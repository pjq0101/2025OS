
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00006297          	auipc	t0,0x6
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0206000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00006297          	auipc	t0,0x6
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0206008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02052b7          	lui	t0,0xc0205
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
ffffffffc020003c:	c0205137          	lui	sp,0xc0205

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	0d628293          	addi	t0,t0,214 # ffffffffc02000d6 <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020004a:	1141                	addi	sp,sp,-16 # ffffffffc0204ff0 <bootstack+0x1ff0>
    extern char etext[], edata[], end[];
    cprintf("Special kernel symbols:\n");
ffffffffc020004c:	00001517          	auipc	a0,0x1
ffffffffc0200050:	6ec50513          	addi	a0,a0,1772 # ffffffffc0201738 <etext+0x4>
void print_kerninfo(void) {
ffffffffc0200054:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200056:	0f4000ef          	jal	ffffffffc020014a <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", (uintptr_t)kern_init);
ffffffffc020005a:	00000597          	auipc	a1,0x0
ffffffffc020005e:	07c58593          	addi	a1,a1,124 # ffffffffc02000d6 <kern_init>
ffffffffc0200062:	00001517          	auipc	a0,0x1
ffffffffc0200066:	6f650513          	addi	a0,a0,1782 # ffffffffc0201758 <etext+0x24>
ffffffffc020006a:	0e0000ef          	jal	ffffffffc020014a <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc020006e:	00001597          	auipc	a1,0x1
ffffffffc0200072:	6c658593          	addi	a1,a1,1734 # ffffffffc0201734 <etext>
ffffffffc0200076:	00001517          	auipc	a0,0x1
ffffffffc020007a:	70250513          	addi	a0,a0,1794 # ffffffffc0201778 <etext+0x44>
ffffffffc020007e:	0cc000ef          	jal	ffffffffc020014a <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc0200082:	00006597          	auipc	a1,0x6
ffffffffc0200086:	f9658593          	addi	a1,a1,-106 # ffffffffc0206018 <free_area>
ffffffffc020008a:	00001517          	auipc	a0,0x1
ffffffffc020008e:	70e50513          	addi	a0,a0,1806 # ffffffffc0201798 <etext+0x64>
ffffffffc0200092:	0b8000ef          	jal	ffffffffc020014a <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc0200096:	00006597          	auipc	a1,0x6
ffffffffc020009a:	fe258593          	addi	a1,a1,-30 # ffffffffc0206078 <end>
ffffffffc020009e:	00001517          	auipc	a0,0x1
ffffffffc02000a2:	71a50513          	addi	a0,a0,1818 # ffffffffc02017b8 <etext+0x84>
ffffffffc02000a6:	0a4000ef          	jal	ffffffffc020014a <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - (char*)kern_init + 1023) / 1024);
ffffffffc02000aa:	00006797          	auipc	a5,0x6
ffffffffc02000ae:	3cd78793          	addi	a5,a5,973 # ffffffffc0206477 <end+0x3ff>
ffffffffc02000b2:	00000717          	auipc	a4,0x0
ffffffffc02000b6:	02470713          	addi	a4,a4,36 # ffffffffc02000d6 <kern_init>
ffffffffc02000ba:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000bc:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02000c0:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000c2:	3ff5f593          	andi	a1,a1,1023
ffffffffc02000c6:	95be                	add	a1,a1,a5
ffffffffc02000c8:	85a9                	srai	a1,a1,0xa
ffffffffc02000ca:	00001517          	auipc	a0,0x1
ffffffffc02000ce:	70e50513          	addi	a0,a0,1806 # ffffffffc02017d8 <etext+0xa4>
}
ffffffffc02000d2:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000d4:	a89d                	j	ffffffffc020014a <cprintf>

ffffffffc02000d6 <kern_init>:

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc02000d6:	00006517          	auipc	a0,0x6
ffffffffc02000da:	f4250513          	addi	a0,a0,-190 # ffffffffc0206018 <free_area>
ffffffffc02000de:	00006617          	auipc	a2,0x6
ffffffffc02000e2:	f9a60613          	addi	a2,a2,-102 # ffffffffc0206078 <end>
int kern_init(void) {
ffffffffc02000e6:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc02000e8:	8e09                	sub	a2,a2,a0
ffffffffc02000ea:	4581                	li	a1,0
int kern_init(void) {
ffffffffc02000ec:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc02000ee:	634010ef          	jal	ffffffffc0201722 <memset>
    dtb_init();
ffffffffc02000f2:	13a000ef          	jal	ffffffffc020022c <dtb_init>
    cons_init();  // init the console
ffffffffc02000f6:	12c000ef          	jal	ffffffffc0200222 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc02000fa:	00002517          	auipc	a0,0x2
ffffffffc02000fe:	e4650513          	addi	a0,a0,-442 # ffffffffc0201f40 <etext+0x80c>
ffffffffc0200102:	07c000ef          	jal	ffffffffc020017e <cputs>

    print_kerninfo();
ffffffffc0200106:	f45ff0ef          	jal	ffffffffc020004a <print_kerninfo>

    // grade_backtrace();
    pmm_init();  // init physical memory management
ffffffffc020010a:	7a5000ef          	jal	ffffffffc02010ae <pmm_init>

    /* do nothing */
    while (1)
ffffffffc020010e:	a001                	j	ffffffffc020010e <kern_init+0x38>

ffffffffc0200110 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200110:	1141                	addi	sp,sp,-16
ffffffffc0200112:	e022                	sd	s0,0(sp)
ffffffffc0200114:	e406                	sd	ra,8(sp)
ffffffffc0200116:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200118:	10c000ef          	jal	ffffffffc0200224 <cons_putc>
    (*cnt) ++;
ffffffffc020011c:	401c                	lw	a5,0(s0)
}
ffffffffc020011e:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200120:	2785                	addiw	a5,a5,1
ffffffffc0200122:	c01c                	sw	a5,0(s0)
}
ffffffffc0200124:	6402                	ld	s0,0(sp)
ffffffffc0200126:	0141                	addi	sp,sp,16
ffffffffc0200128:	8082                	ret

ffffffffc020012a <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc020012a:	1101                	addi	sp,sp,-32
ffffffffc020012c:	862a                	mv	a2,a0
ffffffffc020012e:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200130:	00000517          	auipc	a0,0x0
ffffffffc0200134:	fe050513          	addi	a0,a0,-32 # ffffffffc0200110 <cputch>
ffffffffc0200138:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc020013a:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020013c:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020013e:	1ba010ef          	jal	ffffffffc02012f8 <vprintfmt>
    return cnt;
}
ffffffffc0200142:	60e2                	ld	ra,24(sp)
ffffffffc0200144:	4532                	lw	a0,12(sp)
ffffffffc0200146:	6105                	addi	sp,sp,32
ffffffffc0200148:	8082                	ret

ffffffffc020014a <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc020014a:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020014c:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
ffffffffc0200150:	f42e                	sd	a1,40(sp)
ffffffffc0200152:	f832                	sd	a2,48(sp)
ffffffffc0200154:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200156:	862a                	mv	a2,a0
ffffffffc0200158:	004c                	addi	a1,sp,4
ffffffffc020015a:	00000517          	auipc	a0,0x0
ffffffffc020015e:	fb650513          	addi	a0,a0,-74 # ffffffffc0200110 <cputch>
ffffffffc0200162:	869a                	mv	a3,t1
cprintf(const char *fmt, ...) {
ffffffffc0200164:	ec06                	sd	ra,24(sp)
ffffffffc0200166:	e0ba                	sd	a4,64(sp)
ffffffffc0200168:	e4be                	sd	a5,72(sp)
ffffffffc020016a:	e8c2                	sd	a6,80(sp)
ffffffffc020016c:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc020016e:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc0200170:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200172:	186010ef          	jal	ffffffffc02012f8 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc0200176:	60e2                	ld	ra,24(sp)
ffffffffc0200178:	4512                	lw	a0,4(sp)
ffffffffc020017a:	6125                	addi	sp,sp,96
ffffffffc020017c:	8082                	ret

ffffffffc020017e <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc020017e:	1101                	addi	sp,sp,-32
ffffffffc0200180:	ec06                	sd	ra,24(sp)
ffffffffc0200182:	e822                	sd	s0,16(sp)
ffffffffc0200184:	87aa                	mv	a5,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc0200186:	00054503          	lbu	a0,0(a0)
ffffffffc020018a:	c905                	beqz	a0,ffffffffc02001ba <cputs+0x3c>
ffffffffc020018c:	e426                	sd	s1,8(sp)
ffffffffc020018e:	00178493          	addi	s1,a5,1
ffffffffc0200192:	8426                	mv	s0,s1
    cons_putc(c);
ffffffffc0200194:	090000ef          	jal	ffffffffc0200224 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200198:	00044503          	lbu	a0,0(s0)
ffffffffc020019c:	87a2                	mv	a5,s0
ffffffffc020019e:	0405                	addi	s0,s0,1
ffffffffc02001a0:	f975                	bnez	a0,ffffffffc0200194 <cputs+0x16>
    (*cnt) ++;
ffffffffc02001a2:	9f85                	subw	a5,a5,s1
    cons_putc(c);
ffffffffc02001a4:	4529                	li	a0,10
    (*cnt) ++;
ffffffffc02001a6:	0027841b          	addiw	s0,a5,2
ffffffffc02001aa:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc02001ac:	078000ef          	jal	ffffffffc0200224 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001b0:	60e2                	ld	ra,24(sp)
ffffffffc02001b2:	8522                	mv	a0,s0
ffffffffc02001b4:	6442                	ld	s0,16(sp)
ffffffffc02001b6:	6105                	addi	sp,sp,32
ffffffffc02001b8:	8082                	ret
    cons_putc(c);
ffffffffc02001ba:	4529                	li	a0,10
ffffffffc02001bc:	068000ef          	jal	ffffffffc0200224 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc02001c0:	4405                	li	s0,1
}
ffffffffc02001c2:	60e2                	ld	ra,24(sp)
ffffffffc02001c4:	8522                	mv	a0,s0
ffffffffc02001c6:	6442                	ld	s0,16(sp)
ffffffffc02001c8:	6105                	addi	sp,sp,32
ffffffffc02001ca:	8082                	ret

ffffffffc02001cc <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02001cc:	00006317          	auipc	t1,0x6
ffffffffc02001d0:	e6430313          	addi	t1,t1,-412 # ffffffffc0206030 <is_panic>
ffffffffc02001d4:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02001d8:	715d                	addi	sp,sp,-80
ffffffffc02001da:	ec06                	sd	ra,24(sp)
ffffffffc02001dc:	f436                	sd	a3,40(sp)
ffffffffc02001de:	f83a                	sd	a4,48(sp)
ffffffffc02001e0:	fc3e                	sd	a5,56(sp)
ffffffffc02001e2:	e0c2                	sd	a6,64(sp)
ffffffffc02001e4:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02001e6:	000e0363          	beqz	t3,ffffffffc02001ec <__panic+0x20>
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    while (1) {
ffffffffc02001ea:	a001                	j	ffffffffc02001ea <__panic+0x1e>
    is_panic = 1;
ffffffffc02001ec:	4785                	li	a5,1
ffffffffc02001ee:	00f32023          	sw	a5,0(t1)
    va_start(ap, fmt);
ffffffffc02001f2:	e822                	sd	s0,16(sp)
ffffffffc02001f4:	103c                	addi	a5,sp,40
ffffffffc02001f6:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001f8:	862e                	mv	a2,a1
ffffffffc02001fa:	85aa                	mv	a1,a0
ffffffffc02001fc:	00001517          	auipc	a0,0x1
ffffffffc0200200:	60c50513          	addi	a0,a0,1548 # ffffffffc0201808 <etext+0xd4>
    va_start(ap, fmt);
ffffffffc0200204:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200206:	f45ff0ef          	jal	ffffffffc020014a <cprintf>
    vcprintf(fmt, ap);
ffffffffc020020a:	65a2                	ld	a1,8(sp)
ffffffffc020020c:	8522                	mv	a0,s0
ffffffffc020020e:	f1dff0ef          	jal	ffffffffc020012a <vcprintf>
    cprintf("\n");
ffffffffc0200212:	00001517          	auipc	a0,0x1
ffffffffc0200216:	61650513          	addi	a0,a0,1558 # ffffffffc0201828 <etext+0xf4>
ffffffffc020021a:	f31ff0ef          	jal	ffffffffc020014a <cprintf>
ffffffffc020021e:	6442                	ld	s0,16(sp)
ffffffffc0200220:	b7e9                	j	ffffffffc02001ea <__panic+0x1e>

ffffffffc0200222 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200222:	8082                	ret

ffffffffc0200224 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200224:	0ff57513          	zext.b	a0,a0
ffffffffc0200228:	44a0106f          	j	ffffffffc0201672 <sbi_console_putchar>

ffffffffc020022c <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc020022c:	711d                	addi	sp,sp,-96
    cprintf("DTB Init\n");
ffffffffc020022e:	00001517          	auipc	a0,0x1
ffffffffc0200232:	60250513          	addi	a0,a0,1538 # ffffffffc0201830 <etext+0xfc>
void dtb_init(void) {
ffffffffc0200236:	ec86                	sd	ra,88(sp)
ffffffffc0200238:	e8a2                	sd	s0,80(sp)
    cprintf("DTB Init\n");
ffffffffc020023a:	f11ff0ef          	jal	ffffffffc020014a <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020023e:	00006597          	auipc	a1,0x6
ffffffffc0200242:	dc25b583          	ld	a1,-574(a1) # ffffffffc0206000 <boot_hartid>
ffffffffc0200246:	00001517          	auipc	a0,0x1
ffffffffc020024a:	5fa50513          	addi	a0,a0,1530 # ffffffffc0201840 <etext+0x10c>
ffffffffc020024e:	efdff0ef          	jal	ffffffffc020014a <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200252:	00006417          	auipc	s0,0x6
ffffffffc0200256:	db640413          	addi	s0,s0,-586 # ffffffffc0206008 <boot_dtb>
ffffffffc020025a:	600c                	ld	a1,0(s0)
ffffffffc020025c:	00001517          	auipc	a0,0x1
ffffffffc0200260:	5f450513          	addi	a0,a0,1524 # ffffffffc0201850 <etext+0x11c>
ffffffffc0200264:	ee7ff0ef          	jal	ffffffffc020014a <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200268:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc020026a:	00001517          	auipc	a0,0x1
ffffffffc020026e:	5fe50513          	addi	a0,a0,1534 # ffffffffc0201868 <etext+0x134>
    if (boot_dtb == 0) {
ffffffffc0200272:	12070d63          	beqz	a4,ffffffffc02003ac <dtb_init+0x180>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200276:	57f5                	li	a5,-3
ffffffffc0200278:	07fa                	slli	a5,a5,0x1e
ffffffffc020027a:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc020027c:	431c                	lw	a5,0(a4)
ffffffffc020027e:	f456                	sd	s5,40(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200280:	00ff0637          	lui	a2,0xff0
ffffffffc0200284:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200288:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020028c:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200290:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200294:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200298:	6ac1                	lui	s5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020029a:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020029c:	8ec9                	or	a3,a3,a0
ffffffffc020029e:	0087979b          	slliw	a5,a5,0x8
ffffffffc02002a2:	1afd                	addi	s5,s5,-1 # ffff <kern_entry-0xffffffffc01f0001>
ffffffffc02002a4:	0157f7b3          	and	a5,a5,s5
ffffffffc02002a8:	8dd5                	or	a1,a1,a3
ffffffffc02002aa:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc02002ac:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002b0:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc02002b2:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfed9e75>
ffffffffc02002b6:	0ef59f63          	bne	a1,a5,ffffffffc02003b4 <dtb_init+0x188>
ffffffffc02002ba:	471c                	lw	a5,8(a4)
ffffffffc02002bc:	4754                	lw	a3,12(a4)
ffffffffc02002be:	fc4e                	sd	s3,56(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002c0:	0087d99b          	srliw	s3,a5,0x8
ffffffffc02002c4:	0086d41b          	srliw	s0,a3,0x8
ffffffffc02002c8:	0186951b          	slliw	a0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002cc:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002d0:	0187959b          	slliw	a1,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002d4:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002d8:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002dc:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002e0:	0109999b          	slliw	s3,s3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e4:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002e8:	8c71                	and	s0,s0,a2
ffffffffc02002ea:	00c9f9b3          	and	s3,s3,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002ee:	01156533          	or	a0,a0,a7
ffffffffc02002f2:	0086969b          	slliw	a3,a3,0x8
ffffffffc02002f6:	0105e633          	or	a2,a1,a6
ffffffffc02002fa:	0087979b          	slliw	a5,a5,0x8
ffffffffc02002fe:	8c49                	or	s0,s0,a0
ffffffffc0200300:	0156f6b3          	and	a3,a3,s5
ffffffffc0200304:	00c9e9b3          	or	s3,s3,a2
ffffffffc0200308:	0157f7b3          	and	a5,a5,s5
ffffffffc020030c:	8c55                	or	s0,s0,a3
ffffffffc020030e:	00f9e9b3          	or	s3,s3,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200312:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200314:	1982                	slli	s3,s3,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200316:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200318:	0209d993          	srli	s3,s3,0x20
ffffffffc020031c:	e4a6                	sd	s1,72(sp)
ffffffffc020031e:	e0ca                	sd	s2,64(sp)
ffffffffc0200320:	ec5e                	sd	s7,24(sp)
ffffffffc0200322:	e862                	sd	s8,16(sp)
ffffffffc0200324:	e466                	sd	s9,8(sp)
ffffffffc0200326:	e06a                	sd	s10,0(sp)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200328:	f852                	sd	s4,48(sp)
    int in_memory_node = 0;
ffffffffc020032a:	4b81                	li	s7,0
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020032c:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020032e:	99ba                	add	s3,s3,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200330:	00ff0cb7          	lui	s9,0xff0
        switch (token) {
ffffffffc0200334:	4c0d                	li	s8,3
ffffffffc0200336:	4911                	li	s2,4
ffffffffc0200338:	4d05                	li	s10,1
ffffffffc020033a:	4489                	li	s1,2
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020033c:	0009a703          	lw	a4,0(s3)
ffffffffc0200340:	00498a13          	addi	s4,s3,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200344:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200348:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020034c:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200350:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200354:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200358:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020035a:	0196f6b3          	and	a3,a3,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020035e:	0087171b          	slliw	a4,a4,0x8
ffffffffc0200362:	8fd5                	or	a5,a5,a3
ffffffffc0200364:	00eaf733          	and	a4,s5,a4
ffffffffc0200368:	8fd9                	or	a5,a5,a4
ffffffffc020036a:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc020036c:	09878263          	beq	a5,s8,ffffffffc02003f0 <dtb_init+0x1c4>
ffffffffc0200370:	00fc6963          	bltu	s8,a5,ffffffffc0200382 <dtb_init+0x156>
ffffffffc0200374:	05a78963          	beq	a5,s10,ffffffffc02003c6 <dtb_init+0x19a>
ffffffffc0200378:	00979763          	bne	a5,s1,ffffffffc0200386 <dtb_init+0x15a>
ffffffffc020037c:	4b81                	li	s7,0
ffffffffc020037e:	89d2                	mv	s3,s4
ffffffffc0200380:	bf75                	j	ffffffffc020033c <dtb_init+0x110>
ffffffffc0200382:	ff278ee3          	beq	a5,s2,ffffffffc020037e <dtb_init+0x152>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200386:	00001517          	auipc	a0,0x1
ffffffffc020038a:	5aa50513          	addi	a0,a0,1450 # ffffffffc0201930 <etext+0x1fc>
ffffffffc020038e:	dbdff0ef          	jal	ffffffffc020014a <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200392:	64a6                	ld	s1,72(sp)
ffffffffc0200394:	6906                	ld	s2,64(sp)
ffffffffc0200396:	79e2                	ld	s3,56(sp)
ffffffffc0200398:	7a42                	ld	s4,48(sp)
ffffffffc020039a:	7aa2                	ld	s5,40(sp)
ffffffffc020039c:	6be2                	ld	s7,24(sp)
ffffffffc020039e:	6c42                	ld	s8,16(sp)
ffffffffc02003a0:	6ca2                	ld	s9,8(sp)
ffffffffc02003a2:	6d02                	ld	s10,0(sp)
ffffffffc02003a4:	00001517          	auipc	a0,0x1
ffffffffc02003a8:	5c450513          	addi	a0,a0,1476 # ffffffffc0201968 <etext+0x234>
}
ffffffffc02003ac:	6446                	ld	s0,80(sp)
ffffffffc02003ae:	60e6                	ld	ra,88(sp)
ffffffffc02003b0:	6125                	addi	sp,sp,96
    cprintf("DTB init completed\n");
ffffffffc02003b2:	bb61                	j	ffffffffc020014a <cprintf>
}
ffffffffc02003b4:	6446                	ld	s0,80(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02003b6:	7aa2                	ld	s5,40(sp)
}
ffffffffc02003b8:	60e6                	ld	ra,88(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02003ba:	00001517          	auipc	a0,0x1
ffffffffc02003be:	4ce50513          	addi	a0,a0,1230 # ffffffffc0201888 <etext+0x154>
}
ffffffffc02003c2:	6125                	addi	sp,sp,96
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02003c4:	b359                	j	ffffffffc020014a <cprintf>
                int name_len = strlen(name);
ffffffffc02003c6:	8552                	mv	a0,s4
ffffffffc02003c8:	2c4010ef          	jal	ffffffffc020168c <strlen>
ffffffffc02003cc:	89aa                	mv	s3,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003ce:	4619                	li	a2,6
ffffffffc02003d0:	00001597          	auipc	a1,0x1
ffffffffc02003d4:	4e058593          	addi	a1,a1,1248 # ffffffffc02018b0 <etext+0x17c>
ffffffffc02003d8:	8552                	mv	a0,s4
                int name_len = strlen(name);
ffffffffc02003da:	2981                	sext.w	s3,s3
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003dc:	31e010ef          	jal	ffffffffc02016fa <strncmp>
ffffffffc02003e0:	e111                	bnez	a0,ffffffffc02003e4 <dtb_init+0x1b8>
                    in_memory_node = 1;
ffffffffc02003e2:	4b85                	li	s7,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02003e4:	0a11                	addi	s4,s4,4
ffffffffc02003e6:	9a4e                	add	s4,s4,s3
ffffffffc02003e8:	ffca7a13          	andi	s4,s4,-4
        switch (token) {
ffffffffc02003ec:	89d2                	mv	s3,s4
ffffffffc02003ee:	b7b9                	j	ffffffffc020033c <dtb_init+0x110>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02003f0:	0049a783          	lw	a5,4(s3)
ffffffffc02003f4:	f05a                	sd	s6,32(sp)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02003f6:	0089a683          	lw	a3,8(s3)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02003fa:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02003fe:	01879b1b          	slliw	s6,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200402:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200406:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020040a:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020040e:	00cb6b33          	or	s6,s6,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200412:	01977733          	and	a4,a4,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200416:	0087979b          	slliw	a5,a5,0x8
ffffffffc020041a:	00eb6b33          	or	s6,s6,a4
ffffffffc020041e:	00faf7b3          	and	a5,s5,a5
ffffffffc0200422:	00fb6b33          	or	s6,s6,a5
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200426:	00c98a13          	addi	s4,s3,12
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020042a:	2b01                	sext.w	s6,s6
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020042c:	000b9c63          	bnez	s7,ffffffffc0200444 <dtb_init+0x218>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200430:	1b02                	slli	s6,s6,0x20
ffffffffc0200432:	020b5b13          	srli	s6,s6,0x20
ffffffffc0200436:	0a0d                	addi	s4,s4,3
ffffffffc0200438:	9a5a                	add	s4,s4,s6
ffffffffc020043a:	ffca7a13          	andi	s4,s4,-4
                break;
ffffffffc020043e:	7b02                	ld	s6,32(sp)
        switch (token) {
ffffffffc0200440:	89d2                	mv	s3,s4
ffffffffc0200442:	bded                	j	ffffffffc020033c <dtb_init+0x110>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200444:	0086d51b          	srliw	a0,a3,0x8
ffffffffc0200448:	0186979b          	slliw	a5,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020044c:	0186d71b          	srliw	a4,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200450:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200454:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200458:	01957533          	and	a0,a0,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020045c:	8fd9                	or	a5,a5,a4
ffffffffc020045e:	0086969b          	slliw	a3,a3,0x8
ffffffffc0200462:	8d5d                	or	a0,a0,a5
ffffffffc0200464:	00daf6b3          	and	a3,s5,a3
ffffffffc0200468:	8d55                	or	a0,a0,a3
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc020046a:	1502                	slli	a0,a0,0x20
ffffffffc020046c:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020046e:	00001597          	auipc	a1,0x1
ffffffffc0200472:	44a58593          	addi	a1,a1,1098 # ffffffffc02018b8 <etext+0x184>
ffffffffc0200476:	9522                	add	a0,a0,s0
ffffffffc0200478:	24a010ef          	jal	ffffffffc02016c2 <strcmp>
ffffffffc020047c:	f955                	bnez	a0,ffffffffc0200430 <dtb_init+0x204>
ffffffffc020047e:	47bd                	li	a5,15
ffffffffc0200480:	fb67f8e3          	bgeu	a5,s6,ffffffffc0200430 <dtb_init+0x204>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200484:	00c9b783          	ld	a5,12(s3)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc0200488:	0149b703          	ld	a4,20(s3)
        cprintf("Physical Memory from DTB:\n");
ffffffffc020048c:	00001517          	auipc	a0,0x1
ffffffffc0200490:	43450513          	addi	a0,a0,1076 # ffffffffc02018c0 <etext+0x18c>
           fdt32_to_cpu(x >> 32);
ffffffffc0200494:	4207d693          	srai	a3,a5,0x20
ffffffffc0200498:	42075813          	srai	a6,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020049c:	0187d39b          	srliw	t2,a5,0x18
ffffffffc02004a0:	0186d29b          	srliw	t0,a3,0x18
ffffffffc02004a4:	01875f9b          	srliw	t6,a4,0x18
ffffffffc02004a8:	01885f1b          	srliw	t5,a6,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004ac:	0087d49b          	srliw	s1,a5,0x8
ffffffffc02004b0:	0087541b          	srliw	s0,a4,0x8
ffffffffc02004b4:	01879e9b          	slliw	t4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004b8:	0107d59b          	srliw	a1,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004bc:	01869e1b          	slliw	t3,a3,0x18
ffffffffc02004c0:	0187131b          	slliw	t1,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004c4:	0107561b          	srliw	a2,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c8:	0188189b          	slliw	a7,a6,0x18
ffffffffc02004cc:	83e1                	srli	a5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ce:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004d2:	8361                	srli	a4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004d4:	0108581b          	srliw	a6,a6,0x10
ffffffffc02004d8:	005e6e33          	or	t3,t3,t0
ffffffffc02004dc:	01e8e8b3          	or	a7,a7,t5
ffffffffc02004e0:	0088181b          	slliw	a6,a6,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004e4:	0104949b          	slliw	s1,s1,0x10
ffffffffc02004e8:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ec:	0085959b          	slliw	a1,a1,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f0:	0197f7b3          	and	a5,a5,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004f4:	0086969b          	slliw	a3,a3,0x8
ffffffffc02004f8:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004fc:	01977733          	and	a4,a4,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200500:	00daf6b3          	and	a3,s5,a3
ffffffffc0200504:	007eeeb3          	or	t4,t4,t2
ffffffffc0200508:	01f36333          	or	t1,t1,t6
ffffffffc020050c:	01c7e7b3          	or	a5,a5,t3
ffffffffc0200510:	00caf633          	and	a2,s5,a2
ffffffffc0200514:	01176733          	or	a4,a4,a7
ffffffffc0200518:	00baf5b3          	and	a1,s5,a1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020051c:	0194f4b3          	and	s1,s1,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200520:	010afab3          	and	s5,s5,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200524:	01947433          	and	s0,s0,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200528:	01d4e4b3          	or	s1,s1,t4
ffffffffc020052c:	00646433          	or	s0,s0,t1
ffffffffc0200530:	8fd5                	or	a5,a5,a3
ffffffffc0200532:	01576733          	or	a4,a4,s5
ffffffffc0200536:	8c51                	or	s0,s0,a2
ffffffffc0200538:	8ccd                	or	s1,s1,a1
           fdt32_to_cpu(x >> 32);
ffffffffc020053a:	1782                	slli	a5,a5,0x20
ffffffffc020053c:	1702                	slli	a4,a4,0x20
ffffffffc020053e:	9381                	srli	a5,a5,0x20
ffffffffc0200540:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200542:	1482                	slli	s1,s1,0x20
ffffffffc0200544:	1402                	slli	s0,s0,0x20
ffffffffc0200546:	8cdd                	or	s1,s1,a5
ffffffffc0200548:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020054a:	c01ff0ef          	jal	ffffffffc020014a <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc020054e:	85a6                	mv	a1,s1
ffffffffc0200550:	00001517          	auipc	a0,0x1
ffffffffc0200554:	39050513          	addi	a0,a0,912 # ffffffffc02018e0 <etext+0x1ac>
ffffffffc0200558:	bf3ff0ef          	jal	ffffffffc020014a <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020055c:	01445613          	srli	a2,s0,0x14
ffffffffc0200560:	85a2                	mv	a1,s0
ffffffffc0200562:	00001517          	auipc	a0,0x1
ffffffffc0200566:	39650513          	addi	a0,a0,918 # ffffffffc02018f8 <etext+0x1c4>
ffffffffc020056a:	be1ff0ef          	jal	ffffffffc020014a <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020056e:	009405b3          	add	a1,s0,s1
ffffffffc0200572:	15fd                	addi	a1,a1,-1
ffffffffc0200574:	00001517          	auipc	a0,0x1
ffffffffc0200578:	3a450513          	addi	a0,a0,932 # ffffffffc0201918 <etext+0x1e4>
ffffffffc020057c:	bcfff0ef          	jal	ffffffffc020014a <cprintf>
        memory_base = mem_base;
ffffffffc0200580:	7b02                	ld	s6,32(sp)
ffffffffc0200582:	00006797          	auipc	a5,0x6
ffffffffc0200586:	aa97bf23          	sd	s1,-1346(a5) # ffffffffc0206040 <memory_base>
        memory_size = mem_size;
ffffffffc020058a:	00006797          	auipc	a5,0x6
ffffffffc020058e:	aa87b723          	sd	s0,-1362(a5) # ffffffffc0206038 <memory_size>
ffffffffc0200592:	b501                	j	ffffffffc0200392 <dtb_init+0x166>

ffffffffc0200594 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200594:	00006517          	auipc	a0,0x6
ffffffffc0200598:	aac53503          	ld	a0,-1364(a0) # ffffffffc0206040 <memory_base>
ffffffffc020059c:	8082                	ret

ffffffffc020059e <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc020059e:	00006517          	auipc	a0,0x6
ffffffffc02005a2:	a9a53503          	ld	a0,-1382(a0) # ffffffffc0206038 <memory_size>
ffffffffc02005a6:	8082                	ret

ffffffffc02005a8 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc02005a8:	00006797          	auipc	a5,0x6
ffffffffc02005ac:	a7078793          	addi	a5,a5,-1424 # ffffffffc0206018 <free_area>
ffffffffc02005b0:	e79c                	sd	a5,8(a5)
ffffffffc02005b2:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc02005b4:	0007a823          	sw	zero,16(a5)
}
ffffffffc02005b8:	8082                	ret

ffffffffc02005ba <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc02005ba:	00006517          	auipc	a0,0x6
ffffffffc02005be:	a6e56503          	lwu	a0,-1426(a0) # ffffffffc0206028 <free_area+0x10>
ffffffffc02005c2:	8082                	ret

ffffffffc02005c4 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02005c4:	c951                	beqz	a0,ffffffffc0200658 <default_alloc_pages+0x94>
    if (n > nr_free) {
ffffffffc02005c6:	00006617          	auipc	a2,0x6
ffffffffc02005ca:	a5260613          	addi	a2,a2,-1454 # ffffffffc0206018 <free_area>
ffffffffc02005ce:	4a0c                	lw	a1,16(a2)
ffffffffc02005d0:	86aa                	mv	a3,a0
ffffffffc02005d2:	02059793          	slli	a5,a1,0x20
ffffffffc02005d6:	9381                	srli	a5,a5,0x20
ffffffffc02005d8:	00a7eb63          	bltu	a5,a0,ffffffffc02005ee <default_alloc_pages+0x2a>
    list_entry_t *le = &free_list;
ffffffffc02005dc:	87b2                	mv	a5,a2
ffffffffc02005de:	a029                	j	ffffffffc02005e8 <default_alloc_pages+0x24>
        if (p->property >= n) {
ffffffffc02005e0:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02005e4:	00d77763          	bgeu	a4,a3,ffffffffc02005f2 <default_alloc_pages+0x2e>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc02005e8:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02005ea:	fec79be3          	bne	a5,a2,ffffffffc02005e0 <default_alloc_pages+0x1c>
        return NULL;
ffffffffc02005ee:	4501                	li	a0,0
}
ffffffffc02005f0:	8082                	ret
        if (page->property > n) {
ffffffffc02005f2:	ff87a303          	lw	t1,-8(a5)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
ffffffffc02005f6:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02005fa:	0087b883          	ld	a7,8(a5)
ffffffffc02005fe:	02031713          	slli	a4,t1,0x20
ffffffffc0200602:	9301                	srli	a4,a4,0x20
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200604:	01183423          	sd	a7,8(a6)
    next->prev = prev;
ffffffffc0200608:	0108b023          	sd	a6,0(a7)
        struct Page *p = le2page(le, page_link);
ffffffffc020060c:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0200610:	00068e1b          	sext.w	t3,a3
        if (page->property > n) {
ffffffffc0200614:	02e6f963          	bgeu	a3,a4,ffffffffc0200646 <default_alloc_pages+0x82>
            struct Page *p = page + n;
ffffffffc0200618:	00269713          	slli	a4,a3,0x2
ffffffffc020061c:	9736                	add	a4,a4,a3
ffffffffc020061e:	070e                	slli	a4,a4,0x3
ffffffffc0200620:	972a                	add	a4,a4,a0
            SetPageProperty(p);
ffffffffc0200622:	6714                	ld	a3,8(a4)
            p->property = page->property - n;
ffffffffc0200624:	41c3033b          	subw	t1,t1,t3
ffffffffc0200628:	00672823          	sw	t1,16(a4)
            SetPageProperty(p);
ffffffffc020062c:	0026e693          	ori	a3,a3,2
ffffffffc0200630:	e714                	sd	a3,8(a4)
            list_add(prev, &(p->page_link));
ffffffffc0200632:	01870693          	addi	a3,a4,24
    prev->next = next->prev = elm;
ffffffffc0200636:	00d8b023          	sd	a3,0(a7)
ffffffffc020063a:	00d83423          	sd	a3,8(a6)
    elm->next = next;
ffffffffc020063e:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc0200642:	01073c23          	sd	a6,24(a4)
        ClearPageProperty(page);
ffffffffc0200646:	ff07b703          	ld	a4,-16(a5)
        nr_free -= n;
ffffffffc020064a:	41c585bb          	subw	a1,a1,t3
ffffffffc020064e:	ca0c                	sw	a1,16(a2)
        ClearPageProperty(page);
ffffffffc0200650:	9b75                	andi	a4,a4,-3
ffffffffc0200652:	fee7b823          	sd	a4,-16(a5)
ffffffffc0200656:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc0200658:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020065a:	00001697          	auipc	a3,0x1
ffffffffc020065e:	32668693          	addi	a3,a3,806 # ffffffffc0201980 <etext+0x24c>
ffffffffc0200662:	00001617          	auipc	a2,0x1
ffffffffc0200666:	32660613          	addi	a2,a2,806 # ffffffffc0201988 <etext+0x254>
ffffffffc020066a:	06200593          	li	a1,98
ffffffffc020066e:	00001517          	auipc	a0,0x1
ffffffffc0200672:	33250513          	addi	a0,a0,818 # ffffffffc02019a0 <etext+0x26c>
default_alloc_pages(size_t n) {
ffffffffc0200676:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200678:	b55ff0ef          	jal	ffffffffc02001cc <__panic>

ffffffffc020067c <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc020067c:	715d                	addi	sp,sp,-80
ffffffffc020067e:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc0200680:	00006417          	auipc	s0,0x6
ffffffffc0200684:	99840413          	addi	s0,s0,-1640 # ffffffffc0206018 <free_area>
ffffffffc0200688:	641c                	ld	a5,8(s0)
ffffffffc020068a:	e486                	sd	ra,72(sp)
ffffffffc020068c:	fc26                	sd	s1,56(sp)
ffffffffc020068e:	f84a                	sd	s2,48(sp)
ffffffffc0200690:	f44e                	sd	s3,40(sp)
ffffffffc0200692:	f052                	sd	s4,32(sp)
ffffffffc0200694:	ec56                	sd	s5,24(sp)
ffffffffc0200696:	e85a                	sd	s6,16(sp)
ffffffffc0200698:	e45e                	sd	s7,8(sp)
ffffffffc020069a:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc020069c:	2c878c63          	beq	a5,s0,ffffffffc0200974 <default_check+0x2f8>
    int count = 0, total = 0;
ffffffffc02006a0:	4481                	li	s1,0
ffffffffc02006a2:	4901                	li	s2,0
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02006a4:	ff07b703          	ld	a4,-16(a5)
ffffffffc02006a8:	8b09                	andi	a4,a4,2
ffffffffc02006aa:	2c070963          	beqz	a4,ffffffffc020097c <default_check+0x300>
        count ++, total += p->property;
ffffffffc02006ae:	ff87a703          	lw	a4,-8(a5)
ffffffffc02006b2:	679c                	ld	a5,8(a5)
ffffffffc02006b4:	2905                	addiw	s2,s2,1
ffffffffc02006b6:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc02006b8:	fe8796e3          	bne	a5,s0,ffffffffc02006a4 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc02006bc:	89a6                	mv	s3,s1
ffffffffc02006be:	1e5000ef          	jal	ffffffffc02010a2 <nr_free_pages>
ffffffffc02006c2:	71351d63          	bne	a0,s3,ffffffffc0200ddc <default_check+0x760>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02006c6:	4505                	li	a0,1
ffffffffc02006c8:	1c3000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc02006cc:	8a2a                	mv	s4,a0
ffffffffc02006ce:	44050763          	beqz	a0,ffffffffc0200b1c <default_check+0x4a0>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02006d2:	4505                	li	a0,1
ffffffffc02006d4:	1b7000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc02006d8:	89aa                	mv	s3,a0
ffffffffc02006da:	72050163          	beqz	a0,ffffffffc0200dfc <default_check+0x780>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02006de:	4505                	li	a0,1
ffffffffc02006e0:	1ab000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc02006e4:	8aaa                	mv	s5,a0
ffffffffc02006e6:	4a050b63          	beqz	a0,ffffffffc0200b9c <default_check+0x520>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02006ea:	2b3a0963          	beq	s4,s3,ffffffffc020099c <default_check+0x320>
ffffffffc02006ee:	2aaa0763          	beq	s4,a0,ffffffffc020099c <default_check+0x320>
ffffffffc02006f2:	2aa98563          	beq	s3,a0,ffffffffc020099c <default_check+0x320>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02006f6:	000a2783          	lw	a5,0(s4)
ffffffffc02006fa:	2c079163          	bnez	a5,ffffffffc02009bc <default_check+0x340>
ffffffffc02006fe:	0009a783          	lw	a5,0(s3)
ffffffffc0200702:	2a079d63          	bnez	a5,ffffffffc02009bc <default_check+0x340>
ffffffffc0200706:	411c                	lw	a5,0(a0)
ffffffffc0200708:	2a079a63          	bnez	a5,ffffffffc02009bc <default_check+0x340>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc020070c:	fcccd7b7          	lui	a5,0xfcccd
ffffffffc0200710:	ccd78793          	addi	a5,a5,-819 # fffffffffccccccd <end+0x3cac6c55>
ffffffffc0200714:	07b2                	slli	a5,a5,0xc
ffffffffc0200716:	ccd78793          	addi	a5,a5,-819
ffffffffc020071a:	07b2                	slli	a5,a5,0xc
ffffffffc020071c:	00006717          	auipc	a4,0x6
ffffffffc0200720:	95473703          	ld	a4,-1708(a4) # ffffffffc0206070 <pages>
ffffffffc0200724:	ccd78793          	addi	a5,a5,-819
ffffffffc0200728:	40ea06b3          	sub	a3,s4,a4
ffffffffc020072c:	07b2                	slli	a5,a5,0xc
ffffffffc020072e:	868d                	srai	a3,a3,0x3
ffffffffc0200730:	ccd78793          	addi	a5,a5,-819
ffffffffc0200734:	02f686b3          	mul	a3,a3,a5
ffffffffc0200738:	00002597          	auipc	a1,0x2
ffffffffc020073c:	9f05b583          	ld	a1,-1552(a1) # ffffffffc0202128 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200740:	00006617          	auipc	a2,0x6
ffffffffc0200744:	92863603          	ld	a2,-1752(a2) # ffffffffc0206068 <npage>
ffffffffc0200748:	0632                	slli	a2,a2,0xc
ffffffffc020074a:	96ae                	add	a3,a3,a1

static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc020074c:	06b2                	slli	a3,a3,0xc
ffffffffc020074e:	28c6f763          	bgeu	a3,a2,ffffffffc02009dc <default_check+0x360>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200752:	40e986b3          	sub	a3,s3,a4
ffffffffc0200756:	868d                	srai	a3,a3,0x3
ffffffffc0200758:	02f686b3          	mul	a3,a3,a5
ffffffffc020075c:	96ae                	add	a3,a3,a1
    return page2ppn(page) << PGSHIFT;
ffffffffc020075e:	06b2                	slli	a3,a3,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200760:	4ac6fe63          	bgeu	a3,a2,ffffffffc0200c1c <default_check+0x5a0>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200764:	40e50733          	sub	a4,a0,a4
ffffffffc0200768:	870d                	srai	a4,a4,0x3
ffffffffc020076a:	02f707b3          	mul	a5,a4,a5
ffffffffc020076e:	97ae                	add	a5,a5,a1
    return page2ppn(page) << PGSHIFT;
ffffffffc0200770:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200772:	30c7f563          	bgeu	a5,a2,ffffffffc0200a7c <default_check+0x400>
    assert(alloc_page() == NULL);
ffffffffc0200776:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200778:	00043c03          	ld	s8,0(s0)
ffffffffc020077c:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200780:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200784:	e400                	sd	s0,8(s0)
ffffffffc0200786:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200788:	00006797          	auipc	a5,0x6
ffffffffc020078c:	8a07a023          	sw	zero,-1888(a5) # ffffffffc0206028 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200790:	0fb000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc0200794:	2c051463          	bnez	a0,ffffffffc0200a5c <default_check+0x3e0>
    free_page(p0);
ffffffffc0200798:	4585                	li	a1,1
ffffffffc020079a:	8552                	mv	a0,s4
ffffffffc020079c:	0fb000ef          	jal	ffffffffc0201096 <free_pages>
    free_page(p1);
ffffffffc02007a0:	4585                	li	a1,1
ffffffffc02007a2:	854e                	mv	a0,s3
ffffffffc02007a4:	0f3000ef          	jal	ffffffffc0201096 <free_pages>
    free_page(p2);
ffffffffc02007a8:	4585                	li	a1,1
ffffffffc02007aa:	8556                	mv	a0,s5
ffffffffc02007ac:	0eb000ef          	jal	ffffffffc0201096 <free_pages>
    assert(nr_free == 3);
ffffffffc02007b0:	4818                	lw	a4,16(s0)
ffffffffc02007b2:	478d                	li	a5,3
ffffffffc02007b4:	28f71463          	bne	a4,a5,ffffffffc0200a3c <default_check+0x3c0>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02007b8:	4505                	li	a0,1
ffffffffc02007ba:	0d1000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc02007be:	89aa                	mv	s3,a0
ffffffffc02007c0:	24050e63          	beqz	a0,ffffffffc0200a1c <default_check+0x3a0>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02007c4:	4505                	li	a0,1
ffffffffc02007c6:	0c5000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc02007ca:	8aaa                	mv	s5,a0
ffffffffc02007cc:	3a050863          	beqz	a0,ffffffffc0200b7c <default_check+0x500>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02007d0:	4505                	li	a0,1
ffffffffc02007d2:	0b9000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc02007d6:	8a2a                	mv	s4,a0
ffffffffc02007d8:	38050263          	beqz	a0,ffffffffc0200b5c <default_check+0x4e0>
    assert(alloc_page() == NULL);
ffffffffc02007dc:	4505                	li	a0,1
ffffffffc02007de:	0ad000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc02007e2:	34051d63          	bnez	a0,ffffffffc0200b3c <default_check+0x4c0>
    free_page(p0);
ffffffffc02007e6:	4585                	li	a1,1
ffffffffc02007e8:	854e                	mv	a0,s3
ffffffffc02007ea:	0ad000ef          	jal	ffffffffc0201096 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc02007ee:	641c                	ld	a5,8(s0)
ffffffffc02007f0:	20878663          	beq	a5,s0,ffffffffc02009fc <default_check+0x380>
    assert((p = alloc_page()) == p0);
ffffffffc02007f4:	4505                	li	a0,1
ffffffffc02007f6:	095000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc02007fa:	30a99163          	bne	s3,a0,ffffffffc0200afc <default_check+0x480>
    assert(alloc_page() == NULL);
ffffffffc02007fe:	4505                	li	a0,1
ffffffffc0200800:	08b000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc0200804:	2c051c63          	bnez	a0,ffffffffc0200adc <default_check+0x460>
    assert(nr_free == 0);
ffffffffc0200808:	481c                	lw	a5,16(s0)
ffffffffc020080a:	2a079963          	bnez	a5,ffffffffc0200abc <default_check+0x440>
    free_page(p);
ffffffffc020080e:	854e                	mv	a0,s3
ffffffffc0200810:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200812:	01843023          	sd	s8,0(s0)
ffffffffc0200816:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc020081a:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc020081e:	079000ef          	jal	ffffffffc0201096 <free_pages>
    free_page(p1);
ffffffffc0200822:	4585                	li	a1,1
ffffffffc0200824:	8556                	mv	a0,s5
ffffffffc0200826:	071000ef          	jal	ffffffffc0201096 <free_pages>
    free_page(p2);
ffffffffc020082a:	4585                	li	a1,1
ffffffffc020082c:	8552                	mv	a0,s4
ffffffffc020082e:	069000ef          	jal	ffffffffc0201096 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200832:	4515                	li	a0,5
ffffffffc0200834:	057000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc0200838:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc020083a:	26050163          	beqz	a0,ffffffffc0200a9c <default_check+0x420>
    assert(!PageProperty(p0));
ffffffffc020083e:	651c                	ld	a5,8(a0)
ffffffffc0200840:	8b89                	andi	a5,a5,2
ffffffffc0200842:	52079d63          	bnez	a5,ffffffffc0200d7c <default_check+0x700>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200846:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200848:	00043b83          	ld	s7,0(s0)
ffffffffc020084c:	00843b03          	ld	s6,8(s0)
ffffffffc0200850:	e000                	sd	s0,0(s0)
ffffffffc0200852:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200854:	037000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc0200858:	50051263          	bnez	a0,ffffffffc0200d5c <default_check+0x6e0>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc020085c:	05098a13          	addi	s4,s3,80
ffffffffc0200860:	8552                	mv	a0,s4
ffffffffc0200862:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200864:	01042c03          	lw	s8,16(s0)
    nr_free = 0;
ffffffffc0200868:	00005797          	auipc	a5,0x5
ffffffffc020086c:	7c07a023          	sw	zero,1984(a5) # ffffffffc0206028 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200870:	027000ef          	jal	ffffffffc0201096 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200874:	4511                	li	a0,4
ffffffffc0200876:	015000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc020087a:	4c051163          	bnez	a0,ffffffffc0200d3c <default_check+0x6c0>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020087e:	0589b783          	ld	a5,88(s3)
ffffffffc0200882:	8b89                	andi	a5,a5,2
ffffffffc0200884:	48078c63          	beqz	a5,ffffffffc0200d1c <default_check+0x6a0>
ffffffffc0200888:	0609a703          	lw	a4,96(s3)
ffffffffc020088c:	478d                	li	a5,3
ffffffffc020088e:	48f71763          	bne	a4,a5,ffffffffc0200d1c <default_check+0x6a0>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200892:	450d                	li	a0,3
ffffffffc0200894:	7f6000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc0200898:	8aaa                	mv	s5,a0
ffffffffc020089a:	46050163          	beqz	a0,ffffffffc0200cfc <default_check+0x680>
    assert(alloc_page() == NULL);
ffffffffc020089e:	4505                	li	a0,1
ffffffffc02008a0:	7ea000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc02008a4:	42051c63          	bnez	a0,ffffffffc0200cdc <default_check+0x660>
    assert(p0 + 2 == p1);
ffffffffc02008a8:	415a1a63          	bne	s4,s5,ffffffffc0200cbc <default_check+0x640>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02008ac:	4585                	li	a1,1
ffffffffc02008ae:	854e                	mv	a0,s3
ffffffffc02008b0:	7e6000ef          	jal	ffffffffc0201096 <free_pages>
    free_pages(p1, 3);
ffffffffc02008b4:	458d                	li	a1,3
ffffffffc02008b6:	8552                	mv	a0,s4
ffffffffc02008b8:	7de000ef          	jal	ffffffffc0201096 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02008bc:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc02008c0:	02898a93          	addi	s5,s3,40
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02008c4:	8b89                	andi	a5,a5,2
ffffffffc02008c6:	3c078b63          	beqz	a5,ffffffffc0200c9c <default_check+0x620>
ffffffffc02008ca:	0109a703          	lw	a4,16(s3)
ffffffffc02008ce:	4785                	li	a5,1
ffffffffc02008d0:	3cf71663          	bne	a4,a5,ffffffffc0200c9c <default_check+0x620>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02008d4:	008a3783          	ld	a5,8(s4)
ffffffffc02008d8:	8b89                	andi	a5,a5,2
ffffffffc02008da:	3a078163          	beqz	a5,ffffffffc0200c7c <default_check+0x600>
ffffffffc02008de:	010a2703          	lw	a4,16(s4)
ffffffffc02008e2:	478d                	li	a5,3
ffffffffc02008e4:	38f71c63          	bne	a4,a5,ffffffffc0200c7c <default_check+0x600>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02008e8:	4505                	li	a0,1
ffffffffc02008ea:	7a0000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc02008ee:	36a99763          	bne	s3,a0,ffffffffc0200c5c <default_check+0x5e0>
    free_page(p0);
ffffffffc02008f2:	4585                	li	a1,1
ffffffffc02008f4:	7a2000ef          	jal	ffffffffc0201096 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02008f8:	4509                	li	a0,2
ffffffffc02008fa:	790000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc02008fe:	32aa1f63          	bne	s4,a0,ffffffffc0200c3c <default_check+0x5c0>

    free_pages(p0, 2);
ffffffffc0200902:	4589                	li	a1,2
ffffffffc0200904:	792000ef          	jal	ffffffffc0201096 <free_pages>
    free_page(p2);
ffffffffc0200908:	4585                	li	a1,1
ffffffffc020090a:	8556                	mv	a0,s5
ffffffffc020090c:	78a000ef          	jal	ffffffffc0201096 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200910:	4515                	li	a0,5
ffffffffc0200912:	778000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc0200916:	89aa                	mv	s3,a0
ffffffffc0200918:	48050263          	beqz	a0,ffffffffc0200d9c <default_check+0x720>
    assert(alloc_page() == NULL);
ffffffffc020091c:	4505                	li	a0,1
ffffffffc020091e:	76c000ef          	jal	ffffffffc020108a <alloc_pages>
ffffffffc0200922:	2c051d63          	bnez	a0,ffffffffc0200bfc <default_check+0x580>

    assert(nr_free == 0);
ffffffffc0200926:	481c                	lw	a5,16(s0)
ffffffffc0200928:	2a079a63          	bnez	a5,ffffffffc0200bdc <default_check+0x560>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc020092c:	4595                	li	a1,5
ffffffffc020092e:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200930:	01842823          	sw	s8,16(s0)
    free_list = free_list_store;
ffffffffc0200934:	01743023          	sd	s7,0(s0)
ffffffffc0200938:	01643423          	sd	s6,8(s0)
    free_pages(p0, 5);
ffffffffc020093c:	75a000ef          	jal	ffffffffc0201096 <free_pages>
    return listelm->next;
ffffffffc0200940:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200942:	00878963          	beq	a5,s0,ffffffffc0200954 <default_check+0x2d8>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200946:	ff87a703          	lw	a4,-8(a5)
ffffffffc020094a:	679c                	ld	a5,8(a5)
ffffffffc020094c:	397d                	addiw	s2,s2,-1
ffffffffc020094e:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200950:	fe879be3          	bne	a5,s0,ffffffffc0200946 <default_check+0x2ca>
    }
    assert(count == 0);
ffffffffc0200954:	26091463          	bnez	s2,ffffffffc0200bbc <default_check+0x540>
    assert(total == 0);
ffffffffc0200958:	46049263          	bnez	s1,ffffffffc0200dbc <default_check+0x740>
}
ffffffffc020095c:	60a6                	ld	ra,72(sp)
ffffffffc020095e:	6406                	ld	s0,64(sp)
ffffffffc0200960:	74e2                	ld	s1,56(sp)
ffffffffc0200962:	7942                	ld	s2,48(sp)
ffffffffc0200964:	79a2                	ld	s3,40(sp)
ffffffffc0200966:	7a02                	ld	s4,32(sp)
ffffffffc0200968:	6ae2                	ld	s5,24(sp)
ffffffffc020096a:	6b42                	ld	s6,16(sp)
ffffffffc020096c:	6ba2                	ld	s7,8(sp)
ffffffffc020096e:	6c02                	ld	s8,0(sp)
ffffffffc0200970:	6161                	addi	sp,sp,80
ffffffffc0200972:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200974:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200976:	4481                	li	s1,0
ffffffffc0200978:	4901                	li	s2,0
ffffffffc020097a:	b391                	j	ffffffffc02006be <default_check+0x42>
        assert(PageProperty(p));
ffffffffc020097c:	00001697          	auipc	a3,0x1
ffffffffc0200980:	03c68693          	addi	a3,a3,60 # ffffffffc02019b8 <etext+0x284>
ffffffffc0200984:	00001617          	auipc	a2,0x1
ffffffffc0200988:	00460613          	addi	a2,a2,4 # ffffffffc0201988 <etext+0x254>
ffffffffc020098c:	0f000593          	li	a1,240
ffffffffc0200990:	00001517          	auipc	a0,0x1
ffffffffc0200994:	01050513          	addi	a0,a0,16 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200998:	835ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020099c:	00001697          	auipc	a3,0x1
ffffffffc02009a0:	0ac68693          	addi	a3,a3,172 # ffffffffc0201a48 <etext+0x314>
ffffffffc02009a4:	00001617          	auipc	a2,0x1
ffffffffc02009a8:	fe460613          	addi	a2,a2,-28 # ffffffffc0201988 <etext+0x254>
ffffffffc02009ac:	0bd00593          	li	a1,189
ffffffffc02009b0:	00001517          	auipc	a0,0x1
ffffffffc02009b4:	ff050513          	addi	a0,a0,-16 # ffffffffc02019a0 <etext+0x26c>
ffffffffc02009b8:	815ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02009bc:	00001697          	auipc	a3,0x1
ffffffffc02009c0:	0b468693          	addi	a3,a3,180 # ffffffffc0201a70 <etext+0x33c>
ffffffffc02009c4:	00001617          	auipc	a2,0x1
ffffffffc02009c8:	fc460613          	addi	a2,a2,-60 # ffffffffc0201988 <etext+0x254>
ffffffffc02009cc:	0be00593          	li	a1,190
ffffffffc02009d0:	00001517          	auipc	a0,0x1
ffffffffc02009d4:	fd050513          	addi	a0,a0,-48 # ffffffffc02019a0 <etext+0x26c>
ffffffffc02009d8:	ff4ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02009dc:	00001697          	auipc	a3,0x1
ffffffffc02009e0:	0d468693          	addi	a3,a3,212 # ffffffffc0201ab0 <etext+0x37c>
ffffffffc02009e4:	00001617          	auipc	a2,0x1
ffffffffc02009e8:	fa460613          	addi	a2,a2,-92 # ffffffffc0201988 <etext+0x254>
ffffffffc02009ec:	0c000593          	li	a1,192
ffffffffc02009f0:	00001517          	auipc	a0,0x1
ffffffffc02009f4:	fb050513          	addi	a0,a0,-80 # ffffffffc02019a0 <etext+0x26c>
ffffffffc02009f8:	fd4ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(!list_empty(&free_list));
ffffffffc02009fc:	00001697          	auipc	a3,0x1
ffffffffc0200a00:	13c68693          	addi	a3,a3,316 # ffffffffc0201b38 <etext+0x404>
ffffffffc0200a04:	00001617          	auipc	a2,0x1
ffffffffc0200a08:	f8460613          	addi	a2,a2,-124 # ffffffffc0201988 <etext+0x254>
ffffffffc0200a0c:	0d900593          	li	a1,217
ffffffffc0200a10:	00001517          	auipc	a0,0x1
ffffffffc0200a14:	f9050513          	addi	a0,a0,-112 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200a18:	fb4ff0ef          	jal	ffffffffc02001cc <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200a1c:	00001697          	auipc	a3,0x1
ffffffffc0200a20:	fcc68693          	addi	a3,a3,-52 # ffffffffc02019e8 <etext+0x2b4>
ffffffffc0200a24:	00001617          	auipc	a2,0x1
ffffffffc0200a28:	f6460613          	addi	a2,a2,-156 # ffffffffc0201988 <etext+0x254>
ffffffffc0200a2c:	0d200593          	li	a1,210
ffffffffc0200a30:	00001517          	auipc	a0,0x1
ffffffffc0200a34:	f7050513          	addi	a0,a0,-144 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200a38:	f94ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(nr_free == 3);
ffffffffc0200a3c:	00001697          	auipc	a3,0x1
ffffffffc0200a40:	0ec68693          	addi	a3,a3,236 # ffffffffc0201b28 <etext+0x3f4>
ffffffffc0200a44:	00001617          	auipc	a2,0x1
ffffffffc0200a48:	f4460613          	addi	a2,a2,-188 # ffffffffc0201988 <etext+0x254>
ffffffffc0200a4c:	0d000593          	li	a1,208
ffffffffc0200a50:	00001517          	auipc	a0,0x1
ffffffffc0200a54:	f5050513          	addi	a0,a0,-176 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200a58:	f74ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200a5c:	00001697          	auipc	a3,0x1
ffffffffc0200a60:	0b468693          	addi	a3,a3,180 # ffffffffc0201b10 <etext+0x3dc>
ffffffffc0200a64:	00001617          	auipc	a2,0x1
ffffffffc0200a68:	f2460613          	addi	a2,a2,-220 # ffffffffc0201988 <etext+0x254>
ffffffffc0200a6c:	0cb00593          	li	a1,203
ffffffffc0200a70:	00001517          	auipc	a0,0x1
ffffffffc0200a74:	f3050513          	addi	a0,a0,-208 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200a78:	f54ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200a7c:	00001697          	auipc	a3,0x1
ffffffffc0200a80:	07468693          	addi	a3,a3,116 # ffffffffc0201af0 <etext+0x3bc>
ffffffffc0200a84:	00001617          	auipc	a2,0x1
ffffffffc0200a88:	f0460613          	addi	a2,a2,-252 # ffffffffc0201988 <etext+0x254>
ffffffffc0200a8c:	0c200593          	li	a1,194
ffffffffc0200a90:	00001517          	auipc	a0,0x1
ffffffffc0200a94:	f1050513          	addi	a0,a0,-240 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200a98:	f34ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(p0 != NULL);
ffffffffc0200a9c:	00001697          	auipc	a3,0x1
ffffffffc0200aa0:	0e468693          	addi	a3,a3,228 # ffffffffc0201b80 <etext+0x44c>
ffffffffc0200aa4:	00001617          	auipc	a2,0x1
ffffffffc0200aa8:	ee460613          	addi	a2,a2,-284 # ffffffffc0201988 <etext+0x254>
ffffffffc0200aac:	0f800593          	li	a1,248
ffffffffc0200ab0:	00001517          	auipc	a0,0x1
ffffffffc0200ab4:	ef050513          	addi	a0,a0,-272 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200ab8:	f14ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(nr_free == 0);
ffffffffc0200abc:	00001697          	auipc	a3,0x1
ffffffffc0200ac0:	0b468693          	addi	a3,a3,180 # ffffffffc0201b70 <etext+0x43c>
ffffffffc0200ac4:	00001617          	auipc	a2,0x1
ffffffffc0200ac8:	ec460613          	addi	a2,a2,-316 # ffffffffc0201988 <etext+0x254>
ffffffffc0200acc:	0df00593          	li	a1,223
ffffffffc0200ad0:	00001517          	auipc	a0,0x1
ffffffffc0200ad4:	ed050513          	addi	a0,a0,-304 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200ad8:	ef4ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200adc:	00001697          	auipc	a3,0x1
ffffffffc0200ae0:	03468693          	addi	a3,a3,52 # ffffffffc0201b10 <etext+0x3dc>
ffffffffc0200ae4:	00001617          	auipc	a2,0x1
ffffffffc0200ae8:	ea460613          	addi	a2,a2,-348 # ffffffffc0201988 <etext+0x254>
ffffffffc0200aec:	0dd00593          	li	a1,221
ffffffffc0200af0:	00001517          	auipc	a0,0x1
ffffffffc0200af4:	eb050513          	addi	a0,a0,-336 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200af8:	ed4ff0ef          	jal	ffffffffc02001cc <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0200afc:	00001697          	auipc	a3,0x1
ffffffffc0200b00:	05468693          	addi	a3,a3,84 # ffffffffc0201b50 <etext+0x41c>
ffffffffc0200b04:	00001617          	auipc	a2,0x1
ffffffffc0200b08:	e8460613          	addi	a2,a2,-380 # ffffffffc0201988 <etext+0x254>
ffffffffc0200b0c:	0dc00593          	li	a1,220
ffffffffc0200b10:	00001517          	auipc	a0,0x1
ffffffffc0200b14:	e9050513          	addi	a0,a0,-368 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200b18:	eb4ff0ef          	jal	ffffffffc02001cc <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200b1c:	00001697          	auipc	a3,0x1
ffffffffc0200b20:	ecc68693          	addi	a3,a3,-308 # ffffffffc02019e8 <etext+0x2b4>
ffffffffc0200b24:	00001617          	auipc	a2,0x1
ffffffffc0200b28:	e6460613          	addi	a2,a2,-412 # ffffffffc0201988 <etext+0x254>
ffffffffc0200b2c:	0b900593          	li	a1,185
ffffffffc0200b30:	00001517          	auipc	a0,0x1
ffffffffc0200b34:	e7050513          	addi	a0,a0,-400 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200b38:	e94ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200b3c:	00001697          	auipc	a3,0x1
ffffffffc0200b40:	fd468693          	addi	a3,a3,-44 # ffffffffc0201b10 <etext+0x3dc>
ffffffffc0200b44:	00001617          	auipc	a2,0x1
ffffffffc0200b48:	e4460613          	addi	a2,a2,-444 # ffffffffc0201988 <etext+0x254>
ffffffffc0200b4c:	0d600593          	li	a1,214
ffffffffc0200b50:	00001517          	auipc	a0,0x1
ffffffffc0200b54:	e5050513          	addi	a0,a0,-432 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200b58:	e74ff0ef          	jal	ffffffffc02001cc <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200b5c:	00001697          	auipc	a3,0x1
ffffffffc0200b60:	ecc68693          	addi	a3,a3,-308 # ffffffffc0201a28 <etext+0x2f4>
ffffffffc0200b64:	00001617          	auipc	a2,0x1
ffffffffc0200b68:	e2460613          	addi	a2,a2,-476 # ffffffffc0201988 <etext+0x254>
ffffffffc0200b6c:	0d400593          	li	a1,212
ffffffffc0200b70:	00001517          	auipc	a0,0x1
ffffffffc0200b74:	e3050513          	addi	a0,a0,-464 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200b78:	e54ff0ef          	jal	ffffffffc02001cc <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200b7c:	00001697          	auipc	a3,0x1
ffffffffc0200b80:	e8c68693          	addi	a3,a3,-372 # ffffffffc0201a08 <etext+0x2d4>
ffffffffc0200b84:	00001617          	auipc	a2,0x1
ffffffffc0200b88:	e0460613          	addi	a2,a2,-508 # ffffffffc0201988 <etext+0x254>
ffffffffc0200b8c:	0d300593          	li	a1,211
ffffffffc0200b90:	00001517          	auipc	a0,0x1
ffffffffc0200b94:	e1050513          	addi	a0,a0,-496 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200b98:	e34ff0ef          	jal	ffffffffc02001cc <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200b9c:	00001697          	auipc	a3,0x1
ffffffffc0200ba0:	e8c68693          	addi	a3,a3,-372 # ffffffffc0201a28 <etext+0x2f4>
ffffffffc0200ba4:	00001617          	auipc	a2,0x1
ffffffffc0200ba8:	de460613          	addi	a2,a2,-540 # ffffffffc0201988 <etext+0x254>
ffffffffc0200bac:	0bb00593          	li	a1,187
ffffffffc0200bb0:	00001517          	auipc	a0,0x1
ffffffffc0200bb4:	df050513          	addi	a0,a0,-528 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200bb8:	e14ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(count == 0);
ffffffffc0200bbc:	00001697          	auipc	a3,0x1
ffffffffc0200bc0:	11468693          	addi	a3,a3,276 # ffffffffc0201cd0 <etext+0x59c>
ffffffffc0200bc4:	00001617          	auipc	a2,0x1
ffffffffc0200bc8:	dc460613          	addi	a2,a2,-572 # ffffffffc0201988 <etext+0x254>
ffffffffc0200bcc:	12500593          	li	a1,293
ffffffffc0200bd0:	00001517          	auipc	a0,0x1
ffffffffc0200bd4:	dd050513          	addi	a0,a0,-560 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200bd8:	df4ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(nr_free == 0);
ffffffffc0200bdc:	00001697          	auipc	a3,0x1
ffffffffc0200be0:	f9468693          	addi	a3,a3,-108 # ffffffffc0201b70 <etext+0x43c>
ffffffffc0200be4:	00001617          	auipc	a2,0x1
ffffffffc0200be8:	da460613          	addi	a2,a2,-604 # ffffffffc0201988 <etext+0x254>
ffffffffc0200bec:	11a00593          	li	a1,282
ffffffffc0200bf0:	00001517          	auipc	a0,0x1
ffffffffc0200bf4:	db050513          	addi	a0,a0,-592 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200bf8:	dd4ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200bfc:	00001697          	auipc	a3,0x1
ffffffffc0200c00:	f1468693          	addi	a3,a3,-236 # ffffffffc0201b10 <etext+0x3dc>
ffffffffc0200c04:	00001617          	auipc	a2,0x1
ffffffffc0200c08:	d8460613          	addi	a2,a2,-636 # ffffffffc0201988 <etext+0x254>
ffffffffc0200c0c:	11800593          	li	a1,280
ffffffffc0200c10:	00001517          	auipc	a0,0x1
ffffffffc0200c14:	d9050513          	addi	a0,a0,-624 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200c18:	db4ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200c1c:	00001697          	auipc	a3,0x1
ffffffffc0200c20:	eb468693          	addi	a3,a3,-332 # ffffffffc0201ad0 <etext+0x39c>
ffffffffc0200c24:	00001617          	auipc	a2,0x1
ffffffffc0200c28:	d6460613          	addi	a2,a2,-668 # ffffffffc0201988 <etext+0x254>
ffffffffc0200c2c:	0c100593          	li	a1,193
ffffffffc0200c30:	00001517          	auipc	a0,0x1
ffffffffc0200c34:	d7050513          	addi	a0,a0,-656 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200c38:	d94ff0ef          	jal	ffffffffc02001cc <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0200c3c:	00001697          	auipc	a3,0x1
ffffffffc0200c40:	05468693          	addi	a3,a3,84 # ffffffffc0201c90 <etext+0x55c>
ffffffffc0200c44:	00001617          	auipc	a2,0x1
ffffffffc0200c48:	d4460613          	addi	a2,a2,-700 # ffffffffc0201988 <etext+0x254>
ffffffffc0200c4c:	11200593          	li	a1,274
ffffffffc0200c50:	00001517          	auipc	a0,0x1
ffffffffc0200c54:	d5050513          	addi	a0,a0,-688 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200c58:	d74ff0ef          	jal	ffffffffc02001cc <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0200c5c:	00001697          	auipc	a3,0x1
ffffffffc0200c60:	01468693          	addi	a3,a3,20 # ffffffffc0201c70 <etext+0x53c>
ffffffffc0200c64:	00001617          	auipc	a2,0x1
ffffffffc0200c68:	d2460613          	addi	a2,a2,-732 # ffffffffc0201988 <etext+0x254>
ffffffffc0200c6c:	11000593          	li	a1,272
ffffffffc0200c70:	00001517          	auipc	a0,0x1
ffffffffc0200c74:	d3050513          	addi	a0,a0,-720 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200c78:	d54ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0200c7c:	00001697          	auipc	a3,0x1
ffffffffc0200c80:	fcc68693          	addi	a3,a3,-52 # ffffffffc0201c48 <etext+0x514>
ffffffffc0200c84:	00001617          	auipc	a2,0x1
ffffffffc0200c88:	d0460613          	addi	a2,a2,-764 # ffffffffc0201988 <etext+0x254>
ffffffffc0200c8c:	10e00593          	li	a1,270
ffffffffc0200c90:	00001517          	auipc	a0,0x1
ffffffffc0200c94:	d1050513          	addi	a0,a0,-752 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200c98:	d34ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0200c9c:	00001697          	auipc	a3,0x1
ffffffffc0200ca0:	f8468693          	addi	a3,a3,-124 # ffffffffc0201c20 <etext+0x4ec>
ffffffffc0200ca4:	00001617          	auipc	a2,0x1
ffffffffc0200ca8:	ce460613          	addi	a2,a2,-796 # ffffffffc0201988 <etext+0x254>
ffffffffc0200cac:	10d00593          	li	a1,269
ffffffffc0200cb0:	00001517          	auipc	a0,0x1
ffffffffc0200cb4:	cf050513          	addi	a0,a0,-784 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200cb8:	d14ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(p0 + 2 == p1);
ffffffffc0200cbc:	00001697          	auipc	a3,0x1
ffffffffc0200cc0:	f5468693          	addi	a3,a3,-172 # ffffffffc0201c10 <etext+0x4dc>
ffffffffc0200cc4:	00001617          	auipc	a2,0x1
ffffffffc0200cc8:	cc460613          	addi	a2,a2,-828 # ffffffffc0201988 <etext+0x254>
ffffffffc0200ccc:	10800593          	li	a1,264
ffffffffc0200cd0:	00001517          	auipc	a0,0x1
ffffffffc0200cd4:	cd050513          	addi	a0,a0,-816 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200cd8:	cf4ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200cdc:	00001697          	auipc	a3,0x1
ffffffffc0200ce0:	e3468693          	addi	a3,a3,-460 # ffffffffc0201b10 <etext+0x3dc>
ffffffffc0200ce4:	00001617          	auipc	a2,0x1
ffffffffc0200ce8:	ca460613          	addi	a2,a2,-860 # ffffffffc0201988 <etext+0x254>
ffffffffc0200cec:	10700593          	li	a1,263
ffffffffc0200cf0:	00001517          	auipc	a0,0x1
ffffffffc0200cf4:	cb050513          	addi	a0,a0,-848 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200cf8:	cd4ff0ef          	jal	ffffffffc02001cc <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200cfc:	00001697          	auipc	a3,0x1
ffffffffc0200d00:	ef468693          	addi	a3,a3,-268 # ffffffffc0201bf0 <etext+0x4bc>
ffffffffc0200d04:	00001617          	auipc	a2,0x1
ffffffffc0200d08:	c8460613          	addi	a2,a2,-892 # ffffffffc0201988 <etext+0x254>
ffffffffc0200d0c:	10600593          	li	a1,262
ffffffffc0200d10:	00001517          	auipc	a0,0x1
ffffffffc0200d14:	c9050513          	addi	a0,a0,-880 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200d18:	cb4ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200d1c:	00001697          	auipc	a3,0x1
ffffffffc0200d20:	ea468693          	addi	a3,a3,-348 # ffffffffc0201bc0 <etext+0x48c>
ffffffffc0200d24:	00001617          	auipc	a2,0x1
ffffffffc0200d28:	c6460613          	addi	a2,a2,-924 # ffffffffc0201988 <etext+0x254>
ffffffffc0200d2c:	10500593          	li	a1,261
ffffffffc0200d30:	00001517          	auipc	a0,0x1
ffffffffc0200d34:	c7050513          	addi	a0,a0,-912 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200d38:	c94ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0200d3c:	00001697          	auipc	a3,0x1
ffffffffc0200d40:	e6c68693          	addi	a3,a3,-404 # ffffffffc0201ba8 <etext+0x474>
ffffffffc0200d44:	00001617          	auipc	a2,0x1
ffffffffc0200d48:	c4460613          	addi	a2,a2,-956 # ffffffffc0201988 <etext+0x254>
ffffffffc0200d4c:	10400593          	li	a1,260
ffffffffc0200d50:	00001517          	auipc	a0,0x1
ffffffffc0200d54:	c5050513          	addi	a0,a0,-944 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200d58:	c74ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200d5c:	00001697          	auipc	a3,0x1
ffffffffc0200d60:	db468693          	addi	a3,a3,-588 # ffffffffc0201b10 <etext+0x3dc>
ffffffffc0200d64:	00001617          	auipc	a2,0x1
ffffffffc0200d68:	c2460613          	addi	a2,a2,-988 # ffffffffc0201988 <etext+0x254>
ffffffffc0200d6c:	0fe00593          	li	a1,254
ffffffffc0200d70:	00001517          	auipc	a0,0x1
ffffffffc0200d74:	c3050513          	addi	a0,a0,-976 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200d78:	c54ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(!PageProperty(p0));
ffffffffc0200d7c:	00001697          	auipc	a3,0x1
ffffffffc0200d80:	e1468693          	addi	a3,a3,-492 # ffffffffc0201b90 <etext+0x45c>
ffffffffc0200d84:	00001617          	auipc	a2,0x1
ffffffffc0200d88:	c0460613          	addi	a2,a2,-1020 # ffffffffc0201988 <etext+0x254>
ffffffffc0200d8c:	0f900593          	li	a1,249
ffffffffc0200d90:	00001517          	auipc	a0,0x1
ffffffffc0200d94:	c1050513          	addi	a0,a0,-1008 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200d98:	c34ff0ef          	jal	ffffffffc02001cc <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200d9c:	00001697          	auipc	a3,0x1
ffffffffc0200da0:	f1468693          	addi	a3,a3,-236 # ffffffffc0201cb0 <etext+0x57c>
ffffffffc0200da4:	00001617          	auipc	a2,0x1
ffffffffc0200da8:	be460613          	addi	a2,a2,-1052 # ffffffffc0201988 <etext+0x254>
ffffffffc0200dac:	11700593          	li	a1,279
ffffffffc0200db0:	00001517          	auipc	a0,0x1
ffffffffc0200db4:	bf050513          	addi	a0,a0,-1040 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200db8:	c14ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(total == 0);
ffffffffc0200dbc:	00001697          	auipc	a3,0x1
ffffffffc0200dc0:	f2468693          	addi	a3,a3,-220 # ffffffffc0201ce0 <etext+0x5ac>
ffffffffc0200dc4:	00001617          	auipc	a2,0x1
ffffffffc0200dc8:	bc460613          	addi	a2,a2,-1084 # ffffffffc0201988 <etext+0x254>
ffffffffc0200dcc:	12600593          	li	a1,294
ffffffffc0200dd0:	00001517          	auipc	a0,0x1
ffffffffc0200dd4:	bd050513          	addi	a0,a0,-1072 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200dd8:	bf4ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(total == nr_free_pages());
ffffffffc0200ddc:	00001697          	auipc	a3,0x1
ffffffffc0200de0:	bec68693          	addi	a3,a3,-1044 # ffffffffc02019c8 <etext+0x294>
ffffffffc0200de4:	00001617          	auipc	a2,0x1
ffffffffc0200de8:	ba460613          	addi	a2,a2,-1116 # ffffffffc0201988 <etext+0x254>
ffffffffc0200dec:	0f300593          	li	a1,243
ffffffffc0200df0:	00001517          	auipc	a0,0x1
ffffffffc0200df4:	bb050513          	addi	a0,a0,-1104 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200df8:	bd4ff0ef          	jal	ffffffffc02001cc <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200dfc:	00001697          	auipc	a3,0x1
ffffffffc0200e00:	c0c68693          	addi	a3,a3,-1012 # ffffffffc0201a08 <etext+0x2d4>
ffffffffc0200e04:	00001617          	auipc	a2,0x1
ffffffffc0200e08:	b8460613          	addi	a2,a2,-1148 # ffffffffc0201988 <etext+0x254>
ffffffffc0200e0c:	0ba00593          	li	a1,186
ffffffffc0200e10:	00001517          	auipc	a0,0x1
ffffffffc0200e14:	b9050513          	addi	a0,a0,-1136 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200e18:	bb4ff0ef          	jal	ffffffffc02001cc <__panic>

ffffffffc0200e1c <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc0200e1c:	1141                	addi	sp,sp,-16
ffffffffc0200e1e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200e20:	14058c63          	beqz	a1,ffffffffc0200f78 <default_free_pages+0x15c>
    for (; p != base + n; p ++) {
ffffffffc0200e24:	00259713          	slli	a4,a1,0x2
ffffffffc0200e28:	972e                	add	a4,a4,a1
ffffffffc0200e2a:	070e                	slli	a4,a4,0x3
ffffffffc0200e2c:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0200e30:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0200e32:	cf09                	beqz	a4,ffffffffc0200e4c <default_free_pages+0x30>
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200e34:	6798                	ld	a4,8(a5)
ffffffffc0200e36:	8b0d                	andi	a4,a4,3
ffffffffc0200e38:	12071063          	bnez	a4,ffffffffc0200f58 <default_free_pages+0x13c>
        p->flags = 0;
ffffffffc0200e3c:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200e40:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0200e44:	02878793          	addi	a5,a5,40
ffffffffc0200e48:	fed796e3          	bne	a5,a3,ffffffffc0200e34 <default_free_pages+0x18>
    SetPageProperty(base);
ffffffffc0200e4c:	00853883          	ld	a7,8(a0)
    nr_free += n;
ffffffffc0200e50:	00005697          	auipc	a3,0x5
ffffffffc0200e54:	1c868693          	addi	a3,a3,456 # ffffffffc0206018 <free_area>
ffffffffc0200e58:	4a98                	lw	a4,16(a3)
    base->property = n;
ffffffffc0200e5a:	2581                	sext.w	a1,a1
    return list->next == list;
ffffffffc0200e5c:	669c                	ld	a5,8(a3)
    SetPageProperty(base);
ffffffffc0200e5e:	0028e613          	ori	a2,a7,2
    base->property = n;
ffffffffc0200e62:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0200e64:	e510                	sd	a2,8(a0)
    nr_free += n;
ffffffffc0200e66:	9f2d                	addw	a4,a4,a1
ffffffffc0200e68:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0200e6a:	0ad78763          	beq	a5,a3,ffffffffc0200f18 <default_free_pages+0xfc>
            struct Page* page = le2page(le, page_link);
ffffffffc0200e6e:	fe878713          	addi	a4,a5,-24
ffffffffc0200e72:	4801                	li	a6,0
ffffffffc0200e74:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0200e78:	00e56a63          	bltu	a0,a4,ffffffffc0200e8c <default_free_pages+0x70>
    return listelm->next;
ffffffffc0200e7c:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0200e7e:	06d70563          	beq	a4,a3,ffffffffc0200ee8 <default_free_pages+0xcc>
    struct Page *p = base;
ffffffffc0200e82:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0200e84:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0200e88:	fee57ae3          	bgeu	a0,a4,ffffffffc0200e7c <default_free_pages+0x60>
ffffffffc0200e8c:	00080463          	beqz	a6,ffffffffc0200e94 <default_free_pages+0x78>
ffffffffc0200e90:	0066b023          	sd	t1,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0200e94:	0007b803          	ld	a6,0(a5)
    prev->next = next->prev = elm;
ffffffffc0200e98:	e390                	sd	a2,0(a5)
ffffffffc0200e9a:	00c83423          	sd	a2,8(a6)
    elm->next = next;
ffffffffc0200e9e:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200ea0:	01053c23          	sd	a6,24(a0)
    if (le != &free_list) {
ffffffffc0200ea4:	02d80063          	beq	a6,a3,ffffffffc0200ec4 <default_free_pages+0xa8>
        if (p + p->property == base) {
ffffffffc0200ea8:	ff882e03          	lw	t3,-8(a6)
        p = le2page(le, page_link);
ffffffffc0200eac:	fe880313          	addi	t1,a6,-24
        if (p + p->property == base) {
ffffffffc0200eb0:	020e1613          	slli	a2,t3,0x20
ffffffffc0200eb4:	9201                	srli	a2,a2,0x20
ffffffffc0200eb6:	00261713          	slli	a4,a2,0x2
ffffffffc0200eba:	9732                	add	a4,a4,a2
ffffffffc0200ebc:	070e                	slli	a4,a4,0x3
ffffffffc0200ebe:	971a                	add	a4,a4,t1
ffffffffc0200ec0:	02e50e63          	beq	a0,a4,ffffffffc0200efc <default_free_pages+0xe0>
    if (le != &free_list) {
ffffffffc0200ec4:	00d78f63          	beq	a5,a3,ffffffffc0200ee2 <default_free_pages+0xc6>
        if (base + base->property == p) {
ffffffffc0200ec8:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc0200eca:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p) {
ffffffffc0200ece:	02059613          	slli	a2,a1,0x20
ffffffffc0200ed2:	9201                	srli	a2,a2,0x20
ffffffffc0200ed4:	00261713          	slli	a4,a2,0x2
ffffffffc0200ed8:	9732                	add	a4,a4,a2
ffffffffc0200eda:	070e                	slli	a4,a4,0x3
ffffffffc0200edc:	972a                	add	a4,a4,a0
ffffffffc0200ede:	04e68a63          	beq	a3,a4,ffffffffc0200f32 <default_free_pages+0x116>
}
ffffffffc0200ee2:	60a2                	ld	ra,8(sp)
ffffffffc0200ee4:	0141                	addi	sp,sp,16
ffffffffc0200ee6:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0200ee8:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0200eea:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0200eec:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0200eee:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0200ef0:	8332                	mv	t1,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0200ef2:	02d70c63          	beq	a4,a3,ffffffffc0200f2a <default_free_pages+0x10e>
ffffffffc0200ef6:	4805                	li	a6,1
    struct Page *p = base;
ffffffffc0200ef8:	87ba                	mv	a5,a4
ffffffffc0200efa:	b769                	j	ffffffffc0200e84 <default_free_pages+0x68>
            p->property += base->property;
ffffffffc0200efc:	01c585bb          	addw	a1,a1,t3
ffffffffc0200f00:	feb82c23          	sw	a1,-8(a6)
            ClearPageProperty(base);
ffffffffc0200f04:	ffd8f893          	andi	a7,a7,-3
ffffffffc0200f08:	01153423          	sd	a7,8(a0)
    prev->next = next;
ffffffffc0200f0c:	00f83423          	sd	a5,8(a6)
    next->prev = prev;
ffffffffc0200f10:	0107b023          	sd	a6,0(a5)
            base = p;
ffffffffc0200f14:	851a                	mv	a0,t1
ffffffffc0200f16:	b77d                	j	ffffffffc0200ec4 <default_free_pages+0xa8>
}
ffffffffc0200f18:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0200f1a:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0200f1e:	e398                	sd	a4,0(a5)
ffffffffc0200f20:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc0200f22:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200f24:	ed1c                	sd	a5,24(a0)
}
ffffffffc0200f26:	0141                	addi	sp,sp,16
ffffffffc0200f28:	8082                	ret
    return listelm->prev;
ffffffffc0200f2a:	883e                	mv	a6,a5
ffffffffc0200f2c:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200f2e:	87b6                	mv	a5,a3
ffffffffc0200f30:	bf95                	j	ffffffffc0200ea4 <default_free_pages+0x88>
            base->property += p->property;
ffffffffc0200f32:	ff87a683          	lw	a3,-8(a5)
            ClearPageProperty(p);
ffffffffc0200f36:	ff07b703          	ld	a4,-16(a5)
ffffffffc0200f3a:	0007b803          	ld	a6,0(a5)
ffffffffc0200f3e:	6790                	ld	a2,8(a5)
            base->property += p->property;
ffffffffc0200f40:	9ead                	addw	a3,a3,a1
ffffffffc0200f42:	c914                	sw	a3,16(a0)
            ClearPageProperty(p);
ffffffffc0200f44:	9b75                	andi	a4,a4,-3
ffffffffc0200f46:	fee7b823          	sd	a4,-16(a5)
}
ffffffffc0200f4a:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0200f4c:	00c83423          	sd	a2,8(a6)
    next->prev = prev;
ffffffffc0200f50:	01063023          	sd	a6,0(a2)
ffffffffc0200f54:	0141                	addi	sp,sp,16
ffffffffc0200f56:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200f58:	00001697          	auipc	a3,0x1
ffffffffc0200f5c:	d9868693          	addi	a3,a3,-616 # ffffffffc0201cf0 <etext+0x5bc>
ffffffffc0200f60:	00001617          	auipc	a2,0x1
ffffffffc0200f64:	a2860613          	addi	a2,a2,-1496 # ffffffffc0201988 <etext+0x254>
ffffffffc0200f68:	08300593          	li	a1,131
ffffffffc0200f6c:	00001517          	auipc	a0,0x1
ffffffffc0200f70:	a3450513          	addi	a0,a0,-1484 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200f74:	a58ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(n > 0);
ffffffffc0200f78:	00001697          	auipc	a3,0x1
ffffffffc0200f7c:	a0868693          	addi	a3,a3,-1528 # ffffffffc0201980 <etext+0x24c>
ffffffffc0200f80:	00001617          	auipc	a2,0x1
ffffffffc0200f84:	a0860613          	addi	a2,a2,-1528 # ffffffffc0201988 <etext+0x254>
ffffffffc0200f88:	08000593          	li	a1,128
ffffffffc0200f8c:	00001517          	auipc	a0,0x1
ffffffffc0200f90:	a1450513          	addi	a0,a0,-1516 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0200f94:	a38ff0ef          	jal	ffffffffc02001cc <__panic>

ffffffffc0200f98 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0200f98:	1141                	addi	sp,sp,-16
ffffffffc0200f9a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200f9c:	c5f9                	beqz	a1,ffffffffc020106a <default_init_memmap+0xd2>
    for (; p != base + n; p ++) {
ffffffffc0200f9e:	00259713          	slli	a4,a1,0x2
ffffffffc0200fa2:	972e                	add	a4,a4,a1
ffffffffc0200fa4:	070e                	slli	a4,a4,0x3
ffffffffc0200fa6:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0200faa:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0200fac:	cf11                	beqz	a4,ffffffffc0200fc8 <default_init_memmap+0x30>
        assert(PageReserved(p));
ffffffffc0200fae:	6798                	ld	a4,8(a5)
ffffffffc0200fb0:	8b05                	andi	a4,a4,1
ffffffffc0200fb2:	cf41                	beqz	a4,ffffffffc020104a <default_init_memmap+0xb2>
        p->flags = p->property = 0;
ffffffffc0200fb4:	0007a823          	sw	zero,16(a5)
ffffffffc0200fb8:	0007b423          	sd	zero,8(a5)
ffffffffc0200fbc:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0200fc0:	02878793          	addi	a5,a5,40
ffffffffc0200fc4:	fed795e3          	bne	a5,a3,ffffffffc0200fae <default_init_memmap+0x16>
    SetPageProperty(base);
ffffffffc0200fc8:	6510                	ld	a2,8(a0)
    nr_free += n;
ffffffffc0200fca:	00005697          	auipc	a3,0x5
ffffffffc0200fce:	04e68693          	addi	a3,a3,78 # ffffffffc0206018 <free_area>
ffffffffc0200fd2:	4a98                	lw	a4,16(a3)
    base->property = n;
ffffffffc0200fd4:	2581                	sext.w	a1,a1
    return list->next == list;
ffffffffc0200fd6:	669c                	ld	a5,8(a3)
    SetPageProperty(base);
ffffffffc0200fd8:	00266613          	ori	a2,a2,2
    base->property = n;
ffffffffc0200fdc:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0200fde:	e510                	sd	a2,8(a0)
    nr_free += n;
ffffffffc0200fe0:	9f2d                	addw	a4,a4,a1
ffffffffc0200fe2:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0200fe4:	04d78663          	beq	a5,a3,ffffffffc0201030 <default_init_memmap+0x98>
            struct Page* page = le2page(le, page_link);
ffffffffc0200fe8:	fe878713          	addi	a4,a5,-24
ffffffffc0200fec:	4581                	li	a1,0
ffffffffc0200fee:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0200ff2:	00e56a63          	bltu	a0,a4,ffffffffc0201006 <default_init_memmap+0x6e>
    return listelm->next;
ffffffffc0200ff6:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0200ff8:	02d70263          	beq	a4,a3,ffffffffc020101c <default_init_memmap+0x84>
    struct Page *p = base;
ffffffffc0200ffc:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0200ffe:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201002:	fee57ae3          	bgeu	a0,a4,ffffffffc0200ff6 <default_init_memmap+0x5e>
ffffffffc0201006:	c199                	beqz	a1,ffffffffc020100c <default_init_memmap+0x74>
ffffffffc0201008:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020100c:	6398                	ld	a4,0(a5)
}
ffffffffc020100e:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201010:	e390                	sd	a2,0(a5)
ffffffffc0201012:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201014:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201016:	ed18                	sd	a4,24(a0)
ffffffffc0201018:	0141                	addi	sp,sp,16
ffffffffc020101a:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020101c:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020101e:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201020:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201022:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201024:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201026:	00d70e63          	beq	a4,a3,ffffffffc0201042 <default_init_memmap+0xaa>
ffffffffc020102a:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc020102c:	87ba                	mv	a5,a4
ffffffffc020102e:	bfc1                	j	ffffffffc0200ffe <default_init_memmap+0x66>
}
ffffffffc0201030:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201032:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0201036:	e398                	sd	a4,0(a5)
ffffffffc0201038:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc020103a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020103c:	ed1c                	sd	a5,24(a0)
}
ffffffffc020103e:	0141                	addi	sp,sp,16
ffffffffc0201040:	8082                	ret
ffffffffc0201042:	60a2                	ld	ra,8(sp)
ffffffffc0201044:	e290                	sd	a2,0(a3)
ffffffffc0201046:	0141                	addi	sp,sp,16
ffffffffc0201048:	8082                	ret
        assert(PageReserved(p));
ffffffffc020104a:	00001697          	auipc	a3,0x1
ffffffffc020104e:	cce68693          	addi	a3,a3,-818 # ffffffffc0201d18 <etext+0x5e4>
ffffffffc0201052:	00001617          	auipc	a2,0x1
ffffffffc0201056:	93660613          	addi	a2,a2,-1738 # ffffffffc0201988 <etext+0x254>
ffffffffc020105a:	04900593          	li	a1,73
ffffffffc020105e:	00001517          	auipc	a0,0x1
ffffffffc0201062:	94250513          	addi	a0,a0,-1726 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0201066:	966ff0ef          	jal	ffffffffc02001cc <__panic>
    assert(n > 0);
ffffffffc020106a:	00001697          	auipc	a3,0x1
ffffffffc020106e:	91668693          	addi	a3,a3,-1770 # ffffffffc0201980 <etext+0x24c>
ffffffffc0201072:	00001617          	auipc	a2,0x1
ffffffffc0201076:	91660613          	addi	a2,a2,-1770 # ffffffffc0201988 <etext+0x254>
ffffffffc020107a:	04600593          	li	a1,70
ffffffffc020107e:	00001517          	auipc	a0,0x1
ffffffffc0201082:	92250513          	addi	a0,a0,-1758 # ffffffffc02019a0 <etext+0x26c>
ffffffffc0201086:	946ff0ef          	jal	ffffffffc02001cc <__panic>

ffffffffc020108a <alloc_pages>:
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
    return pmm_manager->alloc_pages(n);
ffffffffc020108a:	00005797          	auipc	a5,0x5
ffffffffc020108e:	fbe7b783          	ld	a5,-66(a5) # ffffffffc0206048 <pmm_manager>
ffffffffc0201092:	6f9c                	ld	a5,24(a5)
ffffffffc0201094:	8782                	jr	a5

ffffffffc0201096 <free_pages>:
}

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    pmm_manager->free_pages(base, n);
ffffffffc0201096:	00005797          	auipc	a5,0x5
ffffffffc020109a:	fb27b783          	ld	a5,-78(a5) # ffffffffc0206048 <pmm_manager>
ffffffffc020109e:	739c                	ld	a5,32(a5)
ffffffffc02010a0:	8782                	jr	a5

ffffffffc02010a2 <nr_free_pages>:
}

// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t nr_free_pages(void) {
    return pmm_manager->nr_free_pages();
ffffffffc02010a2:	00005797          	auipc	a5,0x5
ffffffffc02010a6:	fa67b783          	ld	a5,-90(a5) # ffffffffc0206048 <pmm_manager>
ffffffffc02010aa:	779c                	ld	a5,40(a5)
ffffffffc02010ac:	8782                	jr	a5

ffffffffc02010ae <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc02010ae:	00001797          	auipc	a5,0x1
ffffffffc02010b2:	eb278793          	addi	a5,a5,-334 # ffffffffc0201f60 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02010b6:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc02010b8:	7179                	addi	sp,sp,-48
ffffffffc02010ba:	f406                	sd	ra,40(sp)
ffffffffc02010bc:	f022                	sd	s0,32(sp)
ffffffffc02010be:	ec26                	sd	s1,24(sp)
ffffffffc02010c0:	e44e                	sd	s3,8(sp)
ffffffffc02010c2:	e84a                	sd	s2,16(sp)
ffffffffc02010c4:	e052                	sd	s4,0(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc02010c6:	00005417          	auipc	s0,0x5
ffffffffc02010ca:	f8240413          	addi	s0,s0,-126 # ffffffffc0206048 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02010ce:	00001517          	auipc	a0,0x1
ffffffffc02010d2:	c7250513          	addi	a0,a0,-910 # ffffffffc0201d40 <etext+0x60c>
    pmm_manager = &default_pmm_manager;
ffffffffc02010d6:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02010d8:	872ff0ef          	jal	ffffffffc020014a <cprintf>
    pmm_manager->init();
ffffffffc02010dc:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02010de:	00005497          	auipc	s1,0x5
ffffffffc02010e2:	f8248493          	addi	s1,s1,-126 # ffffffffc0206060 <va_pa_offset>
    pmm_manager->init();
ffffffffc02010e6:	679c                	ld	a5,8(a5)
ffffffffc02010e8:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02010ea:	57f5                	li	a5,-3
ffffffffc02010ec:	07fa                	slli	a5,a5,0x1e
ffffffffc02010ee:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc02010f0:	ca4ff0ef          	jal	ffffffffc0200594 <get_memory_base>
ffffffffc02010f4:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc02010f6:	ca8ff0ef          	jal	ffffffffc020059e <get_memory_size>
    if (mem_size == 0) {
ffffffffc02010fa:	14050f63          	beqz	a0,ffffffffc0201258 <pmm_init+0x1aa>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02010fe:	892a                	mv	s2,a0
    cprintf("physcial memory map:\n");
ffffffffc0201100:	00001517          	auipc	a0,0x1
ffffffffc0201104:	c8850513          	addi	a0,a0,-888 # ffffffffc0201d88 <etext+0x654>
ffffffffc0201108:	842ff0ef          	jal	ffffffffc020014a <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc020110c:	01298a33          	add	s4,s3,s2
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0201110:	864e                	mv	a2,s3
ffffffffc0201112:	fffa0693          	addi	a3,s4,-1
ffffffffc0201116:	85ca                	mv	a1,s2
ffffffffc0201118:	00001517          	auipc	a0,0x1
ffffffffc020111c:	c8850513          	addi	a0,a0,-888 # ffffffffc0201da0 <etext+0x66c>
ffffffffc0201120:	82aff0ef          	jal	ffffffffc020014a <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc0201124:	c80007b7          	lui	a5,0xc8000
ffffffffc0201128:	8652                	mv	a2,s4
ffffffffc020112a:	0d47e663          	bltu	a5,s4,ffffffffc02011f6 <pmm_init+0x148>
ffffffffc020112e:	77fd                	lui	a5,0xfffff
ffffffffc0201130:	00006817          	auipc	a6,0x6
ffffffffc0201134:	f4780813          	addi	a6,a6,-185 # ffffffffc0207077 <end+0xfff>
ffffffffc0201138:	00f87833          	and	a6,a6,a5
    npage = maxpa / PGSIZE;
ffffffffc020113c:	8231                	srli	a2,a2,0xc
ffffffffc020113e:	00005797          	auipc	a5,0x5
ffffffffc0201142:	f2c7b523          	sd	a2,-214(a5) # ffffffffc0206068 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201146:	00005797          	auipc	a5,0x5
ffffffffc020114a:	f307b523          	sd	a6,-214(a5) # ffffffffc0206070 <pages>
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020114e:	000807b7          	lui	a5,0x80
ffffffffc0201152:	002005b7          	lui	a1,0x200
ffffffffc0201156:	02f60563          	beq	a2,a5,ffffffffc0201180 <pmm_init+0xd2>
ffffffffc020115a:	00261593          	slli	a1,a2,0x2
ffffffffc020115e:	00c587b3          	add	a5,a1,a2
ffffffffc0201162:	fec006b7          	lui	a3,0xfec00
ffffffffc0201166:	078e                	slli	a5,a5,0x3
ffffffffc0201168:	96c2                	add	a3,a3,a6
ffffffffc020116a:	96be                	add	a3,a3,a5
ffffffffc020116c:	87c2                	mv	a5,a6
        SetPageReserved(pages + i);
ffffffffc020116e:	6798                	ld	a4,8(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201170:	02878793          	addi	a5,a5,40 # 80028 <kern_entry-0xffffffffc017ffd8>
        SetPageReserved(pages + i);
ffffffffc0201174:	00176713          	ori	a4,a4,1
ffffffffc0201178:	fee7b023          	sd	a4,-32(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020117c:	fed799e3          	bne	a5,a3,ffffffffc020116e <pmm_init+0xc0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201180:	95b2                	add	a1,a1,a2
ffffffffc0201182:	fec006b7          	lui	a3,0xfec00
ffffffffc0201186:	96c2                	add	a3,a3,a6
ffffffffc0201188:	058e                	slli	a1,a1,0x3
ffffffffc020118a:	96ae                	add	a3,a3,a1
ffffffffc020118c:	c02007b7          	lui	a5,0xc0200
ffffffffc0201190:	0af6e863          	bltu	a3,a5,ffffffffc0201240 <pmm_init+0x192>
ffffffffc0201194:	6098                	ld	a4,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0201196:	77fd                	lui	a5,0xfffff
ffffffffc0201198:	00fa75b3          	and	a1,s4,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020119c:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc020119e:	04b6ef63          	bltu	a3,a1,ffffffffc02011fc <pmm_init+0x14e>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc02011a2:	601c                	ld	a5,0(s0)
ffffffffc02011a4:	7b9c                	ld	a5,48(a5)
ffffffffc02011a6:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02011a8:	00001517          	auipc	a0,0x1
ffffffffc02011ac:	c8050513          	addi	a0,a0,-896 # ffffffffc0201e28 <etext+0x6f4>
ffffffffc02011b0:	f9bfe0ef          	jal	ffffffffc020014a <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc02011b4:	00004597          	auipc	a1,0x4
ffffffffc02011b8:	e4c58593          	addi	a1,a1,-436 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc02011bc:	00005797          	auipc	a5,0x5
ffffffffc02011c0:	e8b7be23          	sd	a1,-356(a5) # ffffffffc0206058 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc02011c4:	c02007b7          	lui	a5,0xc0200
ffffffffc02011c8:	0af5e463          	bltu	a1,a5,ffffffffc0201270 <pmm_init+0x1c2>
ffffffffc02011cc:	609c                	ld	a5,0(s1)
}
ffffffffc02011ce:	7402                	ld	s0,32(sp)
ffffffffc02011d0:	70a2                	ld	ra,40(sp)
ffffffffc02011d2:	64e2                	ld	s1,24(sp)
ffffffffc02011d4:	6942                	ld	s2,16(sp)
ffffffffc02011d6:	69a2                	ld	s3,8(sp)
ffffffffc02011d8:	6a02                	ld	s4,0(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc02011da:	40f586b3          	sub	a3,a1,a5
ffffffffc02011de:	00005797          	auipc	a5,0x5
ffffffffc02011e2:	e6d7b923          	sd	a3,-398(a5) # ffffffffc0206050 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02011e6:	00001517          	auipc	a0,0x1
ffffffffc02011ea:	c6250513          	addi	a0,a0,-926 # ffffffffc0201e48 <etext+0x714>
ffffffffc02011ee:	8636                	mv	a2,a3
}
ffffffffc02011f0:	6145                	addi	sp,sp,48
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02011f2:	f59fe06f          	j	ffffffffc020014a <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc02011f6:	c8000637          	lui	a2,0xc8000
ffffffffc02011fa:	bf15                	j	ffffffffc020112e <pmm_init+0x80>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02011fc:	6705                	lui	a4,0x1
ffffffffc02011fe:	177d                	addi	a4,a4,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc0201200:	96ba                	add	a3,a3,a4
ffffffffc0201202:	8efd                	and	a3,a3,a5
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0201204:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201208:	02c7f063          	bgeu	a5,a2,ffffffffc0201228 <pmm_init+0x17a>
    pmm_manager->init_memmap(base, n);
ffffffffc020120c:	6018                	ld	a4,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc020120e:	fff80637          	lui	a2,0xfff80
ffffffffc0201212:	97b2                	add	a5,a5,a2
ffffffffc0201214:	00279513          	slli	a0,a5,0x2
ffffffffc0201218:	953e                	add	a0,a0,a5
ffffffffc020121a:	6b1c                	ld	a5,16(a4)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020121c:	8d95                	sub	a1,a1,a3
ffffffffc020121e:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0201220:	81b1                	srli	a1,a1,0xc
ffffffffc0201222:	9542                	add	a0,a0,a6
ffffffffc0201224:	9782                	jalr	a5
}
ffffffffc0201226:	bfb5                	j	ffffffffc02011a2 <pmm_init+0xf4>
        panic("pa2page called with invalid pa");
ffffffffc0201228:	00001617          	auipc	a2,0x1
ffffffffc020122c:	bd060613          	addi	a2,a2,-1072 # ffffffffc0201df8 <etext+0x6c4>
ffffffffc0201230:	06a00593          	li	a1,106
ffffffffc0201234:	00001517          	auipc	a0,0x1
ffffffffc0201238:	be450513          	addi	a0,a0,-1052 # ffffffffc0201e18 <etext+0x6e4>
ffffffffc020123c:	f91fe0ef          	jal	ffffffffc02001cc <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201240:	00001617          	auipc	a2,0x1
ffffffffc0201244:	b9060613          	addi	a2,a2,-1136 # ffffffffc0201dd0 <etext+0x69c>
ffffffffc0201248:	05e00593          	li	a1,94
ffffffffc020124c:	00001517          	auipc	a0,0x1
ffffffffc0201250:	b2c50513          	addi	a0,a0,-1236 # ffffffffc0201d78 <etext+0x644>
ffffffffc0201254:	f79fe0ef          	jal	ffffffffc02001cc <__panic>
        panic("DTB memory info not available");
ffffffffc0201258:	00001617          	auipc	a2,0x1
ffffffffc020125c:	b0060613          	addi	a2,a2,-1280 # ffffffffc0201d58 <etext+0x624>
ffffffffc0201260:	04600593          	li	a1,70
ffffffffc0201264:	00001517          	auipc	a0,0x1
ffffffffc0201268:	b1450513          	addi	a0,a0,-1260 # ffffffffc0201d78 <etext+0x644>
ffffffffc020126c:	f61fe0ef          	jal	ffffffffc02001cc <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201270:	86ae                	mv	a3,a1
ffffffffc0201272:	00001617          	auipc	a2,0x1
ffffffffc0201276:	b5e60613          	addi	a2,a2,-1186 # ffffffffc0201dd0 <etext+0x69c>
ffffffffc020127a:	07900593          	li	a1,121
ffffffffc020127e:	00001517          	auipc	a0,0x1
ffffffffc0201282:	afa50513          	addi	a0,a0,-1286 # ffffffffc0201d78 <etext+0x644>
ffffffffc0201286:	f47fe0ef          	jal	ffffffffc02001cc <__panic>

ffffffffc020128a <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020128a:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020128e:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0201290:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201294:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201296:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020129a:	f022                	sd	s0,32(sp)
ffffffffc020129c:	ec26                	sd	s1,24(sp)
ffffffffc020129e:	e84a                	sd	s2,16(sp)
ffffffffc02012a0:	f406                	sd	ra,40(sp)
ffffffffc02012a2:	84aa                	mv	s1,a0
ffffffffc02012a4:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02012a6:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc02012aa:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc02012ac:	05067063          	bgeu	a2,a6,ffffffffc02012ec <printnum+0x62>
ffffffffc02012b0:	e44e                	sd	s3,8(sp)
ffffffffc02012b2:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02012b4:	4785                	li	a5,1
ffffffffc02012b6:	00e7d763          	bge	a5,a4,ffffffffc02012c4 <printnum+0x3a>
            putch(padc, putdat);
ffffffffc02012ba:	85ca                	mv	a1,s2
ffffffffc02012bc:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc02012be:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02012c0:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02012c2:	fc65                	bnez	s0,ffffffffc02012ba <printnum+0x30>
ffffffffc02012c4:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02012c6:	1a02                	slli	s4,s4,0x20
ffffffffc02012c8:	020a5a13          	srli	s4,s4,0x20
ffffffffc02012cc:	00001797          	auipc	a5,0x1
ffffffffc02012d0:	bbc78793          	addi	a5,a5,-1092 # ffffffffc0201e88 <etext+0x754>
ffffffffc02012d4:	97d2                	add	a5,a5,s4
}
ffffffffc02012d6:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02012d8:	0007c503          	lbu	a0,0(a5)
}
ffffffffc02012dc:	70a2                	ld	ra,40(sp)
ffffffffc02012de:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02012e0:	85ca                	mv	a1,s2
ffffffffc02012e2:	87a6                	mv	a5,s1
}
ffffffffc02012e4:	6942                	ld	s2,16(sp)
ffffffffc02012e6:	64e2                	ld	s1,24(sp)
ffffffffc02012e8:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02012ea:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02012ec:	03065633          	divu	a2,a2,a6
ffffffffc02012f0:	8722                	mv	a4,s0
ffffffffc02012f2:	f99ff0ef          	jal	ffffffffc020128a <printnum>
ffffffffc02012f6:	bfc1                	j	ffffffffc02012c6 <printnum+0x3c>

ffffffffc02012f8 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02012f8:	7119                	addi	sp,sp,-128
ffffffffc02012fa:	f4a6                	sd	s1,104(sp)
ffffffffc02012fc:	f0ca                	sd	s2,96(sp)
ffffffffc02012fe:	ecce                	sd	s3,88(sp)
ffffffffc0201300:	e8d2                	sd	s4,80(sp)
ffffffffc0201302:	e4d6                	sd	s5,72(sp)
ffffffffc0201304:	e0da                	sd	s6,64(sp)
ffffffffc0201306:	f862                	sd	s8,48(sp)
ffffffffc0201308:	fc86                	sd	ra,120(sp)
ffffffffc020130a:	f8a2                	sd	s0,112(sp)
ffffffffc020130c:	fc5e                	sd	s7,56(sp)
ffffffffc020130e:	f466                	sd	s9,40(sp)
ffffffffc0201310:	f06a                	sd	s10,32(sp)
ffffffffc0201312:	ec6e                	sd	s11,24(sp)
ffffffffc0201314:	892a                	mv	s2,a0
ffffffffc0201316:	84ae                	mv	s1,a1
ffffffffc0201318:	8c32                	mv	s8,a2
ffffffffc020131a:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020131c:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201320:	05500b13          	li	s6,85
ffffffffc0201324:	00001a97          	auipc	s5,0x1
ffffffffc0201328:	c74a8a93          	addi	s5,s5,-908 # ffffffffc0201f98 <default_pmm_manager+0x38>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020132c:	000c4503          	lbu	a0,0(s8)
ffffffffc0201330:	001c0413          	addi	s0,s8,1
ffffffffc0201334:	01350a63          	beq	a0,s3,ffffffffc0201348 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0201338:	cd0d                	beqz	a0,ffffffffc0201372 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc020133a:	85a6                	mv	a1,s1
ffffffffc020133c:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020133e:	00044503          	lbu	a0,0(s0)
ffffffffc0201342:	0405                	addi	s0,s0,1
ffffffffc0201344:	ff351ae3          	bne	a0,s3,ffffffffc0201338 <vprintfmt+0x40>
        char padc = ' ';
ffffffffc0201348:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc020134c:	4b81                	li	s7,0
ffffffffc020134e:	4601                	li	a2,0
        width = precision = -1;
ffffffffc0201350:	5d7d                	li	s10,-1
ffffffffc0201352:	5cfd                	li	s9,-1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201354:	00044683          	lbu	a3,0(s0)
ffffffffc0201358:	00140c13          	addi	s8,s0,1
ffffffffc020135c:	fdd6859b          	addiw	a1,a3,-35 # fffffffffebfffdd <end+0x3e9f9f65>
ffffffffc0201360:	0ff5f593          	zext.b	a1,a1
ffffffffc0201364:	02bb6663          	bltu	s6,a1,ffffffffc0201390 <vprintfmt+0x98>
ffffffffc0201368:	058a                	slli	a1,a1,0x2
ffffffffc020136a:	95d6                	add	a1,a1,s5
ffffffffc020136c:	4198                	lw	a4,0(a1)
ffffffffc020136e:	9756                	add	a4,a4,s5
ffffffffc0201370:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0201372:	70e6                	ld	ra,120(sp)
ffffffffc0201374:	7446                	ld	s0,112(sp)
ffffffffc0201376:	74a6                	ld	s1,104(sp)
ffffffffc0201378:	7906                	ld	s2,96(sp)
ffffffffc020137a:	69e6                	ld	s3,88(sp)
ffffffffc020137c:	6a46                	ld	s4,80(sp)
ffffffffc020137e:	6aa6                	ld	s5,72(sp)
ffffffffc0201380:	6b06                	ld	s6,64(sp)
ffffffffc0201382:	7be2                	ld	s7,56(sp)
ffffffffc0201384:	7c42                	ld	s8,48(sp)
ffffffffc0201386:	7ca2                	ld	s9,40(sp)
ffffffffc0201388:	7d02                	ld	s10,32(sp)
ffffffffc020138a:	6de2                	ld	s11,24(sp)
ffffffffc020138c:	6109                	addi	sp,sp,128
ffffffffc020138e:	8082                	ret
            putch('%', putdat);
ffffffffc0201390:	85a6                	mv	a1,s1
ffffffffc0201392:	02500513          	li	a0,37
ffffffffc0201396:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201398:	fff44703          	lbu	a4,-1(s0)
ffffffffc020139c:	02500793          	li	a5,37
ffffffffc02013a0:	8c22                	mv	s8,s0
ffffffffc02013a2:	f8f705e3          	beq	a4,a5,ffffffffc020132c <vprintfmt+0x34>
ffffffffc02013a6:	02500713          	li	a4,37
ffffffffc02013aa:	ffec4783          	lbu	a5,-2(s8)
ffffffffc02013ae:	1c7d                	addi	s8,s8,-1
ffffffffc02013b0:	fee79de3          	bne	a5,a4,ffffffffc02013aa <vprintfmt+0xb2>
ffffffffc02013b4:	bfa5                	j	ffffffffc020132c <vprintfmt+0x34>
                ch = *fmt;
ffffffffc02013b6:	00144783          	lbu	a5,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc02013ba:	4725                	li	a4,9
                precision = precision * 10 + ch - '0';
ffffffffc02013bc:	fd068d1b          	addiw	s10,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc02013c0:	fd07859b          	addiw	a1,a5,-48
                ch = *fmt;
ffffffffc02013c4:	0007869b          	sext.w	a3,a5
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02013c8:	8462                	mv	s0,s8
                if (ch < '0' || ch > '9') {
ffffffffc02013ca:	02b76563          	bltu	a4,a1,ffffffffc02013f4 <vprintfmt+0xfc>
ffffffffc02013ce:	4525                	li	a0,9
                ch = *fmt;
ffffffffc02013d0:	00144783          	lbu	a5,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02013d4:	002d171b          	slliw	a4,s10,0x2
ffffffffc02013d8:	01a7073b          	addw	a4,a4,s10
ffffffffc02013dc:	0017171b          	slliw	a4,a4,0x1
ffffffffc02013e0:	9f35                	addw	a4,a4,a3
                if (ch < '0' || ch > '9') {
ffffffffc02013e2:	fd07859b          	addiw	a1,a5,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02013e6:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02013e8:	fd070d1b          	addiw	s10,a4,-48
                ch = *fmt;
ffffffffc02013ec:	0007869b          	sext.w	a3,a5
                if (ch < '0' || ch > '9') {
ffffffffc02013f0:	feb570e3          	bgeu	a0,a1,ffffffffc02013d0 <vprintfmt+0xd8>
            if (width < 0)
ffffffffc02013f4:	f60cd0e3          	bgez	s9,ffffffffc0201354 <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc02013f8:	8cea                	mv	s9,s10
ffffffffc02013fa:	5d7d                	li	s10,-1
ffffffffc02013fc:	bfa1                	j	ffffffffc0201354 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02013fe:	8db6                	mv	s11,a3
ffffffffc0201400:	8462                	mv	s0,s8
ffffffffc0201402:	bf89                	j	ffffffffc0201354 <vprintfmt+0x5c>
ffffffffc0201404:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0201406:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0201408:	b7b1                	j	ffffffffc0201354 <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc020140a:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc020140c:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc0201410:	00c7c463          	blt	a5,a2,ffffffffc0201418 <vprintfmt+0x120>
    else if (lflag) {
ffffffffc0201414:	1a060163          	beqz	a2,ffffffffc02015b6 <vprintfmt+0x2be>
        return va_arg(*ap, unsigned long);
ffffffffc0201418:	000a3603          	ld	a2,0(s4)
ffffffffc020141c:	46c1                	li	a3,16
ffffffffc020141e:	8a3a                	mv	s4,a4
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201420:	000d879b          	sext.w	a5,s11
ffffffffc0201424:	8766                	mv	a4,s9
ffffffffc0201426:	85a6                	mv	a1,s1
ffffffffc0201428:	854a                	mv	a0,s2
ffffffffc020142a:	e61ff0ef          	jal	ffffffffc020128a <printnum>
            break;
ffffffffc020142e:	bdfd                	j	ffffffffc020132c <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0201430:	000a2503          	lw	a0,0(s4)
ffffffffc0201434:	85a6                	mv	a1,s1
ffffffffc0201436:	0a21                	addi	s4,s4,8
ffffffffc0201438:	9902                	jalr	s2
            break;
ffffffffc020143a:	bdcd                	j	ffffffffc020132c <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc020143c:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc020143e:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc0201442:	00c7c463          	blt	a5,a2,ffffffffc020144a <vprintfmt+0x152>
    else if (lflag) {
ffffffffc0201446:	16060363          	beqz	a2,ffffffffc02015ac <vprintfmt+0x2b4>
        return va_arg(*ap, unsigned long);
ffffffffc020144a:	000a3603          	ld	a2,0(s4)
ffffffffc020144e:	46a9                	li	a3,10
ffffffffc0201450:	8a3a                	mv	s4,a4
ffffffffc0201452:	b7f9                	j	ffffffffc0201420 <vprintfmt+0x128>
            putch('0', putdat);
ffffffffc0201454:	85a6                	mv	a1,s1
ffffffffc0201456:	03000513          	li	a0,48
ffffffffc020145a:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc020145c:	85a6                	mv	a1,s1
ffffffffc020145e:	07800513          	li	a0,120
ffffffffc0201462:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201464:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0201468:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020146a:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020146c:	bf55                	j	ffffffffc0201420 <vprintfmt+0x128>
            putch(ch, putdat);
ffffffffc020146e:	85a6                	mv	a1,s1
ffffffffc0201470:	02500513          	li	a0,37
ffffffffc0201474:	9902                	jalr	s2
            break;
ffffffffc0201476:	bd5d                	j	ffffffffc020132c <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0201478:	000a2d03          	lw	s10,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020147c:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc020147e:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0201480:	bf95                	j	ffffffffc02013f4 <vprintfmt+0xfc>
    if (lflag >= 2) {
ffffffffc0201482:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0201484:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc0201488:	00c7c463          	blt	a5,a2,ffffffffc0201490 <vprintfmt+0x198>
    else if (lflag) {
ffffffffc020148c:	10060b63          	beqz	a2,ffffffffc02015a2 <vprintfmt+0x2aa>
        return va_arg(*ap, unsigned long);
ffffffffc0201490:	000a3603          	ld	a2,0(s4)
ffffffffc0201494:	46a1                	li	a3,8
ffffffffc0201496:	8a3a                	mv	s4,a4
ffffffffc0201498:	b761                	j	ffffffffc0201420 <vprintfmt+0x128>
            if (width < 0)
ffffffffc020149a:	fffcc793          	not	a5,s9
ffffffffc020149e:	97fd                	srai	a5,a5,0x3f
ffffffffc02014a0:	00fcf7b3          	and	a5,s9,a5
ffffffffc02014a4:	00078c9b          	sext.w	s9,a5
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02014a8:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc02014aa:	b56d                	j	ffffffffc0201354 <vprintfmt+0x5c>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02014ac:	000a3403          	ld	s0,0(s4)
ffffffffc02014b0:	008a0793          	addi	a5,s4,8
ffffffffc02014b4:	e43e                	sd	a5,8(sp)
ffffffffc02014b6:	12040063          	beqz	s0,ffffffffc02015d6 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc02014ba:	0d905963          	blez	s9,ffffffffc020158c <vprintfmt+0x294>
ffffffffc02014be:	02d00793          	li	a5,45
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02014c2:	00140a13          	addi	s4,s0,1
            if (width > 0 && padc != '-') {
ffffffffc02014c6:	12fd9763          	bne	s11,a5,ffffffffc02015f4 <vprintfmt+0x2fc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02014ca:	00044783          	lbu	a5,0(s0)
ffffffffc02014ce:	0007851b          	sext.w	a0,a5
ffffffffc02014d2:	cb9d                	beqz	a5,ffffffffc0201508 <vprintfmt+0x210>
ffffffffc02014d4:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02014d6:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02014da:	000d4563          	bltz	s10,ffffffffc02014e4 <vprintfmt+0x1ec>
ffffffffc02014de:	3d7d                	addiw	s10,s10,-1
ffffffffc02014e0:	028d0263          	beq	s10,s0,ffffffffc0201504 <vprintfmt+0x20c>
                    putch('?', putdat);
ffffffffc02014e4:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02014e6:	0c0b8d63          	beqz	s7,ffffffffc02015c0 <vprintfmt+0x2c8>
ffffffffc02014ea:	3781                	addiw	a5,a5,-32
ffffffffc02014ec:	0cfdfa63          	bgeu	s11,a5,ffffffffc02015c0 <vprintfmt+0x2c8>
                    putch('?', putdat);
ffffffffc02014f0:	03f00513          	li	a0,63
ffffffffc02014f4:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02014f6:	000a4783          	lbu	a5,0(s4)
ffffffffc02014fa:	3cfd                	addiw	s9,s9,-1 # feffff <kern_entry-0xffffffffbf210001>
ffffffffc02014fc:	0a05                	addi	s4,s4,1
ffffffffc02014fe:	0007851b          	sext.w	a0,a5
ffffffffc0201502:	ffe1                	bnez	a5,ffffffffc02014da <vprintfmt+0x1e2>
            for (; width > 0; width --) {
ffffffffc0201504:	01905963          	blez	s9,ffffffffc0201516 <vprintfmt+0x21e>
                putch(' ', putdat);
ffffffffc0201508:	85a6                	mv	a1,s1
ffffffffc020150a:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc020150e:	3cfd                	addiw	s9,s9,-1
                putch(' ', putdat);
ffffffffc0201510:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0201512:	fe0c9be3          	bnez	s9,ffffffffc0201508 <vprintfmt+0x210>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201516:	6a22                	ld	s4,8(sp)
ffffffffc0201518:	bd11                	j	ffffffffc020132c <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc020151a:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc020151c:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0201520:	00c7c363          	blt	a5,a2,ffffffffc0201526 <vprintfmt+0x22e>
    else if (lflag) {
ffffffffc0201524:	ce25                	beqz	a2,ffffffffc020159c <vprintfmt+0x2a4>
        return va_arg(*ap, long);
ffffffffc0201526:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc020152a:	08044d63          	bltz	s0,ffffffffc02015c4 <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc020152e:	8622                	mv	a2,s0
ffffffffc0201530:	8a5e                	mv	s4,s7
ffffffffc0201532:	46a9                	li	a3,10
ffffffffc0201534:	b5f5                	j	ffffffffc0201420 <vprintfmt+0x128>
            if (err < 0) {
ffffffffc0201536:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020153a:	4619                	li	a2,6
            if (err < 0) {
ffffffffc020153c:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0201540:	8fb9                	xor	a5,a5,a4
ffffffffc0201542:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201546:	02d64663          	blt	a2,a3,ffffffffc0201572 <vprintfmt+0x27a>
ffffffffc020154a:	00369713          	slli	a4,a3,0x3
ffffffffc020154e:	00001797          	auipc	a5,0x1
ffffffffc0201552:	ba278793          	addi	a5,a5,-1118 # ffffffffc02020f0 <error_string>
ffffffffc0201556:	97ba                	add	a5,a5,a4
ffffffffc0201558:	639c                	ld	a5,0(a5)
ffffffffc020155a:	cf81                	beqz	a5,ffffffffc0201572 <vprintfmt+0x27a>
                printfmt(putch, putdat, "%s", p);
ffffffffc020155c:	86be                	mv	a3,a5
ffffffffc020155e:	00001617          	auipc	a2,0x1
ffffffffc0201562:	95a60613          	addi	a2,a2,-1702 # ffffffffc0201eb8 <etext+0x784>
ffffffffc0201566:	85a6                	mv	a1,s1
ffffffffc0201568:	854a                	mv	a0,s2
ffffffffc020156a:	0e8000ef          	jal	ffffffffc0201652 <printfmt>
            err = va_arg(ap, int);
ffffffffc020156e:	0a21                	addi	s4,s4,8
ffffffffc0201570:	bb75                	j	ffffffffc020132c <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201572:	00001617          	auipc	a2,0x1
ffffffffc0201576:	93660613          	addi	a2,a2,-1738 # ffffffffc0201ea8 <etext+0x774>
ffffffffc020157a:	85a6                	mv	a1,s1
ffffffffc020157c:	854a                	mv	a0,s2
ffffffffc020157e:	0d4000ef          	jal	ffffffffc0201652 <printfmt>
            err = va_arg(ap, int);
ffffffffc0201582:	0a21                	addi	s4,s4,8
ffffffffc0201584:	b365                	j	ffffffffc020132c <vprintfmt+0x34>
            lflag ++;
ffffffffc0201586:	2605                	addiw	a2,a2,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201588:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc020158a:	b3e9                	j	ffffffffc0201354 <vprintfmt+0x5c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020158c:	00044783          	lbu	a5,0(s0)
ffffffffc0201590:	0007851b          	sext.w	a0,a5
ffffffffc0201594:	d3c9                	beqz	a5,ffffffffc0201516 <vprintfmt+0x21e>
ffffffffc0201596:	00140a13          	addi	s4,s0,1
ffffffffc020159a:	bf2d                	j	ffffffffc02014d4 <vprintfmt+0x1dc>
        return va_arg(*ap, int);
ffffffffc020159c:	000a2403          	lw	s0,0(s4)
ffffffffc02015a0:	b769                	j	ffffffffc020152a <vprintfmt+0x232>
        return va_arg(*ap, unsigned int);
ffffffffc02015a2:	000a6603          	lwu	a2,0(s4)
ffffffffc02015a6:	46a1                	li	a3,8
ffffffffc02015a8:	8a3a                	mv	s4,a4
ffffffffc02015aa:	bd9d                	j	ffffffffc0201420 <vprintfmt+0x128>
ffffffffc02015ac:	000a6603          	lwu	a2,0(s4)
ffffffffc02015b0:	46a9                	li	a3,10
ffffffffc02015b2:	8a3a                	mv	s4,a4
ffffffffc02015b4:	b5b5                	j	ffffffffc0201420 <vprintfmt+0x128>
ffffffffc02015b6:	000a6603          	lwu	a2,0(s4)
ffffffffc02015ba:	46c1                	li	a3,16
ffffffffc02015bc:	8a3a                	mv	s4,a4
ffffffffc02015be:	b58d                	j	ffffffffc0201420 <vprintfmt+0x128>
                    putch(ch, putdat);
ffffffffc02015c0:	9902                	jalr	s2
ffffffffc02015c2:	bf15                	j	ffffffffc02014f6 <vprintfmt+0x1fe>
                putch('-', putdat);
ffffffffc02015c4:	85a6                	mv	a1,s1
ffffffffc02015c6:	02d00513          	li	a0,45
ffffffffc02015ca:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02015cc:	40800633          	neg	a2,s0
ffffffffc02015d0:	8a5e                	mv	s4,s7
ffffffffc02015d2:	46a9                	li	a3,10
ffffffffc02015d4:	b5b1                	j	ffffffffc0201420 <vprintfmt+0x128>
            if (width > 0 && padc != '-') {
ffffffffc02015d6:	01905663          	blez	s9,ffffffffc02015e2 <vprintfmt+0x2ea>
ffffffffc02015da:	02d00793          	li	a5,45
ffffffffc02015de:	04fd9263          	bne	s11,a5,ffffffffc0201622 <vprintfmt+0x32a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02015e2:	02800793          	li	a5,40
ffffffffc02015e6:	00001a17          	auipc	s4,0x1
ffffffffc02015ea:	8bba0a13          	addi	s4,s4,-1861 # ffffffffc0201ea1 <etext+0x76d>
ffffffffc02015ee:	02800513          	li	a0,40
ffffffffc02015f2:	b5cd                	j	ffffffffc02014d4 <vprintfmt+0x1dc>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02015f4:	85ea                	mv	a1,s10
ffffffffc02015f6:	8522                	mv	a0,s0
ffffffffc02015f8:	0ae000ef          	jal	ffffffffc02016a6 <strnlen>
ffffffffc02015fc:	40ac8cbb          	subw	s9,s9,a0
ffffffffc0201600:	01905963          	blez	s9,ffffffffc0201612 <vprintfmt+0x31a>
                    putch(padc, putdat);
ffffffffc0201604:	2d81                	sext.w	s11,s11
ffffffffc0201606:	85a6                	mv	a1,s1
ffffffffc0201608:	856e                	mv	a0,s11
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020160a:	3cfd                	addiw	s9,s9,-1
                    putch(padc, putdat);
ffffffffc020160c:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020160e:	fe0c9ce3          	bnez	s9,ffffffffc0201606 <vprintfmt+0x30e>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201612:	00044783          	lbu	a5,0(s0)
ffffffffc0201616:	0007851b          	sext.w	a0,a5
ffffffffc020161a:	ea079de3          	bnez	a5,ffffffffc02014d4 <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020161e:	6a22                	ld	s4,8(sp)
ffffffffc0201620:	b331                	j	ffffffffc020132c <vprintfmt+0x34>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201622:	85ea                	mv	a1,s10
ffffffffc0201624:	00001517          	auipc	a0,0x1
ffffffffc0201628:	87c50513          	addi	a0,a0,-1924 # ffffffffc0201ea0 <etext+0x76c>
ffffffffc020162c:	07a000ef          	jal	ffffffffc02016a6 <strnlen>
ffffffffc0201630:	40ac8cbb          	subw	s9,s9,a0
                p = "(null)";
ffffffffc0201634:	00001417          	auipc	s0,0x1
ffffffffc0201638:	86c40413          	addi	s0,s0,-1940 # ffffffffc0201ea0 <etext+0x76c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020163c:	00001a17          	auipc	s4,0x1
ffffffffc0201640:	865a0a13          	addi	s4,s4,-1947 # ffffffffc0201ea1 <etext+0x76d>
ffffffffc0201644:	02800793          	li	a5,40
ffffffffc0201648:	02800513          	li	a0,40
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020164c:	fb904ce3          	bgtz	s9,ffffffffc0201604 <vprintfmt+0x30c>
ffffffffc0201650:	b551                	j	ffffffffc02014d4 <vprintfmt+0x1dc>

ffffffffc0201652 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201652:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201654:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201658:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020165a:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020165c:	ec06                	sd	ra,24(sp)
ffffffffc020165e:	f83a                	sd	a4,48(sp)
ffffffffc0201660:	fc3e                	sd	a5,56(sp)
ffffffffc0201662:	e0c2                	sd	a6,64(sp)
ffffffffc0201664:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201666:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201668:	c91ff0ef          	jal	ffffffffc02012f8 <vprintfmt>
}
ffffffffc020166c:	60e2                	ld	ra,24(sp)
ffffffffc020166e:	6161                	addi	sp,sp,80
ffffffffc0201670:	8082                	ret

ffffffffc0201672 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201672:	4781                	li	a5,0
ffffffffc0201674:	00005717          	auipc	a4,0x5
ffffffffc0201678:	99c73703          	ld	a4,-1636(a4) # ffffffffc0206010 <SBI_CONSOLE_PUTCHAR>
ffffffffc020167c:	88ba                	mv	a7,a4
ffffffffc020167e:	852a                	mv	a0,a0
ffffffffc0201680:	85be                	mv	a1,a5
ffffffffc0201682:	863e                	mv	a2,a5
ffffffffc0201684:	00000073          	ecall
ffffffffc0201688:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc020168a:	8082                	ret

ffffffffc020168c <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc020168c:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0201690:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0201692:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0201694:	cb81                	beqz	a5,ffffffffc02016a4 <strlen+0x18>
        cnt ++;
ffffffffc0201696:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0201698:	00a707b3          	add	a5,a4,a0
ffffffffc020169c:	0007c783          	lbu	a5,0(a5)
ffffffffc02016a0:	fbfd                	bnez	a5,ffffffffc0201696 <strlen+0xa>
ffffffffc02016a2:	8082                	ret
    }
    return cnt;
}
ffffffffc02016a4:	8082                	ret

ffffffffc02016a6 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02016a6:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02016a8:	e589                	bnez	a1,ffffffffc02016b2 <strnlen+0xc>
ffffffffc02016aa:	a811                	j	ffffffffc02016be <strnlen+0x18>
        cnt ++;
ffffffffc02016ac:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02016ae:	00f58863          	beq	a1,a5,ffffffffc02016be <strnlen+0x18>
ffffffffc02016b2:	00f50733          	add	a4,a0,a5
ffffffffc02016b6:	00074703          	lbu	a4,0(a4)
ffffffffc02016ba:	fb6d                	bnez	a4,ffffffffc02016ac <strnlen+0x6>
ffffffffc02016bc:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02016be:	852e                	mv	a0,a1
ffffffffc02016c0:	8082                	ret

ffffffffc02016c2 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02016c2:	00054783          	lbu	a5,0(a0)
ffffffffc02016c6:	e791                	bnez	a5,ffffffffc02016d2 <strcmp+0x10>
ffffffffc02016c8:	a02d                	j	ffffffffc02016f2 <strcmp+0x30>
ffffffffc02016ca:	00054783          	lbu	a5,0(a0)
ffffffffc02016ce:	cf89                	beqz	a5,ffffffffc02016e8 <strcmp+0x26>
ffffffffc02016d0:	85b6                	mv	a1,a3
ffffffffc02016d2:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc02016d6:	0505                	addi	a0,a0,1
ffffffffc02016d8:	00158693          	addi	a3,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02016dc:	fef707e3          	beq	a4,a5,ffffffffc02016ca <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02016e0:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02016e4:	9d19                	subw	a0,a0,a4
ffffffffc02016e6:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02016e8:	0015c703          	lbu	a4,1(a1)
ffffffffc02016ec:	4501                	li	a0,0
}
ffffffffc02016ee:	9d19                	subw	a0,a0,a4
ffffffffc02016f0:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02016f2:	0005c703          	lbu	a4,0(a1)
ffffffffc02016f6:	4501                	li	a0,0
ffffffffc02016f8:	b7f5                	j	ffffffffc02016e4 <strcmp+0x22>

ffffffffc02016fa <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02016fa:	ce01                	beqz	a2,ffffffffc0201712 <strncmp+0x18>
ffffffffc02016fc:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201700:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201702:	cb91                	beqz	a5,ffffffffc0201716 <strncmp+0x1c>
ffffffffc0201704:	0005c703          	lbu	a4,0(a1)
ffffffffc0201708:	00f71763          	bne	a4,a5,ffffffffc0201716 <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc020170c:	0505                	addi	a0,a0,1
ffffffffc020170e:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201710:	f675                	bnez	a2,ffffffffc02016fc <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201712:	4501                	li	a0,0
ffffffffc0201714:	8082                	ret
ffffffffc0201716:	00054503          	lbu	a0,0(a0)
ffffffffc020171a:	0005c783          	lbu	a5,0(a1)
ffffffffc020171e:	9d1d                	subw	a0,a0,a5
}
ffffffffc0201720:	8082                	ret

ffffffffc0201722 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201722:	ca01                	beqz	a2,ffffffffc0201732 <memset+0x10>
ffffffffc0201724:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0201726:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0201728:	0785                	addi	a5,a5,1
ffffffffc020172a:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc020172e:	fef61de3          	bne	a2,a5,ffffffffc0201728 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201732:	8082                	ret
