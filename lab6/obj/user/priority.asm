
obj/__user_priority.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	144000ef          	jal	ra,800164 <umain>
1:  j 1b
  800024:	a001                	j	800024 <_start+0x4>

0000000000800026 <__panic>:
#include <stdio.h>
#include <ulib.h>
#include <error.h>

void
__panic(const char *file, int line, const char *fmt, ...) {
  800026:	715d                	addi	sp,sp,-80
  800028:	8e2e                	mv	t3,a1
  80002a:	e822                	sd	s0,16(sp)
    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
    cprintf("user panic at %s:%d:\n    ", file, line);
  80002c:	85aa                	mv	a1,a0
__panic(const char *file, int line, const char *fmt, ...) {
  80002e:	8432                	mv	s0,a2
  800030:	fc3e                	sd	a5,56(sp)
    cprintf("user panic at %s:%d:\n    ", file, line);
  800032:	8672                	mv	a2,t3
    va_start(ap, fmt);
  800034:	103c                	addi	a5,sp,40
    cprintf("user panic at %s:%d:\n    ", file, line);
  800036:	00001517          	auipc	a0,0x1
  80003a:	a0250513          	addi	a0,a0,-1534 # 800a38 <main+0x1b8>
__panic(const char *file, int line, const char *fmt, ...) {
  80003e:	ec06                	sd	ra,24(sp)
  800040:	f436                	sd	a3,40(sp)
  800042:	f83a                	sd	a4,48(sp)
  800044:	e0c2                	sd	a6,64(sp)
  800046:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  800048:	e43e                	sd	a5,8(sp)
    cprintf("user panic at %s:%d:\n    ", file, line);
  80004a:	058000ef          	jal	ra,8000a2 <cprintf>
    vcprintf(fmt, ap);
  80004e:	65a2                	ld	a1,8(sp)
  800050:	8522                	mv	a0,s0
  800052:	030000ef          	jal	ra,800082 <vcprintf>
    cprintf("\n");
  800056:	00001517          	auipc	a0,0x1
  80005a:	a0250513          	addi	a0,a0,-1534 # 800a58 <main+0x1d8>
  80005e:	044000ef          	jal	ra,8000a2 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800062:	5559                	li	a0,-10
  800064:	0da000ef          	jal	ra,80013e <exit>

0000000000800068 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  800068:	1141                	addi	sp,sp,-16
  80006a:	e022                	sd	s0,0(sp)
  80006c:	e406                	sd	ra,8(sp)
  80006e:	842e                	mv	s0,a1
    sys_putc(c);
  800070:	0bc000ef          	jal	ra,80012c <sys_putc>
    (*cnt) ++;
  800074:	401c                	lw	a5,0(s0)
}
  800076:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
  800078:	2785                	addiw	a5,a5,1
  80007a:	c01c                	sw	a5,0(s0)
}
  80007c:	6402                	ld	s0,0(sp)
  80007e:	0141                	addi	sp,sp,16
  800080:	8082                	ret

0000000000800082 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  800082:	1101                	addi	sp,sp,-32
  800084:	862a                	mv	a2,a0
  800086:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  800088:	00000517          	auipc	a0,0x0
  80008c:	fe050513          	addi	a0,a0,-32 # 800068 <cputch>
  800090:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
  800092:	ec06                	sd	ra,24(sp)
    int cnt = 0;
  800094:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  800096:	1c2000ef          	jal	ra,800258 <vprintfmt>
    return cnt;
}
  80009a:	60e2                	ld	ra,24(sp)
  80009c:	4532                	lw	a0,12(sp)
  80009e:	6105                	addi	sp,sp,32
  8000a0:	8082                	ret

00000000008000a2 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  8000a2:	711d                	addi	sp,sp,-96
    va_list ap;

    va_start(ap, fmt);
  8000a4:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
  8000a8:	8e2a                	mv	t3,a0
  8000aa:	f42e                	sd	a1,40(sp)
  8000ac:	f832                	sd	a2,48(sp)
  8000ae:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  8000b0:	00000517          	auipc	a0,0x0
  8000b4:	fb850513          	addi	a0,a0,-72 # 800068 <cputch>
  8000b8:	004c                	addi	a1,sp,4
  8000ba:	869a                	mv	a3,t1
  8000bc:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
  8000be:	ec06                	sd	ra,24(sp)
  8000c0:	e0ba                	sd	a4,64(sp)
  8000c2:	e4be                	sd	a5,72(sp)
  8000c4:	e8c2                	sd	a6,80(sp)
  8000c6:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
  8000c8:	e41a                	sd	t1,8(sp)
    int cnt = 0;
  8000ca:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  8000cc:	18c000ef          	jal	ra,800258 <vprintfmt>
    int cnt = vcprintf(fmt, ap);
    va_end(ap);

    return cnt;
}
  8000d0:	60e2                	ld	ra,24(sp)
  8000d2:	4512                	lw	a0,4(sp)
  8000d4:	6125                	addi	sp,sp,96
  8000d6:	8082                	ret

00000000008000d8 <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int64_t num, ...) {
  8000d8:	7175                	addi	sp,sp,-144
  8000da:	e42a                	sd	a0,8(sp)
    va_list ap;
    va_start(ap, num);
    uint64_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint64_t);
  8000dc:	0108                	addi	a0,sp,128
syscall(int64_t num, ...) {
  8000de:	ecae                	sd	a1,88(sp)
  8000e0:	f0b2                	sd	a2,96(sp)
  8000e2:	f4b6                	sd	a3,104(sp)
  8000e4:	f8ba                	sd	a4,112(sp)
  8000e6:	fcbe                	sd	a5,120(sp)
  8000e8:	e142                	sd	a6,128(sp)
  8000ea:	e546                	sd	a7,136(sp)
        a[i] = va_arg(ap, uint64_t);
  8000ec:	f02a                	sd	a0,32(sp)
  8000ee:	f42e                	sd	a1,40(sp)
  8000f0:	f832                	sd	a2,48(sp)
  8000f2:	fc36                	sd	a3,56(sp)
  8000f4:	e0ba                	sd	a4,64(sp)
  8000f6:	e4be                	sd	a5,72(sp)
    }
    va_end(ap);
    asm volatile (
  8000f8:	4522                	lw	a0,8(sp)
  8000fa:	55a2                	lw	a1,40(sp)
  8000fc:	5642                	lw	a2,48(sp)
  8000fe:	56e2                	lw	a3,56(sp)
  800100:	4706                	lw	a4,64(sp)
  800102:	47a6                	lw	a5,72(sp)
  800104:	00000073          	ecall
  800108:	ce2a                	sw	a0,28(sp)
          "m" (a[3]),
          "m" (a[4])
        : "memory"
      );
    return ret;
}
  80010a:	4572                	lw	a0,28(sp)
  80010c:	6149                	addi	sp,sp,144
  80010e:	8082                	ret

0000000000800110 <sys_exit>:

int
sys_exit(int64_t error_code) {
  800110:	85aa                	mv	a1,a0
    return syscall(SYS_exit, error_code);
  800112:	4505                	li	a0,1
  800114:	b7d1                	j	8000d8 <syscall>

0000000000800116 <sys_fork>:
}

int
sys_fork(void) {
    return syscall(SYS_fork);
  800116:	4509                	li	a0,2
  800118:	b7c1                	j	8000d8 <syscall>

000000000080011a <sys_wait>:
}

int
sys_wait(int64_t pid, int *store) {
  80011a:	862e                	mv	a2,a1
    return syscall(SYS_wait, pid, store);
  80011c:	85aa                	mv	a1,a0
  80011e:	450d                	li	a0,3
  800120:	bf65                	j	8000d8 <syscall>

0000000000800122 <sys_kill>:
sys_yield(void) {
    return syscall(SYS_yield);
}

int
sys_kill(int64_t pid) {
  800122:	85aa                	mv	a1,a0
    return syscall(SYS_kill, pid);
  800124:	4531                	li	a0,12
  800126:	bf4d                	j	8000d8 <syscall>

0000000000800128 <sys_getpid>:
}

int
sys_getpid(void) {
    return syscall(SYS_getpid);
  800128:	4549                	li	a0,18
  80012a:	b77d                	j	8000d8 <syscall>

000000000080012c <sys_putc>:
}

int
sys_putc(int64_t c) {
  80012c:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  80012e:	4579                	li	a0,30
  800130:	b765                	j	8000d8 <syscall>

0000000000800132 <sys_gettime>:
    return syscall(SYS_pgdir);
}

int
sys_gettime(void) {
    return syscall(SYS_gettime);
  800132:	4545                	li	a0,17
  800134:	b755                	j	8000d8 <syscall>

0000000000800136 <sys_lab6_set_priority>:
}

void
sys_lab6_set_priority(uint64_t priority)
{
  800136:	85aa                	mv	a1,a0
    syscall(SYS_lab6_set_priority, priority);
  800138:	0ff00513          	li	a0,255
  80013c:	bf71                	j	8000d8 <syscall>

000000000080013e <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  80013e:	1141                	addi	sp,sp,-16
  800140:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  800142:	fcfff0ef          	jal	ra,800110 <sys_exit>
    cprintf("BUG: exit failed.\n");
  800146:	00001517          	auipc	a0,0x1
  80014a:	91a50513          	addi	a0,a0,-1766 # 800a60 <main+0x1e0>
  80014e:	f55ff0ef          	jal	ra,8000a2 <cprintf>
    while (1);
  800152:	a001                	j	800152 <exit+0x14>

0000000000800154 <fork>:
}

int
fork(void) {
    return sys_fork();
  800154:	b7c9                	j	800116 <sys_fork>

0000000000800156 <waitpid>:
    return sys_wait(0, NULL);
}

int
waitpid(int pid, int *store) {
    return sys_wait(pid, store);
  800156:	b7d1                	j	80011a <sys_wait>

0000000000800158 <kill>:
    sys_yield();
}

int
kill(int pid) {
    return sys_kill(pid);
  800158:	b7e9                	j	800122 <sys_kill>

000000000080015a <getpid>:
}

int
getpid(void) {
    return sys_getpid();
  80015a:	b7f9                	j	800128 <sys_getpid>

000000000080015c <gettime_msec>:
    sys_pgdir();
}

unsigned int
gettime_msec(void) {
    return (unsigned int)sys_gettime();
  80015c:	bfd9                	j	800132 <sys_gettime>

000000000080015e <lab6_setpriority>:
}

void
lab6_setpriority(uint32_t priority)
{
    sys_lab6_set_priority(priority);
  80015e:	1502                	slli	a0,a0,0x20
  800160:	9101                	srli	a0,a0,0x20
  800162:	bfd1                	j	800136 <sys_lab6_set_priority>

0000000000800164 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  800164:	1141                	addi	sp,sp,-16
  800166:	e406                	sd	ra,8(sp)
    int ret = main();
  800168:	718000ef          	jal	ra,800880 <main>
    exit(ret);
  80016c:	fd3ff0ef          	jal	ra,80013e <exit>

0000000000800170 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  800170:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800174:	7139                	addi	sp,sp,-64
    unsigned mod = do_div(result, base);
  800176:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  80017a:	e852                	sd	s4,16(sp)
    unsigned mod = do_div(result, base);
  80017c:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  800180:	f426                	sd	s1,40(sp)
  800182:	f04a                	sd	s2,32(sp)
  800184:	ec4e                	sd	s3,24(sp)
  800186:	fc06                	sd	ra,56(sp)
  800188:	f822                	sd	s0,48(sp)
  80018a:	e456                	sd	s5,8(sp)
  80018c:	e05a                	sd	s6,0(sp)
  80018e:	84aa                	mv	s1,a0
  800190:	892e                	mv	s2,a1
  800192:	89be                	mv	s3,a5
    unsigned mod = do_div(result, base);
  800194:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  800196:	05067163          	bgeu	a2,a6,8001d8 <printnum+0x68>
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  80019a:	fff7041b          	addiw	s0,a4,-1
  80019e:	00805763          	blez	s0,8001ac <printnum+0x3c>
  8001a2:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  8001a4:	85ca                	mv	a1,s2
  8001a6:	854e                	mv	a0,s3
  8001a8:	9482                	jalr	s1
        while (-- width > 0)
  8001aa:	fc65                	bnez	s0,8001a2 <printnum+0x32>
  8001ac:	00001417          	auipc	s0,0x1
  8001b0:	8cc40413          	addi	s0,s0,-1844 # 800a78 <main+0x1f8>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  8001b4:	1a02                	slli	s4,s4,0x20
  8001b6:	020a5a13          	srli	s4,s4,0x20
  8001ba:	9452                	add	s0,s0,s4
  8001bc:	00044503          	lbu	a0,0(s0)
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  8001c0:	7442                	ld	s0,48(sp)
  8001c2:	70e2                	ld	ra,56(sp)
  8001c4:	69e2                	ld	s3,24(sp)
  8001c6:	6a42                	ld	s4,16(sp)
  8001c8:	6aa2                	ld	s5,8(sp)
  8001ca:	6b02                	ld	s6,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001cc:	85ca                	mv	a1,s2
  8001ce:	87a6                	mv	a5,s1
}
  8001d0:	7902                	ld	s2,32(sp)
  8001d2:	74a2                	ld	s1,40(sp)
  8001d4:	6121                	addi	sp,sp,64
    putch("0123456789abcdef"[mod], putdat);
  8001d6:	8782                	jr	a5
    unsigned mod = do_div(result, base);
  8001d8:	03065633          	divu	a2,a2,a6
  8001dc:	03067ab3          	remu	s5,a2,a6
  8001e0:	2a81                	sext.w	s5,s5
    if (num >= base) {
  8001e2:	03067863          	bgeu	a2,a6,800212 <printnum+0xa2>
        while (-- width > 0)
  8001e6:	ffe7041b          	addiw	s0,a4,-2
  8001ea:	00805763          	blez	s0,8001f8 <printnum+0x88>
  8001ee:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  8001f0:	85ca                	mv	a1,s2
  8001f2:	854e                	mv	a0,s3
  8001f4:	9482                	jalr	s1
        while (-- width > 0)
  8001f6:	fc65                	bnez	s0,8001ee <printnum+0x7e>
  8001f8:	00001417          	auipc	s0,0x1
  8001fc:	88040413          	addi	s0,s0,-1920 # 800a78 <main+0x1f8>
    putch("0123456789abcdef"[mod], putdat);
  800200:	1a82                	slli	s5,s5,0x20
  800202:	020ada93          	srli	s5,s5,0x20
  800206:	9aa2                	add	s5,s5,s0
  800208:	000ac503          	lbu	a0,0(s5)
  80020c:	85ca                	mv	a1,s2
  80020e:	9482                	jalr	s1
}
  800210:	b755                	j	8001b4 <printnum+0x44>
    unsigned mod = do_div(result, base);
  800212:	03065633          	divu	a2,a2,a6
        while (-- width > 0)
  800216:	ffd7041b          	addiw	s0,a4,-3
    unsigned mod = do_div(result, base);
  80021a:	03067b33          	remu	s6,a2,a6
  80021e:	2b01                	sext.w	s6,s6
    if (num >= base) {
  800220:	03067663          	bgeu	a2,a6,80024c <printnum+0xdc>
        while (-- width > 0)
  800224:	00805763          	blez	s0,800232 <printnum+0xc2>
  800228:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  80022a:	85ca                	mv	a1,s2
  80022c:	854e                	mv	a0,s3
  80022e:	9482                	jalr	s1
        while (-- width > 0)
  800230:	fc65                	bnez	s0,800228 <printnum+0xb8>
    putch("0123456789abcdef"[mod], putdat);
  800232:	1b02                	slli	s6,s6,0x20
  800234:	00001417          	auipc	s0,0x1
  800238:	84440413          	addi	s0,s0,-1980 # 800a78 <main+0x1f8>
  80023c:	020b5b13          	srli	s6,s6,0x20
  800240:	9b22                	add	s6,s6,s0
  800242:	000b4503          	lbu	a0,0(s6)
  800246:	85ca                	mv	a1,s2
  800248:	9482                	jalr	s1
}
  80024a:	bf5d                	j	800200 <printnum+0x90>
        printnum(putch, putdat, result, base, width - 1, padc);
  80024c:	03065633          	divu	a2,a2,a6
  800250:	8722                	mv	a4,s0
  800252:	f1fff0ef          	jal	ra,800170 <printnum>
  800256:	bff1                	j	800232 <printnum+0xc2>

0000000000800258 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  800258:	7119                	addi	sp,sp,-128
  80025a:	f4a6                	sd	s1,104(sp)
  80025c:	f0ca                	sd	s2,96(sp)
  80025e:	ecce                	sd	s3,88(sp)
  800260:	e8d2                	sd	s4,80(sp)
  800262:	e4d6                	sd	s5,72(sp)
  800264:	e0da                	sd	s6,64(sp)
  800266:	fc5e                	sd	s7,56(sp)
  800268:	f466                	sd	s9,40(sp)
  80026a:	fc86                	sd	ra,120(sp)
  80026c:	f8a2                	sd	s0,112(sp)
  80026e:	f862                	sd	s8,48(sp)
  800270:	f06a                	sd	s10,32(sp)
  800272:	ec6e                	sd	s11,24(sp)
  800274:	892a                	mv	s2,a0
  800276:	84ae                	mv	s1,a1
  800278:	8cb2                	mv	s9,a2
  80027a:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80027c:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  800280:	5bfd                	li	s7,-1
  800282:	00001a97          	auipc	s5,0x1
  800286:	82aa8a93          	addi	s5,s5,-2006 # 800aac <main+0x22c>
    putch("0123456789abcdef"[mod], putdat);
  80028a:	00000b17          	auipc	s6,0x0
  80028e:	7eeb0b13          	addi	s6,s6,2030 # 800a78 <main+0x1f8>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800292:	000cc503          	lbu	a0,0(s9)
  800296:	001c8413          	addi	s0,s9,1
  80029a:	01350a63          	beq	a0,s3,8002ae <vprintfmt+0x56>
            if (ch == '\0') {
  80029e:	c121                	beqz	a0,8002de <vprintfmt+0x86>
            putch(ch, putdat);
  8002a0:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8002a2:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  8002a4:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8002a6:	fff44503          	lbu	a0,-1(s0)
  8002aa:	ff351ae3          	bne	a0,s3,80029e <vprintfmt+0x46>
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  8002ae:	00044683          	lbu	a3,0(s0)
        char padc = ' ';
  8002b2:	02000813          	li	a6,32
        lflag = altflag = 0;
  8002b6:	4d81                	li	s11,0
  8002b8:	4501                	li	a0,0
        width = precision = -1;
  8002ba:	5c7d                	li	s8,-1
  8002bc:	5d7d                	li	s10,-1
  8002be:	05500613          	li	a2,85
        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
  8002c2:	45a5                	li	a1,9
        switch (ch = *(unsigned char *)fmt ++) {
  8002c4:	fdd6879b          	addiw	a5,a3,-35
  8002c8:	0ff7f793          	zext.b	a5,a5
  8002cc:	00140c93          	addi	s9,s0,1
  8002d0:	04f66263          	bltu	a2,a5,800314 <vprintfmt+0xbc>
  8002d4:	078a                	slli	a5,a5,0x2
  8002d6:	97d6                	add	a5,a5,s5
  8002d8:	439c                	lw	a5,0(a5)
  8002da:	97d6                	add	a5,a5,s5
  8002dc:	8782                	jr	a5
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8002de:	70e6                	ld	ra,120(sp)
  8002e0:	7446                	ld	s0,112(sp)
  8002e2:	74a6                	ld	s1,104(sp)
  8002e4:	7906                	ld	s2,96(sp)
  8002e6:	69e6                	ld	s3,88(sp)
  8002e8:	6a46                	ld	s4,80(sp)
  8002ea:	6aa6                	ld	s5,72(sp)
  8002ec:	6b06                	ld	s6,64(sp)
  8002ee:	7be2                	ld	s7,56(sp)
  8002f0:	7c42                	ld	s8,48(sp)
  8002f2:	7ca2                	ld	s9,40(sp)
  8002f4:	7d02                	ld	s10,32(sp)
  8002f6:	6de2                	ld	s11,24(sp)
  8002f8:	6109                	addi	sp,sp,128
  8002fa:	8082                	ret
            padc = '0';
  8002fc:	8836                	mv	a6,a3
            goto reswitch;
  8002fe:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800302:	8466                	mv	s0,s9
  800304:	00140c93          	addi	s9,s0,1
  800308:	fdd6879b          	addiw	a5,a3,-35
  80030c:	0ff7f793          	zext.b	a5,a5
  800310:	fcf672e3          	bgeu	a2,a5,8002d4 <vprintfmt+0x7c>
            putch('%', putdat);
  800314:	85a6                	mv	a1,s1
  800316:	02500513          	li	a0,37
  80031a:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  80031c:	fff44783          	lbu	a5,-1(s0)
  800320:	8ca2                	mv	s9,s0
  800322:	f73788e3          	beq	a5,s3,800292 <vprintfmt+0x3a>
  800326:	ffecc783          	lbu	a5,-2(s9)
  80032a:	1cfd                	addi	s9,s9,-1
  80032c:	ff379de3          	bne	a5,s3,800326 <vprintfmt+0xce>
  800330:	b78d                	j	800292 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  800332:	fd068c1b          	addiw	s8,a3,-48
                ch = *fmt;
  800336:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  80033a:	8466                	mv	s0,s9
                if (ch < '0' || ch > '9') {
  80033c:	fd06879b          	addiw	a5,a3,-48
                ch = *fmt;
  800340:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  800344:	02f5e563          	bltu	a1,a5,80036e <vprintfmt+0x116>
                ch = *fmt;
  800348:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
  80034c:	002c179b          	slliw	a5,s8,0x2
  800350:	0187873b          	addw	a4,a5,s8
  800354:	0017171b          	slliw	a4,a4,0x1
  800358:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
  80035c:	fd06879b          	addiw	a5,a3,-48
            for (precision = 0; ; ++ fmt) {
  800360:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  800362:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  800366:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  80036a:	fcf5ffe3          	bgeu	a1,a5,800348 <vprintfmt+0xf0>
            if (width < 0)
  80036e:	f40d5be3          	bgez	s10,8002c4 <vprintfmt+0x6c>
                width = precision, precision = -1;
  800372:	8d62                	mv	s10,s8
  800374:	5c7d                	li	s8,-1
  800376:	b7b9                	j	8002c4 <vprintfmt+0x6c>
            if (width < 0)
  800378:	fffd4793          	not	a5,s10
  80037c:	97fd                	srai	a5,a5,0x3f
  80037e:	00fd7d33          	and	s10,s10,a5
        switch (ch = *(unsigned char *)fmt ++) {
  800382:	00144683          	lbu	a3,1(s0)
  800386:	2d01                	sext.w	s10,s10
  800388:	8466                	mv	s0,s9
            goto reswitch;
  80038a:	bf2d                	j	8002c4 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  80038c:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  800390:	00144683          	lbu	a3,1(s0)
            precision = va_arg(ap, int);
  800394:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  800396:	8466                	mv	s0,s9
            goto process_precision;
  800398:	bfd9                	j	80036e <vprintfmt+0x116>
    if (lflag >= 2) {
  80039a:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80039c:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  8003a0:	00a7c463          	blt	a5,a0,8003a8 <vprintfmt+0x150>
    else if (lflag) {
  8003a4:	28050a63          	beqz	a0,800638 <vprintfmt+0x3e0>
        return va_arg(*ap, unsigned long);
  8003a8:	000a3783          	ld	a5,0(s4)
  8003ac:	4641                	li	a2,16
  8003ae:	8a3a                	mv	s4,a4
  8003b0:	46c1                	li	a3,16
    unsigned mod = do_div(result, base);
  8003b2:	02c7fdb3          	remu	s11,a5,a2
            printnum(putch, putdat, num, base, width, padc);
  8003b6:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  8003ba:	0ac7f563          	bgeu	a5,a2,800464 <vprintfmt+0x20c>
        while (-- width > 0)
  8003be:	3d7d                	addiw	s10,s10,-1
  8003c0:	01a05863          	blez	s10,8003d0 <vprintfmt+0x178>
  8003c4:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  8003c6:	85a6                	mv	a1,s1
  8003c8:	8562                	mv	a0,s8
  8003ca:	9902                	jalr	s2
        while (-- width > 0)
  8003cc:	fe0d1ce3          	bnez	s10,8003c4 <vprintfmt+0x16c>
    putch("0123456789abcdef"[mod], putdat);
  8003d0:	9dda                	add	s11,s11,s6
  8003d2:	000dc503          	lbu	a0,0(s11)
  8003d6:	85a6                	mv	a1,s1
  8003d8:	9902                	jalr	s2
}
  8003da:	bd65                	j	800292 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  8003dc:	000a2503          	lw	a0,0(s4)
  8003e0:	85a6                	mv	a1,s1
  8003e2:	0a21                	addi	s4,s4,8
  8003e4:	9902                	jalr	s2
            break;
  8003e6:	b575                	j	800292 <vprintfmt+0x3a>
    if (lflag >= 2) {
  8003e8:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8003ea:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  8003ee:	00a7c463          	blt	a5,a0,8003f6 <vprintfmt+0x19e>
    else if (lflag) {
  8003f2:	22050d63          	beqz	a0,80062c <vprintfmt+0x3d4>
        return va_arg(*ap, unsigned long);
  8003f6:	000a3783          	ld	a5,0(s4)
  8003fa:	4629                	li	a2,10
  8003fc:	8a3a                	mv	s4,a4
  8003fe:	46a9                	li	a3,10
  800400:	bf4d                	j	8003b2 <vprintfmt+0x15a>
        switch (ch = *(unsigned char *)fmt ++) {
  800402:	00144683          	lbu	a3,1(s0)
            altflag = 1;
  800406:	4d85                	li	s11,1
        switch (ch = *(unsigned char *)fmt ++) {
  800408:	8466                	mv	s0,s9
            goto reswitch;
  80040a:	bd6d                	j	8002c4 <vprintfmt+0x6c>
            putch(ch, putdat);
  80040c:	85a6                	mv	a1,s1
  80040e:	02500513          	li	a0,37
  800412:	9902                	jalr	s2
            break;
  800414:	bdbd                	j	800292 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  800416:	00144683          	lbu	a3,1(s0)
            lflag ++;
  80041a:	2505                	addiw	a0,a0,1
        switch (ch = *(unsigned char *)fmt ++) {
  80041c:	8466                	mv	s0,s9
            goto reswitch;
  80041e:	b55d                	j	8002c4 <vprintfmt+0x6c>
    if (lflag >= 2) {
  800420:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800422:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800426:	00a7c463          	blt	a5,a0,80042e <vprintfmt+0x1d6>
    else if (lflag) {
  80042a:	1e050b63          	beqz	a0,800620 <vprintfmt+0x3c8>
        return va_arg(*ap, unsigned long);
  80042e:	000a3783          	ld	a5,0(s4)
  800432:	4621                	li	a2,8
  800434:	8a3a                	mv	s4,a4
  800436:	46a1                	li	a3,8
  800438:	bfad                	j	8003b2 <vprintfmt+0x15a>
            putch('0', putdat);
  80043a:	03000513          	li	a0,48
  80043e:	85a6                	mv	a1,s1
  800440:	e042                	sd	a6,0(sp)
  800442:	9902                	jalr	s2
            putch('x', putdat);
  800444:	85a6                	mv	a1,s1
  800446:	07800513          	li	a0,120
  80044a:	9902                	jalr	s2
            goto number;
  80044c:	6802                	ld	a6,0(sp)
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80044e:	000a3783          	ld	a5,0(s4)
            goto number;
  800452:	4641                	li	a2,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800454:	0a21                	addi	s4,s4,8
    unsigned mod = do_div(result, base);
  800456:	02c7fdb3          	remu	s11,a5,a2
            goto number;
  80045a:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
  80045c:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  800460:	f4c7efe3          	bltu	a5,a2,8003be <vprintfmt+0x166>
        while (-- width > 0)
  800464:	3d79                	addiw	s10,s10,-2
    unsigned mod = do_div(result, base);
  800466:	02c7d7b3          	divu	a5,a5,a2
  80046a:	02c7f433          	remu	s0,a5,a2
    if (num >= base) {
  80046e:	10c7f463          	bgeu	a5,a2,800576 <vprintfmt+0x31e>
        while (-- width > 0)
  800472:	01a05863          	blez	s10,800482 <vprintfmt+0x22a>
  800476:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  800478:	85a6                	mv	a1,s1
  80047a:	8562                	mv	a0,s8
  80047c:	9902                	jalr	s2
        while (-- width > 0)
  80047e:	fe0d1ce3          	bnez	s10,800476 <vprintfmt+0x21e>
    putch("0123456789abcdef"[mod], putdat);
  800482:	945a                	add	s0,s0,s6
  800484:	00044503          	lbu	a0,0(s0)
  800488:	85a6                	mv	a1,s1
  80048a:	9dda                	add	s11,s11,s6
  80048c:	9902                	jalr	s2
  80048e:	000dc503          	lbu	a0,0(s11)
  800492:	85a6                	mv	a1,s1
  800494:	9902                	jalr	s2
  800496:	bbf5                	j	800292 <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
  800498:	000a3403          	ld	s0,0(s4)
  80049c:	008a0793          	addi	a5,s4,8
  8004a0:	e43e                	sd	a5,8(sp)
  8004a2:	1e040563          	beqz	s0,80068c <vprintfmt+0x434>
            if (width > 0 && padc != '-') {
  8004a6:	15a05263          	blez	s10,8005ea <vprintfmt+0x392>
  8004aa:	02d00793          	li	a5,45
  8004ae:	10f81b63          	bne	a6,a5,8005c4 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004b2:	00044783          	lbu	a5,0(s0)
  8004b6:	0007851b          	sext.w	a0,a5
  8004ba:	0e078c63          	beqz	a5,8005b2 <vprintfmt+0x35a>
  8004be:	0405                	addi	s0,s0,1
  8004c0:	120d8e63          	beqz	s11,8005fc <vprintfmt+0x3a4>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004c4:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004c8:	020c4963          	bltz	s8,8004fa <vprintfmt+0x2a2>
  8004cc:	fffc0a1b          	addiw	s4,s8,-1
  8004d0:	0d7a0f63          	beq	s4,s7,8005ae <vprintfmt+0x356>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004d4:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  8004d6:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8004d8:	02fdf663          	bgeu	s11,a5,800504 <vprintfmt+0x2ac>
                    putch('?', putdat);
  8004dc:	03f00513          	li	a0,63
  8004e0:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004e2:	00044783          	lbu	a5,0(s0)
  8004e6:	3d7d                	addiw	s10,s10,-1
  8004e8:	0405                	addi	s0,s0,1
  8004ea:	0007851b          	sext.w	a0,a5
  8004ee:	c3e1                	beqz	a5,8005ae <vprintfmt+0x356>
  8004f0:	140c4a63          	bltz	s8,800644 <vprintfmt+0x3ec>
  8004f4:	8c52                	mv	s8,s4
  8004f6:	fc0c5be3          	bgez	s8,8004cc <vprintfmt+0x274>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004fa:	3781                	addiw	a5,a5,-32
  8004fc:	8a62                	mv	s4,s8
                    putch('?', putdat);
  8004fe:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800500:	fcfdeee3          	bltu	s11,a5,8004dc <vprintfmt+0x284>
                    putch(ch, putdat);
  800504:	9902                	jalr	s2
  800506:	bff1                	j	8004e2 <vprintfmt+0x28a>
    if (lflag >= 2) {
  800508:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80050a:	008a0d93          	addi	s11,s4,8
    if (lflag >= 2) {
  80050e:	00a7c463          	blt	a5,a0,800516 <vprintfmt+0x2be>
    else if (lflag) {
  800512:	10050463          	beqz	a0,80061a <vprintfmt+0x3c2>
        return va_arg(*ap, long);
  800516:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  80051a:	14044d63          	bltz	s0,800674 <vprintfmt+0x41c>
            num = getint(&ap, lflag);
  80051e:	87a2                	mv	a5,s0
  800520:	8a6e                	mv	s4,s11
  800522:	4629                	li	a2,10
  800524:	46a9                	li	a3,10
  800526:	b571                	j	8003b2 <vprintfmt+0x15a>
            err = va_arg(ap, int);
  800528:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80052c:	4761                	li	a4,24
            err = va_arg(ap, int);
  80052e:	0a21                	addi	s4,s4,8
            if (err < 0) {
  800530:	41f7d69b          	sraiw	a3,a5,0x1f
  800534:	8fb5                	xor	a5,a5,a3
  800536:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80053a:	02d74563          	blt	a4,a3,800564 <vprintfmt+0x30c>
  80053e:	00369713          	slli	a4,a3,0x3
  800542:	00000797          	auipc	a5,0x0
  800546:	78678793          	addi	a5,a5,1926 # 800cc8 <error_string>
  80054a:	97ba                	add	a5,a5,a4
  80054c:	639c                	ld	a5,0(a5)
  80054e:	cb99                	beqz	a5,800564 <vprintfmt+0x30c>
                printfmt(putch, putdat, "%s", p);
  800550:	86be                	mv	a3,a5
  800552:	00000617          	auipc	a2,0x0
  800556:	55660613          	addi	a2,a2,1366 # 800aa8 <main+0x228>
  80055a:	85a6                	mv	a1,s1
  80055c:	854a                	mv	a0,s2
  80055e:	160000ef          	jal	ra,8006be <printfmt>
  800562:	bb05                	j	800292 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  800564:	00000617          	auipc	a2,0x0
  800568:	53460613          	addi	a2,a2,1332 # 800a98 <main+0x218>
  80056c:	85a6                	mv	a1,s1
  80056e:	854a                	mv	a0,s2
  800570:	14e000ef          	jal	ra,8006be <printfmt>
  800574:	bb39                	j	800292 <vprintfmt+0x3a>
        printnum(putch, putdat, result, base, width - 1, padc);
  800576:	02c7d633          	divu	a2,a5,a2
  80057a:	876a                	mv	a4,s10
  80057c:	87e2                	mv	a5,s8
  80057e:	85a6                	mv	a1,s1
  800580:	854a                	mv	a0,s2
  800582:	befff0ef          	jal	ra,800170 <printnum>
  800586:	bdf5                	j	800482 <vprintfmt+0x22a>
                    putch(ch, putdat);
  800588:	85a6                	mv	a1,s1
  80058a:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80058c:	00044503          	lbu	a0,0(s0)
  800590:	3d7d                	addiw	s10,s10,-1
  800592:	0405                	addi	s0,s0,1
  800594:	cd09                	beqz	a0,8005ae <vprintfmt+0x356>
  800596:	008d0d3b          	addw	s10,s10,s0
  80059a:	fffd0d9b          	addiw	s11,s10,-1
                    putch(ch, putdat);
  80059e:	85a6                	mv	a1,s1
  8005a0:	408d8d3b          	subw	s10,s11,s0
  8005a4:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005a6:	00044503          	lbu	a0,0(s0)
  8005aa:	0405                	addi	s0,s0,1
  8005ac:	f96d                	bnez	a0,80059e <vprintfmt+0x346>
            for (; width > 0; width --) {
  8005ae:	01a05963          	blez	s10,8005c0 <vprintfmt+0x368>
  8005b2:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
  8005b4:	85a6                	mv	a1,s1
  8005b6:	02000513          	li	a0,32
  8005ba:	9902                	jalr	s2
            for (; width > 0; width --) {
  8005bc:	fe0d1be3          	bnez	s10,8005b2 <vprintfmt+0x35a>
            if ((p = va_arg(ap, char *)) == NULL) {
  8005c0:	6a22                	ld	s4,8(sp)
  8005c2:	b9c1                	j	800292 <vprintfmt+0x3a>
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005c4:	85e2                	mv	a1,s8
  8005c6:	8522                	mv	a0,s0
  8005c8:	e042                	sd	a6,0(sp)
  8005ca:	114000ef          	jal	ra,8006de <strnlen>
  8005ce:	40ad0d3b          	subw	s10,s10,a0
  8005d2:	01a05c63          	blez	s10,8005ea <vprintfmt+0x392>
                    putch(padc, putdat);
  8005d6:	6802                	ld	a6,0(sp)
  8005d8:	0008051b          	sext.w	a0,a6
  8005dc:	85a6                	mv	a1,s1
  8005de:	e02a                	sd	a0,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005e0:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
  8005e2:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005e4:	6502                	ld	a0,0(sp)
  8005e6:	fe0d1be3          	bnez	s10,8005dc <vprintfmt+0x384>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005ea:	00044783          	lbu	a5,0(s0)
  8005ee:	0405                	addi	s0,s0,1
  8005f0:	0007851b          	sext.w	a0,a5
  8005f4:	ec0796e3          	bnez	a5,8004c0 <vprintfmt+0x268>
            if ((p = va_arg(ap, char *)) == NULL) {
  8005f8:	6a22                	ld	s4,8(sp)
  8005fa:	b961                	j	800292 <vprintfmt+0x3a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005fc:	f80c46e3          	bltz	s8,800588 <vprintfmt+0x330>
  800600:	3c7d                	addiw	s8,s8,-1
  800602:	fb7c06e3          	beq	s8,s7,8005ae <vprintfmt+0x356>
                    putch(ch, putdat);
  800606:	85a6                	mv	a1,s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800608:	0405                	addi	s0,s0,1
                    putch(ch, putdat);
  80060a:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80060c:	fff44503          	lbu	a0,-1(s0)
  800610:	3d7d                	addiw	s10,s10,-1
  800612:	f56d                	bnez	a0,8005fc <vprintfmt+0x3a4>
            for (; width > 0; width --) {
  800614:	f9a04fe3          	bgtz	s10,8005b2 <vprintfmt+0x35a>
  800618:	b765                	j	8005c0 <vprintfmt+0x368>
        return va_arg(*ap, int);
  80061a:	000a2403          	lw	s0,0(s4)
  80061e:	bdf5                	j	80051a <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned int);
  800620:	000a6783          	lwu	a5,0(s4)
  800624:	4621                	li	a2,8
  800626:	8a3a                	mv	s4,a4
  800628:	46a1                	li	a3,8
  80062a:	b361                	j	8003b2 <vprintfmt+0x15a>
  80062c:	000a6783          	lwu	a5,0(s4)
  800630:	4629                	li	a2,10
  800632:	8a3a                	mv	s4,a4
  800634:	46a9                	li	a3,10
  800636:	bbb5                	j	8003b2 <vprintfmt+0x15a>
  800638:	000a6783          	lwu	a5,0(s4)
  80063c:	4641                	li	a2,16
  80063e:	8a3a                	mv	s4,a4
  800640:	46c1                	li	a3,16
  800642:	bb85                	j	8003b2 <vprintfmt+0x15a>
  800644:	01a40d3b          	addw	s10,s0,s10
                if (altflag && (ch < ' ' || ch > '~')) {
  800648:	05e00d93          	li	s11,94
  80064c:	3d7d                	addiw	s10,s10,-1
  80064e:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  800650:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800652:	00fdf463          	bgeu	s11,a5,80065a <vprintfmt+0x402>
                    putch('?', putdat);
  800656:	03f00513          	li	a0,63
  80065a:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80065c:	00044783          	lbu	a5,0(s0)
  800660:	408d073b          	subw	a4,s10,s0
  800664:	0405                	addi	s0,s0,1
  800666:	0007851b          	sext.w	a0,a5
  80066a:	f3f5                	bnez	a5,80064e <vprintfmt+0x3f6>
  80066c:	8d3a                	mv	s10,a4
            for (; width > 0; width --) {
  80066e:	f5a042e3          	bgtz	s10,8005b2 <vprintfmt+0x35a>
  800672:	b7b9                	j	8005c0 <vprintfmt+0x368>
                putch('-', putdat);
  800674:	85a6                	mv	a1,s1
  800676:	02d00513          	li	a0,45
  80067a:	e042                	sd	a6,0(sp)
  80067c:	9902                	jalr	s2
                num = -(long long)num;
  80067e:	6802                	ld	a6,0(sp)
  800680:	8a6e                	mv	s4,s11
  800682:	408007b3          	neg	a5,s0
  800686:	4629                	li	a2,10
  800688:	46a9                	li	a3,10
  80068a:	b325                	j	8003b2 <vprintfmt+0x15a>
            if (width > 0 && padc != '-') {
  80068c:	03a05063          	blez	s10,8006ac <vprintfmt+0x454>
  800690:	02d00793          	li	a5,45
                p = "(null)";
  800694:	00000417          	auipc	s0,0x0
  800698:	3fc40413          	addi	s0,s0,1020 # 800a90 <main+0x210>
            if (width > 0 && padc != '-') {
  80069c:	f2f814e3          	bne	a6,a5,8005c4 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8006a0:	02800793          	li	a5,40
  8006a4:	02800513          	li	a0,40
  8006a8:	0405                	addi	s0,s0,1
  8006aa:	bd19                	j	8004c0 <vprintfmt+0x268>
  8006ac:	02800513          	li	a0,40
  8006b0:	02800793          	li	a5,40
  8006b4:	00000417          	auipc	s0,0x0
  8006b8:	3dd40413          	addi	s0,s0,989 # 800a91 <main+0x211>
  8006bc:	b511                	j	8004c0 <vprintfmt+0x268>

00000000008006be <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006be:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  8006c0:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006c4:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8006c6:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006c8:	ec06                	sd	ra,24(sp)
  8006ca:	f83a                	sd	a4,48(sp)
  8006cc:	fc3e                	sd	a5,56(sp)
  8006ce:	e0c2                	sd	a6,64(sp)
  8006d0:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8006d2:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8006d4:	b85ff0ef          	jal	ra,800258 <vprintfmt>
}
  8006d8:	60e2                	ld	ra,24(sp)
  8006da:	6161                	addi	sp,sp,80
  8006dc:	8082                	ret

00000000008006de <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  8006de:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  8006e0:	e589                	bnez	a1,8006ea <strnlen+0xc>
  8006e2:	a811                	j	8006f6 <strnlen+0x18>
        cnt ++;
  8006e4:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  8006e6:	00f58863          	beq	a1,a5,8006f6 <strnlen+0x18>
  8006ea:	00f50733          	add	a4,a0,a5
  8006ee:	00074703          	lbu	a4,0(a4)
  8006f2:	fb6d                	bnez	a4,8006e4 <strnlen+0x6>
  8006f4:	85be                	mv	a1,a5
    }
    return cnt;
}
  8006f6:	852e                	mv	a0,a1
  8006f8:	8082                	ret

00000000008006fa <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  8006fa:	8eb2                	mv	t4,a2
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
  8006fc:	fff60e13          	addi	t3,a2,-1
  800700:	16060863          	beqz	a2,800870 <memset+0x176>
  800704:	40a007b3          	neg	a5,a0
  800708:	8b9d                	andi	a5,a5,7
  80070a:	00778713          	addi	a4,a5,7
  80070e:	46ad                	li	a3,11
  800710:	16d76163          	bltu	a4,a3,800872 <memset+0x178>
  800714:	16ee6463          	bltu	t3,a4,80087c <memset+0x182>
  800718:	16078063          	beqz	a5,800878 <memset+0x17e>
        *p ++ = c;
  80071c:	00b50023          	sb	a1,0(a0)
  800720:	4705                	li	a4,1
  800722:	00150f13          	addi	t5,a0,1
    while (n -- > 0) {
  800726:	ffee8e13          	addi	t3,t4,-2
  80072a:	06e78563          	beq	a5,a4,800794 <memset+0x9a>
        *p ++ = c;
  80072e:	00b500a3          	sb	a1,1(a0)
  800732:	4709                	li	a4,2
  800734:	00250f13          	addi	t5,a0,2
    while (n -- > 0) {
  800738:	ffde8e13          	addi	t3,t4,-3
  80073c:	04e78c63          	beq	a5,a4,800794 <memset+0x9a>
        *p ++ = c;
  800740:	00b50123          	sb	a1,2(a0)
  800744:	470d                	li	a4,3
  800746:	00350f13          	addi	t5,a0,3
    while (n -- > 0) {
  80074a:	ffce8e13          	addi	t3,t4,-4
  80074e:	04e78363          	beq	a5,a4,800794 <memset+0x9a>
        *p ++ = c;
  800752:	00b501a3          	sb	a1,3(a0)
  800756:	4711                	li	a4,4
  800758:	00450f13          	addi	t5,a0,4
    while (n -- > 0) {
  80075c:	ffbe8e13          	addi	t3,t4,-5
  800760:	02e78a63          	beq	a5,a4,800794 <memset+0x9a>
        *p ++ = c;
  800764:	00b50223          	sb	a1,4(a0)
  800768:	4715                	li	a4,5
  80076a:	00550f13          	addi	t5,a0,5
    while (n -- > 0) {
  80076e:	ffae8e13          	addi	t3,t4,-6
  800772:	02e78163          	beq	a5,a4,800794 <memset+0x9a>
        *p ++ = c;
  800776:	00b502a3          	sb	a1,5(a0)
  80077a:	471d                	li	a4,7
  80077c:	00650f13          	addi	t5,a0,6
    while (n -- > 0) {
  800780:	ff9e8e13          	addi	t3,t4,-7
  800784:	00e79863          	bne	a5,a4,800794 <memset+0x9a>
        *p ++ = c;
  800788:	00750f13          	addi	t5,a0,7
  80078c:	00b50323          	sb	a1,6(a0)
    while (n -- > 0) {
  800790:	ff8e8e13          	addi	t3,t4,-8
  800794:	00859713          	slli	a4,a1,0x8
  800798:	8f4d                	or	a4,a4,a1
  80079a:	01059313          	slli	t1,a1,0x10
  80079e:	00676333          	or	t1,a4,t1
  8007a2:	01859893          	slli	a7,a1,0x18
  8007a6:	02059813          	slli	a6,a1,0x20
  8007aa:	011368b3          	or	a7,t1,a7
  8007ae:	02859613          	slli	a2,a1,0x28
  8007b2:	0108e833          	or	a6,a7,a6
  8007b6:	40fe8eb3          	sub	t4,t4,a5
  8007ba:	00c86633          	or	a2,a6,a2
  8007be:	03059693          	slli	a3,a1,0x30
  8007c2:	8ed1                	or	a3,a3,a2
  8007c4:	03859713          	slli	a4,a1,0x38
  8007c8:	97aa                	add	a5,a5,a0
  8007ca:	ff8ef613          	andi	a2,t4,-8
  8007ce:	8f55                	or	a4,a4,a3
  8007d0:	00f606b3          	add	a3,a2,a5
        *p ++ = c;
  8007d4:	e398                	sd	a4,0(a5)
    while (n -- > 0) {
  8007d6:	07a1                	addi	a5,a5,8
  8007d8:	fed79ee3          	bne	a5,a3,8007d4 <memset+0xda>
  8007dc:	ff8ef713          	andi	a4,t4,-8
  8007e0:	00ef07b3          	add	a5,t5,a4
  8007e4:	40ee0e33          	sub	t3,t3,a4
  8007e8:	08ee8763          	beq	t4,a4,800876 <memset+0x17c>
        *p ++ = c;
  8007ec:	00b78023          	sb	a1,0(a5)
    while (n -- > 0) {
  8007f0:	080e0063          	beqz	t3,800870 <memset+0x176>
        *p ++ = c;
  8007f4:	00b780a3          	sb	a1,1(a5)
    while (n -- > 0) {
  8007f8:	4705                	li	a4,1
  8007fa:	06ee0b63          	beq	t3,a4,800870 <memset+0x176>
        *p ++ = c;
  8007fe:	00b78123          	sb	a1,2(a5)
    while (n -- > 0) {
  800802:	4709                	li	a4,2
  800804:	06ee0663          	beq	t3,a4,800870 <memset+0x176>
        *p ++ = c;
  800808:	00b781a3          	sb	a1,3(a5)
    while (n -- > 0) {
  80080c:	470d                	li	a4,3
  80080e:	06ee0163          	beq	t3,a4,800870 <memset+0x176>
        *p ++ = c;
  800812:	00b78223          	sb	a1,4(a5)
    while (n -- > 0) {
  800816:	4711                	li	a4,4
  800818:	04ee0c63          	beq	t3,a4,800870 <memset+0x176>
        *p ++ = c;
  80081c:	00b782a3          	sb	a1,5(a5)
    while (n -- > 0) {
  800820:	4715                	li	a4,5
  800822:	04ee0763          	beq	t3,a4,800870 <memset+0x176>
        *p ++ = c;
  800826:	00b78323          	sb	a1,6(a5)
    while (n -- > 0) {
  80082a:	4719                	li	a4,6
  80082c:	04ee0263          	beq	t3,a4,800870 <memset+0x176>
        *p ++ = c;
  800830:	00b783a3          	sb	a1,7(a5)
    while (n -- > 0) {
  800834:	471d                	li	a4,7
  800836:	02ee0d63          	beq	t3,a4,800870 <memset+0x176>
        *p ++ = c;
  80083a:	00b78423          	sb	a1,8(a5)
    while (n -- > 0) {
  80083e:	4721                	li	a4,8
  800840:	02ee0863          	beq	t3,a4,800870 <memset+0x176>
        *p ++ = c;
  800844:	00b784a3          	sb	a1,9(a5)
    while (n -- > 0) {
  800848:	4725                	li	a4,9
  80084a:	02ee0363          	beq	t3,a4,800870 <memset+0x176>
        *p ++ = c;
  80084e:	00b78523          	sb	a1,10(a5)
    while (n -- > 0) {
  800852:	4729                	li	a4,10
  800854:	00ee0e63          	beq	t3,a4,800870 <memset+0x176>
        *p ++ = c;
  800858:	00b785a3          	sb	a1,11(a5)
    while (n -- > 0) {
  80085c:	472d                	li	a4,11
  80085e:	00ee0963          	beq	t3,a4,800870 <memset+0x176>
        *p ++ = c;
  800862:	00b78623          	sb	a1,12(a5)
    while (n -- > 0) {
  800866:	4731                	li	a4,12
  800868:	00ee0463          	beq	t3,a4,800870 <memset+0x176>
        *p ++ = c;
  80086c:	00b786a3          	sb	a1,13(a5)
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  800870:	8082                	ret
  800872:	472d                	li	a4,11
  800874:	b545                	j	800714 <memset+0x1a>
  800876:	8082                	ret
    while (n -- > 0) {
  800878:	8f2a                	mv	t5,a0
  80087a:	bf29                	j	800794 <memset+0x9a>
  80087c:	87aa                	mv	a5,a0
  80087e:	b7bd                	j	8007ec <memset+0xf2>

0000000000800880 <main>:
          j = !j;
     }
}

int
main(void) {
  800880:	711d                	addi	sp,sp,-96
     int i,time;
     memset(pids, 0, sizeof(pids));
  800882:	4651                	li	a2,20
  800884:	4581                	li	a1,0
  800886:	00000517          	auipc	a0,0x0
  80088a:	79250513          	addi	a0,a0,1938 # 801018 <pids>
main(void) {
  80088e:	ec86                	sd	ra,88(sp)
  800890:	e8a2                	sd	s0,80(sp)
  800892:	e4a6                	sd	s1,72(sp)
  800894:	e0ca                	sd	s2,64(sp)
  800896:	fc4e                	sd	s3,56(sp)
  800898:	f852                	sd	s4,48(sp)
  80089a:	f456                	sd	s5,40(sp)
  80089c:	f05a                	sd	s6,32(sp)
  80089e:	ec5e                	sd	s7,24(sp)
     memset(pids, 0, sizeof(pids));
  8008a0:	e5bff0ef          	jal	ra,8006fa <memset>
     lab6_setpriority(TOTAL + 1);
  8008a4:	4519                	li	a0,6
  8008a6:	00000a97          	auipc	s5,0x0
  8008aa:	75aa8a93          	addi	s5,s5,1882 # 801000 <acc>
  8008ae:	00000917          	auipc	s2,0x0
  8008b2:	76a90913          	addi	s2,s2,1898 # 801018 <pids>
  8008b6:	8a9ff0ef          	jal	ra,80015e <lab6_setpriority>

     for (i = 0; i < TOTAL; i ++) {
  8008ba:	89d6                	mv	s3,s5
     lab6_setpriority(TOTAL + 1);
  8008bc:	84ca                	mv	s1,s2
     for (i = 0; i < TOTAL; i ++) {
  8008be:	4401                	li	s0,0
  8008c0:	4a15                	li	s4,5
          acc[i]=0;
  8008c2:	0009a023          	sw	zero,0(s3)
          if ((pids[i] = fork()) == 0) {
  8008c6:	88fff0ef          	jal	ra,800154 <fork>
  8008ca:	c088                	sw	a0,0(s1)
  8008cc:	c969                	beqz	a0,80099e <main+0x11e>
                        }
                    }
               }
               
          }
          if (pids[i] < 0) {
  8008ce:	12054c63          	bltz	a0,800a06 <main+0x186>
     for (i = 0; i < TOTAL; i ++) {
  8008d2:	2405                	addiw	s0,s0,1
  8008d4:	0991                	addi	s3,s3,4
  8008d6:	0491                	addi	s1,s1,4
  8008d8:	ff4415e3          	bne	s0,s4,8008c2 <main+0x42>
               goto failed;
          }
     }

     cprintf("main: fork ok,now need to wait pids.\n");
  8008dc:	00000497          	auipc	s1,0x0
  8008e0:	75448493          	addi	s1,s1,1876 # 801030 <status>
  8008e4:	00000517          	auipc	a0,0x0
  8008e8:	4cc50513          	addi	a0,a0,1228 # 800db0 <error_string+0xe8>
  8008ec:	fb6ff0ef          	jal	ra,8000a2 <cprintf>

     for (i = 0; i < TOTAL; i ++) {
  8008f0:	00000997          	auipc	s3,0x0
  8008f4:	75498993          	addi	s3,s3,1876 # 801044 <status+0x14>
     cprintf("main: fork ok,now need to wait pids.\n");
  8008f8:	8a26                	mv	s4,s1
  8008fa:	8426                	mv	s0,s1
         status[i]=0;
         waitpid(pids[i],&status[i]);
         cprintf("main: pid %d, acc %d, time %d\n",pids[i],status[i],gettime_msec()); 
  8008fc:	00000b97          	auipc	s7,0x0
  800900:	4dcb8b93          	addi	s7,s7,1244 # 800dd8 <error_string+0x110>
         waitpid(pids[i],&status[i]);
  800904:	00092503          	lw	a0,0(s2)
  800908:	85a2                	mv	a1,s0
         status[i]=0;
  80090a:	00042023          	sw	zero,0(s0)
         waitpid(pids[i],&status[i]);
  80090e:	849ff0ef          	jal	ra,800156 <waitpid>
         cprintf("main: pid %d, acc %d, time %d\n",pids[i],status[i],gettime_msec()); 
  800912:	00092a83          	lw	s5,0(s2)
  800916:	00042b03          	lw	s6,0(s0)
  80091a:	843ff0ef          	jal	ra,80015c <gettime_msec>
  80091e:	0005069b          	sext.w	a3,a0
  800922:	865a                	mv	a2,s6
  800924:	85d6                	mv	a1,s5
  800926:	855e                	mv	a0,s7
     for (i = 0; i < TOTAL; i ++) {
  800928:	0411                	addi	s0,s0,4
         cprintf("main: pid %d, acc %d, time %d\n",pids[i],status[i],gettime_msec()); 
  80092a:	f78ff0ef          	jal	ra,8000a2 <cprintf>
     for (i = 0; i < TOTAL; i ++) {
  80092e:	0911                	addi	s2,s2,4
  800930:	fd341ae3          	bne	s0,s3,800904 <main+0x84>
     }
     cprintf("main: wait pids over\n");
  800934:	00000517          	auipc	a0,0x0
  800938:	4c450513          	addi	a0,a0,1220 # 800df8 <error_string+0x130>
  80093c:	f66ff0ef          	jal	ra,8000a2 <cprintf>
     cprintf("sched result:");
  800940:	00000517          	auipc	a0,0x0
  800944:	4d050513          	addi	a0,a0,1232 # 800e10 <error_string+0x148>
  800948:	f5aff0ef          	jal	ra,8000a2 <cprintf>
     for (i = 0; i < TOTAL; i ++)
     {
         cprintf(" %d", (status[i] * 2 / status[0] + 1) / 2);
  80094c:	00000417          	auipc	s0,0x0
  800950:	4d440413          	addi	s0,s0,1236 # 800e20 <error_string+0x158>
  800954:	408c                	lw	a1,0(s1)
  800956:	000a2783          	lw	a5,0(s4)
     for (i = 0; i < TOTAL; i ++)
  80095a:	0491                	addi	s1,s1,4
         cprintf(" %d", (status[i] * 2 / status[0] + 1) / 2);
  80095c:	0015959b          	slliw	a1,a1,0x1
  800960:	02f5c5bb          	divw	a1,a1,a5
  800964:	8522                	mv	a0,s0
  800966:	2585                	addiw	a1,a1,1
  800968:	01f5d79b          	srliw	a5,a1,0x1f
  80096c:	9dbd                	addw	a1,a1,a5
  80096e:	4015d59b          	sraiw	a1,a1,0x1
  800972:	f30ff0ef          	jal	ra,8000a2 <cprintf>
     for (i = 0; i < TOTAL; i ++)
  800976:	fd349fe3          	bne	s1,s3,800954 <main+0xd4>
     }
     cprintf("\n");
  80097a:	00000517          	auipc	a0,0x0
  80097e:	0de50513          	addi	a0,a0,222 # 800a58 <main+0x1d8>
  800982:	f20ff0ef          	jal	ra,8000a2 <cprintf>
          if (pids[i] > 0) {
               kill(pids[i]);
          }
     }
     panic("FAIL: T.T\n");
}
  800986:	60e6                	ld	ra,88(sp)
  800988:	6446                	ld	s0,80(sp)
  80098a:	64a6                	ld	s1,72(sp)
  80098c:	6906                	ld	s2,64(sp)
  80098e:	79e2                	ld	s3,56(sp)
  800990:	7a42                	ld	s4,48(sp)
  800992:	7aa2                	ld	s5,40(sp)
  800994:	7b02                	ld	s6,32(sp)
  800996:	6be2                	ld	s7,24(sp)
  800998:	4501                	li	a0,0
  80099a:	6125                	addi	sp,sp,96
  80099c:	8082                	ret
               lab6_setpriority(i + 1);
  80099e:	0014051b          	addiw	a0,s0,1
               acc[i] = 0;
  8009a2:	040a                	slli	s0,s0,0x2
  8009a4:	9456                	add	s0,s0,s5
                    if(acc[i]%4000==0) {
  8009a6:	6485                	lui	s1,0x1
               lab6_setpriority(i + 1);
  8009a8:	fb6ff0ef          	jal	ra,80015e <lab6_setpriority>
                    if(acc[i]%4000==0) {
  8009ac:	fa04849b          	addiw	s1,s1,-96
               acc[i] = 0;
  8009b0:	00042023          	sw	zero,0(s0)
                        if((time=gettime_msec())>MAX_TIME) {
  8009b4:	7d000993          	li	s3,2000
  8009b8:	4014                	lw	a3,0(s0)
  8009ba:	2685                	addiw	a3,a3,1
     for (i = 0; i != 200; ++ i)
  8009bc:	0c800713          	li	a4,200
          j = !j;
  8009c0:	47b2                	lw	a5,12(sp)
     for (i = 0; i != 200; ++ i)
  8009c2:	377d                	addiw	a4,a4,-1
          j = !j;
  8009c4:	2781                	sext.w	a5,a5
  8009c6:	0017b793          	seqz	a5,a5
  8009ca:	c63e                	sw	a5,12(sp)
     for (i = 0; i != 200; ++ i)
  8009cc:	fb75                	bnez	a4,8009c0 <main+0x140>
                    if(acc[i]%4000==0) {
  8009ce:	0296f7bb          	remuw	a5,a3,s1
  8009d2:	0016871b          	addiw	a4,a3,1
  8009d6:	c399                	beqz	a5,8009dc <main+0x15c>
  8009d8:	86ba                	mv	a3,a4
  8009da:	b7cd                	j	8009bc <main+0x13c>
  8009dc:	c014                	sw	a3,0(s0)
                        if((time=gettime_msec())>MAX_TIME) {
  8009de:	f7eff0ef          	jal	ra,80015c <gettime_msec>
  8009e2:	0005091b          	sext.w	s2,a0
  8009e6:	fd29d9e3          	bge	s3,s2,8009b8 <main+0x138>
                            cprintf("child pid %d, acc %d, time %d\n",getpid(),acc[i],time);
  8009ea:	f70ff0ef          	jal	ra,80015a <getpid>
  8009ee:	4010                	lw	a2,0(s0)
  8009f0:	85aa                	mv	a1,a0
  8009f2:	86ca                	mv	a3,s2
  8009f4:	00000517          	auipc	a0,0x0
  8009f8:	39c50513          	addi	a0,a0,924 # 800d90 <error_string+0xc8>
  8009fc:	ea6ff0ef          	jal	ra,8000a2 <cprintf>
                            exit(acc[i]);
  800a00:	4008                	lw	a0,0(s0)
  800a02:	f3cff0ef          	jal	ra,80013e <exit>
  800a06:	00000417          	auipc	s0,0x0
  800a0a:	62640413          	addi	s0,s0,1574 # 80102c <pids+0x14>
          if (pids[i] > 0) {
  800a0e:	00092503          	lw	a0,0(s2)
  800a12:	00a05463          	blez	a0,800a1a <main+0x19a>
               kill(pids[i]);
  800a16:	f42ff0ef          	jal	ra,800158 <kill>
     for (i = 0; i < TOTAL; i ++) {
  800a1a:	0911                	addi	s2,s2,4
  800a1c:	fe8919e3          	bne	s2,s0,800a0e <main+0x18e>
     panic("FAIL: T.T\n");
  800a20:	00000617          	auipc	a2,0x0
  800a24:	40860613          	addi	a2,a2,1032 # 800e28 <error_string+0x160>
  800a28:	04b00593          	li	a1,75
  800a2c:	00000517          	auipc	a0,0x0
  800a30:	40c50513          	addi	a0,a0,1036 # 800e38 <error_string+0x170>
  800a34:	df2ff0ef          	jal	ra,800026 <__panic>
