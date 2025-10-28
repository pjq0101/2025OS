#include <pmm.h>
#include <list.h>
#include <string.h>
#include <default_pmm.h>
#include <stdio.h>
#include <assert.h>

// 显示当前伙伴系统空闲链表数组的状态
static void show_buddy_array(int start_order, int end_order) {
    cprintf("---- free lists ----\n");
    for (int i = start_order; i <= end_order; i++) {
        if (!list_empty(&buddy_array[i].free_list)) {
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
        }
    }
    cprintf("---- end ----\n");
}

// 测试简单请求和释放操作
static void buddy_system_check_easy_alloc_and_free_condition(void) {
    cprintf("CHECK EASY ALLOC:\n");
    cprintf("nr_free=%d\n", nr_free);
    
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
    
    cprintf("p0 alloc 15 pages\n");
    p0 = alloc_pages(15);
    show_buddy_array(0, MAX_ORDER - 1);
    
    cprintf("p1 alloc 30 pages\n");
    p1 = alloc_pages(30);
    show_buddy_array(0, MAX_ORDER - 1);
    
    cprintf("p2 alloc 70 pages\n");
    p2 = alloc_pages(70);
    show_buddy_array(0, MAX_ORDER - 1);
    
    cprintf("p0=0x%016lx\n", p0);
    cprintf("p1=0x%016lx\n", p1);
    cprintf("p2=0x%016lx\n", p2);
    
    assert(p0 != p1 && p0 != p2 && p1 != p2);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
    assert(page2pa(p0) < npage * PGSIZE);
    assert(page2pa(p1) < npage * PGSIZE);
    assert(page2pa(p2) < npage * PGSIZE);
    
    cprintf("CHECK EASY FREE:\n");
    cprintf("free p0...\n");
    free_pages(p0, 15);
    cprintf("after free p0, nr_free=%d\n", nr_free);
    show_buddy_array(0, MAX_ORDER - 1);
    
    cprintf("free p1...\n");
    free_pages(p1, 30);
    cprintf("after free p1, nr_free=%d\n", nr_free);
    show_buddy_array(0, MAX_ORDER - 1);
    
    cprintf("free p2...\n");
    free_pages(p2, 70);
    cprintf("after free p2, nr_free=%d\n", nr_free);
    show_buddy_array(0, MAX_ORDER - 1);
}

// 测试复杂请求和释放操作
static void buddy_system_check_difficult_alloc_and_free_condition(void) {
    cprintf("CHECK DIFFICULT ALLOC:\n");
    cprintf("nr_free=%d\n", nr_free);
    
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
    
    cprintf("p0 alloc 15 pages\n");
    p0 = alloc_pages(15);
    show_buddy_array(0, MAX_ORDER - 1);
    
    cprintf("p1 alloc 30 pages\n");
    p1 = alloc_pages(30);
    show_buddy_array(0, MAX_ORDER - 1);
    
    cprintf("p2 alloc 70 pages\n");
    p2 = alloc_pages(70);
    show_buddy_array(0, MAX_ORDER - 1);
    
    cprintf("p0=0x%016lx\n", p0);
    cprintf("p1=0x%016lx\n", p1);
    cprintf("p2=0x%016lx\n", p2);
    
    assert(p0 != p1 && p0 != p2 && p1 != p2);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
    assert(page2pa(p0) < npage * PGSIZE);
    assert(page2pa(p1) < npage * PGSIZE);
    assert(page2pa(p2) < npage * PGSIZE);
    
    cprintf("CHECK DIFFICULT FREE:\n");
    cprintf("free p0...\n");
    free_pages(p0, 15);
    cprintf("after free p0, nr_free=%d\n", nr_free);
    show_buddy_array(0, MAX_ORDER - 1);
    
    cprintf("free p1...\n");
    free_pages(p1, 30);
    cprintf("after free p1, nr_free=%d\n", nr_free);
    show_buddy_array(0, MAX_ORDER - 1);
    
    cprintf("free p2...\n");
    free_pages(p2, 70);
    cprintf("after free p2, nr_free=%d\n", nr_free);
    show_buddy_array(0, MAX_ORDER - 1);
}

// 测试请求和释放最小单元操作
static void buddy_system_check_min_alloc_and_free_condition(void) {
    cprintf("CHECK MIN ALLOC:\n");
    cprintf("nr_free=%d\n", nr_free);
    
    struct Page *p3 = alloc_pages(1);
    cprintf("alloc p3 (1 page)\n");
    show_buddy_array(0, MAX_ORDER - 1);
    
    cprintf("p3=0x%016lx\n", p3);
    assert(p3 != NULL);
    assert(page_ref(p3) == 0);
    assert(page2pa(p3) < npage * PGSIZE);
    
    cprintf("free p3...\n");
    free_pages(p3, 1);
    cprintf("after free p3, nr_free=%d\n", nr_free);
    show_buddy_array(0, MAX_ORDER - 1);
}

// 测试请求和释放最大单元操作
static void buddy_system_check_max_alloc_and_free_condition(void) {
    cprintf("CHECK MAX ALLOC:\n");
    cprintf("nr_free=%d\n", nr_free);
    
    // 计算最大可分配的页数
    size_t max_pages = 1 << (MAX_ORDER - 1);
    cprintf("try alloc max block: %d pages\n", max_pages);
    
    struct Page *p4 = alloc_pages(max_pages);
    if (p4 != NULL) {
        cprintf("p4=0x%016lx\n", p4);
        assert(page_ref(p4) == 0);
        assert(page2pa(p4) < npage * PGSIZE);
        
        cprintf("after alloc p4:\n");
        show_buddy_array(0, MAX_ORDER - 1);
        
        cprintf("free p4...\n");
        free_pages(p4, max_pages);
        cprintf("after free p4, nr_free=%d\n", nr_free);
        show_buddy_array(0, MAX_ORDER - 1);
    } else {
        cprintf("no free blocks\n");
    }
}

// 最终检测函数
static void buddy_system_check(void) {
    cprintf("BEGIN BUDDY TEST\n");
    buddy_system_check_easy_alloc_and_free_condition();
    buddy_system_check_min_alloc_and_free_condition();
    buddy_system_check_max_alloc_and_free_condition();
    buddy_system_check_difficult_alloc_and_free_condition();
    cprintf("BUDDY TEST COMPLETED\n");
}

// 导出测试函数供外部调用
void run_buddy_system_test(void) {
    buddy_system_check();
}


