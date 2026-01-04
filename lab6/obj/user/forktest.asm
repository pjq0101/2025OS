
obj/__user_forktest.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	126000ef          	jal	ra,800146 <umain>
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
  80003a:	75250513          	addi	a0,a0,1874 # 800788 <main+0xac>
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
  80005a:	75250513          	addi	a0,a0,1874 # 8007a8 <main+0xcc>
  80005e:	044000ef          	jal	ra,8000a2 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800062:	5559                	li	a0,-10
  800064:	0c4000ef          	jal	ra,800128 <exit>

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
  800070:	0b2000ef          	jal	ra,800122 <sys_putc>
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
  800096:	1a4000ef          	jal	ra,80023a <vprintfmt>
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
  8000cc:	16e000ef          	jal	ra,80023a <vprintfmt>
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

0000000000800122 <sys_putc>:
sys_getpid(void) {
    return syscall(SYS_getpid);
}

int
sys_putc(int64_t c) {
  800122:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  800124:	4579                	li	a0,30
  800126:	bf4d                	j	8000d8 <syscall>

0000000000800128 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  800128:	1141                	addi	sp,sp,-16
  80012a:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  80012c:	fe5ff0ef          	jal	ra,800110 <sys_exit>
    cprintf("BUG: exit failed.\n");
  800130:	00000517          	auipc	a0,0x0
  800134:	68050513          	addi	a0,a0,1664 # 8007b0 <main+0xd4>
  800138:	f6bff0ef          	jal	ra,8000a2 <cprintf>
    while (1);
  80013c:	a001                	j	80013c <exit+0x14>

000000000080013e <fork>:
}

int
fork(void) {
    return sys_fork();
  80013e:	bfe1                	j	800116 <sys_fork>

0000000000800140 <wait>:
}

int
wait(void) {
    return sys_wait(0, NULL);
  800140:	4581                	li	a1,0
  800142:	4501                	li	a0,0
  800144:	bfd9                	j	80011a <sys_wait>

0000000000800146 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  800146:	1141                	addi	sp,sp,-16
  800148:	e406                	sd	ra,8(sp)
    int ret = main();
  80014a:	592000ef          	jal	ra,8006dc <main>
    exit(ret);
  80014e:	fdbff0ef          	jal	ra,800128 <exit>

0000000000800152 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  800152:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800156:	7139                	addi	sp,sp,-64
    unsigned mod = do_div(result, base);
  800158:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  80015c:	e852                	sd	s4,16(sp)
    unsigned mod = do_div(result, base);
  80015e:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  800162:	f426                	sd	s1,40(sp)
  800164:	f04a                	sd	s2,32(sp)
  800166:	ec4e                	sd	s3,24(sp)
  800168:	fc06                	sd	ra,56(sp)
  80016a:	f822                	sd	s0,48(sp)
  80016c:	e456                	sd	s5,8(sp)
  80016e:	e05a                	sd	s6,0(sp)
  800170:	84aa                	mv	s1,a0
  800172:	892e                	mv	s2,a1
  800174:	89be                	mv	s3,a5
    unsigned mod = do_div(result, base);
  800176:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  800178:	05067163          	bgeu	a2,a6,8001ba <printnum+0x68>
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  80017c:	fff7041b          	addiw	s0,a4,-1
  800180:	00805763          	blez	s0,80018e <printnum+0x3c>
  800184:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800186:	85ca                	mv	a1,s2
  800188:	854e                	mv	a0,s3
  80018a:	9482                	jalr	s1
        while (-- width > 0)
  80018c:	fc65                	bnez	s0,800184 <printnum+0x32>
  80018e:	00000417          	auipc	s0,0x0
  800192:	63a40413          	addi	s0,s0,1594 # 8007c8 <main+0xec>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  800196:	1a02                	slli	s4,s4,0x20
  800198:	020a5a13          	srli	s4,s4,0x20
  80019c:	9452                	add	s0,s0,s4
  80019e:	00044503          	lbu	a0,0(s0)
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  8001a2:	7442                	ld	s0,48(sp)
  8001a4:	70e2                	ld	ra,56(sp)
  8001a6:	69e2                	ld	s3,24(sp)
  8001a8:	6a42                	ld	s4,16(sp)
  8001aa:	6aa2                	ld	s5,8(sp)
  8001ac:	6b02                	ld	s6,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001ae:	85ca                	mv	a1,s2
  8001b0:	87a6                	mv	a5,s1
}
  8001b2:	7902                	ld	s2,32(sp)
  8001b4:	74a2                	ld	s1,40(sp)
  8001b6:	6121                	addi	sp,sp,64
    putch("0123456789abcdef"[mod], putdat);
  8001b8:	8782                	jr	a5
    unsigned mod = do_div(result, base);
  8001ba:	03065633          	divu	a2,a2,a6
  8001be:	03067ab3          	remu	s5,a2,a6
  8001c2:	2a81                	sext.w	s5,s5
    if (num >= base) {
  8001c4:	03067863          	bgeu	a2,a6,8001f4 <printnum+0xa2>
        while (-- width > 0)
  8001c8:	ffe7041b          	addiw	s0,a4,-2
  8001cc:	00805763          	blez	s0,8001da <printnum+0x88>
  8001d0:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  8001d2:	85ca                	mv	a1,s2
  8001d4:	854e                	mv	a0,s3
  8001d6:	9482                	jalr	s1
        while (-- width > 0)
  8001d8:	fc65                	bnez	s0,8001d0 <printnum+0x7e>
  8001da:	00000417          	auipc	s0,0x0
  8001de:	5ee40413          	addi	s0,s0,1518 # 8007c8 <main+0xec>
    putch("0123456789abcdef"[mod], putdat);
  8001e2:	1a82                	slli	s5,s5,0x20
  8001e4:	020ada93          	srli	s5,s5,0x20
  8001e8:	9aa2                	add	s5,s5,s0
  8001ea:	000ac503          	lbu	a0,0(s5)
  8001ee:	85ca                	mv	a1,s2
  8001f0:	9482                	jalr	s1
}
  8001f2:	b755                	j	800196 <printnum+0x44>
    unsigned mod = do_div(result, base);
  8001f4:	03065633          	divu	a2,a2,a6
        while (-- width > 0)
  8001f8:	ffd7041b          	addiw	s0,a4,-3
    unsigned mod = do_div(result, base);
  8001fc:	03067b33          	remu	s6,a2,a6
  800200:	2b01                	sext.w	s6,s6
    if (num >= base) {
  800202:	03067663          	bgeu	a2,a6,80022e <printnum+0xdc>
        while (-- width > 0)
  800206:	00805763          	blez	s0,800214 <printnum+0xc2>
  80020a:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  80020c:	85ca                	mv	a1,s2
  80020e:	854e                	mv	a0,s3
  800210:	9482                	jalr	s1
        while (-- width > 0)
  800212:	fc65                	bnez	s0,80020a <printnum+0xb8>
    putch("0123456789abcdef"[mod], putdat);
  800214:	1b02                	slli	s6,s6,0x20
  800216:	00000417          	auipc	s0,0x0
  80021a:	5b240413          	addi	s0,s0,1458 # 8007c8 <main+0xec>
  80021e:	020b5b13          	srli	s6,s6,0x20
  800222:	9b22                	add	s6,s6,s0
  800224:	000b4503          	lbu	a0,0(s6)
  800228:	85ca                	mv	a1,s2
  80022a:	9482                	jalr	s1
}
  80022c:	bf5d                	j	8001e2 <printnum+0x90>
        printnum(putch, putdat, result, base, width - 1, padc);
  80022e:	03065633          	divu	a2,a2,a6
  800232:	8722                	mv	a4,s0
  800234:	f1fff0ef          	jal	ra,800152 <printnum>
  800238:	bff1                	j	800214 <printnum+0xc2>

000000000080023a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  80023a:	7119                	addi	sp,sp,-128
  80023c:	f4a6                	sd	s1,104(sp)
  80023e:	f0ca                	sd	s2,96(sp)
  800240:	ecce                	sd	s3,88(sp)
  800242:	e8d2                	sd	s4,80(sp)
  800244:	e4d6                	sd	s5,72(sp)
  800246:	e0da                	sd	s6,64(sp)
  800248:	fc5e                	sd	s7,56(sp)
  80024a:	f466                	sd	s9,40(sp)
  80024c:	fc86                	sd	ra,120(sp)
  80024e:	f8a2                	sd	s0,112(sp)
  800250:	f862                	sd	s8,48(sp)
  800252:	f06a                	sd	s10,32(sp)
  800254:	ec6e                	sd	s11,24(sp)
  800256:	892a                	mv	s2,a0
  800258:	84ae                	mv	s1,a1
  80025a:	8cb2                	mv	s9,a2
  80025c:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80025e:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  800262:	5bfd                	li	s7,-1
  800264:	00000a97          	auipc	s5,0x0
  800268:	598a8a93          	addi	s5,s5,1432 # 8007fc <main+0x120>
    putch("0123456789abcdef"[mod], putdat);
  80026c:	00000b17          	auipc	s6,0x0
  800270:	55cb0b13          	addi	s6,s6,1372 # 8007c8 <main+0xec>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800274:	000cc503          	lbu	a0,0(s9)
  800278:	001c8413          	addi	s0,s9,1
  80027c:	01350a63          	beq	a0,s3,800290 <vprintfmt+0x56>
            if (ch == '\0') {
  800280:	c121                	beqz	a0,8002c0 <vprintfmt+0x86>
            putch(ch, putdat);
  800282:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800284:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  800286:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800288:	fff44503          	lbu	a0,-1(s0)
  80028c:	ff351ae3          	bne	a0,s3,800280 <vprintfmt+0x46>
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  800290:	00044683          	lbu	a3,0(s0)
        char padc = ' ';
  800294:	02000813          	li	a6,32
        lflag = altflag = 0;
  800298:	4d81                	li	s11,0
  80029a:	4501                	li	a0,0
        width = precision = -1;
  80029c:	5c7d                	li	s8,-1
  80029e:	5d7d                	li	s10,-1
  8002a0:	05500613          	li	a2,85
        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
  8002a4:	45a5                	li	a1,9
        switch (ch = *(unsigned char *)fmt ++) {
  8002a6:	fdd6879b          	addiw	a5,a3,-35
  8002aa:	0ff7f793          	zext.b	a5,a5
  8002ae:	00140c93          	addi	s9,s0,1
  8002b2:	04f66263          	bltu	a2,a5,8002f6 <vprintfmt+0xbc>
  8002b6:	078a                	slli	a5,a5,0x2
  8002b8:	97d6                	add	a5,a5,s5
  8002ba:	439c                	lw	a5,0(a5)
  8002bc:	97d6                	add	a5,a5,s5
  8002be:	8782                	jr	a5
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8002c0:	70e6                	ld	ra,120(sp)
  8002c2:	7446                	ld	s0,112(sp)
  8002c4:	74a6                	ld	s1,104(sp)
  8002c6:	7906                	ld	s2,96(sp)
  8002c8:	69e6                	ld	s3,88(sp)
  8002ca:	6a46                	ld	s4,80(sp)
  8002cc:	6aa6                	ld	s5,72(sp)
  8002ce:	6b06                	ld	s6,64(sp)
  8002d0:	7be2                	ld	s7,56(sp)
  8002d2:	7c42                	ld	s8,48(sp)
  8002d4:	7ca2                	ld	s9,40(sp)
  8002d6:	7d02                	ld	s10,32(sp)
  8002d8:	6de2                	ld	s11,24(sp)
  8002da:	6109                	addi	sp,sp,128
  8002dc:	8082                	ret
            padc = '0';
  8002de:	8836                	mv	a6,a3
            goto reswitch;
  8002e0:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  8002e4:	8466                	mv	s0,s9
  8002e6:	00140c93          	addi	s9,s0,1
  8002ea:	fdd6879b          	addiw	a5,a3,-35
  8002ee:	0ff7f793          	zext.b	a5,a5
  8002f2:	fcf672e3          	bgeu	a2,a5,8002b6 <vprintfmt+0x7c>
            putch('%', putdat);
  8002f6:	85a6                	mv	a1,s1
  8002f8:	02500513          	li	a0,37
  8002fc:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  8002fe:	fff44783          	lbu	a5,-1(s0)
  800302:	8ca2                	mv	s9,s0
  800304:	f73788e3          	beq	a5,s3,800274 <vprintfmt+0x3a>
  800308:	ffecc783          	lbu	a5,-2(s9)
  80030c:	1cfd                	addi	s9,s9,-1
  80030e:	ff379de3          	bne	a5,s3,800308 <vprintfmt+0xce>
  800312:	b78d                	j	800274 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  800314:	fd068c1b          	addiw	s8,a3,-48
                ch = *fmt;
  800318:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  80031c:	8466                	mv	s0,s9
                if (ch < '0' || ch > '9') {
  80031e:	fd06879b          	addiw	a5,a3,-48
                ch = *fmt;
  800322:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  800326:	02f5e563          	bltu	a1,a5,800350 <vprintfmt+0x116>
                ch = *fmt;
  80032a:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
  80032e:	002c179b          	slliw	a5,s8,0x2
  800332:	0187873b          	addw	a4,a5,s8
  800336:	0017171b          	slliw	a4,a4,0x1
  80033a:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
  80033e:	fd06879b          	addiw	a5,a3,-48
            for (precision = 0; ; ++ fmt) {
  800342:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  800344:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  800348:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  80034c:	fcf5ffe3          	bgeu	a1,a5,80032a <vprintfmt+0xf0>
            if (width < 0)
  800350:	f40d5be3          	bgez	s10,8002a6 <vprintfmt+0x6c>
                width = precision, precision = -1;
  800354:	8d62                	mv	s10,s8
  800356:	5c7d                	li	s8,-1
  800358:	b7b9                	j	8002a6 <vprintfmt+0x6c>
            if (width < 0)
  80035a:	fffd4793          	not	a5,s10
  80035e:	97fd                	srai	a5,a5,0x3f
  800360:	00fd7d33          	and	s10,s10,a5
        switch (ch = *(unsigned char *)fmt ++) {
  800364:	00144683          	lbu	a3,1(s0)
  800368:	2d01                	sext.w	s10,s10
  80036a:	8466                	mv	s0,s9
            goto reswitch;
  80036c:	bf2d                	j	8002a6 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  80036e:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  800372:	00144683          	lbu	a3,1(s0)
            precision = va_arg(ap, int);
  800376:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  800378:	8466                	mv	s0,s9
            goto process_precision;
  80037a:	bfd9                	j	800350 <vprintfmt+0x116>
    if (lflag >= 2) {
  80037c:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80037e:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800382:	00a7c463          	blt	a5,a0,80038a <vprintfmt+0x150>
    else if (lflag) {
  800386:	28050a63          	beqz	a0,80061a <vprintfmt+0x3e0>
        return va_arg(*ap, unsigned long);
  80038a:	000a3783          	ld	a5,0(s4)
  80038e:	4641                	li	a2,16
  800390:	8a3a                	mv	s4,a4
  800392:	46c1                	li	a3,16
    unsigned mod = do_div(result, base);
  800394:	02c7fdb3          	remu	s11,a5,a2
            printnum(putch, putdat, num, base, width, padc);
  800398:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  80039c:	0ac7f563          	bgeu	a5,a2,800446 <vprintfmt+0x20c>
        while (-- width > 0)
  8003a0:	3d7d                	addiw	s10,s10,-1
  8003a2:	01a05863          	blez	s10,8003b2 <vprintfmt+0x178>
  8003a6:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  8003a8:	85a6                	mv	a1,s1
  8003aa:	8562                	mv	a0,s8
  8003ac:	9902                	jalr	s2
        while (-- width > 0)
  8003ae:	fe0d1ce3          	bnez	s10,8003a6 <vprintfmt+0x16c>
    putch("0123456789abcdef"[mod], putdat);
  8003b2:	9dda                	add	s11,s11,s6
  8003b4:	000dc503          	lbu	a0,0(s11)
  8003b8:	85a6                	mv	a1,s1
  8003ba:	9902                	jalr	s2
}
  8003bc:	bd65                	j	800274 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  8003be:	000a2503          	lw	a0,0(s4)
  8003c2:	85a6                	mv	a1,s1
  8003c4:	0a21                	addi	s4,s4,8
  8003c6:	9902                	jalr	s2
            break;
  8003c8:	b575                	j	800274 <vprintfmt+0x3a>
    if (lflag >= 2) {
  8003ca:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8003cc:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  8003d0:	00a7c463          	blt	a5,a0,8003d8 <vprintfmt+0x19e>
    else if (lflag) {
  8003d4:	22050d63          	beqz	a0,80060e <vprintfmt+0x3d4>
        return va_arg(*ap, unsigned long);
  8003d8:	000a3783          	ld	a5,0(s4)
  8003dc:	4629                	li	a2,10
  8003de:	8a3a                	mv	s4,a4
  8003e0:	46a9                	li	a3,10
  8003e2:	bf4d                	j	800394 <vprintfmt+0x15a>
        switch (ch = *(unsigned char *)fmt ++) {
  8003e4:	00144683          	lbu	a3,1(s0)
            altflag = 1;
  8003e8:	4d85                	li	s11,1
        switch (ch = *(unsigned char *)fmt ++) {
  8003ea:	8466                	mv	s0,s9
            goto reswitch;
  8003ec:	bd6d                	j	8002a6 <vprintfmt+0x6c>
            putch(ch, putdat);
  8003ee:	85a6                	mv	a1,s1
  8003f0:	02500513          	li	a0,37
  8003f4:	9902                	jalr	s2
            break;
  8003f6:	bdbd                	j	800274 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  8003f8:	00144683          	lbu	a3,1(s0)
            lflag ++;
  8003fc:	2505                	addiw	a0,a0,1
        switch (ch = *(unsigned char *)fmt ++) {
  8003fe:	8466                	mv	s0,s9
            goto reswitch;
  800400:	b55d                	j	8002a6 <vprintfmt+0x6c>
    if (lflag >= 2) {
  800402:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800404:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800408:	00a7c463          	blt	a5,a0,800410 <vprintfmt+0x1d6>
    else if (lflag) {
  80040c:	1e050b63          	beqz	a0,800602 <vprintfmt+0x3c8>
        return va_arg(*ap, unsigned long);
  800410:	000a3783          	ld	a5,0(s4)
  800414:	4621                	li	a2,8
  800416:	8a3a                	mv	s4,a4
  800418:	46a1                	li	a3,8
  80041a:	bfad                	j	800394 <vprintfmt+0x15a>
            putch('0', putdat);
  80041c:	03000513          	li	a0,48
  800420:	85a6                	mv	a1,s1
  800422:	e042                	sd	a6,0(sp)
  800424:	9902                	jalr	s2
            putch('x', putdat);
  800426:	85a6                	mv	a1,s1
  800428:	07800513          	li	a0,120
  80042c:	9902                	jalr	s2
            goto number;
  80042e:	6802                	ld	a6,0(sp)
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800430:	000a3783          	ld	a5,0(s4)
            goto number;
  800434:	4641                	li	a2,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800436:	0a21                	addi	s4,s4,8
    unsigned mod = do_div(result, base);
  800438:	02c7fdb3          	remu	s11,a5,a2
            goto number;
  80043c:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
  80043e:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  800442:	f4c7efe3          	bltu	a5,a2,8003a0 <vprintfmt+0x166>
        while (-- width > 0)
  800446:	3d79                	addiw	s10,s10,-2
    unsigned mod = do_div(result, base);
  800448:	02c7d7b3          	divu	a5,a5,a2
  80044c:	02c7f433          	remu	s0,a5,a2
    if (num >= base) {
  800450:	10c7f463          	bgeu	a5,a2,800558 <vprintfmt+0x31e>
        while (-- width > 0)
  800454:	01a05863          	blez	s10,800464 <vprintfmt+0x22a>
  800458:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  80045a:	85a6                	mv	a1,s1
  80045c:	8562                	mv	a0,s8
  80045e:	9902                	jalr	s2
        while (-- width > 0)
  800460:	fe0d1ce3          	bnez	s10,800458 <vprintfmt+0x21e>
    putch("0123456789abcdef"[mod], putdat);
  800464:	945a                	add	s0,s0,s6
  800466:	00044503          	lbu	a0,0(s0)
  80046a:	85a6                	mv	a1,s1
  80046c:	9dda                	add	s11,s11,s6
  80046e:	9902                	jalr	s2
  800470:	000dc503          	lbu	a0,0(s11)
  800474:	85a6                	mv	a1,s1
  800476:	9902                	jalr	s2
  800478:	bbf5                	j	800274 <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
  80047a:	000a3403          	ld	s0,0(s4)
  80047e:	008a0793          	addi	a5,s4,8
  800482:	e43e                	sd	a5,8(sp)
  800484:	1e040563          	beqz	s0,80066e <vprintfmt+0x434>
            if (width > 0 && padc != '-') {
  800488:	15a05263          	blez	s10,8005cc <vprintfmt+0x392>
  80048c:	02d00793          	li	a5,45
  800490:	10f81b63          	bne	a6,a5,8005a6 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800494:	00044783          	lbu	a5,0(s0)
  800498:	0007851b          	sext.w	a0,a5
  80049c:	0e078c63          	beqz	a5,800594 <vprintfmt+0x35a>
  8004a0:	0405                	addi	s0,s0,1
  8004a2:	120d8e63          	beqz	s11,8005de <vprintfmt+0x3a4>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004a6:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004aa:	020c4963          	bltz	s8,8004dc <vprintfmt+0x2a2>
  8004ae:	fffc0a1b          	addiw	s4,s8,-1
  8004b2:	0d7a0f63          	beq	s4,s7,800590 <vprintfmt+0x356>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004b6:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  8004b8:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8004ba:	02fdf663          	bgeu	s11,a5,8004e6 <vprintfmt+0x2ac>
                    putch('?', putdat);
  8004be:	03f00513          	li	a0,63
  8004c2:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004c4:	00044783          	lbu	a5,0(s0)
  8004c8:	3d7d                	addiw	s10,s10,-1
  8004ca:	0405                	addi	s0,s0,1
  8004cc:	0007851b          	sext.w	a0,a5
  8004d0:	c3e1                	beqz	a5,800590 <vprintfmt+0x356>
  8004d2:	140c4a63          	bltz	s8,800626 <vprintfmt+0x3ec>
  8004d6:	8c52                	mv	s8,s4
  8004d8:	fc0c5be3          	bgez	s8,8004ae <vprintfmt+0x274>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004dc:	3781                	addiw	a5,a5,-32
  8004de:	8a62                	mv	s4,s8
                    putch('?', putdat);
  8004e0:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8004e2:	fcfdeee3          	bltu	s11,a5,8004be <vprintfmt+0x284>
                    putch(ch, putdat);
  8004e6:	9902                	jalr	s2
  8004e8:	bff1                	j	8004c4 <vprintfmt+0x28a>
    if (lflag >= 2) {
  8004ea:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8004ec:	008a0d93          	addi	s11,s4,8
    if (lflag >= 2) {
  8004f0:	00a7c463          	blt	a5,a0,8004f8 <vprintfmt+0x2be>
    else if (lflag) {
  8004f4:	10050463          	beqz	a0,8005fc <vprintfmt+0x3c2>
        return va_arg(*ap, long);
  8004f8:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  8004fc:	14044d63          	bltz	s0,800656 <vprintfmt+0x41c>
            num = getint(&ap, lflag);
  800500:	87a2                	mv	a5,s0
  800502:	8a6e                	mv	s4,s11
  800504:	4629                	li	a2,10
  800506:	46a9                	li	a3,10
  800508:	b571                	j	800394 <vprintfmt+0x15a>
            err = va_arg(ap, int);
  80050a:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80050e:	4761                	li	a4,24
            err = va_arg(ap, int);
  800510:	0a21                	addi	s4,s4,8
            if (err < 0) {
  800512:	41f7d69b          	sraiw	a3,a5,0x1f
  800516:	8fb5                	xor	a5,a5,a3
  800518:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80051c:	02d74563          	blt	a4,a3,800546 <vprintfmt+0x30c>
  800520:	00369713          	slli	a4,a3,0x3
  800524:	00000797          	auipc	a5,0x0
  800528:	4f478793          	addi	a5,a5,1268 # 800a18 <error_string>
  80052c:	97ba                	add	a5,a5,a4
  80052e:	639c                	ld	a5,0(a5)
  800530:	cb99                	beqz	a5,800546 <vprintfmt+0x30c>
                printfmt(putch, putdat, "%s", p);
  800532:	86be                	mv	a3,a5
  800534:	00000617          	auipc	a2,0x0
  800538:	2c460613          	addi	a2,a2,708 # 8007f8 <main+0x11c>
  80053c:	85a6                	mv	a1,s1
  80053e:	854a                	mv	a0,s2
  800540:	160000ef          	jal	ra,8006a0 <printfmt>
  800544:	bb05                	j	800274 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  800546:	00000617          	auipc	a2,0x0
  80054a:	2a260613          	addi	a2,a2,674 # 8007e8 <main+0x10c>
  80054e:	85a6                	mv	a1,s1
  800550:	854a                	mv	a0,s2
  800552:	14e000ef          	jal	ra,8006a0 <printfmt>
  800556:	bb39                	j	800274 <vprintfmt+0x3a>
        printnum(putch, putdat, result, base, width - 1, padc);
  800558:	02c7d633          	divu	a2,a5,a2
  80055c:	876a                	mv	a4,s10
  80055e:	87e2                	mv	a5,s8
  800560:	85a6                	mv	a1,s1
  800562:	854a                	mv	a0,s2
  800564:	befff0ef          	jal	ra,800152 <printnum>
  800568:	bdf5                	j	800464 <vprintfmt+0x22a>
                    putch(ch, putdat);
  80056a:	85a6                	mv	a1,s1
  80056c:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80056e:	00044503          	lbu	a0,0(s0)
  800572:	3d7d                	addiw	s10,s10,-1
  800574:	0405                	addi	s0,s0,1
  800576:	cd09                	beqz	a0,800590 <vprintfmt+0x356>
  800578:	008d0d3b          	addw	s10,s10,s0
  80057c:	fffd0d9b          	addiw	s11,s10,-1
                    putch(ch, putdat);
  800580:	85a6                	mv	a1,s1
  800582:	408d8d3b          	subw	s10,s11,s0
  800586:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800588:	00044503          	lbu	a0,0(s0)
  80058c:	0405                	addi	s0,s0,1
  80058e:	f96d                	bnez	a0,800580 <vprintfmt+0x346>
            for (; width > 0; width --) {
  800590:	01a05963          	blez	s10,8005a2 <vprintfmt+0x368>
  800594:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
  800596:	85a6                	mv	a1,s1
  800598:	02000513          	li	a0,32
  80059c:	9902                	jalr	s2
            for (; width > 0; width --) {
  80059e:	fe0d1be3          	bnez	s10,800594 <vprintfmt+0x35a>
            if ((p = va_arg(ap, char *)) == NULL) {
  8005a2:	6a22                	ld	s4,8(sp)
  8005a4:	b9c1                	j	800274 <vprintfmt+0x3a>
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005a6:	85e2                	mv	a1,s8
  8005a8:	8522                	mv	a0,s0
  8005aa:	e042                	sd	a6,0(sp)
  8005ac:	114000ef          	jal	ra,8006c0 <strnlen>
  8005b0:	40ad0d3b          	subw	s10,s10,a0
  8005b4:	01a05c63          	blez	s10,8005cc <vprintfmt+0x392>
                    putch(padc, putdat);
  8005b8:	6802                	ld	a6,0(sp)
  8005ba:	0008051b          	sext.w	a0,a6
  8005be:	85a6                	mv	a1,s1
  8005c0:	e02a                	sd	a0,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005c2:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
  8005c4:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005c6:	6502                	ld	a0,0(sp)
  8005c8:	fe0d1be3          	bnez	s10,8005be <vprintfmt+0x384>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005cc:	00044783          	lbu	a5,0(s0)
  8005d0:	0405                	addi	s0,s0,1
  8005d2:	0007851b          	sext.w	a0,a5
  8005d6:	ec0796e3          	bnez	a5,8004a2 <vprintfmt+0x268>
            if ((p = va_arg(ap, char *)) == NULL) {
  8005da:	6a22                	ld	s4,8(sp)
  8005dc:	b961                	j	800274 <vprintfmt+0x3a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005de:	f80c46e3          	bltz	s8,80056a <vprintfmt+0x330>
  8005e2:	3c7d                	addiw	s8,s8,-1
  8005e4:	fb7c06e3          	beq	s8,s7,800590 <vprintfmt+0x356>
                    putch(ch, putdat);
  8005e8:	85a6                	mv	a1,s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005ea:	0405                	addi	s0,s0,1
                    putch(ch, putdat);
  8005ec:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005ee:	fff44503          	lbu	a0,-1(s0)
  8005f2:	3d7d                	addiw	s10,s10,-1
  8005f4:	f56d                	bnez	a0,8005de <vprintfmt+0x3a4>
            for (; width > 0; width --) {
  8005f6:	f9a04fe3          	bgtz	s10,800594 <vprintfmt+0x35a>
  8005fa:	b765                	j	8005a2 <vprintfmt+0x368>
        return va_arg(*ap, int);
  8005fc:	000a2403          	lw	s0,0(s4)
  800600:	bdf5                	j	8004fc <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned int);
  800602:	000a6783          	lwu	a5,0(s4)
  800606:	4621                	li	a2,8
  800608:	8a3a                	mv	s4,a4
  80060a:	46a1                	li	a3,8
  80060c:	b361                	j	800394 <vprintfmt+0x15a>
  80060e:	000a6783          	lwu	a5,0(s4)
  800612:	4629                	li	a2,10
  800614:	8a3a                	mv	s4,a4
  800616:	46a9                	li	a3,10
  800618:	bbb5                	j	800394 <vprintfmt+0x15a>
  80061a:	000a6783          	lwu	a5,0(s4)
  80061e:	4641                	li	a2,16
  800620:	8a3a                	mv	s4,a4
  800622:	46c1                	li	a3,16
  800624:	bb85                	j	800394 <vprintfmt+0x15a>
  800626:	01a40d3b          	addw	s10,s0,s10
                if (altflag && (ch < ' ' || ch > '~')) {
  80062a:	05e00d93          	li	s11,94
  80062e:	3d7d                	addiw	s10,s10,-1
  800630:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  800632:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800634:	00fdf463          	bgeu	s11,a5,80063c <vprintfmt+0x402>
                    putch('?', putdat);
  800638:	03f00513          	li	a0,63
  80063c:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80063e:	00044783          	lbu	a5,0(s0)
  800642:	408d073b          	subw	a4,s10,s0
  800646:	0405                	addi	s0,s0,1
  800648:	0007851b          	sext.w	a0,a5
  80064c:	f3f5                	bnez	a5,800630 <vprintfmt+0x3f6>
  80064e:	8d3a                	mv	s10,a4
            for (; width > 0; width --) {
  800650:	f5a042e3          	bgtz	s10,800594 <vprintfmt+0x35a>
  800654:	b7b9                	j	8005a2 <vprintfmt+0x368>
                putch('-', putdat);
  800656:	85a6                	mv	a1,s1
  800658:	02d00513          	li	a0,45
  80065c:	e042                	sd	a6,0(sp)
  80065e:	9902                	jalr	s2
                num = -(long long)num;
  800660:	6802                	ld	a6,0(sp)
  800662:	8a6e                	mv	s4,s11
  800664:	408007b3          	neg	a5,s0
  800668:	4629                	li	a2,10
  80066a:	46a9                	li	a3,10
  80066c:	b325                	j	800394 <vprintfmt+0x15a>
            if (width > 0 && padc != '-') {
  80066e:	03a05063          	blez	s10,80068e <vprintfmt+0x454>
  800672:	02d00793          	li	a5,45
                p = "(null)";
  800676:	00000417          	auipc	s0,0x0
  80067a:	16a40413          	addi	s0,s0,362 # 8007e0 <main+0x104>
            if (width > 0 && padc != '-') {
  80067e:	f2f814e3          	bne	a6,a5,8005a6 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800682:	02800793          	li	a5,40
  800686:	02800513          	li	a0,40
  80068a:	0405                	addi	s0,s0,1
  80068c:	bd19                	j	8004a2 <vprintfmt+0x268>
  80068e:	02800513          	li	a0,40
  800692:	02800793          	li	a5,40
  800696:	00000417          	auipc	s0,0x0
  80069a:	14b40413          	addi	s0,s0,331 # 8007e1 <main+0x105>
  80069e:	b511                	j	8004a2 <vprintfmt+0x268>

00000000008006a0 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006a0:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  8006a2:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006a6:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8006a8:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006aa:	ec06                	sd	ra,24(sp)
  8006ac:	f83a                	sd	a4,48(sp)
  8006ae:	fc3e                	sd	a5,56(sp)
  8006b0:	e0c2                	sd	a6,64(sp)
  8006b2:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8006b4:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8006b6:	b85ff0ef          	jal	ra,80023a <vprintfmt>
}
  8006ba:	60e2                	ld	ra,24(sp)
  8006bc:	6161                	addi	sp,sp,80
  8006be:	8082                	ret

00000000008006c0 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  8006c0:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  8006c2:	e589                	bnez	a1,8006cc <strnlen+0xc>
  8006c4:	a811                	j	8006d8 <strnlen+0x18>
        cnt ++;
  8006c6:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  8006c8:	00f58863          	beq	a1,a5,8006d8 <strnlen+0x18>
  8006cc:	00f50733          	add	a4,a0,a5
  8006d0:	00074703          	lbu	a4,0(a4)
  8006d4:	fb6d                	bnez	a4,8006c6 <strnlen+0x6>
  8006d6:	85be                	mv	a1,a5
    }
    return cnt;
}
  8006d8:	852e                	mv	a0,a1
  8006da:	8082                	ret

00000000008006dc <main>:
#include <stdio.h>

const int max_child = 32;

int
main(void) {
  8006dc:	1101                	addi	sp,sp,-32
  8006de:	e822                	sd	s0,16(sp)
  8006e0:	e426                	sd	s1,8(sp)
  8006e2:	ec06                	sd	ra,24(sp)
    int n, pid;
    for (n = 0; n < max_child; n ++) {
  8006e4:	4401                	li	s0,0
  8006e6:	02000493          	li	s1,32
        if ((pid = fork()) == 0) {
  8006ea:	a55ff0ef          	jal	ra,80013e <fork>
  8006ee:	cd05                	beqz	a0,800726 <main+0x4a>
            cprintf("I am child %d\n", n);
            exit(0);
        }
        assert(pid > 0);
  8006f0:	06a05063          	blez	a0,800750 <main+0x74>
    for (n = 0; n < max_child; n ++) {
  8006f4:	2405                	addiw	s0,s0,1
  8006f6:	fe941ae3          	bne	s0,s1,8006ea <main+0xe>
  8006fa:	02000413          	li	s0,32
    if (n > max_child) {
        panic("fork claimed to work %d times!\n", n);
    }

    for (; n > 0; n --) {
        if (wait() != 0) {
  8006fe:	a43ff0ef          	jal	ra,800140 <wait>
  800702:	ed05                	bnez	a0,80073a <main+0x5e>
    for (; n > 0; n --) {
  800704:	347d                	addiw	s0,s0,-1
  800706:	fc65                	bnez	s0,8006fe <main+0x22>
            panic("wait stopped early\n");
        }
    }

    if (wait() == 0) {
  800708:	a39ff0ef          	jal	ra,800140 <wait>
  80070c:	c12d                	beqz	a0,80076e <main+0x92>
        panic("wait got too many\n");
    }

    cprintf("forktest pass.\n");
  80070e:	00000517          	auipc	a0,0x0
  800712:	44250513          	addi	a0,a0,1090 # 800b50 <error_string+0x138>
  800716:	98dff0ef          	jal	ra,8000a2 <cprintf>
    return 0;
}
  80071a:	60e2                	ld	ra,24(sp)
  80071c:	6442                	ld	s0,16(sp)
  80071e:	64a2                	ld	s1,8(sp)
  800720:	4501                	li	a0,0
  800722:	6105                	addi	sp,sp,32
  800724:	8082                	ret
            cprintf("I am child %d\n", n);
  800726:	85a2                	mv	a1,s0
  800728:	00000517          	auipc	a0,0x0
  80072c:	3b850513          	addi	a0,a0,952 # 800ae0 <error_string+0xc8>
  800730:	973ff0ef          	jal	ra,8000a2 <cprintf>
            exit(0);
  800734:	4501                	li	a0,0
  800736:	9f3ff0ef          	jal	ra,800128 <exit>
            panic("wait stopped early\n");
  80073a:	00000617          	auipc	a2,0x0
  80073e:	3e660613          	addi	a2,a2,998 # 800b20 <error_string+0x108>
  800742:	45dd                	li	a1,23
  800744:	00000517          	auipc	a0,0x0
  800748:	3cc50513          	addi	a0,a0,972 # 800b10 <error_string+0xf8>
  80074c:	8dbff0ef          	jal	ra,800026 <__panic>
        assert(pid > 0);
  800750:	00000697          	auipc	a3,0x0
  800754:	3a068693          	addi	a3,a3,928 # 800af0 <error_string+0xd8>
  800758:	00000617          	auipc	a2,0x0
  80075c:	3a060613          	addi	a2,a2,928 # 800af8 <error_string+0xe0>
  800760:	45b9                	li	a1,14
  800762:	00000517          	auipc	a0,0x0
  800766:	3ae50513          	addi	a0,a0,942 # 800b10 <error_string+0xf8>
  80076a:	8bdff0ef          	jal	ra,800026 <__panic>
        panic("wait got too many\n");
  80076e:	00000617          	auipc	a2,0x0
  800772:	3ca60613          	addi	a2,a2,970 # 800b38 <error_string+0x120>
  800776:	45f1                	li	a1,28
  800778:	00000517          	auipc	a0,0x0
  80077c:	39850513          	addi	a0,a0,920 # 800b10 <error_string+0xf8>
  800780:	8a7ff0ef          	jal	ra,800026 <__panic>
