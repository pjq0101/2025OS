
obj/__user_waitkill.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	136000ef          	jal	ra,800156 <umain>
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
  800036:	00000517          	auipc	a0,0x0
  80003a:	7ea50513          	addi	a0,a0,2026 # 800820 <main+0xac>
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
  80005a:	b2250513          	addi	a0,a0,-1246 # 800b78 <error_string+0xd0>
  80005e:	044000ef          	jal	ra,8000a2 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800062:	5559                	li	a0,-10
  800064:	0d2000ef          	jal	ra,800136 <exit>

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
  800070:	0c0000ef          	jal	ra,800130 <sys_putc>
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
  800096:	1b4000ef          	jal	ra,80024a <vprintfmt>
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
  8000cc:	17e000ef          	jal	ra,80024a <vprintfmt>
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

0000000000800122 <sys_yield>:
}

int
sys_yield(void) {
    return syscall(SYS_yield);
  800122:	4529                	li	a0,10
  800124:	bf55                	j	8000d8 <syscall>

0000000000800126 <sys_kill>:
}

int
sys_kill(int64_t pid) {
  800126:	85aa                	mv	a1,a0
    return syscall(SYS_kill, pid);
  800128:	4531                	li	a0,12
  80012a:	b77d                	j	8000d8 <syscall>

000000000080012c <sys_getpid>:
}

int
sys_getpid(void) {
    return syscall(SYS_getpid);
  80012c:	4549                	li	a0,18
  80012e:	b76d                	j	8000d8 <syscall>

0000000000800130 <sys_putc>:
}

int
sys_putc(int64_t c) {
  800130:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  800132:	4579                	li	a0,30
  800134:	b755                	j	8000d8 <syscall>

0000000000800136 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  800136:	1141                	addi	sp,sp,-16
  800138:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  80013a:	fd7ff0ef          	jal	ra,800110 <sys_exit>
    cprintf("BUG: exit failed.\n");
  80013e:	00000517          	auipc	a0,0x0
  800142:	70250513          	addi	a0,a0,1794 # 800840 <main+0xcc>
  800146:	f5dff0ef          	jal	ra,8000a2 <cprintf>
    while (1);
  80014a:	a001                	j	80014a <exit+0x14>

000000000080014c <fork>:
}

int
fork(void) {
    return sys_fork();
  80014c:	b7e9                	j	800116 <sys_fork>

000000000080014e <waitpid>:
    return sys_wait(0, NULL);
}

int
waitpid(int pid, int *store) {
    return sys_wait(pid, store);
  80014e:	b7f1                	j	80011a <sys_wait>

0000000000800150 <yield>:
}

void
yield(void) {
    sys_yield();
  800150:	bfc9                	j	800122 <sys_yield>

0000000000800152 <kill>:
}

int
kill(int pid) {
    return sys_kill(pid);
  800152:	bfd1                	j	800126 <sys_kill>

0000000000800154 <getpid>:
}

int
getpid(void) {
    return sys_getpid();
  800154:	bfe1                	j	80012c <sys_getpid>

0000000000800156 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  800156:	1141                	addi	sp,sp,-16
  800158:	e406                	sd	ra,8(sp)
    int ret = main();
  80015a:	61a000ef          	jal	ra,800774 <main>
    exit(ret);
  80015e:	fd9ff0ef          	jal	ra,800136 <exit>

0000000000800162 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  800162:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800166:	7139                	addi	sp,sp,-64
    unsigned mod = do_div(result, base);
  800168:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  80016c:	e852                	sd	s4,16(sp)
    unsigned mod = do_div(result, base);
  80016e:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  800172:	f426                	sd	s1,40(sp)
  800174:	f04a                	sd	s2,32(sp)
  800176:	ec4e                	sd	s3,24(sp)
  800178:	fc06                	sd	ra,56(sp)
  80017a:	f822                	sd	s0,48(sp)
  80017c:	e456                	sd	s5,8(sp)
  80017e:	e05a                	sd	s6,0(sp)
  800180:	84aa                	mv	s1,a0
  800182:	892e                	mv	s2,a1
  800184:	89be                	mv	s3,a5
    unsigned mod = do_div(result, base);
  800186:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  800188:	05067163          	bgeu	a2,a6,8001ca <printnum+0x68>
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  80018c:	fff7041b          	addiw	s0,a4,-1
  800190:	00805763          	blez	s0,80019e <printnum+0x3c>
  800194:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800196:	85ca                	mv	a1,s2
  800198:	854e                	mv	a0,s3
  80019a:	9482                	jalr	s1
        while (-- width > 0)
  80019c:	fc65                	bnez	s0,800194 <printnum+0x32>
  80019e:	00000417          	auipc	s0,0x0
  8001a2:	6ba40413          	addi	s0,s0,1722 # 800858 <main+0xe4>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  8001a6:	1a02                	slli	s4,s4,0x20
  8001a8:	020a5a13          	srli	s4,s4,0x20
  8001ac:	9452                	add	s0,s0,s4
  8001ae:	00044503          	lbu	a0,0(s0)
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  8001b2:	7442                	ld	s0,48(sp)
  8001b4:	70e2                	ld	ra,56(sp)
  8001b6:	69e2                	ld	s3,24(sp)
  8001b8:	6a42                	ld	s4,16(sp)
  8001ba:	6aa2                	ld	s5,8(sp)
  8001bc:	6b02                	ld	s6,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001be:	85ca                	mv	a1,s2
  8001c0:	87a6                	mv	a5,s1
}
  8001c2:	7902                	ld	s2,32(sp)
  8001c4:	74a2                	ld	s1,40(sp)
  8001c6:	6121                	addi	sp,sp,64
    putch("0123456789abcdef"[mod], putdat);
  8001c8:	8782                	jr	a5
    unsigned mod = do_div(result, base);
  8001ca:	03065633          	divu	a2,a2,a6
  8001ce:	03067ab3          	remu	s5,a2,a6
  8001d2:	2a81                	sext.w	s5,s5
    if (num >= base) {
  8001d4:	03067863          	bgeu	a2,a6,800204 <printnum+0xa2>
        while (-- width > 0)
  8001d8:	ffe7041b          	addiw	s0,a4,-2
  8001dc:	00805763          	blez	s0,8001ea <printnum+0x88>
  8001e0:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  8001e2:	85ca                	mv	a1,s2
  8001e4:	854e                	mv	a0,s3
  8001e6:	9482                	jalr	s1
        while (-- width > 0)
  8001e8:	fc65                	bnez	s0,8001e0 <printnum+0x7e>
  8001ea:	00000417          	auipc	s0,0x0
  8001ee:	66e40413          	addi	s0,s0,1646 # 800858 <main+0xe4>
    putch("0123456789abcdef"[mod], putdat);
  8001f2:	1a82                	slli	s5,s5,0x20
  8001f4:	020ada93          	srli	s5,s5,0x20
  8001f8:	9aa2                	add	s5,s5,s0
  8001fa:	000ac503          	lbu	a0,0(s5)
  8001fe:	85ca                	mv	a1,s2
  800200:	9482                	jalr	s1
}
  800202:	b755                	j	8001a6 <printnum+0x44>
    unsigned mod = do_div(result, base);
  800204:	03065633          	divu	a2,a2,a6
        while (-- width > 0)
  800208:	ffd7041b          	addiw	s0,a4,-3
    unsigned mod = do_div(result, base);
  80020c:	03067b33          	remu	s6,a2,a6
  800210:	2b01                	sext.w	s6,s6
    if (num >= base) {
  800212:	03067663          	bgeu	a2,a6,80023e <printnum+0xdc>
        while (-- width > 0)
  800216:	00805763          	blez	s0,800224 <printnum+0xc2>
  80021a:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  80021c:	85ca                	mv	a1,s2
  80021e:	854e                	mv	a0,s3
  800220:	9482                	jalr	s1
        while (-- width > 0)
  800222:	fc65                	bnez	s0,80021a <printnum+0xb8>
    putch("0123456789abcdef"[mod], putdat);
  800224:	1b02                	slli	s6,s6,0x20
  800226:	00000417          	auipc	s0,0x0
  80022a:	63240413          	addi	s0,s0,1586 # 800858 <main+0xe4>
  80022e:	020b5b13          	srli	s6,s6,0x20
  800232:	9b22                	add	s6,s6,s0
  800234:	000b4503          	lbu	a0,0(s6)
  800238:	85ca                	mv	a1,s2
  80023a:	9482                	jalr	s1
}
  80023c:	bf5d                	j	8001f2 <printnum+0x90>
        printnum(putch, putdat, result, base, width - 1, padc);
  80023e:	03065633          	divu	a2,a2,a6
  800242:	8722                	mv	a4,s0
  800244:	f1fff0ef          	jal	ra,800162 <printnum>
  800248:	bff1                	j	800224 <printnum+0xc2>

000000000080024a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  80024a:	7119                	addi	sp,sp,-128
  80024c:	f4a6                	sd	s1,104(sp)
  80024e:	f0ca                	sd	s2,96(sp)
  800250:	ecce                	sd	s3,88(sp)
  800252:	e8d2                	sd	s4,80(sp)
  800254:	e4d6                	sd	s5,72(sp)
  800256:	e0da                	sd	s6,64(sp)
  800258:	fc5e                	sd	s7,56(sp)
  80025a:	f466                	sd	s9,40(sp)
  80025c:	fc86                	sd	ra,120(sp)
  80025e:	f8a2                	sd	s0,112(sp)
  800260:	f862                	sd	s8,48(sp)
  800262:	f06a                	sd	s10,32(sp)
  800264:	ec6e                	sd	s11,24(sp)
  800266:	892a                	mv	s2,a0
  800268:	84ae                	mv	s1,a1
  80026a:	8cb2                	mv	s9,a2
  80026c:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80026e:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  800272:	5bfd                	li	s7,-1
  800274:	00000a97          	auipc	s5,0x0
  800278:	618a8a93          	addi	s5,s5,1560 # 80088c <main+0x118>
    putch("0123456789abcdef"[mod], putdat);
  80027c:	00000b17          	auipc	s6,0x0
  800280:	5dcb0b13          	addi	s6,s6,1500 # 800858 <main+0xe4>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800284:	000cc503          	lbu	a0,0(s9)
  800288:	001c8413          	addi	s0,s9,1
  80028c:	01350a63          	beq	a0,s3,8002a0 <vprintfmt+0x56>
            if (ch == '\0') {
  800290:	c121                	beqz	a0,8002d0 <vprintfmt+0x86>
            putch(ch, putdat);
  800292:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800294:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  800296:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800298:	fff44503          	lbu	a0,-1(s0)
  80029c:	ff351ae3          	bne	a0,s3,800290 <vprintfmt+0x46>
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  8002a0:	00044683          	lbu	a3,0(s0)
        char padc = ' ';
  8002a4:	02000813          	li	a6,32
        lflag = altflag = 0;
  8002a8:	4d81                	li	s11,0
  8002aa:	4501                	li	a0,0
        width = precision = -1;
  8002ac:	5c7d                	li	s8,-1
  8002ae:	5d7d                	li	s10,-1
  8002b0:	05500613          	li	a2,85
        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
  8002b4:	45a5                	li	a1,9
        switch (ch = *(unsigned char *)fmt ++) {
  8002b6:	fdd6879b          	addiw	a5,a3,-35
  8002ba:	0ff7f793          	zext.b	a5,a5
  8002be:	00140c93          	addi	s9,s0,1
  8002c2:	04f66263          	bltu	a2,a5,800306 <vprintfmt+0xbc>
  8002c6:	078a                	slli	a5,a5,0x2
  8002c8:	97d6                	add	a5,a5,s5
  8002ca:	439c                	lw	a5,0(a5)
  8002cc:	97d6                	add	a5,a5,s5
  8002ce:	8782                	jr	a5
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8002d0:	70e6                	ld	ra,120(sp)
  8002d2:	7446                	ld	s0,112(sp)
  8002d4:	74a6                	ld	s1,104(sp)
  8002d6:	7906                	ld	s2,96(sp)
  8002d8:	69e6                	ld	s3,88(sp)
  8002da:	6a46                	ld	s4,80(sp)
  8002dc:	6aa6                	ld	s5,72(sp)
  8002de:	6b06                	ld	s6,64(sp)
  8002e0:	7be2                	ld	s7,56(sp)
  8002e2:	7c42                	ld	s8,48(sp)
  8002e4:	7ca2                	ld	s9,40(sp)
  8002e6:	7d02                	ld	s10,32(sp)
  8002e8:	6de2                	ld	s11,24(sp)
  8002ea:	6109                	addi	sp,sp,128
  8002ec:	8082                	ret
            padc = '0';
  8002ee:	8836                	mv	a6,a3
            goto reswitch;
  8002f0:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  8002f4:	8466                	mv	s0,s9
  8002f6:	00140c93          	addi	s9,s0,1
  8002fa:	fdd6879b          	addiw	a5,a3,-35
  8002fe:	0ff7f793          	zext.b	a5,a5
  800302:	fcf672e3          	bgeu	a2,a5,8002c6 <vprintfmt+0x7c>
            putch('%', putdat);
  800306:	85a6                	mv	a1,s1
  800308:	02500513          	li	a0,37
  80030c:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  80030e:	fff44783          	lbu	a5,-1(s0)
  800312:	8ca2                	mv	s9,s0
  800314:	f73788e3          	beq	a5,s3,800284 <vprintfmt+0x3a>
  800318:	ffecc783          	lbu	a5,-2(s9)
  80031c:	1cfd                	addi	s9,s9,-1
  80031e:	ff379de3          	bne	a5,s3,800318 <vprintfmt+0xce>
  800322:	b78d                	j	800284 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  800324:	fd068c1b          	addiw	s8,a3,-48
                ch = *fmt;
  800328:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  80032c:	8466                	mv	s0,s9
                if (ch < '0' || ch > '9') {
  80032e:	fd06879b          	addiw	a5,a3,-48
                ch = *fmt;
  800332:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  800336:	02f5e563          	bltu	a1,a5,800360 <vprintfmt+0x116>
                ch = *fmt;
  80033a:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
  80033e:	002c179b          	slliw	a5,s8,0x2
  800342:	0187873b          	addw	a4,a5,s8
  800346:	0017171b          	slliw	a4,a4,0x1
  80034a:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
  80034e:	fd06879b          	addiw	a5,a3,-48
            for (precision = 0; ; ++ fmt) {
  800352:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  800354:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  800358:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  80035c:	fcf5ffe3          	bgeu	a1,a5,80033a <vprintfmt+0xf0>
            if (width < 0)
  800360:	f40d5be3          	bgez	s10,8002b6 <vprintfmt+0x6c>
                width = precision, precision = -1;
  800364:	8d62                	mv	s10,s8
  800366:	5c7d                	li	s8,-1
  800368:	b7b9                	j	8002b6 <vprintfmt+0x6c>
            if (width < 0)
  80036a:	fffd4793          	not	a5,s10
  80036e:	97fd                	srai	a5,a5,0x3f
  800370:	00fd7d33          	and	s10,s10,a5
        switch (ch = *(unsigned char *)fmt ++) {
  800374:	00144683          	lbu	a3,1(s0)
  800378:	2d01                	sext.w	s10,s10
  80037a:	8466                	mv	s0,s9
            goto reswitch;
  80037c:	bf2d                	j	8002b6 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  80037e:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  800382:	00144683          	lbu	a3,1(s0)
            precision = va_arg(ap, int);
  800386:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  800388:	8466                	mv	s0,s9
            goto process_precision;
  80038a:	bfd9                	j	800360 <vprintfmt+0x116>
    if (lflag >= 2) {
  80038c:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80038e:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800392:	00a7c463          	blt	a5,a0,80039a <vprintfmt+0x150>
    else if (lflag) {
  800396:	28050a63          	beqz	a0,80062a <vprintfmt+0x3e0>
        return va_arg(*ap, unsigned long);
  80039a:	000a3783          	ld	a5,0(s4)
  80039e:	4641                	li	a2,16
  8003a0:	8a3a                	mv	s4,a4
  8003a2:	46c1                	li	a3,16
    unsigned mod = do_div(result, base);
  8003a4:	02c7fdb3          	remu	s11,a5,a2
            printnum(putch, putdat, num, base, width, padc);
  8003a8:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  8003ac:	0ac7f563          	bgeu	a5,a2,800456 <vprintfmt+0x20c>
        while (-- width > 0)
  8003b0:	3d7d                	addiw	s10,s10,-1
  8003b2:	01a05863          	blez	s10,8003c2 <vprintfmt+0x178>
  8003b6:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  8003b8:	85a6                	mv	a1,s1
  8003ba:	8562                	mv	a0,s8
  8003bc:	9902                	jalr	s2
        while (-- width > 0)
  8003be:	fe0d1ce3          	bnez	s10,8003b6 <vprintfmt+0x16c>
    putch("0123456789abcdef"[mod], putdat);
  8003c2:	9dda                	add	s11,s11,s6
  8003c4:	000dc503          	lbu	a0,0(s11)
  8003c8:	85a6                	mv	a1,s1
  8003ca:	9902                	jalr	s2
}
  8003cc:	bd65                	j	800284 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  8003ce:	000a2503          	lw	a0,0(s4)
  8003d2:	85a6                	mv	a1,s1
  8003d4:	0a21                	addi	s4,s4,8
  8003d6:	9902                	jalr	s2
            break;
  8003d8:	b575                	j	800284 <vprintfmt+0x3a>
    if (lflag >= 2) {
  8003da:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8003dc:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  8003e0:	00a7c463          	blt	a5,a0,8003e8 <vprintfmt+0x19e>
    else if (lflag) {
  8003e4:	22050d63          	beqz	a0,80061e <vprintfmt+0x3d4>
        return va_arg(*ap, unsigned long);
  8003e8:	000a3783          	ld	a5,0(s4)
  8003ec:	4629                	li	a2,10
  8003ee:	8a3a                	mv	s4,a4
  8003f0:	46a9                	li	a3,10
  8003f2:	bf4d                	j	8003a4 <vprintfmt+0x15a>
        switch (ch = *(unsigned char *)fmt ++) {
  8003f4:	00144683          	lbu	a3,1(s0)
            altflag = 1;
  8003f8:	4d85                	li	s11,1
        switch (ch = *(unsigned char *)fmt ++) {
  8003fa:	8466                	mv	s0,s9
            goto reswitch;
  8003fc:	bd6d                	j	8002b6 <vprintfmt+0x6c>
            putch(ch, putdat);
  8003fe:	85a6                	mv	a1,s1
  800400:	02500513          	li	a0,37
  800404:	9902                	jalr	s2
            break;
  800406:	bdbd                	j	800284 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  800408:	00144683          	lbu	a3,1(s0)
            lflag ++;
  80040c:	2505                	addiw	a0,a0,1
        switch (ch = *(unsigned char *)fmt ++) {
  80040e:	8466                	mv	s0,s9
            goto reswitch;
  800410:	b55d                	j	8002b6 <vprintfmt+0x6c>
    if (lflag >= 2) {
  800412:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800414:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800418:	00a7c463          	blt	a5,a0,800420 <vprintfmt+0x1d6>
    else if (lflag) {
  80041c:	1e050b63          	beqz	a0,800612 <vprintfmt+0x3c8>
        return va_arg(*ap, unsigned long);
  800420:	000a3783          	ld	a5,0(s4)
  800424:	4621                	li	a2,8
  800426:	8a3a                	mv	s4,a4
  800428:	46a1                	li	a3,8
  80042a:	bfad                	j	8003a4 <vprintfmt+0x15a>
            putch('0', putdat);
  80042c:	03000513          	li	a0,48
  800430:	85a6                	mv	a1,s1
  800432:	e042                	sd	a6,0(sp)
  800434:	9902                	jalr	s2
            putch('x', putdat);
  800436:	85a6                	mv	a1,s1
  800438:	07800513          	li	a0,120
  80043c:	9902                	jalr	s2
            goto number;
  80043e:	6802                	ld	a6,0(sp)
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800440:	000a3783          	ld	a5,0(s4)
            goto number;
  800444:	4641                	li	a2,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800446:	0a21                	addi	s4,s4,8
    unsigned mod = do_div(result, base);
  800448:	02c7fdb3          	remu	s11,a5,a2
            goto number;
  80044c:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
  80044e:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  800452:	f4c7efe3          	bltu	a5,a2,8003b0 <vprintfmt+0x166>
        while (-- width > 0)
  800456:	3d79                	addiw	s10,s10,-2
    unsigned mod = do_div(result, base);
  800458:	02c7d7b3          	divu	a5,a5,a2
  80045c:	02c7f433          	remu	s0,a5,a2
    if (num >= base) {
  800460:	10c7f463          	bgeu	a5,a2,800568 <vprintfmt+0x31e>
        while (-- width > 0)
  800464:	01a05863          	blez	s10,800474 <vprintfmt+0x22a>
  800468:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  80046a:	85a6                	mv	a1,s1
  80046c:	8562                	mv	a0,s8
  80046e:	9902                	jalr	s2
        while (-- width > 0)
  800470:	fe0d1ce3          	bnez	s10,800468 <vprintfmt+0x21e>
    putch("0123456789abcdef"[mod], putdat);
  800474:	945a                	add	s0,s0,s6
  800476:	00044503          	lbu	a0,0(s0)
  80047a:	85a6                	mv	a1,s1
  80047c:	9dda                	add	s11,s11,s6
  80047e:	9902                	jalr	s2
  800480:	000dc503          	lbu	a0,0(s11)
  800484:	85a6                	mv	a1,s1
  800486:	9902                	jalr	s2
  800488:	bbf5                	j	800284 <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
  80048a:	000a3403          	ld	s0,0(s4)
  80048e:	008a0793          	addi	a5,s4,8
  800492:	e43e                	sd	a5,8(sp)
  800494:	1e040563          	beqz	s0,80067e <vprintfmt+0x434>
            if (width > 0 && padc != '-') {
  800498:	15a05263          	blez	s10,8005dc <vprintfmt+0x392>
  80049c:	02d00793          	li	a5,45
  8004a0:	10f81b63          	bne	a6,a5,8005b6 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004a4:	00044783          	lbu	a5,0(s0)
  8004a8:	0007851b          	sext.w	a0,a5
  8004ac:	0e078c63          	beqz	a5,8005a4 <vprintfmt+0x35a>
  8004b0:	0405                	addi	s0,s0,1
  8004b2:	120d8e63          	beqz	s11,8005ee <vprintfmt+0x3a4>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004b6:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004ba:	020c4963          	bltz	s8,8004ec <vprintfmt+0x2a2>
  8004be:	fffc0a1b          	addiw	s4,s8,-1
  8004c2:	0d7a0f63          	beq	s4,s7,8005a0 <vprintfmt+0x356>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004c6:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  8004c8:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8004ca:	02fdf663          	bgeu	s11,a5,8004f6 <vprintfmt+0x2ac>
                    putch('?', putdat);
  8004ce:	03f00513          	li	a0,63
  8004d2:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004d4:	00044783          	lbu	a5,0(s0)
  8004d8:	3d7d                	addiw	s10,s10,-1
  8004da:	0405                	addi	s0,s0,1
  8004dc:	0007851b          	sext.w	a0,a5
  8004e0:	c3e1                	beqz	a5,8005a0 <vprintfmt+0x356>
  8004e2:	140c4a63          	bltz	s8,800636 <vprintfmt+0x3ec>
  8004e6:	8c52                	mv	s8,s4
  8004e8:	fc0c5be3          	bgez	s8,8004be <vprintfmt+0x274>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004ec:	3781                	addiw	a5,a5,-32
  8004ee:	8a62                	mv	s4,s8
                    putch('?', putdat);
  8004f0:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8004f2:	fcfdeee3          	bltu	s11,a5,8004ce <vprintfmt+0x284>
                    putch(ch, putdat);
  8004f6:	9902                	jalr	s2
  8004f8:	bff1                	j	8004d4 <vprintfmt+0x28a>
    if (lflag >= 2) {
  8004fa:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8004fc:	008a0d93          	addi	s11,s4,8
    if (lflag >= 2) {
  800500:	00a7c463          	blt	a5,a0,800508 <vprintfmt+0x2be>
    else if (lflag) {
  800504:	10050463          	beqz	a0,80060c <vprintfmt+0x3c2>
        return va_arg(*ap, long);
  800508:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  80050c:	14044d63          	bltz	s0,800666 <vprintfmt+0x41c>
            num = getint(&ap, lflag);
  800510:	87a2                	mv	a5,s0
  800512:	8a6e                	mv	s4,s11
  800514:	4629                	li	a2,10
  800516:	46a9                	li	a3,10
  800518:	b571                	j	8003a4 <vprintfmt+0x15a>
            err = va_arg(ap, int);
  80051a:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80051e:	4761                	li	a4,24
            err = va_arg(ap, int);
  800520:	0a21                	addi	s4,s4,8
            if (err < 0) {
  800522:	41f7d69b          	sraiw	a3,a5,0x1f
  800526:	8fb5                	xor	a5,a5,a3
  800528:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80052c:	02d74563          	blt	a4,a3,800556 <vprintfmt+0x30c>
  800530:	00369713          	slli	a4,a3,0x3
  800534:	00000797          	auipc	a5,0x0
  800538:	57478793          	addi	a5,a5,1396 # 800aa8 <error_string>
  80053c:	97ba                	add	a5,a5,a4
  80053e:	639c                	ld	a5,0(a5)
  800540:	cb99                	beqz	a5,800556 <vprintfmt+0x30c>
                printfmt(putch, putdat, "%s", p);
  800542:	86be                	mv	a3,a5
  800544:	00000617          	auipc	a2,0x0
  800548:	34460613          	addi	a2,a2,836 # 800888 <main+0x114>
  80054c:	85a6                	mv	a1,s1
  80054e:	854a                	mv	a0,s2
  800550:	160000ef          	jal	ra,8006b0 <printfmt>
  800554:	bb05                	j	800284 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  800556:	00000617          	auipc	a2,0x0
  80055a:	32260613          	addi	a2,a2,802 # 800878 <main+0x104>
  80055e:	85a6                	mv	a1,s1
  800560:	854a                	mv	a0,s2
  800562:	14e000ef          	jal	ra,8006b0 <printfmt>
  800566:	bb39                	j	800284 <vprintfmt+0x3a>
        printnum(putch, putdat, result, base, width - 1, padc);
  800568:	02c7d633          	divu	a2,a5,a2
  80056c:	876a                	mv	a4,s10
  80056e:	87e2                	mv	a5,s8
  800570:	85a6                	mv	a1,s1
  800572:	854a                	mv	a0,s2
  800574:	befff0ef          	jal	ra,800162 <printnum>
  800578:	bdf5                	j	800474 <vprintfmt+0x22a>
                    putch(ch, putdat);
  80057a:	85a6                	mv	a1,s1
  80057c:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80057e:	00044503          	lbu	a0,0(s0)
  800582:	3d7d                	addiw	s10,s10,-1
  800584:	0405                	addi	s0,s0,1
  800586:	cd09                	beqz	a0,8005a0 <vprintfmt+0x356>
  800588:	008d0d3b          	addw	s10,s10,s0
  80058c:	fffd0d9b          	addiw	s11,s10,-1
                    putch(ch, putdat);
  800590:	85a6                	mv	a1,s1
  800592:	408d8d3b          	subw	s10,s11,s0
  800596:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800598:	00044503          	lbu	a0,0(s0)
  80059c:	0405                	addi	s0,s0,1
  80059e:	f96d                	bnez	a0,800590 <vprintfmt+0x346>
            for (; width > 0; width --) {
  8005a0:	01a05963          	blez	s10,8005b2 <vprintfmt+0x368>
  8005a4:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
  8005a6:	85a6                	mv	a1,s1
  8005a8:	02000513          	li	a0,32
  8005ac:	9902                	jalr	s2
            for (; width > 0; width --) {
  8005ae:	fe0d1be3          	bnez	s10,8005a4 <vprintfmt+0x35a>
            if ((p = va_arg(ap, char *)) == NULL) {
  8005b2:	6a22                	ld	s4,8(sp)
  8005b4:	b9c1                	j	800284 <vprintfmt+0x3a>
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005b6:	85e2                	mv	a1,s8
  8005b8:	8522                	mv	a0,s0
  8005ba:	e042                	sd	a6,0(sp)
  8005bc:	114000ef          	jal	ra,8006d0 <strnlen>
  8005c0:	40ad0d3b          	subw	s10,s10,a0
  8005c4:	01a05c63          	blez	s10,8005dc <vprintfmt+0x392>
                    putch(padc, putdat);
  8005c8:	6802                	ld	a6,0(sp)
  8005ca:	0008051b          	sext.w	a0,a6
  8005ce:	85a6                	mv	a1,s1
  8005d0:	e02a                	sd	a0,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005d2:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
  8005d4:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005d6:	6502                	ld	a0,0(sp)
  8005d8:	fe0d1be3          	bnez	s10,8005ce <vprintfmt+0x384>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005dc:	00044783          	lbu	a5,0(s0)
  8005e0:	0405                	addi	s0,s0,1
  8005e2:	0007851b          	sext.w	a0,a5
  8005e6:	ec0796e3          	bnez	a5,8004b2 <vprintfmt+0x268>
            if ((p = va_arg(ap, char *)) == NULL) {
  8005ea:	6a22                	ld	s4,8(sp)
  8005ec:	b961                	j	800284 <vprintfmt+0x3a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005ee:	f80c46e3          	bltz	s8,80057a <vprintfmt+0x330>
  8005f2:	3c7d                	addiw	s8,s8,-1
  8005f4:	fb7c06e3          	beq	s8,s7,8005a0 <vprintfmt+0x356>
                    putch(ch, putdat);
  8005f8:	85a6                	mv	a1,s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005fa:	0405                	addi	s0,s0,1
                    putch(ch, putdat);
  8005fc:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005fe:	fff44503          	lbu	a0,-1(s0)
  800602:	3d7d                	addiw	s10,s10,-1
  800604:	f56d                	bnez	a0,8005ee <vprintfmt+0x3a4>
            for (; width > 0; width --) {
  800606:	f9a04fe3          	bgtz	s10,8005a4 <vprintfmt+0x35a>
  80060a:	b765                	j	8005b2 <vprintfmt+0x368>
        return va_arg(*ap, int);
  80060c:	000a2403          	lw	s0,0(s4)
  800610:	bdf5                	j	80050c <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned int);
  800612:	000a6783          	lwu	a5,0(s4)
  800616:	4621                	li	a2,8
  800618:	8a3a                	mv	s4,a4
  80061a:	46a1                	li	a3,8
  80061c:	b361                	j	8003a4 <vprintfmt+0x15a>
  80061e:	000a6783          	lwu	a5,0(s4)
  800622:	4629                	li	a2,10
  800624:	8a3a                	mv	s4,a4
  800626:	46a9                	li	a3,10
  800628:	bbb5                	j	8003a4 <vprintfmt+0x15a>
  80062a:	000a6783          	lwu	a5,0(s4)
  80062e:	4641                	li	a2,16
  800630:	8a3a                	mv	s4,a4
  800632:	46c1                	li	a3,16
  800634:	bb85                	j	8003a4 <vprintfmt+0x15a>
  800636:	01a40d3b          	addw	s10,s0,s10
                if (altflag && (ch < ' ' || ch > '~')) {
  80063a:	05e00d93          	li	s11,94
  80063e:	3d7d                	addiw	s10,s10,-1
  800640:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  800642:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800644:	00fdf463          	bgeu	s11,a5,80064c <vprintfmt+0x402>
                    putch('?', putdat);
  800648:	03f00513          	li	a0,63
  80064c:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80064e:	00044783          	lbu	a5,0(s0)
  800652:	408d073b          	subw	a4,s10,s0
  800656:	0405                	addi	s0,s0,1
  800658:	0007851b          	sext.w	a0,a5
  80065c:	f3f5                	bnez	a5,800640 <vprintfmt+0x3f6>
  80065e:	8d3a                	mv	s10,a4
            for (; width > 0; width --) {
  800660:	f5a042e3          	bgtz	s10,8005a4 <vprintfmt+0x35a>
  800664:	b7b9                	j	8005b2 <vprintfmt+0x368>
                putch('-', putdat);
  800666:	85a6                	mv	a1,s1
  800668:	02d00513          	li	a0,45
  80066c:	e042                	sd	a6,0(sp)
  80066e:	9902                	jalr	s2
                num = -(long long)num;
  800670:	6802                	ld	a6,0(sp)
  800672:	8a6e                	mv	s4,s11
  800674:	408007b3          	neg	a5,s0
  800678:	4629                	li	a2,10
  80067a:	46a9                	li	a3,10
  80067c:	b325                	j	8003a4 <vprintfmt+0x15a>
            if (width > 0 && padc != '-') {
  80067e:	03a05063          	blez	s10,80069e <vprintfmt+0x454>
  800682:	02d00793          	li	a5,45
                p = "(null)";
  800686:	00000417          	auipc	s0,0x0
  80068a:	1ea40413          	addi	s0,s0,490 # 800870 <main+0xfc>
            if (width > 0 && padc != '-') {
  80068e:	f2f814e3          	bne	a6,a5,8005b6 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800692:	02800793          	li	a5,40
  800696:	02800513          	li	a0,40
  80069a:	0405                	addi	s0,s0,1
  80069c:	bd19                	j	8004b2 <vprintfmt+0x268>
  80069e:	02800513          	li	a0,40
  8006a2:	02800793          	li	a5,40
  8006a6:	00000417          	auipc	s0,0x0
  8006aa:	1cb40413          	addi	s0,s0,459 # 800871 <main+0xfd>
  8006ae:	b511                	j	8004b2 <vprintfmt+0x268>

00000000008006b0 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006b0:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  8006b2:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006b6:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8006b8:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006ba:	ec06                	sd	ra,24(sp)
  8006bc:	f83a                	sd	a4,48(sp)
  8006be:	fc3e                	sd	a5,56(sp)
  8006c0:	e0c2                	sd	a6,64(sp)
  8006c2:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8006c4:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8006c6:	b85ff0ef          	jal	ra,80024a <vprintfmt>
}
  8006ca:	60e2                	ld	ra,24(sp)
  8006cc:	6161                	addi	sp,sp,80
  8006ce:	8082                	ret

00000000008006d0 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  8006d0:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  8006d2:	e589                	bnez	a1,8006dc <strnlen+0xc>
  8006d4:	a811                	j	8006e8 <strnlen+0x18>
        cnt ++;
  8006d6:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  8006d8:	00f58863          	beq	a1,a5,8006e8 <strnlen+0x18>
  8006dc:	00f50733          	add	a4,a0,a5
  8006e0:	00074703          	lbu	a4,0(a4)
  8006e4:	fb6d                	bnez	a4,8006d6 <strnlen+0x6>
  8006e6:	85be                	mv	a1,a5
    }
    return cnt;
}
  8006e8:	852e                	mv	a0,a1
  8006ea:	8082                	ret

00000000008006ec <do_yield>:
#include <ulib.h>
#include <stdio.h>

void
do_yield(void) {
  8006ec:	1141                	addi	sp,sp,-16
  8006ee:	e406                	sd	ra,8(sp)
    yield();
  8006f0:	a61ff0ef          	jal	ra,800150 <yield>
    yield();
  8006f4:	a5dff0ef          	jal	ra,800150 <yield>
    yield();
  8006f8:	a59ff0ef          	jal	ra,800150 <yield>
    yield();
  8006fc:	a55ff0ef          	jal	ra,800150 <yield>
    yield();
  800700:	a51ff0ef          	jal	ra,800150 <yield>
    yield();
}
  800704:	60a2                	ld	ra,8(sp)
  800706:	0141                	addi	sp,sp,16
    yield();
  800708:	b4a1                	j	800150 <yield>

000000000080070a <loop>:

int parent, pid1, pid2;

void
loop(void) {
  80070a:	1141                	addi	sp,sp,-16
    cprintf("child 1.\n");
  80070c:	00000517          	auipc	a0,0x0
  800710:	46450513          	addi	a0,a0,1124 # 800b70 <error_string+0xc8>
loop(void) {
  800714:	e406                	sd	ra,8(sp)
    cprintf("child 1.\n");
  800716:	98dff0ef          	jal	ra,8000a2 <cprintf>
    while (1);
  80071a:	a001                	j	80071a <loop+0x10>

000000000080071c <work>:
}

void
work(void) {
  80071c:	1141                	addi	sp,sp,-16
    cprintf("child 2.\n");
  80071e:	00000517          	auipc	a0,0x0
  800722:	46250513          	addi	a0,a0,1122 # 800b80 <error_string+0xd8>
work(void) {
  800726:	e406                	sd	ra,8(sp)
    cprintf("child 2.\n");
  800728:	97bff0ef          	jal	ra,8000a2 <cprintf>
    do_yield();
  80072c:	fc1ff0ef          	jal	ra,8006ec <do_yield>
    if (kill(parent) == 0) {
  800730:	00001517          	auipc	a0,0x1
  800734:	8d052503          	lw	a0,-1840(a0) # 801000 <parent>
  800738:	a1bff0ef          	jal	ra,800152 <kill>
  80073c:	e105                	bnez	a0,80075c <work+0x40>
        cprintf("kill parent ok.\n");
  80073e:	00000517          	auipc	a0,0x0
  800742:	45250513          	addi	a0,a0,1106 # 800b90 <error_string+0xe8>
  800746:	95dff0ef          	jal	ra,8000a2 <cprintf>
        do_yield();
  80074a:	fa3ff0ef          	jal	ra,8006ec <do_yield>
        if (kill(pid1) == 0) {
  80074e:	00001517          	auipc	a0,0x1
  800752:	8b652503          	lw	a0,-1866(a0) # 801004 <pid1>
  800756:	9fdff0ef          	jal	ra,800152 <kill>
  80075a:	c501                	beqz	a0,800762 <work+0x46>
            cprintf("kill child1 ok.\n");
            exit(0);
        }
    }
    exit(-1);
  80075c:	557d                	li	a0,-1
  80075e:	9d9ff0ef          	jal	ra,800136 <exit>
            cprintf("kill child1 ok.\n");
  800762:	00000517          	auipc	a0,0x0
  800766:	44650513          	addi	a0,a0,1094 # 800ba8 <error_string+0x100>
  80076a:	939ff0ef          	jal	ra,8000a2 <cprintf>
            exit(0);
  80076e:	4501                	li	a0,0
  800770:	9c7ff0ef          	jal	ra,800136 <exit>

0000000000800774 <main>:
}

int
main(void) {
  800774:	1141                	addi	sp,sp,-16
  800776:	e406                	sd	ra,8(sp)
  800778:	e022                	sd	s0,0(sp)
    parent = getpid();
  80077a:	9dbff0ef          	jal	ra,800154 <getpid>
  80077e:	00001797          	auipc	a5,0x1
  800782:	88a7a123          	sw	a0,-1918(a5) # 801000 <parent>
    if ((pid1 = fork()) == 0) {
  800786:	00001417          	auipc	s0,0x1
  80078a:	87e40413          	addi	s0,s0,-1922 # 801004 <pid1>
  80078e:	9bfff0ef          	jal	ra,80014c <fork>
  800792:	c008                	sw	a0,0(s0)
  800794:	c13d                	beqz	a0,8007fa <main+0x86>
        loop();
    }

    assert(pid1 > 0);
  800796:	04a05263          	blez	a0,8007da <main+0x66>

    if ((pid2 = fork()) == 0) {
  80079a:	9b3ff0ef          	jal	ra,80014c <fork>
  80079e:	00001797          	auipc	a5,0x1
  8007a2:	86a7a523          	sw	a0,-1942(a5) # 801008 <pid2>
  8007a6:	c93d                	beqz	a0,80081c <main+0xa8>
        work();
    }
    if (pid2 > 0) {
  8007a8:	04a05b63          	blez	a0,8007fe <main+0x8a>
        cprintf("wait child 1.\n");
  8007ac:	00000517          	auipc	a0,0x0
  8007b0:	44c50513          	addi	a0,a0,1100 # 800bf8 <error_string+0x150>
  8007b4:	8efff0ef          	jal	ra,8000a2 <cprintf>
        waitpid(pid1, NULL);
  8007b8:	4008                	lw	a0,0(s0)
  8007ba:	4581                	li	a1,0
  8007bc:	993ff0ef          	jal	ra,80014e <waitpid>
        panic("waitpid %d returns\n", pid1);
  8007c0:	4014                	lw	a3,0(s0)
  8007c2:	00000617          	auipc	a2,0x0
  8007c6:	44660613          	addi	a2,a2,1094 # 800c08 <error_string+0x160>
  8007ca:	03400593          	li	a1,52
  8007ce:	00000517          	auipc	a0,0x0
  8007d2:	41a50513          	addi	a0,a0,1050 # 800be8 <error_string+0x140>
  8007d6:	851ff0ef          	jal	ra,800026 <__panic>
    assert(pid1 > 0);
  8007da:	00000697          	auipc	a3,0x0
  8007de:	3e668693          	addi	a3,a3,998 # 800bc0 <error_string+0x118>
  8007e2:	00000617          	auipc	a2,0x0
  8007e6:	3ee60613          	addi	a2,a2,1006 # 800bd0 <error_string+0x128>
  8007ea:	02c00593          	li	a1,44
  8007ee:	00000517          	auipc	a0,0x0
  8007f2:	3fa50513          	addi	a0,a0,1018 # 800be8 <error_string+0x140>
  8007f6:	831ff0ef          	jal	ra,800026 <__panic>
        loop();
  8007fa:	f11ff0ef          	jal	ra,80070a <loop>
    }
    else {
        kill(pid1);
  8007fe:	4008                	lw	a0,0(s0)
  800800:	953ff0ef          	jal	ra,800152 <kill>
    }
    panic("FAIL: T.T\n");
  800804:	00000617          	auipc	a2,0x0
  800808:	41c60613          	addi	a2,a2,1052 # 800c20 <error_string+0x178>
  80080c:	03900593          	li	a1,57
  800810:	00000517          	auipc	a0,0x0
  800814:	3d850513          	addi	a0,a0,984 # 800be8 <error_string+0x140>
  800818:	80fff0ef          	jal	ra,800026 <__panic>
        work();
  80081c:	f01ff0ef          	jal	ra,80071c <work>
