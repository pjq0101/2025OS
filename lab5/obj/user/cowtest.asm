
obj/__user_cowtest.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
.text
.globl _start
_start:
    # call user-program function
    call umain
  800020:	0c6000ef          	jal	8000e6 <umain>
1:  j 1b
  800024:	a001                	j	800024 <_start+0x4>

0000000000800026 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  800026:	1141                	addi	sp,sp,-16
  800028:	e022                	sd	s0,0(sp)
  80002a:	e406                	sd	ra,8(sp)
  80002c:	842e                	mv	s0,a1
    sys_putc(c);
  80002e:	096000ef          	jal	8000c4 <sys_putc>
    (*cnt) ++;
  800032:	401c                	lw	a5,0(s0)
}
  800034:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
  800036:	2785                	addiw	a5,a5,1
  800038:	c01c                	sw	a5,0(s0)
}
  80003a:	6402                	ld	s0,0(sp)
  80003c:	0141                	addi	sp,sp,16
  80003e:	8082                	ret

0000000000800040 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  800040:	711d                	addi	sp,sp,-96
    va_list ap;

    va_start(ap, fmt);
  800042:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
  800046:	f42e                	sd	a1,40(sp)
  800048:	f832                	sd	a2,48(sp)
  80004a:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80004c:	862a                	mv	a2,a0
  80004e:	004c                	addi	a1,sp,4
  800050:	00000517          	auipc	a0,0x0
  800054:	fd650513          	addi	a0,a0,-42 # 800026 <cputch>
  800058:	869a                	mv	a3,t1
cprintf(const char *fmt, ...) {
  80005a:	ec06                	sd	ra,24(sp)
  80005c:	e0ba                	sd	a4,64(sp)
  80005e:	e4be                	sd	a5,72(sp)
  800060:	e8c2                	sd	a6,80(sp)
  800062:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
  800064:	e41a                	sd	t1,8(sp)
    int cnt = 0;
  800066:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  800068:	0f8000ef          	jal	800160 <vprintfmt>
    int cnt = vcprintf(fmt, ap);
    va_end(ap);

    return cnt;
}
  80006c:	60e2                	ld	ra,24(sp)
  80006e:	4512                	lw	a0,4(sp)
  800070:	6125                	addi	sp,sp,96
  800072:	8082                	ret

0000000000800074 <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int64_t num, ...) {
  800074:	7175                	addi	sp,sp,-144
  800076:	e42a                	sd	a0,8(sp)
    va_list ap;
    va_start(ap, num);
    uint64_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint64_t);
  800078:	0108                	addi	a0,sp,128
syscall(int64_t num, ...) {
  80007a:	ecae                	sd	a1,88(sp)
  80007c:	f0b2                	sd	a2,96(sp)
  80007e:	f4b6                	sd	a3,104(sp)
  800080:	f8ba                	sd	a4,112(sp)
  800082:	fcbe                	sd	a5,120(sp)
  800084:	e142                	sd	a6,128(sp)
  800086:	e546                	sd	a7,136(sp)
        a[i] = va_arg(ap, uint64_t);
  800088:	f02a                	sd	a0,32(sp)
  80008a:	f42e                	sd	a1,40(sp)
  80008c:	f832                	sd	a2,48(sp)
  80008e:	fc36                	sd	a3,56(sp)
  800090:	e0ba                	sd	a4,64(sp)
  800092:	e4be                	sd	a5,72(sp)
    }
    va_end(ap);

    asm volatile (
  800094:	6522                	ld	a0,8(sp)
  800096:	75a2                	ld	a1,40(sp)
  800098:	7642                	ld	a2,48(sp)
  80009a:	76e2                	ld	a3,56(sp)
  80009c:	6706                	ld	a4,64(sp)
  80009e:	67a6                	ld	a5,72(sp)
  8000a0:	00000073          	ecall
  8000a4:	00a13e23          	sd	a0,28(sp)
        "sd a0, %0"
        : "=m" (ret)
        : "m"(num), "m"(a[0]), "m"(a[1]), "m"(a[2]), "m"(a[3]), "m"(a[4])
        :"memory");
    return ret;
}
  8000a8:	4572                	lw	a0,28(sp)
  8000aa:	6149                	addi	sp,sp,144
  8000ac:	8082                	ret

00000000008000ae <sys_exit>:

int
sys_exit(int64_t error_code) {
  8000ae:	85aa                	mv	a1,a0
    return syscall(SYS_exit, error_code);
  8000b0:	4505                	li	a0,1
  8000b2:	b7c9                	j	800074 <syscall>

00000000008000b4 <sys_fork>:
}

int
sys_fork(void) {
    return syscall(SYS_fork);
  8000b4:	4509                	li	a0,2
  8000b6:	bf7d                	j	800074 <syscall>

00000000008000b8 <sys_wait>:
}

int
sys_wait(int64_t pid, int *store) {
  8000b8:	862e                	mv	a2,a1
    return syscall(SYS_wait, pid, store);
  8000ba:	85aa                	mv	a1,a0
  8000bc:	450d                	li	a0,3
  8000be:	bf5d                	j	800074 <syscall>

00000000008000c0 <sys_getpid>:
    return syscall(SYS_kill, pid);
}

int
sys_getpid(void) {
    return syscall(SYS_getpid);
  8000c0:	4549                	li	a0,18
  8000c2:	bf4d                	j	800074 <syscall>

00000000008000c4 <sys_putc>:
}

int
sys_putc(int64_t c) {
  8000c4:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  8000c6:	4579                	li	a0,30
  8000c8:	b775                	j	800074 <syscall>

00000000008000ca <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8000ca:	1141                	addi	sp,sp,-16
  8000cc:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  8000ce:	fe1ff0ef          	jal	8000ae <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000d2:	00000517          	auipc	a0,0x0
  8000d6:	61e50513          	addi	a0,a0,1566 # 8006f0 <main+0x1fa>
  8000da:	f67ff0ef          	jal	800040 <cprintf>
    while (1);
  8000de:	a001                	j	8000de <exit+0x14>

00000000008000e0 <fork>:
}

int
fork(void) {
    return sys_fork();
  8000e0:	bfd1                	j	8000b4 <sys_fork>

00000000008000e2 <waitpid>:
    return sys_wait(0, NULL);
}

int
waitpid(int pid, int *store) {
    return sys_wait(pid, store);
  8000e2:	bfd9                	j	8000b8 <sys_wait>

00000000008000e4 <getpid>:
    return sys_kill(pid);
}

int
getpid(void) {
    return sys_getpid();
  8000e4:	bff1                	j	8000c0 <sys_getpid>

00000000008000e6 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8000e6:	1141                	addi	sp,sp,-16
  8000e8:	e406                	sd	ra,8(sp)
    int ret = main();
  8000ea:	40c000ef          	jal	8004f6 <main>
    exit(ret);
  8000ee:	fddff0ef          	jal	8000ca <exit>

00000000008000f2 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  8000f2:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000f6:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
  8000f8:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000fc:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
  8000fe:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  800102:	f022                	sd	s0,32(sp)
  800104:	ec26                	sd	s1,24(sp)
  800106:	e84a                	sd	s2,16(sp)
  800108:	f406                	sd	ra,40(sp)
  80010a:	84aa                	mv	s1,a0
  80010c:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  80010e:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
  800112:	2a01                	sext.w	s4,s4
    if (num >= base) {
  800114:	05067063          	bgeu	a2,a6,800154 <printnum+0x62>
  800118:	e44e                	sd	s3,8(sp)
  80011a:	89be                	mv	s3,a5
        while (-- width > 0)
  80011c:	4785                	li	a5,1
  80011e:	00e7d763          	bge	a5,a4,80012c <printnum+0x3a>
            putch(padc, putdat);
  800122:	85ca                	mv	a1,s2
  800124:	854e                	mv	a0,s3
        while (-- width > 0)
  800126:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800128:	9482                	jalr	s1
        while (-- width > 0)
  80012a:	fc65                	bnez	s0,800122 <printnum+0x30>
  80012c:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  80012e:	1a02                	slli	s4,s4,0x20
  800130:	020a5a13          	srli	s4,s4,0x20
  800134:	00000797          	auipc	a5,0x0
  800138:	5d478793          	addi	a5,a5,1492 # 800708 <main+0x212>
  80013c:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  80013e:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  800140:	0007c503          	lbu	a0,0(a5)
}
  800144:	70a2                	ld	ra,40(sp)
  800146:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  800148:	85ca                	mv	a1,s2
  80014a:	87a6                	mv	a5,s1
}
  80014c:	6942                	ld	s2,16(sp)
  80014e:	64e2                	ld	s1,24(sp)
  800150:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  800152:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  800154:	03065633          	divu	a2,a2,a6
  800158:	8722                	mv	a4,s0
  80015a:	f99ff0ef          	jal	8000f2 <printnum>
  80015e:	bfc1                	j	80012e <printnum+0x3c>

0000000000800160 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  800160:	7119                	addi	sp,sp,-128
  800162:	f4a6                	sd	s1,104(sp)
  800164:	f0ca                	sd	s2,96(sp)
  800166:	ecce                	sd	s3,88(sp)
  800168:	e8d2                	sd	s4,80(sp)
  80016a:	e4d6                	sd	s5,72(sp)
  80016c:	e0da                	sd	s6,64(sp)
  80016e:	f862                	sd	s8,48(sp)
  800170:	fc86                	sd	ra,120(sp)
  800172:	f8a2                	sd	s0,112(sp)
  800174:	fc5e                	sd	s7,56(sp)
  800176:	f466                	sd	s9,40(sp)
  800178:	f06a                	sd	s10,32(sp)
  80017a:	ec6e                	sd	s11,24(sp)
  80017c:	892a                	mv	s2,a0
  80017e:	84ae                	mv	s1,a1
  800180:	8c32                	mv	s8,a2
  800182:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800184:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  800188:	05500b13          	li	s6,85
  80018c:	00001a97          	auipc	s5,0x1
  800190:	958a8a93          	addi	s5,s5,-1704 # 800ae4 <main+0x5ee>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800194:	000c4503          	lbu	a0,0(s8)
  800198:	001c0413          	addi	s0,s8,1
  80019c:	01350a63          	beq	a0,s3,8001b0 <vprintfmt+0x50>
            if (ch == '\0') {
  8001a0:	cd0d                	beqz	a0,8001da <vprintfmt+0x7a>
            putch(ch, putdat);
  8001a2:	85a6                	mv	a1,s1
  8001a4:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001a6:	00044503          	lbu	a0,0(s0)
  8001aa:	0405                	addi	s0,s0,1
  8001ac:	ff351ae3          	bne	a0,s3,8001a0 <vprintfmt+0x40>
        char padc = ' ';
  8001b0:	02000d93          	li	s11,32
        lflag = altflag = 0;
  8001b4:	4b81                	li	s7,0
  8001b6:	4601                	li	a2,0
        width = precision = -1;
  8001b8:	5d7d                	li	s10,-1
  8001ba:	5cfd                	li	s9,-1
        switch (ch = *(unsigned char *)fmt ++) {
  8001bc:	00044683          	lbu	a3,0(s0)
  8001c0:	00140c13          	addi	s8,s0,1
  8001c4:	fdd6859b          	addiw	a1,a3,-35
  8001c8:	0ff5f593          	zext.b	a1,a1
  8001cc:	02bb6663          	bltu	s6,a1,8001f8 <vprintfmt+0x98>
  8001d0:	058a                	slli	a1,a1,0x2
  8001d2:	95d6                	add	a1,a1,s5
  8001d4:	4198                	lw	a4,0(a1)
  8001d6:	9756                	add	a4,a4,s5
  8001d8:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8001da:	70e6                	ld	ra,120(sp)
  8001dc:	7446                	ld	s0,112(sp)
  8001de:	74a6                	ld	s1,104(sp)
  8001e0:	7906                	ld	s2,96(sp)
  8001e2:	69e6                	ld	s3,88(sp)
  8001e4:	6a46                	ld	s4,80(sp)
  8001e6:	6aa6                	ld	s5,72(sp)
  8001e8:	6b06                	ld	s6,64(sp)
  8001ea:	7be2                	ld	s7,56(sp)
  8001ec:	7c42                	ld	s8,48(sp)
  8001ee:	7ca2                	ld	s9,40(sp)
  8001f0:	7d02                	ld	s10,32(sp)
  8001f2:	6de2                	ld	s11,24(sp)
  8001f4:	6109                	addi	sp,sp,128
  8001f6:	8082                	ret
            putch('%', putdat);
  8001f8:	85a6                	mv	a1,s1
  8001fa:	02500513          	li	a0,37
  8001fe:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800200:	fff44703          	lbu	a4,-1(s0)
  800204:	02500793          	li	a5,37
  800208:	8c22                	mv	s8,s0
  80020a:	f8f705e3          	beq	a4,a5,800194 <vprintfmt+0x34>
  80020e:	02500713          	li	a4,37
  800212:	ffec4783          	lbu	a5,-2(s8)
  800216:	1c7d                	addi	s8,s8,-1
  800218:	fee79de3          	bne	a5,a4,800212 <vprintfmt+0xb2>
  80021c:	bfa5                	j	800194 <vprintfmt+0x34>
                ch = *fmt;
  80021e:	00144783          	lbu	a5,1(s0)
                if (ch < '0' || ch > '9') {
  800222:	4725                	li	a4,9
                precision = precision * 10 + ch - '0';
  800224:	fd068d1b          	addiw	s10,a3,-48
                if (ch < '0' || ch > '9') {
  800228:	fd07859b          	addiw	a1,a5,-48
                ch = *fmt;
  80022c:	0007869b          	sext.w	a3,a5
        switch (ch = *(unsigned char *)fmt ++) {
  800230:	8462                	mv	s0,s8
                if (ch < '0' || ch > '9') {
  800232:	02b76563          	bltu	a4,a1,80025c <vprintfmt+0xfc>
  800236:	4525                	li	a0,9
                ch = *fmt;
  800238:	00144783          	lbu	a5,1(s0)
                precision = precision * 10 + ch - '0';
  80023c:	002d171b          	slliw	a4,s10,0x2
  800240:	01a7073b          	addw	a4,a4,s10
  800244:	0017171b          	slliw	a4,a4,0x1
  800248:	9f35                	addw	a4,a4,a3
                if (ch < '0' || ch > '9') {
  80024a:	fd07859b          	addiw	a1,a5,-48
            for (precision = 0; ; ++ fmt) {
  80024e:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  800250:	fd070d1b          	addiw	s10,a4,-48
                ch = *fmt;
  800254:	0007869b          	sext.w	a3,a5
                if (ch < '0' || ch > '9') {
  800258:	feb570e3          	bgeu	a0,a1,800238 <vprintfmt+0xd8>
            if (width < 0)
  80025c:	f60cd0e3          	bgez	s9,8001bc <vprintfmt+0x5c>
                width = precision, precision = -1;
  800260:	8cea                	mv	s9,s10
  800262:	5d7d                	li	s10,-1
  800264:	bfa1                	j	8001bc <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
  800266:	8db6                	mv	s11,a3
  800268:	8462                	mv	s0,s8
  80026a:	bf89                	j	8001bc <vprintfmt+0x5c>
  80026c:	8462                	mv	s0,s8
            altflag = 1;
  80026e:	4b85                	li	s7,1
            goto reswitch;
  800270:	b7b1                	j	8001bc <vprintfmt+0x5c>
    if (lflag >= 2) {
  800272:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800274:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800278:	00c7c463          	blt	a5,a2,800280 <vprintfmt+0x120>
    else if (lflag) {
  80027c:	1a060163          	beqz	a2,80041e <vprintfmt+0x2be>
        return va_arg(*ap, unsigned long);
  800280:	000a3603          	ld	a2,0(s4)
  800284:	46c1                	li	a3,16
  800286:	8a3a                	mv	s4,a4
            printnum(putch, putdat, num, base, width, padc);
  800288:	000d879b          	sext.w	a5,s11
  80028c:	8766                	mv	a4,s9
  80028e:	85a6                	mv	a1,s1
  800290:	854a                	mv	a0,s2
  800292:	e61ff0ef          	jal	8000f2 <printnum>
            break;
  800296:	bdfd                	j	800194 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
  800298:	000a2503          	lw	a0,0(s4)
  80029c:	85a6                	mv	a1,s1
  80029e:	0a21                	addi	s4,s4,8
  8002a0:	9902                	jalr	s2
            break;
  8002a2:	bdcd                	j	800194 <vprintfmt+0x34>
    if (lflag >= 2) {
  8002a4:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8002a6:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  8002aa:	00c7c463          	blt	a5,a2,8002b2 <vprintfmt+0x152>
    else if (lflag) {
  8002ae:	16060363          	beqz	a2,800414 <vprintfmt+0x2b4>
        return va_arg(*ap, unsigned long);
  8002b2:	000a3603          	ld	a2,0(s4)
  8002b6:	46a9                	li	a3,10
  8002b8:	8a3a                	mv	s4,a4
  8002ba:	b7f9                	j	800288 <vprintfmt+0x128>
            putch('0', putdat);
  8002bc:	85a6                	mv	a1,s1
  8002be:	03000513          	li	a0,48
  8002c2:	9902                	jalr	s2
            putch('x', putdat);
  8002c4:	85a6                	mv	a1,s1
  8002c6:	07800513          	li	a0,120
  8002ca:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8002cc:	000a3603          	ld	a2,0(s4)
            goto number;
  8002d0:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8002d2:	0a21                	addi	s4,s4,8
            goto number;
  8002d4:	bf55                	j	800288 <vprintfmt+0x128>
            putch(ch, putdat);
  8002d6:	85a6                	mv	a1,s1
  8002d8:	02500513          	li	a0,37
  8002dc:	9902                	jalr	s2
            break;
  8002de:	bd5d                	j	800194 <vprintfmt+0x34>
            precision = va_arg(ap, int);
  8002e0:	000a2d03          	lw	s10,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  8002e4:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
  8002e6:	0a21                	addi	s4,s4,8
            goto process_precision;
  8002e8:	bf95                	j	80025c <vprintfmt+0xfc>
    if (lflag >= 2) {
  8002ea:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8002ec:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  8002f0:	00c7c463          	blt	a5,a2,8002f8 <vprintfmt+0x198>
    else if (lflag) {
  8002f4:	10060b63          	beqz	a2,80040a <vprintfmt+0x2aa>
        return va_arg(*ap, unsigned long);
  8002f8:	000a3603          	ld	a2,0(s4)
  8002fc:	46a1                	li	a3,8
  8002fe:	8a3a                	mv	s4,a4
  800300:	b761                	j	800288 <vprintfmt+0x128>
            if (width < 0)
  800302:	fffcc793          	not	a5,s9
  800306:	97fd                	srai	a5,a5,0x3f
  800308:	00fcf7b3          	and	a5,s9,a5
  80030c:	00078c9b          	sext.w	s9,a5
        switch (ch = *(unsigned char *)fmt ++) {
  800310:	8462                	mv	s0,s8
            goto reswitch;
  800312:	b56d                	j	8001bc <vprintfmt+0x5c>
            if ((p = va_arg(ap, char *)) == NULL) {
  800314:	000a3403          	ld	s0,0(s4)
  800318:	008a0793          	addi	a5,s4,8
  80031c:	e43e                	sd	a5,8(sp)
  80031e:	12040063          	beqz	s0,80043e <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
  800322:	0d905963          	blez	s9,8003f4 <vprintfmt+0x294>
  800326:	02d00793          	li	a5,45
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80032a:	00140a13          	addi	s4,s0,1
            if (width > 0 && padc != '-') {
  80032e:	12fd9763          	bne	s11,a5,80045c <vprintfmt+0x2fc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800332:	00044783          	lbu	a5,0(s0)
  800336:	0007851b          	sext.w	a0,a5
  80033a:	cb9d                	beqz	a5,800370 <vprintfmt+0x210>
  80033c:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
  80033e:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800342:	000d4563          	bltz	s10,80034c <vprintfmt+0x1ec>
  800346:	3d7d                	addiw	s10,s10,-1
  800348:	028d0263          	beq	s10,s0,80036c <vprintfmt+0x20c>
                    putch('?', putdat);
  80034c:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  80034e:	0c0b8d63          	beqz	s7,800428 <vprintfmt+0x2c8>
  800352:	3781                	addiw	a5,a5,-32
  800354:	0cfdfa63          	bgeu	s11,a5,800428 <vprintfmt+0x2c8>
                    putch('?', putdat);
  800358:	03f00513          	li	a0,63
  80035c:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80035e:	000a4783          	lbu	a5,0(s4)
  800362:	3cfd                	addiw	s9,s9,-1
  800364:	0a05                	addi	s4,s4,1
  800366:	0007851b          	sext.w	a0,a5
  80036a:	ffe1                	bnez	a5,800342 <vprintfmt+0x1e2>
            for (; width > 0; width --) {
  80036c:	01905963          	blez	s9,80037e <vprintfmt+0x21e>
                putch(' ', putdat);
  800370:	85a6                	mv	a1,s1
  800372:	02000513          	li	a0,32
            for (; width > 0; width --) {
  800376:	3cfd                	addiw	s9,s9,-1
                putch(' ', putdat);
  800378:	9902                	jalr	s2
            for (; width > 0; width --) {
  80037a:	fe0c9be3          	bnez	s9,800370 <vprintfmt+0x210>
            if ((p = va_arg(ap, char *)) == NULL) {
  80037e:	6a22                	ld	s4,8(sp)
  800380:	bd11                	j	800194 <vprintfmt+0x34>
    if (lflag >= 2) {
  800382:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800384:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
  800388:	00c7c363          	blt	a5,a2,80038e <vprintfmt+0x22e>
    else if (lflag) {
  80038c:	ce25                	beqz	a2,800404 <vprintfmt+0x2a4>
        return va_arg(*ap, long);
  80038e:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  800392:	08044d63          	bltz	s0,80042c <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
  800396:	8622                	mv	a2,s0
  800398:	8a5e                	mv	s4,s7
  80039a:	46a9                	li	a3,10
  80039c:	b5f5                	j	800288 <vprintfmt+0x128>
            if (err < 0) {
  80039e:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8003a2:	4661                	li	a2,24
            if (err < 0) {
  8003a4:	41f7d71b          	sraiw	a4,a5,0x1f
  8003a8:	8fb9                	xor	a5,a5,a4
  8003aa:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8003ae:	02d64663          	blt	a2,a3,8003da <vprintfmt+0x27a>
  8003b2:	00369713          	slli	a4,a3,0x3
  8003b6:	00001797          	auipc	a5,0x1
  8003ba:	88a78793          	addi	a5,a5,-1910 # 800c40 <error_string>
  8003be:	97ba                	add	a5,a5,a4
  8003c0:	639c                	ld	a5,0(a5)
  8003c2:	cf81                	beqz	a5,8003da <vprintfmt+0x27a>
                printfmt(putch, putdat, "%s", p);
  8003c4:	86be                	mv	a3,a5
  8003c6:	00000617          	auipc	a2,0x0
  8003ca:	37a60613          	addi	a2,a2,890 # 800740 <main+0x24a>
  8003ce:	85a6                	mv	a1,s1
  8003d0:	854a                	mv	a0,s2
  8003d2:	0e8000ef          	jal	8004ba <printfmt>
            err = va_arg(ap, int);
  8003d6:	0a21                	addi	s4,s4,8
  8003d8:	bb75                	j	800194 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
  8003da:	00000617          	auipc	a2,0x0
  8003de:	35660613          	addi	a2,a2,854 # 800730 <main+0x23a>
  8003e2:	85a6                	mv	a1,s1
  8003e4:	854a                	mv	a0,s2
  8003e6:	0d4000ef          	jal	8004ba <printfmt>
            err = va_arg(ap, int);
  8003ea:	0a21                	addi	s4,s4,8
  8003ec:	b365                	j	800194 <vprintfmt+0x34>
            lflag ++;
  8003ee:	2605                	addiw	a2,a2,1
        switch (ch = *(unsigned char *)fmt ++) {
  8003f0:	8462                	mv	s0,s8
            goto reswitch;
  8003f2:	b3e9                	j	8001bc <vprintfmt+0x5c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003f4:	00044783          	lbu	a5,0(s0)
  8003f8:	0007851b          	sext.w	a0,a5
  8003fc:	d3c9                	beqz	a5,80037e <vprintfmt+0x21e>
  8003fe:	00140a13          	addi	s4,s0,1
  800402:	bf2d                	j	80033c <vprintfmt+0x1dc>
        return va_arg(*ap, int);
  800404:	000a2403          	lw	s0,0(s4)
  800408:	b769                	j	800392 <vprintfmt+0x232>
        return va_arg(*ap, unsigned int);
  80040a:	000a6603          	lwu	a2,0(s4)
  80040e:	46a1                	li	a3,8
  800410:	8a3a                	mv	s4,a4
  800412:	bd9d                	j	800288 <vprintfmt+0x128>
  800414:	000a6603          	lwu	a2,0(s4)
  800418:	46a9                	li	a3,10
  80041a:	8a3a                	mv	s4,a4
  80041c:	b5b5                	j	800288 <vprintfmt+0x128>
  80041e:	000a6603          	lwu	a2,0(s4)
  800422:	46c1                	li	a3,16
  800424:	8a3a                	mv	s4,a4
  800426:	b58d                	j	800288 <vprintfmt+0x128>
                    putch(ch, putdat);
  800428:	9902                	jalr	s2
  80042a:	bf15                	j	80035e <vprintfmt+0x1fe>
                putch('-', putdat);
  80042c:	85a6                	mv	a1,s1
  80042e:	02d00513          	li	a0,45
  800432:	9902                	jalr	s2
                num = -(long long)num;
  800434:	40800633          	neg	a2,s0
  800438:	8a5e                	mv	s4,s7
  80043a:	46a9                	li	a3,10
  80043c:	b5b1                	j	800288 <vprintfmt+0x128>
            if (width > 0 && padc != '-') {
  80043e:	01905663          	blez	s9,80044a <vprintfmt+0x2ea>
  800442:	02d00793          	li	a5,45
  800446:	04fd9263          	bne	s11,a5,80048a <vprintfmt+0x32a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80044a:	02800793          	li	a5,40
  80044e:	00000a17          	auipc	s4,0x0
  800452:	2d3a0a13          	addi	s4,s4,723 # 800721 <main+0x22b>
  800456:	02800513          	li	a0,40
  80045a:	b5cd                	j	80033c <vprintfmt+0x1dc>
                for (width -= strnlen(p, precision); width > 0; width --) {
  80045c:	85ea                	mv	a1,s10
  80045e:	8522                	mv	a0,s0
  800460:	07a000ef          	jal	8004da <strnlen>
  800464:	40ac8cbb          	subw	s9,s9,a0
  800468:	01905963          	blez	s9,80047a <vprintfmt+0x31a>
                    putch(padc, putdat);
  80046c:	2d81                	sext.w	s11,s11
  80046e:	85a6                	mv	a1,s1
  800470:	856e                	mv	a0,s11
                for (width -= strnlen(p, precision); width > 0; width --) {
  800472:	3cfd                	addiw	s9,s9,-1
                    putch(padc, putdat);
  800474:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  800476:	fe0c9ce3          	bnez	s9,80046e <vprintfmt+0x30e>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80047a:	00044783          	lbu	a5,0(s0)
  80047e:	0007851b          	sext.w	a0,a5
  800482:	ea079de3          	bnez	a5,80033c <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
  800486:	6a22                	ld	s4,8(sp)
  800488:	b331                	j	800194 <vprintfmt+0x34>
                for (width -= strnlen(p, precision); width > 0; width --) {
  80048a:	85ea                	mv	a1,s10
  80048c:	00000517          	auipc	a0,0x0
  800490:	29450513          	addi	a0,a0,660 # 800720 <main+0x22a>
  800494:	046000ef          	jal	8004da <strnlen>
  800498:	40ac8cbb          	subw	s9,s9,a0
                p = "(null)";
  80049c:	00000417          	auipc	s0,0x0
  8004a0:	28440413          	addi	s0,s0,644 # 800720 <main+0x22a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004a4:	00000a17          	auipc	s4,0x0
  8004a8:	27da0a13          	addi	s4,s4,637 # 800721 <main+0x22b>
  8004ac:	02800793          	li	a5,40
  8004b0:	02800513          	li	a0,40
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004b4:	fb904ce3          	bgtz	s9,80046c <vprintfmt+0x30c>
  8004b8:	b551                	j	80033c <vprintfmt+0x1dc>

00000000008004ba <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004ba:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  8004bc:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004c0:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004c2:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004c4:	ec06                	sd	ra,24(sp)
  8004c6:	f83a                	sd	a4,48(sp)
  8004c8:	fc3e                	sd	a5,56(sp)
  8004ca:	e0c2                	sd	a6,64(sp)
  8004cc:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8004ce:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004d0:	c91ff0ef          	jal	800160 <vprintfmt>
}
  8004d4:	60e2                	ld	ra,24(sp)
  8004d6:	6161                	addi	sp,sp,80
  8004d8:	8082                	ret

00000000008004da <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  8004da:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  8004dc:	e589                	bnez	a1,8004e6 <strnlen+0xc>
  8004de:	a811                	j	8004f2 <strnlen+0x18>
        cnt ++;
  8004e0:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  8004e2:	00f58863          	beq	a1,a5,8004f2 <strnlen+0x18>
  8004e6:	00f50733          	add	a4,a0,a5
  8004ea:	00074703          	lbu	a4,0(a4)
  8004ee:	fb6d                	bnez	a4,8004e0 <strnlen+0x6>
  8004f0:	85be                	mv	a1,a5
    }
    return cnt;
}
  8004f2:	852e                	mv	a0,a1
  8004f4:	8082                	ret

00000000008004f6 <main>:
// 全局变量用于测试 COW
static char buffer[TEST_SIZE];

// 测试 COW 机制
int main(void)
{
  8004f6:	7139                	addi	sp,sp,-64
    cprintf("=== Copy-on-Write (COW) Test ===\n");
  8004f8:	00000517          	auipc	a0,0x0
  8004fc:	31050513          	addi	a0,a0,784 # 800808 <main+0x312>
{
  800500:	f822                	sd	s0,48(sp)
  800502:	f426                	sd	s1,40(sp)
  800504:	fc06                	sd	ra,56(sp)
  800506:	f04a                	sd	s2,32(sp)
  800508:	ec4e                	sd	s3,24(sp)
  80050a:	e852                	sd	s4,16(sp)
  80050c:	00001497          	auipc	s1,0x1
  800510:	af448493          	addi	s1,s1,-1292 # 801000 <buffer>
    cprintf("=== Copy-on-Write (COW) Test ===\n");
  800514:	b2dff0ef          	jal	800040 <cprintf>
  800518:	87a6                	mv	a5,s1
    
    // 初始化数据
    for (int i = 0; i < TEST_SIZE; i++)
  80051a:	4401                	li	s0,0
  80051c:	6709                	lui	a4,0x2
    {
        buffer[i] = (char)(i % 256);
  80051e:	00878023          	sb	s0,0(a5)
    for (int i = 0; i < TEST_SIZE; i++)
  800522:	2405                	addiw	s0,s0,1
  800524:	0785                	addi	a5,a5,1
  800526:	fee41ce3          	bne	s0,a4,80051e <main+0x28>
    }
    cprintf("Parent: Initialized buffer with test data\n");
  80052a:	00000517          	auipc	a0,0x0
  80052e:	30650513          	addi	a0,a0,774 # 800830 <main+0x33a>
  800532:	b0fff0ef          	jal	800040 <cprintf>
    
    // 验证初始数据
    int sum = 0;
    for (int i = 0; i < TEST_SIZE; i++)
  800536:	9426                	add	s0,s0,s1
    cprintf("Parent: Initialized buffer with test data\n");
  800538:	00001797          	auipc	a5,0x1
  80053c:	ac878793          	addi	a5,a5,-1336 # 801000 <buffer>
    int sum = 0;
  800540:	4901                	li	s2,0
    {
        sum += buffer[i];
  800542:	0007c703          	lbu	a4,0(a5)
    for (int i = 0; i < TEST_SIZE; i++)
  800546:	0785                	addi	a5,a5,1
        sum += buffer[i];
  800548:	0127093b          	addw	s2,a4,s2
    for (int i = 0; i < TEST_SIZE; i++)
  80054c:	fe879be3          	bne	a5,s0,800542 <main+0x4c>
    }
    cprintf("Parent: Sum of buffer = %d\n", sum);
  800550:	85ca                	mv	a1,s2
  800552:	00000517          	auipc	a0,0x0
  800556:	30e50513          	addi	a0,a0,782 # 800860 <main+0x36a>
  80055a:	ae7ff0ef          	jal	800040 <cprintf>
    
    // Fork 子进程
    int pid = fork();
  80055e:	b83ff0ef          	jal	8000e0 <fork>
  800562:	8a2a                	mv	s4,a0
    if (pid < 0)
  800564:	16054c63          	bltz	a0,8006dc <main+0x1e6>
    {
        cprintf("Fork failed\n");
        return -1;
    }
    
    if (pid == 0)
  800568:	e931                	bnez	a0,8005bc <main+0xc6>
    {
        // 子进程
        cprintf("Child: Started, PID = %d\n", getpid());
  80056a:	b7bff0ef          	jal	8000e4 <getpid>
  80056e:	85aa                	mv	a1,a0
  800570:	00000517          	auipc	a0,0x0
  800574:	32050513          	addi	a0,a0,800 # 800890 <main+0x39a>
  800578:	ac9ff0ef          	jal	800040 <cprintf>
  80057c:	00001797          	auipc	a5,0x1
  800580:	a8478793          	addi	a5,a5,-1404 # 801000 <buffer>
        
        // 验证子进程可以看到父进程的数据（共享页面）
        int child_sum = 0;
  800584:	4981                	li	s3,0
        for (int i = 0; i < TEST_SIZE; i++)
        {
            child_sum += buffer[i];
  800586:	0007c703          	lbu	a4,0(a5)
        for (int i = 0; i < TEST_SIZE; i++)
  80058a:	0785                	addi	a5,a5,1
            child_sum += buffer[i];
  80058c:	013709bb          	addw	s3,a4,s3
        for (int i = 0; i < TEST_SIZE; i++)
  800590:	fe879be3          	bne	a5,s0,800586 <main+0x90>
        }
        cprintf("Child: Sum of buffer (before write) = %d\n", child_sum);
  800594:	85ce                	mv	a1,s3
  800596:	00000517          	auipc	a0,0x0
  80059a:	31a50513          	addi	a0,a0,794 # 8008b0 <main+0x3ba>
  80059e:	aa3ff0ef          	jal	800040 <cprintf>
        
        if (child_sum != sum)
  8005a2:	0d298963          	beq	s3,s2,800674 <main+0x17e>
        {
            cprintf("Child: ERROR - Data mismatch! Expected %d, got %d\n", sum, child_sum);
  8005a6:	864e                	mv	a2,s3
  8005a8:	85ca                	mv	a1,s2
  8005aa:	00000517          	auipc	a0,0x0
  8005ae:	33650513          	addi	a0,a0,822 # 8008e0 <main+0x3ea>
  8005b2:	a8fff0ef          	jal	800040 <cprintf>
            exit(-1);
  8005b6:	557d                	li	a0,-1
  8005b8:	b13ff0ef          	jal	8000ca <exit>
        exit(0);
    }
    else
    {
        // 父进程
        cprintf("Parent: Child PID = %d\n", pid);
  8005bc:	85aa                	mv	a1,a0
  8005be:	00000517          	auipc	a0,0x0
  8005c2:	3ca50513          	addi	a0,a0,970 # 800988 <main+0x492>
  8005c6:	a7bff0ef          	jal	800040 <cprintf>
        
        // 等待子进程完成
        int status;
        waitpid(pid, &status);
  8005ca:	006c                	addi	a1,sp,12
  8005cc:	8552                	mv	a0,s4
  8005ce:	b15ff0ef          	jal	8000e2 <waitpid>
        cprintf("Parent: Child exited with status %d\n", status);
  8005d2:	45b2                	lw	a1,12(sp)
  8005d4:	00000517          	auipc	a0,0x0
  8005d8:	3cc50513          	addi	a0,a0,972 # 8009a0 <main+0x4aa>
        
        // 验证父进程的数据没有被修改（COW 应该保护了父进程的数据）
        int parent_sum = 0;
  8005dc:	4981                	li	s3,0
        cprintf("Parent: Child exited with status %d\n", status);
  8005de:	a63ff0ef          	jal	800040 <cprintf>
  8005e2:	00001797          	auipc	a5,0x1
  8005e6:	a1e78793          	addi	a5,a5,-1506 # 801000 <buffer>
        for (int i = 0; i < TEST_SIZE; i++)
        {
            parent_sum += buffer[i];
  8005ea:	0007c703          	lbu	a4,0(a5)
        for (int i = 0; i < TEST_SIZE; i++)
  8005ee:	0785                	addi	a5,a5,1
            parent_sum += buffer[i];
  8005f0:	013709bb          	addw	s3,a4,s3
        for (int i = 0; i < TEST_SIZE; i++)
  8005f4:	fe879be3          	bne	a5,s0,8005ea <main+0xf4>
        }
        cprintf("Parent: Sum of buffer (after child write) = %d\n", parent_sum);
  8005f8:	85ce                	mv	a1,s3
  8005fa:	00000517          	auipc	a0,0x0
  8005fe:	3ce50513          	addi	a0,a0,974 # 8009c8 <main+0x4d2>
  800602:	a3fff0ef          	jal	800040 <cprintf>
        
        if (parent_sum != sum)
  800606:	0d299163          	bne	s3,s2,8006c8 <main+0x1d2>
        {
            cprintf("Parent: ERROR - Data was modified! Expected %d, got %d\n", sum, parent_sum);
            return -1;
        }
        
        cprintf("Parent: Data integrity verified - COW working correctly!\n");
  80060a:	00000517          	auipc	a0,0x0
  80060e:	42650513          	addi	a0,a0,1062 # 800a30 <main+0x53a>
  800612:	a2fff0ef          	jal	800040 <cprintf>
        
        // 父进程也修改数据（再次触发 COW）
        cprintf("Parent: Modifying buffer...\n");
  800616:	00000517          	auipc	a0,0x0
  80061a:	45a50513          	addi	a0,a0,1114 # 800a70 <main+0x57a>
  80061e:	a23ff0ef          	jal	800040 <cprintf>
        for (int i = 0; i < TEST_SIZE; i++)
        {
            buffer[i] = (char)((i + 2) % 256);
  800622:	4689                	li	a3,2
        cprintf("Parent: Modifying buffer...\n");
  800624:	00001797          	auipc	a5,0x1
  800628:	9dc78793          	addi	a5,a5,-1572 # 801000 <buffer>
            buffer[i] = (char)((i + 2) % 256);
  80062c:	9e85                	subw	a3,a3,s1
  80062e:	00f6873b          	addw	a4,a3,a5
  800632:	00e78023          	sb	a4,0(a5)
        for (int i = 0; i < TEST_SIZE; i++)
  800636:	0785                	addi	a5,a5,1
  800638:	fe879be3          	bne	a5,s0,80062e <main+0x138>
        }
        
        int final_sum = 0;
  80063c:	4581                	li	a1,0
        for (int i = 0; i < TEST_SIZE; i++)
        {
            final_sum += buffer[i];
  80063e:	0004c783          	lbu	a5,0(s1)
        for (int i = 0; i < TEST_SIZE; i++)
  800642:	0485                	addi	s1,s1,1
            final_sum += buffer[i];
  800644:	9dbd                	addw	a1,a1,a5
        for (int i = 0; i < TEST_SIZE; i++)
  800646:	fe849ce3          	bne	s1,s0,80063e <main+0x148>
        }
        cprintf("Parent: Sum of buffer (after parent write) = %d\n", final_sum);
  80064a:	00000517          	auipc	a0,0x0
  80064e:	44650513          	addi	a0,a0,1094 # 800a90 <main+0x59a>
  800652:	9efff0ef          	jal	800040 <cprintf>
        
        cprintf("=== COW Test Passed ===\n");
  800656:	00000517          	auipc	a0,0x0
  80065a:	47250513          	addi	a0,a0,1138 # 800ac8 <main+0x5d2>
  80065e:	9e3ff0ef          	jal	800040 <cprintf>
    }
    
    return 0;
  800662:	4501                	li	a0,0
}
  800664:	70e2                	ld	ra,56(sp)
  800666:	7442                	ld	s0,48(sp)
  800668:	74a2                	ld	s1,40(sp)
  80066a:	7902                	ld	s2,32(sp)
  80066c:	69e2                	ld	s3,24(sp)
  80066e:	6a42                	ld	s4,16(sp)
  800670:	6121                	addi	sp,sp,64
  800672:	8082                	ret
        cprintf("Child: Modifying buffer (triggering COW)...\n");
  800674:	00000517          	auipc	a0,0x0
  800678:	2a450513          	addi	a0,a0,676 # 800918 <main+0x422>
  80067c:	9c5ff0ef          	jal	800040 <cprintf>
            buffer[i] = (char)((i + 1) % 256);
  800680:	4685                	li	a3,1
        cprintf("Child: Modifying buffer (triggering COW)...\n");
  800682:	00001797          	auipc	a5,0x1
  800686:	97e78793          	addi	a5,a5,-1666 # 801000 <buffer>
            buffer[i] = (char)((i + 1) % 256);
  80068a:	9e85                	subw	a3,a3,s1
  80068c:	00f6873b          	addw	a4,a3,a5
  800690:	00e78023          	sb	a4,0(a5)
        for (int i = 0; i < TEST_SIZE; i++)
  800694:	0785                	addi	a5,a5,1
  800696:	fe879be3          	bne	a5,s0,80068c <main+0x196>
            new_sum += buffer[i];
  80069a:	0004c783          	lbu	a5,0(s1)
        for (int i = 0; i < TEST_SIZE; i++)
  80069e:	0485                	addi	s1,s1,1
            new_sum += buffer[i];
  8006a0:	01478a3b          	addw	s4,a5,s4
        for (int i = 0; i < TEST_SIZE; i++)
  8006a4:	fe849be3          	bne	s1,s0,80069a <main+0x1a4>
        cprintf("Child: Sum of buffer (after write) = %d\n", new_sum);
  8006a8:	85d2                	mv	a1,s4
  8006aa:	00000517          	auipc	a0,0x0
  8006ae:	29e50513          	addi	a0,a0,670 # 800948 <main+0x452>
  8006b2:	98fff0ef          	jal	800040 <cprintf>
        cprintf("Child: Exiting\n");
  8006b6:	00000517          	auipc	a0,0x0
  8006ba:	2c250513          	addi	a0,a0,706 # 800978 <main+0x482>
  8006be:	983ff0ef          	jal	800040 <cprintf>
        exit(0);
  8006c2:	4501                	li	a0,0
  8006c4:	a07ff0ef          	jal	8000ca <exit>
            cprintf("Parent: ERROR - Data was modified! Expected %d, got %d\n", sum, parent_sum);
  8006c8:	864e                	mv	a2,s3
  8006ca:	85ca                	mv	a1,s2
  8006cc:	00000517          	auipc	a0,0x0
  8006d0:	32c50513          	addi	a0,a0,812 # 8009f8 <main+0x502>
  8006d4:	96dff0ef          	jal	800040 <cprintf>
        return -1;
  8006d8:	557d                	li	a0,-1
  8006da:	b769                	j	800664 <main+0x16e>
        cprintf("Fork failed\n");
  8006dc:	00000517          	auipc	a0,0x0
  8006e0:	1a450513          	addi	a0,a0,420 # 800880 <main+0x38a>
  8006e4:	95dff0ef          	jal	800040 <cprintf>
        return -1;
  8006e8:	557d                	li	a0,-1
  8006ea:	bfad                	j	800664 <main+0x16e>
