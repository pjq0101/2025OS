#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>
#include <pthread.h>

#define PAGE_SIZE 4096           // 页大小，通常为4KB
#define MAX_NUMNODES 1           // 最大NUMA节点数，简化版本设为1
#define SLAB_CACHE_DMA 0x0001    // DMA内存标志位
#define GFP_KERNEL 0             // 内核内存分配标志

// 数据类型定义
typedef unsigned long gfp_t;     // 内存分配标志类型
typedef pthread_spinlock_t spinlock_t; // 自旋锁类型

// 双向链表结构，用于管理各种链表
struct list_head {
    struct list_head* next, * prev; // 前向和后向指针
};

// 页结构，表示一个内存页，用于SLUB分配
struct page {
    struct list_head list;       // 用于链接到各种链表
    void* freelist;              // 指向当前页中空闲对象链表的头指针
    int inuse;                   // 当前页中已使用的对象数量
    int objects;                 // 当前页中总的对象数量
    void* s_mem;                 // 指向页中实际内存的起始地址
    struct page* next;           // 指向下一个页的指针（用于简单链表）
};

// 订单和对象数编码结构，将订单和对象数打包在一个整数中
struct kmem_cache_order_objects {
    unsigned int x;              // 高16位存储订单，低16位存储对象数
};

// 每CPU结构，每个CPU核心都有自己的缓存，减少锁竞争
struct kmem_cache_cpu {
    void** freelist;             // 指向当前CPU的空闲对象链表
    unsigned long tid;           // 事务ID，用于检测并发冲突
    struct page* page;           // 当前CPU正在使用的页
    struct page* partial;        // 当前CPU的部分空页链表
};

// 节点结构，用于NUMA架构，管理每个节点的部分空页
struct kmem_cache_node {
    spinlock_t list_lock;        // 保护partial链表的自旋锁
    unsigned long nr_partial;    // 节点中部分空页的数量
    struct list_head partial;    // 节点部分空页的双向链表
};

// 主缓存结构，管理特定大小的对象分配
struct kmem_cache {
    struct kmem_cache_cpu* cpu_slab;  // 每CPU slab信息，指向CPU缓存结构
    unsigned long flags;              // 缓存标志位，如DMA标志等
    unsigned long min_partial;        // 最小partial链表数，保持的最小部分空页数
    int size;                         // 对象大小（包含对齐填充后的实际大小）
    int object_size;                  // 用户请求的实际对象大小
    int offset;                       // 空闲指针在对象中的偏移量
    int cpu_partial;                  // 每CPU partial对象数限制
    struct kmem_cache_order_objects oo; // 订单和对象数编码

    // 排序后的大小信息
    struct kmem_cache_order_objects max; // 最大订单和对象数
    struct kmem_cache_order_objects min; // 最小订单和对象数
    gfp_t allocflags;                 // 分配标志，传递给底层页分配器
    int refcount;                     // 引用计数，跟踪缓存的使用情况
    void (*ctor)(void*);             // 构造函数，在分配对象时调用
    int inuse;                        // 使用中的偏移，对象实际使用的大小
    int align;                        // 对齐要求
    const char* name;                 // 缓存名称，用于标识
    struct list_head list;            // 缓存链表，链接所有缓存
    struct kmem_cache_node* node[MAX_NUMNODES]; // 每个NUMA节点的管理数据
};

// 全局缓存链表，管理所有创建的缓存
static struct list_head cache_list;
// 全局缓存互斥锁，保护缓存链表的访问
static pthread_mutex_t cache_mutex = PTHREAD_MUTEX_INITIALIZER;

// 列表操作函数

/**
 * 初始化链表头
 * @param list 要初始化的链表头
 */
static inline void INIT_LIST_HEAD(struct list_head* list)
{
    list->next = list->prev = list; // 循环链表，指向自己
}

/**
 * 在链表头部添加新节点
 * @param new 要添加的新节点
 * @param head 链表头
 */
static inline void list_add(struct list_head* new, struct list_head* head)
{
    new->next = head->next;      // 新节点指向原第一个节点
    new->prev = head;            // 新节点前向指向头节点
    head->next->prev = new;      // 原第一个节点前向指向新节点
    head->next = new;            // 头节点指向新节点
}

/**
 * 从链表中删除节点
 * @param entry 要删除的节点
 */
static inline void list_del(struct list_head* entry)
{
    entry->next->prev = entry->prev; // 后继节点的前向指针指向当前节点的前驱
    entry->prev->next = entry->next; // 前驱节点的后继指针指向当前节点的后继
    entry->next = entry->prev = NULL; // 清空当前节点的指针
}

/**
 * 检查链表是否为空
 * @param head 链表头
 * @return 1为空，0为非空
 */
static inline int list_empty(const struct list_head* head)
{
    return head->next == head;   // 如果头节点指向自己，则为空
}

// 链表遍历宏定义

/**
 * 通过成员指针获取包含该成员的结构体指针
 */
#define list_entry(ptr, type, member) \
    container_of(ptr, type, member)

/**
 * 遍历链表中的每个元素
 * @param pos 当前位置指针
 * @param head 链表头
 * @param member 链表成员在结构体中的名称
 */
#define list_for_each_entry(pos, head, member) \
    for (pos = list_entry((head)->next, typeof(*pos), member); \
         &pos->member != (head); \
         pos = list_entry(pos->member.next, typeof(*pos), member))

/**
 * 安全遍历链表（可在遍历时删除元素）
 * @param pos 当前位置指针
 * @param n 下一个位置临时指针
 * @param head 链表头
 */
#define list_for_each_safe(pos, n, head) \
    for (pos = (head)->next, n = pos->next; pos != (head); \
         pos = n, n = pos->next)

/**
 * 通过成员指针获取包含该成员的结构体指针的实现
 */
#define container_of(ptr, type, member) ({ \
    const typeof(((type *)0)->member) *__mptr = (ptr); \
    (type *)((char *)__mptr - offsetof(type, member)); })

/**
 * 计算结构体成员偏移量
 */
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)

// 页分配函数

/**
 * 分配指定订单的连续页
 * @param flags 分配标志
 * @param order 订单，2^order个页
 * @return 成功返回页结构指针，失败返回NULL
 */
static struct page* alloc_pages(gfp_t flags, int order)
{
    size_t size = (1 << order) * PAGE_SIZE; // 计算总大小
    void* addr = aligned_alloc(PAGE_SIZE, size); // 按页大小对齐分配
    if (!addr) return NULL;

    struct page* page = malloc(sizeof(struct page));
    if (!page) {
        free(addr);
        return NULL;
    }

    memset(page, 0, sizeof(*page));
    page->s_mem = addr;          // 保存分配的内存地址
    INIT_LIST_HEAD(&page->list); // 初始化页的链表节点
    return page;
}

/**
 * 释放页结构及其关联的内存
 * @param page 要释放的页
 */
static void free_pages(struct page* page)
{
    if (page && page->s_mem) {
        free(page->s_mem);       // 释放实际内存
    }
    free(page);                  // 释放页结构本身
}

// 计算最佳order和对象数

/**
 * 计算最适合的订单和每页对象数
 * @param size 对象大小
 * @return 编码后的订单和对象数
 */
static unsigned int calculate_order(int size)
{
    unsigned int order;
    unsigned int min_objects = 4; // 每页最少对象数

    // 从最小订单开始尝试，找到能容纳足够多对象的合适订单
    for (order = 0; order <= 10; order++) {
        unsigned int slab_size = (1 << order) * PAGE_SIZE; // 计算slab大小
        unsigned int num_objects = (slab_size - sizeof(struct page)) / size; // 计算对象数

        if (num_objects >= min_objects) {
            return (order << 16) | num_objects; // 高16位存订单，低16位存对象数
        }
    }

    // 如果找不到合适的，使用最大订单作为fallback
    return (10 << 16) | ((PAGE_SIZE << 10) / size);
}

// 初始化slab页

/**
 * 初始化新分配的slab页
 * @param cache 所属的缓存
 * @param page 要初始化的页
 */
static void init_slab_page(struct kmem_cache* cache, struct page* page)
{
    unsigned int order = cache->oo.x >> 16;        // 提取订单
    unsigned int num_objects = cache->oo.x & 0xffff; // 提取对象数

    void* start = page->s_mem;                     // 页内存起始地址
    void* end = start + (1 << order) * PAGE_SIZE;  // 页内存结束地址
    void** freelist = NULL;                        // 空闲链表头

    // 构建空闲对象链表（逆序构建）
    for (unsigned int i = 0; i < num_objects; i++) {
        void* obj = start + i * cache->size;       // 计算对象地址
        *(void**)obj = freelist;                   // 在当前对象中存储下一个空闲对象的地址
        freelist = obj;                            // 更新链表头
    }

    page->freelist = freelist;   // 设置页的空闲链表头
    page->objects = num_objects; // 记录总对象数
    page->inuse = 0;             // 初始时没有对象被使用
}

// 创建缓存

/**
 * 创建新的SLUB缓存
 * @param name 缓存名称
 * @param size 对象大小
 * @param align 对齐要求
 * @param flags 缓存标志
 * @param ctor 构造函数
 * @return 成功返回缓存指针，失败返回NULL
 */
struct kmem_cache* kmem_cache_create(const char* name, int size, int align,
    unsigned long flags, void (*ctor)(void*))
{
    struct kmem_cache* cache = malloc(sizeof(*cache));
    if (!cache) return NULL;

    memset(cache, 0, sizeof(*cache));

    // 初始化基本字段
    cache->name = strdup(name);  // 复制缓存名称
    cache->object_size = size;   // 用户请求的对象大小
    cache->size = (size + sizeof(void*) - 1) & ~(sizeof(void*) - 1); // 对齐后的实际大小
    if (cache->size < sizeof(void*)) cache->size = sizeof(void*); // 最小为指针大小

    cache->align = align;
    cache->ctor = ctor;
    cache->flags = flags;
    cache->refcount = 1;
    cache->inuse = cache->size;

    // 计算最佳订单和对象数
    cache->oo.x = calculate_order(cache->size);
    cache->min = cache->max = cache->oo;

    // 初始化每CPU数据
    cache->cpu_slab = malloc(sizeof(struct kmem_cache_cpu));
    if (!cache->cpu_slab) {
        free((void*)cache->name);
        free(cache);
        return NULL;
    }
    memset(cache->cpu_slab, 0, sizeof(struct kmem_cache_cpu));

    // 初始化节点数据（简化版本只使用一个节点）
    for (int i = 0; i < MAX_NUMNODES; i++) {
        cache->node[i] = malloc(sizeof(struct kmem_cache_node));
        if (!cache->node[i]) {
            // 清理已分配的内存
            for (int j = 0; j < i; j++) free(cache->node[j]);
            free(cache->cpu_slab);
            free((void*)cache->name);
            free(cache);
            return NULL;
        }
        pthread_spin_init(&cache->node[i]->list_lock, PTHREAD_PROCESS_PRIVATE);
        cache->node[i]->nr_partial = 0;
        INIT_LIST_HEAD(&cache->node[i]->partial);
    }

    // 设置其他参数
    cache->min_partial = 5;      // 最小保持的部分空页数
    cache->cpu_partial = 30;     // 每CPU部分空页限制
    cache->offset = 0;           // 空闲指针偏移（简化版本设为0）
    cache->allocflags = GFP_KERNEL;

    // 将新缓存添加到全局缓存链表
    pthread_mutex_lock(&cache_mutex);
    INIT_LIST_HEAD(&cache->list);
    list_add(&cache->list, &cache_list);
    pthread_mutex_unlock(&cache_mutex);

    printf("Created cache '%s': size=%d, object_size=%d, order=%u, objects=%u\n",
        name, cache->size, cache->object_size,
        cache->oo.x >> 16, cache->oo.x & 0xffff);

    return cache;
}

// 分配对象

/**
 * 从缓存中分配一个对象
 * @param cache 目标缓存
 * @param flags 分配标志
 * @return 成功返回对象指针，失败返回NULL
 */
void* kmem_cache_alloc(struct kmem_cache* cache, gfp_t flags)
{
    struct kmem_cache_cpu* c = cache->cpu_slab;
    void* object = NULL;

    // 1. 从CPU当前页分配（当前CPU使用的slab缓冲区有多余的空闲对象）
    if (c->page && c->page->freelist) {
        object = c->page->freelist;
        c->page->freelist = *(void**)object;
        c->page->inuse++;
        if (cache->ctor) cache->ctor(object);
        return object;
    }

    // 2. 从CPU partial链表分配（CPU部分空slab链表不为空）
    if (c->partial) {
        // 将当前满slab移除（如果有的话）
        if (c->page && c->page->inuse == c->page->objects) {
            // 当前slab已满，需要移除（简化实现）
            struct kmem_cache_node* n = cache->node[0];
            pthread_spin_lock(&n->list_lock);
            list_add(&c->page->list, &n->partial);
            n->nr_partial++;
            pthread_spin_unlock(&n->list_lock);
        }
        
        // 从CPU partial获取新slab
        c->page = c->partial;
        c->partial = c->partial->next;
        c->page->next = NULL;

        object = c->page->freelist;
        c->page->freelist = *(void**)object;
        c->page->inuse++;
        if (cache->ctor) cache->ctor(object);
        return object;
    }

    // 3. 从节点partial链表批量获取（CPU部分空slab链表为空）
    struct kmem_cache_node* n = cache->node[0];
    pthread_spin_lock(&n->list_lock);

    if (!list_empty(&n->partial)) {
        // 批量获取：直到满足cpu_partial条件
        int target_free_objects = cache->cpu_partial / 2;
        int current_free_objects = 0;
        
        // 批量转移slab从节点到CPU partial
        while (!list_empty(&n->partial) && current_free_objects < target_free_objects) {
            struct page* page = list_entry(n->partial.next, struct page, list);
            list_del(&page->list);
            n->nr_partial--;
            
            // 计算这个slab的空闲对象数
            int slab_free_objects = page->objects - page->inuse;
            current_free_objects += slab_free_objects;
            
            // 添加到CPU partial链表
            page->next = c->partial;
            c->partial = page;
        }
        
        pthread_spin_unlock(&n->list_lock);
        
        // 现在CPU partial不为空了，递归调用自己
        return kmem_cache_alloc(cache, flags);
    }

    pthread_spin_unlock(&n->list_lock);

    // 4. 分配新slab页（所有资源全部耗尽）
    unsigned int order = cache->oo.x >> 16;
    struct page* page = alloc_pages(flags, order);
    if (!page) return NULL;

    init_slab_page(cache, page);
    
    // 如果有当前页且是满的，移到节点
    if (c->page && c->page->inuse == c->page->objects) {
        pthread_spin_lock(&n->list_lock);
        list_add(&c->page->list, &n->partial);
        n->nr_partial++;
        pthread_spin_unlock(&n->list_lock);
    }
    
    c->page = page;
    object = page->freelist;
    page->freelist = *(void**)object;
    page->inuse++;

    if (cache->ctor) cache->ctor(object);
    return object;
}

// 释放对象

/**
 * 释放对象回缓存
 * @param cache 目标缓存
 * @param object 要释放的对象指针
 */
void kmem_cache_free(struct kmem_cache* cache, void* object)
{
    if (!object) return;

    struct kmem_cache_cpu* c = cache->cpu_slab;
    struct kmem_cache_node* n = cache->node[0];

    // 检查对象是否属于当前CPU页
    if (c->page && object >= c->page->s_mem &&
        object < c->page->s_mem + (1 << (cache->oo.x >> 16)) * PAGE_SIZE) {

        // 快速路径：放回CPU freelist
        *(void**)object = c->freelist;           // 将对象插入freelist头部
        c->freelist = object;
        c->page->inuse--;                        // 减少页的使用计数

        // 如果页变空，考虑释放
        if (c->page->inuse == 0) {
            free_pages(c->page);                 // 释放空页
            c->page = NULL;
        }
        // 如果页使用率低，移到节点partial链表
        else if (c->page->inuse < c->page->objects / 2) {
            pthread_spin_lock(&n->list_lock);
            list_add(&c->page->list, &n->partial); // 添加到节点partial链表
            n->nr_partial++;
            pthread_spin_unlock(&n->list_lock);
            c->page = NULL;                      // 清空当前CPU页
        }
    }
    else {
        // 慢速路径：对象不属于当前CPU页，直接放回freelist
        *(void**)object = c->freelist;
        c->freelist = object;
    }
}

// 销毁缓存

/**
 * 销毁缓存并释放所有相关资源
 * @param cache 要销毁的缓存
 */
void kmem_cache_destroy(struct kmem_cache* cache)
{
    if (!cache) return;

    printf("Destroying cache '%s'\n", cache->name);

    // 从全局列表移除
    pthread_mutex_lock(&cache_mutex);
    list_del(&cache->list);
    pthread_mutex_unlock(&cache_mutex);

    // 释放节点partial链表中的所有页
    for (int i = 0; i < MAX_NUMNODES; i++) {
        if (cache->node[i]) {
            struct list_head* pos, * n;
            struct list_head* partial_list = &cache->node[i]->partial;

            // 安全遍历并释放所有部分空页
            list_for_each_safe(pos, n, partial_list) {
                struct page* page = list_entry(pos, struct page, list);
                list_del(&page->list);           // 从链表中移除
                free_pages(page);                // 释放页
            }
            pthread_spin_destroy(&cache->node[i]->list_lock); // 销毁自旋锁
            free(cache->node[i]);                // 释放节点结构
        }
    }

    // 释放CPU数据
    if (cache->cpu_slab) {
        if (cache->cpu_slab->page) free_pages(cache->cpu_slab->page);
        // 释放CPU partial链表
        struct page* partial = cache->cpu_slab->partial;
        while (partial) {
            struct page* next = partial->next;
            free_pages(partial);
            partial = next;
        }
        free(cache->cpu_slab);                   // 释放CPU结构
    }

    free((void*)cache->name);                    // 释放缓存名称
    free(cache);                                 // 释放缓存结构
}

// 显示缓存状态

/**
 * 显示缓存的统计信息
 * @param cache 目标缓存
 */
void kmem_cache_stats(struct kmem_cache* cache)
{
    printf("Cache '%s' stats:\n", cache->name);
    printf("  Object size: %d, Slab size: %d\n", cache->object_size, cache->size);
    printf("  Order: %u, Objects per slab: %u\n",
        cache->oo.x >> 16, cache->oo.x & 0xffff);
    printf("  CPU page inuse: %d\n",
        cache->cpu_slab->page ? cache->cpu_slab->page->inuse : 0);
    printf("  Node partial slabs: %lu\n", cache->node[0]->nr_partial);
}


// 测试函数
void test_kmem_cache(void)
{

    // 创建缓存
    struct kmem_cache* cache = kmem_cache_create("test_objects", 64, 0, 0, NULL);
    assert(cache != NULL);

    kmem_cache_stats(cache);

    // 测试分配功能
    void* obj1 = kmem_cache_alloc(cache, GFP_KERNEL);
    void* obj2 = kmem_cache_alloc(cache, GFP_KERNEL);
    void* obj3 = kmem_cache_alloc(cache, GFP_KERNEL);

    printf("分配对象: %p, %p, %p\n", obj1, obj2, obj3);
    assert(obj1 != NULL && obj2 != NULL && obj3 != NULL);

    kmem_cache_stats(cache);

    // 测试内存写入和验证
    memset(obj1, 0xAA, 64);
    memset(obj2, 0xBB, 64);
    memset(obj3, 0xCC, 64);

    assert(*(unsigned char*)obj1 == 0xAA);
    assert(*(unsigned char*)obj2 == 0xBB);
    assert(*(unsigned char*)obj3 == 0xCC);

    // 测试释放功能
    kmem_cache_free(cache, obj1);
    kmem_cache_free(cache, obj2);
    kmem_cache_free(cache, obj3);

    kmem_cache_stats(cache);

    // 测试对象重用
    void* obj4 = kmem_cache_alloc(cache, GFP_KERNEL);
    printf("重用对象: %p\n", obj4);
    assert(obj4 != NULL);

    kmem_cache_free(cache, obj4);

    // 性能测试：大量分配和释放
    const int NUM_ALLOCS = 100;
    void* objects[NUM_ALLOCS];

    printf("性能测试: 分配和释放 %d 个对象\n", NUM_ALLOCS);
    for (int i = 0; i < NUM_ALLOCS; i++) {
        objects[i] = kmem_cache_alloc(cache, GFP_KERNEL);
        assert(objects[i] != NULL);
    }

    for (int i = 0; i < NUM_ALLOCS; i++) {
        kmem_cache_free(cache, objects[i]);
    }

    kmem_cache_stats(cache);
    kmem_cache_destroy(cache);
}

int main()
{
    // 初始化全局缓存列表
    INIT_LIST_HEAD(&cache_list);

    test_kmem_cache();
    return 0;
}
