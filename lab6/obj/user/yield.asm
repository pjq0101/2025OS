
obj/__user_yield.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	0bc000ef          	jal	ra,8000dc <umain>
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
  80002e:	08e000ef          	jal	ra,8000bc <sys_putc>
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
  800046:	8e2a                	mv	t3,a0
  800048:	f42e                	sd	a1,40(sp)
  80004a:	f832                	sd	a2,48(sp)
  80004c:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80004e:	00000517          	auipc	a0,0x0
  800052:	fd850513          	addi	a0,a0,-40 # 800026 <cputch>
  800056:	004c                	addi	a1,sp,4
  800058:	869a                	mv	a3,t1
  80005a:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
  80005c:	ec06                	sd	ra,24(sp)
  80005e:	e0ba                	sd	a4,64(sp)
  800060:	e4be                	sd	a5,72(sp)
  800062:	e8c2                	sd	a6,80(sp)
  800064:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
  800066:	e41a                	sd	t1,8(sp)
    int cnt = 0;
  800068:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80006a:	166000ef          	jal	ra,8001d0 <vprintfmt>
    int cnt = vcprintf(fmt, ap);
    va_end(ap);

    return cnt;
}
  80006e:	60e2                	ld	ra,24(sp)
  800070:	4512                	lw	a0,4(sp)
  800072:	6125                	addi	sp,sp,96
  800074:	8082                	ret

0000000000800076 <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int64_t num, ...) {
  800076:	7175                	addi	sp,sp,-144
  800078:	e42a                	sd	a0,8(sp)
    va_list ap;
    va_start(ap, num);
    uint64_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint64_t);
  80007a:	0108                	addi	a0,sp,128
syscall(int64_t num, ...) {
  80007c:	ecae                	sd	a1,88(sp)
  80007e:	f0b2                	sd	a2,96(sp)
  800080:	f4b6                	sd	a3,104(sp)
  800082:	f8ba                	sd	a4,112(sp)
  800084:	fcbe                	sd	a5,120(sp)
  800086:	e142                	sd	a6,128(sp)
  800088:	e546                	sd	a7,136(sp)
        a[i] = va_arg(ap, uint64_t);
  80008a:	f02a                	sd	a0,32(sp)
  80008c:	f42e                	sd	a1,40(sp)
  80008e:	f832                	sd	a2,48(sp)
  800090:	fc36                	sd	a3,56(sp)
  800092:	e0ba                	sd	a4,64(sp)
  800094:	e4be                	sd	a5,72(sp)
    }
    va_end(ap);
    asm volatile (
  800096:	4522                	lw	a0,8(sp)
  800098:	55a2                	lw	a1,40(sp)
  80009a:	5642                	lw	a2,48(sp)
  80009c:	56e2                	lw	a3,56(sp)
  80009e:	4706                	lw	a4,64(sp)
  8000a0:	47a6                	lw	a5,72(sp)
  8000a2:	00000073          	ecall
  8000a6:	ce2a                	sw	a0,28(sp)
          "m" (a[3]),
          "m" (a[4])
        : "memory"
      );
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
  8000b2:	b7d1                	j	800076 <syscall>

00000000008000b4 <sys_yield>:
    return syscall(SYS_wait, pid, store);
}

int
sys_yield(void) {
    return syscall(SYS_yield);
  8000b4:	4529                	li	a0,10
  8000b6:	b7c1                	j	800076 <syscall>

00000000008000b8 <sys_getpid>:
    return syscall(SYS_kill, pid);
}

int
sys_getpid(void) {
    return syscall(SYS_getpid);
  8000b8:	4549                	li	a0,18
  8000ba:	bf75                	j	800076 <syscall>

00000000008000bc <sys_putc>:
}

int
sys_putc(int64_t c) {
  8000bc:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  8000be:	4579                	li	a0,30
  8000c0:	bf5d                	j	800076 <syscall>

00000000008000c2 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8000c2:	1141                	addi	sp,sp,-16
  8000c4:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  8000c6:	fe9ff0ef          	jal	ra,8000ae <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000ca:	00000517          	auipc	a0,0x0
  8000ce:	61650513          	addi	a0,a0,1558 # 8006e0 <main+0x6e>
  8000d2:	f6fff0ef          	jal	ra,800040 <cprintf>
    while (1);
  8000d6:	a001                	j	8000d6 <exit+0x14>

00000000008000d8 <yield>:
    return sys_wait(pid, store);
}

void
yield(void) {
    sys_yield();
  8000d8:	bff1                	j	8000b4 <sys_yield>

00000000008000da <getpid>:
    return sys_kill(pid);
}

int
getpid(void) {
    return sys_getpid();
  8000da:	bff9                	j	8000b8 <sys_getpid>

00000000008000dc <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8000dc:	1141                	addi	sp,sp,-16
  8000de:	e406                	sd	ra,8(sp)
    int ret = main();
  8000e0:	592000ef          	jal	ra,800672 <main>
    exit(ret);
  8000e4:	fdfff0ef          	jal	ra,8000c2 <exit>

00000000008000e8 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  8000e8:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000ec:	7139                	addi	sp,sp,-64
    unsigned mod = do_div(result, base);
  8000ee:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000f2:	e852                	sd	s4,16(sp)
    unsigned mod = do_div(result, base);
  8000f4:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  8000f8:	f426                	sd	s1,40(sp)
  8000fa:	f04a                	sd	s2,32(sp)
  8000fc:	ec4e                	sd	s3,24(sp)
  8000fe:	fc06                	sd	ra,56(sp)
  800100:	f822                	sd	s0,48(sp)
  800102:	e456                	sd	s5,8(sp)
  800104:	e05a                	sd	s6,0(sp)
  800106:	84aa                	mv	s1,a0
  800108:	892e                	mv	s2,a1
  80010a:	89be                	mv	s3,a5
    unsigned mod = do_div(result, base);
  80010c:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  80010e:	05067163          	bgeu	a2,a6,800150 <printnum+0x68>
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800112:	fff7041b          	addiw	s0,a4,-1
  800116:	00805763          	blez	s0,800124 <printnum+0x3c>
  80011a:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  80011c:	85ca                	mv	a1,s2
  80011e:	854e                	mv	a0,s3
  800120:	9482                	jalr	s1
        while (-- width > 0)
  800122:	fc65                	bnez	s0,80011a <printnum+0x32>
  800124:	00000417          	auipc	s0,0x0
  800128:	5d440413          	addi	s0,s0,1492 # 8006f8 <main+0x86>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  80012c:	1a02                	slli	s4,s4,0x20
  80012e:	020a5a13          	srli	s4,s4,0x20
  800132:	9452                	add	s0,s0,s4
  800134:	00044503          	lbu	a0,0(s0)
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  800138:	7442                	ld	s0,48(sp)
  80013a:	70e2                	ld	ra,56(sp)
  80013c:	69e2                	ld	s3,24(sp)
  80013e:	6a42                	ld	s4,16(sp)
  800140:	6aa2                	ld	s5,8(sp)
  800142:	6b02                	ld	s6,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  800144:	85ca                	mv	a1,s2
  800146:	87a6                	mv	a5,s1
}
  800148:	7902                	ld	s2,32(sp)
  80014a:	74a2                	ld	s1,40(sp)
  80014c:	6121                	addi	sp,sp,64
    putch("0123456789abcdef"[mod], putdat);
  80014e:	8782                	jr	a5
    unsigned mod = do_div(result, base);
  800150:	03065633          	divu	a2,a2,a6
  800154:	03067ab3          	remu	s5,a2,a6
  800158:	2a81                	sext.w	s5,s5
    if (num >= base) {
  80015a:	03067863          	bgeu	a2,a6,80018a <printnum+0xa2>
        while (-- width > 0)
  80015e:	ffe7041b          	addiw	s0,a4,-2
  800162:	00805763          	blez	s0,800170 <printnum+0x88>
  800166:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800168:	85ca                	mv	a1,s2
  80016a:	854e                	mv	a0,s3
  80016c:	9482                	jalr	s1
        while (-- width > 0)
  80016e:	fc65                	bnez	s0,800166 <printnum+0x7e>
  800170:	00000417          	auipc	s0,0x0
  800174:	58840413          	addi	s0,s0,1416 # 8006f8 <main+0x86>
    putch("0123456789abcdef"[mod], putdat);
  800178:	1a82                	slli	s5,s5,0x20
  80017a:	020ada93          	srli	s5,s5,0x20
  80017e:	9aa2                	add	s5,s5,s0
  800180:	000ac503          	lbu	a0,0(s5)
  800184:	85ca                	mv	a1,s2
  800186:	9482                	jalr	s1
}
  800188:	b755                	j	80012c <printnum+0x44>
    unsigned mod = do_div(result, base);
  80018a:	03065633          	divu	a2,a2,a6
        while (-- width > 0)
  80018e:	ffd7041b          	addiw	s0,a4,-3
    unsigned mod = do_div(result, base);
  800192:	03067b33          	remu	s6,a2,a6
  800196:	2b01                	sext.w	s6,s6
    if (num >= base) {
  800198:	03067663          	bgeu	a2,a6,8001c4 <printnum+0xdc>
        while (-- width > 0)
  80019c:	00805763          	blez	s0,8001aa <printnum+0xc2>
  8001a0:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  8001a2:	85ca                	mv	a1,s2
  8001a4:	854e                	mv	a0,s3
  8001a6:	9482                	jalr	s1
        while (-- width > 0)
  8001a8:	fc65                	bnez	s0,8001a0 <printnum+0xb8>
    putch("0123456789abcdef"[mod], putdat);
  8001aa:	1b02                	slli	s6,s6,0x20
  8001ac:	00000417          	auipc	s0,0x0
  8001b0:	54c40413          	addi	s0,s0,1356 # 8006f8 <main+0x86>
  8001b4:	020b5b13          	srli	s6,s6,0x20
  8001b8:	9b22                	add	s6,s6,s0
  8001ba:	000b4503          	lbu	a0,0(s6)
  8001be:	85ca                	mv	a1,s2
  8001c0:	9482                	jalr	s1
}
  8001c2:	bf5d                	j	800178 <printnum+0x90>
        printnum(putch, putdat, result, base, width - 1, padc);
  8001c4:	03065633          	divu	a2,a2,a6
  8001c8:	8722                	mv	a4,s0
  8001ca:	f1fff0ef          	jal	ra,8000e8 <printnum>
  8001ce:	bff1                	j	8001aa <printnum+0xc2>

00000000008001d0 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  8001d0:	7119                	addi	sp,sp,-128
  8001d2:	f4a6                	sd	s1,104(sp)
  8001d4:	f0ca                	sd	s2,96(sp)
  8001d6:	ecce                	sd	s3,88(sp)
  8001d8:	e8d2                	sd	s4,80(sp)
  8001da:	e4d6                	sd	s5,72(sp)
  8001dc:	e0da                	sd	s6,64(sp)
  8001de:	fc5e                	sd	s7,56(sp)
  8001e0:	f466                	sd	s9,40(sp)
  8001e2:	fc86                	sd	ra,120(sp)
  8001e4:	f8a2                	sd	s0,112(sp)
  8001e6:	f862                	sd	s8,48(sp)
  8001e8:	f06a                	sd	s10,32(sp)
  8001ea:	ec6e                	sd	s11,24(sp)
  8001ec:	892a                	mv	s2,a0
  8001ee:	84ae                	mv	s1,a1
  8001f0:	8cb2                	mv	s9,a2
  8001f2:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001f4:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  8001f8:	5bfd                	li	s7,-1
  8001fa:	00000a97          	auipc	s5,0x0
  8001fe:	532a8a93          	addi	s5,s5,1330 # 80072c <main+0xba>
    putch("0123456789abcdef"[mod], putdat);
  800202:	00000b17          	auipc	s6,0x0
  800206:	4f6b0b13          	addi	s6,s6,1270 # 8006f8 <main+0x86>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80020a:	000cc503          	lbu	a0,0(s9)
  80020e:	001c8413          	addi	s0,s9,1
  800212:	01350a63          	beq	a0,s3,800226 <vprintfmt+0x56>
            if (ch == '\0') {
  800216:	c121                	beqz	a0,800256 <vprintfmt+0x86>
            putch(ch, putdat);
  800218:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80021a:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  80021c:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80021e:	fff44503          	lbu	a0,-1(s0)
  800222:	ff351ae3          	bne	a0,s3,800216 <vprintfmt+0x46>
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  800226:	00044683          	lbu	a3,0(s0)
        char padc = ' ';
  80022a:	02000813          	li	a6,32
        lflag = altflag = 0;
  80022e:	4d81                	li	s11,0
  800230:	4501                	li	a0,0
        width = precision = -1;
  800232:	5c7d                	li	s8,-1
  800234:	5d7d                	li	s10,-1
  800236:	05500613          	li	a2,85
        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
  80023a:	45a5                	li	a1,9
        switch (ch = *(unsigned char *)fmt ++) {
  80023c:	fdd6879b          	addiw	a5,a3,-35
  800240:	0ff7f793          	zext.b	a5,a5
  800244:	00140c93          	addi	s9,s0,1
  800248:	04f66263          	bltu	a2,a5,80028c <vprintfmt+0xbc>
  80024c:	078a                	slli	a5,a5,0x2
  80024e:	97d6                	add	a5,a5,s5
  800250:	439c                	lw	a5,0(a5)
  800252:	97d6                	add	a5,a5,s5
  800254:	8782                	jr	a5
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  800256:	70e6                	ld	ra,120(sp)
  800258:	7446                	ld	s0,112(sp)
  80025a:	74a6                	ld	s1,104(sp)
  80025c:	7906                	ld	s2,96(sp)
  80025e:	69e6                	ld	s3,88(sp)
  800260:	6a46                	ld	s4,80(sp)
  800262:	6aa6                	ld	s5,72(sp)
  800264:	6b06                	ld	s6,64(sp)
  800266:	7be2                	ld	s7,56(sp)
  800268:	7c42                	ld	s8,48(sp)
  80026a:	7ca2                	ld	s9,40(sp)
  80026c:	7d02                	ld	s10,32(sp)
  80026e:	6de2                	ld	s11,24(sp)
  800270:	6109                	addi	sp,sp,128
  800272:	8082                	ret
            padc = '0';
  800274:	8836                	mv	a6,a3
            goto reswitch;
  800276:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  80027a:	8466                	mv	s0,s9
  80027c:	00140c93          	addi	s9,s0,1
  800280:	fdd6879b          	addiw	a5,a3,-35
  800284:	0ff7f793          	zext.b	a5,a5
  800288:	fcf672e3          	bgeu	a2,a5,80024c <vprintfmt+0x7c>
            putch('%', putdat);
  80028c:	85a6                	mv	a1,s1
  80028e:	02500513          	li	a0,37
  800292:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800294:	fff44783          	lbu	a5,-1(s0)
  800298:	8ca2                	mv	s9,s0
  80029a:	f73788e3          	beq	a5,s3,80020a <vprintfmt+0x3a>
  80029e:	ffecc783          	lbu	a5,-2(s9)
  8002a2:	1cfd                	addi	s9,s9,-1
  8002a4:	ff379de3          	bne	a5,s3,80029e <vprintfmt+0xce>
  8002a8:	b78d                	j	80020a <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  8002aa:	fd068c1b          	addiw	s8,a3,-48
                ch = *fmt;
  8002ae:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  8002b2:	8466                	mv	s0,s9
                if (ch < '0' || ch > '9') {
  8002b4:	fd06879b          	addiw	a5,a3,-48
                ch = *fmt;
  8002b8:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  8002bc:	02f5e563          	bltu	a1,a5,8002e6 <vprintfmt+0x116>
                ch = *fmt;
  8002c0:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
  8002c4:	002c179b          	slliw	a5,s8,0x2
  8002c8:	0187873b          	addw	a4,a5,s8
  8002cc:	0017171b          	slliw	a4,a4,0x1
  8002d0:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
  8002d4:	fd06879b          	addiw	a5,a3,-48
            for (precision = 0; ; ++ fmt) {
  8002d8:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  8002da:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  8002de:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  8002e2:	fcf5ffe3          	bgeu	a1,a5,8002c0 <vprintfmt+0xf0>
            if (width < 0)
  8002e6:	f40d5be3          	bgez	s10,80023c <vprintfmt+0x6c>
                width = precision, precision = -1;
  8002ea:	8d62                	mv	s10,s8
  8002ec:	5c7d                	li	s8,-1
  8002ee:	b7b9                	j	80023c <vprintfmt+0x6c>
            if (width < 0)
  8002f0:	fffd4793          	not	a5,s10
  8002f4:	97fd                	srai	a5,a5,0x3f
  8002f6:	00fd7d33          	and	s10,s10,a5
        switch (ch = *(unsigned char *)fmt ++) {
  8002fa:	00144683          	lbu	a3,1(s0)
  8002fe:	2d01                	sext.w	s10,s10
  800300:	8466                	mv	s0,s9
            goto reswitch;
  800302:	bf2d                	j	80023c <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  800304:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  800308:	00144683          	lbu	a3,1(s0)
            precision = va_arg(ap, int);
  80030c:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  80030e:	8466                	mv	s0,s9
            goto process_precision;
  800310:	bfd9                	j	8002e6 <vprintfmt+0x116>
    if (lflag >= 2) {
  800312:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800314:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800318:	00a7c463          	blt	a5,a0,800320 <vprintfmt+0x150>
    else if (lflag) {
  80031c:	28050a63          	beqz	a0,8005b0 <vprintfmt+0x3e0>
        return va_arg(*ap, unsigned long);
  800320:	000a3783          	ld	a5,0(s4)
  800324:	4641                	li	a2,16
  800326:	8a3a                	mv	s4,a4
  800328:	46c1                	li	a3,16
    unsigned mod = do_div(result, base);
  80032a:	02c7fdb3          	remu	s11,a5,a2
            printnum(putch, putdat, num, base, width, padc);
  80032e:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  800332:	0ac7f563          	bgeu	a5,a2,8003dc <vprintfmt+0x20c>
        while (-- width > 0)
  800336:	3d7d                	addiw	s10,s10,-1
  800338:	01a05863          	blez	s10,800348 <vprintfmt+0x178>
  80033c:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  80033e:	85a6                	mv	a1,s1
  800340:	8562                	mv	a0,s8
  800342:	9902                	jalr	s2
        while (-- width > 0)
  800344:	fe0d1ce3          	bnez	s10,80033c <vprintfmt+0x16c>
    putch("0123456789abcdef"[mod], putdat);
  800348:	9dda                	add	s11,s11,s6
  80034a:	000dc503          	lbu	a0,0(s11)
  80034e:	85a6                	mv	a1,s1
  800350:	9902                	jalr	s2
}
  800352:	bd65                	j	80020a <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  800354:	000a2503          	lw	a0,0(s4)
  800358:	85a6                	mv	a1,s1
  80035a:	0a21                	addi	s4,s4,8
  80035c:	9902                	jalr	s2
            break;
  80035e:	b575                	j	80020a <vprintfmt+0x3a>
    if (lflag >= 2) {
  800360:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800362:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800366:	00a7c463          	blt	a5,a0,80036e <vprintfmt+0x19e>
    else if (lflag) {
  80036a:	22050d63          	beqz	a0,8005a4 <vprintfmt+0x3d4>
        return va_arg(*ap, unsigned long);
  80036e:	000a3783          	ld	a5,0(s4)
  800372:	4629                	li	a2,10
  800374:	8a3a                	mv	s4,a4
  800376:	46a9                	li	a3,10
  800378:	bf4d                	j	80032a <vprintfmt+0x15a>
        switch (ch = *(unsigned char *)fmt ++) {
  80037a:	00144683          	lbu	a3,1(s0)
            altflag = 1;
  80037e:	4d85                	li	s11,1
        switch (ch = *(unsigned char *)fmt ++) {
  800380:	8466                	mv	s0,s9
            goto reswitch;
  800382:	bd6d                	j	80023c <vprintfmt+0x6c>
            putch(ch, putdat);
  800384:	85a6                	mv	a1,s1
  800386:	02500513          	li	a0,37
  80038a:	9902                	jalr	s2
            break;
  80038c:	bdbd                	j	80020a <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  80038e:	00144683          	lbu	a3,1(s0)
            lflag ++;
  800392:	2505                	addiw	a0,a0,1
        switch (ch = *(unsigned char *)fmt ++) {
  800394:	8466                	mv	s0,s9
            goto reswitch;
  800396:	b55d                	j	80023c <vprintfmt+0x6c>
    if (lflag >= 2) {
  800398:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80039a:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  80039e:	00a7c463          	blt	a5,a0,8003a6 <vprintfmt+0x1d6>
    else if (lflag) {
  8003a2:	1e050b63          	beqz	a0,800598 <vprintfmt+0x3c8>
        return va_arg(*ap, unsigned long);
  8003a6:	000a3783          	ld	a5,0(s4)
  8003aa:	4621                	li	a2,8
  8003ac:	8a3a                	mv	s4,a4
  8003ae:	46a1                	li	a3,8
  8003b0:	bfad                	j	80032a <vprintfmt+0x15a>
            putch('0', putdat);
  8003b2:	03000513          	li	a0,48
  8003b6:	85a6                	mv	a1,s1
  8003b8:	e042                	sd	a6,0(sp)
  8003ba:	9902                	jalr	s2
            putch('x', putdat);
  8003bc:	85a6                	mv	a1,s1
  8003be:	07800513          	li	a0,120
  8003c2:	9902                	jalr	s2
            goto number;
  8003c4:	6802                	ld	a6,0(sp)
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8003c6:	000a3783          	ld	a5,0(s4)
            goto number;
  8003ca:	4641                	li	a2,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8003cc:	0a21                	addi	s4,s4,8
    unsigned mod = do_div(result, base);
  8003ce:	02c7fdb3          	remu	s11,a5,a2
            goto number;
  8003d2:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
  8003d4:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  8003d8:	f4c7efe3          	bltu	a5,a2,800336 <vprintfmt+0x166>
        while (-- width > 0)
  8003dc:	3d79                	addiw	s10,s10,-2
    unsigned mod = do_div(result, base);
  8003de:	02c7d7b3          	divu	a5,a5,a2
  8003e2:	02c7f433          	remu	s0,a5,a2
    if (num >= base) {
  8003e6:	10c7f463          	bgeu	a5,a2,8004ee <vprintfmt+0x31e>
        while (-- width > 0)
  8003ea:	01a05863          	blez	s10,8003fa <vprintfmt+0x22a>
  8003ee:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  8003f0:	85a6                	mv	a1,s1
  8003f2:	8562                	mv	a0,s8
  8003f4:	9902                	jalr	s2
        while (-- width > 0)
  8003f6:	fe0d1ce3          	bnez	s10,8003ee <vprintfmt+0x21e>
    putch("0123456789abcdef"[mod], putdat);
  8003fa:	945a                	add	s0,s0,s6
  8003fc:	00044503          	lbu	a0,0(s0)
  800400:	85a6                	mv	a1,s1
  800402:	9dda                	add	s11,s11,s6
  800404:	9902                	jalr	s2
  800406:	000dc503          	lbu	a0,0(s11)
  80040a:	85a6                	mv	a1,s1
  80040c:	9902                	jalr	s2
  80040e:	bbf5                	j	80020a <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
  800410:	000a3403          	ld	s0,0(s4)
  800414:	008a0793          	addi	a5,s4,8
  800418:	e43e                	sd	a5,8(sp)
  80041a:	1e040563          	beqz	s0,800604 <vprintfmt+0x434>
            if (width > 0 && padc != '-') {
  80041e:	15a05263          	blez	s10,800562 <vprintfmt+0x392>
  800422:	02d00793          	li	a5,45
  800426:	10f81b63          	bne	a6,a5,80053c <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80042a:	00044783          	lbu	a5,0(s0)
  80042e:	0007851b          	sext.w	a0,a5
  800432:	0e078c63          	beqz	a5,80052a <vprintfmt+0x35a>
  800436:	0405                	addi	s0,s0,1
  800438:	120d8e63          	beqz	s11,800574 <vprintfmt+0x3a4>
                if (altflag && (ch < ' ' || ch > '~')) {
  80043c:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800440:	020c4963          	bltz	s8,800472 <vprintfmt+0x2a2>
  800444:	fffc0a1b          	addiw	s4,s8,-1
  800448:	0d7a0f63          	beq	s4,s7,800526 <vprintfmt+0x356>
                if (altflag && (ch < ' ' || ch > '~')) {
  80044c:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  80044e:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800450:	02fdf663          	bgeu	s11,a5,80047c <vprintfmt+0x2ac>
                    putch('?', putdat);
  800454:	03f00513          	li	a0,63
  800458:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80045a:	00044783          	lbu	a5,0(s0)
  80045e:	3d7d                	addiw	s10,s10,-1
  800460:	0405                	addi	s0,s0,1
  800462:	0007851b          	sext.w	a0,a5
  800466:	c3e1                	beqz	a5,800526 <vprintfmt+0x356>
  800468:	140c4a63          	bltz	s8,8005bc <vprintfmt+0x3ec>
  80046c:	8c52                	mv	s8,s4
  80046e:	fc0c5be3          	bgez	s8,800444 <vprintfmt+0x274>
                if (altflag && (ch < ' ' || ch > '~')) {
  800472:	3781                	addiw	a5,a5,-32
  800474:	8a62                	mv	s4,s8
                    putch('?', putdat);
  800476:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800478:	fcfdeee3          	bltu	s11,a5,800454 <vprintfmt+0x284>
                    putch(ch, putdat);
  80047c:	9902                	jalr	s2
  80047e:	bff1                	j	80045a <vprintfmt+0x28a>
    if (lflag >= 2) {
  800480:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800482:	008a0d93          	addi	s11,s4,8
    if (lflag >= 2) {
  800486:	00a7c463          	blt	a5,a0,80048e <vprintfmt+0x2be>
    else if (lflag) {
  80048a:	10050463          	beqz	a0,800592 <vprintfmt+0x3c2>
        return va_arg(*ap, long);
  80048e:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  800492:	14044d63          	bltz	s0,8005ec <vprintfmt+0x41c>
            num = getint(&ap, lflag);
  800496:	87a2                	mv	a5,s0
  800498:	8a6e                	mv	s4,s11
  80049a:	4629                	li	a2,10
  80049c:	46a9                	li	a3,10
  80049e:	b571                	j	80032a <vprintfmt+0x15a>
            err = va_arg(ap, int);
  8004a0:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8004a4:	4761                	li	a4,24
            err = va_arg(ap, int);
  8004a6:	0a21                	addi	s4,s4,8
            if (err < 0) {
  8004a8:	41f7d69b          	sraiw	a3,a5,0x1f
  8004ac:	8fb5                	xor	a5,a5,a3
  8004ae:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8004b2:	02d74563          	blt	a4,a3,8004dc <vprintfmt+0x30c>
  8004b6:	00369713          	slli	a4,a3,0x3
  8004ba:	00000797          	auipc	a5,0x0
  8004be:	48e78793          	addi	a5,a5,1166 # 800948 <error_string>
  8004c2:	97ba                	add	a5,a5,a4
  8004c4:	639c                	ld	a5,0(a5)
  8004c6:	cb99                	beqz	a5,8004dc <vprintfmt+0x30c>
                printfmt(putch, putdat, "%s", p);
  8004c8:	86be                	mv	a3,a5
  8004ca:	00000617          	auipc	a2,0x0
  8004ce:	25e60613          	addi	a2,a2,606 # 800728 <main+0xb6>
  8004d2:	85a6                	mv	a1,s1
  8004d4:	854a                	mv	a0,s2
  8004d6:	160000ef          	jal	ra,800636 <printfmt>
  8004da:	bb05                	j	80020a <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  8004dc:	00000617          	auipc	a2,0x0
  8004e0:	23c60613          	addi	a2,a2,572 # 800718 <main+0xa6>
  8004e4:	85a6                	mv	a1,s1
  8004e6:	854a                	mv	a0,s2
  8004e8:	14e000ef          	jal	ra,800636 <printfmt>
  8004ec:	bb39                	j	80020a <vprintfmt+0x3a>
        printnum(putch, putdat, result, base, width - 1, padc);
  8004ee:	02c7d633          	divu	a2,a5,a2
  8004f2:	876a                	mv	a4,s10
  8004f4:	87e2                	mv	a5,s8
  8004f6:	85a6                	mv	a1,s1
  8004f8:	854a                	mv	a0,s2
  8004fa:	befff0ef          	jal	ra,8000e8 <printnum>
  8004fe:	bdf5                	j	8003fa <vprintfmt+0x22a>
                    putch(ch, putdat);
  800500:	85a6                	mv	a1,s1
  800502:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800504:	00044503          	lbu	a0,0(s0)
  800508:	3d7d                	addiw	s10,s10,-1
  80050a:	0405                	addi	s0,s0,1
  80050c:	cd09                	beqz	a0,800526 <vprintfmt+0x356>
  80050e:	008d0d3b          	addw	s10,s10,s0
  800512:	fffd0d9b          	addiw	s11,s10,-1
                    putch(ch, putdat);
  800516:	85a6                	mv	a1,s1
  800518:	408d8d3b          	subw	s10,s11,s0
  80051c:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80051e:	00044503          	lbu	a0,0(s0)
  800522:	0405                	addi	s0,s0,1
  800524:	f96d                	bnez	a0,800516 <vprintfmt+0x346>
            for (; width > 0; width --) {
  800526:	01a05963          	blez	s10,800538 <vprintfmt+0x368>
  80052a:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
  80052c:	85a6                	mv	a1,s1
  80052e:	02000513          	li	a0,32
  800532:	9902                	jalr	s2
            for (; width > 0; width --) {
  800534:	fe0d1be3          	bnez	s10,80052a <vprintfmt+0x35a>
            if ((p = va_arg(ap, char *)) == NULL) {
  800538:	6a22                	ld	s4,8(sp)
  80053a:	b9c1                	j	80020a <vprintfmt+0x3a>
                for (width -= strnlen(p, precision); width > 0; width --) {
  80053c:	85e2                	mv	a1,s8
  80053e:	8522                	mv	a0,s0
  800540:	e042                	sd	a6,0(sp)
  800542:	114000ef          	jal	ra,800656 <strnlen>
  800546:	40ad0d3b          	subw	s10,s10,a0
  80054a:	01a05c63          	blez	s10,800562 <vprintfmt+0x392>
                    putch(padc, putdat);
  80054e:	6802                	ld	a6,0(sp)
  800550:	0008051b          	sext.w	a0,a6
  800554:	85a6                	mv	a1,s1
  800556:	e02a                	sd	a0,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
  800558:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
  80055a:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  80055c:	6502                	ld	a0,0(sp)
  80055e:	fe0d1be3          	bnez	s10,800554 <vprintfmt+0x384>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800562:	00044783          	lbu	a5,0(s0)
  800566:	0405                	addi	s0,s0,1
  800568:	0007851b          	sext.w	a0,a5
  80056c:	ec0796e3          	bnez	a5,800438 <vprintfmt+0x268>
            if ((p = va_arg(ap, char *)) == NULL) {
  800570:	6a22                	ld	s4,8(sp)
  800572:	b961                	j	80020a <vprintfmt+0x3a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800574:	f80c46e3          	bltz	s8,800500 <vprintfmt+0x330>
  800578:	3c7d                	addiw	s8,s8,-1
  80057a:	fb7c06e3          	beq	s8,s7,800526 <vprintfmt+0x356>
                    putch(ch, putdat);
  80057e:	85a6                	mv	a1,s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800580:	0405                	addi	s0,s0,1
                    putch(ch, putdat);
  800582:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800584:	fff44503          	lbu	a0,-1(s0)
  800588:	3d7d                	addiw	s10,s10,-1
  80058a:	f56d                	bnez	a0,800574 <vprintfmt+0x3a4>
            for (; width > 0; width --) {
  80058c:	f9a04fe3          	bgtz	s10,80052a <vprintfmt+0x35a>
  800590:	b765                	j	800538 <vprintfmt+0x368>
        return va_arg(*ap, int);
  800592:	000a2403          	lw	s0,0(s4)
  800596:	bdf5                	j	800492 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned int);
  800598:	000a6783          	lwu	a5,0(s4)
  80059c:	4621                	li	a2,8
  80059e:	8a3a                	mv	s4,a4
  8005a0:	46a1                	li	a3,8
  8005a2:	b361                	j	80032a <vprintfmt+0x15a>
  8005a4:	000a6783          	lwu	a5,0(s4)
  8005a8:	4629                	li	a2,10
  8005aa:	8a3a                	mv	s4,a4
  8005ac:	46a9                	li	a3,10
  8005ae:	bbb5                	j	80032a <vprintfmt+0x15a>
  8005b0:	000a6783          	lwu	a5,0(s4)
  8005b4:	4641                	li	a2,16
  8005b6:	8a3a                	mv	s4,a4
  8005b8:	46c1                	li	a3,16
  8005ba:	bb85                	j	80032a <vprintfmt+0x15a>
  8005bc:	01a40d3b          	addw	s10,s0,s10
                if (altflag && (ch < ' ' || ch > '~')) {
  8005c0:	05e00d93          	li	s11,94
  8005c4:	3d7d                	addiw	s10,s10,-1
  8005c6:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  8005c8:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8005ca:	00fdf463          	bgeu	s11,a5,8005d2 <vprintfmt+0x402>
                    putch('?', putdat);
  8005ce:	03f00513          	li	a0,63
  8005d2:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005d4:	00044783          	lbu	a5,0(s0)
  8005d8:	408d073b          	subw	a4,s10,s0
  8005dc:	0405                	addi	s0,s0,1
  8005de:	0007851b          	sext.w	a0,a5
  8005e2:	f3f5                	bnez	a5,8005c6 <vprintfmt+0x3f6>
  8005e4:	8d3a                	mv	s10,a4
            for (; width > 0; width --) {
  8005e6:	f5a042e3          	bgtz	s10,80052a <vprintfmt+0x35a>
  8005ea:	b7b9                	j	800538 <vprintfmt+0x368>
                putch('-', putdat);
  8005ec:	85a6                	mv	a1,s1
  8005ee:	02d00513          	li	a0,45
  8005f2:	e042                	sd	a6,0(sp)
  8005f4:	9902                	jalr	s2
                num = -(long long)num;
  8005f6:	6802                	ld	a6,0(sp)
  8005f8:	8a6e                	mv	s4,s11
  8005fa:	408007b3          	neg	a5,s0
  8005fe:	4629                	li	a2,10
  800600:	46a9                	li	a3,10
  800602:	b325                	j	80032a <vprintfmt+0x15a>
            if (width > 0 && padc != '-') {
  800604:	03a05063          	blez	s10,800624 <vprintfmt+0x454>
  800608:	02d00793          	li	a5,45
                p = "(null)";
  80060c:	00000417          	auipc	s0,0x0
  800610:	10440413          	addi	s0,s0,260 # 800710 <main+0x9e>
            if (width > 0 && padc != '-') {
  800614:	f2f814e3          	bne	a6,a5,80053c <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800618:	02800793          	li	a5,40
  80061c:	02800513          	li	a0,40
  800620:	0405                	addi	s0,s0,1
  800622:	bd19                	j	800438 <vprintfmt+0x268>
  800624:	02800513          	li	a0,40
  800628:	02800793          	li	a5,40
  80062c:	00000417          	auipc	s0,0x0
  800630:	0e540413          	addi	s0,s0,229 # 800711 <main+0x9f>
  800634:	b511                	j	800438 <vprintfmt+0x268>

0000000000800636 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800636:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  800638:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  80063c:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  80063e:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800640:	ec06                	sd	ra,24(sp)
  800642:	f83a                	sd	a4,48(sp)
  800644:	fc3e                	sd	a5,56(sp)
  800646:	e0c2                	sd	a6,64(sp)
  800648:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  80064a:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  80064c:	b85ff0ef          	jal	ra,8001d0 <vprintfmt>
}
  800650:	60e2                	ld	ra,24(sp)
  800652:	6161                	addi	sp,sp,80
  800654:	8082                	ret

0000000000800656 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  800656:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  800658:	e589                	bnez	a1,800662 <strnlen+0xc>
  80065a:	a811                	j	80066e <strnlen+0x18>
        cnt ++;
  80065c:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  80065e:	00f58863          	beq	a1,a5,80066e <strnlen+0x18>
  800662:	00f50733          	add	a4,a0,a5
  800666:	00074703          	lbu	a4,0(a4)
  80066a:	fb6d                	bnez	a4,80065c <strnlen+0x6>
  80066c:	85be                	mv	a1,a5
    }
    return cnt;
}
  80066e:	852e                	mv	a0,a1
  800670:	8082                	ret

0000000000800672 <main>:
#include <ulib.h>
#include <stdio.h>

int
main(void) {
  800672:	1101                	addi	sp,sp,-32
  800674:	ec06                	sd	ra,24(sp)
  800676:	e822                	sd	s0,16(sp)
  800678:	e426                	sd	s1,8(sp)
  80067a:	e04a                	sd	s2,0(sp)
    int i;
    cprintf("Hello, I am process %d.\n", getpid());
  80067c:	a5fff0ef          	jal	ra,8000da <getpid>
  800680:	85aa                	mv	a1,a0
  800682:	00000517          	auipc	a0,0x0
  800686:	38e50513          	addi	a0,a0,910 # 800a10 <error_string+0xc8>
  80068a:	9b7ff0ef          	jal	ra,800040 <cprintf>
    for (i = 0; i < 5; i ++) {
  80068e:	4401                	li	s0,0
        yield();
        cprintf("Back in process %d, iteration %d.\n", getpid(), i);
  800690:	00000917          	auipc	s2,0x0
  800694:	3a090913          	addi	s2,s2,928 # 800a30 <error_string+0xe8>
    for (i = 0; i < 5; i ++) {
  800698:	4495                	li	s1,5
        yield();
  80069a:	a3fff0ef          	jal	ra,8000d8 <yield>
        cprintf("Back in process %d, iteration %d.\n", getpid(), i);
  80069e:	a3dff0ef          	jal	ra,8000da <getpid>
  8006a2:	85aa                	mv	a1,a0
  8006a4:	8622                	mv	a2,s0
  8006a6:	854a                	mv	a0,s2
    for (i = 0; i < 5; i ++) {
  8006a8:	2405                	addiw	s0,s0,1
        cprintf("Back in process %d, iteration %d.\n", getpid(), i);
  8006aa:	997ff0ef          	jal	ra,800040 <cprintf>
    for (i = 0; i < 5; i ++) {
  8006ae:	fe9416e3          	bne	s0,s1,80069a <main+0x28>
    }
    cprintf("All done in process %d.\n", getpid());
  8006b2:	a29ff0ef          	jal	ra,8000da <getpid>
  8006b6:	85aa                	mv	a1,a0
  8006b8:	00000517          	auipc	a0,0x0
  8006bc:	3a050513          	addi	a0,a0,928 # 800a58 <error_string+0x110>
  8006c0:	981ff0ef          	jal	ra,800040 <cprintf>
    cprintf("yield pass.\n");
  8006c4:	00000517          	auipc	a0,0x0
  8006c8:	3b450513          	addi	a0,a0,948 # 800a78 <error_string+0x130>
  8006cc:	975ff0ef          	jal	ra,800040 <cprintf>
    return 0;
}
  8006d0:	60e2                	ld	ra,24(sp)
  8006d2:	6442                	ld	s0,16(sp)
  8006d4:	64a2                	ld	s1,8(sp)
  8006d6:	6902                	ld	s2,0(sp)
  8006d8:	4501                	li	a0,0
  8006da:	6105                	addi	sp,sp,32
  8006dc:	8082                	ret
