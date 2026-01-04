
obj/__user_faultread.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	0b0000ef          	jal	ra,8000d0 <umain>
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
  80002e:	086000ef          	jal	ra,8000b4 <sys_putc>
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
  80006a:	15a000ef          	jal	ra,8001c4 <vprintfmt>
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

00000000008000b4 <sys_putc>:
sys_getpid(void) {
    return syscall(SYS_getpid);
}

int
sys_putc(int64_t c) {
  8000b4:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  8000b6:	4579                	li	a0,30
  8000b8:	bf7d                	j	800076 <syscall>

00000000008000ba <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8000ba:	1141                	addi	sp,sp,-16
  8000bc:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  8000be:	ff1ff0ef          	jal	ra,8000ae <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000c2:	00000517          	auipc	a0,0x0
  8000c6:	5ae50513          	addi	a0,a0,1454 # 800670 <main+0xa>
  8000ca:	f77ff0ef          	jal	ra,800040 <cprintf>
    while (1);
  8000ce:	a001                	j	8000ce <exit+0x14>

00000000008000d0 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8000d0:	1141                	addi	sp,sp,-16
  8000d2:	e406                	sd	ra,8(sp)
    int ret = main();
  8000d4:	592000ef          	jal	ra,800666 <main>
    exit(ret);
  8000d8:	fe3ff0ef          	jal	ra,8000ba <exit>

00000000008000dc <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  8000dc:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000e0:	7139                	addi	sp,sp,-64
    unsigned mod = do_div(result, base);
  8000e2:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000e6:	e852                	sd	s4,16(sp)
    unsigned mod = do_div(result, base);
  8000e8:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  8000ec:	f426                	sd	s1,40(sp)
  8000ee:	f04a                	sd	s2,32(sp)
  8000f0:	ec4e                	sd	s3,24(sp)
  8000f2:	fc06                	sd	ra,56(sp)
  8000f4:	f822                	sd	s0,48(sp)
  8000f6:	e456                	sd	s5,8(sp)
  8000f8:	e05a                	sd	s6,0(sp)
  8000fa:	84aa                	mv	s1,a0
  8000fc:	892e                	mv	s2,a1
  8000fe:	89be                	mv	s3,a5
    unsigned mod = do_div(result, base);
  800100:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  800102:	05067163          	bgeu	a2,a6,800144 <printnum+0x68>
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800106:	fff7041b          	addiw	s0,a4,-1
  80010a:	00805763          	blez	s0,800118 <printnum+0x3c>
  80010e:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800110:	85ca                	mv	a1,s2
  800112:	854e                	mv	a0,s3
  800114:	9482                	jalr	s1
        while (-- width > 0)
  800116:	fc65                	bnez	s0,80010e <printnum+0x32>
  800118:	00000417          	auipc	s0,0x0
  80011c:	57040413          	addi	s0,s0,1392 # 800688 <main+0x22>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  800120:	1a02                	slli	s4,s4,0x20
  800122:	020a5a13          	srli	s4,s4,0x20
  800126:	9452                	add	s0,s0,s4
  800128:	00044503          	lbu	a0,0(s0)
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  80012c:	7442                	ld	s0,48(sp)
  80012e:	70e2                	ld	ra,56(sp)
  800130:	69e2                	ld	s3,24(sp)
  800132:	6a42                	ld	s4,16(sp)
  800134:	6aa2                	ld	s5,8(sp)
  800136:	6b02                	ld	s6,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  800138:	85ca                	mv	a1,s2
  80013a:	87a6                	mv	a5,s1
}
  80013c:	7902                	ld	s2,32(sp)
  80013e:	74a2                	ld	s1,40(sp)
  800140:	6121                	addi	sp,sp,64
    putch("0123456789abcdef"[mod], putdat);
  800142:	8782                	jr	a5
    unsigned mod = do_div(result, base);
  800144:	03065633          	divu	a2,a2,a6
  800148:	03067ab3          	remu	s5,a2,a6
  80014c:	2a81                	sext.w	s5,s5
    if (num >= base) {
  80014e:	03067863          	bgeu	a2,a6,80017e <printnum+0xa2>
        while (-- width > 0)
  800152:	ffe7041b          	addiw	s0,a4,-2
  800156:	00805763          	blez	s0,800164 <printnum+0x88>
  80015a:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  80015c:	85ca                	mv	a1,s2
  80015e:	854e                	mv	a0,s3
  800160:	9482                	jalr	s1
        while (-- width > 0)
  800162:	fc65                	bnez	s0,80015a <printnum+0x7e>
  800164:	00000417          	auipc	s0,0x0
  800168:	52440413          	addi	s0,s0,1316 # 800688 <main+0x22>
    putch("0123456789abcdef"[mod], putdat);
  80016c:	1a82                	slli	s5,s5,0x20
  80016e:	020ada93          	srli	s5,s5,0x20
  800172:	9aa2                	add	s5,s5,s0
  800174:	000ac503          	lbu	a0,0(s5)
  800178:	85ca                	mv	a1,s2
  80017a:	9482                	jalr	s1
}
  80017c:	b755                	j	800120 <printnum+0x44>
    unsigned mod = do_div(result, base);
  80017e:	03065633          	divu	a2,a2,a6
        while (-- width > 0)
  800182:	ffd7041b          	addiw	s0,a4,-3
    unsigned mod = do_div(result, base);
  800186:	03067b33          	remu	s6,a2,a6
  80018a:	2b01                	sext.w	s6,s6
    if (num >= base) {
  80018c:	03067663          	bgeu	a2,a6,8001b8 <printnum+0xdc>
        while (-- width > 0)
  800190:	00805763          	blez	s0,80019e <printnum+0xc2>
  800194:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800196:	85ca                	mv	a1,s2
  800198:	854e                	mv	a0,s3
  80019a:	9482                	jalr	s1
        while (-- width > 0)
  80019c:	fc65                	bnez	s0,800194 <printnum+0xb8>
    putch("0123456789abcdef"[mod], putdat);
  80019e:	1b02                	slli	s6,s6,0x20
  8001a0:	00000417          	auipc	s0,0x0
  8001a4:	4e840413          	addi	s0,s0,1256 # 800688 <main+0x22>
  8001a8:	020b5b13          	srli	s6,s6,0x20
  8001ac:	9b22                	add	s6,s6,s0
  8001ae:	000b4503          	lbu	a0,0(s6)
  8001b2:	85ca                	mv	a1,s2
  8001b4:	9482                	jalr	s1
}
  8001b6:	bf5d                	j	80016c <printnum+0x90>
        printnum(putch, putdat, result, base, width - 1, padc);
  8001b8:	03065633          	divu	a2,a2,a6
  8001bc:	8722                	mv	a4,s0
  8001be:	f1fff0ef          	jal	ra,8000dc <printnum>
  8001c2:	bff1                	j	80019e <printnum+0xc2>

00000000008001c4 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  8001c4:	7119                	addi	sp,sp,-128
  8001c6:	f4a6                	sd	s1,104(sp)
  8001c8:	f0ca                	sd	s2,96(sp)
  8001ca:	ecce                	sd	s3,88(sp)
  8001cc:	e8d2                	sd	s4,80(sp)
  8001ce:	e4d6                	sd	s5,72(sp)
  8001d0:	e0da                	sd	s6,64(sp)
  8001d2:	fc5e                	sd	s7,56(sp)
  8001d4:	f466                	sd	s9,40(sp)
  8001d6:	fc86                	sd	ra,120(sp)
  8001d8:	f8a2                	sd	s0,112(sp)
  8001da:	f862                	sd	s8,48(sp)
  8001dc:	f06a                	sd	s10,32(sp)
  8001de:	ec6e                	sd	s11,24(sp)
  8001e0:	892a                	mv	s2,a0
  8001e2:	84ae                	mv	s1,a1
  8001e4:	8cb2                	mv	s9,a2
  8001e6:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001e8:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  8001ec:	5bfd                	li	s7,-1
  8001ee:	00000a97          	auipc	s5,0x0
  8001f2:	4cea8a93          	addi	s5,s5,1230 # 8006bc <main+0x56>
    putch("0123456789abcdef"[mod], putdat);
  8001f6:	00000b17          	auipc	s6,0x0
  8001fa:	492b0b13          	addi	s6,s6,1170 # 800688 <main+0x22>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001fe:	000cc503          	lbu	a0,0(s9)
  800202:	001c8413          	addi	s0,s9,1
  800206:	01350a63          	beq	a0,s3,80021a <vprintfmt+0x56>
            if (ch == '\0') {
  80020a:	c121                	beqz	a0,80024a <vprintfmt+0x86>
            putch(ch, putdat);
  80020c:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80020e:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  800210:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800212:	fff44503          	lbu	a0,-1(s0)
  800216:	ff351ae3          	bne	a0,s3,80020a <vprintfmt+0x46>
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  80021a:	00044683          	lbu	a3,0(s0)
        char padc = ' ';
  80021e:	02000813          	li	a6,32
        lflag = altflag = 0;
  800222:	4d81                	li	s11,0
  800224:	4501                	li	a0,0
        width = precision = -1;
  800226:	5c7d                	li	s8,-1
  800228:	5d7d                	li	s10,-1
  80022a:	05500613          	li	a2,85
        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
  80022e:	45a5                	li	a1,9
        switch (ch = *(unsigned char *)fmt ++) {
  800230:	fdd6879b          	addiw	a5,a3,-35
  800234:	0ff7f793          	zext.b	a5,a5
  800238:	00140c93          	addi	s9,s0,1
  80023c:	04f66263          	bltu	a2,a5,800280 <vprintfmt+0xbc>
  800240:	078a                	slli	a5,a5,0x2
  800242:	97d6                	add	a5,a5,s5
  800244:	439c                	lw	a5,0(a5)
  800246:	97d6                	add	a5,a5,s5
  800248:	8782                	jr	a5
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  80024a:	70e6                	ld	ra,120(sp)
  80024c:	7446                	ld	s0,112(sp)
  80024e:	74a6                	ld	s1,104(sp)
  800250:	7906                	ld	s2,96(sp)
  800252:	69e6                	ld	s3,88(sp)
  800254:	6a46                	ld	s4,80(sp)
  800256:	6aa6                	ld	s5,72(sp)
  800258:	6b06                	ld	s6,64(sp)
  80025a:	7be2                	ld	s7,56(sp)
  80025c:	7c42                	ld	s8,48(sp)
  80025e:	7ca2                	ld	s9,40(sp)
  800260:	7d02                	ld	s10,32(sp)
  800262:	6de2                	ld	s11,24(sp)
  800264:	6109                	addi	sp,sp,128
  800266:	8082                	ret
            padc = '0';
  800268:	8836                	mv	a6,a3
            goto reswitch;
  80026a:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  80026e:	8466                	mv	s0,s9
  800270:	00140c93          	addi	s9,s0,1
  800274:	fdd6879b          	addiw	a5,a3,-35
  800278:	0ff7f793          	zext.b	a5,a5
  80027c:	fcf672e3          	bgeu	a2,a5,800240 <vprintfmt+0x7c>
            putch('%', putdat);
  800280:	85a6                	mv	a1,s1
  800282:	02500513          	li	a0,37
  800286:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800288:	fff44783          	lbu	a5,-1(s0)
  80028c:	8ca2                	mv	s9,s0
  80028e:	f73788e3          	beq	a5,s3,8001fe <vprintfmt+0x3a>
  800292:	ffecc783          	lbu	a5,-2(s9)
  800296:	1cfd                	addi	s9,s9,-1
  800298:	ff379de3          	bne	a5,s3,800292 <vprintfmt+0xce>
  80029c:	b78d                	j	8001fe <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  80029e:	fd068c1b          	addiw	s8,a3,-48
                ch = *fmt;
  8002a2:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  8002a6:	8466                	mv	s0,s9
                if (ch < '0' || ch > '9') {
  8002a8:	fd06879b          	addiw	a5,a3,-48
                ch = *fmt;
  8002ac:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  8002b0:	02f5e563          	bltu	a1,a5,8002da <vprintfmt+0x116>
                ch = *fmt;
  8002b4:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
  8002b8:	002c179b          	slliw	a5,s8,0x2
  8002bc:	0187873b          	addw	a4,a5,s8
  8002c0:	0017171b          	slliw	a4,a4,0x1
  8002c4:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
  8002c8:	fd06879b          	addiw	a5,a3,-48
            for (precision = 0; ; ++ fmt) {
  8002cc:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  8002ce:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  8002d2:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  8002d6:	fcf5ffe3          	bgeu	a1,a5,8002b4 <vprintfmt+0xf0>
            if (width < 0)
  8002da:	f40d5be3          	bgez	s10,800230 <vprintfmt+0x6c>
                width = precision, precision = -1;
  8002de:	8d62                	mv	s10,s8
  8002e0:	5c7d                	li	s8,-1
  8002e2:	b7b9                	j	800230 <vprintfmt+0x6c>
            if (width < 0)
  8002e4:	fffd4793          	not	a5,s10
  8002e8:	97fd                	srai	a5,a5,0x3f
  8002ea:	00fd7d33          	and	s10,s10,a5
        switch (ch = *(unsigned char *)fmt ++) {
  8002ee:	00144683          	lbu	a3,1(s0)
  8002f2:	2d01                	sext.w	s10,s10
  8002f4:	8466                	mv	s0,s9
            goto reswitch;
  8002f6:	bf2d                	j	800230 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  8002f8:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  8002fc:	00144683          	lbu	a3,1(s0)
            precision = va_arg(ap, int);
  800300:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  800302:	8466                	mv	s0,s9
            goto process_precision;
  800304:	bfd9                	j	8002da <vprintfmt+0x116>
    if (lflag >= 2) {
  800306:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800308:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  80030c:	00a7c463          	blt	a5,a0,800314 <vprintfmt+0x150>
    else if (lflag) {
  800310:	28050a63          	beqz	a0,8005a4 <vprintfmt+0x3e0>
        return va_arg(*ap, unsigned long);
  800314:	000a3783          	ld	a5,0(s4)
  800318:	4641                	li	a2,16
  80031a:	8a3a                	mv	s4,a4
  80031c:	46c1                	li	a3,16
    unsigned mod = do_div(result, base);
  80031e:	02c7fdb3          	remu	s11,a5,a2
            printnum(putch, putdat, num, base, width, padc);
  800322:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  800326:	0ac7f563          	bgeu	a5,a2,8003d0 <vprintfmt+0x20c>
        while (-- width > 0)
  80032a:	3d7d                	addiw	s10,s10,-1
  80032c:	01a05863          	blez	s10,80033c <vprintfmt+0x178>
  800330:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  800332:	85a6                	mv	a1,s1
  800334:	8562                	mv	a0,s8
  800336:	9902                	jalr	s2
        while (-- width > 0)
  800338:	fe0d1ce3          	bnez	s10,800330 <vprintfmt+0x16c>
    putch("0123456789abcdef"[mod], putdat);
  80033c:	9dda                	add	s11,s11,s6
  80033e:	000dc503          	lbu	a0,0(s11)
  800342:	85a6                	mv	a1,s1
  800344:	9902                	jalr	s2
}
  800346:	bd65                	j	8001fe <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  800348:	000a2503          	lw	a0,0(s4)
  80034c:	85a6                	mv	a1,s1
  80034e:	0a21                	addi	s4,s4,8
  800350:	9902                	jalr	s2
            break;
  800352:	b575                	j	8001fe <vprintfmt+0x3a>
    if (lflag >= 2) {
  800354:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800356:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  80035a:	00a7c463          	blt	a5,a0,800362 <vprintfmt+0x19e>
    else if (lflag) {
  80035e:	22050d63          	beqz	a0,800598 <vprintfmt+0x3d4>
        return va_arg(*ap, unsigned long);
  800362:	000a3783          	ld	a5,0(s4)
  800366:	4629                	li	a2,10
  800368:	8a3a                	mv	s4,a4
  80036a:	46a9                	li	a3,10
  80036c:	bf4d                	j	80031e <vprintfmt+0x15a>
        switch (ch = *(unsigned char *)fmt ++) {
  80036e:	00144683          	lbu	a3,1(s0)
            altflag = 1;
  800372:	4d85                	li	s11,1
        switch (ch = *(unsigned char *)fmt ++) {
  800374:	8466                	mv	s0,s9
            goto reswitch;
  800376:	bd6d                	j	800230 <vprintfmt+0x6c>
            putch(ch, putdat);
  800378:	85a6                	mv	a1,s1
  80037a:	02500513          	li	a0,37
  80037e:	9902                	jalr	s2
            break;
  800380:	bdbd                	j	8001fe <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  800382:	00144683          	lbu	a3,1(s0)
            lflag ++;
  800386:	2505                	addiw	a0,a0,1
        switch (ch = *(unsigned char *)fmt ++) {
  800388:	8466                	mv	s0,s9
            goto reswitch;
  80038a:	b55d                	j	800230 <vprintfmt+0x6c>
    if (lflag >= 2) {
  80038c:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80038e:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800392:	00a7c463          	blt	a5,a0,80039a <vprintfmt+0x1d6>
    else if (lflag) {
  800396:	1e050b63          	beqz	a0,80058c <vprintfmt+0x3c8>
        return va_arg(*ap, unsigned long);
  80039a:	000a3783          	ld	a5,0(s4)
  80039e:	4621                	li	a2,8
  8003a0:	8a3a                	mv	s4,a4
  8003a2:	46a1                	li	a3,8
  8003a4:	bfad                	j	80031e <vprintfmt+0x15a>
            putch('0', putdat);
  8003a6:	03000513          	li	a0,48
  8003aa:	85a6                	mv	a1,s1
  8003ac:	e042                	sd	a6,0(sp)
  8003ae:	9902                	jalr	s2
            putch('x', putdat);
  8003b0:	85a6                	mv	a1,s1
  8003b2:	07800513          	li	a0,120
  8003b6:	9902                	jalr	s2
            goto number;
  8003b8:	6802                	ld	a6,0(sp)
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8003ba:	000a3783          	ld	a5,0(s4)
            goto number;
  8003be:	4641                	li	a2,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8003c0:	0a21                	addi	s4,s4,8
    unsigned mod = do_div(result, base);
  8003c2:	02c7fdb3          	remu	s11,a5,a2
            goto number;
  8003c6:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
  8003c8:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  8003cc:	f4c7efe3          	bltu	a5,a2,80032a <vprintfmt+0x166>
        while (-- width > 0)
  8003d0:	3d79                	addiw	s10,s10,-2
    unsigned mod = do_div(result, base);
  8003d2:	02c7d7b3          	divu	a5,a5,a2
  8003d6:	02c7f433          	remu	s0,a5,a2
    if (num >= base) {
  8003da:	10c7f463          	bgeu	a5,a2,8004e2 <vprintfmt+0x31e>
        while (-- width > 0)
  8003de:	01a05863          	blez	s10,8003ee <vprintfmt+0x22a>
  8003e2:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  8003e4:	85a6                	mv	a1,s1
  8003e6:	8562                	mv	a0,s8
  8003e8:	9902                	jalr	s2
        while (-- width > 0)
  8003ea:	fe0d1ce3          	bnez	s10,8003e2 <vprintfmt+0x21e>
    putch("0123456789abcdef"[mod], putdat);
  8003ee:	945a                	add	s0,s0,s6
  8003f0:	00044503          	lbu	a0,0(s0)
  8003f4:	85a6                	mv	a1,s1
  8003f6:	9dda                	add	s11,s11,s6
  8003f8:	9902                	jalr	s2
  8003fa:	000dc503          	lbu	a0,0(s11)
  8003fe:	85a6                	mv	a1,s1
  800400:	9902                	jalr	s2
  800402:	bbf5                	j	8001fe <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
  800404:	000a3403          	ld	s0,0(s4)
  800408:	008a0793          	addi	a5,s4,8
  80040c:	e43e                	sd	a5,8(sp)
  80040e:	1e040563          	beqz	s0,8005f8 <vprintfmt+0x434>
            if (width > 0 && padc != '-') {
  800412:	15a05263          	blez	s10,800556 <vprintfmt+0x392>
  800416:	02d00793          	li	a5,45
  80041a:	10f81b63          	bne	a6,a5,800530 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80041e:	00044783          	lbu	a5,0(s0)
  800422:	0007851b          	sext.w	a0,a5
  800426:	0e078c63          	beqz	a5,80051e <vprintfmt+0x35a>
  80042a:	0405                	addi	s0,s0,1
  80042c:	120d8e63          	beqz	s11,800568 <vprintfmt+0x3a4>
                if (altflag && (ch < ' ' || ch > '~')) {
  800430:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800434:	020c4963          	bltz	s8,800466 <vprintfmt+0x2a2>
  800438:	fffc0a1b          	addiw	s4,s8,-1
  80043c:	0d7a0f63          	beq	s4,s7,80051a <vprintfmt+0x356>
                if (altflag && (ch < ' ' || ch > '~')) {
  800440:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  800442:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800444:	02fdf663          	bgeu	s11,a5,800470 <vprintfmt+0x2ac>
                    putch('?', putdat);
  800448:	03f00513          	li	a0,63
  80044c:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80044e:	00044783          	lbu	a5,0(s0)
  800452:	3d7d                	addiw	s10,s10,-1
  800454:	0405                	addi	s0,s0,1
  800456:	0007851b          	sext.w	a0,a5
  80045a:	c3e1                	beqz	a5,80051a <vprintfmt+0x356>
  80045c:	140c4a63          	bltz	s8,8005b0 <vprintfmt+0x3ec>
  800460:	8c52                	mv	s8,s4
  800462:	fc0c5be3          	bgez	s8,800438 <vprintfmt+0x274>
                if (altflag && (ch < ' ' || ch > '~')) {
  800466:	3781                	addiw	a5,a5,-32
  800468:	8a62                	mv	s4,s8
                    putch('?', putdat);
  80046a:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  80046c:	fcfdeee3          	bltu	s11,a5,800448 <vprintfmt+0x284>
                    putch(ch, putdat);
  800470:	9902                	jalr	s2
  800472:	bff1                	j	80044e <vprintfmt+0x28a>
    if (lflag >= 2) {
  800474:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800476:	008a0d93          	addi	s11,s4,8
    if (lflag >= 2) {
  80047a:	00a7c463          	blt	a5,a0,800482 <vprintfmt+0x2be>
    else if (lflag) {
  80047e:	10050463          	beqz	a0,800586 <vprintfmt+0x3c2>
        return va_arg(*ap, long);
  800482:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  800486:	14044d63          	bltz	s0,8005e0 <vprintfmt+0x41c>
            num = getint(&ap, lflag);
  80048a:	87a2                	mv	a5,s0
  80048c:	8a6e                	mv	s4,s11
  80048e:	4629                	li	a2,10
  800490:	46a9                	li	a3,10
  800492:	b571                	j	80031e <vprintfmt+0x15a>
            err = va_arg(ap, int);
  800494:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800498:	4761                	li	a4,24
            err = va_arg(ap, int);
  80049a:	0a21                	addi	s4,s4,8
            if (err < 0) {
  80049c:	41f7d69b          	sraiw	a3,a5,0x1f
  8004a0:	8fb5                	xor	a5,a5,a3
  8004a2:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8004a6:	02d74563          	blt	a4,a3,8004d0 <vprintfmt+0x30c>
  8004aa:	00369713          	slli	a4,a3,0x3
  8004ae:	00000797          	auipc	a5,0x0
  8004b2:	42a78793          	addi	a5,a5,1066 # 8008d8 <error_string>
  8004b6:	97ba                	add	a5,a5,a4
  8004b8:	639c                	ld	a5,0(a5)
  8004ba:	cb99                	beqz	a5,8004d0 <vprintfmt+0x30c>
                printfmt(putch, putdat, "%s", p);
  8004bc:	86be                	mv	a3,a5
  8004be:	00000617          	auipc	a2,0x0
  8004c2:	1fa60613          	addi	a2,a2,506 # 8006b8 <main+0x52>
  8004c6:	85a6                	mv	a1,s1
  8004c8:	854a                	mv	a0,s2
  8004ca:	160000ef          	jal	ra,80062a <printfmt>
  8004ce:	bb05                	j	8001fe <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  8004d0:	00000617          	auipc	a2,0x0
  8004d4:	1d860613          	addi	a2,a2,472 # 8006a8 <main+0x42>
  8004d8:	85a6                	mv	a1,s1
  8004da:	854a                	mv	a0,s2
  8004dc:	14e000ef          	jal	ra,80062a <printfmt>
  8004e0:	bb39                	j	8001fe <vprintfmt+0x3a>
        printnum(putch, putdat, result, base, width - 1, padc);
  8004e2:	02c7d633          	divu	a2,a5,a2
  8004e6:	876a                	mv	a4,s10
  8004e8:	87e2                	mv	a5,s8
  8004ea:	85a6                	mv	a1,s1
  8004ec:	854a                	mv	a0,s2
  8004ee:	befff0ef          	jal	ra,8000dc <printnum>
  8004f2:	bdf5                	j	8003ee <vprintfmt+0x22a>
                    putch(ch, putdat);
  8004f4:	85a6                	mv	a1,s1
  8004f6:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004f8:	00044503          	lbu	a0,0(s0)
  8004fc:	3d7d                	addiw	s10,s10,-1
  8004fe:	0405                	addi	s0,s0,1
  800500:	cd09                	beqz	a0,80051a <vprintfmt+0x356>
  800502:	008d0d3b          	addw	s10,s10,s0
  800506:	fffd0d9b          	addiw	s11,s10,-1
                    putch(ch, putdat);
  80050a:	85a6                	mv	a1,s1
  80050c:	408d8d3b          	subw	s10,s11,s0
  800510:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800512:	00044503          	lbu	a0,0(s0)
  800516:	0405                	addi	s0,s0,1
  800518:	f96d                	bnez	a0,80050a <vprintfmt+0x346>
            for (; width > 0; width --) {
  80051a:	01a05963          	blez	s10,80052c <vprintfmt+0x368>
  80051e:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
  800520:	85a6                	mv	a1,s1
  800522:	02000513          	li	a0,32
  800526:	9902                	jalr	s2
            for (; width > 0; width --) {
  800528:	fe0d1be3          	bnez	s10,80051e <vprintfmt+0x35a>
            if ((p = va_arg(ap, char *)) == NULL) {
  80052c:	6a22                	ld	s4,8(sp)
  80052e:	b9c1                	j	8001fe <vprintfmt+0x3a>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800530:	85e2                	mv	a1,s8
  800532:	8522                	mv	a0,s0
  800534:	e042                	sd	a6,0(sp)
  800536:	114000ef          	jal	ra,80064a <strnlen>
  80053a:	40ad0d3b          	subw	s10,s10,a0
  80053e:	01a05c63          	blez	s10,800556 <vprintfmt+0x392>
                    putch(padc, putdat);
  800542:	6802                	ld	a6,0(sp)
  800544:	0008051b          	sext.w	a0,a6
  800548:	85a6                	mv	a1,s1
  80054a:	e02a                	sd	a0,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
  80054c:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
  80054e:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  800550:	6502                	ld	a0,0(sp)
  800552:	fe0d1be3          	bnez	s10,800548 <vprintfmt+0x384>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800556:	00044783          	lbu	a5,0(s0)
  80055a:	0405                	addi	s0,s0,1
  80055c:	0007851b          	sext.w	a0,a5
  800560:	ec0796e3          	bnez	a5,80042c <vprintfmt+0x268>
            if ((p = va_arg(ap, char *)) == NULL) {
  800564:	6a22                	ld	s4,8(sp)
  800566:	b961                	j	8001fe <vprintfmt+0x3a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800568:	f80c46e3          	bltz	s8,8004f4 <vprintfmt+0x330>
  80056c:	3c7d                	addiw	s8,s8,-1
  80056e:	fb7c06e3          	beq	s8,s7,80051a <vprintfmt+0x356>
                    putch(ch, putdat);
  800572:	85a6                	mv	a1,s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800574:	0405                	addi	s0,s0,1
                    putch(ch, putdat);
  800576:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800578:	fff44503          	lbu	a0,-1(s0)
  80057c:	3d7d                	addiw	s10,s10,-1
  80057e:	f56d                	bnez	a0,800568 <vprintfmt+0x3a4>
            for (; width > 0; width --) {
  800580:	f9a04fe3          	bgtz	s10,80051e <vprintfmt+0x35a>
  800584:	b765                	j	80052c <vprintfmt+0x368>
        return va_arg(*ap, int);
  800586:	000a2403          	lw	s0,0(s4)
  80058a:	bdf5                	j	800486 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned int);
  80058c:	000a6783          	lwu	a5,0(s4)
  800590:	4621                	li	a2,8
  800592:	8a3a                	mv	s4,a4
  800594:	46a1                	li	a3,8
  800596:	b361                	j	80031e <vprintfmt+0x15a>
  800598:	000a6783          	lwu	a5,0(s4)
  80059c:	4629                	li	a2,10
  80059e:	8a3a                	mv	s4,a4
  8005a0:	46a9                	li	a3,10
  8005a2:	bbb5                	j	80031e <vprintfmt+0x15a>
  8005a4:	000a6783          	lwu	a5,0(s4)
  8005a8:	4641                	li	a2,16
  8005aa:	8a3a                	mv	s4,a4
  8005ac:	46c1                	li	a3,16
  8005ae:	bb85                	j	80031e <vprintfmt+0x15a>
  8005b0:	01a40d3b          	addw	s10,s0,s10
                if (altflag && (ch < ' ' || ch > '~')) {
  8005b4:	05e00d93          	li	s11,94
  8005b8:	3d7d                	addiw	s10,s10,-1
  8005ba:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  8005bc:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8005be:	00fdf463          	bgeu	s11,a5,8005c6 <vprintfmt+0x402>
                    putch('?', putdat);
  8005c2:	03f00513          	li	a0,63
  8005c6:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005c8:	00044783          	lbu	a5,0(s0)
  8005cc:	408d073b          	subw	a4,s10,s0
  8005d0:	0405                	addi	s0,s0,1
  8005d2:	0007851b          	sext.w	a0,a5
  8005d6:	f3f5                	bnez	a5,8005ba <vprintfmt+0x3f6>
  8005d8:	8d3a                	mv	s10,a4
            for (; width > 0; width --) {
  8005da:	f5a042e3          	bgtz	s10,80051e <vprintfmt+0x35a>
  8005de:	b7b9                	j	80052c <vprintfmt+0x368>
                putch('-', putdat);
  8005e0:	85a6                	mv	a1,s1
  8005e2:	02d00513          	li	a0,45
  8005e6:	e042                	sd	a6,0(sp)
  8005e8:	9902                	jalr	s2
                num = -(long long)num;
  8005ea:	6802                	ld	a6,0(sp)
  8005ec:	8a6e                	mv	s4,s11
  8005ee:	408007b3          	neg	a5,s0
  8005f2:	4629                	li	a2,10
  8005f4:	46a9                	li	a3,10
  8005f6:	b325                	j	80031e <vprintfmt+0x15a>
            if (width > 0 && padc != '-') {
  8005f8:	03a05063          	blez	s10,800618 <vprintfmt+0x454>
  8005fc:	02d00793          	li	a5,45
                p = "(null)";
  800600:	00000417          	auipc	s0,0x0
  800604:	0a040413          	addi	s0,s0,160 # 8006a0 <main+0x3a>
            if (width > 0 && padc != '-') {
  800608:	f2f814e3          	bne	a6,a5,800530 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80060c:	02800793          	li	a5,40
  800610:	02800513          	li	a0,40
  800614:	0405                	addi	s0,s0,1
  800616:	bd19                	j	80042c <vprintfmt+0x268>
  800618:	02800513          	li	a0,40
  80061c:	02800793          	li	a5,40
  800620:	00000417          	auipc	s0,0x0
  800624:	08140413          	addi	s0,s0,129 # 8006a1 <main+0x3b>
  800628:	b511                	j	80042c <vprintfmt+0x268>

000000000080062a <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  80062a:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  80062c:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800630:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800632:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800634:	ec06                	sd	ra,24(sp)
  800636:	f83a                	sd	a4,48(sp)
  800638:	fc3e                	sd	a5,56(sp)
  80063a:	e0c2                	sd	a6,64(sp)
  80063c:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  80063e:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800640:	b85ff0ef          	jal	ra,8001c4 <vprintfmt>
}
  800644:	60e2                	ld	ra,24(sp)
  800646:	6161                	addi	sp,sp,80
  800648:	8082                	ret

000000000080064a <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  80064a:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  80064c:	e589                	bnez	a1,800656 <strnlen+0xc>
  80064e:	a811                	j	800662 <strnlen+0x18>
        cnt ++;
  800650:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  800652:	00f58863          	beq	a1,a5,800662 <strnlen+0x18>
  800656:	00f50733          	add	a4,a0,a5
  80065a:	00074703          	lbu	a4,0(a4)
  80065e:	fb6d                	bnez	a4,800650 <strnlen+0x6>
  800660:	85be                	mv	a1,a5
    }
    return cnt;
}
  800662:	852e                	mv	a0,a1
  800664:	8082                	ret

0000000000800666 <main>:
#include <stdio.h>
#include <ulib.h>

int
main(void) {
    cprintf("I read %8x from 0.\n", *(unsigned int *)0);
  800666:	00002783          	lw	a5,0(zero) # 0 <_start-0x800020>
  80066a:	9002                	ebreak
