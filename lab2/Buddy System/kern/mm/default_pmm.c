#include <pmm.h> 
#include <list.h>
#include <string.h>
#include <stdio.h>
#include <default_pmm.h>

// 使用memlayout.h中定义的free_area_t，不需要重复定义
// 全局变量声明
free_area_t buddy_array[MAX_ORDER];
unsigned int nr_free = 0;

// 最大块的阶数已在memlayout.h中定义，这里不需要重复定义

// 初始化 Buddy System
void buddy_system_init(void) {
    for (int i = 0; i < MAX_ORDER; i++) {
        list_init(&buddy_array[i].free_list);
        buddy_array[i].nr_free = 0;
    }
    nr_free = 0;
}

// 获取一个大小为 2^order 的块的伙伴：必须基于“页索引”做异或
struct Page *get_buddy(struct Page *base, int order) {
    size_t base_index = (size_t)(base - pages);
    size_t buddy_index = base_index ^ (1UL << order);
    return pages + buddy_index;
}

// 向 Buddy System 中添加空闲页块
static void buddy_system_add_free_page(struct Page *page, int order) {
    list_add(&(page->page_link), &buddy_array[order].free_list);
    buddy_array[order].nr_free++;
}

// 分配一个给定大小的内存块（向上按 2 的幂对齐）
struct Page *buddy_system_alloc_pages(size_t requested_pages) {
    // 目标阶数：满足 2^order >= requested_pages 的最小 order
    int target_order = 0;
    size_t adjusted_pages = 1;
    while (adjusted_pages < requested_pages && target_order < MAX_ORDER) {
        adjusted_pages <<= 1;
        target_order++;
    }

    // 在 >= target_order 的阶级中寻找可用块
    int found_order = target_order;
    while (found_order < MAX_ORDER && list_empty(&(buddy_array[found_order].free_list))) {
        found_order++;
    }
    if (found_order >= MAX_ORDER) {
        return NULL; // 无可用块
    }

    // 取出一个较大的块
    struct Page *allocated_page = le2page(list_next(&(buddy_array[found_order].free_list)), page_link);
    list_del(&(allocated_page->page_link));
    buddy_array[found_order].nr_free--;

    // 自顶向下拆分到 target_order
    while (found_order > target_order) {
        found_order--;
        struct Page *buddy_page = allocated_page + (1 << found_order);
        buddy_page->property = (1 << found_order);
        SetPageProperty(buddy_page);
        list_add(&(buddy_array[found_order].free_list), &(buddy_page->page_link));
        buddy_array[found_order].nr_free++;
    }

    // 分配出去的块头清标志
    ClearPageProperty(allocated_page);
    allocated_page->property = 0;

    // nr_free 按实际分配块大小减少（2^target_order）
    nr_free -= (1U << target_order);
    return allocated_page;
}

// 释放内存块，并尝试合并空闲块
void buddy_system_free_pages(struct Page *base, size_t n) {
    // 释放时也按向上 2 的幂对齐到阶数
    int order = 0;
    size_t block_pages = 1;
    while (block_pages < n && order < MAX_ORDER) {
        block_pages <<= 1;
        order++;
    }

    cprintf("Buddy System算法将释放第NO.%d页开始的共%d页\n", page2ppn(base), (int)n);

    // 尝试自底向上合并
    while (order < MAX_ORDER) {
        struct Page *buddy = get_buddy(base, order);
        if (buddy >= pages && buddy < pages + npage && PageProperty(buddy) && buddy->property == (1U << order)) {
            // 确保较小地址作为合并后的头
            if (base > buddy) {
                struct Page *tmp = base;
                base = buddy;
                buddy = tmp;
            }
            list_del(&(buddy->page_link));
            buddy_array[order].nr_free--;
            // 合并成更高一阶
            order++;
        } else {
            // 无法继续合并，插入当前阶链表
            base->property = (1U << order);
            SetPageProperty(base);
            list_add(&(buddy_array[order].free_list), &(base->page_link));
            buddy_array[order].nr_free++;
            break;
        }
    }

    // nr_free 按实际归还块大小增加
    nr_free += (1U << order);
}

// 初始化内存块映射（将内存页加入伙伴系统）
static void default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p++) {
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }

    // 将区间 [base, base+n) 切分为按对齐的 2^k 块逐一入表
    struct Page *pos = base;
    size_t remain = n;
    while (remain > 0) {
        // 当前位置到 pages 的索引
        size_t idx = (size_t)(pos - pages);
        // 计算在该位置允许的最大对齐阶（保证 idx 对齐到 2^k）
        int max_align_order = 0;
        while (((idx & (1UL << max_align_order)) == 0) && max_align_order < (MAX_ORDER - 1)) {
            max_align_order++;
        }
        if (max_align_order > 0) max_align_order--; // 回退到满足对齐的最大阶

        // 同时受剩余页数限制
        int size_limit_order = 0;
        while (((1UL << size_limit_order) << 1) <= remain && size_limit_order < (MAX_ORDER - 1)) {
            size_limit_order++;
        }

        int use_order = max_align_order < size_limit_order ? max_align_order : size_limit_order;
        size_t blk_pages = (1UL << use_order);

        pos->property = blk_pages;
        SetPageProperty(pos);
        list_add(&(buddy_array[use_order].free_list), &(pos->page_link));
        buddy_array[use_order].nr_free++;

        pos += blk_pages;
        remain -= blk_pages;
        nr_free += blk_pages;
    }

    cprintf("初始化内存块: %d页 已拆分入表\n", (int)n);
}

// 获取空闲页的数量
size_t buddy_system_nr_free_pages(void) {
    return nr_free;
}

// 功能检测函数
static void basic_check(void) {
    cprintf("开始基本功能检测...\n");
    
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
    
    // 测试基本分配功能
    cprintf("测试分配3页...\n");
    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);
    assert((p2 = alloc_page()) != NULL);

    assert(p0 != p1 && p0 != p2 && p1 != p2);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);

    assert(page2pa(p0) < npage * PGSIZE);
    assert(page2pa(p1) < npage * PGSIZE);
    assert(page2pa(p2) < npage * PGSIZE);

    // 测试释放功能
    cprintf("测试释放3页...\n");
    free_page(p0);
    free_page(p1);
    free_page(p2);
    
    cprintf("基本功能检测完成!\n");
}

// Buddy System 管理器接口
const struct pmm_manager buddy_pmm_manager = {
    .name = "buddy_pmm_manager",
    .init = buddy_system_init,
    .init_memmap = default_init_memmap,
    .alloc_pages = buddy_system_alloc_pages,
    .free_pages = buddy_system_free_pages,
    .nr_free_pages = buddy_system_nr_free_pages,
    .check = basic_check,
};

