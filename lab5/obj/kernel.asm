
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000b297          	auipc	t0,0xb
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020b000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000b297          	auipc	t0,0xb
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020b008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020a2b7          	lui	t0,0xc020a
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
ffffffffc020003c:	c020a137          	lui	sp,0xc020a

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
ffffffffc020004a:	0009b517          	auipc	a0,0x9b
ffffffffc020004e:	97e50513          	addi	a0,a0,-1666 # ffffffffc029a9c8 <buf>
ffffffffc0200052:	0009f617          	auipc	a2,0x9f
ffffffffc0200056:	e2660613          	addi	a2,a2,-474 # ffffffffc029ee78 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0209ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	1e3050ef          	jal	ffffffffc0205a44 <memset>
    dtb_init();
ffffffffc0200066:	592000ef          	jal	ffffffffc02005f8 <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	51c000ef          	jal	ffffffffc0200586 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00006597          	auipc	a1,0x6
ffffffffc0200072:	a0258593          	addi	a1,a1,-1534 # ffffffffc0205a70 <etext+0x2>
ffffffffc0200076:	00006517          	auipc	a0,0x6
ffffffffc020007a:	a1a50513          	addi	a0,a0,-1510 # ffffffffc0205a90 <etext+0x22>
ffffffffc020007e:	116000ef          	jal	ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	1a6000ef          	jal	ffffffffc0200228 <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	0dd020ef          	jal	ffffffffc0202962 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	0f7000ef          	jal	ffffffffc0200980 <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	0f5000ef          	jal	ffffffffc0200982 <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	183030ef          	jal	ffffffffc0203a14 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	0ce050ef          	jal	ffffffffc0205164 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	49a000ef          	jal	ffffffffc0200534 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	0d7000ef          	jal	ffffffffc0200974 <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	25c050ef          	jal	ffffffffc02052fe <cpu_idle>

ffffffffc02000a6 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000a6:	715d                	addi	sp,sp,-80
ffffffffc02000a8:	e486                	sd	ra,72(sp)
ffffffffc02000aa:	e0a2                	sd	s0,64(sp)
ffffffffc02000ac:	fc26                	sd	s1,56(sp)
ffffffffc02000ae:	f84a                	sd	s2,48(sp)
ffffffffc02000b0:	f44e                	sd	s3,40(sp)
ffffffffc02000b2:	f052                	sd	s4,32(sp)
ffffffffc02000b4:	ec56                	sd	s5,24(sp)
ffffffffc02000b6:	e85a                	sd	s6,16(sp)
    if (prompt != NULL) {
ffffffffc02000b8:	c901                	beqz	a0,ffffffffc02000c8 <readline+0x22>
ffffffffc02000ba:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000bc:	00006517          	auipc	a0,0x6
ffffffffc02000c0:	9dc50513          	addi	a0,a0,-1572 # ffffffffc0205a98 <etext+0x2a>
ffffffffc02000c4:	0d0000ef          	jal	ffffffffc0200194 <cprintf>
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
ffffffffc02000c8:	4401                	li	s0,0
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ca:	44fd                	li	s1,31
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000cc:	4921                	li	s2,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000ce:	4a29                	li	s4,10
ffffffffc02000d0:	4ab5                	li	s5,13
            buf[i ++] = c;
ffffffffc02000d2:	0009bb17          	auipc	s6,0x9b
ffffffffc02000d6:	8f6b0b13          	addi	s6,s6,-1802 # ffffffffc029a9c8 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000da:	3fe00993          	li	s3,1022
        c = getchar();
ffffffffc02000de:	13a000ef          	jal	ffffffffc0200218 <getchar>
        if (c < 0) {
ffffffffc02000e2:	00054a63          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e6:	00a4da63          	bge	s1,a0,ffffffffc02000fa <readline+0x54>
ffffffffc02000ea:	0289d263          	bge	s3,s0,ffffffffc020010e <readline+0x68>
        c = getchar();
ffffffffc02000ee:	12a000ef          	jal	ffffffffc0200218 <getchar>
        if (c < 0) {
ffffffffc02000f2:	fe055ae3          	bgez	a0,ffffffffc02000e6 <readline+0x40>
            return NULL;
ffffffffc02000f6:	4501                	li	a0,0
ffffffffc02000f8:	a091                	j	ffffffffc020013c <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fa:	03251463          	bne	a0,s2,ffffffffc0200122 <readline+0x7c>
ffffffffc02000fe:	04804963          	bgtz	s0,ffffffffc0200150 <readline+0xaa>
        c = getchar();
ffffffffc0200102:	116000ef          	jal	ffffffffc0200218 <getchar>
        if (c < 0) {
ffffffffc0200106:	fe0548e3          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020010a:	fea4d8e3          	bge	s1,a0,ffffffffc02000fa <readline+0x54>
            cputchar(c);
ffffffffc020010e:	e42a                	sd	a0,8(sp)
ffffffffc0200110:	0b8000ef          	jal	ffffffffc02001c8 <cputchar>
            buf[i ++] = c;
ffffffffc0200114:	6522                	ld	a0,8(sp)
ffffffffc0200116:	008b07b3          	add	a5,s6,s0
ffffffffc020011a:	2405                	addiw	s0,s0,1
ffffffffc020011c:	00a78023          	sb	a0,0(a5)
ffffffffc0200120:	bf7d                	j	ffffffffc02000de <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0200122:	01450463          	beq	a0,s4,ffffffffc020012a <readline+0x84>
ffffffffc0200126:	fb551ce3          	bne	a0,s5,ffffffffc02000de <readline+0x38>
            cputchar(c);
ffffffffc020012a:	09e000ef          	jal	ffffffffc02001c8 <cputchar>
            buf[i] = '\0';
ffffffffc020012e:	0009b517          	auipc	a0,0x9b
ffffffffc0200132:	89a50513          	addi	a0,a0,-1894 # ffffffffc029a9c8 <buf>
ffffffffc0200136:	942a                	add	s0,s0,a0
ffffffffc0200138:	00040023          	sb	zero,0(s0)
            return buf;
        }
    }
}
ffffffffc020013c:	60a6                	ld	ra,72(sp)
ffffffffc020013e:	6406                	ld	s0,64(sp)
ffffffffc0200140:	74e2                	ld	s1,56(sp)
ffffffffc0200142:	7942                	ld	s2,48(sp)
ffffffffc0200144:	79a2                	ld	s3,40(sp)
ffffffffc0200146:	7a02                	ld	s4,32(sp)
ffffffffc0200148:	6ae2                	ld	s5,24(sp)
ffffffffc020014a:	6b42                	ld	s6,16(sp)
ffffffffc020014c:	6161                	addi	sp,sp,80
ffffffffc020014e:	8082                	ret
            cputchar(c);
ffffffffc0200150:	4521                	li	a0,8
ffffffffc0200152:	076000ef          	jal	ffffffffc02001c8 <cputchar>
            i --;
ffffffffc0200156:	347d                	addiw	s0,s0,-1
ffffffffc0200158:	b759                	j	ffffffffc02000de <readline+0x38>

ffffffffc020015a <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015a:	1141                	addi	sp,sp,-16
ffffffffc020015c:	e022                	sd	s0,0(sp)
ffffffffc020015e:	e406                	sd	ra,8(sp)
ffffffffc0200160:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200162:	426000ef          	jal	ffffffffc0200588 <cons_putc>
    (*cnt)++;
ffffffffc0200166:	401c                	lw	a5,0(s0)
}
ffffffffc0200168:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc020016a:	2785                	addiw	a5,a5,1
ffffffffc020016c:	c01c                	sw	a5,0(s0)
}
ffffffffc020016e:	6402                	ld	s0,0(sp)
ffffffffc0200170:	0141                	addi	sp,sp,16
ffffffffc0200172:	8082                	ret

ffffffffc0200174 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200174:	1101                	addi	sp,sp,-32
ffffffffc0200176:	862a                	mv	a2,a0
ffffffffc0200178:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017a:	00000517          	auipc	a0,0x0
ffffffffc020017e:	fe050513          	addi	a0,a0,-32 # ffffffffc020015a <cputch>
ffffffffc0200182:	006c                	addi	a1,sp,12
{
ffffffffc0200184:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200186:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc0200188:	484050ef          	jal	ffffffffc020560c <vprintfmt>
    return cnt;
}
ffffffffc020018c:	60e2                	ld	ra,24(sp)
ffffffffc020018e:	4532                	lw	a0,12(sp)
ffffffffc0200190:	6105                	addi	sp,sp,32
ffffffffc0200192:	8082                	ret

ffffffffc0200194 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200194:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200196:	02810313          	addi	t1,sp,40
{
ffffffffc020019a:	f42e                	sd	a1,40(sp)
ffffffffc020019c:	f832                	sd	a2,48(sp)
ffffffffc020019e:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a0:	862a                	mv	a2,a0
ffffffffc02001a2:	004c                	addi	a1,sp,4
ffffffffc02001a4:	00000517          	auipc	a0,0x0
ffffffffc02001a8:	fb650513          	addi	a0,a0,-74 # ffffffffc020015a <cputch>
ffffffffc02001ac:	869a                	mv	a3,t1
{
ffffffffc02001ae:	ec06                	sd	ra,24(sp)
ffffffffc02001b0:	e0ba                	sd	a4,64(sp)
ffffffffc02001b2:	e4be                	sd	a5,72(sp)
ffffffffc02001b4:	e8c2                	sd	a6,80(sp)
ffffffffc02001b6:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001b8:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001ba:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001bc:	450050ef          	jal	ffffffffc020560c <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c0:	60e2                	ld	ra,24(sp)
ffffffffc02001c2:	4512                	lw	a0,4(sp)
ffffffffc02001c4:	6125                	addi	sp,sp,96
ffffffffc02001c6:	8082                	ret

ffffffffc02001c8 <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001c8:	a6c1                	j	ffffffffc0200588 <cons_putc>

ffffffffc02001ca <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001ca:	1101                	addi	sp,sp,-32
ffffffffc02001cc:	ec06                	sd	ra,24(sp)
ffffffffc02001ce:	e822                	sd	s0,16(sp)
ffffffffc02001d0:	87aa                	mv	a5,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001d2:	00054503          	lbu	a0,0(a0)
ffffffffc02001d6:	c905                	beqz	a0,ffffffffc0200206 <cputs+0x3c>
ffffffffc02001d8:	e426                	sd	s1,8(sp)
ffffffffc02001da:	00178493          	addi	s1,a5,1
ffffffffc02001de:	8426                	mv	s0,s1
    cons_putc(c);
ffffffffc02001e0:	3a8000ef          	jal	ffffffffc0200588 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001e4:	00044503          	lbu	a0,0(s0)
ffffffffc02001e8:	87a2                	mv	a5,s0
ffffffffc02001ea:	0405                	addi	s0,s0,1
ffffffffc02001ec:	f975                	bnez	a0,ffffffffc02001e0 <cputs+0x16>
    (*cnt)++;
ffffffffc02001ee:	9f85                	subw	a5,a5,s1
    cons_putc(c);
ffffffffc02001f0:	4529                	li	a0,10
    (*cnt)++;
ffffffffc02001f2:	0027841b          	addiw	s0,a5,2
ffffffffc02001f6:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc02001f8:	390000ef          	jal	ffffffffc0200588 <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001fc:	60e2                	ld	ra,24(sp)
ffffffffc02001fe:	8522                	mv	a0,s0
ffffffffc0200200:	6442                	ld	s0,16(sp)
ffffffffc0200202:	6105                	addi	sp,sp,32
ffffffffc0200204:	8082                	ret
    cons_putc(c);
ffffffffc0200206:	4529                	li	a0,10
ffffffffc0200208:	380000ef          	jal	ffffffffc0200588 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc020020c:	4405                	li	s0,1
}
ffffffffc020020e:	60e2                	ld	ra,24(sp)
ffffffffc0200210:	8522                	mv	a0,s0
ffffffffc0200212:	6442                	ld	s0,16(sp)
ffffffffc0200214:	6105                	addi	sp,sp,32
ffffffffc0200216:	8082                	ret

ffffffffc0200218 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc0200218:	1141                	addi	sp,sp,-16
ffffffffc020021a:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020021c:	3a0000ef          	jal	ffffffffc02005bc <cons_getc>
ffffffffc0200220:	dd75                	beqz	a0,ffffffffc020021c <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200222:	60a2                	ld	ra,8(sp)
ffffffffc0200224:	0141                	addi	sp,sp,16
ffffffffc0200226:	8082                	ret

ffffffffc0200228 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc0200228:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020022a:	00006517          	auipc	a0,0x6
ffffffffc020022e:	87650513          	addi	a0,a0,-1930 # ffffffffc0205aa0 <etext+0x32>
{
ffffffffc0200232:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200234:	f61ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200238:	00000597          	auipc	a1,0x0
ffffffffc020023c:	e1258593          	addi	a1,a1,-494 # ffffffffc020004a <kern_init>
ffffffffc0200240:	00006517          	auipc	a0,0x6
ffffffffc0200244:	88050513          	addi	a0,a0,-1920 # ffffffffc0205ac0 <etext+0x52>
ffffffffc0200248:	f4dff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020024c:	00006597          	auipc	a1,0x6
ffffffffc0200250:	82258593          	addi	a1,a1,-2014 # ffffffffc0205a6e <etext>
ffffffffc0200254:	00006517          	auipc	a0,0x6
ffffffffc0200258:	88c50513          	addi	a0,a0,-1908 # ffffffffc0205ae0 <etext+0x72>
ffffffffc020025c:	f39ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200260:	0009a597          	auipc	a1,0x9a
ffffffffc0200264:	76858593          	addi	a1,a1,1896 # ffffffffc029a9c8 <buf>
ffffffffc0200268:	00006517          	auipc	a0,0x6
ffffffffc020026c:	89850513          	addi	a0,a0,-1896 # ffffffffc0205b00 <etext+0x92>
ffffffffc0200270:	f25ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200274:	0009f597          	auipc	a1,0x9f
ffffffffc0200278:	c0458593          	addi	a1,a1,-1020 # ffffffffc029ee78 <end>
ffffffffc020027c:	00006517          	auipc	a0,0x6
ffffffffc0200280:	8a450513          	addi	a0,a0,-1884 # ffffffffc0205b20 <etext+0xb2>
ffffffffc0200284:	f11ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200288:	0009f797          	auipc	a5,0x9f
ffffffffc020028c:	fef78793          	addi	a5,a5,-17 # ffffffffc029f277 <end+0x3ff>
ffffffffc0200290:	00000717          	auipc	a4,0x0
ffffffffc0200294:	dba70713          	addi	a4,a4,-582 # ffffffffc020004a <kern_init>
ffffffffc0200298:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020029a:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc020029e:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002a0:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002a4:	95be                	add	a1,a1,a5
ffffffffc02002a6:	85a9                	srai	a1,a1,0xa
ffffffffc02002a8:	00006517          	auipc	a0,0x6
ffffffffc02002ac:	89850513          	addi	a0,a0,-1896 # ffffffffc0205b40 <etext+0xd2>
}
ffffffffc02002b0:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002b2:	b5cd                	j	ffffffffc0200194 <cprintf>

ffffffffc02002b4 <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc02002b4:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002b6:	00006617          	auipc	a2,0x6
ffffffffc02002ba:	8ba60613          	addi	a2,a2,-1862 # ffffffffc0205b70 <etext+0x102>
ffffffffc02002be:	04f00593          	li	a1,79
ffffffffc02002c2:	00006517          	auipc	a0,0x6
ffffffffc02002c6:	8c650513          	addi	a0,a0,-1850 # ffffffffc0205b88 <etext+0x11a>
{
ffffffffc02002ca:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002cc:	1bc000ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02002d0 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02002d0:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002d2:	00006617          	auipc	a2,0x6
ffffffffc02002d6:	8ce60613          	addi	a2,a2,-1842 # ffffffffc0205ba0 <etext+0x132>
ffffffffc02002da:	00006597          	auipc	a1,0x6
ffffffffc02002de:	8e658593          	addi	a1,a1,-1818 # ffffffffc0205bc0 <etext+0x152>
ffffffffc02002e2:	00006517          	auipc	a0,0x6
ffffffffc02002e6:	8e650513          	addi	a0,a0,-1818 # ffffffffc0205bc8 <etext+0x15a>
{
ffffffffc02002ea:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002ec:	ea9ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02002f0:	00006617          	auipc	a2,0x6
ffffffffc02002f4:	8e860613          	addi	a2,a2,-1816 # ffffffffc0205bd8 <etext+0x16a>
ffffffffc02002f8:	00006597          	auipc	a1,0x6
ffffffffc02002fc:	90858593          	addi	a1,a1,-1784 # ffffffffc0205c00 <etext+0x192>
ffffffffc0200300:	00006517          	auipc	a0,0x6
ffffffffc0200304:	8c850513          	addi	a0,a0,-1848 # ffffffffc0205bc8 <etext+0x15a>
ffffffffc0200308:	e8dff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020030c:	00006617          	auipc	a2,0x6
ffffffffc0200310:	90460613          	addi	a2,a2,-1788 # ffffffffc0205c10 <etext+0x1a2>
ffffffffc0200314:	00006597          	auipc	a1,0x6
ffffffffc0200318:	91c58593          	addi	a1,a1,-1764 # ffffffffc0205c30 <etext+0x1c2>
ffffffffc020031c:	00006517          	auipc	a0,0x6
ffffffffc0200320:	8ac50513          	addi	a0,a0,-1876 # ffffffffc0205bc8 <etext+0x15a>
ffffffffc0200324:	e71ff0ef          	jal	ffffffffc0200194 <cprintf>
    }
    return 0;
}
ffffffffc0200328:	60a2                	ld	ra,8(sp)
ffffffffc020032a:	4501                	li	a0,0
ffffffffc020032c:	0141                	addi	sp,sp,16
ffffffffc020032e:	8082                	ret

ffffffffc0200330 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200330:	1141                	addi	sp,sp,-16
ffffffffc0200332:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200334:	ef5ff0ef          	jal	ffffffffc0200228 <print_kerninfo>
    return 0;
}
ffffffffc0200338:	60a2                	ld	ra,8(sp)
ffffffffc020033a:	4501                	li	a0,0
ffffffffc020033c:	0141                	addi	sp,sp,16
ffffffffc020033e:	8082                	ret

ffffffffc0200340 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200340:	1141                	addi	sp,sp,-16
ffffffffc0200342:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc0200344:	f71ff0ef          	jal	ffffffffc02002b4 <print_stackframe>
    return 0;
}
ffffffffc0200348:	60a2                	ld	ra,8(sp)
ffffffffc020034a:	4501                	li	a0,0
ffffffffc020034c:	0141                	addi	sp,sp,16
ffffffffc020034e:	8082                	ret

ffffffffc0200350 <kmonitor>:
{
ffffffffc0200350:	7115                	addi	sp,sp,-224
ffffffffc0200352:	f15a                	sd	s6,160(sp)
ffffffffc0200354:	8b2a                	mv	s6,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200356:	00006517          	auipc	a0,0x6
ffffffffc020035a:	8ea50513          	addi	a0,a0,-1814 # ffffffffc0205c40 <etext+0x1d2>
{
ffffffffc020035e:	ed86                	sd	ra,216(sp)
ffffffffc0200360:	e9a2                	sd	s0,208(sp)
ffffffffc0200362:	e5a6                	sd	s1,200(sp)
ffffffffc0200364:	e1ca                	sd	s2,192(sp)
ffffffffc0200366:	fd4e                	sd	s3,184(sp)
ffffffffc0200368:	f952                	sd	s4,176(sp)
ffffffffc020036a:	f556                	sd	s5,168(sp)
ffffffffc020036c:	ed5e                	sd	s7,152(sp)
ffffffffc020036e:	e962                	sd	s8,144(sp)
ffffffffc0200370:	e566                	sd	s9,136(sp)
ffffffffc0200372:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200374:	e21ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200378:	00006517          	auipc	a0,0x6
ffffffffc020037c:	8f050513          	addi	a0,a0,-1808 # ffffffffc0205c68 <etext+0x1fa>
ffffffffc0200380:	e15ff0ef          	jal	ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc0200384:	000b0563          	beqz	s6,ffffffffc020038e <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc0200388:	855a                	mv	a0,s6
ffffffffc020038a:	7e0000ef          	jal	ffffffffc0200b6a <print_trapframe>
ffffffffc020038e:	00007c17          	auipc	s8,0x7
ffffffffc0200392:	42ac0c13          	addi	s8,s8,1066 # ffffffffc02077b8 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc0200396:	00006917          	auipc	s2,0x6
ffffffffc020039a:	8fa90913          	addi	s2,s2,-1798 # ffffffffc0205c90 <etext+0x222>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020039e:	00006497          	auipc	s1,0x6
ffffffffc02003a2:	8fa48493          	addi	s1,s1,-1798 # ffffffffc0205c98 <etext+0x22a>
        if (argc == MAXARGS - 1)
ffffffffc02003a6:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003a8:	00006a97          	auipc	s5,0x6
ffffffffc02003ac:	8f8a8a93          	addi	s5,s5,-1800 # ffffffffc0205ca0 <etext+0x232>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003b0:	4a0d                	li	s4,3
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003b2:	00006b97          	auipc	s7,0x6
ffffffffc02003b6:	90eb8b93          	addi	s7,s7,-1778 # ffffffffc0205cc0 <etext+0x252>
        if ((buf = readline("K> ")) != NULL)
ffffffffc02003ba:	854a                	mv	a0,s2
ffffffffc02003bc:	cebff0ef          	jal	ffffffffc02000a6 <readline>
ffffffffc02003c0:	842a                	mv	s0,a0
ffffffffc02003c2:	dd65                	beqz	a0,ffffffffc02003ba <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003c4:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003c8:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003ca:	e59d                	bnez	a1,ffffffffc02003f8 <kmonitor+0xa8>
    if (argc == 0)
ffffffffc02003cc:	fe0c87e3          	beqz	s9,ffffffffc02003ba <kmonitor+0x6a>
ffffffffc02003d0:	00007d17          	auipc	s10,0x7
ffffffffc02003d4:	3e8d0d13          	addi	s10,s10,1000 # ffffffffc02077b8 <commands>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003d8:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003da:	6582                	ld	a1,0(sp)
ffffffffc02003dc:	000d3503          	ld	a0,0(s10)
ffffffffc02003e0:	5ee050ef          	jal	ffffffffc02059ce <strcmp>
ffffffffc02003e4:	c53d                	beqz	a0,ffffffffc0200452 <kmonitor+0x102>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003e6:	2405                	addiw	s0,s0,1
ffffffffc02003e8:	0d61                	addi	s10,s10,24
ffffffffc02003ea:	ff4418e3          	bne	s0,s4,ffffffffc02003da <kmonitor+0x8a>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003ee:	6582                	ld	a1,0(sp)
ffffffffc02003f0:	855e                	mv	a0,s7
ffffffffc02003f2:	da3ff0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
ffffffffc02003f6:	b7d1                	j	ffffffffc02003ba <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003f8:	8526                	mv	a0,s1
ffffffffc02003fa:	634050ef          	jal	ffffffffc0205a2e <strchr>
ffffffffc02003fe:	c901                	beqz	a0,ffffffffc020040e <kmonitor+0xbe>
ffffffffc0200400:	00144583          	lbu	a1,1(s0)
            *buf++ = '\0';
ffffffffc0200404:	00040023          	sb	zero,0(s0)
ffffffffc0200408:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020040a:	d1e9                	beqz	a1,ffffffffc02003cc <kmonitor+0x7c>
ffffffffc020040c:	b7f5                	j	ffffffffc02003f8 <kmonitor+0xa8>
        if (*buf == '\0')
ffffffffc020040e:	00044783          	lbu	a5,0(s0)
ffffffffc0200412:	dfcd                	beqz	a5,ffffffffc02003cc <kmonitor+0x7c>
        if (argc == MAXARGS - 1)
ffffffffc0200414:	033c8a63          	beq	s9,s3,ffffffffc0200448 <kmonitor+0xf8>
        argv[argc++] = buf;
ffffffffc0200418:	003c9793          	slli	a5,s9,0x3
ffffffffc020041c:	08078793          	addi	a5,a5,128
ffffffffc0200420:	978a                	add	a5,a5,sp
ffffffffc0200422:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200426:	00044583          	lbu	a1,0(s0)
        argv[argc++] = buf;
ffffffffc020042a:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc020042c:	e591                	bnez	a1,ffffffffc0200438 <kmonitor+0xe8>
ffffffffc020042e:	bf79                	j	ffffffffc02003cc <kmonitor+0x7c>
ffffffffc0200430:	00144583          	lbu	a1,1(s0)
            buf++;
ffffffffc0200434:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200436:	d9d9                	beqz	a1,ffffffffc02003cc <kmonitor+0x7c>
ffffffffc0200438:	8526                	mv	a0,s1
ffffffffc020043a:	5f4050ef          	jal	ffffffffc0205a2e <strchr>
ffffffffc020043e:	d96d                	beqz	a0,ffffffffc0200430 <kmonitor+0xe0>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200440:	00044583          	lbu	a1,0(s0)
ffffffffc0200444:	d5c1                	beqz	a1,ffffffffc02003cc <kmonitor+0x7c>
ffffffffc0200446:	bf4d                	j	ffffffffc02003f8 <kmonitor+0xa8>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200448:	45c1                	li	a1,16
ffffffffc020044a:	8556                	mv	a0,s5
ffffffffc020044c:	d49ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200450:	b7e1                	j	ffffffffc0200418 <kmonitor+0xc8>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc0200452:	00141793          	slli	a5,s0,0x1
ffffffffc0200456:	97a2                	add	a5,a5,s0
ffffffffc0200458:	078e                	slli	a5,a5,0x3
ffffffffc020045a:	97e2                	add	a5,a5,s8
ffffffffc020045c:	6b9c                	ld	a5,16(a5)
ffffffffc020045e:	865a                	mv	a2,s6
ffffffffc0200460:	002c                	addi	a1,sp,8
ffffffffc0200462:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200466:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0)
ffffffffc0200468:	f40559e3          	bgez	a0,ffffffffc02003ba <kmonitor+0x6a>
}
ffffffffc020046c:	60ee                	ld	ra,216(sp)
ffffffffc020046e:	644e                	ld	s0,208(sp)
ffffffffc0200470:	64ae                	ld	s1,200(sp)
ffffffffc0200472:	690e                	ld	s2,192(sp)
ffffffffc0200474:	79ea                	ld	s3,184(sp)
ffffffffc0200476:	7a4a                	ld	s4,176(sp)
ffffffffc0200478:	7aaa                	ld	s5,168(sp)
ffffffffc020047a:	7b0a                	ld	s6,160(sp)
ffffffffc020047c:	6bea                	ld	s7,152(sp)
ffffffffc020047e:	6c4a                	ld	s8,144(sp)
ffffffffc0200480:	6caa                	ld	s9,136(sp)
ffffffffc0200482:	6d0a                	ld	s10,128(sp)
ffffffffc0200484:	612d                	addi	sp,sp,224
ffffffffc0200486:	8082                	ret

ffffffffc0200488 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
ffffffffc0200488:	0009f317          	auipc	t1,0x9f
ffffffffc020048c:	96830313          	addi	t1,t1,-1688 # ffffffffc029edf0 <is_panic>
ffffffffc0200490:	00033e03          	ld	t3,0(t1)
{
ffffffffc0200494:	715d                	addi	sp,sp,-80
ffffffffc0200496:	ec06                	sd	ra,24(sp)
ffffffffc0200498:	f436                	sd	a3,40(sp)
ffffffffc020049a:	f83a                	sd	a4,48(sp)
ffffffffc020049c:	fc3e                	sd	a5,56(sp)
ffffffffc020049e:	e0c2                	sd	a6,64(sp)
ffffffffc02004a0:	e4c6                	sd	a7,72(sp)
    if (is_panic)
ffffffffc02004a2:	020e1c63          	bnez	t3,ffffffffc02004da <__panic+0x52>
    {
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02004a6:	4785                	li	a5,1
ffffffffc02004a8:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004ac:	e822                	sd	s0,16(sp)
ffffffffc02004ae:	103c                	addi	a5,sp,40
ffffffffc02004b0:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004b2:	862e                	mv	a2,a1
ffffffffc02004b4:	85aa                	mv	a1,a0
ffffffffc02004b6:	00006517          	auipc	a0,0x6
ffffffffc02004ba:	82250513          	addi	a0,a0,-2014 # ffffffffc0205cd8 <etext+0x26a>
    va_start(ap, fmt);
ffffffffc02004be:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004c0:	cd5ff0ef          	jal	ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004c4:	65a2                	ld	a1,8(sp)
ffffffffc02004c6:	8522                	mv	a0,s0
ffffffffc02004c8:	cadff0ef          	jal	ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004cc:	00006517          	auipc	a0,0x6
ffffffffc02004d0:	82c50513          	addi	a0,a0,-2004 # ffffffffc0205cf8 <etext+0x28a>
ffffffffc02004d4:	cc1ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02004d8:	6442                	ld	s0,16(sp)
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004da:	4501                	li	a0,0
ffffffffc02004dc:	4581                	li	a1,0
ffffffffc02004de:	4601                	li	a2,0
ffffffffc02004e0:	48a1                	li	a7,8
ffffffffc02004e2:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004e6:	494000ef          	jal	ffffffffc020097a <intr_disable>
    while (1)
    {
        kmonitor(NULL);
ffffffffc02004ea:	4501                	li	a0,0
ffffffffc02004ec:	e65ff0ef          	jal	ffffffffc0200350 <kmonitor>
    while (1)
ffffffffc02004f0:	bfed                	j	ffffffffc02004ea <__panic+0x62>

ffffffffc02004f2 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
ffffffffc02004f2:	715d                	addi	sp,sp,-80
ffffffffc02004f4:	e822                	sd	s0,16(sp)
ffffffffc02004f6:	fc3e                	sd	a5,56(sp)
ffffffffc02004f8:	8432                	mv	s0,a2
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004fa:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004fc:	862e                	mv	a2,a1
ffffffffc02004fe:	85aa                	mv	a1,a0
ffffffffc0200500:	00006517          	auipc	a0,0x6
ffffffffc0200504:	80050513          	addi	a0,a0,-2048 # ffffffffc0205d00 <etext+0x292>
{
ffffffffc0200508:	ec06                	sd	ra,24(sp)
ffffffffc020050a:	f436                	sd	a3,40(sp)
ffffffffc020050c:	f83a                	sd	a4,48(sp)
ffffffffc020050e:	e0c2                	sd	a6,64(sp)
ffffffffc0200510:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0200512:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200514:	c81ff0ef          	jal	ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200518:	65a2                	ld	a1,8(sp)
ffffffffc020051a:	8522                	mv	a0,s0
ffffffffc020051c:	c59ff0ef          	jal	ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc0200520:	00005517          	auipc	a0,0x5
ffffffffc0200524:	7d850513          	addi	a0,a0,2008 # ffffffffc0205cf8 <etext+0x28a>
ffffffffc0200528:	c6dff0ef          	jal	ffffffffc0200194 <cprintf>
    va_end(ap);
}
ffffffffc020052c:	60e2                	ld	ra,24(sp)
ffffffffc020052e:	6442                	ld	s0,16(sp)
ffffffffc0200530:	6161                	addi	sp,sp,80
ffffffffc0200532:	8082                	ret

ffffffffc0200534 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc0200534:	67e1                	lui	a5,0x18
ffffffffc0200536:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xeb98>
ffffffffc020053a:	0009f717          	auipc	a4,0x9f
ffffffffc020053e:	8af73f23          	sd	a5,-1858(a4) # ffffffffc029edf8 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200542:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200546:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200548:	953e                	add	a0,a0,a5
ffffffffc020054a:	4601                	li	a2,0
ffffffffc020054c:	4881                	li	a7,0
ffffffffc020054e:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200552:	02000793          	li	a5,32
ffffffffc0200556:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc020055a:	00005517          	auipc	a0,0x5
ffffffffc020055e:	7c650513          	addi	a0,a0,1990 # ffffffffc0205d20 <etext+0x2b2>
    ticks = 0;
ffffffffc0200562:	0009f797          	auipc	a5,0x9f
ffffffffc0200566:	8807bf23          	sd	zero,-1890(a5) # ffffffffc029ee00 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020056a:	b12d                	j	ffffffffc0200194 <cprintf>

ffffffffc020056c <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020056c:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200570:	0009f797          	auipc	a5,0x9f
ffffffffc0200574:	8887b783          	ld	a5,-1912(a5) # ffffffffc029edf8 <timebase>
ffffffffc0200578:	953e                	add	a0,a0,a5
ffffffffc020057a:	4581                	li	a1,0
ffffffffc020057c:	4601                	li	a2,0
ffffffffc020057e:	4881                	li	a7,0
ffffffffc0200580:	00000073          	ecall
ffffffffc0200584:	8082                	ret

ffffffffc0200586 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200586:	8082                	ret

ffffffffc0200588 <cons_putc>:
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0200588:	100027f3          	csrr	a5,sstatus
ffffffffc020058c:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc020058e:	0ff57513          	zext.b	a0,a0
ffffffffc0200592:	e799                	bnez	a5,ffffffffc02005a0 <cons_putc+0x18>
ffffffffc0200594:	4581                	li	a1,0
ffffffffc0200596:	4601                	li	a2,0
ffffffffc0200598:	4885                	li	a7,1
ffffffffc020059a:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc020059e:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02005a0:	1101                	addi	sp,sp,-32
ffffffffc02005a2:	ec06                	sd	ra,24(sp)
ffffffffc02005a4:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02005a6:	3d4000ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc02005aa:	6522                	ld	a0,8(sp)
ffffffffc02005ac:	4581                	li	a1,0
ffffffffc02005ae:	4601                	li	a2,0
ffffffffc02005b0:	4885                	li	a7,1
ffffffffc02005b2:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02005b6:	60e2                	ld	ra,24(sp)
ffffffffc02005b8:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc02005ba:	ae6d                	j	ffffffffc0200974 <intr_enable>

ffffffffc02005bc <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02005bc:	100027f3          	csrr	a5,sstatus
ffffffffc02005c0:	8b89                	andi	a5,a5,2
ffffffffc02005c2:	eb89                	bnez	a5,ffffffffc02005d4 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02005c4:	4501                	li	a0,0
ffffffffc02005c6:	4581                	li	a1,0
ffffffffc02005c8:	4601                	li	a2,0
ffffffffc02005ca:	4889                	li	a7,2
ffffffffc02005cc:	00000073          	ecall
ffffffffc02005d0:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005d2:	8082                	ret
int cons_getc(void) {
ffffffffc02005d4:	1101                	addi	sp,sp,-32
ffffffffc02005d6:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005d8:	3a2000ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc02005dc:	4501                	li	a0,0
ffffffffc02005de:	4581                	li	a1,0
ffffffffc02005e0:	4601                	li	a2,0
ffffffffc02005e2:	4889                	li	a7,2
ffffffffc02005e4:	00000073          	ecall
ffffffffc02005e8:	2501                	sext.w	a0,a0
ffffffffc02005ea:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005ec:	388000ef          	jal	ffffffffc0200974 <intr_enable>
}
ffffffffc02005f0:	60e2                	ld	ra,24(sp)
ffffffffc02005f2:	6522                	ld	a0,8(sp)
ffffffffc02005f4:	6105                	addi	sp,sp,32
ffffffffc02005f6:	8082                	ret

ffffffffc02005f8 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005f8:	711d                	addi	sp,sp,-96
    cprintf("DTB Init\n");
ffffffffc02005fa:	00005517          	auipc	a0,0x5
ffffffffc02005fe:	74650513          	addi	a0,a0,1862 # ffffffffc0205d40 <etext+0x2d2>
void dtb_init(void) {
ffffffffc0200602:	ec86                	sd	ra,88(sp)
ffffffffc0200604:	e8a2                	sd	s0,80(sp)
    cprintf("DTB Init\n");
ffffffffc0200606:	b8fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020060a:	0000b597          	auipc	a1,0xb
ffffffffc020060e:	9f65b583          	ld	a1,-1546(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc0200612:	00005517          	auipc	a0,0x5
ffffffffc0200616:	73e50513          	addi	a0,a0,1854 # ffffffffc0205d50 <etext+0x2e2>
ffffffffc020061a:	b7bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020061e:	0000b417          	auipc	s0,0xb
ffffffffc0200622:	9ea40413          	addi	s0,s0,-1558 # ffffffffc020b008 <boot_dtb>
ffffffffc0200626:	600c                	ld	a1,0(s0)
ffffffffc0200628:	00005517          	auipc	a0,0x5
ffffffffc020062c:	73850513          	addi	a0,a0,1848 # ffffffffc0205d60 <etext+0x2f2>
ffffffffc0200630:	b65ff0ef          	jal	ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200634:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200636:	00005517          	auipc	a0,0x5
ffffffffc020063a:	74250513          	addi	a0,a0,1858 # ffffffffc0205d78 <etext+0x30a>
    if (boot_dtb == 0) {
ffffffffc020063e:	12070d63          	beqz	a4,ffffffffc0200778 <dtb_init+0x180>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200642:	57f5                	li	a5,-3
ffffffffc0200644:	07fa                	slli	a5,a5,0x1e
ffffffffc0200646:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200648:	431c                	lw	a5,0(a4)
ffffffffc020064a:	f456                	sd	s5,40(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020064c:	00ff0637          	lui	a2,0xff0
ffffffffc0200650:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200654:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200658:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020065c:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200660:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200664:	6ac1                	lui	s5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200666:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200668:	8ec9                	or	a3,a3,a0
ffffffffc020066a:	0087979b          	slliw	a5,a5,0x8
ffffffffc020066e:	1afd                	addi	s5,s5,-1 # ffff <_binary_obj___user_exit_out_size+0x64f7>
ffffffffc0200670:	0157f7b3          	and	a5,a5,s5
ffffffffc0200674:	8dd5                	or	a1,a1,a3
ffffffffc0200676:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200678:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067c:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc020067e:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe41075>
ffffffffc0200682:	0ef59f63          	bne	a1,a5,ffffffffc0200780 <dtb_init+0x188>
ffffffffc0200686:	471c                	lw	a5,8(a4)
ffffffffc0200688:	4754                	lw	a3,12(a4)
ffffffffc020068a:	fc4e                	sd	s3,56(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020068c:	0087d99b          	srliw	s3,a5,0x8
ffffffffc0200690:	0086d41b          	srliw	s0,a3,0x8
ffffffffc0200694:	0186951b          	slliw	a0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200698:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020069c:	0187959b          	slliw	a1,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006a0:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006a4:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006a8:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ac:	0109999b          	slliw	s3,s3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b0:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006b4:	8c71                	and	s0,s0,a2
ffffffffc02006b6:	00c9f9b3          	and	s3,s3,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ba:	01156533          	or	a0,a0,a7
ffffffffc02006be:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006c2:	0105e633          	or	a2,a1,a6
ffffffffc02006c6:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006ca:	8c49                	or	s0,s0,a0
ffffffffc02006cc:	0156f6b3          	and	a3,a3,s5
ffffffffc02006d0:	00c9e9b3          	or	s3,s3,a2
ffffffffc02006d4:	0157f7b3          	and	a5,a5,s5
ffffffffc02006d8:	8c55                	or	s0,s0,a3
ffffffffc02006da:	00f9e9b3          	or	s3,s3,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006de:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006e0:	1982                	slli	s3,s3,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006e2:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006e4:	0209d993          	srli	s3,s3,0x20
ffffffffc02006e8:	e4a6                	sd	s1,72(sp)
ffffffffc02006ea:	e0ca                	sd	s2,64(sp)
ffffffffc02006ec:	ec5e                	sd	s7,24(sp)
ffffffffc02006ee:	e862                	sd	s8,16(sp)
ffffffffc02006f0:	e466                	sd	s9,8(sp)
ffffffffc02006f2:	e06a                	sd	s10,0(sp)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006f4:	f852                	sd	s4,48(sp)
    int in_memory_node = 0;
ffffffffc02006f6:	4b81                	li	s7,0
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006f8:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006fa:	99ba                	add	s3,s3,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006fc:	00ff0cb7          	lui	s9,0xff0
        switch (token) {
ffffffffc0200700:	4c0d                	li	s8,3
ffffffffc0200702:	4911                	li	s2,4
ffffffffc0200704:	4d05                	li	s10,1
ffffffffc0200706:	4489                	li	s1,2
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200708:	0009a703          	lw	a4,0(s3)
ffffffffc020070c:	00498a13          	addi	s4,s3,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200710:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200714:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200718:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020071c:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200720:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200724:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200726:	0196f6b3          	and	a3,a3,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020072a:	0087171b          	slliw	a4,a4,0x8
ffffffffc020072e:	8fd5                	or	a5,a5,a3
ffffffffc0200730:	00eaf733          	and	a4,s5,a4
ffffffffc0200734:	8fd9                	or	a5,a5,a4
ffffffffc0200736:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200738:	09878263          	beq	a5,s8,ffffffffc02007bc <dtb_init+0x1c4>
ffffffffc020073c:	00fc6963          	bltu	s8,a5,ffffffffc020074e <dtb_init+0x156>
ffffffffc0200740:	05a78963          	beq	a5,s10,ffffffffc0200792 <dtb_init+0x19a>
ffffffffc0200744:	00979763          	bne	a5,s1,ffffffffc0200752 <dtb_init+0x15a>
ffffffffc0200748:	4b81                	li	s7,0
ffffffffc020074a:	89d2                	mv	s3,s4
ffffffffc020074c:	bf75                	j	ffffffffc0200708 <dtb_init+0x110>
ffffffffc020074e:	ff278ee3          	beq	a5,s2,ffffffffc020074a <dtb_init+0x152>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200752:	00005517          	auipc	a0,0x5
ffffffffc0200756:	6ee50513          	addi	a0,a0,1774 # ffffffffc0205e40 <etext+0x3d2>
ffffffffc020075a:	a3bff0ef          	jal	ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020075e:	64a6                	ld	s1,72(sp)
ffffffffc0200760:	6906                	ld	s2,64(sp)
ffffffffc0200762:	79e2                	ld	s3,56(sp)
ffffffffc0200764:	7a42                	ld	s4,48(sp)
ffffffffc0200766:	7aa2                	ld	s5,40(sp)
ffffffffc0200768:	6be2                	ld	s7,24(sp)
ffffffffc020076a:	6c42                	ld	s8,16(sp)
ffffffffc020076c:	6ca2                	ld	s9,8(sp)
ffffffffc020076e:	6d02                	ld	s10,0(sp)
ffffffffc0200770:	00005517          	auipc	a0,0x5
ffffffffc0200774:	70850513          	addi	a0,a0,1800 # ffffffffc0205e78 <etext+0x40a>
}
ffffffffc0200778:	6446                	ld	s0,80(sp)
ffffffffc020077a:	60e6                	ld	ra,88(sp)
ffffffffc020077c:	6125                	addi	sp,sp,96
    cprintf("DTB init completed\n");
ffffffffc020077e:	bc19                	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200780:	6446                	ld	s0,80(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200782:	7aa2                	ld	s5,40(sp)
}
ffffffffc0200784:	60e6                	ld	ra,88(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200786:	00005517          	auipc	a0,0x5
ffffffffc020078a:	61250513          	addi	a0,a0,1554 # ffffffffc0205d98 <etext+0x32a>
}
ffffffffc020078e:	6125                	addi	sp,sp,96
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200790:	b411                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc0200792:	8552                	mv	a0,s4
ffffffffc0200794:	1f2050ef          	jal	ffffffffc0205986 <strlen>
ffffffffc0200798:	89aa                	mv	s3,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020079a:	4619                	li	a2,6
ffffffffc020079c:	00005597          	auipc	a1,0x5
ffffffffc02007a0:	62458593          	addi	a1,a1,1572 # ffffffffc0205dc0 <etext+0x352>
ffffffffc02007a4:	8552                	mv	a0,s4
                int name_len = strlen(name);
ffffffffc02007a6:	2981                	sext.w	s3,s3
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007a8:	25e050ef          	jal	ffffffffc0205a06 <strncmp>
ffffffffc02007ac:	e111                	bnez	a0,ffffffffc02007b0 <dtb_init+0x1b8>
                    in_memory_node = 1;
ffffffffc02007ae:	4b85                	li	s7,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02007b0:	0a11                	addi	s4,s4,4
ffffffffc02007b2:	9a4e                	add	s4,s4,s3
ffffffffc02007b4:	ffca7a13          	andi	s4,s4,-4
        switch (token) {
ffffffffc02007b8:	89d2                	mv	s3,s4
ffffffffc02007ba:	b7b9                	j	ffffffffc0200708 <dtb_init+0x110>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007bc:	0049a783          	lw	a5,4(s3)
ffffffffc02007c0:	f05a                	sd	s6,32(sp)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007c2:	0089a683          	lw	a3,8(s3)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007c6:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02007ca:	01879b1b          	slliw	s6,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007ce:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007d2:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007d6:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02007da:	00cb6b33          	or	s6,s6,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007de:	01977733          	and	a4,a4,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007e2:	0087979b          	slliw	a5,a5,0x8
ffffffffc02007e6:	00eb6b33          	or	s6,s6,a4
ffffffffc02007ea:	00faf7b3          	and	a5,s5,a5
ffffffffc02007ee:	00fb6b33          	or	s6,s6,a5
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007f2:	00c98a13          	addi	s4,s3,12
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007f6:	2b01                	sext.w	s6,s6
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02007f8:	000b9c63          	bnez	s7,ffffffffc0200810 <dtb_init+0x218>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02007fc:	1b02                	slli	s6,s6,0x20
ffffffffc02007fe:	020b5b13          	srli	s6,s6,0x20
ffffffffc0200802:	0a0d                	addi	s4,s4,3
ffffffffc0200804:	9a5a                	add	s4,s4,s6
ffffffffc0200806:	ffca7a13          	andi	s4,s4,-4
                break;
ffffffffc020080a:	7b02                	ld	s6,32(sp)
        switch (token) {
ffffffffc020080c:	89d2                	mv	s3,s4
ffffffffc020080e:	bded                	j	ffffffffc0200708 <dtb_init+0x110>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200810:	0086d51b          	srliw	a0,a3,0x8
ffffffffc0200814:	0186979b          	slliw	a5,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200818:	0186d71b          	srliw	a4,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020081c:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200820:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200824:	01957533          	and	a0,a0,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200828:	8fd9                	or	a5,a5,a4
ffffffffc020082a:	0086969b          	slliw	a3,a3,0x8
ffffffffc020082e:	8d5d                	or	a0,a0,a5
ffffffffc0200830:	00daf6b3          	and	a3,s5,a3
ffffffffc0200834:	8d55                	or	a0,a0,a3
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200836:	1502                	slli	a0,a0,0x20
ffffffffc0200838:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020083a:	00005597          	auipc	a1,0x5
ffffffffc020083e:	58e58593          	addi	a1,a1,1422 # ffffffffc0205dc8 <etext+0x35a>
ffffffffc0200842:	9522                	add	a0,a0,s0
ffffffffc0200844:	18a050ef          	jal	ffffffffc02059ce <strcmp>
ffffffffc0200848:	f955                	bnez	a0,ffffffffc02007fc <dtb_init+0x204>
ffffffffc020084a:	47bd                	li	a5,15
ffffffffc020084c:	fb67f8e3          	bgeu	a5,s6,ffffffffc02007fc <dtb_init+0x204>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200850:	00c9b783          	ld	a5,12(s3)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc0200854:	0149b703          	ld	a4,20(s3)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200858:	00005517          	auipc	a0,0x5
ffffffffc020085c:	57850513          	addi	a0,a0,1400 # ffffffffc0205dd0 <etext+0x362>
           fdt32_to_cpu(x >> 32);
ffffffffc0200860:	4207d693          	srai	a3,a5,0x20
ffffffffc0200864:	42075813          	srai	a6,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200868:	0187d39b          	srliw	t2,a5,0x18
ffffffffc020086c:	0186d29b          	srliw	t0,a3,0x18
ffffffffc0200870:	01875f9b          	srliw	t6,a4,0x18
ffffffffc0200874:	01885f1b          	srliw	t5,a6,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200878:	0087d49b          	srliw	s1,a5,0x8
ffffffffc020087c:	0087541b          	srliw	s0,a4,0x8
ffffffffc0200880:	01879e9b          	slliw	t4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200884:	0107d59b          	srliw	a1,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200888:	01869e1b          	slliw	t3,a3,0x18
ffffffffc020088c:	0187131b          	slliw	t1,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200890:	0107561b          	srliw	a2,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200894:	0188189b          	slliw	a7,a6,0x18
ffffffffc0200898:	83e1                	srli	a5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020089a:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020089e:	8361                	srli	a4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008a0:	0108581b          	srliw	a6,a6,0x10
ffffffffc02008a4:	005e6e33          	or	t3,t3,t0
ffffffffc02008a8:	01e8e8b3          	or	a7,a7,t5
ffffffffc02008ac:	0088181b          	slliw	a6,a6,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008b0:	0104949b          	slliw	s1,s1,0x10
ffffffffc02008b4:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008b8:	0085959b          	slliw	a1,a1,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008bc:	0197f7b3          	and	a5,a5,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008c0:	0086969b          	slliw	a3,a3,0x8
ffffffffc02008c4:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c8:	01977733          	and	a4,a4,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008cc:	00daf6b3          	and	a3,s5,a3
ffffffffc02008d0:	007eeeb3          	or	t4,t4,t2
ffffffffc02008d4:	01f36333          	or	t1,t1,t6
ffffffffc02008d8:	01c7e7b3          	or	a5,a5,t3
ffffffffc02008dc:	00caf633          	and	a2,s5,a2
ffffffffc02008e0:	01176733          	or	a4,a4,a7
ffffffffc02008e4:	00baf5b3          	and	a1,s5,a1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008e8:	0194f4b3          	and	s1,s1,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008ec:	010afab3          	and	s5,s5,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008f0:	01947433          	and	s0,s0,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008f4:	01d4e4b3          	or	s1,s1,t4
ffffffffc02008f8:	00646433          	or	s0,s0,t1
ffffffffc02008fc:	8fd5                	or	a5,a5,a3
ffffffffc02008fe:	01576733          	or	a4,a4,s5
ffffffffc0200902:	8c51                	or	s0,s0,a2
ffffffffc0200904:	8ccd                	or	s1,s1,a1
           fdt32_to_cpu(x >> 32);
ffffffffc0200906:	1782                	slli	a5,a5,0x20
ffffffffc0200908:	1702                	slli	a4,a4,0x20
ffffffffc020090a:	9381                	srli	a5,a5,0x20
ffffffffc020090c:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020090e:	1482                	slli	s1,s1,0x20
ffffffffc0200910:	1402                	slli	s0,s0,0x20
ffffffffc0200912:	8cdd                	or	s1,s1,a5
ffffffffc0200914:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200916:	87fff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc020091a:	85a6                	mv	a1,s1
ffffffffc020091c:	00005517          	auipc	a0,0x5
ffffffffc0200920:	4d450513          	addi	a0,a0,1236 # ffffffffc0205df0 <etext+0x382>
ffffffffc0200924:	871ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200928:	01445613          	srli	a2,s0,0x14
ffffffffc020092c:	85a2                	mv	a1,s0
ffffffffc020092e:	00005517          	auipc	a0,0x5
ffffffffc0200932:	4da50513          	addi	a0,a0,1242 # ffffffffc0205e08 <etext+0x39a>
ffffffffc0200936:	85fff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020093a:	009405b3          	add	a1,s0,s1
ffffffffc020093e:	15fd                	addi	a1,a1,-1
ffffffffc0200940:	00005517          	auipc	a0,0x5
ffffffffc0200944:	4e850513          	addi	a0,a0,1256 # ffffffffc0205e28 <etext+0x3ba>
ffffffffc0200948:	84dff0ef          	jal	ffffffffc0200194 <cprintf>
        memory_base = mem_base;
ffffffffc020094c:	7b02                	ld	s6,32(sp)
ffffffffc020094e:	0009e797          	auipc	a5,0x9e
ffffffffc0200952:	4c97b123          	sd	s1,1218(a5) # ffffffffc029ee10 <memory_base>
        memory_size = mem_size;
ffffffffc0200956:	0009e797          	auipc	a5,0x9e
ffffffffc020095a:	4a87b923          	sd	s0,1202(a5) # ffffffffc029ee08 <memory_size>
ffffffffc020095e:	b501                	j	ffffffffc020075e <dtb_init+0x166>

ffffffffc0200960 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200960:	0009e517          	auipc	a0,0x9e
ffffffffc0200964:	4b053503          	ld	a0,1200(a0) # ffffffffc029ee10 <memory_base>
ffffffffc0200968:	8082                	ret

ffffffffc020096a <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc020096a:	0009e517          	auipc	a0,0x9e
ffffffffc020096e:	49e53503          	ld	a0,1182(a0) # ffffffffc029ee08 <memory_size>
ffffffffc0200972:	8082                	ret

ffffffffc0200974 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200974:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200978:	8082                	ret

ffffffffc020097a <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc020097a:	100177f3          	csrrci	a5,sstatus,2
ffffffffc020097e:	8082                	ret

ffffffffc0200980 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc0200980:	8082                	ret

ffffffffc0200982 <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc0200982:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200986:	00000797          	auipc	a5,0x0
ffffffffc020098a:	56e78793          	addi	a5,a5,1390 # ffffffffc0200ef4 <__alltraps>
ffffffffc020098e:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc0200992:	000407b7          	lui	a5,0x40
ffffffffc0200996:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc020099a:	8082                	ret

ffffffffc020099c <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020099c:	610c                	ld	a1,0(a0)
{
ffffffffc020099e:	1141                	addi	sp,sp,-16
ffffffffc02009a0:	e022                	sd	s0,0(sp)
ffffffffc02009a2:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009a4:	00005517          	auipc	a0,0x5
ffffffffc02009a8:	4ec50513          	addi	a0,a0,1260 # ffffffffc0205e90 <etext+0x422>
{
ffffffffc02009ac:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009ae:	fe6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009b2:	640c                	ld	a1,8(s0)
ffffffffc02009b4:	00005517          	auipc	a0,0x5
ffffffffc02009b8:	4f450513          	addi	a0,a0,1268 # ffffffffc0205ea8 <etext+0x43a>
ffffffffc02009bc:	fd8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009c0:	680c                	ld	a1,16(s0)
ffffffffc02009c2:	00005517          	auipc	a0,0x5
ffffffffc02009c6:	4fe50513          	addi	a0,a0,1278 # ffffffffc0205ec0 <etext+0x452>
ffffffffc02009ca:	fcaff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02009ce:	6c0c                	ld	a1,24(s0)
ffffffffc02009d0:	00005517          	auipc	a0,0x5
ffffffffc02009d4:	50850513          	addi	a0,a0,1288 # ffffffffc0205ed8 <etext+0x46a>
ffffffffc02009d8:	fbcff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02009dc:	700c                	ld	a1,32(s0)
ffffffffc02009de:	00005517          	auipc	a0,0x5
ffffffffc02009e2:	51250513          	addi	a0,a0,1298 # ffffffffc0205ef0 <etext+0x482>
ffffffffc02009e6:	faeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02009ea:	740c                	ld	a1,40(s0)
ffffffffc02009ec:	00005517          	auipc	a0,0x5
ffffffffc02009f0:	51c50513          	addi	a0,a0,1308 # ffffffffc0205f08 <etext+0x49a>
ffffffffc02009f4:	fa0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02009f8:	780c                	ld	a1,48(s0)
ffffffffc02009fa:	00005517          	auipc	a0,0x5
ffffffffc02009fe:	52650513          	addi	a0,a0,1318 # ffffffffc0205f20 <etext+0x4b2>
ffffffffc0200a02:	f92ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a06:	7c0c                	ld	a1,56(s0)
ffffffffc0200a08:	00005517          	auipc	a0,0x5
ffffffffc0200a0c:	53050513          	addi	a0,a0,1328 # ffffffffc0205f38 <etext+0x4ca>
ffffffffc0200a10:	f84ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a14:	602c                	ld	a1,64(s0)
ffffffffc0200a16:	00005517          	auipc	a0,0x5
ffffffffc0200a1a:	53a50513          	addi	a0,a0,1338 # ffffffffc0205f50 <etext+0x4e2>
ffffffffc0200a1e:	f76ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a22:	642c                	ld	a1,72(s0)
ffffffffc0200a24:	00005517          	auipc	a0,0x5
ffffffffc0200a28:	54450513          	addi	a0,a0,1348 # ffffffffc0205f68 <etext+0x4fa>
ffffffffc0200a2c:	f68ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a30:	682c                	ld	a1,80(s0)
ffffffffc0200a32:	00005517          	auipc	a0,0x5
ffffffffc0200a36:	54e50513          	addi	a0,a0,1358 # ffffffffc0205f80 <etext+0x512>
ffffffffc0200a3a:	f5aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a3e:	6c2c                	ld	a1,88(s0)
ffffffffc0200a40:	00005517          	auipc	a0,0x5
ffffffffc0200a44:	55850513          	addi	a0,a0,1368 # ffffffffc0205f98 <etext+0x52a>
ffffffffc0200a48:	f4cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a4c:	702c                	ld	a1,96(s0)
ffffffffc0200a4e:	00005517          	auipc	a0,0x5
ffffffffc0200a52:	56250513          	addi	a0,a0,1378 # ffffffffc0205fb0 <etext+0x542>
ffffffffc0200a56:	f3eff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a5a:	742c                	ld	a1,104(s0)
ffffffffc0200a5c:	00005517          	auipc	a0,0x5
ffffffffc0200a60:	56c50513          	addi	a0,a0,1388 # ffffffffc0205fc8 <etext+0x55a>
ffffffffc0200a64:	f30ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200a68:	782c                	ld	a1,112(s0)
ffffffffc0200a6a:	00005517          	auipc	a0,0x5
ffffffffc0200a6e:	57650513          	addi	a0,a0,1398 # ffffffffc0205fe0 <etext+0x572>
ffffffffc0200a72:	f22ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200a76:	7c2c                	ld	a1,120(s0)
ffffffffc0200a78:	00005517          	auipc	a0,0x5
ffffffffc0200a7c:	58050513          	addi	a0,a0,1408 # ffffffffc0205ff8 <etext+0x58a>
ffffffffc0200a80:	f14ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200a84:	604c                	ld	a1,128(s0)
ffffffffc0200a86:	00005517          	auipc	a0,0x5
ffffffffc0200a8a:	58a50513          	addi	a0,a0,1418 # ffffffffc0206010 <etext+0x5a2>
ffffffffc0200a8e:	f06ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200a92:	644c                	ld	a1,136(s0)
ffffffffc0200a94:	00005517          	auipc	a0,0x5
ffffffffc0200a98:	59450513          	addi	a0,a0,1428 # ffffffffc0206028 <etext+0x5ba>
ffffffffc0200a9c:	ef8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200aa0:	684c                	ld	a1,144(s0)
ffffffffc0200aa2:	00005517          	auipc	a0,0x5
ffffffffc0200aa6:	59e50513          	addi	a0,a0,1438 # ffffffffc0206040 <etext+0x5d2>
ffffffffc0200aaa:	eeaff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200aae:	6c4c                	ld	a1,152(s0)
ffffffffc0200ab0:	00005517          	auipc	a0,0x5
ffffffffc0200ab4:	5a850513          	addi	a0,a0,1448 # ffffffffc0206058 <etext+0x5ea>
ffffffffc0200ab8:	edcff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200abc:	704c                	ld	a1,160(s0)
ffffffffc0200abe:	00005517          	auipc	a0,0x5
ffffffffc0200ac2:	5b250513          	addi	a0,a0,1458 # ffffffffc0206070 <etext+0x602>
ffffffffc0200ac6:	eceff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200aca:	744c                	ld	a1,168(s0)
ffffffffc0200acc:	00005517          	auipc	a0,0x5
ffffffffc0200ad0:	5bc50513          	addi	a0,a0,1468 # ffffffffc0206088 <etext+0x61a>
ffffffffc0200ad4:	ec0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200ad8:	784c                	ld	a1,176(s0)
ffffffffc0200ada:	00005517          	auipc	a0,0x5
ffffffffc0200ade:	5c650513          	addi	a0,a0,1478 # ffffffffc02060a0 <etext+0x632>
ffffffffc0200ae2:	eb2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200ae6:	7c4c                	ld	a1,184(s0)
ffffffffc0200ae8:	00005517          	auipc	a0,0x5
ffffffffc0200aec:	5d050513          	addi	a0,a0,1488 # ffffffffc02060b8 <etext+0x64a>
ffffffffc0200af0:	ea4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200af4:	606c                	ld	a1,192(s0)
ffffffffc0200af6:	00005517          	auipc	a0,0x5
ffffffffc0200afa:	5da50513          	addi	a0,a0,1498 # ffffffffc02060d0 <etext+0x662>
ffffffffc0200afe:	e96ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b02:	646c                	ld	a1,200(s0)
ffffffffc0200b04:	00005517          	auipc	a0,0x5
ffffffffc0200b08:	5e450513          	addi	a0,a0,1508 # ffffffffc02060e8 <etext+0x67a>
ffffffffc0200b0c:	e88ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b10:	686c                	ld	a1,208(s0)
ffffffffc0200b12:	00005517          	auipc	a0,0x5
ffffffffc0200b16:	5ee50513          	addi	a0,a0,1518 # ffffffffc0206100 <etext+0x692>
ffffffffc0200b1a:	e7aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b1e:	6c6c                	ld	a1,216(s0)
ffffffffc0200b20:	00005517          	auipc	a0,0x5
ffffffffc0200b24:	5f850513          	addi	a0,a0,1528 # ffffffffc0206118 <etext+0x6aa>
ffffffffc0200b28:	e6cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b2c:	706c                	ld	a1,224(s0)
ffffffffc0200b2e:	00005517          	auipc	a0,0x5
ffffffffc0200b32:	60250513          	addi	a0,a0,1538 # ffffffffc0206130 <etext+0x6c2>
ffffffffc0200b36:	e5eff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b3a:	746c                	ld	a1,232(s0)
ffffffffc0200b3c:	00005517          	auipc	a0,0x5
ffffffffc0200b40:	60c50513          	addi	a0,a0,1548 # ffffffffc0206148 <etext+0x6da>
ffffffffc0200b44:	e50ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b48:	786c                	ld	a1,240(s0)
ffffffffc0200b4a:	00005517          	auipc	a0,0x5
ffffffffc0200b4e:	61650513          	addi	a0,a0,1558 # ffffffffc0206160 <etext+0x6f2>
ffffffffc0200b52:	e42ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b56:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b58:	6402                	ld	s0,0(sp)
ffffffffc0200b5a:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b5c:	00005517          	auipc	a0,0x5
ffffffffc0200b60:	61c50513          	addi	a0,a0,1564 # ffffffffc0206178 <etext+0x70a>
}
ffffffffc0200b64:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b66:	e2eff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200b6a <print_trapframe>:
{
ffffffffc0200b6a:	1141                	addi	sp,sp,-16
ffffffffc0200b6c:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b6e:	85aa                	mv	a1,a0
{
ffffffffc0200b70:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b72:	00005517          	auipc	a0,0x5
ffffffffc0200b76:	61e50513          	addi	a0,a0,1566 # ffffffffc0206190 <etext+0x722>
{
ffffffffc0200b7a:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b7c:	e18ff0ef          	jal	ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200b80:	8522                	mv	a0,s0
ffffffffc0200b82:	e1bff0ef          	jal	ffffffffc020099c <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200b86:	10043583          	ld	a1,256(s0)
ffffffffc0200b8a:	00005517          	auipc	a0,0x5
ffffffffc0200b8e:	61e50513          	addi	a0,a0,1566 # ffffffffc02061a8 <etext+0x73a>
ffffffffc0200b92:	e02ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200b96:	10843583          	ld	a1,264(s0)
ffffffffc0200b9a:	00005517          	auipc	a0,0x5
ffffffffc0200b9e:	62650513          	addi	a0,a0,1574 # ffffffffc02061c0 <etext+0x752>
ffffffffc0200ba2:	df2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200ba6:	11043583          	ld	a1,272(s0)
ffffffffc0200baa:	00005517          	auipc	a0,0x5
ffffffffc0200bae:	62e50513          	addi	a0,a0,1582 # ffffffffc02061d8 <etext+0x76a>
ffffffffc0200bb2:	de2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bb6:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bba:	6402                	ld	s0,0(sp)
ffffffffc0200bbc:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bbe:	00005517          	auipc	a0,0x5
ffffffffc0200bc2:	62a50513          	addi	a0,a0,1578 # ffffffffc02061e8 <etext+0x77a>
}
ffffffffc0200bc6:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bc8:	dccff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200bcc <interrupt_handler>:
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause)
ffffffffc0200bcc:	11853783          	ld	a5,280(a0)
ffffffffc0200bd0:	472d                	li	a4,11
ffffffffc0200bd2:	0786                	slli	a5,a5,0x1
ffffffffc0200bd4:	8385                	srli	a5,a5,0x1
ffffffffc0200bd6:	06f76d63          	bltu	a4,a5,ffffffffc0200c50 <interrupt_handler+0x84>
ffffffffc0200bda:	00007717          	auipc	a4,0x7
ffffffffc0200bde:	c2670713          	addi	a4,a4,-986 # ffffffffc0207800 <commands+0x48>
ffffffffc0200be2:	078a                	slli	a5,a5,0x2
ffffffffc0200be4:	97ba                	add	a5,a5,a4
ffffffffc0200be6:	439c                	lw	a5,0(a5)
ffffffffc0200be8:	97ba                	add	a5,a5,a4
ffffffffc0200bea:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200bec:	00005517          	auipc	a0,0x5
ffffffffc0200bf0:	67450513          	addi	a0,a0,1652 # ffffffffc0206260 <etext+0x7f2>
ffffffffc0200bf4:	da0ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200bf8:	00005517          	auipc	a0,0x5
ffffffffc0200bfc:	64850513          	addi	a0,a0,1608 # ffffffffc0206240 <etext+0x7d2>
ffffffffc0200c00:	d94ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c04:	00005517          	auipc	a0,0x5
ffffffffc0200c08:	5fc50513          	addi	a0,a0,1532 # ffffffffc0206200 <etext+0x792>
ffffffffc0200c0c:	d88ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c10:	00005517          	auipc	a0,0x5
ffffffffc0200c14:	61050513          	addi	a0,a0,1552 # ffffffffc0206220 <etext+0x7b2>
ffffffffc0200c18:	d7cff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200c1c:	1141                	addi	sp,sp,-16
ffffffffc0200c1e:	e406                	sd	ra,8(sp)
        /* 时间片轮转： 
        *(1) 设置下一次时钟中断（clock_set_next_event）
        *(2) ticks 计数器自增
        *(3) 每 TICK_NUM 次中断（如 100 次），进行判断当前是否有进程正在运行，如果有则标记该进程需要被重新调度（current->need_resched）
        */
        clock_set_next_event();  // (1) 设置下一次时钟中断
ffffffffc0200c20:	94dff0ef          	jal	ffffffffc020056c <clock_set_next_event>
        ticks++;                 // (2) ticks 计数器自增
ffffffffc0200c24:	0009e797          	auipc	a5,0x9e
ffffffffc0200c28:	1dc78793          	addi	a5,a5,476 # ffffffffc029ee00 <ticks>
ffffffffc0200c2c:	6398                	ld	a4,0(a5)
ffffffffc0200c2e:	0705                	addi	a4,a4,1
ffffffffc0200c30:	e398                	sd	a4,0(a5)
        if (ticks % TICK_NUM == 0) {  // (3) 每 TICK_NUM 次中断
ffffffffc0200c32:	639c                	ld	a5,0(a5)
ffffffffc0200c34:	06400713          	li	a4,100
ffffffffc0200c38:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200c3c:	cb99                	beqz	a5,ffffffffc0200c52 <interrupt_handler+0x86>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c3e:	60a2                	ld	ra,8(sp)
ffffffffc0200c40:	0141                	addi	sp,sp,16
ffffffffc0200c42:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c44:	00005517          	auipc	a0,0x5
ffffffffc0200c48:	64c50513          	addi	a0,a0,1612 # ffffffffc0206290 <etext+0x822>
ffffffffc0200c4c:	d48ff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200c50:	bf29                	j	ffffffffc0200b6a <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200c52:	06400593          	li	a1,100
ffffffffc0200c56:	00005517          	auipc	a0,0x5
ffffffffc0200c5a:	62a50513          	addi	a0,a0,1578 # ffffffffc0206280 <etext+0x812>
ffffffffc0200c5e:	d36ff0ef          	jal	ffffffffc0200194 <cprintf>
            print_count++;
ffffffffc0200c62:	0009e717          	auipc	a4,0x9e
ffffffffc0200c66:	1b670713          	addi	a4,a4,438 # ffffffffc029ee18 <print_count>
ffffffffc0200c6a:	431c                	lw	a5,0(a4)
            if (print_count >= 10) {  // 打印10次后关机
ffffffffc0200c6c:	46a5                	li	a3,9
            print_count++;
ffffffffc0200c6e:	0017861b          	addiw	a2,a5,1
ffffffffc0200c72:	c310                	sw	a2,0(a4)
            if (print_count >= 10) {  // 打印10次后关机
ffffffffc0200c74:	00c6d863          	bge	a3,a2,ffffffffc0200c84 <interrupt_handler+0xb8>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200c78:	4501                	li	a0,0
ffffffffc0200c7a:	4581                	li	a1,0
ffffffffc0200c7c:	4601                	li	a2,0
ffffffffc0200c7e:	48a1                	li	a7,8
ffffffffc0200c80:	00000073          	ecall
            if (current != NULL) {
ffffffffc0200c84:	0009e797          	auipc	a5,0x9e
ffffffffc0200c88:	1dc7b783          	ld	a5,476(a5) # ffffffffc029ee60 <current>
ffffffffc0200c8c:	dbcd                	beqz	a5,ffffffffc0200c3e <interrupt_handler+0x72>
                current->need_resched = 1;
ffffffffc0200c8e:	4705                	li	a4,1
ffffffffc0200c90:	ef98                	sd	a4,24(a5)
ffffffffc0200c92:	b775                	j	ffffffffc0200c3e <interrupt_handler+0x72>

ffffffffc0200c94 <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200c94:	11853783          	ld	a5,280(a0)
{
ffffffffc0200c98:	1141                	addi	sp,sp,-16
ffffffffc0200c9a:	e022                	sd	s0,0(sp)
ffffffffc0200c9c:	e406                	sd	ra,8(sp)
    switch (tf->cause)
ffffffffc0200c9e:	473d                	li	a4,15
{
ffffffffc0200ca0:	842a                	mv	s0,a0
    switch (tf->cause)
ffffffffc0200ca2:	18f76463          	bltu	a4,a5,ffffffffc0200e2a <exception_handler+0x196>
ffffffffc0200ca6:	00007717          	auipc	a4,0x7
ffffffffc0200caa:	b8a70713          	addi	a4,a4,-1142 # ffffffffc0207830 <commands+0x78>
ffffffffc0200cae:	078a                	slli	a5,a5,0x2
ffffffffc0200cb0:	97ba                	add	a5,a5,a4
ffffffffc0200cb2:	439c                	lw	a5,0(a5)
ffffffffc0200cb4:	97ba                	add	a5,a5,a4
ffffffffc0200cb6:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200cb8:	00005517          	auipc	a0,0x5
ffffffffc0200cbc:	6e050513          	addi	a0,a0,1760 # ffffffffc0206398 <etext+0x92a>
ffffffffc0200cc0:	cd4ff0ef          	jal	ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200cc4:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cc8:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200cca:	0791                	addi	a5,a5,4
ffffffffc0200ccc:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200cd0:	6402                	ld	s0,0(sp)
ffffffffc0200cd2:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200cd4:	0350406f          	j	ffffffffc0205508 <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200cd8:	00005517          	auipc	a0,0x5
ffffffffc0200cdc:	6e050513          	addi	a0,a0,1760 # ffffffffc02063b8 <etext+0x94a>
}
ffffffffc0200ce0:	6402                	ld	s0,0(sp)
ffffffffc0200ce2:	60a2                	ld	ra,8(sp)
ffffffffc0200ce4:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200ce6:	caeff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200cea:	00005517          	auipc	a0,0x5
ffffffffc0200cee:	6ee50513          	addi	a0,a0,1774 # ffffffffc02063d8 <etext+0x96a>
ffffffffc0200cf2:	b7fd                	j	ffffffffc0200ce0 <exception_handler+0x4c>
        cprintf("Instruction page fault at 0x%08lx\n", tf->tval);
ffffffffc0200cf4:	11053583          	ld	a1,272(a0)
ffffffffc0200cf8:	00005517          	auipc	a0,0x5
ffffffffc0200cfc:	70050513          	addi	a0,a0,1792 # ffffffffc02063f8 <etext+0x98a>
ffffffffc0200d00:	c94ff0ef          	jal	ffffffffc0200194 <cprintf>
        if (current != NULL && current->mm != NULL)
ffffffffc0200d04:	0009e797          	auipc	a5,0x9e
ffffffffc0200d08:	15c7b783          	ld	a5,348(a5) # ffffffffc029ee60 <current>
ffffffffc0200d0c:	0e078c63          	beqz	a5,ffffffffc0200e04 <exception_handler+0x170>
ffffffffc0200d10:	7788                	ld	a0,40(a5)
ffffffffc0200d12:	0e050963          	beqz	a0,ffffffffc0200e04 <exception_handler+0x170>
            if (do_pgfault(current->mm, 0, tf->tval) != 0)
ffffffffc0200d16:	11043603          	ld	a2,272(s0)
ffffffffc0200d1a:	4581                	li	a1,0
ffffffffc0200d1c:	0c6030ef          	jal	ffffffffc0203de2 <do_pgfault>
ffffffffc0200d20:	0e050263          	beqz	a0,ffffffffc0200e04 <exception_handler+0x170>
                print_trapframe(tf);
ffffffffc0200d24:	8522                	mv	a0,s0
ffffffffc0200d26:	e45ff0ef          	jal	ffffffffc0200b6a <print_trapframe>
                panic("do_pgfault failed");
ffffffffc0200d2a:	00005617          	auipc	a2,0x5
ffffffffc0200d2e:	6f660613          	addi	a2,a2,1782 # ffffffffc0206420 <etext+0x9b2>
ffffffffc0200d32:	0df00593          	li	a1,223
ffffffffc0200d36:	00005517          	auipc	a0,0x5
ffffffffc0200d3a:	63250513          	addi	a0,a0,1586 # ffffffffc0206368 <etext+0x8fa>
ffffffffc0200d3e:	f4aff0ef          	jal	ffffffffc0200488 <__panic>
        cprintf("Load page fault at 0x%08lx\n", tf->tval);
ffffffffc0200d42:	11053583          	ld	a1,272(a0)
ffffffffc0200d46:	00005517          	auipc	a0,0x5
ffffffffc0200d4a:	6f250513          	addi	a0,a0,1778 # ffffffffc0206438 <etext+0x9ca>
ffffffffc0200d4e:	c46ff0ef          	jal	ffffffffc0200194 <cprintf>
        if (current != NULL && current->mm != NULL)
ffffffffc0200d52:	0009e797          	auipc	a5,0x9e
ffffffffc0200d56:	10e7b783          	ld	a5,270(a5) # ffffffffc029ee60 <current>
ffffffffc0200d5a:	c7cd                	beqz	a5,ffffffffc0200e04 <exception_handler+0x170>
ffffffffc0200d5c:	7788                	ld	a0,40(a5)
ffffffffc0200d5e:	c15d                	beqz	a0,ffffffffc0200e04 <exception_handler+0x170>
            if (do_pgfault(current->mm, 0, tf->tval) != 0)
ffffffffc0200d60:	11043603          	ld	a2,272(s0)
ffffffffc0200d64:	4581                	li	a1,0
ffffffffc0200d66:	07c030ef          	jal	ffffffffc0203de2 <do_pgfault>
ffffffffc0200d6a:	cd49                	beqz	a0,ffffffffc0200e04 <exception_handler+0x170>
                print_trapframe(tf);
ffffffffc0200d6c:	8522                	mv	a0,s0
ffffffffc0200d6e:	dfdff0ef          	jal	ffffffffc0200b6a <print_trapframe>
                panic("do_pgfault failed");
ffffffffc0200d72:	00005617          	auipc	a2,0x5
ffffffffc0200d76:	6ae60613          	addi	a2,a2,1710 # ffffffffc0206420 <etext+0x9b2>
ffffffffc0200d7a:	0eb00593          	li	a1,235
ffffffffc0200d7e:	00005517          	auipc	a0,0x5
ffffffffc0200d82:	5ea50513          	addi	a0,a0,1514 # ffffffffc0206368 <etext+0x8fa>
ffffffffc0200d86:	f02ff0ef          	jal	ffffffffc0200488 <__panic>
        cprintf("Store/AMO page fault at 0x%08lx\n", tf->tval);
ffffffffc0200d8a:	11053583          	ld	a1,272(a0)
ffffffffc0200d8e:	00005517          	auipc	a0,0x5
ffffffffc0200d92:	6ca50513          	addi	a0,a0,1738 # ffffffffc0206458 <etext+0x9ea>
ffffffffc0200d96:	bfeff0ef          	jal	ffffffffc0200194 <cprintf>
        if (current != NULL && current->mm != NULL)
ffffffffc0200d9a:	0009e797          	auipc	a5,0x9e
ffffffffc0200d9e:	0c67b783          	ld	a5,198(a5) # ffffffffc029ee60 <current>
ffffffffc0200da2:	c3ad                	beqz	a5,ffffffffc0200e04 <exception_handler+0x170>
ffffffffc0200da4:	7788                	ld	a0,40(a5)
ffffffffc0200da6:	cd39                	beqz	a0,ffffffffc0200e04 <exception_handler+0x170>
            if (do_pgfault(current->mm, 0x2, tf->tval) != 0)
ffffffffc0200da8:	11043603          	ld	a2,272(s0)
ffffffffc0200dac:	4589                	li	a1,2
ffffffffc0200dae:	034030ef          	jal	ffffffffc0203de2 <do_pgfault>
ffffffffc0200db2:	c929                	beqz	a0,ffffffffc0200e04 <exception_handler+0x170>
                print_trapframe(tf);
ffffffffc0200db4:	8522                	mv	a0,s0
ffffffffc0200db6:	db5ff0ef          	jal	ffffffffc0200b6a <print_trapframe>
                panic("do_pgfault failed");
ffffffffc0200dba:	00005617          	auipc	a2,0x5
ffffffffc0200dbe:	66660613          	addi	a2,a2,1638 # ffffffffc0206420 <etext+0x9b2>
ffffffffc0200dc2:	0f800593          	li	a1,248
ffffffffc0200dc6:	00005517          	auipc	a0,0x5
ffffffffc0200dca:	5a250513          	addi	a0,a0,1442 # ffffffffc0206368 <etext+0x8fa>
ffffffffc0200dce:	ebaff0ef          	jal	ffffffffc0200488 <__panic>
        cprintf("Instruction address misaligned\n");
ffffffffc0200dd2:	00005517          	auipc	a0,0x5
ffffffffc0200dd6:	4de50513          	addi	a0,a0,1246 # ffffffffc02062b0 <etext+0x842>
ffffffffc0200dda:	b719                	j	ffffffffc0200ce0 <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200ddc:	00005517          	auipc	a0,0x5
ffffffffc0200de0:	4f450513          	addi	a0,a0,1268 # ffffffffc02062d0 <etext+0x862>
ffffffffc0200de4:	bdf5                	j	ffffffffc0200ce0 <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200de6:	00005517          	auipc	a0,0x5
ffffffffc0200dea:	50a50513          	addi	a0,a0,1290 # ffffffffc02062f0 <etext+0x882>
ffffffffc0200dee:	bdcd                	j	ffffffffc0200ce0 <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200df0:	00005517          	auipc	a0,0x5
ffffffffc0200df4:	51850513          	addi	a0,a0,1304 # ffffffffc0206308 <etext+0x89a>
ffffffffc0200df8:	b9cff0ef          	jal	ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200dfc:	6458                	ld	a4,136(s0)
ffffffffc0200dfe:	47a9                	li	a5,10
ffffffffc0200e00:	04f70663          	beq	a4,a5,ffffffffc0200e4c <exception_handler+0x1b8>
}
ffffffffc0200e04:	60a2                	ld	ra,8(sp)
ffffffffc0200e06:	6402                	ld	s0,0(sp)
ffffffffc0200e08:	0141                	addi	sp,sp,16
ffffffffc0200e0a:	8082                	ret
        cprintf("Load address misaligned\n");
ffffffffc0200e0c:	00005517          	auipc	a0,0x5
ffffffffc0200e10:	50c50513          	addi	a0,a0,1292 # ffffffffc0206318 <etext+0x8aa>
ffffffffc0200e14:	b5f1                	j	ffffffffc0200ce0 <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200e16:	00005517          	auipc	a0,0x5
ffffffffc0200e1a:	52250513          	addi	a0,a0,1314 # ffffffffc0206338 <etext+0x8ca>
ffffffffc0200e1e:	b5c9                	j	ffffffffc0200ce0 <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200e20:	00005517          	auipc	a0,0x5
ffffffffc0200e24:	56050513          	addi	a0,a0,1376 # ffffffffc0206380 <etext+0x912>
ffffffffc0200e28:	bd65                	j	ffffffffc0200ce0 <exception_handler+0x4c>
        print_trapframe(tf);
ffffffffc0200e2a:	8522                	mv	a0,s0
}
ffffffffc0200e2c:	6402                	ld	s0,0(sp)
ffffffffc0200e2e:	60a2                	ld	ra,8(sp)
ffffffffc0200e30:	0141                	addi	sp,sp,16
        print_trapframe(tf);
ffffffffc0200e32:	bb25                	j	ffffffffc0200b6a <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200e34:	00005617          	auipc	a2,0x5
ffffffffc0200e38:	51c60613          	addi	a2,a2,1308 # ffffffffc0206350 <etext+0x8e2>
ffffffffc0200e3c:	0c200593          	li	a1,194
ffffffffc0200e40:	00005517          	auipc	a0,0x5
ffffffffc0200e44:	52850513          	addi	a0,a0,1320 # ffffffffc0206368 <etext+0x8fa>
ffffffffc0200e48:	e40ff0ef          	jal	ffffffffc0200488 <__panic>
            tf->epc += 4;
ffffffffc0200e4c:	10843783          	ld	a5,264(s0)
ffffffffc0200e50:	0791                	addi	a5,a5,4
ffffffffc0200e52:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200e56:	6b2040ef          	jal	ffffffffc0205508 <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200e5a:	0009e797          	auipc	a5,0x9e
ffffffffc0200e5e:	0067b783          	ld	a5,6(a5) # ffffffffc029ee60 <current>
ffffffffc0200e62:	6b9c                	ld	a5,16(a5)
ffffffffc0200e64:	8522                	mv	a0,s0
}
ffffffffc0200e66:	6402                	ld	s0,0(sp)
ffffffffc0200e68:	60a2                	ld	ra,8(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200e6a:	6589                	lui	a1,0x2
ffffffffc0200e6c:	95be                	add	a1,a1,a5
}
ffffffffc0200e6e:	0141                	addi	sp,sp,16
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200e70:	aa89                	j	ffffffffc0200fc2 <kernel_execve_ret>

ffffffffc0200e72 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200e72:	1101                	addi	sp,sp,-32
ffffffffc0200e74:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200e76:	0009e417          	auipc	s0,0x9e
ffffffffc0200e7a:	fea40413          	addi	s0,s0,-22 # ffffffffc029ee60 <current>
ffffffffc0200e7e:	6018                	ld	a4,0(s0)
{
ffffffffc0200e80:	ec06                	sd	ra,24(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e82:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200e86:	c329                	beqz	a4,ffffffffc0200ec8 <trap+0x56>
ffffffffc0200e88:	e426                	sd	s1,8(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e8a:	10053483          	ld	s1,256(a0)
ffffffffc0200e8e:	e04a                	sd	s2,0(sp)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200e90:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200e94:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e96:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e9a:	0206c463          	bltz	a3,ffffffffc0200ec2 <trap+0x50>
        exception_handler(tf);
ffffffffc0200e9e:	df7ff0ef          	jal	ffffffffc0200c94 <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200ea2:	601c                	ld	a5,0(s0)
ffffffffc0200ea4:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200ea8:	e499                	bnez	s1,ffffffffc0200eb6 <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200eaa:	0b07a703          	lw	a4,176(a5)
ffffffffc0200eae:	8b05                	andi	a4,a4,1
ffffffffc0200eb0:	ef0d                	bnez	a4,ffffffffc0200eea <trap+0x78>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200eb2:	6f9c                	ld	a5,24(a5)
ffffffffc0200eb4:	e785                	bnez	a5,ffffffffc0200edc <trap+0x6a>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200eb6:	60e2                	ld	ra,24(sp)
ffffffffc0200eb8:	6442                	ld	s0,16(sp)
ffffffffc0200eba:	64a2                	ld	s1,8(sp)
ffffffffc0200ebc:	6902                	ld	s2,0(sp)
ffffffffc0200ebe:	6105                	addi	sp,sp,32
ffffffffc0200ec0:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200ec2:	d0bff0ef          	jal	ffffffffc0200bcc <interrupt_handler>
ffffffffc0200ec6:	bff1                	j	ffffffffc0200ea2 <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200ec8:	0006c663          	bltz	a3,ffffffffc0200ed4 <trap+0x62>
}
ffffffffc0200ecc:	6442                	ld	s0,16(sp)
ffffffffc0200ece:	60e2                	ld	ra,24(sp)
ffffffffc0200ed0:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200ed2:	b3c9                	j	ffffffffc0200c94 <exception_handler>
}
ffffffffc0200ed4:	6442                	ld	s0,16(sp)
ffffffffc0200ed6:	60e2                	ld	ra,24(sp)
ffffffffc0200ed8:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200eda:	b9cd                	j	ffffffffc0200bcc <interrupt_handler>
}
ffffffffc0200edc:	6442                	ld	s0,16(sp)
                schedule();
ffffffffc0200ede:	64a2                	ld	s1,8(sp)
ffffffffc0200ee0:	6902                	ld	s2,0(sp)
}
ffffffffc0200ee2:	60e2                	ld	ra,24(sp)
ffffffffc0200ee4:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200ee6:	5360406f          	j	ffffffffc020541c <schedule>
                do_exit(-E_KILLED);
ffffffffc0200eea:	555d                	li	a0,-9
ffffffffc0200eec:	7ca030ef          	jal	ffffffffc02046b6 <do_exit>
            if (current->need_resched)
ffffffffc0200ef0:	601c                	ld	a5,0(s0)
ffffffffc0200ef2:	b7c1                	j	ffffffffc0200eb2 <trap+0x40>

ffffffffc0200ef4 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200ef4:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200ef8:	00011463          	bnez	sp,ffffffffc0200f00 <__alltraps+0xc>
ffffffffc0200efc:	14002173          	csrr	sp,sscratch
ffffffffc0200f00:	712d                	addi	sp,sp,-288
ffffffffc0200f02:	e002                	sd	zero,0(sp)
ffffffffc0200f04:	e406                	sd	ra,8(sp)
ffffffffc0200f06:	ec0e                	sd	gp,24(sp)
ffffffffc0200f08:	f012                	sd	tp,32(sp)
ffffffffc0200f0a:	f416                	sd	t0,40(sp)
ffffffffc0200f0c:	f81a                	sd	t1,48(sp)
ffffffffc0200f0e:	fc1e                	sd	t2,56(sp)
ffffffffc0200f10:	e0a2                	sd	s0,64(sp)
ffffffffc0200f12:	e4a6                	sd	s1,72(sp)
ffffffffc0200f14:	e8aa                	sd	a0,80(sp)
ffffffffc0200f16:	ecae                	sd	a1,88(sp)
ffffffffc0200f18:	f0b2                	sd	a2,96(sp)
ffffffffc0200f1a:	f4b6                	sd	a3,104(sp)
ffffffffc0200f1c:	f8ba                	sd	a4,112(sp)
ffffffffc0200f1e:	fcbe                	sd	a5,120(sp)
ffffffffc0200f20:	e142                	sd	a6,128(sp)
ffffffffc0200f22:	e546                	sd	a7,136(sp)
ffffffffc0200f24:	e94a                	sd	s2,144(sp)
ffffffffc0200f26:	ed4e                	sd	s3,152(sp)
ffffffffc0200f28:	f152                	sd	s4,160(sp)
ffffffffc0200f2a:	f556                	sd	s5,168(sp)
ffffffffc0200f2c:	f95a                	sd	s6,176(sp)
ffffffffc0200f2e:	fd5e                	sd	s7,184(sp)
ffffffffc0200f30:	e1e2                	sd	s8,192(sp)
ffffffffc0200f32:	e5e6                	sd	s9,200(sp)
ffffffffc0200f34:	e9ea                	sd	s10,208(sp)
ffffffffc0200f36:	edee                	sd	s11,216(sp)
ffffffffc0200f38:	f1f2                	sd	t3,224(sp)
ffffffffc0200f3a:	f5f6                	sd	t4,232(sp)
ffffffffc0200f3c:	f9fa                	sd	t5,240(sp)
ffffffffc0200f3e:	fdfe                	sd	t6,248(sp)
ffffffffc0200f40:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200f44:	100024f3          	csrr	s1,sstatus
ffffffffc0200f48:	14102973          	csrr	s2,sepc
ffffffffc0200f4c:	143029f3          	csrr	s3,stval
ffffffffc0200f50:	14202a73          	csrr	s4,scause
ffffffffc0200f54:	e822                	sd	s0,16(sp)
ffffffffc0200f56:	e226                	sd	s1,256(sp)
ffffffffc0200f58:	e64a                	sd	s2,264(sp)
ffffffffc0200f5a:	ea4e                	sd	s3,272(sp)
ffffffffc0200f5c:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200f5e:	850a                	mv	a0,sp
    jal trap
ffffffffc0200f60:	f13ff0ef          	jal	ffffffffc0200e72 <trap>

ffffffffc0200f64 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200f64:	6492                	ld	s1,256(sp)
ffffffffc0200f66:	6932                	ld	s2,264(sp)
ffffffffc0200f68:	1004f413          	andi	s0,s1,256
ffffffffc0200f6c:	e401                	bnez	s0,ffffffffc0200f74 <__trapret+0x10>
ffffffffc0200f6e:	1200                	addi	s0,sp,288
ffffffffc0200f70:	14041073          	csrw	sscratch,s0
ffffffffc0200f74:	10049073          	csrw	sstatus,s1
ffffffffc0200f78:	14191073          	csrw	sepc,s2
ffffffffc0200f7c:	60a2                	ld	ra,8(sp)
ffffffffc0200f7e:	61e2                	ld	gp,24(sp)
ffffffffc0200f80:	7202                	ld	tp,32(sp)
ffffffffc0200f82:	72a2                	ld	t0,40(sp)
ffffffffc0200f84:	7342                	ld	t1,48(sp)
ffffffffc0200f86:	73e2                	ld	t2,56(sp)
ffffffffc0200f88:	6406                	ld	s0,64(sp)
ffffffffc0200f8a:	64a6                	ld	s1,72(sp)
ffffffffc0200f8c:	6546                	ld	a0,80(sp)
ffffffffc0200f8e:	65e6                	ld	a1,88(sp)
ffffffffc0200f90:	7606                	ld	a2,96(sp)
ffffffffc0200f92:	76a6                	ld	a3,104(sp)
ffffffffc0200f94:	7746                	ld	a4,112(sp)
ffffffffc0200f96:	77e6                	ld	a5,120(sp)
ffffffffc0200f98:	680a                	ld	a6,128(sp)
ffffffffc0200f9a:	68aa                	ld	a7,136(sp)
ffffffffc0200f9c:	694a                	ld	s2,144(sp)
ffffffffc0200f9e:	69ea                	ld	s3,152(sp)
ffffffffc0200fa0:	7a0a                	ld	s4,160(sp)
ffffffffc0200fa2:	7aaa                	ld	s5,168(sp)
ffffffffc0200fa4:	7b4a                	ld	s6,176(sp)
ffffffffc0200fa6:	7bea                	ld	s7,184(sp)
ffffffffc0200fa8:	6c0e                	ld	s8,192(sp)
ffffffffc0200faa:	6cae                	ld	s9,200(sp)
ffffffffc0200fac:	6d4e                	ld	s10,208(sp)
ffffffffc0200fae:	6dee                	ld	s11,216(sp)
ffffffffc0200fb0:	7e0e                	ld	t3,224(sp)
ffffffffc0200fb2:	7eae                	ld	t4,232(sp)
ffffffffc0200fb4:	7f4e                	ld	t5,240(sp)
ffffffffc0200fb6:	7fee                	ld	t6,248(sp)
ffffffffc0200fb8:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200fba:	10200073          	sret

ffffffffc0200fbe <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200fbe:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200fc0:	b755                	j	ffffffffc0200f64 <__trapret>

ffffffffc0200fc2 <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200fc2:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_softint_out_size-0x66b8>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200fc6:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200fca:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200fce:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200fd2:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200fd6:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200fda:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200fde:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200fe2:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200fe6:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200fe8:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200fea:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200fec:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200fee:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200ff0:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200ff2:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200ff4:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200ff6:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200ff8:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200ffa:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200ffc:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200ffe:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0201000:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0201002:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0201004:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0201006:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0201008:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc020100a:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc020100c:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc020100e:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0201010:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0201012:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0201014:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0201016:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0201018:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc020101a:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc020101c:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc020101e:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0201020:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0201022:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0201024:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0201026:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0201028:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc020102a:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc020102c:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc020102e:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0201030:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0201032:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0201034:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0201036:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0201038:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc020103a:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc020103c:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc020103e:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0201040:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0201042:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0201044:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0201046:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0201048:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc020104a:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc020104c:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc020104e:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0201050:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0201052:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0201054:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0201056:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0201058:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc020105a:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc020105c:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc020105e:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0201060:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0201062:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0201064:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0201066:	812e                	mv	sp,a1
ffffffffc0201068:	bdf5                	j	ffffffffc0200f64 <__trapret>

ffffffffc020106a <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc020106a:	0009a797          	auipc	a5,0x9a
ffffffffc020106e:	d5e78793          	addi	a5,a5,-674 # ffffffffc029adc8 <free_area>
ffffffffc0201072:	e79c                	sd	a5,8(a5)
ffffffffc0201074:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0201076:	0007a823          	sw	zero,16(a5)
}
ffffffffc020107a:	8082                	ret

ffffffffc020107c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc020107c:	0009a517          	auipc	a0,0x9a
ffffffffc0201080:	d5c56503          	lwu	a0,-676(a0) # ffffffffc029add8 <free_area+0x10>
ffffffffc0201084:	8082                	ret

ffffffffc0201086 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0201086:	715d                	addi	sp,sp,-80
ffffffffc0201088:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc020108a:	0009a417          	auipc	s0,0x9a
ffffffffc020108e:	d3e40413          	addi	s0,s0,-706 # ffffffffc029adc8 <free_area>
ffffffffc0201092:	641c                	ld	a5,8(s0)
ffffffffc0201094:	e486                	sd	ra,72(sp)
ffffffffc0201096:	fc26                	sd	s1,56(sp)
ffffffffc0201098:	f84a                	sd	s2,48(sp)
ffffffffc020109a:	f44e                	sd	s3,40(sp)
ffffffffc020109c:	f052                	sd	s4,32(sp)
ffffffffc020109e:	ec56                	sd	s5,24(sp)
ffffffffc02010a0:	e85a                	sd	s6,16(sp)
ffffffffc02010a2:	e45e                	sd	s7,8(sp)
ffffffffc02010a4:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc02010a6:	2a878963          	beq	a5,s0,ffffffffc0201358 <default_check+0x2d2>
    int count = 0, total = 0;
ffffffffc02010aa:	4481                	li	s1,0
ffffffffc02010ac:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02010ae:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02010b2:	8b09                	andi	a4,a4,2
ffffffffc02010b4:	2a070663          	beqz	a4,ffffffffc0201360 <default_check+0x2da>
        count ++, total += p->property;
ffffffffc02010b8:	ff87a703          	lw	a4,-8(a5)
ffffffffc02010bc:	679c                	ld	a5,8(a5)
ffffffffc02010be:	2905                	addiw	s2,s2,1
ffffffffc02010c0:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc02010c2:	fe8796e3          	bne	a5,s0,ffffffffc02010ae <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc02010c6:	89a6                	mv	s3,s1
ffffffffc02010c8:	6bb000ef          	jal	ffffffffc0201f82 <nr_free_pages>
ffffffffc02010cc:	6f351a63          	bne	a0,s3,ffffffffc02017c0 <default_check+0x73a>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02010d0:	4505                	li	a0,1
ffffffffc02010d2:	633000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc02010d6:	8aaa                	mv	s5,a0
ffffffffc02010d8:	42050463          	beqz	a0,ffffffffc0201500 <default_check+0x47a>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02010dc:	4505                	li	a0,1
ffffffffc02010de:	627000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc02010e2:	89aa                	mv	s3,a0
ffffffffc02010e4:	6e050e63          	beqz	a0,ffffffffc02017e0 <default_check+0x75a>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02010e8:	4505                	li	a0,1
ffffffffc02010ea:	61b000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc02010ee:	8a2a                	mv	s4,a0
ffffffffc02010f0:	48050863          	beqz	a0,ffffffffc0201580 <default_check+0x4fa>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02010f4:	293a8663          	beq	s5,s3,ffffffffc0201380 <default_check+0x2fa>
ffffffffc02010f8:	28aa8463          	beq	s5,a0,ffffffffc0201380 <default_check+0x2fa>
ffffffffc02010fc:	28a98263          	beq	s3,a0,ffffffffc0201380 <default_check+0x2fa>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201100:	000aa783          	lw	a5,0(s5)
ffffffffc0201104:	28079e63          	bnez	a5,ffffffffc02013a0 <default_check+0x31a>
ffffffffc0201108:	0009a783          	lw	a5,0(s3)
ffffffffc020110c:	28079a63          	bnez	a5,ffffffffc02013a0 <default_check+0x31a>
ffffffffc0201110:	411c                	lw	a5,0(a0)
ffffffffc0201112:	28079763          	bnez	a5,ffffffffc02013a0 <default_check+0x31a>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0201116:	0009e797          	auipc	a5,0x9e
ffffffffc020111a:	d3a7b783          	ld	a5,-710(a5) # ffffffffc029ee50 <pages>
ffffffffc020111e:	40fa8733          	sub	a4,s5,a5
ffffffffc0201122:	00007617          	auipc	a2,0x7
ffffffffc0201126:	aa663603          	ld	a2,-1370(a2) # ffffffffc0207bc8 <nbase>
ffffffffc020112a:	8719                	srai	a4,a4,0x6
ffffffffc020112c:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020112e:	0009e697          	auipc	a3,0x9e
ffffffffc0201132:	d1a6b683          	ld	a3,-742(a3) # ffffffffc029ee48 <npage>
ffffffffc0201136:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0201138:	0732                	slli	a4,a4,0xc
ffffffffc020113a:	28d77363          	bgeu	a4,a3,ffffffffc02013c0 <default_check+0x33a>
    return page - pages + nbase;
ffffffffc020113e:	40f98733          	sub	a4,s3,a5
ffffffffc0201142:	8719                	srai	a4,a4,0x6
ffffffffc0201144:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201146:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201148:	4ad77c63          	bgeu	a4,a3,ffffffffc0201600 <default_check+0x57a>
    return page - pages + nbase;
ffffffffc020114c:	40f507b3          	sub	a5,a0,a5
ffffffffc0201150:	8799                	srai	a5,a5,0x6
ffffffffc0201152:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201154:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201156:	30d7f563          	bgeu	a5,a3,ffffffffc0201460 <default_check+0x3da>
    assert(alloc_page() == NULL);
ffffffffc020115a:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020115c:	00043c03          	ld	s8,0(s0)
ffffffffc0201160:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0201164:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0201168:	e400                	sd	s0,8(s0)
ffffffffc020116a:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc020116c:	0009a797          	auipc	a5,0x9a
ffffffffc0201170:	c607a623          	sw	zero,-916(a5) # ffffffffc029add8 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0201174:	591000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc0201178:	2c051463          	bnez	a0,ffffffffc0201440 <default_check+0x3ba>
    free_page(p0);
ffffffffc020117c:	4585                	li	a1,1
ffffffffc020117e:	8556                	mv	a0,s5
ffffffffc0201180:	5c3000ef          	jal	ffffffffc0201f42 <free_pages>
    free_page(p1);
ffffffffc0201184:	4585                	li	a1,1
ffffffffc0201186:	854e                	mv	a0,s3
ffffffffc0201188:	5bb000ef          	jal	ffffffffc0201f42 <free_pages>
    free_page(p2);
ffffffffc020118c:	4585                	li	a1,1
ffffffffc020118e:	8552                	mv	a0,s4
ffffffffc0201190:	5b3000ef          	jal	ffffffffc0201f42 <free_pages>
    assert(nr_free == 3);
ffffffffc0201194:	4818                	lw	a4,16(s0)
ffffffffc0201196:	478d                	li	a5,3
ffffffffc0201198:	28f71463          	bne	a4,a5,ffffffffc0201420 <default_check+0x39a>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020119c:	4505                	li	a0,1
ffffffffc020119e:	567000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc02011a2:	89aa                	mv	s3,a0
ffffffffc02011a4:	24050e63          	beqz	a0,ffffffffc0201400 <default_check+0x37a>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02011a8:	4505                	li	a0,1
ffffffffc02011aa:	55b000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc02011ae:	8aaa                	mv	s5,a0
ffffffffc02011b0:	3a050863          	beqz	a0,ffffffffc0201560 <default_check+0x4da>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02011b4:	4505                	li	a0,1
ffffffffc02011b6:	54f000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc02011ba:	8a2a                	mv	s4,a0
ffffffffc02011bc:	38050263          	beqz	a0,ffffffffc0201540 <default_check+0x4ba>
    assert(alloc_page() == NULL);
ffffffffc02011c0:	4505                	li	a0,1
ffffffffc02011c2:	543000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc02011c6:	34051d63          	bnez	a0,ffffffffc0201520 <default_check+0x49a>
    free_page(p0);
ffffffffc02011ca:	4585                	li	a1,1
ffffffffc02011cc:	854e                	mv	a0,s3
ffffffffc02011ce:	575000ef          	jal	ffffffffc0201f42 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc02011d2:	641c                	ld	a5,8(s0)
ffffffffc02011d4:	20878663          	beq	a5,s0,ffffffffc02013e0 <default_check+0x35a>
    assert((p = alloc_page()) == p0);
ffffffffc02011d8:	4505                	li	a0,1
ffffffffc02011da:	52b000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc02011de:	30a99163          	bne	s3,a0,ffffffffc02014e0 <default_check+0x45a>
    assert(alloc_page() == NULL);
ffffffffc02011e2:	4505                	li	a0,1
ffffffffc02011e4:	521000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc02011e8:	2c051c63          	bnez	a0,ffffffffc02014c0 <default_check+0x43a>
    assert(nr_free == 0);
ffffffffc02011ec:	481c                	lw	a5,16(s0)
ffffffffc02011ee:	2a079963          	bnez	a5,ffffffffc02014a0 <default_check+0x41a>
    free_page(p);
ffffffffc02011f2:	854e                	mv	a0,s3
ffffffffc02011f4:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc02011f6:	01843023          	sd	s8,0(s0)
ffffffffc02011fa:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc02011fe:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201202:	541000ef          	jal	ffffffffc0201f42 <free_pages>
    free_page(p1);
ffffffffc0201206:	4585                	li	a1,1
ffffffffc0201208:	8556                	mv	a0,s5
ffffffffc020120a:	539000ef          	jal	ffffffffc0201f42 <free_pages>
    free_page(p2);
ffffffffc020120e:	4585                	li	a1,1
ffffffffc0201210:	8552                	mv	a0,s4
ffffffffc0201212:	531000ef          	jal	ffffffffc0201f42 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201216:	4515                	li	a0,5
ffffffffc0201218:	4ed000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc020121c:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc020121e:	26050163          	beqz	a0,ffffffffc0201480 <default_check+0x3fa>
ffffffffc0201222:	651c                	ld	a5,8(a0)
    assert(!PageProperty(p0));
ffffffffc0201224:	8b89                	andi	a5,a5,2
ffffffffc0201226:	52079d63          	bnez	a5,ffffffffc0201760 <default_check+0x6da>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc020122a:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020122c:	00043b83          	ld	s7,0(s0)
ffffffffc0201230:	00843b03          	ld	s6,8(s0)
ffffffffc0201234:	e000                	sd	s0,0(s0)
ffffffffc0201236:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0201238:	4cd000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc020123c:	50051263          	bnez	a0,ffffffffc0201740 <default_check+0x6ba>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201240:	08098a13          	addi	s4,s3,128
ffffffffc0201244:	8552                	mv	a0,s4
ffffffffc0201246:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201248:	01042c03          	lw	s8,16(s0)
    nr_free = 0;
ffffffffc020124c:	0009a797          	auipc	a5,0x9a
ffffffffc0201250:	b807a623          	sw	zero,-1140(a5) # ffffffffc029add8 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0201254:	4ef000ef          	jal	ffffffffc0201f42 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201258:	4511                	li	a0,4
ffffffffc020125a:	4ab000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc020125e:	4c051163          	bnez	a0,ffffffffc0201720 <default_check+0x69a>
ffffffffc0201262:	0889b783          	ld	a5,136(s3)
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201266:	8b89                	andi	a5,a5,2
ffffffffc0201268:	48078c63          	beqz	a5,ffffffffc0201700 <default_check+0x67a>
ffffffffc020126c:	0909a703          	lw	a4,144(s3)
ffffffffc0201270:	478d                	li	a5,3
ffffffffc0201272:	48f71763          	bne	a4,a5,ffffffffc0201700 <default_check+0x67a>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201276:	450d                	li	a0,3
ffffffffc0201278:	48d000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc020127c:	8aaa                	mv	s5,a0
ffffffffc020127e:	46050163          	beqz	a0,ffffffffc02016e0 <default_check+0x65a>
    assert(alloc_page() == NULL);
ffffffffc0201282:	4505                	li	a0,1
ffffffffc0201284:	481000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc0201288:	42051c63          	bnez	a0,ffffffffc02016c0 <default_check+0x63a>
    assert(p0 + 2 == p1);
ffffffffc020128c:	415a1a63          	bne	s4,s5,ffffffffc02016a0 <default_check+0x61a>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201290:	4585                	li	a1,1
ffffffffc0201292:	854e                	mv	a0,s3
ffffffffc0201294:	4af000ef          	jal	ffffffffc0201f42 <free_pages>
    free_pages(p1, 3);
ffffffffc0201298:	458d                	li	a1,3
ffffffffc020129a:	8552                	mv	a0,s4
ffffffffc020129c:	4a7000ef          	jal	ffffffffc0201f42 <free_pages>
ffffffffc02012a0:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc02012a4:	04098a93          	addi	s5,s3,64
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02012a8:	8b89                	andi	a5,a5,2
ffffffffc02012aa:	3c078b63          	beqz	a5,ffffffffc0201680 <default_check+0x5fa>
ffffffffc02012ae:	0109a703          	lw	a4,16(s3)
ffffffffc02012b2:	4785                	li	a5,1
ffffffffc02012b4:	3cf71663          	bne	a4,a5,ffffffffc0201680 <default_check+0x5fa>
ffffffffc02012b8:	008a3783          	ld	a5,8(s4)
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02012bc:	8b89                	andi	a5,a5,2
ffffffffc02012be:	3a078163          	beqz	a5,ffffffffc0201660 <default_check+0x5da>
ffffffffc02012c2:	010a2703          	lw	a4,16(s4)
ffffffffc02012c6:	478d                	li	a5,3
ffffffffc02012c8:	38f71c63          	bne	a4,a5,ffffffffc0201660 <default_check+0x5da>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02012cc:	4505                	li	a0,1
ffffffffc02012ce:	437000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc02012d2:	36a99763          	bne	s3,a0,ffffffffc0201640 <default_check+0x5ba>
    free_page(p0);
ffffffffc02012d6:	4585                	li	a1,1
ffffffffc02012d8:	46b000ef          	jal	ffffffffc0201f42 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02012dc:	4509                	li	a0,2
ffffffffc02012de:	427000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc02012e2:	32aa1f63          	bne	s4,a0,ffffffffc0201620 <default_check+0x59a>

    free_pages(p0, 2);
ffffffffc02012e6:	4589                	li	a1,2
ffffffffc02012e8:	45b000ef          	jal	ffffffffc0201f42 <free_pages>
    free_page(p2);
ffffffffc02012ec:	4585                	li	a1,1
ffffffffc02012ee:	8556                	mv	a0,s5
ffffffffc02012f0:	453000ef          	jal	ffffffffc0201f42 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02012f4:	4515                	li	a0,5
ffffffffc02012f6:	40f000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc02012fa:	89aa                	mv	s3,a0
ffffffffc02012fc:	48050263          	beqz	a0,ffffffffc0201780 <default_check+0x6fa>
    assert(alloc_page() == NULL);
ffffffffc0201300:	4505                	li	a0,1
ffffffffc0201302:	403000ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc0201306:	2c051d63          	bnez	a0,ffffffffc02015e0 <default_check+0x55a>

    assert(nr_free == 0);
ffffffffc020130a:	481c                	lw	a5,16(s0)
ffffffffc020130c:	2a079a63          	bnez	a5,ffffffffc02015c0 <default_check+0x53a>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201310:	4595                	li	a1,5
ffffffffc0201312:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201314:	01842823          	sw	s8,16(s0)
    free_list = free_list_store;
ffffffffc0201318:	01743023          	sd	s7,0(s0)
ffffffffc020131c:	01643423          	sd	s6,8(s0)
    free_pages(p0, 5);
ffffffffc0201320:	423000ef          	jal	ffffffffc0201f42 <free_pages>
    return listelm->next;
ffffffffc0201324:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201326:	00878963          	beq	a5,s0,ffffffffc0201338 <default_check+0x2b2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc020132a:	ff87a703          	lw	a4,-8(a5)
ffffffffc020132e:	679c                	ld	a5,8(a5)
ffffffffc0201330:	397d                	addiw	s2,s2,-1
ffffffffc0201332:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201334:	fe879be3          	bne	a5,s0,ffffffffc020132a <default_check+0x2a4>
    }
    assert(count == 0);
ffffffffc0201338:	26091463          	bnez	s2,ffffffffc02015a0 <default_check+0x51a>
    assert(total == 0);
ffffffffc020133c:	46049263          	bnez	s1,ffffffffc02017a0 <default_check+0x71a>
}
ffffffffc0201340:	60a6                	ld	ra,72(sp)
ffffffffc0201342:	6406                	ld	s0,64(sp)
ffffffffc0201344:	74e2                	ld	s1,56(sp)
ffffffffc0201346:	7942                	ld	s2,48(sp)
ffffffffc0201348:	79a2                	ld	s3,40(sp)
ffffffffc020134a:	7a02                	ld	s4,32(sp)
ffffffffc020134c:	6ae2                	ld	s5,24(sp)
ffffffffc020134e:	6b42                	ld	s6,16(sp)
ffffffffc0201350:	6ba2                	ld	s7,8(sp)
ffffffffc0201352:	6c02                	ld	s8,0(sp)
ffffffffc0201354:	6161                	addi	sp,sp,80
ffffffffc0201356:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201358:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc020135a:	4481                	li	s1,0
ffffffffc020135c:	4901                	li	s2,0
ffffffffc020135e:	b3ad                	j	ffffffffc02010c8 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201360:	00005697          	auipc	a3,0x5
ffffffffc0201364:	12068693          	addi	a3,a3,288 # ffffffffc0206480 <etext+0xa12>
ffffffffc0201368:	00005617          	auipc	a2,0x5
ffffffffc020136c:	12860613          	addi	a2,a2,296 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201370:	10e00593          	li	a1,270
ffffffffc0201374:	00005517          	auipc	a0,0x5
ffffffffc0201378:	13450513          	addi	a0,a0,308 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020137c:	90cff0ef          	jal	ffffffffc0200488 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201380:	00005697          	auipc	a3,0x5
ffffffffc0201384:	1c068693          	addi	a3,a3,448 # ffffffffc0206540 <etext+0xad2>
ffffffffc0201388:	00005617          	auipc	a2,0x5
ffffffffc020138c:	10860613          	addi	a2,a2,264 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201390:	0db00593          	li	a1,219
ffffffffc0201394:	00005517          	auipc	a0,0x5
ffffffffc0201398:	11450513          	addi	a0,a0,276 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020139c:	8ecff0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02013a0:	00005697          	auipc	a3,0x5
ffffffffc02013a4:	1c868693          	addi	a3,a3,456 # ffffffffc0206568 <etext+0xafa>
ffffffffc02013a8:	00005617          	auipc	a2,0x5
ffffffffc02013ac:	0e860613          	addi	a2,a2,232 # ffffffffc0206490 <etext+0xa22>
ffffffffc02013b0:	0dc00593          	li	a1,220
ffffffffc02013b4:	00005517          	auipc	a0,0x5
ffffffffc02013b8:	0f450513          	addi	a0,a0,244 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02013bc:	8ccff0ef          	jal	ffffffffc0200488 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02013c0:	00005697          	auipc	a3,0x5
ffffffffc02013c4:	1e868693          	addi	a3,a3,488 # ffffffffc02065a8 <etext+0xb3a>
ffffffffc02013c8:	00005617          	auipc	a2,0x5
ffffffffc02013cc:	0c860613          	addi	a2,a2,200 # ffffffffc0206490 <etext+0xa22>
ffffffffc02013d0:	0de00593          	li	a1,222
ffffffffc02013d4:	00005517          	auipc	a0,0x5
ffffffffc02013d8:	0d450513          	addi	a0,a0,212 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02013dc:	8acff0ef          	jal	ffffffffc0200488 <__panic>
    assert(!list_empty(&free_list));
ffffffffc02013e0:	00005697          	auipc	a3,0x5
ffffffffc02013e4:	25068693          	addi	a3,a3,592 # ffffffffc0206630 <etext+0xbc2>
ffffffffc02013e8:	00005617          	auipc	a2,0x5
ffffffffc02013ec:	0a860613          	addi	a2,a2,168 # ffffffffc0206490 <etext+0xa22>
ffffffffc02013f0:	0f700593          	li	a1,247
ffffffffc02013f4:	00005517          	auipc	a0,0x5
ffffffffc02013f8:	0b450513          	addi	a0,a0,180 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02013fc:	88cff0ef          	jal	ffffffffc0200488 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201400:	00005697          	auipc	a3,0x5
ffffffffc0201404:	0e068693          	addi	a3,a3,224 # ffffffffc02064e0 <etext+0xa72>
ffffffffc0201408:	00005617          	auipc	a2,0x5
ffffffffc020140c:	08860613          	addi	a2,a2,136 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201410:	0f000593          	li	a1,240
ffffffffc0201414:	00005517          	auipc	a0,0x5
ffffffffc0201418:	09450513          	addi	a0,a0,148 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020141c:	86cff0ef          	jal	ffffffffc0200488 <__panic>
    assert(nr_free == 3);
ffffffffc0201420:	00005697          	auipc	a3,0x5
ffffffffc0201424:	20068693          	addi	a3,a3,512 # ffffffffc0206620 <etext+0xbb2>
ffffffffc0201428:	00005617          	auipc	a2,0x5
ffffffffc020142c:	06860613          	addi	a2,a2,104 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201430:	0ee00593          	li	a1,238
ffffffffc0201434:	00005517          	auipc	a0,0x5
ffffffffc0201438:	07450513          	addi	a0,a0,116 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020143c:	84cff0ef          	jal	ffffffffc0200488 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201440:	00005697          	auipc	a3,0x5
ffffffffc0201444:	1c868693          	addi	a3,a3,456 # ffffffffc0206608 <etext+0xb9a>
ffffffffc0201448:	00005617          	auipc	a2,0x5
ffffffffc020144c:	04860613          	addi	a2,a2,72 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201450:	0e900593          	li	a1,233
ffffffffc0201454:	00005517          	auipc	a0,0x5
ffffffffc0201458:	05450513          	addi	a0,a0,84 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020145c:	82cff0ef          	jal	ffffffffc0200488 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201460:	00005697          	auipc	a3,0x5
ffffffffc0201464:	18868693          	addi	a3,a3,392 # ffffffffc02065e8 <etext+0xb7a>
ffffffffc0201468:	00005617          	auipc	a2,0x5
ffffffffc020146c:	02860613          	addi	a2,a2,40 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201470:	0e000593          	li	a1,224
ffffffffc0201474:	00005517          	auipc	a0,0x5
ffffffffc0201478:	03450513          	addi	a0,a0,52 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020147c:	80cff0ef          	jal	ffffffffc0200488 <__panic>
    assert(p0 != NULL);
ffffffffc0201480:	00005697          	auipc	a3,0x5
ffffffffc0201484:	1f868693          	addi	a3,a3,504 # ffffffffc0206678 <etext+0xc0a>
ffffffffc0201488:	00005617          	auipc	a2,0x5
ffffffffc020148c:	00860613          	addi	a2,a2,8 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201490:	11600593          	li	a1,278
ffffffffc0201494:	00005517          	auipc	a0,0x5
ffffffffc0201498:	01450513          	addi	a0,a0,20 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020149c:	fedfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(nr_free == 0);
ffffffffc02014a0:	00005697          	auipc	a3,0x5
ffffffffc02014a4:	1c868693          	addi	a3,a3,456 # ffffffffc0206668 <etext+0xbfa>
ffffffffc02014a8:	00005617          	auipc	a2,0x5
ffffffffc02014ac:	fe860613          	addi	a2,a2,-24 # ffffffffc0206490 <etext+0xa22>
ffffffffc02014b0:	0fd00593          	li	a1,253
ffffffffc02014b4:	00005517          	auipc	a0,0x5
ffffffffc02014b8:	ff450513          	addi	a0,a0,-12 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02014bc:	fcdfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02014c0:	00005697          	auipc	a3,0x5
ffffffffc02014c4:	14868693          	addi	a3,a3,328 # ffffffffc0206608 <etext+0xb9a>
ffffffffc02014c8:	00005617          	auipc	a2,0x5
ffffffffc02014cc:	fc860613          	addi	a2,a2,-56 # ffffffffc0206490 <etext+0xa22>
ffffffffc02014d0:	0fb00593          	li	a1,251
ffffffffc02014d4:	00005517          	auipc	a0,0x5
ffffffffc02014d8:	fd450513          	addi	a0,a0,-44 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02014dc:	fadfe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02014e0:	00005697          	auipc	a3,0x5
ffffffffc02014e4:	16868693          	addi	a3,a3,360 # ffffffffc0206648 <etext+0xbda>
ffffffffc02014e8:	00005617          	auipc	a2,0x5
ffffffffc02014ec:	fa860613          	addi	a2,a2,-88 # ffffffffc0206490 <etext+0xa22>
ffffffffc02014f0:	0fa00593          	li	a1,250
ffffffffc02014f4:	00005517          	auipc	a0,0x5
ffffffffc02014f8:	fb450513          	addi	a0,a0,-76 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02014fc:	f8dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201500:	00005697          	auipc	a3,0x5
ffffffffc0201504:	fe068693          	addi	a3,a3,-32 # ffffffffc02064e0 <etext+0xa72>
ffffffffc0201508:	00005617          	auipc	a2,0x5
ffffffffc020150c:	f8860613          	addi	a2,a2,-120 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201510:	0d700593          	li	a1,215
ffffffffc0201514:	00005517          	auipc	a0,0x5
ffffffffc0201518:	f9450513          	addi	a0,a0,-108 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020151c:	f6dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201520:	00005697          	auipc	a3,0x5
ffffffffc0201524:	0e868693          	addi	a3,a3,232 # ffffffffc0206608 <etext+0xb9a>
ffffffffc0201528:	00005617          	auipc	a2,0x5
ffffffffc020152c:	f6860613          	addi	a2,a2,-152 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201530:	0f400593          	li	a1,244
ffffffffc0201534:	00005517          	auipc	a0,0x5
ffffffffc0201538:	f7450513          	addi	a0,a0,-140 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020153c:	f4dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201540:	00005697          	auipc	a3,0x5
ffffffffc0201544:	fe068693          	addi	a3,a3,-32 # ffffffffc0206520 <etext+0xab2>
ffffffffc0201548:	00005617          	auipc	a2,0x5
ffffffffc020154c:	f4860613          	addi	a2,a2,-184 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201550:	0f200593          	li	a1,242
ffffffffc0201554:	00005517          	auipc	a0,0x5
ffffffffc0201558:	f5450513          	addi	a0,a0,-172 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020155c:	f2dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201560:	00005697          	auipc	a3,0x5
ffffffffc0201564:	fa068693          	addi	a3,a3,-96 # ffffffffc0206500 <etext+0xa92>
ffffffffc0201568:	00005617          	auipc	a2,0x5
ffffffffc020156c:	f2860613          	addi	a2,a2,-216 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201570:	0f100593          	li	a1,241
ffffffffc0201574:	00005517          	auipc	a0,0x5
ffffffffc0201578:	f3450513          	addi	a0,a0,-204 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020157c:	f0dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201580:	00005697          	auipc	a3,0x5
ffffffffc0201584:	fa068693          	addi	a3,a3,-96 # ffffffffc0206520 <etext+0xab2>
ffffffffc0201588:	00005617          	auipc	a2,0x5
ffffffffc020158c:	f0860613          	addi	a2,a2,-248 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201590:	0d900593          	li	a1,217
ffffffffc0201594:	00005517          	auipc	a0,0x5
ffffffffc0201598:	f1450513          	addi	a0,a0,-236 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020159c:	eedfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(count == 0);
ffffffffc02015a0:	00005697          	auipc	a3,0x5
ffffffffc02015a4:	22868693          	addi	a3,a3,552 # ffffffffc02067c8 <etext+0xd5a>
ffffffffc02015a8:	00005617          	auipc	a2,0x5
ffffffffc02015ac:	ee860613          	addi	a2,a2,-280 # ffffffffc0206490 <etext+0xa22>
ffffffffc02015b0:	14300593          	li	a1,323
ffffffffc02015b4:	00005517          	auipc	a0,0x5
ffffffffc02015b8:	ef450513          	addi	a0,a0,-268 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02015bc:	ecdfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(nr_free == 0);
ffffffffc02015c0:	00005697          	auipc	a3,0x5
ffffffffc02015c4:	0a868693          	addi	a3,a3,168 # ffffffffc0206668 <etext+0xbfa>
ffffffffc02015c8:	00005617          	auipc	a2,0x5
ffffffffc02015cc:	ec860613          	addi	a2,a2,-312 # ffffffffc0206490 <etext+0xa22>
ffffffffc02015d0:	13800593          	li	a1,312
ffffffffc02015d4:	00005517          	auipc	a0,0x5
ffffffffc02015d8:	ed450513          	addi	a0,a0,-300 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02015dc:	eadfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02015e0:	00005697          	auipc	a3,0x5
ffffffffc02015e4:	02868693          	addi	a3,a3,40 # ffffffffc0206608 <etext+0xb9a>
ffffffffc02015e8:	00005617          	auipc	a2,0x5
ffffffffc02015ec:	ea860613          	addi	a2,a2,-344 # ffffffffc0206490 <etext+0xa22>
ffffffffc02015f0:	13600593          	li	a1,310
ffffffffc02015f4:	00005517          	auipc	a0,0x5
ffffffffc02015f8:	eb450513          	addi	a0,a0,-332 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02015fc:	e8dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201600:	00005697          	auipc	a3,0x5
ffffffffc0201604:	fc868693          	addi	a3,a3,-56 # ffffffffc02065c8 <etext+0xb5a>
ffffffffc0201608:	00005617          	auipc	a2,0x5
ffffffffc020160c:	e8860613          	addi	a2,a2,-376 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201610:	0df00593          	li	a1,223
ffffffffc0201614:	00005517          	auipc	a0,0x5
ffffffffc0201618:	e9450513          	addi	a0,a0,-364 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020161c:	e6dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201620:	00005697          	auipc	a3,0x5
ffffffffc0201624:	16868693          	addi	a3,a3,360 # ffffffffc0206788 <etext+0xd1a>
ffffffffc0201628:	00005617          	auipc	a2,0x5
ffffffffc020162c:	e6860613          	addi	a2,a2,-408 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201630:	13000593          	li	a1,304
ffffffffc0201634:	00005517          	auipc	a0,0x5
ffffffffc0201638:	e7450513          	addi	a0,a0,-396 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020163c:	e4dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201640:	00005697          	auipc	a3,0x5
ffffffffc0201644:	12868693          	addi	a3,a3,296 # ffffffffc0206768 <etext+0xcfa>
ffffffffc0201648:	00005617          	auipc	a2,0x5
ffffffffc020164c:	e4860613          	addi	a2,a2,-440 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201650:	12e00593          	li	a1,302
ffffffffc0201654:	00005517          	auipc	a0,0x5
ffffffffc0201658:	e5450513          	addi	a0,a0,-428 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020165c:	e2dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201660:	00005697          	auipc	a3,0x5
ffffffffc0201664:	0e068693          	addi	a3,a3,224 # ffffffffc0206740 <etext+0xcd2>
ffffffffc0201668:	00005617          	auipc	a2,0x5
ffffffffc020166c:	e2860613          	addi	a2,a2,-472 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201670:	12c00593          	li	a1,300
ffffffffc0201674:	00005517          	auipc	a0,0x5
ffffffffc0201678:	e3450513          	addi	a0,a0,-460 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020167c:	e0dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201680:	00005697          	auipc	a3,0x5
ffffffffc0201684:	09868693          	addi	a3,a3,152 # ffffffffc0206718 <etext+0xcaa>
ffffffffc0201688:	00005617          	auipc	a2,0x5
ffffffffc020168c:	e0860613          	addi	a2,a2,-504 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201690:	12b00593          	li	a1,299
ffffffffc0201694:	00005517          	auipc	a0,0x5
ffffffffc0201698:	e1450513          	addi	a0,a0,-492 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020169c:	dedfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(p0 + 2 == p1);
ffffffffc02016a0:	00005697          	auipc	a3,0x5
ffffffffc02016a4:	06868693          	addi	a3,a3,104 # ffffffffc0206708 <etext+0xc9a>
ffffffffc02016a8:	00005617          	auipc	a2,0x5
ffffffffc02016ac:	de860613          	addi	a2,a2,-536 # ffffffffc0206490 <etext+0xa22>
ffffffffc02016b0:	12600593          	li	a1,294
ffffffffc02016b4:	00005517          	auipc	a0,0x5
ffffffffc02016b8:	df450513          	addi	a0,a0,-524 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02016bc:	dcdfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02016c0:	00005697          	auipc	a3,0x5
ffffffffc02016c4:	f4868693          	addi	a3,a3,-184 # ffffffffc0206608 <etext+0xb9a>
ffffffffc02016c8:	00005617          	auipc	a2,0x5
ffffffffc02016cc:	dc860613          	addi	a2,a2,-568 # ffffffffc0206490 <etext+0xa22>
ffffffffc02016d0:	12500593          	li	a1,293
ffffffffc02016d4:	00005517          	auipc	a0,0x5
ffffffffc02016d8:	dd450513          	addi	a0,a0,-556 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02016dc:	dadfe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02016e0:	00005697          	auipc	a3,0x5
ffffffffc02016e4:	00868693          	addi	a3,a3,8 # ffffffffc02066e8 <etext+0xc7a>
ffffffffc02016e8:	00005617          	auipc	a2,0x5
ffffffffc02016ec:	da860613          	addi	a2,a2,-600 # ffffffffc0206490 <etext+0xa22>
ffffffffc02016f0:	12400593          	li	a1,292
ffffffffc02016f4:	00005517          	auipc	a0,0x5
ffffffffc02016f8:	db450513          	addi	a0,a0,-588 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02016fc:	d8dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201700:	00005697          	auipc	a3,0x5
ffffffffc0201704:	fb868693          	addi	a3,a3,-72 # ffffffffc02066b8 <etext+0xc4a>
ffffffffc0201708:	00005617          	auipc	a2,0x5
ffffffffc020170c:	d8860613          	addi	a2,a2,-632 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201710:	12300593          	li	a1,291
ffffffffc0201714:	00005517          	auipc	a0,0x5
ffffffffc0201718:	d9450513          	addi	a0,a0,-620 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020171c:	d6dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201720:	00005697          	auipc	a3,0x5
ffffffffc0201724:	f8068693          	addi	a3,a3,-128 # ffffffffc02066a0 <etext+0xc32>
ffffffffc0201728:	00005617          	auipc	a2,0x5
ffffffffc020172c:	d6860613          	addi	a2,a2,-664 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201730:	12200593          	li	a1,290
ffffffffc0201734:	00005517          	auipc	a0,0x5
ffffffffc0201738:	d7450513          	addi	a0,a0,-652 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020173c:	d4dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201740:	00005697          	auipc	a3,0x5
ffffffffc0201744:	ec868693          	addi	a3,a3,-312 # ffffffffc0206608 <etext+0xb9a>
ffffffffc0201748:	00005617          	auipc	a2,0x5
ffffffffc020174c:	d4860613          	addi	a2,a2,-696 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201750:	11c00593          	li	a1,284
ffffffffc0201754:	00005517          	auipc	a0,0x5
ffffffffc0201758:	d5450513          	addi	a0,a0,-684 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020175c:	d2dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(!PageProperty(p0));
ffffffffc0201760:	00005697          	auipc	a3,0x5
ffffffffc0201764:	f2868693          	addi	a3,a3,-216 # ffffffffc0206688 <etext+0xc1a>
ffffffffc0201768:	00005617          	auipc	a2,0x5
ffffffffc020176c:	d2860613          	addi	a2,a2,-728 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201770:	11700593          	li	a1,279
ffffffffc0201774:	00005517          	auipc	a0,0x5
ffffffffc0201778:	d3450513          	addi	a0,a0,-716 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020177c:	d0dfe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201780:	00005697          	auipc	a3,0x5
ffffffffc0201784:	02868693          	addi	a3,a3,40 # ffffffffc02067a8 <etext+0xd3a>
ffffffffc0201788:	00005617          	auipc	a2,0x5
ffffffffc020178c:	d0860613          	addi	a2,a2,-760 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201790:	13500593          	li	a1,309
ffffffffc0201794:	00005517          	auipc	a0,0x5
ffffffffc0201798:	d1450513          	addi	a0,a0,-748 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc020179c:	cedfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(total == 0);
ffffffffc02017a0:	00005697          	auipc	a3,0x5
ffffffffc02017a4:	03868693          	addi	a3,a3,56 # ffffffffc02067d8 <etext+0xd6a>
ffffffffc02017a8:	00005617          	auipc	a2,0x5
ffffffffc02017ac:	ce860613          	addi	a2,a2,-792 # ffffffffc0206490 <etext+0xa22>
ffffffffc02017b0:	14400593          	li	a1,324
ffffffffc02017b4:	00005517          	auipc	a0,0x5
ffffffffc02017b8:	cf450513          	addi	a0,a0,-780 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02017bc:	ccdfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(total == nr_free_pages());
ffffffffc02017c0:	00005697          	auipc	a3,0x5
ffffffffc02017c4:	d0068693          	addi	a3,a3,-768 # ffffffffc02064c0 <etext+0xa52>
ffffffffc02017c8:	00005617          	auipc	a2,0x5
ffffffffc02017cc:	cc860613          	addi	a2,a2,-824 # ffffffffc0206490 <etext+0xa22>
ffffffffc02017d0:	11100593          	li	a1,273
ffffffffc02017d4:	00005517          	auipc	a0,0x5
ffffffffc02017d8:	cd450513          	addi	a0,a0,-812 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02017dc:	cadfe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02017e0:	00005697          	auipc	a3,0x5
ffffffffc02017e4:	d2068693          	addi	a3,a3,-736 # ffffffffc0206500 <etext+0xa92>
ffffffffc02017e8:	00005617          	auipc	a2,0x5
ffffffffc02017ec:	ca860613          	addi	a2,a2,-856 # ffffffffc0206490 <etext+0xa22>
ffffffffc02017f0:	0d800593          	li	a1,216
ffffffffc02017f4:	00005517          	auipc	a0,0x5
ffffffffc02017f8:	cb450513          	addi	a0,a0,-844 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc02017fc:	c8dfe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201800 <default_free_pages>:
{
ffffffffc0201800:	1141                	addi	sp,sp,-16
ffffffffc0201802:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201804:	14058463          	beqz	a1,ffffffffc020194c <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc0201808:	00659713          	slli	a4,a1,0x6
ffffffffc020180c:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201810:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc0201812:	c30d                	beqz	a4,ffffffffc0201834 <default_free_pages+0x34>
ffffffffc0201814:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201816:	8b05                	andi	a4,a4,1
ffffffffc0201818:	10071a63          	bnez	a4,ffffffffc020192c <default_free_pages+0x12c>
ffffffffc020181c:	6798                	ld	a4,8(a5)
ffffffffc020181e:	8b09                	andi	a4,a4,2
ffffffffc0201820:	10071663          	bnez	a4,ffffffffc020192c <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc0201824:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0201828:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc020182c:	04078793          	addi	a5,a5,64
ffffffffc0201830:	fed792e3          	bne	a5,a3,ffffffffc0201814 <default_free_pages+0x14>
    base->property = n;
ffffffffc0201834:	2581                	sext.w	a1,a1
ffffffffc0201836:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201838:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020183c:	4789                	li	a5,2
ffffffffc020183e:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201842:	00099697          	auipc	a3,0x99
ffffffffc0201846:	58668693          	addi	a3,a3,1414 # ffffffffc029adc8 <free_area>
ffffffffc020184a:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020184c:	669c                	ld	a5,8(a3)
ffffffffc020184e:	9f2d                	addw	a4,a4,a1
ffffffffc0201850:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc0201852:	0ad78163          	beq	a5,a3,ffffffffc02018f4 <default_free_pages+0xf4>
            struct Page *page = le2page(le, page_link);
ffffffffc0201856:	fe878713          	addi	a4,a5,-24
ffffffffc020185a:	4581                	li	a1,0
ffffffffc020185c:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc0201860:	00e56a63          	bltu	a0,a4,ffffffffc0201874 <default_free_pages+0x74>
    return listelm->next;
ffffffffc0201864:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201866:	04d70c63          	beq	a4,a3,ffffffffc02018be <default_free_pages+0xbe>
    struct Page *p = base;
ffffffffc020186a:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc020186c:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201870:	fee57ae3          	bgeu	a0,a4,ffffffffc0201864 <default_free_pages+0x64>
ffffffffc0201874:	c199                	beqz	a1,ffffffffc020187a <default_free_pages+0x7a>
ffffffffc0201876:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020187a:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc020187c:	e390                	sd	a2,0(a5)
ffffffffc020187e:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201880:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201882:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc0201884:	00d70d63          	beq	a4,a3,ffffffffc020189e <default_free_pages+0x9e>
        if (p + p->property == base)
ffffffffc0201888:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc020188c:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc0201890:	02059813          	slli	a6,a1,0x20
ffffffffc0201894:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201898:	97b2                	add	a5,a5,a2
ffffffffc020189a:	02f50c63          	beq	a0,a5,ffffffffc02018d2 <default_free_pages+0xd2>
    return listelm->next;
ffffffffc020189e:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc02018a0:	00d78c63          	beq	a5,a3,ffffffffc02018b8 <default_free_pages+0xb8>
        if (base + base->property == p)
ffffffffc02018a4:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc02018a6:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc02018aa:	02061593          	slli	a1,a2,0x20
ffffffffc02018ae:	01a5d713          	srli	a4,a1,0x1a
ffffffffc02018b2:	972a                	add	a4,a4,a0
ffffffffc02018b4:	04e68c63          	beq	a3,a4,ffffffffc020190c <default_free_pages+0x10c>
}
ffffffffc02018b8:	60a2                	ld	ra,8(sp)
ffffffffc02018ba:	0141                	addi	sp,sp,16
ffffffffc02018bc:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02018be:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02018c0:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02018c2:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02018c4:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02018c6:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc02018c8:	02d70f63          	beq	a4,a3,ffffffffc0201906 <default_free_pages+0x106>
ffffffffc02018cc:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc02018ce:	87ba                	mv	a5,a4
ffffffffc02018d0:	bf71                	j	ffffffffc020186c <default_free_pages+0x6c>
            p->property += base->property;
ffffffffc02018d2:	491c                	lw	a5,16(a0)
ffffffffc02018d4:	9fad                	addw	a5,a5,a1
ffffffffc02018d6:	fef72c23          	sw	a5,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02018da:	57f5                	li	a5,-3
ffffffffc02018dc:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc02018e0:	01853803          	ld	a6,24(a0)
ffffffffc02018e4:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc02018e6:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02018e8:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc02018ec:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc02018ee:	0105b023          	sd	a6,0(a1)
ffffffffc02018f2:	b77d                	j	ffffffffc02018a0 <default_free_pages+0xa0>
}
ffffffffc02018f4:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc02018f6:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc02018fa:	e398                	sd	a4,0(a5)
ffffffffc02018fc:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc02018fe:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201900:	ed1c                	sd	a5,24(a0)
}
ffffffffc0201902:	0141                	addi	sp,sp,16
ffffffffc0201904:	8082                	ret
ffffffffc0201906:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc0201908:	873e                	mv	a4,a5
ffffffffc020190a:	bfad                	j	ffffffffc0201884 <default_free_pages+0x84>
            base->property += p->property;
ffffffffc020190c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201910:	ff078693          	addi	a3,a5,-16
ffffffffc0201914:	9f31                	addw	a4,a4,a2
ffffffffc0201916:	c918                	sw	a4,16(a0)
ffffffffc0201918:	5775                	li	a4,-3
ffffffffc020191a:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020191e:	6398                	ld	a4,0(a5)
ffffffffc0201920:	679c                	ld	a5,8(a5)
}
ffffffffc0201922:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201924:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201926:	e398                	sd	a4,0(a5)
ffffffffc0201928:	0141                	addi	sp,sp,16
ffffffffc020192a:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020192c:	00005697          	auipc	a3,0x5
ffffffffc0201930:	ec468693          	addi	a3,a3,-316 # ffffffffc02067f0 <etext+0xd82>
ffffffffc0201934:	00005617          	auipc	a2,0x5
ffffffffc0201938:	b5c60613          	addi	a2,a2,-1188 # ffffffffc0206490 <etext+0xa22>
ffffffffc020193c:	09400593          	li	a1,148
ffffffffc0201940:	00005517          	auipc	a0,0x5
ffffffffc0201944:	b6850513          	addi	a0,a0,-1176 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc0201948:	b41fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(n > 0);
ffffffffc020194c:	00005697          	auipc	a3,0x5
ffffffffc0201950:	e9c68693          	addi	a3,a3,-356 # ffffffffc02067e8 <etext+0xd7a>
ffffffffc0201954:	00005617          	auipc	a2,0x5
ffffffffc0201958:	b3c60613          	addi	a2,a2,-1220 # ffffffffc0206490 <etext+0xa22>
ffffffffc020195c:	09000593          	li	a1,144
ffffffffc0201960:	00005517          	auipc	a0,0x5
ffffffffc0201964:	b4850513          	addi	a0,a0,-1208 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc0201968:	b21fe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc020196c <default_alloc_pages>:
    assert(n > 0);
ffffffffc020196c:	c949                	beqz	a0,ffffffffc02019fe <default_alloc_pages+0x92>
    if (n > nr_free)
ffffffffc020196e:	00099617          	auipc	a2,0x99
ffffffffc0201972:	45a60613          	addi	a2,a2,1114 # ffffffffc029adc8 <free_area>
ffffffffc0201976:	4a0c                	lw	a1,16(a2)
ffffffffc0201978:	872a                	mv	a4,a0
ffffffffc020197a:	02059793          	slli	a5,a1,0x20
ffffffffc020197e:	9381                	srli	a5,a5,0x20
ffffffffc0201980:	00a7eb63          	bltu	a5,a0,ffffffffc0201996 <default_alloc_pages+0x2a>
    list_entry_t *le = &free_list;
ffffffffc0201984:	87b2                	mv	a5,a2
ffffffffc0201986:	a029                	j	ffffffffc0201990 <default_alloc_pages+0x24>
        if (p->property >= n)
ffffffffc0201988:	ff87e683          	lwu	a3,-8(a5)
ffffffffc020198c:	00e6f763          	bgeu	a3,a4,ffffffffc020199a <default_alloc_pages+0x2e>
    return listelm->next;
ffffffffc0201990:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201992:	fec79be3          	bne	a5,a2,ffffffffc0201988 <default_alloc_pages+0x1c>
        return NULL;
ffffffffc0201996:	4501                	li	a0,0
}
ffffffffc0201998:	8082                	ret
    __list_del(listelm->prev, listelm->next);
ffffffffc020199a:	0087b883          	ld	a7,8(a5)
        if (page->property > n)
ffffffffc020199e:	ff87a803          	lw	a6,-8(a5)
    return listelm->prev;
ffffffffc02019a2:	6394                	ld	a3,0(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc02019a4:	fe878513          	addi	a0,a5,-24
        if (page->property > n)
ffffffffc02019a8:	02081313          	slli	t1,a6,0x20
    prev->next = next;
ffffffffc02019ac:	0116b423          	sd	a7,8(a3)
    next->prev = prev;
ffffffffc02019b0:	00d8b023          	sd	a3,0(a7)
ffffffffc02019b4:	02035313          	srli	t1,t1,0x20
            p->property = page->property - n;
ffffffffc02019b8:	0007089b          	sext.w	a7,a4
        if (page->property > n)
ffffffffc02019bc:	02677963          	bgeu	a4,t1,ffffffffc02019ee <default_alloc_pages+0x82>
            struct Page *p = page + n;
ffffffffc02019c0:	071a                	slli	a4,a4,0x6
ffffffffc02019c2:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc02019c4:	4118083b          	subw	a6,a6,a7
ffffffffc02019c8:	01072823          	sw	a6,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02019cc:	4589                	li	a1,2
ffffffffc02019ce:	00870813          	addi	a6,a4,8
ffffffffc02019d2:	40b8302f          	amoor.d	zero,a1,(a6)
    __list_add(elm, listelm, listelm->next);
ffffffffc02019d6:	0086b803          	ld	a6,8(a3)
            list_add(prev, &(p->page_link));
ffffffffc02019da:	01870313          	addi	t1,a4,24
        nr_free -= n;
ffffffffc02019de:	4a0c                	lw	a1,16(a2)
    prev->next = next->prev = elm;
ffffffffc02019e0:	00683023          	sd	t1,0(a6)
ffffffffc02019e4:	0066b423          	sd	t1,8(a3)
    elm->next = next;
ffffffffc02019e8:	03073023          	sd	a6,32(a4)
    elm->prev = prev;
ffffffffc02019ec:	ef14                	sd	a3,24(a4)
ffffffffc02019ee:	411585bb          	subw	a1,a1,a7
ffffffffc02019f2:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02019f4:	5775                	li	a4,-3
ffffffffc02019f6:	17c1                	addi	a5,a5,-16
ffffffffc02019f8:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc02019fc:	8082                	ret
{
ffffffffc02019fe:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201a00:	00005697          	auipc	a3,0x5
ffffffffc0201a04:	de868693          	addi	a3,a3,-536 # ffffffffc02067e8 <etext+0xd7a>
ffffffffc0201a08:	00005617          	auipc	a2,0x5
ffffffffc0201a0c:	a8860613          	addi	a2,a2,-1400 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201a10:	06c00593          	li	a1,108
ffffffffc0201a14:	00005517          	auipc	a0,0x5
ffffffffc0201a18:	a9450513          	addi	a0,a0,-1388 # ffffffffc02064a8 <etext+0xa3a>
{
ffffffffc0201a1c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201a1e:	a6bfe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201a22 <default_init_memmap>:
{
ffffffffc0201a22:	1141                	addi	sp,sp,-16
ffffffffc0201a24:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201a26:	c5f1                	beqz	a1,ffffffffc0201af2 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc0201a28:	00659713          	slli	a4,a1,0x6
ffffffffc0201a2c:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201a30:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc0201a32:	cf11                	beqz	a4,ffffffffc0201a4e <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201a34:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0201a36:	8b05                	andi	a4,a4,1
ffffffffc0201a38:	cf49                	beqz	a4,ffffffffc0201ad2 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc0201a3a:	0007a823          	sw	zero,16(a5)
ffffffffc0201a3e:	0007b423          	sd	zero,8(a5)
ffffffffc0201a42:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201a46:	04078793          	addi	a5,a5,64
ffffffffc0201a4a:	fed795e3          	bne	a5,a3,ffffffffc0201a34 <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201a4e:	2581                	sext.w	a1,a1
ffffffffc0201a50:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201a52:	4789                	li	a5,2
ffffffffc0201a54:	00850713          	addi	a4,a0,8
ffffffffc0201a58:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201a5c:	00099697          	auipc	a3,0x99
ffffffffc0201a60:	36c68693          	addi	a3,a3,876 # ffffffffc029adc8 <free_area>
ffffffffc0201a64:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201a66:	669c                	ld	a5,8(a3)
ffffffffc0201a68:	9f2d                	addw	a4,a4,a1
ffffffffc0201a6a:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc0201a6c:	04d78663          	beq	a5,a3,ffffffffc0201ab8 <default_init_memmap+0x96>
            struct Page *page = le2page(le, page_link);
ffffffffc0201a70:	fe878713          	addi	a4,a5,-24
ffffffffc0201a74:	4581                	li	a1,0
ffffffffc0201a76:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc0201a7a:	00e56a63          	bltu	a0,a4,ffffffffc0201a8e <default_init_memmap+0x6c>
    return listelm->next;
ffffffffc0201a7e:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201a80:	02d70263          	beq	a4,a3,ffffffffc0201aa4 <default_init_memmap+0x82>
    struct Page *p = base;
ffffffffc0201a84:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201a86:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201a8a:	fee57ae3          	bgeu	a0,a4,ffffffffc0201a7e <default_init_memmap+0x5c>
ffffffffc0201a8e:	c199                	beqz	a1,ffffffffc0201a94 <default_init_memmap+0x72>
ffffffffc0201a90:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201a94:	6398                	ld	a4,0(a5)
}
ffffffffc0201a96:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201a98:	e390                	sd	a2,0(a5)
ffffffffc0201a9a:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201a9c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a9e:	ed18                	sd	a4,24(a0)
ffffffffc0201aa0:	0141                	addi	sp,sp,16
ffffffffc0201aa2:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201aa4:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201aa6:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201aa8:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201aaa:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201aac:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc0201aae:	00d70e63          	beq	a4,a3,ffffffffc0201aca <default_init_memmap+0xa8>
ffffffffc0201ab2:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0201ab4:	87ba                	mv	a5,a4
ffffffffc0201ab6:	bfc1                	j	ffffffffc0201a86 <default_init_memmap+0x64>
}
ffffffffc0201ab8:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201aba:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0201abe:	e398                	sd	a4,0(a5)
ffffffffc0201ac0:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc0201ac2:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201ac4:	ed1c                	sd	a5,24(a0)
}
ffffffffc0201ac6:	0141                	addi	sp,sp,16
ffffffffc0201ac8:	8082                	ret
ffffffffc0201aca:	60a2                	ld	ra,8(sp)
ffffffffc0201acc:	e290                	sd	a2,0(a3)
ffffffffc0201ace:	0141                	addi	sp,sp,16
ffffffffc0201ad0:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201ad2:	00005697          	auipc	a3,0x5
ffffffffc0201ad6:	d4668693          	addi	a3,a3,-698 # ffffffffc0206818 <etext+0xdaa>
ffffffffc0201ada:	00005617          	auipc	a2,0x5
ffffffffc0201ade:	9b660613          	addi	a2,a2,-1610 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201ae2:	04b00593          	li	a1,75
ffffffffc0201ae6:	00005517          	auipc	a0,0x5
ffffffffc0201aea:	9c250513          	addi	a0,a0,-1598 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc0201aee:	99bfe0ef          	jal	ffffffffc0200488 <__panic>
    assert(n > 0);
ffffffffc0201af2:	00005697          	auipc	a3,0x5
ffffffffc0201af6:	cf668693          	addi	a3,a3,-778 # ffffffffc02067e8 <etext+0xd7a>
ffffffffc0201afa:	00005617          	auipc	a2,0x5
ffffffffc0201afe:	99660613          	addi	a2,a2,-1642 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201b02:	04700593          	li	a1,71
ffffffffc0201b06:	00005517          	auipc	a0,0x5
ffffffffc0201b0a:	9a250513          	addi	a0,a0,-1630 # ffffffffc02064a8 <etext+0xa3a>
ffffffffc0201b0e:	97bfe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201b12 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201b12:	cd49                	beqz	a0,ffffffffc0201bac <slob_free+0x9a>
{
ffffffffc0201b14:	1141                	addi	sp,sp,-16
ffffffffc0201b16:	e022                	sd	s0,0(sp)
ffffffffc0201b18:	e406                	sd	ra,8(sp)
ffffffffc0201b1a:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201b1c:	eda1                	bnez	a1,ffffffffc0201b74 <slob_free+0x62>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b1e:	100027f3          	csrr	a5,sstatus
ffffffffc0201b22:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201b24:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b26:	efb9                	bnez	a5,ffffffffc0201b84 <slob_free+0x72>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201b28:	00099617          	auipc	a2,0x99
ffffffffc0201b2c:	e9060613          	addi	a2,a2,-368 # ffffffffc029a9b8 <slobfree>
ffffffffc0201b30:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b32:	6798                	ld	a4,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201b34:	0287fa63          	bgeu	a5,s0,ffffffffc0201b68 <slob_free+0x56>
ffffffffc0201b38:	00e46463          	bltu	s0,a4,ffffffffc0201b40 <slob_free+0x2e>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b3c:	02e7ea63          	bltu	a5,a4,ffffffffc0201b70 <slob_free+0x5e>
			break;

	if (b + b->units == cur->next)
ffffffffc0201b40:	400c                	lw	a1,0(s0)
ffffffffc0201b42:	00459693          	slli	a3,a1,0x4
ffffffffc0201b46:	96a2                	add	a3,a3,s0
ffffffffc0201b48:	04d70d63          	beq	a4,a3,ffffffffc0201ba2 <slob_free+0x90>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201b4c:	438c                	lw	a1,0(a5)
ffffffffc0201b4e:	e418                	sd	a4,8(s0)
ffffffffc0201b50:	00459693          	slli	a3,a1,0x4
ffffffffc0201b54:	96be                	add	a3,a3,a5
ffffffffc0201b56:	04d40063          	beq	s0,a3,ffffffffc0201b96 <slob_free+0x84>
ffffffffc0201b5a:	e780                	sd	s0,8(a5)
		cur->next = b->next;
	}
	else
		cur->next = b;

	slobfree = cur;
ffffffffc0201b5c:	e21c                	sd	a5,0(a2)
    if (flag)
ffffffffc0201b5e:	e51d                	bnez	a0,ffffffffc0201b8c <slob_free+0x7a>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201b60:	60a2                	ld	ra,8(sp)
ffffffffc0201b62:	6402                	ld	s0,0(sp)
ffffffffc0201b64:	0141                	addi	sp,sp,16
ffffffffc0201b66:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b68:	00e7e463          	bltu	a5,a4,ffffffffc0201b70 <slob_free+0x5e>
ffffffffc0201b6c:	fce46ae3          	bltu	s0,a4,ffffffffc0201b40 <slob_free+0x2e>
        return 1;
ffffffffc0201b70:	87ba                	mv	a5,a4
ffffffffc0201b72:	b7c1                	j	ffffffffc0201b32 <slob_free+0x20>
		b->units = SLOB_UNITS(size);
ffffffffc0201b74:	25bd                	addiw	a1,a1,15
ffffffffc0201b76:	8191                	srli	a1,a1,0x4
ffffffffc0201b78:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b7a:	100027f3          	csrr	a5,sstatus
ffffffffc0201b7e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201b80:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b82:	d3dd                	beqz	a5,ffffffffc0201b28 <slob_free+0x16>
        intr_disable();
ffffffffc0201b84:	df7fe0ef          	jal	ffffffffc020097a <intr_disable>
        return 1;
ffffffffc0201b88:	4505                	li	a0,1
ffffffffc0201b8a:	bf79                	j	ffffffffc0201b28 <slob_free+0x16>
}
ffffffffc0201b8c:	6402                	ld	s0,0(sp)
ffffffffc0201b8e:	60a2                	ld	ra,8(sp)
ffffffffc0201b90:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201b92:	de3fe06f          	j	ffffffffc0200974 <intr_enable>
		cur->units += b->units;
ffffffffc0201b96:	4014                	lw	a3,0(s0)
		cur->next = b->next;
ffffffffc0201b98:	843a                	mv	s0,a4
		cur->units += b->units;
ffffffffc0201b9a:	00b6873b          	addw	a4,a3,a1
ffffffffc0201b9e:	c398                	sw	a4,0(a5)
		cur->next = b->next;
ffffffffc0201ba0:	bf6d                	j	ffffffffc0201b5a <slob_free+0x48>
		b->units += cur->next->units;
ffffffffc0201ba2:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201ba4:	6718                	ld	a4,8(a4)
		b->units += cur->next->units;
ffffffffc0201ba6:	9ead                	addw	a3,a3,a1
ffffffffc0201ba8:	c014                	sw	a3,0(s0)
		b->next = cur->next->next;
ffffffffc0201baa:	b74d                	j	ffffffffc0201b4c <slob_free+0x3a>
ffffffffc0201bac:	8082                	ret

ffffffffc0201bae <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201bae:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201bb0:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201bb2:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201bb6:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201bb8:	34c000ef          	jal	ffffffffc0201f04 <alloc_pages>
	if (!page)
ffffffffc0201bbc:	c91d                	beqz	a0,ffffffffc0201bf2 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201bbe:	0009d797          	auipc	a5,0x9d
ffffffffc0201bc2:	2927b783          	ld	a5,658(a5) # ffffffffc029ee50 <pages>
ffffffffc0201bc6:	8d1d                	sub	a0,a0,a5
ffffffffc0201bc8:	8519                	srai	a0,a0,0x6
ffffffffc0201bca:	00006797          	auipc	a5,0x6
ffffffffc0201bce:	ffe7b783          	ld	a5,-2(a5) # ffffffffc0207bc8 <nbase>
ffffffffc0201bd2:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc0201bd4:	00c51793          	slli	a5,a0,0xc
ffffffffc0201bd8:	83b1                	srli	a5,a5,0xc
ffffffffc0201bda:	0009d717          	auipc	a4,0x9d
ffffffffc0201bde:	26e73703          	ld	a4,622(a4) # ffffffffc029ee48 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201be2:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201be4:	00e7fa63          	bgeu	a5,a4,ffffffffc0201bf8 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201be8:	0009d797          	auipc	a5,0x9d
ffffffffc0201bec:	2587b783          	ld	a5,600(a5) # ffffffffc029ee40 <va_pa_offset>
ffffffffc0201bf0:	953e                	add	a0,a0,a5
}
ffffffffc0201bf2:	60a2                	ld	ra,8(sp)
ffffffffc0201bf4:	0141                	addi	sp,sp,16
ffffffffc0201bf6:	8082                	ret
ffffffffc0201bf8:	86aa                	mv	a3,a0
ffffffffc0201bfa:	00005617          	auipc	a2,0x5
ffffffffc0201bfe:	c4660613          	addi	a2,a2,-954 # ffffffffc0206840 <etext+0xdd2>
ffffffffc0201c02:	07100593          	li	a1,113
ffffffffc0201c06:	00005517          	auipc	a0,0x5
ffffffffc0201c0a:	c6250513          	addi	a0,a0,-926 # ffffffffc0206868 <etext+0xdfa>
ffffffffc0201c0e:	87bfe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201c12 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201c12:	1101                	addi	sp,sp,-32
ffffffffc0201c14:	ec06                	sd	ra,24(sp)
ffffffffc0201c16:	e822                	sd	s0,16(sp)
ffffffffc0201c18:	e426                	sd	s1,8(sp)
ffffffffc0201c1a:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201c1c:	01050713          	addi	a4,a0,16
ffffffffc0201c20:	6785                	lui	a5,0x1
ffffffffc0201c22:	0cf77363          	bgeu	a4,a5,ffffffffc0201ce8 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201c26:	00f50493          	addi	s1,a0,15
ffffffffc0201c2a:	8091                	srli	s1,s1,0x4
ffffffffc0201c2c:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c2e:	10002673          	csrr	a2,sstatus
ffffffffc0201c32:	8a09                	andi	a2,a2,2
ffffffffc0201c34:	e25d                	bnez	a2,ffffffffc0201cda <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201c36:	00099917          	auipc	s2,0x99
ffffffffc0201c3a:	d8290913          	addi	s2,s2,-638 # ffffffffc029a9b8 <slobfree>
ffffffffc0201c3e:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c42:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201c44:	4398                	lw	a4,0(a5)
ffffffffc0201c46:	08975e63          	bge	a4,s1,ffffffffc0201ce2 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201c4a:	00f68b63          	beq	a3,a5,ffffffffc0201c60 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c4e:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201c50:	4018                	lw	a4,0(s0)
ffffffffc0201c52:	02975a63          	bge	a4,s1,ffffffffc0201c86 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201c56:	00093683          	ld	a3,0(s2)
ffffffffc0201c5a:	87a2                	mv	a5,s0
ffffffffc0201c5c:	fef699e3          	bne	a3,a5,ffffffffc0201c4e <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201c60:	ee31                	bnez	a2,ffffffffc0201cbc <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201c62:	4501                	li	a0,0
ffffffffc0201c64:	f4bff0ef          	jal	ffffffffc0201bae <__slob_get_free_pages.constprop.0>
ffffffffc0201c68:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201c6a:	cd05                	beqz	a0,ffffffffc0201ca2 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201c6c:	6585                	lui	a1,0x1
ffffffffc0201c6e:	ea5ff0ef          	jal	ffffffffc0201b12 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c72:	10002673          	csrr	a2,sstatus
ffffffffc0201c76:	8a09                	andi	a2,a2,2
ffffffffc0201c78:	ee05                	bnez	a2,ffffffffc0201cb0 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201c7a:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c7e:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201c80:	4018                	lw	a4,0(s0)
ffffffffc0201c82:	fc974ae3          	blt	a4,s1,ffffffffc0201c56 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201c86:	04e48763          	beq	s1,a4,ffffffffc0201cd4 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201c8a:	00449693          	slli	a3,s1,0x4
ffffffffc0201c8e:	96a2                	add	a3,a3,s0
ffffffffc0201c90:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201c92:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201c94:	9f05                	subw	a4,a4,s1
ffffffffc0201c96:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201c98:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201c9a:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201c9c:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201ca0:	e20d                	bnez	a2,ffffffffc0201cc2 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201ca2:	60e2                	ld	ra,24(sp)
ffffffffc0201ca4:	8522                	mv	a0,s0
ffffffffc0201ca6:	6442                	ld	s0,16(sp)
ffffffffc0201ca8:	64a2                	ld	s1,8(sp)
ffffffffc0201caa:	6902                	ld	s2,0(sp)
ffffffffc0201cac:	6105                	addi	sp,sp,32
ffffffffc0201cae:	8082                	ret
        intr_disable();
ffffffffc0201cb0:	ccbfe0ef          	jal	ffffffffc020097a <intr_disable>
			cur = slobfree;
ffffffffc0201cb4:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201cb8:	4605                	li	a2,1
ffffffffc0201cba:	b7d1                	j	ffffffffc0201c7e <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201cbc:	cb9fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0201cc0:	b74d                	j	ffffffffc0201c62 <slob_alloc.constprop.0+0x50>
ffffffffc0201cc2:	cb3fe0ef          	jal	ffffffffc0200974 <intr_enable>
}
ffffffffc0201cc6:	60e2                	ld	ra,24(sp)
ffffffffc0201cc8:	8522                	mv	a0,s0
ffffffffc0201cca:	6442                	ld	s0,16(sp)
ffffffffc0201ccc:	64a2                	ld	s1,8(sp)
ffffffffc0201cce:	6902                	ld	s2,0(sp)
ffffffffc0201cd0:	6105                	addi	sp,sp,32
ffffffffc0201cd2:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201cd4:	6418                	ld	a4,8(s0)
ffffffffc0201cd6:	e798                	sd	a4,8(a5)
ffffffffc0201cd8:	b7d1                	j	ffffffffc0201c9c <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201cda:	ca1fe0ef          	jal	ffffffffc020097a <intr_disable>
        return 1;
ffffffffc0201cde:	4605                	li	a2,1
ffffffffc0201ce0:	bf99                	j	ffffffffc0201c36 <slob_alloc.constprop.0+0x24>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201ce2:	843e                	mv	s0,a5
	prev = slobfree;
ffffffffc0201ce4:	87b6                	mv	a5,a3
ffffffffc0201ce6:	b745                	j	ffffffffc0201c86 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201ce8:	00005697          	auipc	a3,0x5
ffffffffc0201cec:	b9068693          	addi	a3,a3,-1136 # ffffffffc0206878 <etext+0xe0a>
ffffffffc0201cf0:	00004617          	auipc	a2,0x4
ffffffffc0201cf4:	7a060613          	addi	a2,a2,1952 # ffffffffc0206490 <etext+0xa22>
ffffffffc0201cf8:	06300593          	li	a1,99
ffffffffc0201cfc:	00005517          	auipc	a0,0x5
ffffffffc0201d00:	b9c50513          	addi	a0,a0,-1124 # ffffffffc0206898 <etext+0xe2a>
ffffffffc0201d04:	f84fe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201d08 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201d08:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201d0a:	00005517          	auipc	a0,0x5
ffffffffc0201d0e:	ba650513          	addi	a0,a0,-1114 # ffffffffc02068b0 <etext+0xe42>
{
ffffffffc0201d12:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201d14:	c80fe0ef          	jal	ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201d18:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201d1a:	00005517          	auipc	a0,0x5
ffffffffc0201d1e:	bae50513          	addi	a0,a0,-1106 # ffffffffc02068c8 <etext+0xe5a>
}
ffffffffc0201d22:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201d24:	c70fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201d28 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201d28:	4501                	li	a0,0
ffffffffc0201d2a:	8082                	ret

ffffffffc0201d2c <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201d2c:	1101                	addi	sp,sp,-32
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d2e:	6785                	lui	a5,0x1
{
ffffffffc0201d30:	e822                	sd	s0,16(sp)
ffffffffc0201d32:	ec06                	sd	ra,24(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d34:	17bd                	addi	a5,a5,-17 # fef <_binary_obj___user_softint_out_size-0x75a9>
{
ffffffffc0201d36:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d38:	04a7fa63          	bgeu	a5,a0,ffffffffc0201d8c <kmalloc+0x60>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201d3c:	4561                	li	a0,24
ffffffffc0201d3e:	e426                	sd	s1,8(sp)
ffffffffc0201d40:	ed3ff0ef          	jal	ffffffffc0201c12 <slob_alloc.constprop.0>
ffffffffc0201d44:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201d46:	c549                	beqz	a0,ffffffffc0201dd0 <kmalloc+0xa4>
ffffffffc0201d48:	e04a                	sd	s2,0(sp)
	bb->order = find_order(size);
ffffffffc0201d4a:	0004079b          	sext.w	a5,s0
ffffffffc0201d4e:	6905                	lui	s2,0x1
	int order = 0;
ffffffffc0201d50:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201d52:	00f95763          	bge	s2,a5,ffffffffc0201d60 <kmalloc+0x34>
ffffffffc0201d56:	6705                	lui	a4,0x1
ffffffffc0201d58:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201d5a:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201d5c:	fef74ee3          	blt	a4,a5,ffffffffc0201d58 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201d60:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201d62:	e4dff0ef          	jal	ffffffffc0201bae <__slob_get_free_pages.constprop.0>
ffffffffc0201d66:	e488                	sd	a0,8(s1)
	if (bb->pages)
ffffffffc0201d68:	cd21                	beqz	a0,ffffffffc0201dc0 <kmalloc+0x94>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d6a:	100027f3          	csrr	a5,sstatus
ffffffffc0201d6e:	8b89                	andi	a5,a5,2
ffffffffc0201d70:	e795                	bnez	a5,ffffffffc0201d9c <kmalloc+0x70>
		bb->next = bigblocks;
ffffffffc0201d72:	0009d797          	auipc	a5,0x9d
ffffffffc0201d76:	0ae78793          	addi	a5,a5,174 # ffffffffc029ee20 <bigblocks>
ffffffffc0201d7a:	6398                	ld	a4,0(a5)
ffffffffc0201d7c:	6902                	ld	s2,0(sp)
		bigblocks = bb;
ffffffffc0201d7e:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201d80:	e898                	sd	a4,16(s1)
    if (flag)
ffffffffc0201d82:	64a2                	ld	s1,8(sp)
	return __kmalloc(size, 0);
}
ffffffffc0201d84:	60e2                	ld	ra,24(sp)
ffffffffc0201d86:	6442                	ld	s0,16(sp)
ffffffffc0201d88:	6105                	addi	sp,sp,32
ffffffffc0201d8a:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201d8c:	0541                	addi	a0,a0,16
ffffffffc0201d8e:	e85ff0ef          	jal	ffffffffc0201c12 <slob_alloc.constprop.0>
ffffffffc0201d92:	87aa                	mv	a5,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201d94:	0541                	addi	a0,a0,16
ffffffffc0201d96:	f7fd                	bnez	a5,ffffffffc0201d84 <kmalloc+0x58>
		return 0;
ffffffffc0201d98:	4501                	li	a0,0
	return __kmalloc(size, 0);
ffffffffc0201d9a:	b7ed                	j	ffffffffc0201d84 <kmalloc+0x58>
        intr_disable();
ffffffffc0201d9c:	bdffe0ef          	jal	ffffffffc020097a <intr_disable>
		bb->next = bigblocks;
ffffffffc0201da0:	0009d797          	auipc	a5,0x9d
ffffffffc0201da4:	08078793          	addi	a5,a5,128 # ffffffffc029ee20 <bigblocks>
ffffffffc0201da8:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201daa:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201dac:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201dae:	bc7fe0ef          	jal	ffffffffc0200974 <intr_enable>
}
ffffffffc0201db2:	60e2                	ld	ra,24(sp)
ffffffffc0201db4:	6442                	ld	s0,16(sp)
		return bb->pages;
ffffffffc0201db6:	6488                	ld	a0,8(s1)
ffffffffc0201db8:	6902                	ld	s2,0(sp)
ffffffffc0201dba:	64a2                	ld	s1,8(sp)
}
ffffffffc0201dbc:	6105                	addi	sp,sp,32
ffffffffc0201dbe:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201dc0:	8526                	mv	a0,s1
ffffffffc0201dc2:	45e1                	li	a1,24
ffffffffc0201dc4:	d4fff0ef          	jal	ffffffffc0201b12 <slob_free>
		return 0;
ffffffffc0201dc8:	4501                	li	a0,0
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201dca:	64a2                	ld	s1,8(sp)
ffffffffc0201dcc:	6902                	ld	s2,0(sp)
ffffffffc0201dce:	bf5d                	j	ffffffffc0201d84 <kmalloc+0x58>
ffffffffc0201dd0:	64a2                	ld	s1,8(sp)
		return 0;
ffffffffc0201dd2:	4501                	li	a0,0
ffffffffc0201dd4:	bf45                	j	ffffffffc0201d84 <kmalloc+0x58>

ffffffffc0201dd6 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201dd6:	c169                	beqz	a0,ffffffffc0201e98 <kfree+0xc2>
{
ffffffffc0201dd8:	1101                	addi	sp,sp,-32
ffffffffc0201dda:	e822                	sd	s0,16(sp)
ffffffffc0201ddc:	ec06                	sd	ra,24(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201dde:	03451793          	slli	a5,a0,0x34
ffffffffc0201de2:	842a                	mv	s0,a0
ffffffffc0201de4:	e7c9                	bnez	a5,ffffffffc0201e6e <kfree+0x98>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201de6:	100027f3          	csrr	a5,sstatus
ffffffffc0201dea:	8b89                	andi	a5,a5,2
ffffffffc0201dec:	ebc1                	bnez	a5,ffffffffc0201e7c <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201dee:	0009d797          	auipc	a5,0x9d
ffffffffc0201df2:	0327b783          	ld	a5,50(a5) # ffffffffc029ee20 <bigblocks>
    return 0;
ffffffffc0201df6:	4601                	li	a2,0
ffffffffc0201df8:	cbbd                	beqz	a5,ffffffffc0201e6e <kfree+0x98>
ffffffffc0201dfa:	e426                	sd	s1,8(sp)
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201dfc:	0009d697          	auipc	a3,0x9d
ffffffffc0201e00:	02468693          	addi	a3,a3,36 # ffffffffc029ee20 <bigblocks>
ffffffffc0201e04:	a021                	j	ffffffffc0201e0c <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e06:	01048693          	addi	a3,s1,16
ffffffffc0201e0a:	c3a5                	beqz	a5,ffffffffc0201e6a <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201e0c:	6798                	ld	a4,8(a5)
ffffffffc0201e0e:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201e10:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201e12:	fe871ae3          	bne	a4,s0,ffffffffc0201e06 <kfree+0x30>
				*last = bb->next;
ffffffffc0201e16:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201e18:	ee2d                	bnez	a2,ffffffffc0201e92 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201e1a:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201e1e:	4098                	lw	a4,0(s1)
ffffffffc0201e20:	08f46963          	bltu	s0,a5,ffffffffc0201eb2 <kfree+0xdc>
ffffffffc0201e24:	0009d797          	auipc	a5,0x9d
ffffffffc0201e28:	01c7b783          	ld	a5,28(a5) # ffffffffc029ee40 <va_pa_offset>
ffffffffc0201e2c:	8c1d                	sub	s0,s0,a5
    if (PPN(pa) >= npage)
ffffffffc0201e2e:	8031                	srli	s0,s0,0xc
ffffffffc0201e30:	0009d797          	auipc	a5,0x9d
ffffffffc0201e34:	0187b783          	ld	a5,24(a5) # ffffffffc029ee48 <npage>
ffffffffc0201e38:	06f47163          	bgeu	s0,a5,ffffffffc0201e9a <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201e3c:	00006797          	auipc	a5,0x6
ffffffffc0201e40:	d8c7b783          	ld	a5,-628(a5) # ffffffffc0207bc8 <nbase>
ffffffffc0201e44:	8c1d                	sub	s0,s0,a5
ffffffffc0201e46:	041a                	slli	s0,s0,0x6
	free_pages(kva2page((void *)kva), 1 << order);
ffffffffc0201e48:	0009d517          	auipc	a0,0x9d
ffffffffc0201e4c:	00853503          	ld	a0,8(a0) # ffffffffc029ee50 <pages>
ffffffffc0201e50:	4585                	li	a1,1
ffffffffc0201e52:	9522                	add	a0,a0,s0
ffffffffc0201e54:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201e58:	0ea000ef          	jal	ffffffffc0201f42 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201e5c:	6442                	ld	s0,16(sp)
ffffffffc0201e5e:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e60:	8526                	mv	a0,s1
ffffffffc0201e62:	64a2                	ld	s1,8(sp)
ffffffffc0201e64:	45e1                	li	a1,24
}
ffffffffc0201e66:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e68:	b16d                	j	ffffffffc0201b12 <slob_free>
ffffffffc0201e6a:	64a2                	ld	s1,8(sp)
ffffffffc0201e6c:	e205                	bnez	a2,ffffffffc0201e8c <kfree+0xb6>
ffffffffc0201e6e:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201e72:	6442                	ld	s0,16(sp)
ffffffffc0201e74:	60e2                	ld	ra,24(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e76:	4581                	li	a1,0
}
ffffffffc0201e78:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e7a:	b961                	j	ffffffffc0201b12 <slob_free>
        intr_disable();
ffffffffc0201e7c:	afffe0ef          	jal	ffffffffc020097a <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e80:	0009d797          	auipc	a5,0x9d
ffffffffc0201e84:	fa07b783          	ld	a5,-96(a5) # ffffffffc029ee20 <bigblocks>
        return 1;
ffffffffc0201e88:	4605                	li	a2,1
ffffffffc0201e8a:	fba5                	bnez	a5,ffffffffc0201dfa <kfree+0x24>
        intr_enable();
ffffffffc0201e8c:	ae9fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0201e90:	bff9                	j	ffffffffc0201e6e <kfree+0x98>
ffffffffc0201e92:	ae3fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0201e96:	b751                	j	ffffffffc0201e1a <kfree+0x44>
ffffffffc0201e98:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201e9a:	00005617          	auipc	a2,0x5
ffffffffc0201e9e:	a7660613          	addi	a2,a2,-1418 # ffffffffc0206910 <etext+0xea2>
ffffffffc0201ea2:	06900593          	li	a1,105
ffffffffc0201ea6:	00005517          	auipc	a0,0x5
ffffffffc0201eaa:	9c250513          	addi	a0,a0,-1598 # ffffffffc0206868 <etext+0xdfa>
ffffffffc0201eae:	ddafe0ef          	jal	ffffffffc0200488 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201eb2:	86a2                	mv	a3,s0
ffffffffc0201eb4:	00005617          	auipc	a2,0x5
ffffffffc0201eb8:	a3460613          	addi	a2,a2,-1484 # ffffffffc02068e8 <etext+0xe7a>
ffffffffc0201ebc:	07700593          	li	a1,119
ffffffffc0201ec0:	00005517          	auipc	a0,0x5
ffffffffc0201ec4:	9a850513          	addi	a0,a0,-1624 # ffffffffc0206868 <etext+0xdfa>
ffffffffc0201ec8:	dc0fe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201ecc <pa2page.part.0>:

    uint64_t mem_begin = get_memory_base();
    uint64_t mem_size = get_memory_size();
    if (mem_size == 0)
    {
        panic("DTB memory info not available");
ffffffffc0201ecc:	1141                	addi	sp,sp,-16
    }
    uint64_t mem_end = mem_begin + mem_size;

    cprintf("physcial memory map:\n");
ffffffffc0201ece:	00005617          	auipc	a2,0x5
ffffffffc0201ed2:	a4260613          	addi	a2,a2,-1470 # ffffffffc0206910 <etext+0xea2>
ffffffffc0201ed6:	06900593          	li	a1,105
ffffffffc0201eda:	00005517          	auipc	a0,0x5
ffffffffc0201ede:	98e50513          	addi	a0,a0,-1650 # ffffffffc0206868 <etext+0xdfa>
        panic("DTB memory info not available");
ffffffffc0201ee2:	e406                	sd	ra,8(sp)
    cprintf("physcial memory map:\n");
ffffffffc0201ee4:	da4fe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201ee8 <pte2page.part.0>:
    npage = maxpa / PGSIZE;
    // BBL has put the initial page table at the first available page after the
    // kernel
    // so stay away from it by adding extra offset to end
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

ffffffffc0201ee8:	1141                	addi	sp,sp,-16
    for (size_t i = 0; i < npage - nbase; i++)
    {
        SetPageReserved(pages + i);
    }
ffffffffc0201eea:	00005617          	auipc	a2,0x5
ffffffffc0201eee:	a4660613          	addi	a2,a2,-1466 # ffffffffc0206930 <etext+0xec2>
ffffffffc0201ef2:	07f00593          	li	a1,127
ffffffffc0201ef6:	00005517          	auipc	a0,0x5
ffffffffc0201efa:	97250513          	addi	a0,a0,-1678 # ffffffffc0206868 <etext+0xdfa>

ffffffffc0201efe:	e406                	sd	ra,8(sp)
    }
ffffffffc0201f00:	d88fe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201f04 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f04:	100027f3          	csrr	a5,sstatus
ffffffffc0201f08:	8b89                	andi	a5,a5,2
ffffffffc0201f0a:	e799                	bnez	a5,ffffffffc0201f18 <alloc_pages+0x14>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f0c:	0009d797          	auipc	a5,0x9d
ffffffffc0201f10:	f1c7b783          	ld	a5,-228(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc0201f14:	6f9c                	ld	a5,24(a5)
ffffffffc0201f16:	8782                	jr	a5
{
ffffffffc0201f18:	1141                	addi	sp,sp,-16
ffffffffc0201f1a:	e406                	sd	ra,8(sp)
ffffffffc0201f1c:	e022                	sd	s0,0(sp)
ffffffffc0201f1e:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201f20:	a5bfe0ef          	jal	ffffffffc020097a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f24:	0009d797          	auipc	a5,0x9d
ffffffffc0201f28:	f047b783          	ld	a5,-252(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc0201f2c:	6f9c                	ld	a5,24(a5)
ffffffffc0201f2e:	8522                	mv	a0,s0
ffffffffc0201f30:	9782                	jalr	a5
ffffffffc0201f32:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201f34:	a41fe0ef          	jal	ffffffffc0200974 <intr_enable>
}
ffffffffc0201f38:	60a2                	ld	ra,8(sp)
ffffffffc0201f3a:	8522                	mv	a0,s0
ffffffffc0201f3c:	6402                	ld	s0,0(sp)
ffffffffc0201f3e:	0141                	addi	sp,sp,16
ffffffffc0201f40:	8082                	ret

ffffffffc0201f42 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f42:	100027f3          	csrr	a5,sstatus
ffffffffc0201f46:	8b89                	andi	a5,a5,2
ffffffffc0201f48:	e799                	bnez	a5,ffffffffc0201f56 <free_pages+0x14>
        pmm_manager->free_pages(base, n);
ffffffffc0201f4a:	0009d797          	auipc	a5,0x9d
ffffffffc0201f4e:	ede7b783          	ld	a5,-290(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc0201f52:	739c                	ld	a5,32(a5)
ffffffffc0201f54:	8782                	jr	a5
{
ffffffffc0201f56:	1101                	addi	sp,sp,-32
ffffffffc0201f58:	ec06                	sd	ra,24(sp)
ffffffffc0201f5a:	e822                	sd	s0,16(sp)
ffffffffc0201f5c:	e426                	sd	s1,8(sp)
ffffffffc0201f5e:	842a                	mv	s0,a0
ffffffffc0201f60:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201f62:	a19fe0ef          	jal	ffffffffc020097a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201f66:	0009d797          	auipc	a5,0x9d
ffffffffc0201f6a:	ec27b783          	ld	a5,-318(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc0201f6e:	739c                	ld	a5,32(a5)
ffffffffc0201f70:	85a6                	mv	a1,s1
ffffffffc0201f72:	8522                	mv	a0,s0
ffffffffc0201f74:	9782                	jalr	a5
}
ffffffffc0201f76:	6442                	ld	s0,16(sp)
ffffffffc0201f78:	60e2                	ld	ra,24(sp)
ffffffffc0201f7a:	64a2                	ld	s1,8(sp)
ffffffffc0201f7c:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201f7e:	9f7fe06f          	j	ffffffffc0200974 <intr_enable>

ffffffffc0201f82 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f82:	100027f3          	csrr	a5,sstatus
ffffffffc0201f86:	8b89                	andi	a5,a5,2
ffffffffc0201f88:	e799                	bnez	a5,ffffffffc0201f96 <nr_free_pages+0x14>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f8a:	0009d797          	auipc	a5,0x9d
ffffffffc0201f8e:	e9e7b783          	ld	a5,-354(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc0201f92:	779c                	ld	a5,40(a5)
ffffffffc0201f94:	8782                	jr	a5
{
ffffffffc0201f96:	1141                	addi	sp,sp,-16
ffffffffc0201f98:	e406                	sd	ra,8(sp)
ffffffffc0201f9a:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201f9c:	9dffe0ef          	jal	ffffffffc020097a <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201fa0:	0009d797          	auipc	a5,0x9d
ffffffffc0201fa4:	e887b783          	ld	a5,-376(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc0201fa8:	779c                	ld	a5,40(a5)
ffffffffc0201faa:	9782                	jalr	a5
ffffffffc0201fac:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201fae:	9c7fe0ef          	jal	ffffffffc0200974 <intr_enable>
}
ffffffffc0201fb2:	60a2                	ld	ra,8(sp)
ffffffffc0201fb4:	8522                	mv	a0,s0
ffffffffc0201fb6:	6402                	ld	s0,0(sp)
ffffffffc0201fb8:	0141                	addi	sp,sp,16
ffffffffc0201fba:	8082                	ret

ffffffffc0201fbc <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201fbc:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201fc0:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201fc4:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201fc6:	078e                	slli	a5,a5,0x3
{
ffffffffc0201fc8:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201fca:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201fce:	6094                	ld	a3,0(s1)
{
ffffffffc0201fd0:	f04a                	sd	s2,32(sp)
ffffffffc0201fd2:	ec4e                	sd	s3,24(sp)
ffffffffc0201fd4:	e852                	sd	s4,16(sp)
ffffffffc0201fd6:	fc06                	sd	ra,56(sp)
ffffffffc0201fd8:	f822                	sd	s0,48(sp)
ffffffffc0201fda:	e456                	sd	s5,8(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201fdc:	0016f793          	andi	a5,a3,1
{
ffffffffc0201fe0:	892e                	mv	s2,a1
ffffffffc0201fe2:	8a32                	mv	s4,a2
ffffffffc0201fe4:	0009d997          	auipc	s3,0x9d
ffffffffc0201fe8:	e6498993          	addi	s3,s3,-412 # ffffffffc029ee48 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201fec:	e3c9                	bnez	a5,ffffffffc020206e <get_pte+0xb2>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201fee:	14060f63          	beqz	a2,ffffffffc020214c <get_pte+0x190>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ff2:	100027f3          	csrr	a5,sstatus
ffffffffc0201ff6:	8b89                	andi	a5,a5,2
ffffffffc0201ff8:	14079c63          	bnez	a5,ffffffffc0202150 <get_pte+0x194>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ffc:	0009d797          	auipc	a5,0x9d
ffffffffc0202000:	e2c7b783          	ld	a5,-468(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc0202004:	6f9c                	ld	a5,24(a5)
ffffffffc0202006:	4505                	li	a0,1
ffffffffc0202008:	9782                	jalr	a5
ffffffffc020200a:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020200c:	14040063          	beqz	s0,ffffffffc020214c <get_pte+0x190>
    page->ref = val;
ffffffffc0202010:	e05a                	sd	s6,0(sp)
    return page - pages + nbase;
ffffffffc0202012:	0009db17          	auipc	s6,0x9d
ffffffffc0202016:	e3eb0b13          	addi	s6,s6,-450 # ffffffffc029ee50 <pages>
ffffffffc020201a:	000b3503          	ld	a0,0(s6)
ffffffffc020201e:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202022:	0009d997          	auipc	s3,0x9d
ffffffffc0202026:	e2698993          	addi	s3,s3,-474 # ffffffffc029ee48 <npage>
ffffffffc020202a:	40a40533          	sub	a0,s0,a0
ffffffffc020202e:	8519                	srai	a0,a0,0x6
ffffffffc0202030:	9556                	add	a0,a0,s5
ffffffffc0202032:	0009b703          	ld	a4,0(s3)
ffffffffc0202036:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc020203a:	4685                	li	a3,1
ffffffffc020203c:	c014                	sw	a3,0(s0)
ffffffffc020203e:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202040:	0532                	slli	a0,a0,0xc
ffffffffc0202042:	16e7fb63          	bgeu	a5,a4,ffffffffc02021b8 <get_pte+0x1fc>
ffffffffc0202046:	0009d797          	auipc	a5,0x9d
ffffffffc020204a:	dfa7b783          	ld	a5,-518(a5) # ffffffffc029ee40 <va_pa_offset>
ffffffffc020204e:	953e                	add	a0,a0,a5
ffffffffc0202050:	6605                	lui	a2,0x1
ffffffffc0202052:	4581                	li	a1,0
ffffffffc0202054:	1f1030ef          	jal	ffffffffc0205a44 <memset>
    return page - pages + nbase;
ffffffffc0202058:	000b3783          	ld	a5,0(s6)
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020205c:	6b02                	ld	s6,0(sp)
ffffffffc020205e:	40f406b3          	sub	a3,s0,a5
ffffffffc0202062:	8699                	srai	a3,a3,0x6
ffffffffc0202064:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202066:	06aa                	slli	a3,a3,0xa
ffffffffc0202068:	0116e693          	ori	a3,a3,17
ffffffffc020206c:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020206e:	77fd                	lui	a5,0xfffff
ffffffffc0202070:	068a                	slli	a3,a3,0x2
ffffffffc0202072:	0009b703          	ld	a4,0(s3)
ffffffffc0202076:	8efd                	and	a3,a3,a5
ffffffffc0202078:	00c6d793          	srli	a5,a3,0xc
ffffffffc020207c:	12e7f163          	bgeu	a5,a4,ffffffffc020219e <get_pte+0x1e2>
ffffffffc0202080:	0009da97          	auipc	s5,0x9d
ffffffffc0202084:	dc0a8a93          	addi	s5,s5,-576 # ffffffffc029ee40 <va_pa_offset>
ffffffffc0202088:	000ab603          	ld	a2,0(s5)
ffffffffc020208c:	01595793          	srli	a5,s2,0x15
ffffffffc0202090:	1ff7f793          	andi	a5,a5,511
ffffffffc0202094:	96b2                	add	a3,a3,a2
ffffffffc0202096:	078e                	slli	a5,a5,0x3
ffffffffc0202098:	00f68433          	add	s0,a3,a5
    if (!(*pdep0 & PTE_V))
ffffffffc020209c:	6014                	ld	a3,0(s0)
ffffffffc020209e:	0016f793          	andi	a5,a3,1
ffffffffc02020a2:	ebbd                	bnez	a5,ffffffffc0202118 <get_pte+0x15c>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02020a4:	0a0a0463          	beqz	s4,ffffffffc020214c <get_pte+0x190>
ffffffffc02020a8:	100027f3          	csrr	a5,sstatus
ffffffffc02020ac:	8b89                	andi	a5,a5,2
ffffffffc02020ae:	efd5                	bnez	a5,ffffffffc020216a <get_pte+0x1ae>
        page = pmm_manager->alloc_pages(n);
ffffffffc02020b0:	0009d797          	auipc	a5,0x9d
ffffffffc02020b4:	d787b783          	ld	a5,-648(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc02020b8:	6f9c                	ld	a5,24(a5)
ffffffffc02020ba:	4505                	li	a0,1
ffffffffc02020bc:	9782                	jalr	a5
ffffffffc02020be:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02020c0:	c4d1                	beqz	s1,ffffffffc020214c <get_pte+0x190>
    page->ref = val;
ffffffffc02020c2:	e05a                	sd	s6,0(sp)
    return page - pages + nbase;
ffffffffc02020c4:	0009db17          	auipc	s6,0x9d
ffffffffc02020c8:	d8cb0b13          	addi	s6,s6,-628 # ffffffffc029ee50 <pages>
ffffffffc02020cc:	000b3683          	ld	a3,0(s6)
ffffffffc02020d0:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02020d4:	0009b703          	ld	a4,0(s3)
ffffffffc02020d8:	40d486b3          	sub	a3,s1,a3
ffffffffc02020dc:	8699                	srai	a3,a3,0x6
ffffffffc02020de:	96d2                	add	a3,a3,s4
ffffffffc02020e0:	00c69793          	slli	a5,a3,0xc
    page->ref = val;
ffffffffc02020e4:	4605                	li	a2,1
ffffffffc02020e6:	c090                	sw	a2,0(s1)
ffffffffc02020e8:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02020ea:	06b2                	slli	a3,a3,0xc
ffffffffc02020ec:	0ee7f363          	bgeu	a5,a4,ffffffffc02021d2 <get_pte+0x216>
ffffffffc02020f0:	000ab503          	ld	a0,0(s5)
ffffffffc02020f4:	6605                	lui	a2,0x1
ffffffffc02020f6:	4581                	li	a1,0
ffffffffc02020f8:	9536                	add	a0,a0,a3
ffffffffc02020fa:	14b030ef          	jal	ffffffffc0205a44 <memset>
    return page - pages + nbase;
ffffffffc02020fe:	000b3783          	ld	a5,0(s6)
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202102:	6b02                	ld	s6,0(sp)
ffffffffc0202104:	40f486b3          	sub	a3,s1,a5
ffffffffc0202108:	8699                	srai	a3,a3,0x6
ffffffffc020210a:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020210c:	06aa                	slli	a3,a3,0xa
ffffffffc020210e:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202112:	e014                	sd	a3,0(s0)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202114:	0009b703          	ld	a4,0(s3)
ffffffffc0202118:	77fd                	lui	a5,0xfffff
ffffffffc020211a:	068a                	slli	a3,a3,0x2
ffffffffc020211c:	8efd                	and	a3,a3,a5
ffffffffc020211e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202122:	06e7f163          	bgeu	a5,a4,ffffffffc0202184 <get_pte+0x1c8>
ffffffffc0202126:	000ab783          	ld	a5,0(s5)
ffffffffc020212a:	00c95913          	srli	s2,s2,0xc
ffffffffc020212e:	1ff97913          	andi	s2,s2,511
ffffffffc0202132:	96be                	add	a3,a3,a5
ffffffffc0202134:	090e                	slli	s2,s2,0x3
ffffffffc0202136:	01268533          	add	a0,a3,s2
}
ffffffffc020213a:	70e2                	ld	ra,56(sp)
ffffffffc020213c:	7442                	ld	s0,48(sp)
ffffffffc020213e:	74a2                	ld	s1,40(sp)
ffffffffc0202140:	7902                	ld	s2,32(sp)
ffffffffc0202142:	69e2                	ld	s3,24(sp)
ffffffffc0202144:	6a42                	ld	s4,16(sp)
ffffffffc0202146:	6aa2                	ld	s5,8(sp)
ffffffffc0202148:	6121                	addi	sp,sp,64
ffffffffc020214a:	8082                	ret
            return NULL;
ffffffffc020214c:	4501                	li	a0,0
ffffffffc020214e:	b7f5                	j	ffffffffc020213a <get_pte+0x17e>
        intr_disable();
ffffffffc0202150:	82bfe0ef          	jal	ffffffffc020097a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202154:	0009d797          	auipc	a5,0x9d
ffffffffc0202158:	cd47b783          	ld	a5,-812(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc020215c:	6f9c                	ld	a5,24(a5)
ffffffffc020215e:	4505                	li	a0,1
ffffffffc0202160:	9782                	jalr	a5
ffffffffc0202162:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202164:	811fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202168:	b555                	j	ffffffffc020200c <get_pte+0x50>
        intr_disable();
ffffffffc020216a:	811fe0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc020216e:	0009d797          	auipc	a5,0x9d
ffffffffc0202172:	cba7b783          	ld	a5,-838(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc0202176:	6f9c                	ld	a5,24(a5)
ffffffffc0202178:	4505                	li	a0,1
ffffffffc020217a:	9782                	jalr	a5
ffffffffc020217c:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc020217e:	ff6fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202182:	bf3d                	j	ffffffffc02020c0 <get_pte+0x104>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202184:	00004617          	auipc	a2,0x4
ffffffffc0202188:	6bc60613          	addi	a2,a2,1724 # ffffffffc0206840 <etext+0xdd2>
ffffffffc020218c:	0fa00593          	li	a1,250
ffffffffc0202190:	00004517          	auipc	a0,0x4
ffffffffc0202194:	7c850513          	addi	a0,a0,1992 # ffffffffc0206958 <etext+0xeea>
ffffffffc0202198:	e05a                	sd	s6,0(sp)
ffffffffc020219a:	aeefe0ef          	jal	ffffffffc0200488 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020219e:	00004617          	auipc	a2,0x4
ffffffffc02021a2:	6a260613          	addi	a2,a2,1698 # ffffffffc0206840 <etext+0xdd2>
ffffffffc02021a6:	0ed00593          	li	a1,237
ffffffffc02021aa:	00004517          	auipc	a0,0x4
ffffffffc02021ae:	7ae50513          	addi	a0,a0,1966 # ffffffffc0206958 <etext+0xeea>
ffffffffc02021b2:	e05a                	sd	s6,0(sp)
ffffffffc02021b4:	ad4fe0ef          	jal	ffffffffc0200488 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02021b8:	86aa                	mv	a3,a0
ffffffffc02021ba:	00004617          	auipc	a2,0x4
ffffffffc02021be:	68660613          	addi	a2,a2,1670 # ffffffffc0206840 <etext+0xdd2>
ffffffffc02021c2:	0e900593          	li	a1,233
ffffffffc02021c6:	00004517          	auipc	a0,0x4
ffffffffc02021ca:	79250513          	addi	a0,a0,1938 # ffffffffc0206958 <etext+0xeea>
ffffffffc02021ce:	abafe0ef          	jal	ffffffffc0200488 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02021d2:	00004617          	auipc	a2,0x4
ffffffffc02021d6:	66e60613          	addi	a2,a2,1646 # ffffffffc0206840 <etext+0xdd2>
ffffffffc02021da:	0f700593          	li	a1,247
ffffffffc02021de:	00004517          	auipc	a0,0x4
ffffffffc02021e2:	77a50513          	addi	a0,a0,1914 # ffffffffc0206958 <etext+0xeea>
ffffffffc02021e6:	aa2fe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02021ea <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc02021ea:	1141                	addi	sp,sp,-16
ffffffffc02021ec:	e022                	sd	s0,0(sp)
ffffffffc02021ee:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02021f0:	4601                	li	a2,0
{
ffffffffc02021f2:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02021f4:	dc9ff0ef          	jal	ffffffffc0201fbc <get_pte>
    if (ptep_store != NULL)
ffffffffc02021f8:	c011                	beqz	s0,ffffffffc02021fc <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc02021fa:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02021fc:	c511                	beqz	a0,ffffffffc0202208 <get_page+0x1e>
ffffffffc02021fe:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0202200:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202202:	0017f713          	andi	a4,a5,1
ffffffffc0202206:	e709                	bnez	a4,ffffffffc0202210 <get_page+0x26>
}
ffffffffc0202208:	60a2                	ld	ra,8(sp)
ffffffffc020220a:	6402                	ld	s0,0(sp)
ffffffffc020220c:	0141                	addi	sp,sp,16
ffffffffc020220e:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202210:	078a                	slli	a5,a5,0x2
ffffffffc0202212:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202214:	0009d717          	auipc	a4,0x9d
ffffffffc0202218:	c3473703          	ld	a4,-972(a4) # ffffffffc029ee48 <npage>
ffffffffc020221c:	00e7ff63          	bgeu	a5,a4,ffffffffc020223a <get_page+0x50>
ffffffffc0202220:	60a2                	ld	ra,8(sp)
ffffffffc0202222:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc0202224:	fff80737          	lui	a4,0xfff80
ffffffffc0202228:	97ba                	add	a5,a5,a4
ffffffffc020222a:	0009d517          	auipc	a0,0x9d
ffffffffc020222e:	c2653503          	ld	a0,-986(a0) # ffffffffc029ee50 <pages>
ffffffffc0202232:	079a                	slli	a5,a5,0x6
ffffffffc0202234:	953e                	add	a0,a0,a5
ffffffffc0202236:	0141                	addi	sp,sp,16
ffffffffc0202238:	8082                	ret
ffffffffc020223a:	c93ff0ef          	jal	ffffffffc0201ecc <pa2page.part.0>

ffffffffc020223e <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc020223e:	715d                	addi	sp,sp,-80
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202240:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202244:	e486                	sd	ra,72(sp)
ffffffffc0202246:	e0a2                	sd	s0,64(sp)
ffffffffc0202248:	fc26                	sd	s1,56(sp)
ffffffffc020224a:	f84a                	sd	s2,48(sp)
ffffffffc020224c:	f44e                	sd	s3,40(sp)
ffffffffc020224e:	f052                	sd	s4,32(sp)
ffffffffc0202250:	ec56                	sd	s5,24(sp)
ffffffffc0202252:	e85a                	sd	s6,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202254:	17d2                	slli	a5,a5,0x34
ffffffffc0202256:	e7f9                	bnez	a5,ffffffffc0202324 <unmap_range+0xe6>
    assert(USER_ACCESS(start, end));
ffffffffc0202258:	002007b7          	lui	a5,0x200
ffffffffc020225c:	842e                	mv	s0,a1
ffffffffc020225e:	0ef5e363          	bltu	a1,a5,ffffffffc0202344 <unmap_range+0x106>
ffffffffc0202262:	8932                	mv	s2,a2
ffffffffc0202264:	0ec5f063          	bgeu	a1,a2,ffffffffc0202344 <unmap_range+0x106>
ffffffffc0202268:	4785                	li	a5,1
ffffffffc020226a:	07fe                	slli	a5,a5,0x1f
ffffffffc020226c:	0cc7ec63          	bltu	a5,a2,ffffffffc0202344 <unmap_range+0x106>
ffffffffc0202270:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc0202272:	6a05                	lui	s4,0x1
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202274:	00200b37          	lui	s6,0x200
ffffffffc0202278:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc020227c:	4601                	li	a2,0
ffffffffc020227e:	85a2                	mv	a1,s0
ffffffffc0202280:	854e                	mv	a0,s3
ffffffffc0202282:	d3bff0ef          	jal	ffffffffc0201fbc <get_pte>
ffffffffc0202286:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc0202288:	c125                	beqz	a0,ffffffffc02022e8 <unmap_range+0xaa>
        if (*ptep != 0)
ffffffffc020228a:	611c                	ld	a5,0(a0)
ffffffffc020228c:	ef99                	bnez	a5,ffffffffc02022aa <unmap_range+0x6c>
        start += PGSIZE;
ffffffffc020228e:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202290:	c019                	beqz	s0,ffffffffc0202296 <unmap_range+0x58>
ffffffffc0202292:	ff2465e3          	bltu	s0,s2,ffffffffc020227c <unmap_range+0x3e>
}
ffffffffc0202296:	60a6                	ld	ra,72(sp)
ffffffffc0202298:	6406                	ld	s0,64(sp)
ffffffffc020229a:	74e2                	ld	s1,56(sp)
ffffffffc020229c:	7942                	ld	s2,48(sp)
ffffffffc020229e:	79a2                	ld	s3,40(sp)
ffffffffc02022a0:	7a02                	ld	s4,32(sp)
ffffffffc02022a2:	6ae2                	ld	s5,24(sp)
ffffffffc02022a4:	6b42                	ld	s6,16(sp)
ffffffffc02022a6:	6161                	addi	sp,sp,80
ffffffffc02022a8:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc02022aa:	0017f713          	andi	a4,a5,1
ffffffffc02022ae:	d365                	beqz	a4,ffffffffc020228e <unmap_range+0x50>
    return pa2page(PTE_ADDR(pte));
ffffffffc02022b0:	078a                	slli	a5,a5,0x2
ffffffffc02022b2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02022b4:	0009d717          	auipc	a4,0x9d
ffffffffc02022b8:	b9473703          	ld	a4,-1132(a4) # ffffffffc029ee48 <npage>
ffffffffc02022bc:	0ae7f463          	bgeu	a5,a4,ffffffffc0202364 <unmap_range+0x126>
    return &pages[PPN(pa) - nbase];
ffffffffc02022c0:	fff80737          	lui	a4,0xfff80
ffffffffc02022c4:	97ba                	add	a5,a5,a4
ffffffffc02022c6:	079a                	slli	a5,a5,0x6
ffffffffc02022c8:	0009d517          	auipc	a0,0x9d
ffffffffc02022cc:	b8853503          	ld	a0,-1144(a0) # ffffffffc029ee50 <pages>
ffffffffc02022d0:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02022d2:	411c                	lw	a5,0(a0)
ffffffffc02022d4:	fff7871b          	addiw	a4,a5,-1 # 1fffff <_binary_obj___user_exit_out_size+0x1f64f7>
ffffffffc02022d8:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc02022da:	cb19                	beqz	a4,ffffffffc02022f0 <unmap_range+0xb2>
        *ptep = 0;
ffffffffc02022dc:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02022e0:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc02022e4:	9452                	add	s0,s0,s4
ffffffffc02022e6:	b76d                	j	ffffffffc0202290 <unmap_range+0x52>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02022e8:	945a                	add	s0,s0,s6
ffffffffc02022ea:	01547433          	and	s0,s0,s5
            continue;
ffffffffc02022ee:	b74d                	j	ffffffffc0202290 <unmap_range+0x52>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02022f0:	100027f3          	csrr	a5,sstatus
ffffffffc02022f4:	8b89                	andi	a5,a5,2
ffffffffc02022f6:	eb89                	bnez	a5,ffffffffc0202308 <unmap_range+0xca>
        pmm_manager->free_pages(base, n);
ffffffffc02022f8:	0009d797          	auipc	a5,0x9d
ffffffffc02022fc:	b307b783          	ld	a5,-1232(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc0202300:	739c                	ld	a5,32(a5)
ffffffffc0202302:	4585                	li	a1,1
ffffffffc0202304:	9782                	jalr	a5
    if (flag)
ffffffffc0202306:	bfd9                	j	ffffffffc02022dc <unmap_range+0x9e>
        intr_disable();
ffffffffc0202308:	e42a                	sd	a0,8(sp)
ffffffffc020230a:	e70fe0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc020230e:	0009d797          	auipc	a5,0x9d
ffffffffc0202312:	b1a7b783          	ld	a5,-1254(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc0202316:	739c                	ld	a5,32(a5)
ffffffffc0202318:	6522                	ld	a0,8(sp)
ffffffffc020231a:	4585                	li	a1,1
ffffffffc020231c:	9782                	jalr	a5
        intr_enable();
ffffffffc020231e:	e56fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202322:	bf6d                	j	ffffffffc02022dc <unmap_range+0x9e>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202324:	00004697          	auipc	a3,0x4
ffffffffc0202328:	64468693          	addi	a3,a3,1604 # ffffffffc0206968 <etext+0xefa>
ffffffffc020232c:	00004617          	auipc	a2,0x4
ffffffffc0202330:	16460613          	addi	a2,a2,356 # ffffffffc0206490 <etext+0xa22>
ffffffffc0202334:	12000593          	li	a1,288
ffffffffc0202338:	00004517          	auipc	a0,0x4
ffffffffc020233c:	62050513          	addi	a0,a0,1568 # ffffffffc0206958 <etext+0xeea>
ffffffffc0202340:	948fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202344:	00004697          	auipc	a3,0x4
ffffffffc0202348:	65468693          	addi	a3,a3,1620 # ffffffffc0206998 <etext+0xf2a>
ffffffffc020234c:	00004617          	auipc	a2,0x4
ffffffffc0202350:	14460613          	addi	a2,a2,324 # ffffffffc0206490 <etext+0xa22>
ffffffffc0202354:	12100593          	li	a1,289
ffffffffc0202358:	00004517          	auipc	a0,0x4
ffffffffc020235c:	60050513          	addi	a0,a0,1536 # ffffffffc0206958 <etext+0xeea>
ffffffffc0202360:	928fe0ef          	jal	ffffffffc0200488 <__panic>
ffffffffc0202364:	b69ff0ef          	jal	ffffffffc0201ecc <pa2page.part.0>

ffffffffc0202368 <exit_range>:
{
ffffffffc0202368:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020236a:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020236e:	fc86                	sd	ra,120(sp)
ffffffffc0202370:	f8a2                	sd	s0,112(sp)
ffffffffc0202372:	f4a6                	sd	s1,104(sp)
ffffffffc0202374:	f0ca                	sd	s2,96(sp)
ffffffffc0202376:	ecce                	sd	s3,88(sp)
ffffffffc0202378:	e8d2                	sd	s4,80(sp)
ffffffffc020237a:	e4d6                	sd	s5,72(sp)
ffffffffc020237c:	e0da                	sd	s6,64(sp)
ffffffffc020237e:	fc5e                	sd	s7,56(sp)
ffffffffc0202380:	f862                	sd	s8,48(sp)
ffffffffc0202382:	f466                	sd	s9,40(sp)
ffffffffc0202384:	f06a                	sd	s10,32(sp)
ffffffffc0202386:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202388:	17d2                	slli	a5,a5,0x34
ffffffffc020238a:	24079163          	bnez	a5,ffffffffc02025cc <exit_range+0x264>
    assert(USER_ACCESS(start, end));
ffffffffc020238e:	002007b7          	lui	a5,0x200
ffffffffc0202392:	28f5e863          	bltu	a1,a5,ffffffffc0202622 <exit_range+0x2ba>
ffffffffc0202396:	8b32                	mv	s6,a2
ffffffffc0202398:	28c5f563          	bgeu	a1,a2,ffffffffc0202622 <exit_range+0x2ba>
ffffffffc020239c:	4785                	li	a5,1
ffffffffc020239e:	07fe                	slli	a5,a5,0x1f
ffffffffc02023a0:	28c7e163          	bltu	a5,a2,ffffffffc0202622 <exit_range+0x2ba>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02023a4:	c0000a37          	lui	s4,0xc0000
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc02023a8:	ffe007b7          	lui	a5,0xffe00
ffffffffc02023ac:	8d2a                	mv	s10,a0
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02023ae:	0145fa33          	and	s4,a1,s4
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc02023b2:	00f5f4b3          	and	s1,a1,a5
        d1start += PDSIZE;
ffffffffc02023b6:	40000db7          	lui	s11,0x40000
    if (PPN(pa) >= npage)
ffffffffc02023ba:	0009d617          	auipc	a2,0x9d
ffffffffc02023be:	a8e60613          	addi	a2,a2,-1394 # ffffffffc029ee48 <npage>
    return KADDR(page2pa(page));
ffffffffc02023c2:	0009d817          	auipc	a6,0x9d
ffffffffc02023c6:	a7e80813          	addi	a6,a6,-1410 # ffffffffc029ee40 <va_pa_offset>
    return &pages[PPN(pa) - nbase];
ffffffffc02023ca:	0009de97          	auipc	t4,0x9d
ffffffffc02023ce:	a86e8e93          	addi	t4,t4,-1402 # ffffffffc029ee50 <pages>
                d0start += PTSIZE;
ffffffffc02023d2:	00200c37          	lui	s8,0x200
ffffffffc02023d6:	a819                	j	ffffffffc02023ec <exit_range+0x84>
        d1start += PDSIZE;
ffffffffc02023d8:	01ba09b3          	add	s3,s4,s11
    } while (d1start != 0 && d1start < end);
ffffffffc02023dc:	14098763          	beqz	s3,ffffffffc020252a <exit_range+0x1c2>
        d1start += PDSIZE;
ffffffffc02023e0:	40000a37          	lui	s4,0x40000
        d0start = d1start;
ffffffffc02023e4:	400004b7          	lui	s1,0x40000
    } while (d1start != 0 && d1start < end);
ffffffffc02023e8:	1569f163          	bgeu	s3,s6,ffffffffc020252a <exit_range+0x1c2>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc02023ec:	01ea5913          	srli	s2,s4,0x1e
ffffffffc02023f0:	1ff97913          	andi	s2,s2,511
ffffffffc02023f4:	090e                	slli	s2,s2,0x3
ffffffffc02023f6:	996a                	add	s2,s2,s10
ffffffffc02023f8:	00093a83          	ld	s5,0(s2) # 1000 <_binary_obj___user_softint_out_size-0x7598>
        if (pde1 & PTE_V)
ffffffffc02023fc:	001af793          	andi	a5,s5,1
ffffffffc0202400:	dfe1                	beqz	a5,ffffffffc02023d8 <exit_range+0x70>
    if (PPN(pa) >= npage)
ffffffffc0202402:	6214                	ld	a3,0(a2)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202404:	0a8a                	slli	s5,s5,0x2
ffffffffc0202406:	00cada93          	srli	s5,s5,0xc
    if (PPN(pa) >= npage)
ffffffffc020240a:	20dafa63          	bgeu	s5,a3,ffffffffc020261e <exit_range+0x2b6>
    return &pages[PPN(pa) - nbase];
ffffffffc020240e:	fff80737          	lui	a4,0xfff80
ffffffffc0202412:	9756                	add	a4,a4,s5
    return page - pages + nbase;
ffffffffc0202414:	000807b7          	lui	a5,0x80
ffffffffc0202418:	97ba                	add	a5,a5,a4
    return page2ppn(page) << PGSHIFT;
ffffffffc020241a:	00c79b93          	slli	s7,a5,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc020241e:	071a                	slli	a4,a4,0x6
    return KADDR(page2pa(page));
ffffffffc0202420:	1ed7f263          	bgeu	a5,a3,ffffffffc0202604 <exit_range+0x29c>
ffffffffc0202424:	00083783          	ld	a5,0(a6)
            free_pd0 = 1;
ffffffffc0202428:	4c85                	li	s9,1
    return &pages[PPN(pa) - nbase];
ffffffffc020242a:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc020242e:	9bbe                	add	s7,s7,a5
    return page - pages + nbase;
ffffffffc0202430:	00080337          	lui	t1,0x80
ffffffffc0202434:	6885                	lui	a7,0x1
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202436:	01ba09b3          	add	s3,s4,s11
ffffffffc020243a:	a801                	j	ffffffffc020244a <exit_range+0xe2>
                    free_pd0 = 0;
ffffffffc020243c:	4c81                	li	s9,0
                d0start += PTSIZE;
ffffffffc020243e:	94e2                	add	s1,s1,s8
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202440:	ccd1                	beqz	s1,ffffffffc02024dc <exit_range+0x174>
ffffffffc0202442:	0934fd63          	bgeu	s1,s3,ffffffffc02024dc <exit_range+0x174>
ffffffffc0202446:	1164f163          	bgeu	s1,s6,ffffffffc0202548 <exit_range+0x1e0>
                pde0 = pd0[PDX0(d0start)];
ffffffffc020244a:	0154d413          	srli	s0,s1,0x15
ffffffffc020244e:	1ff47413          	andi	s0,s0,511
ffffffffc0202452:	040e                	slli	s0,s0,0x3
ffffffffc0202454:	945e                	add	s0,s0,s7
ffffffffc0202456:	601c                	ld	a5,0(s0)
                if (pde0 & PTE_V)
ffffffffc0202458:	0017f693          	andi	a3,a5,1
ffffffffc020245c:	d2e5                	beqz	a3,ffffffffc020243c <exit_range+0xd4>
    if (PPN(pa) >= npage)
ffffffffc020245e:	00063f03          	ld	t5,0(a2)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202462:	078a                	slli	a5,a5,0x2
ffffffffc0202464:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202466:	1be7fc63          	bgeu	a5,t5,ffffffffc020261e <exit_range+0x2b6>
    return &pages[PPN(pa) - nbase];
ffffffffc020246a:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc020246c:	00678fb3          	add	t6,a5,t1
    return &pages[PPN(pa) - nbase];
ffffffffc0202470:	000eb503          	ld	a0,0(t4)
ffffffffc0202474:	00679593          	slli	a1,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202478:	00cf9693          	slli	a3,t6,0xc
    return KADDR(page2pa(page));
ffffffffc020247c:	17eff863          	bgeu	t6,t5,ffffffffc02025ec <exit_range+0x284>
ffffffffc0202480:	00083783          	ld	a5,0(a6)
ffffffffc0202484:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202486:	01168f33          	add	t5,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc020248a:	629c                	ld	a5,0(a3)
ffffffffc020248c:	8b85                	andi	a5,a5,1
ffffffffc020248e:	fbc5                	bnez	a5,ffffffffc020243e <exit_range+0xd6>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202490:	06a1                	addi	a3,a3,8
ffffffffc0202492:	ffe69ce3          	bne	a3,t5,ffffffffc020248a <exit_range+0x122>
    return &pages[PPN(pa) - nbase];
ffffffffc0202496:	952e                	add	a0,a0,a1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202498:	100027f3          	csrr	a5,sstatus
ffffffffc020249c:	8b89                	andi	a5,a5,2
ffffffffc020249e:	ebc5                	bnez	a5,ffffffffc020254e <exit_range+0x1e6>
        pmm_manager->free_pages(base, n);
ffffffffc02024a0:	0009d797          	auipc	a5,0x9d
ffffffffc02024a4:	9887b783          	ld	a5,-1656(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc02024a8:	739c                	ld	a5,32(a5)
ffffffffc02024aa:	4585                	li	a1,1
ffffffffc02024ac:	e03a                	sd	a4,0(sp)
ffffffffc02024ae:	9782                	jalr	a5
    if (flag)
ffffffffc02024b0:	6702                	ld	a4,0(sp)
ffffffffc02024b2:	fff80e37          	lui	t3,0xfff80
ffffffffc02024b6:	00080337          	lui	t1,0x80
ffffffffc02024ba:	6885                	lui	a7,0x1
ffffffffc02024bc:	0009d617          	auipc	a2,0x9d
ffffffffc02024c0:	98c60613          	addi	a2,a2,-1652 # ffffffffc029ee48 <npage>
ffffffffc02024c4:	0009d817          	auipc	a6,0x9d
ffffffffc02024c8:	97c80813          	addi	a6,a6,-1668 # ffffffffc029ee40 <va_pa_offset>
ffffffffc02024cc:	0009de97          	auipc	t4,0x9d
ffffffffc02024d0:	984e8e93          	addi	t4,t4,-1660 # ffffffffc029ee50 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc02024d4:	00043023          	sd	zero,0(s0)
                d0start += PTSIZE;
ffffffffc02024d8:	94e2                	add	s1,s1,s8
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02024da:	f4a5                	bnez	s1,ffffffffc0202442 <exit_range+0xda>
            if (free_pd0)
ffffffffc02024dc:	ee0c8ee3          	beqz	s9,ffffffffc02023d8 <exit_range+0x70>
    if (PPN(pa) >= npage)
ffffffffc02024e0:	621c                	ld	a5,0(a2)
ffffffffc02024e2:	12fafe63          	bgeu	s5,a5,ffffffffc020261e <exit_range+0x2b6>
    return &pages[PPN(pa) - nbase];
ffffffffc02024e6:	0009d517          	auipc	a0,0x9d
ffffffffc02024ea:	96a53503          	ld	a0,-1686(a0) # ffffffffc029ee50 <pages>
ffffffffc02024ee:	953a                	add	a0,a0,a4
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02024f0:	100027f3          	csrr	a5,sstatus
ffffffffc02024f4:	8b89                	andi	a5,a5,2
ffffffffc02024f6:	efd9                	bnez	a5,ffffffffc0202594 <exit_range+0x22c>
        pmm_manager->free_pages(base, n);
ffffffffc02024f8:	0009d797          	auipc	a5,0x9d
ffffffffc02024fc:	9307b783          	ld	a5,-1744(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc0202500:	739c                	ld	a5,32(a5)
ffffffffc0202502:	4585                	li	a1,1
ffffffffc0202504:	9782                	jalr	a5
ffffffffc0202506:	0009de97          	auipc	t4,0x9d
ffffffffc020250a:	94ae8e93          	addi	t4,t4,-1718 # ffffffffc029ee50 <pages>
ffffffffc020250e:	0009d817          	auipc	a6,0x9d
ffffffffc0202512:	93280813          	addi	a6,a6,-1742 # ffffffffc029ee40 <va_pa_offset>
ffffffffc0202516:	0009d617          	auipc	a2,0x9d
ffffffffc020251a:	93260613          	addi	a2,a2,-1742 # ffffffffc029ee48 <npage>
                pgdir[PDX1(d1start)] = 0;
ffffffffc020251e:	00093023          	sd	zero,0(s2)
        d1start += PDSIZE;
ffffffffc0202522:	01ba09b3          	add	s3,s4,s11
    } while (d1start != 0 && d1start < end);
ffffffffc0202526:	ea099de3          	bnez	s3,ffffffffc02023e0 <exit_range+0x78>
}
ffffffffc020252a:	70e6                	ld	ra,120(sp)
ffffffffc020252c:	7446                	ld	s0,112(sp)
ffffffffc020252e:	74a6                	ld	s1,104(sp)
ffffffffc0202530:	7906                	ld	s2,96(sp)
ffffffffc0202532:	69e6                	ld	s3,88(sp)
ffffffffc0202534:	6a46                	ld	s4,80(sp)
ffffffffc0202536:	6aa6                	ld	s5,72(sp)
ffffffffc0202538:	6b06                	ld	s6,64(sp)
ffffffffc020253a:	7be2                	ld	s7,56(sp)
ffffffffc020253c:	7c42                	ld	s8,48(sp)
ffffffffc020253e:	7ca2                	ld	s9,40(sp)
ffffffffc0202540:	7d02                	ld	s10,32(sp)
ffffffffc0202542:	6de2                	ld	s11,24(sp)
ffffffffc0202544:	6109                	addi	sp,sp,128
ffffffffc0202546:	8082                	ret
            if (free_pd0)
ffffffffc0202548:	e80c8ce3          	beqz	s9,ffffffffc02023e0 <exit_range+0x78>
ffffffffc020254c:	bf51                	j	ffffffffc02024e0 <exit_range+0x178>
        intr_disable();
ffffffffc020254e:	e03a                	sd	a4,0(sp)
ffffffffc0202550:	e42a                	sd	a0,8(sp)
ffffffffc0202552:	c28fe0ef          	jal	ffffffffc020097a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202556:	0009d797          	auipc	a5,0x9d
ffffffffc020255a:	8d27b783          	ld	a5,-1838(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc020255e:	739c                	ld	a5,32(a5)
ffffffffc0202560:	6522                	ld	a0,8(sp)
ffffffffc0202562:	4585                	li	a1,1
ffffffffc0202564:	9782                	jalr	a5
        intr_enable();
ffffffffc0202566:	c0efe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc020256a:	6702                	ld	a4,0(sp)
ffffffffc020256c:	0009de97          	auipc	t4,0x9d
ffffffffc0202570:	8e4e8e93          	addi	t4,t4,-1820 # ffffffffc029ee50 <pages>
ffffffffc0202574:	0009d817          	auipc	a6,0x9d
ffffffffc0202578:	8cc80813          	addi	a6,a6,-1844 # ffffffffc029ee40 <va_pa_offset>
ffffffffc020257c:	0009d617          	auipc	a2,0x9d
ffffffffc0202580:	8cc60613          	addi	a2,a2,-1844 # ffffffffc029ee48 <npage>
ffffffffc0202584:	6885                	lui	a7,0x1
ffffffffc0202586:	00080337          	lui	t1,0x80
ffffffffc020258a:	fff80e37          	lui	t3,0xfff80
                        pd0[PDX0(d0start)] = 0;
ffffffffc020258e:	00043023          	sd	zero,0(s0)
ffffffffc0202592:	b799                	j	ffffffffc02024d8 <exit_range+0x170>
        intr_disable();
ffffffffc0202594:	e02a                	sd	a0,0(sp)
ffffffffc0202596:	be4fe0ef          	jal	ffffffffc020097a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020259a:	0009d797          	auipc	a5,0x9d
ffffffffc020259e:	88e7b783          	ld	a5,-1906(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc02025a2:	739c                	ld	a5,32(a5)
ffffffffc02025a4:	6502                	ld	a0,0(sp)
ffffffffc02025a6:	4585                	li	a1,1
ffffffffc02025a8:	9782                	jalr	a5
        intr_enable();
ffffffffc02025aa:	bcafe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc02025ae:	0009d617          	auipc	a2,0x9d
ffffffffc02025b2:	89a60613          	addi	a2,a2,-1894 # ffffffffc029ee48 <npage>
ffffffffc02025b6:	0009d817          	auipc	a6,0x9d
ffffffffc02025ba:	88a80813          	addi	a6,a6,-1910 # ffffffffc029ee40 <va_pa_offset>
ffffffffc02025be:	0009de97          	auipc	t4,0x9d
ffffffffc02025c2:	892e8e93          	addi	t4,t4,-1902 # ffffffffc029ee50 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02025c6:	00093023          	sd	zero,0(s2)
ffffffffc02025ca:	bfa1                	j	ffffffffc0202522 <exit_range+0x1ba>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02025cc:	00004697          	auipc	a3,0x4
ffffffffc02025d0:	39c68693          	addi	a3,a3,924 # ffffffffc0206968 <etext+0xefa>
ffffffffc02025d4:	00004617          	auipc	a2,0x4
ffffffffc02025d8:	ebc60613          	addi	a2,a2,-324 # ffffffffc0206490 <etext+0xa22>
ffffffffc02025dc:	13500593          	li	a1,309
ffffffffc02025e0:	00004517          	auipc	a0,0x4
ffffffffc02025e4:	37850513          	addi	a0,a0,888 # ffffffffc0206958 <etext+0xeea>
ffffffffc02025e8:	ea1fd0ef          	jal	ffffffffc0200488 <__panic>
    return KADDR(page2pa(page));
ffffffffc02025ec:	00004617          	auipc	a2,0x4
ffffffffc02025f0:	25460613          	addi	a2,a2,596 # ffffffffc0206840 <etext+0xdd2>
ffffffffc02025f4:	07100593          	li	a1,113
ffffffffc02025f8:	00004517          	auipc	a0,0x4
ffffffffc02025fc:	27050513          	addi	a0,a0,624 # ffffffffc0206868 <etext+0xdfa>
ffffffffc0202600:	e89fd0ef          	jal	ffffffffc0200488 <__panic>
ffffffffc0202604:	86de                	mv	a3,s7
ffffffffc0202606:	00004617          	auipc	a2,0x4
ffffffffc020260a:	23a60613          	addi	a2,a2,570 # ffffffffc0206840 <etext+0xdd2>
ffffffffc020260e:	07100593          	li	a1,113
ffffffffc0202612:	00004517          	auipc	a0,0x4
ffffffffc0202616:	25650513          	addi	a0,a0,598 # ffffffffc0206868 <etext+0xdfa>
ffffffffc020261a:	e6ffd0ef          	jal	ffffffffc0200488 <__panic>
ffffffffc020261e:	8afff0ef          	jal	ffffffffc0201ecc <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202622:	00004697          	auipc	a3,0x4
ffffffffc0202626:	37668693          	addi	a3,a3,886 # ffffffffc0206998 <etext+0xf2a>
ffffffffc020262a:	00004617          	auipc	a2,0x4
ffffffffc020262e:	e6660613          	addi	a2,a2,-410 # ffffffffc0206490 <etext+0xa22>
ffffffffc0202632:	13600593          	li	a1,310
ffffffffc0202636:	00004517          	auipc	a0,0x4
ffffffffc020263a:	32250513          	addi	a0,a0,802 # ffffffffc0206958 <etext+0xeea>
ffffffffc020263e:	e4bfd0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0202642 <copy_range>:
{
ffffffffc0202642:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202644:	00d667b3          	or	a5,a2,a3
{
ffffffffc0202648:	f486                	sd	ra,104(sp)
ffffffffc020264a:	f0a2                	sd	s0,96(sp)
ffffffffc020264c:	eca6                	sd	s1,88(sp)
ffffffffc020264e:	e8ca                	sd	s2,80(sp)
ffffffffc0202650:	e4ce                	sd	s3,72(sp)
ffffffffc0202652:	e0d2                	sd	s4,64(sp)
ffffffffc0202654:	fc56                	sd	s5,56(sp)
ffffffffc0202656:	f85a                	sd	s6,48(sp)
ffffffffc0202658:	f45e                	sd	s7,40(sp)
ffffffffc020265a:	f062                	sd	s8,32(sp)
ffffffffc020265c:	ec66                	sd	s9,24(sp)
ffffffffc020265e:	e86a                	sd	s10,16(sp)
ffffffffc0202660:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202662:	17d2                	slli	a5,a5,0x34
ffffffffc0202664:	12079b63          	bnez	a5,ffffffffc020279a <copy_range+0x158>
    assert(USER_ACCESS(start, end));
ffffffffc0202668:	002007b7          	lui	a5,0x200
ffffffffc020266c:	8432                	mv	s0,a2
ffffffffc020266e:	10f66663          	bltu	a2,a5,ffffffffc020277a <copy_range+0x138>
ffffffffc0202672:	8936                	mv	s2,a3
ffffffffc0202674:	10d67363          	bgeu	a2,a3,ffffffffc020277a <copy_range+0x138>
ffffffffc0202678:	4785                	li	a5,1
ffffffffc020267a:	07fe                	slli	a5,a5,0x1f
ffffffffc020267c:	0ed7ef63          	bltu	a5,a3,ffffffffc020277a <copy_range+0x138>
ffffffffc0202680:	8aaa                	mv	s5,a0
ffffffffc0202682:	89ae                	mv	s3,a1
ffffffffc0202684:	8b3a                	mv	s6,a4
        start += PGSIZE;
ffffffffc0202686:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc0202688:	0009cc97          	auipc	s9,0x9c
ffffffffc020268c:	7c0c8c93          	addi	s9,s9,1984 # ffffffffc029ee48 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202690:	0009cc17          	auipc	s8,0x9c
ffffffffc0202694:	7c0c0c13          	addi	s8,s8,1984 # ffffffffc029ee50 <pages>
ffffffffc0202698:	fff80bb7          	lui	s7,0xfff80
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc020269c:	00200db7          	lui	s11,0x200
ffffffffc02026a0:	ffe00d37          	lui	s10,0xffe00
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc02026a4:	4601                	li	a2,0
ffffffffc02026a6:	85a2                	mv	a1,s0
ffffffffc02026a8:	854e                	mv	a0,s3
ffffffffc02026aa:	913ff0ef          	jal	ffffffffc0201fbc <get_pte>
ffffffffc02026ae:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02026b0:	c15d                	beqz	a0,ffffffffc0202756 <copy_range+0x114>
        if (*ptep & PTE_V)
ffffffffc02026b2:	611c                	ld	a5,0(a0)
ffffffffc02026b4:	8b85                	andi	a5,a5,1
ffffffffc02026b6:	e78d                	bnez	a5,ffffffffc02026e0 <copy_range+0x9e>
        start += PGSIZE;
ffffffffc02026b8:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02026ba:	c019                	beqz	s0,ffffffffc02026c0 <copy_range+0x7e>
ffffffffc02026bc:	ff2464e3          	bltu	s0,s2,ffffffffc02026a4 <copy_range+0x62>
    return 0;
ffffffffc02026c0:	4501                	li	a0,0
}
ffffffffc02026c2:	70a6                	ld	ra,104(sp)
ffffffffc02026c4:	7406                	ld	s0,96(sp)
ffffffffc02026c6:	64e6                	ld	s1,88(sp)
ffffffffc02026c8:	6946                	ld	s2,80(sp)
ffffffffc02026ca:	69a6                	ld	s3,72(sp)
ffffffffc02026cc:	6a06                	ld	s4,64(sp)
ffffffffc02026ce:	7ae2                	ld	s5,56(sp)
ffffffffc02026d0:	7b42                	ld	s6,48(sp)
ffffffffc02026d2:	7ba2                	ld	s7,40(sp)
ffffffffc02026d4:	7c02                	ld	s8,32(sp)
ffffffffc02026d6:	6ce2                	ld	s9,24(sp)
ffffffffc02026d8:	6d42                	ld	s10,16(sp)
ffffffffc02026da:	6da2                	ld	s11,8(sp)
ffffffffc02026dc:	6165                	addi	sp,sp,112
ffffffffc02026de:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc02026e0:	4605                	li	a2,1
ffffffffc02026e2:	85a2                	mv	a1,s0
ffffffffc02026e4:	8556                	mv	a0,s5
ffffffffc02026e6:	8d7ff0ef          	jal	ffffffffc0201fbc <get_pte>
ffffffffc02026ea:	c935                	beqz	a0,ffffffffc020275e <copy_range+0x11c>
            struct Page *page = pte2page(*ptep);
ffffffffc02026ec:	6098                	ld	a4,0(s1)
    if (!(pte & PTE_V))
ffffffffc02026ee:	00177793          	andi	a5,a4,1
ffffffffc02026f2:	cba5                	beqz	a5,ffffffffc0202762 <copy_range+0x120>
    if (PPN(pa) >= npage)
ffffffffc02026f4:	000cb683          	ld	a3,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02026f8:	00271793          	slli	a5,a4,0x2
ffffffffc02026fc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02026fe:	0ad7fe63          	bgeu	a5,a3,ffffffffc02027ba <copy_range+0x178>
    return &pages[PPN(pa) - nbase];
ffffffffc0202702:	000c3603          	ld	a2,0(s8)
ffffffffc0202706:	97de                	add	a5,a5,s7
ffffffffc0202708:	079a                	slli	a5,a5,0x6
ffffffffc020270a:	97b2                	add	a5,a5,a2
    page->ref += 1;
ffffffffc020270c:	4394                	lw	a3,0(a5)
ffffffffc020270e:	2685                	addiw	a3,a3,1
            if (!share)
ffffffffc0202710:	020b1d63          	bnez	s6,ffffffffc020274a <copy_range+0x108>
                if (*ptep & PTE_W)
ffffffffc0202714:	00477593          	andi	a1,a4,4
ffffffffc0202718:	c98d                	beqz	a1,ffffffffc020274a <copy_range+0x108>
ffffffffc020271a:	c394                	sw	a3,0(a5)
ffffffffc020271c:	00878593          	addi	a1,a5,8 # 200008 <_binary_obj___user_exit_out_size+0x1f6500>
ffffffffc0202720:	4691                	li	a3,4
ffffffffc0202722:	40d5b02f          	amoor.d	zero,a3,(a1)
    return page - pages + nbase;
ffffffffc0202726:	8f91                	sub	a5,a5,a2
ffffffffc0202728:	000806b7          	lui	a3,0x80
ffffffffc020272c:	8799                	srai	a5,a5,0x6
ffffffffc020272e:	97b6                	add	a5,a5,a3
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202730:	8b6d                	andi	a4,a4,27
ffffffffc0202732:	07aa                	slli	a5,a5,0xa
ffffffffc0202734:	8fd9                	or	a5,a5,a4
ffffffffc0202736:	0017e793          	ori	a5,a5,1
                    *nptep = pte_create(page2ppn(page), perm);
ffffffffc020273a:	e11c                	sd	a5,0(a0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020273c:	12040073          	sfence.vma	s0
                    *ptep = pte_create(page2ppn(page), perm);
ffffffffc0202740:	e09c                	sd	a5,0(s1)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202742:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202746:	9452                	add	s0,s0,s4
ffffffffc0202748:	bf8d                	j	ffffffffc02026ba <copy_range+0x78>
                *nptep = *ptep;
ffffffffc020274a:	e118                	sd	a4,0(a0)
    page->ref += 1;
ffffffffc020274c:	c394                	sw	a3,0(a5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020274e:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202752:	9452                	add	s0,s0,s4
ffffffffc0202754:	b79d                	j	ffffffffc02026ba <copy_range+0x78>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202756:	946e                	add	s0,s0,s11
ffffffffc0202758:	01a47433          	and	s0,s0,s10
            continue;
ffffffffc020275c:	bfb9                	j	ffffffffc02026ba <copy_range+0x78>
                return -E_NO_MEM;
ffffffffc020275e:	5571                	li	a0,-4
ffffffffc0202760:	b78d                	j	ffffffffc02026c2 <copy_range+0x80>
        panic("pte2page called with invalid pte");
ffffffffc0202762:	00004617          	auipc	a2,0x4
ffffffffc0202766:	1ce60613          	addi	a2,a2,462 # ffffffffc0206930 <etext+0xec2>
ffffffffc020276a:	07f00593          	li	a1,127
ffffffffc020276e:	00004517          	auipc	a0,0x4
ffffffffc0202772:	0fa50513          	addi	a0,a0,250 # ffffffffc0206868 <etext+0xdfa>
ffffffffc0202776:	d13fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020277a:	00004697          	auipc	a3,0x4
ffffffffc020277e:	21e68693          	addi	a3,a3,542 # ffffffffc0206998 <etext+0xf2a>
ffffffffc0202782:	00004617          	auipc	a2,0x4
ffffffffc0202786:	d0e60613          	addi	a2,a2,-754 # ffffffffc0206490 <etext+0xa22>
ffffffffc020278a:	17c00593          	li	a1,380
ffffffffc020278e:	00004517          	auipc	a0,0x4
ffffffffc0202792:	1ca50513          	addi	a0,a0,458 # ffffffffc0206958 <etext+0xeea>
ffffffffc0202796:	cf3fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020279a:	00004697          	auipc	a3,0x4
ffffffffc020279e:	1ce68693          	addi	a3,a3,462 # ffffffffc0206968 <etext+0xefa>
ffffffffc02027a2:	00004617          	auipc	a2,0x4
ffffffffc02027a6:	cee60613          	addi	a2,a2,-786 # ffffffffc0206490 <etext+0xa22>
ffffffffc02027aa:	17b00593          	li	a1,379
ffffffffc02027ae:	00004517          	auipc	a0,0x4
ffffffffc02027b2:	1aa50513          	addi	a0,a0,426 # ffffffffc0206958 <etext+0xeea>
ffffffffc02027b6:	cd3fd0ef          	jal	ffffffffc0200488 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02027ba:	00004617          	auipc	a2,0x4
ffffffffc02027be:	15660613          	addi	a2,a2,342 # ffffffffc0206910 <etext+0xea2>
ffffffffc02027c2:	06900593          	li	a1,105
ffffffffc02027c6:	00004517          	auipc	a0,0x4
ffffffffc02027ca:	0a250513          	addi	a0,a0,162 # ffffffffc0206868 <etext+0xdfa>
ffffffffc02027ce:	cbbfd0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02027d2 <page_remove>:
{
ffffffffc02027d2:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02027d4:	4601                	li	a2,0
{
ffffffffc02027d6:	ec26                	sd	s1,24(sp)
ffffffffc02027d8:	f406                	sd	ra,40(sp)
ffffffffc02027da:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02027dc:	fe0ff0ef          	jal	ffffffffc0201fbc <get_pte>
    if (ptep != NULL)
ffffffffc02027e0:	c901                	beqz	a0,ffffffffc02027f0 <page_remove+0x1e>
    if (*ptep & PTE_V)
ffffffffc02027e2:	611c                	ld	a5,0(a0)
ffffffffc02027e4:	f022                	sd	s0,32(sp)
ffffffffc02027e6:	842a                	mv	s0,a0
ffffffffc02027e8:	0017f713          	andi	a4,a5,1
ffffffffc02027ec:	e711                	bnez	a4,ffffffffc02027f8 <page_remove+0x26>
ffffffffc02027ee:	7402                	ld	s0,32(sp)
}
ffffffffc02027f0:	70a2                	ld	ra,40(sp)
ffffffffc02027f2:	64e2                	ld	s1,24(sp)
ffffffffc02027f4:	6145                	addi	sp,sp,48
ffffffffc02027f6:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02027f8:	078a                	slli	a5,a5,0x2
ffffffffc02027fa:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02027fc:	0009c717          	auipc	a4,0x9c
ffffffffc0202800:	64c73703          	ld	a4,1612(a4) # ffffffffc029ee48 <npage>
ffffffffc0202804:	06e7f363          	bgeu	a5,a4,ffffffffc020286a <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202808:	fff80737          	lui	a4,0xfff80
ffffffffc020280c:	97ba                	add	a5,a5,a4
ffffffffc020280e:	079a                	slli	a5,a5,0x6
ffffffffc0202810:	0009c517          	auipc	a0,0x9c
ffffffffc0202814:	64053503          	ld	a0,1600(a0) # ffffffffc029ee50 <pages>
ffffffffc0202818:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020281a:	411c                	lw	a5,0(a0)
ffffffffc020281c:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202820:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202822:	cb11                	beqz	a4,ffffffffc0202836 <page_remove+0x64>
        *ptep = 0;
ffffffffc0202824:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202828:	12048073          	sfence.vma	s1
ffffffffc020282c:	7402                	ld	s0,32(sp)
}
ffffffffc020282e:	70a2                	ld	ra,40(sp)
ffffffffc0202830:	64e2                	ld	s1,24(sp)
ffffffffc0202832:	6145                	addi	sp,sp,48
ffffffffc0202834:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202836:	100027f3          	csrr	a5,sstatus
ffffffffc020283a:	8b89                	andi	a5,a5,2
ffffffffc020283c:	eb89                	bnez	a5,ffffffffc020284e <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc020283e:	0009c797          	auipc	a5,0x9c
ffffffffc0202842:	5ea7b783          	ld	a5,1514(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc0202846:	739c                	ld	a5,32(a5)
ffffffffc0202848:	4585                	li	a1,1
ffffffffc020284a:	9782                	jalr	a5
    if (flag)
ffffffffc020284c:	bfe1                	j	ffffffffc0202824 <page_remove+0x52>
        intr_disable();
ffffffffc020284e:	e42a                	sd	a0,8(sp)
ffffffffc0202850:	92afe0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc0202854:	0009c797          	auipc	a5,0x9c
ffffffffc0202858:	5d47b783          	ld	a5,1492(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc020285c:	739c                	ld	a5,32(a5)
ffffffffc020285e:	6522                	ld	a0,8(sp)
ffffffffc0202860:	4585                	li	a1,1
ffffffffc0202862:	9782                	jalr	a5
        intr_enable();
ffffffffc0202864:	910fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202868:	bf75                	j	ffffffffc0202824 <page_remove+0x52>
ffffffffc020286a:	e62ff0ef          	jal	ffffffffc0201ecc <pa2page.part.0>

ffffffffc020286e <page_insert>:
{
ffffffffc020286e:	7139                	addi	sp,sp,-64
ffffffffc0202870:	e852                	sd	s4,16(sp)
ffffffffc0202872:	8a32                	mv	s4,a2
ffffffffc0202874:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202876:	4605                	li	a2,1
{
ffffffffc0202878:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020287a:	85d2                	mv	a1,s4
{
ffffffffc020287c:	f426                	sd	s1,40(sp)
ffffffffc020287e:	fc06                	sd	ra,56(sp)
ffffffffc0202880:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202882:	f3aff0ef          	jal	ffffffffc0201fbc <get_pte>
    if (ptep == NULL)
ffffffffc0202886:	c971                	beqz	a0,ffffffffc020295a <page_insert+0xec>
    page->ref += 1;
ffffffffc0202888:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc020288a:	611c                	ld	a5,0(a0)
ffffffffc020288c:	ec4e                	sd	s3,24(sp)
ffffffffc020288e:	0016871b          	addiw	a4,a3,1
ffffffffc0202892:	c018                	sw	a4,0(s0)
ffffffffc0202894:	0017f713          	andi	a4,a5,1
ffffffffc0202898:	89aa                	mv	s3,a0
ffffffffc020289a:	eb15                	bnez	a4,ffffffffc02028ce <page_insert+0x60>
    return &pages[PPN(pa) - nbase];
ffffffffc020289c:	0009c717          	auipc	a4,0x9c
ffffffffc02028a0:	5b473703          	ld	a4,1460(a4) # ffffffffc029ee50 <pages>
    return page - pages + nbase;
ffffffffc02028a4:	8c19                	sub	s0,s0,a4
ffffffffc02028a6:	000807b7          	lui	a5,0x80
ffffffffc02028aa:	8419                	srai	s0,s0,0x6
ffffffffc02028ac:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02028ae:	042a                	slli	s0,s0,0xa
ffffffffc02028b0:	8cc1                	or	s1,s1,s0
ffffffffc02028b2:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02028b6:	0099b023          	sd	s1,0(s3)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02028ba:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc02028be:	69e2                	ld	s3,24(sp)
ffffffffc02028c0:	4501                	li	a0,0
}
ffffffffc02028c2:	70e2                	ld	ra,56(sp)
ffffffffc02028c4:	7442                	ld	s0,48(sp)
ffffffffc02028c6:	74a2                	ld	s1,40(sp)
ffffffffc02028c8:	6a42                	ld	s4,16(sp)
ffffffffc02028ca:	6121                	addi	sp,sp,64
ffffffffc02028cc:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02028ce:	078a                	slli	a5,a5,0x2
ffffffffc02028d0:	f04a                	sd	s2,32(sp)
ffffffffc02028d2:	e456                	sd	s5,8(sp)
ffffffffc02028d4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02028d6:	0009c717          	auipc	a4,0x9c
ffffffffc02028da:	57273703          	ld	a4,1394(a4) # ffffffffc029ee48 <npage>
ffffffffc02028de:	08e7f063          	bgeu	a5,a4,ffffffffc020295e <page_insert+0xf0>
    return &pages[PPN(pa) - nbase];
ffffffffc02028e2:	0009ca97          	auipc	s5,0x9c
ffffffffc02028e6:	56ea8a93          	addi	s5,s5,1390 # ffffffffc029ee50 <pages>
ffffffffc02028ea:	000ab703          	ld	a4,0(s5)
ffffffffc02028ee:	fff80637          	lui	a2,0xfff80
ffffffffc02028f2:	00c78933          	add	s2,a5,a2
ffffffffc02028f6:	091a                	slli	s2,s2,0x6
ffffffffc02028f8:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc02028fa:	01240e63          	beq	s0,s2,ffffffffc0202916 <page_insert+0xa8>
    page->ref -= 1;
ffffffffc02028fe:	00092783          	lw	a5,0(s2)
ffffffffc0202902:	fff7869b          	addiw	a3,a5,-1 # 7ffff <_binary_obj___user_exit_out_size+0x764f7>
ffffffffc0202906:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc020290a:	ca91                	beqz	a3,ffffffffc020291e <page_insert+0xb0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020290c:	120a0073          	sfence.vma	s4
ffffffffc0202910:	7902                	ld	s2,32(sp)
ffffffffc0202912:	6aa2                	ld	s5,8(sp)
}
ffffffffc0202914:	bf41                	j	ffffffffc02028a4 <page_insert+0x36>
    return page->ref;
ffffffffc0202916:	7902                	ld	s2,32(sp)
ffffffffc0202918:	6aa2                	ld	s5,8(sp)
    page->ref -= 1;
ffffffffc020291a:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc020291c:	b761                	j	ffffffffc02028a4 <page_insert+0x36>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020291e:	100027f3          	csrr	a5,sstatus
ffffffffc0202922:	8b89                	andi	a5,a5,2
ffffffffc0202924:	ef81                	bnez	a5,ffffffffc020293c <page_insert+0xce>
        pmm_manager->free_pages(base, n);
ffffffffc0202926:	0009c797          	auipc	a5,0x9c
ffffffffc020292a:	5027b783          	ld	a5,1282(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc020292e:	739c                	ld	a5,32(a5)
ffffffffc0202930:	4585                	li	a1,1
ffffffffc0202932:	854a                	mv	a0,s2
ffffffffc0202934:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202936:	000ab703          	ld	a4,0(s5)
ffffffffc020293a:	bfc9                	j	ffffffffc020290c <page_insert+0x9e>
        intr_disable();
ffffffffc020293c:	83efe0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc0202940:	0009c797          	auipc	a5,0x9c
ffffffffc0202944:	4e87b783          	ld	a5,1256(a5) # ffffffffc029ee28 <pmm_manager>
ffffffffc0202948:	739c                	ld	a5,32(a5)
ffffffffc020294a:	4585                	li	a1,1
ffffffffc020294c:	854a                	mv	a0,s2
ffffffffc020294e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202950:	824fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202954:	000ab703          	ld	a4,0(s5)
ffffffffc0202958:	bf55                	j	ffffffffc020290c <page_insert+0x9e>
        return -E_NO_MEM;
ffffffffc020295a:	5571                	li	a0,-4
ffffffffc020295c:	b79d                	j	ffffffffc02028c2 <page_insert+0x54>
ffffffffc020295e:	d6eff0ef          	jal	ffffffffc0201ecc <pa2page.part.0>

ffffffffc0202962 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202962:	00005797          	auipc	a5,0x5
ffffffffc0202966:	f0e78793          	addi	a5,a5,-242 # ffffffffc0207870 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020296a:	638c                	ld	a1,0(a5)
{
ffffffffc020296c:	7159                	addi	sp,sp,-112
ffffffffc020296e:	f486                	sd	ra,104(sp)
ffffffffc0202970:	e8ca                	sd	s2,80(sp)
ffffffffc0202972:	e4ce                	sd	s3,72(sp)
ffffffffc0202974:	f85a                	sd	s6,48(sp)
ffffffffc0202976:	f0a2                	sd	s0,96(sp)
ffffffffc0202978:	eca6                	sd	s1,88(sp)
ffffffffc020297a:	e0d2                	sd	s4,64(sp)
ffffffffc020297c:	fc56                	sd	s5,56(sp)
ffffffffc020297e:	f45e                	sd	s7,40(sp)
ffffffffc0202980:	f062                	sd	s8,32(sp)
ffffffffc0202982:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202984:	0009cb17          	auipc	s6,0x9c
ffffffffc0202988:	4a4b0b13          	addi	s6,s6,1188 # ffffffffc029ee28 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020298c:	00004517          	auipc	a0,0x4
ffffffffc0202990:	02450513          	addi	a0,a0,36 # ffffffffc02069b0 <etext+0xf42>
    pmm_manager = &default_pmm_manager;
ffffffffc0202994:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202998:	ffcfd0ef          	jal	ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc020299c:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02029a0:	0009c997          	auipc	s3,0x9c
ffffffffc02029a4:	4a098993          	addi	s3,s3,1184 # ffffffffc029ee40 <va_pa_offset>
    pmm_manager->init();
ffffffffc02029a8:	679c                	ld	a5,8(a5)
ffffffffc02029aa:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02029ac:	57f5                	li	a5,-3
ffffffffc02029ae:	07fa                	slli	a5,a5,0x1e
ffffffffc02029b0:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc02029b4:	fadfd0ef          	jal	ffffffffc0200960 <get_memory_base>
ffffffffc02029b8:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc02029ba:	fb1fd0ef          	jal	ffffffffc020096a <get_memory_size>
    if (mem_size == 0)
ffffffffc02029be:	20050be3          	beqz	a0,ffffffffc02033d4 <pmm_init+0xa72>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02029c2:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc02029c4:	00004517          	auipc	a0,0x4
ffffffffc02029c8:	02450513          	addi	a0,a0,36 # ffffffffc02069e8 <etext+0xf7a>
ffffffffc02029cc:	fc8fd0ef          	jal	ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02029d0:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02029d4:	864a                	mv	a2,s2
ffffffffc02029d6:	fff40693          	addi	a3,s0,-1
ffffffffc02029da:	85a6                	mv	a1,s1
ffffffffc02029dc:	00004517          	auipc	a0,0x4
ffffffffc02029e0:	02450513          	addi	a0,a0,36 # ffffffffc0206a00 <etext+0xf92>
ffffffffc02029e4:	fb0fd0ef          	jal	ffffffffc0200194 <cprintf>
    if (maxpa > KERNTOP)
ffffffffc02029e8:	c80007b7          	lui	a5,0xc8000
ffffffffc02029ec:	8622                	mv	a2,s0
ffffffffc02029ee:	5487e763          	bltu	a5,s0,ffffffffc0202f3c <pmm_init+0x5da>
ffffffffc02029f2:	77fd                	lui	a5,0xfffff
ffffffffc02029f4:	0009d697          	auipc	a3,0x9d
ffffffffc02029f8:	48368693          	addi	a3,a3,1155 # ffffffffc029fe77 <end+0xfff>
ffffffffc02029fc:	8efd                	and	a3,a3,a5
    npage = maxpa / PGSIZE;
ffffffffc02029fe:	8231                	srli	a2,a2,0xc
ffffffffc0202a00:	0009c497          	auipc	s1,0x9c
ffffffffc0202a04:	44848493          	addi	s1,s1,1096 # ffffffffc029ee48 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202a08:	0009cb97          	auipc	s7,0x9c
ffffffffc0202a0c:	448b8b93          	addi	s7,s7,1096 # ffffffffc029ee50 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202a10:	e090                	sd	a2,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202a12:	00dbb023          	sd	a3,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202a16:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202a1a:	8736                	mv	a4,a3
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202a1c:	04f60163          	beq	a2,a5,ffffffffc0202a5e <pmm_init+0xfc>
ffffffffc0202a20:	4705                	li	a4,1
ffffffffc0202a22:	06a1                	addi	a3,a3,8
ffffffffc0202a24:	40e6b02f          	amoor.d	zero,a4,(a3)
ffffffffc0202a28:	6090                	ld	a2,0(s1)
ffffffffc0202a2a:	4505                	li	a0,1
ffffffffc0202a2c:	fff805b7          	lui	a1,0xfff80
ffffffffc0202a30:	40f607b3          	sub	a5,a2,a5
ffffffffc0202a34:	02f77063          	bgeu	a4,a5,ffffffffc0202a54 <pmm_init+0xf2>
        SetPageReserved(pages + i);
ffffffffc0202a38:	000bb783          	ld	a5,0(s7)
ffffffffc0202a3c:	00671693          	slli	a3,a4,0x6
ffffffffc0202a40:	97b6                	add	a5,a5,a3
ffffffffc0202a42:	07a1                	addi	a5,a5,8 # 80008 <_binary_obj___user_exit_out_size+0x76500>
ffffffffc0202a44:	40a7b02f          	amoor.d	zero,a0,(a5)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202a48:	6090                	ld	a2,0(s1)
ffffffffc0202a4a:	0705                	addi	a4,a4,1
ffffffffc0202a4c:	00b607b3          	add	a5,a2,a1
ffffffffc0202a50:	fef764e3          	bltu	a4,a5,ffffffffc0202a38 <pmm_init+0xd6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202a54:	000bb703          	ld	a4,0(s7)
ffffffffc0202a58:	079a                	slli	a5,a5,0x6
ffffffffc0202a5a:	00f706b3          	add	a3,a4,a5
ffffffffc0202a5e:	c02007b7          	lui	a5,0xc0200
ffffffffc0202a62:	2ef6eae3          	bltu	a3,a5,ffffffffc0203556 <pmm_init+0xbf4>
ffffffffc0202a66:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202a6a:	77fd                	lui	a5,0xfffff
ffffffffc0202a6c:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202a6e:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202a70:	5086e963          	bltu	a3,s0,ffffffffc0202f82 <pmm_init+0x620>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202a74:	00004517          	auipc	a0,0x4
ffffffffc0202a78:	fb450513          	addi	a0,a0,-76 # ffffffffc0206a28 <etext+0xfba>
ffffffffc0202a7c:	f18fd0ef          	jal	ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202a80:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202a84:	0009c917          	auipc	s2,0x9c
ffffffffc0202a88:	3b490913          	addi	s2,s2,948 # ffffffffc029ee38 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202a8c:	7b9c                	ld	a5,48(a5)
ffffffffc0202a8e:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202a90:	00004517          	auipc	a0,0x4
ffffffffc0202a94:	fb050513          	addi	a0,a0,-80 # ffffffffc0206a40 <etext+0xfd2>
ffffffffc0202a98:	efcfd0ef          	jal	ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202a9c:	00007697          	auipc	a3,0x7
ffffffffc0202aa0:	56468693          	addi	a3,a3,1380 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202aa4:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202aa8:	c02007b7          	lui	a5,0xc0200
ffffffffc0202aac:	28f6e9e3          	bltu	a3,a5,ffffffffc020353e <pmm_init+0xbdc>
ffffffffc0202ab0:	0009b783          	ld	a5,0(s3)
ffffffffc0202ab4:	8e9d                	sub	a3,a3,a5
ffffffffc0202ab6:	0009c797          	auipc	a5,0x9c
ffffffffc0202aba:	36d7bd23          	sd	a3,890(a5) # ffffffffc029ee30 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202abe:	100027f3          	csrr	a5,sstatus
ffffffffc0202ac2:	8b89                	andi	a5,a5,2
ffffffffc0202ac4:	4a079563          	bnez	a5,ffffffffc0202f6e <pmm_init+0x60c>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202ac8:	000b3783          	ld	a5,0(s6)
ffffffffc0202acc:	779c                	ld	a5,40(a5)
ffffffffc0202ace:	9782                	jalr	a5
ffffffffc0202ad0:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202ad2:	6098                	ld	a4,0(s1)
ffffffffc0202ad4:	c80007b7          	lui	a5,0xc8000
ffffffffc0202ad8:	83b1                	srli	a5,a5,0xc
ffffffffc0202ada:	66e7e163          	bltu	a5,a4,ffffffffc020313c <pmm_init+0x7da>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202ade:	00093503          	ld	a0,0(s2)
ffffffffc0202ae2:	62050d63          	beqz	a0,ffffffffc020311c <pmm_init+0x7ba>
ffffffffc0202ae6:	03451793          	slli	a5,a0,0x34
ffffffffc0202aea:	62079963          	bnez	a5,ffffffffc020311c <pmm_init+0x7ba>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202aee:	4601                	li	a2,0
ffffffffc0202af0:	4581                	li	a1,0
ffffffffc0202af2:	ef8ff0ef          	jal	ffffffffc02021ea <get_page>
ffffffffc0202af6:	60051363          	bnez	a0,ffffffffc02030fc <pmm_init+0x79a>
ffffffffc0202afa:	100027f3          	csrr	a5,sstatus
ffffffffc0202afe:	8b89                	andi	a5,a5,2
ffffffffc0202b00:	44079c63          	bnez	a5,ffffffffc0202f58 <pmm_init+0x5f6>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202b04:	000b3783          	ld	a5,0(s6)
ffffffffc0202b08:	4505                	li	a0,1
ffffffffc0202b0a:	6f9c                	ld	a5,24(a5)
ffffffffc0202b0c:	9782                	jalr	a5
ffffffffc0202b0e:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202b10:	00093503          	ld	a0,0(s2)
ffffffffc0202b14:	4681                	li	a3,0
ffffffffc0202b16:	4601                	li	a2,0
ffffffffc0202b18:	85d2                	mv	a1,s4
ffffffffc0202b1a:	d55ff0ef          	jal	ffffffffc020286e <page_insert>
ffffffffc0202b1e:	260518e3          	bnez	a0,ffffffffc020358e <pmm_init+0xc2c>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202b22:	00093503          	ld	a0,0(s2)
ffffffffc0202b26:	4601                	li	a2,0
ffffffffc0202b28:	4581                	li	a1,0
ffffffffc0202b2a:	c92ff0ef          	jal	ffffffffc0201fbc <get_pte>
ffffffffc0202b2e:	240500e3          	beqz	a0,ffffffffc020356e <pmm_init+0xc0c>
    assert(pte2page(*ptep) == p1);
ffffffffc0202b32:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202b34:	0017f713          	andi	a4,a5,1
ffffffffc0202b38:	5a070063          	beqz	a4,ffffffffc02030d8 <pmm_init+0x776>
    if (PPN(pa) >= npage)
ffffffffc0202b3c:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202b3e:	078a                	slli	a5,a5,0x2
ffffffffc0202b40:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b42:	58e7f963          	bgeu	a5,a4,ffffffffc02030d4 <pmm_init+0x772>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b46:	000bb683          	ld	a3,0(s7)
ffffffffc0202b4a:	fff80637          	lui	a2,0xfff80
ffffffffc0202b4e:	97b2                	add	a5,a5,a2
ffffffffc0202b50:	079a                	slli	a5,a5,0x6
ffffffffc0202b52:	97b6                	add	a5,a5,a3
ffffffffc0202b54:	14fa15e3          	bne	s4,a5,ffffffffc020349e <pmm_init+0xb3c>
    assert(page_ref(p1) == 1);
ffffffffc0202b58:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_softint_out_size-0x7598>
ffffffffc0202b5c:	4785                	li	a5,1
ffffffffc0202b5e:	12f690e3          	bne	a3,a5,ffffffffc020347e <pmm_init+0xb1c>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202b62:	00093503          	ld	a0,0(s2)
ffffffffc0202b66:	77fd                	lui	a5,0xfffff
ffffffffc0202b68:	6114                	ld	a3,0(a0)
ffffffffc0202b6a:	068a                	slli	a3,a3,0x2
ffffffffc0202b6c:	8efd                	and	a3,a3,a5
ffffffffc0202b6e:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202b72:	0ee67ae3          	bgeu	a2,a4,ffffffffc0203466 <pmm_init+0xb04>
ffffffffc0202b76:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202b7a:	96e2                	add	a3,a3,s8
ffffffffc0202b7c:	0006ba83          	ld	s5,0(a3)
ffffffffc0202b80:	0a8a                	slli	s5,s5,0x2
ffffffffc0202b82:	00fafab3          	and	s5,s5,a5
ffffffffc0202b86:	00cad793          	srli	a5,s5,0xc
ffffffffc0202b8a:	0ce7f1e3          	bgeu	a5,a4,ffffffffc020344c <pmm_init+0xaea>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202b8e:	4601                	li	a2,0
ffffffffc0202b90:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202b92:	9c56                	add	s8,s8,s5
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202b94:	c28ff0ef          	jal	ffffffffc0201fbc <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202b98:	0c21                	addi	s8,s8,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202b9a:	55851163          	bne	a0,s8,ffffffffc02030dc <pmm_init+0x77a>
ffffffffc0202b9e:	100027f3          	csrr	a5,sstatus
ffffffffc0202ba2:	8b89                	andi	a5,a5,2
ffffffffc0202ba4:	38079f63          	bnez	a5,ffffffffc0202f42 <pmm_init+0x5e0>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202ba8:	000b3783          	ld	a5,0(s6)
ffffffffc0202bac:	4505                	li	a0,1
ffffffffc0202bae:	6f9c                	ld	a5,24(a5)
ffffffffc0202bb0:	9782                	jalr	a5
ffffffffc0202bb2:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202bb4:	00093503          	ld	a0,0(s2)
ffffffffc0202bb8:	46d1                	li	a3,20
ffffffffc0202bba:	6605                	lui	a2,0x1
ffffffffc0202bbc:	85e2                	mv	a1,s8
ffffffffc0202bbe:	cb1ff0ef          	jal	ffffffffc020286e <page_insert>
ffffffffc0202bc2:	060515e3          	bnez	a0,ffffffffc020342c <pmm_init+0xaca>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202bc6:	00093503          	ld	a0,0(s2)
ffffffffc0202bca:	4601                	li	a2,0
ffffffffc0202bcc:	6585                	lui	a1,0x1
ffffffffc0202bce:	beeff0ef          	jal	ffffffffc0201fbc <get_pte>
ffffffffc0202bd2:	02050de3          	beqz	a0,ffffffffc020340c <pmm_init+0xaaa>
    assert(*ptep & PTE_U);
ffffffffc0202bd6:	611c                	ld	a5,0(a0)
ffffffffc0202bd8:	0107f713          	andi	a4,a5,16
ffffffffc0202bdc:	7c070c63          	beqz	a4,ffffffffc02033b4 <pmm_init+0xa52>
    assert(*ptep & PTE_W);
ffffffffc0202be0:	8b91                	andi	a5,a5,4
ffffffffc0202be2:	7a078963          	beqz	a5,ffffffffc0203394 <pmm_init+0xa32>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202be6:	00093503          	ld	a0,0(s2)
ffffffffc0202bea:	611c                	ld	a5,0(a0)
ffffffffc0202bec:	8bc1                	andi	a5,a5,16
ffffffffc0202bee:	78078363          	beqz	a5,ffffffffc0203374 <pmm_init+0xa12>
    assert(page_ref(p2) == 1);
ffffffffc0202bf2:	000c2703          	lw	a4,0(s8)
ffffffffc0202bf6:	4785                	li	a5,1
ffffffffc0202bf8:	74f71e63          	bne	a4,a5,ffffffffc0203354 <pmm_init+0x9f2>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202bfc:	4681                	li	a3,0
ffffffffc0202bfe:	6605                	lui	a2,0x1
ffffffffc0202c00:	85d2                	mv	a1,s4
ffffffffc0202c02:	c6dff0ef          	jal	ffffffffc020286e <page_insert>
ffffffffc0202c06:	72051763          	bnez	a0,ffffffffc0203334 <pmm_init+0x9d2>
    assert(page_ref(p1) == 2);
ffffffffc0202c0a:	000a2703          	lw	a4,0(s4)
ffffffffc0202c0e:	4789                	li	a5,2
ffffffffc0202c10:	70f71263          	bne	a4,a5,ffffffffc0203314 <pmm_init+0x9b2>
    assert(page_ref(p2) == 0);
ffffffffc0202c14:	000c2783          	lw	a5,0(s8)
ffffffffc0202c18:	6c079e63          	bnez	a5,ffffffffc02032f4 <pmm_init+0x992>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202c1c:	00093503          	ld	a0,0(s2)
ffffffffc0202c20:	4601                	li	a2,0
ffffffffc0202c22:	6585                	lui	a1,0x1
ffffffffc0202c24:	b98ff0ef          	jal	ffffffffc0201fbc <get_pte>
ffffffffc0202c28:	6a050663          	beqz	a0,ffffffffc02032d4 <pmm_init+0x972>
    assert(pte2page(*ptep) == p1);
ffffffffc0202c2c:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202c2e:	00177793          	andi	a5,a4,1
ffffffffc0202c32:	4a078363          	beqz	a5,ffffffffc02030d8 <pmm_init+0x776>
    if (PPN(pa) >= npage)
ffffffffc0202c36:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202c38:	00271793          	slli	a5,a4,0x2
ffffffffc0202c3c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c3e:	48d7fb63          	bgeu	a5,a3,ffffffffc02030d4 <pmm_init+0x772>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c42:	000bb683          	ld	a3,0(s7)
ffffffffc0202c46:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202c4a:	97d6                	add	a5,a5,s5
ffffffffc0202c4c:	079a                	slli	a5,a5,0x6
ffffffffc0202c4e:	97b6                	add	a5,a5,a3
ffffffffc0202c50:	66fa1263          	bne	s4,a5,ffffffffc02032b4 <pmm_init+0x952>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202c54:	8b41                	andi	a4,a4,16
ffffffffc0202c56:	62071f63          	bnez	a4,ffffffffc0203294 <pmm_init+0x932>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202c5a:	00093503          	ld	a0,0(s2)
ffffffffc0202c5e:	4581                	li	a1,0
ffffffffc0202c60:	b73ff0ef          	jal	ffffffffc02027d2 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202c64:	000a2c83          	lw	s9,0(s4)
ffffffffc0202c68:	4785                	li	a5,1
ffffffffc0202c6a:	60fc9563          	bne	s9,a5,ffffffffc0203274 <pmm_init+0x912>
    assert(page_ref(p2) == 0);
ffffffffc0202c6e:	000c2783          	lw	a5,0(s8)
ffffffffc0202c72:	5e079163          	bnez	a5,ffffffffc0203254 <pmm_init+0x8f2>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202c76:	00093503          	ld	a0,0(s2)
ffffffffc0202c7a:	6585                	lui	a1,0x1
ffffffffc0202c7c:	b57ff0ef          	jal	ffffffffc02027d2 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202c80:	000a2783          	lw	a5,0(s4)
ffffffffc0202c84:	52079863          	bnez	a5,ffffffffc02031b4 <pmm_init+0x852>
    assert(page_ref(p2) == 0);
ffffffffc0202c88:	000c2783          	lw	a5,0(s8)
ffffffffc0202c8c:	50079463          	bnez	a5,ffffffffc0203194 <pmm_init+0x832>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202c90:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202c94:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c96:	000a3783          	ld	a5,0(s4)
ffffffffc0202c9a:	078a                	slli	a5,a5,0x2
ffffffffc0202c9c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c9e:	42e7fb63          	bgeu	a5,a4,ffffffffc02030d4 <pmm_init+0x772>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ca2:	000bb503          	ld	a0,0(s7)
ffffffffc0202ca6:	97d6                	add	a5,a5,s5
ffffffffc0202ca8:	079a                	slli	a5,a5,0x6
    return page->ref;
ffffffffc0202caa:	00f506b3          	add	a3,a0,a5
ffffffffc0202cae:	4294                	lw	a3,0(a3)
ffffffffc0202cb0:	4d969263          	bne	a3,s9,ffffffffc0203174 <pmm_init+0x812>
    return page - pages + nbase;
ffffffffc0202cb4:	8799                	srai	a5,a5,0x6
ffffffffc0202cb6:	00080637          	lui	a2,0x80
ffffffffc0202cba:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202cbc:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202cc0:	48e7fe63          	bgeu	a5,a4,ffffffffc020315c <pmm_init+0x7fa>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202cc4:	0009b783          	ld	a5,0(s3)
ffffffffc0202cc8:	97b6                	add	a5,a5,a3
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cca:	639c                	ld	a5,0(a5)
ffffffffc0202ccc:	078a                	slli	a5,a5,0x2
ffffffffc0202cce:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cd0:	40e7f263          	bgeu	a5,a4,ffffffffc02030d4 <pmm_init+0x772>
    return &pages[PPN(pa) - nbase];
ffffffffc0202cd4:	8f91                	sub	a5,a5,a2
ffffffffc0202cd6:	079a                	slli	a5,a5,0x6
ffffffffc0202cd8:	953e                	add	a0,a0,a5
ffffffffc0202cda:	100027f3          	csrr	a5,sstatus
ffffffffc0202cde:	8b89                	andi	a5,a5,2
ffffffffc0202ce0:	30079963          	bnez	a5,ffffffffc0202ff2 <pmm_init+0x690>
        pmm_manager->free_pages(base, n);
ffffffffc0202ce4:	000b3783          	ld	a5,0(s6)
ffffffffc0202ce8:	4585                	li	a1,1
ffffffffc0202cea:	739c                	ld	a5,32(a5)
ffffffffc0202cec:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cee:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202cf2:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cf4:	078a                	slli	a5,a5,0x2
ffffffffc0202cf6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cf8:	3ce7fe63          	bgeu	a5,a4,ffffffffc02030d4 <pmm_init+0x772>
    return &pages[PPN(pa) - nbase];
ffffffffc0202cfc:	000bb503          	ld	a0,0(s7)
ffffffffc0202d00:	fff80737          	lui	a4,0xfff80
ffffffffc0202d04:	97ba                	add	a5,a5,a4
ffffffffc0202d06:	079a                	slli	a5,a5,0x6
ffffffffc0202d08:	953e                	add	a0,a0,a5
ffffffffc0202d0a:	100027f3          	csrr	a5,sstatus
ffffffffc0202d0e:	8b89                	andi	a5,a5,2
ffffffffc0202d10:	2c079563          	bnez	a5,ffffffffc0202fda <pmm_init+0x678>
ffffffffc0202d14:	000b3783          	ld	a5,0(s6)
ffffffffc0202d18:	4585                	li	a1,1
ffffffffc0202d1a:	739c                	ld	a5,32(a5)
ffffffffc0202d1c:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202d1e:	00093783          	ld	a5,0(s2)
ffffffffc0202d22:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd60188>
    asm volatile("sfence.vma");
ffffffffc0202d26:	12000073          	sfence.vma
ffffffffc0202d2a:	100027f3          	csrr	a5,sstatus
ffffffffc0202d2e:	8b89                	andi	a5,a5,2
ffffffffc0202d30:	28079b63          	bnez	a5,ffffffffc0202fc6 <pmm_init+0x664>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d34:	000b3783          	ld	a5,0(s6)
ffffffffc0202d38:	779c                	ld	a5,40(a5)
ffffffffc0202d3a:	9782                	jalr	a5
ffffffffc0202d3c:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202d3e:	4b441b63          	bne	s0,s4,ffffffffc02031f4 <pmm_init+0x892>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202d42:	00004517          	auipc	a0,0x4
ffffffffc0202d46:	02650513          	addi	a0,a0,38 # ffffffffc0206d68 <etext+0x12fa>
ffffffffc0202d4a:	c4afd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0202d4e:	100027f3          	csrr	a5,sstatus
ffffffffc0202d52:	8b89                	andi	a5,a5,2
ffffffffc0202d54:	24079f63          	bnez	a5,ffffffffc0202fb2 <pmm_init+0x650>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d58:	000b3783          	ld	a5,0(s6)
ffffffffc0202d5c:	779c                	ld	a5,40(a5)
ffffffffc0202d5e:	9782                	jalr	a5
ffffffffc0202d60:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202d62:	6098                	ld	a4,0(s1)
ffffffffc0202d64:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202d68:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202d6a:	00c71793          	slli	a5,a4,0xc
ffffffffc0202d6e:	6a05                	lui	s4,0x1
ffffffffc0202d70:	02f47c63          	bgeu	s0,a5,ffffffffc0202da8 <pmm_init+0x446>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202d74:	00c45793          	srli	a5,s0,0xc
ffffffffc0202d78:	00093503          	ld	a0,0(s2)
ffffffffc0202d7c:	2ee7ff63          	bgeu	a5,a4,ffffffffc020307a <pmm_init+0x718>
ffffffffc0202d80:	0009b583          	ld	a1,0(s3)
ffffffffc0202d84:	4601                	li	a2,0
ffffffffc0202d86:	95a2                	add	a1,a1,s0
ffffffffc0202d88:	a34ff0ef          	jal	ffffffffc0201fbc <get_pte>
ffffffffc0202d8c:	32050463          	beqz	a0,ffffffffc02030b4 <pmm_init+0x752>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202d90:	611c                	ld	a5,0(a0)
ffffffffc0202d92:	078a                	slli	a5,a5,0x2
ffffffffc0202d94:	0157f7b3          	and	a5,a5,s5
ffffffffc0202d98:	2e879e63          	bne	a5,s0,ffffffffc0203094 <pmm_init+0x732>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202d9c:	6098                	ld	a4,0(s1)
ffffffffc0202d9e:	9452                	add	s0,s0,s4
ffffffffc0202da0:	00c71793          	slli	a5,a4,0xc
ffffffffc0202da4:	fcf468e3          	bltu	s0,a5,ffffffffc0202d74 <pmm_init+0x412>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202da8:	00093783          	ld	a5,0(s2)
ffffffffc0202dac:	639c                	ld	a5,0(a5)
ffffffffc0202dae:	42079363          	bnez	a5,ffffffffc02031d4 <pmm_init+0x872>
ffffffffc0202db2:	100027f3          	csrr	a5,sstatus
ffffffffc0202db6:	8b89                	andi	a5,a5,2
ffffffffc0202db8:	24079963          	bnez	a5,ffffffffc020300a <pmm_init+0x6a8>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202dbc:	000b3783          	ld	a5,0(s6)
ffffffffc0202dc0:	4505                	li	a0,1
ffffffffc0202dc2:	6f9c                	ld	a5,24(a5)
ffffffffc0202dc4:	9782                	jalr	a5
ffffffffc0202dc6:	842a                	mv	s0,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202dc8:	00093503          	ld	a0,0(s2)
ffffffffc0202dcc:	4699                	li	a3,6
ffffffffc0202dce:	10000613          	li	a2,256
ffffffffc0202dd2:	85a2                	mv	a1,s0
ffffffffc0202dd4:	a9bff0ef          	jal	ffffffffc020286e <page_insert>
ffffffffc0202dd8:	44051e63          	bnez	a0,ffffffffc0203234 <pmm_init+0x8d2>
    assert(page_ref(p) == 1);
ffffffffc0202ddc:	4018                	lw	a4,0(s0)
ffffffffc0202dde:	4785                	li	a5,1
ffffffffc0202de0:	42f71a63          	bne	a4,a5,ffffffffc0203214 <pmm_init+0x8b2>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202de4:	00093503          	ld	a0,0(s2)
ffffffffc0202de8:	6605                	lui	a2,0x1
ffffffffc0202dea:	4699                	li	a3,6
ffffffffc0202dec:	10060613          	addi	a2,a2,256 # 1100 <_binary_obj___user_softint_out_size-0x7498>
ffffffffc0202df0:	85a2                	mv	a1,s0
ffffffffc0202df2:	a7dff0ef          	jal	ffffffffc020286e <page_insert>
ffffffffc0202df6:	72051463          	bnez	a0,ffffffffc020351e <pmm_init+0xbbc>
    assert(page_ref(p) == 2);
ffffffffc0202dfa:	4018                	lw	a4,0(s0)
ffffffffc0202dfc:	4789                	li	a5,2
ffffffffc0202dfe:	70f71063          	bne	a4,a5,ffffffffc02034fe <pmm_init+0xb9c>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202e02:	00004597          	auipc	a1,0x4
ffffffffc0202e06:	0ae58593          	addi	a1,a1,174 # ffffffffc0206eb0 <etext+0x1442>
ffffffffc0202e0a:	10000513          	li	a0,256
ffffffffc0202e0e:	3af020ef          	jal	ffffffffc02059bc <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202e12:	6585                	lui	a1,0x1
ffffffffc0202e14:	10058593          	addi	a1,a1,256 # 1100 <_binary_obj___user_softint_out_size-0x7498>
ffffffffc0202e18:	10000513          	li	a0,256
ffffffffc0202e1c:	3b3020ef          	jal	ffffffffc02059ce <strcmp>
ffffffffc0202e20:	6a051f63          	bnez	a0,ffffffffc02034de <pmm_init+0xb7c>
    return page - pages + nbase;
ffffffffc0202e24:	000bb683          	ld	a3,0(s7)
ffffffffc0202e28:	000807b7          	lui	a5,0x80
    return KADDR(page2pa(page));
ffffffffc0202e2c:	6098                	ld	a4,0(s1)
    return page - pages + nbase;
ffffffffc0202e2e:	40d406b3          	sub	a3,s0,a3
ffffffffc0202e32:	8699                	srai	a3,a3,0x6
ffffffffc0202e34:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0202e36:	00c69793          	slli	a5,a3,0xc
ffffffffc0202e3a:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202e3c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202e3e:	30e7ff63          	bgeu	a5,a4,ffffffffc020315c <pmm_init+0x7fa>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202e42:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202e46:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202e4a:	97b6                	add	a5,a5,a3
ffffffffc0202e4c:	10078023          	sb	zero,256(a5) # 80100 <_binary_obj___user_exit_out_size+0x765f8>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202e50:	337020ef          	jal	ffffffffc0205986 <strlen>
ffffffffc0202e54:	66051563          	bnez	a0,ffffffffc02034be <pmm_init+0xb5c>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202e58:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202e5c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e5e:	000a3783          	ld	a5,0(s4) # 1000 <_binary_obj___user_softint_out_size-0x7598>
ffffffffc0202e62:	078a                	slli	a5,a5,0x2
ffffffffc0202e64:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e66:	26e7f763          	bgeu	a5,a4,ffffffffc02030d4 <pmm_init+0x772>
    return page2ppn(page) << PGSHIFT;
ffffffffc0202e6a:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202e6e:	2ee7f763          	bgeu	a5,a4,ffffffffc020315c <pmm_init+0x7fa>
ffffffffc0202e72:	0009b783          	ld	a5,0(s3)
ffffffffc0202e76:	00f689b3          	add	s3,a3,a5
ffffffffc0202e7a:	100027f3          	csrr	a5,sstatus
ffffffffc0202e7e:	8b89                	andi	a5,a5,2
ffffffffc0202e80:	1e079263          	bnez	a5,ffffffffc0203064 <pmm_init+0x702>
        pmm_manager->free_pages(base, n);
ffffffffc0202e84:	000b3783          	ld	a5,0(s6)
ffffffffc0202e88:	4585                	li	a1,1
ffffffffc0202e8a:	8522                	mv	a0,s0
ffffffffc0202e8c:	739c                	ld	a5,32(a5)
ffffffffc0202e8e:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e90:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage)
ffffffffc0202e94:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e96:	078a                	slli	a5,a5,0x2
ffffffffc0202e98:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e9a:	22e7fd63          	bgeu	a5,a4,ffffffffc02030d4 <pmm_init+0x772>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e9e:	000bb503          	ld	a0,0(s7)
ffffffffc0202ea2:	fff80737          	lui	a4,0xfff80
ffffffffc0202ea6:	97ba                	add	a5,a5,a4
ffffffffc0202ea8:	079a                	slli	a5,a5,0x6
ffffffffc0202eaa:	953e                	add	a0,a0,a5
ffffffffc0202eac:	100027f3          	csrr	a5,sstatus
ffffffffc0202eb0:	8b89                	andi	a5,a5,2
ffffffffc0202eb2:	18079d63          	bnez	a5,ffffffffc020304c <pmm_init+0x6ea>
ffffffffc0202eb6:	000b3783          	ld	a5,0(s6)
ffffffffc0202eba:	4585                	li	a1,1
ffffffffc0202ebc:	739c                	ld	a5,32(a5)
ffffffffc0202ebe:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ec0:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202ec4:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ec6:	078a                	slli	a5,a5,0x2
ffffffffc0202ec8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202eca:	20e7f563          	bgeu	a5,a4,ffffffffc02030d4 <pmm_init+0x772>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ece:	000bb503          	ld	a0,0(s7)
ffffffffc0202ed2:	fff80737          	lui	a4,0xfff80
ffffffffc0202ed6:	97ba                	add	a5,a5,a4
ffffffffc0202ed8:	079a                	slli	a5,a5,0x6
ffffffffc0202eda:	953e                	add	a0,a0,a5
ffffffffc0202edc:	100027f3          	csrr	a5,sstatus
ffffffffc0202ee0:	8b89                	andi	a5,a5,2
ffffffffc0202ee2:	14079963          	bnez	a5,ffffffffc0203034 <pmm_init+0x6d2>
ffffffffc0202ee6:	000b3783          	ld	a5,0(s6)
ffffffffc0202eea:	4585                	li	a1,1
ffffffffc0202eec:	739c                	ld	a5,32(a5)
ffffffffc0202eee:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202ef0:	00093783          	ld	a5,0(s2)
ffffffffc0202ef4:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202ef8:	12000073          	sfence.vma
ffffffffc0202efc:	100027f3          	csrr	a5,sstatus
ffffffffc0202f00:	8b89                	andi	a5,a5,2
ffffffffc0202f02:	10079f63          	bnez	a5,ffffffffc0203020 <pmm_init+0x6be>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202f06:	000b3783          	ld	a5,0(s6)
ffffffffc0202f0a:	779c                	ld	a5,40(a5)
ffffffffc0202f0c:	9782                	jalr	a5
ffffffffc0202f0e:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202f10:	4c8c1e63          	bne	s8,s0,ffffffffc02033ec <pmm_init+0xa8a>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202f14:	00004517          	auipc	a0,0x4
ffffffffc0202f18:	01450513          	addi	a0,a0,20 # ffffffffc0206f28 <etext+0x14ba>
ffffffffc0202f1c:	a78fd0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0202f20:	7406                	ld	s0,96(sp)
ffffffffc0202f22:	70a6                	ld	ra,104(sp)
ffffffffc0202f24:	64e6                	ld	s1,88(sp)
ffffffffc0202f26:	6946                	ld	s2,80(sp)
ffffffffc0202f28:	69a6                	ld	s3,72(sp)
ffffffffc0202f2a:	6a06                	ld	s4,64(sp)
ffffffffc0202f2c:	7ae2                	ld	s5,56(sp)
ffffffffc0202f2e:	7b42                	ld	s6,48(sp)
ffffffffc0202f30:	7ba2                	ld	s7,40(sp)
ffffffffc0202f32:	7c02                	ld	s8,32(sp)
ffffffffc0202f34:	6ce2                	ld	s9,24(sp)
ffffffffc0202f36:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202f38:	dd1fe06f          	j	ffffffffc0201d08 <kmalloc_init>
    if (maxpa > KERNTOP)
ffffffffc0202f3c:	c8000637          	lui	a2,0xc8000
ffffffffc0202f40:	bc4d                	j	ffffffffc02029f2 <pmm_init+0x90>
        intr_disable();
ffffffffc0202f42:	a39fd0ef          	jal	ffffffffc020097a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202f46:	000b3783          	ld	a5,0(s6)
ffffffffc0202f4a:	4505                	li	a0,1
ffffffffc0202f4c:	6f9c                	ld	a5,24(a5)
ffffffffc0202f4e:	9782                	jalr	a5
ffffffffc0202f50:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202f52:	a23fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202f56:	b9b9                	j	ffffffffc0202bb4 <pmm_init+0x252>
        intr_disable();
ffffffffc0202f58:	a23fd0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc0202f5c:	000b3783          	ld	a5,0(s6)
ffffffffc0202f60:	4505                	li	a0,1
ffffffffc0202f62:	6f9c                	ld	a5,24(a5)
ffffffffc0202f64:	9782                	jalr	a5
ffffffffc0202f66:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202f68:	a0dfd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202f6c:	b655                	j	ffffffffc0202b10 <pmm_init+0x1ae>
        intr_disable();
ffffffffc0202f6e:	a0dfd0ef          	jal	ffffffffc020097a <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202f72:	000b3783          	ld	a5,0(s6)
ffffffffc0202f76:	779c                	ld	a5,40(a5)
ffffffffc0202f78:	9782                	jalr	a5
ffffffffc0202f7a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202f7c:	9f9fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202f80:	be89                	j	ffffffffc0202ad2 <pmm_init+0x170>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202f82:	6585                	lui	a1,0x1
ffffffffc0202f84:	15fd                	addi	a1,a1,-1 # fff <_binary_obj___user_softint_out_size-0x7599>
ffffffffc0202f86:	96ae                	add	a3,a3,a1
ffffffffc0202f88:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202f8a:	00c7d693          	srli	a3,a5,0xc
ffffffffc0202f8e:	14c6f363          	bgeu	a3,a2,ffffffffc02030d4 <pmm_init+0x772>
    pmm_manager->init_memmap(base, n);
ffffffffc0202f92:	000b3603          	ld	a2,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202f96:	fff805b7          	lui	a1,0xfff80
ffffffffc0202f9a:	96ae                	add	a3,a3,a1
ffffffffc0202f9c:	6a10                	ld	a2,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202f9e:	8c1d                	sub	s0,s0,a5
ffffffffc0202fa0:	00669513          	slli	a0,a3,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202fa4:	00c45593          	srli	a1,s0,0xc
ffffffffc0202fa8:	953a                	add	a0,a0,a4
ffffffffc0202faa:	9602                	jalr	a2
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202fac:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202fb0:	b4d1                	j	ffffffffc0202a74 <pmm_init+0x112>
        intr_disable();
ffffffffc0202fb2:	9c9fd0ef          	jal	ffffffffc020097a <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202fb6:	000b3783          	ld	a5,0(s6)
ffffffffc0202fba:	779c                	ld	a5,40(a5)
ffffffffc0202fbc:	9782                	jalr	a5
ffffffffc0202fbe:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202fc0:	9b5fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202fc4:	bb79                	j	ffffffffc0202d62 <pmm_init+0x400>
        intr_disable();
ffffffffc0202fc6:	9b5fd0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc0202fca:	000b3783          	ld	a5,0(s6)
ffffffffc0202fce:	779c                	ld	a5,40(a5)
ffffffffc0202fd0:	9782                	jalr	a5
ffffffffc0202fd2:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202fd4:	9a1fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202fd8:	b39d                	j	ffffffffc0202d3e <pmm_init+0x3dc>
ffffffffc0202fda:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202fdc:	99ffd0ef          	jal	ffffffffc020097a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202fe0:	000b3783          	ld	a5,0(s6)
ffffffffc0202fe4:	6522                	ld	a0,8(sp)
ffffffffc0202fe6:	4585                	li	a1,1
ffffffffc0202fe8:	739c                	ld	a5,32(a5)
ffffffffc0202fea:	9782                	jalr	a5
        intr_enable();
ffffffffc0202fec:	989fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202ff0:	b33d                	j	ffffffffc0202d1e <pmm_init+0x3bc>
ffffffffc0202ff2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202ff4:	987fd0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc0202ff8:	000b3783          	ld	a5,0(s6)
ffffffffc0202ffc:	6522                	ld	a0,8(sp)
ffffffffc0202ffe:	4585                	li	a1,1
ffffffffc0203000:	739c                	ld	a5,32(a5)
ffffffffc0203002:	9782                	jalr	a5
        intr_enable();
ffffffffc0203004:	971fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0203008:	b1dd                	j	ffffffffc0202cee <pmm_init+0x38c>
        intr_disable();
ffffffffc020300a:	971fd0ef          	jal	ffffffffc020097a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020300e:	000b3783          	ld	a5,0(s6)
ffffffffc0203012:	4505                	li	a0,1
ffffffffc0203014:	6f9c                	ld	a5,24(a5)
ffffffffc0203016:	9782                	jalr	a5
ffffffffc0203018:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020301a:	95bfd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc020301e:	b36d                	j	ffffffffc0202dc8 <pmm_init+0x466>
        intr_disable();
ffffffffc0203020:	95bfd0ef          	jal	ffffffffc020097a <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0203024:	000b3783          	ld	a5,0(s6)
ffffffffc0203028:	779c                	ld	a5,40(a5)
ffffffffc020302a:	9782                	jalr	a5
ffffffffc020302c:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020302e:	947fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0203032:	bdf9                	j	ffffffffc0202f10 <pmm_init+0x5ae>
ffffffffc0203034:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203036:	945fd0ef          	jal	ffffffffc020097a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020303a:	000b3783          	ld	a5,0(s6)
ffffffffc020303e:	6522                	ld	a0,8(sp)
ffffffffc0203040:	4585                	li	a1,1
ffffffffc0203042:	739c                	ld	a5,32(a5)
ffffffffc0203044:	9782                	jalr	a5
        intr_enable();
ffffffffc0203046:	92ffd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc020304a:	b55d                	j	ffffffffc0202ef0 <pmm_init+0x58e>
ffffffffc020304c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020304e:	92dfd0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc0203052:	000b3783          	ld	a5,0(s6)
ffffffffc0203056:	6522                	ld	a0,8(sp)
ffffffffc0203058:	4585                	li	a1,1
ffffffffc020305a:	739c                	ld	a5,32(a5)
ffffffffc020305c:	9782                	jalr	a5
        intr_enable();
ffffffffc020305e:	917fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0203062:	bdb9                	j	ffffffffc0202ec0 <pmm_init+0x55e>
        intr_disable();
ffffffffc0203064:	917fd0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc0203068:	000b3783          	ld	a5,0(s6)
ffffffffc020306c:	4585                	li	a1,1
ffffffffc020306e:	8522                	mv	a0,s0
ffffffffc0203070:	739c                	ld	a5,32(a5)
ffffffffc0203072:	9782                	jalr	a5
        intr_enable();
ffffffffc0203074:	901fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0203078:	bd21                	j	ffffffffc0202e90 <pmm_init+0x52e>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020307a:	86a2                	mv	a3,s0
ffffffffc020307c:	00003617          	auipc	a2,0x3
ffffffffc0203080:	7c460613          	addi	a2,a2,1988 # ffffffffc0206840 <etext+0xdd2>
ffffffffc0203084:	25700593          	li	a1,599
ffffffffc0203088:	00004517          	auipc	a0,0x4
ffffffffc020308c:	8d050513          	addi	a0,a0,-1840 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203090:	bf8fd0ef          	jal	ffffffffc0200488 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0203094:	00004697          	auipc	a3,0x4
ffffffffc0203098:	d3468693          	addi	a3,a3,-716 # ffffffffc0206dc8 <etext+0x135a>
ffffffffc020309c:	00003617          	auipc	a2,0x3
ffffffffc02030a0:	3f460613          	addi	a2,a2,1012 # ffffffffc0206490 <etext+0xa22>
ffffffffc02030a4:	25800593          	li	a1,600
ffffffffc02030a8:	00004517          	auipc	a0,0x4
ffffffffc02030ac:	8b050513          	addi	a0,a0,-1872 # ffffffffc0206958 <etext+0xeea>
ffffffffc02030b0:	bd8fd0ef          	jal	ffffffffc0200488 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02030b4:	00004697          	auipc	a3,0x4
ffffffffc02030b8:	cd468693          	addi	a3,a3,-812 # ffffffffc0206d88 <etext+0x131a>
ffffffffc02030bc:	00003617          	auipc	a2,0x3
ffffffffc02030c0:	3d460613          	addi	a2,a2,980 # ffffffffc0206490 <etext+0xa22>
ffffffffc02030c4:	25700593          	li	a1,599
ffffffffc02030c8:	00004517          	auipc	a0,0x4
ffffffffc02030cc:	89050513          	addi	a0,a0,-1904 # ffffffffc0206958 <etext+0xeea>
ffffffffc02030d0:	bb8fd0ef          	jal	ffffffffc0200488 <__panic>
ffffffffc02030d4:	df9fe0ef          	jal	ffffffffc0201ecc <pa2page.part.0>
ffffffffc02030d8:	e11fe0ef          	jal	ffffffffc0201ee8 <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02030dc:	00004697          	auipc	a3,0x4
ffffffffc02030e0:	aa468693          	addi	a3,a3,-1372 # ffffffffc0206b80 <etext+0x1112>
ffffffffc02030e4:	00003617          	auipc	a2,0x3
ffffffffc02030e8:	3ac60613          	addi	a2,a2,940 # ffffffffc0206490 <etext+0xa22>
ffffffffc02030ec:	22700593          	li	a1,551
ffffffffc02030f0:	00004517          	auipc	a0,0x4
ffffffffc02030f4:	86850513          	addi	a0,a0,-1944 # ffffffffc0206958 <etext+0xeea>
ffffffffc02030f8:	b90fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02030fc:	00004697          	auipc	a3,0x4
ffffffffc0203100:	9c468693          	addi	a3,a3,-1596 # ffffffffc0206ac0 <etext+0x1052>
ffffffffc0203104:	00003617          	auipc	a2,0x3
ffffffffc0203108:	38c60613          	addi	a2,a2,908 # ffffffffc0206490 <etext+0xa22>
ffffffffc020310c:	21a00593          	li	a1,538
ffffffffc0203110:	00004517          	auipc	a0,0x4
ffffffffc0203114:	84850513          	addi	a0,a0,-1976 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203118:	b70fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc020311c:	00004697          	auipc	a3,0x4
ffffffffc0203120:	96468693          	addi	a3,a3,-1692 # ffffffffc0206a80 <etext+0x1012>
ffffffffc0203124:	00003617          	auipc	a2,0x3
ffffffffc0203128:	36c60613          	addi	a2,a2,876 # ffffffffc0206490 <etext+0xa22>
ffffffffc020312c:	21900593          	li	a1,537
ffffffffc0203130:	00004517          	auipc	a0,0x4
ffffffffc0203134:	82850513          	addi	a0,a0,-2008 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203138:	b50fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020313c:	00004697          	auipc	a3,0x4
ffffffffc0203140:	92468693          	addi	a3,a3,-1756 # ffffffffc0206a60 <etext+0xff2>
ffffffffc0203144:	00003617          	auipc	a2,0x3
ffffffffc0203148:	34c60613          	addi	a2,a2,844 # ffffffffc0206490 <etext+0xa22>
ffffffffc020314c:	21800593          	li	a1,536
ffffffffc0203150:	00004517          	auipc	a0,0x4
ffffffffc0203154:	80850513          	addi	a0,a0,-2040 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203158:	b30fd0ef          	jal	ffffffffc0200488 <__panic>
    return KADDR(page2pa(page));
ffffffffc020315c:	00003617          	auipc	a2,0x3
ffffffffc0203160:	6e460613          	addi	a2,a2,1764 # ffffffffc0206840 <etext+0xdd2>
ffffffffc0203164:	07100593          	li	a1,113
ffffffffc0203168:	00003517          	auipc	a0,0x3
ffffffffc020316c:	70050513          	addi	a0,a0,1792 # ffffffffc0206868 <etext+0xdfa>
ffffffffc0203170:	b18fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0203174:	00004697          	auipc	a3,0x4
ffffffffc0203178:	b9c68693          	addi	a3,a3,-1124 # ffffffffc0206d10 <etext+0x12a2>
ffffffffc020317c:	00003617          	auipc	a2,0x3
ffffffffc0203180:	31460613          	addi	a2,a2,788 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203184:	24000593          	li	a1,576
ffffffffc0203188:	00003517          	auipc	a0,0x3
ffffffffc020318c:	7d050513          	addi	a0,a0,2000 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203190:	af8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203194:	00004697          	auipc	a3,0x4
ffffffffc0203198:	b3468693          	addi	a3,a3,-1228 # ffffffffc0206cc8 <etext+0x125a>
ffffffffc020319c:	00003617          	auipc	a2,0x3
ffffffffc02031a0:	2f460613          	addi	a2,a2,756 # ffffffffc0206490 <etext+0xa22>
ffffffffc02031a4:	23e00593          	li	a1,574
ffffffffc02031a8:	00003517          	auipc	a0,0x3
ffffffffc02031ac:	7b050513          	addi	a0,a0,1968 # ffffffffc0206958 <etext+0xeea>
ffffffffc02031b0:	ad8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc02031b4:	00004697          	auipc	a3,0x4
ffffffffc02031b8:	b4468693          	addi	a3,a3,-1212 # ffffffffc0206cf8 <etext+0x128a>
ffffffffc02031bc:	00003617          	auipc	a2,0x3
ffffffffc02031c0:	2d460613          	addi	a2,a2,724 # ffffffffc0206490 <etext+0xa22>
ffffffffc02031c4:	23d00593          	li	a1,573
ffffffffc02031c8:	00003517          	auipc	a0,0x3
ffffffffc02031cc:	79050513          	addi	a0,a0,1936 # ffffffffc0206958 <etext+0xeea>
ffffffffc02031d0:	ab8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc02031d4:	00004697          	auipc	a3,0x4
ffffffffc02031d8:	c0c68693          	addi	a3,a3,-1012 # ffffffffc0206de0 <etext+0x1372>
ffffffffc02031dc:	00003617          	auipc	a2,0x3
ffffffffc02031e0:	2b460613          	addi	a2,a2,692 # ffffffffc0206490 <etext+0xa22>
ffffffffc02031e4:	25b00593          	li	a1,603
ffffffffc02031e8:	00003517          	auipc	a0,0x3
ffffffffc02031ec:	77050513          	addi	a0,a0,1904 # ffffffffc0206958 <etext+0xeea>
ffffffffc02031f0:	a98fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02031f4:	00004697          	auipc	a3,0x4
ffffffffc02031f8:	b4c68693          	addi	a3,a3,-1204 # ffffffffc0206d40 <etext+0x12d2>
ffffffffc02031fc:	00003617          	auipc	a2,0x3
ffffffffc0203200:	29460613          	addi	a2,a2,660 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203204:	24800593          	li	a1,584
ffffffffc0203208:	00003517          	auipc	a0,0x3
ffffffffc020320c:	75050513          	addi	a0,a0,1872 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203210:	a78fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p) == 1);
ffffffffc0203214:	00004697          	auipc	a3,0x4
ffffffffc0203218:	c2468693          	addi	a3,a3,-988 # ffffffffc0206e38 <etext+0x13ca>
ffffffffc020321c:	00003617          	auipc	a2,0x3
ffffffffc0203220:	27460613          	addi	a2,a2,628 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203224:	26000593          	li	a1,608
ffffffffc0203228:	00003517          	auipc	a0,0x3
ffffffffc020322c:	73050513          	addi	a0,a0,1840 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203230:	a58fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0203234:	00004697          	auipc	a3,0x4
ffffffffc0203238:	bc468693          	addi	a3,a3,-1084 # ffffffffc0206df8 <etext+0x138a>
ffffffffc020323c:	00003617          	auipc	a2,0x3
ffffffffc0203240:	25460613          	addi	a2,a2,596 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203244:	25f00593          	li	a1,607
ffffffffc0203248:	00003517          	auipc	a0,0x3
ffffffffc020324c:	71050513          	addi	a0,a0,1808 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203250:	a38fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203254:	00004697          	auipc	a3,0x4
ffffffffc0203258:	a7468693          	addi	a3,a3,-1420 # ffffffffc0206cc8 <etext+0x125a>
ffffffffc020325c:	00003617          	auipc	a2,0x3
ffffffffc0203260:	23460613          	addi	a2,a2,564 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203264:	23a00593          	li	a1,570
ffffffffc0203268:	00003517          	auipc	a0,0x3
ffffffffc020326c:	6f050513          	addi	a0,a0,1776 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203270:	a18fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203274:	00004697          	auipc	a3,0x4
ffffffffc0203278:	8f468693          	addi	a3,a3,-1804 # ffffffffc0206b68 <etext+0x10fa>
ffffffffc020327c:	00003617          	auipc	a2,0x3
ffffffffc0203280:	21460613          	addi	a2,a2,532 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203284:	23900593          	li	a1,569
ffffffffc0203288:	00003517          	auipc	a0,0x3
ffffffffc020328c:	6d050513          	addi	a0,a0,1744 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203290:	9f8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0203294:	00004697          	auipc	a3,0x4
ffffffffc0203298:	a4c68693          	addi	a3,a3,-1460 # ffffffffc0206ce0 <etext+0x1272>
ffffffffc020329c:	00003617          	auipc	a2,0x3
ffffffffc02032a0:	1f460613          	addi	a2,a2,500 # ffffffffc0206490 <etext+0xa22>
ffffffffc02032a4:	23600593          	li	a1,566
ffffffffc02032a8:	00003517          	auipc	a0,0x3
ffffffffc02032ac:	6b050513          	addi	a0,a0,1712 # ffffffffc0206958 <etext+0xeea>
ffffffffc02032b0:	9d8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02032b4:	00004697          	auipc	a3,0x4
ffffffffc02032b8:	89c68693          	addi	a3,a3,-1892 # ffffffffc0206b50 <etext+0x10e2>
ffffffffc02032bc:	00003617          	auipc	a2,0x3
ffffffffc02032c0:	1d460613          	addi	a2,a2,468 # ffffffffc0206490 <etext+0xa22>
ffffffffc02032c4:	23500593          	li	a1,565
ffffffffc02032c8:	00003517          	auipc	a0,0x3
ffffffffc02032cc:	69050513          	addi	a0,a0,1680 # ffffffffc0206958 <etext+0xeea>
ffffffffc02032d0:	9b8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02032d4:	00004697          	auipc	a3,0x4
ffffffffc02032d8:	91c68693          	addi	a3,a3,-1764 # ffffffffc0206bf0 <etext+0x1182>
ffffffffc02032dc:	00003617          	auipc	a2,0x3
ffffffffc02032e0:	1b460613          	addi	a2,a2,436 # ffffffffc0206490 <etext+0xa22>
ffffffffc02032e4:	23400593          	li	a1,564
ffffffffc02032e8:	00003517          	auipc	a0,0x3
ffffffffc02032ec:	67050513          	addi	a0,a0,1648 # ffffffffc0206958 <etext+0xeea>
ffffffffc02032f0:	998fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02032f4:	00004697          	auipc	a3,0x4
ffffffffc02032f8:	9d468693          	addi	a3,a3,-1580 # ffffffffc0206cc8 <etext+0x125a>
ffffffffc02032fc:	00003617          	auipc	a2,0x3
ffffffffc0203300:	19460613          	addi	a2,a2,404 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203304:	23300593          	li	a1,563
ffffffffc0203308:	00003517          	auipc	a0,0x3
ffffffffc020330c:	65050513          	addi	a0,a0,1616 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203310:	978fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0203314:	00004697          	auipc	a3,0x4
ffffffffc0203318:	99c68693          	addi	a3,a3,-1636 # ffffffffc0206cb0 <etext+0x1242>
ffffffffc020331c:	00003617          	auipc	a2,0x3
ffffffffc0203320:	17460613          	addi	a2,a2,372 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203324:	23200593          	li	a1,562
ffffffffc0203328:	00003517          	auipc	a0,0x3
ffffffffc020332c:	63050513          	addi	a0,a0,1584 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203330:	958fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0203334:	00004697          	auipc	a3,0x4
ffffffffc0203338:	94c68693          	addi	a3,a3,-1716 # ffffffffc0206c80 <etext+0x1212>
ffffffffc020333c:	00003617          	auipc	a2,0x3
ffffffffc0203340:	15460613          	addi	a2,a2,340 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203344:	23100593          	li	a1,561
ffffffffc0203348:	00003517          	auipc	a0,0x3
ffffffffc020334c:	61050513          	addi	a0,a0,1552 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203350:	938fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0203354:	00004697          	auipc	a3,0x4
ffffffffc0203358:	91468693          	addi	a3,a3,-1772 # ffffffffc0206c68 <etext+0x11fa>
ffffffffc020335c:	00003617          	auipc	a2,0x3
ffffffffc0203360:	13460613          	addi	a2,a2,308 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203364:	22f00593          	li	a1,559
ffffffffc0203368:	00003517          	auipc	a0,0x3
ffffffffc020336c:	5f050513          	addi	a0,a0,1520 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203370:	918fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0203374:	00004697          	auipc	a3,0x4
ffffffffc0203378:	8d468693          	addi	a3,a3,-1836 # ffffffffc0206c48 <etext+0x11da>
ffffffffc020337c:	00003617          	auipc	a2,0x3
ffffffffc0203380:	11460613          	addi	a2,a2,276 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203384:	22e00593          	li	a1,558
ffffffffc0203388:	00003517          	auipc	a0,0x3
ffffffffc020338c:	5d050513          	addi	a0,a0,1488 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203390:	8f8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(*ptep & PTE_W);
ffffffffc0203394:	00004697          	auipc	a3,0x4
ffffffffc0203398:	8a468693          	addi	a3,a3,-1884 # ffffffffc0206c38 <etext+0x11ca>
ffffffffc020339c:	00003617          	auipc	a2,0x3
ffffffffc02033a0:	0f460613          	addi	a2,a2,244 # ffffffffc0206490 <etext+0xa22>
ffffffffc02033a4:	22d00593          	li	a1,557
ffffffffc02033a8:	00003517          	auipc	a0,0x3
ffffffffc02033ac:	5b050513          	addi	a0,a0,1456 # ffffffffc0206958 <etext+0xeea>
ffffffffc02033b0:	8d8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(*ptep & PTE_U);
ffffffffc02033b4:	00004697          	auipc	a3,0x4
ffffffffc02033b8:	87468693          	addi	a3,a3,-1932 # ffffffffc0206c28 <etext+0x11ba>
ffffffffc02033bc:	00003617          	auipc	a2,0x3
ffffffffc02033c0:	0d460613          	addi	a2,a2,212 # ffffffffc0206490 <etext+0xa22>
ffffffffc02033c4:	22c00593          	li	a1,556
ffffffffc02033c8:	00003517          	auipc	a0,0x3
ffffffffc02033cc:	59050513          	addi	a0,a0,1424 # ffffffffc0206958 <etext+0xeea>
ffffffffc02033d0:	8b8fd0ef          	jal	ffffffffc0200488 <__panic>
        panic("DTB memory info not available");
ffffffffc02033d4:	00003617          	auipc	a2,0x3
ffffffffc02033d8:	5f460613          	addi	a2,a2,1524 # ffffffffc02069c8 <etext+0xf5a>
ffffffffc02033dc:	06500593          	li	a1,101
ffffffffc02033e0:	00003517          	auipc	a0,0x3
ffffffffc02033e4:	57850513          	addi	a0,a0,1400 # ffffffffc0206958 <etext+0xeea>
ffffffffc02033e8:	8a0fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02033ec:	00004697          	auipc	a3,0x4
ffffffffc02033f0:	95468693          	addi	a3,a3,-1708 # ffffffffc0206d40 <etext+0x12d2>
ffffffffc02033f4:	00003617          	auipc	a2,0x3
ffffffffc02033f8:	09c60613          	addi	a2,a2,156 # ffffffffc0206490 <etext+0xa22>
ffffffffc02033fc:	27200593          	li	a1,626
ffffffffc0203400:	00003517          	auipc	a0,0x3
ffffffffc0203404:	55850513          	addi	a0,a0,1368 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203408:	880fd0ef          	jal	ffffffffc0200488 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020340c:	00003697          	auipc	a3,0x3
ffffffffc0203410:	7e468693          	addi	a3,a3,2020 # ffffffffc0206bf0 <etext+0x1182>
ffffffffc0203414:	00003617          	auipc	a2,0x3
ffffffffc0203418:	07c60613          	addi	a2,a2,124 # ffffffffc0206490 <etext+0xa22>
ffffffffc020341c:	22b00593          	li	a1,555
ffffffffc0203420:	00003517          	auipc	a0,0x3
ffffffffc0203424:	53850513          	addi	a0,a0,1336 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203428:	860fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020342c:	00003697          	auipc	a3,0x3
ffffffffc0203430:	78468693          	addi	a3,a3,1924 # ffffffffc0206bb0 <etext+0x1142>
ffffffffc0203434:	00003617          	auipc	a2,0x3
ffffffffc0203438:	05c60613          	addi	a2,a2,92 # ffffffffc0206490 <etext+0xa22>
ffffffffc020343c:	22a00593          	li	a1,554
ffffffffc0203440:	00003517          	auipc	a0,0x3
ffffffffc0203444:	51850513          	addi	a0,a0,1304 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203448:	840fd0ef          	jal	ffffffffc0200488 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020344c:	86d6                	mv	a3,s5
ffffffffc020344e:	00003617          	auipc	a2,0x3
ffffffffc0203452:	3f260613          	addi	a2,a2,1010 # ffffffffc0206840 <etext+0xdd2>
ffffffffc0203456:	22600593          	li	a1,550
ffffffffc020345a:	00003517          	auipc	a0,0x3
ffffffffc020345e:	4fe50513          	addi	a0,a0,1278 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203462:	826fd0ef          	jal	ffffffffc0200488 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203466:	00003617          	auipc	a2,0x3
ffffffffc020346a:	3da60613          	addi	a2,a2,986 # ffffffffc0206840 <etext+0xdd2>
ffffffffc020346e:	22500593          	li	a1,549
ffffffffc0203472:	00003517          	auipc	a0,0x3
ffffffffc0203476:	4e650513          	addi	a0,a0,1254 # ffffffffc0206958 <etext+0xeea>
ffffffffc020347a:	80efd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020347e:	00003697          	auipc	a3,0x3
ffffffffc0203482:	6ea68693          	addi	a3,a3,1770 # ffffffffc0206b68 <etext+0x10fa>
ffffffffc0203486:	00003617          	auipc	a2,0x3
ffffffffc020348a:	00a60613          	addi	a2,a2,10 # ffffffffc0206490 <etext+0xa22>
ffffffffc020348e:	22300593          	li	a1,547
ffffffffc0203492:	00003517          	auipc	a0,0x3
ffffffffc0203496:	4c650513          	addi	a0,a0,1222 # ffffffffc0206958 <etext+0xeea>
ffffffffc020349a:	feffc0ef          	jal	ffffffffc0200488 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020349e:	00003697          	auipc	a3,0x3
ffffffffc02034a2:	6b268693          	addi	a3,a3,1714 # ffffffffc0206b50 <etext+0x10e2>
ffffffffc02034a6:	00003617          	auipc	a2,0x3
ffffffffc02034aa:	fea60613          	addi	a2,a2,-22 # ffffffffc0206490 <etext+0xa22>
ffffffffc02034ae:	22200593          	li	a1,546
ffffffffc02034b2:	00003517          	auipc	a0,0x3
ffffffffc02034b6:	4a650513          	addi	a0,a0,1190 # ffffffffc0206958 <etext+0xeea>
ffffffffc02034ba:	fcffc0ef          	jal	ffffffffc0200488 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02034be:	00004697          	auipc	a3,0x4
ffffffffc02034c2:	a4268693          	addi	a3,a3,-1470 # ffffffffc0206f00 <etext+0x1492>
ffffffffc02034c6:	00003617          	auipc	a2,0x3
ffffffffc02034ca:	fca60613          	addi	a2,a2,-54 # ffffffffc0206490 <etext+0xa22>
ffffffffc02034ce:	26900593          	li	a1,617
ffffffffc02034d2:	00003517          	auipc	a0,0x3
ffffffffc02034d6:	48650513          	addi	a0,a0,1158 # ffffffffc0206958 <etext+0xeea>
ffffffffc02034da:	faffc0ef          	jal	ffffffffc0200488 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02034de:	00004697          	auipc	a3,0x4
ffffffffc02034e2:	9ea68693          	addi	a3,a3,-1558 # ffffffffc0206ec8 <etext+0x145a>
ffffffffc02034e6:	00003617          	auipc	a2,0x3
ffffffffc02034ea:	faa60613          	addi	a2,a2,-86 # ffffffffc0206490 <etext+0xa22>
ffffffffc02034ee:	26600593          	li	a1,614
ffffffffc02034f2:	00003517          	auipc	a0,0x3
ffffffffc02034f6:	46650513          	addi	a0,a0,1126 # ffffffffc0206958 <etext+0xeea>
ffffffffc02034fa:	f8ffc0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p) == 2);
ffffffffc02034fe:	00004697          	auipc	a3,0x4
ffffffffc0203502:	99a68693          	addi	a3,a3,-1638 # ffffffffc0206e98 <etext+0x142a>
ffffffffc0203506:	00003617          	auipc	a2,0x3
ffffffffc020350a:	f8a60613          	addi	a2,a2,-118 # ffffffffc0206490 <etext+0xa22>
ffffffffc020350e:	26200593          	li	a1,610
ffffffffc0203512:	00003517          	auipc	a0,0x3
ffffffffc0203516:	44650513          	addi	a0,a0,1094 # ffffffffc0206958 <etext+0xeea>
ffffffffc020351a:	f6ffc0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc020351e:	00004697          	auipc	a3,0x4
ffffffffc0203522:	93268693          	addi	a3,a3,-1742 # ffffffffc0206e50 <etext+0x13e2>
ffffffffc0203526:	00003617          	auipc	a2,0x3
ffffffffc020352a:	f6a60613          	addi	a2,a2,-150 # ffffffffc0206490 <etext+0xa22>
ffffffffc020352e:	26100593          	li	a1,609
ffffffffc0203532:	00003517          	auipc	a0,0x3
ffffffffc0203536:	42650513          	addi	a0,a0,1062 # ffffffffc0206958 <etext+0xeea>
ffffffffc020353a:	f4ffc0ef          	jal	ffffffffc0200488 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020353e:	00003617          	auipc	a2,0x3
ffffffffc0203542:	3aa60613          	addi	a2,a2,938 # ffffffffc02068e8 <etext+0xe7a>
ffffffffc0203546:	0c900593          	li	a1,201
ffffffffc020354a:	00003517          	auipc	a0,0x3
ffffffffc020354e:	40e50513          	addi	a0,a0,1038 # ffffffffc0206958 <etext+0xeea>
ffffffffc0203552:	f37fc0ef          	jal	ffffffffc0200488 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203556:	00003617          	auipc	a2,0x3
ffffffffc020355a:	39260613          	addi	a2,a2,914 # ffffffffc02068e8 <etext+0xe7a>
ffffffffc020355e:	08100593          	li	a1,129
ffffffffc0203562:	00003517          	auipc	a0,0x3
ffffffffc0203566:	3f650513          	addi	a0,a0,1014 # ffffffffc0206958 <etext+0xeea>
ffffffffc020356a:	f1ffc0ef          	jal	ffffffffc0200488 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc020356e:	00003697          	auipc	a3,0x3
ffffffffc0203572:	5b268693          	addi	a3,a3,1458 # ffffffffc0206b20 <etext+0x10b2>
ffffffffc0203576:	00003617          	auipc	a2,0x3
ffffffffc020357a:	f1a60613          	addi	a2,a2,-230 # ffffffffc0206490 <etext+0xa22>
ffffffffc020357e:	22100593          	li	a1,545
ffffffffc0203582:	00003517          	auipc	a0,0x3
ffffffffc0203586:	3d650513          	addi	a0,a0,982 # ffffffffc0206958 <etext+0xeea>
ffffffffc020358a:	efffc0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc020358e:	00003697          	auipc	a3,0x3
ffffffffc0203592:	56268693          	addi	a3,a3,1378 # ffffffffc0206af0 <etext+0x1082>
ffffffffc0203596:	00003617          	auipc	a2,0x3
ffffffffc020359a:	efa60613          	addi	a2,a2,-262 # ffffffffc0206490 <etext+0xa22>
ffffffffc020359e:	21e00593          	li	a1,542
ffffffffc02035a2:	00003517          	auipc	a0,0x3
ffffffffc02035a6:	3b650513          	addi	a0,a0,950 # ffffffffc0206958 <etext+0xeea>
ffffffffc02035aa:	edffc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02035ae <tlb_invalidate>:
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02035ae:	12058073          	sfence.vma	a1
}
ffffffffc02035b2:	8082                	ret

ffffffffc02035b4 <pgdir_alloc_page>:
{
ffffffffc02035b4:	7179                	addi	sp,sp,-48
ffffffffc02035b6:	ec26                	sd	s1,24(sp)
ffffffffc02035b8:	e44e                	sd	s3,8(sp)
ffffffffc02035ba:	e052                	sd	s4,0(sp)
ffffffffc02035bc:	f406                	sd	ra,40(sp)
ffffffffc02035be:	f022                	sd	s0,32(sp)
ffffffffc02035c0:	e84a                	sd	s2,16(sp)
ffffffffc02035c2:	8a2a                	mv	s4,a0
ffffffffc02035c4:	84ae                	mv	s1,a1
ffffffffc02035c6:	89b2                	mv	s3,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02035c8:	100027f3          	csrr	a5,sstatus
ffffffffc02035cc:	8b89                	andi	a5,a5,2
ffffffffc02035ce:	e3a9                	bnez	a5,ffffffffc0203610 <pgdir_alloc_page+0x5c>
        page = pmm_manager->alloc_pages(n);
ffffffffc02035d0:	0009c917          	auipc	s2,0x9c
ffffffffc02035d4:	85890913          	addi	s2,s2,-1960 # ffffffffc029ee28 <pmm_manager>
ffffffffc02035d8:	00093783          	ld	a5,0(s2)
ffffffffc02035dc:	4505                	li	a0,1
ffffffffc02035de:	6f9c                	ld	a5,24(a5)
ffffffffc02035e0:	9782                	jalr	a5
ffffffffc02035e2:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc02035e4:	c429                	beqz	s0,ffffffffc020362e <pgdir_alloc_page+0x7a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc02035e6:	86ce                	mv	a3,s3
ffffffffc02035e8:	8626                	mv	a2,s1
ffffffffc02035ea:	85a2                	mv	a1,s0
ffffffffc02035ec:	8552                	mv	a0,s4
ffffffffc02035ee:	a80ff0ef          	jal	ffffffffc020286e <page_insert>
ffffffffc02035f2:	e121                	bnez	a0,ffffffffc0203632 <pgdir_alloc_page+0x7e>
        assert(page_ref(page) == 1);
ffffffffc02035f4:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc02035f6:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc02035f8:	4785                	li	a5,1
ffffffffc02035fa:	06f71463          	bne	a4,a5,ffffffffc0203662 <pgdir_alloc_page+0xae>
}
ffffffffc02035fe:	70a2                	ld	ra,40(sp)
ffffffffc0203600:	8522                	mv	a0,s0
ffffffffc0203602:	7402                	ld	s0,32(sp)
ffffffffc0203604:	64e2                	ld	s1,24(sp)
ffffffffc0203606:	6942                	ld	s2,16(sp)
ffffffffc0203608:	69a2                	ld	s3,8(sp)
ffffffffc020360a:	6a02                	ld	s4,0(sp)
ffffffffc020360c:	6145                	addi	sp,sp,48
ffffffffc020360e:	8082                	ret
        intr_disable();
ffffffffc0203610:	b6afd0ef          	jal	ffffffffc020097a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203614:	0009c917          	auipc	s2,0x9c
ffffffffc0203618:	81490913          	addi	s2,s2,-2028 # ffffffffc029ee28 <pmm_manager>
ffffffffc020361c:	00093783          	ld	a5,0(s2)
ffffffffc0203620:	4505                	li	a0,1
ffffffffc0203622:	6f9c                	ld	a5,24(a5)
ffffffffc0203624:	9782                	jalr	a5
ffffffffc0203626:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203628:	b4cfd0ef          	jal	ffffffffc0200974 <intr_enable>
    if (page != NULL)
ffffffffc020362c:	fc4d                	bnez	s0,ffffffffc02035e6 <pgdir_alloc_page+0x32>
            return NULL;
ffffffffc020362e:	4401                	li	s0,0
ffffffffc0203630:	b7f9                	j	ffffffffc02035fe <pgdir_alloc_page+0x4a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203632:	100027f3          	csrr	a5,sstatus
ffffffffc0203636:	8b89                	andi	a5,a5,2
ffffffffc0203638:	eb89                	bnez	a5,ffffffffc020364a <pgdir_alloc_page+0x96>
        pmm_manager->free_pages(base, n);
ffffffffc020363a:	00093783          	ld	a5,0(s2)
ffffffffc020363e:	8522                	mv	a0,s0
ffffffffc0203640:	4585                	li	a1,1
ffffffffc0203642:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203644:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203646:	9782                	jalr	a5
    if (flag)
ffffffffc0203648:	bf5d                	j	ffffffffc02035fe <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc020364a:	b30fd0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc020364e:	00093783          	ld	a5,0(s2)
ffffffffc0203652:	8522                	mv	a0,s0
ffffffffc0203654:	4585                	li	a1,1
ffffffffc0203656:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203658:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc020365a:	9782                	jalr	a5
        intr_enable();
ffffffffc020365c:	b18fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0203660:	bf79                	j	ffffffffc02035fe <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc0203662:	00004697          	auipc	a3,0x4
ffffffffc0203666:	8e668693          	addi	a3,a3,-1818 # ffffffffc0206f48 <etext+0x14da>
ffffffffc020366a:	00003617          	auipc	a2,0x3
ffffffffc020366e:	e2660613          	addi	a2,a2,-474 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203672:	1ff00593          	li	a1,511
ffffffffc0203676:	00003517          	auipc	a0,0x3
ffffffffc020367a:	2e250513          	addi	a0,a0,738 # ffffffffc0206958 <etext+0xeea>
ffffffffc020367e:	e0bfc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0203682 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203682:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0203684:	00004697          	auipc	a3,0x4
ffffffffc0203688:	8dc68693          	addi	a3,a3,-1828 # ffffffffc0206f60 <etext+0x14f2>
ffffffffc020368c:	00003617          	auipc	a2,0x3
ffffffffc0203690:	e0460613          	addi	a2,a2,-508 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203694:	07400593          	li	a1,116
ffffffffc0203698:	00004517          	auipc	a0,0x4
ffffffffc020369c:	8e850513          	addi	a0,a0,-1816 # ffffffffc0206f80 <etext+0x1512>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02036a0:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02036a2:	de7fc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02036a6 <mm_create>:
{
ffffffffc02036a6:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036a8:	04000513          	li	a0,64
{
ffffffffc02036ac:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036ae:	e7efe0ef          	jal	ffffffffc0201d2c <kmalloc>
    if (mm != NULL)
ffffffffc02036b2:	cd19                	beqz	a0,ffffffffc02036d0 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc02036b4:	e508                	sd	a0,8(a0)
ffffffffc02036b6:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02036b8:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02036bc:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02036c0:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02036c4:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc02036c8:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc02036cc:	02053c23          	sd	zero,56(a0)
}
ffffffffc02036d0:	60a2                	ld	ra,8(sp)
ffffffffc02036d2:	0141                	addi	sp,sp,16
ffffffffc02036d4:	8082                	ret

ffffffffc02036d6 <find_vma>:
{
ffffffffc02036d6:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc02036d8:	c505                	beqz	a0,ffffffffc0203700 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc02036da:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02036dc:	c501                	beqz	a0,ffffffffc02036e4 <find_vma+0xe>
ffffffffc02036de:	651c                	ld	a5,8(a0)
ffffffffc02036e0:	02f5f663          	bgeu	a1,a5,ffffffffc020370c <find_vma+0x36>
    return listelm->next;
ffffffffc02036e4:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc02036e6:	00f68d63          	beq	a3,a5,ffffffffc0203700 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc02036ea:	fe87b703          	ld	a4,-24(a5)
ffffffffc02036ee:	00e5e663          	bltu	a1,a4,ffffffffc02036fa <find_vma+0x24>
ffffffffc02036f2:	ff07b703          	ld	a4,-16(a5)
ffffffffc02036f6:	00e5e763          	bltu	a1,a4,ffffffffc0203704 <find_vma+0x2e>
ffffffffc02036fa:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc02036fc:	fef697e3          	bne	a3,a5,ffffffffc02036ea <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0203700:	4501                	li	a0,0
}
ffffffffc0203702:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0203704:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0203708:	ea88                	sd	a0,16(a3)
ffffffffc020370a:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020370c:	691c                	ld	a5,16(a0)
ffffffffc020370e:	fcf5fbe3          	bgeu	a1,a5,ffffffffc02036e4 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0203712:	ea88                	sd	a0,16(a3)
ffffffffc0203714:	8082                	ret

ffffffffc0203716 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203716:	6590                	ld	a2,8(a1)
ffffffffc0203718:	0105b803          	ld	a6,16(a1) # fffffffffff80010 <end+0x3fce1198>
{
ffffffffc020371c:	1141                	addi	sp,sp,-16
ffffffffc020371e:	e406                	sd	ra,8(sp)
ffffffffc0203720:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203722:	01066763          	bltu	a2,a6,ffffffffc0203730 <insert_vma_struct+0x1a>
ffffffffc0203726:	a085                	j	ffffffffc0203786 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203728:	fe87b703          	ld	a4,-24(a5)
ffffffffc020372c:	04e66863          	bltu	a2,a4,ffffffffc020377c <insert_vma_struct+0x66>
ffffffffc0203730:	86be                	mv	a3,a5
ffffffffc0203732:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0203734:	fef51ae3          	bne	a0,a5,ffffffffc0203728 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203738:	02a68463          	beq	a3,a0,ffffffffc0203760 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc020373c:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203740:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203744:	08e8f163          	bgeu	a7,a4,ffffffffc02037c6 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203748:	04e66f63          	bltu	a2,a4,ffffffffc02037a6 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc020374c:	00f50a63          	beq	a0,a5,ffffffffc0203760 <insert_vma_struct+0x4a>
ffffffffc0203750:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203754:	05076963          	bltu	a4,a6,ffffffffc02037a6 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0203758:	ff07b603          	ld	a2,-16(a5)
ffffffffc020375c:	02c77363          	bgeu	a4,a2,ffffffffc0203782 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0203760:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0203762:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0203764:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0203768:	e390                	sd	a2,0(a5)
ffffffffc020376a:	e690                	sd	a2,8(a3)
}
ffffffffc020376c:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc020376e:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0203770:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0203772:	0017079b          	addiw	a5,a4,1 # fffffffffff80001 <end+0x3fce1189>
ffffffffc0203776:	d11c                	sw	a5,32(a0)
}
ffffffffc0203778:	0141                	addi	sp,sp,16
ffffffffc020377a:	8082                	ret
    if (le_prev != list)
ffffffffc020377c:	fca690e3          	bne	a3,a0,ffffffffc020373c <insert_vma_struct+0x26>
ffffffffc0203780:	bfd1                	j	ffffffffc0203754 <insert_vma_struct+0x3e>
ffffffffc0203782:	f01ff0ef          	jal	ffffffffc0203682 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203786:	00004697          	auipc	a3,0x4
ffffffffc020378a:	80a68693          	addi	a3,a3,-2038 # ffffffffc0206f90 <etext+0x1522>
ffffffffc020378e:	00003617          	auipc	a2,0x3
ffffffffc0203792:	d0260613          	addi	a2,a2,-766 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203796:	07a00593          	li	a1,122
ffffffffc020379a:	00003517          	auipc	a0,0x3
ffffffffc020379e:	7e650513          	addi	a0,a0,2022 # ffffffffc0206f80 <etext+0x1512>
ffffffffc02037a2:	ce7fc0ef          	jal	ffffffffc0200488 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02037a6:	00004697          	auipc	a3,0x4
ffffffffc02037aa:	82a68693          	addi	a3,a3,-2006 # ffffffffc0206fd0 <etext+0x1562>
ffffffffc02037ae:	00003617          	auipc	a2,0x3
ffffffffc02037b2:	ce260613          	addi	a2,a2,-798 # ffffffffc0206490 <etext+0xa22>
ffffffffc02037b6:	07300593          	li	a1,115
ffffffffc02037ba:	00003517          	auipc	a0,0x3
ffffffffc02037be:	7c650513          	addi	a0,a0,1990 # ffffffffc0206f80 <etext+0x1512>
ffffffffc02037c2:	cc7fc0ef          	jal	ffffffffc0200488 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc02037c6:	00003697          	auipc	a3,0x3
ffffffffc02037ca:	7ea68693          	addi	a3,a3,2026 # ffffffffc0206fb0 <etext+0x1542>
ffffffffc02037ce:	00003617          	auipc	a2,0x3
ffffffffc02037d2:	cc260613          	addi	a2,a2,-830 # ffffffffc0206490 <etext+0xa22>
ffffffffc02037d6:	07200593          	li	a1,114
ffffffffc02037da:	00003517          	auipc	a0,0x3
ffffffffc02037de:	7a650513          	addi	a0,a0,1958 # ffffffffc0206f80 <etext+0x1512>
ffffffffc02037e2:	ca7fc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02037e6 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc02037e6:	591c                	lw	a5,48(a0)
{
ffffffffc02037e8:	1141                	addi	sp,sp,-16
ffffffffc02037ea:	e406                	sd	ra,8(sp)
ffffffffc02037ec:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc02037ee:	e78d                	bnez	a5,ffffffffc0203818 <mm_destroy+0x32>
ffffffffc02037f0:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc02037f2:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc02037f4:	00a40c63          	beq	s0,a0,ffffffffc020380c <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc02037f8:	6118                	ld	a4,0(a0)
ffffffffc02037fa:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc02037fc:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc02037fe:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203800:	e398                	sd	a4,0(a5)
ffffffffc0203802:	dd4fe0ef          	jal	ffffffffc0201dd6 <kfree>
    return listelm->next;
ffffffffc0203806:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0203808:	fea418e3          	bne	s0,a0,ffffffffc02037f8 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc020380c:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc020380e:	6402                	ld	s0,0(sp)
ffffffffc0203810:	60a2                	ld	ra,8(sp)
ffffffffc0203812:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0203814:	dc2fe06f          	j	ffffffffc0201dd6 <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0203818:	00003697          	auipc	a3,0x3
ffffffffc020381c:	7d868693          	addi	a3,a3,2008 # ffffffffc0206ff0 <etext+0x1582>
ffffffffc0203820:	00003617          	auipc	a2,0x3
ffffffffc0203824:	c7060613          	addi	a2,a2,-912 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203828:	09e00593          	li	a1,158
ffffffffc020382c:	00003517          	auipc	a0,0x3
ffffffffc0203830:	75450513          	addi	a0,a0,1876 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203834:	c55fc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0203838 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203838:	6785                	lui	a5,0x1
ffffffffc020383a:	17fd                	addi	a5,a5,-1 # fff <_binary_obj___user_softint_out_size-0x7599>
{
ffffffffc020383c:	7139                	addi	sp,sp,-64
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc020383e:	787d                	lui	a6,0xfffff
ffffffffc0203840:	963e                	add	a2,a2,a5
{
ffffffffc0203842:	f822                	sd	s0,48(sp)
ffffffffc0203844:	f426                	sd	s1,40(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203846:	962e                	add	a2,a2,a1
{
ffffffffc0203848:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc020384a:	0105f4b3          	and	s1,a1,a6
    if (!USER_ACCESS(start, end))
ffffffffc020384e:	002007b7          	lui	a5,0x200
ffffffffc0203852:	01067433          	and	s0,a2,a6
ffffffffc0203856:	08f4e363          	bltu	s1,a5,ffffffffc02038dc <mm_map+0xa4>
ffffffffc020385a:	0884f163          	bgeu	s1,s0,ffffffffc02038dc <mm_map+0xa4>
ffffffffc020385e:	4785                	li	a5,1
ffffffffc0203860:	07fe                	slli	a5,a5,0x1f
ffffffffc0203862:	0687ed63          	bltu	a5,s0,ffffffffc02038dc <mm_map+0xa4>
ffffffffc0203866:	ec4e                	sd	s3,24(sp)
ffffffffc0203868:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc020386a:	c93d                	beqz	a0,ffffffffc02038e0 <mm_map+0xa8>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc020386c:	85a6                	mv	a1,s1
ffffffffc020386e:	e852                	sd	s4,16(sp)
ffffffffc0203870:	e456                	sd	s5,8(sp)
ffffffffc0203872:	8a3a                	mv	s4,a4
ffffffffc0203874:	8ab6                	mv	s5,a3
ffffffffc0203876:	e61ff0ef          	jal	ffffffffc02036d6 <find_vma>
ffffffffc020387a:	c501                	beqz	a0,ffffffffc0203882 <mm_map+0x4a>
ffffffffc020387c:	651c                	ld	a5,8(a0)
ffffffffc020387e:	0487ec63          	bltu	a5,s0,ffffffffc02038d6 <mm_map+0x9e>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203882:	03000513          	li	a0,48
ffffffffc0203886:	f04a                	sd	s2,32(sp)
ffffffffc0203888:	ca4fe0ef          	jal	ffffffffc0201d2c <kmalloc>
ffffffffc020388c:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc020388e:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203890:	02090a63          	beqz	s2,ffffffffc02038c4 <mm_map+0x8c>
        vma->vm_start = vm_start;
ffffffffc0203894:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc0203898:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc020389c:	01592c23          	sw	s5,24(s2)

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc02038a0:	85ca                	mv	a1,s2
ffffffffc02038a2:	854e                	mv	a0,s3
ffffffffc02038a4:	e73ff0ef          	jal	ffffffffc0203716 <insert_vma_struct>
    if (vma_store != NULL)
ffffffffc02038a8:	000a0463          	beqz	s4,ffffffffc02038b0 <mm_map+0x78>
    {
        *vma_store = vma;
ffffffffc02038ac:	012a3023          	sd	s2,0(s4)
ffffffffc02038b0:	7902                	ld	s2,32(sp)
ffffffffc02038b2:	69e2                	ld	s3,24(sp)
ffffffffc02038b4:	6a42                	ld	s4,16(sp)
ffffffffc02038b6:	6aa2                	ld	s5,8(sp)
    }
    ret = 0;
ffffffffc02038b8:	4501                	li	a0,0

out:
    return ret;
}
ffffffffc02038ba:	70e2                	ld	ra,56(sp)
ffffffffc02038bc:	7442                	ld	s0,48(sp)
ffffffffc02038be:	74a2                	ld	s1,40(sp)
ffffffffc02038c0:	6121                	addi	sp,sp,64
ffffffffc02038c2:	8082                	ret
ffffffffc02038c4:	70e2                	ld	ra,56(sp)
ffffffffc02038c6:	7442                	ld	s0,48(sp)
ffffffffc02038c8:	7902                	ld	s2,32(sp)
ffffffffc02038ca:	69e2                	ld	s3,24(sp)
ffffffffc02038cc:	6a42                	ld	s4,16(sp)
ffffffffc02038ce:	6aa2                	ld	s5,8(sp)
ffffffffc02038d0:	74a2                	ld	s1,40(sp)
ffffffffc02038d2:	6121                	addi	sp,sp,64
ffffffffc02038d4:	8082                	ret
ffffffffc02038d6:	69e2                	ld	s3,24(sp)
ffffffffc02038d8:	6a42                	ld	s4,16(sp)
ffffffffc02038da:	6aa2                	ld	s5,8(sp)
        return -E_INVAL;
ffffffffc02038dc:	5575                	li	a0,-3
ffffffffc02038de:	bff1                	j	ffffffffc02038ba <mm_map+0x82>
    assert(mm != NULL);
ffffffffc02038e0:	00003697          	auipc	a3,0x3
ffffffffc02038e4:	72868693          	addi	a3,a3,1832 # ffffffffc0207008 <etext+0x159a>
ffffffffc02038e8:	00003617          	auipc	a2,0x3
ffffffffc02038ec:	ba860613          	addi	a2,a2,-1112 # ffffffffc0206490 <etext+0xa22>
ffffffffc02038f0:	0b300593          	li	a1,179
ffffffffc02038f4:	00003517          	auipc	a0,0x3
ffffffffc02038f8:	68c50513          	addi	a0,a0,1676 # ffffffffc0206f80 <etext+0x1512>
ffffffffc02038fc:	f04a                	sd	s2,32(sp)
ffffffffc02038fe:	e852                	sd	s4,16(sp)
ffffffffc0203900:	e456                	sd	s5,8(sp)
ffffffffc0203902:	b87fc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0203906 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0203906:	7139                	addi	sp,sp,-64
ffffffffc0203908:	fc06                	sd	ra,56(sp)
ffffffffc020390a:	f822                	sd	s0,48(sp)
ffffffffc020390c:	f426                	sd	s1,40(sp)
ffffffffc020390e:	f04a                	sd	s2,32(sp)
ffffffffc0203910:	ec4e                	sd	s3,24(sp)
ffffffffc0203912:	e852                	sd	s4,16(sp)
ffffffffc0203914:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0203916:	c525                	beqz	a0,ffffffffc020397e <dup_mmap+0x78>
ffffffffc0203918:	892a                	mv	s2,a0
ffffffffc020391a:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc020391c:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc020391e:	c1a5                	beqz	a1,ffffffffc020397e <dup_mmap+0x78>
    return listelm->prev;
ffffffffc0203920:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203922:	04848c63          	beq	s1,s0,ffffffffc020397a <dup_mmap+0x74>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203926:	03000513          	li	a0,48
    {
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc020392a:	fe843a83          	ld	s5,-24(s0) # ffffffffc01fffe8 <_binary_obj___user_exit_out_size+0xffffffffc01f64e0>
ffffffffc020392e:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203932:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203936:	bf6fe0ef          	jal	ffffffffc0201d2c <kmalloc>
ffffffffc020393a:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc020393c:	c50d                	beqz	a0,ffffffffc0203966 <dup_mmap+0x60>
        vma->vm_start = vm_start;
ffffffffc020393e:	01553423          	sd	s5,8(a0)
ffffffffc0203942:	01453823          	sd	s4,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203946:	01352c23          	sw	s3,24(a0)
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc020394a:	854a                	mv	a0,s2
ffffffffc020394c:	dcbff0ef          	jal	ffffffffc0203716 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203950:	ff043683          	ld	a3,-16(s0)
ffffffffc0203954:	fe843603          	ld	a2,-24(s0)
ffffffffc0203958:	6c8c                	ld	a1,24(s1)
ffffffffc020395a:	01893503          	ld	a0,24(s2)
ffffffffc020395e:	4701                	li	a4,0
ffffffffc0203960:	ce3fe0ef          	jal	ffffffffc0202642 <copy_range>
ffffffffc0203964:	dd55                	beqz	a0,ffffffffc0203920 <dup_mmap+0x1a>
            return -E_NO_MEM;
ffffffffc0203966:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203968:	70e2                	ld	ra,56(sp)
ffffffffc020396a:	7442                	ld	s0,48(sp)
ffffffffc020396c:	74a2                	ld	s1,40(sp)
ffffffffc020396e:	7902                	ld	s2,32(sp)
ffffffffc0203970:	69e2                	ld	s3,24(sp)
ffffffffc0203972:	6a42                	ld	s4,16(sp)
ffffffffc0203974:	6aa2                	ld	s5,8(sp)
ffffffffc0203976:	6121                	addi	sp,sp,64
ffffffffc0203978:	8082                	ret
    return 0;
ffffffffc020397a:	4501                	li	a0,0
ffffffffc020397c:	b7f5                	j	ffffffffc0203968 <dup_mmap+0x62>
    assert(to != NULL && from != NULL);
ffffffffc020397e:	00003697          	auipc	a3,0x3
ffffffffc0203982:	69a68693          	addi	a3,a3,1690 # ffffffffc0207018 <etext+0x15aa>
ffffffffc0203986:	00003617          	auipc	a2,0x3
ffffffffc020398a:	b0a60613          	addi	a2,a2,-1270 # ffffffffc0206490 <etext+0xa22>
ffffffffc020398e:	0cf00593          	li	a1,207
ffffffffc0203992:	00003517          	auipc	a0,0x3
ffffffffc0203996:	5ee50513          	addi	a0,a0,1518 # ffffffffc0206f80 <etext+0x1512>
ffffffffc020399a:	aeffc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc020399e <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc020399e:	1101                	addi	sp,sp,-32
ffffffffc02039a0:	ec06                	sd	ra,24(sp)
ffffffffc02039a2:	e822                	sd	s0,16(sp)
ffffffffc02039a4:	e426                	sd	s1,8(sp)
ffffffffc02039a6:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02039a8:	c531                	beqz	a0,ffffffffc02039f4 <exit_mmap+0x56>
ffffffffc02039aa:	591c                	lw	a5,48(a0)
ffffffffc02039ac:	84aa                	mv	s1,a0
ffffffffc02039ae:	e3b9                	bnez	a5,ffffffffc02039f4 <exit_mmap+0x56>
    return listelm->next;
ffffffffc02039b0:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc02039b2:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc02039b6:	02850663          	beq	a0,s0,ffffffffc02039e2 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02039ba:	ff043603          	ld	a2,-16(s0)
ffffffffc02039be:	fe843583          	ld	a1,-24(s0)
ffffffffc02039c2:	854a                	mv	a0,s2
ffffffffc02039c4:	87bfe0ef          	jal	ffffffffc020223e <unmap_range>
ffffffffc02039c8:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02039ca:	fe8498e3          	bne	s1,s0,ffffffffc02039ba <exit_mmap+0x1c>
ffffffffc02039ce:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc02039d0:	00848c63          	beq	s1,s0,ffffffffc02039e8 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02039d4:	ff043603          	ld	a2,-16(s0)
ffffffffc02039d8:	fe843583          	ld	a1,-24(s0)
ffffffffc02039dc:	854a                	mv	a0,s2
ffffffffc02039de:	98bfe0ef          	jal	ffffffffc0202368 <exit_range>
ffffffffc02039e2:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02039e4:	fe8498e3          	bne	s1,s0,ffffffffc02039d4 <exit_mmap+0x36>
    }
}
ffffffffc02039e8:	60e2                	ld	ra,24(sp)
ffffffffc02039ea:	6442                	ld	s0,16(sp)
ffffffffc02039ec:	64a2                	ld	s1,8(sp)
ffffffffc02039ee:	6902                	ld	s2,0(sp)
ffffffffc02039f0:	6105                	addi	sp,sp,32
ffffffffc02039f2:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02039f4:	00003697          	auipc	a3,0x3
ffffffffc02039f8:	64468693          	addi	a3,a3,1604 # ffffffffc0207038 <etext+0x15ca>
ffffffffc02039fc:	00003617          	auipc	a2,0x3
ffffffffc0203a00:	a9460613          	addi	a2,a2,-1388 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203a04:	0e800593          	li	a1,232
ffffffffc0203a08:	00003517          	auipc	a0,0x3
ffffffffc0203a0c:	57850513          	addi	a0,a0,1400 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203a10:	a79fc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0203a14 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203a14:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a16:	04000513          	li	a0,64
{
ffffffffc0203a1a:	fc06                	sd	ra,56(sp)
ffffffffc0203a1c:	f822                	sd	s0,48(sp)
ffffffffc0203a1e:	f426                	sd	s1,40(sp)
ffffffffc0203a20:	f04a                	sd	s2,32(sp)
ffffffffc0203a22:	ec4e                	sd	s3,24(sp)
ffffffffc0203a24:	e852                	sd	s4,16(sp)
ffffffffc0203a26:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a28:	b04fe0ef          	jal	ffffffffc0201d2c <kmalloc>
    if (mm != NULL)
ffffffffc0203a2c:	18050163          	beqz	a0,ffffffffc0203bae <vmm_init+0x19a>
ffffffffc0203a30:	842a                	mv	s0,a0
    elm->prev = elm->next = elm;
ffffffffc0203a32:	e508                	sd	a0,8(a0)
ffffffffc0203a34:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203a36:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203a3a:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203a3e:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203a42:	02053423          	sd	zero,40(a0)
ffffffffc0203a46:	02052823          	sw	zero,48(a0)
ffffffffc0203a4a:	02053c23          	sd	zero,56(a0)
ffffffffc0203a4e:	03200493          	li	s1,50
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a52:	03000513          	li	a0,48
ffffffffc0203a56:	ad6fe0ef          	jal	ffffffffc0201d2c <kmalloc>
ffffffffc0203a5a:	00248913          	addi	s2,s1,2
ffffffffc0203a5e:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0203a60:	12050763          	beqz	a0,ffffffffc0203b8e <vmm_init+0x17a>
        vma->vm_start = vm_start;
ffffffffc0203a64:	e504                	sd	s1,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203a66:	01253823          	sd	s2,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203a6a:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203a6e:	14ed                	addi	s1,s1,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203a70:	8522                	mv	a0,s0
ffffffffc0203a72:	ca5ff0ef          	jal	ffffffffc0203716 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203a76:	fcf1                	bnez	s1,ffffffffc0203a52 <vmm_init+0x3e>
ffffffffc0203a78:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203a7c:	1f900913          	li	s2,505
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a80:	03000513          	li	a0,48
ffffffffc0203a84:	aa8fe0ef          	jal	ffffffffc0201d2c <kmalloc>
ffffffffc0203a88:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0203a8a:	14050263          	beqz	a0,ffffffffc0203bce <vmm_init+0x1ba>
        vma->vm_end = vm_end;
ffffffffc0203a8e:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0203a92:	e504                	sd	s1,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203a94:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203a96:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203a9a:	0495                	addi	s1,s1,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203a9c:	8522                	mv	a0,s0
ffffffffc0203a9e:	c79ff0ef          	jal	ffffffffc0203716 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203aa2:	fd249fe3          	bne	s1,s2,ffffffffc0203a80 <vmm_init+0x6c>
    return listelm->next;
ffffffffc0203aa6:	641c                	ld	a5,8(s0)

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203aa8:	1a878363          	beq	a5,s0,ffffffffc0203c4e <vmm_init+0x23a>
ffffffffc0203aac:	4715                	li	a4,5
    for (i = 1; i <= step2; i++)
ffffffffc0203aae:	1f400593          	li	a1,500
ffffffffc0203ab2:	a021                	j	ffffffffc0203aba <vmm_init+0xa6>
        assert(le != &(mm->mmap_list));
ffffffffc0203ab4:	0715                	addi	a4,a4,5
ffffffffc0203ab6:	18878c63          	beq	a5,s0,ffffffffc0203c4e <vmm_init+0x23a>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203aba:	fe87b683          	ld	a3,-24(a5) # 1fffe8 <_binary_obj___user_exit_out_size+0x1f64e0>
ffffffffc0203abe:	16e69863          	bne	a3,a4,ffffffffc0203c2e <vmm_init+0x21a>
ffffffffc0203ac2:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203ac6:	00270693          	addi	a3,a4,2
ffffffffc0203aca:	16d61263          	bne	a2,a3,ffffffffc0203c2e <vmm_init+0x21a>
ffffffffc0203ace:	679c                	ld	a5,8(a5)
    for (i = 1; i <= step2; i++)
ffffffffc0203ad0:	feb712e3          	bne	a4,a1,ffffffffc0203ab4 <vmm_init+0xa0>
ffffffffc0203ad4:	4a1d                	li	s4,7
ffffffffc0203ad6:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203ad8:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203adc:	85a6                	mv	a1,s1
ffffffffc0203ade:	8522                	mv	a0,s0
ffffffffc0203ae0:	bf7ff0ef          	jal	ffffffffc02036d6 <find_vma>
ffffffffc0203ae4:	89aa                	mv	s3,a0
        assert(vma1 != NULL);
ffffffffc0203ae6:	1a050463          	beqz	a0,ffffffffc0203c8e <vmm_init+0x27a>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203aea:	00148593          	addi	a1,s1,1
ffffffffc0203aee:	8522                	mv	a0,s0
ffffffffc0203af0:	be7ff0ef          	jal	ffffffffc02036d6 <find_vma>
ffffffffc0203af4:	892a                	mv	s2,a0
        assert(vma2 != NULL);
ffffffffc0203af6:	16050c63          	beqz	a0,ffffffffc0203c6e <vmm_init+0x25a>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203afa:	85d2                	mv	a1,s4
ffffffffc0203afc:	8522                	mv	a0,s0
ffffffffc0203afe:	bd9ff0ef          	jal	ffffffffc02036d6 <find_vma>
        assert(vma3 == NULL);
ffffffffc0203b02:	1e051663          	bnez	a0,ffffffffc0203cee <vmm_init+0x2da>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203b06:	00348593          	addi	a1,s1,3
ffffffffc0203b0a:	8522                	mv	a0,s0
ffffffffc0203b0c:	bcbff0ef          	jal	ffffffffc02036d6 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203b10:	1a051f63          	bnez	a0,ffffffffc0203cce <vmm_init+0x2ba>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203b14:	00448593          	addi	a1,s1,4
ffffffffc0203b18:	8522                	mv	a0,s0
ffffffffc0203b1a:	bbdff0ef          	jal	ffffffffc02036d6 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203b1e:	18051863          	bnez	a0,ffffffffc0203cae <vmm_init+0x29a>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203b22:	0089b783          	ld	a5,8(s3)
ffffffffc0203b26:	0e979463          	bne	a5,s1,ffffffffc0203c0e <vmm_init+0x1fa>
ffffffffc0203b2a:	0109b783          	ld	a5,16(s3)
ffffffffc0203b2e:	0f479063          	bne	a5,s4,ffffffffc0203c0e <vmm_init+0x1fa>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203b32:	00893783          	ld	a5,8(s2)
ffffffffc0203b36:	0a979c63          	bne	a5,s1,ffffffffc0203bee <vmm_init+0x1da>
ffffffffc0203b3a:	01093783          	ld	a5,16(s2)
ffffffffc0203b3e:	0b479863          	bne	a5,s4,ffffffffc0203bee <vmm_init+0x1da>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203b42:	0495                	addi	s1,s1,5
ffffffffc0203b44:	0a15                	addi	s4,s4,5
ffffffffc0203b46:	f9549be3          	bne	s1,s5,ffffffffc0203adc <vmm_init+0xc8>
ffffffffc0203b4a:	4491                	li	s1,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203b4c:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203b4e:	85a6                	mv	a1,s1
ffffffffc0203b50:	8522                	mv	a0,s0
ffffffffc0203b52:	b85ff0ef          	jal	ffffffffc02036d6 <find_vma>
        if (vma_below_5 != NULL)
ffffffffc0203b56:	1a051c63          	bnez	a0,ffffffffc0203d0e <vmm_init+0x2fa>
    for (i = 4; i >= 0; i--)
ffffffffc0203b5a:	14fd                	addi	s1,s1,-1
ffffffffc0203b5c:	ff2499e3          	bne	s1,s2,ffffffffc0203b4e <vmm_init+0x13a>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
ffffffffc0203b60:	8522                	mv	a0,s0
ffffffffc0203b62:	c85ff0ef          	jal	ffffffffc02037e6 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203b66:	00003517          	auipc	a0,0x3
ffffffffc0203b6a:	64250513          	addi	a0,a0,1602 # ffffffffc02071a8 <etext+0x173a>
ffffffffc0203b6e:	e26fc0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0203b72:	7442                	ld	s0,48(sp)
ffffffffc0203b74:	70e2                	ld	ra,56(sp)
ffffffffc0203b76:	74a2                	ld	s1,40(sp)
ffffffffc0203b78:	7902                	ld	s2,32(sp)
ffffffffc0203b7a:	69e2                	ld	s3,24(sp)
ffffffffc0203b7c:	6a42                	ld	s4,16(sp)
ffffffffc0203b7e:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203b80:	00003517          	auipc	a0,0x3
ffffffffc0203b84:	64850513          	addi	a0,a0,1608 # ffffffffc02071c8 <etext+0x175a>
}
ffffffffc0203b88:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203b8a:	e0afc06f          	j	ffffffffc0200194 <cprintf>
        assert(vma != NULL);
ffffffffc0203b8e:	00003697          	auipc	a3,0x3
ffffffffc0203b92:	4ca68693          	addi	a3,a3,1226 # ffffffffc0207058 <etext+0x15ea>
ffffffffc0203b96:	00003617          	auipc	a2,0x3
ffffffffc0203b9a:	8fa60613          	addi	a2,a2,-1798 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203b9e:	12c00593          	li	a1,300
ffffffffc0203ba2:	00003517          	auipc	a0,0x3
ffffffffc0203ba6:	3de50513          	addi	a0,a0,990 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203baa:	8dffc0ef          	jal	ffffffffc0200488 <__panic>
    assert(mm != NULL);
ffffffffc0203bae:	00003697          	auipc	a3,0x3
ffffffffc0203bb2:	45a68693          	addi	a3,a3,1114 # ffffffffc0207008 <etext+0x159a>
ffffffffc0203bb6:	00003617          	auipc	a2,0x3
ffffffffc0203bba:	8da60613          	addi	a2,a2,-1830 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203bbe:	12400593          	li	a1,292
ffffffffc0203bc2:	00003517          	auipc	a0,0x3
ffffffffc0203bc6:	3be50513          	addi	a0,a0,958 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203bca:	8bffc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma != NULL);
ffffffffc0203bce:	00003697          	auipc	a3,0x3
ffffffffc0203bd2:	48a68693          	addi	a3,a3,1162 # ffffffffc0207058 <etext+0x15ea>
ffffffffc0203bd6:	00003617          	auipc	a2,0x3
ffffffffc0203bda:	8ba60613          	addi	a2,a2,-1862 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203bde:	13300593          	li	a1,307
ffffffffc0203be2:	00003517          	auipc	a0,0x3
ffffffffc0203be6:	39e50513          	addi	a0,a0,926 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203bea:	89ffc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203bee:	00003697          	auipc	a3,0x3
ffffffffc0203bf2:	54a68693          	addi	a3,a3,1354 # ffffffffc0207138 <etext+0x16ca>
ffffffffc0203bf6:	00003617          	auipc	a2,0x3
ffffffffc0203bfa:	89a60613          	addi	a2,a2,-1894 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203bfe:	14f00593          	li	a1,335
ffffffffc0203c02:	00003517          	auipc	a0,0x3
ffffffffc0203c06:	37e50513          	addi	a0,a0,894 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203c0a:	87ffc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203c0e:	00003697          	auipc	a3,0x3
ffffffffc0203c12:	4fa68693          	addi	a3,a3,1274 # ffffffffc0207108 <etext+0x169a>
ffffffffc0203c16:	00003617          	auipc	a2,0x3
ffffffffc0203c1a:	87a60613          	addi	a2,a2,-1926 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203c1e:	14e00593          	li	a1,334
ffffffffc0203c22:	00003517          	auipc	a0,0x3
ffffffffc0203c26:	35e50513          	addi	a0,a0,862 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203c2a:	85ffc0ef          	jal	ffffffffc0200488 <__panic>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203c2e:	00003697          	auipc	a3,0x3
ffffffffc0203c32:	45268693          	addi	a3,a3,1106 # ffffffffc0207080 <etext+0x1612>
ffffffffc0203c36:	00003617          	auipc	a2,0x3
ffffffffc0203c3a:	85a60613          	addi	a2,a2,-1958 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203c3e:	13d00593          	li	a1,317
ffffffffc0203c42:	00003517          	auipc	a0,0x3
ffffffffc0203c46:	33e50513          	addi	a0,a0,830 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203c4a:	83ffc0ef          	jal	ffffffffc0200488 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203c4e:	00003697          	auipc	a3,0x3
ffffffffc0203c52:	41a68693          	addi	a3,a3,1050 # ffffffffc0207068 <etext+0x15fa>
ffffffffc0203c56:	00003617          	auipc	a2,0x3
ffffffffc0203c5a:	83a60613          	addi	a2,a2,-1990 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203c5e:	13b00593          	li	a1,315
ffffffffc0203c62:	00003517          	auipc	a0,0x3
ffffffffc0203c66:	31e50513          	addi	a0,a0,798 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203c6a:	81ffc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma2 != NULL);
ffffffffc0203c6e:	00003697          	auipc	a3,0x3
ffffffffc0203c72:	45a68693          	addi	a3,a3,1114 # ffffffffc02070c8 <etext+0x165a>
ffffffffc0203c76:	00003617          	auipc	a2,0x3
ffffffffc0203c7a:	81a60613          	addi	a2,a2,-2022 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203c7e:	14600593          	li	a1,326
ffffffffc0203c82:	00003517          	auipc	a0,0x3
ffffffffc0203c86:	2fe50513          	addi	a0,a0,766 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203c8a:	ffefc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma1 != NULL);
ffffffffc0203c8e:	00003697          	auipc	a3,0x3
ffffffffc0203c92:	42a68693          	addi	a3,a3,1066 # ffffffffc02070b8 <etext+0x164a>
ffffffffc0203c96:	00002617          	auipc	a2,0x2
ffffffffc0203c9a:	7fa60613          	addi	a2,a2,2042 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203c9e:	14400593          	li	a1,324
ffffffffc0203ca2:	00003517          	auipc	a0,0x3
ffffffffc0203ca6:	2de50513          	addi	a0,a0,734 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203caa:	fdefc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma5 == NULL);
ffffffffc0203cae:	00003697          	auipc	a3,0x3
ffffffffc0203cb2:	44a68693          	addi	a3,a3,1098 # ffffffffc02070f8 <etext+0x168a>
ffffffffc0203cb6:	00002617          	auipc	a2,0x2
ffffffffc0203cba:	7da60613          	addi	a2,a2,2010 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203cbe:	14c00593          	li	a1,332
ffffffffc0203cc2:	00003517          	auipc	a0,0x3
ffffffffc0203cc6:	2be50513          	addi	a0,a0,702 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203cca:	fbefc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma4 == NULL);
ffffffffc0203cce:	00003697          	auipc	a3,0x3
ffffffffc0203cd2:	41a68693          	addi	a3,a3,1050 # ffffffffc02070e8 <etext+0x167a>
ffffffffc0203cd6:	00002617          	auipc	a2,0x2
ffffffffc0203cda:	7ba60613          	addi	a2,a2,1978 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203cde:	14a00593          	li	a1,330
ffffffffc0203ce2:	00003517          	auipc	a0,0x3
ffffffffc0203ce6:	29e50513          	addi	a0,a0,670 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203cea:	f9efc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma3 == NULL);
ffffffffc0203cee:	00003697          	auipc	a3,0x3
ffffffffc0203cf2:	3ea68693          	addi	a3,a3,1002 # ffffffffc02070d8 <etext+0x166a>
ffffffffc0203cf6:	00002617          	auipc	a2,0x2
ffffffffc0203cfa:	79a60613          	addi	a2,a2,1946 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203cfe:	14800593          	li	a1,328
ffffffffc0203d02:	00003517          	auipc	a0,0x3
ffffffffc0203d06:	27e50513          	addi	a0,a0,638 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203d0a:	f7efc0ef          	jal	ffffffffc0200488 <__panic>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203d0e:	6914                	ld	a3,16(a0)
ffffffffc0203d10:	6510                	ld	a2,8(a0)
ffffffffc0203d12:	0004859b          	sext.w	a1,s1
ffffffffc0203d16:	00003517          	auipc	a0,0x3
ffffffffc0203d1a:	45250513          	addi	a0,a0,1106 # ffffffffc0207168 <etext+0x16fa>
ffffffffc0203d1e:	c76fc0ef          	jal	ffffffffc0200194 <cprintf>
        assert(vma_below_5 == NULL);
ffffffffc0203d22:	00003697          	auipc	a3,0x3
ffffffffc0203d26:	46e68693          	addi	a3,a3,1134 # ffffffffc0207190 <etext+0x1722>
ffffffffc0203d2a:	00002617          	auipc	a2,0x2
ffffffffc0203d2e:	76660613          	addi	a2,a2,1894 # ffffffffc0206490 <etext+0xa22>
ffffffffc0203d32:	15900593          	li	a1,345
ffffffffc0203d36:	00003517          	auipc	a0,0x3
ffffffffc0203d3a:	24a50513          	addi	a0,a0,586 # ffffffffc0206f80 <etext+0x1512>
ffffffffc0203d3e:	f4afc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0203d42 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203d42:	7179                	addi	sp,sp,-48
ffffffffc0203d44:	f022                	sd	s0,32(sp)
ffffffffc0203d46:	f406                	sd	ra,40(sp)
ffffffffc0203d48:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203d4a:	c535                	beqz	a0,ffffffffc0203db6 <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203d4c:	002007b7          	lui	a5,0x200
ffffffffc0203d50:	04f5ee63          	bltu	a1,a5,ffffffffc0203dac <user_mem_check+0x6a>
ffffffffc0203d54:	ec26                	sd	s1,24(sp)
ffffffffc0203d56:	00c584b3          	add	s1,a1,a2
ffffffffc0203d5a:	0695fc63          	bgeu	a1,s1,ffffffffc0203dd2 <user_mem_check+0x90>
ffffffffc0203d5e:	4785                	li	a5,1
ffffffffc0203d60:	07fe                	slli	a5,a5,0x1f
ffffffffc0203d62:	0697e863          	bltu	a5,s1,ffffffffc0203dd2 <user_mem_check+0x90>
ffffffffc0203d66:	e84a                	sd	s2,16(sp)
ffffffffc0203d68:	e44e                	sd	s3,8(sp)
ffffffffc0203d6a:	e052                	sd	s4,0(sp)
ffffffffc0203d6c:	892a                	mv	s2,a0
ffffffffc0203d6e:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d70:	6a05                	lui	s4,0x1
ffffffffc0203d72:	a821                	j	ffffffffc0203d8a <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d74:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d78:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203d7a:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d7c:	c685                	beqz	a3,ffffffffc0203da4 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203d7e:	c399                	beqz	a5,ffffffffc0203d84 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d80:	02e46263          	bltu	s0,a4,ffffffffc0203da4 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203d84:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203d86:	04947863          	bgeu	s0,s1,ffffffffc0203dd6 <user_mem_check+0x94>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203d8a:	85a2                	mv	a1,s0
ffffffffc0203d8c:	854a                	mv	a0,s2
ffffffffc0203d8e:	949ff0ef          	jal	ffffffffc02036d6 <find_vma>
ffffffffc0203d92:	c909                	beqz	a0,ffffffffc0203da4 <user_mem_check+0x62>
ffffffffc0203d94:	6518                	ld	a4,8(a0)
ffffffffc0203d96:	00e46763          	bltu	s0,a4,ffffffffc0203da4 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d9a:	4d1c                	lw	a5,24(a0)
ffffffffc0203d9c:	fc099ce3          	bnez	s3,ffffffffc0203d74 <user_mem_check+0x32>
ffffffffc0203da0:	8b85                	andi	a5,a5,1
ffffffffc0203da2:	f3ed                	bnez	a5,ffffffffc0203d84 <user_mem_check+0x42>
ffffffffc0203da4:	64e2                	ld	s1,24(sp)
ffffffffc0203da6:	6942                	ld	s2,16(sp)
ffffffffc0203da8:	69a2                	ld	s3,8(sp)
ffffffffc0203daa:	6a02                	ld	s4,0(sp)
            return 0;
ffffffffc0203dac:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc0203dae:	70a2                	ld	ra,40(sp)
ffffffffc0203db0:	7402                	ld	s0,32(sp)
ffffffffc0203db2:	6145                	addi	sp,sp,48
ffffffffc0203db4:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203db6:	c02007b7          	lui	a5,0xc0200
ffffffffc0203dba:	4501                	li	a0,0
ffffffffc0203dbc:	fef5e9e3          	bltu	a1,a5,ffffffffc0203dae <user_mem_check+0x6c>
ffffffffc0203dc0:	962e                	add	a2,a2,a1
ffffffffc0203dc2:	fec5f6e3          	bgeu	a1,a2,ffffffffc0203dae <user_mem_check+0x6c>
ffffffffc0203dc6:	c8000537          	lui	a0,0xc8000
ffffffffc0203dca:	0505                	addi	a0,a0,1 # ffffffffc8000001 <end+0x7d61189>
ffffffffc0203dcc:	00a63533          	sltu	a0,a2,a0
ffffffffc0203dd0:	bff9                	j	ffffffffc0203dae <user_mem_check+0x6c>
ffffffffc0203dd2:	64e2                	ld	s1,24(sp)
ffffffffc0203dd4:	bfe1                	j	ffffffffc0203dac <user_mem_check+0x6a>
ffffffffc0203dd6:	64e2                	ld	s1,24(sp)
ffffffffc0203dd8:	6942                	ld	s2,16(sp)
ffffffffc0203dda:	69a2                	ld	s3,8(sp)
ffffffffc0203ddc:	6a02                	ld	s4,0(sp)
        return 1;
ffffffffc0203dde:	4505                	li	a0,1
ffffffffc0203de0:	b7f9                	j	ffffffffc0203dae <user_mem_check+0x6c>

ffffffffc0203de2 <do_pgfault>:
int do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr)
{
    int ret = -E_INVAL;
    
    // 检查地址是否在用户空间
    if (!USER_ACCESS(addr, addr + 1))
ffffffffc0203de2:	ffe007b7          	lui	a5,0xffe00
ffffffffc0203de6:	97b2                	add	a5,a5,a2
ffffffffc0203de8:	7fe00737          	lui	a4,0x7fe00
ffffffffc0203dec:	22e7f463          	bgeu	a5,a4,ffffffffc0204014 <do_pgfault+0x232>
{
ffffffffc0203df0:	715d                	addi	sp,sp,-80
ffffffffc0203df2:	f84a                	sd	s2,48(sp)
ffffffffc0203df4:	892e                	mv	s2,a1
    {
        goto failed;
    }
    
    // 查找包含该地址的 vma
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0203df6:	85b2                	mv	a1,a2
{
ffffffffc0203df8:	e0a2                	sd	s0,64(sp)
ffffffffc0203dfa:	fc26                	sd	s1,56(sp)
ffffffffc0203dfc:	f44e                	sd	s3,40(sp)
ffffffffc0203dfe:	e486                	sd	ra,72(sp)
ffffffffc0203e00:	8432                	mv	s0,a2
ffffffffc0203e02:	89aa                	mv	s3,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0203e04:	8d3ff0ef          	jal	ffffffffc02036d6 <find_vma>
ffffffffc0203e08:	84aa                	mv	s1,a0
    if (vma == NULL || addr < vma->vm_start || addr >= vma->vm_end)
ffffffffc0203e0a:	1e050763          	beqz	a0,ffffffffc0203ff8 <do_pgfault+0x216>
ffffffffc0203e0e:	651c                	ld	a5,8(a0)
ffffffffc0203e10:	1ef46463          	bltu	s0,a5,ffffffffc0203ff8 <do_pgfault+0x216>
ffffffffc0203e14:	691c                	ld	a5,16(a0)
ffffffffc0203e16:	1ef47163          	bgeu	s0,a5,ffffffffc0203ff8 <do_pgfault+0x216>
    {
        goto failed;
    }
    
    // 获取页表项
    pte_t *ptep = get_pte(mm->pgdir, addr, 1);
ffffffffc0203e1a:	0189b503          	ld	a0,24(s3)
ffffffffc0203e1e:	4605                	li	a2,1
ffffffffc0203e20:	85a2                	mv	a1,s0
ffffffffc0203e22:	f052                	sd	s4,32(sp)
ffffffffc0203e24:	998fe0ef          	jal	ffffffffc0201fbc <get_pte>
ffffffffc0203e28:	8a2a                	mv	s4,a0
    if (ptep == NULL)
ffffffffc0203e2a:	1c050c63          	beqz	a0,ffffffffc0204002 <do_pgfault+0x220>
    
    // 检查是否是写操作导致的 page fault
    bool is_write = (error_code & 0x2) != 0;
    
    // 如果页表项有效，说明页面存在
    if (*ptep & PTE_V)
ffffffffc0203e2e:	6118                	ld	a4,0(a0)
    bool is_write = (error_code & 0x2) != 0;
ffffffffc0203e30:	00297593          	andi	a1,s2,2
    if (*ptep & PTE_V)
ffffffffc0203e34:	00177793          	andi	a5,a4,1
ffffffffc0203e38:	ebcd                	bnez	a5,ffffffffc0203eea <do_pgfault+0x108>
        }
    }
    else
    {
        // 页面不存在，需要分配新页面
        if (!(vma->vm_flags & VM_WRITE) && is_write)
ffffffffc0203e3a:	4c9c                	lw	a5,24(s1)
ffffffffc0203e3c:	8b89                	andi	a5,a5,2
ffffffffc0203e3e:	e399                	bnez	a5,ffffffffc0203e44 <do_pgfault+0x62>
ffffffffc0203e40:	1a059b63          	bnez	a1,ffffffffc0203ff6 <do_pgfault+0x214>
        {
            goto failed;
        }
        
        // 分配新页面
        struct Page *page = alloc_page();
ffffffffc0203e44:	4505                	li	a0,1
ffffffffc0203e46:	8befe0ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc0203e4a:	892a                	mv	s2,a0
        if (page == NULL)
ffffffffc0203e4c:	1a050b63          	beqz	a0,ffffffffc0204002 <do_pgfault+0x220>
            goto failed;
        }
        
        // 设置页表项权限
        uint32_t perm = PTE_U | PTE_V;
        if (vma->vm_flags & VM_WRITE)
ffffffffc0203e50:	4c9c                	lw	a5,24(s1)
ffffffffc0203e52:	ec56                	sd	s5,24(sp)
        {
            perm |= PTE_W;
ffffffffc0203e54:	46d5                	li	a3,21
        if (vma->vm_flags & VM_WRITE)
ffffffffc0203e56:	0027f713          	andi	a4,a5,2
ffffffffc0203e5a:	e311                	bnez	a4,ffffffffc0203e5e <do_pgfault+0x7c>
        uint32_t perm = PTE_U | PTE_V;
ffffffffc0203e5c:	46c5                	li	a3,17
        }
        if (vma->vm_flags & VM_READ)
ffffffffc0203e5e:	0017f713          	andi	a4,a5,1
ffffffffc0203e62:	0706                	slli	a4,a4,0x1
        {
            perm |= PTE_R;
        }
        if (vma->vm_flags & VM_EXEC)
ffffffffc0203e64:	8b91                	andi	a5,a5,4
        if (vma->vm_flags & VM_READ)
ffffffffc0203e66:	8f55                	or	a4,a4,a3
        if (vma->vm_flags & VM_EXEC)
ffffffffc0203e68:	c399                	beqz	a5,ffffffffc0203e6e <do_pgfault+0x8c>
        {
            perm |= PTE_X;
ffffffffc0203e6a:	00876713          	ori	a4,a4,8
    return page - pages + nbase;
ffffffffc0203e6e:	0009ba97          	auipc	s5,0x9b
ffffffffc0203e72:	fe2a8a93          	addi	s5,s5,-30 # ffffffffc029ee50 <pages>
ffffffffc0203e76:	000ab783          	ld	a5,0(s5)
ffffffffc0203e7a:	00004497          	auipc	s1,0x4
ffffffffc0203e7e:	d4e4b483          	ld	s1,-690(s1) # ffffffffc0207bc8 <nbase>
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0203e82:	1702                	slli	a4,a4,0x20
    return page - pages + nbase;
ffffffffc0203e84:	40f907b3          	sub	a5,s2,a5
ffffffffc0203e88:	8799                	srai	a5,a5,0x6
ffffffffc0203e8a:	97a6                	add	a5,a5,s1
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0203e8c:	9301                	srli	a4,a4,0x20
ffffffffc0203e8e:	07aa                	slli	a5,a5,0xa
        }
        
        *ptep = pte_create(page2ppn(page), perm);
        tlb_invalidate(mm->pgdir, addr);
ffffffffc0203e90:	0189b503          	ld	a0,24(s3)
ffffffffc0203e94:	8fd9                	or	a5,a5,a4
ffffffffc0203e96:	0017e793          	ori	a5,a5,1
        *ptep = pte_create(page2ppn(page), perm);
ffffffffc0203e9a:	00fa3023          	sd	a5,0(s4) # 1000 <_binary_obj___user_softint_out_size-0x7598>
        tlb_invalidate(mm->pgdir, addr);
ffffffffc0203e9e:	85a2                	mv	a1,s0
ffffffffc0203ea0:	f0eff0ef          	jal	ffffffffc02035ae <tlb_invalidate>
    return page - pages + nbase;
ffffffffc0203ea4:	000ab783          	ld	a5,0(s5)
    return KADDR(page2pa(page));
ffffffffc0203ea8:	0009b717          	auipc	a4,0x9b
ffffffffc0203eac:	fa073703          	ld	a4,-96(a4) # ffffffffc029ee48 <npage>
    return page - pages + nbase;
ffffffffc0203eb0:	40f90533          	sub	a0,s2,a5
ffffffffc0203eb4:	8519                	srai	a0,a0,0x6
ffffffffc0203eb6:	9526                	add	a0,a0,s1
    return KADDR(page2pa(page));
ffffffffc0203eb8:	00c51793          	slli	a5,a0,0xc
ffffffffc0203ebc:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203ebe:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0203ec0:	14e7fc63          	bgeu	a5,a4,ffffffffc0204018 <do_pgfault+0x236>
        
        // 初始化页面为 0
        memset(page2kva(page), 0, PGSIZE);
ffffffffc0203ec4:	0009b797          	auipc	a5,0x9b
ffffffffc0203ec8:	f7c7b783          	ld	a5,-132(a5) # ffffffffc029ee40 <va_pa_offset>
ffffffffc0203ecc:	6605                	lui	a2,0x1
ffffffffc0203ece:	4581                	li	a1,0
ffffffffc0203ed0:	953e                	add	a0,a0,a5
ffffffffc0203ed2:	373010ef          	jal	ffffffffc0205a44 <memset>
                    ret = 0;
ffffffffc0203ed6:	7a02                	ld	s4,32(sp)
ffffffffc0203ed8:	6ae2                	ld	s5,24(sp)
ffffffffc0203eda:	4501                	li	a0,0
        ret = 0;
    }
    
failed:
    return ret;
ffffffffc0203edc:	60a6                	ld	ra,72(sp)
ffffffffc0203ede:	6406                	ld	s0,64(sp)
ffffffffc0203ee0:	74e2                	ld	s1,56(sp)
ffffffffc0203ee2:	7942                	ld	s2,48(sp)
ffffffffc0203ee4:	79a2                	ld	s3,40(sp)
ffffffffc0203ee6:	6161                	addi	sp,sp,80
ffffffffc0203ee8:	8082                	ret
        if (is_write && !(*ptep & PTE_W) && (vma->vm_flags & VM_WRITE))
ffffffffc0203eea:	10058663          	beqz	a1,ffffffffc0203ff6 <do_pgfault+0x214>
ffffffffc0203eee:	00477793          	andi	a5,a4,4
ffffffffc0203ef2:	10079263          	bnez	a5,ffffffffc0203ff6 <do_pgfault+0x214>
ffffffffc0203ef6:	4c9c                	lw	a5,24(s1)
ffffffffc0203ef8:	8b89                	andi	a5,a5,2
ffffffffc0203efa:	0e078e63          	beqz	a5,ffffffffc0203ff6 <do_pgfault+0x214>
ffffffffc0203efe:	e45e                	sd	s7,8(sp)
    if (PPN(pa) >= npage)
ffffffffc0203f00:	0009bb97          	auipc	s7,0x9b
ffffffffc0203f04:	f48b8b93          	addi	s7,s7,-184 # ffffffffc029ee48 <npage>
ffffffffc0203f08:	000bb683          	ld	a3,0(s7)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203f0c:	00271793          	slli	a5,a4,0x2
ffffffffc0203f10:	ec56                	sd	s5,24(sp)
ffffffffc0203f12:	e85a                	sd	s6,16(sp)
ffffffffc0203f14:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203f16:	12d7f063          	bgeu	a5,a3,ffffffffc0204036 <do_pgfault+0x254>
    return &pages[PPN(pa) - nbase];
ffffffffc0203f1a:	0009bb17          	auipc	s6,0x9b
ffffffffc0203f1e:	f36b0b13          	addi	s6,s6,-202 # ffffffffc029ee50 <pages>
ffffffffc0203f22:	000b3903          	ld	s2,0(s6)
ffffffffc0203f26:	00004a97          	auipc	s5,0x4
ffffffffc0203f2a:	ca2aba83          	ld	s5,-862(s5) # ffffffffc0207bc8 <nbase>
ffffffffc0203f2e:	415787b3          	sub	a5,a5,s5
ffffffffc0203f32:	079a                	slli	a5,a5,0x6
ffffffffc0203f34:	993e                	add	s2,s2,a5
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0203f36:	00893783          	ld	a5,8(s2)
            if (PageCow(page))
ffffffffc0203f3a:	8b91                	andi	a5,a5,4
ffffffffc0203f3c:	c7f1                	beqz	a5,ffffffffc0204008 <do_pgfault+0x226>
                if (page_ref(page) > 1)
ffffffffc0203f3e:	00092683          	lw	a3,0(s2)
ffffffffc0203f42:	4785                	li	a5,1
ffffffffc0203f44:	08d7d863          	bge	a5,a3,ffffffffc0203fd4 <do_pgfault+0x1f2>
                    struct Page *new_page = alloc_page();
ffffffffc0203f48:	4505                	li	a0,1
ffffffffc0203f4a:	fbbfd0ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc0203f4e:	84aa                	mv	s1,a0
                    if (new_page == NULL)
ffffffffc0203f50:	c555                	beqz	a0,ffffffffc0203ffc <do_pgfault+0x21a>
    return page - pages + nbase;
ffffffffc0203f52:	000b3783          	ld	a5,0(s6)
    return KADDR(page2pa(page));
ffffffffc0203f56:	577d                	li	a4,-1
ffffffffc0203f58:	000bb603          	ld	a2,0(s7)
    return page - pages + nbase;
ffffffffc0203f5c:	40f906b3          	sub	a3,s2,a5
ffffffffc0203f60:	8699                	srai	a3,a3,0x6
ffffffffc0203f62:	96d6                	add	a3,a3,s5
    return KADDR(page2pa(page));
ffffffffc0203f64:	8331                	srli	a4,a4,0xc
ffffffffc0203f66:	00e6f5b3          	and	a1,a3,a4
    return page2ppn(page) << PGSHIFT;
ffffffffc0203f6a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203f6c:	0ec5fe63          	bgeu	a1,a2,ffffffffc0204068 <do_pgfault+0x286>
    return page - pages + nbase;
ffffffffc0203f70:	40f507b3          	sub	a5,a0,a5
ffffffffc0203f74:	8799                	srai	a5,a5,0x6
ffffffffc0203f76:	97d6                	add	a5,a5,s5
    return KADDR(page2pa(page));
ffffffffc0203f78:	0009b517          	auipc	a0,0x9b
ffffffffc0203f7c:	ec853503          	ld	a0,-312(a0) # ffffffffc029ee40 <va_pa_offset>
ffffffffc0203f80:	8f7d                	and	a4,a4,a5
ffffffffc0203f82:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0203f86:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0203f88:	0cc77363          	bgeu	a4,a2,ffffffffc020404e <do_pgfault+0x26c>
                    memcpy(dst_kva, src_kva, PGSIZE);
ffffffffc0203f8c:	6605                	lui	a2,0x1
ffffffffc0203f8e:	953e                	add	a0,a0,a5
ffffffffc0203f90:	2c7010ef          	jal	ffffffffc0205a56 <memcpy>
    page->ref -= 1;
ffffffffc0203f94:	00092783          	lw	a5,0(s2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0203f98:	00848713          	addi	a4,s1,8
ffffffffc0203f9c:	37fd                	addiw	a5,a5,-1
ffffffffc0203f9e:	00f92023          	sw	a5,0(s2)
ffffffffc0203fa2:	57ed                	li	a5,-5
ffffffffc0203fa4:	60f7302f          	amoand.d	zero,a5,(a4)
    return page - pages + nbase;
ffffffffc0203fa8:	000b3703          	ld	a4,0(s6)
                    uint32_t perm = (*ptep & (PTE_U | PTE_R | PTE_X)) | PTE_W | PTE_V;
ffffffffc0203fac:	000a3783          	ld	a5,0(s4)
                    tlb_invalidate(mm->pgdir, addr);
ffffffffc0203fb0:	0189b503          	ld	a0,24(s3)
ffffffffc0203fb4:	8c99                	sub	s1,s1,a4
ffffffffc0203fb6:	8499                	srai	s1,s1,0x6
ffffffffc0203fb8:	94d6                	add	s1,s1,s5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0203fba:	04aa                	slli	s1,s1,0xa
                    uint32_t perm = (*ptep & (PTE_U | PTE_R | PTE_X)) | PTE_W | PTE_V;
ffffffffc0203fbc:	8be9                	andi	a5,a5,26
ffffffffc0203fbe:	8fc5                	or	a5,a5,s1
ffffffffc0203fc0:	0057e793          	ori	a5,a5,5
                    *ptep = pte_create(page2ppn(new_page), perm);
ffffffffc0203fc4:	00fa3023          	sd	a5,0(s4)
                    tlb_invalidate(mm->pgdir, addr);
ffffffffc0203fc8:	85a2                	mv	a1,s0
ffffffffc0203fca:	de4ff0ef          	jal	ffffffffc02035ae <tlb_invalidate>
                    ret = 0;
ffffffffc0203fce:	6b42                	ld	s6,16(sp)
ffffffffc0203fd0:	6ba2                	ld	s7,8(sp)
ffffffffc0203fd2:	b711                	j	ffffffffc0203ed6 <do_pgfault+0xf4>
ffffffffc0203fd4:	57ed                	li	a5,-5
ffffffffc0203fd6:	00890693          	addi	a3,s2,8
ffffffffc0203fda:	60f6b02f          	amoand.d	zero,a5,(a3)
                    tlb_invalidate(mm->pgdir, addr);
ffffffffc0203fde:	0189b503          	ld	a0,24(s3)
                    *ptep |= PTE_W;
ffffffffc0203fe2:	00476713          	ori	a4,a4,4
ffffffffc0203fe6:	00ea3023          	sd	a4,0(s4)
                    tlb_invalidate(mm->pgdir, addr);
ffffffffc0203fea:	85a2                	mv	a1,s0
ffffffffc0203fec:	dc2ff0ef          	jal	ffffffffc02035ae <tlb_invalidate>
                    ret = 0;
ffffffffc0203ff0:	6b42                	ld	s6,16(sp)
ffffffffc0203ff2:	6ba2                	ld	s7,8(sp)
ffffffffc0203ff4:	b5cd                	j	ffffffffc0203ed6 <do_pgfault+0xf4>
ffffffffc0203ff6:	7a02                	ld	s4,32(sp)
    int ret = -E_INVAL;
ffffffffc0203ff8:	5575                	li	a0,-3
ffffffffc0203ffa:	b5cd                	j	ffffffffc0203edc <do_pgfault+0xfa>
ffffffffc0203ffc:	6ae2                	ld	s5,24(sp)
ffffffffc0203ffe:	6b42                	ld	s6,16(sp)
ffffffffc0204000:	6ba2                	ld	s7,8(sp)
ffffffffc0204002:	7a02                	ld	s4,32(sp)
        ret = -E_NO_MEM;
ffffffffc0204004:	5571                	li	a0,-4
ffffffffc0204006:	bdd9                	j	ffffffffc0203edc <do_pgfault+0xfa>
ffffffffc0204008:	7a02                	ld	s4,32(sp)
ffffffffc020400a:	6ae2                	ld	s5,24(sp)
ffffffffc020400c:	6b42                	ld	s6,16(sp)
ffffffffc020400e:	6ba2                	ld	s7,8(sp)
    int ret = -E_INVAL;
ffffffffc0204010:	5575                	li	a0,-3
ffffffffc0204012:	b5e9                	j	ffffffffc0203edc <do_pgfault+0xfa>
ffffffffc0204014:	5575                	li	a0,-3
ffffffffc0204016:	8082                	ret
    return KADDR(page2pa(page));
ffffffffc0204018:	86aa                	mv	a3,a0
ffffffffc020401a:	00003617          	auipc	a2,0x3
ffffffffc020401e:	82660613          	addi	a2,a2,-2010 # ffffffffc0206840 <etext+0xdd2>
ffffffffc0204022:	07100593          	li	a1,113
ffffffffc0204026:	00003517          	auipc	a0,0x3
ffffffffc020402a:	84250513          	addi	a0,a0,-1982 # ffffffffc0206868 <etext+0xdfa>
ffffffffc020402e:	e85a                	sd	s6,16(sp)
ffffffffc0204030:	e45e                	sd	s7,8(sp)
ffffffffc0204032:	c56fc0ef          	jal	ffffffffc0200488 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204036:	00003617          	auipc	a2,0x3
ffffffffc020403a:	8da60613          	addi	a2,a2,-1830 # ffffffffc0206910 <etext+0xea2>
ffffffffc020403e:	06900593          	li	a1,105
ffffffffc0204042:	00003517          	auipc	a0,0x3
ffffffffc0204046:	82650513          	addi	a0,a0,-2010 # ffffffffc0206868 <etext+0xdfa>
ffffffffc020404a:	c3efc0ef          	jal	ffffffffc0200488 <__panic>
    return KADDR(page2pa(page));
ffffffffc020404e:	86be                	mv	a3,a5
ffffffffc0204050:	00002617          	auipc	a2,0x2
ffffffffc0204054:	7f060613          	addi	a2,a2,2032 # ffffffffc0206840 <etext+0xdd2>
ffffffffc0204058:	07100593          	li	a1,113
ffffffffc020405c:	00003517          	auipc	a0,0x3
ffffffffc0204060:	80c50513          	addi	a0,a0,-2036 # ffffffffc0206868 <etext+0xdfa>
ffffffffc0204064:	c24fc0ef          	jal	ffffffffc0200488 <__panic>
ffffffffc0204068:	00002617          	auipc	a2,0x2
ffffffffc020406c:	7d860613          	addi	a2,a2,2008 # ffffffffc0206840 <etext+0xdd2>
ffffffffc0204070:	07100593          	li	a1,113
ffffffffc0204074:	00002517          	auipc	a0,0x2
ffffffffc0204078:	7f450513          	addi	a0,a0,2036 # ffffffffc0206868 <etext+0xdfa>
ffffffffc020407c:	c0cfc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0204080 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0204080:	8526                	mv	a0,s1
	jalr s0
ffffffffc0204082:	9402                	jalr	s0

	jal do_exit
ffffffffc0204084:	632000ef          	jal	ffffffffc02046b6 <do_exit>

ffffffffc0204088 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0204088:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc020408a:	10800513          	li	a0,264
{
ffffffffc020408e:	e022                	sd	s0,0(sp)
ffffffffc0204090:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204092:	c9bfd0ef          	jal	ffffffffc0201d2c <kmalloc>
ffffffffc0204096:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0204098:	cd21                	beqz	a0,ffffffffc02040f0 <alloc_proc+0x68>
         *       struct trapframe *tf;                       // Trap frame for current interrupt
         *       uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         */
         proc->state = PROC_UNINIT;  // 进程状态为未初始化
ffffffffc020409a:	57fd                	li	a5,-1
ffffffffc020409c:	1782                	slli	a5,a5,0x20
ffffffffc020409e:	e11c                	sd	a5,0(a0)
         proc->pid = -1;             // 进程ID初始化为-1（无效）
         proc->runs = 0;             // 运行次数初始化为0
ffffffffc02040a0:	00052423          	sw	zero,8(a0)
         proc->kstack = 0;           // 内核栈地址初始化为0
ffffffffc02040a4:	00053823          	sd	zero,16(a0)
         proc->need_resched = 0;     // 不需要调度
ffffffffc02040a8:	00053c23          	sd	zero,24(a0)
         proc->parent = NULL;        // 父进程指针为空
ffffffffc02040ac:	02053023          	sd	zero,32(a0)
         proc->mm = NULL;            // 内存管理结构为空
ffffffffc02040b0:	02053423          	sd	zero,40(a0)
         memset(&(proc->context), 0, sizeof(struct context)); // 上下文清零
ffffffffc02040b4:	07000613          	li	a2,112
ffffffffc02040b8:	4581                	li	a1,0
ffffffffc02040ba:	03050513          	addi	a0,a0,48
ffffffffc02040be:	187010ef          	jal	ffffffffc0205a44 <memset>
         proc->tf = NULL;            // 陷阱帧指针为空
         proc->pgdir = boot_pgdir_pa;            // 页目录基址为boot_pgdir_pa
ffffffffc02040c2:	0009b797          	auipc	a5,0x9b
ffffffffc02040c6:	d6e7b783          	ld	a5,-658(a5) # ffffffffc029ee30 <boot_pgdir_pa>
         proc->tf = NULL;            // 陷阱帧指针为空
ffffffffc02040ca:	0a043023          	sd	zero,160(s0)
         proc->pgdir = boot_pgdir_pa;            // 页目录基址为boot_pgdir_pa
ffffffffc02040ce:	f45c                	sd	a5,168(s0)
         proc->flags = 0;            // 进程标志为0
ffffffffc02040d0:	0a042823          	sw	zero,176(s0)
         memset(proc->name, 0, PROC_NAME_LEN); // 进程名清零
ffffffffc02040d4:	463d                	li	a2,15
ffffffffc02040d6:	4581                	li	a1,0
ffffffffc02040d8:	0b440513          	addi	a0,s0,180
ffffffffc02040dc:	169010ef          	jal	ffffffffc0205a44 <memset>
        /*
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
         proc->wait_state = 0;        // 等待状态初始化为0
ffffffffc02040e0:	0e042623          	sw	zero,236(s0)
         proc->cptr = NULL;           // 子进程指针为空
ffffffffc02040e4:	0e043823          	sd	zero,240(s0)
         proc->yptr = NULL;           // 弟弟进程指针为空
ffffffffc02040e8:	0e043c23          	sd	zero,248(s0)
         proc->optr = NULL;           // 哥哥进程指针为空
ffffffffc02040ec:	10043023          	sd	zero,256(s0)
    }
    return proc;
}
ffffffffc02040f0:	60a2                	ld	ra,8(sp)
ffffffffc02040f2:	8522                	mv	a0,s0
ffffffffc02040f4:	6402                	ld	s0,0(sp)
ffffffffc02040f6:	0141                	addi	sp,sp,16
ffffffffc02040f8:	8082                	ret

ffffffffc02040fa <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc02040fa:	0009b797          	auipc	a5,0x9b
ffffffffc02040fe:	d667b783          	ld	a5,-666(a5) # ffffffffc029ee60 <current>
ffffffffc0204102:	73c8                	ld	a0,160(a5)
ffffffffc0204104:	ebbfc06f          	j	ffffffffc0200fbe <forkrets>

ffffffffc0204108 <user_main>:
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204108:	0009b797          	auipc	a5,0x9b
ffffffffc020410c:	d587b783          	ld	a5,-680(a5) # ffffffffc029ee60 <current>
ffffffffc0204110:	43cc                	lw	a1,4(a5)
{
ffffffffc0204112:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204114:	00003617          	auipc	a2,0x3
ffffffffc0204118:	0cc60613          	addi	a2,a2,204 # ffffffffc02071e0 <etext+0x1772>
ffffffffc020411c:	00003517          	auipc	a0,0x3
ffffffffc0204120:	0cc50513          	addi	a0,a0,204 # ffffffffc02071e8 <etext+0x177a>
{
ffffffffc0204124:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204126:	86efc0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020412a:	3fe05797          	auipc	a5,0x3fe05
ffffffffc020412e:	76678793          	addi	a5,a5,1894 # 9890 <_binary_obj___user_cowtest_out_size>
ffffffffc0204132:	e43e                	sd	a5,8(sp)
ffffffffc0204134:	00003517          	auipc	a0,0x3
ffffffffc0204138:	0ac50513          	addi	a0,a0,172 # ffffffffc02071e0 <etext+0x1772>
ffffffffc020413c:	00019797          	auipc	a5,0x19
ffffffffc0204140:	09c78793          	addi	a5,a5,156 # ffffffffc021d1d8 <_binary_obj___user_cowtest_out_start>
ffffffffc0204144:	f03e                	sd	a5,32(sp)
ffffffffc0204146:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc0204148:	e802                	sd	zero,16(sp)
ffffffffc020414a:	03d010ef          	jal	ffffffffc0205986 <strlen>
ffffffffc020414e:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0204150:	4511                	li	a0,4
ffffffffc0204152:	55a2                	lw	a1,40(sp)
ffffffffc0204154:	4662                	lw	a2,24(sp)
ffffffffc0204156:	5682                	lw	a3,32(sp)
ffffffffc0204158:	4722                	lw	a4,8(sp)
ffffffffc020415a:	48a9                	li	a7,10
ffffffffc020415c:	9002                	ebreak
ffffffffc020415e:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0204160:	65c2                	ld	a1,16(sp)
ffffffffc0204162:	00003517          	auipc	a0,0x3
ffffffffc0204166:	0ae50513          	addi	a0,a0,174 # ffffffffc0207210 <etext+0x17a2>
ffffffffc020416a:	82afc0ef          	jal	ffffffffc0200194 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc020416e:	00003617          	auipc	a2,0x3
ffffffffc0204172:	0b260613          	addi	a2,a2,178 # ffffffffc0207220 <etext+0x17b2>
ffffffffc0204176:	3d600593          	li	a1,982
ffffffffc020417a:	00003517          	auipc	a0,0x3
ffffffffc020417e:	0c650513          	addi	a0,a0,198 # ffffffffc0207240 <etext+0x17d2>
ffffffffc0204182:	b06fc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0204186 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0204186:	6d14                	ld	a3,24(a0)
{
ffffffffc0204188:	1141                	addi	sp,sp,-16
ffffffffc020418a:	e406                	sd	ra,8(sp)
ffffffffc020418c:	c02007b7          	lui	a5,0xc0200
ffffffffc0204190:	02f6ee63          	bltu	a3,a5,ffffffffc02041cc <put_pgdir+0x46>
ffffffffc0204194:	0009b797          	auipc	a5,0x9b
ffffffffc0204198:	cac7b783          	ld	a5,-852(a5) # ffffffffc029ee40 <va_pa_offset>
ffffffffc020419c:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc020419e:	82b1                	srli	a3,a3,0xc
ffffffffc02041a0:	0009b797          	auipc	a5,0x9b
ffffffffc02041a4:	ca87b783          	ld	a5,-856(a5) # ffffffffc029ee48 <npage>
ffffffffc02041a8:	02f6fe63          	bgeu	a3,a5,ffffffffc02041e4 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc02041ac:	00004797          	auipc	a5,0x4
ffffffffc02041b0:	a1c7b783          	ld	a5,-1508(a5) # ffffffffc0207bc8 <nbase>
}
ffffffffc02041b4:	60a2                	ld	ra,8(sp)
ffffffffc02041b6:	8e9d                	sub	a3,a3,a5
    free_page(kva2page(mm->pgdir));
ffffffffc02041b8:	0009b517          	auipc	a0,0x9b
ffffffffc02041bc:	c9853503          	ld	a0,-872(a0) # ffffffffc029ee50 <pages>
ffffffffc02041c0:	069a                	slli	a3,a3,0x6
ffffffffc02041c2:	4585                	li	a1,1
ffffffffc02041c4:	9536                	add	a0,a0,a3
}
ffffffffc02041c6:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc02041c8:	d7bfd06f          	j	ffffffffc0201f42 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc02041cc:	00002617          	auipc	a2,0x2
ffffffffc02041d0:	71c60613          	addi	a2,a2,1820 # ffffffffc02068e8 <etext+0xe7a>
ffffffffc02041d4:	07700593          	li	a1,119
ffffffffc02041d8:	00002517          	auipc	a0,0x2
ffffffffc02041dc:	69050513          	addi	a0,a0,1680 # ffffffffc0206868 <etext+0xdfa>
ffffffffc02041e0:	aa8fc0ef          	jal	ffffffffc0200488 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02041e4:	00002617          	auipc	a2,0x2
ffffffffc02041e8:	72c60613          	addi	a2,a2,1836 # ffffffffc0206910 <etext+0xea2>
ffffffffc02041ec:	06900593          	li	a1,105
ffffffffc02041f0:	00002517          	auipc	a0,0x2
ffffffffc02041f4:	67850513          	addi	a0,a0,1656 # ffffffffc0206868 <etext+0xdfa>
ffffffffc02041f8:	a90fc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02041fc <proc_run>:
{
ffffffffc02041fc:	7179                	addi	sp,sp,-48
ffffffffc02041fe:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0204200:	0009b917          	auipc	s2,0x9b
ffffffffc0204204:	c6090913          	addi	s2,s2,-928 # ffffffffc029ee60 <current>
{
ffffffffc0204208:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc020420a:	00093483          	ld	s1,0(s2)
{
ffffffffc020420e:	f406                	sd	ra,40(sp)
    if (proc != current)
ffffffffc0204210:	02a48a63          	beq	s1,a0,ffffffffc0204244 <proc_run+0x48>
ffffffffc0204214:	e84e                	sd	s3,16(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204216:	100027f3          	csrr	a5,sstatus
ffffffffc020421a:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020421c:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020421e:	ef9d                	bnez	a5,ffffffffc020425c <proc_run+0x60>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0204220:	755c                	ld	a5,168(a0)
ffffffffc0204222:	577d                	li	a4,-1
ffffffffc0204224:	177e                	slli	a4,a4,0x3f
ffffffffc0204226:	83b1                	srli	a5,a5,0xc
            current = proc;
ffffffffc0204228:	00a93023          	sd	a0,0(s2)
ffffffffc020422c:	8fd9                	or	a5,a5,a4
ffffffffc020422e:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(next->context));
ffffffffc0204232:	03050593          	addi	a1,a0,48
ffffffffc0204236:	03048513          	addi	a0,s1,48
ffffffffc020423a:	0de010ef          	jal	ffffffffc0205318 <switch_to>
    if (flag)
ffffffffc020423e:	00099863          	bnez	s3,ffffffffc020424e <proc_run+0x52>
ffffffffc0204242:	69c2                	ld	s3,16(sp)
}
ffffffffc0204244:	70a2                	ld	ra,40(sp)
ffffffffc0204246:	7482                	ld	s1,32(sp)
ffffffffc0204248:	6962                	ld	s2,24(sp)
ffffffffc020424a:	6145                	addi	sp,sp,48
ffffffffc020424c:	8082                	ret
        intr_enable();
ffffffffc020424e:	69c2                	ld	s3,16(sp)
ffffffffc0204250:	70a2                	ld	ra,40(sp)
ffffffffc0204252:	7482                	ld	s1,32(sp)
ffffffffc0204254:	6962                	ld	s2,24(sp)
ffffffffc0204256:	6145                	addi	sp,sp,48
ffffffffc0204258:	f1cfc06f          	j	ffffffffc0200974 <intr_enable>
ffffffffc020425c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020425e:	f1cfc0ef          	jal	ffffffffc020097a <intr_disable>
        return 1;
ffffffffc0204262:	6522                	ld	a0,8(sp)
ffffffffc0204264:	4985                	li	s3,1
ffffffffc0204266:	bf6d                	j	ffffffffc0204220 <proc_run+0x24>

ffffffffc0204268 <do_fork>:
{
ffffffffc0204268:	7119                	addi	sp,sp,-128
ffffffffc020426a:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc020426c:	0009b917          	auipc	s2,0x9b
ffffffffc0204270:	bec90913          	addi	s2,s2,-1044 # ffffffffc029ee58 <nr_process>
ffffffffc0204274:	00092703          	lw	a4,0(s2)
{
ffffffffc0204278:	fc86                	sd	ra,120(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc020427a:	6785                	lui	a5,0x1
ffffffffc020427c:	34f75863          	bge	a4,a5,ffffffffc02045cc <do_fork+0x364>
ffffffffc0204280:	f8a2                	sd	s0,112(sp)
ffffffffc0204282:	f4a6                	sd	s1,104(sp)
ffffffffc0204284:	ecce                	sd	s3,88(sp)
ffffffffc0204286:	e8d2                	sd	s4,80(sp)
ffffffffc0204288:	89ae                	mv	s3,a1
ffffffffc020428a:	8a2a                	mv	s4,a0
ffffffffc020428c:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc020428e:	dfbff0ef          	jal	ffffffffc0204088 <alloc_proc>
ffffffffc0204292:	84aa                	mv	s1,a0
ffffffffc0204294:	32050063          	beqz	a0,ffffffffc02045b4 <do_fork+0x34c>
ffffffffc0204298:	f862                	sd	s8,48(sp)
    proc->parent = current;
ffffffffc020429a:	0009bc17          	auipc	s8,0x9b
ffffffffc020429e:	bc6c0c13          	addi	s8,s8,-1082 # ffffffffc029ee60 <current>
ffffffffc02042a2:	000c3783          	ld	a5,0(s8)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc02042a6:	4509                	li	a0,2
    proc->parent = current;
ffffffffc02042a8:	f09c                	sd	a5,32(s1)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc02042aa:	c5bfd0ef          	jal	ffffffffc0201f04 <alloc_pages>
    if (page != NULL)
ffffffffc02042ae:	2e050f63          	beqz	a0,ffffffffc02045ac <do_fork+0x344>
ffffffffc02042b2:	e4d6                	sd	s5,72(sp)
    return page - pages + nbase;
ffffffffc02042b4:	0009ba97          	auipc	s5,0x9b
ffffffffc02042b8:	b9ca8a93          	addi	s5,s5,-1124 # ffffffffc029ee50 <pages>
ffffffffc02042bc:	000ab703          	ld	a4,0(s5)
ffffffffc02042c0:	e0da                	sd	s6,64(sp)
ffffffffc02042c2:	00004b17          	auipc	s6,0x4
ffffffffc02042c6:	906b0b13          	addi	s6,s6,-1786 # ffffffffc0207bc8 <nbase>
ffffffffc02042ca:	000b3783          	ld	a5,0(s6)
ffffffffc02042ce:	40e506b3          	sub	a3,a0,a4
ffffffffc02042d2:	fc5e                	sd	s7,56(sp)
    return KADDR(page2pa(page));
ffffffffc02042d4:	0009bb97          	auipc	s7,0x9b
ffffffffc02042d8:	b74b8b93          	addi	s7,s7,-1164 # ffffffffc029ee48 <npage>
ffffffffc02042dc:	ec6e                	sd	s11,24(sp)
    return page - pages + nbase;
ffffffffc02042de:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc02042e0:	5dfd                	li	s11,-1
ffffffffc02042e2:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc02042e6:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02042e8:	00cddd93          	srli	s11,s11,0xc
ffffffffc02042ec:	01b6f633          	and	a2,a3,s11
ffffffffc02042f0:	f06a                	sd	s10,32(sp)
    return page2ppn(page) << PGSHIFT;
ffffffffc02042f2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02042f4:	34e67c63          	bgeu	a2,a4,ffffffffc020464c <do_fork+0x3e4>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc02042f8:	000c3603          	ld	a2,0(s8)
ffffffffc02042fc:	0009bc17          	auipc	s8,0x9b
ffffffffc0204300:	b44c0c13          	addi	s8,s8,-1212 # ffffffffc029ee40 <va_pa_offset>
ffffffffc0204304:	000c3703          	ld	a4,0(s8)
ffffffffc0204308:	02863d03          	ld	s10,40(a2)
ffffffffc020430c:	e43e                	sd	a5,8(sp)
ffffffffc020430e:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0204310:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc0204312:	020d0863          	beqz	s10,ffffffffc0204342 <do_fork+0xda>
    if (clone_flags & CLONE_VM)
ffffffffc0204316:	100a7a13          	andi	s4,s4,256
ffffffffc020431a:	1a0a0f63          	beqz	s4,ffffffffc02044d8 <do_fork+0x270>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc020431e:	030d2703          	lw	a4,48(s10) # ffffffffffe00030 <end+0x3fb611b8>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204322:	018d3783          	ld	a5,24(s10)
ffffffffc0204326:	c02006b7          	lui	a3,0xc0200
ffffffffc020432a:	2705                	addiw	a4,a4,1
ffffffffc020432c:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc0204330:	03a4b423          	sd	s10,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204334:	2ed7e263          	bltu	a5,a3,ffffffffc0204618 <do_fork+0x3b0>
ffffffffc0204338:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020433c:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020433e:	8f99                	sub	a5,a5,a4
ffffffffc0204340:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204342:	6789                	lui	a5,0x2
ffffffffc0204344:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_softint_out_size-0x66b8>
ffffffffc0204348:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc020434a:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020434c:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc020434e:	87b6                	mv	a5,a3
ffffffffc0204350:	12040893          	addi	a7,s0,288
ffffffffc0204354:	00063803          	ld	a6,0(a2)
ffffffffc0204358:	6608                	ld	a0,8(a2)
ffffffffc020435a:	6a0c                	ld	a1,16(a2)
ffffffffc020435c:	6e18                	ld	a4,24(a2)
ffffffffc020435e:	0107b023          	sd	a6,0(a5)
ffffffffc0204362:	e788                	sd	a0,8(a5)
ffffffffc0204364:	eb8c                	sd	a1,16(a5)
ffffffffc0204366:	ef98                	sd	a4,24(a5)
ffffffffc0204368:	02060613          	addi	a2,a2,32
ffffffffc020436c:	02078793          	addi	a5,a5,32
ffffffffc0204370:	ff1612e3          	bne	a2,a7,ffffffffc0204354 <do_fork+0xec>
    proc->tf->gpr.a0 = 0;
ffffffffc0204374:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204378:	12098d63          	beqz	s3,ffffffffc02044b2 <do_fork+0x24a>
ffffffffc020437c:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204380:	00000797          	auipc	a5,0x0
ffffffffc0204384:	d7a78793          	addi	a5,a5,-646 # ffffffffc02040fa <forkret>
ffffffffc0204388:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc020438a:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020438c:	100027f3          	csrr	a5,sstatus
ffffffffc0204390:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204392:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204394:	12079e63          	bnez	a5,ffffffffc02044d0 <do_fork+0x268>
    if (++last_pid >= MAX_PID)
ffffffffc0204398:	00096817          	auipc	a6,0x96
ffffffffc020439c:	62c80813          	addi	a6,a6,1580 # ffffffffc029a9c4 <last_pid.1>
ffffffffc02043a0:	00082783          	lw	a5,0(a6)
ffffffffc02043a4:	6709                	lui	a4,0x2
ffffffffc02043a6:	0017851b          	addiw	a0,a5,1
ffffffffc02043aa:	00a82023          	sw	a0,0(a6)
ffffffffc02043ae:	08e55c63          	bge	a0,a4,ffffffffc0204446 <do_fork+0x1de>
    if (last_pid >= next_safe)
ffffffffc02043b2:	00096317          	auipc	t1,0x96
ffffffffc02043b6:	60e30313          	addi	t1,t1,1550 # ffffffffc029a9c0 <next_safe.0>
ffffffffc02043ba:	00032783          	lw	a5,0(t1)
ffffffffc02043be:	0009b417          	auipc	s0,0x9b
ffffffffc02043c2:	a2240413          	addi	s0,s0,-1502 # ffffffffc029ede0 <proc_list>
ffffffffc02043c6:	08f55863          	bge	a0,a5,ffffffffc0204456 <do_fork+0x1ee>
        proc->pid = get_pid();
ffffffffc02043ca:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc02043cc:	45a9                	li	a1,10
ffffffffc02043ce:	2501                	sext.w	a0,a0
ffffffffc02043d0:	1b8010ef          	jal	ffffffffc0205588 <hash32>
ffffffffc02043d4:	02051793          	slli	a5,a0,0x20
ffffffffc02043d8:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02043dc:	00097797          	auipc	a5,0x97
ffffffffc02043e0:	a0478793          	addi	a5,a5,-1532 # ffffffffc029ade0 <hash_list>
ffffffffc02043e4:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc02043e6:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc02043e8:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc02043ea:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc02043ee:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc02043f0:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc02043f2:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc02043f4:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc02043f6:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc02043fa:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc02043fc:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc02043fe:	e21c                	sd	a5,0(a2)
ffffffffc0204400:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc0204402:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc0204404:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc0204406:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020440a:	10e4b023          	sd	a4,256(s1)
ffffffffc020440e:	c311                	beqz	a4,ffffffffc0204412 <do_fork+0x1aa>
        proc->optr->yptr = proc;
ffffffffc0204410:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc0204412:	00092783          	lw	a5,0(s2)
    proc->parent->cptr = proc;
ffffffffc0204416:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc0204418:	2785                	addiw	a5,a5,1
ffffffffc020441a:	00f92023          	sw	a5,0(s2)
    if (flag)
ffffffffc020441e:	12099d63          	bnez	s3,ffffffffc0204558 <do_fork+0x2f0>
    wakeup_proc(proc);
ffffffffc0204422:	8526                	mv	a0,s1
ffffffffc0204424:	75f000ef          	jal	ffffffffc0205382 <wakeup_proc>
    ret = proc->pid;
ffffffffc0204428:	40c8                	lw	a0,4(s1)
ffffffffc020442a:	7446                	ld	s0,112(sp)
ffffffffc020442c:	74a6                	ld	s1,104(sp)
ffffffffc020442e:	69e6                	ld	s3,88(sp)
ffffffffc0204430:	6a46                	ld	s4,80(sp)
ffffffffc0204432:	6aa6                	ld	s5,72(sp)
ffffffffc0204434:	6b06                	ld	s6,64(sp)
ffffffffc0204436:	7be2                	ld	s7,56(sp)
ffffffffc0204438:	7c42                	ld	s8,48(sp)
ffffffffc020443a:	7d02                	ld	s10,32(sp)
ffffffffc020443c:	6de2                	ld	s11,24(sp)
}
ffffffffc020443e:	70e6                	ld	ra,120(sp)
ffffffffc0204440:	7906                	ld	s2,96(sp)
ffffffffc0204442:	6109                	addi	sp,sp,128
ffffffffc0204444:	8082                	ret
        last_pid = 1;
ffffffffc0204446:	4785                	li	a5,1
ffffffffc0204448:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc020444c:	4505                	li	a0,1
ffffffffc020444e:	00096317          	auipc	t1,0x96
ffffffffc0204452:	57230313          	addi	t1,t1,1394 # ffffffffc029a9c0 <next_safe.0>
    return listelm->next;
ffffffffc0204456:	0009b417          	auipc	s0,0x9b
ffffffffc020445a:	98a40413          	addi	s0,s0,-1654 # ffffffffc029ede0 <proc_list>
ffffffffc020445e:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc0204462:	6789                	lui	a5,0x2
ffffffffc0204464:	00f32023          	sw	a5,0(t1)
ffffffffc0204468:	86aa                	mv	a3,a0
ffffffffc020446a:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc020446c:	028e0e63          	beq	t3,s0,ffffffffc02044a8 <do_fork+0x240>
ffffffffc0204470:	88ae                	mv	a7,a1
ffffffffc0204472:	87f2                	mv	a5,t3
ffffffffc0204474:	6609                	lui	a2,0x2
ffffffffc0204476:	a811                	j	ffffffffc020448a <do_fork+0x222>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204478:	00e6d663          	bge	a3,a4,ffffffffc0204484 <do_fork+0x21c>
ffffffffc020447c:	00c75463          	bge	a4,a2,ffffffffc0204484 <do_fork+0x21c>
                next_safe = proc->pid;
ffffffffc0204480:	863a                	mv	a2,a4
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204482:	4885                	li	a7,1
ffffffffc0204484:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204486:	00878d63          	beq	a5,s0,ffffffffc02044a0 <do_fork+0x238>
            if (proc->pid == last_pid)
ffffffffc020448a:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_softint_out_size-0x665c>
ffffffffc020448e:	fed715e3          	bne	a4,a3,ffffffffc0204478 <do_fork+0x210>
                if (++last_pid >= next_safe)
ffffffffc0204492:	2685                	addiw	a3,a3,1
ffffffffc0204494:	12c6d663          	bge	a3,a2,ffffffffc02045c0 <do_fork+0x358>
ffffffffc0204498:	679c                	ld	a5,8(a5)
ffffffffc020449a:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc020449c:	fe8797e3          	bne	a5,s0,ffffffffc020448a <do_fork+0x222>
ffffffffc02044a0:	00088463          	beqz	a7,ffffffffc02044a8 <do_fork+0x240>
ffffffffc02044a4:	00c32023          	sw	a2,0(t1)
ffffffffc02044a8:	d18d                	beqz	a1,ffffffffc02043ca <do_fork+0x162>
ffffffffc02044aa:	00d82023          	sw	a3,0(a6)
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02044ae:	8536                	mv	a0,a3
ffffffffc02044b0:	bf29                	j	ffffffffc02043ca <do_fork+0x162>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02044b2:	89b6                	mv	s3,a3
ffffffffc02044b4:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02044b8:	00000797          	auipc	a5,0x0
ffffffffc02044bc:	c4278793          	addi	a5,a5,-958 # ffffffffc02040fa <forkret>
ffffffffc02044c0:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02044c2:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02044c4:	100027f3          	csrr	a5,sstatus
ffffffffc02044c8:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02044ca:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02044cc:	ec0786e3          	beqz	a5,ffffffffc0204398 <do_fork+0x130>
        intr_disable();
ffffffffc02044d0:	caafc0ef          	jal	ffffffffc020097a <intr_disable>
        return 1;
ffffffffc02044d4:	4985                	li	s3,1
ffffffffc02044d6:	b5c9                	j	ffffffffc0204398 <do_fork+0x130>
ffffffffc02044d8:	f466                	sd	s9,40(sp)
    if ((mm = mm_create()) == NULL)
ffffffffc02044da:	9ccff0ef          	jal	ffffffffc02036a6 <mm_create>
ffffffffc02044de:	8caa                	mv	s9,a0
ffffffffc02044e0:	c941                	beqz	a0,ffffffffc0204570 <do_fork+0x308>
    if ((page = alloc_page()) == NULL)
ffffffffc02044e2:	4505                	li	a0,1
ffffffffc02044e4:	a21fd0ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc02044e8:	c149                	beqz	a0,ffffffffc020456a <do_fork+0x302>
    return page - pages + nbase;
ffffffffc02044ea:	000ab683          	ld	a3,0(s5)
ffffffffc02044ee:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc02044f0:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc02044f4:	40d506b3          	sub	a3,a0,a3
ffffffffc02044f8:	8699                	srai	a3,a3,0x6
ffffffffc02044fa:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02044fc:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc0204500:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204502:	0cedf763          	bgeu	s11,a4,ffffffffc02045d0 <do_fork+0x368>
ffffffffc0204506:	000c3783          	ld	a5,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc020450a:	6605                	lui	a2,0x1
ffffffffc020450c:	0009b597          	auipc	a1,0x9b
ffffffffc0204510:	92c5b583          	ld	a1,-1748(a1) # ffffffffc029ee38 <boot_pgdir_va>
ffffffffc0204514:	00f68a33          	add	s4,a3,a5
ffffffffc0204518:	8552                	mv	a0,s4
ffffffffc020451a:	53c010ef          	jal	ffffffffc0205a56 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc020451e:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc0204522:	014cbc23          	sd	s4,24(s9)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204526:	4785                	li	a5,1
ffffffffc0204528:	40fdb7af          	amoor.d	a5,a5,(s11)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc020452c:	8b85                	andi	a5,a5,1
ffffffffc020452e:	4a05                	li	s4,1
ffffffffc0204530:	c799                	beqz	a5,ffffffffc020453e <do_fork+0x2d6>
    {
        schedule();
ffffffffc0204532:	6eb000ef          	jal	ffffffffc020541c <schedule>
ffffffffc0204536:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc020453a:	8b85                	andi	a5,a5,1
ffffffffc020453c:	fbfd                	bnez	a5,ffffffffc0204532 <do_fork+0x2ca>
        ret = dup_mmap(mm, oldmm);
ffffffffc020453e:	85ea                	mv	a1,s10
ffffffffc0204540:	8566                	mv	a0,s9
ffffffffc0204542:	bc4ff0ef          	jal	ffffffffc0203906 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0204546:	57f9                	li	a5,-2
ffffffffc0204548:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc020454c:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc020454e:	cbcd                	beqz	a5,ffffffffc0204600 <do_fork+0x398>
    if ((mm = mm_create()) == NULL)
ffffffffc0204550:	8d66                	mv	s10,s9
    if (ret != 0)
ffffffffc0204552:	e511                	bnez	a0,ffffffffc020455e <do_fork+0x2f6>
ffffffffc0204554:	7ca2                	ld	s9,40(sp)
ffffffffc0204556:	b3e1                	j	ffffffffc020431e <do_fork+0xb6>
        intr_enable();
ffffffffc0204558:	c1cfc0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc020455c:	b5d9                	j	ffffffffc0204422 <do_fork+0x1ba>
    exit_mmap(mm);
ffffffffc020455e:	8566                	mv	a0,s9
ffffffffc0204560:	c3eff0ef          	jal	ffffffffc020399e <exit_mmap>
    put_pgdir(mm);
ffffffffc0204564:	8566                	mv	a0,s9
ffffffffc0204566:	c21ff0ef          	jal	ffffffffc0204186 <put_pgdir>
    mm_destroy(mm);
ffffffffc020456a:	8566                	mv	a0,s9
ffffffffc020456c:	a7aff0ef          	jal	ffffffffc02037e6 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204570:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc0204572:	c02007b7          	lui	a5,0xc0200
ffffffffc0204576:	0af6ef63          	bltu	a3,a5,ffffffffc0204634 <do_fork+0x3cc>
ffffffffc020457a:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc020457e:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc0204582:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204586:	83b1                	srli	a5,a5,0xc
ffffffffc0204588:	06e7f063          	bgeu	a5,a4,ffffffffc02045e8 <do_fork+0x380>
    return &pages[PPN(pa) - nbase];
ffffffffc020458c:	000b3703          	ld	a4,0(s6)
ffffffffc0204590:	000ab503          	ld	a0,0(s5)
ffffffffc0204594:	4589                	li	a1,2
ffffffffc0204596:	8f99                	sub	a5,a5,a4
ffffffffc0204598:	079a                	slli	a5,a5,0x6
ffffffffc020459a:	953e                	add	a0,a0,a5
ffffffffc020459c:	9a7fd0ef          	jal	ffffffffc0201f42 <free_pages>
}
ffffffffc02045a0:	6aa6                	ld	s5,72(sp)
ffffffffc02045a2:	6b06                	ld	s6,64(sp)
ffffffffc02045a4:	7be2                	ld	s7,56(sp)
ffffffffc02045a6:	7ca2                	ld	s9,40(sp)
ffffffffc02045a8:	7d02                	ld	s10,32(sp)
ffffffffc02045aa:	6de2                	ld	s11,24(sp)
    kfree(proc);
ffffffffc02045ac:	8526                	mv	a0,s1
ffffffffc02045ae:	829fd0ef          	jal	ffffffffc0201dd6 <kfree>
ffffffffc02045b2:	7c42                	ld	s8,48(sp)
ffffffffc02045b4:	7446                	ld	s0,112(sp)
ffffffffc02045b6:	74a6                	ld	s1,104(sp)
ffffffffc02045b8:	69e6                	ld	s3,88(sp)
ffffffffc02045ba:	6a46                	ld	s4,80(sp)
    ret = -E_NO_MEM;
ffffffffc02045bc:	5571                	li	a0,-4
    return ret;
ffffffffc02045be:	b541                	j	ffffffffc020443e <do_fork+0x1d6>
                    if (last_pid >= MAX_PID)
ffffffffc02045c0:	6789                	lui	a5,0x2
ffffffffc02045c2:	00f6c363          	blt	a3,a5,ffffffffc02045c8 <do_fork+0x360>
                        last_pid = 1;
ffffffffc02045c6:	4685                	li	a3,1
                    goto repeat;
ffffffffc02045c8:	4585                	li	a1,1
ffffffffc02045ca:	b54d                	j	ffffffffc020446c <do_fork+0x204>
    int ret = -E_NO_FREE_PROC;
ffffffffc02045cc:	556d                	li	a0,-5
ffffffffc02045ce:	bd85                	j	ffffffffc020443e <do_fork+0x1d6>
    return KADDR(page2pa(page));
ffffffffc02045d0:	00002617          	auipc	a2,0x2
ffffffffc02045d4:	27060613          	addi	a2,a2,624 # ffffffffc0206840 <etext+0xdd2>
ffffffffc02045d8:	07100593          	li	a1,113
ffffffffc02045dc:	00002517          	auipc	a0,0x2
ffffffffc02045e0:	28c50513          	addi	a0,a0,652 # ffffffffc0206868 <etext+0xdfa>
ffffffffc02045e4:	ea5fb0ef          	jal	ffffffffc0200488 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02045e8:	00002617          	auipc	a2,0x2
ffffffffc02045ec:	32860613          	addi	a2,a2,808 # ffffffffc0206910 <etext+0xea2>
ffffffffc02045f0:	06900593          	li	a1,105
ffffffffc02045f4:	00002517          	auipc	a0,0x2
ffffffffc02045f8:	27450513          	addi	a0,a0,628 # ffffffffc0206868 <etext+0xdfa>
ffffffffc02045fc:	e8dfb0ef          	jal	ffffffffc0200488 <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc0204600:	00003617          	auipc	a2,0x3
ffffffffc0204604:	c5860613          	addi	a2,a2,-936 # ffffffffc0207258 <etext+0x17ea>
ffffffffc0204608:	03f00593          	li	a1,63
ffffffffc020460c:	00003517          	auipc	a0,0x3
ffffffffc0204610:	c5c50513          	addi	a0,a0,-932 # ffffffffc0207268 <etext+0x17fa>
ffffffffc0204614:	e75fb0ef          	jal	ffffffffc0200488 <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204618:	86be                	mv	a3,a5
ffffffffc020461a:	00002617          	auipc	a2,0x2
ffffffffc020461e:	2ce60613          	addi	a2,a2,718 # ffffffffc02068e8 <etext+0xe7a>
ffffffffc0204622:	19900593          	li	a1,409
ffffffffc0204626:	00003517          	auipc	a0,0x3
ffffffffc020462a:	c1a50513          	addi	a0,a0,-998 # ffffffffc0207240 <etext+0x17d2>
ffffffffc020462e:	f466                	sd	s9,40(sp)
ffffffffc0204630:	e59fb0ef          	jal	ffffffffc0200488 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204634:	00002617          	auipc	a2,0x2
ffffffffc0204638:	2b460613          	addi	a2,a2,692 # ffffffffc02068e8 <etext+0xe7a>
ffffffffc020463c:	07700593          	li	a1,119
ffffffffc0204640:	00002517          	auipc	a0,0x2
ffffffffc0204644:	22850513          	addi	a0,a0,552 # ffffffffc0206868 <etext+0xdfa>
ffffffffc0204648:	e41fb0ef          	jal	ffffffffc0200488 <__panic>
    return KADDR(page2pa(page));
ffffffffc020464c:	00002617          	auipc	a2,0x2
ffffffffc0204650:	1f460613          	addi	a2,a2,500 # ffffffffc0206840 <etext+0xdd2>
ffffffffc0204654:	07100593          	li	a1,113
ffffffffc0204658:	00002517          	auipc	a0,0x2
ffffffffc020465c:	21050513          	addi	a0,a0,528 # ffffffffc0206868 <etext+0xdfa>
ffffffffc0204660:	f466                	sd	s9,40(sp)
ffffffffc0204662:	e27fb0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0204666 <kernel_thread>:
{
ffffffffc0204666:	7129                	addi	sp,sp,-320
ffffffffc0204668:	fa22                	sd	s0,304(sp)
ffffffffc020466a:	f626                	sd	s1,296(sp)
ffffffffc020466c:	f24a                	sd	s2,288(sp)
ffffffffc020466e:	84ae                	mv	s1,a1
ffffffffc0204670:	892a                	mv	s2,a0
ffffffffc0204672:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204674:	4581                	li	a1,0
ffffffffc0204676:	12000613          	li	a2,288
ffffffffc020467a:	850a                	mv	a0,sp
{
ffffffffc020467c:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020467e:	3c6010ef          	jal	ffffffffc0205a44 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc0204682:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc0204684:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204686:	100027f3          	csrr	a5,sstatus
ffffffffc020468a:	edd7f793          	andi	a5,a5,-291
ffffffffc020468e:	1207e793          	ori	a5,a5,288
ffffffffc0204692:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204694:	860a                	mv	a2,sp
ffffffffc0204696:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020469a:	00000797          	auipc	a5,0x0
ffffffffc020469e:	9e678793          	addi	a5,a5,-1562 # ffffffffc0204080 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02046a2:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02046a4:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02046a6:	bc3ff0ef          	jal	ffffffffc0204268 <do_fork>
}
ffffffffc02046aa:	70f2                	ld	ra,312(sp)
ffffffffc02046ac:	7452                	ld	s0,304(sp)
ffffffffc02046ae:	74b2                	ld	s1,296(sp)
ffffffffc02046b0:	7912                	ld	s2,288(sp)
ffffffffc02046b2:	6131                	addi	sp,sp,320
ffffffffc02046b4:	8082                	ret

ffffffffc02046b6 <do_exit>:
{
ffffffffc02046b6:	7179                	addi	sp,sp,-48
ffffffffc02046b8:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc02046ba:	0009a417          	auipc	s0,0x9a
ffffffffc02046be:	7a640413          	addi	s0,s0,1958 # ffffffffc029ee60 <current>
ffffffffc02046c2:	601c                	ld	a5,0(s0)
{
ffffffffc02046c4:	f406                	sd	ra,40(sp)
    if (current == idleproc)
ffffffffc02046c6:	0009a717          	auipc	a4,0x9a
ffffffffc02046ca:	7aa73703          	ld	a4,1962(a4) # ffffffffc029ee70 <idleproc>
ffffffffc02046ce:	ec26                	sd	s1,24(sp)
ffffffffc02046d0:	0ce78f63          	beq	a5,a4,ffffffffc02047ae <do_exit+0xf8>
    if (current == initproc)
ffffffffc02046d4:	0009a497          	auipc	s1,0x9a
ffffffffc02046d8:	79448493          	addi	s1,s1,1940 # ffffffffc029ee68 <initproc>
ffffffffc02046dc:	6098                	ld	a4,0(s1)
ffffffffc02046de:	e84a                	sd	s2,16(sp)
ffffffffc02046e0:	e44e                	sd	s3,8(sp)
ffffffffc02046e2:	e052                	sd	s4,0(sp)
ffffffffc02046e4:	0ee78e63          	beq	a5,a4,ffffffffc02047e0 <do_exit+0x12a>
    struct mm_struct *mm = current->mm;
ffffffffc02046e8:	0287b983          	ld	s3,40(a5)
ffffffffc02046ec:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc02046ee:	02098663          	beqz	s3,ffffffffc020471a <do_exit+0x64>
ffffffffc02046f2:	0009a797          	auipc	a5,0x9a
ffffffffc02046f6:	73e7b783          	ld	a5,1854(a5) # ffffffffc029ee30 <boot_pgdir_pa>
ffffffffc02046fa:	577d                	li	a4,-1
ffffffffc02046fc:	177e                	slli	a4,a4,0x3f
ffffffffc02046fe:	83b1                	srli	a5,a5,0xc
ffffffffc0204700:	8fd9                	or	a5,a5,a4
ffffffffc0204702:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0204706:	0309a783          	lw	a5,48(s3)
ffffffffc020470a:	fff7871b          	addiw	a4,a5,-1
ffffffffc020470e:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204712:	cf4d                	beqz	a4,ffffffffc02047cc <do_exit+0x116>
        current->mm = NULL;
ffffffffc0204714:	601c                	ld	a5,0(s0)
ffffffffc0204716:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc020471a:	601c                	ld	a5,0(s0)
ffffffffc020471c:	470d                	li	a4,3
ffffffffc020471e:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc0204720:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204724:	100027f3          	csrr	a5,sstatus
ffffffffc0204728:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020472a:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020472c:	e7f1                	bnez	a5,ffffffffc02047f8 <do_exit+0x142>
        proc = current->parent;
ffffffffc020472e:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204730:	800007b7          	lui	a5,0x80000
ffffffffc0204734:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff64f9>
        proc = current->parent;
ffffffffc0204736:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204738:	0ec52703          	lw	a4,236(a0)
ffffffffc020473c:	0cf70263          	beq	a4,a5,ffffffffc0204800 <do_exit+0x14a>
        while (current->cptr != NULL)
ffffffffc0204740:	6018                	ld	a4,0(s0)
ffffffffc0204742:	7b7c                	ld	a5,240(a4)
ffffffffc0204744:	c3a1                	beqz	a5,ffffffffc0204784 <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204746:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc020474a:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc020474c:	0985                	addi	s3,s3,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff64f9>
ffffffffc020474e:	a021                	j	ffffffffc0204756 <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc0204750:	6018                	ld	a4,0(s0)
ffffffffc0204752:	7b7c                	ld	a5,240(a4)
ffffffffc0204754:	cb85                	beqz	a5,ffffffffc0204784 <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc0204756:	1007b683          	ld	a3,256(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020475a:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc020475c:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020475e:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc0204760:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204764:	10e7b023          	sd	a4,256(a5)
ffffffffc0204768:	c311                	beqz	a4,ffffffffc020476c <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc020476a:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc020476c:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc020476e:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc0204770:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204772:	fd271fe3          	bne	a4,s2,ffffffffc0204750 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204776:	0ec52783          	lw	a5,236(a0)
ffffffffc020477a:	fd379be3          	bne	a5,s3,ffffffffc0204750 <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc020477e:	405000ef          	jal	ffffffffc0205382 <wakeup_proc>
ffffffffc0204782:	b7f9                	j	ffffffffc0204750 <do_exit+0x9a>
    if (flag)
ffffffffc0204784:	020a1263          	bnez	s4,ffffffffc02047a8 <do_exit+0xf2>
    schedule();
ffffffffc0204788:	495000ef          	jal	ffffffffc020541c <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc020478c:	601c                	ld	a5,0(s0)
ffffffffc020478e:	00003617          	auipc	a2,0x3
ffffffffc0204792:	b1260613          	addi	a2,a2,-1262 # ffffffffc02072a0 <etext+0x1832>
ffffffffc0204796:	25200593          	li	a1,594
ffffffffc020479a:	43d4                	lw	a3,4(a5)
ffffffffc020479c:	00003517          	auipc	a0,0x3
ffffffffc02047a0:	aa450513          	addi	a0,a0,-1372 # ffffffffc0207240 <etext+0x17d2>
ffffffffc02047a4:	ce5fb0ef          	jal	ffffffffc0200488 <__panic>
        intr_enable();
ffffffffc02047a8:	9ccfc0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc02047ac:	bff1                	j	ffffffffc0204788 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc02047ae:	00003617          	auipc	a2,0x3
ffffffffc02047b2:	ad260613          	addi	a2,a2,-1326 # ffffffffc0207280 <etext+0x1812>
ffffffffc02047b6:	21e00593          	li	a1,542
ffffffffc02047ba:	00003517          	auipc	a0,0x3
ffffffffc02047be:	a8650513          	addi	a0,a0,-1402 # ffffffffc0207240 <etext+0x17d2>
ffffffffc02047c2:	e84a                	sd	s2,16(sp)
ffffffffc02047c4:	e44e                	sd	s3,8(sp)
ffffffffc02047c6:	e052                	sd	s4,0(sp)
ffffffffc02047c8:	cc1fb0ef          	jal	ffffffffc0200488 <__panic>
            exit_mmap(mm);
ffffffffc02047cc:	854e                	mv	a0,s3
ffffffffc02047ce:	9d0ff0ef          	jal	ffffffffc020399e <exit_mmap>
            put_pgdir(mm);
ffffffffc02047d2:	854e                	mv	a0,s3
ffffffffc02047d4:	9b3ff0ef          	jal	ffffffffc0204186 <put_pgdir>
            mm_destroy(mm);
ffffffffc02047d8:	854e                	mv	a0,s3
ffffffffc02047da:	80cff0ef          	jal	ffffffffc02037e6 <mm_destroy>
ffffffffc02047de:	bf1d                	j	ffffffffc0204714 <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc02047e0:	00003617          	auipc	a2,0x3
ffffffffc02047e4:	ab060613          	addi	a2,a2,-1360 # ffffffffc0207290 <etext+0x1822>
ffffffffc02047e8:	22200593          	li	a1,546
ffffffffc02047ec:	00003517          	auipc	a0,0x3
ffffffffc02047f0:	a5450513          	addi	a0,a0,-1452 # ffffffffc0207240 <etext+0x17d2>
ffffffffc02047f4:	c95fb0ef          	jal	ffffffffc0200488 <__panic>
        intr_disable();
ffffffffc02047f8:	982fc0ef          	jal	ffffffffc020097a <intr_disable>
        return 1;
ffffffffc02047fc:	4a05                	li	s4,1
ffffffffc02047fe:	bf05                	j	ffffffffc020472e <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204800:	383000ef          	jal	ffffffffc0205382 <wakeup_proc>
ffffffffc0204804:	bf35                	j	ffffffffc0204740 <do_exit+0x8a>

ffffffffc0204806 <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc0204806:	7179                	addi	sp,sp,-48
ffffffffc0204808:	ec26                	sd	s1,24(sp)
ffffffffc020480a:	e84a                	sd	s2,16(sp)
ffffffffc020480c:	e44e                	sd	s3,8(sp)
ffffffffc020480e:	f406                	sd	ra,40(sp)
ffffffffc0204810:	f022                	sd	s0,32(sp)
ffffffffc0204812:	84aa                	mv	s1,a0
ffffffffc0204814:	892e                	mv	s2,a1
ffffffffc0204816:	0009a997          	auipc	s3,0x9a
ffffffffc020481a:	64a98993          	addi	s3,s3,1610 # ffffffffc029ee60 <current>
    if (pid != 0)
ffffffffc020481e:	c105                	beqz	a0,ffffffffc020483e <do_wait.part.0+0x38>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204820:	6789                	lui	a5,0x2
ffffffffc0204822:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204826:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x659a>
ffffffffc0204828:	2501                	sext.w	a0,a0
ffffffffc020482a:	12e7f363          	bgeu	a5,a4,ffffffffc0204950 <do_wait.part.0+0x14a>
    return -E_BAD_PROC;
ffffffffc020482e:	5579                	li	a0,-2
}
ffffffffc0204830:	70a2                	ld	ra,40(sp)
ffffffffc0204832:	7402                	ld	s0,32(sp)
ffffffffc0204834:	64e2                	ld	s1,24(sp)
ffffffffc0204836:	6942                	ld	s2,16(sp)
ffffffffc0204838:	69a2                	ld	s3,8(sp)
ffffffffc020483a:	6145                	addi	sp,sp,48
ffffffffc020483c:	8082                	ret
        proc = current->cptr;
ffffffffc020483e:	0009b683          	ld	a3,0(s3)
ffffffffc0204842:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204844:	d46d                	beqz	s0,ffffffffc020482e <do_wait.part.0+0x28>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204846:	470d                	li	a4,3
ffffffffc0204848:	a021                	j	ffffffffc0204850 <do_wait.part.0+0x4a>
        for (; proc != NULL; proc = proc->optr)
ffffffffc020484a:	10043403          	ld	s0,256(s0)
ffffffffc020484e:	cc71                	beqz	s0,ffffffffc020492a <do_wait.part.0+0x124>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204850:	401c                	lw	a5,0(s0)
ffffffffc0204852:	fee79ce3          	bne	a5,a4,ffffffffc020484a <do_wait.part.0+0x44>
    if (proc == idleproc || proc == initproc)
ffffffffc0204856:	0009a797          	auipc	a5,0x9a
ffffffffc020485a:	61a7b783          	ld	a5,1562(a5) # ffffffffc029ee70 <idleproc>
ffffffffc020485e:	14878c63          	beq	a5,s0,ffffffffc02049b6 <do_wait.part.0+0x1b0>
ffffffffc0204862:	0009a797          	auipc	a5,0x9a
ffffffffc0204866:	6067b783          	ld	a5,1542(a5) # ffffffffc029ee68 <initproc>
ffffffffc020486a:	14f40663          	beq	s0,a5,ffffffffc02049b6 <do_wait.part.0+0x1b0>
    if (code_store != NULL)
ffffffffc020486e:	00090663          	beqz	s2,ffffffffc020487a <do_wait.part.0+0x74>
        *code_store = proc->exit_code;
ffffffffc0204872:	0e842783          	lw	a5,232(s0)
ffffffffc0204876:	00f92023          	sw	a5,0(s2)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020487a:	100027f3          	csrr	a5,sstatus
ffffffffc020487e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204880:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204882:	10079463          	bnez	a5,ffffffffc020498a <do_wait.part.0+0x184>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204886:	6c74                	ld	a3,216(s0)
ffffffffc0204888:	7078                	ld	a4,224(s0)
    if (proc->optr != NULL)
ffffffffc020488a:	10043783          	ld	a5,256(s0)
    prev->next = next;
ffffffffc020488e:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0204890:	e314                	sd	a3,0(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204892:	6474                	ld	a3,200(s0)
ffffffffc0204894:	6878                	ld	a4,208(s0)
    prev->next = next;
ffffffffc0204896:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0204898:	e314                	sd	a3,0(a4)
ffffffffc020489a:	c399                	beqz	a5,ffffffffc02048a0 <do_wait.part.0+0x9a>
        proc->optr->yptr = proc->yptr;
ffffffffc020489c:	7c78                	ld	a4,248(s0)
ffffffffc020489e:	fff8                	sd	a4,248(a5)
    if (proc->yptr != NULL)
ffffffffc02048a0:	7c78                	ld	a4,248(s0)
ffffffffc02048a2:	c36d                	beqz	a4,ffffffffc0204984 <do_wait.part.0+0x17e>
        proc->yptr->optr = proc->optr;
ffffffffc02048a4:	10f73023          	sd	a5,256(a4)
    nr_process--;
ffffffffc02048a8:	0009a717          	auipc	a4,0x9a
ffffffffc02048ac:	5b070713          	addi	a4,a4,1456 # ffffffffc029ee58 <nr_process>
ffffffffc02048b0:	431c                	lw	a5,0(a4)
ffffffffc02048b2:	37fd                	addiw	a5,a5,-1
ffffffffc02048b4:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc02048b6:	e661                	bnez	a2,ffffffffc020497e <do_wait.part.0+0x178>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02048b8:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc02048ba:	c02007b7          	lui	a5,0xc0200
ffffffffc02048be:	0ef6e063          	bltu	a3,a5,ffffffffc020499e <do_wait.part.0+0x198>
ffffffffc02048c2:	0009a797          	auipc	a5,0x9a
ffffffffc02048c6:	57e7b783          	ld	a5,1406(a5) # ffffffffc029ee40 <va_pa_offset>
ffffffffc02048ca:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02048cc:	82b1                	srli	a3,a3,0xc
ffffffffc02048ce:	0009a797          	auipc	a5,0x9a
ffffffffc02048d2:	57a7b783          	ld	a5,1402(a5) # ffffffffc029ee48 <npage>
ffffffffc02048d6:	0ef6fc63          	bgeu	a3,a5,ffffffffc02049ce <do_wait.part.0+0x1c8>
    return &pages[PPN(pa) - nbase];
ffffffffc02048da:	00003797          	auipc	a5,0x3
ffffffffc02048de:	2ee7b783          	ld	a5,750(a5) # ffffffffc0207bc8 <nbase>
ffffffffc02048e2:	8e9d                	sub	a3,a3,a5
ffffffffc02048e4:	069a                	slli	a3,a3,0x6
ffffffffc02048e6:	0009a517          	auipc	a0,0x9a
ffffffffc02048ea:	56a53503          	ld	a0,1386(a0) # ffffffffc029ee50 <pages>
ffffffffc02048ee:	9536                	add	a0,a0,a3
ffffffffc02048f0:	4589                	li	a1,2
ffffffffc02048f2:	e50fd0ef          	jal	ffffffffc0201f42 <free_pages>
    kfree(proc);
ffffffffc02048f6:	8522                	mv	a0,s0
ffffffffc02048f8:	cdefd0ef          	jal	ffffffffc0201dd6 <kfree>
}
ffffffffc02048fc:	70a2                	ld	ra,40(sp)
ffffffffc02048fe:	7402                	ld	s0,32(sp)
ffffffffc0204900:	64e2                	ld	s1,24(sp)
ffffffffc0204902:	6942                	ld	s2,16(sp)
ffffffffc0204904:	69a2                	ld	s3,8(sp)
    return 0;
ffffffffc0204906:	4501                	li	a0,0
}
ffffffffc0204908:	6145                	addi	sp,sp,48
ffffffffc020490a:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc020490c:	0009a997          	auipc	s3,0x9a
ffffffffc0204910:	55498993          	addi	s3,s3,1364 # ffffffffc029ee60 <current>
ffffffffc0204914:	0009b683          	ld	a3,0(s3)
ffffffffc0204918:	f4843783          	ld	a5,-184(s0)
ffffffffc020491c:	f0d799e3          	bne	a5,a3,ffffffffc020482e <do_wait.part.0+0x28>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204920:	f2842703          	lw	a4,-216(s0)
ffffffffc0204924:	478d                	li	a5,3
ffffffffc0204926:	06f70663          	beq	a4,a5,ffffffffc0204992 <do_wait.part.0+0x18c>
        current->wait_state = WT_CHILD;
ffffffffc020492a:	800007b7          	lui	a5,0x80000
ffffffffc020492e:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff64f9>
        current->state = PROC_SLEEPING;
ffffffffc0204930:	4705                	li	a4,1
        current->wait_state = WT_CHILD;
ffffffffc0204932:	0ef6a623          	sw	a5,236(a3)
        current->state = PROC_SLEEPING;
ffffffffc0204936:	c298                	sw	a4,0(a3)
        schedule();
ffffffffc0204938:	2e5000ef          	jal	ffffffffc020541c <schedule>
        if (current->flags & PF_EXITING)
ffffffffc020493c:	0009b783          	ld	a5,0(s3)
ffffffffc0204940:	0b07a783          	lw	a5,176(a5)
ffffffffc0204944:	8b85                	andi	a5,a5,1
ffffffffc0204946:	eba9                	bnez	a5,ffffffffc0204998 <do_wait.part.0+0x192>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204948:	0004851b          	sext.w	a0,s1
    if (pid != 0)
ffffffffc020494c:	ee0489e3          	beqz	s1,ffffffffc020483e <do_wait.part.0+0x38>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204950:	45a9                	li	a1,10
ffffffffc0204952:	437000ef          	jal	ffffffffc0205588 <hash32>
ffffffffc0204956:	02051793          	slli	a5,a0,0x20
ffffffffc020495a:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020495e:	00096797          	auipc	a5,0x96
ffffffffc0204962:	48278793          	addi	a5,a5,1154 # ffffffffc029ade0 <hash_list>
ffffffffc0204966:	953e                	add	a0,a0,a5
ffffffffc0204968:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc020496a:	a029                	j	ffffffffc0204974 <do_wait.part.0+0x16e>
            if (proc->pid == pid)
ffffffffc020496c:	f2c42783          	lw	a5,-212(s0)
ffffffffc0204970:	f8978ee3          	beq	a5,s1,ffffffffc020490c <do_wait.part.0+0x106>
    return listelm->next;
ffffffffc0204974:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc0204976:	fe851be3          	bne	a0,s0,ffffffffc020496c <do_wait.part.0+0x166>
    return -E_BAD_PROC;
ffffffffc020497a:	5579                	li	a0,-2
ffffffffc020497c:	bd55                	j	ffffffffc0204830 <do_wait.part.0+0x2a>
        intr_enable();
ffffffffc020497e:	ff7fb0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0204982:	bf1d                	j	ffffffffc02048b8 <do_wait.part.0+0xb2>
        proc->parent->cptr = proc->optr;
ffffffffc0204984:	7018                	ld	a4,32(s0)
ffffffffc0204986:	fb7c                	sd	a5,240(a4)
ffffffffc0204988:	b705                	j	ffffffffc02048a8 <do_wait.part.0+0xa2>
        intr_disable();
ffffffffc020498a:	ff1fb0ef          	jal	ffffffffc020097a <intr_disable>
        return 1;
ffffffffc020498e:	4605                	li	a2,1
ffffffffc0204990:	bddd                	j	ffffffffc0204886 <do_wait.part.0+0x80>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204992:	f2840413          	addi	s0,s0,-216
ffffffffc0204996:	b5c1                	j	ffffffffc0204856 <do_wait.part.0+0x50>
            do_exit(-E_KILLED);
ffffffffc0204998:	555d                	li	a0,-9
ffffffffc020499a:	d1dff0ef          	jal	ffffffffc02046b6 <do_exit>
    return pa2page(PADDR(kva));
ffffffffc020499e:	00002617          	auipc	a2,0x2
ffffffffc02049a2:	f4a60613          	addi	a2,a2,-182 # ffffffffc02068e8 <etext+0xe7a>
ffffffffc02049a6:	07700593          	li	a1,119
ffffffffc02049aa:	00002517          	auipc	a0,0x2
ffffffffc02049ae:	ebe50513          	addi	a0,a0,-322 # ffffffffc0206868 <etext+0xdfa>
ffffffffc02049b2:	ad7fb0ef          	jal	ffffffffc0200488 <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc02049b6:	00003617          	auipc	a2,0x3
ffffffffc02049ba:	90a60613          	addi	a2,a2,-1782 # ffffffffc02072c0 <etext+0x1852>
ffffffffc02049be:	37e00593          	li	a1,894
ffffffffc02049c2:	00003517          	auipc	a0,0x3
ffffffffc02049c6:	87e50513          	addi	a0,a0,-1922 # ffffffffc0207240 <etext+0x17d2>
ffffffffc02049ca:	abffb0ef          	jal	ffffffffc0200488 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02049ce:	00002617          	auipc	a2,0x2
ffffffffc02049d2:	f4260613          	addi	a2,a2,-190 # ffffffffc0206910 <etext+0xea2>
ffffffffc02049d6:	06900593          	li	a1,105
ffffffffc02049da:	00002517          	auipc	a0,0x2
ffffffffc02049de:	e8e50513          	addi	a0,a0,-370 # ffffffffc0206868 <etext+0xdfa>
ffffffffc02049e2:	aa7fb0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02049e6 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc02049e6:	1141                	addi	sp,sp,-16
ffffffffc02049e8:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc02049ea:	d98fd0ef          	jal	ffffffffc0201f82 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc02049ee:	b3afd0ef          	jal	ffffffffc0201d28 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc02049f2:	4601                	li	a2,0
ffffffffc02049f4:	4581                	li	a1,0
ffffffffc02049f6:	fffff517          	auipc	a0,0xfffff
ffffffffc02049fa:	71250513          	addi	a0,a0,1810 # ffffffffc0204108 <user_main>
ffffffffc02049fe:	c69ff0ef          	jal	ffffffffc0204666 <kernel_thread>
    if (pid <= 0)
ffffffffc0204a02:	00a04563          	bgtz	a0,ffffffffc0204a0c <init_main+0x26>
ffffffffc0204a06:	a071                	j	ffffffffc0204a92 <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc0204a08:	215000ef          	jal	ffffffffc020541c <schedule>
    if (code_store != NULL)
ffffffffc0204a0c:	4581                	li	a1,0
ffffffffc0204a0e:	4501                	li	a0,0
ffffffffc0204a10:	df7ff0ef          	jal	ffffffffc0204806 <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc0204a14:	d975                	beqz	a0,ffffffffc0204a08 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0204a16:	00003517          	auipc	a0,0x3
ffffffffc0204a1a:	8ea50513          	addi	a0,a0,-1814 # ffffffffc0207300 <etext+0x1892>
ffffffffc0204a1e:	f76fb0ef          	jal	ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204a22:	0009a797          	auipc	a5,0x9a
ffffffffc0204a26:	4467b783          	ld	a5,1094(a5) # ffffffffc029ee68 <initproc>
ffffffffc0204a2a:	7bf8                	ld	a4,240(a5)
ffffffffc0204a2c:	e339                	bnez	a4,ffffffffc0204a72 <init_main+0x8c>
ffffffffc0204a2e:	7ff8                	ld	a4,248(a5)
ffffffffc0204a30:	e329                	bnez	a4,ffffffffc0204a72 <init_main+0x8c>
ffffffffc0204a32:	1007b703          	ld	a4,256(a5)
ffffffffc0204a36:	ef15                	bnez	a4,ffffffffc0204a72 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc0204a38:	0009a697          	auipc	a3,0x9a
ffffffffc0204a3c:	4206a683          	lw	a3,1056(a3) # ffffffffc029ee58 <nr_process>
ffffffffc0204a40:	4709                	li	a4,2
ffffffffc0204a42:	0ae69463          	bne	a3,a4,ffffffffc0204aea <init_main+0x104>
ffffffffc0204a46:	0009a697          	auipc	a3,0x9a
ffffffffc0204a4a:	39a68693          	addi	a3,a3,922 # ffffffffc029ede0 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204a4e:	6698                	ld	a4,8(a3)
ffffffffc0204a50:	0c878793          	addi	a5,a5,200
ffffffffc0204a54:	06f71b63          	bne	a4,a5,ffffffffc0204aca <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204a58:	629c                	ld	a5,0(a3)
ffffffffc0204a5a:	04f71863          	bne	a4,a5,ffffffffc0204aaa <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc0204a5e:	00003517          	auipc	a0,0x3
ffffffffc0204a62:	98a50513          	addi	a0,a0,-1654 # ffffffffc02073e8 <etext+0x197a>
ffffffffc0204a66:	f2efb0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc0204a6a:	60a2                	ld	ra,8(sp)
ffffffffc0204a6c:	4501                	li	a0,0
ffffffffc0204a6e:	0141                	addi	sp,sp,16
ffffffffc0204a70:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204a72:	00003697          	auipc	a3,0x3
ffffffffc0204a76:	8b668693          	addi	a3,a3,-1866 # ffffffffc0207328 <etext+0x18ba>
ffffffffc0204a7a:	00002617          	auipc	a2,0x2
ffffffffc0204a7e:	a1660613          	addi	a2,a2,-1514 # ffffffffc0206490 <etext+0xa22>
ffffffffc0204a82:	3ec00593          	li	a1,1004
ffffffffc0204a86:	00002517          	auipc	a0,0x2
ffffffffc0204a8a:	7ba50513          	addi	a0,a0,1978 # ffffffffc0207240 <etext+0x17d2>
ffffffffc0204a8e:	9fbfb0ef          	jal	ffffffffc0200488 <__panic>
        panic("create user_main failed.\n");
ffffffffc0204a92:	00003617          	auipc	a2,0x3
ffffffffc0204a96:	84e60613          	addi	a2,a2,-1970 # ffffffffc02072e0 <etext+0x1872>
ffffffffc0204a9a:	3e300593          	li	a1,995
ffffffffc0204a9e:	00002517          	auipc	a0,0x2
ffffffffc0204aa2:	7a250513          	addi	a0,a0,1954 # ffffffffc0207240 <etext+0x17d2>
ffffffffc0204aa6:	9e3fb0ef          	jal	ffffffffc0200488 <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204aaa:	00003697          	auipc	a3,0x3
ffffffffc0204aae:	90e68693          	addi	a3,a3,-1778 # ffffffffc02073b8 <etext+0x194a>
ffffffffc0204ab2:	00002617          	auipc	a2,0x2
ffffffffc0204ab6:	9de60613          	addi	a2,a2,-1570 # ffffffffc0206490 <etext+0xa22>
ffffffffc0204aba:	3ef00593          	li	a1,1007
ffffffffc0204abe:	00002517          	auipc	a0,0x2
ffffffffc0204ac2:	78250513          	addi	a0,a0,1922 # ffffffffc0207240 <etext+0x17d2>
ffffffffc0204ac6:	9c3fb0ef          	jal	ffffffffc0200488 <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204aca:	00003697          	auipc	a3,0x3
ffffffffc0204ace:	8be68693          	addi	a3,a3,-1858 # ffffffffc0207388 <etext+0x191a>
ffffffffc0204ad2:	00002617          	auipc	a2,0x2
ffffffffc0204ad6:	9be60613          	addi	a2,a2,-1602 # ffffffffc0206490 <etext+0xa22>
ffffffffc0204ada:	3ee00593          	li	a1,1006
ffffffffc0204ade:	00002517          	auipc	a0,0x2
ffffffffc0204ae2:	76250513          	addi	a0,a0,1890 # ffffffffc0207240 <etext+0x17d2>
ffffffffc0204ae6:	9a3fb0ef          	jal	ffffffffc0200488 <__panic>
    assert(nr_process == 2);
ffffffffc0204aea:	00003697          	auipc	a3,0x3
ffffffffc0204aee:	88e68693          	addi	a3,a3,-1906 # ffffffffc0207378 <etext+0x190a>
ffffffffc0204af2:	00002617          	auipc	a2,0x2
ffffffffc0204af6:	99e60613          	addi	a2,a2,-1634 # ffffffffc0206490 <etext+0xa22>
ffffffffc0204afa:	3ed00593          	li	a1,1005
ffffffffc0204afe:	00002517          	auipc	a0,0x2
ffffffffc0204b02:	74250513          	addi	a0,a0,1858 # ffffffffc0207240 <etext+0x17d2>
ffffffffc0204b06:	983fb0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0204b0a <do_execve>:
{
ffffffffc0204b0a:	7171                	addi	sp,sp,-176
ffffffffc0204b0c:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204b0e:	0009ad97          	auipc	s11,0x9a
ffffffffc0204b12:	352d8d93          	addi	s11,s11,850 # ffffffffc029ee60 <current>
ffffffffc0204b16:	000db783          	ld	a5,0(s11)
{
ffffffffc0204b1a:	e54e                	sd	s3,136(sp)
ffffffffc0204b1c:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204b1e:	0287b983          	ld	s3,40(a5)
{
ffffffffc0204b22:	e94a                	sd	s2,144(sp)
ffffffffc0204b24:	fcd6                	sd	s5,120(sp)
ffffffffc0204b26:	892a                	mv	s2,a0
ffffffffc0204b28:	84ae                	mv	s1,a1
ffffffffc0204b2a:	8ab2                	mv	s5,a2
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204b2c:	4681                	li	a3,0
ffffffffc0204b2e:	862e                	mv	a2,a1
ffffffffc0204b30:	85aa                	mv	a1,a0
ffffffffc0204b32:	854e                	mv	a0,s3
{
ffffffffc0204b34:	f506                	sd	ra,168(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204b36:	a0cff0ef          	jal	ffffffffc0203d42 <user_mem_check>
ffffffffc0204b3a:	46050663          	beqz	a0,ffffffffc0204fa6 <do_execve+0x49c>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204b3e:	4641                	li	a2,16
ffffffffc0204b40:	4581                	li	a1,0
ffffffffc0204b42:	1808                	addi	a0,sp,48
ffffffffc0204b44:	701000ef          	jal	ffffffffc0205a44 <memset>
    if (len > PROC_NAME_LEN)
ffffffffc0204b48:	47bd                	li	a5,15
ffffffffc0204b4a:	8626                	mv	a2,s1
ffffffffc0204b4c:	1097e263          	bltu	a5,s1,ffffffffc0204c50 <do_execve+0x146>
    memcpy(local_name, name, len);
ffffffffc0204b50:	85ca                	mv	a1,s2
ffffffffc0204b52:	1808                	addi	a0,sp,48
ffffffffc0204b54:	703000ef          	jal	ffffffffc0205a56 <memcpy>
    if (mm != NULL)
ffffffffc0204b58:	10098363          	beqz	s3,ffffffffc0204c5e <do_execve+0x154>
        cputs("mm != NULL");
ffffffffc0204b5c:	00002517          	auipc	a0,0x2
ffffffffc0204b60:	4ac50513          	addi	a0,a0,1196 # ffffffffc0207008 <etext+0x159a>
ffffffffc0204b64:	e66fb0ef          	jal	ffffffffc02001ca <cputs>
ffffffffc0204b68:	0009a797          	auipc	a5,0x9a
ffffffffc0204b6c:	2c87b783          	ld	a5,712(a5) # ffffffffc029ee30 <boot_pgdir_pa>
ffffffffc0204b70:	577d                	li	a4,-1
ffffffffc0204b72:	177e                	slli	a4,a4,0x3f
ffffffffc0204b74:	83b1                	srli	a5,a5,0xc
ffffffffc0204b76:	8fd9                	or	a5,a5,a4
ffffffffc0204b78:	18079073          	csrw	satp,a5
ffffffffc0204b7c:	0309a783          	lw	a5,48(s3)
ffffffffc0204b80:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204b84:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204b88:	2e070a63          	beqz	a4,ffffffffc0204e7c <do_execve+0x372>
        current->mm = NULL;
ffffffffc0204b8c:	000db783          	ld	a5,0(s11)
ffffffffc0204b90:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204b94:	b13fe0ef          	jal	ffffffffc02036a6 <mm_create>
ffffffffc0204b98:	84aa                	mv	s1,a0
ffffffffc0204b9a:	20050863          	beqz	a0,ffffffffc0204daa <do_execve+0x2a0>
    if ((page = alloc_page()) == NULL)
ffffffffc0204b9e:	4505                	li	a0,1
ffffffffc0204ba0:	b64fd0ef          	jal	ffffffffc0201f04 <alloc_pages>
ffffffffc0204ba4:	40050563          	beqz	a0,ffffffffc0204fae <do_execve+0x4a4>
    return page - pages + nbase;
ffffffffc0204ba8:	e8ea                	sd	s10,80(sp)
ffffffffc0204baa:	0009ad17          	auipc	s10,0x9a
ffffffffc0204bae:	2a6d0d13          	addi	s10,s10,678 # ffffffffc029ee50 <pages>
ffffffffc0204bb2:	000d3783          	ld	a5,0(s10)
ffffffffc0204bb6:	ece6                	sd	s9,88(sp)
    return KADDR(page2pa(page));
ffffffffc0204bb8:	0009ac97          	auipc	s9,0x9a
ffffffffc0204bbc:	290c8c93          	addi	s9,s9,656 # ffffffffc029ee48 <npage>
    return page - pages + nbase;
ffffffffc0204bc0:	40f506b3          	sub	a3,a0,a5
ffffffffc0204bc4:	00003717          	auipc	a4,0x3
ffffffffc0204bc8:	00473703          	ld	a4,4(a4) # ffffffffc0207bc8 <nbase>
ffffffffc0204bcc:	f4de                	sd	s7,104(sp)
ffffffffc0204bce:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204bd0:	5bfd                	li	s7,-1
ffffffffc0204bd2:	000cb783          	ld	a5,0(s9)
    return page - pages + nbase;
ffffffffc0204bd6:	96ba                	add	a3,a3,a4
ffffffffc0204bd8:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204bda:	00cbd713          	srli	a4,s7,0xc
ffffffffc0204bde:	f03a                	sd	a4,32(sp)
ffffffffc0204be0:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204be2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204be4:	3ef77863          	bgeu	a4,a5,ffffffffc0204fd4 <do_execve+0x4ca>
ffffffffc0204be8:	f8da                	sd	s6,112(sp)
ffffffffc0204bea:	0009ab17          	auipc	s6,0x9a
ffffffffc0204bee:	256b0b13          	addi	s6,s6,598 # ffffffffc029ee40 <va_pa_offset>
ffffffffc0204bf2:	000b3783          	ld	a5,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204bf6:	6605                	lui	a2,0x1
ffffffffc0204bf8:	0009a597          	auipc	a1,0x9a
ffffffffc0204bfc:	2405b583          	ld	a1,576(a1) # ffffffffc029ee38 <boot_pgdir_va>
ffffffffc0204c00:	00f68933          	add	s2,a3,a5
ffffffffc0204c04:	854a                	mv	a0,s2
ffffffffc0204c06:	e152                	sd	s4,128(sp)
ffffffffc0204c08:	64f000ef          	jal	ffffffffc0205a56 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204c0c:	000aa703          	lw	a4,0(s5)
ffffffffc0204c10:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204c14:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204c18:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464baa77>
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204c1c:	020aba03          	ld	s4,32(s5)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204c20:	06f70663          	beq	a4,a5,ffffffffc0204c8c <do_execve+0x182>
        ret = -E_INVAL_ELF;
ffffffffc0204c24:	5961                	li	s2,-8
    put_pgdir(mm);
ffffffffc0204c26:	8526                	mv	a0,s1
ffffffffc0204c28:	d5eff0ef          	jal	ffffffffc0204186 <put_pgdir>
ffffffffc0204c2c:	6a0a                	ld	s4,128(sp)
ffffffffc0204c2e:	7b46                	ld	s6,112(sp)
ffffffffc0204c30:	7ba6                	ld	s7,104(sp)
ffffffffc0204c32:	6ce6                	ld	s9,88(sp)
ffffffffc0204c34:	6d46                	ld	s10,80(sp)
    mm_destroy(mm);
ffffffffc0204c36:	8526                	mv	a0,s1
ffffffffc0204c38:	baffe0ef          	jal	ffffffffc02037e6 <mm_destroy>
    do_exit(ret);
ffffffffc0204c3c:	854a                	mv	a0,s2
ffffffffc0204c3e:	f122                	sd	s0,160(sp)
ffffffffc0204c40:	e152                	sd	s4,128(sp)
ffffffffc0204c42:	f8da                	sd	s6,112(sp)
ffffffffc0204c44:	f4de                	sd	s7,104(sp)
ffffffffc0204c46:	f0e2                	sd	s8,96(sp)
ffffffffc0204c48:	ece6                	sd	s9,88(sp)
ffffffffc0204c4a:	e8ea                	sd	s10,80(sp)
ffffffffc0204c4c:	a6bff0ef          	jal	ffffffffc02046b6 <do_exit>
    if (len > PROC_NAME_LEN)
ffffffffc0204c50:	463d                	li	a2,15
    memcpy(local_name, name, len);
ffffffffc0204c52:	85ca                	mv	a1,s2
ffffffffc0204c54:	1808                	addi	a0,sp,48
ffffffffc0204c56:	601000ef          	jal	ffffffffc0205a56 <memcpy>
    if (mm != NULL)
ffffffffc0204c5a:	f00991e3          	bnez	s3,ffffffffc0204b5c <do_execve+0x52>
    if (current->mm != NULL)
ffffffffc0204c5e:	000db783          	ld	a5,0(s11)
ffffffffc0204c62:	779c                	ld	a5,40(a5)
ffffffffc0204c64:	db85                	beqz	a5,ffffffffc0204b94 <do_execve+0x8a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204c66:	00002617          	auipc	a2,0x2
ffffffffc0204c6a:	7a260613          	addi	a2,a2,1954 # ffffffffc0207408 <etext+0x199a>
ffffffffc0204c6e:	25e00593          	li	a1,606
ffffffffc0204c72:	00002517          	auipc	a0,0x2
ffffffffc0204c76:	5ce50513          	addi	a0,a0,1486 # ffffffffc0207240 <etext+0x17d2>
ffffffffc0204c7a:	f122                	sd	s0,160(sp)
ffffffffc0204c7c:	e152                	sd	s4,128(sp)
ffffffffc0204c7e:	f8da                	sd	s6,112(sp)
ffffffffc0204c80:	f4de                	sd	s7,104(sp)
ffffffffc0204c82:	f0e2                	sd	s8,96(sp)
ffffffffc0204c84:	ece6                	sd	s9,88(sp)
ffffffffc0204c86:	e8ea                	sd	s10,80(sp)
ffffffffc0204c88:	801fb0ef          	jal	ffffffffc0200488 <__panic>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204c8c:	038ad703          	lhu	a4,56(s5)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204c90:	9a56                	add	s4,s4,s5
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204c92:	f122                	sd	s0,160(sp)
ffffffffc0204c94:	00371793          	slli	a5,a4,0x3
ffffffffc0204c98:	8f99                	sub	a5,a5,a4
ffffffffc0204c9a:	078e                	slli	a5,a5,0x3
ffffffffc0204c9c:	97d2                	add	a5,a5,s4
ffffffffc0204c9e:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204ca0:	00fa7e63          	bgeu	s4,a5,ffffffffc0204cbc <do_execve+0x1b2>
ffffffffc0204ca4:	f0e2                	sd	s8,96(sp)
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204ca6:	000a2783          	lw	a5,0(s4)
ffffffffc0204caa:	4705                	li	a4,1
ffffffffc0204cac:	10e78163          	beq	a5,a4,ffffffffc0204dae <do_execve+0x2a4>
    for (; ph < ph_end; ph++)
ffffffffc0204cb0:	77a2                	ld	a5,40(sp)
ffffffffc0204cb2:	038a0a13          	addi	s4,s4,56
ffffffffc0204cb6:	fefa68e3          	bltu	s4,a5,ffffffffc0204ca6 <do_execve+0x19c>
ffffffffc0204cba:	7c06                	ld	s8,96(sp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204cbc:	4701                	li	a4,0
ffffffffc0204cbe:	46ad                	li	a3,11
ffffffffc0204cc0:	00100637          	lui	a2,0x100
ffffffffc0204cc4:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204cc8:	8526                	mv	a0,s1
ffffffffc0204cca:	b6ffe0ef          	jal	ffffffffc0203838 <mm_map>
ffffffffc0204cce:	892a                	mv	s2,a0
ffffffffc0204cd0:	1a051163          	bnez	a0,ffffffffc0204e72 <do_execve+0x368>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204cd4:	6c88                	ld	a0,24(s1)
ffffffffc0204cd6:	467d                	li	a2,31
ffffffffc0204cd8:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204cdc:	8d9fe0ef          	jal	ffffffffc02035b4 <pgdir_alloc_page>
ffffffffc0204ce0:	38050a63          	beqz	a0,ffffffffc0205074 <do_execve+0x56a>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204ce4:	6c88                	ld	a0,24(s1)
ffffffffc0204ce6:	467d                	li	a2,31
ffffffffc0204ce8:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204cec:	8c9fe0ef          	jal	ffffffffc02035b4 <pgdir_alloc_page>
ffffffffc0204cf0:	36050163          	beqz	a0,ffffffffc0205052 <do_execve+0x548>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cf4:	6c88                	ld	a0,24(s1)
ffffffffc0204cf6:	467d                	li	a2,31
ffffffffc0204cf8:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204cfc:	8b9fe0ef          	jal	ffffffffc02035b4 <pgdir_alloc_page>
ffffffffc0204d00:	32050863          	beqz	a0,ffffffffc0205030 <do_execve+0x526>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204d04:	6c88                	ld	a0,24(s1)
ffffffffc0204d06:	467d                	li	a2,31
ffffffffc0204d08:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204d0c:	8a9fe0ef          	jal	ffffffffc02035b4 <pgdir_alloc_page>
ffffffffc0204d10:	2e050f63          	beqz	a0,ffffffffc020500e <do_execve+0x504>
    mm->mm_count += 1;
ffffffffc0204d14:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204d16:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204d1a:	6c94                	ld	a3,24(s1)
ffffffffc0204d1c:	2785                	addiw	a5,a5,1
ffffffffc0204d1e:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204d20:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204d22:	c02007b7          	lui	a5,0xc0200
ffffffffc0204d26:	2cf6e763          	bltu	a3,a5,ffffffffc0204ff4 <do_execve+0x4ea>
ffffffffc0204d2a:	000b3783          	ld	a5,0(s6)
ffffffffc0204d2e:	577d                	li	a4,-1
ffffffffc0204d30:	177e                	slli	a4,a4,0x3f
ffffffffc0204d32:	8e9d                	sub	a3,a3,a5
ffffffffc0204d34:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204d38:	f654                	sd	a3,168(a2)
ffffffffc0204d3a:	8fd9                	or	a5,a5,a4
ffffffffc0204d3c:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204d40:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204d42:	4581                	li	a1,0
ffffffffc0204d44:	12000613          	li	a2,288
    uintptr_t sstatus = tf->status;
ffffffffc0204d48:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204d4c:	8522                	mv	a0,s0
ffffffffc0204d4e:	4f7000ef          	jal	ffffffffc0205a44 <memset>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d52:	000db983          	ld	s3,0(s11)
    tf->epc = elf->e_entry;
ffffffffc0204d56:	018ab703          	ld	a4,24(s5)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204d5a:	edf4f493          	andi	s1,s1,-289
    tf->gpr.sp = USTACKTOP;
ffffffffc0204d5e:	4785                	li	a5,1
ffffffffc0204d60:	07fe                	slli	a5,a5,0x1f
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d62:	0b498993          	addi	s3,s3,180
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204d66:	0204e493          	ori	s1,s1,32
    tf->gpr.sp = USTACKTOP;
ffffffffc0204d6a:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0204d6c:	10e43423          	sd	a4,264(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204d70:	10943023          	sd	s1,256(s0)
    tf->gpr.a0 = 0;
ffffffffc0204d74:	04043823          	sd	zero,80(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d78:	4641                	li	a2,16
ffffffffc0204d7a:	4581                	li	a1,0
ffffffffc0204d7c:	854e                	mv	a0,s3
ffffffffc0204d7e:	4c7000ef          	jal	ffffffffc0205a44 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204d82:	463d                	li	a2,15
ffffffffc0204d84:	180c                	addi	a1,sp,48
ffffffffc0204d86:	854e                	mv	a0,s3
ffffffffc0204d88:	4cf000ef          	jal	ffffffffc0205a56 <memcpy>
ffffffffc0204d8c:	740a                	ld	s0,160(sp)
ffffffffc0204d8e:	6a0a                	ld	s4,128(sp)
ffffffffc0204d90:	7b46                	ld	s6,112(sp)
ffffffffc0204d92:	7ba6                	ld	s7,104(sp)
ffffffffc0204d94:	6ce6                	ld	s9,88(sp)
ffffffffc0204d96:	6d46                	ld	s10,80(sp)
}
ffffffffc0204d98:	70aa                	ld	ra,168(sp)
ffffffffc0204d9a:	64ea                	ld	s1,152(sp)
ffffffffc0204d9c:	69aa                	ld	s3,136(sp)
ffffffffc0204d9e:	7ae6                	ld	s5,120(sp)
ffffffffc0204da0:	6da6                	ld	s11,72(sp)
ffffffffc0204da2:	854a                	mv	a0,s2
ffffffffc0204da4:	694a                	ld	s2,144(sp)
ffffffffc0204da6:	614d                	addi	sp,sp,176
ffffffffc0204da8:	8082                	ret
    int ret = -E_NO_MEM;
ffffffffc0204daa:	5971                	li	s2,-4
ffffffffc0204dac:	bd41                	j	ffffffffc0204c3c <do_execve+0x132>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204dae:	028a3603          	ld	a2,40(s4)
ffffffffc0204db2:	020a3783          	ld	a5,32(s4)
ffffffffc0204db6:	20f66063          	bltu	a2,a5,ffffffffc0204fb6 <do_execve+0x4ac>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204dba:	004a2783          	lw	a5,4(s4)
ffffffffc0204dbe:	0017f693          	andi	a3,a5,1
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204dc2:	0027f593          	andi	a1,a5,2
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204dc6:	0026971b          	slliw	a4,a3,0x2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204dca:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204dcc:	068a                	slli	a3,a3,0x2
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204dce:	e1e9                	bnez	a1,ffffffffc0204e90 <do_execve+0x386>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204dd0:	1a079c63          	bnez	a5,ffffffffc0204f88 <do_execve+0x47e>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204dd4:	47c5                	li	a5,17
ffffffffc0204dd6:	ec3e                	sd	a5,24(sp)
        if (vm_flags & VM_EXEC)
ffffffffc0204dd8:	0046f793          	andi	a5,a3,4
ffffffffc0204ddc:	c789                	beqz	a5,ffffffffc0204de6 <do_execve+0x2dc>
            perm |= PTE_X;
ffffffffc0204dde:	67e2                	ld	a5,24(sp)
ffffffffc0204de0:	0087e793          	ori	a5,a5,8
ffffffffc0204de4:	ec3e                	sd	a5,24(sp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204de6:	010a3583          	ld	a1,16(s4)
ffffffffc0204dea:	4701                	li	a4,0
ffffffffc0204dec:	8526                	mv	a0,s1
ffffffffc0204dee:	a4bfe0ef          	jal	ffffffffc0203838 <mm_map>
ffffffffc0204df2:	892a                	mv	s2,a0
ffffffffc0204df4:	1a051f63          	bnez	a0,ffffffffc0204fb2 <do_execve+0x4a8>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204df8:	010a3c03          	ld	s8,16(s4)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204dfc:	020a3903          	ld	s2,32(s4)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204e00:	008a3983          	ld	s3,8(s4)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204e04:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204e06:	9962                	add	s2,s2,s8
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204e08:	00fc7bb3          	and	s7,s8,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204e0c:	99d6                	add	s3,s3,s5
        while (start < end)
ffffffffc0204e0e:	052c6963          	bltu	s8,s2,ffffffffc0204e60 <do_execve+0x356>
ffffffffc0204e12:	aa61                	j	ffffffffc0204faa <do_execve+0x4a0>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204e14:	6785                	lui	a5,0x1
ffffffffc0204e16:	417c0533          	sub	a0,s8,s7
ffffffffc0204e1a:	9bbe                	add	s7,s7,a5
            if (end < la)
ffffffffc0204e1c:	41890633          	sub	a2,s2,s8
ffffffffc0204e20:	01796463          	bltu	s2,s7,ffffffffc0204e28 <do_execve+0x31e>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204e24:	418b8633          	sub	a2,s7,s8
    return page - pages + nbase;
ffffffffc0204e28:	000d3683          	ld	a3,0(s10)
ffffffffc0204e2c:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204e2e:	000cb583          	ld	a1,0(s9)
    return page - pages + nbase;
ffffffffc0204e32:	40d406b3          	sub	a3,s0,a3
ffffffffc0204e36:	8699                	srai	a3,a3,0x6
ffffffffc0204e38:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204e3a:	7782                	ld	a5,32(sp)
ffffffffc0204e3c:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204e40:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204e42:	16b87d63          	bgeu	a6,a1,ffffffffc0204fbc <do_execve+0x4b2>
ffffffffc0204e46:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204e4a:	85ce                	mv	a1,s3
ffffffffc0204e4c:	e432                	sd	a2,8(sp)
ffffffffc0204e4e:	96c2                	add	a3,a3,a6
ffffffffc0204e50:	9536                	add	a0,a0,a3
ffffffffc0204e52:	405000ef          	jal	ffffffffc0205a56 <memcpy>
            start += size, from += size;
ffffffffc0204e56:	6622                	ld	a2,8(sp)
ffffffffc0204e58:	9c32                	add	s8,s8,a2
ffffffffc0204e5a:	99b2                	add	s3,s3,a2
        while (start < end)
ffffffffc0204e5c:	052c7363          	bgeu	s8,s2,ffffffffc0204ea2 <do_execve+0x398>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204e60:	6c88                	ld	a0,24(s1)
ffffffffc0204e62:	6662                	ld	a2,24(sp)
ffffffffc0204e64:	85de                	mv	a1,s7
ffffffffc0204e66:	f4efe0ef          	jal	ffffffffc02035b4 <pgdir_alloc_page>
ffffffffc0204e6a:	842a                	mv	s0,a0
ffffffffc0204e6c:	f545                	bnez	a0,ffffffffc0204e14 <do_execve+0x30a>
ffffffffc0204e6e:	7c06                	ld	s8,96(sp)
        ret = -E_NO_MEM;
ffffffffc0204e70:	5971                	li	s2,-4
    exit_mmap(mm);
ffffffffc0204e72:	8526                	mv	a0,s1
ffffffffc0204e74:	b2bfe0ef          	jal	ffffffffc020399e <exit_mmap>
ffffffffc0204e78:	740a                	ld	s0,160(sp)
ffffffffc0204e7a:	b375                	j	ffffffffc0204c26 <do_execve+0x11c>
            exit_mmap(mm);
ffffffffc0204e7c:	854e                	mv	a0,s3
ffffffffc0204e7e:	b21fe0ef          	jal	ffffffffc020399e <exit_mmap>
            put_pgdir(mm);
ffffffffc0204e82:	854e                	mv	a0,s3
ffffffffc0204e84:	b02ff0ef          	jal	ffffffffc0204186 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204e88:	854e                	mv	a0,s3
ffffffffc0204e8a:	95dfe0ef          	jal	ffffffffc02037e6 <mm_destroy>
ffffffffc0204e8e:	b9fd                	j	ffffffffc0204b8c <do_execve+0x82>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204e90:	10079363          	bnez	a5,ffffffffc0204f96 <do_execve+0x48c>
            vm_flags |= VM_WRITE;
ffffffffc0204e94:	00276713          	ori	a4,a4,2
ffffffffc0204e98:	0007069b          	sext.w	a3,a4
            perm |= (PTE_W | PTE_R);
ffffffffc0204e9c:	47dd                	li	a5,23
ffffffffc0204e9e:	ec3e                	sd	a5,24(sp)
ffffffffc0204ea0:	bf25                	j	ffffffffc0204dd8 <do_execve+0x2ce>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204ea2:	010a3903          	ld	s2,16(s4)
ffffffffc0204ea6:	028a3683          	ld	a3,40(s4)
ffffffffc0204eaa:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204eac:	077c7b63          	bgeu	s8,s7,ffffffffc0204f22 <do_execve+0x418>
            if (start == end)
ffffffffc0204eb0:	e18900e3          	beq	s2,s8,ffffffffc0204cb0 <do_execve+0x1a6>
            if (page == NULL)
ffffffffc0204eb4:	dc4d                	beqz	s0,ffffffffc0204e6e <do_execve+0x364>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204eb6:	6505                	lui	a0,0x1
ffffffffc0204eb8:	9562                	add	a0,a0,s8
ffffffffc0204eba:	41750533          	sub	a0,a0,s7
                size -= la - end;
ffffffffc0204ebe:	418909b3          	sub	s3,s2,s8
            if (end < la)
ffffffffc0204ec2:	0d797f63          	bgeu	s2,s7,ffffffffc0204fa0 <do_execve+0x496>
    return page - pages + nbase;
ffffffffc0204ec6:	000d3683          	ld	a3,0(s10)
ffffffffc0204eca:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204ecc:	000cb603          	ld	a2,0(s9)
    return page - pages + nbase;
ffffffffc0204ed0:	40d406b3          	sub	a3,s0,a3
ffffffffc0204ed4:	8699                	srai	a3,a3,0x6
ffffffffc0204ed6:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204ed8:	00c69593          	slli	a1,a3,0xc
ffffffffc0204edc:	81b1                	srli	a1,a1,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0204ede:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204ee0:	0cc5fe63          	bgeu	a1,a2,ffffffffc0204fbc <do_execve+0x4b2>
ffffffffc0204ee4:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204ee8:	864e                	mv	a2,s3
ffffffffc0204eea:	4581                	li	a1,0
ffffffffc0204eec:	96c2                	add	a3,a3,a6
ffffffffc0204eee:	9536                	add	a0,a0,a3
ffffffffc0204ef0:	355000ef          	jal	ffffffffc0205a44 <memset>
            start += size;
ffffffffc0204ef4:	9c4e                	add	s8,s8,s3
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204ef6:	03797463          	bgeu	s2,s7,ffffffffc0204f1e <do_execve+0x414>
ffffffffc0204efa:	db890be3          	beq	s2,s8,ffffffffc0204cb0 <do_execve+0x1a6>
ffffffffc0204efe:	00002697          	auipc	a3,0x2
ffffffffc0204f02:	53268693          	addi	a3,a3,1330 # ffffffffc0207430 <etext+0x19c2>
ffffffffc0204f06:	00001617          	auipc	a2,0x1
ffffffffc0204f0a:	58a60613          	addi	a2,a2,1418 # ffffffffc0206490 <etext+0xa22>
ffffffffc0204f0e:	2ce00593          	li	a1,718
ffffffffc0204f12:	00002517          	auipc	a0,0x2
ffffffffc0204f16:	32e50513          	addi	a0,a0,814 # ffffffffc0207240 <etext+0x17d2>
ffffffffc0204f1a:	d6efb0ef          	jal	ffffffffc0200488 <__panic>
ffffffffc0204f1e:	ff8b90e3          	bne	s7,s8,ffffffffc0204efe <do_execve+0x3f4>
        while (start < end)
ffffffffc0204f22:	d92c77e3          	bgeu	s8,s2,ffffffffc0204cb0 <do_execve+0x1a6>
ffffffffc0204f26:	56fd                	li	a3,-1
ffffffffc0204f28:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204f2c:	e43e                	sd	a5,8(sp)
ffffffffc0204f2e:	a0a9                	j	ffffffffc0204f78 <do_execve+0x46e>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204f30:	6785                	lui	a5,0x1
ffffffffc0204f32:	417c0533          	sub	a0,s8,s7
ffffffffc0204f36:	9bbe                	add	s7,s7,a5
            if (end < la)
ffffffffc0204f38:	418909b3          	sub	s3,s2,s8
ffffffffc0204f3c:	01796463          	bltu	s2,s7,ffffffffc0204f44 <do_execve+0x43a>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204f40:	418b89b3          	sub	s3,s7,s8
    return page - pages + nbase;
ffffffffc0204f44:	000d3683          	ld	a3,0(s10)
ffffffffc0204f48:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204f4a:	000cb583          	ld	a1,0(s9)
    return page - pages + nbase;
ffffffffc0204f4e:	40d406b3          	sub	a3,s0,a3
ffffffffc0204f52:	8699                	srai	a3,a3,0x6
ffffffffc0204f54:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204f56:	67a2                	ld	a5,8(sp)
ffffffffc0204f58:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204f5c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204f5e:	04b87f63          	bgeu	a6,a1,ffffffffc0204fbc <do_execve+0x4b2>
ffffffffc0204f62:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204f66:	864e                	mv	a2,s3
ffffffffc0204f68:	4581                	li	a1,0
ffffffffc0204f6a:	96c2                	add	a3,a3,a6
ffffffffc0204f6c:	9536                	add	a0,a0,a3
            start += size;
ffffffffc0204f6e:	9c4e                	add	s8,s8,s3
            memset(page2kva(page) + off, 0, size);
ffffffffc0204f70:	2d5000ef          	jal	ffffffffc0205a44 <memset>
        while (start < end)
ffffffffc0204f74:	d32c7ee3          	bgeu	s8,s2,ffffffffc0204cb0 <do_execve+0x1a6>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204f78:	6c88                	ld	a0,24(s1)
ffffffffc0204f7a:	6662                	ld	a2,24(sp)
ffffffffc0204f7c:	85de                	mv	a1,s7
ffffffffc0204f7e:	e36fe0ef          	jal	ffffffffc02035b4 <pgdir_alloc_page>
ffffffffc0204f82:	842a                	mv	s0,a0
ffffffffc0204f84:	f555                	bnez	a0,ffffffffc0204f30 <do_execve+0x426>
ffffffffc0204f86:	b5e5                	j	ffffffffc0204e6e <do_execve+0x364>
            vm_flags |= VM_READ;
ffffffffc0204f88:	00176713          	ori	a4,a4,1
ffffffffc0204f8c:	47cd                	li	a5,19
ffffffffc0204f8e:	0007069b          	sext.w	a3,a4
ffffffffc0204f92:	ec3e                	sd	a5,24(sp)
ffffffffc0204f94:	b591                	j	ffffffffc0204dd8 <do_execve+0x2ce>
ffffffffc0204f96:	00376713          	ori	a4,a4,3
ffffffffc0204f9a:	0007069b          	sext.w	a3,a4
        if (vm_flags & VM_WRITE)
ffffffffc0204f9e:	bdfd                	j	ffffffffc0204e9c <do_execve+0x392>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204fa0:	418b89b3          	sub	s3,s7,s8
ffffffffc0204fa4:	b70d                	j	ffffffffc0204ec6 <do_execve+0x3bc>
        return -E_INVAL;
ffffffffc0204fa6:	5975                	li	s2,-3
ffffffffc0204fa8:	bbc5                	j	ffffffffc0204d98 <do_execve+0x28e>
        while (start < end)
ffffffffc0204faa:	8962                	mv	s2,s8
ffffffffc0204fac:	bded                	j	ffffffffc0204ea6 <do_execve+0x39c>
    int ret = -E_NO_MEM;
ffffffffc0204fae:	5971                	li	s2,-4
ffffffffc0204fb0:	b159                	j	ffffffffc0204c36 <do_execve+0x12c>
ffffffffc0204fb2:	7c06                	ld	s8,96(sp)
ffffffffc0204fb4:	bd7d                	j	ffffffffc0204e72 <do_execve+0x368>
            ret = -E_INVAL_ELF;
ffffffffc0204fb6:	7c06                	ld	s8,96(sp)
ffffffffc0204fb8:	5961                	li	s2,-8
ffffffffc0204fba:	bd65                	j	ffffffffc0204e72 <do_execve+0x368>
ffffffffc0204fbc:	00002617          	auipc	a2,0x2
ffffffffc0204fc0:	88460613          	addi	a2,a2,-1916 # ffffffffc0206840 <etext+0xdd2>
ffffffffc0204fc4:	07100593          	li	a1,113
ffffffffc0204fc8:	00002517          	auipc	a0,0x2
ffffffffc0204fcc:	8a050513          	addi	a0,a0,-1888 # ffffffffc0206868 <etext+0xdfa>
ffffffffc0204fd0:	cb8fb0ef          	jal	ffffffffc0200488 <__panic>
ffffffffc0204fd4:	00002617          	auipc	a2,0x2
ffffffffc0204fd8:	86c60613          	addi	a2,a2,-1940 # ffffffffc0206840 <etext+0xdd2>
ffffffffc0204fdc:	07100593          	li	a1,113
ffffffffc0204fe0:	00002517          	auipc	a0,0x2
ffffffffc0204fe4:	88850513          	addi	a0,a0,-1912 # ffffffffc0206868 <etext+0xdfa>
ffffffffc0204fe8:	f122                	sd	s0,160(sp)
ffffffffc0204fea:	e152                	sd	s4,128(sp)
ffffffffc0204fec:	f8da                	sd	s6,112(sp)
ffffffffc0204fee:	f0e2                	sd	s8,96(sp)
ffffffffc0204ff0:	c98fb0ef          	jal	ffffffffc0200488 <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204ff4:	00002617          	auipc	a2,0x2
ffffffffc0204ff8:	8f460613          	addi	a2,a2,-1804 # ffffffffc02068e8 <etext+0xe7a>
ffffffffc0204ffc:	2ed00593          	li	a1,749
ffffffffc0205000:	00002517          	auipc	a0,0x2
ffffffffc0205004:	24050513          	addi	a0,a0,576 # ffffffffc0207240 <etext+0x17d2>
ffffffffc0205008:	f0e2                	sd	s8,96(sp)
ffffffffc020500a:	c7efb0ef          	jal	ffffffffc0200488 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc020500e:	00002697          	auipc	a3,0x2
ffffffffc0205012:	53a68693          	addi	a3,a3,1338 # ffffffffc0207548 <etext+0x1ada>
ffffffffc0205016:	00001617          	auipc	a2,0x1
ffffffffc020501a:	47a60613          	addi	a2,a2,1146 # ffffffffc0206490 <etext+0xa22>
ffffffffc020501e:	2e800593          	li	a1,744
ffffffffc0205022:	00002517          	auipc	a0,0x2
ffffffffc0205026:	21e50513          	addi	a0,a0,542 # ffffffffc0207240 <etext+0x17d2>
ffffffffc020502a:	f0e2                	sd	s8,96(sp)
ffffffffc020502c:	c5cfb0ef          	jal	ffffffffc0200488 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0205030:	00002697          	auipc	a3,0x2
ffffffffc0205034:	4d068693          	addi	a3,a3,1232 # ffffffffc0207500 <etext+0x1a92>
ffffffffc0205038:	00001617          	auipc	a2,0x1
ffffffffc020503c:	45860613          	addi	a2,a2,1112 # ffffffffc0206490 <etext+0xa22>
ffffffffc0205040:	2e700593          	li	a1,743
ffffffffc0205044:	00002517          	auipc	a0,0x2
ffffffffc0205048:	1fc50513          	addi	a0,a0,508 # ffffffffc0207240 <etext+0x17d2>
ffffffffc020504c:	f0e2                	sd	s8,96(sp)
ffffffffc020504e:	c3afb0ef          	jal	ffffffffc0200488 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0205052:	00002697          	auipc	a3,0x2
ffffffffc0205056:	46668693          	addi	a3,a3,1126 # ffffffffc02074b8 <etext+0x1a4a>
ffffffffc020505a:	00001617          	auipc	a2,0x1
ffffffffc020505e:	43660613          	addi	a2,a2,1078 # ffffffffc0206490 <etext+0xa22>
ffffffffc0205062:	2e600593          	li	a1,742
ffffffffc0205066:	00002517          	auipc	a0,0x2
ffffffffc020506a:	1da50513          	addi	a0,a0,474 # ffffffffc0207240 <etext+0x17d2>
ffffffffc020506e:	f0e2                	sd	s8,96(sp)
ffffffffc0205070:	c18fb0ef          	jal	ffffffffc0200488 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0205074:	00002697          	auipc	a3,0x2
ffffffffc0205078:	3fc68693          	addi	a3,a3,1020 # ffffffffc0207470 <etext+0x1a02>
ffffffffc020507c:	00001617          	auipc	a2,0x1
ffffffffc0205080:	41460613          	addi	a2,a2,1044 # ffffffffc0206490 <etext+0xa22>
ffffffffc0205084:	2e500593          	li	a1,741
ffffffffc0205088:	00002517          	auipc	a0,0x2
ffffffffc020508c:	1b850513          	addi	a0,a0,440 # ffffffffc0207240 <etext+0x17d2>
ffffffffc0205090:	f0e2                	sd	s8,96(sp)
ffffffffc0205092:	bf6fb0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0205096 <do_yield>:
    current->need_resched = 1;
ffffffffc0205096:	0009a797          	auipc	a5,0x9a
ffffffffc020509a:	dca7b783          	ld	a5,-566(a5) # ffffffffc029ee60 <current>
ffffffffc020509e:	4705                	li	a4,1
ffffffffc02050a0:	ef98                	sd	a4,24(a5)
}
ffffffffc02050a2:	4501                	li	a0,0
ffffffffc02050a4:	8082                	ret

ffffffffc02050a6 <do_wait>:
{
ffffffffc02050a6:	1101                	addi	sp,sp,-32
ffffffffc02050a8:	e822                	sd	s0,16(sp)
ffffffffc02050aa:	e426                	sd	s1,8(sp)
    struct mm_struct *mm = current->mm;
ffffffffc02050ac:	0009a797          	auipc	a5,0x9a
ffffffffc02050b0:	db47b783          	ld	a5,-588(a5) # ffffffffc029ee60 <current>
{
ffffffffc02050b4:	ec06                	sd	ra,24(sp)
    struct mm_struct *mm = current->mm;
ffffffffc02050b6:	779c                	ld	a5,40(a5)
{
ffffffffc02050b8:	842e                	mv	s0,a1
ffffffffc02050ba:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc02050bc:	c599                	beqz	a1,ffffffffc02050ca <do_wait+0x24>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc02050be:	4685                	li	a3,1
ffffffffc02050c0:	4611                	li	a2,4
ffffffffc02050c2:	853e                	mv	a0,a5
ffffffffc02050c4:	c7ffe0ef          	jal	ffffffffc0203d42 <user_mem_check>
ffffffffc02050c8:	c909                	beqz	a0,ffffffffc02050da <do_wait+0x34>
ffffffffc02050ca:	85a2                	mv	a1,s0
}
ffffffffc02050cc:	6442                	ld	s0,16(sp)
ffffffffc02050ce:	60e2                	ld	ra,24(sp)
ffffffffc02050d0:	8526                	mv	a0,s1
ffffffffc02050d2:	64a2                	ld	s1,8(sp)
ffffffffc02050d4:	6105                	addi	sp,sp,32
ffffffffc02050d6:	f30ff06f          	j	ffffffffc0204806 <do_wait.part.0>
ffffffffc02050da:	60e2                	ld	ra,24(sp)
ffffffffc02050dc:	6442                	ld	s0,16(sp)
ffffffffc02050de:	64a2                	ld	s1,8(sp)
ffffffffc02050e0:	5575                	li	a0,-3
ffffffffc02050e2:	6105                	addi	sp,sp,32
ffffffffc02050e4:	8082                	ret

ffffffffc02050e6 <do_kill>:
    if (0 < pid && pid < MAX_PID)
ffffffffc02050e6:	6789                	lui	a5,0x2
ffffffffc02050e8:	fff5071b          	addiw	a4,a0,-1
ffffffffc02050ec:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x659a>
ffffffffc02050ee:	06e7e963          	bltu	a5,a4,ffffffffc0205160 <do_kill+0x7a>
{
ffffffffc02050f2:	1141                	addi	sp,sp,-16
ffffffffc02050f4:	e022                	sd	s0,0(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02050f6:	45a9                	li	a1,10
ffffffffc02050f8:	842a                	mv	s0,a0
ffffffffc02050fa:	2501                	sext.w	a0,a0
{
ffffffffc02050fc:	e406                	sd	ra,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02050fe:	48a000ef          	jal	ffffffffc0205588 <hash32>
ffffffffc0205102:	02051793          	slli	a5,a0,0x20
ffffffffc0205106:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020510a:	00096797          	auipc	a5,0x96
ffffffffc020510e:	cd678793          	addi	a5,a5,-810 # ffffffffc029ade0 <hash_list>
ffffffffc0205112:	953e                	add	a0,a0,a5
ffffffffc0205114:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0205116:	a029                	j	ffffffffc0205120 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0205118:	f2c7a703          	lw	a4,-212(a5)
ffffffffc020511c:	00870a63          	beq	a4,s0,ffffffffc0205130 <do_kill+0x4a>
ffffffffc0205120:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0205122:	fef51be3          	bne	a0,a5,ffffffffc0205118 <do_kill+0x32>
    return -E_INVAL;
ffffffffc0205126:	5575                	li	a0,-3
}
ffffffffc0205128:	60a2                	ld	ra,8(sp)
ffffffffc020512a:	6402                	ld	s0,0(sp)
ffffffffc020512c:	0141                	addi	sp,sp,16
ffffffffc020512e:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0205130:	fd87a703          	lw	a4,-40(a5)
        return -E_KILLED;
ffffffffc0205134:	555d                	li	a0,-9
        if (!(proc->flags & PF_EXITING))
ffffffffc0205136:	00177693          	andi	a3,a4,1
ffffffffc020513a:	f6fd                	bnez	a3,ffffffffc0205128 <do_kill+0x42>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc020513c:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc020513e:	00176713          	ori	a4,a4,1
ffffffffc0205142:	fce7ac23          	sw	a4,-40(a5)
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0205146:	0006c763          	bltz	a3,ffffffffc0205154 <do_kill+0x6e>
            return 0;
ffffffffc020514a:	4501                	li	a0,0
}
ffffffffc020514c:	60a2                	ld	ra,8(sp)
ffffffffc020514e:	6402                	ld	s0,0(sp)
ffffffffc0205150:	0141                	addi	sp,sp,16
ffffffffc0205152:	8082                	ret
                wakeup_proc(proc);
ffffffffc0205154:	f2878513          	addi	a0,a5,-216
ffffffffc0205158:	22a000ef          	jal	ffffffffc0205382 <wakeup_proc>
            return 0;
ffffffffc020515c:	4501                	li	a0,0
ffffffffc020515e:	b7fd                	j	ffffffffc020514c <do_kill+0x66>
    return -E_INVAL;
ffffffffc0205160:	5575                	li	a0,-3
}
ffffffffc0205162:	8082                	ret

ffffffffc0205164 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0205164:	1101                	addi	sp,sp,-32
ffffffffc0205166:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0205168:	0009a797          	auipc	a5,0x9a
ffffffffc020516c:	c7878793          	addi	a5,a5,-904 # ffffffffc029ede0 <proc_list>
ffffffffc0205170:	ec06                	sd	ra,24(sp)
ffffffffc0205172:	e822                	sd	s0,16(sp)
ffffffffc0205174:	e04a                	sd	s2,0(sp)
ffffffffc0205176:	00096497          	auipc	s1,0x96
ffffffffc020517a:	c6a48493          	addi	s1,s1,-918 # ffffffffc029ade0 <hash_list>
ffffffffc020517e:	e79c                	sd	a5,8(a5)
ffffffffc0205180:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0205182:	0009a717          	auipc	a4,0x9a
ffffffffc0205186:	c5e70713          	addi	a4,a4,-930 # ffffffffc029ede0 <proc_list>
ffffffffc020518a:	87a6                	mv	a5,s1
ffffffffc020518c:	e79c                	sd	a5,8(a5)
ffffffffc020518e:	e39c                	sd	a5,0(a5)
ffffffffc0205190:	07c1                	addi	a5,a5,16
ffffffffc0205192:	fee79de3          	bne	a5,a4,ffffffffc020518c <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0205196:	ef3fe0ef          	jal	ffffffffc0204088 <alloc_proc>
ffffffffc020519a:	0009a917          	auipc	s2,0x9a
ffffffffc020519e:	cd690913          	addi	s2,s2,-810 # ffffffffc029ee70 <idleproc>
ffffffffc02051a2:	00a93023          	sd	a0,0(s2)
ffffffffc02051a6:	10050063          	beqz	a0,ffffffffc02052a6 <proc_init+0x142>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc02051aa:	4789                	li	a5,2
ffffffffc02051ac:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02051ae:	00003797          	auipc	a5,0x3
ffffffffc02051b2:	e5278793          	addi	a5,a5,-430 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02051b6:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02051ba:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc02051bc:	4785                	li	a5,1
ffffffffc02051be:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02051c0:	4641                	li	a2,16
ffffffffc02051c2:	4581                	li	a1,0
ffffffffc02051c4:	8522                	mv	a0,s0
ffffffffc02051c6:	07f000ef          	jal	ffffffffc0205a44 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02051ca:	463d                	li	a2,15
ffffffffc02051cc:	00002597          	auipc	a1,0x2
ffffffffc02051d0:	3dc58593          	addi	a1,a1,988 # ffffffffc02075a8 <etext+0x1b3a>
ffffffffc02051d4:	8522                	mv	a0,s0
ffffffffc02051d6:	081000ef          	jal	ffffffffc0205a56 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc02051da:	0009a717          	auipc	a4,0x9a
ffffffffc02051de:	c7e70713          	addi	a4,a4,-898 # ffffffffc029ee58 <nr_process>
ffffffffc02051e2:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc02051e4:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02051e8:	4601                	li	a2,0
    nr_process++;
ffffffffc02051ea:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02051ec:	4581                	li	a1,0
ffffffffc02051ee:	fffff517          	auipc	a0,0xfffff
ffffffffc02051f2:	7f850513          	addi	a0,a0,2040 # ffffffffc02049e6 <init_main>
    nr_process++;
ffffffffc02051f6:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc02051f8:	0009a797          	auipc	a5,0x9a
ffffffffc02051fc:	c6d7b423          	sd	a3,-920(a5) # ffffffffc029ee60 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205200:	c66ff0ef          	jal	ffffffffc0204666 <kernel_thread>
ffffffffc0205204:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0205206:	08a05463          	blez	a0,ffffffffc020528e <proc_init+0x12a>
    if (0 < pid && pid < MAX_PID)
ffffffffc020520a:	6789                	lui	a5,0x2
ffffffffc020520c:	fff5071b          	addiw	a4,a0,-1
ffffffffc0205210:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x659a>
ffffffffc0205212:	2501                	sext.w	a0,a0
ffffffffc0205214:	02e7e463          	bltu	a5,a4,ffffffffc020523c <proc_init+0xd8>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0205218:	45a9                	li	a1,10
ffffffffc020521a:	36e000ef          	jal	ffffffffc0205588 <hash32>
ffffffffc020521e:	02051713          	slli	a4,a0,0x20
ffffffffc0205222:	01c75793          	srli	a5,a4,0x1c
ffffffffc0205226:	00f486b3          	add	a3,s1,a5
ffffffffc020522a:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc020522c:	a029                	j	ffffffffc0205236 <proc_init+0xd2>
            if (proc->pid == pid)
ffffffffc020522e:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0205232:	04870b63          	beq	a4,s0,ffffffffc0205288 <proc_init+0x124>
    return listelm->next;
ffffffffc0205236:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0205238:	fef69be3          	bne	a3,a5,ffffffffc020522e <proc_init+0xca>
    return NULL;
ffffffffc020523c:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020523e:	0b478493          	addi	s1,a5,180
ffffffffc0205242:	4641                	li	a2,16
ffffffffc0205244:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0205246:	0009a417          	auipc	s0,0x9a
ffffffffc020524a:	c2240413          	addi	s0,s0,-990 # ffffffffc029ee68 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020524e:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0205250:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205252:	7f2000ef          	jal	ffffffffc0205a44 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205256:	463d                	li	a2,15
ffffffffc0205258:	00002597          	auipc	a1,0x2
ffffffffc020525c:	37858593          	addi	a1,a1,888 # ffffffffc02075d0 <etext+0x1b62>
ffffffffc0205260:	8526                	mv	a0,s1
ffffffffc0205262:	7f4000ef          	jal	ffffffffc0205a56 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205266:	00093783          	ld	a5,0(s2)
ffffffffc020526a:	cbb5                	beqz	a5,ffffffffc02052de <proc_init+0x17a>
ffffffffc020526c:	43dc                	lw	a5,4(a5)
ffffffffc020526e:	eba5                	bnez	a5,ffffffffc02052de <proc_init+0x17a>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205270:	601c                	ld	a5,0(s0)
ffffffffc0205272:	c7b1                	beqz	a5,ffffffffc02052be <proc_init+0x15a>
ffffffffc0205274:	43d8                	lw	a4,4(a5)
ffffffffc0205276:	4785                	li	a5,1
ffffffffc0205278:	04f71363          	bne	a4,a5,ffffffffc02052be <proc_init+0x15a>
}
ffffffffc020527c:	60e2                	ld	ra,24(sp)
ffffffffc020527e:	6442                	ld	s0,16(sp)
ffffffffc0205280:	64a2                	ld	s1,8(sp)
ffffffffc0205282:	6902                	ld	s2,0(sp)
ffffffffc0205284:	6105                	addi	sp,sp,32
ffffffffc0205286:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0205288:	f2878793          	addi	a5,a5,-216
ffffffffc020528c:	bf4d                	j	ffffffffc020523e <proc_init+0xda>
        panic("create init_main failed.\n");
ffffffffc020528e:	00002617          	auipc	a2,0x2
ffffffffc0205292:	32260613          	addi	a2,a2,802 # ffffffffc02075b0 <etext+0x1b42>
ffffffffc0205296:	41200593          	li	a1,1042
ffffffffc020529a:	00002517          	auipc	a0,0x2
ffffffffc020529e:	fa650513          	addi	a0,a0,-90 # ffffffffc0207240 <etext+0x17d2>
ffffffffc02052a2:	9e6fb0ef          	jal	ffffffffc0200488 <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc02052a6:	00002617          	auipc	a2,0x2
ffffffffc02052aa:	2ea60613          	addi	a2,a2,746 # ffffffffc0207590 <etext+0x1b22>
ffffffffc02052ae:	40300593          	li	a1,1027
ffffffffc02052b2:	00002517          	auipc	a0,0x2
ffffffffc02052b6:	f8e50513          	addi	a0,a0,-114 # ffffffffc0207240 <etext+0x17d2>
ffffffffc02052ba:	9cefb0ef          	jal	ffffffffc0200488 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02052be:	00002697          	auipc	a3,0x2
ffffffffc02052c2:	34268693          	addi	a3,a3,834 # ffffffffc0207600 <etext+0x1b92>
ffffffffc02052c6:	00001617          	auipc	a2,0x1
ffffffffc02052ca:	1ca60613          	addi	a2,a2,458 # ffffffffc0206490 <etext+0xa22>
ffffffffc02052ce:	41900593          	li	a1,1049
ffffffffc02052d2:	00002517          	auipc	a0,0x2
ffffffffc02052d6:	f6e50513          	addi	a0,a0,-146 # ffffffffc0207240 <etext+0x17d2>
ffffffffc02052da:	9aefb0ef          	jal	ffffffffc0200488 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02052de:	00002697          	auipc	a3,0x2
ffffffffc02052e2:	2fa68693          	addi	a3,a3,762 # ffffffffc02075d8 <etext+0x1b6a>
ffffffffc02052e6:	00001617          	auipc	a2,0x1
ffffffffc02052ea:	1aa60613          	addi	a2,a2,426 # ffffffffc0206490 <etext+0xa22>
ffffffffc02052ee:	41800593          	li	a1,1048
ffffffffc02052f2:	00002517          	auipc	a0,0x2
ffffffffc02052f6:	f4e50513          	addi	a0,a0,-178 # ffffffffc0207240 <etext+0x17d2>
ffffffffc02052fa:	98efb0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02052fe <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc02052fe:	1141                	addi	sp,sp,-16
ffffffffc0205300:	e022                	sd	s0,0(sp)
ffffffffc0205302:	e406                	sd	ra,8(sp)
ffffffffc0205304:	0009a417          	auipc	s0,0x9a
ffffffffc0205308:	b5c40413          	addi	s0,s0,-1188 # ffffffffc029ee60 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc020530c:	6018                	ld	a4,0(s0)
ffffffffc020530e:	6f1c                	ld	a5,24(a4)
ffffffffc0205310:	dffd                	beqz	a5,ffffffffc020530e <cpu_idle+0x10>
        {
            schedule();
ffffffffc0205312:	10a000ef          	jal	ffffffffc020541c <schedule>
ffffffffc0205316:	bfdd                	j	ffffffffc020530c <cpu_idle+0xe>

ffffffffc0205318 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0205318:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc020531c:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0205320:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0205322:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0205324:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0205328:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc020532c:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0205330:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0205334:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0205338:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc020533c:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0205340:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0205344:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0205348:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc020534c:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0205350:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0205354:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0205356:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0205358:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc020535c:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0205360:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0205364:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0205368:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc020536c:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0205370:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0205374:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0205378:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc020537c:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0205380:	8082                	ret

ffffffffc0205382 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205382:	4118                	lw	a4,0(a0)
{
ffffffffc0205384:	1141                	addi	sp,sp,-16
ffffffffc0205386:	e406                	sd	ra,8(sp)
ffffffffc0205388:	e022                	sd	s0,0(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020538a:	478d                	li	a5,3
ffffffffc020538c:	06f70963          	beq	a4,a5,ffffffffc02053fe <wakeup_proc+0x7c>
ffffffffc0205390:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205392:	100027f3          	csrr	a5,sstatus
ffffffffc0205396:	8b89                	andi	a5,a5,2
ffffffffc0205398:	eb99                	bnez	a5,ffffffffc02053ae <wakeup_proc+0x2c>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc020539a:	4789                	li	a5,2
ffffffffc020539c:	02f70763          	beq	a4,a5,ffffffffc02053ca <wakeup_proc+0x48>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02053a0:	60a2                	ld	ra,8(sp)
ffffffffc02053a2:	6402                	ld	s0,0(sp)
            proc->state = PROC_RUNNABLE;
ffffffffc02053a4:	c11c                	sw	a5,0(a0)
            proc->wait_state = 0;
ffffffffc02053a6:	0e052623          	sw	zero,236(a0)
}
ffffffffc02053aa:	0141                	addi	sp,sp,16
ffffffffc02053ac:	8082                	ret
        intr_disable();
ffffffffc02053ae:	dccfb0ef          	jal	ffffffffc020097a <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc02053b2:	4018                	lw	a4,0(s0)
ffffffffc02053b4:	4789                	li	a5,2
ffffffffc02053b6:	02f70863          	beq	a4,a5,ffffffffc02053e6 <wakeup_proc+0x64>
            proc->state = PROC_RUNNABLE;
ffffffffc02053ba:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc02053bc:	0e042623          	sw	zero,236(s0)
}
ffffffffc02053c0:	6402                	ld	s0,0(sp)
ffffffffc02053c2:	60a2                	ld	ra,8(sp)
ffffffffc02053c4:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc02053c6:	daefb06f          	j	ffffffffc0200974 <intr_enable>
ffffffffc02053ca:	6402                	ld	s0,0(sp)
ffffffffc02053cc:	60a2                	ld	ra,8(sp)
            warn("wakeup runnable process.\n");
ffffffffc02053ce:	00002617          	auipc	a2,0x2
ffffffffc02053d2:	29260613          	addi	a2,a2,658 # ffffffffc0207660 <etext+0x1bf2>
ffffffffc02053d6:	45d1                	li	a1,20
ffffffffc02053d8:	00002517          	auipc	a0,0x2
ffffffffc02053dc:	27050513          	addi	a0,a0,624 # ffffffffc0207648 <etext+0x1bda>
}
ffffffffc02053e0:	0141                	addi	sp,sp,16
            warn("wakeup runnable process.\n");
ffffffffc02053e2:	910fb06f          	j	ffffffffc02004f2 <__warn>
ffffffffc02053e6:	00002617          	auipc	a2,0x2
ffffffffc02053ea:	27a60613          	addi	a2,a2,634 # ffffffffc0207660 <etext+0x1bf2>
ffffffffc02053ee:	45d1                	li	a1,20
ffffffffc02053f0:	00002517          	auipc	a0,0x2
ffffffffc02053f4:	25850513          	addi	a0,a0,600 # ffffffffc0207648 <etext+0x1bda>
ffffffffc02053f8:	8fafb0ef          	jal	ffffffffc02004f2 <__warn>
    if (flag)
ffffffffc02053fc:	b7d1                	j	ffffffffc02053c0 <wakeup_proc+0x3e>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02053fe:	00002697          	auipc	a3,0x2
ffffffffc0205402:	22a68693          	addi	a3,a3,554 # ffffffffc0207628 <etext+0x1bba>
ffffffffc0205406:	00001617          	auipc	a2,0x1
ffffffffc020540a:	08a60613          	addi	a2,a2,138 # ffffffffc0206490 <etext+0xa22>
ffffffffc020540e:	45a5                	li	a1,9
ffffffffc0205410:	00002517          	auipc	a0,0x2
ffffffffc0205414:	23850513          	addi	a0,a0,568 # ffffffffc0207648 <etext+0x1bda>
ffffffffc0205418:	870fb0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc020541c <schedule>:

void schedule(void)
{
ffffffffc020541c:	1141                	addi	sp,sp,-16
ffffffffc020541e:	e406                	sd	ra,8(sp)
ffffffffc0205420:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205422:	100027f3          	csrr	a5,sstatus
ffffffffc0205426:	8b89                	andi	a5,a5,2
ffffffffc0205428:	4401                	li	s0,0
ffffffffc020542a:	efbd                	bnez	a5,ffffffffc02054a8 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc020542c:	0009a897          	auipc	a7,0x9a
ffffffffc0205430:	a348b883          	ld	a7,-1484(a7) # ffffffffc029ee60 <current>
ffffffffc0205434:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205438:	0009a517          	auipc	a0,0x9a
ffffffffc020543c:	a3853503          	ld	a0,-1480(a0) # ffffffffc029ee70 <idleproc>
ffffffffc0205440:	04a88e63          	beq	a7,a0,ffffffffc020549c <schedule+0x80>
ffffffffc0205444:	0c888693          	addi	a3,a7,200
ffffffffc0205448:	0009a617          	auipc	a2,0x9a
ffffffffc020544c:	99860613          	addi	a2,a2,-1640 # ffffffffc029ede0 <proc_list>
        le = last;
ffffffffc0205450:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0205452:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc0205454:	4809                	li	a6,2
ffffffffc0205456:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc0205458:	00c78863          	beq	a5,a2,ffffffffc0205468 <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc020545c:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0205460:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc0205464:	03070163          	beq	a4,a6,ffffffffc0205486 <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc0205468:	fef697e3          	bne	a3,a5,ffffffffc0205456 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc020546c:	ed89                	bnez	a1,ffffffffc0205486 <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc020546e:	451c                	lw	a5,8(a0)
ffffffffc0205470:	2785                	addiw	a5,a5,1
ffffffffc0205472:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc0205474:	00a88463          	beq	a7,a0,ffffffffc020547c <schedule+0x60>
        {
            proc_run(next);
ffffffffc0205478:	d85fe0ef          	jal	ffffffffc02041fc <proc_run>
    if (flag)
ffffffffc020547c:	e819                	bnez	s0,ffffffffc0205492 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc020547e:	60a2                	ld	ra,8(sp)
ffffffffc0205480:	6402                	ld	s0,0(sp)
ffffffffc0205482:	0141                	addi	sp,sp,16
ffffffffc0205484:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205486:	4198                	lw	a4,0(a1)
ffffffffc0205488:	4789                	li	a5,2
ffffffffc020548a:	fef712e3          	bne	a4,a5,ffffffffc020546e <schedule+0x52>
ffffffffc020548e:	852e                	mv	a0,a1
ffffffffc0205490:	bff9                	j	ffffffffc020546e <schedule+0x52>
}
ffffffffc0205492:	6402                	ld	s0,0(sp)
ffffffffc0205494:	60a2                	ld	ra,8(sp)
ffffffffc0205496:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0205498:	cdcfb06f          	j	ffffffffc0200974 <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020549c:	0009a617          	auipc	a2,0x9a
ffffffffc02054a0:	94460613          	addi	a2,a2,-1724 # ffffffffc029ede0 <proc_list>
ffffffffc02054a4:	86b2                	mv	a3,a2
ffffffffc02054a6:	b76d                	j	ffffffffc0205450 <schedule+0x34>
        intr_disable();
ffffffffc02054a8:	cd2fb0ef          	jal	ffffffffc020097a <intr_disable>
        return 1;
ffffffffc02054ac:	4405                	li	s0,1
ffffffffc02054ae:	bfbd                	j	ffffffffc020542c <schedule+0x10>

ffffffffc02054b0 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc02054b0:	0009a797          	auipc	a5,0x9a
ffffffffc02054b4:	9b07b783          	ld	a5,-1616(a5) # ffffffffc029ee60 <current>
}
ffffffffc02054b8:	43c8                	lw	a0,4(a5)
ffffffffc02054ba:	8082                	ret

ffffffffc02054bc <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc02054bc:	4501                	li	a0,0
ffffffffc02054be:	8082                	ret

ffffffffc02054c0 <sys_putc>:
    cputchar(c);
ffffffffc02054c0:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc02054c2:	1141                	addi	sp,sp,-16
ffffffffc02054c4:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc02054c6:	d03fa0ef          	jal	ffffffffc02001c8 <cputchar>
}
ffffffffc02054ca:	60a2                	ld	ra,8(sp)
ffffffffc02054cc:	4501                	li	a0,0
ffffffffc02054ce:	0141                	addi	sp,sp,16
ffffffffc02054d0:	8082                	ret

ffffffffc02054d2 <sys_kill>:
    return do_kill(pid);
ffffffffc02054d2:	4108                	lw	a0,0(a0)
ffffffffc02054d4:	c13ff06f          	j	ffffffffc02050e6 <do_kill>

ffffffffc02054d8 <sys_yield>:
    return do_yield();
ffffffffc02054d8:	bbfff06f          	j	ffffffffc0205096 <do_yield>

ffffffffc02054dc <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc02054dc:	6d14                	ld	a3,24(a0)
ffffffffc02054de:	6910                	ld	a2,16(a0)
ffffffffc02054e0:	650c                	ld	a1,8(a0)
ffffffffc02054e2:	6108                	ld	a0,0(a0)
ffffffffc02054e4:	e26ff06f          	j	ffffffffc0204b0a <do_execve>

ffffffffc02054e8 <sys_wait>:
    return do_wait(pid, store);
ffffffffc02054e8:	650c                	ld	a1,8(a0)
ffffffffc02054ea:	4108                	lw	a0,0(a0)
ffffffffc02054ec:	bbbff06f          	j	ffffffffc02050a6 <do_wait>

ffffffffc02054f0 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc02054f0:	0009a797          	auipc	a5,0x9a
ffffffffc02054f4:	9707b783          	ld	a5,-1680(a5) # ffffffffc029ee60 <current>
ffffffffc02054f8:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc02054fa:	4501                	li	a0,0
ffffffffc02054fc:	6a0c                	ld	a1,16(a2)
ffffffffc02054fe:	d6bfe06f          	j	ffffffffc0204268 <do_fork>

ffffffffc0205502 <sys_exit>:
    return do_exit(error_code);
ffffffffc0205502:	4108                	lw	a0,0(a0)
ffffffffc0205504:	9b2ff06f          	j	ffffffffc02046b6 <do_exit>

ffffffffc0205508 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc0205508:	715d                	addi	sp,sp,-80
ffffffffc020550a:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc020550c:	0009a497          	auipc	s1,0x9a
ffffffffc0205510:	95448493          	addi	s1,s1,-1708 # ffffffffc029ee60 <current>
ffffffffc0205514:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc0205516:	e0a2                	sd	s0,64(sp)
ffffffffc0205518:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc020551a:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc020551c:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc020551e:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc0205520:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205524:	0327ee63          	bltu	a5,s2,ffffffffc0205560 <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc0205528:	00391713          	slli	a4,s2,0x3
ffffffffc020552c:	00002797          	auipc	a5,0x2
ffffffffc0205530:	37c78793          	addi	a5,a5,892 # ffffffffc02078a8 <syscalls>
ffffffffc0205534:	97ba                	add	a5,a5,a4
ffffffffc0205536:	639c                	ld	a5,0(a5)
ffffffffc0205538:	c785                	beqz	a5,ffffffffc0205560 <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc020553a:	7028                	ld	a0,96(s0)
ffffffffc020553c:	742c                	ld	a1,104(s0)
ffffffffc020553e:	7834                	ld	a3,112(s0)
ffffffffc0205540:	7c38                	ld	a4,120(s0)
ffffffffc0205542:	6c30                	ld	a2,88(s0)
ffffffffc0205544:	e82a                	sd	a0,16(sp)
ffffffffc0205546:	ec2e                	sd	a1,24(sp)
ffffffffc0205548:	e432                	sd	a2,8(sp)
ffffffffc020554a:	f036                	sd	a3,32(sp)
ffffffffc020554c:	f43a                	sd	a4,40(sp)
            arg[1] = tf->gpr.a2;
            arg[2] = tf->gpr.a3;
            arg[3] = tf->gpr.a4;
            arg[4] = tf->gpr.a5;
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc020554e:	0028                	addi	a0,sp,8
ffffffffc0205550:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc0205552:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205554:	e828                	sd	a0,80(s0)
}
ffffffffc0205556:	6406                	ld	s0,64(sp)
ffffffffc0205558:	74e2                	ld	s1,56(sp)
ffffffffc020555a:	7942                	ld	s2,48(sp)
ffffffffc020555c:	6161                	addi	sp,sp,80
ffffffffc020555e:	8082                	ret
    print_trapframe(tf);
ffffffffc0205560:	8522                	mv	a0,s0
ffffffffc0205562:	e08fb0ef          	jal	ffffffffc0200b6a <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc0205566:	609c                	ld	a5,0(s1)
ffffffffc0205568:	86ca                	mv	a3,s2
ffffffffc020556a:	00002617          	auipc	a2,0x2
ffffffffc020556e:	11660613          	addi	a2,a2,278 # ffffffffc0207680 <etext+0x1c12>
ffffffffc0205572:	43d8                	lw	a4,4(a5)
ffffffffc0205574:	06200593          	li	a1,98
ffffffffc0205578:	0b478793          	addi	a5,a5,180
ffffffffc020557c:	00002517          	auipc	a0,0x2
ffffffffc0205580:	13450513          	addi	a0,a0,308 # ffffffffc02076b0 <etext+0x1c42>
ffffffffc0205584:	f05fa0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0205588 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0205588:	9e3707b7          	lui	a5,0x9e370
ffffffffc020558c:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_obj___user_exit_out_size+0xffffffff9e3664f9>
ffffffffc020558e:	02a787bb          	mulw	a5,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205592:	02000513          	li	a0,32
ffffffffc0205596:	9d0d                	subw	a0,a0,a1
}
ffffffffc0205598:	00a7d53b          	srlw	a0,a5,a0
ffffffffc020559c:	8082                	ret

ffffffffc020559e <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020559e:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02055a2:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc02055a4:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02055a8:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02055aa:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02055ae:	f022                	sd	s0,32(sp)
ffffffffc02055b0:	ec26                	sd	s1,24(sp)
ffffffffc02055b2:	e84a                	sd	s2,16(sp)
ffffffffc02055b4:	f406                	sd	ra,40(sp)
ffffffffc02055b6:	84aa                	mv	s1,a0
ffffffffc02055b8:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02055ba:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc02055be:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc02055c0:	05067063          	bgeu	a2,a6,ffffffffc0205600 <printnum+0x62>
ffffffffc02055c4:	e44e                	sd	s3,8(sp)
ffffffffc02055c6:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02055c8:	4785                	li	a5,1
ffffffffc02055ca:	00e7d763          	bge	a5,a4,ffffffffc02055d8 <printnum+0x3a>
            putch(padc, putdat);
ffffffffc02055ce:	85ca                	mv	a1,s2
ffffffffc02055d0:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc02055d2:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02055d4:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02055d6:	fc65                	bnez	s0,ffffffffc02055ce <printnum+0x30>
ffffffffc02055d8:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02055da:	1a02                	slli	s4,s4,0x20
ffffffffc02055dc:	020a5a13          	srli	s4,s4,0x20
ffffffffc02055e0:	00002797          	auipc	a5,0x2
ffffffffc02055e4:	0e878793          	addi	a5,a5,232 # ffffffffc02076c8 <etext+0x1c5a>
ffffffffc02055e8:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc02055ea:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02055ec:	0007c503          	lbu	a0,0(a5)
}
ffffffffc02055f0:	70a2                	ld	ra,40(sp)
ffffffffc02055f2:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02055f4:	85ca                	mv	a1,s2
ffffffffc02055f6:	87a6                	mv	a5,s1
}
ffffffffc02055f8:	6942                	ld	s2,16(sp)
ffffffffc02055fa:	64e2                	ld	s1,24(sp)
ffffffffc02055fc:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02055fe:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205600:	03065633          	divu	a2,a2,a6
ffffffffc0205604:	8722                	mv	a4,s0
ffffffffc0205606:	f99ff0ef          	jal	ffffffffc020559e <printnum>
ffffffffc020560a:	bfc1                	j	ffffffffc02055da <printnum+0x3c>

ffffffffc020560c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc020560c:	7119                	addi	sp,sp,-128
ffffffffc020560e:	f4a6                	sd	s1,104(sp)
ffffffffc0205610:	f0ca                	sd	s2,96(sp)
ffffffffc0205612:	ecce                	sd	s3,88(sp)
ffffffffc0205614:	e8d2                	sd	s4,80(sp)
ffffffffc0205616:	e4d6                	sd	s5,72(sp)
ffffffffc0205618:	e0da                	sd	s6,64(sp)
ffffffffc020561a:	f862                	sd	s8,48(sp)
ffffffffc020561c:	fc86                	sd	ra,120(sp)
ffffffffc020561e:	f8a2                	sd	s0,112(sp)
ffffffffc0205620:	fc5e                	sd	s7,56(sp)
ffffffffc0205622:	f466                	sd	s9,40(sp)
ffffffffc0205624:	f06a                	sd	s10,32(sp)
ffffffffc0205626:	ec6e                	sd	s11,24(sp)
ffffffffc0205628:	892a                	mv	s2,a0
ffffffffc020562a:	84ae                	mv	s1,a1
ffffffffc020562c:	8c32                	mv	s8,a2
ffffffffc020562e:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205630:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205634:	05500b13          	li	s6,85
ffffffffc0205638:	00002a97          	auipc	s5,0x2
ffffffffc020563c:	370a8a93          	addi	s5,s5,880 # ffffffffc02079a8 <syscalls+0x100>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205640:	000c4503          	lbu	a0,0(s8)
ffffffffc0205644:	001c0413          	addi	s0,s8,1
ffffffffc0205648:	01350a63          	beq	a0,s3,ffffffffc020565c <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc020564c:	cd0d                	beqz	a0,ffffffffc0205686 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc020564e:	85a6                	mv	a1,s1
ffffffffc0205650:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205652:	00044503          	lbu	a0,0(s0)
ffffffffc0205656:	0405                	addi	s0,s0,1
ffffffffc0205658:	ff351ae3          	bne	a0,s3,ffffffffc020564c <vprintfmt+0x40>
        char padc = ' ';
ffffffffc020565c:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0205660:	4b81                	li	s7,0
ffffffffc0205662:	4601                	li	a2,0
        width = precision = -1;
ffffffffc0205664:	5d7d                	li	s10,-1
ffffffffc0205666:	5cfd                	li	s9,-1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205668:	00044683          	lbu	a3,0(s0)
ffffffffc020566c:	00140c13          	addi	s8,s0,1
ffffffffc0205670:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0205674:	0ff5f593          	zext.b	a1,a1
ffffffffc0205678:	02bb6663          	bltu	s6,a1,ffffffffc02056a4 <vprintfmt+0x98>
ffffffffc020567c:	058a                	slli	a1,a1,0x2
ffffffffc020567e:	95d6                	add	a1,a1,s5
ffffffffc0205680:	4198                	lw	a4,0(a1)
ffffffffc0205682:	9756                	add	a4,a4,s5
ffffffffc0205684:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205686:	70e6                	ld	ra,120(sp)
ffffffffc0205688:	7446                	ld	s0,112(sp)
ffffffffc020568a:	74a6                	ld	s1,104(sp)
ffffffffc020568c:	7906                	ld	s2,96(sp)
ffffffffc020568e:	69e6                	ld	s3,88(sp)
ffffffffc0205690:	6a46                	ld	s4,80(sp)
ffffffffc0205692:	6aa6                	ld	s5,72(sp)
ffffffffc0205694:	6b06                	ld	s6,64(sp)
ffffffffc0205696:	7be2                	ld	s7,56(sp)
ffffffffc0205698:	7c42                	ld	s8,48(sp)
ffffffffc020569a:	7ca2                	ld	s9,40(sp)
ffffffffc020569c:	7d02                	ld	s10,32(sp)
ffffffffc020569e:	6de2                	ld	s11,24(sp)
ffffffffc02056a0:	6109                	addi	sp,sp,128
ffffffffc02056a2:	8082                	ret
            putch('%', putdat);
ffffffffc02056a4:	85a6                	mv	a1,s1
ffffffffc02056a6:	02500513          	li	a0,37
ffffffffc02056aa:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02056ac:	fff44703          	lbu	a4,-1(s0)
ffffffffc02056b0:	02500793          	li	a5,37
ffffffffc02056b4:	8c22                	mv	s8,s0
ffffffffc02056b6:	f8f705e3          	beq	a4,a5,ffffffffc0205640 <vprintfmt+0x34>
ffffffffc02056ba:	02500713          	li	a4,37
ffffffffc02056be:	ffec4783          	lbu	a5,-2(s8)
ffffffffc02056c2:	1c7d                	addi	s8,s8,-1
ffffffffc02056c4:	fee79de3          	bne	a5,a4,ffffffffc02056be <vprintfmt+0xb2>
ffffffffc02056c8:	bfa5                	j	ffffffffc0205640 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc02056ca:	00144783          	lbu	a5,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc02056ce:	4725                	li	a4,9
                precision = precision * 10 + ch - '0';
ffffffffc02056d0:	fd068d1b          	addiw	s10,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc02056d4:	fd07859b          	addiw	a1,a5,-48
                ch = *fmt;
ffffffffc02056d8:	0007869b          	sext.w	a3,a5
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056dc:	8462                	mv	s0,s8
                if (ch < '0' || ch > '9') {
ffffffffc02056de:	02b76563          	bltu	a4,a1,ffffffffc0205708 <vprintfmt+0xfc>
ffffffffc02056e2:	4525                	li	a0,9
                ch = *fmt;
ffffffffc02056e4:	00144783          	lbu	a5,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02056e8:	002d171b          	slliw	a4,s10,0x2
ffffffffc02056ec:	01a7073b          	addw	a4,a4,s10
ffffffffc02056f0:	0017171b          	slliw	a4,a4,0x1
ffffffffc02056f4:	9f35                	addw	a4,a4,a3
                if (ch < '0' || ch > '9') {
ffffffffc02056f6:	fd07859b          	addiw	a1,a5,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02056fa:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02056fc:	fd070d1b          	addiw	s10,a4,-48
                ch = *fmt;
ffffffffc0205700:	0007869b          	sext.w	a3,a5
                if (ch < '0' || ch > '9') {
ffffffffc0205704:	feb570e3          	bgeu	a0,a1,ffffffffc02056e4 <vprintfmt+0xd8>
            if (width < 0)
ffffffffc0205708:	f60cd0e3          	bgez	s9,ffffffffc0205668 <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc020570c:	8cea                	mv	s9,s10
ffffffffc020570e:	5d7d                	li	s10,-1
ffffffffc0205710:	bfa1                	j	ffffffffc0205668 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205712:	8db6                	mv	s11,a3
ffffffffc0205714:	8462                	mv	s0,s8
ffffffffc0205716:	bf89                	j	ffffffffc0205668 <vprintfmt+0x5c>
ffffffffc0205718:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc020571a:	4b85                	li	s7,1
            goto reswitch;
ffffffffc020571c:	b7b1                	j	ffffffffc0205668 <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc020571e:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0205720:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc0205724:	00c7c463          	blt	a5,a2,ffffffffc020572c <vprintfmt+0x120>
    else if (lflag) {
ffffffffc0205728:	1a060163          	beqz	a2,ffffffffc02058ca <vprintfmt+0x2be>
        return va_arg(*ap, unsigned long);
ffffffffc020572c:	000a3603          	ld	a2,0(s4)
ffffffffc0205730:	46c1                	li	a3,16
ffffffffc0205732:	8a3a                	mv	s4,a4
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205734:	000d879b          	sext.w	a5,s11
ffffffffc0205738:	8766                	mv	a4,s9
ffffffffc020573a:	85a6                	mv	a1,s1
ffffffffc020573c:	854a                	mv	a0,s2
ffffffffc020573e:	e61ff0ef          	jal	ffffffffc020559e <printnum>
            break;
ffffffffc0205742:	bdfd                	j	ffffffffc0205640 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0205744:	000a2503          	lw	a0,0(s4)
ffffffffc0205748:	85a6                	mv	a1,s1
ffffffffc020574a:	0a21                	addi	s4,s4,8
ffffffffc020574c:	9902                	jalr	s2
            break;
ffffffffc020574e:	bdcd                	j	ffffffffc0205640 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0205750:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0205752:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc0205756:	00c7c463          	blt	a5,a2,ffffffffc020575e <vprintfmt+0x152>
    else if (lflag) {
ffffffffc020575a:	16060363          	beqz	a2,ffffffffc02058c0 <vprintfmt+0x2b4>
        return va_arg(*ap, unsigned long);
ffffffffc020575e:	000a3603          	ld	a2,0(s4)
ffffffffc0205762:	46a9                	li	a3,10
ffffffffc0205764:	8a3a                	mv	s4,a4
ffffffffc0205766:	b7f9                	j	ffffffffc0205734 <vprintfmt+0x128>
            putch('0', putdat);
ffffffffc0205768:	85a6                	mv	a1,s1
ffffffffc020576a:	03000513          	li	a0,48
ffffffffc020576e:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0205770:	85a6                	mv	a1,s1
ffffffffc0205772:	07800513          	li	a0,120
ffffffffc0205776:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205778:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc020577c:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020577e:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0205780:	bf55                	j	ffffffffc0205734 <vprintfmt+0x128>
            putch(ch, putdat);
ffffffffc0205782:	85a6                	mv	a1,s1
ffffffffc0205784:	02500513          	li	a0,37
ffffffffc0205788:	9902                	jalr	s2
            break;
ffffffffc020578a:	bd5d                	j	ffffffffc0205640 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc020578c:	000a2d03          	lw	s10,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205790:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0205792:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0205794:	bf95                	j	ffffffffc0205708 <vprintfmt+0xfc>
    if (lflag >= 2) {
ffffffffc0205796:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0205798:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc020579c:	00c7c463          	blt	a5,a2,ffffffffc02057a4 <vprintfmt+0x198>
    else if (lflag) {
ffffffffc02057a0:	10060b63          	beqz	a2,ffffffffc02058b6 <vprintfmt+0x2aa>
        return va_arg(*ap, unsigned long);
ffffffffc02057a4:	000a3603          	ld	a2,0(s4)
ffffffffc02057a8:	46a1                	li	a3,8
ffffffffc02057aa:	8a3a                	mv	s4,a4
ffffffffc02057ac:	b761                	j	ffffffffc0205734 <vprintfmt+0x128>
            if (width < 0)
ffffffffc02057ae:	fffcc793          	not	a5,s9
ffffffffc02057b2:	97fd                	srai	a5,a5,0x3f
ffffffffc02057b4:	00fcf7b3          	and	a5,s9,a5
ffffffffc02057b8:	00078c9b          	sext.w	s9,a5
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02057bc:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc02057be:	b56d                	j	ffffffffc0205668 <vprintfmt+0x5c>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02057c0:	000a3403          	ld	s0,0(s4)
ffffffffc02057c4:	008a0793          	addi	a5,s4,8
ffffffffc02057c8:	e43e                	sd	a5,8(sp)
ffffffffc02057ca:	12040063          	beqz	s0,ffffffffc02058ea <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc02057ce:	0d905963          	blez	s9,ffffffffc02058a0 <vprintfmt+0x294>
ffffffffc02057d2:	02d00793          	li	a5,45
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057d6:	00140a13          	addi	s4,s0,1
            if (width > 0 && padc != '-') {
ffffffffc02057da:	12fd9763          	bne	s11,a5,ffffffffc0205908 <vprintfmt+0x2fc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057de:	00044783          	lbu	a5,0(s0)
ffffffffc02057e2:	0007851b          	sext.w	a0,a5
ffffffffc02057e6:	cb9d                	beqz	a5,ffffffffc020581c <vprintfmt+0x210>
ffffffffc02057e8:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02057ea:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057ee:	000d4563          	bltz	s10,ffffffffc02057f8 <vprintfmt+0x1ec>
ffffffffc02057f2:	3d7d                	addiw	s10,s10,-1
ffffffffc02057f4:	028d0263          	beq	s10,s0,ffffffffc0205818 <vprintfmt+0x20c>
                    putch('?', putdat);
ffffffffc02057f8:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02057fa:	0c0b8d63          	beqz	s7,ffffffffc02058d4 <vprintfmt+0x2c8>
ffffffffc02057fe:	3781                	addiw	a5,a5,-32
ffffffffc0205800:	0cfdfa63          	bgeu	s11,a5,ffffffffc02058d4 <vprintfmt+0x2c8>
                    putch('?', putdat);
ffffffffc0205804:	03f00513          	li	a0,63
ffffffffc0205808:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020580a:	000a4783          	lbu	a5,0(s4)
ffffffffc020580e:	3cfd                	addiw	s9,s9,-1
ffffffffc0205810:	0a05                	addi	s4,s4,1
ffffffffc0205812:	0007851b          	sext.w	a0,a5
ffffffffc0205816:	ffe1                	bnez	a5,ffffffffc02057ee <vprintfmt+0x1e2>
            for (; width > 0; width --) {
ffffffffc0205818:	01905963          	blez	s9,ffffffffc020582a <vprintfmt+0x21e>
                putch(' ', putdat);
ffffffffc020581c:	85a6                	mv	a1,s1
ffffffffc020581e:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0205822:	3cfd                	addiw	s9,s9,-1
                putch(' ', putdat);
ffffffffc0205824:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0205826:	fe0c9be3          	bnez	s9,ffffffffc020581c <vprintfmt+0x210>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020582a:	6a22                	ld	s4,8(sp)
ffffffffc020582c:	bd11                	j	ffffffffc0205640 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc020582e:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0205830:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0205834:	00c7c363          	blt	a5,a2,ffffffffc020583a <vprintfmt+0x22e>
    else if (lflag) {
ffffffffc0205838:	ce25                	beqz	a2,ffffffffc02058b0 <vprintfmt+0x2a4>
        return va_arg(*ap, long);
ffffffffc020583a:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc020583e:	08044d63          	bltz	s0,ffffffffc02058d8 <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0205842:	8622                	mv	a2,s0
ffffffffc0205844:	8a5e                	mv	s4,s7
ffffffffc0205846:	46a9                	li	a3,10
ffffffffc0205848:	b5f5                	j	ffffffffc0205734 <vprintfmt+0x128>
            if (err < 0) {
ffffffffc020584a:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020584e:	4661                	li	a2,24
            if (err < 0) {
ffffffffc0205850:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0205854:	8fb9                	xor	a5,a5,a4
ffffffffc0205856:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020585a:	02d64663          	blt	a2,a3,ffffffffc0205886 <vprintfmt+0x27a>
ffffffffc020585e:	00369713          	slli	a4,a3,0x3
ffffffffc0205862:	00002797          	auipc	a5,0x2
ffffffffc0205866:	29e78793          	addi	a5,a5,670 # ffffffffc0207b00 <error_string>
ffffffffc020586a:	97ba                	add	a5,a5,a4
ffffffffc020586c:	639c                	ld	a5,0(a5)
ffffffffc020586e:	cf81                	beqz	a5,ffffffffc0205886 <vprintfmt+0x27a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0205870:	86be                	mv	a3,a5
ffffffffc0205872:	00000617          	auipc	a2,0x0
ffffffffc0205876:	22660613          	addi	a2,a2,550 # ffffffffc0205a98 <etext+0x2a>
ffffffffc020587a:	85a6                	mv	a1,s1
ffffffffc020587c:	854a                	mv	a0,s2
ffffffffc020587e:	0e8000ef          	jal	ffffffffc0205966 <printfmt>
            err = va_arg(ap, int);
ffffffffc0205882:	0a21                	addi	s4,s4,8
ffffffffc0205884:	bb75                	j	ffffffffc0205640 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0205886:	00002617          	auipc	a2,0x2
ffffffffc020588a:	e6260613          	addi	a2,a2,-414 # ffffffffc02076e8 <etext+0x1c7a>
ffffffffc020588e:	85a6                	mv	a1,s1
ffffffffc0205890:	854a                	mv	a0,s2
ffffffffc0205892:	0d4000ef          	jal	ffffffffc0205966 <printfmt>
            err = va_arg(ap, int);
ffffffffc0205896:	0a21                	addi	s4,s4,8
ffffffffc0205898:	b365                	j	ffffffffc0205640 <vprintfmt+0x34>
            lflag ++;
ffffffffc020589a:	2605                	addiw	a2,a2,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020589c:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc020589e:	b3e9                	j	ffffffffc0205668 <vprintfmt+0x5c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02058a0:	00044783          	lbu	a5,0(s0)
ffffffffc02058a4:	0007851b          	sext.w	a0,a5
ffffffffc02058a8:	d3c9                	beqz	a5,ffffffffc020582a <vprintfmt+0x21e>
ffffffffc02058aa:	00140a13          	addi	s4,s0,1
ffffffffc02058ae:	bf2d                	j	ffffffffc02057e8 <vprintfmt+0x1dc>
        return va_arg(*ap, int);
ffffffffc02058b0:	000a2403          	lw	s0,0(s4)
ffffffffc02058b4:	b769                	j	ffffffffc020583e <vprintfmt+0x232>
        return va_arg(*ap, unsigned int);
ffffffffc02058b6:	000a6603          	lwu	a2,0(s4)
ffffffffc02058ba:	46a1                	li	a3,8
ffffffffc02058bc:	8a3a                	mv	s4,a4
ffffffffc02058be:	bd9d                	j	ffffffffc0205734 <vprintfmt+0x128>
ffffffffc02058c0:	000a6603          	lwu	a2,0(s4)
ffffffffc02058c4:	46a9                	li	a3,10
ffffffffc02058c6:	8a3a                	mv	s4,a4
ffffffffc02058c8:	b5b5                	j	ffffffffc0205734 <vprintfmt+0x128>
ffffffffc02058ca:	000a6603          	lwu	a2,0(s4)
ffffffffc02058ce:	46c1                	li	a3,16
ffffffffc02058d0:	8a3a                	mv	s4,a4
ffffffffc02058d2:	b58d                	j	ffffffffc0205734 <vprintfmt+0x128>
                    putch(ch, putdat);
ffffffffc02058d4:	9902                	jalr	s2
ffffffffc02058d6:	bf15                	j	ffffffffc020580a <vprintfmt+0x1fe>
                putch('-', putdat);
ffffffffc02058d8:	85a6                	mv	a1,s1
ffffffffc02058da:	02d00513          	li	a0,45
ffffffffc02058de:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02058e0:	40800633          	neg	a2,s0
ffffffffc02058e4:	8a5e                	mv	s4,s7
ffffffffc02058e6:	46a9                	li	a3,10
ffffffffc02058e8:	b5b1                	j	ffffffffc0205734 <vprintfmt+0x128>
            if (width > 0 && padc != '-') {
ffffffffc02058ea:	01905663          	blez	s9,ffffffffc02058f6 <vprintfmt+0x2ea>
ffffffffc02058ee:	02d00793          	li	a5,45
ffffffffc02058f2:	04fd9263          	bne	s11,a5,ffffffffc0205936 <vprintfmt+0x32a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02058f6:	02800793          	li	a5,40
ffffffffc02058fa:	00002a17          	auipc	s4,0x2
ffffffffc02058fe:	de7a0a13          	addi	s4,s4,-537 # ffffffffc02076e1 <etext+0x1c73>
ffffffffc0205902:	02800513          	li	a0,40
ffffffffc0205906:	b5cd                	j	ffffffffc02057e8 <vprintfmt+0x1dc>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205908:	85ea                	mv	a1,s10
ffffffffc020590a:	8522                	mv	a0,s0
ffffffffc020590c:	094000ef          	jal	ffffffffc02059a0 <strnlen>
ffffffffc0205910:	40ac8cbb          	subw	s9,s9,a0
ffffffffc0205914:	01905963          	blez	s9,ffffffffc0205926 <vprintfmt+0x31a>
                    putch(padc, putdat);
ffffffffc0205918:	2d81                	sext.w	s11,s11
ffffffffc020591a:	85a6                	mv	a1,s1
ffffffffc020591c:	856e                	mv	a0,s11
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020591e:	3cfd                	addiw	s9,s9,-1
                    putch(padc, putdat);
ffffffffc0205920:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205922:	fe0c9ce3          	bnez	s9,ffffffffc020591a <vprintfmt+0x30e>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205926:	00044783          	lbu	a5,0(s0)
ffffffffc020592a:	0007851b          	sext.w	a0,a5
ffffffffc020592e:	ea079de3          	bnez	a5,ffffffffc02057e8 <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205932:	6a22                	ld	s4,8(sp)
ffffffffc0205934:	b331                	j	ffffffffc0205640 <vprintfmt+0x34>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205936:	85ea                	mv	a1,s10
ffffffffc0205938:	00002517          	auipc	a0,0x2
ffffffffc020593c:	da850513          	addi	a0,a0,-600 # ffffffffc02076e0 <etext+0x1c72>
ffffffffc0205940:	060000ef          	jal	ffffffffc02059a0 <strnlen>
ffffffffc0205944:	40ac8cbb          	subw	s9,s9,a0
                p = "(null)";
ffffffffc0205948:	00002417          	auipc	s0,0x2
ffffffffc020594c:	d9840413          	addi	s0,s0,-616 # ffffffffc02076e0 <etext+0x1c72>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205950:	00002a17          	auipc	s4,0x2
ffffffffc0205954:	d91a0a13          	addi	s4,s4,-623 # ffffffffc02076e1 <etext+0x1c73>
ffffffffc0205958:	02800793          	li	a5,40
ffffffffc020595c:	02800513          	li	a0,40
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205960:	fb904ce3          	bgtz	s9,ffffffffc0205918 <vprintfmt+0x30c>
ffffffffc0205964:	b551                	j	ffffffffc02057e8 <vprintfmt+0x1dc>

ffffffffc0205966 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205966:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0205968:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020596c:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020596e:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205970:	ec06                	sd	ra,24(sp)
ffffffffc0205972:	f83a                	sd	a4,48(sp)
ffffffffc0205974:	fc3e                	sd	a5,56(sp)
ffffffffc0205976:	e0c2                	sd	a6,64(sp)
ffffffffc0205978:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020597a:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020597c:	c91ff0ef          	jal	ffffffffc020560c <vprintfmt>
}
ffffffffc0205980:	60e2                	ld	ra,24(sp)
ffffffffc0205982:	6161                	addi	sp,sp,80
ffffffffc0205984:	8082                	ret

ffffffffc0205986 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0205986:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc020598a:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc020598c:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc020598e:	cb81                	beqz	a5,ffffffffc020599e <strlen+0x18>
        cnt ++;
ffffffffc0205990:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0205992:	00a707b3          	add	a5,a4,a0
ffffffffc0205996:	0007c783          	lbu	a5,0(a5)
ffffffffc020599a:	fbfd                	bnez	a5,ffffffffc0205990 <strlen+0xa>
ffffffffc020599c:	8082                	ret
    }
    return cnt;
}
ffffffffc020599e:	8082                	ret

ffffffffc02059a0 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02059a0:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02059a2:	e589                	bnez	a1,ffffffffc02059ac <strnlen+0xc>
ffffffffc02059a4:	a811                	j	ffffffffc02059b8 <strnlen+0x18>
        cnt ++;
ffffffffc02059a6:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02059a8:	00f58863          	beq	a1,a5,ffffffffc02059b8 <strnlen+0x18>
ffffffffc02059ac:	00f50733          	add	a4,a0,a5
ffffffffc02059b0:	00074703          	lbu	a4,0(a4)
ffffffffc02059b4:	fb6d                	bnez	a4,ffffffffc02059a6 <strnlen+0x6>
ffffffffc02059b6:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02059b8:	852e                	mv	a0,a1
ffffffffc02059ba:	8082                	ret

ffffffffc02059bc <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc02059bc:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc02059be:	0005c703          	lbu	a4,0(a1)
ffffffffc02059c2:	0785                	addi	a5,a5,1
ffffffffc02059c4:	0585                	addi	a1,a1,1
ffffffffc02059c6:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02059ca:	fb75                	bnez	a4,ffffffffc02059be <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc02059cc:	8082                	ret

ffffffffc02059ce <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02059ce:	00054783          	lbu	a5,0(a0)
ffffffffc02059d2:	e791                	bnez	a5,ffffffffc02059de <strcmp+0x10>
ffffffffc02059d4:	a02d                	j	ffffffffc02059fe <strcmp+0x30>
ffffffffc02059d6:	00054783          	lbu	a5,0(a0)
ffffffffc02059da:	cf89                	beqz	a5,ffffffffc02059f4 <strcmp+0x26>
ffffffffc02059dc:	85b6                	mv	a1,a3
ffffffffc02059de:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc02059e2:	0505                	addi	a0,a0,1
ffffffffc02059e4:	00158693          	addi	a3,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02059e8:	fef707e3          	beq	a4,a5,ffffffffc02059d6 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02059ec:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02059f0:	9d19                	subw	a0,a0,a4
ffffffffc02059f2:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02059f4:	0015c703          	lbu	a4,1(a1)
ffffffffc02059f8:	4501                	li	a0,0
}
ffffffffc02059fa:	9d19                	subw	a0,a0,a4
ffffffffc02059fc:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02059fe:	0005c703          	lbu	a4,0(a1)
ffffffffc0205a02:	4501                	li	a0,0
ffffffffc0205a04:	b7f5                	j	ffffffffc02059f0 <strcmp+0x22>

ffffffffc0205a06 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205a06:	ce01                	beqz	a2,ffffffffc0205a1e <strncmp+0x18>
ffffffffc0205a08:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0205a0c:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205a0e:	cb91                	beqz	a5,ffffffffc0205a22 <strncmp+0x1c>
ffffffffc0205a10:	0005c703          	lbu	a4,0(a1)
ffffffffc0205a14:	00f71763          	bne	a4,a5,ffffffffc0205a22 <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0205a18:	0505                	addi	a0,a0,1
ffffffffc0205a1a:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205a1c:	f675                	bnez	a2,ffffffffc0205a08 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205a1e:	4501                	li	a0,0
ffffffffc0205a20:	8082                	ret
ffffffffc0205a22:	00054503          	lbu	a0,0(a0)
ffffffffc0205a26:	0005c783          	lbu	a5,0(a1)
ffffffffc0205a2a:	9d1d                	subw	a0,a0,a5
}
ffffffffc0205a2c:	8082                	ret

ffffffffc0205a2e <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0205a2e:	00054783          	lbu	a5,0(a0)
ffffffffc0205a32:	c799                	beqz	a5,ffffffffc0205a40 <strchr+0x12>
        if (*s == c) {
ffffffffc0205a34:	00f58763          	beq	a1,a5,ffffffffc0205a42 <strchr+0x14>
    while (*s != '\0') {
ffffffffc0205a38:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0205a3c:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0205a3e:	fbfd                	bnez	a5,ffffffffc0205a34 <strchr+0x6>
    }
    return NULL;
ffffffffc0205a40:	4501                	li	a0,0
}
ffffffffc0205a42:	8082                	ret

ffffffffc0205a44 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0205a44:	ca01                	beqz	a2,ffffffffc0205a54 <memset+0x10>
ffffffffc0205a46:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0205a48:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0205a4a:	0785                	addi	a5,a5,1
ffffffffc0205a4c:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0205a50:	fef61de3          	bne	a2,a5,ffffffffc0205a4a <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0205a54:	8082                	ret

ffffffffc0205a56 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0205a56:	ca19                	beqz	a2,ffffffffc0205a6c <memcpy+0x16>
ffffffffc0205a58:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0205a5a:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0205a5c:	0005c703          	lbu	a4,0(a1)
ffffffffc0205a60:	0585                	addi	a1,a1,1
ffffffffc0205a62:	0785                	addi	a5,a5,1
ffffffffc0205a64:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0205a68:	feb61ae3          	bne	a2,a1,ffffffffc0205a5c <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0205a6c:	8082                	ret
