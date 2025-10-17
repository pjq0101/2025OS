
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00005297          	auipc	t0,0x5
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0205000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00005297          	auipc	t0,0x5
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0205008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02042b7          	lui	t0,0xc0204
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
ffffffffc020003c:	c0204137          	lui	sp,0xc0204

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
ffffffffc020004a:	1141                	addi	sp,sp,-16 # ffffffffc0203ff0 <bootstack+0x1ff0>
    extern char etext[], edata[], end[];
    cprintf("Special kernel symbols:\n");
ffffffffc020004c:	00001517          	auipc	a0,0x1
ffffffffc0200050:	62c50513          	addi	a0,a0,1580 # ffffffffc0201678 <etext>
void print_kerninfo(void) {
ffffffffc0200054:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200056:	0f2000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", (uintptr_t)kern_init);
ffffffffc020005a:	00000597          	auipc	a1,0x0
ffffffffc020005e:	07c58593          	addi	a1,a1,124 # ffffffffc02000d6 <kern_init>
ffffffffc0200062:	00001517          	auipc	a0,0x1
ffffffffc0200066:	63650513          	addi	a0,a0,1590 # ffffffffc0201698 <etext+0x20>
ffffffffc020006a:	0de000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc020006e:	00001597          	auipc	a1,0x1
ffffffffc0200072:	60a58593          	addi	a1,a1,1546 # ffffffffc0201678 <etext>
ffffffffc0200076:	00001517          	auipc	a0,0x1
ffffffffc020007a:	64250513          	addi	a0,a0,1602 # ffffffffc02016b8 <etext+0x40>
ffffffffc020007e:	0ca000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc0200082:	00005597          	auipc	a1,0x5
ffffffffc0200086:	f9658593          	addi	a1,a1,-106 # ffffffffc0205018 <free_area>
ffffffffc020008a:	00001517          	auipc	a0,0x1
ffffffffc020008e:	64e50513          	addi	a0,a0,1614 # ffffffffc02016d8 <etext+0x60>
ffffffffc0200092:	0b6000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc0200096:	00005597          	auipc	a1,0x5
ffffffffc020009a:	fe258593          	addi	a1,a1,-30 # ffffffffc0205078 <end>
ffffffffc020009e:	00001517          	auipc	a0,0x1
ffffffffc02000a2:	65a50513          	addi	a0,a0,1626 # ffffffffc02016f8 <etext+0x80>
ffffffffc02000a6:	0a2000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - (char*)kern_init + 1023) / 1024);
ffffffffc02000aa:	00000717          	auipc	a4,0x0
ffffffffc02000ae:	02c70713          	addi	a4,a4,44 # ffffffffc02000d6 <kern_init>
ffffffffc02000b2:	00005797          	auipc	a5,0x5
ffffffffc02000b6:	3c578793          	addi	a5,a5,965 # ffffffffc0205477 <end+0x3ff>
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
ffffffffc02000ce:	64e50513          	addi	a0,a0,1614 # ffffffffc0201718 <etext+0xa0>
}
ffffffffc02000d2:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000d4:	a895                	j	ffffffffc0200148 <cprintf>

ffffffffc02000d6 <kern_init>:

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc02000d6:	00005517          	auipc	a0,0x5
ffffffffc02000da:	f4250513          	addi	a0,a0,-190 # ffffffffc0205018 <free_area>
ffffffffc02000de:	00005617          	auipc	a2,0x5
ffffffffc02000e2:	f9a60613          	addi	a2,a2,-102 # ffffffffc0205078 <end>
int kern_init(void) {
ffffffffc02000e6:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc02000e8:	8e09                	sub	a2,a2,a0
ffffffffc02000ea:	4581                	li	a1,0
int kern_init(void) {
ffffffffc02000ec:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc02000ee:	578010ef          	jal	ffffffffc0201666 <memset>
    dtb_init();
ffffffffc02000f2:	136000ef          	jal	ffffffffc0200228 <dtb_init>
    cons_init();  // init the console
ffffffffc02000f6:	128000ef          	jal	ffffffffc020021e <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc02000fa:	00002517          	auipc	a0,0x2
ffffffffc02000fe:	d0e50513          	addi	a0,a0,-754 # ffffffffc0201e08 <etext+0x790>
ffffffffc0200102:	07a000ef          	jal	ffffffffc020017c <cputs>

    print_kerninfo();
ffffffffc0200106:	f45ff0ef          	jal	ffffffffc020004a <print_kerninfo>

    // grade_backtrace();
    pmm_init();  // init physical memory management
ffffffffc020010a:	713000ef          	jal	ffffffffc020101c <pmm_init>

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
ffffffffc0200110:	1101                	addi	sp,sp,-32
ffffffffc0200112:	ec06                	sd	ra,24(sp)
ffffffffc0200114:	e42e                	sd	a1,8(sp)
    cons_putc(c);
ffffffffc0200116:	10a000ef          	jal	ffffffffc0200220 <cons_putc>
    (*cnt) ++;
ffffffffc020011a:	65a2                	ld	a1,8(sp)
}
ffffffffc020011c:	60e2                	ld	ra,24(sp)
    (*cnt) ++;
ffffffffc020011e:	419c                	lw	a5,0(a1)
ffffffffc0200120:	2785                	addiw	a5,a5,1
ffffffffc0200122:	c19c                	sw	a5,0(a1)
}
ffffffffc0200124:	6105                	addi	sp,sp,32
ffffffffc0200126:	8082                	ret

ffffffffc0200128 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200128:	1101                	addi	sp,sp,-32
ffffffffc020012a:	862a                	mv	a2,a0
ffffffffc020012c:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020012e:	00000517          	auipc	a0,0x0
ffffffffc0200132:	fe250513          	addi	a0,a0,-30 # ffffffffc0200110 <cputch>
ffffffffc0200136:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200138:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020013a:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020013c:	11a010ef          	jal	ffffffffc0201256 <vprintfmt>
    return cnt;
}
ffffffffc0200140:	60e2                	ld	ra,24(sp)
ffffffffc0200142:	4532                	lw	a0,12(sp)
ffffffffc0200144:	6105                	addi	sp,sp,32
ffffffffc0200146:	8082                	ret

ffffffffc0200148 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc0200148:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020014a:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
ffffffffc020014e:	f42e                	sd	a1,40(sp)
ffffffffc0200150:	f832                	sd	a2,48(sp)
ffffffffc0200152:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200154:	862a                	mv	a2,a0
ffffffffc0200156:	004c                	addi	a1,sp,4
ffffffffc0200158:	00000517          	auipc	a0,0x0
ffffffffc020015c:	fb850513          	addi	a0,a0,-72 # ffffffffc0200110 <cputch>
ffffffffc0200160:	869a                	mv	a3,t1
cprintf(const char *fmt, ...) {
ffffffffc0200162:	ec06                	sd	ra,24(sp)
ffffffffc0200164:	e0ba                	sd	a4,64(sp)
ffffffffc0200166:	e4be                	sd	a5,72(sp)
ffffffffc0200168:	e8c2                	sd	a6,80(sp)
ffffffffc020016a:	ecc6                	sd	a7,88(sp)
    int cnt = 0;
ffffffffc020016c:	c202                	sw	zero,4(sp)
    va_start(ap, fmt);
ffffffffc020016e:	e41a                	sd	t1,8(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200170:	0e6010ef          	jal	ffffffffc0201256 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc0200174:	60e2                	ld	ra,24(sp)
ffffffffc0200176:	4512                	lw	a0,4(sp)
ffffffffc0200178:	6125                	addi	sp,sp,96
ffffffffc020017a:	8082                	ret

ffffffffc020017c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc020017c:	1101                	addi	sp,sp,-32
ffffffffc020017e:	e822                	sd	s0,16(sp)
ffffffffc0200180:	ec06                	sd	ra,24(sp)
ffffffffc0200182:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc0200184:	00054503          	lbu	a0,0(a0)
ffffffffc0200188:	c51d                	beqz	a0,ffffffffc02001b6 <cputs+0x3a>
ffffffffc020018a:	e426                	sd	s1,8(sp)
ffffffffc020018c:	0405                	addi	s0,s0,1
    int cnt = 0;
ffffffffc020018e:	4481                	li	s1,0
    cons_putc(c);
ffffffffc0200190:	090000ef          	jal	ffffffffc0200220 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200194:	00044503          	lbu	a0,0(s0)
ffffffffc0200198:	0405                	addi	s0,s0,1
ffffffffc020019a:	87a6                	mv	a5,s1
    (*cnt) ++;
ffffffffc020019c:	2485                	addiw	s1,s1,1
    while ((c = *str ++) != '\0') {
ffffffffc020019e:	f96d                	bnez	a0,ffffffffc0200190 <cputs+0x14>
    cons_putc(c);
ffffffffc02001a0:	4529                	li	a0,10
    (*cnt) ++;
ffffffffc02001a2:	0027841b          	addiw	s0,a5,2
ffffffffc02001a6:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc02001a8:	078000ef          	jal	ffffffffc0200220 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001ac:	60e2                	ld	ra,24(sp)
ffffffffc02001ae:	8522                	mv	a0,s0
ffffffffc02001b0:	6442                	ld	s0,16(sp)
ffffffffc02001b2:	6105                	addi	sp,sp,32
ffffffffc02001b4:	8082                	ret
    cons_putc(c);
ffffffffc02001b6:	4529                	li	a0,10
ffffffffc02001b8:	068000ef          	jal	ffffffffc0200220 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc02001bc:	4405                	li	s0,1
}
ffffffffc02001be:	60e2                	ld	ra,24(sp)
ffffffffc02001c0:	8522                	mv	a0,s0
ffffffffc02001c2:	6442                	ld	s0,16(sp)
ffffffffc02001c4:	6105                	addi	sp,sp,32
ffffffffc02001c6:	8082                	ret

ffffffffc02001c8 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02001c8:	00005317          	auipc	t1,0x5
ffffffffc02001cc:	e6832303          	lw	t1,-408(t1) # ffffffffc0205030 <is_panic>
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02001d0:	715d                	addi	sp,sp,-80
ffffffffc02001d2:	ec06                	sd	ra,24(sp)
ffffffffc02001d4:	f436                	sd	a3,40(sp)
ffffffffc02001d6:	f83a                	sd	a4,48(sp)
ffffffffc02001d8:	fc3e                	sd	a5,56(sp)
ffffffffc02001da:	e0c2                	sd	a6,64(sp)
ffffffffc02001dc:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02001de:	00030363          	beqz	t1,ffffffffc02001e4 <__panic+0x1c>
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    while (1) {
ffffffffc02001e2:	a001                	j	ffffffffc02001e2 <__panic+0x1a>
    is_panic = 1;
ffffffffc02001e4:	4705                	li	a4,1
    va_start(ap, fmt);
ffffffffc02001e6:	103c                	addi	a5,sp,40
ffffffffc02001e8:	e822                	sd	s0,16(sp)
ffffffffc02001ea:	8432                	mv	s0,a2
ffffffffc02001ec:	862e                	mv	a2,a1
ffffffffc02001ee:	85aa                	mv	a1,a0
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001f0:	00001517          	auipc	a0,0x1
ffffffffc02001f4:	55850513          	addi	a0,a0,1368 # ffffffffc0201748 <etext+0xd0>
    is_panic = 1;
ffffffffc02001f8:	00005697          	auipc	a3,0x5
ffffffffc02001fc:	e2e6ac23          	sw	a4,-456(a3) # ffffffffc0205030 <is_panic>
    va_start(ap, fmt);
ffffffffc0200200:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200202:	f47ff0ef          	jal	ffffffffc0200148 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200206:	65a2                	ld	a1,8(sp)
ffffffffc0200208:	8522                	mv	a0,s0
ffffffffc020020a:	f1fff0ef          	jal	ffffffffc0200128 <vcprintf>
    cprintf("\n");
ffffffffc020020e:	00001517          	auipc	a0,0x1
ffffffffc0200212:	55a50513          	addi	a0,a0,1370 # ffffffffc0201768 <etext+0xf0>
ffffffffc0200216:	f33ff0ef          	jal	ffffffffc0200148 <cprintf>
ffffffffc020021a:	6442                	ld	s0,16(sp)
ffffffffc020021c:	b7d9                	j	ffffffffc02001e2 <__panic+0x1a>

ffffffffc020021e <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020021e:	8082                	ret

ffffffffc0200220 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200220:	0ff57513          	zext.b	a0,a0
ffffffffc0200224:	3980106f          	j	ffffffffc02015bc <sbi_console_putchar>

ffffffffc0200228 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200228:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc020022a:	00001517          	auipc	a0,0x1
ffffffffc020022e:	54650513          	addi	a0,a0,1350 # ffffffffc0201770 <etext+0xf8>
void dtb_init(void) {
ffffffffc0200232:	f406                	sd	ra,40(sp)
ffffffffc0200234:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc0200236:	f13ff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020023a:	00005597          	auipc	a1,0x5
ffffffffc020023e:	dc65b583          	ld	a1,-570(a1) # ffffffffc0205000 <boot_hartid>
ffffffffc0200242:	00001517          	auipc	a0,0x1
ffffffffc0200246:	53e50513          	addi	a0,a0,1342 # ffffffffc0201780 <etext+0x108>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020024a:	00005417          	auipc	s0,0x5
ffffffffc020024e:	dbe40413          	addi	s0,s0,-578 # ffffffffc0205008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200252:	ef7ff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200256:	600c                	ld	a1,0(s0)
ffffffffc0200258:	00001517          	auipc	a0,0x1
ffffffffc020025c:	53850513          	addi	a0,a0,1336 # ffffffffc0201790 <etext+0x118>
ffffffffc0200260:	ee9ff0ef          	jal	ffffffffc0200148 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200264:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200266:	00001517          	auipc	a0,0x1
ffffffffc020026a:	54250513          	addi	a0,a0,1346 # ffffffffc02017a8 <etext+0x130>
    if (boot_dtb == 0) {
ffffffffc020026e:	10070163          	beqz	a4,ffffffffc0200370 <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200272:	57f5                	li	a5,-3
ffffffffc0200274:	07fa                	slli	a5,a5,0x1e
ffffffffc0200276:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200278:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc020027a:	d00e06b7          	lui	a3,0xd00e0
ffffffffc020027e:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfedae75>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200282:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200286:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020028a:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020028e:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200292:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200296:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200298:	8e49                	or	a2,a2,a0
ffffffffc020029a:	0ff7f793          	zext.b	a5,a5
ffffffffc020029e:	8dd1                	or	a1,a1,a2
ffffffffc02002a0:	07a2                	slli	a5,a5,0x8
ffffffffc02002a2:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002a4:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc02002a8:	0cd59863          	bne	a1,a3,ffffffffc0200378 <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02002ac:	4710                	lw	a2,8(a4)
ffffffffc02002ae:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02002b0:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002b2:	0086541b          	srliw	s0,a2,0x8
ffffffffc02002b6:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002ba:	01865e1b          	srliw	t3,a2,0x18
ffffffffc02002be:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002c2:	0186151b          	slliw	a0,a2,0x18
ffffffffc02002c6:	0186959b          	slliw	a1,a3,0x18
ffffffffc02002ca:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002ce:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002d2:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002d6:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02002da:	01c56533          	or	a0,a0,t3
ffffffffc02002de:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002e2:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e6:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002ea:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002ee:	0ff6f693          	zext.b	a3,a3
ffffffffc02002f2:	8c49                	or	s0,s0,a0
ffffffffc02002f4:	0622                	slli	a2,a2,0x8
ffffffffc02002f6:	8fcd                	or	a5,a5,a1
ffffffffc02002f8:	06a2                	slli	a3,a3,0x8
ffffffffc02002fa:	8c51                	or	s0,s0,a2
ffffffffc02002fc:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02002fe:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200300:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200302:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200304:	9381                	srli	a5,a5,0x20
ffffffffc0200306:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc0200308:	4301                	li	t1,0
        switch (token) {
ffffffffc020030a:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020030c:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020030e:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc0200312:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200314:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200316:	0087579b          	srliw	a5,a4,0x8
ffffffffc020031a:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020031e:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200322:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200326:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020032a:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020032e:	8ed1                	or	a3,a3,a2
ffffffffc0200330:	0ff77713          	zext.b	a4,a4
ffffffffc0200334:	8fd5                	or	a5,a5,a3
ffffffffc0200336:	0722                	slli	a4,a4,0x8
ffffffffc0200338:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc020033a:	05178763          	beq	a5,a7,ffffffffc0200388 <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020033e:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc0200340:	00f8e963          	bltu	a7,a5,ffffffffc0200352 <dtb_init+0x12a>
ffffffffc0200344:	07c78d63          	beq	a5,t3,ffffffffc02003be <dtb_init+0x196>
ffffffffc0200348:	4709                	li	a4,2
ffffffffc020034a:	00e79763          	bne	a5,a4,ffffffffc0200358 <dtb_init+0x130>
ffffffffc020034e:	4301                	li	t1,0
ffffffffc0200350:	b7d1                	j	ffffffffc0200314 <dtb_init+0xec>
ffffffffc0200352:	4711                	li	a4,4
ffffffffc0200354:	fce780e3          	beq	a5,a4,ffffffffc0200314 <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200358:	00001517          	auipc	a0,0x1
ffffffffc020035c:	51850513          	addi	a0,a0,1304 # ffffffffc0201870 <etext+0x1f8>
ffffffffc0200360:	de9ff0ef          	jal	ffffffffc0200148 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200364:	64e2                	ld	s1,24(sp)
ffffffffc0200366:	6942                	ld	s2,16(sp)
ffffffffc0200368:	00001517          	auipc	a0,0x1
ffffffffc020036c:	54050513          	addi	a0,a0,1344 # ffffffffc02018a8 <etext+0x230>
}
ffffffffc0200370:	7402                	ld	s0,32(sp)
ffffffffc0200372:	70a2                	ld	ra,40(sp)
ffffffffc0200374:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc0200376:	bbc9                	j	ffffffffc0200148 <cprintf>
}
ffffffffc0200378:	7402                	ld	s0,32(sp)
ffffffffc020037a:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc020037c:	00001517          	auipc	a0,0x1
ffffffffc0200380:	44c50513          	addi	a0,a0,1100 # ffffffffc02017c8 <etext+0x150>
}
ffffffffc0200384:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200386:	b3c9                	j	ffffffffc0200148 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200388:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020038a:	0087579b          	srliw	a5,a4,0x8
ffffffffc020038e:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200392:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200396:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020039a:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020039e:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02003a2:	8ed1                	or	a3,a3,a2
ffffffffc02003a4:	0ff77713          	zext.b	a4,a4
ffffffffc02003a8:	8fd5                	or	a5,a5,a3
ffffffffc02003aa:	0722                	slli	a4,a4,0x8
ffffffffc02003ac:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02003ae:	04031463          	bnez	t1,ffffffffc02003f6 <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02003b2:	1782                	slli	a5,a5,0x20
ffffffffc02003b4:	9381                	srli	a5,a5,0x20
ffffffffc02003b6:	043d                	addi	s0,s0,15
ffffffffc02003b8:	943e                	add	s0,s0,a5
ffffffffc02003ba:	9871                	andi	s0,s0,-4
                break;
ffffffffc02003bc:	bfa1                	j	ffffffffc0200314 <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc02003be:	8522                	mv	a0,s0
ffffffffc02003c0:	e01a                	sd	t1,0(sp)
ffffffffc02003c2:	214010ef          	jal	ffffffffc02015d6 <strlen>
ffffffffc02003c6:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003c8:	4619                	li	a2,6
ffffffffc02003ca:	8522                	mv	a0,s0
ffffffffc02003cc:	00001597          	auipc	a1,0x1
ffffffffc02003d0:	42458593          	addi	a1,a1,1060 # ffffffffc02017f0 <etext+0x178>
ffffffffc02003d4:	26a010ef          	jal	ffffffffc020163e <strncmp>
ffffffffc02003d8:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02003da:	0411                	addi	s0,s0,4
ffffffffc02003dc:	0004879b          	sext.w	a5,s1
ffffffffc02003e0:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003e2:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02003e6:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003e8:	00a36333          	or	t1,t1,a0
                break;
ffffffffc02003ec:	00ff0837          	lui	a6,0xff0
ffffffffc02003f0:	488d                	li	a7,3
ffffffffc02003f2:	4e05                	li	t3,1
ffffffffc02003f4:	b705                	j	ffffffffc0200314 <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02003f6:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02003f8:	00001597          	auipc	a1,0x1
ffffffffc02003fc:	40058593          	addi	a1,a1,1024 # ffffffffc02017f8 <etext+0x180>
ffffffffc0200400:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200402:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200406:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020040a:	0187169b          	slliw	a3,a4,0x18
ffffffffc020040e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200412:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200416:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020041a:	8ed1                	or	a3,a3,a2
ffffffffc020041c:	0ff77713          	zext.b	a4,a4
ffffffffc0200420:	0722                	slli	a4,a4,0x8
ffffffffc0200422:	8d55                	or	a0,a0,a3
ffffffffc0200424:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200426:	1502                	slli	a0,a0,0x20
ffffffffc0200428:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020042a:	954a                	add	a0,a0,s2
ffffffffc020042c:	e01a                	sd	t1,0(sp)
ffffffffc020042e:	1dc010ef          	jal	ffffffffc020160a <strcmp>
ffffffffc0200432:	67a2                	ld	a5,8(sp)
ffffffffc0200434:	473d                	li	a4,15
ffffffffc0200436:	6302                	ld	t1,0(sp)
ffffffffc0200438:	00ff0837          	lui	a6,0xff0
ffffffffc020043c:	488d                	li	a7,3
ffffffffc020043e:	4e05                	li	t3,1
ffffffffc0200440:	f6f779e3          	bgeu	a4,a5,ffffffffc02003b2 <dtb_init+0x18a>
ffffffffc0200444:	f53d                	bnez	a0,ffffffffc02003b2 <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200446:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020044a:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc020044e:	00001517          	auipc	a0,0x1
ffffffffc0200452:	3b250513          	addi	a0,a0,946 # ffffffffc0201800 <etext+0x188>
           fdt32_to_cpu(x >> 32);
ffffffffc0200456:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020045a:	0087d31b          	srliw	t1,a5,0x8
ffffffffc020045e:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200462:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200466:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020046a:	0187959b          	slliw	a1,a5,0x18
ffffffffc020046e:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200472:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200476:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020047a:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020047e:	01037333          	and	t1,t1,a6
ffffffffc0200482:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200486:	01e5e5b3          	or	a1,a1,t5
ffffffffc020048a:	0ff7f793          	zext.b	a5,a5
ffffffffc020048e:	01de6e33          	or	t3,t3,t4
ffffffffc0200492:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200496:	01067633          	and	a2,a2,a6
ffffffffc020049a:	0086d31b          	srliw	t1,a3,0x8
ffffffffc020049e:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004a2:	07a2                	slli	a5,a5,0x8
ffffffffc02004a4:	0108d89b          	srliw	a7,a7,0x10
ffffffffc02004a8:	0186df1b          	srliw	t5,a3,0x18
ffffffffc02004ac:	01875e9b          	srliw	t4,a4,0x18
ffffffffc02004b0:	8ddd                	or	a1,a1,a5
ffffffffc02004b2:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004b6:	0186979b          	slliw	a5,a3,0x18
ffffffffc02004ba:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004be:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c2:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004c6:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004ca:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ce:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004d2:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004d6:	08a2                	slli	a7,a7,0x8
ffffffffc02004d8:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004dc:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004e0:	0ff6f693          	zext.b	a3,a3
ffffffffc02004e4:	01de6833          	or	a6,t3,t4
ffffffffc02004e8:	0ff77713          	zext.b	a4,a4
ffffffffc02004ec:	01166633          	or	a2,a2,a7
ffffffffc02004f0:	0067e7b3          	or	a5,a5,t1
ffffffffc02004f4:	06a2                	slli	a3,a3,0x8
ffffffffc02004f6:	01046433          	or	s0,s0,a6
ffffffffc02004fa:	0722                	slli	a4,a4,0x8
ffffffffc02004fc:	8fd5                	or	a5,a5,a3
ffffffffc02004fe:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc0200500:	1582                	slli	a1,a1,0x20
ffffffffc0200502:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200504:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200506:	9201                	srli	a2,a2,0x20
ffffffffc0200508:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020050a:	1402                	slli	s0,s0,0x20
ffffffffc020050c:	00b7e4b3          	or	s1,a5,a1
ffffffffc0200510:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200512:	c37ff0ef          	jal	ffffffffc0200148 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200516:	85a6                	mv	a1,s1
ffffffffc0200518:	00001517          	auipc	a0,0x1
ffffffffc020051c:	30850513          	addi	a0,a0,776 # ffffffffc0201820 <etext+0x1a8>
ffffffffc0200520:	c29ff0ef          	jal	ffffffffc0200148 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200524:	01445613          	srli	a2,s0,0x14
ffffffffc0200528:	85a2                	mv	a1,s0
ffffffffc020052a:	00001517          	auipc	a0,0x1
ffffffffc020052e:	30e50513          	addi	a0,a0,782 # ffffffffc0201838 <etext+0x1c0>
ffffffffc0200532:	c17ff0ef          	jal	ffffffffc0200148 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200536:	009405b3          	add	a1,s0,s1
ffffffffc020053a:	15fd                	addi	a1,a1,-1
ffffffffc020053c:	00001517          	auipc	a0,0x1
ffffffffc0200540:	31c50513          	addi	a0,a0,796 # ffffffffc0201858 <etext+0x1e0>
ffffffffc0200544:	c05ff0ef          	jal	ffffffffc0200148 <cprintf>
        memory_base = mem_base;
ffffffffc0200548:	00005797          	auipc	a5,0x5
ffffffffc020054c:	ae97bc23          	sd	s1,-1288(a5) # ffffffffc0205040 <memory_base>
        memory_size = mem_size;
ffffffffc0200550:	00005797          	auipc	a5,0x5
ffffffffc0200554:	ae87b423          	sd	s0,-1304(a5) # ffffffffc0205038 <memory_size>
ffffffffc0200558:	b531                	j	ffffffffc0200364 <dtb_init+0x13c>

ffffffffc020055a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020055a:	00005517          	auipc	a0,0x5
ffffffffc020055e:	ae653503          	ld	a0,-1306(a0) # ffffffffc0205040 <memory_base>
ffffffffc0200562:	8082                	ret

ffffffffc0200564 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc0200564:	00005517          	auipc	a0,0x5
ffffffffc0200568:	ad453503          	ld	a0,-1324(a0) # ffffffffc0205038 <memory_size>
ffffffffc020056c:	8082                	ret

ffffffffc020056e <best_fit_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc020056e:	00005797          	auipc	a5,0x5
ffffffffc0200572:	aaa78793          	addi	a5,a5,-1366 # ffffffffc0205018 <free_area>
ffffffffc0200576:	e79c                	sd	a5,8(a5)
ffffffffc0200578:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
best_fit_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc020057a:	0007a823          	sw	zero,16(a5)
}
ffffffffc020057e:	8082                	ret

ffffffffc0200580 <best_fit_nr_free_pages>:
}

static size_t
best_fit_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200580:	00005517          	auipc	a0,0x5
ffffffffc0200584:	aa856503          	lwu	a0,-1368(a0) # ffffffffc0205028 <free_area+0x10>
ffffffffc0200588:	8082                	ret

ffffffffc020058a <best_fit_alloc_pages>:
    assert(n > 0);
ffffffffc020058a:	cd69                	beqz	a0,ffffffffc0200664 <best_fit_alloc_pages+0xda>
    if (n > nr_free) {
ffffffffc020058c:	00005897          	auipc	a7,0x5
ffffffffc0200590:	a9c8a883          	lw	a7,-1380(a7) # ffffffffc0205028 <free_area+0x10>
ffffffffc0200594:	86aa                	mv	a3,a0
ffffffffc0200596:	00005617          	auipc	a2,0x5
ffffffffc020059a:	a8260613          	addi	a2,a2,-1406 # ffffffffc0205018 <free_area>
ffffffffc020059e:	02089793          	slli	a5,a7,0x20
ffffffffc02005a2:	9381                	srli	a5,a5,0x20
ffffffffc02005a4:	0aa7e663          	bltu	a5,a0,ffffffffc0200650 <best_fit_alloc_pages+0xc6>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc02005a8:	661c                	ld	a5,8(a2)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02005aa:	0ac78363          	beq	a5,a2,ffffffffc0200650 <best_fit_alloc_pages+0xc6>
    size_t min_size = nr_free + 1;
ffffffffc02005ae:	0018859b          	addiw	a1,a7,1
ffffffffc02005b2:	1582                	slli	a1,a1,0x20
ffffffffc02005b4:	9181                	srli	a1,a1,0x20
    list_entry_t *best_le = NULL;
ffffffffc02005b6:	4801                	li	a6,0
    struct Page *page = NULL;
ffffffffc02005b8:	4501                	li	a0,0
        if (p->property >= n) {
ffffffffc02005ba:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02005be:	00d76a63          	bltu	a4,a3,ffffffffc02005d2 <best_fit_alloc_pages+0x48>
            if (p->property == n) {
ffffffffc02005c2:	06d70f63          	beq	a4,a3,ffffffffc0200640 <best_fit_alloc_pages+0xb6>
            if (p->property < min_size) {
ffffffffc02005c6:	00b77663          	bgeu	a4,a1,ffffffffc02005d2 <best_fit_alloc_pages+0x48>
                min_size = p->property;
ffffffffc02005ca:	85ba                	mv	a1,a4
                best_le = le;
ffffffffc02005cc:	883e                	mv	a6,a5
                page = p;
ffffffffc02005ce:	fe878513          	addi	a0,a5,-24
ffffffffc02005d2:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02005d4:	fec793e3          	bne	a5,a2,ffffffffc02005ba <best_fit_alloc_pages+0x30>
    if (page != NULL) {
ffffffffc02005d8:	c13d                	beqz	a0,ffffffffc020063e <best_fit_alloc_pages+0xb4>
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
ffffffffc02005da:	6d1c                	ld	a5,24(a0)
        list_entry_t* prev = (best_le != NULL) ? list_prev(best_le) : list_prev(&(page->page_link));
ffffffffc02005dc:	85be                	mv	a1,a5
ffffffffc02005de:	00080463          	beqz	a6,ffffffffc02005e6 <best_fit_alloc_pages+0x5c>
ffffffffc02005e2:	00083583          	ld	a1,0(a6) # ff0000 <kern_entry-0xffffffffbf210000>
        if (page->property > n) {
ffffffffc02005e6:	4918                	lw	a4,16(a0)
    __list_del(listelm->prev, listelm->next);
ffffffffc02005e8:	02053803          	ld	a6,32(a0)
ffffffffc02005ec:	02071313          	slli	t1,a4,0x20
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02005f0:	0107b423          	sd	a6,8(a5)
ffffffffc02005f4:	02035313          	srli	t1,t1,0x20
    next->prev = prev;
ffffffffc02005f8:	00f83023          	sd	a5,0(a6)
ffffffffc02005fc:	0266f963          	bgeu	a3,t1,ffffffffc020062e <best_fit_alloc_pages+0xa4>
            struct Page *p = page + n;
ffffffffc0200600:	00269793          	slli	a5,a3,0x2
ffffffffc0200604:	97b6                	add	a5,a5,a3
ffffffffc0200606:	078e                	slli	a5,a5,0x3
ffffffffc0200608:	97aa                	add	a5,a5,a0
            SetPageProperty(p);
ffffffffc020060a:	0087b803          	ld	a6,8(a5)
            p->property = page->property - n;
ffffffffc020060e:	9f15                	subw	a4,a4,a3
ffffffffc0200610:	cb98                	sw	a4,16(a5)
            SetPageProperty(p);
ffffffffc0200612:	00286713          	ori	a4,a6,2
ffffffffc0200616:	e798                	sd	a4,8(a5)
            if (prev != &free_list) {
ffffffffc0200618:	02c58e63          	beq	a1,a2,ffffffffc0200654 <best_fit_alloc_pages+0xca>
    __list_add(elm, listelm, listelm->next);
ffffffffc020061c:	6598                	ld	a4,8(a1)
                list_add_after(prev, &(p->page_link));
ffffffffc020061e:	01878813          	addi	a6,a5,24
    prev->next = next->prev = elm;
ffffffffc0200622:	01073023          	sd	a6,0(a4)
ffffffffc0200626:	0105b423          	sd	a6,8(a1)
    elm->next = next;
ffffffffc020062a:	f398                	sd	a4,32(a5)
    elm->prev = prev;
ffffffffc020062c:	ef8c                	sd	a1,24(a5)
        ClearPageProperty(page);
ffffffffc020062e:	651c                	ld	a5,8(a0)
        nr_free -= n;
ffffffffc0200630:	40d888bb          	subw	a7,a7,a3
ffffffffc0200634:	01162823          	sw	a7,16(a2)
        ClearPageProperty(page);
ffffffffc0200638:	9bf5                	andi	a5,a5,-3
ffffffffc020063a:	e51c                	sd	a5,8(a0)
ffffffffc020063c:	8082                	ret
ffffffffc020063e:	8082                	ret
                page = p;
ffffffffc0200640:	fe878513          	addi	a0,a5,-24
                best_le = le;
ffffffffc0200644:	883e                	mv	a6,a5
    return listelm->prev;
ffffffffc0200646:	6d1c                	ld	a5,24(a0)
        list_entry_t* prev = (best_le != NULL) ? list_prev(best_le) : list_prev(&(page->page_link));
ffffffffc0200648:	85be                	mv	a1,a5
ffffffffc020064a:	f8081ce3          	bnez	a6,ffffffffc02005e2 <best_fit_alloc_pages+0x58>
ffffffffc020064e:	bf61                	j	ffffffffc02005e6 <best_fit_alloc_pages+0x5c>
        return NULL;
ffffffffc0200650:	4501                	li	a0,0
}
ffffffffc0200652:	8082                	ret
    __list_add(elm, listelm, listelm->next);
ffffffffc0200654:	6618                	ld	a4,8(a2)
                list_add(&free_list, &(p->page_link));
ffffffffc0200656:	01878593          	addi	a1,a5,24
    prev->next = next->prev = elm;
ffffffffc020065a:	e30c                	sd	a1,0(a4)
ffffffffc020065c:	e60c                	sd	a1,8(a2)
    elm->next = next;
ffffffffc020065e:	f398                	sd	a4,32(a5)
    elm->prev = prev;
ffffffffc0200660:	ef90                	sd	a2,24(a5)
}
ffffffffc0200662:	b7f1                	j	ffffffffc020062e <best_fit_alloc_pages+0xa4>
best_fit_alloc_pages(size_t n) {
ffffffffc0200664:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200666:	00001697          	auipc	a3,0x1
ffffffffc020066a:	25a68693          	addi	a3,a3,602 # ffffffffc02018c0 <etext+0x248>
ffffffffc020066e:	00001617          	auipc	a2,0x1
ffffffffc0200672:	25a60613          	addi	a2,a2,602 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200676:	06b00593          	li	a1,107
ffffffffc020067a:	00001517          	auipc	a0,0x1
ffffffffc020067e:	26650513          	addi	a0,a0,614 # ffffffffc02018e0 <etext+0x268>
best_fit_alloc_pages(size_t n) {
ffffffffc0200682:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200684:	b45ff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200688 <best_fit_check>:
}

// LAB2: below code is used to check the best fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
best_fit_check(void) {
ffffffffc0200688:	711d                	addi	sp,sp,-96
ffffffffc020068a:	e0ca                	sd	s2,64(sp)
    return listelm->next;
ffffffffc020068c:	00005917          	auipc	s2,0x5
ffffffffc0200690:	98c90913          	addi	s2,s2,-1652 # ffffffffc0205018 <free_area>
ffffffffc0200694:	00893783          	ld	a5,8(s2)
ffffffffc0200698:	ec86                	sd	ra,88(sp)
ffffffffc020069a:	e8a2                	sd	s0,80(sp)
ffffffffc020069c:	e4a6                	sd	s1,72(sp)
ffffffffc020069e:	fc4e                	sd	s3,56(sp)
ffffffffc02006a0:	f852                	sd	s4,48(sp)
ffffffffc02006a2:	f456                	sd	s5,40(sp)
ffffffffc02006a4:	f05a                	sd	s6,32(sp)
ffffffffc02006a6:	ec5e                	sd	s7,24(sp)
ffffffffc02006a8:	e862                	sd	s8,16(sp)
ffffffffc02006aa:	e466                	sd	s9,8(sp)
    int score = 0 ,sumscore = 6;
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc02006ac:	2b278f63          	beq	a5,s2,ffffffffc020096a <best_fit_check+0x2e2>
    int count = 0, total = 0;
ffffffffc02006b0:	4401                	li	s0,0
ffffffffc02006b2:	4481                	li	s1,0
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02006b4:	ff07b703          	ld	a4,-16(a5)
ffffffffc02006b8:	8b09                	andi	a4,a4,2
ffffffffc02006ba:	2a070c63          	beqz	a4,ffffffffc0200972 <best_fit_check+0x2ea>
        count ++, total += p->property;
ffffffffc02006be:	ff87a703          	lw	a4,-8(a5)
ffffffffc02006c2:	679c                	ld	a5,8(a5)
ffffffffc02006c4:	2485                	addiw	s1,s1,1
ffffffffc02006c6:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc02006c8:	ff2796e3          	bne	a5,s2,ffffffffc02006b4 <best_fit_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc02006cc:	89a2                	mv	s3,s0
ffffffffc02006ce:	143000ef          	jal	ffffffffc0201010 <nr_free_pages>
ffffffffc02006d2:	39351063          	bne	a0,s3,ffffffffc0200a52 <best_fit_check+0x3ca>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02006d6:	4505                	li	a0,1
ffffffffc02006d8:	121000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc02006dc:	8aaa                	mv	s5,a0
ffffffffc02006de:	3a050a63          	beqz	a0,ffffffffc0200a92 <best_fit_check+0x40a>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02006e2:	4505                	li	a0,1
ffffffffc02006e4:	115000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc02006e8:	89aa                	mv	s3,a0
ffffffffc02006ea:	38050463          	beqz	a0,ffffffffc0200a72 <best_fit_check+0x3ea>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02006ee:	4505                	li	a0,1
ffffffffc02006f0:	109000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc02006f4:	8a2a                	mv	s4,a0
ffffffffc02006f6:	30050e63          	beqz	a0,ffffffffc0200a12 <best_fit_check+0x38a>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02006fa:	40aa87b3          	sub	a5,s5,a0
ffffffffc02006fe:	40a98733          	sub	a4,s3,a0
ffffffffc0200702:	0017b793          	seqz	a5,a5
ffffffffc0200706:	00173713          	seqz	a4,a4
ffffffffc020070a:	8fd9                	or	a5,a5,a4
ffffffffc020070c:	2e079363          	bnez	a5,ffffffffc02009f2 <best_fit_check+0x36a>
ffffffffc0200710:	2f3a8163          	beq	s5,s3,ffffffffc02009f2 <best_fit_check+0x36a>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200714:	000aa783          	lw	a5,0(s5)
ffffffffc0200718:	26079d63          	bnez	a5,ffffffffc0200992 <best_fit_check+0x30a>
ffffffffc020071c:	0009a783          	lw	a5,0(s3)
ffffffffc0200720:	26079963          	bnez	a5,ffffffffc0200992 <best_fit_check+0x30a>
ffffffffc0200724:	411c                	lw	a5,0(a0)
ffffffffc0200726:	26079663          	bnez	a5,ffffffffc0200992 <best_fit_check+0x30a>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc020072a:	00005797          	auipc	a5,0x5
ffffffffc020072e:	9467b783          	ld	a5,-1722(a5) # ffffffffc0205070 <pages>
ffffffffc0200732:	ccccd737          	lui	a4,0xccccd
ffffffffc0200736:	ccd70713          	addi	a4,a4,-819 # ffffffffcccccccd <end+0xcac7c55>
ffffffffc020073a:	02071693          	slli	a3,a4,0x20
ffffffffc020073e:	96ba                	add	a3,a3,a4
ffffffffc0200740:	40fa8733          	sub	a4,s5,a5
ffffffffc0200744:	870d                	srai	a4,a4,0x3
ffffffffc0200746:	02d70733          	mul	a4,a4,a3
ffffffffc020074a:	00002517          	auipc	a0,0x2
ffffffffc020074e:	8a653503          	ld	a0,-1882(a0) # ffffffffc0201ff0 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200752:	00005697          	auipc	a3,0x5
ffffffffc0200756:	9166b683          	ld	a3,-1770(a3) # ffffffffc0205068 <npage>
ffffffffc020075a:	06b2                	slli	a3,a3,0xc
ffffffffc020075c:	972a                	add	a4,a4,a0

static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc020075e:	0732                	slli	a4,a4,0xc
ffffffffc0200760:	26d77963          	bgeu	a4,a3,ffffffffc02009d2 <best_fit_check+0x34a>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200764:	ccccd5b7          	lui	a1,0xccccd
ffffffffc0200768:	ccd58593          	addi	a1,a1,-819 # ffffffffcccccccd <end+0xcac7c55>
ffffffffc020076c:	02059613          	slli	a2,a1,0x20
ffffffffc0200770:	40f98733          	sub	a4,s3,a5
ffffffffc0200774:	962e                	add	a2,a2,a1
ffffffffc0200776:	870d                	srai	a4,a4,0x3
ffffffffc0200778:	02c70733          	mul	a4,a4,a2
ffffffffc020077c:	972a                	add	a4,a4,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc020077e:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200780:	40d77963          	bgeu	a4,a3,ffffffffc0200b92 <best_fit_check+0x50a>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200784:	40fa07b3          	sub	a5,s4,a5
ffffffffc0200788:	878d                	srai	a5,a5,0x3
ffffffffc020078a:	02c787b3          	mul	a5,a5,a2
ffffffffc020078e:	97aa                	add	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200790:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200792:	3ed7f063          	bgeu	a5,a3,ffffffffc0200b72 <best_fit_check+0x4ea>
    assert(alloc_page() == NULL);
ffffffffc0200796:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200798:	00093c03          	ld	s8,0(s2)
ffffffffc020079c:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc02007a0:	00005b17          	auipc	s6,0x5
ffffffffc02007a4:	888b2b03          	lw	s6,-1912(s6) # ffffffffc0205028 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc02007a8:	01293023          	sd	s2,0(s2)
ffffffffc02007ac:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc02007b0:	00005797          	auipc	a5,0x5
ffffffffc02007b4:	8607ac23          	sw	zero,-1928(a5) # ffffffffc0205028 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc02007b8:	041000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc02007bc:	38051b63          	bnez	a0,ffffffffc0200b52 <best_fit_check+0x4ca>
    free_page(p0);
ffffffffc02007c0:	8556                	mv	a0,s5
ffffffffc02007c2:	4585                	li	a1,1
ffffffffc02007c4:	041000ef          	jal	ffffffffc0201004 <free_pages>
    free_page(p1);
ffffffffc02007c8:	854e                	mv	a0,s3
ffffffffc02007ca:	4585                	li	a1,1
ffffffffc02007cc:	039000ef          	jal	ffffffffc0201004 <free_pages>
    free_page(p2);
ffffffffc02007d0:	8552                	mv	a0,s4
ffffffffc02007d2:	4585                	li	a1,1
ffffffffc02007d4:	031000ef          	jal	ffffffffc0201004 <free_pages>
    assert(nr_free == 3);
ffffffffc02007d8:	00005717          	auipc	a4,0x5
ffffffffc02007dc:	85072703          	lw	a4,-1968(a4) # ffffffffc0205028 <free_area+0x10>
ffffffffc02007e0:	478d                	li	a5,3
ffffffffc02007e2:	34f71863          	bne	a4,a5,ffffffffc0200b32 <best_fit_check+0x4aa>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02007e6:	4505                	li	a0,1
ffffffffc02007e8:	011000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc02007ec:	89aa                	mv	s3,a0
ffffffffc02007ee:	32050263          	beqz	a0,ffffffffc0200b12 <best_fit_check+0x48a>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02007f2:	4505                	li	a0,1
ffffffffc02007f4:	005000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc02007f8:	8aaa                	mv	s5,a0
ffffffffc02007fa:	2e050c63          	beqz	a0,ffffffffc0200af2 <best_fit_check+0x46a>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02007fe:	4505                	li	a0,1
ffffffffc0200800:	7f8000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc0200804:	8a2a                	mv	s4,a0
ffffffffc0200806:	2c050663          	beqz	a0,ffffffffc0200ad2 <best_fit_check+0x44a>
    assert(alloc_page() == NULL);
ffffffffc020080a:	4505                	li	a0,1
ffffffffc020080c:	7ec000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc0200810:	2a051163          	bnez	a0,ffffffffc0200ab2 <best_fit_check+0x42a>
    free_page(p0);
ffffffffc0200814:	4585                	li	a1,1
ffffffffc0200816:	854e                	mv	a0,s3
ffffffffc0200818:	7ec000ef          	jal	ffffffffc0201004 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc020081c:	00893783          	ld	a5,8(s2)
ffffffffc0200820:	19278963          	beq	a5,s2,ffffffffc02009b2 <best_fit_check+0x32a>
    assert((p = alloc_page()) == p0);
ffffffffc0200824:	4505                	li	a0,1
ffffffffc0200826:	7d2000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc020082a:	8caa                	mv	s9,a0
ffffffffc020082c:	54a99363          	bne	s3,a0,ffffffffc0200d72 <best_fit_check+0x6ea>
    assert(alloc_page() == NULL);
ffffffffc0200830:	4505                	li	a0,1
ffffffffc0200832:	7c6000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc0200836:	50051e63          	bnez	a0,ffffffffc0200d52 <best_fit_check+0x6ca>
    assert(nr_free == 0);
ffffffffc020083a:	00004797          	auipc	a5,0x4
ffffffffc020083e:	7ee7a783          	lw	a5,2030(a5) # ffffffffc0205028 <free_area+0x10>
ffffffffc0200842:	4e079863          	bnez	a5,ffffffffc0200d32 <best_fit_check+0x6aa>
    free_page(p);
ffffffffc0200846:	8566                	mv	a0,s9
ffffffffc0200848:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc020084a:	01893023          	sd	s8,0(s2)
ffffffffc020084e:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc0200852:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc0200856:	7ae000ef          	jal	ffffffffc0201004 <free_pages>
    free_page(p1);
ffffffffc020085a:	8556                	mv	a0,s5
ffffffffc020085c:	4585                	li	a1,1
ffffffffc020085e:	7a6000ef          	jal	ffffffffc0201004 <free_pages>
    free_page(p2);
ffffffffc0200862:	8552                	mv	a0,s4
ffffffffc0200864:	4585                	li	a1,1
ffffffffc0200866:	79e000ef          	jal	ffffffffc0201004 <free_pages>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc020086a:	4515                	li	a0,5
ffffffffc020086c:	78c000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc0200870:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200872:	4a050063          	beqz	a0,ffffffffc0200d12 <best_fit_check+0x68a>
    assert(!PageProperty(p0));
ffffffffc0200876:	651c                	ld	a5,8(a0)
ffffffffc0200878:	8b89                	andi	a5,a5,2
ffffffffc020087a:	46079c63          	bnez	a5,ffffffffc0200cf2 <best_fit_check+0x66a>
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc020087e:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200880:	00093b83          	ld	s7,0(s2)
ffffffffc0200884:	00893b03          	ld	s6,8(s2)
ffffffffc0200888:	01293023          	sd	s2,0(s2)
ffffffffc020088c:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc0200890:	768000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc0200894:	42051f63          	bnez	a0,ffffffffc0200cd2 <best_fit_check+0x64a>
    #endif
    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    // * - - * -
    free_pages(p0 + 1, 2);
ffffffffc0200898:	4589                	li	a1,2
ffffffffc020089a:	02898513          	addi	a0,s3,40
    unsigned int nr_free_store = nr_free;
ffffffffc020089e:	00004c17          	auipc	s8,0x4
ffffffffc02008a2:	78ac2c03          	lw	s8,1930(s8) # ffffffffc0205028 <free_area+0x10>
    free_pages(p0 + 4, 1);
ffffffffc02008a6:	0a098a93          	addi	s5,s3,160
    nr_free = 0;
ffffffffc02008aa:	00004797          	auipc	a5,0x4
ffffffffc02008ae:	7607af23          	sw	zero,1918(a5) # ffffffffc0205028 <free_area+0x10>
    free_pages(p0 + 1, 2);
ffffffffc02008b2:	752000ef          	jal	ffffffffc0201004 <free_pages>
    free_pages(p0 + 4, 1);
ffffffffc02008b6:	8556                	mv	a0,s5
ffffffffc02008b8:	4585                	li	a1,1
ffffffffc02008ba:	74a000ef          	jal	ffffffffc0201004 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02008be:	4511                	li	a0,4
ffffffffc02008c0:	738000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc02008c4:	3e051763          	bnez	a0,ffffffffc0200cb2 <best_fit_check+0x62a>
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc02008c8:	0309b783          	ld	a5,48(s3)
ffffffffc02008cc:	8b89                	andi	a5,a5,2
ffffffffc02008ce:	3c078263          	beqz	a5,ffffffffc0200c92 <best_fit_check+0x60a>
ffffffffc02008d2:	0389ac83          	lw	s9,56(s3)
ffffffffc02008d6:	4789                	li	a5,2
ffffffffc02008d8:	3afc9d63          	bne	s9,a5,ffffffffc0200c92 <best_fit_check+0x60a>
    // * - - * *
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc02008dc:	4505                	li	a0,1
ffffffffc02008de:	71a000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc02008e2:	8a2a                	mv	s4,a0
ffffffffc02008e4:	38050763          	beqz	a0,ffffffffc0200c72 <best_fit_check+0x5ea>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc02008e8:	8566                	mv	a0,s9
ffffffffc02008ea:	70e000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc02008ee:	36050263          	beqz	a0,ffffffffc0200c52 <best_fit_check+0x5ca>
    assert(p0 + 4 == p1);
ffffffffc02008f2:	354a9063          	bne	s5,s4,ffffffffc0200c32 <best_fit_check+0x5aa>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    p2 = p0 + 1;
    free_pages(p0, 5);
ffffffffc02008f6:	854e                	mv	a0,s3
ffffffffc02008f8:	4595                	li	a1,5
ffffffffc02008fa:	70a000ef          	jal	ffffffffc0201004 <free_pages>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02008fe:	4515                	li	a0,5
ffffffffc0200900:	6f8000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc0200904:	89aa                	mv	s3,a0
ffffffffc0200906:	30050663          	beqz	a0,ffffffffc0200c12 <best_fit_check+0x58a>
    assert(alloc_page() == NULL);
ffffffffc020090a:	4505                	li	a0,1
ffffffffc020090c:	6ec000ef          	jal	ffffffffc0200ff8 <alloc_pages>
ffffffffc0200910:	2e051163          	bnez	a0,ffffffffc0200bf2 <best_fit_check+0x56a>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    assert(nr_free == 0);
ffffffffc0200914:	00004797          	auipc	a5,0x4
ffffffffc0200918:	7147a783          	lw	a5,1812(a5) # ffffffffc0205028 <free_area+0x10>
ffffffffc020091c:	2a079b63          	bnez	a5,ffffffffc0200bd2 <best_fit_check+0x54a>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200920:	854e                	mv	a0,s3
ffffffffc0200922:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc0200924:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc0200928:	01793023          	sd	s7,0(s2)
ffffffffc020092c:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc0200930:	6d4000ef          	jal	ffffffffc0201004 <free_pages>
    return listelm->next;
ffffffffc0200934:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200938:	01278963          	beq	a5,s2,ffffffffc020094a <best_fit_check+0x2c2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc020093c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200940:	679c                	ld	a5,8(a5)
ffffffffc0200942:	34fd                	addiw	s1,s1,-1
ffffffffc0200944:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200946:	ff279be3          	bne	a5,s2,ffffffffc020093c <best_fit_check+0x2b4>
    }
    assert(count == 0);
ffffffffc020094a:	26049463          	bnez	s1,ffffffffc0200bb2 <best_fit_check+0x52a>
    assert(total == 0);
ffffffffc020094e:	e075                	bnez	s0,ffffffffc0200a32 <best_fit_check+0x3aa>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
}
ffffffffc0200950:	60e6                	ld	ra,88(sp)
ffffffffc0200952:	6446                	ld	s0,80(sp)
ffffffffc0200954:	64a6                	ld	s1,72(sp)
ffffffffc0200956:	6906                	ld	s2,64(sp)
ffffffffc0200958:	79e2                	ld	s3,56(sp)
ffffffffc020095a:	7a42                	ld	s4,48(sp)
ffffffffc020095c:	7aa2                	ld	s5,40(sp)
ffffffffc020095e:	7b02                	ld	s6,32(sp)
ffffffffc0200960:	6be2                	ld	s7,24(sp)
ffffffffc0200962:	6c42                	ld	s8,16(sp)
ffffffffc0200964:	6ca2                	ld	s9,8(sp)
ffffffffc0200966:	6125                	addi	sp,sp,96
ffffffffc0200968:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc020096a:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc020096c:	4401                	li	s0,0
ffffffffc020096e:	4481                	li	s1,0
ffffffffc0200970:	bbb9                	j	ffffffffc02006ce <best_fit_check+0x46>
        assert(PageProperty(p));
ffffffffc0200972:	00001697          	auipc	a3,0x1
ffffffffc0200976:	f8668693          	addi	a3,a3,-122 # ffffffffc02018f8 <etext+0x280>
ffffffffc020097a:	00001617          	auipc	a2,0x1
ffffffffc020097e:	f4e60613          	addi	a2,a2,-178 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200982:	11800593          	li	a1,280
ffffffffc0200986:	00001517          	auipc	a0,0x1
ffffffffc020098a:	f5a50513          	addi	a0,a0,-166 # ffffffffc02018e0 <etext+0x268>
ffffffffc020098e:	83bff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200992:	00001697          	auipc	a3,0x1
ffffffffc0200996:	01e68693          	addi	a3,a3,30 # ffffffffc02019b0 <etext+0x338>
ffffffffc020099a:	00001617          	auipc	a2,0x1
ffffffffc020099e:	f2e60613          	addi	a2,a2,-210 # ffffffffc02018c8 <etext+0x250>
ffffffffc02009a2:	0e500593          	li	a1,229
ffffffffc02009a6:	00001517          	auipc	a0,0x1
ffffffffc02009aa:	f3a50513          	addi	a0,a0,-198 # ffffffffc02018e0 <etext+0x268>
ffffffffc02009ae:	81bff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(!list_empty(&free_list));
ffffffffc02009b2:	00001697          	auipc	a3,0x1
ffffffffc02009b6:	0c668693          	addi	a3,a3,198 # ffffffffc0201a78 <etext+0x400>
ffffffffc02009ba:	00001617          	auipc	a2,0x1
ffffffffc02009be:	f0e60613          	addi	a2,a2,-242 # ffffffffc02018c8 <etext+0x250>
ffffffffc02009c2:	10000593          	li	a1,256
ffffffffc02009c6:	00001517          	auipc	a0,0x1
ffffffffc02009ca:	f1a50513          	addi	a0,a0,-230 # ffffffffc02018e0 <etext+0x268>
ffffffffc02009ce:	ffaff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02009d2:	00001697          	auipc	a3,0x1
ffffffffc02009d6:	01e68693          	addi	a3,a3,30 # ffffffffc02019f0 <etext+0x378>
ffffffffc02009da:	00001617          	auipc	a2,0x1
ffffffffc02009de:	eee60613          	addi	a2,a2,-274 # ffffffffc02018c8 <etext+0x250>
ffffffffc02009e2:	0e700593          	li	a1,231
ffffffffc02009e6:	00001517          	auipc	a0,0x1
ffffffffc02009ea:	efa50513          	addi	a0,a0,-262 # ffffffffc02018e0 <etext+0x268>
ffffffffc02009ee:	fdaff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02009f2:	00001697          	auipc	a3,0x1
ffffffffc02009f6:	f9668693          	addi	a3,a3,-106 # ffffffffc0201988 <etext+0x310>
ffffffffc02009fa:	00001617          	auipc	a2,0x1
ffffffffc02009fe:	ece60613          	addi	a2,a2,-306 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200a02:	0e400593          	li	a1,228
ffffffffc0200a06:	00001517          	auipc	a0,0x1
ffffffffc0200a0a:	eda50513          	addi	a0,a0,-294 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200a0e:	fbaff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200a12:	00001697          	auipc	a3,0x1
ffffffffc0200a16:	f5668693          	addi	a3,a3,-170 # ffffffffc0201968 <etext+0x2f0>
ffffffffc0200a1a:	00001617          	auipc	a2,0x1
ffffffffc0200a1e:	eae60613          	addi	a2,a2,-338 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200a22:	0e200593          	li	a1,226
ffffffffc0200a26:	00001517          	auipc	a0,0x1
ffffffffc0200a2a:	eba50513          	addi	a0,a0,-326 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200a2e:	f9aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(total == 0);
ffffffffc0200a32:	00001697          	auipc	a3,0x1
ffffffffc0200a36:	17668693          	addi	a3,a3,374 # ffffffffc0201ba8 <etext+0x530>
ffffffffc0200a3a:	00001617          	auipc	a2,0x1
ffffffffc0200a3e:	e8e60613          	addi	a2,a2,-370 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200a42:	15a00593          	li	a1,346
ffffffffc0200a46:	00001517          	auipc	a0,0x1
ffffffffc0200a4a:	e9a50513          	addi	a0,a0,-358 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200a4e:	f7aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(total == nr_free_pages());
ffffffffc0200a52:	00001697          	auipc	a3,0x1
ffffffffc0200a56:	eb668693          	addi	a3,a3,-330 # ffffffffc0201908 <etext+0x290>
ffffffffc0200a5a:	00001617          	auipc	a2,0x1
ffffffffc0200a5e:	e6e60613          	addi	a2,a2,-402 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200a62:	11b00593          	li	a1,283
ffffffffc0200a66:	00001517          	auipc	a0,0x1
ffffffffc0200a6a:	e7a50513          	addi	a0,a0,-390 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200a6e:	f5aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200a72:	00001697          	auipc	a3,0x1
ffffffffc0200a76:	ed668693          	addi	a3,a3,-298 # ffffffffc0201948 <etext+0x2d0>
ffffffffc0200a7a:	00001617          	auipc	a2,0x1
ffffffffc0200a7e:	e4e60613          	addi	a2,a2,-434 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200a82:	0e100593          	li	a1,225
ffffffffc0200a86:	00001517          	auipc	a0,0x1
ffffffffc0200a8a:	e5a50513          	addi	a0,a0,-422 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200a8e:	f3aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200a92:	00001697          	auipc	a3,0x1
ffffffffc0200a96:	e9668693          	addi	a3,a3,-362 # ffffffffc0201928 <etext+0x2b0>
ffffffffc0200a9a:	00001617          	auipc	a2,0x1
ffffffffc0200a9e:	e2e60613          	addi	a2,a2,-466 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200aa2:	0e000593          	li	a1,224
ffffffffc0200aa6:	00001517          	auipc	a0,0x1
ffffffffc0200aaa:	e3a50513          	addi	a0,a0,-454 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200aae:	f1aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200ab2:	00001697          	auipc	a3,0x1
ffffffffc0200ab6:	f9e68693          	addi	a3,a3,-98 # ffffffffc0201a50 <etext+0x3d8>
ffffffffc0200aba:	00001617          	auipc	a2,0x1
ffffffffc0200abe:	e0e60613          	addi	a2,a2,-498 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200ac2:	0fd00593          	li	a1,253
ffffffffc0200ac6:	00001517          	auipc	a0,0x1
ffffffffc0200aca:	e1a50513          	addi	a0,a0,-486 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200ace:	efaff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200ad2:	00001697          	auipc	a3,0x1
ffffffffc0200ad6:	e9668693          	addi	a3,a3,-362 # ffffffffc0201968 <etext+0x2f0>
ffffffffc0200ada:	00001617          	auipc	a2,0x1
ffffffffc0200ade:	dee60613          	addi	a2,a2,-530 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200ae2:	0fb00593          	li	a1,251
ffffffffc0200ae6:	00001517          	auipc	a0,0x1
ffffffffc0200aea:	dfa50513          	addi	a0,a0,-518 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200aee:	edaff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200af2:	00001697          	auipc	a3,0x1
ffffffffc0200af6:	e5668693          	addi	a3,a3,-426 # ffffffffc0201948 <etext+0x2d0>
ffffffffc0200afa:	00001617          	auipc	a2,0x1
ffffffffc0200afe:	dce60613          	addi	a2,a2,-562 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200b02:	0fa00593          	li	a1,250
ffffffffc0200b06:	00001517          	auipc	a0,0x1
ffffffffc0200b0a:	dda50513          	addi	a0,a0,-550 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200b0e:	ebaff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200b12:	00001697          	auipc	a3,0x1
ffffffffc0200b16:	e1668693          	addi	a3,a3,-490 # ffffffffc0201928 <etext+0x2b0>
ffffffffc0200b1a:	00001617          	auipc	a2,0x1
ffffffffc0200b1e:	dae60613          	addi	a2,a2,-594 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200b22:	0f900593          	li	a1,249
ffffffffc0200b26:	00001517          	auipc	a0,0x1
ffffffffc0200b2a:	dba50513          	addi	a0,a0,-582 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200b2e:	e9aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(nr_free == 3);
ffffffffc0200b32:	00001697          	auipc	a3,0x1
ffffffffc0200b36:	f3668693          	addi	a3,a3,-202 # ffffffffc0201a68 <etext+0x3f0>
ffffffffc0200b3a:	00001617          	auipc	a2,0x1
ffffffffc0200b3e:	d8e60613          	addi	a2,a2,-626 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200b42:	0f700593          	li	a1,247
ffffffffc0200b46:	00001517          	auipc	a0,0x1
ffffffffc0200b4a:	d9a50513          	addi	a0,a0,-614 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200b4e:	e7aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200b52:	00001697          	auipc	a3,0x1
ffffffffc0200b56:	efe68693          	addi	a3,a3,-258 # ffffffffc0201a50 <etext+0x3d8>
ffffffffc0200b5a:	00001617          	auipc	a2,0x1
ffffffffc0200b5e:	d6e60613          	addi	a2,a2,-658 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200b62:	0f200593          	li	a1,242
ffffffffc0200b66:	00001517          	auipc	a0,0x1
ffffffffc0200b6a:	d7a50513          	addi	a0,a0,-646 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200b6e:	e5aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200b72:	00001697          	auipc	a3,0x1
ffffffffc0200b76:	ebe68693          	addi	a3,a3,-322 # ffffffffc0201a30 <etext+0x3b8>
ffffffffc0200b7a:	00001617          	auipc	a2,0x1
ffffffffc0200b7e:	d4e60613          	addi	a2,a2,-690 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200b82:	0e900593          	li	a1,233
ffffffffc0200b86:	00001517          	auipc	a0,0x1
ffffffffc0200b8a:	d5a50513          	addi	a0,a0,-678 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200b8e:	e3aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200b92:	00001697          	auipc	a3,0x1
ffffffffc0200b96:	e7e68693          	addi	a3,a3,-386 # ffffffffc0201a10 <etext+0x398>
ffffffffc0200b9a:	00001617          	auipc	a2,0x1
ffffffffc0200b9e:	d2e60613          	addi	a2,a2,-722 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200ba2:	0e800593          	li	a1,232
ffffffffc0200ba6:	00001517          	auipc	a0,0x1
ffffffffc0200baa:	d3a50513          	addi	a0,a0,-710 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200bae:	e1aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(count == 0);
ffffffffc0200bb2:	00001697          	auipc	a3,0x1
ffffffffc0200bb6:	fe668693          	addi	a3,a3,-26 # ffffffffc0201b98 <etext+0x520>
ffffffffc0200bba:	00001617          	auipc	a2,0x1
ffffffffc0200bbe:	d0e60613          	addi	a2,a2,-754 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200bc2:	15900593          	li	a1,345
ffffffffc0200bc6:	00001517          	auipc	a0,0x1
ffffffffc0200bca:	d1a50513          	addi	a0,a0,-742 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200bce:	dfaff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(nr_free == 0);
ffffffffc0200bd2:	00001697          	auipc	a3,0x1
ffffffffc0200bd6:	ede68693          	addi	a3,a3,-290 # ffffffffc0201ab0 <etext+0x438>
ffffffffc0200bda:	00001617          	auipc	a2,0x1
ffffffffc0200bde:	cee60613          	addi	a2,a2,-786 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200be2:	14e00593          	li	a1,334
ffffffffc0200be6:	00001517          	auipc	a0,0x1
ffffffffc0200bea:	cfa50513          	addi	a0,a0,-774 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200bee:	ddaff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200bf2:	00001697          	auipc	a3,0x1
ffffffffc0200bf6:	e5e68693          	addi	a3,a3,-418 # ffffffffc0201a50 <etext+0x3d8>
ffffffffc0200bfa:	00001617          	auipc	a2,0x1
ffffffffc0200bfe:	cce60613          	addi	a2,a2,-818 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200c02:	14800593          	li	a1,328
ffffffffc0200c06:	00001517          	auipc	a0,0x1
ffffffffc0200c0a:	cda50513          	addi	a0,a0,-806 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200c0e:	dbaff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200c12:	00001697          	auipc	a3,0x1
ffffffffc0200c16:	f6668693          	addi	a3,a3,-154 # ffffffffc0201b78 <etext+0x500>
ffffffffc0200c1a:	00001617          	auipc	a2,0x1
ffffffffc0200c1e:	cae60613          	addi	a2,a2,-850 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200c22:	14700593          	li	a1,327
ffffffffc0200c26:	00001517          	auipc	a0,0x1
ffffffffc0200c2a:	cba50513          	addi	a0,a0,-838 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200c2e:	d9aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(p0 + 4 == p1);
ffffffffc0200c32:	00001697          	auipc	a3,0x1
ffffffffc0200c36:	f3668693          	addi	a3,a3,-202 # ffffffffc0201b68 <etext+0x4f0>
ffffffffc0200c3a:	00001617          	auipc	a2,0x1
ffffffffc0200c3e:	c8e60613          	addi	a2,a2,-882 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200c42:	13f00593          	li	a1,319
ffffffffc0200c46:	00001517          	auipc	a0,0x1
ffffffffc0200c4a:	c9a50513          	addi	a0,a0,-870 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200c4e:	d7aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0200c52:	00001697          	auipc	a3,0x1
ffffffffc0200c56:	efe68693          	addi	a3,a3,-258 # ffffffffc0201b50 <etext+0x4d8>
ffffffffc0200c5a:	00001617          	auipc	a2,0x1
ffffffffc0200c5e:	c6e60613          	addi	a2,a2,-914 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200c62:	13e00593          	li	a1,318
ffffffffc0200c66:	00001517          	auipc	a0,0x1
ffffffffc0200c6a:	c7a50513          	addi	a0,a0,-902 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200c6e:	d5aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0200c72:	00001697          	auipc	a3,0x1
ffffffffc0200c76:	ebe68693          	addi	a3,a3,-322 # ffffffffc0201b30 <etext+0x4b8>
ffffffffc0200c7a:	00001617          	auipc	a2,0x1
ffffffffc0200c7e:	c4e60613          	addi	a2,a2,-946 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200c82:	13d00593          	li	a1,317
ffffffffc0200c86:	00001517          	auipc	a0,0x1
ffffffffc0200c8a:	c5a50513          	addi	a0,a0,-934 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200c8e:	d3aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0200c92:	00001697          	auipc	a3,0x1
ffffffffc0200c96:	e6e68693          	addi	a3,a3,-402 # ffffffffc0201b00 <etext+0x488>
ffffffffc0200c9a:	00001617          	auipc	a2,0x1
ffffffffc0200c9e:	c2e60613          	addi	a2,a2,-978 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200ca2:	13b00593          	li	a1,315
ffffffffc0200ca6:	00001517          	auipc	a0,0x1
ffffffffc0200caa:	c3a50513          	addi	a0,a0,-966 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200cae:	d1aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0200cb2:	00001697          	auipc	a3,0x1
ffffffffc0200cb6:	e3668693          	addi	a3,a3,-458 # ffffffffc0201ae8 <etext+0x470>
ffffffffc0200cba:	00001617          	auipc	a2,0x1
ffffffffc0200cbe:	c0e60613          	addi	a2,a2,-1010 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200cc2:	13a00593          	li	a1,314
ffffffffc0200cc6:	00001517          	auipc	a0,0x1
ffffffffc0200cca:	c1a50513          	addi	a0,a0,-998 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200cce:	cfaff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200cd2:	00001697          	auipc	a3,0x1
ffffffffc0200cd6:	d7e68693          	addi	a3,a3,-642 # ffffffffc0201a50 <etext+0x3d8>
ffffffffc0200cda:	00001617          	auipc	a2,0x1
ffffffffc0200cde:	bee60613          	addi	a2,a2,-1042 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200ce2:	12e00593          	li	a1,302
ffffffffc0200ce6:	00001517          	auipc	a0,0x1
ffffffffc0200cea:	bfa50513          	addi	a0,a0,-1030 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200cee:	cdaff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(!PageProperty(p0));
ffffffffc0200cf2:	00001697          	auipc	a3,0x1
ffffffffc0200cf6:	dde68693          	addi	a3,a3,-546 # ffffffffc0201ad0 <etext+0x458>
ffffffffc0200cfa:	00001617          	auipc	a2,0x1
ffffffffc0200cfe:	bce60613          	addi	a2,a2,-1074 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200d02:	12500593          	li	a1,293
ffffffffc0200d06:	00001517          	auipc	a0,0x1
ffffffffc0200d0a:	bda50513          	addi	a0,a0,-1062 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200d0e:	cbaff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(p0 != NULL);
ffffffffc0200d12:	00001697          	auipc	a3,0x1
ffffffffc0200d16:	dae68693          	addi	a3,a3,-594 # ffffffffc0201ac0 <etext+0x448>
ffffffffc0200d1a:	00001617          	auipc	a2,0x1
ffffffffc0200d1e:	bae60613          	addi	a2,a2,-1106 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200d22:	12400593          	li	a1,292
ffffffffc0200d26:	00001517          	auipc	a0,0x1
ffffffffc0200d2a:	bba50513          	addi	a0,a0,-1094 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200d2e:	c9aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(nr_free == 0);
ffffffffc0200d32:	00001697          	auipc	a3,0x1
ffffffffc0200d36:	d7e68693          	addi	a3,a3,-642 # ffffffffc0201ab0 <etext+0x438>
ffffffffc0200d3a:	00001617          	auipc	a2,0x1
ffffffffc0200d3e:	b8e60613          	addi	a2,a2,-1138 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200d42:	10600593          	li	a1,262
ffffffffc0200d46:	00001517          	auipc	a0,0x1
ffffffffc0200d4a:	b9a50513          	addi	a0,a0,-1126 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200d4e:	c7aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200d52:	00001697          	auipc	a3,0x1
ffffffffc0200d56:	cfe68693          	addi	a3,a3,-770 # ffffffffc0201a50 <etext+0x3d8>
ffffffffc0200d5a:	00001617          	auipc	a2,0x1
ffffffffc0200d5e:	b6e60613          	addi	a2,a2,-1170 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200d62:	10400593          	li	a1,260
ffffffffc0200d66:	00001517          	auipc	a0,0x1
ffffffffc0200d6a:	b7a50513          	addi	a0,a0,-1158 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200d6e:	c5aff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0200d72:	00001697          	auipc	a3,0x1
ffffffffc0200d76:	d1e68693          	addi	a3,a3,-738 # ffffffffc0201a90 <etext+0x418>
ffffffffc0200d7a:	00001617          	auipc	a2,0x1
ffffffffc0200d7e:	b4e60613          	addi	a2,a2,-1202 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200d82:	10300593          	li	a1,259
ffffffffc0200d86:	00001517          	auipc	a0,0x1
ffffffffc0200d8a:	b5a50513          	addi	a0,a0,-1190 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200d8e:	c3aff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200d92 <best_fit_free_pages>:
best_fit_free_pages(struct Page *base, size_t n) {
ffffffffc0200d92:	1141                	addi	sp,sp,-16
ffffffffc0200d94:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200d96:	14058463          	beqz	a1,ffffffffc0200ede <best_fit_free_pages+0x14c>
    for (; p != base + n; p ++) {
ffffffffc0200d9a:	00259713          	slli	a4,a1,0x2
ffffffffc0200d9e:	972e                	add	a4,a4,a1
ffffffffc0200da0:	070e                	slli	a4,a4,0x3
ffffffffc0200da2:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0200da6:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0200da8:	cf09                	beqz	a4,ffffffffc0200dc2 <best_fit_free_pages+0x30>
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200daa:	6798                	ld	a4,8(a5)
ffffffffc0200dac:	8b0d                	andi	a4,a4,3
ffffffffc0200dae:	10071863          	bnez	a4,ffffffffc0200ebe <best_fit_free_pages+0x12c>
        p->flags = 0;
ffffffffc0200db2:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200db6:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0200dba:	02878793          	addi	a5,a5,40
ffffffffc0200dbe:	fed796e3          	bne	a5,a3,ffffffffc0200daa <best_fit_free_pages+0x18>
    SetPageProperty(base);
ffffffffc0200dc2:	00853883          	ld	a7,8(a0)
    nr_free += n;
ffffffffc0200dc6:	00004717          	auipc	a4,0x4
ffffffffc0200dca:	26272703          	lw	a4,610(a4) # ffffffffc0205028 <free_area+0x10>
ffffffffc0200dce:	00004617          	auipc	a2,0x4
ffffffffc0200dd2:	24a60613          	addi	a2,a2,586 # ffffffffc0205018 <free_area>
    return list->next == list;
ffffffffc0200dd6:	661c                	ld	a5,8(a2)
    SetPageProperty(base);
ffffffffc0200dd8:	0028e693          	ori	a3,a7,2
    base->property = n;
ffffffffc0200ddc:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0200dde:	e514                	sd	a3,8(a0)
    nr_free += n;
ffffffffc0200de0:	9f2d                	addw	a4,a4,a1
ffffffffc0200de2:	ca18                	sw	a4,16(a2)
        list_entry_t *le = &free_list;
ffffffffc0200de4:	8832                	mv	a6,a2
    if (list_empty(&free_list)) {
ffffffffc0200de6:	00c79463          	bne	a5,a2,ffffffffc0200dee <best_fit_free_pages+0x5c>
ffffffffc0200dea:	a871                	j	ffffffffc0200e86 <best_fit_free_pages+0xf4>
ffffffffc0200dec:	87ba                	mv	a5,a4
            struct Page *page = le2page(next, page_link);
ffffffffc0200dee:	fe878693          	addi	a3,a5,-24
            if (base < page) {
ffffffffc0200df2:	06d56b63          	bltu	a0,a3,ffffffffc0200e68 <best_fit_free_pages+0xd6>
    return listelm->next;
ffffffffc0200df6:	6798                	ld	a4,8(a5)
ffffffffc0200df8:	883e                	mv	a6,a5
        while ((next = list_next(le)) != &free_list) {
ffffffffc0200dfa:	fec719e3          	bne	a4,a2,ffffffffc0200dec <best_fit_free_pages+0x5a>
        list_add_after(le, &(base->page_link));
ffffffffc0200dfe:	01850813          	addi	a6,a0,24
    prev->next = next->prev = elm;
ffffffffc0200e02:	0107b423          	sd	a6,8(a5)
ffffffffc0200e06:	01063023          	sd	a6,0(a2)
    elm->next = next;
ffffffffc0200e0a:	f110                	sd	a2,32(a0)
    elm->prev = prev;
ffffffffc0200e0c:	ed1c                	sd	a5,24(a0)
    if (le != &free_list) {
ffffffffc0200e0e:	02c78e63          	beq	a5,a2,ffffffffc0200e4a <best_fit_free_pages+0xb8>
        if (p + p->property == base) {
ffffffffc0200e12:	ff87ae03          	lw	t3,-8(a5)
ffffffffc0200e16:	020e1313          	slli	t1,t3,0x20
ffffffffc0200e1a:	02035313          	srli	t1,t1,0x20
ffffffffc0200e1e:	00231813          	slli	a6,t1,0x2
ffffffffc0200e22:	981a                	add	a6,a6,t1
ffffffffc0200e24:	080e                	slli	a6,a6,0x3
ffffffffc0200e26:	9836                	add	a6,a6,a3
ffffffffc0200e28:	03050463          	beq	a0,a6,ffffffffc0200e50 <best_fit_free_pages+0xbe>
    if (le != &free_list) {
ffffffffc0200e2c:	00c70f63          	beq	a4,a2,ffffffffc0200e4a <best_fit_free_pages+0xb8>
        if (base + base->property == p) {
ffffffffc0200e30:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc0200e32:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc0200e36:	02059613          	slli	a2,a1,0x20
ffffffffc0200e3a:	9201                	srli	a2,a2,0x20
ffffffffc0200e3c:	00261793          	slli	a5,a2,0x2
ffffffffc0200e40:	97b2                	add	a5,a5,a2
ffffffffc0200e42:	078e                	slli	a5,a5,0x3
ffffffffc0200e44:	97aa                	add	a5,a5,a0
ffffffffc0200e46:	04f68963          	beq	a3,a5,ffffffffc0200e98 <best_fit_free_pages+0x106>
}
ffffffffc0200e4a:	60a2                	ld	ra,8(sp)
ffffffffc0200e4c:	0141                	addi	sp,sp,16
ffffffffc0200e4e:	8082                	ret
            p->property += base->property;
ffffffffc0200e50:	01c585bb          	addw	a1,a1,t3
ffffffffc0200e54:	feb7ac23          	sw	a1,-8(a5)
            ClearPageProperty(base);
ffffffffc0200e58:	ffd8f893          	andi	a7,a7,-3
ffffffffc0200e5c:	01153423          	sd	a7,8(a0)
    prev->next = next;
ffffffffc0200e60:	e798                	sd	a4,8(a5)
    next->prev = prev;
ffffffffc0200e62:	e31c                	sd	a5,0(a4)
            base = p;
ffffffffc0200e64:	8536                	mv	a0,a3
ffffffffc0200e66:	b7d9                	j	ffffffffc0200e2c <best_fit_free_pages+0x9a>
        list_add_after(le, &(base->page_link));
ffffffffc0200e68:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0200e6c:	e398                	sd	a4,0(a5)
ffffffffc0200e6e:	00e83423          	sd	a4,8(a6)
    elm->next = next;
ffffffffc0200e72:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200e74:	01053c23          	sd	a6,24(a0)
    if (le != &free_list) {
ffffffffc0200e78:	873e                	mv	a4,a5
ffffffffc0200e7a:	fe880693          	addi	a3,a6,-24
ffffffffc0200e7e:	87c2                	mv	a5,a6
ffffffffc0200e80:	f8c819e3          	bne	a6,a2,ffffffffc0200e12 <best_fit_free_pages+0x80>
ffffffffc0200e84:	b765                	j	ffffffffc0200e2c <best_fit_free_pages+0x9a>
}
ffffffffc0200e86:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0200e88:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0200e8c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200e8e:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0200e90:	e398                	sd	a4,0(a5)
ffffffffc0200e92:	e798                	sd	a4,8(a5)
}
ffffffffc0200e94:	0141                	addi	sp,sp,16
ffffffffc0200e96:	8082                	ret
            base->property += p->property;
ffffffffc0200e98:	ff872683          	lw	a3,-8(a4)
            ClearPageProperty(p);
ffffffffc0200e9c:	ff073783          	ld	a5,-16(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200ea0:	00073803          	ld	a6,0(a4)
ffffffffc0200ea4:	6710                	ld	a2,8(a4)
            base->property += p->property;
ffffffffc0200ea6:	9ead                	addw	a3,a3,a1
ffffffffc0200ea8:	c914                	sw	a3,16(a0)
            ClearPageProperty(p);
ffffffffc0200eaa:	9bf5                	andi	a5,a5,-3
ffffffffc0200eac:	fef73823          	sd	a5,-16(a4)
}
ffffffffc0200eb0:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0200eb2:	00c83423          	sd	a2,8(a6)
    next->prev = prev;
ffffffffc0200eb6:	01063023          	sd	a6,0(a2)
ffffffffc0200eba:	0141                	addi	sp,sp,16
ffffffffc0200ebc:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200ebe:	00001697          	auipc	a3,0x1
ffffffffc0200ec2:	cfa68693          	addi	a3,a3,-774 # ffffffffc0201bb8 <etext+0x540>
ffffffffc0200ec6:	00001617          	auipc	a2,0x1
ffffffffc0200eca:	a0260613          	addi	a2,a2,-1534 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200ece:	09f00593          	li	a1,159
ffffffffc0200ed2:	00001517          	auipc	a0,0x1
ffffffffc0200ed6:	a0e50513          	addi	a0,a0,-1522 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200eda:	aeeff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(n > 0);
ffffffffc0200ede:	00001697          	auipc	a3,0x1
ffffffffc0200ee2:	9e268693          	addi	a3,a3,-1566 # ffffffffc02018c0 <etext+0x248>
ffffffffc0200ee6:	00001617          	auipc	a2,0x1
ffffffffc0200eea:	9e260613          	addi	a2,a2,-1566 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200eee:	09c00593          	li	a1,156
ffffffffc0200ef2:	00001517          	auipc	a0,0x1
ffffffffc0200ef6:	9ee50513          	addi	a0,a0,-1554 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200efa:	aceff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200efe <best_fit_init_memmap>:
best_fit_init_memmap(struct Page *base, size_t n) {
ffffffffc0200efe:	1141                	addi	sp,sp,-16
ffffffffc0200f00:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200f02:	c9f9                	beqz	a1,ffffffffc0200fd8 <best_fit_init_memmap+0xda>
    for (; p != base + n; p ++) {
ffffffffc0200f04:	00259713          	slli	a4,a1,0x2
ffffffffc0200f08:	972e                	add	a4,a4,a1
ffffffffc0200f0a:	070e                	slli	a4,a4,0x3
ffffffffc0200f0c:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0200f10:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0200f12:	cf11                	beqz	a4,ffffffffc0200f2e <best_fit_init_memmap+0x30>
        assert(PageReserved(p));
ffffffffc0200f14:	6798                	ld	a4,8(a5)
ffffffffc0200f16:	8b05                	andi	a4,a4,1
ffffffffc0200f18:	c345                	beqz	a4,ffffffffc0200fb8 <best_fit_init_memmap+0xba>
        p->flags = 0;
ffffffffc0200f1a:	0007b423          	sd	zero,8(a5)
ffffffffc0200f1e:	0007a023          	sw	zero,0(a5)
        p->property = 0;
ffffffffc0200f22:	0007a823          	sw	zero,16(a5)
    for (; p != base + n; p ++) {
ffffffffc0200f26:	02878793          	addi	a5,a5,40
ffffffffc0200f2a:	fed795e3          	bne	a5,a3,ffffffffc0200f14 <best_fit_init_memmap+0x16>
    SetPageProperty(base);
ffffffffc0200f2e:	651c                	ld	a5,8(a0)
    nr_free += n;
ffffffffc0200f30:	00004717          	auipc	a4,0x4
ffffffffc0200f34:	0f872703          	lw	a4,248(a4) # ffffffffc0205028 <free_area+0x10>
ffffffffc0200f38:	00004697          	auipc	a3,0x4
ffffffffc0200f3c:	0e068693          	addi	a3,a3,224 # ffffffffc0205018 <free_area>
    base->property = n;
ffffffffc0200f40:	2581                	sext.w	a1,a1
    SetPageProperty(base);
ffffffffc0200f42:	0027e613          	ori	a2,a5,2
    return list->next == list;
ffffffffc0200f46:	669c                	ld	a5,8(a3)
    base->property = n;
ffffffffc0200f48:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0200f4a:	e510                	sd	a2,8(a0)
    nr_free += n;
ffffffffc0200f4c:	9f2d                	addw	a4,a4,a1
ffffffffc0200f4e:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0200f50:	04d78763          	beq	a5,a3,ffffffffc0200f9e <best_fit_init_memmap+0xa0>
            if (base->property < page->property) {
ffffffffc0200f54:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200f58:	4801                	li	a6,0
ffffffffc0200f5a:	01850613          	addi	a2,a0,24
ffffffffc0200f5e:	00e5ea63          	bltu	a1,a4,ffffffffc0200f72 <best_fit_init_memmap+0x74>
    return listelm->next;
ffffffffc0200f62:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0200f64:	02d70363          	beq	a4,a3,ffffffffc0200f8a <best_fit_init_memmap+0x8c>
    struct Page *p = base;
ffffffffc0200f68:	87ba                	mv	a5,a4
            if (base->property < page->property) {
ffffffffc0200f6a:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200f6e:	fee5fae3          	bgeu	a1,a4,ffffffffc0200f62 <best_fit_init_memmap+0x64>
ffffffffc0200f72:	00080463          	beqz	a6,ffffffffc0200f7a <best_fit_init_memmap+0x7c>
ffffffffc0200f76:	0116b023          	sd	a7,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0200f7a:	6398                	ld	a4,0(a5)
}
ffffffffc0200f7c:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0200f7e:	e390                	sd	a2,0(a5)
ffffffffc0200f80:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc0200f82:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0200f84:	f11c                	sd	a5,32(a0)
ffffffffc0200f86:	0141                	addi	sp,sp,16
ffffffffc0200f88:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0200f8a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0200f8c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0200f8e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0200f90:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0200f92:	88b2                	mv	a7,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0200f94:	00d70e63          	beq	a4,a3,ffffffffc0200fb0 <best_fit_init_memmap+0xb2>
ffffffffc0200f98:	4805                	li	a6,1
    struct Page *p = base;
ffffffffc0200f9a:	87ba                	mv	a5,a4
ffffffffc0200f9c:	b7f9                	j	ffffffffc0200f6a <best_fit_init_memmap+0x6c>
}
ffffffffc0200f9e:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0200fa0:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0200fa4:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200fa6:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0200fa8:	e398                	sd	a4,0(a5)
ffffffffc0200faa:	e798                	sd	a4,8(a5)
}
ffffffffc0200fac:	0141                	addi	sp,sp,16
ffffffffc0200fae:	8082                	ret
ffffffffc0200fb0:	60a2                	ld	ra,8(sp)
ffffffffc0200fb2:	e290                	sd	a2,0(a3)
ffffffffc0200fb4:	0141                	addi	sp,sp,16
ffffffffc0200fb6:	8082                	ret
        assert(PageReserved(p));
ffffffffc0200fb8:	00001697          	auipc	a3,0x1
ffffffffc0200fbc:	c2868693          	addi	a3,a3,-984 # ffffffffc0201be0 <etext+0x568>
ffffffffc0200fc0:	00001617          	auipc	a2,0x1
ffffffffc0200fc4:	90860613          	addi	a2,a2,-1784 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200fc8:	04a00593          	li	a1,74
ffffffffc0200fcc:	00001517          	auipc	a0,0x1
ffffffffc0200fd0:	91450513          	addi	a0,a0,-1772 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200fd4:	9f4ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(n > 0);
ffffffffc0200fd8:	00001697          	auipc	a3,0x1
ffffffffc0200fdc:	8e868693          	addi	a3,a3,-1816 # ffffffffc02018c0 <etext+0x248>
ffffffffc0200fe0:	00001617          	auipc	a2,0x1
ffffffffc0200fe4:	8e860613          	addi	a2,a2,-1816 # ffffffffc02018c8 <etext+0x250>
ffffffffc0200fe8:	04700593          	li	a1,71
ffffffffc0200fec:	00001517          	auipc	a0,0x1
ffffffffc0200ff0:	8f450513          	addi	a0,a0,-1804 # ffffffffc02018e0 <etext+0x268>
ffffffffc0200ff4:	9d4ff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200ff8 <alloc_pages>:
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
    return pmm_manager->alloc_pages(n);
ffffffffc0200ff8:	00004797          	auipc	a5,0x4
ffffffffc0200ffc:	0507b783          	ld	a5,80(a5) # ffffffffc0205048 <pmm_manager>
ffffffffc0201000:	6f9c                	ld	a5,24(a5)
ffffffffc0201002:	8782                	jr	a5

ffffffffc0201004 <free_pages>:
}

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    pmm_manager->free_pages(base, n);
ffffffffc0201004:	00004797          	auipc	a5,0x4
ffffffffc0201008:	0447b783          	ld	a5,68(a5) # ffffffffc0205048 <pmm_manager>
ffffffffc020100c:	739c                	ld	a5,32(a5)
ffffffffc020100e:	8782                	jr	a5

ffffffffc0201010 <nr_free_pages>:
}

// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t nr_free_pages(void) {
    return pmm_manager->nr_free_pages();
ffffffffc0201010:	00004797          	auipc	a5,0x4
ffffffffc0201014:	0387b783          	ld	a5,56(a5) # ffffffffc0205048 <pmm_manager>
ffffffffc0201018:	779c                	ld	a5,40(a5)
ffffffffc020101a:	8782                	jr	a5

ffffffffc020101c <pmm_init>:
    pmm_manager = &best_fit_pmm_manager;
ffffffffc020101c:	00001797          	auipc	a5,0x1
ffffffffc0201020:	e0c78793          	addi	a5,a5,-500 # ffffffffc0201e28 <best_fit_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201024:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc0201026:	7139                	addi	sp,sp,-64
ffffffffc0201028:	fc06                	sd	ra,56(sp)
ffffffffc020102a:	f822                	sd	s0,48(sp)
ffffffffc020102c:	f426                	sd	s1,40(sp)
ffffffffc020102e:	ec4e                	sd	s3,24(sp)
ffffffffc0201030:	f04a                	sd	s2,32(sp)
    pmm_manager = &best_fit_pmm_manager;
ffffffffc0201032:	00004417          	auipc	s0,0x4
ffffffffc0201036:	01640413          	addi	s0,s0,22 # ffffffffc0205048 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020103a:	00001517          	auipc	a0,0x1
ffffffffc020103e:	bce50513          	addi	a0,a0,-1074 # ffffffffc0201c08 <etext+0x590>
    pmm_manager = &best_fit_pmm_manager;
ffffffffc0201042:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201044:	904ff0ef          	jal	ffffffffc0200148 <cprintf>
    pmm_manager->init();
ffffffffc0201048:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020104a:	00004497          	auipc	s1,0x4
ffffffffc020104e:	01648493          	addi	s1,s1,22 # ffffffffc0205060 <va_pa_offset>
    pmm_manager->init();
ffffffffc0201052:	679c                	ld	a5,8(a5)
ffffffffc0201054:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0201056:	57f5                	li	a5,-3
ffffffffc0201058:	07fa                	slli	a5,a5,0x1e
ffffffffc020105a:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc020105c:	cfeff0ef          	jal	ffffffffc020055a <get_memory_base>
ffffffffc0201060:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0201062:	d02ff0ef          	jal	ffffffffc0200564 <get_memory_size>
    if (mem_size == 0) {
ffffffffc0201066:	14050c63          	beqz	a0,ffffffffc02011be <pmm_init+0x1a2>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc020106a:	00a98933          	add	s2,s3,a0
ffffffffc020106e:	e42a                	sd	a0,8(sp)
    cprintf("physcial memory map:\n");
ffffffffc0201070:	00001517          	auipc	a0,0x1
ffffffffc0201074:	be050513          	addi	a0,a0,-1056 # ffffffffc0201c50 <etext+0x5d8>
ffffffffc0201078:	8d0ff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc020107c:	65a2                	ld	a1,8(sp)
ffffffffc020107e:	864e                	mv	a2,s3
ffffffffc0201080:	fff90693          	addi	a3,s2,-1
ffffffffc0201084:	00001517          	auipc	a0,0x1
ffffffffc0201088:	be450513          	addi	a0,a0,-1052 # ffffffffc0201c68 <etext+0x5f0>
ffffffffc020108c:	8bcff0ef          	jal	ffffffffc0200148 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc0201090:	c80007b7          	lui	a5,0xc8000
ffffffffc0201094:	85ca                	mv	a1,s2
ffffffffc0201096:	0d27e263          	bltu	a5,s2,ffffffffc020115a <pmm_init+0x13e>
ffffffffc020109a:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020109c:	00005697          	auipc	a3,0x5
ffffffffc02010a0:	fdb68693          	addi	a3,a3,-37 # ffffffffc0206077 <end+0xfff>
ffffffffc02010a4:	8efd                	and	a3,a3,a5
    npage = maxpa / PGSIZE;
ffffffffc02010a6:	81b1                	srli	a1,a1,0xc
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02010a8:	fff80837          	lui	a6,0xfff80
    npage = maxpa / PGSIZE;
ffffffffc02010ac:	00004797          	auipc	a5,0x4
ffffffffc02010b0:	fab7be23          	sd	a1,-68(a5) # ffffffffc0205068 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02010b4:	00004797          	auipc	a5,0x4
ffffffffc02010b8:	fad7be23          	sd	a3,-68(a5) # ffffffffc0205070 <pages>
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02010bc:	982e                	add	a6,a6,a1
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02010be:	88b6                	mv	a7,a3
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02010c0:	02080963          	beqz	a6,ffffffffc02010f2 <pmm_init+0xd6>
ffffffffc02010c4:	00259613          	slli	a2,a1,0x2
ffffffffc02010c8:	962e                	add	a2,a2,a1
ffffffffc02010ca:	fec007b7          	lui	a5,0xfec00
ffffffffc02010ce:	97b6                	add	a5,a5,a3
ffffffffc02010d0:	060e                	slli	a2,a2,0x3
ffffffffc02010d2:	963e                	add	a2,a2,a5
ffffffffc02010d4:	87b6                	mv	a5,a3
        SetPageReserved(pages + i);
ffffffffc02010d6:	6798                	ld	a4,8(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02010d8:	02878793          	addi	a5,a5,40 # fffffffffec00028 <end+0x3e9fafb0>
        SetPageReserved(pages + i);
ffffffffc02010dc:	00176713          	ori	a4,a4,1
ffffffffc02010e0:	fee7b023          	sd	a4,-32(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02010e4:	fec799e3          	bne	a5,a2,ffffffffc02010d6 <pmm_init+0xba>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02010e8:	00281793          	slli	a5,a6,0x2
ffffffffc02010ec:	97c2                	add	a5,a5,a6
ffffffffc02010ee:	078e                	slli	a5,a5,0x3
ffffffffc02010f0:	96be                	add	a3,a3,a5
ffffffffc02010f2:	c02007b7          	lui	a5,0xc0200
ffffffffc02010f6:	0af6e863          	bltu	a3,a5,ffffffffc02011a6 <pmm_init+0x18a>
ffffffffc02010fa:	6098                	ld	a4,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc02010fc:	77fd                	lui	a5,0xfffff
ffffffffc02010fe:	00f97933          	and	s2,s2,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201102:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0201104:	0526ed63          	bltu	a3,s2,ffffffffc020115e <pmm_init+0x142>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0201108:	601c                	ld	a5,0(s0)
ffffffffc020110a:	7b9c                	ld	a5,48(a5)
ffffffffc020110c:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc020110e:	00001517          	auipc	a0,0x1
ffffffffc0201112:	be250513          	addi	a0,a0,-1054 # ffffffffc0201cf0 <etext+0x678>
ffffffffc0201116:	832ff0ef          	jal	ffffffffc0200148 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc020111a:	00003597          	auipc	a1,0x3
ffffffffc020111e:	ee658593          	addi	a1,a1,-282 # ffffffffc0204000 <boot_page_table_sv39>
ffffffffc0201122:	00004797          	auipc	a5,0x4
ffffffffc0201126:	f2b7bb23          	sd	a1,-202(a5) # ffffffffc0205058 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc020112a:	c02007b7          	lui	a5,0xc0200
ffffffffc020112e:	0af5e463          	bltu	a1,a5,ffffffffc02011d6 <pmm_init+0x1ba>
ffffffffc0201132:	609c                	ld	a5,0(s1)
}
ffffffffc0201134:	7442                	ld	s0,48(sp)
ffffffffc0201136:	70e2                	ld	ra,56(sp)
ffffffffc0201138:	74a2                	ld	s1,40(sp)
ffffffffc020113a:	7902                	ld	s2,32(sp)
ffffffffc020113c:	69e2                	ld	s3,24(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc020113e:	40f586b3          	sub	a3,a1,a5
ffffffffc0201142:	00004797          	auipc	a5,0x4
ffffffffc0201146:	f0d7b723          	sd	a3,-242(a5) # ffffffffc0205050 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc020114a:	00001517          	auipc	a0,0x1
ffffffffc020114e:	bc650513          	addi	a0,a0,-1082 # ffffffffc0201d10 <etext+0x698>
ffffffffc0201152:	8636                	mv	a2,a3
}
ffffffffc0201154:	6121                	addi	sp,sp,64
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201156:	ff3fe06f          	j	ffffffffc0200148 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc020115a:	85be                	mv	a1,a5
ffffffffc020115c:	bf3d                	j	ffffffffc020109a <pmm_init+0x7e>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc020115e:	6705                	lui	a4,0x1
ffffffffc0201160:	177d                	addi	a4,a4,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc0201162:	96ba                	add	a3,a3,a4
ffffffffc0201164:	8efd                	and	a3,a3,a5
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0201166:	00c6d793          	srli	a5,a3,0xc
ffffffffc020116a:	02b7f263          	bgeu	a5,a1,ffffffffc020118e <pmm_init+0x172>
    pmm_manager->init_memmap(base, n);
ffffffffc020116e:	6018                	ld	a4,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0201170:	fff80637          	lui	a2,0xfff80
ffffffffc0201174:	97b2                	add	a5,a5,a2
ffffffffc0201176:	00279513          	slli	a0,a5,0x2
ffffffffc020117a:	953e                	add	a0,a0,a5
ffffffffc020117c:	6b1c                	ld	a5,16(a4)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020117e:	40d90933          	sub	s2,s2,a3
ffffffffc0201182:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0201184:	00c95593          	srli	a1,s2,0xc
ffffffffc0201188:	9546                	add	a0,a0,a7
ffffffffc020118a:	9782                	jalr	a5
}
ffffffffc020118c:	bfb5                	j	ffffffffc0201108 <pmm_init+0xec>
        panic("pa2page called with invalid pa");
ffffffffc020118e:	00001617          	auipc	a2,0x1
ffffffffc0201192:	b3260613          	addi	a2,a2,-1230 # ffffffffc0201cc0 <etext+0x648>
ffffffffc0201196:	06a00593          	li	a1,106
ffffffffc020119a:	00001517          	auipc	a0,0x1
ffffffffc020119e:	b4650513          	addi	a0,a0,-1210 # ffffffffc0201ce0 <etext+0x668>
ffffffffc02011a2:	826ff0ef          	jal	ffffffffc02001c8 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02011a6:	00001617          	auipc	a2,0x1
ffffffffc02011aa:	af260613          	addi	a2,a2,-1294 # ffffffffc0201c98 <etext+0x620>
ffffffffc02011ae:	05e00593          	li	a1,94
ffffffffc02011b2:	00001517          	auipc	a0,0x1
ffffffffc02011b6:	a8e50513          	addi	a0,a0,-1394 # ffffffffc0201c40 <etext+0x5c8>
ffffffffc02011ba:	80eff0ef          	jal	ffffffffc02001c8 <__panic>
        panic("DTB memory info not available");
ffffffffc02011be:	00001617          	auipc	a2,0x1
ffffffffc02011c2:	a6260613          	addi	a2,a2,-1438 # ffffffffc0201c20 <etext+0x5a8>
ffffffffc02011c6:	04600593          	li	a1,70
ffffffffc02011ca:	00001517          	auipc	a0,0x1
ffffffffc02011ce:	a7650513          	addi	a0,a0,-1418 # ffffffffc0201c40 <etext+0x5c8>
ffffffffc02011d2:	ff7fe0ef          	jal	ffffffffc02001c8 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc02011d6:	86ae                	mv	a3,a1
ffffffffc02011d8:	00001617          	auipc	a2,0x1
ffffffffc02011dc:	ac060613          	addi	a2,a2,-1344 # ffffffffc0201c98 <etext+0x620>
ffffffffc02011e0:	07900593          	li	a1,121
ffffffffc02011e4:	00001517          	auipc	a0,0x1
ffffffffc02011e8:	a5c50513          	addi	a0,a0,-1444 # ffffffffc0201c40 <etext+0x5c8>
ffffffffc02011ec:	fddfe0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc02011f0 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02011f0:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02011f2:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02011f6:	f022                	sd	s0,32(sp)
ffffffffc02011f8:	ec26                	sd	s1,24(sp)
ffffffffc02011fa:	e84a                	sd	s2,16(sp)
ffffffffc02011fc:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02011fe:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201202:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201204:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0201208:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020120c:	84aa                	mv	s1,a0
ffffffffc020120e:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc0201210:	03067d63          	bgeu	a2,a6,ffffffffc020124a <printnum+0x5a>
ffffffffc0201214:	e44e                	sd	s3,8(sp)
ffffffffc0201216:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0201218:	4785                	li	a5,1
ffffffffc020121a:	00e7d763          	bge	a5,a4,ffffffffc0201228 <printnum+0x38>
            putch(padc, putdat);
ffffffffc020121e:	85ca                	mv	a1,s2
ffffffffc0201220:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc0201222:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201224:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201226:	fc65                	bnez	s0,ffffffffc020121e <printnum+0x2e>
ffffffffc0201228:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020122a:	00001797          	auipc	a5,0x1
ffffffffc020122e:	b2678793          	addi	a5,a5,-1242 # ffffffffc0201d50 <etext+0x6d8>
ffffffffc0201232:	97d2                	add	a5,a5,s4
}
ffffffffc0201234:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201236:	0007c503          	lbu	a0,0(a5)
}
ffffffffc020123a:	70a2                	ld	ra,40(sp)
ffffffffc020123c:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020123e:	85ca                	mv	a1,s2
ffffffffc0201240:	87a6                	mv	a5,s1
}
ffffffffc0201242:	6942                	ld	s2,16(sp)
ffffffffc0201244:	64e2                	ld	s1,24(sp)
ffffffffc0201246:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201248:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc020124a:	03065633          	divu	a2,a2,a6
ffffffffc020124e:	8722                	mv	a4,s0
ffffffffc0201250:	fa1ff0ef          	jal	ffffffffc02011f0 <printnum>
ffffffffc0201254:	bfd9                	j	ffffffffc020122a <printnum+0x3a>

ffffffffc0201256 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201256:	7119                	addi	sp,sp,-128
ffffffffc0201258:	f4a6                	sd	s1,104(sp)
ffffffffc020125a:	f0ca                	sd	s2,96(sp)
ffffffffc020125c:	ecce                	sd	s3,88(sp)
ffffffffc020125e:	e8d2                	sd	s4,80(sp)
ffffffffc0201260:	e4d6                	sd	s5,72(sp)
ffffffffc0201262:	e0da                	sd	s6,64(sp)
ffffffffc0201264:	f862                	sd	s8,48(sp)
ffffffffc0201266:	fc86                	sd	ra,120(sp)
ffffffffc0201268:	f8a2                	sd	s0,112(sp)
ffffffffc020126a:	fc5e                	sd	s7,56(sp)
ffffffffc020126c:	f466                	sd	s9,40(sp)
ffffffffc020126e:	f06a                	sd	s10,32(sp)
ffffffffc0201270:	ec6e                	sd	s11,24(sp)
ffffffffc0201272:	84aa                	mv	s1,a0
ffffffffc0201274:	8c32                	mv	s8,a2
ffffffffc0201276:	8a36                	mv	s4,a3
ffffffffc0201278:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020127a:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020127e:	05500b13          	li	s6,85
ffffffffc0201282:	00001a97          	auipc	s5,0x1
ffffffffc0201286:	bdea8a93          	addi	s5,s5,-1058 # ffffffffc0201e60 <best_fit_pmm_manager+0x38>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020128a:	000c4503          	lbu	a0,0(s8)
ffffffffc020128e:	001c0413          	addi	s0,s8,1
ffffffffc0201292:	01350a63          	beq	a0,s3,ffffffffc02012a6 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0201296:	cd0d                	beqz	a0,ffffffffc02012d0 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0201298:	85ca                	mv	a1,s2
ffffffffc020129a:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020129c:	00044503          	lbu	a0,0(s0)
ffffffffc02012a0:	0405                	addi	s0,s0,1
ffffffffc02012a2:	ff351ae3          	bne	a0,s3,ffffffffc0201296 <vprintfmt+0x40>
        width = precision = -1;
ffffffffc02012a6:	5cfd                	li	s9,-1
ffffffffc02012a8:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc02012aa:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc02012ae:	4b81                	li	s7,0
ffffffffc02012b0:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02012b2:	00044683          	lbu	a3,0(s0)
ffffffffc02012b6:	00140c13          	addi	s8,s0,1
ffffffffc02012ba:	fdd6859b          	addiw	a1,a3,-35
ffffffffc02012be:	0ff5f593          	zext.b	a1,a1
ffffffffc02012c2:	02bb6663          	bltu	s6,a1,ffffffffc02012ee <vprintfmt+0x98>
ffffffffc02012c6:	058a                	slli	a1,a1,0x2
ffffffffc02012c8:	95d6                	add	a1,a1,s5
ffffffffc02012ca:	4198                	lw	a4,0(a1)
ffffffffc02012cc:	9756                	add	a4,a4,s5
ffffffffc02012ce:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02012d0:	70e6                	ld	ra,120(sp)
ffffffffc02012d2:	7446                	ld	s0,112(sp)
ffffffffc02012d4:	74a6                	ld	s1,104(sp)
ffffffffc02012d6:	7906                	ld	s2,96(sp)
ffffffffc02012d8:	69e6                	ld	s3,88(sp)
ffffffffc02012da:	6a46                	ld	s4,80(sp)
ffffffffc02012dc:	6aa6                	ld	s5,72(sp)
ffffffffc02012de:	6b06                	ld	s6,64(sp)
ffffffffc02012e0:	7be2                	ld	s7,56(sp)
ffffffffc02012e2:	7c42                	ld	s8,48(sp)
ffffffffc02012e4:	7ca2                	ld	s9,40(sp)
ffffffffc02012e6:	7d02                	ld	s10,32(sp)
ffffffffc02012e8:	6de2                	ld	s11,24(sp)
ffffffffc02012ea:	6109                	addi	sp,sp,128
ffffffffc02012ec:	8082                	ret
            putch('%', putdat);
ffffffffc02012ee:	85ca                	mv	a1,s2
ffffffffc02012f0:	02500513          	li	a0,37
ffffffffc02012f4:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02012f6:	fff44783          	lbu	a5,-1(s0)
ffffffffc02012fa:	02500713          	li	a4,37
ffffffffc02012fe:	8c22                	mv	s8,s0
ffffffffc0201300:	f8e785e3          	beq	a5,a4,ffffffffc020128a <vprintfmt+0x34>
ffffffffc0201304:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0201308:	1c7d                	addi	s8,s8,-1
ffffffffc020130a:	fee79de3          	bne	a5,a4,ffffffffc0201304 <vprintfmt+0xae>
ffffffffc020130e:	bfb5                	j	ffffffffc020128a <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0201310:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0201314:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc0201316:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc020131a:	fd06071b          	addiw	a4,a2,-48
ffffffffc020131e:	24e56a63          	bltu	a0,a4,ffffffffc0201572 <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0201322:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201324:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc0201326:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc020132a:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc020132e:	0197073b          	addw	a4,a4,s9
ffffffffc0201332:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201336:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201338:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc020133c:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc020133e:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0201342:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0201346:	feb570e3          	bgeu	a0,a1,ffffffffc0201326 <vprintfmt+0xd0>
            if (width < 0)
ffffffffc020134a:	f60d54e3          	bgez	s10,ffffffffc02012b2 <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc020134e:	8d66                	mv	s10,s9
ffffffffc0201350:	5cfd                	li	s9,-1
ffffffffc0201352:	b785                	j	ffffffffc02012b2 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201354:	8db6                	mv	s11,a3
ffffffffc0201356:	8462                	mv	s0,s8
ffffffffc0201358:	bfa9                	j	ffffffffc02012b2 <vprintfmt+0x5c>
ffffffffc020135a:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc020135c:	4b85                	li	s7,1
            goto reswitch;
ffffffffc020135e:	bf91                	j	ffffffffc02012b2 <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0201360:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201362:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201366:	00f74463          	blt	a4,a5,ffffffffc020136e <vprintfmt+0x118>
    else if (lflag) {
ffffffffc020136a:	1a078763          	beqz	a5,ffffffffc0201518 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc020136e:	000a3603          	ld	a2,0(s4)
ffffffffc0201372:	46c1                	li	a3,16
ffffffffc0201374:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201376:	000d879b          	sext.w	a5,s11
ffffffffc020137a:	876a                	mv	a4,s10
ffffffffc020137c:	85ca                	mv	a1,s2
ffffffffc020137e:	8526                	mv	a0,s1
ffffffffc0201380:	e71ff0ef          	jal	ffffffffc02011f0 <printnum>
            break;
ffffffffc0201384:	b719                	j	ffffffffc020128a <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0201386:	000a2503          	lw	a0,0(s4)
ffffffffc020138a:	85ca                	mv	a1,s2
ffffffffc020138c:	0a21                	addi	s4,s4,8
ffffffffc020138e:	9482                	jalr	s1
            break;
ffffffffc0201390:	bded                	j	ffffffffc020128a <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0201392:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201394:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201398:	00f74463          	blt	a4,a5,ffffffffc02013a0 <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc020139c:	16078963          	beqz	a5,ffffffffc020150e <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc02013a0:	000a3603          	ld	a2,0(s4)
ffffffffc02013a4:	46a9                	li	a3,10
ffffffffc02013a6:	8a2e                	mv	s4,a1
ffffffffc02013a8:	b7f9                	j	ffffffffc0201376 <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc02013aa:	85ca                	mv	a1,s2
ffffffffc02013ac:	03000513          	li	a0,48
ffffffffc02013b0:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc02013b2:	85ca                	mv	a1,s2
ffffffffc02013b4:	07800513          	li	a0,120
ffffffffc02013b8:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02013ba:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc02013be:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02013c0:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02013c2:	bf55                	j	ffffffffc0201376 <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc02013c4:	85ca                	mv	a1,s2
ffffffffc02013c6:	02500513          	li	a0,37
ffffffffc02013ca:	9482                	jalr	s1
            break;
ffffffffc02013cc:	bd7d                	j	ffffffffc020128a <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc02013ce:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02013d2:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc02013d4:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc02013d6:	bf95                	j	ffffffffc020134a <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc02013d8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02013da:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02013de:	00f74463          	blt	a4,a5,ffffffffc02013e6 <vprintfmt+0x190>
    else if (lflag) {
ffffffffc02013e2:	12078163          	beqz	a5,ffffffffc0201504 <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc02013e6:	000a3603          	ld	a2,0(s4)
ffffffffc02013ea:	46a1                	li	a3,8
ffffffffc02013ec:	8a2e                	mv	s4,a1
ffffffffc02013ee:	b761                	j	ffffffffc0201376 <vprintfmt+0x120>
            if (width < 0)
ffffffffc02013f0:	876a                	mv	a4,s10
ffffffffc02013f2:	000d5363          	bgez	s10,ffffffffc02013f8 <vprintfmt+0x1a2>
ffffffffc02013f6:	4701                	li	a4,0
ffffffffc02013f8:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02013fc:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc02013fe:	bd55                	j	ffffffffc02012b2 <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc0201400:	000d841b          	sext.w	s0,s11
ffffffffc0201404:	fd340793          	addi	a5,s0,-45
ffffffffc0201408:	00f037b3          	snez	a5,a5
ffffffffc020140c:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201410:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc0201414:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201416:	008a0793          	addi	a5,s4,8
ffffffffc020141a:	e43e                	sd	a5,8(sp)
ffffffffc020141c:	100d8c63          	beqz	s11,ffffffffc0201534 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0201420:	12071363          	bnez	a4,ffffffffc0201546 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201424:	000dc783          	lbu	a5,0(s11)
ffffffffc0201428:	0007851b          	sext.w	a0,a5
ffffffffc020142c:	c78d                	beqz	a5,ffffffffc0201456 <vprintfmt+0x200>
ffffffffc020142e:	0d85                	addi	s11,s11,1
ffffffffc0201430:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201432:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201436:	000cc563          	bltz	s9,ffffffffc0201440 <vprintfmt+0x1ea>
ffffffffc020143a:	3cfd                	addiw	s9,s9,-1
ffffffffc020143c:	008c8d63          	beq	s9,s0,ffffffffc0201456 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201440:	020b9663          	bnez	s7,ffffffffc020146c <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc0201444:	85ca                	mv	a1,s2
ffffffffc0201446:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201448:	000dc783          	lbu	a5,0(s11)
ffffffffc020144c:	0d85                	addi	s11,s11,1
ffffffffc020144e:	3d7d                	addiw	s10,s10,-1
ffffffffc0201450:	0007851b          	sext.w	a0,a5
ffffffffc0201454:	f3ed                	bnez	a5,ffffffffc0201436 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc0201456:	01a05963          	blez	s10,ffffffffc0201468 <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc020145a:	85ca                	mv	a1,s2
ffffffffc020145c:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0201460:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc0201462:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc0201464:	fe0d1be3          	bnez	s10,ffffffffc020145a <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201468:	6a22                	ld	s4,8(sp)
ffffffffc020146a:	b505                	j	ffffffffc020128a <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020146c:	3781                	addiw	a5,a5,-32
ffffffffc020146e:	fcfa7be3          	bgeu	s4,a5,ffffffffc0201444 <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc0201472:	03f00513          	li	a0,63
ffffffffc0201476:	85ca                	mv	a1,s2
ffffffffc0201478:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020147a:	000dc783          	lbu	a5,0(s11)
ffffffffc020147e:	0d85                	addi	s11,s11,1
ffffffffc0201480:	3d7d                	addiw	s10,s10,-1
ffffffffc0201482:	0007851b          	sext.w	a0,a5
ffffffffc0201486:	dbe1                	beqz	a5,ffffffffc0201456 <vprintfmt+0x200>
ffffffffc0201488:	fa0cd9e3          	bgez	s9,ffffffffc020143a <vprintfmt+0x1e4>
ffffffffc020148c:	b7c5                	j	ffffffffc020146c <vprintfmt+0x216>
            if (err < 0) {
ffffffffc020148e:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201492:	4619                	li	a2,6
            err = va_arg(ap, int);
ffffffffc0201494:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201496:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020149a:	8fb9                	xor	a5,a5,a4
ffffffffc020149c:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02014a0:	02d64563          	blt	a2,a3,ffffffffc02014ca <vprintfmt+0x274>
ffffffffc02014a4:	00001797          	auipc	a5,0x1
ffffffffc02014a8:	b1478793          	addi	a5,a5,-1260 # ffffffffc0201fb8 <error_string>
ffffffffc02014ac:	00369713          	slli	a4,a3,0x3
ffffffffc02014b0:	97ba                	add	a5,a5,a4
ffffffffc02014b2:	639c                	ld	a5,0(a5)
ffffffffc02014b4:	cb99                	beqz	a5,ffffffffc02014ca <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc02014b6:	86be                	mv	a3,a5
ffffffffc02014b8:	00001617          	auipc	a2,0x1
ffffffffc02014bc:	8c860613          	addi	a2,a2,-1848 # ffffffffc0201d80 <etext+0x708>
ffffffffc02014c0:	85ca                	mv	a1,s2
ffffffffc02014c2:	8526                	mv	a0,s1
ffffffffc02014c4:	0d8000ef          	jal	ffffffffc020159c <printfmt>
ffffffffc02014c8:	b3c9                	j	ffffffffc020128a <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02014ca:	00001617          	auipc	a2,0x1
ffffffffc02014ce:	8a660613          	addi	a2,a2,-1882 # ffffffffc0201d70 <etext+0x6f8>
ffffffffc02014d2:	85ca                	mv	a1,s2
ffffffffc02014d4:	8526                	mv	a0,s1
ffffffffc02014d6:	0c6000ef          	jal	ffffffffc020159c <printfmt>
ffffffffc02014da:	bb45                	j	ffffffffc020128a <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc02014dc:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02014de:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc02014e2:	00f74363          	blt	a4,a5,ffffffffc02014e8 <vprintfmt+0x292>
    else if (lflag) {
ffffffffc02014e6:	cf81                	beqz	a5,ffffffffc02014fe <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc02014e8:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02014ec:	02044b63          	bltz	s0,ffffffffc0201522 <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc02014f0:	8622                	mv	a2,s0
ffffffffc02014f2:	8a5e                	mv	s4,s7
ffffffffc02014f4:	46a9                	li	a3,10
ffffffffc02014f6:	b541                	j	ffffffffc0201376 <vprintfmt+0x120>
            lflag ++;
ffffffffc02014f8:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02014fa:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc02014fc:	bb5d                	j	ffffffffc02012b2 <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc02014fe:	000a2403          	lw	s0,0(s4)
ffffffffc0201502:	b7ed                	j	ffffffffc02014ec <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc0201504:	000a6603          	lwu	a2,0(s4)
ffffffffc0201508:	46a1                	li	a3,8
ffffffffc020150a:	8a2e                	mv	s4,a1
ffffffffc020150c:	b5ad                	j	ffffffffc0201376 <vprintfmt+0x120>
ffffffffc020150e:	000a6603          	lwu	a2,0(s4)
ffffffffc0201512:	46a9                	li	a3,10
ffffffffc0201514:	8a2e                	mv	s4,a1
ffffffffc0201516:	b585                	j	ffffffffc0201376 <vprintfmt+0x120>
ffffffffc0201518:	000a6603          	lwu	a2,0(s4)
ffffffffc020151c:	46c1                	li	a3,16
ffffffffc020151e:	8a2e                	mv	s4,a1
ffffffffc0201520:	bd99                	j	ffffffffc0201376 <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc0201522:	85ca                	mv	a1,s2
ffffffffc0201524:	02d00513          	li	a0,45
ffffffffc0201528:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc020152a:	40800633          	neg	a2,s0
ffffffffc020152e:	8a5e                	mv	s4,s7
ffffffffc0201530:	46a9                	li	a3,10
ffffffffc0201532:	b591                	j	ffffffffc0201376 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc0201534:	e329                	bnez	a4,ffffffffc0201576 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201536:	02800793          	li	a5,40
ffffffffc020153a:	853e                	mv	a0,a5
ffffffffc020153c:	00001d97          	auipc	s11,0x1
ffffffffc0201540:	82dd8d93          	addi	s11,s11,-2003 # ffffffffc0201d69 <etext+0x6f1>
ffffffffc0201544:	b5f5                	j	ffffffffc0201430 <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201546:	85e6                	mv	a1,s9
ffffffffc0201548:	856e                	mv	a0,s11
ffffffffc020154a:	0a4000ef          	jal	ffffffffc02015ee <strnlen>
ffffffffc020154e:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0201552:	01a05863          	blez	s10,ffffffffc0201562 <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc0201556:	85ca                	mv	a1,s2
ffffffffc0201558:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020155a:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc020155c:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020155e:	fe0d1ce3          	bnez	s10,ffffffffc0201556 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201562:	000dc783          	lbu	a5,0(s11)
ffffffffc0201566:	0007851b          	sext.w	a0,a5
ffffffffc020156a:	ec0792e3          	bnez	a5,ffffffffc020142e <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020156e:	6a22                	ld	s4,8(sp)
ffffffffc0201570:	bb29                	j	ffffffffc020128a <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201572:	8462                	mv	s0,s8
ffffffffc0201574:	bbd9                	j	ffffffffc020134a <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201576:	85e6                	mv	a1,s9
ffffffffc0201578:	00000517          	auipc	a0,0x0
ffffffffc020157c:	7f050513          	addi	a0,a0,2032 # ffffffffc0201d68 <etext+0x6f0>
ffffffffc0201580:	06e000ef          	jal	ffffffffc02015ee <strnlen>
ffffffffc0201584:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201588:	02800793          	li	a5,40
                p = "(null)";
ffffffffc020158c:	00000d97          	auipc	s11,0x0
ffffffffc0201590:	7dcd8d93          	addi	s11,s11,2012 # ffffffffc0201d68 <etext+0x6f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201594:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201596:	fda040e3          	bgtz	s10,ffffffffc0201556 <vprintfmt+0x300>
ffffffffc020159a:	bd51                	j	ffffffffc020142e <vprintfmt+0x1d8>

ffffffffc020159c <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020159c:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc020159e:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02015a2:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02015a4:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02015a6:	ec06                	sd	ra,24(sp)
ffffffffc02015a8:	f83a                	sd	a4,48(sp)
ffffffffc02015aa:	fc3e                	sd	a5,56(sp)
ffffffffc02015ac:	e0c2                	sd	a6,64(sp)
ffffffffc02015ae:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02015b0:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02015b2:	ca5ff0ef          	jal	ffffffffc0201256 <vprintfmt>
}
ffffffffc02015b6:	60e2                	ld	ra,24(sp)
ffffffffc02015b8:	6161                	addi	sp,sp,80
ffffffffc02015ba:	8082                	ret

ffffffffc02015bc <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc02015bc:	00004717          	auipc	a4,0x4
ffffffffc02015c0:	a5473703          	ld	a4,-1452(a4) # ffffffffc0205010 <SBI_CONSOLE_PUTCHAR>
ffffffffc02015c4:	4781                	li	a5,0
ffffffffc02015c6:	88ba                	mv	a7,a4
ffffffffc02015c8:	852a                	mv	a0,a0
ffffffffc02015ca:	85be                	mv	a1,a5
ffffffffc02015cc:	863e                	mv	a2,a5
ffffffffc02015ce:	00000073          	ecall
ffffffffc02015d2:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc02015d4:	8082                	ret

ffffffffc02015d6 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02015d6:	00054783          	lbu	a5,0(a0)
ffffffffc02015da:	cb81                	beqz	a5,ffffffffc02015ea <strlen+0x14>
    size_t cnt = 0;
ffffffffc02015dc:	4781                	li	a5,0
        cnt ++;
ffffffffc02015de:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc02015e0:	00f50733          	add	a4,a0,a5
ffffffffc02015e4:	00074703          	lbu	a4,0(a4)
ffffffffc02015e8:	fb7d                	bnez	a4,ffffffffc02015de <strlen+0x8>
    }
    return cnt;
}
ffffffffc02015ea:	853e                	mv	a0,a5
ffffffffc02015ec:	8082                	ret

ffffffffc02015ee <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02015ee:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02015f0:	e589                	bnez	a1,ffffffffc02015fa <strnlen+0xc>
ffffffffc02015f2:	a811                	j	ffffffffc0201606 <strnlen+0x18>
        cnt ++;
ffffffffc02015f4:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02015f6:	00f58863          	beq	a1,a5,ffffffffc0201606 <strnlen+0x18>
ffffffffc02015fa:	00f50733          	add	a4,a0,a5
ffffffffc02015fe:	00074703          	lbu	a4,0(a4)
ffffffffc0201602:	fb6d                	bnez	a4,ffffffffc02015f4 <strnlen+0x6>
ffffffffc0201604:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201606:	852e                	mv	a0,a1
ffffffffc0201608:	8082                	ret

ffffffffc020160a <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020160a:	00054783          	lbu	a5,0(a0)
ffffffffc020160e:	e791                	bnez	a5,ffffffffc020161a <strcmp+0x10>
ffffffffc0201610:	a01d                	j	ffffffffc0201636 <strcmp+0x2c>
ffffffffc0201612:	00054783          	lbu	a5,0(a0)
ffffffffc0201616:	cb99                	beqz	a5,ffffffffc020162c <strcmp+0x22>
ffffffffc0201618:	0585                	addi	a1,a1,1
ffffffffc020161a:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc020161e:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201620:	fef709e3          	beq	a4,a5,ffffffffc0201612 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201624:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0201628:	9d19                	subw	a0,a0,a4
ffffffffc020162a:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020162c:	0015c703          	lbu	a4,1(a1)
ffffffffc0201630:	4501                	li	a0,0
}
ffffffffc0201632:	9d19                	subw	a0,a0,a4
ffffffffc0201634:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201636:	0005c703          	lbu	a4,0(a1)
ffffffffc020163a:	4501                	li	a0,0
ffffffffc020163c:	b7f5                	j	ffffffffc0201628 <strcmp+0x1e>

ffffffffc020163e <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020163e:	ce01                	beqz	a2,ffffffffc0201656 <strncmp+0x18>
ffffffffc0201640:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201644:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201646:	cb91                	beqz	a5,ffffffffc020165a <strncmp+0x1c>
ffffffffc0201648:	0005c703          	lbu	a4,0(a1)
ffffffffc020164c:	00f71763          	bne	a4,a5,ffffffffc020165a <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0201650:	0505                	addi	a0,a0,1
ffffffffc0201652:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201654:	f675                	bnez	a2,ffffffffc0201640 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201656:	4501                	li	a0,0
ffffffffc0201658:	8082                	ret
ffffffffc020165a:	00054503          	lbu	a0,0(a0)
ffffffffc020165e:	0005c783          	lbu	a5,0(a1)
ffffffffc0201662:	9d1d                	subw	a0,a0,a5
}
ffffffffc0201664:	8082                	ret

ffffffffc0201666 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201666:	ca01                	beqz	a2,ffffffffc0201676 <memset+0x10>
ffffffffc0201668:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc020166a:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc020166c:	0785                	addi	a5,a5,1
ffffffffc020166e:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201672:	fef61de3          	bne	a2,a5,ffffffffc020166c <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201676:	8082                	ret
