
obj/__user_divzero.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	112000ef          	jal	ra,800132 <umain>
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
  80003a:	6ca50513          	addi	a0,a0,1738 # 800700 <main+0x38>
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
  800056:	00000517          	auipc	a0,0x0
  80005a:	6ca50513          	addi	a0,a0,1738 # 800720 <main+0x58>
  80005e:	044000ef          	jal	ra,8000a2 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800062:	5559                	li	a0,-10
  800064:	0b8000ef          	jal	ra,80011c <exit>

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
  800070:	0a6000ef          	jal	ra,800116 <sys_putc>
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
  800096:	190000ef          	jal	ra,800226 <vprintfmt>
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
  8000cc:	15a000ef          	jal	ra,800226 <vprintfmt>
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

0000000000800116 <sys_putc>:
sys_getpid(void) {
    return syscall(SYS_getpid);
}

int
sys_putc(int64_t c) {
  800116:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  800118:	4579                	li	a0,30
  80011a:	bf7d                	j	8000d8 <syscall>

000000000080011c <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  80011c:	1141                	addi	sp,sp,-16
  80011e:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  800120:	ff1ff0ef          	jal	ra,800110 <sys_exit>
    cprintf("BUG: exit failed.\n");
  800124:	00000517          	auipc	a0,0x0
  800128:	60450513          	addi	a0,a0,1540 # 800728 <main+0x60>
  80012c:	f77ff0ef          	jal	ra,8000a2 <cprintf>
    while (1);
  800130:	a001                	j	800130 <exit+0x14>

0000000000800132 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  800132:	1141                	addi	sp,sp,-16
  800134:	e406                	sd	ra,8(sp)
    int ret = main();
  800136:	592000ef          	jal	ra,8006c8 <main>
    exit(ret);
  80013a:	fe3ff0ef          	jal	ra,80011c <exit>

000000000080013e <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  80013e:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800142:	7139                	addi	sp,sp,-64
    unsigned mod = do_div(result, base);
  800144:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800148:	e852                	sd	s4,16(sp)
    unsigned mod = do_div(result, base);
  80014a:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  80014e:	f426                	sd	s1,40(sp)
  800150:	f04a                	sd	s2,32(sp)
  800152:	ec4e                	sd	s3,24(sp)
  800154:	fc06                	sd	ra,56(sp)
  800156:	f822                	sd	s0,48(sp)
  800158:	e456                	sd	s5,8(sp)
  80015a:	e05a                	sd	s6,0(sp)
  80015c:	84aa                	mv	s1,a0
  80015e:	892e                	mv	s2,a1
  800160:	89be                	mv	s3,a5
    unsigned mod = do_div(result, base);
  800162:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  800164:	05067163          	bgeu	a2,a6,8001a6 <printnum+0x68>
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800168:	fff7041b          	addiw	s0,a4,-1
  80016c:	00805763          	blez	s0,80017a <printnum+0x3c>
  800170:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800172:	85ca                	mv	a1,s2
  800174:	854e                	mv	a0,s3
  800176:	9482                	jalr	s1
        while (-- width > 0)
  800178:	fc65                	bnez	s0,800170 <printnum+0x32>
  80017a:	00000417          	auipc	s0,0x0
  80017e:	5c640413          	addi	s0,s0,1478 # 800740 <main+0x78>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  800182:	1a02                	slli	s4,s4,0x20
  800184:	020a5a13          	srli	s4,s4,0x20
  800188:	9452                	add	s0,s0,s4
  80018a:	00044503          	lbu	a0,0(s0)
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  80018e:	7442                	ld	s0,48(sp)
  800190:	70e2                	ld	ra,56(sp)
  800192:	69e2                	ld	s3,24(sp)
  800194:	6a42                	ld	s4,16(sp)
  800196:	6aa2                	ld	s5,8(sp)
  800198:	6b02                	ld	s6,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  80019a:	85ca                	mv	a1,s2
  80019c:	87a6                	mv	a5,s1
}
  80019e:	7902                	ld	s2,32(sp)
  8001a0:	74a2                	ld	s1,40(sp)
  8001a2:	6121                	addi	sp,sp,64
    putch("0123456789abcdef"[mod], putdat);
  8001a4:	8782                	jr	a5
    unsigned mod = do_div(result, base);
  8001a6:	03065633          	divu	a2,a2,a6
  8001aa:	03067ab3          	remu	s5,a2,a6
  8001ae:	2a81                	sext.w	s5,s5
    if (num >= base) {
  8001b0:	03067863          	bgeu	a2,a6,8001e0 <printnum+0xa2>
        while (-- width > 0)
  8001b4:	ffe7041b          	addiw	s0,a4,-2
  8001b8:	00805763          	blez	s0,8001c6 <printnum+0x88>
  8001bc:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  8001be:	85ca                	mv	a1,s2
  8001c0:	854e                	mv	a0,s3
  8001c2:	9482                	jalr	s1
        while (-- width > 0)
  8001c4:	fc65                	bnez	s0,8001bc <printnum+0x7e>
  8001c6:	00000417          	auipc	s0,0x0
  8001ca:	57a40413          	addi	s0,s0,1402 # 800740 <main+0x78>
    putch("0123456789abcdef"[mod], putdat);
  8001ce:	1a82                	slli	s5,s5,0x20
  8001d0:	020ada93          	srli	s5,s5,0x20
  8001d4:	9aa2                	add	s5,s5,s0
  8001d6:	000ac503          	lbu	a0,0(s5)
  8001da:	85ca                	mv	a1,s2
  8001dc:	9482                	jalr	s1
}
  8001de:	b755                	j	800182 <printnum+0x44>
    unsigned mod = do_div(result, base);
  8001e0:	03065633          	divu	a2,a2,a6
        while (-- width > 0)
  8001e4:	ffd7041b          	addiw	s0,a4,-3
    unsigned mod = do_div(result, base);
  8001e8:	03067b33          	remu	s6,a2,a6
  8001ec:	2b01                	sext.w	s6,s6
    if (num >= base) {
  8001ee:	03067663          	bgeu	a2,a6,80021a <printnum+0xdc>
        while (-- width > 0)
  8001f2:	00805763          	blez	s0,800200 <printnum+0xc2>
  8001f6:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  8001f8:	85ca                	mv	a1,s2
  8001fa:	854e                	mv	a0,s3
  8001fc:	9482                	jalr	s1
        while (-- width > 0)
  8001fe:	fc65                	bnez	s0,8001f6 <printnum+0xb8>
    putch("0123456789abcdef"[mod], putdat);
  800200:	1b02                	slli	s6,s6,0x20
  800202:	00000417          	auipc	s0,0x0
  800206:	53e40413          	addi	s0,s0,1342 # 800740 <main+0x78>
  80020a:	020b5b13          	srli	s6,s6,0x20
  80020e:	9b22                	add	s6,s6,s0
  800210:	000b4503          	lbu	a0,0(s6)
  800214:	85ca                	mv	a1,s2
  800216:	9482                	jalr	s1
}
  800218:	bf5d                	j	8001ce <printnum+0x90>
        printnum(putch, putdat, result, base, width - 1, padc);
  80021a:	03065633          	divu	a2,a2,a6
  80021e:	8722                	mv	a4,s0
  800220:	f1fff0ef          	jal	ra,80013e <printnum>
  800224:	bff1                	j	800200 <printnum+0xc2>

0000000000800226 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  800226:	7119                	addi	sp,sp,-128
  800228:	f4a6                	sd	s1,104(sp)
  80022a:	f0ca                	sd	s2,96(sp)
  80022c:	ecce                	sd	s3,88(sp)
  80022e:	e8d2                	sd	s4,80(sp)
  800230:	e4d6                	sd	s5,72(sp)
  800232:	e0da                	sd	s6,64(sp)
  800234:	fc5e                	sd	s7,56(sp)
  800236:	f466                	sd	s9,40(sp)
  800238:	fc86                	sd	ra,120(sp)
  80023a:	f8a2                	sd	s0,112(sp)
  80023c:	f862                	sd	s8,48(sp)
  80023e:	f06a                	sd	s10,32(sp)
  800240:	ec6e                	sd	s11,24(sp)
  800242:	892a                	mv	s2,a0
  800244:	84ae                	mv	s1,a1
  800246:	8cb2                	mv	s9,a2
  800248:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80024a:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  80024e:	5bfd                	li	s7,-1
  800250:	00000a97          	auipc	s5,0x0
  800254:	524a8a93          	addi	s5,s5,1316 # 800774 <main+0xac>
    putch("0123456789abcdef"[mod], putdat);
  800258:	00000b17          	auipc	s6,0x0
  80025c:	4e8b0b13          	addi	s6,s6,1256 # 800740 <main+0x78>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800260:	000cc503          	lbu	a0,0(s9)
  800264:	001c8413          	addi	s0,s9,1
  800268:	01350a63          	beq	a0,s3,80027c <vprintfmt+0x56>
            if (ch == '\0') {
  80026c:	c121                	beqz	a0,8002ac <vprintfmt+0x86>
            putch(ch, putdat);
  80026e:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800270:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  800272:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800274:	fff44503          	lbu	a0,-1(s0)
  800278:	ff351ae3          	bne	a0,s3,80026c <vprintfmt+0x46>
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  80027c:	00044683          	lbu	a3,0(s0)
        char padc = ' ';
  800280:	02000813          	li	a6,32
        lflag = altflag = 0;
  800284:	4d81                	li	s11,0
  800286:	4501                	li	a0,0
        width = precision = -1;
  800288:	5c7d                	li	s8,-1
  80028a:	5d7d                	li	s10,-1
  80028c:	05500613          	li	a2,85
        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
  800290:	45a5                	li	a1,9
        switch (ch = *(unsigned char *)fmt ++) {
  800292:	fdd6879b          	addiw	a5,a3,-35
  800296:	0ff7f793          	zext.b	a5,a5
  80029a:	00140c93          	addi	s9,s0,1
  80029e:	04f66263          	bltu	a2,a5,8002e2 <vprintfmt+0xbc>
  8002a2:	078a                	slli	a5,a5,0x2
  8002a4:	97d6                	add	a5,a5,s5
  8002a6:	439c                	lw	a5,0(a5)
  8002a8:	97d6                	add	a5,a5,s5
  8002aa:	8782                	jr	a5
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8002ac:	70e6                	ld	ra,120(sp)
  8002ae:	7446                	ld	s0,112(sp)
  8002b0:	74a6                	ld	s1,104(sp)
  8002b2:	7906                	ld	s2,96(sp)
  8002b4:	69e6                	ld	s3,88(sp)
  8002b6:	6a46                	ld	s4,80(sp)
  8002b8:	6aa6                	ld	s5,72(sp)
  8002ba:	6b06                	ld	s6,64(sp)
  8002bc:	7be2                	ld	s7,56(sp)
  8002be:	7c42                	ld	s8,48(sp)
  8002c0:	7ca2                	ld	s9,40(sp)
  8002c2:	7d02                	ld	s10,32(sp)
  8002c4:	6de2                	ld	s11,24(sp)
  8002c6:	6109                	addi	sp,sp,128
  8002c8:	8082                	ret
            padc = '0';
  8002ca:	8836                	mv	a6,a3
            goto reswitch;
  8002cc:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  8002d0:	8466                	mv	s0,s9
  8002d2:	00140c93          	addi	s9,s0,1
  8002d6:	fdd6879b          	addiw	a5,a3,-35
  8002da:	0ff7f793          	zext.b	a5,a5
  8002de:	fcf672e3          	bgeu	a2,a5,8002a2 <vprintfmt+0x7c>
            putch('%', putdat);
  8002e2:	85a6                	mv	a1,s1
  8002e4:	02500513          	li	a0,37
  8002e8:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  8002ea:	fff44783          	lbu	a5,-1(s0)
  8002ee:	8ca2                	mv	s9,s0
  8002f0:	f73788e3          	beq	a5,s3,800260 <vprintfmt+0x3a>
  8002f4:	ffecc783          	lbu	a5,-2(s9)
  8002f8:	1cfd                	addi	s9,s9,-1
  8002fa:	ff379de3          	bne	a5,s3,8002f4 <vprintfmt+0xce>
  8002fe:	b78d                	j	800260 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  800300:	fd068c1b          	addiw	s8,a3,-48
                ch = *fmt;
  800304:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800308:	8466                	mv	s0,s9
                if (ch < '0' || ch > '9') {
  80030a:	fd06879b          	addiw	a5,a3,-48
                ch = *fmt;
  80030e:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  800312:	02f5e563          	bltu	a1,a5,80033c <vprintfmt+0x116>
                ch = *fmt;
  800316:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
  80031a:	002c179b          	slliw	a5,s8,0x2
  80031e:	0187873b          	addw	a4,a5,s8
  800322:	0017171b          	slliw	a4,a4,0x1
  800326:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
  80032a:	fd06879b          	addiw	a5,a3,-48
            for (precision = 0; ; ++ fmt) {
  80032e:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  800330:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  800334:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  800338:	fcf5ffe3          	bgeu	a1,a5,800316 <vprintfmt+0xf0>
            if (width < 0)
  80033c:	f40d5be3          	bgez	s10,800292 <vprintfmt+0x6c>
                width = precision, precision = -1;
  800340:	8d62                	mv	s10,s8
  800342:	5c7d                	li	s8,-1
  800344:	b7b9                	j	800292 <vprintfmt+0x6c>
            if (width < 0)
  800346:	fffd4793          	not	a5,s10
  80034a:	97fd                	srai	a5,a5,0x3f
  80034c:	00fd7d33          	and	s10,s10,a5
        switch (ch = *(unsigned char *)fmt ++) {
  800350:	00144683          	lbu	a3,1(s0)
  800354:	2d01                	sext.w	s10,s10
  800356:	8466                	mv	s0,s9
            goto reswitch;
  800358:	bf2d                	j	800292 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  80035a:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  80035e:	00144683          	lbu	a3,1(s0)
            precision = va_arg(ap, int);
  800362:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  800364:	8466                	mv	s0,s9
            goto process_precision;
  800366:	bfd9                	j	80033c <vprintfmt+0x116>
    if (lflag >= 2) {
  800368:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80036a:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  80036e:	00a7c463          	blt	a5,a0,800376 <vprintfmt+0x150>
    else if (lflag) {
  800372:	28050a63          	beqz	a0,800606 <vprintfmt+0x3e0>
        return va_arg(*ap, unsigned long);
  800376:	000a3783          	ld	a5,0(s4)
  80037a:	4641                	li	a2,16
  80037c:	8a3a                	mv	s4,a4
  80037e:	46c1                	li	a3,16
    unsigned mod = do_div(result, base);
  800380:	02c7fdb3          	remu	s11,a5,a2
            printnum(putch, putdat, num, base, width, padc);
  800384:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  800388:	0ac7f563          	bgeu	a5,a2,800432 <vprintfmt+0x20c>
        while (-- width > 0)
  80038c:	3d7d                	addiw	s10,s10,-1
  80038e:	01a05863          	blez	s10,80039e <vprintfmt+0x178>
  800392:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  800394:	85a6                	mv	a1,s1
  800396:	8562                	mv	a0,s8
  800398:	9902                	jalr	s2
        while (-- width > 0)
  80039a:	fe0d1ce3          	bnez	s10,800392 <vprintfmt+0x16c>
    putch("0123456789abcdef"[mod], putdat);
  80039e:	9dda                	add	s11,s11,s6
  8003a0:	000dc503          	lbu	a0,0(s11)
  8003a4:	85a6                	mv	a1,s1
  8003a6:	9902                	jalr	s2
}
  8003a8:	bd65                	j	800260 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  8003aa:	000a2503          	lw	a0,0(s4)
  8003ae:	85a6                	mv	a1,s1
  8003b0:	0a21                	addi	s4,s4,8
  8003b2:	9902                	jalr	s2
            break;
  8003b4:	b575                	j	800260 <vprintfmt+0x3a>
    if (lflag >= 2) {
  8003b6:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8003b8:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  8003bc:	00a7c463          	blt	a5,a0,8003c4 <vprintfmt+0x19e>
    else if (lflag) {
  8003c0:	22050d63          	beqz	a0,8005fa <vprintfmt+0x3d4>
        return va_arg(*ap, unsigned long);
  8003c4:	000a3783          	ld	a5,0(s4)
  8003c8:	4629                	li	a2,10
  8003ca:	8a3a                	mv	s4,a4
  8003cc:	46a9                	li	a3,10
  8003ce:	bf4d                	j	800380 <vprintfmt+0x15a>
        switch (ch = *(unsigned char *)fmt ++) {
  8003d0:	00144683          	lbu	a3,1(s0)
            altflag = 1;
  8003d4:	4d85                	li	s11,1
        switch (ch = *(unsigned char *)fmt ++) {
  8003d6:	8466                	mv	s0,s9
            goto reswitch;
  8003d8:	bd6d                	j	800292 <vprintfmt+0x6c>
            putch(ch, putdat);
  8003da:	85a6                	mv	a1,s1
  8003dc:	02500513          	li	a0,37
  8003e0:	9902                	jalr	s2
            break;
  8003e2:	bdbd                	j	800260 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  8003e4:	00144683          	lbu	a3,1(s0)
            lflag ++;
  8003e8:	2505                	addiw	a0,a0,1
        switch (ch = *(unsigned char *)fmt ++) {
  8003ea:	8466                	mv	s0,s9
            goto reswitch;
  8003ec:	b55d                	j	800292 <vprintfmt+0x6c>
    if (lflag >= 2) {
  8003ee:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8003f0:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  8003f4:	00a7c463          	blt	a5,a0,8003fc <vprintfmt+0x1d6>
    else if (lflag) {
  8003f8:	1e050b63          	beqz	a0,8005ee <vprintfmt+0x3c8>
        return va_arg(*ap, unsigned long);
  8003fc:	000a3783          	ld	a5,0(s4)
  800400:	4621                	li	a2,8
  800402:	8a3a                	mv	s4,a4
  800404:	46a1                	li	a3,8
  800406:	bfad                	j	800380 <vprintfmt+0x15a>
            putch('0', putdat);
  800408:	03000513          	li	a0,48
  80040c:	85a6                	mv	a1,s1
  80040e:	e042                	sd	a6,0(sp)
  800410:	9902                	jalr	s2
            putch('x', putdat);
  800412:	85a6                	mv	a1,s1
  800414:	07800513          	li	a0,120
  800418:	9902                	jalr	s2
            goto number;
  80041a:	6802                	ld	a6,0(sp)
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80041c:	000a3783          	ld	a5,0(s4)
            goto number;
  800420:	4641                	li	a2,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800422:	0a21                	addi	s4,s4,8
    unsigned mod = do_div(result, base);
  800424:	02c7fdb3          	remu	s11,a5,a2
            goto number;
  800428:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
  80042a:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  80042e:	f4c7efe3          	bltu	a5,a2,80038c <vprintfmt+0x166>
        while (-- width > 0)
  800432:	3d79                	addiw	s10,s10,-2
    unsigned mod = do_div(result, base);
  800434:	02c7d7b3          	divu	a5,a5,a2
  800438:	02c7f433          	remu	s0,a5,a2
    if (num >= base) {
  80043c:	10c7f463          	bgeu	a5,a2,800544 <vprintfmt+0x31e>
        while (-- width > 0)
  800440:	01a05863          	blez	s10,800450 <vprintfmt+0x22a>
  800444:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  800446:	85a6                	mv	a1,s1
  800448:	8562                	mv	a0,s8
  80044a:	9902                	jalr	s2
        while (-- width > 0)
  80044c:	fe0d1ce3          	bnez	s10,800444 <vprintfmt+0x21e>
    putch("0123456789abcdef"[mod], putdat);
  800450:	945a                	add	s0,s0,s6
  800452:	00044503          	lbu	a0,0(s0)
  800456:	85a6                	mv	a1,s1
  800458:	9dda                	add	s11,s11,s6
  80045a:	9902                	jalr	s2
  80045c:	000dc503          	lbu	a0,0(s11)
  800460:	85a6                	mv	a1,s1
  800462:	9902                	jalr	s2
  800464:	bbf5                	j	800260 <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
  800466:	000a3403          	ld	s0,0(s4)
  80046a:	008a0793          	addi	a5,s4,8
  80046e:	e43e                	sd	a5,8(sp)
  800470:	1e040563          	beqz	s0,80065a <vprintfmt+0x434>
            if (width > 0 && padc != '-') {
  800474:	15a05263          	blez	s10,8005b8 <vprintfmt+0x392>
  800478:	02d00793          	li	a5,45
  80047c:	10f81b63          	bne	a6,a5,800592 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800480:	00044783          	lbu	a5,0(s0)
  800484:	0007851b          	sext.w	a0,a5
  800488:	0e078c63          	beqz	a5,800580 <vprintfmt+0x35a>
  80048c:	0405                	addi	s0,s0,1
  80048e:	120d8e63          	beqz	s11,8005ca <vprintfmt+0x3a4>
                if (altflag && (ch < ' ' || ch > '~')) {
  800492:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800496:	020c4963          	bltz	s8,8004c8 <vprintfmt+0x2a2>
  80049a:	fffc0a1b          	addiw	s4,s8,-1
  80049e:	0d7a0f63          	beq	s4,s7,80057c <vprintfmt+0x356>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004a2:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  8004a4:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8004a6:	02fdf663          	bgeu	s11,a5,8004d2 <vprintfmt+0x2ac>
                    putch('?', putdat);
  8004aa:	03f00513          	li	a0,63
  8004ae:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004b0:	00044783          	lbu	a5,0(s0)
  8004b4:	3d7d                	addiw	s10,s10,-1
  8004b6:	0405                	addi	s0,s0,1
  8004b8:	0007851b          	sext.w	a0,a5
  8004bc:	c3e1                	beqz	a5,80057c <vprintfmt+0x356>
  8004be:	140c4a63          	bltz	s8,800612 <vprintfmt+0x3ec>
  8004c2:	8c52                	mv	s8,s4
  8004c4:	fc0c5be3          	bgez	s8,80049a <vprintfmt+0x274>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004c8:	3781                	addiw	a5,a5,-32
  8004ca:	8a62                	mv	s4,s8
                    putch('?', putdat);
  8004cc:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8004ce:	fcfdeee3          	bltu	s11,a5,8004aa <vprintfmt+0x284>
                    putch(ch, putdat);
  8004d2:	9902                	jalr	s2
  8004d4:	bff1                	j	8004b0 <vprintfmt+0x28a>
    if (lflag >= 2) {
  8004d6:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8004d8:	008a0d93          	addi	s11,s4,8
    if (lflag >= 2) {
  8004dc:	00a7c463          	blt	a5,a0,8004e4 <vprintfmt+0x2be>
    else if (lflag) {
  8004e0:	10050463          	beqz	a0,8005e8 <vprintfmt+0x3c2>
        return va_arg(*ap, long);
  8004e4:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  8004e8:	14044d63          	bltz	s0,800642 <vprintfmt+0x41c>
            num = getint(&ap, lflag);
  8004ec:	87a2                	mv	a5,s0
  8004ee:	8a6e                	mv	s4,s11
  8004f0:	4629                	li	a2,10
  8004f2:	46a9                	li	a3,10
  8004f4:	b571                	j	800380 <vprintfmt+0x15a>
            err = va_arg(ap, int);
  8004f6:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8004fa:	4761                	li	a4,24
            err = va_arg(ap, int);
  8004fc:	0a21                	addi	s4,s4,8
            if (err < 0) {
  8004fe:	41f7d69b          	sraiw	a3,a5,0x1f
  800502:	8fb5                	xor	a5,a5,a3
  800504:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800508:	02d74563          	blt	a4,a3,800532 <vprintfmt+0x30c>
  80050c:	00369713          	slli	a4,a3,0x3
  800510:	00000797          	auipc	a5,0x0
  800514:	48078793          	addi	a5,a5,1152 # 800990 <error_string>
  800518:	97ba                	add	a5,a5,a4
  80051a:	639c                	ld	a5,0(a5)
  80051c:	cb99                	beqz	a5,800532 <vprintfmt+0x30c>
                printfmt(putch, putdat, "%s", p);
  80051e:	86be                	mv	a3,a5
  800520:	00000617          	auipc	a2,0x0
  800524:	25060613          	addi	a2,a2,592 # 800770 <main+0xa8>
  800528:	85a6                	mv	a1,s1
  80052a:	854a                	mv	a0,s2
  80052c:	160000ef          	jal	ra,80068c <printfmt>
  800530:	bb05                	j	800260 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  800532:	00000617          	auipc	a2,0x0
  800536:	22e60613          	addi	a2,a2,558 # 800760 <main+0x98>
  80053a:	85a6                	mv	a1,s1
  80053c:	854a                	mv	a0,s2
  80053e:	14e000ef          	jal	ra,80068c <printfmt>
  800542:	bb39                	j	800260 <vprintfmt+0x3a>
        printnum(putch, putdat, result, base, width - 1, padc);
  800544:	02c7d633          	divu	a2,a5,a2
  800548:	876a                	mv	a4,s10
  80054a:	87e2                	mv	a5,s8
  80054c:	85a6                	mv	a1,s1
  80054e:	854a                	mv	a0,s2
  800550:	befff0ef          	jal	ra,80013e <printnum>
  800554:	bdf5                	j	800450 <vprintfmt+0x22a>
                    putch(ch, putdat);
  800556:	85a6                	mv	a1,s1
  800558:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80055a:	00044503          	lbu	a0,0(s0)
  80055e:	3d7d                	addiw	s10,s10,-1
  800560:	0405                	addi	s0,s0,1
  800562:	cd09                	beqz	a0,80057c <vprintfmt+0x356>
  800564:	008d0d3b          	addw	s10,s10,s0
  800568:	fffd0d9b          	addiw	s11,s10,-1
                    putch(ch, putdat);
  80056c:	85a6                	mv	a1,s1
  80056e:	408d8d3b          	subw	s10,s11,s0
  800572:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800574:	00044503          	lbu	a0,0(s0)
  800578:	0405                	addi	s0,s0,1
  80057a:	f96d                	bnez	a0,80056c <vprintfmt+0x346>
            for (; width > 0; width --) {
  80057c:	01a05963          	blez	s10,80058e <vprintfmt+0x368>
  800580:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
  800582:	85a6                	mv	a1,s1
  800584:	02000513          	li	a0,32
  800588:	9902                	jalr	s2
            for (; width > 0; width --) {
  80058a:	fe0d1be3          	bnez	s10,800580 <vprintfmt+0x35a>
            if ((p = va_arg(ap, char *)) == NULL) {
  80058e:	6a22                	ld	s4,8(sp)
  800590:	b9c1                	j	800260 <vprintfmt+0x3a>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800592:	85e2                	mv	a1,s8
  800594:	8522                	mv	a0,s0
  800596:	e042                	sd	a6,0(sp)
  800598:	114000ef          	jal	ra,8006ac <strnlen>
  80059c:	40ad0d3b          	subw	s10,s10,a0
  8005a0:	01a05c63          	blez	s10,8005b8 <vprintfmt+0x392>
                    putch(padc, putdat);
  8005a4:	6802                	ld	a6,0(sp)
  8005a6:	0008051b          	sext.w	a0,a6
  8005aa:	85a6                	mv	a1,s1
  8005ac:	e02a                	sd	a0,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005ae:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
  8005b0:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005b2:	6502                	ld	a0,0(sp)
  8005b4:	fe0d1be3          	bnez	s10,8005aa <vprintfmt+0x384>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005b8:	00044783          	lbu	a5,0(s0)
  8005bc:	0405                	addi	s0,s0,1
  8005be:	0007851b          	sext.w	a0,a5
  8005c2:	ec0796e3          	bnez	a5,80048e <vprintfmt+0x268>
            if ((p = va_arg(ap, char *)) == NULL) {
  8005c6:	6a22                	ld	s4,8(sp)
  8005c8:	b961                	j	800260 <vprintfmt+0x3a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005ca:	f80c46e3          	bltz	s8,800556 <vprintfmt+0x330>
  8005ce:	3c7d                	addiw	s8,s8,-1
  8005d0:	fb7c06e3          	beq	s8,s7,80057c <vprintfmt+0x356>
                    putch(ch, putdat);
  8005d4:	85a6                	mv	a1,s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005d6:	0405                	addi	s0,s0,1
                    putch(ch, putdat);
  8005d8:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005da:	fff44503          	lbu	a0,-1(s0)
  8005de:	3d7d                	addiw	s10,s10,-1
  8005e0:	f56d                	bnez	a0,8005ca <vprintfmt+0x3a4>
            for (; width > 0; width --) {
  8005e2:	f9a04fe3          	bgtz	s10,800580 <vprintfmt+0x35a>
  8005e6:	b765                	j	80058e <vprintfmt+0x368>
        return va_arg(*ap, int);
  8005e8:	000a2403          	lw	s0,0(s4)
  8005ec:	bdf5                	j	8004e8 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned int);
  8005ee:	000a6783          	lwu	a5,0(s4)
  8005f2:	4621                	li	a2,8
  8005f4:	8a3a                	mv	s4,a4
  8005f6:	46a1                	li	a3,8
  8005f8:	b361                	j	800380 <vprintfmt+0x15a>
  8005fa:	000a6783          	lwu	a5,0(s4)
  8005fe:	4629                	li	a2,10
  800600:	8a3a                	mv	s4,a4
  800602:	46a9                	li	a3,10
  800604:	bbb5                	j	800380 <vprintfmt+0x15a>
  800606:	000a6783          	lwu	a5,0(s4)
  80060a:	4641                	li	a2,16
  80060c:	8a3a                	mv	s4,a4
  80060e:	46c1                	li	a3,16
  800610:	bb85                	j	800380 <vprintfmt+0x15a>
  800612:	01a40d3b          	addw	s10,s0,s10
                if (altflag && (ch < ' ' || ch > '~')) {
  800616:	05e00d93          	li	s11,94
  80061a:	3d7d                	addiw	s10,s10,-1
  80061c:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  80061e:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800620:	00fdf463          	bgeu	s11,a5,800628 <vprintfmt+0x402>
                    putch('?', putdat);
  800624:	03f00513          	li	a0,63
  800628:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80062a:	00044783          	lbu	a5,0(s0)
  80062e:	408d073b          	subw	a4,s10,s0
  800632:	0405                	addi	s0,s0,1
  800634:	0007851b          	sext.w	a0,a5
  800638:	f3f5                	bnez	a5,80061c <vprintfmt+0x3f6>
  80063a:	8d3a                	mv	s10,a4
            for (; width > 0; width --) {
  80063c:	f5a042e3          	bgtz	s10,800580 <vprintfmt+0x35a>
  800640:	b7b9                	j	80058e <vprintfmt+0x368>
                putch('-', putdat);
  800642:	85a6                	mv	a1,s1
  800644:	02d00513          	li	a0,45
  800648:	e042                	sd	a6,0(sp)
  80064a:	9902                	jalr	s2
                num = -(long long)num;
  80064c:	6802                	ld	a6,0(sp)
  80064e:	8a6e                	mv	s4,s11
  800650:	408007b3          	neg	a5,s0
  800654:	4629                	li	a2,10
  800656:	46a9                	li	a3,10
  800658:	b325                	j	800380 <vprintfmt+0x15a>
            if (width > 0 && padc != '-') {
  80065a:	03a05063          	blez	s10,80067a <vprintfmt+0x454>
  80065e:	02d00793          	li	a5,45
                p = "(null)";
  800662:	00000417          	auipc	s0,0x0
  800666:	0f640413          	addi	s0,s0,246 # 800758 <main+0x90>
            if (width > 0 && padc != '-') {
  80066a:	f2f814e3          	bne	a6,a5,800592 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80066e:	02800793          	li	a5,40
  800672:	02800513          	li	a0,40
  800676:	0405                	addi	s0,s0,1
  800678:	bd19                	j	80048e <vprintfmt+0x268>
  80067a:	02800513          	li	a0,40
  80067e:	02800793          	li	a5,40
  800682:	00000417          	auipc	s0,0x0
  800686:	0d740413          	addi	s0,s0,215 # 800759 <main+0x91>
  80068a:	b511                	j	80048e <vprintfmt+0x268>

000000000080068c <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  80068c:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  80068e:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800692:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800694:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800696:	ec06                	sd	ra,24(sp)
  800698:	f83a                	sd	a4,48(sp)
  80069a:	fc3e                	sd	a5,56(sp)
  80069c:	e0c2                	sd	a6,64(sp)
  80069e:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8006a0:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8006a2:	b85ff0ef          	jal	ra,800226 <vprintfmt>
}
  8006a6:	60e2                	ld	ra,24(sp)
  8006a8:	6161                	addi	sp,sp,80
  8006aa:	8082                	ret

00000000008006ac <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  8006ac:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  8006ae:	e589                	bnez	a1,8006b8 <strnlen+0xc>
  8006b0:	a811                	j	8006c4 <strnlen+0x18>
        cnt ++;
  8006b2:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  8006b4:	00f58863          	beq	a1,a5,8006c4 <strnlen+0x18>
  8006b8:	00f50733          	add	a4,a0,a5
  8006bc:	00074703          	lbu	a4,0(a4)
  8006c0:	fb6d                	bnez	a4,8006b2 <strnlen+0x6>
  8006c2:	85be                	mv	a1,a5
    }
    return cnt;
}
  8006c4:	852e                	mv	a0,a1
  8006c6:	8082                	ret

00000000008006c8 <main>:

int zero;

int
main(void) {
    cprintf("value is %d.\n", 1 / zero);
  8006c8:	00001797          	auipc	a5,0x1
  8006cc:	9387a783          	lw	a5,-1736(a5) # 801000 <zero>
  8006d0:	4585                	li	a1,1
  8006d2:	02f5c5bb          	divw	a1,a1,a5
main(void) {
  8006d6:	1141                	addi	sp,sp,-16
    cprintf("value is %d.\n", 1 / zero);
  8006d8:	00000517          	auipc	a0,0x0
  8006dc:	38050513          	addi	a0,a0,896 # 800a58 <error_string+0xc8>
main(void) {
  8006e0:	e406                	sd	ra,8(sp)
    cprintf("value is %d.\n", 1 / zero);
  8006e2:	9c1ff0ef          	jal	ra,8000a2 <cprintf>
    panic("FAIL: T.T\n");
  8006e6:	00000617          	auipc	a2,0x0
  8006ea:	38260613          	addi	a2,a2,898 # 800a68 <error_string+0xd8>
  8006ee:	45a5                	li	a1,9
  8006f0:	00000517          	auipc	a0,0x0
  8006f4:	38850513          	addi	a0,a0,904 # 800a78 <error_string+0xe8>
  8006f8:	92fff0ef          	jal	ra,800026 <__panic>
