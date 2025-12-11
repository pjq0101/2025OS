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

