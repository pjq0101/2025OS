#ifndef __KERN_MM_DEFAULT_PMM_H__ 
#define  __KERN_MM_DEFAULT_PMM_H__

#include <pmm.h>

// Buddy System 数据结构和函数声明
// 注意：free_area_t 和 MAX_ORDER 已在 memlayout.h 中定义

// Buddy System 相关函数声明
extern free_area_t buddy_array[MAX_ORDER];  // Buddy System 的空闲块数组
extern unsigned int nr_free;  // 当前空闲页块的总数量

// 初始化 Buddy System
void buddy_system_init(void);

// 分配页面
struct Page *buddy_system_alloc_pages(size_t requested_pages);

// 释放页面
void buddy_system_free_pages(struct Page *base, size_t n);

// 获取空闲页的数量
size_t buddy_system_nr_free_pages(void);

// 伙伴获取函数
struct Page *get_buddy(struct Page *base, int order);

// 伙伴系统内存管理器
extern const struct pmm_manager buddy_pmm_manager;

// 测试函数声明
void run_buddy_system_test(void);

#endif /* ! __KERN_MM_DEFAULT_PMM_H__ */

