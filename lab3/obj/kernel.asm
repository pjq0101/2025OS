
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00007297          	auipc	t0,0x7
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0207000 <boot_hartid>
ffffffffc020000c:	00007297          	auipc	t0,0x7
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0207008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02062b7          	lui	t0,0xc0206
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0206137          	lui	sp,0xc0206
ffffffffc0200040:	c0206337          	lui	t1,0xc0206
ffffffffc0200044:	00030313          	mv	t1,t1
ffffffffc0200048:	811a                	mv	sp,t1
ffffffffc020004a:	c02002b7          	lui	t0,0xc0200
ffffffffc020004e:	05428293          	addi	t0,t0,84 # ffffffffc0200054 <kern_init>
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
ffffffffc0200060:	44c60613          	addi	a2,a2,1100 # ffffffffc02074a8 <end>
int kern_init(void) {
ffffffffc0200064:	1141                	addi	sp,sp,-16 # ffffffffc0205ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc0200066:	8e09                	sub	a2,a2,a0
ffffffffc0200068:	4581                	li	a1,0
int kern_init(void) {
ffffffffc020006a:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020006c:	787010ef          	jal	ffffffffc0201ff2 <memset>
    dtb_init();
ffffffffc0200070:	454000ef          	jal	ffffffffc02004c4 <dtb_init>
    cons_init();  // init the console
ffffffffc0200074:	442000ef          	jal	ffffffffc02004b6 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200078:	00003517          	auipc	a0,0x3
ffffffffc020007c:	e5050513          	addi	a0,a0,-432 # ffffffffc0202ec8 <etext+0xec4>
ffffffffc0200080:	0d8000ef          	jal	ffffffffc0200158 <cputs>

    print_kerninfo();
ffffffffc0200084:	132000ef          	jal	ffffffffc02001b6 <print_kerninfo>

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200088:	7c4000ef          	jal	ffffffffc020084c <idt_init>

    pmm_init();  // init physical memory management
ffffffffc020008c:	7b0010ef          	jal	ffffffffc020183c <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc0200090:	7bc000ef          	jal	ffffffffc020084c <idt_init>

    clock_init();   // init clock interrupt
ffffffffc0200094:	3e0000ef          	jal	ffffffffc0200474 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200098:	7a8000ef          	jal	ffffffffc0200840 <intr_enable>



    // 测试1：mret
    static int illegal_test_done = 0;
    if (!illegal_test_done) {
ffffffffc020009c:	00007797          	auipc	a5,0x7
ffffffffc02000a0:	3a87a783          	lw	a5,936(a5) # ffffffffc0207444 <illegal_test_done.1>
ffffffffc02000a4:	c785                	beqz	a5,ffffffffc02000cc <kern_init+0x78>
        illegal_test_done = 1;
    }

    // 测试2：ebreak
    static int ebreak_test_done = 0;
    if (!ebreak_test_done) {
ffffffffc02000a6:	00007797          	auipc	a5,0x7
ffffffffc02000aa:	39a7a783          	lw	a5,922(a5) # ffffffffc0207440 <ebreak_test_done.0>
ffffffffc02000ae:	c391                	beqz	a5,ffffffffc02000b2 <kern_init+0x5e>
    }

    
    
    /* do nothing */
    while (1)
ffffffffc02000b0:	a001                	j	ffffffffc02000b0 <kern_init+0x5c>
        cprintf("\n=== Testing Breakpoint (ebreak) ===\n");
ffffffffc02000b2:	00002517          	auipc	a0,0x2
ffffffffc02000b6:	f8e50513          	addi	a0,a0,-114 # ffffffffc0202040 <etext+0x3c>
ffffffffc02000ba:	068000ef          	jal	ffffffffc0200122 <cprintf>
        asm volatile("ebreak");
ffffffffc02000be:	9002                	ebreak
        ebreak_test_done = 1;
ffffffffc02000c0:	4785                	li	a5,1
ffffffffc02000c2:	00007717          	auipc	a4,0x7
ffffffffc02000c6:	36f72f23          	sw	a5,894(a4) # ffffffffc0207440 <ebreak_test_done.0>
ffffffffc02000ca:	b7dd                	j	ffffffffc02000b0 <kern_init+0x5c>
        cprintf("\n=== Testing Illegal Instruction (mret) ===\n");
ffffffffc02000cc:	00002517          	auipc	a0,0x2
ffffffffc02000d0:	f3c50513          	addi	a0,a0,-196 # ffffffffc0202008 <etext+0x4>
ffffffffc02000d4:	04e000ef          	jal	ffffffffc0200122 <cprintf>
        asm volatile(".word 0x30200073");  // mret 指令
ffffffffc02000d8:	30200073          	.word	0x30200073
        illegal_test_done = 1;
ffffffffc02000dc:	4785                	li	a5,1
ffffffffc02000de:	00007717          	auipc	a4,0x7
ffffffffc02000e2:	36f72323          	sw	a5,870(a4) # ffffffffc0207444 <illegal_test_done.1>
ffffffffc02000e6:	b7c1                	j	ffffffffc02000a6 <kern_init+0x52>

ffffffffc02000e8 <cputch>:
ffffffffc02000e8:	1141                	addi	sp,sp,-16
ffffffffc02000ea:	e022                	sd	s0,0(sp)
ffffffffc02000ec:	e406                	sd	ra,8(sp)
ffffffffc02000ee:	842e                	mv	s0,a1
ffffffffc02000f0:	3c8000ef          	jal	ffffffffc02004b8 <cons_putc>
ffffffffc02000f4:	401c                	lw	a5,0(s0)
ffffffffc02000f6:	60a2                	ld	ra,8(sp)
ffffffffc02000f8:	2785                	addiw	a5,a5,1
ffffffffc02000fa:	c01c                	sw	a5,0(s0)
ffffffffc02000fc:	6402                	ld	s0,0(sp)
ffffffffc02000fe:	0141                	addi	sp,sp,16
ffffffffc0200100:	8082                	ret

ffffffffc0200102 <vcprintf>:
ffffffffc0200102:	1101                	addi	sp,sp,-32
ffffffffc0200104:	862a                	mv	a2,a0
ffffffffc0200106:	86ae                	mv	a3,a1
ffffffffc0200108:	00000517          	auipc	a0,0x0
ffffffffc020010c:	fe050513          	addi	a0,a0,-32 # ffffffffc02000e8 <cputch>
ffffffffc0200110:	006c                	addi	a1,sp,12
ffffffffc0200112:	ec06                	sd	ra,24(sp)
ffffffffc0200114:	c602                	sw	zero,12(sp)
ffffffffc0200116:	199010ef          	jal	ffffffffc0201aae <vprintfmt>
ffffffffc020011a:	60e2                	ld	ra,24(sp)
ffffffffc020011c:	4532                	lw	a0,12(sp)
ffffffffc020011e:	6105                	addi	sp,sp,32
ffffffffc0200120:	8082                	ret

ffffffffc0200122 <cprintf>:
ffffffffc0200122:	711d                	addi	sp,sp,-96
ffffffffc0200124:	02810313          	addi	t1,sp,40
ffffffffc0200128:	f42e                	sd	a1,40(sp)
ffffffffc020012a:	f832                	sd	a2,48(sp)
ffffffffc020012c:	fc36                	sd	a3,56(sp)
ffffffffc020012e:	862a                	mv	a2,a0
ffffffffc0200130:	004c                	addi	a1,sp,4
ffffffffc0200132:	00000517          	auipc	a0,0x0
ffffffffc0200136:	fb650513          	addi	a0,a0,-74 # ffffffffc02000e8 <cputch>
ffffffffc020013a:	869a                	mv	a3,t1
ffffffffc020013c:	ec06                	sd	ra,24(sp)
ffffffffc020013e:	e0ba                	sd	a4,64(sp)
ffffffffc0200140:	e4be                	sd	a5,72(sp)
ffffffffc0200142:	e8c2                	sd	a6,80(sp)
ffffffffc0200144:	ecc6                	sd	a7,88(sp)
ffffffffc0200146:	e41a                	sd	t1,8(sp)
ffffffffc0200148:	c202                	sw	zero,4(sp)
ffffffffc020014a:	165010ef          	jal	ffffffffc0201aae <vprintfmt>
ffffffffc020014e:	60e2                	ld	ra,24(sp)
ffffffffc0200150:	4512                	lw	a0,4(sp)
ffffffffc0200152:	6125                	addi	sp,sp,96
ffffffffc0200154:	8082                	ret

ffffffffc0200156 <cputchar>:
ffffffffc0200156:	a68d                	j	ffffffffc02004b8 <cons_putc>

ffffffffc0200158 <cputs>:
ffffffffc0200158:	1101                	addi	sp,sp,-32
ffffffffc020015a:	ec06                	sd	ra,24(sp)
ffffffffc020015c:	e822                	sd	s0,16(sp)
ffffffffc020015e:	87aa                	mv	a5,a0
ffffffffc0200160:	00054503          	lbu	a0,0(a0)
ffffffffc0200164:	c905                	beqz	a0,ffffffffc0200194 <cputs+0x3c>
ffffffffc0200166:	e426                	sd	s1,8(sp)
ffffffffc0200168:	00178493          	addi	s1,a5,1
ffffffffc020016c:	8426                	mv	s0,s1
ffffffffc020016e:	34a000ef          	jal	ffffffffc02004b8 <cons_putc>
ffffffffc0200172:	00044503          	lbu	a0,0(s0)
ffffffffc0200176:	87a2                	mv	a5,s0
ffffffffc0200178:	0405                	addi	s0,s0,1
ffffffffc020017a:	f975                	bnez	a0,ffffffffc020016e <cputs+0x16>
ffffffffc020017c:	9f85                	subw	a5,a5,s1
ffffffffc020017e:	4529                	li	a0,10
ffffffffc0200180:	0027841b          	addiw	s0,a5,2
ffffffffc0200184:	64a2                	ld	s1,8(sp)
ffffffffc0200186:	332000ef          	jal	ffffffffc02004b8 <cons_putc>
ffffffffc020018a:	60e2                	ld	ra,24(sp)
ffffffffc020018c:	8522                	mv	a0,s0
ffffffffc020018e:	6442                	ld	s0,16(sp)
ffffffffc0200190:	6105                	addi	sp,sp,32
ffffffffc0200192:	8082                	ret
ffffffffc0200194:	4529                	li	a0,10
ffffffffc0200196:	322000ef          	jal	ffffffffc02004b8 <cons_putc>
ffffffffc020019a:	4405                	li	s0,1
ffffffffc020019c:	60e2                	ld	ra,24(sp)
ffffffffc020019e:	8522                	mv	a0,s0
ffffffffc02001a0:	6442                	ld	s0,16(sp)
ffffffffc02001a2:	6105                	addi	sp,sp,32
ffffffffc02001a4:	8082                	ret

ffffffffc02001a6 <getchar>:
ffffffffc02001a6:	1141                	addi	sp,sp,-16
ffffffffc02001a8:	e406                	sd	ra,8(sp)
ffffffffc02001aa:	316000ef          	jal	ffffffffc02004c0 <cons_getc>
ffffffffc02001ae:	dd75                	beqz	a0,ffffffffc02001aa <getchar+0x4>
ffffffffc02001b0:	60a2                	ld	ra,8(sp)
ffffffffc02001b2:	0141                	addi	sp,sp,16
ffffffffc02001b4:	8082                	ret

ffffffffc02001b6 <print_kerninfo>:
ffffffffc02001b6:	1141                	addi	sp,sp,-16
ffffffffc02001b8:	00002517          	auipc	a0,0x2
ffffffffc02001bc:	eb050513          	addi	a0,a0,-336 # ffffffffc0202068 <etext+0x64>
ffffffffc02001c0:	e406                	sd	ra,8(sp)
ffffffffc02001c2:	f61ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02001c6:	00000597          	auipc	a1,0x0
ffffffffc02001ca:	e8e58593          	addi	a1,a1,-370 # ffffffffc0200054 <kern_init>
ffffffffc02001ce:	00002517          	auipc	a0,0x2
ffffffffc02001d2:	eba50513          	addi	a0,a0,-326 # ffffffffc0202088 <etext+0x84>
ffffffffc02001d6:	f4dff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02001da:	00002597          	auipc	a1,0x2
ffffffffc02001de:	e2a58593          	addi	a1,a1,-470 # ffffffffc0202004 <etext>
ffffffffc02001e2:	00002517          	auipc	a0,0x2
ffffffffc02001e6:	ec650513          	addi	a0,a0,-314 # ffffffffc02020a8 <etext+0xa4>
ffffffffc02001ea:	f39ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02001ee:	00007597          	auipc	a1,0x7
ffffffffc02001f2:	e3a58593          	addi	a1,a1,-454 # ffffffffc0207028 <free_area>
ffffffffc02001f6:	00002517          	auipc	a0,0x2
ffffffffc02001fa:	ed250513          	addi	a0,a0,-302 # ffffffffc02020c8 <etext+0xc4>
ffffffffc02001fe:	f25ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200202:	00007597          	auipc	a1,0x7
ffffffffc0200206:	2a658593          	addi	a1,a1,678 # ffffffffc02074a8 <end>
ffffffffc020020a:	00002517          	auipc	a0,0x2
ffffffffc020020e:	ede50513          	addi	a0,a0,-290 # ffffffffc02020e8 <etext+0xe4>
ffffffffc0200212:	f11ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200216:	00007797          	auipc	a5,0x7
ffffffffc020021a:	69178793          	addi	a5,a5,1681 # ffffffffc02078a7 <end+0x3ff>
ffffffffc020021e:	00000717          	auipc	a4,0x0
ffffffffc0200222:	e3670713          	addi	a4,a4,-458 # ffffffffc0200054 <kern_init>
ffffffffc0200226:	8f99                	sub	a5,a5,a4
ffffffffc0200228:	43f7d593          	srai	a1,a5,0x3f
ffffffffc020022c:	60a2                	ld	ra,8(sp)
ffffffffc020022e:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200232:	95be                	add	a1,a1,a5
ffffffffc0200234:	85a9                	srai	a1,a1,0xa
ffffffffc0200236:	00002517          	auipc	a0,0x2
ffffffffc020023a:	ed250513          	addi	a0,a0,-302 # ffffffffc0202108 <etext+0x104>
ffffffffc020023e:	0141                	addi	sp,sp,16
ffffffffc0200240:	b5cd                	j	ffffffffc0200122 <cprintf>

ffffffffc0200242 <print_stackframe>:
ffffffffc0200242:	1141                	addi	sp,sp,-16
ffffffffc0200244:	00002617          	auipc	a2,0x2
ffffffffc0200248:	ef460613          	addi	a2,a2,-268 # ffffffffc0202138 <etext+0x134>
ffffffffc020024c:	04d00593          	li	a1,77
ffffffffc0200250:	00002517          	auipc	a0,0x2
ffffffffc0200254:	f0050513          	addi	a0,a0,-256 # ffffffffc0202150 <etext+0x14c>
ffffffffc0200258:	e406                	sd	ra,8(sp)
ffffffffc020025a:	1bc000ef          	jal	ffffffffc0200416 <__panic>

ffffffffc020025e <mon_help>:
ffffffffc020025e:	1141                	addi	sp,sp,-16
ffffffffc0200260:	00002617          	auipc	a2,0x2
ffffffffc0200264:	f0860613          	addi	a2,a2,-248 # ffffffffc0202168 <etext+0x164>
ffffffffc0200268:	00002597          	auipc	a1,0x2
ffffffffc020026c:	f2058593          	addi	a1,a1,-224 # ffffffffc0202188 <etext+0x184>
ffffffffc0200270:	00002517          	auipc	a0,0x2
ffffffffc0200274:	f2050513          	addi	a0,a0,-224 # ffffffffc0202190 <etext+0x18c>
ffffffffc0200278:	e406                	sd	ra,8(sp)
ffffffffc020027a:	ea9ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc020027e:	00002617          	auipc	a2,0x2
ffffffffc0200282:	f2260613          	addi	a2,a2,-222 # ffffffffc02021a0 <etext+0x19c>
ffffffffc0200286:	00002597          	auipc	a1,0x2
ffffffffc020028a:	f4258593          	addi	a1,a1,-190 # ffffffffc02021c8 <etext+0x1c4>
ffffffffc020028e:	00002517          	auipc	a0,0x2
ffffffffc0200292:	f0250513          	addi	a0,a0,-254 # ffffffffc0202190 <etext+0x18c>
ffffffffc0200296:	e8dff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc020029a:	00002617          	auipc	a2,0x2
ffffffffc020029e:	f3e60613          	addi	a2,a2,-194 # ffffffffc02021d8 <etext+0x1d4>
ffffffffc02002a2:	00002597          	auipc	a1,0x2
ffffffffc02002a6:	f5658593          	addi	a1,a1,-170 # ffffffffc02021f8 <etext+0x1f4>
ffffffffc02002aa:	00002517          	auipc	a0,0x2
ffffffffc02002ae:	ee650513          	addi	a0,a0,-282 # ffffffffc0202190 <etext+0x18c>
ffffffffc02002b2:	e71ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02002b6:	60a2                	ld	ra,8(sp)
ffffffffc02002b8:	4501                	li	a0,0
ffffffffc02002ba:	0141                	addi	sp,sp,16
ffffffffc02002bc:	8082                	ret

ffffffffc02002be <mon_kerninfo>:
ffffffffc02002be:	1141                	addi	sp,sp,-16
ffffffffc02002c0:	e406                	sd	ra,8(sp)
ffffffffc02002c2:	ef5ff0ef          	jal	ffffffffc02001b6 <print_kerninfo>
ffffffffc02002c6:	60a2                	ld	ra,8(sp)
ffffffffc02002c8:	4501                	li	a0,0
ffffffffc02002ca:	0141                	addi	sp,sp,16
ffffffffc02002cc:	8082                	ret

ffffffffc02002ce <mon_backtrace>:
ffffffffc02002ce:	1141                	addi	sp,sp,-16
ffffffffc02002d0:	e406                	sd	ra,8(sp)
ffffffffc02002d2:	f71ff0ef          	jal	ffffffffc0200242 <print_stackframe>
ffffffffc02002d6:	60a2                	ld	ra,8(sp)
ffffffffc02002d8:	4501                	li	a0,0
ffffffffc02002da:	0141                	addi	sp,sp,16
ffffffffc02002dc:	8082                	ret

ffffffffc02002de <kmonitor>:
ffffffffc02002de:	7115                	addi	sp,sp,-224
ffffffffc02002e0:	f15a                	sd	s6,160(sp)
ffffffffc02002e2:	8b2a                	mv	s6,a0
ffffffffc02002e4:	00002517          	auipc	a0,0x2
ffffffffc02002e8:	f2450513          	addi	a0,a0,-220 # ffffffffc0202208 <etext+0x204>
ffffffffc02002ec:	ed86                	sd	ra,216(sp)
ffffffffc02002ee:	e9a2                	sd	s0,208(sp)
ffffffffc02002f0:	e5a6                	sd	s1,200(sp)
ffffffffc02002f2:	e1ca                	sd	s2,192(sp)
ffffffffc02002f4:	fd4e                	sd	s3,184(sp)
ffffffffc02002f6:	f952                	sd	s4,176(sp)
ffffffffc02002f8:	f556                	sd	s5,168(sp)
ffffffffc02002fa:	ed5e                	sd	s7,152(sp)
ffffffffc02002fc:	e962                	sd	s8,144(sp)
ffffffffc02002fe:	e566                	sd	s9,136(sp)
ffffffffc0200300:	e16a                	sd	s10,128(sp)
ffffffffc0200302:	e21ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200306:	00002517          	auipc	a0,0x2
ffffffffc020030a:	f2a50513          	addi	a0,a0,-214 # ffffffffc0202230 <etext+0x22c>
ffffffffc020030e:	e15ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200312:	000b0563          	beqz	s6,ffffffffc020031c <kmonitor+0x3e>
ffffffffc0200316:	855a                	mv	a0,s6
ffffffffc0200318:	714000ef          	jal	ffffffffc0200a2c <print_trapframe>
ffffffffc020031c:	00003c17          	auipc	s8,0x3
ffffffffc0200320:	bccc0c13          	addi	s8,s8,-1076 # ffffffffc0202ee8 <commands>
ffffffffc0200324:	00002917          	auipc	s2,0x2
ffffffffc0200328:	f3490913          	addi	s2,s2,-204 # ffffffffc0202258 <etext+0x254>
ffffffffc020032c:	00002497          	auipc	s1,0x2
ffffffffc0200330:	f3448493          	addi	s1,s1,-204 # ffffffffc0202260 <etext+0x25c>
ffffffffc0200334:	49bd                	li	s3,15
ffffffffc0200336:	00002a97          	auipc	s5,0x2
ffffffffc020033a:	f32a8a93          	addi	s5,s5,-206 # ffffffffc0202268 <etext+0x264>
ffffffffc020033e:	4a0d                	li	s4,3
ffffffffc0200340:	00002b97          	auipc	s7,0x2
ffffffffc0200344:	f48b8b93          	addi	s7,s7,-184 # ffffffffc0202288 <etext+0x284>
ffffffffc0200348:	854a                	mv	a0,s2
ffffffffc020034a:	2df010ef          	jal	ffffffffc0201e28 <readline>
ffffffffc020034e:	842a                	mv	s0,a0
ffffffffc0200350:	dd65                	beqz	a0,ffffffffc0200348 <kmonitor+0x6a>
ffffffffc0200352:	00054583          	lbu	a1,0(a0)
ffffffffc0200356:	4c81                	li	s9,0
ffffffffc0200358:	e59d                	bnez	a1,ffffffffc0200386 <kmonitor+0xa8>
ffffffffc020035a:	fe0c87e3          	beqz	s9,ffffffffc0200348 <kmonitor+0x6a>
ffffffffc020035e:	00003d17          	auipc	s10,0x3
ffffffffc0200362:	b8ad0d13          	addi	s10,s10,-1142 # ffffffffc0202ee8 <commands>
ffffffffc0200366:	4401                	li	s0,0
ffffffffc0200368:	6582                	ld	a1,0(sp)
ffffffffc020036a:	000d3503          	ld	a0,0(s10)
ffffffffc020036e:	40f010ef          	jal	ffffffffc0201f7c <strcmp>
ffffffffc0200372:	c53d                	beqz	a0,ffffffffc02003e0 <kmonitor+0x102>
ffffffffc0200374:	2405                	addiw	s0,s0,1
ffffffffc0200376:	0d61                	addi	s10,s10,24
ffffffffc0200378:	ff4418e3          	bne	s0,s4,ffffffffc0200368 <kmonitor+0x8a>
ffffffffc020037c:	6582                	ld	a1,0(sp)
ffffffffc020037e:	855e                	mv	a0,s7
ffffffffc0200380:	da3ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200384:	b7d1                	j	ffffffffc0200348 <kmonitor+0x6a>
ffffffffc0200386:	8526                	mv	a0,s1
ffffffffc0200388:	455010ef          	jal	ffffffffc0201fdc <strchr>
ffffffffc020038c:	c901                	beqz	a0,ffffffffc020039c <kmonitor+0xbe>
ffffffffc020038e:	00144583          	lbu	a1,1(s0)
ffffffffc0200392:	00040023          	sb	zero,0(s0)
ffffffffc0200396:	0405                	addi	s0,s0,1
ffffffffc0200398:	d1e9                	beqz	a1,ffffffffc020035a <kmonitor+0x7c>
ffffffffc020039a:	b7f5                	j	ffffffffc0200386 <kmonitor+0xa8>
ffffffffc020039c:	00044783          	lbu	a5,0(s0)
ffffffffc02003a0:	dfcd                	beqz	a5,ffffffffc020035a <kmonitor+0x7c>
ffffffffc02003a2:	033c8a63          	beq	s9,s3,ffffffffc02003d6 <kmonitor+0xf8>
ffffffffc02003a6:	003c9793          	slli	a5,s9,0x3
ffffffffc02003aa:	08078793          	addi	a5,a5,128
ffffffffc02003ae:	978a                	add	a5,a5,sp
ffffffffc02003b0:	f887b023          	sd	s0,-128(a5)
ffffffffc02003b4:	00044583          	lbu	a1,0(s0)
ffffffffc02003b8:	2c85                	addiw	s9,s9,1
ffffffffc02003ba:	e591                	bnez	a1,ffffffffc02003c6 <kmonitor+0xe8>
ffffffffc02003bc:	bf79                	j	ffffffffc020035a <kmonitor+0x7c>
ffffffffc02003be:	00144583          	lbu	a1,1(s0)
ffffffffc02003c2:	0405                	addi	s0,s0,1
ffffffffc02003c4:	d9d9                	beqz	a1,ffffffffc020035a <kmonitor+0x7c>
ffffffffc02003c6:	8526                	mv	a0,s1
ffffffffc02003c8:	415010ef          	jal	ffffffffc0201fdc <strchr>
ffffffffc02003cc:	d96d                	beqz	a0,ffffffffc02003be <kmonitor+0xe0>
ffffffffc02003ce:	00044583          	lbu	a1,0(s0)
ffffffffc02003d2:	d5c1                	beqz	a1,ffffffffc020035a <kmonitor+0x7c>
ffffffffc02003d4:	bf4d                	j	ffffffffc0200386 <kmonitor+0xa8>
ffffffffc02003d6:	45c1                	li	a1,16
ffffffffc02003d8:	8556                	mv	a0,s5
ffffffffc02003da:	d49ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02003de:	b7e1                	j	ffffffffc02003a6 <kmonitor+0xc8>
ffffffffc02003e0:	00141793          	slli	a5,s0,0x1
ffffffffc02003e4:	97a2                	add	a5,a5,s0
ffffffffc02003e6:	078e                	slli	a5,a5,0x3
ffffffffc02003e8:	97e2                	add	a5,a5,s8
ffffffffc02003ea:	6b9c                	ld	a5,16(a5)
ffffffffc02003ec:	865a                	mv	a2,s6
ffffffffc02003ee:	002c                	addi	a1,sp,8
ffffffffc02003f0:	fffc851b          	addiw	a0,s9,-1
ffffffffc02003f4:	9782                	jalr	a5
ffffffffc02003f6:	f40559e3          	bgez	a0,ffffffffc0200348 <kmonitor+0x6a>
ffffffffc02003fa:	60ee                	ld	ra,216(sp)
ffffffffc02003fc:	644e                	ld	s0,208(sp)
ffffffffc02003fe:	64ae                	ld	s1,200(sp)
ffffffffc0200400:	690e                	ld	s2,192(sp)
ffffffffc0200402:	79ea                	ld	s3,184(sp)
ffffffffc0200404:	7a4a                	ld	s4,176(sp)
ffffffffc0200406:	7aaa                	ld	s5,168(sp)
ffffffffc0200408:	7b0a                	ld	s6,160(sp)
ffffffffc020040a:	6bea                	ld	s7,152(sp)
ffffffffc020040c:	6c4a                	ld	s8,144(sp)
ffffffffc020040e:	6caa                	ld	s9,136(sp)
ffffffffc0200410:	6d0a                	ld	s10,128(sp)
ffffffffc0200412:	612d                	addi	sp,sp,224
ffffffffc0200414:	8082                	ret

ffffffffc0200416 <__panic>:
ffffffffc0200416:	00007317          	auipc	t1,0x7
ffffffffc020041a:	03230313          	addi	t1,t1,50 # ffffffffc0207448 <is_panic>
ffffffffc020041e:	00032e03          	lw	t3,0(t1)
ffffffffc0200422:	715d                	addi	sp,sp,-80
ffffffffc0200424:	ec06                	sd	ra,24(sp)
ffffffffc0200426:	f436                	sd	a3,40(sp)
ffffffffc0200428:	f83a                	sd	a4,48(sp)
ffffffffc020042a:	fc3e                	sd	a5,56(sp)
ffffffffc020042c:	e0c2                	sd	a6,64(sp)
ffffffffc020042e:	e4c6                	sd	a7,72(sp)
ffffffffc0200430:	020e1c63          	bnez	t3,ffffffffc0200468 <__panic+0x52>
ffffffffc0200434:	4785                	li	a5,1
ffffffffc0200436:	00f32023          	sw	a5,0(t1)
ffffffffc020043a:	e822                	sd	s0,16(sp)
ffffffffc020043c:	103c                	addi	a5,sp,40
ffffffffc020043e:	8432                	mv	s0,a2
ffffffffc0200440:	862e                	mv	a2,a1
ffffffffc0200442:	85aa                	mv	a1,a0
ffffffffc0200444:	00002517          	auipc	a0,0x2
ffffffffc0200448:	e5c50513          	addi	a0,a0,-420 # ffffffffc02022a0 <etext+0x29c>
ffffffffc020044c:	e43e                	sd	a5,8(sp)
ffffffffc020044e:	cd5ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200452:	65a2                	ld	a1,8(sp)
ffffffffc0200454:	8522                	mv	a0,s0
ffffffffc0200456:	cadff0ef          	jal	ffffffffc0200102 <vcprintf>
ffffffffc020045a:	00002517          	auipc	a0,0x2
ffffffffc020045e:	e6650513          	addi	a0,a0,-410 # ffffffffc02022c0 <etext+0x2bc>
ffffffffc0200462:	cc1ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200466:	6442                	ld	s0,16(sp)
ffffffffc0200468:	3de000ef          	jal	ffffffffc0200846 <intr_disable>
ffffffffc020046c:	4501                	li	a0,0
ffffffffc020046e:	e71ff0ef          	jal	ffffffffc02002de <kmonitor>
ffffffffc0200472:	bfed                	j	ffffffffc020046c <__panic+0x56>

ffffffffc0200474 <clock_init>:
ffffffffc0200474:	1141                	addi	sp,sp,-16
ffffffffc0200476:	e406                	sd	ra,8(sp)
ffffffffc0200478:	02000793          	li	a5,32
ffffffffc020047c:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200480:	c0102573          	rdtime	a0
ffffffffc0200484:	67e1                	lui	a5,0x18
ffffffffc0200486:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020048a:	953e                	add	a0,a0,a5
ffffffffc020048c:	26b010ef          	jal	ffffffffc0201ef6 <sbi_set_timer>
ffffffffc0200490:	60a2                	ld	ra,8(sp)
ffffffffc0200492:	00007797          	auipc	a5,0x7
ffffffffc0200496:	fa07bf23          	sd	zero,-66(a5) # ffffffffc0207450 <ticks>
ffffffffc020049a:	00002517          	auipc	a0,0x2
ffffffffc020049e:	e2e50513          	addi	a0,a0,-466 # ffffffffc02022c8 <etext+0x2c4>
ffffffffc02004a2:	0141                	addi	sp,sp,16
ffffffffc02004a4:	b9bd                	j	ffffffffc0200122 <cprintf>

ffffffffc02004a6 <clock_set_next_event>:
ffffffffc02004a6:	c0102573          	rdtime	a0
ffffffffc02004aa:	67e1                	lui	a5,0x18
ffffffffc02004ac:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc02004b0:	953e                	add	a0,a0,a5
ffffffffc02004b2:	2450106f          	j	ffffffffc0201ef6 <sbi_set_timer>

ffffffffc02004b6 <cons_init>:
ffffffffc02004b6:	8082                	ret

ffffffffc02004b8 <cons_putc>:
ffffffffc02004b8:	0ff57513          	zext.b	a0,a0
ffffffffc02004bc:	2210106f          	j	ffffffffc0201edc <sbi_console_putchar>

ffffffffc02004c0 <cons_getc>:
ffffffffc02004c0:	2510106f          	j	ffffffffc0201f10 <sbi_console_getchar>

ffffffffc02004c4 <dtb_init>:
ffffffffc02004c4:	711d                	addi	sp,sp,-96
ffffffffc02004c6:	00002517          	auipc	a0,0x2
ffffffffc02004ca:	e2250513          	addi	a0,a0,-478 # ffffffffc02022e8 <etext+0x2e4>
ffffffffc02004ce:	ec86                	sd	ra,88(sp)
ffffffffc02004d0:	e8a2                	sd	s0,80(sp)
ffffffffc02004d2:	c51ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02004d6:	00007597          	auipc	a1,0x7
ffffffffc02004da:	b2a5b583          	ld	a1,-1238(a1) # ffffffffc0207000 <boot_hartid>
ffffffffc02004de:	00002517          	auipc	a0,0x2
ffffffffc02004e2:	e1a50513          	addi	a0,a0,-486 # ffffffffc02022f8 <etext+0x2f4>
ffffffffc02004e6:	c3dff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02004ea:	00007417          	auipc	s0,0x7
ffffffffc02004ee:	b1e40413          	addi	s0,s0,-1250 # ffffffffc0207008 <boot_dtb>
ffffffffc02004f2:	600c                	ld	a1,0(s0)
ffffffffc02004f4:	00002517          	auipc	a0,0x2
ffffffffc02004f8:	e1450513          	addi	a0,a0,-492 # ffffffffc0202308 <etext+0x304>
ffffffffc02004fc:	c27ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200500:	6018                	ld	a4,0(s0)
ffffffffc0200502:	00002517          	auipc	a0,0x2
ffffffffc0200506:	e1e50513          	addi	a0,a0,-482 # ffffffffc0202320 <etext+0x31c>
ffffffffc020050a:	12070d63          	beqz	a4,ffffffffc0200644 <dtb_init+0x180>
ffffffffc020050e:	57f5                	li	a5,-3
ffffffffc0200510:	07fa                	slli	a5,a5,0x1e
ffffffffc0200512:	973e                	add	a4,a4,a5
ffffffffc0200514:	431c                	lw	a5,0(a4)
ffffffffc0200516:	f456                	sd	s5,40(sp)
ffffffffc0200518:	00ff0637          	lui	a2,0xff0
ffffffffc020051c:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200520:	0187969b          	slliw	a3,a5,0x18
ffffffffc0200524:	0187d51b          	srliw	a0,a5,0x18
ffffffffc0200528:	0105959b          	slliw	a1,a1,0x10
ffffffffc020052c:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200530:	6ac1                	lui	s5,0x10
ffffffffc0200532:	8df1                	and	a1,a1,a2
ffffffffc0200534:	8ec9                	or	a3,a3,a0
ffffffffc0200536:	0087979b          	slliw	a5,a5,0x8
ffffffffc020053a:	1afd                	addi	s5,s5,-1 # ffff <kern_entry-0xffffffffc01f0001>
ffffffffc020053c:	0157f7b3          	and	a5,a5,s5
ffffffffc0200540:	8dd5                	or	a1,a1,a3
ffffffffc0200542:	8ddd                	or	a1,a1,a5
ffffffffc0200544:	d00e07b7          	lui	a5,0xd00e0
ffffffffc0200548:	2581                	sext.w	a1,a1
ffffffffc020054a:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfed8a45>
ffffffffc020054e:	0ef59f63          	bne	a1,a5,ffffffffc020064c <dtb_init+0x188>
ffffffffc0200552:	471c                	lw	a5,8(a4)
ffffffffc0200554:	4754                	lw	a3,12(a4)
ffffffffc0200556:	fc4e                	sd	s3,56(sp)
ffffffffc0200558:	0087d99b          	srliw	s3,a5,0x8
ffffffffc020055c:	0086d41b          	srliw	s0,a3,0x8
ffffffffc0200560:	0186951b          	slliw	a0,a3,0x18
ffffffffc0200564:	0186d89b          	srliw	a7,a3,0x18
ffffffffc0200568:	0187959b          	slliw	a1,a5,0x18
ffffffffc020056c:	0187d81b          	srliw	a6,a5,0x18
ffffffffc0200570:	0104141b          	slliw	s0,s0,0x10
ffffffffc0200574:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200578:	0109999b          	slliw	s3,s3,0x10
ffffffffc020057c:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200580:	8c71                	and	s0,s0,a2
ffffffffc0200582:	00c9f9b3          	and	s3,s3,a2
ffffffffc0200586:	01156533          	or	a0,a0,a7
ffffffffc020058a:	0086969b          	slliw	a3,a3,0x8
ffffffffc020058e:	0105e633          	or	a2,a1,a6
ffffffffc0200592:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200596:	8c49                	or	s0,s0,a0
ffffffffc0200598:	0156f6b3          	and	a3,a3,s5
ffffffffc020059c:	00c9e9b3          	or	s3,s3,a2
ffffffffc02005a0:	0157f7b3          	and	a5,a5,s5
ffffffffc02005a4:	8c55                	or	s0,s0,a3
ffffffffc02005a6:	00f9e9b3          	or	s3,s3,a5
ffffffffc02005aa:	1402                	slli	s0,s0,0x20
ffffffffc02005ac:	1982                	slli	s3,s3,0x20
ffffffffc02005ae:	9001                	srli	s0,s0,0x20
ffffffffc02005b0:	0209d993          	srli	s3,s3,0x20
ffffffffc02005b4:	e4a6                	sd	s1,72(sp)
ffffffffc02005b6:	e0ca                	sd	s2,64(sp)
ffffffffc02005b8:	ec5e                	sd	s7,24(sp)
ffffffffc02005ba:	e862                	sd	s8,16(sp)
ffffffffc02005bc:	e466                	sd	s9,8(sp)
ffffffffc02005be:	e06a                	sd	s10,0(sp)
ffffffffc02005c0:	f852                	sd	s4,48(sp)
ffffffffc02005c2:	4b81                	li	s7,0
ffffffffc02005c4:	943a                	add	s0,s0,a4
ffffffffc02005c6:	99ba                	add	s3,s3,a4
ffffffffc02005c8:	00ff0cb7          	lui	s9,0xff0
ffffffffc02005cc:	4c0d                	li	s8,3
ffffffffc02005ce:	4911                	li	s2,4
ffffffffc02005d0:	4d05                	li	s10,1
ffffffffc02005d2:	4489                	li	s1,2
ffffffffc02005d4:	0009a703          	lw	a4,0(s3)
ffffffffc02005d8:	00498a13          	addi	s4,s3,4
ffffffffc02005dc:	0087569b          	srliw	a3,a4,0x8
ffffffffc02005e0:	0187179b          	slliw	a5,a4,0x18
ffffffffc02005e4:	0187561b          	srliw	a2,a4,0x18
ffffffffc02005e8:	0106969b          	slliw	a3,a3,0x10
ffffffffc02005ec:	0107571b          	srliw	a4,a4,0x10
ffffffffc02005f0:	8fd1                	or	a5,a5,a2
ffffffffc02005f2:	0196f6b3          	and	a3,a3,s9
ffffffffc02005f6:	0087171b          	slliw	a4,a4,0x8
ffffffffc02005fa:	8fd5                	or	a5,a5,a3
ffffffffc02005fc:	00eaf733          	and	a4,s5,a4
ffffffffc0200600:	8fd9                	or	a5,a5,a4
ffffffffc0200602:	2781                	sext.w	a5,a5
ffffffffc0200604:	09878263          	beq	a5,s8,ffffffffc0200688 <dtb_init+0x1c4>
ffffffffc0200608:	00fc6963          	bltu	s8,a5,ffffffffc020061a <dtb_init+0x156>
ffffffffc020060c:	05a78963          	beq	a5,s10,ffffffffc020065e <dtb_init+0x19a>
ffffffffc0200610:	00979763          	bne	a5,s1,ffffffffc020061e <dtb_init+0x15a>
ffffffffc0200614:	4b81                	li	s7,0
ffffffffc0200616:	89d2                	mv	s3,s4
ffffffffc0200618:	bf75                	j	ffffffffc02005d4 <dtb_init+0x110>
ffffffffc020061a:	ff278ee3          	beq	a5,s2,ffffffffc0200616 <dtb_init+0x152>
ffffffffc020061e:	00002517          	auipc	a0,0x2
ffffffffc0200622:	dca50513          	addi	a0,a0,-566 # ffffffffc02023e8 <etext+0x3e4>
ffffffffc0200626:	afdff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc020062a:	64a6                	ld	s1,72(sp)
ffffffffc020062c:	6906                	ld	s2,64(sp)
ffffffffc020062e:	79e2                	ld	s3,56(sp)
ffffffffc0200630:	7a42                	ld	s4,48(sp)
ffffffffc0200632:	7aa2                	ld	s5,40(sp)
ffffffffc0200634:	6be2                	ld	s7,24(sp)
ffffffffc0200636:	6c42                	ld	s8,16(sp)
ffffffffc0200638:	6ca2                	ld	s9,8(sp)
ffffffffc020063a:	6d02                	ld	s10,0(sp)
ffffffffc020063c:	00002517          	auipc	a0,0x2
ffffffffc0200640:	de450513          	addi	a0,a0,-540 # ffffffffc0202420 <etext+0x41c>
ffffffffc0200644:	6446                	ld	s0,80(sp)
ffffffffc0200646:	60e6                	ld	ra,88(sp)
ffffffffc0200648:	6125                	addi	sp,sp,96
ffffffffc020064a:	bce1                	j	ffffffffc0200122 <cprintf>
ffffffffc020064c:	6446                	ld	s0,80(sp)
ffffffffc020064e:	7aa2                	ld	s5,40(sp)
ffffffffc0200650:	60e6                	ld	ra,88(sp)
ffffffffc0200652:	00002517          	auipc	a0,0x2
ffffffffc0200656:	cee50513          	addi	a0,a0,-786 # ffffffffc0202340 <etext+0x33c>
ffffffffc020065a:	6125                	addi	sp,sp,96
ffffffffc020065c:	b4d9                	j	ffffffffc0200122 <cprintf>
ffffffffc020065e:	8552                	mv	a0,s4
ffffffffc0200660:	0e7010ef          	jal	ffffffffc0201f46 <strlen>
ffffffffc0200664:	89aa                	mv	s3,a0
ffffffffc0200666:	4619                	li	a2,6
ffffffffc0200668:	00002597          	auipc	a1,0x2
ffffffffc020066c:	d0058593          	addi	a1,a1,-768 # ffffffffc0202368 <etext+0x364>
ffffffffc0200670:	8552                	mv	a0,s4
ffffffffc0200672:	2981                	sext.w	s3,s3
ffffffffc0200674:	141010ef          	jal	ffffffffc0201fb4 <strncmp>
ffffffffc0200678:	e111                	bnez	a0,ffffffffc020067c <dtb_init+0x1b8>
ffffffffc020067a:	4b85                	li	s7,1
ffffffffc020067c:	0a11                	addi	s4,s4,4
ffffffffc020067e:	9a4e                	add	s4,s4,s3
ffffffffc0200680:	ffca7a13          	andi	s4,s4,-4
ffffffffc0200684:	89d2                	mv	s3,s4
ffffffffc0200686:	b7b9                	j	ffffffffc02005d4 <dtb_init+0x110>
ffffffffc0200688:	0049a783          	lw	a5,4(s3)
ffffffffc020068c:	f05a                	sd	s6,32(sp)
ffffffffc020068e:	0089a683          	lw	a3,8(s3)
ffffffffc0200692:	0087d71b          	srliw	a4,a5,0x8
ffffffffc0200696:	01879b1b          	slliw	s6,a5,0x18
ffffffffc020069a:	0187d61b          	srliw	a2,a5,0x18
ffffffffc020069e:	0107171b          	slliw	a4,a4,0x10
ffffffffc02006a2:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02006a6:	00cb6b33          	or	s6,s6,a2
ffffffffc02006aa:	01977733          	and	a4,a4,s9
ffffffffc02006ae:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006b2:	00eb6b33          	or	s6,s6,a4
ffffffffc02006b6:	00faf7b3          	and	a5,s5,a5
ffffffffc02006ba:	00fb6b33          	or	s6,s6,a5
ffffffffc02006be:	00c98a13          	addi	s4,s3,12
ffffffffc02006c2:	2b01                	sext.w	s6,s6
ffffffffc02006c4:	000b9c63          	bnez	s7,ffffffffc02006dc <dtb_init+0x218>
ffffffffc02006c8:	1b02                	slli	s6,s6,0x20
ffffffffc02006ca:	020b5b13          	srli	s6,s6,0x20
ffffffffc02006ce:	0a0d                	addi	s4,s4,3
ffffffffc02006d0:	9a5a                	add	s4,s4,s6
ffffffffc02006d2:	ffca7a13          	andi	s4,s4,-4
ffffffffc02006d6:	7b02                	ld	s6,32(sp)
ffffffffc02006d8:	89d2                	mv	s3,s4
ffffffffc02006da:	bded                	j	ffffffffc02005d4 <dtb_init+0x110>
ffffffffc02006dc:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02006e0:	0186979b          	slliw	a5,a3,0x18
ffffffffc02006e4:	0186d71b          	srliw	a4,a3,0x18
ffffffffc02006e8:	0105151b          	slliw	a0,a0,0x10
ffffffffc02006ec:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02006f0:	01957533          	and	a0,a0,s9
ffffffffc02006f4:	8fd9                	or	a5,a5,a4
ffffffffc02006f6:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006fa:	8d5d                	or	a0,a0,a5
ffffffffc02006fc:	00daf6b3          	and	a3,s5,a3
ffffffffc0200700:	8d55                	or	a0,a0,a3
ffffffffc0200702:	1502                	slli	a0,a0,0x20
ffffffffc0200704:	9101                	srli	a0,a0,0x20
ffffffffc0200706:	00002597          	auipc	a1,0x2
ffffffffc020070a:	c6a58593          	addi	a1,a1,-918 # ffffffffc0202370 <etext+0x36c>
ffffffffc020070e:	9522                	add	a0,a0,s0
ffffffffc0200710:	06d010ef          	jal	ffffffffc0201f7c <strcmp>
ffffffffc0200714:	f955                	bnez	a0,ffffffffc02006c8 <dtb_init+0x204>
ffffffffc0200716:	47bd                	li	a5,15
ffffffffc0200718:	fb67f8e3          	bgeu	a5,s6,ffffffffc02006c8 <dtb_init+0x204>
ffffffffc020071c:	00c9b783          	ld	a5,12(s3)
ffffffffc0200720:	0149b703          	ld	a4,20(s3)
ffffffffc0200724:	00002517          	auipc	a0,0x2
ffffffffc0200728:	c5450513          	addi	a0,a0,-940 # ffffffffc0202378 <etext+0x374>
ffffffffc020072c:	4207d693          	srai	a3,a5,0x20
ffffffffc0200730:	42075813          	srai	a6,a4,0x20
ffffffffc0200734:	0187d39b          	srliw	t2,a5,0x18
ffffffffc0200738:	0186d29b          	srliw	t0,a3,0x18
ffffffffc020073c:	01875f9b          	srliw	t6,a4,0x18
ffffffffc0200740:	01885f1b          	srliw	t5,a6,0x18
ffffffffc0200744:	0087d49b          	srliw	s1,a5,0x8
ffffffffc0200748:	0087541b          	srliw	s0,a4,0x8
ffffffffc020074c:	01879e9b          	slliw	t4,a5,0x18
ffffffffc0200750:	0107d59b          	srliw	a1,a5,0x10
ffffffffc0200754:	01869e1b          	slliw	t3,a3,0x18
ffffffffc0200758:	0187131b          	slliw	t1,a4,0x18
ffffffffc020075c:	0107561b          	srliw	a2,a4,0x10
ffffffffc0200760:	0188189b          	slliw	a7,a6,0x18
ffffffffc0200764:	83e1                	srli	a5,a5,0x18
ffffffffc0200766:	0106d69b          	srliw	a3,a3,0x10
ffffffffc020076a:	8361                	srli	a4,a4,0x18
ffffffffc020076c:	0108581b          	srliw	a6,a6,0x10
ffffffffc0200770:	005e6e33          	or	t3,t3,t0
ffffffffc0200774:	01e8e8b3          	or	a7,a7,t5
ffffffffc0200778:	0088181b          	slliw	a6,a6,0x8
ffffffffc020077c:	0104949b          	slliw	s1,s1,0x10
ffffffffc0200780:	0104141b          	slliw	s0,s0,0x10
ffffffffc0200784:	0085959b          	slliw	a1,a1,0x8
ffffffffc0200788:	0197f7b3          	and	a5,a5,s9
ffffffffc020078c:	0086969b          	slliw	a3,a3,0x8
ffffffffc0200790:	0086161b          	slliw	a2,a2,0x8
ffffffffc0200794:	01977733          	and	a4,a4,s9
ffffffffc0200798:	00daf6b3          	and	a3,s5,a3
ffffffffc020079c:	007eeeb3          	or	t4,t4,t2
ffffffffc02007a0:	01f36333          	or	t1,t1,t6
ffffffffc02007a4:	01c7e7b3          	or	a5,a5,t3
ffffffffc02007a8:	00caf633          	and	a2,s5,a2
ffffffffc02007ac:	01176733          	or	a4,a4,a7
ffffffffc02007b0:	00baf5b3          	and	a1,s5,a1
ffffffffc02007b4:	0194f4b3          	and	s1,s1,s9
ffffffffc02007b8:	010afab3          	and	s5,s5,a6
ffffffffc02007bc:	01947433          	and	s0,s0,s9
ffffffffc02007c0:	01d4e4b3          	or	s1,s1,t4
ffffffffc02007c4:	00646433          	or	s0,s0,t1
ffffffffc02007c8:	8fd5                	or	a5,a5,a3
ffffffffc02007ca:	01576733          	or	a4,a4,s5
ffffffffc02007ce:	8c51                	or	s0,s0,a2
ffffffffc02007d0:	8ccd                	or	s1,s1,a1
ffffffffc02007d2:	1782                	slli	a5,a5,0x20
ffffffffc02007d4:	1702                	slli	a4,a4,0x20
ffffffffc02007d6:	9381                	srli	a5,a5,0x20
ffffffffc02007d8:	9301                	srli	a4,a4,0x20
ffffffffc02007da:	1482                	slli	s1,s1,0x20
ffffffffc02007dc:	1402                	slli	s0,s0,0x20
ffffffffc02007de:	8cdd                	or	s1,s1,a5
ffffffffc02007e0:	8c59                	or	s0,s0,a4
ffffffffc02007e2:	941ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02007e6:	85a6                	mv	a1,s1
ffffffffc02007e8:	00002517          	auipc	a0,0x2
ffffffffc02007ec:	bb050513          	addi	a0,a0,-1104 # ffffffffc0202398 <etext+0x394>
ffffffffc02007f0:	933ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02007f4:	01445613          	srli	a2,s0,0x14
ffffffffc02007f8:	85a2                	mv	a1,s0
ffffffffc02007fa:	00002517          	auipc	a0,0x2
ffffffffc02007fe:	bb650513          	addi	a0,a0,-1098 # ffffffffc02023b0 <etext+0x3ac>
ffffffffc0200802:	921ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200806:	009405b3          	add	a1,s0,s1
ffffffffc020080a:	15fd                	addi	a1,a1,-1
ffffffffc020080c:	00002517          	auipc	a0,0x2
ffffffffc0200810:	bc450513          	addi	a0,a0,-1084 # ffffffffc02023d0 <etext+0x3cc>
ffffffffc0200814:	90fff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200818:	7b02                	ld	s6,32(sp)
ffffffffc020081a:	00007797          	auipc	a5,0x7
ffffffffc020081e:	c497b323          	sd	s1,-954(a5) # ffffffffc0207460 <memory_base>
ffffffffc0200822:	00007797          	auipc	a5,0x7
ffffffffc0200826:	c287bb23          	sd	s0,-970(a5) # ffffffffc0207458 <memory_size>
ffffffffc020082a:	b501                	j	ffffffffc020062a <dtb_init+0x166>

ffffffffc020082c <get_memory_base>:
ffffffffc020082c:	00007517          	auipc	a0,0x7
ffffffffc0200830:	c3453503          	ld	a0,-972(a0) # ffffffffc0207460 <memory_base>
ffffffffc0200834:	8082                	ret

ffffffffc0200836 <get_memory_size>:
ffffffffc0200836:	00007517          	auipc	a0,0x7
ffffffffc020083a:	c2253503          	ld	a0,-990(a0) # ffffffffc0207458 <memory_size>
ffffffffc020083e:	8082                	ret

ffffffffc0200840 <intr_enable>:
ffffffffc0200840:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200844:	8082                	ret

ffffffffc0200846 <intr_disable>:
ffffffffc0200846:	100177f3          	csrrci	a5,sstatus,2
ffffffffc020084a:	8082                	ret

ffffffffc020084c <idt_init>:
ffffffffc020084c:	14005073          	csrwi	sscratch,0
ffffffffc0200850:	00000797          	auipc	a5,0x0
ffffffffc0200854:	39478793          	addi	a5,a5,916 # ffffffffc0200be4 <__alltraps>
ffffffffc0200858:	10579073          	csrw	stvec,a5
ffffffffc020085c:	8082                	ret

ffffffffc020085e <print_regs>:
ffffffffc020085e:	610c                	ld	a1,0(a0)
ffffffffc0200860:	1141                	addi	sp,sp,-16
ffffffffc0200862:	e022                	sd	s0,0(sp)
ffffffffc0200864:	842a                	mv	s0,a0
ffffffffc0200866:	00002517          	auipc	a0,0x2
ffffffffc020086a:	bd250513          	addi	a0,a0,-1070 # ffffffffc0202438 <etext+0x434>
ffffffffc020086e:	e406                	sd	ra,8(sp)
ffffffffc0200870:	8b3ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200874:	640c                	ld	a1,8(s0)
ffffffffc0200876:	00002517          	auipc	a0,0x2
ffffffffc020087a:	bda50513          	addi	a0,a0,-1062 # ffffffffc0202450 <etext+0x44c>
ffffffffc020087e:	8a5ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200882:	680c                	ld	a1,16(s0)
ffffffffc0200884:	00002517          	auipc	a0,0x2
ffffffffc0200888:	be450513          	addi	a0,a0,-1052 # ffffffffc0202468 <etext+0x464>
ffffffffc020088c:	897ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200890:	6c0c                	ld	a1,24(s0)
ffffffffc0200892:	00002517          	auipc	a0,0x2
ffffffffc0200896:	bee50513          	addi	a0,a0,-1042 # ffffffffc0202480 <etext+0x47c>
ffffffffc020089a:	889ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc020089e:	700c                	ld	a1,32(s0)
ffffffffc02008a0:	00002517          	auipc	a0,0x2
ffffffffc02008a4:	bf850513          	addi	a0,a0,-1032 # ffffffffc0202498 <etext+0x494>
ffffffffc02008a8:	87bff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02008ac:	740c                	ld	a1,40(s0)
ffffffffc02008ae:	00002517          	auipc	a0,0x2
ffffffffc02008b2:	c0250513          	addi	a0,a0,-1022 # ffffffffc02024b0 <etext+0x4ac>
ffffffffc02008b6:	86dff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02008ba:	780c                	ld	a1,48(s0)
ffffffffc02008bc:	00002517          	auipc	a0,0x2
ffffffffc02008c0:	c0c50513          	addi	a0,a0,-1012 # ffffffffc02024c8 <etext+0x4c4>
ffffffffc02008c4:	85fff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02008c8:	7c0c                	ld	a1,56(s0)
ffffffffc02008ca:	00002517          	auipc	a0,0x2
ffffffffc02008ce:	c1650513          	addi	a0,a0,-1002 # ffffffffc02024e0 <etext+0x4dc>
ffffffffc02008d2:	851ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02008d6:	602c                	ld	a1,64(s0)
ffffffffc02008d8:	00002517          	auipc	a0,0x2
ffffffffc02008dc:	c2050513          	addi	a0,a0,-992 # ffffffffc02024f8 <etext+0x4f4>
ffffffffc02008e0:	843ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02008e4:	642c                	ld	a1,72(s0)
ffffffffc02008e6:	00002517          	auipc	a0,0x2
ffffffffc02008ea:	c2a50513          	addi	a0,a0,-982 # ffffffffc0202510 <etext+0x50c>
ffffffffc02008ee:	835ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02008f2:	682c                	ld	a1,80(s0)
ffffffffc02008f4:	00002517          	auipc	a0,0x2
ffffffffc02008f8:	c3450513          	addi	a0,a0,-972 # ffffffffc0202528 <etext+0x524>
ffffffffc02008fc:	827ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200900:	6c2c                	ld	a1,88(s0)
ffffffffc0200902:	00002517          	auipc	a0,0x2
ffffffffc0200906:	c3e50513          	addi	a0,a0,-962 # ffffffffc0202540 <etext+0x53c>
ffffffffc020090a:	819ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc020090e:	702c                	ld	a1,96(s0)
ffffffffc0200910:	00002517          	auipc	a0,0x2
ffffffffc0200914:	c4850513          	addi	a0,a0,-952 # ffffffffc0202558 <etext+0x554>
ffffffffc0200918:	80bff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc020091c:	742c                	ld	a1,104(s0)
ffffffffc020091e:	00002517          	auipc	a0,0x2
ffffffffc0200922:	c5250513          	addi	a0,a0,-942 # ffffffffc0202570 <etext+0x56c>
ffffffffc0200926:	ffcff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc020092a:	782c                	ld	a1,112(s0)
ffffffffc020092c:	00002517          	auipc	a0,0x2
ffffffffc0200930:	c5c50513          	addi	a0,a0,-932 # ffffffffc0202588 <etext+0x584>
ffffffffc0200934:	feeff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200938:	7c2c                	ld	a1,120(s0)
ffffffffc020093a:	00002517          	auipc	a0,0x2
ffffffffc020093e:	c6650513          	addi	a0,a0,-922 # ffffffffc02025a0 <etext+0x59c>
ffffffffc0200942:	fe0ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200946:	604c                	ld	a1,128(s0)
ffffffffc0200948:	00002517          	auipc	a0,0x2
ffffffffc020094c:	c7050513          	addi	a0,a0,-912 # ffffffffc02025b8 <etext+0x5b4>
ffffffffc0200950:	fd2ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200954:	644c                	ld	a1,136(s0)
ffffffffc0200956:	00002517          	auipc	a0,0x2
ffffffffc020095a:	c7a50513          	addi	a0,a0,-902 # ffffffffc02025d0 <etext+0x5cc>
ffffffffc020095e:	fc4ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200962:	684c                	ld	a1,144(s0)
ffffffffc0200964:	00002517          	auipc	a0,0x2
ffffffffc0200968:	c8450513          	addi	a0,a0,-892 # ffffffffc02025e8 <etext+0x5e4>
ffffffffc020096c:	fb6ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200970:	6c4c                	ld	a1,152(s0)
ffffffffc0200972:	00002517          	auipc	a0,0x2
ffffffffc0200976:	c8e50513          	addi	a0,a0,-882 # ffffffffc0202600 <etext+0x5fc>
ffffffffc020097a:	fa8ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc020097e:	704c                	ld	a1,160(s0)
ffffffffc0200980:	00002517          	auipc	a0,0x2
ffffffffc0200984:	c9850513          	addi	a0,a0,-872 # ffffffffc0202618 <etext+0x614>
ffffffffc0200988:	f9aff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc020098c:	744c                	ld	a1,168(s0)
ffffffffc020098e:	00002517          	auipc	a0,0x2
ffffffffc0200992:	ca250513          	addi	a0,a0,-862 # ffffffffc0202630 <etext+0x62c>
ffffffffc0200996:	f8cff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc020099a:	784c                	ld	a1,176(s0)
ffffffffc020099c:	00002517          	auipc	a0,0x2
ffffffffc02009a0:	cac50513          	addi	a0,a0,-852 # ffffffffc0202648 <etext+0x644>
ffffffffc02009a4:	f7eff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02009a8:	7c4c                	ld	a1,184(s0)
ffffffffc02009aa:	00002517          	auipc	a0,0x2
ffffffffc02009ae:	cb650513          	addi	a0,a0,-842 # ffffffffc0202660 <etext+0x65c>
ffffffffc02009b2:	f70ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02009b6:	606c                	ld	a1,192(s0)
ffffffffc02009b8:	00002517          	auipc	a0,0x2
ffffffffc02009bc:	cc050513          	addi	a0,a0,-832 # ffffffffc0202678 <etext+0x674>
ffffffffc02009c0:	f62ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02009c4:	646c                	ld	a1,200(s0)
ffffffffc02009c6:	00002517          	auipc	a0,0x2
ffffffffc02009ca:	cca50513          	addi	a0,a0,-822 # ffffffffc0202690 <etext+0x68c>
ffffffffc02009ce:	f54ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02009d2:	686c                	ld	a1,208(s0)
ffffffffc02009d4:	00002517          	auipc	a0,0x2
ffffffffc02009d8:	cd450513          	addi	a0,a0,-812 # ffffffffc02026a8 <etext+0x6a4>
ffffffffc02009dc:	f46ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02009e0:	6c6c                	ld	a1,216(s0)
ffffffffc02009e2:	00002517          	auipc	a0,0x2
ffffffffc02009e6:	cde50513          	addi	a0,a0,-802 # ffffffffc02026c0 <etext+0x6bc>
ffffffffc02009ea:	f38ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02009ee:	706c                	ld	a1,224(s0)
ffffffffc02009f0:	00002517          	auipc	a0,0x2
ffffffffc02009f4:	ce850513          	addi	a0,a0,-792 # ffffffffc02026d8 <etext+0x6d4>
ffffffffc02009f8:	f2aff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02009fc:	746c                	ld	a1,232(s0)
ffffffffc02009fe:	00002517          	auipc	a0,0x2
ffffffffc0200a02:	cf250513          	addi	a0,a0,-782 # ffffffffc02026f0 <etext+0x6ec>
ffffffffc0200a06:	f1cff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200a0a:	786c                	ld	a1,240(s0)
ffffffffc0200a0c:	00002517          	auipc	a0,0x2
ffffffffc0200a10:	cfc50513          	addi	a0,a0,-772 # ffffffffc0202708 <etext+0x704>
ffffffffc0200a14:	f0eff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200a18:	7c6c                	ld	a1,248(s0)
ffffffffc0200a1a:	6402                	ld	s0,0(sp)
ffffffffc0200a1c:	60a2                	ld	ra,8(sp)
ffffffffc0200a1e:	00002517          	auipc	a0,0x2
ffffffffc0200a22:	d0250513          	addi	a0,a0,-766 # ffffffffc0202720 <etext+0x71c>
ffffffffc0200a26:	0141                	addi	sp,sp,16
ffffffffc0200a28:	efaff06f          	j	ffffffffc0200122 <cprintf>

ffffffffc0200a2c <print_trapframe>:
ffffffffc0200a2c:	1141                	addi	sp,sp,-16
ffffffffc0200a2e:	e022                	sd	s0,0(sp)
ffffffffc0200a30:	85aa                	mv	a1,a0
ffffffffc0200a32:	842a                	mv	s0,a0
ffffffffc0200a34:	00002517          	auipc	a0,0x2
ffffffffc0200a38:	d0450513          	addi	a0,a0,-764 # ffffffffc0202738 <etext+0x734>
ffffffffc0200a3c:	e406                	sd	ra,8(sp)
ffffffffc0200a3e:	ee4ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200a42:	8522                	mv	a0,s0
ffffffffc0200a44:	e1bff0ef          	jal	ffffffffc020085e <print_regs>
ffffffffc0200a48:	10043583          	ld	a1,256(s0)
ffffffffc0200a4c:	00002517          	auipc	a0,0x2
ffffffffc0200a50:	d0450513          	addi	a0,a0,-764 # ffffffffc0202750 <etext+0x74c>
ffffffffc0200a54:	eceff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200a58:	10843583          	ld	a1,264(s0)
ffffffffc0200a5c:	00002517          	auipc	a0,0x2
ffffffffc0200a60:	d0c50513          	addi	a0,a0,-756 # ffffffffc0202768 <etext+0x764>
ffffffffc0200a64:	ebeff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200a68:	11043583          	ld	a1,272(s0)
ffffffffc0200a6c:	00002517          	auipc	a0,0x2
ffffffffc0200a70:	d1450513          	addi	a0,a0,-748 # ffffffffc0202780 <etext+0x77c>
ffffffffc0200a74:	eaeff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200a78:	11843583          	ld	a1,280(s0)
ffffffffc0200a7c:	6402                	ld	s0,0(sp)
ffffffffc0200a7e:	60a2                	ld	ra,8(sp)
ffffffffc0200a80:	00002517          	auipc	a0,0x2
ffffffffc0200a84:	d1850513          	addi	a0,a0,-744 # ffffffffc0202798 <etext+0x794>
ffffffffc0200a88:	0141                	addi	sp,sp,16
ffffffffc0200a8a:	e98ff06f          	j	ffffffffc0200122 <cprintf>

ffffffffc0200a8e <interrupt_handler>:
ffffffffc0200a8e:	11853783          	ld	a5,280(a0)
ffffffffc0200a92:	472d                	li	a4,11
ffffffffc0200a94:	0786                	slli	a5,a5,0x1
ffffffffc0200a96:	8385                	srli	a5,a5,0x1
ffffffffc0200a98:	08f76363          	bltu	a4,a5,ffffffffc0200b1e <interrupt_handler+0x90>
ffffffffc0200a9c:	00002717          	auipc	a4,0x2
ffffffffc0200aa0:	49470713          	addi	a4,a4,1172 # ffffffffc0202f30 <commands+0x48>
ffffffffc0200aa4:	078a                	slli	a5,a5,0x2
ffffffffc0200aa6:	97ba                	add	a5,a5,a4
ffffffffc0200aa8:	439c                	lw	a5,0(a5)
ffffffffc0200aaa:	97ba                	add	a5,a5,a4
ffffffffc0200aac:	8782                	jr	a5
ffffffffc0200aae:	00002517          	auipc	a0,0x2
ffffffffc0200ab2:	d6250513          	addi	a0,a0,-670 # ffffffffc0202810 <etext+0x80c>
ffffffffc0200ab6:	e6cff06f          	j	ffffffffc0200122 <cprintf>
ffffffffc0200aba:	00002517          	auipc	a0,0x2
ffffffffc0200abe:	d3650513          	addi	a0,a0,-714 # ffffffffc02027f0 <etext+0x7ec>
ffffffffc0200ac2:	e60ff06f          	j	ffffffffc0200122 <cprintf>
ffffffffc0200ac6:	00002517          	auipc	a0,0x2
ffffffffc0200aca:	cea50513          	addi	a0,a0,-790 # ffffffffc02027b0 <etext+0x7ac>
ffffffffc0200ace:	e54ff06f          	j	ffffffffc0200122 <cprintf>
ffffffffc0200ad2:	00002517          	auipc	a0,0x2
ffffffffc0200ad6:	d5e50513          	addi	a0,a0,-674 # ffffffffc0202830 <etext+0x82c>
ffffffffc0200ada:	e48ff06f          	j	ffffffffc0200122 <cprintf>
ffffffffc0200ade:	1141                	addi	sp,sp,-16
ffffffffc0200ae0:	e406                	sd	ra,8(sp)
ffffffffc0200ae2:	9c5ff0ef          	jal	ffffffffc02004a6 <clock_set_next_event>
ffffffffc0200ae6:	00007797          	auipc	a5,0x7
ffffffffc0200aea:	96a78793          	addi	a5,a5,-1686 # ffffffffc0207450 <ticks>
ffffffffc0200aee:	6398                	ld	a4,0(a5)
ffffffffc0200af0:	0705                	addi	a4,a4,1
ffffffffc0200af2:	e398                	sd	a4,0(a5)
ffffffffc0200af4:	639c                	ld	a5,0(a5)
ffffffffc0200af6:	06400713          	li	a4,100
ffffffffc0200afa:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200afe:	c38d                	beqz	a5,ffffffffc0200b20 <interrupt_handler+0x92>
ffffffffc0200b00:	60a2                	ld	ra,8(sp)
ffffffffc0200b02:	0141                	addi	sp,sp,16
ffffffffc0200b04:	8082                	ret
ffffffffc0200b06:	00002517          	auipc	a0,0x2
ffffffffc0200b0a:	d5250513          	addi	a0,a0,-686 # ffffffffc0202858 <etext+0x854>
ffffffffc0200b0e:	e14ff06f          	j	ffffffffc0200122 <cprintf>
ffffffffc0200b12:	00002517          	auipc	a0,0x2
ffffffffc0200b16:	cbe50513          	addi	a0,a0,-834 # ffffffffc02027d0 <etext+0x7cc>
ffffffffc0200b1a:	e08ff06f          	j	ffffffffc0200122 <cprintf>
ffffffffc0200b1e:	b739                	j	ffffffffc0200a2c <print_trapframe>
ffffffffc0200b20:	06400593          	li	a1,100
ffffffffc0200b24:	00002517          	auipc	a0,0x2
ffffffffc0200b28:	d2450513          	addi	a0,a0,-732 # ffffffffc0202848 <etext+0x844>
ffffffffc0200b2c:	df6ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200b30:	00007717          	auipc	a4,0x7
ffffffffc0200b34:	93870713          	addi	a4,a4,-1736 # ffffffffc0207468 <print_count>
ffffffffc0200b38:	431c                	lw	a5,0(a4)
ffffffffc0200b3a:	46a5                	li	a3,9
ffffffffc0200b3c:	0017861b          	addiw	a2,a5,1
ffffffffc0200b40:	c310                	sw	a2,0(a4)
ffffffffc0200b42:	fac6dfe3          	bge	a3,a2,ffffffffc0200b00 <interrupt_handler+0x72>
ffffffffc0200b46:	60a2                	ld	ra,8(sp)
ffffffffc0200b48:	0141                	addi	sp,sp,16
ffffffffc0200b4a:	3e20106f          	j	ffffffffc0201f2c <sbi_shutdown>

ffffffffc0200b4e <exception_handler>:
ffffffffc0200b4e:	11853783          	ld	a5,280(a0)
ffffffffc0200b52:	1141                	addi	sp,sp,-16
ffffffffc0200b54:	e022                	sd	s0,0(sp)
ffffffffc0200b56:	e406                	sd	ra,8(sp)
ffffffffc0200b58:	470d                	li	a4,3
ffffffffc0200b5a:	842a                	mv	s0,a0
ffffffffc0200b5c:	04e78663          	beq	a5,a4,ffffffffc0200ba8 <exception_handler+0x5a>
ffffffffc0200b60:	02f76c63          	bltu	a4,a5,ffffffffc0200b98 <exception_handler+0x4a>
ffffffffc0200b64:	4709                	li	a4,2
ffffffffc0200b66:	02e79563          	bne	a5,a4,ffffffffc0200b90 <exception_handler+0x42>
ffffffffc0200b6a:	00002517          	auipc	a0,0x2
ffffffffc0200b6e:	d0e50513          	addi	a0,a0,-754 # ffffffffc0202878 <etext+0x874>
ffffffffc0200b72:	db0ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200b76:	10843583          	ld	a1,264(s0)
ffffffffc0200b7a:	00002517          	auipc	a0,0x2
ffffffffc0200b7e:	d2650513          	addi	a0,a0,-730 # ffffffffc02028a0 <etext+0x89c>
ffffffffc0200b82:	da0ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200b86:	10843783          	ld	a5,264(s0)
ffffffffc0200b8a:	0791                	addi	a5,a5,4
ffffffffc0200b8c:	10f43423          	sd	a5,264(s0)
ffffffffc0200b90:	60a2                	ld	ra,8(sp)
ffffffffc0200b92:	6402                	ld	s0,0(sp)
ffffffffc0200b94:	0141                	addi	sp,sp,16
ffffffffc0200b96:	8082                	ret
ffffffffc0200b98:	17f1                	addi	a5,a5,-4
ffffffffc0200b9a:	471d                	li	a4,7
ffffffffc0200b9c:	fef77ae3          	bgeu	a4,a5,ffffffffc0200b90 <exception_handler+0x42>
ffffffffc0200ba0:	6402                	ld	s0,0(sp)
ffffffffc0200ba2:	60a2                	ld	ra,8(sp)
ffffffffc0200ba4:	0141                	addi	sp,sp,16
ffffffffc0200ba6:	b559                	j	ffffffffc0200a2c <print_trapframe>
ffffffffc0200ba8:	00002517          	auipc	a0,0x2
ffffffffc0200bac:	d2050513          	addi	a0,a0,-736 # ffffffffc02028c8 <etext+0x8c4>
ffffffffc0200bb0:	d72ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200bb4:	10843583          	ld	a1,264(s0)
ffffffffc0200bb8:	00002517          	auipc	a0,0x2
ffffffffc0200bbc:	d3050513          	addi	a0,a0,-720 # ffffffffc02028e8 <etext+0x8e4>
ffffffffc0200bc0:	d62ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200bc4:	10843783          	ld	a5,264(s0)
ffffffffc0200bc8:	60a2                	ld	ra,8(sp)
ffffffffc0200bca:	0791                	addi	a5,a5,4
ffffffffc0200bcc:	10f43423          	sd	a5,264(s0)
ffffffffc0200bd0:	6402                	ld	s0,0(sp)
ffffffffc0200bd2:	0141                	addi	sp,sp,16
ffffffffc0200bd4:	8082                	ret

ffffffffc0200bd6 <trap>:
ffffffffc0200bd6:	11853783          	ld	a5,280(a0)
ffffffffc0200bda:	0007c363          	bltz	a5,ffffffffc0200be0 <trap+0xa>
ffffffffc0200bde:	bf85                	j	ffffffffc0200b4e <exception_handler>
ffffffffc0200be0:	b57d                	j	ffffffffc0200a8e <interrupt_handler>
	...

ffffffffc0200be4 <__alltraps>:
ffffffffc0200be4:	14011073          	csrw	sscratch,sp
ffffffffc0200be8:	712d                	addi	sp,sp,-288
ffffffffc0200bea:	e002                	sd	zero,0(sp)
ffffffffc0200bec:	e406                	sd	ra,8(sp)
ffffffffc0200bee:	ec0e                	sd	gp,24(sp)
ffffffffc0200bf0:	f012                	sd	tp,32(sp)
ffffffffc0200bf2:	f416                	sd	t0,40(sp)
ffffffffc0200bf4:	f81a                	sd	t1,48(sp)
ffffffffc0200bf6:	fc1e                	sd	t2,56(sp)
ffffffffc0200bf8:	e0a2                	sd	s0,64(sp)
ffffffffc0200bfa:	e4a6                	sd	s1,72(sp)
ffffffffc0200bfc:	e8aa                	sd	a0,80(sp)
ffffffffc0200bfe:	ecae                	sd	a1,88(sp)
ffffffffc0200c00:	f0b2                	sd	a2,96(sp)
ffffffffc0200c02:	f4b6                	sd	a3,104(sp)
ffffffffc0200c04:	f8ba                	sd	a4,112(sp)
ffffffffc0200c06:	fcbe                	sd	a5,120(sp)
ffffffffc0200c08:	e142                	sd	a6,128(sp)
ffffffffc0200c0a:	e546                	sd	a7,136(sp)
ffffffffc0200c0c:	e94a                	sd	s2,144(sp)
ffffffffc0200c0e:	ed4e                	sd	s3,152(sp)
ffffffffc0200c10:	f152                	sd	s4,160(sp)
ffffffffc0200c12:	f556                	sd	s5,168(sp)
ffffffffc0200c14:	f95a                	sd	s6,176(sp)
ffffffffc0200c16:	fd5e                	sd	s7,184(sp)
ffffffffc0200c18:	e1e2                	sd	s8,192(sp)
ffffffffc0200c1a:	e5e6                	sd	s9,200(sp)
ffffffffc0200c1c:	e9ea                	sd	s10,208(sp)
ffffffffc0200c1e:	edee                	sd	s11,216(sp)
ffffffffc0200c20:	f1f2                	sd	t3,224(sp)
ffffffffc0200c22:	f5f6                	sd	t4,232(sp)
ffffffffc0200c24:	f9fa                	sd	t5,240(sp)
ffffffffc0200c26:	fdfe                	sd	t6,248(sp)
ffffffffc0200c28:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200c2c:	100024f3          	csrr	s1,sstatus
ffffffffc0200c30:	14102973          	csrr	s2,sepc
ffffffffc0200c34:	143029f3          	csrr	s3,stval
ffffffffc0200c38:	14202a73          	csrr	s4,scause
ffffffffc0200c3c:	e822                	sd	s0,16(sp)
ffffffffc0200c3e:	e226                	sd	s1,256(sp)
ffffffffc0200c40:	e64a                	sd	s2,264(sp)
ffffffffc0200c42:	ea4e                	sd	s3,272(sp)
ffffffffc0200c44:	ee52                	sd	s4,280(sp)
ffffffffc0200c46:	850a                	mv	a0,sp
ffffffffc0200c48:	f8fff0ef          	jal	ffffffffc0200bd6 <trap>

ffffffffc0200c4c <__trapret>:
ffffffffc0200c4c:	6492                	ld	s1,256(sp)
ffffffffc0200c4e:	6932                	ld	s2,264(sp)
ffffffffc0200c50:	10049073          	csrw	sstatus,s1
ffffffffc0200c54:	14191073          	csrw	sepc,s2
ffffffffc0200c58:	60a2                	ld	ra,8(sp)
ffffffffc0200c5a:	61e2                	ld	gp,24(sp)
ffffffffc0200c5c:	7202                	ld	tp,32(sp)
ffffffffc0200c5e:	72a2                	ld	t0,40(sp)
ffffffffc0200c60:	7342                	ld	t1,48(sp)
ffffffffc0200c62:	73e2                	ld	t2,56(sp)
ffffffffc0200c64:	6406                	ld	s0,64(sp)
ffffffffc0200c66:	64a6                	ld	s1,72(sp)
ffffffffc0200c68:	6546                	ld	a0,80(sp)
ffffffffc0200c6a:	65e6                	ld	a1,88(sp)
ffffffffc0200c6c:	7606                	ld	a2,96(sp)
ffffffffc0200c6e:	76a6                	ld	a3,104(sp)
ffffffffc0200c70:	7746                	ld	a4,112(sp)
ffffffffc0200c72:	77e6                	ld	a5,120(sp)
ffffffffc0200c74:	680a                	ld	a6,128(sp)
ffffffffc0200c76:	68aa                	ld	a7,136(sp)
ffffffffc0200c78:	694a                	ld	s2,144(sp)
ffffffffc0200c7a:	69ea                	ld	s3,152(sp)
ffffffffc0200c7c:	7a0a                	ld	s4,160(sp)
ffffffffc0200c7e:	7aaa                	ld	s5,168(sp)
ffffffffc0200c80:	7b4a                	ld	s6,176(sp)
ffffffffc0200c82:	7bea                	ld	s7,184(sp)
ffffffffc0200c84:	6c0e                	ld	s8,192(sp)
ffffffffc0200c86:	6cae                	ld	s9,200(sp)
ffffffffc0200c88:	6d4e                	ld	s10,208(sp)
ffffffffc0200c8a:	6dee                	ld	s11,216(sp)
ffffffffc0200c8c:	7e0e                	ld	t3,224(sp)
ffffffffc0200c8e:	7eae                	ld	t4,232(sp)
ffffffffc0200c90:	7f4e                	ld	t5,240(sp)
ffffffffc0200c92:	7fee                	ld	t6,248(sp)
ffffffffc0200c94:	6142                	ld	sp,16(sp)
ffffffffc0200c96:	10200073          	sret

ffffffffc0200c9a <default_init>:
ffffffffc0200c9a:	00006797          	auipc	a5,0x6
ffffffffc0200c9e:	38e78793          	addi	a5,a5,910 # ffffffffc0207028 <free_area>
ffffffffc0200ca2:	e79c                	sd	a5,8(a5)
ffffffffc0200ca4:	e39c                	sd	a5,0(a5)
ffffffffc0200ca6:	0007a823          	sw	zero,16(a5)
ffffffffc0200caa:	8082                	ret

ffffffffc0200cac <default_nr_free_pages>:
ffffffffc0200cac:	00006517          	auipc	a0,0x6
ffffffffc0200cb0:	38c56503          	lwu	a0,908(a0) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200cb4:	8082                	ret

ffffffffc0200cb6 <default_check>:
ffffffffc0200cb6:	715d                	addi	sp,sp,-80
ffffffffc0200cb8:	e0a2                	sd	s0,64(sp)
ffffffffc0200cba:	00006417          	auipc	s0,0x6
ffffffffc0200cbe:	36e40413          	addi	s0,s0,878 # ffffffffc0207028 <free_area>
ffffffffc0200cc2:	641c                	ld	a5,8(s0)
ffffffffc0200cc4:	e486                	sd	ra,72(sp)
ffffffffc0200cc6:	fc26                	sd	s1,56(sp)
ffffffffc0200cc8:	f84a                	sd	s2,48(sp)
ffffffffc0200cca:	f44e                	sd	s3,40(sp)
ffffffffc0200ccc:	f052                	sd	s4,32(sp)
ffffffffc0200cce:	ec56                	sd	s5,24(sp)
ffffffffc0200cd0:	e85a                	sd	s6,16(sp)
ffffffffc0200cd2:	e45e                	sd	s7,8(sp)
ffffffffc0200cd4:	e062                	sd	s8,0(sp)
ffffffffc0200cd6:	2e878063          	beq	a5,s0,ffffffffc0200fb6 <default_check+0x300>
ffffffffc0200cda:	4481                	li	s1,0
ffffffffc0200cdc:	4901                	li	s2,0
ffffffffc0200cde:	ff07b703          	ld	a4,-16(a5)
ffffffffc0200ce2:	8b09                	andi	a4,a4,2
ffffffffc0200ce4:	2c070d63          	beqz	a4,ffffffffc0200fbe <default_check+0x308>
ffffffffc0200ce8:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200cec:	679c                	ld	a5,8(a5)
ffffffffc0200cee:	2905                	addiw	s2,s2,1
ffffffffc0200cf0:	9cb9                	addw	s1,s1,a4
ffffffffc0200cf2:	fe8796e3          	bne	a5,s0,ffffffffc0200cde <default_check+0x28>
ffffffffc0200cf6:	89a6                	mv	s3,s1
ffffffffc0200cf8:	30b000ef          	jal	ffffffffc0201802 <nr_free_pages>
ffffffffc0200cfc:	73351163          	bne	a0,s3,ffffffffc020141e <default_check+0x768>
ffffffffc0200d00:	4505                	li	a0,1
ffffffffc0200d02:	283000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200d06:	8a2a                	mv	s4,a0
ffffffffc0200d08:	44050b63          	beqz	a0,ffffffffc020115e <default_check+0x4a8>
ffffffffc0200d0c:	4505                	li	a0,1
ffffffffc0200d0e:	277000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200d12:	89aa                	mv	s3,a0
ffffffffc0200d14:	72050563          	beqz	a0,ffffffffc020143e <default_check+0x788>
ffffffffc0200d18:	4505                	li	a0,1
ffffffffc0200d1a:	26b000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200d1e:	8aaa                	mv	s5,a0
ffffffffc0200d20:	4a050f63          	beqz	a0,ffffffffc02011de <default_check+0x528>
ffffffffc0200d24:	2b3a0d63          	beq	s4,s3,ffffffffc0200fde <default_check+0x328>
ffffffffc0200d28:	2aaa0b63          	beq	s4,a0,ffffffffc0200fde <default_check+0x328>
ffffffffc0200d2c:	2aa98963          	beq	s3,a0,ffffffffc0200fde <default_check+0x328>
ffffffffc0200d30:	000a2783          	lw	a5,0(s4)
ffffffffc0200d34:	2c079563          	bnez	a5,ffffffffc0200ffe <default_check+0x348>
ffffffffc0200d38:	0009a783          	lw	a5,0(s3)
ffffffffc0200d3c:	2c079163          	bnez	a5,ffffffffc0200ffe <default_check+0x348>
ffffffffc0200d40:	411c                	lw	a5,0(a0)
ffffffffc0200d42:	2a079e63          	bnez	a5,ffffffffc0200ffe <default_check+0x348>
ffffffffc0200d46:	fcccd7b7          	lui	a5,0xfcccd
ffffffffc0200d4a:	ccd78793          	addi	a5,a5,-819 # fffffffffccccccd <end+0x3cac5825>
ffffffffc0200d4e:	07b2                	slli	a5,a5,0xc
ffffffffc0200d50:	ccd78793          	addi	a5,a5,-819
ffffffffc0200d54:	07b2                	slli	a5,a5,0xc
ffffffffc0200d56:	00006717          	auipc	a4,0x6
ffffffffc0200d5a:	74273703          	ld	a4,1858(a4) # ffffffffc0207498 <pages>
ffffffffc0200d5e:	ccd78793          	addi	a5,a5,-819
ffffffffc0200d62:	40ea06b3          	sub	a3,s4,a4
ffffffffc0200d66:	07b2                	slli	a5,a5,0xc
ffffffffc0200d68:	868d                	srai	a3,a3,0x3
ffffffffc0200d6a:	ccd78793          	addi	a5,a5,-819
ffffffffc0200d6e:	02f686b3          	mul	a3,a3,a5
ffffffffc0200d72:	00002597          	auipc	a1,0x2
ffffffffc0200d76:	3b65b583          	ld	a1,950(a1) # ffffffffc0203128 <nbase>
ffffffffc0200d7a:	00006617          	auipc	a2,0x6
ffffffffc0200d7e:	71663603          	ld	a2,1814(a2) # ffffffffc0207490 <npage>
ffffffffc0200d82:	0632                	slli	a2,a2,0xc
ffffffffc0200d84:	96ae                	add	a3,a3,a1
ffffffffc0200d86:	06b2                	slli	a3,a3,0xc
ffffffffc0200d88:	28c6fb63          	bgeu	a3,a2,ffffffffc020101e <default_check+0x368>
ffffffffc0200d8c:	40e986b3          	sub	a3,s3,a4
ffffffffc0200d90:	868d                	srai	a3,a3,0x3
ffffffffc0200d92:	02f686b3          	mul	a3,a3,a5
ffffffffc0200d96:	96ae                	add	a3,a3,a1
ffffffffc0200d98:	06b2                	slli	a3,a3,0xc
ffffffffc0200d9a:	4cc6f263          	bgeu	a3,a2,ffffffffc020125e <default_check+0x5a8>
ffffffffc0200d9e:	40e50733          	sub	a4,a0,a4
ffffffffc0200da2:	870d                	srai	a4,a4,0x3
ffffffffc0200da4:	02f707b3          	mul	a5,a4,a5
ffffffffc0200da8:	97ae                	add	a5,a5,a1
ffffffffc0200daa:	07b2                	slli	a5,a5,0xc
ffffffffc0200dac:	30c7f963          	bgeu	a5,a2,ffffffffc02010be <default_check+0x408>
ffffffffc0200db0:	4505                	li	a0,1
ffffffffc0200db2:	00043c03          	ld	s8,0(s0)
ffffffffc0200db6:	00843b83          	ld	s7,8(s0)
ffffffffc0200dba:	01042b03          	lw	s6,16(s0)
ffffffffc0200dbe:	e400                	sd	s0,8(s0)
ffffffffc0200dc0:	e000                	sd	s0,0(s0)
ffffffffc0200dc2:	00006797          	auipc	a5,0x6
ffffffffc0200dc6:	2607ab23          	sw	zero,630(a5) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200dca:	1bb000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200dce:	2c051863          	bnez	a0,ffffffffc020109e <default_check+0x3e8>
ffffffffc0200dd2:	4585                	li	a1,1
ffffffffc0200dd4:	8552                	mv	a0,s4
ffffffffc0200dd6:	1ed000ef          	jal	ffffffffc02017c2 <free_pages>
ffffffffc0200dda:	4585                	li	a1,1
ffffffffc0200ddc:	854e                	mv	a0,s3
ffffffffc0200dde:	1e5000ef          	jal	ffffffffc02017c2 <free_pages>
ffffffffc0200de2:	4585                	li	a1,1
ffffffffc0200de4:	8556                	mv	a0,s5
ffffffffc0200de6:	1dd000ef          	jal	ffffffffc02017c2 <free_pages>
ffffffffc0200dea:	4818                	lw	a4,16(s0)
ffffffffc0200dec:	478d                	li	a5,3
ffffffffc0200dee:	28f71863          	bne	a4,a5,ffffffffc020107e <default_check+0x3c8>
ffffffffc0200df2:	4505                	li	a0,1
ffffffffc0200df4:	191000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200df8:	89aa                	mv	s3,a0
ffffffffc0200dfa:	26050263          	beqz	a0,ffffffffc020105e <default_check+0x3a8>
ffffffffc0200dfe:	4505                	li	a0,1
ffffffffc0200e00:	185000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200e04:	8aaa                	mv	s5,a0
ffffffffc0200e06:	3a050c63          	beqz	a0,ffffffffc02011be <default_check+0x508>
ffffffffc0200e0a:	4505                	li	a0,1
ffffffffc0200e0c:	179000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200e10:	8a2a                	mv	s4,a0
ffffffffc0200e12:	38050663          	beqz	a0,ffffffffc020119e <default_check+0x4e8>
ffffffffc0200e16:	4505                	li	a0,1
ffffffffc0200e18:	16d000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200e1c:	36051163          	bnez	a0,ffffffffc020117e <default_check+0x4c8>
ffffffffc0200e20:	4585                	li	a1,1
ffffffffc0200e22:	854e                	mv	a0,s3
ffffffffc0200e24:	19f000ef          	jal	ffffffffc02017c2 <free_pages>
ffffffffc0200e28:	641c                	ld	a5,8(s0)
ffffffffc0200e2a:	20878a63          	beq	a5,s0,ffffffffc020103e <default_check+0x388>
ffffffffc0200e2e:	4505                	li	a0,1
ffffffffc0200e30:	155000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200e34:	30a99563          	bne	s3,a0,ffffffffc020113e <default_check+0x488>
ffffffffc0200e38:	4505                	li	a0,1
ffffffffc0200e3a:	14b000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200e3e:	2e051063          	bnez	a0,ffffffffc020111e <default_check+0x468>
ffffffffc0200e42:	481c                	lw	a5,16(s0)
ffffffffc0200e44:	2a079d63          	bnez	a5,ffffffffc02010fe <default_check+0x448>
ffffffffc0200e48:	854e                	mv	a0,s3
ffffffffc0200e4a:	4585                	li	a1,1
ffffffffc0200e4c:	01843023          	sd	s8,0(s0)
ffffffffc0200e50:	01743423          	sd	s7,8(s0)
ffffffffc0200e54:	01642823          	sw	s6,16(s0)
ffffffffc0200e58:	16b000ef          	jal	ffffffffc02017c2 <free_pages>
ffffffffc0200e5c:	4585                	li	a1,1
ffffffffc0200e5e:	8556                	mv	a0,s5
ffffffffc0200e60:	163000ef          	jal	ffffffffc02017c2 <free_pages>
ffffffffc0200e64:	4585                	li	a1,1
ffffffffc0200e66:	8552                	mv	a0,s4
ffffffffc0200e68:	15b000ef          	jal	ffffffffc02017c2 <free_pages>
ffffffffc0200e6c:	4515                	li	a0,5
ffffffffc0200e6e:	117000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200e72:	89aa                	mv	s3,a0
ffffffffc0200e74:	26050563          	beqz	a0,ffffffffc02010de <default_check+0x428>
ffffffffc0200e78:	651c                	ld	a5,8(a0)
ffffffffc0200e7a:	8385                	srli	a5,a5,0x1
ffffffffc0200e7c:	8b85                	andi	a5,a5,1
ffffffffc0200e7e:	54079063          	bnez	a5,ffffffffc02013be <default_check+0x708>
ffffffffc0200e82:	4505                	li	a0,1
ffffffffc0200e84:	00043b03          	ld	s6,0(s0)
ffffffffc0200e88:	00843a83          	ld	s5,8(s0)
ffffffffc0200e8c:	e000                	sd	s0,0(s0)
ffffffffc0200e8e:	e400                	sd	s0,8(s0)
ffffffffc0200e90:	0f5000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200e94:	50051563          	bnez	a0,ffffffffc020139e <default_check+0x6e8>
ffffffffc0200e98:	05098a13          	addi	s4,s3,80
ffffffffc0200e9c:	8552                	mv	a0,s4
ffffffffc0200e9e:	458d                	li	a1,3
ffffffffc0200ea0:	01042b83          	lw	s7,16(s0)
ffffffffc0200ea4:	00006797          	auipc	a5,0x6
ffffffffc0200ea8:	1807aa23          	sw	zero,404(a5) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200eac:	117000ef          	jal	ffffffffc02017c2 <free_pages>
ffffffffc0200eb0:	4511                	li	a0,4
ffffffffc0200eb2:	0d3000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200eb6:	4c051463          	bnez	a0,ffffffffc020137e <default_check+0x6c8>
ffffffffc0200eba:	0589b783          	ld	a5,88(s3)
ffffffffc0200ebe:	8385                	srli	a5,a5,0x1
ffffffffc0200ec0:	8b85                	andi	a5,a5,1
ffffffffc0200ec2:	48078e63          	beqz	a5,ffffffffc020135e <default_check+0x6a8>
ffffffffc0200ec6:	0609a703          	lw	a4,96(s3)
ffffffffc0200eca:	478d                	li	a5,3
ffffffffc0200ecc:	48f71963          	bne	a4,a5,ffffffffc020135e <default_check+0x6a8>
ffffffffc0200ed0:	450d                	li	a0,3
ffffffffc0200ed2:	0b3000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200ed6:	8c2a                	mv	s8,a0
ffffffffc0200ed8:	46050363          	beqz	a0,ffffffffc020133e <default_check+0x688>
ffffffffc0200edc:	4505                	li	a0,1
ffffffffc0200ede:	0a7000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200ee2:	42051e63          	bnez	a0,ffffffffc020131e <default_check+0x668>
ffffffffc0200ee6:	418a1c63          	bne	s4,s8,ffffffffc02012fe <default_check+0x648>
ffffffffc0200eea:	4585                	li	a1,1
ffffffffc0200eec:	854e                	mv	a0,s3
ffffffffc0200eee:	0d5000ef          	jal	ffffffffc02017c2 <free_pages>
ffffffffc0200ef2:	458d                	li	a1,3
ffffffffc0200ef4:	8552                	mv	a0,s4
ffffffffc0200ef6:	0cd000ef          	jal	ffffffffc02017c2 <free_pages>
ffffffffc0200efa:	0089b783          	ld	a5,8(s3)
ffffffffc0200efe:	02898c13          	addi	s8,s3,40
ffffffffc0200f02:	8385                	srli	a5,a5,0x1
ffffffffc0200f04:	8b85                	andi	a5,a5,1
ffffffffc0200f06:	3c078c63          	beqz	a5,ffffffffc02012de <default_check+0x628>
ffffffffc0200f0a:	0109a703          	lw	a4,16(s3)
ffffffffc0200f0e:	4785                	li	a5,1
ffffffffc0200f10:	3cf71763          	bne	a4,a5,ffffffffc02012de <default_check+0x628>
ffffffffc0200f14:	008a3783          	ld	a5,8(s4)
ffffffffc0200f18:	8385                	srli	a5,a5,0x1
ffffffffc0200f1a:	8b85                	andi	a5,a5,1
ffffffffc0200f1c:	3a078163          	beqz	a5,ffffffffc02012be <default_check+0x608>
ffffffffc0200f20:	010a2703          	lw	a4,16(s4)
ffffffffc0200f24:	478d                	li	a5,3
ffffffffc0200f26:	38f71c63          	bne	a4,a5,ffffffffc02012be <default_check+0x608>
ffffffffc0200f2a:	4505                	li	a0,1
ffffffffc0200f2c:	059000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200f30:	36a99763          	bne	s3,a0,ffffffffc020129e <default_check+0x5e8>
ffffffffc0200f34:	4585                	li	a1,1
ffffffffc0200f36:	08d000ef          	jal	ffffffffc02017c2 <free_pages>
ffffffffc0200f3a:	4509                	li	a0,2
ffffffffc0200f3c:	049000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200f40:	32aa1f63          	bne	s4,a0,ffffffffc020127e <default_check+0x5c8>
ffffffffc0200f44:	4589                	li	a1,2
ffffffffc0200f46:	07d000ef          	jal	ffffffffc02017c2 <free_pages>
ffffffffc0200f4a:	4585                	li	a1,1
ffffffffc0200f4c:	8562                	mv	a0,s8
ffffffffc0200f4e:	075000ef          	jal	ffffffffc02017c2 <free_pages>
ffffffffc0200f52:	4515                	li	a0,5
ffffffffc0200f54:	031000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200f58:	89aa                	mv	s3,a0
ffffffffc0200f5a:	48050263          	beqz	a0,ffffffffc02013de <default_check+0x728>
ffffffffc0200f5e:	4505                	li	a0,1
ffffffffc0200f60:	025000ef          	jal	ffffffffc0201784 <alloc_pages>
ffffffffc0200f64:	2c051d63          	bnez	a0,ffffffffc020123e <default_check+0x588>
ffffffffc0200f68:	481c                	lw	a5,16(s0)
ffffffffc0200f6a:	2a079a63          	bnez	a5,ffffffffc020121e <default_check+0x568>
ffffffffc0200f6e:	4595                	li	a1,5
ffffffffc0200f70:	854e                	mv	a0,s3
ffffffffc0200f72:	01742823          	sw	s7,16(s0)
ffffffffc0200f76:	01643023          	sd	s6,0(s0)
ffffffffc0200f7a:	01543423          	sd	s5,8(s0)
ffffffffc0200f7e:	045000ef          	jal	ffffffffc02017c2 <free_pages>
ffffffffc0200f82:	641c                	ld	a5,8(s0)
ffffffffc0200f84:	00878963          	beq	a5,s0,ffffffffc0200f96 <default_check+0x2e0>
ffffffffc0200f88:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200f8c:	679c                	ld	a5,8(a5)
ffffffffc0200f8e:	397d                	addiw	s2,s2,-1
ffffffffc0200f90:	9c99                	subw	s1,s1,a4
ffffffffc0200f92:	fe879be3          	bne	a5,s0,ffffffffc0200f88 <default_check+0x2d2>
ffffffffc0200f96:	26091463          	bnez	s2,ffffffffc02011fe <default_check+0x548>
ffffffffc0200f9a:	46049263          	bnez	s1,ffffffffc02013fe <default_check+0x748>
ffffffffc0200f9e:	60a6                	ld	ra,72(sp)
ffffffffc0200fa0:	6406                	ld	s0,64(sp)
ffffffffc0200fa2:	74e2                	ld	s1,56(sp)
ffffffffc0200fa4:	7942                	ld	s2,48(sp)
ffffffffc0200fa6:	79a2                	ld	s3,40(sp)
ffffffffc0200fa8:	7a02                	ld	s4,32(sp)
ffffffffc0200faa:	6ae2                	ld	s5,24(sp)
ffffffffc0200fac:	6b42                	ld	s6,16(sp)
ffffffffc0200fae:	6ba2                	ld	s7,8(sp)
ffffffffc0200fb0:	6c02                	ld	s8,0(sp)
ffffffffc0200fb2:	6161                	addi	sp,sp,80
ffffffffc0200fb4:	8082                	ret
ffffffffc0200fb6:	4981                	li	s3,0
ffffffffc0200fb8:	4481                	li	s1,0
ffffffffc0200fba:	4901                	li	s2,0
ffffffffc0200fbc:	bb35                	j	ffffffffc0200cf8 <default_check+0x42>
ffffffffc0200fbe:	00002697          	auipc	a3,0x2
ffffffffc0200fc2:	94a68693          	addi	a3,a3,-1718 # ffffffffc0202908 <etext+0x904>
ffffffffc0200fc6:	00002617          	auipc	a2,0x2
ffffffffc0200fca:	95260613          	addi	a2,a2,-1710 # ffffffffc0202918 <etext+0x914>
ffffffffc0200fce:	0f000593          	li	a1,240
ffffffffc0200fd2:	00002517          	auipc	a0,0x2
ffffffffc0200fd6:	95e50513          	addi	a0,a0,-1698 # ffffffffc0202930 <etext+0x92c>
ffffffffc0200fda:	c3cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc0200fde:	00002697          	auipc	a3,0x2
ffffffffc0200fe2:	9ea68693          	addi	a3,a3,-1558 # ffffffffc02029c8 <etext+0x9c4>
ffffffffc0200fe6:	00002617          	auipc	a2,0x2
ffffffffc0200fea:	93260613          	addi	a2,a2,-1742 # ffffffffc0202918 <etext+0x914>
ffffffffc0200fee:	0bd00593          	li	a1,189
ffffffffc0200ff2:	00002517          	auipc	a0,0x2
ffffffffc0200ff6:	93e50513          	addi	a0,a0,-1730 # ffffffffc0202930 <etext+0x92c>
ffffffffc0200ffa:	c1cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc0200ffe:	00002697          	auipc	a3,0x2
ffffffffc0201002:	9f268693          	addi	a3,a3,-1550 # ffffffffc02029f0 <etext+0x9ec>
ffffffffc0201006:	00002617          	auipc	a2,0x2
ffffffffc020100a:	91260613          	addi	a2,a2,-1774 # ffffffffc0202918 <etext+0x914>
ffffffffc020100e:	0be00593          	li	a1,190
ffffffffc0201012:	00002517          	auipc	a0,0x2
ffffffffc0201016:	91e50513          	addi	a0,a0,-1762 # ffffffffc0202930 <etext+0x92c>
ffffffffc020101a:	bfcff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020101e:	00002697          	auipc	a3,0x2
ffffffffc0201022:	a1268693          	addi	a3,a3,-1518 # ffffffffc0202a30 <etext+0xa2c>
ffffffffc0201026:	00002617          	auipc	a2,0x2
ffffffffc020102a:	8f260613          	addi	a2,a2,-1806 # ffffffffc0202918 <etext+0x914>
ffffffffc020102e:	0c000593          	li	a1,192
ffffffffc0201032:	00002517          	auipc	a0,0x2
ffffffffc0201036:	8fe50513          	addi	a0,a0,-1794 # ffffffffc0202930 <etext+0x92c>
ffffffffc020103a:	bdcff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020103e:	00002697          	auipc	a3,0x2
ffffffffc0201042:	a7a68693          	addi	a3,a3,-1414 # ffffffffc0202ab8 <etext+0xab4>
ffffffffc0201046:	00002617          	auipc	a2,0x2
ffffffffc020104a:	8d260613          	addi	a2,a2,-1838 # ffffffffc0202918 <etext+0x914>
ffffffffc020104e:	0d900593          	li	a1,217
ffffffffc0201052:	00002517          	auipc	a0,0x2
ffffffffc0201056:	8de50513          	addi	a0,a0,-1826 # ffffffffc0202930 <etext+0x92c>
ffffffffc020105a:	bbcff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020105e:	00002697          	auipc	a3,0x2
ffffffffc0201062:	90a68693          	addi	a3,a3,-1782 # ffffffffc0202968 <etext+0x964>
ffffffffc0201066:	00002617          	auipc	a2,0x2
ffffffffc020106a:	8b260613          	addi	a2,a2,-1870 # ffffffffc0202918 <etext+0x914>
ffffffffc020106e:	0d200593          	li	a1,210
ffffffffc0201072:	00002517          	auipc	a0,0x2
ffffffffc0201076:	8be50513          	addi	a0,a0,-1858 # ffffffffc0202930 <etext+0x92c>
ffffffffc020107a:	b9cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020107e:	00002697          	auipc	a3,0x2
ffffffffc0201082:	a2a68693          	addi	a3,a3,-1494 # ffffffffc0202aa8 <etext+0xaa4>
ffffffffc0201086:	00002617          	auipc	a2,0x2
ffffffffc020108a:	89260613          	addi	a2,a2,-1902 # ffffffffc0202918 <etext+0x914>
ffffffffc020108e:	0d000593          	li	a1,208
ffffffffc0201092:	00002517          	auipc	a0,0x2
ffffffffc0201096:	89e50513          	addi	a0,a0,-1890 # ffffffffc0202930 <etext+0x92c>
ffffffffc020109a:	b7cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020109e:	00002697          	auipc	a3,0x2
ffffffffc02010a2:	9f268693          	addi	a3,a3,-1550 # ffffffffc0202a90 <etext+0xa8c>
ffffffffc02010a6:	00002617          	auipc	a2,0x2
ffffffffc02010aa:	87260613          	addi	a2,a2,-1934 # ffffffffc0202918 <etext+0x914>
ffffffffc02010ae:	0cb00593          	li	a1,203
ffffffffc02010b2:	00002517          	auipc	a0,0x2
ffffffffc02010b6:	87e50513          	addi	a0,a0,-1922 # ffffffffc0202930 <etext+0x92c>
ffffffffc02010ba:	b5cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc02010be:	00002697          	auipc	a3,0x2
ffffffffc02010c2:	9b268693          	addi	a3,a3,-1614 # ffffffffc0202a70 <etext+0xa6c>
ffffffffc02010c6:	00002617          	auipc	a2,0x2
ffffffffc02010ca:	85260613          	addi	a2,a2,-1966 # ffffffffc0202918 <etext+0x914>
ffffffffc02010ce:	0c200593          	li	a1,194
ffffffffc02010d2:	00002517          	auipc	a0,0x2
ffffffffc02010d6:	85e50513          	addi	a0,a0,-1954 # ffffffffc0202930 <etext+0x92c>
ffffffffc02010da:	b3cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc02010de:	00002697          	auipc	a3,0x2
ffffffffc02010e2:	a2268693          	addi	a3,a3,-1502 # ffffffffc0202b00 <etext+0xafc>
ffffffffc02010e6:	00002617          	auipc	a2,0x2
ffffffffc02010ea:	83260613          	addi	a2,a2,-1998 # ffffffffc0202918 <etext+0x914>
ffffffffc02010ee:	0f800593          	li	a1,248
ffffffffc02010f2:	00002517          	auipc	a0,0x2
ffffffffc02010f6:	83e50513          	addi	a0,a0,-1986 # ffffffffc0202930 <etext+0x92c>
ffffffffc02010fa:	b1cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc02010fe:	00002697          	auipc	a3,0x2
ffffffffc0201102:	9f268693          	addi	a3,a3,-1550 # ffffffffc0202af0 <etext+0xaec>
ffffffffc0201106:	00002617          	auipc	a2,0x2
ffffffffc020110a:	81260613          	addi	a2,a2,-2030 # ffffffffc0202918 <etext+0x914>
ffffffffc020110e:	0df00593          	li	a1,223
ffffffffc0201112:	00002517          	auipc	a0,0x2
ffffffffc0201116:	81e50513          	addi	a0,a0,-2018 # ffffffffc0202930 <etext+0x92c>
ffffffffc020111a:	afcff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020111e:	00002697          	auipc	a3,0x2
ffffffffc0201122:	97268693          	addi	a3,a3,-1678 # ffffffffc0202a90 <etext+0xa8c>
ffffffffc0201126:	00001617          	auipc	a2,0x1
ffffffffc020112a:	7f260613          	addi	a2,a2,2034 # ffffffffc0202918 <etext+0x914>
ffffffffc020112e:	0dd00593          	li	a1,221
ffffffffc0201132:	00001517          	auipc	a0,0x1
ffffffffc0201136:	7fe50513          	addi	a0,a0,2046 # ffffffffc0202930 <etext+0x92c>
ffffffffc020113a:	adcff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020113e:	00002697          	auipc	a3,0x2
ffffffffc0201142:	99268693          	addi	a3,a3,-1646 # ffffffffc0202ad0 <etext+0xacc>
ffffffffc0201146:	00001617          	auipc	a2,0x1
ffffffffc020114a:	7d260613          	addi	a2,a2,2002 # ffffffffc0202918 <etext+0x914>
ffffffffc020114e:	0dc00593          	li	a1,220
ffffffffc0201152:	00001517          	auipc	a0,0x1
ffffffffc0201156:	7de50513          	addi	a0,a0,2014 # ffffffffc0202930 <etext+0x92c>
ffffffffc020115a:	abcff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020115e:	00002697          	auipc	a3,0x2
ffffffffc0201162:	80a68693          	addi	a3,a3,-2038 # ffffffffc0202968 <etext+0x964>
ffffffffc0201166:	00001617          	auipc	a2,0x1
ffffffffc020116a:	7b260613          	addi	a2,a2,1970 # ffffffffc0202918 <etext+0x914>
ffffffffc020116e:	0b900593          	li	a1,185
ffffffffc0201172:	00001517          	auipc	a0,0x1
ffffffffc0201176:	7be50513          	addi	a0,a0,1982 # ffffffffc0202930 <etext+0x92c>
ffffffffc020117a:	a9cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020117e:	00002697          	auipc	a3,0x2
ffffffffc0201182:	91268693          	addi	a3,a3,-1774 # ffffffffc0202a90 <etext+0xa8c>
ffffffffc0201186:	00001617          	auipc	a2,0x1
ffffffffc020118a:	79260613          	addi	a2,a2,1938 # ffffffffc0202918 <etext+0x914>
ffffffffc020118e:	0d600593          	li	a1,214
ffffffffc0201192:	00001517          	auipc	a0,0x1
ffffffffc0201196:	79e50513          	addi	a0,a0,1950 # ffffffffc0202930 <etext+0x92c>
ffffffffc020119a:	a7cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020119e:	00002697          	auipc	a3,0x2
ffffffffc02011a2:	80a68693          	addi	a3,a3,-2038 # ffffffffc02029a8 <etext+0x9a4>
ffffffffc02011a6:	00001617          	auipc	a2,0x1
ffffffffc02011aa:	77260613          	addi	a2,a2,1906 # ffffffffc0202918 <etext+0x914>
ffffffffc02011ae:	0d400593          	li	a1,212
ffffffffc02011b2:	00001517          	auipc	a0,0x1
ffffffffc02011b6:	77e50513          	addi	a0,a0,1918 # ffffffffc0202930 <etext+0x92c>
ffffffffc02011ba:	a5cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc02011be:	00001697          	auipc	a3,0x1
ffffffffc02011c2:	7ca68693          	addi	a3,a3,1994 # ffffffffc0202988 <etext+0x984>
ffffffffc02011c6:	00001617          	auipc	a2,0x1
ffffffffc02011ca:	75260613          	addi	a2,a2,1874 # ffffffffc0202918 <etext+0x914>
ffffffffc02011ce:	0d300593          	li	a1,211
ffffffffc02011d2:	00001517          	auipc	a0,0x1
ffffffffc02011d6:	75e50513          	addi	a0,a0,1886 # ffffffffc0202930 <etext+0x92c>
ffffffffc02011da:	a3cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc02011de:	00001697          	auipc	a3,0x1
ffffffffc02011e2:	7ca68693          	addi	a3,a3,1994 # ffffffffc02029a8 <etext+0x9a4>
ffffffffc02011e6:	00001617          	auipc	a2,0x1
ffffffffc02011ea:	73260613          	addi	a2,a2,1842 # ffffffffc0202918 <etext+0x914>
ffffffffc02011ee:	0bb00593          	li	a1,187
ffffffffc02011f2:	00001517          	auipc	a0,0x1
ffffffffc02011f6:	73e50513          	addi	a0,a0,1854 # ffffffffc0202930 <etext+0x92c>
ffffffffc02011fa:	a1cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc02011fe:	00002697          	auipc	a3,0x2
ffffffffc0201202:	a5268693          	addi	a3,a3,-1454 # ffffffffc0202c50 <etext+0xc4c>
ffffffffc0201206:	00001617          	auipc	a2,0x1
ffffffffc020120a:	71260613          	addi	a2,a2,1810 # ffffffffc0202918 <etext+0x914>
ffffffffc020120e:	12500593          	li	a1,293
ffffffffc0201212:	00001517          	auipc	a0,0x1
ffffffffc0201216:	71e50513          	addi	a0,a0,1822 # ffffffffc0202930 <etext+0x92c>
ffffffffc020121a:	9fcff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020121e:	00002697          	auipc	a3,0x2
ffffffffc0201222:	8d268693          	addi	a3,a3,-1838 # ffffffffc0202af0 <etext+0xaec>
ffffffffc0201226:	00001617          	auipc	a2,0x1
ffffffffc020122a:	6f260613          	addi	a2,a2,1778 # ffffffffc0202918 <etext+0x914>
ffffffffc020122e:	11a00593          	li	a1,282
ffffffffc0201232:	00001517          	auipc	a0,0x1
ffffffffc0201236:	6fe50513          	addi	a0,a0,1790 # ffffffffc0202930 <etext+0x92c>
ffffffffc020123a:	9dcff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020123e:	00002697          	auipc	a3,0x2
ffffffffc0201242:	85268693          	addi	a3,a3,-1966 # ffffffffc0202a90 <etext+0xa8c>
ffffffffc0201246:	00001617          	auipc	a2,0x1
ffffffffc020124a:	6d260613          	addi	a2,a2,1746 # ffffffffc0202918 <etext+0x914>
ffffffffc020124e:	11800593          	li	a1,280
ffffffffc0201252:	00001517          	auipc	a0,0x1
ffffffffc0201256:	6de50513          	addi	a0,a0,1758 # ffffffffc0202930 <etext+0x92c>
ffffffffc020125a:	9bcff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020125e:	00001697          	auipc	a3,0x1
ffffffffc0201262:	7f268693          	addi	a3,a3,2034 # ffffffffc0202a50 <etext+0xa4c>
ffffffffc0201266:	00001617          	auipc	a2,0x1
ffffffffc020126a:	6b260613          	addi	a2,a2,1714 # ffffffffc0202918 <etext+0x914>
ffffffffc020126e:	0c100593          	li	a1,193
ffffffffc0201272:	00001517          	auipc	a0,0x1
ffffffffc0201276:	6be50513          	addi	a0,a0,1726 # ffffffffc0202930 <etext+0x92c>
ffffffffc020127a:	99cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020127e:	00002697          	auipc	a3,0x2
ffffffffc0201282:	99268693          	addi	a3,a3,-1646 # ffffffffc0202c10 <etext+0xc0c>
ffffffffc0201286:	00001617          	auipc	a2,0x1
ffffffffc020128a:	69260613          	addi	a2,a2,1682 # ffffffffc0202918 <etext+0x914>
ffffffffc020128e:	11200593          	li	a1,274
ffffffffc0201292:	00001517          	auipc	a0,0x1
ffffffffc0201296:	69e50513          	addi	a0,a0,1694 # ffffffffc0202930 <etext+0x92c>
ffffffffc020129a:	97cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020129e:	00002697          	auipc	a3,0x2
ffffffffc02012a2:	95268693          	addi	a3,a3,-1710 # ffffffffc0202bf0 <etext+0xbec>
ffffffffc02012a6:	00001617          	auipc	a2,0x1
ffffffffc02012aa:	67260613          	addi	a2,a2,1650 # ffffffffc0202918 <etext+0x914>
ffffffffc02012ae:	11000593          	li	a1,272
ffffffffc02012b2:	00001517          	auipc	a0,0x1
ffffffffc02012b6:	67e50513          	addi	a0,a0,1662 # ffffffffc0202930 <etext+0x92c>
ffffffffc02012ba:	95cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc02012be:	00002697          	auipc	a3,0x2
ffffffffc02012c2:	90a68693          	addi	a3,a3,-1782 # ffffffffc0202bc8 <etext+0xbc4>
ffffffffc02012c6:	00001617          	auipc	a2,0x1
ffffffffc02012ca:	65260613          	addi	a2,a2,1618 # ffffffffc0202918 <etext+0x914>
ffffffffc02012ce:	10e00593          	li	a1,270
ffffffffc02012d2:	00001517          	auipc	a0,0x1
ffffffffc02012d6:	65e50513          	addi	a0,a0,1630 # ffffffffc0202930 <etext+0x92c>
ffffffffc02012da:	93cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc02012de:	00002697          	auipc	a3,0x2
ffffffffc02012e2:	8c268693          	addi	a3,a3,-1854 # ffffffffc0202ba0 <etext+0xb9c>
ffffffffc02012e6:	00001617          	auipc	a2,0x1
ffffffffc02012ea:	63260613          	addi	a2,a2,1586 # ffffffffc0202918 <etext+0x914>
ffffffffc02012ee:	10d00593          	li	a1,269
ffffffffc02012f2:	00001517          	auipc	a0,0x1
ffffffffc02012f6:	63e50513          	addi	a0,a0,1598 # ffffffffc0202930 <etext+0x92c>
ffffffffc02012fa:	91cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc02012fe:	00002697          	auipc	a3,0x2
ffffffffc0201302:	89268693          	addi	a3,a3,-1902 # ffffffffc0202b90 <etext+0xb8c>
ffffffffc0201306:	00001617          	auipc	a2,0x1
ffffffffc020130a:	61260613          	addi	a2,a2,1554 # ffffffffc0202918 <etext+0x914>
ffffffffc020130e:	10800593          	li	a1,264
ffffffffc0201312:	00001517          	auipc	a0,0x1
ffffffffc0201316:	61e50513          	addi	a0,a0,1566 # ffffffffc0202930 <etext+0x92c>
ffffffffc020131a:	8fcff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020131e:	00001697          	auipc	a3,0x1
ffffffffc0201322:	77268693          	addi	a3,a3,1906 # ffffffffc0202a90 <etext+0xa8c>
ffffffffc0201326:	00001617          	auipc	a2,0x1
ffffffffc020132a:	5f260613          	addi	a2,a2,1522 # ffffffffc0202918 <etext+0x914>
ffffffffc020132e:	10700593          	li	a1,263
ffffffffc0201332:	00001517          	auipc	a0,0x1
ffffffffc0201336:	5fe50513          	addi	a0,a0,1534 # ffffffffc0202930 <etext+0x92c>
ffffffffc020133a:	8dcff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020133e:	00002697          	auipc	a3,0x2
ffffffffc0201342:	83268693          	addi	a3,a3,-1998 # ffffffffc0202b70 <etext+0xb6c>
ffffffffc0201346:	00001617          	auipc	a2,0x1
ffffffffc020134a:	5d260613          	addi	a2,a2,1490 # ffffffffc0202918 <etext+0x914>
ffffffffc020134e:	10600593          	li	a1,262
ffffffffc0201352:	00001517          	auipc	a0,0x1
ffffffffc0201356:	5de50513          	addi	a0,a0,1502 # ffffffffc0202930 <etext+0x92c>
ffffffffc020135a:	8bcff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020135e:	00001697          	auipc	a3,0x1
ffffffffc0201362:	7e268693          	addi	a3,a3,2018 # ffffffffc0202b40 <etext+0xb3c>
ffffffffc0201366:	00001617          	auipc	a2,0x1
ffffffffc020136a:	5b260613          	addi	a2,a2,1458 # ffffffffc0202918 <etext+0x914>
ffffffffc020136e:	10500593          	li	a1,261
ffffffffc0201372:	00001517          	auipc	a0,0x1
ffffffffc0201376:	5be50513          	addi	a0,a0,1470 # ffffffffc0202930 <etext+0x92c>
ffffffffc020137a:	89cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020137e:	00001697          	auipc	a3,0x1
ffffffffc0201382:	7aa68693          	addi	a3,a3,1962 # ffffffffc0202b28 <etext+0xb24>
ffffffffc0201386:	00001617          	auipc	a2,0x1
ffffffffc020138a:	59260613          	addi	a2,a2,1426 # ffffffffc0202918 <etext+0x914>
ffffffffc020138e:	10400593          	li	a1,260
ffffffffc0201392:	00001517          	auipc	a0,0x1
ffffffffc0201396:	59e50513          	addi	a0,a0,1438 # ffffffffc0202930 <etext+0x92c>
ffffffffc020139a:	87cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020139e:	00001697          	auipc	a3,0x1
ffffffffc02013a2:	6f268693          	addi	a3,a3,1778 # ffffffffc0202a90 <etext+0xa8c>
ffffffffc02013a6:	00001617          	auipc	a2,0x1
ffffffffc02013aa:	57260613          	addi	a2,a2,1394 # ffffffffc0202918 <etext+0x914>
ffffffffc02013ae:	0fe00593          	li	a1,254
ffffffffc02013b2:	00001517          	auipc	a0,0x1
ffffffffc02013b6:	57e50513          	addi	a0,a0,1406 # ffffffffc0202930 <etext+0x92c>
ffffffffc02013ba:	85cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc02013be:	00001697          	auipc	a3,0x1
ffffffffc02013c2:	75268693          	addi	a3,a3,1874 # ffffffffc0202b10 <etext+0xb0c>
ffffffffc02013c6:	00001617          	auipc	a2,0x1
ffffffffc02013ca:	55260613          	addi	a2,a2,1362 # ffffffffc0202918 <etext+0x914>
ffffffffc02013ce:	0f900593          	li	a1,249
ffffffffc02013d2:	00001517          	auipc	a0,0x1
ffffffffc02013d6:	55e50513          	addi	a0,a0,1374 # ffffffffc0202930 <etext+0x92c>
ffffffffc02013da:	83cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc02013de:	00002697          	auipc	a3,0x2
ffffffffc02013e2:	85268693          	addi	a3,a3,-1966 # ffffffffc0202c30 <etext+0xc2c>
ffffffffc02013e6:	00001617          	auipc	a2,0x1
ffffffffc02013ea:	53260613          	addi	a2,a2,1330 # ffffffffc0202918 <etext+0x914>
ffffffffc02013ee:	11700593          	li	a1,279
ffffffffc02013f2:	00001517          	auipc	a0,0x1
ffffffffc02013f6:	53e50513          	addi	a0,a0,1342 # ffffffffc0202930 <etext+0x92c>
ffffffffc02013fa:	81cff0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc02013fe:	00002697          	auipc	a3,0x2
ffffffffc0201402:	86268693          	addi	a3,a3,-1950 # ffffffffc0202c60 <etext+0xc5c>
ffffffffc0201406:	00001617          	auipc	a2,0x1
ffffffffc020140a:	51260613          	addi	a2,a2,1298 # ffffffffc0202918 <etext+0x914>
ffffffffc020140e:	12600593          	li	a1,294
ffffffffc0201412:	00001517          	auipc	a0,0x1
ffffffffc0201416:	51e50513          	addi	a0,a0,1310 # ffffffffc0202930 <etext+0x92c>
ffffffffc020141a:	ffdfe0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020141e:	00001697          	auipc	a3,0x1
ffffffffc0201422:	52a68693          	addi	a3,a3,1322 # ffffffffc0202948 <etext+0x944>
ffffffffc0201426:	00001617          	auipc	a2,0x1
ffffffffc020142a:	4f260613          	addi	a2,a2,1266 # ffffffffc0202918 <etext+0x914>
ffffffffc020142e:	0f300593          	li	a1,243
ffffffffc0201432:	00001517          	auipc	a0,0x1
ffffffffc0201436:	4fe50513          	addi	a0,a0,1278 # ffffffffc0202930 <etext+0x92c>
ffffffffc020143a:	fddfe0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc020143e:	00001697          	auipc	a3,0x1
ffffffffc0201442:	54a68693          	addi	a3,a3,1354 # ffffffffc0202988 <etext+0x984>
ffffffffc0201446:	00001617          	auipc	a2,0x1
ffffffffc020144a:	4d260613          	addi	a2,a2,1234 # ffffffffc0202918 <etext+0x914>
ffffffffc020144e:	0ba00593          	li	a1,186
ffffffffc0201452:	00001517          	auipc	a0,0x1
ffffffffc0201456:	4de50513          	addi	a0,a0,1246 # ffffffffc0202930 <etext+0x92c>
ffffffffc020145a:	fbdfe0ef          	jal	ffffffffc0200416 <__panic>

ffffffffc020145e <default_free_pages>:
ffffffffc020145e:	1141                	addi	sp,sp,-16
ffffffffc0201460:	e406                	sd	ra,8(sp)
ffffffffc0201462:	14058a63          	beqz	a1,ffffffffc02015b6 <default_free_pages+0x158>
ffffffffc0201466:	00259713          	slli	a4,a1,0x2
ffffffffc020146a:	972e                	add	a4,a4,a1
ffffffffc020146c:	070e                	slli	a4,a4,0x3
ffffffffc020146e:	00e506b3          	add	a3,a0,a4
ffffffffc0201472:	87aa                	mv	a5,a0
ffffffffc0201474:	c30d                	beqz	a4,ffffffffc0201496 <default_free_pages+0x38>
ffffffffc0201476:	6798                	ld	a4,8(a5)
ffffffffc0201478:	8b05                	andi	a4,a4,1
ffffffffc020147a:	10071e63          	bnez	a4,ffffffffc0201596 <default_free_pages+0x138>
ffffffffc020147e:	6798                	ld	a4,8(a5)
ffffffffc0201480:	8b09                	andi	a4,a4,2
ffffffffc0201482:	10071a63          	bnez	a4,ffffffffc0201596 <default_free_pages+0x138>
ffffffffc0201486:	0007b423          	sd	zero,8(a5)
ffffffffc020148a:	0007a023          	sw	zero,0(a5)
ffffffffc020148e:	02878793          	addi	a5,a5,40
ffffffffc0201492:	fed792e3          	bne	a5,a3,ffffffffc0201476 <default_free_pages+0x18>
ffffffffc0201496:	2581                	sext.w	a1,a1
ffffffffc0201498:	c90c                	sw	a1,16(a0)
ffffffffc020149a:	00850893          	addi	a7,a0,8
ffffffffc020149e:	4789                	li	a5,2
ffffffffc02014a0:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc02014a4:	00006697          	auipc	a3,0x6
ffffffffc02014a8:	b8468693          	addi	a3,a3,-1148 # ffffffffc0207028 <free_area>
ffffffffc02014ac:	4a98                	lw	a4,16(a3)
ffffffffc02014ae:	669c                	ld	a5,8(a3)
ffffffffc02014b0:	9f2d                	addw	a4,a4,a1
ffffffffc02014b2:	ca98                	sw	a4,16(a3)
ffffffffc02014b4:	0ad78563          	beq	a5,a3,ffffffffc020155e <default_free_pages+0x100>
ffffffffc02014b8:	fe878713          	addi	a4,a5,-24
ffffffffc02014bc:	4581                	li	a1,0
ffffffffc02014be:	01850613          	addi	a2,a0,24
ffffffffc02014c2:	00e56a63          	bltu	a0,a4,ffffffffc02014d6 <default_free_pages+0x78>
ffffffffc02014c6:	6798                	ld	a4,8(a5)
ffffffffc02014c8:	06d70263          	beq	a4,a3,ffffffffc020152c <default_free_pages+0xce>
ffffffffc02014cc:	87ba                	mv	a5,a4
ffffffffc02014ce:	fe878713          	addi	a4,a5,-24
ffffffffc02014d2:	fee57ae3          	bgeu	a0,a4,ffffffffc02014c6 <default_free_pages+0x68>
ffffffffc02014d6:	c199                	beqz	a1,ffffffffc02014dc <default_free_pages+0x7e>
ffffffffc02014d8:	0106b023          	sd	a6,0(a3)
ffffffffc02014dc:	6398                	ld	a4,0(a5)
ffffffffc02014de:	e390                	sd	a2,0(a5)
ffffffffc02014e0:	e710                	sd	a2,8(a4)
ffffffffc02014e2:	f11c                	sd	a5,32(a0)
ffffffffc02014e4:	ed18                	sd	a4,24(a0)
ffffffffc02014e6:	02d70063          	beq	a4,a3,ffffffffc0201506 <default_free_pages+0xa8>
ffffffffc02014ea:	ff872803          	lw	a6,-8(a4)
ffffffffc02014ee:	fe870593          	addi	a1,a4,-24
ffffffffc02014f2:	02081613          	slli	a2,a6,0x20
ffffffffc02014f6:	9201                	srli	a2,a2,0x20
ffffffffc02014f8:	00261793          	slli	a5,a2,0x2
ffffffffc02014fc:	97b2                	add	a5,a5,a2
ffffffffc02014fe:	078e                	slli	a5,a5,0x3
ffffffffc0201500:	97ae                	add	a5,a5,a1
ffffffffc0201502:	02f50f63          	beq	a0,a5,ffffffffc0201540 <default_free_pages+0xe2>
ffffffffc0201506:	7118                	ld	a4,32(a0)
ffffffffc0201508:	00d70f63          	beq	a4,a3,ffffffffc0201526 <default_free_pages+0xc8>
ffffffffc020150c:	490c                	lw	a1,16(a0)
ffffffffc020150e:	fe870693          	addi	a3,a4,-24
ffffffffc0201512:	02059613          	slli	a2,a1,0x20
ffffffffc0201516:	9201                	srli	a2,a2,0x20
ffffffffc0201518:	00261793          	slli	a5,a2,0x2
ffffffffc020151c:	97b2                	add	a5,a5,a2
ffffffffc020151e:	078e                	slli	a5,a5,0x3
ffffffffc0201520:	97aa                	add	a5,a5,a0
ffffffffc0201522:	04f68a63          	beq	a3,a5,ffffffffc0201576 <default_free_pages+0x118>
ffffffffc0201526:	60a2                	ld	ra,8(sp)
ffffffffc0201528:	0141                	addi	sp,sp,16
ffffffffc020152a:	8082                	ret
ffffffffc020152c:	e790                	sd	a2,8(a5)
ffffffffc020152e:	f114                	sd	a3,32(a0)
ffffffffc0201530:	6798                	ld	a4,8(a5)
ffffffffc0201532:	ed1c                	sd	a5,24(a0)
ffffffffc0201534:	8832                	mv	a6,a2
ffffffffc0201536:	02d70d63          	beq	a4,a3,ffffffffc0201570 <default_free_pages+0x112>
ffffffffc020153a:	4585                	li	a1,1
ffffffffc020153c:	87ba                	mv	a5,a4
ffffffffc020153e:	bf41                	j	ffffffffc02014ce <default_free_pages+0x70>
ffffffffc0201540:	491c                	lw	a5,16(a0)
ffffffffc0201542:	010787bb          	addw	a5,a5,a6
ffffffffc0201546:	fef72c23          	sw	a5,-8(a4)
ffffffffc020154a:	57f5                	li	a5,-3
ffffffffc020154c:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc0201550:	6d10                	ld	a2,24(a0)
ffffffffc0201552:	711c                	ld	a5,32(a0)
ffffffffc0201554:	852e                	mv	a0,a1
ffffffffc0201556:	e61c                	sd	a5,8(a2)
ffffffffc0201558:	6718                	ld	a4,8(a4)
ffffffffc020155a:	e390                	sd	a2,0(a5)
ffffffffc020155c:	b775                	j	ffffffffc0201508 <default_free_pages+0xaa>
ffffffffc020155e:	60a2                	ld	ra,8(sp)
ffffffffc0201560:	01850713          	addi	a4,a0,24
ffffffffc0201564:	e398                	sd	a4,0(a5)
ffffffffc0201566:	e798                	sd	a4,8(a5)
ffffffffc0201568:	f11c                	sd	a5,32(a0)
ffffffffc020156a:	ed1c                	sd	a5,24(a0)
ffffffffc020156c:	0141                	addi	sp,sp,16
ffffffffc020156e:	8082                	ret
ffffffffc0201570:	e290                	sd	a2,0(a3)
ffffffffc0201572:	873e                	mv	a4,a5
ffffffffc0201574:	bf8d                	j	ffffffffc02014e6 <default_free_pages+0x88>
ffffffffc0201576:	ff872783          	lw	a5,-8(a4)
ffffffffc020157a:	ff070693          	addi	a3,a4,-16
ffffffffc020157e:	9fad                	addw	a5,a5,a1
ffffffffc0201580:	c91c                	sw	a5,16(a0)
ffffffffc0201582:	57f5                	li	a5,-3
ffffffffc0201584:	60f6b02f          	amoand.d	zero,a5,(a3)
ffffffffc0201588:	6314                	ld	a3,0(a4)
ffffffffc020158a:	671c                	ld	a5,8(a4)
ffffffffc020158c:	60a2                	ld	ra,8(sp)
ffffffffc020158e:	e69c                	sd	a5,8(a3)
ffffffffc0201590:	e394                	sd	a3,0(a5)
ffffffffc0201592:	0141                	addi	sp,sp,16
ffffffffc0201594:	8082                	ret
ffffffffc0201596:	00001697          	auipc	a3,0x1
ffffffffc020159a:	6e268693          	addi	a3,a3,1762 # ffffffffc0202c78 <etext+0xc74>
ffffffffc020159e:	00001617          	auipc	a2,0x1
ffffffffc02015a2:	37a60613          	addi	a2,a2,890 # ffffffffc0202918 <etext+0x914>
ffffffffc02015a6:	08300593          	li	a1,131
ffffffffc02015aa:	00001517          	auipc	a0,0x1
ffffffffc02015ae:	38650513          	addi	a0,a0,902 # ffffffffc0202930 <etext+0x92c>
ffffffffc02015b2:	e65fe0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc02015b6:	00001697          	auipc	a3,0x1
ffffffffc02015ba:	6ba68693          	addi	a3,a3,1722 # ffffffffc0202c70 <etext+0xc6c>
ffffffffc02015be:	00001617          	auipc	a2,0x1
ffffffffc02015c2:	35a60613          	addi	a2,a2,858 # ffffffffc0202918 <etext+0x914>
ffffffffc02015c6:	08000593          	li	a1,128
ffffffffc02015ca:	00001517          	auipc	a0,0x1
ffffffffc02015ce:	36650513          	addi	a0,a0,870 # ffffffffc0202930 <etext+0x92c>
ffffffffc02015d2:	e45fe0ef          	jal	ffffffffc0200416 <__panic>

ffffffffc02015d6 <default_alloc_pages>:
ffffffffc02015d6:	c959                	beqz	a0,ffffffffc020166c <default_alloc_pages+0x96>
ffffffffc02015d8:	00006617          	auipc	a2,0x6
ffffffffc02015dc:	a5060613          	addi	a2,a2,-1456 # ffffffffc0207028 <free_area>
ffffffffc02015e0:	4a0c                	lw	a1,16(a2)
ffffffffc02015e2:	86aa                	mv	a3,a0
ffffffffc02015e4:	02059793          	slli	a5,a1,0x20
ffffffffc02015e8:	9381                	srli	a5,a5,0x20
ffffffffc02015ea:	00a7eb63          	bltu	a5,a0,ffffffffc0201600 <default_alloc_pages+0x2a>
ffffffffc02015ee:	87b2                	mv	a5,a2
ffffffffc02015f0:	a029                	j	ffffffffc02015fa <default_alloc_pages+0x24>
ffffffffc02015f2:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02015f6:	00d77763          	bgeu	a4,a3,ffffffffc0201604 <default_alloc_pages+0x2e>
ffffffffc02015fa:	679c                	ld	a5,8(a5)
ffffffffc02015fc:	fec79be3          	bne	a5,a2,ffffffffc02015f2 <default_alloc_pages+0x1c>
ffffffffc0201600:	4501                	li	a0,0
ffffffffc0201602:	8082                	ret
ffffffffc0201604:	6798                	ld	a4,8(a5)
ffffffffc0201606:	0007b803          	ld	a6,0(a5)
ffffffffc020160a:	ff87a883          	lw	a7,-8(a5)
ffffffffc020160e:	fe878513          	addi	a0,a5,-24
ffffffffc0201612:	00e83423          	sd	a4,8(a6)
ffffffffc0201616:	01073023          	sd	a6,0(a4)
ffffffffc020161a:	02089713          	slli	a4,a7,0x20
ffffffffc020161e:	9301                	srli	a4,a4,0x20
ffffffffc0201620:	0006831b          	sext.w	t1,a3
ffffffffc0201624:	02e6fc63          	bgeu	a3,a4,ffffffffc020165c <default_alloc_pages+0x86>
ffffffffc0201628:	00269713          	slli	a4,a3,0x2
ffffffffc020162c:	9736                	add	a4,a4,a3
ffffffffc020162e:	070e                	slli	a4,a4,0x3
ffffffffc0201630:	972a                	add	a4,a4,a0
ffffffffc0201632:	406888bb          	subw	a7,a7,t1
ffffffffc0201636:	01172823          	sw	a7,16(a4)
ffffffffc020163a:	4689                	li	a3,2
ffffffffc020163c:	00870593          	addi	a1,a4,8
ffffffffc0201640:	40d5b02f          	amoor.d	zero,a3,(a1)
ffffffffc0201644:	00883683          	ld	a3,8(a6)
ffffffffc0201648:	01870893          	addi	a7,a4,24
ffffffffc020164c:	4a0c                	lw	a1,16(a2)
ffffffffc020164e:	0116b023          	sd	a7,0(a3)
ffffffffc0201652:	01183423          	sd	a7,8(a6)
ffffffffc0201656:	f314                	sd	a3,32(a4)
ffffffffc0201658:	01073c23          	sd	a6,24(a4)
ffffffffc020165c:	406585bb          	subw	a1,a1,t1
ffffffffc0201660:	ca0c                	sw	a1,16(a2)
ffffffffc0201662:	5775                	li	a4,-3
ffffffffc0201664:	17c1                	addi	a5,a5,-16
ffffffffc0201666:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc020166a:	8082                	ret
ffffffffc020166c:	1141                	addi	sp,sp,-16
ffffffffc020166e:	00001697          	auipc	a3,0x1
ffffffffc0201672:	60268693          	addi	a3,a3,1538 # ffffffffc0202c70 <etext+0xc6c>
ffffffffc0201676:	00001617          	auipc	a2,0x1
ffffffffc020167a:	2a260613          	addi	a2,a2,674 # ffffffffc0202918 <etext+0x914>
ffffffffc020167e:	06200593          	li	a1,98
ffffffffc0201682:	00001517          	auipc	a0,0x1
ffffffffc0201686:	2ae50513          	addi	a0,a0,686 # ffffffffc0202930 <etext+0x92c>
ffffffffc020168a:	e406                	sd	ra,8(sp)
ffffffffc020168c:	d8bfe0ef          	jal	ffffffffc0200416 <__panic>

ffffffffc0201690 <default_init_memmap>:
ffffffffc0201690:	1141                	addi	sp,sp,-16
ffffffffc0201692:	e406                	sd	ra,8(sp)
ffffffffc0201694:	c9e1                	beqz	a1,ffffffffc0201764 <default_init_memmap+0xd4>
ffffffffc0201696:	00259713          	slli	a4,a1,0x2
ffffffffc020169a:	972e                	add	a4,a4,a1
ffffffffc020169c:	070e                	slli	a4,a4,0x3
ffffffffc020169e:	00e506b3          	add	a3,a0,a4
ffffffffc02016a2:	87aa                	mv	a5,a0
ffffffffc02016a4:	cf11                	beqz	a4,ffffffffc02016c0 <default_init_memmap+0x30>
ffffffffc02016a6:	6798                	ld	a4,8(a5)
ffffffffc02016a8:	8b05                	andi	a4,a4,1
ffffffffc02016aa:	cf49                	beqz	a4,ffffffffc0201744 <default_init_memmap+0xb4>
ffffffffc02016ac:	0007a823          	sw	zero,16(a5)
ffffffffc02016b0:	0007b423          	sd	zero,8(a5)
ffffffffc02016b4:	0007a023          	sw	zero,0(a5)
ffffffffc02016b8:	02878793          	addi	a5,a5,40
ffffffffc02016bc:	fed795e3          	bne	a5,a3,ffffffffc02016a6 <default_init_memmap+0x16>
ffffffffc02016c0:	2581                	sext.w	a1,a1
ffffffffc02016c2:	c90c                	sw	a1,16(a0)
ffffffffc02016c4:	4789                	li	a5,2
ffffffffc02016c6:	00850713          	addi	a4,a0,8
ffffffffc02016ca:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc02016ce:	00006697          	auipc	a3,0x6
ffffffffc02016d2:	95a68693          	addi	a3,a3,-1702 # ffffffffc0207028 <free_area>
ffffffffc02016d6:	4a98                	lw	a4,16(a3)
ffffffffc02016d8:	669c                	ld	a5,8(a3)
ffffffffc02016da:	9f2d                	addw	a4,a4,a1
ffffffffc02016dc:	ca98                	sw	a4,16(a3)
ffffffffc02016de:	04d78663          	beq	a5,a3,ffffffffc020172a <default_init_memmap+0x9a>
ffffffffc02016e2:	fe878713          	addi	a4,a5,-24
ffffffffc02016e6:	4581                	li	a1,0
ffffffffc02016e8:	01850613          	addi	a2,a0,24
ffffffffc02016ec:	00e56a63          	bltu	a0,a4,ffffffffc0201700 <default_init_memmap+0x70>
ffffffffc02016f0:	6798                	ld	a4,8(a5)
ffffffffc02016f2:	02d70263          	beq	a4,a3,ffffffffc0201716 <default_init_memmap+0x86>
ffffffffc02016f6:	87ba                	mv	a5,a4
ffffffffc02016f8:	fe878713          	addi	a4,a5,-24
ffffffffc02016fc:	fee57ae3          	bgeu	a0,a4,ffffffffc02016f0 <default_init_memmap+0x60>
ffffffffc0201700:	c199                	beqz	a1,ffffffffc0201706 <default_init_memmap+0x76>
ffffffffc0201702:	0106b023          	sd	a6,0(a3)
ffffffffc0201706:	6398                	ld	a4,0(a5)
ffffffffc0201708:	60a2                	ld	ra,8(sp)
ffffffffc020170a:	e390                	sd	a2,0(a5)
ffffffffc020170c:	e710                	sd	a2,8(a4)
ffffffffc020170e:	f11c                	sd	a5,32(a0)
ffffffffc0201710:	ed18                	sd	a4,24(a0)
ffffffffc0201712:	0141                	addi	sp,sp,16
ffffffffc0201714:	8082                	ret
ffffffffc0201716:	e790                	sd	a2,8(a5)
ffffffffc0201718:	f114                	sd	a3,32(a0)
ffffffffc020171a:	6798                	ld	a4,8(a5)
ffffffffc020171c:	ed1c                	sd	a5,24(a0)
ffffffffc020171e:	8832                	mv	a6,a2
ffffffffc0201720:	00d70e63          	beq	a4,a3,ffffffffc020173c <default_init_memmap+0xac>
ffffffffc0201724:	4585                	li	a1,1
ffffffffc0201726:	87ba                	mv	a5,a4
ffffffffc0201728:	bfc1                	j	ffffffffc02016f8 <default_init_memmap+0x68>
ffffffffc020172a:	60a2                	ld	ra,8(sp)
ffffffffc020172c:	01850713          	addi	a4,a0,24
ffffffffc0201730:	e398                	sd	a4,0(a5)
ffffffffc0201732:	e798                	sd	a4,8(a5)
ffffffffc0201734:	f11c                	sd	a5,32(a0)
ffffffffc0201736:	ed1c                	sd	a5,24(a0)
ffffffffc0201738:	0141                	addi	sp,sp,16
ffffffffc020173a:	8082                	ret
ffffffffc020173c:	60a2                	ld	ra,8(sp)
ffffffffc020173e:	e290                	sd	a2,0(a3)
ffffffffc0201740:	0141                	addi	sp,sp,16
ffffffffc0201742:	8082                	ret
ffffffffc0201744:	00001697          	auipc	a3,0x1
ffffffffc0201748:	55c68693          	addi	a3,a3,1372 # ffffffffc0202ca0 <etext+0xc9c>
ffffffffc020174c:	00001617          	auipc	a2,0x1
ffffffffc0201750:	1cc60613          	addi	a2,a2,460 # ffffffffc0202918 <etext+0x914>
ffffffffc0201754:	04900593          	li	a1,73
ffffffffc0201758:	00001517          	auipc	a0,0x1
ffffffffc020175c:	1d850513          	addi	a0,a0,472 # ffffffffc0202930 <etext+0x92c>
ffffffffc0201760:	cb7fe0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc0201764:	00001697          	auipc	a3,0x1
ffffffffc0201768:	50c68693          	addi	a3,a3,1292 # ffffffffc0202c70 <etext+0xc6c>
ffffffffc020176c:	00001617          	auipc	a2,0x1
ffffffffc0201770:	1ac60613          	addi	a2,a2,428 # ffffffffc0202918 <etext+0x914>
ffffffffc0201774:	04600593          	li	a1,70
ffffffffc0201778:	00001517          	auipc	a0,0x1
ffffffffc020177c:	1b850513          	addi	a0,a0,440 # ffffffffc0202930 <etext+0x92c>
ffffffffc0201780:	c97fe0ef          	jal	ffffffffc0200416 <__panic>

ffffffffc0201784 <alloc_pages>:
ffffffffc0201784:	100027f3          	csrr	a5,sstatus
ffffffffc0201788:	8b89                	andi	a5,a5,2
ffffffffc020178a:	e799                	bnez	a5,ffffffffc0201798 <alloc_pages+0x14>
ffffffffc020178c:	00006797          	auipc	a5,0x6
ffffffffc0201790:	ce47b783          	ld	a5,-796(a5) # ffffffffc0207470 <pmm_manager>
ffffffffc0201794:	6f9c                	ld	a5,24(a5)
ffffffffc0201796:	8782                	jr	a5
ffffffffc0201798:	1141                	addi	sp,sp,-16
ffffffffc020179a:	e406                	sd	ra,8(sp)
ffffffffc020179c:	e022                	sd	s0,0(sp)
ffffffffc020179e:	842a                	mv	s0,a0
ffffffffc02017a0:	8a6ff0ef          	jal	ffffffffc0200846 <intr_disable>
ffffffffc02017a4:	00006797          	auipc	a5,0x6
ffffffffc02017a8:	ccc7b783          	ld	a5,-820(a5) # ffffffffc0207470 <pmm_manager>
ffffffffc02017ac:	6f9c                	ld	a5,24(a5)
ffffffffc02017ae:	8522                	mv	a0,s0
ffffffffc02017b0:	9782                	jalr	a5
ffffffffc02017b2:	842a                	mv	s0,a0
ffffffffc02017b4:	88cff0ef          	jal	ffffffffc0200840 <intr_enable>
ffffffffc02017b8:	60a2                	ld	ra,8(sp)
ffffffffc02017ba:	8522                	mv	a0,s0
ffffffffc02017bc:	6402                	ld	s0,0(sp)
ffffffffc02017be:	0141                	addi	sp,sp,16
ffffffffc02017c0:	8082                	ret

ffffffffc02017c2 <free_pages>:
ffffffffc02017c2:	100027f3          	csrr	a5,sstatus
ffffffffc02017c6:	8b89                	andi	a5,a5,2
ffffffffc02017c8:	e799                	bnez	a5,ffffffffc02017d6 <free_pages+0x14>
ffffffffc02017ca:	00006797          	auipc	a5,0x6
ffffffffc02017ce:	ca67b783          	ld	a5,-858(a5) # ffffffffc0207470 <pmm_manager>
ffffffffc02017d2:	739c                	ld	a5,32(a5)
ffffffffc02017d4:	8782                	jr	a5
ffffffffc02017d6:	1101                	addi	sp,sp,-32
ffffffffc02017d8:	ec06                	sd	ra,24(sp)
ffffffffc02017da:	e822                	sd	s0,16(sp)
ffffffffc02017dc:	e426                	sd	s1,8(sp)
ffffffffc02017de:	842a                	mv	s0,a0
ffffffffc02017e0:	84ae                	mv	s1,a1
ffffffffc02017e2:	864ff0ef          	jal	ffffffffc0200846 <intr_disable>
ffffffffc02017e6:	00006797          	auipc	a5,0x6
ffffffffc02017ea:	c8a7b783          	ld	a5,-886(a5) # ffffffffc0207470 <pmm_manager>
ffffffffc02017ee:	739c                	ld	a5,32(a5)
ffffffffc02017f0:	85a6                	mv	a1,s1
ffffffffc02017f2:	8522                	mv	a0,s0
ffffffffc02017f4:	9782                	jalr	a5
ffffffffc02017f6:	6442                	ld	s0,16(sp)
ffffffffc02017f8:	60e2                	ld	ra,24(sp)
ffffffffc02017fa:	64a2                	ld	s1,8(sp)
ffffffffc02017fc:	6105                	addi	sp,sp,32
ffffffffc02017fe:	842ff06f          	j	ffffffffc0200840 <intr_enable>

ffffffffc0201802 <nr_free_pages>:
ffffffffc0201802:	100027f3          	csrr	a5,sstatus
ffffffffc0201806:	8b89                	andi	a5,a5,2
ffffffffc0201808:	e799                	bnez	a5,ffffffffc0201816 <nr_free_pages+0x14>
ffffffffc020180a:	00006797          	auipc	a5,0x6
ffffffffc020180e:	c667b783          	ld	a5,-922(a5) # ffffffffc0207470 <pmm_manager>
ffffffffc0201812:	779c                	ld	a5,40(a5)
ffffffffc0201814:	8782                	jr	a5
ffffffffc0201816:	1141                	addi	sp,sp,-16
ffffffffc0201818:	e406                	sd	ra,8(sp)
ffffffffc020181a:	e022                	sd	s0,0(sp)
ffffffffc020181c:	82aff0ef          	jal	ffffffffc0200846 <intr_disable>
ffffffffc0201820:	00006797          	auipc	a5,0x6
ffffffffc0201824:	c507b783          	ld	a5,-944(a5) # ffffffffc0207470 <pmm_manager>
ffffffffc0201828:	779c                	ld	a5,40(a5)
ffffffffc020182a:	9782                	jalr	a5
ffffffffc020182c:	842a                	mv	s0,a0
ffffffffc020182e:	812ff0ef          	jal	ffffffffc0200840 <intr_enable>
ffffffffc0201832:	60a2                	ld	ra,8(sp)
ffffffffc0201834:	8522                	mv	a0,s0
ffffffffc0201836:	6402                	ld	s0,0(sp)
ffffffffc0201838:	0141                	addi	sp,sp,16
ffffffffc020183a:	8082                	ret

ffffffffc020183c <pmm_init>:
ffffffffc020183c:	00001797          	auipc	a5,0x1
ffffffffc0201840:	72478793          	addi	a5,a5,1828 # ffffffffc0202f60 <default_pmm_manager>
ffffffffc0201844:	638c                	ld	a1,0(a5)
ffffffffc0201846:	7179                	addi	sp,sp,-48
ffffffffc0201848:	f406                	sd	ra,40(sp)
ffffffffc020184a:	f022                	sd	s0,32(sp)
ffffffffc020184c:	ec26                	sd	s1,24(sp)
ffffffffc020184e:	e052                	sd	s4,0(sp)
ffffffffc0201850:	e84a                	sd	s2,16(sp)
ffffffffc0201852:	e44e                	sd	s3,8(sp)
ffffffffc0201854:	00006417          	auipc	s0,0x6
ffffffffc0201858:	c1c40413          	addi	s0,s0,-996 # ffffffffc0207470 <pmm_manager>
ffffffffc020185c:	00001517          	auipc	a0,0x1
ffffffffc0201860:	46c50513          	addi	a0,a0,1132 # ffffffffc0202cc8 <etext+0xcc4>
ffffffffc0201864:	e01c                	sd	a5,0(s0)
ffffffffc0201866:	8bdfe0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc020186a:	601c                	ld	a5,0(s0)
ffffffffc020186c:	00006497          	auipc	s1,0x6
ffffffffc0201870:	c1c48493          	addi	s1,s1,-996 # ffffffffc0207488 <va_pa_offset>
ffffffffc0201874:	679c                	ld	a5,8(a5)
ffffffffc0201876:	9782                	jalr	a5
ffffffffc0201878:	57f5                	li	a5,-3
ffffffffc020187a:	07fa                	slli	a5,a5,0x1e
ffffffffc020187c:	e09c                	sd	a5,0(s1)
ffffffffc020187e:	faffe0ef          	jal	ffffffffc020082c <get_memory_base>
ffffffffc0201882:	8a2a                	mv	s4,a0
ffffffffc0201884:	fb3fe0ef          	jal	ffffffffc0200836 <get_memory_size>
ffffffffc0201888:	18050363          	beqz	a0,ffffffffc0201a0e <pmm_init+0x1d2>
ffffffffc020188c:	89aa                	mv	s3,a0
ffffffffc020188e:	00001517          	auipc	a0,0x1
ffffffffc0201892:	48250513          	addi	a0,a0,1154 # ffffffffc0202d10 <etext+0xd0c>
ffffffffc0201896:	88dfe0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc020189a:	013a0933          	add	s2,s4,s3
ffffffffc020189e:	fff90693          	addi	a3,s2,-1
ffffffffc02018a2:	8652                	mv	a2,s4
ffffffffc02018a4:	85ce                	mv	a1,s3
ffffffffc02018a6:	00001517          	auipc	a0,0x1
ffffffffc02018aa:	48250513          	addi	a0,a0,1154 # ffffffffc0202d28 <etext+0xd24>
ffffffffc02018ae:	875fe0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02018b2:	c8000737          	lui	a4,0xc8000
ffffffffc02018b6:	87ca                	mv	a5,s2
ffffffffc02018b8:	0f276863          	bltu	a4,s2,ffffffffc02019a8 <pmm_init+0x16c>
ffffffffc02018bc:	00007697          	auipc	a3,0x7
ffffffffc02018c0:	beb68693          	addi	a3,a3,-1045 # ffffffffc02084a7 <end+0xfff>
ffffffffc02018c4:	777d                	lui	a4,0xfffff
ffffffffc02018c6:	8ef9                	and	a3,a3,a4
ffffffffc02018c8:	83b1                	srli	a5,a5,0xc
ffffffffc02018ca:	00006817          	auipc	a6,0x6
ffffffffc02018ce:	bc680813          	addi	a6,a6,-1082 # ffffffffc0207490 <npage>
ffffffffc02018d2:	00006597          	auipc	a1,0x6
ffffffffc02018d6:	bc658593          	addi	a1,a1,-1082 # ffffffffc0207498 <pages>
ffffffffc02018da:	00f83023          	sd	a5,0(a6)
ffffffffc02018de:	e194                	sd	a3,0(a1)
ffffffffc02018e0:	00080637          	lui	a2,0x80
ffffffffc02018e4:	88b6                	mv	a7,a3
ffffffffc02018e6:	04c78463          	beq	a5,a2,ffffffffc020192e <pmm_init+0xf2>
ffffffffc02018ea:	4785                	li	a5,1
ffffffffc02018ec:	00868713          	addi	a4,a3,8
ffffffffc02018f0:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc02018f4:	00083783          	ld	a5,0(a6)
ffffffffc02018f8:	4705                	li	a4,1
ffffffffc02018fa:	02800693          	li	a3,40
ffffffffc02018fe:	40c78633          	sub	a2,a5,a2
ffffffffc0201902:	4885                	li	a7,1
ffffffffc0201904:	fff80537          	lui	a0,0xfff80
ffffffffc0201908:	02c77063          	bgeu	a4,a2,ffffffffc0201928 <pmm_init+0xec>
ffffffffc020190c:	619c                	ld	a5,0(a1)
ffffffffc020190e:	97b6                	add	a5,a5,a3
ffffffffc0201910:	07a1                	addi	a5,a5,8
ffffffffc0201912:	4117b02f          	amoor.d	zero,a7,(a5)
ffffffffc0201916:	00083783          	ld	a5,0(a6)
ffffffffc020191a:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0x3fdf7b59>
ffffffffc020191c:	02868693          	addi	a3,a3,40
ffffffffc0201920:	00a78633          	add	a2,a5,a0
ffffffffc0201924:	fec764e3          	bltu	a4,a2,ffffffffc020190c <pmm_init+0xd0>
ffffffffc0201928:	0005b883          	ld	a7,0(a1)
ffffffffc020192c:	86c6                	mv	a3,a7
ffffffffc020192e:	00279713          	slli	a4,a5,0x2
ffffffffc0201932:	973e                	add	a4,a4,a5
ffffffffc0201934:	fec00637          	lui	a2,0xfec00
ffffffffc0201938:	070e                	slli	a4,a4,0x3
ffffffffc020193a:	96b2                	add	a3,a3,a2
ffffffffc020193c:	96ba                	add	a3,a3,a4
ffffffffc020193e:	c0200737          	lui	a4,0xc0200
ffffffffc0201942:	0ae6ea63          	bltu	a3,a4,ffffffffc02019f6 <pmm_init+0x1ba>
ffffffffc0201946:	6090                	ld	a2,0(s1)
ffffffffc0201948:	777d                	lui	a4,0xfffff
ffffffffc020194a:	00e97933          	and	s2,s2,a4
ffffffffc020194e:	8e91                	sub	a3,a3,a2
ffffffffc0201950:	0526ef63          	bltu	a3,s2,ffffffffc02019ae <pmm_init+0x172>
ffffffffc0201954:	601c                	ld	a5,0(s0)
ffffffffc0201956:	7b9c                	ld	a5,48(a5)
ffffffffc0201958:	9782                	jalr	a5
ffffffffc020195a:	00001517          	auipc	a0,0x1
ffffffffc020195e:	45650513          	addi	a0,a0,1110 # ffffffffc0202db0 <etext+0xdac>
ffffffffc0201962:	fc0fe0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0201966:	00004597          	auipc	a1,0x4
ffffffffc020196a:	69a58593          	addi	a1,a1,1690 # ffffffffc0206000 <boot_page_table_sv39>
ffffffffc020196e:	00006797          	auipc	a5,0x6
ffffffffc0201972:	b0b7b923          	sd	a1,-1262(a5) # ffffffffc0207480 <satp_virtual>
ffffffffc0201976:	c02007b7          	lui	a5,0xc0200
ffffffffc020197a:	0af5e663          	bltu	a1,a5,ffffffffc0201a26 <pmm_init+0x1ea>
ffffffffc020197e:	609c                	ld	a5,0(s1)
ffffffffc0201980:	7402                	ld	s0,32(sp)
ffffffffc0201982:	70a2                	ld	ra,40(sp)
ffffffffc0201984:	64e2                	ld	s1,24(sp)
ffffffffc0201986:	6942                	ld	s2,16(sp)
ffffffffc0201988:	69a2                	ld	s3,8(sp)
ffffffffc020198a:	6a02                	ld	s4,0(sp)
ffffffffc020198c:	40f586b3          	sub	a3,a1,a5
ffffffffc0201990:	00006797          	auipc	a5,0x6
ffffffffc0201994:	aed7b423          	sd	a3,-1304(a5) # ffffffffc0207478 <satp_physical>
ffffffffc0201998:	00001517          	auipc	a0,0x1
ffffffffc020199c:	43850513          	addi	a0,a0,1080 # ffffffffc0202dd0 <etext+0xdcc>
ffffffffc02019a0:	8636                	mv	a2,a3
ffffffffc02019a2:	6145                	addi	sp,sp,48
ffffffffc02019a4:	f7efe06f          	j	ffffffffc0200122 <cprintf>
ffffffffc02019a8:	c80007b7          	lui	a5,0xc8000
ffffffffc02019ac:	bf01                	j	ffffffffc02018bc <pmm_init+0x80>
ffffffffc02019ae:	6605                	lui	a2,0x1
ffffffffc02019b0:	167d                	addi	a2,a2,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc02019b2:	96b2                	add	a3,a3,a2
ffffffffc02019b4:	8ef9                	and	a3,a3,a4
ffffffffc02019b6:	00c6d713          	srli	a4,a3,0xc
ffffffffc02019ba:	02f77263          	bgeu	a4,a5,ffffffffc02019de <pmm_init+0x1a2>
ffffffffc02019be:	6010                	ld	a2,0(s0)
ffffffffc02019c0:	fff807b7          	lui	a5,0xfff80
ffffffffc02019c4:	97ba                	add	a5,a5,a4
ffffffffc02019c6:	00279513          	slli	a0,a5,0x2
ffffffffc02019ca:	953e                	add	a0,a0,a5
ffffffffc02019cc:	6a1c                	ld	a5,16(a2)
ffffffffc02019ce:	40d90933          	sub	s2,s2,a3
ffffffffc02019d2:	050e                	slli	a0,a0,0x3
ffffffffc02019d4:	00c95593          	srli	a1,s2,0xc
ffffffffc02019d8:	9546                	add	a0,a0,a7
ffffffffc02019da:	9782                	jalr	a5
ffffffffc02019dc:	bfa5                	j	ffffffffc0201954 <pmm_init+0x118>
ffffffffc02019de:	00001617          	auipc	a2,0x1
ffffffffc02019e2:	3a260613          	addi	a2,a2,930 # ffffffffc0202d80 <etext+0xd7c>
ffffffffc02019e6:	06b00593          	li	a1,107
ffffffffc02019ea:	00001517          	auipc	a0,0x1
ffffffffc02019ee:	3b650513          	addi	a0,a0,950 # ffffffffc0202da0 <etext+0xd9c>
ffffffffc02019f2:	a25fe0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc02019f6:	00001617          	auipc	a2,0x1
ffffffffc02019fa:	36260613          	addi	a2,a2,866 # ffffffffc0202d58 <etext+0xd54>
ffffffffc02019fe:	07100593          	li	a1,113
ffffffffc0201a02:	00001517          	auipc	a0,0x1
ffffffffc0201a06:	2fe50513          	addi	a0,a0,766 # ffffffffc0202d00 <etext+0xcfc>
ffffffffc0201a0a:	a0dfe0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc0201a0e:	00001617          	auipc	a2,0x1
ffffffffc0201a12:	2d260613          	addi	a2,a2,722 # ffffffffc0202ce0 <etext+0xcdc>
ffffffffc0201a16:	05a00593          	li	a1,90
ffffffffc0201a1a:	00001517          	auipc	a0,0x1
ffffffffc0201a1e:	2e650513          	addi	a0,a0,742 # ffffffffc0202d00 <etext+0xcfc>
ffffffffc0201a22:	9f5fe0ef          	jal	ffffffffc0200416 <__panic>
ffffffffc0201a26:	86ae                	mv	a3,a1
ffffffffc0201a28:	00001617          	auipc	a2,0x1
ffffffffc0201a2c:	33060613          	addi	a2,a2,816 # ffffffffc0202d58 <etext+0xd54>
ffffffffc0201a30:	08c00593          	li	a1,140
ffffffffc0201a34:	00001517          	auipc	a0,0x1
ffffffffc0201a38:	2cc50513          	addi	a0,a0,716 # ffffffffc0202d00 <etext+0xcfc>
ffffffffc0201a3c:	9dbfe0ef          	jal	ffffffffc0200416 <__panic>

ffffffffc0201a40 <printnum>:
ffffffffc0201a40:	02069813          	slli	a6,a3,0x20
ffffffffc0201a44:	7179                	addi	sp,sp,-48
ffffffffc0201a46:	02085813          	srli	a6,a6,0x20
ffffffffc0201a4a:	e052                	sd	s4,0(sp)
ffffffffc0201a4c:	03067a33          	remu	s4,a2,a6
ffffffffc0201a50:	f022                	sd	s0,32(sp)
ffffffffc0201a52:	ec26                	sd	s1,24(sp)
ffffffffc0201a54:	e84a                	sd	s2,16(sp)
ffffffffc0201a56:	f406                	sd	ra,40(sp)
ffffffffc0201a58:	84aa                	mv	s1,a0
ffffffffc0201a5a:	892e                	mv	s2,a1
ffffffffc0201a5c:	fff7041b          	addiw	s0,a4,-1 # ffffffffffffefff <end+0x3fdf7b57>
ffffffffc0201a60:	2a01                	sext.w	s4,s4
ffffffffc0201a62:	05067063          	bgeu	a2,a6,ffffffffc0201aa2 <printnum+0x62>
ffffffffc0201a66:	e44e                	sd	s3,8(sp)
ffffffffc0201a68:	89be                	mv	s3,a5
ffffffffc0201a6a:	4785                	li	a5,1
ffffffffc0201a6c:	00e7d763          	bge	a5,a4,ffffffffc0201a7a <printnum+0x3a>
ffffffffc0201a70:	85ca                	mv	a1,s2
ffffffffc0201a72:	854e                	mv	a0,s3
ffffffffc0201a74:	347d                	addiw	s0,s0,-1
ffffffffc0201a76:	9482                	jalr	s1
ffffffffc0201a78:	fc65                	bnez	s0,ffffffffc0201a70 <printnum+0x30>
ffffffffc0201a7a:	69a2                	ld	s3,8(sp)
ffffffffc0201a7c:	1a02                	slli	s4,s4,0x20
ffffffffc0201a7e:	020a5a13          	srli	s4,s4,0x20
ffffffffc0201a82:	00001797          	auipc	a5,0x1
ffffffffc0201a86:	38e78793          	addi	a5,a5,910 # ffffffffc0202e10 <etext+0xe0c>
ffffffffc0201a8a:	97d2                	add	a5,a5,s4
ffffffffc0201a8c:	7402                	ld	s0,32(sp)
ffffffffc0201a8e:	0007c503          	lbu	a0,0(a5)
ffffffffc0201a92:	70a2                	ld	ra,40(sp)
ffffffffc0201a94:	6a02                	ld	s4,0(sp)
ffffffffc0201a96:	85ca                	mv	a1,s2
ffffffffc0201a98:	87a6                	mv	a5,s1
ffffffffc0201a9a:	6942                	ld	s2,16(sp)
ffffffffc0201a9c:	64e2                	ld	s1,24(sp)
ffffffffc0201a9e:	6145                	addi	sp,sp,48
ffffffffc0201aa0:	8782                	jr	a5
ffffffffc0201aa2:	03065633          	divu	a2,a2,a6
ffffffffc0201aa6:	8722                	mv	a4,s0
ffffffffc0201aa8:	f99ff0ef          	jal	ffffffffc0201a40 <printnum>
ffffffffc0201aac:	bfc1                	j	ffffffffc0201a7c <printnum+0x3c>

ffffffffc0201aae <vprintfmt>:
ffffffffc0201aae:	7119                	addi	sp,sp,-128
ffffffffc0201ab0:	f4a6                	sd	s1,104(sp)
ffffffffc0201ab2:	f0ca                	sd	s2,96(sp)
ffffffffc0201ab4:	ecce                	sd	s3,88(sp)
ffffffffc0201ab6:	e8d2                	sd	s4,80(sp)
ffffffffc0201ab8:	e4d6                	sd	s5,72(sp)
ffffffffc0201aba:	e0da                	sd	s6,64(sp)
ffffffffc0201abc:	f862                	sd	s8,48(sp)
ffffffffc0201abe:	fc86                	sd	ra,120(sp)
ffffffffc0201ac0:	f8a2                	sd	s0,112(sp)
ffffffffc0201ac2:	fc5e                	sd	s7,56(sp)
ffffffffc0201ac4:	f466                	sd	s9,40(sp)
ffffffffc0201ac6:	f06a                	sd	s10,32(sp)
ffffffffc0201ac8:	ec6e                	sd	s11,24(sp)
ffffffffc0201aca:	892a                	mv	s2,a0
ffffffffc0201acc:	84ae                	mv	s1,a1
ffffffffc0201ace:	8c32                	mv	s8,a2
ffffffffc0201ad0:	8a36                	mv	s4,a3
ffffffffc0201ad2:	02500993          	li	s3,37
ffffffffc0201ad6:	05500b13          	li	s6,85
ffffffffc0201ada:	00001a97          	auipc	s5,0x1
ffffffffc0201ade:	4bea8a93          	addi	s5,s5,1214 # ffffffffc0202f98 <default_pmm_manager+0x38>
ffffffffc0201ae2:	000c4503          	lbu	a0,0(s8)
ffffffffc0201ae6:	001c0413          	addi	s0,s8,1
ffffffffc0201aea:	01350a63          	beq	a0,s3,ffffffffc0201afe <vprintfmt+0x50>
ffffffffc0201aee:	cd0d                	beqz	a0,ffffffffc0201b28 <vprintfmt+0x7a>
ffffffffc0201af0:	85a6                	mv	a1,s1
ffffffffc0201af2:	9902                	jalr	s2
ffffffffc0201af4:	00044503          	lbu	a0,0(s0)
ffffffffc0201af8:	0405                	addi	s0,s0,1
ffffffffc0201afa:	ff351ae3          	bne	a0,s3,ffffffffc0201aee <vprintfmt+0x40>
ffffffffc0201afe:	02000d93          	li	s11,32
ffffffffc0201b02:	4b81                	li	s7,0
ffffffffc0201b04:	4601                	li	a2,0
ffffffffc0201b06:	5d7d                	li	s10,-1
ffffffffc0201b08:	5cfd                	li	s9,-1
ffffffffc0201b0a:	00044683          	lbu	a3,0(s0)
ffffffffc0201b0e:	00140c13          	addi	s8,s0,1
ffffffffc0201b12:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0201b16:	0ff5f593          	zext.b	a1,a1
ffffffffc0201b1a:	02bb6663          	bltu	s6,a1,ffffffffc0201b46 <vprintfmt+0x98>
ffffffffc0201b1e:	058a                	slli	a1,a1,0x2
ffffffffc0201b20:	95d6                	add	a1,a1,s5
ffffffffc0201b22:	4198                	lw	a4,0(a1)
ffffffffc0201b24:	9756                	add	a4,a4,s5
ffffffffc0201b26:	8702                	jr	a4
ffffffffc0201b28:	70e6                	ld	ra,120(sp)
ffffffffc0201b2a:	7446                	ld	s0,112(sp)
ffffffffc0201b2c:	74a6                	ld	s1,104(sp)
ffffffffc0201b2e:	7906                	ld	s2,96(sp)
ffffffffc0201b30:	69e6                	ld	s3,88(sp)
ffffffffc0201b32:	6a46                	ld	s4,80(sp)
ffffffffc0201b34:	6aa6                	ld	s5,72(sp)
ffffffffc0201b36:	6b06                	ld	s6,64(sp)
ffffffffc0201b38:	7be2                	ld	s7,56(sp)
ffffffffc0201b3a:	7c42                	ld	s8,48(sp)
ffffffffc0201b3c:	7ca2                	ld	s9,40(sp)
ffffffffc0201b3e:	7d02                	ld	s10,32(sp)
ffffffffc0201b40:	6de2                	ld	s11,24(sp)
ffffffffc0201b42:	6109                	addi	sp,sp,128
ffffffffc0201b44:	8082                	ret
ffffffffc0201b46:	85a6                	mv	a1,s1
ffffffffc0201b48:	02500513          	li	a0,37
ffffffffc0201b4c:	9902                	jalr	s2
ffffffffc0201b4e:	fff44703          	lbu	a4,-1(s0)
ffffffffc0201b52:	02500793          	li	a5,37
ffffffffc0201b56:	8c22                	mv	s8,s0
ffffffffc0201b58:	f8f705e3          	beq	a4,a5,ffffffffc0201ae2 <vprintfmt+0x34>
ffffffffc0201b5c:	02500713          	li	a4,37
ffffffffc0201b60:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0201b64:	1c7d                	addi	s8,s8,-1
ffffffffc0201b66:	fee79de3          	bne	a5,a4,ffffffffc0201b60 <vprintfmt+0xb2>
ffffffffc0201b6a:	bfa5                	j	ffffffffc0201ae2 <vprintfmt+0x34>
ffffffffc0201b6c:	00144783          	lbu	a5,1(s0)
ffffffffc0201b70:	4725                	li	a4,9
ffffffffc0201b72:	fd068d1b          	addiw	s10,a3,-48
ffffffffc0201b76:	fd07859b          	addiw	a1,a5,-48
ffffffffc0201b7a:	0007869b          	sext.w	a3,a5
ffffffffc0201b7e:	8462                	mv	s0,s8
ffffffffc0201b80:	02b76563          	bltu	a4,a1,ffffffffc0201baa <vprintfmt+0xfc>
ffffffffc0201b84:	4525                	li	a0,9
ffffffffc0201b86:	00144783          	lbu	a5,1(s0)
ffffffffc0201b8a:	002d171b          	slliw	a4,s10,0x2
ffffffffc0201b8e:	01a7073b          	addw	a4,a4,s10
ffffffffc0201b92:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201b96:	9f35                	addw	a4,a4,a3
ffffffffc0201b98:	fd07859b          	addiw	a1,a5,-48
ffffffffc0201b9c:	0405                	addi	s0,s0,1
ffffffffc0201b9e:	fd070d1b          	addiw	s10,a4,-48
ffffffffc0201ba2:	0007869b          	sext.w	a3,a5
ffffffffc0201ba6:	feb570e3          	bgeu	a0,a1,ffffffffc0201b86 <vprintfmt+0xd8>
ffffffffc0201baa:	f60cd0e3          	bgez	s9,ffffffffc0201b0a <vprintfmt+0x5c>
ffffffffc0201bae:	8cea                	mv	s9,s10
ffffffffc0201bb0:	5d7d                	li	s10,-1
ffffffffc0201bb2:	bfa1                	j	ffffffffc0201b0a <vprintfmt+0x5c>
ffffffffc0201bb4:	8db6                	mv	s11,a3
ffffffffc0201bb6:	8462                	mv	s0,s8
ffffffffc0201bb8:	bf89                	j	ffffffffc0201b0a <vprintfmt+0x5c>
ffffffffc0201bba:	8462                	mv	s0,s8
ffffffffc0201bbc:	4b85                	li	s7,1
ffffffffc0201bbe:	b7b1                	j	ffffffffc0201b0a <vprintfmt+0x5c>
ffffffffc0201bc0:	4785                	li	a5,1
ffffffffc0201bc2:	008a0713          	addi	a4,s4,8
ffffffffc0201bc6:	00c7c463          	blt	a5,a2,ffffffffc0201bce <vprintfmt+0x120>
ffffffffc0201bca:	1a060163          	beqz	a2,ffffffffc0201d6c <vprintfmt+0x2be>
ffffffffc0201bce:	000a3603          	ld	a2,0(s4)
ffffffffc0201bd2:	46c1                	li	a3,16
ffffffffc0201bd4:	8a3a                	mv	s4,a4
ffffffffc0201bd6:	000d879b          	sext.w	a5,s11
ffffffffc0201bda:	8766                	mv	a4,s9
ffffffffc0201bdc:	85a6                	mv	a1,s1
ffffffffc0201bde:	854a                	mv	a0,s2
ffffffffc0201be0:	e61ff0ef          	jal	ffffffffc0201a40 <printnum>
ffffffffc0201be4:	bdfd                	j	ffffffffc0201ae2 <vprintfmt+0x34>
ffffffffc0201be6:	000a2503          	lw	a0,0(s4)
ffffffffc0201bea:	85a6                	mv	a1,s1
ffffffffc0201bec:	0a21                	addi	s4,s4,8
ffffffffc0201bee:	9902                	jalr	s2
ffffffffc0201bf0:	bdcd                	j	ffffffffc0201ae2 <vprintfmt+0x34>
ffffffffc0201bf2:	4785                	li	a5,1
ffffffffc0201bf4:	008a0713          	addi	a4,s4,8
ffffffffc0201bf8:	00c7c463          	blt	a5,a2,ffffffffc0201c00 <vprintfmt+0x152>
ffffffffc0201bfc:	16060363          	beqz	a2,ffffffffc0201d62 <vprintfmt+0x2b4>
ffffffffc0201c00:	000a3603          	ld	a2,0(s4)
ffffffffc0201c04:	46a9                	li	a3,10
ffffffffc0201c06:	8a3a                	mv	s4,a4
ffffffffc0201c08:	b7f9                	j	ffffffffc0201bd6 <vprintfmt+0x128>
ffffffffc0201c0a:	85a6                	mv	a1,s1
ffffffffc0201c0c:	03000513          	li	a0,48
ffffffffc0201c10:	9902                	jalr	s2
ffffffffc0201c12:	85a6                	mv	a1,s1
ffffffffc0201c14:	07800513          	li	a0,120
ffffffffc0201c18:	9902                	jalr	s2
ffffffffc0201c1a:	000a3603          	ld	a2,0(s4)
ffffffffc0201c1e:	46c1                	li	a3,16
ffffffffc0201c20:	0a21                	addi	s4,s4,8
ffffffffc0201c22:	bf55                	j	ffffffffc0201bd6 <vprintfmt+0x128>
ffffffffc0201c24:	85a6                	mv	a1,s1
ffffffffc0201c26:	02500513          	li	a0,37
ffffffffc0201c2a:	9902                	jalr	s2
ffffffffc0201c2c:	bd5d                	j	ffffffffc0201ae2 <vprintfmt+0x34>
ffffffffc0201c2e:	000a2d03          	lw	s10,0(s4)
ffffffffc0201c32:	8462                	mv	s0,s8
ffffffffc0201c34:	0a21                	addi	s4,s4,8
ffffffffc0201c36:	bf95                	j	ffffffffc0201baa <vprintfmt+0xfc>
ffffffffc0201c38:	4785                	li	a5,1
ffffffffc0201c3a:	008a0713          	addi	a4,s4,8
ffffffffc0201c3e:	00c7c463          	blt	a5,a2,ffffffffc0201c46 <vprintfmt+0x198>
ffffffffc0201c42:	10060b63          	beqz	a2,ffffffffc0201d58 <vprintfmt+0x2aa>
ffffffffc0201c46:	000a3603          	ld	a2,0(s4)
ffffffffc0201c4a:	46a1                	li	a3,8
ffffffffc0201c4c:	8a3a                	mv	s4,a4
ffffffffc0201c4e:	b761                	j	ffffffffc0201bd6 <vprintfmt+0x128>
ffffffffc0201c50:	fffcc793          	not	a5,s9
ffffffffc0201c54:	97fd                	srai	a5,a5,0x3f
ffffffffc0201c56:	00fcf7b3          	and	a5,s9,a5
ffffffffc0201c5a:	00078c9b          	sext.w	s9,a5
ffffffffc0201c5e:	8462                	mv	s0,s8
ffffffffc0201c60:	b56d                	j	ffffffffc0201b0a <vprintfmt+0x5c>
ffffffffc0201c62:	000a3403          	ld	s0,0(s4)
ffffffffc0201c66:	008a0793          	addi	a5,s4,8
ffffffffc0201c6a:	e43e                	sd	a5,8(sp)
ffffffffc0201c6c:	12040063          	beqz	s0,ffffffffc0201d8c <vprintfmt+0x2de>
ffffffffc0201c70:	0d905963          	blez	s9,ffffffffc0201d42 <vprintfmt+0x294>
ffffffffc0201c74:	02d00793          	li	a5,45
ffffffffc0201c78:	00140a13          	addi	s4,s0,1
ffffffffc0201c7c:	12fd9763          	bne	s11,a5,ffffffffc0201daa <vprintfmt+0x2fc>
ffffffffc0201c80:	00044783          	lbu	a5,0(s0)
ffffffffc0201c84:	0007851b          	sext.w	a0,a5
ffffffffc0201c88:	cb9d                	beqz	a5,ffffffffc0201cbe <vprintfmt+0x210>
ffffffffc0201c8a:	547d                	li	s0,-1
ffffffffc0201c8c:	05e00d93          	li	s11,94
ffffffffc0201c90:	000d4563          	bltz	s10,ffffffffc0201c9a <vprintfmt+0x1ec>
ffffffffc0201c94:	3d7d                	addiw	s10,s10,-1
ffffffffc0201c96:	028d0263          	beq	s10,s0,ffffffffc0201cba <vprintfmt+0x20c>
ffffffffc0201c9a:	85a6                	mv	a1,s1
ffffffffc0201c9c:	0c0b8d63          	beqz	s7,ffffffffc0201d76 <vprintfmt+0x2c8>
ffffffffc0201ca0:	3781                	addiw	a5,a5,-32
ffffffffc0201ca2:	0cfdfa63          	bgeu	s11,a5,ffffffffc0201d76 <vprintfmt+0x2c8>
ffffffffc0201ca6:	03f00513          	li	a0,63
ffffffffc0201caa:	9902                	jalr	s2
ffffffffc0201cac:	000a4783          	lbu	a5,0(s4)
ffffffffc0201cb0:	3cfd                	addiw	s9,s9,-1 # feffff <kern_entry-0xffffffffbf210001>
ffffffffc0201cb2:	0a05                	addi	s4,s4,1
ffffffffc0201cb4:	0007851b          	sext.w	a0,a5
ffffffffc0201cb8:	ffe1                	bnez	a5,ffffffffc0201c90 <vprintfmt+0x1e2>
ffffffffc0201cba:	01905963          	blez	s9,ffffffffc0201ccc <vprintfmt+0x21e>
ffffffffc0201cbe:	85a6                	mv	a1,s1
ffffffffc0201cc0:	02000513          	li	a0,32
ffffffffc0201cc4:	3cfd                	addiw	s9,s9,-1
ffffffffc0201cc6:	9902                	jalr	s2
ffffffffc0201cc8:	fe0c9be3          	bnez	s9,ffffffffc0201cbe <vprintfmt+0x210>
ffffffffc0201ccc:	6a22                	ld	s4,8(sp)
ffffffffc0201cce:	bd11                	j	ffffffffc0201ae2 <vprintfmt+0x34>
ffffffffc0201cd0:	4785                	li	a5,1
ffffffffc0201cd2:	008a0b93          	addi	s7,s4,8
ffffffffc0201cd6:	00c7c363          	blt	a5,a2,ffffffffc0201cdc <vprintfmt+0x22e>
ffffffffc0201cda:	ce25                	beqz	a2,ffffffffc0201d52 <vprintfmt+0x2a4>
ffffffffc0201cdc:	000a3403          	ld	s0,0(s4)
ffffffffc0201ce0:	08044d63          	bltz	s0,ffffffffc0201d7a <vprintfmt+0x2cc>
ffffffffc0201ce4:	8622                	mv	a2,s0
ffffffffc0201ce6:	8a5e                	mv	s4,s7
ffffffffc0201ce8:	46a9                	li	a3,10
ffffffffc0201cea:	b5f5                	j	ffffffffc0201bd6 <vprintfmt+0x128>
ffffffffc0201cec:	000a2783          	lw	a5,0(s4)
ffffffffc0201cf0:	4619                	li	a2,6
ffffffffc0201cf2:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0201cf6:	8fb9                	xor	a5,a5,a4
ffffffffc0201cf8:	40e786bb          	subw	a3,a5,a4
ffffffffc0201cfc:	02d64663          	blt	a2,a3,ffffffffc0201d28 <vprintfmt+0x27a>
ffffffffc0201d00:	00369713          	slli	a4,a3,0x3
ffffffffc0201d04:	00001797          	auipc	a5,0x1
ffffffffc0201d08:	3ec78793          	addi	a5,a5,1004 # ffffffffc02030f0 <error_string>
ffffffffc0201d0c:	97ba                	add	a5,a5,a4
ffffffffc0201d0e:	639c                	ld	a5,0(a5)
ffffffffc0201d10:	cf81                	beqz	a5,ffffffffc0201d28 <vprintfmt+0x27a>
ffffffffc0201d12:	86be                	mv	a3,a5
ffffffffc0201d14:	00001617          	auipc	a2,0x1
ffffffffc0201d18:	12c60613          	addi	a2,a2,300 # ffffffffc0202e40 <etext+0xe3c>
ffffffffc0201d1c:	85a6                	mv	a1,s1
ffffffffc0201d1e:	854a                	mv	a0,s2
ffffffffc0201d20:	0e8000ef          	jal	ffffffffc0201e08 <printfmt>
ffffffffc0201d24:	0a21                	addi	s4,s4,8
ffffffffc0201d26:	bb75                	j	ffffffffc0201ae2 <vprintfmt+0x34>
ffffffffc0201d28:	00001617          	auipc	a2,0x1
ffffffffc0201d2c:	10860613          	addi	a2,a2,264 # ffffffffc0202e30 <etext+0xe2c>
ffffffffc0201d30:	85a6                	mv	a1,s1
ffffffffc0201d32:	854a                	mv	a0,s2
ffffffffc0201d34:	0d4000ef          	jal	ffffffffc0201e08 <printfmt>
ffffffffc0201d38:	0a21                	addi	s4,s4,8
ffffffffc0201d3a:	b365                	j	ffffffffc0201ae2 <vprintfmt+0x34>
ffffffffc0201d3c:	2605                	addiw	a2,a2,1
ffffffffc0201d3e:	8462                	mv	s0,s8
ffffffffc0201d40:	b3e9                	j	ffffffffc0201b0a <vprintfmt+0x5c>
ffffffffc0201d42:	00044783          	lbu	a5,0(s0)
ffffffffc0201d46:	0007851b          	sext.w	a0,a5
ffffffffc0201d4a:	d3c9                	beqz	a5,ffffffffc0201ccc <vprintfmt+0x21e>
ffffffffc0201d4c:	00140a13          	addi	s4,s0,1
ffffffffc0201d50:	bf2d                	j	ffffffffc0201c8a <vprintfmt+0x1dc>
ffffffffc0201d52:	000a2403          	lw	s0,0(s4)
ffffffffc0201d56:	b769                	j	ffffffffc0201ce0 <vprintfmt+0x232>
ffffffffc0201d58:	000a6603          	lwu	a2,0(s4)
ffffffffc0201d5c:	46a1                	li	a3,8
ffffffffc0201d5e:	8a3a                	mv	s4,a4
ffffffffc0201d60:	bd9d                	j	ffffffffc0201bd6 <vprintfmt+0x128>
ffffffffc0201d62:	000a6603          	lwu	a2,0(s4)
ffffffffc0201d66:	46a9                	li	a3,10
ffffffffc0201d68:	8a3a                	mv	s4,a4
ffffffffc0201d6a:	b5b5                	j	ffffffffc0201bd6 <vprintfmt+0x128>
ffffffffc0201d6c:	000a6603          	lwu	a2,0(s4)
ffffffffc0201d70:	46c1                	li	a3,16
ffffffffc0201d72:	8a3a                	mv	s4,a4
ffffffffc0201d74:	b58d                	j	ffffffffc0201bd6 <vprintfmt+0x128>
ffffffffc0201d76:	9902                	jalr	s2
ffffffffc0201d78:	bf15                	j	ffffffffc0201cac <vprintfmt+0x1fe>
ffffffffc0201d7a:	85a6                	mv	a1,s1
ffffffffc0201d7c:	02d00513          	li	a0,45
ffffffffc0201d80:	9902                	jalr	s2
ffffffffc0201d82:	40800633          	neg	a2,s0
ffffffffc0201d86:	8a5e                	mv	s4,s7
ffffffffc0201d88:	46a9                	li	a3,10
ffffffffc0201d8a:	b5b1                	j	ffffffffc0201bd6 <vprintfmt+0x128>
ffffffffc0201d8c:	01905663          	blez	s9,ffffffffc0201d98 <vprintfmt+0x2ea>
ffffffffc0201d90:	02d00793          	li	a5,45
ffffffffc0201d94:	04fd9263          	bne	s11,a5,ffffffffc0201dd8 <vprintfmt+0x32a>
ffffffffc0201d98:	02800793          	li	a5,40
ffffffffc0201d9c:	00001a17          	auipc	s4,0x1
ffffffffc0201da0:	08da0a13          	addi	s4,s4,141 # ffffffffc0202e29 <etext+0xe25>
ffffffffc0201da4:	02800513          	li	a0,40
ffffffffc0201da8:	b5cd                	j	ffffffffc0201c8a <vprintfmt+0x1dc>
ffffffffc0201daa:	85ea                	mv	a1,s10
ffffffffc0201dac:	8522                	mv	a0,s0
ffffffffc0201dae:	1b2000ef          	jal	ffffffffc0201f60 <strnlen>
ffffffffc0201db2:	40ac8cbb          	subw	s9,s9,a0
ffffffffc0201db6:	01905963          	blez	s9,ffffffffc0201dc8 <vprintfmt+0x31a>
ffffffffc0201dba:	2d81                	sext.w	s11,s11
ffffffffc0201dbc:	85a6                	mv	a1,s1
ffffffffc0201dbe:	856e                	mv	a0,s11
ffffffffc0201dc0:	3cfd                	addiw	s9,s9,-1
ffffffffc0201dc2:	9902                	jalr	s2
ffffffffc0201dc4:	fe0c9ce3          	bnez	s9,ffffffffc0201dbc <vprintfmt+0x30e>
ffffffffc0201dc8:	00044783          	lbu	a5,0(s0)
ffffffffc0201dcc:	0007851b          	sext.w	a0,a5
ffffffffc0201dd0:	ea079de3          	bnez	a5,ffffffffc0201c8a <vprintfmt+0x1dc>
ffffffffc0201dd4:	6a22                	ld	s4,8(sp)
ffffffffc0201dd6:	b331                	j	ffffffffc0201ae2 <vprintfmt+0x34>
ffffffffc0201dd8:	85ea                	mv	a1,s10
ffffffffc0201dda:	00001517          	auipc	a0,0x1
ffffffffc0201dde:	04e50513          	addi	a0,a0,78 # ffffffffc0202e28 <etext+0xe24>
ffffffffc0201de2:	17e000ef          	jal	ffffffffc0201f60 <strnlen>
ffffffffc0201de6:	40ac8cbb          	subw	s9,s9,a0
ffffffffc0201dea:	00001417          	auipc	s0,0x1
ffffffffc0201dee:	03e40413          	addi	s0,s0,62 # ffffffffc0202e28 <etext+0xe24>
ffffffffc0201df2:	00001a17          	auipc	s4,0x1
ffffffffc0201df6:	037a0a13          	addi	s4,s4,55 # ffffffffc0202e29 <etext+0xe25>
ffffffffc0201dfa:	02800793          	li	a5,40
ffffffffc0201dfe:	02800513          	li	a0,40
ffffffffc0201e02:	fb904ce3          	bgtz	s9,ffffffffc0201dba <vprintfmt+0x30c>
ffffffffc0201e06:	b551                	j	ffffffffc0201c8a <vprintfmt+0x1dc>

ffffffffc0201e08 <printfmt>:
ffffffffc0201e08:	715d                	addi	sp,sp,-80
ffffffffc0201e0a:	02810313          	addi	t1,sp,40
ffffffffc0201e0e:	f436                	sd	a3,40(sp)
ffffffffc0201e10:	869a                	mv	a3,t1
ffffffffc0201e12:	ec06                	sd	ra,24(sp)
ffffffffc0201e14:	f83a                	sd	a4,48(sp)
ffffffffc0201e16:	fc3e                	sd	a5,56(sp)
ffffffffc0201e18:	e0c2                	sd	a6,64(sp)
ffffffffc0201e1a:	e4c6                	sd	a7,72(sp)
ffffffffc0201e1c:	e41a                	sd	t1,8(sp)
ffffffffc0201e1e:	c91ff0ef          	jal	ffffffffc0201aae <vprintfmt>
ffffffffc0201e22:	60e2                	ld	ra,24(sp)
ffffffffc0201e24:	6161                	addi	sp,sp,80
ffffffffc0201e26:	8082                	ret

ffffffffc0201e28 <readline>:
ffffffffc0201e28:	715d                	addi	sp,sp,-80
ffffffffc0201e2a:	e486                	sd	ra,72(sp)
ffffffffc0201e2c:	e0a2                	sd	s0,64(sp)
ffffffffc0201e2e:	fc26                	sd	s1,56(sp)
ffffffffc0201e30:	f84a                	sd	s2,48(sp)
ffffffffc0201e32:	f44e                	sd	s3,40(sp)
ffffffffc0201e34:	f052                	sd	s4,32(sp)
ffffffffc0201e36:	ec56                	sd	s5,24(sp)
ffffffffc0201e38:	e85a                	sd	s6,16(sp)
ffffffffc0201e3a:	c901                	beqz	a0,ffffffffc0201e4a <readline+0x22>
ffffffffc0201e3c:	85aa                	mv	a1,a0
ffffffffc0201e3e:	00001517          	auipc	a0,0x1
ffffffffc0201e42:	00250513          	addi	a0,a0,2 # ffffffffc0202e40 <etext+0xe3c>
ffffffffc0201e46:	adcfe0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0201e4a:	4401                	li	s0,0
ffffffffc0201e4c:	44fd                	li	s1,31
ffffffffc0201e4e:	4921                	li	s2,8
ffffffffc0201e50:	4a29                	li	s4,10
ffffffffc0201e52:	4ab5                	li	s5,13
ffffffffc0201e54:	00005b17          	auipc	s6,0x5
ffffffffc0201e58:	1ecb0b13          	addi	s6,s6,492 # ffffffffc0207040 <buf>
ffffffffc0201e5c:	3fe00993          	li	s3,1022
ffffffffc0201e60:	b46fe0ef          	jal	ffffffffc02001a6 <getchar>
ffffffffc0201e64:	00054a63          	bltz	a0,ffffffffc0201e78 <readline+0x50>
ffffffffc0201e68:	00a4da63          	bge	s1,a0,ffffffffc0201e7c <readline+0x54>
ffffffffc0201e6c:	0289d263          	bge	s3,s0,ffffffffc0201e90 <readline+0x68>
ffffffffc0201e70:	b36fe0ef          	jal	ffffffffc02001a6 <getchar>
ffffffffc0201e74:	fe055ae3          	bgez	a0,ffffffffc0201e68 <readline+0x40>
ffffffffc0201e78:	4501                	li	a0,0
ffffffffc0201e7a:	a091                	j	ffffffffc0201ebe <readline+0x96>
ffffffffc0201e7c:	03251463          	bne	a0,s2,ffffffffc0201ea4 <readline+0x7c>
ffffffffc0201e80:	04804963          	bgtz	s0,ffffffffc0201ed2 <readline+0xaa>
ffffffffc0201e84:	b22fe0ef          	jal	ffffffffc02001a6 <getchar>
ffffffffc0201e88:	fe0548e3          	bltz	a0,ffffffffc0201e78 <readline+0x50>
ffffffffc0201e8c:	fea4d8e3          	bge	s1,a0,ffffffffc0201e7c <readline+0x54>
ffffffffc0201e90:	e42a                	sd	a0,8(sp)
ffffffffc0201e92:	ac4fe0ef          	jal	ffffffffc0200156 <cputchar>
ffffffffc0201e96:	6522                	ld	a0,8(sp)
ffffffffc0201e98:	008b07b3          	add	a5,s6,s0
ffffffffc0201e9c:	2405                	addiw	s0,s0,1
ffffffffc0201e9e:	00a78023          	sb	a0,0(a5)
ffffffffc0201ea2:	bf7d                	j	ffffffffc0201e60 <readline+0x38>
ffffffffc0201ea4:	01450463          	beq	a0,s4,ffffffffc0201eac <readline+0x84>
ffffffffc0201ea8:	fb551ce3          	bne	a0,s5,ffffffffc0201e60 <readline+0x38>
ffffffffc0201eac:	aaafe0ef          	jal	ffffffffc0200156 <cputchar>
ffffffffc0201eb0:	00005517          	auipc	a0,0x5
ffffffffc0201eb4:	19050513          	addi	a0,a0,400 # ffffffffc0207040 <buf>
ffffffffc0201eb8:	942a                	add	s0,s0,a0
ffffffffc0201eba:	00040023          	sb	zero,0(s0)
ffffffffc0201ebe:	60a6                	ld	ra,72(sp)
ffffffffc0201ec0:	6406                	ld	s0,64(sp)
ffffffffc0201ec2:	74e2                	ld	s1,56(sp)
ffffffffc0201ec4:	7942                	ld	s2,48(sp)
ffffffffc0201ec6:	79a2                	ld	s3,40(sp)
ffffffffc0201ec8:	7a02                	ld	s4,32(sp)
ffffffffc0201eca:	6ae2                	ld	s5,24(sp)
ffffffffc0201ecc:	6b42                	ld	s6,16(sp)
ffffffffc0201ece:	6161                	addi	sp,sp,80
ffffffffc0201ed0:	8082                	ret
ffffffffc0201ed2:	4521                	li	a0,8
ffffffffc0201ed4:	a82fe0ef          	jal	ffffffffc0200156 <cputchar>
ffffffffc0201ed8:	347d                	addiw	s0,s0,-1
ffffffffc0201eda:	b759                	j	ffffffffc0201e60 <readline+0x38>

ffffffffc0201edc <sbi_console_putchar>:
ffffffffc0201edc:	4781                	li	a5,0
ffffffffc0201ede:	00005717          	auipc	a4,0x5
ffffffffc0201ee2:	14273703          	ld	a4,322(a4) # ffffffffc0207020 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201ee6:	88ba                	mv	a7,a4
ffffffffc0201ee8:	852a                	mv	a0,a0
ffffffffc0201eea:	85be                	mv	a1,a5
ffffffffc0201eec:	863e                	mv	a2,a5
ffffffffc0201eee:	00000073          	ecall
ffffffffc0201ef2:	87aa                	mv	a5,a0
ffffffffc0201ef4:	8082                	ret

ffffffffc0201ef6 <sbi_set_timer>:
ffffffffc0201ef6:	4781                	li	a5,0
ffffffffc0201ef8:	00005717          	auipc	a4,0x5
ffffffffc0201efc:	5a873703          	ld	a4,1448(a4) # ffffffffc02074a0 <SBI_SET_TIMER>
ffffffffc0201f00:	88ba                	mv	a7,a4
ffffffffc0201f02:	852a                	mv	a0,a0
ffffffffc0201f04:	85be                	mv	a1,a5
ffffffffc0201f06:	863e                	mv	a2,a5
ffffffffc0201f08:	00000073          	ecall
ffffffffc0201f0c:	87aa                	mv	a5,a0
ffffffffc0201f0e:	8082                	ret

ffffffffc0201f10 <sbi_console_getchar>:
ffffffffc0201f10:	4501                	li	a0,0
ffffffffc0201f12:	00005797          	auipc	a5,0x5
ffffffffc0201f16:	1067b783          	ld	a5,262(a5) # ffffffffc0207018 <SBI_CONSOLE_GETCHAR>
ffffffffc0201f1a:	88be                	mv	a7,a5
ffffffffc0201f1c:	852a                	mv	a0,a0
ffffffffc0201f1e:	85aa                	mv	a1,a0
ffffffffc0201f20:	862a                	mv	a2,a0
ffffffffc0201f22:	00000073          	ecall
ffffffffc0201f26:	852a                	mv	a0,a0
ffffffffc0201f28:	2501                	sext.w	a0,a0
ffffffffc0201f2a:	8082                	ret

ffffffffc0201f2c <sbi_shutdown>:
ffffffffc0201f2c:	4781                	li	a5,0
ffffffffc0201f2e:	00005717          	auipc	a4,0x5
ffffffffc0201f32:	0e273703          	ld	a4,226(a4) # ffffffffc0207010 <SBI_SHUTDOWN>
ffffffffc0201f36:	88ba                	mv	a7,a4
ffffffffc0201f38:	853e                	mv	a0,a5
ffffffffc0201f3a:	85be                	mv	a1,a5
ffffffffc0201f3c:	863e                	mv	a2,a5
ffffffffc0201f3e:	00000073          	ecall
ffffffffc0201f42:	87aa                	mv	a5,a0
ffffffffc0201f44:	8082                	ret

ffffffffc0201f46 <strlen>:
ffffffffc0201f46:	00054783          	lbu	a5,0(a0)
ffffffffc0201f4a:	872a                	mv	a4,a0
ffffffffc0201f4c:	4501                	li	a0,0
ffffffffc0201f4e:	cb81                	beqz	a5,ffffffffc0201f5e <strlen+0x18>
ffffffffc0201f50:	0505                	addi	a0,a0,1
ffffffffc0201f52:	00a707b3          	add	a5,a4,a0
ffffffffc0201f56:	0007c783          	lbu	a5,0(a5)
ffffffffc0201f5a:	fbfd                	bnez	a5,ffffffffc0201f50 <strlen+0xa>
ffffffffc0201f5c:	8082                	ret
ffffffffc0201f5e:	8082                	ret

ffffffffc0201f60 <strnlen>:
ffffffffc0201f60:	4781                	li	a5,0
ffffffffc0201f62:	e589                	bnez	a1,ffffffffc0201f6c <strnlen+0xc>
ffffffffc0201f64:	a811                	j	ffffffffc0201f78 <strnlen+0x18>
ffffffffc0201f66:	0785                	addi	a5,a5,1
ffffffffc0201f68:	00f58863          	beq	a1,a5,ffffffffc0201f78 <strnlen+0x18>
ffffffffc0201f6c:	00f50733          	add	a4,a0,a5
ffffffffc0201f70:	00074703          	lbu	a4,0(a4)
ffffffffc0201f74:	fb6d                	bnez	a4,ffffffffc0201f66 <strnlen+0x6>
ffffffffc0201f76:	85be                	mv	a1,a5
ffffffffc0201f78:	852e                	mv	a0,a1
ffffffffc0201f7a:	8082                	ret

ffffffffc0201f7c <strcmp>:
ffffffffc0201f7c:	00054783          	lbu	a5,0(a0)
ffffffffc0201f80:	e791                	bnez	a5,ffffffffc0201f8c <strcmp+0x10>
ffffffffc0201f82:	a02d                	j	ffffffffc0201fac <strcmp+0x30>
ffffffffc0201f84:	00054783          	lbu	a5,0(a0)
ffffffffc0201f88:	cf89                	beqz	a5,ffffffffc0201fa2 <strcmp+0x26>
ffffffffc0201f8a:	85b6                	mv	a1,a3
ffffffffc0201f8c:	0005c703          	lbu	a4,0(a1)
ffffffffc0201f90:	0505                	addi	a0,a0,1
ffffffffc0201f92:	00158693          	addi	a3,a1,1
ffffffffc0201f96:	fef707e3          	beq	a4,a5,ffffffffc0201f84 <strcmp+0x8>
ffffffffc0201f9a:	0007851b          	sext.w	a0,a5
ffffffffc0201f9e:	9d19                	subw	a0,a0,a4
ffffffffc0201fa0:	8082                	ret
ffffffffc0201fa2:	0015c703          	lbu	a4,1(a1)
ffffffffc0201fa6:	4501                	li	a0,0
ffffffffc0201fa8:	9d19                	subw	a0,a0,a4
ffffffffc0201faa:	8082                	ret
ffffffffc0201fac:	0005c703          	lbu	a4,0(a1)
ffffffffc0201fb0:	4501                	li	a0,0
ffffffffc0201fb2:	b7f5                	j	ffffffffc0201f9e <strcmp+0x22>

ffffffffc0201fb4 <strncmp>:
ffffffffc0201fb4:	ce01                	beqz	a2,ffffffffc0201fcc <strncmp+0x18>
ffffffffc0201fb6:	00054783          	lbu	a5,0(a0)
ffffffffc0201fba:	167d                	addi	a2,a2,-1
ffffffffc0201fbc:	cb91                	beqz	a5,ffffffffc0201fd0 <strncmp+0x1c>
ffffffffc0201fbe:	0005c703          	lbu	a4,0(a1)
ffffffffc0201fc2:	00f71763          	bne	a4,a5,ffffffffc0201fd0 <strncmp+0x1c>
ffffffffc0201fc6:	0505                	addi	a0,a0,1
ffffffffc0201fc8:	0585                	addi	a1,a1,1
ffffffffc0201fca:	f675                	bnez	a2,ffffffffc0201fb6 <strncmp+0x2>
ffffffffc0201fcc:	4501                	li	a0,0
ffffffffc0201fce:	8082                	ret
ffffffffc0201fd0:	00054503          	lbu	a0,0(a0)
ffffffffc0201fd4:	0005c783          	lbu	a5,0(a1)
ffffffffc0201fd8:	9d1d                	subw	a0,a0,a5
ffffffffc0201fda:	8082                	ret

ffffffffc0201fdc <strchr>:
ffffffffc0201fdc:	00054783          	lbu	a5,0(a0)
ffffffffc0201fe0:	c799                	beqz	a5,ffffffffc0201fee <strchr+0x12>
ffffffffc0201fe2:	00f58763          	beq	a1,a5,ffffffffc0201ff0 <strchr+0x14>
ffffffffc0201fe6:	00154783          	lbu	a5,1(a0)
ffffffffc0201fea:	0505                	addi	a0,a0,1
ffffffffc0201fec:	fbfd                	bnez	a5,ffffffffc0201fe2 <strchr+0x6>
ffffffffc0201fee:	4501                	li	a0,0
ffffffffc0201ff0:	8082                	ret

ffffffffc0201ff2 <memset>:
ffffffffc0201ff2:	ca01                	beqz	a2,ffffffffc0202002 <memset+0x10>
ffffffffc0201ff4:	962a                	add	a2,a2,a0
ffffffffc0201ff6:	87aa                	mv	a5,a0
ffffffffc0201ff8:	0785                	addi	a5,a5,1
ffffffffc0201ffa:	feb78fa3          	sb	a1,-1(a5)
ffffffffc0201ffe:	fef61de3          	bne	a2,a5,ffffffffc0201ff8 <memset+0x6>
ffffffffc0202002:	8082                	ret
