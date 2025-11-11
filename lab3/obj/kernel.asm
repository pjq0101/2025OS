
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00007297          	auipc	t0,0x7
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0207000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00007297          	auipc	t0,0x7
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0207008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02062b7          	lui	t0,0xc0206
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
ffffffffc020003c:	c0206137          	lui	sp,0xc0206

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 1. 使用临时寄存器 t1 计算栈顶的精确地址
    lui t1, %hi(bootstacktop)
ffffffffc0200040:	c0206337          	lui	t1,0xc0206
    addi t1, t1, %lo(bootstacktop)
ffffffffc0200044:	00030313          	mv	t1,t1
    # 2. 将精确地址一次性地、安全地传给 sp
    mv sp, t1
ffffffffc0200048:	811a                	mv	sp,t1
    # 现在栈指针已经完美设置，可以安全地调用任何C函数了
    # 然后跳转到 kern_init (不再返回)
    lui t0, %hi(kern_init)
ffffffffc020004a:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020004e:	05428293          	addi	t0,t0,84 # ffffffffc0200054 <kern_init>
    jr t0
ffffffffc0200052:	8282                	jr	t0

ffffffffc0200054 <kern_init>:
void grade_backtrace(void);

int kern_init(void) {
    extern char edata[], end[];
    // 先清零 BSS，再读取并保存 DTB 的内存信息，避免被清零覆盖（为了解释变化 正式上传时我觉得应该删去这句话）
    memset(edata, 0, end - edata);
ffffffffc0200054:	00007517          	auipc	a0,0x7
ffffffffc0200058:	fd450513          	addi	a0,a0,-44 # ffffffffc0207028 <free_area>
ffffffffc020005c:	00007617          	auipc	a2,0x7
ffffffffc0200060:	44460613          	addi	a2,a2,1092 # ffffffffc02074a0 <end>
int kern_init(void) {
ffffffffc0200064:	1141                	addi	sp,sp,-16 # ffffffffc0205ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc0200066:	8e09                	sub	a2,a2,a0
ffffffffc0200068:	4581                	li	a1,0
int kern_init(void) {
ffffffffc020006a:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020006c:	75b010ef          	jal	ffffffffc0201fc6 <memset>
    dtb_init();
ffffffffc0200070:	428000ef          	jal	ffffffffc0200498 <dtb_init>
    cons_init();  // init the console
ffffffffc0200074:	416000ef          	jal	ffffffffc020048a <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200078:	00003517          	auipc	a0,0x3
ffffffffc020007c:	e1050513          	addi	a0,a0,-496 # ffffffffc0202e88 <etext+0xeb0>
ffffffffc0200080:	0ac000ef          	jal	ffffffffc020012c <cputs>

    print_kerninfo();
ffffffffc0200084:	106000ef          	jal	ffffffffc020018a <print_kerninfo>

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200088:	798000ef          	jal	ffffffffc0200820 <idt_init>

    pmm_init();  // init physical memory management
ffffffffc020008c:	784010ef          	jal	ffffffffc0201810 <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc0200090:	790000ef          	jal	ffffffffc0200820 <idt_init>

    clock_init();   // init clock interrupt
ffffffffc0200094:	3b4000ef          	jal	ffffffffc0200448 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200098:	77c000ef          	jal	ffffffffc0200814 <intr_enable>


    
    // 测试1：非法指令异常
    cprintf("Testing mret (illegal instruction)...\n");
ffffffffc020009c:	00002517          	auipc	a0,0x2
ffffffffc02000a0:	f3c50513          	addi	a0,a0,-196 # ffffffffc0201fd8 <etext>
ffffffffc02000a4:	052000ef          	jal	ffffffffc02000f6 <cprintf>
    asm("mret");
ffffffffc02000a8:	30200073          	mret

    // 测试2：断点异常  
    cprintf("Testing ebreak (breakpoint)...\n");
ffffffffc02000ac:	00002517          	auipc	a0,0x2
ffffffffc02000b0:	f5c50513          	addi	a0,a0,-164 # ffffffffc0202008 <etext+0x30>
ffffffffc02000b4:	042000ef          	jal	ffffffffc02000f6 <cprintf>
    asm("ebreak");
ffffffffc02000b8:	9002                	ebreak

    
    
    /* do nothing */
    while (1)
ffffffffc02000ba:	a001                	j	ffffffffc02000ba <kern_init+0x66>

ffffffffc02000bc <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc02000bc:	1141                	addi	sp,sp,-16
ffffffffc02000be:	e022                	sd	s0,0(sp)
ffffffffc02000c0:	e406                	sd	ra,8(sp)
ffffffffc02000c2:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc02000c4:	3c8000ef          	jal	ffffffffc020048c <cons_putc>
    (*cnt) ++;
ffffffffc02000c8:	401c                	lw	a5,0(s0)
}
ffffffffc02000ca:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc02000cc:	2785                	addiw	a5,a5,1
ffffffffc02000ce:	c01c                	sw	a5,0(s0)
}
ffffffffc02000d0:	6402                	ld	s0,0(sp)
ffffffffc02000d2:	0141                	addi	sp,sp,16
ffffffffc02000d4:	8082                	ret

ffffffffc02000d6 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000d6:	1101                	addi	sp,sp,-32
ffffffffc02000d8:	862a                	mv	a2,a0
ffffffffc02000da:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000dc:	00000517          	auipc	a0,0x0
ffffffffc02000e0:	fe050513          	addi	a0,a0,-32 # ffffffffc02000bc <cputch>
ffffffffc02000e4:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000e6:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000e8:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000ea:	199010ef          	jal	ffffffffc0201a82 <vprintfmt>
    return cnt;
}
ffffffffc02000ee:	60e2                	ld	ra,24(sp)
ffffffffc02000f0:	4532                	lw	a0,12(sp)
ffffffffc02000f2:	6105                	addi	sp,sp,32
ffffffffc02000f4:	8082                	ret

ffffffffc02000f6 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000f6:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000f8:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
ffffffffc02000fc:	f42e                	sd	a1,40(sp)
ffffffffc02000fe:	f832                	sd	a2,48(sp)
ffffffffc0200100:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200102:	862a                	mv	a2,a0
ffffffffc0200104:	004c                	addi	a1,sp,4
ffffffffc0200106:	00000517          	auipc	a0,0x0
ffffffffc020010a:	fb650513          	addi	a0,a0,-74 # ffffffffc02000bc <cputch>
ffffffffc020010e:	869a                	mv	a3,t1
cprintf(const char *fmt, ...) {
ffffffffc0200110:	ec06                	sd	ra,24(sp)
ffffffffc0200112:	e0ba                	sd	a4,64(sp)
ffffffffc0200114:	e4be                	sd	a5,72(sp)
ffffffffc0200116:	e8c2                	sd	a6,80(sp)
ffffffffc0200118:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc020011a:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc020011c:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020011e:	165010ef          	jal	ffffffffc0201a82 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc0200122:	60e2                	ld	ra,24(sp)
ffffffffc0200124:	4512                	lw	a0,4(sp)
ffffffffc0200126:	6125                	addi	sp,sp,96
ffffffffc0200128:	8082                	ret

ffffffffc020012a <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc020012a:	a68d                	j	ffffffffc020048c <cons_putc>

ffffffffc020012c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc020012c:	1101                	addi	sp,sp,-32
ffffffffc020012e:	ec06                	sd	ra,24(sp)
ffffffffc0200130:	e822                	sd	s0,16(sp)
ffffffffc0200132:	87aa                	mv	a5,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc0200134:	00054503          	lbu	a0,0(a0)
ffffffffc0200138:	c905                	beqz	a0,ffffffffc0200168 <cputs+0x3c>
ffffffffc020013a:	e426                	sd	s1,8(sp)
ffffffffc020013c:	00178493          	addi	s1,a5,1
ffffffffc0200140:	8426                	mv	s0,s1
    cons_putc(c);
ffffffffc0200142:	34a000ef          	jal	ffffffffc020048c <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200146:	00044503          	lbu	a0,0(s0)
ffffffffc020014a:	87a2                	mv	a5,s0
ffffffffc020014c:	0405                	addi	s0,s0,1
ffffffffc020014e:	f975                	bnez	a0,ffffffffc0200142 <cputs+0x16>
    (*cnt) ++;
ffffffffc0200150:	9f85                	subw	a5,a5,s1
    cons_putc(c);
ffffffffc0200152:	4529                	li	a0,10
    (*cnt) ++;
ffffffffc0200154:	0027841b          	addiw	s0,a5,2
ffffffffc0200158:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc020015a:	332000ef          	jal	ffffffffc020048c <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc020015e:	60e2                	ld	ra,24(sp)
ffffffffc0200160:	8522                	mv	a0,s0
ffffffffc0200162:	6442                	ld	s0,16(sp)
ffffffffc0200164:	6105                	addi	sp,sp,32
ffffffffc0200166:	8082                	ret
    cons_putc(c);
ffffffffc0200168:	4529                	li	a0,10
ffffffffc020016a:	322000ef          	jal	ffffffffc020048c <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc020016e:	4405                	li	s0,1
}
ffffffffc0200170:	60e2                	ld	ra,24(sp)
ffffffffc0200172:	8522                	mv	a0,s0
ffffffffc0200174:	6442                	ld	s0,16(sp)
ffffffffc0200176:	6105                	addi	sp,sp,32
ffffffffc0200178:	8082                	ret

ffffffffc020017a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc020017a:	1141                	addi	sp,sp,-16
ffffffffc020017c:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020017e:	316000ef          	jal	ffffffffc0200494 <cons_getc>
ffffffffc0200182:	dd75                	beqz	a0,ffffffffc020017e <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200184:	60a2                	ld	ra,8(sp)
ffffffffc0200186:	0141                	addi	sp,sp,16
ffffffffc0200188:	8082                	ret

ffffffffc020018a <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020018a:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020018c:	00002517          	auipc	a0,0x2
ffffffffc0200190:	e9c50513          	addi	a0,a0,-356 # ffffffffc0202028 <etext+0x50>
void print_kerninfo(void) {
ffffffffc0200194:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200196:	f61ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc020019a:	00000597          	auipc	a1,0x0
ffffffffc020019e:	eba58593          	addi	a1,a1,-326 # ffffffffc0200054 <kern_init>
ffffffffc02001a2:	00002517          	auipc	a0,0x2
ffffffffc02001a6:	ea650513          	addi	a0,a0,-346 # ffffffffc0202048 <etext+0x70>
ffffffffc02001aa:	f4dff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc02001ae:	00002597          	auipc	a1,0x2
ffffffffc02001b2:	e2a58593          	addi	a1,a1,-470 # ffffffffc0201fd8 <etext>
ffffffffc02001b6:	00002517          	auipc	a0,0x2
ffffffffc02001ba:	eb250513          	addi	a0,a0,-334 # ffffffffc0202068 <etext+0x90>
ffffffffc02001be:	f39ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc02001c2:	00007597          	auipc	a1,0x7
ffffffffc02001c6:	e6658593          	addi	a1,a1,-410 # ffffffffc0207028 <free_area>
ffffffffc02001ca:	00002517          	auipc	a0,0x2
ffffffffc02001ce:	ebe50513          	addi	a0,a0,-322 # ffffffffc0202088 <etext+0xb0>
ffffffffc02001d2:	f25ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc02001d6:	00007597          	auipc	a1,0x7
ffffffffc02001da:	2ca58593          	addi	a1,a1,714 # ffffffffc02074a0 <end>
ffffffffc02001de:	00002517          	auipc	a0,0x2
ffffffffc02001e2:	eca50513          	addi	a0,a0,-310 # ffffffffc02020a8 <etext+0xd0>
ffffffffc02001e6:	f11ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001ea:	00007797          	auipc	a5,0x7
ffffffffc02001ee:	6b578793          	addi	a5,a5,1717 # ffffffffc020789f <end+0x3ff>
ffffffffc02001f2:	00000717          	auipc	a4,0x0
ffffffffc02001f6:	e6270713          	addi	a4,a4,-414 # ffffffffc0200054 <kern_init>
ffffffffc02001fa:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001fc:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200200:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200202:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200206:	95be                	add	a1,a1,a5
ffffffffc0200208:	85a9                	srai	a1,a1,0xa
ffffffffc020020a:	00002517          	auipc	a0,0x2
ffffffffc020020e:	ebe50513          	addi	a0,a0,-322 # ffffffffc02020c8 <etext+0xf0>
}
ffffffffc0200212:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200214:	b5cd                	j	ffffffffc02000f6 <cprintf>

ffffffffc0200216 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc0200216:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc0200218:	00002617          	auipc	a2,0x2
ffffffffc020021c:	ee060613          	addi	a2,a2,-288 # ffffffffc02020f8 <etext+0x120>
ffffffffc0200220:	04d00593          	li	a1,77
ffffffffc0200224:	00002517          	auipc	a0,0x2
ffffffffc0200228:	eec50513          	addi	a0,a0,-276 # ffffffffc0202110 <etext+0x138>
void print_stackframe(void) {
ffffffffc020022c:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc020022e:	1bc000ef          	jal	ffffffffc02003ea <__panic>

ffffffffc0200232 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200232:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200234:	00002617          	auipc	a2,0x2
ffffffffc0200238:	ef460613          	addi	a2,a2,-268 # ffffffffc0202128 <etext+0x150>
ffffffffc020023c:	00002597          	auipc	a1,0x2
ffffffffc0200240:	f0c58593          	addi	a1,a1,-244 # ffffffffc0202148 <etext+0x170>
ffffffffc0200244:	00002517          	auipc	a0,0x2
ffffffffc0200248:	f0c50513          	addi	a0,a0,-244 # ffffffffc0202150 <etext+0x178>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc020024c:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020024e:	ea9ff0ef          	jal	ffffffffc02000f6 <cprintf>
ffffffffc0200252:	00002617          	auipc	a2,0x2
ffffffffc0200256:	f0e60613          	addi	a2,a2,-242 # ffffffffc0202160 <etext+0x188>
ffffffffc020025a:	00002597          	auipc	a1,0x2
ffffffffc020025e:	f2e58593          	addi	a1,a1,-210 # ffffffffc0202188 <etext+0x1b0>
ffffffffc0200262:	00002517          	auipc	a0,0x2
ffffffffc0200266:	eee50513          	addi	a0,a0,-274 # ffffffffc0202150 <etext+0x178>
ffffffffc020026a:	e8dff0ef          	jal	ffffffffc02000f6 <cprintf>
ffffffffc020026e:	00002617          	auipc	a2,0x2
ffffffffc0200272:	f2a60613          	addi	a2,a2,-214 # ffffffffc0202198 <etext+0x1c0>
ffffffffc0200276:	00002597          	auipc	a1,0x2
ffffffffc020027a:	f4258593          	addi	a1,a1,-190 # ffffffffc02021b8 <etext+0x1e0>
ffffffffc020027e:	00002517          	auipc	a0,0x2
ffffffffc0200282:	ed250513          	addi	a0,a0,-302 # ffffffffc0202150 <etext+0x178>
ffffffffc0200286:	e71ff0ef          	jal	ffffffffc02000f6 <cprintf>
    }
    return 0;
}
ffffffffc020028a:	60a2                	ld	ra,8(sp)
ffffffffc020028c:	4501                	li	a0,0
ffffffffc020028e:	0141                	addi	sp,sp,16
ffffffffc0200290:	8082                	ret

ffffffffc0200292 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200292:	1141                	addi	sp,sp,-16
ffffffffc0200294:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200296:	ef5ff0ef          	jal	ffffffffc020018a <print_kerninfo>
    return 0;
}
ffffffffc020029a:	60a2                	ld	ra,8(sp)
ffffffffc020029c:	4501                	li	a0,0
ffffffffc020029e:	0141                	addi	sp,sp,16
ffffffffc02002a0:	8082                	ret

ffffffffc02002a2 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002a2:	1141                	addi	sp,sp,-16
ffffffffc02002a4:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02002a6:	f71ff0ef          	jal	ffffffffc0200216 <print_stackframe>
    return 0;
}
ffffffffc02002aa:	60a2                	ld	ra,8(sp)
ffffffffc02002ac:	4501                	li	a0,0
ffffffffc02002ae:	0141                	addi	sp,sp,16
ffffffffc02002b0:	8082                	ret

ffffffffc02002b2 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc02002b2:	7115                	addi	sp,sp,-224
ffffffffc02002b4:	f15a                	sd	s6,160(sp)
ffffffffc02002b6:	8b2a                	mv	s6,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002b8:	00002517          	auipc	a0,0x2
ffffffffc02002bc:	f1050513          	addi	a0,a0,-240 # ffffffffc02021c8 <etext+0x1f0>
kmonitor(struct trapframe *tf) {
ffffffffc02002c0:	ed86                	sd	ra,216(sp)
ffffffffc02002c2:	e9a2                	sd	s0,208(sp)
ffffffffc02002c4:	e5a6                	sd	s1,200(sp)
ffffffffc02002c6:	e1ca                	sd	s2,192(sp)
ffffffffc02002c8:	fd4e                	sd	s3,184(sp)
ffffffffc02002ca:	f952                	sd	s4,176(sp)
ffffffffc02002cc:	f556                	sd	s5,168(sp)
ffffffffc02002ce:	ed5e                	sd	s7,152(sp)
ffffffffc02002d0:	e962                	sd	s8,144(sp)
ffffffffc02002d2:	e566                	sd	s9,136(sp)
ffffffffc02002d4:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002d6:	e21ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002da:	00002517          	auipc	a0,0x2
ffffffffc02002de:	f1650513          	addi	a0,a0,-234 # ffffffffc02021f0 <etext+0x218>
ffffffffc02002e2:	e15ff0ef          	jal	ffffffffc02000f6 <cprintf>
    if (tf != NULL) {
ffffffffc02002e6:	000b0563          	beqz	s6,ffffffffc02002f0 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc02002ea:	855a                	mv	a0,s6
ffffffffc02002ec:	714000ef          	jal	ffffffffc0200a00 <print_trapframe>
ffffffffc02002f0:	00003c17          	auipc	s8,0x3
ffffffffc02002f4:	bb8c0c13          	addi	s8,s8,-1096 # ffffffffc0202ea8 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02002f8:	00002917          	auipc	s2,0x2
ffffffffc02002fc:	f2090913          	addi	s2,s2,-224 # ffffffffc0202218 <etext+0x240>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200300:	00002497          	auipc	s1,0x2
ffffffffc0200304:	f2048493          	addi	s1,s1,-224 # ffffffffc0202220 <etext+0x248>
        if (argc == MAXARGS - 1) {
ffffffffc0200308:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020030a:	00002a97          	auipc	s5,0x2
ffffffffc020030e:	f1ea8a93          	addi	s5,s5,-226 # ffffffffc0202228 <etext+0x250>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200312:	4a0d                	li	s4,3
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200314:	00002b97          	auipc	s7,0x2
ffffffffc0200318:	f34b8b93          	addi	s7,s7,-204 # ffffffffc0202248 <etext+0x270>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020031c:	854a                	mv	a0,s2
ffffffffc020031e:	2df010ef          	jal	ffffffffc0201dfc <readline>
ffffffffc0200322:	842a                	mv	s0,a0
ffffffffc0200324:	dd65                	beqz	a0,ffffffffc020031c <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200326:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc020032a:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020032c:	e59d                	bnez	a1,ffffffffc020035a <kmonitor+0xa8>
    if (argc == 0) {
ffffffffc020032e:	fe0c87e3          	beqz	s9,ffffffffc020031c <kmonitor+0x6a>
ffffffffc0200332:	00003d17          	auipc	s10,0x3
ffffffffc0200336:	b76d0d13          	addi	s10,s10,-1162 # ffffffffc0202ea8 <commands>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020033a:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020033c:	6582                	ld	a1,0(sp)
ffffffffc020033e:	000d3503          	ld	a0,0(s10)
ffffffffc0200342:	40f010ef          	jal	ffffffffc0201f50 <strcmp>
ffffffffc0200346:	c53d                	beqz	a0,ffffffffc02003b4 <kmonitor+0x102>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200348:	2405                	addiw	s0,s0,1
ffffffffc020034a:	0d61                	addi	s10,s10,24
ffffffffc020034c:	ff4418e3          	bne	s0,s4,ffffffffc020033c <kmonitor+0x8a>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200350:	6582                	ld	a1,0(sp)
ffffffffc0200352:	855e                	mv	a0,s7
ffffffffc0200354:	da3ff0ef          	jal	ffffffffc02000f6 <cprintf>
    return 0;
ffffffffc0200358:	b7d1                	j	ffffffffc020031c <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020035a:	8526                	mv	a0,s1
ffffffffc020035c:	455010ef          	jal	ffffffffc0201fb0 <strchr>
ffffffffc0200360:	c901                	beqz	a0,ffffffffc0200370 <kmonitor+0xbe>
ffffffffc0200362:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200366:	00040023          	sb	zero,0(s0)
ffffffffc020036a:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020036c:	d1e9                	beqz	a1,ffffffffc020032e <kmonitor+0x7c>
ffffffffc020036e:	b7f5                	j	ffffffffc020035a <kmonitor+0xa8>
        if (*buf == '\0') {
ffffffffc0200370:	00044783          	lbu	a5,0(s0)
ffffffffc0200374:	dfcd                	beqz	a5,ffffffffc020032e <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc0200376:	033c8a63          	beq	s9,s3,ffffffffc02003aa <kmonitor+0xf8>
        argv[argc ++] = buf;
ffffffffc020037a:	003c9793          	slli	a5,s9,0x3
ffffffffc020037e:	08078793          	addi	a5,a5,128
ffffffffc0200382:	978a                	add	a5,a5,sp
ffffffffc0200384:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200388:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc020038c:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020038e:	e591                	bnez	a1,ffffffffc020039a <kmonitor+0xe8>
ffffffffc0200390:	bf79                	j	ffffffffc020032e <kmonitor+0x7c>
ffffffffc0200392:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc0200396:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200398:	d9d9                	beqz	a1,ffffffffc020032e <kmonitor+0x7c>
ffffffffc020039a:	8526                	mv	a0,s1
ffffffffc020039c:	415010ef          	jal	ffffffffc0201fb0 <strchr>
ffffffffc02003a0:	d96d                	beqz	a0,ffffffffc0200392 <kmonitor+0xe0>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003a2:	00044583          	lbu	a1,0(s0)
ffffffffc02003a6:	d5c1                	beqz	a1,ffffffffc020032e <kmonitor+0x7c>
ffffffffc02003a8:	bf4d                	j	ffffffffc020035a <kmonitor+0xa8>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003aa:	45c1                	li	a1,16
ffffffffc02003ac:	8556                	mv	a0,s5
ffffffffc02003ae:	d49ff0ef          	jal	ffffffffc02000f6 <cprintf>
ffffffffc02003b2:	b7e1                	j	ffffffffc020037a <kmonitor+0xc8>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003b4:	00141793          	slli	a5,s0,0x1
ffffffffc02003b8:	97a2                	add	a5,a5,s0
ffffffffc02003ba:	078e                	slli	a5,a5,0x3
ffffffffc02003bc:	97e2                	add	a5,a5,s8
ffffffffc02003be:	6b9c                	ld	a5,16(a5)
ffffffffc02003c0:	865a                	mv	a2,s6
ffffffffc02003c2:	002c                	addi	a1,sp,8
ffffffffc02003c4:	fffc851b          	addiw	a0,s9,-1
ffffffffc02003c8:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02003ca:	f40559e3          	bgez	a0,ffffffffc020031c <kmonitor+0x6a>
}
ffffffffc02003ce:	60ee                	ld	ra,216(sp)
ffffffffc02003d0:	644e                	ld	s0,208(sp)
ffffffffc02003d2:	64ae                	ld	s1,200(sp)
ffffffffc02003d4:	690e                	ld	s2,192(sp)
ffffffffc02003d6:	79ea                	ld	s3,184(sp)
ffffffffc02003d8:	7a4a                	ld	s4,176(sp)
ffffffffc02003da:	7aaa                	ld	s5,168(sp)
ffffffffc02003dc:	7b0a                	ld	s6,160(sp)
ffffffffc02003de:	6bea                	ld	s7,152(sp)
ffffffffc02003e0:	6c4a                	ld	s8,144(sp)
ffffffffc02003e2:	6caa                	ld	s9,136(sp)
ffffffffc02003e4:	6d0a                	ld	s10,128(sp)
ffffffffc02003e6:	612d                	addi	sp,sp,224
ffffffffc02003e8:	8082                	ret

ffffffffc02003ea <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02003ea:	00007317          	auipc	t1,0x7
ffffffffc02003ee:	05630313          	addi	t1,t1,86 # ffffffffc0207440 <is_panic>
ffffffffc02003f2:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02003f6:	715d                	addi	sp,sp,-80
ffffffffc02003f8:	ec06                	sd	ra,24(sp)
ffffffffc02003fa:	f436                	sd	a3,40(sp)
ffffffffc02003fc:	f83a                	sd	a4,48(sp)
ffffffffc02003fe:	fc3e                	sd	a5,56(sp)
ffffffffc0200400:	e0c2                	sd	a6,64(sp)
ffffffffc0200402:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200404:	020e1c63          	bnez	t3,ffffffffc020043c <__panic+0x52>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200408:	4785                	li	a5,1
ffffffffc020040a:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc020040e:	e822                	sd	s0,16(sp)
ffffffffc0200410:	103c                	addi	a5,sp,40
ffffffffc0200412:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200414:	862e                	mv	a2,a1
ffffffffc0200416:	85aa                	mv	a1,a0
ffffffffc0200418:	00002517          	auipc	a0,0x2
ffffffffc020041c:	e4850513          	addi	a0,a0,-440 # ffffffffc0202260 <etext+0x288>
    va_start(ap, fmt);
ffffffffc0200420:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200422:	cd5ff0ef          	jal	ffffffffc02000f6 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200426:	65a2                	ld	a1,8(sp)
ffffffffc0200428:	8522                	mv	a0,s0
ffffffffc020042a:	cadff0ef          	jal	ffffffffc02000d6 <vcprintf>
    cprintf("\n");
ffffffffc020042e:	00002517          	auipc	a0,0x2
ffffffffc0200432:	e5250513          	addi	a0,a0,-430 # ffffffffc0202280 <etext+0x2a8>
ffffffffc0200436:	cc1ff0ef          	jal	ffffffffc02000f6 <cprintf>
ffffffffc020043a:	6442                	ld	s0,16(sp)
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc020043c:	3de000ef          	jal	ffffffffc020081a <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc0200440:	4501                	li	a0,0
ffffffffc0200442:	e71ff0ef          	jal	ffffffffc02002b2 <kmonitor>
    while (1) {
ffffffffc0200446:	bfed                	j	ffffffffc0200440 <__panic+0x56>

ffffffffc0200448 <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
ffffffffc0200448:	1141                	addi	sp,sp,-16
ffffffffc020044a:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
ffffffffc020044c:	02000793          	li	a5,32
ffffffffc0200450:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200454:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200458:	67e1                	lui	a5,0x18
ffffffffc020045a:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020045e:	953e                	add	a0,a0,a5
ffffffffc0200460:	26b010ef          	jal	ffffffffc0201eca <sbi_set_timer>
}
ffffffffc0200464:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc0200466:	00007797          	auipc	a5,0x7
ffffffffc020046a:	fe07b123          	sd	zero,-30(a5) # ffffffffc0207448 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020046e:	00002517          	auipc	a0,0x2
ffffffffc0200472:	e1a50513          	addi	a0,a0,-486 # ffffffffc0202288 <etext+0x2b0>
}
ffffffffc0200476:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
ffffffffc0200478:	b9bd                	j	ffffffffc02000f6 <cprintf>

ffffffffc020047a <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020047a:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020047e:	67e1                	lui	a5,0x18
ffffffffc0200480:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200484:	953e                	add	a0,a0,a5
ffffffffc0200486:	2450106f          	j	ffffffffc0201eca <sbi_set_timer>

ffffffffc020048a <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020048a:	8082                	ret

ffffffffc020048c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc020048c:	0ff57513          	zext.b	a0,a0
ffffffffc0200490:	2210106f          	j	ffffffffc0201eb0 <sbi_console_putchar>

ffffffffc0200494 <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
ffffffffc0200494:	2510106f          	j	ffffffffc0201ee4 <sbi_console_getchar>

ffffffffc0200498 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200498:	711d                	addi	sp,sp,-96
    cprintf("DTB Init\n");
ffffffffc020049a:	00002517          	auipc	a0,0x2
ffffffffc020049e:	e0e50513          	addi	a0,a0,-498 # ffffffffc02022a8 <etext+0x2d0>
void dtb_init(void) {
ffffffffc02004a2:	ec86                	sd	ra,88(sp)
ffffffffc02004a4:	e8a2                	sd	s0,80(sp)
    cprintf("DTB Init\n");
ffffffffc02004a6:	c51ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02004aa:	00007597          	auipc	a1,0x7
ffffffffc02004ae:	b565b583          	ld	a1,-1194(a1) # ffffffffc0207000 <boot_hartid>
ffffffffc02004b2:	00002517          	auipc	a0,0x2
ffffffffc02004b6:	e0650513          	addi	a0,a0,-506 # ffffffffc02022b8 <etext+0x2e0>
ffffffffc02004ba:	c3dff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02004be:	00007417          	auipc	s0,0x7
ffffffffc02004c2:	b4a40413          	addi	s0,s0,-1206 # ffffffffc0207008 <boot_dtb>
ffffffffc02004c6:	600c                	ld	a1,0(s0)
ffffffffc02004c8:	00002517          	auipc	a0,0x2
ffffffffc02004cc:	e0050513          	addi	a0,a0,-512 # ffffffffc02022c8 <etext+0x2f0>
ffffffffc02004d0:	c27ff0ef          	jal	ffffffffc02000f6 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02004d4:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02004d6:	00002517          	auipc	a0,0x2
ffffffffc02004da:	e0a50513          	addi	a0,a0,-502 # ffffffffc02022e0 <etext+0x308>
    if (boot_dtb == 0) {
ffffffffc02004de:	12070d63          	beqz	a4,ffffffffc0200618 <dtb_init+0x180>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc02004e2:	57f5                	li	a5,-3
ffffffffc02004e4:	07fa                	slli	a5,a5,0x1e
ffffffffc02004e6:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc02004e8:	431c                	lw	a5,0(a4)
ffffffffc02004ea:	f456                	sd	s5,40(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004ec:	00ff0637          	lui	a2,0xff0
ffffffffc02004f0:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02004f4:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004f8:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004fc:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200500:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200504:	6ac1                	lui	s5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200506:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200508:	8ec9                	or	a3,a3,a0
ffffffffc020050a:	0087979b          	slliw	a5,a5,0x8
ffffffffc020050e:	1afd                	addi	s5,s5,-1 # ffff <kern_entry-0xffffffffc01f0001>
ffffffffc0200510:	0157f7b3          	and	a5,a5,s5
ffffffffc0200514:	8dd5                	or	a1,a1,a3
ffffffffc0200516:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200518:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020051c:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc020051e:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfed8a4d>
ffffffffc0200522:	0ef59f63          	bne	a1,a5,ffffffffc0200620 <dtb_init+0x188>
ffffffffc0200526:	471c                	lw	a5,8(a4)
ffffffffc0200528:	4754                	lw	a3,12(a4)
ffffffffc020052a:	fc4e                	sd	s3,56(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020052c:	0087d99b          	srliw	s3,a5,0x8
ffffffffc0200530:	0086d41b          	srliw	s0,a3,0x8
ffffffffc0200534:	0186951b          	slliw	a0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200538:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020053c:	0187959b          	slliw	a1,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200540:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200544:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200548:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020054c:	0109999b          	slliw	s3,s3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200550:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200554:	8c71                	and	s0,s0,a2
ffffffffc0200556:	00c9f9b3          	and	s3,s3,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020055a:	01156533          	or	a0,a0,a7
ffffffffc020055e:	0086969b          	slliw	a3,a3,0x8
ffffffffc0200562:	0105e633          	or	a2,a1,a6
ffffffffc0200566:	0087979b          	slliw	a5,a5,0x8
ffffffffc020056a:	8c49                	or	s0,s0,a0
ffffffffc020056c:	0156f6b3          	and	a3,a3,s5
ffffffffc0200570:	00c9e9b3          	or	s3,s3,a2
ffffffffc0200574:	0157f7b3          	and	a5,a5,s5
ffffffffc0200578:	8c55                	or	s0,s0,a3
ffffffffc020057a:	00f9e9b3          	or	s3,s3,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020057e:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200580:	1982                	slli	s3,s3,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200582:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200584:	0209d993          	srli	s3,s3,0x20
ffffffffc0200588:	e4a6                	sd	s1,72(sp)
ffffffffc020058a:	e0ca                	sd	s2,64(sp)
ffffffffc020058c:	ec5e                	sd	s7,24(sp)
ffffffffc020058e:	e862                	sd	s8,16(sp)
ffffffffc0200590:	e466                	sd	s9,8(sp)
ffffffffc0200592:	e06a                	sd	s10,0(sp)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200594:	f852                	sd	s4,48(sp)
    int in_memory_node = 0;
ffffffffc0200596:	4b81                	li	s7,0
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200598:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020059a:	99ba                	add	s3,s3,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020059c:	00ff0cb7          	lui	s9,0xff0
        switch (token) {
ffffffffc02005a0:	4c0d                	li	s8,3
ffffffffc02005a2:	4911                	li	s2,4
ffffffffc02005a4:	4d05                	li	s10,1
ffffffffc02005a6:	4489                	li	s1,2
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02005a8:	0009a703          	lw	a4,0(s3)
ffffffffc02005ac:	00498a13          	addi	s4,s3,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005b0:	0087569b          	srliw	a3,a4,0x8
ffffffffc02005b4:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005b8:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005bc:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005c0:	0107571b          	srliw	a4,a4,0x10
ffffffffc02005c4:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005c6:	0196f6b3          	and	a3,a3,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ca:	0087171b          	slliw	a4,a4,0x8
ffffffffc02005ce:	8fd5                	or	a5,a5,a3
ffffffffc02005d0:	00eaf733          	and	a4,s5,a4
ffffffffc02005d4:	8fd9                	or	a5,a5,a4
ffffffffc02005d6:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc02005d8:	09878263          	beq	a5,s8,ffffffffc020065c <dtb_init+0x1c4>
ffffffffc02005dc:	00fc6963          	bltu	s8,a5,ffffffffc02005ee <dtb_init+0x156>
ffffffffc02005e0:	05a78963          	beq	a5,s10,ffffffffc0200632 <dtb_init+0x19a>
ffffffffc02005e4:	00979763          	bne	a5,s1,ffffffffc02005f2 <dtb_init+0x15a>
ffffffffc02005e8:	4b81                	li	s7,0
ffffffffc02005ea:	89d2                	mv	s3,s4
ffffffffc02005ec:	bf75                	j	ffffffffc02005a8 <dtb_init+0x110>
ffffffffc02005ee:	ff278ee3          	beq	a5,s2,ffffffffc02005ea <dtb_init+0x152>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02005f2:	00002517          	auipc	a0,0x2
ffffffffc02005f6:	db650513          	addi	a0,a0,-586 # ffffffffc02023a8 <etext+0x3d0>
ffffffffc02005fa:	afdff0ef          	jal	ffffffffc02000f6 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02005fe:	64a6                	ld	s1,72(sp)
ffffffffc0200600:	6906                	ld	s2,64(sp)
ffffffffc0200602:	79e2                	ld	s3,56(sp)
ffffffffc0200604:	7a42                	ld	s4,48(sp)
ffffffffc0200606:	7aa2                	ld	s5,40(sp)
ffffffffc0200608:	6be2                	ld	s7,24(sp)
ffffffffc020060a:	6c42                	ld	s8,16(sp)
ffffffffc020060c:	6ca2                	ld	s9,8(sp)
ffffffffc020060e:	6d02                	ld	s10,0(sp)
ffffffffc0200610:	00002517          	auipc	a0,0x2
ffffffffc0200614:	dd050513          	addi	a0,a0,-560 # ffffffffc02023e0 <etext+0x408>
}
ffffffffc0200618:	6446                	ld	s0,80(sp)
ffffffffc020061a:	60e6                	ld	ra,88(sp)
ffffffffc020061c:	6125                	addi	sp,sp,96
    cprintf("DTB init completed\n");
ffffffffc020061e:	bce1                	j	ffffffffc02000f6 <cprintf>
}
ffffffffc0200620:	6446                	ld	s0,80(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200622:	7aa2                	ld	s5,40(sp)
}
ffffffffc0200624:	60e6                	ld	ra,88(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200626:	00002517          	auipc	a0,0x2
ffffffffc020062a:	cda50513          	addi	a0,a0,-806 # ffffffffc0202300 <etext+0x328>
}
ffffffffc020062e:	6125                	addi	sp,sp,96
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200630:	b4d9                	j	ffffffffc02000f6 <cprintf>
                int name_len = strlen(name);
ffffffffc0200632:	8552                	mv	a0,s4
ffffffffc0200634:	0e7010ef          	jal	ffffffffc0201f1a <strlen>
ffffffffc0200638:	89aa                	mv	s3,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020063a:	4619                	li	a2,6
ffffffffc020063c:	00002597          	auipc	a1,0x2
ffffffffc0200640:	cec58593          	addi	a1,a1,-788 # ffffffffc0202328 <etext+0x350>
ffffffffc0200644:	8552                	mv	a0,s4
                int name_len = strlen(name);
ffffffffc0200646:	2981                	sext.w	s3,s3
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200648:	141010ef          	jal	ffffffffc0201f88 <strncmp>
ffffffffc020064c:	e111                	bnez	a0,ffffffffc0200650 <dtb_init+0x1b8>
                    in_memory_node = 1;
ffffffffc020064e:	4b85                	li	s7,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200650:	0a11                	addi	s4,s4,4
ffffffffc0200652:	9a4e                	add	s4,s4,s3
ffffffffc0200654:	ffca7a13          	andi	s4,s4,-4
        switch (token) {
ffffffffc0200658:	89d2                	mv	s3,s4
ffffffffc020065a:	b7b9                	j	ffffffffc02005a8 <dtb_init+0x110>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc020065c:	0049a783          	lw	a5,4(s3)
ffffffffc0200660:	f05a                	sd	s6,32(sp)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200662:	0089a683          	lw	a3,8(s3)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200666:	0087d71b          	srliw	a4,a5,0x8
ffffffffc020066a:	01879b1b          	slliw	s6,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020066e:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200672:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200676:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020067a:	00cb6b33          	or	s6,s6,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067e:	01977733          	and	a4,a4,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200682:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200686:	00eb6b33          	or	s6,s6,a4
ffffffffc020068a:	00faf7b3          	and	a5,s5,a5
ffffffffc020068e:	00fb6b33          	or	s6,s6,a5
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200692:	00c98a13          	addi	s4,s3,12
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200696:	2b01                	sext.w	s6,s6
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200698:	000b9c63          	bnez	s7,ffffffffc02006b0 <dtb_init+0x218>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc020069c:	1b02                	slli	s6,s6,0x20
ffffffffc020069e:	020b5b13          	srli	s6,s6,0x20
ffffffffc02006a2:	0a0d                	addi	s4,s4,3
ffffffffc02006a4:	9a5a                	add	s4,s4,s6
ffffffffc02006a6:	ffca7a13          	andi	s4,s4,-4
                break;
ffffffffc02006aa:	7b02                	ld	s6,32(sp)
        switch (token) {
ffffffffc02006ac:	89d2                	mv	s3,s4
ffffffffc02006ae:	bded                	j	ffffffffc02005a8 <dtb_init+0x110>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006b0:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02006b4:	0186979b          	slliw	a5,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b8:	0186d71b          	srliw	a4,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006bc:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c0:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c4:	01957533          	and	a0,a0,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c8:	8fd9                	or	a5,a5,a4
ffffffffc02006ca:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006ce:	8d5d                	or	a0,a0,a5
ffffffffc02006d0:	00daf6b3          	and	a3,s5,a3
ffffffffc02006d4:	8d55                	or	a0,a0,a3
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc02006d6:	1502                	slli	a0,a0,0x20
ffffffffc02006d8:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006da:	00002597          	auipc	a1,0x2
ffffffffc02006de:	c5658593          	addi	a1,a1,-938 # ffffffffc0202330 <etext+0x358>
ffffffffc02006e2:	9522                	add	a0,a0,s0
ffffffffc02006e4:	06d010ef          	jal	ffffffffc0201f50 <strcmp>
ffffffffc02006e8:	f955                	bnez	a0,ffffffffc020069c <dtb_init+0x204>
ffffffffc02006ea:	47bd                	li	a5,15
ffffffffc02006ec:	fb67f8e3          	bgeu	a5,s6,ffffffffc020069c <dtb_init+0x204>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02006f0:	00c9b783          	ld	a5,12(s3)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02006f4:	0149b703          	ld	a4,20(s3)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02006f8:	00002517          	auipc	a0,0x2
ffffffffc02006fc:	c4050513          	addi	a0,a0,-960 # ffffffffc0202338 <etext+0x360>
           fdt32_to_cpu(x >> 32);
ffffffffc0200700:	4207d693          	srai	a3,a5,0x20
ffffffffc0200704:	42075813          	srai	a6,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200708:	0187d39b          	srliw	t2,a5,0x18
ffffffffc020070c:	0186d29b          	srliw	t0,a3,0x18
ffffffffc0200710:	01875f9b          	srliw	t6,a4,0x18
ffffffffc0200714:	01885f1b          	srliw	t5,a6,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200718:	0087d49b          	srliw	s1,a5,0x8
ffffffffc020071c:	0087541b          	srliw	s0,a4,0x8
ffffffffc0200720:	01879e9b          	slliw	t4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200724:	0107d59b          	srliw	a1,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200728:	01869e1b          	slliw	t3,a3,0x18
ffffffffc020072c:	0187131b          	slliw	t1,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200730:	0107561b          	srliw	a2,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200734:	0188189b          	slliw	a7,a6,0x18
ffffffffc0200738:	83e1                	srli	a5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020073a:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020073e:	8361                	srli	a4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200740:	0108581b          	srliw	a6,a6,0x10
ffffffffc0200744:	005e6e33          	or	t3,t3,t0
ffffffffc0200748:	01e8e8b3          	or	a7,a7,t5
ffffffffc020074c:	0088181b          	slliw	a6,a6,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200750:	0104949b          	slliw	s1,s1,0x10
ffffffffc0200754:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200758:	0085959b          	slliw	a1,a1,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020075c:	0197f7b3          	and	a5,a5,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200760:	0086969b          	slliw	a3,a3,0x8
ffffffffc0200764:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200768:	01977733          	and	a4,a4,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020076c:	00daf6b3          	and	a3,s5,a3
ffffffffc0200770:	007eeeb3          	or	t4,t4,t2
ffffffffc0200774:	01f36333          	or	t1,t1,t6
ffffffffc0200778:	01c7e7b3          	or	a5,a5,t3
ffffffffc020077c:	00caf633          	and	a2,s5,a2
ffffffffc0200780:	01176733          	or	a4,a4,a7
ffffffffc0200784:	00baf5b3          	and	a1,s5,a1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200788:	0194f4b3          	and	s1,s1,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020078c:	010afab3          	and	s5,s5,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200790:	01947433          	and	s0,s0,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200794:	01d4e4b3          	or	s1,s1,t4
ffffffffc0200798:	00646433          	or	s0,s0,t1
ffffffffc020079c:	8fd5                	or	a5,a5,a3
ffffffffc020079e:	01576733          	or	a4,a4,s5
ffffffffc02007a2:	8c51                	or	s0,s0,a2
ffffffffc02007a4:	8ccd                	or	s1,s1,a1
           fdt32_to_cpu(x >> 32);
ffffffffc02007a6:	1782                	slli	a5,a5,0x20
ffffffffc02007a8:	1702                	slli	a4,a4,0x20
ffffffffc02007aa:	9381                	srli	a5,a5,0x20
ffffffffc02007ac:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02007ae:	1482                	slli	s1,s1,0x20
ffffffffc02007b0:	1402                	slli	s0,s0,0x20
ffffffffc02007b2:	8cdd                	or	s1,s1,a5
ffffffffc02007b4:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc02007b6:	941ff0ef          	jal	ffffffffc02000f6 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc02007ba:	85a6                	mv	a1,s1
ffffffffc02007bc:	00002517          	auipc	a0,0x2
ffffffffc02007c0:	b9c50513          	addi	a0,a0,-1124 # ffffffffc0202358 <etext+0x380>
ffffffffc02007c4:	933ff0ef          	jal	ffffffffc02000f6 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc02007c8:	01445613          	srli	a2,s0,0x14
ffffffffc02007cc:	85a2                	mv	a1,s0
ffffffffc02007ce:	00002517          	auipc	a0,0x2
ffffffffc02007d2:	ba250513          	addi	a0,a0,-1118 # ffffffffc0202370 <etext+0x398>
ffffffffc02007d6:	921ff0ef          	jal	ffffffffc02000f6 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02007da:	009405b3          	add	a1,s0,s1
ffffffffc02007de:	15fd                	addi	a1,a1,-1
ffffffffc02007e0:	00002517          	auipc	a0,0x2
ffffffffc02007e4:	bb050513          	addi	a0,a0,-1104 # ffffffffc0202390 <etext+0x3b8>
ffffffffc02007e8:	90fff0ef          	jal	ffffffffc02000f6 <cprintf>
        memory_base = mem_base;
ffffffffc02007ec:	7b02                	ld	s6,32(sp)
ffffffffc02007ee:	00007797          	auipc	a5,0x7
ffffffffc02007f2:	c697b523          	sd	s1,-918(a5) # ffffffffc0207458 <memory_base>
        memory_size = mem_size;
ffffffffc02007f6:	00007797          	auipc	a5,0x7
ffffffffc02007fa:	c487bd23          	sd	s0,-934(a5) # ffffffffc0207450 <memory_size>
ffffffffc02007fe:	b501                	j	ffffffffc02005fe <dtb_init+0x166>

ffffffffc0200800 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200800:	00007517          	auipc	a0,0x7
ffffffffc0200804:	c5853503          	ld	a0,-936(a0) # ffffffffc0207458 <memory_base>
ffffffffc0200808:	8082                	ret

ffffffffc020080a <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc020080a:	00007517          	auipc	a0,0x7
ffffffffc020080e:	c4653503          	ld	a0,-954(a0) # ffffffffc0207450 <memory_size>
ffffffffc0200812:	8082                	ret

ffffffffc0200814 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200814:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200818:	8082                	ret

ffffffffc020081a <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc020081a:	100177f3          	csrrci	a5,sstatus,2
ffffffffc020081e:	8082                	ret

ffffffffc0200820 <idt_init>:
     */

    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc0200820:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200824:	00000797          	auipc	a5,0x0
ffffffffc0200828:	39478793          	addi	a5,a5,916 # ffffffffc0200bb8 <__alltraps>
ffffffffc020082c:	10579073          	csrw	stvec,a5
}
ffffffffc0200830:	8082                	ret

ffffffffc0200832 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200832:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc0200834:	1141                	addi	sp,sp,-16
ffffffffc0200836:	e022                	sd	s0,0(sp)
ffffffffc0200838:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020083a:	00002517          	auipc	a0,0x2
ffffffffc020083e:	bbe50513          	addi	a0,a0,-1090 # ffffffffc02023f8 <etext+0x420>
void print_regs(struct pushregs *gpr) {
ffffffffc0200842:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200844:	8b3ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200848:	640c                	ld	a1,8(s0)
ffffffffc020084a:	00002517          	auipc	a0,0x2
ffffffffc020084e:	bc650513          	addi	a0,a0,-1082 # ffffffffc0202410 <etext+0x438>
ffffffffc0200852:	8a5ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc0200856:	680c                	ld	a1,16(s0)
ffffffffc0200858:	00002517          	auipc	a0,0x2
ffffffffc020085c:	bd050513          	addi	a0,a0,-1072 # ffffffffc0202428 <etext+0x450>
ffffffffc0200860:	897ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200864:	6c0c                	ld	a1,24(s0)
ffffffffc0200866:	00002517          	auipc	a0,0x2
ffffffffc020086a:	bda50513          	addi	a0,a0,-1062 # ffffffffc0202440 <etext+0x468>
ffffffffc020086e:	889ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200872:	700c                	ld	a1,32(s0)
ffffffffc0200874:	00002517          	auipc	a0,0x2
ffffffffc0200878:	be450513          	addi	a0,a0,-1052 # ffffffffc0202458 <etext+0x480>
ffffffffc020087c:	87bff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200880:	740c                	ld	a1,40(s0)
ffffffffc0200882:	00002517          	auipc	a0,0x2
ffffffffc0200886:	bee50513          	addi	a0,a0,-1042 # ffffffffc0202470 <etext+0x498>
ffffffffc020088a:	86dff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc020088e:	780c                	ld	a1,48(s0)
ffffffffc0200890:	00002517          	auipc	a0,0x2
ffffffffc0200894:	bf850513          	addi	a0,a0,-1032 # ffffffffc0202488 <etext+0x4b0>
ffffffffc0200898:	85fff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc020089c:	7c0c                	ld	a1,56(s0)
ffffffffc020089e:	00002517          	auipc	a0,0x2
ffffffffc02008a2:	c0250513          	addi	a0,a0,-1022 # ffffffffc02024a0 <etext+0x4c8>
ffffffffc02008a6:	851ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02008aa:	602c                	ld	a1,64(s0)
ffffffffc02008ac:	00002517          	auipc	a0,0x2
ffffffffc02008b0:	c0c50513          	addi	a0,a0,-1012 # ffffffffc02024b8 <etext+0x4e0>
ffffffffc02008b4:	843ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02008b8:	642c                	ld	a1,72(s0)
ffffffffc02008ba:	00002517          	auipc	a0,0x2
ffffffffc02008be:	c1650513          	addi	a0,a0,-1002 # ffffffffc02024d0 <etext+0x4f8>
ffffffffc02008c2:	835ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02008c6:	682c                	ld	a1,80(s0)
ffffffffc02008c8:	00002517          	auipc	a0,0x2
ffffffffc02008cc:	c2050513          	addi	a0,a0,-992 # ffffffffc02024e8 <etext+0x510>
ffffffffc02008d0:	827ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02008d4:	6c2c                	ld	a1,88(s0)
ffffffffc02008d6:	00002517          	auipc	a0,0x2
ffffffffc02008da:	c2a50513          	addi	a0,a0,-982 # ffffffffc0202500 <etext+0x528>
ffffffffc02008de:	819ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc02008e2:	702c                	ld	a1,96(s0)
ffffffffc02008e4:	00002517          	auipc	a0,0x2
ffffffffc02008e8:	c3450513          	addi	a0,a0,-972 # ffffffffc0202518 <etext+0x540>
ffffffffc02008ec:	80bff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc02008f0:	742c                	ld	a1,104(s0)
ffffffffc02008f2:	00002517          	auipc	a0,0x2
ffffffffc02008f6:	c3e50513          	addi	a0,a0,-962 # ffffffffc0202530 <etext+0x558>
ffffffffc02008fa:	ffcff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc02008fe:	782c                	ld	a1,112(s0)
ffffffffc0200900:	00002517          	auipc	a0,0x2
ffffffffc0200904:	c4850513          	addi	a0,a0,-952 # ffffffffc0202548 <etext+0x570>
ffffffffc0200908:	feeff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc020090c:	7c2c                	ld	a1,120(s0)
ffffffffc020090e:	00002517          	auipc	a0,0x2
ffffffffc0200912:	c5250513          	addi	a0,a0,-942 # ffffffffc0202560 <etext+0x588>
ffffffffc0200916:	fe0ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020091a:	604c                	ld	a1,128(s0)
ffffffffc020091c:	00002517          	auipc	a0,0x2
ffffffffc0200920:	c5c50513          	addi	a0,a0,-932 # ffffffffc0202578 <etext+0x5a0>
ffffffffc0200924:	fd2ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200928:	644c                	ld	a1,136(s0)
ffffffffc020092a:	00002517          	auipc	a0,0x2
ffffffffc020092e:	c6650513          	addi	a0,a0,-922 # ffffffffc0202590 <etext+0x5b8>
ffffffffc0200932:	fc4ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200936:	684c                	ld	a1,144(s0)
ffffffffc0200938:	00002517          	auipc	a0,0x2
ffffffffc020093c:	c7050513          	addi	a0,a0,-912 # ffffffffc02025a8 <etext+0x5d0>
ffffffffc0200940:	fb6ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200944:	6c4c                	ld	a1,152(s0)
ffffffffc0200946:	00002517          	auipc	a0,0x2
ffffffffc020094a:	c7a50513          	addi	a0,a0,-902 # ffffffffc02025c0 <etext+0x5e8>
ffffffffc020094e:	fa8ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200952:	704c                	ld	a1,160(s0)
ffffffffc0200954:	00002517          	auipc	a0,0x2
ffffffffc0200958:	c8450513          	addi	a0,a0,-892 # ffffffffc02025d8 <etext+0x600>
ffffffffc020095c:	f9aff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200960:	744c                	ld	a1,168(s0)
ffffffffc0200962:	00002517          	auipc	a0,0x2
ffffffffc0200966:	c8e50513          	addi	a0,a0,-882 # ffffffffc02025f0 <etext+0x618>
ffffffffc020096a:	f8cff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc020096e:	784c                	ld	a1,176(s0)
ffffffffc0200970:	00002517          	auipc	a0,0x2
ffffffffc0200974:	c9850513          	addi	a0,a0,-872 # ffffffffc0202608 <etext+0x630>
ffffffffc0200978:	f7eff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc020097c:	7c4c                	ld	a1,184(s0)
ffffffffc020097e:	00002517          	auipc	a0,0x2
ffffffffc0200982:	ca250513          	addi	a0,a0,-862 # ffffffffc0202620 <etext+0x648>
ffffffffc0200986:	f70ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc020098a:	606c                	ld	a1,192(s0)
ffffffffc020098c:	00002517          	auipc	a0,0x2
ffffffffc0200990:	cac50513          	addi	a0,a0,-852 # ffffffffc0202638 <etext+0x660>
ffffffffc0200994:	f62ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200998:	646c                	ld	a1,200(s0)
ffffffffc020099a:	00002517          	auipc	a0,0x2
ffffffffc020099e:	cb650513          	addi	a0,a0,-842 # ffffffffc0202650 <etext+0x678>
ffffffffc02009a2:	f54ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02009a6:	686c                	ld	a1,208(s0)
ffffffffc02009a8:	00002517          	auipc	a0,0x2
ffffffffc02009ac:	cc050513          	addi	a0,a0,-832 # ffffffffc0202668 <etext+0x690>
ffffffffc02009b0:	f46ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02009b4:	6c6c                	ld	a1,216(s0)
ffffffffc02009b6:	00002517          	auipc	a0,0x2
ffffffffc02009ba:	cca50513          	addi	a0,a0,-822 # ffffffffc0202680 <etext+0x6a8>
ffffffffc02009be:	f38ff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc02009c2:	706c                	ld	a1,224(s0)
ffffffffc02009c4:	00002517          	auipc	a0,0x2
ffffffffc02009c8:	cd450513          	addi	a0,a0,-812 # ffffffffc0202698 <etext+0x6c0>
ffffffffc02009cc:	f2aff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc02009d0:	746c                	ld	a1,232(s0)
ffffffffc02009d2:	00002517          	auipc	a0,0x2
ffffffffc02009d6:	cde50513          	addi	a0,a0,-802 # ffffffffc02026b0 <etext+0x6d8>
ffffffffc02009da:	f1cff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc02009de:	786c                	ld	a1,240(s0)
ffffffffc02009e0:	00002517          	auipc	a0,0x2
ffffffffc02009e4:	ce850513          	addi	a0,a0,-792 # ffffffffc02026c8 <etext+0x6f0>
ffffffffc02009e8:	f0eff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02009ec:	7c6c                	ld	a1,248(s0)
}
ffffffffc02009ee:	6402                	ld	s0,0(sp)
ffffffffc02009f0:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02009f2:	00002517          	auipc	a0,0x2
ffffffffc02009f6:	cee50513          	addi	a0,a0,-786 # ffffffffc02026e0 <etext+0x708>
}
ffffffffc02009fa:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02009fc:	efaff06f          	j	ffffffffc02000f6 <cprintf>

ffffffffc0200a00 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a00:	1141                	addi	sp,sp,-16
ffffffffc0200a02:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a04:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a06:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a08:	00002517          	auipc	a0,0x2
ffffffffc0200a0c:	cf050513          	addi	a0,a0,-784 # ffffffffc02026f8 <etext+0x720>
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a10:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a12:	ee4ff0ef          	jal	ffffffffc02000f6 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200a16:	8522                	mv	a0,s0
ffffffffc0200a18:	e1bff0ef          	jal	ffffffffc0200832 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200a1c:	10043583          	ld	a1,256(s0)
ffffffffc0200a20:	00002517          	auipc	a0,0x2
ffffffffc0200a24:	cf050513          	addi	a0,a0,-784 # ffffffffc0202710 <etext+0x738>
ffffffffc0200a28:	eceff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200a2c:	10843583          	ld	a1,264(s0)
ffffffffc0200a30:	00002517          	auipc	a0,0x2
ffffffffc0200a34:	cf850513          	addi	a0,a0,-776 # ffffffffc0202728 <etext+0x750>
ffffffffc0200a38:	ebeff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200a3c:	11043583          	ld	a1,272(s0)
ffffffffc0200a40:	00002517          	auipc	a0,0x2
ffffffffc0200a44:	d0050513          	addi	a0,a0,-768 # ffffffffc0202740 <etext+0x768>
ffffffffc0200a48:	eaeff0ef          	jal	ffffffffc02000f6 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a4c:	11843583          	ld	a1,280(s0)
}
ffffffffc0200a50:	6402                	ld	s0,0(sp)
ffffffffc0200a52:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a54:	00002517          	auipc	a0,0x2
ffffffffc0200a58:	d0450513          	addi	a0,a0,-764 # ffffffffc0202758 <etext+0x780>
}
ffffffffc0200a5c:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a5e:	e98ff06f          	j	ffffffffc02000f6 <cprintf>

ffffffffc0200a62 <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause) {
ffffffffc0200a62:	11853783          	ld	a5,280(a0)
ffffffffc0200a66:	472d                	li	a4,11
ffffffffc0200a68:	0786                	slli	a5,a5,0x1
ffffffffc0200a6a:	8385                	srli	a5,a5,0x1
ffffffffc0200a6c:	08f76363          	bltu	a4,a5,ffffffffc0200af2 <interrupt_handler+0x90>
ffffffffc0200a70:	00002717          	auipc	a4,0x2
ffffffffc0200a74:	48070713          	addi	a4,a4,1152 # ffffffffc0202ef0 <commands+0x48>
ffffffffc0200a78:	078a                	slli	a5,a5,0x2
ffffffffc0200a7a:	97ba                	add	a5,a5,a4
ffffffffc0200a7c:	439c                	lw	a5,0(a5)
ffffffffc0200a7e:	97ba                	add	a5,a5,a4
ffffffffc0200a80:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc0200a82:	00002517          	auipc	a0,0x2
ffffffffc0200a86:	d4e50513          	addi	a0,a0,-690 # ffffffffc02027d0 <etext+0x7f8>
ffffffffc0200a8a:	e6cff06f          	j	ffffffffc02000f6 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc0200a8e:	00002517          	auipc	a0,0x2
ffffffffc0200a92:	d2250513          	addi	a0,a0,-734 # ffffffffc02027b0 <etext+0x7d8>
ffffffffc0200a96:	e60ff06f          	j	ffffffffc02000f6 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc0200a9a:	00002517          	auipc	a0,0x2
ffffffffc0200a9e:	cd650513          	addi	a0,a0,-810 # ffffffffc0202770 <etext+0x798>
ffffffffc0200aa2:	e54ff06f          	j	ffffffffc02000f6 <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc0200aa6:	00002517          	auipc	a0,0x2
ffffffffc0200aaa:	d4a50513          	addi	a0,a0,-694 # ffffffffc02027f0 <etext+0x818>
ffffffffc0200aae:	e48ff06f          	j	ffffffffc02000f6 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc0200ab2:	1141                	addi	sp,sp,-16
ffffffffc0200ab4:	e406                	sd	ra,8(sp)
            /*(1)设置下次时钟中断- clock_set_next_event()
             *(2)计数器（ticks）加一
             *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
            * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            */
            clock_set_next_event();  // 设置下次时钟中断
ffffffffc0200ab6:	9c5ff0ef          	jal	ffffffffc020047a <clock_set_next_event>
            ticks++;                 // 计数器加一
ffffffffc0200aba:	00007797          	auipc	a5,0x7
ffffffffc0200abe:	98e78793          	addi	a5,a5,-1650 # ffffffffc0207448 <ticks>
ffffffffc0200ac2:	6398                	ld	a4,0(a5)
ffffffffc0200ac4:	0705                	addi	a4,a4,1
ffffffffc0200ac6:	e398                	sd	a4,0(a5)
            if (ticks % TICK_NUM == 0) {  // 每100次中断打印一次
ffffffffc0200ac8:	639c                	ld	a5,0(a5)
ffffffffc0200aca:	06400713          	li	a4,100
ffffffffc0200ace:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200ad2:	c38d                	beqz	a5,ffffffffc0200af4 <interrupt_handler+0x92>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200ad4:	60a2                	ld	ra,8(sp)
ffffffffc0200ad6:	0141                	addi	sp,sp,16
ffffffffc0200ad8:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200ada:	00002517          	auipc	a0,0x2
ffffffffc0200ade:	d3e50513          	addi	a0,a0,-706 # ffffffffc0202818 <etext+0x840>
ffffffffc0200ae2:	e14ff06f          	j	ffffffffc02000f6 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200ae6:	00002517          	auipc	a0,0x2
ffffffffc0200aea:	caa50513          	addi	a0,a0,-854 # ffffffffc0202790 <etext+0x7b8>
ffffffffc0200aee:	e08ff06f          	j	ffffffffc02000f6 <cprintf>
            print_trapframe(tf);
ffffffffc0200af2:	b739                	j	ffffffffc0200a00 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200af4:	06400593          	li	a1,100
ffffffffc0200af8:	00002517          	auipc	a0,0x2
ffffffffc0200afc:	d1050513          	addi	a0,a0,-752 # ffffffffc0202808 <etext+0x830>
ffffffffc0200b00:	df6ff0ef          	jal	ffffffffc02000f6 <cprintf>
                print_count++;
ffffffffc0200b04:	00007717          	auipc	a4,0x7
ffffffffc0200b08:	95c70713          	addi	a4,a4,-1700 # ffffffffc0207460 <print_count>
ffffffffc0200b0c:	431c                	lw	a5,0(a4)
                if (print_count >= 10) {  // 打印10次后关机
ffffffffc0200b0e:	46a5                	li	a3,9
                print_count++;
ffffffffc0200b10:	0017861b          	addiw	a2,a5,1
ffffffffc0200b14:	c310                	sw	a2,0(a4)
                if (print_count >= 10) {  // 打印10次后关机
ffffffffc0200b16:	fac6dfe3          	bge	a3,a2,ffffffffc0200ad4 <interrupt_handler+0x72>
}
ffffffffc0200b1a:	60a2                	ld	ra,8(sp)
ffffffffc0200b1c:	0141                	addi	sp,sp,16
                    sbi_shutdown();
ffffffffc0200b1e:	3e20106f          	j	ffffffffc0201f00 <sbi_shutdown>

ffffffffc0200b22 <exception_handler>:

void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
ffffffffc0200b22:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc0200b26:	1141                	addi	sp,sp,-16
ffffffffc0200b28:	e022                	sd	s0,0(sp)
ffffffffc0200b2a:	e406                	sd	ra,8(sp)
    switch (tf->cause) {
ffffffffc0200b2c:	470d                	li	a4,3
void exception_handler(struct trapframe *tf) {
ffffffffc0200b2e:	842a                	mv	s0,a0
    switch (tf->cause) {
ffffffffc0200b30:	04e78663          	beq	a5,a4,ffffffffc0200b7c <exception_handler+0x5a>
ffffffffc0200b34:	02f76c63          	bltu	a4,a5,ffffffffc0200b6c <exception_handler+0x4a>
ffffffffc0200b38:	4709                	li	a4,2
ffffffffc0200b3a:	02e79563          	bne	a5,a4,ffffffffc0200b64 <exception_handler+0x42>
             /* LAB3 CHALLENGE3   2311688 :  */
            /*(1)输出指令异常类型（ Illegal instruction）
             *(2)输出异常指令地址
             *(3)更新 tf->epc寄存器
            */
            cprintf("Exception type:Illegal instruction\n");
ffffffffc0200b3e:	00002517          	auipc	a0,0x2
ffffffffc0200b42:	cfa50513          	addi	a0,a0,-774 # ffffffffc0202838 <etext+0x860>
ffffffffc0200b46:	db0ff0ef          	jal	ffffffffc02000f6 <cprintf>
            cprintf("Illegal instruction caught at 0x%08x\n", tf->epc);
ffffffffc0200b4a:	10843583          	ld	a1,264(s0)
ffffffffc0200b4e:	00002517          	auipc	a0,0x2
ffffffffc0200b52:	d1250513          	addi	a0,a0,-750 # ffffffffc0202860 <etext+0x888>
ffffffffc0200b56:	da0ff0ef          	jal	ffffffffc02000f6 <cprintf>
            tf->epc += 4;  // 跳过异常指令（RISC-V指令长度为4字节）
ffffffffc0200b5a:	10843783          	ld	a5,264(s0)
ffffffffc0200b5e:	0791                	addi	a5,a5,4
ffffffffc0200b60:	10f43423          	sd	a5,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200b64:	60a2                	ld	ra,8(sp)
ffffffffc0200b66:	6402                	ld	s0,0(sp)
ffffffffc0200b68:	0141                	addi	sp,sp,16
ffffffffc0200b6a:	8082                	ret
    switch (tf->cause) {
ffffffffc0200b6c:	17f1                	addi	a5,a5,-4
ffffffffc0200b6e:	471d                	li	a4,7
ffffffffc0200b70:	fef77ae3          	bgeu	a4,a5,ffffffffc0200b64 <exception_handler+0x42>
}
ffffffffc0200b74:	6402                	ld	s0,0(sp)
ffffffffc0200b76:	60a2                	ld	ra,8(sp)
ffffffffc0200b78:	0141                	addi	sp,sp,16
            print_trapframe(tf);
ffffffffc0200b7a:	b559                	j	ffffffffc0200a00 <print_trapframe>
            cprintf("Exception type: breakpoint\n");
ffffffffc0200b7c:	00002517          	auipc	a0,0x2
ffffffffc0200b80:	d0c50513          	addi	a0,a0,-756 # ffffffffc0202888 <etext+0x8b0>
ffffffffc0200b84:	d72ff0ef          	jal	ffffffffc02000f6 <cprintf>
            cprintf("ebreak caught at 0x%08x\n", tf->epc);
ffffffffc0200b88:	10843583          	ld	a1,264(s0)
ffffffffc0200b8c:	00002517          	auipc	a0,0x2
ffffffffc0200b90:	d1c50513          	addi	a0,a0,-740 # ffffffffc02028a8 <etext+0x8d0>
ffffffffc0200b94:	d62ff0ef          	jal	ffffffffc02000f6 <cprintf>
            tf->epc += 2;  // 跳过断点指令
ffffffffc0200b98:	10843783          	ld	a5,264(s0)
}
ffffffffc0200b9c:	60a2                	ld	ra,8(sp)
            tf->epc += 2;  // 跳过断点指令
ffffffffc0200b9e:	0789                	addi	a5,a5,2
ffffffffc0200ba0:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200ba4:	6402                	ld	s0,0(sp)
ffffffffc0200ba6:	0141                	addi	sp,sp,16
ffffffffc0200ba8:	8082                	ret

ffffffffc0200baa <trap>:

static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200baa:	11853783          	ld	a5,280(a0)
ffffffffc0200bae:	0007c363          	bltz	a5,ffffffffc0200bb4 <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc0200bb2:	bf85                	j	ffffffffc0200b22 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200bb4:	b57d                	j	ffffffffc0200a62 <interrupt_handler>
	...

ffffffffc0200bb8 <__alltraps>:
    .endm

    .globl __alltraps
    .align(2)
__alltraps:
    SAVE_ALL
ffffffffc0200bb8:	14011073          	csrw	sscratch,sp
ffffffffc0200bbc:	712d                	addi	sp,sp,-288
ffffffffc0200bbe:	e002                	sd	zero,0(sp)
ffffffffc0200bc0:	e406                	sd	ra,8(sp)
ffffffffc0200bc2:	ec0e                	sd	gp,24(sp)
ffffffffc0200bc4:	f012                	sd	tp,32(sp)
ffffffffc0200bc6:	f416                	sd	t0,40(sp)
ffffffffc0200bc8:	f81a                	sd	t1,48(sp)
ffffffffc0200bca:	fc1e                	sd	t2,56(sp)
ffffffffc0200bcc:	e0a2                	sd	s0,64(sp)
ffffffffc0200bce:	e4a6                	sd	s1,72(sp)
ffffffffc0200bd0:	e8aa                	sd	a0,80(sp)
ffffffffc0200bd2:	ecae                	sd	a1,88(sp)
ffffffffc0200bd4:	f0b2                	sd	a2,96(sp)
ffffffffc0200bd6:	f4b6                	sd	a3,104(sp)
ffffffffc0200bd8:	f8ba                	sd	a4,112(sp)
ffffffffc0200bda:	fcbe                	sd	a5,120(sp)
ffffffffc0200bdc:	e142                	sd	a6,128(sp)
ffffffffc0200bde:	e546                	sd	a7,136(sp)
ffffffffc0200be0:	e94a                	sd	s2,144(sp)
ffffffffc0200be2:	ed4e                	sd	s3,152(sp)
ffffffffc0200be4:	f152                	sd	s4,160(sp)
ffffffffc0200be6:	f556                	sd	s5,168(sp)
ffffffffc0200be8:	f95a                	sd	s6,176(sp)
ffffffffc0200bea:	fd5e                	sd	s7,184(sp)
ffffffffc0200bec:	e1e2                	sd	s8,192(sp)
ffffffffc0200bee:	e5e6                	sd	s9,200(sp)
ffffffffc0200bf0:	e9ea                	sd	s10,208(sp)
ffffffffc0200bf2:	edee                	sd	s11,216(sp)
ffffffffc0200bf4:	f1f2                	sd	t3,224(sp)
ffffffffc0200bf6:	f5f6                	sd	t4,232(sp)
ffffffffc0200bf8:	f9fa                	sd	t5,240(sp)
ffffffffc0200bfa:	fdfe                	sd	t6,248(sp)
ffffffffc0200bfc:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200c00:	100024f3          	csrr	s1,sstatus
ffffffffc0200c04:	14102973          	csrr	s2,sepc
ffffffffc0200c08:	143029f3          	csrr	s3,stval
ffffffffc0200c0c:	14202a73          	csrr	s4,scause
ffffffffc0200c10:	e822                	sd	s0,16(sp)
ffffffffc0200c12:	e226                	sd	s1,256(sp)
ffffffffc0200c14:	e64a                	sd	s2,264(sp)
ffffffffc0200c16:	ea4e                	sd	s3,272(sp)
ffffffffc0200c18:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200c1a:	850a                	mv	a0,sp
    jal trap
ffffffffc0200c1c:	f8fff0ef          	jal	ffffffffc0200baa <trap>

ffffffffc0200c20 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200c20:	6492                	ld	s1,256(sp)
ffffffffc0200c22:	6932                	ld	s2,264(sp)
ffffffffc0200c24:	10049073          	csrw	sstatus,s1
ffffffffc0200c28:	14191073          	csrw	sepc,s2
ffffffffc0200c2c:	60a2                	ld	ra,8(sp)
ffffffffc0200c2e:	61e2                	ld	gp,24(sp)
ffffffffc0200c30:	7202                	ld	tp,32(sp)
ffffffffc0200c32:	72a2                	ld	t0,40(sp)
ffffffffc0200c34:	7342                	ld	t1,48(sp)
ffffffffc0200c36:	73e2                	ld	t2,56(sp)
ffffffffc0200c38:	6406                	ld	s0,64(sp)
ffffffffc0200c3a:	64a6                	ld	s1,72(sp)
ffffffffc0200c3c:	6546                	ld	a0,80(sp)
ffffffffc0200c3e:	65e6                	ld	a1,88(sp)
ffffffffc0200c40:	7606                	ld	a2,96(sp)
ffffffffc0200c42:	76a6                	ld	a3,104(sp)
ffffffffc0200c44:	7746                	ld	a4,112(sp)
ffffffffc0200c46:	77e6                	ld	a5,120(sp)
ffffffffc0200c48:	680a                	ld	a6,128(sp)
ffffffffc0200c4a:	68aa                	ld	a7,136(sp)
ffffffffc0200c4c:	694a                	ld	s2,144(sp)
ffffffffc0200c4e:	69ea                	ld	s3,152(sp)
ffffffffc0200c50:	7a0a                	ld	s4,160(sp)
ffffffffc0200c52:	7aaa                	ld	s5,168(sp)
ffffffffc0200c54:	7b4a                	ld	s6,176(sp)
ffffffffc0200c56:	7bea                	ld	s7,184(sp)
ffffffffc0200c58:	6c0e                	ld	s8,192(sp)
ffffffffc0200c5a:	6cae                	ld	s9,200(sp)
ffffffffc0200c5c:	6d4e                	ld	s10,208(sp)
ffffffffc0200c5e:	6dee                	ld	s11,216(sp)
ffffffffc0200c60:	7e0e                	ld	t3,224(sp)
ffffffffc0200c62:	7eae                	ld	t4,232(sp)
ffffffffc0200c64:	7f4e                	ld	t5,240(sp)
ffffffffc0200c66:	7fee                	ld	t6,248(sp)
ffffffffc0200c68:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200c6a:	10200073          	sret

ffffffffc0200c6e <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200c6e:	00006797          	auipc	a5,0x6
ffffffffc0200c72:	3ba78793          	addi	a5,a5,954 # ffffffffc0207028 <free_area>
ffffffffc0200c76:	e79c                	sd	a5,8(a5)
ffffffffc0200c78:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200c7a:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200c7e:	8082                	ret

ffffffffc0200c80 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200c80:	00006517          	auipc	a0,0x6
ffffffffc0200c84:	3b856503          	lwu	a0,952(a0) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200c88:	8082                	ret

ffffffffc0200c8a <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200c8a:	715d                	addi	sp,sp,-80
ffffffffc0200c8c:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200c8e:	00006417          	auipc	s0,0x6
ffffffffc0200c92:	39a40413          	addi	s0,s0,922 # ffffffffc0207028 <free_area>
ffffffffc0200c96:	641c                	ld	a5,8(s0)
ffffffffc0200c98:	e486                	sd	ra,72(sp)
ffffffffc0200c9a:	fc26                	sd	s1,56(sp)
ffffffffc0200c9c:	f84a                	sd	s2,48(sp)
ffffffffc0200c9e:	f44e                	sd	s3,40(sp)
ffffffffc0200ca0:	f052                	sd	s4,32(sp)
ffffffffc0200ca2:	ec56                	sd	s5,24(sp)
ffffffffc0200ca4:	e85a                	sd	s6,16(sp)
ffffffffc0200ca6:	e45e                	sd	s7,8(sp)
ffffffffc0200ca8:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200caa:	2e878063          	beq	a5,s0,ffffffffc0200f8a <default_check+0x300>
    int count = 0, total = 0;
ffffffffc0200cae:	4481                	li	s1,0
ffffffffc0200cb0:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200cb2:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200cb6:	8b09                	andi	a4,a4,2
ffffffffc0200cb8:	2c070d63          	beqz	a4,ffffffffc0200f92 <default_check+0x308>
        count ++, total += p->property;
ffffffffc0200cbc:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200cc0:	679c                	ld	a5,8(a5)
ffffffffc0200cc2:	2905                	addiw	s2,s2,1
ffffffffc0200cc4:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200cc6:	fe8796e3          	bne	a5,s0,ffffffffc0200cb2 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200cca:	89a6                	mv	s3,s1
ffffffffc0200ccc:	30b000ef          	jal	ffffffffc02017d6 <nr_free_pages>
ffffffffc0200cd0:	73351163          	bne	a0,s3,ffffffffc02013f2 <default_check+0x768>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200cd4:	4505                	li	a0,1
ffffffffc0200cd6:	283000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200cda:	8a2a                	mv	s4,a0
ffffffffc0200cdc:	44050b63          	beqz	a0,ffffffffc0201132 <default_check+0x4a8>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200ce0:	4505                	li	a0,1
ffffffffc0200ce2:	277000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200ce6:	89aa                	mv	s3,a0
ffffffffc0200ce8:	72050563          	beqz	a0,ffffffffc0201412 <default_check+0x788>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200cec:	4505                	li	a0,1
ffffffffc0200cee:	26b000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200cf2:	8aaa                	mv	s5,a0
ffffffffc0200cf4:	4a050f63          	beqz	a0,ffffffffc02011b2 <default_check+0x528>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200cf8:	2b3a0d63          	beq	s4,s3,ffffffffc0200fb2 <default_check+0x328>
ffffffffc0200cfc:	2aaa0b63          	beq	s4,a0,ffffffffc0200fb2 <default_check+0x328>
ffffffffc0200d00:	2aa98963          	beq	s3,a0,ffffffffc0200fb2 <default_check+0x328>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200d04:	000a2783          	lw	a5,0(s4)
ffffffffc0200d08:	2c079563          	bnez	a5,ffffffffc0200fd2 <default_check+0x348>
ffffffffc0200d0c:	0009a783          	lw	a5,0(s3)
ffffffffc0200d10:	2c079163          	bnez	a5,ffffffffc0200fd2 <default_check+0x348>
ffffffffc0200d14:	411c                	lw	a5,0(a0)
ffffffffc0200d16:	2a079e63          	bnez	a5,ffffffffc0200fd2 <default_check+0x348>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d1a:	fcccd7b7          	lui	a5,0xfcccd
ffffffffc0200d1e:	ccd78793          	addi	a5,a5,-819 # fffffffffccccccd <end+0x3cac582d>
ffffffffc0200d22:	07b2                	slli	a5,a5,0xc
ffffffffc0200d24:	ccd78793          	addi	a5,a5,-819
ffffffffc0200d28:	07b2                	slli	a5,a5,0xc
ffffffffc0200d2a:	00006717          	auipc	a4,0x6
ffffffffc0200d2e:	76673703          	ld	a4,1894(a4) # ffffffffc0207490 <pages>
ffffffffc0200d32:	ccd78793          	addi	a5,a5,-819
ffffffffc0200d36:	40ea06b3          	sub	a3,s4,a4
ffffffffc0200d3a:	07b2                	slli	a5,a5,0xc
ffffffffc0200d3c:	868d                	srai	a3,a3,0x3
ffffffffc0200d3e:	ccd78793          	addi	a5,a5,-819
ffffffffc0200d42:	02f686b3          	mul	a3,a3,a5
ffffffffc0200d46:	00002597          	auipc	a1,0x2
ffffffffc0200d4a:	3a25b583          	ld	a1,930(a1) # ffffffffc02030e8 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200d4e:	00006617          	auipc	a2,0x6
ffffffffc0200d52:	73a63603          	ld	a2,1850(a2) # ffffffffc0207488 <npage>
ffffffffc0200d56:	0632                	slli	a2,a2,0xc
ffffffffc0200d58:	96ae                	add	a3,a3,a1

static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d5a:	06b2                	slli	a3,a3,0xc
ffffffffc0200d5c:	28c6fb63          	bgeu	a3,a2,ffffffffc0200ff2 <default_check+0x368>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d60:	40e986b3          	sub	a3,s3,a4
ffffffffc0200d64:	868d                	srai	a3,a3,0x3
ffffffffc0200d66:	02f686b3          	mul	a3,a3,a5
ffffffffc0200d6a:	96ae                	add	a3,a3,a1
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d6c:	06b2                	slli	a3,a3,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200d6e:	4cc6f263          	bgeu	a3,a2,ffffffffc0201232 <default_check+0x5a8>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d72:	40e50733          	sub	a4,a0,a4
ffffffffc0200d76:	870d                	srai	a4,a4,0x3
ffffffffc0200d78:	02f707b3          	mul	a5,a4,a5
ffffffffc0200d7c:	97ae                	add	a5,a5,a1
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d7e:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200d80:	30c7f963          	bgeu	a5,a2,ffffffffc0201092 <default_check+0x408>
    assert(alloc_page() == NULL);
ffffffffc0200d84:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200d86:	00043c03          	ld	s8,0(s0)
ffffffffc0200d8a:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200d8e:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200d92:	e400                	sd	s0,8(s0)
ffffffffc0200d94:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200d96:	00006797          	auipc	a5,0x6
ffffffffc0200d9a:	2a07a123          	sw	zero,674(a5) # ffffffffc0207038 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200d9e:	1bb000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200da2:	2c051863          	bnez	a0,ffffffffc0201072 <default_check+0x3e8>
    free_page(p0);
ffffffffc0200da6:	4585                	li	a1,1
ffffffffc0200da8:	8552                	mv	a0,s4
ffffffffc0200daa:	1ed000ef          	jal	ffffffffc0201796 <free_pages>
    free_page(p1);
ffffffffc0200dae:	4585                	li	a1,1
ffffffffc0200db0:	854e                	mv	a0,s3
ffffffffc0200db2:	1e5000ef          	jal	ffffffffc0201796 <free_pages>
    free_page(p2);
ffffffffc0200db6:	4585                	li	a1,1
ffffffffc0200db8:	8556                	mv	a0,s5
ffffffffc0200dba:	1dd000ef          	jal	ffffffffc0201796 <free_pages>
    assert(nr_free == 3);
ffffffffc0200dbe:	4818                	lw	a4,16(s0)
ffffffffc0200dc0:	478d                	li	a5,3
ffffffffc0200dc2:	28f71863          	bne	a4,a5,ffffffffc0201052 <default_check+0x3c8>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200dc6:	4505                	li	a0,1
ffffffffc0200dc8:	191000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200dcc:	89aa                	mv	s3,a0
ffffffffc0200dce:	26050263          	beqz	a0,ffffffffc0201032 <default_check+0x3a8>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200dd2:	4505                	li	a0,1
ffffffffc0200dd4:	185000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200dd8:	8aaa                	mv	s5,a0
ffffffffc0200dda:	3a050c63          	beqz	a0,ffffffffc0201192 <default_check+0x508>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200dde:	4505                	li	a0,1
ffffffffc0200de0:	179000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200de4:	8a2a                	mv	s4,a0
ffffffffc0200de6:	38050663          	beqz	a0,ffffffffc0201172 <default_check+0x4e8>
    assert(alloc_page() == NULL);
ffffffffc0200dea:	4505                	li	a0,1
ffffffffc0200dec:	16d000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200df0:	36051163          	bnez	a0,ffffffffc0201152 <default_check+0x4c8>
    free_page(p0);
ffffffffc0200df4:	4585                	li	a1,1
ffffffffc0200df6:	854e                	mv	a0,s3
ffffffffc0200df8:	19f000ef          	jal	ffffffffc0201796 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200dfc:	641c                	ld	a5,8(s0)
ffffffffc0200dfe:	20878a63          	beq	a5,s0,ffffffffc0201012 <default_check+0x388>
    assert((p = alloc_page()) == p0);
ffffffffc0200e02:	4505                	li	a0,1
ffffffffc0200e04:	155000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200e08:	30a99563          	bne	s3,a0,ffffffffc0201112 <default_check+0x488>
    assert(alloc_page() == NULL);
ffffffffc0200e0c:	4505                	li	a0,1
ffffffffc0200e0e:	14b000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200e12:	2e051063          	bnez	a0,ffffffffc02010f2 <default_check+0x468>
    assert(nr_free == 0);
ffffffffc0200e16:	481c                	lw	a5,16(s0)
ffffffffc0200e18:	2a079d63          	bnez	a5,ffffffffc02010d2 <default_check+0x448>
    free_page(p);
ffffffffc0200e1c:	854e                	mv	a0,s3
ffffffffc0200e1e:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200e20:	01843023          	sd	s8,0(s0)
ffffffffc0200e24:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200e28:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200e2c:	16b000ef          	jal	ffffffffc0201796 <free_pages>
    free_page(p1);
ffffffffc0200e30:	4585                	li	a1,1
ffffffffc0200e32:	8556                	mv	a0,s5
ffffffffc0200e34:	163000ef          	jal	ffffffffc0201796 <free_pages>
    free_page(p2);
ffffffffc0200e38:	4585                	li	a1,1
ffffffffc0200e3a:	8552                	mv	a0,s4
ffffffffc0200e3c:	15b000ef          	jal	ffffffffc0201796 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200e40:	4515                	li	a0,5
ffffffffc0200e42:	117000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200e46:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200e48:	26050563          	beqz	a0,ffffffffc02010b2 <default_check+0x428>
ffffffffc0200e4c:	651c                	ld	a5,8(a0)
ffffffffc0200e4e:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200e50:	8b85                	andi	a5,a5,1
ffffffffc0200e52:	54079063          	bnez	a5,ffffffffc0201392 <default_check+0x708>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200e56:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200e58:	00043b03          	ld	s6,0(s0)
ffffffffc0200e5c:	00843a83          	ld	s5,8(s0)
ffffffffc0200e60:	e000                	sd	s0,0(s0)
ffffffffc0200e62:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200e64:	0f5000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200e68:	50051563          	bnez	a0,ffffffffc0201372 <default_check+0x6e8>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200e6c:	05098a13          	addi	s4,s3,80
ffffffffc0200e70:	8552                	mv	a0,s4
ffffffffc0200e72:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200e74:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0200e78:	00006797          	auipc	a5,0x6
ffffffffc0200e7c:	1c07a023          	sw	zero,448(a5) # ffffffffc0207038 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200e80:	117000ef          	jal	ffffffffc0201796 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200e84:	4511                	li	a0,4
ffffffffc0200e86:	0d3000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200e8a:	4c051463          	bnez	a0,ffffffffc0201352 <default_check+0x6c8>
ffffffffc0200e8e:	0589b783          	ld	a5,88(s3)
ffffffffc0200e92:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200e94:	8b85                	andi	a5,a5,1
ffffffffc0200e96:	48078e63          	beqz	a5,ffffffffc0201332 <default_check+0x6a8>
ffffffffc0200e9a:	0609a703          	lw	a4,96(s3)
ffffffffc0200e9e:	478d                	li	a5,3
ffffffffc0200ea0:	48f71963          	bne	a4,a5,ffffffffc0201332 <default_check+0x6a8>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200ea4:	450d                	li	a0,3
ffffffffc0200ea6:	0b3000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200eaa:	8c2a                	mv	s8,a0
ffffffffc0200eac:	46050363          	beqz	a0,ffffffffc0201312 <default_check+0x688>
    assert(alloc_page() == NULL);
ffffffffc0200eb0:	4505                	li	a0,1
ffffffffc0200eb2:	0a7000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200eb6:	42051e63          	bnez	a0,ffffffffc02012f2 <default_check+0x668>
    assert(p0 + 2 == p1);
ffffffffc0200eba:	418a1c63          	bne	s4,s8,ffffffffc02012d2 <default_check+0x648>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0200ebe:	4585                	li	a1,1
ffffffffc0200ec0:	854e                	mv	a0,s3
ffffffffc0200ec2:	0d5000ef          	jal	ffffffffc0201796 <free_pages>
    free_pages(p1, 3);
ffffffffc0200ec6:	458d                	li	a1,3
ffffffffc0200ec8:	8552                	mv	a0,s4
ffffffffc0200eca:	0cd000ef          	jal	ffffffffc0201796 <free_pages>
ffffffffc0200ece:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0200ed2:	02898c13          	addi	s8,s3,40
ffffffffc0200ed6:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0200ed8:	8b85                	andi	a5,a5,1
ffffffffc0200eda:	3c078c63          	beqz	a5,ffffffffc02012b2 <default_check+0x628>
ffffffffc0200ede:	0109a703          	lw	a4,16(s3)
ffffffffc0200ee2:	4785                	li	a5,1
ffffffffc0200ee4:	3cf71763          	bne	a4,a5,ffffffffc02012b2 <default_check+0x628>
ffffffffc0200ee8:	008a3783          	ld	a5,8(s4)
ffffffffc0200eec:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0200eee:	8b85                	andi	a5,a5,1
ffffffffc0200ef0:	3a078163          	beqz	a5,ffffffffc0201292 <default_check+0x608>
ffffffffc0200ef4:	010a2703          	lw	a4,16(s4)
ffffffffc0200ef8:	478d                	li	a5,3
ffffffffc0200efa:	38f71c63          	bne	a4,a5,ffffffffc0201292 <default_check+0x608>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0200efe:	4505                	li	a0,1
ffffffffc0200f00:	059000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200f04:	36a99763          	bne	s3,a0,ffffffffc0201272 <default_check+0x5e8>
    free_page(p0);
ffffffffc0200f08:	4585                	li	a1,1
ffffffffc0200f0a:	08d000ef          	jal	ffffffffc0201796 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0200f0e:	4509                	li	a0,2
ffffffffc0200f10:	049000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200f14:	32aa1f63          	bne	s4,a0,ffffffffc0201252 <default_check+0x5c8>

    free_pages(p0, 2);
ffffffffc0200f18:	4589                	li	a1,2
ffffffffc0200f1a:	07d000ef          	jal	ffffffffc0201796 <free_pages>
    free_page(p2);
ffffffffc0200f1e:	4585                	li	a1,1
ffffffffc0200f20:	8562                	mv	a0,s8
ffffffffc0200f22:	075000ef          	jal	ffffffffc0201796 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200f26:	4515                	li	a0,5
ffffffffc0200f28:	031000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200f2c:	89aa                	mv	s3,a0
ffffffffc0200f2e:	48050263          	beqz	a0,ffffffffc02013b2 <default_check+0x728>
    assert(alloc_page() == NULL);
ffffffffc0200f32:	4505                	li	a0,1
ffffffffc0200f34:	025000ef          	jal	ffffffffc0201758 <alloc_pages>
ffffffffc0200f38:	2c051d63          	bnez	a0,ffffffffc0201212 <default_check+0x588>

    assert(nr_free == 0);
ffffffffc0200f3c:	481c                	lw	a5,16(s0)
ffffffffc0200f3e:	2a079a63          	bnez	a5,ffffffffc02011f2 <default_check+0x568>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200f42:	4595                	li	a1,5
ffffffffc0200f44:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200f46:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0200f4a:	01643023          	sd	s6,0(s0)
ffffffffc0200f4e:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0200f52:	045000ef          	jal	ffffffffc0201796 <free_pages>
    return listelm->next;
ffffffffc0200f56:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200f58:	00878963          	beq	a5,s0,ffffffffc0200f6a <default_check+0x2e0>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200f5c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200f60:	679c                	ld	a5,8(a5)
ffffffffc0200f62:	397d                	addiw	s2,s2,-1
ffffffffc0200f64:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200f66:	fe879be3          	bne	a5,s0,ffffffffc0200f5c <default_check+0x2d2>
    }
    assert(count == 0);
ffffffffc0200f6a:	26091463          	bnez	s2,ffffffffc02011d2 <default_check+0x548>
    assert(total == 0);
ffffffffc0200f6e:	46049263          	bnez	s1,ffffffffc02013d2 <default_check+0x748>
}
ffffffffc0200f72:	60a6                	ld	ra,72(sp)
ffffffffc0200f74:	6406                	ld	s0,64(sp)
ffffffffc0200f76:	74e2                	ld	s1,56(sp)
ffffffffc0200f78:	7942                	ld	s2,48(sp)
ffffffffc0200f7a:	79a2                	ld	s3,40(sp)
ffffffffc0200f7c:	7a02                	ld	s4,32(sp)
ffffffffc0200f7e:	6ae2                	ld	s5,24(sp)
ffffffffc0200f80:	6b42                	ld	s6,16(sp)
ffffffffc0200f82:	6ba2                	ld	s7,8(sp)
ffffffffc0200f84:	6c02                	ld	s8,0(sp)
ffffffffc0200f86:	6161                	addi	sp,sp,80
ffffffffc0200f88:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200f8a:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200f8c:	4481                	li	s1,0
ffffffffc0200f8e:	4901                	li	s2,0
ffffffffc0200f90:	bb35                	j	ffffffffc0200ccc <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0200f92:	00002697          	auipc	a3,0x2
ffffffffc0200f96:	93668693          	addi	a3,a3,-1738 # ffffffffc02028c8 <etext+0x8f0>
ffffffffc0200f9a:	00002617          	auipc	a2,0x2
ffffffffc0200f9e:	93e60613          	addi	a2,a2,-1730 # ffffffffc02028d8 <etext+0x900>
ffffffffc0200fa2:	0f000593          	li	a1,240
ffffffffc0200fa6:	00002517          	auipc	a0,0x2
ffffffffc0200faa:	94a50513          	addi	a0,a0,-1718 # ffffffffc02028f0 <etext+0x918>
ffffffffc0200fae:	c3cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200fb2:	00002697          	auipc	a3,0x2
ffffffffc0200fb6:	9d668693          	addi	a3,a3,-1578 # ffffffffc0202988 <etext+0x9b0>
ffffffffc0200fba:	00002617          	auipc	a2,0x2
ffffffffc0200fbe:	91e60613          	addi	a2,a2,-1762 # ffffffffc02028d8 <etext+0x900>
ffffffffc0200fc2:	0bd00593          	li	a1,189
ffffffffc0200fc6:	00002517          	auipc	a0,0x2
ffffffffc0200fca:	92a50513          	addi	a0,a0,-1750 # ffffffffc02028f0 <etext+0x918>
ffffffffc0200fce:	c1cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200fd2:	00002697          	auipc	a3,0x2
ffffffffc0200fd6:	9de68693          	addi	a3,a3,-1570 # ffffffffc02029b0 <etext+0x9d8>
ffffffffc0200fda:	00002617          	auipc	a2,0x2
ffffffffc0200fde:	8fe60613          	addi	a2,a2,-1794 # ffffffffc02028d8 <etext+0x900>
ffffffffc0200fe2:	0be00593          	li	a1,190
ffffffffc0200fe6:	00002517          	auipc	a0,0x2
ffffffffc0200fea:	90a50513          	addi	a0,a0,-1782 # ffffffffc02028f0 <etext+0x918>
ffffffffc0200fee:	bfcff0ef          	jal	ffffffffc02003ea <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200ff2:	00002697          	auipc	a3,0x2
ffffffffc0200ff6:	9fe68693          	addi	a3,a3,-1538 # ffffffffc02029f0 <etext+0xa18>
ffffffffc0200ffa:	00002617          	auipc	a2,0x2
ffffffffc0200ffe:	8de60613          	addi	a2,a2,-1826 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201002:	0c000593          	li	a1,192
ffffffffc0201006:	00002517          	auipc	a0,0x2
ffffffffc020100a:	8ea50513          	addi	a0,a0,-1814 # ffffffffc02028f0 <etext+0x918>
ffffffffc020100e:	bdcff0ef          	jal	ffffffffc02003ea <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201012:	00002697          	auipc	a3,0x2
ffffffffc0201016:	a6668693          	addi	a3,a3,-1434 # ffffffffc0202a78 <etext+0xaa0>
ffffffffc020101a:	00002617          	auipc	a2,0x2
ffffffffc020101e:	8be60613          	addi	a2,a2,-1858 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201022:	0d900593          	li	a1,217
ffffffffc0201026:	00002517          	auipc	a0,0x2
ffffffffc020102a:	8ca50513          	addi	a0,a0,-1846 # ffffffffc02028f0 <etext+0x918>
ffffffffc020102e:	bbcff0ef          	jal	ffffffffc02003ea <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201032:	00002697          	auipc	a3,0x2
ffffffffc0201036:	8f668693          	addi	a3,a3,-1802 # ffffffffc0202928 <etext+0x950>
ffffffffc020103a:	00002617          	auipc	a2,0x2
ffffffffc020103e:	89e60613          	addi	a2,a2,-1890 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201042:	0d200593          	li	a1,210
ffffffffc0201046:	00002517          	auipc	a0,0x2
ffffffffc020104a:	8aa50513          	addi	a0,a0,-1878 # ffffffffc02028f0 <etext+0x918>
ffffffffc020104e:	b9cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(nr_free == 3);
ffffffffc0201052:	00002697          	auipc	a3,0x2
ffffffffc0201056:	a1668693          	addi	a3,a3,-1514 # ffffffffc0202a68 <etext+0xa90>
ffffffffc020105a:	00002617          	auipc	a2,0x2
ffffffffc020105e:	87e60613          	addi	a2,a2,-1922 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201062:	0d000593          	li	a1,208
ffffffffc0201066:	00002517          	auipc	a0,0x2
ffffffffc020106a:	88a50513          	addi	a0,a0,-1910 # ffffffffc02028f0 <etext+0x918>
ffffffffc020106e:	b7cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201072:	00002697          	auipc	a3,0x2
ffffffffc0201076:	9de68693          	addi	a3,a3,-1570 # ffffffffc0202a50 <etext+0xa78>
ffffffffc020107a:	00002617          	auipc	a2,0x2
ffffffffc020107e:	85e60613          	addi	a2,a2,-1954 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201082:	0cb00593          	li	a1,203
ffffffffc0201086:	00002517          	auipc	a0,0x2
ffffffffc020108a:	86a50513          	addi	a0,a0,-1942 # ffffffffc02028f0 <etext+0x918>
ffffffffc020108e:	b5cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201092:	00002697          	auipc	a3,0x2
ffffffffc0201096:	99e68693          	addi	a3,a3,-1634 # ffffffffc0202a30 <etext+0xa58>
ffffffffc020109a:	00002617          	auipc	a2,0x2
ffffffffc020109e:	83e60613          	addi	a2,a2,-1986 # ffffffffc02028d8 <etext+0x900>
ffffffffc02010a2:	0c200593          	li	a1,194
ffffffffc02010a6:	00002517          	auipc	a0,0x2
ffffffffc02010aa:	84a50513          	addi	a0,a0,-1974 # ffffffffc02028f0 <etext+0x918>
ffffffffc02010ae:	b3cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(p0 != NULL);
ffffffffc02010b2:	00002697          	auipc	a3,0x2
ffffffffc02010b6:	a0e68693          	addi	a3,a3,-1522 # ffffffffc0202ac0 <etext+0xae8>
ffffffffc02010ba:	00002617          	auipc	a2,0x2
ffffffffc02010be:	81e60613          	addi	a2,a2,-2018 # ffffffffc02028d8 <etext+0x900>
ffffffffc02010c2:	0f800593          	li	a1,248
ffffffffc02010c6:	00002517          	auipc	a0,0x2
ffffffffc02010ca:	82a50513          	addi	a0,a0,-2006 # ffffffffc02028f0 <etext+0x918>
ffffffffc02010ce:	b1cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(nr_free == 0);
ffffffffc02010d2:	00002697          	auipc	a3,0x2
ffffffffc02010d6:	9de68693          	addi	a3,a3,-1570 # ffffffffc0202ab0 <etext+0xad8>
ffffffffc02010da:	00001617          	auipc	a2,0x1
ffffffffc02010de:	7fe60613          	addi	a2,a2,2046 # ffffffffc02028d8 <etext+0x900>
ffffffffc02010e2:	0df00593          	li	a1,223
ffffffffc02010e6:	00002517          	auipc	a0,0x2
ffffffffc02010ea:	80a50513          	addi	a0,a0,-2038 # ffffffffc02028f0 <etext+0x918>
ffffffffc02010ee:	afcff0ef          	jal	ffffffffc02003ea <__panic>
    assert(alloc_page() == NULL);
ffffffffc02010f2:	00002697          	auipc	a3,0x2
ffffffffc02010f6:	95e68693          	addi	a3,a3,-1698 # ffffffffc0202a50 <etext+0xa78>
ffffffffc02010fa:	00001617          	auipc	a2,0x1
ffffffffc02010fe:	7de60613          	addi	a2,a2,2014 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201102:	0dd00593          	li	a1,221
ffffffffc0201106:	00001517          	auipc	a0,0x1
ffffffffc020110a:	7ea50513          	addi	a0,a0,2026 # ffffffffc02028f0 <etext+0x918>
ffffffffc020110e:	adcff0ef          	jal	ffffffffc02003ea <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201112:	00002697          	auipc	a3,0x2
ffffffffc0201116:	97e68693          	addi	a3,a3,-1666 # ffffffffc0202a90 <etext+0xab8>
ffffffffc020111a:	00001617          	auipc	a2,0x1
ffffffffc020111e:	7be60613          	addi	a2,a2,1982 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201122:	0dc00593          	li	a1,220
ffffffffc0201126:	00001517          	auipc	a0,0x1
ffffffffc020112a:	7ca50513          	addi	a0,a0,1994 # ffffffffc02028f0 <etext+0x918>
ffffffffc020112e:	abcff0ef          	jal	ffffffffc02003ea <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201132:	00001697          	auipc	a3,0x1
ffffffffc0201136:	7f668693          	addi	a3,a3,2038 # ffffffffc0202928 <etext+0x950>
ffffffffc020113a:	00001617          	auipc	a2,0x1
ffffffffc020113e:	79e60613          	addi	a2,a2,1950 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201142:	0b900593          	li	a1,185
ffffffffc0201146:	00001517          	auipc	a0,0x1
ffffffffc020114a:	7aa50513          	addi	a0,a0,1962 # ffffffffc02028f0 <etext+0x918>
ffffffffc020114e:	a9cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201152:	00002697          	auipc	a3,0x2
ffffffffc0201156:	8fe68693          	addi	a3,a3,-1794 # ffffffffc0202a50 <etext+0xa78>
ffffffffc020115a:	00001617          	auipc	a2,0x1
ffffffffc020115e:	77e60613          	addi	a2,a2,1918 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201162:	0d600593          	li	a1,214
ffffffffc0201166:	00001517          	auipc	a0,0x1
ffffffffc020116a:	78a50513          	addi	a0,a0,1930 # ffffffffc02028f0 <etext+0x918>
ffffffffc020116e:	a7cff0ef          	jal	ffffffffc02003ea <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201172:	00001697          	auipc	a3,0x1
ffffffffc0201176:	7f668693          	addi	a3,a3,2038 # ffffffffc0202968 <etext+0x990>
ffffffffc020117a:	00001617          	auipc	a2,0x1
ffffffffc020117e:	75e60613          	addi	a2,a2,1886 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201182:	0d400593          	li	a1,212
ffffffffc0201186:	00001517          	auipc	a0,0x1
ffffffffc020118a:	76a50513          	addi	a0,a0,1898 # ffffffffc02028f0 <etext+0x918>
ffffffffc020118e:	a5cff0ef          	jal	ffffffffc02003ea <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201192:	00001697          	auipc	a3,0x1
ffffffffc0201196:	7b668693          	addi	a3,a3,1974 # ffffffffc0202948 <etext+0x970>
ffffffffc020119a:	00001617          	auipc	a2,0x1
ffffffffc020119e:	73e60613          	addi	a2,a2,1854 # ffffffffc02028d8 <etext+0x900>
ffffffffc02011a2:	0d300593          	li	a1,211
ffffffffc02011a6:	00001517          	auipc	a0,0x1
ffffffffc02011aa:	74a50513          	addi	a0,a0,1866 # ffffffffc02028f0 <etext+0x918>
ffffffffc02011ae:	a3cff0ef          	jal	ffffffffc02003ea <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02011b2:	00001697          	auipc	a3,0x1
ffffffffc02011b6:	7b668693          	addi	a3,a3,1974 # ffffffffc0202968 <etext+0x990>
ffffffffc02011ba:	00001617          	auipc	a2,0x1
ffffffffc02011be:	71e60613          	addi	a2,a2,1822 # ffffffffc02028d8 <etext+0x900>
ffffffffc02011c2:	0bb00593          	li	a1,187
ffffffffc02011c6:	00001517          	auipc	a0,0x1
ffffffffc02011ca:	72a50513          	addi	a0,a0,1834 # ffffffffc02028f0 <etext+0x918>
ffffffffc02011ce:	a1cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(count == 0);
ffffffffc02011d2:	00002697          	auipc	a3,0x2
ffffffffc02011d6:	a3e68693          	addi	a3,a3,-1474 # ffffffffc0202c10 <etext+0xc38>
ffffffffc02011da:	00001617          	auipc	a2,0x1
ffffffffc02011de:	6fe60613          	addi	a2,a2,1790 # ffffffffc02028d8 <etext+0x900>
ffffffffc02011e2:	12500593          	li	a1,293
ffffffffc02011e6:	00001517          	auipc	a0,0x1
ffffffffc02011ea:	70a50513          	addi	a0,a0,1802 # ffffffffc02028f0 <etext+0x918>
ffffffffc02011ee:	9fcff0ef          	jal	ffffffffc02003ea <__panic>
    assert(nr_free == 0);
ffffffffc02011f2:	00002697          	auipc	a3,0x2
ffffffffc02011f6:	8be68693          	addi	a3,a3,-1858 # ffffffffc0202ab0 <etext+0xad8>
ffffffffc02011fa:	00001617          	auipc	a2,0x1
ffffffffc02011fe:	6de60613          	addi	a2,a2,1758 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201202:	11a00593          	li	a1,282
ffffffffc0201206:	00001517          	auipc	a0,0x1
ffffffffc020120a:	6ea50513          	addi	a0,a0,1770 # ffffffffc02028f0 <etext+0x918>
ffffffffc020120e:	9dcff0ef          	jal	ffffffffc02003ea <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201212:	00002697          	auipc	a3,0x2
ffffffffc0201216:	83e68693          	addi	a3,a3,-1986 # ffffffffc0202a50 <etext+0xa78>
ffffffffc020121a:	00001617          	auipc	a2,0x1
ffffffffc020121e:	6be60613          	addi	a2,a2,1726 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201222:	11800593          	li	a1,280
ffffffffc0201226:	00001517          	auipc	a0,0x1
ffffffffc020122a:	6ca50513          	addi	a0,a0,1738 # ffffffffc02028f0 <etext+0x918>
ffffffffc020122e:	9bcff0ef          	jal	ffffffffc02003ea <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201232:	00001697          	auipc	a3,0x1
ffffffffc0201236:	7de68693          	addi	a3,a3,2014 # ffffffffc0202a10 <etext+0xa38>
ffffffffc020123a:	00001617          	auipc	a2,0x1
ffffffffc020123e:	69e60613          	addi	a2,a2,1694 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201242:	0c100593          	li	a1,193
ffffffffc0201246:	00001517          	auipc	a0,0x1
ffffffffc020124a:	6aa50513          	addi	a0,a0,1706 # ffffffffc02028f0 <etext+0x918>
ffffffffc020124e:	99cff0ef          	jal	ffffffffc02003ea <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201252:	00002697          	auipc	a3,0x2
ffffffffc0201256:	97e68693          	addi	a3,a3,-1666 # ffffffffc0202bd0 <etext+0xbf8>
ffffffffc020125a:	00001617          	auipc	a2,0x1
ffffffffc020125e:	67e60613          	addi	a2,a2,1662 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201262:	11200593          	li	a1,274
ffffffffc0201266:	00001517          	auipc	a0,0x1
ffffffffc020126a:	68a50513          	addi	a0,a0,1674 # ffffffffc02028f0 <etext+0x918>
ffffffffc020126e:	97cff0ef          	jal	ffffffffc02003ea <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201272:	00002697          	auipc	a3,0x2
ffffffffc0201276:	93e68693          	addi	a3,a3,-1730 # ffffffffc0202bb0 <etext+0xbd8>
ffffffffc020127a:	00001617          	auipc	a2,0x1
ffffffffc020127e:	65e60613          	addi	a2,a2,1630 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201282:	11000593          	li	a1,272
ffffffffc0201286:	00001517          	auipc	a0,0x1
ffffffffc020128a:	66a50513          	addi	a0,a0,1642 # ffffffffc02028f0 <etext+0x918>
ffffffffc020128e:	95cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201292:	00002697          	auipc	a3,0x2
ffffffffc0201296:	8f668693          	addi	a3,a3,-1802 # ffffffffc0202b88 <etext+0xbb0>
ffffffffc020129a:	00001617          	auipc	a2,0x1
ffffffffc020129e:	63e60613          	addi	a2,a2,1598 # ffffffffc02028d8 <etext+0x900>
ffffffffc02012a2:	10e00593          	li	a1,270
ffffffffc02012a6:	00001517          	auipc	a0,0x1
ffffffffc02012aa:	64a50513          	addi	a0,a0,1610 # ffffffffc02028f0 <etext+0x918>
ffffffffc02012ae:	93cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02012b2:	00002697          	auipc	a3,0x2
ffffffffc02012b6:	8ae68693          	addi	a3,a3,-1874 # ffffffffc0202b60 <etext+0xb88>
ffffffffc02012ba:	00001617          	auipc	a2,0x1
ffffffffc02012be:	61e60613          	addi	a2,a2,1566 # ffffffffc02028d8 <etext+0x900>
ffffffffc02012c2:	10d00593          	li	a1,269
ffffffffc02012c6:	00001517          	auipc	a0,0x1
ffffffffc02012ca:	62a50513          	addi	a0,a0,1578 # ffffffffc02028f0 <etext+0x918>
ffffffffc02012ce:	91cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(p0 + 2 == p1);
ffffffffc02012d2:	00002697          	auipc	a3,0x2
ffffffffc02012d6:	87e68693          	addi	a3,a3,-1922 # ffffffffc0202b50 <etext+0xb78>
ffffffffc02012da:	00001617          	auipc	a2,0x1
ffffffffc02012de:	5fe60613          	addi	a2,a2,1534 # ffffffffc02028d8 <etext+0x900>
ffffffffc02012e2:	10800593          	li	a1,264
ffffffffc02012e6:	00001517          	auipc	a0,0x1
ffffffffc02012ea:	60a50513          	addi	a0,a0,1546 # ffffffffc02028f0 <etext+0x918>
ffffffffc02012ee:	8fcff0ef          	jal	ffffffffc02003ea <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012f2:	00001697          	auipc	a3,0x1
ffffffffc02012f6:	75e68693          	addi	a3,a3,1886 # ffffffffc0202a50 <etext+0xa78>
ffffffffc02012fa:	00001617          	auipc	a2,0x1
ffffffffc02012fe:	5de60613          	addi	a2,a2,1502 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201302:	10700593          	li	a1,263
ffffffffc0201306:	00001517          	auipc	a0,0x1
ffffffffc020130a:	5ea50513          	addi	a0,a0,1514 # ffffffffc02028f0 <etext+0x918>
ffffffffc020130e:	8dcff0ef          	jal	ffffffffc02003ea <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201312:	00002697          	auipc	a3,0x2
ffffffffc0201316:	81e68693          	addi	a3,a3,-2018 # ffffffffc0202b30 <etext+0xb58>
ffffffffc020131a:	00001617          	auipc	a2,0x1
ffffffffc020131e:	5be60613          	addi	a2,a2,1470 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201322:	10600593          	li	a1,262
ffffffffc0201326:	00001517          	auipc	a0,0x1
ffffffffc020132a:	5ca50513          	addi	a0,a0,1482 # ffffffffc02028f0 <etext+0x918>
ffffffffc020132e:	8bcff0ef          	jal	ffffffffc02003ea <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201332:	00001697          	auipc	a3,0x1
ffffffffc0201336:	7ce68693          	addi	a3,a3,1998 # ffffffffc0202b00 <etext+0xb28>
ffffffffc020133a:	00001617          	auipc	a2,0x1
ffffffffc020133e:	59e60613          	addi	a2,a2,1438 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201342:	10500593          	li	a1,261
ffffffffc0201346:	00001517          	auipc	a0,0x1
ffffffffc020134a:	5aa50513          	addi	a0,a0,1450 # ffffffffc02028f0 <etext+0x918>
ffffffffc020134e:	89cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201352:	00001697          	auipc	a3,0x1
ffffffffc0201356:	79668693          	addi	a3,a3,1942 # ffffffffc0202ae8 <etext+0xb10>
ffffffffc020135a:	00001617          	auipc	a2,0x1
ffffffffc020135e:	57e60613          	addi	a2,a2,1406 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201362:	10400593          	li	a1,260
ffffffffc0201366:	00001517          	auipc	a0,0x1
ffffffffc020136a:	58a50513          	addi	a0,a0,1418 # ffffffffc02028f0 <etext+0x918>
ffffffffc020136e:	87cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201372:	00001697          	auipc	a3,0x1
ffffffffc0201376:	6de68693          	addi	a3,a3,1758 # ffffffffc0202a50 <etext+0xa78>
ffffffffc020137a:	00001617          	auipc	a2,0x1
ffffffffc020137e:	55e60613          	addi	a2,a2,1374 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201382:	0fe00593          	li	a1,254
ffffffffc0201386:	00001517          	auipc	a0,0x1
ffffffffc020138a:	56a50513          	addi	a0,a0,1386 # ffffffffc02028f0 <etext+0x918>
ffffffffc020138e:	85cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(!PageProperty(p0));
ffffffffc0201392:	00001697          	auipc	a3,0x1
ffffffffc0201396:	73e68693          	addi	a3,a3,1854 # ffffffffc0202ad0 <etext+0xaf8>
ffffffffc020139a:	00001617          	auipc	a2,0x1
ffffffffc020139e:	53e60613          	addi	a2,a2,1342 # ffffffffc02028d8 <etext+0x900>
ffffffffc02013a2:	0f900593          	li	a1,249
ffffffffc02013a6:	00001517          	auipc	a0,0x1
ffffffffc02013aa:	54a50513          	addi	a0,a0,1354 # ffffffffc02028f0 <etext+0x918>
ffffffffc02013ae:	83cff0ef          	jal	ffffffffc02003ea <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02013b2:	00002697          	auipc	a3,0x2
ffffffffc02013b6:	83e68693          	addi	a3,a3,-1986 # ffffffffc0202bf0 <etext+0xc18>
ffffffffc02013ba:	00001617          	auipc	a2,0x1
ffffffffc02013be:	51e60613          	addi	a2,a2,1310 # ffffffffc02028d8 <etext+0x900>
ffffffffc02013c2:	11700593          	li	a1,279
ffffffffc02013c6:	00001517          	auipc	a0,0x1
ffffffffc02013ca:	52a50513          	addi	a0,a0,1322 # ffffffffc02028f0 <etext+0x918>
ffffffffc02013ce:	81cff0ef          	jal	ffffffffc02003ea <__panic>
    assert(total == 0);
ffffffffc02013d2:	00002697          	auipc	a3,0x2
ffffffffc02013d6:	84e68693          	addi	a3,a3,-1970 # ffffffffc0202c20 <etext+0xc48>
ffffffffc02013da:	00001617          	auipc	a2,0x1
ffffffffc02013de:	4fe60613          	addi	a2,a2,1278 # ffffffffc02028d8 <etext+0x900>
ffffffffc02013e2:	12600593          	li	a1,294
ffffffffc02013e6:	00001517          	auipc	a0,0x1
ffffffffc02013ea:	50a50513          	addi	a0,a0,1290 # ffffffffc02028f0 <etext+0x918>
ffffffffc02013ee:	ffdfe0ef          	jal	ffffffffc02003ea <__panic>
    assert(total == nr_free_pages());
ffffffffc02013f2:	00001697          	auipc	a3,0x1
ffffffffc02013f6:	51668693          	addi	a3,a3,1302 # ffffffffc0202908 <etext+0x930>
ffffffffc02013fa:	00001617          	auipc	a2,0x1
ffffffffc02013fe:	4de60613          	addi	a2,a2,1246 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201402:	0f300593          	li	a1,243
ffffffffc0201406:	00001517          	auipc	a0,0x1
ffffffffc020140a:	4ea50513          	addi	a0,a0,1258 # ffffffffc02028f0 <etext+0x918>
ffffffffc020140e:	fddfe0ef          	jal	ffffffffc02003ea <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201412:	00001697          	auipc	a3,0x1
ffffffffc0201416:	53668693          	addi	a3,a3,1334 # ffffffffc0202948 <etext+0x970>
ffffffffc020141a:	00001617          	auipc	a2,0x1
ffffffffc020141e:	4be60613          	addi	a2,a2,1214 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201422:	0ba00593          	li	a1,186
ffffffffc0201426:	00001517          	auipc	a0,0x1
ffffffffc020142a:	4ca50513          	addi	a0,a0,1226 # ffffffffc02028f0 <etext+0x918>
ffffffffc020142e:	fbdfe0ef          	jal	ffffffffc02003ea <__panic>

ffffffffc0201432 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc0201432:	1141                	addi	sp,sp,-16
ffffffffc0201434:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201436:	14058a63          	beqz	a1,ffffffffc020158a <default_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc020143a:	00259713          	slli	a4,a1,0x2
ffffffffc020143e:	972e                	add	a4,a4,a1
ffffffffc0201440:	070e                	slli	a4,a4,0x3
ffffffffc0201442:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201446:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0201448:	c30d                	beqz	a4,ffffffffc020146a <default_free_pages+0x38>
ffffffffc020144a:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020144c:	8b05                	andi	a4,a4,1
ffffffffc020144e:	10071e63          	bnez	a4,ffffffffc020156a <default_free_pages+0x138>
ffffffffc0201452:	6798                	ld	a4,8(a5)
ffffffffc0201454:	8b09                	andi	a4,a4,2
ffffffffc0201456:	10071a63          	bnez	a4,ffffffffc020156a <default_free_pages+0x138>
        p->flags = 0;
ffffffffc020145a:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc020145e:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201462:	02878793          	addi	a5,a5,40
ffffffffc0201466:	fed792e3          	bne	a5,a3,ffffffffc020144a <default_free_pages+0x18>
    base->property = n;
ffffffffc020146a:	2581                	sext.w	a1,a1
ffffffffc020146c:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc020146e:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201472:	4789                	li	a5,2
ffffffffc0201474:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201478:	00006697          	auipc	a3,0x6
ffffffffc020147c:	bb068693          	addi	a3,a3,-1104 # ffffffffc0207028 <free_area>
ffffffffc0201480:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201482:	669c                	ld	a5,8(a3)
ffffffffc0201484:	9f2d                	addw	a4,a4,a1
ffffffffc0201486:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201488:	0ad78563          	beq	a5,a3,ffffffffc0201532 <default_free_pages+0x100>
            struct Page* page = le2page(le, page_link);
ffffffffc020148c:	fe878713          	addi	a4,a5,-24
ffffffffc0201490:	4581                	li	a1,0
ffffffffc0201492:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0201496:	00e56a63          	bltu	a0,a4,ffffffffc02014aa <default_free_pages+0x78>
    return listelm->next;
ffffffffc020149a:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020149c:	06d70263          	beq	a4,a3,ffffffffc0201500 <default_free_pages+0xce>
    struct Page *p = base;
ffffffffc02014a0:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02014a2:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02014a6:	fee57ae3          	bgeu	a0,a4,ffffffffc020149a <default_free_pages+0x68>
ffffffffc02014aa:	c199                	beqz	a1,ffffffffc02014b0 <default_free_pages+0x7e>
ffffffffc02014ac:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02014b0:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02014b2:	e390                	sd	a2,0(a5)
ffffffffc02014b4:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02014b6:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02014b8:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc02014ba:	02d70063          	beq	a4,a3,ffffffffc02014da <default_free_pages+0xa8>
        if (p + p->property == base) {
ffffffffc02014be:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc02014c2:	fe870593          	addi	a1,a4,-24
        if (p + p->property == base) {
ffffffffc02014c6:	02081613          	slli	a2,a6,0x20
ffffffffc02014ca:	9201                	srli	a2,a2,0x20
ffffffffc02014cc:	00261793          	slli	a5,a2,0x2
ffffffffc02014d0:	97b2                	add	a5,a5,a2
ffffffffc02014d2:	078e                	slli	a5,a5,0x3
ffffffffc02014d4:	97ae                	add	a5,a5,a1
ffffffffc02014d6:	02f50f63          	beq	a0,a5,ffffffffc0201514 <default_free_pages+0xe2>
    return listelm->next;
ffffffffc02014da:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc02014dc:	00d70f63          	beq	a4,a3,ffffffffc02014fa <default_free_pages+0xc8>
        if (base + base->property == p) {
ffffffffc02014e0:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc02014e2:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc02014e6:	02059613          	slli	a2,a1,0x20
ffffffffc02014ea:	9201                	srli	a2,a2,0x20
ffffffffc02014ec:	00261793          	slli	a5,a2,0x2
ffffffffc02014f0:	97b2                	add	a5,a5,a2
ffffffffc02014f2:	078e                	slli	a5,a5,0x3
ffffffffc02014f4:	97aa                	add	a5,a5,a0
ffffffffc02014f6:	04f68a63          	beq	a3,a5,ffffffffc020154a <default_free_pages+0x118>
}
ffffffffc02014fa:	60a2                	ld	ra,8(sp)
ffffffffc02014fc:	0141                	addi	sp,sp,16
ffffffffc02014fe:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201500:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201502:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201504:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201506:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201508:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc020150a:	02d70d63          	beq	a4,a3,ffffffffc0201544 <default_free_pages+0x112>
ffffffffc020150e:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0201510:	87ba                	mv	a5,a4
ffffffffc0201512:	bf41                	j	ffffffffc02014a2 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0201514:	491c                	lw	a5,16(a0)
ffffffffc0201516:	010787bb          	addw	a5,a5,a6
ffffffffc020151a:	fef72c23          	sw	a5,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020151e:	57f5                	li	a5,-3
ffffffffc0201520:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201524:	6d10                	ld	a2,24(a0)
ffffffffc0201526:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc0201528:	852e                	mv	a0,a1
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc020152a:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc020152c:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc020152e:	e390                	sd	a2,0(a5)
ffffffffc0201530:	b775                	j	ffffffffc02014dc <default_free_pages+0xaa>
}
ffffffffc0201532:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201534:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0201538:	e398                	sd	a4,0(a5)
ffffffffc020153a:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc020153c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020153e:	ed1c                	sd	a5,24(a0)
}
ffffffffc0201540:	0141                	addi	sp,sp,16
ffffffffc0201542:	8082                	ret
ffffffffc0201544:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc0201546:	873e                	mv	a4,a5
ffffffffc0201548:	bf8d                	j	ffffffffc02014ba <default_free_pages+0x88>
            base->property += p->property;
ffffffffc020154a:	ff872783          	lw	a5,-8(a4)
ffffffffc020154e:	ff070693          	addi	a3,a4,-16
ffffffffc0201552:	9fad                	addw	a5,a5,a1
ffffffffc0201554:	c91c                	sw	a5,16(a0)
ffffffffc0201556:	57f5                	li	a5,-3
ffffffffc0201558:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020155c:	6314                	ld	a3,0(a4)
ffffffffc020155e:	671c                	ld	a5,8(a4)
}
ffffffffc0201560:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201562:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc0201564:	e394                	sd	a3,0(a5)
ffffffffc0201566:	0141                	addi	sp,sp,16
ffffffffc0201568:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020156a:	00001697          	auipc	a3,0x1
ffffffffc020156e:	6ce68693          	addi	a3,a3,1742 # ffffffffc0202c38 <etext+0xc60>
ffffffffc0201572:	00001617          	auipc	a2,0x1
ffffffffc0201576:	36660613          	addi	a2,a2,870 # ffffffffc02028d8 <etext+0x900>
ffffffffc020157a:	08300593          	li	a1,131
ffffffffc020157e:	00001517          	auipc	a0,0x1
ffffffffc0201582:	37250513          	addi	a0,a0,882 # ffffffffc02028f0 <etext+0x918>
ffffffffc0201586:	e65fe0ef          	jal	ffffffffc02003ea <__panic>
    assert(n > 0);
ffffffffc020158a:	00001697          	auipc	a3,0x1
ffffffffc020158e:	6a668693          	addi	a3,a3,1702 # ffffffffc0202c30 <etext+0xc58>
ffffffffc0201592:	00001617          	auipc	a2,0x1
ffffffffc0201596:	34660613          	addi	a2,a2,838 # ffffffffc02028d8 <etext+0x900>
ffffffffc020159a:	08000593          	li	a1,128
ffffffffc020159e:	00001517          	auipc	a0,0x1
ffffffffc02015a2:	35250513          	addi	a0,a0,850 # ffffffffc02028f0 <etext+0x918>
ffffffffc02015a6:	e45fe0ef          	jal	ffffffffc02003ea <__panic>

ffffffffc02015aa <default_alloc_pages>:
    assert(n > 0);
ffffffffc02015aa:	c959                	beqz	a0,ffffffffc0201640 <default_alloc_pages+0x96>
    if (n > nr_free) {
ffffffffc02015ac:	00006617          	auipc	a2,0x6
ffffffffc02015b0:	a7c60613          	addi	a2,a2,-1412 # ffffffffc0207028 <free_area>
ffffffffc02015b4:	4a0c                	lw	a1,16(a2)
ffffffffc02015b6:	86aa                	mv	a3,a0
ffffffffc02015b8:	02059793          	slli	a5,a1,0x20
ffffffffc02015bc:	9381                	srli	a5,a5,0x20
ffffffffc02015be:	00a7eb63          	bltu	a5,a0,ffffffffc02015d4 <default_alloc_pages+0x2a>
    list_entry_t *le = &free_list;
ffffffffc02015c2:	87b2                	mv	a5,a2
ffffffffc02015c4:	a029                	j	ffffffffc02015ce <default_alloc_pages+0x24>
        if (p->property >= n) {
ffffffffc02015c6:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02015ca:	00d77763          	bgeu	a4,a3,ffffffffc02015d8 <default_alloc_pages+0x2e>
    return listelm->next;
ffffffffc02015ce:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02015d0:	fec79be3          	bne	a5,a2,ffffffffc02015c6 <default_alloc_pages+0x1c>
        return NULL;
ffffffffc02015d4:	4501                	li	a0,0
}
ffffffffc02015d6:	8082                	ret
    __list_del(listelm->prev, listelm->next);
ffffffffc02015d8:	6798                	ld	a4,8(a5)
    return listelm->prev;
ffffffffc02015da:	0007b803          	ld	a6,0(a5)
        if (page->property > n) {
ffffffffc02015de:	ff87a883          	lw	a7,-8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc02015e2:	fe878513          	addi	a0,a5,-24
    prev->next = next;
ffffffffc02015e6:	00e83423          	sd	a4,8(a6)
    next->prev = prev;
ffffffffc02015ea:	01073023          	sd	a6,0(a4)
        if (page->property > n) {
ffffffffc02015ee:	02089713          	slli	a4,a7,0x20
ffffffffc02015f2:	9301                	srli	a4,a4,0x20
            p->property = page->property - n;
ffffffffc02015f4:	0006831b          	sext.w	t1,a3
        if (page->property > n) {
ffffffffc02015f8:	02e6fc63          	bgeu	a3,a4,ffffffffc0201630 <default_alloc_pages+0x86>
            struct Page *p = page + n;
ffffffffc02015fc:	00269713          	slli	a4,a3,0x2
ffffffffc0201600:	9736                	add	a4,a4,a3
ffffffffc0201602:	070e                	slli	a4,a4,0x3
ffffffffc0201604:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201606:	406888bb          	subw	a7,a7,t1
ffffffffc020160a:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020160e:	4689                	li	a3,2
ffffffffc0201610:	00870593          	addi	a1,a4,8
ffffffffc0201614:	40d5b02f          	amoor.d	zero,a3,(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201618:	00883683          	ld	a3,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc020161c:	01870893          	addi	a7,a4,24
        nr_free -= n;
ffffffffc0201620:	4a0c                	lw	a1,16(a2)
    prev->next = next->prev = elm;
ffffffffc0201622:	0116b023          	sd	a7,0(a3)
ffffffffc0201626:	01183423          	sd	a7,8(a6)
    elm->next = next;
ffffffffc020162a:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc020162c:	01073c23          	sd	a6,24(a4)
ffffffffc0201630:	406585bb          	subw	a1,a1,t1
ffffffffc0201634:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201636:	5775                	li	a4,-3
ffffffffc0201638:	17c1                	addi	a5,a5,-16
ffffffffc020163a:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc020163e:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc0201640:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201642:	00001697          	auipc	a3,0x1
ffffffffc0201646:	5ee68693          	addi	a3,a3,1518 # ffffffffc0202c30 <etext+0xc58>
ffffffffc020164a:	00001617          	auipc	a2,0x1
ffffffffc020164e:	28e60613          	addi	a2,a2,654 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201652:	06200593          	li	a1,98
ffffffffc0201656:	00001517          	auipc	a0,0x1
ffffffffc020165a:	29a50513          	addi	a0,a0,666 # ffffffffc02028f0 <etext+0x918>
default_alloc_pages(size_t n) {
ffffffffc020165e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201660:	d8bfe0ef          	jal	ffffffffc02003ea <__panic>

ffffffffc0201664 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0201664:	1141                	addi	sp,sp,-16
ffffffffc0201666:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201668:	c9e1                	beqz	a1,ffffffffc0201738 <default_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc020166a:	00259713          	slli	a4,a1,0x2
ffffffffc020166e:	972e                	add	a4,a4,a1
ffffffffc0201670:	070e                	slli	a4,a4,0x3
ffffffffc0201672:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201676:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0201678:	cf11                	beqz	a4,ffffffffc0201694 <default_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020167a:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc020167c:	8b05                	andi	a4,a4,1
ffffffffc020167e:	cf49                	beqz	a4,ffffffffc0201718 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc0201680:	0007a823          	sw	zero,16(a5)
ffffffffc0201684:	0007b423          	sd	zero,8(a5)
ffffffffc0201688:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc020168c:	02878793          	addi	a5,a5,40
ffffffffc0201690:	fed795e3          	bne	a5,a3,ffffffffc020167a <default_init_memmap+0x16>
    base->property = n;
ffffffffc0201694:	2581                	sext.w	a1,a1
ffffffffc0201696:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201698:	4789                	li	a5,2
ffffffffc020169a:	00850713          	addi	a4,a0,8
ffffffffc020169e:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02016a2:	00006697          	auipc	a3,0x6
ffffffffc02016a6:	98668693          	addi	a3,a3,-1658 # ffffffffc0207028 <free_area>
ffffffffc02016aa:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02016ac:	669c                	ld	a5,8(a3)
ffffffffc02016ae:	9f2d                	addw	a4,a4,a1
ffffffffc02016b0:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02016b2:	04d78663          	beq	a5,a3,ffffffffc02016fe <default_init_memmap+0x9a>
            struct Page* page = le2page(le, page_link);
ffffffffc02016b6:	fe878713          	addi	a4,a5,-24
ffffffffc02016ba:	4581                	li	a1,0
ffffffffc02016bc:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc02016c0:	00e56a63          	bltu	a0,a4,ffffffffc02016d4 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc02016c4:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02016c6:	02d70263          	beq	a4,a3,ffffffffc02016ea <default_init_memmap+0x86>
    struct Page *p = base;
ffffffffc02016ca:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02016cc:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02016d0:	fee57ae3          	bgeu	a0,a4,ffffffffc02016c4 <default_init_memmap+0x60>
ffffffffc02016d4:	c199                	beqz	a1,ffffffffc02016da <default_init_memmap+0x76>
ffffffffc02016d6:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02016da:	6398                	ld	a4,0(a5)
}
ffffffffc02016dc:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02016de:	e390                	sd	a2,0(a5)
ffffffffc02016e0:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02016e2:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02016e4:	ed18                	sd	a4,24(a0)
ffffffffc02016e6:	0141                	addi	sp,sp,16
ffffffffc02016e8:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02016ea:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02016ec:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02016ee:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02016f0:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02016f2:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc02016f4:	00d70e63          	beq	a4,a3,ffffffffc0201710 <default_init_memmap+0xac>
ffffffffc02016f8:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc02016fa:	87ba                	mv	a5,a4
ffffffffc02016fc:	bfc1                	j	ffffffffc02016cc <default_init_memmap+0x68>
}
ffffffffc02016fe:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201700:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0201704:	e398                	sd	a4,0(a5)
ffffffffc0201706:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc0201708:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020170a:	ed1c                	sd	a5,24(a0)
}
ffffffffc020170c:	0141                	addi	sp,sp,16
ffffffffc020170e:	8082                	ret
ffffffffc0201710:	60a2                	ld	ra,8(sp)
ffffffffc0201712:	e290                	sd	a2,0(a3)
ffffffffc0201714:	0141                	addi	sp,sp,16
ffffffffc0201716:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201718:	00001697          	auipc	a3,0x1
ffffffffc020171c:	54868693          	addi	a3,a3,1352 # ffffffffc0202c60 <etext+0xc88>
ffffffffc0201720:	00001617          	auipc	a2,0x1
ffffffffc0201724:	1b860613          	addi	a2,a2,440 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201728:	04900593          	li	a1,73
ffffffffc020172c:	00001517          	auipc	a0,0x1
ffffffffc0201730:	1c450513          	addi	a0,a0,452 # ffffffffc02028f0 <etext+0x918>
ffffffffc0201734:	cb7fe0ef          	jal	ffffffffc02003ea <__panic>
    assert(n > 0);
ffffffffc0201738:	00001697          	auipc	a3,0x1
ffffffffc020173c:	4f868693          	addi	a3,a3,1272 # ffffffffc0202c30 <etext+0xc58>
ffffffffc0201740:	00001617          	auipc	a2,0x1
ffffffffc0201744:	19860613          	addi	a2,a2,408 # ffffffffc02028d8 <etext+0x900>
ffffffffc0201748:	04600593          	li	a1,70
ffffffffc020174c:	00001517          	auipc	a0,0x1
ffffffffc0201750:	1a450513          	addi	a0,a0,420 # ffffffffc02028f0 <etext+0x918>
ffffffffc0201754:	c97fe0ef          	jal	ffffffffc02003ea <__panic>

ffffffffc0201758 <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201758:	100027f3          	csrr	a5,sstatus
ffffffffc020175c:	8b89                	andi	a5,a5,2
ffffffffc020175e:	e799                	bnez	a5,ffffffffc020176c <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201760:	00006797          	auipc	a5,0x6
ffffffffc0201764:	d087b783          	ld	a5,-760(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc0201768:	6f9c                	ld	a5,24(a5)
ffffffffc020176a:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc020176c:	1141                	addi	sp,sp,-16
ffffffffc020176e:	e406                	sd	ra,8(sp)
ffffffffc0201770:	e022                	sd	s0,0(sp)
ffffffffc0201772:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201774:	8a6ff0ef          	jal	ffffffffc020081a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201778:	00006797          	auipc	a5,0x6
ffffffffc020177c:	cf07b783          	ld	a5,-784(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc0201780:	6f9c                	ld	a5,24(a5)
ffffffffc0201782:	8522                	mv	a0,s0
ffffffffc0201784:	9782                	jalr	a5
ffffffffc0201786:	842a                	mv	s0,a0
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc0201788:	88cff0ef          	jal	ffffffffc0200814 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc020178c:	60a2                	ld	ra,8(sp)
ffffffffc020178e:	8522                	mv	a0,s0
ffffffffc0201790:	6402                	ld	s0,0(sp)
ffffffffc0201792:	0141                	addi	sp,sp,16
ffffffffc0201794:	8082                	ret

ffffffffc0201796 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201796:	100027f3          	csrr	a5,sstatus
ffffffffc020179a:	8b89                	andi	a5,a5,2
ffffffffc020179c:	e799                	bnez	a5,ffffffffc02017aa <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc020179e:	00006797          	auipc	a5,0x6
ffffffffc02017a2:	cca7b783          	ld	a5,-822(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc02017a6:	739c                	ld	a5,32(a5)
ffffffffc02017a8:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc02017aa:	1101                	addi	sp,sp,-32
ffffffffc02017ac:	ec06                	sd	ra,24(sp)
ffffffffc02017ae:	e822                	sd	s0,16(sp)
ffffffffc02017b0:	e426                	sd	s1,8(sp)
ffffffffc02017b2:	842a                	mv	s0,a0
ffffffffc02017b4:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc02017b6:	864ff0ef          	jal	ffffffffc020081a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02017ba:	00006797          	auipc	a5,0x6
ffffffffc02017be:	cae7b783          	ld	a5,-850(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc02017c2:	739c                	ld	a5,32(a5)
ffffffffc02017c4:	85a6                	mv	a1,s1
ffffffffc02017c6:	8522                	mv	a0,s0
ffffffffc02017c8:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc02017ca:	6442                	ld	s0,16(sp)
ffffffffc02017cc:	60e2                	ld	ra,24(sp)
ffffffffc02017ce:	64a2                	ld	s1,8(sp)
ffffffffc02017d0:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02017d2:	842ff06f          	j	ffffffffc0200814 <intr_enable>

ffffffffc02017d6 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02017d6:	100027f3          	csrr	a5,sstatus
ffffffffc02017da:	8b89                	andi	a5,a5,2
ffffffffc02017dc:	e799                	bnez	a5,ffffffffc02017ea <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc02017de:	00006797          	auipc	a5,0x6
ffffffffc02017e2:	c8a7b783          	ld	a5,-886(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc02017e6:	779c                	ld	a5,40(a5)
ffffffffc02017e8:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc02017ea:	1141                	addi	sp,sp,-16
ffffffffc02017ec:	e406                	sd	ra,8(sp)
ffffffffc02017ee:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc02017f0:	82aff0ef          	jal	ffffffffc020081a <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02017f4:	00006797          	auipc	a5,0x6
ffffffffc02017f8:	c747b783          	ld	a5,-908(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc02017fc:	779c                	ld	a5,40(a5)
ffffffffc02017fe:	9782                	jalr	a5
ffffffffc0201800:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201802:	812ff0ef          	jal	ffffffffc0200814 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201806:	60a2                	ld	ra,8(sp)
ffffffffc0201808:	8522                	mv	a0,s0
ffffffffc020180a:	6402                	ld	s0,0(sp)
ffffffffc020180c:	0141                	addi	sp,sp,16
ffffffffc020180e:	8082                	ret

ffffffffc0201810 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0201810:	00001797          	auipc	a5,0x1
ffffffffc0201814:	71078793          	addi	a5,a5,1808 # ffffffffc0202f20 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201818:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc020181a:	7179                	addi	sp,sp,-48
ffffffffc020181c:	f406                	sd	ra,40(sp)
ffffffffc020181e:	f022                	sd	s0,32(sp)
ffffffffc0201820:	ec26                	sd	s1,24(sp)
ffffffffc0201822:	e052                	sd	s4,0(sp)
ffffffffc0201824:	e84a                	sd	s2,16(sp)
ffffffffc0201826:	e44e                	sd	s3,8(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0201828:	00006417          	auipc	s0,0x6
ffffffffc020182c:	c4040413          	addi	s0,s0,-960 # ffffffffc0207468 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201830:	00001517          	auipc	a0,0x1
ffffffffc0201834:	45850513          	addi	a0,a0,1112 # ffffffffc0202c88 <etext+0xcb0>
    pmm_manager = &default_pmm_manager;
ffffffffc0201838:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020183a:	8bdfe0ef          	jal	ffffffffc02000f6 <cprintf>
    pmm_manager->init();
ffffffffc020183e:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0201840:	00006497          	auipc	s1,0x6
ffffffffc0201844:	c4048493          	addi	s1,s1,-960 # ffffffffc0207480 <va_pa_offset>
    pmm_manager->init();
ffffffffc0201848:	679c                	ld	a5,8(a5)
ffffffffc020184a:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020184c:	57f5                	li	a5,-3
ffffffffc020184e:	07fa                	slli	a5,a5,0x1e
ffffffffc0201850:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc0201852:	faffe0ef          	jal	ffffffffc0200800 <get_memory_base>
ffffffffc0201856:	8a2a                	mv	s4,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0201858:	fb3fe0ef          	jal	ffffffffc020080a <get_memory_size>
    if (mem_size == 0) {
ffffffffc020185c:	18050363          	beqz	a0,ffffffffc02019e2 <pmm_init+0x1d2>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0201860:	89aa                	mv	s3,a0
    cprintf("physcial memory map:\n");
ffffffffc0201862:	00001517          	auipc	a0,0x1
ffffffffc0201866:	46e50513          	addi	a0,a0,1134 # ffffffffc0202cd0 <etext+0xcf8>
ffffffffc020186a:	88dfe0ef          	jal	ffffffffc02000f6 <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc020186e:	013a0933          	add	s2,s4,s3
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0201872:	fff90693          	addi	a3,s2,-1
ffffffffc0201876:	8652                	mv	a2,s4
ffffffffc0201878:	85ce                	mv	a1,s3
ffffffffc020187a:	00001517          	auipc	a0,0x1
ffffffffc020187e:	46e50513          	addi	a0,a0,1134 # ffffffffc0202ce8 <etext+0xd10>
ffffffffc0201882:	875fe0ef          	jal	ffffffffc02000f6 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc0201886:	c8000737          	lui	a4,0xc8000
ffffffffc020188a:	87ca                	mv	a5,s2
ffffffffc020188c:	0f276863          	bltu	a4,s2,ffffffffc020197c <pmm_init+0x16c>
ffffffffc0201890:	00007697          	auipc	a3,0x7
ffffffffc0201894:	c0f68693          	addi	a3,a3,-1009 # ffffffffc020849f <end+0xfff>
ffffffffc0201898:	777d                	lui	a4,0xfffff
ffffffffc020189a:	8ef9                	and	a3,a3,a4
    npage = maxpa / PGSIZE;
ffffffffc020189c:	83b1                	srli	a5,a5,0xc
ffffffffc020189e:	00006817          	auipc	a6,0x6
ffffffffc02018a2:	bea80813          	addi	a6,a6,-1046 # ffffffffc0207488 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02018a6:	00006597          	auipc	a1,0x6
ffffffffc02018aa:	bea58593          	addi	a1,a1,-1046 # ffffffffc0207490 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02018ae:	00f83023          	sd	a5,0(a6)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02018b2:	e194                	sd	a3,0(a1)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02018b4:	00080637          	lui	a2,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02018b8:	88b6                	mv	a7,a3
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02018ba:	04c78463          	beq	a5,a2,ffffffffc0201902 <pmm_init+0xf2>
ffffffffc02018be:	4785                	li	a5,1
ffffffffc02018c0:	00868713          	addi	a4,a3,8
ffffffffc02018c4:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc02018c8:	00083783          	ld	a5,0(a6)
ffffffffc02018cc:	4705                	li	a4,1
ffffffffc02018ce:	02800693          	li	a3,40
ffffffffc02018d2:	40c78633          	sub	a2,a5,a2
ffffffffc02018d6:	4885                	li	a7,1
ffffffffc02018d8:	fff80537          	lui	a0,0xfff80
ffffffffc02018dc:	02c77063          	bgeu	a4,a2,ffffffffc02018fc <pmm_init+0xec>
        SetPageReserved(pages + i);
ffffffffc02018e0:	619c                	ld	a5,0(a1)
ffffffffc02018e2:	97b6                	add	a5,a5,a3
ffffffffc02018e4:	07a1                	addi	a5,a5,8
ffffffffc02018e6:	4117b02f          	amoor.d	zero,a7,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02018ea:	00083783          	ld	a5,0(a6)
ffffffffc02018ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0x3fdf7b61>
ffffffffc02018f0:	02868693          	addi	a3,a3,40
ffffffffc02018f4:	00a78633          	add	a2,a5,a0
ffffffffc02018f8:	fec764e3          	bltu	a4,a2,ffffffffc02018e0 <pmm_init+0xd0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02018fc:	0005b883          	ld	a7,0(a1)
ffffffffc0201900:	86c6                	mv	a3,a7
ffffffffc0201902:	00279713          	slli	a4,a5,0x2
ffffffffc0201906:	973e                	add	a4,a4,a5
ffffffffc0201908:	fec00637          	lui	a2,0xfec00
ffffffffc020190c:	070e                	slli	a4,a4,0x3
ffffffffc020190e:	96b2                	add	a3,a3,a2
ffffffffc0201910:	96ba                	add	a3,a3,a4
ffffffffc0201912:	c0200737          	lui	a4,0xc0200
ffffffffc0201916:	0ae6ea63          	bltu	a3,a4,ffffffffc02019ca <pmm_init+0x1ba>
ffffffffc020191a:	6090                	ld	a2,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020191c:	777d                	lui	a4,0xfffff
ffffffffc020191e:	00e97933          	and	s2,s2,a4
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201922:	8e91                	sub	a3,a3,a2
    if (freemem < mem_end) {
ffffffffc0201924:	0526ef63          	bltu	a3,s2,ffffffffc0201982 <pmm_init+0x172>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0201928:	601c                	ld	a5,0(s0)
ffffffffc020192a:	7b9c                	ld	a5,48(a5)
ffffffffc020192c:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc020192e:	00001517          	auipc	a0,0x1
ffffffffc0201932:	44250513          	addi	a0,a0,1090 # ffffffffc0202d70 <etext+0xd98>
ffffffffc0201936:	fc0fe0ef          	jal	ffffffffc02000f6 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc020193a:	00004597          	auipc	a1,0x4
ffffffffc020193e:	6c658593          	addi	a1,a1,1734 # ffffffffc0206000 <boot_page_table_sv39>
ffffffffc0201942:	00006797          	auipc	a5,0x6
ffffffffc0201946:	b2b7bb23          	sd	a1,-1226(a5) # ffffffffc0207478 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc020194a:	c02007b7          	lui	a5,0xc0200
ffffffffc020194e:	0af5e663          	bltu	a1,a5,ffffffffc02019fa <pmm_init+0x1ea>
ffffffffc0201952:	609c                	ld	a5,0(s1)
}
ffffffffc0201954:	7402                	ld	s0,32(sp)
ffffffffc0201956:	70a2                	ld	ra,40(sp)
ffffffffc0201958:	64e2                	ld	s1,24(sp)
ffffffffc020195a:	6942                	ld	s2,16(sp)
ffffffffc020195c:	69a2                	ld	s3,8(sp)
ffffffffc020195e:	6a02                	ld	s4,0(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0201960:	40f586b3          	sub	a3,a1,a5
ffffffffc0201964:	00006797          	auipc	a5,0x6
ffffffffc0201968:	b0d7b623          	sd	a3,-1268(a5) # ffffffffc0207470 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc020196c:	00001517          	auipc	a0,0x1
ffffffffc0201970:	42450513          	addi	a0,a0,1060 # ffffffffc0202d90 <etext+0xdb8>
ffffffffc0201974:	8636                	mv	a2,a3
}
ffffffffc0201976:	6145                	addi	sp,sp,48
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201978:	f7efe06f          	j	ffffffffc02000f6 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc020197c:	c80007b7          	lui	a5,0xc8000
ffffffffc0201980:	bf01                	j	ffffffffc0201890 <pmm_init+0x80>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0201982:	6605                	lui	a2,0x1
ffffffffc0201984:	167d                	addi	a2,a2,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc0201986:	96b2                	add	a3,a3,a2
ffffffffc0201988:	8ef9                	and	a3,a3,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc020198a:	00c6d713          	srli	a4,a3,0xc
ffffffffc020198e:	02f77263          	bgeu	a4,a5,ffffffffc02019b2 <pmm_init+0x1a2>
    pmm_manager->init_memmap(base, n);
ffffffffc0201992:	6010                	ld	a2,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0201994:	fff807b7          	lui	a5,0xfff80
ffffffffc0201998:	97ba                	add	a5,a5,a4
ffffffffc020199a:	00279513          	slli	a0,a5,0x2
ffffffffc020199e:	953e                	add	a0,a0,a5
ffffffffc02019a0:	6a1c                	ld	a5,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02019a2:	40d90933          	sub	s2,s2,a3
ffffffffc02019a6:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc02019a8:	00c95593          	srli	a1,s2,0xc
ffffffffc02019ac:	9546                	add	a0,a0,a7
ffffffffc02019ae:	9782                	jalr	a5
}
ffffffffc02019b0:	bfa5                	j	ffffffffc0201928 <pmm_init+0x118>
        panic("pa2page called with invalid pa");
ffffffffc02019b2:	00001617          	auipc	a2,0x1
ffffffffc02019b6:	38e60613          	addi	a2,a2,910 # ffffffffc0202d40 <etext+0xd68>
ffffffffc02019ba:	06b00593          	li	a1,107
ffffffffc02019be:	00001517          	auipc	a0,0x1
ffffffffc02019c2:	3a250513          	addi	a0,a0,930 # ffffffffc0202d60 <etext+0xd88>
ffffffffc02019c6:	a25fe0ef          	jal	ffffffffc02003ea <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02019ca:	00001617          	auipc	a2,0x1
ffffffffc02019ce:	34e60613          	addi	a2,a2,846 # ffffffffc0202d18 <etext+0xd40>
ffffffffc02019d2:	07100593          	li	a1,113
ffffffffc02019d6:	00001517          	auipc	a0,0x1
ffffffffc02019da:	2ea50513          	addi	a0,a0,746 # ffffffffc0202cc0 <etext+0xce8>
ffffffffc02019de:	a0dfe0ef          	jal	ffffffffc02003ea <__panic>
        panic("DTB memory info not available");
ffffffffc02019e2:	00001617          	auipc	a2,0x1
ffffffffc02019e6:	2be60613          	addi	a2,a2,702 # ffffffffc0202ca0 <etext+0xcc8>
ffffffffc02019ea:	05a00593          	li	a1,90
ffffffffc02019ee:	00001517          	auipc	a0,0x1
ffffffffc02019f2:	2d250513          	addi	a0,a0,722 # ffffffffc0202cc0 <etext+0xce8>
ffffffffc02019f6:	9f5fe0ef          	jal	ffffffffc02003ea <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc02019fa:	86ae                	mv	a3,a1
ffffffffc02019fc:	00001617          	auipc	a2,0x1
ffffffffc0201a00:	31c60613          	addi	a2,a2,796 # ffffffffc0202d18 <etext+0xd40>
ffffffffc0201a04:	08c00593          	li	a1,140
ffffffffc0201a08:	00001517          	auipc	a0,0x1
ffffffffc0201a0c:	2b850513          	addi	a0,a0,696 # ffffffffc0202cc0 <etext+0xce8>
ffffffffc0201a10:	9dbfe0ef          	jal	ffffffffc02003ea <__panic>

ffffffffc0201a14 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0201a14:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201a18:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0201a1a:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201a1e:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201a20:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201a24:	f022                	sd	s0,32(sp)
ffffffffc0201a26:	ec26                	sd	s1,24(sp)
ffffffffc0201a28:	e84a                	sd	s2,16(sp)
ffffffffc0201a2a:	f406                	sd	ra,40(sp)
ffffffffc0201a2c:	84aa                	mv	s1,a0
ffffffffc0201a2e:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0201a30:	fff7041b          	addiw	s0,a4,-1 # ffffffffffffefff <end+0x3fdf7b5f>
    unsigned mod = do_div(result, base);
ffffffffc0201a34:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0201a36:	05067063          	bgeu	a2,a6,ffffffffc0201a76 <printnum+0x62>
ffffffffc0201a3a:	e44e                	sd	s3,8(sp)
ffffffffc0201a3c:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0201a3e:	4785                	li	a5,1
ffffffffc0201a40:	00e7d763          	bge	a5,a4,ffffffffc0201a4e <printnum+0x3a>
            putch(padc, putdat);
ffffffffc0201a44:	85ca                	mv	a1,s2
ffffffffc0201a46:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc0201a48:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201a4a:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201a4c:	fc65                	bnez	s0,ffffffffc0201a44 <printnum+0x30>
ffffffffc0201a4e:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a50:	1a02                	slli	s4,s4,0x20
ffffffffc0201a52:	020a5a13          	srli	s4,s4,0x20
ffffffffc0201a56:	00001797          	auipc	a5,0x1
ffffffffc0201a5a:	37a78793          	addi	a5,a5,890 # ffffffffc0202dd0 <etext+0xdf8>
ffffffffc0201a5e:	97d2                	add	a5,a5,s4
}
ffffffffc0201a60:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a62:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0201a66:	70a2                	ld	ra,40(sp)
ffffffffc0201a68:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a6a:	85ca                	mv	a1,s2
ffffffffc0201a6c:	87a6                	mv	a5,s1
}
ffffffffc0201a6e:	6942                	ld	s2,16(sp)
ffffffffc0201a70:	64e2                	ld	s1,24(sp)
ffffffffc0201a72:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201a74:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201a76:	03065633          	divu	a2,a2,a6
ffffffffc0201a7a:	8722                	mv	a4,s0
ffffffffc0201a7c:	f99ff0ef          	jal	ffffffffc0201a14 <printnum>
ffffffffc0201a80:	bfc1                	j	ffffffffc0201a50 <printnum+0x3c>

ffffffffc0201a82 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201a82:	7119                	addi	sp,sp,-128
ffffffffc0201a84:	f4a6                	sd	s1,104(sp)
ffffffffc0201a86:	f0ca                	sd	s2,96(sp)
ffffffffc0201a88:	ecce                	sd	s3,88(sp)
ffffffffc0201a8a:	e8d2                	sd	s4,80(sp)
ffffffffc0201a8c:	e4d6                	sd	s5,72(sp)
ffffffffc0201a8e:	e0da                	sd	s6,64(sp)
ffffffffc0201a90:	f862                	sd	s8,48(sp)
ffffffffc0201a92:	fc86                	sd	ra,120(sp)
ffffffffc0201a94:	f8a2                	sd	s0,112(sp)
ffffffffc0201a96:	fc5e                	sd	s7,56(sp)
ffffffffc0201a98:	f466                	sd	s9,40(sp)
ffffffffc0201a9a:	f06a                	sd	s10,32(sp)
ffffffffc0201a9c:	ec6e                	sd	s11,24(sp)
ffffffffc0201a9e:	892a                	mv	s2,a0
ffffffffc0201aa0:	84ae                	mv	s1,a1
ffffffffc0201aa2:	8c32                	mv	s8,a2
ffffffffc0201aa4:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201aa6:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201aaa:	05500b13          	li	s6,85
ffffffffc0201aae:	00001a97          	auipc	s5,0x1
ffffffffc0201ab2:	4aaa8a93          	addi	s5,s5,1194 # ffffffffc0202f58 <default_pmm_manager+0x38>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201ab6:	000c4503          	lbu	a0,0(s8)
ffffffffc0201aba:	001c0413          	addi	s0,s8,1
ffffffffc0201abe:	01350a63          	beq	a0,s3,ffffffffc0201ad2 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0201ac2:	cd0d                	beqz	a0,ffffffffc0201afc <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0201ac4:	85a6                	mv	a1,s1
ffffffffc0201ac6:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201ac8:	00044503          	lbu	a0,0(s0)
ffffffffc0201acc:	0405                	addi	s0,s0,1
ffffffffc0201ace:	ff351ae3          	bne	a0,s3,ffffffffc0201ac2 <vprintfmt+0x40>
        char padc = ' ';
ffffffffc0201ad2:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0201ad6:	4b81                	li	s7,0
ffffffffc0201ad8:	4601                	li	a2,0
        width = precision = -1;
ffffffffc0201ada:	5d7d                	li	s10,-1
ffffffffc0201adc:	5cfd                	li	s9,-1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ade:	00044683          	lbu	a3,0(s0)
ffffffffc0201ae2:	00140c13          	addi	s8,s0,1
ffffffffc0201ae6:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0201aea:	0ff5f593          	zext.b	a1,a1
ffffffffc0201aee:	02bb6663          	bltu	s6,a1,ffffffffc0201b1a <vprintfmt+0x98>
ffffffffc0201af2:	058a                	slli	a1,a1,0x2
ffffffffc0201af4:	95d6                	add	a1,a1,s5
ffffffffc0201af6:	4198                	lw	a4,0(a1)
ffffffffc0201af8:	9756                	add	a4,a4,s5
ffffffffc0201afa:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0201afc:	70e6                	ld	ra,120(sp)
ffffffffc0201afe:	7446                	ld	s0,112(sp)
ffffffffc0201b00:	74a6                	ld	s1,104(sp)
ffffffffc0201b02:	7906                	ld	s2,96(sp)
ffffffffc0201b04:	69e6                	ld	s3,88(sp)
ffffffffc0201b06:	6a46                	ld	s4,80(sp)
ffffffffc0201b08:	6aa6                	ld	s5,72(sp)
ffffffffc0201b0a:	6b06                	ld	s6,64(sp)
ffffffffc0201b0c:	7be2                	ld	s7,56(sp)
ffffffffc0201b0e:	7c42                	ld	s8,48(sp)
ffffffffc0201b10:	7ca2                	ld	s9,40(sp)
ffffffffc0201b12:	7d02                	ld	s10,32(sp)
ffffffffc0201b14:	6de2                	ld	s11,24(sp)
ffffffffc0201b16:	6109                	addi	sp,sp,128
ffffffffc0201b18:	8082                	ret
            putch('%', putdat);
ffffffffc0201b1a:	85a6                	mv	a1,s1
ffffffffc0201b1c:	02500513          	li	a0,37
ffffffffc0201b20:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201b22:	fff44703          	lbu	a4,-1(s0)
ffffffffc0201b26:	02500793          	li	a5,37
ffffffffc0201b2a:	8c22                	mv	s8,s0
ffffffffc0201b2c:	f8f705e3          	beq	a4,a5,ffffffffc0201ab6 <vprintfmt+0x34>
ffffffffc0201b30:	02500713          	li	a4,37
ffffffffc0201b34:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0201b38:	1c7d                	addi	s8,s8,-1
ffffffffc0201b3a:	fee79de3          	bne	a5,a4,ffffffffc0201b34 <vprintfmt+0xb2>
ffffffffc0201b3e:	bfa5                	j	ffffffffc0201ab6 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0201b40:	00144783          	lbu	a5,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0201b44:	4725                	li	a4,9
                precision = precision * 10 + ch - '0';
ffffffffc0201b46:	fd068d1b          	addiw	s10,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0201b4a:	fd07859b          	addiw	a1,a5,-48
                ch = *fmt;
ffffffffc0201b4e:	0007869b          	sext.w	a3,a5
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b52:	8462                	mv	s0,s8
                if (ch < '0' || ch > '9') {
ffffffffc0201b54:	02b76563          	bltu	a4,a1,ffffffffc0201b7e <vprintfmt+0xfc>
ffffffffc0201b58:	4525                	li	a0,9
                ch = *fmt;
ffffffffc0201b5a:	00144783          	lbu	a5,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201b5e:	002d171b          	slliw	a4,s10,0x2
ffffffffc0201b62:	01a7073b          	addw	a4,a4,s10
ffffffffc0201b66:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201b6a:	9f35                	addw	a4,a4,a3
                if (ch < '0' || ch > '9') {
ffffffffc0201b6c:	fd07859b          	addiw	a1,a5,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201b70:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201b72:	fd070d1b          	addiw	s10,a4,-48
                ch = *fmt;
ffffffffc0201b76:	0007869b          	sext.w	a3,a5
                if (ch < '0' || ch > '9') {
ffffffffc0201b7a:	feb570e3          	bgeu	a0,a1,ffffffffc0201b5a <vprintfmt+0xd8>
            if (width < 0)
ffffffffc0201b7e:	f60cd0e3          	bgez	s9,ffffffffc0201ade <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0201b82:	8cea                	mv	s9,s10
ffffffffc0201b84:	5d7d                	li	s10,-1
ffffffffc0201b86:	bfa1                	j	ffffffffc0201ade <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b88:	8db6                	mv	s11,a3
ffffffffc0201b8a:	8462                	mv	s0,s8
ffffffffc0201b8c:	bf89                	j	ffffffffc0201ade <vprintfmt+0x5c>
ffffffffc0201b8e:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0201b90:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0201b92:	b7b1                	j	ffffffffc0201ade <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0201b94:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0201b96:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc0201b9a:	00c7c463          	blt	a5,a2,ffffffffc0201ba2 <vprintfmt+0x120>
    else if (lflag) {
ffffffffc0201b9e:	1a060163          	beqz	a2,ffffffffc0201d40 <vprintfmt+0x2be>
        return va_arg(*ap, unsigned long);
ffffffffc0201ba2:	000a3603          	ld	a2,0(s4)
ffffffffc0201ba6:	46c1                	li	a3,16
ffffffffc0201ba8:	8a3a                	mv	s4,a4
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201baa:	000d879b          	sext.w	a5,s11
ffffffffc0201bae:	8766                	mv	a4,s9
ffffffffc0201bb0:	85a6                	mv	a1,s1
ffffffffc0201bb2:	854a                	mv	a0,s2
ffffffffc0201bb4:	e61ff0ef          	jal	ffffffffc0201a14 <printnum>
            break;
ffffffffc0201bb8:	bdfd                	j	ffffffffc0201ab6 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0201bba:	000a2503          	lw	a0,0(s4)
ffffffffc0201bbe:	85a6                	mv	a1,s1
ffffffffc0201bc0:	0a21                	addi	s4,s4,8
ffffffffc0201bc2:	9902                	jalr	s2
            break;
ffffffffc0201bc4:	bdcd                	j	ffffffffc0201ab6 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0201bc6:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0201bc8:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc0201bcc:	00c7c463          	blt	a5,a2,ffffffffc0201bd4 <vprintfmt+0x152>
    else if (lflag) {
ffffffffc0201bd0:	16060363          	beqz	a2,ffffffffc0201d36 <vprintfmt+0x2b4>
        return va_arg(*ap, unsigned long);
ffffffffc0201bd4:	000a3603          	ld	a2,0(s4)
ffffffffc0201bd8:	46a9                	li	a3,10
ffffffffc0201bda:	8a3a                	mv	s4,a4
ffffffffc0201bdc:	b7f9                	j	ffffffffc0201baa <vprintfmt+0x128>
            putch('0', putdat);
ffffffffc0201bde:	85a6                	mv	a1,s1
ffffffffc0201be0:	03000513          	li	a0,48
ffffffffc0201be4:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0201be6:	85a6                	mv	a1,s1
ffffffffc0201be8:	07800513          	li	a0,120
ffffffffc0201bec:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201bee:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0201bf2:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201bf4:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201bf6:	bf55                	j	ffffffffc0201baa <vprintfmt+0x128>
            putch(ch, putdat);
ffffffffc0201bf8:	85a6                	mv	a1,s1
ffffffffc0201bfa:	02500513          	li	a0,37
ffffffffc0201bfe:	9902                	jalr	s2
            break;
ffffffffc0201c00:	bd5d                	j	ffffffffc0201ab6 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0201c02:	000a2d03          	lw	s10,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201c06:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0201c08:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0201c0a:	bf95                	j	ffffffffc0201b7e <vprintfmt+0xfc>
    if (lflag >= 2) {
ffffffffc0201c0c:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0201c0e:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc0201c12:	00c7c463          	blt	a5,a2,ffffffffc0201c1a <vprintfmt+0x198>
    else if (lflag) {
ffffffffc0201c16:	10060b63          	beqz	a2,ffffffffc0201d2c <vprintfmt+0x2aa>
        return va_arg(*ap, unsigned long);
ffffffffc0201c1a:	000a3603          	ld	a2,0(s4)
ffffffffc0201c1e:	46a1                	li	a3,8
ffffffffc0201c20:	8a3a                	mv	s4,a4
ffffffffc0201c22:	b761                	j	ffffffffc0201baa <vprintfmt+0x128>
            if (width < 0)
ffffffffc0201c24:	fffcc793          	not	a5,s9
ffffffffc0201c28:	97fd                	srai	a5,a5,0x3f
ffffffffc0201c2a:	00fcf7b3          	and	a5,s9,a5
ffffffffc0201c2e:	00078c9b          	sext.w	s9,a5
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201c32:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0201c34:	b56d                	j	ffffffffc0201ade <vprintfmt+0x5c>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201c36:	000a3403          	ld	s0,0(s4)
ffffffffc0201c3a:	008a0793          	addi	a5,s4,8
ffffffffc0201c3e:	e43e                	sd	a5,8(sp)
ffffffffc0201c40:	12040063          	beqz	s0,ffffffffc0201d60 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0201c44:	0d905963          	blez	s9,ffffffffc0201d16 <vprintfmt+0x294>
ffffffffc0201c48:	02d00793          	li	a5,45
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c4c:	00140a13          	addi	s4,s0,1
            if (width > 0 && padc != '-') {
ffffffffc0201c50:	12fd9763          	bne	s11,a5,ffffffffc0201d7e <vprintfmt+0x2fc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c54:	00044783          	lbu	a5,0(s0)
ffffffffc0201c58:	0007851b          	sext.w	a0,a5
ffffffffc0201c5c:	cb9d                	beqz	a5,ffffffffc0201c92 <vprintfmt+0x210>
ffffffffc0201c5e:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201c60:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c64:	000d4563          	bltz	s10,ffffffffc0201c6e <vprintfmt+0x1ec>
ffffffffc0201c68:	3d7d                	addiw	s10,s10,-1
ffffffffc0201c6a:	028d0263          	beq	s10,s0,ffffffffc0201c8e <vprintfmt+0x20c>
                    putch('?', putdat);
ffffffffc0201c6e:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201c70:	0c0b8d63          	beqz	s7,ffffffffc0201d4a <vprintfmt+0x2c8>
ffffffffc0201c74:	3781                	addiw	a5,a5,-32
ffffffffc0201c76:	0cfdfa63          	bgeu	s11,a5,ffffffffc0201d4a <vprintfmt+0x2c8>
                    putch('?', putdat);
ffffffffc0201c7a:	03f00513          	li	a0,63
ffffffffc0201c7e:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c80:	000a4783          	lbu	a5,0(s4)
ffffffffc0201c84:	3cfd                	addiw	s9,s9,-1 # feffff <kern_entry-0xffffffffbf210001>
ffffffffc0201c86:	0a05                	addi	s4,s4,1
ffffffffc0201c88:	0007851b          	sext.w	a0,a5
ffffffffc0201c8c:	ffe1                	bnez	a5,ffffffffc0201c64 <vprintfmt+0x1e2>
            for (; width > 0; width --) {
ffffffffc0201c8e:	01905963          	blez	s9,ffffffffc0201ca0 <vprintfmt+0x21e>
                putch(' ', putdat);
ffffffffc0201c92:	85a6                	mv	a1,s1
ffffffffc0201c94:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0201c98:	3cfd                	addiw	s9,s9,-1
                putch(' ', putdat);
ffffffffc0201c9a:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0201c9c:	fe0c9be3          	bnez	s9,ffffffffc0201c92 <vprintfmt+0x210>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201ca0:	6a22                	ld	s4,8(sp)
ffffffffc0201ca2:	bd11                	j	ffffffffc0201ab6 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0201ca4:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0201ca6:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0201caa:	00c7c363          	blt	a5,a2,ffffffffc0201cb0 <vprintfmt+0x22e>
    else if (lflag) {
ffffffffc0201cae:	ce25                	beqz	a2,ffffffffc0201d26 <vprintfmt+0x2a4>
        return va_arg(*ap, long);
ffffffffc0201cb0:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201cb4:	08044d63          	bltz	s0,ffffffffc0201d4e <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0201cb8:	8622                	mv	a2,s0
ffffffffc0201cba:	8a5e                	mv	s4,s7
ffffffffc0201cbc:	46a9                	li	a3,10
ffffffffc0201cbe:	b5f5                	j	ffffffffc0201baa <vprintfmt+0x128>
            if (err < 0) {
ffffffffc0201cc0:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201cc4:	4619                	li	a2,6
            if (err < 0) {
ffffffffc0201cc6:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0201cca:	8fb9                	xor	a5,a5,a4
ffffffffc0201ccc:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201cd0:	02d64663          	blt	a2,a3,ffffffffc0201cfc <vprintfmt+0x27a>
ffffffffc0201cd4:	00369713          	slli	a4,a3,0x3
ffffffffc0201cd8:	00001797          	auipc	a5,0x1
ffffffffc0201cdc:	3d878793          	addi	a5,a5,984 # ffffffffc02030b0 <error_string>
ffffffffc0201ce0:	97ba                	add	a5,a5,a4
ffffffffc0201ce2:	639c                	ld	a5,0(a5)
ffffffffc0201ce4:	cf81                	beqz	a5,ffffffffc0201cfc <vprintfmt+0x27a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201ce6:	86be                	mv	a3,a5
ffffffffc0201ce8:	00001617          	auipc	a2,0x1
ffffffffc0201cec:	11860613          	addi	a2,a2,280 # ffffffffc0202e00 <etext+0xe28>
ffffffffc0201cf0:	85a6                	mv	a1,s1
ffffffffc0201cf2:	854a                	mv	a0,s2
ffffffffc0201cf4:	0e8000ef          	jal	ffffffffc0201ddc <printfmt>
            err = va_arg(ap, int);
ffffffffc0201cf8:	0a21                	addi	s4,s4,8
ffffffffc0201cfa:	bb75                	j	ffffffffc0201ab6 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201cfc:	00001617          	auipc	a2,0x1
ffffffffc0201d00:	0f460613          	addi	a2,a2,244 # ffffffffc0202df0 <etext+0xe18>
ffffffffc0201d04:	85a6                	mv	a1,s1
ffffffffc0201d06:	854a                	mv	a0,s2
ffffffffc0201d08:	0d4000ef          	jal	ffffffffc0201ddc <printfmt>
            err = va_arg(ap, int);
ffffffffc0201d0c:	0a21                	addi	s4,s4,8
ffffffffc0201d0e:	b365                	j	ffffffffc0201ab6 <vprintfmt+0x34>
            lflag ++;
ffffffffc0201d10:	2605                	addiw	a2,a2,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201d12:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0201d14:	b3e9                	j	ffffffffc0201ade <vprintfmt+0x5c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d16:	00044783          	lbu	a5,0(s0)
ffffffffc0201d1a:	0007851b          	sext.w	a0,a5
ffffffffc0201d1e:	d3c9                	beqz	a5,ffffffffc0201ca0 <vprintfmt+0x21e>
ffffffffc0201d20:	00140a13          	addi	s4,s0,1
ffffffffc0201d24:	bf2d                	j	ffffffffc0201c5e <vprintfmt+0x1dc>
        return va_arg(*ap, int);
ffffffffc0201d26:	000a2403          	lw	s0,0(s4)
ffffffffc0201d2a:	b769                	j	ffffffffc0201cb4 <vprintfmt+0x232>
        return va_arg(*ap, unsigned int);
ffffffffc0201d2c:	000a6603          	lwu	a2,0(s4)
ffffffffc0201d30:	46a1                	li	a3,8
ffffffffc0201d32:	8a3a                	mv	s4,a4
ffffffffc0201d34:	bd9d                	j	ffffffffc0201baa <vprintfmt+0x128>
ffffffffc0201d36:	000a6603          	lwu	a2,0(s4)
ffffffffc0201d3a:	46a9                	li	a3,10
ffffffffc0201d3c:	8a3a                	mv	s4,a4
ffffffffc0201d3e:	b5b5                	j	ffffffffc0201baa <vprintfmt+0x128>
ffffffffc0201d40:	000a6603          	lwu	a2,0(s4)
ffffffffc0201d44:	46c1                	li	a3,16
ffffffffc0201d46:	8a3a                	mv	s4,a4
ffffffffc0201d48:	b58d                	j	ffffffffc0201baa <vprintfmt+0x128>
                    putch(ch, putdat);
ffffffffc0201d4a:	9902                	jalr	s2
ffffffffc0201d4c:	bf15                	j	ffffffffc0201c80 <vprintfmt+0x1fe>
                putch('-', putdat);
ffffffffc0201d4e:	85a6                	mv	a1,s1
ffffffffc0201d50:	02d00513          	li	a0,45
ffffffffc0201d54:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0201d56:	40800633          	neg	a2,s0
ffffffffc0201d5a:	8a5e                	mv	s4,s7
ffffffffc0201d5c:	46a9                	li	a3,10
ffffffffc0201d5e:	b5b1                	j	ffffffffc0201baa <vprintfmt+0x128>
            if (width > 0 && padc != '-') {
ffffffffc0201d60:	01905663          	blez	s9,ffffffffc0201d6c <vprintfmt+0x2ea>
ffffffffc0201d64:	02d00793          	li	a5,45
ffffffffc0201d68:	04fd9263          	bne	s11,a5,ffffffffc0201dac <vprintfmt+0x32a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d6c:	02800793          	li	a5,40
ffffffffc0201d70:	00001a17          	auipc	s4,0x1
ffffffffc0201d74:	079a0a13          	addi	s4,s4,121 # ffffffffc0202de9 <etext+0xe11>
ffffffffc0201d78:	02800513          	li	a0,40
ffffffffc0201d7c:	b5cd                	j	ffffffffc0201c5e <vprintfmt+0x1dc>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d7e:	85ea                	mv	a1,s10
ffffffffc0201d80:	8522                	mv	a0,s0
ffffffffc0201d82:	1b2000ef          	jal	ffffffffc0201f34 <strnlen>
ffffffffc0201d86:	40ac8cbb          	subw	s9,s9,a0
ffffffffc0201d8a:	01905963          	blez	s9,ffffffffc0201d9c <vprintfmt+0x31a>
                    putch(padc, putdat);
ffffffffc0201d8e:	2d81                	sext.w	s11,s11
ffffffffc0201d90:	85a6                	mv	a1,s1
ffffffffc0201d92:	856e                	mv	a0,s11
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d94:	3cfd                	addiw	s9,s9,-1
                    putch(padc, putdat);
ffffffffc0201d96:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201d98:	fe0c9ce3          	bnez	s9,ffffffffc0201d90 <vprintfmt+0x30e>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d9c:	00044783          	lbu	a5,0(s0)
ffffffffc0201da0:	0007851b          	sext.w	a0,a5
ffffffffc0201da4:	ea079de3          	bnez	a5,ffffffffc0201c5e <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201da8:	6a22                	ld	s4,8(sp)
ffffffffc0201daa:	b331                	j	ffffffffc0201ab6 <vprintfmt+0x34>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201dac:	85ea                	mv	a1,s10
ffffffffc0201dae:	00001517          	auipc	a0,0x1
ffffffffc0201db2:	03a50513          	addi	a0,a0,58 # ffffffffc0202de8 <etext+0xe10>
ffffffffc0201db6:	17e000ef          	jal	ffffffffc0201f34 <strnlen>
ffffffffc0201dba:	40ac8cbb          	subw	s9,s9,a0
                p = "(null)";
ffffffffc0201dbe:	00001417          	auipc	s0,0x1
ffffffffc0201dc2:	02a40413          	addi	s0,s0,42 # ffffffffc0202de8 <etext+0xe10>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201dc6:	00001a17          	auipc	s4,0x1
ffffffffc0201dca:	023a0a13          	addi	s4,s4,35 # ffffffffc0202de9 <etext+0xe11>
ffffffffc0201dce:	02800793          	li	a5,40
ffffffffc0201dd2:	02800513          	li	a0,40
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201dd6:	fb904ce3          	bgtz	s9,ffffffffc0201d8e <vprintfmt+0x30c>
ffffffffc0201dda:	b551                	j	ffffffffc0201c5e <vprintfmt+0x1dc>

ffffffffc0201ddc <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201ddc:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201dde:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201de2:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201de4:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201de6:	ec06                	sd	ra,24(sp)
ffffffffc0201de8:	f83a                	sd	a4,48(sp)
ffffffffc0201dea:	fc3e                	sd	a5,56(sp)
ffffffffc0201dec:	e0c2                	sd	a6,64(sp)
ffffffffc0201dee:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201df0:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201df2:	c91ff0ef          	jal	ffffffffc0201a82 <vprintfmt>
}
ffffffffc0201df6:	60e2                	ld	ra,24(sp)
ffffffffc0201df8:	6161                	addi	sp,sp,80
ffffffffc0201dfa:	8082                	ret

ffffffffc0201dfc <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0201dfc:	715d                	addi	sp,sp,-80
ffffffffc0201dfe:	e486                	sd	ra,72(sp)
ffffffffc0201e00:	e0a2                	sd	s0,64(sp)
ffffffffc0201e02:	fc26                	sd	s1,56(sp)
ffffffffc0201e04:	f84a                	sd	s2,48(sp)
ffffffffc0201e06:	f44e                	sd	s3,40(sp)
ffffffffc0201e08:	f052                	sd	s4,32(sp)
ffffffffc0201e0a:	ec56                	sd	s5,24(sp)
ffffffffc0201e0c:	e85a                	sd	s6,16(sp)
    if (prompt != NULL) {
ffffffffc0201e0e:	c901                	beqz	a0,ffffffffc0201e1e <readline+0x22>
ffffffffc0201e10:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc0201e12:	00001517          	auipc	a0,0x1
ffffffffc0201e16:	fee50513          	addi	a0,a0,-18 # ffffffffc0202e00 <etext+0xe28>
ffffffffc0201e1a:	adcfe0ef          	jal	ffffffffc02000f6 <cprintf>
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
ffffffffc0201e1e:	4401                	li	s0,0
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201e20:	44fd                	li	s1,31
        }
        else if (c == '\b' && i > 0) {
ffffffffc0201e22:	4921                	li	s2,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0201e24:	4a29                	li	s4,10
ffffffffc0201e26:	4ab5                	li	s5,13
            buf[i ++] = c;
ffffffffc0201e28:	00005b17          	auipc	s6,0x5
ffffffffc0201e2c:	218b0b13          	addi	s6,s6,536 # ffffffffc0207040 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201e30:	3fe00993          	li	s3,1022
        c = getchar();
ffffffffc0201e34:	b46fe0ef          	jal	ffffffffc020017a <getchar>
        if (c < 0) {
ffffffffc0201e38:	00054a63          	bltz	a0,ffffffffc0201e4c <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201e3c:	00a4da63          	bge	s1,a0,ffffffffc0201e50 <readline+0x54>
ffffffffc0201e40:	0289d263          	bge	s3,s0,ffffffffc0201e64 <readline+0x68>
        c = getchar();
ffffffffc0201e44:	b36fe0ef          	jal	ffffffffc020017a <getchar>
        if (c < 0) {
ffffffffc0201e48:	fe055ae3          	bgez	a0,ffffffffc0201e3c <readline+0x40>
            return NULL;
ffffffffc0201e4c:	4501                	li	a0,0
ffffffffc0201e4e:	a091                	j	ffffffffc0201e92 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc0201e50:	03251463          	bne	a0,s2,ffffffffc0201e78 <readline+0x7c>
ffffffffc0201e54:	04804963          	bgtz	s0,ffffffffc0201ea6 <readline+0xaa>
        c = getchar();
ffffffffc0201e58:	b22fe0ef          	jal	ffffffffc020017a <getchar>
        if (c < 0) {
ffffffffc0201e5c:	fe0548e3          	bltz	a0,ffffffffc0201e4c <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201e60:	fea4d8e3          	bge	s1,a0,ffffffffc0201e50 <readline+0x54>
            cputchar(c);
ffffffffc0201e64:	e42a                	sd	a0,8(sp)
ffffffffc0201e66:	ac4fe0ef          	jal	ffffffffc020012a <cputchar>
            buf[i ++] = c;
ffffffffc0201e6a:	6522                	ld	a0,8(sp)
ffffffffc0201e6c:	008b07b3          	add	a5,s6,s0
ffffffffc0201e70:	2405                	addiw	s0,s0,1
ffffffffc0201e72:	00a78023          	sb	a0,0(a5)
ffffffffc0201e76:	bf7d                	j	ffffffffc0201e34 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0201e78:	01450463          	beq	a0,s4,ffffffffc0201e80 <readline+0x84>
ffffffffc0201e7c:	fb551ce3          	bne	a0,s5,ffffffffc0201e34 <readline+0x38>
            cputchar(c);
ffffffffc0201e80:	aaafe0ef          	jal	ffffffffc020012a <cputchar>
            buf[i] = '\0';
ffffffffc0201e84:	00005517          	auipc	a0,0x5
ffffffffc0201e88:	1bc50513          	addi	a0,a0,444 # ffffffffc0207040 <buf>
ffffffffc0201e8c:	942a                	add	s0,s0,a0
ffffffffc0201e8e:	00040023          	sb	zero,0(s0)
            return buf;
        }
    }
}
ffffffffc0201e92:	60a6                	ld	ra,72(sp)
ffffffffc0201e94:	6406                	ld	s0,64(sp)
ffffffffc0201e96:	74e2                	ld	s1,56(sp)
ffffffffc0201e98:	7942                	ld	s2,48(sp)
ffffffffc0201e9a:	79a2                	ld	s3,40(sp)
ffffffffc0201e9c:	7a02                	ld	s4,32(sp)
ffffffffc0201e9e:	6ae2                	ld	s5,24(sp)
ffffffffc0201ea0:	6b42                	ld	s6,16(sp)
ffffffffc0201ea2:	6161                	addi	sp,sp,80
ffffffffc0201ea4:	8082                	ret
            cputchar(c);
ffffffffc0201ea6:	4521                	li	a0,8
ffffffffc0201ea8:	a82fe0ef          	jal	ffffffffc020012a <cputchar>
            i --;
ffffffffc0201eac:	347d                	addiw	s0,s0,-1
ffffffffc0201eae:	b759                	j	ffffffffc0201e34 <readline+0x38>

ffffffffc0201eb0 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201eb0:	4781                	li	a5,0
ffffffffc0201eb2:	00005717          	auipc	a4,0x5
ffffffffc0201eb6:	16e73703          	ld	a4,366(a4) # ffffffffc0207020 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201eba:	88ba                	mv	a7,a4
ffffffffc0201ebc:	852a                	mv	a0,a0
ffffffffc0201ebe:	85be                	mv	a1,a5
ffffffffc0201ec0:	863e                	mv	a2,a5
ffffffffc0201ec2:	00000073          	ecall
ffffffffc0201ec6:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0201ec8:	8082                	ret

ffffffffc0201eca <sbi_set_timer>:
    __asm__ volatile (
ffffffffc0201eca:	4781                	li	a5,0
ffffffffc0201ecc:	00005717          	auipc	a4,0x5
ffffffffc0201ed0:	5cc73703          	ld	a4,1484(a4) # ffffffffc0207498 <SBI_SET_TIMER>
ffffffffc0201ed4:	88ba                	mv	a7,a4
ffffffffc0201ed6:	852a                	mv	a0,a0
ffffffffc0201ed8:	85be                	mv	a1,a5
ffffffffc0201eda:	863e                	mv	a2,a5
ffffffffc0201edc:	00000073          	ecall
ffffffffc0201ee0:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc0201ee2:	8082                	ret

ffffffffc0201ee4 <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc0201ee4:	4501                	li	a0,0
ffffffffc0201ee6:	00005797          	auipc	a5,0x5
ffffffffc0201eea:	1327b783          	ld	a5,306(a5) # ffffffffc0207018 <SBI_CONSOLE_GETCHAR>
ffffffffc0201eee:	88be                	mv	a7,a5
ffffffffc0201ef0:	852a                	mv	a0,a0
ffffffffc0201ef2:	85aa                	mv	a1,a0
ffffffffc0201ef4:	862a                	mv	a2,a0
ffffffffc0201ef6:	00000073          	ecall
ffffffffc0201efa:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
ffffffffc0201efc:	2501                	sext.w	a0,a0
ffffffffc0201efe:	8082                	ret

ffffffffc0201f00 <sbi_shutdown>:
    __asm__ volatile (
ffffffffc0201f00:	4781                	li	a5,0
ffffffffc0201f02:	00005717          	auipc	a4,0x5
ffffffffc0201f06:	10e73703          	ld	a4,270(a4) # ffffffffc0207010 <SBI_SHUTDOWN>
ffffffffc0201f0a:	88ba                	mv	a7,a4
ffffffffc0201f0c:	853e                	mv	a0,a5
ffffffffc0201f0e:	85be                	mv	a1,a5
ffffffffc0201f10:	863e                	mv	a2,a5
ffffffffc0201f12:	00000073          	ecall
ffffffffc0201f16:	87aa                	mv	a5,a0

void sbi_shutdown(void)
{
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
ffffffffc0201f18:	8082                	ret

ffffffffc0201f1a <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0201f1a:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0201f1e:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0201f20:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0201f22:	cb81                	beqz	a5,ffffffffc0201f32 <strlen+0x18>
        cnt ++;
ffffffffc0201f24:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0201f26:	00a707b3          	add	a5,a4,a0
ffffffffc0201f2a:	0007c783          	lbu	a5,0(a5)
ffffffffc0201f2e:	fbfd                	bnez	a5,ffffffffc0201f24 <strlen+0xa>
ffffffffc0201f30:	8082                	ret
    }
    return cnt;
}
ffffffffc0201f32:	8082                	ret

ffffffffc0201f34 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201f34:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201f36:	e589                	bnez	a1,ffffffffc0201f40 <strnlen+0xc>
ffffffffc0201f38:	a811                	j	ffffffffc0201f4c <strnlen+0x18>
        cnt ++;
ffffffffc0201f3a:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201f3c:	00f58863          	beq	a1,a5,ffffffffc0201f4c <strnlen+0x18>
ffffffffc0201f40:	00f50733          	add	a4,a0,a5
ffffffffc0201f44:	00074703          	lbu	a4,0(a4)
ffffffffc0201f48:	fb6d                	bnez	a4,ffffffffc0201f3a <strnlen+0x6>
ffffffffc0201f4a:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201f4c:	852e                	mv	a0,a1
ffffffffc0201f4e:	8082                	ret

ffffffffc0201f50 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201f50:	00054783          	lbu	a5,0(a0)
ffffffffc0201f54:	e791                	bnez	a5,ffffffffc0201f60 <strcmp+0x10>
ffffffffc0201f56:	a02d                	j	ffffffffc0201f80 <strcmp+0x30>
ffffffffc0201f58:	00054783          	lbu	a5,0(a0)
ffffffffc0201f5c:	cf89                	beqz	a5,ffffffffc0201f76 <strcmp+0x26>
ffffffffc0201f5e:	85b6                	mv	a1,a3
ffffffffc0201f60:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0201f64:	0505                	addi	a0,a0,1
ffffffffc0201f66:	00158693          	addi	a3,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201f6a:	fef707e3          	beq	a4,a5,ffffffffc0201f58 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201f6e:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0201f72:	9d19                	subw	a0,a0,a4
ffffffffc0201f74:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201f76:	0015c703          	lbu	a4,1(a1)
ffffffffc0201f7a:	4501                	li	a0,0
}
ffffffffc0201f7c:	9d19                	subw	a0,a0,a4
ffffffffc0201f7e:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201f80:	0005c703          	lbu	a4,0(a1)
ffffffffc0201f84:	4501                	li	a0,0
ffffffffc0201f86:	b7f5                	j	ffffffffc0201f72 <strcmp+0x22>

ffffffffc0201f88 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201f88:	ce01                	beqz	a2,ffffffffc0201fa0 <strncmp+0x18>
ffffffffc0201f8a:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201f8e:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201f90:	cb91                	beqz	a5,ffffffffc0201fa4 <strncmp+0x1c>
ffffffffc0201f92:	0005c703          	lbu	a4,0(a1)
ffffffffc0201f96:	00f71763          	bne	a4,a5,ffffffffc0201fa4 <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0201f9a:	0505                	addi	a0,a0,1
ffffffffc0201f9c:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201f9e:	f675                	bnez	a2,ffffffffc0201f8a <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201fa0:	4501                	li	a0,0
ffffffffc0201fa2:	8082                	ret
ffffffffc0201fa4:	00054503          	lbu	a0,0(a0)
ffffffffc0201fa8:	0005c783          	lbu	a5,0(a1)
ffffffffc0201fac:	9d1d                	subw	a0,a0,a5
}
ffffffffc0201fae:	8082                	ret

ffffffffc0201fb0 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0201fb0:	00054783          	lbu	a5,0(a0)
ffffffffc0201fb4:	c799                	beqz	a5,ffffffffc0201fc2 <strchr+0x12>
        if (*s == c) {
ffffffffc0201fb6:	00f58763          	beq	a1,a5,ffffffffc0201fc4 <strchr+0x14>
    while (*s != '\0') {
ffffffffc0201fba:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0201fbe:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0201fc0:	fbfd                	bnez	a5,ffffffffc0201fb6 <strchr+0x6>
    }
    return NULL;
ffffffffc0201fc2:	4501                	li	a0,0
}
ffffffffc0201fc4:	8082                	ret

ffffffffc0201fc6 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201fc6:	ca01                	beqz	a2,ffffffffc0201fd6 <memset+0x10>
ffffffffc0201fc8:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0201fca:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0201fcc:	0785                	addi	a5,a5,1
ffffffffc0201fce:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201fd2:	fef61de3          	bne	a2,a5,ffffffffc0201fcc <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201fd6:	8082                	ret
