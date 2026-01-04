
obj/__user_matrix.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	13a000ef          	jal	ra,80015a <umain>
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
  80003a:	52250513          	addi	a0,a0,1314 # 801558 <main+0xc8>
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
  800056:	00002517          	auipc	a0,0x2
  80005a:	88a50513          	addi	a0,a0,-1910 # 8018e0 <error_string+0x100>
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
  800096:	1b8000ef          	jal	ra,80024e <vprintfmt>
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
  8000cc:	182000ef          	jal	ra,80024e <vprintfmt>
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
  80013e:	00001517          	auipc	a0,0x1
  800142:	43a50513          	addi	a0,a0,1082 # 801578 <main+0xe8>
  800146:	f5dff0ef          	jal	ra,8000a2 <cprintf>
    while (1);
  80014a:	a001                	j	80014a <exit+0x14>

000000000080014c <fork>:
}

int
fork(void) {
    return sys_fork();
  80014c:	b7e9                	j	800116 <sys_fork>

000000000080014e <wait>:
}

int
wait(void) {
    return sys_wait(0, NULL);
  80014e:	4581                	li	a1,0
  800150:	4501                	li	a0,0
  800152:	b7e1                	j	80011a <sys_wait>

0000000000800154 <yield>:
    return sys_wait(pid, store);
}

void
yield(void) {
    sys_yield();
  800154:	b7f9                	j	800122 <sys_yield>

0000000000800156 <kill>:
}

int
kill(int pid) {
    return sys_kill(pid);
  800156:	bfc1                	j	800126 <sys_kill>

0000000000800158 <getpid>:
}

int
getpid(void) {
    return sys_getpid();
  800158:	bfd1                	j	80012c <sys_getpid>

000000000080015a <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  80015a:	1141                	addi	sp,sp,-16
  80015c:	e406                	sd	ra,8(sp)
    int ret = main();
  80015e:	332010ef          	jal	ra,801490 <main>
    exit(ret);
  800162:	fd5ff0ef          	jal	ra,800136 <exit>

0000000000800166 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  800166:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  80016a:	7139                	addi	sp,sp,-64
    unsigned mod = do_div(result, base);
  80016c:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800170:	e852                	sd	s4,16(sp)
    unsigned mod = do_div(result, base);
  800172:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  800176:	f426                	sd	s1,40(sp)
  800178:	f04a                	sd	s2,32(sp)
  80017a:	ec4e                	sd	s3,24(sp)
  80017c:	fc06                	sd	ra,56(sp)
  80017e:	f822                	sd	s0,48(sp)
  800180:	e456                	sd	s5,8(sp)
  800182:	e05a                	sd	s6,0(sp)
  800184:	84aa                	mv	s1,a0
  800186:	892e                	mv	s2,a1
  800188:	89be                	mv	s3,a5
    unsigned mod = do_div(result, base);
  80018a:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  80018c:	05067163          	bgeu	a2,a6,8001ce <printnum+0x68>
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800190:	fff7041b          	addiw	s0,a4,-1
  800194:	00805763          	blez	s0,8001a2 <printnum+0x3c>
  800198:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  80019a:	85ca                	mv	a1,s2
  80019c:	854e                	mv	a0,s3
  80019e:	9482                	jalr	s1
        while (-- width > 0)
  8001a0:	fc65                	bnez	s0,800198 <printnum+0x32>
  8001a2:	00001417          	auipc	s0,0x1
  8001a6:	3ee40413          	addi	s0,s0,1006 # 801590 <main+0x100>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  8001aa:	1a02                	slli	s4,s4,0x20
  8001ac:	020a5a13          	srli	s4,s4,0x20
  8001b0:	9452                	add	s0,s0,s4
  8001b2:	00044503          	lbu	a0,0(s0)
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  8001b6:	7442                	ld	s0,48(sp)
  8001b8:	70e2                	ld	ra,56(sp)
  8001ba:	69e2                	ld	s3,24(sp)
  8001bc:	6a42                	ld	s4,16(sp)
  8001be:	6aa2                	ld	s5,8(sp)
  8001c0:	6b02                	ld	s6,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001c2:	85ca                	mv	a1,s2
  8001c4:	87a6                	mv	a5,s1
}
  8001c6:	7902                	ld	s2,32(sp)
  8001c8:	74a2                	ld	s1,40(sp)
  8001ca:	6121                	addi	sp,sp,64
    putch("0123456789abcdef"[mod], putdat);
  8001cc:	8782                	jr	a5
    unsigned mod = do_div(result, base);
  8001ce:	03065633          	divu	a2,a2,a6
  8001d2:	03067ab3          	remu	s5,a2,a6
  8001d6:	2a81                	sext.w	s5,s5
    if (num >= base) {
  8001d8:	03067863          	bgeu	a2,a6,800208 <printnum+0xa2>
        while (-- width > 0)
  8001dc:	ffe7041b          	addiw	s0,a4,-2
  8001e0:	00805763          	blez	s0,8001ee <printnum+0x88>
  8001e4:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  8001e6:	85ca                	mv	a1,s2
  8001e8:	854e                	mv	a0,s3
  8001ea:	9482                	jalr	s1
        while (-- width > 0)
  8001ec:	fc65                	bnez	s0,8001e4 <printnum+0x7e>
  8001ee:	00001417          	auipc	s0,0x1
  8001f2:	3a240413          	addi	s0,s0,930 # 801590 <main+0x100>
    putch("0123456789abcdef"[mod], putdat);
  8001f6:	1a82                	slli	s5,s5,0x20
  8001f8:	020ada93          	srli	s5,s5,0x20
  8001fc:	9aa2                	add	s5,s5,s0
  8001fe:	000ac503          	lbu	a0,0(s5)
  800202:	85ca                	mv	a1,s2
  800204:	9482                	jalr	s1
}
  800206:	b755                	j	8001aa <printnum+0x44>
    unsigned mod = do_div(result, base);
  800208:	03065633          	divu	a2,a2,a6
        while (-- width > 0)
  80020c:	ffd7041b          	addiw	s0,a4,-3
    unsigned mod = do_div(result, base);
  800210:	03067b33          	remu	s6,a2,a6
  800214:	2b01                	sext.w	s6,s6
    if (num >= base) {
  800216:	03067663          	bgeu	a2,a6,800242 <printnum+0xdc>
        while (-- width > 0)
  80021a:	00805763          	blez	s0,800228 <printnum+0xc2>
  80021e:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800220:	85ca                	mv	a1,s2
  800222:	854e                	mv	a0,s3
  800224:	9482                	jalr	s1
        while (-- width > 0)
  800226:	fc65                	bnez	s0,80021e <printnum+0xb8>
    putch("0123456789abcdef"[mod], putdat);
  800228:	1b02                	slli	s6,s6,0x20
  80022a:	00001417          	auipc	s0,0x1
  80022e:	36640413          	addi	s0,s0,870 # 801590 <main+0x100>
  800232:	020b5b13          	srli	s6,s6,0x20
  800236:	9b22                	add	s6,s6,s0
  800238:	000b4503          	lbu	a0,0(s6)
  80023c:	85ca                	mv	a1,s2
  80023e:	9482                	jalr	s1
}
  800240:	bf5d                	j	8001f6 <printnum+0x90>
        printnum(putch, putdat, result, base, width - 1, padc);
  800242:	03065633          	divu	a2,a2,a6
  800246:	8722                	mv	a4,s0
  800248:	f1fff0ef          	jal	ra,800166 <printnum>
  80024c:	bff1                	j	800228 <printnum+0xc2>

000000000080024e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  80024e:	7119                	addi	sp,sp,-128
  800250:	f4a6                	sd	s1,104(sp)
  800252:	f0ca                	sd	s2,96(sp)
  800254:	ecce                	sd	s3,88(sp)
  800256:	e8d2                	sd	s4,80(sp)
  800258:	e4d6                	sd	s5,72(sp)
  80025a:	e0da                	sd	s6,64(sp)
  80025c:	fc5e                	sd	s7,56(sp)
  80025e:	f466                	sd	s9,40(sp)
  800260:	fc86                	sd	ra,120(sp)
  800262:	f8a2                	sd	s0,112(sp)
  800264:	f862                	sd	s8,48(sp)
  800266:	f06a                	sd	s10,32(sp)
  800268:	ec6e                	sd	s11,24(sp)
  80026a:	892a                	mv	s2,a0
  80026c:	84ae                	mv	s1,a1
  80026e:	8cb2                	mv	s9,a2
  800270:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800272:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  800276:	5bfd                	li	s7,-1
  800278:	00001a97          	auipc	s5,0x1
  80027c:	34ca8a93          	addi	s5,s5,844 # 8015c4 <main+0x134>
    putch("0123456789abcdef"[mod], putdat);
  800280:	00001b17          	auipc	s6,0x1
  800284:	310b0b13          	addi	s6,s6,784 # 801590 <main+0x100>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800288:	000cc503          	lbu	a0,0(s9)
  80028c:	001c8413          	addi	s0,s9,1
  800290:	01350a63          	beq	a0,s3,8002a4 <vprintfmt+0x56>
            if (ch == '\0') {
  800294:	c121                	beqz	a0,8002d4 <vprintfmt+0x86>
            putch(ch, putdat);
  800296:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800298:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  80029a:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80029c:	fff44503          	lbu	a0,-1(s0)
  8002a0:	ff351ae3          	bne	a0,s3,800294 <vprintfmt+0x46>
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  8002a4:	00044683          	lbu	a3,0(s0)
        char padc = ' ';
  8002a8:	02000813          	li	a6,32
        lflag = altflag = 0;
  8002ac:	4d81                	li	s11,0
  8002ae:	4501                	li	a0,0
        width = precision = -1;
  8002b0:	5c7d                	li	s8,-1
  8002b2:	5d7d                	li	s10,-1
  8002b4:	05500613          	li	a2,85
        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
  8002b8:	45a5                	li	a1,9
        switch (ch = *(unsigned char *)fmt ++) {
  8002ba:	fdd6879b          	addiw	a5,a3,-35
  8002be:	0ff7f793          	zext.b	a5,a5
  8002c2:	00140c93          	addi	s9,s0,1
  8002c6:	04f66263          	bltu	a2,a5,80030a <vprintfmt+0xbc>
  8002ca:	078a                	slli	a5,a5,0x2
  8002cc:	97d6                	add	a5,a5,s5
  8002ce:	439c                	lw	a5,0(a5)
  8002d0:	97d6                	add	a5,a5,s5
  8002d2:	8782                	jr	a5
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8002d4:	70e6                	ld	ra,120(sp)
  8002d6:	7446                	ld	s0,112(sp)
  8002d8:	74a6                	ld	s1,104(sp)
  8002da:	7906                	ld	s2,96(sp)
  8002dc:	69e6                	ld	s3,88(sp)
  8002de:	6a46                	ld	s4,80(sp)
  8002e0:	6aa6                	ld	s5,72(sp)
  8002e2:	6b06                	ld	s6,64(sp)
  8002e4:	7be2                	ld	s7,56(sp)
  8002e6:	7c42                	ld	s8,48(sp)
  8002e8:	7ca2                	ld	s9,40(sp)
  8002ea:	7d02                	ld	s10,32(sp)
  8002ec:	6de2                	ld	s11,24(sp)
  8002ee:	6109                	addi	sp,sp,128
  8002f0:	8082                	ret
            padc = '0';
  8002f2:	8836                	mv	a6,a3
            goto reswitch;
  8002f4:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  8002f8:	8466                	mv	s0,s9
  8002fa:	00140c93          	addi	s9,s0,1
  8002fe:	fdd6879b          	addiw	a5,a3,-35
  800302:	0ff7f793          	zext.b	a5,a5
  800306:	fcf672e3          	bgeu	a2,a5,8002ca <vprintfmt+0x7c>
            putch('%', putdat);
  80030a:	85a6                	mv	a1,s1
  80030c:	02500513          	li	a0,37
  800310:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800312:	fff44783          	lbu	a5,-1(s0)
  800316:	8ca2                	mv	s9,s0
  800318:	f73788e3          	beq	a5,s3,800288 <vprintfmt+0x3a>
  80031c:	ffecc783          	lbu	a5,-2(s9)
  800320:	1cfd                	addi	s9,s9,-1
  800322:	ff379de3          	bne	a5,s3,80031c <vprintfmt+0xce>
  800326:	b78d                	j	800288 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  800328:	fd068c1b          	addiw	s8,a3,-48
                ch = *fmt;
  80032c:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800330:	8466                	mv	s0,s9
                if (ch < '0' || ch > '9') {
  800332:	fd06879b          	addiw	a5,a3,-48
                ch = *fmt;
  800336:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  80033a:	02f5e563          	bltu	a1,a5,800364 <vprintfmt+0x116>
                ch = *fmt;
  80033e:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
  800342:	002c179b          	slliw	a5,s8,0x2
  800346:	0187873b          	addw	a4,a5,s8
  80034a:	0017171b          	slliw	a4,a4,0x1
  80034e:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
  800352:	fd06879b          	addiw	a5,a3,-48
            for (precision = 0; ; ++ fmt) {
  800356:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  800358:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  80035c:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  800360:	fcf5ffe3          	bgeu	a1,a5,80033e <vprintfmt+0xf0>
            if (width < 0)
  800364:	f40d5be3          	bgez	s10,8002ba <vprintfmt+0x6c>
                width = precision, precision = -1;
  800368:	8d62                	mv	s10,s8
  80036a:	5c7d                	li	s8,-1
  80036c:	b7b9                	j	8002ba <vprintfmt+0x6c>
            if (width < 0)
  80036e:	fffd4793          	not	a5,s10
  800372:	97fd                	srai	a5,a5,0x3f
  800374:	00fd7d33          	and	s10,s10,a5
        switch (ch = *(unsigned char *)fmt ++) {
  800378:	00144683          	lbu	a3,1(s0)
  80037c:	2d01                	sext.w	s10,s10
  80037e:	8466                	mv	s0,s9
            goto reswitch;
  800380:	bf2d                	j	8002ba <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  800382:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  800386:	00144683          	lbu	a3,1(s0)
            precision = va_arg(ap, int);
  80038a:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  80038c:	8466                	mv	s0,s9
            goto process_precision;
  80038e:	bfd9                	j	800364 <vprintfmt+0x116>
    if (lflag >= 2) {
  800390:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800392:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800396:	00a7c463          	blt	a5,a0,80039e <vprintfmt+0x150>
    else if (lflag) {
  80039a:	28050a63          	beqz	a0,80062e <vprintfmt+0x3e0>
        return va_arg(*ap, unsigned long);
  80039e:	000a3783          	ld	a5,0(s4)
  8003a2:	4641                	li	a2,16
  8003a4:	8a3a                	mv	s4,a4
  8003a6:	46c1                	li	a3,16
    unsigned mod = do_div(result, base);
  8003a8:	02c7fdb3          	remu	s11,a5,a2
            printnum(putch, putdat, num, base, width, padc);
  8003ac:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  8003b0:	0ac7f563          	bgeu	a5,a2,80045a <vprintfmt+0x20c>
        while (-- width > 0)
  8003b4:	3d7d                	addiw	s10,s10,-1
  8003b6:	01a05863          	blez	s10,8003c6 <vprintfmt+0x178>
  8003ba:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  8003bc:	85a6                	mv	a1,s1
  8003be:	8562                	mv	a0,s8
  8003c0:	9902                	jalr	s2
        while (-- width > 0)
  8003c2:	fe0d1ce3          	bnez	s10,8003ba <vprintfmt+0x16c>
    putch("0123456789abcdef"[mod], putdat);
  8003c6:	9dda                	add	s11,s11,s6
  8003c8:	000dc503          	lbu	a0,0(s11)
  8003cc:	85a6                	mv	a1,s1
  8003ce:	9902                	jalr	s2
}
  8003d0:	bd65                	j	800288 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  8003d2:	000a2503          	lw	a0,0(s4)
  8003d6:	85a6                	mv	a1,s1
  8003d8:	0a21                	addi	s4,s4,8
  8003da:	9902                	jalr	s2
            break;
  8003dc:	b575                	j	800288 <vprintfmt+0x3a>
    if (lflag >= 2) {
  8003de:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8003e0:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  8003e4:	00a7c463          	blt	a5,a0,8003ec <vprintfmt+0x19e>
    else if (lflag) {
  8003e8:	22050d63          	beqz	a0,800622 <vprintfmt+0x3d4>
        return va_arg(*ap, unsigned long);
  8003ec:	000a3783          	ld	a5,0(s4)
  8003f0:	4629                	li	a2,10
  8003f2:	8a3a                	mv	s4,a4
  8003f4:	46a9                	li	a3,10
  8003f6:	bf4d                	j	8003a8 <vprintfmt+0x15a>
        switch (ch = *(unsigned char *)fmt ++) {
  8003f8:	00144683          	lbu	a3,1(s0)
            altflag = 1;
  8003fc:	4d85                	li	s11,1
        switch (ch = *(unsigned char *)fmt ++) {
  8003fe:	8466                	mv	s0,s9
            goto reswitch;
  800400:	bd6d                	j	8002ba <vprintfmt+0x6c>
            putch(ch, putdat);
  800402:	85a6                	mv	a1,s1
  800404:	02500513          	li	a0,37
  800408:	9902                	jalr	s2
            break;
  80040a:	bdbd                	j	800288 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  80040c:	00144683          	lbu	a3,1(s0)
            lflag ++;
  800410:	2505                	addiw	a0,a0,1
        switch (ch = *(unsigned char *)fmt ++) {
  800412:	8466                	mv	s0,s9
            goto reswitch;
  800414:	b55d                	j	8002ba <vprintfmt+0x6c>
    if (lflag >= 2) {
  800416:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800418:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  80041c:	00a7c463          	blt	a5,a0,800424 <vprintfmt+0x1d6>
    else if (lflag) {
  800420:	1e050b63          	beqz	a0,800616 <vprintfmt+0x3c8>
        return va_arg(*ap, unsigned long);
  800424:	000a3783          	ld	a5,0(s4)
  800428:	4621                	li	a2,8
  80042a:	8a3a                	mv	s4,a4
  80042c:	46a1                	li	a3,8
  80042e:	bfad                	j	8003a8 <vprintfmt+0x15a>
            putch('0', putdat);
  800430:	03000513          	li	a0,48
  800434:	85a6                	mv	a1,s1
  800436:	e042                	sd	a6,0(sp)
  800438:	9902                	jalr	s2
            putch('x', putdat);
  80043a:	85a6                	mv	a1,s1
  80043c:	07800513          	li	a0,120
  800440:	9902                	jalr	s2
            goto number;
  800442:	6802                	ld	a6,0(sp)
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800444:	000a3783          	ld	a5,0(s4)
            goto number;
  800448:	4641                	li	a2,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80044a:	0a21                	addi	s4,s4,8
    unsigned mod = do_div(result, base);
  80044c:	02c7fdb3          	remu	s11,a5,a2
            goto number;
  800450:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
  800452:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  800456:	f4c7efe3          	bltu	a5,a2,8003b4 <vprintfmt+0x166>
        while (-- width > 0)
  80045a:	3d79                	addiw	s10,s10,-2
    unsigned mod = do_div(result, base);
  80045c:	02c7d7b3          	divu	a5,a5,a2
  800460:	02c7f433          	remu	s0,a5,a2
    if (num >= base) {
  800464:	10c7f463          	bgeu	a5,a2,80056c <vprintfmt+0x31e>
        while (-- width > 0)
  800468:	01a05863          	blez	s10,800478 <vprintfmt+0x22a>
  80046c:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  80046e:	85a6                	mv	a1,s1
  800470:	8562                	mv	a0,s8
  800472:	9902                	jalr	s2
        while (-- width > 0)
  800474:	fe0d1ce3          	bnez	s10,80046c <vprintfmt+0x21e>
    putch("0123456789abcdef"[mod], putdat);
  800478:	945a                	add	s0,s0,s6
  80047a:	00044503          	lbu	a0,0(s0)
  80047e:	85a6                	mv	a1,s1
  800480:	9dda                	add	s11,s11,s6
  800482:	9902                	jalr	s2
  800484:	000dc503          	lbu	a0,0(s11)
  800488:	85a6                	mv	a1,s1
  80048a:	9902                	jalr	s2
  80048c:	bbf5                	j	800288 <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
  80048e:	000a3403          	ld	s0,0(s4)
  800492:	008a0793          	addi	a5,s4,8
  800496:	e43e                	sd	a5,8(sp)
  800498:	1e040563          	beqz	s0,800682 <vprintfmt+0x434>
            if (width > 0 && padc != '-') {
  80049c:	15a05263          	blez	s10,8005e0 <vprintfmt+0x392>
  8004a0:	02d00793          	li	a5,45
  8004a4:	10f81b63          	bne	a6,a5,8005ba <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004a8:	00044783          	lbu	a5,0(s0)
  8004ac:	0007851b          	sext.w	a0,a5
  8004b0:	0e078c63          	beqz	a5,8005a8 <vprintfmt+0x35a>
  8004b4:	0405                	addi	s0,s0,1
  8004b6:	120d8e63          	beqz	s11,8005f2 <vprintfmt+0x3a4>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004ba:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004be:	020c4963          	bltz	s8,8004f0 <vprintfmt+0x2a2>
  8004c2:	fffc0a1b          	addiw	s4,s8,-1
  8004c6:	0d7a0f63          	beq	s4,s7,8005a4 <vprintfmt+0x356>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004ca:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  8004cc:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8004ce:	02fdf663          	bgeu	s11,a5,8004fa <vprintfmt+0x2ac>
                    putch('?', putdat);
  8004d2:	03f00513          	li	a0,63
  8004d6:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004d8:	00044783          	lbu	a5,0(s0)
  8004dc:	3d7d                	addiw	s10,s10,-1
  8004de:	0405                	addi	s0,s0,1
  8004e0:	0007851b          	sext.w	a0,a5
  8004e4:	c3e1                	beqz	a5,8005a4 <vprintfmt+0x356>
  8004e6:	140c4a63          	bltz	s8,80063a <vprintfmt+0x3ec>
  8004ea:	8c52                	mv	s8,s4
  8004ec:	fc0c5be3          	bgez	s8,8004c2 <vprintfmt+0x274>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004f0:	3781                	addiw	a5,a5,-32
  8004f2:	8a62                	mv	s4,s8
                    putch('?', putdat);
  8004f4:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8004f6:	fcfdeee3          	bltu	s11,a5,8004d2 <vprintfmt+0x284>
                    putch(ch, putdat);
  8004fa:	9902                	jalr	s2
  8004fc:	bff1                	j	8004d8 <vprintfmt+0x28a>
    if (lflag >= 2) {
  8004fe:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800500:	008a0d93          	addi	s11,s4,8
    if (lflag >= 2) {
  800504:	00a7c463          	blt	a5,a0,80050c <vprintfmt+0x2be>
    else if (lflag) {
  800508:	10050463          	beqz	a0,800610 <vprintfmt+0x3c2>
        return va_arg(*ap, long);
  80050c:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  800510:	14044d63          	bltz	s0,80066a <vprintfmt+0x41c>
            num = getint(&ap, lflag);
  800514:	87a2                	mv	a5,s0
  800516:	8a6e                	mv	s4,s11
  800518:	4629                	li	a2,10
  80051a:	46a9                	li	a3,10
  80051c:	b571                	j	8003a8 <vprintfmt+0x15a>
            err = va_arg(ap, int);
  80051e:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800522:	4761                	li	a4,24
            err = va_arg(ap, int);
  800524:	0a21                	addi	s4,s4,8
            if (err < 0) {
  800526:	41f7d69b          	sraiw	a3,a5,0x1f
  80052a:	8fb5                	xor	a5,a5,a3
  80052c:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800530:	02d74563          	blt	a4,a3,80055a <vprintfmt+0x30c>
  800534:	00369713          	slli	a4,a3,0x3
  800538:	00001797          	auipc	a5,0x1
  80053c:	2a878793          	addi	a5,a5,680 # 8017e0 <error_string>
  800540:	97ba                	add	a5,a5,a4
  800542:	639c                	ld	a5,0(a5)
  800544:	cb99                	beqz	a5,80055a <vprintfmt+0x30c>
                printfmt(putch, putdat, "%s", p);
  800546:	86be                	mv	a3,a5
  800548:	00001617          	auipc	a2,0x1
  80054c:	07860613          	addi	a2,a2,120 # 8015c0 <main+0x130>
  800550:	85a6                	mv	a1,s1
  800552:	854a                	mv	a0,s2
  800554:	160000ef          	jal	ra,8006b4 <printfmt>
  800558:	bb05                	j	800288 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  80055a:	00001617          	auipc	a2,0x1
  80055e:	05660613          	addi	a2,a2,86 # 8015b0 <main+0x120>
  800562:	85a6                	mv	a1,s1
  800564:	854a                	mv	a0,s2
  800566:	14e000ef          	jal	ra,8006b4 <printfmt>
  80056a:	bb39                	j	800288 <vprintfmt+0x3a>
        printnum(putch, putdat, result, base, width - 1, padc);
  80056c:	02c7d633          	divu	a2,a5,a2
  800570:	876a                	mv	a4,s10
  800572:	87e2                	mv	a5,s8
  800574:	85a6                	mv	a1,s1
  800576:	854a                	mv	a0,s2
  800578:	befff0ef          	jal	ra,800166 <printnum>
  80057c:	bdf5                	j	800478 <vprintfmt+0x22a>
                    putch(ch, putdat);
  80057e:	85a6                	mv	a1,s1
  800580:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800582:	00044503          	lbu	a0,0(s0)
  800586:	3d7d                	addiw	s10,s10,-1
  800588:	0405                	addi	s0,s0,1
  80058a:	cd09                	beqz	a0,8005a4 <vprintfmt+0x356>
  80058c:	008d0d3b          	addw	s10,s10,s0
  800590:	fffd0d9b          	addiw	s11,s10,-1
                    putch(ch, putdat);
  800594:	85a6                	mv	a1,s1
  800596:	408d8d3b          	subw	s10,s11,s0
  80059a:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80059c:	00044503          	lbu	a0,0(s0)
  8005a0:	0405                	addi	s0,s0,1
  8005a2:	f96d                	bnez	a0,800594 <vprintfmt+0x346>
            for (; width > 0; width --) {
  8005a4:	01a05963          	blez	s10,8005b6 <vprintfmt+0x368>
  8005a8:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
  8005aa:	85a6                	mv	a1,s1
  8005ac:	02000513          	li	a0,32
  8005b0:	9902                	jalr	s2
            for (; width > 0; width --) {
  8005b2:	fe0d1be3          	bnez	s10,8005a8 <vprintfmt+0x35a>
            if ((p = va_arg(ap, char *)) == NULL) {
  8005b6:	6a22                	ld	s4,8(sp)
  8005b8:	b9c1                	j	800288 <vprintfmt+0x3a>
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005ba:	85e2                	mv	a1,s8
  8005bc:	8522                	mv	a0,s0
  8005be:	e042                	sd	a6,0(sp)
  8005c0:	154000ef          	jal	ra,800714 <strnlen>
  8005c4:	40ad0d3b          	subw	s10,s10,a0
  8005c8:	01a05c63          	blez	s10,8005e0 <vprintfmt+0x392>
                    putch(padc, putdat);
  8005cc:	6802                	ld	a6,0(sp)
  8005ce:	0008051b          	sext.w	a0,a6
  8005d2:	85a6                	mv	a1,s1
  8005d4:	e02a                	sd	a0,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005d6:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
  8005d8:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005da:	6502                	ld	a0,0(sp)
  8005dc:	fe0d1be3          	bnez	s10,8005d2 <vprintfmt+0x384>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005e0:	00044783          	lbu	a5,0(s0)
  8005e4:	0405                	addi	s0,s0,1
  8005e6:	0007851b          	sext.w	a0,a5
  8005ea:	ec0796e3          	bnez	a5,8004b6 <vprintfmt+0x268>
            if ((p = va_arg(ap, char *)) == NULL) {
  8005ee:	6a22                	ld	s4,8(sp)
  8005f0:	b961                	j	800288 <vprintfmt+0x3a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005f2:	f80c46e3          	bltz	s8,80057e <vprintfmt+0x330>
  8005f6:	3c7d                	addiw	s8,s8,-1
  8005f8:	fb7c06e3          	beq	s8,s7,8005a4 <vprintfmt+0x356>
                    putch(ch, putdat);
  8005fc:	85a6                	mv	a1,s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005fe:	0405                	addi	s0,s0,1
                    putch(ch, putdat);
  800600:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800602:	fff44503          	lbu	a0,-1(s0)
  800606:	3d7d                	addiw	s10,s10,-1
  800608:	f56d                	bnez	a0,8005f2 <vprintfmt+0x3a4>
            for (; width > 0; width --) {
  80060a:	f9a04fe3          	bgtz	s10,8005a8 <vprintfmt+0x35a>
  80060e:	b765                	j	8005b6 <vprintfmt+0x368>
        return va_arg(*ap, int);
  800610:	000a2403          	lw	s0,0(s4)
  800614:	bdf5                	j	800510 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned int);
  800616:	000a6783          	lwu	a5,0(s4)
  80061a:	4621                	li	a2,8
  80061c:	8a3a                	mv	s4,a4
  80061e:	46a1                	li	a3,8
  800620:	b361                	j	8003a8 <vprintfmt+0x15a>
  800622:	000a6783          	lwu	a5,0(s4)
  800626:	4629                	li	a2,10
  800628:	8a3a                	mv	s4,a4
  80062a:	46a9                	li	a3,10
  80062c:	bbb5                	j	8003a8 <vprintfmt+0x15a>
  80062e:	000a6783          	lwu	a5,0(s4)
  800632:	4641                	li	a2,16
  800634:	8a3a                	mv	s4,a4
  800636:	46c1                	li	a3,16
  800638:	bb85                	j	8003a8 <vprintfmt+0x15a>
  80063a:	01a40d3b          	addw	s10,s0,s10
                if (altflag && (ch < ' ' || ch > '~')) {
  80063e:	05e00d93          	li	s11,94
  800642:	3d7d                	addiw	s10,s10,-1
  800644:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  800646:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800648:	00fdf463          	bgeu	s11,a5,800650 <vprintfmt+0x402>
                    putch('?', putdat);
  80064c:	03f00513          	li	a0,63
  800650:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800652:	00044783          	lbu	a5,0(s0)
  800656:	408d073b          	subw	a4,s10,s0
  80065a:	0405                	addi	s0,s0,1
  80065c:	0007851b          	sext.w	a0,a5
  800660:	f3f5                	bnez	a5,800644 <vprintfmt+0x3f6>
  800662:	8d3a                	mv	s10,a4
            for (; width > 0; width --) {
  800664:	f5a042e3          	bgtz	s10,8005a8 <vprintfmt+0x35a>
  800668:	b7b9                	j	8005b6 <vprintfmt+0x368>
                putch('-', putdat);
  80066a:	85a6                	mv	a1,s1
  80066c:	02d00513          	li	a0,45
  800670:	e042                	sd	a6,0(sp)
  800672:	9902                	jalr	s2
                num = -(long long)num;
  800674:	6802                	ld	a6,0(sp)
  800676:	8a6e                	mv	s4,s11
  800678:	408007b3          	neg	a5,s0
  80067c:	4629                	li	a2,10
  80067e:	46a9                	li	a3,10
  800680:	b325                	j	8003a8 <vprintfmt+0x15a>
            if (width > 0 && padc != '-') {
  800682:	03a05063          	blez	s10,8006a2 <vprintfmt+0x454>
  800686:	02d00793          	li	a5,45
                p = "(null)";
  80068a:	00001417          	auipc	s0,0x1
  80068e:	f1e40413          	addi	s0,s0,-226 # 8015a8 <main+0x118>
            if (width > 0 && padc != '-') {
  800692:	f2f814e3          	bne	a6,a5,8005ba <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800696:	02800793          	li	a5,40
  80069a:	02800513          	li	a0,40
  80069e:	0405                	addi	s0,s0,1
  8006a0:	bd19                	j	8004b6 <vprintfmt+0x268>
  8006a2:	02800513          	li	a0,40
  8006a6:	02800793          	li	a5,40
  8006aa:	00001417          	auipc	s0,0x1
  8006ae:	eff40413          	addi	s0,s0,-257 # 8015a9 <main+0x119>
  8006b2:	b511                	j	8004b6 <vprintfmt+0x268>

00000000008006b4 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006b4:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  8006b6:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006ba:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8006bc:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006be:	ec06                	sd	ra,24(sp)
  8006c0:	f83a                	sd	a4,48(sp)
  8006c2:	fc3e                	sd	a5,56(sp)
  8006c4:	e0c2                	sd	a6,64(sp)
  8006c6:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8006c8:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8006ca:	b85ff0ef          	jal	ra,80024e <vprintfmt>
}
  8006ce:	60e2                	ld	ra,24(sp)
  8006d0:	6161                	addi	sp,sp,80
  8006d2:	8082                	ret

00000000008006d4 <rand>:
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
  8006d4:	00002697          	auipc	a3,0x2
  8006d8:	92c68693          	addi	a3,a3,-1748 # 802000 <next>
  8006dc:	629c                	ld	a5,0(a3)
  8006de:	00001717          	auipc	a4,0x1
  8006e2:	24a73703          	ld	a4,586(a4) # 801928 <error_string+0x148>
  8006e6:	02e787b3          	mul	a5,a5,a4
    unsigned long long result = (next >> 12);
    return (int)do_div(result, RAND_MAX + 1);
  8006ea:	80000737          	lui	a4,0x80000
  8006ee:	fff74713          	not	a4,a4
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
  8006f2:	07ad                	addi	a5,a5,11
  8006f4:	07c2                	slli	a5,a5,0x10
  8006f6:	83c1                	srli	a5,a5,0x10
    unsigned long long result = (next >> 12);
  8006f8:	00c7d513          	srli	a0,a5,0xc
    return (int)do_div(result, RAND_MAX + 1);
  8006fc:	02e57533          	remu	a0,a0,a4
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
  800700:	e29c                	sd	a5,0(a3)
}
  800702:	2505                	addiw	a0,a0,1
  800704:	8082                	ret

0000000000800706 <srand>:
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
    next = seed;
  800706:	1502                	slli	a0,a0,0x20
  800708:	9101                	srli	a0,a0,0x20
  80070a:	00002797          	auipc	a5,0x2
  80070e:	8ea7bb23          	sd	a0,-1802(a5) # 802000 <next>
}
  800712:	8082                	ret

0000000000800714 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  800714:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  800716:	e589                	bnez	a1,800720 <strnlen+0xc>
  800718:	a811                	j	80072c <strnlen+0x18>
        cnt ++;
  80071a:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  80071c:	00f58863          	beq	a1,a5,80072c <strnlen+0x18>
  800720:	00f50733          	add	a4,a0,a5
  800724:	00074703          	lbu	a4,0(a4) # ffffffff80000000 <matc+0xffffffff7f7fdcd8>
  800728:	fb6d                	bnez	a4,80071a <strnlen+0x6>
  80072a:	85be                	mv	a1,a5
    }
    return cnt;
}
  80072c:	852e                	mv	a0,a1
  80072e:	8082                	ret

0000000000800730 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  800730:	8eb2                	mv	t4,a2
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
  800732:	fff60e13          	addi	t3,a2,-1
  800736:	16060863          	beqz	a2,8008a6 <memset+0x176>
  80073a:	40a007b3          	neg	a5,a0
  80073e:	8b9d                	andi	a5,a5,7
  800740:	00778713          	addi	a4,a5,7
  800744:	46ad                	li	a3,11
  800746:	16d76163          	bltu	a4,a3,8008a8 <memset+0x178>
  80074a:	16ee6463          	bltu	t3,a4,8008b2 <memset+0x182>
  80074e:	16078063          	beqz	a5,8008ae <memset+0x17e>
        *p ++ = c;
  800752:	00b50023          	sb	a1,0(a0)
  800756:	4705                	li	a4,1
  800758:	00150f13          	addi	t5,a0,1
    while (n -- > 0) {
  80075c:	ffee8e13          	addi	t3,t4,-2
  800760:	06e78563          	beq	a5,a4,8007ca <memset+0x9a>
        *p ++ = c;
  800764:	00b500a3          	sb	a1,1(a0)
  800768:	4709                	li	a4,2
  80076a:	00250f13          	addi	t5,a0,2
    while (n -- > 0) {
  80076e:	ffde8e13          	addi	t3,t4,-3
  800772:	04e78c63          	beq	a5,a4,8007ca <memset+0x9a>
        *p ++ = c;
  800776:	00b50123          	sb	a1,2(a0)
  80077a:	470d                	li	a4,3
  80077c:	00350f13          	addi	t5,a0,3
    while (n -- > 0) {
  800780:	ffce8e13          	addi	t3,t4,-4
  800784:	04e78363          	beq	a5,a4,8007ca <memset+0x9a>
        *p ++ = c;
  800788:	00b501a3          	sb	a1,3(a0)
  80078c:	4711                	li	a4,4
  80078e:	00450f13          	addi	t5,a0,4
    while (n -- > 0) {
  800792:	ffbe8e13          	addi	t3,t4,-5
  800796:	02e78a63          	beq	a5,a4,8007ca <memset+0x9a>
        *p ++ = c;
  80079a:	00b50223          	sb	a1,4(a0)
  80079e:	4715                	li	a4,5
  8007a0:	00550f13          	addi	t5,a0,5
    while (n -- > 0) {
  8007a4:	ffae8e13          	addi	t3,t4,-6
  8007a8:	02e78163          	beq	a5,a4,8007ca <memset+0x9a>
        *p ++ = c;
  8007ac:	00b502a3          	sb	a1,5(a0)
  8007b0:	471d                	li	a4,7
  8007b2:	00650f13          	addi	t5,a0,6
    while (n -- > 0) {
  8007b6:	ff9e8e13          	addi	t3,t4,-7
  8007ba:	00e79863          	bne	a5,a4,8007ca <memset+0x9a>
        *p ++ = c;
  8007be:	00750f13          	addi	t5,a0,7
  8007c2:	00b50323          	sb	a1,6(a0)
    while (n -- > 0) {
  8007c6:	ff8e8e13          	addi	t3,t4,-8
  8007ca:	00859713          	slli	a4,a1,0x8
  8007ce:	8f4d                	or	a4,a4,a1
  8007d0:	01059313          	slli	t1,a1,0x10
  8007d4:	00676333          	or	t1,a4,t1
  8007d8:	01859893          	slli	a7,a1,0x18
  8007dc:	02059813          	slli	a6,a1,0x20
  8007e0:	011368b3          	or	a7,t1,a7
  8007e4:	02859613          	slli	a2,a1,0x28
  8007e8:	0108e833          	or	a6,a7,a6
  8007ec:	40fe8eb3          	sub	t4,t4,a5
  8007f0:	00c86633          	or	a2,a6,a2
  8007f4:	03059693          	slli	a3,a1,0x30
  8007f8:	8ed1                	or	a3,a3,a2
  8007fa:	03859713          	slli	a4,a1,0x38
  8007fe:	97aa                	add	a5,a5,a0
  800800:	ff8ef613          	andi	a2,t4,-8
  800804:	8f55                	or	a4,a4,a3
  800806:	00f606b3          	add	a3,a2,a5
        *p ++ = c;
  80080a:	e398                	sd	a4,0(a5)
    while (n -- > 0) {
  80080c:	07a1                	addi	a5,a5,8
  80080e:	fed79ee3          	bne	a5,a3,80080a <memset+0xda>
  800812:	ff8ef713          	andi	a4,t4,-8
  800816:	00ef07b3          	add	a5,t5,a4
  80081a:	40ee0e33          	sub	t3,t3,a4
  80081e:	08ee8763          	beq	t4,a4,8008ac <memset+0x17c>
        *p ++ = c;
  800822:	00b78023          	sb	a1,0(a5)
    while (n -- > 0) {
  800826:	080e0063          	beqz	t3,8008a6 <memset+0x176>
        *p ++ = c;
  80082a:	00b780a3          	sb	a1,1(a5)
    while (n -- > 0) {
  80082e:	4705                	li	a4,1
  800830:	06ee0b63          	beq	t3,a4,8008a6 <memset+0x176>
        *p ++ = c;
  800834:	00b78123          	sb	a1,2(a5)
    while (n -- > 0) {
  800838:	4709                	li	a4,2
  80083a:	06ee0663          	beq	t3,a4,8008a6 <memset+0x176>
        *p ++ = c;
  80083e:	00b781a3          	sb	a1,3(a5)
    while (n -- > 0) {
  800842:	470d                	li	a4,3
  800844:	06ee0163          	beq	t3,a4,8008a6 <memset+0x176>
        *p ++ = c;
  800848:	00b78223          	sb	a1,4(a5)
    while (n -- > 0) {
  80084c:	4711                	li	a4,4
  80084e:	04ee0c63          	beq	t3,a4,8008a6 <memset+0x176>
        *p ++ = c;
  800852:	00b782a3          	sb	a1,5(a5)
    while (n -- > 0) {
  800856:	4715                	li	a4,5
  800858:	04ee0763          	beq	t3,a4,8008a6 <memset+0x176>
        *p ++ = c;
  80085c:	00b78323          	sb	a1,6(a5)
    while (n -- > 0) {
  800860:	4719                	li	a4,6
  800862:	04ee0263          	beq	t3,a4,8008a6 <memset+0x176>
        *p ++ = c;
  800866:	00b783a3          	sb	a1,7(a5)
    while (n -- > 0) {
  80086a:	471d                	li	a4,7
  80086c:	02ee0d63          	beq	t3,a4,8008a6 <memset+0x176>
        *p ++ = c;
  800870:	00b78423          	sb	a1,8(a5)
    while (n -- > 0) {
  800874:	4721                	li	a4,8
  800876:	02ee0863          	beq	t3,a4,8008a6 <memset+0x176>
        *p ++ = c;
  80087a:	00b784a3          	sb	a1,9(a5)
    while (n -- > 0) {
  80087e:	4725                	li	a4,9
  800880:	02ee0363          	beq	t3,a4,8008a6 <memset+0x176>
        *p ++ = c;
  800884:	00b78523          	sb	a1,10(a5)
    while (n -- > 0) {
  800888:	4729                	li	a4,10
  80088a:	00ee0e63          	beq	t3,a4,8008a6 <memset+0x176>
        *p ++ = c;
  80088e:	00b785a3          	sb	a1,11(a5)
    while (n -- > 0) {
  800892:	472d                	li	a4,11
  800894:	00ee0963          	beq	t3,a4,8008a6 <memset+0x176>
        *p ++ = c;
  800898:	00b78623          	sb	a1,12(a5)
    while (n -- > 0) {
  80089c:	4731                	li	a4,12
  80089e:	00ee0463          	beq	t3,a4,8008a6 <memset+0x176>
        *p ++ = c;
  8008a2:	00b786a3          	sb	a1,13(a5)
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  8008a6:	8082                	ret
  8008a8:	472d                	li	a4,11
  8008aa:	b545                	j	80074a <memset+0x1a>
  8008ac:	8082                	ret
    while (n -- > 0) {
  8008ae:	8f2a                	mv	t5,a0
  8008b0:	bf29                	j	8007ca <memset+0x9a>
  8008b2:	87aa                	mv	a5,a0
  8008b4:	b7bd                	j	800822 <memset+0xf2>

00000000008008b6 <work>:
void
work(unsigned int times) {
    int i, j, k, size = MATSIZE;
    for (i = 0; i < size; i ++) {
        for (j = 0; j < size; j ++) {
            mata[i][j] = matb[i][j] = 1;
  8008b6:	4785                	li	a5,1
work(unsigned int times) {
  8008b8:	c7010113          	addi	sp,sp,-912
            mata[i][j] = matb[i][j] = 1;
  8008bc:	1782                	slli	a5,a5,0x20
  8008be:	0785                	addi	a5,a5,1
work(unsigned int times) {
  8008c0:	35513c23          	sd	s5,856(sp)
  8008c4:	35613823          	sd	s6,848(sp)
            mata[i][j] = matb[i][j] = 1;
  8008c8:	00001a97          	auipc	s5,0x1
  8008cc:	740a8a93          	addi	s5,s5,1856 # 802008 <mata>
  8008d0:	00002b17          	auipc	s6,0x2
  8008d4:	8c8b0b13          	addi	s6,s6,-1848 # 802198 <matb>
work(unsigned int times) {
  8008d8:	38113423          	sd	ra,904(sp)
  8008dc:	38813023          	sd	s0,896(sp)
  8008e0:	37413023          	sd	s4,864(sp)
            mata[i][j] = matb[i][j] = 1;
  8008e4:	00fb3023          	sd	a5,0(s6)
  8008e8:	00fb3423          	sd	a5,8(s6)
  8008ec:	00fb3823          	sd	a5,16(s6)
  8008f0:	00fb3c23          	sd	a5,24(s6)
  8008f4:	02fb3023          	sd	a5,32(s6)
  8008f8:	00fab023          	sd	a5,0(s5)
  8008fc:	00fab423          	sd	a5,8(s5)
  800900:	00fab823          	sd	a5,16(s5)
  800904:	00fabc23          	sd	a5,24(s5)
  800908:	02fab023          	sd	a5,32(s5)
  80090c:	02fb3423          	sd	a5,40(s6)
  800910:	02fb3823          	sd	a5,48(s6)
  800914:	02fb3c23          	sd	a5,56(s6)
  800918:	04fb3023          	sd	a5,64(s6)
  80091c:	04fb3423          	sd	a5,72(s6)
  800920:	02fab423          	sd	a5,40(s5)
  800924:	02fab823          	sd	a5,48(s5)
  800928:	02fabc23          	sd	a5,56(s5)
  80092c:	04fab023          	sd	a5,64(s5)
work(unsigned int times) {
  800930:	36913c23          	sd	s1,888(sp)
  800934:	37213823          	sd	s2,880(sp)
  800938:	37313423          	sd	s3,872(sp)
  80093c:	35713423          	sd	s7,840(sp)
  800940:	35813023          	sd	s8,832(sp)
  800944:	33913c23          	sd	s9,824(sp)
  800948:	33a13823          	sd	s10,816(sp)
  80094c:	33b13423          	sd	s11,808(sp)
            mata[i][j] = matb[i][j] = 1;
  800950:	04fab423          	sd	a5,72(s5)
  800954:	04fb3823          	sd	a5,80(s6)
  800958:	04fb3c23          	sd	a5,88(s6)
  80095c:	06fb3023          	sd	a5,96(s6)
  800960:	06fb3423          	sd	a5,104(s6)
  800964:	06fb3823          	sd	a5,112(s6)
  800968:	04fab823          	sd	a5,80(s5)
  80096c:	04fabc23          	sd	a5,88(s5)
  800970:	06fab023          	sd	a5,96(s5)
  800974:	06fab423          	sd	a5,104(s5)
  800978:	06fab823          	sd	a5,112(s5)
  80097c:	06fb3c23          	sd	a5,120(s6)
  800980:	08fb3023          	sd	a5,128(s6)
  800984:	08fb3423          	sd	a5,136(s6)
  800988:	08fb3823          	sd	a5,144(s6)
  80098c:	08fb3c23          	sd	a5,152(s6)
  800990:	06fabc23          	sd	a5,120(s5)
  800994:	08fab023          	sd	a5,128(s5)
  800998:	08fab423          	sd	a5,136(s5)
  80099c:	08fab823          	sd	a5,144(s5)
  8009a0:	08fabc23          	sd	a5,152(s5)
  8009a4:	0afb3023          	sd	a5,160(s6)
  8009a8:	0afb3423          	sd	a5,168(s6)
  8009ac:	0afb3823          	sd	a5,176(s6)
  8009b0:	0afb3c23          	sd	a5,184(s6)
  8009b4:	0cfb3023          	sd	a5,192(s6)
  8009b8:	0afab023          	sd	a5,160(s5)
  8009bc:	0afab423          	sd	a5,168(s5)
  8009c0:	0afab823          	sd	a5,176(s5)
  8009c4:	0afabc23          	sd	a5,184(s5)
  8009c8:	0cfab023          	sd	a5,192(s5)
  8009cc:	0cfb3423          	sd	a5,200(s6)
  8009d0:	0cfb3823          	sd	a5,208(s6)
  8009d4:	0cfb3c23          	sd	a5,216(s6)
  8009d8:	0efb3023          	sd	a5,224(s6)
  8009dc:	0efb3423          	sd	a5,232(s6)
  8009e0:	0cfab423          	sd	a5,200(s5)
  8009e4:	0cfab823          	sd	a5,208(s5)
  8009e8:	0cfabc23          	sd	a5,216(s5)
  8009ec:	0efab023          	sd	a5,224(s5)
  8009f0:	0efab423          	sd	a5,232(s5)
  8009f4:	0efb3823          	sd	a5,240(s6)
  8009f8:	0efb3c23          	sd	a5,248(s6)
  8009fc:	10fb3023          	sd	a5,256(s6)
  800a00:	10fb3423          	sd	a5,264(s6)
  800a04:	10fb3823          	sd	a5,272(s6)
  800a08:	0efab823          	sd	a5,240(s5)
  800a0c:	0efabc23          	sd	a5,248(s5)
  800a10:	10fab023          	sd	a5,256(s5)
  800a14:	10fab423          	sd	a5,264(s5)
  800a18:	10fab823          	sd	a5,272(s5)
  800a1c:	10fb3c23          	sd	a5,280(s6)
  800a20:	12fb3023          	sd	a5,288(s6)
  800a24:	12fb3423          	sd	a5,296(s6)
  800a28:	12fb3823          	sd	a5,304(s6)
  800a2c:	12fb3c23          	sd	a5,312(s6)
  800a30:	10fabc23          	sd	a5,280(s5)
  800a34:	12fab023          	sd	a5,288(s5)
  800a38:	12fab423          	sd	a5,296(s5)
  800a3c:	12fab823          	sd	a5,304(s5)
  800a40:	12fabc23          	sd	a5,312(s5)
  800a44:	14fb3023          	sd	a5,320(s6)
  800a48:	14fb3423          	sd	a5,328(s6)
  800a4c:	14fb3823          	sd	a5,336(s6)
  800a50:	14fb3c23          	sd	a5,344(s6)
  800a54:	16fb3023          	sd	a5,352(s6)
  800a58:	14fab023          	sd	a5,320(s5)
work(unsigned int times) {
  800a5c:	842a                	mv	s0,a0
            mata[i][j] = matb[i][j] = 1;
  800a5e:	14fab423          	sd	a5,328(s5)
  800a62:	14fab823          	sd	a5,336(s5)
  800a66:	14fabc23          	sd	a5,344(s5)
  800a6a:	16fab023          	sd	a5,352(s5)
  800a6e:	16fb3423          	sd	a5,360(s6)
  800a72:	16fb3823          	sd	a5,368(s6)
  800a76:	16fb3c23          	sd	a5,376(s6)
  800a7a:	18fb3023          	sd	a5,384(s6)
  800a7e:	18fb3423          	sd	a5,392(s6)
  800a82:	16fab423          	sd	a5,360(s5)
  800a86:	16fab823          	sd	a5,368(s5)
  800a8a:	16fabc23          	sd	a5,376(s5)
  800a8e:	18fab023          	sd	a5,384(s5)
  800a92:	18fab423          	sd	a5,392(s5)
        }
    }

    yield();
  800a96:	ebeff0ef          	jal	ra,800154 <yield>

    cprintf("pid %d is running (%d times)!.\n", getpid(), times);
  800a9a:	ebeff0ef          	jal	ra,800158 <getpid>
  800a9e:	85aa                	mv	a1,a0
  800aa0:	8622                	mv	a2,s0
  800aa2:	00001517          	auipc	a0,0x1
  800aa6:	e0650513          	addi	a0,a0,-506 # 8018a8 <error_string+0xc8>
  800aaa:	df8ff0ef          	jal	ra,8000a2 <cprintf>

    while (times -- > 0) {
  800aae:	fff4079b          	addiw	a5,s0,-1
  800ab2:	30f13c23          	sd	a5,792(sp)
  800ab6:	00002a17          	auipc	s4,0x2
  800aba:	872a0a13          	addi	s4,s4,-1934 # 802328 <matc>
  800abe:	1a040de3          	beqz	s0,801478 <work+0xbc2>
        for (i = 0; i < size; i ++) {
            for (j = 0; j < size; j ++) {
                matc[i][j] = 0;
                for (k = 0; k < size; k ++) {
                    matc[i][j] += mata[i][k] * matb[k][j];
  800ac2:	078b2783          	lw	a5,120(s6)
  800ac6:	050b2b83          	lw	s7,80(s6)
  800aca:	000b2c83          	lw	s9,0(s6)
  800ace:	fb3e                	sd	a5,432(sp)
  800ad0:	0a0b2783          	lw	a5,160(s6)
  800ad4:	028b2c03          	lw	s8,40(s6)
  800ad8:	00001317          	auipc	t1,0x1
  800adc:	53030313          	addi	t1,t1,1328 # 802008 <mata>
  800ae0:	20f13023          	sd	a5,512(sp)
  800ae4:	0c8b2783          	lw	a5,200(s6)
  800ae8:	00002f97          	auipc	t6,0x2
  800aec:	840f8f93          	addi	t6,t6,-1984 # 802328 <matc>
  800af0:	efbe                	sd	a5,472(sp)
  800af2:	0f0b2783          	lw	a5,240(s6)
  800af6:	ff3e                	sd	a5,440(sp)
  800af8:	118b2783          	lw	a5,280(s6)
  800afc:	ef3e                	sd	a5,408(sp)
  800afe:	140b2783          	lw	a5,320(s6)
  800b02:	24f13423          	sd	a5,584(sp)
  800b06:	168b2783          	lw	a5,360(s6)
  800b0a:	24f13023          	sd	a5,576(sp)
  800b0e:	004b2783          	lw	a5,4(s6)
  800b12:	22f13c23          	sd	a5,568(sp)
  800b16:	02cb2783          	lw	a5,44(s6)
  800b1a:	22f13823          	sd	a5,560(sp)
  800b1e:	054b2783          	lw	a5,84(s6)
  800b22:	22f13423          	sd	a5,552(sp)
  800b26:	07cb2783          	lw	a5,124(s6)
  800b2a:	22f13023          	sd	a5,544(sp)
  800b2e:	0a4b2783          	lw	a5,164(s6)
  800b32:	20f13c23          	sd	a5,536(sp)
  800b36:	0ccb2783          	lw	a5,204(s6)
  800b3a:	20f13823          	sd	a5,528(sp)
  800b3e:	0f4b2783          	lw	a5,244(s6)
  800b42:	20f13423          	sd	a5,520(sp)
  800b46:	11cb2783          	lw	a5,284(s6)
  800b4a:	f7be                	sd	a5,488(sp)
  800b4c:	144b2783          	lw	a5,324(s6)
  800b50:	e7be                	sd	a5,456(sp)
  800b52:	16cb2783          	lw	a5,364(s6)
  800b56:	f33e                	sd	a5,416(sp)
  800b58:	008b2783          	lw	a5,8(s6)
  800b5c:	f6be                	sd	a5,360(sp)
  800b5e:	030b2783          	lw	a5,48(s6)
  800b62:	f2be                	sd	a5,352(sp)
  800b64:	058b2783          	lw	a5,88(s6)
  800b68:	eabe                	sd	a5,336(sp)
  800b6a:	080b2783          	lw	a5,128(s6)
  800b6e:	e6be                	sd	a5,328(sp)
  800b70:	0a8b2783          	lw	a5,168(s6)
  800b74:	fe3e                	sd	a5,312(sp)
  800b76:	0d0b2783          	lw	a5,208(s6)
  800b7a:	f63e                	sd	a5,296(sp)
  800b7c:	0f8b2783          	lw	a5,248(s6)
  800b80:	f23e                	sd	a5,288(sp)
  800b82:	120b2783          	lw	a5,288(s6)
  800b86:	ea3e                	sd	a5,272(sp)
  800b88:	148b2783          	lw	a5,328(s6)
  800b8c:	e63e                	sd	a5,264(sp)
  800b8e:	170b2783          	lw	a5,368(s6)
  800b92:	fdbe                	sd	a5,248(sp)
  800b94:	00cb2783          	lw	a5,12(s6)
  800b98:	f1be                	sd	a5,224(sp)
  800b9a:	034b2783          	lw	a5,52(s6)
  800b9e:	edbe                	sd	a5,216(sp)
  800ba0:	05cb2783          	lw	a5,92(s6)
  800ba4:	e9be                	sd	a5,208(sp)
  800ba6:	084b2783          	lw	a5,132(s6)
  800baa:	e1be                	sd	a5,192(sp)
  800bac:	0acb2783          	lw	a5,172(s6)
  800bb0:	f93e                	sd	a5,176(sp)
  800bb2:	0d4b2783          	lw	a5,212(s6)
  800bb6:	f53e                	sd	a5,168(sp)
  800bb8:	0fcb2783          	lw	a5,252(s6)
  800bbc:	ed3e                	sd	a5,152(sp)
  800bbe:	124b2783          	lw	a5,292(s6)
  800bc2:	e93e                	sd	a5,144(sp)
  800bc4:	14cb2783          	lw	a5,332(s6)
  800bc8:	e13e                	sd	a5,128(sp)
  800bca:	174b2783          	lw	a5,372(s6)
  800bce:	fcbe                	sd	a5,120(sp)
  800bd0:	010b2783          	lw	a5,16(s6)
  800bd4:	f4be                	sd	a5,104(sp)
  800bd6:	038b2783          	lw	a5,56(s6)
  800bda:	f0be                	sd	a5,96(sp)
  800bdc:	060b2783          	lw	a5,96(s6)
  800be0:	ecbe                	sd	a5,88(sp)
  800be2:	088b2783          	lw	a5,136(s6)
  800be6:	e4be                	sd	a5,72(sp)
  800be8:	0b0b2783          	lw	a5,176(s6)
  800bec:	e0be                	sd	a5,64(sp)
  800bee:	0d8b2783          	lw	a5,216(s6)
  800bf2:	fc3e                	sd	a5,56(sp)
  800bf4:	100b2783          	lw	a5,256(s6)
  800bf8:	f83e                	sd	a5,48(sp)
  800bfa:	128b2783          	lw	a5,296(s6)
  800bfe:	f43e                	sd	a5,40(sp)
  800c00:	150b2783          	lw	a5,336(s6)
  800c04:	f03e                	sd	a5,32(sp)
  800c06:	178b2783          	lw	a5,376(s6)
  800c0a:	ec3e                	sd	a5,24(sp)
  800c0c:	014b2783          	lw	a5,20(s6)
  800c10:	e83e                	sd	a5,16(sp)
  800c12:	03cb2783          	lw	a5,60(s6)
  800c16:	e43e                	sd	a5,8(sp)
  800c18:	064b2783          	lw	a5,100(s6)
  800c1c:	fd3e                	sd	a5,184(sp)
  800c1e:	08cb2783          	lw	a5,140(s6)
  800c22:	f13e                	sd	a5,160(sp)
  800c24:	0b4b2783          	lw	a5,180(s6)
  800c28:	28f13823          	sd	a5,656(sp)
  800c2c:	0dcb2783          	lw	a5,220(s6)
  800c30:	28f13c23          	sd	a5,664(sp)
  800c34:	104b2783          	lw	a5,260(s6)
  800c38:	e53e                	sd	a5,136(sp)
  800c3a:	12cb2783          	lw	a5,300(s6)
  800c3e:	f8be                	sd	a5,112(sp)
  800c40:	154b2783          	lw	a5,340(s6)
  800c44:	28f13023          	sd	a5,640(sp)
  800c48:	17cb2783          	lw	a5,380(s6)
  800c4c:	28f13423          	sd	a5,648(sp)
  800c50:	018b2783          	lw	a5,24(s6)
  800c54:	26f13c23          	sd	a5,632(sp)
  800c58:	040b2783          	lw	a5,64(s6)
  800c5c:	e8be                	sd	a5,80(sp)
  800c5e:	068b2783          	lw	a5,104(s6)
  800c62:	e33e                	sd	a5,384(sp)
  800c64:	090b2783          	lw	a5,144(s6)
  800c68:	26f13823          	sd	a5,624(sp)
  800c6c:	0b8b2783          	lw	a5,184(s6)
  800c70:	fbbe                	sd	a5,496(sp)
  800c72:	0e0b2783          	lw	a5,224(s6)
  800c76:	f3be                	sd	a5,480(sp)
  800c78:	108b2783          	lw	a5,264(s6)
  800c7c:	26f13023          	sd	a5,608(sp)
  800c80:	130b2783          	lw	a5,304(s6)
  800c84:	26f13423          	sd	a5,616(sp)
  800c88:	158b2783          	lw	a5,344(s6)
  800c8c:	ebbe                	sd	a5,464(sp)
  800c8e:	180b2783          	lw	a5,384(s6)
  800c92:	e3be                	sd	a5,448(sp)
  800c94:	01cb2783          	lw	a5,28(s6)
  800c98:	f73e                	sd	a5,424(sp)
  800c9a:	044b2783          	lw	a5,68(s6)
  800c9e:	24f13823          	sd	a5,592(sp)
  800ca2:	06cb2783          	lw	a5,108(s6)
  800ca6:	24f13c23          	sd	a5,600(sp)
  800caa:	094b2783          	lw	a5,148(s6)
  800cae:	eb3e                	sd	a5,400(sp)
  800cb0:	0bcb2783          	lw	a5,188(s6)
  800cb4:	e5be                	sd	a5,200(sp)
  800cb6:	0e4b2783          	lw	a5,228(s6)
  800cba:	ffbe                	sd	a5,504(sp)
  800cbc:	10cb2783          	lw	a5,268(s6)
  800cc0:	2af13023          	sd	a5,672(sp)
  800cc4:	134b2783          	lw	a5,308(s6)
  800cc8:	2af13423          	sd	a5,680(sp)
  800ccc:	15cb2783          	lw	a5,348(s6)
  800cd0:	2af13823          	sd	a5,688(sp)
  800cd4:	184b2783          	lw	a5,388(s6)
  800cd8:	2af13c23          	sd	a5,696(sp)
  800cdc:	020b2783          	lw	a5,32(s6)
  800ce0:	2cf13023          	sd	a5,704(sp)
  800ce4:	048b2783          	lw	a5,72(s6)
  800ce8:	2cf13423          	sd	a5,712(sp)
  800cec:	070b2783          	lw	a5,112(s6)
  800cf0:	2cf13823          	sd	a5,720(sp)
  800cf4:	098b2783          	lw	a5,152(s6)
  800cf8:	2cf13c23          	sd	a5,728(sp)
  800cfc:	0c0b2783          	lw	a5,192(s6)
  800d00:	2ef13023          	sd	a5,736(sp)
  800d04:	0e8b2783          	lw	a5,232(s6)
  800d08:	2ef13423          	sd	a5,744(sp)
  800d0c:	110b2783          	lw	a5,272(s6)
  800d10:	2ef13823          	sd	a5,752(sp)
  800d14:	138b2783          	lw	a5,312(s6)
  800d18:	2ef13c23          	sd	a5,760(sp)
  800d1c:	160b2783          	lw	a5,352(s6)
  800d20:	30f13023          	sd	a5,768(sp)
  800d24:	188b2783          	lw	a5,392(s6)
  800d28:	30f13423          	sd	a5,776(sp)
  800d2c:	024b2783          	lw	a5,36(s6)
  800d30:	f5be                	sd	a5,232(sp)
  800d32:	04cb2783          	lw	a5,76(s6)
  800d36:	f9be                	sd	a5,240(sp)
  800d38:	074b2783          	lw	a5,116(s6)
  800d3c:	e23e                	sd	a5,256(sp)
  800d3e:	09cb2783          	lw	a5,156(s6)
  800d42:	ee3e                	sd	a5,280(sp)
  800d44:	0c4b2783          	lw	a5,196(s6)
  800d48:	fa3e                	sd	a5,304(sp)
  800d4a:	0ecb2783          	lw	a5,236(s6)
  800d4e:	e2be                	sd	a5,320(sp)
  800d50:	114b2783          	lw	a5,276(s6)
  800d54:	eebe                	sd	a5,344(sp)
  800d56:	13cb2783          	lw	a5,316(s6)
  800d5a:	fabe                	sd	a5,368(sp)
  800d5c:	164b2783          	lw	a5,356(s6)
  800d60:	31713823          	sd	s7,784(sp)
  800d64:	febe                	sd	a5,376(sp)
  800d66:	18cb2783          	lw	a5,396(s6)
  800d6a:	e73e                	sd	a5,392(sp)
  800d6c:	00032883          	lw	a7,0(t1)
  800d70:	00432f03          	lw	t5,4(t1)
  800d74:	23013403          	ld	s0,560(sp)
  800d78:	039887bb          	mulw	a5,a7,s9
  800d7c:	7296                	ld	t0,352(sp)
  800d7e:	6942                	ld	s2,16(sp)
  800d80:	25013983          	ld	s3,592(sp)
  800d84:	7bae                	ld	s7,232(sp)
  800d86:	2c013d83          	ld	s11,704(sp)
  800d8a:	00832803          	lw	a6,8(t1)
  800d8e:	00c32503          	lw	a0,12(t1)
  800d92:	01032583          	lw	a1,16(t1)
  800d96:	01432603          	lw	a2,20(t1)
  800d9a:	038f04bb          	mulw	s1,t5,s8
  800d9e:	01832683          	lw	a3,24(t1)
  800da2:	01c32703          	lw	a4,28(t1)
  800da6:	02032e83          	lw	t4,32(t1)
  800daa:	02432e03          	lw	t3,36(t1)
        for (i = 0; i < size; i ++) {
  800dae:	028f8f93          	addi	t6,t6,40
  800db2:	02830313          	addi	t1,t1,40
                    matc[i][j] += mata[i][k] * matb[k][j];
  800db6:	9cbd                	addw	s1,s1,a5
  800db8:	23813783          	ld	a5,568(sp)
  800dbc:	028f043b          	mulw	s0,t5,s0
  800dc0:	02f887bb          	mulw	a5,a7,a5
  800dc4:	9c3d                	addw	s0,s0,a5
  800dc6:	77b6                	ld	a5,360(sp)
  800dc8:	025f00bb          	mulw	ra,t5,t0
  800dcc:	62ee                	ld	t0,216(sp)
  800dce:	02f887bb          	mulw	a5,a7,a5
  800dd2:	00f080bb          	addw	ra,ra,a5
  800dd6:	778e                	ld	a5,224(sp)
  800dd8:	03e283bb          	mulw	t2,t0,t5
  800ddc:	7286                	ld	t0,96(sp)
  800dde:	031787bb          	mulw	a5,a5,a7
  800de2:	00f383bb          	addw	t2,t2,a5
  800de6:	77a6                	ld	a5,104(sp)
  800de8:	03e282bb          	mulw	t0,t0,t5
  800dec:	031787bb          	mulw	a5,a5,a7
  800df0:	00f282bb          	addw	t0,t0,a5
  800df4:	67a2                	ld	a5,8(sp)
  800df6:	03190d3b          	mulw	s10,s2,a7
  800dfa:	27813903          	ld	s2,632(sp)
  800dfe:	03e787bb          	mulw	a5,a5,t5
  800e02:	00fd0d3b          	addw	s10,s10,a5
  800e06:	67c6                	ld	a5,80(sp)
  800e08:	0328893b          	mulw	s2,a7,s2
  800e0c:	03e787bb          	mulw	a5,a5,t5
  800e10:	00f907bb          	addw	a5,s2,a5
  800e14:	793a                	ld	s2,424(sp)
  800e16:	033f09bb          	mulw	s3,t5,s3
  800e1a:	0328893b          	mulw	s2,a7,s2
  800e1e:	03b88dbb          	mulw	s11,a7,s11
  800e22:	012989bb          	addw	s3,s3,s2
  800e26:	2c813903          	ld	s2,712(sp)
  800e2a:	037888bb          	mulw	a7,a7,s7
  800e2e:	7bce                	ld	s7,240(sp)
  800e30:	032f093b          	mulw	s2,t5,s2
  800e34:	037f0f3b          	mulw	t5,t5,s7
  800e38:	31013b83          	ld	s7,784(sp)
  800e3c:	012d893b          	addw	s2,s11,s2
  800e40:	01e888bb          	addw	a7,a7,t5
  800e44:	22813f03          	ld	t5,552(sp)
  800e48:	03780dbb          	mulw	s11,a6,s7
  800e4c:	6bd6                	ld	s7,336(sp)
  800e4e:	03e80f3b          	mulw	t5,a6,t5
  800e52:	01b484bb          	addw	s1,s1,s11
  800e56:	03780dbb          	mulw	s11,a6,s7
  800e5a:	01e4043b          	addw	s0,s0,t5
  800e5e:	6f4e                	ld	t5,208(sp)
  800e60:	6be6                	ld	s7,88(sp)
  800e62:	030f0f3b          	mulw	t5,t5,a6
  800e66:	01b080bb          	addw	ra,ra,s11
  800e6a:	030b8dbb          	mulw	s11,s7,a6
  800e6e:	01e383bb          	addw	t2,t2,t5
  800e72:	7f6a                	ld	t5,184(sp)
  800e74:	6b9a                	ld	s7,384(sp)
  800e76:	030f0f3b          	mulw	t5,t5,a6
  800e7a:	01b282bb          	addw	t0,t0,s11
  800e7e:	03780dbb          	mulw	s11,a6,s7
  800e82:	25813b83          	ld	s7,600(sp)
  800e86:	01ed0f3b          	addw	t5,s10,t5
  800e8a:	03780d3b          	mulw	s10,a6,s7
  800e8e:	2d013b83          	ld	s7,720(sp)
  800e92:	01b787bb          	addw	a5,a5,s11
  800e96:	03780dbb          	mulw	s11,a6,s7
  800e9a:	6b92                	ld	s7,256(sp)
  800e9c:	01a989bb          	addw	s3,s3,s10
  800ea0:	0378083b          	mulw	a6,a6,s7
  800ea4:	01b90dbb          	addw	s11,s2,s11
  800ea8:	795a                	ld	s2,432(sp)
  800eaa:	0108883b          	addw	a6,a7,a6
  800eae:	22013883          	ld	a7,544(sp)
  800eb2:	0325093b          	mulw	s2,a0,s2
  800eb6:	031508bb          	mulw	a7,a0,a7
  800eba:	0124893b          	addw	s2,s1,s2
  800ebe:	64b6                	ld	s1,328(sp)
  800ec0:	011408bb          	addw	a7,s0,a7
  800ec4:	640e                	ld	s0,192(sp)
  800ec6:	029504bb          	mulw	s1,a0,s1
  800eca:	02a4043b          	mulw	s0,s0,a0
  800ece:	009084bb          	addw	s1,ra,s1
  800ed2:	60a6                	ld	ra,72(sp)
  800ed4:	0083843b          	addw	s0,t2,s0
  800ed8:	738a                	ld	t2,160(sp)
  800eda:	02a080bb          	mulw	ra,ra,a0
  800ede:	02a383bb          	mulw	t2,t2,a0
  800ee2:	001282bb          	addw	t0,t0,ra
  800ee6:	27013083          	ld	ra,624(sp)
  800eea:	007f03bb          	addw	t2,t5,t2
  800eee:	6f5a                	ld	t5,400(sp)
  800ef0:	021500bb          	mulw	ra,a0,ra
  800ef4:	03e50f3b          	mulw	t5,a0,t5
  800ef8:	001787bb          	addw	a5,a5,ra
  800efc:	2d813083          	ld	ra,728(sp)
  800f00:	01e989bb          	addw	s3,s3,t5
  800f04:	6f72                	ld	t5,280(sp)
  800f06:	021500bb          	mulw	ra,a0,ra
  800f0a:	03e5053b          	mulw	a0,a0,t5
  800f0e:	20013f03          	ld	t5,512(sp)
  800f12:	001d8dbb          	addw	s11,s11,ra
  800f16:	00a8053b          	addw	a0,a6,a0
  800f1a:	21813803          	ld	a6,536(sp)
  800f1e:	03e58f3b          	mulw	t5,a1,t5
  800f22:	0305883b          	mulw	a6,a1,a6
  800f26:	01e9093b          	addw	s2,s2,t5
  800f2a:	7f72                	ld	t5,312(sp)
  800f2c:	0108883b          	addw	a6,a7,a6
  800f30:	78ca                	ld	a7,176(sp)
  800f32:	03e580bb          	mulw	ra,a1,t5
  800f36:	6f06                	ld	t5,64(sp)
  800f38:	02b888bb          	mulw	a7,a7,a1
  800f3c:	001484bb          	addw	s1,s1,ra
  800f40:	0114043b          	addw	s0,s0,a7
  800f44:	29013883          	ld	a7,656(sp)
  800f48:	02bf0f3b          	mulw	t5,t5,a1
  800f4c:	031580bb          	mulw	ra,a1,a7
  800f50:	78de                	ld	a7,496(sp)
  800f52:	01e282bb          	addw	t0,t0,t5
  800f56:	6f2e                	ld	t5,200(sp)
  800f58:	031588bb          	mulw	a7,a1,a7
  800f5c:	001383bb          	addw	t2,t2,ra
  800f60:	70d2                	ld	ra,304(sp)
  800f62:	011787bb          	addw	a5,a5,a7
  800f66:	2e013883          	ld	a7,736(sp)
  800f6a:	02bf0f3b          	mulw	t5,t5,a1
  800f6e:	031588bb          	mulw	a7,a1,a7
  800f72:	01e98f3b          	addw	t5,s3,t5
  800f76:	021585bb          	mulw	a1,a1,ra
  800f7a:	011d8dbb          	addw	s11,s11,a7
  800f7e:	68fe                	ld	a7,472(sp)
  800f80:	9da9                	addw	a1,a1,a0
  800f82:	21013503          	ld	a0,528(sp)
  800f86:	031600bb          	mulw	ra,a2,a7
  800f8a:	78b2                	ld	a7,296(sp)
  800f8c:	02a6053b          	mulw	a0,a2,a0
  800f90:	0019093b          	addw	s2,s2,ra
  800f94:	00a8053b          	addw	a0,a6,a0
  800f98:	782a                	ld	a6,168(sp)
  800f9a:	02c888bb          	mulw	a7,a7,a2
  800f9e:	02c8083b          	mulw	a6,a6,a2
  800fa2:	011484bb          	addw	s1,s1,a7
  800fa6:	78e2                	ld	a7,56(sp)
  800fa8:	0104043b          	addw	s0,s0,a6
  800fac:	29813803          	ld	a6,664(sp)
  800fb0:	02c880bb          	mulw	ra,a7,a2
  800fb4:	030608bb          	mulw	a7,a2,a6
  800fb8:	781e                	ld	a6,480(sp)
  800fba:	001282bb          	addw	t0,t0,ra
  800fbe:	0306083b          	mulw	a6,a2,a6
  800fc2:	011380bb          	addw	ra,t2,a7
  800fc6:	78fe                	ld	a7,504(sp)
  800fc8:	010787bb          	addw	a5,a5,a6
  800fcc:	031603bb          	mulw	t2,a2,a7
  800fd0:	2e813803          	ld	a6,744(sp)
  800fd4:	6896                	ld	a7,320(sp)
  800fd6:	0306083b          	mulw	a6,a2,a6
  800fda:	007f0f3b          	addw	t5,t5,t2
  800fde:	0316063b          	mulw	a2,a2,a7
  800fe2:	010d8dbb          	addw	s11,s11,a6
  800fe6:	787a                	ld	a6,440(sp)
  800fe8:	9e2d                	addw	a2,a2,a1
  800fea:	20813583          	ld	a1,520(sp)
  800fee:	030688bb          	mulw	a7,a3,a6
  800ff2:	7812                	ld	a6,288(sp)
  800ff4:	02b685bb          	mulw	a1,a3,a1
  800ff8:	0119093b          	addw	s2,s2,a7
  800ffc:	9da9                	addw	a1,a1,a0
  800ffe:	656a                	ld	a0,152(sp)
  801000:	02d8083b          	mulw	a6,a6,a3
  801004:	02d5053b          	mulw	a0,a0,a3
  801008:	010484bb          	addw	s1,s1,a6
  80100c:	7842                	ld	a6,48(sp)
  80100e:	9c29                	addw	s0,s0,a0
  801010:	652a                	ld	a0,136(sp)
  801012:	02d808bb          	mulw	a7,a6,a3
  801016:	02d5083b          	mulw	a6,a0,a3
  80101a:	26013503          	ld	a0,608(sp)
  80101e:	011282bb          	addw	t0,t0,a7
  801022:	02a6853b          	mulw	a0,a3,a0
  801026:	010083bb          	addw	t2,ra,a6
  80102a:	2a013803          	ld	a6,672(sp)
  80102e:	9fa9                	addw	a5,a5,a0
  801030:	030688bb          	mulw	a7,a3,a6
  801034:	2f013503          	ld	a0,752(sp)
  801038:	6876                	ld	a6,344(sp)
  80103a:	02a6853b          	mulw	a0,a3,a0
  80103e:	011f0f3b          	addw	t5,t5,a7
  801042:	030686bb          	mulw	a3,a3,a6
  801046:	00ad8dbb          	addw	s11,s11,a0
  80104a:	657a                	ld	a0,408(sp)
  80104c:	9eb1                	addw	a3,a3,a2
  80104e:	763e                	ld	a2,488(sp)
  801050:	02a7083b          	mulw	a6,a4,a0
  801054:	6552                	ld	a0,272(sp)
  801056:	02c7063b          	mulw	a2,a4,a2
  80105a:	0109093b          	addw	s2,s2,a6
  80105e:	9e2d                	addw	a2,a2,a1
  801060:	65ca                	ld	a1,144(sp)
  801062:	02e5053b          	mulw	a0,a0,a4
  801066:	02e585bb          	mulw	a1,a1,a4
  80106a:	9ca9                	addw	s1,s1,a0
  80106c:	7522                	ld	a0,40(sp)
  80106e:	9c2d                	addw	s0,s0,a1
  801070:	75c6                	ld	a1,112(sp)
  801072:	02e5083b          	mulw	a6,a0,a4
  801076:	02e5853b          	mulw	a0,a1,a4
  80107a:	26813583          	ld	a1,616(sp)
  80107e:	010282bb          	addw	t0,t0,a6
  801082:	02b705bb          	mulw	a1,a4,a1
  801086:	00a383bb          	addw	t2,t2,a0
  80108a:	2a813503          	ld	a0,680(sp)
  80108e:	9fad                	addw	a5,a5,a1
  801090:	02a7083b          	mulw	a6,a4,a0
  801094:	2f813583          	ld	a1,760(sp)
  801098:	7556                	ld	a0,368(sp)
  80109a:	02b705bb          	mulw	a1,a4,a1
  80109e:	010f0f3b          	addw	t5,t5,a6
  8010a2:	02a7073b          	mulw	a4,a4,a0
  8010a6:	00bd8dbb          	addw	s11,s11,a1
  8010aa:	24813583          	ld	a1,584(sp)
  8010ae:	9f35                	addw	a4,a4,a3
  8010b0:	66be                	ld	a3,456(sp)
  8010b2:	02be853b          	mulw	a0,t4,a1
  8010b6:	65b2                	ld	a1,264(sp)
  8010b8:	02de86bb          	mulw	a3,t4,a3
  8010bc:	00a9093b          	addw	s2,s2,a0
  8010c0:	9eb1                	addw	a3,a3,a2
  8010c2:	660a                	ld	a2,128(sp)
  8010c4:	03d585bb          	mulw	a1,a1,t4
  8010c8:	03d6063b          	mulw	a2,a2,t4
  8010cc:	9cad                	addw	s1,s1,a1
  8010ce:	7582                	ld	a1,32(sp)
  8010d0:	9c31                	addw	s0,s0,a2
  8010d2:	28013603          	ld	a2,640(sp)
  8010d6:	03d5853b          	mulw	a0,a1,t4
  8010da:	02ce85bb          	mulw	a1,t4,a2
  8010de:	665e                	ld	a2,464(sp)
  8010e0:	00a282bb          	addw	t0,t0,a0
  8010e4:	02ce863b          	mulw	a2,t4,a2
  8010e8:	00b383bb          	addw	t2,t2,a1
  8010ec:	2b013583          	ld	a1,688(sp)
  8010f0:	9fb1                	addw	a5,a5,a2
  8010f2:	02be853b          	mulw	a0,t4,a1
  8010f6:	30013603          	ld	a2,768(sp)
  8010fa:	75f6                	ld	a1,376(sp)
  8010fc:	02ce863b          	mulw	a2,t4,a2
  801100:	00af0f3b          	addw	t5,t5,a0
  801104:	02be8ebb          	mulw	t4,t4,a1
  801108:	759a                	ld	a1,416(sp)
  80110a:	00cd8dbb          	addw	s11,s11,a2
  80110e:	24013603          	ld	a2,576(sp)
  801112:	02be05bb          	mulw	a1,t3,a1
  801116:	01d7073b          	addw	a4,a4,t4
  80111a:	9ead                	addw	a3,a3,a1
  80111c:	fcdfae23          	sw	a3,-36(t6)
  801120:	76e6                	ld	a3,120(sp)
  801122:	02ce063b          	mulw	a2,t3,a2
  801126:	03c686bb          	mulw	a3,a3,t3
  80112a:	00c9093b          	addw	s2,s2,a2
  80112e:	766e                	ld	a2,248(sp)
  801130:	fd2fac23          	sw	s2,-40(t6)
  801134:	9c35                	addw	s0,s0,a3
  801136:	28813683          	ld	a3,648(sp)
  80113a:	03c6053b          	mulw	a0,a2,t3
  80113e:	6662                	ld	a2,24(sp)
  801140:	fe8fa223          	sw	s0,-28(t6)
  801144:	02de06bb          	mulw	a3,t3,a3
  801148:	9ca9                	addw	s1,s1,a0
  80114a:	fe9fa023          	sw	s1,-32(t6)
  80114e:	03c605bb          	mulw	a1,a2,t3
  801152:	661e                	ld	a2,448(sp)
  801154:	00d383bb          	addw	t2,t2,a3
  801158:	2b813683          	ld	a3,696(sp)
  80115c:	fe7fa623          	sw	t2,-20(t6)
  801160:	02ce063b          	mulw	a2,t3,a2
  801164:	00b282bb          	addw	t0,t0,a1
  801168:	fe5fa423          	sw	t0,-24(t6)
  80116c:	02de06bb          	mulw	a3,t3,a3
  801170:	9fb1                	addw	a5,a5,a2
  801172:	feffa823          	sw	a5,-16(t6)
  801176:	30813783          	ld	a5,776(sp)
  80117a:	00df0f3b          	addw	t5,t5,a3
  80117e:	66ba                	ld	a3,392(sp)
  801180:	02fe07bb          	mulw	a5,t3,a5
  801184:	ffefaa23          	sw	t5,-12(t6)
  801188:	02de0e3b          	mulw	t3,t3,a3
  80118c:	00fd8dbb          	addw	s11,s11,a5
  801190:	ffbfac23          	sw	s11,-8(t6)
        for (i = 0; i < size; i ++) {
  801194:	00001797          	auipc	a5,0x1
  801198:	00478793          	addi	a5,a5,4 # 802198 <matb>
                    matc[i][j] += mata[i][k] * matb[k][j];
  80119c:	01c7073b          	addw	a4,a4,t3
  8011a0:	feefae23          	sw	a4,-4(t6)
        for (i = 0; i < size; i ++) {
  8011a4:	bc6794e3          	bne	a5,t1,800d6c <work+0x4b6>
                }
            }
        }
        for (i = 0; i < size; i ++) {
            for (j = 0; j < size; j ++) {
                mata[i][j] = matb[i][j] = matc[i][j];
  8011a8:	000a3d83          	ld	s11,0(s4)
  8011ac:	008a3d03          	ld	s10,8(s4)
  8011b0:	010a3c83          	ld	s9,16(s4)
  8011b4:	018a3c03          	ld	s8,24(s4)
  8011b8:	020a3b83          	ld	s7,32(s4)
  8011bc:	028a3983          	ld	s3,40(s4)
  8011c0:	030a3903          	ld	s2,48(s4)
  8011c4:	0c0a3783          	ld	a5,192(s4)
  8011c8:	038a3483          	ld	s1,56(s4)
  8011cc:	01bb3023          	sd	s11,0(s6)
  8011d0:	01ab3423          	sd	s10,8(s6)
  8011d4:	019b3823          	sd	s9,16(s6)
  8011d8:	018b3c23          	sd	s8,24(s6)
  8011dc:	037b3023          	sd	s7,32(s6)
  8011e0:	033b3423          	sd	s3,40(s6)
  8011e4:	032b3823          	sd	s2,48(s6)
  8011e8:	0b8a3703          	ld	a4,184(s4)
  8011ec:	040a3403          	ld	s0,64(s4)
  8011f0:	048a3083          	ld	ra,72(s4)
  8011f4:	050a3383          	ld	t2,80(s4)
  8011f8:	058a3283          	ld	t0,88(s4)
  8011fc:	060a3f83          	ld	t6,96(s4)
  801200:	068a3f03          	ld	t5,104(s4)
  801204:	070a3e83          	ld	t4,112(s4)
  801208:	078a3e03          	ld	t3,120(s4)
  80120c:	080a3303          	ld	t1,128(s4)
  801210:	088a3883          	ld	a7,136(s4)
  801214:	090a3803          	ld	a6,144(s4)
  801218:	098a3503          	ld	a0,152(s4)
  80121c:	0a0a3583          	ld	a1,160(s4)
  801220:	0a8a3603          	ld	a2,168(s4)
  801224:	0b0a3683          	ld	a3,176(s4)
  801228:	029b3c23          	sd	s1,56(s6)
  80122c:	e43e                	sd	a5,8(sp)
  80122e:	0cfb3023          	sd	a5,192(s6)
  801232:	0c8a3783          	ld	a5,200(s4)
  801236:	0aeb3c23          	sd	a4,184(s6)
  80123a:	048b3023          	sd	s0,64(s6)
  80123e:	0cfb3423          	sd	a5,200(s6)
  801242:	0d0a3783          	ld	a5,208(s4)
  801246:	041b3423          	sd	ra,72(s6)
  80124a:	047b3823          	sd	t2,80(s6)
  80124e:	0cfb3823          	sd	a5,208(s6)
  801252:	0d8a3783          	ld	a5,216(s4)
  801256:	045b3c23          	sd	t0,88(s6)
  80125a:	07fb3023          	sd	t6,96(s6)
  80125e:	0cfb3c23          	sd	a5,216(s6)
  801262:	0e0a3783          	ld	a5,224(s4)
  801266:	07eb3423          	sd	t5,104(s6)
  80126a:	07db3823          	sd	t4,112(s6)
  80126e:	0efb3023          	sd	a5,224(s6)
  801272:	0e8a3783          	ld	a5,232(s4)
  801276:	07cb3c23          	sd	t3,120(s6)
  80127a:	086b3023          	sd	t1,128(s6)
  80127e:	0efb3423          	sd	a5,232(s6)
  801282:	0f0a3783          	ld	a5,240(s4)
  801286:	091b3423          	sd	a7,136(s6)
  80128a:	090b3823          	sd	a6,144(s6)
  80128e:	0efb3823          	sd	a5,240(s6)
  801292:	0f8a3783          	ld	a5,248(s4)
  801296:	08ab3c23          	sd	a0,152(s6)
  80129a:	0abb3023          	sd	a1,160(s6)
  80129e:	0acb3423          	sd	a2,168(s6)
  8012a2:	0adb3823          	sd	a3,176(s6)
  8012a6:	0efb3c23          	sd	a5,248(s6)
  8012aa:	100a3783          	ld	a5,256(s4)
  8012ae:	10fb3023          	sd	a5,256(s6)
  8012b2:	108a3783          	ld	a5,264(s4)
  8012b6:	10fb3423          	sd	a5,264(s6)
  8012ba:	110a3783          	ld	a5,272(s4)
  8012be:	10fb3823          	sd	a5,272(s6)
  8012c2:	118a3783          	ld	a5,280(s4)
  8012c6:	10fb3c23          	sd	a5,280(s6)
  8012ca:	120a3783          	ld	a5,288(s4)
  8012ce:	12fb3023          	sd	a5,288(s6)
  8012d2:	128a3783          	ld	a5,296(s4)
  8012d6:	12fb3423          	sd	a5,296(s6)
  8012da:	130a3783          	ld	a5,304(s4)
  8012de:	12fb3823          	sd	a5,304(s6)
  8012e2:	138a3783          	ld	a5,312(s4)
  8012e6:	12fb3c23          	sd	a5,312(s6)
  8012ea:	140a3783          	ld	a5,320(s4)
  8012ee:	14fb3023          	sd	a5,320(s6)
  8012f2:	148a3783          	ld	a5,328(s4)
  8012f6:	14fb3423          	sd	a5,328(s6)
  8012fa:	150a3783          	ld	a5,336(s4)
  8012fe:	14fb3823          	sd	a5,336(s6)
  801302:	158a3783          	ld	a5,344(s4)
  801306:	14fb3c23          	sd	a5,344(s6)
  80130a:	160a3783          	ld	a5,352(s4)
  80130e:	16fb3023          	sd	a5,352(s6)
  801312:	168a3783          	ld	a5,360(s4)
  801316:	16fb3423          	sd	a5,360(s6)
  80131a:	170a3783          	ld	a5,368(s4)
  80131e:	16fb3823          	sd	a5,368(s6)
  801322:	178a3783          	ld	a5,376(s4)
  801326:	16fb3c23          	sd	a5,376(s6)
  80132a:	180a3783          	ld	a5,384(s4)
  80132e:	0aeabc23          	sd	a4,184(s5)
  801332:	01bab023          	sd	s11,0(s5)
  801336:	18fb3023          	sd	a5,384(s6)
  80133a:	188a3783          	ld	a5,392(s4)
  80133e:	01aab423          	sd	s10,8(s5)
  801342:	019ab823          	sd	s9,16(s5)
  801346:	18fb3423          	sd	a5,392(s6)
  80134a:	67a2                	ld	a5,8(sp)
  80134c:	018abc23          	sd	s8,24(s5)
  801350:	037ab023          	sd	s7,32(s5)
  801354:	0cfab023          	sd	a5,192(s5)
  801358:	0c8a3783          	ld	a5,200(s4)
  80135c:	033ab423          	sd	s3,40(s5)
  801360:	032ab823          	sd	s2,48(s5)
  801364:	029abc23          	sd	s1,56(s5)
  801368:	048ab023          	sd	s0,64(s5)
  80136c:	041ab423          	sd	ra,72(s5)
  801370:	047ab823          	sd	t2,80(s5)
  801374:	045abc23          	sd	t0,88(s5)
  801378:	07fab023          	sd	t6,96(s5)
  80137c:	07eab423          	sd	t5,104(s5)
  801380:	07dab823          	sd	t4,112(s5)
  801384:	07cabc23          	sd	t3,120(s5)
  801388:	086ab023          	sd	t1,128(s5)
  80138c:	091ab423          	sd	a7,136(s5)
  801390:	090ab823          	sd	a6,144(s5)
  801394:	08aabc23          	sd	a0,152(s5)
  801398:	0abab023          	sd	a1,160(s5)
  80139c:	0acab423          	sd	a2,168(s5)
  8013a0:	0adab823          	sd	a3,176(s5)
  8013a4:	0cfab423          	sd	a5,200(s5)
  8013a8:	0d0a3783          	ld	a5,208(s4)
  8013ac:	0f8a3703          	ld	a4,248(s4)
  8013b0:	0cfab823          	sd	a5,208(s5)
  8013b4:	0eeabc23          	sd	a4,248(s5)
  8013b8:	100a3703          	ld	a4,256(s4)
  8013bc:	0d8a3783          	ld	a5,216(s4)
  8013c0:	10eab023          	sd	a4,256(s5)
  8013c4:	108a3703          	ld	a4,264(s4)
  8013c8:	0cfabc23          	sd	a5,216(s5)
  8013cc:	0e0a3783          	ld	a5,224(s4)
  8013d0:	10eab423          	sd	a4,264(s5)
  8013d4:	110a3703          	ld	a4,272(s4)
  8013d8:	0efab023          	sd	a5,224(s5)
  8013dc:	0e8a3783          	ld	a5,232(s4)
  8013e0:	10eab823          	sd	a4,272(s5)
  8013e4:	118a3703          	ld	a4,280(s4)
  8013e8:	0efab423          	sd	a5,232(s5)
  8013ec:	0f0a3783          	ld	a5,240(s4)
  8013f0:	10eabc23          	sd	a4,280(s5)
  8013f4:	120a3703          	ld	a4,288(s4)
  8013f8:	0efab823          	sd	a5,240(s5)
    while (times -- > 0) {
  8013fc:	31813783          	ld	a5,792(sp)
                mata[i][j] = matb[i][j] = matc[i][j];
  801400:	12eab023          	sd	a4,288(s5)
  801404:	128a3703          	ld	a4,296(s4)
    while (times -- > 0) {
  801408:	37fd                	addiw	a5,a5,-1
  80140a:	30f13c23          	sd	a5,792(sp)
                mata[i][j] = matb[i][j] = matc[i][j];
  80140e:	12eab423          	sd	a4,296(s5)
  801412:	130a3703          	ld	a4,304(s4)
  801416:	12eab823          	sd	a4,304(s5)
  80141a:	138a3703          	ld	a4,312(s4)
  80141e:	12eabc23          	sd	a4,312(s5)
  801422:	140a3703          	ld	a4,320(s4)
  801426:	14eab023          	sd	a4,320(s5)
  80142a:	148a3703          	ld	a4,328(s4)
  80142e:	14eab423          	sd	a4,328(s5)
  801432:	150a3703          	ld	a4,336(s4)
  801436:	14eab823          	sd	a4,336(s5)
  80143a:	158a3703          	ld	a4,344(s4)
  80143e:	14eabc23          	sd	a4,344(s5)
  801442:	160a3703          	ld	a4,352(s4)
  801446:	16eab023          	sd	a4,352(s5)
  80144a:	168a3703          	ld	a4,360(s4)
  80144e:	16eab423          	sd	a4,360(s5)
  801452:	170a3703          	ld	a4,368(s4)
  801456:	16eab823          	sd	a4,368(s5)
  80145a:	178a3703          	ld	a4,376(s4)
  80145e:	16eabc23          	sd	a4,376(s5)
  801462:	180a3703          	ld	a4,384(s4)
  801466:	18eab023          	sd	a4,384(s5)
  80146a:	188a3703          	ld	a4,392(s4)
  80146e:	18eab423          	sd	a4,392(s5)
    while (times -- > 0) {
  801472:	577d                	li	a4,-1
  801474:	e4e79763          	bne	a5,a4,800ac2 <work+0x20c>
            }
        }
    }
    cprintf("pid %d done!.\n", getpid());
  801478:	ce1fe0ef          	jal	ra,800158 <getpid>
  80147c:	85aa                	mv	a1,a0
  80147e:	00000517          	auipc	a0,0x0
  801482:	44a50513          	addi	a0,a0,1098 # 8018c8 <error_string+0xe8>
  801486:	c1dfe0ef          	jal	ra,8000a2 <cprintf>
    exit(0);
  80148a:	4501                	li	a0,0
  80148c:	cabfe0ef          	jal	ra,800136 <exit>

0000000000801490 <main>:
}

const int total = 21;

int
main(void) {
  801490:	7175                	addi	sp,sp,-144
  801492:	f4ce                	sd	s3,104(sp)
    int pids[total];
    memset(pids, 0, sizeof(pids));
  801494:	05400613          	li	a2,84
  801498:	4581                	li	a1,0
  80149a:	0028                	addi	a0,sp,8
  80149c:	00810993          	addi	s3,sp,8
main(void) {
  8014a0:	e122                	sd	s0,128(sp)
  8014a2:	fca6                	sd	s1,120(sp)
  8014a4:	f8ca                	sd	s2,112(sp)
  8014a6:	e506                	sd	ra,136(sp)
    memset(pids, 0, sizeof(pids));
  8014a8:	84ce                	mv	s1,s3
  8014aa:	a86ff0ef          	jal	ra,800730 <memset>

    int i;
    for (i = 0; i < total; i ++) {
  8014ae:	4401                	li	s0,0
  8014b0:	4955                	li	s2,21
        if ((pids[i] = fork()) == 0) {
  8014b2:	c9bfe0ef          	jal	ra,80014c <fork>
  8014b6:	c088                	sw	a0,0(s1)
  8014b8:	cd2d                	beqz	a0,801532 <main+0xa2>
            srand(i * i);
            int times = (((unsigned int)rand()) % total);
            times = (times * times + 10) * 100;
            work(times);
        }
        if (pids[i] < 0) {
  8014ba:	04054663          	bltz	a0,801506 <main+0x76>
    for (i = 0; i < total; i ++) {
  8014be:	2405                	addiw	s0,s0,1
  8014c0:	0491                	addi	s1,s1,4
  8014c2:	ff2418e3          	bne	s0,s2,8014b2 <main+0x22>
            goto failed;
        }
    }

    cprintf("fork ok.\n");
  8014c6:	00000517          	auipc	a0,0x0
  8014ca:	41250513          	addi	a0,a0,1042 # 8018d8 <error_string+0xf8>
  8014ce:	bd5fe0ef          	jal	ra,8000a2 <cprintf>
  8014d2:	4455                	li	s0,21

    for (i = 0; i < total; i ++) {
        if (wait() != 0) {
  8014d4:	c7bfe0ef          	jal	ra,80014e <wait>
  8014d8:	e10d                	bnez	a0,8014fa <main+0x6a>
    for (i = 0; i < total; i ++) {
  8014da:	347d                	addiw	s0,s0,-1
  8014dc:	fc65                	bnez	s0,8014d4 <main+0x44>
            cprintf("wait failed.\n");
            goto failed;
        }
    }

    cprintf("matrix pass.\n");
  8014de:	00000517          	auipc	a0,0x0
  8014e2:	41a50513          	addi	a0,a0,1050 # 8018f8 <error_string+0x118>
  8014e6:	bbdfe0ef          	jal	ra,8000a2 <cprintf>
        if (pids[i] > 0) {
            kill(pids[i]);
        }
    }
    panic("FAIL: T.T\n");
}
  8014ea:	60aa                	ld	ra,136(sp)
  8014ec:	640a                	ld	s0,128(sp)
  8014ee:	74e6                	ld	s1,120(sp)
  8014f0:	7946                	ld	s2,112(sp)
  8014f2:	79a6                	ld	s3,104(sp)
  8014f4:	4501                	li	a0,0
  8014f6:	6149                	addi	sp,sp,144
  8014f8:	8082                	ret
            cprintf("wait failed.\n");
  8014fa:	00000517          	auipc	a0,0x0
  8014fe:	3ee50513          	addi	a0,a0,1006 # 8018e8 <error_string+0x108>
  801502:	ba1fe0ef          	jal	ra,8000a2 <cprintf>
            goto failed;
  801506:	08e0                	addi	s0,sp,92
        if (pids[i] > 0) {
  801508:	0009a503          	lw	a0,0(s3)
  80150c:	00a05463          	blez	a0,801514 <main+0x84>
            kill(pids[i]);
  801510:	c47fe0ef          	jal	ra,800156 <kill>
    for (i = 0; i < total; i ++) {
  801514:	0991                	addi	s3,s3,4
  801516:	ff3419e3          	bne	s0,s3,801508 <main+0x78>
    panic("FAIL: T.T\n");
  80151a:	00000617          	auipc	a2,0x0
  80151e:	3ee60613          	addi	a2,a2,1006 # 801908 <error_string+0x128>
  801522:	05200593          	li	a1,82
  801526:	00000517          	auipc	a0,0x0
  80152a:	3f250513          	addi	a0,a0,1010 # 801918 <error_string+0x138>
  80152e:	af9fe0ef          	jal	ra,800026 <__panic>
            srand(i * i);
  801532:	0284053b          	mulw	a0,s0,s0
  801536:	9d0ff0ef          	jal	ra,800706 <srand>
            int times = (((unsigned int)rand()) % total);
  80153a:	99aff0ef          	jal	ra,8006d4 <rand>
  80153e:	47d5                	li	a5,21
  801540:	02f577bb          	remuw	a5,a0,a5
            work(times);
  801544:	06400513          	li	a0,100
            times = (times * times + 10) * 100;
  801548:	02f787bb          	mulw	a5,a5,a5
  80154c:	27a9                	addiw	a5,a5,10
            work(times);
  80154e:	02f5053b          	mulw	a0,a0,a5
  801552:	b64ff0ef          	jal	ra,8008b6 <work>
