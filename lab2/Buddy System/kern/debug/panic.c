#include <defs.h>
#include <stdio.h>
#include <string.h>  // Ensure this is included for strstr()
#include <pmm.h>     // Ensure this is included to access nr_free_pages()

// Explicit declaration of strstr to avoid implicit declaration error
extern char *strstr(const char *haystack, const char *needle); 

extern size_t nr_free_pages(void);  // Explicit declaration of nr_free_pages

static bool is_panic = 0;

/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
    }
    is_panic = 1;

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel panic at %s:%d:\n    ", file, line);
    vcprintf(fmt, ap);
    cprintf("\n");

    // For memory-related panic, add debugging info (like memory allocation failure)
    if (strstr(fmt, "memory") != NULL || strstr(fmt, "alloc") != NULL) {
        // This part is to output debugging information when memory allocation fails
        cprintf("Memory allocation failure or panic occurred. Please check the Buddy System implementation.\n");
        // Output the remaining free pages
        cprintf("Free pages remaining: %zu\n", nr_free_pages());  // Ensure nr_free_pages is declared and defined
    }

    va_end(ap);

panic_dead:
    while (1) {
        ;
    }
}

/* __warn - like panic, but don't panic */
void
__warn(const char *file, int line, const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);
}

bool
is_kernel_panic(void) {
    return is_panic;
}

