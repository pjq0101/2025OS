
obj/__user_exit.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	12e000ef          	jal	ra,80014e <umain>
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
  80003a:	7c250513          	addi	a0,a0,1986 # 8007f8 <main+0x114>
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
  80005a:	b5250513          	addi	a0,a0,-1198 # 800ba8 <error_string+0x128>
  80005e:	044000ef          	jal	ra,8000a2 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800062:	5559                	li	a0,-10
  800064:	0c8000ef          	jal	ra,80012c <exit>

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
  800070:	0b6000ef          	jal	ra,800126 <sys_putc>
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
  800096:	1ac000ef          	jal	ra,800242 <vprintfmt>
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
  8000cc:	176000ef          	jal	ra,800242 <vprintfmt>
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

0000000000800126 <sys_putc>:
sys_getpid(void) {
    return syscall(SYS_getpid);
}

int
sys_putc(int64_t c) {
  800126:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  800128:	4579                	li	a0,30
  80012a:	b77d                	j	8000d8 <syscall>

000000000080012c <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  80012c:	1141                	addi	sp,sp,-16
  80012e:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  800130:	fe1ff0ef          	jal	ra,800110 <sys_exit>
    cprintf("BUG: exit failed.\n");
  800134:	00000517          	auipc	a0,0x0
  800138:	6e450513          	addi	a0,a0,1764 # 800818 <main+0x134>
  80013c:	f67ff0ef          	jal	ra,8000a2 <cprintf>
    while (1);
  800140:	a001                	j	800140 <exit+0x14>

0000000000800142 <fork>:
}

int
fork(void) {
    return sys_fork();
  800142:	bfd1                	j	800116 <sys_fork>

0000000000800144 <wait>:
}

int
wait(void) {
    return sys_wait(0, NULL);
  800144:	4581                	li	a1,0
  800146:	4501                	li	a0,0
  800148:	bfc9                	j	80011a <sys_wait>

000000000080014a <waitpid>:
}

int
waitpid(int pid, int *store) {
    return sys_wait(pid, store);
  80014a:	bfc1                	j	80011a <sys_wait>

000000000080014c <yield>:
}

void
yield(void) {
    sys_yield();
  80014c:	bfd9                	j	800122 <sys_yield>

000000000080014e <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  80014e:	1141                	addi	sp,sp,-16
  800150:	e406                	sd	ra,8(sp)
    int ret = main();
  800152:	592000ef          	jal	ra,8006e4 <main>
    exit(ret);
  800156:	fd7ff0ef          	jal	ra,80012c <exit>

000000000080015a <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  80015a:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  80015e:	7139                	addi	sp,sp,-64
    unsigned mod = do_div(result, base);
  800160:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800164:	e852                	sd	s4,16(sp)
    unsigned mod = do_div(result, base);
  800166:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  80016a:	f426                	sd	s1,40(sp)
  80016c:	f04a                	sd	s2,32(sp)
  80016e:	ec4e                	sd	s3,24(sp)
  800170:	fc06                	sd	ra,56(sp)
  800172:	f822                	sd	s0,48(sp)
  800174:	e456                	sd	s5,8(sp)
  800176:	e05a                	sd	s6,0(sp)
  800178:	84aa                	mv	s1,a0
  80017a:	892e                	mv	s2,a1
  80017c:	89be                	mv	s3,a5
    unsigned mod = do_div(result, base);
  80017e:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  800180:	05067163          	bgeu	a2,a6,8001c2 <printnum+0x68>
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800184:	fff7041b          	addiw	s0,a4,-1
  800188:	00805763          	blez	s0,800196 <printnum+0x3c>
  80018c:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  80018e:	85ca                	mv	a1,s2
  800190:	854e                	mv	a0,s3
  800192:	9482                	jalr	s1
        while (-- width > 0)
  800194:	fc65                	bnez	s0,80018c <printnum+0x32>
  800196:	00000417          	auipc	s0,0x0
  80019a:	69a40413          	addi	s0,s0,1690 # 800830 <main+0x14c>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  80019e:	1a02                	slli	s4,s4,0x20
  8001a0:	020a5a13          	srli	s4,s4,0x20
  8001a4:	9452                	add	s0,s0,s4
  8001a6:	00044503          	lbu	a0,0(s0)
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  8001aa:	7442                	ld	s0,48(sp)
  8001ac:	70e2                	ld	ra,56(sp)
  8001ae:	69e2                	ld	s3,24(sp)
  8001b0:	6a42                	ld	s4,16(sp)
  8001b2:	6aa2                	ld	s5,8(sp)
  8001b4:	6b02                	ld	s6,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001b6:	85ca                	mv	a1,s2
  8001b8:	87a6                	mv	a5,s1
}
  8001ba:	7902                	ld	s2,32(sp)
  8001bc:	74a2                	ld	s1,40(sp)
  8001be:	6121                	addi	sp,sp,64
    putch("0123456789abcdef"[mod], putdat);
  8001c0:	8782                	jr	a5
    unsigned mod = do_div(result, base);
  8001c2:	03065633          	divu	a2,a2,a6
  8001c6:	03067ab3          	remu	s5,a2,a6
  8001ca:	2a81                	sext.w	s5,s5
    if (num >= base) {
  8001cc:	03067863          	bgeu	a2,a6,8001fc <printnum+0xa2>
        while (-- width > 0)
  8001d0:	ffe7041b          	addiw	s0,a4,-2
  8001d4:	00805763          	blez	s0,8001e2 <printnum+0x88>
  8001d8:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  8001da:	85ca                	mv	a1,s2
  8001dc:	854e                	mv	a0,s3
  8001de:	9482                	jalr	s1
        while (-- width > 0)
  8001e0:	fc65                	bnez	s0,8001d8 <printnum+0x7e>
  8001e2:	00000417          	auipc	s0,0x0
  8001e6:	64e40413          	addi	s0,s0,1614 # 800830 <main+0x14c>
    putch("0123456789abcdef"[mod], putdat);
  8001ea:	1a82                	slli	s5,s5,0x20
  8001ec:	020ada93          	srli	s5,s5,0x20
  8001f0:	9aa2                	add	s5,s5,s0
  8001f2:	000ac503          	lbu	a0,0(s5)
  8001f6:	85ca                	mv	a1,s2
  8001f8:	9482                	jalr	s1
}
  8001fa:	b755                	j	80019e <printnum+0x44>
    unsigned mod = do_div(result, base);
  8001fc:	03065633          	divu	a2,a2,a6
        while (-- width > 0)
  800200:	ffd7041b          	addiw	s0,a4,-3
    unsigned mod = do_div(result, base);
  800204:	03067b33          	remu	s6,a2,a6
  800208:	2b01                	sext.w	s6,s6
    if (num >= base) {
  80020a:	03067663          	bgeu	a2,a6,800236 <printnum+0xdc>
        while (-- width > 0)
  80020e:	00805763          	blez	s0,80021c <printnum+0xc2>
  800212:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800214:	85ca                	mv	a1,s2
  800216:	854e                	mv	a0,s3
  800218:	9482                	jalr	s1
        while (-- width > 0)
  80021a:	fc65                	bnez	s0,800212 <printnum+0xb8>
    putch("0123456789abcdef"[mod], putdat);
  80021c:	1b02                	slli	s6,s6,0x20
  80021e:	00000417          	auipc	s0,0x0
  800222:	61240413          	addi	s0,s0,1554 # 800830 <main+0x14c>
  800226:	020b5b13          	srli	s6,s6,0x20
  80022a:	9b22                	add	s6,s6,s0
  80022c:	000b4503          	lbu	a0,0(s6)
  800230:	85ca                	mv	a1,s2
  800232:	9482                	jalr	s1
}
  800234:	bf5d                	j	8001ea <printnum+0x90>
        printnum(putch, putdat, result, base, width - 1, padc);
  800236:	03065633          	divu	a2,a2,a6
  80023a:	8722                	mv	a4,s0
  80023c:	f1fff0ef          	jal	ra,80015a <printnum>
  800240:	bff1                	j	80021c <printnum+0xc2>

0000000000800242 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  800242:	7119                	addi	sp,sp,-128
  800244:	f4a6                	sd	s1,104(sp)
  800246:	f0ca                	sd	s2,96(sp)
  800248:	ecce                	sd	s3,88(sp)
  80024a:	e8d2                	sd	s4,80(sp)
  80024c:	e4d6                	sd	s5,72(sp)
  80024e:	e0da                	sd	s6,64(sp)
  800250:	fc5e                	sd	s7,56(sp)
  800252:	f466                	sd	s9,40(sp)
  800254:	fc86                	sd	ra,120(sp)
  800256:	f8a2                	sd	s0,112(sp)
  800258:	f862                	sd	s8,48(sp)
  80025a:	f06a                	sd	s10,32(sp)
  80025c:	ec6e                	sd	s11,24(sp)
  80025e:	892a                	mv	s2,a0
  800260:	84ae                	mv	s1,a1
  800262:	8cb2                	mv	s9,a2
  800264:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800266:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  80026a:	5bfd                	li	s7,-1
  80026c:	00000a97          	auipc	s5,0x0
  800270:	5f8a8a93          	addi	s5,s5,1528 # 800864 <main+0x180>
    putch("0123456789abcdef"[mod], putdat);
  800274:	00000b17          	auipc	s6,0x0
  800278:	5bcb0b13          	addi	s6,s6,1468 # 800830 <main+0x14c>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80027c:	000cc503          	lbu	a0,0(s9)
  800280:	001c8413          	addi	s0,s9,1
  800284:	01350a63          	beq	a0,s3,800298 <vprintfmt+0x56>
            if (ch == '\0') {
  800288:	c121                	beqz	a0,8002c8 <vprintfmt+0x86>
            putch(ch, putdat);
  80028a:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80028c:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  80028e:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800290:	fff44503          	lbu	a0,-1(s0)
  800294:	ff351ae3          	bne	a0,s3,800288 <vprintfmt+0x46>
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  800298:	00044683          	lbu	a3,0(s0)
        char padc = ' ';
  80029c:	02000813          	li	a6,32
        lflag = altflag = 0;
  8002a0:	4d81                	li	s11,0
  8002a2:	4501                	li	a0,0
        width = precision = -1;
  8002a4:	5c7d                	li	s8,-1
  8002a6:	5d7d                	li	s10,-1
  8002a8:	05500613          	li	a2,85
        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
  8002ac:	45a5                	li	a1,9
        switch (ch = *(unsigned char *)fmt ++) {
  8002ae:	fdd6879b          	addiw	a5,a3,-35
  8002b2:	0ff7f793          	zext.b	a5,a5
  8002b6:	00140c93          	addi	s9,s0,1
  8002ba:	04f66263          	bltu	a2,a5,8002fe <vprintfmt+0xbc>
  8002be:	078a                	slli	a5,a5,0x2
  8002c0:	97d6                	add	a5,a5,s5
  8002c2:	439c                	lw	a5,0(a5)
  8002c4:	97d6                	add	a5,a5,s5
  8002c6:	8782                	jr	a5
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8002c8:	70e6                	ld	ra,120(sp)
  8002ca:	7446                	ld	s0,112(sp)
  8002cc:	74a6                	ld	s1,104(sp)
  8002ce:	7906                	ld	s2,96(sp)
  8002d0:	69e6                	ld	s3,88(sp)
  8002d2:	6a46                	ld	s4,80(sp)
  8002d4:	6aa6                	ld	s5,72(sp)
  8002d6:	6b06                	ld	s6,64(sp)
  8002d8:	7be2                	ld	s7,56(sp)
  8002da:	7c42                	ld	s8,48(sp)
  8002dc:	7ca2                	ld	s9,40(sp)
  8002de:	7d02                	ld	s10,32(sp)
  8002e0:	6de2                	ld	s11,24(sp)
  8002e2:	6109                	addi	sp,sp,128
  8002e4:	8082                	ret
            padc = '0';
  8002e6:	8836                	mv	a6,a3
            goto reswitch;
  8002e8:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  8002ec:	8466                	mv	s0,s9
  8002ee:	00140c93          	addi	s9,s0,1
  8002f2:	fdd6879b          	addiw	a5,a3,-35
  8002f6:	0ff7f793          	zext.b	a5,a5
  8002fa:	fcf672e3          	bgeu	a2,a5,8002be <vprintfmt+0x7c>
            putch('%', putdat);
  8002fe:	85a6                	mv	a1,s1
  800300:	02500513          	li	a0,37
  800304:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800306:	fff44783          	lbu	a5,-1(s0)
  80030a:	8ca2                	mv	s9,s0
  80030c:	f73788e3          	beq	a5,s3,80027c <vprintfmt+0x3a>
  800310:	ffecc783          	lbu	a5,-2(s9)
  800314:	1cfd                	addi	s9,s9,-1
  800316:	ff379de3          	bne	a5,s3,800310 <vprintfmt+0xce>
  80031a:	b78d                	j	80027c <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  80031c:	fd068c1b          	addiw	s8,a3,-48
                ch = *fmt;
  800320:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800324:	8466                	mv	s0,s9
                if (ch < '0' || ch > '9') {
  800326:	fd06879b          	addiw	a5,a3,-48
                ch = *fmt;
  80032a:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  80032e:	02f5e563          	bltu	a1,a5,800358 <vprintfmt+0x116>
                ch = *fmt;
  800332:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
  800336:	002c179b          	slliw	a5,s8,0x2
  80033a:	0187873b          	addw	a4,a5,s8
  80033e:	0017171b          	slliw	a4,a4,0x1
  800342:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
  800346:	fd06879b          	addiw	a5,a3,-48
            for (precision = 0; ; ++ fmt) {
  80034a:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  80034c:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  800350:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  800354:	fcf5ffe3          	bgeu	a1,a5,800332 <vprintfmt+0xf0>
            if (width < 0)
  800358:	f40d5be3          	bgez	s10,8002ae <vprintfmt+0x6c>
                width = precision, precision = -1;
  80035c:	8d62                	mv	s10,s8
  80035e:	5c7d                	li	s8,-1
  800360:	b7b9                	j	8002ae <vprintfmt+0x6c>
            if (width < 0)
  800362:	fffd4793          	not	a5,s10
  800366:	97fd                	srai	a5,a5,0x3f
  800368:	00fd7d33          	and	s10,s10,a5
        switch (ch = *(unsigned char *)fmt ++) {
  80036c:	00144683          	lbu	a3,1(s0)
  800370:	2d01                	sext.w	s10,s10
  800372:	8466                	mv	s0,s9
            goto reswitch;
  800374:	bf2d                	j	8002ae <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  800376:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  80037a:	00144683          	lbu	a3,1(s0)
            precision = va_arg(ap, int);
  80037e:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  800380:	8466                	mv	s0,s9
            goto process_precision;
  800382:	bfd9                	j	800358 <vprintfmt+0x116>
    if (lflag >= 2) {
  800384:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800386:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  80038a:	00a7c463          	blt	a5,a0,800392 <vprintfmt+0x150>
    else if (lflag) {
  80038e:	28050a63          	beqz	a0,800622 <vprintfmt+0x3e0>
        return va_arg(*ap, unsigned long);
  800392:	000a3783          	ld	a5,0(s4)
  800396:	4641                	li	a2,16
  800398:	8a3a                	mv	s4,a4
  80039a:	46c1                	li	a3,16
    unsigned mod = do_div(result, base);
  80039c:	02c7fdb3          	remu	s11,a5,a2
            printnum(putch, putdat, num, base, width, padc);
  8003a0:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  8003a4:	0ac7f563          	bgeu	a5,a2,80044e <vprintfmt+0x20c>
        while (-- width > 0)
  8003a8:	3d7d                	addiw	s10,s10,-1
  8003aa:	01a05863          	blez	s10,8003ba <vprintfmt+0x178>
  8003ae:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  8003b0:	85a6                	mv	a1,s1
  8003b2:	8562                	mv	a0,s8
  8003b4:	9902                	jalr	s2
        while (-- width > 0)
  8003b6:	fe0d1ce3          	bnez	s10,8003ae <vprintfmt+0x16c>
    putch("0123456789abcdef"[mod], putdat);
  8003ba:	9dda                	add	s11,s11,s6
  8003bc:	000dc503          	lbu	a0,0(s11)
  8003c0:	85a6                	mv	a1,s1
  8003c2:	9902                	jalr	s2
}
  8003c4:	bd65                	j	80027c <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  8003c6:	000a2503          	lw	a0,0(s4)
  8003ca:	85a6                	mv	a1,s1
  8003cc:	0a21                	addi	s4,s4,8
  8003ce:	9902                	jalr	s2
            break;
  8003d0:	b575                	j	80027c <vprintfmt+0x3a>
    if (lflag >= 2) {
  8003d2:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8003d4:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  8003d8:	00a7c463          	blt	a5,a0,8003e0 <vprintfmt+0x19e>
    else if (lflag) {
  8003dc:	22050d63          	beqz	a0,800616 <vprintfmt+0x3d4>
        return va_arg(*ap, unsigned long);
  8003e0:	000a3783          	ld	a5,0(s4)
  8003e4:	4629                	li	a2,10
  8003e6:	8a3a                	mv	s4,a4
  8003e8:	46a9                	li	a3,10
  8003ea:	bf4d                	j	80039c <vprintfmt+0x15a>
        switch (ch = *(unsigned char *)fmt ++) {
  8003ec:	00144683          	lbu	a3,1(s0)
            altflag = 1;
  8003f0:	4d85                	li	s11,1
        switch (ch = *(unsigned char *)fmt ++) {
  8003f2:	8466                	mv	s0,s9
            goto reswitch;
  8003f4:	bd6d                	j	8002ae <vprintfmt+0x6c>
            putch(ch, putdat);
  8003f6:	85a6                	mv	a1,s1
  8003f8:	02500513          	li	a0,37
  8003fc:	9902                	jalr	s2
            break;
  8003fe:	bdbd                	j	80027c <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  800400:	00144683          	lbu	a3,1(s0)
            lflag ++;
  800404:	2505                	addiw	a0,a0,1
        switch (ch = *(unsigned char *)fmt ++) {
  800406:	8466                	mv	s0,s9
            goto reswitch;
  800408:	b55d                	j	8002ae <vprintfmt+0x6c>
    if (lflag >= 2) {
  80040a:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80040c:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800410:	00a7c463          	blt	a5,a0,800418 <vprintfmt+0x1d6>
    else if (lflag) {
  800414:	1e050b63          	beqz	a0,80060a <vprintfmt+0x3c8>
        return va_arg(*ap, unsigned long);
  800418:	000a3783          	ld	a5,0(s4)
  80041c:	4621                	li	a2,8
  80041e:	8a3a                	mv	s4,a4
  800420:	46a1                	li	a3,8
  800422:	bfad                	j	80039c <vprintfmt+0x15a>
            putch('0', putdat);
  800424:	03000513          	li	a0,48
  800428:	85a6                	mv	a1,s1
  80042a:	e042                	sd	a6,0(sp)
  80042c:	9902                	jalr	s2
            putch('x', putdat);
  80042e:	85a6                	mv	a1,s1
  800430:	07800513          	li	a0,120
  800434:	9902                	jalr	s2
            goto number;
  800436:	6802                	ld	a6,0(sp)
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800438:	000a3783          	ld	a5,0(s4)
            goto number;
  80043c:	4641                	li	a2,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80043e:	0a21                	addi	s4,s4,8
    unsigned mod = do_div(result, base);
  800440:	02c7fdb3          	remu	s11,a5,a2
            goto number;
  800444:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
  800446:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  80044a:	f4c7efe3          	bltu	a5,a2,8003a8 <vprintfmt+0x166>
        while (-- width > 0)
  80044e:	3d79                	addiw	s10,s10,-2
    unsigned mod = do_div(result, base);
  800450:	02c7d7b3          	divu	a5,a5,a2
  800454:	02c7f433          	remu	s0,a5,a2
    if (num >= base) {
  800458:	10c7f463          	bgeu	a5,a2,800560 <vprintfmt+0x31e>
        while (-- width > 0)
  80045c:	01a05863          	blez	s10,80046c <vprintfmt+0x22a>
  800460:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  800462:	85a6                	mv	a1,s1
  800464:	8562                	mv	a0,s8
  800466:	9902                	jalr	s2
        while (-- width > 0)
  800468:	fe0d1ce3          	bnez	s10,800460 <vprintfmt+0x21e>
    putch("0123456789abcdef"[mod], putdat);
  80046c:	945a                	add	s0,s0,s6
  80046e:	00044503          	lbu	a0,0(s0)
  800472:	85a6                	mv	a1,s1
  800474:	9dda                	add	s11,s11,s6
  800476:	9902                	jalr	s2
  800478:	000dc503          	lbu	a0,0(s11)
  80047c:	85a6                	mv	a1,s1
  80047e:	9902                	jalr	s2
  800480:	bbf5                	j	80027c <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
  800482:	000a3403          	ld	s0,0(s4)
  800486:	008a0793          	addi	a5,s4,8
  80048a:	e43e                	sd	a5,8(sp)
  80048c:	1e040563          	beqz	s0,800676 <vprintfmt+0x434>
            if (width > 0 && padc != '-') {
  800490:	15a05263          	blez	s10,8005d4 <vprintfmt+0x392>
  800494:	02d00793          	li	a5,45
  800498:	10f81b63          	bne	a6,a5,8005ae <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80049c:	00044783          	lbu	a5,0(s0)
  8004a0:	0007851b          	sext.w	a0,a5
  8004a4:	0e078c63          	beqz	a5,80059c <vprintfmt+0x35a>
  8004a8:	0405                	addi	s0,s0,1
  8004aa:	120d8e63          	beqz	s11,8005e6 <vprintfmt+0x3a4>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004ae:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004b2:	020c4963          	bltz	s8,8004e4 <vprintfmt+0x2a2>
  8004b6:	fffc0a1b          	addiw	s4,s8,-1
  8004ba:	0d7a0f63          	beq	s4,s7,800598 <vprintfmt+0x356>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004be:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  8004c0:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8004c2:	02fdf663          	bgeu	s11,a5,8004ee <vprintfmt+0x2ac>
                    putch('?', putdat);
  8004c6:	03f00513          	li	a0,63
  8004ca:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004cc:	00044783          	lbu	a5,0(s0)
  8004d0:	3d7d                	addiw	s10,s10,-1
  8004d2:	0405                	addi	s0,s0,1
  8004d4:	0007851b          	sext.w	a0,a5
  8004d8:	c3e1                	beqz	a5,800598 <vprintfmt+0x356>
  8004da:	140c4a63          	bltz	s8,80062e <vprintfmt+0x3ec>
  8004de:	8c52                	mv	s8,s4
  8004e0:	fc0c5be3          	bgez	s8,8004b6 <vprintfmt+0x274>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004e4:	3781                	addiw	a5,a5,-32
  8004e6:	8a62                	mv	s4,s8
                    putch('?', putdat);
  8004e8:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8004ea:	fcfdeee3          	bltu	s11,a5,8004c6 <vprintfmt+0x284>
                    putch(ch, putdat);
  8004ee:	9902                	jalr	s2
  8004f0:	bff1                	j	8004cc <vprintfmt+0x28a>
    if (lflag >= 2) {
  8004f2:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8004f4:	008a0d93          	addi	s11,s4,8
    if (lflag >= 2) {
  8004f8:	00a7c463          	blt	a5,a0,800500 <vprintfmt+0x2be>
    else if (lflag) {
  8004fc:	10050463          	beqz	a0,800604 <vprintfmt+0x3c2>
        return va_arg(*ap, long);
  800500:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  800504:	14044d63          	bltz	s0,80065e <vprintfmt+0x41c>
            num = getint(&ap, lflag);
  800508:	87a2                	mv	a5,s0
  80050a:	8a6e                	mv	s4,s11
  80050c:	4629                	li	a2,10
  80050e:	46a9                	li	a3,10
  800510:	b571                	j	80039c <vprintfmt+0x15a>
            err = va_arg(ap, int);
  800512:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800516:	4761                	li	a4,24
            err = va_arg(ap, int);
  800518:	0a21                	addi	s4,s4,8
            if (err < 0) {
  80051a:	41f7d69b          	sraiw	a3,a5,0x1f
  80051e:	8fb5                	xor	a5,a5,a3
  800520:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800524:	02d74563          	blt	a4,a3,80054e <vprintfmt+0x30c>
  800528:	00369713          	slli	a4,a3,0x3
  80052c:	00000797          	auipc	a5,0x0
  800530:	55478793          	addi	a5,a5,1364 # 800a80 <error_string>
  800534:	97ba                	add	a5,a5,a4
  800536:	639c                	ld	a5,0(a5)
  800538:	cb99                	beqz	a5,80054e <vprintfmt+0x30c>
                printfmt(putch, putdat, "%s", p);
  80053a:	86be                	mv	a3,a5
  80053c:	00000617          	auipc	a2,0x0
  800540:	32460613          	addi	a2,a2,804 # 800860 <main+0x17c>
  800544:	85a6                	mv	a1,s1
  800546:	854a                	mv	a0,s2
  800548:	160000ef          	jal	ra,8006a8 <printfmt>
  80054c:	bb05                	j	80027c <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  80054e:	00000617          	auipc	a2,0x0
  800552:	30260613          	addi	a2,a2,770 # 800850 <main+0x16c>
  800556:	85a6                	mv	a1,s1
  800558:	854a                	mv	a0,s2
  80055a:	14e000ef          	jal	ra,8006a8 <printfmt>
  80055e:	bb39                	j	80027c <vprintfmt+0x3a>
        printnum(putch, putdat, result, base, width - 1, padc);
  800560:	02c7d633          	divu	a2,a5,a2
  800564:	876a                	mv	a4,s10
  800566:	87e2                	mv	a5,s8
  800568:	85a6                	mv	a1,s1
  80056a:	854a                	mv	a0,s2
  80056c:	befff0ef          	jal	ra,80015a <printnum>
  800570:	bdf5                	j	80046c <vprintfmt+0x22a>
                    putch(ch, putdat);
  800572:	85a6                	mv	a1,s1
  800574:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800576:	00044503          	lbu	a0,0(s0)
  80057a:	3d7d                	addiw	s10,s10,-1
  80057c:	0405                	addi	s0,s0,1
  80057e:	cd09                	beqz	a0,800598 <vprintfmt+0x356>
  800580:	008d0d3b          	addw	s10,s10,s0
  800584:	fffd0d9b          	addiw	s11,s10,-1
                    putch(ch, putdat);
  800588:	85a6                	mv	a1,s1
  80058a:	408d8d3b          	subw	s10,s11,s0
  80058e:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800590:	00044503          	lbu	a0,0(s0)
  800594:	0405                	addi	s0,s0,1
  800596:	f96d                	bnez	a0,800588 <vprintfmt+0x346>
            for (; width > 0; width --) {
  800598:	01a05963          	blez	s10,8005aa <vprintfmt+0x368>
  80059c:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
  80059e:	85a6                	mv	a1,s1
  8005a0:	02000513          	li	a0,32
  8005a4:	9902                	jalr	s2
            for (; width > 0; width --) {
  8005a6:	fe0d1be3          	bnez	s10,80059c <vprintfmt+0x35a>
            if ((p = va_arg(ap, char *)) == NULL) {
  8005aa:	6a22                	ld	s4,8(sp)
  8005ac:	b9c1                	j	80027c <vprintfmt+0x3a>
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005ae:	85e2                	mv	a1,s8
  8005b0:	8522                	mv	a0,s0
  8005b2:	e042                	sd	a6,0(sp)
  8005b4:	114000ef          	jal	ra,8006c8 <strnlen>
  8005b8:	40ad0d3b          	subw	s10,s10,a0
  8005bc:	01a05c63          	blez	s10,8005d4 <vprintfmt+0x392>
                    putch(padc, putdat);
  8005c0:	6802                	ld	a6,0(sp)
  8005c2:	0008051b          	sext.w	a0,a6
  8005c6:	85a6                	mv	a1,s1
  8005c8:	e02a                	sd	a0,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005ca:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
  8005cc:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005ce:	6502                	ld	a0,0(sp)
  8005d0:	fe0d1be3          	bnez	s10,8005c6 <vprintfmt+0x384>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005d4:	00044783          	lbu	a5,0(s0)
  8005d8:	0405                	addi	s0,s0,1
  8005da:	0007851b          	sext.w	a0,a5
  8005de:	ec0796e3          	bnez	a5,8004aa <vprintfmt+0x268>
            if ((p = va_arg(ap, char *)) == NULL) {
  8005e2:	6a22                	ld	s4,8(sp)
  8005e4:	b961                	j	80027c <vprintfmt+0x3a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005e6:	f80c46e3          	bltz	s8,800572 <vprintfmt+0x330>
  8005ea:	3c7d                	addiw	s8,s8,-1
  8005ec:	fb7c06e3          	beq	s8,s7,800598 <vprintfmt+0x356>
                    putch(ch, putdat);
  8005f0:	85a6                	mv	a1,s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005f2:	0405                	addi	s0,s0,1
                    putch(ch, putdat);
  8005f4:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005f6:	fff44503          	lbu	a0,-1(s0)
  8005fa:	3d7d                	addiw	s10,s10,-1
  8005fc:	f56d                	bnez	a0,8005e6 <vprintfmt+0x3a4>
            for (; width > 0; width --) {
  8005fe:	f9a04fe3          	bgtz	s10,80059c <vprintfmt+0x35a>
  800602:	b765                	j	8005aa <vprintfmt+0x368>
        return va_arg(*ap, int);
  800604:	000a2403          	lw	s0,0(s4)
  800608:	bdf5                	j	800504 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned int);
  80060a:	000a6783          	lwu	a5,0(s4)
  80060e:	4621                	li	a2,8
  800610:	8a3a                	mv	s4,a4
  800612:	46a1                	li	a3,8
  800614:	b361                	j	80039c <vprintfmt+0x15a>
  800616:	000a6783          	lwu	a5,0(s4)
  80061a:	4629                	li	a2,10
  80061c:	8a3a                	mv	s4,a4
  80061e:	46a9                	li	a3,10
  800620:	bbb5                	j	80039c <vprintfmt+0x15a>
  800622:	000a6783          	lwu	a5,0(s4)
  800626:	4641                	li	a2,16
  800628:	8a3a                	mv	s4,a4
  80062a:	46c1                	li	a3,16
  80062c:	bb85                	j	80039c <vprintfmt+0x15a>
  80062e:	01a40d3b          	addw	s10,s0,s10
                if (altflag && (ch < ' ' || ch > '~')) {
  800632:	05e00d93          	li	s11,94
  800636:	3d7d                	addiw	s10,s10,-1
  800638:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  80063a:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  80063c:	00fdf463          	bgeu	s11,a5,800644 <vprintfmt+0x402>
                    putch('?', putdat);
  800640:	03f00513          	li	a0,63
  800644:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800646:	00044783          	lbu	a5,0(s0)
  80064a:	408d073b          	subw	a4,s10,s0
  80064e:	0405                	addi	s0,s0,1
  800650:	0007851b          	sext.w	a0,a5
  800654:	f3f5                	bnez	a5,800638 <vprintfmt+0x3f6>
  800656:	8d3a                	mv	s10,a4
            for (; width > 0; width --) {
  800658:	f5a042e3          	bgtz	s10,80059c <vprintfmt+0x35a>
  80065c:	b7b9                	j	8005aa <vprintfmt+0x368>
                putch('-', putdat);
  80065e:	85a6                	mv	a1,s1
  800660:	02d00513          	li	a0,45
  800664:	e042                	sd	a6,0(sp)
  800666:	9902                	jalr	s2
                num = -(long long)num;
  800668:	6802                	ld	a6,0(sp)
  80066a:	8a6e                	mv	s4,s11
  80066c:	408007b3          	neg	a5,s0
  800670:	4629                	li	a2,10
  800672:	46a9                	li	a3,10
  800674:	b325                	j	80039c <vprintfmt+0x15a>
            if (width > 0 && padc != '-') {
  800676:	03a05063          	blez	s10,800696 <vprintfmt+0x454>
  80067a:	02d00793          	li	a5,45
                p = "(null)";
  80067e:	00000417          	auipc	s0,0x0
  800682:	1ca40413          	addi	s0,s0,458 # 800848 <main+0x164>
            if (width > 0 && padc != '-') {
  800686:	f2f814e3          	bne	a6,a5,8005ae <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80068a:	02800793          	li	a5,40
  80068e:	02800513          	li	a0,40
  800692:	0405                	addi	s0,s0,1
  800694:	bd19                	j	8004aa <vprintfmt+0x268>
  800696:	02800513          	li	a0,40
  80069a:	02800793          	li	a5,40
  80069e:	00000417          	auipc	s0,0x0
  8006a2:	1ab40413          	addi	s0,s0,427 # 800849 <main+0x165>
  8006a6:	b511                	j	8004aa <vprintfmt+0x268>

00000000008006a8 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006a8:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  8006aa:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006ae:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8006b0:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006b2:	ec06                	sd	ra,24(sp)
  8006b4:	f83a                	sd	a4,48(sp)
  8006b6:	fc3e                	sd	a5,56(sp)
  8006b8:	e0c2                	sd	a6,64(sp)
  8006ba:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8006bc:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8006be:	b85ff0ef          	jal	ra,800242 <vprintfmt>
}
  8006c2:	60e2                	ld	ra,24(sp)
  8006c4:	6161                	addi	sp,sp,80
  8006c6:	8082                	ret

00000000008006c8 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  8006c8:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  8006ca:	e589                	bnez	a1,8006d4 <strnlen+0xc>
  8006cc:	a811                	j	8006e0 <strnlen+0x18>
        cnt ++;
  8006ce:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  8006d0:	00f58863          	beq	a1,a5,8006e0 <strnlen+0x18>
  8006d4:	00f50733          	add	a4,a0,a5
  8006d8:	00074703          	lbu	a4,0(a4)
  8006dc:	fb6d                	bnez	a4,8006ce <strnlen+0x6>
  8006de:	85be                	mv	a1,a5
    }
    return cnt;
}
  8006e0:	852e                	mv	a0,a1
  8006e2:	8082                	ret

00000000008006e4 <main>:
#include <ulib.h>

int magic = -0x10384;

int
main(void) {
  8006e4:	1101                	addi	sp,sp,-32
    int pid, code;
    cprintf("I am the parent. Forking the child...\n");
  8006e6:	00000517          	auipc	a0,0x0
  8006ea:	46250513          	addi	a0,a0,1122 # 800b48 <error_string+0xc8>
main(void) {
  8006ee:	ec06                	sd	ra,24(sp)
  8006f0:	e822                	sd	s0,16(sp)
    cprintf("I am the parent. Forking the child...\n");
  8006f2:	9b1ff0ef          	jal	ra,8000a2 <cprintf>
    if ((pid = fork()) == 0) {
  8006f6:	a4dff0ef          	jal	ra,800142 <fork>
  8006fa:	c561                	beqz	a0,8007c2 <main+0xde>
  8006fc:	842a                	mv	s0,a0
        yield();
        yield();
        exit(magic);
    }
    else {
        cprintf("I am parent, fork a child pid %d\n",pid);
  8006fe:	85aa                	mv	a1,a0
  800700:	00000517          	auipc	a0,0x0
  800704:	48850513          	addi	a0,a0,1160 # 800b88 <error_string+0x108>
  800708:	99bff0ef          	jal	ra,8000a2 <cprintf>
    }
    assert(pid > 0);
  80070c:	08805c63          	blez	s0,8007a4 <main+0xc0>
    cprintf("I am the parent, waiting now..\n");
  800710:	00000517          	auipc	a0,0x0
  800714:	4d050513          	addi	a0,a0,1232 # 800be0 <error_string+0x160>
  800718:	98bff0ef          	jal	ra,8000a2 <cprintf>

    assert(waitpid(pid, &code) == 0 && code == magic);
  80071c:	006c                	addi	a1,sp,12
  80071e:	8522                	mv	a0,s0
  800720:	a2bff0ef          	jal	ra,80014a <waitpid>
  800724:	e131                	bnez	a0,800768 <main+0x84>
  800726:	4732                	lw	a4,12(sp)
  800728:	00001797          	auipc	a5,0x1
  80072c:	8d87a783          	lw	a5,-1832(a5) # 801000 <magic>
  800730:	02f71c63          	bne	a4,a5,800768 <main+0x84>
    assert(waitpid(pid, &code) != 0 && wait() != 0);
  800734:	006c                	addi	a1,sp,12
  800736:	8522                	mv	a0,s0
  800738:	a13ff0ef          	jal	ra,80014a <waitpid>
  80073c:	c529                	beqz	a0,800786 <main+0xa2>
  80073e:	a07ff0ef          	jal	ra,800144 <wait>
  800742:	c131                	beqz	a0,800786 <main+0xa2>
    cprintf("waitpid %d ok.\n", pid);
  800744:	85a2                	mv	a1,s0
  800746:	00000517          	auipc	a0,0x0
  80074a:	51250513          	addi	a0,a0,1298 # 800c58 <error_string+0x1d8>
  80074e:	955ff0ef          	jal	ra,8000a2 <cprintf>

    cprintf("exit pass.\n");
  800752:	00000517          	auipc	a0,0x0
  800756:	51650513          	addi	a0,a0,1302 # 800c68 <error_string+0x1e8>
  80075a:	949ff0ef          	jal	ra,8000a2 <cprintf>
    return 0;
}
  80075e:	60e2                	ld	ra,24(sp)
  800760:	6442                	ld	s0,16(sp)
  800762:	4501                	li	a0,0
  800764:	6105                	addi	sp,sp,32
  800766:	8082                	ret
    assert(waitpid(pid, &code) == 0 && code == magic);
  800768:	00000697          	auipc	a3,0x0
  80076c:	49868693          	addi	a3,a3,1176 # 800c00 <error_string+0x180>
  800770:	00000617          	auipc	a2,0x0
  800774:	44860613          	addi	a2,a2,1096 # 800bb8 <error_string+0x138>
  800778:	45ed                	li	a1,27
  80077a:	00000517          	auipc	a0,0x0
  80077e:	45650513          	addi	a0,a0,1110 # 800bd0 <error_string+0x150>
  800782:	8a5ff0ef          	jal	ra,800026 <__panic>
    assert(waitpid(pid, &code) != 0 && wait() != 0);
  800786:	00000697          	auipc	a3,0x0
  80078a:	4aa68693          	addi	a3,a3,1194 # 800c30 <error_string+0x1b0>
  80078e:	00000617          	auipc	a2,0x0
  800792:	42a60613          	addi	a2,a2,1066 # 800bb8 <error_string+0x138>
  800796:	45f1                	li	a1,28
  800798:	00000517          	auipc	a0,0x0
  80079c:	43850513          	addi	a0,a0,1080 # 800bd0 <error_string+0x150>
  8007a0:	887ff0ef          	jal	ra,800026 <__panic>
    assert(pid > 0);
  8007a4:	00000697          	auipc	a3,0x0
  8007a8:	40c68693          	addi	a3,a3,1036 # 800bb0 <error_string+0x130>
  8007ac:	00000617          	auipc	a2,0x0
  8007b0:	40c60613          	addi	a2,a2,1036 # 800bb8 <error_string+0x138>
  8007b4:	45e1                	li	a1,24
  8007b6:	00000517          	auipc	a0,0x0
  8007ba:	41a50513          	addi	a0,a0,1050 # 800bd0 <error_string+0x150>
  8007be:	869ff0ef          	jal	ra,800026 <__panic>
        cprintf("I am the child.\n");
  8007c2:	00000517          	auipc	a0,0x0
  8007c6:	3ae50513          	addi	a0,a0,942 # 800b70 <error_string+0xf0>
  8007ca:	8d9ff0ef          	jal	ra,8000a2 <cprintf>
        yield();
  8007ce:	97fff0ef          	jal	ra,80014c <yield>
        yield();
  8007d2:	97bff0ef          	jal	ra,80014c <yield>
        yield();
  8007d6:	977ff0ef          	jal	ra,80014c <yield>
        yield();
  8007da:	973ff0ef          	jal	ra,80014c <yield>
        yield();
  8007de:	96fff0ef          	jal	ra,80014c <yield>
        yield();
  8007e2:	96bff0ef          	jal	ra,80014c <yield>
        yield();
  8007e6:	967ff0ef          	jal	ra,80014c <yield>
        exit(magic);
  8007ea:	00001517          	auipc	a0,0x1
  8007ee:	81652503          	lw	a0,-2026(a0) # 801000 <magic>
  8007f2:	93bff0ef          	jal	ra,80012c <exit>
