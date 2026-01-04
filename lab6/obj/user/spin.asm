
obj/__user_spin.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	130000ef          	jal	ra,800150 <umain>
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
  80003a:	78250513          	addi	a0,a0,1922 # 8007b8 <main+0xd2>
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
  80005a:	78250513          	addi	a0,a0,1922 # 8007d8 <main+0xf2>
  80005e:	044000ef          	jal	ra,8000a2 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800062:	5559                	li	a0,-10
  800064:	0ce000ef          	jal	ra,800132 <exit>

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
  800070:	0bc000ef          	jal	ra,80012c <sys_putc>
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
  800096:	1ae000ef          	jal	ra,800244 <vprintfmt>
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
  8000cc:	178000ef          	jal	ra,800244 <vprintfmt>
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

000000000080012c <sys_putc>:
sys_getpid(void) {
    return syscall(SYS_getpid);
}

int
sys_putc(int64_t c) {
  80012c:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  80012e:	4579                	li	a0,30
  800130:	b765                	j	8000d8 <syscall>

0000000000800132 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  800132:	1141                	addi	sp,sp,-16
  800134:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  800136:	fdbff0ef          	jal	ra,800110 <sys_exit>
    cprintf("BUG: exit failed.\n");
  80013a:	00000517          	auipc	a0,0x0
  80013e:	6a650513          	addi	a0,a0,1702 # 8007e0 <main+0xfa>
  800142:	f61ff0ef          	jal	ra,8000a2 <cprintf>
    while (1);
  800146:	a001                	j	800146 <exit+0x14>

0000000000800148 <fork>:
}

int
fork(void) {
    return sys_fork();
  800148:	b7f9                	j	800116 <sys_fork>

000000000080014a <waitpid>:
    return sys_wait(0, NULL);
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

000000000080014e <kill>:
}

int
kill(int pid) {
    return sys_kill(pid);
  80014e:	bfe1                	j	800126 <sys_kill>

0000000000800150 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  800150:	1141                	addi	sp,sp,-16
  800152:	e406                	sd	ra,8(sp)
    int ret = main();
  800154:	592000ef          	jal	ra,8006e6 <main>
    exit(ret);
  800158:	fdbff0ef          	jal	ra,800132 <exit>

000000000080015c <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  80015c:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800160:	7139                	addi	sp,sp,-64
    unsigned mod = do_div(result, base);
  800162:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800166:	e852                	sd	s4,16(sp)
    unsigned mod = do_div(result, base);
  800168:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  80016c:	f426                	sd	s1,40(sp)
  80016e:	f04a                	sd	s2,32(sp)
  800170:	ec4e                	sd	s3,24(sp)
  800172:	fc06                	sd	ra,56(sp)
  800174:	f822                	sd	s0,48(sp)
  800176:	e456                	sd	s5,8(sp)
  800178:	e05a                	sd	s6,0(sp)
  80017a:	84aa                	mv	s1,a0
  80017c:	892e                	mv	s2,a1
  80017e:	89be                	mv	s3,a5
    unsigned mod = do_div(result, base);
  800180:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  800182:	05067163          	bgeu	a2,a6,8001c4 <printnum+0x68>
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800186:	fff7041b          	addiw	s0,a4,-1
  80018a:	00805763          	blez	s0,800198 <printnum+0x3c>
  80018e:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800190:	85ca                	mv	a1,s2
  800192:	854e                	mv	a0,s3
  800194:	9482                	jalr	s1
        while (-- width > 0)
  800196:	fc65                	bnez	s0,80018e <printnum+0x32>
  800198:	00000417          	auipc	s0,0x0
  80019c:	66040413          	addi	s0,s0,1632 # 8007f8 <main+0x112>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  8001a0:	1a02                	slli	s4,s4,0x20
  8001a2:	020a5a13          	srli	s4,s4,0x20
  8001a6:	9452                	add	s0,s0,s4
  8001a8:	00044503          	lbu	a0,0(s0)
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  8001ac:	7442                	ld	s0,48(sp)
  8001ae:	70e2                	ld	ra,56(sp)
  8001b0:	69e2                	ld	s3,24(sp)
  8001b2:	6a42                	ld	s4,16(sp)
  8001b4:	6aa2                	ld	s5,8(sp)
  8001b6:	6b02                	ld	s6,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001b8:	85ca                	mv	a1,s2
  8001ba:	87a6                	mv	a5,s1
}
  8001bc:	7902                	ld	s2,32(sp)
  8001be:	74a2                	ld	s1,40(sp)
  8001c0:	6121                	addi	sp,sp,64
    putch("0123456789abcdef"[mod], putdat);
  8001c2:	8782                	jr	a5
    unsigned mod = do_div(result, base);
  8001c4:	03065633          	divu	a2,a2,a6
  8001c8:	03067ab3          	remu	s5,a2,a6
  8001cc:	2a81                	sext.w	s5,s5
    if (num >= base) {
  8001ce:	03067863          	bgeu	a2,a6,8001fe <printnum+0xa2>
        while (-- width > 0)
  8001d2:	ffe7041b          	addiw	s0,a4,-2
  8001d6:	00805763          	blez	s0,8001e4 <printnum+0x88>
  8001da:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  8001dc:	85ca                	mv	a1,s2
  8001de:	854e                	mv	a0,s3
  8001e0:	9482                	jalr	s1
        while (-- width > 0)
  8001e2:	fc65                	bnez	s0,8001da <printnum+0x7e>
  8001e4:	00000417          	auipc	s0,0x0
  8001e8:	61440413          	addi	s0,s0,1556 # 8007f8 <main+0x112>
    putch("0123456789abcdef"[mod], putdat);
  8001ec:	1a82                	slli	s5,s5,0x20
  8001ee:	020ada93          	srli	s5,s5,0x20
  8001f2:	9aa2                	add	s5,s5,s0
  8001f4:	000ac503          	lbu	a0,0(s5)
  8001f8:	85ca                	mv	a1,s2
  8001fa:	9482                	jalr	s1
}
  8001fc:	b755                	j	8001a0 <printnum+0x44>
    unsigned mod = do_div(result, base);
  8001fe:	03065633          	divu	a2,a2,a6
        while (-- width > 0)
  800202:	ffd7041b          	addiw	s0,a4,-3
    unsigned mod = do_div(result, base);
  800206:	03067b33          	remu	s6,a2,a6
  80020a:	2b01                	sext.w	s6,s6
    if (num >= base) {
  80020c:	03067663          	bgeu	a2,a6,800238 <printnum+0xdc>
        while (-- width > 0)
  800210:	00805763          	blez	s0,80021e <printnum+0xc2>
  800214:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800216:	85ca                	mv	a1,s2
  800218:	854e                	mv	a0,s3
  80021a:	9482                	jalr	s1
        while (-- width > 0)
  80021c:	fc65                	bnez	s0,800214 <printnum+0xb8>
    putch("0123456789abcdef"[mod], putdat);
  80021e:	1b02                	slli	s6,s6,0x20
  800220:	00000417          	auipc	s0,0x0
  800224:	5d840413          	addi	s0,s0,1496 # 8007f8 <main+0x112>
  800228:	020b5b13          	srli	s6,s6,0x20
  80022c:	9b22                	add	s6,s6,s0
  80022e:	000b4503          	lbu	a0,0(s6)
  800232:	85ca                	mv	a1,s2
  800234:	9482                	jalr	s1
}
  800236:	bf5d                	j	8001ec <printnum+0x90>
        printnum(putch, putdat, result, base, width - 1, padc);
  800238:	03065633          	divu	a2,a2,a6
  80023c:	8722                	mv	a4,s0
  80023e:	f1fff0ef          	jal	ra,80015c <printnum>
  800242:	bff1                	j	80021e <printnum+0xc2>

0000000000800244 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  800244:	7119                	addi	sp,sp,-128
  800246:	f4a6                	sd	s1,104(sp)
  800248:	f0ca                	sd	s2,96(sp)
  80024a:	ecce                	sd	s3,88(sp)
  80024c:	e8d2                	sd	s4,80(sp)
  80024e:	e4d6                	sd	s5,72(sp)
  800250:	e0da                	sd	s6,64(sp)
  800252:	fc5e                	sd	s7,56(sp)
  800254:	f466                	sd	s9,40(sp)
  800256:	fc86                	sd	ra,120(sp)
  800258:	f8a2                	sd	s0,112(sp)
  80025a:	f862                	sd	s8,48(sp)
  80025c:	f06a                	sd	s10,32(sp)
  80025e:	ec6e                	sd	s11,24(sp)
  800260:	892a                	mv	s2,a0
  800262:	84ae                	mv	s1,a1
  800264:	8cb2                	mv	s9,a2
  800266:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800268:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  80026c:	5bfd                	li	s7,-1
  80026e:	00000a97          	auipc	s5,0x0
  800272:	5bea8a93          	addi	s5,s5,1470 # 80082c <main+0x146>
    putch("0123456789abcdef"[mod], putdat);
  800276:	00000b17          	auipc	s6,0x0
  80027a:	582b0b13          	addi	s6,s6,1410 # 8007f8 <main+0x112>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80027e:	000cc503          	lbu	a0,0(s9)
  800282:	001c8413          	addi	s0,s9,1
  800286:	01350a63          	beq	a0,s3,80029a <vprintfmt+0x56>
            if (ch == '\0') {
  80028a:	c121                	beqz	a0,8002ca <vprintfmt+0x86>
            putch(ch, putdat);
  80028c:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80028e:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  800290:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800292:	fff44503          	lbu	a0,-1(s0)
  800296:	ff351ae3          	bne	a0,s3,80028a <vprintfmt+0x46>
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  80029a:	00044683          	lbu	a3,0(s0)
        char padc = ' ';
  80029e:	02000813          	li	a6,32
        lflag = altflag = 0;
  8002a2:	4d81                	li	s11,0
  8002a4:	4501                	li	a0,0
        width = precision = -1;
  8002a6:	5c7d                	li	s8,-1
  8002a8:	5d7d                	li	s10,-1
  8002aa:	05500613          	li	a2,85
        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
  8002ae:	45a5                	li	a1,9
        switch (ch = *(unsigned char *)fmt ++) {
  8002b0:	fdd6879b          	addiw	a5,a3,-35
  8002b4:	0ff7f793          	zext.b	a5,a5
  8002b8:	00140c93          	addi	s9,s0,1
  8002bc:	04f66263          	bltu	a2,a5,800300 <vprintfmt+0xbc>
  8002c0:	078a                	slli	a5,a5,0x2
  8002c2:	97d6                	add	a5,a5,s5
  8002c4:	439c                	lw	a5,0(a5)
  8002c6:	97d6                	add	a5,a5,s5
  8002c8:	8782                	jr	a5
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8002ca:	70e6                	ld	ra,120(sp)
  8002cc:	7446                	ld	s0,112(sp)
  8002ce:	74a6                	ld	s1,104(sp)
  8002d0:	7906                	ld	s2,96(sp)
  8002d2:	69e6                	ld	s3,88(sp)
  8002d4:	6a46                	ld	s4,80(sp)
  8002d6:	6aa6                	ld	s5,72(sp)
  8002d8:	6b06                	ld	s6,64(sp)
  8002da:	7be2                	ld	s7,56(sp)
  8002dc:	7c42                	ld	s8,48(sp)
  8002de:	7ca2                	ld	s9,40(sp)
  8002e0:	7d02                	ld	s10,32(sp)
  8002e2:	6de2                	ld	s11,24(sp)
  8002e4:	6109                	addi	sp,sp,128
  8002e6:	8082                	ret
            padc = '0';
  8002e8:	8836                	mv	a6,a3
            goto reswitch;
  8002ea:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  8002ee:	8466                	mv	s0,s9
  8002f0:	00140c93          	addi	s9,s0,1
  8002f4:	fdd6879b          	addiw	a5,a3,-35
  8002f8:	0ff7f793          	zext.b	a5,a5
  8002fc:	fcf672e3          	bgeu	a2,a5,8002c0 <vprintfmt+0x7c>
            putch('%', putdat);
  800300:	85a6                	mv	a1,s1
  800302:	02500513          	li	a0,37
  800306:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800308:	fff44783          	lbu	a5,-1(s0)
  80030c:	8ca2                	mv	s9,s0
  80030e:	f73788e3          	beq	a5,s3,80027e <vprintfmt+0x3a>
  800312:	ffecc783          	lbu	a5,-2(s9)
  800316:	1cfd                	addi	s9,s9,-1
  800318:	ff379de3          	bne	a5,s3,800312 <vprintfmt+0xce>
  80031c:	b78d                	j	80027e <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  80031e:	fd068c1b          	addiw	s8,a3,-48
                ch = *fmt;
  800322:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800326:	8466                	mv	s0,s9
                if (ch < '0' || ch > '9') {
  800328:	fd06879b          	addiw	a5,a3,-48
                ch = *fmt;
  80032c:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  800330:	02f5e563          	bltu	a1,a5,80035a <vprintfmt+0x116>
                ch = *fmt;
  800334:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
  800338:	002c179b          	slliw	a5,s8,0x2
  80033c:	0187873b          	addw	a4,a5,s8
  800340:	0017171b          	slliw	a4,a4,0x1
  800344:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
  800348:	fd06879b          	addiw	a5,a3,-48
            for (precision = 0; ; ++ fmt) {
  80034c:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  80034e:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  800352:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
  800356:	fcf5ffe3          	bgeu	a1,a5,800334 <vprintfmt+0xf0>
            if (width < 0)
  80035a:	f40d5be3          	bgez	s10,8002b0 <vprintfmt+0x6c>
                width = precision, precision = -1;
  80035e:	8d62                	mv	s10,s8
  800360:	5c7d                	li	s8,-1
  800362:	b7b9                	j	8002b0 <vprintfmt+0x6c>
            if (width < 0)
  800364:	fffd4793          	not	a5,s10
  800368:	97fd                	srai	a5,a5,0x3f
  80036a:	00fd7d33          	and	s10,s10,a5
        switch (ch = *(unsigned char *)fmt ++) {
  80036e:	00144683          	lbu	a3,1(s0)
  800372:	2d01                	sext.w	s10,s10
  800374:	8466                	mv	s0,s9
            goto reswitch;
  800376:	bf2d                	j	8002b0 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  800378:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  80037c:	00144683          	lbu	a3,1(s0)
            precision = va_arg(ap, int);
  800380:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  800382:	8466                	mv	s0,s9
            goto process_precision;
  800384:	bfd9                	j	80035a <vprintfmt+0x116>
    if (lflag >= 2) {
  800386:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800388:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  80038c:	00a7c463          	blt	a5,a0,800394 <vprintfmt+0x150>
    else if (lflag) {
  800390:	28050a63          	beqz	a0,800624 <vprintfmt+0x3e0>
        return va_arg(*ap, unsigned long);
  800394:	000a3783          	ld	a5,0(s4)
  800398:	4641                	li	a2,16
  80039a:	8a3a                	mv	s4,a4
  80039c:	46c1                	li	a3,16
    unsigned mod = do_div(result, base);
  80039e:	02c7fdb3          	remu	s11,a5,a2
            printnum(putch, putdat, num, base, width, padc);
  8003a2:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  8003a6:	0ac7f563          	bgeu	a5,a2,800450 <vprintfmt+0x20c>
        while (-- width > 0)
  8003aa:	3d7d                	addiw	s10,s10,-1
  8003ac:	01a05863          	blez	s10,8003bc <vprintfmt+0x178>
  8003b0:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  8003b2:	85a6                	mv	a1,s1
  8003b4:	8562                	mv	a0,s8
  8003b6:	9902                	jalr	s2
        while (-- width > 0)
  8003b8:	fe0d1ce3          	bnez	s10,8003b0 <vprintfmt+0x16c>
    putch("0123456789abcdef"[mod], putdat);
  8003bc:	9dda                	add	s11,s11,s6
  8003be:	000dc503          	lbu	a0,0(s11)
  8003c2:	85a6                	mv	a1,s1
  8003c4:	9902                	jalr	s2
}
  8003c6:	bd65                	j	80027e <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  8003c8:	000a2503          	lw	a0,0(s4)
  8003cc:	85a6                	mv	a1,s1
  8003ce:	0a21                	addi	s4,s4,8
  8003d0:	9902                	jalr	s2
            break;
  8003d2:	b575                	j	80027e <vprintfmt+0x3a>
    if (lflag >= 2) {
  8003d4:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8003d6:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  8003da:	00a7c463          	blt	a5,a0,8003e2 <vprintfmt+0x19e>
    else if (lflag) {
  8003de:	22050d63          	beqz	a0,800618 <vprintfmt+0x3d4>
        return va_arg(*ap, unsigned long);
  8003e2:	000a3783          	ld	a5,0(s4)
  8003e6:	4629                	li	a2,10
  8003e8:	8a3a                	mv	s4,a4
  8003ea:	46a9                	li	a3,10
  8003ec:	bf4d                	j	80039e <vprintfmt+0x15a>
        switch (ch = *(unsigned char *)fmt ++) {
  8003ee:	00144683          	lbu	a3,1(s0)
            altflag = 1;
  8003f2:	4d85                	li	s11,1
        switch (ch = *(unsigned char *)fmt ++) {
  8003f4:	8466                	mv	s0,s9
            goto reswitch;
  8003f6:	bd6d                	j	8002b0 <vprintfmt+0x6c>
            putch(ch, putdat);
  8003f8:	85a6                	mv	a1,s1
  8003fa:	02500513          	li	a0,37
  8003fe:	9902                	jalr	s2
            break;
  800400:	bdbd                	j	80027e <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  800402:	00144683          	lbu	a3,1(s0)
            lflag ++;
  800406:	2505                	addiw	a0,a0,1
        switch (ch = *(unsigned char *)fmt ++) {
  800408:	8466                	mv	s0,s9
            goto reswitch;
  80040a:	b55d                	j	8002b0 <vprintfmt+0x6c>
    if (lflag >= 2) {
  80040c:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80040e:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
  800412:	00a7c463          	blt	a5,a0,80041a <vprintfmt+0x1d6>
    else if (lflag) {
  800416:	1e050b63          	beqz	a0,80060c <vprintfmt+0x3c8>
        return va_arg(*ap, unsigned long);
  80041a:	000a3783          	ld	a5,0(s4)
  80041e:	4621                	li	a2,8
  800420:	8a3a                	mv	s4,a4
  800422:	46a1                	li	a3,8
  800424:	bfad                	j	80039e <vprintfmt+0x15a>
            putch('0', putdat);
  800426:	03000513          	li	a0,48
  80042a:	85a6                	mv	a1,s1
  80042c:	e042                	sd	a6,0(sp)
  80042e:	9902                	jalr	s2
            putch('x', putdat);
  800430:	85a6                	mv	a1,s1
  800432:	07800513          	li	a0,120
  800436:	9902                	jalr	s2
            goto number;
  800438:	6802                	ld	a6,0(sp)
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80043a:	000a3783          	ld	a5,0(s4)
            goto number;
  80043e:	4641                	li	a2,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800440:	0a21                	addi	s4,s4,8
    unsigned mod = do_div(result, base);
  800442:	02c7fdb3          	remu	s11,a5,a2
            goto number;
  800446:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
  800448:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
  80044c:	f4c7efe3          	bltu	a5,a2,8003aa <vprintfmt+0x166>
        while (-- width > 0)
  800450:	3d79                	addiw	s10,s10,-2
    unsigned mod = do_div(result, base);
  800452:	02c7d7b3          	divu	a5,a5,a2
  800456:	02c7f433          	remu	s0,a5,a2
    if (num >= base) {
  80045a:	10c7f463          	bgeu	a5,a2,800562 <vprintfmt+0x31e>
        while (-- width > 0)
  80045e:	01a05863          	blez	s10,80046e <vprintfmt+0x22a>
  800462:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
  800464:	85a6                	mv	a1,s1
  800466:	8562                	mv	a0,s8
  800468:	9902                	jalr	s2
        while (-- width > 0)
  80046a:	fe0d1ce3          	bnez	s10,800462 <vprintfmt+0x21e>
    putch("0123456789abcdef"[mod], putdat);
  80046e:	945a                	add	s0,s0,s6
  800470:	00044503          	lbu	a0,0(s0)
  800474:	85a6                	mv	a1,s1
  800476:	9dda                	add	s11,s11,s6
  800478:	9902                	jalr	s2
  80047a:	000dc503          	lbu	a0,0(s11)
  80047e:	85a6                	mv	a1,s1
  800480:	9902                	jalr	s2
  800482:	bbf5                	j	80027e <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
  800484:	000a3403          	ld	s0,0(s4)
  800488:	008a0793          	addi	a5,s4,8
  80048c:	e43e                	sd	a5,8(sp)
  80048e:	1e040563          	beqz	s0,800678 <vprintfmt+0x434>
            if (width > 0 && padc != '-') {
  800492:	15a05263          	blez	s10,8005d6 <vprintfmt+0x392>
  800496:	02d00793          	li	a5,45
  80049a:	10f81b63          	bne	a6,a5,8005b0 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80049e:	00044783          	lbu	a5,0(s0)
  8004a2:	0007851b          	sext.w	a0,a5
  8004a6:	0e078c63          	beqz	a5,80059e <vprintfmt+0x35a>
  8004aa:	0405                	addi	s0,s0,1
  8004ac:	120d8e63          	beqz	s11,8005e8 <vprintfmt+0x3a4>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004b0:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004b4:	020c4963          	bltz	s8,8004e6 <vprintfmt+0x2a2>
  8004b8:	fffc0a1b          	addiw	s4,s8,-1
  8004bc:	0d7a0f63          	beq	s4,s7,80059a <vprintfmt+0x356>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004c0:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  8004c2:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8004c4:	02fdf663          	bgeu	s11,a5,8004f0 <vprintfmt+0x2ac>
                    putch('?', putdat);
  8004c8:	03f00513          	li	a0,63
  8004cc:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004ce:	00044783          	lbu	a5,0(s0)
  8004d2:	3d7d                	addiw	s10,s10,-1
  8004d4:	0405                	addi	s0,s0,1
  8004d6:	0007851b          	sext.w	a0,a5
  8004da:	c3e1                	beqz	a5,80059a <vprintfmt+0x356>
  8004dc:	140c4a63          	bltz	s8,800630 <vprintfmt+0x3ec>
  8004e0:	8c52                	mv	s8,s4
  8004e2:	fc0c5be3          	bgez	s8,8004b8 <vprintfmt+0x274>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004e6:	3781                	addiw	a5,a5,-32
  8004e8:	8a62                	mv	s4,s8
                    putch('?', putdat);
  8004ea:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8004ec:	fcfdeee3          	bltu	s11,a5,8004c8 <vprintfmt+0x284>
                    putch(ch, putdat);
  8004f0:	9902                	jalr	s2
  8004f2:	bff1                	j	8004ce <vprintfmt+0x28a>
    if (lflag >= 2) {
  8004f4:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8004f6:	008a0d93          	addi	s11,s4,8
    if (lflag >= 2) {
  8004fa:	00a7c463          	blt	a5,a0,800502 <vprintfmt+0x2be>
    else if (lflag) {
  8004fe:	10050463          	beqz	a0,800606 <vprintfmt+0x3c2>
        return va_arg(*ap, long);
  800502:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  800506:	14044d63          	bltz	s0,800660 <vprintfmt+0x41c>
            num = getint(&ap, lflag);
  80050a:	87a2                	mv	a5,s0
  80050c:	8a6e                	mv	s4,s11
  80050e:	4629                	li	a2,10
  800510:	46a9                	li	a3,10
  800512:	b571                	j	80039e <vprintfmt+0x15a>
            err = va_arg(ap, int);
  800514:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800518:	4761                	li	a4,24
            err = va_arg(ap, int);
  80051a:	0a21                	addi	s4,s4,8
            if (err < 0) {
  80051c:	41f7d69b          	sraiw	a3,a5,0x1f
  800520:	8fb5                	xor	a5,a5,a3
  800522:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800526:	02d74563          	blt	a4,a3,800550 <vprintfmt+0x30c>
  80052a:	00369713          	slli	a4,a3,0x3
  80052e:	00000797          	auipc	a5,0x0
  800532:	51a78793          	addi	a5,a5,1306 # 800a48 <error_string>
  800536:	97ba                	add	a5,a5,a4
  800538:	639c                	ld	a5,0(a5)
  80053a:	cb99                	beqz	a5,800550 <vprintfmt+0x30c>
                printfmt(putch, putdat, "%s", p);
  80053c:	86be                	mv	a3,a5
  80053e:	00000617          	auipc	a2,0x0
  800542:	2ea60613          	addi	a2,a2,746 # 800828 <main+0x142>
  800546:	85a6                	mv	a1,s1
  800548:	854a                	mv	a0,s2
  80054a:	160000ef          	jal	ra,8006aa <printfmt>
  80054e:	bb05                	j	80027e <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  800550:	00000617          	auipc	a2,0x0
  800554:	2c860613          	addi	a2,a2,712 # 800818 <main+0x132>
  800558:	85a6                	mv	a1,s1
  80055a:	854a                	mv	a0,s2
  80055c:	14e000ef          	jal	ra,8006aa <printfmt>
  800560:	bb39                	j	80027e <vprintfmt+0x3a>
        printnum(putch, putdat, result, base, width - 1, padc);
  800562:	02c7d633          	divu	a2,a5,a2
  800566:	876a                	mv	a4,s10
  800568:	87e2                	mv	a5,s8
  80056a:	85a6                	mv	a1,s1
  80056c:	854a                	mv	a0,s2
  80056e:	befff0ef          	jal	ra,80015c <printnum>
  800572:	bdf5                	j	80046e <vprintfmt+0x22a>
                    putch(ch, putdat);
  800574:	85a6                	mv	a1,s1
  800576:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800578:	00044503          	lbu	a0,0(s0)
  80057c:	3d7d                	addiw	s10,s10,-1
  80057e:	0405                	addi	s0,s0,1
  800580:	cd09                	beqz	a0,80059a <vprintfmt+0x356>
  800582:	008d0d3b          	addw	s10,s10,s0
  800586:	fffd0d9b          	addiw	s11,s10,-1
                    putch(ch, putdat);
  80058a:	85a6                	mv	a1,s1
  80058c:	408d8d3b          	subw	s10,s11,s0
  800590:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800592:	00044503          	lbu	a0,0(s0)
  800596:	0405                	addi	s0,s0,1
  800598:	f96d                	bnez	a0,80058a <vprintfmt+0x346>
            for (; width > 0; width --) {
  80059a:	01a05963          	blez	s10,8005ac <vprintfmt+0x368>
  80059e:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
  8005a0:	85a6                	mv	a1,s1
  8005a2:	02000513          	li	a0,32
  8005a6:	9902                	jalr	s2
            for (; width > 0; width --) {
  8005a8:	fe0d1be3          	bnez	s10,80059e <vprintfmt+0x35a>
            if ((p = va_arg(ap, char *)) == NULL) {
  8005ac:	6a22                	ld	s4,8(sp)
  8005ae:	b9c1                	j	80027e <vprintfmt+0x3a>
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005b0:	85e2                	mv	a1,s8
  8005b2:	8522                	mv	a0,s0
  8005b4:	e042                	sd	a6,0(sp)
  8005b6:	114000ef          	jal	ra,8006ca <strnlen>
  8005ba:	40ad0d3b          	subw	s10,s10,a0
  8005be:	01a05c63          	blez	s10,8005d6 <vprintfmt+0x392>
                    putch(padc, putdat);
  8005c2:	6802                	ld	a6,0(sp)
  8005c4:	0008051b          	sext.w	a0,a6
  8005c8:	85a6                	mv	a1,s1
  8005ca:	e02a                	sd	a0,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005cc:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
  8005ce:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  8005d0:	6502                	ld	a0,0(sp)
  8005d2:	fe0d1be3          	bnez	s10,8005c8 <vprintfmt+0x384>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005d6:	00044783          	lbu	a5,0(s0)
  8005da:	0405                	addi	s0,s0,1
  8005dc:	0007851b          	sext.w	a0,a5
  8005e0:	ec0796e3          	bnez	a5,8004ac <vprintfmt+0x268>
            if ((p = va_arg(ap, char *)) == NULL) {
  8005e4:	6a22                	ld	s4,8(sp)
  8005e6:	b961                	j	80027e <vprintfmt+0x3a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005e8:	f80c46e3          	bltz	s8,800574 <vprintfmt+0x330>
  8005ec:	3c7d                	addiw	s8,s8,-1
  8005ee:	fb7c06e3          	beq	s8,s7,80059a <vprintfmt+0x356>
                    putch(ch, putdat);
  8005f2:	85a6                	mv	a1,s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005f4:	0405                	addi	s0,s0,1
                    putch(ch, putdat);
  8005f6:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8005f8:	fff44503          	lbu	a0,-1(s0)
  8005fc:	3d7d                	addiw	s10,s10,-1
  8005fe:	f56d                	bnez	a0,8005e8 <vprintfmt+0x3a4>
            for (; width > 0; width --) {
  800600:	f9a04fe3          	bgtz	s10,80059e <vprintfmt+0x35a>
  800604:	b765                	j	8005ac <vprintfmt+0x368>
        return va_arg(*ap, int);
  800606:	000a2403          	lw	s0,0(s4)
  80060a:	bdf5                	j	800506 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned int);
  80060c:	000a6783          	lwu	a5,0(s4)
  800610:	4621                	li	a2,8
  800612:	8a3a                	mv	s4,a4
  800614:	46a1                	li	a3,8
  800616:	b361                	j	80039e <vprintfmt+0x15a>
  800618:	000a6783          	lwu	a5,0(s4)
  80061c:	4629                	li	a2,10
  80061e:	8a3a                	mv	s4,a4
  800620:	46a9                	li	a3,10
  800622:	bbb5                	j	80039e <vprintfmt+0x15a>
  800624:	000a6783          	lwu	a5,0(s4)
  800628:	4641                	li	a2,16
  80062a:	8a3a                	mv	s4,a4
  80062c:	46c1                	li	a3,16
  80062e:	bb85                	j	80039e <vprintfmt+0x15a>
  800630:	01a40d3b          	addw	s10,s0,s10
                if (altflag && (ch < ' ' || ch > '~')) {
  800634:	05e00d93          	li	s11,94
  800638:	3d7d                	addiw	s10,s10,-1
  80063a:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
  80063c:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  80063e:	00fdf463          	bgeu	s11,a5,800646 <vprintfmt+0x402>
                    putch('?', putdat);
  800642:	03f00513          	li	a0,63
  800646:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800648:	00044783          	lbu	a5,0(s0)
  80064c:	408d073b          	subw	a4,s10,s0
  800650:	0405                	addi	s0,s0,1
  800652:	0007851b          	sext.w	a0,a5
  800656:	f3f5                	bnez	a5,80063a <vprintfmt+0x3f6>
  800658:	8d3a                	mv	s10,a4
            for (; width > 0; width --) {
  80065a:	f5a042e3          	bgtz	s10,80059e <vprintfmt+0x35a>
  80065e:	b7b9                	j	8005ac <vprintfmt+0x368>
                putch('-', putdat);
  800660:	85a6                	mv	a1,s1
  800662:	02d00513          	li	a0,45
  800666:	e042                	sd	a6,0(sp)
  800668:	9902                	jalr	s2
                num = -(long long)num;
  80066a:	6802                	ld	a6,0(sp)
  80066c:	8a6e                	mv	s4,s11
  80066e:	408007b3          	neg	a5,s0
  800672:	4629                	li	a2,10
  800674:	46a9                	li	a3,10
  800676:	b325                	j	80039e <vprintfmt+0x15a>
            if (width > 0 && padc != '-') {
  800678:	03a05063          	blez	s10,800698 <vprintfmt+0x454>
  80067c:	02d00793          	li	a5,45
                p = "(null)";
  800680:	00000417          	auipc	s0,0x0
  800684:	19040413          	addi	s0,s0,400 # 800810 <main+0x12a>
            if (width > 0 && padc != '-') {
  800688:	f2f814e3          	bne	a6,a5,8005b0 <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80068c:	02800793          	li	a5,40
  800690:	02800513          	li	a0,40
  800694:	0405                	addi	s0,s0,1
  800696:	bd19                	j	8004ac <vprintfmt+0x268>
  800698:	02800513          	li	a0,40
  80069c:	02800793          	li	a5,40
  8006a0:	00000417          	auipc	s0,0x0
  8006a4:	17140413          	addi	s0,s0,369 # 800811 <main+0x12b>
  8006a8:	b511                	j	8004ac <vprintfmt+0x268>

00000000008006aa <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006aa:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  8006ac:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006b0:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8006b2:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8006b4:	ec06                	sd	ra,24(sp)
  8006b6:	f83a                	sd	a4,48(sp)
  8006b8:	fc3e                	sd	a5,56(sp)
  8006ba:	e0c2                	sd	a6,64(sp)
  8006bc:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8006be:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8006c0:	b85ff0ef          	jal	ra,800244 <vprintfmt>
}
  8006c4:	60e2                	ld	ra,24(sp)
  8006c6:	6161                	addi	sp,sp,80
  8006c8:	8082                	ret

00000000008006ca <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  8006ca:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  8006cc:	e589                	bnez	a1,8006d6 <strnlen+0xc>
  8006ce:	a811                	j	8006e2 <strnlen+0x18>
        cnt ++;
  8006d0:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  8006d2:	00f58863          	beq	a1,a5,8006e2 <strnlen+0x18>
  8006d6:	00f50733          	add	a4,a0,a5
  8006da:	00074703          	lbu	a4,0(a4)
  8006de:	fb6d                	bnez	a4,8006d0 <strnlen+0x6>
  8006e0:	85be                	mv	a1,a5
    }
    return cnt;
}
  8006e2:	852e                	mv	a0,a1
  8006e4:	8082                	ret

00000000008006e6 <main>:
#include <stdio.h>
#include <ulib.h>

int
main(void) {
  8006e6:	1141                	addi	sp,sp,-16
    int pid, ret;
    cprintf("I am the parent. Forking the child...\n");
  8006e8:	00000517          	auipc	a0,0x0
  8006ec:	42850513          	addi	a0,a0,1064 # 800b10 <error_string+0xc8>
main(void) {
  8006f0:	e406                	sd	ra,8(sp)
  8006f2:	e022                	sd	s0,0(sp)
    cprintf("I am the parent. Forking the child...\n");
  8006f4:	9afff0ef          	jal	ra,8000a2 <cprintf>
    if ((pid = fork()) == 0) {
  8006f8:	a51ff0ef          	jal	ra,800148 <fork>
  8006fc:	e901                	bnez	a0,80070c <main+0x26>
        cprintf("I am the child. spinning ...\n");
  8006fe:	00000517          	auipc	a0,0x0
  800702:	43a50513          	addi	a0,a0,1082 # 800b38 <error_string+0xf0>
  800706:	99dff0ef          	jal	ra,8000a2 <cprintf>
        while (1);
  80070a:	a001                	j	80070a <main+0x24>
    }
    cprintf("I am the parent. Running the child...\n");
  80070c:	842a                	mv	s0,a0
  80070e:	00000517          	auipc	a0,0x0
  800712:	44a50513          	addi	a0,a0,1098 # 800b58 <error_string+0x110>
  800716:	98dff0ef          	jal	ra,8000a2 <cprintf>

    yield();
  80071a:	a33ff0ef          	jal	ra,80014c <yield>
    yield();
  80071e:	a2fff0ef          	jal	ra,80014c <yield>
    yield();
  800722:	a2bff0ef          	jal	ra,80014c <yield>

    cprintf("I am the parent.  Killing the child...\n");
  800726:	00000517          	auipc	a0,0x0
  80072a:	45a50513          	addi	a0,a0,1114 # 800b80 <error_string+0x138>
  80072e:	975ff0ef          	jal	ra,8000a2 <cprintf>

    assert((ret = kill(pid)) == 0);
  800732:	8522                	mv	a0,s0
  800734:	a1bff0ef          	jal	ra,80014e <kill>
  800738:	ed31                	bnez	a0,800794 <main+0xae>
    cprintf("kill returns %d\n", ret);
  80073a:	4581                	li	a1,0
  80073c:	00000517          	auipc	a0,0x0
  800740:	4ac50513          	addi	a0,a0,1196 # 800be8 <error_string+0x1a0>
  800744:	95fff0ef          	jal	ra,8000a2 <cprintf>

    assert((ret = waitpid(pid, NULL)) == 0);
  800748:	4581                	li	a1,0
  80074a:	8522                	mv	a0,s0
  80074c:	9ffff0ef          	jal	ra,80014a <waitpid>
  800750:	e11d                	bnez	a0,800776 <main+0x90>
    cprintf("wait returns %d\n", ret);
  800752:	4581                	li	a1,0
  800754:	00000517          	auipc	a0,0x0
  800758:	4cc50513          	addi	a0,a0,1228 # 800c20 <error_string+0x1d8>
  80075c:	947ff0ef          	jal	ra,8000a2 <cprintf>

    cprintf("spin may pass.\n");
  800760:	00000517          	auipc	a0,0x0
  800764:	4d850513          	addi	a0,a0,1240 # 800c38 <error_string+0x1f0>
  800768:	93bff0ef          	jal	ra,8000a2 <cprintf>
    return 0;
}
  80076c:	60a2                	ld	ra,8(sp)
  80076e:	6402                	ld	s0,0(sp)
  800770:	4501                	li	a0,0
  800772:	0141                	addi	sp,sp,16
  800774:	8082                	ret
    assert((ret = waitpid(pid, NULL)) == 0);
  800776:	00000697          	auipc	a3,0x0
  80077a:	48a68693          	addi	a3,a3,1162 # 800c00 <error_string+0x1b8>
  80077e:	00000617          	auipc	a2,0x0
  800782:	44260613          	addi	a2,a2,1090 # 800bc0 <error_string+0x178>
  800786:	45dd                	li	a1,23
  800788:	00000517          	auipc	a0,0x0
  80078c:	45050513          	addi	a0,a0,1104 # 800bd8 <error_string+0x190>
  800790:	897ff0ef          	jal	ra,800026 <__panic>
    assert((ret = kill(pid)) == 0);
  800794:	00000697          	auipc	a3,0x0
  800798:	41468693          	addi	a3,a3,1044 # 800ba8 <error_string+0x160>
  80079c:	00000617          	auipc	a2,0x0
  8007a0:	42460613          	addi	a2,a2,1060 # 800bc0 <error_string+0x178>
  8007a4:	45d1                	li	a1,20
  8007a6:	00000517          	auipc	a0,0x0
  8007aa:	43250513          	addi	a0,a0,1074 # 800bd8 <error_string+0x190>
  8007ae:	879ff0ef          	jal	ra,800026 <__panic>
