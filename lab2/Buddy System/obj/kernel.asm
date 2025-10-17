
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
ffffffffc0200044:	0d828293          	addi	t0,t0,216 # ffffffffc02000d8 <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020004a:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[];
    cprintf("Special kernel symbols:\n");
ffffffffc020004c:	00002517          	auipc	a0,0x2
ffffffffc0200050:	d4c50513          	addi	a0,a0,-692 # ffffffffc0201d98 <etext+0x4>
void print_kerninfo(void) {
ffffffffc0200054:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200056:	0fa000ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", (uintptr_t)kern_init);
ffffffffc020005a:	00000597          	auipc	a1,0x0
ffffffffc020005e:	07e58593          	addi	a1,a1,126 # ffffffffc02000d8 <kern_init>
ffffffffc0200062:	00002517          	auipc	a0,0x2
ffffffffc0200066:	d5650513          	addi	a0,a0,-682 # ffffffffc0201db8 <etext+0x24>
ffffffffc020006a:	0e6000ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc020006e:	00002597          	auipc	a1,0x2
ffffffffc0200072:	d2658593          	addi	a1,a1,-730 # ffffffffc0201d94 <etext>
ffffffffc0200076:	00002517          	auipc	a0,0x2
ffffffffc020007a:	d6250513          	addi	a0,a0,-670 # ffffffffc0201dd8 <etext+0x44>
ffffffffc020007e:	0d2000ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc0200082:	00006597          	auipc	a1,0x6
ffffffffc0200086:	f9658593          	addi	a1,a1,-106 # ffffffffc0206018 <buddy_array>
ffffffffc020008a:	00002517          	auipc	a0,0x2
ffffffffc020008e:	d6e50513          	addi	a0,a0,-658 # ffffffffc0201df8 <etext+0x64>
ffffffffc0200092:	0be000ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc0200096:	00006597          	auipc	a1,0x6
ffffffffc020009a:	12258593          	addi	a1,a1,290 # ffffffffc02061b8 <end>
ffffffffc020009e:	00002517          	auipc	a0,0x2
ffffffffc02000a2:	d7a50513          	addi	a0,a0,-646 # ffffffffc0201e18 <etext+0x84>
ffffffffc02000a6:	0aa000ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - (char*)kern_init + 1023) / 1024);
ffffffffc02000aa:	00006597          	auipc	a1,0x6
ffffffffc02000ae:	50d58593          	addi	a1,a1,1293 # ffffffffc02065b7 <end+0x3ff>
ffffffffc02000b2:	00000797          	auipc	a5,0x0
ffffffffc02000b6:	02678793          	addi	a5,a5,38 # ffffffffc02000d8 <kern_init>
ffffffffc02000ba:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000be:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02000c2:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000c4:	3ff5f593          	andi	a1,a1,1023
ffffffffc02000c8:	95be                	add	a1,a1,a5
ffffffffc02000ca:	85a9                	srai	a1,a1,0xa
ffffffffc02000cc:	00002517          	auipc	a0,0x2
ffffffffc02000d0:	d6c50513          	addi	a0,a0,-660 # ffffffffc0201e38 <etext+0xa4>
}
ffffffffc02000d4:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000d6:	a8ad                	j	ffffffffc0200150 <cprintf>

ffffffffc02000d8 <kern_init>:

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc02000d8:	00006517          	auipc	a0,0x6
ffffffffc02000dc:	f4050513          	addi	a0,a0,-192 # ffffffffc0206018 <buddy_array>
ffffffffc02000e0:	00006617          	auipc	a2,0x6
ffffffffc02000e4:	0d860613          	addi	a2,a2,216 # ffffffffc02061b8 <end>
int kern_init(void) {
ffffffffc02000e8:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc02000ea:	8e09                	sub	a2,a2,a0
ffffffffc02000ec:	4581                	li	a1,0
int kern_init(void) {
ffffffffc02000ee:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc02000f0:	45b010ef          	jal	ra,ffffffffc0201d4a <memset>
    dtb_init();
ffffffffc02000f4:	170000ef          	jal	ra,ffffffffc0200264 <dtb_init>
    cons_init();  // init the console
ffffffffc02000f8:	162000ef          	jal	ra,ffffffffc020025a <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc02000fc:	00002517          	auipc	a0,0x2
ffffffffc0200100:	d6c50513          	addi	a0,a0,-660 # ffffffffc0201e68 <etext+0xd4>
ffffffffc0200104:	082000ef          	jal	ra,ffffffffc0200186 <cputs>

    print_kerninfo();
ffffffffc0200108:	f43ff0ef          	jal	ra,ffffffffc020004a <print_kerninfo>

    // grade_backtrace();
    pmm_init();  // 初始化物理内存管理器，使用 Buddy System
ffffffffc020010c:	5e4010ef          	jal	ra,ffffffffc02016f0 <pmm_init>
    
    // 运行伙伴系统测试
    run_buddy_system_test();
ffffffffc0200110:	504000ef          	jal	ra,ffffffffc0200614 <run_buddy_system_test>

    /* do nothing */
    while (1)
ffffffffc0200114:	a001                	j	ffffffffc0200114 <kern_init+0x3c>

ffffffffc0200116 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200116:	1141                	addi	sp,sp,-16
ffffffffc0200118:	e022                	sd	s0,0(sp)
ffffffffc020011a:	e406                	sd	ra,8(sp)
ffffffffc020011c:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc020011e:	13e000ef          	jal	ra,ffffffffc020025c <cons_putc>
    (*cnt) ++;
ffffffffc0200122:	401c                	lw	a5,0(s0)
}
ffffffffc0200124:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200126:	2785                	addiw	a5,a5,1
ffffffffc0200128:	c01c                	sw	a5,0(s0)
}
ffffffffc020012a:	6402                	ld	s0,0(sp)
ffffffffc020012c:	0141                	addi	sp,sp,16
ffffffffc020012e:	8082                	ret

ffffffffc0200130 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200130:	1101                	addi	sp,sp,-32
ffffffffc0200132:	862a                	mv	a2,a0
ffffffffc0200134:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200136:	00000517          	auipc	a0,0x0
ffffffffc020013a:	fe050513          	addi	a0,a0,-32 # ffffffffc0200116 <cputch>
ffffffffc020013e:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200140:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200142:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200144:	7f0010ef          	jal	ra,ffffffffc0201934 <vprintfmt>
    return cnt;
}
ffffffffc0200148:	60e2                	ld	ra,24(sp)
ffffffffc020014a:	4532                	lw	a0,12(sp)
ffffffffc020014c:	6105                	addi	sp,sp,32
ffffffffc020014e:	8082                	ret

ffffffffc0200150 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc0200150:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200152:	02810313          	addi	t1,sp,40 # ffffffffc0205028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc0200156:	8e2a                	mv	t3,a0
ffffffffc0200158:	f42e                	sd	a1,40(sp)
ffffffffc020015a:	f832                	sd	a2,48(sp)
ffffffffc020015c:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020015e:	00000517          	auipc	a0,0x0
ffffffffc0200162:	fb850513          	addi	a0,a0,-72 # ffffffffc0200116 <cputch>
ffffffffc0200166:	004c                	addi	a1,sp,4
ffffffffc0200168:	869a                	mv	a3,t1
ffffffffc020016a:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc020016c:	ec06                	sd	ra,24(sp)
ffffffffc020016e:	e0ba                	sd	a4,64(sp)
ffffffffc0200170:	e4be                	sd	a5,72(sp)
ffffffffc0200172:	e8c2                	sd	a6,80(sp)
ffffffffc0200174:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc0200176:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc0200178:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020017a:	7ba010ef          	jal	ra,ffffffffc0201934 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc020017e:	60e2                	ld	ra,24(sp)
ffffffffc0200180:	4512                	lw	a0,4(sp)
ffffffffc0200182:	6125                	addi	sp,sp,96
ffffffffc0200184:	8082                	ret

ffffffffc0200186 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc0200186:	1101                	addi	sp,sp,-32
ffffffffc0200188:	e822                	sd	s0,16(sp)
ffffffffc020018a:	ec06                	sd	ra,24(sp)
ffffffffc020018c:	e426                	sd	s1,8(sp)
ffffffffc020018e:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc0200190:	00054503          	lbu	a0,0(a0)
ffffffffc0200194:	c51d                	beqz	a0,ffffffffc02001c2 <cputs+0x3c>
ffffffffc0200196:	0405                	addi	s0,s0,1
ffffffffc0200198:	4485                	li	s1,1
ffffffffc020019a:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc020019c:	0c0000ef          	jal	ra,ffffffffc020025c <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc02001a0:	00044503          	lbu	a0,0(s0)
ffffffffc02001a4:	008487bb          	addw	a5,s1,s0
ffffffffc02001a8:	0405                	addi	s0,s0,1
ffffffffc02001aa:	f96d                	bnez	a0,ffffffffc020019c <cputs+0x16>
    (*cnt) ++;
ffffffffc02001ac:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001b0:	4529                	li	a0,10
ffffffffc02001b2:	0aa000ef          	jal	ra,ffffffffc020025c <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001b6:	60e2                	ld	ra,24(sp)
ffffffffc02001b8:	8522                	mv	a0,s0
ffffffffc02001ba:	6442                	ld	s0,16(sp)
ffffffffc02001bc:	64a2                	ld	s1,8(sp)
ffffffffc02001be:	6105                	addi	sp,sp,32
ffffffffc02001c0:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc02001c2:	4405                	li	s0,1
ffffffffc02001c4:	b7f5                	j	ffffffffc02001b0 <cputs+0x2a>

ffffffffc02001c6 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02001c6:	00006317          	auipc	t1,0x6
ffffffffc02001ca:	fa230313          	addi	t1,t1,-94 # ffffffffc0206168 <is_panic>
ffffffffc02001ce:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02001d2:	715d                	addi	sp,sp,-80
ffffffffc02001d4:	ec06                	sd	ra,24(sp)
ffffffffc02001d6:	e822                	sd	s0,16(sp)
ffffffffc02001d8:	f436                	sd	a3,40(sp)
ffffffffc02001da:	f83a                	sd	a4,48(sp)
ffffffffc02001dc:	fc3e                	sd	a5,56(sp)
ffffffffc02001de:	e0c2                	sd	a6,64(sp)
ffffffffc02001e0:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02001e2:	000e0363          	beqz	t3,ffffffffc02001e8 <__panic+0x22>
    }

    va_end(ap);

panic_dead:
    while (1) {
ffffffffc02001e6:	a001                	j	ffffffffc02001e6 <__panic+0x20>
    is_panic = 1;
ffffffffc02001e8:	4785                	li	a5,1
ffffffffc02001ea:	00f32023          	sw	a5,0(t1)
    va_start(ap, fmt);
ffffffffc02001ee:	8432                	mv	s0,a2
ffffffffc02001f0:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001f2:	862e                	mv	a2,a1
ffffffffc02001f4:	85aa                	mv	a1,a0
ffffffffc02001f6:	00002517          	auipc	a0,0x2
ffffffffc02001fa:	c9250513          	addi	a0,a0,-878 # ffffffffc0201e88 <etext+0xf4>
    va_start(ap, fmt);
ffffffffc02001fe:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200200:	f51ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200204:	65a2                	ld	a1,8(sp)
ffffffffc0200206:	8522                	mv	a0,s0
ffffffffc0200208:	f29ff0ef          	jal	ra,ffffffffc0200130 <vcprintf>
    cprintf("\n");
ffffffffc020020c:	00002517          	auipc	a0,0x2
ffffffffc0200210:	13450513          	addi	a0,a0,308 # ffffffffc0202340 <etext+0x5ac>
ffffffffc0200214:	f3dff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    if (strstr(fmt, "memory") != NULL || strstr(fmt, "alloc") != NULL) {
ffffffffc0200218:	00002597          	auipc	a1,0x2
ffffffffc020021c:	c9058593          	addi	a1,a1,-880 # ffffffffc0201ea8 <etext+0x114>
ffffffffc0200220:	8522                	mv	a0,s0
ffffffffc0200222:	33b010ef          	jal	ra,ffffffffc0201d5c <strstr>
ffffffffc0200226:	c10d                	beqz	a0,ffffffffc0200248 <__panic+0x82>
        cprintf("Memory allocation failure or panic occurred. Please check the Buddy System implementation.\n");
ffffffffc0200228:	00002517          	auipc	a0,0x2
ffffffffc020022c:	c8850513          	addi	a0,a0,-888 # ffffffffc0201eb0 <etext+0x11c>
ffffffffc0200230:	f21ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
        cprintf("Free pages remaining: %zu\n", nr_free_pages());  // Ensure nr_free_pages is declared and defined
ffffffffc0200234:	4b0010ef          	jal	ra,ffffffffc02016e4 <nr_free_pages>
ffffffffc0200238:	85aa                	mv	a1,a0
ffffffffc020023a:	00002517          	auipc	a0,0x2
ffffffffc020023e:	cd650513          	addi	a0,a0,-810 # ffffffffc0201f10 <etext+0x17c>
ffffffffc0200242:	f0fff0ef          	jal	ra,ffffffffc0200150 <cprintf>
ffffffffc0200246:	b745                	j	ffffffffc02001e6 <__panic+0x20>
    if (strstr(fmt, "memory") != NULL || strstr(fmt, "alloc") != NULL) {
ffffffffc0200248:	00002597          	auipc	a1,0x2
ffffffffc020024c:	ce858593          	addi	a1,a1,-792 # ffffffffc0201f30 <etext+0x19c>
ffffffffc0200250:	8522                	mv	a0,s0
ffffffffc0200252:	30b010ef          	jal	ra,ffffffffc0201d5c <strstr>
ffffffffc0200256:	f969                	bnez	a0,ffffffffc0200228 <__panic+0x62>
ffffffffc0200258:	b779                	j	ffffffffc02001e6 <__panic+0x20>

ffffffffc020025a <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020025a:	8082                	ret

ffffffffc020025c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc020025c:	0ff57513          	zext.b	a0,a0
ffffffffc0200260:	2570106f          	j	ffffffffc0201cb6 <sbi_console_putchar>

ffffffffc0200264 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200264:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200266:	00002517          	auipc	a0,0x2
ffffffffc020026a:	cd250513          	addi	a0,a0,-814 # ffffffffc0201f38 <etext+0x1a4>
void dtb_init(void) {
ffffffffc020026e:	fc86                	sd	ra,120(sp)
ffffffffc0200270:	f8a2                	sd	s0,112(sp)
ffffffffc0200272:	e8d2                	sd	s4,80(sp)
ffffffffc0200274:	f4a6                	sd	s1,104(sp)
ffffffffc0200276:	f0ca                	sd	s2,96(sp)
ffffffffc0200278:	ecce                	sd	s3,88(sp)
ffffffffc020027a:	e4d6                	sd	s5,72(sp)
ffffffffc020027c:	e0da                	sd	s6,64(sp)
ffffffffc020027e:	fc5e                	sd	s7,56(sp)
ffffffffc0200280:	f862                	sd	s8,48(sp)
ffffffffc0200282:	f466                	sd	s9,40(sp)
ffffffffc0200284:	f06a                	sd	s10,32(sp)
ffffffffc0200286:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200288:	ec9ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020028c:	00006597          	auipc	a1,0x6
ffffffffc0200290:	d745b583          	ld	a1,-652(a1) # ffffffffc0206000 <boot_hartid>
ffffffffc0200294:	00002517          	auipc	a0,0x2
ffffffffc0200298:	cb450513          	addi	a0,a0,-844 # ffffffffc0201f48 <etext+0x1b4>
ffffffffc020029c:	eb5ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02002a0:	00006417          	auipc	s0,0x6
ffffffffc02002a4:	d6840413          	addi	s0,s0,-664 # ffffffffc0206008 <boot_dtb>
ffffffffc02002a8:	600c                	ld	a1,0(s0)
ffffffffc02002aa:	00002517          	auipc	a0,0x2
ffffffffc02002ae:	cae50513          	addi	a0,a0,-850 # ffffffffc0201f58 <etext+0x1c4>
ffffffffc02002b2:	e9fff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02002b6:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02002ba:	00002517          	auipc	a0,0x2
ffffffffc02002be:	cb650513          	addi	a0,a0,-842 # ffffffffc0201f70 <etext+0x1dc>
    if (boot_dtb == 0) {
ffffffffc02002c2:	120a0463          	beqz	s4,ffffffffc02003ea <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc02002c6:	57f5                	li	a5,-3
ffffffffc02002c8:	07fa                	slli	a5,a5,0x1e
ffffffffc02002ca:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc02002ce:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002d0:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002d4:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002d6:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02002da:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002de:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002e2:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e6:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002ea:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002ec:	8ec9                	or	a3,a3,a0
ffffffffc02002ee:	0087979b          	slliw	a5,a5,0x8
ffffffffc02002f2:	1b7d                	addi	s6,s6,-1
ffffffffc02002f4:	0167f7b3          	and	a5,a5,s6
ffffffffc02002f8:	8dd5                	or	a1,a1,a3
ffffffffc02002fa:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc02002fc:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200300:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc0200302:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfed9d35>
ffffffffc0200306:	10f59163          	bne	a1,a5,ffffffffc0200408 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc020030a:	471c                	lw	a5,8(a4)
ffffffffc020030c:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc020030e:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200310:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200314:	0086d51b          	srliw	a0,a3,0x8
ffffffffc0200318:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020031c:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200320:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200324:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200328:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020032c:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200330:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200334:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200338:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020033a:	01146433          	or	s0,s0,a7
ffffffffc020033e:	0086969b          	slliw	a3,a3,0x8
ffffffffc0200342:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200346:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200348:	0087979b          	slliw	a5,a5,0x8
ffffffffc020034c:	8c49                	or	s0,s0,a0
ffffffffc020034e:	0166f6b3          	and	a3,a3,s6
ffffffffc0200352:	00ca6a33          	or	s4,s4,a2
ffffffffc0200356:	0167f7b3          	and	a5,a5,s6
ffffffffc020035a:	8c55                	or	s0,s0,a3
ffffffffc020035c:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200360:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200362:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200364:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200366:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020036a:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020036c:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020036e:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc0200372:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200374:	00002917          	auipc	s2,0x2
ffffffffc0200378:	c4490913          	addi	s2,s2,-956 # ffffffffc0201fb8 <etext+0x224>
ffffffffc020037c:	49bd                	li	s3,15
        switch (token) {
ffffffffc020037e:	4d91                	li	s11,4
ffffffffc0200380:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200382:	00002497          	auipc	s1,0x2
ffffffffc0200386:	b2648493          	addi	s1,s1,-1242 # ffffffffc0201ea8 <etext+0x114>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020038a:	000a2703          	lw	a4,0(s4)
ffffffffc020038e:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200392:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200396:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020039a:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020039e:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02003a2:	0107571b          	srliw	a4,a4,0x10
ffffffffc02003a6:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02003a8:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02003ac:	0087171b          	slliw	a4,a4,0x8
ffffffffc02003b0:	8fd5                	or	a5,a5,a3
ffffffffc02003b2:	00eb7733          	and	a4,s6,a4
ffffffffc02003b6:	8fd9                	or	a5,a5,a4
ffffffffc02003b8:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc02003ba:	09778c63          	beq	a5,s7,ffffffffc0200452 <dtb_init+0x1ee>
ffffffffc02003be:	00fbea63          	bltu	s7,a5,ffffffffc02003d2 <dtb_init+0x16e>
ffffffffc02003c2:	07a78663          	beq	a5,s10,ffffffffc020042e <dtb_init+0x1ca>
ffffffffc02003c6:	4709                	li	a4,2
ffffffffc02003c8:	00e79763          	bne	a5,a4,ffffffffc02003d6 <dtb_init+0x172>
ffffffffc02003cc:	4c81                	li	s9,0
ffffffffc02003ce:	8a56                	mv	s4,s5
ffffffffc02003d0:	bf6d                	j	ffffffffc020038a <dtb_init+0x126>
ffffffffc02003d2:	ffb78ee3          	beq	a5,s11,ffffffffc02003ce <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02003d6:	00002517          	auipc	a0,0x2
ffffffffc02003da:	c5a50513          	addi	a0,a0,-934 # ffffffffc0202030 <etext+0x29c>
ffffffffc02003de:	d73ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02003e2:	00002517          	auipc	a0,0x2
ffffffffc02003e6:	c8650513          	addi	a0,a0,-890 # ffffffffc0202068 <etext+0x2d4>
}
ffffffffc02003ea:	7446                	ld	s0,112(sp)
ffffffffc02003ec:	70e6                	ld	ra,120(sp)
ffffffffc02003ee:	74a6                	ld	s1,104(sp)
ffffffffc02003f0:	7906                	ld	s2,96(sp)
ffffffffc02003f2:	69e6                	ld	s3,88(sp)
ffffffffc02003f4:	6a46                	ld	s4,80(sp)
ffffffffc02003f6:	6aa6                	ld	s5,72(sp)
ffffffffc02003f8:	6b06                	ld	s6,64(sp)
ffffffffc02003fa:	7be2                	ld	s7,56(sp)
ffffffffc02003fc:	7c42                	ld	s8,48(sp)
ffffffffc02003fe:	7ca2                	ld	s9,40(sp)
ffffffffc0200400:	7d02                	ld	s10,32(sp)
ffffffffc0200402:	6de2                	ld	s11,24(sp)
ffffffffc0200404:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc0200406:	b3a9                	j	ffffffffc0200150 <cprintf>
}
ffffffffc0200408:	7446                	ld	s0,112(sp)
ffffffffc020040a:	70e6                	ld	ra,120(sp)
ffffffffc020040c:	74a6                	ld	s1,104(sp)
ffffffffc020040e:	7906                	ld	s2,96(sp)
ffffffffc0200410:	69e6                	ld	s3,88(sp)
ffffffffc0200412:	6a46                	ld	s4,80(sp)
ffffffffc0200414:	6aa6                	ld	s5,72(sp)
ffffffffc0200416:	6b06                	ld	s6,64(sp)
ffffffffc0200418:	7be2                	ld	s7,56(sp)
ffffffffc020041a:	7c42                	ld	s8,48(sp)
ffffffffc020041c:	7ca2                	ld	s9,40(sp)
ffffffffc020041e:	7d02                	ld	s10,32(sp)
ffffffffc0200420:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200422:	00002517          	auipc	a0,0x2
ffffffffc0200426:	b6e50513          	addi	a0,a0,-1170 # ffffffffc0201f90 <etext+0x1fc>
}
ffffffffc020042a:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc020042c:	b315                	j	ffffffffc0200150 <cprintf>
                int name_len = strlen(name);
ffffffffc020042e:	8556                	mv	a0,s5
ffffffffc0200430:	0a1010ef          	jal	ra,ffffffffc0201cd0 <strlen>
ffffffffc0200434:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200436:	4619                	li	a2,6
ffffffffc0200438:	85a6                	mv	a1,s1
ffffffffc020043a:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc020043c:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020043e:	0e7010ef          	jal	ra,ffffffffc0201d24 <strncmp>
ffffffffc0200442:	e111                	bnez	a0,ffffffffc0200446 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc0200444:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200446:	0a91                	addi	s5,s5,4
ffffffffc0200448:	9ad2                	add	s5,s5,s4
ffffffffc020044a:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc020044e:	8a56                	mv	s4,s5
ffffffffc0200450:	bf2d                	j	ffffffffc020038a <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200452:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200456:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020045a:	0087d71b          	srliw	a4,a5,0x8
ffffffffc020045e:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200462:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200466:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020046a:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020046e:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200472:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200476:	0087979b          	slliw	a5,a5,0x8
ffffffffc020047a:	00eaeab3          	or	s5,s5,a4
ffffffffc020047e:	00fb77b3          	and	a5,s6,a5
ffffffffc0200482:	00faeab3          	or	s5,s5,a5
ffffffffc0200486:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200488:	000c9c63          	bnez	s9,ffffffffc02004a0 <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc020048c:	1a82                	slli	s5,s5,0x20
ffffffffc020048e:	00368793          	addi	a5,a3,3
ffffffffc0200492:	020ada93          	srli	s5,s5,0x20
ffffffffc0200496:	9abe                	add	s5,s5,a5
ffffffffc0200498:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc020049c:	8a56                	mv	s4,s5
ffffffffc020049e:	b5f5                	j	ffffffffc020038a <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02004a0:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02004a4:	85ca                	mv	a1,s2
ffffffffc02004a6:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004a8:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ac:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004b0:	0187971b          	slliw	a4,a5,0x18
ffffffffc02004b4:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004b8:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02004bc:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004be:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004c2:	0087979b          	slliw	a5,a5,0x8
ffffffffc02004c6:	8d59                	or	a0,a0,a4
ffffffffc02004c8:	00fb77b3          	and	a5,s6,a5
ffffffffc02004cc:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc02004ce:	1502                	slli	a0,a0,0x20
ffffffffc02004d0:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02004d2:	9522                	add	a0,a0,s0
ffffffffc02004d4:	033010ef          	jal	ra,ffffffffc0201d06 <strcmp>
ffffffffc02004d8:	66a2                	ld	a3,8(sp)
ffffffffc02004da:	f94d                	bnez	a0,ffffffffc020048c <dtb_init+0x228>
ffffffffc02004dc:	fb59f8e3          	bgeu	s3,s5,ffffffffc020048c <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02004e0:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02004e4:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02004e8:	00002517          	auipc	a0,0x2
ffffffffc02004ec:	ad850513          	addi	a0,a0,-1320 # ffffffffc0201fc0 <etext+0x22c>
           fdt32_to_cpu(x >> 32);
ffffffffc02004f0:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f4:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02004f8:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004fc:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200500:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200504:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200508:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020050c:	0187d693          	srli	a3,a5,0x18
ffffffffc0200510:	01861f1b          	slliw	t5,a2,0x18
ffffffffc0200514:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200518:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020051c:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200520:	010f6f33          	or	t5,t5,a6
ffffffffc0200524:	0187529b          	srliw	t0,a4,0x18
ffffffffc0200528:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020052c:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200530:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200534:	0186f6b3          	and	a3,a3,s8
ffffffffc0200538:	01859e1b          	slliw	t3,a1,0x18
ffffffffc020053c:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200540:	0107581b          	srliw	a6,a4,0x10
ffffffffc0200544:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200548:	8361                	srli	a4,a4,0x18
ffffffffc020054a:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020054e:	0105d59b          	srliw	a1,a1,0x10
ffffffffc0200552:	01e6e6b3          	or	a3,a3,t5
ffffffffc0200556:	00cb7633          	and	a2,s6,a2
ffffffffc020055a:	0088181b          	slliw	a6,a6,0x8
ffffffffc020055e:	0085959b          	slliw	a1,a1,0x8
ffffffffc0200562:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200566:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020056a:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020056e:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200572:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200576:	011b78b3          	and	a7,s6,a7
ffffffffc020057a:	005eeeb3          	or	t4,t4,t0
ffffffffc020057e:	00c6e733          	or	a4,a3,a2
ffffffffc0200582:	006c6c33          	or	s8,s8,t1
ffffffffc0200586:	010b76b3          	and	a3,s6,a6
ffffffffc020058a:	00bb7b33          	and	s6,s6,a1
ffffffffc020058e:	01d7e7b3          	or	a5,a5,t4
ffffffffc0200592:	016c6b33          	or	s6,s8,s6
ffffffffc0200596:	01146433          	or	s0,s0,a7
ffffffffc020059a:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc020059c:	1702                	slli	a4,a4,0x20
ffffffffc020059e:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02005a0:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc02005a2:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02005a4:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc02005a6:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02005aa:	0167eb33          	or	s6,a5,s6
ffffffffc02005ae:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc02005b0:	ba1ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc02005b4:	85a2                	mv	a1,s0
ffffffffc02005b6:	00002517          	auipc	a0,0x2
ffffffffc02005ba:	a2a50513          	addi	a0,a0,-1494 # ffffffffc0201fe0 <etext+0x24c>
ffffffffc02005be:	b93ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc02005c2:	014b5613          	srli	a2,s6,0x14
ffffffffc02005c6:	85da                	mv	a1,s6
ffffffffc02005c8:	00002517          	auipc	a0,0x2
ffffffffc02005cc:	a3050513          	addi	a0,a0,-1488 # ffffffffc0201ff8 <etext+0x264>
ffffffffc02005d0:	b81ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02005d4:	008b05b3          	add	a1,s6,s0
ffffffffc02005d8:	15fd                	addi	a1,a1,-1
ffffffffc02005da:	00002517          	auipc	a0,0x2
ffffffffc02005de:	a3e50513          	addi	a0,a0,-1474 # ffffffffc0202018 <etext+0x284>
ffffffffc02005e2:	b6fff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc02005e6:	00002517          	auipc	a0,0x2
ffffffffc02005ea:	a8250513          	addi	a0,a0,-1406 # ffffffffc0202068 <etext+0x2d4>
        memory_base = mem_base;
ffffffffc02005ee:	00006797          	auipc	a5,0x6
ffffffffc02005f2:	b887b123          	sd	s0,-1150(a5) # ffffffffc0206170 <memory_base>
        memory_size = mem_size;
ffffffffc02005f6:	00006797          	auipc	a5,0x6
ffffffffc02005fa:	b967b123          	sd	s6,-1150(a5) # ffffffffc0206178 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc02005fe:	b3f5                	j	ffffffffc02003ea <dtb_init+0x186>

ffffffffc0200600 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200600:	00006517          	auipc	a0,0x6
ffffffffc0200604:	b7053503          	ld	a0,-1168(a0) # ffffffffc0206170 <memory_base>
ffffffffc0200608:	8082                	ret

ffffffffc020060a <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc020060a:	00006517          	auipc	a0,0x6
ffffffffc020060e:	b6e53503          	ld	a0,-1170(a0) # ffffffffc0206178 <memory_size>
ffffffffc0200612:	8082                	ret

ffffffffc0200614 <run_buddy_system_test>:
    buddy_system_check_difficult_alloc_and_free_condition();
    cprintf("BUDDY TEST COMPLETED\n");
}

// 导出测试函数供外部调用
void run_buddy_system_test(void) {
ffffffffc0200614:	7159                	addi	sp,sp,-112
    cprintf("BEGIN BUDDY TEST\n");
ffffffffc0200616:	00002517          	auipc	a0,0x2
ffffffffc020061a:	a6a50513          	addi	a0,a0,-1430 # ffffffffc0202080 <etext+0x2ec>
void run_buddy_system_test(void) {
ffffffffc020061e:	f486                	sd	ra,104(sp)
ffffffffc0200620:	f0a2                	sd	s0,96(sp)
ffffffffc0200622:	eca6                	sd	s1,88(sp)
ffffffffc0200624:	e8ca                	sd	s2,80(sp)
ffffffffc0200626:	e4ce                	sd	s3,72(sp)
ffffffffc0200628:	e0d2                	sd	s4,64(sp)
ffffffffc020062a:	fc56                	sd	s5,56(sp)
ffffffffc020062c:	f85a                	sd	s6,48(sp)
ffffffffc020062e:	f45e                	sd	s7,40(sp)
ffffffffc0200630:	f062                	sd	s8,32(sp)
ffffffffc0200632:	ec66                	sd	s9,24(sp)
ffffffffc0200634:	e86a                	sd	s10,16(sp)
ffffffffc0200636:	e46e                	sd	s11,8(sp)
    cprintf("BEGIN BUDDY TEST\n");
ffffffffc0200638:	b19ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("CHECK EASY ALLOC:\n");
ffffffffc020063c:	00002517          	auipc	a0,0x2
ffffffffc0200640:	a5c50513          	addi	a0,a0,-1444 # ffffffffc0202098 <etext+0x304>
ffffffffc0200644:	b0dff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("nr_free=%d\n", nr_free);
ffffffffc0200648:	00006997          	auipc	s3,0x6
ffffffffc020064c:	b3898993          	addi	s3,s3,-1224 # ffffffffc0206180 <nr_free>
ffffffffc0200650:	0009a583          	lw	a1,0(s3)
ffffffffc0200654:	00002517          	auipc	a0,0x2
ffffffffc0200658:	a5c50513          	addi	a0,a0,-1444 # ffffffffc02020b0 <etext+0x31c>
ffffffffc020065c:	00006417          	auipc	s0,0x6
ffffffffc0200660:	9bc40413          	addi	s0,s0,-1604 # ffffffffc0206018 <buddy_array>
ffffffffc0200664:	aedff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("p0 alloc 10 pages\n");
ffffffffc0200668:	00002517          	auipc	a0,0x2
ffffffffc020066c:	a5850513          	addi	a0,a0,-1448 # ffffffffc02020c0 <etext+0x32c>
ffffffffc0200670:	ae1ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    p0 = alloc_pages(10);
ffffffffc0200674:	4529                	li	a0,10
ffffffffc0200676:	056010ef          	jal	ra,ffffffffc02016cc <alloc_pages>
ffffffffc020067a:	8a2a                	mv	s4,a0
    cprintf("---- free lists ----\n");
ffffffffc020067c:	00002517          	auipc	a0,0x2
ffffffffc0200680:	a5c50513          	addi	a0,a0,-1444 # ffffffffc02020d8 <etext+0x344>
ffffffffc0200684:	84a2                	mv	s1,s0
ffffffffc0200686:	acbff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc020068a:	4901                	li	s2,0
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc020068c:	4b85                	li	s7,1
ffffffffc020068e:	00002b17          	auipc	s6,0x2
ffffffffc0200692:	a62b0b13          	addi	s6,s6,-1438 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200696:	4ab9                	li	s5,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc0200698:	649c                	ld	a5,8(s1)
ffffffffc020069a:	00f48963          	beq	s1,a5,ffffffffc02006ac <run_buddy_system_test+0x98>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc020069e:	86a6                	mv	a3,s1
ffffffffc02006a0:	012b963b          	sllw	a2,s7,s2
ffffffffc02006a4:	85ca                	mv	a1,s2
ffffffffc02006a6:	855a                	mv	a0,s6
ffffffffc02006a8:	aa9ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc02006ac:	2905                	addiw	s2,s2,1
ffffffffc02006ae:	04e1                	addi	s1,s1,24
ffffffffc02006b0:	ff5914e3          	bne	s2,s5,ffffffffc0200698 <run_buddy_system_test+0x84>
    cprintf("---- end ----\n");
ffffffffc02006b4:	00002517          	auipc	a0,0x2
ffffffffc02006b8:	a6c50513          	addi	a0,a0,-1428 # ffffffffc0202120 <etext+0x38c>
ffffffffc02006bc:	a95ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("p1 alloc 10 pages\n");
ffffffffc02006c0:	00002517          	auipc	a0,0x2
ffffffffc02006c4:	a7050513          	addi	a0,a0,-1424 # ffffffffc0202130 <etext+0x39c>
ffffffffc02006c8:	a89ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    p1 = alloc_pages(10);
ffffffffc02006cc:	4529                	li	a0,10
ffffffffc02006ce:	7ff000ef          	jal	ra,ffffffffc02016cc <alloc_pages>
ffffffffc02006d2:	8d2a                	mv	s10,a0
    cprintf("---- free lists ----\n");
ffffffffc02006d4:	00002517          	auipc	a0,0x2
ffffffffc02006d8:	a0450513          	addi	a0,a0,-1532 # ffffffffc02020d8 <etext+0x344>
ffffffffc02006dc:	00006497          	auipc	s1,0x6
ffffffffc02006e0:	93c48493          	addi	s1,s1,-1732 # ffffffffc0206018 <buddy_array>
ffffffffc02006e4:	a6dff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc02006e8:	4901                	li	s2,0
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc02006ea:	4b85                	li	s7,1
ffffffffc02006ec:	00002b17          	auipc	s6,0x2
ffffffffc02006f0:	a04b0b13          	addi	s6,s6,-1532 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc02006f4:	4ab9                	li	s5,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc02006f6:	649c                	ld	a5,8(s1)
ffffffffc02006f8:	00f48963          	beq	s1,a5,ffffffffc020070a <run_buddy_system_test+0xf6>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc02006fc:	86a6                	mv	a3,s1
ffffffffc02006fe:	012b963b          	sllw	a2,s7,s2
ffffffffc0200702:	85ca                	mv	a1,s2
ffffffffc0200704:	855a                	mv	a0,s6
ffffffffc0200706:	a4bff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc020070a:	2905                	addiw	s2,s2,1
ffffffffc020070c:	04e1                	addi	s1,s1,24
ffffffffc020070e:	ff5914e3          	bne	s2,s5,ffffffffc02006f6 <run_buddy_system_test+0xe2>
    cprintf("---- end ----\n");
ffffffffc0200712:	00002517          	auipc	a0,0x2
ffffffffc0200716:	a0e50513          	addi	a0,a0,-1522 # ffffffffc0202120 <etext+0x38c>
ffffffffc020071a:	a37ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("p2 alloc 10 pages\n");
ffffffffc020071e:	00002517          	auipc	a0,0x2
ffffffffc0200722:	a2a50513          	addi	a0,a0,-1494 # ffffffffc0202148 <etext+0x3b4>
ffffffffc0200726:	a2bff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    p2 = alloc_pages(10);
ffffffffc020072a:	4529                	li	a0,10
ffffffffc020072c:	7a1000ef          	jal	ra,ffffffffc02016cc <alloc_pages>
ffffffffc0200730:	8aaa                	mv	s5,a0
    cprintf("---- free lists ----\n");
ffffffffc0200732:	00002517          	auipc	a0,0x2
ffffffffc0200736:	9a650513          	addi	a0,a0,-1626 # ffffffffc02020d8 <etext+0x344>
ffffffffc020073a:	00006497          	auipc	s1,0x6
ffffffffc020073e:	8de48493          	addi	s1,s1,-1826 # ffffffffc0206018 <buddy_array>
ffffffffc0200742:	a0fff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200746:	4901                	li	s2,0
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200748:	4c05                	li	s8,1
ffffffffc020074a:	00002b97          	auipc	s7,0x2
ffffffffc020074e:	9a6b8b93          	addi	s7,s7,-1626 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200752:	4b39                	li	s6,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc0200754:	649c                	ld	a5,8(s1)
ffffffffc0200756:	00f48963          	beq	s1,a5,ffffffffc0200768 <run_buddy_system_test+0x154>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc020075a:	86a6                	mv	a3,s1
ffffffffc020075c:	012c163b          	sllw	a2,s8,s2
ffffffffc0200760:	85ca                	mv	a1,s2
ffffffffc0200762:	855e                	mv	a0,s7
ffffffffc0200764:	9edff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200768:	2905                	addiw	s2,s2,1
ffffffffc020076a:	04e1                	addi	s1,s1,24
ffffffffc020076c:	ff6914e3          	bne	s2,s6,ffffffffc0200754 <run_buddy_system_test+0x140>
    cprintf("---- end ----\n");
ffffffffc0200770:	00002517          	auipc	a0,0x2
ffffffffc0200774:	9b050513          	addi	a0,a0,-1616 # ffffffffc0202120 <etext+0x38c>
ffffffffc0200778:	9d9ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("p0=0x%016lx\n", p0);
ffffffffc020077c:	85d2                	mv	a1,s4
ffffffffc020077e:	00002517          	auipc	a0,0x2
ffffffffc0200782:	9e250513          	addi	a0,a0,-1566 # ffffffffc0202160 <etext+0x3cc>
ffffffffc0200786:	9cbff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("p1=0x%016lx\n", p1);
ffffffffc020078a:	85ea                	mv	a1,s10
ffffffffc020078c:	00002517          	auipc	a0,0x2
ffffffffc0200790:	9e450513          	addi	a0,a0,-1564 # ffffffffc0202170 <etext+0x3dc>
ffffffffc0200794:	9bdff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("p2=0x%016lx\n", p2);
ffffffffc0200798:	85d6                	mv	a1,s5
ffffffffc020079a:	00002517          	auipc	a0,0x2
ffffffffc020079e:	9e650513          	addi	a0,a0,-1562 # ffffffffc0202180 <etext+0x3ec>
ffffffffc02007a2:	9afff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02007a6:	7baa0463          	beq	s4,s10,ffffffffc0200f4e <run_buddy_system_test+0x93a>
ffffffffc02007aa:	7b5a0263          	beq	s4,s5,ffffffffc0200f4e <run_buddy_system_test+0x93a>
ffffffffc02007ae:	7b5d0063          	beq	s10,s5,ffffffffc0200f4e <run_buddy_system_test+0x93a>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02007b2:	000a2783          	lw	a5,0(s4)
ffffffffc02007b6:	76079c63          	bnez	a5,ffffffffc0200f2e <run_buddy_system_test+0x91a>
ffffffffc02007ba:	000d2783          	lw	a5,0(s10)
ffffffffc02007be:	76079863          	bnez	a5,ffffffffc0200f2e <run_buddy_system_test+0x91a>
    return page2ppn(page) << PGSHIFT;
}



static inline int page_ref(struct Page *page) { return page->ref; }
ffffffffc02007c2:	000aa903          	lw	s2,0(s5)
ffffffffc02007c6:	76091463          	bnez	s2,ffffffffc0200f2e <run_buddy_system_test+0x91a>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02007ca:	00006797          	auipc	a5,0x6
ffffffffc02007ce:	9c678793          	addi	a5,a5,-1594 # ffffffffc0206190 <pages>
ffffffffc02007d2:	639c                	ld	a5,0(a5)
ffffffffc02007d4:	00002b97          	auipc	s7,0x2
ffffffffc02007d8:	2b4bbb83          	ld	s7,692(s7) # ffffffffc0202a88 <error_string+0x38>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02007dc:	00006c17          	auipc	s8,0x6
ffffffffc02007e0:	9acc0c13          	addi	s8,s8,-1620 # ffffffffc0206188 <npage>
ffffffffc02007e4:	40fa0733          	sub	a4,s4,a5
ffffffffc02007e8:	870d                	srai	a4,a4,0x3
ffffffffc02007ea:	03770733          	mul	a4,a4,s7
ffffffffc02007ee:	000c3683          	ld	a3,0(s8)
ffffffffc02007f2:	00002b17          	auipc	s6,0x2
ffffffffc02007f6:	29eb3b03          	ld	s6,670(s6) # ffffffffc0202a90 <nbase>
ffffffffc02007fa:	06b2                	slli	a3,a3,0xc
ffffffffc02007fc:	975a                	add	a4,a4,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc02007fe:	0732                	slli	a4,a4,0xc
ffffffffc0200800:	02d777e3          	bgeu	a4,a3,ffffffffc020102e <run_buddy_system_test+0xa1a>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200804:	40fd0733          	sub	a4,s10,a5
ffffffffc0200808:	870d                	srai	a4,a4,0x3
ffffffffc020080a:	03770733          	mul	a4,a4,s7
ffffffffc020080e:	975a                	add	a4,a4,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0200810:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200812:	04d77ee3          	bgeu	a4,a3,ffffffffc020106e <run_buddy_system_test+0xa5a>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200816:	40fa87b3          	sub	a5,s5,a5
ffffffffc020081a:	878d                	srai	a5,a5,0x3
ffffffffc020081c:	037787b3          	mul	a5,a5,s7
ffffffffc0200820:	97da                	add	a5,a5,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0200822:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200824:	02d7f5e3          	bgeu	a5,a3,ffffffffc020104e <run_buddy_system_test+0xa3a>
    cprintf("CHECK EASY FREE:\n");
ffffffffc0200828:	00002517          	auipc	a0,0x2
ffffffffc020082c:	a6050513          	addi	a0,a0,-1440 # ffffffffc0202288 <etext+0x4f4>
ffffffffc0200830:	921ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("free p0...\n");
ffffffffc0200834:	00002517          	auipc	a0,0x2
ffffffffc0200838:	a6c50513          	addi	a0,a0,-1428 # ffffffffc02022a0 <etext+0x50c>
ffffffffc020083c:	915ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    free_pages(p0, 10);
ffffffffc0200840:	8552                	mv	a0,s4
ffffffffc0200842:	45a9                	li	a1,10
ffffffffc0200844:	695000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    cprintf("after free p0, nr_free=%d\n", nr_free);
ffffffffc0200848:	0009a583          	lw	a1,0(s3)
ffffffffc020084c:	00002517          	auipc	a0,0x2
ffffffffc0200850:	a6450513          	addi	a0,a0,-1436 # ffffffffc02022b0 <etext+0x51c>
    cprintf("---- free lists ----\n");
ffffffffc0200854:	00005497          	auipc	s1,0x5
ffffffffc0200858:	7c448493          	addi	s1,s1,1988 # ffffffffc0206018 <buddy_array>
    cprintf("after free p0, nr_free=%d\n", nr_free);
ffffffffc020085c:	8f5ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("---- free lists ----\n");
ffffffffc0200860:	00002517          	auipc	a0,0x2
ffffffffc0200864:	87850513          	addi	a0,a0,-1928 # ffffffffc02020d8 <etext+0x344>
ffffffffc0200868:	8e9ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc020086c:	4d81                	li	s11,0
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc020086e:	00002a17          	auipc	s4,0x2
ffffffffc0200872:	882a0a13          	addi	s4,s4,-1918 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200876:	4cb9                	li	s9,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc0200878:	649c                	ld	a5,8(s1)
ffffffffc020087a:	00f48a63          	beq	s1,a5,ffffffffc020088e <run_buddy_system_test+0x27a>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc020087e:	4785                	li	a5,1
ffffffffc0200880:	86a6                	mv	a3,s1
ffffffffc0200882:	01b7963b          	sllw	a2,a5,s11
ffffffffc0200886:	85ee                	mv	a1,s11
ffffffffc0200888:	8552                	mv	a0,s4
ffffffffc020088a:	8c7ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc020088e:	2d85                	addiw	s11,s11,1
ffffffffc0200890:	04e1                	addi	s1,s1,24
ffffffffc0200892:	ff9d93e3          	bne	s11,s9,ffffffffc0200878 <run_buddy_system_test+0x264>
    cprintf("---- end ----\n");
ffffffffc0200896:	00002517          	auipc	a0,0x2
ffffffffc020089a:	88a50513          	addi	a0,a0,-1910 # ffffffffc0202120 <etext+0x38c>
ffffffffc020089e:	8b3ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("free p1...\n");
ffffffffc02008a2:	00002517          	auipc	a0,0x2
ffffffffc02008a6:	a2e50513          	addi	a0,a0,-1490 # ffffffffc02022d0 <etext+0x53c>
ffffffffc02008aa:	8a7ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    free_pages(p1, 10);
ffffffffc02008ae:	856a                	mv	a0,s10
ffffffffc02008b0:	45a9                	li	a1,10
ffffffffc02008b2:	627000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    cprintf("after free p1, nr_free=%d\n", nr_free);
ffffffffc02008b6:	0009a583          	lw	a1,0(s3)
ffffffffc02008ba:	00002517          	auipc	a0,0x2
ffffffffc02008be:	a2650513          	addi	a0,a0,-1498 # ffffffffc02022e0 <etext+0x54c>
    cprintf("---- free lists ----\n");
ffffffffc02008c2:	00005497          	auipc	s1,0x5
ffffffffc02008c6:	75648493          	addi	s1,s1,1878 # ffffffffc0206018 <buddy_array>
    cprintf("after free p1, nr_free=%d\n", nr_free);
ffffffffc02008ca:	887ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("---- free lists ----\n");
ffffffffc02008ce:	00002517          	auipc	a0,0x2
ffffffffc02008d2:	80a50513          	addi	a0,a0,-2038 # ffffffffc02020d8 <etext+0x344>
ffffffffc02008d6:	87bff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc02008da:	4a01                	li	s4,0
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc02008dc:	4d85                	li	s11,1
ffffffffc02008de:	00002d17          	auipc	s10,0x2
ffffffffc02008e2:	812d0d13          	addi	s10,s10,-2030 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc02008e6:	4cb9                	li	s9,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc02008e8:	649c                	ld	a5,8(s1)
ffffffffc02008ea:	00f48963          	beq	s1,a5,ffffffffc02008fc <run_buddy_system_test+0x2e8>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc02008ee:	86a6                	mv	a3,s1
ffffffffc02008f0:	014d963b          	sllw	a2,s11,s4
ffffffffc02008f4:	85d2                	mv	a1,s4
ffffffffc02008f6:	856a                	mv	a0,s10
ffffffffc02008f8:	859ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc02008fc:	2a05                	addiw	s4,s4,1
ffffffffc02008fe:	04e1                	addi	s1,s1,24
ffffffffc0200900:	ff9a14e3          	bne	s4,s9,ffffffffc02008e8 <run_buddy_system_test+0x2d4>
    cprintf("---- end ----\n");
ffffffffc0200904:	00002517          	auipc	a0,0x2
ffffffffc0200908:	81c50513          	addi	a0,a0,-2020 # ffffffffc0202120 <etext+0x38c>
ffffffffc020090c:	845ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("free p2...\n");
ffffffffc0200910:	00002517          	auipc	a0,0x2
ffffffffc0200914:	9f050513          	addi	a0,a0,-1552 # ffffffffc0202300 <etext+0x56c>
ffffffffc0200918:	839ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    free_pages(p2, 10);
ffffffffc020091c:	8556                	mv	a0,s5
ffffffffc020091e:	45a9                	li	a1,10
ffffffffc0200920:	5b9000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    cprintf("after free p2, nr_free=%d\n", nr_free);
ffffffffc0200924:	0009a583          	lw	a1,0(s3)
ffffffffc0200928:	00002517          	auipc	a0,0x2
ffffffffc020092c:	9e850513          	addi	a0,a0,-1560 # ffffffffc0202310 <etext+0x57c>
    cprintf("---- free lists ----\n");
ffffffffc0200930:	00005497          	auipc	s1,0x5
ffffffffc0200934:	6e848493          	addi	s1,s1,1768 # ffffffffc0206018 <buddy_array>
    cprintf("after free p2, nr_free=%d\n", nr_free);
ffffffffc0200938:	819ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("---- free lists ----\n");
ffffffffc020093c:	00001517          	auipc	a0,0x1
ffffffffc0200940:	79c50513          	addi	a0,a0,1948 # ffffffffc02020d8 <etext+0x344>
ffffffffc0200944:	80dff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200948:	4a01                	li	s4,0
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc020094a:	4d05                	li	s10,1
ffffffffc020094c:	00001a97          	auipc	s5,0x1
ffffffffc0200950:	7a4a8a93          	addi	s5,s5,1956 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200954:	4db9                	li	s11,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc0200956:	649c                	ld	a5,8(s1)
ffffffffc0200958:	00f48963          	beq	s1,a5,ffffffffc020096a <run_buddy_system_test+0x356>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc020095c:	86a6                	mv	a3,s1
ffffffffc020095e:	014d163b          	sllw	a2,s10,s4
ffffffffc0200962:	85d2                	mv	a1,s4
ffffffffc0200964:	8556                	mv	a0,s5
ffffffffc0200966:	feaff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc020096a:	2a05                	addiw	s4,s4,1
ffffffffc020096c:	04e1                	addi	s1,s1,24
ffffffffc020096e:	ffba14e3          	bne	s4,s11,ffffffffc0200956 <run_buddy_system_test+0x342>
    cprintf("---- end ----\n");
ffffffffc0200972:	00001517          	auipc	a0,0x1
ffffffffc0200976:	7ae50513          	addi	a0,a0,1966 # ffffffffc0202120 <etext+0x38c>
ffffffffc020097a:	fd6ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("CHECK MIN ALLOC:\n");
ffffffffc020097e:	00002517          	auipc	a0,0x2
ffffffffc0200982:	9b250513          	addi	a0,a0,-1614 # ffffffffc0202330 <etext+0x59c>
ffffffffc0200986:	fcaff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("nr_free=%d\n", nr_free);
ffffffffc020098a:	0009a583          	lw	a1,0(s3)
ffffffffc020098e:	00001517          	auipc	a0,0x1
ffffffffc0200992:	72250513          	addi	a0,a0,1826 # ffffffffc02020b0 <etext+0x31c>
    cprintf("---- free lists ----\n");
ffffffffc0200996:	00005497          	auipc	s1,0x5
ffffffffc020099a:	68248493          	addi	s1,s1,1666 # ffffffffc0206018 <buddy_array>
    cprintf("nr_free=%d\n", nr_free);
ffffffffc020099e:	fb2ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    struct Page *p3 = alloc_pages(1);
ffffffffc02009a2:	4505                	li	a0,1
ffffffffc02009a4:	529000ef          	jal	ra,ffffffffc02016cc <alloc_pages>
ffffffffc02009a8:	8a2a                	mv	s4,a0
    cprintf("alloc p3 (1 page)\n");
ffffffffc02009aa:	00002517          	auipc	a0,0x2
ffffffffc02009ae:	99e50513          	addi	a0,a0,-1634 # ffffffffc0202348 <etext+0x5b4>
ffffffffc02009b2:	f9eff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("---- free lists ----\n");
ffffffffc02009b6:	00001517          	auipc	a0,0x1
ffffffffc02009ba:	72250513          	addi	a0,a0,1826 # ffffffffc02020d8 <etext+0x344>
ffffffffc02009be:	f92ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc02009c2:	4d05                	li	s10,1
ffffffffc02009c4:	00001a97          	auipc	s5,0x1
ffffffffc02009c8:	72ca8a93          	addi	s5,s5,1836 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc02009cc:	4db9                	li	s11,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc02009ce:	649c                	ld	a5,8(s1)
ffffffffc02009d0:	00f48963          	beq	s1,a5,ffffffffc02009e2 <run_buddy_system_test+0x3ce>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc02009d4:	86a6                	mv	a3,s1
ffffffffc02009d6:	012d163b          	sllw	a2,s10,s2
ffffffffc02009da:	85ca                	mv	a1,s2
ffffffffc02009dc:	8556                	mv	a0,s5
ffffffffc02009de:	f72ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc02009e2:	2905                	addiw	s2,s2,1
ffffffffc02009e4:	04e1                	addi	s1,s1,24
ffffffffc02009e6:	ffb914e3          	bne	s2,s11,ffffffffc02009ce <run_buddy_system_test+0x3ba>
    cprintf("---- end ----\n");
ffffffffc02009ea:	00001517          	auipc	a0,0x1
ffffffffc02009ee:	73650513          	addi	a0,a0,1846 # ffffffffc0202120 <etext+0x38c>
ffffffffc02009f2:	f5eff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("p3=0x%016lx\n", p3);
ffffffffc02009f6:	85d2                	mv	a1,s4
ffffffffc02009f8:	00002517          	auipc	a0,0x2
ffffffffc02009fc:	96850513          	addi	a0,a0,-1688 # ffffffffc0202360 <etext+0x5cc>
ffffffffc0200a00:	f50ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    assert(p3 != NULL);
ffffffffc0200a04:	6a0a0563          	beqz	s4,ffffffffc02010ae <run_buddy_system_test+0xa9a>
static inline int page_ref(struct Page *page) { return page->ref; }
ffffffffc0200a08:	000a2483          	lw	s1,0(s4)
    assert(page_ref(p3) == 0);
ffffffffc0200a0c:	68049163          	bnez	s1,ffffffffc020108e <run_buddy_system_test+0xa7a>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200a10:	00005797          	auipc	a5,0x5
ffffffffc0200a14:	78078793          	addi	a5,a5,1920 # ffffffffc0206190 <pages>
ffffffffc0200a18:	639c                	ld	a5,0(a5)
    assert(page2pa(p3) < npage * PGSIZE);
ffffffffc0200a1a:	000c3703          	ld	a4,0(s8)
ffffffffc0200a1e:	40fa07b3          	sub	a5,s4,a5
ffffffffc0200a22:	878d                	srai	a5,a5,0x3
ffffffffc0200a24:	037787b3          	mul	a5,a5,s7
ffffffffc0200a28:	0732                	slli	a4,a4,0xc
ffffffffc0200a2a:	97da                	add	a5,a5,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0200a2c:	07b2                	slli	a5,a5,0xc
ffffffffc0200a2e:	5ee7f063          	bgeu	a5,a4,ffffffffc020100e <run_buddy_system_test+0x9fa>
    cprintf("free p3...\n");
ffffffffc0200a32:	00002517          	auipc	a0,0x2
ffffffffc0200a36:	98650513          	addi	a0,a0,-1658 # ffffffffc02023b8 <etext+0x624>
ffffffffc0200a3a:	f16ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    free_pages(p3, 1);
ffffffffc0200a3e:	8552                	mv	a0,s4
ffffffffc0200a40:	4585                	li	a1,1
ffffffffc0200a42:	497000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    cprintf("after free p3, nr_free=%d\n", nr_free);
ffffffffc0200a46:	0009a583          	lw	a1,0(s3)
ffffffffc0200a4a:	00002517          	auipc	a0,0x2
ffffffffc0200a4e:	97e50513          	addi	a0,a0,-1666 # ffffffffc02023c8 <etext+0x634>
    cprintf("---- free lists ----\n");
ffffffffc0200a52:	00005917          	auipc	s2,0x5
ffffffffc0200a56:	5c690913          	addi	s2,s2,1478 # ffffffffc0206018 <buddy_array>
    cprintf("after free p3, nr_free=%d\n", nr_free);
ffffffffc0200a5a:	ef6ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("---- free lists ----\n");
ffffffffc0200a5e:	00001517          	auipc	a0,0x1
ffffffffc0200a62:	67a50513          	addi	a0,a0,1658 # ffffffffc02020d8 <etext+0x344>
ffffffffc0200a66:	eeaff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200a6a:	4a01                	li	s4,0
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200a6c:	4d05                	li	s10,1
ffffffffc0200a6e:	00001a97          	auipc	s5,0x1
ffffffffc0200a72:	682a8a93          	addi	s5,s5,1666 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200a76:	4db9                	li	s11,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc0200a78:	00893783          	ld	a5,8(s2)
ffffffffc0200a7c:	00f90963          	beq	s2,a5,ffffffffc0200a8e <run_buddy_system_test+0x47a>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200a80:	86ca                	mv	a3,s2
ffffffffc0200a82:	014d163b          	sllw	a2,s10,s4
ffffffffc0200a86:	85d2                	mv	a1,s4
ffffffffc0200a88:	8556                	mv	a0,s5
ffffffffc0200a8a:	ec6ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200a8e:	2a05                	addiw	s4,s4,1
ffffffffc0200a90:	0961                	addi	s2,s2,24
ffffffffc0200a92:	ffba13e3          	bne	s4,s11,ffffffffc0200a78 <run_buddy_system_test+0x464>
    cprintf("---- end ----\n");
ffffffffc0200a96:	00001517          	auipc	a0,0x1
ffffffffc0200a9a:	68a50513          	addi	a0,a0,1674 # ffffffffc0202120 <etext+0x38c>
ffffffffc0200a9e:	eb2ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("CHECK MAX ALLOC:\n");
ffffffffc0200aa2:	00002517          	auipc	a0,0x2
ffffffffc0200aa6:	94650513          	addi	a0,a0,-1722 # ffffffffc02023e8 <etext+0x654>
ffffffffc0200aaa:	ea6ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("nr_free=%d\n", nr_free);
ffffffffc0200aae:	0009a583          	lw	a1,0(s3)
ffffffffc0200ab2:	00001517          	auipc	a0,0x1
ffffffffc0200ab6:	5fe50513          	addi	a0,a0,1534 # ffffffffc02020b0 <etext+0x31c>
ffffffffc0200aba:	e96ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("try alloc max block: %d pages\n", max_pages);
ffffffffc0200abe:	6589                	lui	a1,0x2
ffffffffc0200ac0:	00002517          	auipc	a0,0x2
ffffffffc0200ac4:	94050513          	addi	a0,a0,-1728 # ffffffffc0202400 <etext+0x66c>
ffffffffc0200ac8:	e88ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    struct Page *p4 = alloc_pages(max_pages);
ffffffffc0200acc:	6509                	lui	a0,0x2
ffffffffc0200ace:	3ff000ef          	jal	ra,ffffffffc02016cc <alloc_pages>
ffffffffc0200ad2:	8aaa                	mv	s5,a0
    if (p4 != NULL) {
ffffffffc0200ad4:	44050663          	beqz	a0,ffffffffc0200f20 <run_buddy_system_test+0x90c>
        cprintf("p4=0x%016lx\n", p4);
ffffffffc0200ad8:	85aa                	mv	a1,a0
ffffffffc0200ada:	00002517          	auipc	a0,0x2
ffffffffc0200ade:	94650513          	addi	a0,a0,-1722 # ffffffffc0202420 <etext+0x68c>
ffffffffc0200ae2:	e6eff0ef          	jal	ra,ffffffffc0200150 <cprintf>
static inline int page_ref(struct Page *page) { return page->ref; }
ffffffffc0200ae6:	000aaa03          	lw	s4,0(s5)
        assert(page_ref(p4) == 0);
ffffffffc0200aea:	500a1263          	bnez	s4,ffffffffc0200fee <run_buddy_system_test+0x9da>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200aee:	00005797          	auipc	a5,0x5
ffffffffc0200af2:	6a278793          	addi	a5,a5,1698 # ffffffffc0206190 <pages>
ffffffffc0200af6:	639c                	ld	a5,0(a5)
        assert(page2pa(p4) < npage * PGSIZE);
ffffffffc0200af8:	000c3703          	ld	a4,0(s8)
ffffffffc0200afc:	40fa87b3          	sub	a5,s5,a5
ffffffffc0200b00:	878d                	srai	a5,a5,0x3
ffffffffc0200b02:	037787b3          	mul	a5,a5,s7
ffffffffc0200b06:	0732                	slli	a4,a4,0xc
ffffffffc0200b08:	97da                	add	a5,a5,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0200b0a:	07b2                	slli	a5,a5,0xc
ffffffffc0200b0c:	4ce7f163          	bgeu	a5,a4,ffffffffc0200fce <run_buddy_system_test+0x9ba>
        cprintf("after alloc p4:\n");
ffffffffc0200b10:	00002517          	auipc	a0,0x2
ffffffffc0200b14:	95850513          	addi	a0,a0,-1704 # ffffffffc0202468 <etext+0x6d4>
ffffffffc0200b18:	e38ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("---- free lists ----\n");
ffffffffc0200b1c:	00001517          	auipc	a0,0x1
ffffffffc0200b20:	5bc50513          	addi	a0,a0,1468 # ffffffffc02020d8 <etext+0x344>
ffffffffc0200b24:	e2cff0ef          	jal	ra,ffffffffc0200150 <cprintf>
ffffffffc0200b28:	00005917          	auipc	s2,0x5
ffffffffc0200b2c:	4f090913          	addi	s2,s2,1264 # ffffffffc0206018 <buddy_array>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200b30:	4d81                	li	s11,0
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200b32:	00001d17          	auipc	s10,0x1
ffffffffc0200b36:	5bed0d13          	addi	s10,s10,1470 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200b3a:	4cb9                	li	s9,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc0200b3c:	00893783          	ld	a5,8(s2)
ffffffffc0200b40:	00f90a63          	beq	s2,a5,ffffffffc0200b54 <run_buddy_system_test+0x540>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200b44:	4785                	li	a5,1
ffffffffc0200b46:	86ca                	mv	a3,s2
ffffffffc0200b48:	01b7963b          	sllw	a2,a5,s11
ffffffffc0200b4c:	85ee                	mv	a1,s11
ffffffffc0200b4e:	856a                	mv	a0,s10
ffffffffc0200b50:	e00ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200b54:	2d85                	addiw	s11,s11,1
ffffffffc0200b56:	0961                	addi	s2,s2,24
ffffffffc0200b58:	ff9d92e3          	bne	s11,s9,ffffffffc0200b3c <run_buddy_system_test+0x528>
    cprintf("---- end ----\n");
ffffffffc0200b5c:	00001517          	auipc	a0,0x1
ffffffffc0200b60:	5c450513          	addi	a0,a0,1476 # ffffffffc0202120 <etext+0x38c>
ffffffffc0200b64:	decff0ef          	jal	ra,ffffffffc0200150 <cprintf>
        cprintf("free p4...\n");
ffffffffc0200b68:	00002517          	auipc	a0,0x2
ffffffffc0200b6c:	91850513          	addi	a0,a0,-1768 # ffffffffc0202480 <etext+0x6ec>
ffffffffc0200b70:	de0ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
        free_pages(p4, max_pages);
ffffffffc0200b74:	8556                	mv	a0,s5
ffffffffc0200b76:	6589                	lui	a1,0x2
ffffffffc0200b78:	361000ef          	jal	ra,ffffffffc02016d8 <free_pages>
        cprintf("after free p4, nr_free=%d\n", nr_free);
ffffffffc0200b7c:	0009a583          	lw	a1,0(s3)
ffffffffc0200b80:	00002517          	auipc	a0,0x2
ffffffffc0200b84:	91050513          	addi	a0,a0,-1776 # ffffffffc0202490 <etext+0x6fc>
    cprintf("---- free lists ----\n");
ffffffffc0200b88:	00005917          	auipc	s2,0x5
ffffffffc0200b8c:	49090913          	addi	s2,s2,1168 # ffffffffc0206018 <buddy_array>
        cprintf("after free p4, nr_free=%d\n", nr_free);
ffffffffc0200b90:	dc0ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("---- free lists ----\n");
ffffffffc0200b94:	00001517          	auipc	a0,0x1
ffffffffc0200b98:	54450513          	addi	a0,a0,1348 # ffffffffc02020d8 <etext+0x344>
ffffffffc0200b9c:	db4ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200ba0:	4d05                	li	s10,1
ffffffffc0200ba2:	00001a97          	auipc	s5,0x1
ffffffffc0200ba6:	54ea8a93          	addi	s5,s5,1358 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200baa:	4db9                	li	s11,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc0200bac:	00893783          	ld	a5,8(s2)
ffffffffc0200bb0:	00f90963          	beq	s2,a5,ffffffffc0200bc2 <run_buddy_system_test+0x5ae>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200bb4:	86ca                	mv	a3,s2
ffffffffc0200bb6:	014d163b          	sllw	a2,s10,s4
ffffffffc0200bba:	85d2                	mv	a1,s4
ffffffffc0200bbc:	8556                	mv	a0,s5
ffffffffc0200bbe:	d92ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200bc2:	2a05                	addiw	s4,s4,1
ffffffffc0200bc4:	0961                	addi	s2,s2,24
ffffffffc0200bc6:	ffba13e3          	bne	s4,s11,ffffffffc0200bac <run_buddy_system_test+0x598>
    cprintf("---- end ----\n");
ffffffffc0200bca:	00001517          	auipc	a0,0x1
ffffffffc0200bce:	55650513          	addi	a0,a0,1366 # ffffffffc0202120 <etext+0x38c>
ffffffffc0200bd2:	d7eff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("CHECK DIFFICULT ALLOC:\n");
ffffffffc0200bd6:	00002517          	auipc	a0,0x2
ffffffffc0200bda:	8ea50513          	addi	a0,a0,-1814 # ffffffffc02024c0 <etext+0x72c>
ffffffffc0200bde:	d72ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("nr_free=%d\n", nr_free);
ffffffffc0200be2:	0009a583          	lw	a1,0(s3)
ffffffffc0200be6:	00001517          	auipc	a0,0x1
ffffffffc0200bea:	4ca50513          	addi	a0,a0,1226 # ffffffffc02020b0 <etext+0x31c>
    cprintf("---- free lists ----\n");
ffffffffc0200bee:	00005917          	auipc	s2,0x5
ffffffffc0200bf2:	42a90913          	addi	s2,s2,1066 # ffffffffc0206018 <buddy_array>
    cprintf("nr_free=%d\n", nr_free);
ffffffffc0200bf6:	d5aff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("p0 alloc 10 pages\n");
ffffffffc0200bfa:	00001517          	auipc	a0,0x1
ffffffffc0200bfe:	4c650513          	addi	a0,a0,1222 # ffffffffc02020c0 <etext+0x32c>
ffffffffc0200c02:	d4eff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    p0 = alloc_pages(10);
ffffffffc0200c06:	4529                	li	a0,10
ffffffffc0200c08:	2c5000ef          	jal	ra,ffffffffc02016cc <alloc_pages>
ffffffffc0200c0c:	8aaa                	mv	s5,a0
    cprintf("---- free lists ----\n");
ffffffffc0200c0e:	00001517          	auipc	a0,0x1
ffffffffc0200c12:	4ca50513          	addi	a0,a0,1226 # ffffffffc02020d8 <etext+0x344>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200c16:	4a01                	li	s4,0
    cprintf("---- free lists ----\n");
ffffffffc0200c18:	d38ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200c1c:	4d85                	li	s11,1
ffffffffc0200c1e:	00001d17          	auipc	s10,0x1
ffffffffc0200c22:	4d2d0d13          	addi	s10,s10,1234 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200c26:	4cb9                	li	s9,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc0200c28:	00893783          	ld	a5,8(s2)
ffffffffc0200c2c:	00f90963          	beq	s2,a5,ffffffffc0200c3e <run_buddy_system_test+0x62a>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200c30:	86ca                	mv	a3,s2
ffffffffc0200c32:	014d963b          	sllw	a2,s11,s4
ffffffffc0200c36:	85d2                	mv	a1,s4
ffffffffc0200c38:	856a                	mv	a0,s10
ffffffffc0200c3a:	d16ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200c3e:	2a05                	addiw	s4,s4,1
ffffffffc0200c40:	0961                	addi	s2,s2,24
ffffffffc0200c42:	ff9a13e3          	bne	s4,s9,ffffffffc0200c28 <run_buddy_system_test+0x614>
    cprintf("---- end ----\n");
ffffffffc0200c46:	00001517          	auipc	a0,0x1
ffffffffc0200c4a:	4da50513          	addi	a0,a0,1242 # ffffffffc0202120 <etext+0x38c>
ffffffffc0200c4e:	d02ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("p1 alloc 50 pages\n");
ffffffffc0200c52:	00002517          	auipc	a0,0x2
ffffffffc0200c56:	88650513          	addi	a0,a0,-1914 # ffffffffc02024d8 <etext+0x744>
ffffffffc0200c5a:	cf6ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    p1 = alloc_pages(50);
ffffffffc0200c5e:	03200513          	li	a0,50
ffffffffc0200c62:	26b000ef          	jal	ra,ffffffffc02016cc <alloc_pages>
ffffffffc0200c66:	8a2a                	mv	s4,a0
    cprintf("---- free lists ----\n");
ffffffffc0200c68:	00001517          	auipc	a0,0x1
ffffffffc0200c6c:	47050513          	addi	a0,a0,1136 # ffffffffc02020d8 <etext+0x344>
ffffffffc0200c70:	00005917          	auipc	s2,0x5
ffffffffc0200c74:	3a890913          	addi	s2,s2,936 # ffffffffc0206018 <buddy_array>
ffffffffc0200c78:	cd8ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200c7c:	4d81                	li	s11,0
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200c7e:	00001d17          	auipc	s10,0x1
ffffffffc0200c82:	472d0d13          	addi	s10,s10,1138 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200c86:	4cb9                	li	s9,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc0200c88:	00893783          	ld	a5,8(s2)
ffffffffc0200c8c:	00f90a63          	beq	s2,a5,ffffffffc0200ca0 <run_buddy_system_test+0x68c>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200c90:	4785                	li	a5,1
ffffffffc0200c92:	86ca                	mv	a3,s2
ffffffffc0200c94:	01b7963b          	sllw	a2,a5,s11
ffffffffc0200c98:	85ee                	mv	a1,s11
ffffffffc0200c9a:	856a                	mv	a0,s10
ffffffffc0200c9c:	cb4ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200ca0:	2d85                	addiw	s11,s11,1
ffffffffc0200ca2:	0961                	addi	s2,s2,24
ffffffffc0200ca4:	ff9d92e3          	bne	s11,s9,ffffffffc0200c88 <run_buddy_system_test+0x674>
    cprintf("---- end ----\n");
ffffffffc0200ca8:	00001517          	auipc	a0,0x1
ffffffffc0200cac:	47850513          	addi	a0,a0,1144 # ffffffffc0202120 <etext+0x38c>
ffffffffc0200cb0:	ca0ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("p2 alloc 100 pages\n");
ffffffffc0200cb4:	00002517          	auipc	a0,0x2
ffffffffc0200cb8:	83c50513          	addi	a0,a0,-1988 # ffffffffc02024f0 <etext+0x75c>
ffffffffc0200cbc:	c94ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    p2 = alloc_pages(100);
ffffffffc0200cc0:	06400513          	li	a0,100
ffffffffc0200cc4:	209000ef          	jal	ra,ffffffffc02016cc <alloc_pages>
ffffffffc0200cc8:	892a                	mv	s2,a0
    cprintf("---- free lists ----\n");
ffffffffc0200cca:	00001517          	auipc	a0,0x1
ffffffffc0200cce:	40e50513          	addi	a0,a0,1038 # ffffffffc02020d8 <etext+0x344>
ffffffffc0200cd2:	00005c97          	auipc	s9,0x5
ffffffffc0200cd6:	346c8c93          	addi	s9,s9,838 # ffffffffc0206018 <buddy_array>
ffffffffc0200cda:	c76ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200cde:	00001d17          	auipc	s10,0x1
ffffffffc0200ce2:	412d0d13          	addi	s10,s10,1042 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200ce6:	4db9                	li	s11,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc0200ce8:	008cb783          	ld	a5,8(s9)
ffffffffc0200cec:	00fc8a63          	beq	s9,a5,ffffffffc0200d00 <run_buddy_system_test+0x6ec>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200cf0:	4785                	li	a5,1
ffffffffc0200cf2:	86e6                	mv	a3,s9
ffffffffc0200cf4:	0097963b          	sllw	a2,a5,s1
ffffffffc0200cf8:	85a6                	mv	a1,s1
ffffffffc0200cfa:	856a                	mv	a0,s10
ffffffffc0200cfc:	c54ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200d00:	2485                	addiw	s1,s1,1
ffffffffc0200d02:	0ce1                	addi	s9,s9,24
ffffffffc0200d04:	ffb492e3          	bne	s1,s11,ffffffffc0200ce8 <run_buddy_system_test+0x6d4>
    cprintf("---- end ----\n");
ffffffffc0200d08:	00001517          	auipc	a0,0x1
ffffffffc0200d0c:	41850513          	addi	a0,a0,1048 # ffffffffc0202120 <etext+0x38c>
ffffffffc0200d10:	c40ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("p0=0x%016lx\n", p0);
ffffffffc0200d14:	85d6                	mv	a1,s5
ffffffffc0200d16:	00001517          	auipc	a0,0x1
ffffffffc0200d1a:	44a50513          	addi	a0,a0,1098 # ffffffffc0202160 <etext+0x3cc>
ffffffffc0200d1e:	c32ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("p1=0x%016lx\n", p1);
ffffffffc0200d22:	85d2                	mv	a1,s4
ffffffffc0200d24:	00001517          	auipc	a0,0x1
ffffffffc0200d28:	44c50513          	addi	a0,a0,1100 # ffffffffc0202170 <etext+0x3dc>
ffffffffc0200d2c:	c24ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("p2=0x%016lx\n", p2);
ffffffffc0200d30:	85ca                	mv	a1,s2
ffffffffc0200d32:	00001517          	auipc	a0,0x1
ffffffffc0200d36:	44e50513          	addi	a0,a0,1102 # ffffffffc0202180 <etext+0x3ec>
ffffffffc0200d3a:	c16ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200d3e:	254a8863          	beq	s5,s4,ffffffffc0200f8e <run_buddy_system_test+0x97a>
ffffffffc0200d42:	252a8663          	beq	s5,s2,ffffffffc0200f8e <run_buddy_system_test+0x97a>
ffffffffc0200d46:	252a0463          	beq	s4,s2,ffffffffc0200f8e <run_buddy_system_test+0x97a>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200d4a:	000aa783          	lw	a5,0(s5)
ffffffffc0200d4e:	22079063          	bnez	a5,ffffffffc0200f6e <run_buddy_system_test+0x95a>
ffffffffc0200d52:	000a2783          	lw	a5,0(s4)
ffffffffc0200d56:	20079c63          	bnez	a5,ffffffffc0200f6e <run_buddy_system_test+0x95a>
static inline int page_ref(struct Page *page) { return page->ref; }
ffffffffc0200d5a:	00092d03          	lw	s10,0(s2)
ffffffffc0200d5e:	200d1863          	bnez	s10,ffffffffc0200f6e <run_buddy_system_test+0x95a>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d62:	00005797          	auipc	a5,0x5
ffffffffc0200d66:	42e78793          	addi	a5,a5,1070 # ffffffffc0206190 <pages>
ffffffffc0200d6a:	639c                	ld	a5,0(a5)
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200d6c:	000c3683          	ld	a3,0(s8)
ffffffffc0200d70:	40fa8733          	sub	a4,s5,a5
ffffffffc0200d74:	870d                	srai	a4,a4,0x3
ffffffffc0200d76:	03770733          	mul	a4,a4,s7
ffffffffc0200d7a:	06b2                	slli	a3,a3,0xc
ffffffffc0200d7c:	975a                	add	a4,a4,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d7e:	0732                	slli	a4,a4,0xc
ffffffffc0200d80:	36d77763          	bgeu	a4,a3,ffffffffc02010ee <run_buddy_system_test+0xada>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d84:	40fa0733          	sub	a4,s4,a5
ffffffffc0200d88:	870d                	srai	a4,a4,0x3
ffffffffc0200d8a:	03770733          	mul	a4,a4,s7
ffffffffc0200d8e:	975a                	add	a4,a4,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d90:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200d92:	32d77e63          	bgeu	a4,a3,ffffffffc02010ce <run_buddy_system_test+0xaba>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d96:	40f907b3          	sub	a5,s2,a5
ffffffffc0200d9a:	878d                	srai	a5,a5,0x3
ffffffffc0200d9c:	03778bb3          	mul	s7,a5,s7
ffffffffc0200da0:	9b5e                	add	s6,s6,s7
    return page2ppn(page) << PGSHIFT;
ffffffffc0200da2:	0b32                	slli	s6,s6,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200da4:	20db7563          	bgeu	s6,a3,ffffffffc0200fae <run_buddy_system_test+0x99a>
    cprintf("CHECK DIFFICULT FREE:\n");
ffffffffc0200da8:	00001517          	auipc	a0,0x1
ffffffffc0200dac:	76050513          	addi	a0,a0,1888 # ffffffffc0202508 <etext+0x774>
ffffffffc0200db0:	ba0ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("free p0...\n");
ffffffffc0200db4:	00001517          	auipc	a0,0x1
ffffffffc0200db8:	4ec50513          	addi	a0,a0,1260 # ffffffffc02022a0 <etext+0x50c>
ffffffffc0200dbc:	b94ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    free_pages(p0, 10);
ffffffffc0200dc0:	8556                	mv	a0,s5
ffffffffc0200dc2:	45a9                	li	a1,10
ffffffffc0200dc4:	115000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    cprintf("after free p0, nr_free=%d\n", nr_free);
ffffffffc0200dc8:	0009a583          	lw	a1,0(s3)
ffffffffc0200dcc:	00001517          	auipc	a0,0x1
ffffffffc0200dd0:	4e450513          	addi	a0,a0,1252 # ffffffffc02022b0 <etext+0x51c>
    cprintf("---- free lists ----\n");
ffffffffc0200dd4:	00005497          	auipc	s1,0x5
ffffffffc0200dd8:	24448493          	addi	s1,s1,580 # ffffffffc0206018 <buddy_array>
    cprintf("after free p0, nr_free=%d\n", nr_free);
ffffffffc0200ddc:	b74ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("---- free lists ----\n");
ffffffffc0200de0:	00001517          	auipc	a0,0x1
ffffffffc0200de4:	2f850513          	addi	a0,a0,760 # ffffffffc02020d8 <etext+0x344>
ffffffffc0200de8:	b68ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200dec:	4a81                	li	s5,0
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200dee:	4c05                	li	s8,1
ffffffffc0200df0:	00001b97          	auipc	s7,0x1
ffffffffc0200df4:	300b8b93          	addi	s7,s7,768 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200df8:	4b39                	li	s6,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc0200dfa:	649c                	ld	a5,8(s1)
ffffffffc0200dfc:	00f48963          	beq	s1,a5,ffffffffc0200e0e <run_buddy_system_test+0x7fa>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200e00:	86a6                	mv	a3,s1
ffffffffc0200e02:	015c163b          	sllw	a2,s8,s5
ffffffffc0200e06:	85d6                	mv	a1,s5
ffffffffc0200e08:	855e                	mv	a0,s7
ffffffffc0200e0a:	b46ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200e0e:	2a85                	addiw	s5,s5,1
ffffffffc0200e10:	04e1                	addi	s1,s1,24
ffffffffc0200e12:	ff6a94e3          	bne	s5,s6,ffffffffc0200dfa <run_buddy_system_test+0x7e6>
    cprintf("---- end ----\n");
ffffffffc0200e16:	00001517          	auipc	a0,0x1
ffffffffc0200e1a:	30a50513          	addi	a0,a0,778 # ffffffffc0202120 <etext+0x38c>
ffffffffc0200e1e:	b32ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("free p1...\n");
ffffffffc0200e22:	00001517          	auipc	a0,0x1
ffffffffc0200e26:	4ae50513          	addi	a0,a0,1198 # ffffffffc02022d0 <etext+0x53c>
ffffffffc0200e2a:	b26ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    free_pages(p1, 50);
ffffffffc0200e2e:	8552                	mv	a0,s4
ffffffffc0200e30:	03200593          	li	a1,50
ffffffffc0200e34:	0a5000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    cprintf("after free p1, nr_free=%d\n", nr_free);
ffffffffc0200e38:	0009a583          	lw	a1,0(s3)
ffffffffc0200e3c:	00001517          	auipc	a0,0x1
ffffffffc0200e40:	4a450513          	addi	a0,a0,1188 # ffffffffc02022e0 <etext+0x54c>
    cprintf("---- free lists ----\n");
ffffffffc0200e44:	00005497          	auipc	s1,0x5
ffffffffc0200e48:	1d448493          	addi	s1,s1,468 # ffffffffc0206018 <buddy_array>
    cprintf("after free p1, nr_free=%d\n", nr_free);
ffffffffc0200e4c:	b04ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("---- free lists ----\n");
ffffffffc0200e50:	00001517          	auipc	a0,0x1
ffffffffc0200e54:	28850513          	addi	a0,a0,648 # ffffffffc02020d8 <etext+0x344>
ffffffffc0200e58:	af8ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200e5c:	4a01                	li	s4,0
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200e5e:	4b85                	li	s7,1
ffffffffc0200e60:	00001b17          	auipc	s6,0x1
ffffffffc0200e64:	290b0b13          	addi	s6,s6,656 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200e68:	4ab9                	li	s5,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc0200e6a:	649c                	ld	a5,8(s1)
ffffffffc0200e6c:	00f48963          	beq	s1,a5,ffffffffc0200e7e <run_buddy_system_test+0x86a>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200e70:	86a6                	mv	a3,s1
ffffffffc0200e72:	014b963b          	sllw	a2,s7,s4
ffffffffc0200e76:	85d2                	mv	a1,s4
ffffffffc0200e78:	855a                	mv	a0,s6
ffffffffc0200e7a:	ad6ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200e7e:	2a05                	addiw	s4,s4,1
ffffffffc0200e80:	04e1                	addi	s1,s1,24
ffffffffc0200e82:	ff5a14e3          	bne	s4,s5,ffffffffc0200e6a <run_buddy_system_test+0x856>
    cprintf("---- end ----\n");
ffffffffc0200e86:	00001517          	auipc	a0,0x1
ffffffffc0200e8a:	29a50513          	addi	a0,a0,666 # ffffffffc0202120 <etext+0x38c>
ffffffffc0200e8e:	ac2ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("free p2...\n");
ffffffffc0200e92:	00001517          	auipc	a0,0x1
ffffffffc0200e96:	46e50513          	addi	a0,a0,1134 # ffffffffc0202300 <etext+0x56c>
ffffffffc0200e9a:	ab6ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    free_pages(p2, 100);
ffffffffc0200e9e:	854a                	mv	a0,s2
ffffffffc0200ea0:	06400593          	li	a1,100
ffffffffc0200ea4:	035000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    cprintf("after free p2, nr_free=%d\n", nr_free);
ffffffffc0200ea8:	0009a583          	lw	a1,0(s3)
ffffffffc0200eac:	00001517          	auipc	a0,0x1
ffffffffc0200eb0:	46450513          	addi	a0,a0,1124 # ffffffffc0202310 <etext+0x57c>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200eb4:	4985                	li	s3,1
    cprintf("after free p2, nr_free=%d\n", nr_free);
ffffffffc0200eb6:	a9aff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    cprintf("---- free lists ----\n");
ffffffffc0200eba:	00001517          	auipc	a0,0x1
ffffffffc0200ebe:	21e50513          	addi	a0,a0,542 # ffffffffc02020d8 <etext+0x344>
ffffffffc0200ec2:	a8eff0ef          	jal	ra,ffffffffc0200150 <cprintf>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200ec6:	00001917          	auipc	s2,0x1
ffffffffc0200eca:	22a90913          	addi	s2,s2,554 # ffffffffc02020f0 <etext+0x35c>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200ece:	44b9                	li	s1,14
        if (!list_empty(&buddy_array[i].free_list)) {
ffffffffc0200ed0:	641c                	ld	a5,8(s0)
ffffffffc0200ed2:	00f40963          	beq	s0,a5,ffffffffc0200ee4 <run_buddy_system_test+0x8d0>
            cprintf("order=%d, block_pages=%d, head=0x%016lx\n", i, (1 << i), &buddy_array[i].free_list);
ffffffffc0200ed6:	86a2                	mv	a3,s0
ffffffffc0200ed8:	01a9963b          	sllw	a2,s3,s10
ffffffffc0200edc:	85ea                	mv	a1,s10
ffffffffc0200ede:	854a                	mv	a0,s2
ffffffffc0200ee0:	a70ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    for (int i = start_order; i <= end_order; i++) {
ffffffffc0200ee4:	2d05                	addiw	s10,s10,1
ffffffffc0200ee6:	0461                	addi	s0,s0,24
ffffffffc0200ee8:	fe9d14e3          	bne	s10,s1,ffffffffc0200ed0 <run_buddy_system_test+0x8bc>
    cprintf("---- end ----\n");
ffffffffc0200eec:	00001517          	auipc	a0,0x1
ffffffffc0200ef0:	23450513          	addi	a0,a0,564 # ffffffffc0202120 <etext+0x38c>
ffffffffc0200ef4:	a5cff0ef          	jal	ra,ffffffffc0200150 <cprintf>
    buddy_system_check();
}
ffffffffc0200ef8:	7406                	ld	s0,96(sp)
ffffffffc0200efa:	70a6                	ld	ra,104(sp)
ffffffffc0200efc:	64e6                	ld	s1,88(sp)
ffffffffc0200efe:	6946                	ld	s2,80(sp)
ffffffffc0200f00:	69a6                	ld	s3,72(sp)
ffffffffc0200f02:	6a06                	ld	s4,64(sp)
ffffffffc0200f04:	7ae2                	ld	s5,56(sp)
ffffffffc0200f06:	7b42                	ld	s6,48(sp)
ffffffffc0200f08:	7ba2                	ld	s7,40(sp)
ffffffffc0200f0a:	7c02                	ld	s8,32(sp)
ffffffffc0200f0c:	6ce2                	ld	s9,24(sp)
ffffffffc0200f0e:	6d42                	ld	s10,16(sp)
ffffffffc0200f10:	6da2                	ld	s11,8(sp)
    cprintf("BUDDY TEST COMPLETED\n");
ffffffffc0200f12:	00001517          	auipc	a0,0x1
ffffffffc0200f16:	60e50513          	addi	a0,a0,1550 # ffffffffc0202520 <etext+0x78c>
}
ffffffffc0200f1a:	6165                	addi	sp,sp,112
    cprintf("BUDDY TEST COMPLETED\n");
ffffffffc0200f1c:	a34ff06f          	j	ffffffffc0200150 <cprintf>
        cprintf("no free blocks\n");
ffffffffc0200f20:	00001517          	auipc	a0,0x1
ffffffffc0200f24:	59050513          	addi	a0,a0,1424 # ffffffffc02024b0 <etext+0x71c>
ffffffffc0200f28:	a28ff0ef          	jal	ra,ffffffffc0200150 <cprintf>
ffffffffc0200f2c:	b16d                	j	ffffffffc0200bd6 <run_buddy_system_test+0x5c2>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200f2e:	00001697          	auipc	a3,0x1
ffffffffc0200f32:	2ba68693          	addi	a3,a3,698 # ffffffffc02021e8 <etext+0x454>
ffffffffc0200f36:	00001617          	auipc	a2,0x1
ffffffffc0200f3a:	28260613          	addi	a2,a2,642 # ffffffffc02021b8 <etext+0x424>
ffffffffc0200f3e:	02c00593          	li	a1,44
ffffffffc0200f42:	00001517          	auipc	a0,0x1
ffffffffc0200f46:	28e50513          	addi	a0,a0,654 # ffffffffc02021d0 <etext+0x43c>
ffffffffc0200f4a:	a7cff0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200f4e:	00001697          	auipc	a3,0x1
ffffffffc0200f52:	24268693          	addi	a3,a3,578 # ffffffffc0202190 <etext+0x3fc>
ffffffffc0200f56:	00001617          	auipc	a2,0x1
ffffffffc0200f5a:	26260613          	addi	a2,a2,610 # ffffffffc02021b8 <etext+0x424>
ffffffffc0200f5e:	02b00593          	li	a1,43
ffffffffc0200f62:	00001517          	auipc	a0,0x1
ffffffffc0200f66:	26e50513          	addi	a0,a0,622 # ffffffffc02021d0 <etext+0x43c>
ffffffffc0200f6a:	a5cff0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200f6e:	00001697          	auipc	a3,0x1
ffffffffc0200f72:	27a68693          	addi	a3,a3,634 # ffffffffc02021e8 <etext+0x454>
ffffffffc0200f76:	00001617          	auipc	a2,0x1
ffffffffc0200f7a:	24260613          	addi	a2,a2,578 # ffffffffc02021b8 <etext+0x424>
ffffffffc0200f7e:	05b00593          	li	a1,91
ffffffffc0200f82:	00001517          	auipc	a0,0x1
ffffffffc0200f86:	24e50513          	addi	a0,a0,590 # ffffffffc02021d0 <etext+0x43c>
ffffffffc0200f8a:	a3cff0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200f8e:	00001697          	auipc	a3,0x1
ffffffffc0200f92:	20268693          	addi	a3,a3,514 # ffffffffc0202190 <etext+0x3fc>
ffffffffc0200f96:	00001617          	auipc	a2,0x1
ffffffffc0200f9a:	22260613          	addi	a2,a2,546 # ffffffffc02021b8 <etext+0x424>
ffffffffc0200f9e:	05a00593          	li	a1,90
ffffffffc0200fa2:	00001517          	auipc	a0,0x1
ffffffffc0200fa6:	22e50513          	addi	a0,a0,558 # ffffffffc02021d0 <etext+0x43c>
ffffffffc0200faa:	a1cff0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200fae:	00001697          	auipc	a3,0x1
ffffffffc0200fb2:	2ba68693          	addi	a3,a3,698 # ffffffffc0202268 <etext+0x4d4>
ffffffffc0200fb6:	00001617          	auipc	a2,0x1
ffffffffc0200fba:	20260613          	addi	a2,a2,514 # ffffffffc02021b8 <etext+0x424>
ffffffffc0200fbe:	05e00593          	li	a1,94
ffffffffc0200fc2:	00001517          	auipc	a0,0x1
ffffffffc0200fc6:	20e50513          	addi	a0,a0,526 # ffffffffc02021d0 <etext+0x43c>
ffffffffc0200fca:	9fcff0ef          	jal	ra,ffffffffc02001c6 <__panic>
        assert(page2pa(p4) < npage * PGSIZE);
ffffffffc0200fce:	00001697          	auipc	a3,0x1
ffffffffc0200fd2:	47a68693          	addi	a3,a3,1146 # ffffffffc0202448 <etext+0x6b4>
ffffffffc0200fd6:	00001617          	auipc	a2,0x1
ffffffffc0200fda:	1e260613          	addi	a2,a2,482 # ffffffffc02021b8 <etext+0x424>
ffffffffc0200fde:	09200593          	li	a1,146
ffffffffc0200fe2:	00001517          	auipc	a0,0x1
ffffffffc0200fe6:	1ee50513          	addi	a0,a0,494 # ffffffffc02021d0 <etext+0x43c>
ffffffffc0200fea:	9dcff0ef          	jal	ra,ffffffffc02001c6 <__panic>
        assert(page_ref(p4) == 0);
ffffffffc0200fee:	00001697          	auipc	a3,0x1
ffffffffc0200ff2:	44268693          	addi	a3,a3,1090 # ffffffffc0202430 <etext+0x69c>
ffffffffc0200ff6:	00001617          	auipc	a2,0x1
ffffffffc0200ffa:	1c260613          	addi	a2,a2,450 # ffffffffc02021b8 <etext+0x424>
ffffffffc0200ffe:	09100593          	li	a1,145
ffffffffc0201002:	00001517          	auipc	a0,0x1
ffffffffc0201006:	1ce50513          	addi	a0,a0,462 # ffffffffc02021d0 <etext+0x43c>
ffffffffc020100a:	9bcff0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(page2pa(p3) < npage * PGSIZE);
ffffffffc020100e:	00001697          	auipc	a3,0x1
ffffffffc0201012:	38a68693          	addi	a3,a3,906 # ffffffffc0202398 <etext+0x604>
ffffffffc0201016:	00001617          	auipc	a2,0x1
ffffffffc020101a:	1a260613          	addi	a2,a2,418 # ffffffffc02021b8 <etext+0x424>
ffffffffc020101e:	07d00593          	li	a1,125
ffffffffc0201022:	00001517          	auipc	a0,0x1
ffffffffc0201026:	1ae50513          	addi	a0,a0,430 # ffffffffc02021d0 <etext+0x43c>
ffffffffc020102a:	99cff0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020102e:	00001697          	auipc	a3,0x1
ffffffffc0201032:	1fa68693          	addi	a3,a3,506 # ffffffffc0202228 <etext+0x494>
ffffffffc0201036:	00001617          	auipc	a2,0x1
ffffffffc020103a:	18260613          	addi	a2,a2,386 # ffffffffc02021b8 <etext+0x424>
ffffffffc020103e:	02d00593          	li	a1,45
ffffffffc0201042:	00001517          	auipc	a0,0x1
ffffffffc0201046:	18e50513          	addi	a0,a0,398 # ffffffffc02021d0 <etext+0x43c>
ffffffffc020104a:	97cff0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020104e:	00001697          	auipc	a3,0x1
ffffffffc0201052:	21a68693          	addi	a3,a3,538 # ffffffffc0202268 <etext+0x4d4>
ffffffffc0201056:	00001617          	auipc	a2,0x1
ffffffffc020105a:	16260613          	addi	a2,a2,354 # ffffffffc02021b8 <etext+0x424>
ffffffffc020105e:	02f00593          	li	a1,47
ffffffffc0201062:	00001517          	auipc	a0,0x1
ffffffffc0201066:	16e50513          	addi	a0,a0,366 # ffffffffc02021d0 <etext+0x43c>
ffffffffc020106a:	95cff0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020106e:	00001697          	auipc	a3,0x1
ffffffffc0201072:	1da68693          	addi	a3,a3,474 # ffffffffc0202248 <etext+0x4b4>
ffffffffc0201076:	00001617          	auipc	a2,0x1
ffffffffc020107a:	14260613          	addi	a2,a2,322 # ffffffffc02021b8 <etext+0x424>
ffffffffc020107e:	02e00593          	li	a1,46
ffffffffc0201082:	00001517          	auipc	a0,0x1
ffffffffc0201086:	14e50513          	addi	a0,a0,334 # ffffffffc02021d0 <etext+0x43c>
ffffffffc020108a:	93cff0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(page_ref(p3) == 0);
ffffffffc020108e:	00001697          	auipc	a3,0x1
ffffffffc0201092:	2f268693          	addi	a3,a3,754 # ffffffffc0202380 <etext+0x5ec>
ffffffffc0201096:	00001617          	auipc	a2,0x1
ffffffffc020109a:	12260613          	addi	a2,a2,290 # ffffffffc02021b8 <etext+0x424>
ffffffffc020109e:	07c00593          	li	a1,124
ffffffffc02010a2:	00001517          	auipc	a0,0x1
ffffffffc02010a6:	12e50513          	addi	a0,a0,302 # ffffffffc02021d0 <etext+0x43c>
ffffffffc02010aa:	91cff0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(p3 != NULL);
ffffffffc02010ae:	00001697          	auipc	a3,0x1
ffffffffc02010b2:	2c268693          	addi	a3,a3,706 # ffffffffc0202370 <etext+0x5dc>
ffffffffc02010b6:	00001617          	auipc	a2,0x1
ffffffffc02010ba:	10260613          	addi	a2,a2,258 # ffffffffc02021b8 <etext+0x424>
ffffffffc02010be:	07b00593          	li	a1,123
ffffffffc02010c2:	00001517          	auipc	a0,0x1
ffffffffc02010c6:	10e50513          	addi	a0,a0,270 # ffffffffc02021d0 <etext+0x43c>
ffffffffc02010ca:	8fcff0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02010ce:	00001697          	auipc	a3,0x1
ffffffffc02010d2:	17a68693          	addi	a3,a3,378 # ffffffffc0202248 <etext+0x4b4>
ffffffffc02010d6:	00001617          	auipc	a2,0x1
ffffffffc02010da:	0e260613          	addi	a2,a2,226 # ffffffffc02021b8 <etext+0x424>
ffffffffc02010de:	05d00593          	li	a1,93
ffffffffc02010e2:	00001517          	auipc	a0,0x1
ffffffffc02010e6:	0ee50513          	addi	a0,a0,238 # ffffffffc02021d0 <etext+0x43c>
ffffffffc02010ea:	8dcff0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02010ee:	00001697          	auipc	a3,0x1
ffffffffc02010f2:	13a68693          	addi	a3,a3,314 # ffffffffc0202228 <etext+0x494>
ffffffffc02010f6:	00001617          	auipc	a2,0x1
ffffffffc02010fa:	0c260613          	addi	a2,a2,194 # ffffffffc02021b8 <etext+0x424>
ffffffffc02010fe:	05c00593          	li	a1,92
ffffffffc0201102:	00001517          	auipc	a0,0x1
ffffffffc0201106:	0ce50513          	addi	a0,a0,206 # ffffffffc02021d0 <etext+0x43c>
ffffffffc020110a:	8bcff0ef          	jal	ra,ffffffffc02001c6 <__panic>

ffffffffc020110e <buddy_system_init>:

// 最大块的阶数已在memlayout.h中定义，这里不需要重复定义

// 初始化 Buddy System
void buddy_system_init(void) {
    for (int i = 0; i < MAX_ORDER; i++) {
ffffffffc020110e:	00005797          	auipc	a5,0x5
ffffffffc0201112:	f0a78793          	addi	a5,a5,-246 # ffffffffc0206018 <buddy_array>
ffffffffc0201116:	00005717          	auipc	a4,0x5
ffffffffc020111a:	05270713          	addi	a4,a4,82 # ffffffffc0206168 <is_panic>
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc020111e:	e79c                	sd	a5,8(a5)
ffffffffc0201120:	e39c                	sd	a5,0(a5)
        list_init(&buddy_array[i].free_list);
        buddy_array[i].nr_free = 0;
ffffffffc0201122:	0007a823          	sw	zero,16(a5)
    for (int i = 0; i < MAX_ORDER; i++) {
ffffffffc0201126:	07e1                	addi	a5,a5,24
ffffffffc0201128:	fee79be3          	bne	a5,a4,ffffffffc020111e <buddy_system_init+0x10>
    }
    nr_free = 0;
ffffffffc020112c:	00005797          	auipc	a5,0x5
ffffffffc0201130:	0407aa23          	sw	zero,84(a5) # ffffffffc0206180 <nr_free>
}
ffffffffc0201134:	8082                	ret

ffffffffc0201136 <buddy_system_alloc_pages>:
// 分配一个给定大小的内存块（向上按 2 的幂对齐）
struct Page *buddy_system_alloc_pages(size_t requested_pages) {
    // 目标阶数：满足 2^order >= requested_pages 的最小 order
    int target_order = 0;
    size_t adjusted_pages = 1;
    while (adjusted_pages < requested_pages && target_order < MAX_ORDER) {
ffffffffc0201136:	4785                	li	a5,1
    int target_order = 0;
ffffffffc0201138:	4601                	li	a2,0
    while (adjusted_pages < requested_pages && target_order < MAX_ORDER) {
ffffffffc020113a:	00a7fe63          	bgeu	a5,a0,ffffffffc0201156 <buddy_system_alloc_pages+0x20>
ffffffffc020113e:	4739                	li	a4,14
        adjusted_pages <<= 1;
ffffffffc0201140:	0786                	slli	a5,a5,0x1
        target_order++;
ffffffffc0201142:	2605                	addiw	a2,a2,1
    while (adjusted_pages < requested_pages && target_order < MAX_ORDER) {
ffffffffc0201144:	00a7f663          	bgeu	a5,a0,ffffffffc0201150 <buddy_system_alloc_pages+0x1a>
ffffffffc0201148:	fee61ce3          	bne	a2,a4,ffffffffc0201140 <buddy_system_alloc_pages+0xa>
    int found_order = target_order;
    while (found_order < MAX_ORDER && list_empty(&(buddy_array[found_order].free_list))) {
        found_order++;
    }
    if (found_order >= MAX_ORDER) {
        return NULL; // 无可用块
ffffffffc020114c:	4501                	li	a0,0
    allocated_page->property = 0;

    // nr_free 按实际分配块大小减少（2^target_order）
    nr_free -= (1U << target_order);
    return allocated_page;
}
ffffffffc020114e:	8082                	ret
    while (found_order < MAX_ORDER && list_empty(&(buddy_array[found_order].free_list))) {
ffffffffc0201150:	47b9                	li	a5,14
ffffffffc0201152:	fef60de3          	beq	a2,a5,ffffffffc020114c <buddy_system_alloc_pages+0x16>
ffffffffc0201156:	00161793          	slli	a5,a2,0x1
ffffffffc020115a:	97b2                	add	a5,a5,a2
ffffffffc020115c:	00005697          	auipc	a3,0x5
ffffffffc0201160:	ebc68693          	addi	a3,a3,-324 # ffffffffc0206018 <buddy_array>
ffffffffc0201164:	078e                	slli	a5,a5,0x3
ffffffffc0201166:	97b6                	add	a5,a5,a3
    int target_order = 0;
ffffffffc0201168:	8732                	mv	a4,a2
    while (found_order < MAX_ORDER && list_empty(&(buddy_array[found_order].free_list))) {
ffffffffc020116a:	45b9                	li	a1,14
ffffffffc020116c:	a029                	j	ffffffffc0201176 <buddy_system_alloc_pages+0x40>
        found_order++;
ffffffffc020116e:	2705                	addiw	a4,a4,1
    while (found_order < MAX_ORDER && list_empty(&(buddy_array[found_order].free_list))) {
ffffffffc0201170:	07e1                	addi	a5,a5,24
ffffffffc0201172:	fcb70de3          	beq	a4,a1,ffffffffc020114c <buddy_system_alloc_pages+0x16>
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
ffffffffc0201176:	0087b883          	ld	a7,8(a5)
ffffffffc020117a:	fef88ae3          	beq	a7,a5,ffffffffc020116e <buddy_system_alloc_pages+0x38>
    buddy_array[found_order].nr_free--;
ffffffffc020117e:	00171793          	slli	a5,a4,0x1
ffffffffc0201182:	97ba                	add	a5,a5,a4
ffffffffc0201184:	078e                	slli	a5,a5,0x3
ffffffffc0201186:	00f68533          	add	a0,a3,a5
    __list_del(listelm->prev, listelm->next);
ffffffffc020118a:	0008b303          	ld	t1,0(a7)
ffffffffc020118e:	0088b803          	ld	a6,8(a7)
ffffffffc0201192:	490c                	lw	a1,16(a0)
ffffffffc0201194:	17a1                	addi	a5,a5,-24
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201196:	01033423          	sd	a6,8(t1)
    next->prev = prev;
ffffffffc020119a:	00683023          	sd	t1,0(a6)
ffffffffc020119e:	35fd                	addiw	a1,a1,-1
ffffffffc02011a0:	c90c                	sw	a1,16(a0)
ffffffffc02011a2:	96be                	add	a3,a3,a5
    struct Page *allocated_page = le2page(list_next(&(buddy_array[found_order].free_list)), page_link);
ffffffffc02011a4:	fe888513          	addi	a0,a7,-24
        struct Page *buddy_page = allocated_page + (1 << found_order);
ffffffffc02011a8:	4e05                	li	t3,1
    while (found_order > target_order) {
ffffffffc02011aa:	04e65463          	bge	a2,a4,ffffffffc02011f2 <buddy_system_alloc_pages+0xbc>
        found_order--;
ffffffffc02011ae:	377d                	addiw	a4,a4,-1
        struct Page *buddy_page = allocated_page + (1 << found_order);
ffffffffc02011b0:	00ee183b          	sllw	a6,t3,a4
ffffffffc02011b4:	00281793          	slli	a5,a6,0x2
ffffffffc02011b8:	97c2                	add	a5,a5,a6
ffffffffc02011ba:	078e                	slli	a5,a5,0x3
ffffffffc02011bc:	97aa                	add	a5,a5,a0
ffffffffc02011be:	85c2                	mv	a1,a6
        SetPageProperty(buddy_page);
ffffffffc02011c0:	0087b803          	ld	a6,8(a5)
    __list_add(elm, listelm, listelm->next);
ffffffffc02011c4:	0086b303          	ld	t1,8(a3)
        buddy_page->property = (1 << found_order);
ffffffffc02011c8:	cb8c                	sw	a1,16(a5)
        SetPageProperty(buddy_page);
ffffffffc02011ca:	00286813          	ori	a6,a6,2
        buddy_array[found_order].nr_free++;
ffffffffc02011ce:	4a8c                	lw	a1,16(a3)
        SetPageProperty(buddy_page);
ffffffffc02011d0:	0107b423          	sd	a6,8(a5)
        list_add(&(buddy_array[found_order].free_list), &(buddy_page->page_link));
ffffffffc02011d4:	01878813          	addi	a6,a5,24
    prev->next = next->prev = elm;
ffffffffc02011d8:	01033023          	sd	a6,0(t1)
ffffffffc02011dc:	0106b423          	sd	a6,8(a3)
    elm->prev = prev;
ffffffffc02011e0:	ef94                	sd	a3,24(a5)
    elm->next = next;
ffffffffc02011e2:	0267b023          	sd	t1,32(a5)
        buddy_array[found_order].nr_free++;
ffffffffc02011e6:	0015879b          	addiw	a5,a1,1
ffffffffc02011ea:	ca9c                	sw	a5,16(a3)
    while (found_order > target_order) {
ffffffffc02011ec:	16a1                	addi	a3,a3,-24
ffffffffc02011ee:	fce610e3          	bne	a2,a4,ffffffffc02011ae <buddy_system_alloc_pages+0x78>
    ClearPageProperty(allocated_page);
ffffffffc02011f2:	ff08b683          	ld	a3,-16(a7)
    nr_free -= (1U << target_order);
ffffffffc02011f6:	00005597          	auipc	a1,0x5
ffffffffc02011fa:	f8a58593          	addi	a1,a1,-118 # ffffffffc0206180 <nr_free>
ffffffffc02011fe:	419c                	lw	a5,0(a1)
ffffffffc0201200:	4705                	li	a4,1
    ClearPageProperty(allocated_page);
ffffffffc0201202:	9af5                	andi	a3,a3,-3
    nr_free -= (1U << target_order);
ffffffffc0201204:	00c7163b          	sllw	a2,a4,a2
    ClearPageProperty(allocated_page);
ffffffffc0201208:	fed8b823          	sd	a3,-16(a7)
    allocated_page->property = 0;
ffffffffc020120c:	fe08ac23          	sw	zero,-8(a7)
    nr_free -= (1U << target_order);
ffffffffc0201210:	40c7863b          	subw	a2,a5,a2
ffffffffc0201214:	c190                	sw	a2,0(a1)
    return allocated_page;
ffffffffc0201216:	8082                	ret

ffffffffc0201218 <buddy_system_nr_free_pages>:
}

// 获取空闲页的数量
size_t buddy_system_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0201218:	00005517          	auipc	a0,0x5
ffffffffc020121c:	f6856503          	lwu	a0,-152(a0) # ffffffffc0206180 <nr_free>
ffffffffc0201220:	8082                	ret

ffffffffc0201222 <buddy_system_free_pages>:
void buddy_system_free_pages(struct Page *base, size_t n) {
ffffffffc0201222:	7179                	addi	sp,sp,-48
ffffffffc0201224:	e44e                	sd	s3,8(sp)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201226:	00005997          	auipc	s3,0x5
ffffffffc020122a:	f6a98993          	addi	s3,s3,-150 # ffffffffc0206190 <pages>
ffffffffc020122e:	0009b783          	ld	a5,0(s3)
ffffffffc0201232:	e84a                	sd	s2,16(sp)
ffffffffc0201234:	00002917          	auipc	s2,0x2
ffffffffc0201238:	85493903          	ld	s2,-1964(s2) # ffffffffc0202a88 <error_string+0x38>
ffffffffc020123c:	40f507b3          	sub	a5,a0,a5
ffffffffc0201240:	878d                	srai	a5,a5,0x3
ffffffffc0201242:	032787b3          	mul	a5,a5,s2
ffffffffc0201246:	ec26                	sd	s1,24(sp)
ffffffffc0201248:	872e                	mv	a4,a1
    cprintf("Buddy System算法将释放第NO.%d页开始的共%d页\n", page2ppn(base), (int)n);
ffffffffc020124a:	0005861b          	sext.w	a2,a1
void buddy_system_free_pages(struct Page *base, size_t n) {
ffffffffc020124e:	f406                	sd	ra,40(sp)
ffffffffc0201250:	00002597          	auipc	a1,0x2
ffffffffc0201254:	8405b583          	ld	a1,-1984(a1) # ffffffffc0202a90 <nbase>
ffffffffc0201258:	f022                	sd	s0,32(sp)
    while (block_pages < n && order < MAX_ORDER) {
ffffffffc020125a:	4685                	li	a3,1
void buddy_system_free_pages(struct Page *base, size_t n) {
ffffffffc020125c:	84aa                	mv	s1,a0
ffffffffc020125e:	95be                	add	a1,a1,a5
    while (block_pages < n && order < MAX_ORDER) {
ffffffffc0201260:	10e6f863          	bgeu	a3,a4,ffffffffc0201370 <buddy_system_free_pages+0x14e>
    size_t block_pages = 1;
ffffffffc0201264:	4785                	li	a5,1
    int order = 0;
ffffffffc0201266:	4401                	li	s0,0
    while (block_pages < n && order < MAX_ORDER) {
ffffffffc0201268:	46b9                	li	a3,14
        block_pages <<= 1;
ffffffffc020126a:	0786                	slli	a5,a5,0x1
        order++;
ffffffffc020126c:	2405                	addiw	s0,s0,1
    while (block_pages < n && order < MAX_ORDER) {
ffffffffc020126e:	00e7fc63          	bgeu	a5,a4,ffffffffc0201286 <buddy_system_free_pages+0x64>
ffffffffc0201272:	fed41ce3          	bne	s0,a3,ffffffffc020126a <buddy_system_free_pages+0x48>
    cprintf("Buddy System算法将释放第NO.%d页开始的共%d页\n", page2ppn(base), (int)n);
ffffffffc0201276:	00001517          	auipc	a0,0x1
ffffffffc020127a:	2c250513          	addi	a0,a0,706 # ffffffffc0202538 <etext+0x7a4>
ffffffffc020127e:	ed3fe0ef          	jal	ra,ffffffffc0200150 <cprintf>
ffffffffc0201282:	6511                	lui	a0,0x4
ffffffffc0201284:	a0f1                	j	ffffffffc0201350 <buddy_system_free_pages+0x12e>
ffffffffc0201286:	00001517          	auipc	a0,0x1
ffffffffc020128a:	2b250513          	addi	a0,a0,690 # ffffffffc0202538 <etext+0x7a4>
ffffffffc020128e:	ec3fe0ef          	jal	ra,ffffffffc0200150 <cprintf>
    while (order < MAX_ORDER) {
ffffffffc0201292:	47b9                	li	a5,14
ffffffffc0201294:	0cf40c63          	beq	s0,a5,ffffffffc020136c <buddy_system_free_pages+0x14a>
        if (buddy >= pages && buddy < pages + npage && PageProperty(buddy) && buddy->property == (1U << order)) {
ffffffffc0201298:	00005797          	auipc	a5,0x5
ffffffffc020129c:	ef07b783          	ld	a5,-272(a5) # ffffffffc0206188 <npage>
    size_t base_index = (size_t)(base - pages);
ffffffffc02012a0:	0009b583          	ld	a1,0(s3)
        if (buddy >= pages && buddy < pages + npage && PageProperty(buddy) && buddy->property == (1U << order)) {
ffffffffc02012a4:	00279813          	slli	a6,a5,0x2
ffffffffc02012a8:	00141613          	slli	a2,s0,0x1
ffffffffc02012ac:	983e                	add	a6,a6,a5
ffffffffc02012ae:	9622                	add	a2,a2,s0
ffffffffc02012b0:	080e                	slli	a6,a6,0x3
ffffffffc02012b2:	00005e97          	auipc	t4,0x5
ffffffffc02012b6:	d66e8e93          	addi	t4,t4,-666 # ffffffffc0206018 <buddy_array>
ffffffffc02012ba:	060e                	slli	a2,a2,0x3
ffffffffc02012bc:	982e                	add	a6,a6,a1
ffffffffc02012be:	9676                	add	a2,a2,t4
    size_t buddy_index = base_index ^ (1UL << order);
ffffffffc02012c0:	4305                	li	t1,1
        if (buddy >= pages && buddy < pages + npage && PageProperty(buddy) && buddy->property == (1U << order)) {
ffffffffc02012c2:	4885                	li	a7,1
    while (order < MAX_ORDER) {
ffffffffc02012c4:	4e39                	li	t3,14
ffffffffc02012c6:	a80d                	j	ffffffffc02012f8 <buddy_system_free_pages+0xd6>
        if (buddy >= pages && buddy < pages + npage && PageProperty(buddy) && buddy->property == (1U << order)) {
ffffffffc02012c8:	0507fb63          	bgeu	a5,a6,ffffffffc020131e <buddy_system_free_pages+0xfc>
ffffffffc02012cc:	6798                	ld	a4,8(a5)
ffffffffc02012ce:	8b09                	andi	a4,a4,2
ffffffffc02012d0:	c739                	beqz	a4,ffffffffc020131e <buddy_system_free_pages+0xfc>
ffffffffc02012d2:	4b98                	lw	a4,16(a5)
ffffffffc02012d4:	04a71563          	bne	a4,a0,ffffffffc020131e <buddy_system_free_pages+0xfc>
            order++;
ffffffffc02012d8:	2405                	addiw	s0,s0,1
            if (base > buddy) {
ffffffffc02012da:	0097f463          	bgeu	a5,s1,ffffffffc02012e2 <buddy_system_free_pages+0xc0>
ffffffffc02012de:	84be                	mv	s1,a5
ffffffffc02012e0:	87fa                	mv	a5,t5
    __list_del(listelm->prev, listelm->next);
ffffffffc02012e2:	6f94                	ld	a3,24(a5)
ffffffffc02012e4:	7398                	ld	a4,32(a5)
            buddy_array[order].nr_free--;
ffffffffc02012e6:	4a1c                	lw	a5,16(a2)
    while (order < MAX_ORDER) {
ffffffffc02012e8:	0661                	addi	a2,a2,24
    prev->next = next;
ffffffffc02012ea:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc02012ec:	e314                	sd	a3,0(a4)
            buddy_array[order].nr_free--;
ffffffffc02012ee:	37fd                	addiw	a5,a5,-1
ffffffffc02012f0:	fef62c23          	sw	a5,-8(a2)
    while (order < MAX_ORDER) {
ffffffffc02012f4:	07c40c63          	beq	s0,t3,ffffffffc020136c <buddy_system_free_pages+0x14a>
    size_t base_index = (size_t)(base - pages);
ffffffffc02012f8:	40b48733          	sub	a4,s1,a1
ffffffffc02012fc:	870d                	srai	a4,a4,0x3
ffffffffc02012fe:	032706b3          	mul	a3,a4,s2
    size_t buddy_index = base_index ^ (1UL << order);
ffffffffc0201302:	008317b3          	sll	a5,t1,s0
            if (base > buddy) {
ffffffffc0201306:	8f26                	mv	t5,s1
        if (buddy >= pages && buddy < pages + npage && PageProperty(buddy) && buddy->property == (1U << order)) {
ffffffffc0201308:	0088953b          	sllw	a0,a7,s0
    size_t buddy_index = base_index ^ (1UL << order);
ffffffffc020130c:	00f6c733          	xor	a4,a3,a5
    return pages + buddy_index;
ffffffffc0201310:	00271793          	slli	a5,a4,0x2
ffffffffc0201314:	97ba                	add	a5,a5,a4
ffffffffc0201316:	078e                	slli	a5,a5,0x3
ffffffffc0201318:	97ae                	add	a5,a5,a1
        if (buddy >= pages && buddy < pages + npage && PageProperty(buddy) && buddy->property == (1U << order)) {
ffffffffc020131a:	fab7f7e3          	bgeu	a5,a1,ffffffffc02012c8 <buddy_system_free_pages+0xa6>
    __list_add(elm, listelm, listelm->next);
ffffffffc020131e:	00141793          	slli	a5,s0,0x1
ffffffffc0201322:	943e                	add	s0,s0,a5
ffffffffc0201324:	040e                	slli	s0,s0,0x3
            SetPageProperty(base);
ffffffffc0201326:	649c                	ld	a5,8(s1)
ffffffffc0201328:	9ea2                	add	t4,t4,s0
ffffffffc020132a:	008eb703          	ld	a4,8(t4)
ffffffffc020132e:	0027e793          	ori	a5,a5,2
ffffffffc0201332:	e49c                	sd	a5,8(s1)
            base->property = (1U << order);
ffffffffc0201334:	c888                	sw	a0,16(s1)
            buddy_array[order].nr_free++;
ffffffffc0201336:	010ea783          	lw	a5,16(t4)
            list_add(&(buddy_array[order].free_list), &(base->page_link));
ffffffffc020133a:	01848693          	addi	a3,s1,24
    prev->next = next->prev = elm;
ffffffffc020133e:	e314                	sd	a3,0(a4)
ffffffffc0201340:	00deb423          	sd	a3,8(t4)
    elm->next = next;
ffffffffc0201344:	f098                	sd	a4,32(s1)
    elm->prev = prev;
ffffffffc0201346:	01d4bc23          	sd	t4,24(s1)
            buddy_array[order].nr_free++;
ffffffffc020134a:	2785                	addiw	a5,a5,1
ffffffffc020134c:	00fea823          	sw	a5,16(t4)
    nr_free += (1U << order);
ffffffffc0201350:	00005717          	auipc	a4,0x5
ffffffffc0201354:	e3070713          	addi	a4,a4,-464 # ffffffffc0206180 <nr_free>
ffffffffc0201358:	431c                	lw	a5,0(a4)
}
ffffffffc020135a:	70a2                	ld	ra,40(sp)
ffffffffc020135c:	7402                	ld	s0,32(sp)
    nr_free += (1U << order);
ffffffffc020135e:	9d3d                	addw	a0,a0,a5
ffffffffc0201360:	c308                	sw	a0,0(a4)
}
ffffffffc0201362:	64e2                	ld	s1,24(sp)
ffffffffc0201364:	6942                	ld	s2,16(sp)
ffffffffc0201366:	69a2                	ld	s3,8(sp)
ffffffffc0201368:	6145                	addi	sp,sp,48
ffffffffc020136a:	8082                	ret
    while (order < MAX_ORDER) {
ffffffffc020136c:	6511                	lui	a0,0x4
ffffffffc020136e:	b7cd                	j	ffffffffc0201350 <buddy_system_free_pages+0x12e>
    cprintf("Buddy System算法将释放第NO.%d页开始的共%d页\n", page2ppn(base), (int)n);
ffffffffc0201370:	00001517          	auipc	a0,0x1
ffffffffc0201374:	1c850513          	addi	a0,a0,456 # ffffffffc0202538 <etext+0x7a4>
ffffffffc0201378:	dd9fe0ef          	jal	ra,ffffffffc0200150 <cprintf>
    int order = 0;
ffffffffc020137c:	4401                	li	s0,0
ffffffffc020137e:	bf29                	j	ffffffffc0201298 <buddy_system_free_pages+0x76>

ffffffffc0201380 <basic_check>:

// 功能检测函数
static void basic_check(void) {
ffffffffc0201380:	1101                	addi	sp,sp,-32
    cprintf("开始基本功能检测...\n");
ffffffffc0201382:	00001517          	auipc	a0,0x1
ffffffffc0201386:	1f650513          	addi	a0,a0,502 # ffffffffc0202578 <etext+0x7e4>
static void basic_check(void) {
ffffffffc020138a:	ec06                	sd	ra,24(sp)
ffffffffc020138c:	e822                	sd	s0,16(sp)
ffffffffc020138e:	e426                	sd	s1,8(sp)
ffffffffc0201390:	e04a                	sd	s2,0(sp)
    cprintf("开始基本功能检测...\n");
ffffffffc0201392:	dbffe0ef          	jal	ra,ffffffffc0200150 <cprintf>
    
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
    
    // 测试基本分配功能
    cprintf("测试分配3页...\n");
ffffffffc0201396:	00001517          	auipc	a0,0x1
ffffffffc020139a:	20250513          	addi	a0,a0,514 # ffffffffc0202598 <etext+0x804>
ffffffffc020139e:	db3fe0ef          	jal	ra,ffffffffc0200150 <cprintf>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02013a2:	4505                	li	a0,1
ffffffffc02013a4:	328000ef          	jal	ra,ffffffffc02016cc <alloc_pages>
ffffffffc02013a8:	14050463          	beqz	a0,ffffffffc02014f0 <basic_check+0x170>
ffffffffc02013ac:	842a                	mv	s0,a0
    assert((p1 = alloc_page()) != NULL);
ffffffffc02013ae:	4505                	li	a0,1
ffffffffc02013b0:	31c000ef          	jal	ra,ffffffffc02016cc <alloc_pages>
ffffffffc02013b4:	84aa                	mv	s1,a0
ffffffffc02013b6:	10050d63          	beqz	a0,ffffffffc02014d0 <basic_check+0x150>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02013ba:	4505                	li	a0,1
ffffffffc02013bc:	310000ef          	jal	ra,ffffffffc02016cc <alloc_pages>
ffffffffc02013c0:	892a                	mv	s2,a0
ffffffffc02013c2:	0e050763          	beqz	a0,ffffffffc02014b0 <basic_check+0x130>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02013c6:	0a940563          	beq	s0,s1,ffffffffc0201470 <basic_check+0xf0>
ffffffffc02013ca:	0aa40363          	beq	s0,a0,ffffffffc0201470 <basic_check+0xf0>
ffffffffc02013ce:	0aa48163          	beq	s1,a0,ffffffffc0201470 <basic_check+0xf0>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02013d2:	401c                	lw	a5,0(s0)
ffffffffc02013d4:	efd5                	bnez	a5,ffffffffc0201490 <basic_check+0x110>
ffffffffc02013d6:	409c                	lw	a5,0(s1)
ffffffffc02013d8:	efc5                	bnez	a5,ffffffffc0201490 <basic_check+0x110>
ffffffffc02013da:	411c                	lw	a5,0(a0)
ffffffffc02013dc:	ebd5                	bnez	a5,ffffffffc0201490 <basic_check+0x110>
ffffffffc02013de:	00005797          	auipc	a5,0x5
ffffffffc02013e2:	db27b783          	ld	a5,-590(a5) # ffffffffc0206190 <pages>
ffffffffc02013e6:	40f40733          	sub	a4,s0,a5
ffffffffc02013ea:	870d                	srai	a4,a4,0x3
ffffffffc02013ec:	00001597          	auipc	a1,0x1
ffffffffc02013f0:	69c5b583          	ld	a1,1692(a1) # ffffffffc0202a88 <error_string+0x38>
ffffffffc02013f4:	02b70733          	mul	a4,a4,a1
ffffffffc02013f8:	00001617          	auipc	a2,0x1
ffffffffc02013fc:	69863603          	ld	a2,1688(a2) # ffffffffc0202a90 <nbase>

    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201400:	00005697          	auipc	a3,0x5
ffffffffc0201404:	d886b683          	ld	a3,-632(a3) # ffffffffc0206188 <npage>
ffffffffc0201408:	06b2                	slli	a3,a3,0xc
ffffffffc020140a:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020140c:	0732                	slli	a4,a4,0xc
ffffffffc020140e:	14d77163          	bgeu	a4,a3,ffffffffc0201550 <basic_check+0x1d0>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201412:	40f48733          	sub	a4,s1,a5
ffffffffc0201416:	870d                	srai	a4,a4,0x3
ffffffffc0201418:	02b70733          	mul	a4,a4,a1
ffffffffc020141c:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020141e:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201420:	10d77863          	bgeu	a4,a3,ffffffffc0201530 <basic_check+0x1b0>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201424:	40f507b3          	sub	a5,a0,a5
ffffffffc0201428:	878d                	srai	a5,a5,0x3
ffffffffc020142a:	02b787b3          	mul	a5,a5,a1
ffffffffc020142e:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201430:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201432:	0cd7ff63          	bgeu	a5,a3,ffffffffc0201510 <basic_check+0x190>

    // 测试释放功能
    cprintf("测试释放3页...\n");
ffffffffc0201436:	00001517          	auipc	a0,0x1
ffffffffc020143a:	1f250513          	addi	a0,a0,498 # ffffffffc0202628 <etext+0x894>
ffffffffc020143e:	d13fe0ef          	jal	ra,ffffffffc0200150 <cprintf>
    free_page(p0);
ffffffffc0201442:	8522                	mv	a0,s0
ffffffffc0201444:	4585                	li	a1,1
ffffffffc0201446:	292000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    free_page(p1);
ffffffffc020144a:	8526                	mv	a0,s1
ffffffffc020144c:	4585                	li	a1,1
ffffffffc020144e:	28a000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    free_page(p2);
ffffffffc0201452:	854a                	mv	a0,s2
ffffffffc0201454:	4585                	li	a1,1
ffffffffc0201456:	282000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    
    cprintf("基本功能检测完成!\n");
}
ffffffffc020145a:	6442                	ld	s0,16(sp)
ffffffffc020145c:	60e2                	ld	ra,24(sp)
ffffffffc020145e:	64a2                	ld	s1,8(sp)
ffffffffc0201460:	6902                	ld	s2,0(sp)
    cprintf("基本功能检测完成!\n");
ffffffffc0201462:	00001517          	auipc	a0,0x1
ffffffffc0201466:	1de50513          	addi	a0,a0,478 # ffffffffc0202640 <etext+0x8ac>
}
ffffffffc020146a:	6105                	addi	sp,sp,32
    cprintf("基本功能检测完成!\n");
ffffffffc020146c:	ce5fe06f          	j	ffffffffc0200150 <cprintf>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201470:	00001697          	auipc	a3,0x1
ffffffffc0201474:	d2068693          	addi	a3,a3,-736 # ffffffffc0202190 <etext+0x3fc>
ffffffffc0201478:	00001617          	auipc	a2,0x1
ffffffffc020147c:	d4060613          	addi	a2,a2,-704 # ffffffffc02021b8 <etext+0x424>
ffffffffc0201480:	0b600593          	li	a1,182
ffffffffc0201484:	00001517          	auipc	a0,0x1
ffffffffc0201488:	14c50513          	addi	a0,a0,332 # ffffffffc02025d0 <etext+0x83c>
ffffffffc020148c:	d3bfe0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201490:	00001697          	auipc	a3,0x1
ffffffffc0201494:	d5868693          	addi	a3,a3,-680 # ffffffffc02021e8 <etext+0x454>
ffffffffc0201498:	00001617          	auipc	a2,0x1
ffffffffc020149c:	d2060613          	addi	a2,a2,-736 # ffffffffc02021b8 <etext+0x424>
ffffffffc02014a0:	0b700593          	li	a1,183
ffffffffc02014a4:	00001517          	auipc	a0,0x1
ffffffffc02014a8:	12c50513          	addi	a0,a0,300 # ffffffffc02025d0 <etext+0x83c>
ffffffffc02014ac:	d1bfe0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014b0:	00001697          	auipc	a3,0x1
ffffffffc02014b4:	15868693          	addi	a3,a3,344 # ffffffffc0202608 <etext+0x874>
ffffffffc02014b8:	00001617          	auipc	a2,0x1
ffffffffc02014bc:	d0060613          	addi	a2,a2,-768 # ffffffffc02021b8 <etext+0x424>
ffffffffc02014c0:	0b400593          	li	a1,180
ffffffffc02014c4:	00001517          	auipc	a0,0x1
ffffffffc02014c8:	10c50513          	addi	a0,a0,268 # ffffffffc02025d0 <etext+0x83c>
ffffffffc02014cc:	cfbfe0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02014d0:	00001697          	auipc	a3,0x1
ffffffffc02014d4:	11868693          	addi	a3,a3,280 # ffffffffc02025e8 <etext+0x854>
ffffffffc02014d8:	00001617          	auipc	a2,0x1
ffffffffc02014dc:	ce060613          	addi	a2,a2,-800 # ffffffffc02021b8 <etext+0x424>
ffffffffc02014e0:	0b300593          	li	a1,179
ffffffffc02014e4:	00001517          	auipc	a0,0x1
ffffffffc02014e8:	0ec50513          	addi	a0,a0,236 # ffffffffc02025d0 <etext+0x83c>
ffffffffc02014ec:	cdbfe0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02014f0:	00001697          	auipc	a3,0x1
ffffffffc02014f4:	0c068693          	addi	a3,a3,192 # ffffffffc02025b0 <etext+0x81c>
ffffffffc02014f8:	00001617          	auipc	a2,0x1
ffffffffc02014fc:	cc060613          	addi	a2,a2,-832 # ffffffffc02021b8 <etext+0x424>
ffffffffc0201500:	0b200593          	li	a1,178
ffffffffc0201504:	00001517          	auipc	a0,0x1
ffffffffc0201508:	0cc50513          	addi	a0,a0,204 # ffffffffc02025d0 <etext+0x83c>
ffffffffc020150c:	cbbfe0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201510:	00001697          	auipc	a3,0x1
ffffffffc0201514:	d5868693          	addi	a3,a3,-680 # ffffffffc0202268 <etext+0x4d4>
ffffffffc0201518:	00001617          	auipc	a2,0x1
ffffffffc020151c:	ca060613          	addi	a2,a2,-864 # ffffffffc02021b8 <etext+0x424>
ffffffffc0201520:	0bb00593          	li	a1,187
ffffffffc0201524:	00001517          	auipc	a0,0x1
ffffffffc0201528:	0ac50513          	addi	a0,a0,172 # ffffffffc02025d0 <etext+0x83c>
ffffffffc020152c:	c9bfe0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201530:	00001697          	auipc	a3,0x1
ffffffffc0201534:	d1868693          	addi	a3,a3,-744 # ffffffffc0202248 <etext+0x4b4>
ffffffffc0201538:	00001617          	auipc	a2,0x1
ffffffffc020153c:	c8060613          	addi	a2,a2,-896 # ffffffffc02021b8 <etext+0x424>
ffffffffc0201540:	0ba00593          	li	a1,186
ffffffffc0201544:	00001517          	auipc	a0,0x1
ffffffffc0201548:	08c50513          	addi	a0,a0,140 # ffffffffc02025d0 <etext+0x83c>
ffffffffc020154c:	c7bfe0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201550:	00001697          	auipc	a3,0x1
ffffffffc0201554:	cd868693          	addi	a3,a3,-808 # ffffffffc0202228 <etext+0x494>
ffffffffc0201558:	00001617          	auipc	a2,0x1
ffffffffc020155c:	c6060613          	addi	a2,a2,-928 # ffffffffc02021b8 <etext+0x424>
ffffffffc0201560:	0b900593          	li	a1,185
ffffffffc0201564:	00001517          	auipc	a0,0x1
ffffffffc0201568:	06c50513          	addi	a0,a0,108 # ffffffffc02025d0 <etext+0x83c>
ffffffffc020156c:	c5bfe0ef          	jal	ra,ffffffffc02001c6 <__panic>

ffffffffc0201570 <default_init_memmap>:
static void default_init_memmap(struct Page *base, size_t n) {
ffffffffc0201570:	1101                	addi	sp,sp,-32
ffffffffc0201572:	ec06                	sd	ra,24(sp)
ffffffffc0201574:	e822                	sd	s0,16(sp)
ffffffffc0201576:	e426                	sd	s1,8(sp)
ffffffffc0201578:	e04a                	sd	s2,0(sp)
    assert(n > 0);
ffffffffc020157a:	12058963          	beqz	a1,ffffffffc02016ac <default_init_memmap+0x13c>
    for (; p != base + n; p++) {
ffffffffc020157e:	00259693          	slli	a3,a1,0x2
ffffffffc0201582:	96ae                	add	a3,a3,a1
ffffffffc0201584:	068e                	slli	a3,a3,0x3
ffffffffc0201586:	96aa                	add	a3,a3,a0
ffffffffc0201588:	87aa                	mv	a5,a0
ffffffffc020158a:	00d50f63          	beq	a0,a3,ffffffffc02015a8 <default_init_memmap+0x38>
        assert(PageReserved(p));
ffffffffc020158e:	6798                	ld	a4,8(a5)
ffffffffc0201590:	8b05                	andi	a4,a4,1
ffffffffc0201592:	cf6d                	beqz	a4,ffffffffc020168c <default_init_memmap+0x11c>
        p->flags = p->property = 0;
ffffffffc0201594:	0007a823          	sw	zero,16(a5)
ffffffffc0201598:	0007b423          	sd	zero,8(a5)

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc020159c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++) {
ffffffffc02015a0:	02878793          	addi	a5,a5,40
ffffffffc02015a4:	fed795e3          	bne	a5,a3,ffffffffc020158e <default_init_memmap+0x1e>
ffffffffc02015a8:	00005f97          	auipc	t6,0x5
ffffffffc02015ac:	bd8f8f93          	addi	t6,t6,-1064 # ffffffffc0206180 <nr_free>
ffffffffc02015b0:	000fae03          	lw	t3,0(t6)
        size_t idx = (size_t)(pos - pages);
ffffffffc02015b4:	00005397          	auipc	t2,0x5
ffffffffc02015b8:	bdc3b383          	ld	t2,-1060(t2) # ffffffffc0206190 <pages>
ffffffffc02015bc:	832e                	mv	t1,a1
ffffffffc02015be:	00001297          	auipc	t0,0x1
ffffffffc02015c2:	4ca2b283          	ld	t0,1226(t0) # ffffffffc0202a88 <error_string+0x38>
ffffffffc02015c6:	00005f17          	auipc	t5,0x5
ffffffffc02015ca:	a52f0f13          	addi	t5,t5,-1454 # ffffffffc0206018 <buddy_array>
        while (((idx & (1UL << max_align_order)) == 0) && max_align_order < (MAX_ORDER - 1)) {
ffffffffc02015ce:	4685                	li	a3,1
ffffffffc02015d0:	4835                	li	a6,13
        pos += blk_pages;
ffffffffc02015d2:	02800e93          	li	t4,40
        size_t idx = (size_t)(pos - pages);
ffffffffc02015d6:	407508b3          	sub	a7,a0,t2
ffffffffc02015da:	4038d893          	srai	a7,a7,0x3
ffffffffc02015de:	025888b3          	mul	a7,a7,t0
        while (((idx & (1UL << max_align_order)) == 0) && max_align_order < (MAX_ORDER - 1)) {
ffffffffc02015e2:	0018f793          	andi	a5,a7,1
ffffffffc02015e6:	e3cd                	bnez	a5,ffffffffc0201688 <default_init_memmap+0x118>
            max_align_order++;
ffffffffc02015e8:	863e                	mv	a2,a5
ffffffffc02015ea:	2785                	addiw	a5,a5,1
        while (((idx & (1UL << max_align_order)) == 0) && max_align_order < (MAX_ORDER - 1)) {
ffffffffc02015ec:	00f69733          	sll	a4,a3,a5
ffffffffc02015f0:	01177733          	and	a4,a4,a7
ffffffffc02015f4:	e701                	bnez	a4,ffffffffc02015fc <default_init_memmap+0x8c>
ffffffffc02015f6:	ff0799e3          	bne	a5,a6,ffffffffc02015e8 <default_init_memmap+0x78>
ffffffffc02015fa:	4631                	li	a2,12
        int size_limit_order = 0;
ffffffffc02015fc:	4781                	li	a5,0
        while (((1UL << size_limit_order) << 1) <= remain && size_limit_order < (MAX_ORDER - 1)) {
ffffffffc02015fe:	00d30a63          	beq	t1,a3,ffffffffc0201612 <default_init_memmap+0xa2>
            size_limit_order++;
ffffffffc0201602:	2785                	addiw	a5,a5,1
        while (((1UL << size_limit_order) << 1) <= remain && size_limit_order < (MAX_ORDER - 1)) {
ffffffffc0201604:	00f69733          	sll	a4,a3,a5
ffffffffc0201608:	0706                	slli	a4,a4,0x1
ffffffffc020160a:	00e36463          	bltu	t1,a4,ffffffffc0201612 <default_init_memmap+0xa2>
ffffffffc020160e:	ff079ae3          	bne	a5,a6,ffffffffc0201602 <default_init_memmap+0x92>
        int use_order = max_align_order < size_limit_order ? max_align_order : size_limit_order;
ffffffffc0201612:	873e                	mv	a4,a5
ffffffffc0201614:	00f65363          	bge	a2,a5,ffffffffc020161a <default_init_memmap+0xaa>
ffffffffc0201618:	8732                	mv	a4,a2
ffffffffc020161a:	0007061b          	sext.w	a2,a4
    __list_add(elm, listelm, listelm->next);
ffffffffc020161e:	00161793          	slli	a5,a2,0x1
ffffffffc0201622:	97b2                	add	a5,a5,a2
        SetPageProperty(pos);
ffffffffc0201624:	00853883          	ld	a7,8(a0)
ffffffffc0201628:	078e                	slli	a5,a5,0x3
ffffffffc020162a:	97fa                	add	a5,a5,t5
ffffffffc020162c:	6784                	ld	s1,8(a5)
        size_t blk_pages = (1UL << use_order);
ffffffffc020162e:	00e69733          	sll	a4,a3,a4
        pos->property = blk_pages;
ffffffffc0201632:	0007041b          	sext.w	s0,a4
        SetPageProperty(pos);
ffffffffc0201636:	0028e893          	ori	a7,a7,2
ffffffffc020163a:	01153423          	sd	a7,8(a0)
        pos->property = blk_pages;
ffffffffc020163e:	c900                	sw	s0,16(a0)
        buddy_array[use_order].nr_free++;
ffffffffc0201640:	0107a883          	lw	a7,16(a5)
        list_add(&(buddy_array[use_order].free_list), &(pos->page_link));
ffffffffc0201644:	01850913          	addi	s2,a0,24
    prev->next = next->prev = elm;
ffffffffc0201648:	0124b023          	sd	s2,0(s1)
ffffffffc020164c:	0127b423          	sd	s2,8(a5)
    elm->next = next;
ffffffffc0201650:	f104                	sd	s1,32(a0)
    elm->prev = prev;
ffffffffc0201652:	ed1c                	sd	a5,24(a0)
        buddy_array[use_order].nr_free++;
ffffffffc0201654:	2885                	addiw	a7,a7,1
        pos += blk_pages;
ffffffffc0201656:	00ce9633          	sll	a2,t4,a2
        buddy_array[use_order].nr_free++;
ffffffffc020165a:	0117a823          	sw	a7,16(a5)
        remain -= blk_pages;
ffffffffc020165e:	40e30333          	sub	t1,t1,a4
        pos += blk_pages;
ffffffffc0201662:	9532                	add	a0,a0,a2
        nr_free += blk_pages;
ffffffffc0201664:	01c40e3b          	addw	t3,s0,t3
    while (remain > 0) {
ffffffffc0201668:	f60317e3          	bnez	t1,ffffffffc02015d6 <default_init_memmap+0x66>
}
ffffffffc020166c:	6442                	ld	s0,16(sp)
ffffffffc020166e:	60e2                	ld	ra,24(sp)
ffffffffc0201670:	64a2                	ld	s1,8(sp)
ffffffffc0201672:	6902                	ld	s2,0(sp)
ffffffffc0201674:	01cfa023          	sw	t3,0(t6)
    cprintf("初始化内存块: %d页 已拆分入表\n", (int)n);
ffffffffc0201678:	2581                	sext.w	a1,a1
ffffffffc020167a:	00001517          	auipc	a0,0x1
ffffffffc020167e:	ffe50513          	addi	a0,a0,-2 # ffffffffc0202678 <etext+0x8e4>
}
ffffffffc0201682:	6105                	addi	sp,sp,32
    cprintf("初始化内存块: %d页 已拆分入表\n", (int)n);
ffffffffc0201684:	acdfe06f          	j	ffffffffc0200150 <cprintf>
        while (((idx & (1UL << max_align_order)) == 0) && max_align_order < (MAX_ORDER - 1)) {
ffffffffc0201688:	4601                	li	a2,0
ffffffffc020168a:	bf8d                	j	ffffffffc02015fc <default_init_memmap+0x8c>
        assert(PageReserved(p));
ffffffffc020168c:	00001697          	auipc	a3,0x1
ffffffffc0201690:	fdc68693          	addi	a3,a3,-36 # ffffffffc0202668 <etext+0x8d4>
ffffffffc0201694:	00001617          	auipc	a2,0x1
ffffffffc0201698:	b2460613          	addi	a2,a2,-1244 # ffffffffc02021b8 <etext+0x424>
ffffffffc020169c:	07c00593          	li	a1,124
ffffffffc02016a0:	00001517          	auipc	a0,0x1
ffffffffc02016a4:	f3050513          	addi	a0,a0,-208 # ffffffffc02025d0 <etext+0x83c>
ffffffffc02016a8:	b1ffe0ef          	jal	ra,ffffffffc02001c6 <__panic>
    assert(n > 0);
ffffffffc02016ac:	00001697          	auipc	a3,0x1
ffffffffc02016b0:	fb468693          	addi	a3,a3,-76 # ffffffffc0202660 <etext+0x8cc>
ffffffffc02016b4:	00001617          	auipc	a2,0x1
ffffffffc02016b8:	b0460613          	addi	a2,a2,-1276 # ffffffffc02021b8 <etext+0x424>
ffffffffc02016bc:	07900593          	li	a1,121
ffffffffc02016c0:	00001517          	auipc	a0,0x1
ffffffffc02016c4:	f1050513          	addi	a0,a0,-240 # ffffffffc02025d0 <etext+0x83c>
ffffffffc02016c8:	afffe0ef          	jal	ra,ffffffffc02001c6 <__panic>

ffffffffc02016cc <alloc_pages>:
    pmm_manager->init_memmap(base, n);
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory
struct Page *alloc_pages(size_t n) {
    return pmm_manager->alloc_pages(n);
ffffffffc02016cc:	00005797          	auipc	a5,0x5
ffffffffc02016d0:	acc7b783          	ld	a5,-1332(a5) # ffffffffc0206198 <pmm_manager>
ffffffffc02016d4:	6f9c                	ld	a5,24(a5)
ffffffffc02016d6:	8782                	jr	a5

ffffffffc02016d8 <free_pages>:
}

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    pmm_manager->free_pages(base, n);
ffffffffc02016d8:	00005797          	auipc	a5,0x5
ffffffffc02016dc:	ac07b783          	ld	a5,-1344(a5) # ffffffffc0206198 <pmm_manager>
ffffffffc02016e0:	739c                	ld	a5,32(a5)
ffffffffc02016e2:	8782                	jr	a5

ffffffffc02016e4 <nr_free_pages>:
}

// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t nr_free_pages(void) {
    return pmm_manager->nr_free_pages();
ffffffffc02016e4:	00005797          	auipc	a5,0x5
ffffffffc02016e8:	ab47b783          	ld	a5,-1356(a5) # ffffffffc0206198 <pmm_manager>
ffffffffc02016ec:	779c                	ld	a5,40(a5)
ffffffffc02016ee:	8782                	jr	a5

ffffffffc02016f0 <pmm_init>:
    pmm_manager = &buddy_pmm_manager;  // 将 default_pmm_manager 替换为 buddy_pmm_manager
ffffffffc02016f0:	00001797          	auipc	a5,0x1
ffffffffc02016f4:	fd078793          	addi	a5,a5,-48 # ffffffffc02026c0 <buddy_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02016f8:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc02016fa:	7179                	addi	sp,sp,-48
ffffffffc02016fc:	f022                	sd	s0,32(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02016fe:	00001517          	auipc	a0,0x1
ffffffffc0201702:	ffa50513          	addi	a0,a0,-6 # ffffffffc02026f8 <buddy_pmm_manager+0x38>
    pmm_manager = &buddy_pmm_manager;  // 将 default_pmm_manager 替换为 buddy_pmm_manager
ffffffffc0201706:	00005417          	auipc	s0,0x5
ffffffffc020170a:	a9240413          	addi	s0,s0,-1390 # ffffffffc0206198 <pmm_manager>
void pmm_init(void) {
ffffffffc020170e:	f406                	sd	ra,40(sp)
ffffffffc0201710:	ec26                	sd	s1,24(sp)
ffffffffc0201712:	e44e                	sd	s3,8(sp)
ffffffffc0201714:	e84a                	sd	s2,16(sp)
ffffffffc0201716:	e052                	sd	s4,0(sp)
    pmm_manager = &buddy_pmm_manager;  // 将 default_pmm_manager 替换为 buddy_pmm_manager
ffffffffc0201718:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020171a:	a37fe0ef          	jal	ra,ffffffffc0200150 <cprintf>
    pmm_manager->init();
ffffffffc020171e:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0201720:	00005497          	auipc	s1,0x5
ffffffffc0201724:	a9048493          	addi	s1,s1,-1392 # ffffffffc02061b0 <va_pa_offset>
    pmm_manager->init();
ffffffffc0201728:	679c                	ld	a5,8(a5)
ffffffffc020172a:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020172c:	57f5                	li	a5,-3
ffffffffc020172e:	07fa                	slli	a5,a5,0x1e
ffffffffc0201730:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc0201732:	ecffe0ef          	jal	ra,ffffffffc0200600 <get_memory_base>
ffffffffc0201736:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0201738:	ed3fe0ef          	jal	ra,ffffffffc020060a <get_memory_size>
    if (mem_size == 0) {
ffffffffc020173c:	14050d63          	beqz	a0,ffffffffc0201896 <pmm_init+0x1a6>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0201740:	892a                	mv	s2,a0
    cprintf("physcial memory map:\n");
ffffffffc0201742:	00001517          	auipc	a0,0x1
ffffffffc0201746:	ffe50513          	addi	a0,a0,-2 # ffffffffc0202740 <buddy_pmm_manager+0x80>
ffffffffc020174a:	a07fe0ef          	jal	ra,ffffffffc0200150 <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc020174e:	01298a33          	add	s4,s3,s2
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0201752:	864e                	mv	a2,s3
ffffffffc0201754:	fffa0693          	addi	a3,s4,-1
ffffffffc0201758:	85ca                	mv	a1,s2
ffffffffc020175a:	00001517          	auipc	a0,0x1
ffffffffc020175e:	ffe50513          	addi	a0,a0,-2 # ffffffffc0202758 <buddy_pmm_manager+0x98>
ffffffffc0201762:	9effe0ef          	jal	ra,ffffffffc0200150 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0201766:	c80007b7          	lui	a5,0xc8000
ffffffffc020176a:	8652                	mv	a2,s4
ffffffffc020176c:	0d47e463          	bltu	a5,s4,ffffffffc0201834 <pmm_init+0x144>
ffffffffc0201770:	00006797          	auipc	a5,0x6
ffffffffc0201774:	a4778793          	addi	a5,a5,-1465 # ffffffffc02071b7 <end+0xfff>
ffffffffc0201778:	757d                	lui	a0,0xfffff
ffffffffc020177a:	8d7d                	and	a0,a0,a5
ffffffffc020177c:	8231                	srli	a2,a2,0xc
ffffffffc020177e:	00005797          	auipc	a5,0x5
ffffffffc0201782:	a0c7b523          	sd	a2,-1526(a5) # ffffffffc0206188 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201786:	00005797          	auipc	a5,0x5
ffffffffc020178a:	a0a7b523          	sd	a0,-1526(a5) # ffffffffc0206190 <pages>
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020178e:	000807b7          	lui	a5,0x80
ffffffffc0201792:	002005b7          	lui	a1,0x200
ffffffffc0201796:	02f60563          	beq	a2,a5,ffffffffc02017c0 <pmm_init+0xd0>
ffffffffc020179a:	00261593          	slli	a1,a2,0x2
ffffffffc020179e:	00c586b3          	add	a3,a1,a2
ffffffffc02017a2:	fec007b7          	lui	a5,0xfec00
ffffffffc02017a6:	97aa                	add	a5,a5,a0
ffffffffc02017a8:	068e                	slli	a3,a3,0x3
ffffffffc02017aa:	96be                	add	a3,a3,a5
ffffffffc02017ac:	87aa                	mv	a5,a0
        SetPageReserved(pages + i);
ffffffffc02017ae:	6798                	ld	a4,8(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02017b0:	02878793          	addi	a5,a5,40 # fffffffffec00028 <end+0x3e9f9e70>
        SetPageReserved(pages + i);
ffffffffc02017b4:	00176713          	ori	a4,a4,1
ffffffffc02017b8:	fee7b023          	sd	a4,-32(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02017bc:	fef699e3          	bne	a3,a5,ffffffffc02017ae <pmm_init+0xbe>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02017c0:	95b2                	add	a1,a1,a2
ffffffffc02017c2:	fec006b7          	lui	a3,0xfec00
ffffffffc02017c6:	96aa                	add	a3,a3,a0
ffffffffc02017c8:	058e                	slli	a1,a1,0x3
ffffffffc02017ca:	96ae                	add	a3,a3,a1
ffffffffc02017cc:	c02007b7          	lui	a5,0xc0200
ffffffffc02017d0:	0af6e763          	bltu	a3,a5,ffffffffc020187e <pmm_init+0x18e>
ffffffffc02017d4:	6098                	ld	a4,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc02017d6:	77fd                	lui	a5,0xfffff
ffffffffc02017d8:	00fa75b3          	and	a1,s4,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02017dc:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc02017de:	04b6ee63          	bltu	a3,a1,ffffffffc020183a <pmm_init+0x14a>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc02017e2:	601c                	ld	a5,0(s0)
ffffffffc02017e4:	7b9c                	ld	a5,48(a5)
ffffffffc02017e6:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02017e8:	00001517          	auipc	a0,0x1
ffffffffc02017ec:	ff850513          	addi	a0,a0,-8 # ffffffffc02027e0 <buddy_pmm_manager+0x120>
ffffffffc02017f0:	961fe0ef          	jal	ra,ffffffffc0200150 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc02017f4:	00004597          	auipc	a1,0x4
ffffffffc02017f8:	80c58593          	addi	a1,a1,-2036 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc02017fc:	00005797          	auipc	a5,0x5
ffffffffc0201800:	9ab7b623          	sd	a1,-1620(a5) # ffffffffc02061a8 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201804:	c02007b7          	lui	a5,0xc0200
ffffffffc0201808:	0af5e363          	bltu	a1,a5,ffffffffc02018ae <pmm_init+0x1be>
ffffffffc020180c:	6090                	ld	a2,0(s1)
}
ffffffffc020180e:	7402                	ld	s0,32(sp)
ffffffffc0201810:	70a2                	ld	ra,40(sp)
ffffffffc0201812:	64e2                	ld	s1,24(sp)
ffffffffc0201814:	6942                	ld	s2,16(sp)
ffffffffc0201816:	69a2                	ld	s3,8(sp)
ffffffffc0201818:	6a02                	ld	s4,0(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc020181a:	40c58633          	sub	a2,a1,a2
ffffffffc020181e:	00005797          	auipc	a5,0x5
ffffffffc0201822:	98c7b123          	sd	a2,-1662(a5) # ffffffffc02061a0 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201826:	00001517          	auipc	a0,0x1
ffffffffc020182a:	fda50513          	addi	a0,a0,-38 # ffffffffc0202800 <buddy_pmm_manager+0x140>
}
ffffffffc020182e:	6145                	addi	sp,sp,48
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201830:	921fe06f          	j	ffffffffc0200150 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0201834:	c8000637          	lui	a2,0xc8000
ffffffffc0201838:	bf25                	j	ffffffffc0201770 <pmm_init+0x80>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc020183a:	6705                	lui	a4,0x1
ffffffffc020183c:	177d                	addi	a4,a4,-1
ffffffffc020183e:	96ba                	add	a3,a3,a4
ffffffffc0201840:	8efd                	and	a3,a3,a5
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0201842:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201846:	02c7f063          	bgeu	a5,a2,ffffffffc0201866 <pmm_init+0x176>
    pmm_manager->init_memmap(base, n);
ffffffffc020184a:	6010                	ld	a2,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc020184c:	fff80737          	lui	a4,0xfff80
ffffffffc0201850:	973e                	add	a4,a4,a5
ffffffffc0201852:	00271793          	slli	a5,a4,0x2
ffffffffc0201856:	97ba                	add	a5,a5,a4
ffffffffc0201858:	6a18                	ld	a4,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020185a:	8d95                	sub	a1,a1,a3
ffffffffc020185c:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc020185e:	81b1                	srli	a1,a1,0xc
ffffffffc0201860:	953e                	add	a0,a0,a5
ffffffffc0201862:	9702                	jalr	a4
}
ffffffffc0201864:	bfbd                	j	ffffffffc02017e2 <pmm_init+0xf2>
        panic("pa2page called with invalid pa");
ffffffffc0201866:	00001617          	auipc	a2,0x1
ffffffffc020186a:	f4a60613          	addi	a2,a2,-182 # ffffffffc02027b0 <buddy_pmm_manager+0xf0>
ffffffffc020186e:	06a00593          	li	a1,106
ffffffffc0201872:	00001517          	auipc	a0,0x1
ffffffffc0201876:	f5e50513          	addi	a0,a0,-162 # ffffffffc02027d0 <buddy_pmm_manager+0x110>
ffffffffc020187a:	94dfe0ef          	jal	ra,ffffffffc02001c6 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020187e:	00001617          	auipc	a2,0x1
ffffffffc0201882:	f0a60613          	addi	a2,a2,-246 # ffffffffc0202788 <buddy_pmm_manager+0xc8>
ffffffffc0201886:	05d00593          	li	a1,93
ffffffffc020188a:	00001517          	auipc	a0,0x1
ffffffffc020188e:	ea650513          	addi	a0,a0,-346 # ffffffffc0202730 <buddy_pmm_manager+0x70>
ffffffffc0201892:	935fe0ef          	jal	ra,ffffffffc02001c6 <__panic>
        panic("DTB memory info not available");
ffffffffc0201896:	00001617          	auipc	a2,0x1
ffffffffc020189a:	e7a60613          	addi	a2,a2,-390 # ffffffffc0202710 <buddy_pmm_manager+0x50>
ffffffffc020189e:	04500593          	li	a1,69
ffffffffc02018a2:	00001517          	auipc	a0,0x1
ffffffffc02018a6:	e8e50513          	addi	a0,a0,-370 # ffffffffc0202730 <buddy_pmm_manager+0x70>
ffffffffc02018aa:	91dfe0ef          	jal	ra,ffffffffc02001c6 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc02018ae:	86ae                	mv	a3,a1
ffffffffc02018b0:	00001617          	auipc	a2,0x1
ffffffffc02018b4:	ed860613          	addi	a2,a2,-296 # ffffffffc0202788 <buddy_pmm_manager+0xc8>
ffffffffc02018b8:	07800593          	li	a1,120
ffffffffc02018bc:	00001517          	auipc	a0,0x1
ffffffffc02018c0:	e7450513          	addi	a0,a0,-396 # ffffffffc0202730 <buddy_pmm_manager+0x70>
ffffffffc02018c4:	903fe0ef          	jal	ra,ffffffffc02001c6 <__panic>

ffffffffc02018c8 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02018c8:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02018cc:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc02018ce:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02018d2:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02018d4:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02018d8:	f022                	sd	s0,32(sp)
ffffffffc02018da:	ec26                	sd	s1,24(sp)
ffffffffc02018dc:	e84a                	sd	s2,16(sp)
ffffffffc02018de:	f406                	sd	ra,40(sp)
ffffffffc02018e0:	e44e                	sd	s3,8(sp)
ffffffffc02018e2:	84aa                	mv	s1,a0
ffffffffc02018e4:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02018e6:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc02018ea:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc02018ec:	03067e63          	bgeu	a2,a6,ffffffffc0201928 <printnum+0x60>
ffffffffc02018f0:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02018f2:	00805763          	blez	s0,ffffffffc0201900 <printnum+0x38>
ffffffffc02018f6:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02018f8:	85ca                	mv	a1,s2
ffffffffc02018fa:	854e                	mv	a0,s3
ffffffffc02018fc:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02018fe:	fc65                	bnez	s0,ffffffffc02018f6 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201900:	1a02                	slli	s4,s4,0x20
ffffffffc0201902:	00001797          	auipc	a5,0x1
ffffffffc0201906:	f3e78793          	addi	a5,a5,-194 # ffffffffc0202840 <buddy_pmm_manager+0x180>
ffffffffc020190a:	020a5a13          	srli	s4,s4,0x20
ffffffffc020190e:	9a3e                	add	s4,s4,a5
}
ffffffffc0201910:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201912:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0201916:	70a2                	ld	ra,40(sp)
ffffffffc0201918:	69a2                	ld	s3,8(sp)
ffffffffc020191a:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020191c:	85ca                	mv	a1,s2
ffffffffc020191e:	87a6                	mv	a5,s1
}
ffffffffc0201920:	6942                	ld	s2,16(sp)
ffffffffc0201922:	64e2                	ld	s1,24(sp)
ffffffffc0201924:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201926:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201928:	03065633          	divu	a2,a2,a6
ffffffffc020192c:	8722                	mv	a4,s0
ffffffffc020192e:	f9bff0ef          	jal	ra,ffffffffc02018c8 <printnum>
ffffffffc0201932:	b7f9                	j	ffffffffc0201900 <printnum+0x38>

ffffffffc0201934 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201934:	7119                	addi	sp,sp,-128
ffffffffc0201936:	f4a6                	sd	s1,104(sp)
ffffffffc0201938:	f0ca                	sd	s2,96(sp)
ffffffffc020193a:	ecce                	sd	s3,88(sp)
ffffffffc020193c:	e8d2                	sd	s4,80(sp)
ffffffffc020193e:	e4d6                	sd	s5,72(sp)
ffffffffc0201940:	e0da                	sd	s6,64(sp)
ffffffffc0201942:	fc5e                	sd	s7,56(sp)
ffffffffc0201944:	f06a                	sd	s10,32(sp)
ffffffffc0201946:	fc86                	sd	ra,120(sp)
ffffffffc0201948:	f8a2                	sd	s0,112(sp)
ffffffffc020194a:	f862                	sd	s8,48(sp)
ffffffffc020194c:	f466                	sd	s9,40(sp)
ffffffffc020194e:	ec6e                	sd	s11,24(sp)
ffffffffc0201950:	892a                	mv	s2,a0
ffffffffc0201952:	84ae                	mv	s1,a1
ffffffffc0201954:	8d32                	mv	s10,a2
ffffffffc0201956:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201958:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc020195c:	5b7d                	li	s6,-1
ffffffffc020195e:	00001a97          	auipc	s5,0x1
ffffffffc0201962:	f16a8a93          	addi	s5,s5,-234 # ffffffffc0202874 <buddy_pmm_manager+0x1b4>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201966:	00001b97          	auipc	s7,0x1
ffffffffc020196a:	0eab8b93          	addi	s7,s7,234 # ffffffffc0202a50 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020196e:	000d4503          	lbu	a0,0(s10)
ffffffffc0201972:	001d0413          	addi	s0,s10,1
ffffffffc0201976:	01350a63          	beq	a0,s3,ffffffffc020198a <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc020197a:	c121                	beqz	a0,ffffffffc02019ba <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc020197c:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020197e:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0201980:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201982:	fff44503          	lbu	a0,-1(s0)
ffffffffc0201986:	ff351ae3          	bne	a0,s3,ffffffffc020197a <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020198a:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc020198e:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0201992:	4c81                	li	s9,0
ffffffffc0201994:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0201996:	5c7d                	li	s8,-1
ffffffffc0201998:	5dfd                	li	s11,-1
ffffffffc020199a:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc020199e:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02019a0:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02019a4:	0ff5f593          	zext.b	a1,a1
ffffffffc02019a8:	00140d13          	addi	s10,s0,1
ffffffffc02019ac:	04b56263          	bltu	a0,a1,ffffffffc02019f0 <vprintfmt+0xbc>
ffffffffc02019b0:	058a                	slli	a1,a1,0x2
ffffffffc02019b2:	95d6                	add	a1,a1,s5
ffffffffc02019b4:	4194                	lw	a3,0(a1)
ffffffffc02019b6:	96d6                	add	a3,a3,s5
ffffffffc02019b8:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02019ba:	70e6                	ld	ra,120(sp)
ffffffffc02019bc:	7446                	ld	s0,112(sp)
ffffffffc02019be:	74a6                	ld	s1,104(sp)
ffffffffc02019c0:	7906                	ld	s2,96(sp)
ffffffffc02019c2:	69e6                	ld	s3,88(sp)
ffffffffc02019c4:	6a46                	ld	s4,80(sp)
ffffffffc02019c6:	6aa6                	ld	s5,72(sp)
ffffffffc02019c8:	6b06                	ld	s6,64(sp)
ffffffffc02019ca:	7be2                	ld	s7,56(sp)
ffffffffc02019cc:	7c42                	ld	s8,48(sp)
ffffffffc02019ce:	7ca2                	ld	s9,40(sp)
ffffffffc02019d0:	7d02                	ld	s10,32(sp)
ffffffffc02019d2:	6de2                	ld	s11,24(sp)
ffffffffc02019d4:	6109                	addi	sp,sp,128
ffffffffc02019d6:	8082                	ret
            padc = '0';
ffffffffc02019d8:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc02019da:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02019de:	846a                	mv	s0,s10
ffffffffc02019e0:	00140d13          	addi	s10,s0,1
ffffffffc02019e4:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02019e8:	0ff5f593          	zext.b	a1,a1
ffffffffc02019ec:	fcb572e3          	bgeu	a0,a1,ffffffffc02019b0 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc02019f0:	85a6                	mv	a1,s1
ffffffffc02019f2:	02500513          	li	a0,37
ffffffffc02019f6:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02019f8:	fff44783          	lbu	a5,-1(s0)
ffffffffc02019fc:	8d22                	mv	s10,s0
ffffffffc02019fe:	f73788e3          	beq	a5,s3,ffffffffc020196e <vprintfmt+0x3a>
ffffffffc0201a02:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201a06:	1d7d                	addi	s10,s10,-1
ffffffffc0201a08:	ff379de3          	bne	a5,s3,ffffffffc0201a02 <vprintfmt+0xce>
ffffffffc0201a0c:	b78d                	j	ffffffffc020196e <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0201a0e:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0201a12:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a16:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0201a18:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0201a1c:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201a20:	02d86463          	bltu	a6,a3,ffffffffc0201a48 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0201a24:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201a28:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201a2c:	0186873b          	addw	a4,a3,s8
ffffffffc0201a30:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201a34:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0201a36:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201a3a:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201a3c:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0201a40:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201a44:	fed870e3          	bgeu	a6,a3,ffffffffc0201a24 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0201a48:	f40ddce3          	bgez	s11,ffffffffc02019a0 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0201a4c:	8de2                	mv	s11,s8
ffffffffc0201a4e:	5c7d                	li	s8,-1
ffffffffc0201a50:	bf81                	j	ffffffffc02019a0 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0201a52:	fffdc693          	not	a3,s11
ffffffffc0201a56:	96fd                	srai	a3,a3,0x3f
ffffffffc0201a58:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a5c:	00144603          	lbu	a2,1(s0)
ffffffffc0201a60:	2d81                	sext.w	s11,s11
ffffffffc0201a62:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201a64:	bf35                	j	ffffffffc02019a0 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0201a66:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a6a:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0201a6e:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a70:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0201a72:	bfd9                	j	ffffffffc0201a48 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0201a74:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201a76:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201a7a:	01174463          	blt	a4,a7,ffffffffc0201a82 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0201a7e:	1a088e63          	beqz	a7,ffffffffc0201c3a <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0201a82:	000a3603          	ld	a2,0(s4)
ffffffffc0201a86:	46c1                	li	a3,16
ffffffffc0201a88:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201a8a:	2781                	sext.w	a5,a5
ffffffffc0201a8c:	876e                	mv	a4,s11
ffffffffc0201a8e:	85a6                	mv	a1,s1
ffffffffc0201a90:	854a                	mv	a0,s2
ffffffffc0201a92:	e37ff0ef          	jal	ra,ffffffffc02018c8 <printnum>
            break;
ffffffffc0201a96:	bde1                	j	ffffffffc020196e <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0201a98:	000a2503          	lw	a0,0(s4)
ffffffffc0201a9c:	85a6                	mv	a1,s1
ffffffffc0201a9e:	0a21                	addi	s4,s4,8
ffffffffc0201aa0:	9902                	jalr	s2
            break;
ffffffffc0201aa2:	b5f1                	j	ffffffffc020196e <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201aa4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201aa6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201aaa:	01174463          	blt	a4,a7,ffffffffc0201ab2 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0201aae:	18088163          	beqz	a7,ffffffffc0201c30 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0201ab2:	000a3603          	ld	a2,0(s4)
ffffffffc0201ab6:	46a9                	li	a3,10
ffffffffc0201ab8:	8a2e                	mv	s4,a1
ffffffffc0201aba:	bfc1                	j	ffffffffc0201a8a <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201abc:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0201ac0:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ac2:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201ac4:	bdf1                	j	ffffffffc02019a0 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0201ac6:	85a6                	mv	a1,s1
ffffffffc0201ac8:	02500513          	li	a0,37
ffffffffc0201acc:	9902                	jalr	s2
            break;
ffffffffc0201ace:	b545                	j	ffffffffc020196e <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ad0:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0201ad4:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ad6:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201ad8:	b5e1                	j	ffffffffc02019a0 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0201ada:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201adc:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201ae0:	01174463          	blt	a4,a7,ffffffffc0201ae8 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0201ae4:	14088163          	beqz	a7,ffffffffc0201c26 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0201ae8:	000a3603          	ld	a2,0(s4)
ffffffffc0201aec:	46a1                	li	a3,8
ffffffffc0201aee:	8a2e                	mv	s4,a1
ffffffffc0201af0:	bf69                	j	ffffffffc0201a8a <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0201af2:	03000513          	li	a0,48
ffffffffc0201af6:	85a6                	mv	a1,s1
ffffffffc0201af8:	e03e                	sd	a5,0(sp)
ffffffffc0201afa:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0201afc:	85a6                	mv	a1,s1
ffffffffc0201afe:	07800513          	li	a0,120
ffffffffc0201b02:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201b04:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201b06:	6782                	ld	a5,0(sp)
ffffffffc0201b08:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201b0a:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0201b0e:	bfb5                	j	ffffffffc0201a8a <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201b10:	000a3403          	ld	s0,0(s4)
ffffffffc0201b14:	008a0713          	addi	a4,s4,8
ffffffffc0201b18:	e03a                	sd	a4,0(sp)
ffffffffc0201b1a:	14040263          	beqz	s0,ffffffffc0201c5e <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0201b1e:	0fb05763          	blez	s11,ffffffffc0201c0c <vprintfmt+0x2d8>
ffffffffc0201b22:	02d00693          	li	a3,45
ffffffffc0201b26:	0cd79163          	bne	a5,a3,ffffffffc0201be8 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201b2a:	00044783          	lbu	a5,0(s0)
ffffffffc0201b2e:	0007851b          	sext.w	a0,a5
ffffffffc0201b32:	cf85                	beqz	a5,ffffffffc0201b6a <vprintfmt+0x236>
ffffffffc0201b34:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201b38:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201b3c:	000c4563          	bltz	s8,ffffffffc0201b46 <vprintfmt+0x212>
ffffffffc0201b40:	3c7d                	addiw	s8,s8,-1
ffffffffc0201b42:	036c0263          	beq	s8,s6,ffffffffc0201b66 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0201b46:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201b48:	0e0c8e63          	beqz	s9,ffffffffc0201c44 <vprintfmt+0x310>
ffffffffc0201b4c:	3781                	addiw	a5,a5,-32
ffffffffc0201b4e:	0ef47b63          	bgeu	s0,a5,ffffffffc0201c44 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0201b52:	03f00513          	li	a0,63
ffffffffc0201b56:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201b58:	000a4783          	lbu	a5,0(s4)
ffffffffc0201b5c:	3dfd                	addiw	s11,s11,-1
ffffffffc0201b5e:	0a05                	addi	s4,s4,1
ffffffffc0201b60:	0007851b          	sext.w	a0,a5
ffffffffc0201b64:	ffe1                	bnez	a5,ffffffffc0201b3c <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0201b66:	01b05963          	blez	s11,ffffffffc0201b78 <vprintfmt+0x244>
ffffffffc0201b6a:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0201b6c:	85a6                	mv	a1,s1
ffffffffc0201b6e:	02000513          	li	a0,32
ffffffffc0201b72:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0201b74:	fe0d9be3          	bnez	s11,ffffffffc0201b6a <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201b78:	6a02                	ld	s4,0(sp)
ffffffffc0201b7a:	bbd5                	j	ffffffffc020196e <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201b7c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201b7e:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0201b82:	01174463          	blt	a4,a7,ffffffffc0201b8a <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0201b86:	08088d63          	beqz	a7,ffffffffc0201c20 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0201b8a:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201b8e:	0a044d63          	bltz	s0,ffffffffc0201c48 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0201b92:	8622                	mv	a2,s0
ffffffffc0201b94:	8a66                	mv	s4,s9
ffffffffc0201b96:	46a9                	li	a3,10
ffffffffc0201b98:	bdcd                	j	ffffffffc0201a8a <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0201b9a:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201b9e:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0201ba0:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201ba2:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0201ba6:	8fb5                	xor	a5,a5,a3
ffffffffc0201ba8:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201bac:	02d74163          	blt	a4,a3,ffffffffc0201bce <vprintfmt+0x29a>
ffffffffc0201bb0:	00369793          	slli	a5,a3,0x3
ffffffffc0201bb4:	97de                	add	a5,a5,s7
ffffffffc0201bb6:	639c                	ld	a5,0(a5)
ffffffffc0201bb8:	cb99                	beqz	a5,ffffffffc0201bce <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201bba:	86be                	mv	a3,a5
ffffffffc0201bbc:	00001617          	auipc	a2,0x1
ffffffffc0201bc0:	cb460613          	addi	a2,a2,-844 # ffffffffc0202870 <buddy_pmm_manager+0x1b0>
ffffffffc0201bc4:	85a6                	mv	a1,s1
ffffffffc0201bc6:	854a                	mv	a0,s2
ffffffffc0201bc8:	0ce000ef          	jal	ra,ffffffffc0201c96 <printfmt>
ffffffffc0201bcc:	b34d                	j	ffffffffc020196e <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201bce:	00001617          	auipc	a2,0x1
ffffffffc0201bd2:	c9260613          	addi	a2,a2,-878 # ffffffffc0202860 <buddy_pmm_manager+0x1a0>
ffffffffc0201bd6:	85a6                	mv	a1,s1
ffffffffc0201bd8:	854a                	mv	a0,s2
ffffffffc0201bda:	0bc000ef          	jal	ra,ffffffffc0201c96 <printfmt>
ffffffffc0201bde:	bb41                	j	ffffffffc020196e <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0201be0:	00001417          	auipc	s0,0x1
ffffffffc0201be4:	c7840413          	addi	s0,s0,-904 # ffffffffc0202858 <buddy_pmm_manager+0x198>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201be8:	85e2                	mv	a1,s8
ffffffffc0201bea:	8522                	mv	a0,s0
ffffffffc0201bec:	e43e                	sd	a5,8(sp)
ffffffffc0201bee:	0fc000ef          	jal	ra,ffffffffc0201cea <strnlen>
ffffffffc0201bf2:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201bf6:	01b05b63          	blez	s11,ffffffffc0201c0c <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0201bfa:	67a2                	ld	a5,8(sp)
ffffffffc0201bfc:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201c00:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0201c02:	85a6                	mv	a1,s1
ffffffffc0201c04:	8552                	mv	a0,s4
ffffffffc0201c06:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201c08:	fe0d9ce3          	bnez	s11,ffffffffc0201c00 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c0c:	00044783          	lbu	a5,0(s0)
ffffffffc0201c10:	00140a13          	addi	s4,s0,1
ffffffffc0201c14:	0007851b          	sext.w	a0,a5
ffffffffc0201c18:	d3a5                	beqz	a5,ffffffffc0201b78 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201c1a:	05e00413          	li	s0,94
ffffffffc0201c1e:	bf39                	j	ffffffffc0201b3c <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0201c20:	000a2403          	lw	s0,0(s4)
ffffffffc0201c24:	b7ad                	j	ffffffffc0201b8e <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0201c26:	000a6603          	lwu	a2,0(s4)
ffffffffc0201c2a:	46a1                	li	a3,8
ffffffffc0201c2c:	8a2e                	mv	s4,a1
ffffffffc0201c2e:	bdb1                	j	ffffffffc0201a8a <vprintfmt+0x156>
ffffffffc0201c30:	000a6603          	lwu	a2,0(s4)
ffffffffc0201c34:	46a9                	li	a3,10
ffffffffc0201c36:	8a2e                	mv	s4,a1
ffffffffc0201c38:	bd89                	j	ffffffffc0201a8a <vprintfmt+0x156>
ffffffffc0201c3a:	000a6603          	lwu	a2,0(s4)
ffffffffc0201c3e:	46c1                	li	a3,16
ffffffffc0201c40:	8a2e                	mv	s4,a1
ffffffffc0201c42:	b5a1                	j	ffffffffc0201a8a <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0201c44:	9902                	jalr	s2
ffffffffc0201c46:	bf09                	j	ffffffffc0201b58 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0201c48:	85a6                	mv	a1,s1
ffffffffc0201c4a:	02d00513          	li	a0,45
ffffffffc0201c4e:	e03e                	sd	a5,0(sp)
ffffffffc0201c50:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0201c52:	6782                	ld	a5,0(sp)
ffffffffc0201c54:	8a66                	mv	s4,s9
ffffffffc0201c56:	40800633          	neg	a2,s0
ffffffffc0201c5a:	46a9                	li	a3,10
ffffffffc0201c5c:	b53d                	j	ffffffffc0201a8a <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0201c5e:	03b05163          	blez	s11,ffffffffc0201c80 <vprintfmt+0x34c>
ffffffffc0201c62:	02d00693          	li	a3,45
ffffffffc0201c66:	f6d79de3          	bne	a5,a3,ffffffffc0201be0 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0201c6a:	00001417          	auipc	s0,0x1
ffffffffc0201c6e:	bee40413          	addi	s0,s0,-1042 # ffffffffc0202858 <buddy_pmm_manager+0x198>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c72:	02800793          	li	a5,40
ffffffffc0201c76:	02800513          	li	a0,40
ffffffffc0201c7a:	00140a13          	addi	s4,s0,1
ffffffffc0201c7e:	bd6d                	j	ffffffffc0201b38 <vprintfmt+0x204>
ffffffffc0201c80:	00001a17          	auipc	s4,0x1
ffffffffc0201c84:	bd9a0a13          	addi	s4,s4,-1063 # ffffffffc0202859 <buddy_pmm_manager+0x199>
ffffffffc0201c88:	02800513          	li	a0,40
ffffffffc0201c8c:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201c90:	05e00413          	li	s0,94
ffffffffc0201c94:	b565                	j	ffffffffc0201b3c <vprintfmt+0x208>

ffffffffc0201c96 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201c96:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201c98:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201c9c:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201c9e:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201ca0:	ec06                	sd	ra,24(sp)
ffffffffc0201ca2:	f83a                	sd	a4,48(sp)
ffffffffc0201ca4:	fc3e                	sd	a5,56(sp)
ffffffffc0201ca6:	e0c2                	sd	a6,64(sp)
ffffffffc0201ca8:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201caa:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201cac:	c89ff0ef          	jal	ra,ffffffffc0201934 <vprintfmt>
}
ffffffffc0201cb0:	60e2                	ld	ra,24(sp)
ffffffffc0201cb2:	6161                	addi	sp,sp,80
ffffffffc0201cb4:	8082                	ret

ffffffffc0201cb6 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201cb6:	4781                	li	a5,0
ffffffffc0201cb8:	00004717          	auipc	a4,0x4
ffffffffc0201cbc:	35873703          	ld	a4,856(a4) # ffffffffc0206010 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201cc0:	88ba                	mv	a7,a4
ffffffffc0201cc2:	852a                	mv	a0,a0
ffffffffc0201cc4:	85be                	mv	a1,a5
ffffffffc0201cc6:	863e                	mv	a2,a5
ffffffffc0201cc8:	00000073          	ecall
ffffffffc0201ccc:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0201cce:	8082                	ret

ffffffffc0201cd0 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0201cd0:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0201cd4:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0201cd6:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0201cd8:	cb81                	beqz	a5,ffffffffc0201ce8 <strlen+0x18>
        cnt ++;
ffffffffc0201cda:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0201cdc:	00a707b3          	add	a5,a4,a0
ffffffffc0201ce0:	0007c783          	lbu	a5,0(a5)
ffffffffc0201ce4:	fbfd                	bnez	a5,ffffffffc0201cda <strlen+0xa>
ffffffffc0201ce6:	8082                	ret
    }
    return cnt;
}
ffffffffc0201ce8:	8082                	ret

ffffffffc0201cea <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201cea:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201cec:	e589                	bnez	a1,ffffffffc0201cf6 <strnlen+0xc>
ffffffffc0201cee:	a811                	j	ffffffffc0201d02 <strnlen+0x18>
        cnt ++;
ffffffffc0201cf0:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201cf2:	00f58863          	beq	a1,a5,ffffffffc0201d02 <strnlen+0x18>
ffffffffc0201cf6:	00f50733          	add	a4,a0,a5
ffffffffc0201cfa:	00074703          	lbu	a4,0(a4)
ffffffffc0201cfe:	fb6d                	bnez	a4,ffffffffc0201cf0 <strnlen+0x6>
ffffffffc0201d00:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201d02:	852e                	mv	a0,a1
ffffffffc0201d04:	8082                	ret

ffffffffc0201d06 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201d06:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201d0a:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201d0e:	cb89                	beqz	a5,ffffffffc0201d20 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0201d10:	0505                	addi	a0,a0,1
ffffffffc0201d12:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201d14:	fee789e3          	beq	a5,a4,ffffffffc0201d06 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201d18:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0201d1c:	9d19                	subw	a0,a0,a4
ffffffffc0201d1e:	8082                	ret
ffffffffc0201d20:	4501                	li	a0,0
ffffffffc0201d22:	bfed                	j	ffffffffc0201d1c <strcmp+0x16>

ffffffffc0201d24 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201d24:	c20d                	beqz	a2,ffffffffc0201d46 <strncmp+0x22>
ffffffffc0201d26:	962e                	add	a2,a2,a1
ffffffffc0201d28:	a031                	j	ffffffffc0201d34 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0201d2a:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201d2c:	00e79a63          	bne	a5,a4,ffffffffc0201d40 <strncmp+0x1c>
ffffffffc0201d30:	00b60b63          	beq	a2,a1,ffffffffc0201d46 <strncmp+0x22>
ffffffffc0201d34:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201d38:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201d3a:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0201d3e:	f7f5                	bnez	a5,ffffffffc0201d2a <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201d40:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0201d44:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201d46:	4501                	li	a0,0
ffffffffc0201d48:	8082                	ret

ffffffffc0201d4a <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201d4a:	ca01                	beqz	a2,ffffffffc0201d5a <memset+0x10>
ffffffffc0201d4c:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0201d4e:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0201d50:	0785                	addi	a5,a5,1
ffffffffc0201d52:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201d56:	fec79de3          	bne	a5,a2,ffffffffc0201d50 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201d5a:	8082                	ret

ffffffffc0201d5c <strstr>:
 * The strstr() function returns a pointer to the beginning of the located
 * substring, or NULL if the substring is not found.
 * */
char *
strstr(const char *haystack, const char *needle) {
    if (!*needle) {
ffffffffc0201d5c:	0005c803          	lbu	a6,0(a1)
ffffffffc0201d60:	02080263          	beqz	a6,ffffffffc0201d84 <strstr+0x28>
        return (char *)haystack;
    }
    
    for (; *haystack; haystack++) {
ffffffffc0201d64:	00054783          	lbu	a5,0(a0)
ffffffffc0201d68:	c785                	beqz	a5,ffffffffc0201d90 <strstr+0x34>
strstr(const char *haystack, const char *needle) {
ffffffffc0201d6a:	86ae                	mv	a3,a1
ffffffffc0201d6c:	872a                	mv	a4,a0
ffffffffc0201d6e:	8642                	mv	a2,a6
        const char *h = haystack;
        const char *n = needle;
        
        while (*h && *n && (*h == *n)) {
            h++;
ffffffffc0201d70:	0705                	addi	a4,a4,1
            n++;
ffffffffc0201d72:	0685                	addi	a3,a3,1
        while (*h && *n && (*h == *n)) {
ffffffffc0201d74:	00f61a63          	bne	a2,a5,ffffffffc0201d88 <strstr+0x2c>
ffffffffc0201d78:	00074783          	lbu	a5,0(a4)
ffffffffc0201d7c:	0006c603          	lbu	a2,0(a3) # fffffffffec00000 <end+0x3e9f9e48>
ffffffffc0201d80:	c399                	beqz	a5,ffffffffc0201d86 <strstr+0x2a>
ffffffffc0201d82:	f67d                	bnez	a2,ffffffffc0201d70 <strstr+0x14>
            return (char *)haystack;
        }
    }
    
    return NULL;
}
ffffffffc0201d84:	8082                	ret
        if (!*n) {
ffffffffc0201d86:	de7d                	beqz	a2,ffffffffc0201d84 <strstr+0x28>
    for (; *haystack; haystack++) {
ffffffffc0201d88:	00154783          	lbu	a5,1(a0)
ffffffffc0201d8c:	0505                	addi	a0,a0,1
ffffffffc0201d8e:	fff1                	bnez	a5,ffffffffc0201d6a <strstr+0xe>
    return NULL;
ffffffffc0201d90:	4501                	li	a0,0
}
ffffffffc0201d92:	8082                	ret
