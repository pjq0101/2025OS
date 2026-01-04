
obj/__user_forktree.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	0c2000ef          	jal	ra,8000e2 <umain>
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
  80002e:	092000ef          	jal	ra,8000c0 <sys_putc>
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
  80006a:	32a000ef          	jal	ra,800394 <vprintfmt>
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

00000000008000b4 <sys_fork>:
}

int
sys_fork(void) {
    return syscall(SYS_fork);
  8000b4:	4509                	li	a0,2
  8000b6:	b7c1                	j	800076 <syscall>

00000000008000b8 <sys_yield>:
    return syscall(SYS_wait, pid, store);
}

int
sys_yield(void) {
    return syscall(SYS_yield);
  8000b8:	4529                	li	a0,10
  8000ba:	bf75                	j	800076 <syscall>

00000000008000bc <sys_getpid>:
    return syscall(SYS_kill, pid);
}

int
sys_getpid(void) {
    return syscall(SYS_getpid);
  8000bc:	4549                	li	a0,18
  8000be:	bf65                	j	800076 <syscall>

00000000008000c0 <sys_putc>:
}

int
sys_putc(int64_t c) {
  8000c0:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  8000c2:	4579                	li	a0,30
  8000c4:	bf4d                	j	800076 <syscall>

00000000008000c6 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8000c6:	1141                	addi	sp,sp,-16
  8000c8:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  8000ca:	fe5ff0ef          	jal	ra,8000ae <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000ce:	00001517          	auipc	a0,0x1
  8000d2:	ec250513          	addi	a0,a0,-318 # 800f90 <main+0x1a>
  8000d6:	f6bff0ef          	jal	ra,800040 <cprintf>
    while (1);
  8000da:	a001                	j	8000da <exit+0x14>

00000000008000dc <fork>:
}

int
fork(void) {
    return sys_fork();
  8000dc:	bfe1                	j	8000b4 <sys_fork>

00000000008000de <yield>:
    return sys_wait(pid, store);
}

void
yield(void) {
    sys_yield();
  8000de:	bfe9                	j	8000b8 <sys_yield>

00000000008000e0 <getpid>:
    return sys_kill(pid);
}

int
getpid(void) {
    return sys_getpid();
  8000e0:	bff1                	j	8000bc <sys_getpid>

00000000008000e2 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8000e2:	1141                	addi	sp,sp,-16
  8000e4:	e406                	sd	ra,8(sp)
    int ret = main();
  8000e6:	691000ef          	jal	ra,800f76 <main>
    exit(ret);
  8000ea:	fddff0ef          	jal	ra,8000c6 <exit>

00000000008000ee <sprintputch>:
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
    b->cnt ++;
  8000ee:	499c                	lw	a5,16(a1)
    if (b->buf < b->ebuf) {
  8000f0:	6198                	ld	a4,0(a1)
  8000f2:	6594                	ld	a3,8(a1)
    b->cnt ++;
  8000f4:	2785                	addiw	a5,a5,1
  8000f6:	c99c                	sw	a5,16(a1)
    if (b->buf < b->ebuf) {
  8000f8:	00d77763          	bgeu	a4,a3,800106 <sprintputch+0x18>
        *b->buf ++ = ch;
  8000fc:	00170793          	addi	a5,a4,1
  800100:	e19c                	sd	a5,0(a1)
  800102:	00a70023          	sb	a0,0(a4)
    }
}
  800106:	8082                	ret

0000000000800108 <printnum>:
    unsigned mod = do_div(result, base);
  800108:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  80010c:	7139                	addi	sp,sp,-64
    unsigned mod = do_div(result, base);
  80010e:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800112:	e852                	sd	s4,16(sp)
    unsigned mod = do_div(result, base);
  800114:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  800118:	f426                	sd	s1,40(sp)
  80011a:	f04a                	sd	s2,32(sp)
  80011c:	ec4e                	sd	s3,24(sp)
  80011e:	fc06                	sd	ra,56(sp)
  800120:	f822                	sd	s0,48(sp)
  800122:	e456                	sd	s5,8(sp)
  800124:	e05a                	sd	s6,0(sp)
  800126:	84aa                	mv	s1,a0
  800128:	892e                	mv	s2,a1
  80012a:	89be                	mv	s3,a5
    unsigned mod = do_div(result, base);
  80012c:	2a01                	sext.w	s4,s4
    if (num >= base) {
  80012e:	05067163          	bgeu	a2,a6,800170 <printnum+0x68>
        while (-- width > 0)
  800132:	fff7041b          	addiw	s0,a4,-1
  800136:	00805763          	blez	s0,800144 <printnum+0x3c>
  80013a:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  80013c:	85ca                	mv	a1,s2
  80013e:	854e                	mv	a0,s3
  800140:	9482                	jalr	s1
        while (-- width > 0)
  800142:	fc65                	bnez	s0,80013a <printnum+0x32>
  800144:	00001417          	auipc	s0,0x1
  800148:	e6440413          	addi	s0,s0,-412 # 800fa8 <main+0x32>
    putch("0123456789abcdef"[mod], putdat);
  80014c:	1a02                	slli	s4,s4,0x20
  80014e:	020a5a13          	srli	s4,s4,0x20
  800152:	9452                	add	s0,s0,s4
  800154:	00044503          	lbu	a0,0(s0)
}
  800158:	7442                	ld	s0,48(sp)
  80015a:	70e2                	ld	ra,56(sp)
  80015c:	69e2                	ld	s3,24(sp)
  80015e:	6a42                	ld	s4,16(sp)
  800160:	6aa2                	ld	s5,8(sp)
  800162:	6b02                	ld	s6,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  800164:	85ca                	mv	a1,s2
  800166:	87a6                	mv	a5,s1
}
  800168:	7902                	ld	s2,32(sp)
  80016a:	74a2                	ld	s1,40(sp)
  80016c:	6121                	addi	sp,sp,64
    putch("0123456789abcdef"[mod], putdat);
  80016e:	8782                	jr	a5
    unsigned mod = do_div(result, base);
  800170:	03065633          	divu	a2,a2,a6
  800174:	03067ab3          	remu	s5,a2,a6
  800178:	2a81                	sext.w	s5,s5
    if (num >= base) {
  80017a:	03067863          	bgeu	a2,a6,8001aa <printnum+0xa2>
        while (-- width > 0)
  80017e:	ffe7041b          	addiw	s0,a4,-2
  800182:	00805763          	blez	s0,800190 <printnum+0x88>
  800186:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800188:	85ca                	mv	a1,s2
  80018a:	854e                	mv	a0,s3
  80018c:	9482                	jalr	s1
        while (-- width > 0)
  80018e:	fc65                	bnez	s0,800186 <printnum+0x7e>
  800190:	00001417          	auipc	s0,0x1
  800194:	e1840413          	addi	s0,s0,-488 # 800fa8 <main+0x32>
    putch("0123456789abcdef"[mod], putdat);
  800198:	1a82                	slli	s5,s5,0x20
  80019a:	020ada93          	srli	s5,s5,0x20
  80019e:	9aa2                	add	s5,s5,s0
  8001a0:	000ac503          	lbu	a0,0(s5)
  8001a4:	85ca                	mv	a1,s2
  8001a6:	9482                	jalr	s1
}
  8001a8:	b755                	j	80014c <printnum+0x44>
    unsigned mod = do_div(result, base);
  8001aa:	03065633          	divu	a2,a2,a6
        while (-- width > 0)
  8001ae:	ffd7041b          	addiw	s0,a4,-3
    unsigned mod = do_div(result, base);
  8001b2:	03067b33          	remu	s6,a2,a6
  8001b6:	2b01                	sext.w	s6,s6
    if (num >= base) {
  8001b8:	03067663          	bgeu	a2,a6,8001e4 <printnum+0xdc>
        while (-- width > 0)
  8001bc:	00805763          	blez	s0,8001ca <printnum+0xc2>
  8001c0:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  8001c2:	85ca                	mv	a1,s2
  8001c4:	854e                	mv	a0,s3
  8001c6:	9482                	jalr	s1
        while (-- width > 0)
  8001c8:	fc65                	bnez	s0,8001c0 <printnum+0xb8>
    putch("0123456789abcdef"[mod], putdat);
  8001ca:	1b02                	slli	s6,s6,0x20
  8001cc:	00001417          	auipc	s0,0x1
  8001d0:	ddc40413          	addi	s0,s0,-548 # 800fa8 <main+0x32>
  8001d4:	020b5b13          	srli	s6,s6,0x20
  8001d8:	9b22                	add	s6,s6,s0
  8001da:	000b4503          	lbu	a0,0(s6)
  8001de:	85ca                	mv	a1,s2
  8001e0:	9482                	jalr	s1
}
  8001e2:	bf5d                	j	800198 <printnum+0x90>
        printnum(putch, putdat, result, base, width - 1, padc);
  8001e4:	03065633          	divu	a2,a2,a6
  8001e8:	8722                	mv	a4,s0
  8001ea:	f1fff0ef          	jal	ra,800108 <printnum>
  8001ee:	bff1                	j	8001ca <printnum+0xc2>

00000000008001f0 <printnum.constprop.0>:
    unsigned mod = do_div(result, base);
  8001f0:	02061793          	slli	a5,a2,0x20
printnum(void (*putch)(int, void*), void *putdat,
  8001f4:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
  8001f6:	9381                	srli	a5,a5,0x20
printnum(void (*putch)(int, void*), void *putdat,
  8001f8:	ec26                	sd	s1,24(sp)
    unsigned mod = do_div(result, base);
  8001fa:	02f5f4b3          	remu	s1,a1,a5
printnum(void (*putch)(int, void*), void *putdat,
  8001fe:	f022                	sd	s0,32(sp)
  800200:	f406                	sd	ra,40(sp)
  800202:	e84a                	sd	s2,16(sp)
  800204:	e44e                	sd	s3,8(sp)
  800206:	842a                	mv	s0,a0
  800208:	883a                	mv	a6,a4
    unsigned mod = do_div(result, base);
  80020a:	2481                	sext.w	s1,s1
    if (num >= base) {
  80020c:	06f5f963          	bgeu	a1,a5,80027e <printnum.constprop.0+0x8e>
        while (-- width > 0)
  800210:	36fd                	addiw	a3,a3,-1
    b->cnt ++;
  800212:	491c                	lw	a5,16(a0)
    if (b->buf < b->ebuf) {
  800214:	6110                	ld	a2,0(a0)
  800216:	650c                	ld	a1,8(a0)
        while (-- width > 0)
  800218:	02d05063          	blez	a3,800238 <printnum.constprop.0+0x48>
    b->cnt ++;
  80021c:	2785                	addiw	a5,a5,1
  80021e:	c81c                	sw	a5,16(s0)
        *b->buf ++ = ch;
  800220:	00160513          	addi	a0,a2,1
    if (b->buf < b->ebuf) {
  800224:	04b67363          	bgeu	a2,a1,80026a <printnum.constprop.0+0x7a>
        *b->buf ++ = ch;
  800228:	e008                	sd	a0,0(s0)
  80022a:	01060023          	sb	a6,0(a2)
        while (-- width > 0)
  80022e:	36fd                	addiw	a3,a3,-1
    b->cnt ++;
  800230:	481c                	lw	a5,16(s0)
    if (b->buf < b->ebuf) {
  800232:	6010                	ld	a2,0(s0)
  800234:	640c                	ld	a1,8(s0)
        while (-- width > 0)
  800236:	f2fd                	bnez	a3,80021c <printnum.constprop.0+0x2c>
  800238:	00001697          	auipc	a3,0x1
  80023c:	d7068693          	addi	a3,a3,-656 # 800fa8 <main+0x32>
    putch("0123456789abcdef"[mod], putdat);
  800240:	1482                	slli	s1,s1,0x20
    b->cnt ++;
  800242:	2785                	addiw	a5,a5,1
    putch("0123456789abcdef"[mod], putdat);
  800244:	9081                	srli	s1,s1,0x20
  800246:	96a6                	add	a3,a3,s1
    b->cnt ++;
  800248:	c81c                	sw	a5,16(s0)
    putch("0123456789abcdef"[mod], putdat);
  80024a:	0006c783          	lbu	a5,0(a3)
    if (b->buf < b->ebuf) {
  80024e:	00b67763          	bgeu	a2,a1,80025c <printnum.constprop.0+0x6c>
        *b->buf ++ = ch;
  800252:	00160713          	addi	a4,a2,1
  800256:	e018                	sd	a4,0(s0)
  800258:	00f60023          	sb	a5,0(a2)
}
  80025c:	70a2                	ld	ra,40(sp)
  80025e:	7402                	ld	s0,32(sp)
  800260:	64e2                	ld	s1,24(sp)
  800262:	6942                	ld	s2,16(sp)
  800264:	69a2                	ld	s3,8(sp)
  800266:	6145                	addi	sp,sp,48
  800268:	8082                	ret
        while (-- width > 0)
  80026a:	36fd                	addiw	a3,a3,-1
  80026c:	00d7873b          	addw	a4,a5,a3
  800270:	2705                	addiw	a4,a4,1
  800272:	d2f9                	beqz	a3,800238 <printnum.constprop.0+0x48>
    b->cnt ++;
  800274:	40d707bb          	subw	a5,a4,a3
        while (-- width > 0)
  800278:	36fd                	addiw	a3,a3,-1
  80027a:	feed                	bnez	a3,800274 <printnum.constprop.0+0x84>
  80027c:	bf75                	j	800238 <printnum.constprop.0+0x48>
    unsigned mod = do_div(result, base);
  80027e:	02f5d5b3          	divu	a1,a1,a5
  800282:	02f5f933          	remu	s2,a1,a5
  800286:	2901                	sext.w	s2,s2
    if (num >= base) {
  800288:	08f5f163          	bgeu	a1,a5,80030a <printnum.constprop.0+0x11a>
        while (-- width > 0)
  80028c:	36f9                	addiw	a3,a3,-2
    b->cnt ++;
  80028e:	491c                	lw	a5,16(a0)
    if (b->buf < b->ebuf) {
  800290:	6118                	ld	a4,0(a0)
  800292:	650c                	ld	a1,8(a0)
        while (-- width > 0)
  800294:	02d05063          	blez	a3,8002b4 <printnum.constprop.0+0xc4>
    b->cnt ++;
  800298:	2785                	addiw	a5,a5,1
  80029a:	c81c                	sw	a5,16(s0)
        *b->buf ++ = ch;
  80029c:	00170613          	addi	a2,a4,1
    if (b->buf < b->ebuf) {
  8002a0:	04b77163          	bgeu	a4,a1,8002e2 <printnum.constprop.0+0xf2>
        *b->buf ++ = ch;
  8002a4:	e010                	sd	a2,0(s0)
  8002a6:	01070023          	sb	a6,0(a4)
        while (-- width > 0)
  8002aa:	36fd                	addiw	a3,a3,-1
    b->cnt ++;
  8002ac:	481c                	lw	a5,16(s0)
    if (b->buf < b->ebuf) {
  8002ae:	6018                	ld	a4,0(s0)
  8002b0:	640c                	ld	a1,8(s0)
        while (-- width > 0)
  8002b2:	f2fd                	bnez	a3,800298 <printnum.constprop.0+0xa8>
  8002b4:	00001697          	auipc	a3,0x1
  8002b8:	cf468693          	addi	a3,a3,-780 # 800fa8 <main+0x32>
    putch("0123456789abcdef"[mod], putdat);
  8002bc:	1902                	slli	s2,s2,0x20
    b->cnt ++;
  8002be:	2785                	addiw	a5,a5,1
    putch("0123456789abcdef"[mod], putdat);
  8002c0:	02095913          	srli	s2,s2,0x20
  8002c4:	9936                	add	s2,s2,a3
    b->cnt ++;
  8002c6:	c81c                	sw	a5,16(s0)
    putch("0123456789abcdef"[mod], putdat);
  8002c8:	00094603          	lbu	a2,0(s2)
    if (b->buf < b->ebuf) {
  8002cc:	02b77663          	bgeu	a4,a1,8002f8 <printnum.constprop.0+0x108>
        *b->buf ++ = ch;
  8002d0:	00170793          	addi	a5,a4,1
  8002d4:	e01c                	sd	a5,0(s0)
  8002d6:	00c70023          	sb	a2,0(a4)
    b->cnt ++;
  8002da:	481c                	lw	a5,16(s0)
    if (b->buf < b->ebuf) {
  8002dc:	6010                	ld	a2,0(s0)
  8002de:	640c                	ld	a1,8(s0)
  8002e0:	b785                	j	800240 <printnum.constprop.0+0x50>
        while (-- width > 0)
  8002e2:	36fd                	addiw	a3,a3,-1
  8002e4:	00f6863b          	addw	a2,a3,a5
  8002e8:	2605                	addiw	a2,a2,1
  8002ea:	d6e9                	beqz	a3,8002b4 <printnum.constprop.0+0xc4>
    b->cnt ++;
  8002ec:	40d607bb          	subw	a5,a2,a3
        while (-- width > 0)
  8002f0:	36fd                	addiw	a3,a3,-1
  8002f2:	feed                	bnez	a3,8002ec <printnum.constprop.0+0xfc>
  8002f4:	b7c1                	j	8002b4 <printnum.constprop.0+0xc4>
    b->cnt ++;
  8002f6:	2789                	addiw	a5,a5,2
  8002f8:	2785                	addiw	a5,a5,1
}
  8002fa:	70a2                	ld	ra,40(sp)
    b->cnt ++;
  8002fc:	c81c                	sw	a5,16(s0)
}
  8002fe:	7402                	ld	s0,32(sp)
  800300:	64e2                	ld	s1,24(sp)
  800302:	6942                	ld	s2,16(sp)
  800304:	69a2                	ld	s3,8(sp)
  800306:	6145                	addi	sp,sp,48
  800308:	8082                	ret
    unsigned mod = do_div(result, base);
  80030a:	02f5d5b3          	divu	a1,a1,a5
        while (-- width > 0)
  80030e:	36f5                	addiw	a3,a3,-3
    unsigned mod = do_div(result, base);
  800310:	02f5f9b3          	remu	s3,a1,a5
  800314:	2981                	sext.w	s3,s3
    if (num >= base) {
  800316:	06f5f763          	bgeu	a1,a5,800384 <printnum.constprop.0+0x194>
    b->cnt ++;
  80031a:	491c                	lw	a5,16(a0)
    if (b->buf < b->ebuf) {
  80031c:	6118                	ld	a4,0(a0)
  80031e:	650c                	ld	a1,8(a0)
        while (-- width > 0)
  800320:	02d05063          	blez	a3,800340 <printnum.constprop.0+0x150>
    b->cnt ++;
  800324:	2785                	addiw	a5,a5,1
  800326:	c81c                	sw	a5,16(s0)
        *b->buf ++ = ch;
  800328:	00170613          	addi	a2,a4,1
    if (b->buf < b->ebuf) {
  80032c:	04b77263          	bgeu	a4,a1,800370 <printnum.constprop.0+0x180>
        *b->buf ++ = ch;
  800330:	e010                	sd	a2,0(s0)
  800332:	01070023          	sb	a6,0(a4)
        while (-- width > 0)
  800336:	36fd                	addiw	a3,a3,-1
    b->cnt ++;
  800338:	481c                	lw	a5,16(s0)
    if (b->buf < b->ebuf) {
  80033a:	6018                	ld	a4,0(s0)
  80033c:	640c                	ld	a1,8(s0)
        while (-- width > 0)
  80033e:	f2fd                	bnez	a3,800324 <printnum.constprop.0+0x134>
    putch("0123456789abcdef"[mod], putdat);
  800340:	1982                	slli	s3,s3,0x20
    b->cnt ++;
  800342:	0017861b          	addiw	a2,a5,1
    putch("0123456789abcdef"[mod], putdat);
  800346:	00001697          	auipc	a3,0x1
  80034a:	c6268693          	addi	a3,a3,-926 # 800fa8 <main+0x32>
  80034e:	0209d993          	srli	s3,s3,0x20
  800352:	99b6                	add	s3,s3,a3
    b->cnt ++;
  800354:	c810                	sw	a2,16(s0)
    putch("0123456789abcdef"[mod], putdat);
  800356:	0009c603          	lbu	a2,0(s3)
    if (b->buf < b->ebuf) {
  80035a:	f8b77ee3          	bgeu	a4,a1,8002f6 <printnum.constprop.0+0x106>
        *b->buf ++ = ch;
  80035e:	00170793          	addi	a5,a4,1
  800362:	e01c                	sd	a5,0(s0)
  800364:	00c70023          	sb	a2,0(a4)
    b->cnt ++;
  800368:	481c                	lw	a5,16(s0)
    if (b->buf < b->ebuf) {
  80036a:	6018                	ld	a4,0(s0)
  80036c:	640c                	ld	a1,8(s0)
  80036e:	b7b9                	j	8002bc <printnum.constprop.0+0xcc>
        while (-- width > 0)
  800370:	36fd                	addiw	a3,a3,-1
  800372:	00f6863b          	addw	a2,a3,a5
  800376:	2605                	addiw	a2,a2,1
  800378:	d6e1                	beqz	a3,800340 <printnum.constprop.0+0x150>
    b->cnt ++;
  80037a:	40d607bb          	subw	a5,a2,a3
        while (-- width > 0)
  80037e:	36fd                	addiw	a3,a3,-1
  800380:	feed                	bnez	a3,80037a <printnum.constprop.0+0x18a>
  800382:	bf7d                	j	800340 <printnum.constprop.0+0x150>
        printnum(putch, putdat, result, base, width - 1, padc);
  800384:	02f5d5b3          	divu	a1,a1,a5
  800388:	e69ff0ef          	jal	ra,8001f0 <printnum.constprop.0>
    b->cnt ++;
  80038c:	481c                	lw	a5,16(s0)
    if (b->buf < b->ebuf) {
  80038e:	6018                	ld	a4,0(s0)
  800390:	640c                	ld	a1,8(s0)
  800392:	b77d                	j	800340 <printnum.constprop.0+0x150>

0000000000800394 <vprintfmt>:
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  800394:	7119                	addi	sp,sp,-128
  800396:	f4a6                	sd	s1,104(sp)
  800398:	f0ca                	sd	s2,96(sp)
  80039a:	ecce                	sd	s3,88(sp)
  80039c:	e8d2                	sd	s4,80(sp)
  80039e:	e4d6                	sd	s5,72(sp)
  8003a0:	e0da                	sd	s6,64(sp)
  8003a2:	fc5e                	sd	s7,56(sp)
  8003a4:	f466                	sd	s9,40(sp)
  8003a6:	fc86                	sd	ra,120(sp)
  8003a8:	f8a2                	sd	s0,112(sp)
  8003aa:	f862                	sd	s8,48(sp)
  8003ac:	f06a                	sd	s10,32(sp)
  8003ae:	ec6e                	sd	s11,24(sp)
  8003b0:	892a                	mv	s2,a0
  8003b2:	84ae                	mv	s1,a1
  8003b4:	8cb2                	mv	s9,a2
  8003b6:	8a36                	mv	s4,a3
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8003b8:	02500993          	li	s3,37
        width = precision = -1;
  8003bc:	5bfd                	li	s7,-1
  8003be:	00001a97          	auipc	s5,0x1
  8003c2:	c1ea8a93          	addi	s5,s5,-994 # 800fdc <main+0x66>
    putch("0123456789abcdef"[mod], putdat);
  8003c6:	00001b17          	auipc	s6,0x1
  8003ca:	be2b0b13          	addi	s6,s6,-1054 # 800fa8 <main+0x32>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8003ce:	000cc503          	lbu	a0,0(s9)
  8003d2:	001c8413          	addi	s0,s9,1
  8003d6:	01350a63          	beq	a0,s3,8003ea <vprintfmt+0x56>
            if (ch == '\0') {
  8003da:	c121                	beqz	a0,80041a <vprintfmt+0x86>
            putch(ch, putdat);
  8003dc:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8003de:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  8003e0:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8003e2:	fff44503          	lbu	a0,-1(s0)
  8003e6:	ff351ae3          	bne	a0,s3,8003da <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
  8003ea:	00044683          	lbu	a3,0(s0)
        char padc = ' ';
  8003ee:	02000813          	li	a6,32
        lflag = altflag = 0;
  8003f2:	4d81                	li	s11,0
  8003f4:	4501                	li	a0,0
        width = precision = -1;
  8003f6:	5c7d                	li	s8,-1
  8003f8:	5d7d                	li	s10,-1
  8003fa:	05500613          	li	a2,85
                if (ch < '0' || ch > '9') {
  8003fe:	45a5                	li	a1,9
        switch (ch = *(unsigned char *)fmt ++) {
  800400:	fdd6879b          	addiw	a5,a3,-35
  800404:	0ff7f793          	zext.b	a5,a5
  800408:	00140c93          	addi	s9,s0,1
  80040c:	04f66263          	bltu	a2,a5,800450 <vprintfmt+0xbc>
  800410:	078a                	slli	a5,a5,0x2
  800412:	97d6                	add	a5,a5,s5
  800414:	439c                	lw	a5,0(a5)
  800416:	97d6                	add	a5,a5,s5
  800418:	8782                	jr	a5
}
  80041a:	70e6                	ld	ra,120(sp)
  80041c:	7446                	ld	s0,112(sp)
  80041e:	74a6                	ld	s1,104(sp)
  800420:	7906                	ld	s2,96(sp)
  800422:	69e6                	ld	s3,88(sp)
  800424:	6a46                	ld	s4,80(sp)
  800426:	6aa6                	ld	s5,72(sp)
  800428:	6b06                	ld	s6,64(sp)
  80042a:	7be2                	ld	s7,56(sp)
  80042c:	7c42                	ld	s8,48(sp)
  80042e:	7ca2                	ld	s9,40(sp)
  800430:	7d02                	ld	s10,32(sp)
  800432:	6de2                	ld	s11,24(sp)
  800434:	6109                	addi	sp,sp,128
  800436:	8082                	ret
            padc = '0';
  800438:	8836                	mv	a6,a3
            goto reswitch;
  80043a:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  80043e:	8466                	mv	s0,s9
  800440:	00140c93          	addi	s9,s0,1
  800444:	fdd6879b          	addiw	a5,a3,-35
  800448:	0ff7f793          	zext.b	a5,a5
  80044c:	fcf672e3          	bgeu	a2,a5,800410 <vprintfmt+0x7c>
            putch('%', putdat);
  800450:	85a6                	mv	a1,s1
  800452:	02500513          	li	a0,37
  800456:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800458:	fff44783          	lbu	a5,-1(s0)
  80045c:	8ca2                	mv	s9,s0
  80045e:	f73788e3          	beq	a5,s3,8003ce <vprintfmt+0x3a>
  800462:	ffecc783          	lbu	a5,-2(s9)
  800466:	1cfd                	addi	s9,s9,-1
  800468:	ff379de3          	bne	a5,s3,800462 <vprintfmt+0xce>
  80046c:	b78d                	j	8003ce <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  80046e:	fd068c1b          	addiw	s8,a3,-48
                ch = *fmt;
  800472:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800476:	8466                	mv	s0,s9
                if (ch < '0' || ch > '9') {
  800478:	fd06879b          	addiw	a5,a3,-48
                ch = *fmt;
  80047c:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  800480:	02f5e563          	bltu	a1,a5,8004aa <vprintfmt+0x116>
                ch = *fmt;
  800484:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
  800488:	002c179b          	slliw	a5,s8,0x2
  80048c:	0187873b          	addw	a4,a5,s8
  800490:	0017171b          	slliw	a4,a4,0x1
  800494:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
  800498:	fd06879b          	addiw	a5,a3,-48
            for (precision = 0; ; ++ fmt) {
  80049c:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  80049e:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  8004a2:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  8004a6:	fcf5ffe3          	bgeu	a1,a5,800484 <vprintfmt+0xf0>
            if (width < 0)
  8004aa:	f40d5be3          	bgez	s10,800400 <vprintfmt+0x6c>
                width = precision, precision = -1;
  8004ae:	8d62                	mv	s10,s8
  8004b0:	5c7d                	li	s8,-1
  8004b2:	b7b9                	j	800400 <vprintfmt+0x6c>
            if (width < 0)
  8004b4:	fffd4793          	not	a5,s10
  8004b8:	97fd                	srai	a5,a5,0x3f
  8004ba:	00fd7d33          	and	s10,s10,a5
        switch (ch = *(unsigned char *)fmt ++) {
  8004be:	00144683          	lbu	a3,1(s0)
  8004c2:	2d01                	sext.w	s10,s10
  8004c4:	8466                	mv	s0,s9
            goto reswitch;
  8004c6:	bf2d                	j	800400 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  8004c8:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  8004cc:	00144683          	lbu	a3,1(s0)
            precision = va_arg(ap, int);
  8004d0:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  8004d2:	8466                	mv	s0,s9
            goto process_precision;
  8004d4:	bfd9                	j	8004aa <vprintfmt+0x116>
    if (lflag >= 2) {
  8004d6:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8004d8:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  8004dc:	00a7c463          	blt	a5,a0,8004e4 <vprintfmt+0x150>
    else if (lflag) {
  8004e0:	28050a63          	beqz	a0,800774 <vprintfmt+0x3e0>
        return va_arg(*ap, unsigned long);
  8004e4:	000a3783          	ld	a5,0(s4)
  8004e8:	4641                	li	a2,16
  8004ea:	8a3a                	mv	s4,a4
  8004ec:	46c1                	li	a3,16
    unsigned mod = do_div(result, base);
  8004ee:	02c7fdb3          	remu	s11,a5,a2
            printnum(putch, putdat, num, base, width, padc);
  8004f2:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  8004f6:	0ac7f563          	bgeu	a5,a2,8005a0 <vprintfmt+0x20c>
        while (-- width > 0)
  8004fa:	3d7d                	addiw	s10,s10,-1
  8004fc:	01a05863          	blez	s10,80050c <vprintfmt+0x178>
  800500:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  800502:	85a6                	mv	a1,s1
  800504:	8562                	mv	a0,s8
  800506:	9902                	jalr	s2
        while (-- width > 0)
  800508:	fe0d1ce3          	bnez	s10,800500 <vprintfmt+0x16c>
    putch("0123456789abcdef"[mod], putdat);
  80050c:	9dda                	add	s11,s11,s6
  80050e:	000dc503          	lbu	a0,0(s11)
  800512:	85a6                	mv	a1,s1
  800514:	9902                	jalr	s2
}
  800516:	bd65                	j	8003ce <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  800518:	000a2503          	lw	a0,0(s4)
  80051c:	85a6                	mv	a1,s1
  80051e:	0a21                	addi	s4,s4,8
  800520:	9902                	jalr	s2
            break;
  800522:	b575                	j	8003ce <vprintfmt+0x3a>
    if (lflag >= 2) {
  800524:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800526:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  80052a:	00a7c463          	blt	a5,a0,800532 <vprintfmt+0x19e>
    else if (lflag) {
  80052e:	22050d63          	beqz	a0,800768 <vprintfmt+0x3d4>
        return va_arg(*ap, unsigned long);
  800532:	000a3783          	ld	a5,0(s4)
  800536:	4629                	li	a2,10
  800538:	8a3a                	mv	s4,a4
  80053a:	46a9                	li	a3,10
  80053c:	bf4d                	j	8004ee <vprintfmt+0x15a>
        switch (ch = *(unsigned char *)fmt ++) {
  80053e:	00144683          	lbu	a3,1(s0)
            altflag = 1;
  800542:	4d85                	li	s11,1
        switch (ch = *(unsigned char *)fmt ++) {
  800544:	8466                	mv	s0,s9
            goto reswitch;
  800546:	bd6d                	j	800400 <vprintfmt+0x6c>
            putch(ch, putdat);
  800548:	85a6                	mv	a1,s1
  80054a:	02500513          	li	a0,37
  80054e:	9902                	jalr	s2
            break;
  800550:	bdbd                	j	8003ce <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  800552:	00144683          	lbu	a3,1(s0)
            lflag ++;
  800556:	2505                	addiw	a0,a0,1
        switch (ch = *(unsigned char *)fmt ++) {
  800558:	8466                	mv	s0,s9
            goto reswitch;
  80055a:	b55d                	j	800400 <vprintfmt+0x6c>
    if (lflag >= 2) {
  80055c:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80055e:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800562:	00a7c463          	blt	a5,a0,80056a <vprintfmt+0x1d6>
    else if (lflag) {
  800566:	1e050b63          	beqz	a0,80075c <vprintfmt+0x3c8>
        return va_arg(*ap, unsigned long);
  80056a:	000a3783          	ld	a5,0(s4)
  80056e:	4621                	li	a2,8
  800570:	8a3a                	mv	s4,a4
  800572:	46a1                	li	a3,8
  800574:	bfad                	j	8004ee <vprintfmt+0x15a>
            putch('0', putdat);
  800576:	03000513          	li	a0,48
  80057a:	85a6                	mv	a1,s1
  80057c:	e042                	sd	a6,0(sp)
  80057e:	9902                	jalr	s2
            putch('x', putdat);
  800580:	85a6                	mv	a1,s1
  800582:	07800513          	li	a0,120
  800586:	9902                	jalr	s2
            goto number;
  800588:	6802                	ld	a6,0(sp)
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80058a:	000a3783          	ld	a5,0(s4)
            goto number;
  80058e:	4641                	li	a2,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800590:	0a21                	addi	s4,s4,8
    unsigned mod = do_div(result, base);
  800592:	02c7fdb3          	remu	s11,a5,a2
            goto number;
  800596:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
  800598:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  80059c:	f4c7efe3          	bltu	a5,a2,8004fa <vprintfmt+0x166>
        while (-- width > 0)
  8005a0:	3d79                	addiw	s10,s10,-2
    unsigned mod = do_div(result, base);
  8005a2:	02c7d7b3          	divu	a5,a5,a2
  8005a6:	02c7f433          	remu	s0,a5,a2
    if (num >= base) {
  8005aa:	10c7f463          	bgeu	a5,a2,8006b2 <vprintfmt+0x31e>
        while (-- width > 0)
  8005ae:	01a05863          	blez	s10,8005be <vprintfmt+0x22a>
  8005b2:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  8005b4:	85a6                	mv	a1,s1
  8005b6:	8562                	mv	a0,s8
  8005b8:	9902                	jalr	s2
        while (-- width > 0)
  8005ba:	fe0d1ce3          	bnez	s10,8005b2 <vprintfmt+0x21e>
    putch("0123456789abcdef"[mod], putdat);
  8005be:	945a                	add	s0,s0,s6
  8005c0:	00044503          	lbu	a0,0(s0)
  8005c4:	85a6                	mv	a1,s1
  8005c6:	9dda                	add	s11,s11,s6
  8005c8:	9902                	jalr	s2
  8005ca:	000dc503          	lbu	a0,0(s11)
  8005ce:	85a6                	mv	a1,s1
  8005d0:	9902                	jalr	s2
  8005d2:	bbf5                	j	8003ce <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
  8005d4:	000a3403          	ld	s0,0(s4)
  8005d8:	008a0793          	addi	a5,s4,8
  8005dc:	e43e                	sd	a5,8(sp)
  8005de:	1e040563          	beqz	s0,8007c8 <vprintfmt+0x434>
            if (width > 0 && padc != '-') {
  8005e2:	15a05263          	blez	s10,800726 <vprintfmt+0x392>
  8005e6:	02d00793          	li	a5,45
  8005ea:	10f81b63          	bne	a6,a5,800700 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005ee:	00044783          	lbu	a5,0(s0)
  8005f2:	0007851b          	sext.w	a0,a5
  8005f6:	0e078c63          	beqz	a5,8006ee <vprintfmt+0x35a>
  8005fa:	0405                	addi	s0,s0,1
  8005fc:	120d8e63          	beqz	s11,800738 <vprintfmt+0x3a4>
                if (altflag && (ch < ' ' || ch > '~')) {
  800600:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800604:	020c4963          	bltz	s8,800636 <vprintfmt+0x2a2>
  800608:	fffc0a1b          	addiw	s4,s8,-1
  80060c:	0d7a0f63          	beq	s4,s7,8006ea <vprintfmt+0x356>
                if (altflag && (ch < ' ' || ch > '~')) {
  800610:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  800612:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800614:	02fdf663          	bgeu	s11,a5,800640 <vprintfmt+0x2ac>
                    putch('?', putdat);
  800618:	03f00513          	li	a0,63
  80061c:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80061e:	00044783          	lbu	a5,0(s0)
  800622:	3d7d                	addiw	s10,s10,-1
  800624:	0405                	addi	s0,s0,1
  800626:	0007851b          	sext.w	a0,a5
  80062a:	c3e1                	beqz	a5,8006ea <vprintfmt+0x356>
  80062c:	140c4a63          	bltz	s8,800780 <vprintfmt+0x3ec>
  800630:	8c52                	mv	s8,s4
  800632:	fc0c5be3          	bgez	s8,800608 <vprintfmt+0x274>
                if (altflag && (ch < ' ' || ch > '~')) {
  800636:	3781                	addiw	a5,a5,-32
  800638:	8a62                	mv	s4,s8
                    putch('?', putdat);
  80063a:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  80063c:	fcfdeee3          	bltu	s11,a5,800618 <vprintfmt+0x284>
                    putch(ch, putdat);
  800640:	9902                	jalr	s2
  800642:	bff1                	j	80061e <vprintfmt+0x28a>
    if (lflag >= 2) {
  800644:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800646:	008a0d93          	addi	s11,s4,8
    if (lflag >= 2) {
  80064a:	00a7c463          	blt	a5,a0,800652 <vprintfmt+0x2be>
    else if (lflag) {
  80064e:	10050463          	beqz	a0,800756 <vprintfmt+0x3c2>
        return va_arg(*ap, long);
  800652:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  800656:	14044d63          	bltz	s0,8007b0 <vprintfmt+0x41c>
            num = getint(&ap, lflag);
  80065a:	87a2                	mv	a5,s0
  80065c:	8a6e                	mv	s4,s11
  80065e:	4629                	li	a2,10
  800660:	46a9                	li	a3,10
  800662:	b571                	j	8004ee <vprintfmt+0x15a>
            err = va_arg(ap, int);
  800664:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800668:	4761                	li	a4,24
            err = va_arg(ap, int);
  80066a:	0a21                	addi	s4,s4,8
            if (err < 0) {
  80066c:	41f7d69b          	sraiw	a3,a5,0x1f
  800670:	8fb5                	xor	a5,a5,a3
  800672:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800676:	02d74563          	blt	a4,a3,8006a0 <vprintfmt+0x30c>
  80067a:	00369713          	slli	a4,a3,0x3
  80067e:	00001797          	auipc	a5,0x1
  800682:	cd278793          	addi	a5,a5,-814 # 801350 <error_string>
  800686:	97ba                	add	a5,a5,a4
  800688:	639c                	ld	a5,0(a5)
  80068a:	cb99                	beqz	a5,8006a0 <vprintfmt+0x30c>
                printfmt(putch, putdat, "%s", p);
  80068c:	86be                	mv	a3,a5
  80068e:	00001617          	auipc	a2,0x1
  800692:	94a60613          	addi	a2,a2,-1718 # 800fd8 <main+0x62>
  800696:	85a6                	mv	a1,s1
  800698:	854a                	mv	a0,s2
  80069a:	160000ef          	jal	ra,8007fa <printfmt>
  80069e:	bb05                	j	8003ce <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  8006a0:	00001617          	auipc	a2,0x1
  8006a4:	92860613          	addi	a2,a2,-1752 # 800fc8 <main+0x52>
  8006a8:	85a6                	mv	a1,s1
  8006aa:	854a                	mv	a0,s2
  8006ac:	14e000ef          	jal	ra,8007fa <printfmt>
  8006b0:	bb39                	j	8003ce <vprintfmt+0x3a>
        printnum(putch, putdat, result, base, width - 1, padc);
  8006b2:	02c7d633          	divu	a2,a5,a2
  8006b6:	876a                	mv	a4,s10
  8006b8:	87e2                	mv	a5,s8
  8006ba:	85a6                	mv	a1,s1
  8006bc:	854a                	mv	a0,s2
  8006be:	a4bff0ef          	jal	ra,800108 <printnum>
  8006c2:	bdf5                	j	8005be <vprintfmt+0x22a>
                    putch(ch, putdat);
  8006c4:	85a6                	mv	a1,s1
  8006c6:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8006c8:	00044503          	lbu	a0,0(s0)
  8006cc:	3d7d                	addiw	s10,s10,-1
  8006ce:	0405                	addi	s0,s0,1
  8006d0:	cd09                	beqz	a0,8006ea <vprintfmt+0x356>
  8006d2:	008d0d3b          	addw	s10,s10,s0
  8006d6:	fffd0d9b          	addiw	s11,s10,-1
                    putch(ch, putdat);
  8006da:	85a6                	mv	a1,s1
  8006dc:	408d8d3b          	subw	s10,s11,s0
  8006e0:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8006e2:	00044503          	lbu	a0,0(s0)
  8006e6:	0405                	addi	s0,s0,1
  8006e8:	f96d                	bnez	a0,8006da <vprintfmt+0x346>
            for (; width > 0; width --) {
  8006ea:	01a05963          	blez	s10,8006fc <vprintfmt+0x368>
  8006ee:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
  8006f0:	85a6                	mv	a1,s1
  8006f2:	02000513          	li	a0,32
  8006f6:	9902                	jalr	s2
            for (; width > 0; width --) {
  8006f8:	fe0d1be3          	bnez	s10,8006ee <vprintfmt+0x35a>
            if ((p = va_arg(ap, char *)) == NULL) {
  8006fc:	6a22                	ld	s4,8(sp)
  8006fe:	b9c1                	j	8003ce <vprintfmt+0x3a>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800700:	85e2                	mv	a1,s8
  800702:	8522                	mv	a0,s0
  800704:	e042                	sd	a6,0(sp)
  800706:	7c8000ef          	jal	ra,800ece <strnlen>
  80070a:	40ad0d3b          	subw	s10,s10,a0
  80070e:	01a05c63          	blez	s10,800726 <vprintfmt+0x392>
                    putch(padc, putdat);
  800712:	6802                	ld	a6,0(sp)
  800714:	0008051b          	sext.w	a0,a6
  800718:	85a6                	mv	a1,s1
  80071a:	e02a                	sd	a0,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
  80071c:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
  80071e:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  800720:	6502                	ld	a0,0(sp)
  800722:	fe0d1be3          	bnez	s10,800718 <vprintfmt+0x384>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800726:	00044783          	lbu	a5,0(s0)
  80072a:	0405                	addi	s0,s0,1
  80072c:	0007851b          	sext.w	a0,a5
  800730:	ec0796e3          	bnez	a5,8005fc <vprintfmt+0x268>
            if ((p = va_arg(ap, char *)) == NULL) {
  800734:	6a22                	ld	s4,8(sp)
  800736:	b961                	j	8003ce <vprintfmt+0x3a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800738:	f80c46e3          	bltz	s8,8006c4 <vprintfmt+0x330>
  80073c:	3c7d                	addiw	s8,s8,-1
  80073e:	fb7c06e3          	beq	s8,s7,8006ea <vprintfmt+0x356>
                    putch(ch, putdat);
  800742:	85a6                	mv	a1,s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800744:	0405                	addi	s0,s0,1
                    putch(ch, putdat);
  800746:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800748:	fff44503          	lbu	a0,-1(s0)
  80074c:	3d7d                	addiw	s10,s10,-1
  80074e:	f56d                	bnez	a0,800738 <vprintfmt+0x3a4>
            for (; width > 0; width --) {
  800750:	f9a04fe3          	bgtz	s10,8006ee <vprintfmt+0x35a>
  800754:	b765                	j	8006fc <vprintfmt+0x368>
        return va_arg(*ap, int);
  800756:	000a2403          	lw	s0,0(s4)
  80075a:	bdf5                	j	800656 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned int);
  80075c:	000a6783          	lwu	a5,0(s4)
  800760:	4621                	li	a2,8
  800762:	8a3a                	mv	s4,a4
  800764:	46a1                	li	a3,8
  800766:	b361                	j	8004ee <vprintfmt+0x15a>
  800768:	000a6783          	lwu	a5,0(s4)
  80076c:	4629                	li	a2,10
  80076e:	8a3a                	mv	s4,a4
  800770:	46a9                	li	a3,10
  800772:	bbb5                	j	8004ee <vprintfmt+0x15a>
  800774:	000a6783          	lwu	a5,0(s4)
  800778:	4641                	li	a2,16
  80077a:	8a3a                	mv	s4,a4
  80077c:	46c1                	li	a3,16
  80077e:	bb85                	j	8004ee <vprintfmt+0x15a>
  800780:	01a40d3b          	addw	s10,s0,s10
                if (altflag && (ch < ' ' || ch > '~')) {
  800784:	05e00d93          	li	s11,94
  800788:	3d7d                	addiw	s10,s10,-1
  80078a:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  80078c:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  80078e:	00fdf463          	bgeu	s11,a5,800796 <vprintfmt+0x402>
                    putch('?', putdat);
  800792:	03f00513          	li	a0,63
  800796:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800798:	00044783          	lbu	a5,0(s0)
  80079c:	408d073b          	subw	a4,s10,s0
  8007a0:	0405                	addi	s0,s0,1
  8007a2:	0007851b          	sext.w	a0,a5
  8007a6:	f3f5                	bnez	a5,80078a <vprintfmt+0x3f6>
  8007a8:	8d3a                	mv	s10,a4
            for (; width > 0; width --) {
  8007aa:	f5a042e3          	bgtz	s10,8006ee <vprintfmt+0x35a>
  8007ae:	b7b9                	j	8006fc <vprintfmt+0x368>
                putch('-', putdat);
  8007b0:	85a6                	mv	a1,s1
  8007b2:	02d00513          	li	a0,45
  8007b6:	e042                	sd	a6,0(sp)
  8007b8:	9902                	jalr	s2
                num = -(long long)num;
  8007ba:	6802                	ld	a6,0(sp)
  8007bc:	8a6e                	mv	s4,s11
  8007be:	408007b3          	neg	a5,s0
  8007c2:	4629                	li	a2,10
  8007c4:	46a9                	li	a3,10
  8007c6:	b325                	j	8004ee <vprintfmt+0x15a>
            if (width > 0 && padc != '-') {
  8007c8:	03a05063          	blez	s10,8007e8 <vprintfmt+0x454>
  8007cc:	02d00793          	li	a5,45
                p = "(null)";
  8007d0:	00000417          	auipc	s0,0x0
  8007d4:	7f040413          	addi	s0,s0,2032 # 800fc0 <main+0x4a>
            if (width > 0 && padc != '-') {
  8007d8:	f2f814e3          	bne	a6,a5,800700 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8007dc:	02800793          	li	a5,40
  8007e0:	02800513          	li	a0,40
  8007e4:	0405                	addi	s0,s0,1
  8007e6:	bd19                	j	8005fc <vprintfmt+0x268>
  8007e8:	02800513          	li	a0,40
  8007ec:	02800793          	li	a5,40
  8007f0:	00000417          	auipc	s0,0x0
  8007f4:	7d140413          	addi	s0,s0,2001 # 800fc1 <main+0x4b>
  8007f8:	b511                	j	8005fc <vprintfmt+0x268>

00000000008007fa <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8007fa:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  8007fc:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800800:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800802:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800804:	ec06                	sd	ra,24(sp)
  800806:	f83a                	sd	a4,48(sp)
  800808:	fc3e                	sd	a5,56(sp)
  80080a:	e0c2                	sd	a6,64(sp)
  80080c:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  80080e:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800810:	b85ff0ef          	jal	ra,800394 <vprintfmt>
}
  800814:	60e2                	ld	ra,24(sp)
  800816:	6161                	addi	sp,sp,80
  800818:	8082                	ret

000000000080081a <vsnprintf>:
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
    struct sprintbuf b = {str, str + size - 1, 0};
  80081a:	fff58793          	addi	a5,a1,-1
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  80081e:	7175                	addi	sp,sp,-144
    struct sprintbuf b = {str, str + size - 1, 0};
  800820:	97aa                	add	a5,a5,a0
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  800822:	e506                	sd	ra,136(sp)
  800824:	e122                	sd	s0,128(sp)
  800826:	fca6                	sd	s1,120(sp)
  800828:	f8ca                	sd	s2,112(sp)
  80082a:	f4ce                	sd	s3,104(sp)
  80082c:	f0d2                	sd	s4,96(sp)
  80082e:	ecd6                	sd	s5,88(sp)
  800830:	e8da                	sd	s6,80(sp)
  800832:	e4de                	sd	s7,72(sp)
  800834:	e0e2                	sd	s8,64(sp)
  800836:	fc66                	sd	s9,56(sp)
  800838:	f86a                	sd	s10,48(sp)
    struct sprintbuf b = {str, str + size - 1, 0};
  80083a:	ec2a                	sd	a0,24(sp)
  80083c:	f03e                	sd	a5,32(sp)
  80083e:	d402                	sw	zero,40(sp)
    if (str == NULL || b.buf > b.ebuf) {
  800840:	62050e63          	beqz	a0,800e7c <vsnprintf+0x662>
  800844:	62a7ec63          	bltu	a5,a0,800e7c <vsnprintf+0x662>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800848:	00064703          	lbu	a4,0(a2)
  80084c:	8bb2                	mv	s7,a2
  80084e:	8b36                	mv	s6,a3
  800850:	02500493          	li	s1,37
  800854:	00001917          	auipc	s2,0x1
  800858:	8e090913          	addi	s2,s2,-1824 # 801134 <main+0x1be>
    putch("0123456789abcdef"[mod], putdat);
  80085c:	00000997          	auipc	s3,0x0
  800860:	74c98993          	addi	s3,s3,1868 # 800fa8 <main+0x32>
                p = "(null)";
  800864:	00000a97          	auipc	s5,0x0
  800868:	75ca8a93          	addi	s5,s5,1884 # 800fc0 <main+0x4a>
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80086c:	00001a17          	auipc	s4,0x1
  800870:	ae4a0a13          	addi	s4,s4,-1308 # 801350 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800874:	0007079b          	sext.w	a5,a4
  800878:	001b8413          	addi	s0,s7,1
  80087c:	02978663          	beq	a5,s1,8008a8 <vsnprintf+0x8e>
  800880:	6562                	ld	a0,24(sp)
            if (ch == '\0') {
  800882:	c3bd                	beqz	a5,8008e8 <vsnprintf+0xce>
    b->cnt ++;
  800884:	57a2                	lw	a5,40(sp)
    if (b->buf < b->ebuf) {
  800886:	7602                	ld	a2,32(sp)
    b->cnt ++;
  800888:	2785                	addiw	a5,a5,1
  80088a:	d43e                	sw	a5,40(sp)
    if (b->buf < b->ebuf) {
  80088c:	04c57663          	bgeu	a0,a2,8008d8 <vsnprintf+0xbe>
        *b->buf ++ = ch;
  800890:	00150793          	addi	a5,a0,1
  800894:	ec3e                	sd	a5,24(sp)
  800896:	00e50023          	sb	a4,0(a0)
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80089a:	00044703          	lbu	a4,0(s0)
  80089e:	0405                	addi	s0,s0,1
  8008a0:	0007079b          	sext.w	a5,a4
  8008a4:	fc971ee3          	bne	a4,s1,800880 <vsnprintf+0x66>
        switch (ch = *(unsigned char *)fmt ++) {
  8008a8:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
  8008ac:	02000c93          	li	s9,32
        lflag = altflag = 0;
  8008b0:	4d01                	li	s10,0
  8008b2:	4301                	li	t1,0
        width = precision = -1;
  8008b4:	55fd                	li	a1,-1
  8008b6:	57fd                	li	a5,-1
  8008b8:	05500813          	li	a6,85
                if (ch < '0' || ch > '9') {
  8008bc:	48a5                	li	a7,9
        switch (ch = *(unsigned char *)fmt ++) {
  8008be:	fdd6051b          	addiw	a0,a2,-35
  8008c2:	0ff57513          	zext.b	a0,a0
  8008c6:	00140b93          	addi	s7,s0,1
  8008ca:	04a86c63          	bltu	a6,a0,800922 <vsnprintf+0x108>
  8008ce:	050a                	slli	a0,a0,0x2
  8008d0:	954a                	add	a0,a0,s2
  8008d2:	4118                	lw	a4,0(a0)
  8008d4:	974a                	add	a4,a4,s2
  8008d6:	8702                	jr	a4
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8008d8:	00044703          	lbu	a4,0(s0)
  8008dc:	0405                	addi	s0,s0,1
  8008de:	0007079b          	sext.w	a5,a4
  8008e2:	fc9703e3          	beq	a4,s1,8008a8 <vsnprintf+0x8e>
            if (ch == '\0') {
  8008e6:	ffd9                	bnez	a5,800884 <vsnprintf+0x6a>
        return -E_INVAL;
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
    // null terminate the buffer
    *b.buf = '\0';
  8008e8:	00050023          	sb	zero,0(a0)
    return b.cnt;
  8008ec:	5522                	lw	a0,40(sp)
}
  8008ee:	60aa                	ld	ra,136(sp)
  8008f0:	640a                	ld	s0,128(sp)
  8008f2:	74e6                	ld	s1,120(sp)
  8008f4:	7946                	ld	s2,112(sp)
  8008f6:	79a6                	ld	s3,104(sp)
  8008f8:	7a06                	ld	s4,96(sp)
  8008fa:	6ae6                	ld	s5,88(sp)
  8008fc:	6b46                	ld	s6,80(sp)
  8008fe:	6ba6                	ld	s7,72(sp)
  800900:	6c06                	ld	s8,64(sp)
  800902:	7ce2                	ld	s9,56(sp)
  800904:	7d42                	ld	s10,48(sp)
  800906:	6149                	addi	sp,sp,144
  800908:	8082                	ret
            padc = '0';
  80090a:	8cb2                	mv	s9,a2
            goto reswitch;
  80090c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800910:	845e                	mv	s0,s7
  800912:	00140b93          	addi	s7,s0,1
  800916:	fdd6051b          	addiw	a0,a2,-35
  80091a:	0ff57513          	zext.b	a0,a0
  80091e:	faa878e3          	bgeu	a6,a0,8008ce <vsnprintf+0xb4>
    b->cnt ++;
  800922:	57a2                	lw	a5,40(sp)
    if (b->buf < b->ebuf) {
  800924:	6562                	ld	a0,24(sp)
  800926:	7702                	ld	a4,32(sp)
    b->cnt ++;
  800928:	2785                	addiw	a5,a5,1
  80092a:	d43e                	sw	a5,40(sp)
    if (b->buf < b->ebuf) {
  80092c:	00e57763          	bgeu	a0,a4,80093a <vsnprintf+0x120>
        *b->buf ++ = ch;
  800930:	00150793          	addi	a5,a0,1
  800934:	ec3e                	sd	a5,24(sp)
  800936:	00950023          	sb	s1,0(a0)
            for (fmt --; fmt[-1] != '%'; fmt --)
  80093a:	fff44783          	lbu	a5,-1(s0)
  80093e:	8ba2                	mv	s7,s0
  800940:	54978763          	beq	a5,s1,800e8e <vsnprintf+0x674>
  800944:	1bfd                	addi	s7,s7,-1
  800946:	873e                	mv	a4,a5
  800948:	fffbc783          	lbu	a5,-1(s7)
  80094c:	fe979ce3          	bne	a5,s1,800944 <vsnprintf+0x12a>
  800950:	b715                	j	800874 <vsnprintf+0x5a>
                precision = precision * 10 + ch - '0';
  800952:	fd06059b          	addiw	a1,a2,-48
                ch = *fmt;
  800956:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  80095a:	845e                	mv	s0,s7
                if (ch < '0' || ch > '9') {
  80095c:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
  800960:	0006071b          	sext.w	a4,a2
                if (ch < '0' || ch > '9') {
  800964:	02d8e363          	bltu	a7,a3,80098a <vsnprintf+0x170>
                ch = *fmt;
  800968:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
  80096c:	0025969b          	slliw	a3,a1,0x2
  800970:	9db5                	addw	a1,a1,a3
  800972:	0015959b          	slliw	a1,a1,0x1
  800976:	9db9                	addw	a1,a1,a4
                if (ch < '0' || ch > '9') {
  800978:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
  80097c:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  80097e:	fd05859b          	addiw	a1,a1,-48
                ch = *fmt;
  800982:	0006071b          	sext.w	a4,a2
                if (ch < '0' || ch > '9') {
  800986:	fed8f1e3          	bgeu	a7,a3,800968 <vsnprintf+0x14e>
            if (width < 0)
  80098a:	f207dae3          	bgez	a5,8008be <vsnprintf+0xa4>
                width = precision, precision = -1;
  80098e:	87ae                	mv	a5,a1
  800990:	55fd                	li	a1,-1
  800992:	b735                	j	8008be <vsnprintf+0xa4>
    if (lflag >= 2) {
  800994:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800996:	008b0693          	addi	a3,s6,8
    if (lflag >= 2) {
  80099a:	00674463          	blt	a4,t1,8009a2 <vsnprintf+0x188>
    else if (lflag) {
  80099e:	36030e63          	beqz	t1,800d1a <vsnprintf+0x500>
        return va_arg(*ap, long);
  8009a2:	000b3703          	ld	a4,0(s6)
            if ((long long)num < 0) {
  8009a6:	4a074063          	bltz	a4,800e46 <vsnprintf+0x62c>
                num = -(long long)num;
  8009aa:	8b36                	mv	s6,a3
  8009ac:	45a9                	li	a1,10
  8009ae:	4629                	li	a2,10
    unsigned mod = do_div(result, base);
  8009b0:	02b77c33          	remu	s8,a4,a1
    if (num >= base) {
  8009b4:	10b77a63          	bgeu	a4,a1,800ac8 <vsnprintf+0x2ae>
        while (-- width > 0)
  8009b8:	37fd                	addiw	a5,a5,-1
    b->cnt ++;
  8009ba:	55a2                	lw	a1,40(sp)
    if (b->buf < b->ebuf) {
  8009bc:	6562                	ld	a0,24(sp)
  8009be:	7682                	ld	a3,32(sp)
        while (-- width > 0)
  8009c0:	02f05063          	blez	a5,8009e0 <vsnprintf+0x1c6>
    b->cnt ++;
  8009c4:	2585                	addiw	a1,a1,1
  8009c6:	d42e                	sw	a1,40(sp)
    if (b->buf < b->ebuf) {
  8009c8:	28d57263          	bgeu	a0,a3,800c4c <vsnprintf+0x432>
        *b->buf ++ = ch;
  8009cc:	00150713          	addi	a4,a0,1
  8009d0:	ec3a                	sd	a4,24(sp)
  8009d2:	01950023          	sb	s9,0(a0)
        while (-- width > 0)
  8009d6:	37fd                	addiw	a5,a5,-1
    b->cnt ++;
  8009d8:	55a2                	lw	a1,40(sp)
    if (b->buf < b->ebuf) {
  8009da:	6562                	ld	a0,24(sp)
  8009dc:	7682                	ld	a3,32(sp)
        while (-- width > 0)
  8009de:	f3fd                	bnez	a5,8009c4 <vsnprintf+0x1aa>
    b->cnt ++;
  8009e0:	2585                	addiw	a1,a1,1
    putch("0123456789abcdef"[mod], putdat);
  8009e2:	9c4e                	add	s8,s8,s3
    b->cnt ++;
  8009e4:	d42e                	sw	a1,40(sp)
    putch("0123456789abcdef"[mod], putdat);
  8009e6:	000c4783          	lbu	a5,0(s8)
    if (b->buf < b->ebuf) {
  8009ea:	1ed57063          	bgeu	a0,a3,800bca <vsnprintf+0x3b0>
        *b->buf ++ = ch;
  8009ee:	00150713          	addi	a4,a0,1
  8009f2:	ec3a                	sd	a4,24(sp)
  8009f4:	00f50023          	sb	a5,0(a0)
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8009f8:	00144703          	lbu	a4,1(s0)
  8009fc:	bda5                	j	800874 <vsnprintf+0x5a>
            err = va_arg(ap, int);
  8009fe:	000b2783          	lw	a5,0(s6)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800a02:	4761                	li	a4,24
            err = va_arg(ap, int);
  800a04:	0b21                	addi	s6,s6,8
            if (err < 0) {
  800a06:	41f7d69b          	sraiw	a3,a5,0x1f
  800a0a:	8fb5                	xor	a5,a5,a3
  800a0c:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800a10:	02d74663          	blt	a4,a3,800a3c <vsnprintf+0x222>
  800a14:	00369793          	slli	a5,a3,0x3
  800a18:	97d2                	add	a5,a5,s4
  800a1a:	639c                	ld	a5,0(a5)
  800a1c:	c385                	beqz	a5,800a3c <vsnprintf+0x222>
                printfmt(putch, putdat, "%s", p);
  800a1e:	86be                	mv	a3,a5
  800a20:	00000617          	auipc	a2,0x0
  800a24:	5b860613          	addi	a2,a2,1464 # 800fd8 <main+0x62>
  800a28:	082c                	addi	a1,sp,24
  800a2a:	fffff517          	auipc	a0,0xfffff
  800a2e:	6c450513          	addi	a0,a0,1732 # 8000ee <sprintputch>
  800a32:	dc9ff0ef          	jal	ra,8007fa <printfmt>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800a36:	00144703          	lbu	a4,1(s0)
  800a3a:	bd2d                	j	800874 <vsnprintf+0x5a>
                printfmt(putch, putdat, "error %d", err);
  800a3c:	00000617          	auipc	a2,0x0
  800a40:	58c60613          	addi	a2,a2,1420 # 800fc8 <main+0x52>
  800a44:	082c                	addi	a1,sp,24
  800a46:	fffff517          	auipc	a0,0xfffff
  800a4a:	6a850513          	addi	a0,a0,1704 # 8000ee <sprintputch>
  800a4e:	dadff0ef          	jal	ra,8007fa <printfmt>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800a52:	00144703          	lbu	a4,1(s0)
                printfmt(putch, putdat, "error %d", err);
  800a56:	bd39                	j	800874 <vsnprintf+0x5a>
        switch (ch = *(unsigned char *)fmt ++) {
  800a58:	00144603          	lbu	a2,1(s0)
            lflag ++;
  800a5c:	2305                	addiw	t1,t1,1
        switch (ch = *(unsigned char *)fmt ++) {
  800a5e:	845e                	mv	s0,s7
            goto reswitch;
  800a60:	bdb9                	j	8008be <vsnprintf+0xa4>
    if (lflag >= 2) {
  800a62:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800a64:	008b0693          	addi	a3,s6,8
    if (lflag >= 2) {
  800a68:	00674463          	blt	a4,t1,800a70 <vsnprintf+0x256>
    else if (lflag) {
  800a6c:	2a030163          	beqz	t1,800d0e <vsnprintf+0x4f4>
        return va_arg(*ap, unsigned long);
  800a70:	000b3703          	ld	a4,0(s6)
  800a74:	45a1                	li	a1,8
  800a76:	8b36                	mv	s6,a3
  800a78:	4621                	li	a2,8
  800a7a:	bf1d                	j	8009b0 <vsnprintf+0x196>
    b->cnt ++;
  800a7c:	5722                	lw	a4,40(sp)
    if (b->buf < b->ebuf) {
  800a7e:	66e2                	ld	a3,24(sp)
  800a80:	7602                	ld	a2,32(sp)
    b->cnt ++;
  800a82:	0017059b          	addiw	a1,a4,1
  800a86:	d42e                	sw	a1,40(sp)
    if (b->buf < b->ebuf) {
  800a88:	20c6f963          	bgeu	a3,a2,800c9a <vsnprintf+0x480>
        *b->buf ++ = ch;
  800a8c:	00168713          	addi	a4,a3,1
  800a90:	ec3a                	sd	a4,24(sp)
  800a92:	03000713          	li	a4,48
  800a96:	00e68023          	sb	a4,0(a3)
    b->cnt ++;
  800a9a:	56a2                	lw	a3,40(sp)
    if (b->buf < b->ebuf) {
  800a9c:	6762                	ld	a4,24(sp)
  800a9e:	7602                	ld	a2,32(sp)
    b->cnt ++;
  800aa0:	2685                	addiw	a3,a3,1
  800aa2:	d436                	sw	a3,40(sp)
    if (b->buf < b->ebuf) {
  800aa4:	00c77963          	bgeu	a4,a2,800ab6 <vsnprintf+0x29c>
        *b->buf ++ = ch;
  800aa8:	00170693          	addi	a3,a4,1
  800aac:	ec36                	sd	a3,24(sp)
  800aae:	07800693          	li	a3,120
  800ab2:	00d70023          	sb	a3,0(a4)
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800ab6:	000b3703          	ld	a4,0(s6)
            goto number;
  800aba:	45c1                	li	a1,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800abc:	0b21                	addi	s6,s6,8
    unsigned mod = do_div(result, base);
  800abe:	02b77c33          	remu	s8,a4,a1
            goto number;
  800ac2:	4641                	li	a2,16
    if (num >= base) {
  800ac4:	eeb76ae3          	bltu	a4,a1,8009b8 <vsnprintf+0x19e>
        while (-- width > 0)
  800ac8:	ffe7869b          	addiw	a3,a5,-2
    unsigned mod = do_div(result, base);
  800acc:	02b75733          	divu	a4,a4,a1
  800ad0:	02b77d33          	remu	s10,a4,a1
    if (num >= base) {
  800ad4:	1ab77863          	bgeu	a4,a1,800c84 <vsnprintf+0x46a>
    b->cnt ++;
  800ad8:	5622                	lw	a2,40(sp)
    if (b->buf < b->ebuf) {
  800ada:	6562                	ld	a0,24(sp)
  800adc:	7582                	ld	a1,32(sp)
        while (-- width > 0)
  800ade:	02d05063          	blez	a3,800afe <vsnprintf+0x2e4>
    b->cnt ++;
  800ae2:	2605                	addiw	a2,a2,1
  800ae4:	d432                	sw	a2,40(sp)
    if (b->buf < b->ebuf) {
  800ae6:	16b57e63          	bgeu	a0,a1,800c62 <vsnprintf+0x448>
        *b->buf ++ = ch;
  800aea:	00150793          	addi	a5,a0,1
  800aee:	ec3e                	sd	a5,24(sp)
  800af0:	01950023          	sb	s9,0(a0)
        while (-- width > 0)
  800af4:	36fd                	addiw	a3,a3,-1
    b->cnt ++;
  800af6:	5622                	lw	a2,40(sp)
    if (b->buf < b->ebuf) {
  800af8:	6562                	ld	a0,24(sp)
  800afa:	7582                	ld	a1,32(sp)
        while (-- width > 0)
  800afc:	f2fd                	bnez	a3,800ae2 <vsnprintf+0x2c8>
    b->cnt ++;
  800afe:	0016079b          	addiw	a5,a2,1
    putch("0123456789abcdef"[mod], putdat);
  800b02:	9d4e                	add	s10,s10,s3
    b->cnt ++;
  800b04:	d43e                	sw	a5,40(sp)
    putch("0123456789abcdef"[mod], putdat);
  800b06:	000d4783          	lbu	a5,0(s10)
    if (b->buf < b->ebuf) {
  800b0a:	16b57863          	bgeu	a0,a1,800c7a <vsnprintf+0x460>
        *b->buf ++ = ch;
  800b0e:	00150713          	addi	a4,a0,1
  800b12:	ec3a                	sd	a4,24(sp)
  800b14:	00f50023          	sb	a5,0(a0)
    b->cnt ++;
  800b18:	55a2                	lw	a1,40(sp)
    if (b->buf < b->ebuf) {
  800b1a:	6562                	ld	a0,24(sp)
  800b1c:	7682                	ld	a3,32(sp)
  800b1e:	b5c9                	j	8009e0 <vsnprintf+0x1c6>
            if ((p = va_arg(ap, char *)) == NULL) {
  800b20:	000b3c03          	ld	s8,0(s6)
  800b24:	0b21                	addi	s6,s6,8
  800b26:	160c0d63          	beqz	s8,800ca0 <vsnprintf+0x486>
            if (width > 0 && padc != '-') {
  800b2a:	1af05d63          	blez	a5,800ce4 <vsnprintf+0x4ca>
  800b2e:	02d00713          	li	a4,45
  800b32:	18ec9063          	bne	s9,a4,800cb2 <vsnprintf+0x498>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800b36:	000c4603          	lbu	a2,0(s8)
  800b3a:	1e060363          	beqz	a2,800d20 <vsnprintf+0x506>
  800b3e:	001c0713          	addi	a4,s8,1
  800b42:	260d0f63          	beqz	s10,800dc0 <vsnprintf+0x5a6>
  800b46:	5efd                	li	t4,-1
                if (altflag && (ch < ' ' || ch > '~')) {
  800b48:	05e00e13          	li	t3,94
        *b->buf ++ = ch;
  800b4c:	03f00f13          	li	t5,63
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800b50:	0405c163          	bltz	a1,800b92 <vsnprintf+0x378>
  800b54:	fff5889b          	addiw	a7,a1,-1
  800b58:	25d88e63          	beq	a7,t4,800db4 <vsnprintf+0x59a>
    b->cnt ++;
  800b5c:	56a2                	lw	a3,40(sp)
                if (altflag && (ch < ' ' || ch > '~')) {
  800b5e:	fe06081b          	addiw	a6,a2,-32
    if (b->buf < b->ebuf) {
  800b62:	6562                	ld	a0,24(sp)
    b->cnt ++;
  800b64:	2685                	addiw	a3,a3,1
  800b66:	d436                	sw	a3,40(sp)
    if (b->buf < b->ebuf) {
  800b68:	7302                	ld	t1,32(sp)
                if (altflag && (ch < ' ' || ch > '~')) {
  800b6a:	030e7e63          	bgeu	t3,a6,800ba6 <vsnprintf+0x38c>
    if (b->buf < b->ebuf) {
  800b6e:	00657763          	bgeu	a0,t1,800b7c <vsnprintf+0x362>
        *b->buf ++ = ch;
  800b72:	00150693          	addi	a3,a0,1
  800b76:	ec36                	sd	a3,24(sp)
  800b78:	01e50023          	sb	t5,0(a0)
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800b7c:	00074603          	lbu	a2,0(a4)
  800b80:	37fd                	addiw	a5,a5,-1
  800b82:	0705                	addi	a4,a4,1
  800b84:	22060863          	beqz	a2,800db4 <vsnprintf+0x59a>
  800b88:	1e05c163          	bltz	a1,800d6a <vsnprintf+0x550>
  800b8c:	85c6                	mv	a1,a7
  800b8e:	fc05d3e3          	bgez	a1,800b54 <vsnprintf+0x33a>
    b->cnt ++;
  800b92:	56a2                	lw	a3,40(sp)
                if (altflag && (ch < ' ' || ch > '~')) {
  800b94:	fe06081b          	addiw	a6,a2,-32
    if (b->buf < b->ebuf) {
  800b98:	6562                	ld	a0,24(sp)
    b->cnt ++;
  800b9a:	2685                	addiw	a3,a3,1
  800b9c:	d436                	sw	a3,40(sp)
    if (b->buf < b->ebuf) {
  800b9e:	7302                	ld	t1,32(sp)
  800ba0:	88ae                	mv	a7,a1
                if (altflag && (ch < ' ' || ch > '~')) {
  800ba2:	fd0e66e3          	bltu	t3,a6,800b6e <vsnprintf+0x354>
    if (b->buf < b->ebuf) {
  800ba6:	fc657be3          	bgeu	a0,t1,800b7c <vsnprintf+0x362>
        *b->buf ++ = ch;
  800baa:	00150693          	addi	a3,a0,1
  800bae:	ec36                	sd	a3,24(sp)
  800bb0:	00c50023          	sb	a2,0(a0)
  800bb4:	b7e1                	j	800b7c <vsnprintf+0x362>
    b->cnt ++;
  800bb6:	57a2                	lw	a5,40(sp)
    if (b->buf < b->ebuf) {
  800bb8:	6562                	ld	a0,24(sp)
  800bba:	7702                	ld	a4,32(sp)
    b->cnt ++;
  800bbc:	2785                	addiw	a5,a5,1
  800bbe:	d43e                	sw	a5,40(sp)
            putch(va_arg(ap, int), putdat);
  800bc0:	0b21                	addi	s6,s6,8
  800bc2:	ff8b2783          	lw	a5,-8(s6)
    if (b->buf < b->ebuf) {
  800bc6:	e2e564e3          	bltu	a0,a4,8009ee <vsnprintf+0x1d4>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800bca:	00144703          	lbu	a4,1(s0)
  800bce:	b15d                	j	800874 <vsnprintf+0x5a>
    if (lflag >= 2) {
  800bd0:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800bd2:	008b0693          	addi	a3,s6,8
    if (lflag >= 2) {
  800bd6:	00674463          	blt	a4,t1,800bde <vsnprintf+0x3c4>
    else if (lflag) {
  800bda:	10030e63          	beqz	t1,800cf6 <vsnprintf+0x4dc>
        return va_arg(*ap, unsigned long);
  800bde:	000b3703          	ld	a4,0(s6)
  800be2:	45c1                	li	a1,16
  800be4:	8b36                	mv	s6,a3
  800be6:	4641                	li	a2,16
  800be8:	b3e1                	j	8009b0 <vsnprintf+0x196>
            if (width < 0)
  800bea:	fff7c713          	not	a4,a5
  800bee:	977d                	srai	a4,a4,0x3f
  800bf0:	8ff9                	and	a5,a5,a4
        switch (ch = *(unsigned char *)fmt ++) {
  800bf2:	00144603          	lbu	a2,1(s0)
  800bf6:	2781                	sext.w	a5,a5
  800bf8:	845e                	mv	s0,s7
            goto reswitch;
  800bfa:	b1d1                	j	8008be <vsnprintf+0xa4>
    if (lflag >= 2) {
  800bfc:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800bfe:	008b0693          	addi	a3,s6,8
    if (lflag >= 2) {
  800c02:	00674463          	blt	a4,t1,800c0a <vsnprintf+0x3f0>
    else if (lflag) {
  800c06:	0e030e63          	beqz	t1,800d02 <vsnprintf+0x4e8>
        return va_arg(*ap, unsigned long);
  800c0a:	000b3703          	ld	a4,0(s6)
  800c0e:	45a9                	li	a1,10
  800c10:	8b36                	mv	s6,a3
  800c12:	4629                	li	a2,10
  800c14:	bb71                	j	8009b0 <vsnprintf+0x196>
        switch (ch = *(unsigned char *)fmt ++) {
  800c16:	00144603          	lbu	a2,1(s0)
            altflag = 1;
  800c1a:	4d05                	li	s10,1
        switch (ch = *(unsigned char *)fmt ++) {
  800c1c:	845e                	mv	s0,s7
            goto reswitch;
  800c1e:	b145                	j	8008be <vsnprintf+0xa4>
    b->cnt ++;
  800c20:	57a2                	lw	a5,40(sp)
    if (b->buf < b->ebuf) {
  800c22:	6562                	ld	a0,24(sp)
  800c24:	7702                	ld	a4,32(sp)
    b->cnt ++;
  800c26:	2785                	addiw	a5,a5,1
  800c28:	d43e                	sw	a5,40(sp)
    if (b->buf < b->ebuf) {
  800c2a:	fae570e3          	bgeu	a0,a4,800bca <vsnprintf+0x3b0>
        *b->buf ++ = ch;
  800c2e:	00150793          	addi	a5,a0,1
  800c32:	ec3e                	sd	a5,24(sp)
  800c34:	00950023          	sb	s1,0(a0)
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800c38:	00144703          	lbu	a4,1(s0)
  800c3c:	b925                	j	800874 <vsnprintf+0x5a>
            precision = va_arg(ap, int);
  800c3e:	000b2583          	lw	a1,0(s6)
        switch (ch = *(unsigned char *)fmt ++) {
  800c42:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
  800c46:	0b21                	addi	s6,s6,8
        switch (ch = *(unsigned char *)fmt ++) {
  800c48:	845e                	mv	s0,s7
            goto process_precision;
  800c4a:	b381                	j	80098a <vsnprintf+0x170>
        while (-- width > 0)
  800c4c:	37fd                	addiw	a5,a5,-1
  800c4e:	00b7873b          	addw	a4,a5,a1
  800c52:	2705                	addiw	a4,a4,1
  800c54:	d80786e3          	beqz	a5,8009e0 <vsnprintf+0x1c6>
    b->cnt ++;
  800c58:	40f705bb          	subw	a1,a4,a5
        while (-- width > 0)
  800c5c:	37fd                	addiw	a5,a5,-1
  800c5e:	ffed                	bnez	a5,800c58 <vsnprintf+0x43e>
  800c60:	b341                	j	8009e0 <vsnprintf+0x1c6>
  800c62:	fff6879b          	addiw	a5,a3,-1
  800c66:	00c7873b          	addw	a4,a5,a2
  800c6a:	2705                	addiw	a4,a4,1
  800c6c:	e80789e3          	beqz	a5,800afe <vsnprintf+0x2e4>
    b->cnt ++;
  800c70:	40f7063b          	subw	a2,a4,a5
        while (-- width > 0)
  800c74:	37fd                	addiw	a5,a5,-1
  800c76:	ffed                	bnez	a5,800c70 <vsnprintf+0x456>
  800c78:	b559                	j	800afe <vsnprintf+0x2e4>
    b->cnt ++;
  800c7a:	2609                	addiw	a2,a2,2
  800c7c:	d432                	sw	a2,40(sp)
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800c7e:	00144703          	lbu	a4,1(s0)
  800c82:	becd                	j	800874 <vsnprintf+0x5a>
        printnum(putch, putdat, result, base, width - 1, padc);
  800c84:	02b755b3          	divu	a1,a4,a1
  800c88:	0828                	addi	a0,sp,24
  800c8a:	000c871b          	sext.w	a4,s9
  800c8e:	d62ff0ef          	jal	ra,8001f0 <printnum.constprop.0>
    b->cnt ++;
  800c92:	5622                	lw	a2,40(sp)
    if (b->buf < b->ebuf) {
  800c94:	6562                	ld	a0,24(sp)
  800c96:	7582                	ld	a1,32(sp)
  800c98:	b59d                	j	800afe <vsnprintf+0x2e4>
    b->cnt ++;
  800c9a:	2709                	addiw	a4,a4,2
  800c9c:	d43a                	sw	a4,40(sp)
    if (b->buf < b->ebuf) {
  800c9e:	bd21                	j	800ab6 <vsnprintf+0x29c>
            if (width > 0 && padc != '-') {
  800ca0:	1ef05063          	blez	a5,800e80 <vsnprintf+0x666>
  800ca4:	02d00713          	li	a4,45
                p = "(null)";
  800ca8:	8c56                	mv	s8,s5
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800caa:	02800613          	li	a2,40
            if (width > 0 && padc != '-') {
  800cae:	e8ec88e3          	beq	s9,a4,800b3e <vsnprintf+0x324>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800cb2:	8562                	mv	a0,s8
  800cb4:	e43e                	sd	a5,8(sp)
  800cb6:	e02e                	sd	a1,0(sp)
  800cb8:	216000ef          	jal	ra,800ece <strnlen>
  800cbc:	67a2                	ld	a5,8(sp)
  800cbe:	6582                	ld	a1,0(sp)
  800cc0:	9f89                	subw	a5,a5,a0
  800cc2:	02f05163          	blez	a5,800ce4 <vsnprintf+0x4ca>
    b->cnt ++;
  800cc6:	5722                	lw	a4,40(sp)
    if (b->buf < b->ebuf) {
  800cc8:	6562                	ld	a0,24(sp)
  800cca:	7682                	ld	a3,32(sp)
    b->cnt ++;
  800ccc:	2705                	addiw	a4,a4,1
  800cce:	d43a                	sw	a4,40(sp)
    if (b->buf < b->ebuf) {
  800cd0:	18d57c63          	bgeu	a0,a3,800e68 <vsnprintf+0x64e>
        *b->buf ++ = ch;
  800cd4:	00150713          	addi	a4,a0,1
  800cd8:	ec3a                	sd	a4,24(sp)
  800cda:	01950023          	sb	s9,0(a0)
                for (width -= strnlen(p, precision); width > 0; width --) {
  800cde:	37fd                	addiw	a5,a5,-1
  800ce0:	f3fd                	bnez	a5,800cc6 <vsnprintf+0x4ac>
  800ce2:	4781                	li	a5,0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800ce4:	000c4603          	lbu	a2,0(s8)
  800ce8:	001c0713          	addi	a4,s8,1
  800cec:	e4061be3          	bnez	a2,800b42 <vsnprintf+0x328>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800cf0:	00144703          	lbu	a4,1(s0)
  800cf4:	b641                	j	800874 <vsnprintf+0x5a>
        return va_arg(*ap, unsigned int);
  800cf6:	000b6703          	lwu	a4,0(s6)
  800cfa:	45c1                	li	a1,16
  800cfc:	8b36                	mv	s6,a3
  800cfe:	4641                	li	a2,16
  800d00:	b945                	j	8009b0 <vsnprintf+0x196>
  800d02:	000b6703          	lwu	a4,0(s6)
  800d06:	45a9                	li	a1,10
  800d08:	8b36                	mv	s6,a3
  800d0a:	4629                	li	a2,10
  800d0c:	b155                	j	8009b0 <vsnprintf+0x196>
  800d0e:	000b6703          	lwu	a4,0(s6)
  800d12:	45a1                	li	a1,8
  800d14:	8b36                	mv	s6,a3
  800d16:	4621                	li	a2,8
  800d18:	b961                	j	8009b0 <vsnprintf+0x196>
        return va_arg(*ap, int);
  800d1a:	000b2703          	lw	a4,0(s6)
  800d1e:	b161                	j	8009a6 <vsnprintf+0x18c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800d20:	85be                	mv	a1,a5
    b->cnt ++;
  800d22:	57a2                	lw	a5,40(sp)
    if (b->buf < b->ebuf) {
  800d24:	6562                	ld	a0,24(sp)
  800d26:	7702                	ld	a4,32(sp)
    b->cnt ++;
  800d28:	2785                	addiw	a5,a5,1
  800d2a:	d43e                	sw	a5,40(sp)
        *b->buf ++ = ch;
  800d2c:	02000693          	li	a3,32
    if (b->buf < b->ebuf) {
  800d30:	02e57163          	bgeu	a0,a4,800d52 <vsnprintf+0x538>
        *b->buf ++ = ch;
  800d34:	00150793          	addi	a5,a0,1
  800d38:	ec3e                	sd	a5,24(sp)
  800d3a:	00d50023          	sb	a3,0(a0)
            for (; width > 0; width --) {
  800d3e:	35fd                	addiw	a1,a1,-1
  800d40:	e80585e3          	beqz	a1,800bca <vsnprintf+0x3b0>
    b->cnt ++;
  800d44:	57a2                	lw	a5,40(sp)
    if (b->buf < b->ebuf) {
  800d46:	6562                	ld	a0,24(sp)
  800d48:	7702                	ld	a4,32(sp)
    b->cnt ++;
  800d4a:	2785                	addiw	a5,a5,1
  800d4c:	d43e                	sw	a5,40(sp)
    if (b->buf < b->ebuf) {
  800d4e:	fee563e3          	bltu	a0,a4,800d34 <vsnprintf+0x51a>
            for (; width > 0; width --) {
  800d52:	fff5879b          	addiw	a5,a1,-1
  800d56:	e6078ae3          	beqz	a5,800bca <vsnprintf+0x3b0>
  800d5a:	5722                	lw	a4,40(sp)
  800d5c:	37fd                	addiw	a5,a5,-1
    b->cnt ++;
  800d5e:	2705                	addiw	a4,a4,1
            for (; width > 0; width --) {
  800d60:	fff5                	bnez	a5,800d5c <vsnprintf+0x542>
  800d62:	d43a                	sw	a4,40(sp)
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800d64:	00144703          	lbu	a4,1(s0)
  800d68:	b631                	j	800874 <vsnprintf+0x5a>
  800d6a:	9fb9                	addw	a5,a5,a4
                if (altflag && (ch < ' ' || ch > '~')) {
  800d6c:	05e00813          	li	a6,94
        *b->buf ++ = ch;
  800d70:	03f00313          	li	t1,63
  800d74:	37fd                	addiw	a5,a5,-1
  800d76:	a831                	j	800d92 <vsnprintf+0x578>
    if (b->buf < b->ebuf) {
  800d78:	01157763          	bgeu	a0,a7,800d86 <vsnprintf+0x56c>
        *b->buf ++ = ch;
  800d7c:	00150693          	addi	a3,a0,1
  800d80:	ec36                	sd	a3,24(sp)
  800d82:	00650023          	sb	t1,0(a0)
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800d86:	00074603          	lbu	a2,0(a4)
  800d8a:	40e785bb          	subw	a1,a5,a4
  800d8e:	0705                	addi	a4,a4,1
  800d90:	c21d                	beqz	a2,800db6 <vsnprintf+0x59c>
    b->cnt ++;
  800d92:	55a2                	lw	a1,40(sp)
                if (altflag && (ch < ' ' || ch > '~')) {
  800d94:	fe06069b          	addiw	a3,a2,-32
    if (b->buf < b->ebuf) {
  800d98:	6562                	ld	a0,24(sp)
    b->cnt ++;
  800d9a:	2585                	addiw	a1,a1,1
  800d9c:	d42e                	sw	a1,40(sp)
    if (b->buf < b->ebuf) {
  800d9e:	7882                	ld	a7,32(sp)
                if (altflag && (ch < ' ' || ch > '~')) {
  800da0:	fcd86ce3          	bltu	a6,a3,800d78 <vsnprintf+0x55e>
    if (b->buf < b->ebuf) {
  800da4:	ff1571e3          	bgeu	a0,a7,800d86 <vsnprintf+0x56c>
        *b->buf ++ = ch;
  800da8:	00150693          	addi	a3,a0,1
  800dac:	ec36                	sd	a3,24(sp)
  800dae:	00c50023          	sb	a2,0(a0)
  800db2:	bfd1                	j	800d86 <vsnprintf+0x56c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800db4:	85be                	mv	a1,a5
            for (; width > 0; width --) {
  800db6:	f6b046e3          	bgtz	a1,800d22 <vsnprintf+0x508>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800dba:	00144703          	lbu	a4,1(s0)
  800dbe:	bc5d                	j	800874 <vsnprintf+0x5a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800dc0:	537d                	li	t1,-1
  800dc2:	0205cc63          	bltz	a1,800dfa <vsnprintf+0x5e0>
  800dc6:	fff5889b          	addiw	a7,a1,-1
  800dca:	fe6885e3          	beq	a7,t1,800db4 <vsnprintf+0x59a>
    b->cnt ++;
  800dce:	5822                	lw	a6,40(sp)
    if (b->buf < b->ebuf) {
  800dd0:	6562                	ld	a0,24(sp)
  800dd2:	7682                	ld	a3,32(sp)
    b->cnt ++;
  800dd4:	2805                	addiw	a6,a6,1
  800dd6:	d442                	sw	a6,40(sp)
    if (b->buf < b->ebuf) {
  800dd8:	00d57763          	bgeu	a0,a3,800de6 <vsnprintf+0x5cc>
        *b->buf ++ = ch;
  800ddc:	00150693          	addi	a3,a0,1
  800de0:	ec36                	sd	a3,24(sp)
  800de2:	00c50023          	sb	a2,0(a0)
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800de6:	00074603          	lbu	a2,0(a4)
  800dea:	37fd                	addiw	a5,a5,-1
  800dec:	0705                	addi	a4,a4,1
  800dee:	d279                	beqz	a2,800db4 <vsnprintf+0x59a>
  800df0:	0005c763          	bltz	a1,800dfe <vsnprintf+0x5e4>
  800df4:	85c6                	mv	a1,a7
  800df6:	fc05d8e3          	bgez	a1,800dc6 <vsnprintf+0x5ac>
  800dfa:	88ae                	mv	a7,a1
  800dfc:	bfc9                	j	800dce <vsnprintf+0x5b4>
  800dfe:	6562                	ld	a0,24(sp)
  800e00:	7682                	ld	a3,32(sp)
  800e02:	9fb9                	addw	a5,a5,a4
  800e04:	37fd                	addiw	a5,a5,-1
    b->cnt ++;
  800e06:	55a2                	lw	a1,40(sp)
  800e08:	2585                	addiw	a1,a1,1
  800e0a:	d42e                	sw	a1,40(sp)
    if (b->buf < b->ebuf) {
  800e0c:	02d57463          	bgeu	a0,a3,800e34 <vsnprintf+0x61a>
        *b->buf ++ = ch;
  800e10:	00150693          	addi	a3,a0,1
  800e14:	ec36                	sd	a3,24(sp)
  800e16:	00c50023          	sb	a2,0(a0)
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800e1a:	00074603          	lbu	a2,0(a4)
  800e1e:	40e785bb          	subw	a1,a5,a4
  800e22:	0705                	addi	a4,a4,1
  800e24:	da49                	beqz	a2,800db6 <vsnprintf+0x59c>
    b->cnt ++;
  800e26:	55a2                	lw	a1,40(sp)
  800e28:	6562                	ld	a0,24(sp)
  800e2a:	7682                	ld	a3,32(sp)
  800e2c:	2585                	addiw	a1,a1,1
  800e2e:	d42e                	sw	a1,40(sp)
    if (b->buf < b->ebuf) {
  800e30:	fed560e3          	bltu	a0,a3,800e10 <vsnprintf+0x5f6>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800e34:	00074603          	lbu	a2,0(a4)
  800e38:	40e785bb          	subw	a1,a5,a4
  800e3c:	0705                	addi	a4,a4,1
  800e3e:	f661                	bnez	a2,800e06 <vsnprintf+0x5ec>
            for (; width > 0; width --) {
  800e40:	eeb041e3          	bgtz	a1,800d22 <vsnprintf+0x508>
  800e44:	bf9d                	j	800dba <vsnprintf+0x5a0>
    b->cnt ++;
  800e46:	5622                	lw	a2,40(sp)
    if (b->buf < b->ebuf) {
  800e48:	65e2                	ld	a1,24(sp)
  800e4a:	7502                	ld	a0,32(sp)
    b->cnt ++;
  800e4c:	2605                	addiw	a2,a2,1
  800e4e:	d432                	sw	a2,40(sp)
    if (b->buf < b->ebuf) {
  800e50:	00a5f963          	bgeu	a1,a0,800e62 <vsnprintf+0x648>
        *b->buf ++ = ch;
  800e54:	00158613          	addi	a2,a1,1
  800e58:	ec32                	sd	a2,24(sp)
  800e5a:	02d00613          	li	a2,45
  800e5e:	00c58023          	sb	a2,0(a1)
                num = -(long long)num;
  800e62:	40e00733          	neg	a4,a4
  800e66:	b691                	j	8009aa <vsnprintf+0x190>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800e68:	37fd                	addiw	a5,a5,-1
  800e6a:	e6078ce3          	beqz	a5,800ce2 <vsnprintf+0x4c8>
  800e6e:	5722                	lw	a4,40(sp)
  800e70:	37fd                	addiw	a5,a5,-1
    b->cnt ++;
  800e72:	2705                	addiw	a4,a4,1
                for (width -= strnlen(p, precision); width > 0; width --) {
  800e74:	fff5                	bnez	a5,800e70 <vsnprintf+0x656>
  800e76:	d43a                	sw	a4,40(sp)
  800e78:	4781                	li	a5,0
  800e7a:	b5ad                	j	800ce4 <vsnprintf+0x4ca>
        return -E_INVAL;
  800e7c:	5575                	li	a0,-3
  800e7e:	bc85                	j	8008ee <vsnprintf+0xd4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800e80:	02800613          	li	a2,40
  800e84:	00000717          	auipc	a4,0x0
  800e88:	13d70713          	addi	a4,a4,317 # 800fc1 <main+0x4b>
  800e8c:	b95d                	j	800b42 <vsnprintf+0x328>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800e8e:	00044703          	lbu	a4,0(s0)
  800e92:	b2cd                	j	800874 <vsnprintf+0x5a>

0000000000800e94 <snprintf>:
snprintf(char *str, size_t size, const char *fmt, ...) {
  800e94:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  800e96:	02810313          	addi	t1,sp,40
snprintf(char *str, size_t size, const char *fmt, ...) {
  800e9a:	f436                	sd	a3,40(sp)
    cnt = vsnprintf(str, size, fmt, ap);
  800e9c:	869a                	mv	a3,t1
snprintf(char *str, size_t size, const char *fmt, ...) {
  800e9e:	ec06                	sd	ra,24(sp)
  800ea0:	f83a                	sd	a4,48(sp)
  800ea2:	fc3e                	sd	a5,56(sp)
  800ea4:	e0c2                	sd	a6,64(sp)
  800ea6:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  800ea8:	e41a                	sd	t1,8(sp)
    cnt = vsnprintf(str, size, fmt, ap);
  800eaa:	971ff0ef          	jal	ra,80081a <vsnprintf>
}
  800eae:	60e2                	ld	ra,24(sp)
  800eb0:	6161                	addi	sp,sp,80
  800eb2:	8082                	ret

0000000000800eb4 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  800eb4:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
  800eb8:	872a                	mv	a4,a0
    size_t cnt = 0;
  800eba:	4501                	li	a0,0
    while (*s ++ != '\0') {
  800ebc:	cb81                	beqz	a5,800ecc <strlen+0x18>
        cnt ++;
  800ebe:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
  800ec0:	00a707b3          	add	a5,a4,a0
  800ec4:	0007c783          	lbu	a5,0(a5)
  800ec8:	fbfd                	bnez	a5,800ebe <strlen+0xa>
  800eca:	8082                	ret
    }
    return cnt;
}
  800ecc:	8082                	ret

0000000000800ece <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  800ece:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  800ed0:	e589                	bnez	a1,800eda <strnlen+0xc>
  800ed2:	a811                	j	800ee6 <strnlen+0x18>
        cnt ++;
  800ed4:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  800ed6:	00f58863          	beq	a1,a5,800ee6 <strnlen+0x18>
  800eda:	00f50733          	add	a4,a0,a5
  800ede:	00074703          	lbu	a4,0(a4)
  800ee2:	fb6d                	bnez	a4,800ed4 <strnlen+0x6>
  800ee4:	85be                	mv	a1,a5
    }
    return cnt;
}
  800ee6:	852e                	mv	a0,a1
  800ee8:	8082                	ret

0000000000800eea <forktree>:
        exit(0);
    }
}

void
forktree(const char *cur) {
  800eea:	1101                	addi	sp,sp,-32
  800eec:	ec06                	sd	ra,24(sp)
  800eee:	e822                	sd	s0,16(sp)
  800ef0:	842a                	mv	s0,a0
    cprintf("%04x: I am '%s'\n", getpid(), cur);
  800ef2:	9eeff0ef          	jal	ra,8000e0 <getpid>
  800ef6:	85aa                	mv	a1,a0
  800ef8:	8622                	mv	a2,s0
  800efa:	00000517          	auipc	a0,0x0
  800efe:	51e50513          	addi	a0,a0,1310 # 801418 <error_string+0xc8>
  800f02:	93eff0ef          	jal	ra,800040 <cprintf>
    if (strlen(cur) >= DEPTH)
  800f06:	8522                	mv	a0,s0
  800f08:	fadff0ef          	jal	ra,800eb4 <strlen>
  800f0c:	478d                	li	a5,3
  800f0e:	00a7fc63          	bgeu	a5,a0,800f26 <forktree+0x3c>
  800f12:	8522                	mv	a0,s0
  800f14:	fa1ff0ef          	jal	ra,800eb4 <strlen>
  800f18:	478d                	li	a5,3
  800f1a:	02a7fc63          	bgeu	a5,a0,800f52 <forktree+0x68>

    forkchild(cur, '0');
    forkchild(cur, '1');
}
  800f1e:	60e2                	ld	ra,24(sp)
  800f20:	6442                	ld	s0,16(sp)
  800f22:	6105                	addi	sp,sp,32
  800f24:	8082                	ret
    snprintf(nxt, DEPTH + 1, "%s%c", cur, branch);
  800f26:	03000713          	li	a4,48
  800f2a:	86a2                	mv	a3,s0
  800f2c:	00000617          	auipc	a2,0x0
  800f30:	50460613          	addi	a2,a2,1284 # 801430 <error_string+0xe0>
  800f34:	4595                	li	a1,5
  800f36:	0028                	addi	a0,sp,8
  800f38:	f5dff0ef          	jal	ra,800e94 <snprintf>
    if (fork() == 0) {
  800f3c:	9a0ff0ef          	jal	ra,8000dc <fork>
  800f40:	f969                	bnez	a0,800f12 <forktree+0x28>
        forktree(nxt);
  800f42:	0028                	addi	a0,sp,8
  800f44:	fa7ff0ef          	jal	ra,800eea <forktree>
        yield();
  800f48:	996ff0ef          	jal	ra,8000de <yield>
        exit(0);
  800f4c:	4501                	li	a0,0
  800f4e:	978ff0ef          	jal	ra,8000c6 <exit>
    snprintf(nxt, DEPTH + 1, "%s%c", cur, branch);
  800f52:	03100713          	li	a4,49
  800f56:	86a2                	mv	a3,s0
  800f58:	00000617          	auipc	a2,0x0
  800f5c:	4d860613          	addi	a2,a2,1240 # 801430 <error_string+0xe0>
  800f60:	4595                	li	a1,5
  800f62:	0028                	addi	a0,sp,8
  800f64:	f31ff0ef          	jal	ra,800e94 <snprintf>
    if (fork() == 0) {
  800f68:	974ff0ef          	jal	ra,8000dc <fork>
  800f6c:	d979                	beqz	a0,800f42 <forktree+0x58>
}
  800f6e:	60e2                	ld	ra,24(sp)
  800f70:	6442                	ld	s0,16(sp)
  800f72:	6105                	addi	sp,sp,32
  800f74:	8082                	ret

0000000000800f76 <main>:

int
main(void) {
  800f76:	1141                	addi	sp,sp,-16
    forktree("");
  800f78:	00000517          	auipc	a0,0x0
  800f7c:	4b050513          	addi	a0,a0,1200 # 801428 <error_string+0xd8>
main(void) {
  800f80:	e406                	sd	ra,8(sp)
    forktree("");
  800f82:	f69ff0ef          	jal	ra,800eea <forktree>
    return 0;
}
  800f86:	60a2                	ld	ra,8(sp)
  800f88:	4501                	li	a0,0
  800f8a:	0141                	addi	sp,sp,16
  800f8c:	8082                	ret
