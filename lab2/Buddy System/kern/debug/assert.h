#ifndef __KERN_DEBUG_ASSERT_H__ 
#define __KERN_DEBUG_ASSERT_H__

#include <defs.h>

// 声明 panic 和 warn 函数
void __warn(const char *file, int line, const char *fmt, ...);
void __noreturn __panic(const char *file, int line, const char *fmt, ...);

// 在内存分配错误时，输出额外的调试信息
#define warn(...)                                       \
    __warn(__FILE__, __LINE__, __VA_ARGS__)

#define panic(...)                                      \
    __panic(__FILE__, __LINE__, __VA_ARGS__)

#define assert(x)                                       \
    do {                                                \
        if (!(x)) {                                     \
            panic("assertion failed: %s", #x);          \
        }                                               \
    } while (0)

// static_assert(x) will generate a compile-time error if 'x' is false.
#define static_assert(x)                                \
    switch (x) { case 0: case (x): ; }

#endif /* !__KERN_DEBUG_ASSERT_H__ */

