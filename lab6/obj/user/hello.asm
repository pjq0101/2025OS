
obj/__user_hello.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	0b6000ef          	jal	ra,8000d6 <umain>
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
  80002e:	08a000ef          	jal	ra,8000b8 <sys_putc>
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
  80006a:	160000ef          	jal	ra,8001ca <vprintfmt>
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

00000000008000b4 <sys_getpid>:
    return syscall(SYS_kill, pid);
}

int
sys_getpid(void) {
    return syscall(SYS_getpid);
  8000b4:	4549                	li	a0,18
  8000b6:	b7c1                	j	800076 <syscall>

00000000008000b8 <sys_putc>:
}

int
sys_putc(int64_t c) {
  8000b8:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  8000ba:	4579                	li	a0,30
  8000bc:	bf6d                	j	800076 <syscall>

00000000008000be <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8000be:	1141                	addi	sp,sp,-16
  8000c0:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  8000c2:	fedff0ef          	jal	ra,8000ae <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000c6:	00000517          	auipc	a0,0x0
  8000ca:	5e250513          	addi	a0,a0,1506 # 8006a8 <main+0x3c>
  8000ce:	f73ff0ef          	jal	ra,800040 <cprintf>
    while (1);
  8000d2:	a001                	j	8000d2 <exit+0x14>

00000000008000d4 <getpid>:
    return sys_kill(pid);
}

int
getpid(void) {
    return sys_getpid();
  8000d4:	b7c5                	j	8000b4 <sys_getpid>

00000000008000d6 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8000d6:	1141                	addi	sp,sp,-16
  8000d8:	e406                	sd	ra,8(sp)
    int ret = main();
  8000da:	592000ef          	jal	ra,80066c <main>
    exit(ret);
  8000de:	fe1ff0ef          	jal	ra,8000be <exit>

00000000008000e2 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  8000e2:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000e6:	7139                	addi	sp,sp,-64
    unsigned mod = do_div(result, base);
  8000e8:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000ec:	e852                	sd	s4,16(sp)
    unsigned mod = do_div(result, base);
  8000ee:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  8000f2:	f426                	sd	s1,40(sp)
  8000f4:	f04a                	sd	s2,32(sp)
  8000f6:	ec4e                	sd	s3,24(sp)
  8000f8:	fc06                	sd	ra,56(sp)
  8000fa:	f822                	sd	s0,48(sp)
  8000fc:	e456                	sd	s5,8(sp)
  8000fe:	e05a                	sd	s6,0(sp)
  800100:	84aa                	mv	s1,a0
  800102:	892e                	mv	s2,a1
  800104:	89be                	mv	s3,a5
    unsigned mod = do_div(result, base);
  800106:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  800108:	05067163          	bgeu	a2,a6,80014a <printnum+0x68>
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  80010c:	fff7041b          	addiw	s0,a4,-1
  800110:	00805763          	blez	s0,80011e <printnum+0x3c>
  800114:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800116:	85ca                	mv	a1,s2
  800118:	854e                	mv	a0,s3
  80011a:	9482                	jalr	s1
        while (-- width > 0)
  80011c:	fc65                	bnez	s0,800114 <printnum+0x32>
  80011e:	00000417          	auipc	s0,0x0
  800122:	5a240413          	addi	s0,s0,1442 # 8006c0 <main+0x54>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  800126:	1a02                	slli	s4,s4,0x20
  800128:	020a5a13          	srli	s4,s4,0x20
  80012c:	9452                	add	s0,s0,s4
  80012e:	00044503          	lbu	a0,0(s0)
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  800132:	7442                	ld	s0,48(sp)
  800134:	70e2                	ld	ra,56(sp)
  800136:	69e2                	ld	s3,24(sp)
  800138:	6a42                	ld	s4,16(sp)
  80013a:	6aa2                	ld	s5,8(sp)
  80013c:	6b02                	ld	s6,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  80013e:	85ca                	mv	a1,s2
  800140:	87a6                	mv	a5,s1
}
  800142:	7902                	ld	s2,32(sp)
  800144:	74a2                	ld	s1,40(sp)
  800146:	6121                	addi	sp,sp,64
    putch("0123456789abcdef"[mod], putdat);
  800148:	8782                	jr	a5
    unsigned mod = do_div(result, base);
  80014a:	03065633          	divu	a2,a2,a6
  80014e:	03067ab3          	remu	s5,a2,a6
  800152:	2a81                	sext.w	s5,s5
    if (num >= base) {
  800154:	03067863          	bgeu	a2,a6,800184 <printnum+0xa2>
        while (-- width > 0)
  800158:	ffe7041b          	addiw	s0,a4,-2
  80015c:	00805763          	blez	s0,80016a <printnum+0x88>
  800160:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800162:	85ca                	mv	a1,s2
  800164:	854e                	mv	a0,s3
  800166:	9482                	jalr	s1
        while (-- width > 0)
  800168:	fc65                	bnez	s0,800160 <printnum+0x7e>
  80016a:	00000417          	auipc	s0,0x0
  80016e:	55640413          	addi	s0,s0,1366 # 8006c0 <main+0x54>
    putch("0123456789abcdef"[mod], putdat);
  800172:	1a82                	slli	s5,s5,0x20
  800174:	020ada93          	srli	s5,s5,0x20
  800178:	9aa2                	add	s5,s5,s0
  80017a:	000ac503          	lbu	a0,0(s5)
  80017e:	85ca                	mv	a1,s2
  800180:	9482                	jalr	s1
}
  800182:	b755                	j	800126 <printnum+0x44>
    unsigned mod = do_div(result, base);
  800184:	03065633          	divu	a2,a2,a6
        while (-- width > 0)
  800188:	ffd7041b          	addiw	s0,a4,-3
    unsigned mod = do_div(result, base);
  80018c:	03067b33          	remu	s6,a2,a6
  800190:	2b01                	sext.w	s6,s6
    if (num >= base) {
  800192:	03067663          	bgeu	a2,a6,8001be <printnum+0xdc>
        while (-- width > 0)
  800196:	00805763          	blez	s0,8001a4 <printnum+0xc2>
  80019a:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  80019c:	85ca                	mv	a1,s2
  80019e:	854e                	mv	a0,s3
  8001a0:	9482                	jalr	s1
        while (-- width > 0)
  8001a2:	fc65                	bnez	s0,80019a <printnum+0xb8>
    putch("0123456789abcdef"[mod], putdat);
  8001a4:	1b02                	slli	s6,s6,0x20
  8001a6:	00000417          	auipc	s0,0x0
  8001aa:	51a40413          	addi	s0,s0,1306 # 8006c0 <main+0x54>
  8001ae:	020b5b13          	srli	s6,s6,0x20
  8001b2:	9b22                	add	s6,s6,s0
  8001b4:	000b4503          	lbu	a0,0(s6)
  8001b8:	85ca                	mv	a1,s2
  8001ba:	9482                	jalr	s1
}
  8001bc:	bf5d                	j	800172 <printnum+0x90>
        printnum(putch, putdat, result, base, width - 1, padc);
  8001be:	03065633          	divu	a2,a2,a6
  8001c2:	8722                	mv	a4,s0
  8001c4:	f1fff0ef          	jal	ra,8000e2 <printnum>
  8001c8:	bff1                	j	8001a4 <printnum+0xc2>

00000000008001ca <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  8001ca:	7119                	addi	sp,sp,-128
  8001cc:	f4a6                	sd	s1,104(sp)
  8001ce:	f0ca                	sd	s2,96(sp)
  8001d0:	ecce                	sd	s3,88(sp)
  8001d2:	e8d2                	sd	s4,80(sp)
  8001d4:	e4d6                	sd	s5,72(sp)
  8001d6:	e0da                	sd	s6,64(sp)
  8001d8:	fc5e                	sd	s7,56(sp)
  8001da:	f466                	sd	s9,40(sp)
  8001dc:	fc86                	sd	ra,120(sp)
  8001de:	f8a2                	sd	s0,112(sp)
  8001e0:	f862                	sd	s8,48(sp)
  8001e2:	f06a                	sd	s10,32(sp)
  8001e4:	ec6e                	sd	s11,24(sp)
  8001e6:	892a                	mv	s2,a0
  8001e8:	84ae                	mv	s1,a1
  8001ea:	8cb2                	mv	s9,a2
  8001ec:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001ee:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  8001f2:	5bfd                	li	s7,-1
  8001f4:	00000a97          	auipc	s5,0x0
  8001f8:	500a8a93          	addi	s5,s5,1280 # 8006f4 <main+0x88>
    putch("0123456789abcdef"[mod], putdat);
  8001fc:	00000b17          	auipc	s6,0x0
  800200:	4c4b0b13          	addi	s6,s6,1220 # 8006c0 <main+0x54>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800204:	000cc503          	lbu	a0,0(s9)
  800208:	001c8413          	addi	s0,s9,1
  80020c:	01350a63          	beq	a0,s3,800220 <vprintfmt+0x56>
            if (ch == '\0') {
  800210:	c121                	beqz	a0,800250 <vprintfmt+0x86>
            putch(ch, putdat);
  800212:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800214:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  800216:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800218:	fff44503          	lbu	a0,-1(s0)
  80021c:	ff351ae3          	bne	a0,s3,800210 <vprintfmt+0x46>
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  800220:	00044683          	lbu	a3,0(s0)
        char padc = ' ';
  800224:	02000813          	li	a6,32
        lflag = altflag = 0;
  800228:	4d81                	li	s11,0
  80022a:	4501                	li	a0,0
        width = precision = -1;
  80022c:	5c7d                	li	s8,-1
  80022e:	5d7d                	li	s10,-1
  800230:	05500613          	li	a2,85
        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
  800234:	45a5                	li	a1,9
        switch (ch = *(unsigned char *)fmt ++) {
  800236:	fdd6879b          	addiw	a5,a3,-35
  80023a:	0ff7f793          	zext.b	a5,a5
  80023e:	00140c93          	addi	s9,s0,1
  800242:	04f66263          	bltu	a2,a5,800286 <vprintfmt+0xbc>
  800246:	078a                	slli	a5,a5,0x2
  800248:	97d6                	add	a5,a5,s5
  80024a:	439c                	lw	a5,0(a5)
  80024c:	97d6                	add	a5,a5,s5
  80024e:	8782                	jr	a5
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  800250:	70e6                	ld	ra,120(sp)
  800252:	7446                	ld	s0,112(sp)
  800254:	74a6                	ld	s1,104(sp)
  800256:	7906                	ld	s2,96(sp)
  800258:	69e6                	ld	s3,88(sp)
  80025a:	6a46                	ld	s4,80(sp)
  80025c:	6aa6                	ld	s5,72(sp)
  80025e:	6b06                	ld	s6,64(sp)
  800260:	7be2                	ld	s7,56(sp)
  800262:	7c42                	ld	s8,48(sp)
  800264:	7ca2                	ld	s9,40(sp)
  800266:	7d02                	ld	s10,32(sp)
  800268:	6de2                	ld	s11,24(sp)
  80026a:	6109                	addi	sp,sp,128
  80026c:	8082                	ret
            padc = '0';
  80026e:	8836                	mv	a6,a3
            goto reswitch;
  800270:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800274:	8466                	mv	s0,s9
  800276:	00140c93          	addi	s9,s0,1
  80027a:	fdd6879b          	addiw	a5,a3,-35
  80027e:	0ff7f793          	zext.b	a5,a5
  800282:	fcf672e3          	bgeu	a2,a5,800246 <vprintfmt+0x7c>
            putch('%', putdat);
  800286:	85a6                	mv	a1,s1
  800288:	02500513          	li	a0,37
  80028c:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  80028e:	fff44783          	lbu	a5,-1(s0)
  800292:	8ca2                	mv	s9,s0
  800294:	f73788e3          	beq	a5,s3,800204 <vprintfmt+0x3a>
  800298:	ffecc783          	lbu	a5,-2(s9)
  80029c:	1cfd                	addi	s9,s9,-1
  80029e:	ff379de3          	bne	a5,s3,800298 <vprintfmt+0xce>
  8002a2:	b78d                	j	800204 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  8002a4:	fd068c1b          	addiw	s8,a3,-48
                ch = *fmt;
  8002a8:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  8002ac:	8466                	mv	s0,s9
                if (ch < '0' || ch > '9') {
  8002ae:	fd06879b          	addiw	a5,a3,-48
                ch = *fmt;
  8002b2:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  8002b6:	02f5e563          	bltu	a1,a5,8002e0 <vprintfmt+0x116>
                ch = *fmt;
  8002ba:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
  8002be:	002c179b          	slliw	a5,s8,0x2
  8002c2:	0187873b          	addw	a4,a5,s8
  8002c6:	0017171b          	slliw	a4,a4,0x1
  8002ca:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
  8002ce:	fd06879b          	addiw	a5,a3,-48
            for (precision = 0; ; ++ fmt) {
  8002d2:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  8002d4:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  8002d8:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  8002dc:	fcf5ffe3          	bgeu	a1,a5,8002ba <vprintfmt+0xf0>
            if (width < 0)
  8002e0:	f40d5be3          	bgez	s10,800236 <vprintfmt+0x6c>
                width = precision, precision = -1;
  8002e4:	8d62                	mv	s10,s8
  8002e6:	5c7d                	li	s8,-1
  8002e8:	b7b9                	j	800236 <vprintfmt+0x6c>
            if (width < 0)
  8002ea:	fffd4793          	not	a5,s10
  8002ee:	97fd                	srai	a5,a5,0x3f
  8002f0:	00fd7d33          	and	s10,s10,a5
        switch (ch = *(unsigned char *)fmt ++) {
  8002f4:	00144683          	lbu	a3,1(s0)
  8002f8:	2d01                	sext.w	s10,s10
  8002fa:	8466                	mv	s0,s9
            goto reswitch;
  8002fc:	bf2d                	j	800236 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  8002fe:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  800302:	00144683          	lbu	a3,1(s0)
            precision = va_arg(ap, int);
  800306:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  800308:	8466                	mv	s0,s9
            goto process_precision;
  80030a:	bfd9                	j	8002e0 <vprintfmt+0x116>
    if (lflag >= 2) {
  80030c:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80030e:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800312:	00a7c463          	blt	a5,a0,80031a <vprintfmt+0x150>
    else if (lflag) {
  800316:	28050a63          	beqz	a0,8005aa <vprintfmt+0x3e0>
        return va_arg(*ap, unsigned long);
  80031a:	000a3783          	ld	a5,0(s4)
  80031e:	4641                	li	a2,16
  800320:	8a3a                	mv	s4,a4
  800322:	46c1                	li	a3,16
    unsigned mod = do_div(result, base);
  800324:	02c7fdb3          	remu	s11,a5,a2
            printnum(putch, putdat, num, base, width, padc);
  800328:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  80032c:	0ac7f563          	bgeu	a5,a2,8003d6 <vprintfmt+0x20c>
        while (-- width > 0)
  800330:	3d7d                	addiw	s10,s10,-1
  800332:	01a05863          	blez	s10,800342 <vprintfmt+0x178>
  800336:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  800338:	85a6                	mv	a1,s1
  80033a:	8562                	mv	a0,s8
  80033c:	9902                	jalr	s2
        while (-- width > 0)
  80033e:	fe0d1ce3          	bnez	s10,800336 <vprintfmt+0x16c>
    putch("0123456789abcdef"[mod], putdat);
  800342:	9dda                	add	s11,s11,s6
  800344:	000dc503          	lbu	a0,0(s11)
  800348:	85a6                	mv	a1,s1
  80034a:	9902                	jalr	s2
}
  80034c:	bd65                	j	800204 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  80034e:	000a2503          	lw	a0,0(s4)
  800352:	85a6                	mv	a1,s1
  800354:	0a21                	addi	s4,s4,8
  800356:	9902                	jalr	s2
            break;
  800358:	b575                	j	800204 <vprintfmt+0x3a>
    if (lflag >= 2) {
  80035a:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80035c:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800360:	00a7c463          	blt	a5,a0,800368 <vprintfmt+0x19e>
    else if (lflag) {
  800364:	22050d63          	beqz	a0,80059e <vprintfmt+0x3d4>
        return va_arg(*ap, unsigned long);
  800368:	000a3783          	ld	a5,0(s4)
  80036c:	4629                	li	a2,10
  80036e:	8a3a                	mv	s4,a4
  800370:	46a9                	li	a3,10
  800372:	bf4d                	j	800324 <vprintfmt+0x15a>
        switch (ch = *(unsigned char *)fmt ++) {
  800374:	00144683          	lbu	a3,1(s0)
            altflag = 1;
  800378:	4d85                	li	s11,1
        switch (ch = *(unsigned char *)fmt ++) {
  80037a:	8466                	mv	s0,s9
            goto reswitch;
  80037c:	bd6d                	j	800236 <vprintfmt+0x6c>
            putch(ch, putdat);
  80037e:	85a6                	mv	a1,s1
  800380:	02500513          	li	a0,37
  800384:	9902                	jalr	s2
            break;
  800386:	bdbd                	j	800204 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  800388:	00144683          	lbu	a3,1(s0)
            lflag ++;
  80038c:	2505                	addiw	a0,a0,1
        switch (ch = *(unsigned char *)fmt ++) {
  80038e:	8466                	mv	s0,s9
            goto reswitch;
  800390:	b55d                	j	800236 <vprintfmt+0x6c>
    if (lflag >= 2) {
  800392:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800394:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800398:	00a7c463          	blt	a5,a0,8003a0 <vprintfmt+0x1d6>
    else if (lflag) {
  80039c:	1e050b63          	beqz	a0,800592 <vprintfmt+0x3c8>
        return va_arg(*ap, unsigned long);
  8003a0:	000a3783          	ld	a5,0(s4)
  8003a4:	4621                	li	a2,8
  8003a6:	8a3a                	mv	s4,a4
  8003a8:	46a1                	li	a3,8
  8003aa:	bfad                	j	800324 <vprintfmt+0x15a>
            putch('0', putdat);
  8003ac:	03000513          	li	a0,48
  8003b0:	85a6                	mv	a1,s1
  8003b2:	e042                	sd	a6,0(sp)
  8003b4:	9902                	jalr	s2
            putch('x', putdat);
  8003b6:	85a6                	mv	a1,s1
  8003b8:	07800513          	li	a0,120
  8003bc:	9902                	jalr	s2
            goto number;
  8003be:	6802                	ld	a6,0(sp)
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8003c0:	000a3783          	ld	a5,0(s4)
            goto number;
  8003c4:	4641                	li	a2,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8003c6:	0a21                	addi	s4,s4,8
    unsigned mod = do_div(result, base);
  8003c8:	02c7fdb3          	remu	s11,a5,a2
            goto number;
  8003cc:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
  8003ce:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  8003d2:	f4c7efe3          	bltu	a5,a2,800330 <vprintfmt+0x166>
        while (-- width > 0)
  8003d6:	3d79                	addiw	s10,s10,-2
    unsigned mod = do_div(result, base);
  8003d8:	02c7d7b3          	divu	a5,a5,a2
  8003dc:	02c7f433          	remu	s0,a5,a2
    if (num >= base) {
  8003e0:	10c7f463          	bgeu	a5,a2,8004e8 <vprintfmt+0x31e>
        while (-- width > 0)
  8003e4:	01a05863          	blez	s10,8003f4 <vprintfmt+0x22a>
  8003e8:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  8003ea:	85a6                	mv	a1,s1
  8003ec:	8562                	mv	a0,s8
  8003ee:	9902                	jalr	s2
        while (-- width > 0)
  8003f0:	fe0d1ce3          	bnez	s10,8003e8 <vprintfmt+0x21e>
    putch("0123456789abcdef"[mod], putdat);
  8003f4:	945a                	add	s0,s0,s6
  8003f6:	00044503          	lbu	a0,0(s0)
  8003fa:	85a6                	mv	a1,s1
  8003fc:	9dda                	add	s11,s11,s6
  8003fe:	9902                	jalr	s2
  800400:	000dc503          	lbu	a0,0(s11)
  800404:	85a6                	mv	a1,s1
  800406:	9902                	jalr	s2
  800408:	bbf5                	j	800204 <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
  80040a:	000a3403          	ld	s0,0(s4)
  80040e:	008a0793          	addi	a5,s4,8
  800412:	e43e                	sd	a5,8(sp)
  800414:	1e040563          	beqz	s0,8005fe <vprintfmt+0x434>
            if (width > 0 && padc != '-') {
  800418:	15a05263          	blez	s10,80055c <vprintfmt+0x392>
  80041c:	02d00793          	li	a5,45
  800420:	10f81b63          	bne	a6,a5,800536 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800424:	00044783          	lbu	a5,0(s0)
  800428:	0007851b          	sext.w	a0,a5
  80042c:	0e078c63          	beqz	a5,800524 <vprintfmt+0x35a>
  800430:	0405                	addi	s0,s0,1
  800432:	120d8e63          	beqz	s11,80056e <vprintfmt+0x3a4>
                if (altflag && (ch < ' ' || ch > '~')) {
  800436:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80043a:	020c4963          	bltz	s8,80046c <vprintfmt+0x2a2>
  80043e:	fffc0a1b          	addiw	s4,s8,-1
  800442:	0d7a0f63          	beq	s4,s7,800520 <vprintfmt+0x356>
                if (altflag && (ch < ' ' || ch > '~')) {
  800446:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  800448:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  80044a:	02fdf663          	bgeu	s11,a5,800476 <vprintfmt+0x2ac>
                    putch('?', putdat);
  80044e:	03f00513          	li	a0,63
  800452:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800454:	00044783          	lbu	a5,0(s0)
  800458:	3d7d                	addiw	s10,s10,-1
  80045a:	0405                	addi	s0,s0,1
  80045c:	0007851b          	sext.w	a0,a5
  800460:	c3e1                	beqz	a5,800520 <vprintfmt+0x356>
  800462:	140c4a63          	bltz	s8,8005b6 <vprintfmt+0x3ec>
  800466:	8c52                	mv	s8,s4
  800468:	fc0c5be3          	bgez	s8,80043e <vprintfmt+0x274>
                if (altflag && (ch < ' ' || ch > '~')) {
  80046c:	3781                	addiw	a5,a5,-32
  80046e:	8a62                	mv	s4,s8
                    putch('?', putdat);
  800470:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800472:	fcfdeee3          	bltu	s11,a5,80044e <vprintfmt+0x284>
                    putch(ch, putdat);
  800476:	9902                	jalr	s2
  800478:	bff1                	j	800454 <vprintfmt+0x28a>
    if (lflag >= 2) {
  80047a:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80047c:	008a0d93          	addi	s11,s4,8
    if (lflag >= 2) {
  800480:	00a7c463          	blt	a5,a0,800488 <vprintfmt+0x2be>
    else if (lflag) {
  800484:	10050463          	beqz	a0,80058c <vprintfmt+0x3c2>
        return va_arg(*ap, long);
  800488:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  80048c:	14044d63          	bltz	s0,8005e6 <vprintfmt+0x41c>
            num = getint(&ap, lflag);
  800490:	87a2                	mv	a5,s0
  800492:	8a6e                	mv	s4,s11
  800494:	4629                	li	a2,10
  800496:	46a9                	li	a3,10
  800498:	b571                	j	800324 <vprintfmt+0x15a>
            err = va_arg(ap, int);
  80049a:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80049e:	4761                	li	a4,24
            err = va_arg(ap, int);
  8004a0:	0a21                	addi	s4,s4,8
            if (err < 0) {
  8004a2:	41f7d69b          	sraiw	a3,a5,0x1f
  8004a6:	8fb5                	xor	a5,a5,a3
  8004a8:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8004ac:	02d74563          	blt	a4,a3,8004d6 <vprintfmt+0x30c>
  8004b0:	00369713          	slli	a4,a3,0x3
  8004b4:	00000797          	auipc	a5,0x0
  8004b8:	45c78793          	addi	a5,a5,1116 # 800910 <error_string>
  8004bc:	97ba                	add	a5,a5,a4
  8004be:	639c                	ld	a5,0(a5)
  8004c0:	cb99                	beqz	a5,8004d6 <vprintfmt+0x30c>
                printfmt(putch, putdat, "%s", p);
  8004c2:	86be                	mv	a3,a5
  8004c4:	00000617          	auipc	a2,0x0
  8004c8:	22c60613          	addi	a2,a2,556 # 8006f0 <main+0x84>
  8004cc:	85a6                	mv	a1,s1
  8004ce:	854a                	mv	a0,s2
  8004d0:	160000ef          	jal	ra,800630 <printfmt>
  8004d4:	bb05                	j	800204 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  8004d6:	00000617          	auipc	a2,0x0
  8004da:	20a60613          	addi	a2,a2,522 # 8006e0 <main+0x74>
  8004de:	85a6                	mv	a1,s1
  8004e0:	854a                	mv	a0,s2
  8004e2:	14e000ef          	jal	ra,800630 <printfmt>
  8004e6:	bb39                	j	800204 <vprintfmt+0x3a>
        printnum(putch, putdat, result, base, width - 1, padc);
  8004e8:	02c7d633          	divu	a2,a5,a2
  8004ec:	876a                	mv	a4,s10
  8004ee:	87e2                	mv	a5,s8
  8004f0:	85a6                	mv	a1,s1
  8004f2:	854a                	mv	a0,s2
  8004f4:	befff0ef          	jal	ra,8000e2 <printnum>
  8004f8:	bdf5                	j	8003f4 <vprintfmt+0x22a>
                    putch(ch, putdat);
  8004fa:	85a6                	mv	a1,s1
  8004fc:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004fe:	00044503          	lbu	a0,0(s0)
  800502:	3d7d                	addiw	s10,s10,-1
  800504:	0405                	addi	s0,s0,1
  800506:	cd09                	beqz	a0,800520 <vprintfmt+0x356>
  800508:	008d0d3b          	addw	s10,s10,s0
  80050c:	fffd0d9b          	addiw	s11,s10,-1
                    putch(ch, putdat);
  800510:	85a6                	mv	a1,s1
  800512:	408d8d3b          	subw	s10,s11,s0
  800516:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800518:	00044503          	lbu	a0,0(s0)
  80051c:	0405                	addi	s0,s0,1
  80051e:	f96d                	bnez	a0,800510 <vprintfmt+0x346>
            for (; width > 0; width --) {
  800520:	01a05963          	blez	s10,800532 <vprintfmt+0x368>
  800524:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
  800526:	85a6                	mv	a1,s1
  800528:	02000513          	li	a0,32
  80052c:	9902                	jalr	s2
            for (; width > 0; width --) {
  80052e:	fe0d1be3          	bnez	s10,800524 <vprintfmt+0x35a>
            if ((p = va_arg(ap, char *)) == NULL) {
  800532:	6a22                	ld	s4,8(sp)
  800534:	b9c1                	j	800204 <vprintfmt+0x3a>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800536:	85e2                	mv	a1,s8
  800538:	8522                	mv	a0,s0
  80053a:	e042                	sd	a6,0(sp)
  80053c:	114000ef          	jal	ra,800650 <strnlen>
  800540:	40ad0d3b          	subw	s10,s10,a0
  800544:	01a05c63          	blez	s10,80055c <vprintfmt+0x392>
                    putch(padc, putdat);
  800548:	6802                	ld	a6,0(sp)
  80054a:	0008051b          	sext.w	a0,a6
  80054e:	85a6                	mv	a1,s1
  800550:	e02a                	sd	a0,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
  800552:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
  800554:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  800556:	6502                	ld	a0,0(sp)
  800558:	fe0d1be3          	bnez	s10,80054e <vprintfmt+0x384>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80055c:	00044783          	lbu	a5,0(s0)
  800560:	0405                	addi	s0,s0,1
  800562:	0007851b          	sext.w	a0,a5
  800566:	ec0796e3          	bnez	a5,800432 <vprintfmt+0x268>
            if ((p = va_arg(ap, char *)) == NULL) {
  80056a:	6a22                	ld	s4,8(sp)
  80056c:	b961                	j	800204 <vprintfmt+0x3a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80056e:	f80c46e3          	bltz	s8,8004fa <vprintfmt+0x330>
  800572:	3c7d                	addiw	s8,s8,-1
  800574:	fb7c06e3          	beq	s8,s7,800520 <vprintfmt+0x356>
                    putch(ch, putdat);
  800578:	85a6                	mv	a1,s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80057a:	0405                	addi	s0,s0,1
                    putch(ch, putdat);
  80057c:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80057e:	fff44503          	lbu	a0,-1(s0)
  800582:	3d7d                	addiw	s10,s10,-1
  800584:	f56d                	bnez	a0,80056e <vprintfmt+0x3a4>
            for (; width > 0; width --) {
  800586:	f9a04fe3          	bgtz	s10,800524 <vprintfmt+0x35a>
  80058a:	b765                	j	800532 <vprintfmt+0x368>
        return va_arg(*ap, int);
  80058c:	000a2403          	lw	s0,0(s4)
  800590:	bdf5                	j	80048c <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned int);
  800592:	000a6783          	lwu	a5,0(s4)
  800596:	4621                	li	a2,8
  800598:	8a3a                	mv	s4,a4
  80059a:	46a1                	li	a3,8
  80059c:	b361                	j	800324 <vprintfmt+0x15a>
  80059e:	000a6783          	lwu	a5,0(s4)
  8005a2:	4629                	li	a2,10
  8005a4:	8a3a                	mv	s4,a4
  8005a6:	46a9                	li	a3,10
  8005a8:	bbb5                	j	800324 <vprintfmt+0x15a>
  8005aa:	000a6783          	lwu	a5,0(s4)
  8005ae:	4641                	li	a2,16
  8005b0:	8a3a                	mv	s4,a4
  8005b2:	46c1                	li	a3,16
  8005b4:	bb85                	j	800324 <vprintfmt+0x15a>
  8005b6:	01a40d3b          	addw	s10,s0,s10
                if (altflag && (ch < ' ' || ch > '~')) {
  8005ba:	05e00d93          	li	s11,94
  8005be:	3d7d                	addiw	s10,s10,-1
  8005c0:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  8005c2:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8005c4:	00fdf463          	bgeu	s11,a5,8005cc <vprintfmt+0x402>
                    putch('?', putdat);
  8005c8:	03f00513          	li	a0,63
  8005cc:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005ce:	00044783          	lbu	a5,0(s0)
  8005d2:	408d073b          	subw	a4,s10,s0
  8005d6:	0405                	addi	s0,s0,1
  8005d8:	0007851b          	sext.w	a0,a5
  8005dc:	f3f5                	bnez	a5,8005c0 <vprintfmt+0x3f6>
  8005de:	8d3a                	mv	s10,a4
            for (; width > 0; width --) {
  8005e0:	f5a042e3          	bgtz	s10,800524 <vprintfmt+0x35a>
  8005e4:	b7b9                	j	800532 <vprintfmt+0x368>
                putch('-', putdat);
  8005e6:	85a6                	mv	a1,s1
  8005e8:	02d00513          	li	a0,45
  8005ec:	e042                	sd	a6,0(sp)
  8005ee:	9902                	jalr	s2
                num = -(long long)num;
  8005f0:	6802                	ld	a6,0(sp)
  8005f2:	8a6e                	mv	s4,s11
  8005f4:	408007b3          	neg	a5,s0
  8005f8:	4629                	li	a2,10
  8005fa:	46a9                	li	a3,10
  8005fc:	b325                	j	800324 <vprintfmt+0x15a>
            if (width > 0 && padc != '-') {
  8005fe:	03a05063          	blez	s10,80061e <vprintfmt+0x454>
  800602:	02d00793          	li	a5,45
                p = "(null)";
  800606:	00000417          	auipc	s0,0x0
  80060a:	0d240413          	addi	s0,s0,210 # 8006d8 <main+0x6c>
            if (width > 0 && padc != '-') {
  80060e:	f2f814e3          	bne	a6,a5,800536 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800612:	02800793          	li	a5,40
  800616:	02800513          	li	a0,40
  80061a:	0405                	addi	s0,s0,1
  80061c:	bd19                	j	800432 <vprintfmt+0x268>
  80061e:	02800513          	li	a0,40
  800622:	02800793          	li	a5,40
  800626:	00000417          	auipc	s0,0x0
  80062a:	0b340413          	addi	s0,s0,179 # 8006d9 <main+0x6d>
  80062e:	b511                	j	800432 <vprintfmt+0x268>

0000000000800630 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800630:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  800632:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800636:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800638:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  80063a:	ec06                	sd	ra,24(sp)
  80063c:	f83a                	sd	a4,48(sp)
  80063e:	fc3e                	sd	a5,56(sp)
  800640:	e0c2                	sd	a6,64(sp)
  800642:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  800644:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800646:	b85ff0ef          	jal	ra,8001ca <vprintfmt>
}
  80064a:	60e2                	ld	ra,24(sp)
  80064c:	6161                	addi	sp,sp,80
  80064e:	8082                	ret

0000000000800650 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  800650:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  800652:	e589                	bnez	a1,80065c <strnlen+0xc>
  800654:	a811                	j	800668 <strnlen+0x18>
        cnt ++;
  800656:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  800658:	00f58863          	beq	a1,a5,800668 <strnlen+0x18>
  80065c:	00f50733          	add	a4,a0,a5
  800660:	00074703          	lbu	a4,0(a4)
  800664:	fb6d                	bnez	a4,800656 <strnlen+0x6>
  800666:	85be                	mv	a1,a5
    }
    return cnt;
}
  800668:	852e                	mv	a0,a1
  80066a:	8082                	ret

000000000080066c <main>:
#include <stdio.h>
#include <ulib.h>

int
main(void) {
  80066c:	1141                	addi	sp,sp,-16
    cprintf("Hello world!!.\n");
  80066e:	00000517          	auipc	a0,0x0
  800672:	36a50513          	addi	a0,a0,874 # 8009d8 <error_string+0xc8>
main(void) {
  800676:	e406                	sd	ra,8(sp)
    cprintf("Hello world!!.\n");
  800678:	9c9ff0ef          	jal	ra,800040 <cprintf>
    cprintf("I am process %d.\n", getpid());
  80067c:	a59ff0ef          	jal	ra,8000d4 <getpid>
  800680:	85aa                	mv	a1,a0
  800682:	00000517          	auipc	a0,0x0
  800686:	36650513          	addi	a0,a0,870 # 8009e8 <error_string+0xd8>
  80068a:	9b7ff0ef          	jal	ra,800040 <cprintf>
    cprintf("hello pass.\n");
  80068e:	00000517          	auipc	a0,0x0
  800692:	37250513          	addi	a0,a0,882 # 800a00 <error_string+0xf0>
  800696:	9abff0ef          	jal	ra,800040 <cprintf>
    return 0;
}
  80069a:	60a2                	ld	ra,8(sp)
  80069c:	4501                	li	a0,0
  80069e:	0141                	addi	sp,sp,16
  8006a0:	8082                	ret
