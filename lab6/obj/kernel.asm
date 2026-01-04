
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000c297          	auipc	t0,0xc
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020c000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000c297          	auipc	t0,0xc
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020c008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020b2b7          	lui	t0,0xc020b
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc0200034:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200038:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc020003c:	c020b137          	lui	sp,0xc020b

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
void grade_backtrace(void);

int kern_init(void)
{
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc020004a:	00142517          	auipc	a0,0x142
ffffffffc020004e:	d2650513          	addi	a0,a0,-730 # ffffffffc0341d70 <buf>
ffffffffc0200052:	00146617          	auipc	a2,0x146
ffffffffc0200056:	1fe60613          	addi	a2,a2,510 # ffffffffc0346250 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	24a060ef          	jal	ra,ffffffffc02062ac <memset>
    cons_init(); // init the console
ffffffffc0200066:	506000ef          	jal	ra,ffffffffc020056c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006a:	00006597          	auipc	a1,0x6
ffffffffc020006e:	49658593          	addi	a1,a1,1174 # ffffffffc0206500 <etext>
ffffffffc0200072:	00006517          	auipc	a0,0x6
ffffffffc0200076:	4ae50513          	addi	a0,a0,1198 # ffffffffc0206520 <etext+0x20>
ffffffffc020007a:	11e000ef          	jal	ra,ffffffffc0200198 <cprintf>

    print_kerninfo();
ffffffffc020007e:	1a2000ef          	jal	ra,ffffffffc0200220 <print_kerninfo>

    // grade_backtrace();

    dtb_init(); // init dtb
ffffffffc0200082:	55c000ef          	jal	ra,ffffffffc02005de <dtb_init>

    pmm_init(); // init physical memory management
ffffffffc0200086:	24b020ef          	jal	ra,ffffffffc0202ad0 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	115000ef          	jal	ra,ffffffffc020099e <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	113000ef          	jal	ra,ffffffffc02009a0 <idt_init>

    vmm_init(); // init virtual memory management
ffffffffc0200092:	5ff030ef          	jal	ra,ffffffffc0203e90 <vmm_init>
    sched_init();
ffffffffc0200096:	123050ef          	jal	ra,ffffffffc02059b8 <sched_init>
    proc_init(); // init process table
ffffffffc020009a:	58c050ef          	jal	ra,ffffffffc0205626 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009e:	486000ef          	jal	ra,ffffffffc0200524 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc02000a2:	0f1000ef          	jal	ra,ffffffffc0200992 <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a6:	718050ef          	jal	ra,ffffffffc02057be <cpu_idle>

ffffffffc02000aa <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000aa:	715d                	addi	sp,sp,-80
ffffffffc02000ac:	e486                	sd	ra,72(sp)
ffffffffc02000ae:	e0a6                	sd	s1,64(sp)
ffffffffc02000b0:	fc4a                	sd	s2,56(sp)
ffffffffc02000b2:	f84e                	sd	s3,48(sp)
ffffffffc02000b4:	f452                	sd	s4,40(sp)
ffffffffc02000b6:	f056                	sd	s5,32(sp)
ffffffffc02000b8:	ec5a                	sd	s6,24(sp)
ffffffffc02000ba:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000bc:	c901                	beqz	a0,ffffffffc02000cc <readline+0x22>
ffffffffc02000be:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000c0:	00006517          	auipc	a0,0x6
ffffffffc02000c4:	46850513          	addi	a0,a0,1128 # ffffffffc0206528 <etext+0x28>
ffffffffc02000c8:	0d0000ef          	jal	ra,ffffffffc0200198 <cprintf>
readline(const char *prompt) {
ffffffffc02000cc:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ce:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000d0:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000d2:	4aa9                	li	s5,10
ffffffffc02000d4:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000d6:	00142b97          	auipc	s7,0x142
ffffffffc02000da:	c9ab8b93          	addi	s7,s7,-870 # ffffffffc0341d70 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000de:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000e2:	12e000ef          	jal	ra,ffffffffc0200210 <getchar>
        if (c < 0) {
ffffffffc02000e6:	00054a63          	bltz	a0,ffffffffc02000fa <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ea:	00a95a63          	bge	s2,a0,ffffffffc02000fe <readline+0x54>
ffffffffc02000ee:	029a5263          	bge	s4,s1,ffffffffc0200112 <readline+0x68>
        c = getchar();
ffffffffc02000f2:	11e000ef          	jal	ra,ffffffffc0200210 <getchar>
        if (c < 0) {
ffffffffc02000f6:	fe055ae3          	bgez	a0,ffffffffc02000ea <readline+0x40>
            return NULL;
ffffffffc02000fa:	4501                	li	a0,0
ffffffffc02000fc:	a091                	j	ffffffffc0200140 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fe:	03351463          	bne	a0,s3,ffffffffc0200126 <readline+0x7c>
ffffffffc0200102:	e8a9                	bnez	s1,ffffffffc0200154 <readline+0xaa>
        c = getchar();
ffffffffc0200104:	10c000ef          	jal	ra,ffffffffc0200210 <getchar>
        if (c < 0) {
ffffffffc0200108:	fe0549e3          	bltz	a0,ffffffffc02000fa <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020010c:	fea959e3          	bge	s2,a0,ffffffffc02000fe <readline+0x54>
ffffffffc0200110:	4481                	li	s1,0
            cputchar(c);
ffffffffc0200112:	e42a                	sd	a0,8(sp)
ffffffffc0200114:	0ba000ef          	jal	ra,ffffffffc02001ce <cputchar>
            buf[i ++] = c;
ffffffffc0200118:	6522                	ld	a0,8(sp)
ffffffffc020011a:	009b87b3          	add	a5,s7,s1
ffffffffc020011e:	2485                	addiw	s1,s1,1
ffffffffc0200120:	00a78023          	sb	a0,0(a5)
ffffffffc0200124:	bf7d                	j	ffffffffc02000e2 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0200126:	01550463          	beq	a0,s5,ffffffffc020012e <readline+0x84>
ffffffffc020012a:	fb651ce3          	bne	a0,s6,ffffffffc02000e2 <readline+0x38>
            cputchar(c);
ffffffffc020012e:	0a0000ef          	jal	ra,ffffffffc02001ce <cputchar>
            buf[i] = '\0';
ffffffffc0200132:	00142517          	auipc	a0,0x142
ffffffffc0200136:	c3e50513          	addi	a0,a0,-962 # ffffffffc0341d70 <buf>
ffffffffc020013a:	94aa                	add	s1,s1,a0
ffffffffc020013c:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0200140:	60a6                	ld	ra,72(sp)
ffffffffc0200142:	6486                	ld	s1,64(sp)
ffffffffc0200144:	7962                	ld	s2,56(sp)
ffffffffc0200146:	79c2                	ld	s3,48(sp)
ffffffffc0200148:	7a22                	ld	s4,40(sp)
ffffffffc020014a:	7a82                	ld	s5,32(sp)
ffffffffc020014c:	6b62                	ld	s6,24(sp)
ffffffffc020014e:	6bc2                	ld	s7,16(sp)
ffffffffc0200150:	6161                	addi	sp,sp,80
ffffffffc0200152:	8082                	ret
            cputchar(c);
ffffffffc0200154:	4521                	li	a0,8
ffffffffc0200156:	078000ef          	jal	ra,ffffffffc02001ce <cputchar>
            i --;
ffffffffc020015a:	34fd                	addiw	s1,s1,-1
ffffffffc020015c:	b759                	j	ffffffffc02000e2 <readline+0x38>

ffffffffc020015e <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015e:	1141                	addi	sp,sp,-16
ffffffffc0200160:	e022                	sd	s0,0(sp)
ffffffffc0200162:	e406                	sd	ra,8(sp)
ffffffffc0200164:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200166:	408000ef          	jal	ra,ffffffffc020056e <cons_putc>
    (*cnt)++;
ffffffffc020016a:	401c                	lw	a5,0(s0)
}
ffffffffc020016c:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc020016e:	2785                	addiw	a5,a5,1
ffffffffc0200170:	c01c                	sw	a5,0(s0)
}
ffffffffc0200172:	6402                	ld	s0,0(sp)
ffffffffc0200174:	0141                	addi	sp,sp,16
ffffffffc0200176:	8082                	ret

ffffffffc0200178 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200178:	1101                	addi	sp,sp,-32
ffffffffc020017a:	862a                	mv	a2,a0
ffffffffc020017c:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017e:	00000517          	auipc	a0,0x0
ffffffffc0200182:	fe050513          	addi	a0,a0,-32 # ffffffffc020015e <cputch>
ffffffffc0200186:	006c                	addi	a1,sp,12
{
ffffffffc0200188:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020018a:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020018c:	3f5050ef          	jal	ra,ffffffffc0205d80 <vprintfmt>
    return cnt;
}
ffffffffc0200190:	60e2                	ld	ra,24(sp)
ffffffffc0200192:	4532                	lw	a0,12(sp)
ffffffffc0200194:	6105                	addi	sp,sp,32
ffffffffc0200196:	8082                	ret

ffffffffc0200198 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200198:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020019a:	02810313          	addi	t1,sp,40 # ffffffffc020b028 <boot_page_table_sv39+0x28>
{
ffffffffc020019e:	8e2a                	mv	t3,a0
ffffffffc02001a0:	f42e                	sd	a1,40(sp)
ffffffffc02001a2:	f832                	sd	a2,48(sp)
ffffffffc02001a4:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a6:	00000517          	auipc	a0,0x0
ffffffffc02001aa:	fb850513          	addi	a0,a0,-72 # ffffffffc020015e <cputch>
ffffffffc02001ae:	004c                	addi	a1,sp,4
ffffffffc02001b0:	869a                	mv	a3,t1
ffffffffc02001b2:	8672                	mv	a2,t3
{
ffffffffc02001b4:	ec06                	sd	ra,24(sp)
ffffffffc02001b6:	e0ba                	sd	a4,64(sp)
ffffffffc02001b8:	e4be                	sd	a5,72(sp)
ffffffffc02001ba:	e8c2                	sd	a6,80(sp)
ffffffffc02001bc:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001be:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001c0:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001c2:	3bf050ef          	jal	ra,ffffffffc0205d80 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c6:	60e2                	ld	ra,24(sp)
ffffffffc02001c8:	4512                	lw	a0,4(sp)
ffffffffc02001ca:	6125                	addi	sp,sp,96
ffffffffc02001cc:	8082                	ret

ffffffffc02001ce <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001ce:	a645                	j	ffffffffc020056e <cons_putc>

ffffffffc02001d0 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001d0:	1101                	addi	sp,sp,-32
ffffffffc02001d2:	e822                	sd	s0,16(sp)
ffffffffc02001d4:	ec06                	sd	ra,24(sp)
ffffffffc02001d6:	e426                	sd	s1,8(sp)
ffffffffc02001d8:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001da:	00054503          	lbu	a0,0(a0)
ffffffffc02001de:	c51d                	beqz	a0,ffffffffc020020c <cputs+0x3c>
ffffffffc02001e0:	0405                	addi	s0,s0,1
ffffffffc02001e2:	4485                	li	s1,1
ffffffffc02001e4:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc02001e6:	388000ef          	jal	ra,ffffffffc020056e <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001ea:	00044503          	lbu	a0,0(s0)
ffffffffc02001ee:	008487bb          	addw	a5,s1,s0
ffffffffc02001f2:	0405                	addi	s0,s0,1
ffffffffc02001f4:	f96d                	bnez	a0,ffffffffc02001e6 <cputs+0x16>
    (*cnt)++;
ffffffffc02001f6:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001fa:	4529                	li	a0,10
ffffffffc02001fc:	372000ef          	jal	ra,ffffffffc020056e <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc0200200:	60e2                	ld	ra,24(sp)
ffffffffc0200202:	8522                	mv	a0,s0
ffffffffc0200204:	6442                	ld	s0,16(sp)
ffffffffc0200206:	64a2                	ld	s1,8(sp)
ffffffffc0200208:	6105                	addi	sp,sp,32
ffffffffc020020a:	8082                	ret
    while ((c = *str++) != '\0')
ffffffffc020020c:	4405                	li	s0,1
ffffffffc020020e:	b7f5                	j	ffffffffc02001fa <cputs+0x2a>

ffffffffc0200210 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc0200210:	1141                	addi	sp,sp,-16
ffffffffc0200212:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200214:	38e000ef          	jal	ra,ffffffffc02005a2 <cons_getc>
ffffffffc0200218:	dd75                	beqz	a0,ffffffffc0200214 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc020021a:	60a2                	ld	ra,8(sp)
ffffffffc020021c:	0141                	addi	sp,sp,16
ffffffffc020021e:	8082                	ret

ffffffffc0200220 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200220:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200222:	00006517          	auipc	a0,0x6
ffffffffc0200226:	30e50513          	addi	a0,a0,782 # ffffffffc0206530 <etext+0x30>
void print_kerninfo(void) {
ffffffffc020022a:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc020022c:	f6dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200230:	00000597          	auipc	a1,0x0
ffffffffc0200234:	e1a58593          	addi	a1,a1,-486 # ffffffffc020004a <kern_init>
ffffffffc0200238:	00006517          	auipc	a0,0x6
ffffffffc020023c:	31850513          	addi	a0,a0,792 # ffffffffc0206550 <etext+0x50>
ffffffffc0200240:	f59ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200244:	00006597          	auipc	a1,0x6
ffffffffc0200248:	2bc58593          	addi	a1,a1,700 # ffffffffc0206500 <etext>
ffffffffc020024c:	00006517          	auipc	a0,0x6
ffffffffc0200250:	32450513          	addi	a0,a0,804 # ffffffffc0206570 <etext+0x70>
ffffffffc0200254:	f45ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200258:	00142597          	auipc	a1,0x142
ffffffffc020025c:	b1858593          	addi	a1,a1,-1256 # ffffffffc0341d70 <buf>
ffffffffc0200260:	00006517          	auipc	a0,0x6
ffffffffc0200264:	33050513          	addi	a0,a0,816 # ffffffffc0206590 <etext+0x90>
ffffffffc0200268:	f31ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc020026c:	00146597          	auipc	a1,0x146
ffffffffc0200270:	fe458593          	addi	a1,a1,-28 # ffffffffc0346250 <end>
ffffffffc0200274:	00006517          	auipc	a0,0x6
ffffffffc0200278:	33c50513          	addi	a0,a0,828 # ffffffffc02065b0 <etext+0xb0>
ffffffffc020027c:	f1dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200280:	00146597          	auipc	a1,0x146
ffffffffc0200284:	3cf58593          	addi	a1,a1,975 # ffffffffc034664f <end+0x3ff>
ffffffffc0200288:	00000797          	auipc	a5,0x0
ffffffffc020028c:	dc278793          	addi	a5,a5,-574 # ffffffffc020004a <kern_init>
ffffffffc0200290:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200294:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200298:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020029a:	3ff5f593          	andi	a1,a1,1023
ffffffffc020029e:	95be                	add	a1,a1,a5
ffffffffc02002a0:	85a9                	srai	a1,a1,0xa
ffffffffc02002a2:	00006517          	auipc	a0,0x6
ffffffffc02002a6:	32e50513          	addi	a0,a0,814 # ffffffffc02065d0 <etext+0xd0>
}
ffffffffc02002aa:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002ac:	b5f5                	j	ffffffffc0200198 <cprintf>

ffffffffc02002ae <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02002ae:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002b0:	00006617          	auipc	a2,0x6
ffffffffc02002b4:	35060613          	addi	a2,a2,848 # ffffffffc0206600 <etext+0x100>
ffffffffc02002b8:	04d00593          	li	a1,77
ffffffffc02002bc:	00006517          	auipc	a0,0x6
ffffffffc02002c0:	35c50513          	addi	a0,a0,860 # ffffffffc0206618 <etext+0x118>
void print_stackframe(void) {
ffffffffc02002c4:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002c6:	1b2000ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc02002ca <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002ca:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002cc:	00006617          	auipc	a2,0x6
ffffffffc02002d0:	36460613          	addi	a2,a2,868 # ffffffffc0206630 <etext+0x130>
ffffffffc02002d4:	00006597          	auipc	a1,0x6
ffffffffc02002d8:	37c58593          	addi	a1,a1,892 # ffffffffc0206650 <etext+0x150>
ffffffffc02002dc:	00006517          	auipc	a0,0x6
ffffffffc02002e0:	37c50513          	addi	a0,a0,892 # ffffffffc0206658 <etext+0x158>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002e4:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e6:	eb3ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc02002ea:	00006617          	auipc	a2,0x6
ffffffffc02002ee:	37e60613          	addi	a2,a2,894 # ffffffffc0206668 <etext+0x168>
ffffffffc02002f2:	00006597          	auipc	a1,0x6
ffffffffc02002f6:	39e58593          	addi	a1,a1,926 # ffffffffc0206690 <etext+0x190>
ffffffffc02002fa:	00006517          	auipc	a0,0x6
ffffffffc02002fe:	35e50513          	addi	a0,a0,862 # ffffffffc0206658 <etext+0x158>
ffffffffc0200302:	e97ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc0200306:	00006617          	auipc	a2,0x6
ffffffffc020030a:	39a60613          	addi	a2,a2,922 # ffffffffc02066a0 <etext+0x1a0>
ffffffffc020030e:	00006597          	auipc	a1,0x6
ffffffffc0200312:	3b258593          	addi	a1,a1,946 # ffffffffc02066c0 <etext+0x1c0>
ffffffffc0200316:	00006517          	auipc	a0,0x6
ffffffffc020031a:	34250513          	addi	a0,a0,834 # ffffffffc0206658 <etext+0x158>
ffffffffc020031e:	e7bff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    }
    return 0;
}
ffffffffc0200322:	60a2                	ld	ra,8(sp)
ffffffffc0200324:	4501                	li	a0,0
ffffffffc0200326:	0141                	addi	sp,sp,16
ffffffffc0200328:	8082                	ret

ffffffffc020032a <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc020032a:	1141                	addi	sp,sp,-16
ffffffffc020032c:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020032e:	ef3ff0ef          	jal	ra,ffffffffc0200220 <print_kerninfo>
    return 0;
}
ffffffffc0200332:	60a2                	ld	ra,8(sp)
ffffffffc0200334:	4501                	li	a0,0
ffffffffc0200336:	0141                	addi	sp,sp,16
ffffffffc0200338:	8082                	ret

ffffffffc020033a <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc020033a:	1141                	addi	sp,sp,-16
ffffffffc020033c:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020033e:	f71ff0ef          	jal	ra,ffffffffc02002ae <print_stackframe>
    return 0;
}
ffffffffc0200342:	60a2                	ld	ra,8(sp)
ffffffffc0200344:	4501                	li	a0,0
ffffffffc0200346:	0141                	addi	sp,sp,16
ffffffffc0200348:	8082                	ret

ffffffffc020034a <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc020034a:	7115                	addi	sp,sp,-224
ffffffffc020034c:	ed5e                	sd	s7,152(sp)
ffffffffc020034e:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200350:	00006517          	auipc	a0,0x6
ffffffffc0200354:	38050513          	addi	a0,a0,896 # ffffffffc02066d0 <etext+0x1d0>
kmonitor(struct trapframe *tf) {
ffffffffc0200358:	ed86                	sd	ra,216(sp)
ffffffffc020035a:	e9a2                	sd	s0,208(sp)
ffffffffc020035c:	e5a6                	sd	s1,200(sp)
ffffffffc020035e:	e1ca                	sd	s2,192(sp)
ffffffffc0200360:	fd4e                	sd	s3,184(sp)
ffffffffc0200362:	f952                	sd	s4,176(sp)
ffffffffc0200364:	f556                	sd	s5,168(sp)
ffffffffc0200366:	f15a                	sd	s6,160(sp)
ffffffffc0200368:	e962                	sd	s8,144(sp)
ffffffffc020036a:	e566                	sd	s9,136(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020036c:	e2dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200370:	00006517          	auipc	a0,0x6
ffffffffc0200374:	38850513          	addi	a0,a0,904 # ffffffffc02066f8 <etext+0x1f8>
ffffffffc0200378:	e21ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    if (tf != NULL) {
ffffffffc020037c:	000b8563          	beqz	s7,ffffffffc0200386 <kmonitor+0x3c>
        print_trapframe(tf);
ffffffffc0200380:	855e                	mv	a0,s7
ffffffffc0200382:	007000ef          	jal	ra,ffffffffc0200b88 <print_trapframe>
ffffffffc0200386:	00006c17          	auipc	s8,0x6
ffffffffc020038a:	3e2c0c13          	addi	s8,s8,994 # ffffffffc0206768 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020038e:	00006997          	auipc	s3,0x6
ffffffffc0200392:	39298993          	addi	s3,s3,914 # ffffffffc0206720 <etext+0x220>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200396:	00006497          	auipc	s1,0x6
ffffffffc020039a:	39248493          	addi	s1,s1,914 # ffffffffc0206728 <etext+0x228>
        if (argc == MAXARGS - 1) {
ffffffffc020039e:	4a3d                	li	s4,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003a0:	00006b17          	auipc	s6,0x6
ffffffffc02003a4:	390b0b13          	addi	s6,s6,912 # ffffffffc0206730 <etext+0x230>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003a8:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02003aa:	854e                	mv	a0,s3
ffffffffc02003ac:	cffff0ef          	jal	ra,ffffffffc02000aa <readline>
ffffffffc02003b0:	842a                	mv	s0,a0
ffffffffc02003b2:	dd65                	beqz	a0,ffffffffc02003aa <kmonitor+0x60>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003b4:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003b8:	4901                	li	s2,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003ba:	e98d                	bnez	a1,ffffffffc02003ec <kmonitor+0xa2>
    if (argc == 0) {
ffffffffc02003bc:	fe0907e3          	beqz	s2,ffffffffc02003aa <kmonitor+0x60>
ffffffffc02003c0:	00006417          	auipc	s0,0x6
ffffffffc02003c4:	3a840413          	addi	s0,s0,936 # ffffffffc0206768 <commands>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003c8:	4c81                	li	s9,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003ca:	6008                	ld	a0,0(s0)
ffffffffc02003cc:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003ce:	0461                	addi	s0,s0,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003d0:	67f050ef          	jal	ra,ffffffffc020624e <strcmp>
ffffffffc02003d4:	c925                	beqz	a0,ffffffffc0200444 <kmonitor+0xfa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003d6:	2c85                	addiw	s9,s9,1
ffffffffc02003d8:	ff5c99e3          	bne	s9,s5,ffffffffc02003ca <kmonitor+0x80>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003dc:	6582                	ld	a1,0(sp)
ffffffffc02003de:	00006517          	auipc	a0,0x6
ffffffffc02003e2:	37250513          	addi	a0,a0,882 # ffffffffc0206750 <etext+0x250>
ffffffffc02003e6:	db3ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    return 0;
ffffffffc02003ea:	b7c1                	j	ffffffffc02003aa <kmonitor+0x60>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003ec:	8526                	mv	a0,s1
ffffffffc02003ee:	6a9050ef          	jal	ra,ffffffffc0206296 <strchr>
ffffffffc02003f2:	c901                	beqz	a0,ffffffffc0200402 <kmonitor+0xb8>
ffffffffc02003f4:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc02003f8:	00040023          	sb	zero,0(s0)
ffffffffc02003fc:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003fe:	dddd                	beqz	a1,ffffffffc02003bc <kmonitor+0x72>
ffffffffc0200400:	b7f5                	j	ffffffffc02003ec <kmonitor+0xa2>
        if (*buf == '\0') {
ffffffffc0200402:	00044783          	lbu	a5,0(s0)
ffffffffc0200406:	dbdd                	beqz	a5,ffffffffc02003bc <kmonitor+0x72>
        if (argc == MAXARGS - 1) {
ffffffffc0200408:	03490963          	beq	s2,s4,ffffffffc020043a <kmonitor+0xf0>
        argv[argc ++] = buf;
ffffffffc020040c:	00391793          	slli	a5,s2,0x3
ffffffffc0200410:	0118                	addi	a4,sp,128
ffffffffc0200412:	97ba                	add	a5,a5,a4
ffffffffc0200414:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200418:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc020041c:	2905                	addiw	s2,s2,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020041e:	e591                	bnez	a1,ffffffffc020042a <kmonitor+0xe0>
ffffffffc0200420:	b745                	j	ffffffffc02003c0 <kmonitor+0x76>
ffffffffc0200422:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc0200426:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200428:	d9d1                	beqz	a1,ffffffffc02003bc <kmonitor+0x72>
ffffffffc020042a:	8526                	mv	a0,s1
ffffffffc020042c:	66b050ef          	jal	ra,ffffffffc0206296 <strchr>
ffffffffc0200430:	d96d                	beqz	a0,ffffffffc0200422 <kmonitor+0xd8>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200432:	00044583          	lbu	a1,0(s0)
ffffffffc0200436:	d1d9                	beqz	a1,ffffffffc02003bc <kmonitor+0x72>
ffffffffc0200438:	bf55                	j	ffffffffc02003ec <kmonitor+0xa2>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020043a:	45c1                	li	a1,16
ffffffffc020043c:	855a                	mv	a0,s6
ffffffffc020043e:	d5bff0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc0200442:	b7e9                	j	ffffffffc020040c <kmonitor+0xc2>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc0200444:	001c9793          	slli	a5,s9,0x1
ffffffffc0200448:	97e6                	add	a5,a5,s9
ffffffffc020044a:	078e                	slli	a5,a5,0x3
ffffffffc020044c:	97e2                	add	a5,a5,s8
ffffffffc020044e:	6b9c                	ld	a5,16(a5)
ffffffffc0200450:	865e                	mv	a2,s7
ffffffffc0200452:	002c                	addi	a1,sp,8
ffffffffc0200454:	fff9051b          	addiw	a0,s2,-1
ffffffffc0200458:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc020045a:	f40558e3          	bgez	a0,ffffffffc02003aa <kmonitor+0x60>
}
ffffffffc020045e:	60ee                	ld	ra,216(sp)
ffffffffc0200460:	644e                	ld	s0,208(sp)
ffffffffc0200462:	64ae                	ld	s1,200(sp)
ffffffffc0200464:	690e                	ld	s2,192(sp)
ffffffffc0200466:	79ea                	ld	s3,184(sp)
ffffffffc0200468:	7a4a                	ld	s4,176(sp)
ffffffffc020046a:	7aaa                	ld	s5,168(sp)
ffffffffc020046c:	7b0a                	ld	s6,160(sp)
ffffffffc020046e:	6bea                	ld	s7,152(sp)
ffffffffc0200470:	6c4a                	ld	s8,144(sp)
ffffffffc0200472:	6caa                	ld	s9,136(sp)
ffffffffc0200474:	612d                	addi	sp,sp,224
ffffffffc0200476:	8082                	ret

ffffffffc0200478 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200478:	00146317          	auipc	t1,0x146
ffffffffc020047c:	d5030313          	addi	t1,t1,-688 # ffffffffc03461c8 <is_panic>
ffffffffc0200480:	00033e03          	ld	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200484:	715d                	addi	sp,sp,-80
ffffffffc0200486:	ec06                	sd	ra,24(sp)
ffffffffc0200488:	e822                	sd	s0,16(sp)
ffffffffc020048a:	f436                	sd	a3,40(sp)
ffffffffc020048c:	f83a                	sd	a4,48(sp)
ffffffffc020048e:	fc3e                	sd	a5,56(sp)
ffffffffc0200490:	e0c2                	sd	a6,64(sp)
ffffffffc0200492:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200494:	020e1a63          	bnez	t3,ffffffffc02004c8 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200498:	4785                	li	a5,1
ffffffffc020049a:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc020049e:	8432                	mv	s0,a2
ffffffffc02004a0:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004a2:	862e                	mv	a2,a1
ffffffffc02004a4:	85aa                	mv	a1,a0
ffffffffc02004a6:	00006517          	auipc	a0,0x6
ffffffffc02004aa:	30a50513          	addi	a0,a0,778 # ffffffffc02067b0 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004ae:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004b0:	ce9ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004b4:	65a2                	ld	a1,8(sp)
ffffffffc02004b6:	8522                	mv	a0,s0
ffffffffc02004b8:	cc1ff0ef          	jal	ra,ffffffffc0200178 <vcprintf>
    cprintf("\n");
ffffffffc02004bc:	00007517          	auipc	a0,0x7
ffffffffc02004c0:	42450513          	addi	a0,a0,1060 # ffffffffc02078e0 <default_pmm_manager+0x578>
ffffffffc02004c4:	cd5ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004c8:	4501                	li	a0,0
ffffffffc02004ca:	4581                	li	a1,0
ffffffffc02004cc:	4601                	li	a2,0
ffffffffc02004ce:	48a1                	li	a7,8
ffffffffc02004d0:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004d4:	4c4000ef          	jal	ra,ffffffffc0200998 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02004d8:	4501                	li	a0,0
ffffffffc02004da:	e71ff0ef          	jal	ra,ffffffffc020034a <kmonitor>
    while (1) {
ffffffffc02004de:	bfed                	j	ffffffffc02004d8 <__panic+0x60>

ffffffffc02004e0 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004e0:	715d                	addi	sp,sp,-80
ffffffffc02004e2:	832e                	mv	t1,a1
ffffffffc02004e4:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004e6:	85aa                	mv	a1,a0
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004e8:	8432                	mv	s0,a2
ffffffffc02004ea:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004ec:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc02004ee:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004f0:	00006517          	auipc	a0,0x6
ffffffffc02004f4:	2e050513          	addi	a0,a0,736 # ffffffffc02067d0 <commands+0x68>
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004f8:	ec06                	sd	ra,24(sp)
ffffffffc02004fa:	f436                	sd	a3,40(sp)
ffffffffc02004fc:	f83a                	sd	a4,48(sp)
ffffffffc02004fe:	e0c2                	sd	a6,64(sp)
ffffffffc0200500:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0200502:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200504:	c95ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200508:	65a2                	ld	a1,8(sp)
ffffffffc020050a:	8522                	mv	a0,s0
ffffffffc020050c:	c6dff0ef          	jal	ra,ffffffffc0200178 <vcprintf>
    cprintf("\n");
ffffffffc0200510:	00007517          	auipc	a0,0x7
ffffffffc0200514:	3d050513          	addi	a0,a0,976 # ffffffffc02078e0 <default_pmm_manager+0x578>
ffffffffc0200518:	c81ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    va_end(ap);
}
ffffffffc020051c:	60e2                	ld	ra,24(sp)
ffffffffc020051e:	6442                	ld	s0,16(sp)
ffffffffc0200520:	6161                	addi	sp,sp,80
ffffffffc0200522:	8082                	ret

ffffffffc0200524 <clock_init>:
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void)
{
    set_csr(sie, MIP_STIP);
ffffffffc0200524:	02000793          	li	a5,32
ffffffffc0200528:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020052c:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200530:	67e1                	lui	a5,0x18
ffffffffc0200532:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0x1b20>
ffffffffc0200536:	953e                	add	a0,a0,a5
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200538:	4581                	li	a1,0
ffffffffc020053a:	4601                	li	a2,0
ffffffffc020053c:	4881                	li	a7,0
ffffffffc020053e:	00000073          	ecall
    cprintf("++ setup timer interrupts\n");
ffffffffc0200542:	00006517          	auipc	a0,0x6
ffffffffc0200546:	2ae50513          	addi	a0,a0,686 # ffffffffc02067f0 <commands+0x88>
    ticks = 0;
ffffffffc020054a:	00146797          	auipc	a5,0x146
ffffffffc020054e:	c807b323          	sd	zero,-890(a5) # ffffffffc03461d0 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200552:	b199                	j	ffffffffc0200198 <cprintf>

ffffffffc0200554 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200554:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200558:	67e1                	lui	a5,0x18
ffffffffc020055a:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0x1b20>
ffffffffc020055e:	953e                	add	a0,a0,a5
ffffffffc0200560:	4581                	li	a1,0
ffffffffc0200562:	4601                	li	a2,0
ffffffffc0200564:	4881                	li	a7,0
ffffffffc0200566:	00000073          	ecall
ffffffffc020056a:	8082                	ret

ffffffffc020056c <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020056c:	8082                	ret

ffffffffc020056e <cons_putc>:
#include <assert.h>
#include <atomic.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020056e:	100027f3          	csrr	a5,sstatus
ffffffffc0200572:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200574:	0ff57513          	zext.b	a0,a0
ffffffffc0200578:	e799                	bnez	a5,ffffffffc0200586 <cons_putc+0x18>
ffffffffc020057a:	4581                	li	a1,0
ffffffffc020057c:	4601                	li	a2,0
ffffffffc020057e:	4885                	li	a7,1
ffffffffc0200580:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc0200584:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200586:	1101                	addi	sp,sp,-32
ffffffffc0200588:	ec06                	sd	ra,24(sp)
ffffffffc020058a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020058c:	40c000ef          	jal	ra,ffffffffc0200998 <intr_disable>
ffffffffc0200590:	6522                	ld	a0,8(sp)
ffffffffc0200592:	4581                	li	a1,0
ffffffffc0200594:	4601                	li	a2,0
ffffffffc0200596:	4885                	li	a7,1
ffffffffc0200598:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc020059c:	60e2                	ld	ra,24(sp)
ffffffffc020059e:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc02005a0:	aecd                	j	ffffffffc0200992 <intr_enable>

ffffffffc02005a2 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02005a2:	100027f3          	csrr	a5,sstatus
ffffffffc02005a6:	8b89                	andi	a5,a5,2
ffffffffc02005a8:	eb89                	bnez	a5,ffffffffc02005ba <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02005aa:	4501                	li	a0,0
ffffffffc02005ac:	4581                	li	a1,0
ffffffffc02005ae:	4601                	li	a2,0
ffffffffc02005b0:	4889                	li	a7,2
ffffffffc02005b2:	00000073          	ecall
ffffffffc02005b6:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005b8:	8082                	ret
int cons_getc(void) {
ffffffffc02005ba:	1101                	addi	sp,sp,-32
ffffffffc02005bc:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005be:	3da000ef          	jal	ra,ffffffffc0200998 <intr_disable>
ffffffffc02005c2:	4501                	li	a0,0
ffffffffc02005c4:	4581                	li	a1,0
ffffffffc02005c6:	4601                	li	a2,0
ffffffffc02005c8:	4889                	li	a7,2
ffffffffc02005ca:	00000073          	ecall
ffffffffc02005ce:	2501                	sext.w	a0,a0
ffffffffc02005d0:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005d2:	3c0000ef          	jal	ra,ffffffffc0200992 <intr_enable>
}
ffffffffc02005d6:	60e2                	ld	ra,24(sp)
ffffffffc02005d8:	6522                	ld	a0,8(sp)
ffffffffc02005da:	6105                	addi	sp,sp,32
ffffffffc02005dc:	8082                	ret

ffffffffc02005de <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005de:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc02005e0:	00006517          	auipc	a0,0x6
ffffffffc02005e4:	23050513          	addi	a0,a0,560 # ffffffffc0206810 <commands+0xa8>
void dtb_init(void) {
ffffffffc02005e8:	fc86                	sd	ra,120(sp)
ffffffffc02005ea:	f8a2                	sd	s0,112(sp)
ffffffffc02005ec:	e8d2                	sd	s4,80(sp)
ffffffffc02005ee:	f4a6                	sd	s1,104(sp)
ffffffffc02005f0:	f0ca                	sd	s2,96(sp)
ffffffffc02005f2:	ecce                	sd	s3,88(sp)
ffffffffc02005f4:	e4d6                	sd	s5,72(sp)
ffffffffc02005f6:	e0da                	sd	s6,64(sp)
ffffffffc02005f8:	fc5e                	sd	s7,56(sp)
ffffffffc02005fa:	f862                	sd	s8,48(sp)
ffffffffc02005fc:	f466                	sd	s9,40(sp)
ffffffffc02005fe:	f06a                	sd	s10,32(sp)
ffffffffc0200600:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200602:	b97ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200606:	0000c597          	auipc	a1,0xc
ffffffffc020060a:	9fa5b583          	ld	a1,-1542(a1) # ffffffffc020c000 <boot_hartid>
ffffffffc020060e:	00006517          	auipc	a0,0x6
ffffffffc0200612:	21250513          	addi	a0,a0,530 # ffffffffc0206820 <commands+0xb8>
ffffffffc0200616:	b83ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020061a:	0000c417          	auipc	s0,0xc
ffffffffc020061e:	9ee40413          	addi	s0,s0,-1554 # ffffffffc020c008 <boot_dtb>
ffffffffc0200622:	600c                	ld	a1,0(s0)
ffffffffc0200624:	00006517          	auipc	a0,0x6
ffffffffc0200628:	20c50513          	addi	a0,a0,524 # ffffffffc0206830 <commands+0xc8>
ffffffffc020062c:	b6dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200630:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200634:	00006517          	auipc	a0,0x6
ffffffffc0200638:	21450513          	addi	a0,a0,532 # ffffffffc0206848 <commands+0xe0>
    if (boot_dtb == 0) {
ffffffffc020063c:	120a0563          	beqz	s4,ffffffffc0200766 <dtb_init+0x188>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200640:	57f5                	li	a5,-3
ffffffffc0200642:	07fa                	slli	a5,a5,0x1e
ffffffffc0200644:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200648:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020064a:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020064e:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200650:	0087d69b          	srliw	a3,a5,0x8
ffffffffc0200654:	0187959b          	slliw	a1,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200658:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020065c:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200660:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200664:	8dc9                	or	a1,a1,a0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200666:	8ef1                	and	a3,a3,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200668:	0087979b          	slliw	a5,a5,0x8
ffffffffc020066c:	1b7d                	addi	s6,s6,-1
ffffffffc020066e:	8dd5                	or	a1,a1,a3
ffffffffc0200670:	0167f7b3          	and	a5,a5,s6
ffffffffc0200674:	8fcd                	or	a5,a5,a1
ffffffffc0200676:	0007859b          	sext.w	a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc020067a:	d00e07b7          	lui	a5,0xd00e0
ffffffffc020067e:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfd99c9d>
ffffffffc0200682:	10f59163          	bne	a1,a5,ffffffffc0200784 <dtb_init+0x1a6>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc0200686:	471c                	lw	a5,8(a4)
ffffffffc0200688:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc020068a:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020068c:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200690:	0086d51b          	srliw	a0,a3,0x8
ffffffffc0200694:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200698:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020069c:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006a0:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006a4:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006a8:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ac:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b0:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006b4:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b6:	01146433          	or	s0,s0,a7
ffffffffc02006ba:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006be:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c2:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c4:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006c8:	8c49                	or	s0,s0,a0
ffffffffc02006ca:	0166f6b3          	and	a3,a3,s6
ffffffffc02006ce:	00ca6a33          	or	s4,s4,a2
ffffffffc02006d2:	0167f7b3          	and	a5,a5,s6
ffffffffc02006d6:	8c55                	or	s0,s0,a3
ffffffffc02006d8:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006dc:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006de:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006e0:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006e2:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006e6:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006e8:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ea:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc02006ee:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006f0:	00006917          	auipc	s2,0x6
ffffffffc02006f4:	1a890913          	addi	s2,s2,424 # ffffffffc0206898 <commands+0x130>
ffffffffc02006f8:	49bd                	li	s3,15
        switch (token) {
ffffffffc02006fa:	4d91                	li	s11,4
ffffffffc02006fc:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02006fe:	00006497          	auipc	s1,0x6
ffffffffc0200702:	19248493          	addi	s1,s1,402 # ffffffffc0206890 <commands+0x128>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200706:	000a2703          	lw	a4,0(s4)
ffffffffc020070a:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020070e:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200712:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200716:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020071a:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020071e:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200722:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200724:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200728:	0087171b          	slliw	a4,a4,0x8
ffffffffc020072c:	8fd5                	or	a5,a5,a3
ffffffffc020072e:	00eb7733          	and	a4,s6,a4
ffffffffc0200732:	8fd9                	or	a5,a5,a4
ffffffffc0200734:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200736:	09778c63          	beq	a5,s7,ffffffffc02007ce <dtb_init+0x1f0>
ffffffffc020073a:	00fbea63          	bltu	s7,a5,ffffffffc020074e <dtb_init+0x170>
ffffffffc020073e:	07a78663          	beq	a5,s10,ffffffffc02007aa <dtb_init+0x1cc>
ffffffffc0200742:	4709                	li	a4,2
ffffffffc0200744:	00e79763          	bne	a5,a4,ffffffffc0200752 <dtb_init+0x174>
ffffffffc0200748:	4c81                	li	s9,0
ffffffffc020074a:	8a56                	mv	s4,s5
ffffffffc020074c:	bf6d                	j	ffffffffc0200706 <dtb_init+0x128>
ffffffffc020074e:	ffb78ee3          	beq	a5,s11,ffffffffc020074a <dtb_init+0x16c>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200752:	00006517          	auipc	a0,0x6
ffffffffc0200756:	1be50513          	addi	a0,a0,446 # ffffffffc0206910 <commands+0x1a8>
ffffffffc020075a:	a3fff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020075e:	00006517          	auipc	a0,0x6
ffffffffc0200762:	1ea50513          	addi	a0,a0,490 # ffffffffc0206948 <commands+0x1e0>
}
ffffffffc0200766:	7446                	ld	s0,112(sp)
ffffffffc0200768:	70e6                	ld	ra,120(sp)
ffffffffc020076a:	74a6                	ld	s1,104(sp)
ffffffffc020076c:	7906                	ld	s2,96(sp)
ffffffffc020076e:	69e6                	ld	s3,88(sp)
ffffffffc0200770:	6a46                	ld	s4,80(sp)
ffffffffc0200772:	6aa6                	ld	s5,72(sp)
ffffffffc0200774:	6b06                	ld	s6,64(sp)
ffffffffc0200776:	7be2                	ld	s7,56(sp)
ffffffffc0200778:	7c42                	ld	s8,48(sp)
ffffffffc020077a:	7ca2                	ld	s9,40(sp)
ffffffffc020077c:	7d02                	ld	s10,32(sp)
ffffffffc020077e:	6de2                	ld	s11,24(sp)
ffffffffc0200780:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc0200782:	bc19                	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200784:	7446                	ld	s0,112(sp)
ffffffffc0200786:	70e6                	ld	ra,120(sp)
ffffffffc0200788:	74a6                	ld	s1,104(sp)
ffffffffc020078a:	7906                	ld	s2,96(sp)
ffffffffc020078c:	69e6                	ld	s3,88(sp)
ffffffffc020078e:	6a46                	ld	s4,80(sp)
ffffffffc0200790:	6aa6                	ld	s5,72(sp)
ffffffffc0200792:	6b06                	ld	s6,64(sp)
ffffffffc0200794:	7be2                	ld	s7,56(sp)
ffffffffc0200796:	7c42                	ld	s8,48(sp)
ffffffffc0200798:	7ca2                	ld	s9,40(sp)
ffffffffc020079a:	7d02                	ld	s10,32(sp)
ffffffffc020079c:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc020079e:	00006517          	auipc	a0,0x6
ffffffffc02007a2:	0ca50513          	addi	a0,a0,202 # ffffffffc0206868 <commands+0x100>
}
ffffffffc02007a6:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007a8:	bac5                	j	ffffffffc0200198 <cprintf>
                int name_len = strlen(name);
ffffffffc02007aa:	8556                	mv	a0,s5
ffffffffc02007ac:	25b050ef          	jal	ra,ffffffffc0206206 <strlen>
ffffffffc02007b0:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007b2:	4619                	li	a2,6
ffffffffc02007b4:	85a6                	mv	a1,s1
ffffffffc02007b6:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007b8:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007ba:	2b7050ef          	jal	ra,ffffffffc0206270 <strncmp>
ffffffffc02007be:	e111                	bnez	a0,ffffffffc02007c2 <dtb_init+0x1e4>
                    in_memory_node = 1;
ffffffffc02007c0:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02007c2:	0a91                	addi	s5,s5,4
ffffffffc02007c4:	9ad2                	add	s5,s5,s4
ffffffffc02007c6:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02007ca:	8a56                	mv	s4,s5
ffffffffc02007cc:	bf2d                	j	ffffffffc0200706 <dtb_init+0x128>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007ce:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007d2:	00ca0713          	addi	a4,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007d6:	0087da9b          	srliw	s5,a5,0x8
ffffffffc02007da:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007de:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007e2:	010a9a9b          	slliw	s5,s5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007e6:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007ea:	018afab3          	and	s5,s5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007ee:	8ed1                	or	a3,a3,a2
ffffffffc02007f0:	0087979b          	slliw	a5,a5,0x8
ffffffffc02007f4:	00daeab3          	or	s5,s5,a3
ffffffffc02007f8:	00fb77b3          	and	a5,s6,a5
ffffffffc02007fc:	00faeab3          	or	s5,s5,a5
ffffffffc0200800:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200802:	000c9c63          	bnez	s9,ffffffffc020081a <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200806:	1a82                	slli	s5,s5,0x20
ffffffffc0200808:	00370793          	addi	a5,a4,3
ffffffffc020080c:	020ada93          	srli	s5,s5,0x20
ffffffffc0200810:	9abe                	add	s5,s5,a5
ffffffffc0200812:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200816:	8a56                	mv	s4,s5
ffffffffc0200818:	b5fd                	j	ffffffffc0200706 <dtb_init+0x128>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020081a:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020081e:	85ca                	mv	a1,s2
ffffffffc0200820:	e43a                	sd	a4,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200822:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200826:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020082a:	0187969b          	slliw	a3,a5,0x18
ffffffffc020082e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200832:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200836:	8ed1                	or	a3,a3,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200838:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020083c:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200840:	8d55                	or	a0,a0,a3
ffffffffc0200842:	00fb77b3          	and	a5,s6,a5
ffffffffc0200846:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200848:	1502                	slli	a0,a0,0x20
ffffffffc020084a:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020084c:	9522                	add	a0,a0,s0
ffffffffc020084e:	201050ef          	jal	ra,ffffffffc020624e <strcmp>
ffffffffc0200852:	6722                	ld	a4,8(sp)
ffffffffc0200854:	f94d                	bnez	a0,ffffffffc0200806 <dtb_init+0x228>
ffffffffc0200856:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200806 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020085a:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020085e:	014a3683          	ld	a3,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200862:	00006517          	auipc	a0,0x6
ffffffffc0200866:	03e50513          	addi	a0,a0,62 # ffffffffc02068a0 <commands+0x138>
           fdt32_to_cpu(x >> 32);
ffffffffc020086a:	4207d613          	srai	a2,a5,0x20
ffffffffc020086e:	4206d813          	srai	a6,a3,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200872:	0187df9b          	srliw	t6,a5,0x18
ffffffffc0200876:	01865e9b          	srliw	t4,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020087a:	0087de1b          	srliw	t3,a5,0x8
ffffffffc020087e:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200882:	0107d31b          	srliw	t1,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200886:	0187d713          	srli	a4,a5,0x18
ffffffffc020088a:	01861f1b          	slliw	t5,a2,0x18
ffffffffc020088e:	0086d79b          	srliw	a5,a3,0x8
ffffffffc0200892:	0088589b          	srliw	a7,a6,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200896:	01df6f33          	or	t5,t5,t4
ffffffffc020089a:	0186d29b          	srliw	t0,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020089e:	01869e9b          	slliw	t4,a3,0x18
ffffffffc02008a2:	0108989b          	slliw	a7,a7,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008a6:	0106559b          	srliw	a1,a2,0x10
ffffffffc02008aa:	01f46433          	or	s0,s0,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008ae:	0188161b          	slliw	a2,a6,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008b2:	01885f9b          	srliw	t6,a6,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008b6:	010e1e1b          	slliw	t3,t3,0x10
ffffffffc02008ba:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008be:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02008c2:	0108581b          	srliw	a6,a6,0x10
ffffffffc02008c6:	01f66633          	or	a2,a2,t6
ffffffffc02008ca:	0088181b          	slliw	a6,a6,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008ce:	018e7e33          	and	t3,t3,s8
ffffffffc02008d2:	01877733          	and	a4,a4,s8
ffffffffc02008d6:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008da:	0083131b          	slliw	t1,t1,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008de:	0188fc33          	and	s8,a7,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008e2:	0085959b          	slliw	a1,a1,0x8
ffffffffc02008e6:	0086969b          	slliw	a3,a3,0x8
ffffffffc02008ea:	006b7333          	and	t1,s6,t1
ffffffffc02008ee:	00db76b3          	and	a3,s6,a3
ffffffffc02008f2:	01e76733          	or	a4,a4,t5
ffffffffc02008f6:	00bb75b3          	and	a1,s6,a1
ffffffffc02008fa:	01866c33          	or	s8,a2,s8
ffffffffc02008fe:	010b7b33          	and	s6,s6,a6
ffffffffc0200902:	01c46433          	or	s0,s0,t3
ffffffffc0200906:	005eee33          	or	t3,t4,t0
ffffffffc020090a:	01c7e7b3          	or	a5,a5,t3
ffffffffc020090e:	8f4d                	or	a4,a4,a1
ffffffffc0200910:	016c6b33          	or	s6,s8,s6
ffffffffc0200914:	00646433          	or	s0,s0,t1
ffffffffc0200918:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc020091a:	1702                	slli	a4,a4,0x20
ffffffffc020091c:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020091e:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200920:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200922:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200924:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200928:	0167eb33          	or	s6,a5,s6
ffffffffc020092c:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020092e:	86bff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200932:	85a2                	mv	a1,s0
ffffffffc0200934:	00006517          	auipc	a0,0x6
ffffffffc0200938:	f8c50513          	addi	a0,a0,-116 # ffffffffc02068c0 <commands+0x158>
ffffffffc020093c:	85dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200940:	014b5613          	srli	a2,s6,0x14
ffffffffc0200944:	85da                	mv	a1,s6
ffffffffc0200946:	00006517          	auipc	a0,0x6
ffffffffc020094a:	f9250513          	addi	a0,a0,-110 # ffffffffc02068d8 <commands+0x170>
ffffffffc020094e:	84bff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200952:	008b05b3          	add	a1,s6,s0
ffffffffc0200956:	15fd                	addi	a1,a1,-1
ffffffffc0200958:	00006517          	auipc	a0,0x6
ffffffffc020095c:	fa050513          	addi	a0,a0,-96 # ffffffffc02068f8 <commands+0x190>
ffffffffc0200960:	839ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc0200964:	00006517          	auipc	a0,0x6
ffffffffc0200968:	fe450513          	addi	a0,a0,-28 # ffffffffc0206948 <commands+0x1e0>
        memory_base = mem_base;
ffffffffc020096c:	00146797          	auipc	a5,0x146
ffffffffc0200970:	8687b623          	sd	s0,-1940(a5) # ffffffffc03461d8 <memory_base>
        memory_size = mem_size;
ffffffffc0200974:	00146797          	auipc	a5,0x146
ffffffffc0200978:	8767b623          	sd	s6,-1940(a5) # ffffffffc03461e0 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc020097c:	b3ed                	j	ffffffffc0200766 <dtb_init+0x188>

ffffffffc020097e <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020097e:	00146517          	auipc	a0,0x146
ffffffffc0200982:	85a53503          	ld	a0,-1958(a0) # ffffffffc03461d8 <memory_base>
ffffffffc0200986:	8082                	ret

ffffffffc0200988 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc0200988:	00146517          	auipc	a0,0x146
ffffffffc020098c:	85853503          	ld	a0,-1960(a0) # ffffffffc03461e0 <memory_size>
ffffffffc0200990:	8082                	ret

ffffffffc0200992 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200992:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200996:	8082                	ret

ffffffffc0200998 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200998:	100177f3          	csrrci	a5,sstatus,2
ffffffffc020099c:	8082                	ret

ffffffffc020099e <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc020099e:	8082                	ret

ffffffffc02009a0 <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009a0:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009a4:	00000797          	auipc	a5,0x0
ffffffffc02009a8:	54078793          	addi	a5,a5,1344 # ffffffffc0200ee4 <__alltraps>
ffffffffc02009ac:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009b0:	000407b7          	lui	a5,0x40
ffffffffc02009b4:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009b8:	8082                	ret

ffffffffc02009ba <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009ba:	610c                	ld	a1,0(a0)
{
ffffffffc02009bc:	1141                	addi	sp,sp,-16
ffffffffc02009be:	e022                	sd	s0,0(sp)
ffffffffc02009c0:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009c2:	00006517          	auipc	a0,0x6
ffffffffc02009c6:	f9e50513          	addi	a0,a0,-98 # ffffffffc0206960 <commands+0x1f8>
{
ffffffffc02009ca:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009cc:	fccff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009d0:	640c                	ld	a1,8(s0)
ffffffffc02009d2:	00006517          	auipc	a0,0x6
ffffffffc02009d6:	fa650513          	addi	a0,a0,-90 # ffffffffc0206978 <commands+0x210>
ffffffffc02009da:	fbeff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009de:	680c                	ld	a1,16(s0)
ffffffffc02009e0:	00006517          	auipc	a0,0x6
ffffffffc02009e4:	fb050513          	addi	a0,a0,-80 # ffffffffc0206990 <commands+0x228>
ffffffffc02009e8:	fb0ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02009ec:	6c0c                	ld	a1,24(s0)
ffffffffc02009ee:	00006517          	auipc	a0,0x6
ffffffffc02009f2:	fba50513          	addi	a0,a0,-70 # ffffffffc02069a8 <commands+0x240>
ffffffffc02009f6:	fa2ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02009fa:	700c                	ld	a1,32(s0)
ffffffffc02009fc:	00006517          	auipc	a0,0x6
ffffffffc0200a00:	fc450513          	addi	a0,a0,-60 # ffffffffc02069c0 <commands+0x258>
ffffffffc0200a04:	f94ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a08:	740c                	ld	a1,40(s0)
ffffffffc0200a0a:	00006517          	auipc	a0,0x6
ffffffffc0200a0e:	fce50513          	addi	a0,a0,-50 # ffffffffc02069d8 <commands+0x270>
ffffffffc0200a12:	f86ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a16:	780c                	ld	a1,48(s0)
ffffffffc0200a18:	00006517          	auipc	a0,0x6
ffffffffc0200a1c:	fd850513          	addi	a0,a0,-40 # ffffffffc02069f0 <commands+0x288>
ffffffffc0200a20:	f78ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a24:	7c0c                	ld	a1,56(s0)
ffffffffc0200a26:	00006517          	auipc	a0,0x6
ffffffffc0200a2a:	fe250513          	addi	a0,a0,-30 # ffffffffc0206a08 <commands+0x2a0>
ffffffffc0200a2e:	f6aff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a32:	602c                	ld	a1,64(s0)
ffffffffc0200a34:	00006517          	auipc	a0,0x6
ffffffffc0200a38:	fec50513          	addi	a0,a0,-20 # ffffffffc0206a20 <commands+0x2b8>
ffffffffc0200a3c:	f5cff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a40:	642c                	ld	a1,72(s0)
ffffffffc0200a42:	00006517          	auipc	a0,0x6
ffffffffc0200a46:	ff650513          	addi	a0,a0,-10 # ffffffffc0206a38 <commands+0x2d0>
ffffffffc0200a4a:	f4eff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a4e:	682c                	ld	a1,80(s0)
ffffffffc0200a50:	00006517          	auipc	a0,0x6
ffffffffc0200a54:	00050513          	mv	a0,a0
ffffffffc0200a58:	f40ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a5c:	6c2c                	ld	a1,88(s0)
ffffffffc0200a5e:	00006517          	auipc	a0,0x6
ffffffffc0200a62:	00a50513          	addi	a0,a0,10 # ffffffffc0206a68 <commands+0x300>
ffffffffc0200a66:	f32ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a6a:	702c                	ld	a1,96(s0)
ffffffffc0200a6c:	00006517          	auipc	a0,0x6
ffffffffc0200a70:	01450513          	addi	a0,a0,20 # ffffffffc0206a80 <commands+0x318>
ffffffffc0200a74:	f24ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a78:	742c                	ld	a1,104(s0)
ffffffffc0200a7a:	00006517          	auipc	a0,0x6
ffffffffc0200a7e:	01e50513          	addi	a0,a0,30 # ffffffffc0206a98 <commands+0x330>
ffffffffc0200a82:	f16ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200a86:	782c                	ld	a1,112(s0)
ffffffffc0200a88:	00006517          	auipc	a0,0x6
ffffffffc0200a8c:	02850513          	addi	a0,a0,40 # ffffffffc0206ab0 <commands+0x348>
ffffffffc0200a90:	f08ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200a94:	7c2c                	ld	a1,120(s0)
ffffffffc0200a96:	00006517          	auipc	a0,0x6
ffffffffc0200a9a:	03250513          	addi	a0,a0,50 # ffffffffc0206ac8 <commands+0x360>
ffffffffc0200a9e:	efaff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200aa2:	604c                	ld	a1,128(s0)
ffffffffc0200aa4:	00006517          	auipc	a0,0x6
ffffffffc0200aa8:	03c50513          	addi	a0,a0,60 # ffffffffc0206ae0 <commands+0x378>
ffffffffc0200aac:	eecff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200ab0:	644c                	ld	a1,136(s0)
ffffffffc0200ab2:	00006517          	auipc	a0,0x6
ffffffffc0200ab6:	04650513          	addi	a0,a0,70 # ffffffffc0206af8 <commands+0x390>
ffffffffc0200aba:	edeff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200abe:	684c                	ld	a1,144(s0)
ffffffffc0200ac0:	00006517          	auipc	a0,0x6
ffffffffc0200ac4:	05050513          	addi	a0,a0,80 # ffffffffc0206b10 <commands+0x3a8>
ffffffffc0200ac8:	ed0ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200acc:	6c4c                	ld	a1,152(s0)
ffffffffc0200ace:	00006517          	auipc	a0,0x6
ffffffffc0200ad2:	05a50513          	addi	a0,a0,90 # ffffffffc0206b28 <commands+0x3c0>
ffffffffc0200ad6:	ec2ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200ada:	704c                	ld	a1,160(s0)
ffffffffc0200adc:	00006517          	auipc	a0,0x6
ffffffffc0200ae0:	06450513          	addi	a0,a0,100 # ffffffffc0206b40 <commands+0x3d8>
ffffffffc0200ae4:	eb4ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200ae8:	744c                	ld	a1,168(s0)
ffffffffc0200aea:	00006517          	auipc	a0,0x6
ffffffffc0200aee:	06e50513          	addi	a0,a0,110 # ffffffffc0206b58 <commands+0x3f0>
ffffffffc0200af2:	ea6ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200af6:	784c                	ld	a1,176(s0)
ffffffffc0200af8:	00006517          	auipc	a0,0x6
ffffffffc0200afc:	07850513          	addi	a0,a0,120 # ffffffffc0206b70 <commands+0x408>
ffffffffc0200b00:	e98ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b04:	7c4c                	ld	a1,184(s0)
ffffffffc0200b06:	00006517          	auipc	a0,0x6
ffffffffc0200b0a:	08250513          	addi	a0,a0,130 # ffffffffc0206b88 <commands+0x420>
ffffffffc0200b0e:	e8aff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b12:	606c                	ld	a1,192(s0)
ffffffffc0200b14:	00006517          	auipc	a0,0x6
ffffffffc0200b18:	08c50513          	addi	a0,a0,140 # ffffffffc0206ba0 <commands+0x438>
ffffffffc0200b1c:	e7cff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b20:	646c                	ld	a1,200(s0)
ffffffffc0200b22:	00006517          	auipc	a0,0x6
ffffffffc0200b26:	09650513          	addi	a0,a0,150 # ffffffffc0206bb8 <commands+0x450>
ffffffffc0200b2a:	e6eff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b2e:	686c                	ld	a1,208(s0)
ffffffffc0200b30:	00006517          	auipc	a0,0x6
ffffffffc0200b34:	0a050513          	addi	a0,a0,160 # ffffffffc0206bd0 <commands+0x468>
ffffffffc0200b38:	e60ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b3c:	6c6c                	ld	a1,216(s0)
ffffffffc0200b3e:	00006517          	auipc	a0,0x6
ffffffffc0200b42:	0aa50513          	addi	a0,a0,170 # ffffffffc0206be8 <commands+0x480>
ffffffffc0200b46:	e52ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b4a:	706c                	ld	a1,224(s0)
ffffffffc0200b4c:	00006517          	auipc	a0,0x6
ffffffffc0200b50:	0b450513          	addi	a0,a0,180 # ffffffffc0206c00 <commands+0x498>
ffffffffc0200b54:	e44ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b58:	746c                	ld	a1,232(s0)
ffffffffc0200b5a:	00006517          	auipc	a0,0x6
ffffffffc0200b5e:	0be50513          	addi	a0,a0,190 # ffffffffc0206c18 <commands+0x4b0>
ffffffffc0200b62:	e36ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b66:	786c                	ld	a1,240(s0)
ffffffffc0200b68:	00006517          	auipc	a0,0x6
ffffffffc0200b6c:	0c850513          	addi	a0,a0,200 # ffffffffc0206c30 <commands+0x4c8>
ffffffffc0200b70:	e28ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b74:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b76:	6402                	ld	s0,0(sp)
ffffffffc0200b78:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b7a:	00006517          	auipc	a0,0x6
ffffffffc0200b7e:	0ce50513          	addi	a0,a0,206 # ffffffffc0206c48 <commands+0x4e0>
}
ffffffffc0200b82:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b84:	e14ff06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0200b88 <print_trapframe>:
{
ffffffffc0200b88:	1141                	addi	sp,sp,-16
ffffffffc0200b8a:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b8c:	85aa                	mv	a1,a0
{
ffffffffc0200b8e:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b90:	00006517          	auipc	a0,0x6
ffffffffc0200b94:	0d050513          	addi	a0,a0,208 # ffffffffc0206c60 <commands+0x4f8>
{
ffffffffc0200b98:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b9a:	dfeff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200b9e:	8522                	mv	a0,s0
ffffffffc0200ba0:	e1bff0ef          	jal	ra,ffffffffc02009ba <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200ba4:	10043583          	ld	a1,256(s0)
ffffffffc0200ba8:	00006517          	auipc	a0,0x6
ffffffffc0200bac:	0d050513          	addi	a0,a0,208 # ffffffffc0206c78 <commands+0x510>
ffffffffc0200bb0:	de8ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bb4:	10843583          	ld	a1,264(s0)
ffffffffc0200bb8:	00006517          	auipc	a0,0x6
ffffffffc0200bbc:	0d850513          	addi	a0,a0,216 # ffffffffc0206c90 <commands+0x528>
ffffffffc0200bc0:	dd8ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200bc4:	11043583          	ld	a1,272(s0)
ffffffffc0200bc8:	00006517          	auipc	a0,0x6
ffffffffc0200bcc:	0e050513          	addi	a0,a0,224 # ffffffffc0206ca8 <commands+0x540>
ffffffffc0200bd0:	dc8ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bd4:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bd8:	6402                	ld	s0,0(sp)
ffffffffc0200bda:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bdc:	00006517          	auipc	a0,0x6
ffffffffc0200be0:	0dc50513          	addi	a0,a0,220 # ffffffffc0206cb8 <commands+0x550>
}
ffffffffc0200be4:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200be6:	db2ff06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0200bea <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200bea:	11853783          	ld	a5,280(a0)
{
ffffffffc0200bee:	1141                	addi	sp,sp,-16
ffffffffc0200bf0:	e406                	sd	ra,8(sp)
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200bf2:	0786                	slli	a5,a5,0x1
{
ffffffffc0200bf4:	e022                	sd	s0,0(sp)
ffffffffc0200bf6:	472d                	li	a4,11
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200bf8:	8385                	srli	a5,a5,0x1
ffffffffc0200bfa:	08f76963          	bltu	a4,a5,ffffffffc0200c8c <interrupt_handler+0xa2>
ffffffffc0200bfe:	00006717          	auipc	a4,0x6
ffffffffc0200c02:	1c270713          	addi	a4,a4,450 # ffffffffc0206dc0 <commands+0x658>
ffffffffc0200c06:	078a                	slli	a5,a5,0x2
ffffffffc0200c08:	97ba                	add	a5,a5,a4
ffffffffc0200c0a:	439c                	lw	a5,0(a5)
ffffffffc0200c0c:	97ba                	add	a5,a5,a4
ffffffffc0200c0e:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c10:	00006517          	auipc	a0,0x6
ffffffffc0200c14:	12050513          	addi	a0,a0,288 # ffffffffc0206d30 <commands+0x5c8>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c18:	6402                	ld	s0,0(sp)
ffffffffc0200c1a:	60a2                	ld	ra,8(sp)
ffffffffc0200c1c:	0141                	addi	sp,sp,16
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c1e:	d7aff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c22:	6402                	ld	s0,0(sp)
ffffffffc0200c24:	60a2                	ld	ra,8(sp)
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c26:	00006517          	auipc	a0,0x6
ffffffffc0200c2a:	0ea50513          	addi	a0,a0,234 # ffffffffc0206d10 <commands+0x5a8>
}
ffffffffc0200c2e:	0141                	addi	sp,sp,16
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c30:	d68ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200c34:	6402                	ld	s0,0(sp)
ffffffffc0200c36:	60a2                	ld	ra,8(sp)
        cprintf("User software interrupt\n");
ffffffffc0200c38:	00006517          	auipc	a0,0x6
ffffffffc0200c3c:	09850513          	addi	a0,a0,152 # ffffffffc0206cd0 <commands+0x568>
}
ffffffffc0200c40:	0141                	addi	sp,sp,16
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c42:	d56ff06f          	j	ffffffffc0200198 <cprintf>
ffffffffc0200c46:	00006517          	auipc	a0,0x6
ffffffffc0200c4a:	0aa50513          	addi	a0,a0,170 # ffffffffc0206cf0 <commands+0x588>
ffffffffc0200c4e:	b7e9                	j	ffffffffc0200c18 <interrupt_handler+0x2e>
        clock_set_next_event();  // (1) 设置下一次时钟中断
ffffffffc0200c50:	905ff0ef          	jal	ra,ffffffffc0200554 <clock_set_next_event>
        ticks++;                 // (2) ticks 计数器自增
ffffffffc0200c54:	00145797          	auipc	a5,0x145
ffffffffc0200c58:	57c78793          	addi	a5,a5,1404 # ffffffffc03461d0 <ticks>
ffffffffc0200c5c:	6398                	ld	a4,0(a5)
ffffffffc0200c5e:	0705                	addi	a4,a4,1
ffffffffc0200c60:	e398                	sd	a4,0(a5)
        if (ticks % TICK_NUM == 0) {  // (3) 每 TICK_NUM 次中断
ffffffffc0200c62:	639c                	ld	a5,0(a5)
ffffffffc0200c64:	06400713          	li	a4,100
ffffffffc0200c68:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200c6c:	c3d1                	beqz	a5,ffffffffc0200cf0 <interrupt_handler+0x106>
        if (current != NULL)
ffffffffc0200c6e:	00145517          	auipc	a0,0x145
ffffffffc0200c72:	5b253503          	ld	a0,1458(a0) # ffffffffc0346220 <current>
ffffffffc0200c76:	c92d                	beqz	a0,ffffffffc0200ce8 <interrupt_handler+0xfe>
}
ffffffffc0200c78:	6402                	ld	s0,0(sp)
ffffffffc0200c7a:	60a2                	ld	ra,8(sp)
ffffffffc0200c7c:	0141                	addi	sp,sp,16
            sched_class_proc_tick(current);
ffffffffc0200c7e:	5130406f          	j	ffffffffc0205990 <sched_class_proc_tick>
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c82:	00006517          	auipc	a0,0x6
ffffffffc0200c86:	11e50513          	addi	a0,a0,286 # ffffffffc0206da0 <commands+0x638>
ffffffffc0200c8a:	b779                	j	ffffffffc0200c18 <interrupt_handler+0x2e>
    cprintf("trapframe at %p\n", tf);
ffffffffc0200c8c:	842a                	mv	s0,a0
ffffffffc0200c8e:	85aa                	mv	a1,a0
ffffffffc0200c90:	00006517          	auipc	a0,0x6
ffffffffc0200c94:	fd050513          	addi	a0,a0,-48 # ffffffffc0206c60 <commands+0x4f8>
ffffffffc0200c98:	d00ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200c9c:	8522                	mv	a0,s0
ffffffffc0200c9e:	d1dff0ef          	jal	ra,ffffffffc02009ba <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200ca2:	10043583          	ld	a1,256(s0)
ffffffffc0200ca6:	00006517          	auipc	a0,0x6
ffffffffc0200caa:	fd250513          	addi	a0,a0,-46 # ffffffffc0206c78 <commands+0x510>
ffffffffc0200cae:	ceaff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200cb2:	10843583          	ld	a1,264(s0)
ffffffffc0200cb6:	00006517          	auipc	a0,0x6
ffffffffc0200cba:	fda50513          	addi	a0,a0,-38 # ffffffffc0206c90 <commands+0x528>
ffffffffc0200cbe:	cdaff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200cc2:	11043583          	ld	a1,272(s0)
ffffffffc0200cc6:	00006517          	auipc	a0,0x6
ffffffffc0200cca:	fe250513          	addi	a0,a0,-30 # ffffffffc0206ca8 <commands+0x540>
ffffffffc0200cce:	ccaff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200cd2:	11843583          	ld	a1,280(s0)
}
ffffffffc0200cd6:	6402                	ld	s0,0(sp)
ffffffffc0200cd8:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200cda:	00006517          	auipc	a0,0x6
ffffffffc0200cde:	fde50513          	addi	a0,a0,-34 # ffffffffc0206cb8 <commands+0x550>
}
ffffffffc0200ce2:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200ce4:	cb4ff06f          	j	ffffffffc0200198 <cprintf>
}
ffffffffc0200ce8:	60a2                	ld	ra,8(sp)
ffffffffc0200cea:	6402                	ld	s0,0(sp)
ffffffffc0200cec:	0141                	addi	sp,sp,16
ffffffffc0200cee:	8082                	ret
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200cf0:	06400593          	li	a1,100
ffffffffc0200cf4:	00006517          	auipc	a0,0x6
ffffffffc0200cf8:	05c50513          	addi	a0,a0,92 # ffffffffc0206d50 <commands+0x5e8>
ffffffffc0200cfc:	c9cff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("End of Test.\n");
ffffffffc0200d00:	00006517          	auipc	a0,0x6
ffffffffc0200d04:	06050513          	addi	a0,a0,96 # ffffffffc0206d60 <commands+0x5f8>
ffffffffc0200d08:	c90ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    panic("EOT: kernel seems ok.");
ffffffffc0200d0c:	00006617          	auipc	a2,0x6
ffffffffc0200d10:	06460613          	addi	a2,a2,100 # ffffffffc0206d70 <commands+0x608>
ffffffffc0200d14:	45ed                	li	a1,27
ffffffffc0200d16:	00006517          	auipc	a0,0x6
ffffffffc0200d1a:	07250513          	addi	a0,a0,114 # ffffffffc0206d88 <commands+0x620>
ffffffffc0200d1e:	f5aff0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0200d22 <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200d22:	11853783          	ld	a5,280(a0)
{
ffffffffc0200d26:	1141                	addi	sp,sp,-16
ffffffffc0200d28:	e022                	sd	s0,0(sp)
ffffffffc0200d2a:	e406                	sd	ra,8(sp)
ffffffffc0200d2c:	473d                	li	a4,15
ffffffffc0200d2e:	842a                	mv	s0,a0
ffffffffc0200d30:	0af76b63          	bltu	a4,a5,ffffffffc0200de6 <exception_handler+0xc4>
ffffffffc0200d34:	00006717          	auipc	a4,0x6
ffffffffc0200d38:	23470713          	addi	a4,a4,564 # ffffffffc0206f68 <commands+0x800>
ffffffffc0200d3c:	078a                	slli	a5,a5,0x2
ffffffffc0200d3e:	97ba                	add	a5,a5,a4
ffffffffc0200d40:	439c                	lw	a5,0(a5)
ffffffffc0200d42:	97ba                	add	a5,a5,a4
ffffffffc0200d44:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200d46:	00006517          	auipc	a0,0x6
ffffffffc0200d4a:	17a50513          	addi	a0,a0,378 # ffffffffc0206ec0 <commands+0x758>
ffffffffc0200d4e:	c4aff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        tf->epc += 4;
ffffffffc0200d52:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200d56:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200d58:	0791                	addi	a5,a5,4
ffffffffc0200d5a:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200d5e:	6402                	ld	s0,0(sp)
ffffffffc0200d60:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200d62:	69f0406f          	j	ffffffffc0205c00 <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200d66:	00006517          	auipc	a0,0x6
ffffffffc0200d6a:	17a50513          	addi	a0,a0,378 # ffffffffc0206ee0 <commands+0x778>
}
ffffffffc0200d6e:	6402                	ld	s0,0(sp)
ffffffffc0200d70:	60a2                	ld	ra,8(sp)
ffffffffc0200d72:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200d74:	c24ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d78:	00006517          	auipc	a0,0x6
ffffffffc0200d7c:	18850513          	addi	a0,a0,392 # ffffffffc0206f00 <commands+0x798>
ffffffffc0200d80:	b7fd                	j	ffffffffc0200d6e <exception_handler+0x4c>
        cprintf("Instruction page fault\n");
ffffffffc0200d82:	00006517          	auipc	a0,0x6
ffffffffc0200d86:	19e50513          	addi	a0,a0,414 # ffffffffc0206f20 <commands+0x7b8>
ffffffffc0200d8a:	b7d5                	j	ffffffffc0200d6e <exception_handler+0x4c>
        cprintf("Load page fault\n");
ffffffffc0200d8c:	00006517          	auipc	a0,0x6
ffffffffc0200d90:	1ac50513          	addi	a0,a0,428 # ffffffffc0206f38 <commands+0x7d0>
ffffffffc0200d94:	bfe9                	j	ffffffffc0200d6e <exception_handler+0x4c>
        cprintf("Store/AMO page fault\n");
ffffffffc0200d96:	00006517          	auipc	a0,0x6
ffffffffc0200d9a:	1ba50513          	addi	a0,a0,442 # ffffffffc0206f50 <commands+0x7e8>
ffffffffc0200d9e:	bfc1                	j	ffffffffc0200d6e <exception_handler+0x4c>
        cprintf("Instruction address misaligned\n");
ffffffffc0200da0:	00006517          	auipc	a0,0x6
ffffffffc0200da4:	05050513          	addi	a0,a0,80 # ffffffffc0206df0 <commands+0x688>
ffffffffc0200da8:	b7d9                	j	ffffffffc0200d6e <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200daa:	00006517          	auipc	a0,0x6
ffffffffc0200dae:	06650513          	addi	a0,a0,102 # ffffffffc0206e10 <commands+0x6a8>
ffffffffc0200db2:	bf75                	j	ffffffffc0200d6e <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200db4:	00006517          	auipc	a0,0x6
ffffffffc0200db8:	07c50513          	addi	a0,a0,124 # ffffffffc0206e30 <commands+0x6c8>
ffffffffc0200dbc:	bf4d                	j	ffffffffc0200d6e <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200dbe:	00006517          	auipc	a0,0x6
ffffffffc0200dc2:	08a50513          	addi	a0,a0,138 # ffffffffc0206e48 <commands+0x6e0>
ffffffffc0200dc6:	b765                	j	ffffffffc0200d6e <exception_handler+0x4c>
        cprintf("Load address misaligned\n");
ffffffffc0200dc8:	00006517          	auipc	a0,0x6
ffffffffc0200dcc:	09050513          	addi	a0,a0,144 # ffffffffc0206e58 <commands+0x6f0>
ffffffffc0200dd0:	bf79                	j	ffffffffc0200d6e <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200dd2:	00006517          	auipc	a0,0x6
ffffffffc0200dd6:	0a650513          	addi	a0,a0,166 # ffffffffc0206e78 <commands+0x710>
ffffffffc0200dda:	bf51                	j	ffffffffc0200d6e <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200ddc:	00006517          	auipc	a0,0x6
ffffffffc0200de0:	0cc50513          	addi	a0,a0,204 # ffffffffc0206ea8 <commands+0x740>
ffffffffc0200de4:	b769                	j	ffffffffc0200d6e <exception_handler+0x4c>
    cprintf("trapframe at %p\n", tf);
ffffffffc0200de6:	85a2                	mv	a1,s0
ffffffffc0200de8:	00006517          	auipc	a0,0x6
ffffffffc0200dec:	e7850513          	addi	a0,a0,-392 # ffffffffc0206c60 <commands+0x4f8>
ffffffffc0200df0:	ba8ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200df4:	8522                	mv	a0,s0
ffffffffc0200df6:	bc5ff0ef          	jal	ra,ffffffffc02009ba <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200dfa:	10043583          	ld	a1,256(s0)
ffffffffc0200dfe:	00006517          	auipc	a0,0x6
ffffffffc0200e02:	e7a50513          	addi	a0,a0,-390 # ffffffffc0206c78 <commands+0x510>
ffffffffc0200e06:	b92ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200e0a:	10843583          	ld	a1,264(s0)
ffffffffc0200e0e:	00006517          	auipc	a0,0x6
ffffffffc0200e12:	e8250513          	addi	a0,a0,-382 # ffffffffc0206c90 <commands+0x528>
ffffffffc0200e16:	b82ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200e1a:	11043583          	ld	a1,272(s0)
ffffffffc0200e1e:	00006517          	auipc	a0,0x6
ffffffffc0200e22:	e8a50513          	addi	a0,a0,-374 # ffffffffc0206ca8 <commands+0x540>
ffffffffc0200e26:	b72ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200e2a:	11843583          	ld	a1,280(s0)
}
ffffffffc0200e2e:	6402                	ld	s0,0(sp)
ffffffffc0200e30:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200e32:	00006517          	auipc	a0,0x6
ffffffffc0200e36:	e8650513          	addi	a0,a0,-378 # ffffffffc0206cb8 <commands+0x550>
}
ffffffffc0200e3a:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200e3c:	b5cff06f          	j	ffffffffc0200198 <cprintf>
        panic("AMO address misaligned\n");
ffffffffc0200e40:	00006617          	auipc	a2,0x6
ffffffffc0200e44:	05060613          	addi	a2,a2,80 # ffffffffc0206e90 <commands+0x728>
ffffffffc0200e48:	0ce00593          	li	a1,206
ffffffffc0200e4c:	00006517          	auipc	a0,0x6
ffffffffc0200e50:	f3c50513          	addi	a0,a0,-196 # ffffffffc0206d88 <commands+0x620>
ffffffffc0200e54:	e24ff0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0200e58 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200e58:	1101                	addi	sp,sp,-32
ffffffffc0200e5a:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200e5c:	00145417          	auipc	s0,0x145
ffffffffc0200e60:	3c440413          	addi	s0,s0,964 # ffffffffc0346220 <current>
ffffffffc0200e64:	6018                	ld	a4,0(s0)
{
ffffffffc0200e66:	ec06                	sd	ra,24(sp)
ffffffffc0200e68:	e426                	sd	s1,8(sp)
ffffffffc0200e6a:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e6c:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200e70:	cf1d                	beqz	a4,ffffffffc0200eae <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e72:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200e76:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200e7a:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e7c:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e80:	0206c463          	bltz	a3,ffffffffc0200ea8 <trap+0x50>
        exception_handler(tf);
ffffffffc0200e84:	e9fff0ef          	jal	ra,ffffffffc0200d22 <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200e88:	601c                	ld	a5,0(s0)
ffffffffc0200e8a:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200e8e:	e499                	bnez	s1,ffffffffc0200e9c <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200e90:	0b07a703          	lw	a4,176(a5)
ffffffffc0200e94:	8b05                	andi	a4,a4,1
ffffffffc0200e96:	e329                	bnez	a4,ffffffffc0200ed8 <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200e98:	6f9c                	ld	a5,24(a5)
ffffffffc0200e9a:	eb85                	bnez	a5,ffffffffc0200eca <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200e9c:	60e2                	ld	ra,24(sp)
ffffffffc0200e9e:	6442                	ld	s0,16(sp)
ffffffffc0200ea0:	64a2                	ld	s1,8(sp)
ffffffffc0200ea2:	6902                	ld	s2,0(sp)
ffffffffc0200ea4:	6105                	addi	sp,sp,32
ffffffffc0200ea6:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200ea8:	d43ff0ef          	jal	ra,ffffffffc0200bea <interrupt_handler>
ffffffffc0200eac:	bff1                	j	ffffffffc0200e88 <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200eae:	0006c863          	bltz	a3,ffffffffc0200ebe <trap+0x66>
}
ffffffffc0200eb2:	6442                	ld	s0,16(sp)
ffffffffc0200eb4:	60e2                	ld	ra,24(sp)
ffffffffc0200eb6:	64a2                	ld	s1,8(sp)
ffffffffc0200eb8:	6902                	ld	s2,0(sp)
ffffffffc0200eba:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200ebc:	b59d                	j	ffffffffc0200d22 <exception_handler>
}
ffffffffc0200ebe:	6442                	ld	s0,16(sp)
ffffffffc0200ec0:	60e2                	ld	ra,24(sp)
ffffffffc0200ec2:	64a2                	ld	s1,8(sp)
ffffffffc0200ec4:	6902                	ld	s2,0(sp)
ffffffffc0200ec6:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200ec8:	b30d                	j	ffffffffc0200bea <interrupt_handler>
}
ffffffffc0200eca:	6442                	ld	s0,16(sp)
ffffffffc0200ecc:	60e2                	ld	ra,24(sp)
ffffffffc0200ece:	64a2                	ld	s1,8(sp)
ffffffffc0200ed0:	6902                	ld	s2,0(sp)
ffffffffc0200ed2:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200ed4:	3e90406f          	j	ffffffffc0205abc <schedule>
                do_exit(-E_KILLED);
ffffffffc0200ed8:	555d                	li	a0,-9
ffffffffc0200eda:	255030ef          	jal	ra,ffffffffc020492e <do_exit>
            if (current->need_resched)
ffffffffc0200ede:	601c                	ld	a5,0(s0)
ffffffffc0200ee0:	bf65                	j	ffffffffc0200e98 <trap+0x40>
	...

ffffffffc0200ee4 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200ee4:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200ee8:	00011463          	bnez	sp,ffffffffc0200ef0 <__alltraps+0xc>
ffffffffc0200eec:	14002173          	csrr	sp,sscratch
ffffffffc0200ef0:	712d                	addi	sp,sp,-288
ffffffffc0200ef2:	e002                	sd	zero,0(sp)
ffffffffc0200ef4:	e406                	sd	ra,8(sp)
ffffffffc0200ef6:	ec0e                	sd	gp,24(sp)
ffffffffc0200ef8:	f012                	sd	tp,32(sp)
ffffffffc0200efa:	f416                	sd	t0,40(sp)
ffffffffc0200efc:	f81a                	sd	t1,48(sp)
ffffffffc0200efe:	fc1e                	sd	t2,56(sp)
ffffffffc0200f00:	e0a2                	sd	s0,64(sp)
ffffffffc0200f02:	e4a6                	sd	s1,72(sp)
ffffffffc0200f04:	e8aa                	sd	a0,80(sp)
ffffffffc0200f06:	ecae                	sd	a1,88(sp)
ffffffffc0200f08:	f0b2                	sd	a2,96(sp)
ffffffffc0200f0a:	f4b6                	sd	a3,104(sp)
ffffffffc0200f0c:	f8ba                	sd	a4,112(sp)
ffffffffc0200f0e:	fcbe                	sd	a5,120(sp)
ffffffffc0200f10:	e142                	sd	a6,128(sp)
ffffffffc0200f12:	e546                	sd	a7,136(sp)
ffffffffc0200f14:	e94a                	sd	s2,144(sp)
ffffffffc0200f16:	ed4e                	sd	s3,152(sp)
ffffffffc0200f18:	f152                	sd	s4,160(sp)
ffffffffc0200f1a:	f556                	sd	s5,168(sp)
ffffffffc0200f1c:	f95a                	sd	s6,176(sp)
ffffffffc0200f1e:	fd5e                	sd	s7,184(sp)
ffffffffc0200f20:	e1e2                	sd	s8,192(sp)
ffffffffc0200f22:	e5e6                	sd	s9,200(sp)
ffffffffc0200f24:	e9ea                	sd	s10,208(sp)
ffffffffc0200f26:	edee                	sd	s11,216(sp)
ffffffffc0200f28:	f1f2                	sd	t3,224(sp)
ffffffffc0200f2a:	f5f6                	sd	t4,232(sp)
ffffffffc0200f2c:	f9fa                	sd	t5,240(sp)
ffffffffc0200f2e:	fdfe                	sd	t6,248(sp)
ffffffffc0200f30:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200f34:	100024f3          	csrr	s1,sstatus
ffffffffc0200f38:	14102973          	csrr	s2,sepc
ffffffffc0200f3c:	143029f3          	csrr	s3,stval
ffffffffc0200f40:	14202a73          	csrr	s4,scause
ffffffffc0200f44:	e822                	sd	s0,16(sp)
ffffffffc0200f46:	e226                	sd	s1,256(sp)
ffffffffc0200f48:	e64a                	sd	s2,264(sp)
ffffffffc0200f4a:	ea4e                	sd	s3,272(sp)
ffffffffc0200f4c:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200f4e:	850a                	mv	a0,sp
    jal trap
ffffffffc0200f50:	f09ff0ef          	jal	ra,ffffffffc0200e58 <trap>

ffffffffc0200f54 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200f54:	6492                	ld	s1,256(sp)
ffffffffc0200f56:	6932                	ld	s2,264(sp)
ffffffffc0200f58:	1004f413          	andi	s0,s1,256
ffffffffc0200f5c:	e401                	bnez	s0,ffffffffc0200f64 <__trapret+0x10>
ffffffffc0200f5e:	1200                	addi	s0,sp,288
ffffffffc0200f60:	14041073          	csrw	sscratch,s0
ffffffffc0200f64:	10049073          	csrw	sstatus,s1
ffffffffc0200f68:	14191073          	csrw	sepc,s2
ffffffffc0200f6c:	60a2                	ld	ra,8(sp)
ffffffffc0200f6e:	61e2                	ld	gp,24(sp)
ffffffffc0200f70:	7202                	ld	tp,32(sp)
ffffffffc0200f72:	72a2                	ld	t0,40(sp)
ffffffffc0200f74:	7342                	ld	t1,48(sp)
ffffffffc0200f76:	73e2                	ld	t2,56(sp)
ffffffffc0200f78:	6406                	ld	s0,64(sp)
ffffffffc0200f7a:	64a6                	ld	s1,72(sp)
ffffffffc0200f7c:	6546                	ld	a0,80(sp)
ffffffffc0200f7e:	65e6                	ld	a1,88(sp)
ffffffffc0200f80:	7606                	ld	a2,96(sp)
ffffffffc0200f82:	76a6                	ld	a3,104(sp)
ffffffffc0200f84:	7746                	ld	a4,112(sp)
ffffffffc0200f86:	77e6                	ld	a5,120(sp)
ffffffffc0200f88:	680a                	ld	a6,128(sp)
ffffffffc0200f8a:	68aa                	ld	a7,136(sp)
ffffffffc0200f8c:	694a                	ld	s2,144(sp)
ffffffffc0200f8e:	69ea                	ld	s3,152(sp)
ffffffffc0200f90:	7a0a                	ld	s4,160(sp)
ffffffffc0200f92:	7aaa                	ld	s5,168(sp)
ffffffffc0200f94:	7b4a                	ld	s6,176(sp)
ffffffffc0200f96:	7bea                	ld	s7,184(sp)
ffffffffc0200f98:	6c0e                	ld	s8,192(sp)
ffffffffc0200f9a:	6cae                	ld	s9,200(sp)
ffffffffc0200f9c:	6d4e                	ld	s10,208(sp)
ffffffffc0200f9e:	6dee                	ld	s11,216(sp)
ffffffffc0200fa0:	7e0e                	ld	t3,224(sp)
ffffffffc0200fa2:	7eae                	ld	t4,232(sp)
ffffffffc0200fa4:	7f4e                	ld	t5,240(sp)
ffffffffc0200fa6:	7fee                	ld	t6,248(sp)
ffffffffc0200fa8:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200faa:	10200073          	sret

ffffffffc0200fae <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200fae:	812a                	mv	sp,a0
ffffffffc0200fb0:	b755                	j	ffffffffc0200f54 <__trapret>

ffffffffc0200fb2 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200fb2:	00141797          	auipc	a5,0x141
ffffffffc0200fb6:	1be78793          	addi	a5,a5,446 # ffffffffc0342170 <free_area>
ffffffffc0200fba:	e79c                	sd	a5,8(a5)
ffffffffc0200fbc:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200fbe:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200fc2:	8082                	ret

ffffffffc0200fc4 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200fc4:	00141517          	auipc	a0,0x141
ffffffffc0200fc8:	1bc56503          	lwu	a0,444(a0) # ffffffffc0342180 <free_area+0x10>
ffffffffc0200fcc:	8082                	ret

ffffffffc0200fce <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0200fce:	715d                	addi	sp,sp,-80
ffffffffc0200fd0:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200fd2:	00141417          	auipc	s0,0x141
ffffffffc0200fd6:	19e40413          	addi	s0,s0,414 # ffffffffc0342170 <free_area>
ffffffffc0200fda:	641c                	ld	a5,8(s0)
ffffffffc0200fdc:	e486                	sd	ra,72(sp)
ffffffffc0200fde:	fc26                	sd	s1,56(sp)
ffffffffc0200fe0:	f84a                	sd	s2,48(sp)
ffffffffc0200fe2:	f44e                	sd	s3,40(sp)
ffffffffc0200fe4:	f052                	sd	s4,32(sp)
ffffffffc0200fe6:	ec56                	sd	s5,24(sp)
ffffffffc0200fe8:	e85a                	sd	s6,16(sp)
ffffffffc0200fea:	e45e                	sd	s7,8(sp)
ffffffffc0200fec:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0200fee:	2a878d63          	beq	a5,s0,ffffffffc02012a8 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0200ff2:	4481                	li	s1,0
ffffffffc0200ff4:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200ff6:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200ffa:	8b09                	andi	a4,a4,2
ffffffffc0200ffc:	2a070a63          	beqz	a4,ffffffffc02012b0 <default_check+0x2e2>
        count++, total += p->property;
ffffffffc0201000:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201004:	679c                	ld	a5,8(a5)
ffffffffc0201006:	2905                	addiw	s2,s2,1
ffffffffc0201008:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc020100a:	fe8796e3          	bne	a5,s0,ffffffffc0200ff6 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc020100e:	89a6                	mv	s3,s1
ffffffffc0201010:	7e1000ef          	jal	ra,ffffffffc0201ff0 <nr_free_pages>
ffffffffc0201014:	6f351e63          	bne	a0,s3,ffffffffc0201710 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201018:	4505                	li	a0,1
ffffffffc020101a:	759000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc020101e:	8aaa                	mv	s5,a0
ffffffffc0201020:	42050863          	beqz	a0,ffffffffc0201450 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201024:	4505                	li	a0,1
ffffffffc0201026:	74d000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc020102a:	89aa                	mv	s3,a0
ffffffffc020102c:	70050263          	beqz	a0,ffffffffc0201730 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201030:	4505                	li	a0,1
ffffffffc0201032:	741000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc0201036:	8a2a                	mv	s4,a0
ffffffffc0201038:	48050c63          	beqz	a0,ffffffffc02014d0 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020103c:	293a8a63          	beq	s5,s3,ffffffffc02012d0 <default_check+0x302>
ffffffffc0201040:	28aa8863          	beq	s5,a0,ffffffffc02012d0 <default_check+0x302>
ffffffffc0201044:	28a98663          	beq	s3,a0,ffffffffc02012d0 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201048:	000aa783          	lw	a5,0(s5)
ffffffffc020104c:	2a079263          	bnez	a5,ffffffffc02012f0 <default_check+0x322>
ffffffffc0201050:	0009a783          	lw	a5,0(s3)
ffffffffc0201054:	28079e63          	bnez	a5,ffffffffc02012f0 <default_check+0x322>
ffffffffc0201058:	411c                	lw	a5,0(a0)
ffffffffc020105a:	28079b63          	bnez	a5,ffffffffc02012f0 <default_check+0x322>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc020105e:	00145797          	auipc	a5,0x145
ffffffffc0201062:	1aa7b783          	ld	a5,426(a5) # ffffffffc0346208 <pages>
ffffffffc0201066:	40fa8733          	sub	a4,s5,a5
ffffffffc020106a:	00008617          	auipc	a2,0x8
ffffffffc020106e:	da663603          	ld	a2,-602(a2) # ffffffffc0208e10 <nbase>
ffffffffc0201072:	8719                	srai	a4,a4,0x6
ffffffffc0201074:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201076:	00145697          	auipc	a3,0x145
ffffffffc020107a:	18a6b683          	ld	a3,394(a3) # ffffffffc0346200 <npage>
ffffffffc020107e:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0201080:	0732                	slli	a4,a4,0xc
ffffffffc0201082:	28d77763          	bgeu	a4,a3,ffffffffc0201310 <default_check+0x342>
    return page - pages + nbase;
ffffffffc0201086:	40f98733          	sub	a4,s3,a5
ffffffffc020108a:	8719                	srai	a4,a4,0x6
ffffffffc020108c:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020108e:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201090:	4cd77063          	bgeu	a4,a3,ffffffffc0201550 <default_check+0x582>
    return page - pages + nbase;
ffffffffc0201094:	40f507b3          	sub	a5,a0,a5
ffffffffc0201098:	8799                	srai	a5,a5,0x6
ffffffffc020109a:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020109c:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020109e:	30d7f963          	bgeu	a5,a3,ffffffffc02013b0 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc02010a2:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02010a4:	00043c03          	ld	s8,0(s0)
ffffffffc02010a8:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc02010ac:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc02010b0:	e400                	sd	s0,8(s0)
ffffffffc02010b2:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc02010b4:	00141797          	auipc	a5,0x141
ffffffffc02010b8:	0c07a623          	sw	zero,204(a5) # ffffffffc0342180 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc02010bc:	6b7000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc02010c0:	2c051863          	bnez	a0,ffffffffc0201390 <default_check+0x3c2>
    free_page(p0);
ffffffffc02010c4:	4585                	li	a1,1
ffffffffc02010c6:	8556                	mv	a0,s5
ffffffffc02010c8:	6e9000ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    free_page(p1);
ffffffffc02010cc:	4585                	li	a1,1
ffffffffc02010ce:	854e                	mv	a0,s3
ffffffffc02010d0:	6e1000ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    free_page(p2);
ffffffffc02010d4:	4585                	li	a1,1
ffffffffc02010d6:	8552                	mv	a0,s4
ffffffffc02010d8:	6d9000ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    assert(nr_free == 3);
ffffffffc02010dc:	4818                	lw	a4,16(s0)
ffffffffc02010de:	478d                	li	a5,3
ffffffffc02010e0:	28f71863          	bne	a4,a5,ffffffffc0201370 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02010e4:	4505                	li	a0,1
ffffffffc02010e6:	68d000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc02010ea:	89aa                	mv	s3,a0
ffffffffc02010ec:	26050263          	beqz	a0,ffffffffc0201350 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02010f0:	4505                	li	a0,1
ffffffffc02010f2:	681000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc02010f6:	8aaa                	mv	s5,a0
ffffffffc02010f8:	3a050c63          	beqz	a0,ffffffffc02014b0 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02010fc:	4505                	li	a0,1
ffffffffc02010fe:	675000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc0201102:	8a2a                	mv	s4,a0
ffffffffc0201104:	38050663          	beqz	a0,ffffffffc0201490 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0201108:	4505                	li	a0,1
ffffffffc020110a:	669000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc020110e:	36051163          	bnez	a0,ffffffffc0201470 <default_check+0x4a2>
    free_page(p0);
ffffffffc0201112:	4585                	li	a1,1
ffffffffc0201114:	854e                	mv	a0,s3
ffffffffc0201116:	69b000ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc020111a:	641c                	ld	a5,8(s0)
ffffffffc020111c:	20878a63          	beq	a5,s0,ffffffffc0201330 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0201120:	4505                	li	a0,1
ffffffffc0201122:	651000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc0201126:	30a99563          	bne	s3,a0,ffffffffc0201430 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc020112a:	4505                	li	a0,1
ffffffffc020112c:	647000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc0201130:	2e051063          	bnez	a0,ffffffffc0201410 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0201134:	481c                	lw	a5,16(s0)
ffffffffc0201136:	2a079d63          	bnez	a5,ffffffffc02013f0 <default_check+0x422>
    free_page(p);
ffffffffc020113a:	854e                	mv	a0,s3
ffffffffc020113c:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc020113e:	01843023          	sd	s8,0(s0)
ffffffffc0201142:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0201146:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc020114a:	667000ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    free_page(p1);
ffffffffc020114e:	4585                	li	a1,1
ffffffffc0201150:	8556                	mv	a0,s5
ffffffffc0201152:	65f000ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    free_page(p2);
ffffffffc0201156:	4585                	li	a1,1
ffffffffc0201158:	8552                	mv	a0,s4
ffffffffc020115a:	657000ef          	jal	ra,ffffffffc0201fb0 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc020115e:	4515                	li	a0,5
ffffffffc0201160:	613000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc0201164:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0201166:	26050563          	beqz	a0,ffffffffc02013d0 <default_check+0x402>
ffffffffc020116a:	651c                	ld	a5,8(a0)
ffffffffc020116c:	8385                	srli	a5,a5,0x1
ffffffffc020116e:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc0201170:	54079063          	bnez	a5,ffffffffc02016b0 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201174:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201176:	00043b03          	ld	s6,0(s0)
ffffffffc020117a:	00843a83          	ld	s5,8(s0)
ffffffffc020117e:	e000                	sd	s0,0(s0)
ffffffffc0201180:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0201182:	5f1000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc0201186:	50051563          	bnez	a0,ffffffffc0201690 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc020118a:	08098a13          	addi	s4,s3,128
ffffffffc020118e:	8552                	mv	a0,s4
ffffffffc0201190:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201192:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0201196:	00141797          	auipc	a5,0x141
ffffffffc020119a:	fe07a523          	sw	zero,-22(a5) # ffffffffc0342180 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc020119e:	613000ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02011a2:	4511                	li	a0,4
ffffffffc02011a4:	5cf000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc02011a8:	4c051463          	bnez	a0,ffffffffc0201670 <default_check+0x6a2>
ffffffffc02011ac:	0889b783          	ld	a5,136(s3)
ffffffffc02011b0:	8385                	srli	a5,a5,0x1
ffffffffc02011b2:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02011b4:	48078e63          	beqz	a5,ffffffffc0201650 <default_check+0x682>
ffffffffc02011b8:	0909a703          	lw	a4,144(s3)
ffffffffc02011bc:	478d                	li	a5,3
ffffffffc02011be:	48f71963          	bne	a4,a5,ffffffffc0201650 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02011c2:	450d                	li	a0,3
ffffffffc02011c4:	5af000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc02011c8:	8c2a                	mv	s8,a0
ffffffffc02011ca:	46050363          	beqz	a0,ffffffffc0201630 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc02011ce:	4505                	li	a0,1
ffffffffc02011d0:	5a3000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc02011d4:	42051e63          	bnez	a0,ffffffffc0201610 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc02011d8:	418a1c63          	bne	s4,s8,ffffffffc02015f0 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02011dc:	4585                	li	a1,1
ffffffffc02011de:	854e                	mv	a0,s3
ffffffffc02011e0:	5d1000ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    free_pages(p1, 3);
ffffffffc02011e4:	458d                	li	a1,3
ffffffffc02011e6:	8552                	mv	a0,s4
ffffffffc02011e8:	5c9000ef          	jal	ra,ffffffffc0201fb0 <free_pages>
ffffffffc02011ec:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc02011f0:	04098c13          	addi	s8,s3,64
ffffffffc02011f4:	8385                	srli	a5,a5,0x1
ffffffffc02011f6:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02011f8:	3c078c63          	beqz	a5,ffffffffc02015d0 <default_check+0x602>
ffffffffc02011fc:	0109a703          	lw	a4,16(s3)
ffffffffc0201200:	4785                	li	a5,1
ffffffffc0201202:	3cf71763          	bne	a4,a5,ffffffffc02015d0 <default_check+0x602>
ffffffffc0201206:	008a3783          	ld	a5,8(s4)
ffffffffc020120a:	8385                	srli	a5,a5,0x1
ffffffffc020120c:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc020120e:	3a078163          	beqz	a5,ffffffffc02015b0 <default_check+0x5e2>
ffffffffc0201212:	010a2703          	lw	a4,16(s4)
ffffffffc0201216:	478d                	li	a5,3
ffffffffc0201218:	38f71c63          	bne	a4,a5,ffffffffc02015b0 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc020121c:	4505                	li	a0,1
ffffffffc020121e:	555000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc0201222:	36a99763          	bne	s3,a0,ffffffffc0201590 <default_check+0x5c2>
    free_page(p0);
ffffffffc0201226:	4585                	li	a1,1
ffffffffc0201228:	589000ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc020122c:	4509                	li	a0,2
ffffffffc020122e:	545000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc0201232:	32aa1f63          	bne	s4,a0,ffffffffc0201570 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc0201236:	4589                	li	a1,2
ffffffffc0201238:	579000ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    free_page(p2);
ffffffffc020123c:	4585                	li	a1,1
ffffffffc020123e:	8562                	mv	a0,s8
ffffffffc0201240:	571000ef          	jal	ra,ffffffffc0201fb0 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201244:	4515                	li	a0,5
ffffffffc0201246:	52d000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc020124a:	89aa                	mv	s3,a0
ffffffffc020124c:	48050263          	beqz	a0,ffffffffc02016d0 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0201250:	4505                	li	a0,1
ffffffffc0201252:	521000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc0201256:	2c051d63          	bnez	a0,ffffffffc0201530 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc020125a:	481c                	lw	a5,16(s0)
ffffffffc020125c:	2a079a63          	bnez	a5,ffffffffc0201510 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201260:	4595                	li	a1,5
ffffffffc0201262:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201264:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201268:	01643023          	sd	s6,0(s0)
ffffffffc020126c:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201270:	541000ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    return listelm->next;
ffffffffc0201274:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201276:	00878963          	beq	a5,s0,ffffffffc0201288 <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc020127a:	ff87a703          	lw	a4,-8(a5)
ffffffffc020127e:	679c                	ld	a5,8(a5)
ffffffffc0201280:	397d                	addiw	s2,s2,-1
ffffffffc0201282:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201284:	fe879be3          	bne	a5,s0,ffffffffc020127a <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc0201288:	26091463          	bnez	s2,ffffffffc02014f0 <default_check+0x522>
    assert(total == 0);
ffffffffc020128c:	46049263          	bnez	s1,ffffffffc02016f0 <default_check+0x722>
}
ffffffffc0201290:	60a6                	ld	ra,72(sp)
ffffffffc0201292:	6406                	ld	s0,64(sp)
ffffffffc0201294:	74e2                	ld	s1,56(sp)
ffffffffc0201296:	7942                	ld	s2,48(sp)
ffffffffc0201298:	79a2                	ld	s3,40(sp)
ffffffffc020129a:	7a02                	ld	s4,32(sp)
ffffffffc020129c:	6ae2                	ld	s5,24(sp)
ffffffffc020129e:	6b42                	ld	s6,16(sp)
ffffffffc02012a0:	6ba2                	ld	s7,8(sp)
ffffffffc02012a2:	6c02                	ld	s8,0(sp)
ffffffffc02012a4:	6161                	addi	sp,sp,80
ffffffffc02012a6:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc02012a8:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02012aa:	4481                	li	s1,0
ffffffffc02012ac:	4901                	li	s2,0
ffffffffc02012ae:	b38d                	j	ffffffffc0201010 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc02012b0:	00006697          	auipc	a3,0x6
ffffffffc02012b4:	cf868693          	addi	a3,a3,-776 # ffffffffc0206fa8 <commands+0x840>
ffffffffc02012b8:	00006617          	auipc	a2,0x6
ffffffffc02012bc:	d0060613          	addi	a2,a2,-768 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02012c0:	11000593          	li	a1,272
ffffffffc02012c4:	00006517          	auipc	a0,0x6
ffffffffc02012c8:	d0c50513          	addi	a0,a0,-756 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02012cc:	9acff0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02012d0:	00006697          	auipc	a3,0x6
ffffffffc02012d4:	d9868693          	addi	a3,a3,-616 # ffffffffc0207068 <commands+0x900>
ffffffffc02012d8:	00006617          	auipc	a2,0x6
ffffffffc02012dc:	ce060613          	addi	a2,a2,-800 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02012e0:	0db00593          	li	a1,219
ffffffffc02012e4:	00006517          	auipc	a0,0x6
ffffffffc02012e8:	cec50513          	addi	a0,a0,-788 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02012ec:	98cff0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02012f0:	00006697          	auipc	a3,0x6
ffffffffc02012f4:	da068693          	addi	a3,a3,-608 # ffffffffc0207090 <commands+0x928>
ffffffffc02012f8:	00006617          	auipc	a2,0x6
ffffffffc02012fc:	cc060613          	addi	a2,a2,-832 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201300:	0dc00593          	li	a1,220
ffffffffc0201304:	00006517          	auipc	a0,0x6
ffffffffc0201308:	ccc50513          	addi	a0,a0,-820 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020130c:	96cff0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201310:	00006697          	auipc	a3,0x6
ffffffffc0201314:	dc068693          	addi	a3,a3,-576 # ffffffffc02070d0 <commands+0x968>
ffffffffc0201318:	00006617          	auipc	a2,0x6
ffffffffc020131c:	ca060613          	addi	a2,a2,-864 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201320:	0de00593          	li	a1,222
ffffffffc0201324:	00006517          	auipc	a0,0x6
ffffffffc0201328:	cac50513          	addi	a0,a0,-852 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020132c:	94cff0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201330:	00006697          	auipc	a3,0x6
ffffffffc0201334:	e2868693          	addi	a3,a3,-472 # ffffffffc0207158 <commands+0x9f0>
ffffffffc0201338:	00006617          	auipc	a2,0x6
ffffffffc020133c:	c8060613          	addi	a2,a2,-896 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201340:	0f700593          	li	a1,247
ffffffffc0201344:	00006517          	auipc	a0,0x6
ffffffffc0201348:	c8c50513          	addi	a0,a0,-884 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020134c:	92cff0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201350:	00006697          	auipc	a3,0x6
ffffffffc0201354:	cb868693          	addi	a3,a3,-840 # ffffffffc0207008 <commands+0x8a0>
ffffffffc0201358:	00006617          	auipc	a2,0x6
ffffffffc020135c:	c6060613          	addi	a2,a2,-928 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201360:	0f000593          	li	a1,240
ffffffffc0201364:	00006517          	auipc	a0,0x6
ffffffffc0201368:	c6c50513          	addi	a0,a0,-916 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020136c:	90cff0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(nr_free == 3);
ffffffffc0201370:	00006697          	auipc	a3,0x6
ffffffffc0201374:	dd868693          	addi	a3,a3,-552 # ffffffffc0207148 <commands+0x9e0>
ffffffffc0201378:	00006617          	auipc	a2,0x6
ffffffffc020137c:	c4060613          	addi	a2,a2,-960 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201380:	0ee00593          	li	a1,238
ffffffffc0201384:	00006517          	auipc	a0,0x6
ffffffffc0201388:	c4c50513          	addi	a0,a0,-948 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020138c:	8ecff0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201390:	00006697          	auipc	a3,0x6
ffffffffc0201394:	da068693          	addi	a3,a3,-608 # ffffffffc0207130 <commands+0x9c8>
ffffffffc0201398:	00006617          	auipc	a2,0x6
ffffffffc020139c:	c2060613          	addi	a2,a2,-992 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02013a0:	0e900593          	li	a1,233
ffffffffc02013a4:	00006517          	auipc	a0,0x6
ffffffffc02013a8:	c2c50513          	addi	a0,a0,-980 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02013ac:	8ccff0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02013b0:	00006697          	auipc	a3,0x6
ffffffffc02013b4:	d6068693          	addi	a3,a3,-672 # ffffffffc0207110 <commands+0x9a8>
ffffffffc02013b8:	00006617          	auipc	a2,0x6
ffffffffc02013bc:	c0060613          	addi	a2,a2,-1024 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02013c0:	0e000593          	li	a1,224
ffffffffc02013c4:	00006517          	auipc	a0,0x6
ffffffffc02013c8:	c0c50513          	addi	a0,a0,-1012 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02013cc:	8acff0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(p0 != NULL);
ffffffffc02013d0:	00006697          	auipc	a3,0x6
ffffffffc02013d4:	dd068693          	addi	a3,a3,-560 # ffffffffc02071a0 <commands+0xa38>
ffffffffc02013d8:	00006617          	auipc	a2,0x6
ffffffffc02013dc:	be060613          	addi	a2,a2,-1056 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02013e0:	11800593          	li	a1,280
ffffffffc02013e4:	00006517          	auipc	a0,0x6
ffffffffc02013e8:	bec50513          	addi	a0,a0,-1044 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02013ec:	88cff0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(nr_free == 0);
ffffffffc02013f0:	00006697          	auipc	a3,0x6
ffffffffc02013f4:	da068693          	addi	a3,a3,-608 # ffffffffc0207190 <commands+0xa28>
ffffffffc02013f8:	00006617          	auipc	a2,0x6
ffffffffc02013fc:	bc060613          	addi	a2,a2,-1088 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201400:	0fd00593          	li	a1,253
ffffffffc0201404:	00006517          	auipc	a0,0x6
ffffffffc0201408:	bcc50513          	addi	a0,a0,-1076 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020140c:	86cff0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201410:	00006697          	auipc	a3,0x6
ffffffffc0201414:	d2068693          	addi	a3,a3,-736 # ffffffffc0207130 <commands+0x9c8>
ffffffffc0201418:	00006617          	auipc	a2,0x6
ffffffffc020141c:	ba060613          	addi	a2,a2,-1120 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201420:	0fb00593          	li	a1,251
ffffffffc0201424:	00006517          	auipc	a0,0x6
ffffffffc0201428:	bac50513          	addi	a0,a0,-1108 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020142c:	84cff0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201430:	00006697          	auipc	a3,0x6
ffffffffc0201434:	d4068693          	addi	a3,a3,-704 # ffffffffc0207170 <commands+0xa08>
ffffffffc0201438:	00006617          	auipc	a2,0x6
ffffffffc020143c:	b8060613          	addi	a2,a2,-1152 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201440:	0fa00593          	li	a1,250
ffffffffc0201444:	00006517          	auipc	a0,0x6
ffffffffc0201448:	b8c50513          	addi	a0,a0,-1140 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020144c:	82cff0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201450:	00006697          	auipc	a3,0x6
ffffffffc0201454:	bb868693          	addi	a3,a3,-1096 # ffffffffc0207008 <commands+0x8a0>
ffffffffc0201458:	00006617          	auipc	a2,0x6
ffffffffc020145c:	b6060613          	addi	a2,a2,-1184 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201460:	0d700593          	li	a1,215
ffffffffc0201464:	00006517          	auipc	a0,0x6
ffffffffc0201468:	b6c50513          	addi	a0,a0,-1172 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020146c:	80cff0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201470:	00006697          	auipc	a3,0x6
ffffffffc0201474:	cc068693          	addi	a3,a3,-832 # ffffffffc0207130 <commands+0x9c8>
ffffffffc0201478:	00006617          	auipc	a2,0x6
ffffffffc020147c:	b4060613          	addi	a2,a2,-1216 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201480:	0f400593          	li	a1,244
ffffffffc0201484:	00006517          	auipc	a0,0x6
ffffffffc0201488:	b4c50513          	addi	a0,a0,-1204 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020148c:	fedfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201490:	00006697          	auipc	a3,0x6
ffffffffc0201494:	bb868693          	addi	a3,a3,-1096 # ffffffffc0207048 <commands+0x8e0>
ffffffffc0201498:	00006617          	auipc	a2,0x6
ffffffffc020149c:	b2060613          	addi	a2,a2,-1248 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02014a0:	0f200593          	li	a1,242
ffffffffc02014a4:	00006517          	auipc	a0,0x6
ffffffffc02014a8:	b2c50513          	addi	a0,a0,-1236 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02014ac:	fcdfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02014b0:	00006697          	auipc	a3,0x6
ffffffffc02014b4:	b7868693          	addi	a3,a3,-1160 # ffffffffc0207028 <commands+0x8c0>
ffffffffc02014b8:	00006617          	auipc	a2,0x6
ffffffffc02014bc:	b0060613          	addi	a2,a2,-1280 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02014c0:	0f100593          	li	a1,241
ffffffffc02014c4:	00006517          	auipc	a0,0x6
ffffffffc02014c8:	b0c50513          	addi	a0,a0,-1268 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02014cc:	fadfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014d0:	00006697          	auipc	a3,0x6
ffffffffc02014d4:	b7868693          	addi	a3,a3,-1160 # ffffffffc0207048 <commands+0x8e0>
ffffffffc02014d8:	00006617          	auipc	a2,0x6
ffffffffc02014dc:	ae060613          	addi	a2,a2,-1312 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02014e0:	0d900593          	li	a1,217
ffffffffc02014e4:	00006517          	auipc	a0,0x6
ffffffffc02014e8:	aec50513          	addi	a0,a0,-1300 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02014ec:	f8dfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(count == 0);
ffffffffc02014f0:	00006697          	auipc	a3,0x6
ffffffffc02014f4:	e0068693          	addi	a3,a3,-512 # ffffffffc02072f0 <commands+0xb88>
ffffffffc02014f8:	00006617          	auipc	a2,0x6
ffffffffc02014fc:	ac060613          	addi	a2,a2,-1344 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201500:	14600593          	li	a1,326
ffffffffc0201504:	00006517          	auipc	a0,0x6
ffffffffc0201508:	acc50513          	addi	a0,a0,-1332 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020150c:	f6dfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(nr_free == 0);
ffffffffc0201510:	00006697          	auipc	a3,0x6
ffffffffc0201514:	c8068693          	addi	a3,a3,-896 # ffffffffc0207190 <commands+0xa28>
ffffffffc0201518:	00006617          	auipc	a2,0x6
ffffffffc020151c:	aa060613          	addi	a2,a2,-1376 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201520:	13a00593          	li	a1,314
ffffffffc0201524:	00006517          	auipc	a0,0x6
ffffffffc0201528:	aac50513          	addi	a0,a0,-1364 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020152c:	f4dfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201530:	00006697          	auipc	a3,0x6
ffffffffc0201534:	c0068693          	addi	a3,a3,-1024 # ffffffffc0207130 <commands+0x9c8>
ffffffffc0201538:	00006617          	auipc	a2,0x6
ffffffffc020153c:	a8060613          	addi	a2,a2,-1408 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201540:	13800593          	li	a1,312
ffffffffc0201544:	00006517          	auipc	a0,0x6
ffffffffc0201548:	a8c50513          	addi	a0,a0,-1396 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020154c:	f2dfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201550:	00006697          	auipc	a3,0x6
ffffffffc0201554:	ba068693          	addi	a3,a3,-1120 # ffffffffc02070f0 <commands+0x988>
ffffffffc0201558:	00006617          	auipc	a2,0x6
ffffffffc020155c:	a6060613          	addi	a2,a2,-1440 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201560:	0df00593          	li	a1,223
ffffffffc0201564:	00006517          	auipc	a0,0x6
ffffffffc0201568:	a6c50513          	addi	a0,a0,-1428 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020156c:	f0dfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201570:	00006697          	auipc	a3,0x6
ffffffffc0201574:	d4068693          	addi	a3,a3,-704 # ffffffffc02072b0 <commands+0xb48>
ffffffffc0201578:	00006617          	auipc	a2,0x6
ffffffffc020157c:	a4060613          	addi	a2,a2,-1472 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201580:	13200593          	li	a1,306
ffffffffc0201584:	00006517          	auipc	a0,0x6
ffffffffc0201588:	a4c50513          	addi	a0,a0,-1460 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020158c:	eedfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201590:	00006697          	auipc	a3,0x6
ffffffffc0201594:	d0068693          	addi	a3,a3,-768 # ffffffffc0207290 <commands+0xb28>
ffffffffc0201598:	00006617          	auipc	a2,0x6
ffffffffc020159c:	a2060613          	addi	a2,a2,-1504 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02015a0:	13000593          	li	a1,304
ffffffffc02015a4:	00006517          	auipc	a0,0x6
ffffffffc02015a8:	a2c50513          	addi	a0,a0,-1492 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02015ac:	ecdfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02015b0:	00006697          	auipc	a3,0x6
ffffffffc02015b4:	cb868693          	addi	a3,a3,-840 # ffffffffc0207268 <commands+0xb00>
ffffffffc02015b8:	00006617          	auipc	a2,0x6
ffffffffc02015bc:	a0060613          	addi	a2,a2,-1536 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02015c0:	12e00593          	li	a1,302
ffffffffc02015c4:	00006517          	auipc	a0,0x6
ffffffffc02015c8:	a0c50513          	addi	a0,a0,-1524 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02015cc:	eadfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02015d0:	00006697          	auipc	a3,0x6
ffffffffc02015d4:	c7068693          	addi	a3,a3,-912 # ffffffffc0207240 <commands+0xad8>
ffffffffc02015d8:	00006617          	auipc	a2,0x6
ffffffffc02015dc:	9e060613          	addi	a2,a2,-1568 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02015e0:	12d00593          	li	a1,301
ffffffffc02015e4:	00006517          	auipc	a0,0x6
ffffffffc02015e8:	9ec50513          	addi	a0,a0,-1556 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02015ec:	e8dfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(p0 + 2 == p1);
ffffffffc02015f0:	00006697          	auipc	a3,0x6
ffffffffc02015f4:	c4068693          	addi	a3,a3,-960 # ffffffffc0207230 <commands+0xac8>
ffffffffc02015f8:	00006617          	auipc	a2,0x6
ffffffffc02015fc:	9c060613          	addi	a2,a2,-1600 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201600:	12800593          	li	a1,296
ffffffffc0201604:	00006517          	auipc	a0,0x6
ffffffffc0201608:	9cc50513          	addi	a0,a0,-1588 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020160c:	e6dfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201610:	00006697          	auipc	a3,0x6
ffffffffc0201614:	b2068693          	addi	a3,a3,-1248 # ffffffffc0207130 <commands+0x9c8>
ffffffffc0201618:	00006617          	auipc	a2,0x6
ffffffffc020161c:	9a060613          	addi	a2,a2,-1632 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201620:	12700593          	li	a1,295
ffffffffc0201624:	00006517          	auipc	a0,0x6
ffffffffc0201628:	9ac50513          	addi	a0,a0,-1620 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020162c:	e4dfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201630:	00006697          	auipc	a3,0x6
ffffffffc0201634:	be068693          	addi	a3,a3,-1056 # ffffffffc0207210 <commands+0xaa8>
ffffffffc0201638:	00006617          	auipc	a2,0x6
ffffffffc020163c:	98060613          	addi	a2,a2,-1664 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201640:	12600593          	li	a1,294
ffffffffc0201644:	00006517          	auipc	a0,0x6
ffffffffc0201648:	98c50513          	addi	a0,a0,-1652 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020164c:	e2dfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201650:	00006697          	auipc	a3,0x6
ffffffffc0201654:	b9068693          	addi	a3,a3,-1136 # ffffffffc02071e0 <commands+0xa78>
ffffffffc0201658:	00006617          	auipc	a2,0x6
ffffffffc020165c:	96060613          	addi	a2,a2,-1696 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201660:	12500593          	li	a1,293
ffffffffc0201664:	00006517          	auipc	a0,0x6
ffffffffc0201668:	96c50513          	addi	a0,a0,-1684 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020166c:	e0dfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201670:	00006697          	auipc	a3,0x6
ffffffffc0201674:	b5868693          	addi	a3,a3,-1192 # ffffffffc02071c8 <commands+0xa60>
ffffffffc0201678:	00006617          	auipc	a2,0x6
ffffffffc020167c:	94060613          	addi	a2,a2,-1728 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201680:	12400593          	li	a1,292
ffffffffc0201684:	00006517          	auipc	a0,0x6
ffffffffc0201688:	94c50513          	addi	a0,a0,-1716 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020168c:	dedfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201690:	00006697          	auipc	a3,0x6
ffffffffc0201694:	aa068693          	addi	a3,a3,-1376 # ffffffffc0207130 <commands+0x9c8>
ffffffffc0201698:	00006617          	auipc	a2,0x6
ffffffffc020169c:	92060613          	addi	a2,a2,-1760 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02016a0:	11e00593          	li	a1,286
ffffffffc02016a4:	00006517          	auipc	a0,0x6
ffffffffc02016a8:	92c50513          	addi	a0,a0,-1748 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02016ac:	dcdfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(!PageProperty(p0));
ffffffffc02016b0:	00006697          	auipc	a3,0x6
ffffffffc02016b4:	b0068693          	addi	a3,a3,-1280 # ffffffffc02071b0 <commands+0xa48>
ffffffffc02016b8:	00006617          	auipc	a2,0x6
ffffffffc02016bc:	90060613          	addi	a2,a2,-1792 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02016c0:	11900593          	li	a1,281
ffffffffc02016c4:	00006517          	auipc	a0,0x6
ffffffffc02016c8:	90c50513          	addi	a0,a0,-1780 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02016cc:	dadfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02016d0:	00006697          	auipc	a3,0x6
ffffffffc02016d4:	c0068693          	addi	a3,a3,-1024 # ffffffffc02072d0 <commands+0xb68>
ffffffffc02016d8:	00006617          	auipc	a2,0x6
ffffffffc02016dc:	8e060613          	addi	a2,a2,-1824 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02016e0:	13700593          	li	a1,311
ffffffffc02016e4:	00006517          	auipc	a0,0x6
ffffffffc02016e8:	8ec50513          	addi	a0,a0,-1812 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02016ec:	d8dfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(total == 0);
ffffffffc02016f0:	00006697          	auipc	a3,0x6
ffffffffc02016f4:	c1068693          	addi	a3,a3,-1008 # ffffffffc0207300 <commands+0xb98>
ffffffffc02016f8:	00006617          	auipc	a2,0x6
ffffffffc02016fc:	8c060613          	addi	a2,a2,-1856 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201700:	14700593          	li	a1,327
ffffffffc0201704:	00006517          	auipc	a0,0x6
ffffffffc0201708:	8cc50513          	addi	a0,a0,-1844 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020170c:	d6dfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(total == nr_free_pages());
ffffffffc0201710:	00006697          	auipc	a3,0x6
ffffffffc0201714:	8d868693          	addi	a3,a3,-1832 # ffffffffc0206fe8 <commands+0x880>
ffffffffc0201718:	00006617          	auipc	a2,0x6
ffffffffc020171c:	8a060613          	addi	a2,a2,-1888 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201720:	11300593          	li	a1,275
ffffffffc0201724:	00006517          	auipc	a0,0x6
ffffffffc0201728:	8ac50513          	addi	a0,a0,-1876 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020172c:	d4dfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201730:	00006697          	auipc	a3,0x6
ffffffffc0201734:	8f868693          	addi	a3,a3,-1800 # ffffffffc0207028 <commands+0x8c0>
ffffffffc0201738:	00006617          	auipc	a2,0x6
ffffffffc020173c:	88060613          	addi	a2,a2,-1920 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201740:	0d800593          	li	a1,216
ffffffffc0201744:	00006517          	auipc	a0,0x6
ffffffffc0201748:	88c50513          	addi	a0,a0,-1908 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020174c:	d2dfe0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0201750 <default_free_pages>:
{
ffffffffc0201750:	1141                	addi	sp,sp,-16
ffffffffc0201752:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201754:	14058563          	beqz	a1,ffffffffc020189e <default_free_pages+0x14e>
    for (; p != base + n; p++)
ffffffffc0201758:	00659693          	slli	a3,a1,0x6
ffffffffc020175c:	96aa                	add	a3,a3,a0
ffffffffc020175e:	87aa                	mv	a5,a0
ffffffffc0201760:	02d50263          	beq	a0,a3,ffffffffc0201784 <default_free_pages+0x34>
ffffffffc0201764:	6798                	ld	a4,8(a5)
ffffffffc0201766:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201768:	10071b63          	bnez	a4,ffffffffc020187e <default_free_pages+0x12e>
ffffffffc020176c:	6798                	ld	a4,8(a5)
ffffffffc020176e:	8b09                	andi	a4,a4,2
ffffffffc0201770:	10071763          	bnez	a4,ffffffffc020187e <default_free_pages+0x12e>
        p->flags = 0;
ffffffffc0201774:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0201778:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc020177c:	04078793          	addi	a5,a5,64
ffffffffc0201780:	fed792e3          	bne	a5,a3,ffffffffc0201764 <default_free_pages+0x14>
    base->property = n;
ffffffffc0201784:	2581                	sext.w	a1,a1
ffffffffc0201786:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201788:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020178c:	4789                	li	a5,2
ffffffffc020178e:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201792:	00141697          	auipc	a3,0x141
ffffffffc0201796:	9de68693          	addi	a3,a3,-1570 # ffffffffc0342170 <free_area>
ffffffffc020179a:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020179c:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc020179e:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02017a2:	9db9                	addw	a1,a1,a4
ffffffffc02017a4:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02017a6:	0ad78563          	beq	a5,a3,ffffffffc0201850 <default_free_pages+0x100>
            struct Page *page = le2page(le, page_link);
ffffffffc02017aa:	fe878713          	addi	a4,a5,-24
ffffffffc02017ae:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02017b2:	4581                	li	a1,0
            if (base < page)
ffffffffc02017b4:	00e56a63          	bltu	a0,a4,ffffffffc02017c8 <default_free_pages+0x78>
    return listelm->next;
ffffffffc02017b8:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02017ba:	04d70b63          	beq	a4,a3,ffffffffc0201810 <default_free_pages+0xc0>
    for (; p != base + n; p++)
ffffffffc02017be:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02017c0:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02017c4:	fee57ae3          	bgeu	a0,a4,ffffffffc02017b8 <default_free_pages+0x68>
ffffffffc02017c8:	c199                	beqz	a1,ffffffffc02017ce <default_free_pages+0x7e>
ffffffffc02017ca:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02017ce:	638c                	ld	a1,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02017d0:	e390                	sd	a2,0(a5)
ffffffffc02017d2:	e590                	sd	a2,8(a1)
    elm->next = next;
ffffffffc02017d4:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02017d6:	ed0c                	sd	a1,24(a0)
    if (le != &free_list)
ffffffffc02017d8:	02d58163          	beq	a1,a3,ffffffffc02017fa <default_free_pages+0xaa>
        if (p + p->property == base)
ffffffffc02017dc:	ff85a803          	lw	a6,-8(a1)
        p = le2page(le, page_link);
ffffffffc02017e0:	fe858613          	addi	a2,a1,-24
        if (p + p->property == base)
ffffffffc02017e4:	02081313          	slli	t1,a6,0x20
ffffffffc02017e8:	01a35713          	srli	a4,t1,0x1a
ffffffffc02017ec:	9732                	add	a4,a4,a2
ffffffffc02017ee:	02e50b63          	beq	a0,a4,ffffffffc0201824 <default_free_pages+0xd4>
    if (le != &free_list)
ffffffffc02017f2:	00d78c63          	beq	a5,a3,ffffffffc020180a <default_free_pages+0xba>
ffffffffc02017f6:	fe878713          	addi	a4,a5,-24
        if (base + base->property == p)
ffffffffc02017fa:	4910                	lw	a2,16(a0)
ffffffffc02017fc:	02061593          	slli	a1,a2,0x20
ffffffffc0201800:	01a5d693          	srli	a3,a1,0x1a
ffffffffc0201804:	96aa                	add	a3,a3,a0
ffffffffc0201806:	04d70c63          	beq	a4,a3,ffffffffc020185e <default_free_pages+0x10e>
}
ffffffffc020180a:	60a2                	ld	ra,8(sp)
ffffffffc020180c:	0141                	addi	sp,sp,16
ffffffffc020180e:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201810:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201812:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201814:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201816:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201818:	02d70863          	beq	a4,a3,ffffffffc0201848 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc020181c:	8832                	mv	a6,a2
ffffffffc020181e:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201820:	87ba                	mv	a5,a4
ffffffffc0201822:	bf79                	j	ffffffffc02017c0 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0201824:	491c                	lw	a5,16(a0)
ffffffffc0201826:	0107883b          	addw	a6,a5,a6
ffffffffc020182a:	ff05ac23          	sw	a6,-8(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020182e:	57f5                	li	a5,-3
ffffffffc0201830:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201834:	01853803          	ld	a6,24(a0)
ffffffffc0201838:	7118                	ld	a4,32(a0)
            base = p;
ffffffffc020183a:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc020183c:	00e83423          	sd	a4,8(a6)
    return listelm->next;
ffffffffc0201840:	659c                	ld	a5,8(a1)
    next->prev = prev;
ffffffffc0201842:	01073023          	sd	a6,0(a4)
ffffffffc0201846:	b775                	j	ffffffffc02017f2 <default_free_pages+0xa2>
        while ((le = list_next(le)) != &free_list)
ffffffffc0201848:	85be                	mv	a1,a5
ffffffffc020184a:	e290                	sd	a2,0(a3)
ffffffffc020184c:	87b6                	mv	a5,a3
ffffffffc020184e:	b779                	j	ffffffffc02017dc <default_free_pages+0x8c>
}
ffffffffc0201850:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201852:	e390                	sd	a2,0(a5)
ffffffffc0201854:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201856:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201858:	ed1c                	sd	a5,24(a0)
ffffffffc020185a:	0141                	addi	sp,sp,16
ffffffffc020185c:	8082                	ret
            base->property += p->property;
ffffffffc020185e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201862:	ff078693          	addi	a3,a5,-16
ffffffffc0201866:	9e39                	addw	a2,a2,a4
ffffffffc0201868:	c910                	sw	a2,16(a0)
ffffffffc020186a:	5775                	li	a4,-3
ffffffffc020186c:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201870:	6398                	ld	a4,0(a5)
ffffffffc0201872:	679c                	ld	a5,8(a5)
}
ffffffffc0201874:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201876:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201878:	e398                	sd	a4,0(a5)
ffffffffc020187a:	0141                	addi	sp,sp,16
ffffffffc020187c:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020187e:	00006697          	auipc	a3,0x6
ffffffffc0201882:	a9a68693          	addi	a3,a3,-1382 # ffffffffc0207318 <commands+0xbb0>
ffffffffc0201886:	00005617          	auipc	a2,0x5
ffffffffc020188a:	73260613          	addi	a2,a2,1842 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020188e:	09400593          	li	a1,148
ffffffffc0201892:	00005517          	auipc	a0,0x5
ffffffffc0201896:	73e50513          	addi	a0,a0,1854 # ffffffffc0206fd0 <commands+0x868>
ffffffffc020189a:	bdffe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(n > 0);
ffffffffc020189e:	00006697          	auipc	a3,0x6
ffffffffc02018a2:	a7268693          	addi	a3,a3,-1422 # ffffffffc0207310 <commands+0xba8>
ffffffffc02018a6:	00005617          	auipc	a2,0x5
ffffffffc02018aa:	71260613          	addi	a2,a2,1810 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02018ae:	09000593          	li	a1,144
ffffffffc02018b2:	00005517          	auipc	a0,0x5
ffffffffc02018b6:	71e50513          	addi	a0,a0,1822 # ffffffffc0206fd0 <commands+0x868>
ffffffffc02018ba:	bbffe0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc02018be <default_alloc_pages>:
    assert(n > 0);
ffffffffc02018be:	c941                	beqz	a0,ffffffffc020194e <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc02018c0:	00141597          	auipc	a1,0x141
ffffffffc02018c4:	8b058593          	addi	a1,a1,-1872 # ffffffffc0342170 <free_area>
ffffffffc02018c8:	0105a803          	lw	a6,16(a1)
ffffffffc02018cc:	872a                	mv	a4,a0
ffffffffc02018ce:	02081793          	slli	a5,a6,0x20
ffffffffc02018d2:	9381                	srli	a5,a5,0x20
ffffffffc02018d4:	00a7ee63          	bltu	a5,a0,ffffffffc02018f0 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc02018d8:	87ae                	mv	a5,a1
ffffffffc02018da:	a801                	j	ffffffffc02018ea <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc02018dc:	ff87a683          	lw	a3,-8(a5)
ffffffffc02018e0:	02069613          	slli	a2,a3,0x20
ffffffffc02018e4:	9201                	srli	a2,a2,0x20
ffffffffc02018e6:	00e67763          	bgeu	a2,a4,ffffffffc02018f4 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc02018ea:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc02018ec:	feb798e3          	bne	a5,a1,ffffffffc02018dc <default_alloc_pages+0x1e>
        return NULL;
ffffffffc02018f0:	4501                	li	a0,0
}
ffffffffc02018f2:	8082                	ret
    return listelm->prev;
ffffffffc02018f4:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02018f8:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc02018fc:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201900:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc0201904:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0201908:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc020190c:	02c77863          	bgeu	a4,a2,ffffffffc020193c <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201910:	071a                	slli	a4,a4,0x6
ffffffffc0201912:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201914:	41c686bb          	subw	a3,a3,t3
ffffffffc0201918:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020191a:	00870613          	addi	a2,a4,8
ffffffffc020191e:	4689                	li	a3,2
ffffffffc0201920:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201924:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0201928:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc020192c:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201930:	e290                	sd	a2,0(a3)
ffffffffc0201932:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0201936:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0201938:	01173c23          	sd	a7,24(a4)
ffffffffc020193c:	41c8083b          	subw	a6,a6,t3
ffffffffc0201940:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201944:	5775                	li	a4,-3
ffffffffc0201946:	17c1                	addi	a5,a5,-16
ffffffffc0201948:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc020194c:	8082                	ret
{
ffffffffc020194e:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201950:	00006697          	auipc	a3,0x6
ffffffffc0201954:	9c068693          	addi	a3,a3,-1600 # ffffffffc0207310 <commands+0xba8>
ffffffffc0201958:	00005617          	auipc	a2,0x5
ffffffffc020195c:	66060613          	addi	a2,a2,1632 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201960:	06c00593          	li	a1,108
ffffffffc0201964:	00005517          	auipc	a0,0x5
ffffffffc0201968:	66c50513          	addi	a0,a0,1644 # ffffffffc0206fd0 <commands+0x868>
{
ffffffffc020196c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020196e:	b0bfe0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0201972 <default_init_memmap>:
{
ffffffffc0201972:	1141                	addi	sp,sp,-16
ffffffffc0201974:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201976:	c5f1                	beqz	a1,ffffffffc0201a42 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc0201978:	00659693          	slli	a3,a1,0x6
ffffffffc020197c:	96aa                	add	a3,a3,a0
ffffffffc020197e:	87aa                	mv	a5,a0
ffffffffc0201980:	00d50f63          	beq	a0,a3,ffffffffc020199e <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201984:	6798                	ld	a4,8(a5)
ffffffffc0201986:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc0201988:	cf49                	beqz	a4,ffffffffc0201a22 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc020198a:	0007a823          	sw	zero,16(a5)
ffffffffc020198e:	0007b423          	sd	zero,8(a5)
ffffffffc0201992:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201996:	04078793          	addi	a5,a5,64
ffffffffc020199a:	fed795e3          	bne	a5,a3,ffffffffc0201984 <default_init_memmap+0x12>
    base->property = n;
ffffffffc020199e:	2581                	sext.w	a1,a1
ffffffffc02019a0:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02019a2:	4789                	li	a5,2
ffffffffc02019a4:	00850713          	addi	a4,a0,8
ffffffffc02019a8:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02019ac:	00140697          	auipc	a3,0x140
ffffffffc02019b0:	7c468693          	addi	a3,a3,1988 # ffffffffc0342170 <free_area>
ffffffffc02019b4:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02019b6:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02019b8:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02019bc:	9db9                	addw	a1,a1,a4
ffffffffc02019be:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02019c0:	04d78a63          	beq	a5,a3,ffffffffc0201a14 <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc02019c4:	fe878713          	addi	a4,a5,-24
ffffffffc02019c8:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02019cc:	4581                	li	a1,0
            if (base < page)
ffffffffc02019ce:	00e56a63          	bltu	a0,a4,ffffffffc02019e2 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc02019d2:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02019d4:	02d70263          	beq	a4,a3,ffffffffc02019f8 <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc02019d8:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02019da:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02019de:	fee57ae3          	bgeu	a0,a4,ffffffffc02019d2 <default_init_memmap+0x60>
ffffffffc02019e2:	c199                	beqz	a1,ffffffffc02019e8 <default_init_memmap+0x76>
ffffffffc02019e4:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02019e8:	6398                	ld	a4,0(a5)
}
ffffffffc02019ea:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02019ec:	e390                	sd	a2,0(a5)
ffffffffc02019ee:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02019f0:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02019f2:	ed18                	sd	a4,24(a0)
ffffffffc02019f4:	0141                	addi	sp,sp,16
ffffffffc02019f6:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02019f8:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02019fa:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02019fc:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02019fe:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201a00:	00d70663          	beq	a4,a3,ffffffffc0201a0c <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201a04:	8832                	mv	a6,a2
ffffffffc0201a06:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201a08:	87ba                	mv	a5,a4
ffffffffc0201a0a:	bfc1                	j	ffffffffc02019da <default_init_memmap+0x68>
}
ffffffffc0201a0c:	60a2                	ld	ra,8(sp)
ffffffffc0201a0e:	e290                	sd	a2,0(a3)
ffffffffc0201a10:	0141                	addi	sp,sp,16
ffffffffc0201a12:	8082                	ret
ffffffffc0201a14:	60a2                	ld	ra,8(sp)
ffffffffc0201a16:	e390                	sd	a2,0(a5)
ffffffffc0201a18:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a1a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a1c:	ed1c                	sd	a5,24(a0)
ffffffffc0201a1e:	0141                	addi	sp,sp,16
ffffffffc0201a20:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201a22:	00006697          	auipc	a3,0x6
ffffffffc0201a26:	91e68693          	addi	a3,a3,-1762 # ffffffffc0207340 <commands+0xbd8>
ffffffffc0201a2a:	00005617          	auipc	a2,0x5
ffffffffc0201a2e:	58e60613          	addi	a2,a2,1422 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201a32:	04b00593          	li	a1,75
ffffffffc0201a36:	00005517          	auipc	a0,0x5
ffffffffc0201a3a:	59a50513          	addi	a0,a0,1434 # ffffffffc0206fd0 <commands+0x868>
ffffffffc0201a3e:	a3bfe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(n > 0);
ffffffffc0201a42:	00006697          	auipc	a3,0x6
ffffffffc0201a46:	8ce68693          	addi	a3,a3,-1842 # ffffffffc0207310 <commands+0xba8>
ffffffffc0201a4a:	00005617          	auipc	a2,0x5
ffffffffc0201a4e:	56e60613          	addi	a2,a2,1390 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201a52:	04700593          	li	a1,71
ffffffffc0201a56:	00005517          	auipc	a0,0x5
ffffffffc0201a5a:	57a50513          	addi	a0,a0,1402 # ffffffffc0206fd0 <commands+0x868>
ffffffffc0201a5e:	a1bfe0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0201a62 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201a62:	c955                	beqz	a0,ffffffffc0201b16 <slob_free+0xb4>
{
ffffffffc0201a64:	1141                	addi	sp,sp,-16
ffffffffc0201a66:	e022                	sd	s0,0(sp)
ffffffffc0201a68:	e406                	sd	ra,8(sp)
ffffffffc0201a6a:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201a6c:	e9c9                	bnez	a1,ffffffffc0201afe <slob_free+0x9c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a6e:	100027f3          	csrr	a5,sstatus
ffffffffc0201a72:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201a74:	4801                	li	a6,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a76:	efc1                	bnez	a5,ffffffffc0201b0e <slob_free+0xac>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201a78:	00140617          	auipc	a2,0x140
ffffffffc0201a7c:	2e860613          	addi	a2,a2,744 # ffffffffc0341d60 <slobfree>
ffffffffc0201a80:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201a82:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201a84:	679c                	ld	a5,8(a5)
ffffffffc0201a86:	02877b63          	bgeu	a4,s0,ffffffffc0201abc <slob_free+0x5a>
ffffffffc0201a8a:	00f46463          	bltu	s0,a5,ffffffffc0201a92 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201a8e:	fef76ae3          	bltu	a4,a5,ffffffffc0201a82 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201a92:	4008                	lw	a0,0(s0)
ffffffffc0201a94:	00451693          	slli	a3,a0,0x4
ffffffffc0201a98:	96a2                	add	a3,a3,s0
ffffffffc0201a9a:	02d78b63          	beq	a5,a3,ffffffffc0201ad0 <slob_free+0x6e>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201a9e:	430c                	lw	a1,0(a4)
ffffffffc0201aa0:	e41c                	sd	a5,8(s0)
ffffffffc0201aa2:	00459693          	slli	a3,a1,0x4
ffffffffc0201aa6:	96ba                	add	a3,a3,a4
ffffffffc0201aa8:	02d40f63          	beq	s0,a3,ffffffffc0201ae6 <slob_free+0x84>
ffffffffc0201aac:	e700                	sd	s0,8(a4)
		cur->next = b->next;
	}
	else
		cur->next = b;

	slobfree = cur;
ffffffffc0201aae:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0201ab0:	04081263          	bnez	a6,ffffffffc0201af4 <slob_free+0x92>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201ab4:	60a2                	ld	ra,8(sp)
ffffffffc0201ab6:	6402                	ld	s0,0(sp)
ffffffffc0201ab8:	0141                	addi	sp,sp,16
ffffffffc0201aba:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201abc:	fcf763e3          	bltu	a4,a5,ffffffffc0201a82 <slob_free+0x20>
ffffffffc0201ac0:	fcf471e3          	bgeu	s0,a5,ffffffffc0201a82 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201ac4:	4008                	lw	a0,0(s0)
ffffffffc0201ac6:	00451693          	slli	a3,a0,0x4
ffffffffc0201aca:	96a2                	add	a3,a3,s0
ffffffffc0201acc:	fcd799e3          	bne	a5,a3,ffffffffc0201a9e <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201ad0:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201ad2:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201ad4:	9d35                	addw	a0,a0,a3
ffffffffc0201ad6:	c008                	sw	a0,0(s0)
	if (cur + cur->units == b)
ffffffffc0201ad8:	430c                	lw	a1,0(a4)
ffffffffc0201ada:	e41c                	sd	a5,8(s0)
ffffffffc0201adc:	00459693          	slli	a3,a1,0x4
ffffffffc0201ae0:	96ba                	add	a3,a3,a4
ffffffffc0201ae2:	fcd415e3          	bne	s0,a3,ffffffffc0201aac <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201ae6:	9da9                	addw	a1,a1,a0
		cur->next = b->next;
ffffffffc0201ae8:	843e                	mv	s0,a5
		cur->units += b->units;
ffffffffc0201aea:	c30c                	sw	a1,0(a4)
		cur->next = b->next;
ffffffffc0201aec:	e700                	sd	s0,8(a4)
	slobfree = cur;
ffffffffc0201aee:	e218                	sd	a4,0(a2)
ffffffffc0201af0:	fc0802e3          	beqz	a6,ffffffffc0201ab4 <slob_free+0x52>
}
ffffffffc0201af4:	6402                	ld	s0,0(sp)
ffffffffc0201af6:	60a2                	ld	ra,8(sp)
ffffffffc0201af8:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201afa:	e99fe06f          	j	ffffffffc0200992 <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201afe:	25bd                	addiw	a1,a1,15
ffffffffc0201b00:	8191                	srli	a1,a1,0x4
ffffffffc0201b02:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b04:	100027f3          	csrr	a5,sstatus
ffffffffc0201b08:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201b0a:	4801                	li	a6,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b0c:	d7b5                	beqz	a5,ffffffffc0201a78 <slob_free+0x16>
        intr_disable();
ffffffffc0201b0e:	e8bfe0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        return 1;
ffffffffc0201b12:	4805                	li	a6,1
ffffffffc0201b14:	b795                	j	ffffffffc0201a78 <slob_free+0x16>
ffffffffc0201b16:	8082                	ret

ffffffffc0201b18 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201b18:	715d                	addi	sp,sp,-80
ffffffffc0201b1a:	e486                	sd	ra,72(sp)
ffffffffc0201b1c:	e0a2                	sd	s0,64(sp)
ffffffffc0201b1e:	fc26                	sd	s1,56(sp)
ffffffffc0201b20:	f84a                	sd	s2,48(sp)
ffffffffc0201b22:	f44e                	sd	s3,40(sp)
ffffffffc0201b24:	f052                	sd	s4,32(sp)
ffffffffc0201b26:	ec56                	sd	s5,24(sp)
ffffffffc0201b28:	e85a                	sd	s6,16(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201b2a:	01050713          	addi	a4,a0,16
ffffffffc0201b2e:	6785                	lui	a5,0x1
ffffffffc0201b30:	10f77f63          	bgeu	a4,a5,ffffffffc0201c4e <slob_alloc.constprop.0+0x136>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201b34:	00f50413          	addi	s0,a0,15
ffffffffc0201b38:	8011                	srli	s0,s0,0x4
ffffffffc0201b3a:	2401                	sext.w	s0,s0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b3c:	100026f3          	csrr	a3,sstatus
ffffffffc0201b40:	8a89                	andi	a3,a3,2
ffffffffc0201b42:	eaf1                	bnez	a3,ffffffffc0201c16 <slob_alloc.constprop.0+0xfe>
	prev = slobfree;
ffffffffc0201b44:	00140917          	auipc	s2,0x140
ffffffffc0201b48:	21c90913          	addi	s2,s2,540 # ffffffffc0341d60 <slobfree>
ffffffffc0201b4c:	00093603          	ld	a2,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201b50:	6608                	ld	a0,8(a2)
		if (cur->units >= units + delta)
ffffffffc0201b52:	4118                	lw	a4,0(a0)
ffffffffc0201b54:	0c875f63          	bge	a4,s0,ffffffffc0201c32 <slob_alloc.constprop.0+0x11a>
    return KADDR(page2pa(page));
ffffffffc0201b58:	54fd                	li	s1,-1
    return page - pages + nbase;
ffffffffc0201b5a:	00144b17          	auipc	s6,0x144
ffffffffc0201b5e:	6aeb0b13          	addi	s6,s6,1710 # ffffffffc0346208 <pages>
ffffffffc0201b62:	00007a97          	auipc	s5,0x7
ffffffffc0201b66:	2aea8a93          	addi	s5,s5,686 # ffffffffc0208e10 <nbase>
    return KADDR(page2pa(page));
ffffffffc0201b6a:	80b1                	srli	s1,s1,0xc
ffffffffc0201b6c:	00144a17          	auipc	s4,0x144
ffffffffc0201b70:	694a0a13          	addi	s4,s4,1684 # ffffffffc0346200 <npage>
ffffffffc0201b74:	00144997          	auipc	s3,0x144
ffffffffc0201b78:	6a498993          	addi	s3,s3,1700 # ffffffffc0346218 <va_pa_offset>
ffffffffc0201b7c:	a029                	j	ffffffffc0201b86 <slob_alloc.constprop.0+0x6e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201b7e:	6788                	ld	a0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201b80:	4118                	lw	a4,0(a0)
ffffffffc0201b82:	04875b63          	bge	a4,s0,ffffffffc0201bd8 <slob_alloc.constprop.0+0xc0>
		if (cur == slobfree)
ffffffffc0201b86:	87aa                	mv	a5,a0
ffffffffc0201b88:	fea61be3          	bne	a2,a0,ffffffffc0201b7e <slob_alloc.constprop.0+0x66>
    if (flag)
ffffffffc0201b8c:	eeb5                	bnez	a3,ffffffffc0201c08 <slob_alloc.constprop.0+0xf0>
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b8e:	4505                	li	a0,1
ffffffffc0201b90:	3e2000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
	if (!page)
ffffffffc0201b94:	c125                	beqz	a0,ffffffffc0201bf4 <slob_alloc.constprop.0+0xdc>
    return page - pages + nbase;
ffffffffc0201b96:	000b3683          	ld	a3,0(s6)
ffffffffc0201b9a:	000ab703          	ld	a4,0(s5)
    return KADDR(page2pa(page));
ffffffffc0201b9e:	000a3783          	ld	a5,0(s4)
    return page - pages + nbase;
ffffffffc0201ba2:	40d506b3          	sub	a3,a0,a3
ffffffffc0201ba6:	8699                	srai	a3,a3,0x6
ffffffffc0201ba8:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0201baa:	0096f733          	and	a4,a3,s1
    return page2ppn(page) << PGSHIFT;
ffffffffc0201bae:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0201bb0:	08f77363          	bgeu	a4,a5,ffffffffc0201c36 <slob_alloc.constprop.0+0x11e>
ffffffffc0201bb4:	0009b503          	ld	a0,0(s3)
ffffffffc0201bb8:	9536                	add	a0,a0,a3
			if (!cur)
ffffffffc0201bba:	c935                	beqz	a0,ffffffffc0201c2e <slob_alloc.constprop.0+0x116>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201bbc:	6585                	lui	a1,0x1
ffffffffc0201bbe:	ea5ff0ef          	jal	ra,ffffffffc0201a62 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201bc2:	100026f3          	csrr	a3,sstatus
ffffffffc0201bc6:	8a89                	andi	a3,a3,2
ffffffffc0201bc8:	e2b9                	bnez	a3,ffffffffc0201c0e <slob_alloc.constprop.0+0xf6>
			cur = slobfree;
ffffffffc0201bca:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201bce:	6788                	ld	a0,8(a5)
			cur = slobfree;
ffffffffc0201bd0:	863e                	mv	a2,a5
		if (cur->units >= units + delta)
ffffffffc0201bd2:	4118                	lw	a4,0(a0)
ffffffffc0201bd4:	fa8749e3          	blt	a4,s0,ffffffffc0201b86 <slob_alloc.constprop.0+0x6e>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201bd8:	04e40863          	beq	s0,a4,ffffffffc0201c28 <slob_alloc.constprop.0+0x110>
				prev->next = cur + units;
ffffffffc0201bdc:	00441613          	slli	a2,s0,0x4
ffffffffc0201be0:	962a                	add	a2,a2,a0
ffffffffc0201be2:	e790                	sd	a2,8(a5)
				prev->next->next = cur->next;
ffffffffc0201be4:	650c                	ld	a1,8(a0)
				prev->next->units = cur->units - units;
ffffffffc0201be6:	9f01                	subw	a4,a4,s0
ffffffffc0201be8:	c218                	sw	a4,0(a2)
				prev->next->next = cur->next;
ffffffffc0201bea:	e60c                	sd	a1,8(a2)
				cur->units = units;
ffffffffc0201bec:	c100                	sw	s0,0(a0)
			slobfree = prev;
ffffffffc0201bee:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201bf2:	e695                	bnez	a3,ffffffffc0201c1e <slob_alloc.constprop.0+0x106>
}
ffffffffc0201bf4:	60a6                	ld	ra,72(sp)
ffffffffc0201bf6:	6406                	ld	s0,64(sp)
ffffffffc0201bf8:	74e2                	ld	s1,56(sp)
ffffffffc0201bfa:	7942                	ld	s2,48(sp)
ffffffffc0201bfc:	79a2                	ld	s3,40(sp)
ffffffffc0201bfe:	7a02                	ld	s4,32(sp)
ffffffffc0201c00:	6ae2                	ld	s5,24(sp)
ffffffffc0201c02:	6b42                	ld	s6,16(sp)
ffffffffc0201c04:	6161                	addi	sp,sp,80
ffffffffc0201c06:	8082                	ret
        intr_enable();
ffffffffc0201c08:	d8bfe0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0201c0c:	b749                	j	ffffffffc0201b8e <slob_alloc.constprop.0+0x76>
        intr_disable();
ffffffffc0201c0e:	d8bfe0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        return 1;
ffffffffc0201c12:	4685                	li	a3,1
ffffffffc0201c14:	bf5d                	j	ffffffffc0201bca <slob_alloc.constprop.0+0xb2>
        intr_disable();
ffffffffc0201c16:	d83fe0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        return 1;
ffffffffc0201c1a:	4685                	li	a3,1
ffffffffc0201c1c:	b725                	j	ffffffffc0201b44 <slob_alloc.constprop.0+0x2c>
ffffffffc0201c1e:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201c20:	d73fe0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0201c24:	6522                	ld	a0,8(sp)
ffffffffc0201c26:	b7f9                	j	ffffffffc0201bf4 <slob_alloc.constprop.0+0xdc>
				prev->next = cur->next; /* unlink */
ffffffffc0201c28:	6518                	ld	a4,8(a0)
ffffffffc0201c2a:	e798                	sd	a4,8(a5)
ffffffffc0201c2c:	b7c9                	j	ffffffffc0201bee <slob_alloc.constprop.0+0xd6>
				return 0;
ffffffffc0201c2e:	4501                	li	a0,0
ffffffffc0201c30:	b7d1                	j	ffffffffc0201bf4 <slob_alloc.constprop.0+0xdc>
		if (cur->units >= units + delta)
ffffffffc0201c32:	87b2                	mv	a5,a2
ffffffffc0201c34:	b755                	j	ffffffffc0201bd8 <slob_alloc.constprop.0+0xc0>
ffffffffc0201c36:	00005617          	auipc	a2,0x5
ffffffffc0201c3a:	7a260613          	addi	a2,a2,1954 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0201c3e:	07100593          	li	a1,113
ffffffffc0201c42:	00005517          	auipc	a0,0x5
ffffffffc0201c46:	7be50513          	addi	a0,a0,1982 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc0201c4a:	82ffe0ef          	jal	ra,ffffffffc0200478 <__panic>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201c4e:	00005697          	auipc	a3,0x5
ffffffffc0201c52:	75268693          	addi	a3,a3,1874 # ffffffffc02073a0 <default_pmm_manager+0x38>
ffffffffc0201c56:	00005617          	auipc	a2,0x5
ffffffffc0201c5a:	36260613          	addi	a2,a2,866 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0201c5e:	06300593          	li	a1,99
ffffffffc0201c62:	00005517          	auipc	a0,0x5
ffffffffc0201c66:	75e50513          	addi	a0,a0,1886 # ffffffffc02073c0 <default_pmm_manager+0x58>
ffffffffc0201c6a:	80ffe0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0201c6e <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201c6e:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201c70:	00005517          	auipc	a0,0x5
ffffffffc0201c74:	7a050513          	addi	a0,a0,1952 # ffffffffc0207410 <default_pmm_manager+0xa8>
{
ffffffffc0201c78:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201c7a:	d1efe0ef          	jal	ra,ffffffffc0200198 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201c7e:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201c80:	00005517          	auipc	a0,0x5
ffffffffc0201c84:	7a850513          	addi	a0,a0,1960 # ffffffffc0207428 <default_pmm_manager+0xc0>
}
ffffffffc0201c88:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201c8a:	d0efe06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0201c8e <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201c8e:	4501                	li	a0,0
ffffffffc0201c90:	8082                	ret

ffffffffc0201c92 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201c92:	1101                	addi	sp,sp,-32
ffffffffc0201c94:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201c96:	6905                	lui	s2,0x1
{
ffffffffc0201c98:	e822                	sd	s0,16(sp)
ffffffffc0201c9a:	ec06                	sd	ra,24(sp)
ffffffffc0201c9c:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201c9e:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x103b9>
{
ffffffffc0201ca2:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201ca4:	08a7f663          	bgeu	a5,a0,ffffffffc0201d30 <kmalloc+0x9e>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201ca8:	4561                	li	a0,24
ffffffffc0201caa:	e6fff0ef          	jal	ra,ffffffffc0201b18 <slob_alloc.constprop.0>
ffffffffc0201cae:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201cb0:	c551                	beqz	a0,ffffffffc0201d3c <kmalloc+0xaa>
	bb->order = find_order(size);
ffffffffc0201cb2:	0004079b          	sext.w	a5,s0
	for (; size > 4096; size >>= 1)
ffffffffc0201cb6:	0cf95463          	bge	s2,a5,ffffffffc0201d7e <kmalloc+0xec>
	int order = 0;
ffffffffc0201cba:	4701                	li	a4,0
	for (; size > 4096; size >>= 1)
ffffffffc0201cbc:	6685                	lui	a3,0x1
ffffffffc0201cbe:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201cc0:	2705                	addiw	a4,a4,1
	for (; size > 4096; size >>= 1)
ffffffffc0201cc2:	fef6cee3          	blt	a3,a5,ffffffffc0201cbe <kmalloc+0x2c>
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201cc6:	4505                	li	a0,1
ffffffffc0201cc8:	00e5153b          	sllw	a0,a0,a4
	bb->order = find_order(size);
ffffffffc0201ccc:	c098                	sw	a4,0(s1)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201cce:	2a4000ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
	if (!page)
ffffffffc0201cd2:	cd51                	beqz	a0,ffffffffc0201d6e <kmalloc+0xdc>
    return page - pages + nbase;
ffffffffc0201cd4:	00144697          	auipc	a3,0x144
ffffffffc0201cd8:	5346b683          	ld	a3,1332(a3) # ffffffffc0346208 <pages>
ffffffffc0201cdc:	40d506b3          	sub	a3,a0,a3
ffffffffc0201ce0:	8699                	srai	a3,a3,0x6
ffffffffc0201ce2:	00007517          	auipc	a0,0x7
ffffffffc0201ce6:	12e53503          	ld	a0,302(a0) # ffffffffc0208e10 <nbase>
ffffffffc0201cea:	96aa                	add	a3,a3,a0
    return KADDR(page2pa(page));
ffffffffc0201cec:	00c69793          	slli	a5,a3,0xc
ffffffffc0201cf0:	83b1                	srli	a5,a5,0xc
ffffffffc0201cf2:	00144717          	auipc	a4,0x144
ffffffffc0201cf6:	50e73703          	ld	a4,1294(a4) # ffffffffc0346200 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201cfa:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0201cfc:	08e7f463          	bgeu	a5,a4,ffffffffc0201d84 <kmalloc+0xf2>
ffffffffc0201d00:	00144517          	auipc	a0,0x144
ffffffffc0201d04:	51853503          	ld	a0,1304(a0) # ffffffffc0346218 <va_pa_offset>
ffffffffc0201d08:	9536                	add	a0,a0,a3
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201d0a:	e488                	sd	a0,8(s1)
	if (bb->pages)
ffffffffc0201d0c:	c13d                	beqz	a0,ffffffffc0201d72 <kmalloc+0xe0>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d0e:	100027f3          	csrr	a5,sstatus
ffffffffc0201d12:	8b89                	andi	a5,a5,2
ffffffffc0201d14:	eb9d                	bnez	a5,ffffffffc0201d4a <kmalloc+0xb8>
		bb->next = bigblocks;
ffffffffc0201d16:	00144797          	auipc	a5,0x144
ffffffffc0201d1a:	4d278793          	addi	a5,a5,1234 # ffffffffc03461e8 <bigblocks>
ffffffffc0201d1e:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201d20:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201d22:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201d24:	60e2                	ld	ra,24(sp)
ffffffffc0201d26:	6442                	ld	s0,16(sp)
ffffffffc0201d28:	64a2                	ld	s1,8(sp)
ffffffffc0201d2a:	6902                	ld	s2,0(sp)
ffffffffc0201d2c:	6105                	addi	sp,sp,32
ffffffffc0201d2e:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201d30:	0541                	addi	a0,a0,16
ffffffffc0201d32:	de7ff0ef          	jal	ra,ffffffffc0201b18 <slob_alloc.constprop.0>
ffffffffc0201d36:	87aa                	mv	a5,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201d38:	0541                	addi	a0,a0,16
ffffffffc0201d3a:	f7ed                	bnez	a5,ffffffffc0201d24 <kmalloc+0x92>
	return 0;
ffffffffc0201d3c:	4501                	li	a0,0
}
ffffffffc0201d3e:	60e2                	ld	ra,24(sp)
ffffffffc0201d40:	6442                	ld	s0,16(sp)
ffffffffc0201d42:	64a2                	ld	s1,8(sp)
ffffffffc0201d44:	6902                	ld	s2,0(sp)
ffffffffc0201d46:	6105                	addi	sp,sp,32
ffffffffc0201d48:	8082                	ret
        intr_disable();
ffffffffc0201d4a:	c4ffe0ef          	jal	ra,ffffffffc0200998 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201d4e:	00144797          	auipc	a5,0x144
ffffffffc0201d52:	49a78793          	addi	a5,a5,1178 # ffffffffc03461e8 <bigblocks>
ffffffffc0201d56:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201d58:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201d5a:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201d5c:	c37fe0ef          	jal	ra,ffffffffc0200992 <intr_enable>
}
ffffffffc0201d60:	60e2                	ld	ra,24(sp)
ffffffffc0201d62:	6442                	ld	s0,16(sp)
		return bb->pages;
ffffffffc0201d64:	6488                	ld	a0,8(s1)
}
ffffffffc0201d66:	6902                	ld	s2,0(sp)
ffffffffc0201d68:	64a2                	ld	s1,8(sp)
ffffffffc0201d6a:	6105                	addi	sp,sp,32
ffffffffc0201d6c:	8082                	ret
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201d6e:	0004b423          	sd	zero,8(s1)
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d72:	8526                	mv	a0,s1
ffffffffc0201d74:	45e1                	li	a1,24
ffffffffc0201d76:	cedff0ef          	jal	ra,ffffffffc0201a62 <slob_free>
	return 0;
ffffffffc0201d7a:	4501                	li	a0,0
ffffffffc0201d7c:	b7c9                	j	ffffffffc0201d3e <kmalloc+0xac>
	for (; size > 4096; size >>= 1)
ffffffffc0201d7e:	4505                	li	a0,1
	int order = 0;
ffffffffc0201d80:	4701                	li	a4,0
ffffffffc0201d82:	b7a9                	j	ffffffffc0201ccc <kmalloc+0x3a>
ffffffffc0201d84:	00005617          	auipc	a2,0x5
ffffffffc0201d88:	65460613          	addi	a2,a2,1620 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0201d8c:	07100593          	li	a1,113
ffffffffc0201d90:	00005517          	auipc	a0,0x5
ffffffffc0201d94:	67050513          	addi	a0,a0,1648 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc0201d98:	ee0fe0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0201d9c <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201d9c:	c169                	beqz	a0,ffffffffc0201e5e <kfree+0xc2>
{
ffffffffc0201d9e:	1101                	addi	sp,sp,-32
ffffffffc0201da0:	e822                	sd	s0,16(sp)
ffffffffc0201da2:	ec06                	sd	ra,24(sp)
ffffffffc0201da4:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201da6:	03451793          	slli	a5,a0,0x34
ffffffffc0201daa:	842a                	mv	s0,a0
ffffffffc0201dac:	e3d9                	bnez	a5,ffffffffc0201e32 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201dae:	100027f3          	csrr	a5,sstatus
ffffffffc0201db2:	8b89                	andi	a5,a5,2
ffffffffc0201db4:	e7d9                	bnez	a5,ffffffffc0201e42 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201db6:	00144797          	auipc	a5,0x144
ffffffffc0201dba:	4327b783          	ld	a5,1074(a5) # ffffffffc03461e8 <bigblocks>
    return 0;
ffffffffc0201dbe:	4601                	li	a2,0
ffffffffc0201dc0:	cbad                	beqz	a5,ffffffffc0201e32 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201dc2:	00144697          	auipc	a3,0x144
ffffffffc0201dc6:	42668693          	addi	a3,a3,1062 # ffffffffc03461e8 <bigblocks>
ffffffffc0201dca:	a021                	j	ffffffffc0201dd2 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201dcc:	01048693          	addi	a3,s1,16
ffffffffc0201dd0:	c3a5                	beqz	a5,ffffffffc0201e30 <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201dd2:	6798                	ld	a4,8(a5)
ffffffffc0201dd4:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201dd6:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201dd8:	fe871ae3          	bne	a4,s0,ffffffffc0201dcc <kfree+0x30>
				*last = bb->next;
ffffffffc0201ddc:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201dde:	ee2d                	bnez	a2,ffffffffc0201e58 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201de0:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201de4:	4098                	lw	a4,0(s1)
ffffffffc0201de6:	08f46963          	bltu	s0,a5,ffffffffc0201e78 <kfree+0xdc>
ffffffffc0201dea:	00144697          	auipc	a3,0x144
ffffffffc0201dee:	42e6b683          	ld	a3,1070(a3) # ffffffffc0346218 <va_pa_offset>
ffffffffc0201df2:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201df4:	8031                	srli	s0,s0,0xc
ffffffffc0201df6:	00144797          	auipc	a5,0x144
ffffffffc0201dfa:	40a7b783          	ld	a5,1034(a5) # ffffffffc0346200 <npage>
ffffffffc0201dfe:	06f47163          	bgeu	s0,a5,ffffffffc0201e60 <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201e02:	00007517          	auipc	a0,0x7
ffffffffc0201e06:	00e53503          	ld	a0,14(a0) # ffffffffc0208e10 <nbase>
ffffffffc0201e0a:	8c09                	sub	s0,s0,a0
ffffffffc0201e0c:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201e0e:	00144517          	auipc	a0,0x144
ffffffffc0201e12:	3fa53503          	ld	a0,1018(a0) # ffffffffc0346208 <pages>
ffffffffc0201e16:	4585                	li	a1,1
ffffffffc0201e18:	9522                	add	a0,a0,s0
ffffffffc0201e1a:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201e1e:	192000ef          	jal	ra,ffffffffc0201fb0 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201e22:	6442                	ld	s0,16(sp)
ffffffffc0201e24:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e26:	8526                	mv	a0,s1
}
ffffffffc0201e28:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e2a:	45e1                	li	a1,24
}
ffffffffc0201e2c:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e2e:	b915                	j	ffffffffc0201a62 <slob_free>
ffffffffc0201e30:	e20d                	bnez	a2,ffffffffc0201e52 <kfree+0xb6>
ffffffffc0201e32:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201e36:	6442                	ld	s0,16(sp)
ffffffffc0201e38:	60e2                	ld	ra,24(sp)
ffffffffc0201e3a:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e3c:	4581                	li	a1,0
}
ffffffffc0201e3e:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e40:	b10d                	j	ffffffffc0201a62 <slob_free>
        intr_disable();
ffffffffc0201e42:	b57fe0ef          	jal	ra,ffffffffc0200998 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e46:	00144797          	auipc	a5,0x144
ffffffffc0201e4a:	3a27b783          	ld	a5,930(a5) # ffffffffc03461e8 <bigblocks>
        return 1;
ffffffffc0201e4e:	4605                	li	a2,1
ffffffffc0201e50:	fbad                	bnez	a5,ffffffffc0201dc2 <kfree+0x26>
        intr_enable();
ffffffffc0201e52:	b41fe0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0201e56:	bff1                	j	ffffffffc0201e32 <kfree+0x96>
ffffffffc0201e58:	b3bfe0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0201e5c:	b751                	j	ffffffffc0201de0 <kfree+0x44>
ffffffffc0201e5e:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201e60:	00005617          	auipc	a2,0x5
ffffffffc0201e64:	61060613          	addi	a2,a2,1552 # ffffffffc0207470 <default_pmm_manager+0x108>
ffffffffc0201e68:	06900593          	li	a1,105
ffffffffc0201e6c:	00005517          	auipc	a0,0x5
ffffffffc0201e70:	59450513          	addi	a0,a0,1428 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc0201e74:	e04fe0ef          	jal	ra,ffffffffc0200478 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201e78:	86a2                	mv	a3,s0
ffffffffc0201e7a:	00005617          	auipc	a2,0x5
ffffffffc0201e7e:	5ce60613          	addi	a2,a2,1486 # ffffffffc0207448 <default_pmm_manager+0xe0>
ffffffffc0201e82:	07700593          	li	a1,119
ffffffffc0201e86:	00005517          	auipc	a0,0x5
ffffffffc0201e8a:	57a50513          	addi	a0,a0,1402 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc0201e8e:	deafe0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0201e92 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201e92:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201e94:	00005617          	auipc	a2,0x5
ffffffffc0201e98:	5dc60613          	addi	a2,a2,1500 # ffffffffc0207470 <default_pmm_manager+0x108>
ffffffffc0201e9c:	06900593          	li	a1,105
ffffffffc0201ea0:	00005517          	auipc	a0,0x5
ffffffffc0201ea4:	56050513          	addi	a0,a0,1376 # ffffffffc0207400 <default_pmm_manager+0x98>
pa2page(uintptr_t pa)
ffffffffc0201ea8:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201eaa:	dcefe0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0201eae <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0201eae:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201eb0:	00005617          	auipc	a2,0x5
ffffffffc0201eb4:	5e060613          	addi	a2,a2,1504 # ffffffffc0207490 <default_pmm_manager+0x128>
ffffffffc0201eb8:	07f00593          	li	a1,127
ffffffffc0201ebc:	00005517          	auipc	a0,0x5
ffffffffc0201ec0:	54450513          	addi	a0,a0,1348 # ffffffffc0207400 <default_pmm_manager+0x98>
pte2page(pte_t pte)
ffffffffc0201ec4:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201ec6:	db2fe0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0201eca <get_pte.constprop.0>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201eca:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201ece:	1ff7f793          	andi	a5,a5,511
    if (!(*pdep1 & PTE_V))
ffffffffc0201ed2:	078e                	slli	a5,a5,0x3
ffffffffc0201ed4:	97aa                	add	a5,a5,a0
ffffffffc0201ed6:	639c                	ld	a5,0(a5)
ffffffffc0201ed8:	0017f713          	andi	a4,a5,1
ffffffffc0201edc:	e319                	bnez	a4,ffffffffc0201ee2 <get_pte.constprop.0+0x18>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
        {
            return NULL;
ffffffffc0201ede:	4501                	li	a0,0
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
}
ffffffffc0201ee0:	8082                	ret
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201ee2:	078a                	slli	a5,a5,0x2
ffffffffc0201ee4:	767d                	lui	a2,0xfffff
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
ffffffffc0201ee6:	1141                	addi	sp,sp,-16
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201ee8:	00c7f6b3          	and	a3,a5,a2
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
ffffffffc0201eec:	e406                	sd	ra,8(sp)
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201eee:	00144717          	auipc	a4,0x144
ffffffffc0201ef2:	31273703          	ld	a4,786(a4) # ffffffffc0346200 <npage>
ffffffffc0201ef6:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201efa:	04e7f463          	bgeu	a5,a4,ffffffffc0201f42 <get_pte.constprop.0+0x78>
ffffffffc0201efe:	0155d793          	srli	a5,a1,0x15
ffffffffc0201f02:	1ff7f793          	andi	a5,a5,511
    if (!(*pdep0 & PTE_V))
ffffffffc0201f06:	078e                	slli	a5,a5,0x3
ffffffffc0201f08:	97b6                	add	a5,a5,a3
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201f0a:	00144517          	auipc	a0,0x144
ffffffffc0201f0e:	30e53503          	ld	a0,782(a0) # ffffffffc0346218 <va_pa_offset>
    if (!(*pdep0 & PTE_V))
ffffffffc0201f12:	97aa                	add	a5,a5,a0
ffffffffc0201f14:	6394                	ld	a3,0(a5)
ffffffffc0201f16:	0016f793          	andi	a5,a3,1
ffffffffc0201f1a:	c385                	beqz	a5,ffffffffc0201f3a <get_pte.constprop.0+0x70>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f1c:	068a                	slli	a3,a3,0x2
ffffffffc0201f1e:	8ef1                	and	a3,a3,a2
ffffffffc0201f20:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201f24:	02e7fb63          	bgeu	a5,a4,ffffffffc0201f5a <get_pte.constprop.0+0x90>
}
ffffffffc0201f28:	60a2                	ld	ra,8(sp)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f2a:	81b1                	srli	a1,a1,0xc
ffffffffc0201f2c:	1ff5f593          	andi	a1,a1,511
ffffffffc0201f30:	9536                	add	a0,a0,a3
ffffffffc0201f32:	058e                	slli	a1,a1,0x3
ffffffffc0201f34:	952e                	add	a0,a0,a1
}
ffffffffc0201f36:	0141                	addi	sp,sp,16
ffffffffc0201f38:	8082                	ret
ffffffffc0201f3a:	60a2                	ld	ra,8(sp)
            return NULL;
ffffffffc0201f3c:	4501                	li	a0,0
}
ffffffffc0201f3e:	0141                	addi	sp,sp,16
ffffffffc0201f40:	8082                	ret
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201f42:	00005617          	auipc	a2,0x5
ffffffffc0201f46:	49660613          	addi	a2,a2,1174 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0201f4a:	0ed00593          	li	a1,237
ffffffffc0201f4e:	00005517          	auipc	a0,0x5
ffffffffc0201f52:	56a50513          	addi	a0,a0,1386 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0201f56:	d22fe0ef          	jal	ra,ffffffffc0200478 <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f5a:	00005617          	auipc	a2,0x5
ffffffffc0201f5e:	47e60613          	addi	a2,a2,1150 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0201f62:	0fa00593          	li	a1,250
ffffffffc0201f66:	00005517          	auipc	a0,0x5
ffffffffc0201f6a:	55250513          	addi	a0,a0,1362 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0201f6e:	d0afe0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0201f72 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f72:	100027f3          	csrr	a5,sstatus
ffffffffc0201f76:	8b89                	andi	a5,a5,2
ffffffffc0201f78:	e799                	bnez	a5,ffffffffc0201f86 <alloc_pages+0x14>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f7a:	00144797          	auipc	a5,0x144
ffffffffc0201f7e:	2967b783          	ld	a5,662(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc0201f82:	6f9c                	ld	a5,24(a5)
ffffffffc0201f84:	8782                	jr	a5
{
ffffffffc0201f86:	1141                	addi	sp,sp,-16
ffffffffc0201f88:	e406                	sd	ra,8(sp)
ffffffffc0201f8a:	e022                	sd	s0,0(sp)
ffffffffc0201f8c:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201f8e:	a0bfe0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f92:	00144797          	auipc	a5,0x144
ffffffffc0201f96:	27e7b783          	ld	a5,638(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc0201f9a:	6f9c                	ld	a5,24(a5)
ffffffffc0201f9c:	8522                	mv	a0,s0
ffffffffc0201f9e:	9782                	jalr	a5
ffffffffc0201fa0:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201fa2:	9f1fe0ef          	jal	ra,ffffffffc0200992 <intr_enable>
}
ffffffffc0201fa6:	60a2                	ld	ra,8(sp)
ffffffffc0201fa8:	8522                	mv	a0,s0
ffffffffc0201faa:	6402                	ld	s0,0(sp)
ffffffffc0201fac:	0141                	addi	sp,sp,16
ffffffffc0201fae:	8082                	ret

ffffffffc0201fb0 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201fb0:	100027f3          	csrr	a5,sstatus
ffffffffc0201fb4:	8b89                	andi	a5,a5,2
ffffffffc0201fb6:	e799                	bnez	a5,ffffffffc0201fc4 <free_pages+0x14>
        pmm_manager->free_pages(base, n);
ffffffffc0201fb8:	00144797          	auipc	a5,0x144
ffffffffc0201fbc:	2587b783          	ld	a5,600(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc0201fc0:	739c                	ld	a5,32(a5)
ffffffffc0201fc2:	8782                	jr	a5
{
ffffffffc0201fc4:	1101                	addi	sp,sp,-32
ffffffffc0201fc6:	ec06                	sd	ra,24(sp)
ffffffffc0201fc8:	e822                	sd	s0,16(sp)
ffffffffc0201fca:	e426                	sd	s1,8(sp)
ffffffffc0201fcc:	842a                	mv	s0,a0
ffffffffc0201fce:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201fd0:	9c9fe0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201fd4:	00144797          	auipc	a5,0x144
ffffffffc0201fd8:	23c7b783          	ld	a5,572(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc0201fdc:	739c                	ld	a5,32(a5)
ffffffffc0201fde:	85a6                	mv	a1,s1
ffffffffc0201fe0:	8522                	mv	a0,s0
ffffffffc0201fe2:	9782                	jalr	a5
}
ffffffffc0201fe4:	6442                	ld	s0,16(sp)
ffffffffc0201fe6:	60e2                	ld	ra,24(sp)
ffffffffc0201fe8:	64a2                	ld	s1,8(sp)
ffffffffc0201fea:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201fec:	9a7fe06f          	j	ffffffffc0200992 <intr_enable>

ffffffffc0201ff0 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ff0:	100027f3          	csrr	a5,sstatus
ffffffffc0201ff4:	8b89                	andi	a5,a5,2
ffffffffc0201ff6:	e799                	bnez	a5,ffffffffc0202004 <nr_free_pages+0x14>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201ff8:	00144797          	auipc	a5,0x144
ffffffffc0201ffc:	2187b783          	ld	a5,536(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc0202000:	779c                	ld	a5,40(a5)
ffffffffc0202002:	8782                	jr	a5
{
ffffffffc0202004:	1141                	addi	sp,sp,-16
ffffffffc0202006:	e406                	sd	ra,8(sp)
ffffffffc0202008:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc020200a:	98ffe0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020200e:	00144797          	auipc	a5,0x144
ffffffffc0202012:	2027b783          	ld	a5,514(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc0202016:	779c                	ld	a5,40(a5)
ffffffffc0202018:	9782                	jalr	a5
ffffffffc020201a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020201c:	977fe0ef          	jal	ra,ffffffffc0200992 <intr_enable>
}
ffffffffc0202020:	60a2                	ld	ra,8(sp)
ffffffffc0202022:	8522                	mv	a0,s0
ffffffffc0202024:	6402                	ld	s0,0(sp)
ffffffffc0202026:	0141                	addi	sp,sp,16
ffffffffc0202028:	8082                	ret

ffffffffc020202a <get_pte>:
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc020202a:	01e5d793          	srli	a5,a1,0x1e
ffffffffc020202e:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0202032:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202034:	078e                	slli	a5,a5,0x3
{
ffffffffc0202036:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202038:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc020203c:	6094                	ld	a3,0(s1)
{
ffffffffc020203e:	f04a                	sd	s2,32(sp)
ffffffffc0202040:	ec4e                	sd	s3,24(sp)
ffffffffc0202042:	e852                	sd	s4,16(sp)
ffffffffc0202044:	fc06                	sd	ra,56(sp)
ffffffffc0202046:	f822                	sd	s0,48(sp)
ffffffffc0202048:	e456                	sd	s5,8(sp)
ffffffffc020204a:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc020204c:	0016f793          	andi	a5,a3,1
{
ffffffffc0202050:	892e                	mv	s2,a1
ffffffffc0202052:	8a32                	mv	s4,a2
ffffffffc0202054:	00144997          	auipc	s3,0x144
ffffffffc0202058:	1ac98993          	addi	s3,s3,428 # ffffffffc0346200 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc020205c:	efbd                	bnez	a5,ffffffffc02020da <get_pte+0xb0>
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020205e:	14060c63          	beqz	a2,ffffffffc02021b6 <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202062:	100027f3          	csrr	a5,sstatus
ffffffffc0202066:	8b89                	andi	a5,a5,2
ffffffffc0202068:	14079963          	bnez	a5,ffffffffc02021ba <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc020206c:	00144797          	auipc	a5,0x144
ffffffffc0202070:	1a47b783          	ld	a5,420(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc0202074:	6f9c                	ld	a5,24(a5)
ffffffffc0202076:	4505                	li	a0,1
ffffffffc0202078:	9782                	jalr	a5
ffffffffc020207a:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020207c:	12040d63          	beqz	s0,ffffffffc02021b6 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202080:	00144b17          	auipc	s6,0x144
ffffffffc0202084:	188b0b13          	addi	s6,s6,392 # ffffffffc0346208 <pages>
ffffffffc0202088:	000b3503          	ld	a0,0(s6)
ffffffffc020208c:	00080ab7          	lui	s5,0x80
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202090:	00144997          	auipc	s3,0x144
ffffffffc0202094:	17098993          	addi	s3,s3,368 # ffffffffc0346200 <npage>
ffffffffc0202098:	40a40533          	sub	a0,s0,a0
ffffffffc020209c:	8519                	srai	a0,a0,0x6
ffffffffc020209e:	9556                	add	a0,a0,s5
ffffffffc02020a0:	0009b703          	ld	a4,0(s3)
ffffffffc02020a4:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc02020a8:	4685                	li	a3,1
ffffffffc02020aa:	c014                	sw	a3,0(s0)
ffffffffc02020ac:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02020ae:	0532                	slli	a0,a0,0xc
ffffffffc02020b0:	16e7f763          	bgeu	a5,a4,ffffffffc020221e <get_pte+0x1f4>
ffffffffc02020b4:	00144797          	auipc	a5,0x144
ffffffffc02020b8:	1647b783          	ld	a5,356(a5) # ffffffffc0346218 <va_pa_offset>
ffffffffc02020bc:	6605                	lui	a2,0x1
ffffffffc02020be:	4581                	li	a1,0
ffffffffc02020c0:	953e                	add	a0,a0,a5
ffffffffc02020c2:	1ea040ef          	jal	ra,ffffffffc02062ac <memset>
    return page - pages + nbase;
ffffffffc02020c6:	000b3683          	ld	a3,0(s6)
ffffffffc02020ca:	40d406b3          	sub	a3,s0,a3
ffffffffc02020ce:	8699                	srai	a3,a3,0x6
ffffffffc02020d0:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02020d2:	06aa                	slli	a3,a3,0xa
ffffffffc02020d4:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02020d8:	e094                	sd	a3,0(s1)
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02020da:	77fd                	lui	a5,0xfffff
ffffffffc02020dc:	068a                	slli	a3,a3,0x2
ffffffffc02020de:	0009b703          	ld	a4,0(s3)
ffffffffc02020e2:	8efd                	and	a3,a3,a5
ffffffffc02020e4:	00c6d793          	srli	a5,a3,0xc
ffffffffc02020e8:	10e7ff63          	bgeu	a5,a4,ffffffffc0202206 <get_pte+0x1dc>
ffffffffc02020ec:	00144a97          	auipc	s5,0x144
ffffffffc02020f0:	12ca8a93          	addi	s5,s5,300 # ffffffffc0346218 <va_pa_offset>
ffffffffc02020f4:	000ab403          	ld	s0,0(s5)
ffffffffc02020f8:	01595793          	srli	a5,s2,0x15
ffffffffc02020fc:	1ff7f793          	andi	a5,a5,511
ffffffffc0202100:	96a2                	add	a3,a3,s0
ffffffffc0202102:	00379413          	slli	s0,a5,0x3
ffffffffc0202106:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0202108:	6014                	ld	a3,0(s0)
ffffffffc020210a:	0016f793          	andi	a5,a3,1
ffffffffc020210e:	ebad                	bnez	a5,ffffffffc0202180 <get_pte+0x156>
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202110:	0a0a0363          	beqz	s4,ffffffffc02021b6 <get_pte+0x18c>
ffffffffc0202114:	100027f3          	csrr	a5,sstatus
ffffffffc0202118:	8b89                	andi	a5,a5,2
ffffffffc020211a:	efcd                	bnez	a5,ffffffffc02021d4 <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc020211c:	00144797          	auipc	a5,0x144
ffffffffc0202120:	0f47b783          	ld	a5,244(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc0202124:	6f9c                	ld	a5,24(a5)
ffffffffc0202126:	4505                	li	a0,1
ffffffffc0202128:	9782                	jalr	a5
ffffffffc020212a:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020212c:	c4c9                	beqz	s1,ffffffffc02021b6 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc020212e:	00144b17          	auipc	s6,0x144
ffffffffc0202132:	0dab0b13          	addi	s6,s6,218 # ffffffffc0346208 <pages>
ffffffffc0202136:	000b3503          	ld	a0,0(s6)
ffffffffc020213a:	00080a37          	lui	s4,0x80
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020213e:	0009b703          	ld	a4,0(s3)
ffffffffc0202142:	40a48533          	sub	a0,s1,a0
ffffffffc0202146:	8519                	srai	a0,a0,0x6
ffffffffc0202148:	9552                	add	a0,a0,s4
ffffffffc020214a:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc020214e:	4685                	li	a3,1
ffffffffc0202150:	c094                	sw	a3,0(s1)
ffffffffc0202152:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202154:	0532                	slli	a0,a0,0xc
ffffffffc0202156:	0ee7f163          	bgeu	a5,a4,ffffffffc0202238 <get_pte+0x20e>
ffffffffc020215a:	000ab783          	ld	a5,0(s5)
ffffffffc020215e:	6605                	lui	a2,0x1
ffffffffc0202160:	4581                	li	a1,0
ffffffffc0202162:	953e                	add	a0,a0,a5
ffffffffc0202164:	148040ef          	jal	ra,ffffffffc02062ac <memset>
    return page - pages + nbase;
ffffffffc0202168:	000b3683          	ld	a3,0(s6)
ffffffffc020216c:	40d486b3          	sub	a3,s1,a3
ffffffffc0202170:	8699                	srai	a3,a3,0x6
ffffffffc0202172:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202174:	06aa                	slli	a3,a3,0xa
ffffffffc0202176:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020217a:	e014                	sd	a3,0(s0)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020217c:	0009b703          	ld	a4,0(s3)
ffffffffc0202180:	068a                	slli	a3,a3,0x2
ffffffffc0202182:	757d                	lui	a0,0xfffff
ffffffffc0202184:	8ee9                	and	a3,a3,a0
ffffffffc0202186:	00c6d793          	srli	a5,a3,0xc
ffffffffc020218a:	06e7f263          	bgeu	a5,a4,ffffffffc02021ee <get_pte+0x1c4>
ffffffffc020218e:	000ab503          	ld	a0,0(s5)
ffffffffc0202192:	00c95913          	srli	s2,s2,0xc
ffffffffc0202196:	1ff97913          	andi	s2,s2,511
ffffffffc020219a:	96aa                	add	a3,a3,a0
ffffffffc020219c:	00391513          	slli	a0,s2,0x3
ffffffffc02021a0:	9536                	add	a0,a0,a3
}
ffffffffc02021a2:	70e2                	ld	ra,56(sp)
ffffffffc02021a4:	7442                	ld	s0,48(sp)
ffffffffc02021a6:	74a2                	ld	s1,40(sp)
ffffffffc02021a8:	7902                	ld	s2,32(sp)
ffffffffc02021aa:	69e2                	ld	s3,24(sp)
ffffffffc02021ac:	6a42                	ld	s4,16(sp)
ffffffffc02021ae:	6aa2                	ld	s5,8(sp)
ffffffffc02021b0:	6b02                	ld	s6,0(sp)
ffffffffc02021b2:	6121                	addi	sp,sp,64
ffffffffc02021b4:	8082                	ret
            return NULL;
ffffffffc02021b6:	4501                	li	a0,0
ffffffffc02021b8:	b7ed                	j	ffffffffc02021a2 <get_pte+0x178>
        intr_disable();
ffffffffc02021ba:	fdefe0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02021be:	00144797          	auipc	a5,0x144
ffffffffc02021c2:	0527b783          	ld	a5,82(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc02021c6:	6f9c                	ld	a5,24(a5)
ffffffffc02021c8:	4505                	li	a0,1
ffffffffc02021ca:	9782                	jalr	a5
ffffffffc02021cc:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02021ce:	fc4fe0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc02021d2:	b56d                	j	ffffffffc020207c <get_pte+0x52>
        intr_disable();
ffffffffc02021d4:	fc4fe0ef          	jal	ra,ffffffffc0200998 <intr_disable>
ffffffffc02021d8:	00144797          	auipc	a5,0x144
ffffffffc02021dc:	0387b783          	ld	a5,56(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc02021e0:	6f9c                	ld	a5,24(a5)
ffffffffc02021e2:	4505                	li	a0,1
ffffffffc02021e4:	9782                	jalr	a5
ffffffffc02021e6:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc02021e8:	faafe0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc02021ec:	b781                	j	ffffffffc020212c <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02021ee:	00005617          	auipc	a2,0x5
ffffffffc02021f2:	1ea60613          	addi	a2,a2,490 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc02021f6:	0fa00593          	li	a1,250
ffffffffc02021fa:	00005517          	auipc	a0,0x5
ffffffffc02021fe:	2be50513          	addi	a0,a0,702 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0202202:	a76fe0ef          	jal	ra,ffffffffc0200478 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202206:	00005617          	auipc	a2,0x5
ffffffffc020220a:	1d260613          	addi	a2,a2,466 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc020220e:	0ed00593          	li	a1,237
ffffffffc0202212:	00005517          	auipc	a0,0x5
ffffffffc0202216:	2a650513          	addi	a0,a0,678 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc020221a:	a5efe0ef          	jal	ra,ffffffffc0200478 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020221e:	86aa                	mv	a3,a0
ffffffffc0202220:	00005617          	auipc	a2,0x5
ffffffffc0202224:	1b860613          	addi	a2,a2,440 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0202228:	0e900593          	li	a1,233
ffffffffc020222c:	00005517          	auipc	a0,0x5
ffffffffc0202230:	28c50513          	addi	a0,a0,652 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0202234:	a44fe0ef          	jal	ra,ffffffffc0200478 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202238:	86aa                	mv	a3,a0
ffffffffc020223a:	00005617          	auipc	a2,0x5
ffffffffc020223e:	19e60613          	addi	a2,a2,414 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0202242:	0f700593          	li	a1,247
ffffffffc0202246:	00005517          	auipc	a0,0x5
ffffffffc020224a:	27250513          	addi	a0,a0,626 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc020224e:	a2afe0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0202252 <unmap_range>:
        tlb_invalidate(pgdir, la); //(6) flush tlb
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc0202252:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202254:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202258:	fc86                	sd	ra,120(sp)
ffffffffc020225a:	f8a2                	sd	s0,112(sp)
ffffffffc020225c:	f4a6                	sd	s1,104(sp)
ffffffffc020225e:	f0ca                	sd	s2,96(sp)
ffffffffc0202260:	ecce                	sd	s3,88(sp)
ffffffffc0202262:	e8d2                	sd	s4,80(sp)
ffffffffc0202264:	e4d6                	sd	s5,72(sp)
ffffffffc0202266:	e0da                	sd	s6,64(sp)
ffffffffc0202268:	fc5e                	sd	s7,56(sp)
ffffffffc020226a:	f862                	sd	s8,48(sp)
ffffffffc020226c:	f466                	sd	s9,40(sp)
ffffffffc020226e:	f06a                	sd	s10,32(sp)
ffffffffc0202270:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202272:	17d2                	slli	a5,a5,0x34
ffffffffc0202274:	16079a63          	bnez	a5,ffffffffc02023e8 <unmap_range+0x196>
    assert(USER_ACCESS(start, end));
ffffffffc0202278:	002007b7          	lui	a5,0x200
ffffffffc020227c:	842e                	mv	s0,a1
ffffffffc020227e:	14f5e563          	bltu	a1,a5,ffffffffc02023c8 <unmap_range+0x176>
ffffffffc0202282:	8932                	mv	s2,a2
ffffffffc0202284:	14c5f263          	bgeu	a1,a2,ffffffffc02023c8 <unmap_range+0x176>
ffffffffc0202288:	4785                	li	a5,1
ffffffffc020228a:	07fe                	slli	a5,a5,0x1f
ffffffffc020228c:	12c7ee63          	bltu	a5,a2,ffffffffc02023c8 <unmap_range+0x176>
ffffffffc0202290:	89aa                	mv	s3,a0
    do
    {
        pte_t *ptep = get_pte(pgdir, start, 0);
        if (ptep == NULL)
        {
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202292:	00200cb7          	lui	s9,0x200
ffffffffc0202296:	ffe00c37          	lui	s8,0xffe00
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020229a:	7afd                	lui	s5,0xfffff
ffffffffc020229c:	00144b17          	auipc	s6,0x144
ffffffffc02022a0:	f64b0b13          	addi	s6,s6,-156 # ffffffffc0346200 <npage>
ffffffffc02022a4:	00144b97          	auipc	s7,0x144
ffffffffc02022a8:	f74b8b93          	addi	s7,s7,-140 # ffffffffc0346218 <va_pa_offset>
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc02022ac:	6a05                	lui	s4,0x1
    return &pages[PPN(pa) - nbase];
ffffffffc02022ae:	00144d17          	auipc	s10,0x144
ffffffffc02022b2:	f5ad0d13          	addi	s10,s10,-166 # ffffffffc0346208 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc02022b6:	00144d97          	auipc	s11,0x144
ffffffffc02022ba:	f5ad8d93          	addi	s11,s11,-166 # ffffffffc0346210 <pmm_manager>
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02022be:	01e45793          	srli	a5,s0,0x1e
ffffffffc02022c2:	1ff7f793          	andi	a5,a5,511
    if (!(*pdep1 & PTE_V))
ffffffffc02022c6:	078e                	slli	a5,a5,0x3
ffffffffc02022c8:	97ce                	add	a5,a5,s3
ffffffffc02022ca:	639c                	ld	a5,0(a5)
ffffffffc02022cc:	0017f713          	andi	a4,a5,1
ffffffffc02022d0:	e715                	bnez	a4,ffffffffc02022fc <unmap_range+0xaa>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02022d2:	9466                	add	s0,s0,s9
ffffffffc02022d4:	01847433          	and	s0,s0,s8
    } while (start != 0 && start < end);
ffffffffc02022d8:	c019                	beqz	s0,ffffffffc02022de <unmap_range+0x8c>
ffffffffc02022da:	ff2462e3          	bltu	s0,s2,ffffffffc02022be <unmap_range+0x6c>
}
ffffffffc02022de:	70e6                	ld	ra,120(sp)
ffffffffc02022e0:	7446                	ld	s0,112(sp)
ffffffffc02022e2:	74a6                	ld	s1,104(sp)
ffffffffc02022e4:	7906                	ld	s2,96(sp)
ffffffffc02022e6:	69e6                	ld	s3,88(sp)
ffffffffc02022e8:	6a46                	ld	s4,80(sp)
ffffffffc02022ea:	6aa6                	ld	s5,72(sp)
ffffffffc02022ec:	6b06                	ld	s6,64(sp)
ffffffffc02022ee:	7be2                	ld	s7,56(sp)
ffffffffc02022f0:	7c42                	ld	s8,48(sp)
ffffffffc02022f2:	7ca2                	ld	s9,40(sp)
ffffffffc02022f4:	7d02                	ld	s10,32(sp)
ffffffffc02022f6:	6de2                	ld	s11,24(sp)
ffffffffc02022f8:	6109                	addi	sp,sp,128
ffffffffc02022fa:	8082                	ret
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02022fc:	078a                	slli	a5,a5,0x2
ffffffffc02022fe:	000b3703          	ld	a4,0(s6)
ffffffffc0202302:	0157f6b3          	and	a3,a5,s5
ffffffffc0202306:	00c6d793          	srli	a5,a3,0xc
ffffffffc020230a:	0ae7f363          	bgeu	a5,a4,ffffffffc02023b0 <unmap_range+0x15e>
ffffffffc020230e:	01545793          	srli	a5,s0,0x15
ffffffffc0202312:	000bb603          	ld	a2,0(s7)
ffffffffc0202316:	1ff7f793          	andi	a5,a5,511
    if (!(*pdep0 & PTE_V))
ffffffffc020231a:	078e                	slli	a5,a5,0x3
ffffffffc020231c:	97b6                	add	a5,a5,a3
ffffffffc020231e:	97b2                	add	a5,a5,a2
ffffffffc0202320:	6394                	ld	a3,0(a5)
ffffffffc0202322:	0016f793          	andi	a5,a3,1
ffffffffc0202326:	d7d5                	beqz	a5,ffffffffc02022d2 <unmap_range+0x80>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202328:	068a                	slli	a3,a3,0x2
ffffffffc020232a:	0156f6b3          	and	a3,a3,s5
ffffffffc020232e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202332:	0ce7fb63          	bgeu	a5,a4,ffffffffc0202408 <unmap_range+0x1b6>
ffffffffc0202336:	00c45493          	srli	s1,s0,0xc
ffffffffc020233a:	1ff4f493          	andi	s1,s1,511
ffffffffc020233e:	96b2                	add	a3,a3,a2
ffffffffc0202340:	048e                	slli	s1,s1,0x3
ffffffffc0202342:	94b6                	add	s1,s1,a3
        if (ptep == NULL)
ffffffffc0202344:	d4d9                	beqz	s1,ffffffffc02022d2 <unmap_range+0x80>
        if (*ptep != 0)
ffffffffc0202346:	609c                	ld	a5,0(s1)
ffffffffc0202348:	e789                	bnez	a5,ffffffffc0202352 <unmap_range+0x100>
        start += PGSIZE;
ffffffffc020234a:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc020234c:	f72469e3          	bltu	s0,s2,ffffffffc02022be <unmap_range+0x6c>
ffffffffc0202350:	b779                	j	ffffffffc02022de <unmap_range+0x8c>
    if (*ptep & PTE_V)
ffffffffc0202352:	0017f693          	andi	a3,a5,1
ffffffffc0202356:	daf5                	beqz	a3,ffffffffc020234a <unmap_range+0xf8>
    return pa2page(PTE_ADDR(pte));
ffffffffc0202358:	078a                	slli	a5,a5,0x2
ffffffffc020235a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020235c:	0ce7f263          	bgeu	a5,a4,ffffffffc0202420 <unmap_range+0x1ce>
    return &pages[PPN(pa) - nbase];
ffffffffc0202360:	000d3503          	ld	a0,0(s10)
ffffffffc0202364:	fff80737          	lui	a4,0xfff80
ffffffffc0202368:	97ba                	add	a5,a5,a4
ffffffffc020236a:	079a                	slli	a5,a5,0x6
ffffffffc020236c:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020236e:	411c                	lw	a5,0(a0)
ffffffffc0202370:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202374:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202376:	c719                	beqz	a4,ffffffffc0202384 <unmap_range+0x132>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc0202378:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020237c:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202380:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202382:	b7e9                	j	ffffffffc020234c <unmap_range+0xfa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202384:	100027f3          	csrr	a5,sstatus
ffffffffc0202388:	8b89                	andi	a5,a5,2
ffffffffc020238a:	e799                	bnez	a5,ffffffffc0202398 <unmap_range+0x146>
        pmm_manager->free_pages(base, n);
ffffffffc020238c:	000db783          	ld	a5,0(s11)
ffffffffc0202390:	4585                	li	a1,1
ffffffffc0202392:	739c                	ld	a5,32(a5)
ffffffffc0202394:	9782                	jalr	a5
    if (flag)
ffffffffc0202396:	b7cd                	j	ffffffffc0202378 <unmap_range+0x126>
ffffffffc0202398:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020239a:	dfefe0ef          	jal	ra,ffffffffc0200998 <intr_disable>
ffffffffc020239e:	000db783          	ld	a5,0(s11)
ffffffffc02023a2:	6522                	ld	a0,8(sp)
ffffffffc02023a4:	4585                	li	a1,1
ffffffffc02023a6:	739c                	ld	a5,32(a5)
ffffffffc02023a8:	9782                	jalr	a5
        intr_enable();
ffffffffc02023aa:	de8fe0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc02023ae:	b7e9                	j	ffffffffc0202378 <unmap_range+0x126>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02023b0:	00005617          	auipc	a2,0x5
ffffffffc02023b4:	02860613          	addi	a2,a2,40 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc02023b8:	0ed00593          	li	a1,237
ffffffffc02023bc:	00005517          	auipc	a0,0x5
ffffffffc02023c0:	0fc50513          	addi	a0,a0,252 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02023c4:	8b4fe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02023c8:	00005697          	auipc	a3,0x5
ffffffffc02023cc:	13068693          	addi	a3,a3,304 # ffffffffc02074f8 <default_pmm_manager+0x190>
ffffffffc02023d0:	00005617          	auipc	a2,0x5
ffffffffc02023d4:	be860613          	addi	a2,a2,-1048 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02023d8:	12300593          	li	a1,291
ffffffffc02023dc:	00005517          	auipc	a0,0x5
ffffffffc02023e0:	0dc50513          	addi	a0,a0,220 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02023e4:	894fe0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02023e8:	00005697          	auipc	a3,0x5
ffffffffc02023ec:	0e068693          	addi	a3,a3,224 # ffffffffc02074c8 <default_pmm_manager+0x160>
ffffffffc02023f0:	00005617          	auipc	a2,0x5
ffffffffc02023f4:	bc860613          	addi	a2,a2,-1080 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02023f8:	12200593          	li	a1,290
ffffffffc02023fc:	00005517          	auipc	a0,0x5
ffffffffc0202400:	0bc50513          	addi	a0,a0,188 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0202404:	874fe0ef          	jal	ra,ffffffffc0200478 <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202408:	00005617          	auipc	a2,0x5
ffffffffc020240c:	fd060613          	addi	a2,a2,-48 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0202410:	0fa00593          	li	a1,250
ffffffffc0202414:	00005517          	auipc	a0,0x5
ffffffffc0202418:	0a450513          	addi	a0,a0,164 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc020241c:	85cfe0ef          	jal	ra,ffffffffc0200478 <__panic>
ffffffffc0202420:	a73ff0ef          	jal	ra,ffffffffc0201e92 <pa2page.part.0>

ffffffffc0202424 <exit_range>:
{
ffffffffc0202424:	7175                	addi	sp,sp,-144
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202426:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020242a:	e506                	sd	ra,136(sp)
ffffffffc020242c:	e122                	sd	s0,128(sp)
ffffffffc020242e:	fca6                	sd	s1,120(sp)
ffffffffc0202430:	f8ca                	sd	s2,112(sp)
ffffffffc0202432:	f4ce                	sd	s3,104(sp)
ffffffffc0202434:	f0d2                	sd	s4,96(sp)
ffffffffc0202436:	ecd6                	sd	s5,88(sp)
ffffffffc0202438:	e8da                	sd	s6,80(sp)
ffffffffc020243a:	e4de                	sd	s7,72(sp)
ffffffffc020243c:	e0e2                	sd	s8,64(sp)
ffffffffc020243e:	fc66                	sd	s9,56(sp)
ffffffffc0202440:	f86a                	sd	s10,48(sp)
ffffffffc0202442:	f46e                	sd	s11,40(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202444:	17d2                	slli	a5,a5,0x34
ffffffffc0202446:	20079663          	bnez	a5,ffffffffc0202652 <exit_range+0x22e>
    assert(USER_ACCESS(start, end));
ffffffffc020244a:	002007b7          	lui	a5,0x200
ffffffffc020244e:	24f5ea63          	bltu	a1,a5,ffffffffc02026a2 <exit_range+0x27e>
ffffffffc0202452:	8c32                	mv	s8,a2
ffffffffc0202454:	24c5f763          	bgeu	a1,a2,ffffffffc02026a2 <exit_range+0x27e>
ffffffffc0202458:	4785                	li	a5,1
ffffffffc020245a:	07fe                	slli	a5,a5,0x1f
ffffffffc020245c:	24c7e363          	bltu	a5,a2,ffffffffc02026a2 <exit_range+0x27e>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc0202460:	c0000b37          	lui	s6,0xc0000
ffffffffc0202464:	0165fb33          	and	s6,a1,s6
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202468:	ffe004b7          	lui	s1,0xffe00
ffffffffc020246c:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc0202470:	567d                	li	a2,-1
ffffffffc0202472:	8e2a                	mv	t3,a0
ffffffffc0202474:	8ced                	and	s1,s1,a1
ffffffffc0202476:	9b3e                	add	s6,s6,a5
    if (PPN(pa) >= npage)
ffffffffc0202478:	00144717          	auipc	a4,0x144
ffffffffc020247c:	d8870713          	addi	a4,a4,-632 # ffffffffc0346200 <npage>
    return KADDR(page2pa(page));
ffffffffc0202480:	00c65a13          	srli	s4,a2,0xc
        pmm_manager->free_pages(base, n);
ffffffffc0202484:	00144997          	auipc	s3,0x144
ffffffffc0202488:	d8c98993          	addi	s3,s3,-628 # ffffffffc0346210 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc020248c:	c0000ab7          	lui	s5,0xc0000
ffffffffc0202490:	9ada                	add	s5,s5,s6
ffffffffc0202492:	01eada93          	srli	s5,s5,0x1e
ffffffffc0202496:	1ffafa93          	andi	s5,s5,511
ffffffffc020249a:	0a8e                	slli	s5,s5,0x3
ffffffffc020249c:	9af2                	add	s5,s5,t3
ffffffffc020249e:	000abc83          	ld	s9,0(s5) # ffffffffc0000000 <_binary_obj___user_matrix_out_size+0xffffffffbffe9480>
        if (pde1 & PTE_V)
ffffffffc02024a2:	001cf793          	andi	a5,s9,1
ffffffffc02024a6:	eb99                	bnez	a5,ffffffffc02024bc <exit_range+0x98>
    } while (d1start != 0 && d1start < end);
ffffffffc02024a8:	120b0763          	beqz	s6,ffffffffc02025d6 <exit_range+0x1b2>
ffffffffc02024ac:	400007b7          	lui	a5,0x40000
ffffffffc02024b0:	97da                	add	a5,a5,s6
ffffffffc02024b2:	84da                	mv	s1,s6
ffffffffc02024b4:	138b7163          	bgeu	s6,s8,ffffffffc02025d6 <exit_range+0x1b2>
ffffffffc02024b8:	8b3e                	mv	s6,a5
ffffffffc02024ba:	bfc9                	j	ffffffffc020248c <exit_range+0x68>
    if (PPN(pa) >= npage)
ffffffffc02024bc:	631c                	ld	a5,0(a4)
    return pa2page(PDE_ADDR(pde));
ffffffffc02024be:	0c8a                	slli	s9,s9,0x2
ffffffffc02024c0:	00ccdc93          	srli	s9,s9,0xc
    if (PPN(pa) >= npage)
ffffffffc02024c4:	1cfcf363          	bgeu	s9,a5,ffffffffc020268a <exit_range+0x266>
    return &pages[PPN(pa) - nbase];
ffffffffc02024c8:	fff80937          	lui	s2,0xfff80
ffffffffc02024cc:	9966                	add	s2,s2,s9
    return page - pages + nbase;
ffffffffc02024ce:	000806b7          	lui	a3,0x80
ffffffffc02024d2:	96ca                	add	a3,a3,s2
    return &pages[PPN(pa) - nbase];
ffffffffc02024d4:	00691613          	slli	a2,s2,0x6
    return KADDR(page2pa(page));
ffffffffc02024d8:	0146f5b3          	and	a1,a3,s4
    return &pages[PPN(pa) - nbase];
ffffffffc02024dc:	e832                	sd	a2,16(sp)
    return page2ppn(page) << PGSHIFT;
ffffffffc02024de:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02024e0:	18f5f963          	bgeu	a1,a5,ffffffffc0202672 <exit_range+0x24e>
ffffffffc02024e4:	00144d97          	auipc	s11,0x144
ffffffffc02024e8:	d34d8d93          	addi	s11,s11,-716 # ffffffffc0346218 <va_pa_offset>
ffffffffc02024ec:	000dbb83          	ld	s7,0(s11)
            free_pd0 = 1;
ffffffffc02024f0:	4d05                	li	s10,1
    return &pages[PPN(pa) - nbase];
ffffffffc02024f2:	fff80337          	lui	t1,0xfff80
    return KADDR(page2pa(page));
ffffffffc02024f6:	9bb6                	add	s7,s7,a3
    return page - pages + nbase;
ffffffffc02024f8:	000808b7          	lui	a7,0x80
ffffffffc02024fc:	6905                	lui	s2,0x1
ffffffffc02024fe:	a811                	j	ffffffffc0202512 <exit_range+0xee>
                    free_pd0 = 0;
ffffffffc0202500:	4d01                	li	s10,0
                d0start += PTSIZE;
ffffffffc0202502:	002007b7          	lui	a5,0x200
ffffffffc0202506:	94be                	add	s1,s1,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202508:	c8c1                	beqz	s1,ffffffffc0202598 <exit_range+0x174>
ffffffffc020250a:	0964f763          	bgeu	s1,s6,ffffffffc0202598 <exit_range+0x174>
ffffffffc020250e:	1184fb63          	bgeu	s1,s8,ffffffffc0202624 <exit_range+0x200>
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202512:	0154d413          	srli	s0,s1,0x15
ffffffffc0202516:	1ff47413          	andi	s0,s0,511
ffffffffc020251a:	040e                	slli	s0,s0,0x3
ffffffffc020251c:	945e                	add	s0,s0,s7
ffffffffc020251e:	601c                	ld	a5,0(s0)
                if (pde0 & PTE_V)
ffffffffc0202520:	0017f693          	andi	a3,a5,1
ffffffffc0202524:	def1                	beqz	a3,ffffffffc0202500 <exit_range+0xdc>
    if (PPN(pa) >= npage)
ffffffffc0202526:	630c                	ld	a1,0(a4)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202528:	078a                	slli	a5,a5,0x2
ffffffffc020252a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020252c:	14b7ff63          	bgeu	a5,a1,ffffffffc020268a <exit_range+0x266>
    return &pages[PPN(pa) - nbase];
ffffffffc0202530:	979a                	add	a5,a5,t1
    return page - pages + nbase;
ffffffffc0202532:	011786b3          	add	a3,a5,a7
    return KADDR(page2pa(page));
ffffffffc0202536:	0146feb3          	and	t4,a3,s4
    return &pages[PPN(pa) - nbase];
ffffffffc020253a:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc020253e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202540:	12bef963          	bgeu	t4,a1,ffffffffc0202672 <exit_range+0x24e>
ffffffffc0202544:	000db783          	ld	a5,0(s11)
ffffffffc0202548:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc020254a:	012685b3          	add	a1,a3,s2
                        if (pt[i] & PTE_V)
ffffffffc020254e:	629c                	ld	a5,0(a3)
ffffffffc0202550:	8b85                	andi	a5,a5,1
ffffffffc0202552:	fbc5                	bnez	a5,ffffffffc0202502 <exit_range+0xde>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202554:	06a1                	addi	a3,a3,8
ffffffffc0202556:	fed59ce3          	bne	a1,a3,ffffffffc020254e <exit_range+0x12a>
    return &pages[PPN(pa) - nbase];
ffffffffc020255a:	00144797          	auipc	a5,0x144
ffffffffc020255e:	cae78793          	addi	a5,a5,-850 # ffffffffc0346208 <pages>
ffffffffc0202562:	639c                	ld	a5,0(a5)
ffffffffc0202564:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202566:	100027f3          	csrr	a5,sstatus
ffffffffc020256a:	8b89                	andi	a5,a5,2
ffffffffc020256c:	e7c1                	bnez	a5,ffffffffc02025f4 <exit_range+0x1d0>
        pmm_manager->free_pages(base, n);
ffffffffc020256e:	0009b783          	ld	a5,0(s3)
ffffffffc0202572:	4585                	li	a1,1
ffffffffc0202574:	e472                	sd	t3,8(sp)
ffffffffc0202576:	739c                	ld	a5,32(a5)
ffffffffc0202578:	9782                	jalr	a5
    if (flag)
ffffffffc020257a:	6e22                	ld	t3,8(sp)
ffffffffc020257c:	fff80337          	lui	t1,0xfff80
ffffffffc0202580:	000808b7          	lui	a7,0x80
ffffffffc0202584:	00144717          	auipc	a4,0x144
ffffffffc0202588:	c7c70713          	addi	a4,a4,-900 # ffffffffc0346200 <npage>
                        pd0[PDX0(d0start)] = 0;
ffffffffc020258c:	00043023          	sd	zero,0(s0)
                d0start += PTSIZE;
ffffffffc0202590:	002007b7          	lui	a5,0x200
ffffffffc0202594:	94be                	add	s1,s1,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202596:	f8b5                	bnez	s1,ffffffffc020250a <exit_range+0xe6>
            if (free_pd0)
ffffffffc0202598:	f00d08e3          	beqz	s10,ffffffffc02024a8 <exit_range+0x84>
    if (PPN(pa) >= npage)
ffffffffc020259c:	631c                	ld	a5,0(a4)
ffffffffc020259e:	0efcf663          	bgeu	s9,a5,ffffffffc020268a <exit_range+0x266>
    return &pages[PPN(pa) - nbase];
ffffffffc02025a2:	00144797          	auipc	a5,0x144
ffffffffc02025a6:	c6678793          	addi	a5,a5,-922 # ffffffffc0346208 <pages>
ffffffffc02025aa:	6388                	ld	a0,0(a5)
ffffffffc02025ac:	67c2                	ld	a5,16(sp)
ffffffffc02025ae:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02025b0:	100027f3          	csrr	a5,sstatus
ffffffffc02025b4:	8b89                	andi	a5,a5,2
ffffffffc02025b6:	ebb5                	bnez	a5,ffffffffc020262a <exit_range+0x206>
        pmm_manager->free_pages(base, n);
ffffffffc02025b8:	0009b783          	ld	a5,0(s3)
ffffffffc02025bc:	4585                	li	a1,1
ffffffffc02025be:	e472                	sd	t3,8(sp)
ffffffffc02025c0:	739c                	ld	a5,32(a5)
ffffffffc02025c2:	9782                	jalr	a5
ffffffffc02025c4:	6e22                	ld	t3,8(sp)
ffffffffc02025c6:	00144717          	auipc	a4,0x144
ffffffffc02025ca:	c3a70713          	addi	a4,a4,-966 # ffffffffc0346200 <npage>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02025ce:	000ab023          	sd	zero,0(s5)
    } while (d1start != 0 && d1start < end);
ffffffffc02025d2:	ec0b1de3          	bnez	s6,ffffffffc02024ac <exit_range+0x88>
}
ffffffffc02025d6:	60aa                	ld	ra,136(sp)
ffffffffc02025d8:	640a                	ld	s0,128(sp)
ffffffffc02025da:	74e6                	ld	s1,120(sp)
ffffffffc02025dc:	7946                	ld	s2,112(sp)
ffffffffc02025de:	79a6                	ld	s3,104(sp)
ffffffffc02025e0:	7a06                	ld	s4,96(sp)
ffffffffc02025e2:	6ae6                	ld	s5,88(sp)
ffffffffc02025e4:	6b46                	ld	s6,80(sp)
ffffffffc02025e6:	6ba6                	ld	s7,72(sp)
ffffffffc02025e8:	6c06                	ld	s8,64(sp)
ffffffffc02025ea:	7ce2                	ld	s9,56(sp)
ffffffffc02025ec:	7d42                	ld	s10,48(sp)
ffffffffc02025ee:	7da2                	ld	s11,40(sp)
ffffffffc02025f0:	6149                	addi	sp,sp,144
ffffffffc02025f2:	8082                	ret
ffffffffc02025f4:	ec72                	sd	t3,24(sp)
ffffffffc02025f6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02025f8:	ba0fe0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02025fc:	0009b783          	ld	a5,0(s3)
ffffffffc0202600:	6522                	ld	a0,8(sp)
ffffffffc0202602:	4585                	li	a1,1
ffffffffc0202604:	739c                	ld	a5,32(a5)
ffffffffc0202606:	9782                	jalr	a5
        intr_enable();
ffffffffc0202608:	b8afe0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc020260c:	6e62                	ld	t3,24(sp)
ffffffffc020260e:	00144717          	auipc	a4,0x144
ffffffffc0202612:	bf270713          	addi	a4,a4,-1038 # ffffffffc0346200 <npage>
ffffffffc0202616:	000808b7          	lui	a7,0x80
ffffffffc020261a:	fff80337          	lui	t1,0xfff80
                        pd0[PDX0(d0start)] = 0;
ffffffffc020261e:	00043023          	sd	zero,0(s0)
ffffffffc0202622:	b7bd                	j	ffffffffc0202590 <exit_range+0x16c>
            if (free_pd0)
ffffffffc0202624:	f60d1ce3          	bnez	s10,ffffffffc020259c <exit_range+0x178>
ffffffffc0202628:	b551                	j	ffffffffc02024ac <exit_range+0x88>
ffffffffc020262a:	e872                	sd	t3,16(sp)
ffffffffc020262c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020262e:	b6afe0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202632:	0009b783          	ld	a5,0(s3)
ffffffffc0202636:	6522                	ld	a0,8(sp)
ffffffffc0202638:	4585                	li	a1,1
ffffffffc020263a:	739c                	ld	a5,32(a5)
ffffffffc020263c:	9782                	jalr	a5
        intr_enable();
ffffffffc020263e:	b54fe0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0202642:	6e42                	ld	t3,16(sp)
ffffffffc0202644:	00144717          	auipc	a4,0x144
ffffffffc0202648:	bbc70713          	addi	a4,a4,-1092 # ffffffffc0346200 <npage>
                pgdir[PDX1(d1start)] = 0;
ffffffffc020264c:	000ab023          	sd	zero,0(s5)
ffffffffc0202650:	b749                	j	ffffffffc02025d2 <exit_range+0x1ae>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202652:	00005697          	auipc	a3,0x5
ffffffffc0202656:	e7668693          	addi	a3,a3,-394 # ffffffffc02074c8 <default_pmm_manager+0x160>
ffffffffc020265a:	00005617          	auipc	a2,0x5
ffffffffc020265e:	95e60613          	addi	a2,a2,-1698 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0202662:	13700593          	li	a1,311
ffffffffc0202666:	00005517          	auipc	a0,0x5
ffffffffc020266a:	e5250513          	addi	a0,a0,-430 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc020266e:	e0bfd0ef          	jal	ra,ffffffffc0200478 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202672:	00005617          	auipc	a2,0x5
ffffffffc0202676:	d6660613          	addi	a2,a2,-666 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc020267a:	07100593          	li	a1,113
ffffffffc020267e:	00005517          	auipc	a0,0x5
ffffffffc0202682:	d8250513          	addi	a0,a0,-638 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc0202686:	df3fd0ef          	jal	ra,ffffffffc0200478 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020268a:	00005617          	auipc	a2,0x5
ffffffffc020268e:	de660613          	addi	a2,a2,-538 # ffffffffc0207470 <default_pmm_manager+0x108>
ffffffffc0202692:	06900593          	li	a1,105
ffffffffc0202696:	00005517          	auipc	a0,0x5
ffffffffc020269a:	d6a50513          	addi	a0,a0,-662 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc020269e:	ddbfd0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02026a2:	00005697          	auipc	a3,0x5
ffffffffc02026a6:	e5668693          	addi	a3,a3,-426 # ffffffffc02074f8 <default_pmm_manager+0x190>
ffffffffc02026aa:	00005617          	auipc	a2,0x5
ffffffffc02026ae:	90e60613          	addi	a2,a2,-1778 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02026b2:	13800593          	li	a1,312
ffffffffc02026b6:	00005517          	auipc	a0,0x5
ffffffffc02026ba:	e0250513          	addi	a0,a0,-510 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02026be:	dbbfd0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc02026c2 <page_remove>:
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02026c2:	01e5d793          	srli	a5,a1,0x1e
ffffffffc02026c6:	1ff7f793          	andi	a5,a5,511
    if (!(*pdep1 & PTE_V))
ffffffffc02026ca:	078e                	slli	a5,a5,0x3
ffffffffc02026cc:	97aa                	add	a5,a5,a0
ffffffffc02026ce:	6394                	ld	a3,0(a5)
ffffffffc02026d0:	0016f793          	andi	a5,a3,1
ffffffffc02026d4:	cba5                	beqz	a5,ffffffffc0202744 <page_remove+0x82>
{
ffffffffc02026d6:	7179                	addi	sp,sp,-48
ffffffffc02026d8:	ec26                	sd	s1,24(sp)
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02026da:	068a                	slli	a3,a3,0x2
ffffffffc02026dc:	74fd                	lui	s1,0xfffff
ffffffffc02026de:	8ee5                	and	a3,a3,s1
{
ffffffffc02026e0:	f406                	sd	ra,40(sp)
ffffffffc02026e2:	f022                	sd	s0,32(sp)
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02026e4:	00144617          	auipc	a2,0x144
ffffffffc02026e8:	b1c63603          	ld	a2,-1252(a2) # ffffffffc0346200 <npage>
ffffffffc02026ec:	00c6d793          	srli	a5,a3,0xc
ffffffffc02026f0:	0cc7f063          	bgeu	a5,a2,ffffffffc02027b0 <page_remove+0xee>
ffffffffc02026f4:	0155d793          	srli	a5,a1,0x15
ffffffffc02026f8:	1ff7f793          	andi	a5,a5,511
    if (!(*pdep0 & PTE_V))
ffffffffc02026fc:	078e                	slli	a5,a5,0x3
ffffffffc02026fe:	96be                	add	a3,a3,a5
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202700:	00144717          	auipc	a4,0x144
ffffffffc0202704:	b1873703          	ld	a4,-1256(a4) # ffffffffc0346218 <va_pa_offset>
    if (!(*pdep0 & PTE_V))
ffffffffc0202708:	96ba                	add	a3,a3,a4
ffffffffc020270a:	6294                	ld	a3,0(a3)
ffffffffc020270c:	842e                	mv	s0,a1
ffffffffc020270e:	0016f793          	andi	a5,a3,1
ffffffffc0202712:	c785                	beqz	a5,ffffffffc020273a <page_remove+0x78>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202714:	068a                	slli	a3,a3,0x2
ffffffffc0202716:	8ee5                	and	a3,a3,s1
ffffffffc0202718:	00c6d793          	srli	a5,a3,0xc
ffffffffc020271c:	0ac7f863          	bgeu	a5,a2,ffffffffc02027cc <page_remove+0x10a>
ffffffffc0202720:	00c5d793          	srli	a5,a1,0xc
ffffffffc0202724:	1ff7f793          	andi	a5,a5,511
ffffffffc0202728:	9736                	add	a4,a4,a3
ffffffffc020272a:	00379493          	slli	s1,a5,0x3
ffffffffc020272e:	94ba                	add	s1,s1,a4
    if (ptep != NULL)
ffffffffc0202730:	c489                	beqz	s1,ffffffffc020273a <page_remove+0x78>
    if (*ptep & PTE_V)
ffffffffc0202732:	609c                	ld	a5,0(s1)
ffffffffc0202734:	0017f713          	andi	a4,a5,1
ffffffffc0202738:	e719                	bnez	a4,ffffffffc0202746 <page_remove+0x84>
}
ffffffffc020273a:	70a2                	ld	ra,40(sp)
ffffffffc020273c:	7402                	ld	s0,32(sp)
ffffffffc020273e:	64e2                	ld	s1,24(sp)
ffffffffc0202740:	6145                	addi	sp,sp,48
ffffffffc0202742:	8082                	ret
ffffffffc0202744:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202746:	078a                	slli	a5,a5,0x2
ffffffffc0202748:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020274a:	06c7ff63          	bgeu	a5,a2,ffffffffc02027c8 <page_remove+0x106>
    return &pages[PPN(pa) - nbase];
ffffffffc020274e:	fff80537          	lui	a0,0xfff80
ffffffffc0202752:	97aa                	add	a5,a5,a0
ffffffffc0202754:	079a                	slli	a5,a5,0x6
ffffffffc0202756:	00144517          	auipc	a0,0x144
ffffffffc020275a:	ab253503          	ld	a0,-1358(a0) # ffffffffc0346208 <pages>
ffffffffc020275e:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202760:	411c                	lw	a5,0(a0)
ffffffffc0202762:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202766:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202768:	cb11                	beqz	a4,ffffffffc020277c <page_remove+0xba>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc020276a:	0004b023          	sd	zero,0(s1) # fffffffffffff000 <end+0x3fcb8db0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020276e:	12040073          	sfence.vma	s0
}
ffffffffc0202772:	70a2                	ld	ra,40(sp)
ffffffffc0202774:	7402                	ld	s0,32(sp)
ffffffffc0202776:	64e2                	ld	s1,24(sp)
ffffffffc0202778:	6145                	addi	sp,sp,48
ffffffffc020277a:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020277c:	100027f3          	csrr	a5,sstatus
ffffffffc0202780:	8b89                	andi	a5,a5,2
ffffffffc0202782:	eb89                	bnez	a5,ffffffffc0202794 <page_remove+0xd2>
        pmm_manager->free_pages(base, n);
ffffffffc0202784:	00144797          	auipc	a5,0x144
ffffffffc0202788:	a8c7b783          	ld	a5,-1396(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc020278c:	739c                	ld	a5,32(a5)
ffffffffc020278e:	4585                	li	a1,1
ffffffffc0202790:	9782                	jalr	a5
    if (flag)
ffffffffc0202792:	bfe1                	j	ffffffffc020276a <page_remove+0xa8>
        intr_disable();
ffffffffc0202794:	e42a                	sd	a0,8(sp)
ffffffffc0202796:	a02fe0ef          	jal	ra,ffffffffc0200998 <intr_disable>
ffffffffc020279a:	00144797          	auipc	a5,0x144
ffffffffc020279e:	a767b783          	ld	a5,-1418(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc02027a2:	739c                	ld	a5,32(a5)
ffffffffc02027a4:	6522                	ld	a0,8(sp)
ffffffffc02027a6:	4585                	li	a1,1
ffffffffc02027a8:	9782                	jalr	a5
        intr_enable();
ffffffffc02027aa:	9e8fe0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc02027ae:	bf75                	j	ffffffffc020276a <page_remove+0xa8>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02027b0:	00005617          	auipc	a2,0x5
ffffffffc02027b4:	c2860613          	addi	a2,a2,-984 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc02027b8:	0ed00593          	li	a1,237
ffffffffc02027bc:	00005517          	auipc	a0,0x5
ffffffffc02027c0:	cfc50513          	addi	a0,a0,-772 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02027c4:	cb5fd0ef          	jal	ra,ffffffffc0200478 <__panic>
ffffffffc02027c8:	ecaff0ef          	jal	ra,ffffffffc0201e92 <pa2page.part.0>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02027cc:	00005617          	auipc	a2,0x5
ffffffffc02027d0:	c0c60613          	addi	a2,a2,-1012 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc02027d4:	0fa00593          	li	a1,250
ffffffffc02027d8:	00005517          	auipc	a0,0x5
ffffffffc02027dc:	ce050513          	addi	a0,a0,-800 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02027e0:	c99fd0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc02027e4 <page_insert>:
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02027e4:	01e65793          	srli	a5,a2,0x1e
ffffffffc02027e8:	1ff7f793          	andi	a5,a5,511
{
ffffffffc02027ec:	711d                	addi	sp,sp,-96
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02027ee:	078e                	slli	a5,a5,0x3
{
ffffffffc02027f0:	f852                	sd	s4,48(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02027f2:	00f50a33          	add	s4,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc02027f6:	000a3783          	ld	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x103a8>
{
ffffffffc02027fa:	e4a6                	sd	s1,72(sp)
ffffffffc02027fc:	e0ca                	sd	s2,64(sp)
ffffffffc02027fe:	fc4e                	sd	s3,56(sp)
ffffffffc0202800:	f456                	sd	s5,40(sp)
ffffffffc0202802:	ec86                	sd	ra,88(sp)
ffffffffc0202804:	e8a2                	sd	s0,80(sp)
ffffffffc0202806:	f05a                	sd	s6,32(sp)
ffffffffc0202808:	ec5e                	sd	s7,24(sp)
ffffffffc020280a:	e862                	sd	s8,16(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc020280c:	0017f713          	andi	a4,a5,1
{
ffffffffc0202810:	8932                	mv	s2,a2
ffffffffc0202812:	89ae                	mv	s3,a1
ffffffffc0202814:	84b6                	mv	s1,a3
ffffffffc0202816:	00144a97          	auipc	s5,0x144
ffffffffc020281a:	9eaa8a93          	addi	s5,s5,-1558 # ffffffffc0346200 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc020281e:	ef35                	bnez	a4,ffffffffc020289a <page_insert+0xb6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202820:	100027f3          	csrr	a5,sstatus
ffffffffc0202824:	8b89                	andi	a5,a5,2
ffffffffc0202826:	1c079263          	bnez	a5,ffffffffc02029ea <page_insert+0x206>
        page = pmm_manager->alloc_pages(n);
ffffffffc020282a:	00144797          	auipc	a5,0x144
ffffffffc020282e:	9e67b783          	ld	a5,-1562(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc0202832:	6f9c                	ld	a5,24(a5)
ffffffffc0202834:	4505                	li	a0,1
ffffffffc0202836:	9782                	jalr	a5
ffffffffc0202838:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020283a:	1e040263          	beqz	s0,ffffffffc0202a1e <page_insert+0x23a>
    return page - pages + nbase;
ffffffffc020283e:	00144b97          	auipc	s7,0x144
ffffffffc0202842:	9cab8b93          	addi	s7,s7,-1590 # ffffffffc0346208 <pages>
ffffffffc0202846:	000bb683          	ld	a3,0(s7)
ffffffffc020284a:	00080b37          	lui	s6,0x80
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020284e:	00144a97          	auipc	s5,0x144
ffffffffc0202852:	9b2a8a93          	addi	s5,s5,-1614 # ffffffffc0346200 <npage>
ffffffffc0202856:	40d406b3          	sub	a3,s0,a3
ffffffffc020285a:	8699                	srai	a3,a3,0x6
ffffffffc020285c:	96da                	add	a3,a3,s6
ffffffffc020285e:	000ab783          	ld	a5,0(s5)
ffffffffc0202862:	00c69713          	slli	a4,a3,0xc
    page->ref = val;
ffffffffc0202866:	4605                	li	a2,1
ffffffffc0202868:	c010                	sw	a2,0(s0)
ffffffffc020286a:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020286c:	06b2                	slli	a3,a3,0xc
ffffffffc020286e:	22f77663          	bgeu	a4,a5,ffffffffc0202a9a <page_insert+0x2b6>
ffffffffc0202872:	00144517          	auipc	a0,0x144
ffffffffc0202876:	9a653503          	ld	a0,-1626(a0) # ffffffffc0346218 <va_pa_offset>
ffffffffc020287a:	6605                	lui	a2,0x1
ffffffffc020287c:	4581                	li	a1,0
ffffffffc020287e:	9536                	add	a0,a0,a3
ffffffffc0202880:	22d030ef          	jal	ra,ffffffffc02062ac <memset>
    return page - pages + nbase;
ffffffffc0202884:	000bb783          	ld	a5,0(s7)
ffffffffc0202888:	40f407b3          	sub	a5,s0,a5
ffffffffc020288c:	8799                	srai	a5,a5,0x6
ffffffffc020288e:	97da                	add	a5,a5,s6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202890:	07aa                	slli	a5,a5,0xa
ffffffffc0202892:	0117e793          	ori	a5,a5,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202896:	00fa3023          	sd	a5,0(s4)
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020289a:	078a                	slli	a5,a5,0x2
ffffffffc020289c:	76fd                	lui	a3,0xfffff
ffffffffc020289e:	000ab603          	ld	a2,0(s5)
ffffffffc02028a2:	8ff5                	and	a5,a5,a3
ffffffffc02028a4:	00c7d713          	srli	a4,a5,0xc
ffffffffc02028a8:	1cc77c63          	bgeu	a4,a2,ffffffffc0202a80 <page_insert+0x29c>
ffffffffc02028ac:	00144b17          	auipc	s6,0x144
ffffffffc02028b0:	96cb0b13          	addi	s6,s6,-1684 # ffffffffc0346218 <va_pa_offset>
ffffffffc02028b4:	000b3683          	ld	a3,0(s6)
ffffffffc02028b8:	01595a13          	srli	s4,s2,0x15
ffffffffc02028bc:	1ffa7a13          	andi	s4,s4,511
ffffffffc02028c0:	97b6                	add	a5,a5,a3
ffffffffc02028c2:	0a0e                	slli	s4,s4,0x3
ffffffffc02028c4:	9a3e                	add	s4,s4,a5
    if (!(*pdep0 & PTE_V))
ffffffffc02028c6:	000a3403          	ld	s0,0(s4)
ffffffffc02028ca:	00147793          	andi	a5,s0,1
ffffffffc02028ce:	cbbd                	beqz	a5,ffffffffc0202944 <page_insert+0x160>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02028d0:	040a                	slli	s0,s0,0x2
ffffffffc02028d2:	76fd                	lui	a3,0xfffff
ffffffffc02028d4:	8c75                	and	s0,s0,a3
ffffffffc02028d6:	00c45793          	srli	a5,s0,0xc
ffffffffc02028da:	18c7f663          	bgeu	a5,a2,ffffffffc0202a66 <page_insert+0x282>
ffffffffc02028de:	000b3683          	ld	a3,0(s6)
ffffffffc02028e2:	00c95793          	srli	a5,s2,0xc
ffffffffc02028e6:	1ff7f793          	andi	a5,a5,511
ffffffffc02028ea:	9436                	add	s0,s0,a3
ffffffffc02028ec:	078e                	slli	a5,a5,0x3
ffffffffc02028ee:	943e                	add	s0,s0,a5
    if (ptep == NULL)
ffffffffc02028f0:	12040763          	beqz	s0,ffffffffc0202a1e <page_insert+0x23a>
    page->ref += 1;
ffffffffc02028f4:	0009a703          	lw	a4,0(s3)
    if (*ptep & PTE_V)
ffffffffc02028f8:	601c                	ld	a5,0(s0)
ffffffffc02028fa:	0017069b          	addiw	a3,a4,1
ffffffffc02028fe:	00d9a023          	sw	a3,0(s3)
ffffffffc0202902:	0017f693          	andi	a3,a5,1
ffffffffc0202906:	e6d5                	bnez	a3,ffffffffc02029b2 <page_insert+0x1ce>
    return page - pages + nbase;
ffffffffc0202908:	00144697          	auipc	a3,0x144
ffffffffc020290c:	9006b683          	ld	a3,-1792(a3) # ffffffffc0346208 <pages>
ffffffffc0202910:	40d986b3          	sub	a3,s3,a3
ffffffffc0202914:	8699                	srai	a3,a3,0x6
ffffffffc0202916:	000809b7          	lui	s3,0x80
ffffffffc020291a:	96ce                	add	a3,a3,s3
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020291c:	06aa                	slli	a3,a3,0xa
ffffffffc020291e:	8ec5                	or	a3,a3,s1
ffffffffc0202920:	0016e693          	ori	a3,a3,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202924:	e014                	sd	a3,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202926:	12090073          	sfence.vma	s2
    return 0;
ffffffffc020292a:	4501                	li	a0,0
}
ffffffffc020292c:	60e6                	ld	ra,88(sp)
ffffffffc020292e:	6446                	ld	s0,80(sp)
ffffffffc0202930:	64a6                	ld	s1,72(sp)
ffffffffc0202932:	6906                	ld	s2,64(sp)
ffffffffc0202934:	79e2                	ld	s3,56(sp)
ffffffffc0202936:	7a42                	ld	s4,48(sp)
ffffffffc0202938:	7aa2                	ld	s5,40(sp)
ffffffffc020293a:	7b02                	ld	s6,32(sp)
ffffffffc020293c:	6be2                	ld	s7,24(sp)
ffffffffc020293e:	6c42                	ld	s8,16(sp)
ffffffffc0202940:	6125                	addi	sp,sp,96
ffffffffc0202942:	8082                	ret
ffffffffc0202944:	100027f3          	csrr	a5,sstatus
ffffffffc0202948:	8b89                	andi	a5,a5,2
ffffffffc020294a:	efcd                	bnez	a5,ffffffffc0202a04 <page_insert+0x220>
        page = pmm_manager->alloc_pages(n);
ffffffffc020294c:	00144797          	auipc	a5,0x144
ffffffffc0202950:	8c47b783          	ld	a5,-1852(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc0202954:	6f9c                	ld	a5,24(a5)
ffffffffc0202956:	4505                	li	a0,1
ffffffffc0202958:	9782                	jalr	a5
ffffffffc020295a:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020295c:	c069                	beqz	s0,ffffffffc0202a1e <page_insert+0x23a>
    return page - pages + nbase;
ffffffffc020295e:	00144c17          	auipc	s8,0x144
ffffffffc0202962:	8aac0c13          	addi	s8,s8,-1878 # ffffffffc0346208 <pages>
ffffffffc0202966:	000c3503          	ld	a0,0(s8)
ffffffffc020296a:	00080bb7          	lui	s7,0x80
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020296e:	000ab703          	ld	a4,0(s5)
ffffffffc0202972:	40a40533          	sub	a0,s0,a0
ffffffffc0202976:	8519                	srai	a0,a0,0x6
ffffffffc0202978:	955e                	add	a0,a0,s7
ffffffffc020297a:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc020297e:	4685                	li	a3,1
ffffffffc0202980:	c014                	sw	a3,0(s0)
ffffffffc0202982:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202984:	0532                	slli	a0,a0,0xc
ffffffffc0202986:	12e7f663          	bgeu	a5,a4,ffffffffc0202ab2 <page_insert+0x2ce>
ffffffffc020298a:	000b3783          	ld	a5,0(s6)
ffffffffc020298e:	6605                	lui	a2,0x1
ffffffffc0202990:	4581                	li	a1,0
ffffffffc0202992:	953e                	add	a0,a0,a5
ffffffffc0202994:	119030ef          	jal	ra,ffffffffc02062ac <memset>
    return page - pages + nbase;
ffffffffc0202998:	000c3503          	ld	a0,0(s8)
ffffffffc020299c:	8c09                	sub	s0,s0,a0
ffffffffc020299e:	8419                	srai	s0,s0,0x6
ffffffffc02029a0:	945e                	add	s0,s0,s7
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02029a2:	042a                	slli	s0,s0,0xa
ffffffffc02029a4:	01146413          	ori	s0,s0,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02029a8:	008a3023          	sd	s0,0(s4)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02029ac:	000ab603          	ld	a2,0(s5)
ffffffffc02029b0:	b705                	j	ffffffffc02028d0 <page_insert+0xec>
    return pa2page(PTE_ADDR(pte));
ffffffffc02029b2:	078a                	slli	a5,a5,0x2
ffffffffc02029b4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02029b6:	10c7fb63          	bgeu	a5,a2,ffffffffc0202acc <page_insert+0x2e8>
    return &pages[PPN(pa) - nbase];
ffffffffc02029ba:	00144a17          	auipc	s4,0x144
ffffffffc02029be:	84ea0a13          	addi	s4,s4,-1970 # ffffffffc0346208 <pages>
ffffffffc02029c2:	000a3683          	ld	a3,0(s4)
ffffffffc02029c6:	fff80537          	lui	a0,0xfff80
ffffffffc02029ca:	953e                	add	a0,a0,a5
ffffffffc02029cc:	051a                	slli	a0,a0,0x6
ffffffffc02029ce:	9536                	add	a0,a0,a3
        if (p == page)
ffffffffc02029d0:	00a98a63          	beq	s3,a0,ffffffffc02029e4 <page_insert+0x200>
    page->ref -= 1;
ffffffffc02029d4:	411c                	lw	a5,0(a0)
ffffffffc02029d6:	fff7871b          	addiw	a4,a5,-1
ffffffffc02029da:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc02029dc:	c339                	beqz	a4,ffffffffc0202a22 <page_insert+0x23e>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02029de:	12090073          	sfence.vma	s2
}
ffffffffc02029e2:	b73d                	j	ffffffffc0202910 <page_insert+0x12c>
ffffffffc02029e4:	00e9a023          	sw	a4,0(s3) # 80000 <_binary_obj___user_matrix_out_size+0x69480>
    return page->ref;
ffffffffc02029e8:	b725                	j	ffffffffc0202910 <page_insert+0x12c>
        intr_disable();
ffffffffc02029ea:	faffd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02029ee:	00144797          	auipc	a5,0x144
ffffffffc02029f2:	8227b783          	ld	a5,-2014(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc02029f6:	6f9c                	ld	a5,24(a5)
ffffffffc02029f8:	4505                	li	a0,1
ffffffffc02029fa:	9782                	jalr	a5
ffffffffc02029fc:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02029fe:	f95fd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0202a02:	bd25                	j	ffffffffc020283a <page_insert+0x56>
        intr_disable();
ffffffffc0202a04:	f95fd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
ffffffffc0202a08:	00144797          	auipc	a5,0x144
ffffffffc0202a0c:	8087b783          	ld	a5,-2040(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc0202a10:	6f9c                	ld	a5,24(a5)
ffffffffc0202a12:	4505                	li	a0,1
ffffffffc0202a14:	9782                	jalr	a5
ffffffffc0202a16:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202a18:	f7bfd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0202a1c:	b781                	j	ffffffffc020295c <page_insert+0x178>
        return -E_NO_MEM;
ffffffffc0202a1e:	5571                	li	a0,-4
ffffffffc0202a20:	b731                	j	ffffffffc020292c <page_insert+0x148>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202a22:	100027f3          	csrr	a5,sstatus
ffffffffc0202a26:	8b89                	andi	a5,a5,2
ffffffffc0202a28:	ef89                	bnez	a5,ffffffffc0202a42 <page_insert+0x25e>
        pmm_manager->free_pages(base, n);
ffffffffc0202a2a:	00143797          	auipc	a5,0x143
ffffffffc0202a2e:	7e67b783          	ld	a5,2022(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc0202a32:	739c                	ld	a5,32(a5)
ffffffffc0202a34:	4585                	li	a1,1
ffffffffc0202a36:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202a38:	000a3683          	ld	a3,0(s4)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202a3c:	12090073          	sfence.vma	s2
ffffffffc0202a40:	bdc1                	j	ffffffffc0202910 <page_insert+0x12c>
        intr_disable();
ffffffffc0202a42:	e42a                	sd	a0,8(sp)
ffffffffc0202a44:	f55fd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202a48:	00143797          	auipc	a5,0x143
ffffffffc0202a4c:	7c87b783          	ld	a5,1992(a5) # ffffffffc0346210 <pmm_manager>
ffffffffc0202a50:	739c                	ld	a5,32(a5)
ffffffffc0202a52:	6522                	ld	a0,8(sp)
ffffffffc0202a54:	4585                	li	a1,1
ffffffffc0202a56:	9782                	jalr	a5
        intr_enable();
ffffffffc0202a58:	f3bfd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0202a5c:	000a3683          	ld	a3,0(s4)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202a60:	12090073          	sfence.vma	s2
ffffffffc0202a64:	b575                	j	ffffffffc0202910 <page_insert+0x12c>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202a66:	86a2                	mv	a3,s0
ffffffffc0202a68:	00005617          	auipc	a2,0x5
ffffffffc0202a6c:	97060613          	addi	a2,a2,-1680 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0202a70:	0fa00593          	li	a1,250
ffffffffc0202a74:	00005517          	auipc	a0,0x5
ffffffffc0202a78:	a4450513          	addi	a0,a0,-1468 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0202a7c:	9fdfd0ef          	jal	ra,ffffffffc0200478 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202a80:	86be                	mv	a3,a5
ffffffffc0202a82:	00005617          	auipc	a2,0x5
ffffffffc0202a86:	95660613          	addi	a2,a2,-1706 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0202a8a:	0ed00593          	li	a1,237
ffffffffc0202a8e:	00005517          	auipc	a0,0x5
ffffffffc0202a92:	a2a50513          	addi	a0,a0,-1494 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0202a96:	9e3fd0ef          	jal	ra,ffffffffc0200478 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202a9a:	00005617          	auipc	a2,0x5
ffffffffc0202a9e:	93e60613          	addi	a2,a2,-1730 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0202aa2:	0e900593          	li	a1,233
ffffffffc0202aa6:	00005517          	auipc	a0,0x5
ffffffffc0202aaa:	a1250513          	addi	a0,a0,-1518 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0202aae:	9cbfd0ef          	jal	ra,ffffffffc0200478 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202ab2:	86aa                	mv	a3,a0
ffffffffc0202ab4:	00005617          	auipc	a2,0x5
ffffffffc0202ab8:	92460613          	addi	a2,a2,-1756 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0202abc:	0f700593          	li	a1,247
ffffffffc0202ac0:	00005517          	auipc	a0,0x5
ffffffffc0202ac4:	9f850513          	addi	a0,a0,-1544 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0202ac8:	9b1fd0ef          	jal	ra,ffffffffc0200478 <__panic>
ffffffffc0202acc:	bc6ff0ef          	jal	ra,ffffffffc0201e92 <pa2page.part.0>

ffffffffc0202ad0 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202ad0:	00005797          	auipc	a5,0x5
ffffffffc0202ad4:	89878793          	addi	a5,a5,-1896 # ffffffffc0207368 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202ad8:	638c                	ld	a1,0(a5)
{
ffffffffc0202ada:	7159                	addi	sp,sp,-112
ffffffffc0202adc:	eca6                	sd	s1,88(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202ade:	00005517          	auipc	a0,0x5
ffffffffc0202ae2:	a3250513          	addi	a0,a0,-1486 # ffffffffc0207510 <default_pmm_manager+0x1a8>
    pmm_manager = &default_pmm_manager;
ffffffffc0202ae6:	00143497          	auipc	s1,0x143
ffffffffc0202aea:	72a48493          	addi	s1,s1,1834 # ffffffffc0346210 <pmm_manager>
{
ffffffffc0202aee:	f486                	sd	ra,104(sp)
ffffffffc0202af0:	e8ca                	sd	s2,80(sp)
ffffffffc0202af2:	e0d2                	sd	s4,64(sp)
ffffffffc0202af4:	f0a2                	sd	s0,96(sp)
ffffffffc0202af6:	e4ce                	sd	s3,72(sp)
ffffffffc0202af8:	fc56                	sd	s5,56(sp)
ffffffffc0202afa:	f85a                	sd	s6,48(sp)
ffffffffc0202afc:	f45e                	sd	s7,40(sp)
ffffffffc0202afe:	f062                	sd	s8,32(sp)
ffffffffc0202b00:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202b02:	e09c                	sd	a5,0(s1)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202b04:	e94fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    pmm_manager->init();
ffffffffc0202b08:	609c                	ld	a5,0(s1)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202b0a:	00143a17          	auipc	s4,0x143
ffffffffc0202b0e:	70ea0a13          	addi	s4,s4,1806 # ffffffffc0346218 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202b12:	679c                	ld	a5,8(a5)
ffffffffc0202b14:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202b16:	57f5                	li	a5,-3
ffffffffc0202b18:	07fa                	slli	a5,a5,0x1e
ffffffffc0202b1a:	00fa3023          	sd	a5,0(s4)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202b1e:	e61fd0ef          	jal	ra,ffffffffc020097e <get_memory_base>
ffffffffc0202b22:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc0202b24:	e65fd0ef          	jal	ra,ffffffffc0200988 <get_memory_size>
    if (mem_size == 0)
ffffffffc0202b28:	1c050be3          	beqz	a0,ffffffffc02034fe <pmm_init+0xa2e>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202b2c:	842a                	mv	s0,a0
    cprintf("physcial memory map:\n");
ffffffffc0202b2e:	00005517          	auipc	a0,0x5
ffffffffc0202b32:	a1a50513          	addi	a0,a0,-1510 # ffffffffc0207548 <default_pmm_manager+0x1e0>
ffffffffc0202b36:	e62fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202b3a:	008909b3          	add	s3,s2,s0
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202b3e:	864a                	mv	a2,s2
ffffffffc0202b40:	fff98693          	addi	a3,s3,-1
ffffffffc0202b44:	85a2                	mv	a1,s0
ffffffffc0202b46:	00005517          	auipc	a0,0x5
ffffffffc0202b4a:	a1a50513          	addi	a0,a0,-1510 # ffffffffc0207560 <default_pmm_manager+0x1f8>
ffffffffc0202b4e:	e4afd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0202b52:	c80007b7          	lui	a5,0xc8000
ffffffffc0202b56:	864e                	mv	a2,s3
ffffffffc0202b58:	5d37e963          	bltu	a5,s3,ffffffffc020312a <pmm_init+0x65a>
ffffffffc0202b5c:	77fd                	lui	a5,0xfffff
ffffffffc0202b5e:	00144697          	auipc	a3,0x144
ffffffffc0202b62:	6f168693          	addi	a3,a3,1777 # ffffffffc034724f <end+0xfff>
ffffffffc0202b66:	8efd                	and	a3,a3,a5
ffffffffc0202b68:	8231                	srli	a2,a2,0xc
ffffffffc0202b6a:	00143417          	auipc	s0,0x143
ffffffffc0202b6e:	69640413          	addi	s0,s0,1686 # ffffffffc0346200 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202b72:	00143917          	auipc	s2,0x143
ffffffffc0202b76:	69690913          	addi	s2,s2,1686 # ffffffffc0346208 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202b7a:	e010                	sd	a2,0(s0)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202b7c:	00d93023          	sd	a3,0(s2)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202b80:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202b84:	8536                	mv	a0,a3
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202b86:	04f60063          	beq	a2,a5,ffffffffc0202bc6 <pmm_init+0xf6>
ffffffffc0202b8a:	4705                	li	a4,1
ffffffffc0202b8c:	06a1                	addi	a3,a3,8
ffffffffc0202b8e:	40e6b02f          	amoor.d	zero,a4,(a3)
ffffffffc0202b92:	40f607b3          	sub	a5,a2,a5
ffffffffc0202b96:	4505                	li	a0,1
ffffffffc0202b98:	fff805b7          	lui	a1,0xfff80
ffffffffc0202b9c:	02f77063          	bgeu	a4,a5,ffffffffc0202bbc <pmm_init+0xec>
        SetPageReserved(pages + i);
ffffffffc0202ba0:	00093783          	ld	a5,0(s2)
ffffffffc0202ba4:	00671693          	slli	a3,a4,0x6
ffffffffc0202ba8:	97b6                	add	a5,a5,a3
ffffffffc0202baa:	07a1                	addi	a5,a5,8
ffffffffc0202bac:	40a7b02f          	amoor.d	zero,a0,(a5)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202bb0:	6010                	ld	a2,0(s0)
ffffffffc0202bb2:	0705                	addi	a4,a4,1
ffffffffc0202bb4:	00b607b3          	add	a5,a2,a1
ffffffffc0202bb8:	fef764e3          	bltu	a4,a5,ffffffffc0202ba0 <pmm_init+0xd0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202bbc:	00093503          	ld	a0,0(s2)
ffffffffc0202bc0:	079a                	slli	a5,a5,0x6
ffffffffc0202bc2:	00f506b3          	add	a3,a0,a5
ffffffffc0202bc6:	c02007b7          	lui	a5,0xc0200
ffffffffc0202bca:	32f6eee3          	bltu	a3,a5,ffffffffc0203706 <pmm_init+0xc36>
ffffffffc0202bce:	000a3583          	ld	a1,0(s4)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202bd2:	77fd                	lui	a5,0xfffff
ffffffffc0202bd4:	00f9f9b3          	and	s3,s3,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202bd8:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202bda:	0336f863          	bgeu	a3,s3,ffffffffc0202c0a <pmm_init+0x13a>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202bde:	6705                	lui	a4,0x1
ffffffffc0202be0:	177d                	addi	a4,a4,-1
ffffffffc0202be2:	96ba                	add	a3,a3,a4
ffffffffc0202be4:	8efd                	and	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0202be6:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202bea:	6cc7fd63          	bgeu	a5,a2,ffffffffc02032c4 <pmm_init+0x7f4>
    pmm_manager->init_memmap(base, n);
ffffffffc0202bee:	6098                	ld	a4,0(s1)
    return &pages[PPN(pa) - nbase];
ffffffffc0202bf0:	fff80637          	lui	a2,0xfff80
ffffffffc0202bf4:	97b2                	add	a5,a5,a2
ffffffffc0202bf6:	6b18                	ld	a4,16(a4)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202bf8:	40d989b3          	sub	s3,s3,a3
ffffffffc0202bfc:	079a                	slli	a5,a5,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202bfe:	00c9d593          	srli	a1,s3,0xc
ffffffffc0202c02:	953e                	add	a0,a0,a5
ffffffffc0202c04:	9702                	jalr	a4
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202c06:	000a3583          	ld	a1,0(s4)
ffffffffc0202c0a:	00005517          	auipc	a0,0x5
ffffffffc0202c0e:	97e50513          	addi	a0,a0,-1666 # ffffffffc0207588 <default_pmm_manager+0x220>
ffffffffc0202c12:	d86fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202c16:	609c                	ld	a5,0(s1)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202c18:	00143997          	auipc	s3,0x143
ffffffffc0202c1c:	5e098993          	addi	s3,s3,1504 # ffffffffc03461f8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202c20:	7b9c                	ld	a5,48(a5)
ffffffffc0202c22:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202c24:	00005517          	auipc	a0,0x5
ffffffffc0202c28:	97c50513          	addi	a0,a0,-1668 # ffffffffc02075a0 <default_pmm_manager+0x238>
ffffffffc0202c2c:	d6cfd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202c30:	00008697          	auipc	a3,0x8
ffffffffc0202c34:	3d068693          	addi	a3,a3,976 # ffffffffc020b000 <boot_page_table_sv39>
ffffffffc0202c38:	00d9b023          	sd	a3,0(s3)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202c3c:	c02007b7          	lui	a5,0xc0200
ffffffffc0202c40:	22f6e7e3          	bltu	a3,a5,ffffffffc020366e <pmm_init+0xb9e>
ffffffffc0202c44:	000a3783          	ld	a5,0(s4)
ffffffffc0202c48:	8e9d                	sub	a3,a3,a5
ffffffffc0202c4a:	00143797          	auipc	a5,0x143
ffffffffc0202c4e:	5ad7b323          	sd	a3,1446(a5) # ffffffffc03461f0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202c52:	100027f3          	csrr	a5,sstatus
ffffffffc0202c56:	8b89                	andi	a5,a5,2
ffffffffc0202c58:	4e079663          	bnez	a5,ffffffffc0203144 <pmm_init+0x674>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c5c:	609c                	ld	a5,0(s1)
ffffffffc0202c5e:	779c                	ld	a5,40(a5)
ffffffffc0202c60:	9782                	jalr	a5
ffffffffc0202c62:	8aaa                	mv	s5,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202c64:	00043b03          	ld	s6,0(s0)
ffffffffc0202c68:	c80007b7          	lui	a5,0xc8000
ffffffffc0202c6c:	83b1                	srli	a5,a5,0xc
ffffffffc0202c6e:	0f67e4e3          	bltu	a5,s6,ffffffffc0203556 <pmm_init+0xa86>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202c72:	0009b503          	ld	a0,0(s3)
ffffffffc0202c76:	0c0500e3          	beqz	a0,ffffffffc0203536 <pmm_init+0xa66>
ffffffffc0202c7a:	03451793          	slli	a5,a0,0x34
ffffffffc0202c7e:	0a079ce3          	bnez	a5,ffffffffc0203536 <pmm_init+0xa66>
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202c82:	4581                	li	a1,0
ffffffffc0202c84:	a46ff0ef          	jal	ra,ffffffffc0201eca <get_pte.constprop.0>
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202c88:	c511                	beqz	a0,ffffffffc0202c94 <pmm_init+0x1c4>
ffffffffc0202c8a:	611c                	ld	a5,0(a0)
ffffffffc0202c8c:	0017f713          	andi	a4,a5,1
ffffffffc0202c90:	50071b63          	bnez	a4,ffffffffc02031a6 <pmm_init+0x6d6>
ffffffffc0202c94:	100027f3          	csrr	a5,sstatus
ffffffffc0202c98:	8b89                	andi	a5,a5,2
ffffffffc0202c9a:	48079b63          	bnez	a5,ffffffffc0203130 <pmm_init+0x660>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202c9e:	609c                	ld	a5,0(s1)
ffffffffc0202ca0:	4505                	li	a0,1
ffffffffc0202ca2:	6f9c                	ld	a5,24(a5)
ffffffffc0202ca4:	9782                	jalr	a5
ffffffffc0202ca6:	8b2a                	mv	s6,a0
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202ca8:	0009b503          	ld	a0,0(s3)
ffffffffc0202cac:	4681                	li	a3,0
ffffffffc0202cae:	4601                	li	a2,0
ffffffffc0202cb0:	85da                	mv	a1,s6
ffffffffc0202cb2:	b33ff0ef          	jal	ra,ffffffffc02027e4 <page_insert>
ffffffffc0202cb6:	020514e3          	bnez	a0,ffffffffc02034de <pmm_init+0xa0e>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202cba:	0009bc83          	ld	s9,0(s3)
ffffffffc0202cbe:	4581                	li	a1,0
ffffffffc0202cc0:	8566                	mv	a0,s9
ffffffffc0202cc2:	a08ff0ef          	jal	ra,ffffffffc0201eca <get_pte.constprop.0>
ffffffffc0202cc6:	7e050c63          	beqz	a0,ffffffffc02034be <pmm_init+0x9ee>
    assert(pte2page(*ptep) == p1);
ffffffffc0202cca:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202ccc:	0017f713          	andi	a4,a5,1
ffffffffc0202cd0:	7e070563          	beqz	a4,ffffffffc02034ba <pmm_init+0x9ea>
    if (PPN(pa) >= npage)
ffffffffc0202cd4:	6018                	ld	a4,0(s0)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202cd6:	078a                	slli	a5,a5,0x2
ffffffffc0202cd8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cda:	5ee7f563          	bgeu	a5,a4,ffffffffc02032c4 <pmm_init+0x7f4>
    return &pages[PPN(pa) - nbase];
ffffffffc0202cde:	00093683          	ld	a3,0(s2)
ffffffffc0202ce2:	fff80637          	lui	a2,0xfff80
ffffffffc0202ce6:	97b2                	add	a5,a5,a2
ffffffffc0202ce8:	079a                	slli	a5,a5,0x6
ffffffffc0202cea:	97b6                	add	a5,a5,a3
ffffffffc0202cec:	26fb19e3          	bne	s6,a5,ffffffffc020375e <pmm_init+0xc8e>
    assert(page_ref(p1) == 1);
ffffffffc0202cf0:	000b2683          	lw	a3,0(s6)
ffffffffc0202cf4:	4785                	li	a5,1
ffffffffc0202cf6:	7af69263          	bne	a3,a5,ffffffffc020349a <pmm_init+0x9ca>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202cfa:	000cb683          	ld	a3,0(s9) # 200000 <_binary_obj___user_matrix_out_size+0x1e9480>
ffffffffc0202cfe:	77fd                	lui	a5,0xfffff
ffffffffc0202d00:	068a                	slli	a3,a3,0x2
ffffffffc0202d02:	8efd                	and	a3,a3,a5
ffffffffc0202d04:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202d08:	76e67d63          	bgeu	a2,a4,ffffffffc0203482 <pmm_init+0x9b2>
ffffffffc0202d0c:	000a3c03          	ld	s8,0(s4)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202d10:	96e2                	add	a3,a3,s8
ffffffffc0202d12:	0006bb83          	ld	s7,0(a3)
ffffffffc0202d16:	0b8a                	slli	s7,s7,0x2
ffffffffc0202d18:	00fbfbb3          	and	s7,s7,a5
ffffffffc0202d1c:	00cbd793          	srli	a5,s7,0xc
ffffffffc0202d20:	74e7f463          	bgeu	a5,a4,ffffffffc0203468 <pmm_init+0x998>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202d24:	6585                	lui	a1,0x1
ffffffffc0202d26:	8566                	mv	a0,s9
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202d28:	9be2                	add	s7,s7,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202d2a:	9a0ff0ef          	jal	ra,ffffffffc0201eca <get_pte.constprop.0>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202d2e:	0ba1                	addi	s7,s7,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202d30:	057513e3          	bne	a0,s7,ffffffffc0203576 <pmm_init+0xaa6>
ffffffffc0202d34:	100027f3          	csrr	a5,sstatus
ffffffffc0202d38:	8b89                	andi	a5,a5,2
ffffffffc0202d3a:	4a079363          	bnez	a5,ffffffffc02031e0 <pmm_init+0x710>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202d3e:	609c                	ld	a5,0(s1)
ffffffffc0202d40:	4505                	li	a0,1
ffffffffc0202d42:	6f9c                	ld	a5,24(a5)
ffffffffc0202d44:	9782                	jalr	a5
ffffffffc0202d46:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202d48:	0009b503          	ld	a0,0(s3)
ffffffffc0202d4c:	46d1                	li	a3,20
ffffffffc0202d4e:	6605                	lui	a2,0x1
ffffffffc0202d50:	85e2                	mv	a1,s8
ffffffffc0202d52:	a93ff0ef          	jal	ra,ffffffffc02027e4 <page_insert>
ffffffffc0202d56:	120518e3          	bnez	a0,ffffffffc0203686 <pmm_init+0xbb6>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202d5a:	0009bb83          	ld	s7,0(s3)
ffffffffc0202d5e:	6585                	lui	a1,0x1
ffffffffc0202d60:	855e                	mv	a0,s7
ffffffffc0202d62:	968ff0ef          	jal	ra,ffffffffc0201eca <get_pte.constprop.0>
ffffffffc0202d66:	160500e3          	beqz	a0,ffffffffc02036c6 <pmm_init+0xbf6>
    assert(*ptep & PTE_U);
ffffffffc0202d6a:	611c                	ld	a5,0(a0)
ffffffffc0202d6c:	0107f713          	andi	a4,a5,16
ffffffffc0202d70:	12070be3          	beqz	a4,ffffffffc02036a6 <pmm_init+0xbd6>
    assert(*ptep & PTE_W);
ffffffffc0202d74:	8b91                	andi	a5,a5,4
ffffffffc0202d76:	6a078963          	beqz	a5,ffffffffc0203428 <pmm_init+0x958>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202d7a:	000bb783          	ld	a5,0(s7) # 80000 <_binary_obj___user_matrix_out_size+0x69480>
ffffffffc0202d7e:	8bc1                	andi	a5,a5,16
ffffffffc0202d80:	68078463          	beqz	a5,ffffffffc0203408 <pmm_init+0x938>
    assert(page_ref(p2) == 1);
ffffffffc0202d84:	000c2703          	lw	a4,0(s8)
ffffffffc0202d88:	4785                	li	a5,1
ffffffffc0202d8a:	64f71f63          	bne	a4,a5,ffffffffc02033e8 <pmm_init+0x918>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202d8e:	4681                	li	a3,0
ffffffffc0202d90:	6605                	lui	a2,0x1
ffffffffc0202d92:	85da                	mv	a1,s6
ffffffffc0202d94:	855e                	mv	a0,s7
ffffffffc0202d96:	a4fff0ef          	jal	ra,ffffffffc02027e4 <page_insert>
ffffffffc0202d9a:	52051763          	bnez	a0,ffffffffc02032c8 <pmm_init+0x7f8>
    assert(page_ref(p1) == 2);
ffffffffc0202d9e:	000b2703          	lw	a4,0(s6)
ffffffffc0202da2:	4789                	li	a5,2
ffffffffc0202da4:	60f71263          	bne	a4,a5,ffffffffc02033a8 <pmm_init+0x8d8>
    assert(page_ref(p2) == 0);
ffffffffc0202da8:	000c2783          	lw	a5,0(s8)
ffffffffc0202dac:	5c079e63          	bnez	a5,ffffffffc0203388 <pmm_init+0x8b8>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202db0:	0009bc83          	ld	s9,0(s3)
ffffffffc0202db4:	6585                	lui	a1,0x1
ffffffffc0202db6:	8566                	mv	a0,s9
ffffffffc0202db8:	912ff0ef          	jal	ra,ffffffffc0201eca <get_pte.constprop.0>
ffffffffc0202dbc:	5a050663          	beqz	a0,ffffffffc0203368 <pmm_init+0x898>
    assert(pte2page(*ptep) == p1);
ffffffffc0202dc0:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202dc2:	00177793          	andi	a5,a4,1
ffffffffc0202dc6:	6e078a63          	beqz	a5,ffffffffc02034ba <pmm_init+0x9ea>
    if (PPN(pa) >= npage)
ffffffffc0202dca:	6014                	ld	a3,0(s0)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202dcc:	00271793          	slli	a5,a4,0x2
ffffffffc0202dd0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202dd2:	4ed7f963          	bgeu	a5,a3,ffffffffc02032c4 <pmm_init+0x7f4>
    return &pages[PPN(pa) - nbase];
ffffffffc0202dd6:	00093683          	ld	a3,0(s2)
ffffffffc0202dda:	fff80bb7          	lui	s7,0xfff80
ffffffffc0202dde:	97de                	add	a5,a5,s7
ffffffffc0202de0:	079a                	slli	a5,a5,0x6
ffffffffc0202de2:	97b6                	add	a5,a5,a3
ffffffffc0202de4:	56fb1263          	bne	s6,a5,ffffffffc0203348 <pmm_init+0x878>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202de8:	8b41                	andi	a4,a4,16
ffffffffc0202dea:	52071f63          	bnez	a4,ffffffffc0203328 <pmm_init+0x858>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202dee:	8566                	mv	a0,s9
ffffffffc0202df0:	4581                	li	a1,0
ffffffffc0202df2:	8d1ff0ef          	jal	ra,ffffffffc02026c2 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202df6:	000b2c83          	lw	s9,0(s6)
ffffffffc0202dfa:	4785                	li	a5,1
ffffffffc0202dfc:	50fc9663          	bne	s9,a5,ffffffffc0203308 <pmm_init+0x838>
    assert(page_ref(p2) == 0);
ffffffffc0202e00:	000c2783          	lw	a5,0(s8)
ffffffffc0202e04:	4e079263          	bnez	a5,ffffffffc02032e8 <pmm_init+0x818>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202e08:	0009b503          	ld	a0,0(s3)
ffffffffc0202e0c:	6585                	lui	a1,0x1
ffffffffc0202e0e:	8b5ff0ef          	jal	ra,ffffffffc02026c2 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202e12:	000b2783          	lw	a5,0(s6)
ffffffffc0202e16:	62079963          	bnez	a5,ffffffffc0203448 <pmm_init+0x978>
    assert(page_ref(p2) == 0);
ffffffffc0202e1a:	000c2783          	lw	a5,0(s8)
ffffffffc0202e1e:	7a079863          	bnez	a5,ffffffffc02035ce <pmm_init+0xafe>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202e22:	0009bb03          	ld	s6,0(s3)
    if (PPN(pa) >= npage)
ffffffffc0202e26:	6018                	ld	a4,0(s0)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e28:	000b3683          	ld	a3,0(s6)
ffffffffc0202e2c:	068a                	slli	a3,a3,0x2
ffffffffc0202e2e:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e30:	48e6fa63          	bgeu	a3,a4,ffffffffc02032c4 <pmm_init+0x7f4>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e34:	00093503          	ld	a0,0(s2)
ffffffffc0202e38:	96de                	add	a3,a3,s7
ffffffffc0202e3a:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202e3c:	00d507b3          	add	a5,a0,a3
ffffffffc0202e40:	439c                	lw	a5,0(a5)
ffffffffc0202e42:	77979663          	bne	a5,s9,ffffffffc02035ae <pmm_init+0xade>
    return page - pages + nbase;
ffffffffc0202e46:	8699                	srai	a3,a3,0x6
ffffffffc0202e48:	000805b7          	lui	a1,0x80
ffffffffc0202e4c:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc0202e4e:	00c69613          	slli	a2,a3,0xc
ffffffffc0202e52:	8231                	srli	a2,a2,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202e54:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202e56:	74e67063          	bgeu	a2,a4,ffffffffc0203596 <pmm_init+0xac6>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202e5a:	000a3603          	ld	a2,0(s4)
ffffffffc0202e5e:	96b2                	add	a3,a3,a2
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e60:	629c                	ld	a5,0(a3)
ffffffffc0202e62:	078a                	slli	a5,a5,0x2
ffffffffc0202e64:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e66:	44e7ff63          	bgeu	a5,a4,ffffffffc02032c4 <pmm_init+0x7f4>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e6a:	8f8d                	sub	a5,a5,a1
ffffffffc0202e6c:	079a                	slli	a5,a5,0x6
ffffffffc0202e6e:	953e                	add	a0,a0,a5
ffffffffc0202e70:	100027f3          	csrr	a5,sstatus
ffffffffc0202e74:	8b89                	andi	a5,a5,2
ffffffffc0202e76:	30079d63          	bnez	a5,ffffffffc0203190 <pmm_init+0x6c0>
        pmm_manager->free_pages(base, n);
ffffffffc0202e7a:	609c                	ld	a5,0(s1)
ffffffffc0202e7c:	4585                	li	a1,1
ffffffffc0202e7e:	739c                	ld	a5,32(a5)
ffffffffc0202e80:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e82:	000b3783          	ld	a5,0(s6)
    if (PPN(pa) >= npage)
ffffffffc0202e86:	6018                	ld	a4,0(s0)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e88:	078a                	slli	a5,a5,0x2
ffffffffc0202e8a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e8c:	42e7fc63          	bgeu	a5,a4,ffffffffc02032c4 <pmm_init+0x7f4>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e90:	00093503          	ld	a0,0(s2)
ffffffffc0202e94:	fff80737          	lui	a4,0xfff80
ffffffffc0202e98:	97ba                	add	a5,a5,a4
ffffffffc0202e9a:	079a                	slli	a5,a5,0x6
ffffffffc0202e9c:	953e                	add	a0,a0,a5
ffffffffc0202e9e:	100027f3          	csrr	a5,sstatus
ffffffffc0202ea2:	8b89                	andi	a5,a5,2
ffffffffc0202ea4:	2c079b63          	bnez	a5,ffffffffc020317a <pmm_init+0x6aa>
ffffffffc0202ea8:	609c                	ld	a5,0(s1)
ffffffffc0202eaa:	4585                	li	a1,1
ffffffffc0202eac:	739c                	ld	a5,32(a5)
ffffffffc0202eae:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202eb0:	0009b783          	ld	a5,0(s3)
ffffffffc0202eb4:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fcb8db0>
    asm volatile("sfence.vma");
ffffffffc0202eb8:	12000073          	sfence.vma
ffffffffc0202ebc:	100027f3          	csrr	a5,sstatus
ffffffffc0202ec0:	8b89                	andi	a5,a5,2
ffffffffc0202ec2:	2a079363          	bnez	a5,ffffffffc0203168 <pmm_init+0x698>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202ec6:	609c                	ld	a5,0(s1)
ffffffffc0202ec8:	779c                	ld	a5,40(a5)
ffffffffc0202eca:	9782                	jalr	a5
ffffffffc0202ecc:	8b2a                	mv	s6,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202ece:	4f6a9d63          	bne	s5,s6,ffffffffc02033c8 <pmm_init+0x8f8>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202ed2:	00005517          	auipc	a0,0x5
ffffffffc0202ed6:	9f650513          	addi	a0,a0,-1546 # ffffffffc02078c8 <default_pmm_manager+0x560>
ffffffffc0202eda:	abefd0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc0202ede:	100027f3          	csrr	a5,sstatus
ffffffffc0202ee2:	8b89                	andi	a5,a5,2
ffffffffc0202ee4:	26079963          	bnez	a5,ffffffffc0203156 <pmm_init+0x686>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202ee8:	609c                	ld	a5,0(s1)
ffffffffc0202eea:	779c                	ld	a5,40(a5)
ffffffffc0202eec:	9782                	jalr	a5
ffffffffc0202eee:	8aaa                	mv	s5,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202ef0:	6010                	ld	a2,0(s0)
ffffffffc0202ef2:	c02007b7          	lui	a5,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202ef6:	0009b883          	ld	a7,0(s3)
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202efa:	00c61813          	slli	a6,a2,0xc
ffffffffc0202efe:	0907ff63          	bgeu	a5,a6,ffffffffc0202f9c <pmm_init+0x4cc>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202f02:	000a3503          	ld	a0,0(s4)
ffffffffc0202f06:	c0200737          	lui	a4,0xc0200
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202f0a:	75fd                	lui	a1,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202f0c:	6305                	lui	t1,0x1
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202f0e:	00c75793          	srli	a5,a4,0xc
ffffffffc0202f12:	36c7f463          	bgeu	a5,a2,ffffffffc020327a <pmm_init+0x7aa>
ffffffffc0202f16:	00e50e33          	add	t3,a0,a4
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202f1a:	01ee5793          	srli	a5,t3,0x1e
ffffffffc0202f1e:	1ff7f793          	andi	a5,a5,511
    if (!(*pdep1 & PTE_V))
ffffffffc0202f22:	078e                	slli	a5,a5,0x3
ffffffffc0202f24:	97c6                	add	a5,a5,a7
ffffffffc0202f26:	6394                	ld	a3,0(a5)
ffffffffc0202f28:	0016f793          	andi	a5,a3,1
ffffffffc0202f2c:	e38d                	bnez	a5,ffffffffc0202f4e <pmm_init+0x47e>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202f2e:	00005697          	auipc	a3,0x5
ffffffffc0202f32:	9ba68693          	addi	a3,a3,-1606 # ffffffffc02078e8 <default_pmm_manager+0x580>
ffffffffc0202f36:	00004617          	auipc	a2,0x4
ffffffffc0202f3a:	08260613          	addi	a2,a2,130 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0202f3e:	25400593          	li	a1,596
ffffffffc0202f42:	00004517          	auipc	a0,0x4
ffffffffc0202f46:	57650513          	addi	a0,a0,1398 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0202f4a:	d2efd0ef          	jal	ra,ffffffffc0200478 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202f4e:	068a                	slli	a3,a3,0x2
ffffffffc0202f50:	8eed                	and	a3,a3,a1
ffffffffc0202f52:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202f56:	32c7ff63          	bgeu	a5,a2,ffffffffc0203294 <pmm_init+0x7c4>
ffffffffc0202f5a:	015e5793          	srli	a5,t3,0x15
ffffffffc0202f5e:	1ff7f793          	andi	a5,a5,511
    if (!(*pdep0 & PTE_V))
ffffffffc0202f62:	078e                	slli	a5,a5,0x3
ffffffffc0202f64:	97aa                	add	a5,a5,a0
ffffffffc0202f66:	96be                	add	a3,a3,a5
ffffffffc0202f68:	6294                	ld	a3,0(a3)
ffffffffc0202f6a:	0016f793          	andi	a5,a3,1
ffffffffc0202f6e:	d3e1                	beqz	a5,ffffffffc0202f2e <pmm_init+0x45e>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202f70:	068a                	slli	a3,a3,0x2
ffffffffc0202f72:	8eed                	and	a3,a3,a1
ffffffffc0202f74:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202f78:	32c7fa63          	bgeu	a5,a2,ffffffffc02032ac <pmm_init+0x7dc>
ffffffffc0202f7c:	00ce5e13          	srli	t3,t3,0xc
ffffffffc0202f80:	1ffe7e13          	andi	t3,t3,511
ffffffffc0202f84:	96aa                	add	a3,a3,a0
ffffffffc0202f86:	0e0e                	slli	t3,t3,0x3
ffffffffc0202f88:	96f2                	add	a3,a3,t3
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202f8a:	d2d5                	beqz	a3,ffffffffc0202f2e <pmm_init+0x45e>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202f8c:	629c                	ld	a5,0(a3)
ffffffffc0202f8e:	078a                	slli	a5,a5,0x2
ffffffffc0202f90:	8fed                	and	a5,a5,a1
ffffffffc0202f92:	2ce79463          	bne	a5,a4,ffffffffc020325a <pmm_init+0x78a>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202f96:	971a                	add	a4,a4,t1
ffffffffc0202f98:	f7076be3          	bltu	a4,a6,ffffffffc0202f0e <pmm_init+0x43e>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202f9c:	0008b783          	ld	a5,0(a7) # 80000 <_binary_obj___user_matrix_out_size+0x69480>
ffffffffc0202fa0:	74079363          	bnez	a5,ffffffffc02036e6 <pmm_init+0xc16>
ffffffffc0202fa4:	100027f3          	csrr	a5,sstatus
ffffffffc0202fa8:	8b89                	andi	a5,a5,2
ffffffffc0202faa:	24079563          	bnez	a5,ffffffffc02031f4 <pmm_init+0x724>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202fae:	609c                	ld	a5,0(s1)
ffffffffc0202fb0:	4505                	li	a0,1
ffffffffc0202fb2:	6f9c                	ld	a5,24(a5)
ffffffffc0202fb4:	9782                	jalr	a5
ffffffffc0202fb6:	8b2a                	mv	s6,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202fb8:	0009b503          	ld	a0,0(s3)
ffffffffc0202fbc:	4699                	li	a3,6
ffffffffc0202fbe:	10000613          	li	a2,256
ffffffffc0202fc2:	85da                	mv	a1,s6
ffffffffc0202fc4:	821ff0ef          	jal	ra,ffffffffc02027e4 <page_insert>
ffffffffc0202fc8:	76051b63          	bnez	a0,ffffffffc020373e <pmm_init+0xc6e>
    assert(page_ref(p) == 1);
ffffffffc0202fcc:	000b2703          	lw	a4,0(s6)
ffffffffc0202fd0:	4785                	li	a5,1
ffffffffc0202fd2:	74f71663          	bne	a4,a5,ffffffffc020371e <pmm_init+0xc4e>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202fd6:	0009b503          	ld	a0,0(s3)
ffffffffc0202fda:	6b85                	lui	s7,0x1
ffffffffc0202fdc:	4699                	li	a3,6
ffffffffc0202fde:	100b8613          	addi	a2,s7,256 # 1100 <_binary_obj___user_faultread_out_size-0x102a8>
ffffffffc0202fe2:	85da                	mv	a1,s6
ffffffffc0202fe4:	801ff0ef          	jal	ra,ffffffffc02027e4 <page_insert>
ffffffffc0202fe8:	66051363          	bnez	a0,ffffffffc020364e <pmm_init+0xb7e>
    assert(page_ref(p) == 2);
ffffffffc0202fec:	000b2703          	lw	a4,0(s6)
ffffffffc0202ff0:	4789                	li	a5,2
ffffffffc0202ff2:	62f71e63          	bne	a4,a5,ffffffffc020362e <pmm_init+0xb5e>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202ff6:	00005597          	auipc	a1,0x5
ffffffffc0202ffa:	a1a58593          	addi	a1,a1,-1510 # ffffffffc0207a10 <default_pmm_manager+0x6a8>
ffffffffc0202ffe:	10000513          	li	a0,256
ffffffffc0203002:	23a030ef          	jal	ra,ffffffffc020623c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203006:	100b8593          	addi	a1,s7,256
ffffffffc020300a:	10000513          	li	a0,256
ffffffffc020300e:	240030ef          	jal	ra,ffffffffc020624e <strcmp>
ffffffffc0203012:	5e051e63          	bnez	a0,ffffffffc020360e <pmm_init+0xb3e>
    return page - pages + nbase;
ffffffffc0203016:	00093683          	ld	a3,0(s2)
ffffffffc020301a:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc020301e:	5c7d                	li	s8,-1
    return page - pages + nbase;
ffffffffc0203020:	40db06b3          	sub	a3,s6,a3
ffffffffc0203024:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0203026:	601c                	ld	a5,0(s0)
    return page - pages + nbase;
ffffffffc0203028:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc020302a:	00cc5c13          	srli	s8,s8,0xc
ffffffffc020302e:	0186f733          	and	a4,a3,s8
    return page2ppn(page) << PGSHIFT;
ffffffffc0203032:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203034:	56f77163          	bgeu	a4,a5,ffffffffc0203596 <pmm_init+0xac6>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0203038:	000a3783          	ld	a5,0(s4)
    assert(strlen((const char *)0x100) == 0);
ffffffffc020303c:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0203040:	96be                	add	a3,a3,a5
ffffffffc0203042:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203046:	1c0030ef          	jal	ra,ffffffffc0206206 <strlen>
ffffffffc020304a:	5a051263          	bnez	a0,ffffffffc02035ee <pmm_init+0xb1e>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc020304e:	0009bb83          	ld	s7,0(s3)
    if (PPN(pa) >= npage)
ffffffffc0203052:	601c                	ld	a5,0(s0)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203054:	000bb683          	ld	a3,0(s7)
ffffffffc0203058:	068a                	slli	a3,a3,0x2
ffffffffc020305a:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc020305c:	26f6f463          	bgeu	a3,a5,ffffffffc02032c4 <pmm_init+0x7f4>
    return KADDR(page2pa(page));
ffffffffc0203060:	0186fc33          	and	s8,a3,s8
    return page2ppn(page) << PGSHIFT;
ffffffffc0203064:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203066:	52fc7863          	bgeu	s8,a5,ffffffffc0203596 <pmm_init+0xac6>
ffffffffc020306a:	000a3a03          	ld	s4,0(s4)
ffffffffc020306e:	9a36                	add	s4,s4,a3
ffffffffc0203070:	100027f3          	csrr	a5,sstatus
ffffffffc0203074:	8b89                	andi	a5,a5,2
ffffffffc0203076:	1c079863          	bnez	a5,ffffffffc0203246 <pmm_init+0x776>
        pmm_manager->free_pages(base, n);
ffffffffc020307a:	609c                	ld	a5,0(s1)
ffffffffc020307c:	4585                	li	a1,1
ffffffffc020307e:	855a                	mv	a0,s6
ffffffffc0203080:	739c                	ld	a5,32(a5)
ffffffffc0203082:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0203084:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0203088:	6018                	ld	a4,0(s0)
    return pa2page(PDE_ADDR(pde));
ffffffffc020308a:	078a                	slli	a5,a5,0x2
ffffffffc020308c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020308e:	22e7fb63          	bgeu	a5,a4,ffffffffc02032c4 <pmm_init+0x7f4>
    return &pages[PPN(pa) - nbase];
ffffffffc0203092:	00093503          	ld	a0,0(s2)
ffffffffc0203096:	fff80737          	lui	a4,0xfff80
ffffffffc020309a:	97ba                	add	a5,a5,a4
ffffffffc020309c:	079a                	slli	a5,a5,0x6
ffffffffc020309e:	953e                	add	a0,a0,a5
ffffffffc02030a0:	100027f3          	csrr	a5,sstatus
ffffffffc02030a4:	8b89                	andi	a5,a5,2
ffffffffc02030a6:	18079563          	bnez	a5,ffffffffc0203230 <pmm_init+0x760>
ffffffffc02030aa:	609c                	ld	a5,0(s1)
ffffffffc02030ac:	4585                	li	a1,1
ffffffffc02030ae:	739c                	ld	a5,32(a5)
ffffffffc02030b0:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02030b2:	000bb783          	ld	a5,0(s7)
    if (PPN(pa) >= npage)
ffffffffc02030b6:	6018                	ld	a4,0(s0)
    return pa2page(PDE_ADDR(pde));
ffffffffc02030b8:	078a                	slli	a5,a5,0x2
ffffffffc02030ba:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02030bc:	20e7f463          	bgeu	a5,a4,ffffffffc02032c4 <pmm_init+0x7f4>
    return &pages[PPN(pa) - nbase];
ffffffffc02030c0:	00093503          	ld	a0,0(s2)
ffffffffc02030c4:	fff80737          	lui	a4,0xfff80
ffffffffc02030c8:	97ba                	add	a5,a5,a4
ffffffffc02030ca:	079a                	slli	a5,a5,0x6
ffffffffc02030cc:	953e                	add	a0,a0,a5
ffffffffc02030ce:	100027f3          	csrr	a5,sstatus
ffffffffc02030d2:	8b89                	andi	a5,a5,2
ffffffffc02030d4:	14079363          	bnez	a5,ffffffffc020321a <pmm_init+0x74a>
ffffffffc02030d8:	609c                	ld	a5,0(s1)
ffffffffc02030da:	4585                	li	a1,1
ffffffffc02030dc:	739c                	ld	a5,32(a5)
ffffffffc02030de:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc02030e0:	0009b783          	ld	a5,0(s3)
ffffffffc02030e4:	0007b023          	sd	zero,0(a5) # ffffffffc0200000 <kern_entry>
    asm volatile("sfence.vma");
ffffffffc02030e8:	12000073          	sfence.vma
ffffffffc02030ec:	100027f3          	csrr	a5,sstatus
ffffffffc02030f0:	8b89                	andi	a5,a5,2
ffffffffc02030f2:	10079b63          	bnez	a5,ffffffffc0203208 <pmm_init+0x738>
        ret = pmm_manager->nr_free_pages();
ffffffffc02030f6:	609c                	ld	a5,0(s1)
ffffffffc02030f8:	779c                	ld	a5,40(a5)
ffffffffc02030fa:	9782                	jalr	a5
ffffffffc02030fc:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc02030fe:	408a9c63          	bne	s5,s0,ffffffffc0203516 <pmm_init+0xa46>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0203102:	00005517          	auipc	a0,0x5
ffffffffc0203106:	98650513          	addi	a0,a0,-1658 # ffffffffc0207a88 <default_pmm_manager+0x720>
ffffffffc020310a:	88efd0ef          	jal	ra,ffffffffc0200198 <cprintf>
}
ffffffffc020310e:	7406                	ld	s0,96(sp)
ffffffffc0203110:	70a6                	ld	ra,104(sp)
ffffffffc0203112:	64e6                	ld	s1,88(sp)
ffffffffc0203114:	6946                	ld	s2,80(sp)
ffffffffc0203116:	69a6                	ld	s3,72(sp)
ffffffffc0203118:	6a06                	ld	s4,64(sp)
ffffffffc020311a:	7ae2                	ld	s5,56(sp)
ffffffffc020311c:	7b42                	ld	s6,48(sp)
ffffffffc020311e:	7ba2                	ld	s7,40(sp)
ffffffffc0203120:	7c02                	ld	s8,32(sp)
ffffffffc0203122:	6ce2                	ld	s9,24(sp)
ffffffffc0203124:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0203126:	b49fe06f          	j	ffffffffc0201c6e <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc020312a:	c8000637          	lui	a2,0xc8000
ffffffffc020312e:	b43d                	j	ffffffffc0202b5c <pmm_init+0x8c>
        intr_disable();
ffffffffc0203130:	869fd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203134:	609c                	ld	a5,0(s1)
ffffffffc0203136:	4505                	li	a0,1
ffffffffc0203138:	6f9c                	ld	a5,24(a5)
ffffffffc020313a:	9782                	jalr	a5
ffffffffc020313c:	8b2a                	mv	s6,a0
        intr_enable();
ffffffffc020313e:	855fd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0203142:	b69d                	j	ffffffffc0202ca8 <pmm_init+0x1d8>
        intr_disable();
ffffffffc0203144:	855fd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0203148:	609c                	ld	a5,0(s1)
ffffffffc020314a:	779c                	ld	a5,40(a5)
ffffffffc020314c:	9782                	jalr	a5
ffffffffc020314e:	8aaa                	mv	s5,a0
        intr_enable();
ffffffffc0203150:	843fd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0203154:	be01                	j	ffffffffc0202c64 <pmm_init+0x194>
        intr_disable();
ffffffffc0203156:	843fd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
ffffffffc020315a:	609c                	ld	a5,0(s1)
ffffffffc020315c:	779c                	ld	a5,40(a5)
ffffffffc020315e:	9782                	jalr	a5
ffffffffc0203160:	8aaa                	mv	s5,a0
        intr_enable();
ffffffffc0203162:	831fd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0203166:	b369                	j	ffffffffc0202ef0 <pmm_init+0x420>
        intr_disable();
ffffffffc0203168:	831fd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
ffffffffc020316c:	609c                	ld	a5,0(s1)
ffffffffc020316e:	779c                	ld	a5,40(a5)
ffffffffc0203170:	9782                	jalr	a5
ffffffffc0203172:	8b2a                	mv	s6,a0
        intr_enable();
ffffffffc0203174:	81ffd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0203178:	bb99                	j	ffffffffc0202ece <pmm_init+0x3fe>
ffffffffc020317a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020317c:	81dfd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0203180:	609c                	ld	a5,0(s1)
ffffffffc0203182:	6522                	ld	a0,8(sp)
ffffffffc0203184:	4585                	li	a1,1
ffffffffc0203186:	739c                	ld	a5,32(a5)
ffffffffc0203188:	9782                	jalr	a5
        intr_enable();
ffffffffc020318a:	809fd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc020318e:	b30d                	j	ffffffffc0202eb0 <pmm_init+0x3e0>
ffffffffc0203190:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203192:	807fd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
ffffffffc0203196:	609c                	ld	a5,0(s1)
ffffffffc0203198:	6522                	ld	a0,8(sp)
ffffffffc020319a:	4585                	li	a1,1
ffffffffc020319c:	739c                	ld	a5,32(a5)
ffffffffc020319e:	9782                	jalr	a5
        intr_enable();
ffffffffc02031a0:	ff2fd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc02031a4:	b9f9                	j	ffffffffc0202e82 <pmm_init+0x3b2>
    return pa2page(PTE_ADDR(pte));
ffffffffc02031a6:	078a                	slli	a5,a5,0x2
ffffffffc02031a8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02031aa:	1167fd63          	bgeu	a5,s6,ffffffffc02032c4 <pmm_init+0x7f4>
    return &pages[PPN(pa) - nbase];
ffffffffc02031ae:	00093703          	ld	a4,0(s2)
ffffffffc02031b2:	fff806b7          	lui	a3,0xfff80
ffffffffc02031b6:	97b6                	add	a5,a5,a3
ffffffffc02031b8:	079a                	slli	a5,a5,0x6
ffffffffc02031ba:	97ba                	add	a5,a5,a4
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02031bc:	ac078ce3          	beqz	a5,ffffffffc0202c94 <pmm_init+0x1c4>
ffffffffc02031c0:	00004697          	auipc	a3,0x4
ffffffffc02031c4:	46068693          	addi	a3,a3,1120 # ffffffffc0207620 <default_pmm_manager+0x2b8>
ffffffffc02031c8:	00004617          	auipc	a2,0x4
ffffffffc02031cc:	df060613          	addi	a2,a2,-528 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02031d0:	21700593          	li	a1,535
ffffffffc02031d4:	00004517          	auipc	a0,0x4
ffffffffc02031d8:	2e450513          	addi	a0,a0,740 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02031dc:	a9cfd0ef          	jal	ra,ffffffffc0200478 <__panic>
        intr_disable();
ffffffffc02031e0:	fb8fd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02031e4:	609c                	ld	a5,0(s1)
ffffffffc02031e6:	4505                	li	a0,1
ffffffffc02031e8:	6f9c                	ld	a5,24(a5)
ffffffffc02031ea:	9782                	jalr	a5
ffffffffc02031ec:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc02031ee:	fa4fd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc02031f2:	be99                	j	ffffffffc0202d48 <pmm_init+0x278>
        intr_disable();
ffffffffc02031f4:	fa4fd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
ffffffffc02031f8:	609c                	ld	a5,0(s1)
ffffffffc02031fa:	4505                	li	a0,1
ffffffffc02031fc:	6f9c                	ld	a5,24(a5)
ffffffffc02031fe:	9782                	jalr	a5
ffffffffc0203200:	8b2a                	mv	s6,a0
        intr_enable();
ffffffffc0203202:	f90fd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0203206:	bb4d                	j	ffffffffc0202fb8 <pmm_init+0x4e8>
        intr_disable();
ffffffffc0203208:	f90fd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020320c:	609c                	ld	a5,0(s1)
ffffffffc020320e:	779c                	ld	a5,40(a5)
ffffffffc0203210:	9782                	jalr	a5
ffffffffc0203212:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203214:	f7efd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0203218:	b5dd                	j	ffffffffc02030fe <pmm_init+0x62e>
ffffffffc020321a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020321c:	f7cfd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0203220:	609c                	ld	a5,0(s1)
ffffffffc0203222:	6522                	ld	a0,8(sp)
ffffffffc0203224:	4585                	li	a1,1
ffffffffc0203226:	739c                	ld	a5,32(a5)
ffffffffc0203228:	9782                	jalr	a5
        intr_enable();
ffffffffc020322a:	f68fd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc020322e:	bd4d                	j	ffffffffc02030e0 <pmm_init+0x610>
ffffffffc0203230:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203232:	f66fd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
ffffffffc0203236:	609c                	ld	a5,0(s1)
ffffffffc0203238:	6522                	ld	a0,8(sp)
ffffffffc020323a:	4585                	li	a1,1
ffffffffc020323c:	739c                	ld	a5,32(a5)
ffffffffc020323e:	9782                	jalr	a5
        intr_enable();
ffffffffc0203240:	f52fd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0203244:	b5bd                	j	ffffffffc02030b2 <pmm_init+0x5e2>
        intr_disable();
ffffffffc0203246:	f52fd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
ffffffffc020324a:	609c                	ld	a5,0(s1)
ffffffffc020324c:	4585                	li	a1,1
ffffffffc020324e:	855a                	mv	a0,s6
ffffffffc0203250:	739c                	ld	a5,32(a5)
ffffffffc0203252:	9782                	jalr	a5
        intr_enable();
ffffffffc0203254:	f3efd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0203258:	b535                	j	ffffffffc0203084 <pmm_init+0x5b4>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc020325a:	00004697          	auipc	a3,0x4
ffffffffc020325e:	6ce68693          	addi	a3,a3,1742 # ffffffffc0207928 <default_pmm_manager+0x5c0>
ffffffffc0203262:	00004617          	auipc	a2,0x4
ffffffffc0203266:	d5660613          	addi	a2,a2,-682 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020326a:	25500593          	li	a1,597
ffffffffc020326e:	00004517          	auipc	a0,0x4
ffffffffc0203272:	24a50513          	addi	a0,a0,586 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203276:	a02fd0ef          	jal	ra,ffffffffc0200478 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020327a:	86ba                	mv	a3,a4
ffffffffc020327c:	00004617          	auipc	a2,0x4
ffffffffc0203280:	15c60613          	addi	a2,a2,348 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0203284:	25400593          	li	a1,596
ffffffffc0203288:	00004517          	auipc	a0,0x4
ffffffffc020328c:	23050513          	addi	a0,a0,560 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203290:	9e8fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0203294:	00004617          	auipc	a2,0x4
ffffffffc0203298:	14460613          	addi	a2,a2,324 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc020329c:	0ed00593          	li	a1,237
ffffffffc02032a0:	00004517          	auipc	a0,0x4
ffffffffc02032a4:	21850513          	addi	a0,a0,536 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02032a8:	9d0fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02032ac:	00004617          	auipc	a2,0x4
ffffffffc02032b0:	12c60613          	addi	a2,a2,300 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc02032b4:	0fa00593          	li	a1,250
ffffffffc02032b8:	00004517          	auipc	a0,0x4
ffffffffc02032bc:	20050513          	addi	a0,a0,512 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02032c0:	9b8fd0ef          	jal	ra,ffffffffc0200478 <__panic>
ffffffffc02032c4:	bcffe0ef          	jal	ra,ffffffffc0201e92 <pa2page.part.0>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02032c8:	00004697          	auipc	a3,0x4
ffffffffc02032cc:	51868693          	addi	a3,a3,1304 # ffffffffc02077e0 <default_pmm_manager+0x478>
ffffffffc02032d0:	00004617          	auipc	a2,0x4
ffffffffc02032d4:	ce860613          	addi	a2,a2,-792 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02032d8:	22e00593          	li	a1,558
ffffffffc02032dc:	00004517          	auipc	a0,0x4
ffffffffc02032e0:	1dc50513          	addi	a0,a0,476 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02032e4:	994fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02032e8:	00004697          	auipc	a3,0x4
ffffffffc02032ec:	54068693          	addi	a3,a3,1344 # ffffffffc0207828 <default_pmm_manager+0x4c0>
ffffffffc02032f0:	00004617          	auipc	a2,0x4
ffffffffc02032f4:	cc860613          	addi	a2,a2,-824 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02032f8:	23700593          	li	a1,567
ffffffffc02032fc:	00004517          	auipc	a0,0x4
ffffffffc0203300:	1bc50513          	addi	a0,a0,444 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203304:	974fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203308:	00004697          	auipc	a3,0x4
ffffffffc020330c:	3c068693          	addi	a3,a3,960 # ffffffffc02076c8 <default_pmm_manager+0x360>
ffffffffc0203310:	00004617          	auipc	a2,0x4
ffffffffc0203314:	ca860613          	addi	a2,a2,-856 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203318:	23600593          	li	a1,566
ffffffffc020331c:	00004517          	auipc	a0,0x4
ffffffffc0203320:	19c50513          	addi	a0,a0,412 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203324:	954fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0203328:	00004697          	auipc	a3,0x4
ffffffffc020332c:	51868693          	addi	a3,a3,1304 # ffffffffc0207840 <default_pmm_manager+0x4d8>
ffffffffc0203330:	00004617          	auipc	a2,0x4
ffffffffc0203334:	c8860613          	addi	a2,a2,-888 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203338:	23300593          	li	a1,563
ffffffffc020333c:	00004517          	auipc	a0,0x4
ffffffffc0203340:	17c50513          	addi	a0,a0,380 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203344:	934fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203348:	00004697          	auipc	a3,0x4
ffffffffc020334c:	36868693          	addi	a3,a3,872 # ffffffffc02076b0 <default_pmm_manager+0x348>
ffffffffc0203350:	00004617          	auipc	a2,0x4
ffffffffc0203354:	c6860613          	addi	a2,a2,-920 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203358:	23200593          	li	a1,562
ffffffffc020335c:	00004517          	auipc	a0,0x4
ffffffffc0203360:	15c50513          	addi	a0,a0,348 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203364:	914fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203368:	00004697          	auipc	a3,0x4
ffffffffc020336c:	3e868693          	addi	a3,a3,1000 # ffffffffc0207750 <default_pmm_manager+0x3e8>
ffffffffc0203370:	00004617          	auipc	a2,0x4
ffffffffc0203374:	c4860613          	addi	a2,a2,-952 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203378:	23100593          	li	a1,561
ffffffffc020337c:	00004517          	auipc	a0,0x4
ffffffffc0203380:	13c50513          	addi	a0,a0,316 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203384:	8f4fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203388:	00004697          	auipc	a3,0x4
ffffffffc020338c:	4a068693          	addi	a3,a3,1184 # ffffffffc0207828 <default_pmm_manager+0x4c0>
ffffffffc0203390:	00004617          	auipc	a2,0x4
ffffffffc0203394:	c2860613          	addi	a2,a2,-984 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203398:	23000593          	li	a1,560
ffffffffc020339c:	00004517          	auipc	a0,0x4
ffffffffc02033a0:	11c50513          	addi	a0,a0,284 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02033a4:	8d4fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02033a8:	00004697          	auipc	a3,0x4
ffffffffc02033ac:	46868693          	addi	a3,a3,1128 # ffffffffc0207810 <default_pmm_manager+0x4a8>
ffffffffc02033b0:	00004617          	auipc	a2,0x4
ffffffffc02033b4:	c0860613          	addi	a2,a2,-1016 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02033b8:	22f00593          	li	a1,559
ffffffffc02033bc:	00004517          	auipc	a0,0x4
ffffffffc02033c0:	0fc50513          	addi	a0,a0,252 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02033c4:	8b4fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02033c8:	00004697          	auipc	a3,0x4
ffffffffc02033cc:	4d868693          	addi	a3,a3,1240 # ffffffffc02078a0 <default_pmm_manager+0x538>
ffffffffc02033d0:	00004617          	auipc	a2,0x4
ffffffffc02033d4:	be860613          	addi	a2,a2,-1048 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02033d8:	24500593          	li	a1,581
ffffffffc02033dc:	00004517          	auipc	a0,0x4
ffffffffc02033e0:	0dc50513          	addi	a0,a0,220 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02033e4:	894fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc02033e8:	00004697          	auipc	a3,0x4
ffffffffc02033ec:	3e068693          	addi	a3,a3,992 # ffffffffc02077c8 <default_pmm_manager+0x460>
ffffffffc02033f0:	00004617          	auipc	a2,0x4
ffffffffc02033f4:	bc860613          	addi	a2,a2,-1080 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02033f8:	22c00593          	li	a1,556
ffffffffc02033fc:	00004517          	auipc	a0,0x4
ffffffffc0203400:	0bc50513          	addi	a0,a0,188 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203404:	874fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0203408:	00004697          	auipc	a3,0x4
ffffffffc020340c:	3a068693          	addi	a3,a3,928 # ffffffffc02077a8 <default_pmm_manager+0x440>
ffffffffc0203410:	00004617          	auipc	a2,0x4
ffffffffc0203414:	ba860613          	addi	a2,a2,-1112 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203418:	22b00593          	li	a1,555
ffffffffc020341c:	00004517          	auipc	a0,0x4
ffffffffc0203420:	09c50513          	addi	a0,a0,156 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203424:	854fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(*ptep & PTE_W);
ffffffffc0203428:	00004697          	auipc	a3,0x4
ffffffffc020342c:	37068693          	addi	a3,a3,880 # ffffffffc0207798 <default_pmm_manager+0x430>
ffffffffc0203430:	00004617          	auipc	a2,0x4
ffffffffc0203434:	b8860613          	addi	a2,a2,-1144 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203438:	22a00593          	li	a1,554
ffffffffc020343c:	00004517          	auipc	a0,0x4
ffffffffc0203440:	07c50513          	addi	a0,a0,124 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203444:	834fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0203448:	00004697          	auipc	a3,0x4
ffffffffc020344c:	41068693          	addi	a3,a3,1040 # ffffffffc0207858 <default_pmm_manager+0x4f0>
ffffffffc0203450:	00004617          	auipc	a2,0x4
ffffffffc0203454:	b6860613          	addi	a2,a2,-1176 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203458:	23a00593          	li	a1,570
ffffffffc020345c:	00004517          	auipc	a0,0x4
ffffffffc0203460:	05c50513          	addi	a0,a0,92 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203464:	814fd0ef          	jal	ra,ffffffffc0200478 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203468:	86de                	mv	a3,s7
ffffffffc020346a:	00004617          	auipc	a2,0x4
ffffffffc020346e:	f6e60613          	addi	a2,a2,-146 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0203472:	22300593          	li	a1,547
ffffffffc0203476:	00004517          	auipc	a0,0x4
ffffffffc020347a:	04250513          	addi	a0,a0,66 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc020347e:	ffbfc0ef          	jal	ra,ffffffffc0200478 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203482:	00004617          	auipc	a2,0x4
ffffffffc0203486:	f5660613          	addi	a2,a2,-170 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc020348a:	22200593          	li	a1,546
ffffffffc020348e:	00004517          	auipc	a0,0x4
ffffffffc0203492:	02a50513          	addi	a0,a0,42 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203496:	fe3fc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020349a:	00004697          	auipc	a3,0x4
ffffffffc020349e:	22e68693          	addi	a3,a3,558 # ffffffffc02076c8 <default_pmm_manager+0x360>
ffffffffc02034a2:	00004617          	auipc	a2,0x4
ffffffffc02034a6:	b1660613          	addi	a2,a2,-1258 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02034aa:	22000593          	li	a1,544
ffffffffc02034ae:	00004517          	auipc	a0,0x4
ffffffffc02034b2:	00a50513          	addi	a0,a0,10 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02034b6:	fc3fc0ef          	jal	ra,ffffffffc0200478 <__panic>
ffffffffc02034ba:	9f5fe0ef          	jal	ra,ffffffffc0201eae <pte2page.part.0>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02034be:	00004697          	auipc	a3,0x4
ffffffffc02034c2:	1c268693          	addi	a3,a3,450 # ffffffffc0207680 <default_pmm_manager+0x318>
ffffffffc02034c6:	00004617          	auipc	a2,0x4
ffffffffc02034ca:	af260613          	addi	a2,a2,-1294 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02034ce:	21e00593          	li	a1,542
ffffffffc02034d2:	00004517          	auipc	a0,0x4
ffffffffc02034d6:	fe650513          	addi	a0,a0,-26 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02034da:	f9ffc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02034de:	00004697          	auipc	a3,0x4
ffffffffc02034e2:	17268693          	addi	a3,a3,370 # ffffffffc0207650 <default_pmm_manager+0x2e8>
ffffffffc02034e6:	00004617          	auipc	a2,0x4
ffffffffc02034ea:	ad260613          	addi	a2,a2,-1326 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02034ee:	21b00593          	li	a1,539
ffffffffc02034f2:	00004517          	auipc	a0,0x4
ffffffffc02034f6:	fc650513          	addi	a0,a0,-58 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02034fa:	f7ffc0ef          	jal	ra,ffffffffc0200478 <__panic>
        panic("DTB memory info not available");
ffffffffc02034fe:	00004617          	auipc	a2,0x4
ffffffffc0203502:	02a60613          	addi	a2,a2,42 # ffffffffc0207528 <default_pmm_manager+0x1c0>
ffffffffc0203506:	06500593          	li	a1,101
ffffffffc020350a:	00004517          	auipc	a0,0x4
ffffffffc020350e:	fae50513          	addi	a0,a0,-82 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203512:	f67fc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203516:	00004697          	auipc	a3,0x4
ffffffffc020351a:	38a68693          	addi	a3,a3,906 # ffffffffc02078a0 <default_pmm_manager+0x538>
ffffffffc020351e:	00004617          	auipc	a2,0x4
ffffffffc0203522:	a9a60613          	addi	a2,a2,-1382 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203526:	26f00593          	li	a1,623
ffffffffc020352a:	00004517          	auipc	a0,0x4
ffffffffc020352e:	f8e50513          	addi	a0,a0,-114 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203532:	f47fc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0203536:	00004697          	auipc	a3,0x4
ffffffffc020353a:	0aa68693          	addi	a3,a3,170 # ffffffffc02075e0 <default_pmm_manager+0x278>
ffffffffc020353e:	00004617          	auipc	a2,0x4
ffffffffc0203542:	a7a60613          	addi	a2,a2,-1414 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203546:	21600593          	li	a1,534
ffffffffc020354a:	00004517          	auipc	a0,0x4
ffffffffc020354e:	f6e50513          	addi	a0,a0,-146 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203552:	f27fc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0203556:	00004697          	auipc	a3,0x4
ffffffffc020355a:	06a68693          	addi	a3,a3,106 # ffffffffc02075c0 <default_pmm_manager+0x258>
ffffffffc020355e:	00004617          	auipc	a2,0x4
ffffffffc0203562:	a5a60613          	addi	a2,a2,-1446 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203566:	21500593          	li	a1,533
ffffffffc020356a:	00004517          	auipc	a0,0x4
ffffffffc020356e:	f4e50513          	addi	a0,a0,-178 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203572:	f07fc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0203576:	00004697          	auipc	a3,0x4
ffffffffc020357a:	16a68693          	addi	a3,a3,362 # ffffffffc02076e0 <default_pmm_manager+0x378>
ffffffffc020357e:	00004617          	auipc	a2,0x4
ffffffffc0203582:	a3a60613          	addi	a2,a2,-1478 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203586:	22400593          	li	a1,548
ffffffffc020358a:	00004517          	auipc	a0,0x4
ffffffffc020358e:	f2e50513          	addi	a0,a0,-210 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203592:	ee7fc0ef          	jal	ra,ffffffffc0200478 <__panic>
    return KADDR(page2pa(page));
ffffffffc0203596:	00004617          	auipc	a2,0x4
ffffffffc020359a:	e4260613          	addi	a2,a2,-446 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc020359e:	07100593          	li	a1,113
ffffffffc02035a2:	00004517          	auipc	a0,0x4
ffffffffc02035a6:	e5e50513          	addi	a0,a0,-418 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc02035aa:	ecffc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc02035ae:	00004697          	auipc	a3,0x4
ffffffffc02035b2:	2c268693          	addi	a3,a3,706 # ffffffffc0207870 <default_pmm_manager+0x508>
ffffffffc02035b6:	00004617          	auipc	a2,0x4
ffffffffc02035ba:	a0260613          	addi	a2,a2,-1534 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02035be:	23d00593          	li	a1,573
ffffffffc02035c2:	00004517          	auipc	a0,0x4
ffffffffc02035c6:	ef650513          	addi	a0,a0,-266 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02035ca:	eaffc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02035ce:	00004697          	auipc	a3,0x4
ffffffffc02035d2:	25a68693          	addi	a3,a3,602 # ffffffffc0207828 <default_pmm_manager+0x4c0>
ffffffffc02035d6:	00004617          	auipc	a2,0x4
ffffffffc02035da:	9e260613          	addi	a2,a2,-1566 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02035de:	23b00593          	li	a1,571
ffffffffc02035e2:	00004517          	auipc	a0,0x4
ffffffffc02035e6:	ed650513          	addi	a0,a0,-298 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02035ea:	e8ffc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02035ee:	00004697          	auipc	a3,0x4
ffffffffc02035f2:	47268693          	addi	a3,a3,1138 # ffffffffc0207a60 <default_pmm_manager+0x6f8>
ffffffffc02035f6:	00004617          	auipc	a2,0x4
ffffffffc02035fa:	9c260613          	addi	a2,a2,-1598 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02035fe:	26600593          	li	a1,614
ffffffffc0203602:	00004517          	auipc	a0,0x4
ffffffffc0203606:	eb650513          	addi	a0,a0,-330 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc020360a:	e6ffc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc020360e:	00004697          	auipc	a3,0x4
ffffffffc0203612:	41a68693          	addi	a3,a3,1050 # ffffffffc0207a28 <default_pmm_manager+0x6c0>
ffffffffc0203616:	00004617          	auipc	a2,0x4
ffffffffc020361a:	9a260613          	addi	a2,a2,-1630 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020361e:	26300593          	li	a1,611
ffffffffc0203622:	00004517          	auipc	a0,0x4
ffffffffc0203626:	e9650513          	addi	a0,a0,-362 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc020362a:	e4ffc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_ref(p) == 2);
ffffffffc020362e:	00004697          	auipc	a3,0x4
ffffffffc0203632:	3ca68693          	addi	a3,a3,970 # ffffffffc02079f8 <default_pmm_manager+0x690>
ffffffffc0203636:	00004617          	auipc	a2,0x4
ffffffffc020363a:	98260613          	addi	a2,a2,-1662 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020363e:	25f00593          	li	a1,607
ffffffffc0203642:	00004517          	auipc	a0,0x4
ffffffffc0203646:	e7650513          	addi	a0,a0,-394 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc020364a:	e2ffc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc020364e:	00004697          	auipc	a3,0x4
ffffffffc0203652:	36268693          	addi	a3,a3,866 # ffffffffc02079b0 <default_pmm_manager+0x648>
ffffffffc0203656:	00004617          	auipc	a2,0x4
ffffffffc020365a:	96260613          	addi	a2,a2,-1694 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020365e:	25e00593          	li	a1,606
ffffffffc0203662:	00004517          	auipc	a0,0x4
ffffffffc0203666:	e5650513          	addi	a0,a0,-426 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc020366a:	e0ffc0ef          	jal	ra,ffffffffc0200478 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020366e:	00004617          	auipc	a2,0x4
ffffffffc0203672:	dda60613          	addi	a2,a2,-550 # ffffffffc0207448 <default_pmm_manager+0xe0>
ffffffffc0203676:	0c900593          	li	a1,201
ffffffffc020367a:	00004517          	auipc	a0,0x4
ffffffffc020367e:	e3e50513          	addi	a0,a0,-450 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203682:	df7fc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203686:	00004697          	auipc	a3,0x4
ffffffffc020368a:	08a68693          	addi	a3,a3,138 # ffffffffc0207710 <default_pmm_manager+0x3a8>
ffffffffc020368e:	00004617          	auipc	a2,0x4
ffffffffc0203692:	92a60613          	addi	a2,a2,-1750 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203696:	22700593          	li	a1,551
ffffffffc020369a:	00004517          	auipc	a0,0x4
ffffffffc020369e:	e1e50513          	addi	a0,a0,-482 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02036a2:	dd7fc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(*ptep & PTE_U);
ffffffffc02036a6:	00004697          	auipc	a3,0x4
ffffffffc02036aa:	0e268693          	addi	a3,a3,226 # ffffffffc0207788 <default_pmm_manager+0x420>
ffffffffc02036ae:	00004617          	auipc	a2,0x4
ffffffffc02036b2:	90a60613          	addi	a2,a2,-1782 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02036b6:	22900593          	li	a1,553
ffffffffc02036ba:	00004517          	auipc	a0,0x4
ffffffffc02036be:	dfe50513          	addi	a0,a0,-514 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02036c2:	db7fc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02036c6:	00004697          	auipc	a3,0x4
ffffffffc02036ca:	08a68693          	addi	a3,a3,138 # ffffffffc0207750 <default_pmm_manager+0x3e8>
ffffffffc02036ce:	00004617          	auipc	a2,0x4
ffffffffc02036d2:	8ea60613          	addi	a2,a2,-1814 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02036d6:	22800593          	li	a1,552
ffffffffc02036da:	00004517          	auipc	a0,0x4
ffffffffc02036de:	dde50513          	addi	a0,a0,-546 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02036e2:	d97fc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc02036e6:	00004697          	auipc	a3,0x4
ffffffffc02036ea:	25a68693          	addi	a3,a3,602 # ffffffffc0207940 <default_pmm_manager+0x5d8>
ffffffffc02036ee:	00004617          	auipc	a2,0x4
ffffffffc02036f2:	8ca60613          	addi	a2,a2,-1846 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02036f6:	25800593          	li	a1,600
ffffffffc02036fa:	00004517          	auipc	a0,0x4
ffffffffc02036fe:	dbe50513          	addi	a0,a0,-578 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203702:	d77fc0ef          	jal	ra,ffffffffc0200478 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203706:	00004617          	auipc	a2,0x4
ffffffffc020370a:	d4260613          	addi	a2,a2,-702 # ffffffffc0207448 <default_pmm_manager+0xe0>
ffffffffc020370e:	08100593          	li	a1,129
ffffffffc0203712:	00004517          	auipc	a0,0x4
ffffffffc0203716:	da650513          	addi	a0,a0,-602 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc020371a:	d5ffc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_ref(p) == 1);
ffffffffc020371e:	00004697          	auipc	a3,0x4
ffffffffc0203722:	27a68693          	addi	a3,a3,634 # ffffffffc0207998 <default_pmm_manager+0x630>
ffffffffc0203726:	00004617          	auipc	a2,0x4
ffffffffc020372a:	89260613          	addi	a2,a2,-1902 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020372e:	25d00593          	li	a1,605
ffffffffc0203732:	00004517          	auipc	a0,0x4
ffffffffc0203736:	d8650513          	addi	a0,a0,-634 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc020373a:	d3ffc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc020373e:	00004697          	auipc	a3,0x4
ffffffffc0203742:	21a68693          	addi	a3,a3,538 # ffffffffc0207958 <default_pmm_manager+0x5f0>
ffffffffc0203746:	00004617          	auipc	a2,0x4
ffffffffc020374a:	87260613          	addi	a2,a2,-1934 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020374e:	25c00593          	li	a1,604
ffffffffc0203752:	00004517          	auipc	a0,0x4
ffffffffc0203756:	d6650513          	addi	a0,a0,-666 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc020375a:	d1ffc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020375e:	00004697          	auipc	a3,0x4
ffffffffc0203762:	f5268693          	addi	a3,a3,-174 # ffffffffc02076b0 <default_pmm_manager+0x348>
ffffffffc0203766:	00004617          	auipc	a2,0x4
ffffffffc020376a:	85260613          	addi	a2,a2,-1966 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020376e:	21f00593          	li	a1,543
ffffffffc0203772:	00004517          	auipc	a0,0x4
ffffffffc0203776:	d4650513          	addi	a0,a0,-698 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc020377a:	cfffc0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc020377e <copy_range>:
{
ffffffffc020377e:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203780:	00d667b3          	or	a5,a2,a3
{
ffffffffc0203784:	f486                	sd	ra,104(sp)
ffffffffc0203786:	f0a2                	sd	s0,96(sp)
ffffffffc0203788:	eca6                	sd	s1,88(sp)
ffffffffc020378a:	e8ca                	sd	s2,80(sp)
ffffffffc020378c:	e4ce                	sd	s3,72(sp)
ffffffffc020378e:	e0d2                	sd	s4,64(sp)
ffffffffc0203790:	fc56                	sd	s5,56(sp)
ffffffffc0203792:	f85a                	sd	s6,48(sp)
ffffffffc0203794:	f45e                	sd	s7,40(sp)
ffffffffc0203796:	f062                	sd	s8,32(sp)
ffffffffc0203798:	ec66                	sd	s9,24(sp)
ffffffffc020379a:	e86a                	sd	s10,16(sp)
ffffffffc020379c:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020379e:	17d2                	slli	a5,a5,0x34
ffffffffc02037a0:	2a079563          	bnez	a5,ffffffffc0203a4a <copy_range+0x2cc>
    assert(USER_ACCESS(start, end));
ffffffffc02037a4:	002007b7          	lui	a5,0x200
ffffffffc02037a8:	8d32                	mv	s10,a2
ffffffffc02037aa:	24f66463          	bltu	a2,a5,ffffffffc02039f2 <copy_range+0x274>
ffffffffc02037ae:	8436                	mv	s0,a3
ffffffffc02037b0:	24d67163          	bgeu	a2,a3,ffffffffc02039f2 <copy_range+0x274>
ffffffffc02037b4:	4785                	li	a5,1
ffffffffc02037b6:	07fe                	slli	a5,a5,0x1f
ffffffffc02037b8:	22d7ed63          	bltu	a5,a3,ffffffffc02039f2 <copy_range+0x274>
ffffffffc02037bc:	5afd                	li	s5,-1
ffffffffc02037be:	8a2a                	mv	s4,a0
ffffffffc02037c0:	84ae                	mv	s1,a1
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02037c2:	00143917          	auipc	s2,0x143
ffffffffc02037c6:	a3e90913          	addi	s2,s2,-1474 # ffffffffc0346200 <npage>
ffffffffc02037ca:	00143997          	auipc	s3,0x143
ffffffffc02037ce:	a4e98993          	addi	s3,s3,-1458 # ffffffffc0346218 <va_pa_offset>
    return &pages[PPN(pa) - nbase];
ffffffffc02037d2:	00143b17          	auipc	s6,0x143
ffffffffc02037d6:	a36b0b13          	addi	s6,s6,-1482 # ffffffffc0346208 <pages>
    return KADDR(page2pa(page));
ffffffffc02037da:	00cada93          	srli	s5,s5,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc02037de:	00143b97          	auipc	s7,0x143
ffffffffc02037e2:	a32b8b93          	addi	s7,s7,-1486 # ffffffffc0346210 <pmm_manager>
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02037e6:	01ed5793          	srli	a5,s10,0x1e
ffffffffc02037ea:	1ff7f793          	andi	a5,a5,511
    if (!(*pdep1 & PTE_V))
ffffffffc02037ee:	078e                	slli	a5,a5,0x3
ffffffffc02037f0:	97a6                	add	a5,a5,s1
ffffffffc02037f2:	639c                	ld	a5,0(a5)
ffffffffc02037f4:	0017f713          	andi	a4,a5,1
ffffffffc02037f8:	ef05                	bnez	a4,ffffffffc0203830 <copy_range+0xb2>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02037fa:	002007b7          	lui	a5,0x200
ffffffffc02037fe:	9d3e                	add	s10,s10,a5
ffffffffc0203800:	ffe007b7          	lui	a5,0xffe00
ffffffffc0203804:	00fd7d33          	and	s10,s10,a5
    } while (start != 0 && start < end);
ffffffffc0203808:	000d0463          	beqz	s10,ffffffffc0203810 <copy_range+0x92>
ffffffffc020380c:	fc8d6de3          	bltu	s10,s0,ffffffffc02037e6 <copy_range+0x68>
    return 0;
ffffffffc0203810:	4501                	li	a0,0
}
ffffffffc0203812:	70a6                	ld	ra,104(sp)
ffffffffc0203814:	7406                	ld	s0,96(sp)
ffffffffc0203816:	64e6                	ld	s1,88(sp)
ffffffffc0203818:	6946                	ld	s2,80(sp)
ffffffffc020381a:	69a6                	ld	s3,72(sp)
ffffffffc020381c:	6a06                	ld	s4,64(sp)
ffffffffc020381e:	7ae2                	ld	s5,56(sp)
ffffffffc0203820:	7b42                	ld	s6,48(sp)
ffffffffc0203822:	7ba2                	ld	s7,40(sp)
ffffffffc0203824:	7c02                	ld	s8,32(sp)
ffffffffc0203826:	6ce2                	ld	s9,24(sp)
ffffffffc0203828:	6d42                	ld	s10,16(sp)
ffffffffc020382a:	6da2                	ld	s11,8(sp)
ffffffffc020382c:	6165                	addi	sp,sp,112
ffffffffc020382e:	8082                	ret
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0203830:	078a                	slli	a5,a5,0x2
ffffffffc0203832:	7dfd                	lui	s11,0xfffff
ffffffffc0203834:	00093603          	ld	a2,0(s2)
ffffffffc0203838:	01b7f6b3          	and	a3,a5,s11
ffffffffc020383c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0203840:	12c7f863          	bgeu	a5,a2,ffffffffc0203970 <copy_range+0x1f2>
ffffffffc0203844:	015d5793          	srli	a5,s10,0x15
ffffffffc0203848:	0009b703          	ld	a4,0(s3)
ffffffffc020384c:	1ff7f793          	andi	a5,a5,511
    if (!(*pdep0 & PTE_V))
ffffffffc0203850:	078e                	slli	a5,a5,0x3
ffffffffc0203852:	97b6                	add	a5,a5,a3
ffffffffc0203854:	97ba                	add	a5,a5,a4
ffffffffc0203856:	6394                	ld	a3,0(a5)
ffffffffc0203858:	0016f793          	andi	a5,a3,1
ffffffffc020385c:	dfd9                	beqz	a5,ffffffffc02037fa <copy_range+0x7c>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020385e:	068a                	slli	a3,a3,0x2
ffffffffc0203860:	01b6f6b3          	and	a3,a3,s11
ffffffffc0203864:	00c6d793          	srli	a5,a3,0xc
ffffffffc0203868:	12c7fd63          	bgeu	a5,a2,ffffffffc02039a2 <copy_range+0x224>
ffffffffc020386c:	00cd5793          	srli	a5,s10,0xc
ffffffffc0203870:	1ff7f793          	andi	a5,a5,511
ffffffffc0203874:	9736                	add	a4,a4,a3
ffffffffc0203876:	00379d93          	slli	s11,a5,0x3
ffffffffc020387a:	9dba                	add	s11,s11,a4
        if (ptep == NULL)
ffffffffc020387c:	f60d8fe3          	beqz	s11,ffffffffc02037fa <copy_range+0x7c>
        if (*ptep & PTE_V)
ffffffffc0203880:	000db783          	ld	a5,0(s11) # fffffffffffff000 <end+0x3fcb8db0>
ffffffffc0203884:	8b85                	andi	a5,a5,1
ffffffffc0203886:	e791                	bnez	a5,ffffffffc0203892 <copy_range+0x114>
        start += PGSIZE;
ffffffffc0203888:	6785                	lui	a5,0x1
ffffffffc020388a:	9d3e                	add	s10,s10,a5
    } while (start != 0 && start < end);
ffffffffc020388c:	f48d6de3          	bltu	s10,s0,ffffffffc02037e6 <copy_range+0x68>
ffffffffc0203890:	b741                	j	ffffffffc0203810 <copy_range+0x92>
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203892:	4605                	li	a2,1
ffffffffc0203894:	85ea                	mv	a1,s10
ffffffffc0203896:	8552                	mv	a0,s4
ffffffffc0203898:	f92fe0ef          	jal	ra,ffffffffc020202a <get_pte>
ffffffffc020389c:	c961                	beqz	a0,ffffffffc020396c <copy_range+0x1ee>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc020389e:	000db783          	ld	a5,0(s11)
    if (!(pte & PTE_V))
ffffffffc02038a2:	0017f713          	andi	a4,a5,1
ffffffffc02038a6:	01f7fd93          	andi	s11,a5,31
ffffffffc02038aa:	16070463          	beqz	a4,ffffffffc0203a12 <copy_range+0x294>
    if (PPN(pa) >= npage)
ffffffffc02038ae:	00093683          	ld	a3,0(s2)
    return pa2page(PTE_ADDR(pte));
ffffffffc02038b2:	078a                	slli	a5,a5,0x2
ffffffffc02038b4:	00c7d713          	srli	a4,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02038b8:	10d77163          	bgeu	a4,a3,ffffffffc02039ba <copy_range+0x23c>
    return &pages[PPN(pa) - nbase];
ffffffffc02038bc:	000b3783          	ld	a5,0(s6)
ffffffffc02038c0:	fff806b7          	lui	a3,0xfff80
ffffffffc02038c4:	9736                	add	a4,a4,a3
ffffffffc02038c6:	071a                	slli	a4,a4,0x6
ffffffffc02038c8:	00e78cb3          	add	s9,a5,a4
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02038cc:	10002773          	csrr	a4,sstatus
ffffffffc02038d0:	8b09                	andi	a4,a4,2
ffffffffc02038d2:	e351                	bnez	a4,ffffffffc0203956 <copy_range+0x1d8>
        page = pmm_manager->alloc_pages(n);
ffffffffc02038d4:	000bb703          	ld	a4,0(s7)
ffffffffc02038d8:	4505                	li	a0,1
ffffffffc02038da:	6f18                	ld	a4,24(a4)
ffffffffc02038dc:	9702                	jalr	a4
ffffffffc02038de:	8c2a                	mv	s8,a0
            assert(page != NULL);
ffffffffc02038e0:	140c8563          	beqz	s9,ffffffffc0203a2a <copy_range+0x2ac>
            assert(npage != NULL);
ffffffffc02038e4:	0e0c0763          	beqz	s8,ffffffffc02039d2 <copy_range+0x254>
    return page - pages + nbase;
ffffffffc02038e8:	000b3703          	ld	a4,0(s6)
ffffffffc02038ec:	000805b7          	lui	a1,0x80
    return KADDR(page2pa(page));
ffffffffc02038f0:	00093603          	ld	a2,0(s2)
    return page - pages + nbase;
ffffffffc02038f4:	40ec86b3          	sub	a3,s9,a4
ffffffffc02038f8:	8699                	srai	a3,a3,0x6
ffffffffc02038fa:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc02038fc:	0156f7b3          	and	a5,a3,s5
    return page2ppn(page) << PGSHIFT;
ffffffffc0203900:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203902:	08c7f463          	bgeu	a5,a2,ffffffffc020398a <copy_range+0x20c>
    return page - pages + nbase;
ffffffffc0203906:	40ec07b3          	sub	a5,s8,a4
    return KADDR(page2pa(page));
ffffffffc020390a:	0009b503          	ld	a0,0(s3)
    return page - pages + nbase;
ffffffffc020390e:	8799                	srai	a5,a5,0x6
ffffffffc0203910:	97ae                	add	a5,a5,a1
    return KADDR(page2pa(page));
ffffffffc0203912:	0157f733          	and	a4,a5,s5
ffffffffc0203916:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc020391a:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc020391c:	06c77663          	bgeu	a4,a2,ffffffffc0203988 <copy_range+0x20a>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc0203920:	6605                	lui	a2,0x1
ffffffffc0203922:	953e                	add	a0,a0,a5
ffffffffc0203924:	30f020ef          	jal	ra,ffffffffc0206432 <memcpy>
            ret = page_insert(to, npage, start, perm);            
ffffffffc0203928:	86ee                	mv	a3,s11
ffffffffc020392a:	866a                	mv	a2,s10
ffffffffc020392c:	85e2                	mv	a1,s8
ffffffffc020392e:	8552                	mv	a0,s4
ffffffffc0203930:	eb5fe0ef          	jal	ra,ffffffffc02027e4 <page_insert>
            assert(ret == 0);
ffffffffc0203934:	d931                	beqz	a0,ffffffffc0203888 <copy_range+0x10a>
ffffffffc0203936:	00004697          	auipc	a3,0x4
ffffffffc020393a:	19268693          	addi	a3,a3,402 # ffffffffc0207ac8 <default_pmm_manager+0x760>
ffffffffc020393e:	00003617          	auipc	a2,0x3
ffffffffc0203942:	67a60613          	addi	a2,a2,1658 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203946:	1b300593          	li	a1,435
ffffffffc020394a:	00004517          	auipc	a0,0x4
ffffffffc020394e:	b6e50513          	addi	a0,a0,-1170 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203952:	b27fc0ef          	jal	ra,ffffffffc0200478 <__panic>
        intr_disable();
ffffffffc0203956:	842fd0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020395a:	000bb703          	ld	a4,0(s7)
ffffffffc020395e:	4505                	li	a0,1
ffffffffc0203960:	6f18                	ld	a4,24(a4)
ffffffffc0203962:	9702                	jalr	a4
ffffffffc0203964:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0203966:	82cfd0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc020396a:	bf9d                	j	ffffffffc02038e0 <copy_range+0x162>
                return -E_NO_MEM;
ffffffffc020396c:	5571                	li	a0,-4
ffffffffc020396e:	b555                	j	ffffffffc0203812 <copy_range+0x94>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0203970:	00004617          	auipc	a2,0x4
ffffffffc0203974:	a6860613          	addi	a2,a2,-1432 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0203978:	0ed00593          	li	a1,237
ffffffffc020397c:	00004517          	auipc	a0,0x4
ffffffffc0203980:	b3c50513          	addi	a0,a0,-1220 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203984:	af5fc0ef          	jal	ra,ffffffffc0200478 <__panic>
ffffffffc0203988:	86be                	mv	a3,a5
ffffffffc020398a:	00004617          	auipc	a2,0x4
ffffffffc020398e:	a4e60613          	addi	a2,a2,-1458 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0203992:	07100593          	li	a1,113
ffffffffc0203996:	00004517          	auipc	a0,0x4
ffffffffc020399a:	a6a50513          	addi	a0,a0,-1430 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc020399e:	adbfc0ef          	jal	ra,ffffffffc0200478 <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02039a2:	00004617          	auipc	a2,0x4
ffffffffc02039a6:	a3660613          	addi	a2,a2,-1482 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc02039aa:	0fa00593          	li	a1,250
ffffffffc02039ae:	00004517          	auipc	a0,0x4
ffffffffc02039b2:	b0a50513          	addi	a0,a0,-1270 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02039b6:	ac3fc0ef          	jal	ra,ffffffffc0200478 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02039ba:	00004617          	auipc	a2,0x4
ffffffffc02039be:	ab660613          	addi	a2,a2,-1354 # ffffffffc0207470 <default_pmm_manager+0x108>
ffffffffc02039c2:	06900593          	li	a1,105
ffffffffc02039c6:	00004517          	auipc	a0,0x4
ffffffffc02039ca:	a3a50513          	addi	a0,a0,-1478 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc02039ce:	aabfc0ef          	jal	ra,ffffffffc0200478 <__panic>
            assert(npage != NULL);
ffffffffc02039d2:	00004697          	auipc	a3,0x4
ffffffffc02039d6:	0e668693          	addi	a3,a3,230 # ffffffffc0207ab8 <default_pmm_manager+0x750>
ffffffffc02039da:	00003617          	auipc	a2,0x3
ffffffffc02039de:	5de60613          	addi	a2,a2,1502 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02039e2:	19700593          	li	a1,407
ffffffffc02039e6:	00004517          	auipc	a0,0x4
ffffffffc02039ea:	ad250513          	addi	a0,a0,-1326 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc02039ee:	a8bfc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02039f2:	00004697          	auipc	a3,0x4
ffffffffc02039f6:	b0668693          	addi	a3,a3,-1274 # ffffffffc02074f8 <default_pmm_manager+0x190>
ffffffffc02039fa:	00003617          	auipc	a2,0x3
ffffffffc02039fe:	5be60613          	addi	a2,a2,1470 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203a02:	17e00593          	li	a1,382
ffffffffc0203a06:	00004517          	auipc	a0,0x4
ffffffffc0203a0a:	ab250513          	addi	a0,a0,-1358 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203a0e:	a6bfc0ef          	jal	ra,ffffffffc0200478 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0203a12:	00004617          	auipc	a2,0x4
ffffffffc0203a16:	a7e60613          	addi	a2,a2,-1410 # ffffffffc0207490 <default_pmm_manager+0x128>
ffffffffc0203a1a:	07f00593          	li	a1,127
ffffffffc0203a1e:	00004517          	auipc	a0,0x4
ffffffffc0203a22:	9e250513          	addi	a0,a0,-1566 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc0203a26:	a53fc0ef          	jal	ra,ffffffffc0200478 <__panic>
            assert(page != NULL);
ffffffffc0203a2a:	00004697          	auipc	a3,0x4
ffffffffc0203a2e:	07e68693          	addi	a3,a3,126 # ffffffffc0207aa8 <default_pmm_manager+0x740>
ffffffffc0203a32:	00003617          	auipc	a2,0x3
ffffffffc0203a36:	58660613          	addi	a2,a2,1414 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203a3a:	19600593          	li	a1,406
ffffffffc0203a3e:	00004517          	auipc	a0,0x4
ffffffffc0203a42:	a7a50513          	addi	a0,a0,-1414 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203a46:	a33fc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203a4a:	00004697          	auipc	a3,0x4
ffffffffc0203a4e:	a7e68693          	addi	a3,a3,-1410 # ffffffffc02074c8 <default_pmm_manager+0x160>
ffffffffc0203a52:	00003617          	auipc	a2,0x3
ffffffffc0203a56:	56660613          	addi	a2,a2,1382 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203a5a:	17d00593          	li	a1,381
ffffffffc0203a5e:	00004517          	auipc	a0,0x4
ffffffffc0203a62:	a5a50513          	addi	a0,a0,-1446 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203a66:	a13fc0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0203a6a <pgdir_alloc_page>:
{
ffffffffc0203a6a:	7179                	addi	sp,sp,-48
ffffffffc0203a6c:	ec26                	sd	s1,24(sp)
ffffffffc0203a6e:	e84a                	sd	s2,16(sp)
ffffffffc0203a70:	e052                	sd	s4,0(sp)
ffffffffc0203a72:	f406                	sd	ra,40(sp)
ffffffffc0203a74:	f022                	sd	s0,32(sp)
ffffffffc0203a76:	e44e                	sd	s3,8(sp)
ffffffffc0203a78:	8a2a                	mv	s4,a0
ffffffffc0203a7a:	84ae                	mv	s1,a1
ffffffffc0203a7c:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203a7e:	100027f3          	csrr	a5,sstatus
ffffffffc0203a82:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc0203a84:	00142997          	auipc	s3,0x142
ffffffffc0203a88:	78c98993          	addi	s3,s3,1932 # ffffffffc0346210 <pmm_manager>
ffffffffc0203a8c:	ef8d                	bnez	a5,ffffffffc0203ac6 <pgdir_alloc_page+0x5c>
ffffffffc0203a8e:	0009b783          	ld	a5,0(s3)
ffffffffc0203a92:	4505                	li	a0,1
ffffffffc0203a94:	6f9c                	ld	a5,24(a5)
ffffffffc0203a96:	9782                	jalr	a5
ffffffffc0203a98:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc0203a9a:	cc09                	beqz	s0,ffffffffc0203ab4 <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc0203a9c:	86ca                	mv	a3,s2
ffffffffc0203a9e:	8626                	mv	a2,s1
ffffffffc0203aa0:	85a2                	mv	a1,s0
ffffffffc0203aa2:	8552                	mv	a0,s4
ffffffffc0203aa4:	d41fe0ef          	jal	ra,ffffffffc02027e4 <page_insert>
ffffffffc0203aa8:	e915                	bnez	a0,ffffffffc0203adc <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc0203aaa:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc0203aac:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc0203aae:	4785                	li	a5,1
ffffffffc0203ab0:	04f71e63          	bne	a4,a5,ffffffffc0203b0c <pgdir_alloc_page+0xa2>
}
ffffffffc0203ab4:	70a2                	ld	ra,40(sp)
ffffffffc0203ab6:	8522                	mv	a0,s0
ffffffffc0203ab8:	7402                	ld	s0,32(sp)
ffffffffc0203aba:	64e2                	ld	s1,24(sp)
ffffffffc0203abc:	6942                	ld	s2,16(sp)
ffffffffc0203abe:	69a2                	ld	s3,8(sp)
ffffffffc0203ac0:	6a02                	ld	s4,0(sp)
ffffffffc0203ac2:	6145                	addi	sp,sp,48
ffffffffc0203ac4:	8082                	ret
        intr_disable();
ffffffffc0203ac6:	ed3fc0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203aca:	0009b783          	ld	a5,0(s3)
ffffffffc0203ace:	4505                	li	a0,1
ffffffffc0203ad0:	6f9c                	ld	a5,24(a5)
ffffffffc0203ad2:	9782                	jalr	a5
ffffffffc0203ad4:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203ad6:	ebdfc0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0203ada:	b7c1                	j	ffffffffc0203a9a <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203adc:	100027f3          	csrr	a5,sstatus
ffffffffc0203ae0:	8b89                	andi	a5,a5,2
ffffffffc0203ae2:	eb89                	bnez	a5,ffffffffc0203af4 <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc0203ae4:	0009b783          	ld	a5,0(s3)
ffffffffc0203ae8:	8522                	mv	a0,s0
ffffffffc0203aea:	4585                	li	a1,1
ffffffffc0203aec:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203aee:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203af0:	9782                	jalr	a5
    if (flag)
ffffffffc0203af2:	b7c9                	j	ffffffffc0203ab4 <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc0203af4:	ea5fc0ef          	jal	ra,ffffffffc0200998 <intr_disable>
ffffffffc0203af8:	0009b783          	ld	a5,0(s3)
ffffffffc0203afc:	8522                	mv	a0,s0
ffffffffc0203afe:	4585                	li	a1,1
ffffffffc0203b00:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203b02:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203b04:	9782                	jalr	a5
        intr_enable();
ffffffffc0203b06:	e8dfc0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0203b0a:	b76d                	j	ffffffffc0203ab4 <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc0203b0c:	00004697          	auipc	a3,0x4
ffffffffc0203b10:	fcc68693          	addi	a3,a3,-52 # ffffffffc0207ad8 <default_pmm_manager+0x770>
ffffffffc0203b14:	00003617          	auipc	a2,0x3
ffffffffc0203b18:	4a460613          	addi	a2,a2,1188 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203b1c:	1fc00593          	li	a1,508
ffffffffc0203b20:	00004517          	auipc	a0,0x4
ffffffffc0203b24:	99850513          	addi	a0,a0,-1640 # ffffffffc02074b8 <default_pmm_manager+0x150>
ffffffffc0203b28:	951fc0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0203b2c <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203b2c:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0203b2e:	00004697          	auipc	a3,0x4
ffffffffc0203b32:	fc268693          	addi	a3,a3,-62 # ffffffffc0207af0 <default_pmm_manager+0x788>
ffffffffc0203b36:	00003617          	auipc	a2,0x3
ffffffffc0203b3a:	48260613          	addi	a2,a2,1154 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203b3e:	07400593          	li	a1,116
ffffffffc0203b42:	00004517          	auipc	a0,0x4
ffffffffc0203b46:	fce50513          	addi	a0,a0,-50 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203b4a:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0203b4c:	92dfc0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0203b50 <mm_create>:
{
ffffffffc0203b50:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203b52:	04000513          	li	a0,64
{
ffffffffc0203b56:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203b58:	93afe0ef          	jal	ra,ffffffffc0201c92 <kmalloc>
    if (mm != NULL)
ffffffffc0203b5c:	cd19                	beqz	a0,ffffffffc0203b7a <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc0203b5e:	e508                	sd	a0,8(a0)
ffffffffc0203b60:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203b62:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203b66:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203b6a:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203b6e:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc0203b72:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc0203b76:	02053c23          	sd	zero,56(a0)
}
ffffffffc0203b7a:	60a2                	ld	ra,8(sp)
ffffffffc0203b7c:	0141                	addi	sp,sp,16
ffffffffc0203b7e:	8082                	ret

ffffffffc0203b80 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203b80:	6590                	ld	a2,8(a1)
ffffffffc0203b82:	0105b803          	ld	a6,16(a1) # 80010 <_binary_obj___user_matrix_out_size+0x69490>
{
ffffffffc0203b86:	1141                	addi	sp,sp,-16
ffffffffc0203b88:	e406                	sd	ra,8(sp)
ffffffffc0203b8a:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203b8c:	01066763          	bltu	a2,a6,ffffffffc0203b9a <insert_vma_struct+0x1a>
ffffffffc0203b90:	a085                	j	ffffffffc0203bf0 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203b92:	fe87b703          	ld	a4,-24(a5) # fe8 <_binary_obj___user_faultread_out_size-0x103c0>
ffffffffc0203b96:	04e66863          	bltu	a2,a4,ffffffffc0203be6 <insert_vma_struct+0x66>
    return listelm->next;
ffffffffc0203b9a:	86be                	mv	a3,a5
ffffffffc0203b9c:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0203b9e:	fef51ae3          	bne	a0,a5,ffffffffc0203b92 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203ba2:	02a68463          	beq	a3,a0,ffffffffc0203bca <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203ba6:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203baa:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203bae:	08e8f163          	bgeu	a7,a4,ffffffffc0203c30 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203bb2:	04e66f63          	bltu	a2,a4,ffffffffc0203c10 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0203bb6:	00f50a63          	beq	a0,a5,ffffffffc0203bca <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203bba:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203bbe:	05076963          	bltu	a4,a6,ffffffffc0203c10 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0203bc2:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203bc6:	02c77363          	bgeu	a4,a2,ffffffffc0203bec <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0203bca:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0203bcc:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0203bce:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0203bd2:	e390                	sd	a2,0(a5)
ffffffffc0203bd4:	e690                	sd	a2,8(a3)
}
ffffffffc0203bd6:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203bd8:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0203bda:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0203bdc:	0017079b          	addiw	a5,a4,1
ffffffffc0203be0:	d11c                	sw	a5,32(a0)
}
ffffffffc0203be2:	0141                	addi	sp,sp,16
ffffffffc0203be4:	8082                	ret
    if (le_prev != list)
ffffffffc0203be6:	fca690e3          	bne	a3,a0,ffffffffc0203ba6 <insert_vma_struct+0x26>
ffffffffc0203bea:	bfd1                	j	ffffffffc0203bbe <insert_vma_struct+0x3e>
ffffffffc0203bec:	f41ff0ef          	jal	ra,ffffffffc0203b2c <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203bf0:	00004697          	auipc	a3,0x4
ffffffffc0203bf4:	f3068693          	addi	a3,a3,-208 # ffffffffc0207b20 <default_pmm_manager+0x7b8>
ffffffffc0203bf8:	00003617          	auipc	a2,0x3
ffffffffc0203bfc:	3c060613          	addi	a2,a2,960 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203c00:	07a00593          	li	a1,122
ffffffffc0203c04:	00004517          	auipc	a0,0x4
ffffffffc0203c08:	f0c50513          	addi	a0,a0,-244 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc0203c0c:	86dfc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203c10:	00004697          	auipc	a3,0x4
ffffffffc0203c14:	f5068693          	addi	a3,a3,-176 # ffffffffc0207b60 <default_pmm_manager+0x7f8>
ffffffffc0203c18:	00003617          	auipc	a2,0x3
ffffffffc0203c1c:	3a060613          	addi	a2,a2,928 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203c20:	07300593          	li	a1,115
ffffffffc0203c24:	00004517          	auipc	a0,0x4
ffffffffc0203c28:	eec50513          	addi	a0,a0,-276 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc0203c2c:	84dfc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203c30:	00004697          	auipc	a3,0x4
ffffffffc0203c34:	f1068693          	addi	a3,a3,-240 # ffffffffc0207b40 <default_pmm_manager+0x7d8>
ffffffffc0203c38:	00003617          	auipc	a2,0x3
ffffffffc0203c3c:	38060613          	addi	a2,a2,896 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203c40:	07200593          	li	a1,114
ffffffffc0203c44:	00004517          	auipc	a0,0x4
ffffffffc0203c48:	ecc50513          	addi	a0,a0,-308 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc0203c4c:	82dfc0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0203c50 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0203c50:	591c                	lw	a5,48(a0)
{
ffffffffc0203c52:	1141                	addi	sp,sp,-16
ffffffffc0203c54:	e406                	sd	ra,8(sp)
ffffffffc0203c56:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203c58:	e78d                	bnez	a5,ffffffffc0203c82 <mm_destroy+0x32>
ffffffffc0203c5a:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0203c5c:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc0203c5e:	00a40c63          	beq	s0,a0,ffffffffc0203c76 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203c62:	6118                	ld	a4,0(a0)
ffffffffc0203c64:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203c66:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203c68:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203c6a:	e398                	sd	a4,0(a5)
ffffffffc0203c6c:	930fe0ef          	jal	ra,ffffffffc0201d9c <kfree>
    return listelm->next;
ffffffffc0203c70:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0203c72:	fea418e3          	bne	s0,a0,ffffffffc0203c62 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203c76:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203c78:	6402                	ld	s0,0(sp)
ffffffffc0203c7a:	60a2                	ld	ra,8(sp)
ffffffffc0203c7c:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0203c7e:	91efe06f          	j	ffffffffc0201d9c <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0203c82:	00004697          	auipc	a3,0x4
ffffffffc0203c86:	efe68693          	addi	a3,a3,-258 # ffffffffc0207b80 <default_pmm_manager+0x818>
ffffffffc0203c8a:	00003617          	auipc	a2,0x3
ffffffffc0203c8e:	32e60613          	addi	a2,a2,814 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203c92:	09e00593          	li	a1,158
ffffffffc0203c96:	00004517          	auipc	a0,0x4
ffffffffc0203c9a:	e7a50513          	addi	a0,a0,-390 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc0203c9e:	fdafc0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0203ca2 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc0203ca2:	7139                	addi	sp,sp,-64
ffffffffc0203ca4:	f04a                	sd	s2,32(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203ca6:	6905                	lui	s2,0x1
ffffffffc0203ca8:	197d                	addi	s2,s2,-1
ffffffffc0203caa:	77fd                	lui	a5,0xfffff
ffffffffc0203cac:	964a                	add	a2,a2,s2
ffffffffc0203cae:	962e                	add	a2,a2,a1
{
ffffffffc0203cb0:	f822                	sd	s0,48(sp)
ffffffffc0203cb2:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203cb4:	00f5f433          	and	s0,a1,a5
{
ffffffffc0203cb8:	f426                	sd	s1,40(sp)
ffffffffc0203cba:	ec4e                	sd	s3,24(sp)
ffffffffc0203cbc:	e852                	sd	s4,16(sp)
ffffffffc0203cbe:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203cc0:	002005b7          	lui	a1,0x200
ffffffffc0203cc4:	00f67933          	and	s2,a2,a5
ffffffffc0203cc8:	08b46563          	bltu	s0,a1,ffffffffc0203d52 <mm_map+0xb0>
ffffffffc0203ccc:	09247363          	bgeu	s0,s2,ffffffffc0203d52 <mm_map+0xb0>
ffffffffc0203cd0:	4785                	li	a5,1
ffffffffc0203cd2:	07fe                	slli	a5,a5,0x1f
ffffffffc0203cd4:	0727ef63          	bltu	a5,s2,ffffffffc0203d52 <mm_map+0xb0>
ffffffffc0203cd8:	84aa                	mv	s1,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203cda:	c159                	beqz	a0,ffffffffc0203d60 <mm_map+0xbe>
        vma = mm->mmap_cache;
ffffffffc0203cdc:	691c                	ld	a5,16(a0)
ffffffffc0203cde:	8ab6                	mv	s5,a3
ffffffffc0203ce0:	8a3a                	mv	s4,a4
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203ce2:	c781                	beqz	a5,ffffffffc0203cea <mm_map+0x48>
ffffffffc0203ce4:	6790                	ld	a2,8(a5)
ffffffffc0203ce6:	06c47063          	bgeu	s0,a2,ffffffffc0203d46 <mm_map+0xa4>
ffffffffc0203cea:	649c                	ld	a5,8(s1)
            while ((le = list_next(le)) != list)
ffffffffc0203cec:	00f48d63          	beq	s1,a5,ffffffffc0203d06 <mm_map+0x64>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0203cf0:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fcb8d98>
ffffffffc0203cf4:	00c46663          	bltu	s0,a2,ffffffffc0203d00 <mm_map+0x5e>
ffffffffc0203cf8:	ff07b583          	ld	a1,-16(a5)
ffffffffc0203cfc:	04b46d63          	bltu	s0,a1,ffffffffc0203d56 <mm_map+0xb4>
ffffffffc0203d00:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0203d02:	fef497e3          	bne	s1,a5,ffffffffc0203cf0 <mm_map+0x4e>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203d06:	03000513          	li	a0,48
ffffffffc0203d0a:	f89fd0ef          	jal	ra,ffffffffc0201c92 <kmalloc>
ffffffffc0203d0e:	89aa                	mv	s3,a0
    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0203d10:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203d12:	02098163          	beqz	s3,ffffffffc0203d34 <mm_map+0x92>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0203d16:	8526                	mv	a0,s1
        vma->vm_start = vm_start;
ffffffffc0203d18:	0089b423          	sd	s0,8(s3)
        vma->vm_end = vm_end;
ffffffffc0203d1c:	0129b823          	sd	s2,16(s3)
        vma->vm_flags = vm_flags;
ffffffffc0203d20:	0159ac23          	sw	s5,24(s3)
    insert_vma_struct(mm, vma);
ffffffffc0203d24:	85ce                	mv	a1,s3
ffffffffc0203d26:	e5bff0ef          	jal	ra,ffffffffc0203b80 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc0203d2a:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc0203d2c:	000a0463          	beqz	s4,ffffffffc0203d34 <mm_map+0x92>
        *vma_store = vma;
ffffffffc0203d30:	013a3023          	sd	s3,0(s4)

out:
    return ret;
}
ffffffffc0203d34:	70e2                	ld	ra,56(sp)
ffffffffc0203d36:	7442                	ld	s0,48(sp)
ffffffffc0203d38:	74a2                	ld	s1,40(sp)
ffffffffc0203d3a:	7902                	ld	s2,32(sp)
ffffffffc0203d3c:	69e2                	ld	s3,24(sp)
ffffffffc0203d3e:	6a42                	ld	s4,16(sp)
ffffffffc0203d40:	6aa2                	ld	s5,8(sp)
ffffffffc0203d42:	6121                	addi	sp,sp,64
ffffffffc0203d44:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203d46:	6b98                	ld	a4,16(a5)
ffffffffc0203d48:	fae471e3          	bgeu	s0,a4,ffffffffc0203cea <mm_map+0x48>
            mm->mmap_cache = vma;
ffffffffc0203d4c:	e89c                	sd	a5,16(s1)
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203d4e:	fb267ce3          	bgeu	a2,s2,ffffffffc0203d06 <mm_map+0x64>
        return -E_INVAL;
ffffffffc0203d52:	5575                	li	a0,-3
ffffffffc0203d54:	b7c5                	j	ffffffffc0203d34 <mm_map+0x92>
                vma = le2vma(le, list_link);
ffffffffc0203d56:	1781                	addi	a5,a5,-32
            mm->mmap_cache = vma;
ffffffffc0203d58:	e89c                	sd	a5,16(s1)
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203d5a:	fb2676e3          	bgeu	a2,s2,ffffffffc0203d06 <mm_map+0x64>
ffffffffc0203d5e:	bfd5                	j	ffffffffc0203d52 <mm_map+0xb0>
    assert(mm != NULL);
ffffffffc0203d60:	00004697          	auipc	a3,0x4
ffffffffc0203d64:	e3868693          	addi	a3,a3,-456 # ffffffffc0207b98 <default_pmm_manager+0x830>
ffffffffc0203d68:	00003617          	auipc	a2,0x3
ffffffffc0203d6c:	25060613          	addi	a2,a2,592 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203d70:	0b300593          	li	a1,179
ffffffffc0203d74:	00004517          	auipc	a0,0x4
ffffffffc0203d78:	d9c50513          	addi	a0,a0,-612 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc0203d7c:	efcfc0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0203d80 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0203d80:	7139                	addi	sp,sp,-64
ffffffffc0203d82:	fc06                	sd	ra,56(sp)
ffffffffc0203d84:	f822                	sd	s0,48(sp)
ffffffffc0203d86:	f426                	sd	s1,40(sp)
ffffffffc0203d88:	f04a                	sd	s2,32(sp)
ffffffffc0203d8a:	ec4e                	sd	s3,24(sp)
ffffffffc0203d8c:	e852                	sd	s4,16(sp)
ffffffffc0203d8e:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0203d90:	c52d                	beqz	a0,ffffffffc0203dfa <dup_mmap+0x7a>
ffffffffc0203d92:	892a                	mv	s2,a0
ffffffffc0203d94:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203d96:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203d98:	e595                	bnez	a1,ffffffffc0203dc4 <dup_mmap+0x44>
ffffffffc0203d9a:	a085                	j	ffffffffc0203dfa <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0203d9c:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0203d9e:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_matrix_out_size+0x1e9488>
        vma->vm_end = vm_end;
ffffffffc0203da2:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203da6:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0203daa:	dd7ff0ef          	jal	ra,ffffffffc0203b80 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203dae:	ff043683          	ld	a3,-16(s0)
ffffffffc0203db2:	fe843603          	ld	a2,-24(s0)
ffffffffc0203db6:	6c8c                	ld	a1,24(s1)
ffffffffc0203db8:	01893503          	ld	a0,24(s2) # 1018 <_binary_obj___user_faultread_out_size-0x10390>
ffffffffc0203dbc:	4701                	li	a4,0
ffffffffc0203dbe:	9c1ff0ef          	jal	ra,ffffffffc020377e <copy_range>
ffffffffc0203dc2:	e105                	bnez	a0,ffffffffc0203de2 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0203dc4:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203dc6:	02848863          	beq	s1,s0,ffffffffc0203df6 <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203dca:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203dce:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203dd2:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203dd6:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203dda:	eb9fd0ef          	jal	ra,ffffffffc0201c92 <kmalloc>
ffffffffc0203dde:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0203de0:	fd55                	bnez	a0,ffffffffc0203d9c <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203de2:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203de4:	70e2                	ld	ra,56(sp)
ffffffffc0203de6:	7442                	ld	s0,48(sp)
ffffffffc0203de8:	74a2                	ld	s1,40(sp)
ffffffffc0203dea:	7902                	ld	s2,32(sp)
ffffffffc0203dec:	69e2                	ld	s3,24(sp)
ffffffffc0203dee:	6a42                	ld	s4,16(sp)
ffffffffc0203df0:	6aa2                	ld	s5,8(sp)
ffffffffc0203df2:	6121                	addi	sp,sp,64
ffffffffc0203df4:	8082                	ret
    return 0;
ffffffffc0203df6:	4501                	li	a0,0
ffffffffc0203df8:	b7f5                	j	ffffffffc0203de4 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc0203dfa:	00004697          	auipc	a3,0x4
ffffffffc0203dfe:	dae68693          	addi	a3,a3,-594 # ffffffffc0207ba8 <default_pmm_manager+0x840>
ffffffffc0203e02:	00003617          	auipc	a2,0x3
ffffffffc0203e06:	1b660613          	addi	a2,a2,438 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203e0a:	0cf00593          	li	a1,207
ffffffffc0203e0e:	00004517          	auipc	a0,0x4
ffffffffc0203e12:	d0250513          	addi	a0,a0,-766 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc0203e16:	e62fc0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0203e1a <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203e1a:	1101                	addi	sp,sp,-32
ffffffffc0203e1c:	ec06                	sd	ra,24(sp)
ffffffffc0203e1e:	e822                	sd	s0,16(sp)
ffffffffc0203e20:	e426                	sd	s1,8(sp)
ffffffffc0203e22:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203e24:	c531                	beqz	a0,ffffffffc0203e70 <exit_mmap+0x56>
ffffffffc0203e26:	591c                	lw	a5,48(a0)
ffffffffc0203e28:	84aa                	mv	s1,a0
ffffffffc0203e2a:	e3b9                	bnez	a5,ffffffffc0203e70 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203e2c:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203e2e:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203e32:	02850663          	beq	a0,s0,ffffffffc0203e5e <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203e36:	ff043603          	ld	a2,-16(s0)
ffffffffc0203e3a:	fe843583          	ld	a1,-24(s0)
ffffffffc0203e3e:	854a                	mv	a0,s2
ffffffffc0203e40:	c12fe0ef          	jal	ra,ffffffffc0202252 <unmap_range>
ffffffffc0203e44:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203e46:	fe8498e3          	bne	s1,s0,ffffffffc0203e36 <exit_mmap+0x1c>
ffffffffc0203e4a:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203e4c:	00848c63          	beq	s1,s0,ffffffffc0203e64 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203e50:	ff043603          	ld	a2,-16(s0)
ffffffffc0203e54:	fe843583          	ld	a1,-24(s0)
ffffffffc0203e58:	854a                	mv	a0,s2
ffffffffc0203e5a:	dcafe0ef          	jal	ra,ffffffffc0202424 <exit_range>
ffffffffc0203e5e:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203e60:	fe8498e3          	bne	s1,s0,ffffffffc0203e50 <exit_mmap+0x36>
    }
}
ffffffffc0203e64:	60e2                	ld	ra,24(sp)
ffffffffc0203e66:	6442                	ld	s0,16(sp)
ffffffffc0203e68:	64a2                	ld	s1,8(sp)
ffffffffc0203e6a:	6902                	ld	s2,0(sp)
ffffffffc0203e6c:	6105                	addi	sp,sp,32
ffffffffc0203e6e:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203e70:	00004697          	auipc	a3,0x4
ffffffffc0203e74:	d5868693          	addi	a3,a3,-680 # ffffffffc0207bc8 <default_pmm_manager+0x860>
ffffffffc0203e78:	00003617          	auipc	a2,0x3
ffffffffc0203e7c:	14060613          	addi	a2,a2,320 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203e80:	0e800593          	li	a1,232
ffffffffc0203e84:	00004517          	auipc	a0,0x4
ffffffffc0203e88:	c8c50513          	addi	a0,a0,-884 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc0203e8c:	decfc0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0203e90 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203e90:	1101                	addi	sp,sp,-32
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203e92:	04000513          	li	a0,64
{
ffffffffc0203e96:	ec06                	sd	ra,24(sp)
ffffffffc0203e98:	e822                	sd	s0,16(sp)
ffffffffc0203e9a:	e426                	sd	s1,8(sp)
ffffffffc0203e9c:	e04a                	sd	s2,0(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203e9e:	df5fd0ef          	jal	ra,ffffffffc0201c92 <kmalloc>
    if (mm != NULL)
ffffffffc0203ea2:	3c050663          	beqz	a0,ffffffffc020426e <vmm_init+0x3de>
ffffffffc0203ea6:	842a                	mv	s0,a0
    elm->prev = elm->next = elm;
ffffffffc0203ea8:	e508                	sd	a0,8(a0)
ffffffffc0203eaa:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203eac:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203eb0:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203eb4:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203eb8:	02053423          	sd	zero,40(a0)
ffffffffc0203ebc:	02052823          	sw	zero,48(a0)
ffffffffc0203ec0:	02053c23          	sd	zero,56(a0)
ffffffffc0203ec4:	03200493          	li	s1,50
ffffffffc0203ec8:	a811                	j	ffffffffc0203edc <vmm_init+0x4c>
        vma->vm_start = vm_start;
ffffffffc0203eca:	e504                	sd	s1,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203ecc:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203ece:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203ed2:	14ed                	addi	s1,s1,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203ed4:	8522                	mv	a0,s0
ffffffffc0203ed6:	cabff0ef          	jal	ra,ffffffffc0203b80 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203eda:	c88d                	beqz	s1,ffffffffc0203f0c <vmm_init+0x7c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203edc:	03000513          	li	a0,48
ffffffffc0203ee0:	db3fd0ef          	jal	ra,ffffffffc0201c92 <kmalloc>
ffffffffc0203ee4:	85aa                	mv	a1,a0
ffffffffc0203ee6:	00248793          	addi	a5,s1,2
    if (vma != NULL)
ffffffffc0203eea:	f165                	bnez	a0,ffffffffc0203eca <vmm_init+0x3a>
        assert(vma != NULL);
ffffffffc0203eec:	00004697          	auipc	a3,0x4
ffffffffc0203ef0:	e7468693          	addi	a3,a3,-396 # ffffffffc0207d60 <default_pmm_manager+0x9f8>
ffffffffc0203ef4:	00003617          	auipc	a2,0x3
ffffffffc0203ef8:	0c460613          	addi	a2,a2,196 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203efc:	12c00593          	li	a1,300
ffffffffc0203f00:	00004517          	auipc	a0,0x4
ffffffffc0203f04:	c1050513          	addi	a0,a0,-1008 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc0203f08:	d70fc0ef          	jal	ra,ffffffffc0200478 <__panic>
ffffffffc0203f0c:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203f10:	1f900913          	li	s2,505
ffffffffc0203f14:	a819                	j	ffffffffc0203f2a <vmm_init+0x9a>
        vma->vm_start = vm_start;
ffffffffc0203f16:	e504                	sd	s1,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203f18:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203f1a:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203f1e:	0495                	addi	s1,s1,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203f20:	8522                	mv	a0,s0
ffffffffc0203f22:	c5fff0ef          	jal	ra,ffffffffc0203b80 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203f26:	03248a63          	beq	s1,s2,ffffffffc0203f5a <vmm_init+0xca>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203f2a:	03000513          	li	a0,48
ffffffffc0203f2e:	d65fd0ef          	jal	ra,ffffffffc0201c92 <kmalloc>
ffffffffc0203f32:	85aa                	mv	a1,a0
ffffffffc0203f34:	00248793          	addi	a5,s1,2
    if (vma != NULL)
ffffffffc0203f38:	fd79                	bnez	a0,ffffffffc0203f16 <vmm_init+0x86>
        assert(vma != NULL);
ffffffffc0203f3a:	00004697          	auipc	a3,0x4
ffffffffc0203f3e:	e2668693          	addi	a3,a3,-474 # ffffffffc0207d60 <default_pmm_manager+0x9f8>
ffffffffc0203f42:	00003617          	auipc	a2,0x3
ffffffffc0203f46:	07660613          	addi	a2,a2,118 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0203f4a:	13300593          	li	a1,307
ffffffffc0203f4e:	00004517          	auipc	a0,0x4
ffffffffc0203f52:	bc250513          	addi	a0,a0,-1086 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc0203f56:	d22fc0ef          	jal	ra,ffffffffc0200478 <__panic>
    return listelm->next;
ffffffffc0203f5a:	6408                	ld	a0,8(s0)
ffffffffc0203f5c:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203f5e:	1fb00593          	li	a1,507
ffffffffc0203f62:	87aa                	mv	a5,a0
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203f64:	2ef40563          	beq	s0,a5,ffffffffc020424e <vmm_init+0x3be>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203f68:	fe87b603          	ld	a2,-24(a5)
ffffffffc0203f6c:	ffe70693          	addi	a3,a4,-2 # fffffffffff7fffe <end+0x3fc39dae>
ffffffffc0203f70:	26d61f63          	bne	a2,a3,ffffffffc02041ee <vmm_init+0x35e>
ffffffffc0203f74:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203f78:	26e69b63          	bne	a3,a4,ffffffffc02041ee <vmm_init+0x35e>
    for (i = 1; i <= step2; i++)
ffffffffc0203f7c:	0715                	addi	a4,a4,5
ffffffffc0203f7e:	679c                	ld	a5,8(a5)
ffffffffc0203f80:	feb712e3          	bne	a4,a1,ffffffffc0203f64 <vmm_init+0xd4>
        vma = mm->mmap_cache;
ffffffffc0203f84:	681c                	ld	a5,16(s0)
ffffffffc0203f86:	4319                	li	t1,6
ffffffffc0203f88:	4e21                	li	t3,8
ffffffffc0203f8a:	4ea5                	li	t4,9
ffffffffc0203f8c:	4895                	li	a7,5
ffffffffc0203f8e:	461d                	li	a2,7
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203f90:	1fb00f13          	li	t5,507
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203f94:	10078163          	beqz	a5,ffffffffc0204096 <vmm_init+0x206>
ffffffffc0203f98:	6798                	ld	a4,8(a5)
ffffffffc0203f9a:	0ee8ee63          	bltu	a7,a4,ffffffffc0204096 <vmm_init+0x206>
ffffffffc0203f9e:	6b98                	ld	a4,16(a5)
ffffffffc0203fa0:	0ee8fb63          	bgeu	a7,a4,ffffffffc0204096 <vmm_init+0x206>
ffffffffc0203fa4:	873e                	mv	a4,a5
ffffffffc0203fa6:	00873803          	ld	a6,8(a4)
            mm->mmap_cache = vma;
ffffffffc0203faa:	e818                	sd	a4,16(s0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203fac:	0b036763          	bltu	t1,a6,ffffffffc020405a <vmm_init+0x1ca>
ffffffffc0203fb0:	6b1c                	ld	a5,16(a4)
ffffffffc0203fb2:	0af37463          	bgeu	t1,a5,ffffffffc020405a <vmm_init+0x1ca>
ffffffffc0203fb6:	87ba                	mv	a5,a4
ffffffffc0203fb8:	678c                	ld	a1,8(a5)
            mm->mmap_cache = vma;
ffffffffc0203fba:	e81c                	sd	a5,16(s0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203fbc:	00b66563          	bltu	a2,a1,ffffffffc0203fc6 <vmm_init+0x136>
ffffffffc0203fc0:	6b94                	ld	a3,16(a5)
ffffffffc0203fc2:	06d66b63          	bltu	a2,a3,ffffffffc0204038 <vmm_init+0x1a8>
            while ((le = list_next(le)) != list)
ffffffffc0203fc6:	00850e63          	beq	a0,s0,ffffffffc0203fe2 <vmm_init+0x152>
ffffffffc0203fca:	86aa                	mv	a3,a0
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0203fcc:	fe86bf83          	ld	t6,-24(a3)
ffffffffc0203fd0:	01f66663          	bltu	a2,t6,ffffffffc0203fdc <vmm_init+0x14c>
ffffffffc0203fd4:	ff06bf83          	ld	t6,-16(a3)
ffffffffc0203fd8:	05f66e63          	bltu	a2,t6,ffffffffc0204034 <vmm_init+0x1a4>
ffffffffc0203fdc:	6694                	ld	a3,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0203fde:	fed417e3          	bne	s0,a3,ffffffffc0203fcc <vmm_init+0x13c>
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203fe2:	00be6563          	bltu	t3,a1,ffffffffc0203fec <vmm_init+0x15c>
ffffffffc0203fe6:	6b94                	ld	a3,16(a5)
ffffffffc0203fe8:	18de6f63          	bltu	t3,a3,ffffffffc0204186 <vmm_init+0x2f6>
            while ((le = list_next(le)) != list)
ffffffffc0203fec:	86aa                	mv	a3,a0
ffffffffc0203fee:	1e850d63          	beq	a0,s0,ffffffffc02041e8 <vmm_init+0x358>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0203ff2:	fe86bf83          	ld	t6,-24(a3)
ffffffffc0203ff6:	01fe6663          	bltu	t3,t6,ffffffffc0204002 <vmm_init+0x172>
ffffffffc0203ffa:	ff06bf83          	ld	t6,-16(a3)
ffffffffc0203ffe:	19fe6263          	bltu	t3,t6,ffffffffc0204182 <vmm_init+0x2f2>
ffffffffc0204002:	6694                	ld	a3,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0204004:	fed417e3          	bne	s0,a3,ffffffffc0203ff2 <vmm_init+0x162>
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0204008:	0cbee563          	bltu	t4,a1,ffffffffc02040d2 <vmm_init+0x242>
ffffffffc020400c:	6b94                	ld	a3,16(a5)
ffffffffc020400e:	0cdef263          	bgeu	t4,a3,ffffffffc02040d2 <vmm_init+0x242>
            mm->mmap_cache = vma;
ffffffffc0204012:	e81c                	sd	a5,16(s0)
        struct vma_struct *vma3 = find_vma(mm, i + 2);
        assert(vma3 == NULL);
        struct vma_struct *vma4 = find_vma(mm, i + 3);
        assert(vma4 == NULL);
        struct vma_struct *vma5 = find_vma(mm, i + 4);
        assert(vma5 == NULL);
ffffffffc0204014:	00004697          	auipc	a3,0x4
ffffffffc0204018:	c6468693          	addi	a3,a3,-924 # ffffffffc0207c78 <default_pmm_manager+0x910>
ffffffffc020401c:	00003617          	auipc	a2,0x3
ffffffffc0204020:	f9c60613          	addi	a2,a2,-100 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0204024:	14c00593          	li	a1,332
ffffffffc0204028:	00004517          	auipc	a0,0x4
ffffffffc020402c:	ae850513          	addi	a0,a0,-1304 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc0204030:	c48fc0ef          	jal	ra,ffffffffc0200478 <__panic>
                vma = le2vma(le, list_link);
ffffffffc0204034:	fe068793          	addi	a5,a3,-32
            mm->mmap_cache = vma;
ffffffffc0204038:	e81c                	sd	a5,16(s0)
        assert(vma3 == NULL);
ffffffffc020403a:	00004697          	auipc	a3,0x4
ffffffffc020403e:	c1e68693          	addi	a3,a3,-994 # ffffffffc0207c58 <default_pmm_manager+0x8f0>
ffffffffc0204042:	00003617          	auipc	a2,0x3
ffffffffc0204046:	f7660613          	addi	a2,a2,-138 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020404a:	14800593          	li	a1,328
ffffffffc020404e:	00004517          	auipc	a0,0x4
ffffffffc0204052:	ac250513          	addi	a0,a0,-1342 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc0204056:	c22fc0ef          	jal	ra,ffffffffc0200478 <__panic>
            while ((le = list_next(le)) != list)
ffffffffc020405a:	00850e63          	beq	a0,s0,ffffffffc0204076 <vmm_init+0x1e6>
ffffffffc020405e:	87aa                	mv	a5,a0
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0204060:	fe87b683          	ld	a3,-24(a5)
ffffffffc0204064:	00d36663          	bltu	t1,a3,ffffffffc0204070 <vmm_init+0x1e0>
ffffffffc0204068:	ff07b683          	ld	a3,-16(a5)
ffffffffc020406c:	14d36163          	bltu	t1,a3,ffffffffc02041ae <vmm_init+0x31e>
ffffffffc0204070:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0204072:	fef417e3          	bne	s0,a5,ffffffffc0204060 <vmm_init+0x1d0>
        assert(vma2 != NULL);
ffffffffc0204076:	00004697          	auipc	a3,0x4
ffffffffc020407a:	bd268693          	addi	a3,a3,-1070 # ffffffffc0207c48 <default_pmm_manager+0x8e0>
ffffffffc020407e:	00003617          	auipc	a2,0x3
ffffffffc0204082:	f3a60613          	addi	a2,a2,-198 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0204086:	14600593          	li	a1,326
ffffffffc020408a:	00004517          	auipc	a0,0x4
ffffffffc020408e:	a8650513          	addi	a0,a0,-1402 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc0204092:	be6fc0ef          	jal	ra,ffffffffc0200478 <__panic>
            while ((le = list_next(le)) != list)
ffffffffc0204096:	00850e63          	beq	a0,s0,ffffffffc02040b2 <vmm_init+0x222>
ffffffffc020409a:	87aa                	mv	a5,a0
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc020409c:	fe87b703          	ld	a4,-24(a5)
ffffffffc02040a0:	00e8e663          	bltu	a7,a4,ffffffffc02040ac <vmm_init+0x21c>
ffffffffc02040a4:	ff07b703          	ld	a4,-16(a5)
ffffffffc02040a8:	10e8e063          	bltu	a7,a4,ffffffffc02041a8 <vmm_init+0x318>
ffffffffc02040ac:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc02040ae:	fef417e3          	bne	s0,a5,ffffffffc020409c <vmm_init+0x20c>
        assert(vma1 != NULL);
ffffffffc02040b2:	00004697          	auipc	a3,0x4
ffffffffc02040b6:	b8668693          	addi	a3,a3,-1146 # ffffffffc0207c38 <default_pmm_manager+0x8d0>
ffffffffc02040ba:	00003617          	auipc	a2,0x3
ffffffffc02040be:	efe60613          	addi	a2,a2,-258 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02040c2:	14400593          	li	a1,324
ffffffffc02040c6:	00004517          	auipc	a0,0x4
ffffffffc02040ca:	a4a50513          	addi	a0,a0,-1462 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc02040ce:	baafc0ef          	jal	ra,ffffffffc0200478 <__panic>
            while ((le = list_next(le)) != list)
ffffffffc02040d2:	00850e63          	beq	a0,s0,ffffffffc02040ee <vmm_init+0x25e>
ffffffffc02040d6:	86aa                	mv	a3,a0
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc02040d8:	fe86bf83          	ld	t6,-24(a3)
ffffffffc02040dc:	01fee663          	bltu	t4,t6,ffffffffc02040e8 <vmm_init+0x258>
ffffffffc02040e0:	ff06bf83          	ld	t6,-16(a3)
ffffffffc02040e4:	0dfee763          	bltu	t4,t6,ffffffffc02041b2 <vmm_init+0x322>
ffffffffc02040e8:	6694                	ld	a3,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc02040ea:	fed417e3          	bne	s0,a3,ffffffffc02040d8 <vmm_init+0x248>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc02040ee:	13181063          	bne	a6,a7,ffffffffc020420e <vmm_init+0x37e>
ffffffffc02040f2:	6b18                	ld	a4,16(a4)
ffffffffc02040f4:	10c71d63          	bne	a4,a2,ffffffffc020420e <vmm_init+0x37e>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc02040f8:	13059b63          	bne	a1,a6,ffffffffc020422e <vmm_init+0x39e>
ffffffffc02040fc:	6b98                	ld	a4,16(a5)
ffffffffc02040fe:	12c71863          	bne	a4,a2,ffffffffc020422e <vmm_init+0x39e>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0204102:	0615                	addi	a2,a2,5
ffffffffc0204104:	00558893          	addi	a7,a1,5
ffffffffc0204108:	0e95                	addi	t4,t4,5
ffffffffc020410a:	0e15                	addi	t3,t3,5
ffffffffc020410c:	0315                	addi	t1,t1,5
ffffffffc020410e:	e9e613e3          	bne	a2,t5,ffffffffc0203f94 <vmm_init+0x104>
ffffffffc0204112:	4711                	li	a4,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0204114:	587d                	li	a6,-1
ffffffffc0204116:	0007059b          	sext.w	a1,a4
            while ((le = list_next(le)) != list)
ffffffffc020411a:	00850e63          	beq	a0,s0,ffffffffc0204136 <vmm_init+0x2a6>
ffffffffc020411e:	87aa                	mv	a5,a0
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0204120:	fe87b603          	ld	a2,-24(a5)
ffffffffc0204124:	00c76663          	bltu	a4,a2,ffffffffc0204130 <vmm_init+0x2a0>
ffffffffc0204128:	ff07b683          	ld	a3,-16(a5)
ffffffffc020412c:	08d76663          	bltu	a4,a3,ffffffffc02041b8 <vmm_init+0x328>
ffffffffc0204130:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0204132:	fef417e3          	bne	s0,a5,ffffffffc0204120 <vmm_init+0x290>
    for (i = 4; i >= 0; i--)
ffffffffc0204136:	177d                	addi	a4,a4,-1
ffffffffc0204138:	fd071fe3          	bne	a4,a6,ffffffffc0204116 <vmm_init+0x286>
    assert(mm_count(mm) == 0);
ffffffffc020413c:	581c                	lw	a5,48(s0)
ffffffffc020413e:	14079863          	bnez	a5,ffffffffc020428e <vmm_init+0x3fe>
    while ((le = list_next(list)) != list)
ffffffffc0204142:	00a40c63          	beq	s0,a0,ffffffffc020415a <vmm_init+0x2ca>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204146:	6118                	ld	a4,0(a0)
ffffffffc0204148:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc020414a:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc020414c:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020414e:	e398                	sd	a4,0(a5)
ffffffffc0204150:	c4dfd0ef          	jal	ra,ffffffffc0201d9c <kfree>
    return listelm->next;
ffffffffc0204154:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0204156:	fea418e3          	bne	s0,a0,ffffffffc0204146 <vmm_init+0x2b6>
    kfree(mm); // kfree mm
ffffffffc020415a:	8522                	mv	a0,s0
ffffffffc020415c:	c41fd0ef          	jal	ra,ffffffffc0201d9c <kfree>
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0204160:	00004517          	auipc	a0,0x4
ffffffffc0204164:	bc850513          	addi	a0,a0,-1080 # ffffffffc0207d28 <default_pmm_manager+0x9c0>
ffffffffc0204168:	830fc0ef          	jal	ra,ffffffffc0200198 <cprintf>
}
ffffffffc020416c:	6442                	ld	s0,16(sp)
ffffffffc020416e:	60e2                	ld	ra,24(sp)
ffffffffc0204170:	64a2                	ld	s1,8(sp)
ffffffffc0204172:	6902                	ld	s2,0(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0204174:	00004517          	auipc	a0,0x4
ffffffffc0204178:	bd450513          	addi	a0,a0,-1068 # ffffffffc0207d48 <default_pmm_manager+0x9e0>
}
ffffffffc020417c:	6105                	addi	sp,sp,32
    cprintf("check_vmm() succeeded.\n");
ffffffffc020417e:	81afc06f          	j	ffffffffc0200198 <cprintf>
                vma = le2vma(le, list_link);
ffffffffc0204182:	fe068793          	addi	a5,a3,-32
            mm->mmap_cache = vma;
ffffffffc0204186:	e81c                	sd	a5,16(s0)
        assert(vma4 == NULL);
ffffffffc0204188:	00004697          	auipc	a3,0x4
ffffffffc020418c:	ae068693          	addi	a3,a3,-1312 # ffffffffc0207c68 <default_pmm_manager+0x900>
ffffffffc0204190:	00003617          	auipc	a2,0x3
ffffffffc0204194:	e2860613          	addi	a2,a2,-472 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0204198:	14a00593          	li	a1,330
ffffffffc020419c:	00004517          	auipc	a0,0x4
ffffffffc02041a0:	97450513          	addi	a0,a0,-1676 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc02041a4:	ad4fc0ef          	jal	ra,ffffffffc0200478 <__panic>
                vma = le2vma(le, list_link);
ffffffffc02041a8:	fe078713          	addi	a4,a5,-32
ffffffffc02041ac:	bbed                	j	ffffffffc0203fa6 <vmm_init+0x116>
ffffffffc02041ae:	1781                	addi	a5,a5,-32
ffffffffc02041b0:	b521                	j	ffffffffc0203fb8 <vmm_init+0x128>
ffffffffc02041b2:	fe068793          	addi	a5,a3,-32
ffffffffc02041b6:	bdb1                	j	ffffffffc0204012 <vmm_init+0x182>
ffffffffc02041b8:	1781                	addi	a5,a5,-32
            mm->mmap_cache = vma;
ffffffffc02041ba:	e81c                	sd	a5,16(s0)
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc02041bc:	00004517          	auipc	a0,0x4
ffffffffc02041c0:	b2c50513          	addi	a0,a0,-1236 # ffffffffc0207ce8 <default_pmm_manager+0x980>
ffffffffc02041c4:	fd5fb0ef          	jal	ra,ffffffffc0200198 <cprintf>
        assert(vma_below_5 == NULL);
ffffffffc02041c8:	00004697          	auipc	a3,0x4
ffffffffc02041cc:	b4868693          	addi	a3,a3,-1208 # ffffffffc0207d10 <default_pmm_manager+0x9a8>
ffffffffc02041d0:	00003617          	auipc	a2,0x3
ffffffffc02041d4:	de860613          	addi	a2,a2,-536 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02041d8:	15900593          	li	a1,345
ffffffffc02041dc:	00004517          	auipc	a0,0x4
ffffffffc02041e0:	93450513          	addi	a0,a0,-1740 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc02041e4:	a94fc0ef          	jal	ra,ffffffffc0200478 <__panic>
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02041e8:	e2bef2e3          	bgeu	t4,a1,ffffffffc020400c <vmm_init+0x17c>
ffffffffc02041ec:	b709                	j	ffffffffc02040ee <vmm_init+0x25e>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc02041ee:	00004697          	auipc	a3,0x4
ffffffffc02041f2:	a1268693          	addi	a3,a3,-1518 # ffffffffc0207c00 <default_pmm_manager+0x898>
ffffffffc02041f6:	00003617          	auipc	a2,0x3
ffffffffc02041fa:	dc260613          	addi	a2,a2,-574 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02041fe:	13d00593          	li	a1,317
ffffffffc0204202:	00004517          	auipc	a0,0x4
ffffffffc0204206:	90e50513          	addi	a0,a0,-1778 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc020420a:	a6efc0ef          	jal	ra,ffffffffc0200478 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc020420e:	00004697          	auipc	a3,0x4
ffffffffc0204212:	a7a68693          	addi	a3,a3,-1414 # ffffffffc0207c88 <default_pmm_manager+0x920>
ffffffffc0204216:	00003617          	auipc	a2,0x3
ffffffffc020421a:	da260613          	addi	a2,a2,-606 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020421e:	14e00593          	li	a1,334
ffffffffc0204222:	00004517          	auipc	a0,0x4
ffffffffc0204226:	8ee50513          	addi	a0,a0,-1810 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc020422a:	a4efc0ef          	jal	ra,ffffffffc0200478 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc020422e:	00004697          	auipc	a3,0x4
ffffffffc0204232:	a8a68693          	addi	a3,a3,-1398 # ffffffffc0207cb8 <default_pmm_manager+0x950>
ffffffffc0204236:	00003617          	auipc	a2,0x3
ffffffffc020423a:	d8260613          	addi	a2,a2,-638 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020423e:	14f00593          	li	a1,335
ffffffffc0204242:	00004517          	auipc	a0,0x4
ffffffffc0204246:	8ce50513          	addi	a0,a0,-1842 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc020424a:	a2efc0ef          	jal	ra,ffffffffc0200478 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc020424e:	00004697          	auipc	a3,0x4
ffffffffc0204252:	99a68693          	addi	a3,a3,-1638 # ffffffffc0207be8 <default_pmm_manager+0x880>
ffffffffc0204256:	00003617          	auipc	a2,0x3
ffffffffc020425a:	d6260613          	addi	a2,a2,-670 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020425e:	13b00593          	li	a1,315
ffffffffc0204262:	00004517          	auipc	a0,0x4
ffffffffc0204266:	8ae50513          	addi	a0,a0,-1874 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc020426a:	a0efc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(mm != NULL);
ffffffffc020426e:	00004697          	auipc	a3,0x4
ffffffffc0204272:	92a68693          	addi	a3,a3,-1750 # ffffffffc0207b98 <default_pmm_manager+0x830>
ffffffffc0204276:	00003617          	auipc	a2,0x3
ffffffffc020427a:	d4260613          	addi	a2,a2,-702 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020427e:	12400593          	li	a1,292
ffffffffc0204282:	00004517          	auipc	a0,0x4
ffffffffc0204286:	88e50513          	addi	a0,a0,-1906 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc020428a:	9eefc0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(mm_count(mm) == 0);
ffffffffc020428e:	00004697          	auipc	a3,0x4
ffffffffc0204292:	8f268693          	addi	a3,a3,-1806 # ffffffffc0207b80 <default_pmm_manager+0x818>
ffffffffc0204296:	00003617          	auipc	a2,0x3
ffffffffc020429a:	d2260613          	addi	a2,a2,-734 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020429e:	09e00593          	li	a1,158
ffffffffc02042a2:	00004517          	auipc	a0,0x4
ffffffffc02042a6:	86e50513          	addi	a0,a0,-1938 # ffffffffc0207b10 <default_pmm_manager+0x7a8>
ffffffffc02042aa:	9cefc0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc02042ae <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
    if (mm != NULL)
ffffffffc02042ae:	c93d                	beqz	a0,ffffffffc0204324 <user_mem_check+0x76>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc02042b0:	002007b7          	lui	a5,0x200
ffffffffc02042b4:	04f5e163          	bltu	a1,a5,ffffffffc02042f6 <user_mem_check+0x48>
ffffffffc02042b8:	00c58833          	add	a6,a1,a2
ffffffffc02042bc:	0305fd63          	bgeu	a1,a6,ffffffffc02042f6 <user_mem_check+0x48>
ffffffffc02042c0:	4785                	li	a5,1
ffffffffc02042c2:	07fe                	slli	a5,a5,0x1f
ffffffffc02042c4:	0307e963          	bltu	a5,a6,ffffffffc02042f6 <user_mem_check+0x48>
        vma = mm->mmap_cache;
ffffffffc02042c8:	691c                	ld	a5,16(a0)
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc02042ca:	6305                	lui	t1,0x1
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02042cc:	c799                	beqz	a5,ffffffffc02042da <user_mem_check+0x2c>
ffffffffc02042ce:	6798                	ld	a4,8(a5)
ffffffffc02042d0:	00e5e563          	bltu	a1,a4,ffffffffc02042da <user_mem_check+0x2c>
ffffffffc02042d4:	6b90                	ld	a2,16(a5)
ffffffffc02042d6:	02c5e463          	bltu	a1,a2,ffffffffc02042fe <user_mem_check+0x50>
ffffffffc02042da:	651c                	ld	a5,8(a0)
            while ((le = list_next(le)) != list)
ffffffffc02042dc:	00f50d63          	beq	a0,a5,ffffffffc02042f6 <user_mem_check+0x48>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc02042e0:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_obj___user_matrix_out_size+0x1e9468>
ffffffffc02042e4:	00e5e663          	bltu	a1,a4,ffffffffc02042f0 <user_mem_check+0x42>
ffffffffc02042e8:	ff07b603          	ld	a2,-16(a5)
ffffffffc02042ec:	00c5e763          	bltu	a1,a2,ffffffffc02042fa <user_mem_check+0x4c>
ffffffffc02042f0:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc02042f2:	fef517e3          	bne	a0,a5,ffffffffc02042e0 <user_mem_check+0x32>
            return 0;
ffffffffc02042f6:	4501                	li	a0,0
ffffffffc02042f8:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc02042fa:	1781                	addi	a5,a5,-32
            mm->mmap_cache = vma;
ffffffffc02042fc:	e91c                	sd	a5,16(a0)
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc02042fe:	4f90                	lw	a2,24(a5)
ffffffffc0204300:	ce99                	beqz	a3,ffffffffc020431e <user_mem_check+0x70>
ffffffffc0204302:	00267893          	andi	a7,a2,2
ffffffffc0204306:	fe0888e3          	beqz	a7,ffffffffc02042f6 <user_mem_check+0x48>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc020430a:	8a21                	andi	a2,a2,8
ffffffffc020430c:	c601                	beqz	a2,ffffffffc0204314 <user_mem_check+0x66>
                if (start < vma->vm_start + PGSIZE)
ffffffffc020430e:	971a                	add	a4,a4,t1
ffffffffc0204310:	fee5e3e3          	bltu	a1,a4,ffffffffc02042f6 <user_mem_check+0x48>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0204314:	6b8c                	ld	a1,16(a5)
        while (start < end)
ffffffffc0204316:	fb05ebe3          	bltu	a1,a6,ffffffffc02042cc <user_mem_check+0x1e>
        }
        return 1;
ffffffffc020431a:	4505                	li	a0,1
ffffffffc020431c:	8082                	ret
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc020431e:	8a05                	andi	a2,a2,1
ffffffffc0204320:	fa75                	bnez	a2,ffffffffc0204314 <user_mem_check+0x66>
ffffffffc0204322:	bfd1                	j	ffffffffc02042f6 <user_mem_check+0x48>
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0204324:	c02007b7          	lui	a5,0xc0200
ffffffffc0204328:	4501                	li	a0,0
ffffffffc020432a:	00f5eb63          	bltu	a1,a5,ffffffffc0204340 <user_mem_check+0x92>
ffffffffc020432e:	962e                	add	a2,a2,a1
ffffffffc0204330:	00c5f863          	bgeu	a1,a2,ffffffffc0204340 <user_mem_check+0x92>
ffffffffc0204334:	c8000537          	lui	a0,0xc8000
ffffffffc0204338:	0505                	addi	a0,a0,1
ffffffffc020433a:	00a63533          	sltu	a0,a2,a0
ffffffffc020433e:	8082                	ret
}
ffffffffc0204340:	8082                	ret

ffffffffc0204342 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0204342:	8526                	mv	a0,s1
	jalr s0
ffffffffc0204344:	9402                	jalr	s0

	jal do_exit
ffffffffc0204346:	5e8000ef          	jal	ra,ffffffffc020492e <do_exit>

ffffffffc020434a <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc020434a:	7179                	addi	sp,sp,-48
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc020434c:	14800513          	li	a0,328
{
ffffffffc0204350:	f022                	sd	s0,32(sp)
ffffffffc0204352:	f406                	sd	ra,40(sp)
ffffffffc0204354:	ec26                	sd	s1,24(sp)
ffffffffc0204356:	e84a                	sd	s2,16(sp)
ffffffffc0204358:	e44e                	sd	s3,8(sp)
ffffffffc020435a:	e052                	sd	s4,0(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc020435c:	937fd0ef          	jal	ra,ffffffffc0201c92 <kmalloc>
ffffffffc0204360:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0204362:	c969                	beqz	a0,ffffffffc0204434 <alloc_proc+0xea>
         *       struct trapframe *tf;                       // Trap frame for current interrupt
         *       uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         */
         proc->state = PROC_UNINIT;  // 进程状态为未初始化
ffffffffc0204364:	59fd                	li	s3,-1
ffffffffc0204366:	1982                	slli	s3,s3,0x20
         proc->runs = 0;             // 运行次数初始化为0
         proc->kstack = 0;           // 内核栈地址初始化为0
         proc->need_resched = 0;     // 不需要调度
         proc->parent = NULL;        // 父进程指针为空
         proc->mm = NULL;            // 内存管理结构为空
         memset(&(proc->context), 0, sizeof(struct context)); // 上下文清零
ffffffffc0204368:	03050913          	addi	s2,a0,48 # ffffffffc8000030 <end+0x7cb9de0>
ffffffffc020436c:	07000613          	li	a2,112
ffffffffc0204370:	4581                	li	a1,0
         proc->state = PROC_UNINIT;  // 进程状态为未初始化
ffffffffc0204372:	01353023          	sd	s3,0(a0)
         proc->runs = 0;             // 运行次数初始化为0
ffffffffc0204376:	00052423          	sw	zero,8(a0)
         proc->kstack = 0;           // 内核栈地址初始化为0
ffffffffc020437a:	00053823          	sd	zero,16(a0)
         proc->need_resched = 0;     // 不需要调度
ffffffffc020437e:	00053c23          	sd	zero,24(a0)
         proc->parent = NULL;        // 父进程指针为空
ffffffffc0204382:	02053023          	sd	zero,32(a0)
         proc->mm = NULL;            // 内存管理结构为空
ffffffffc0204386:	02053423          	sd	zero,40(a0)
         memset(&(proc->context), 0, sizeof(struct context)); // 上下文清零
ffffffffc020438a:	854a                	mv	a0,s2
ffffffffc020438c:	721010ef          	jal	ra,ffffffffc02062ac <memset>
         proc->tf = NULL;            // 陷阱帧指针为空
         proc->pgdir = boot_pgdir_pa;            // 页目录基址为boot_pgdir_pa
ffffffffc0204390:	00142a17          	auipc	s4,0x142
ffffffffc0204394:	e60a0a13          	addi	s4,s4,-416 # ffffffffc03461f0 <boot_pgdir_pa>
ffffffffc0204398:	000a3783          	ld	a5,0(s4)
         proc->flags = 0;            // 进程标志为0
         memset(proc->name, 0, PROC_NAME_LEN); // 进程名清零
ffffffffc020439c:	0b440493          	addi	s1,s0,180
ffffffffc02043a0:	463d                	li	a2,15
         proc->pgdir = boot_pgdir_pa;            // 页目录基址为boot_pgdir_pa
ffffffffc02043a2:	f45c                	sd	a5,168(s0)
         memset(proc->name, 0, PROC_NAME_LEN); // 进程名清零
ffffffffc02043a4:	4581                	li	a1,0
         proc->tf = NULL;            // 陷阱帧指针为空
ffffffffc02043a6:	0a043023          	sd	zero,160(s0)
         proc->flags = 0;            // 进程标志为0
ffffffffc02043aa:	0a042823          	sw	zero,176(s0)
         memset(proc->name, 0, PROC_NAME_LEN); // 进程名清零
ffffffffc02043ae:	8526                	mv	a0,s1
ffffffffc02043b0:	6fd010ef          	jal	ra,ffffffffc02062ac <memset>
         proc->runs = 0;
         proc->kstack = 0;
         proc->need_resched = 0;
         proc->parent = NULL;
         proc->mm = NULL;
         memset(&(proc->context), 0, sizeof(struct context));
ffffffffc02043b4:	07000613          	li	a2,112
ffffffffc02043b8:	4581                	li	a1,0
         proc->wait_state = 0;        // 等待状态初始化为0
ffffffffc02043ba:	0e042623          	sw	zero,236(s0)
         proc->cptr = NULL;           // 子进程指针为空
ffffffffc02043be:	0e043823          	sd	zero,240(s0)
         proc->yptr = NULL;           // 弟弟进程指针为空
ffffffffc02043c2:	0e043c23          	sd	zero,248(s0)
         proc->optr = NULL;           // 哥哥进程指针为空
ffffffffc02043c6:	10043023          	sd	zero,256(s0)
         proc->state = PROC_UNINIT;
ffffffffc02043ca:	01343023          	sd	s3,0(s0)
         proc->runs = 0;
ffffffffc02043ce:	00042423          	sw	zero,8(s0)
         proc->kstack = 0;
ffffffffc02043d2:	00043823          	sd	zero,16(s0)
         proc->need_resched = 0;
ffffffffc02043d6:	00043c23          	sd	zero,24(s0)
         proc->parent = NULL;
ffffffffc02043da:	02043023          	sd	zero,32(s0)
         proc->mm = NULL;
ffffffffc02043de:	02043423          	sd	zero,40(s0)
         memset(&(proc->context), 0, sizeof(struct context));
ffffffffc02043e2:	854a                	mv	a0,s2
ffffffffc02043e4:	6c9010ef          	jal	ra,ffffffffc02062ac <memset>
         proc->tf = NULL;
         proc->pgdir = boot_pgdir_pa;
ffffffffc02043e8:	000a3783          	ld	a5,0(s4)
         proc->tf = NULL;
ffffffffc02043ec:	0a043023          	sd	zero,160(s0)
         proc->flags = 0;
ffffffffc02043f0:	0a042823          	sw	zero,176(s0)
         proc->pgdir = boot_pgdir_pa;
ffffffffc02043f4:	f45c                	sd	a5,168(s0)
         memset(proc->name, 0, PROC_NAME_LEN);
ffffffffc02043f6:	463d                	li	a2,15
ffffffffc02043f8:	4581                	li	a1,0
ffffffffc02043fa:	8526                	mv	a0,s1
ffffffffc02043fc:	6b1010ef          	jal	ra,ffffffffc02062ac <memset>
         // lab5 add:
         proc->wait_state = 0;
         proc->cptr = proc->optr = proc->yptr = NULL;
         proc->rq = NULL;                    // 运行队列指针为空
         list_init(&(proc->run_link));       // 初始化运行队列链表节点
ffffffffc0204400:	11040793          	addi	a5,s0,272
         proc->wait_state = 0;
ffffffffc0204404:	0e042623          	sw	zero,236(s0)
         proc->cptr = proc->optr = proc->yptr = NULL;
ffffffffc0204408:	0e043c23          	sd	zero,248(s0)
ffffffffc020440c:	10043023          	sd	zero,256(s0)
ffffffffc0204410:	0e043823          	sd	zero,240(s0)
         proc->rq = NULL;                    // 运行队列指针为空
ffffffffc0204414:	10043423          	sd	zero,264(s0)
    elm->prev = elm->next = elm;
ffffffffc0204418:	10f43c23          	sd	a5,280(s0)
ffffffffc020441c:	10f43823          	sd	a5,272(s0)
         proc->time_slice = 0;                // 时间片初始化为0
ffffffffc0204420:	12042023          	sw	zero,288(s0)
     compare_f comp) __attribute__((always_inline));

static inline void
skew_heap_init(skew_heap_entry_t *a)
{
     a->left = a->right = a->parent = NULL;
ffffffffc0204424:	12043423          	sd	zero,296(s0)
ffffffffc0204428:	12043823          	sd	zero,304(s0)
ffffffffc020442c:	12043c23          	sd	zero,312(s0)
         skew_heap_init(&(proc->lab6_run_pool)); // 初始化斜堆节点（用于stride调度）
         proc->lab6_stride = 0;               // stride值初始化为0
ffffffffc0204430:	14043023          	sd	zero,320(s0)
         proc->lab6_priority = 0;              // 优先级初始化为0
    }
    return proc;
}
ffffffffc0204434:	70a2                	ld	ra,40(sp)
ffffffffc0204436:	8522                	mv	a0,s0
ffffffffc0204438:	7402                	ld	s0,32(sp)
ffffffffc020443a:	64e2                	ld	s1,24(sp)
ffffffffc020443c:	6942                	ld	s2,16(sp)
ffffffffc020443e:	69a2                	ld	s3,8(sp)
ffffffffc0204440:	6a02                	ld	s4,0(sp)
ffffffffc0204442:	6145                	addi	sp,sp,48
ffffffffc0204444:	8082                	ret

ffffffffc0204446 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0204446:	00142797          	auipc	a5,0x142
ffffffffc020444a:	dda7b783          	ld	a5,-550(a5) # ffffffffc0346220 <current>
ffffffffc020444e:	73c8                	ld	a0,160(a5)
ffffffffc0204450:	b5ffc06f          	j	ffffffffc0200fae <forkrets>

ffffffffc0204454 <proc_run>:
{
ffffffffc0204454:	7179                	addi	sp,sp,-48
ffffffffc0204456:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0204458:	00142917          	auipc	s2,0x142
ffffffffc020445c:	dc890913          	addi	s2,s2,-568 # ffffffffc0346220 <current>
{
ffffffffc0204460:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0204462:	00093483          	ld	s1,0(s2)
{
ffffffffc0204466:	f406                	sd	ra,40(sp)
ffffffffc0204468:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc020446a:	02a48863          	beq	s1,a0,ffffffffc020449a <proc_run+0x46>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020446e:	100027f3          	csrr	a5,sstatus
ffffffffc0204472:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204474:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204476:	ef9d                	bnez	a5,ffffffffc02044b4 <proc_run+0x60>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0204478:	755c                	ld	a5,168(a0)
ffffffffc020447a:	577d                	li	a4,-1
ffffffffc020447c:	177e                	slli	a4,a4,0x3f
ffffffffc020447e:	83b1                	srli	a5,a5,0xc
             current = proc;
ffffffffc0204480:	00a93023          	sd	a0,0(s2)
ffffffffc0204484:	8fd9                	or	a5,a5,a4
ffffffffc0204486:	18079073          	csrw	satp,a5
             switch_to(&(prev->context), &(next->context));
ffffffffc020448a:	03050593          	addi	a1,a0,48
ffffffffc020448e:	03048513          	addi	a0,s1,48
ffffffffc0204492:	380010ef          	jal	ra,ffffffffc0205812 <switch_to>
    if (flag)
ffffffffc0204496:	00099863          	bnez	s3,ffffffffc02044a6 <proc_run+0x52>
}
ffffffffc020449a:	70a2                	ld	ra,40(sp)
ffffffffc020449c:	7482                	ld	s1,32(sp)
ffffffffc020449e:	6962                	ld	s2,24(sp)
ffffffffc02044a0:	69c2                	ld	s3,16(sp)
ffffffffc02044a2:	6145                	addi	sp,sp,48
ffffffffc02044a4:	8082                	ret
ffffffffc02044a6:	70a2                	ld	ra,40(sp)
ffffffffc02044a8:	7482                	ld	s1,32(sp)
ffffffffc02044aa:	6962                	ld	s2,24(sp)
ffffffffc02044ac:	69c2                	ld	s3,16(sp)
ffffffffc02044ae:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02044b0:	ce2fc06f          	j	ffffffffc0200992 <intr_enable>
ffffffffc02044b4:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02044b6:	ce2fc0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        return 1;
ffffffffc02044ba:	6522                	ld	a0,8(sp)
ffffffffc02044bc:	4985                	li	s3,1
ffffffffc02044be:	bf6d                	j	ffffffffc0204478 <proc_run+0x24>

ffffffffc02044c0 <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf)
{
ffffffffc02044c0:	7119                	addi	sp,sp,-128
ffffffffc02044c2:	f0ca                	sd	s2,96(sp)
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS)
ffffffffc02044c4:	00142917          	auipc	s2,0x142
ffffffffc02044c8:	d7490913          	addi	s2,s2,-652 # ffffffffc0346238 <nr_process>
ffffffffc02044cc:	00092703          	lw	a4,0(s2)
{
ffffffffc02044d0:	fc86                	sd	ra,120(sp)
ffffffffc02044d2:	f8a2                	sd	s0,112(sp)
ffffffffc02044d4:	f4a6                	sd	s1,104(sp)
ffffffffc02044d6:	ecce                	sd	s3,88(sp)
ffffffffc02044d8:	e8d2                	sd	s4,80(sp)
ffffffffc02044da:	e4d6                	sd	s5,72(sp)
ffffffffc02044dc:	e0da                	sd	s6,64(sp)
ffffffffc02044de:	fc5e                	sd	s7,56(sp)
ffffffffc02044e0:	f862                	sd	s8,48(sp)
ffffffffc02044e2:	f466                	sd	s9,40(sp)
ffffffffc02044e4:	f06a                	sd	s10,32(sp)
ffffffffc02044e6:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc02044e8:	6785                	lui	a5,0x1
ffffffffc02044ea:	36f75b63          	bge	a4,a5,ffffffffc0204860 <do_fork+0x3a0>
ffffffffc02044ee:	8a2a                	mv	s4,a0
ffffffffc02044f0:	89ae                	mv	s3,a1
ffffffffc02044f2:	8432                	mv	s0,a2
     *    -------------------
     *    update step 1: set child proc's parent to current process, make sure current process's wait_state is 0
     *    update step 5: insert proc_struct into hash_list && proc_list, set the relation links of process
     */
     //    1. call alloc_proc to allocate a proc_struct
     if ((proc = alloc_proc()) == NULL)
ffffffffc02044f4:	e57ff0ef          	jal	ra,ffffffffc020434a <alloc_proc>
ffffffffc02044f8:	84aa                	mv	s1,a0
ffffffffc02044fa:	32050d63          	beqz	a0,ffffffffc0204834 <do_fork+0x374>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc02044fe:	4509                	li	a0,2
ffffffffc0204500:	a73fd0ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
    if (page != NULL)
ffffffffc0204504:	32050563          	beqz	a0,ffffffffc020482e <do_fork+0x36e>
    return page - pages + nbase;
ffffffffc0204508:	00142b17          	auipc	s6,0x142
ffffffffc020450c:	d00b0b13          	addi	s6,s6,-768 # ffffffffc0346208 <pages>
ffffffffc0204510:	000b3683          	ld	a3,0(s6)
ffffffffc0204514:	00005797          	auipc	a5,0x5
ffffffffc0204518:	8fc78793          	addi	a5,a5,-1796 # ffffffffc0208e10 <nbase>
ffffffffc020451c:	639c                	ld	a5,0(a5)
ffffffffc020451e:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0204522:	00142c17          	auipc	s8,0x142
ffffffffc0204526:	cdec0c13          	addi	s8,s8,-802 # ffffffffc0346200 <npage>
    return page - pages + nbase;
ffffffffc020452a:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020452c:	5dfd                	li	s11,-1
ffffffffc020452e:	000c3703          	ld	a4,0(s8)
    return page - pages + nbase;
ffffffffc0204532:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204534:	00cddd93          	srli	s11,s11,0xc
ffffffffc0204538:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc020453c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020453e:	38e67463          	bgeu	a2,a4,ffffffffc02048c6 <do_fork+0x406>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204542:	00142a97          	auipc	s5,0x142
ffffffffc0204546:	cdea8a93          	addi	s5,s5,-802 # ffffffffc0346220 <current>
ffffffffc020454a:	000ab703          	ld	a4,0(s5)
ffffffffc020454e:	00142c97          	auipc	s9,0x142
ffffffffc0204552:	ccac8c93          	addi	s9,s9,-822 # ffffffffc0346218 <va_pa_offset>
ffffffffc0204556:	000cb603          	ld	a2,0(s9)
ffffffffc020455a:	02873b83          	ld	s7,40(a4)
ffffffffc020455e:	e43e                	sd	a5,8(sp)
ffffffffc0204560:	96b2                	add	a3,a3,a2
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0204562:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc0204564:	020b8863          	beqz	s7,ffffffffc0204594 <do_fork+0xd4>
    if (clone_flags & CLONE_VM)
ffffffffc0204568:	100a7a13          	andi	s4,s4,256
ffffffffc020456c:	1c0a0663          	beqz	s4,ffffffffc0204738 <do_fork+0x278>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc0204570:	030ba683          	lw	a3,48(s7)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204574:	018bb783          	ld	a5,24(s7)
ffffffffc0204578:	c0200637          	lui	a2,0xc0200
ffffffffc020457c:	2685                	addiw	a3,a3,1
ffffffffc020457e:	02dba823          	sw	a3,48(s7)
    proc->mm = mm;
ffffffffc0204582:	0374b423          	sd	s7,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204586:	30c7e763          	bltu	a5,a2,ffffffffc0204894 <do_fork+0x3d4>
ffffffffc020458a:	000cb703          	ld	a4,0(s9)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020458e:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204590:	8f99                	sub	a5,a5,a4
ffffffffc0204592:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204594:	6789                	lui	a5,0x2
ffffffffc0204596:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0xf4c8>
ffffffffc020459a:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc020459c:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020459e:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc02045a0:	87b6                	mv	a5,a3
ffffffffc02045a2:	12040893          	addi	a7,s0,288
ffffffffc02045a6:	00063803          	ld	a6,0(a2) # ffffffffc0200000 <kern_entry>
ffffffffc02045aa:	6608                	ld	a0,8(a2)
ffffffffc02045ac:	6a0c                	ld	a1,16(a2)
ffffffffc02045ae:	6e18                	ld	a4,24(a2)
ffffffffc02045b0:	0107b023          	sd	a6,0(a5)
ffffffffc02045b4:	e788                	sd	a0,8(a5)
ffffffffc02045b6:	eb8c                	sd	a1,16(a5)
ffffffffc02045b8:	ef98                	sd	a4,24(a5)
ffffffffc02045ba:	02060613          	addi	a2,a2,32
ffffffffc02045be:	02078793          	addi	a5,a5,32
ffffffffc02045c2:	ff1612e3          	bne	a2,a7,ffffffffc02045a6 <do_fork+0xe6>
    proc->tf->gpr.a0 = 0;
ffffffffc02045c6:	0406b823          	sd	zero,80(a3)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02045ca:	14098463          	beqz	s3,ffffffffc0204712 <do_fork+0x252>
ffffffffc02045ce:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02045d2:	00000797          	auipc	a5,0x0
ffffffffc02045d6:	e7478793          	addi	a5,a5,-396 # ffffffffc0204446 <forkret>
ffffffffc02045da:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02045dc:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02045de:	100027f3          	csrr	a5,sstatus
ffffffffc02045e2:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02045e4:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02045e6:	14079563          	bnez	a5,ffffffffc0204730 <do_fork+0x270>
    if (++last_pid >= MAX_PID)
ffffffffc02045ea:	0013d817          	auipc	a6,0x13d
ffffffffc02045ee:	77e80813          	addi	a6,a6,1918 # ffffffffc0341d68 <last_pid.1>
     
     //    5. insert proc_struct into hash_list && proc_list
     bool intr_flag;
     local_intr_save(intr_flag);
     {
         proc->parent = current;
ffffffffc02045f2:	000ab703          	ld	a4,0(s5)
    if (++last_pid >= MAX_PID)
ffffffffc02045f6:	00082783          	lw	a5,0(a6)
ffffffffc02045fa:	6689                	lui	a3,0x2
         proc->parent = current;
ffffffffc02045fc:	f098                	sd	a4,32(s1)
    if (++last_pid >= MAX_PID)
ffffffffc02045fe:	0017851b          	addiw	a0,a5,1
         current->wait_state = 0;
ffffffffc0204602:	0e072623          	sw	zero,236(a4)
    if (++last_pid >= MAX_PID)
ffffffffc0204606:	00a82023          	sw	a0,0(a6)
ffffffffc020460a:	08d55d63          	bge	a0,a3,ffffffffc02046a4 <do_fork+0x1e4>
    if (last_pid >= next_safe)
ffffffffc020460e:	0013d317          	auipc	t1,0x13d
ffffffffc0204612:	75e30313          	addi	t1,t1,1886 # ffffffffc0341d6c <next_safe.0>
ffffffffc0204616:	00032783          	lw	a5,0(t1)
ffffffffc020461a:	00142417          	auipc	s0,0x142
ffffffffc020461e:	b6e40413          	addi	s0,s0,-1170 # ffffffffc0346188 <proc_list>
ffffffffc0204622:	08f55963          	bge	a0,a5,ffffffffc02046b4 <do_fork+0x1f4>
         proc->pid = get_pid();
ffffffffc0204626:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204628:	45a9                	li	a1,10
ffffffffc020462a:	2501                	sext.w	a0,a0
ffffffffc020462c:	656010ef          	jal	ra,ffffffffc0205c82 <hash32>
ffffffffc0204630:	02051793          	slli	a5,a0,0x20
ffffffffc0204634:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204638:	0013e797          	auipc	a5,0x13e
ffffffffc020463c:	b5078793          	addi	a5,a5,-1200 # ffffffffc0342188 <hash_list>
ffffffffc0204640:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204642:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204644:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204646:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc020464a:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc020464c:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc020464e:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204650:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204652:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc0204656:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc0204658:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc020465a:	e21c                	sd	a5,0(a2)
ffffffffc020465c:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc020465e:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc0204660:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc0204662:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204666:	10e4b023          	sd	a4,256(s1)
ffffffffc020466a:	c311                	beqz	a4,ffffffffc020466e <do_fork+0x1ae>
        proc->optr->yptr = proc;
ffffffffc020466c:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc020466e:	00092783          	lw	a5,0(s2)
    proc->parent->cptr = proc;
ffffffffc0204672:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc0204674:	2785                	addiw	a5,a5,1
ffffffffc0204676:	00f92023          	sw	a5,0(s2)
    if (flag)
ffffffffc020467a:	1a099f63          	bnez	s3,ffffffffc0204838 <do_fork+0x378>
         set_links(proc);  // 这个函数内部已经包含了list_add和nr_process++
     }
     local_intr_restore(intr_flag);
     
     //    6. call wakeup_proc to make the new child process RUNNABLE
     wakeup_proc(proc);
ffffffffc020467e:	8526                	mv	a0,s1
ffffffffc0204680:	38a010ef          	jal	ra,ffffffffc0205a0a <wakeup_proc>
     
     //    7. set ret vaule using child proc's pid
     ret = proc->pid;     
ffffffffc0204684:	40c8                	lw	a0,4(s1)
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
ffffffffc0204686:	70e6                	ld	ra,120(sp)
ffffffffc0204688:	7446                	ld	s0,112(sp)
ffffffffc020468a:	74a6                	ld	s1,104(sp)
ffffffffc020468c:	7906                	ld	s2,96(sp)
ffffffffc020468e:	69e6                	ld	s3,88(sp)
ffffffffc0204690:	6a46                	ld	s4,80(sp)
ffffffffc0204692:	6aa6                	ld	s5,72(sp)
ffffffffc0204694:	6b06                	ld	s6,64(sp)
ffffffffc0204696:	7be2                	ld	s7,56(sp)
ffffffffc0204698:	7c42                	ld	s8,48(sp)
ffffffffc020469a:	7ca2                	ld	s9,40(sp)
ffffffffc020469c:	7d02                	ld	s10,32(sp)
ffffffffc020469e:	6de2                	ld	s11,24(sp)
ffffffffc02046a0:	6109                	addi	sp,sp,128
ffffffffc02046a2:	8082                	ret
        last_pid = 1;
ffffffffc02046a4:	4785                	li	a5,1
ffffffffc02046a6:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02046aa:	4505                	li	a0,1
ffffffffc02046ac:	0013d317          	auipc	t1,0x13d
ffffffffc02046b0:	6c030313          	addi	t1,t1,1728 # ffffffffc0341d6c <next_safe.0>
    return listelm->next;
ffffffffc02046b4:	00142417          	auipc	s0,0x142
ffffffffc02046b8:	ad440413          	addi	s0,s0,-1324 # ffffffffc0346188 <proc_list>
ffffffffc02046bc:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc02046c0:	6789                	lui	a5,0x2
ffffffffc02046c2:	00f32023          	sw	a5,0(t1)
ffffffffc02046c6:	86aa                	mv	a3,a0
ffffffffc02046c8:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc02046ca:	6e89                	lui	t4,0x2
ffffffffc02046cc:	188e0463          	beq	t3,s0,ffffffffc0204854 <do_fork+0x394>
ffffffffc02046d0:	88ae                	mv	a7,a1
ffffffffc02046d2:	87f2                	mv	a5,t3
ffffffffc02046d4:	6609                	lui	a2,0x2
ffffffffc02046d6:	a811                	j	ffffffffc02046ea <do_fork+0x22a>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02046d8:	00e6d663          	bge	a3,a4,ffffffffc02046e4 <do_fork+0x224>
ffffffffc02046dc:	00c75463          	bge	a4,a2,ffffffffc02046e4 <do_fork+0x224>
ffffffffc02046e0:	863a                	mv	a2,a4
ffffffffc02046e2:	4885                	li	a7,1
ffffffffc02046e4:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02046e6:	00878d63          	beq	a5,s0,ffffffffc0204700 <do_fork+0x240>
            if (proc->pid == last_pid)
ffffffffc02046ea:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0xf46c>
ffffffffc02046ee:	fed715e3          	bne	a4,a3,ffffffffc02046d8 <do_fork+0x218>
                if (++last_pid >= next_safe)
ffffffffc02046f2:	2685                	addiw	a3,a3,1
ffffffffc02046f4:	14c6d563          	bge	a3,a2,ffffffffc020483e <do_fork+0x37e>
ffffffffc02046f8:	679c                	ld	a5,8(a5)
ffffffffc02046fa:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc02046fc:	fe8797e3          	bne	a5,s0,ffffffffc02046ea <do_fork+0x22a>
ffffffffc0204700:	c581                	beqz	a1,ffffffffc0204708 <do_fork+0x248>
ffffffffc0204702:	00d82023          	sw	a3,0(a6)
ffffffffc0204706:	8536                	mv	a0,a3
ffffffffc0204708:	f0088fe3          	beqz	a7,ffffffffc0204626 <do_fork+0x166>
ffffffffc020470c:	00c32023          	sw	a2,0(t1)
ffffffffc0204710:	bf19                	j	ffffffffc0204626 <do_fork+0x166>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204712:	89b6                	mv	s3,a3
ffffffffc0204714:	0136b823          	sd	s3,16(a3) # 2010 <_binary_obj___user_faultread_out_size-0xf398>
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204718:	00000797          	auipc	a5,0x0
ffffffffc020471c:	d2e78793          	addi	a5,a5,-722 # ffffffffc0204446 <forkret>
ffffffffc0204720:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204722:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204724:	100027f3          	csrr	a5,sstatus
ffffffffc0204728:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020472a:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020472c:	ea078fe3          	beqz	a5,ffffffffc02045ea <do_fork+0x12a>
        intr_disable();
ffffffffc0204730:	a68fc0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        return 1;
ffffffffc0204734:	4985                	li	s3,1
ffffffffc0204736:	bd55                	j	ffffffffc02045ea <do_fork+0x12a>
    if ((mm = mm_create()) == NULL)
ffffffffc0204738:	c18ff0ef          	jal	ra,ffffffffc0203b50 <mm_create>
ffffffffc020473c:	67a2                	ld	a5,8(sp)
ffffffffc020473e:	8d2a                	mv	s10,a0
ffffffffc0204740:	c161                	beqz	a0,ffffffffc0204800 <do_fork+0x340>
    if ((page = alloc_page()) == NULL)
ffffffffc0204742:	4505                	li	a0,1
ffffffffc0204744:	82ffd0ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc0204748:	67a2                	ld	a5,8(sp)
ffffffffc020474a:	0e050f63          	beqz	a0,ffffffffc0204848 <do_fork+0x388>
    return page - pages + nbase;
ffffffffc020474e:	000b3683          	ld	a3,0(s6)
    return KADDR(page2pa(page));
ffffffffc0204752:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204756:	40d506b3          	sub	a3,a0,a3
ffffffffc020475a:	8699                	srai	a3,a3,0x6
ffffffffc020475c:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020475e:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc0204762:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204764:	16cdf163          	bgeu	s11,a2,ffffffffc02048c6 <do_fork+0x406>
ffffffffc0204768:	000cba03          	ld	s4,0(s9)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc020476c:	6605                	lui	a2,0x1
ffffffffc020476e:	00142597          	auipc	a1,0x142
ffffffffc0204772:	a8a5b583          	ld	a1,-1398(a1) # ffffffffc03461f8 <boot_pgdir_va>
ffffffffc0204776:	9a36                	add	s4,s4,a3
ffffffffc0204778:	8552                	mv	a0,s4
ffffffffc020477a:	4b9010ef          	jal	ra,ffffffffc0206432 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc020477e:	038b8d93          	addi	s11,s7,56
    mm->pgdir = pgdir;
ffffffffc0204782:	014d3c23          	sd	s4,24(s10)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204786:	4785                	li	a5,1
ffffffffc0204788:	40fdb7af          	amoor.d	a5,a5,(s11)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc020478c:	8b85                	andi	a5,a5,1
ffffffffc020478e:	4a05                	li	s4,1
ffffffffc0204790:	c799                	beqz	a5,ffffffffc020479e <do_fork+0x2de>
    {
        schedule();
ffffffffc0204792:	32a010ef          	jal	ra,ffffffffc0205abc <schedule>
ffffffffc0204796:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc020479a:	8b85                	andi	a5,a5,1
ffffffffc020479c:	fbfd                	bnez	a5,ffffffffc0204792 <do_fork+0x2d2>
        ret = dup_mmap(mm, oldmm);
ffffffffc020479e:	85de                	mv	a1,s7
ffffffffc02047a0:	856a                	mv	a0,s10
ffffffffc02047a2:	ddeff0ef          	jal	ra,ffffffffc0203d80 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02047a6:	57f9                	li	a5,-2
ffffffffc02047a8:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc02047ac:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02047ae:	10078063          	beqz	a5,ffffffffc02048ae <do_fork+0x3ee>
good_mm:
ffffffffc02047b2:	8bea                	mv	s7,s10
    if (ret != 0)
ffffffffc02047b4:	da050ee3          	beqz	a0,ffffffffc0204570 <do_fork+0xb0>
    exit_mmap(mm);
ffffffffc02047b8:	856a                	mv	a0,s10
ffffffffc02047ba:	e60ff0ef          	jal	ra,ffffffffc0203e1a <exit_mmap>
    return pa2page(PADDR(kva));
ffffffffc02047be:	018d3683          	ld	a3,24(s10)
ffffffffc02047c2:	c02007b7          	lui	a5,0xc0200
ffffffffc02047c6:	0af6eb63          	bltu	a3,a5,ffffffffc020487c <do_fork+0x3bc>
ffffffffc02047ca:	000cb703          	ld	a4,0(s9)
    if (PPN(pa) >= npage)
ffffffffc02047ce:	000c3783          	ld	a5,0(s8)
    return pa2page(PADDR(kva));
ffffffffc02047d2:	40e68733          	sub	a4,a3,a4
    if (PPN(pa) >= npage)
ffffffffc02047d6:	8331                	srli	a4,a4,0xc
ffffffffc02047d8:	08f77663          	bgeu	a4,a5,ffffffffc0204864 <do_fork+0x3a4>
    return &pages[PPN(pa) - nbase];
ffffffffc02047dc:	00004797          	auipc	a5,0x4
ffffffffc02047e0:	63478793          	addi	a5,a5,1588 # ffffffffc0208e10 <nbase>
ffffffffc02047e4:	639c                	ld	a5,0(a5)
ffffffffc02047e6:	000b3503          	ld	a0,0(s6)
    free_page(kva2page(mm->pgdir));
ffffffffc02047ea:	4585                	li	a1,1
ffffffffc02047ec:	8f1d                	sub	a4,a4,a5
ffffffffc02047ee:	071a                	slli	a4,a4,0x6
ffffffffc02047f0:	953a                	add	a0,a0,a4
ffffffffc02047f2:	e43e                	sd	a5,8(sp)
ffffffffc02047f4:	fbcfd0ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    mm_destroy(mm);
ffffffffc02047f8:	856a                	mv	a0,s10
ffffffffc02047fa:	c56ff0ef          	jal	ra,ffffffffc0203c50 <mm_destroy>
ffffffffc02047fe:	67a2                	ld	a5,8(sp)
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204800:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc0204802:	c0200737          	lui	a4,0xc0200
ffffffffc0204806:	06e6eb63          	bltu	a3,a4,ffffffffc020487c <do_fork+0x3bc>
ffffffffc020480a:	000cb703          	ld	a4,0(s9)
    if (PPN(pa) >= npage)
ffffffffc020480e:	000c3603          	ld	a2,0(s8)
    return pa2page(PADDR(kva));
ffffffffc0204812:	40e68733          	sub	a4,a3,a4
    if (PPN(pa) >= npage)
ffffffffc0204816:	8331                	srli	a4,a4,0xc
ffffffffc0204818:	04c77663          	bgeu	a4,a2,ffffffffc0204864 <do_fork+0x3a4>
    return &pages[PPN(pa) - nbase];
ffffffffc020481c:	000b3503          	ld	a0,0(s6)
ffffffffc0204820:	40f707b3          	sub	a5,a4,a5
ffffffffc0204824:	079a                	slli	a5,a5,0x6
ffffffffc0204826:	4589                	li	a1,2
ffffffffc0204828:	953e                	add	a0,a0,a5
ffffffffc020482a:	f86fd0ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    kfree(proc);
ffffffffc020482e:	8526                	mv	a0,s1
ffffffffc0204830:	d6cfd0ef          	jal	ra,ffffffffc0201d9c <kfree>
    ret = -E_NO_MEM;
ffffffffc0204834:	5571                	li	a0,-4
    return ret;
ffffffffc0204836:	bd81                	j	ffffffffc0204686 <do_fork+0x1c6>
        intr_enable();
ffffffffc0204838:	95afc0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc020483c:	b589                	j	ffffffffc020467e <do_fork+0x1be>
                    if (last_pid >= MAX_PID)
ffffffffc020483e:	01d6c363          	blt	a3,t4,ffffffffc0204844 <do_fork+0x384>
                        last_pid = 1;
ffffffffc0204842:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204844:	4585                	li	a1,1
ffffffffc0204846:	b559                	j	ffffffffc02046cc <do_fork+0x20c>
    mm_destroy(mm);
ffffffffc0204848:	856a                	mv	a0,s10
ffffffffc020484a:	e43e                	sd	a5,8(sp)
ffffffffc020484c:	c04ff0ef          	jal	ra,ffffffffc0203c50 <mm_destroy>
ffffffffc0204850:	67a2                	ld	a5,8(sp)
ffffffffc0204852:	b77d                	j	ffffffffc0204800 <do_fork+0x340>
ffffffffc0204854:	dc0589e3          	beqz	a1,ffffffffc0204626 <do_fork+0x166>
ffffffffc0204858:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc020485c:	8536                	mv	a0,a3
ffffffffc020485e:	b3e1                	j	ffffffffc0204626 <do_fork+0x166>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204860:	556d                	li	a0,-5
ffffffffc0204862:	b515                	j	ffffffffc0204686 <do_fork+0x1c6>
        panic("pa2page called with invalid pa");
ffffffffc0204864:	00003617          	auipc	a2,0x3
ffffffffc0204868:	c0c60613          	addi	a2,a2,-1012 # ffffffffc0207470 <default_pmm_manager+0x108>
ffffffffc020486c:	06900593          	li	a1,105
ffffffffc0204870:	00003517          	auipc	a0,0x3
ffffffffc0204874:	b9050513          	addi	a0,a0,-1136 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc0204878:	c01fb0ef          	jal	ra,ffffffffc0200478 <__panic>
    return pa2page(PADDR(kva));
ffffffffc020487c:	00003617          	auipc	a2,0x3
ffffffffc0204880:	bcc60613          	addi	a2,a2,-1076 # ffffffffc0207448 <default_pmm_manager+0xe0>
ffffffffc0204884:	07700593          	li	a1,119
ffffffffc0204888:	00003517          	auipc	a0,0x3
ffffffffc020488c:	b7850513          	addi	a0,a0,-1160 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc0204890:	be9fb0ef          	jal	ra,ffffffffc0200478 <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204894:	86be                	mv	a3,a5
ffffffffc0204896:	00003617          	auipc	a2,0x3
ffffffffc020489a:	bb260613          	addi	a2,a2,-1102 # ffffffffc0207448 <default_pmm_manager+0xe0>
ffffffffc020489e:	1af00593          	li	a1,431
ffffffffc02048a2:	00003517          	auipc	a0,0x3
ffffffffc02048a6:	4f650513          	addi	a0,a0,1270 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc02048aa:	bcffb0ef          	jal	ra,ffffffffc0200478 <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc02048ae:	00003617          	auipc	a2,0x3
ffffffffc02048b2:	4c260613          	addi	a2,a2,1218 # ffffffffc0207d70 <default_pmm_manager+0xa08>
ffffffffc02048b6:	04000593          	li	a1,64
ffffffffc02048ba:	00003517          	auipc	a0,0x3
ffffffffc02048be:	4c650513          	addi	a0,a0,1222 # ffffffffc0207d80 <default_pmm_manager+0xa18>
ffffffffc02048c2:	bb7fb0ef          	jal	ra,ffffffffc0200478 <__panic>
    return KADDR(page2pa(page));
ffffffffc02048c6:	00003617          	auipc	a2,0x3
ffffffffc02048ca:	b1260613          	addi	a2,a2,-1262 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc02048ce:	07100593          	li	a1,113
ffffffffc02048d2:	00003517          	auipc	a0,0x3
ffffffffc02048d6:	b2e50513          	addi	a0,a0,-1234 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc02048da:	b9ffb0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc02048de <kernel_thread>:
{
ffffffffc02048de:	7129                	addi	sp,sp,-320
ffffffffc02048e0:	fa22                	sd	s0,304(sp)
ffffffffc02048e2:	f626                	sd	s1,296(sp)
ffffffffc02048e4:	f24a                	sd	s2,288(sp)
ffffffffc02048e6:	84ae                	mv	s1,a1
ffffffffc02048e8:	892a                	mv	s2,a0
ffffffffc02048ea:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02048ec:	4581                	li	a1,0
ffffffffc02048ee:	12000613          	li	a2,288
ffffffffc02048f2:	850a                	mv	a0,sp
{
ffffffffc02048f4:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02048f6:	1b7010ef          	jal	ra,ffffffffc02062ac <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02048fa:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02048fc:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02048fe:	100027f3          	csrr	a5,sstatus
ffffffffc0204902:	edd7f793          	andi	a5,a5,-291
ffffffffc0204906:	1207e793          	ori	a5,a5,288
ffffffffc020490a:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020490c:	860a                	mv	a2,sp
ffffffffc020490e:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204912:	00000797          	auipc	a5,0x0
ffffffffc0204916:	a3078793          	addi	a5,a5,-1488 # ffffffffc0204342 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020491a:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020491c:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020491e:	ba3ff0ef          	jal	ra,ffffffffc02044c0 <do_fork>
}
ffffffffc0204922:	70f2                	ld	ra,312(sp)
ffffffffc0204924:	7452                	ld	s0,304(sp)
ffffffffc0204926:	74b2                	ld	s1,296(sp)
ffffffffc0204928:	7912                	ld	s2,288(sp)
ffffffffc020492a:	6131                	addi	sp,sp,320
ffffffffc020492c:	8082                	ret

ffffffffc020492e <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int do_exit(int error_code)
{
ffffffffc020492e:	7179                	addi	sp,sp,-48
ffffffffc0204930:	e84a                	sd	s2,16(sp)
    if (current == idleproc)
ffffffffc0204932:	00142917          	auipc	s2,0x142
ffffffffc0204936:	8ee90913          	addi	s2,s2,-1810 # ffffffffc0346220 <current>
ffffffffc020493a:	00093783          	ld	a5,0(s2)
{
ffffffffc020493e:	f406                	sd	ra,40(sp)
ffffffffc0204940:	f022                	sd	s0,32(sp)
ffffffffc0204942:	ec26                	sd	s1,24(sp)
ffffffffc0204944:	e44e                	sd	s3,8(sp)
ffffffffc0204946:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc0204948:	00142717          	auipc	a4,0x142
ffffffffc020494c:	8e073703          	ld	a4,-1824(a4) # ffffffffc0346228 <idleproc>
ffffffffc0204950:	0ce78f63          	beq	a5,a4,ffffffffc0204a2e <do_exit+0x100>
    {
        panic("idleproc exit.\n");
    }
    if (current == initproc)
ffffffffc0204954:	00142417          	auipc	s0,0x142
ffffffffc0204958:	8dc40413          	addi	s0,s0,-1828 # ffffffffc0346230 <initproc>
ffffffffc020495c:	6018                	ld	a4,0(s0)
ffffffffc020495e:	12e78a63          	beq	a5,a4,ffffffffc0204a92 <do_exit+0x164>
    {
        panic("initproc exit.\n");
    }
    struct mm_struct *mm = current->mm;
ffffffffc0204962:	7784                	ld	s1,40(a5)
ffffffffc0204964:	89aa                	mv	s3,a0
    if (mm != NULL)
ffffffffc0204966:	c485                	beqz	s1,ffffffffc020498e <do_exit+0x60>
ffffffffc0204968:	00142797          	auipc	a5,0x142
ffffffffc020496c:	8887b783          	ld	a5,-1912(a5) # ffffffffc03461f0 <boot_pgdir_pa>
ffffffffc0204970:	577d                	li	a4,-1
ffffffffc0204972:	177e                	slli	a4,a4,0x3f
ffffffffc0204974:	83b1                	srli	a5,a5,0xc
ffffffffc0204976:	8fd9                	or	a5,a5,a4
ffffffffc0204978:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc020497c:	589c                	lw	a5,48(s1)
ffffffffc020497e:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204982:	d898                	sw	a4,48(s1)
    {
        lsatp(boot_pgdir_pa);
        if (mm_count_dec(mm) == 0)
ffffffffc0204984:	c369                	beqz	a4,ffffffffc0204a46 <do_exit+0x118>
        {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
ffffffffc0204986:	00093783          	ld	a5,0(s2)
ffffffffc020498a:	0207b423          	sd	zero,40(a5)
    }
    current->state = PROC_ZOMBIE;
ffffffffc020498e:	00093783          	ld	a5,0(s2)
ffffffffc0204992:	470d                	li	a4,3
ffffffffc0204994:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc0204996:	0f37a423          	sw	s3,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020499a:	100027f3          	csrr	a5,sstatus
ffffffffc020499e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02049a0:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02049a2:	10079463          	bnez	a5,ffffffffc0204aaa <do_exit+0x17c>
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
    {
        proc = current->parent;
ffffffffc02049a6:	00093703          	ld	a4,0(s2)
        if (proc->wait_state == WT_CHILD)
ffffffffc02049aa:	800007b7          	lui	a5,0x80000
ffffffffc02049ae:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc02049b0:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc02049b2:	0ec52703          	lw	a4,236(a0)
ffffffffc02049b6:	0ef70e63          	beq	a4,a5,ffffffffc0204ab2 <do_exit+0x184>
        {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL)
ffffffffc02049ba:	00093683          	ld	a3,0(s2)
            }
            proc->parent = initproc;
            initproc->cptr = proc;
            if (proc->state == PROC_ZOMBIE)
            {
                if (initproc->wait_state == WT_CHILD)
ffffffffc02049be:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc02049c2:	448d                	li	s1,3
        while (current->cptr != NULL)
ffffffffc02049c4:	7afc                	ld	a5,240(a3)
                if (initproc->wait_state == WT_CHILD)
ffffffffc02049c6:	0985                	addi	s3,s3,1
        while (current->cptr != NULL)
ffffffffc02049c8:	e781                	bnez	a5,ffffffffc02049d0 <do_exit+0xa2>
ffffffffc02049ca:	a825                	j	ffffffffc0204a02 <do_exit+0xd4>
ffffffffc02049cc:	7afc                	ld	a5,240(a3)
ffffffffc02049ce:	cb95                	beqz	a5,ffffffffc0204a02 <do_exit+0xd4>
            current->cptr = proc->optr;
ffffffffc02049d0:	1007b703          	ld	a4,256(a5) # ffffffff80000100 <_binary_obj___user_matrix_out_size+0xffffffff7ffe9580>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02049d4:	6008                	ld	a0,0(s0)
            current->cptr = proc->optr;
ffffffffc02049d6:	faf8                	sd	a4,240(a3)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02049d8:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02049da:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02049de:	10e7b023          	sd	a4,256(a5)
ffffffffc02049e2:	c311                	beqz	a4,ffffffffc02049e6 <do_exit+0xb8>
                initproc->cptr->yptr = proc;
ffffffffc02049e4:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02049e6:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02049e8:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02049ea:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02049ec:	fe9710e3          	bne	a4,s1,ffffffffc02049cc <do_exit+0x9e>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02049f0:	0ec52783          	lw	a5,236(a0)
ffffffffc02049f4:	fd379ce3          	bne	a5,s3,ffffffffc02049cc <do_exit+0x9e>
                {
                    wakeup_proc(initproc);
ffffffffc02049f8:	012010ef          	jal	ra,ffffffffc0205a0a <wakeup_proc>
        while (current->cptr != NULL)
ffffffffc02049fc:	00093683          	ld	a3,0(s2)
ffffffffc0204a00:	b7f1                	j	ffffffffc02049cc <do_exit+0x9e>
    if (flag)
ffffffffc0204a02:	020a1363          	bnez	s4,ffffffffc0204a28 <do_exit+0xfa>
                }
            }
        }
    }
    local_intr_restore(intr_flag);
    schedule();
ffffffffc0204a06:	0b6010ef          	jal	ra,ffffffffc0205abc <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc0204a0a:	00093783          	ld	a5,0(s2)
ffffffffc0204a0e:	00003617          	auipc	a2,0x3
ffffffffc0204a12:	3c260613          	addi	a2,a2,962 # ffffffffc0207dd0 <default_pmm_manager+0xa68>
ffffffffc0204a16:	26900593          	li	a1,617
ffffffffc0204a1a:	43d4                	lw	a3,4(a5)
ffffffffc0204a1c:	00003517          	auipc	a0,0x3
ffffffffc0204a20:	37c50513          	addi	a0,a0,892 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc0204a24:	a55fb0ef          	jal	ra,ffffffffc0200478 <__panic>
        intr_enable();
ffffffffc0204a28:	f6bfb0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0204a2c:	bfe9                	j	ffffffffc0204a06 <do_exit+0xd8>
        panic("idleproc exit.\n");
ffffffffc0204a2e:	00003617          	auipc	a2,0x3
ffffffffc0204a32:	38260613          	addi	a2,a2,898 # ffffffffc0207db0 <default_pmm_manager+0xa48>
ffffffffc0204a36:	23500593          	li	a1,565
ffffffffc0204a3a:	00003517          	auipc	a0,0x3
ffffffffc0204a3e:	35e50513          	addi	a0,a0,862 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc0204a42:	a37fb0ef          	jal	ra,ffffffffc0200478 <__panic>
            exit_mmap(mm);
ffffffffc0204a46:	8526                	mv	a0,s1
ffffffffc0204a48:	bd2ff0ef          	jal	ra,ffffffffc0203e1a <exit_mmap>
    return pa2page(PADDR(kva));
ffffffffc0204a4c:	6c94                	ld	a3,24(s1)
ffffffffc0204a4e:	c02007b7          	lui	a5,0xc0200
ffffffffc0204a52:	06f6e363          	bltu	a3,a5,ffffffffc0204ab8 <do_exit+0x18a>
ffffffffc0204a56:	00141797          	auipc	a5,0x141
ffffffffc0204a5a:	7c27b783          	ld	a5,1986(a5) # ffffffffc0346218 <va_pa_offset>
ffffffffc0204a5e:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204a60:	82b1                	srli	a3,a3,0xc
ffffffffc0204a62:	00141797          	auipc	a5,0x141
ffffffffc0204a66:	79e7b783          	ld	a5,1950(a5) # ffffffffc0346200 <npage>
ffffffffc0204a6a:	06f6f363          	bgeu	a3,a5,ffffffffc0204ad0 <do_exit+0x1a2>
    return &pages[PPN(pa) - nbase];
ffffffffc0204a6e:	00004517          	auipc	a0,0x4
ffffffffc0204a72:	3a253503          	ld	a0,930(a0) # ffffffffc0208e10 <nbase>
ffffffffc0204a76:	8e89                	sub	a3,a3,a0
ffffffffc0204a78:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0204a7a:	00141517          	auipc	a0,0x141
ffffffffc0204a7e:	78e53503          	ld	a0,1934(a0) # ffffffffc0346208 <pages>
ffffffffc0204a82:	9536                	add	a0,a0,a3
ffffffffc0204a84:	4585                	li	a1,1
ffffffffc0204a86:	d2afd0ef          	jal	ra,ffffffffc0201fb0 <free_pages>
            mm_destroy(mm);
ffffffffc0204a8a:	8526                	mv	a0,s1
ffffffffc0204a8c:	9c4ff0ef          	jal	ra,ffffffffc0203c50 <mm_destroy>
ffffffffc0204a90:	bddd                	j	ffffffffc0204986 <do_exit+0x58>
        panic("initproc exit.\n");
ffffffffc0204a92:	00003617          	auipc	a2,0x3
ffffffffc0204a96:	32e60613          	addi	a2,a2,814 # ffffffffc0207dc0 <default_pmm_manager+0xa58>
ffffffffc0204a9a:	23900593          	li	a1,569
ffffffffc0204a9e:	00003517          	auipc	a0,0x3
ffffffffc0204aa2:	2fa50513          	addi	a0,a0,762 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc0204aa6:	9d3fb0ef          	jal	ra,ffffffffc0200478 <__panic>
        intr_disable();
ffffffffc0204aaa:	eeffb0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        return 1;
ffffffffc0204aae:	4a05                	li	s4,1
ffffffffc0204ab0:	bddd                	j	ffffffffc02049a6 <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204ab2:	759000ef          	jal	ra,ffffffffc0205a0a <wakeup_proc>
ffffffffc0204ab6:	b711                	j	ffffffffc02049ba <do_exit+0x8c>
    return pa2page(PADDR(kva));
ffffffffc0204ab8:	00003617          	auipc	a2,0x3
ffffffffc0204abc:	99060613          	addi	a2,a2,-1648 # ffffffffc0207448 <default_pmm_manager+0xe0>
ffffffffc0204ac0:	07700593          	li	a1,119
ffffffffc0204ac4:	00003517          	auipc	a0,0x3
ffffffffc0204ac8:	93c50513          	addi	a0,a0,-1732 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc0204acc:	9adfb0ef          	jal	ra,ffffffffc0200478 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204ad0:	00003617          	auipc	a2,0x3
ffffffffc0204ad4:	9a060613          	addi	a2,a2,-1632 # ffffffffc0207470 <default_pmm_manager+0x108>
ffffffffc0204ad8:	06900593          	li	a1,105
ffffffffc0204adc:	00003517          	auipc	a0,0x3
ffffffffc0204ae0:	92450513          	addi	a0,a0,-1756 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc0204ae4:	995fb0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0204ae8 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc0204ae8:	7139                	addi	sp,sp,-64
ffffffffc0204aea:	fc06                	sd	ra,56(sp)
ffffffffc0204aec:	f822                	sd	s0,48(sp)
ffffffffc0204aee:	f426                	sd	s1,40(sp)
ffffffffc0204af0:	f04a                	sd	s2,32(sp)
ffffffffc0204af2:	ec4e                	sd	s3,24(sp)
ffffffffc0204af4:	e852                	sd	s4,16(sp)
ffffffffc0204af6:	e456                	sd	s5,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0204af8:	cf8fd0ef          	jal	ra,ffffffffc0201ff0 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204afc:	992fd0ef          	jal	ra,ffffffffc0201c8e <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0204b00:	4601                	li	a2,0
ffffffffc0204b02:	4581                	li	a1,0
ffffffffc0204b04:	00001517          	auipc	a0,0x1
ffffffffc0204b08:	80650513          	addi	a0,a0,-2042 # ffffffffc020530a <user_main>
ffffffffc0204b0c:	dd3ff0ef          	jal	ra,ffffffffc02048de <kernel_thread>
    if (pid <= 0)
ffffffffc0204b10:	16a05463          	blez	a0,ffffffffc0204c78 <init_main+0x190>
        current->wait_state = WT_CHILD;
ffffffffc0204b14:	800009b7          	lui	s3,0x80000
ffffffffc0204b18:	00141917          	auipc	s2,0x141
ffffffffc0204b1c:	70890913          	addi	s2,s2,1800 # ffffffffc0346220 <current>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204b20:	448d                	li	s1,3
        current->state = PROC_SLEEPING;
ffffffffc0204b22:	4a05                	li	s4,1
        current->wait_state = WT_CHILD;
ffffffffc0204b24:	0985                	addi	s3,s3,1
    if (proc == idleproc || proc == initproc)
ffffffffc0204b26:	00141a97          	auipc	s5,0x141
ffffffffc0204b2a:	702a8a93          	addi	s5,s5,1794 # ffffffffc0346228 <idleproc>
        proc = current->cptr;
ffffffffc0204b2e:	00093703          	ld	a4,0(s2)
ffffffffc0204b32:	7b60                	ld	s0,240(a4)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204b34:	e409                	bnez	s0,ffffffffc0204b3e <init_main+0x56>
ffffffffc0204b36:	a8e9                	j	ffffffffc0204c10 <init_main+0x128>
ffffffffc0204b38:	10043403          	ld	s0,256(s0)
ffffffffc0204b3c:	c04d                	beqz	s0,ffffffffc0204bde <init_main+0xf6>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204b3e:	401c                	lw	a5,0(s0)
ffffffffc0204b40:	fe979ce3          	bne	a5,s1,ffffffffc0204b38 <init_main+0x50>
    if (proc == idleproc || proc == initproc)
ffffffffc0204b44:	000ab783          	ld	a5,0(s5)
ffffffffc0204b48:	1e878c63          	beq	a5,s0,ffffffffc0204d40 <init_main+0x258>
ffffffffc0204b4c:	00141797          	auipc	a5,0x141
ffffffffc0204b50:	6e47b783          	ld	a5,1764(a5) # ffffffffc0346230 <initproc>
ffffffffc0204b54:	1e878663          	beq	a5,s0,ffffffffc0204d40 <init_main+0x258>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204b58:	100027f3          	csrr	a5,sstatus
ffffffffc0204b5c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204b5e:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204b60:	e7c5                	bnez	a5,ffffffffc0204c08 <init_main+0x120>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204b62:	6c70                	ld	a2,216(s0)
ffffffffc0204b64:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204b66:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc0204b6a:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc0204b6c:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204b6e:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204b70:	6470                	ld	a2,200(s0)
ffffffffc0204b72:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc0204b74:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204b76:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc0204b78:	c319                	beqz	a4,ffffffffc0204b7e <init_main+0x96>
        proc->optr->yptr = proc->yptr;
ffffffffc0204b7a:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc0204b7c:	7c7c                	ld	a5,248(s0)
ffffffffc0204b7e:	c3d1                	beqz	a5,ffffffffc0204c02 <init_main+0x11a>
        proc->yptr->optr = proc->optr;
ffffffffc0204b80:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc0204b84:	00141717          	auipc	a4,0x141
ffffffffc0204b88:	6b470713          	addi	a4,a4,1716 # ffffffffc0346238 <nr_process>
ffffffffc0204b8c:	431c                	lw	a5,0(a4)
ffffffffc0204b8e:	37fd                	addiw	a5,a5,-1
ffffffffc0204b90:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc0204b92:	e5ad                	bnez	a1,ffffffffc0204bfc <init_main+0x114>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204b94:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0204b96:	c02007b7          	lui	a5,0xc0200
ffffffffc0204b9a:	18f6e763          	bltu	a3,a5,ffffffffc0204d28 <init_main+0x240>
ffffffffc0204b9e:	00141797          	auipc	a5,0x141
ffffffffc0204ba2:	67a7b783          	ld	a5,1658(a5) # ffffffffc0346218 <va_pa_offset>
ffffffffc0204ba6:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204ba8:	82b1                	srli	a3,a3,0xc
ffffffffc0204baa:	00141797          	auipc	a5,0x141
ffffffffc0204bae:	6567b783          	ld	a5,1622(a5) # ffffffffc0346200 <npage>
ffffffffc0204bb2:	14f6ff63          	bgeu	a3,a5,ffffffffc0204d10 <init_main+0x228>
    return &pages[PPN(pa) - nbase];
ffffffffc0204bb6:	00004517          	auipc	a0,0x4
ffffffffc0204bba:	25a53503          	ld	a0,602(a0) # ffffffffc0208e10 <nbase>
ffffffffc0204bbe:	8e89                	sub	a3,a3,a0
ffffffffc0204bc0:	069a                	slli	a3,a3,0x6
ffffffffc0204bc2:	00141517          	auipc	a0,0x141
ffffffffc0204bc6:	64653503          	ld	a0,1606(a0) # ffffffffc0346208 <pages>
ffffffffc0204bca:	9536                	add	a0,a0,a3
ffffffffc0204bcc:	4589                	li	a1,2
ffffffffc0204bce:	be2fd0ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    kfree(proc);
ffffffffc0204bd2:	8522                	mv	a0,s0
ffffffffc0204bd4:	9c8fd0ef          	jal	ra,ffffffffc0201d9c <kfree>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc0204bd8:	6e5000ef          	jal	ra,ffffffffc0205abc <schedule>
ffffffffc0204bdc:	bf89                	j	ffffffffc0204b2e <init_main+0x46>
        current->state = PROC_SLEEPING;
ffffffffc0204bde:	01472023          	sw	s4,0(a4)
        current->wait_state = WT_CHILD;
ffffffffc0204be2:	0f372623          	sw	s3,236(a4)
        schedule();
ffffffffc0204be6:	6d7000ef          	jal	ra,ffffffffc0205abc <schedule>
        if (current->flags & PF_EXITING)
ffffffffc0204bea:	00093703          	ld	a4,0(s2)
ffffffffc0204bee:	0b072783          	lw	a5,176(a4)
ffffffffc0204bf2:	8b85                	andi	a5,a5,1
ffffffffc0204bf4:	df9d                	beqz	a5,ffffffffc0204b32 <init_main+0x4a>
            do_exit(-E_KILLED);
ffffffffc0204bf6:	555d                	li	a0,-9
ffffffffc0204bf8:	d37ff0ef          	jal	ra,ffffffffc020492e <do_exit>
        intr_enable();
ffffffffc0204bfc:	d97fb0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0204c00:	bf51                	j	ffffffffc0204b94 <init_main+0xac>
        proc->parent->cptr = proc->optr;
ffffffffc0204c02:	701c                	ld	a5,32(s0)
ffffffffc0204c04:	fbf8                	sd	a4,240(a5)
ffffffffc0204c06:	bfbd                	j	ffffffffc0204b84 <init_main+0x9c>
        intr_disable();
ffffffffc0204c08:	d91fb0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        return 1;
ffffffffc0204c0c:	4585                	li	a1,1
ffffffffc0204c0e:	bf91                	j	ffffffffc0204b62 <init_main+0x7a>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0204c10:	00003517          	auipc	a0,0x3
ffffffffc0204c14:	20050513          	addi	a0,a0,512 # ffffffffc0207e10 <default_pmm_manager+0xaa8>
ffffffffc0204c18:	d80fb0ef          	jal	ra,ffffffffc0200198 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204c1c:	00141797          	auipc	a5,0x141
ffffffffc0204c20:	6147b783          	ld	a5,1556(a5) # ffffffffc0346230 <initproc>
ffffffffc0204c24:	7bf8                	ld	a4,240(a5)
ffffffffc0204c26:	e769                	bnez	a4,ffffffffc0204cf0 <init_main+0x208>
ffffffffc0204c28:	7ff8                	ld	a4,248(a5)
ffffffffc0204c2a:	e379                	bnez	a4,ffffffffc0204cf0 <init_main+0x208>
ffffffffc0204c2c:	1007b703          	ld	a4,256(a5)
ffffffffc0204c30:	e361                	bnez	a4,ffffffffc0204cf0 <init_main+0x208>
    assert(nr_process == 2);
ffffffffc0204c32:	00141697          	auipc	a3,0x141
ffffffffc0204c36:	6066a683          	lw	a3,1542(a3) # ffffffffc0346238 <nr_process>
ffffffffc0204c3a:	4709                	li	a4,2
ffffffffc0204c3c:	08e69a63          	bne	a3,a4,ffffffffc0204cd0 <init_main+0x1e8>
    return listelm->next;
ffffffffc0204c40:	00141697          	auipc	a3,0x141
ffffffffc0204c44:	54868693          	addi	a3,a3,1352 # ffffffffc0346188 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204c48:	6698                	ld	a4,8(a3)
ffffffffc0204c4a:	0c878793          	addi	a5,a5,200
ffffffffc0204c4e:	06f71163          	bne	a4,a5,ffffffffc0204cb0 <init_main+0x1c8>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204c52:	629c                	ld	a5,0(a3)
ffffffffc0204c54:	02f71e63          	bne	a4,a5,ffffffffc0204c90 <init_main+0x1a8>

    cprintf("init check memory pass.\n");
ffffffffc0204c58:	00003517          	auipc	a0,0x3
ffffffffc0204c5c:	2c050513          	addi	a0,a0,704 # ffffffffc0207f18 <default_pmm_manager+0xbb0>
ffffffffc0204c60:	d38fb0ef          	jal	ra,ffffffffc0200198 <cprintf>
    return 0;
}
ffffffffc0204c64:	70e2                	ld	ra,56(sp)
ffffffffc0204c66:	7442                	ld	s0,48(sp)
ffffffffc0204c68:	74a2                	ld	s1,40(sp)
ffffffffc0204c6a:	7902                	ld	s2,32(sp)
ffffffffc0204c6c:	69e2                	ld	s3,24(sp)
ffffffffc0204c6e:	6a42                	ld	s4,16(sp)
ffffffffc0204c70:	6aa2                	ld	s5,8(sp)
ffffffffc0204c72:	4501                	li	a0,0
ffffffffc0204c74:	6121                	addi	sp,sp,64
ffffffffc0204c76:	8082                	ret
        panic("create user_main failed.\n");
ffffffffc0204c78:	00003617          	auipc	a2,0x3
ffffffffc0204c7c:	17860613          	addi	a2,a2,376 # ffffffffc0207df0 <default_pmm_manager+0xa88>
ffffffffc0204c80:	3ef00593          	li	a1,1007
ffffffffc0204c84:	00003517          	auipc	a0,0x3
ffffffffc0204c88:	11450513          	addi	a0,a0,276 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc0204c8c:	fecfb0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204c90:	00003697          	auipc	a3,0x3
ffffffffc0204c94:	25868693          	addi	a3,a3,600 # ffffffffc0207ee8 <default_pmm_manager+0xb80>
ffffffffc0204c98:	00002617          	auipc	a2,0x2
ffffffffc0204c9c:	32060613          	addi	a2,a2,800 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0204ca0:	3fb00593          	li	a1,1019
ffffffffc0204ca4:	00003517          	auipc	a0,0x3
ffffffffc0204ca8:	0f450513          	addi	a0,a0,244 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc0204cac:	fccfb0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204cb0:	00003697          	auipc	a3,0x3
ffffffffc0204cb4:	20868693          	addi	a3,a3,520 # ffffffffc0207eb8 <default_pmm_manager+0xb50>
ffffffffc0204cb8:	00002617          	auipc	a2,0x2
ffffffffc0204cbc:	30060613          	addi	a2,a2,768 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0204cc0:	3fa00593          	li	a1,1018
ffffffffc0204cc4:	00003517          	auipc	a0,0x3
ffffffffc0204cc8:	0d450513          	addi	a0,a0,212 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc0204ccc:	facfb0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(nr_process == 2);
ffffffffc0204cd0:	00003697          	auipc	a3,0x3
ffffffffc0204cd4:	1d868693          	addi	a3,a3,472 # ffffffffc0207ea8 <default_pmm_manager+0xb40>
ffffffffc0204cd8:	00002617          	auipc	a2,0x2
ffffffffc0204cdc:	2e060613          	addi	a2,a2,736 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0204ce0:	3f900593          	li	a1,1017
ffffffffc0204ce4:	00003517          	auipc	a0,0x3
ffffffffc0204ce8:	0b450513          	addi	a0,a0,180 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc0204cec:	f8cfb0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204cf0:	00003697          	auipc	a3,0x3
ffffffffc0204cf4:	16868693          	addi	a3,a3,360 # ffffffffc0207e58 <default_pmm_manager+0xaf0>
ffffffffc0204cf8:	00002617          	auipc	a2,0x2
ffffffffc0204cfc:	2c060613          	addi	a2,a2,704 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0204d00:	3f800593          	li	a1,1016
ffffffffc0204d04:	00003517          	auipc	a0,0x3
ffffffffc0204d08:	09450513          	addi	a0,a0,148 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc0204d0c:	f6cfb0ef          	jal	ra,ffffffffc0200478 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204d10:	00002617          	auipc	a2,0x2
ffffffffc0204d14:	76060613          	addi	a2,a2,1888 # ffffffffc0207470 <default_pmm_manager+0x108>
ffffffffc0204d18:	06900593          	li	a1,105
ffffffffc0204d1c:	00002517          	auipc	a0,0x2
ffffffffc0204d20:	6e450513          	addi	a0,a0,1764 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc0204d24:	f54fb0ef          	jal	ra,ffffffffc0200478 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204d28:	00002617          	auipc	a2,0x2
ffffffffc0204d2c:	72060613          	addi	a2,a2,1824 # ffffffffc0207448 <default_pmm_manager+0xe0>
ffffffffc0204d30:	07700593          	li	a1,119
ffffffffc0204d34:	00002517          	auipc	a0,0x2
ffffffffc0204d38:	6cc50513          	addi	a0,a0,1740 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc0204d3c:	f3cfb0ef          	jal	ra,ffffffffc0200478 <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc0204d40:	00003617          	auipc	a2,0x3
ffffffffc0204d44:	0f860613          	addi	a2,a2,248 # ffffffffc0207e38 <default_pmm_manager+0xad0>
ffffffffc0204d48:	38c00593          	li	a1,908
ffffffffc0204d4c:	00003517          	auipc	a0,0x3
ffffffffc0204d50:	04c50513          	addi	a0,a0,76 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc0204d54:	f24fb0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0204d58 <do_execve>:
{
ffffffffc0204d58:	7171                	addi	sp,sp,-176
ffffffffc0204d5a:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204d5c:	00141d97          	auipc	s11,0x141
ffffffffc0204d60:	4c4d8d93          	addi	s11,s11,1220 # ffffffffc0346220 <current>
ffffffffc0204d64:	000db783          	ld	a5,0(s11)
{
ffffffffc0204d68:	e54e                	sd	s3,136(sp)
ffffffffc0204d6a:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204d6c:	0287b983          	ld	s3,40(a5)
{
ffffffffc0204d70:	e94a                	sd	s2,144(sp)
ffffffffc0204d72:	f8da                	sd	s6,112(sp)
ffffffffc0204d74:	892a                	mv	s2,a0
ffffffffc0204d76:	8b32                	mv	s6,a2
ffffffffc0204d78:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204d7a:	862e                	mv	a2,a1
ffffffffc0204d7c:	4681                	li	a3,0
ffffffffc0204d7e:	85aa                	mv	a1,a0
ffffffffc0204d80:	854e                	mv	a0,s3
{
ffffffffc0204d82:	f506                	sd	ra,168(sp)
ffffffffc0204d84:	f122                	sd	s0,160(sp)
ffffffffc0204d86:	e152                	sd	s4,128(sp)
ffffffffc0204d88:	fcd6                	sd	s5,120(sp)
ffffffffc0204d8a:	f4de                	sd	s7,104(sp)
ffffffffc0204d8c:	f0e2                	sd	s8,96(sp)
ffffffffc0204d8e:	ece6                	sd	s9,88(sp)
ffffffffc0204d90:	e8ea                	sd	s10,80(sp)
ffffffffc0204d92:	f05a                	sd	s6,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204d94:	d1aff0ef          	jal	ra,ffffffffc02042ae <user_mem_check>
ffffffffc0204d98:	48050063          	beqz	a0,ffffffffc0205218 <do_execve+0x4c0>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204d9c:	4641                	li	a2,16
ffffffffc0204d9e:	4581                	li	a1,0
ffffffffc0204da0:	1808                	addi	a0,sp,48
ffffffffc0204da2:	50a010ef          	jal	ra,ffffffffc02062ac <memset>
    memcpy(local_name, name, len);
ffffffffc0204da6:	47bd                	li	a5,15
ffffffffc0204da8:	8626                	mv	a2,s1
ffffffffc0204daa:	1097e263          	bltu	a5,s1,ffffffffc0204eae <do_execve+0x156>
ffffffffc0204dae:	85ca                	mv	a1,s2
ffffffffc0204db0:	1808                	addi	a0,sp,48
ffffffffc0204db2:	680010ef          	jal	ra,ffffffffc0206432 <memcpy>
    if (mm != NULL)
ffffffffc0204db6:	10098363          	beqz	s3,ffffffffc0204ebc <do_execve+0x164>
        cputs("mm != NULL");
ffffffffc0204dba:	00003517          	auipc	a0,0x3
ffffffffc0204dbe:	dde50513          	addi	a0,a0,-546 # ffffffffc0207b98 <default_pmm_manager+0x830>
ffffffffc0204dc2:	c0efb0ef          	jal	ra,ffffffffc02001d0 <cputs>
ffffffffc0204dc6:	00141797          	auipc	a5,0x141
ffffffffc0204dca:	42a7b783          	ld	a5,1066(a5) # ffffffffc03461f0 <boot_pgdir_pa>
ffffffffc0204dce:	577d                	li	a4,-1
ffffffffc0204dd0:	177e                	slli	a4,a4,0x3f
ffffffffc0204dd2:	83b1                	srli	a5,a5,0xc
ffffffffc0204dd4:	8fd9                	or	a5,a5,a4
ffffffffc0204dd6:	18079073          	csrw	satp,a5
ffffffffc0204dda:	0309a783          	lw	a5,48(s3) # ffffffff80000030 <_binary_obj___user_matrix_out_size+0xffffffff7ffe94b0>
ffffffffc0204dde:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204de2:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204de6:	2e070563          	beqz	a4,ffffffffc02050d0 <do_execve+0x378>
        current->mm = NULL;
ffffffffc0204dea:	000db783          	ld	a5,0(s11)
ffffffffc0204dee:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204df2:	d5ffe0ef          	jal	ra,ffffffffc0203b50 <mm_create>
ffffffffc0204df6:	84aa                	mv	s1,a0
ffffffffc0204df8:	20050163          	beqz	a0,ffffffffc0204ffa <do_execve+0x2a2>
    if ((page = alloc_page()) == NULL)
ffffffffc0204dfc:	4505                	li	a0,1
ffffffffc0204dfe:	974fd0ef          	jal	ra,ffffffffc0201f72 <alloc_pages>
ffffffffc0204e02:	40050f63          	beqz	a0,ffffffffc0205220 <do_execve+0x4c8>
    return page - pages + nbase;
ffffffffc0204e06:	00141c97          	auipc	s9,0x141
ffffffffc0204e0a:	402c8c93          	addi	s9,s9,1026 # ffffffffc0346208 <pages>
ffffffffc0204e0e:	000cb683          	ld	a3,0(s9)
ffffffffc0204e12:	00004717          	auipc	a4,0x4
ffffffffc0204e16:	ffe73703          	ld	a4,-2(a4) # ffffffffc0208e10 <nbase>
    return KADDR(page2pa(page));
ffffffffc0204e1a:	00141b97          	auipc	s7,0x141
ffffffffc0204e1e:	3e6b8b93          	addi	s7,s7,998 # ffffffffc0346200 <npage>
    return page - pages + nbase;
ffffffffc0204e22:	40d506b3          	sub	a3,a0,a3
ffffffffc0204e26:	8699                	srai	a3,a3,0x6
ffffffffc0204e28:	96ba                	add	a3,a3,a4
ffffffffc0204e2a:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204e2c:	000bb783          	ld	a5,0(s7)
ffffffffc0204e30:	577d                	li	a4,-1
ffffffffc0204e32:	8331                	srli	a4,a4,0xc
ffffffffc0204e34:	ec3a                	sd	a4,24(sp)
ffffffffc0204e36:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204e38:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204e3a:	3ef77763          	bgeu	a4,a5,ffffffffc0205228 <do_execve+0x4d0>
ffffffffc0204e3e:	00141a97          	auipc	s5,0x141
ffffffffc0204e42:	3daa8a93          	addi	s5,s5,986 # ffffffffc0346218 <va_pa_offset>
ffffffffc0204e46:	000ab983          	ld	s3,0(s5)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204e4a:	6605                	lui	a2,0x1
ffffffffc0204e4c:	00141597          	auipc	a1,0x141
ffffffffc0204e50:	3ac5b583          	ld	a1,940(a1) # ffffffffc03461f8 <boot_pgdir_va>
ffffffffc0204e54:	99b6                	add	s3,s3,a3
ffffffffc0204e56:	854e                	mv	a0,s3
ffffffffc0204e58:	5da010ef          	jal	ra,ffffffffc0206432 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204e5c:	7682                	ld	a3,32(sp)
ffffffffc0204e5e:	464c47b7          	lui	a5,0x464c4
ffffffffc0204e62:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_matrix_out_size+0x464ad9ff>
ffffffffc0204e66:	4298                	lw	a4,0(a3)
    mm->pgdir = pgdir;
ffffffffc0204e68:	0134bc23          	sd	s3,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204e6c:	06f70863          	beq	a4,a5,ffffffffc0204edc <do_execve+0x184>
        ret = -E_INVAL_ELF;
ffffffffc0204e70:	5961                	li	s2,-8
    return pa2page(PADDR(kva));
ffffffffc0204e72:	c02007b7          	lui	a5,0xc0200
ffffffffc0204e76:	3cf9e563          	bltu	s3,a5,ffffffffc0205240 <do_execve+0x4e8>
ffffffffc0204e7a:	000ab683          	ld	a3,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0204e7e:	000bb783          	ld	a5,0(s7)
    return pa2page(PADDR(kva));
ffffffffc0204e82:	40d989b3          	sub	s3,s3,a3
    if (PPN(pa) >= npage)
ffffffffc0204e86:	00c9d993          	srli	s3,s3,0xc
ffffffffc0204e8a:	3cf9f863          	bgeu	s3,a5,ffffffffc020525a <do_execve+0x502>
    return &pages[PPN(pa) - nbase];
ffffffffc0204e8e:	67c2                	ld	a5,16(sp)
ffffffffc0204e90:	000cb503          	ld	a0,0(s9)
    free_page(kva2page(mm->pgdir));
ffffffffc0204e94:	4585                	li	a1,1
ffffffffc0204e96:	40f989b3          	sub	s3,s3,a5
ffffffffc0204e9a:	099a                	slli	s3,s3,0x6
ffffffffc0204e9c:	954e                	add	a0,a0,s3
ffffffffc0204e9e:	912fd0ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    mm_destroy(mm);
ffffffffc0204ea2:	8526                	mv	a0,s1
ffffffffc0204ea4:	dadfe0ef          	jal	ra,ffffffffc0203c50 <mm_destroy>
    do_exit(ret);
ffffffffc0204ea8:	854a                	mv	a0,s2
ffffffffc0204eaa:	a85ff0ef          	jal	ra,ffffffffc020492e <do_exit>
    memcpy(local_name, name, len);
ffffffffc0204eae:	463d                	li	a2,15
ffffffffc0204eb0:	85ca                	mv	a1,s2
ffffffffc0204eb2:	1808                	addi	a0,sp,48
ffffffffc0204eb4:	57e010ef          	jal	ra,ffffffffc0206432 <memcpy>
    if (mm != NULL)
ffffffffc0204eb8:	f00991e3          	bnez	s3,ffffffffc0204dba <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204ebc:	000db783          	ld	a5,0(s11)
ffffffffc0204ec0:	779c                	ld	a5,40(a5)
ffffffffc0204ec2:	db85                	beqz	a5,ffffffffc0204df2 <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204ec4:	00003617          	auipc	a2,0x3
ffffffffc0204ec8:	07460613          	addi	a2,a2,116 # ffffffffc0207f38 <default_pmm_manager+0xbd0>
ffffffffc0204ecc:	27500593          	li	a1,629
ffffffffc0204ed0:	00003517          	auipc	a0,0x3
ffffffffc0204ed4:	ec850513          	addi	a0,a0,-312 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc0204ed8:	da0fb0ef          	jal	ra,ffffffffc0200478 <__panic>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204edc:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204ee0:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204ee4:	00371793          	slli	a5,a4,0x3
ffffffffc0204ee8:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204eea:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204eec:	078e                	slli	a5,a5,0x3
ffffffffc0204eee:	97ce                	add	a5,a5,s3
ffffffffc0204ef0:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204ef2:	00f9fc63          	bgeu	s3,a5,ffffffffc0204f0a <do_execve+0x1b2>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204ef6:	0009a783          	lw	a5,0(s3)
ffffffffc0204efa:	4705                	li	a4,1
ffffffffc0204efc:	10e78163          	beq	a5,a4,ffffffffc0204ffe <do_execve+0x2a6>
    for (; ph < ph_end; ph++)
ffffffffc0204f00:	77a2                	ld	a5,40(sp)
ffffffffc0204f02:	03898993          	addi	s3,s3,56
ffffffffc0204f06:	fef9e8e3          	bltu	s3,a5,ffffffffc0204ef6 <do_execve+0x19e>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204f0a:	4701                	li	a4,0
ffffffffc0204f0c:	46ad                	li	a3,11
ffffffffc0204f0e:	00100637          	lui	a2,0x100
ffffffffc0204f12:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204f16:	8526                	mv	a0,s1
ffffffffc0204f18:	d8bfe0ef          	jal	ra,ffffffffc0203ca2 <mm_map>
ffffffffc0204f1c:	892a                	mv	s2,a0
ffffffffc0204f1e:	1a051363          	bnez	a0,ffffffffc02050c4 <do_execve+0x36c>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204f22:	6c88                	ld	a0,24(s1)
ffffffffc0204f24:	467d                	li	a2,31
ffffffffc0204f26:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204f2a:	b41fe0ef          	jal	ra,ffffffffc0203a6a <pgdir_alloc_page>
ffffffffc0204f2e:	3a050e63          	beqz	a0,ffffffffc02052ea <do_execve+0x592>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204f32:	6c88                	ld	a0,24(s1)
ffffffffc0204f34:	467d                	li	a2,31
ffffffffc0204f36:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204f3a:	b31fe0ef          	jal	ra,ffffffffc0203a6a <pgdir_alloc_page>
ffffffffc0204f3e:	38050663          	beqz	a0,ffffffffc02052ca <do_execve+0x572>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204f42:	6c88                	ld	a0,24(s1)
ffffffffc0204f44:	467d                	li	a2,31
ffffffffc0204f46:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204f4a:	b21fe0ef          	jal	ra,ffffffffc0203a6a <pgdir_alloc_page>
ffffffffc0204f4e:	34050e63          	beqz	a0,ffffffffc02052aa <do_execve+0x552>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204f52:	6c88                	ld	a0,24(s1)
ffffffffc0204f54:	467d                	li	a2,31
ffffffffc0204f56:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204f5a:	b11fe0ef          	jal	ra,ffffffffc0203a6a <pgdir_alloc_page>
ffffffffc0204f5e:	32050663          	beqz	a0,ffffffffc020528a <do_execve+0x532>
    mm->mm_count += 1;
ffffffffc0204f62:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204f64:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204f68:	6c94                	ld	a3,24(s1)
ffffffffc0204f6a:	2785                	addiw	a5,a5,1
ffffffffc0204f6c:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204f6e:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204f70:	c02007b7          	lui	a5,0xc0200
ffffffffc0204f74:	2ef6ef63          	bltu	a3,a5,ffffffffc0205272 <do_execve+0x51a>
ffffffffc0204f78:	000ab783          	ld	a5,0(s5)
ffffffffc0204f7c:	577d                	li	a4,-1
ffffffffc0204f7e:	177e                	slli	a4,a4,0x3f
ffffffffc0204f80:	8e9d                	sub	a3,a3,a5
ffffffffc0204f82:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204f86:	f654                	sd	a3,168(a2)
ffffffffc0204f88:	8fd9                	or	a5,a5,a4
ffffffffc0204f8a:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204f8e:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204f90:	4581                	li	a1,0
ffffffffc0204f92:	12000613          	li	a2,288
ffffffffc0204f96:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204f98:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204f9c:	310010ef          	jal	ra,ffffffffc02062ac <memset>
    tf->epc = elf->e_entry;
ffffffffc0204fa0:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204fa2:	000db983          	ld	s3,0(s11)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204fa6:	edf4f493          	andi	s1,s1,-289
    tf->epc = elf->e_entry;
ffffffffc0204faa:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204fac:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204fae:	0b498993          	addi	s3,s3,180
    tf->gpr.sp = USTACKTOP;
ffffffffc0204fb2:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204fb4:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204fb8:	4641                	li	a2,16
ffffffffc0204fba:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0204fbc:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0204fbe:	10e43423          	sd	a4,264(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204fc2:	10943023          	sd	s1,256(s0)
    tf->gpr.a0 = 0;
ffffffffc0204fc6:	04043823          	sd	zero,80(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204fca:	854e                	mv	a0,s3
ffffffffc0204fcc:	2e0010ef          	jal	ra,ffffffffc02062ac <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204fd0:	463d                	li	a2,15
ffffffffc0204fd2:	180c                	addi	a1,sp,48
ffffffffc0204fd4:	854e                	mv	a0,s3
ffffffffc0204fd6:	45c010ef          	jal	ra,ffffffffc0206432 <memcpy>
}
ffffffffc0204fda:	70aa                	ld	ra,168(sp)
ffffffffc0204fdc:	740a                	ld	s0,160(sp)
ffffffffc0204fde:	64ea                	ld	s1,152(sp)
ffffffffc0204fe0:	69aa                	ld	s3,136(sp)
ffffffffc0204fe2:	6a0a                	ld	s4,128(sp)
ffffffffc0204fe4:	7ae6                	ld	s5,120(sp)
ffffffffc0204fe6:	7b46                	ld	s6,112(sp)
ffffffffc0204fe8:	7ba6                	ld	s7,104(sp)
ffffffffc0204fea:	7c06                	ld	s8,96(sp)
ffffffffc0204fec:	6ce6                	ld	s9,88(sp)
ffffffffc0204fee:	6d46                	ld	s10,80(sp)
ffffffffc0204ff0:	6da6                	ld	s11,72(sp)
ffffffffc0204ff2:	854a                	mv	a0,s2
ffffffffc0204ff4:	694a                	ld	s2,144(sp)
ffffffffc0204ff6:	614d                	addi	sp,sp,176
ffffffffc0204ff8:	8082                	ret
    int ret = -E_NO_MEM;
ffffffffc0204ffa:	5971                	li	s2,-4
ffffffffc0204ffc:	b575                	j	ffffffffc0204ea8 <do_execve+0x150>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204ffe:	0289b603          	ld	a2,40(s3)
ffffffffc0205002:	0209b783          	ld	a5,32(s3)
ffffffffc0205006:	20f66f63          	bltu	a2,a5,ffffffffc0205224 <do_execve+0x4cc>
        if (ph->p_flags & ELF_PF_X)
ffffffffc020500a:	0049a783          	lw	a5,4(s3)
ffffffffc020500e:	4689                	li	a3,2
ffffffffc0205010:	0017f713          	andi	a4,a5,1
ffffffffc0205014:	c319                	beqz	a4,ffffffffc020501a <do_execve+0x2c2>
ffffffffc0205016:	4699                	li	a3,6
            vm_flags |= VM_EXEC;
ffffffffc0205018:	4711                	li	a4,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc020501a:	0027f593          	andi	a1,a5,2
ffffffffc020501e:	10058963          	beqz	a1,ffffffffc0205130 <do_execve+0x3d8>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0205022:	8b91                	andi	a5,a5,4
ffffffffc0205024:	0e079d63          	bnez	a5,ffffffffc020511e <do_execve+0x3c6>
ffffffffc0205028:	45e5                	li	a1,25
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc020502a:	4d45                	li	s10,17
        if (vm_flags & VM_WRITE)
ffffffffc020502c:	0026f793          	andi	a5,a3,2
ffffffffc0205030:	c399                	beqz	a5,ffffffffc0205036 <do_execve+0x2de>
ffffffffc0205032:	45fd                	li	a1,31
            perm |= (PTE_W | PTE_R);
ffffffffc0205034:	4d5d                	li	s10,23
        if (vm_flags & VM_EXEC)
ffffffffc0205036:	c311                	beqz	a4,ffffffffc020503a <do_execve+0x2e2>
            perm |= PTE_X;
ffffffffc0205038:	8d2e                	mv	s10,a1
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc020503a:	0109b583          	ld	a1,16(s3)
ffffffffc020503e:	4701                	li	a4,0
ffffffffc0205040:	8526                	mv	a0,s1
ffffffffc0205042:	c61fe0ef          	jal	ra,ffffffffc0203ca2 <mm_map>
ffffffffc0205046:	892a                	mv	s2,a0
ffffffffc0205048:	ed35                	bnez	a0,ffffffffc02050c4 <do_execve+0x36c>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc020504a:	0109bc03          	ld	s8,16(s3)
ffffffffc020504e:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0205050:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0205054:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0205058:	00fc7b33          	and	s6,s8,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc020505c:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc020505e:	9a62                	add	s4,s4,s8
        unsigned char *from = binary + ph->p_offset;
ffffffffc0205060:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0205062:	054c6963          	bltu	s8,s4,ffffffffc02050b4 <do_execve+0x35c>
ffffffffc0205066:	aa5d                	j	ffffffffc020521c <do_execve+0x4c4>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0205068:	6785                	lui	a5,0x1
ffffffffc020506a:	416c0533          	sub	a0,s8,s6
ffffffffc020506e:	9b3e                	add	s6,s6,a5
ffffffffc0205070:	418b0633          	sub	a2,s6,s8
            if (end < la)
ffffffffc0205074:	016a7463          	bgeu	s4,s6,ffffffffc020507c <do_execve+0x324>
                size -= la - end;
ffffffffc0205078:	418a0633          	sub	a2,s4,s8
    return page - pages + nbase;
ffffffffc020507c:	000cb683          	ld	a3,0(s9)
ffffffffc0205080:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0205082:	000bb583          	ld	a1,0(s7)
    return page - pages + nbase;
ffffffffc0205086:	40d406b3          	sub	a3,s0,a3
ffffffffc020508a:	8699                	srai	a3,a3,0x6
ffffffffc020508c:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020508e:	67e2                	ld	a5,24(sp)
ffffffffc0205090:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0205094:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0205096:	18b87963          	bgeu	a6,a1,ffffffffc0205228 <do_execve+0x4d0>
ffffffffc020509a:	000ab803          	ld	a6,0(s5)
            memcpy(page2kva(page) + off, from, size);
ffffffffc020509e:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc02050a0:	9c32                	add	s8,s8,a2
ffffffffc02050a2:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc02050a4:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc02050a6:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc02050a8:	38a010ef          	jal	ra,ffffffffc0206432 <memcpy>
            start += size, from += size;
ffffffffc02050ac:	6622                	ld	a2,8(sp)
ffffffffc02050ae:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc02050b0:	094c7563          	bgeu	s8,s4,ffffffffc020513a <do_execve+0x3e2>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc02050b4:	6c88                	ld	a0,24(s1)
ffffffffc02050b6:	866a                	mv	a2,s10
ffffffffc02050b8:	85da                	mv	a1,s6
ffffffffc02050ba:	9b1fe0ef          	jal	ra,ffffffffc0203a6a <pgdir_alloc_page>
ffffffffc02050be:	842a                	mv	s0,a0
ffffffffc02050c0:	f545                	bnez	a0,ffffffffc0205068 <do_execve+0x310>
        ret = -E_NO_MEM;
ffffffffc02050c2:	5971                	li	s2,-4
    exit_mmap(mm);
ffffffffc02050c4:	8526                	mv	a0,s1
ffffffffc02050c6:	d55fe0ef          	jal	ra,ffffffffc0203e1a <exit_mmap>
    return pa2page(PADDR(kva));
ffffffffc02050ca:	0184b983          	ld	s3,24(s1)
ffffffffc02050ce:	b355                	j	ffffffffc0204e72 <do_execve+0x11a>
            exit_mmap(mm);
ffffffffc02050d0:	854e                	mv	a0,s3
ffffffffc02050d2:	d49fe0ef          	jal	ra,ffffffffc0203e1a <exit_mmap>
ffffffffc02050d6:	0189b683          	ld	a3,24(s3)
ffffffffc02050da:	c02007b7          	lui	a5,0xc0200
ffffffffc02050de:	16f6e263          	bltu	a3,a5,ffffffffc0205242 <do_execve+0x4ea>
ffffffffc02050e2:	00141797          	auipc	a5,0x141
ffffffffc02050e6:	1367b783          	ld	a5,310(a5) # ffffffffc0346218 <va_pa_offset>
ffffffffc02050ea:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02050ec:	82b1                	srli	a3,a3,0xc
ffffffffc02050ee:	00141797          	auipc	a5,0x141
ffffffffc02050f2:	1127b783          	ld	a5,274(a5) # ffffffffc0346200 <npage>
ffffffffc02050f6:	16f6f263          	bgeu	a3,a5,ffffffffc020525a <do_execve+0x502>
    return &pages[PPN(pa) - nbase];
ffffffffc02050fa:	00004517          	auipc	a0,0x4
ffffffffc02050fe:	d1653503          	ld	a0,-746(a0) # ffffffffc0208e10 <nbase>
ffffffffc0205102:	8e89                	sub	a3,a3,a0
ffffffffc0205104:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0205106:	00141517          	auipc	a0,0x141
ffffffffc020510a:	10253503          	ld	a0,258(a0) # ffffffffc0346208 <pages>
ffffffffc020510e:	9536                	add	a0,a0,a3
ffffffffc0205110:	4585                	li	a1,1
ffffffffc0205112:	e9ffc0ef          	jal	ra,ffffffffc0201fb0 <free_pages>
            mm_destroy(mm);
ffffffffc0205116:	854e                	mv	a0,s3
ffffffffc0205118:	b39fe0ef          	jal	ra,ffffffffc0203c50 <mm_destroy>
ffffffffc020511c:	b1f9                	j	ffffffffc0204dea <do_execve+0x92>
            vm_flags |= VM_READ;
ffffffffc020511e:	0016e793          	ori	a5,a3,1
        if (vm_flags & VM_READ)
ffffffffc0205122:	0046f713          	andi	a4,a3,4
            vm_flags |= VM_READ;
ffffffffc0205126:	45ed                	li	a1,27
ffffffffc0205128:	0007869b          	sext.w	a3,a5
            perm |= PTE_R;
ffffffffc020512c:	4d4d                	li	s10,19
ffffffffc020512e:	bdfd                	j	ffffffffc020502c <do_execve+0x2d4>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0205130:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0205132:	86ba                	mv	a3,a4
        if (ph->p_flags & ELF_PF_R)
ffffffffc0205134:	ee078ae3          	beqz	a5,ffffffffc0205028 <do_execve+0x2d0>
ffffffffc0205138:	b7dd                	j	ffffffffc020511e <do_execve+0x3c6>
        end = ph->p_va + ph->p_memsz;
ffffffffc020513a:	0109b683          	ld	a3,16(s3)
ffffffffc020513e:	0289b903          	ld	s2,40(s3)
ffffffffc0205142:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0205144:	076c7a63          	bgeu	s8,s6,ffffffffc02051b8 <do_execve+0x460>
            if (start == end)
ffffffffc0205148:	db890ce3          	beq	s2,s8,ffffffffc0204f00 <do_execve+0x1a8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc020514c:	6785                	lui	a5,0x1
ffffffffc020514e:	00fc0533          	add	a0,s8,a5
ffffffffc0205152:	41650533          	sub	a0,a0,s6
            if (end < la)
ffffffffc0205156:	0b696d63          	bltu	s2,s6,ffffffffc0205210 <do_execve+0x4b8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc020515a:	418b0633          	sub	a2,s6,s8
ffffffffc020515e:	8c5a                	mv	s8,s6
    return page - pages + nbase;
ffffffffc0205160:	000cb683          	ld	a3,0(s9)
ffffffffc0205164:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0205166:	000bb583          	ld	a1,0(s7)
    return page - pages + nbase;
ffffffffc020516a:	40d406b3          	sub	a3,s0,a3
ffffffffc020516e:	8699                	srai	a3,a3,0x6
ffffffffc0205170:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0205172:	67e2                	ld	a5,24(sp)
ffffffffc0205174:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0205178:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020517a:	0ab87763          	bgeu	a6,a1,ffffffffc0205228 <do_execve+0x4d0>
ffffffffc020517e:	000ab803          	ld	a6,0(s5)
            memset(page2kva(page) + off, 0, size);
ffffffffc0205182:	4581                	li	a1,0
ffffffffc0205184:	96c2                	add	a3,a3,a6
ffffffffc0205186:	9536                	add	a0,a0,a3
ffffffffc0205188:	124010ef          	jal	ra,ffffffffc02062ac <memset>
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc020518c:	03697463          	bgeu	s2,s6,ffffffffc02051b4 <do_execve+0x45c>
ffffffffc0205190:	d78908e3          	beq	s2,s8,ffffffffc0204f00 <do_execve+0x1a8>
ffffffffc0205194:	00003697          	auipc	a3,0x3
ffffffffc0205198:	dcc68693          	addi	a3,a3,-564 # ffffffffc0207f60 <default_pmm_manager+0xbf8>
ffffffffc020519c:	00002617          	auipc	a2,0x2
ffffffffc02051a0:	e1c60613          	addi	a2,a2,-484 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02051a4:	2de00593          	li	a1,734
ffffffffc02051a8:	00003517          	auipc	a0,0x3
ffffffffc02051ac:	bf050513          	addi	a0,a0,-1040 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc02051b0:	ac8fb0ef          	jal	ra,ffffffffc0200478 <__panic>
ffffffffc02051b4:	ff8b10e3          	bne	s6,s8,ffffffffc0205194 <do_execve+0x43c>
        while (start < end)
ffffffffc02051b8:	d52c74e3          	bgeu	s8,s2,ffffffffc0204f00 <do_execve+0x1a8>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc02051bc:	6c88                	ld	a0,24(s1)
ffffffffc02051be:	866a                	mv	a2,s10
ffffffffc02051c0:	85da                	mv	a1,s6
ffffffffc02051c2:	8a9fe0ef          	jal	ra,ffffffffc0203a6a <pgdir_alloc_page>
ffffffffc02051c6:	842a                	mv	s0,a0
ffffffffc02051c8:	ee050de3          	beqz	a0,ffffffffc02050c2 <do_execve+0x36a>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc02051cc:	6785                	lui	a5,0x1
ffffffffc02051ce:	416c0533          	sub	a0,s8,s6
ffffffffc02051d2:	9b3e                	add	s6,s6,a5
ffffffffc02051d4:	418b0633          	sub	a2,s6,s8
            if (end < la)
ffffffffc02051d8:	01697463          	bgeu	s2,s6,ffffffffc02051e0 <do_execve+0x488>
                size -= la - end;
ffffffffc02051dc:	41890633          	sub	a2,s2,s8
    return page - pages + nbase;
ffffffffc02051e0:	000cb683          	ld	a3,0(s9)
ffffffffc02051e4:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc02051e6:	000bb583          	ld	a1,0(s7)
    return page - pages + nbase;
ffffffffc02051ea:	40d406b3          	sub	a3,s0,a3
ffffffffc02051ee:	8699                	srai	a3,a3,0x6
ffffffffc02051f0:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02051f2:	67e2                	ld	a5,24(sp)
ffffffffc02051f4:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc02051f8:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02051fa:	02b87763          	bgeu	a6,a1,ffffffffc0205228 <do_execve+0x4d0>
ffffffffc02051fe:	000ab803          	ld	a6,0(s5)
            memset(page2kva(page) + off, 0, size);
ffffffffc0205202:	4581                	li	a1,0
            start += size;
ffffffffc0205204:	9c32                	add	s8,s8,a2
ffffffffc0205206:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0205208:	9536                	add	a0,a0,a3
ffffffffc020520a:	0a2010ef          	jal	ra,ffffffffc02062ac <memset>
ffffffffc020520e:	b76d                	j	ffffffffc02051b8 <do_execve+0x460>
                size -= la - end;
ffffffffc0205210:	41890633          	sub	a2,s2,s8
ffffffffc0205214:	8c4a                	mv	s8,s2
ffffffffc0205216:	b7a9                	j	ffffffffc0205160 <do_execve+0x408>
        return -E_INVAL;
ffffffffc0205218:	5975                	li	s2,-3
ffffffffc020521a:	b3c1                	j	ffffffffc0204fda <do_execve+0x282>
        while (start < end)
ffffffffc020521c:	86e2                	mv	a3,s8
ffffffffc020521e:	b705                	j	ffffffffc020513e <do_execve+0x3e6>
    int ret = -E_NO_MEM;
ffffffffc0205220:	5971                	li	s2,-4
ffffffffc0205222:	b141                	j	ffffffffc0204ea2 <do_execve+0x14a>
            ret = -E_INVAL_ELF;
ffffffffc0205224:	5961                	li	s2,-8
ffffffffc0205226:	bd79                	j	ffffffffc02050c4 <do_execve+0x36c>
ffffffffc0205228:	00002617          	auipc	a2,0x2
ffffffffc020522c:	1b060613          	addi	a2,a2,432 # ffffffffc02073d8 <default_pmm_manager+0x70>
ffffffffc0205230:	07100593          	li	a1,113
ffffffffc0205234:	00002517          	auipc	a0,0x2
ffffffffc0205238:	1cc50513          	addi	a0,a0,460 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc020523c:	a3cfb0ef          	jal	ra,ffffffffc0200478 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0205240:	86ce                	mv	a3,s3
ffffffffc0205242:	00002617          	auipc	a2,0x2
ffffffffc0205246:	20660613          	addi	a2,a2,518 # ffffffffc0207448 <default_pmm_manager+0xe0>
ffffffffc020524a:	07700593          	li	a1,119
ffffffffc020524e:	00002517          	auipc	a0,0x2
ffffffffc0205252:	1b250513          	addi	a0,a0,434 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc0205256:	a22fb0ef          	jal	ra,ffffffffc0200478 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020525a:	00002617          	auipc	a2,0x2
ffffffffc020525e:	21660613          	addi	a2,a2,534 # ffffffffc0207470 <default_pmm_manager+0x108>
ffffffffc0205262:	06900593          	li	a1,105
ffffffffc0205266:	00002517          	auipc	a0,0x2
ffffffffc020526a:	19a50513          	addi	a0,a0,410 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc020526e:	a0afb0ef          	jal	ra,ffffffffc0200478 <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0205272:	00002617          	auipc	a2,0x2
ffffffffc0205276:	1d660613          	addi	a2,a2,470 # ffffffffc0207448 <default_pmm_manager+0xe0>
ffffffffc020527a:	2fd00593          	li	a1,765
ffffffffc020527e:	00003517          	auipc	a0,0x3
ffffffffc0205282:	b1a50513          	addi	a0,a0,-1254 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc0205286:	9f2fb0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc020528a:	00003697          	auipc	a3,0x3
ffffffffc020528e:	dee68693          	addi	a3,a3,-530 # ffffffffc0208078 <default_pmm_manager+0xd10>
ffffffffc0205292:	00002617          	auipc	a2,0x2
ffffffffc0205296:	d2660613          	addi	a2,a2,-730 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020529a:	2f800593          	li	a1,760
ffffffffc020529e:	00003517          	auipc	a0,0x3
ffffffffc02052a2:	afa50513          	addi	a0,a0,-1286 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc02052a6:	9d2fb0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc02052aa:	00003697          	auipc	a3,0x3
ffffffffc02052ae:	d8668693          	addi	a3,a3,-634 # ffffffffc0208030 <default_pmm_manager+0xcc8>
ffffffffc02052b2:	00002617          	auipc	a2,0x2
ffffffffc02052b6:	d0660613          	addi	a2,a2,-762 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02052ba:	2f700593          	li	a1,759
ffffffffc02052be:	00003517          	auipc	a0,0x3
ffffffffc02052c2:	ada50513          	addi	a0,a0,-1318 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc02052c6:	9b2fb0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc02052ca:	00003697          	auipc	a3,0x3
ffffffffc02052ce:	d1e68693          	addi	a3,a3,-738 # ffffffffc0207fe8 <default_pmm_manager+0xc80>
ffffffffc02052d2:	00002617          	auipc	a2,0x2
ffffffffc02052d6:	ce660613          	addi	a2,a2,-794 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02052da:	2f600593          	li	a1,758
ffffffffc02052de:	00003517          	auipc	a0,0x3
ffffffffc02052e2:	aba50513          	addi	a0,a0,-1350 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc02052e6:	992fb0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc02052ea:	00003697          	auipc	a3,0x3
ffffffffc02052ee:	cb668693          	addi	a3,a3,-842 # ffffffffc0207fa0 <default_pmm_manager+0xc38>
ffffffffc02052f2:	00002617          	auipc	a2,0x2
ffffffffc02052f6:	cc660613          	addi	a2,a2,-826 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02052fa:	2f500593          	li	a1,757
ffffffffc02052fe:	00003517          	auipc	a0,0x3
ffffffffc0205302:	a9a50513          	addi	a0,a0,-1382 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc0205306:	972fb0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc020530a <user_main>:
{
ffffffffc020530a:	1101                	addi	sp,sp,-32
ffffffffc020530c:	e04a                	sd	s2,0(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc020530e:	00141917          	auipc	s2,0x141
ffffffffc0205312:	f1290913          	addi	s2,s2,-238 # ffffffffc0346220 <current>
ffffffffc0205316:	00093783          	ld	a5,0(s2)
ffffffffc020531a:	00003617          	auipc	a2,0x3
ffffffffc020531e:	da660613          	addi	a2,a2,-602 # ffffffffc02080c0 <default_pmm_manager+0xd58>
ffffffffc0205322:	00003517          	auipc	a0,0x3
ffffffffc0205326:	dae50513          	addi	a0,a0,-594 # ffffffffc02080d0 <default_pmm_manager+0xd68>
ffffffffc020532a:	43cc                	lw	a1,4(a5)
{
ffffffffc020532c:	ec06                	sd	ra,24(sp)
ffffffffc020532e:	e822                	sd	s0,16(sp)
ffffffffc0205330:	e426                	sd	s1,8(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0205332:	e67fa0ef          	jal	ra,ffffffffc0200198 <cprintf>
    size_t len = strlen(name);
ffffffffc0205336:	00003517          	auipc	a0,0x3
ffffffffc020533a:	d8a50513          	addi	a0,a0,-630 # ffffffffc02080c0 <default_pmm_manager+0xd58>
ffffffffc020533e:	6c9000ef          	jal	ra,ffffffffc0206206 <strlen>
    struct trapframe *old_tf = current->tf;
ffffffffc0205342:	00093783          	ld	a5,0(s2)
    size_t len = strlen(name);
ffffffffc0205346:	84aa                	mv	s1,a0
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0205348:	12000613          	li	a2,288
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc020534c:	6b80                	ld	s0,16(a5)
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc020534e:	73cc                	ld	a1,160(a5)
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0205350:	6789                	lui	a5,0x2
ffffffffc0205352:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0xf4c8>
ffffffffc0205356:	943e                	add	s0,s0,a5
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0205358:	8522                	mv	a0,s0
ffffffffc020535a:	0d8010ef          	jal	ra,ffffffffc0206432 <memcpy>
    current->tf = new_tf;
ffffffffc020535e:	00093783          	ld	a5,0(s2)
    ret = do_execve(name, len, binary, size);
ffffffffc0205362:	3fe0e697          	auipc	a3,0x3fe0e
ffffffffc0205366:	99668693          	addi	a3,a3,-1642 # 12cf8 <_binary_obj___user_priority_out_size>
ffffffffc020536a:	000d0617          	auipc	a2,0xd0
ffffffffc020536e:	43660613          	addi	a2,a2,1078 # ffffffffc02d57a0 <_binary_obj___user_priority_out_start>
    current->tf = new_tf;
ffffffffc0205372:	f3c0                	sd	s0,160(a5)
    ret = do_execve(name, len, binary, size);
ffffffffc0205374:	85a6                	mv	a1,s1
ffffffffc0205376:	00003517          	auipc	a0,0x3
ffffffffc020537a:	d4a50513          	addi	a0,a0,-694 # ffffffffc02080c0 <default_pmm_manager+0xd58>
ffffffffc020537e:	9dbff0ef          	jal	ra,ffffffffc0204d58 <do_execve>
    asm volatile(
ffffffffc0205382:	8122                	mv	sp,s0
ffffffffc0205384:	bd1fb06f          	j	ffffffffc0200f54 <__trapret>
    panic("user_main execve failed.\n");
ffffffffc0205388:	00003617          	auipc	a2,0x3
ffffffffc020538c:	d7060613          	addi	a2,a2,-656 # ffffffffc02080f8 <default_pmm_manager+0xd90>
ffffffffc0205390:	3e200593          	li	a1,994
ffffffffc0205394:	00003517          	auipc	a0,0x3
ffffffffc0205398:	a0450513          	addi	a0,a0,-1532 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc020539c:	8dcfb0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc02053a0 <do_yield>:
    current->need_resched = 1;
ffffffffc02053a0:	00141797          	auipc	a5,0x141
ffffffffc02053a4:	e807b783          	ld	a5,-384(a5) # ffffffffc0346220 <current>
ffffffffc02053a8:	4705                	li	a4,1
ffffffffc02053aa:	ef98                	sd	a4,24(a5)
}
ffffffffc02053ac:	4501                	li	a0,0
ffffffffc02053ae:	8082                	ret

ffffffffc02053b0 <do_wait>:
{
ffffffffc02053b0:	711d                	addi	sp,sp,-96
ffffffffc02053b2:	e4a6                	sd	s1,72(sp)
ffffffffc02053b4:	fc4e                	sd	s3,56(sp)
ffffffffc02053b6:	ec86                	sd	ra,88(sp)
ffffffffc02053b8:	e8a2                	sd	s0,80(sp)
ffffffffc02053ba:	e0ca                	sd	s2,64(sp)
ffffffffc02053bc:	f852                	sd	s4,48(sp)
ffffffffc02053be:	f456                	sd	s5,40(sp)
ffffffffc02053c0:	f05a                	sd	s6,32(sp)
ffffffffc02053c2:	ec5e                	sd	s7,24(sp)
ffffffffc02053c4:	e862                	sd	s8,16(sp)
ffffffffc02053c6:	e466                	sd	s9,8(sp)
ffffffffc02053c8:	e06a                	sd	s10,0(sp)
ffffffffc02053ca:	89ae                	mv	s3,a1
ffffffffc02053cc:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc02053ce:	cd81                	beqz	a1,ffffffffc02053e6 <do_wait+0x36>
    struct mm_struct *mm = current->mm;
ffffffffc02053d0:	00141797          	auipc	a5,0x141
ffffffffc02053d4:	e507b783          	ld	a5,-432(a5) # ffffffffc0346220 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc02053d8:	7788                	ld	a0,40(a5)
ffffffffc02053da:	4685                	li	a3,1
ffffffffc02053dc:	4611                	li	a2,4
ffffffffc02053de:	ed1fe0ef          	jal	ra,ffffffffc02042ae <user_mem_check>
ffffffffc02053e2:	16050e63          	beqz	a0,ffffffffc020555e <do_wait+0x1ae>
    if (0 < pid && pid < MAX_PID)
ffffffffc02053e6:	6a09                	lui	s4,0x2
        current->wait_state = WT_CHILD;
ffffffffc02053e8:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc02053ec:	00048c1b          	sext.w	s8,s1
ffffffffc02053f0:	fff48b1b          	addiw	s6,s1,-1
        proc = current->cptr;
ffffffffc02053f4:	00141d17          	auipc	s10,0x141
ffffffffc02053f8:	e2cd0d13          	addi	s10,s10,-468 # ffffffffc0346220 <current>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02053fc:	4c8d                	li	s9,3
    if (0 < pid && pid < MAX_PID)
ffffffffc02053fe:	1a79                	addi	s4,s4,-2
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0205400:	0013db97          	auipc	s7,0x13d
ffffffffc0205404:	d88b8b93          	addi	s7,s7,-632 # ffffffffc0342188 <hash_list>
        current->state = PROC_SLEEPING;
ffffffffc0205408:	4a85                	li	s5,1
        current->wait_state = WT_CHILD;
ffffffffc020540a:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc020540c:	ccad                	beqz	s1,ffffffffc0205486 <do_wait+0xd6>
    if (0 < pid && pid < MAX_PID)
ffffffffc020540e:	036a6463          	bltu	s4,s6,ffffffffc0205436 <do_wait+0x86>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0205412:	45a9                	li	a1,10
ffffffffc0205414:	8562                	mv	a0,s8
ffffffffc0205416:	06d000ef          	jal	ra,ffffffffc0205c82 <hash32>
ffffffffc020541a:	02051793          	slli	a5,a0,0x20
ffffffffc020541e:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0205422:	955e                	add	a0,a0,s7
ffffffffc0205424:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc0205426:	a029                	j	ffffffffc0205430 <do_wait+0x80>
            if (proc->pid == pid)
ffffffffc0205428:	f2c42783          	lw	a5,-212(s0)
ffffffffc020542c:	02978463          	beq	a5,s1,ffffffffc0205454 <do_wait+0xa4>
ffffffffc0205430:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc0205432:	fe851be3          	bne	a0,s0,ffffffffc0205428 <do_wait+0x78>
    return -E_BAD_PROC;
ffffffffc0205436:	5579                	li	a0,-2
}
ffffffffc0205438:	60e6                	ld	ra,88(sp)
ffffffffc020543a:	6446                	ld	s0,80(sp)
ffffffffc020543c:	64a6                	ld	s1,72(sp)
ffffffffc020543e:	6906                	ld	s2,64(sp)
ffffffffc0205440:	79e2                	ld	s3,56(sp)
ffffffffc0205442:	7a42                	ld	s4,48(sp)
ffffffffc0205444:	7aa2                	ld	s5,40(sp)
ffffffffc0205446:	7b02                	ld	s6,32(sp)
ffffffffc0205448:	6be2                	ld	s7,24(sp)
ffffffffc020544a:	6c42                	ld	s8,16(sp)
ffffffffc020544c:	6ca2                	ld	s9,8(sp)
ffffffffc020544e:	6d02                	ld	s10,0(sp)
ffffffffc0205450:	6125                	addi	sp,sp,96
ffffffffc0205452:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc0205454:	000d3703          	ld	a4,0(s10)
ffffffffc0205458:	f4843783          	ld	a5,-184(s0)
ffffffffc020545c:	fce79de3          	bne	a5,a4,ffffffffc0205436 <do_wait+0x86>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0205460:	f2842783          	lw	a5,-216(s0)
ffffffffc0205464:	0f978a63          	beq	a5,s9,ffffffffc0205558 <do_wait+0x1a8>
        current->state = PROC_SLEEPING;
ffffffffc0205468:	01572023          	sw	s5,0(a4)
        current->wait_state = WT_CHILD;
ffffffffc020546c:	0f272623          	sw	s2,236(a4)
        schedule();
ffffffffc0205470:	64c000ef          	jal	ra,ffffffffc0205abc <schedule>
        if (current->flags & PF_EXITING)
ffffffffc0205474:	000d3783          	ld	a5,0(s10)
ffffffffc0205478:	0b07a783          	lw	a5,176(a5)
ffffffffc020547c:	8b85                	andi	a5,a5,1
ffffffffc020547e:	d7d9                	beqz	a5,ffffffffc020540c <do_wait+0x5c>
            do_exit(-E_KILLED);
ffffffffc0205480:	555d                	li	a0,-9
ffffffffc0205482:	cacff0ef          	jal	ra,ffffffffc020492e <do_exit>
        proc = current->cptr;
ffffffffc0205486:	000d3703          	ld	a4,0(s10)
ffffffffc020548a:	7b60                	ld	s0,240(a4)
        for (; proc != NULL; proc = proc->optr)
ffffffffc020548c:	e409                	bnez	s0,ffffffffc0205496 <do_wait+0xe6>
ffffffffc020548e:	b765                	j	ffffffffc0205436 <do_wait+0x86>
ffffffffc0205490:	10043403          	ld	s0,256(s0)
ffffffffc0205494:	d871                	beqz	s0,ffffffffc0205468 <do_wait+0xb8>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0205496:	401c                	lw	a5,0(s0)
ffffffffc0205498:	ff979ce3          	bne	a5,s9,ffffffffc0205490 <do_wait+0xe0>
    if (proc == idleproc || proc == initproc)
ffffffffc020549c:	00141797          	auipc	a5,0x141
ffffffffc02054a0:	d8c7b783          	ld	a5,-628(a5) # ffffffffc0346228 <idleproc>
ffffffffc02054a4:	0e878763          	beq	a5,s0,ffffffffc0205592 <do_wait+0x1e2>
ffffffffc02054a8:	00141797          	auipc	a5,0x141
ffffffffc02054ac:	d887b783          	ld	a5,-632(a5) # ffffffffc0346230 <initproc>
ffffffffc02054b0:	0ef40163          	beq	s0,a5,ffffffffc0205592 <do_wait+0x1e2>
    if (code_store != NULL)
ffffffffc02054b4:	00098663          	beqz	s3,ffffffffc02054c0 <do_wait+0x110>
        *code_store = proc->exit_code;
ffffffffc02054b8:	0e842783          	lw	a5,232(s0)
ffffffffc02054bc:	00f9a023          	sw	a5,0(s3)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02054c0:	100027f3          	csrr	a5,sstatus
ffffffffc02054c4:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02054c6:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02054c8:	e7c1                	bnez	a5,ffffffffc0205550 <do_wait+0x1a0>
    __list_del(listelm->prev, listelm->next);
ffffffffc02054ca:	6c70                	ld	a2,216(s0)
ffffffffc02054cc:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc02054ce:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc02054d2:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc02054d4:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc02054d6:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02054d8:	6470                	ld	a2,200(s0)
ffffffffc02054da:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc02054dc:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc02054de:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc02054e0:	c319                	beqz	a4,ffffffffc02054e6 <do_wait+0x136>
        proc->optr->yptr = proc->yptr;
ffffffffc02054e2:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc02054e4:	7c7c                	ld	a5,248(s0)
ffffffffc02054e6:	c3b5                	beqz	a5,ffffffffc020554a <do_wait+0x19a>
        proc->yptr->optr = proc->optr;
ffffffffc02054e8:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc02054ec:	00141717          	auipc	a4,0x141
ffffffffc02054f0:	d4c70713          	addi	a4,a4,-692 # ffffffffc0346238 <nr_process>
ffffffffc02054f4:	431c                	lw	a5,0(a4)
ffffffffc02054f6:	37fd                	addiw	a5,a5,-1
ffffffffc02054f8:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc02054fa:	e5a9                	bnez	a1,ffffffffc0205544 <do_wait+0x194>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02054fc:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc02054fe:	c02007b7          	lui	a5,0xc0200
ffffffffc0205502:	06f6ec63          	bltu	a3,a5,ffffffffc020557a <do_wait+0x1ca>
ffffffffc0205506:	00141797          	auipc	a5,0x141
ffffffffc020550a:	d127b783          	ld	a5,-750(a5) # ffffffffc0346218 <va_pa_offset>
ffffffffc020550e:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0205510:	82b1                	srli	a3,a3,0xc
ffffffffc0205512:	00141797          	auipc	a5,0x141
ffffffffc0205516:	cee7b783          	ld	a5,-786(a5) # ffffffffc0346200 <npage>
ffffffffc020551a:	04f6f463          	bgeu	a3,a5,ffffffffc0205562 <do_wait+0x1b2>
    return &pages[PPN(pa) - nbase];
ffffffffc020551e:	00004517          	auipc	a0,0x4
ffffffffc0205522:	8f253503          	ld	a0,-1806(a0) # ffffffffc0208e10 <nbase>
ffffffffc0205526:	8e89                	sub	a3,a3,a0
ffffffffc0205528:	069a                	slli	a3,a3,0x6
ffffffffc020552a:	00141517          	auipc	a0,0x141
ffffffffc020552e:	cde53503          	ld	a0,-802(a0) # ffffffffc0346208 <pages>
ffffffffc0205532:	9536                	add	a0,a0,a3
ffffffffc0205534:	4589                	li	a1,2
ffffffffc0205536:	a7bfc0ef          	jal	ra,ffffffffc0201fb0 <free_pages>
    kfree(proc);
ffffffffc020553a:	8522                	mv	a0,s0
ffffffffc020553c:	861fc0ef          	jal	ra,ffffffffc0201d9c <kfree>
    return 0;
ffffffffc0205540:	4501                	li	a0,0
ffffffffc0205542:	bddd                	j	ffffffffc0205438 <do_wait+0x88>
        intr_enable();
ffffffffc0205544:	c4efb0ef          	jal	ra,ffffffffc0200992 <intr_enable>
ffffffffc0205548:	bf55                	j	ffffffffc02054fc <do_wait+0x14c>
        proc->parent->cptr = proc->optr;
ffffffffc020554a:	701c                	ld	a5,32(s0)
ffffffffc020554c:	fbf8                	sd	a4,240(a5)
ffffffffc020554e:	bf79                	j	ffffffffc02054ec <do_wait+0x13c>
        intr_disable();
ffffffffc0205550:	c48fb0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        return 1;
ffffffffc0205554:	4585                	li	a1,1
ffffffffc0205556:	bf95                	j	ffffffffc02054ca <do_wait+0x11a>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0205558:	f2840413          	addi	s0,s0,-216
ffffffffc020555c:	b781                	j	ffffffffc020549c <do_wait+0xec>
            return -E_INVAL;
ffffffffc020555e:	5575                	li	a0,-3
ffffffffc0205560:	bde1                	j	ffffffffc0205438 <do_wait+0x88>
        panic("pa2page called with invalid pa");
ffffffffc0205562:	00002617          	auipc	a2,0x2
ffffffffc0205566:	f0e60613          	addi	a2,a2,-242 # ffffffffc0207470 <default_pmm_manager+0x108>
ffffffffc020556a:	06900593          	li	a1,105
ffffffffc020556e:	00002517          	auipc	a0,0x2
ffffffffc0205572:	e9250513          	addi	a0,a0,-366 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc0205576:	f03fa0ef          	jal	ra,ffffffffc0200478 <__panic>
    return pa2page(PADDR(kva));
ffffffffc020557a:	00002617          	auipc	a2,0x2
ffffffffc020557e:	ece60613          	addi	a2,a2,-306 # ffffffffc0207448 <default_pmm_manager+0xe0>
ffffffffc0205582:	07700593          	li	a1,119
ffffffffc0205586:	00002517          	auipc	a0,0x2
ffffffffc020558a:	e7a50513          	addi	a0,a0,-390 # ffffffffc0207400 <default_pmm_manager+0x98>
ffffffffc020558e:	eebfa0ef          	jal	ra,ffffffffc0200478 <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc0205592:	00003617          	auipc	a2,0x3
ffffffffc0205596:	8a660613          	addi	a2,a2,-1882 # ffffffffc0207e38 <default_pmm_manager+0xad0>
ffffffffc020559a:	38c00593          	li	a1,908
ffffffffc020559e:	00002517          	auipc	a0,0x2
ffffffffc02055a2:	7fa50513          	addi	a0,a0,2042 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc02055a6:	ed3fa0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc02055aa <do_kill>:
{
ffffffffc02055aa:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc02055ac:	6789                	lui	a5,0x2
{
ffffffffc02055ae:	e406                	sd	ra,8(sp)
ffffffffc02055b0:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc02055b2:	fff5071b          	addiw	a4,a0,-1
ffffffffc02055b6:	17f9                	addi	a5,a5,-2
ffffffffc02055b8:	02e7e963          	bltu	a5,a4,ffffffffc02055ea <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02055bc:	842a                	mv	s0,a0
ffffffffc02055be:	45a9                	li	a1,10
ffffffffc02055c0:	2501                	sext.w	a0,a0
ffffffffc02055c2:	6c0000ef          	jal	ra,ffffffffc0205c82 <hash32>
ffffffffc02055c6:	02051793          	slli	a5,a0,0x20
ffffffffc02055ca:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02055ce:	0013d797          	auipc	a5,0x13d
ffffffffc02055d2:	bba78793          	addi	a5,a5,-1094 # ffffffffc0342188 <hash_list>
ffffffffc02055d6:	953e                	add	a0,a0,a5
ffffffffc02055d8:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc02055da:	a029                	j	ffffffffc02055e4 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc02055dc:	f2c7a703          	lw	a4,-212(a5)
ffffffffc02055e0:	00870b63          	beq	a4,s0,ffffffffc02055f6 <do_kill+0x4c>
    return listelm->next;
ffffffffc02055e4:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02055e6:	fef51be3          	bne	a0,a5,ffffffffc02055dc <do_kill+0x32>
    return -E_INVAL;
ffffffffc02055ea:	5475                	li	s0,-3
}
ffffffffc02055ec:	60a2                	ld	ra,8(sp)
ffffffffc02055ee:	8522                	mv	a0,s0
ffffffffc02055f0:	6402                	ld	s0,0(sp)
ffffffffc02055f2:	0141                	addi	sp,sp,16
ffffffffc02055f4:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc02055f6:	fd87a703          	lw	a4,-40(a5)
ffffffffc02055fa:	00177693          	andi	a3,a4,1
ffffffffc02055fe:	e295                	bnez	a3,ffffffffc0205622 <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0205600:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0205602:	00176713          	ori	a4,a4,1
ffffffffc0205606:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc020560a:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc020560c:	fe06d0e3          	bgez	a3,ffffffffc02055ec <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0205610:	f2878513          	addi	a0,a5,-216
ffffffffc0205614:	3f6000ef          	jal	ra,ffffffffc0205a0a <wakeup_proc>
}
ffffffffc0205618:	60a2                	ld	ra,8(sp)
ffffffffc020561a:	8522                	mv	a0,s0
ffffffffc020561c:	6402                	ld	s0,0(sp)
ffffffffc020561e:	0141                	addi	sp,sp,16
ffffffffc0205620:	8082                	ret
        return -E_KILLED;
ffffffffc0205622:	545d                	li	s0,-9
ffffffffc0205624:	b7e1                	j	ffffffffc02055ec <do_kill+0x42>

ffffffffc0205626 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0205626:	1101                	addi	sp,sp,-32
ffffffffc0205628:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc020562a:	00141797          	auipc	a5,0x141
ffffffffc020562e:	b5e78793          	addi	a5,a5,-1186 # ffffffffc0346188 <proc_list>
ffffffffc0205632:	ec06                	sd	ra,24(sp)
ffffffffc0205634:	e822                	sd	s0,16(sp)
ffffffffc0205636:	e04a                	sd	s2,0(sp)
ffffffffc0205638:	0013d497          	auipc	s1,0x13d
ffffffffc020563c:	b5048493          	addi	s1,s1,-1200 # ffffffffc0342188 <hash_list>
ffffffffc0205640:	e79c                	sd	a5,8(a5)
ffffffffc0205642:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0205644:	00141717          	auipc	a4,0x141
ffffffffc0205648:	b4470713          	addi	a4,a4,-1212 # ffffffffc0346188 <proc_list>
ffffffffc020564c:	87a6                	mv	a5,s1
ffffffffc020564e:	e79c                	sd	a5,8(a5)
ffffffffc0205650:	e39c                	sd	a5,0(a5)
ffffffffc0205652:	07c1                	addi	a5,a5,16
ffffffffc0205654:	fee79de3          	bne	a5,a4,ffffffffc020564e <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0205658:	cf3fe0ef          	jal	ra,ffffffffc020434a <alloc_proc>
ffffffffc020565c:	00141917          	auipc	s2,0x141
ffffffffc0205660:	bcc90913          	addi	s2,s2,-1076 # ffffffffc0346228 <idleproc>
ffffffffc0205664:	00a93023          	sd	a0,0(s2)
ffffffffc0205668:	0e050f63          	beqz	a0,ffffffffc0205766 <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc020566c:	4789                	li	a5,2
ffffffffc020566e:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205670:	00004797          	auipc	a5,0x4
ffffffffc0205674:	99078793          	addi	a5,a5,-1648 # ffffffffc0209000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205678:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc020567c:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc020567e:	4785                	li	a5,1
ffffffffc0205680:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205682:	4641                	li	a2,16
ffffffffc0205684:	4581                	li	a1,0
ffffffffc0205686:	8522                	mv	a0,s0
ffffffffc0205688:	425000ef          	jal	ra,ffffffffc02062ac <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020568c:	463d                	li	a2,15
ffffffffc020568e:	00003597          	auipc	a1,0x3
ffffffffc0205692:	aa258593          	addi	a1,a1,-1374 # ffffffffc0208130 <default_pmm_manager+0xdc8>
ffffffffc0205696:	8522                	mv	a0,s0
ffffffffc0205698:	59b000ef          	jal	ra,ffffffffc0206432 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc020569c:	00141717          	auipc	a4,0x141
ffffffffc02056a0:	b9c70713          	addi	a4,a4,-1124 # ffffffffc0346238 <nr_process>
ffffffffc02056a4:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc02056a6:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02056aa:	4601                	li	a2,0
    nr_process++;
ffffffffc02056ac:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02056ae:	4581                	li	a1,0
ffffffffc02056b0:	fffff517          	auipc	a0,0xfffff
ffffffffc02056b4:	43850513          	addi	a0,a0,1080 # ffffffffc0204ae8 <init_main>
    nr_process++;
ffffffffc02056b8:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc02056ba:	00141797          	auipc	a5,0x141
ffffffffc02056be:	b6d7b323          	sd	a3,-1178(a5) # ffffffffc0346220 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02056c2:	a1cff0ef          	jal	ra,ffffffffc02048de <kernel_thread>
ffffffffc02056c6:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc02056c8:	08a05363          	blez	a0,ffffffffc020574e <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc02056cc:	6789                	lui	a5,0x2
ffffffffc02056ce:	fff5071b          	addiw	a4,a0,-1
ffffffffc02056d2:	17f9                	addi	a5,a5,-2
ffffffffc02056d4:	2501                	sext.w	a0,a0
ffffffffc02056d6:	02e7e363          	bltu	a5,a4,ffffffffc02056fc <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02056da:	45a9                	li	a1,10
ffffffffc02056dc:	5a6000ef          	jal	ra,ffffffffc0205c82 <hash32>
ffffffffc02056e0:	02051793          	slli	a5,a0,0x20
ffffffffc02056e4:	01c7d693          	srli	a3,a5,0x1c
ffffffffc02056e8:	96a6                	add	a3,a3,s1
ffffffffc02056ea:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc02056ec:	a029                	j	ffffffffc02056f6 <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc02056ee:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0xf47c>
ffffffffc02056f2:	04870b63          	beq	a4,s0,ffffffffc0205748 <proc_init+0x122>
    return listelm->next;
ffffffffc02056f6:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02056f8:	fef69be3          	bne	a3,a5,ffffffffc02056ee <proc_init+0xc8>
    return NULL;
ffffffffc02056fc:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02056fe:	0b478493          	addi	s1,a5,180
ffffffffc0205702:	4641                	li	a2,16
ffffffffc0205704:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0205706:	00141417          	auipc	s0,0x141
ffffffffc020570a:	b2a40413          	addi	s0,s0,-1238 # ffffffffc0346230 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020570e:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0205710:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205712:	39b000ef          	jal	ra,ffffffffc02062ac <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205716:	463d                	li	a2,15
ffffffffc0205718:	00003597          	auipc	a1,0x3
ffffffffc020571c:	a4058593          	addi	a1,a1,-1472 # ffffffffc0208158 <default_pmm_manager+0xdf0>
ffffffffc0205720:	8526                	mv	a0,s1
ffffffffc0205722:	511000ef          	jal	ra,ffffffffc0206432 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205726:	00093783          	ld	a5,0(s2)
ffffffffc020572a:	cbb5                	beqz	a5,ffffffffc020579e <proc_init+0x178>
ffffffffc020572c:	43dc                	lw	a5,4(a5)
ffffffffc020572e:	eba5                	bnez	a5,ffffffffc020579e <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205730:	601c                	ld	a5,0(s0)
ffffffffc0205732:	c7b1                	beqz	a5,ffffffffc020577e <proc_init+0x158>
ffffffffc0205734:	43d8                	lw	a4,4(a5)
ffffffffc0205736:	4785                	li	a5,1
ffffffffc0205738:	04f71363          	bne	a4,a5,ffffffffc020577e <proc_init+0x158>
}
ffffffffc020573c:	60e2                	ld	ra,24(sp)
ffffffffc020573e:	6442                	ld	s0,16(sp)
ffffffffc0205740:	64a2                	ld	s1,8(sp)
ffffffffc0205742:	6902                	ld	s2,0(sp)
ffffffffc0205744:	6105                	addi	sp,sp,32
ffffffffc0205746:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0205748:	f2878793          	addi	a5,a5,-216
ffffffffc020574c:	bf4d                	j	ffffffffc02056fe <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc020574e:	00003617          	auipc	a2,0x3
ffffffffc0205752:	9ea60613          	addi	a2,a2,-1558 # ffffffffc0208138 <default_pmm_manager+0xdd0>
ffffffffc0205756:	41e00593          	li	a1,1054
ffffffffc020575a:	00002517          	auipc	a0,0x2
ffffffffc020575e:	63e50513          	addi	a0,a0,1598 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc0205762:	d17fa0ef          	jal	ra,ffffffffc0200478 <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0205766:	00003617          	auipc	a2,0x3
ffffffffc020576a:	9b260613          	addi	a2,a2,-1614 # ffffffffc0208118 <default_pmm_manager+0xdb0>
ffffffffc020576e:	40f00593          	li	a1,1039
ffffffffc0205772:	00002517          	auipc	a0,0x2
ffffffffc0205776:	62650513          	addi	a0,a0,1574 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc020577a:	cfffa0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc020577e:	00003697          	auipc	a3,0x3
ffffffffc0205782:	a0a68693          	addi	a3,a3,-1526 # ffffffffc0208188 <default_pmm_manager+0xe20>
ffffffffc0205786:	00002617          	auipc	a2,0x2
ffffffffc020578a:	83260613          	addi	a2,a2,-1998 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020578e:	42500593          	li	a1,1061
ffffffffc0205792:	00002517          	auipc	a0,0x2
ffffffffc0205796:	60650513          	addi	a0,a0,1542 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc020579a:	cdffa0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020579e:	00003697          	auipc	a3,0x3
ffffffffc02057a2:	9c268693          	addi	a3,a3,-1598 # ffffffffc0208160 <default_pmm_manager+0xdf8>
ffffffffc02057a6:	00002617          	auipc	a2,0x2
ffffffffc02057aa:	81260613          	addi	a2,a2,-2030 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02057ae:	42400593          	li	a1,1060
ffffffffc02057b2:	00002517          	auipc	a0,0x2
ffffffffc02057b6:	5e650513          	addi	a0,a0,1510 # ffffffffc0207d98 <default_pmm_manager+0xa30>
ffffffffc02057ba:	cbffa0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc02057be <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc02057be:	1141                	addi	sp,sp,-16
ffffffffc02057c0:	e022                	sd	s0,0(sp)
ffffffffc02057c2:	e406                	sd	ra,8(sp)
ffffffffc02057c4:	00141417          	auipc	s0,0x141
ffffffffc02057c8:	a5c40413          	addi	s0,s0,-1444 # ffffffffc0346220 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc02057cc:	6018                	ld	a4,0(s0)
ffffffffc02057ce:	6f1c                	ld	a5,24(a4)
ffffffffc02057d0:	dffd                	beqz	a5,ffffffffc02057ce <cpu_idle+0x10>
        {
            schedule();
ffffffffc02057d2:	2ea000ef          	jal	ra,ffffffffc0205abc <schedule>
ffffffffc02057d6:	bfdd                	j	ffffffffc02057cc <cpu_idle+0xe>

ffffffffc02057d8 <lab6_set_priority>:
        }
    }
}
// FOR LAB6, set the process's priority (bigger value will get more CPU time)
void lab6_set_priority(uint32_t priority)
{
ffffffffc02057d8:	1141                	addi	sp,sp,-16
ffffffffc02057da:	e022                	sd	s0,0(sp)
    cprintf("set priority to %d\n", priority);
ffffffffc02057dc:	85aa                	mv	a1,a0
{
ffffffffc02057de:	842a                	mv	s0,a0
    cprintf("set priority to %d\n", priority);
ffffffffc02057e0:	00003517          	auipc	a0,0x3
ffffffffc02057e4:	9d050513          	addi	a0,a0,-1584 # ffffffffc02081b0 <default_pmm_manager+0xe48>
{
ffffffffc02057e8:	e406                	sd	ra,8(sp)
    cprintf("set priority to %d\n", priority);
ffffffffc02057ea:	9affa0ef          	jal	ra,ffffffffc0200198 <cprintf>
    if (priority == 0)
        current->lab6_priority = 1;
ffffffffc02057ee:	00141797          	auipc	a5,0x141
ffffffffc02057f2:	a327b783          	ld	a5,-1486(a5) # ffffffffc0346220 <current>
    if (priority == 0)
ffffffffc02057f6:	e801                	bnez	s0,ffffffffc0205806 <lab6_set_priority+0x2e>
    else
        current->lab6_priority = priority;
}
ffffffffc02057f8:	60a2                	ld	ra,8(sp)
ffffffffc02057fa:	6402                	ld	s0,0(sp)
        current->lab6_priority = 1;
ffffffffc02057fc:	4705                	li	a4,1
ffffffffc02057fe:	14e7a223          	sw	a4,324(a5)
}
ffffffffc0205802:	0141                	addi	sp,sp,16
ffffffffc0205804:	8082                	ret
ffffffffc0205806:	60a2                	ld	ra,8(sp)
        current->lab6_priority = priority;
ffffffffc0205808:	1487a223          	sw	s0,324(a5)
}
ffffffffc020580c:	6402                	ld	s0,0(sp)
ffffffffc020580e:	0141                	addi	sp,sp,16
ffffffffc0205810:	8082                	ret

ffffffffc0205812 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0205812:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0205816:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc020581a:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc020581c:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc020581e:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0205822:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0205826:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc020582a:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc020582e:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0205832:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0205836:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc020583a:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc020583e:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0205842:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0205846:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc020584a:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc020584e:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0205850:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0205852:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0205856:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc020585a:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc020585e:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0205862:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0205866:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc020586a:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc020586e:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0205872:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0205876:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc020587a:	8082                	ret

ffffffffc020587c <RR_init>:
    elm->prev = elm->next = elm;
ffffffffc020587c:	e508                	sd	a0,8(a0)
ffffffffc020587e:	e108                	sd	a0,0(a0)
static void
RR_init(struct run_queue *rq)
{
    // LAB6: 填写你在lab6中实现的代码
    list_init(&(rq->run_list));
    rq->proc_num = 0;
ffffffffc0205880:	00052823          	sw	zero,16(a0)
    rq->lab6_run_pool = NULL;
ffffffffc0205884:	00053c23          	sd	zero,24(a0)
}
ffffffffc0205888:	8082                	ret

ffffffffc020588a <RR_pick_next>:
    return listelm->next;
ffffffffc020588a:	651c                	ld	a5,8(a0)
static struct proc_struct *
RR_pick_next(struct run_queue *rq)
{
    // LAB6: 填写你在lab6中实现的代码
    list_entry_t *le = list_next(&(rq->run_list));
    if (le != &(rq->run_list)) {
ffffffffc020588c:	00f50563          	beq	a0,a5,ffffffffc0205896 <RR_pick_next+0xc>
        return le2proc(le, run_link);
ffffffffc0205890:	ef078513          	addi	a0,a5,-272
ffffffffc0205894:	8082                	ret
    }
    return NULL;
ffffffffc0205896:	4501                	li	a0,0
}
ffffffffc0205898:	8082                	ret

ffffffffc020589a <RR_proc_tick>:
 */
static void
RR_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
    // LAB6: 填写你在lab6中实现的代码
    if (proc->time_slice > 0) {
ffffffffc020589a:	1205a783          	lw	a5,288(a1)
ffffffffc020589e:	00f05563          	blez	a5,ffffffffc02058a8 <RR_proc_tick+0xe>
        proc->time_slice --;
ffffffffc02058a2:	37fd                	addiw	a5,a5,-1
ffffffffc02058a4:	12f5a023          	sw	a5,288(a1)
    }
    if (proc->time_slice == 0) {
ffffffffc02058a8:	e399                	bnez	a5,ffffffffc02058ae <RR_proc_tick+0x14>
        proc->need_resched = 1;
ffffffffc02058aa:	4785                	li	a5,1
ffffffffc02058ac:	ed9c                	sd	a5,24(a1)
    }
}
ffffffffc02058ae:	8082                	ret

ffffffffc02058b0 <RR_dequeue>:
    assert(!list_empty(&(rq->run_list)));
ffffffffc02058b0:	651c                	ld	a5,8(a0)
{
ffffffffc02058b2:	1141                	addi	sp,sp,-16
ffffffffc02058b4:	e406                	sd	ra,8(sp)
    assert(!list_empty(&(rq->run_list)));
ffffffffc02058b6:	02f50a63          	beq	a0,a5,ffffffffc02058ea <RR_dequeue+0x3a>
    assert(proc->rq == rq);
ffffffffc02058ba:	1085b783          	ld	a5,264(a1)
ffffffffc02058be:	04a79663          	bne	a5,a0,ffffffffc020590a <RR_dequeue+0x5a>
    __list_del(listelm->prev, listelm->next);
ffffffffc02058c2:	1105b503          	ld	a0,272(a1)
ffffffffc02058c6:	1185b603          	ld	a2,280(a1)
    rq->proc_num --;
ffffffffc02058ca:	4b98                	lw	a4,16(a5)
    list_del_init(&(proc->run_link));
ffffffffc02058cc:	11058693          	addi	a3,a1,272
    prev->next = next;
ffffffffc02058d0:	e510                	sd	a2,8(a0)
    next->prev = prev;
ffffffffc02058d2:	e208                	sd	a0,0(a2)
}
ffffffffc02058d4:	60a2                	ld	ra,8(sp)
    elm->prev = elm->next = elm;
ffffffffc02058d6:	10d5bc23          	sd	a3,280(a1)
ffffffffc02058da:	10d5b823          	sd	a3,272(a1)
    rq->proc_num --;
ffffffffc02058de:	377d                	addiw	a4,a4,-1
ffffffffc02058e0:	cb98                	sw	a4,16(a5)
    proc->rq = NULL;
ffffffffc02058e2:	1005b423          	sd	zero,264(a1)
}
ffffffffc02058e6:	0141                	addi	sp,sp,16
ffffffffc02058e8:	8082                	ret
    assert(!list_empty(&(rq->run_list)));
ffffffffc02058ea:	00003697          	auipc	a3,0x3
ffffffffc02058ee:	8de68693          	addi	a3,a3,-1826 # ffffffffc02081c8 <default_pmm_manager+0xe60>
ffffffffc02058f2:	00001617          	auipc	a2,0x1
ffffffffc02058f6:	6c660613          	addi	a2,a2,1734 # ffffffffc0206fb8 <commands+0x850>
ffffffffc02058fa:	03d00593          	li	a1,61
ffffffffc02058fe:	00003517          	auipc	a0,0x3
ffffffffc0205902:	8ea50513          	addi	a0,a0,-1814 # ffffffffc02081e8 <default_pmm_manager+0xe80>
ffffffffc0205906:	b73fa0ef          	jal	ra,ffffffffc0200478 <__panic>
    assert(proc->rq == rq);
ffffffffc020590a:	00003697          	auipc	a3,0x3
ffffffffc020590e:	8fe68693          	addi	a3,a3,-1794 # ffffffffc0208208 <default_pmm_manager+0xea0>
ffffffffc0205912:	00001617          	auipc	a2,0x1
ffffffffc0205916:	6a660613          	addi	a2,a2,1702 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020591a:	03e00593          	li	a1,62
ffffffffc020591e:	00003517          	auipc	a0,0x3
ffffffffc0205922:	8ca50513          	addi	a0,a0,-1846 # ffffffffc02081e8 <default_pmm_manager+0xe80>
ffffffffc0205926:	b53fa0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc020592a <RR_enqueue>:
    assert(list_empty(&(proc->run_link)));
ffffffffc020592a:	1185b703          	ld	a4,280(a1)
ffffffffc020592e:	11058793          	addi	a5,a1,272
ffffffffc0205932:	02e79d63          	bne	a5,a4,ffffffffc020596c <RR_enqueue+0x42>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0205936:	6118                	ld	a4,0(a0)
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
ffffffffc0205938:	1205a683          	lw	a3,288(a1)
    prev->next = next->prev = elm;
ffffffffc020593c:	e11c                	sd	a5,0(a0)
ffffffffc020593e:	e71c                	sd	a5,8(a4)
    elm->next = next;
ffffffffc0205940:	10a5bc23          	sd	a0,280(a1)
    elm->prev = prev;
ffffffffc0205944:	10e5b823          	sd	a4,272(a1)
ffffffffc0205948:	495c                	lw	a5,20(a0)
ffffffffc020594a:	ea89                	bnez	a3,ffffffffc020595c <RR_enqueue+0x32>
        proc->time_slice = rq->max_time_slice;
ffffffffc020594c:	12f5a023          	sw	a5,288(a1)
    rq->proc_num ++;
ffffffffc0205950:	491c                	lw	a5,16(a0)
    proc->rq = rq;
ffffffffc0205952:	10a5b423          	sd	a0,264(a1)
    rq->proc_num ++;
ffffffffc0205956:	2785                	addiw	a5,a5,1
ffffffffc0205958:	c91c                	sw	a5,16(a0)
ffffffffc020595a:	8082                	ret
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
ffffffffc020595c:	fed7c8e3          	blt	a5,a3,ffffffffc020594c <RR_enqueue+0x22>
    rq->proc_num ++;
ffffffffc0205960:	491c                	lw	a5,16(a0)
    proc->rq = rq;
ffffffffc0205962:	10a5b423          	sd	a0,264(a1)
    rq->proc_num ++;
ffffffffc0205966:	2785                	addiw	a5,a5,1
ffffffffc0205968:	c91c                	sw	a5,16(a0)
ffffffffc020596a:	8082                	ret
{
ffffffffc020596c:	1141                	addi	sp,sp,-16
    assert(list_empty(&(proc->run_link)));
ffffffffc020596e:	00003697          	auipc	a3,0x3
ffffffffc0205972:	8aa68693          	addi	a3,a3,-1878 # ffffffffc0208218 <default_pmm_manager+0xeb0>
ffffffffc0205976:	00001617          	auipc	a2,0x1
ffffffffc020597a:	64260613          	addi	a2,a2,1602 # ffffffffc0206fb8 <commands+0x850>
ffffffffc020597e:	02900593          	li	a1,41
ffffffffc0205982:	00003517          	auipc	a0,0x3
ffffffffc0205986:	86650513          	addi	a0,a0,-1946 # ffffffffc02081e8 <default_pmm_manager+0xe80>
{
ffffffffc020598a:	e406                	sd	ra,8(sp)
    assert(list_empty(&(proc->run_link)));
ffffffffc020598c:	aedfa0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0205990 <sched_class_proc_tick>:
    return sched_class->pick_next(rq);
}

void sched_class_proc_tick(struct proc_struct *proc)
{
    if (proc != idleproc)
ffffffffc0205990:	00141797          	auipc	a5,0x141
ffffffffc0205994:	8987b783          	ld	a5,-1896(a5) # ffffffffc0346228 <idleproc>
{
ffffffffc0205998:	85aa                	mv	a1,a0
    if (proc != idleproc)
ffffffffc020599a:	00a78c63          	beq	a5,a0,ffffffffc02059b2 <sched_class_proc_tick+0x22>
    {
        sched_class->proc_tick(rq, proc);
ffffffffc020599e:	00141797          	auipc	a5,0x141
ffffffffc02059a2:	8aa7b783          	ld	a5,-1878(a5) # ffffffffc0346248 <sched_class>
ffffffffc02059a6:	779c                	ld	a5,40(a5)
ffffffffc02059a8:	00141517          	auipc	a0,0x141
ffffffffc02059ac:	89853503          	ld	a0,-1896(a0) # ffffffffc0346240 <rq>
ffffffffc02059b0:	8782                	jr	a5
    }
    else
    {
        proc->need_resched = 1;
ffffffffc02059b2:	4705                	li	a4,1
ffffffffc02059b4:	ef98                	sd	a4,24(a5)
    }
}
ffffffffc02059b6:	8082                	ret

ffffffffc02059b8 <sched_init>:

static struct run_queue __rq;

void sched_init(void)
{
ffffffffc02059b8:	1141                	addi	sp,sp,-16
    list_init(&timer_list);

    sched_class = &default_sched_class;
ffffffffc02059ba:	0013c717          	auipc	a4,0x13c
ffffffffc02059be:	37670713          	addi	a4,a4,886 # ffffffffc0341d30 <default_sched_class>
{
ffffffffc02059c2:	e022                	sd	s0,0(sp)
ffffffffc02059c4:	e406                	sd	ra,8(sp)
    elm->prev = elm->next = elm;
ffffffffc02059c6:	00140797          	auipc	a5,0x140
ffffffffc02059ca:	7f278793          	addi	a5,a5,2034 # ffffffffc03461b8 <timer_list>

    rq = &__rq;
    rq->max_time_slice = MAX_TIME_SLICE;
    sched_class->init(rq);
ffffffffc02059ce:	6714                	ld	a3,8(a4)
    rq = &__rq;
ffffffffc02059d0:	00140517          	auipc	a0,0x140
ffffffffc02059d4:	7c850513          	addi	a0,a0,1992 # ffffffffc0346198 <__rq>
ffffffffc02059d8:	e79c                	sd	a5,8(a5)
ffffffffc02059da:	e39c                	sd	a5,0(a5)
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc02059dc:	4795                	li	a5,5
ffffffffc02059de:	c95c                	sw	a5,20(a0)
    sched_class = &default_sched_class;
ffffffffc02059e0:	00141417          	auipc	s0,0x141
ffffffffc02059e4:	86840413          	addi	s0,s0,-1944 # ffffffffc0346248 <sched_class>
    rq = &__rq;
ffffffffc02059e8:	00141797          	auipc	a5,0x141
ffffffffc02059ec:	84a7bc23          	sd	a0,-1960(a5) # ffffffffc0346240 <rq>
    sched_class = &default_sched_class;
ffffffffc02059f0:	e018                	sd	a4,0(s0)
    sched_class->init(rq);
ffffffffc02059f2:	9682                	jalr	a3

    cprintf("sched class: %s\n", sched_class->name);
ffffffffc02059f4:	601c                	ld	a5,0(s0)
}
ffffffffc02059f6:	6402                	ld	s0,0(sp)
ffffffffc02059f8:	60a2                	ld	ra,8(sp)
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc02059fa:	638c                	ld	a1,0(a5)
ffffffffc02059fc:	00003517          	auipc	a0,0x3
ffffffffc0205a00:	84c50513          	addi	a0,a0,-1972 # ffffffffc0208248 <default_pmm_manager+0xee0>
}
ffffffffc0205a04:	0141                	addi	sp,sp,16
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205a06:	f92fa06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0205a0a <wakeup_proc>:

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205a0a:	4118                	lw	a4,0(a0)
{
ffffffffc0205a0c:	1101                	addi	sp,sp,-32
ffffffffc0205a0e:	ec06                	sd	ra,24(sp)
ffffffffc0205a10:	e822                	sd	s0,16(sp)
ffffffffc0205a12:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205a14:	478d                	li	a5,3
ffffffffc0205a16:	08f70363          	beq	a4,a5,ffffffffc0205a9c <wakeup_proc+0x92>
ffffffffc0205a1a:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205a1c:	100027f3          	csrr	a5,sstatus
ffffffffc0205a20:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205a22:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205a24:	e7bd                	bnez	a5,ffffffffc0205a92 <wakeup_proc+0x88>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205a26:	4789                	li	a5,2
ffffffffc0205a28:	04f70863          	beq	a4,a5,ffffffffc0205a78 <wakeup_proc+0x6e>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc0205a2c:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc0205a2e:	0e042623          	sw	zero,236(s0)
            if (proc != current)
ffffffffc0205a32:	00140797          	auipc	a5,0x140
ffffffffc0205a36:	7ee7b783          	ld	a5,2030(a5) # ffffffffc0346220 <current>
ffffffffc0205a3a:	02878363          	beq	a5,s0,ffffffffc0205a60 <wakeup_proc+0x56>
    if (proc != idleproc)
ffffffffc0205a3e:	00140797          	auipc	a5,0x140
ffffffffc0205a42:	7ea7b783          	ld	a5,2026(a5) # ffffffffc0346228 <idleproc>
ffffffffc0205a46:	00f40d63          	beq	s0,a5,ffffffffc0205a60 <wakeup_proc+0x56>
        sched_class->enqueue(rq, proc);
ffffffffc0205a4a:	00140797          	auipc	a5,0x140
ffffffffc0205a4e:	7fe7b783          	ld	a5,2046(a5) # ffffffffc0346248 <sched_class>
ffffffffc0205a52:	6b9c                	ld	a5,16(a5)
ffffffffc0205a54:	85a2                	mv	a1,s0
ffffffffc0205a56:	00140517          	auipc	a0,0x140
ffffffffc0205a5a:	7ea53503          	ld	a0,2026(a0) # ffffffffc0346240 <rq>
ffffffffc0205a5e:	9782                	jalr	a5
    if (flag)
ffffffffc0205a60:	e491                	bnez	s1,ffffffffc0205a6c <wakeup_proc+0x62>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205a62:	60e2                	ld	ra,24(sp)
ffffffffc0205a64:	6442                	ld	s0,16(sp)
ffffffffc0205a66:	64a2                	ld	s1,8(sp)
ffffffffc0205a68:	6105                	addi	sp,sp,32
ffffffffc0205a6a:	8082                	ret
ffffffffc0205a6c:	6442                	ld	s0,16(sp)
ffffffffc0205a6e:	60e2                	ld	ra,24(sp)
ffffffffc0205a70:	64a2                	ld	s1,8(sp)
ffffffffc0205a72:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205a74:	f1ffa06f          	j	ffffffffc0200992 <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc0205a78:	00003617          	auipc	a2,0x3
ffffffffc0205a7c:	82060613          	addi	a2,a2,-2016 # ffffffffc0208298 <default_pmm_manager+0xf30>
ffffffffc0205a80:	05100593          	li	a1,81
ffffffffc0205a84:	00002517          	auipc	a0,0x2
ffffffffc0205a88:	7fc50513          	addi	a0,a0,2044 # ffffffffc0208280 <default_pmm_manager+0xf18>
ffffffffc0205a8c:	a55fa0ef          	jal	ra,ffffffffc02004e0 <__warn>
ffffffffc0205a90:	bfc1                	j	ffffffffc0205a60 <wakeup_proc+0x56>
        intr_disable();
ffffffffc0205a92:	f07fa0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205a96:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc0205a98:	4485                	li	s1,1
ffffffffc0205a9a:	b771                	j	ffffffffc0205a26 <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205a9c:	00002697          	auipc	a3,0x2
ffffffffc0205aa0:	7c468693          	addi	a3,a3,1988 # ffffffffc0208260 <default_pmm_manager+0xef8>
ffffffffc0205aa4:	00001617          	auipc	a2,0x1
ffffffffc0205aa8:	51460613          	addi	a2,a2,1300 # ffffffffc0206fb8 <commands+0x850>
ffffffffc0205aac:	04200593          	li	a1,66
ffffffffc0205ab0:	00002517          	auipc	a0,0x2
ffffffffc0205ab4:	7d050513          	addi	a0,a0,2000 # ffffffffc0208280 <default_pmm_manager+0xf18>
ffffffffc0205ab8:	9c1fa0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0205abc <schedule>:

void schedule(void)
{
ffffffffc0205abc:	7179                	addi	sp,sp,-48
ffffffffc0205abe:	f406                	sd	ra,40(sp)
ffffffffc0205ac0:	f022                	sd	s0,32(sp)
ffffffffc0205ac2:	ec26                	sd	s1,24(sp)
ffffffffc0205ac4:	e84a                	sd	s2,16(sp)
ffffffffc0205ac6:	e44e                	sd	s3,8(sp)
ffffffffc0205ac8:	e052                	sd	s4,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205aca:	100027f3          	csrr	a5,sstatus
ffffffffc0205ace:	8b89                	andi	a5,a5,2
ffffffffc0205ad0:	4a01                	li	s4,0
ffffffffc0205ad2:	e7c5                	bnez	a5,ffffffffc0205b7a <schedule+0xbe>
    bool intr_flag;
    struct proc_struct *next;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0205ad4:	00140497          	auipc	s1,0x140
ffffffffc0205ad8:	74c48493          	addi	s1,s1,1868 # ffffffffc0346220 <current>
ffffffffc0205adc:	608c                	ld	a1,0(s1)
        sched_class->enqueue(rq, proc);
ffffffffc0205ade:	00140997          	auipc	s3,0x140
ffffffffc0205ae2:	76a98993          	addi	s3,s3,1898 # ffffffffc0346248 <sched_class>
ffffffffc0205ae6:	00140917          	auipc	s2,0x140
ffffffffc0205aea:	75a90913          	addi	s2,s2,1882 # ffffffffc0346240 <rq>
        if (current->state == PROC_RUNNABLE)
ffffffffc0205aee:	4194                	lw	a3,0(a1)
        current->need_resched = 0;
ffffffffc0205af0:	0005bc23          	sd	zero,24(a1)
        if (current->state == PROC_RUNNABLE)
ffffffffc0205af4:	4709                	li	a4,2
        sched_class->enqueue(rq, proc);
ffffffffc0205af6:	0009b783          	ld	a5,0(s3)
ffffffffc0205afa:	00093503          	ld	a0,0(s2)
        if (current->state == PROC_RUNNABLE)
ffffffffc0205afe:	04e68063          	beq	a3,a4,ffffffffc0205b3e <schedule+0x82>
    return sched_class->pick_next(rq);
ffffffffc0205b02:	739c                	ld	a5,32(a5)
ffffffffc0205b04:	9782                	jalr	a5
ffffffffc0205b06:	842a                	mv	s0,a0
        {
            sched_class_enqueue(current);
        }
        if ((next = sched_class_pick_next()) != NULL)
ffffffffc0205b08:	c939                	beqz	a0,ffffffffc0205b5e <schedule+0xa2>
    sched_class->dequeue(rq, proc);
ffffffffc0205b0a:	0009b783          	ld	a5,0(s3)
ffffffffc0205b0e:	00093503          	ld	a0,0(s2)
ffffffffc0205b12:	85a2                	mv	a1,s0
ffffffffc0205b14:	6f9c                	ld	a5,24(a5)
ffffffffc0205b16:	9782                	jalr	a5
        }
        if (next == NULL)
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc0205b18:	441c                	lw	a5,8(s0)
        if (next != current)
ffffffffc0205b1a:	6098                	ld	a4,0(s1)
        next->runs++;
ffffffffc0205b1c:	2785                	addiw	a5,a5,1
ffffffffc0205b1e:	c41c                	sw	a5,8(s0)
        if (next != current)
ffffffffc0205b20:	00870563          	beq	a4,s0,ffffffffc0205b2a <schedule+0x6e>
        {
            proc_run(next);
ffffffffc0205b24:	8522                	mv	a0,s0
ffffffffc0205b26:	92ffe0ef          	jal	ra,ffffffffc0204454 <proc_run>
    if (flag)
ffffffffc0205b2a:	020a1f63          	bnez	s4,ffffffffc0205b68 <schedule+0xac>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205b2e:	70a2                	ld	ra,40(sp)
ffffffffc0205b30:	7402                	ld	s0,32(sp)
ffffffffc0205b32:	64e2                	ld	s1,24(sp)
ffffffffc0205b34:	6942                	ld	s2,16(sp)
ffffffffc0205b36:	69a2                	ld	s3,8(sp)
ffffffffc0205b38:	6a02                	ld	s4,0(sp)
ffffffffc0205b3a:	6145                	addi	sp,sp,48
ffffffffc0205b3c:	8082                	ret
    if (proc != idleproc)
ffffffffc0205b3e:	00140717          	auipc	a4,0x140
ffffffffc0205b42:	6ea73703          	ld	a4,1770(a4) # ffffffffc0346228 <idleproc>
ffffffffc0205b46:	fae58ee3          	beq	a1,a4,ffffffffc0205b02 <schedule+0x46>
        sched_class->enqueue(rq, proc);
ffffffffc0205b4a:	6b9c                	ld	a5,16(a5)
ffffffffc0205b4c:	9782                	jalr	a5
    return sched_class->pick_next(rq);
ffffffffc0205b4e:	0009b783          	ld	a5,0(s3)
ffffffffc0205b52:	00093503          	ld	a0,0(s2)
ffffffffc0205b56:	739c                	ld	a5,32(a5)
ffffffffc0205b58:	9782                	jalr	a5
ffffffffc0205b5a:	842a                	mv	s0,a0
        if ((next = sched_class_pick_next()) != NULL)
ffffffffc0205b5c:	f55d                	bnez	a0,ffffffffc0205b0a <schedule+0x4e>
            next = idleproc;
ffffffffc0205b5e:	00140417          	auipc	s0,0x140
ffffffffc0205b62:	6ca43403          	ld	s0,1738(s0) # ffffffffc0346228 <idleproc>
ffffffffc0205b66:	bf4d                	j	ffffffffc0205b18 <schedule+0x5c>
}
ffffffffc0205b68:	7402                	ld	s0,32(sp)
ffffffffc0205b6a:	70a2                	ld	ra,40(sp)
ffffffffc0205b6c:	64e2                	ld	s1,24(sp)
ffffffffc0205b6e:	6942                	ld	s2,16(sp)
ffffffffc0205b70:	69a2                	ld	s3,8(sp)
ffffffffc0205b72:	6a02                	ld	s4,0(sp)
ffffffffc0205b74:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0205b76:	e1dfa06f          	j	ffffffffc0200992 <intr_enable>
        intr_disable();
ffffffffc0205b7a:	e1ffa0ef          	jal	ra,ffffffffc0200998 <intr_disable>
        return 1;
ffffffffc0205b7e:	4a05                	li	s4,1
ffffffffc0205b80:	bf91                	j	ffffffffc0205ad4 <schedule+0x18>

ffffffffc0205b82 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0205b82:	00140797          	auipc	a5,0x140
ffffffffc0205b86:	69e7b783          	ld	a5,1694(a5) # ffffffffc0346220 <current>
}
ffffffffc0205b8a:	43c8                	lw	a0,4(a5)
ffffffffc0205b8c:	8082                	ret

ffffffffc0205b8e <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205b8e:	4501                	li	a0,0
ffffffffc0205b90:	8082                	ret

ffffffffc0205b92 <sys_gettime>:
static int sys_gettime(uint64_t arg[]){
    return (int)ticks*10;
ffffffffc0205b92:	00140797          	auipc	a5,0x140
ffffffffc0205b96:	63e7b783          	ld	a5,1598(a5) # ffffffffc03461d0 <ticks>
ffffffffc0205b9a:	0027951b          	slliw	a0,a5,0x2
ffffffffc0205b9e:	9d3d                	addw	a0,a0,a5
}
ffffffffc0205ba0:	0015151b          	slliw	a0,a0,0x1
ffffffffc0205ba4:	8082                	ret

ffffffffc0205ba6 <sys_lab6_set_priority>:
static int sys_lab6_set_priority(uint64_t arg[]){
    uint64_t priority = (uint64_t)arg[0];
    lab6_set_priority(priority);
ffffffffc0205ba6:	4108                	lw	a0,0(a0)
static int sys_lab6_set_priority(uint64_t arg[]){
ffffffffc0205ba8:	1141                	addi	sp,sp,-16
ffffffffc0205baa:	e406                	sd	ra,8(sp)
    lab6_set_priority(priority);
ffffffffc0205bac:	c2dff0ef          	jal	ra,ffffffffc02057d8 <lab6_set_priority>
    return 0;
}
ffffffffc0205bb0:	60a2                	ld	ra,8(sp)
ffffffffc0205bb2:	4501                	li	a0,0
ffffffffc0205bb4:	0141                	addi	sp,sp,16
ffffffffc0205bb6:	8082                	ret

ffffffffc0205bb8 <sys_putc>:
    cputchar(c);
ffffffffc0205bb8:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205bba:	1141                	addi	sp,sp,-16
ffffffffc0205bbc:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205bbe:	e10fa0ef          	jal	ra,ffffffffc02001ce <cputchar>
}
ffffffffc0205bc2:	60a2                	ld	ra,8(sp)
ffffffffc0205bc4:	4501                	li	a0,0
ffffffffc0205bc6:	0141                	addi	sp,sp,16
ffffffffc0205bc8:	8082                	ret

ffffffffc0205bca <sys_kill>:
    return do_kill(pid);
ffffffffc0205bca:	4108                	lw	a0,0(a0)
ffffffffc0205bcc:	9dfff06f          	j	ffffffffc02055aa <do_kill>

ffffffffc0205bd0 <sys_yield>:
    return do_yield();
ffffffffc0205bd0:	fd0ff06f          	j	ffffffffc02053a0 <do_yield>

ffffffffc0205bd4 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205bd4:	6d14                	ld	a3,24(a0)
ffffffffc0205bd6:	6910                	ld	a2,16(a0)
ffffffffc0205bd8:	650c                	ld	a1,8(a0)
ffffffffc0205bda:	6108                	ld	a0,0(a0)
ffffffffc0205bdc:	97cff06f          	j	ffffffffc0204d58 <do_execve>

ffffffffc0205be0 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0205be0:	650c                	ld	a1,8(a0)
ffffffffc0205be2:	4108                	lw	a0,0(a0)
ffffffffc0205be4:	fccff06f          	j	ffffffffc02053b0 <do_wait>

ffffffffc0205be8 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0205be8:	00140797          	auipc	a5,0x140
ffffffffc0205bec:	6387b783          	ld	a5,1592(a5) # ffffffffc0346220 <current>
ffffffffc0205bf0:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc0205bf2:	4501                	li	a0,0
ffffffffc0205bf4:	6a0c                	ld	a1,16(a2)
ffffffffc0205bf6:	8cbfe06f          	j	ffffffffc02044c0 <do_fork>

ffffffffc0205bfa <sys_exit>:
    return do_exit(error_code);
ffffffffc0205bfa:	4108                	lw	a0,0(a0)
ffffffffc0205bfc:	d33fe06f          	j	ffffffffc020492e <do_exit>

ffffffffc0205c00 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc0205c00:	715d                	addi	sp,sp,-80
ffffffffc0205c02:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205c04:	00140497          	auipc	s1,0x140
ffffffffc0205c08:	61c48493          	addi	s1,s1,1564 # ffffffffc0346220 <current>
ffffffffc0205c0c:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc0205c0e:	e0a2                	sd	s0,64(sp)
ffffffffc0205c10:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205c12:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc0205c14:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205c16:	0ff00793          	li	a5,255
    int num = tf->gpr.a0;
ffffffffc0205c1a:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205c1e:	0327ee63          	bltu	a5,s2,ffffffffc0205c5a <syscall+0x5a>
        if (syscalls[num] != NULL) {
ffffffffc0205c22:	00391713          	slli	a4,s2,0x3
ffffffffc0205c26:	00002797          	auipc	a5,0x2
ffffffffc0205c2a:	6da78793          	addi	a5,a5,1754 # ffffffffc0208300 <syscalls>
ffffffffc0205c2e:	97ba                	add	a5,a5,a4
ffffffffc0205c30:	639c                	ld	a5,0(a5)
ffffffffc0205c32:	c785                	beqz	a5,ffffffffc0205c5a <syscall+0x5a>
            arg[0] = tf->gpr.a1;
            arg[1] = tf->gpr.a2;
            arg[2] = tf->gpr.a3;
            arg[3] = tf->gpr.a4;
            arg[4] = tf->gpr.a5;
ffffffffc0205c34:	7028                	ld	a0,96(s0)
ffffffffc0205c36:	742c                	ld	a1,104(s0)
ffffffffc0205c38:	7834                	ld	a3,112(s0)
            arg[0] = tf->gpr.a1;
ffffffffc0205c3a:	7c38                	ld	a4,120(s0)
ffffffffc0205c3c:	6c30                	ld	a2,88(s0)
ffffffffc0205c3e:	e82a                	sd	a0,16(sp)
ffffffffc0205c40:	ec2e                	sd	a1,24(sp)
ffffffffc0205c42:	e432                	sd	a2,8(sp)
ffffffffc0205c44:	f036                	sd	a3,32(sp)
ffffffffc0205c46:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205c48:	0028                	addi	a0,sp,8
ffffffffc0205c4a:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc0205c4c:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205c4e:	e828                	sd	a0,80(s0)
}
ffffffffc0205c50:	6406                	ld	s0,64(sp)
ffffffffc0205c52:	74e2                	ld	s1,56(sp)
ffffffffc0205c54:	7942                	ld	s2,48(sp)
ffffffffc0205c56:	6161                	addi	sp,sp,80
ffffffffc0205c58:	8082                	ret
    print_trapframe(tf);
ffffffffc0205c5a:	8522                	mv	a0,s0
ffffffffc0205c5c:	f2dfa0ef          	jal	ra,ffffffffc0200b88 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc0205c60:	609c                	ld	a5,0(s1)
ffffffffc0205c62:	86ca                	mv	a3,s2
ffffffffc0205c64:	00002617          	auipc	a2,0x2
ffffffffc0205c68:	65460613          	addi	a2,a2,1620 # ffffffffc02082b8 <default_pmm_manager+0xf50>
ffffffffc0205c6c:	43d8                	lw	a4,4(a5)
ffffffffc0205c6e:	06c00593          	li	a1,108
ffffffffc0205c72:	0b478793          	addi	a5,a5,180
ffffffffc0205c76:	00002517          	auipc	a0,0x2
ffffffffc0205c7a:	67250513          	addi	a0,a0,1650 # ffffffffc02082e8 <default_pmm_manager+0xf80>
ffffffffc0205c7e:	ffafa0ef          	jal	ra,ffffffffc0200478 <__panic>

ffffffffc0205c82 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0205c82:	9e3707b7          	lui	a5,0x9e370
ffffffffc0205c86:	2785                	addiw	a5,a5,1
ffffffffc0205c88:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205c8c:	02000793          	li	a5,32
ffffffffc0205c90:	9f8d                	subw	a5,a5,a1
}
ffffffffc0205c92:	00f5553b          	srlw	a0,a0,a5
ffffffffc0205c96:	8082                	ret

ffffffffc0205c98 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205c98:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205c9c:	7139                	addi	sp,sp,-64
    unsigned mod = do_div(result, base);
ffffffffc0205c9e:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205ca2:	e852                	sd	s4,16(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205ca4:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205ca8:	f426                	sd	s1,40(sp)
ffffffffc0205caa:	f04a                	sd	s2,32(sp)
ffffffffc0205cac:	ec4e                	sd	s3,24(sp)
ffffffffc0205cae:	fc06                	sd	ra,56(sp)
ffffffffc0205cb0:	f822                	sd	s0,48(sp)
ffffffffc0205cb2:	e456                	sd	s5,8(sp)
ffffffffc0205cb4:	e05a                	sd	s6,0(sp)
ffffffffc0205cb6:	84aa                	mv	s1,a0
ffffffffc0205cb8:	892e                	mv	s2,a1
ffffffffc0205cba:	89be                	mv	s3,a5
    unsigned mod = do_div(result, base);
ffffffffc0205cbc:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
ffffffffc0205cbe:	05067163          	bgeu	a2,a6,ffffffffc0205d00 <printnum+0x68>
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0205cc2:	fff7041b          	addiw	s0,a4,-1
ffffffffc0205cc6:	00805763          	blez	s0,ffffffffc0205cd4 <printnum+0x3c>
ffffffffc0205cca:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205ccc:	85ca                	mv	a1,s2
ffffffffc0205cce:	854e                	mv	a0,s3
ffffffffc0205cd0:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205cd2:	fc65                	bnez	s0,ffffffffc0205cca <printnum+0x32>
ffffffffc0205cd4:	00003417          	auipc	s0,0x3
ffffffffc0205cd8:	e2c40413          	addi	s0,s0,-468 # ffffffffc0208b00 <syscalls+0x800>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205cdc:	1a02                	slli	s4,s4,0x20
ffffffffc0205cde:	020a5a13          	srli	s4,s4,0x20
ffffffffc0205ce2:	9452                	add	s0,s0,s4
ffffffffc0205ce4:	00044503          	lbu	a0,0(s0)
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0205ce8:	7442                	ld	s0,48(sp)
ffffffffc0205cea:	70e2                	ld	ra,56(sp)
ffffffffc0205cec:	69e2                	ld	s3,24(sp)
ffffffffc0205cee:	6a42                	ld	s4,16(sp)
ffffffffc0205cf0:	6aa2                	ld	s5,8(sp)
ffffffffc0205cf2:	6b02                	ld	s6,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205cf4:	85ca                	mv	a1,s2
ffffffffc0205cf6:	87a6                	mv	a5,s1
}
ffffffffc0205cf8:	7902                	ld	s2,32(sp)
ffffffffc0205cfa:	74a2                	ld	s1,40(sp)
ffffffffc0205cfc:	6121                	addi	sp,sp,64
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205cfe:	8782                	jr	a5
    unsigned mod = do_div(result, base);
ffffffffc0205d00:	03065633          	divu	a2,a2,a6
ffffffffc0205d04:	03067ab3          	remu	s5,a2,a6
ffffffffc0205d08:	2a81                	sext.w	s5,s5
    if (num >= base) {
ffffffffc0205d0a:	03067863          	bgeu	a2,a6,ffffffffc0205d3a <printnum+0xa2>
        while (-- width > 0)
ffffffffc0205d0e:	ffe7041b          	addiw	s0,a4,-2
ffffffffc0205d12:	00805763          	blez	s0,ffffffffc0205d20 <printnum+0x88>
ffffffffc0205d16:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205d18:	85ca                	mv	a1,s2
ffffffffc0205d1a:	854e                	mv	a0,s3
ffffffffc0205d1c:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205d1e:	fc65                	bnez	s0,ffffffffc0205d16 <printnum+0x7e>
ffffffffc0205d20:	00003417          	auipc	s0,0x3
ffffffffc0205d24:	de040413          	addi	s0,s0,-544 # ffffffffc0208b00 <syscalls+0x800>
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205d28:	1a82                	slli	s5,s5,0x20
ffffffffc0205d2a:	020ada93          	srli	s5,s5,0x20
ffffffffc0205d2e:	9aa2                	add	s5,s5,s0
ffffffffc0205d30:	000ac503          	lbu	a0,0(s5)
ffffffffc0205d34:	85ca                	mv	a1,s2
ffffffffc0205d36:	9482                	jalr	s1
}
ffffffffc0205d38:	b755                	j	ffffffffc0205cdc <printnum+0x44>
    unsigned mod = do_div(result, base);
ffffffffc0205d3a:	03065633          	divu	a2,a2,a6
        while (-- width > 0)
ffffffffc0205d3e:	ffd7041b          	addiw	s0,a4,-3
    unsigned mod = do_div(result, base);
ffffffffc0205d42:	03067b33          	remu	s6,a2,a6
ffffffffc0205d46:	2b01                	sext.w	s6,s6
    if (num >= base) {
ffffffffc0205d48:	03067663          	bgeu	a2,a6,ffffffffc0205d74 <printnum+0xdc>
        while (-- width > 0)
ffffffffc0205d4c:	00805763          	blez	s0,ffffffffc0205d5a <printnum+0xc2>
ffffffffc0205d50:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205d52:	85ca                	mv	a1,s2
ffffffffc0205d54:	854e                	mv	a0,s3
ffffffffc0205d56:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205d58:	fc65                	bnez	s0,ffffffffc0205d50 <printnum+0xb8>
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205d5a:	1b02                	slli	s6,s6,0x20
ffffffffc0205d5c:	00003417          	auipc	s0,0x3
ffffffffc0205d60:	da440413          	addi	s0,s0,-604 # ffffffffc0208b00 <syscalls+0x800>
ffffffffc0205d64:	020b5b13          	srli	s6,s6,0x20
ffffffffc0205d68:	9b22                	add	s6,s6,s0
ffffffffc0205d6a:	000b4503          	lbu	a0,0(s6)
ffffffffc0205d6e:	85ca                	mv	a1,s2
ffffffffc0205d70:	9482                	jalr	s1
}
ffffffffc0205d72:	bf5d                	j	ffffffffc0205d28 <printnum+0x90>
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205d74:	03065633          	divu	a2,a2,a6
ffffffffc0205d78:	8722                	mv	a4,s0
ffffffffc0205d7a:	f1fff0ef          	jal	ra,ffffffffc0205c98 <printnum>
ffffffffc0205d7e:	bff1                	j	ffffffffc0205d5a <printnum+0xc2>

ffffffffc0205d80 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0205d80:	7119                	addi	sp,sp,-128
ffffffffc0205d82:	f4a6                	sd	s1,104(sp)
ffffffffc0205d84:	f0ca                	sd	s2,96(sp)
ffffffffc0205d86:	ecce                	sd	s3,88(sp)
ffffffffc0205d88:	e8d2                	sd	s4,80(sp)
ffffffffc0205d8a:	e4d6                	sd	s5,72(sp)
ffffffffc0205d8c:	e0da                	sd	s6,64(sp)
ffffffffc0205d8e:	fc5e                	sd	s7,56(sp)
ffffffffc0205d90:	f466                	sd	s9,40(sp)
ffffffffc0205d92:	fc86                	sd	ra,120(sp)
ffffffffc0205d94:	f8a2                	sd	s0,112(sp)
ffffffffc0205d96:	f862                	sd	s8,48(sp)
ffffffffc0205d98:	f06a                	sd	s10,32(sp)
ffffffffc0205d9a:	ec6e                	sd	s11,24(sp)
ffffffffc0205d9c:	892a                	mv	s2,a0
ffffffffc0205d9e:	84ae                	mv	s1,a1
ffffffffc0205da0:	8cb2                	mv	s9,a2
ffffffffc0205da2:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205da4:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0205da8:	5bfd                	li	s7,-1
ffffffffc0205daa:	00003a97          	auipc	s5,0x3
ffffffffc0205dae:	d82a8a93          	addi	s5,s5,-638 # ffffffffc0208b2c <syscalls+0x82c>
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205db2:	00003b17          	auipc	s6,0x3
ffffffffc0205db6:	d4eb0b13          	addi	s6,s6,-690 # ffffffffc0208b00 <syscalls+0x800>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205dba:	000cc503          	lbu	a0,0(s9)
ffffffffc0205dbe:	001c8413          	addi	s0,s9,1
ffffffffc0205dc2:	01350a63          	beq	a0,s3,ffffffffc0205dd6 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0205dc6:	c121                	beqz	a0,ffffffffc0205e06 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0205dc8:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205dca:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0205dcc:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205dce:	fff44503          	lbu	a0,-1(s0)
ffffffffc0205dd2:	ff351ae3          	bne	a0,s3,ffffffffc0205dc6 <vprintfmt+0x46>
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205dd6:	00044683          	lbu	a3,0(s0)
        char padc = ' ';
ffffffffc0205dda:	02000813          	li	a6,32
        lflag = altflag = 0;
ffffffffc0205dde:	4d81                	li	s11,0
ffffffffc0205de0:	4501                	li	a0,0
        width = precision = -1;
ffffffffc0205de2:	5c7d                	li	s8,-1
ffffffffc0205de4:	5d7d                	li	s10,-1
ffffffffc0205de6:	05500613          	li	a2,85
        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
ffffffffc0205dea:	45a5                	li	a1,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205dec:	fdd6879b          	addiw	a5,a3,-35
ffffffffc0205df0:	0ff7f793          	zext.b	a5,a5
ffffffffc0205df4:	00140c93          	addi	s9,s0,1
ffffffffc0205df8:	04f66263          	bltu	a2,a5,ffffffffc0205e3c <vprintfmt+0xbc>
ffffffffc0205dfc:	078a                	slli	a5,a5,0x2
ffffffffc0205dfe:	97d6                	add	a5,a5,s5
ffffffffc0205e00:	439c                	lw	a5,0(a5)
ffffffffc0205e02:	97d6                	add	a5,a5,s5
ffffffffc0205e04:	8782                	jr	a5
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205e06:	70e6                	ld	ra,120(sp)
ffffffffc0205e08:	7446                	ld	s0,112(sp)
ffffffffc0205e0a:	74a6                	ld	s1,104(sp)
ffffffffc0205e0c:	7906                	ld	s2,96(sp)
ffffffffc0205e0e:	69e6                	ld	s3,88(sp)
ffffffffc0205e10:	6a46                	ld	s4,80(sp)
ffffffffc0205e12:	6aa6                	ld	s5,72(sp)
ffffffffc0205e14:	6b06                	ld	s6,64(sp)
ffffffffc0205e16:	7be2                	ld	s7,56(sp)
ffffffffc0205e18:	7c42                	ld	s8,48(sp)
ffffffffc0205e1a:	7ca2                	ld	s9,40(sp)
ffffffffc0205e1c:	7d02                	ld	s10,32(sp)
ffffffffc0205e1e:	6de2                	ld	s11,24(sp)
ffffffffc0205e20:	6109                	addi	sp,sp,128
ffffffffc0205e22:	8082                	ret
            padc = '0';
ffffffffc0205e24:	8836                	mv	a6,a3
            goto reswitch;
ffffffffc0205e26:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205e2a:	8466                	mv	s0,s9
ffffffffc0205e2c:	00140c93          	addi	s9,s0,1
ffffffffc0205e30:	fdd6879b          	addiw	a5,a3,-35
ffffffffc0205e34:	0ff7f793          	zext.b	a5,a5
ffffffffc0205e38:	fcf672e3          	bgeu	a2,a5,ffffffffc0205dfc <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0205e3c:	85a6                	mv	a1,s1
ffffffffc0205e3e:	02500513          	li	a0,37
ffffffffc0205e42:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205e44:	fff44783          	lbu	a5,-1(s0)
ffffffffc0205e48:	8ca2                	mv	s9,s0
ffffffffc0205e4a:	f73788e3          	beq	a5,s3,ffffffffc0205dba <vprintfmt+0x3a>
ffffffffc0205e4e:	ffecc783          	lbu	a5,-2(s9)
ffffffffc0205e52:	1cfd                	addi	s9,s9,-1
ffffffffc0205e54:	ff379de3          	bne	a5,s3,ffffffffc0205e4e <vprintfmt+0xce>
ffffffffc0205e58:	b78d                	j	ffffffffc0205dba <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0205e5a:	fd068c1b          	addiw	s8,a3,-48
                ch = *fmt;
ffffffffc0205e5e:	00144683          	lbu	a3,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205e62:	8466                	mv	s0,s9
                if (ch < '0' || ch > '9') {
ffffffffc0205e64:	fd06879b          	addiw	a5,a3,-48
                ch = *fmt;
ffffffffc0205e68:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
ffffffffc0205e6c:	02f5e563          	bltu	a1,a5,ffffffffc0205e96 <vprintfmt+0x116>
                ch = *fmt;
ffffffffc0205e70:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0205e74:	002c179b          	slliw	a5,s8,0x2
ffffffffc0205e78:	0187873b          	addw	a4,a5,s8
ffffffffc0205e7c:	0017171b          	slliw	a4,a4,0x1
ffffffffc0205e80:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
ffffffffc0205e84:	fd06879b          	addiw	a5,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0205e88:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0205e8a:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0205e8e:	0006889b          	sext.w	a7,a3
                if (ch < '0' || ch > '9') {
ffffffffc0205e92:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0205e70 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0205e96:	f40d5be3          	bgez	s10,ffffffffc0205dec <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0205e9a:	8d62                	mv	s10,s8
ffffffffc0205e9c:	5c7d                	li	s8,-1
ffffffffc0205e9e:	b7b9                	j	ffffffffc0205dec <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0205ea0:	fffd4793          	not	a5,s10
ffffffffc0205ea4:	97fd                	srai	a5,a5,0x3f
ffffffffc0205ea6:	00fd7d33          	and	s10,s10,a5
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205eaa:	00144683          	lbu	a3,1(s0)
ffffffffc0205eae:	2d01                	sext.w	s10,s10
ffffffffc0205eb0:	8466                	mv	s0,s9
            goto reswitch;
ffffffffc0205eb2:	bf2d                	j	ffffffffc0205dec <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0205eb4:	000a2c03          	lw	s8,0(s4) # 2000 <_binary_obj___user_faultread_out_size-0xf3a8>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205eb8:	00144683          	lbu	a3,1(s0)
            precision = va_arg(ap, int);
ffffffffc0205ebc:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205ebe:	8466                	mv	s0,s9
            goto process_precision;
ffffffffc0205ec0:	bfd9                	j	ffffffffc0205e96 <vprintfmt+0x116>
    if (lflag >= 2) {
ffffffffc0205ec2:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0205ec4:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc0205ec8:	00a7c463          	blt	a5,a0,ffffffffc0205ed0 <vprintfmt+0x150>
    else if (lflag) {
ffffffffc0205ecc:	28050a63          	beqz	a0,ffffffffc0206160 <vprintfmt+0x3e0>
        return va_arg(*ap, unsigned long);
ffffffffc0205ed0:	000a3783          	ld	a5,0(s4)
ffffffffc0205ed4:	4641                	li	a2,16
ffffffffc0205ed6:	8a3a                	mv	s4,a4
ffffffffc0205ed8:	46c1                	li	a3,16
    unsigned mod = do_div(result, base);
ffffffffc0205eda:	02c7fdb3          	remu	s11,a5,a2
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205ede:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
ffffffffc0205ee2:	0ac7f563          	bgeu	a5,a2,ffffffffc0205f8c <vprintfmt+0x20c>
        while (-- width > 0)
ffffffffc0205ee6:	3d7d                	addiw	s10,s10,-1
ffffffffc0205ee8:	01a05863          	blez	s10,ffffffffc0205ef8 <vprintfmt+0x178>
ffffffffc0205eec:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
ffffffffc0205eee:	85a6                	mv	a1,s1
ffffffffc0205ef0:	8562                	mv	a0,s8
ffffffffc0205ef2:	9902                	jalr	s2
        while (-- width > 0)
ffffffffc0205ef4:	fe0d1ce3          	bnez	s10,ffffffffc0205eec <vprintfmt+0x16c>
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205ef8:	9dda                	add	s11,s11,s6
ffffffffc0205efa:	000dc503          	lbu	a0,0(s11)
ffffffffc0205efe:	85a6                	mv	a1,s1
ffffffffc0205f00:	9902                	jalr	s2
}
ffffffffc0205f02:	bd65                	j	ffffffffc0205dba <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0205f04:	000a2503          	lw	a0,0(s4)
ffffffffc0205f08:	85a6                	mv	a1,s1
ffffffffc0205f0a:	0a21                	addi	s4,s4,8
ffffffffc0205f0c:	9902                	jalr	s2
            break;
ffffffffc0205f0e:	b575                	j	ffffffffc0205dba <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0205f10:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0205f12:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc0205f16:	00a7c463          	blt	a5,a0,ffffffffc0205f1e <vprintfmt+0x19e>
    else if (lflag) {
ffffffffc0205f1a:	22050d63          	beqz	a0,ffffffffc0206154 <vprintfmt+0x3d4>
        return va_arg(*ap, unsigned long);
ffffffffc0205f1e:	000a3783          	ld	a5,0(s4)
ffffffffc0205f22:	4629                	li	a2,10
ffffffffc0205f24:	8a3a                	mv	s4,a4
ffffffffc0205f26:	46a9                	li	a3,10
ffffffffc0205f28:	bf4d                	j	ffffffffc0205eda <vprintfmt+0x15a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205f2a:	00144683          	lbu	a3,1(s0)
            altflag = 1;
ffffffffc0205f2e:	4d85                	li	s11,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205f30:	8466                	mv	s0,s9
            goto reswitch;
ffffffffc0205f32:	bd6d                	j	ffffffffc0205dec <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0205f34:	85a6                	mv	a1,s1
ffffffffc0205f36:	02500513          	li	a0,37
ffffffffc0205f3a:	9902                	jalr	s2
            break;
ffffffffc0205f3c:	bdbd                	j	ffffffffc0205dba <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205f3e:	00144683          	lbu	a3,1(s0)
            lflag ++;
ffffffffc0205f42:	2505                	addiw	a0,a0,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205f44:	8466                	mv	s0,s9
            goto reswitch;
ffffffffc0205f46:	b55d                	j	ffffffffc0205dec <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0205f48:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0205f4a:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc0205f4e:	00a7c463          	blt	a5,a0,ffffffffc0205f56 <vprintfmt+0x1d6>
    else if (lflag) {
ffffffffc0205f52:	1e050b63          	beqz	a0,ffffffffc0206148 <vprintfmt+0x3c8>
        return va_arg(*ap, unsigned long);
ffffffffc0205f56:	000a3783          	ld	a5,0(s4)
ffffffffc0205f5a:	4621                	li	a2,8
ffffffffc0205f5c:	8a3a                	mv	s4,a4
ffffffffc0205f5e:	46a1                	li	a3,8
ffffffffc0205f60:	bfad                	j	ffffffffc0205eda <vprintfmt+0x15a>
            putch('0', putdat);
ffffffffc0205f62:	03000513          	li	a0,48
ffffffffc0205f66:	85a6                	mv	a1,s1
ffffffffc0205f68:	e042                	sd	a6,0(sp)
ffffffffc0205f6a:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0205f6c:	85a6                	mv	a1,s1
ffffffffc0205f6e:	07800513          	li	a0,120
ffffffffc0205f72:	9902                	jalr	s2
            goto number;
ffffffffc0205f74:	6802                	ld	a6,0(sp)
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205f76:	000a3783          	ld	a5,0(s4)
            goto number;
ffffffffc0205f7a:	4641                	li	a2,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205f7c:	0a21                	addi	s4,s4,8
    unsigned mod = do_div(result, base);
ffffffffc0205f7e:	02c7fdb3          	remu	s11,a5,a2
            goto number;
ffffffffc0205f82:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205f84:	00080c1b          	sext.w	s8,a6
    if (num >= base) {
ffffffffc0205f88:	f4c7efe3          	bltu	a5,a2,ffffffffc0205ee6 <vprintfmt+0x166>
        while (-- width > 0)
ffffffffc0205f8c:	3d79                	addiw	s10,s10,-2
    unsigned mod = do_div(result, base);
ffffffffc0205f8e:	02c7d7b3          	divu	a5,a5,a2
ffffffffc0205f92:	02c7f433          	remu	s0,a5,a2
    if (num >= base) {
ffffffffc0205f96:	10c7f463          	bgeu	a5,a2,ffffffffc020609e <vprintfmt+0x31e>
        while (-- width > 0)
ffffffffc0205f9a:	01a05863          	blez	s10,ffffffffc0205faa <vprintfmt+0x22a>
ffffffffc0205f9e:	3d7d                	addiw	s10,s10,-1
            putch(padc, putdat);
ffffffffc0205fa0:	85a6                	mv	a1,s1
ffffffffc0205fa2:	8562                	mv	a0,s8
ffffffffc0205fa4:	9902                	jalr	s2
        while (-- width > 0)
ffffffffc0205fa6:	fe0d1ce3          	bnez	s10,ffffffffc0205f9e <vprintfmt+0x21e>
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205faa:	945a                	add	s0,s0,s6
ffffffffc0205fac:	00044503          	lbu	a0,0(s0)
ffffffffc0205fb0:	85a6                	mv	a1,s1
ffffffffc0205fb2:	9dda                	add	s11,s11,s6
ffffffffc0205fb4:	9902                	jalr	s2
ffffffffc0205fb6:	000dc503          	lbu	a0,0(s11)
ffffffffc0205fba:	85a6                	mv	a1,s1
ffffffffc0205fbc:	9902                	jalr	s2
ffffffffc0205fbe:	bbf5                	j	ffffffffc0205dba <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205fc0:	000a3403          	ld	s0,0(s4)
ffffffffc0205fc4:	008a0793          	addi	a5,s4,8
ffffffffc0205fc8:	e43e                	sd	a5,8(sp)
ffffffffc0205fca:	1e040563          	beqz	s0,ffffffffc02061b4 <vprintfmt+0x434>
            if (width > 0 && padc != '-') {
ffffffffc0205fce:	15a05263          	blez	s10,ffffffffc0206112 <vprintfmt+0x392>
ffffffffc0205fd2:	02d00793          	li	a5,45
ffffffffc0205fd6:	10f81b63          	bne	a6,a5,ffffffffc02060ec <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205fda:	00044783          	lbu	a5,0(s0)
ffffffffc0205fde:	0007851b          	sext.w	a0,a5
ffffffffc0205fe2:	0e078c63          	beqz	a5,ffffffffc02060da <vprintfmt+0x35a>
ffffffffc0205fe6:	0405                	addi	s0,s0,1
ffffffffc0205fe8:	120d8e63          	beqz	s11,ffffffffc0206124 <vprintfmt+0x3a4>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205fec:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205ff0:	020c4963          	bltz	s8,ffffffffc0206022 <vprintfmt+0x2a2>
ffffffffc0205ff4:	fffc0a1b          	addiw	s4,s8,-1
ffffffffc0205ff8:	0d7a0f63          	beq	s4,s7,ffffffffc02060d6 <vprintfmt+0x356>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205ffc:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
ffffffffc0205ffe:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0206000:	02fdf663          	bgeu	s11,a5,ffffffffc020602c <vprintfmt+0x2ac>
                    putch('?', putdat);
ffffffffc0206004:	03f00513          	li	a0,63
ffffffffc0206008:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020600a:	00044783          	lbu	a5,0(s0)
ffffffffc020600e:	3d7d                	addiw	s10,s10,-1
ffffffffc0206010:	0405                	addi	s0,s0,1
ffffffffc0206012:	0007851b          	sext.w	a0,a5
ffffffffc0206016:	c3e1                	beqz	a5,ffffffffc02060d6 <vprintfmt+0x356>
ffffffffc0206018:	140c4a63          	bltz	s8,ffffffffc020616c <vprintfmt+0x3ec>
ffffffffc020601c:	8c52                	mv	s8,s4
ffffffffc020601e:	fc0c5be3          	bgez	s8,ffffffffc0205ff4 <vprintfmt+0x274>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0206022:	3781                	addiw	a5,a5,-32
ffffffffc0206024:	8a62                	mv	s4,s8
                    putch('?', putdat);
ffffffffc0206026:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0206028:	fcfdeee3          	bltu	s11,a5,ffffffffc0206004 <vprintfmt+0x284>
                    putch(ch, putdat);
ffffffffc020602c:	9902                	jalr	s2
ffffffffc020602e:	bff1                	j	ffffffffc020600a <vprintfmt+0x28a>
    if (lflag >= 2) {
ffffffffc0206030:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0206032:	008a0d93          	addi	s11,s4,8
    if (lflag >= 2) {
ffffffffc0206036:	00a7c463          	blt	a5,a0,ffffffffc020603e <vprintfmt+0x2be>
    else if (lflag) {
ffffffffc020603a:	10050463          	beqz	a0,ffffffffc0206142 <vprintfmt+0x3c2>
        return va_arg(*ap, long);
ffffffffc020603e:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0206042:	14044d63          	bltz	s0,ffffffffc020619c <vprintfmt+0x41c>
            num = getint(&ap, lflag);
ffffffffc0206046:	87a2                	mv	a5,s0
ffffffffc0206048:	8a6e                	mv	s4,s11
ffffffffc020604a:	4629                	li	a2,10
ffffffffc020604c:	46a9                	li	a3,10
ffffffffc020604e:	b571                	j	ffffffffc0205eda <vprintfmt+0x15a>
            err = va_arg(ap, int);
ffffffffc0206050:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0206054:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc0206056:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0206058:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc020605c:	8fb5                	xor	a5,a5,a3
ffffffffc020605e:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0206062:	02d74563          	blt	a4,a3,ffffffffc020608c <vprintfmt+0x30c>
ffffffffc0206066:	00369713          	slli	a4,a3,0x3
ffffffffc020606a:	00003797          	auipc	a5,0x3
ffffffffc020606e:	cde78793          	addi	a5,a5,-802 # ffffffffc0208d48 <error_string>
ffffffffc0206072:	97ba                	add	a5,a5,a4
ffffffffc0206074:	639c                	ld	a5,0(a5)
ffffffffc0206076:	cb99                	beqz	a5,ffffffffc020608c <vprintfmt+0x30c>
                printfmt(putch, putdat, "%s", p);
ffffffffc0206078:	86be                	mv	a3,a5
ffffffffc020607a:	00000617          	auipc	a2,0x0
ffffffffc020607e:	4ae60613          	addi	a2,a2,1198 # ffffffffc0206528 <etext+0x28>
ffffffffc0206082:	85a6                	mv	a1,s1
ffffffffc0206084:	854a                	mv	a0,s2
ffffffffc0206086:	160000ef          	jal	ra,ffffffffc02061e6 <printfmt>
ffffffffc020608a:	bb05                	j	ffffffffc0205dba <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc020608c:	00003617          	auipc	a2,0x3
ffffffffc0206090:	a9460613          	addi	a2,a2,-1388 # ffffffffc0208b20 <syscalls+0x820>
ffffffffc0206094:	85a6                	mv	a1,s1
ffffffffc0206096:	854a                	mv	a0,s2
ffffffffc0206098:	14e000ef          	jal	ra,ffffffffc02061e6 <printfmt>
ffffffffc020609c:	bb39                	j	ffffffffc0205dba <vprintfmt+0x3a>
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc020609e:	02c7d633          	divu	a2,a5,a2
ffffffffc02060a2:	876a                	mv	a4,s10
ffffffffc02060a4:	87e2                	mv	a5,s8
ffffffffc02060a6:	85a6                	mv	a1,s1
ffffffffc02060a8:	854a                	mv	a0,s2
ffffffffc02060aa:	befff0ef          	jal	ra,ffffffffc0205c98 <printnum>
ffffffffc02060ae:	bdf5                	j	ffffffffc0205faa <vprintfmt+0x22a>
                    putch(ch, putdat);
ffffffffc02060b0:	85a6                	mv	a1,s1
ffffffffc02060b2:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02060b4:	00044503          	lbu	a0,0(s0)
ffffffffc02060b8:	3d7d                	addiw	s10,s10,-1
ffffffffc02060ba:	0405                	addi	s0,s0,1
ffffffffc02060bc:	cd09                	beqz	a0,ffffffffc02060d6 <vprintfmt+0x356>
ffffffffc02060be:	008d0d3b          	addw	s10,s10,s0
ffffffffc02060c2:	fffd0d9b          	addiw	s11,s10,-1
                    putch(ch, putdat);
ffffffffc02060c6:	85a6                	mv	a1,s1
ffffffffc02060c8:	408d8d3b          	subw	s10,s11,s0
ffffffffc02060cc:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02060ce:	00044503          	lbu	a0,0(s0)
ffffffffc02060d2:	0405                	addi	s0,s0,1
ffffffffc02060d4:	f96d                	bnez	a0,ffffffffc02060c6 <vprintfmt+0x346>
            for (; width > 0; width --) {
ffffffffc02060d6:	01a05963          	blez	s10,ffffffffc02060e8 <vprintfmt+0x368>
ffffffffc02060da:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc02060dc:	85a6                	mv	a1,s1
ffffffffc02060de:	02000513          	li	a0,32
ffffffffc02060e2:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02060e4:	fe0d1be3          	bnez	s10,ffffffffc02060da <vprintfmt+0x35a>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02060e8:	6a22                	ld	s4,8(sp)
ffffffffc02060ea:	b9c1                	j	ffffffffc0205dba <vprintfmt+0x3a>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02060ec:	85e2                	mv	a1,s8
ffffffffc02060ee:	8522                	mv	a0,s0
ffffffffc02060f0:	e042                	sd	a6,0(sp)
ffffffffc02060f2:	12e000ef          	jal	ra,ffffffffc0206220 <strnlen>
ffffffffc02060f6:	40ad0d3b          	subw	s10,s10,a0
ffffffffc02060fa:	01a05c63          	blez	s10,ffffffffc0206112 <vprintfmt+0x392>
                    putch(padc, putdat);
ffffffffc02060fe:	6802                	ld	a6,0(sp)
ffffffffc0206100:	0008051b          	sext.w	a0,a6
ffffffffc0206104:	85a6                	mv	a1,s1
ffffffffc0206106:	e02a                	sd	a0,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0206108:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc020610a:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020610c:	6502                	ld	a0,0(sp)
ffffffffc020610e:	fe0d1be3          	bnez	s10,ffffffffc0206104 <vprintfmt+0x384>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0206112:	00044783          	lbu	a5,0(s0)
ffffffffc0206116:	0405                	addi	s0,s0,1
ffffffffc0206118:	0007851b          	sext.w	a0,a5
ffffffffc020611c:	ec0796e3          	bnez	a5,ffffffffc0205fe8 <vprintfmt+0x268>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0206120:	6a22                	ld	s4,8(sp)
ffffffffc0206122:	b961                	j	ffffffffc0205dba <vprintfmt+0x3a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0206124:	f80c46e3          	bltz	s8,ffffffffc02060b0 <vprintfmt+0x330>
ffffffffc0206128:	3c7d                	addiw	s8,s8,-1
ffffffffc020612a:	fb7c06e3          	beq	s8,s7,ffffffffc02060d6 <vprintfmt+0x356>
                    putch(ch, putdat);
ffffffffc020612e:	85a6                	mv	a1,s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0206130:	0405                	addi	s0,s0,1
                    putch(ch, putdat);
ffffffffc0206132:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0206134:	fff44503          	lbu	a0,-1(s0)
ffffffffc0206138:	3d7d                	addiw	s10,s10,-1
ffffffffc020613a:	f56d                	bnez	a0,ffffffffc0206124 <vprintfmt+0x3a4>
            for (; width > 0; width --) {
ffffffffc020613c:	f9a04fe3          	bgtz	s10,ffffffffc02060da <vprintfmt+0x35a>
ffffffffc0206140:	b765                	j	ffffffffc02060e8 <vprintfmt+0x368>
        return va_arg(*ap, int);
ffffffffc0206142:	000a2403          	lw	s0,0(s4)
ffffffffc0206146:	bdf5                	j	ffffffffc0206042 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned int);
ffffffffc0206148:	000a6783          	lwu	a5,0(s4)
ffffffffc020614c:	4621                	li	a2,8
ffffffffc020614e:	8a3a                	mv	s4,a4
ffffffffc0206150:	46a1                	li	a3,8
ffffffffc0206152:	b361                	j	ffffffffc0205eda <vprintfmt+0x15a>
ffffffffc0206154:	000a6783          	lwu	a5,0(s4)
ffffffffc0206158:	4629                	li	a2,10
ffffffffc020615a:	8a3a                	mv	s4,a4
ffffffffc020615c:	46a9                	li	a3,10
ffffffffc020615e:	bbb5                	j	ffffffffc0205eda <vprintfmt+0x15a>
ffffffffc0206160:	000a6783          	lwu	a5,0(s4)
ffffffffc0206164:	4641                	li	a2,16
ffffffffc0206166:	8a3a                	mv	s4,a4
ffffffffc0206168:	46c1                	li	a3,16
ffffffffc020616a:	bb85                	j	ffffffffc0205eda <vprintfmt+0x15a>
ffffffffc020616c:	01a40d3b          	addw	s10,s0,s10
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0206170:	05e00d93          	li	s11,94
ffffffffc0206174:	3d7d                	addiw	s10,s10,-1
ffffffffc0206176:	3781                	addiw	a5,a5,-32
                    putch('?', putdat);
ffffffffc0206178:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020617a:	00fdf463          	bgeu	s11,a5,ffffffffc0206182 <vprintfmt+0x402>
                    putch('?', putdat);
ffffffffc020617e:	03f00513          	li	a0,63
ffffffffc0206182:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0206184:	00044783          	lbu	a5,0(s0)
ffffffffc0206188:	408d073b          	subw	a4,s10,s0
ffffffffc020618c:	0405                	addi	s0,s0,1
ffffffffc020618e:	0007851b          	sext.w	a0,a5
ffffffffc0206192:	f3f5                	bnez	a5,ffffffffc0206176 <vprintfmt+0x3f6>
ffffffffc0206194:	8d3a                	mv	s10,a4
            for (; width > 0; width --) {
ffffffffc0206196:	f5a042e3          	bgtz	s10,ffffffffc02060da <vprintfmt+0x35a>
ffffffffc020619a:	b7b9                	j	ffffffffc02060e8 <vprintfmt+0x368>
                putch('-', putdat);
ffffffffc020619c:	85a6                	mv	a1,s1
ffffffffc020619e:	02d00513          	li	a0,45
ffffffffc02061a2:	e042                	sd	a6,0(sp)
ffffffffc02061a4:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02061a6:	6802                	ld	a6,0(sp)
ffffffffc02061a8:	8a6e                	mv	s4,s11
ffffffffc02061aa:	408007b3          	neg	a5,s0
ffffffffc02061ae:	4629                	li	a2,10
ffffffffc02061b0:	46a9                	li	a3,10
ffffffffc02061b2:	b325                	j	ffffffffc0205eda <vprintfmt+0x15a>
            if (width > 0 && padc != '-') {
ffffffffc02061b4:	03a05063          	blez	s10,ffffffffc02061d4 <vprintfmt+0x454>
ffffffffc02061b8:	02d00793          	li	a5,45
                p = "(null)";
ffffffffc02061bc:	00003417          	auipc	s0,0x3
ffffffffc02061c0:	95c40413          	addi	s0,s0,-1700 # ffffffffc0208b18 <syscalls+0x818>
            if (width > 0 && padc != '-') {
ffffffffc02061c4:	f2f814e3          	bne	a6,a5,ffffffffc02060ec <vprintfmt+0x36c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02061c8:	02800793          	li	a5,40
ffffffffc02061cc:	02800513          	li	a0,40
ffffffffc02061d0:	0405                	addi	s0,s0,1
ffffffffc02061d2:	bd19                	j	ffffffffc0205fe8 <vprintfmt+0x268>
ffffffffc02061d4:	02800513          	li	a0,40
ffffffffc02061d8:	02800793          	li	a5,40
ffffffffc02061dc:	00003417          	auipc	s0,0x3
ffffffffc02061e0:	93d40413          	addi	s0,s0,-1731 # ffffffffc0208b19 <syscalls+0x819>
ffffffffc02061e4:	b511                	j	ffffffffc0205fe8 <vprintfmt+0x268>

ffffffffc02061e6 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02061e6:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02061e8:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02061ec:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02061ee:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02061f0:	ec06                	sd	ra,24(sp)
ffffffffc02061f2:	f83a                	sd	a4,48(sp)
ffffffffc02061f4:	fc3e                	sd	a5,56(sp)
ffffffffc02061f6:	e0c2                	sd	a6,64(sp)
ffffffffc02061f8:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02061fa:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02061fc:	b85ff0ef          	jal	ra,ffffffffc0205d80 <vprintfmt>
}
ffffffffc0206200:	60e2                	ld	ra,24(sp)
ffffffffc0206202:	6161                	addi	sp,sp,80
ffffffffc0206204:	8082                	ret

ffffffffc0206206 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0206206:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc020620a:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc020620c:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc020620e:	cb81                	beqz	a5,ffffffffc020621e <strlen+0x18>
        cnt ++;
ffffffffc0206210:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0206212:	00a707b3          	add	a5,a4,a0
ffffffffc0206216:	0007c783          	lbu	a5,0(a5)
ffffffffc020621a:	fbfd                	bnez	a5,ffffffffc0206210 <strlen+0xa>
ffffffffc020621c:	8082                	ret
    }
    return cnt;
}
ffffffffc020621e:	8082                	ret

ffffffffc0206220 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0206220:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0206222:	e589                	bnez	a1,ffffffffc020622c <strnlen+0xc>
ffffffffc0206224:	a811                	j	ffffffffc0206238 <strnlen+0x18>
        cnt ++;
ffffffffc0206226:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0206228:	00f58863          	beq	a1,a5,ffffffffc0206238 <strnlen+0x18>
ffffffffc020622c:	00f50733          	add	a4,a0,a5
ffffffffc0206230:	00074703          	lbu	a4,0(a4)
ffffffffc0206234:	fb6d                	bnez	a4,ffffffffc0206226 <strnlen+0x6>
ffffffffc0206236:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0206238:	852e                	mv	a0,a1
ffffffffc020623a:	8082                	ret

ffffffffc020623c <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc020623c:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc020623e:	0005c703          	lbu	a4,0(a1)
ffffffffc0206242:	0785                	addi	a5,a5,1
ffffffffc0206244:	0585                	addi	a1,a1,1
ffffffffc0206246:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020624a:	fb75                	bnez	a4,ffffffffc020623e <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc020624c:	8082                	ret

ffffffffc020624e <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020624e:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0206252:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0206256:	cb99                	beqz	a5,ffffffffc020626c <strcmp+0x1e>
ffffffffc0206258:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc020625c:	0505                	addi	a0,a0,1
ffffffffc020625e:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0206260:	fef707e3          	beq	a4,a5,ffffffffc020624e <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0206264:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0206268:	9d19                	subw	a0,a0,a4
ffffffffc020626a:	8082                	ret
ffffffffc020626c:	4501                	li	a0,0
ffffffffc020626e:	bfed                	j	ffffffffc0206268 <strcmp+0x1a>

ffffffffc0206270 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0206270:	c20d                	beqz	a2,ffffffffc0206292 <strncmp+0x22>
ffffffffc0206272:	962e                	add	a2,a2,a1
ffffffffc0206274:	a031                	j	ffffffffc0206280 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0206276:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0206278:	00e79a63          	bne	a5,a4,ffffffffc020628c <strncmp+0x1c>
ffffffffc020627c:	00b60b63          	beq	a2,a1,ffffffffc0206292 <strncmp+0x22>
ffffffffc0206280:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0206284:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0206286:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020628a:	f7f5                	bnez	a5,ffffffffc0206276 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020628c:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0206290:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0206292:	4501                	li	a0,0
ffffffffc0206294:	8082                	ret

ffffffffc0206296 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0206296:	00054783          	lbu	a5,0(a0)
ffffffffc020629a:	c799                	beqz	a5,ffffffffc02062a8 <strchr+0x12>
        if (*s == c) {
ffffffffc020629c:	00f58763          	beq	a1,a5,ffffffffc02062aa <strchr+0x14>
    while (*s != '\0') {
ffffffffc02062a0:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02062a4:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02062a6:	fbfd                	bnez	a5,ffffffffc020629c <strchr+0x6>
    }
    return NULL;
ffffffffc02062a8:	4501                	li	a0,0
}
ffffffffc02062aa:	8082                	ret

ffffffffc02062ac <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
ffffffffc02062ac:	8eb2                	mv	t4,a2
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02062ae:	fff60e13          	addi	t3,a2,-1
ffffffffc02062b2:	16060863          	beqz	a2,ffffffffc0206422 <memset+0x176>
ffffffffc02062b6:	40a007b3          	neg	a5,a0
ffffffffc02062ba:	8b9d                	andi	a5,a5,7
ffffffffc02062bc:	00778713          	addi	a4,a5,7
ffffffffc02062c0:	46ad                	li	a3,11
ffffffffc02062c2:	16d76163          	bltu	a4,a3,ffffffffc0206424 <memset+0x178>
ffffffffc02062c6:	16ee6463          	bltu	t3,a4,ffffffffc020642e <memset+0x182>
ffffffffc02062ca:	16078063          	beqz	a5,ffffffffc020642a <memset+0x17e>
        *p ++ = c;
ffffffffc02062ce:	00b50023          	sb	a1,0(a0)
ffffffffc02062d2:	4705                	li	a4,1
ffffffffc02062d4:	00150f13          	addi	t5,a0,1
    while (n -- > 0) {
ffffffffc02062d8:	ffee8e13          	addi	t3,t4,-2 # 1ffe <_binary_obj___user_faultread_out_size-0xf3aa>
ffffffffc02062dc:	06e78563          	beq	a5,a4,ffffffffc0206346 <memset+0x9a>
        *p ++ = c;
ffffffffc02062e0:	00b500a3          	sb	a1,1(a0)
ffffffffc02062e4:	4709                	li	a4,2
ffffffffc02062e6:	00250f13          	addi	t5,a0,2
    while (n -- > 0) {
ffffffffc02062ea:	ffde8e13          	addi	t3,t4,-3
ffffffffc02062ee:	04e78c63          	beq	a5,a4,ffffffffc0206346 <memset+0x9a>
        *p ++ = c;
ffffffffc02062f2:	00b50123          	sb	a1,2(a0)
ffffffffc02062f6:	470d                	li	a4,3
ffffffffc02062f8:	00350f13          	addi	t5,a0,3
    while (n -- > 0) {
ffffffffc02062fc:	ffce8e13          	addi	t3,t4,-4
ffffffffc0206300:	04e78363          	beq	a5,a4,ffffffffc0206346 <memset+0x9a>
        *p ++ = c;
ffffffffc0206304:	00b501a3          	sb	a1,3(a0)
ffffffffc0206308:	4711                	li	a4,4
ffffffffc020630a:	00450f13          	addi	t5,a0,4
    while (n -- > 0) {
ffffffffc020630e:	ffbe8e13          	addi	t3,t4,-5
ffffffffc0206312:	02e78a63          	beq	a5,a4,ffffffffc0206346 <memset+0x9a>
        *p ++ = c;
ffffffffc0206316:	00b50223          	sb	a1,4(a0)
ffffffffc020631a:	4715                	li	a4,5
ffffffffc020631c:	00550f13          	addi	t5,a0,5
    while (n -- > 0) {
ffffffffc0206320:	ffae8e13          	addi	t3,t4,-6
ffffffffc0206324:	02e78163          	beq	a5,a4,ffffffffc0206346 <memset+0x9a>
        *p ++ = c;
ffffffffc0206328:	00b502a3          	sb	a1,5(a0)
ffffffffc020632c:	471d                	li	a4,7
ffffffffc020632e:	00650f13          	addi	t5,a0,6
    while (n -- > 0) {
ffffffffc0206332:	ff9e8e13          	addi	t3,t4,-7
ffffffffc0206336:	00e79863          	bne	a5,a4,ffffffffc0206346 <memset+0x9a>
        *p ++ = c;
ffffffffc020633a:	00750f13          	addi	t5,a0,7
ffffffffc020633e:	00b50323          	sb	a1,6(a0)
    while (n -- > 0) {
ffffffffc0206342:	ff8e8e13          	addi	t3,t4,-8
ffffffffc0206346:	00859713          	slli	a4,a1,0x8
ffffffffc020634a:	8f4d                	or	a4,a4,a1
ffffffffc020634c:	01059313          	slli	t1,a1,0x10
ffffffffc0206350:	00676333          	or	t1,a4,t1
ffffffffc0206354:	01859893          	slli	a7,a1,0x18
ffffffffc0206358:	02059813          	slli	a6,a1,0x20
ffffffffc020635c:	011368b3          	or	a7,t1,a7
ffffffffc0206360:	02859613          	slli	a2,a1,0x28
ffffffffc0206364:	0108e833          	or	a6,a7,a6
ffffffffc0206368:	40fe8eb3          	sub	t4,t4,a5
ffffffffc020636c:	00c86633          	or	a2,a6,a2
ffffffffc0206370:	03059693          	slli	a3,a1,0x30
ffffffffc0206374:	8ed1                	or	a3,a3,a2
ffffffffc0206376:	03859713          	slli	a4,a1,0x38
ffffffffc020637a:	97aa                	add	a5,a5,a0
ffffffffc020637c:	ff8ef613          	andi	a2,t4,-8
ffffffffc0206380:	8f55                	or	a4,a4,a3
ffffffffc0206382:	00f606b3          	add	a3,a2,a5
        *p ++ = c;
ffffffffc0206386:	e398                	sd	a4,0(a5)
    while (n -- > 0) {
ffffffffc0206388:	07a1                	addi	a5,a5,8
ffffffffc020638a:	fed79ee3          	bne	a5,a3,ffffffffc0206386 <memset+0xda>
ffffffffc020638e:	ff8ef713          	andi	a4,t4,-8
ffffffffc0206392:	00ef07b3          	add	a5,t5,a4
ffffffffc0206396:	40ee0e33          	sub	t3,t3,a4
ffffffffc020639a:	08ee8763          	beq	t4,a4,ffffffffc0206428 <memset+0x17c>
        *p ++ = c;
ffffffffc020639e:	00b78023          	sb	a1,0(a5)
    while (n -- > 0) {
ffffffffc02063a2:	080e0063          	beqz	t3,ffffffffc0206422 <memset+0x176>
        *p ++ = c;
ffffffffc02063a6:	00b780a3          	sb	a1,1(a5)
    while (n -- > 0) {
ffffffffc02063aa:	4705                	li	a4,1
ffffffffc02063ac:	06ee0b63          	beq	t3,a4,ffffffffc0206422 <memset+0x176>
        *p ++ = c;
ffffffffc02063b0:	00b78123          	sb	a1,2(a5)
    while (n -- > 0) {
ffffffffc02063b4:	4709                	li	a4,2
ffffffffc02063b6:	06ee0663          	beq	t3,a4,ffffffffc0206422 <memset+0x176>
        *p ++ = c;
ffffffffc02063ba:	00b781a3          	sb	a1,3(a5)
    while (n -- > 0) {
ffffffffc02063be:	470d                	li	a4,3
ffffffffc02063c0:	06ee0163          	beq	t3,a4,ffffffffc0206422 <memset+0x176>
        *p ++ = c;
ffffffffc02063c4:	00b78223          	sb	a1,4(a5)
    while (n -- > 0) {
ffffffffc02063c8:	4711                	li	a4,4
ffffffffc02063ca:	04ee0c63          	beq	t3,a4,ffffffffc0206422 <memset+0x176>
        *p ++ = c;
ffffffffc02063ce:	00b782a3          	sb	a1,5(a5)
    while (n -- > 0) {
ffffffffc02063d2:	4715                	li	a4,5
ffffffffc02063d4:	04ee0763          	beq	t3,a4,ffffffffc0206422 <memset+0x176>
        *p ++ = c;
ffffffffc02063d8:	00b78323          	sb	a1,6(a5)
    while (n -- > 0) {
ffffffffc02063dc:	4719                	li	a4,6
ffffffffc02063de:	04ee0263          	beq	t3,a4,ffffffffc0206422 <memset+0x176>
        *p ++ = c;
ffffffffc02063e2:	00b783a3          	sb	a1,7(a5)
    while (n -- > 0) {
ffffffffc02063e6:	471d                	li	a4,7
ffffffffc02063e8:	02ee0d63          	beq	t3,a4,ffffffffc0206422 <memset+0x176>
        *p ++ = c;
ffffffffc02063ec:	00b78423          	sb	a1,8(a5)
    while (n -- > 0) {
ffffffffc02063f0:	4721                	li	a4,8
ffffffffc02063f2:	02ee0863          	beq	t3,a4,ffffffffc0206422 <memset+0x176>
        *p ++ = c;
ffffffffc02063f6:	00b784a3          	sb	a1,9(a5)
    while (n -- > 0) {
ffffffffc02063fa:	4725                	li	a4,9
ffffffffc02063fc:	02ee0363          	beq	t3,a4,ffffffffc0206422 <memset+0x176>
        *p ++ = c;
ffffffffc0206400:	00b78523          	sb	a1,10(a5)
    while (n -- > 0) {
ffffffffc0206404:	4729                	li	a4,10
ffffffffc0206406:	00ee0e63          	beq	t3,a4,ffffffffc0206422 <memset+0x176>
        *p ++ = c;
ffffffffc020640a:	00b785a3          	sb	a1,11(a5)
    while (n -- > 0) {
ffffffffc020640e:	472d                	li	a4,11
ffffffffc0206410:	00ee0963          	beq	t3,a4,ffffffffc0206422 <memset+0x176>
        *p ++ = c;
ffffffffc0206414:	00b78623          	sb	a1,12(a5)
    while (n -- > 0) {
ffffffffc0206418:	4731                	li	a4,12
ffffffffc020641a:	00ee0463          	beq	t3,a4,ffffffffc0206422 <memset+0x176>
        *p ++ = c;
ffffffffc020641e:	00b786a3          	sb	a1,13(a5)
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0206422:	8082                	ret
ffffffffc0206424:	472d                	li	a4,11
ffffffffc0206426:	b545                	j	ffffffffc02062c6 <memset+0x1a>
ffffffffc0206428:	8082                	ret
    while (n -- > 0) {
ffffffffc020642a:	8f2a                	mv	t5,a0
ffffffffc020642c:	bf29                	j	ffffffffc0206346 <memset+0x9a>
ffffffffc020642e:	87aa                	mv	a5,a0
ffffffffc0206430:	b7bd                	j	ffffffffc020639e <memset+0xf2>

ffffffffc0206432 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0206432:	fff60893          	addi	a7,a2,-1
ffffffffc0206436:	c661                	beqz	a2,ffffffffc02064fe <memcpy+0xcc>
ffffffffc0206438:	00158713          	addi	a4,a1,1
ffffffffc020643c:	00b567b3          	or	a5,a0,a1
ffffffffc0206440:	40e506b3          	sub	a3,a0,a4
ffffffffc0206444:	8b9d                	andi	a5,a5,7
ffffffffc0206446:	0076b693          	sltiu	a3,a3,7
ffffffffc020644a:	0016c693          	xori	a3,a3,1
ffffffffc020644e:	0017b793          	seqz	a5,a5
ffffffffc0206452:	8ff5                	and	a5,a5,a3
ffffffffc0206454:	cbd1                	beqz	a5,ffffffffc02064e8 <memcpy+0xb6>
ffffffffc0206456:	00a8b793          	sltiu	a5,a7,10
ffffffffc020645a:	0017c793          	xori	a5,a5,1
ffffffffc020645e:	0ff7f793          	zext.b	a5,a5
ffffffffc0206462:	c3d9                	beqz	a5,ffffffffc02064e8 <memcpy+0xb6>
ffffffffc0206464:	ff867813          	andi	a6,a2,-8
ffffffffc0206468:	87ae                	mv	a5,a1
ffffffffc020646a:	872a                	mv	a4,a0
ffffffffc020646c:	982e                	add	a6,a6,a1
        *d ++ = *s ++;
ffffffffc020646e:	6394                	ld	a3,0(a5)
ffffffffc0206470:	07a1                	addi	a5,a5,8
ffffffffc0206472:	0721                	addi	a4,a4,8
ffffffffc0206474:	fed73c23          	sd	a3,-8(a4)
    while (n -- > 0) {
ffffffffc0206478:	ff079be3          	bne	a5,a6,ffffffffc020646e <memcpy+0x3c>
ffffffffc020647c:	ff867693          	andi	a3,a2,-8
ffffffffc0206480:	95b6                	add	a1,a1,a3
ffffffffc0206482:	00d50733          	add	a4,a0,a3
ffffffffc0206486:	40d887b3          	sub	a5,a7,a3
ffffffffc020648a:	06d60a63          	beq	a2,a3,ffffffffc02064fe <memcpy+0xcc>
        *d ++ = *s ++;
ffffffffc020648e:	0005c683          	lbu	a3,0(a1)
ffffffffc0206492:	00d70023          	sb	a3,0(a4)
    while (n -- > 0) {
ffffffffc0206496:	c7a5                	beqz	a5,ffffffffc02064fe <memcpy+0xcc>
        *d ++ = *s ++;
ffffffffc0206498:	0015c603          	lbu	a2,1(a1)
    while (n -- > 0) {
ffffffffc020649c:	4685                	li	a3,1
        *d ++ = *s ++;
ffffffffc020649e:	00c700a3          	sb	a2,1(a4)
    while (n -- > 0) {
ffffffffc02064a2:	04d78e63          	beq	a5,a3,ffffffffc02064fe <memcpy+0xcc>
        *d ++ = *s ++;
ffffffffc02064a6:	0025c603          	lbu	a2,2(a1)
    while (n -- > 0) {
ffffffffc02064aa:	4689                	li	a3,2
        *d ++ = *s ++;
ffffffffc02064ac:	00c70123          	sb	a2,2(a4)
    while (n -- > 0) {
ffffffffc02064b0:	04d78763          	beq	a5,a3,ffffffffc02064fe <memcpy+0xcc>
        *d ++ = *s ++;
ffffffffc02064b4:	0035c603          	lbu	a2,3(a1)
    while (n -- > 0) {
ffffffffc02064b8:	468d                	li	a3,3
        *d ++ = *s ++;
ffffffffc02064ba:	00c701a3          	sb	a2,3(a4)
    while (n -- > 0) {
ffffffffc02064be:	04d78063          	beq	a5,a3,ffffffffc02064fe <memcpy+0xcc>
        *d ++ = *s ++;
ffffffffc02064c2:	0045c603          	lbu	a2,4(a1)
    while (n -- > 0) {
ffffffffc02064c6:	4691                	li	a3,4
        *d ++ = *s ++;
ffffffffc02064c8:	00c70223          	sb	a2,4(a4)
    while (n -- > 0) {
ffffffffc02064cc:	02d78963          	beq	a5,a3,ffffffffc02064fe <memcpy+0xcc>
        *d ++ = *s ++;
ffffffffc02064d0:	0055c603          	lbu	a2,5(a1)
    while (n -- > 0) {
ffffffffc02064d4:	4695                	li	a3,5
        *d ++ = *s ++;
ffffffffc02064d6:	00c702a3          	sb	a2,5(a4)
    while (n -- > 0) {
ffffffffc02064da:	02d78263          	beq	a5,a3,ffffffffc02064fe <memcpy+0xcc>
        *d ++ = *s ++;
ffffffffc02064de:	0065c783          	lbu	a5,6(a1)
ffffffffc02064e2:	00f70323          	sb	a5,6(a4)
    while (n -- > 0) {
ffffffffc02064e6:	8082                	ret
ffffffffc02064e8:	95b2                	add	a1,a1,a2
    char *d = dst;
ffffffffc02064ea:	87aa                	mv	a5,a0
ffffffffc02064ec:	a011                	j	ffffffffc02064f0 <memcpy+0xbe>
ffffffffc02064ee:	0705                	addi	a4,a4,1
        *d ++ = *s ++;
ffffffffc02064f0:	fff74683          	lbu	a3,-1(a4)
ffffffffc02064f4:	0785                	addi	a5,a5,1
ffffffffc02064f6:	fed78fa3          	sb	a3,-1(a5)
    while (n -- > 0) {
ffffffffc02064fa:	feb71ae3          	bne	a4,a1,ffffffffc02064ee <memcpy+0xbc>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02064fe:	8082                	ret
