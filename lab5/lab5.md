## 练习1: 加载应用程序并执行（需要编码）

### 实现过程

我需要补充`load_icode`函数的第6步。以下是需要编写的代码：

```
//(6) setup trapframe for user environment
struct trapframe *tf = current->tf;
// Keep sstatus
uintptr_t sstatus = tf->status;
memset(tf, 0, sizeof(struct trapframe));
/* LAB5:EXERCISE1 YOUR CODE
* should set tf->gpr.sp, tf->epc, tf->status
* NOTICE: If we set trapframe correctly, then the user level process can return to USER MODE from kernel. So
* tf->gpr.sp should be user stack top (the value of sp)
* tf->epc should be entry point of user program (the value of sepc)
* tf->status should be appropriate for user program (the value of sstatus)
* hint: check meaning of SPP, SPIE in SSTATUS, use them by SSTATUS_SPP, SSTATUS_SPIE(defined in risv.h)
*/
// 设置用户栈指针：USTACKTOP是用户栈的顶部地址
tf->gpr.sp = USTACKTOP;
// 设置程序计数器：ELF入口地址
tf->epc = elf->e_entry;
// 设置状态寄存器：
// - SPP位清0，表示从用户态返回（U-mode）
// - SPIE位置1，表示在用户态启用中断
// - 继承之前的sstatus寄存器的其他位
tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
// 设置a0寄存器为0（作为main函数的返回值）
tf->gpr.a0 = 0;
ret = 0;
```

##### 设计实现过程说明

实验需要设置用户态进程的`trapframe`，使其能从内核态正确返回到用户态。需要设置正确的栈指针、程序计数器和处理器状态。

对此：

**用户栈指针 `(tf->gpr.sp)`**：设置为`USTACKTOP`，这是用户栈的顶部地址。

**程序计数器 `(tf->epc)`**：设置为ELF文件的入口地址`elf->e_entry`，这是应用程序的第一条指令地址。

**状态寄存器 `(tf->status)`**：清除SPP位以确保从用户态返回。设置`SPIE`位以在用户态启用中断。保留其他状态位不变。

额外将`a0`寄存器设置为0，作为`main`函数的返回值（`argc`参数）。



### 问题回答

##### 用户态进程执行过程描述

**①进程被调度**

调度器选择该用户进程为RUNNING态。

调用`proc_run`切换到该进程的上下文。

**②上下文恢复**

`proc_run`加载进程的页目录表到`satp`寄存器。

切换到进程的内核栈。

通过`switch_to`恢复进程的上下文。

**③中断返回**

在`forkret`中调用`forkrets`，最终通过`sret`指令返回用户态。

`sret`指令根据`trapframe->status`的SPP位判断返回的特权级。

由于SPP=0，CPU返回用户态(U-mode)。

**④开始执行用户程序**

PC寄存器被设置为`trapframe->epc`（即`elf->e_entry`）。

栈指针被设置为USTACKTOP。

CPU从应用程序的入口点开始执行第一条指令。

a0寄存器为0，作为main函数的参数。

**⑤进入用户态运行**

应用程序在用户地址空间中运行。

可以响应中断（SPIE=1）。

通过系统调用与内核交互。

整个过程完成了从内核调度用户进程到实际执行用户程序第一条指令的完整切换。



## 练习2: 父进程复制自己的内存空间给子进程（需要编码）

### copy_range函数实现

**设计思路**

copy_range函数的核心任务是逐页复制父进程的内存内容到子进程的地址空间中，其实现要点包括：

1. 遍历父进程地址空间：从start到end逐页处理
2. 获取页表项：使用`get_pte`获取父进程的页表项
3. 分配新物理页：为子进程分配新的物理内存页
4. 复制内存内容：使用`memcpy`复制整个页的内容
5. 建立映射关系：使用page_insert建立子进程的虚拟地址到物理地址的映射

**具体实现代码**

在`kern/mm/pmm.c`中实现copy_range函数：

```
int copy_range(pde_t *to, pde_t *from, uintptr_t start, uintptr_t end,
               bool share)
{
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
    assert(USER_ACCESS(start, end));
    
    // 按页为单位复制内容
    do
    {
        // 根据地址start获取进程A的pte
        pte_t *ptep = get_pte(from, start, 0), *nptep;
        if (ptep == NULL)
        {
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
            continue;
        }
        
        // 获取进程B的pte，如果pte为NULL则分配一个页表
        if (*ptep & PTE_V)
        {
            if ((nptep = get_pte(to, start, 1)) == NULL)
            {
                return -E_NO_MEM;
            }
            
            uint32_t perm = (*ptep & PTE_USER);
            // 从ptep获取页
            struct Page *page = pte2page(*ptep);
            // 为进程B分配一个页
            struct Page *npage = alloc_page();
            assert(page != NULL);
            assert(npage != NULL);
            
            int ret = 0;
            
            /* 实现内容复制和映射建立 */
            
            // (1) 找到src_kvaddr: page的内核虚拟地址
            void *src_kvaddr = page2kva(page);
            
            // (2) 找到dst_kvaddr: npage的内核虚拟地址
            void *dst_kvaddr = page2kva(npage);
            
            // (3) 从src_kvaddr复制内存到dst_kvaddr，大小为PGSIZE
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
            
            // (4) 建立nage的物理地址与线性地址start的映射
            ret = page_insert(to, npage, start, perm);
            
            assert(ret == 0);
        }
        start += PGSIZE;
    } while (start != 0 && start < end);
    
    return 0;
}
```

**参数验证：**

确保起始和结束地址按页对齐

确保地址在用户空间范围内

**循环处理每个页面：**

使用do-while循环遍历[start, end)范围内的每个页面

每次增加PGSIZE（页大小）

**获取父进程页表项：**

使用get_pte(from, start, 0)获取父进程的页表项

如果页表项不存在，跳过当前页表项范围

**检查页面有效性：**

检查页表项是否有效（PTE_V标志位）

获取父进程的物理页：`page = pte2page(*ptep)`

**为子进程分配资源：**

获取子进程的页表项：`get_pte(to, start, 1)`

为子进程分配新的物理页：`npage = alloc_page()`

**复制内存内容：**

将父进程页转换为内核虚拟地址：`src_kvaddr = page2kva(page)`

将子进程页转换为内核虚拟地址：`dst_kvaddr = page2kva(npage)`

使用`memcpy`复制整个页面内容

**建立子进程映射：**

使用page_insert建立子进程的虚拟地址到物理地址的映射

继承父进程的页面权限（主要是用户权限PTE_USER）



### 问题回答：Copy-on-Write机制设计

Copy-on-write（简称COW）的基本概念是指如果有多个使用者对一个资源A（比如内存块）进行读操作，则每个使用者只需获得一个指向同一个资源A的指针，就可以该资源了。若某使用者需要对这个资源A进行写操作，系统会对该资源进行拷贝操作，从而使得该“写操作”使用者获得一个该资源A的“私有”拷贝—资源B，可对资源B进行写操作。该“写操作”使用者对资源B的改变对于其他的使用者而言是不可见的，因为其他使用者看到的还是资源A。

**数据结构修改**：

修改Page结构，增加引用计数`int ref`

**页表项权限调整：**

COW页面在页表项中清除写权限位（PTE_W）

保留读权限和其他权限

**fork时的COW处理：**

复制父进程页表项到子进程

共享的页面增加引用计数

将页表项标记为只读（清除PTE_W）

**写时复制触发：**

进程尝试写入只读的COW页面

触发页错误异常（page fault）

在页错误处理程序中检测COW页面

**COW页面复制：**

如果页面引用计数>1，执行复制

分配新物理页面

复制原页面内容到新页面

更新当前进程的页表项，恢复写权限

减少原页面的引用计数



## 练习3: 阅读分析源代码，理解进程执行 fork/exec/wait/exit 的实现，以及系统调用的实现（不需要编码）

### fork() 函数

**用户态：**

1. 用户程序调用 `fork()` -> `sys_fork()` -> `syscall(SYS_fork)`
2. 执行 `ecall` 进入内核态

**内核态**（`kern/syscall/syscall.c` -> `kern/process/proc.c`）：

1. `sys_fork()` 从当前进程的 `trapframe` 获取用户栈指针
2. 调用 `do_fork(0, stack, tf)` 创建子进程

**do_fork() 的核心步骤**：

1. **分配进程控制块**：`alloc_proc()` 创建新的 proc_struct
2. **设置父子关系**：`proc->parent = current`
3. **分配内核栈**：`setup_kstack()` 为子进程分配内核栈空间
4. **复制内存空间**：`copy_mm()` 复制或共享父进程的内存管理结构
5. **复制执行上下文**：`copy_thread()` 设置子进程的 trapframe 和 context

  \- 复制父进程的 trapframe（包含所有寄存器状态）

  \- 设置子进程的 a0 寄存器为 0（用于区分父子进程）

  \- 设置子进程的返回地址为 `forkret`

6. **分配 PID**：`get_pid()` 为子进程分配唯一标识符
7. **加入进程列表**：`hash_proc()` 和 `set_links()` 将子进程加入管理结构
8. **唤醒子进程**：`wakeup_proc()` 设置子进程状态为 PROC_RUNNABLE
9. **返回子进程 PID**：父进程返回子进程的 PID

**返回用户态**：

父进程：返回子进程的 PID（>0）

子进程：返回 0（通过 `copy_thread()` 设置的 a0=0）

**用户态与内核态操作划分**

\- **用户态**：调用 fork，准备系统调用参数

\- **内核态**：创建进程控制块、分配资源、复制内存空间、设置执行上下文、进程调度



### exec() 函数

**用户态**：

1. 用户程序调用 `exec()` -> `sys_exec()` -> `syscall(SYS_exec, name, len, binary, size)`
2. 执行 `ecall` 进入内核态

**内核态**（`kern/syscall/syscall.c` -> `kern/process/proc.c`）：

1. `sys_exec()` 提取参数（程序名、二进制数据等）
2. 调用 `do_execve(name, len, binary, size)`

**`do_execve()` 的核心步骤**：

1. **验证参数**：检查程序名指针的有效性
2. **释放旧内存空间**：

  \- 如果当前进程有内存管理结构，调用 `exit_mmap()`、`put_pgdir()`、`mm_destroy()` 释放

  \- 设置 `current->mm = NULL`

3. **加载新程序**：`load_icode(binary, size)`

  \- 创建新的内存管理结构 `mm_create()`

  \- 设置新的页目录 `setup_pgdir()`

  \- 解析 ELF 格式文件头

  \- 加载程序段（TEXT、DATA）到内存

  \- 设置 BSS 段

  \- 设置用户栈

  \- **关键**：设置新的 `trapframe`

   \- `tf->gpr.sp = USTACKTOP`（用户栈顶）

   \- `tf->epc = elf->e_entry`（程序入口地址）

   \- `tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE`（用户态标志）

   \- `tf->gpr.a0 = 0`（main 函数的 `argc`）

4. **设置进程名**：`set_proc_name()`
5. **返回 0**：成功执行

**返回用户态**：

\- 通过 `kernel_execve_ret()` 调整 `trapframe`，然后执行 `__trapret`

\- 恢复新的 `trapframe`，跳转到新程序的入口地址（`tf->epc`）

\- **重要**：exec 成功后不会返回到调用 exec 的代码，而是直接执行新程序

**用户态与内核态操作划分**

\- **用户态**：调用 exec，传递程序名和二进制数据

\- **内核态**：释放旧内存、加载新程序、设置新的执行上下文、跳转到新程序入口



###  wait() 函数

**用户态**：

1. 用户程序调用 `wait()` 或 `waitpid()` -> `sys_wait()` -> `syscall(SYS_wait, pid, store)`
2. 执行 `ecall` 进入内核态

**内核态**（`kern/syscall/syscall.c` -> `kern/process/proc.c`）：

1. `sys_wait()` 提取参数（等待的子进程 PID、状态码存储地址）
2. 调用 `do_wait(pid, code_store)`

**do_wait() 的核心步骤**：

1. **验证参数**：检查 code_store 指针的有效性（如果非空）
2. **查找子进程**：

  \- 如果 pid != 0：查找指定 PID 的子进程

  \- 如果 pid == 0：查找任意一个子进程

3. **检查子进程状态**：

  \- 如果找到子进程且状态为 `PROC_ZOMBIE`：跳转到 `found` 标签

  \- 如果有子进程但未处于 ZOMBIE 状态：

   \- 设置当前进程状态为 `PROC_SLEEPING`

   \- 设置等待状态为 `WT_CHILD`

   \- 调用 `schedule()` 让出 CPU，等待子进程退出

   \- 被唤醒后重新检查（`goto repeat`）

4. **清理僵尸进程**（found 标签）：

  \- 如果 code_store 非空，写入子进程的退出码

  \- 从进程列表中移除：`unhash_proc()`、`remove_links()`

  \- 释放内核栈：`put_kstack()`

  \- 释放进程控制块：`kfree(proc)`

5. **返回 0**：成功回收子进程

**返回用户态**：

\- 如果成功：返回 0，code_store 中存储子进程退出码

\- 如果失败：返回错误码（如 -E_BAD_PROC）

**用户态与内核态操作划分**

\- **用户态**：调用 wait，传递要等待的子进程 PID

\- **内核态**：查找子进程、检查状态、进程阻塞/唤醒、清理僵尸进程资源



### exit() 函数

**用户态**：

1. 用户程序调用 `exit(error_code)` -> `sys_exit()` -> `syscall(SYS_exit, error_code)`
2. 执行 `ecall` 进入内核态

**内核态**（`kern/syscall/syscall.c` -> `kern/process/proc.c`）：

1. `sys_exit()` 提取错误码参数
2. 调用 `do_exit(error_code)`

**do_exit() 的核心步骤**：

1. **安全检查**：禁止 `idleproc` 和 `initproc` 退出
2. **释放内存空间**：

  \- 如果进程有内存管理结构：

   \- 切换到内核页目录

   \- 如果引用计数为 0，调用 `exit_mmap()`、`put_pgdir()`、`mm_destroy()` 释放

  \- 设置 `current->mm = NULL`

3. **设置进程状态**：

  \- `current->state = PROC_ZOMBIE`

  \- `current->exit_code = error_code`

4. **处理子进程**：

  \- 将所有子进程的父进程改为 `initproc`

  \- 如果子进程已经是 ZOMBIE 状态且 `initproc` 在等待，唤醒 `initproc`

5. **唤醒父进程**：

  \- 如果父进程的等待状态为 `WT_CHILD`，调用 `wakeup_proc()` 唤醒父进程

6. **调度其他进程**：

  \- 调用 `schedule()` 切换到其他进程

  \- **重要**：exit 后进程不会返回，而是永远停留在调度器中

**返回用户态**：

\- exit 后进程不会返回用户态，而是被调度器切换到其他进程

\- 父进程通过 wait 可以获取子进程的退出码

 **用户态与内核态操作划分**

\- **用户态**：调用 exit，传递退出码

\- **内核态**：释放内存、设置僵尸状态、处理子进程、唤醒父进程、进程调度



### 内核态执行结果返回给用户程序的方式

1. **通过 `trapframe` 的 a0 寄存器**：

  \- 系统调用处理函数将返回值写入 `tf->gpr.a0`

  \- `__trapret` 恢复寄存器时，a0 的值被恢复到用户态

  \- 用户程序的 `syscall()` 函数通过内联汇编读取 a0 的值

2. **通过内存地址**（如 wait 的 code_store）：

  \- 内核直接写入用户态提供的有效内存地址

  \- 需要先通过 `user_mem_check()` 验证地址有效性

3. **通过进程状态**（如 fork 的子进程）：

  \- fork 通过设置子进程 `trapframe` 的 a0=0 来区分父子进程

  \- 子进程从 fork 返回时自动得到 0



### `ucore` 用户态进程执行状态生命周期图

 <img src="D:\lab5\media\用户态进程的执行状态生命周期图.png" alt="用户态进程的执行状态生命周期图" style="zoom:25%;" />

#### 状态说明

1. **PROC_UNINIT（未初始化）**

  \- 进程刚被 `alloc_proc()` 创建时的状态

  \- 转换事件：

   \- `proc_init()` 或 `wakeup_proc()` -> PROC_RUNNABLE

2. **PROC_RUNNABLE（可运行）**

  \- 进程可以被调度执行的状态（可能正在运行，也可能在就绪队列中等待）

  \- 转换事件：

   \- `proc_init()` 或 `wakeup_proc()` -> PROC_RUNNABLE（从其他状态唤醒）

   \- `schedule()` -> PROC_RUNNABLE（时间片用完或被抢占，重新加入就绪队列）

   \- `proc_run()` -> [RUNNING]（被调度器选中，开始运行）

   \- `do_wait()` -> PROC_SLEEPING（等待子进程）

   \- `do_exit()` -> PROC_ZOMBIE（进程退出）

3. **[RUNNING]（正在运行）**

  \- 进程正在 CPU 上执行的状态（这是 PROC_RUNNABLE 的一个子状态）

  \- 转换事件：

   \- `proc_run()` -> [RUNNING]（被调度器选中）

   \- `schedule()` -> PROC_RUNNABLE（时间片用完或被抢占）

4. **PROC_SLEEPING（睡眠）**

  \- 进程因等待某些事件而阻塞的状态

  \- 转换事件：

   \- `do_wait()` -> PROC_SLEEPING（等待子进程退出）

   \- `try_free_pages()` -> PROC_SLEEPING（等待内存页释放）

   \- `wakeup_proc()` -> PROC_RUNNABLE（被唤醒，如子进程退出、内存可用等）

5. **PROC_ZOMBIE（僵尸）**

  \- 进程已退出但资源尚未被父进程回收的状态

  \- 转换事件：

   \- `do_exit()` -> PROC_ZOMBIE（进程退出）

   \- `do_wait()` -> [进程销毁]（父进程回收资源，进程彻底销毁）



### 执行`make grade`

结果如下，显示的应用程序检测都输出ok

![make grade](D:\lab5\media\make grade.jpg)



##  扩展练习 Challenge：实现 Copy on Write （COW）机制

### 实现过程

**Page 结构修改**

在 `kern/mm/memlayout.h` 中为 Page 结构添加 COW 标志位：

```
struct Page
{
    int ref;                    // page frame's reference counter
    uint64_t flags;             // array of flags that describe the status of the page frame
    unsigned int property;      // the num of free block, used in first fit pm manager
    list_entry_t page_link;     // free list link
    list_entry_t pra_page_link; // used for pra (page replace algorithm)
    uintptr_t pra_vaddr;        // used for pra (page replace algorithm)
};

// 添加 COW 标志位定义
#define PG_cow 2  // COW 页面标志位

// 添加操作宏
#define SetPageCow(page) set_bit(PG_cow, &((page)->flags))
#define ClearPageCow(page) clear_bit(PG_cow, &((page)->flags))
#define PageCow(page) test_bit(PG_cow, &((page)->flags))
```

**页表项权限调整**

\- COW 页面在页表项中清除写权限位（PTE_W）

\- 保留读权限（PTE_R）和其他权限（PTE_U, PTE_X）

\- 页表项仍然有效（PTE_V）

**Fork 时的 COW 处理**

对练习二的copy_range函数进行部分修改

```
// COW 机制：fork 时的处理
 if (!share)
 {
     // 只对可写页面启用 COW（代码段等只读页面不需要 COW）
     if (*ptep & PTE_W)
     {
         // 1. 增加页面引用计数（父子共享）
         page_ref_inc(page);
         
         // 2. 设置 COW 标志位
         SetPageCow(page);
         
         // 3. 提取原页面权限，移除写权限（PTE_W）
         uint32_t perm = (*ptep & (PTE_U | PTE_R | PTE_X | PTE_V)) & ~PTE_W;
                    
            // 4. 子进程页表映射到同一物理页，权限设为只读
            *nptep = pte_create(page2ppn(page), perm);
            tlb_invalidate(to, start);
            
            // 5. 父进程页表也改为只读（确保父子都无法直接写）
            *ptep = pte_create(page2ppn(page), perm);
            tlb_invalidate(from, start);
        }
        else
        {
            // 只读页面（如代码段）：直接共享，不需要 COW
            *nptep = *ptep;
            page_ref_inc(page);
            tlb_invalidate(to, start);
        }
    }
    else
    {
        // 共享模式：直接复制页表项
        *nptep = *ptep;
        page_ref_inc(page);
        tlb_invalidate(to, start);
    }
}
```

**COW 页面复制**

```
// do_pgfault - 处理页面错误异常，实现 COW 机制
// @mm: 内存管理结构
// @error_code: 错误代码（bit 1 表示写操作）
// @addr: 发生错误的虚拟地址
int do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr)
{
    int ret = -E_INVAL;
    
    // 检查地址是否在用户空间
    if (!USER_ACCESS(addr, addr + 1))
    {
        goto failed;
    }
    
    // 查找包含该地址的 vma
    struct vma_struct *vma = find_vma(mm, addr);
    if (vma == NULL || addr < vma->vm_start || addr >= vma->vm_end)
    {
        goto failed;
    }
    
    // 获取页表项
    pte_t *ptep = get_pte(mm->pgdir, addr, 1);
    if (ptep == NULL)
    {
        ret = -E_NO_MEM;
        goto failed;
    }
    
    // 检查是否是写操作导致的 page fault
    bool is_write = (error_code & 0x2) != 0;
    
    // 如果页表项有效，说明页面存在
    if (*ptep & PTE_V)
    {
        // 检查是否是 COW 情况：页面存在但没有写权限，且是写操作
        if (is_write && !(*ptep & PTE_W) && (vma->vm_flags & VM_WRITE))
        {
            struct Page *page = pte2page(*ptep);
            
            // 检查是否是 COW 页面
            if (PageCow(page))
            {
                // COW 页面复制处理
                if (page_ref(page) > 1)
                {
                    // 引用计数 > 1，需要复制页面
                    struct Page *new_page = alloc_page();
                    if (new_page == NULL)
                    {
                        ret = -E_NO_MEM;
                        goto failed;
                    }
                    
                    // 复制页面内容
                    void *src_kva = page2kva(page);
                    void *dst_kva = page2kva(new_page);
                    memcpy(dst_kva, src_kva, PGSIZE);
                    
                    // 减少原页面的引用计数
                    page_ref_dec(page);
                    
                    // 清除原页面的 COW 标志（如果引用计数仍 > 0，其他进程仍在使用）
                    // 新页面不是 COW 页面
                    ClearPageCow(new_page);
                    
                    // 设置新页面的页表项，恢复写权限
                    uint32_t perm = (*ptep & (PTE_U | PTE_R | PTE_X)) | PTE_W | PTE_V;
                    *ptep = pte_create(page2ppn(new_page), perm);
                    tlb_invalidate(mm->pgdir, addr);
                    
                    ret = 0;
                }
                else
                {
                    // 引用计数 == 1，只有当前进程在使用，直接设置写权限
                    ClearPageCow(page);
                    *ptep |= PTE_W;
                    tlb_invalidate(mm->pgdir, addr);
                    ret = 0;
                }
            }
            else
            {
                // 不是 COW 页面，可能是其他错误
                goto failed;
            }
        }
        else
        {
            // 不是写操作或页面不允许写
            goto failed;
        }
    }
    else
    {
        // 页面不存在，需要分配新页面
        if (!(vma->vm_flags & VM_WRITE) && is_write)
        {
            goto failed;
        }
        
        // 分配新页面
        struct Page *page = alloc_page();
        if (page == NULL)
        {
            ret = -E_NO_MEM;
            goto failed;
        }
        
        // 设置页表项权限
        uint32_t perm = PTE_U | PTE_V;
        if (vma->vm_flags & VM_WRITE)
        {
            perm |= PTE_W;
        }
        if (vma->vm_flags & VM_READ)
        {
            perm |= PTE_R;
        }
        if (vma->vm_flags & VM_EXEC)
        {
            perm |= PTE_X;
        }
        
        *ptep = pte_create(page2ppn(page), perm);
        tlb_invalidate(mm->pgdir, addr);
        
        // 初始化页面为 0
        memset(page2kva(page), 0, PGSIZE);
        
        ret = 0;
    }
    
failed:
    return ret;
}
```

**测试程序**

```
#include <ulib.h>
#include <stdio.h>
#include <unistd.h>

#define PAGE_SIZE 4096
#define TEST_SIZE (PAGE_SIZE * 2)

// 全局变量用于测试 COW
static char buffer[TEST_SIZE];

// 测试 COW 机制
int main(void)
{
    cprintf("=== Copy-on-Write (COW) Test ===\n");
    
    // 初始化数据
    for (int i = 0; i < TEST_SIZE; i++)
    {
        buffer[i] = (char)(i % 256);
    }
    cprintf("Parent: Initialized buffer with test data\n");
    
    // 验证初始数据
    int sum = 0;
    for (int i = 0; i < TEST_SIZE; i++)
    {
        sum += buffer[i];
    }
    cprintf("Parent: Sum of buffer = %d\n", sum);
    
    // Fork 子进程
    int pid = fork();
    if (pid < 0)
    {
        cprintf("Fork failed\n");
        return -1;
    }
    
    if (pid == 0)
    {
        // 子进程
        cprintf("Child: Started, PID = %d\n", getpid());
        
        // 验证子进程可以看到父进程的数据（共享页面）
        int child_sum = 0;
        for (int i = 0; i < TEST_SIZE; i++)
        {
            child_sum += buffer[i];
        }
        cprintf("Child: Sum of buffer (before write) = %d\n", child_sum);
        
        if (child_sum != sum)
        {
            cprintf("Child: ERROR - Data mismatch! Expected %d, got %d\n", sum, child_sum);
            exit(-1);
        }
        
        // 修改数据（触发 COW）
        cprintf("Child: Modifying buffer (triggering COW)...\n");
        for (int i = 0; i < TEST_SIZE; i++)
        {
            buffer[i] = (char)((i + 1) % 256);
        }
        
        // 验证修改后的数据
        int new_sum = 0;
        for (int i = 0; i < TEST_SIZE; i++)
        {
            new_sum += buffer[i];
        }
        cprintf("Child: Sum of buffer (after write) = %d\n", new_sum);
        
        cprintf("Child: Exiting\n");
        exit(0);
    }
    else
    {
        // 父进程
        cprintf("Parent: Child PID = %d\n", pid);
        
        // 等待子进程完成
        int status;
        waitpid(pid, &status);
        cprintf("Parent: Child exited with status %d\n", status);
        
        // 验证父进程的数据没有被修改（COW 应该保护了父进程的数据）
        int parent_sum = 0;
        for (int i = 0; i < TEST_SIZE; i++)
        {
            parent_sum += buffer[i];
        }
        cprintf("Parent: Sum of buffer (after child write) = %d\n", parent_sum);
        
        if (parent_sum != sum)
        {
            cprintf("Parent: ERROR - Data was modified! Expected %d, got %d\n", sum, parent_sum);
            return -1;
        }
        
        cprintf("Parent: Data integrity verified - COW working correctly!\n");
        
        // 父进程也修改数据（再次触发 COW）
        cprintf("Parent: Modifying buffer...\n");
        for (int i = 0; i < TEST_SIZE; i++)
        {
            buffer[i] = (char)((i + 2) % 256);
        }
        
        int final_sum = 0;
        for (int i = 0; i < TEST_SIZE; i++)
        {
            final_sum += buffer[i];
        }
        cprintf("Parent: Sum of buffer (after parent write) = %d\n", final_sum);
        
        cprintf("=== COW Test Passed ===\n");
    }
    
    return 0;
}
```

**测试程序流程**:

1. 父进程初始化全局数据
2. Fork 子进程
3. 验证子进程可以看到父进程的数据（共享）
4. 子进程修改数据（触发 COW）
5. 验证父进程的数据未被修改（隔离）
6. 父进程修改数据（再次触发 COW）

### 状态转换说明

页面在 COW 机制中有以下状态：

1. **NORMAL_WRITABLE**: 正常可写状态（非 COW，有写权限）

2. **COW_SHARED**: COW 共享状态（父子进程共享，引用计数 > 1，无写权限，有 COW 标志）

3. **COW_PRIVATE**: COW 私有状态（引用计数 == 1，无写权限，有 COW 标志）

4. **PRIVATE_WRITABLE**: 私有可写状态（COW 复制后，有写权限，无 COW 标志）

   ```
                         ┌──────────────┐
                         │ NORMAL_WRITABLE│
                         │  正常可写      │
                         │ ref≥1, W=1, cow=0│
                         └───────┬──────┘
                                 │
                                 │ fork()/copy_range
                                 ▼
                         ┌──────────────┐
                         │ COW_SHARED   │
                         │ COW共享       │
                         │ ref>1, W=0, cow=1│
                         └───────┬──────┘
                                 │
                        ┌────────┴────────┐
                        │                 │
                        ▼                 ▼
                 ┌──────────────┐   ┌──────────────┐
                 │ COW_PRIVATE  │   │ 直接解除映射   │
                 │ COW私有      │   │ 导致ref=0     │
                 │ ref=1, W=0, cow=1│   │ 释放页面     │
                 └───────┬──────┘   └──────────────┘
                         │                 ▲
                         │ write/page_fault│
                         ▼                 │
                 ┌──────────────┐         │
                 │PRIVATE_WRITABLE         │
                 │ 私有可写      │         │
                 │ ref=1, W=1, cow=0│     │
                 └───────┬──────┘         │
                         │                 │
                         │ unmap()/ref--   │
                         │ (ref=0时)       │
                         └─────────────────┘
                                 │
                                 ▼
                         ┌──────────────┐
                         │  UNMAPPED    │
                         │  未映射      │
                         │  页面已释放   │
                         └──────────────┘
   ```

### 测试结果

运行`make build-cowtest`启动cow，运行`make qemu`，结果如下

![cow机制](D:\lab5\media\cow机制.png)

cow机制工作正常，fork时页面共享，子进程可以看到父进程的数据；子进程写入时触发 page fault，

父进程的数据保持不变，cow隔离成功，父进程写入时也触发了cow，即父子进程都正确设置了只读，

测试通过。



## 分支任务：`gdb` 调试系统调用以及返回

### 成功的关键步骤和输出

 **用户程序符号表加载** 

```
(gdb) add-symbol-file obj/__user_exit.out
Reading symbols from obj/__user_exit.out
```

![图片1](D:\lab5\media\图片1.png)

**有效的断点设置** 

**断点1**：用户态ecall指令前（最关键的观察点）

```
(gdb) break *0x800104
Breakpoint 9 at 0x800104: file user/libs/syscall.c, line 19.
(gdb) commands 9
\>echo "=== USER: ECALL INSTRUCTION ==="
\>echo "About to execute syscall"
\>info registers a0 a1 a2 a3 a4 a5
\>echo ""
\>end
```

有效输出1：

```
Breakpoint 9, 0x0000000000800104 in syscall (num=2) at user/libs/syscall.c:19
"=== USER: ECALL INSTRUCTION ==="
"About to execute syscall"
a0       0x2   2   # 系统调用号2 = SYS_fork
a1       0x0   0
a2       0x0   0
a3       0x0   0
a4       0x0   0
a5       0x0   0
```

![图片2](D:\lab5\media\图片2.png)

**断点2**：执行ecall后进入内核

```
(gdb) si # 执行ecall指令
0xffffffffc0200f3c in __alltraps () at kern/trap/trapentry.S:123
```

手动查看寄存器状态：

```
(gdb) info registers sepc scause sstatus
sepc      0x800104  8388868  # 异常发生地址
scause     0x8  8        # 异常原因：用户态ecall
sstatus    0x8000000000046020 -9223372036854489056
```

![图片3](D:\lab5\media\图片3.png)

**断点3**：do_fork函数

```
(gdb) break do_fork
Breakpoint 7 at 0xffffffffc020424a: file kern/process/proc.c, line 445.
(gdb) commands 7
\>echo "=== KERNEL: DO_FORK ==="
\>echo "Creating child process..."
\>end
```

有效输出2：

```
Breakpoint 7, do_fork (clone_flags=0, stack=2147483456, tf=0xffffffffc04bbee0)
  at kern/process/proc.c:445
"=== KERNEL: DO_FORK ==="
"Creating child process..."
```

![图片4](D:\lab5\media\图片4.png)

**断点4**：返回用户态后

```
(gdb) break *0x800108
Breakpoint 13 at 0x800108: file user/libs/syscall.c, line 19.
(gdb) commands 13
\>echo "=== [6] USER: AFTER SRET ==="
\>echo "Back in user mode"
\>echo "pc = "
\>info registers pc
\>echo "Return value = "
\>info registers a0
\>echo ""
\>end
```

有效输出3：

```
Breakpoint 13, 0x0000000000800108 in syscall (num=4) at user/libs/syscall.c:19
"=== [6] USER: AFTER SRET ==="
"Back in user mode"
"pc = "
pc       0x800108  0x800108 <syscall+48> # 返回地址正确
"Return value = "
a0       0x4   4             # 返回值
```

![图片5](D:\lab5\media\图片5.png)

 **完整的系统调用流程**

1. 用户态`ecall`前: `a0=2 (SYS_fork), pc=0x800104`
2. 执行`ecall`: 触发异常，`scause=0x8`
3. 进入内核: `sepc=0x800104` (异常地址)
4. 内核处理: 执行`do_fork`
5. 返回用户态: `pc=0x800108` (`ecall`下一条指令)

### 失败/无效的部分

1. **QEMU内部断点设置失败** 

```
(gdb) monitor b trans_ecall
unknown command: 'b'
```

原因：`gdb`版本不支持monitor命令

2. **部分内核地址无法访问** 

```
Cannot insert breakpoint 2: Cannot access memory at address 0xffffffffc0200f38
```

原因：页表未建立或当前上下文无法访问

3. **错误的断点地址** 

```
Breakpoint 15 at 0xffffffffc020578c: file libs/printfmt.c, line 199.
```

原因：误将`vprintfmt`函数当作`syscall`分发函数

### 有效的调试命令总结

1. **基本设置**

```
\# 启动调试
make gdb

\# 加载用户程序符号表
add-symbol-file obj/__user_exit.out

\# 清理断点
delete breakpoints
```

2. **关键断点（已验证有效）**

**用户态ecall指令**

```
break *0x800104
commands
\>echo "=== USER: ECALL ==="
\>info registers a0 a1 a2 a3 a4 a5
\>echo ""
\>end
```

**内核do_fork函数**

```
break do_fork
commands
\>echo "=== KERNEL: DO_FORK ==="
\>end
```

**返回用户态后**

```
break *0x800108
commands
\>echo "=== USER: RETURNED ==="
\>info registers pc a0
\>echo ""
\>end
```

3. **手动查看关键信息**

```
\# 查看寄存器
info registers sepc scause sstatus a0 a1 a2 a3 a4 a5

\# 单步执行
si # 执行ecall指令
 
\# 继续执行
continue
```

### 核心发现

1. **ecall机制**：

\- 用户态执行`ecall`触发异常（`scause=0x8`）

\- `sepc`保存异常地址（0x800104）

\- 跳转到内核中断处理程序（`__alltraps`）

 2. **特权级切换**：

\- 从用户态(U)切换到内核态(S)

\- `sstatus`寄存器记录状态变化

3. **返回机制**：

\- `sret`指令从内核态返回用户态

\- 返回到`sepc`指定的地址（0x800108）

\- 系统调用返回值通过a0寄存器传递

4. **系统调用流程**：

用户程序 → `syscall`封装 → `ecall` → 内核中断处理 → `syscall`分发 → 具体处理(do_fork) → `sret`返回 → 用户程序



## 分支任务：`gdb` 调试页表查询过程

![图片6](D:\lab5\media\图片6.png)

![图片7](D:\lab5\media\图片7.png)

1. **成功捕获访存指令**

找到了 `sd ra,8(sp)` 指令（地址 `0xffffffffc02000ee`）

成功设置了断点并命中

2. **观察到成功的访存操作**

虚拟地址：`0xffffffffc0204ff8`

操作：存储 `ra` 寄存器值到栈

结果：成功执行，数据验证正确

3. **推断出页表翻译行为**

`TLB`可能命中（因为内核栈地址通常已被访问过）

虚拟→物理地址翻译由硬件/`QEMU`透明完成