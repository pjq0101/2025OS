
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00014297          	auipc	t0,0x14
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0214000 <boot_hartid>
ffffffffc020000c:	00014297          	auipc	t0,0x14
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0214008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02132b7          	lui	t0,0xc0213
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0213137          	lui	sp,0xc0213
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
ffffffffc020004a:	00091517          	auipc	a0,0x91
ffffffffc020004e:	01650513          	addi	a0,a0,22 # ffffffffc0291060 <buf>
ffffffffc0200052:	00097617          	auipc	a2,0x97
ffffffffc0200056:	8be60613          	addi	a2,a2,-1858 # ffffffffc0296910 <end>
ffffffffc020005a:	1141                	addi	sp,sp,-16
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
ffffffffc0200060:	e406                	sd	ra,8(sp)
ffffffffc0200062:	43e0b0ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0200066:	52c000ef          	jal	ra,ffffffffc0200592 <cons_init>
ffffffffc020006a:	0000b597          	auipc	a1,0xb
ffffffffc020006e:	4a658593          	addi	a1,a1,1190 # ffffffffc020b510 <etext+0x6>
ffffffffc0200072:	0000b517          	auipc	a0,0xb
ffffffffc0200076:	4be50513          	addi	a0,a0,1214 # ffffffffc020b530 <etext+0x26>
ffffffffc020007a:	12c000ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020007e:	1ae000ef          	jal	ra,ffffffffc020022c <print_kerninfo>
ffffffffc0200082:	62a000ef          	jal	ra,ffffffffc02006ac <dtb_init>
ffffffffc0200086:	24b020ef          	jal	ra,ffffffffc0202ad0 <pmm_init>
ffffffffc020008a:	3ef000ef          	jal	ra,ffffffffc0200c78 <pic_init>
ffffffffc020008e:	515000ef          	jal	ra,ffffffffc0200da2 <idt_init>
ffffffffc0200092:	6d7030ef          	jal	ra,ffffffffc0203f68 <vmm_init>
ffffffffc0200096:	190070ef          	jal	ra,ffffffffc0207226 <sched_init>
ffffffffc020009a:	597060ef          	jal	ra,ffffffffc0206e30 <proc_init>
ffffffffc020009e:	1bf000ef          	jal	ra,ffffffffc0200a5c <ide_init>
ffffffffc02000a2:	108050ef          	jal	ra,ffffffffc02051aa <fs_init>
ffffffffc02000a6:	4a4000ef          	jal	ra,ffffffffc020054a <clock_init>
ffffffffc02000aa:	3c3000ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02000ae:	74f060ef          	jal	ra,ffffffffc0206ffc <cpu_idle>

ffffffffc02000b2 <readline>:
ffffffffc02000b2:	715d                	addi	sp,sp,-80
ffffffffc02000b4:	e486                	sd	ra,72(sp)
ffffffffc02000b6:	e0a6                	sd	s1,64(sp)
ffffffffc02000b8:	fc4a                	sd	s2,56(sp)
ffffffffc02000ba:	f84e                	sd	s3,48(sp)
ffffffffc02000bc:	f452                	sd	s4,40(sp)
ffffffffc02000be:	f056                	sd	s5,32(sp)
ffffffffc02000c0:	ec5a                	sd	s6,24(sp)
ffffffffc02000c2:	e85e                	sd	s7,16(sp)
ffffffffc02000c4:	c901                	beqz	a0,ffffffffc02000d4 <readline+0x22>
ffffffffc02000c6:	85aa                	mv	a1,a0
ffffffffc02000c8:	0000b517          	auipc	a0,0xb
ffffffffc02000cc:	47050513          	addi	a0,a0,1136 # ffffffffc020b538 <etext+0x2e>
ffffffffc02000d0:	0d6000ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02000d4:	4481                	li	s1,0
ffffffffc02000d6:	497d                	li	s2,31
ffffffffc02000d8:	49a1                	li	s3,8
ffffffffc02000da:	4aa9                	li	s5,10
ffffffffc02000dc:	4b35                	li	s6,13
ffffffffc02000de:	00091b97          	auipc	s7,0x91
ffffffffc02000e2:	f82b8b93          	addi	s7,s7,-126 # ffffffffc0291060 <buf>
ffffffffc02000e6:	3fe00a13          	li	s4,1022
ffffffffc02000ea:	0fa000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc02000ee:	00054a63          	bltz	a0,ffffffffc0200102 <readline+0x50>
ffffffffc02000f2:	00a95a63          	bge	s2,a0,ffffffffc0200106 <readline+0x54>
ffffffffc02000f6:	029a5263          	bge	s4,s1,ffffffffc020011a <readline+0x68>
ffffffffc02000fa:	0ea000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc02000fe:	fe055ae3          	bgez	a0,ffffffffc02000f2 <readline+0x40>
ffffffffc0200102:	4501                	li	a0,0
ffffffffc0200104:	a091                	j	ffffffffc0200148 <readline+0x96>
ffffffffc0200106:	03351463          	bne	a0,s3,ffffffffc020012e <readline+0x7c>
ffffffffc020010a:	e8a9                	bnez	s1,ffffffffc020015c <readline+0xaa>
ffffffffc020010c:	0d8000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc0200110:	fe0549e3          	bltz	a0,ffffffffc0200102 <readline+0x50>
ffffffffc0200114:	fea959e3          	bge	s2,a0,ffffffffc0200106 <readline+0x54>
ffffffffc0200118:	4481                	li	s1,0
ffffffffc020011a:	e42a                	sd	a0,8(sp)
ffffffffc020011c:	0c6000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0200120:	6522                	ld	a0,8(sp)
ffffffffc0200122:	009b87b3          	add	a5,s7,s1
ffffffffc0200126:	2485                	addiw	s1,s1,1
ffffffffc0200128:	00a78023          	sb	a0,0(a5)
ffffffffc020012c:	bf7d                	j	ffffffffc02000ea <readline+0x38>
ffffffffc020012e:	01550463          	beq	a0,s5,ffffffffc0200136 <readline+0x84>
ffffffffc0200132:	fb651ce3          	bne	a0,s6,ffffffffc02000ea <readline+0x38>
ffffffffc0200136:	0ac000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc020013a:	00091517          	auipc	a0,0x91
ffffffffc020013e:	f2650513          	addi	a0,a0,-218 # ffffffffc0291060 <buf>
ffffffffc0200142:	94aa                	add	s1,s1,a0
ffffffffc0200144:	00048023          	sb	zero,0(s1)
ffffffffc0200148:	60a6                	ld	ra,72(sp)
ffffffffc020014a:	6486                	ld	s1,64(sp)
ffffffffc020014c:	7962                	ld	s2,56(sp)
ffffffffc020014e:	79c2                	ld	s3,48(sp)
ffffffffc0200150:	7a22                	ld	s4,40(sp)
ffffffffc0200152:	7a82                	ld	s5,32(sp)
ffffffffc0200154:	6b62                	ld	s6,24(sp)
ffffffffc0200156:	6bc2                	ld	s7,16(sp)
ffffffffc0200158:	6161                	addi	sp,sp,80
ffffffffc020015a:	8082                	ret
ffffffffc020015c:	4521                	li	a0,8
ffffffffc020015e:	084000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0200162:	34fd                	addiw	s1,s1,-1
ffffffffc0200164:	b759                	j	ffffffffc02000ea <readline+0x38>

ffffffffc0200166 <cputch>:
ffffffffc0200166:	1141                	addi	sp,sp,-16
ffffffffc0200168:	e022                	sd	s0,0(sp)
ffffffffc020016a:	e406                	sd	ra,8(sp)
ffffffffc020016c:	842e                	mv	s0,a1
ffffffffc020016e:	432000ef          	jal	ra,ffffffffc02005a0 <cons_putc>
ffffffffc0200172:	401c                	lw	a5,0(s0)
ffffffffc0200174:	60a2                	ld	ra,8(sp)
ffffffffc0200176:	2785                	addiw	a5,a5,1
ffffffffc0200178:	c01c                	sw	a5,0(s0)
ffffffffc020017a:	6402                	ld	s0,0(sp)
ffffffffc020017c:	0141                	addi	sp,sp,16
ffffffffc020017e:	8082                	ret

ffffffffc0200180 <vcprintf>:
ffffffffc0200180:	1101                	addi	sp,sp,-32
ffffffffc0200182:	872e                	mv	a4,a1
ffffffffc0200184:	75dd                	lui	a1,0xffff7
ffffffffc0200186:	86aa                	mv	a3,a0
ffffffffc0200188:	0070                	addi	a2,sp,12
ffffffffc020018a:	00000517          	auipc	a0,0x0
ffffffffc020018e:	fdc50513          	addi	a0,a0,-36 # ffffffffc0200166 <cputch>
ffffffffc0200192:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0200196:	ec06                	sd	ra,24(sp)
ffffffffc0200198:	c602                	sw	zero,12(sp)
ffffffffc020019a:	6790a0ef          	jal	ra,ffffffffc020b012 <vprintfmt>
ffffffffc020019e:	60e2                	ld	ra,24(sp)
ffffffffc02001a0:	4532                	lw	a0,12(sp)
ffffffffc02001a2:	6105                	addi	sp,sp,32
ffffffffc02001a4:	8082                	ret

ffffffffc02001a6 <cprintf>:
ffffffffc02001a6:	711d                	addi	sp,sp,-96
ffffffffc02001a8:	02810313          	addi	t1,sp,40 # ffffffffc0213028 <boot_page_table_sv39+0x28>
ffffffffc02001ac:	8e2a                	mv	t3,a0
ffffffffc02001ae:	f42e                	sd	a1,40(sp)
ffffffffc02001b0:	75dd                	lui	a1,0xffff7
ffffffffc02001b2:	f832                	sd	a2,48(sp)
ffffffffc02001b4:	fc36                	sd	a3,56(sp)
ffffffffc02001b6:	e0ba                	sd	a4,64(sp)
ffffffffc02001b8:	00000517          	auipc	a0,0x0
ffffffffc02001bc:	fae50513          	addi	a0,a0,-82 # ffffffffc0200166 <cputch>
ffffffffc02001c0:	0050                	addi	a2,sp,4
ffffffffc02001c2:	871a                	mv	a4,t1
ffffffffc02001c4:	86f2                	mv	a3,t3
ffffffffc02001c6:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc02001ca:	ec06                	sd	ra,24(sp)
ffffffffc02001cc:	e4be                	sd	a5,72(sp)
ffffffffc02001ce:	e8c2                	sd	a6,80(sp)
ffffffffc02001d0:	ecc6                	sd	a7,88(sp)
ffffffffc02001d2:	e41a                	sd	t1,8(sp)
ffffffffc02001d4:	c202                	sw	zero,4(sp)
ffffffffc02001d6:	63d0a0ef          	jal	ra,ffffffffc020b012 <vprintfmt>
ffffffffc02001da:	60e2                	ld	ra,24(sp)
ffffffffc02001dc:	4512                	lw	a0,4(sp)
ffffffffc02001de:	6125                	addi	sp,sp,96
ffffffffc02001e0:	8082                	ret

ffffffffc02001e2 <cputchar>:
ffffffffc02001e2:	ae7d                	j	ffffffffc02005a0 <cons_putc>

ffffffffc02001e4 <getchar>:
ffffffffc02001e4:	1141                	addi	sp,sp,-16
ffffffffc02001e6:	e406                	sd	ra,8(sp)
ffffffffc02001e8:	40c000ef          	jal	ra,ffffffffc02005f4 <cons_getc>
ffffffffc02001ec:	dd75                	beqz	a0,ffffffffc02001e8 <getchar+0x4>
ffffffffc02001ee:	60a2                	ld	ra,8(sp)
ffffffffc02001f0:	0141                	addi	sp,sp,16
ffffffffc02001f2:	8082                	ret

ffffffffc02001f4 <strdup>:
ffffffffc02001f4:	1101                	addi	sp,sp,-32
ffffffffc02001f6:	ec06                	sd	ra,24(sp)
ffffffffc02001f8:	e822                	sd	s0,16(sp)
ffffffffc02001fa:	e426                	sd	s1,8(sp)
ffffffffc02001fc:	e04a                	sd	s2,0(sp)
ffffffffc02001fe:	892a                	mv	s2,a0
ffffffffc0200200:	1fe0b0ef          	jal	ra,ffffffffc020b3fe <strlen>
ffffffffc0200204:	842a                	mv	s0,a0
ffffffffc0200206:	0505                	addi	a0,a0,1
ffffffffc0200208:	587010ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020020c:	84aa                	mv	s1,a0
ffffffffc020020e:	c901                	beqz	a0,ffffffffc020021e <strdup+0x2a>
ffffffffc0200210:	8622                	mv	a2,s0
ffffffffc0200212:	85ca                	mv	a1,s2
ffffffffc0200214:	9426                	add	s0,s0,s1
ffffffffc0200216:	2dc0b0ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc020021a:	00040023          	sb	zero,0(s0)
ffffffffc020021e:	60e2                	ld	ra,24(sp)
ffffffffc0200220:	6442                	ld	s0,16(sp)
ffffffffc0200222:	6902                	ld	s2,0(sp)
ffffffffc0200224:	8526                	mv	a0,s1
ffffffffc0200226:	64a2                	ld	s1,8(sp)
ffffffffc0200228:	6105                	addi	sp,sp,32
ffffffffc020022a:	8082                	ret

ffffffffc020022c <print_kerninfo>:
ffffffffc020022c:	1141                	addi	sp,sp,-16
ffffffffc020022e:	0000b517          	auipc	a0,0xb
ffffffffc0200232:	31250513          	addi	a0,a0,786 # ffffffffc020b540 <etext+0x36>
ffffffffc0200236:	e406                	sd	ra,8(sp)
ffffffffc0200238:	f6fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020023c:	00000597          	auipc	a1,0x0
ffffffffc0200240:	e0e58593          	addi	a1,a1,-498 # ffffffffc020004a <kern_init>
ffffffffc0200244:	0000b517          	auipc	a0,0xb
ffffffffc0200248:	31c50513          	addi	a0,a0,796 # ffffffffc020b560 <etext+0x56>
ffffffffc020024c:	f5bff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200250:	0000b597          	auipc	a1,0xb
ffffffffc0200254:	2ba58593          	addi	a1,a1,698 # ffffffffc020b50a <etext>
ffffffffc0200258:	0000b517          	auipc	a0,0xb
ffffffffc020025c:	32850513          	addi	a0,a0,808 # ffffffffc020b580 <etext+0x76>
ffffffffc0200260:	f47ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200264:	00091597          	auipc	a1,0x91
ffffffffc0200268:	dfc58593          	addi	a1,a1,-516 # ffffffffc0291060 <buf>
ffffffffc020026c:	0000b517          	auipc	a0,0xb
ffffffffc0200270:	33450513          	addi	a0,a0,820 # ffffffffc020b5a0 <etext+0x96>
ffffffffc0200274:	f33ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200278:	00096597          	auipc	a1,0x96
ffffffffc020027c:	69858593          	addi	a1,a1,1688 # ffffffffc0296910 <end>
ffffffffc0200280:	0000b517          	auipc	a0,0xb
ffffffffc0200284:	34050513          	addi	a0,a0,832 # ffffffffc020b5c0 <etext+0xb6>
ffffffffc0200288:	f1fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020028c:	00097597          	auipc	a1,0x97
ffffffffc0200290:	a8358593          	addi	a1,a1,-1405 # ffffffffc0296d0f <end+0x3ff>
ffffffffc0200294:	00000797          	auipc	a5,0x0
ffffffffc0200298:	db678793          	addi	a5,a5,-586 # ffffffffc020004a <kern_init>
ffffffffc020029c:	40f587b3          	sub	a5,a1,a5
ffffffffc02002a0:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02002a4:	60a2                	ld	ra,8(sp)
ffffffffc02002a6:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002aa:	95be                	add	a1,a1,a5
ffffffffc02002ac:	85a9                	srai	a1,a1,0xa
ffffffffc02002ae:	0000b517          	auipc	a0,0xb
ffffffffc02002b2:	33250513          	addi	a0,a0,818 # ffffffffc020b5e0 <etext+0xd6>
ffffffffc02002b6:	0141                	addi	sp,sp,16
ffffffffc02002b8:	b5fd                	j	ffffffffc02001a6 <cprintf>

ffffffffc02002ba <print_stackframe>:
ffffffffc02002ba:	1141                	addi	sp,sp,-16
ffffffffc02002bc:	0000b617          	auipc	a2,0xb
ffffffffc02002c0:	35460613          	addi	a2,a2,852 # ffffffffc020b610 <etext+0x106>
ffffffffc02002c4:	04e00593          	li	a1,78
ffffffffc02002c8:	0000b517          	auipc	a0,0xb
ffffffffc02002cc:	36050513          	addi	a0,a0,864 # ffffffffc020b628 <etext+0x11e>
ffffffffc02002d0:	e406                	sd	ra,8(sp)
ffffffffc02002d2:	1cc000ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02002d6 <mon_help>:
ffffffffc02002d6:	1141                	addi	sp,sp,-16
ffffffffc02002d8:	0000b617          	auipc	a2,0xb
ffffffffc02002dc:	36860613          	addi	a2,a2,872 # ffffffffc020b640 <etext+0x136>
ffffffffc02002e0:	0000b597          	auipc	a1,0xb
ffffffffc02002e4:	38058593          	addi	a1,a1,896 # ffffffffc020b660 <etext+0x156>
ffffffffc02002e8:	0000b517          	auipc	a0,0xb
ffffffffc02002ec:	38050513          	addi	a0,a0,896 # ffffffffc020b668 <etext+0x15e>
ffffffffc02002f0:	e406                	sd	ra,8(sp)
ffffffffc02002f2:	eb5ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02002f6:	0000b617          	auipc	a2,0xb
ffffffffc02002fa:	38260613          	addi	a2,a2,898 # ffffffffc020b678 <etext+0x16e>
ffffffffc02002fe:	0000b597          	auipc	a1,0xb
ffffffffc0200302:	3a258593          	addi	a1,a1,930 # ffffffffc020b6a0 <etext+0x196>
ffffffffc0200306:	0000b517          	auipc	a0,0xb
ffffffffc020030a:	36250513          	addi	a0,a0,866 # ffffffffc020b668 <etext+0x15e>
ffffffffc020030e:	e99ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200312:	0000b617          	auipc	a2,0xb
ffffffffc0200316:	39e60613          	addi	a2,a2,926 # ffffffffc020b6b0 <etext+0x1a6>
ffffffffc020031a:	0000b597          	auipc	a1,0xb
ffffffffc020031e:	3b658593          	addi	a1,a1,950 # ffffffffc020b6d0 <etext+0x1c6>
ffffffffc0200322:	0000b517          	auipc	a0,0xb
ffffffffc0200326:	34650513          	addi	a0,a0,838 # ffffffffc020b668 <etext+0x15e>
ffffffffc020032a:	e7dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020032e:	60a2                	ld	ra,8(sp)
ffffffffc0200330:	4501                	li	a0,0
ffffffffc0200332:	0141                	addi	sp,sp,16
ffffffffc0200334:	8082                	ret

ffffffffc0200336 <mon_kerninfo>:
ffffffffc0200336:	1141                	addi	sp,sp,-16
ffffffffc0200338:	e406                	sd	ra,8(sp)
ffffffffc020033a:	ef3ff0ef          	jal	ra,ffffffffc020022c <print_kerninfo>
ffffffffc020033e:	60a2                	ld	ra,8(sp)
ffffffffc0200340:	4501                	li	a0,0
ffffffffc0200342:	0141                	addi	sp,sp,16
ffffffffc0200344:	8082                	ret

ffffffffc0200346 <mon_backtrace>:
ffffffffc0200346:	1141                	addi	sp,sp,-16
ffffffffc0200348:	e406                	sd	ra,8(sp)
ffffffffc020034a:	f71ff0ef          	jal	ra,ffffffffc02002ba <print_stackframe>
ffffffffc020034e:	60a2                	ld	ra,8(sp)
ffffffffc0200350:	4501                	li	a0,0
ffffffffc0200352:	0141                	addi	sp,sp,16
ffffffffc0200354:	8082                	ret

ffffffffc0200356 <kmonitor>:
ffffffffc0200356:	7115                	addi	sp,sp,-224
ffffffffc0200358:	ed5e                	sd	s7,152(sp)
ffffffffc020035a:	8baa                	mv	s7,a0
ffffffffc020035c:	0000b517          	auipc	a0,0xb
ffffffffc0200360:	38450513          	addi	a0,a0,900 # ffffffffc020b6e0 <etext+0x1d6>
ffffffffc0200364:	ed86                	sd	ra,216(sp)
ffffffffc0200366:	e9a2                	sd	s0,208(sp)
ffffffffc0200368:	e5a6                	sd	s1,200(sp)
ffffffffc020036a:	e1ca                	sd	s2,192(sp)
ffffffffc020036c:	fd4e                	sd	s3,184(sp)
ffffffffc020036e:	f952                	sd	s4,176(sp)
ffffffffc0200370:	f556                	sd	s5,168(sp)
ffffffffc0200372:	f15a                	sd	s6,160(sp)
ffffffffc0200374:	e962                	sd	s8,144(sp)
ffffffffc0200376:	e566                	sd	s9,136(sp)
ffffffffc0200378:	e16a                	sd	s10,128(sp)
ffffffffc020037a:	e2dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020037e:	0000b517          	auipc	a0,0xb
ffffffffc0200382:	38a50513          	addi	a0,a0,906 # ffffffffc020b708 <etext+0x1fe>
ffffffffc0200386:	e21ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020038a:	000b8563          	beqz	s7,ffffffffc0200394 <kmonitor+0x3e>
ffffffffc020038e:	855e                	mv	a0,s7
ffffffffc0200390:	3fb000ef          	jal	ra,ffffffffc0200f8a <print_trapframe>
ffffffffc0200394:	0000bc17          	auipc	s8,0xb
ffffffffc0200398:	3e4c0c13          	addi	s8,s8,996 # ffffffffc020b778 <commands>
ffffffffc020039c:	0000b917          	auipc	s2,0xb
ffffffffc02003a0:	39490913          	addi	s2,s2,916 # ffffffffc020b730 <etext+0x226>
ffffffffc02003a4:	0000b497          	auipc	s1,0xb
ffffffffc02003a8:	39448493          	addi	s1,s1,916 # ffffffffc020b738 <etext+0x22e>
ffffffffc02003ac:	49bd                	li	s3,15
ffffffffc02003ae:	0000bb17          	auipc	s6,0xb
ffffffffc02003b2:	392b0b13          	addi	s6,s6,914 # ffffffffc020b740 <etext+0x236>
ffffffffc02003b6:	0000ba17          	auipc	s4,0xb
ffffffffc02003ba:	2aaa0a13          	addi	s4,s4,682 # ffffffffc020b660 <etext+0x156>
ffffffffc02003be:	4a8d                	li	s5,3
ffffffffc02003c0:	854a                	mv	a0,s2
ffffffffc02003c2:	cf1ff0ef          	jal	ra,ffffffffc02000b2 <readline>
ffffffffc02003c6:	842a                	mv	s0,a0
ffffffffc02003c8:	dd65                	beqz	a0,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc02003ca:	00054583          	lbu	a1,0(a0)
ffffffffc02003ce:	4c81                	li	s9,0
ffffffffc02003d0:	e1bd                	bnez	a1,ffffffffc0200436 <kmonitor+0xe0>
ffffffffc02003d2:	fe0c87e3          	beqz	s9,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc02003d6:	6582                	ld	a1,0(sp)
ffffffffc02003d8:	0000bd17          	auipc	s10,0xb
ffffffffc02003dc:	3a0d0d13          	addi	s10,s10,928 # ffffffffc020b778 <commands>
ffffffffc02003e0:	8552                	mv	a0,s4
ffffffffc02003e2:	4401                	li	s0,0
ffffffffc02003e4:	0d61                	addi	s10,s10,24
ffffffffc02003e6:	0600b0ef          	jal	ra,ffffffffc020b446 <strcmp>
ffffffffc02003ea:	c919                	beqz	a0,ffffffffc0200400 <kmonitor+0xaa>
ffffffffc02003ec:	2405                	addiw	s0,s0,1
ffffffffc02003ee:	0b540063          	beq	s0,s5,ffffffffc020048e <kmonitor+0x138>
ffffffffc02003f2:	000d3503          	ld	a0,0(s10)
ffffffffc02003f6:	6582                	ld	a1,0(sp)
ffffffffc02003f8:	0d61                	addi	s10,s10,24
ffffffffc02003fa:	04c0b0ef          	jal	ra,ffffffffc020b446 <strcmp>
ffffffffc02003fe:	f57d                	bnez	a0,ffffffffc02003ec <kmonitor+0x96>
ffffffffc0200400:	00141793          	slli	a5,s0,0x1
ffffffffc0200404:	97a2                	add	a5,a5,s0
ffffffffc0200406:	078e                	slli	a5,a5,0x3
ffffffffc0200408:	97e2                	add	a5,a5,s8
ffffffffc020040a:	6b9c                	ld	a5,16(a5)
ffffffffc020040c:	865e                	mv	a2,s7
ffffffffc020040e:	002c                	addi	a1,sp,8
ffffffffc0200410:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200414:	9782                	jalr	a5
ffffffffc0200416:	fa0555e3          	bgez	a0,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc020041a:	60ee                	ld	ra,216(sp)
ffffffffc020041c:	644e                	ld	s0,208(sp)
ffffffffc020041e:	64ae                	ld	s1,200(sp)
ffffffffc0200420:	690e                	ld	s2,192(sp)
ffffffffc0200422:	79ea                	ld	s3,184(sp)
ffffffffc0200424:	7a4a                	ld	s4,176(sp)
ffffffffc0200426:	7aaa                	ld	s5,168(sp)
ffffffffc0200428:	7b0a                	ld	s6,160(sp)
ffffffffc020042a:	6bea                	ld	s7,152(sp)
ffffffffc020042c:	6c4a                	ld	s8,144(sp)
ffffffffc020042e:	6caa                	ld	s9,136(sp)
ffffffffc0200430:	6d0a                	ld	s10,128(sp)
ffffffffc0200432:	612d                	addi	sp,sp,224
ffffffffc0200434:	8082                	ret
ffffffffc0200436:	8526                	mv	a0,s1
ffffffffc0200438:	0520b0ef          	jal	ra,ffffffffc020b48a <strchr>
ffffffffc020043c:	c901                	beqz	a0,ffffffffc020044c <kmonitor+0xf6>
ffffffffc020043e:	00144583          	lbu	a1,1(s0)
ffffffffc0200442:	00040023          	sb	zero,0(s0)
ffffffffc0200446:	0405                	addi	s0,s0,1
ffffffffc0200448:	d5c9                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc020044a:	b7f5                	j	ffffffffc0200436 <kmonitor+0xe0>
ffffffffc020044c:	00044783          	lbu	a5,0(s0)
ffffffffc0200450:	d3c9                	beqz	a5,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200452:	033c8963          	beq	s9,s3,ffffffffc0200484 <kmonitor+0x12e>
ffffffffc0200456:	003c9793          	slli	a5,s9,0x3
ffffffffc020045a:	0118                	addi	a4,sp,128
ffffffffc020045c:	97ba                	add	a5,a5,a4
ffffffffc020045e:	f887b023          	sd	s0,-128(a5)
ffffffffc0200462:	00044583          	lbu	a1,0(s0)
ffffffffc0200466:	2c85                	addiw	s9,s9,1
ffffffffc0200468:	e591                	bnez	a1,ffffffffc0200474 <kmonitor+0x11e>
ffffffffc020046a:	b7b5                	j	ffffffffc02003d6 <kmonitor+0x80>
ffffffffc020046c:	00144583          	lbu	a1,1(s0)
ffffffffc0200470:	0405                	addi	s0,s0,1
ffffffffc0200472:	d1a5                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200474:	8526                	mv	a0,s1
ffffffffc0200476:	0140b0ef          	jal	ra,ffffffffc020b48a <strchr>
ffffffffc020047a:	d96d                	beqz	a0,ffffffffc020046c <kmonitor+0x116>
ffffffffc020047c:	00044583          	lbu	a1,0(s0)
ffffffffc0200480:	d9a9                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200482:	bf55                	j	ffffffffc0200436 <kmonitor+0xe0>
ffffffffc0200484:	45c1                	li	a1,16
ffffffffc0200486:	855a                	mv	a0,s6
ffffffffc0200488:	d1fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020048c:	b7e9                	j	ffffffffc0200456 <kmonitor+0x100>
ffffffffc020048e:	6582                	ld	a1,0(sp)
ffffffffc0200490:	0000b517          	auipc	a0,0xb
ffffffffc0200494:	2d050513          	addi	a0,a0,720 # ffffffffc020b760 <etext+0x256>
ffffffffc0200498:	d0fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020049c:	b715                	j	ffffffffc02003c0 <kmonitor+0x6a>

ffffffffc020049e <__panic>:
ffffffffc020049e:	00096317          	auipc	t1,0x96
ffffffffc02004a2:	3ca30313          	addi	t1,t1,970 # ffffffffc0296868 <is_panic>
ffffffffc02004a6:	00033e03          	ld	t3,0(t1)
ffffffffc02004aa:	715d                	addi	sp,sp,-80
ffffffffc02004ac:	ec06                	sd	ra,24(sp)
ffffffffc02004ae:	e822                	sd	s0,16(sp)
ffffffffc02004b0:	f436                	sd	a3,40(sp)
ffffffffc02004b2:	f83a                	sd	a4,48(sp)
ffffffffc02004b4:	fc3e                	sd	a5,56(sp)
ffffffffc02004b6:	e0c2                	sd	a6,64(sp)
ffffffffc02004b8:	e4c6                	sd	a7,72(sp)
ffffffffc02004ba:	020e1a63          	bnez	t3,ffffffffc02004ee <__panic+0x50>
ffffffffc02004be:	4785                	li	a5,1
ffffffffc02004c0:	00f33023          	sd	a5,0(t1)
ffffffffc02004c4:	8432                	mv	s0,a2
ffffffffc02004c6:	103c                	addi	a5,sp,40
ffffffffc02004c8:	862e                	mv	a2,a1
ffffffffc02004ca:	85aa                	mv	a1,a0
ffffffffc02004cc:	0000b517          	auipc	a0,0xb
ffffffffc02004d0:	2f450513          	addi	a0,a0,756 # ffffffffc020b7c0 <commands+0x48>
ffffffffc02004d4:	e43e                	sd	a5,8(sp)
ffffffffc02004d6:	cd1ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02004da:	65a2                	ld	a1,8(sp)
ffffffffc02004dc:	8522                	mv	a0,s0
ffffffffc02004de:	ca3ff0ef          	jal	ra,ffffffffc0200180 <vcprintf>
ffffffffc02004e2:	0000c517          	auipc	a0,0xc
ffffffffc02004e6:	59e50513          	addi	a0,a0,1438 # ffffffffc020ca80 <default_pmm_manager+0x610>
ffffffffc02004ea:	cbdff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02004ee:	4501                	li	a0,0
ffffffffc02004f0:	4581                	li	a1,0
ffffffffc02004f2:	4601                	li	a2,0
ffffffffc02004f4:	48a1                	li	a7,8
ffffffffc02004f6:	00000073          	ecall
ffffffffc02004fa:	778000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02004fe:	4501                	li	a0,0
ffffffffc0200500:	e57ff0ef          	jal	ra,ffffffffc0200356 <kmonitor>
ffffffffc0200504:	bfed                	j	ffffffffc02004fe <__panic+0x60>

ffffffffc0200506 <__warn>:
ffffffffc0200506:	715d                	addi	sp,sp,-80
ffffffffc0200508:	832e                	mv	t1,a1
ffffffffc020050a:	e822                	sd	s0,16(sp)
ffffffffc020050c:	85aa                	mv	a1,a0
ffffffffc020050e:	8432                	mv	s0,a2
ffffffffc0200510:	fc3e                	sd	a5,56(sp)
ffffffffc0200512:	861a                	mv	a2,t1
ffffffffc0200514:	103c                	addi	a5,sp,40
ffffffffc0200516:	0000b517          	auipc	a0,0xb
ffffffffc020051a:	2ca50513          	addi	a0,a0,714 # ffffffffc020b7e0 <commands+0x68>
ffffffffc020051e:	ec06                	sd	ra,24(sp)
ffffffffc0200520:	f436                	sd	a3,40(sp)
ffffffffc0200522:	f83a                	sd	a4,48(sp)
ffffffffc0200524:	e0c2                	sd	a6,64(sp)
ffffffffc0200526:	e4c6                	sd	a7,72(sp)
ffffffffc0200528:	e43e                	sd	a5,8(sp)
ffffffffc020052a:	c7dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020052e:	65a2                	ld	a1,8(sp)
ffffffffc0200530:	8522                	mv	a0,s0
ffffffffc0200532:	c4fff0ef          	jal	ra,ffffffffc0200180 <vcprintf>
ffffffffc0200536:	0000c517          	auipc	a0,0xc
ffffffffc020053a:	54a50513          	addi	a0,a0,1354 # ffffffffc020ca80 <default_pmm_manager+0x610>
ffffffffc020053e:	c69ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200542:	60e2                	ld	ra,24(sp)
ffffffffc0200544:	6442                	ld	s0,16(sp)
ffffffffc0200546:	6161                	addi	sp,sp,80
ffffffffc0200548:	8082                	ret

ffffffffc020054a <clock_init>:
ffffffffc020054a:	02000793          	li	a5,32
ffffffffc020054e:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200552:	c0102573          	rdtime	a0
ffffffffc0200556:	67e1                	lui	a5,0x18
ffffffffc0200558:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc020055c:	953e                	add	a0,a0,a5
ffffffffc020055e:	4581                	li	a1,0
ffffffffc0200560:	4601                	li	a2,0
ffffffffc0200562:	4881                	li	a7,0
ffffffffc0200564:	00000073          	ecall
ffffffffc0200568:	0000b517          	auipc	a0,0xb
ffffffffc020056c:	29850513          	addi	a0,a0,664 # ffffffffc020b800 <commands+0x88>
ffffffffc0200570:	00096797          	auipc	a5,0x96
ffffffffc0200574:	3007b023          	sd	zero,768(a5) # ffffffffc0296870 <ticks>
ffffffffc0200578:	b13d                	j	ffffffffc02001a6 <cprintf>

ffffffffc020057a <clock_set_next_event>:
ffffffffc020057a:	c0102573          	rdtime	a0
ffffffffc020057e:	67e1                	lui	a5,0x18
ffffffffc0200580:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc0200584:	953e                	add	a0,a0,a5
ffffffffc0200586:	4581                	li	a1,0
ffffffffc0200588:	4601                	li	a2,0
ffffffffc020058a:	4881                	li	a7,0
ffffffffc020058c:	00000073          	ecall
ffffffffc0200590:	8082                	ret

ffffffffc0200592 <cons_init>:
ffffffffc0200592:	4501                	li	a0,0
ffffffffc0200594:	4581                	li	a1,0
ffffffffc0200596:	4601                	li	a2,0
ffffffffc0200598:	4889                	li	a7,2
ffffffffc020059a:	00000073          	ecall
ffffffffc020059e:	8082                	ret

ffffffffc02005a0 <cons_putc>:
ffffffffc02005a0:	1101                	addi	sp,sp,-32
ffffffffc02005a2:	ec06                	sd	ra,24(sp)
ffffffffc02005a4:	100027f3          	csrr	a5,sstatus
ffffffffc02005a8:	8b89                	andi	a5,a5,2
ffffffffc02005aa:	4701                	li	a4,0
ffffffffc02005ac:	ef95                	bnez	a5,ffffffffc02005e8 <cons_putc+0x48>
ffffffffc02005ae:	47a1                	li	a5,8
ffffffffc02005b0:	00f50b63          	beq	a0,a5,ffffffffc02005c6 <cons_putc+0x26>
ffffffffc02005b4:	4581                	li	a1,0
ffffffffc02005b6:	4601                	li	a2,0
ffffffffc02005b8:	4885                	li	a7,1
ffffffffc02005ba:	00000073          	ecall
ffffffffc02005be:	e315                	bnez	a4,ffffffffc02005e2 <cons_putc+0x42>
ffffffffc02005c0:	60e2                	ld	ra,24(sp)
ffffffffc02005c2:	6105                	addi	sp,sp,32
ffffffffc02005c4:	8082                	ret
ffffffffc02005c6:	4521                	li	a0,8
ffffffffc02005c8:	4581                	li	a1,0
ffffffffc02005ca:	4601                	li	a2,0
ffffffffc02005cc:	4885                	li	a7,1
ffffffffc02005ce:	00000073          	ecall
ffffffffc02005d2:	02000513          	li	a0,32
ffffffffc02005d6:	00000073          	ecall
ffffffffc02005da:	4521                	li	a0,8
ffffffffc02005dc:	00000073          	ecall
ffffffffc02005e0:	d365                	beqz	a4,ffffffffc02005c0 <cons_putc+0x20>
ffffffffc02005e2:	60e2                	ld	ra,24(sp)
ffffffffc02005e4:	6105                	addi	sp,sp,32
ffffffffc02005e6:	a559                	j	ffffffffc0200c6c <intr_enable>
ffffffffc02005e8:	e42a                	sd	a0,8(sp)
ffffffffc02005ea:	688000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02005ee:	6522                	ld	a0,8(sp)
ffffffffc02005f0:	4705                	li	a4,1
ffffffffc02005f2:	bf75                	j	ffffffffc02005ae <cons_putc+0xe>

ffffffffc02005f4 <cons_getc>:
ffffffffc02005f4:	1101                	addi	sp,sp,-32
ffffffffc02005f6:	ec06                	sd	ra,24(sp)
ffffffffc02005f8:	100027f3          	csrr	a5,sstatus
ffffffffc02005fc:	8b89                	andi	a5,a5,2
ffffffffc02005fe:	4801                	li	a6,0
ffffffffc0200600:	e3d5                	bnez	a5,ffffffffc02006a4 <cons_getc+0xb0>
ffffffffc0200602:	00091697          	auipc	a3,0x91
ffffffffc0200606:	e5e68693          	addi	a3,a3,-418 # ffffffffc0291460 <cons>
ffffffffc020060a:	07f00713          	li	a4,127
ffffffffc020060e:	20000313          	li	t1,512
ffffffffc0200612:	a021                	j	ffffffffc020061a <cons_getc+0x26>
ffffffffc0200614:	0ff57513          	zext.b	a0,a0
ffffffffc0200618:	ef91                	bnez	a5,ffffffffc0200634 <cons_getc+0x40>
ffffffffc020061a:	4501                	li	a0,0
ffffffffc020061c:	4581                	li	a1,0
ffffffffc020061e:	4601                	li	a2,0
ffffffffc0200620:	4889                	li	a7,2
ffffffffc0200622:	00000073          	ecall
ffffffffc0200626:	0005079b          	sext.w	a5,a0
ffffffffc020062a:	0207c763          	bltz	a5,ffffffffc0200658 <cons_getc+0x64>
ffffffffc020062e:	fee793e3          	bne	a5,a4,ffffffffc0200614 <cons_getc+0x20>
ffffffffc0200632:	4521                	li	a0,8
ffffffffc0200634:	2046a783          	lw	a5,516(a3)
ffffffffc0200638:	02079613          	slli	a2,a5,0x20
ffffffffc020063c:	9201                	srli	a2,a2,0x20
ffffffffc020063e:	2785                	addiw	a5,a5,1
ffffffffc0200640:	9636                	add	a2,a2,a3
ffffffffc0200642:	20f6a223          	sw	a5,516(a3)
ffffffffc0200646:	00a60023          	sb	a0,0(a2)
ffffffffc020064a:	fc6798e3          	bne	a5,t1,ffffffffc020061a <cons_getc+0x26>
ffffffffc020064e:	00091797          	auipc	a5,0x91
ffffffffc0200652:	0007ab23          	sw	zero,22(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc0200656:	b7d1                	j	ffffffffc020061a <cons_getc+0x26>
ffffffffc0200658:	2006a783          	lw	a5,512(a3)
ffffffffc020065c:	2046a703          	lw	a4,516(a3)
ffffffffc0200660:	4501                	li	a0,0
ffffffffc0200662:	00f70f63          	beq	a4,a5,ffffffffc0200680 <cons_getc+0x8c>
ffffffffc0200666:	0017861b          	addiw	a2,a5,1
ffffffffc020066a:	1782                	slli	a5,a5,0x20
ffffffffc020066c:	9381                	srli	a5,a5,0x20
ffffffffc020066e:	97b6                	add	a5,a5,a3
ffffffffc0200670:	20c6a023          	sw	a2,512(a3)
ffffffffc0200674:	20000713          	li	a4,512
ffffffffc0200678:	0007c503          	lbu	a0,0(a5)
ffffffffc020067c:	00e60763          	beq	a2,a4,ffffffffc020068a <cons_getc+0x96>
ffffffffc0200680:	00081b63          	bnez	a6,ffffffffc0200696 <cons_getc+0xa2>
ffffffffc0200684:	60e2                	ld	ra,24(sp)
ffffffffc0200686:	6105                	addi	sp,sp,32
ffffffffc0200688:	8082                	ret
ffffffffc020068a:	00091797          	auipc	a5,0x91
ffffffffc020068e:	fc07ab23          	sw	zero,-42(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc0200692:	fe0809e3          	beqz	a6,ffffffffc0200684 <cons_getc+0x90>
ffffffffc0200696:	e42a                	sd	a0,8(sp)
ffffffffc0200698:	5d4000ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020069c:	60e2                	ld	ra,24(sp)
ffffffffc020069e:	6522                	ld	a0,8(sp)
ffffffffc02006a0:	6105                	addi	sp,sp,32
ffffffffc02006a2:	8082                	ret
ffffffffc02006a4:	5ce000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02006a8:	4805                	li	a6,1
ffffffffc02006aa:	bfa1                	j	ffffffffc0200602 <cons_getc+0xe>

ffffffffc02006ac <dtb_init>:
ffffffffc02006ac:	7119                	addi	sp,sp,-128
ffffffffc02006ae:	0000b517          	auipc	a0,0xb
ffffffffc02006b2:	17250513          	addi	a0,a0,370 # ffffffffc020b820 <commands+0xa8>
ffffffffc02006b6:	fc86                	sd	ra,120(sp)
ffffffffc02006b8:	f8a2                	sd	s0,112(sp)
ffffffffc02006ba:	e8d2                	sd	s4,80(sp)
ffffffffc02006bc:	f4a6                	sd	s1,104(sp)
ffffffffc02006be:	f0ca                	sd	s2,96(sp)
ffffffffc02006c0:	ecce                	sd	s3,88(sp)
ffffffffc02006c2:	e4d6                	sd	s5,72(sp)
ffffffffc02006c4:	e0da                	sd	s6,64(sp)
ffffffffc02006c6:	fc5e                	sd	s7,56(sp)
ffffffffc02006c8:	f862                	sd	s8,48(sp)
ffffffffc02006ca:	f466                	sd	s9,40(sp)
ffffffffc02006cc:	f06a                	sd	s10,32(sp)
ffffffffc02006ce:	ec6e                	sd	s11,24(sp)
ffffffffc02006d0:	ad7ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006d4:	00014597          	auipc	a1,0x14
ffffffffc02006d8:	92c5b583          	ld	a1,-1748(a1) # ffffffffc0214000 <boot_hartid>
ffffffffc02006dc:	0000b517          	auipc	a0,0xb
ffffffffc02006e0:	15450513          	addi	a0,a0,340 # ffffffffc020b830 <commands+0xb8>
ffffffffc02006e4:	ac3ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006e8:	00014417          	auipc	s0,0x14
ffffffffc02006ec:	92040413          	addi	s0,s0,-1760 # ffffffffc0214008 <boot_dtb>
ffffffffc02006f0:	600c                	ld	a1,0(s0)
ffffffffc02006f2:	0000b517          	auipc	a0,0xb
ffffffffc02006f6:	14e50513          	addi	a0,a0,334 # ffffffffc020b840 <commands+0xc8>
ffffffffc02006fa:	aadff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006fe:	00043a03          	ld	s4,0(s0)
ffffffffc0200702:	0000b517          	auipc	a0,0xb
ffffffffc0200706:	15650513          	addi	a0,a0,342 # ffffffffc020b858 <commands+0xe0>
ffffffffc020070a:	120a0463          	beqz	s4,ffffffffc0200832 <dtb_init+0x186>
ffffffffc020070e:	57f5                	li	a5,-3
ffffffffc0200710:	07fa                	slli	a5,a5,0x1e
ffffffffc0200712:	00fa0733          	add	a4,s4,a5
ffffffffc0200716:	431c                	lw	a5,0(a4)
ffffffffc0200718:	00ff0637          	lui	a2,0xff0
ffffffffc020071c:	6b41                	lui	s6,0x10
ffffffffc020071e:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200722:	0187969b          	slliw	a3,a5,0x18
ffffffffc0200726:	0187d51b          	srliw	a0,a5,0x18
ffffffffc020072a:	0105959b          	slliw	a1,a1,0x10
ffffffffc020072e:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200732:	8df1                	and	a1,a1,a2
ffffffffc0200734:	8ec9                	or	a3,a3,a0
ffffffffc0200736:	0087979b          	slliw	a5,a5,0x8
ffffffffc020073a:	1b7d                	addi	s6,s6,-1
ffffffffc020073c:	0167f7b3          	and	a5,a5,s6
ffffffffc0200740:	8dd5                	or	a1,a1,a3
ffffffffc0200742:	8ddd                	or	a1,a1,a5
ffffffffc0200744:	d00e07b7          	lui	a5,0xd00e0
ffffffffc0200748:	2581                	sext.w	a1,a1
ffffffffc020074a:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe495dd>
ffffffffc020074e:	10f59163          	bne	a1,a5,ffffffffc0200850 <dtb_init+0x1a4>
ffffffffc0200752:	471c                	lw	a5,8(a4)
ffffffffc0200754:	4754                	lw	a3,12(a4)
ffffffffc0200756:	4c81                	li	s9,0
ffffffffc0200758:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020075c:	0086d51b          	srliw	a0,a3,0x8
ffffffffc0200760:	0186941b          	slliw	s0,a3,0x18
ffffffffc0200764:	0186d89b          	srliw	a7,a3,0x18
ffffffffc0200768:	01879a1b          	slliw	s4,a5,0x18
ffffffffc020076c:	0187d81b          	srliw	a6,a5,0x18
ffffffffc0200770:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200774:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200778:	0105959b          	slliw	a1,a1,0x10
ffffffffc020077c:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200780:	8d71                	and	a0,a0,a2
ffffffffc0200782:	01146433          	or	s0,s0,a7
ffffffffc0200786:	0086969b          	slliw	a3,a3,0x8
ffffffffc020078a:	010a6a33          	or	s4,s4,a6
ffffffffc020078e:	8e6d                	and	a2,a2,a1
ffffffffc0200790:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200794:	8c49                	or	s0,s0,a0
ffffffffc0200796:	0166f6b3          	and	a3,a3,s6
ffffffffc020079a:	00ca6a33          	or	s4,s4,a2
ffffffffc020079e:	0167f7b3          	and	a5,a5,s6
ffffffffc02007a2:	8c55                	or	s0,s0,a3
ffffffffc02007a4:	00fa6a33          	or	s4,s4,a5
ffffffffc02007a8:	1402                	slli	s0,s0,0x20
ffffffffc02007aa:	1a02                	slli	s4,s4,0x20
ffffffffc02007ac:	9001                	srli	s0,s0,0x20
ffffffffc02007ae:	020a5a13          	srli	s4,s4,0x20
ffffffffc02007b2:	943a                	add	s0,s0,a4
ffffffffc02007b4:	9a3a                	add	s4,s4,a4
ffffffffc02007b6:	00ff0c37          	lui	s8,0xff0
ffffffffc02007ba:	4b8d                	li	s7,3
ffffffffc02007bc:	0000b917          	auipc	s2,0xb
ffffffffc02007c0:	0ec90913          	addi	s2,s2,236 # ffffffffc020b8a8 <commands+0x130>
ffffffffc02007c4:	49bd                	li	s3,15
ffffffffc02007c6:	4d91                	li	s11,4
ffffffffc02007c8:	4d05                	li	s10,1
ffffffffc02007ca:	0000b497          	auipc	s1,0xb
ffffffffc02007ce:	0d648493          	addi	s1,s1,214 # ffffffffc020b8a0 <commands+0x128>
ffffffffc02007d2:	000a2703          	lw	a4,0(s4)
ffffffffc02007d6:	004a0a93          	addi	s5,s4,4
ffffffffc02007da:	0087569b          	srliw	a3,a4,0x8
ffffffffc02007de:	0187179b          	slliw	a5,a4,0x18
ffffffffc02007e2:	0187561b          	srliw	a2,a4,0x18
ffffffffc02007e6:	0106969b          	slliw	a3,a3,0x10
ffffffffc02007ea:	0107571b          	srliw	a4,a4,0x10
ffffffffc02007ee:	8fd1                	or	a5,a5,a2
ffffffffc02007f0:	0186f6b3          	and	a3,a3,s8
ffffffffc02007f4:	0087171b          	slliw	a4,a4,0x8
ffffffffc02007f8:	8fd5                	or	a5,a5,a3
ffffffffc02007fa:	00eb7733          	and	a4,s6,a4
ffffffffc02007fe:	8fd9                	or	a5,a5,a4
ffffffffc0200800:	2781                	sext.w	a5,a5
ffffffffc0200802:	09778c63          	beq	a5,s7,ffffffffc020089a <dtb_init+0x1ee>
ffffffffc0200806:	00fbea63          	bltu	s7,a5,ffffffffc020081a <dtb_init+0x16e>
ffffffffc020080a:	07a78663          	beq	a5,s10,ffffffffc0200876 <dtb_init+0x1ca>
ffffffffc020080e:	4709                	li	a4,2
ffffffffc0200810:	00e79763          	bne	a5,a4,ffffffffc020081e <dtb_init+0x172>
ffffffffc0200814:	4c81                	li	s9,0
ffffffffc0200816:	8a56                	mv	s4,s5
ffffffffc0200818:	bf6d                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc020081a:	ffb78ee3          	beq	a5,s11,ffffffffc0200816 <dtb_init+0x16a>
ffffffffc020081e:	0000b517          	auipc	a0,0xb
ffffffffc0200822:	10250513          	addi	a0,a0,258 # ffffffffc020b920 <commands+0x1a8>
ffffffffc0200826:	981ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020082a:	0000b517          	auipc	a0,0xb
ffffffffc020082e:	12e50513          	addi	a0,a0,302 # ffffffffc020b958 <commands+0x1e0>
ffffffffc0200832:	7446                	ld	s0,112(sp)
ffffffffc0200834:	70e6                	ld	ra,120(sp)
ffffffffc0200836:	74a6                	ld	s1,104(sp)
ffffffffc0200838:	7906                	ld	s2,96(sp)
ffffffffc020083a:	69e6                	ld	s3,88(sp)
ffffffffc020083c:	6a46                	ld	s4,80(sp)
ffffffffc020083e:	6aa6                	ld	s5,72(sp)
ffffffffc0200840:	6b06                	ld	s6,64(sp)
ffffffffc0200842:	7be2                	ld	s7,56(sp)
ffffffffc0200844:	7c42                	ld	s8,48(sp)
ffffffffc0200846:	7ca2                	ld	s9,40(sp)
ffffffffc0200848:	7d02                	ld	s10,32(sp)
ffffffffc020084a:	6de2                	ld	s11,24(sp)
ffffffffc020084c:	6109                	addi	sp,sp,128
ffffffffc020084e:	baa1                	j	ffffffffc02001a6 <cprintf>
ffffffffc0200850:	7446                	ld	s0,112(sp)
ffffffffc0200852:	70e6                	ld	ra,120(sp)
ffffffffc0200854:	74a6                	ld	s1,104(sp)
ffffffffc0200856:	7906                	ld	s2,96(sp)
ffffffffc0200858:	69e6                	ld	s3,88(sp)
ffffffffc020085a:	6a46                	ld	s4,80(sp)
ffffffffc020085c:	6aa6                	ld	s5,72(sp)
ffffffffc020085e:	6b06                	ld	s6,64(sp)
ffffffffc0200860:	7be2                	ld	s7,56(sp)
ffffffffc0200862:	7c42                	ld	s8,48(sp)
ffffffffc0200864:	7ca2                	ld	s9,40(sp)
ffffffffc0200866:	7d02                	ld	s10,32(sp)
ffffffffc0200868:	6de2                	ld	s11,24(sp)
ffffffffc020086a:	0000b517          	auipc	a0,0xb
ffffffffc020086e:	00e50513          	addi	a0,a0,14 # ffffffffc020b878 <commands+0x100>
ffffffffc0200872:	6109                	addi	sp,sp,128
ffffffffc0200874:	ba0d                	j	ffffffffc02001a6 <cprintf>
ffffffffc0200876:	8556                	mv	a0,s5
ffffffffc0200878:	3870a0ef          	jal	ra,ffffffffc020b3fe <strlen>
ffffffffc020087c:	8a2a                	mv	s4,a0
ffffffffc020087e:	4619                	li	a2,6
ffffffffc0200880:	85a6                	mv	a1,s1
ffffffffc0200882:	8556                	mv	a0,s5
ffffffffc0200884:	2a01                	sext.w	s4,s4
ffffffffc0200886:	3df0a0ef          	jal	ra,ffffffffc020b464 <strncmp>
ffffffffc020088a:	e111                	bnez	a0,ffffffffc020088e <dtb_init+0x1e2>
ffffffffc020088c:	4c85                	li	s9,1
ffffffffc020088e:	0a91                	addi	s5,s5,4
ffffffffc0200890:	9ad2                	add	s5,s5,s4
ffffffffc0200892:	ffcafa93          	andi	s5,s5,-4
ffffffffc0200896:	8a56                	mv	s4,s5
ffffffffc0200898:	bf2d                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc020089a:	004a2783          	lw	a5,4(s4)
ffffffffc020089e:	00ca0693          	addi	a3,s4,12
ffffffffc02008a2:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02008a6:	01879a9b          	slliw	s5,a5,0x18
ffffffffc02008aa:	0187d61b          	srliw	a2,a5,0x18
ffffffffc02008ae:	0107171b          	slliw	a4,a4,0x10
ffffffffc02008b2:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02008b6:	00caeab3          	or	s5,s5,a2
ffffffffc02008ba:	01877733          	and	a4,a4,s8
ffffffffc02008be:	0087979b          	slliw	a5,a5,0x8
ffffffffc02008c2:	00eaeab3          	or	s5,s5,a4
ffffffffc02008c6:	00fb77b3          	and	a5,s6,a5
ffffffffc02008ca:	00faeab3          	or	s5,s5,a5
ffffffffc02008ce:	2a81                	sext.w	s5,s5
ffffffffc02008d0:	000c9c63          	bnez	s9,ffffffffc02008e8 <dtb_init+0x23c>
ffffffffc02008d4:	1a82                	slli	s5,s5,0x20
ffffffffc02008d6:	00368793          	addi	a5,a3,3
ffffffffc02008da:	020ada93          	srli	s5,s5,0x20
ffffffffc02008de:	9abe                	add	s5,s5,a5
ffffffffc02008e0:	ffcafa93          	andi	s5,s5,-4
ffffffffc02008e4:	8a56                	mv	s4,s5
ffffffffc02008e6:	b5f5                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc02008e8:	008a2783          	lw	a5,8(s4)
ffffffffc02008ec:	85ca                	mv	a1,s2
ffffffffc02008ee:	e436                	sd	a3,8(sp)
ffffffffc02008f0:	0087d51b          	srliw	a0,a5,0x8
ffffffffc02008f4:	0187d61b          	srliw	a2,a5,0x18
ffffffffc02008f8:	0187971b          	slliw	a4,a5,0x18
ffffffffc02008fc:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200900:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200904:	8f51                	or	a4,a4,a2
ffffffffc0200906:	01857533          	and	a0,a0,s8
ffffffffc020090a:	0087979b          	slliw	a5,a5,0x8
ffffffffc020090e:	8d59                	or	a0,a0,a4
ffffffffc0200910:	00fb77b3          	and	a5,s6,a5
ffffffffc0200914:	8d5d                	or	a0,a0,a5
ffffffffc0200916:	1502                	slli	a0,a0,0x20
ffffffffc0200918:	9101                	srli	a0,a0,0x20
ffffffffc020091a:	9522                	add	a0,a0,s0
ffffffffc020091c:	32b0a0ef          	jal	ra,ffffffffc020b446 <strcmp>
ffffffffc0200920:	66a2                	ld	a3,8(sp)
ffffffffc0200922:	f94d                	bnez	a0,ffffffffc02008d4 <dtb_init+0x228>
ffffffffc0200924:	fb59f8e3          	bgeu	s3,s5,ffffffffc02008d4 <dtb_init+0x228>
ffffffffc0200928:	00ca3783          	ld	a5,12(s4)
ffffffffc020092c:	014a3703          	ld	a4,20(s4)
ffffffffc0200930:	0000b517          	auipc	a0,0xb
ffffffffc0200934:	f8050513          	addi	a0,a0,-128 # ffffffffc020b8b0 <commands+0x138>
ffffffffc0200938:	4207d613          	srai	a2,a5,0x20
ffffffffc020093c:	0087d31b          	srliw	t1,a5,0x8
ffffffffc0200940:	42075593          	srai	a1,a4,0x20
ffffffffc0200944:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200948:	0186581b          	srliw	a6,a2,0x18
ffffffffc020094c:	0187941b          	slliw	s0,a5,0x18
ffffffffc0200950:	0107d89b          	srliw	a7,a5,0x10
ffffffffc0200954:	0187d693          	srli	a3,a5,0x18
ffffffffc0200958:	01861f1b          	slliw	t5,a2,0x18
ffffffffc020095c:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200960:	0103131b          	slliw	t1,t1,0x10
ffffffffc0200964:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200968:	010f6f33          	or	t5,t5,a6
ffffffffc020096c:	0187529b          	srliw	t0,a4,0x18
ffffffffc0200970:	0185df9b          	srliw	t6,a1,0x18
ffffffffc0200974:	01837333          	and	t1,t1,s8
ffffffffc0200978:	01c46433          	or	s0,s0,t3
ffffffffc020097c:	0186f6b3          	and	a3,a3,s8
ffffffffc0200980:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200984:	01871e9b          	slliw	t4,a4,0x18
ffffffffc0200988:	0107581b          	srliw	a6,a4,0x10
ffffffffc020098c:	0086161b          	slliw	a2,a2,0x8
ffffffffc0200990:	8361                	srli	a4,a4,0x18
ffffffffc0200992:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200996:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020099a:	01e6e6b3          	or	a3,a3,t5
ffffffffc020099e:	00cb7633          	and	a2,s6,a2
ffffffffc02009a2:	0088181b          	slliw	a6,a6,0x8
ffffffffc02009a6:	0085959b          	slliw	a1,a1,0x8
ffffffffc02009aa:	00646433          	or	s0,s0,t1
ffffffffc02009ae:	0187f7b3          	and	a5,a5,s8
ffffffffc02009b2:	01fe6333          	or	t1,t3,t6
ffffffffc02009b6:	01877c33          	and	s8,a4,s8
ffffffffc02009ba:	0088989b          	slliw	a7,a7,0x8
ffffffffc02009be:	011b78b3          	and	a7,s6,a7
ffffffffc02009c2:	005eeeb3          	or	t4,t4,t0
ffffffffc02009c6:	00c6e733          	or	a4,a3,a2
ffffffffc02009ca:	006c6c33          	or	s8,s8,t1
ffffffffc02009ce:	010b76b3          	and	a3,s6,a6
ffffffffc02009d2:	00bb7b33          	and	s6,s6,a1
ffffffffc02009d6:	01d7e7b3          	or	a5,a5,t4
ffffffffc02009da:	016c6b33          	or	s6,s8,s6
ffffffffc02009de:	01146433          	or	s0,s0,a7
ffffffffc02009e2:	8fd5                	or	a5,a5,a3
ffffffffc02009e4:	1702                	slli	a4,a4,0x20
ffffffffc02009e6:	1b02                	slli	s6,s6,0x20
ffffffffc02009e8:	1782                	slli	a5,a5,0x20
ffffffffc02009ea:	9301                	srli	a4,a4,0x20
ffffffffc02009ec:	1402                	slli	s0,s0,0x20
ffffffffc02009ee:	020b5b13          	srli	s6,s6,0x20
ffffffffc02009f2:	0167eb33          	or	s6,a5,s6
ffffffffc02009f6:	8c59                	or	s0,s0,a4
ffffffffc02009f8:	faeff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02009fc:	85a2                	mv	a1,s0
ffffffffc02009fe:	0000b517          	auipc	a0,0xb
ffffffffc0200a02:	ed250513          	addi	a0,a0,-302 # ffffffffc020b8d0 <commands+0x158>
ffffffffc0200a06:	fa0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a0a:	014b5613          	srli	a2,s6,0x14
ffffffffc0200a0e:	85da                	mv	a1,s6
ffffffffc0200a10:	0000b517          	auipc	a0,0xb
ffffffffc0200a14:	ed850513          	addi	a0,a0,-296 # ffffffffc020b8e8 <commands+0x170>
ffffffffc0200a18:	f8eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a1c:	008b05b3          	add	a1,s6,s0
ffffffffc0200a20:	15fd                	addi	a1,a1,-1
ffffffffc0200a22:	0000b517          	auipc	a0,0xb
ffffffffc0200a26:	ee650513          	addi	a0,a0,-282 # ffffffffc020b908 <commands+0x190>
ffffffffc0200a2a:	f7cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a2e:	0000b517          	auipc	a0,0xb
ffffffffc0200a32:	f2a50513          	addi	a0,a0,-214 # ffffffffc020b958 <commands+0x1e0>
ffffffffc0200a36:	00096797          	auipc	a5,0x96
ffffffffc0200a3a:	e487b123          	sd	s0,-446(a5) # ffffffffc0296878 <memory_base>
ffffffffc0200a3e:	00096797          	auipc	a5,0x96
ffffffffc0200a42:	e567b123          	sd	s6,-446(a5) # ffffffffc0296880 <memory_size>
ffffffffc0200a46:	b3f5                	j	ffffffffc0200832 <dtb_init+0x186>

ffffffffc0200a48 <get_memory_base>:
ffffffffc0200a48:	00096517          	auipc	a0,0x96
ffffffffc0200a4c:	e3053503          	ld	a0,-464(a0) # ffffffffc0296878 <memory_base>
ffffffffc0200a50:	8082                	ret

ffffffffc0200a52 <get_memory_size>:
ffffffffc0200a52:	00096517          	auipc	a0,0x96
ffffffffc0200a56:	e2e53503          	ld	a0,-466(a0) # ffffffffc0296880 <memory_size>
ffffffffc0200a5a:	8082                	ret

ffffffffc0200a5c <ide_init>:
ffffffffc0200a5c:	1141                	addi	sp,sp,-16
ffffffffc0200a5e:	00091597          	auipc	a1,0x91
ffffffffc0200a62:	c5a58593          	addi	a1,a1,-934 # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200a66:	4505                	li	a0,1
ffffffffc0200a68:	e022                	sd	s0,0(sp)
ffffffffc0200a6a:	00091797          	auipc	a5,0x91
ffffffffc0200a6e:	be07af23          	sw	zero,-1026(a5) # ffffffffc0291668 <ide_devices>
ffffffffc0200a72:	00091797          	auipc	a5,0x91
ffffffffc0200a76:	c407a323          	sw	zero,-954(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200a7a:	00091797          	auipc	a5,0x91
ffffffffc0200a7e:	c807a723          	sw	zero,-882(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200a82:	00091797          	auipc	a5,0x91
ffffffffc0200a86:	cc07ab23          	sw	zero,-810(a5) # ffffffffc0291758 <ide_devices+0xf0>
ffffffffc0200a8a:	e406                	sd	ra,8(sp)
ffffffffc0200a8c:	00091417          	auipc	s0,0x91
ffffffffc0200a90:	bdc40413          	addi	s0,s0,-1060 # ffffffffc0291668 <ide_devices>
ffffffffc0200a94:	23a000ef          	jal	ra,ffffffffc0200cce <ramdisk_init>
ffffffffc0200a98:	483c                	lw	a5,80(s0)
ffffffffc0200a9a:	cf99                	beqz	a5,ffffffffc0200ab8 <ide_init+0x5c>
ffffffffc0200a9c:	00091597          	auipc	a1,0x91
ffffffffc0200aa0:	c6c58593          	addi	a1,a1,-916 # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200aa4:	4509                	li	a0,2
ffffffffc0200aa6:	228000ef          	jal	ra,ffffffffc0200cce <ramdisk_init>
ffffffffc0200aaa:	0a042783          	lw	a5,160(s0)
ffffffffc0200aae:	c785                	beqz	a5,ffffffffc0200ad6 <ide_init+0x7a>
ffffffffc0200ab0:	60a2                	ld	ra,8(sp)
ffffffffc0200ab2:	6402                	ld	s0,0(sp)
ffffffffc0200ab4:	0141                	addi	sp,sp,16
ffffffffc0200ab6:	8082                	ret
ffffffffc0200ab8:	0000b697          	auipc	a3,0xb
ffffffffc0200abc:	eb868693          	addi	a3,a3,-328 # ffffffffc020b970 <commands+0x1f8>
ffffffffc0200ac0:	0000b617          	auipc	a2,0xb
ffffffffc0200ac4:	ec860613          	addi	a2,a2,-312 # ffffffffc020b988 <commands+0x210>
ffffffffc0200ac8:	45c5                	li	a1,17
ffffffffc0200aca:	0000b517          	auipc	a0,0xb
ffffffffc0200ace:	ed650513          	addi	a0,a0,-298 # ffffffffc020b9a0 <commands+0x228>
ffffffffc0200ad2:	9cdff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200ad6:	0000b697          	auipc	a3,0xb
ffffffffc0200ada:	ee268693          	addi	a3,a3,-286 # ffffffffc020b9b8 <commands+0x240>
ffffffffc0200ade:	0000b617          	auipc	a2,0xb
ffffffffc0200ae2:	eaa60613          	addi	a2,a2,-342 # ffffffffc020b988 <commands+0x210>
ffffffffc0200ae6:	45d1                	li	a1,20
ffffffffc0200ae8:	0000b517          	auipc	a0,0xb
ffffffffc0200aec:	eb850513          	addi	a0,a0,-328 # ffffffffc020b9a0 <commands+0x228>
ffffffffc0200af0:	9afff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200af4 <ide_device_valid>:
ffffffffc0200af4:	478d                	li	a5,3
ffffffffc0200af6:	00a7ef63          	bltu	a5,a0,ffffffffc0200b14 <ide_device_valid+0x20>
ffffffffc0200afa:	00251793          	slli	a5,a0,0x2
ffffffffc0200afe:	953e                	add	a0,a0,a5
ffffffffc0200b00:	0512                	slli	a0,a0,0x4
ffffffffc0200b02:	00091797          	auipc	a5,0x91
ffffffffc0200b06:	b6678793          	addi	a5,a5,-1178 # ffffffffc0291668 <ide_devices>
ffffffffc0200b0a:	953e                	add	a0,a0,a5
ffffffffc0200b0c:	4108                	lw	a0,0(a0)
ffffffffc0200b0e:	00a03533          	snez	a0,a0
ffffffffc0200b12:	8082                	ret
ffffffffc0200b14:	4501                	li	a0,0
ffffffffc0200b16:	8082                	ret

ffffffffc0200b18 <ide_device_size>:
ffffffffc0200b18:	478d                	li	a5,3
ffffffffc0200b1a:	02a7e163          	bltu	a5,a0,ffffffffc0200b3c <ide_device_size+0x24>
ffffffffc0200b1e:	00251793          	slli	a5,a0,0x2
ffffffffc0200b22:	953e                	add	a0,a0,a5
ffffffffc0200b24:	0512                	slli	a0,a0,0x4
ffffffffc0200b26:	00091797          	auipc	a5,0x91
ffffffffc0200b2a:	b4278793          	addi	a5,a5,-1214 # ffffffffc0291668 <ide_devices>
ffffffffc0200b2e:	97aa                	add	a5,a5,a0
ffffffffc0200b30:	4398                	lw	a4,0(a5)
ffffffffc0200b32:	4501                	li	a0,0
ffffffffc0200b34:	c709                	beqz	a4,ffffffffc0200b3e <ide_device_size+0x26>
ffffffffc0200b36:	0087e503          	lwu	a0,8(a5)
ffffffffc0200b3a:	8082                	ret
ffffffffc0200b3c:	4501                	li	a0,0
ffffffffc0200b3e:	8082                	ret

ffffffffc0200b40 <ide_read_secs>:
ffffffffc0200b40:	1141                	addi	sp,sp,-16
ffffffffc0200b42:	e406                	sd	ra,8(sp)
ffffffffc0200b44:	08000793          	li	a5,128
ffffffffc0200b48:	04d7e763          	bltu	a5,a3,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b4c:	478d                	li	a5,3
ffffffffc0200b4e:	0005081b          	sext.w	a6,a0
ffffffffc0200b52:	04a7e263          	bltu	a5,a0,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b56:	00281793          	slli	a5,a6,0x2
ffffffffc0200b5a:	97c2                	add	a5,a5,a6
ffffffffc0200b5c:	0792                	slli	a5,a5,0x4
ffffffffc0200b5e:	00091817          	auipc	a6,0x91
ffffffffc0200b62:	b0a80813          	addi	a6,a6,-1270 # ffffffffc0291668 <ide_devices>
ffffffffc0200b66:	97c2                	add	a5,a5,a6
ffffffffc0200b68:	0007a883          	lw	a7,0(a5)
ffffffffc0200b6c:	02088563          	beqz	a7,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b70:	100008b7          	lui	a7,0x10000
ffffffffc0200b74:	0515f163          	bgeu	a1,a7,ffffffffc0200bb6 <ide_read_secs+0x76>
ffffffffc0200b78:	1582                	slli	a1,a1,0x20
ffffffffc0200b7a:	9181                	srli	a1,a1,0x20
ffffffffc0200b7c:	00d58733          	add	a4,a1,a3
ffffffffc0200b80:	02e8eb63          	bltu	a7,a4,ffffffffc0200bb6 <ide_read_secs+0x76>
ffffffffc0200b84:	00251713          	slli	a4,a0,0x2
ffffffffc0200b88:	60a2                	ld	ra,8(sp)
ffffffffc0200b8a:	63bc                	ld	a5,64(a5)
ffffffffc0200b8c:	953a                	add	a0,a0,a4
ffffffffc0200b8e:	0512                	slli	a0,a0,0x4
ffffffffc0200b90:	9542                	add	a0,a0,a6
ffffffffc0200b92:	0141                	addi	sp,sp,16
ffffffffc0200b94:	8782                	jr	a5
ffffffffc0200b96:	0000b697          	auipc	a3,0xb
ffffffffc0200b9a:	e3a68693          	addi	a3,a3,-454 # ffffffffc020b9d0 <commands+0x258>
ffffffffc0200b9e:	0000b617          	auipc	a2,0xb
ffffffffc0200ba2:	dea60613          	addi	a2,a2,-534 # ffffffffc020b988 <commands+0x210>
ffffffffc0200ba6:	02200593          	li	a1,34
ffffffffc0200baa:	0000b517          	auipc	a0,0xb
ffffffffc0200bae:	df650513          	addi	a0,a0,-522 # ffffffffc020b9a0 <commands+0x228>
ffffffffc0200bb2:	8edff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200bb6:	0000b697          	auipc	a3,0xb
ffffffffc0200bba:	e4268693          	addi	a3,a3,-446 # ffffffffc020b9f8 <commands+0x280>
ffffffffc0200bbe:	0000b617          	auipc	a2,0xb
ffffffffc0200bc2:	dca60613          	addi	a2,a2,-566 # ffffffffc020b988 <commands+0x210>
ffffffffc0200bc6:	02300593          	li	a1,35
ffffffffc0200bca:	0000b517          	auipc	a0,0xb
ffffffffc0200bce:	dd650513          	addi	a0,a0,-554 # ffffffffc020b9a0 <commands+0x228>
ffffffffc0200bd2:	8cdff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200bd6 <ide_write_secs>:
ffffffffc0200bd6:	1141                	addi	sp,sp,-16
ffffffffc0200bd8:	e406                	sd	ra,8(sp)
ffffffffc0200bda:	08000793          	li	a5,128
ffffffffc0200bde:	04d7e763          	bltu	a5,a3,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200be2:	478d                	li	a5,3
ffffffffc0200be4:	0005081b          	sext.w	a6,a0
ffffffffc0200be8:	04a7e263          	bltu	a5,a0,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200bec:	00281793          	slli	a5,a6,0x2
ffffffffc0200bf0:	97c2                	add	a5,a5,a6
ffffffffc0200bf2:	0792                	slli	a5,a5,0x4
ffffffffc0200bf4:	00091817          	auipc	a6,0x91
ffffffffc0200bf8:	a7480813          	addi	a6,a6,-1420 # ffffffffc0291668 <ide_devices>
ffffffffc0200bfc:	97c2                	add	a5,a5,a6
ffffffffc0200bfe:	0007a883          	lw	a7,0(a5)
ffffffffc0200c02:	02088563          	beqz	a7,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200c06:	100008b7          	lui	a7,0x10000
ffffffffc0200c0a:	0515f163          	bgeu	a1,a7,ffffffffc0200c4c <ide_write_secs+0x76>
ffffffffc0200c0e:	1582                	slli	a1,a1,0x20
ffffffffc0200c10:	9181                	srli	a1,a1,0x20
ffffffffc0200c12:	00d58733          	add	a4,a1,a3
ffffffffc0200c16:	02e8eb63          	bltu	a7,a4,ffffffffc0200c4c <ide_write_secs+0x76>
ffffffffc0200c1a:	00251713          	slli	a4,a0,0x2
ffffffffc0200c1e:	60a2                	ld	ra,8(sp)
ffffffffc0200c20:	67bc                	ld	a5,72(a5)
ffffffffc0200c22:	953a                	add	a0,a0,a4
ffffffffc0200c24:	0512                	slli	a0,a0,0x4
ffffffffc0200c26:	9542                	add	a0,a0,a6
ffffffffc0200c28:	0141                	addi	sp,sp,16
ffffffffc0200c2a:	8782                	jr	a5
ffffffffc0200c2c:	0000b697          	auipc	a3,0xb
ffffffffc0200c30:	da468693          	addi	a3,a3,-604 # ffffffffc020b9d0 <commands+0x258>
ffffffffc0200c34:	0000b617          	auipc	a2,0xb
ffffffffc0200c38:	d5460613          	addi	a2,a2,-684 # ffffffffc020b988 <commands+0x210>
ffffffffc0200c3c:	02900593          	li	a1,41
ffffffffc0200c40:	0000b517          	auipc	a0,0xb
ffffffffc0200c44:	d6050513          	addi	a0,a0,-672 # ffffffffc020b9a0 <commands+0x228>
ffffffffc0200c48:	857ff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200c4c:	0000b697          	auipc	a3,0xb
ffffffffc0200c50:	dac68693          	addi	a3,a3,-596 # ffffffffc020b9f8 <commands+0x280>
ffffffffc0200c54:	0000b617          	auipc	a2,0xb
ffffffffc0200c58:	d3460613          	addi	a2,a2,-716 # ffffffffc020b988 <commands+0x210>
ffffffffc0200c5c:	02a00593          	li	a1,42
ffffffffc0200c60:	0000b517          	auipc	a0,0xb
ffffffffc0200c64:	d4050513          	addi	a0,a0,-704 # ffffffffc020b9a0 <commands+0x228>
ffffffffc0200c68:	837ff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200c6c <intr_enable>:
ffffffffc0200c6c:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200c70:	8082                	ret

ffffffffc0200c72 <intr_disable>:
ffffffffc0200c72:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200c76:	8082                	ret

ffffffffc0200c78 <pic_init>:
ffffffffc0200c78:	8082                	ret

ffffffffc0200c7a <ramdisk_write>:
ffffffffc0200c7a:	00856703          	lwu	a4,8(a0)
ffffffffc0200c7e:	1141                	addi	sp,sp,-16
ffffffffc0200c80:	e406                	sd	ra,8(sp)
ffffffffc0200c82:	8f0d                	sub	a4,a4,a1
ffffffffc0200c84:	87ae                	mv	a5,a1
ffffffffc0200c86:	85b2                	mv	a1,a2
ffffffffc0200c88:	00e6f363          	bgeu	a3,a4,ffffffffc0200c8e <ramdisk_write+0x14>
ffffffffc0200c8c:	8736                	mv	a4,a3
ffffffffc0200c8e:	6908                	ld	a0,16(a0)
ffffffffc0200c90:	07a6                	slli	a5,a5,0x9
ffffffffc0200c92:	00971613          	slli	a2,a4,0x9
ffffffffc0200c96:	953e                	add	a0,a0,a5
ffffffffc0200c98:	05b0a0ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc0200c9c:	60a2                	ld	ra,8(sp)
ffffffffc0200c9e:	4501                	li	a0,0
ffffffffc0200ca0:	0141                	addi	sp,sp,16
ffffffffc0200ca2:	8082                	ret

ffffffffc0200ca4 <ramdisk_read>:
ffffffffc0200ca4:	00856783          	lwu	a5,8(a0)
ffffffffc0200ca8:	1141                	addi	sp,sp,-16
ffffffffc0200caa:	e406                	sd	ra,8(sp)
ffffffffc0200cac:	8f8d                	sub	a5,a5,a1
ffffffffc0200cae:	872a                	mv	a4,a0
ffffffffc0200cb0:	8532                	mv	a0,a2
ffffffffc0200cb2:	00f6f363          	bgeu	a3,a5,ffffffffc0200cb8 <ramdisk_read+0x14>
ffffffffc0200cb6:	87b6                	mv	a5,a3
ffffffffc0200cb8:	6b18                	ld	a4,16(a4)
ffffffffc0200cba:	05a6                	slli	a1,a1,0x9
ffffffffc0200cbc:	00979613          	slli	a2,a5,0x9
ffffffffc0200cc0:	95ba                	add	a1,a1,a4
ffffffffc0200cc2:	0310a0ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc0200cc6:	60a2                	ld	ra,8(sp)
ffffffffc0200cc8:	4501                	li	a0,0
ffffffffc0200cca:	0141                	addi	sp,sp,16
ffffffffc0200ccc:	8082                	ret

ffffffffc0200cce <ramdisk_init>:
ffffffffc0200cce:	1101                	addi	sp,sp,-32
ffffffffc0200cd0:	e822                	sd	s0,16(sp)
ffffffffc0200cd2:	842e                	mv	s0,a1
ffffffffc0200cd4:	e426                	sd	s1,8(sp)
ffffffffc0200cd6:	05000613          	li	a2,80
ffffffffc0200cda:	84aa                	mv	s1,a0
ffffffffc0200cdc:	4581                	li	a1,0
ffffffffc0200cde:	8522                	mv	a0,s0
ffffffffc0200ce0:	ec06                	sd	ra,24(sp)
ffffffffc0200ce2:	e04a                	sd	s2,0(sp)
ffffffffc0200ce4:	7bc0a0ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0200ce8:	4785                	li	a5,1
ffffffffc0200cea:	06f48b63          	beq	s1,a5,ffffffffc0200d60 <ramdisk_init+0x92>
ffffffffc0200cee:	4789                	li	a5,2
ffffffffc0200cf0:	00090617          	auipc	a2,0x90
ffffffffc0200cf4:	32060613          	addi	a2,a2,800 # ffffffffc0291010 <arena>
ffffffffc0200cf8:	0001b917          	auipc	s2,0x1b
ffffffffc0200cfc:	01890913          	addi	s2,s2,24 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200d00:	08f49563          	bne	s1,a5,ffffffffc0200d8a <ramdisk_init+0xbc>
ffffffffc0200d04:	06c90863          	beq	s2,a2,ffffffffc0200d74 <ramdisk_init+0xa6>
ffffffffc0200d08:	412604b3          	sub	s1,a2,s2
ffffffffc0200d0c:	86a6                	mv	a3,s1
ffffffffc0200d0e:	85ca                	mv	a1,s2
ffffffffc0200d10:	167d                	addi	a2,a2,-1
ffffffffc0200d12:	0000b517          	auipc	a0,0xb
ffffffffc0200d16:	d3e50513          	addi	a0,a0,-706 # ffffffffc020ba50 <commands+0x2d8>
ffffffffc0200d1a:	c8cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200d1e:	57fd                	li	a5,-1
ffffffffc0200d20:	1782                	slli	a5,a5,0x20
ffffffffc0200d22:	0785                	addi	a5,a5,1
ffffffffc0200d24:	0094d49b          	srliw	s1,s1,0x9
ffffffffc0200d28:	e01c                	sd	a5,0(s0)
ffffffffc0200d2a:	c404                	sw	s1,8(s0)
ffffffffc0200d2c:	01243823          	sd	s2,16(s0)
ffffffffc0200d30:	02040513          	addi	a0,s0,32
ffffffffc0200d34:	0000b597          	auipc	a1,0xb
ffffffffc0200d38:	d7458593          	addi	a1,a1,-652 # ffffffffc020baa8 <commands+0x330>
ffffffffc0200d3c:	6f80a0ef          	jal	ra,ffffffffc020b434 <strcpy>
ffffffffc0200d40:	00000797          	auipc	a5,0x0
ffffffffc0200d44:	f6478793          	addi	a5,a5,-156 # ffffffffc0200ca4 <ramdisk_read>
ffffffffc0200d48:	e03c                	sd	a5,64(s0)
ffffffffc0200d4a:	00000797          	auipc	a5,0x0
ffffffffc0200d4e:	f3078793          	addi	a5,a5,-208 # ffffffffc0200c7a <ramdisk_write>
ffffffffc0200d52:	60e2                	ld	ra,24(sp)
ffffffffc0200d54:	e43c                	sd	a5,72(s0)
ffffffffc0200d56:	6442                	ld	s0,16(sp)
ffffffffc0200d58:	64a2                	ld	s1,8(sp)
ffffffffc0200d5a:	6902                	ld	s2,0(sp)
ffffffffc0200d5c:	6105                	addi	sp,sp,32
ffffffffc0200d5e:	8082                	ret
ffffffffc0200d60:	0001b617          	auipc	a2,0x1b
ffffffffc0200d64:	fb060613          	addi	a2,a2,-80 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200d68:	00013917          	auipc	s2,0x13
ffffffffc0200d6c:	2a890913          	addi	s2,s2,680 # ffffffffc0214010 <_binary_bin_swap_img_start>
ffffffffc0200d70:	f8c91ce3          	bne	s2,a2,ffffffffc0200d08 <ramdisk_init+0x3a>
ffffffffc0200d74:	6442                	ld	s0,16(sp)
ffffffffc0200d76:	60e2                	ld	ra,24(sp)
ffffffffc0200d78:	64a2                	ld	s1,8(sp)
ffffffffc0200d7a:	6902                	ld	s2,0(sp)
ffffffffc0200d7c:	0000b517          	auipc	a0,0xb
ffffffffc0200d80:	cbc50513          	addi	a0,a0,-836 # ffffffffc020ba38 <commands+0x2c0>
ffffffffc0200d84:	6105                	addi	sp,sp,32
ffffffffc0200d86:	c20ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200d8a:	0000b617          	auipc	a2,0xb
ffffffffc0200d8e:	cee60613          	addi	a2,a2,-786 # ffffffffc020ba78 <commands+0x300>
ffffffffc0200d92:	03200593          	li	a1,50
ffffffffc0200d96:	0000b517          	auipc	a0,0xb
ffffffffc0200d9a:	cfa50513          	addi	a0,a0,-774 # ffffffffc020ba90 <commands+0x318>
ffffffffc0200d9e:	f00ff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200da2 <idt_init>:
ffffffffc0200da2:	14005073          	csrwi	sscratch,0
ffffffffc0200da6:	00000797          	auipc	a5,0x0
ffffffffc0200daa:	43a78793          	addi	a5,a5,1082 # ffffffffc02011e0 <__alltraps>
ffffffffc0200dae:	10579073          	csrw	stvec,a5
ffffffffc0200db2:	000407b7          	lui	a5,0x40
ffffffffc0200db6:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200dba:	8082                	ret

ffffffffc0200dbc <print_regs>:
ffffffffc0200dbc:	610c                	ld	a1,0(a0)
ffffffffc0200dbe:	1141                	addi	sp,sp,-16
ffffffffc0200dc0:	e022                	sd	s0,0(sp)
ffffffffc0200dc2:	842a                	mv	s0,a0
ffffffffc0200dc4:	0000b517          	auipc	a0,0xb
ffffffffc0200dc8:	cf450513          	addi	a0,a0,-780 # ffffffffc020bab8 <commands+0x340>
ffffffffc0200dcc:	e406                	sd	ra,8(sp)
ffffffffc0200dce:	bd8ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dd2:	640c                	ld	a1,8(s0)
ffffffffc0200dd4:	0000b517          	auipc	a0,0xb
ffffffffc0200dd8:	cfc50513          	addi	a0,a0,-772 # ffffffffc020bad0 <commands+0x358>
ffffffffc0200ddc:	bcaff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200de0:	680c                	ld	a1,16(s0)
ffffffffc0200de2:	0000b517          	auipc	a0,0xb
ffffffffc0200de6:	d0650513          	addi	a0,a0,-762 # ffffffffc020bae8 <commands+0x370>
ffffffffc0200dea:	bbcff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dee:	6c0c                	ld	a1,24(s0)
ffffffffc0200df0:	0000b517          	auipc	a0,0xb
ffffffffc0200df4:	d1050513          	addi	a0,a0,-752 # ffffffffc020bb00 <commands+0x388>
ffffffffc0200df8:	baeff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dfc:	700c                	ld	a1,32(s0)
ffffffffc0200dfe:	0000b517          	auipc	a0,0xb
ffffffffc0200e02:	d1a50513          	addi	a0,a0,-742 # ffffffffc020bb18 <commands+0x3a0>
ffffffffc0200e06:	ba0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e0a:	740c                	ld	a1,40(s0)
ffffffffc0200e0c:	0000b517          	auipc	a0,0xb
ffffffffc0200e10:	d2450513          	addi	a0,a0,-732 # ffffffffc020bb30 <commands+0x3b8>
ffffffffc0200e14:	b92ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e18:	780c                	ld	a1,48(s0)
ffffffffc0200e1a:	0000b517          	auipc	a0,0xb
ffffffffc0200e1e:	d2e50513          	addi	a0,a0,-722 # ffffffffc020bb48 <commands+0x3d0>
ffffffffc0200e22:	b84ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e26:	7c0c                	ld	a1,56(s0)
ffffffffc0200e28:	0000b517          	auipc	a0,0xb
ffffffffc0200e2c:	d3850513          	addi	a0,a0,-712 # ffffffffc020bb60 <commands+0x3e8>
ffffffffc0200e30:	b76ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e34:	602c                	ld	a1,64(s0)
ffffffffc0200e36:	0000b517          	auipc	a0,0xb
ffffffffc0200e3a:	d4250513          	addi	a0,a0,-702 # ffffffffc020bb78 <commands+0x400>
ffffffffc0200e3e:	b68ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e42:	642c                	ld	a1,72(s0)
ffffffffc0200e44:	0000b517          	auipc	a0,0xb
ffffffffc0200e48:	d4c50513          	addi	a0,a0,-692 # ffffffffc020bb90 <commands+0x418>
ffffffffc0200e4c:	b5aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e50:	682c                	ld	a1,80(s0)
ffffffffc0200e52:	0000b517          	auipc	a0,0xb
ffffffffc0200e56:	d5650513          	addi	a0,a0,-682 # ffffffffc020bba8 <commands+0x430>
ffffffffc0200e5a:	b4cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e5e:	6c2c                	ld	a1,88(s0)
ffffffffc0200e60:	0000b517          	auipc	a0,0xb
ffffffffc0200e64:	d6050513          	addi	a0,a0,-672 # ffffffffc020bbc0 <commands+0x448>
ffffffffc0200e68:	b3eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e6c:	702c                	ld	a1,96(s0)
ffffffffc0200e6e:	0000b517          	auipc	a0,0xb
ffffffffc0200e72:	d6a50513          	addi	a0,a0,-662 # ffffffffc020bbd8 <commands+0x460>
ffffffffc0200e76:	b30ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e7a:	742c                	ld	a1,104(s0)
ffffffffc0200e7c:	0000b517          	auipc	a0,0xb
ffffffffc0200e80:	d7450513          	addi	a0,a0,-652 # ffffffffc020bbf0 <commands+0x478>
ffffffffc0200e84:	b22ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e88:	782c                	ld	a1,112(s0)
ffffffffc0200e8a:	0000b517          	auipc	a0,0xb
ffffffffc0200e8e:	d7e50513          	addi	a0,a0,-642 # ffffffffc020bc08 <commands+0x490>
ffffffffc0200e92:	b14ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e96:	7c2c                	ld	a1,120(s0)
ffffffffc0200e98:	0000b517          	auipc	a0,0xb
ffffffffc0200e9c:	d8850513          	addi	a0,a0,-632 # ffffffffc020bc20 <commands+0x4a8>
ffffffffc0200ea0:	b06ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ea4:	604c                	ld	a1,128(s0)
ffffffffc0200ea6:	0000b517          	auipc	a0,0xb
ffffffffc0200eaa:	d9250513          	addi	a0,a0,-622 # ffffffffc020bc38 <commands+0x4c0>
ffffffffc0200eae:	af8ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200eb2:	644c                	ld	a1,136(s0)
ffffffffc0200eb4:	0000b517          	auipc	a0,0xb
ffffffffc0200eb8:	d9c50513          	addi	a0,a0,-612 # ffffffffc020bc50 <commands+0x4d8>
ffffffffc0200ebc:	aeaff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ec0:	684c                	ld	a1,144(s0)
ffffffffc0200ec2:	0000b517          	auipc	a0,0xb
ffffffffc0200ec6:	da650513          	addi	a0,a0,-602 # ffffffffc020bc68 <commands+0x4f0>
ffffffffc0200eca:	adcff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ece:	6c4c                	ld	a1,152(s0)
ffffffffc0200ed0:	0000b517          	auipc	a0,0xb
ffffffffc0200ed4:	db050513          	addi	a0,a0,-592 # ffffffffc020bc80 <commands+0x508>
ffffffffc0200ed8:	aceff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200edc:	704c                	ld	a1,160(s0)
ffffffffc0200ede:	0000b517          	auipc	a0,0xb
ffffffffc0200ee2:	dba50513          	addi	a0,a0,-582 # ffffffffc020bc98 <commands+0x520>
ffffffffc0200ee6:	ac0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200eea:	744c                	ld	a1,168(s0)
ffffffffc0200eec:	0000b517          	auipc	a0,0xb
ffffffffc0200ef0:	dc450513          	addi	a0,a0,-572 # ffffffffc020bcb0 <commands+0x538>
ffffffffc0200ef4:	ab2ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ef8:	784c                	ld	a1,176(s0)
ffffffffc0200efa:	0000b517          	auipc	a0,0xb
ffffffffc0200efe:	dce50513          	addi	a0,a0,-562 # ffffffffc020bcc8 <commands+0x550>
ffffffffc0200f02:	aa4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f06:	7c4c                	ld	a1,184(s0)
ffffffffc0200f08:	0000b517          	auipc	a0,0xb
ffffffffc0200f0c:	dd850513          	addi	a0,a0,-552 # ffffffffc020bce0 <commands+0x568>
ffffffffc0200f10:	a96ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f14:	606c                	ld	a1,192(s0)
ffffffffc0200f16:	0000b517          	auipc	a0,0xb
ffffffffc0200f1a:	de250513          	addi	a0,a0,-542 # ffffffffc020bcf8 <commands+0x580>
ffffffffc0200f1e:	a88ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f22:	646c                	ld	a1,200(s0)
ffffffffc0200f24:	0000b517          	auipc	a0,0xb
ffffffffc0200f28:	dec50513          	addi	a0,a0,-532 # ffffffffc020bd10 <commands+0x598>
ffffffffc0200f2c:	a7aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f30:	686c                	ld	a1,208(s0)
ffffffffc0200f32:	0000b517          	auipc	a0,0xb
ffffffffc0200f36:	df650513          	addi	a0,a0,-522 # ffffffffc020bd28 <commands+0x5b0>
ffffffffc0200f3a:	a6cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f3e:	6c6c                	ld	a1,216(s0)
ffffffffc0200f40:	0000b517          	auipc	a0,0xb
ffffffffc0200f44:	e0050513          	addi	a0,a0,-512 # ffffffffc020bd40 <commands+0x5c8>
ffffffffc0200f48:	a5eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f4c:	706c                	ld	a1,224(s0)
ffffffffc0200f4e:	0000b517          	auipc	a0,0xb
ffffffffc0200f52:	e0a50513          	addi	a0,a0,-502 # ffffffffc020bd58 <commands+0x5e0>
ffffffffc0200f56:	a50ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f5a:	746c                	ld	a1,232(s0)
ffffffffc0200f5c:	0000b517          	auipc	a0,0xb
ffffffffc0200f60:	e1450513          	addi	a0,a0,-492 # ffffffffc020bd70 <commands+0x5f8>
ffffffffc0200f64:	a42ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f68:	786c                	ld	a1,240(s0)
ffffffffc0200f6a:	0000b517          	auipc	a0,0xb
ffffffffc0200f6e:	e1e50513          	addi	a0,a0,-482 # ffffffffc020bd88 <commands+0x610>
ffffffffc0200f72:	a34ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f76:	7c6c                	ld	a1,248(s0)
ffffffffc0200f78:	6402                	ld	s0,0(sp)
ffffffffc0200f7a:	60a2                	ld	ra,8(sp)
ffffffffc0200f7c:	0000b517          	auipc	a0,0xb
ffffffffc0200f80:	e2450513          	addi	a0,a0,-476 # ffffffffc020bda0 <commands+0x628>
ffffffffc0200f84:	0141                	addi	sp,sp,16
ffffffffc0200f86:	a20ff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200f8a <print_trapframe>:
ffffffffc0200f8a:	1141                	addi	sp,sp,-16
ffffffffc0200f8c:	e022                	sd	s0,0(sp)
ffffffffc0200f8e:	85aa                	mv	a1,a0
ffffffffc0200f90:	842a                	mv	s0,a0
ffffffffc0200f92:	0000b517          	auipc	a0,0xb
ffffffffc0200f96:	e2650513          	addi	a0,a0,-474 # ffffffffc020bdb8 <commands+0x640>
ffffffffc0200f9a:	e406                	sd	ra,8(sp)
ffffffffc0200f9c:	a0aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fa0:	8522                	mv	a0,s0
ffffffffc0200fa2:	e1bff0ef          	jal	ra,ffffffffc0200dbc <print_regs>
ffffffffc0200fa6:	10043583          	ld	a1,256(s0)
ffffffffc0200faa:	0000b517          	auipc	a0,0xb
ffffffffc0200fae:	e2650513          	addi	a0,a0,-474 # ffffffffc020bdd0 <commands+0x658>
ffffffffc0200fb2:	9f4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fb6:	10843583          	ld	a1,264(s0)
ffffffffc0200fba:	0000b517          	auipc	a0,0xb
ffffffffc0200fbe:	e2e50513          	addi	a0,a0,-466 # ffffffffc020bde8 <commands+0x670>
ffffffffc0200fc2:	9e4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fc6:	11043583          	ld	a1,272(s0)
ffffffffc0200fca:	0000b517          	auipc	a0,0xb
ffffffffc0200fce:	e3650513          	addi	a0,a0,-458 # ffffffffc020be00 <commands+0x688>
ffffffffc0200fd2:	9d4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fd6:	11843583          	ld	a1,280(s0)
ffffffffc0200fda:	6402                	ld	s0,0(sp)
ffffffffc0200fdc:	60a2                	ld	ra,8(sp)
ffffffffc0200fde:	0000b517          	auipc	a0,0xb
ffffffffc0200fe2:	e3250513          	addi	a0,a0,-462 # ffffffffc020be10 <commands+0x698>
ffffffffc0200fe6:	0141                	addi	sp,sp,16
ffffffffc0200fe8:	9beff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200fec <interrupt_handler>:
ffffffffc0200fec:	11853783          	ld	a5,280(a0)
ffffffffc0200ff0:	472d                	li	a4,11
ffffffffc0200ff2:	0786                	slli	a5,a5,0x1
ffffffffc0200ff4:	8385                	srli	a5,a5,0x1
ffffffffc0200ff6:	06f76c63          	bltu	a4,a5,ffffffffc020106e <interrupt_handler+0x82>
ffffffffc0200ffa:	0000b717          	auipc	a4,0xb
ffffffffc0200ffe:	ece70713          	addi	a4,a4,-306 # ffffffffc020bec8 <commands+0x750>
ffffffffc0201002:	078a                	slli	a5,a5,0x2
ffffffffc0201004:	97ba                	add	a5,a5,a4
ffffffffc0201006:	439c                	lw	a5,0(a5)
ffffffffc0201008:	97ba                	add	a5,a5,a4
ffffffffc020100a:	8782                	jr	a5
ffffffffc020100c:	0000b517          	auipc	a0,0xb
ffffffffc0201010:	e7c50513          	addi	a0,a0,-388 # ffffffffc020be88 <commands+0x710>
ffffffffc0201014:	992ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201018:	0000b517          	auipc	a0,0xb
ffffffffc020101c:	e5050513          	addi	a0,a0,-432 # ffffffffc020be68 <commands+0x6f0>
ffffffffc0201020:	986ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201024:	0000b517          	auipc	a0,0xb
ffffffffc0201028:	e0450513          	addi	a0,a0,-508 # ffffffffc020be28 <commands+0x6b0>
ffffffffc020102c:	97aff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201030:	0000b517          	auipc	a0,0xb
ffffffffc0201034:	e1850513          	addi	a0,a0,-488 # ffffffffc020be48 <commands+0x6d0>
ffffffffc0201038:	96eff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020103c:	1141                	addi	sp,sp,-16
ffffffffc020103e:	e406                	sd	ra,8(sp)
ffffffffc0201040:	d3aff0ef          	jal	ra,ffffffffc020057a <clock_set_next_event>
ffffffffc0201044:	00096717          	auipc	a4,0x96
ffffffffc0201048:	82c70713          	addi	a4,a4,-2004 # ffffffffc0296870 <ticks>
ffffffffc020104c:	631c                	ld	a5,0(a4)
ffffffffc020104e:	0785                	addi	a5,a5,1
ffffffffc0201050:	e31c                	sd	a5,0(a4)
ffffffffc0201052:	4e4060ef          	jal	ra,ffffffffc0207536 <run_timer_list>
ffffffffc0201056:	d9eff0ef          	jal	ra,ffffffffc02005f4 <cons_getc>
ffffffffc020105a:	60a2                	ld	ra,8(sp)
ffffffffc020105c:	0141                	addi	sp,sp,16
ffffffffc020105e:	3a90706f          	j	ffffffffc0208c06 <dev_stdin_write>
ffffffffc0201062:	0000b517          	auipc	a0,0xb
ffffffffc0201066:	e4650513          	addi	a0,a0,-442 # ffffffffc020bea8 <commands+0x730>
ffffffffc020106a:	93cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020106e:	bf31                	j	ffffffffc0200f8a <print_trapframe>

ffffffffc0201070 <exception_handler>:
ffffffffc0201070:	11853783          	ld	a5,280(a0)
ffffffffc0201074:	1141                	addi	sp,sp,-16
ffffffffc0201076:	e022                	sd	s0,0(sp)
ffffffffc0201078:	e406                	sd	ra,8(sp)
ffffffffc020107a:	473d                	li	a4,15
ffffffffc020107c:	842a                	mv	s0,a0
ffffffffc020107e:	0af76b63          	bltu	a4,a5,ffffffffc0201134 <exception_handler+0xc4>
ffffffffc0201082:	0000b717          	auipc	a4,0xb
ffffffffc0201086:	00670713          	addi	a4,a4,6 # ffffffffc020c088 <commands+0x910>
ffffffffc020108a:	078a                	slli	a5,a5,0x2
ffffffffc020108c:	97ba                	add	a5,a5,a4
ffffffffc020108e:	439c                	lw	a5,0(a5)
ffffffffc0201090:	97ba                	add	a5,a5,a4
ffffffffc0201092:	8782                	jr	a5
ffffffffc0201094:	0000b517          	auipc	a0,0xb
ffffffffc0201098:	f4c50513          	addi	a0,a0,-180 # ffffffffc020bfe0 <commands+0x868>
ffffffffc020109c:	90aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02010a0:	10843783          	ld	a5,264(s0)
ffffffffc02010a4:	60a2                	ld	ra,8(sp)
ffffffffc02010a6:	0791                	addi	a5,a5,4
ffffffffc02010a8:	10f43423          	sd	a5,264(s0)
ffffffffc02010ac:	6402                	ld	s0,0(sp)
ffffffffc02010ae:	0141                	addi	sp,sp,16
ffffffffc02010b0:	69c0606f          	j	ffffffffc020774c <syscall>
ffffffffc02010b4:	0000b517          	auipc	a0,0xb
ffffffffc02010b8:	f4c50513          	addi	a0,a0,-180 # ffffffffc020c000 <commands+0x888>
ffffffffc02010bc:	6402                	ld	s0,0(sp)
ffffffffc02010be:	60a2                	ld	ra,8(sp)
ffffffffc02010c0:	0141                	addi	sp,sp,16
ffffffffc02010c2:	8e4ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010c6:	0000b517          	auipc	a0,0xb
ffffffffc02010ca:	f5a50513          	addi	a0,a0,-166 # ffffffffc020c020 <commands+0x8a8>
ffffffffc02010ce:	b7fd                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010d0:	0000b517          	auipc	a0,0xb
ffffffffc02010d4:	f7050513          	addi	a0,a0,-144 # ffffffffc020c040 <commands+0x8c8>
ffffffffc02010d8:	b7d5                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010da:	0000b517          	auipc	a0,0xb
ffffffffc02010de:	f7e50513          	addi	a0,a0,-130 # ffffffffc020c058 <commands+0x8e0>
ffffffffc02010e2:	bfe9                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010e4:	0000b517          	auipc	a0,0xb
ffffffffc02010e8:	f8c50513          	addi	a0,a0,-116 # ffffffffc020c070 <commands+0x8f8>
ffffffffc02010ec:	bfc1                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010ee:	0000b517          	auipc	a0,0xb
ffffffffc02010f2:	e0a50513          	addi	a0,a0,-502 # ffffffffc020bef8 <commands+0x780>
ffffffffc02010f6:	b7d9                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010f8:	0000b517          	auipc	a0,0xb
ffffffffc02010fc:	e2050513          	addi	a0,a0,-480 # ffffffffc020bf18 <commands+0x7a0>
ffffffffc0201100:	bf75                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc0201102:	0000b517          	auipc	a0,0xb
ffffffffc0201106:	e3650513          	addi	a0,a0,-458 # ffffffffc020bf38 <commands+0x7c0>
ffffffffc020110a:	bf4d                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc020110c:	0000b517          	auipc	a0,0xb
ffffffffc0201110:	e4450513          	addi	a0,a0,-444 # ffffffffc020bf50 <commands+0x7d8>
ffffffffc0201114:	b765                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc0201116:	0000b517          	auipc	a0,0xb
ffffffffc020111a:	e4a50513          	addi	a0,a0,-438 # ffffffffc020bf60 <commands+0x7e8>
ffffffffc020111e:	bf79                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc0201120:	0000b517          	auipc	a0,0xb
ffffffffc0201124:	e6050513          	addi	a0,a0,-416 # ffffffffc020bf80 <commands+0x808>
ffffffffc0201128:	bf51                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc020112a:	0000b517          	auipc	a0,0xb
ffffffffc020112e:	e9e50513          	addi	a0,a0,-354 # ffffffffc020bfc8 <commands+0x850>
ffffffffc0201132:	b769                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc0201134:	8522                	mv	a0,s0
ffffffffc0201136:	6402                	ld	s0,0(sp)
ffffffffc0201138:	60a2                	ld	ra,8(sp)
ffffffffc020113a:	0141                	addi	sp,sp,16
ffffffffc020113c:	b5b9                	j	ffffffffc0200f8a <print_trapframe>
ffffffffc020113e:	0000b617          	auipc	a2,0xb
ffffffffc0201142:	e5a60613          	addi	a2,a2,-422 # ffffffffc020bf98 <commands+0x820>
ffffffffc0201146:	0b100593          	li	a1,177
ffffffffc020114a:	0000b517          	auipc	a0,0xb
ffffffffc020114e:	e6650513          	addi	a0,a0,-410 # ffffffffc020bfb0 <commands+0x838>
ffffffffc0201152:	b4cff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201156 <trap>:
ffffffffc0201156:	1101                	addi	sp,sp,-32
ffffffffc0201158:	e822                	sd	s0,16(sp)
ffffffffc020115a:	00095417          	auipc	s0,0x95
ffffffffc020115e:	76640413          	addi	s0,s0,1894 # ffffffffc02968c0 <current>
ffffffffc0201162:	6018                	ld	a4,0(s0)
ffffffffc0201164:	ec06                	sd	ra,24(sp)
ffffffffc0201166:	e426                	sd	s1,8(sp)
ffffffffc0201168:	e04a                	sd	s2,0(sp)
ffffffffc020116a:	11853683          	ld	a3,280(a0)
ffffffffc020116e:	cf1d                	beqz	a4,ffffffffc02011ac <trap+0x56>
ffffffffc0201170:	10053483          	ld	s1,256(a0)
ffffffffc0201174:	0a073903          	ld	s2,160(a4)
ffffffffc0201178:	f348                	sd	a0,160(a4)
ffffffffc020117a:	1004f493          	andi	s1,s1,256
ffffffffc020117e:	0206c463          	bltz	a3,ffffffffc02011a6 <trap+0x50>
ffffffffc0201182:	eefff0ef          	jal	ra,ffffffffc0201070 <exception_handler>
ffffffffc0201186:	601c                	ld	a5,0(s0)
ffffffffc0201188:	0b27b023          	sd	s2,160(a5) # 400a0 <_binary_bin_swap_img_size+0x383a0>
ffffffffc020118c:	e499                	bnez	s1,ffffffffc020119a <trap+0x44>
ffffffffc020118e:	0b07a703          	lw	a4,176(a5)
ffffffffc0201192:	8b05                	andi	a4,a4,1
ffffffffc0201194:	e329                	bnez	a4,ffffffffc02011d6 <trap+0x80>
ffffffffc0201196:	6f9c                	ld	a5,24(a5)
ffffffffc0201198:	eb85                	bnez	a5,ffffffffc02011c8 <trap+0x72>
ffffffffc020119a:	60e2                	ld	ra,24(sp)
ffffffffc020119c:	6442                	ld	s0,16(sp)
ffffffffc020119e:	64a2                	ld	s1,8(sp)
ffffffffc02011a0:	6902                	ld	s2,0(sp)
ffffffffc02011a2:	6105                	addi	sp,sp,32
ffffffffc02011a4:	8082                	ret
ffffffffc02011a6:	e47ff0ef          	jal	ra,ffffffffc0200fec <interrupt_handler>
ffffffffc02011aa:	bff1                	j	ffffffffc0201186 <trap+0x30>
ffffffffc02011ac:	0006c863          	bltz	a3,ffffffffc02011bc <trap+0x66>
ffffffffc02011b0:	6442                	ld	s0,16(sp)
ffffffffc02011b2:	60e2                	ld	ra,24(sp)
ffffffffc02011b4:	64a2                	ld	s1,8(sp)
ffffffffc02011b6:	6902                	ld	s2,0(sp)
ffffffffc02011b8:	6105                	addi	sp,sp,32
ffffffffc02011ba:	bd5d                	j	ffffffffc0201070 <exception_handler>
ffffffffc02011bc:	6442                	ld	s0,16(sp)
ffffffffc02011be:	60e2                	ld	ra,24(sp)
ffffffffc02011c0:	64a2                	ld	s1,8(sp)
ffffffffc02011c2:	6902                	ld	s2,0(sp)
ffffffffc02011c4:	6105                	addi	sp,sp,32
ffffffffc02011c6:	b51d                	j	ffffffffc0200fec <interrupt_handler>
ffffffffc02011c8:	6442                	ld	s0,16(sp)
ffffffffc02011ca:	60e2                	ld	ra,24(sp)
ffffffffc02011cc:	64a2                	ld	s1,8(sp)
ffffffffc02011ce:	6902                	ld	s2,0(sp)
ffffffffc02011d0:	6105                	addi	sp,sp,32
ffffffffc02011d2:	1580606f          	j	ffffffffc020732a <schedule>
ffffffffc02011d6:	555d                	li	a0,-9
ffffffffc02011d8:	625040ef          	jal	ra,ffffffffc0205ffc <do_exit>
ffffffffc02011dc:	601c                	ld	a5,0(s0)
ffffffffc02011de:	bf65                	j	ffffffffc0201196 <trap+0x40>

ffffffffc02011e0 <__alltraps>:
ffffffffc02011e0:	14011173          	csrrw	sp,sscratch,sp
ffffffffc02011e4:	00011463          	bnez	sp,ffffffffc02011ec <__alltraps+0xc>
ffffffffc02011e8:	14002173          	csrr	sp,sscratch
ffffffffc02011ec:	712d                	addi	sp,sp,-288
ffffffffc02011ee:	e002                	sd	zero,0(sp)
ffffffffc02011f0:	e406                	sd	ra,8(sp)
ffffffffc02011f2:	ec0e                	sd	gp,24(sp)
ffffffffc02011f4:	f012                	sd	tp,32(sp)
ffffffffc02011f6:	f416                	sd	t0,40(sp)
ffffffffc02011f8:	f81a                	sd	t1,48(sp)
ffffffffc02011fa:	fc1e                	sd	t2,56(sp)
ffffffffc02011fc:	e0a2                	sd	s0,64(sp)
ffffffffc02011fe:	e4a6                	sd	s1,72(sp)
ffffffffc0201200:	e8aa                	sd	a0,80(sp)
ffffffffc0201202:	ecae                	sd	a1,88(sp)
ffffffffc0201204:	f0b2                	sd	a2,96(sp)
ffffffffc0201206:	f4b6                	sd	a3,104(sp)
ffffffffc0201208:	f8ba                	sd	a4,112(sp)
ffffffffc020120a:	fcbe                	sd	a5,120(sp)
ffffffffc020120c:	e142                	sd	a6,128(sp)
ffffffffc020120e:	e546                	sd	a7,136(sp)
ffffffffc0201210:	e94a                	sd	s2,144(sp)
ffffffffc0201212:	ed4e                	sd	s3,152(sp)
ffffffffc0201214:	f152                	sd	s4,160(sp)
ffffffffc0201216:	f556                	sd	s5,168(sp)
ffffffffc0201218:	f95a                	sd	s6,176(sp)
ffffffffc020121a:	fd5e                	sd	s7,184(sp)
ffffffffc020121c:	e1e2                	sd	s8,192(sp)
ffffffffc020121e:	e5e6                	sd	s9,200(sp)
ffffffffc0201220:	e9ea                	sd	s10,208(sp)
ffffffffc0201222:	edee                	sd	s11,216(sp)
ffffffffc0201224:	f1f2                	sd	t3,224(sp)
ffffffffc0201226:	f5f6                	sd	t4,232(sp)
ffffffffc0201228:	f9fa                	sd	t5,240(sp)
ffffffffc020122a:	fdfe                	sd	t6,248(sp)
ffffffffc020122c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0201230:	100024f3          	csrr	s1,sstatus
ffffffffc0201234:	14102973          	csrr	s2,sepc
ffffffffc0201238:	143029f3          	csrr	s3,stval
ffffffffc020123c:	14202a73          	csrr	s4,scause
ffffffffc0201240:	e822                	sd	s0,16(sp)
ffffffffc0201242:	e226                	sd	s1,256(sp)
ffffffffc0201244:	e64a                	sd	s2,264(sp)
ffffffffc0201246:	ea4e                	sd	s3,272(sp)
ffffffffc0201248:	ee52                	sd	s4,280(sp)
ffffffffc020124a:	850a                	mv	a0,sp
ffffffffc020124c:	f0bff0ef          	jal	ra,ffffffffc0201156 <trap>

ffffffffc0201250 <__trapret>:
ffffffffc0201250:	6492                	ld	s1,256(sp)
ffffffffc0201252:	6932                	ld	s2,264(sp)
ffffffffc0201254:	1004f413          	andi	s0,s1,256
ffffffffc0201258:	e401                	bnez	s0,ffffffffc0201260 <__trapret+0x10>
ffffffffc020125a:	1200                	addi	s0,sp,288
ffffffffc020125c:	14041073          	csrw	sscratch,s0
ffffffffc0201260:	10049073          	csrw	sstatus,s1
ffffffffc0201264:	14191073          	csrw	sepc,s2
ffffffffc0201268:	60a2                	ld	ra,8(sp)
ffffffffc020126a:	61e2                	ld	gp,24(sp)
ffffffffc020126c:	7202                	ld	tp,32(sp)
ffffffffc020126e:	72a2                	ld	t0,40(sp)
ffffffffc0201270:	7342                	ld	t1,48(sp)
ffffffffc0201272:	73e2                	ld	t2,56(sp)
ffffffffc0201274:	6406                	ld	s0,64(sp)
ffffffffc0201276:	64a6                	ld	s1,72(sp)
ffffffffc0201278:	6546                	ld	a0,80(sp)
ffffffffc020127a:	65e6                	ld	a1,88(sp)
ffffffffc020127c:	7606                	ld	a2,96(sp)
ffffffffc020127e:	76a6                	ld	a3,104(sp)
ffffffffc0201280:	7746                	ld	a4,112(sp)
ffffffffc0201282:	77e6                	ld	a5,120(sp)
ffffffffc0201284:	680a                	ld	a6,128(sp)
ffffffffc0201286:	68aa                	ld	a7,136(sp)
ffffffffc0201288:	694a                	ld	s2,144(sp)
ffffffffc020128a:	69ea                	ld	s3,152(sp)
ffffffffc020128c:	7a0a                	ld	s4,160(sp)
ffffffffc020128e:	7aaa                	ld	s5,168(sp)
ffffffffc0201290:	7b4a                	ld	s6,176(sp)
ffffffffc0201292:	7bea                	ld	s7,184(sp)
ffffffffc0201294:	6c0e                	ld	s8,192(sp)
ffffffffc0201296:	6cae                	ld	s9,200(sp)
ffffffffc0201298:	6d4e                	ld	s10,208(sp)
ffffffffc020129a:	6dee                	ld	s11,216(sp)
ffffffffc020129c:	7e0e                	ld	t3,224(sp)
ffffffffc020129e:	7eae                	ld	t4,232(sp)
ffffffffc02012a0:	7f4e                	ld	t5,240(sp)
ffffffffc02012a2:	7fee                	ld	t6,248(sp)
ffffffffc02012a4:	6142                	ld	sp,16(sp)
ffffffffc02012a6:	10200073          	sret

ffffffffc02012aa <forkrets>:
ffffffffc02012aa:	812a                	mv	sp,a0
ffffffffc02012ac:	b755                	j	ffffffffc0201250 <__trapret>

ffffffffc02012ae <default_init>:
ffffffffc02012ae:	00090797          	auipc	a5,0x90
ffffffffc02012b2:	4fa78793          	addi	a5,a5,1274 # ffffffffc02917a8 <free_area>
ffffffffc02012b6:	e79c                	sd	a5,8(a5)
ffffffffc02012b8:	e39c                	sd	a5,0(a5)
ffffffffc02012ba:	0007a823          	sw	zero,16(a5)
ffffffffc02012be:	8082                	ret

ffffffffc02012c0 <default_nr_free_pages>:
ffffffffc02012c0:	00090517          	auipc	a0,0x90
ffffffffc02012c4:	4f856503          	lwu	a0,1272(a0) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02012c8:	8082                	ret

ffffffffc02012ca <default_check>:
ffffffffc02012ca:	715d                	addi	sp,sp,-80
ffffffffc02012cc:	e0a2                	sd	s0,64(sp)
ffffffffc02012ce:	00090417          	auipc	s0,0x90
ffffffffc02012d2:	4da40413          	addi	s0,s0,1242 # ffffffffc02917a8 <free_area>
ffffffffc02012d6:	641c                	ld	a5,8(s0)
ffffffffc02012d8:	e486                	sd	ra,72(sp)
ffffffffc02012da:	fc26                	sd	s1,56(sp)
ffffffffc02012dc:	f84a                	sd	s2,48(sp)
ffffffffc02012de:	f44e                	sd	s3,40(sp)
ffffffffc02012e0:	f052                	sd	s4,32(sp)
ffffffffc02012e2:	ec56                	sd	s5,24(sp)
ffffffffc02012e4:	e85a                	sd	s6,16(sp)
ffffffffc02012e6:	e45e                	sd	s7,8(sp)
ffffffffc02012e8:	e062                	sd	s8,0(sp)
ffffffffc02012ea:	2a878d63          	beq	a5,s0,ffffffffc02015a4 <default_check+0x2da>
ffffffffc02012ee:	4481                	li	s1,0
ffffffffc02012f0:	4901                	li	s2,0
ffffffffc02012f2:	ff07b703          	ld	a4,-16(a5)
ffffffffc02012f6:	8b09                	andi	a4,a4,2
ffffffffc02012f8:	2a070a63          	beqz	a4,ffffffffc02015ac <default_check+0x2e2>
ffffffffc02012fc:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201300:	679c                	ld	a5,8(a5)
ffffffffc0201302:	2905                	addiw	s2,s2,1
ffffffffc0201304:	9cb9                	addw	s1,s1,a4
ffffffffc0201306:	fe8796e3          	bne	a5,s0,ffffffffc02012f2 <default_check+0x28>
ffffffffc020130a:	89a6                	mv	s3,s1
ffffffffc020130c:	6df000ef          	jal	ra,ffffffffc02021ea <nr_free_pages>
ffffffffc0201310:	6f351e63          	bne	a0,s3,ffffffffc0201a0c <default_check+0x742>
ffffffffc0201314:	4505                	li	a0,1
ffffffffc0201316:	657000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020131a:	8aaa                	mv	s5,a0
ffffffffc020131c:	42050863          	beqz	a0,ffffffffc020174c <default_check+0x482>
ffffffffc0201320:	4505                	li	a0,1
ffffffffc0201322:	64b000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201326:	89aa                	mv	s3,a0
ffffffffc0201328:	70050263          	beqz	a0,ffffffffc0201a2c <default_check+0x762>
ffffffffc020132c:	4505                	li	a0,1
ffffffffc020132e:	63f000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201332:	8a2a                	mv	s4,a0
ffffffffc0201334:	48050c63          	beqz	a0,ffffffffc02017cc <default_check+0x502>
ffffffffc0201338:	293a8a63          	beq	s5,s3,ffffffffc02015cc <default_check+0x302>
ffffffffc020133c:	28aa8863          	beq	s5,a0,ffffffffc02015cc <default_check+0x302>
ffffffffc0201340:	28a98663          	beq	s3,a0,ffffffffc02015cc <default_check+0x302>
ffffffffc0201344:	000aa783          	lw	a5,0(s5)
ffffffffc0201348:	2a079263          	bnez	a5,ffffffffc02015ec <default_check+0x322>
ffffffffc020134c:	0009a783          	lw	a5,0(s3)
ffffffffc0201350:	28079e63          	bnez	a5,ffffffffc02015ec <default_check+0x322>
ffffffffc0201354:	411c                	lw	a5,0(a0)
ffffffffc0201356:	28079b63          	bnez	a5,ffffffffc02015ec <default_check+0x322>
ffffffffc020135a:	00095797          	auipc	a5,0x95
ffffffffc020135e:	54e7b783          	ld	a5,1358(a5) # ffffffffc02968a8 <pages>
ffffffffc0201362:	40fa8733          	sub	a4,s5,a5
ffffffffc0201366:	0000e617          	auipc	a2,0xe
ffffffffc020136a:	45263603          	ld	a2,1106(a2) # ffffffffc020f7b8 <nbase>
ffffffffc020136e:	8719                	srai	a4,a4,0x6
ffffffffc0201370:	9732                	add	a4,a4,a2
ffffffffc0201372:	00095697          	auipc	a3,0x95
ffffffffc0201376:	52e6b683          	ld	a3,1326(a3) # ffffffffc02968a0 <npage>
ffffffffc020137a:	06b2                	slli	a3,a3,0xc
ffffffffc020137c:	0732                	slli	a4,a4,0xc
ffffffffc020137e:	28d77763          	bgeu	a4,a3,ffffffffc020160c <default_check+0x342>
ffffffffc0201382:	40f98733          	sub	a4,s3,a5
ffffffffc0201386:	8719                	srai	a4,a4,0x6
ffffffffc0201388:	9732                	add	a4,a4,a2
ffffffffc020138a:	0732                	slli	a4,a4,0xc
ffffffffc020138c:	4cd77063          	bgeu	a4,a3,ffffffffc020184c <default_check+0x582>
ffffffffc0201390:	40f507b3          	sub	a5,a0,a5
ffffffffc0201394:	8799                	srai	a5,a5,0x6
ffffffffc0201396:	97b2                	add	a5,a5,a2
ffffffffc0201398:	07b2                	slli	a5,a5,0xc
ffffffffc020139a:	30d7f963          	bgeu	a5,a3,ffffffffc02016ac <default_check+0x3e2>
ffffffffc020139e:	4505                	li	a0,1
ffffffffc02013a0:	00043c03          	ld	s8,0(s0)
ffffffffc02013a4:	00843b83          	ld	s7,8(s0)
ffffffffc02013a8:	01042b03          	lw	s6,16(s0)
ffffffffc02013ac:	e400                	sd	s0,8(s0)
ffffffffc02013ae:	e000                	sd	s0,0(s0)
ffffffffc02013b0:	00090797          	auipc	a5,0x90
ffffffffc02013b4:	4007a423          	sw	zero,1032(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02013b8:	5b5000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02013bc:	2c051863          	bnez	a0,ffffffffc020168c <default_check+0x3c2>
ffffffffc02013c0:	4585                	li	a1,1
ffffffffc02013c2:	8556                	mv	a0,s5
ffffffffc02013c4:	5e7000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02013c8:	4585                	li	a1,1
ffffffffc02013ca:	854e                	mv	a0,s3
ffffffffc02013cc:	5df000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02013d0:	4585                	li	a1,1
ffffffffc02013d2:	8552                	mv	a0,s4
ffffffffc02013d4:	5d7000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02013d8:	4818                	lw	a4,16(s0)
ffffffffc02013da:	478d                	li	a5,3
ffffffffc02013dc:	28f71863          	bne	a4,a5,ffffffffc020166c <default_check+0x3a2>
ffffffffc02013e0:	4505                	li	a0,1
ffffffffc02013e2:	58b000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02013e6:	89aa                	mv	s3,a0
ffffffffc02013e8:	26050263          	beqz	a0,ffffffffc020164c <default_check+0x382>
ffffffffc02013ec:	4505                	li	a0,1
ffffffffc02013ee:	57f000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02013f2:	8aaa                	mv	s5,a0
ffffffffc02013f4:	3a050c63          	beqz	a0,ffffffffc02017ac <default_check+0x4e2>
ffffffffc02013f8:	4505                	li	a0,1
ffffffffc02013fa:	573000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02013fe:	8a2a                	mv	s4,a0
ffffffffc0201400:	38050663          	beqz	a0,ffffffffc020178c <default_check+0x4c2>
ffffffffc0201404:	4505                	li	a0,1
ffffffffc0201406:	567000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020140a:	36051163          	bnez	a0,ffffffffc020176c <default_check+0x4a2>
ffffffffc020140e:	4585                	li	a1,1
ffffffffc0201410:	854e                	mv	a0,s3
ffffffffc0201412:	599000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201416:	641c                	ld	a5,8(s0)
ffffffffc0201418:	20878a63          	beq	a5,s0,ffffffffc020162c <default_check+0x362>
ffffffffc020141c:	4505                	li	a0,1
ffffffffc020141e:	54f000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201422:	30a99563          	bne	s3,a0,ffffffffc020172c <default_check+0x462>
ffffffffc0201426:	4505                	li	a0,1
ffffffffc0201428:	545000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020142c:	2e051063          	bnez	a0,ffffffffc020170c <default_check+0x442>
ffffffffc0201430:	481c                	lw	a5,16(s0)
ffffffffc0201432:	2a079d63          	bnez	a5,ffffffffc02016ec <default_check+0x422>
ffffffffc0201436:	854e                	mv	a0,s3
ffffffffc0201438:	4585                	li	a1,1
ffffffffc020143a:	01843023          	sd	s8,0(s0)
ffffffffc020143e:	01743423          	sd	s7,8(s0)
ffffffffc0201442:	01642823          	sw	s6,16(s0)
ffffffffc0201446:	565000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc020144a:	4585                	li	a1,1
ffffffffc020144c:	8556                	mv	a0,s5
ffffffffc020144e:	55d000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201452:	4585                	li	a1,1
ffffffffc0201454:	8552                	mv	a0,s4
ffffffffc0201456:	555000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc020145a:	4515                	li	a0,5
ffffffffc020145c:	511000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201460:	89aa                	mv	s3,a0
ffffffffc0201462:	26050563          	beqz	a0,ffffffffc02016cc <default_check+0x402>
ffffffffc0201466:	651c                	ld	a5,8(a0)
ffffffffc0201468:	8385                	srli	a5,a5,0x1
ffffffffc020146a:	8b85                	andi	a5,a5,1
ffffffffc020146c:	54079063          	bnez	a5,ffffffffc02019ac <default_check+0x6e2>
ffffffffc0201470:	4505                	li	a0,1
ffffffffc0201472:	00043b03          	ld	s6,0(s0)
ffffffffc0201476:	00843a83          	ld	s5,8(s0)
ffffffffc020147a:	e000                	sd	s0,0(s0)
ffffffffc020147c:	e400                	sd	s0,8(s0)
ffffffffc020147e:	4ef000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201482:	50051563          	bnez	a0,ffffffffc020198c <default_check+0x6c2>
ffffffffc0201486:	08098a13          	addi	s4,s3,128
ffffffffc020148a:	8552                	mv	a0,s4
ffffffffc020148c:	458d                	li	a1,3
ffffffffc020148e:	01042b83          	lw	s7,16(s0)
ffffffffc0201492:	00090797          	auipc	a5,0x90
ffffffffc0201496:	3207a323          	sw	zero,806(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020149a:	511000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc020149e:	4511                	li	a0,4
ffffffffc02014a0:	4cd000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02014a4:	4c051463          	bnez	a0,ffffffffc020196c <default_check+0x6a2>
ffffffffc02014a8:	0889b783          	ld	a5,136(s3)
ffffffffc02014ac:	8385                	srli	a5,a5,0x1
ffffffffc02014ae:	8b85                	andi	a5,a5,1
ffffffffc02014b0:	48078e63          	beqz	a5,ffffffffc020194c <default_check+0x682>
ffffffffc02014b4:	0909a703          	lw	a4,144(s3)
ffffffffc02014b8:	478d                	li	a5,3
ffffffffc02014ba:	48f71963          	bne	a4,a5,ffffffffc020194c <default_check+0x682>
ffffffffc02014be:	450d                	li	a0,3
ffffffffc02014c0:	4ad000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02014c4:	8c2a                	mv	s8,a0
ffffffffc02014c6:	46050363          	beqz	a0,ffffffffc020192c <default_check+0x662>
ffffffffc02014ca:	4505                	li	a0,1
ffffffffc02014cc:	4a1000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02014d0:	42051e63          	bnez	a0,ffffffffc020190c <default_check+0x642>
ffffffffc02014d4:	418a1c63          	bne	s4,s8,ffffffffc02018ec <default_check+0x622>
ffffffffc02014d8:	4585                	li	a1,1
ffffffffc02014da:	854e                	mv	a0,s3
ffffffffc02014dc:	4cf000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02014e0:	458d                	li	a1,3
ffffffffc02014e2:	8552                	mv	a0,s4
ffffffffc02014e4:	4c7000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02014e8:	0089b783          	ld	a5,8(s3)
ffffffffc02014ec:	04098c13          	addi	s8,s3,64
ffffffffc02014f0:	8385                	srli	a5,a5,0x1
ffffffffc02014f2:	8b85                	andi	a5,a5,1
ffffffffc02014f4:	3c078c63          	beqz	a5,ffffffffc02018cc <default_check+0x602>
ffffffffc02014f8:	0109a703          	lw	a4,16(s3)
ffffffffc02014fc:	4785                	li	a5,1
ffffffffc02014fe:	3cf71763          	bne	a4,a5,ffffffffc02018cc <default_check+0x602>
ffffffffc0201502:	008a3783          	ld	a5,8(s4)
ffffffffc0201506:	8385                	srli	a5,a5,0x1
ffffffffc0201508:	8b85                	andi	a5,a5,1
ffffffffc020150a:	3a078163          	beqz	a5,ffffffffc02018ac <default_check+0x5e2>
ffffffffc020150e:	010a2703          	lw	a4,16(s4)
ffffffffc0201512:	478d                	li	a5,3
ffffffffc0201514:	38f71c63          	bne	a4,a5,ffffffffc02018ac <default_check+0x5e2>
ffffffffc0201518:	4505                	li	a0,1
ffffffffc020151a:	453000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020151e:	36a99763          	bne	s3,a0,ffffffffc020188c <default_check+0x5c2>
ffffffffc0201522:	4585                	li	a1,1
ffffffffc0201524:	487000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201528:	4509                	li	a0,2
ffffffffc020152a:	443000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020152e:	32aa1f63          	bne	s4,a0,ffffffffc020186c <default_check+0x5a2>
ffffffffc0201532:	4589                	li	a1,2
ffffffffc0201534:	477000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201538:	4585                	li	a1,1
ffffffffc020153a:	8562                	mv	a0,s8
ffffffffc020153c:	46f000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201540:	4515                	li	a0,5
ffffffffc0201542:	42b000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201546:	89aa                	mv	s3,a0
ffffffffc0201548:	48050263          	beqz	a0,ffffffffc02019cc <default_check+0x702>
ffffffffc020154c:	4505                	li	a0,1
ffffffffc020154e:	41f000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201552:	2c051d63          	bnez	a0,ffffffffc020182c <default_check+0x562>
ffffffffc0201556:	481c                	lw	a5,16(s0)
ffffffffc0201558:	2a079a63          	bnez	a5,ffffffffc020180c <default_check+0x542>
ffffffffc020155c:	4595                	li	a1,5
ffffffffc020155e:	854e                	mv	a0,s3
ffffffffc0201560:	01742823          	sw	s7,16(s0)
ffffffffc0201564:	01643023          	sd	s6,0(s0)
ffffffffc0201568:	01543423          	sd	s5,8(s0)
ffffffffc020156c:	43f000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201570:	641c                	ld	a5,8(s0)
ffffffffc0201572:	00878963          	beq	a5,s0,ffffffffc0201584 <default_check+0x2ba>
ffffffffc0201576:	ff87a703          	lw	a4,-8(a5)
ffffffffc020157a:	679c                	ld	a5,8(a5)
ffffffffc020157c:	397d                	addiw	s2,s2,-1
ffffffffc020157e:	9c99                	subw	s1,s1,a4
ffffffffc0201580:	fe879be3          	bne	a5,s0,ffffffffc0201576 <default_check+0x2ac>
ffffffffc0201584:	26091463          	bnez	s2,ffffffffc02017ec <default_check+0x522>
ffffffffc0201588:	46049263          	bnez	s1,ffffffffc02019ec <default_check+0x722>
ffffffffc020158c:	60a6                	ld	ra,72(sp)
ffffffffc020158e:	6406                	ld	s0,64(sp)
ffffffffc0201590:	74e2                	ld	s1,56(sp)
ffffffffc0201592:	7942                	ld	s2,48(sp)
ffffffffc0201594:	79a2                	ld	s3,40(sp)
ffffffffc0201596:	7a02                	ld	s4,32(sp)
ffffffffc0201598:	6ae2                	ld	s5,24(sp)
ffffffffc020159a:	6b42                	ld	s6,16(sp)
ffffffffc020159c:	6ba2                	ld	s7,8(sp)
ffffffffc020159e:	6c02                	ld	s8,0(sp)
ffffffffc02015a0:	6161                	addi	sp,sp,80
ffffffffc02015a2:	8082                	ret
ffffffffc02015a4:	4981                	li	s3,0
ffffffffc02015a6:	4481                	li	s1,0
ffffffffc02015a8:	4901                	li	s2,0
ffffffffc02015aa:	b38d                	j	ffffffffc020130c <default_check+0x42>
ffffffffc02015ac:	0000b697          	auipc	a3,0xb
ffffffffc02015b0:	b1c68693          	addi	a3,a3,-1252 # ffffffffc020c0c8 <commands+0x950>
ffffffffc02015b4:	0000a617          	auipc	a2,0xa
ffffffffc02015b8:	3d460613          	addi	a2,a2,980 # ffffffffc020b988 <commands+0x210>
ffffffffc02015bc:	0ef00593          	li	a1,239
ffffffffc02015c0:	0000b517          	auipc	a0,0xb
ffffffffc02015c4:	b1850513          	addi	a0,a0,-1256 # ffffffffc020c0d8 <commands+0x960>
ffffffffc02015c8:	ed7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02015cc:	0000b697          	auipc	a3,0xb
ffffffffc02015d0:	ba468693          	addi	a3,a3,-1116 # ffffffffc020c170 <commands+0x9f8>
ffffffffc02015d4:	0000a617          	auipc	a2,0xa
ffffffffc02015d8:	3b460613          	addi	a2,a2,948 # ffffffffc020b988 <commands+0x210>
ffffffffc02015dc:	0bc00593          	li	a1,188
ffffffffc02015e0:	0000b517          	auipc	a0,0xb
ffffffffc02015e4:	af850513          	addi	a0,a0,-1288 # ffffffffc020c0d8 <commands+0x960>
ffffffffc02015e8:	eb7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02015ec:	0000b697          	auipc	a3,0xb
ffffffffc02015f0:	bac68693          	addi	a3,a3,-1108 # ffffffffc020c198 <commands+0xa20>
ffffffffc02015f4:	0000a617          	auipc	a2,0xa
ffffffffc02015f8:	39460613          	addi	a2,a2,916 # ffffffffc020b988 <commands+0x210>
ffffffffc02015fc:	0bd00593          	li	a1,189
ffffffffc0201600:	0000b517          	auipc	a0,0xb
ffffffffc0201604:	ad850513          	addi	a0,a0,-1320 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201608:	e97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020160c:	0000b697          	auipc	a3,0xb
ffffffffc0201610:	bcc68693          	addi	a3,a3,-1076 # ffffffffc020c1d8 <commands+0xa60>
ffffffffc0201614:	0000a617          	auipc	a2,0xa
ffffffffc0201618:	37460613          	addi	a2,a2,884 # ffffffffc020b988 <commands+0x210>
ffffffffc020161c:	0bf00593          	li	a1,191
ffffffffc0201620:	0000b517          	auipc	a0,0xb
ffffffffc0201624:	ab850513          	addi	a0,a0,-1352 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201628:	e77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020162c:	0000b697          	auipc	a3,0xb
ffffffffc0201630:	c3468693          	addi	a3,a3,-972 # ffffffffc020c260 <commands+0xae8>
ffffffffc0201634:	0000a617          	auipc	a2,0xa
ffffffffc0201638:	35460613          	addi	a2,a2,852 # ffffffffc020b988 <commands+0x210>
ffffffffc020163c:	0d800593          	li	a1,216
ffffffffc0201640:	0000b517          	auipc	a0,0xb
ffffffffc0201644:	a9850513          	addi	a0,a0,-1384 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201648:	e57fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020164c:	0000b697          	auipc	a3,0xb
ffffffffc0201650:	ac468693          	addi	a3,a3,-1340 # ffffffffc020c110 <commands+0x998>
ffffffffc0201654:	0000a617          	auipc	a2,0xa
ffffffffc0201658:	33460613          	addi	a2,a2,820 # ffffffffc020b988 <commands+0x210>
ffffffffc020165c:	0d100593          	li	a1,209
ffffffffc0201660:	0000b517          	auipc	a0,0xb
ffffffffc0201664:	a7850513          	addi	a0,a0,-1416 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201668:	e37fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020166c:	0000b697          	auipc	a3,0xb
ffffffffc0201670:	be468693          	addi	a3,a3,-1052 # ffffffffc020c250 <commands+0xad8>
ffffffffc0201674:	0000a617          	auipc	a2,0xa
ffffffffc0201678:	31460613          	addi	a2,a2,788 # ffffffffc020b988 <commands+0x210>
ffffffffc020167c:	0cf00593          	li	a1,207
ffffffffc0201680:	0000b517          	auipc	a0,0xb
ffffffffc0201684:	a5850513          	addi	a0,a0,-1448 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201688:	e17fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020168c:	0000b697          	auipc	a3,0xb
ffffffffc0201690:	bac68693          	addi	a3,a3,-1108 # ffffffffc020c238 <commands+0xac0>
ffffffffc0201694:	0000a617          	auipc	a2,0xa
ffffffffc0201698:	2f460613          	addi	a2,a2,756 # ffffffffc020b988 <commands+0x210>
ffffffffc020169c:	0ca00593          	li	a1,202
ffffffffc02016a0:	0000b517          	auipc	a0,0xb
ffffffffc02016a4:	a3850513          	addi	a0,a0,-1480 # ffffffffc020c0d8 <commands+0x960>
ffffffffc02016a8:	df7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016ac:	0000b697          	auipc	a3,0xb
ffffffffc02016b0:	b6c68693          	addi	a3,a3,-1172 # ffffffffc020c218 <commands+0xaa0>
ffffffffc02016b4:	0000a617          	auipc	a2,0xa
ffffffffc02016b8:	2d460613          	addi	a2,a2,724 # ffffffffc020b988 <commands+0x210>
ffffffffc02016bc:	0c100593          	li	a1,193
ffffffffc02016c0:	0000b517          	auipc	a0,0xb
ffffffffc02016c4:	a1850513          	addi	a0,a0,-1512 # ffffffffc020c0d8 <commands+0x960>
ffffffffc02016c8:	dd7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016cc:	0000b697          	auipc	a3,0xb
ffffffffc02016d0:	bdc68693          	addi	a3,a3,-1060 # ffffffffc020c2a8 <commands+0xb30>
ffffffffc02016d4:	0000a617          	auipc	a2,0xa
ffffffffc02016d8:	2b460613          	addi	a2,a2,692 # ffffffffc020b988 <commands+0x210>
ffffffffc02016dc:	0f700593          	li	a1,247
ffffffffc02016e0:	0000b517          	auipc	a0,0xb
ffffffffc02016e4:	9f850513          	addi	a0,a0,-1544 # ffffffffc020c0d8 <commands+0x960>
ffffffffc02016e8:	db7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016ec:	0000b697          	auipc	a3,0xb
ffffffffc02016f0:	bac68693          	addi	a3,a3,-1108 # ffffffffc020c298 <commands+0xb20>
ffffffffc02016f4:	0000a617          	auipc	a2,0xa
ffffffffc02016f8:	29460613          	addi	a2,a2,660 # ffffffffc020b988 <commands+0x210>
ffffffffc02016fc:	0de00593          	li	a1,222
ffffffffc0201700:	0000b517          	auipc	a0,0xb
ffffffffc0201704:	9d850513          	addi	a0,a0,-1576 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201708:	d97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020170c:	0000b697          	auipc	a3,0xb
ffffffffc0201710:	b2c68693          	addi	a3,a3,-1236 # ffffffffc020c238 <commands+0xac0>
ffffffffc0201714:	0000a617          	auipc	a2,0xa
ffffffffc0201718:	27460613          	addi	a2,a2,628 # ffffffffc020b988 <commands+0x210>
ffffffffc020171c:	0dc00593          	li	a1,220
ffffffffc0201720:	0000b517          	auipc	a0,0xb
ffffffffc0201724:	9b850513          	addi	a0,a0,-1608 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201728:	d77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020172c:	0000b697          	auipc	a3,0xb
ffffffffc0201730:	b4c68693          	addi	a3,a3,-1204 # ffffffffc020c278 <commands+0xb00>
ffffffffc0201734:	0000a617          	auipc	a2,0xa
ffffffffc0201738:	25460613          	addi	a2,a2,596 # ffffffffc020b988 <commands+0x210>
ffffffffc020173c:	0db00593          	li	a1,219
ffffffffc0201740:	0000b517          	auipc	a0,0xb
ffffffffc0201744:	99850513          	addi	a0,a0,-1640 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201748:	d57fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020174c:	0000b697          	auipc	a3,0xb
ffffffffc0201750:	9c468693          	addi	a3,a3,-1596 # ffffffffc020c110 <commands+0x998>
ffffffffc0201754:	0000a617          	auipc	a2,0xa
ffffffffc0201758:	23460613          	addi	a2,a2,564 # ffffffffc020b988 <commands+0x210>
ffffffffc020175c:	0b800593          	li	a1,184
ffffffffc0201760:	0000b517          	auipc	a0,0xb
ffffffffc0201764:	97850513          	addi	a0,a0,-1672 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201768:	d37fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020176c:	0000b697          	auipc	a3,0xb
ffffffffc0201770:	acc68693          	addi	a3,a3,-1332 # ffffffffc020c238 <commands+0xac0>
ffffffffc0201774:	0000a617          	auipc	a2,0xa
ffffffffc0201778:	21460613          	addi	a2,a2,532 # ffffffffc020b988 <commands+0x210>
ffffffffc020177c:	0d500593          	li	a1,213
ffffffffc0201780:	0000b517          	auipc	a0,0xb
ffffffffc0201784:	95850513          	addi	a0,a0,-1704 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201788:	d17fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020178c:	0000b697          	auipc	a3,0xb
ffffffffc0201790:	9c468693          	addi	a3,a3,-1596 # ffffffffc020c150 <commands+0x9d8>
ffffffffc0201794:	0000a617          	auipc	a2,0xa
ffffffffc0201798:	1f460613          	addi	a2,a2,500 # ffffffffc020b988 <commands+0x210>
ffffffffc020179c:	0d300593          	li	a1,211
ffffffffc02017a0:	0000b517          	auipc	a0,0xb
ffffffffc02017a4:	93850513          	addi	a0,a0,-1736 # ffffffffc020c0d8 <commands+0x960>
ffffffffc02017a8:	cf7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017ac:	0000b697          	auipc	a3,0xb
ffffffffc02017b0:	98468693          	addi	a3,a3,-1660 # ffffffffc020c130 <commands+0x9b8>
ffffffffc02017b4:	0000a617          	auipc	a2,0xa
ffffffffc02017b8:	1d460613          	addi	a2,a2,468 # ffffffffc020b988 <commands+0x210>
ffffffffc02017bc:	0d200593          	li	a1,210
ffffffffc02017c0:	0000b517          	auipc	a0,0xb
ffffffffc02017c4:	91850513          	addi	a0,a0,-1768 # ffffffffc020c0d8 <commands+0x960>
ffffffffc02017c8:	cd7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017cc:	0000b697          	auipc	a3,0xb
ffffffffc02017d0:	98468693          	addi	a3,a3,-1660 # ffffffffc020c150 <commands+0x9d8>
ffffffffc02017d4:	0000a617          	auipc	a2,0xa
ffffffffc02017d8:	1b460613          	addi	a2,a2,436 # ffffffffc020b988 <commands+0x210>
ffffffffc02017dc:	0ba00593          	li	a1,186
ffffffffc02017e0:	0000b517          	auipc	a0,0xb
ffffffffc02017e4:	8f850513          	addi	a0,a0,-1800 # ffffffffc020c0d8 <commands+0x960>
ffffffffc02017e8:	cb7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017ec:	0000b697          	auipc	a3,0xb
ffffffffc02017f0:	c0c68693          	addi	a3,a3,-1012 # ffffffffc020c3f8 <commands+0xc80>
ffffffffc02017f4:	0000a617          	auipc	a2,0xa
ffffffffc02017f8:	19460613          	addi	a2,a2,404 # ffffffffc020b988 <commands+0x210>
ffffffffc02017fc:	12400593          	li	a1,292
ffffffffc0201800:	0000b517          	auipc	a0,0xb
ffffffffc0201804:	8d850513          	addi	a0,a0,-1832 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201808:	c97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020180c:	0000b697          	auipc	a3,0xb
ffffffffc0201810:	a8c68693          	addi	a3,a3,-1396 # ffffffffc020c298 <commands+0xb20>
ffffffffc0201814:	0000a617          	auipc	a2,0xa
ffffffffc0201818:	17460613          	addi	a2,a2,372 # ffffffffc020b988 <commands+0x210>
ffffffffc020181c:	11900593          	li	a1,281
ffffffffc0201820:	0000b517          	auipc	a0,0xb
ffffffffc0201824:	8b850513          	addi	a0,a0,-1864 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201828:	c77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020182c:	0000b697          	auipc	a3,0xb
ffffffffc0201830:	a0c68693          	addi	a3,a3,-1524 # ffffffffc020c238 <commands+0xac0>
ffffffffc0201834:	0000a617          	auipc	a2,0xa
ffffffffc0201838:	15460613          	addi	a2,a2,340 # ffffffffc020b988 <commands+0x210>
ffffffffc020183c:	11700593          	li	a1,279
ffffffffc0201840:	0000b517          	auipc	a0,0xb
ffffffffc0201844:	89850513          	addi	a0,a0,-1896 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201848:	c57fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020184c:	0000b697          	auipc	a3,0xb
ffffffffc0201850:	9ac68693          	addi	a3,a3,-1620 # ffffffffc020c1f8 <commands+0xa80>
ffffffffc0201854:	0000a617          	auipc	a2,0xa
ffffffffc0201858:	13460613          	addi	a2,a2,308 # ffffffffc020b988 <commands+0x210>
ffffffffc020185c:	0c000593          	li	a1,192
ffffffffc0201860:	0000b517          	auipc	a0,0xb
ffffffffc0201864:	87850513          	addi	a0,a0,-1928 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201868:	c37fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020186c:	0000b697          	auipc	a3,0xb
ffffffffc0201870:	b4c68693          	addi	a3,a3,-1204 # ffffffffc020c3b8 <commands+0xc40>
ffffffffc0201874:	0000a617          	auipc	a2,0xa
ffffffffc0201878:	11460613          	addi	a2,a2,276 # ffffffffc020b988 <commands+0x210>
ffffffffc020187c:	11100593          	li	a1,273
ffffffffc0201880:	0000b517          	auipc	a0,0xb
ffffffffc0201884:	85850513          	addi	a0,a0,-1960 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201888:	c17fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020188c:	0000b697          	auipc	a3,0xb
ffffffffc0201890:	b0c68693          	addi	a3,a3,-1268 # ffffffffc020c398 <commands+0xc20>
ffffffffc0201894:	0000a617          	auipc	a2,0xa
ffffffffc0201898:	0f460613          	addi	a2,a2,244 # ffffffffc020b988 <commands+0x210>
ffffffffc020189c:	10f00593          	li	a1,271
ffffffffc02018a0:	0000b517          	auipc	a0,0xb
ffffffffc02018a4:	83850513          	addi	a0,a0,-1992 # ffffffffc020c0d8 <commands+0x960>
ffffffffc02018a8:	bf7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018ac:	0000b697          	auipc	a3,0xb
ffffffffc02018b0:	ac468693          	addi	a3,a3,-1340 # ffffffffc020c370 <commands+0xbf8>
ffffffffc02018b4:	0000a617          	auipc	a2,0xa
ffffffffc02018b8:	0d460613          	addi	a2,a2,212 # ffffffffc020b988 <commands+0x210>
ffffffffc02018bc:	10d00593          	li	a1,269
ffffffffc02018c0:	0000b517          	auipc	a0,0xb
ffffffffc02018c4:	81850513          	addi	a0,a0,-2024 # ffffffffc020c0d8 <commands+0x960>
ffffffffc02018c8:	bd7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018cc:	0000b697          	auipc	a3,0xb
ffffffffc02018d0:	a7c68693          	addi	a3,a3,-1412 # ffffffffc020c348 <commands+0xbd0>
ffffffffc02018d4:	0000a617          	auipc	a2,0xa
ffffffffc02018d8:	0b460613          	addi	a2,a2,180 # ffffffffc020b988 <commands+0x210>
ffffffffc02018dc:	10c00593          	li	a1,268
ffffffffc02018e0:	0000a517          	auipc	a0,0xa
ffffffffc02018e4:	7f850513          	addi	a0,a0,2040 # ffffffffc020c0d8 <commands+0x960>
ffffffffc02018e8:	bb7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018ec:	0000b697          	auipc	a3,0xb
ffffffffc02018f0:	a4c68693          	addi	a3,a3,-1460 # ffffffffc020c338 <commands+0xbc0>
ffffffffc02018f4:	0000a617          	auipc	a2,0xa
ffffffffc02018f8:	09460613          	addi	a2,a2,148 # ffffffffc020b988 <commands+0x210>
ffffffffc02018fc:	10700593          	li	a1,263
ffffffffc0201900:	0000a517          	auipc	a0,0xa
ffffffffc0201904:	7d850513          	addi	a0,a0,2008 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201908:	b97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020190c:	0000b697          	auipc	a3,0xb
ffffffffc0201910:	92c68693          	addi	a3,a3,-1748 # ffffffffc020c238 <commands+0xac0>
ffffffffc0201914:	0000a617          	auipc	a2,0xa
ffffffffc0201918:	07460613          	addi	a2,a2,116 # ffffffffc020b988 <commands+0x210>
ffffffffc020191c:	10600593          	li	a1,262
ffffffffc0201920:	0000a517          	auipc	a0,0xa
ffffffffc0201924:	7b850513          	addi	a0,a0,1976 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201928:	b77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020192c:	0000b697          	auipc	a3,0xb
ffffffffc0201930:	9ec68693          	addi	a3,a3,-1556 # ffffffffc020c318 <commands+0xba0>
ffffffffc0201934:	0000a617          	auipc	a2,0xa
ffffffffc0201938:	05460613          	addi	a2,a2,84 # ffffffffc020b988 <commands+0x210>
ffffffffc020193c:	10500593          	li	a1,261
ffffffffc0201940:	0000a517          	auipc	a0,0xa
ffffffffc0201944:	79850513          	addi	a0,a0,1944 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201948:	b57fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020194c:	0000b697          	auipc	a3,0xb
ffffffffc0201950:	99c68693          	addi	a3,a3,-1636 # ffffffffc020c2e8 <commands+0xb70>
ffffffffc0201954:	0000a617          	auipc	a2,0xa
ffffffffc0201958:	03460613          	addi	a2,a2,52 # ffffffffc020b988 <commands+0x210>
ffffffffc020195c:	10400593          	li	a1,260
ffffffffc0201960:	0000a517          	auipc	a0,0xa
ffffffffc0201964:	77850513          	addi	a0,a0,1912 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201968:	b37fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020196c:	0000b697          	auipc	a3,0xb
ffffffffc0201970:	96468693          	addi	a3,a3,-1692 # ffffffffc020c2d0 <commands+0xb58>
ffffffffc0201974:	0000a617          	auipc	a2,0xa
ffffffffc0201978:	01460613          	addi	a2,a2,20 # ffffffffc020b988 <commands+0x210>
ffffffffc020197c:	10300593          	li	a1,259
ffffffffc0201980:	0000a517          	auipc	a0,0xa
ffffffffc0201984:	75850513          	addi	a0,a0,1880 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201988:	b17fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020198c:	0000b697          	auipc	a3,0xb
ffffffffc0201990:	8ac68693          	addi	a3,a3,-1876 # ffffffffc020c238 <commands+0xac0>
ffffffffc0201994:	0000a617          	auipc	a2,0xa
ffffffffc0201998:	ff460613          	addi	a2,a2,-12 # ffffffffc020b988 <commands+0x210>
ffffffffc020199c:	0fd00593          	li	a1,253
ffffffffc02019a0:	0000a517          	auipc	a0,0xa
ffffffffc02019a4:	73850513          	addi	a0,a0,1848 # ffffffffc020c0d8 <commands+0x960>
ffffffffc02019a8:	af7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019ac:	0000b697          	auipc	a3,0xb
ffffffffc02019b0:	90c68693          	addi	a3,a3,-1780 # ffffffffc020c2b8 <commands+0xb40>
ffffffffc02019b4:	0000a617          	auipc	a2,0xa
ffffffffc02019b8:	fd460613          	addi	a2,a2,-44 # ffffffffc020b988 <commands+0x210>
ffffffffc02019bc:	0f800593          	li	a1,248
ffffffffc02019c0:	0000a517          	auipc	a0,0xa
ffffffffc02019c4:	71850513          	addi	a0,a0,1816 # ffffffffc020c0d8 <commands+0x960>
ffffffffc02019c8:	ad7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019cc:	0000b697          	auipc	a3,0xb
ffffffffc02019d0:	a0c68693          	addi	a3,a3,-1524 # ffffffffc020c3d8 <commands+0xc60>
ffffffffc02019d4:	0000a617          	auipc	a2,0xa
ffffffffc02019d8:	fb460613          	addi	a2,a2,-76 # ffffffffc020b988 <commands+0x210>
ffffffffc02019dc:	11600593          	li	a1,278
ffffffffc02019e0:	0000a517          	auipc	a0,0xa
ffffffffc02019e4:	6f850513          	addi	a0,a0,1784 # ffffffffc020c0d8 <commands+0x960>
ffffffffc02019e8:	ab7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019ec:	0000b697          	auipc	a3,0xb
ffffffffc02019f0:	a1c68693          	addi	a3,a3,-1508 # ffffffffc020c408 <commands+0xc90>
ffffffffc02019f4:	0000a617          	auipc	a2,0xa
ffffffffc02019f8:	f9460613          	addi	a2,a2,-108 # ffffffffc020b988 <commands+0x210>
ffffffffc02019fc:	12500593          	li	a1,293
ffffffffc0201a00:	0000a517          	auipc	a0,0xa
ffffffffc0201a04:	6d850513          	addi	a0,a0,1752 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201a08:	a97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a0c:	0000a697          	auipc	a3,0xa
ffffffffc0201a10:	6e468693          	addi	a3,a3,1764 # ffffffffc020c0f0 <commands+0x978>
ffffffffc0201a14:	0000a617          	auipc	a2,0xa
ffffffffc0201a18:	f7460613          	addi	a2,a2,-140 # ffffffffc020b988 <commands+0x210>
ffffffffc0201a1c:	0f200593          	li	a1,242
ffffffffc0201a20:	0000a517          	auipc	a0,0xa
ffffffffc0201a24:	6b850513          	addi	a0,a0,1720 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201a28:	a77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a2c:	0000a697          	auipc	a3,0xa
ffffffffc0201a30:	70468693          	addi	a3,a3,1796 # ffffffffc020c130 <commands+0x9b8>
ffffffffc0201a34:	0000a617          	auipc	a2,0xa
ffffffffc0201a38:	f5460613          	addi	a2,a2,-172 # ffffffffc020b988 <commands+0x210>
ffffffffc0201a3c:	0b900593          	li	a1,185
ffffffffc0201a40:	0000a517          	auipc	a0,0xa
ffffffffc0201a44:	69850513          	addi	a0,a0,1688 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201a48:	a57fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201a4c <default_free_pages>:
ffffffffc0201a4c:	1141                	addi	sp,sp,-16
ffffffffc0201a4e:	e406                	sd	ra,8(sp)
ffffffffc0201a50:	14058463          	beqz	a1,ffffffffc0201b98 <default_free_pages+0x14c>
ffffffffc0201a54:	00659693          	slli	a3,a1,0x6
ffffffffc0201a58:	96aa                	add	a3,a3,a0
ffffffffc0201a5a:	87aa                	mv	a5,a0
ffffffffc0201a5c:	02d50263          	beq	a0,a3,ffffffffc0201a80 <default_free_pages+0x34>
ffffffffc0201a60:	6798                	ld	a4,8(a5)
ffffffffc0201a62:	8b05                	andi	a4,a4,1
ffffffffc0201a64:	10071a63          	bnez	a4,ffffffffc0201b78 <default_free_pages+0x12c>
ffffffffc0201a68:	6798                	ld	a4,8(a5)
ffffffffc0201a6a:	8b09                	andi	a4,a4,2
ffffffffc0201a6c:	10071663          	bnez	a4,ffffffffc0201b78 <default_free_pages+0x12c>
ffffffffc0201a70:	0007b423          	sd	zero,8(a5)
ffffffffc0201a74:	0007a023          	sw	zero,0(a5)
ffffffffc0201a78:	04078793          	addi	a5,a5,64
ffffffffc0201a7c:	fed792e3          	bne	a5,a3,ffffffffc0201a60 <default_free_pages+0x14>
ffffffffc0201a80:	2581                	sext.w	a1,a1
ffffffffc0201a82:	c90c                	sw	a1,16(a0)
ffffffffc0201a84:	00850893          	addi	a7,a0,8
ffffffffc0201a88:	4789                	li	a5,2
ffffffffc0201a8a:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0201a8e:	00090697          	auipc	a3,0x90
ffffffffc0201a92:	d1a68693          	addi	a3,a3,-742 # ffffffffc02917a8 <free_area>
ffffffffc0201a96:	4a98                	lw	a4,16(a3)
ffffffffc0201a98:	669c                	ld	a5,8(a3)
ffffffffc0201a9a:	01850613          	addi	a2,a0,24
ffffffffc0201a9e:	9db9                	addw	a1,a1,a4
ffffffffc0201aa0:	ca8c                	sw	a1,16(a3)
ffffffffc0201aa2:	0ad78463          	beq	a5,a3,ffffffffc0201b4a <default_free_pages+0xfe>
ffffffffc0201aa6:	fe878713          	addi	a4,a5,-24
ffffffffc0201aaa:	0006b803          	ld	a6,0(a3)
ffffffffc0201aae:	4581                	li	a1,0
ffffffffc0201ab0:	00e56a63          	bltu	a0,a4,ffffffffc0201ac4 <default_free_pages+0x78>
ffffffffc0201ab4:	6798                	ld	a4,8(a5)
ffffffffc0201ab6:	04d70c63          	beq	a4,a3,ffffffffc0201b0e <default_free_pages+0xc2>
ffffffffc0201aba:	87ba                	mv	a5,a4
ffffffffc0201abc:	fe878713          	addi	a4,a5,-24
ffffffffc0201ac0:	fee57ae3          	bgeu	a0,a4,ffffffffc0201ab4 <default_free_pages+0x68>
ffffffffc0201ac4:	c199                	beqz	a1,ffffffffc0201aca <default_free_pages+0x7e>
ffffffffc0201ac6:	0106b023          	sd	a6,0(a3)
ffffffffc0201aca:	6398                	ld	a4,0(a5)
ffffffffc0201acc:	e390                	sd	a2,0(a5)
ffffffffc0201ace:	e710                	sd	a2,8(a4)
ffffffffc0201ad0:	f11c                	sd	a5,32(a0)
ffffffffc0201ad2:	ed18                	sd	a4,24(a0)
ffffffffc0201ad4:	00d70d63          	beq	a4,a3,ffffffffc0201aee <default_free_pages+0xa2>
ffffffffc0201ad8:	ff872583          	lw	a1,-8(a4)
ffffffffc0201adc:	fe870613          	addi	a2,a4,-24
ffffffffc0201ae0:	02059813          	slli	a6,a1,0x20
ffffffffc0201ae4:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201ae8:	97b2                	add	a5,a5,a2
ffffffffc0201aea:	02f50c63          	beq	a0,a5,ffffffffc0201b22 <default_free_pages+0xd6>
ffffffffc0201aee:	711c                	ld	a5,32(a0)
ffffffffc0201af0:	00d78c63          	beq	a5,a3,ffffffffc0201b08 <default_free_pages+0xbc>
ffffffffc0201af4:	4910                	lw	a2,16(a0)
ffffffffc0201af6:	fe878693          	addi	a3,a5,-24
ffffffffc0201afa:	02061593          	slli	a1,a2,0x20
ffffffffc0201afe:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201b02:	972a                	add	a4,a4,a0
ffffffffc0201b04:	04e68a63          	beq	a3,a4,ffffffffc0201b58 <default_free_pages+0x10c>
ffffffffc0201b08:	60a2                	ld	ra,8(sp)
ffffffffc0201b0a:	0141                	addi	sp,sp,16
ffffffffc0201b0c:	8082                	ret
ffffffffc0201b0e:	e790                	sd	a2,8(a5)
ffffffffc0201b10:	f114                	sd	a3,32(a0)
ffffffffc0201b12:	6798                	ld	a4,8(a5)
ffffffffc0201b14:	ed1c                	sd	a5,24(a0)
ffffffffc0201b16:	02d70763          	beq	a4,a3,ffffffffc0201b44 <default_free_pages+0xf8>
ffffffffc0201b1a:	8832                	mv	a6,a2
ffffffffc0201b1c:	4585                	li	a1,1
ffffffffc0201b1e:	87ba                	mv	a5,a4
ffffffffc0201b20:	bf71                	j	ffffffffc0201abc <default_free_pages+0x70>
ffffffffc0201b22:	491c                	lw	a5,16(a0)
ffffffffc0201b24:	9dbd                	addw	a1,a1,a5
ffffffffc0201b26:	feb72c23          	sw	a1,-8(a4)
ffffffffc0201b2a:	57f5                	li	a5,-3
ffffffffc0201b2c:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc0201b30:	01853803          	ld	a6,24(a0)
ffffffffc0201b34:	710c                	ld	a1,32(a0)
ffffffffc0201b36:	8532                	mv	a0,a2
ffffffffc0201b38:	00b83423          	sd	a1,8(a6)
ffffffffc0201b3c:	671c                	ld	a5,8(a4)
ffffffffc0201b3e:	0105b023          	sd	a6,0(a1)
ffffffffc0201b42:	b77d                	j	ffffffffc0201af0 <default_free_pages+0xa4>
ffffffffc0201b44:	e290                	sd	a2,0(a3)
ffffffffc0201b46:	873e                	mv	a4,a5
ffffffffc0201b48:	bf41                	j	ffffffffc0201ad8 <default_free_pages+0x8c>
ffffffffc0201b4a:	60a2                	ld	ra,8(sp)
ffffffffc0201b4c:	e390                	sd	a2,0(a5)
ffffffffc0201b4e:	e790                	sd	a2,8(a5)
ffffffffc0201b50:	f11c                	sd	a5,32(a0)
ffffffffc0201b52:	ed1c                	sd	a5,24(a0)
ffffffffc0201b54:	0141                	addi	sp,sp,16
ffffffffc0201b56:	8082                	ret
ffffffffc0201b58:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201b5c:	ff078693          	addi	a3,a5,-16
ffffffffc0201b60:	9e39                	addw	a2,a2,a4
ffffffffc0201b62:	c910                	sw	a2,16(a0)
ffffffffc0201b64:	5775                	li	a4,-3
ffffffffc0201b66:	60e6b02f          	amoand.d	zero,a4,(a3)
ffffffffc0201b6a:	6398                	ld	a4,0(a5)
ffffffffc0201b6c:	679c                	ld	a5,8(a5)
ffffffffc0201b6e:	60a2                	ld	ra,8(sp)
ffffffffc0201b70:	e71c                	sd	a5,8(a4)
ffffffffc0201b72:	e398                	sd	a4,0(a5)
ffffffffc0201b74:	0141                	addi	sp,sp,16
ffffffffc0201b76:	8082                	ret
ffffffffc0201b78:	0000b697          	auipc	a3,0xb
ffffffffc0201b7c:	8a868693          	addi	a3,a3,-1880 # ffffffffc020c420 <commands+0xca8>
ffffffffc0201b80:	0000a617          	auipc	a2,0xa
ffffffffc0201b84:	e0860613          	addi	a2,a2,-504 # ffffffffc020b988 <commands+0x210>
ffffffffc0201b88:	08200593          	li	a1,130
ffffffffc0201b8c:	0000a517          	auipc	a0,0xa
ffffffffc0201b90:	54c50513          	addi	a0,a0,1356 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201b94:	90bfe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201b98:	0000b697          	auipc	a3,0xb
ffffffffc0201b9c:	88068693          	addi	a3,a3,-1920 # ffffffffc020c418 <commands+0xca0>
ffffffffc0201ba0:	0000a617          	auipc	a2,0xa
ffffffffc0201ba4:	de860613          	addi	a2,a2,-536 # ffffffffc020b988 <commands+0x210>
ffffffffc0201ba8:	07f00593          	li	a1,127
ffffffffc0201bac:	0000a517          	auipc	a0,0xa
ffffffffc0201bb0:	52c50513          	addi	a0,a0,1324 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201bb4:	8ebfe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201bb8 <default_alloc_pages>:
ffffffffc0201bb8:	c941                	beqz	a0,ffffffffc0201c48 <default_alloc_pages+0x90>
ffffffffc0201bba:	00090597          	auipc	a1,0x90
ffffffffc0201bbe:	bee58593          	addi	a1,a1,-1042 # ffffffffc02917a8 <free_area>
ffffffffc0201bc2:	0105a803          	lw	a6,16(a1)
ffffffffc0201bc6:	872a                	mv	a4,a0
ffffffffc0201bc8:	02081793          	slli	a5,a6,0x20
ffffffffc0201bcc:	9381                	srli	a5,a5,0x20
ffffffffc0201bce:	00a7ee63          	bltu	a5,a0,ffffffffc0201bea <default_alloc_pages+0x32>
ffffffffc0201bd2:	87ae                	mv	a5,a1
ffffffffc0201bd4:	a801                	j	ffffffffc0201be4 <default_alloc_pages+0x2c>
ffffffffc0201bd6:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201bda:	02069613          	slli	a2,a3,0x20
ffffffffc0201bde:	9201                	srli	a2,a2,0x20
ffffffffc0201be0:	00e67763          	bgeu	a2,a4,ffffffffc0201bee <default_alloc_pages+0x36>
ffffffffc0201be4:	679c                	ld	a5,8(a5)
ffffffffc0201be6:	feb798e3          	bne	a5,a1,ffffffffc0201bd6 <default_alloc_pages+0x1e>
ffffffffc0201bea:	4501                	li	a0,0
ffffffffc0201bec:	8082                	ret
ffffffffc0201bee:	0007b883          	ld	a7,0(a5)
ffffffffc0201bf2:	0087b303          	ld	t1,8(a5)
ffffffffc0201bf6:	fe878513          	addi	a0,a5,-24
ffffffffc0201bfa:	00070e1b          	sext.w	t3,a4
ffffffffc0201bfe:	0068b423          	sd	t1,8(a7) # 10000008 <_binary_bin_sfs_img_size+0xff8ad08>
ffffffffc0201c02:	01133023          	sd	a7,0(t1)
ffffffffc0201c06:	02c77863          	bgeu	a4,a2,ffffffffc0201c36 <default_alloc_pages+0x7e>
ffffffffc0201c0a:	071a                	slli	a4,a4,0x6
ffffffffc0201c0c:	972a                	add	a4,a4,a0
ffffffffc0201c0e:	41c686bb          	subw	a3,a3,t3
ffffffffc0201c12:	cb14                	sw	a3,16(a4)
ffffffffc0201c14:	00870613          	addi	a2,a4,8
ffffffffc0201c18:	4689                	li	a3,2
ffffffffc0201c1a:	40d6302f          	amoor.d	zero,a3,(a2)
ffffffffc0201c1e:	0088b683          	ld	a3,8(a7)
ffffffffc0201c22:	01870613          	addi	a2,a4,24
ffffffffc0201c26:	0105a803          	lw	a6,16(a1)
ffffffffc0201c2a:	e290                	sd	a2,0(a3)
ffffffffc0201c2c:	00c8b423          	sd	a2,8(a7)
ffffffffc0201c30:	f314                	sd	a3,32(a4)
ffffffffc0201c32:	01173c23          	sd	a7,24(a4)
ffffffffc0201c36:	41c8083b          	subw	a6,a6,t3
ffffffffc0201c3a:	0105a823          	sw	a6,16(a1)
ffffffffc0201c3e:	5775                	li	a4,-3
ffffffffc0201c40:	17c1                	addi	a5,a5,-16
ffffffffc0201c42:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0201c46:	8082                	ret
ffffffffc0201c48:	1141                	addi	sp,sp,-16
ffffffffc0201c4a:	0000a697          	auipc	a3,0xa
ffffffffc0201c4e:	7ce68693          	addi	a3,a3,1998 # ffffffffc020c418 <commands+0xca0>
ffffffffc0201c52:	0000a617          	auipc	a2,0xa
ffffffffc0201c56:	d3660613          	addi	a2,a2,-714 # ffffffffc020b988 <commands+0x210>
ffffffffc0201c5a:	06100593          	li	a1,97
ffffffffc0201c5e:	0000a517          	auipc	a0,0xa
ffffffffc0201c62:	47a50513          	addi	a0,a0,1146 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201c66:	e406                	sd	ra,8(sp)
ffffffffc0201c68:	837fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201c6c <default_init_memmap>:
ffffffffc0201c6c:	1141                	addi	sp,sp,-16
ffffffffc0201c6e:	e406                	sd	ra,8(sp)
ffffffffc0201c70:	c5f1                	beqz	a1,ffffffffc0201d3c <default_init_memmap+0xd0>
ffffffffc0201c72:	00659693          	slli	a3,a1,0x6
ffffffffc0201c76:	96aa                	add	a3,a3,a0
ffffffffc0201c78:	87aa                	mv	a5,a0
ffffffffc0201c7a:	00d50f63          	beq	a0,a3,ffffffffc0201c98 <default_init_memmap+0x2c>
ffffffffc0201c7e:	6798                	ld	a4,8(a5)
ffffffffc0201c80:	8b05                	andi	a4,a4,1
ffffffffc0201c82:	cf49                	beqz	a4,ffffffffc0201d1c <default_init_memmap+0xb0>
ffffffffc0201c84:	0007a823          	sw	zero,16(a5)
ffffffffc0201c88:	0007b423          	sd	zero,8(a5)
ffffffffc0201c8c:	0007a023          	sw	zero,0(a5)
ffffffffc0201c90:	04078793          	addi	a5,a5,64
ffffffffc0201c94:	fed795e3          	bne	a5,a3,ffffffffc0201c7e <default_init_memmap+0x12>
ffffffffc0201c98:	2581                	sext.w	a1,a1
ffffffffc0201c9a:	c90c                	sw	a1,16(a0)
ffffffffc0201c9c:	4789                	li	a5,2
ffffffffc0201c9e:	00850713          	addi	a4,a0,8
ffffffffc0201ca2:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0201ca6:	00090697          	auipc	a3,0x90
ffffffffc0201caa:	b0268693          	addi	a3,a3,-1278 # ffffffffc02917a8 <free_area>
ffffffffc0201cae:	4a98                	lw	a4,16(a3)
ffffffffc0201cb0:	669c                	ld	a5,8(a3)
ffffffffc0201cb2:	01850613          	addi	a2,a0,24
ffffffffc0201cb6:	9db9                	addw	a1,a1,a4
ffffffffc0201cb8:	ca8c                	sw	a1,16(a3)
ffffffffc0201cba:	04d78a63          	beq	a5,a3,ffffffffc0201d0e <default_init_memmap+0xa2>
ffffffffc0201cbe:	fe878713          	addi	a4,a5,-24
ffffffffc0201cc2:	0006b803          	ld	a6,0(a3)
ffffffffc0201cc6:	4581                	li	a1,0
ffffffffc0201cc8:	00e56a63          	bltu	a0,a4,ffffffffc0201cdc <default_init_memmap+0x70>
ffffffffc0201ccc:	6798                	ld	a4,8(a5)
ffffffffc0201cce:	02d70263          	beq	a4,a3,ffffffffc0201cf2 <default_init_memmap+0x86>
ffffffffc0201cd2:	87ba                	mv	a5,a4
ffffffffc0201cd4:	fe878713          	addi	a4,a5,-24
ffffffffc0201cd8:	fee57ae3          	bgeu	a0,a4,ffffffffc0201ccc <default_init_memmap+0x60>
ffffffffc0201cdc:	c199                	beqz	a1,ffffffffc0201ce2 <default_init_memmap+0x76>
ffffffffc0201cde:	0106b023          	sd	a6,0(a3)
ffffffffc0201ce2:	6398                	ld	a4,0(a5)
ffffffffc0201ce4:	60a2                	ld	ra,8(sp)
ffffffffc0201ce6:	e390                	sd	a2,0(a5)
ffffffffc0201ce8:	e710                	sd	a2,8(a4)
ffffffffc0201cea:	f11c                	sd	a5,32(a0)
ffffffffc0201cec:	ed18                	sd	a4,24(a0)
ffffffffc0201cee:	0141                	addi	sp,sp,16
ffffffffc0201cf0:	8082                	ret
ffffffffc0201cf2:	e790                	sd	a2,8(a5)
ffffffffc0201cf4:	f114                	sd	a3,32(a0)
ffffffffc0201cf6:	6798                	ld	a4,8(a5)
ffffffffc0201cf8:	ed1c                	sd	a5,24(a0)
ffffffffc0201cfa:	00d70663          	beq	a4,a3,ffffffffc0201d06 <default_init_memmap+0x9a>
ffffffffc0201cfe:	8832                	mv	a6,a2
ffffffffc0201d00:	4585                	li	a1,1
ffffffffc0201d02:	87ba                	mv	a5,a4
ffffffffc0201d04:	bfc1                	j	ffffffffc0201cd4 <default_init_memmap+0x68>
ffffffffc0201d06:	60a2                	ld	ra,8(sp)
ffffffffc0201d08:	e290                	sd	a2,0(a3)
ffffffffc0201d0a:	0141                	addi	sp,sp,16
ffffffffc0201d0c:	8082                	ret
ffffffffc0201d0e:	60a2                	ld	ra,8(sp)
ffffffffc0201d10:	e390                	sd	a2,0(a5)
ffffffffc0201d12:	e790                	sd	a2,8(a5)
ffffffffc0201d14:	f11c                	sd	a5,32(a0)
ffffffffc0201d16:	ed1c                	sd	a5,24(a0)
ffffffffc0201d18:	0141                	addi	sp,sp,16
ffffffffc0201d1a:	8082                	ret
ffffffffc0201d1c:	0000a697          	auipc	a3,0xa
ffffffffc0201d20:	72c68693          	addi	a3,a3,1836 # ffffffffc020c448 <commands+0xcd0>
ffffffffc0201d24:	0000a617          	auipc	a2,0xa
ffffffffc0201d28:	c6460613          	addi	a2,a2,-924 # ffffffffc020b988 <commands+0x210>
ffffffffc0201d2c:	04800593          	li	a1,72
ffffffffc0201d30:	0000a517          	auipc	a0,0xa
ffffffffc0201d34:	3a850513          	addi	a0,a0,936 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201d38:	f66fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201d3c:	0000a697          	auipc	a3,0xa
ffffffffc0201d40:	6dc68693          	addi	a3,a3,1756 # ffffffffc020c418 <commands+0xca0>
ffffffffc0201d44:	0000a617          	auipc	a2,0xa
ffffffffc0201d48:	c4460613          	addi	a2,a2,-956 # ffffffffc020b988 <commands+0x210>
ffffffffc0201d4c:	04500593          	li	a1,69
ffffffffc0201d50:	0000a517          	auipc	a0,0xa
ffffffffc0201d54:	38850513          	addi	a0,a0,904 # ffffffffc020c0d8 <commands+0x960>
ffffffffc0201d58:	f46fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201d5c <slob_free>:
ffffffffc0201d5c:	c94d                	beqz	a0,ffffffffc0201e0e <slob_free+0xb2>
ffffffffc0201d5e:	1141                	addi	sp,sp,-16
ffffffffc0201d60:	e022                	sd	s0,0(sp)
ffffffffc0201d62:	e406                	sd	ra,8(sp)
ffffffffc0201d64:	842a                	mv	s0,a0
ffffffffc0201d66:	e9c1                	bnez	a1,ffffffffc0201df6 <slob_free+0x9a>
ffffffffc0201d68:	100027f3          	csrr	a5,sstatus
ffffffffc0201d6c:	8b89                	andi	a5,a5,2
ffffffffc0201d6e:	4501                	li	a0,0
ffffffffc0201d70:	ebd9                	bnez	a5,ffffffffc0201e06 <slob_free+0xaa>
ffffffffc0201d72:	0008f617          	auipc	a2,0x8f
ffffffffc0201d76:	2de60613          	addi	a2,a2,734 # ffffffffc0291050 <slobfree>
ffffffffc0201d7a:	621c                	ld	a5,0(a2)
ffffffffc0201d7c:	873e                	mv	a4,a5
ffffffffc0201d7e:	679c                	ld	a5,8(a5)
ffffffffc0201d80:	02877a63          	bgeu	a4,s0,ffffffffc0201db4 <slob_free+0x58>
ffffffffc0201d84:	00f46463          	bltu	s0,a5,ffffffffc0201d8c <slob_free+0x30>
ffffffffc0201d88:	fef76ae3          	bltu	a4,a5,ffffffffc0201d7c <slob_free+0x20>
ffffffffc0201d8c:	400c                	lw	a1,0(s0)
ffffffffc0201d8e:	00459693          	slli	a3,a1,0x4
ffffffffc0201d92:	96a2                	add	a3,a3,s0
ffffffffc0201d94:	02d78a63          	beq	a5,a3,ffffffffc0201dc8 <slob_free+0x6c>
ffffffffc0201d98:	4314                	lw	a3,0(a4)
ffffffffc0201d9a:	e41c                	sd	a5,8(s0)
ffffffffc0201d9c:	00469793          	slli	a5,a3,0x4
ffffffffc0201da0:	97ba                	add	a5,a5,a4
ffffffffc0201da2:	02f40e63          	beq	s0,a5,ffffffffc0201dde <slob_free+0x82>
ffffffffc0201da6:	e700                	sd	s0,8(a4)
ffffffffc0201da8:	e218                	sd	a4,0(a2)
ffffffffc0201daa:	e129                	bnez	a0,ffffffffc0201dec <slob_free+0x90>
ffffffffc0201dac:	60a2                	ld	ra,8(sp)
ffffffffc0201dae:	6402                	ld	s0,0(sp)
ffffffffc0201db0:	0141                	addi	sp,sp,16
ffffffffc0201db2:	8082                	ret
ffffffffc0201db4:	fcf764e3          	bltu	a4,a5,ffffffffc0201d7c <slob_free+0x20>
ffffffffc0201db8:	fcf472e3          	bgeu	s0,a5,ffffffffc0201d7c <slob_free+0x20>
ffffffffc0201dbc:	400c                	lw	a1,0(s0)
ffffffffc0201dbe:	00459693          	slli	a3,a1,0x4
ffffffffc0201dc2:	96a2                	add	a3,a3,s0
ffffffffc0201dc4:	fcd79ae3          	bne	a5,a3,ffffffffc0201d98 <slob_free+0x3c>
ffffffffc0201dc8:	4394                	lw	a3,0(a5)
ffffffffc0201dca:	679c                	ld	a5,8(a5)
ffffffffc0201dcc:	9db5                	addw	a1,a1,a3
ffffffffc0201dce:	c00c                	sw	a1,0(s0)
ffffffffc0201dd0:	4314                	lw	a3,0(a4)
ffffffffc0201dd2:	e41c                	sd	a5,8(s0)
ffffffffc0201dd4:	00469793          	slli	a5,a3,0x4
ffffffffc0201dd8:	97ba                	add	a5,a5,a4
ffffffffc0201dda:	fcf416e3          	bne	s0,a5,ffffffffc0201da6 <slob_free+0x4a>
ffffffffc0201dde:	401c                	lw	a5,0(s0)
ffffffffc0201de0:	640c                	ld	a1,8(s0)
ffffffffc0201de2:	e218                	sd	a4,0(a2)
ffffffffc0201de4:	9ebd                	addw	a3,a3,a5
ffffffffc0201de6:	c314                	sw	a3,0(a4)
ffffffffc0201de8:	e70c                	sd	a1,8(a4)
ffffffffc0201dea:	d169                	beqz	a0,ffffffffc0201dac <slob_free+0x50>
ffffffffc0201dec:	6402                	ld	s0,0(sp)
ffffffffc0201dee:	60a2                	ld	ra,8(sp)
ffffffffc0201df0:	0141                	addi	sp,sp,16
ffffffffc0201df2:	e7bfe06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0201df6:	25bd                	addiw	a1,a1,15
ffffffffc0201df8:	8191                	srli	a1,a1,0x4
ffffffffc0201dfa:	c10c                	sw	a1,0(a0)
ffffffffc0201dfc:	100027f3          	csrr	a5,sstatus
ffffffffc0201e00:	8b89                	andi	a5,a5,2
ffffffffc0201e02:	4501                	li	a0,0
ffffffffc0201e04:	d7bd                	beqz	a5,ffffffffc0201d72 <slob_free+0x16>
ffffffffc0201e06:	e6dfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201e0a:	4505                	li	a0,1
ffffffffc0201e0c:	b79d                	j	ffffffffc0201d72 <slob_free+0x16>
ffffffffc0201e0e:	8082                	ret

ffffffffc0201e10 <__slob_get_free_pages.constprop.0>:
ffffffffc0201e10:	4785                	li	a5,1
ffffffffc0201e12:	1141                	addi	sp,sp,-16
ffffffffc0201e14:	00a7953b          	sllw	a0,a5,a0
ffffffffc0201e18:	e406                	sd	ra,8(sp)
ffffffffc0201e1a:	352000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201e1e:	c91d                	beqz	a0,ffffffffc0201e54 <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0201e20:	00095697          	auipc	a3,0x95
ffffffffc0201e24:	a886b683          	ld	a3,-1400(a3) # ffffffffc02968a8 <pages>
ffffffffc0201e28:	8d15                	sub	a0,a0,a3
ffffffffc0201e2a:	8519                	srai	a0,a0,0x6
ffffffffc0201e2c:	0000e697          	auipc	a3,0xe
ffffffffc0201e30:	98c6b683          	ld	a3,-1652(a3) # ffffffffc020f7b8 <nbase>
ffffffffc0201e34:	9536                	add	a0,a0,a3
ffffffffc0201e36:	00c51793          	slli	a5,a0,0xc
ffffffffc0201e3a:	83b1                	srli	a5,a5,0xc
ffffffffc0201e3c:	00095717          	auipc	a4,0x95
ffffffffc0201e40:	a6473703          	ld	a4,-1436(a4) # ffffffffc02968a0 <npage>
ffffffffc0201e44:	0532                	slli	a0,a0,0xc
ffffffffc0201e46:	00e7fa63          	bgeu	a5,a4,ffffffffc0201e5a <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201e4a:	00095697          	auipc	a3,0x95
ffffffffc0201e4e:	a6e6b683          	ld	a3,-1426(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0201e52:	9536                	add	a0,a0,a3
ffffffffc0201e54:	60a2                	ld	ra,8(sp)
ffffffffc0201e56:	0141                	addi	sp,sp,16
ffffffffc0201e58:	8082                	ret
ffffffffc0201e5a:	86aa                	mv	a3,a0
ffffffffc0201e5c:	0000a617          	auipc	a2,0xa
ffffffffc0201e60:	64c60613          	addi	a2,a2,1612 # ffffffffc020c4a8 <default_pmm_manager+0x38>
ffffffffc0201e64:	07100593          	li	a1,113
ffffffffc0201e68:	0000a517          	auipc	a0,0xa
ffffffffc0201e6c:	66850513          	addi	a0,a0,1640 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0201e70:	e2efe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201e74 <slob_alloc.constprop.0>:
ffffffffc0201e74:	1101                	addi	sp,sp,-32
ffffffffc0201e76:	ec06                	sd	ra,24(sp)
ffffffffc0201e78:	e822                	sd	s0,16(sp)
ffffffffc0201e7a:	e426                	sd	s1,8(sp)
ffffffffc0201e7c:	e04a                	sd	s2,0(sp)
ffffffffc0201e7e:	01050713          	addi	a4,a0,16
ffffffffc0201e82:	6785                	lui	a5,0x1
ffffffffc0201e84:	0cf77363          	bgeu	a4,a5,ffffffffc0201f4a <slob_alloc.constprop.0+0xd6>
ffffffffc0201e88:	00f50493          	addi	s1,a0,15
ffffffffc0201e8c:	8091                	srli	s1,s1,0x4
ffffffffc0201e8e:	2481                	sext.w	s1,s1
ffffffffc0201e90:	10002673          	csrr	a2,sstatus
ffffffffc0201e94:	8a09                	andi	a2,a2,2
ffffffffc0201e96:	e25d                	bnez	a2,ffffffffc0201f3c <slob_alloc.constprop.0+0xc8>
ffffffffc0201e98:	0008f917          	auipc	s2,0x8f
ffffffffc0201e9c:	1b890913          	addi	s2,s2,440 # ffffffffc0291050 <slobfree>
ffffffffc0201ea0:	00093683          	ld	a3,0(s2)
ffffffffc0201ea4:	669c                	ld	a5,8(a3)
ffffffffc0201ea6:	4398                	lw	a4,0(a5)
ffffffffc0201ea8:	08975e63          	bge	a4,s1,ffffffffc0201f44 <slob_alloc.constprop.0+0xd0>
ffffffffc0201eac:	00f68b63          	beq	a3,a5,ffffffffc0201ec2 <slob_alloc.constprop.0+0x4e>
ffffffffc0201eb0:	6780                	ld	s0,8(a5)
ffffffffc0201eb2:	4018                	lw	a4,0(s0)
ffffffffc0201eb4:	02975a63          	bge	a4,s1,ffffffffc0201ee8 <slob_alloc.constprop.0+0x74>
ffffffffc0201eb8:	00093683          	ld	a3,0(s2)
ffffffffc0201ebc:	87a2                	mv	a5,s0
ffffffffc0201ebe:	fef699e3          	bne	a3,a5,ffffffffc0201eb0 <slob_alloc.constprop.0+0x3c>
ffffffffc0201ec2:	ee31                	bnez	a2,ffffffffc0201f1e <slob_alloc.constprop.0+0xaa>
ffffffffc0201ec4:	4501                	li	a0,0
ffffffffc0201ec6:	f4bff0ef          	jal	ra,ffffffffc0201e10 <__slob_get_free_pages.constprop.0>
ffffffffc0201eca:	842a                	mv	s0,a0
ffffffffc0201ecc:	cd05                	beqz	a0,ffffffffc0201f04 <slob_alloc.constprop.0+0x90>
ffffffffc0201ece:	6585                	lui	a1,0x1
ffffffffc0201ed0:	e8dff0ef          	jal	ra,ffffffffc0201d5c <slob_free>
ffffffffc0201ed4:	10002673          	csrr	a2,sstatus
ffffffffc0201ed8:	8a09                	andi	a2,a2,2
ffffffffc0201eda:	ee05                	bnez	a2,ffffffffc0201f12 <slob_alloc.constprop.0+0x9e>
ffffffffc0201edc:	00093783          	ld	a5,0(s2)
ffffffffc0201ee0:	6780                	ld	s0,8(a5)
ffffffffc0201ee2:	4018                	lw	a4,0(s0)
ffffffffc0201ee4:	fc974ae3          	blt	a4,s1,ffffffffc0201eb8 <slob_alloc.constprop.0+0x44>
ffffffffc0201ee8:	04e48763          	beq	s1,a4,ffffffffc0201f36 <slob_alloc.constprop.0+0xc2>
ffffffffc0201eec:	00449693          	slli	a3,s1,0x4
ffffffffc0201ef0:	96a2                	add	a3,a3,s0
ffffffffc0201ef2:	e794                	sd	a3,8(a5)
ffffffffc0201ef4:	640c                	ld	a1,8(s0)
ffffffffc0201ef6:	9f05                	subw	a4,a4,s1
ffffffffc0201ef8:	c298                	sw	a4,0(a3)
ffffffffc0201efa:	e68c                	sd	a1,8(a3)
ffffffffc0201efc:	c004                	sw	s1,0(s0)
ffffffffc0201efe:	00f93023          	sd	a5,0(s2)
ffffffffc0201f02:	e20d                	bnez	a2,ffffffffc0201f24 <slob_alloc.constprop.0+0xb0>
ffffffffc0201f04:	60e2                	ld	ra,24(sp)
ffffffffc0201f06:	8522                	mv	a0,s0
ffffffffc0201f08:	6442                	ld	s0,16(sp)
ffffffffc0201f0a:	64a2                	ld	s1,8(sp)
ffffffffc0201f0c:	6902                	ld	s2,0(sp)
ffffffffc0201f0e:	6105                	addi	sp,sp,32
ffffffffc0201f10:	8082                	ret
ffffffffc0201f12:	d61fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201f16:	00093783          	ld	a5,0(s2)
ffffffffc0201f1a:	4605                	li	a2,1
ffffffffc0201f1c:	b7d1                	j	ffffffffc0201ee0 <slob_alloc.constprop.0+0x6c>
ffffffffc0201f1e:	d4ffe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0201f22:	b74d                	j	ffffffffc0201ec4 <slob_alloc.constprop.0+0x50>
ffffffffc0201f24:	d49fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0201f28:	60e2                	ld	ra,24(sp)
ffffffffc0201f2a:	8522                	mv	a0,s0
ffffffffc0201f2c:	6442                	ld	s0,16(sp)
ffffffffc0201f2e:	64a2                	ld	s1,8(sp)
ffffffffc0201f30:	6902                	ld	s2,0(sp)
ffffffffc0201f32:	6105                	addi	sp,sp,32
ffffffffc0201f34:	8082                	ret
ffffffffc0201f36:	6418                	ld	a4,8(s0)
ffffffffc0201f38:	e798                	sd	a4,8(a5)
ffffffffc0201f3a:	b7d1                	j	ffffffffc0201efe <slob_alloc.constprop.0+0x8a>
ffffffffc0201f3c:	d37fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201f40:	4605                	li	a2,1
ffffffffc0201f42:	bf99                	j	ffffffffc0201e98 <slob_alloc.constprop.0+0x24>
ffffffffc0201f44:	843e                	mv	s0,a5
ffffffffc0201f46:	87b6                	mv	a5,a3
ffffffffc0201f48:	b745                	j	ffffffffc0201ee8 <slob_alloc.constprop.0+0x74>
ffffffffc0201f4a:	0000a697          	auipc	a3,0xa
ffffffffc0201f4e:	59668693          	addi	a3,a3,1430 # ffffffffc020c4e0 <default_pmm_manager+0x70>
ffffffffc0201f52:	0000a617          	auipc	a2,0xa
ffffffffc0201f56:	a3660613          	addi	a2,a2,-1482 # ffffffffc020b988 <commands+0x210>
ffffffffc0201f5a:	06300593          	li	a1,99
ffffffffc0201f5e:	0000a517          	auipc	a0,0xa
ffffffffc0201f62:	5a250513          	addi	a0,a0,1442 # ffffffffc020c500 <default_pmm_manager+0x90>
ffffffffc0201f66:	d38fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201f6a <kmalloc_init>:
ffffffffc0201f6a:	1141                	addi	sp,sp,-16
ffffffffc0201f6c:	0000a517          	auipc	a0,0xa
ffffffffc0201f70:	5ac50513          	addi	a0,a0,1452 # ffffffffc020c518 <default_pmm_manager+0xa8>
ffffffffc0201f74:	e406                	sd	ra,8(sp)
ffffffffc0201f76:	a30fe0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0201f7a:	60a2                	ld	ra,8(sp)
ffffffffc0201f7c:	0000a517          	auipc	a0,0xa
ffffffffc0201f80:	5b450513          	addi	a0,a0,1460 # ffffffffc020c530 <default_pmm_manager+0xc0>
ffffffffc0201f84:	0141                	addi	sp,sp,16
ffffffffc0201f86:	a20fe06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0201f8a <kallocated>:
ffffffffc0201f8a:	4501                	li	a0,0
ffffffffc0201f8c:	8082                	ret

ffffffffc0201f8e <kmalloc>:
ffffffffc0201f8e:	1101                	addi	sp,sp,-32
ffffffffc0201f90:	e04a                	sd	s2,0(sp)
ffffffffc0201f92:	6905                	lui	s2,0x1
ffffffffc0201f94:	e822                	sd	s0,16(sp)
ffffffffc0201f96:	ec06                	sd	ra,24(sp)
ffffffffc0201f98:	e426                	sd	s1,8(sp)
ffffffffc0201f9a:	fef90793          	addi	a5,s2,-17 # fef <_binary_bin_swap_img_size-0x6d11>
ffffffffc0201f9e:	842a                	mv	s0,a0
ffffffffc0201fa0:	04a7f963          	bgeu	a5,a0,ffffffffc0201ff2 <kmalloc+0x64>
ffffffffc0201fa4:	4561                	li	a0,24
ffffffffc0201fa6:	ecfff0ef          	jal	ra,ffffffffc0201e74 <slob_alloc.constprop.0>
ffffffffc0201faa:	84aa                	mv	s1,a0
ffffffffc0201fac:	c929                	beqz	a0,ffffffffc0201ffe <kmalloc+0x70>
ffffffffc0201fae:	0004079b          	sext.w	a5,s0
ffffffffc0201fb2:	4501                	li	a0,0
ffffffffc0201fb4:	00f95763          	bge	s2,a5,ffffffffc0201fc2 <kmalloc+0x34>
ffffffffc0201fb8:	6705                	lui	a4,0x1
ffffffffc0201fba:	8785                	srai	a5,a5,0x1
ffffffffc0201fbc:	2505                	addiw	a0,a0,1
ffffffffc0201fbe:	fef74ee3          	blt	a4,a5,ffffffffc0201fba <kmalloc+0x2c>
ffffffffc0201fc2:	c088                	sw	a0,0(s1)
ffffffffc0201fc4:	e4dff0ef          	jal	ra,ffffffffc0201e10 <__slob_get_free_pages.constprop.0>
ffffffffc0201fc8:	e488                	sd	a0,8(s1)
ffffffffc0201fca:	842a                	mv	s0,a0
ffffffffc0201fcc:	c525                	beqz	a0,ffffffffc0202034 <kmalloc+0xa6>
ffffffffc0201fce:	100027f3          	csrr	a5,sstatus
ffffffffc0201fd2:	8b89                	andi	a5,a5,2
ffffffffc0201fd4:	ef8d                	bnez	a5,ffffffffc020200e <kmalloc+0x80>
ffffffffc0201fd6:	00095797          	auipc	a5,0x95
ffffffffc0201fda:	8b278793          	addi	a5,a5,-1870 # ffffffffc0296888 <bigblocks>
ffffffffc0201fde:	6398                	ld	a4,0(a5)
ffffffffc0201fe0:	e384                	sd	s1,0(a5)
ffffffffc0201fe2:	e898                	sd	a4,16(s1)
ffffffffc0201fe4:	60e2                	ld	ra,24(sp)
ffffffffc0201fe6:	8522                	mv	a0,s0
ffffffffc0201fe8:	6442                	ld	s0,16(sp)
ffffffffc0201fea:	64a2                	ld	s1,8(sp)
ffffffffc0201fec:	6902                	ld	s2,0(sp)
ffffffffc0201fee:	6105                	addi	sp,sp,32
ffffffffc0201ff0:	8082                	ret
ffffffffc0201ff2:	0541                	addi	a0,a0,16
ffffffffc0201ff4:	e81ff0ef          	jal	ra,ffffffffc0201e74 <slob_alloc.constprop.0>
ffffffffc0201ff8:	01050413          	addi	s0,a0,16
ffffffffc0201ffc:	f565                	bnez	a0,ffffffffc0201fe4 <kmalloc+0x56>
ffffffffc0201ffe:	4401                	li	s0,0
ffffffffc0202000:	60e2                	ld	ra,24(sp)
ffffffffc0202002:	8522                	mv	a0,s0
ffffffffc0202004:	6442                	ld	s0,16(sp)
ffffffffc0202006:	64a2                	ld	s1,8(sp)
ffffffffc0202008:	6902                	ld	s2,0(sp)
ffffffffc020200a:	6105                	addi	sp,sp,32
ffffffffc020200c:	8082                	ret
ffffffffc020200e:	c65fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202012:	00095797          	auipc	a5,0x95
ffffffffc0202016:	87678793          	addi	a5,a5,-1930 # ffffffffc0296888 <bigblocks>
ffffffffc020201a:	6398                	ld	a4,0(a5)
ffffffffc020201c:	e384                	sd	s1,0(a5)
ffffffffc020201e:	e898                	sd	a4,16(s1)
ffffffffc0202020:	c4dfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202024:	6480                	ld	s0,8(s1)
ffffffffc0202026:	60e2                	ld	ra,24(sp)
ffffffffc0202028:	64a2                	ld	s1,8(sp)
ffffffffc020202a:	8522                	mv	a0,s0
ffffffffc020202c:	6442                	ld	s0,16(sp)
ffffffffc020202e:	6902                	ld	s2,0(sp)
ffffffffc0202030:	6105                	addi	sp,sp,32
ffffffffc0202032:	8082                	ret
ffffffffc0202034:	45e1                	li	a1,24
ffffffffc0202036:	8526                	mv	a0,s1
ffffffffc0202038:	d25ff0ef          	jal	ra,ffffffffc0201d5c <slob_free>
ffffffffc020203c:	b765                	j	ffffffffc0201fe4 <kmalloc+0x56>

ffffffffc020203e <kfree>:
ffffffffc020203e:	c169                	beqz	a0,ffffffffc0202100 <kfree+0xc2>
ffffffffc0202040:	1101                	addi	sp,sp,-32
ffffffffc0202042:	e822                	sd	s0,16(sp)
ffffffffc0202044:	ec06                	sd	ra,24(sp)
ffffffffc0202046:	e426                	sd	s1,8(sp)
ffffffffc0202048:	03451793          	slli	a5,a0,0x34
ffffffffc020204c:	842a                	mv	s0,a0
ffffffffc020204e:	e3d9                	bnez	a5,ffffffffc02020d4 <kfree+0x96>
ffffffffc0202050:	100027f3          	csrr	a5,sstatus
ffffffffc0202054:	8b89                	andi	a5,a5,2
ffffffffc0202056:	e7d9                	bnez	a5,ffffffffc02020e4 <kfree+0xa6>
ffffffffc0202058:	00095797          	auipc	a5,0x95
ffffffffc020205c:	8307b783          	ld	a5,-2000(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0202060:	4601                	li	a2,0
ffffffffc0202062:	cbad                	beqz	a5,ffffffffc02020d4 <kfree+0x96>
ffffffffc0202064:	00095697          	auipc	a3,0x95
ffffffffc0202068:	82468693          	addi	a3,a3,-2012 # ffffffffc0296888 <bigblocks>
ffffffffc020206c:	a021                	j	ffffffffc0202074 <kfree+0x36>
ffffffffc020206e:	01048693          	addi	a3,s1,16
ffffffffc0202072:	c3a5                	beqz	a5,ffffffffc02020d2 <kfree+0x94>
ffffffffc0202074:	6798                	ld	a4,8(a5)
ffffffffc0202076:	84be                	mv	s1,a5
ffffffffc0202078:	6b9c                	ld	a5,16(a5)
ffffffffc020207a:	fe871ae3          	bne	a4,s0,ffffffffc020206e <kfree+0x30>
ffffffffc020207e:	e29c                	sd	a5,0(a3)
ffffffffc0202080:	ee2d                	bnez	a2,ffffffffc02020fa <kfree+0xbc>
ffffffffc0202082:	c02007b7          	lui	a5,0xc0200
ffffffffc0202086:	4098                	lw	a4,0(s1)
ffffffffc0202088:	08f46963          	bltu	s0,a5,ffffffffc020211a <kfree+0xdc>
ffffffffc020208c:	00095697          	auipc	a3,0x95
ffffffffc0202090:	82c6b683          	ld	a3,-2004(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202094:	8c15                	sub	s0,s0,a3
ffffffffc0202096:	8031                	srli	s0,s0,0xc
ffffffffc0202098:	00095797          	auipc	a5,0x95
ffffffffc020209c:	8087b783          	ld	a5,-2040(a5) # ffffffffc02968a0 <npage>
ffffffffc02020a0:	06f47163          	bgeu	s0,a5,ffffffffc0202102 <kfree+0xc4>
ffffffffc02020a4:	0000d517          	auipc	a0,0xd
ffffffffc02020a8:	71453503          	ld	a0,1812(a0) # ffffffffc020f7b8 <nbase>
ffffffffc02020ac:	8c09                	sub	s0,s0,a0
ffffffffc02020ae:	041a                	slli	s0,s0,0x6
ffffffffc02020b0:	00094517          	auipc	a0,0x94
ffffffffc02020b4:	7f853503          	ld	a0,2040(a0) # ffffffffc02968a8 <pages>
ffffffffc02020b8:	4585                	li	a1,1
ffffffffc02020ba:	9522                	add	a0,a0,s0
ffffffffc02020bc:	00e595bb          	sllw	a1,a1,a4
ffffffffc02020c0:	0ea000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02020c4:	6442                	ld	s0,16(sp)
ffffffffc02020c6:	60e2                	ld	ra,24(sp)
ffffffffc02020c8:	8526                	mv	a0,s1
ffffffffc02020ca:	64a2                	ld	s1,8(sp)
ffffffffc02020cc:	45e1                	li	a1,24
ffffffffc02020ce:	6105                	addi	sp,sp,32
ffffffffc02020d0:	b171                	j	ffffffffc0201d5c <slob_free>
ffffffffc02020d2:	e20d                	bnez	a2,ffffffffc02020f4 <kfree+0xb6>
ffffffffc02020d4:	ff040513          	addi	a0,s0,-16
ffffffffc02020d8:	6442                	ld	s0,16(sp)
ffffffffc02020da:	60e2                	ld	ra,24(sp)
ffffffffc02020dc:	64a2                	ld	s1,8(sp)
ffffffffc02020de:	4581                	li	a1,0
ffffffffc02020e0:	6105                	addi	sp,sp,32
ffffffffc02020e2:	b9ad                	j	ffffffffc0201d5c <slob_free>
ffffffffc02020e4:	b8ffe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02020e8:	00094797          	auipc	a5,0x94
ffffffffc02020ec:	7a07b783          	ld	a5,1952(a5) # ffffffffc0296888 <bigblocks>
ffffffffc02020f0:	4605                	li	a2,1
ffffffffc02020f2:	fbad                	bnez	a5,ffffffffc0202064 <kfree+0x26>
ffffffffc02020f4:	b79fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02020f8:	bff1                	j	ffffffffc02020d4 <kfree+0x96>
ffffffffc02020fa:	b73fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02020fe:	b751                	j	ffffffffc0202082 <kfree+0x44>
ffffffffc0202100:	8082                	ret
ffffffffc0202102:	0000a617          	auipc	a2,0xa
ffffffffc0202106:	47660613          	addi	a2,a2,1142 # ffffffffc020c578 <default_pmm_manager+0x108>
ffffffffc020210a:	06900593          	li	a1,105
ffffffffc020210e:	0000a517          	auipc	a0,0xa
ffffffffc0202112:	3c250513          	addi	a0,a0,962 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0202116:	b88fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020211a:	86a2                	mv	a3,s0
ffffffffc020211c:	0000a617          	auipc	a2,0xa
ffffffffc0202120:	43460613          	addi	a2,a2,1076 # ffffffffc020c550 <default_pmm_manager+0xe0>
ffffffffc0202124:	07700593          	li	a1,119
ffffffffc0202128:	0000a517          	auipc	a0,0xa
ffffffffc020212c:	3a850513          	addi	a0,a0,936 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0202130:	b6efe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0202134 <pa2page.part.0>:
ffffffffc0202134:	1141                	addi	sp,sp,-16
ffffffffc0202136:	0000a617          	auipc	a2,0xa
ffffffffc020213a:	44260613          	addi	a2,a2,1090 # ffffffffc020c578 <default_pmm_manager+0x108>
ffffffffc020213e:	06900593          	li	a1,105
ffffffffc0202142:	0000a517          	auipc	a0,0xa
ffffffffc0202146:	38e50513          	addi	a0,a0,910 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc020214a:	e406                	sd	ra,8(sp)
ffffffffc020214c:	b52fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0202150 <pte2page.part.0>:
ffffffffc0202150:	1141                	addi	sp,sp,-16
ffffffffc0202152:	0000a617          	auipc	a2,0xa
ffffffffc0202156:	44660613          	addi	a2,a2,1094 # ffffffffc020c598 <default_pmm_manager+0x128>
ffffffffc020215a:	07f00593          	li	a1,127
ffffffffc020215e:	0000a517          	auipc	a0,0xa
ffffffffc0202162:	37250513          	addi	a0,a0,882 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0202166:	e406                	sd	ra,8(sp)
ffffffffc0202168:	b36fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020216c <alloc_pages>:
ffffffffc020216c:	100027f3          	csrr	a5,sstatus
ffffffffc0202170:	8b89                	andi	a5,a5,2
ffffffffc0202172:	e799                	bnez	a5,ffffffffc0202180 <alloc_pages+0x14>
ffffffffc0202174:	00094797          	auipc	a5,0x94
ffffffffc0202178:	73c7b783          	ld	a5,1852(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020217c:	6f9c                	ld	a5,24(a5)
ffffffffc020217e:	8782                	jr	a5
ffffffffc0202180:	1141                	addi	sp,sp,-16
ffffffffc0202182:	e406                	sd	ra,8(sp)
ffffffffc0202184:	e022                	sd	s0,0(sp)
ffffffffc0202186:	842a                	mv	s0,a0
ffffffffc0202188:	aebfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020218c:	00094797          	auipc	a5,0x94
ffffffffc0202190:	7247b783          	ld	a5,1828(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202194:	6f9c                	ld	a5,24(a5)
ffffffffc0202196:	8522                	mv	a0,s0
ffffffffc0202198:	9782                	jalr	a5
ffffffffc020219a:	842a                	mv	s0,a0
ffffffffc020219c:	ad1fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02021a0:	60a2                	ld	ra,8(sp)
ffffffffc02021a2:	8522                	mv	a0,s0
ffffffffc02021a4:	6402                	ld	s0,0(sp)
ffffffffc02021a6:	0141                	addi	sp,sp,16
ffffffffc02021a8:	8082                	ret

ffffffffc02021aa <free_pages>:
ffffffffc02021aa:	100027f3          	csrr	a5,sstatus
ffffffffc02021ae:	8b89                	andi	a5,a5,2
ffffffffc02021b0:	e799                	bnez	a5,ffffffffc02021be <free_pages+0x14>
ffffffffc02021b2:	00094797          	auipc	a5,0x94
ffffffffc02021b6:	6fe7b783          	ld	a5,1790(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02021ba:	739c                	ld	a5,32(a5)
ffffffffc02021bc:	8782                	jr	a5
ffffffffc02021be:	1101                	addi	sp,sp,-32
ffffffffc02021c0:	ec06                	sd	ra,24(sp)
ffffffffc02021c2:	e822                	sd	s0,16(sp)
ffffffffc02021c4:	e426                	sd	s1,8(sp)
ffffffffc02021c6:	842a                	mv	s0,a0
ffffffffc02021c8:	84ae                	mv	s1,a1
ffffffffc02021ca:	aa9fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02021ce:	00094797          	auipc	a5,0x94
ffffffffc02021d2:	6e27b783          	ld	a5,1762(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02021d6:	739c                	ld	a5,32(a5)
ffffffffc02021d8:	85a6                	mv	a1,s1
ffffffffc02021da:	8522                	mv	a0,s0
ffffffffc02021dc:	9782                	jalr	a5
ffffffffc02021de:	6442                	ld	s0,16(sp)
ffffffffc02021e0:	60e2                	ld	ra,24(sp)
ffffffffc02021e2:	64a2                	ld	s1,8(sp)
ffffffffc02021e4:	6105                	addi	sp,sp,32
ffffffffc02021e6:	a87fe06f          	j	ffffffffc0200c6c <intr_enable>

ffffffffc02021ea <nr_free_pages>:
ffffffffc02021ea:	100027f3          	csrr	a5,sstatus
ffffffffc02021ee:	8b89                	andi	a5,a5,2
ffffffffc02021f0:	e799                	bnez	a5,ffffffffc02021fe <nr_free_pages+0x14>
ffffffffc02021f2:	00094797          	auipc	a5,0x94
ffffffffc02021f6:	6be7b783          	ld	a5,1726(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02021fa:	779c                	ld	a5,40(a5)
ffffffffc02021fc:	8782                	jr	a5
ffffffffc02021fe:	1141                	addi	sp,sp,-16
ffffffffc0202200:	e406                	sd	ra,8(sp)
ffffffffc0202202:	e022                	sd	s0,0(sp)
ffffffffc0202204:	a6ffe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202208:	00094797          	auipc	a5,0x94
ffffffffc020220c:	6a87b783          	ld	a5,1704(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202210:	779c                	ld	a5,40(a5)
ffffffffc0202212:	9782                	jalr	a5
ffffffffc0202214:	842a                	mv	s0,a0
ffffffffc0202216:	a57fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020221a:	60a2                	ld	ra,8(sp)
ffffffffc020221c:	8522                	mv	a0,s0
ffffffffc020221e:	6402                	ld	s0,0(sp)
ffffffffc0202220:	0141                	addi	sp,sp,16
ffffffffc0202222:	8082                	ret

ffffffffc0202224 <get_pte>:
ffffffffc0202224:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202228:	1ff7f793          	andi	a5,a5,511
ffffffffc020222c:	7139                	addi	sp,sp,-64
ffffffffc020222e:	078e                	slli	a5,a5,0x3
ffffffffc0202230:	f426                	sd	s1,40(sp)
ffffffffc0202232:	00f504b3          	add	s1,a0,a5
ffffffffc0202236:	6094                	ld	a3,0(s1)
ffffffffc0202238:	f04a                	sd	s2,32(sp)
ffffffffc020223a:	ec4e                	sd	s3,24(sp)
ffffffffc020223c:	e852                	sd	s4,16(sp)
ffffffffc020223e:	fc06                	sd	ra,56(sp)
ffffffffc0202240:	f822                	sd	s0,48(sp)
ffffffffc0202242:	e456                	sd	s5,8(sp)
ffffffffc0202244:	e05a                	sd	s6,0(sp)
ffffffffc0202246:	0016f793          	andi	a5,a3,1
ffffffffc020224a:	892e                	mv	s2,a1
ffffffffc020224c:	8a32                	mv	s4,a2
ffffffffc020224e:	00094997          	auipc	s3,0x94
ffffffffc0202252:	65298993          	addi	s3,s3,1618 # ffffffffc02968a0 <npage>
ffffffffc0202256:	efbd                	bnez	a5,ffffffffc02022d4 <get_pte+0xb0>
ffffffffc0202258:	14060c63          	beqz	a2,ffffffffc02023b0 <get_pte+0x18c>
ffffffffc020225c:	100027f3          	csrr	a5,sstatus
ffffffffc0202260:	8b89                	andi	a5,a5,2
ffffffffc0202262:	14079963          	bnez	a5,ffffffffc02023b4 <get_pte+0x190>
ffffffffc0202266:	00094797          	auipc	a5,0x94
ffffffffc020226a:	64a7b783          	ld	a5,1610(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020226e:	6f9c                	ld	a5,24(a5)
ffffffffc0202270:	4505                	li	a0,1
ffffffffc0202272:	9782                	jalr	a5
ffffffffc0202274:	842a                	mv	s0,a0
ffffffffc0202276:	12040d63          	beqz	s0,ffffffffc02023b0 <get_pte+0x18c>
ffffffffc020227a:	00094b17          	auipc	s6,0x94
ffffffffc020227e:	62eb0b13          	addi	s6,s6,1582 # ffffffffc02968a8 <pages>
ffffffffc0202282:	000b3503          	ld	a0,0(s6)
ffffffffc0202286:	00080ab7          	lui	s5,0x80
ffffffffc020228a:	00094997          	auipc	s3,0x94
ffffffffc020228e:	61698993          	addi	s3,s3,1558 # ffffffffc02968a0 <npage>
ffffffffc0202292:	40a40533          	sub	a0,s0,a0
ffffffffc0202296:	8519                	srai	a0,a0,0x6
ffffffffc0202298:	9556                	add	a0,a0,s5
ffffffffc020229a:	0009b703          	ld	a4,0(s3)
ffffffffc020229e:	00c51793          	slli	a5,a0,0xc
ffffffffc02022a2:	4685                	li	a3,1
ffffffffc02022a4:	c014                	sw	a3,0(s0)
ffffffffc02022a6:	83b1                	srli	a5,a5,0xc
ffffffffc02022a8:	0532                	slli	a0,a0,0xc
ffffffffc02022aa:	16e7f763          	bgeu	a5,a4,ffffffffc0202418 <get_pte+0x1f4>
ffffffffc02022ae:	00094797          	auipc	a5,0x94
ffffffffc02022b2:	60a7b783          	ld	a5,1546(a5) # ffffffffc02968b8 <va_pa_offset>
ffffffffc02022b6:	6605                	lui	a2,0x1
ffffffffc02022b8:	4581                	li	a1,0
ffffffffc02022ba:	953e                	add	a0,a0,a5
ffffffffc02022bc:	1e4090ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc02022c0:	000b3683          	ld	a3,0(s6)
ffffffffc02022c4:	40d406b3          	sub	a3,s0,a3
ffffffffc02022c8:	8699                	srai	a3,a3,0x6
ffffffffc02022ca:	96d6                	add	a3,a3,s5
ffffffffc02022cc:	06aa                	slli	a3,a3,0xa
ffffffffc02022ce:	0116e693          	ori	a3,a3,17
ffffffffc02022d2:	e094                	sd	a3,0(s1)
ffffffffc02022d4:	77fd                	lui	a5,0xfffff
ffffffffc02022d6:	068a                	slli	a3,a3,0x2
ffffffffc02022d8:	0009b703          	ld	a4,0(s3)
ffffffffc02022dc:	8efd                	and	a3,a3,a5
ffffffffc02022de:	00c6d793          	srli	a5,a3,0xc
ffffffffc02022e2:	10e7ff63          	bgeu	a5,a4,ffffffffc0202400 <get_pte+0x1dc>
ffffffffc02022e6:	00094a97          	auipc	s5,0x94
ffffffffc02022ea:	5d2a8a93          	addi	s5,s5,1490 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02022ee:	000ab403          	ld	s0,0(s5)
ffffffffc02022f2:	01595793          	srli	a5,s2,0x15
ffffffffc02022f6:	1ff7f793          	andi	a5,a5,511
ffffffffc02022fa:	96a2                	add	a3,a3,s0
ffffffffc02022fc:	00379413          	slli	s0,a5,0x3
ffffffffc0202300:	9436                	add	s0,s0,a3
ffffffffc0202302:	6014                	ld	a3,0(s0)
ffffffffc0202304:	0016f793          	andi	a5,a3,1
ffffffffc0202308:	ebad                	bnez	a5,ffffffffc020237a <get_pte+0x156>
ffffffffc020230a:	0a0a0363          	beqz	s4,ffffffffc02023b0 <get_pte+0x18c>
ffffffffc020230e:	100027f3          	csrr	a5,sstatus
ffffffffc0202312:	8b89                	andi	a5,a5,2
ffffffffc0202314:	efcd                	bnez	a5,ffffffffc02023ce <get_pte+0x1aa>
ffffffffc0202316:	00094797          	auipc	a5,0x94
ffffffffc020231a:	59a7b783          	ld	a5,1434(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020231e:	6f9c                	ld	a5,24(a5)
ffffffffc0202320:	4505                	li	a0,1
ffffffffc0202322:	9782                	jalr	a5
ffffffffc0202324:	84aa                	mv	s1,a0
ffffffffc0202326:	c4c9                	beqz	s1,ffffffffc02023b0 <get_pte+0x18c>
ffffffffc0202328:	00094b17          	auipc	s6,0x94
ffffffffc020232c:	580b0b13          	addi	s6,s6,1408 # ffffffffc02968a8 <pages>
ffffffffc0202330:	000b3503          	ld	a0,0(s6)
ffffffffc0202334:	00080a37          	lui	s4,0x80
ffffffffc0202338:	0009b703          	ld	a4,0(s3)
ffffffffc020233c:	40a48533          	sub	a0,s1,a0
ffffffffc0202340:	8519                	srai	a0,a0,0x6
ffffffffc0202342:	9552                	add	a0,a0,s4
ffffffffc0202344:	00c51793          	slli	a5,a0,0xc
ffffffffc0202348:	4685                	li	a3,1
ffffffffc020234a:	c094                	sw	a3,0(s1)
ffffffffc020234c:	83b1                	srli	a5,a5,0xc
ffffffffc020234e:	0532                	slli	a0,a0,0xc
ffffffffc0202350:	0ee7f163          	bgeu	a5,a4,ffffffffc0202432 <get_pte+0x20e>
ffffffffc0202354:	000ab783          	ld	a5,0(s5)
ffffffffc0202358:	6605                	lui	a2,0x1
ffffffffc020235a:	4581                	li	a1,0
ffffffffc020235c:	953e                	add	a0,a0,a5
ffffffffc020235e:	142090ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0202362:	000b3683          	ld	a3,0(s6)
ffffffffc0202366:	40d486b3          	sub	a3,s1,a3
ffffffffc020236a:	8699                	srai	a3,a3,0x6
ffffffffc020236c:	96d2                	add	a3,a3,s4
ffffffffc020236e:	06aa                	slli	a3,a3,0xa
ffffffffc0202370:	0116e693          	ori	a3,a3,17
ffffffffc0202374:	e014                	sd	a3,0(s0)
ffffffffc0202376:	0009b703          	ld	a4,0(s3)
ffffffffc020237a:	068a                	slli	a3,a3,0x2
ffffffffc020237c:	757d                	lui	a0,0xfffff
ffffffffc020237e:	8ee9                	and	a3,a3,a0
ffffffffc0202380:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202384:	06e7f263          	bgeu	a5,a4,ffffffffc02023e8 <get_pte+0x1c4>
ffffffffc0202388:	000ab503          	ld	a0,0(s5)
ffffffffc020238c:	00c95913          	srli	s2,s2,0xc
ffffffffc0202390:	1ff97913          	andi	s2,s2,511
ffffffffc0202394:	96aa                	add	a3,a3,a0
ffffffffc0202396:	00391513          	slli	a0,s2,0x3
ffffffffc020239a:	9536                	add	a0,a0,a3
ffffffffc020239c:	70e2                	ld	ra,56(sp)
ffffffffc020239e:	7442                	ld	s0,48(sp)
ffffffffc02023a0:	74a2                	ld	s1,40(sp)
ffffffffc02023a2:	7902                	ld	s2,32(sp)
ffffffffc02023a4:	69e2                	ld	s3,24(sp)
ffffffffc02023a6:	6a42                	ld	s4,16(sp)
ffffffffc02023a8:	6aa2                	ld	s5,8(sp)
ffffffffc02023aa:	6b02                	ld	s6,0(sp)
ffffffffc02023ac:	6121                	addi	sp,sp,64
ffffffffc02023ae:	8082                	ret
ffffffffc02023b0:	4501                	li	a0,0
ffffffffc02023b2:	b7ed                	j	ffffffffc020239c <get_pte+0x178>
ffffffffc02023b4:	8bffe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02023b8:	00094797          	auipc	a5,0x94
ffffffffc02023bc:	4f87b783          	ld	a5,1272(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02023c0:	6f9c                	ld	a5,24(a5)
ffffffffc02023c2:	4505                	li	a0,1
ffffffffc02023c4:	9782                	jalr	a5
ffffffffc02023c6:	842a                	mv	s0,a0
ffffffffc02023c8:	8a5fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02023cc:	b56d                	j	ffffffffc0202276 <get_pte+0x52>
ffffffffc02023ce:	8a5fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02023d2:	00094797          	auipc	a5,0x94
ffffffffc02023d6:	4de7b783          	ld	a5,1246(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02023da:	6f9c                	ld	a5,24(a5)
ffffffffc02023dc:	4505                	li	a0,1
ffffffffc02023de:	9782                	jalr	a5
ffffffffc02023e0:	84aa                	mv	s1,a0
ffffffffc02023e2:	88bfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02023e6:	b781                	j	ffffffffc0202326 <get_pte+0x102>
ffffffffc02023e8:	0000a617          	auipc	a2,0xa
ffffffffc02023ec:	0c060613          	addi	a2,a2,192 # ffffffffc020c4a8 <default_pmm_manager+0x38>
ffffffffc02023f0:	13200593          	li	a1,306
ffffffffc02023f4:	0000a517          	auipc	a0,0xa
ffffffffc02023f8:	1cc50513          	addi	a0,a0,460 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02023fc:	8a2fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202400:	0000a617          	auipc	a2,0xa
ffffffffc0202404:	0a860613          	addi	a2,a2,168 # ffffffffc020c4a8 <default_pmm_manager+0x38>
ffffffffc0202408:	12500593          	li	a1,293
ffffffffc020240c:	0000a517          	auipc	a0,0xa
ffffffffc0202410:	1b450513          	addi	a0,a0,436 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0202414:	88afe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202418:	86aa                	mv	a3,a0
ffffffffc020241a:	0000a617          	auipc	a2,0xa
ffffffffc020241e:	08e60613          	addi	a2,a2,142 # ffffffffc020c4a8 <default_pmm_manager+0x38>
ffffffffc0202422:	12100593          	li	a1,289
ffffffffc0202426:	0000a517          	auipc	a0,0xa
ffffffffc020242a:	19a50513          	addi	a0,a0,410 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020242e:	870fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202432:	86aa                	mv	a3,a0
ffffffffc0202434:	0000a617          	auipc	a2,0xa
ffffffffc0202438:	07460613          	addi	a2,a2,116 # ffffffffc020c4a8 <default_pmm_manager+0x38>
ffffffffc020243c:	12f00593          	li	a1,303
ffffffffc0202440:	0000a517          	auipc	a0,0xa
ffffffffc0202444:	18050513          	addi	a0,a0,384 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0202448:	856fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020244c <boot_map_segment>:
ffffffffc020244c:	6785                	lui	a5,0x1
ffffffffc020244e:	7139                	addi	sp,sp,-64
ffffffffc0202450:	00d5c833          	xor	a6,a1,a3
ffffffffc0202454:	17fd                	addi	a5,a5,-1
ffffffffc0202456:	fc06                	sd	ra,56(sp)
ffffffffc0202458:	f822                	sd	s0,48(sp)
ffffffffc020245a:	f426                	sd	s1,40(sp)
ffffffffc020245c:	f04a                	sd	s2,32(sp)
ffffffffc020245e:	ec4e                	sd	s3,24(sp)
ffffffffc0202460:	e852                	sd	s4,16(sp)
ffffffffc0202462:	e456                	sd	s5,8(sp)
ffffffffc0202464:	00f87833          	and	a6,a6,a5
ffffffffc0202468:	08081563          	bnez	a6,ffffffffc02024f2 <boot_map_segment+0xa6>
ffffffffc020246c:	00f5f4b3          	and	s1,a1,a5
ffffffffc0202470:	963e                	add	a2,a2,a5
ffffffffc0202472:	94b2                	add	s1,s1,a2
ffffffffc0202474:	797d                	lui	s2,0xfffff
ffffffffc0202476:	80b1                	srli	s1,s1,0xc
ffffffffc0202478:	0125f5b3          	and	a1,a1,s2
ffffffffc020247c:	0126f6b3          	and	a3,a3,s2
ffffffffc0202480:	c0a1                	beqz	s1,ffffffffc02024c0 <boot_map_segment+0x74>
ffffffffc0202482:	00176713          	ori	a4,a4,1
ffffffffc0202486:	04b2                	slli	s1,s1,0xc
ffffffffc0202488:	02071993          	slli	s3,a4,0x20
ffffffffc020248c:	8a2a                	mv	s4,a0
ffffffffc020248e:	842e                	mv	s0,a1
ffffffffc0202490:	94ae                	add	s1,s1,a1
ffffffffc0202492:	40b68933          	sub	s2,a3,a1
ffffffffc0202496:	0209d993          	srli	s3,s3,0x20
ffffffffc020249a:	6a85                	lui	s5,0x1
ffffffffc020249c:	4605                	li	a2,1
ffffffffc020249e:	85a2                	mv	a1,s0
ffffffffc02024a0:	8552                	mv	a0,s4
ffffffffc02024a2:	d83ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc02024a6:	008907b3          	add	a5,s2,s0
ffffffffc02024aa:	c505                	beqz	a0,ffffffffc02024d2 <boot_map_segment+0x86>
ffffffffc02024ac:	83b1                	srli	a5,a5,0xc
ffffffffc02024ae:	07aa                	slli	a5,a5,0xa
ffffffffc02024b0:	0137e7b3          	or	a5,a5,s3
ffffffffc02024b4:	0017e793          	ori	a5,a5,1
ffffffffc02024b8:	e11c                	sd	a5,0(a0)
ffffffffc02024ba:	9456                	add	s0,s0,s5
ffffffffc02024bc:	fe8490e3          	bne	s1,s0,ffffffffc020249c <boot_map_segment+0x50>
ffffffffc02024c0:	70e2                	ld	ra,56(sp)
ffffffffc02024c2:	7442                	ld	s0,48(sp)
ffffffffc02024c4:	74a2                	ld	s1,40(sp)
ffffffffc02024c6:	7902                	ld	s2,32(sp)
ffffffffc02024c8:	69e2                	ld	s3,24(sp)
ffffffffc02024ca:	6a42                	ld	s4,16(sp)
ffffffffc02024cc:	6aa2                	ld	s5,8(sp)
ffffffffc02024ce:	6121                	addi	sp,sp,64
ffffffffc02024d0:	8082                	ret
ffffffffc02024d2:	0000a697          	auipc	a3,0xa
ffffffffc02024d6:	11668693          	addi	a3,a3,278 # ffffffffc020c5e8 <default_pmm_manager+0x178>
ffffffffc02024da:	00009617          	auipc	a2,0x9
ffffffffc02024de:	4ae60613          	addi	a2,a2,1198 # ffffffffc020b988 <commands+0x210>
ffffffffc02024e2:	09c00593          	li	a1,156
ffffffffc02024e6:	0000a517          	auipc	a0,0xa
ffffffffc02024ea:	0da50513          	addi	a0,a0,218 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02024ee:	fb1fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02024f2:	0000a697          	auipc	a3,0xa
ffffffffc02024f6:	0de68693          	addi	a3,a3,222 # ffffffffc020c5d0 <default_pmm_manager+0x160>
ffffffffc02024fa:	00009617          	auipc	a2,0x9
ffffffffc02024fe:	48e60613          	addi	a2,a2,1166 # ffffffffc020b988 <commands+0x210>
ffffffffc0202502:	09500593          	li	a1,149
ffffffffc0202506:	0000a517          	auipc	a0,0xa
ffffffffc020250a:	0ba50513          	addi	a0,a0,186 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020250e:	f91fd0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0202512 <get_page>:
ffffffffc0202512:	1141                	addi	sp,sp,-16
ffffffffc0202514:	e022                	sd	s0,0(sp)
ffffffffc0202516:	8432                	mv	s0,a2
ffffffffc0202518:	4601                	li	a2,0
ffffffffc020251a:	e406                	sd	ra,8(sp)
ffffffffc020251c:	d09ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202520:	c011                	beqz	s0,ffffffffc0202524 <get_page+0x12>
ffffffffc0202522:	e008                	sd	a0,0(s0)
ffffffffc0202524:	c511                	beqz	a0,ffffffffc0202530 <get_page+0x1e>
ffffffffc0202526:	611c                	ld	a5,0(a0)
ffffffffc0202528:	4501                	li	a0,0
ffffffffc020252a:	0017f713          	andi	a4,a5,1
ffffffffc020252e:	e709                	bnez	a4,ffffffffc0202538 <get_page+0x26>
ffffffffc0202530:	60a2                	ld	ra,8(sp)
ffffffffc0202532:	6402                	ld	s0,0(sp)
ffffffffc0202534:	0141                	addi	sp,sp,16
ffffffffc0202536:	8082                	ret
ffffffffc0202538:	078a                	slli	a5,a5,0x2
ffffffffc020253a:	83b1                	srli	a5,a5,0xc
ffffffffc020253c:	00094717          	auipc	a4,0x94
ffffffffc0202540:	36473703          	ld	a4,868(a4) # ffffffffc02968a0 <npage>
ffffffffc0202544:	00e7ff63          	bgeu	a5,a4,ffffffffc0202562 <get_page+0x50>
ffffffffc0202548:	60a2                	ld	ra,8(sp)
ffffffffc020254a:	6402                	ld	s0,0(sp)
ffffffffc020254c:	fff80537          	lui	a0,0xfff80
ffffffffc0202550:	97aa                	add	a5,a5,a0
ffffffffc0202552:	079a                	slli	a5,a5,0x6
ffffffffc0202554:	00094517          	auipc	a0,0x94
ffffffffc0202558:	35453503          	ld	a0,852(a0) # ffffffffc02968a8 <pages>
ffffffffc020255c:	953e                	add	a0,a0,a5
ffffffffc020255e:	0141                	addi	sp,sp,16
ffffffffc0202560:	8082                	ret
ffffffffc0202562:	bd3ff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>

ffffffffc0202566 <unmap_range>:
ffffffffc0202566:	7159                	addi	sp,sp,-112
ffffffffc0202568:	00c5e7b3          	or	a5,a1,a2
ffffffffc020256c:	f486                	sd	ra,104(sp)
ffffffffc020256e:	f0a2                	sd	s0,96(sp)
ffffffffc0202570:	eca6                	sd	s1,88(sp)
ffffffffc0202572:	e8ca                	sd	s2,80(sp)
ffffffffc0202574:	e4ce                	sd	s3,72(sp)
ffffffffc0202576:	e0d2                	sd	s4,64(sp)
ffffffffc0202578:	fc56                	sd	s5,56(sp)
ffffffffc020257a:	f85a                	sd	s6,48(sp)
ffffffffc020257c:	f45e                	sd	s7,40(sp)
ffffffffc020257e:	f062                	sd	s8,32(sp)
ffffffffc0202580:	ec66                	sd	s9,24(sp)
ffffffffc0202582:	e86a                	sd	s10,16(sp)
ffffffffc0202584:	17d2                	slli	a5,a5,0x34
ffffffffc0202586:	e3ed                	bnez	a5,ffffffffc0202668 <unmap_range+0x102>
ffffffffc0202588:	002007b7          	lui	a5,0x200
ffffffffc020258c:	842e                	mv	s0,a1
ffffffffc020258e:	0ef5ed63          	bltu	a1,a5,ffffffffc0202688 <unmap_range+0x122>
ffffffffc0202592:	8932                	mv	s2,a2
ffffffffc0202594:	0ec5fa63          	bgeu	a1,a2,ffffffffc0202688 <unmap_range+0x122>
ffffffffc0202598:	4785                	li	a5,1
ffffffffc020259a:	07fe                	slli	a5,a5,0x1f
ffffffffc020259c:	0ec7e663          	bltu	a5,a2,ffffffffc0202688 <unmap_range+0x122>
ffffffffc02025a0:	89aa                	mv	s3,a0
ffffffffc02025a2:	6a05                	lui	s4,0x1
ffffffffc02025a4:	00094c97          	auipc	s9,0x94
ffffffffc02025a8:	2fcc8c93          	addi	s9,s9,764 # ffffffffc02968a0 <npage>
ffffffffc02025ac:	00094c17          	auipc	s8,0x94
ffffffffc02025b0:	2fcc0c13          	addi	s8,s8,764 # ffffffffc02968a8 <pages>
ffffffffc02025b4:	fff80bb7          	lui	s7,0xfff80
ffffffffc02025b8:	00094d17          	auipc	s10,0x94
ffffffffc02025bc:	2f8d0d13          	addi	s10,s10,760 # ffffffffc02968b0 <pmm_manager>
ffffffffc02025c0:	00200b37          	lui	s6,0x200
ffffffffc02025c4:	ffe00ab7          	lui	s5,0xffe00
ffffffffc02025c8:	4601                	li	a2,0
ffffffffc02025ca:	85a2                	mv	a1,s0
ffffffffc02025cc:	854e                	mv	a0,s3
ffffffffc02025ce:	c57ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc02025d2:	84aa                	mv	s1,a0
ffffffffc02025d4:	cd29                	beqz	a0,ffffffffc020262e <unmap_range+0xc8>
ffffffffc02025d6:	611c                	ld	a5,0(a0)
ffffffffc02025d8:	e395                	bnez	a5,ffffffffc02025fc <unmap_range+0x96>
ffffffffc02025da:	9452                	add	s0,s0,s4
ffffffffc02025dc:	ff2466e3          	bltu	s0,s2,ffffffffc02025c8 <unmap_range+0x62>
ffffffffc02025e0:	70a6                	ld	ra,104(sp)
ffffffffc02025e2:	7406                	ld	s0,96(sp)
ffffffffc02025e4:	64e6                	ld	s1,88(sp)
ffffffffc02025e6:	6946                	ld	s2,80(sp)
ffffffffc02025e8:	69a6                	ld	s3,72(sp)
ffffffffc02025ea:	6a06                	ld	s4,64(sp)
ffffffffc02025ec:	7ae2                	ld	s5,56(sp)
ffffffffc02025ee:	7b42                	ld	s6,48(sp)
ffffffffc02025f0:	7ba2                	ld	s7,40(sp)
ffffffffc02025f2:	7c02                	ld	s8,32(sp)
ffffffffc02025f4:	6ce2                	ld	s9,24(sp)
ffffffffc02025f6:	6d42                	ld	s10,16(sp)
ffffffffc02025f8:	6165                	addi	sp,sp,112
ffffffffc02025fa:	8082                	ret
ffffffffc02025fc:	0017f713          	andi	a4,a5,1
ffffffffc0202600:	df69                	beqz	a4,ffffffffc02025da <unmap_range+0x74>
ffffffffc0202602:	000cb703          	ld	a4,0(s9)
ffffffffc0202606:	078a                	slli	a5,a5,0x2
ffffffffc0202608:	83b1                	srli	a5,a5,0xc
ffffffffc020260a:	08e7ff63          	bgeu	a5,a4,ffffffffc02026a8 <unmap_range+0x142>
ffffffffc020260e:	000c3503          	ld	a0,0(s8)
ffffffffc0202612:	97de                	add	a5,a5,s7
ffffffffc0202614:	079a                	slli	a5,a5,0x6
ffffffffc0202616:	953e                	add	a0,a0,a5
ffffffffc0202618:	411c                	lw	a5,0(a0)
ffffffffc020261a:	fff7871b          	addiw	a4,a5,-1
ffffffffc020261e:	c118                	sw	a4,0(a0)
ffffffffc0202620:	cf11                	beqz	a4,ffffffffc020263c <unmap_range+0xd6>
ffffffffc0202622:	0004b023          	sd	zero,0(s1)
ffffffffc0202626:	12040073          	sfence.vma	s0
ffffffffc020262a:	9452                	add	s0,s0,s4
ffffffffc020262c:	bf45                	j	ffffffffc02025dc <unmap_range+0x76>
ffffffffc020262e:	945a                	add	s0,s0,s6
ffffffffc0202630:	01547433          	and	s0,s0,s5
ffffffffc0202634:	d455                	beqz	s0,ffffffffc02025e0 <unmap_range+0x7a>
ffffffffc0202636:	f92469e3          	bltu	s0,s2,ffffffffc02025c8 <unmap_range+0x62>
ffffffffc020263a:	b75d                	j	ffffffffc02025e0 <unmap_range+0x7a>
ffffffffc020263c:	100027f3          	csrr	a5,sstatus
ffffffffc0202640:	8b89                	andi	a5,a5,2
ffffffffc0202642:	e799                	bnez	a5,ffffffffc0202650 <unmap_range+0xea>
ffffffffc0202644:	000d3783          	ld	a5,0(s10)
ffffffffc0202648:	4585                	li	a1,1
ffffffffc020264a:	739c                	ld	a5,32(a5)
ffffffffc020264c:	9782                	jalr	a5
ffffffffc020264e:	bfd1                	j	ffffffffc0202622 <unmap_range+0xbc>
ffffffffc0202650:	e42a                	sd	a0,8(sp)
ffffffffc0202652:	e20fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202656:	000d3783          	ld	a5,0(s10)
ffffffffc020265a:	6522                	ld	a0,8(sp)
ffffffffc020265c:	4585                	li	a1,1
ffffffffc020265e:	739c                	ld	a5,32(a5)
ffffffffc0202660:	9782                	jalr	a5
ffffffffc0202662:	e0afe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202666:	bf75                	j	ffffffffc0202622 <unmap_range+0xbc>
ffffffffc0202668:	0000a697          	auipc	a3,0xa
ffffffffc020266c:	f9068693          	addi	a3,a3,-112 # ffffffffc020c5f8 <default_pmm_manager+0x188>
ffffffffc0202670:	00009617          	auipc	a2,0x9
ffffffffc0202674:	31860613          	addi	a2,a2,792 # ffffffffc020b988 <commands+0x210>
ffffffffc0202678:	15a00593          	li	a1,346
ffffffffc020267c:	0000a517          	auipc	a0,0xa
ffffffffc0202680:	f4450513          	addi	a0,a0,-188 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0202684:	e1bfd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202688:	0000a697          	auipc	a3,0xa
ffffffffc020268c:	fa068693          	addi	a3,a3,-96 # ffffffffc020c628 <default_pmm_manager+0x1b8>
ffffffffc0202690:	00009617          	auipc	a2,0x9
ffffffffc0202694:	2f860613          	addi	a2,a2,760 # ffffffffc020b988 <commands+0x210>
ffffffffc0202698:	15b00593          	li	a1,347
ffffffffc020269c:	0000a517          	auipc	a0,0xa
ffffffffc02026a0:	f2450513          	addi	a0,a0,-220 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02026a4:	dfbfd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02026a8:	a8dff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>

ffffffffc02026ac <exit_range>:
ffffffffc02026ac:	7119                	addi	sp,sp,-128
ffffffffc02026ae:	00c5e7b3          	or	a5,a1,a2
ffffffffc02026b2:	fc86                	sd	ra,120(sp)
ffffffffc02026b4:	f8a2                	sd	s0,112(sp)
ffffffffc02026b6:	f4a6                	sd	s1,104(sp)
ffffffffc02026b8:	f0ca                	sd	s2,96(sp)
ffffffffc02026ba:	ecce                	sd	s3,88(sp)
ffffffffc02026bc:	e8d2                	sd	s4,80(sp)
ffffffffc02026be:	e4d6                	sd	s5,72(sp)
ffffffffc02026c0:	e0da                	sd	s6,64(sp)
ffffffffc02026c2:	fc5e                	sd	s7,56(sp)
ffffffffc02026c4:	f862                	sd	s8,48(sp)
ffffffffc02026c6:	f466                	sd	s9,40(sp)
ffffffffc02026c8:	f06a                	sd	s10,32(sp)
ffffffffc02026ca:	ec6e                	sd	s11,24(sp)
ffffffffc02026cc:	17d2                	slli	a5,a5,0x34
ffffffffc02026ce:	20079a63          	bnez	a5,ffffffffc02028e2 <exit_range+0x236>
ffffffffc02026d2:	002007b7          	lui	a5,0x200
ffffffffc02026d6:	24f5e463          	bltu	a1,a5,ffffffffc020291e <exit_range+0x272>
ffffffffc02026da:	8ab2                	mv	s5,a2
ffffffffc02026dc:	24c5f163          	bgeu	a1,a2,ffffffffc020291e <exit_range+0x272>
ffffffffc02026e0:	4785                	li	a5,1
ffffffffc02026e2:	07fe                	slli	a5,a5,0x1f
ffffffffc02026e4:	22c7ed63          	bltu	a5,a2,ffffffffc020291e <exit_range+0x272>
ffffffffc02026e8:	c00009b7          	lui	s3,0xc0000
ffffffffc02026ec:	0135f9b3          	and	s3,a1,s3
ffffffffc02026f0:	ffe00937          	lui	s2,0xffe00
ffffffffc02026f4:	400007b7          	lui	a5,0x40000
ffffffffc02026f8:	5cfd                	li	s9,-1
ffffffffc02026fa:	8c2a                	mv	s8,a0
ffffffffc02026fc:	0125f933          	and	s2,a1,s2
ffffffffc0202700:	99be                	add	s3,s3,a5
ffffffffc0202702:	00094d17          	auipc	s10,0x94
ffffffffc0202706:	19ed0d13          	addi	s10,s10,414 # ffffffffc02968a0 <npage>
ffffffffc020270a:	00ccdc93          	srli	s9,s9,0xc
ffffffffc020270e:	00094717          	auipc	a4,0x94
ffffffffc0202712:	19a70713          	addi	a4,a4,410 # ffffffffc02968a8 <pages>
ffffffffc0202716:	00094d97          	auipc	s11,0x94
ffffffffc020271a:	19ad8d93          	addi	s11,s11,410 # ffffffffc02968b0 <pmm_manager>
ffffffffc020271e:	c0000437          	lui	s0,0xc0000
ffffffffc0202722:	944e                	add	s0,s0,s3
ffffffffc0202724:	8079                	srli	s0,s0,0x1e
ffffffffc0202726:	1ff47413          	andi	s0,s0,511
ffffffffc020272a:	040e                	slli	s0,s0,0x3
ffffffffc020272c:	9462                	add	s0,s0,s8
ffffffffc020272e:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc0202732:	001a7793          	andi	a5,s4,1
ffffffffc0202736:	eb99                	bnez	a5,ffffffffc020274c <exit_range+0xa0>
ffffffffc0202738:	12098463          	beqz	s3,ffffffffc0202860 <exit_range+0x1b4>
ffffffffc020273c:	400007b7          	lui	a5,0x40000
ffffffffc0202740:	97ce                	add	a5,a5,s3
ffffffffc0202742:	894e                	mv	s2,s3
ffffffffc0202744:	1159fe63          	bgeu	s3,s5,ffffffffc0202860 <exit_range+0x1b4>
ffffffffc0202748:	89be                	mv	s3,a5
ffffffffc020274a:	bfd1                	j	ffffffffc020271e <exit_range+0x72>
ffffffffc020274c:	000d3783          	ld	a5,0(s10)
ffffffffc0202750:	0a0a                	slli	s4,s4,0x2
ffffffffc0202752:	00ca5a13          	srli	s4,s4,0xc
ffffffffc0202756:	1cfa7263          	bgeu	s4,a5,ffffffffc020291a <exit_range+0x26e>
ffffffffc020275a:	fff80637          	lui	a2,0xfff80
ffffffffc020275e:	9652                	add	a2,a2,s4
ffffffffc0202760:	000806b7          	lui	a3,0x80
ffffffffc0202764:	96b2                	add	a3,a3,a2
ffffffffc0202766:	0196f5b3          	and	a1,a3,s9
ffffffffc020276a:	061a                	slli	a2,a2,0x6
ffffffffc020276c:	06b2                	slli	a3,a3,0xc
ffffffffc020276e:	18f5fa63          	bgeu	a1,a5,ffffffffc0202902 <exit_range+0x256>
ffffffffc0202772:	00094817          	auipc	a6,0x94
ffffffffc0202776:	14680813          	addi	a6,a6,326 # ffffffffc02968b8 <va_pa_offset>
ffffffffc020277a:	00083b03          	ld	s6,0(a6)
ffffffffc020277e:	4b85                	li	s7,1
ffffffffc0202780:	fff80e37          	lui	t3,0xfff80
ffffffffc0202784:	9b36                	add	s6,s6,a3
ffffffffc0202786:	00080337          	lui	t1,0x80
ffffffffc020278a:	6885                	lui	a7,0x1
ffffffffc020278c:	a819                	j	ffffffffc02027a2 <exit_range+0xf6>
ffffffffc020278e:	4b81                	li	s7,0
ffffffffc0202790:	002007b7          	lui	a5,0x200
ffffffffc0202794:	993e                	add	s2,s2,a5
ffffffffc0202796:	08090c63          	beqz	s2,ffffffffc020282e <exit_range+0x182>
ffffffffc020279a:	09397a63          	bgeu	s2,s3,ffffffffc020282e <exit_range+0x182>
ffffffffc020279e:	0f597063          	bgeu	s2,s5,ffffffffc020287e <exit_range+0x1d2>
ffffffffc02027a2:	01595493          	srli	s1,s2,0x15
ffffffffc02027a6:	1ff4f493          	andi	s1,s1,511
ffffffffc02027aa:	048e                	slli	s1,s1,0x3
ffffffffc02027ac:	94da                	add	s1,s1,s6
ffffffffc02027ae:	609c                	ld	a5,0(s1)
ffffffffc02027b0:	0017f693          	andi	a3,a5,1
ffffffffc02027b4:	dee9                	beqz	a3,ffffffffc020278e <exit_range+0xe2>
ffffffffc02027b6:	000d3583          	ld	a1,0(s10)
ffffffffc02027ba:	078a                	slli	a5,a5,0x2
ffffffffc02027bc:	83b1                	srli	a5,a5,0xc
ffffffffc02027be:	14b7fe63          	bgeu	a5,a1,ffffffffc020291a <exit_range+0x26e>
ffffffffc02027c2:	97f2                	add	a5,a5,t3
ffffffffc02027c4:	006786b3          	add	a3,a5,t1
ffffffffc02027c8:	0196feb3          	and	t4,a3,s9
ffffffffc02027cc:	00679513          	slli	a0,a5,0x6
ffffffffc02027d0:	06b2                	slli	a3,a3,0xc
ffffffffc02027d2:	12bef863          	bgeu	t4,a1,ffffffffc0202902 <exit_range+0x256>
ffffffffc02027d6:	00083783          	ld	a5,0(a6)
ffffffffc02027da:	96be                	add	a3,a3,a5
ffffffffc02027dc:	011685b3          	add	a1,a3,a7
ffffffffc02027e0:	629c                	ld	a5,0(a3)
ffffffffc02027e2:	8b85                	andi	a5,a5,1
ffffffffc02027e4:	f7d5                	bnez	a5,ffffffffc0202790 <exit_range+0xe4>
ffffffffc02027e6:	06a1                	addi	a3,a3,8
ffffffffc02027e8:	fed59ce3          	bne	a1,a3,ffffffffc02027e0 <exit_range+0x134>
ffffffffc02027ec:	631c                	ld	a5,0(a4)
ffffffffc02027ee:	953e                	add	a0,a0,a5
ffffffffc02027f0:	100027f3          	csrr	a5,sstatus
ffffffffc02027f4:	8b89                	andi	a5,a5,2
ffffffffc02027f6:	e7d9                	bnez	a5,ffffffffc0202884 <exit_range+0x1d8>
ffffffffc02027f8:	000db783          	ld	a5,0(s11)
ffffffffc02027fc:	4585                	li	a1,1
ffffffffc02027fe:	e032                	sd	a2,0(sp)
ffffffffc0202800:	739c                	ld	a5,32(a5)
ffffffffc0202802:	9782                	jalr	a5
ffffffffc0202804:	6602                	ld	a2,0(sp)
ffffffffc0202806:	00094817          	auipc	a6,0x94
ffffffffc020280a:	0b280813          	addi	a6,a6,178 # ffffffffc02968b8 <va_pa_offset>
ffffffffc020280e:	fff80e37          	lui	t3,0xfff80
ffffffffc0202812:	00080337          	lui	t1,0x80
ffffffffc0202816:	6885                	lui	a7,0x1
ffffffffc0202818:	00094717          	auipc	a4,0x94
ffffffffc020281c:	09070713          	addi	a4,a4,144 # ffffffffc02968a8 <pages>
ffffffffc0202820:	0004b023          	sd	zero,0(s1)
ffffffffc0202824:	002007b7          	lui	a5,0x200
ffffffffc0202828:	993e                	add	s2,s2,a5
ffffffffc020282a:	f60918e3          	bnez	s2,ffffffffc020279a <exit_range+0xee>
ffffffffc020282e:	f00b85e3          	beqz	s7,ffffffffc0202738 <exit_range+0x8c>
ffffffffc0202832:	000d3783          	ld	a5,0(s10)
ffffffffc0202836:	0efa7263          	bgeu	s4,a5,ffffffffc020291a <exit_range+0x26e>
ffffffffc020283a:	6308                	ld	a0,0(a4)
ffffffffc020283c:	9532                	add	a0,a0,a2
ffffffffc020283e:	100027f3          	csrr	a5,sstatus
ffffffffc0202842:	8b89                	andi	a5,a5,2
ffffffffc0202844:	efad                	bnez	a5,ffffffffc02028be <exit_range+0x212>
ffffffffc0202846:	000db783          	ld	a5,0(s11)
ffffffffc020284a:	4585                	li	a1,1
ffffffffc020284c:	739c                	ld	a5,32(a5)
ffffffffc020284e:	9782                	jalr	a5
ffffffffc0202850:	00094717          	auipc	a4,0x94
ffffffffc0202854:	05870713          	addi	a4,a4,88 # ffffffffc02968a8 <pages>
ffffffffc0202858:	00043023          	sd	zero,0(s0)
ffffffffc020285c:	ee0990e3          	bnez	s3,ffffffffc020273c <exit_range+0x90>
ffffffffc0202860:	70e6                	ld	ra,120(sp)
ffffffffc0202862:	7446                	ld	s0,112(sp)
ffffffffc0202864:	74a6                	ld	s1,104(sp)
ffffffffc0202866:	7906                	ld	s2,96(sp)
ffffffffc0202868:	69e6                	ld	s3,88(sp)
ffffffffc020286a:	6a46                	ld	s4,80(sp)
ffffffffc020286c:	6aa6                	ld	s5,72(sp)
ffffffffc020286e:	6b06                	ld	s6,64(sp)
ffffffffc0202870:	7be2                	ld	s7,56(sp)
ffffffffc0202872:	7c42                	ld	s8,48(sp)
ffffffffc0202874:	7ca2                	ld	s9,40(sp)
ffffffffc0202876:	7d02                	ld	s10,32(sp)
ffffffffc0202878:	6de2                	ld	s11,24(sp)
ffffffffc020287a:	6109                	addi	sp,sp,128
ffffffffc020287c:	8082                	ret
ffffffffc020287e:	ea0b8fe3          	beqz	s7,ffffffffc020273c <exit_range+0x90>
ffffffffc0202882:	bf45                	j	ffffffffc0202832 <exit_range+0x186>
ffffffffc0202884:	e032                	sd	a2,0(sp)
ffffffffc0202886:	e42a                	sd	a0,8(sp)
ffffffffc0202888:	beafe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020288c:	000db783          	ld	a5,0(s11)
ffffffffc0202890:	6522                	ld	a0,8(sp)
ffffffffc0202892:	4585                	li	a1,1
ffffffffc0202894:	739c                	ld	a5,32(a5)
ffffffffc0202896:	9782                	jalr	a5
ffffffffc0202898:	bd4fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020289c:	6602                	ld	a2,0(sp)
ffffffffc020289e:	00094717          	auipc	a4,0x94
ffffffffc02028a2:	00a70713          	addi	a4,a4,10 # ffffffffc02968a8 <pages>
ffffffffc02028a6:	6885                	lui	a7,0x1
ffffffffc02028a8:	00080337          	lui	t1,0x80
ffffffffc02028ac:	fff80e37          	lui	t3,0xfff80
ffffffffc02028b0:	00094817          	auipc	a6,0x94
ffffffffc02028b4:	00880813          	addi	a6,a6,8 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02028b8:	0004b023          	sd	zero,0(s1)
ffffffffc02028bc:	b7a5                	j	ffffffffc0202824 <exit_range+0x178>
ffffffffc02028be:	e02a                	sd	a0,0(sp)
ffffffffc02028c0:	bb2fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02028c4:	000db783          	ld	a5,0(s11)
ffffffffc02028c8:	6502                	ld	a0,0(sp)
ffffffffc02028ca:	4585                	li	a1,1
ffffffffc02028cc:	739c                	ld	a5,32(a5)
ffffffffc02028ce:	9782                	jalr	a5
ffffffffc02028d0:	b9cfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02028d4:	00094717          	auipc	a4,0x94
ffffffffc02028d8:	fd470713          	addi	a4,a4,-44 # ffffffffc02968a8 <pages>
ffffffffc02028dc:	00043023          	sd	zero,0(s0)
ffffffffc02028e0:	bfb5                	j	ffffffffc020285c <exit_range+0x1b0>
ffffffffc02028e2:	0000a697          	auipc	a3,0xa
ffffffffc02028e6:	d1668693          	addi	a3,a3,-746 # ffffffffc020c5f8 <default_pmm_manager+0x188>
ffffffffc02028ea:	00009617          	auipc	a2,0x9
ffffffffc02028ee:	09e60613          	addi	a2,a2,158 # ffffffffc020b988 <commands+0x210>
ffffffffc02028f2:	16f00593          	li	a1,367
ffffffffc02028f6:	0000a517          	auipc	a0,0xa
ffffffffc02028fa:	cca50513          	addi	a0,a0,-822 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02028fe:	ba1fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202902:	0000a617          	auipc	a2,0xa
ffffffffc0202906:	ba660613          	addi	a2,a2,-1114 # ffffffffc020c4a8 <default_pmm_manager+0x38>
ffffffffc020290a:	07100593          	li	a1,113
ffffffffc020290e:	0000a517          	auipc	a0,0xa
ffffffffc0202912:	bc250513          	addi	a0,a0,-1086 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0202916:	b89fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020291a:	81bff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>
ffffffffc020291e:	0000a697          	auipc	a3,0xa
ffffffffc0202922:	d0a68693          	addi	a3,a3,-758 # ffffffffc020c628 <default_pmm_manager+0x1b8>
ffffffffc0202926:	00009617          	auipc	a2,0x9
ffffffffc020292a:	06260613          	addi	a2,a2,98 # ffffffffc020b988 <commands+0x210>
ffffffffc020292e:	17000593          	li	a1,368
ffffffffc0202932:	0000a517          	auipc	a0,0xa
ffffffffc0202936:	c8e50513          	addi	a0,a0,-882 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020293a:	b65fd0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020293e <page_remove>:
ffffffffc020293e:	7179                	addi	sp,sp,-48
ffffffffc0202940:	4601                	li	a2,0
ffffffffc0202942:	ec26                	sd	s1,24(sp)
ffffffffc0202944:	f406                	sd	ra,40(sp)
ffffffffc0202946:	f022                	sd	s0,32(sp)
ffffffffc0202948:	84ae                	mv	s1,a1
ffffffffc020294a:	8dbff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc020294e:	c511                	beqz	a0,ffffffffc020295a <page_remove+0x1c>
ffffffffc0202950:	611c                	ld	a5,0(a0)
ffffffffc0202952:	842a                	mv	s0,a0
ffffffffc0202954:	0017f713          	andi	a4,a5,1
ffffffffc0202958:	e711                	bnez	a4,ffffffffc0202964 <page_remove+0x26>
ffffffffc020295a:	70a2                	ld	ra,40(sp)
ffffffffc020295c:	7402                	ld	s0,32(sp)
ffffffffc020295e:	64e2                	ld	s1,24(sp)
ffffffffc0202960:	6145                	addi	sp,sp,48
ffffffffc0202962:	8082                	ret
ffffffffc0202964:	078a                	slli	a5,a5,0x2
ffffffffc0202966:	83b1                	srli	a5,a5,0xc
ffffffffc0202968:	00094717          	auipc	a4,0x94
ffffffffc020296c:	f3873703          	ld	a4,-200(a4) # ffffffffc02968a0 <npage>
ffffffffc0202970:	06e7f363          	bgeu	a5,a4,ffffffffc02029d6 <page_remove+0x98>
ffffffffc0202974:	fff80537          	lui	a0,0xfff80
ffffffffc0202978:	97aa                	add	a5,a5,a0
ffffffffc020297a:	079a                	slli	a5,a5,0x6
ffffffffc020297c:	00094517          	auipc	a0,0x94
ffffffffc0202980:	f2c53503          	ld	a0,-212(a0) # ffffffffc02968a8 <pages>
ffffffffc0202984:	953e                	add	a0,a0,a5
ffffffffc0202986:	411c                	lw	a5,0(a0)
ffffffffc0202988:	fff7871b          	addiw	a4,a5,-1
ffffffffc020298c:	c118                	sw	a4,0(a0)
ffffffffc020298e:	cb11                	beqz	a4,ffffffffc02029a2 <page_remove+0x64>
ffffffffc0202990:	00043023          	sd	zero,0(s0)
ffffffffc0202994:	12048073          	sfence.vma	s1
ffffffffc0202998:	70a2                	ld	ra,40(sp)
ffffffffc020299a:	7402                	ld	s0,32(sp)
ffffffffc020299c:	64e2                	ld	s1,24(sp)
ffffffffc020299e:	6145                	addi	sp,sp,48
ffffffffc02029a0:	8082                	ret
ffffffffc02029a2:	100027f3          	csrr	a5,sstatus
ffffffffc02029a6:	8b89                	andi	a5,a5,2
ffffffffc02029a8:	eb89                	bnez	a5,ffffffffc02029ba <page_remove+0x7c>
ffffffffc02029aa:	00094797          	auipc	a5,0x94
ffffffffc02029ae:	f067b783          	ld	a5,-250(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02029b2:	739c                	ld	a5,32(a5)
ffffffffc02029b4:	4585                	li	a1,1
ffffffffc02029b6:	9782                	jalr	a5
ffffffffc02029b8:	bfe1                	j	ffffffffc0202990 <page_remove+0x52>
ffffffffc02029ba:	e42a                	sd	a0,8(sp)
ffffffffc02029bc:	ab6fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02029c0:	00094797          	auipc	a5,0x94
ffffffffc02029c4:	ef07b783          	ld	a5,-272(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02029c8:	739c                	ld	a5,32(a5)
ffffffffc02029ca:	6522                	ld	a0,8(sp)
ffffffffc02029cc:	4585                	li	a1,1
ffffffffc02029ce:	9782                	jalr	a5
ffffffffc02029d0:	a9cfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02029d4:	bf75                	j	ffffffffc0202990 <page_remove+0x52>
ffffffffc02029d6:	f5eff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>

ffffffffc02029da <page_insert>:
ffffffffc02029da:	7139                	addi	sp,sp,-64
ffffffffc02029dc:	e852                	sd	s4,16(sp)
ffffffffc02029de:	8a32                	mv	s4,a2
ffffffffc02029e0:	f822                	sd	s0,48(sp)
ffffffffc02029e2:	4605                	li	a2,1
ffffffffc02029e4:	842e                	mv	s0,a1
ffffffffc02029e6:	85d2                	mv	a1,s4
ffffffffc02029e8:	f426                	sd	s1,40(sp)
ffffffffc02029ea:	fc06                	sd	ra,56(sp)
ffffffffc02029ec:	f04a                	sd	s2,32(sp)
ffffffffc02029ee:	ec4e                	sd	s3,24(sp)
ffffffffc02029f0:	e456                	sd	s5,8(sp)
ffffffffc02029f2:	84b6                	mv	s1,a3
ffffffffc02029f4:	831ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc02029f8:	c961                	beqz	a0,ffffffffc0202ac8 <page_insert+0xee>
ffffffffc02029fa:	4014                	lw	a3,0(s0)
ffffffffc02029fc:	611c                	ld	a5,0(a0)
ffffffffc02029fe:	89aa                	mv	s3,a0
ffffffffc0202a00:	0016871b          	addiw	a4,a3,1
ffffffffc0202a04:	c018                	sw	a4,0(s0)
ffffffffc0202a06:	0017f713          	andi	a4,a5,1
ffffffffc0202a0a:	ef05                	bnez	a4,ffffffffc0202a42 <page_insert+0x68>
ffffffffc0202a0c:	00094717          	auipc	a4,0x94
ffffffffc0202a10:	e9c73703          	ld	a4,-356(a4) # ffffffffc02968a8 <pages>
ffffffffc0202a14:	8c19                	sub	s0,s0,a4
ffffffffc0202a16:	000807b7          	lui	a5,0x80
ffffffffc0202a1a:	8419                	srai	s0,s0,0x6
ffffffffc0202a1c:	943e                	add	s0,s0,a5
ffffffffc0202a1e:	042a                	slli	s0,s0,0xa
ffffffffc0202a20:	8cc1                	or	s1,s1,s0
ffffffffc0202a22:	0014e493          	ori	s1,s1,1
ffffffffc0202a26:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc0202a2a:	120a0073          	sfence.vma	s4
ffffffffc0202a2e:	4501                	li	a0,0
ffffffffc0202a30:	70e2                	ld	ra,56(sp)
ffffffffc0202a32:	7442                	ld	s0,48(sp)
ffffffffc0202a34:	74a2                	ld	s1,40(sp)
ffffffffc0202a36:	7902                	ld	s2,32(sp)
ffffffffc0202a38:	69e2                	ld	s3,24(sp)
ffffffffc0202a3a:	6a42                	ld	s4,16(sp)
ffffffffc0202a3c:	6aa2                	ld	s5,8(sp)
ffffffffc0202a3e:	6121                	addi	sp,sp,64
ffffffffc0202a40:	8082                	ret
ffffffffc0202a42:	078a                	slli	a5,a5,0x2
ffffffffc0202a44:	83b1                	srli	a5,a5,0xc
ffffffffc0202a46:	00094717          	auipc	a4,0x94
ffffffffc0202a4a:	e5a73703          	ld	a4,-422(a4) # ffffffffc02968a0 <npage>
ffffffffc0202a4e:	06e7ff63          	bgeu	a5,a4,ffffffffc0202acc <page_insert+0xf2>
ffffffffc0202a52:	00094a97          	auipc	s5,0x94
ffffffffc0202a56:	e56a8a93          	addi	s5,s5,-426 # ffffffffc02968a8 <pages>
ffffffffc0202a5a:	000ab703          	ld	a4,0(s5)
ffffffffc0202a5e:	fff80937          	lui	s2,0xfff80
ffffffffc0202a62:	993e                	add	s2,s2,a5
ffffffffc0202a64:	091a                	slli	s2,s2,0x6
ffffffffc0202a66:	993a                	add	s2,s2,a4
ffffffffc0202a68:	01240c63          	beq	s0,s2,ffffffffc0202a80 <page_insert+0xa6>
ffffffffc0202a6c:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fce96f0>
ffffffffc0202a70:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202a74:	00d92023          	sw	a3,0(s2)
ffffffffc0202a78:	c691                	beqz	a3,ffffffffc0202a84 <page_insert+0xaa>
ffffffffc0202a7a:	120a0073          	sfence.vma	s4
ffffffffc0202a7e:	bf59                	j	ffffffffc0202a14 <page_insert+0x3a>
ffffffffc0202a80:	c014                	sw	a3,0(s0)
ffffffffc0202a82:	bf49                	j	ffffffffc0202a14 <page_insert+0x3a>
ffffffffc0202a84:	100027f3          	csrr	a5,sstatus
ffffffffc0202a88:	8b89                	andi	a5,a5,2
ffffffffc0202a8a:	ef91                	bnez	a5,ffffffffc0202aa6 <page_insert+0xcc>
ffffffffc0202a8c:	00094797          	auipc	a5,0x94
ffffffffc0202a90:	e247b783          	ld	a5,-476(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202a94:	739c                	ld	a5,32(a5)
ffffffffc0202a96:	4585                	li	a1,1
ffffffffc0202a98:	854a                	mv	a0,s2
ffffffffc0202a9a:	9782                	jalr	a5
ffffffffc0202a9c:	000ab703          	ld	a4,0(s5)
ffffffffc0202aa0:	120a0073          	sfence.vma	s4
ffffffffc0202aa4:	bf85                	j	ffffffffc0202a14 <page_insert+0x3a>
ffffffffc0202aa6:	9ccfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202aaa:	00094797          	auipc	a5,0x94
ffffffffc0202aae:	e067b783          	ld	a5,-506(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202ab2:	739c                	ld	a5,32(a5)
ffffffffc0202ab4:	4585                	li	a1,1
ffffffffc0202ab6:	854a                	mv	a0,s2
ffffffffc0202ab8:	9782                	jalr	a5
ffffffffc0202aba:	9b2fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202abe:	000ab703          	ld	a4,0(s5)
ffffffffc0202ac2:	120a0073          	sfence.vma	s4
ffffffffc0202ac6:	b7b9                	j	ffffffffc0202a14 <page_insert+0x3a>
ffffffffc0202ac8:	5571                	li	a0,-4
ffffffffc0202aca:	b79d                	j	ffffffffc0202a30 <page_insert+0x56>
ffffffffc0202acc:	e68ff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>

ffffffffc0202ad0 <pmm_init>:
ffffffffc0202ad0:	0000a797          	auipc	a5,0xa
ffffffffc0202ad4:	9a078793          	addi	a5,a5,-1632 # ffffffffc020c470 <default_pmm_manager>
ffffffffc0202ad8:	638c                	ld	a1,0(a5)
ffffffffc0202ada:	7159                	addi	sp,sp,-112
ffffffffc0202adc:	f85a                	sd	s6,48(sp)
ffffffffc0202ade:	0000a517          	auipc	a0,0xa
ffffffffc0202ae2:	b6250513          	addi	a0,a0,-1182 # ffffffffc020c640 <default_pmm_manager+0x1d0>
ffffffffc0202ae6:	00094b17          	auipc	s6,0x94
ffffffffc0202aea:	dcab0b13          	addi	s6,s6,-566 # ffffffffc02968b0 <pmm_manager>
ffffffffc0202aee:	f486                	sd	ra,104(sp)
ffffffffc0202af0:	e8ca                	sd	s2,80(sp)
ffffffffc0202af2:	e4ce                	sd	s3,72(sp)
ffffffffc0202af4:	f0a2                	sd	s0,96(sp)
ffffffffc0202af6:	eca6                	sd	s1,88(sp)
ffffffffc0202af8:	e0d2                	sd	s4,64(sp)
ffffffffc0202afa:	fc56                	sd	s5,56(sp)
ffffffffc0202afc:	f45e                	sd	s7,40(sp)
ffffffffc0202afe:	f062                	sd	s8,32(sp)
ffffffffc0202b00:	ec66                	sd	s9,24(sp)
ffffffffc0202b02:	00fb3023          	sd	a5,0(s6)
ffffffffc0202b06:	ea0fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202b0a:	000b3783          	ld	a5,0(s6)
ffffffffc0202b0e:	00094997          	auipc	s3,0x94
ffffffffc0202b12:	daa98993          	addi	s3,s3,-598 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202b16:	679c                	ld	a5,8(a5)
ffffffffc0202b18:	9782                	jalr	a5
ffffffffc0202b1a:	57f5                	li	a5,-3
ffffffffc0202b1c:	07fa                	slli	a5,a5,0x1e
ffffffffc0202b1e:	00f9b023          	sd	a5,0(s3)
ffffffffc0202b22:	f27fd0ef          	jal	ra,ffffffffc0200a48 <get_memory_base>
ffffffffc0202b26:	892a                	mv	s2,a0
ffffffffc0202b28:	f2bfd0ef          	jal	ra,ffffffffc0200a52 <get_memory_size>
ffffffffc0202b2c:	280502e3          	beqz	a0,ffffffffc02035b0 <pmm_init+0xae0>
ffffffffc0202b30:	84aa                	mv	s1,a0
ffffffffc0202b32:	0000a517          	auipc	a0,0xa
ffffffffc0202b36:	b4650513          	addi	a0,a0,-1210 # ffffffffc020c678 <default_pmm_manager+0x208>
ffffffffc0202b3a:	e6cfd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202b3e:	00990433          	add	s0,s2,s1
ffffffffc0202b42:	fff40693          	addi	a3,s0,-1
ffffffffc0202b46:	864a                	mv	a2,s2
ffffffffc0202b48:	85a6                	mv	a1,s1
ffffffffc0202b4a:	0000a517          	auipc	a0,0xa
ffffffffc0202b4e:	b4650513          	addi	a0,a0,-1210 # ffffffffc020c690 <default_pmm_manager+0x220>
ffffffffc0202b52:	e54fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202b56:	c8000737          	lui	a4,0xc8000
ffffffffc0202b5a:	87a2                	mv	a5,s0
ffffffffc0202b5c:	5e876e63          	bltu	a4,s0,ffffffffc0203158 <pmm_init+0x688>
ffffffffc0202b60:	757d                	lui	a0,0xfffff
ffffffffc0202b62:	00095617          	auipc	a2,0x95
ffffffffc0202b66:	dad60613          	addi	a2,a2,-595 # ffffffffc029790f <end+0xfff>
ffffffffc0202b6a:	8e69                	and	a2,a2,a0
ffffffffc0202b6c:	00094497          	auipc	s1,0x94
ffffffffc0202b70:	d3448493          	addi	s1,s1,-716 # ffffffffc02968a0 <npage>
ffffffffc0202b74:	00c7d513          	srli	a0,a5,0xc
ffffffffc0202b78:	00094b97          	auipc	s7,0x94
ffffffffc0202b7c:	d30b8b93          	addi	s7,s7,-720 # ffffffffc02968a8 <pages>
ffffffffc0202b80:	e088                	sd	a0,0(s1)
ffffffffc0202b82:	00cbb023          	sd	a2,0(s7)
ffffffffc0202b86:	000807b7          	lui	a5,0x80
ffffffffc0202b8a:	86b2                	mv	a3,a2
ffffffffc0202b8c:	02f50863          	beq	a0,a5,ffffffffc0202bbc <pmm_init+0xec>
ffffffffc0202b90:	4781                	li	a5,0
ffffffffc0202b92:	4585                	li	a1,1
ffffffffc0202b94:	fff806b7          	lui	a3,0xfff80
ffffffffc0202b98:	00679513          	slli	a0,a5,0x6
ffffffffc0202b9c:	9532                	add	a0,a0,a2
ffffffffc0202b9e:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd686f8>
ffffffffc0202ba2:	40b7302f          	amoor.d	zero,a1,(a4)
ffffffffc0202ba6:	6088                	ld	a0,0(s1)
ffffffffc0202ba8:	0785                	addi	a5,a5,1
ffffffffc0202baa:	000bb603          	ld	a2,0(s7)
ffffffffc0202bae:	00d50733          	add	a4,a0,a3
ffffffffc0202bb2:	fee7e3e3          	bltu	a5,a4,ffffffffc0202b98 <pmm_init+0xc8>
ffffffffc0202bb6:	071a                	slli	a4,a4,0x6
ffffffffc0202bb8:	00e606b3          	add	a3,a2,a4
ffffffffc0202bbc:	c02007b7          	lui	a5,0xc0200
ffffffffc0202bc0:	3af6eae3          	bltu	a3,a5,ffffffffc0203774 <pmm_init+0xca4>
ffffffffc0202bc4:	0009b583          	ld	a1,0(s3)
ffffffffc0202bc8:	77fd                	lui	a5,0xfffff
ffffffffc0202bca:	8c7d                	and	s0,s0,a5
ffffffffc0202bcc:	8e8d                	sub	a3,a3,a1
ffffffffc0202bce:	5e86e363          	bltu	a3,s0,ffffffffc02031b4 <pmm_init+0x6e4>
ffffffffc0202bd2:	0000a517          	auipc	a0,0xa
ffffffffc0202bd6:	ae650513          	addi	a0,a0,-1306 # ffffffffc020c6b8 <default_pmm_manager+0x248>
ffffffffc0202bda:	dccfd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202bde:	000b3783          	ld	a5,0(s6)
ffffffffc0202be2:	7b9c                	ld	a5,48(a5)
ffffffffc0202be4:	9782                	jalr	a5
ffffffffc0202be6:	0000a517          	auipc	a0,0xa
ffffffffc0202bea:	aea50513          	addi	a0,a0,-1302 # ffffffffc020c6d0 <default_pmm_manager+0x260>
ffffffffc0202bee:	db8fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202bf2:	100027f3          	csrr	a5,sstatus
ffffffffc0202bf6:	8b89                	andi	a5,a5,2
ffffffffc0202bf8:	5a079363          	bnez	a5,ffffffffc020319e <pmm_init+0x6ce>
ffffffffc0202bfc:	000b3783          	ld	a5,0(s6)
ffffffffc0202c00:	4505                	li	a0,1
ffffffffc0202c02:	6f9c                	ld	a5,24(a5)
ffffffffc0202c04:	9782                	jalr	a5
ffffffffc0202c06:	842a                	mv	s0,a0
ffffffffc0202c08:	180408e3          	beqz	s0,ffffffffc0203598 <pmm_init+0xac8>
ffffffffc0202c0c:	000bb683          	ld	a3,0(s7)
ffffffffc0202c10:	5a7d                	li	s4,-1
ffffffffc0202c12:	6098                	ld	a4,0(s1)
ffffffffc0202c14:	40d406b3          	sub	a3,s0,a3
ffffffffc0202c18:	8699                	srai	a3,a3,0x6
ffffffffc0202c1a:	00080437          	lui	s0,0x80
ffffffffc0202c1e:	96a2                	add	a3,a3,s0
ffffffffc0202c20:	00ca5793          	srli	a5,s4,0xc
ffffffffc0202c24:	8ff5                	and	a5,a5,a3
ffffffffc0202c26:	06b2                	slli	a3,a3,0xc
ffffffffc0202c28:	30e7fde3          	bgeu	a5,a4,ffffffffc0203742 <pmm_init+0xc72>
ffffffffc0202c2c:	0009b403          	ld	s0,0(s3)
ffffffffc0202c30:	6605                	lui	a2,0x1
ffffffffc0202c32:	4581                	li	a1,0
ffffffffc0202c34:	9436                	add	s0,s0,a3
ffffffffc0202c36:	8522                	mv	a0,s0
ffffffffc0202c38:	069080ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0202c3c:	0009b683          	ld	a3,0(s3)
ffffffffc0202c40:	77fd                	lui	a5,0xfffff
ffffffffc0202c42:	0000a917          	auipc	s2,0xa
ffffffffc0202c46:	8c790913          	addi	s2,s2,-1849 # ffffffffc020c509 <default_pmm_manager+0x99>
ffffffffc0202c4a:	00f97933          	and	s2,s2,a5
ffffffffc0202c4e:	c0200ab7          	lui	s5,0xc0200
ffffffffc0202c52:	3fe00637          	lui	a2,0x3fe00
ffffffffc0202c56:	964a                	add	a2,a2,s2
ffffffffc0202c58:	4729                	li	a4,10
ffffffffc0202c5a:	40da86b3          	sub	a3,s5,a3
ffffffffc0202c5e:	c02005b7          	lui	a1,0xc0200
ffffffffc0202c62:	8522                	mv	a0,s0
ffffffffc0202c64:	fe8ff0ef          	jal	ra,ffffffffc020244c <boot_map_segment>
ffffffffc0202c68:	c8000637          	lui	a2,0xc8000
ffffffffc0202c6c:	41260633          	sub	a2,a2,s2
ffffffffc0202c70:	3f596ce3          	bltu	s2,s5,ffffffffc0203868 <pmm_init+0xd98>
ffffffffc0202c74:	0009b683          	ld	a3,0(s3)
ffffffffc0202c78:	85ca                	mv	a1,s2
ffffffffc0202c7a:	4719                	li	a4,6
ffffffffc0202c7c:	40d906b3          	sub	a3,s2,a3
ffffffffc0202c80:	8522                	mv	a0,s0
ffffffffc0202c82:	00094917          	auipc	s2,0x94
ffffffffc0202c86:	c1690913          	addi	s2,s2,-1002 # ffffffffc0296898 <boot_pgdir_va>
ffffffffc0202c8a:	fc2ff0ef          	jal	ra,ffffffffc020244c <boot_map_segment>
ffffffffc0202c8e:	00893023          	sd	s0,0(s2)
ffffffffc0202c92:	2d5464e3          	bltu	s0,s5,ffffffffc020375a <pmm_init+0xc8a>
ffffffffc0202c96:	0009b783          	ld	a5,0(s3)
ffffffffc0202c9a:	1a7e                	slli	s4,s4,0x3f
ffffffffc0202c9c:	8c1d                	sub	s0,s0,a5
ffffffffc0202c9e:	00c45793          	srli	a5,s0,0xc
ffffffffc0202ca2:	00094717          	auipc	a4,0x94
ffffffffc0202ca6:	be873723          	sd	s0,-1042(a4) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0202caa:	0147ea33          	or	s4,a5,s4
ffffffffc0202cae:	180a1073          	csrw	satp,s4
ffffffffc0202cb2:	12000073          	sfence.vma
ffffffffc0202cb6:	0000a517          	auipc	a0,0xa
ffffffffc0202cba:	a5a50513          	addi	a0,a0,-1446 # ffffffffc020c710 <default_pmm_manager+0x2a0>
ffffffffc0202cbe:	ce8fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202cc2:	0000e717          	auipc	a4,0xe
ffffffffc0202cc6:	33e70713          	addi	a4,a4,830 # ffffffffc0211000 <bootstack>
ffffffffc0202cca:	0000e797          	auipc	a5,0xe
ffffffffc0202cce:	33678793          	addi	a5,a5,822 # ffffffffc0211000 <bootstack>
ffffffffc0202cd2:	5cf70d63          	beq	a4,a5,ffffffffc02032ac <pmm_init+0x7dc>
ffffffffc0202cd6:	100027f3          	csrr	a5,sstatus
ffffffffc0202cda:	8b89                	andi	a5,a5,2
ffffffffc0202cdc:	4a079763          	bnez	a5,ffffffffc020318a <pmm_init+0x6ba>
ffffffffc0202ce0:	000b3783          	ld	a5,0(s6)
ffffffffc0202ce4:	779c                	ld	a5,40(a5)
ffffffffc0202ce6:	9782                	jalr	a5
ffffffffc0202ce8:	842a                	mv	s0,a0
ffffffffc0202cea:	6098                	ld	a4,0(s1)
ffffffffc0202cec:	c80007b7          	lui	a5,0xc8000
ffffffffc0202cf0:	83b1                	srli	a5,a5,0xc
ffffffffc0202cf2:	08e7e3e3          	bltu	a5,a4,ffffffffc0203578 <pmm_init+0xaa8>
ffffffffc0202cf6:	00093503          	ld	a0,0(s2)
ffffffffc0202cfa:	04050fe3          	beqz	a0,ffffffffc0203558 <pmm_init+0xa88>
ffffffffc0202cfe:	03451793          	slli	a5,a0,0x34
ffffffffc0202d02:	04079be3          	bnez	a5,ffffffffc0203558 <pmm_init+0xa88>
ffffffffc0202d06:	4601                	li	a2,0
ffffffffc0202d08:	4581                	li	a1,0
ffffffffc0202d0a:	809ff0ef          	jal	ra,ffffffffc0202512 <get_page>
ffffffffc0202d0e:	2e0511e3          	bnez	a0,ffffffffc02037f0 <pmm_init+0xd20>
ffffffffc0202d12:	100027f3          	csrr	a5,sstatus
ffffffffc0202d16:	8b89                	andi	a5,a5,2
ffffffffc0202d18:	44079e63          	bnez	a5,ffffffffc0203174 <pmm_init+0x6a4>
ffffffffc0202d1c:	000b3783          	ld	a5,0(s6)
ffffffffc0202d20:	4505                	li	a0,1
ffffffffc0202d22:	6f9c                	ld	a5,24(a5)
ffffffffc0202d24:	9782                	jalr	a5
ffffffffc0202d26:	8a2a                	mv	s4,a0
ffffffffc0202d28:	00093503          	ld	a0,0(s2)
ffffffffc0202d2c:	4681                	li	a3,0
ffffffffc0202d2e:	4601                	li	a2,0
ffffffffc0202d30:	85d2                	mv	a1,s4
ffffffffc0202d32:	ca9ff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0202d36:	26051be3          	bnez	a0,ffffffffc02037ac <pmm_init+0xcdc>
ffffffffc0202d3a:	00093503          	ld	a0,0(s2)
ffffffffc0202d3e:	4601                	li	a2,0
ffffffffc0202d40:	4581                	li	a1,0
ffffffffc0202d42:	ce2ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202d46:	280505e3          	beqz	a0,ffffffffc02037d0 <pmm_init+0xd00>
ffffffffc0202d4a:	611c                	ld	a5,0(a0)
ffffffffc0202d4c:	0017f713          	andi	a4,a5,1
ffffffffc0202d50:	26070ee3          	beqz	a4,ffffffffc02037cc <pmm_init+0xcfc>
ffffffffc0202d54:	6098                	ld	a4,0(s1)
ffffffffc0202d56:	078a                	slli	a5,a5,0x2
ffffffffc0202d58:	83b1                	srli	a5,a5,0xc
ffffffffc0202d5a:	62e7f363          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202d5e:	000bb683          	ld	a3,0(s7)
ffffffffc0202d62:	fff80637          	lui	a2,0xfff80
ffffffffc0202d66:	97b2                	add	a5,a5,a2
ffffffffc0202d68:	079a                	slli	a5,a5,0x6
ffffffffc0202d6a:	97b6                	add	a5,a5,a3
ffffffffc0202d6c:	2afa12e3          	bne	s4,a5,ffffffffc0203810 <pmm_init+0xd40>
ffffffffc0202d70:	000a2683          	lw	a3,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0202d74:	4785                	li	a5,1
ffffffffc0202d76:	2cf699e3          	bne	a3,a5,ffffffffc0203848 <pmm_init+0xd78>
ffffffffc0202d7a:	00093503          	ld	a0,0(s2)
ffffffffc0202d7e:	77fd                	lui	a5,0xfffff
ffffffffc0202d80:	6114                	ld	a3,0(a0)
ffffffffc0202d82:	068a                	slli	a3,a3,0x2
ffffffffc0202d84:	8efd                	and	a3,a3,a5
ffffffffc0202d86:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202d8a:	2ae673e3          	bgeu	a2,a4,ffffffffc0203830 <pmm_init+0xd60>
ffffffffc0202d8e:	0009bc03          	ld	s8,0(s3)
ffffffffc0202d92:	96e2                	add	a3,a3,s8
ffffffffc0202d94:	0006ba83          	ld	s5,0(a3) # fffffffffff80000 <end+0x3fce96f0>
ffffffffc0202d98:	0a8a                	slli	s5,s5,0x2
ffffffffc0202d9a:	00fafab3          	and	s5,s5,a5
ffffffffc0202d9e:	00cad793          	srli	a5,s5,0xc
ffffffffc0202da2:	06e7f3e3          	bgeu	a5,a4,ffffffffc0203608 <pmm_init+0xb38>
ffffffffc0202da6:	4601                	li	a2,0
ffffffffc0202da8:	6585                	lui	a1,0x1
ffffffffc0202daa:	9ae2                	add	s5,s5,s8
ffffffffc0202dac:	c78ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202db0:	0aa1                	addi	s5,s5,8
ffffffffc0202db2:	03551be3          	bne	a0,s5,ffffffffc02035e8 <pmm_init+0xb18>
ffffffffc0202db6:	100027f3          	csrr	a5,sstatus
ffffffffc0202dba:	8b89                	andi	a5,a5,2
ffffffffc0202dbc:	3a079163          	bnez	a5,ffffffffc020315e <pmm_init+0x68e>
ffffffffc0202dc0:	000b3783          	ld	a5,0(s6)
ffffffffc0202dc4:	4505                	li	a0,1
ffffffffc0202dc6:	6f9c                	ld	a5,24(a5)
ffffffffc0202dc8:	9782                	jalr	a5
ffffffffc0202dca:	8c2a                	mv	s8,a0
ffffffffc0202dcc:	00093503          	ld	a0,0(s2)
ffffffffc0202dd0:	46d1                	li	a3,20
ffffffffc0202dd2:	6605                	lui	a2,0x1
ffffffffc0202dd4:	85e2                	mv	a1,s8
ffffffffc0202dd6:	c05ff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0202dda:	1a0519e3          	bnez	a0,ffffffffc020378c <pmm_init+0xcbc>
ffffffffc0202dde:	00093503          	ld	a0,0(s2)
ffffffffc0202de2:	4601                	li	a2,0
ffffffffc0202de4:	6585                	lui	a1,0x1
ffffffffc0202de6:	c3eff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202dea:	10050ce3          	beqz	a0,ffffffffc0203702 <pmm_init+0xc32>
ffffffffc0202dee:	611c                	ld	a5,0(a0)
ffffffffc0202df0:	0107f713          	andi	a4,a5,16
ffffffffc0202df4:	0e0707e3          	beqz	a4,ffffffffc02036e2 <pmm_init+0xc12>
ffffffffc0202df8:	8b91                	andi	a5,a5,4
ffffffffc0202dfa:	0c0784e3          	beqz	a5,ffffffffc02036c2 <pmm_init+0xbf2>
ffffffffc0202dfe:	00093503          	ld	a0,0(s2)
ffffffffc0202e02:	611c                	ld	a5,0(a0)
ffffffffc0202e04:	8bc1                	andi	a5,a5,16
ffffffffc0202e06:	08078ee3          	beqz	a5,ffffffffc02036a2 <pmm_init+0xbd2>
ffffffffc0202e0a:	000c2703          	lw	a4,0(s8)
ffffffffc0202e0e:	4785                	li	a5,1
ffffffffc0202e10:	06f719e3          	bne	a4,a5,ffffffffc0203682 <pmm_init+0xbb2>
ffffffffc0202e14:	4681                	li	a3,0
ffffffffc0202e16:	6605                	lui	a2,0x1
ffffffffc0202e18:	85d2                	mv	a1,s4
ffffffffc0202e1a:	bc1ff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0202e1e:	040512e3          	bnez	a0,ffffffffc0203662 <pmm_init+0xb92>
ffffffffc0202e22:	000a2703          	lw	a4,0(s4)
ffffffffc0202e26:	4789                	li	a5,2
ffffffffc0202e28:	00f71de3          	bne	a4,a5,ffffffffc0203642 <pmm_init+0xb72>
ffffffffc0202e2c:	000c2783          	lw	a5,0(s8)
ffffffffc0202e30:	7e079963          	bnez	a5,ffffffffc0203622 <pmm_init+0xb52>
ffffffffc0202e34:	00093503          	ld	a0,0(s2)
ffffffffc0202e38:	4601                	li	a2,0
ffffffffc0202e3a:	6585                	lui	a1,0x1
ffffffffc0202e3c:	be8ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202e40:	54050263          	beqz	a0,ffffffffc0203384 <pmm_init+0x8b4>
ffffffffc0202e44:	6118                	ld	a4,0(a0)
ffffffffc0202e46:	00177793          	andi	a5,a4,1
ffffffffc0202e4a:	180781e3          	beqz	a5,ffffffffc02037cc <pmm_init+0xcfc>
ffffffffc0202e4e:	6094                	ld	a3,0(s1)
ffffffffc0202e50:	00271793          	slli	a5,a4,0x2
ffffffffc0202e54:	83b1                	srli	a5,a5,0xc
ffffffffc0202e56:	52d7f563          	bgeu	a5,a3,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202e5a:	000bb683          	ld	a3,0(s7)
ffffffffc0202e5e:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202e62:	97d6                	add	a5,a5,s5
ffffffffc0202e64:	079a                	slli	a5,a5,0x6
ffffffffc0202e66:	97b6                	add	a5,a5,a3
ffffffffc0202e68:	58fa1e63          	bne	s4,a5,ffffffffc0203404 <pmm_init+0x934>
ffffffffc0202e6c:	8b41                	andi	a4,a4,16
ffffffffc0202e6e:	56071b63          	bnez	a4,ffffffffc02033e4 <pmm_init+0x914>
ffffffffc0202e72:	00093503          	ld	a0,0(s2)
ffffffffc0202e76:	4581                	li	a1,0
ffffffffc0202e78:	ac7ff0ef          	jal	ra,ffffffffc020293e <page_remove>
ffffffffc0202e7c:	000a2c83          	lw	s9,0(s4)
ffffffffc0202e80:	4785                	li	a5,1
ffffffffc0202e82:	5cfc9163          	bne	s9,a5,ffffffffc0203444 <pmm_init+0x974>
ffffffffc0202e86:	000c2783          	lw	a5,0(s8)
ffffffffc0202e8a:	58079d63          	bnez	a5,ffffffffc0203424 <pmm_init+0x954>
ffffffffc0202e8e:	00093503          	ld	a0,0(s2)
ffffffffc0202e92:	6585                	lui	a1,0x1
ffffffffc0202e94:	aabff0ef          	jal	ra,ffffffffc020293e <page_remove>
ffffffffc0202e98:	000a2783          	lw	a5,0(s4)
ffffffffc0202e9c:	200793e3          	bnez	a5,ffffffffc02038a2 <pmm_init+0xdd2>
ffffffffc0202ea0:	000c2783          	lw	a5,0(s8)
ffffffffc0202ea4:	1c079fe3          	bnez	a5,ffffffffc0203882 <pmm_init+0xdb2>
ffffffffc0202ea8:	00093a03          	ld	s4,0(s2)
ffffffffc0202eac:	608c                	ld	a1,0(s1)
ffffffffc0202eae:	000a3683          	ld	a3,0(s4)
ffffffffc0202eb2:	068a                	slli	a3,a3,0x2
ffffffffc0202eb4:	82b1                	srli	a3,a3,0xc
ffffffffc0202eb6:	4cb6f563          	bgeu	a3,a1,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202eba:	000bb503          	ld	a0,0(s7)
ffffffffc0202ebe:	96d6                	add	a3,a3,s5
ffffffffc0202ec0:	069a                	slli	a3,a3,0x6
ffffffffc0202ec2:	00d507b3          	add	a5,a0,a3
ffffffffc0202ec6:	439c                	lw	a5,0(a5)
ffffffffc0202ec8:	4f979e63          	bne	a5,s9,ffffffffc02033c4 <pmm_init+0x8f4>
ffffffffc0202ecc:	8699                	srai	a3,a3,0x6
ffffffffc0202ece:	00080637          	lui	a2,0x80
ffffffffc0202ed2:	96b2                	add	a3,a3,a2
ffffffffc0202ed4:	00c69713          	slli	a4,a3,0xc
ffffffffc0202ed8:	8331                	srli	a4,a4,0xc
ffffffffc0202eda:	06b2                	slli	a3,a3,0xc
ffffffffc0202edc:	06b773e3          	bgeu	a4,a1,ffffffffc0203742 <pmm_init+0xc72>
ffffffffc0202ee0:	0009b703          	ld	a4,0(s3)
ffffffffc0202ee4:	96ba                	add	a3,a3,a4
ffffffffc0202ee6:	629c                	ld	a5,0(a3)
ffffffffc0202ee8:	078a                	slli	a5,a5,0x2
ffffffffc0202eea:	83b1                	srli	a5,a5,0xc
ffffffffc0202eec:	48b7fa63          	bgeu	a5,a1,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202ef0:	8f91                	sub	a5,a5,a2
ffffffffc0202ef2:	079a                	slli	a5,a5,0x6
ffffffffc0202ef4:	953e                	add	a0,a0,a5
ffffffffc0202ef6:	100027f3          	csrr	a5,sstatus
ffffffffc0202efa:	8b89                	andi	a5,a5,2
ffffffffc0202efc:	32079463          	bnez	a5,ffffffffc0203224 <pmm_init+0x754>
ffffffffc0202f00:	000b3783          	ld	a5,0(s6)
ffffffffc0202f04:	4585                	li	a1,1
ffffffffc0202f06:	739c                	ld	a5,32(a5)
ffffffffc0202f08:	9782                	jalr	a5
ffffffffc0202f0a:	000a3783          	ld	a5,0(s4)
ffffffffc0202f0e:	6098                	ld	a4,0(s1)
ffffffffc0202f10:	078a                	slli	a5,a5,0x2
ffffffffc0202f12:	83b1                	srli	a5,a5,0xc
ffffffffc0202f14:	46e7f663          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202f18:	000bb503          	ld	a0,0(s7)
ffffffffc0202f1c:	fff80737          	lui	a4,0xfff80
ffffffffc0202f20:	97ba                	add	a5,a5,a4
ffffffffc0202f22:	079a                	slli	a5,a5,0x6
ffffffffc0202f24:	953e                	add	a0,a0,a5
ffffffffc0202f26:	100027f3          	csrr	a5,sstatus
ffffffffc0202f2a:	8b89                	andi	a5,a5,2
ffffffffc0202f2c:	2e079063          	bnez	a5,ffffffffc020320c <pmm_init+0x73c>
ffffffffc0202f30:	000b3783          	ld	a5,0(s6)
ffffffffc0202f34:	4585                	li	a1,1
ffffffffc0202f36:	739c                	ld	a5,32(a5)
ffffffffc0202f38:	9782                	jalr	a5
ffffffffc0202f3a:	00093783          	ld	a5,0(s2)
ffffffffc0202f3e:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0202f42:	12000073          	sfence.vma
ffffffffc0202f46:	100027f3          	csrr	a5,sstatus
ffffffffc0202f4a:	8b89                	andi	a5,a5,2
ffffffffc0202f4c:	2a079663          	bnez	a5,ffffffffc02031f8 <pmm_init+0x728>
ffffffffc0202f50:	000b3783          	ld	a5,0(s6)
ffffffffc0202f54:	779c                	ld	a5,40(a5)
ffffffffc0202f56:	9782                	jalr	a5
ffffffffc0202f58:	8a2a                	mv	s4,a0
ffffffffc0202f5a:	7d441463          	bne	s0,s4,ffffffffc0203722 <pmm_init+0xc52>
ffffffffc0202f5e:	0000a517          	auipc	a0,0xa
ffffffffc0202f62:	b0a50513          	addi	a0,a0,-1270 # ffffffffc020ca68 <default_pmm_manager+0x5f8>
ffffffffc0202f66:	a40fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202f6a:	100027f3          	csrr	a5,sstatus
ffffffffc0202f6e:	8b89                	andi	a5,a5,2
ffffffffc0202f70:	26079a63          	bnez	a5,ffffffffc02031e4 <pmm_init+0x714>
ffffffffc0202f74:	000b3783          	ld	a5,0(s6)
ffffffffc0202f78:	779c                	ld	a5,40(a5)
ffffffffc0202f7a:	9782                	jalr	a5
ffffffffc0202f7c:	8c2a                	mv	s8,a0
ffffffffc0202f7e:	6098                	ld	a4,0(s1)
ffffffffc0202f80:	c0200437          	lui	s0,0xc0200
ffffffffc0202f84:	7afd                	lui	s5,0xfffff
ffffffffc0202f86:	00c71793          	slli	a5,a4,0xc
ffffffffc0202f8a:	6a05                	lui	s4,0x1
ffffffffc0202f8c:	02f47c63          	bgeu	s0,a5,ffffffffc0202fc4 <pmm_init+0x4f4>
ffffffffc0202f90:	00c45793          	srli	a5,s0,0xc
ffffffffc0202f94:	00093503          	ld	a0,0(s2)
ffffffffc0202f98:	3ae7f763          	bgeu	a5,a4,ffffffffc0203346 <pmm_init+0x876>
ffffffffc0202f9c:	0009b583          	ld	a1,0(s3)
ffffffffc0202fa0:	4601                	li	a2,0
ffffffffc0202fa2:	95a2                	add	a1,a1,s0
ffffffffc0202fa4:	a80ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202fa8:	36050f63          	beqz	a0,ffffffffc0203326 <pmm_init+0x856>
ffffffffc0202fac:	611c                	ld	a5,0(a0)
ffffffffc0202fae:	078a                	slli	a5,a5,0x2
ffffffffc0202fb0:	0157f7b3          	and	a5,a5,s5
ffffffffc0202fb4:	3a879663          	bne	a5,s0,ffffffffc0203360 <pmm_init+0x890>
ffffffffc0202fb8:	6098                	ld	a4,0(s1)
ffffffffc0202fba:	9452                	add	s0,s0,s4
ffffffffc0202fbc:	00c71793          	slli	a5,a4,0xc
ffffffffc0202fc0:	fcf468e3          	bltu	s0,a5,ffffffffc0202f90 <pmm_init+0x4c0>
ffffffffc0202fc4:	00093783          	ld	a5,0(s2)
ffffffffc0202fc8:	639c                	ld	a5,0(a5)
ffffffffc0202fca:	48079d63          	bnez	a5,ffffffffc0203464 <pmm_init+0x994>
ffffffffc0202fce:	100027f3          	csrr	a5,sstatus
ffffffffc0202fd2:	8b89                	andi	a5,a5,2
ffffffffc0202fd4:	26079463          	bnez	a5,ffffffffc020323c <pmm_init+0x76c>
ffffffffc0202fd8:	000b3783          	ld	a5,0(s6)
ffffffffc0202fdc:	4505                	li	a0,1
ffffffffc0202fde:	6f9c                	ld	a5,24(a5)
ffffffffc0202fe0:	9782                	jalr	a5
ffffffffc0202fe2:	8a2a                	mv	s4,a0
ffffffffc0202fe4:	00093503          	ld	a0,0(s2)
ffffffffc0202fe8:	4699                	li	a3,6
ffffffffc0202fea:	10000613          	li	a2,256
ffffffffc0202fee:	85d2                	mv	a1,s4
ffffffffc0202ff0:	9ebff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0202ff4:	4a051863          	bnez	a0,ffffffffc02034a4 <pmm_init+0x9d4>
ffffffffc0202ff8:	000a2703          	lw	a4,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0202ffc:	4785                	li	a5,1
ffffffffc0202ffe:	48f71363          	bne	a4,a5,ffffffffc0203484 <pmm_init+0x9b4>
ffffffffc0203002:	00093503          	ld	a0,0(s2)
ffffffffc0203006:	6405                	lui	s0,0x1
ffffffffc0203008:	4699                	li	a3,6
ffffffffc020300a:	10040613          	addi	a2,s0,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc020300e:	85d2                	mv	a1,s4
ffffffffc0203010:	9cbff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0203014:	38051863          	bnez	a0,ffffffffc02033a4 <pmm_init+0x8d4>
ffffffffc0203018:	000a2703          	lw	a4,0(s4)
ffffffffc020301c:	4789                	li	a5,2
ffffffffc020301e:	4ef71363          	bne	a4,a5,ffffffffc0203504 <pmm_init+0xa34>
ffffffffc0203022:	0000a597          	auipc	a1,0xa
ffffffffc0203026:	b8e58593          	addi	a1,a1,-1138 # ffffffffc020cbb0 <default_pmm_manager+0x740>
ffffffffc020302a:	10000513          	li	a0,256
ffffffffc020302e:	406080ef          	jal	ra,ffffffffc020b434 <strcpy>
ffffffffc0203032:	10040593          	addi	a1,s0,256
ffffffffc0203036:	10000513          	li	a0,256
ffffffffc020303a:	40c080ef          	jal	ra,ffffffffc020b446 <strcmp>
ffffffffc020303e:	4a051363          	bnez	a0,ffffffffc02034e4 <pmm_init+0xa14>
ffffffffc0203042:	000bb683          	ld	a3,0(s7)
ffffffffc0203046:	00080737          	lui	a4,0x80
ffffffffc020304a:	547d                	li	s0,-1
ffffffffc020304c:	40da06b3          	sub	a3,s4,a3
ffffffffc0203050:	8699                	srai	a3,a3,0x6
ffffffffc0203052:	609c                	ld	a5,0(s1)
ffffffffc0203054:	96ba                	add	a3,a3,a4
ffffffffc0203056:	8031                	srli	s0,s0,0xc
ffffffffc0203058:	0086f733          	and	a4,a3,s0
ffffffffc020305c:	06b2                	slli	a3,a3,0xc
ffffffffc020305e:	6ef77263          	bgeu	a4,a5,ffffffffc0203742 <pmm_init+0xc72>
ffffffffc0203062:	0009b783          	ld	a5,0(s3)
ffffffffc0203066:	10000513          	li	a0,256
ffffffffc020306a:	96be                	add	a3,a3,a5
ffffffffc020306c:	10068023          	sb	zero,256(a3)
ffffffffc0203070:	38e080ef          	jal	ra,ffffffffc020b3fe <strlen>
ffffffffc0203074:	44051863          	bnez	a0,ffffffffc02034c4 <pmm_init+0x9f4>
ffffffffc0203078:	00093a83          	ld	s5,0(s2)
ffffffffc020307c:	609c                	ld	a5,0(s1)
ffffffffc020307e:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0203082:	068a                	slli	a3,a3,0x2
ffffffffc0203084:	82b1                	srli	a3,a3,0xc
ffffffffc0203086:	2ef6fd63          	bgeu	a3,a5,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc020308a:	8c75                	and	s0,s0,a3
ffffffffc020308c:	06b2                	slli	a3,a3,0xc
ffffffffc020308e:	6af47a63          	bgeu	s0,a5,ffffffffc0203742 <pmm_init+0xc72>
ffffffffc0203092:	0009b403          	ld	s0,0(s3)
ffffffffc0203096:	9436                	add	s0,s0,a3
ffffffffc0203098:	100027f3          	csrr	a5,sstatus
ffffffffc020309c:	8b89                	andi	a5,a5,2
ffffffffc020309e:	1e079c63          	bnez	a5,ffffffffc0203296 <pmm_init+0x7c6>
ffffffffc02030a2:	000b3783          	ld	a5,0(s6)
ffffffffc02030a6:	4585                	li	a1,1
ffffffffc02030a8:	8552                	mv	a0,s4
ffffffffc02030aa:	739c                	ld	a5,32(a5)
ffffffffc02030ac:	9782                	jalr	a5
ffffffffc02030ae:	601c                	ld	a5,0(s0)
ffffffffc02030b0:	6098                	ld	a4,0(s1)
ffffffffc02030b2:	078a                	slli	a5,a5,0x2
ffffffffc02030b4:	83b1                	srli	a5,a5,0xc
ffffffffc02030b6:	2ce7f563          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc02030ba:	000bb503          	ld	a0,0(s7)
ffffffffc02030be:	fff80737          	lui	a4,0xfff80
ffffffffc02030c2:	97ba                	add	a5,a5,a4
ffffffffc02030c4:	079a                	slli	a5,a5,0x6
ffffffffc02030c6:	953e                	add	a0,a0,a5
ffffffffc02030c8:	100027f3          	csrr	a5,sstatus
ffffffffc02030cc:	8b89                	andi	a5,a5,2
ffffffffc02030ce:	1a079863          	bnez	a5,ffffffffc020327e <pmm_init+0x7ae>
ffffffffc02030d2:	000b3783          	ld	a5,0(s6)
ffffffffc02030d6:	4585                	li	a1,1
ffffffffc02030d8:	739c                	ld	a5,32(a5)
ffffffffc02030da:	9782                	jalr	a5
ffffffffc02030dc:	000ab783          	ld	a5,0(s5)
ffffffffc02030e0:	6098                	ld	a4,0(s1)
ffffffffc02030e2:	078a                	slli	a5,a5,0x2
ffffffffc02030e4:	83b1                	srli	a5,a5,0xc
ffffffffc02030e6:	28e7fd63          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc02030ea:	000bb503          	ld	a0,0(s7)
ffffffffc02030ee:	fff80737          	lui	a4,0xfff80
ffffffffc02030f2:	97ba                	add	a5,a5,a4
ffffffffc02030f4:	079a                	slli	a5,a5,0x6
ffffffffc02030f6:	953e                	add	a0,a0,a5
ffffffffc02030f8:	100027f3          	csrr	a5,sstatus
ffffffffc02030fc:	8b89                	andi	a5,a5,2
ffffffffc02030fe:	16079463          	bnez	a5,ffffffffc0203266 <pmm_init+0x796>
ffffffffc0203102:	000b3783          	ld	a5,0(s6)
ffffffffc0203106:	4585                	li	a1,1
ffffffffc0203108:	739c                	ld	a5,32(a5)
ffffffffc020310a:	9782                	jalr	a5
ffffffffc020310c:	00093783          	ld	a5,0(s2)
ffffffffc0203110:	0007b023          	sd	zero,0(a5)
ffffffffc0203114:	12000073          	sfence.vma
ffffffffc0203118:	100027f3          	csrr	a5,sstatus
ffffffffc020311c:	8b89                	andi	a5,a5,2
ffffffffc020311e:	12079a63          	bnez	a5,ffffffffc0203252 <pmm_init+0x782>
ffffffffc0203122:	000b3783          	ld	a5,0(s6)
ffffffffc0203126:	779c                	ld	a5,40(a5)
ffffffffc0203128:	9782                	jalr	a5
ffffffffc020312a:	842a                	mv	s0,a0
ffffffffc020312c:	488c1e63          	bne	s8,s0,ffffffffc02035c8 <pmm_init+0xaf8>
ffffffffc0203130:	0000a517          	auipc	a0,0xa
ffffffffc0203134:	af850513          	addi	a0,a0,-1288 # ffffffffc020cc28 <default_pmm_manager+0x7b8>
ffffffffc0203138:	86efd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020313c:	7406                	ld	s0,96(sp)
ffffffffc020313e:	70a6                	ld	ra,104(sp)
ffffffffc0203140:	64e6                	ld	s1,88(sp)
ffffffffc0203142:	6946                	ld	s2,80(sp)
ffffffffc0203144:	69a6                	ld	s3,72(sp)
ffffffffc0203146:	6a06                	ld	s4,64(sp)
ffffffffc0203148:	7ae2                	ld	s5,56(sp)
ffffffffc020314a:	7b42                	ld	s6,48(sp)
ffffffffc020314c:	7ba2                	ld	s7,40(sp)
ffffffffc020314e:	7c02                	ld	s8,32(sp)
ffffffffc0203150:	6ce2                	ld	s9,24(sp)
ffffffffc0203152:	6165                	addi	sp,sp,112
ffffffffc0203154:	e17fe06f          	j	ffffffffc0201f6a <kmalloc_init>
ffffffffc0203158:	c80007b7          	lui	a5,0xc8000
ffffffffc020315c:	b411                	j	ffffffffc0202b60 <pmm_init+0x90>
ffffffffc020315e:	b15fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203162:	000b3783          	ld	a5,0(s6)
ffffffffc0203166:	4505                	li	a0,1
ffffffffc0203168:	6f9c                	ld	a5,24(a5)
ffffffffc020316a:	9782                	jalr	a5
ffffffffc020316c:	8c2a                	mv	s8,a0
ffffffffc020316e:	afffd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203172:	b9a9                	j	ffffffffc0202dcc <pmm_init+0x2fc>
ffffffffc0203174:	afffd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203178:	000b3783          	ld	a5,0(s6)
ffffffffc020317c:	4505                	li	a0,1
ffffffffc020317e:	6f9c                	ld	a5,24(a5)
ffffffffc0203180:	9782                	jalr	a5
ffffffffc0203182:	8a2a                	mv	s4,a0
ffffffffc0203184:	ae9fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203188:	b645                	j	ffffffffc0202d28 <pmm_init+0x258>
ffffffffc020318a:	ae9fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020318e:	000b3783          	ld	a5,0(s6)
ffffffffc0203192:	779c                	ld	a5,40(a5)
ffffffffc0203194:	9782                	jalr	a5
ffffffffc0203196:	842a                	mv	s0,a0
ffffffffc0203198:	ad5fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020319c:	b6b9                	j	ffffffffc0202cea <pmm_init+0x21a>
ffffffffc020319e:	ad5fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02031a2:	000b3783          	ld	a5,0(s6)
ffffffffc02031a6:	4505                	li	a0,1
ffffffffc02031a8:	6f9c                	ld	a5,24(a5)
ffffffffc02031aa:	9782                	jalr	a5
ffffffffc02031ac:	842a                	mv	s0,a0
ffffffffc02031ae:	abffd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02031b2:	bc99                	j	ffffffffc0202c08 <pmm_init+0x138>
ffffffffc02031b4:	6705                	lui	a4,0x1
ffffffffc02031b6:	177d                	addi	a4,a4,-1
ffffffffc02031b8:	96ba                	add	a3,a3,a4
ffffffffc02031ba:	8ff5                	and	a5,a5,a3
ffffffffc02031bc:	00c7d713          	srli	a4,a5,0xc
ffffffffc02031c0:	1ca77063          	bgeu	a4,a0,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc02031c4:	000b3683          	ld	a3,0(s6)
ffffffffc02031c8:	fff80537          	lui	a0,0xfff80
ffffffffc02031cc:	972a                	add	a4,a4,a0
ffffffffc02031ce:	6a94                	ld	a3,16(a3)
ffffffffc02031d0:	8c1d                	sub	s0,s0,a5
ffffffffc02031d2:	00671513          	slli	a0,a4,0x6
ffffffffc02031d6:	00c45593          	srli	a1,s0,0xc
ffffffffc02031da:	9532                	add	a0,a0,a2
ffffffffc02031dc:	9682                	jalr	a3
ffffffffc02031de:	0009b583          	ld	a1,0(s3)
ffffffffc02031e2:	bac5                	j	ffffffffc0202bd2 <pmm_init+0x102>
ffffffffc02031e4:	a8ffd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02031e8:	000b3783          	ld	a5,0(s6)
ffffffffc02031ec:	779c                	ld	a5,40(a5)
ffffffffc02031ee:	9782                	jalr	a5
ffffffffc02031f0:	8c2a                	mv	s8,a0
ffffffffc02031f2:	a7bfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02031f6:	b361                	j	ffffffffc0202f7e <pmm_init+0x4ae>
ffffffffc02031f8:	a7bfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02031fc:	000b3783          	ld	a5,0(s6)
ffffffffc0203200:	779c                	ld	a5,40(a5)
ffffffffc0203202:	9782                	jalr	a5
ffffffffc0203204:	8a2a                	mv	s4,a0
ffffffffc0203206:	a67fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020320a:	bb81                	j	ffffffffc0202f5a <pmm_init+0x48a>
ffffffffc020320c:	e42a                	sd	a0,8(sp)
ffffffffc020320e:	a65fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203212:	000b3783          	ld	a5,0(s6)
ffffffffc0203216:	6522                	ld	a0,8(sp)
ffffffffc0203218:	4585                	li	a1,1
ffffffffc020321a:	739c                	ld	a5,32(a5)
ffffffffc020321c:	9782                	jalr	a5
ffffffffc020321e:	a4ffd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203222:	bb21                	j	ffffffffc0202f3a <pmm_init+0x46a>
ffffffffc0203224:	e42a                	sd	a0,8(sp)
ffffffffc0203226:	a4dfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020322a:	000b3783          	ld	a5,0(s6)
ffffffffc020322e:	6522                	ld	a0,8(sp)
ffffffffc0203230:	4585                	li	a1,1
ffffffffc0203232:	739c                	ld	a5,32(a5)
ffffffffc0203234:	9782                	jalr	a5
ffffffffc0203236:	a37fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020323a:	b9c1                	j	ffffffffc0202f0a <pmm_init+0x43a>
ffffffffc020323c:	a37fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203240:	000b3783          	ld	a5,0(s6)
ffffffffc0203244:	4505                	li	a0,1
ffffffffc0203246:	6f9c                	ld	a5,24(a5)
ffffffffc0203248:	9782                	jalr	a5
ffffffffc020324a:	8a2a                	mv	s4,a0
ffffffffc020324c:	a21fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203250:	bb51                	j	ffffffffc0202fe4 <pmm_init+0x514>
ffffffffc0203252:	a21fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203256:	000b3783          	ld	a5,0(s6)
ffffffffc020325a:	779c                	ld	a5,40(a5)
ffffffffc020325c:	9782                	jalr	a5
ffffffffc020325e:	842a                	mv	s0,a0
ffffffffc0203260:	a0dfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203264:	b5e1                	j	ffffffffc020312c <pmm_init+0x65c>
ffffffffc0203266:	e42a                	sd	a0,8(sp)
ffffffffc0203268:	a0bfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020326c:	000b3783          	ld	a5,0(s6)
ffffffffc0203270:	6522                	ld	a0,8(sp)
ffffffffc0203272:	4585                	li	a1,1
ffffffffc0203274:	739c                	ld	a5,32(a5)
ffffffffc0203276:	9782                	jalr	a5
ffffffffc0203278:	9f5fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020327c:	bd41                	j	ffffffffc020310c <pmm_init+0x63c>
ffffffffc020327e:	e42a                	sd	a0,8(sp)
ffffffffc0203280:	9f3fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203284:	000b3783          	ld	a5,0(s6)
ffffffffc0203288:	6522                	ld	a0,8(sp)
ffffffffc020328a:	4585                	li	a1,1
ffffffffc020328c:	739c                	ld	a5,32(a5)
ffffffffc020328e:	9782                	jalr	a5
ffffffffc0203290:	9ddfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203294:	b5a1                	j	ffffffffc02030dc <pmm_init+0x60c>
ffffffffc0203296:	9ddfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020329a:	000b3783          	ld	a5,0(s6)
ffffffffc020329e:	4585                	li	a1,1
ffffffffc02032a0:	8552                	mv	a0,s4
ffffffffc02032a2:	739c                	ld	a5,32(a5)
ffffffffc02032a4:	9782                	jalr	a5
ffffffffc02032a6:	9c7fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02032aa:	b511                	j	ffffffffc02030ae <pmm_init+0x5de>
ffffffffc02032ac:	00010417          	auipc	s0,0x10
ffffffffc02032b0:	d5440413          	addi	s0,s0,-684 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc02032b4:	00010797          	auipc	a5,0x10
ffffffffc02032b8:	d4c78793          	addi	a5,a5,-692 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc02032bc:	a0f41de3          	bne	s0,a5,ffffffffc0202cd6 <pmm_init+0x206>
ffffffffc02032c0:	4581                	li	a1,0
ffffffffc02032c2:	6605                	lui	a2,0x1
ffffffffc02032c4:	8522                	mv	a0,s0
ffffffffc02032c6:	1da080ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc02032ca:	0000d597          	auipc	a1,0xd
ffffffffc02032ce:	d3658593          	addi	a1,a1,-714 # ffffffffc0210000 <bootstackguard>
ffffffffc02032d2:	0000e797          	auipc	a5,0xe
ffffffffc02032d6:	d20786a3          	sb	zero,-723(a5) # ffffffffc0210fff <bootstackguard+0xfff>
ffffffffc02032da:	0000d797          	auipc	a5,0xd
ffffffffc02032de:	d2078323          	sb	zero,-730(a5) # ffffffffc0210000 <bootstackguard>
ffffffffc02032e2:	00093503          	ld	a0,0(s2)
ffffffffc02032e6:	2555ec63          	bltu	a1,s5,ffffffffc020353e <pmm_init+0xa6e>
ffffffffc02032ea:	0009b683          	ld	a3,0(s3)
ffffffffc02032ee:	4701                	li	a4,0
ffffffffc02032f0:	6605                	lui	a2,0x1
ffffffffc02032f2:	40d586b3          	sub	a3,a1,a3
ffffffffc02032f6:	956ff0ef          	jal	ra,ffffffffc020244c <boot_map_segment>
ffffffffc02032fa:	00093503          	ld	a0,0(s2)
ffffffffc02032fe:	23546363          	bltu	s0,s5,ffffffffc0203524 <pmm_init+0xa54>
ffffffffc0203302:	0009b683          	ld	a3,0(s3)
ffffffffc0203306:	4701                	li	a4,0
ffffffffc0203308:	6605                	lui	a2,0x1
ffffffffc020330a:	40d406b3          	sub	a3,s0,a3
ffffffffc020330e:	85a2                	mv	a1,s0
ffffffffc0203310:	93cff0ef          	jal	ra,ffffffffc020244c <boot_map_segment>
ffffffffc0203314:	12000073          	sfence.vma
ffffffffc0203318:	00009517          	auipc	a0,0x9
ffffffffc020331c:	42050513          	addi	a0,a0,1056 # ffffffffc020c738 <default_pmm_manager+0x2c8>
ffffffffc0203320:	e87fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0203324:	ba4d                	j	ffffffffc0202cd6 <pmm_init+0x206>
ffffffffc0203326:	00009697          	auipc	a3,0x9
ffffffffc020332a:	76268693          	addi	a3,a3,1890 # ffffffffc020ca88 <default_pmm_manager+0x618>
ffffffffc020332e:	00008617          	auipc	a2,0x8
ffffffffc0203332:	65a60613          	addi	a2,a2,1626 # ffffffffc020b988 <commands+0x210>
ffffffffc0203336:	2af00593          	li	a1,687
ffffffffc020333a:	00009517          	auipc	a0,0x9
ffffffffc020333e:	28650513          	addi	a0,a0,646 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203342:	95cfd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203346:	86a2                	mv	a3,s0
ffffffffc0203348:	00009617          	auipc	a2,0x9
ffffffffc020334c:	16060613          	addi	a2,a2,352 # ffffffffc020c4a8 <default_pmm_manager+0x38>
ffffffffc0203350:	2af00593          	li	a1,687
ffffffffc0203354:	00009517          	auipc	a0,0x9
ffffffffc0203358:	26c50513          	addi	a0,a0,620 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020335c:	942fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203360:	00009697          	auipc	a3,0x9
ffffffffc0203364:	76868693          	addi	a3,a3,1896 # ffffffffc020cac8 <default_pmm_manager+0x658>
ffffffffc0203368:	00008617          	auipc	a2,0x8
ffffffffc020336c:	62060613          	addi	a2,a2,1568 # ffffffffc020b988 <commands+0x210>
ffffffffc0203370:	2b000593          	li	a1,688
ffffffffc0203374:	00009517          	auipc	a0,0x9
ffffffffc0203378:	24c50513          	addi	a0,a0,588 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020337c:	922fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203380:	db5fe0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>
ffffffffc0203384:	00009697          	auipc	a3,0x9
ffffffffc0203388:	56c68693          	addi	a3,a3,1388 # ffffffffc020c8f0 <default_pmm_manager+0x480>
ffffffffc020338c:	00008617          	auipc	a2,0x8
ffffffffc0203390:	5fc60613          	addi	a2,a2,1532 # ffffffffc020b988 <commands+0x210>
ffffffffc0203394:	28c00593          	li	a1,652
ffffffffc0203398:	00009517          	auipc	a0,0x9
ffffffffc020339c:	22850513          	addi	a0,a0,552 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02033a0:	8fefd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02033a4:	00009697          	auipc	a3,0x9
ffffffffc02033a8:	7ac68693          	addi	a3,a3,1964 # ffffffffc020cb50 <default_pmm_manager+0x6e0>
ffffffffc02033ac:	00008617          	auipc	a2,0x8
ffffffffc02033b0:	5dc60613          	addi	a2,a2,1500 # ffffffffc020b988 <commands+0x210>
ffffffffc02033b4:	2b900593          	li	a1,697
ffffffffc02033b8:	00009517          	auipc	a0,0x9
ffffffffc02033bc:	20850513          	addi	a0,a0,520 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02033c0:	8defd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02033c4:	00009697          	auipc	a3,0x9
ffffffffc02033c8:	64c68693          	addi	a3,a3,1612 # ffffffffc020ca10 <default_pmm_manager+0x5a0>
ffffffffc02033cc:	00008617          	auipc	a2,0x8
ffffffffc02033d0:	5bc60613          	addi	a2,a2,1468 # ffffffffc020b988 <commands+0x210>
ffffffffc02033d4:	29800593          	li	a1,664
ffffffffc02033d8:	00009517          	auipc	a0,0x9
ffffffffc02033dc:	1e850513          	addi	a0,a0,488 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02033e0:	8befd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02033e4:	00009697          	auipc	a3,0x9
ffffffffc02033e8:	5fc68693          	addi	a3,a3,1532 # ffffffffc020c9e0 <default_pmm_manager+0x570>
ffffffffc02033ec:	00008617          	auipc	a2,0x8
ffffffffc02033f0:	59c60613          	addi	a2,a2,1436 # ffffffffc020b988 <commands+0x210>
ffffffffc02033f4:	28e00593          	li	a1,654
ffffffffc02033f8:	00009517          	auipc	a0,0x9
ffffffffc02033fc:	1c850513          	addi	a0,a0,456 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203400:	89efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203404:	00009697          	auipc	a3,0x9
ffffffffc0203408:	44c68693          	addi	a3,a3,1100 # ffffffffc020c850 <default_pmm_manager+0x3e0>
ffffffffc020340c:	00008617          	auipc	a2,0x8
ffffffffc0203410:	57c60613          	addi	a2,a2,1404 # ffffffffc020b988 <commands+0x210>
ffffffffc0203414:	28d00593          	li	a1,653
ffffffffc0203418:	00009517          	auipc	a0,0x9
ffffffffc020341c:	1a850513          	addi	a0,a0,424 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203420:	87efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203424:	00009697          	auipc	a3,0x9
ffffffffc0203428:	5a468693          	addi	a3,a3,1444 # ffffffffc020c9c8 <default_pmm_manager+0x558>
ffffffffc020342c:	00008617          	auipc	a2,0x8
ffffffffc0203430:	55c60613          	addi	a2,a2,1372 # ffffffffc020b988 <commands+0x210>
ffffffffc0203434:	29200593          	li	a1,658
ffffffffc0203438:	00009517          	auipc	a0,0x9
ffffffffc020343c:	18850513          	addi	a0,a0,392 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203440:	85efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203444:	00009697          	auipc	a3,0x9
ffffffffc0203448:	42468693          	addi	a3,a3,1060 # ffffffffc020c868 <default_pmm_manager+0x3f8>
ffffffffc020344c:	00008617          	auipc	a2,0x8
ffffffffc0203450:	53c60613          	addi	a2,a2,1340 # ffffffffc020b988 <commands+0x210>
ffffffffc0203454:	29100593          	li	a1,657
ffffffffc0203458:	00009517          	auipc	a0,0x9
ffffffffc020345c:	16850513          	addi	a0,a0,360 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203460:	83efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203464:	00009697          	auipc	a3,0x9
ffffffffc0203468:	67c68693          	addi	a3,a3,1660 # ffffffffc020cae0 <default_pmm_manager+0x670>
ffffffffc020346c:	00008617          	auipc	a2,0x8
ffffffffc0203470:	51c60613          	addi	a2,a2,1308 # ffffffffc020b988 <commands+0x210>
ffffffffc0203474:	2b300593          	li	a1,691
ffffffffc0203478:	00009517          	auipc	a0,0x9
ffffffffc020347c:	14850513          	addi	a0,a0,328 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203480:	81efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203484:	00009697          	auipc	a3,0x9
ffffffffc0203488:	6b468693          	addi	a3,a3,1716 # ffffffffc020cb38 <default_pmm_manager+0x6c8>
ffffffffc020348c:	00008617          	auipc	a2,0x8
ffffffffc0203490:	4fc60613          	addi	a2,a2,1276 # ffffffffc020b988 <commands+0x210>
ffffffffc0203494:	2b800593          	li	a1,696
ffffffffc0203498:	00009517          	auipc	a0,0x9
ffffffffc020349c:	12850513          	addi	a0,a0,296 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02034a0:	ffffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02034a4:	00009697          	auipc	a3,0x9
ffffffffc02034a8:	65468693          	addi	a3,a3,1620 # ffffffffc020caf8 <default_pmm_manager+0x688>
ffffffffc02034ac:	00008617          	auipc	a2,0x8
ffffffffc02034b0:	4dc60613          	addi	a2,a2,1244 # ffffffffc020b988 <commands+0x210>
ffffffffc02034b4:	2b700593          	li	a1,695
ffffffffc02034b8:	00009517          	auipc	a0,0x9
ffffffffc02034bc:	10850513          	addi	a0,a0,264 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02034c0:	fdffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02034c4:	00009697          	auipc	a3,0x9
ffffffffc02034c8:	73c68693          	addi	a3,a3,1852 # ffffffffc020cc00 <default_pmm_manager+0x790>
ffffffffc02034cc:	00008617          	auipc	a2,0x8
ffffffffc02034d0:	4bc60613          	addi	a2,a2,1212 # ffffffffc020b988 <commands+0x210>
ffffffffc02034d4:	2c100593          	li	a1,705
ffffffffc02034d8:	00009517          	auipc	a0,0x9
ffffffffc02034dc:	0e850513          	addi	a0,a0,232 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02034e0:	fbffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02034e4:	00009697          	auipc	a3,0x9
ffffffffc02034e8:	6e468693          	addi	a3,a3,1764 # ffffffffc020cbc8 <default_pmm_manager+0x758>
ffffffffc02034ec:	00008617          	auipc	a2,0x8
ffffffffc02034f0:	49c60613          	addi	a2,a2,1180 # ffffffffc020b988 <commands+0x210>
ffffffffc02034f4:	2be00593          	li	a1,702
ffffffffc02034f8:	00009517          	auipc	a0,0x9
ffffffffc02034fc:	0c850513          	addi	a0,a0,200 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203500:	f9ffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203504:	00009697          	auipc	a3,0x9
ffffffffc0203508:	69468693          	addi	a3,a3,1684 # ffffffffc020cb98 <default_pmm_manager+0x728>
ffffffffc020350c:	00008617          	auipc	a2,0x8
ffffffffc0203510:	47c60613          	addi	a2,a2,1148 # ffffffffc020b988 <commands+0x210>
ffffffffc0203514:	2ba00593          	li	a1,698
ffffffffc0203518:	00009517          	auipc	a0,0x9
ffffffffc020351c:	0a850513          	addi	a0,a0,168 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203520:	f7ffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203524:	86a2                	mv	a3,s0
ffffffffc0203526:	00009617          	auipc	a2,0x9
ffffffffc020352a:	02a60613          	addi	a2,a2,42 # ffffffffc020c550 <default_pmm_manager+0xe0>
ffffffffc020352e:	0dc00593          	li	a1,220
ffffffffc0203532:	00009517          	auipc	a0,0x9
ffffffffc0203536:	08e50513          	addi	a0,a0,142 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020353a:	f65fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020353e:	86ae                	mv	a3,a1
ffffffffc0203540:	00009617          	auipc	a2,0x9
ffffffffc0203544:	01060613          	addi	a2,a2,16 # ffffffffc020c550 <default_pmm_manager+0xe0>
ffffffffc0203548:	0db00593          	li	a1,219
ffffffffc020354c:	00009517          	auipc	a0,0x9
ffffffffc0203550:	07450513          	addi	a0,a0,116 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203554:	f4bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203558:	00009697          	auipc	a3,0x9
ffffffffc020355c:	22868693          	addi	a3,a3,552 # ffffffffc020c780 <default_pmm_manager+0x310>
ffffffffc0203560:	00008617          	auipc	a2,0x8
ffffffffc0203564:	42860613          	addi	a2,a2,1064 # ffffffffc020b988 <commands+0x210>
ffffffffc0203568:	27100593          	li	a1,625
ffffffffc020356c:	00009517          	auipc	a0,0x9
ffffffffc0203570:	05450513          	addi	a0,a0,84 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203574:	f2bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203578:	00009697          	auipc	a3,0x9
ffffffffc020357c:	1e868693          	addi	a3,a3,488 # ffffffffc020c760 <default_pmm_manager+0x2f0>
ffffffffc0203580:	00008617          	auipc	a2,0x8
ffffffffc0203584:	40860613          	addi	a2,a2,1032 # ffffffffc020b988 <commands+0x210>
ffffffffc0203588:	27000593          	li	a1,624
ffffffffc020358c:	00009517          	auipc	a0,0x9
ffffffffc0203590:	03450513          	addi	a0,a0,52 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203594:	f0bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203598:	00009617          	auipc	a2,0x9
ffffffffc020359c:	15860613          	addi	a2,a2,344 # ffffffffc020c6f0 <default_pmm_manager+0x280>
ffffffffc02035a0:	0aa00593          	li	a1,170
ffffffffc02035a4:	00009517          	auipc	a0,0x9
ffffffffc02035a8:	01c50513          	addi	a0,a0,28 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02035ac:	ef3fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035b0:	00009617          	auipc	a2,0x9
ffffffffc02035b4:	0a860613          	addi	a2,a2,168 # ffffffffc020c658 <default_pmm_manager+0x1e8>
ffffffffc02035b8:	06500593          	li	a1,101
ffffffffc02035bc:	00009517          	auipc	a0,0x9
ffffffffc02035c0:	00450513          	addi	a0,a0,4 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02035c4:	edbfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035c8:	00009697          	auipc	a3,0x9
ffffffffc02035cc:	47868693          	addi	a3,a3,1144 # ffffffffc020ca40 <default_pmm_manager+0x5d0>
ffffffffc02035d0:	00008617          	auipc	a2,0x8
ffffffffc02035d4:	3b860613          	addi	a2,a2,952 # ffffffffc020b988 <commands+0x210>
ffffffffc02035d8:	2ca00593          	li	a1,714
ffffffffc02035dc:	00009517          	auipc	a0,0x9
ffffffffc02035e0:	fe450513          	addi	a0,a0,-28 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02035e4:	ebbfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035e8:	00009697          	auipc	a3,0x9
ffffffffc02035ec:	29868693          	addi	a3,a3,664 # ffffffffc020c880 <default_pmm_manager+0x410>
ffffffffc02035f0:	00008617          	auipc	a2,0x8
ffffffffc02035f4:	39860613          	addi	a2,a2,920 # ffffffffc020b988 <commands+0x210>
ffffffffc02035f8:	27f00593          	li	a1,639
ffffffffc02035fc:	00009517          	auipc	a0,0x9
ffffffffc0203600:	fc450513          	addi	a0,a0,-60 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203604:	e9bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203608:	86d6                	mv	a3,s5
ffffffffc020360a:	00009617          	auipc	a2,0x9
ffffffffc020360e:	e9e60613          	addi	a2,a2,-354 # ffffffffc020c4a8 <default_pmm_manager+0x38>
ffffffffc0203612:	27e00593          	li	a1,638
ffffffffc0203616:	00009517          	auipc	a0,0x9
ffffffffc020361a:	faa50513          	addi	a0,a0,-86 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020361e:	e81fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203622:	00009697          	auipc	a3,0x9
ffffffffc0203626:	3a668693          	addi	a3,a3,934 # ffffffffc020c9c8 <default_pmm_manager+0x558>
ffffffffc020362a:	00008617          	auipc	a2,0x8
ffffffffc020362e:	35e60613          	addi	a2,a2,862 # ffffffffc020b988 <commands+0x210>
ffffffffc0203632:	28b00593          	li	a1,651
ffffffffc0203636:	00009517          	auipc	a0,0x9
ffffffffc020363a:	f8a50513          	addi	a0,a0,-118 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020363e:	e61fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203642:	00009697          	auipc	a3,0x9
ffffffffc0203646:	36e68693          	addi	a3,a3,878 # ffffffffc020c9b0 <default_pmm_manager+0x540>
ffffffffc020364a:	00008617          	auipc	a2,0x8
ffffffffc020364e:	33e60613          	addi	a2,a2,830 # ffffffffc020b988 <commands+0x210>
ffffffffc0203652:	28a00593          	li	a1,650
ffffffffc0203656:	00009517          	auipc	a0,0x9
ffffffffc020365a:	f6a50513          	addi	a0,a0,-150 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020365e:	e41fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203662:	00009697          	auipc	a3,0x9
ffffffffc0203666:	31e68693          	addi	a3,a3,798 # ffffffffc020c980 <default_pmm_manager+0x510>
ffffffffc020366a:	00008617          	auipc	a2,0x8
ffffffffc020366e:	31e60613          	addi	a2,a2,798 # ffffffffc020b988 <commands+0x210>
ffffffffc0203672:	28900593          	li	a1,649
ffffffffc0203676:	00009517          	auipc	a0,0x9
ffffffffc020367a:	f4a50513          	addi	a0,a0,-182 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020367e:	e21fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203682:	00009697          	auipc	a3,0x9
ffffffffc0203686:	2e668693          	addi	a3,a3,742 # ffffffffc020c968 <default_pmm_manager+0x4f8>
ffffffffc020368a:	00008617          	auipc	a2,0x8
ffffffffc020368e:	2fe60613          	addi	a2,a2,766 # ffffffffc020b988 <commands+0x210>
ffffffffc0203692:	28700593          	li	a1,647
ffffffffc0203696:	00009517          	auipc	a0,0x9
ffffffffc020369a:	f2a50513          	addi	a0,a0,-214 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020369e:	e01fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036a2:	00009697          	auipc	a3,0x9
ffffffffc02036a6:	2a668693          	addi	a3,a3,678 # ffffffffc020c948 <default_pmm_manager+0x4d8>
ffffffffc02036aa:	00008617          	auipc	a2,0x8
ffffffffc02036ae:	2de60613          	addi	a2,a2,734 # ffffffffc020b988 <commands+0x210>
ffffffffc02036b2:	28600593          	li	a1,646
ffffffffc02036b6:	00009517          	auipc	a0,0x9
ffffffffc02036ba:	f0a50513          	addi	a0,a0,-246 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02036be:	de1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036c2:	00009697          	auipc	a3,0x9
ffffffffc02036c6:	27668693          	addi	a3,a3,630 # ffffffffc020c938 <default_pmm_manager+0x4c8>
ffffffffc02036ca:	00008617          	auipc	a2,0x8
ffffffffc02036ce:	2be60613          	addi	a2,a2,702 # ffffffffc020b988 <commands+0x210>
ffffffffc02036d2:	28500593          	li	a1,645
ffffffffc02036d6:	00009517          	auipc	a0,0x9
ffffffffc02036da:	eea50513          	addi	a0,a0,-278 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02036de:	dc1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036e2:	00009697          	auipc	a3,0x9
ffffffffc02036e6:	24668693          	addi	a3,a3,582 # ffffffffc020c928 <default_pmm_manager+0x4b8>
ffffffffc02036ea:	00008617          	auipc	a2,0x8
ffffffffc02036ee:	29e60613          	addi	a2,a2,670 # ffffffffc020b988 <commands+0x210>
ffffffffc02036f2:	28400593          	li	a1,644
ffffffffc02036f6:	00009517          	auipc	a0,0x9
ffffffffc02036fa:	eca50513          	addi	a0,a0,-310 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02036fe:	da1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203702:	00009697          	auipc	a3,0x9
ffffffffc0203706:	1ee68693          	addi	a3,a3,494 # ffffffffc020c8f0 <default_pmm_manager+0x480>
ffffffffc020370a:	00008617          	auipc	a2,0x8
ffffffffc020370e:	27e60613          	addi	a2,a2,638 # ffffffffc020b988 <commands+0x210>
ffffffffc0203712:	28300593          	li	a1,643
ffffffffc0203716:	00009517          	auipc	a0,0x9
ffffffffc020371a:	eaa50513          	addi	a0,a0,-342 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020371e:	d81fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203722:	00009697          	auipc	a3,0x9
ffffffffc0203726:	31e68693          	addi	a3,a3,798 # ffffffffc020ca40 <default_pmm_manager+0x5d0>
ffffffffc020372a:	00008617          	auipc	a2,0x8
ffffffffc020372e:	25e60613          	addi	a2,a2,606 # ffffffffc020b988 <commands+0x210>
ffffffffc0203732:	2a000593          	li	a1,672
ffffffffc0203736:	00009517          	auipc	a0,0x9
ffffffffc020373a:	e8a50513          	addi	a0,a0,-374 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020373e:	d61fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203742:	00009617          	auipc	a2,0x9
ffffffffc0203746:	d6660613          	addi	a2,a2,-666 # ffffffffc020c4a8 <default_pmm_manager+0x38>
ffffffffc020374a:	07100593          	li	a1,113
ffffffffc020374e:	00009517          	auipc	a0,0x9
ffffffffc0203752:	d8250513          	addi	a0,a0,-638 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0203756:	d49fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020375a:	86a2                	mv	a3,s0
ffffffffc020375c:	00009617          	auipc	a2,0x9
ffffffffc0203760:	df460613          	addi	a2,a2,-524 # ffffffffc020c550 <default_pmm_manager+0xe0>
ffffffffc0203764:	0ca00593          	li	a1,202
ffffffffc0203768:	00009517          	auipc	a0,0x9
ffffffffc020376c:	e5850513          	addi	a0,a0,-424 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203770:	d2ffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203774:	00009617          	auipc	a2,0x9
ffffffffc0203778:	ddc60613          	addi	a2,a2,-548 # ffffffffc020c550 <default_pmm_manager+0xe0>
ffffffffc020377c:	08100593          	li	a1,129
ffffffffc0203780:	00009517          	auipc	a0,0x9
ffffffffc0203784:	e4050513          	addi	a0,a0,-448 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203788:	d17fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020378c:	00009697          	auipc	a3,0x9
ffffffffc0203790:	12468693          	addi	a3,a3,292 # ffffffffc020c8b0 <default_pmm_manager+0x440>
ffffffffc0203794:	00008617          	auipc	a2,0x8
ffffffffc0203798:	1f460613          	addi	a2,a2,500 # ffffffffc020b988 <commands+0x210>
ffffffffc020379c:	28200593          	li	a1,642
ffffffffc02037a0:	00009517          	auipc	a0,0x9
ffffffffc02037a4:	e2050513          	addi	a0,a0,-480 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02037a8:	cf7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037ac:	00009697          	auipc	a3,0x9
ffffffffc02037b0:	04468693          	addi	a3,a3,68 # ffffffffc020c7f0 <default_pmm_manager+0x380>
ffffffffc02037b4:	00008617          	auipc	a2,0x8
ffffffffc02037b8:	1d460613          	addi	a2,a2,468 # ffffffffc020b988 <commands+0x210>
ffffffffc02037bc:	27600593          	li	a1,630
ffffffffc02037c0:	00009517          	auipc	a0,0x9
ffffffffc02037c4:	e0050513          	addi	a0,a0,-512 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02037c8:	cd7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037cc:	985fe0ef          	jal	ra,ffffffffc0202150 <pte2page.part.0>
ffffffffc02037d0:	00009697          	auipc	a3,0x9
ffffffffc02037d4:	05068693          	addi	a3,a3,80 # ffffffffc020c820 <default_pmm_manager+0x3b0>
ffffffffc02037d8:	00008617          	auipc	a2,0x8
ffffffffc02037dc:	1b060613          	addi	a2,a2,432 # ffffffffc020b988 <commands+0x210>
ffffffffc02037e0:	27900593          	li	a1,633
ffffffffc02037e4:	00009517          	auipc	a0,0x9
ffffffffc02037e8:	ddc50513          	addi	a0,a0,-548 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02037ec:	cb3fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037f0:	00009697          	auipc	a3,0x9
ffffffffc02037f4:	fd068693          	addi	a3,a3,-48 # ffffffffc020c7c0 <default_pmm_manager+0x350>
ffffffffc02037f8:	00008617          	auipc	a2,0x8
ffffffffc02037fc:	19060613          	addi	a2,a2,400 # ffffffffc020b988 <commands+0x210>
ffffffffc0203800:	27200593          	li	a1,626
ffffffffc0203804:	00009517          	auipc	a0,0x9
ffffffffc0203808:	dbc50513          	addi	a0,a0,-580 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020380c:	c93fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203810:	00009697          	auipc	a3,0x9
ffffffffc0203814:	04068693          	addi	a3,a3,64 # ffffffffc020c850 <default_pmm_manager+0x3e0>
ffffffffc0203818:	00008617          	auipc	a2,0x8
ffffffffc020381c:	17060613          	addi	a2,a2,368 # ffffffffc020b988 <commands+0x210>
ffffffffc0203820:	27a00593          	li	a1,634
ffffffffc0203824:	00009517          	auipc	a0,0x9
ffffffffc0203828:	d9c50513          	addi	a0,a0,-612 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020382c:	c73fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203830:	00009617          	auipc	a2,0x9
ffffffffc0203834:	c7860613          	addi	a2,a2,-904 # ffffffffc020c4a8 <default_pmm_manager+0x38>
ffffffffc0203838:	27d00593          	li	a1,637
ffffffffc020383c:	00009517          	auipc	a0,0x9
ffffffffc0203840:	d8450513          	addi	a0,a0,-636 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203844:	c5bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203848:	00009697          	auipc	a3,0x9
ffffffffc020384c:	02068693          	addi	a3,a3,32 # ffffffffc020c868 <default_pmm_manager+0x3f8>
ffffffffc0203850:	00008617          	auipc	a2,0x8
ffffffffc0203854:	13860613          	addi	a2,a2,312 # ffffffffc020b988 <commands+0x210>
ffffffffc0203858:	27b00593          	li	a1,635
ffffffffc020385c:	00009517          	auipc	a0,0x9
ffffffffc0203860:	d6450513          	addi	a0,a0,-668 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203864:	c3bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203868:	86ca                	mv	a3,s2
ffffffffc020386a:	00009617          	auipc	a2,0x9
ffffffffc020386e:	ce660613          	addi	a2,a2,-794 # ffffffffc020c550 <default_pmm_manager+0xe0>
ffffffffc0203872:	0c600593          	li	a1,198
ffffffffc0203876:	00009517          	auipc	a0,0x9
ffffffffc020387a:	d4a50513          	addi	a0,a0,-694 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020387e:	c21fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203882:	00009697          	auipc	a3,0x9
ffffffffc0203886:	14668693          	addi	a3,a3,326 # ffffffffc020c9c8 <default_pmm_manager+0x558>
ffffffffc020388a:	00008617          	auipc	a2,0x8
ffffffffc020388e:	0fe60613          	addi	a2,a2,254 # ffffffffc020b988 <commands+0x210>
ffffffffc0203892:	29600593          	li	a1,662
ffffffffc0203896:	00009517          	auipc	a0,0x9
ffffffffc020389a:	d2a50513          	addi	a0,a0,-726 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc020389e:	c01fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02038a2:	00009697          	auipc	a3,0x9
ffffffffc02038a6:	15668693          	addi	a3,a3,342 # ffffffffc020c9f8 <default_pmm_manager+0x588>
ffffffffc02038aa:	00008617          	auipc	a2,0x8
ffffffffc02038ae:	0de60613          	addi	a2,a2,222 # ffffffffc020b988 <commands+0x210>
ffffffffc02038b2:	29500593          	li	a1,661
ffffffffc02038b6:	00009517          	auipc	a0,0x9
ffffffffc02038ba:	d0a50513          	addi	a0,a0,-758 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc02038be:	be1fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02038c2 <copy_range>:
ffffffffc02038c2:	7159                	addi	sp,sp,-112
ffffffffc02038c4:	00d667b3          	or	a5,a2,a3
ffffffffc02038c8:	f486                	sd	ra,104(sp)
ffffffffc02038ca:	f0a2                	sd	s0,96(sp)
ffffffffc02038cc:	eca6                	sd	s1,88(sp)
ffffffffc02038ce:	e8ca                	sd	s2,80(sp)
ffffffffc02038d0:	e4ce                	sd	s3,72(sp)
ffffffffc02038d2:	e0d2                	sd	s4,64(sp)
ffffffffc02038d4:	fc56                	sd	s5,56(sp)
ffffffffc02038d6:	f85a                	sd	s6,48(sp)
ffffffffc02038d8:	f45e                	sd	s7,40(sp)
ffffffffc02038da:	f062                	sd	s8,32(sp)
ffffffffc02038dc:	ec66                	sd	s9,24(sp)
ffffffffc02038de:	e86a                	sd	s10,16(sp)
ffffffffc02038e0:	e46e                	sd	s11,8(sp)
ffffffffc02038e2:	17d2                	slli	a5,a5,0x34
ffffffffc02038e4:	20079f63          	bnez	a5,ffffffffc0203b02 <copy_range+0x240>
ffffffffc02038e8:	002007b7          	lui	a5,0x200
ffffffffc02038ec:	8432                	mv	s0,a2
ffffffffc02038ee:	1af66263          	bltu	a2,a5,ffffffffc0203a92 <copy_range+0x1d0>
ffffffffc02038f2:	8936                	mv	s2,a3
ffffffffc02038f4:	18d67f63          	bgeu	a2,a3,ffffffffc0203a92 <copy_range+0x1d0>
ffffffffc02038f8:	4785                	li	a5,1
ffffffffc02038fa:	07fe                	slli	a5,a5,0x1f
ffffffffc02038fc:	18d7eb63          	bltu	a5,a3,ffffffffc0203a92 <copy_range+0x1d0>
ffffffffc0203900:	5b7d                	li	s6,-1
ffffffffc0203902:	8aaa                	mv	s5,a0
ffffffffc0203904:	89ae                	mv	s3,a1
ffffffffc0203906:	6a05                	lui	s4,0x1
ffffffffc0203908:	00093c17          	auipc	s8,0x93
ffffffffc020390c:	f98c0c13          	addi	s8,s8,-104 # ffffffffc02968a0 <npage>
ffffffffc0203910:	00093b97          	auipc	s7,0x93
ffffffffc0203914:	f98b8b93          	addi	s7,s7,-104 # ffffffffc02968a8 <pages>
ffffffffc0203918:	00cb5b13          	srli	s6,s6,0xc
ffffffffc020391c:	00093c97          	auipc	s9,0x93
ffffffffc0203920:	f94c8c93          	addi	s9,s9,-108 # ffffffffc02968b0 <pmm_manager>
ffffffffc0203924:	4601                	li	a2,0
ffffffffc0203926:	85a2                	mv	a1,s0
ffffffffc0203928:	854e                	mv	a0,s3
ffffffffc020392a:	8fbfe0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc020392e:	84aa                	mv	s1,a0
ffffffffc0203930:	0e050c63          	beqz	a0,ffffffffc0203a28 <copy_range+0x166>
ffffffffc0203934:	611c                	ld	a5,0(a0)
ffffffffc0203936:	8b85                	andi	a5,a5,1
ffffffffc0203938:	e785                	bnez	a5,ffffffffc0203960 <copy_range+0x9e>
ffffffffc020393a:	9452                	add	s0,s0,s4
ffffffffc020393c:	ff2464e3          	bltu	s0,s2,ffffffffc0203924 <copy_range+0x62>
ffffffffc0203940:	4501                	li	a0,0
ffffffffc0203942:	70a6                	ld	ra,104(sp)
ffffffffc0203944:	7406                	ld	s0,96(sp)
ffffffffc0203946:	64e6                	ld	s1,88(sp)
ffffffffc0203948:	6946                	ld	s2,80(sp)
ffffffffc020394a:	69a6                	ld	s3,72(sp)
ffffffffc020394c:	6a06                	ld	s4,64(sp)
ffffffffc020394e:	7ae2                	ld	s5,56(sp)
ffffffffc0203950:	7b42                	ld	s6,48(sp)
ffffffffc0203952:	7ba2                	ld	s7,40(sp)
ffffffffc0203954:	7c02                	ld	s8,32(sp)
ffffffffc0203956:	6ce2                	ld	s9,24(sp)
ffffffffc0203958:	6d42                	ld	s10,16(sp)
ffffffffc020395a:	6da2                	ld	s11,8(sp)
ffffffffc020395c:	6165                	addi	sp,sp,112
ffffffffc020395e:	8082                	ret
ffffffffc0203960:	4605                	li	a2,1
ffffffffc0203962:	85a2                	mv	a1,s0
ffffffffc0203964:	8556                	mv	a0,s5
ffffffffc0203966:	8bffe0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc020396a:	c56d                	beqz	a0,ffffffffc0203a54 <copy_range+0x192>
ffffffffc020396c:	609c                	ld	a5,0(s1)
ffffffffc020396e:	0017f713          	andi	a4,a5,1
ffffffffc0203972:	01f7f493          	andi	s1,a5,31
ffffffffc0203976:	16070a63          	beqz	a4,ffffffffc0203aea <copy_range+0x228>
ffffffffc020397a:	000c3683          	ld	a3,0(s8)
ffffffffc020397e:	078a                	slli	a5,a5,0x2
ffffffffc0203980:	00c7d713          	srli	a4,a5,0xc
ffffffffc0203984:	14d77763          	bgeu	a4,a3,ffffffffc0203ad2 <copy_range+0x210>
ffffffffc0203988:	000bb783          	ld	a5,0(s7)
ffffffffc020398c:	fff806b7          	lui	a3,0xfff80
ffffffffc0203990:	9736                	add	a4,a4,a3
ffffffffc0203992:	071a                	slli	a4,a4,0x6
ffffffffc0203994:	00e78db3          	add	s11,a5,a4
ffffffffc0203998:	10002773          	csrr	a4,sstatus
ffffffffc020399c:	8b09                	andi	a4,a4,2
ffffffffc020399e:	e345                	bnez	a4,ffffffffc0203a3e <copy_range+0x17c>
ffffffffc02039a0:	000cb703          	ld	a4,0(s9)
ffffffffc02039a4:	4505                	li	a0,1
ffffffffc02039a6:	6f18                	ld	a4,24(a4)
ffffffffc02039a8:	9702                	jalr	a4
ffffffffc02039aa:	8d2a                	mv	s10,a0
ffffffffc02039ac:	0c0d8363          	beqz	s11,ffffffffc0203a72 <copy_range+0x1b0>
ffffffffc02039b0:	100d0163          	beqz	s10,ffffffffc0203ab2 <copy_range+0x1f0>
ffffffffc02039b4:	000bb703          	ld	a4,0(s7)
ffffffffc02039b8:	000805b7          	lui	a1,0x80
ffffffffc02039bc:	000c3603          	ld	a2,0(s8)
ffffffffc02039c0:	40ed86b3          	sub	a3,s11,a4
ffffffffc02039c4:	8699                	srai	a3,a3,0x6
ffffffffc02039c6:	96ae                	add	a3,a3,a1
ffffffffc02039c8:	0166f7b3          	and	a5,a3,s6
ffffffffc02039cc:	06b2                	slli	a3,a3,0xc
ffffffffc02039ce:	08c7f663          	bgeu	a5,a2,ffffffffc0203a5a <copy_range+0x198>
ffffffffc02039d2:	40ed07b3          	sub	a5,s10,a4
ffffffffc02039d6:	00093717          	auipc	a4,0x93
ffffffffc02039da:	ee270713          	addi	a4,a4,-286 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02039de:	6308                	ld	a0,0(a4)
ffffffffc02039e0:	8799                	srai	a5,a5,0x6
ffffffffc02039e2:	97ae                	add	a5,a5,a1
ffffffffc02039e4:	0167f733          	and	a4,a5,s6
ffffffffc02039e8:	00a685b3          	add	a1,a3,a0
ffffffffc02039ec:	07b2                	slli	a5,a5,0xc
ffffffffc02039ee:	06c77563          	bgeu	a4,a2,ffffffffc0203a58 <copy_range+0x196>
ffffffffc02039f2:	6605                	lui	a2,0x1
ffffffffc02039f4:	953e                	add	a0,a0,a5
ffffffffc02039f6:	2fd070ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc02039fa:	86a6                	mv	a3,s1
ffffffffc02039fc:	8622                	mv	a2,s0
ffffffffc02039fe:	85ea                	mv	a1,s10
ffffffffc0203a00:	8556                	mv	a0,s5
ffffffffc0203a02:	fd9fe0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0203a06:	d915                	beqz	a0,ffffffffc020393a <copy_range+0x78>
ffffffffc0203a08:	00009697          	auipc	a3,0x9
ffffffffc0203a0c:	26068693          	addi	a3,a3,608 # ffffffffc020cc68 <default_pmm_manager+0x7f8>
ffffffffc0203a10:	00008617          	auipc	a2,0x8
ffffffffc0203a14:	f7860613          	addi	a2,a2,-136 # ffffffffc020b988 <commands+0x210>
ffffffffc0203a18:	20e00593          	li	a1,526
ffffffffc0203a1c:	00009517          	auipc	a0,0x9
ffffffffc0203a20:	ba450513          	addi	a0,a0,-1116 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203a24:	a7bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203a28:	00200637          	lui	a2,0x200
ffffffffc0203a2c:	9432                	add	s0,s0,a2
ffffffffc0203a2e:	ffe00637          	lui	a2,0xffe00
ffffffffc0203a32:	8c71                	and	s0,s0,a2
ffffffffc0203a34:	f00406e3          	beqz	s0,ffffffffc0203940 <copy_range+0x7e>
ffffffffc0203a38:	ef2466e3          	bltu	s0,s2,ffffffffc0203924 <copy_range+0x62>
ffffffffc0203a3c:	b711                	j	ffffffffc0203940 <copy_range+0x7e>
ffffffffc0203a3e:	a34fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203a42:	000cb703          	ld	a4,0(s9)
ffffffffc0203a46:	4505                	li	a0,1
ffffffffc0203a48:	6f18                	ld	a4,24(a4)
ffffffffc0203a4a:	9702                	jalr	a4
ffffffffc0203a4c:	8d2a                	mv	s10,a0
ffffffffc0203a4e:	a1efd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203a52:	bfa9                	j	ffffffffc02039ac <copy_range+0xea>
ffffffffc0203a54:	5571                	li	a0,-4
ffffffffc0203a56:	b5f5                	j	ffffffffc0203942 <copy_range+0x80>
ffffffffc0203a58:	86be                	mv	a3,a5
ffffffffc0203a5a:	00009617          	auipc	a2,0x9
ffffffffc0203a5e:	a4e60613          	addi	a2,a2,-1458 # ffffffffc020c4a8 <default_pmm_manager+0x38>
ffffffffc0203a62:	07100593          	li	a1,113
ffffffffc0203a66:	00009517          	auipc	a0,0x9
ffffffffc0203a6a:	a6a50513          	addi	a0,a0,-1430 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0203a6e:	a31fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203a72:	00009697          	auipc	a3,0x9
ffffffffc0203a76:	1d668693          	addi	a3,a3,470 # ffffffffc020cc48 <default_pmm_manager+0x7d8>
ffffffffc0203a7a:	00008617          	auipc	a2,0x8
ffffffffc0203a7e:	f0e60613          	addi	a2,a2,-242 # ffffffffc020b988 <commands+0x210>
ffffffffc0203a82:	1ce00593          	li	a1,462
ffffffffc0203a86:	00009517          	auipc	a0,0x9
ffffffffc0203a8a:	b3a50513          	addi	a0,a0,-1222 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203a8e:	a11fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203a92:	00009697          	auipc	a3,0x9
ffffffffc0203a96:	b9668693          	addi	a3,a3,-1130 # ffffffffc020c628 <default_pmm_manager+0x1b8>
ffffffffc0203a9a:	00008617          	auipc	a2,0x8
ffffffffc0203a9e:	eee60613          	addi	a2,a2,-274 # ffffffffc020b988 <commands+0x210>
ffffffffc0203aa2:	1b600593          	li	a1,438
ffffffffc0203aa6:	00009517          	auipc	a0,0x9
ffffffffc0203aaa:	b1a50513          	addi	a0,a0,-1254 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203aae:	9f1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203ab2:	00009697          	auipc	a3,0x9
ffffffffc0203ab6:	1a668693          	addi	a3,a3,422 # ffffffffc020cc58 <default_pmm_manager+0x7e8>
ffffffffc0203aba:	00008617          	auipc	a2,0x8
ffffffffc0203abe:	ece60613          	addi	a2,a2,-306 # ffffffffc020b988 <commands+0x210>
ffffffffc0203ac2:	1cf00593          	li	a1,463
ffffffffc0203ac6:	00009517          	auipc	a0,0x9
ffffffffc0203aca:	afa50513          	addi	a0,a0,-1286 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203ace:	9d1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203ad2:	00009617          	auipc	a2,0x9
ffffffffc0203ad6:	aa660613          	addi	a2,a2,-1370 # ffffffffc020c578 <default_pmm_manager+0x108>
ffffffffc0203ada:	06900593          	li	a1,105
ffffffffc0203ade:	00009517          	auipc	a0,0x9
ffffffffc0203ae2:	9f250513          	addi	a0,a0,-1550 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0203ae6:	9b9fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203aea:	00009617          	auipc	a2,0x9
ffffffffc0203aee:	aae60613          	addi	a2,a2,-1362 # ffffffffc020c598 <default_pmm_manager+0x128>
ffffffffc0203af2:	07f00593          	li	a1,127
ffffffffc0203af6:	00009517          	auipc	a0,0x9
ffffffffc0203afa:	9da50513          	addi	a0,a0,-1574 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0203afe:	9a1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203b02:	00009697          	auipc	a3,0x9
ffffffffc0203b06:	af668693          	addi	a3,a3,-1290 # ffffffffc020c5f8 <default_pmm_manager+0x188>
ffffffffc0203b0a:	00008617          	auipc	a2,0x8
ffffffffc0203b0e:	e7e60613          	addi	a2,a2,-386 # ffffffffc020b988 <commands+0x210>
ffffffffc0203b12:	1b500593          	li	a1,437
ffffffffc0203b16:	00009517          	auipc	a0,0x9
ffffffffc0203b1a:	aaa50513          	addi	a0,a0,-1366 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203b1e:	981fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203b22 <pgdir_alloc_page>:
ffffffffc0203b22:	7179                	addi	sp,sp,-48
ffffffffc0203b24:	ec26                	sd	s1,24(sp)
ffffffffc0203b26:	e84a                	sd	s2,16(sp)
ffffffffc0203b28:	e052                	sd	s4,0(sp)
ffffffffc0203b2a:	f406                	sd	ra,40(sp)
ffffffffc0203b2c:	f022                	sd	s0,32(sp)
ffffffffc0203b2e:	e44e                	sd	s3,8(sp)
ffffffffc0203b30:	8a2a                	mv	s4,a0
ffffffffc0203b32:	84ae                	mv	s1,a1
ffffffffc0203b34:	8932                	mv	s2,a2
ffffffffc0203b36:	100027f3          	csrr	a5,sstatus
ffffffffc0203b3a:	8b89                	andi	a5,a5,2
ffffffffc0203b3c:	00093997          	auipc	s3,0x93
ffffffffc0203b40:	d7498993          	addi	s3,s3,-652 # ffffffffc02968b0 <pmm_manager>
ffffffffc0203b44:	ef8d                	bnez	a5,ffffffffc0203b7e <pgdir_alloc_page+0x5c>
ffffffffc0203b46:	0009b783          	ld	a5,0(s3)
ffffffffc0203b4a:	4505                	li	a0,1
ffffffffc0203b4c:	6f9c                	ld	a5,24(a5)
ffffffffc0203b4e:	9782                	jalr	a5
ffffffffc0203b50:	842a                	mv	s0,a0
ffffffffc0203b52:	cc09                	beqz	s0,ffffffffc0203b6c <pgdir_alloc_page+0x4a>
ffffffffc0203b54:	86ca                	mv	a3,s2
ffffffffc0203b56:	8626                	mv	a2,s1
ffffffffc0203b58:	85a2                	mv	a1,s0
ffffffffc0203b5a:	8552                	mv	a0,s4
ffffffffc0203b5c:	e7ffe0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0203b60:	e915                	bnez	a0,ffffffffc0203b94 <pgdir_alloc_page+0x72>
ffffffffc0203b62:	4018                	lw	a4,0(s0)
ffffffffc0203b64:	fc04                	sd	s1,56(s0)
ffffffffc0203b66:	4785                	li	a5,1
ffffffffc0203b68:	04f71e63          	bne	a4,a5,ffffffffc0203bc4 <pgdir_alloc_page+0xa2>
ffffffffc0203b6c:	70a2                	ld	ra,40(sp)
ffffffffc0203b6e:	8522                	mv	a0,s0
ffffffffc0203b70:	7402                	ld	s0,32(sp)
ffffffffc0203b72:	64e2                	ld	s1,24(sp)
ffffffffc0203b74:	6942                	ld	s2,16(sp)
ffffffffc0203b76:	69a2                	ld	s3,8(sp)
ffffffffc0203b78:	6a02                	ld	s4,0(sp)
ffffffffc0203b7a:	6145                	addi	sp,sp,48
ffffffffc0203b7c:	8082                	ret
ffffffffc0203b7e:	8f4fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203b82:	0009b783          	ld	a5,0(s3)
ffffffffc0203b86:	4505                	li	a0,1
ffffffffc0203b88:	6f9c                	ld	a5,24(a5)
ffffffffc0203b8a:	9782                	jalr	a5
ffffffffc0203b8c:	842a                	mv	s0,a0
ffffffffc0203b8e:	8defd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203b92:	b7c1                	j	ffffffffc0203b52 <pgdir_alloc_page+0x30>
ffffffffc0203b94:	100027f3          	csrr	a5,sstatus
ffffffffc0203b98:	8b89                	andi	a5,a5,2
ffffffffc0203b9a:	eb89                	bnez	a5,ffffffffc0203bac <pgdir_alloc_page+0x8a>
ffffffffc0203b9c:	0009b783          	ld	a5,0(s3)
ffffffffc0203ba0:	8522                	mv	a0,s0
ffffffffc0203ba2:	4585                	li	a1,1
ffffffffc0203ba4:	739c                	ld	a5,32(a5)
ffffffffc0203ba6:	4401                	li	s0,0
ffffffffc0203ba8:	9782                	jalr	a5
ffffffffc0203baa:	b7c9                	j	ffffffffc0203b6c <pgdir_alloc_page+0x4a>
ffffffffc0203bac:	8c6fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203bb0:	0009b783          	ld	a5,0(s3)
ffffffffc0203bb4:	8522                	mv	a0,s0
ffffffffc0203bb6:	4585                	li	a1,1
ffffffffc0203bb8:	739c                	ld	a5,32(a5)
ffffffffc0203bba:	4401                	li	s0,0
ffffffffc0203bbc:	9782                	jalr	a5
ffffffffc0203bbe:	8aefd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203bc2:	b76d                	j	ffffffffc0203b6c <pgdir_alloc_page+0x4a>
ffffffffc0203bc4:	00009697          	auipc	a3,0x9
ffffffffc0203bc8:	0b468693          	addi	a3,a3,180 # ffffffffc020cc78 <default_pmm_manager+0x808>
ffffffffc0203bcc:	00008617          	auipc	a2,0x8
ffffffffc0203bd0:	dbc60613          	addi	a2,a2,-580 # ffffffffc020b988 <commands+0x210>
ffffffffc0203bd4:	25700593          	li	a1,599
ffffffffc0203bd8:	00009517          	auipc	a0,0x9
ffffffffc0203bdc:	9e850513          	addi	a0,a0,-1560 # ffffffffc020c5c0 <default_pmm_manager+0x150>
ffffffffc0203be0:	8bffc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203be4 <check_vma_overlap.part.0>:
ffffffffc0203be4:	1141                	addi	sp,sp,-16
ffffffffc0203be6:	00009697          	auipc	a3,0x9
ffffffffc0203bea:	0aa68693          	addi	a3,a3,170 # ffffffffc020cc90 <default_pmm_manager+0x820>
ffffffffc0203bee:	00008617          	auipc	a2,0x8
ffffffffc0203bf2:	d9a60613          	addi	a2,a2,-614 # ffffffffc020b988 <commands+0x210>
ffffffffc0203bf6:	07600593          	li	a1,118
ffffffffc0203bfa:	00009517          	auipc	a0,0x9
ffffffffc0203bfe:	0b650513          	addi	a0,a0,182 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc0203c02:	e406                	sd	ra,8(sp)
ffffffffc0203c04:	89bfc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203c08 <mm_create>:
ffffffffc0203c08:	1141                	addi	sp,sp,-16
ffffffffc0203c0a:	05800513          	li	a0,88
ffffffffc0203c0e:	e022                	sd	s0,0(sp)
ffffffffc0203c10:	e406                	sd	ra,8(sp)
ffffffffc0203c12:	b7cfe0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0203c16:	842a                	mv	s0,a0
ffffffffc0203c18:	c115                	beqz	a0,ffffffffc0203c3c <mm_create+0x34>
ffffffffc0203c1a:	e408                	sd	a0,8(s0)
ffffffffc0203c1c:	e008                	sd	a0,0(s0)
ffffffffc0203c1e:	00053823          	sd	zero,16(a0)
ffffffffc0203c22:	00053c23          	sd	zero,24(a0)
ffffffffc0203c26:	02052023          	sw	zero,32(a0)
ffffffffc0203c2a:	02053423          	sd	zero,40(a0)
ffffffffc0203c2e:	02052823          	sw	zero,48(a0)
ffffffffc0203c32:	4585                	li	a1,1
ffffffffc0203c34:	03850513          	addi	a0,a0,56
ffffffffc0203c38:	123000ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc0203c3c:	60a2                	ld	ra,8(sp)
ffffffffc0203c3e:	8522                	mv	a0,s0
ffffffffc0203c40:	6402                	ld	s0,0(sp)
ffffffffc0203c42:	0141                	addi	sp,sp,16
ffffffffc0203c44:	8082                	ret

ffffffffc0203c46 <find_vma>:
ffffffffc0203c46:	86aa                	mv	a3,a0
ffffffffc0203c48:	c505                	beqz	a0,ffffffffc0203c70 <find_vma+0x2a>
ffffffffc0203c4a:	6908                	ld	a0,16(a0)
ffffffffc0203c4c:	c501                	beqz	a0,ffffffffc0203c54 <find_vma+0xe>
ffffffffc0203c4e:	651c                	ld	a5,8(a0)
ffffffffc0203c50:	02f5f263          	bgeu	a1,a5,ffffffffc0203c74 <find_vma+0x2e>
ffffffffc0203c54:	669c                	ld	a5,8(a3)
ffffffffc0203c56:	00f68d63          	beq	a3,a5,ffffffffc0203c70 <find_vma+0x2a>
ffffffffc0203c5a:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_bin_sfs_img_size+0x18ace8>
ffffffffc0203c5e:	00e5e663          	bltu	a1,a4,ffffffffc0203c6a <find_vma+0x24>
ffffffffc0203c62:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203c66:	00e5ec63          	bltu	a1,a4,ffffffffc0203c7e <find_vma+0x38>
ffffffffc0203c6a:	679c                	ld	a5,8(a5)
ffffffffc0203c6c:	fef697e3          	bne	a3,a5,ffffffffc0203c5a <find_vma+0x14>
ffffffffc0203c70:	4501                	li	a0,0
ffffffffc0203c72:	8082                	ret
ffffffffc0203c74:	691c                	ld	a5,16(a0)
ffffffffc0203c76:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0203c54 <find_vma+0xe>
ffffffffc0203c7a:	ea88                	sd	a0,16(a3)
ffffffffc0203c7c:	8082                	ret
ffffffffc0203c7e:	fe078513          	addi	a0,a5,-32
ffffffffc0203c82:	ea88                	sd	a0,16(a3)
ffffffffc0203c84:	8082                	ret

ffffffffc0203c86 <insert_vma_struct>:
ffffffffc0203c86:	6590                	ld	a2,8(a1)
ffffffffc0203c88:	0105b803          	ld	a6,16(a1) # 80010 <_binary_bin_sfs_img_size+0xad10>
ffffffffc0203c8c:	1141                	addi	sp,sp,-16
ffffffffc0203c8e:	e406                	sd	ra,8(sp)
ffffffffc0203c90:	87aa                	mv	a5,a0
ffffffffc0203c92:	01066763          	bltu	a2,a6,ffffffffc0203ca0 <insert_vma_struct+0x1a>
ffffffffc0203c96:	a085                	j	ffffffffc0203cf6 <insert_vma_struct+0x70>
ffffffffc0203c98:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203c9c:	04e66863          	bltu	a2,a4,ffffffffc0203cec <insert_vma_struct+0x66>
ffffffffc0203ca0:	86be                	mv	a3,a5
ffffffffc0203ca2:	679c                	ld	a5,8(a5)
ffffffffc0203ca4:	fef51ae3          	bne	a0,a5,ffffffffc0203c98 <insert_vma_struct+0x12>
ffffffffc0203ca8:	02a68463          	beq	a3,a0,ffffffffc0203cd0 <insert_vma_struct+0x4a>
ffffffffc0203cac:	ff06b703          	ld	a4,-16(a3)
ffffffffc0203cb0:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203cb4:	08e8f163          	bgeu	a7,a4,ffffffffc0203d36 <insert_vma_struct+0xb0>
ffffffffc0203cb8:	04e66f63          	bltu	a2,a4,ffffffffc0203d16 <insert_vma_struct+0x90>
ffffffffc0203cbc:	00f50a63          	beq	a0,a5,ffffffffc0203cd0 <insert_vma_struct+0x4a>
ffffffffc0203cc0:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203cc4:	05076963          	bltu	a4,a6,ffffffffc0203d16 <insert_vma_struct+0x90>
ffffffffc0203cc8:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203ccc:	02c77363          	bgeu	a4,a2,ffffffffc0203cf2 <insert_vma_struct+0x6c>
ffffffffc0203cd0:	5118                	lw	a4,32(a0)
ffffffffc0203cd2:	e188                	sd	a0,0(a1)
ffffffffc0203cd4:	02058613          	addi	a2,a1,32
ffffffffc0203cd8:	e390                	sd	a2,0(a5)
ffffffffc0203cda:	e690                	sd	a2,8(a3)
ffffffffc0203cdc:	60a2                	ld	ra,8(sp)
ffffffffc0203cde:	f59c                	sd	a5,40(a1)
ffffffffc0203ce0:	f194                	sd	a3,32(a1)
ffffffffc0203ce2:	0017079b          	addiw	a5,a4,1
ffffffffc0203ce6:	d11c                	sw	a5,32(a0)
ffffffffc0203ce8:	0141                	addi	sp,sp,16
ffffffffc0203cea:	8082                	ret
ffffffffc0203cec:	fca690e3          	bne	a3,a0,ffffffffc0203cac <insert_vma_struct+0x26>
ffffffffc0203cf0:	bfd1                	j	ffffffffc0203cc4 <insert_vma_struct+0x3e>
ffffffffc0203cf2:	ef3ff0ef          	jal	ra,ffffffffc0203be4 <check_vma_overlap.part.0>
ffffffffc0203cf6:	00009697          	auipc	a3,0x9
ffffffffc0203cfa:	fca68693          	addi	a3,a3,-54 # ffffffffc020ccc0 <default_pmm_manager+0x850>
ffffffffc0203cfe:	00008617          	auipc	a2,0x8
ffffffffc0203d02:	c8a60613          	addi	a2,a2,-886 # ffffffffc020b988 <commands+0x210>
ffffffffc0203d06:	07c00593          	li	a1,124
ffffffffc0203d0a:	00009517          	auipc	a0,0x9
ffffffffc0203d0e:	fa650513          	addi	a0,a0,-90 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc0203d12:	f8cfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203d16:	00009697          	auipc	a3,0x9
ffffffffc0203d1a:	fea68693          	addi	a3,a3,-22 # ffffffffc020cd00 <default_pmm_manager+0x890>
ffffffffc0203d1e:	00008617          	auipc	a2,0x8
ffffffffc0203d22:	c6a60613          	addi	a2,a2,-918 # ffffffffc020b988 <commands+0x210>
ffffffffc0203d26:	07500593          	li	a1,117
ffffffffc0203d2a:	00009517          	auipc	a0,0x9
ffffffffc0203d2e:	f8650513          	addi	a0,a0,-122 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc0203d32:	f6cfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203d36:	00009697          	auipc	a3,0x9
ffffffffc0203d3a:	faa68693          	addi	a3,a3,-86 # ffffffffc020cce0 <default_pmm_manager+0x870>
ffffffffc0203d3e:	00008617          	auipc	a2,0x8
ffffffffc0203d42:	c4a60613          	addi	a2,a2,-950 # ffffffffc020b988 <commands+0x210>
ffffffffc0203d46:	07400593          	li	a1,116
ffffffffc0203d4a:	00009517          	auipc	a0,0x9
ffffffffc0203d4e:	f6650513          	addi	a0,a0,-154 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc0203d52:	f4cfc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203d56 <mm_destroy>:
ffffffffc0203d56:	591c                	lw	a5,48(a0)
ffffffffc0203d58:	1141                	addi	sp,sp,-16
ffffffffc0203d5a:	e406                	sd	ra,8(sp)
ffffffffc0203d5c:	e022                	sd	s0,0(sp)
ffffffffc0203d5e:	e78d                	bnez	a5,ffffffffc0203d88 <mm_destroy+0x32>
ffffffffc0203d60:	842a                	mv	s0,a0
ffffffffc0203d62:	6508                	ld	a0,8(a0)
ffffffffc0203d64:	00a40c63          	beq	s0,a0,ffffffffc0203d7c <mm_destroy+0x26>
ffffffffc0203d68:	6118                	ld	a4,0(a0)
ffffffffc0203d6a:	651c                	ld	a5,8(a0)
ffffffffc0203d6c:	1501                	addi	a0,a0,-32
ffffffffc0203d6e:	e71c                	sd	a5,8(a4)
ffffffffc0203d70:	e398                	sd	a4,0(a5)
ffffffffc0203d72:	accfe0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0203d76:	6408                	ld	a0,8(s0)
ffffffffc0203d78:	fea418e3          	bne	s0,a0,ffffffffc0203d68 <mm_destroy+0x12>
ffffffffc0203d7c:	8522                	mv	a0,s0
ffffffffc0203d7e:	6402                	ld	s0,0(sp)
ffffffffc0203d80:	60a2                	ld	ra,8(sp)
ffffffffc0203d82:	0141                	addi	sp,sp,16
ffffffffc0203d84:	abafe06f          	j	ffffffffc020203e <kfree>
ffffffffc0203d88:	00009697          	auipc	a3,0x9
ffffffffc0203d8c:	f9868693          	addi	a3,a3,-104 # ffffffffc020cd20 <default_pmm_manager+0x8b0>
ffffffffc0203d90:	00008617          	auipc	a2,0x8
ffffffffc0203d94:	bf860613          	addi	a2,a2,-1032 # ffffffffc020b988 <commands+0x210>
ffffffffc0203d98:	0a000593          	li	a1,160
ffffffffc0203d9c:	00009517          	auipc	a0,0x9
ffffffffc0203da0:	f1450513          	addi	a0,a0,-236 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc0203da4:	efafc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203da8 <mm_map>:
ffffffffc0203da8:	7139                	addi	sp,sp,-64
ffffffffc0203daa:	f822                	sd	s0,48(sp)
ffffffffc0203dac:	6405                	lui	s0,0x1
ffffffffc0203dae:	147d                	addi	s0,s0,-1
ffffffffc0203db0:	77fd                	lui	a5,0xfffff
ffffffffc0203db2:	9622                	add	a2,a2,s0
ffffffffc0203db4:	962e                	add	a2,a2,a1
ffffffffc0203db6:	f426                	sd	s1,40(sp)
ffffffffc0203db8:	fc06                	sd	ra,56(sp)
ffffffffc0203dba:	00f5f4b3          	and	s1,a1,a5
ffffffffc0203dbe:	f04a                	sd	s2,32(sp)
ffffffffc0203dc0:	ec4e                	sd	s3,24(sp)
ffffffffc0203dc2:	e852                	sd	s4,16(sp)
ffffffffc0203dc4:	e456                	sd	s5,8(sp)
ffffffffc0203dc6:	002005b7          	lui	a1,0x200
ffffffffc0203dca:	00f67433          	and	s0,a2,a5
ffffffffc0203dce:	06b4e363          	bltu	s1,a1,ffffffffc0203e34 <mm_map+0x8c>
ffffffffc0203dd2:	0684f163          	bgeu	s1,s0,ffffffffc0203e34 <mm_map+0x8c>
ffffffffc0203dd6:	4785                	li	a5,1
ffffffffc0203dd8:	07fe                	slli	a5,a5,0x1f
ffffffffc0203dda:	0487ed63          	bltu	a5,s0,ffffffffc0203e34 <mm_map+0x8c>
ffffffffc0203dde:	89aa                	mv	s3,a0
ffffffffc0203de0:	cd21                	beqz	a0,ffffffffc0203e38 <mm_map+0x90>
ffffffffc0203de2:	85a6                	mv	a1,s1
ffffffffc0203de4:	8ab6                	mv	s5,a3
ffffffffc0203de6:	8a3a                	mv	s4,a4
ffffffffc0203de8:	e5fff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc0203dec:	c501                	beqz	a0,ffffffffc0203df4 <mm_map+0x4c>
ffffffffc0203dee:	651c                	ld	a5,8(a0)
ffffffffc0203df0:	0487e263          	bltu	a5,s0,ffffffffc0203e34 <mm_map+0x8c>
ffffffffc0203df4:	03000513          	li	a0,48
ffffffffc0203df8:	996fe0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0203dfc:	892a                	mv	s2,a0
ffffffffc0203dfe:	5571                	li	a0,-4
ffffffffc0203e00:	02090163          	beqz	s2,ffffffffc0203e22 <mm_map+0x7a>
ffffffffc0203e04:	854e                	mv	a0,s3
ffffffffc0203e06:	00993423          	sd	s1,8(s2)
ffffffffc0203e0a:	00893823          	sd	s0,16(s2)
ffffffffc0203e0e:	01592c23          	sw	s5,24(s2)
ffffffffc0203e12:	85ca                	mv	a1,s2
ffffffffc0203e14:	e73ff0ef          	jal	ra,ffffffffc0203c86 <insert_vma_struct>
ffffffffc0203e18:	4501                	li	a0,0
ffffffffc0203e1a:	000a0463          	beqz	s4,ffffffffc0203e22 <mm_map+0x7a>
ffffffffc0203e1e:	012a3023          	sd	s2,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0203e22:	70e2                	ld	ra,56(sp)
ffffffffc0203e24:	7442                	ld	s0,48(sp)
ffffffffc0203e26:	74a2                	ld	s1,40(sp)
ffffffffc0203e28:	7902                	ld	s2,32(sp)
ffffffffc0203e2a:	69e2                	ld	s3,24(sp)
ffffffffc0203e2c:	6a42                	ld	s4,16(sp)
ffffffffc0203e2e:	6aa2                	ld	s5,8(sp)
ffffffffc0203e30:	6121                	addi	sp,sp,64
ffffffffc0203e32:	8082                	ret
ffffffffc0203e34:	5575                	li	a0,-3
ffffffffc0203e36:	b7f5                	j	ffffffffc0203e22 <mm_map+0x7a>
ffffffffc0203e38:	00009697          	auipc	a3,0x9
ffffffffc0203e3c:	f0068693          	addi	a3,a3,-256 # ffffffffc020cd38 <default_pmm_manager+0x8c8>
ffffffffc0203e40:	00008617          	auipc	a2,0x8
ffffffffc0203e44:	b4860613          	addi	a2,a2,-1208 # ffffffffc020b988 <commands+0x210>
ffffffffc0203e48:	0b500593          	li	a1,181
ffffffffc0203e4c:	00009517          	auipc	a0,0x9
ffffffffc0203e50:	e6450513          	addi	a0,a0,-412 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc0203e54:	e4afc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203e58 <dup_mmap>:
ffffffffc0203e58:	7139                	addi	sp,sp,-64
ffffffffc0203e5a:	fc06                	sd	ra,56(sp)
ffffffffc0203e5c:	f822                	sd	s0,48(sp)
ffffffffc0203e5e:	f426                	sd	s1,40(sp)
ffffffffc0203e60:	f04a                	sd	s2,32(sp)
ffffffffc0203e62:	ec4e                	sd	s3,24(sp)
ffffffffc0203e64:	e852                	sd	s4,16(sp)
ffffffffc0203e66:	e456                	sd	s5,8(sp)
ffffffffc0203e68:	c52d                	beqz	a0,ffffffffc0203ed2 <dup_mmap+0x7a>
ffffffffc0203e6a:	892a                	mv	s2,a0
ffffffffc0203e6c:	84ae                	mv	s1,a1
ffffffffc0203e6e:	842e                	mv	s0,a1
ffffffffc0203e70:	e595                	bnez	a1,ffffffffc0203e9c <dup_mmap+0x44>
ffffffffc0203e72:	a085                	j	ffffffffc0203ed2 <dup_mmap+0x7a>
ffffffffc0203e74:	854a                	mv	a0,s2
ffffffffc0203e76:	0155b423          	sd	s5,8(a1) # 200008 <_binary_bin_sfs_img_size+0x18ad08>
ffffffffc0203e7a:	0145b823          	sd	s4,16(a1)
ffffffffc0203e7e:	0135ac23          	sw	s3,24(a1)
ffffffffc0203e82:	e05ff0ef          	jal	ra,ffffffffc0203c86 <insert_vma_struct>
ffffffffc0203e86:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_bin_swap_img_size-0x6d10>
ffffffffc0203e8a:	fe843603          	ld	a2,-24(s0)
ffffffffc0203e8e:	6c8c                	ld	a1,24(s1)
ffffffffc0203e90:	01893503          	ld	a0,24(s2)
ffffffffc0203e94:	4701                	li	a4,0
ffffffffc0203e96:	a2dff0ef          	jal	ra,ffffffffc02038c2 <copy_range>
ffffffffc0203e9a:	e105                	bnez	a0,ffffffffc0203eba <dup_mmap+0x62>
ffffffffc0203e9c:	6000                	ld	s0,0(s0)
ffffffffc0203e9e:	02848863          	beq	s1,s0,ffffffffc0203ece <dup_mmap+0x76>
ffffffffc0203ea2:	03000513          	li	a0,48
ffffffffc0203ea6:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203eaa:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203eae:	ff842983          	lw	s3,-8(s0)
ffffffffc0203eb2:	8dcfe0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0203eb6:	85aa                	mv	a1,a0
ffffffffc0203eb8:	fd55                	bnez	a0,ffffffffc0203e74 <dup_mmap+0x1c>
ffffffffc0203eba:	5571                	li	a0,-4
ffffffffc0203ebc:	70e2                	ld	ra,56(sp)
ffffffffc0203ebe:	7442                	ld	s0,48(sp)
ffffffffc0203ec0:	74a2                	ld	s1,40(sp)
ffffffffc0203ec2:	7902                	ld	s2,32(sp)
ffffffffc0203ec4:	69e2                	ld	s3,24(sp)
ffffffffc0203ec6:	6a42                	ld	s4,16(sp)
ffffffffc0203ec8:	6aa2                	ld	s5,8(sp)
ffffffffc0203eca:	6121                	addi	sp,sp,64
ffffffffc0203ecc:	8082                	ret
ffffffffc0203ece:	4501                	li	a0,0
ffffffffc0203ed0:	b7f5                	j	ffffffffc0203ebc <dup_mmap+0x64>
ffffffffc0203ed2:	00009697          	auipc	a3,0x9
ffffffffc0203ed6:	e7668693          	addi	a3,a3,-394 # ffffffffc020cd48 <default_pmm_manager+0x8d8>
ffffffffc0203eda:	00008617          	auipc	a2,0x8
ffffffffc0203ede:	aae60613          	addi	a2,a2,-1362 # ffffffffc020b988 <commands+0x210>
ffffffffc0203ee2:	0d100593          	li	a1,209
ffffffffc0203ee6:	00009517          	auipc	a0,0x9
ffffffffc0203eea:	dca50513          	addi	a0,a0,-566 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc0203eee:	db0fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203ef2 <exit_mmap>:
ffffffffc0203ef2:	1101                	addi	sp,sp,-32
ffffffffc0203ef4:	ec06                	sd	ra,24(sp)
ffffffffc0203ef6:	e822                	sd	s0,16(sp)
ffffffffc0203ef8:	e426                	sd	s1,8(sp)
ffffffffc0203efa:	e04a                	sd	s2,0(sp)
ffffffffc0203efc:	c531                	beqz	a0,ffffffffc0203f48 <exit_mmap+0x56>
ffffffffc0203efe:	591c                	lw	a5,48(a0)
ffffffffc0203f00:	84aa                	mv	s1,a0
ffffffffc0203f02:	e3b9                	bnez	a5,ffffffffc0203f48 <exit_mmap+0x56>
ffffffffc0203f04:	6500                	ld	s0,8(a0)
ffffffffc0203f06:	01853903          	ld	s2,24(a0)
ffffffffc0203f0a:	02850663          	beq	a0,s0,ffffffffc0203f36 <exit_mmap+0x44>
ffffffffc0203f0e:	ff043603          	ld	a2,-16(s0)
ffffffffc0203f12:	fe843583          	ld	a1,-24(s0)
ffffffffc0203f16:	854a                	mv	a0,s2
ffffffffc0203f18:	e4efe0ef          	jal	ra,ffffffffc0202566 <unmap_range>
ffffffffc0203f1c:	6400                	ld	s0,8(s0)
ffffffffc0203f1e:	fe8498e3          	bne	s1,s0,ffffffffc0203f0e <exit_mmap+0x1c>
ffffffffc0203f22:	6400                	ld	s0,8(s0)
ffffffffc0203f24:	00848c63          	beq	s1,s0,ffffffffc0203f3c <exit_mmap+0x4a>
ffffffffc0203f28:	ff043603          	ld	a2,-16(s0)
ffffffffc0203f2c:	fe843583          	ld	a1,-24(s0)
ffffffffc0203f30:	854a                	mv	a0,s2
ffffffffc0203f32:	f7afe0ef          	jal	ra,ffffffffc02026ac <exit_range>
ffffffffc0203f36:	6400                	ld	s0,8(s0)
ffffffffc0203f38:	fe8498e3          	bne	s1,s0,ffffffffc0203f28 <exit_mmap+0x36>
ffffffffc0203f3c:	60e2                	ld	ra,24(sp)
ffffffffc0203f3e:	6442                	ld	s0,16(sp)
ffffffffc0203f40:	64a2                	ld	s1,8(sp)
ffffffffc0203f42:	6902                	ld	s2,0(sp)
ffffffffc0203f44:	6105                	addi	sp,sp,32
ffffffffc0203f46:	8082                	ret
ffffffffc0203f48:	00009697          	auipc	a3,0x9
ffffffffc0203f4c:	e2068693          	addi	a3,a3,-480 # ffffffffc020cd68 <default_pmm_manager+0x8f8>
ffffffffc0203f50:	00008617          	auipc	a2,0x8
ffffffffc0203f54:	a3860613          	addi	a2,a2,-1480 # ffffffffc020b988 <commands+0x210>
ffffffffc0203f58:	0ea00593          	li	a1,234
ffffffffc0203f5c:	00009517          	auipc	a0,0x9
ffffffffc0203f60:	d5450513          	addi	a0,a0,-684 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc0203f64:	d3afc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203f68 <vmm_init>:
ffffffffc0203f68:	7139                	addi	sp,sp,-64
ffffffffc0203f6a:	05800513          	li	a0,88
ffffffffc0203f6e:	fc06                	sd	ra,56(sp)
ffffffffc0203f70:	f822                	sd	s0,48(sp)
ffffffffc0203f72:	f426                	sd	s1,40(sp)
ffffffffc0203f74:	f04a                	sd	s2,32(sp)
ffffffffc0203f76:	ec4e                	sd	s3,24(sp)
ffffffffc0203f78:	e852                	sd	s4,16(sp)
ffffffffc0203f7a:	e456                	sd	s5,8(sp)
ffffffffc0203f7c:	812fe0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0203f80:	2e050963          	beqz	a0,ffffffffc0204272 <vmm_init+0x30a>
ffffffffc0203f84:	e508                	sd	a0,8(a0)
ffffffffc0203f86:	e108                	sd	a0,0(a0)
ffffffffc0203f88:	00053823          	sd	zero,16(a0)
ffffffffc0203f8c:	00053c23          	sd	zero,24(a0)
ffffffffc0203f90:	02052023          	sw	zero,32(a0)
ffffffffc0203f94:	02053423          	sd	zero,40(a0)
ffffffffc0203f98:	02052823          	sw	zero,48(a0)
ffffffffc0203f9c:	84aa                	mv	s1,a0
ffffffffc0203f9e:	4585                	li	a1,1
ffffffffc0203fa0:	03850513          	addi	a0,a0,56
ffffffffc0203fa4:	5b6000ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc0203fa8:	03200413          	li	s0,50
ffffffffc0203fac:	a811                	j	ffffffffc0203fc0 <vmm_init+0x58>
ffffffffc0203fae:	e500                	sd	s0,8(a0)
ffffffffc0203fb0:	e91c                	sd	a5,16(a0)
ffffffffc0203fb2:	00052c23          	sw	zero,24(a0)
ffffffffc0203fb6:	146d                	addi	s0,s0,-5
ffffffffc0203fb8:	8526                	mv	a0,s1
ffffffffc0203fba:	ccdff0ef          	jal	ra,ffffffffc0203c86 <insert_vma_struct>
ffffffffc0203fbe:	c80d                	beqz	s0,ffffffffc0203ff0 <vmm_init+0x88>
ffffffffc0203fc0:	03000513          	li	a0,48
ffffffffc0203fc4:	fcbfd0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0203fc8:	85aa                	mv	a1,a0
ffffffffc0203fca:	00240793          	addi	a5,s0,2
ffffffffc0203fce:	f165                	bnez	a0,ffffffffc0203fae <vmm_init+0x46>
ffffffffc0203fd0:	00009697          	auipc	a3,0x9
ffffffffc0203fd4:	f3068693          	addi	a3,a3,-208 # ffffffffc020cf00 <default_pmm_manager+0xa90>
ffffffffc0203fd8:	00008617          	auipc	a2,0x8
ffffffffc0203fdc:	9b060613          	addi	a2,a2,-1616 # ffffffffc020b988 <commands+0x210>
ffffffffc0203fe0:	12e00593          	li	a1,302
ffffffffc0203fe4:	00009517          	auipc	a0,0x9
ffffffffc0203fe8:	ccc50513          	addi	a0,a0,-820 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc0203fec:	cb2fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203ff0:	03700413          	li	s0,55
ffffffffc0203ff4:	1f900913          	li	s2,505
ffffffffc0203ff8:	a819                	j	ffffffffc020400e <vmm_init+0xa6>
ffffffffc0203ffa:	e500                	sd	s0,8(a0)
ffffffffc0203ffc:	e91c                	sd	a5,16(a0)
ffffffffc0203ffe:	00052c23          	sw	zero,24(a0)
ffffffffc0204002:	0415                	addi	s0,s0,5
ffffffffc0204004:	8526                	mv	a0,s1
ffffffffc0204006:	c81ff0ef          	jal	ra,ffffffffc0203c86 <insert_vma_struct>
ffffffffc020400a:	03240a63          	beq	s0,s2,ffffffffc020403e <vmm_init+0xd6>
ffffffffc020400e:	03000513          	li	a0,48
ffffffffc0204012:	f7dfd0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0204016:	85aa                	mv	a1,a0
ffffffffc0204018:	00240793          	addi	a5,s0,2
ffffffffc020401c:	fd79                	bnez	a0,ffffffffc0203ffa <vmm_init+0x92>
ffffffffc020401e:	00009697          	auipc	a3,0x9
ffffffffc0204022:	ee268693          	addi	a3,a3,-286 # ffffffffc020cf00 <default_pmm_manager+0xa90>
ffffffffc0204026:	00008617          	auipc	a2,0x8
ffffffffc020402a:	96260613          	addi	a2,a2,-1694 # ffffffffc020b988 <commands+0x210>
ffffffffc020402e:	13500593          	li	a1,309
ffffffffc0204032:	00009517          	auipc	a0,0x9
ffffffffc0204036:	c7e50513          	addi	a0,a0,-898 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc020403a:	c64fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020403e:	649c                	ld	a5,8(s1)
ffffffffc0204040:	471d                	li	a4,7
ffffffffc0204042:	1fb00593          	li	a1,507
ffffffffc0204046:	16f48663          	beq	s1,a5,ffffffffc02041b2 <vmm_init+0x24a>
ffffffffc020404a:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd686d8>
ffffffffc020404e:	ffe70693          	addi	a3,a4,-2
ffffffffc0204052:	10d61063          	bne	a2,a3,ffffffffc0204152 <vmm_init+0x1ea>
ffffffffc0204056:	ff07b683          	ld	a3,-16(a5)
ffffffffc020405a:	0ed71c63          	bne	a4,a3,ffffffffc0204152 <vmm_init+0x1ea>
ffffffffc020405e:	0715                	addi	a4,a4,5
ffffffffc0204060:	679c                	ld	a5,8(a5)
ffffffffc0204062:	feb712e3          	bne	a4,a1,ffffffffc0204046 <vmm_init+0xde>
ffffffffc0204066:	4a1d                	li	s4,7
ffffffffc0204068:	4415                	li	s0,5
ffffffffc020406a:	1f900a93          	li	s5,505
ffffffffc020406e:	85a2                	mv	a1,s0
ffffffffc0204070:	8526                	mv	a0,s1
ffffffffc0204072:	bd5ff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc0204076:	892a                	mv	s2,a0
ffffffffc0204078:	16050d63          	beqz	a0,ffffffffc02041f2 <vmm_init+0x28a>
ffffffffc020407c:	00140593          	addi	a1,s0,1
ffffffffc0204080:	8526                	mv	a0,s1
ffffffffc0204082:	bc5ff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc0204086:	89aa                	mv	s3,a0
ffffffffc0204088:	14050563          	beqz	a0,ffffffffc02041d2 <vmm_init+0x26a>
ffffffffc020408c:	85d2                	mv	a1,s4
ffffffffc020408e:	8526                	mv	a0,s1
ffffffffc0204090:	bb7ff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc0204094:	16051f63          	bnez	a0,ffffffffc0204212 <vmm_init+0x2aa>
ffffffffc0204098:	00340593          	addi	a1,s0,3
ffffffffc020409c:	8526                	mv	a0,s1
ffffffffc020409e:	ba9ff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc02040a2:	1a051863          	bnez	a0,ffffffffc0204252 <vmm_init+0x2ea>
ffffffffc02040a6:	00440593          	addi	a1,s0,4
ffffffffc02040aa:	8526                	mv	a0,s1
ffffffffc02040ac:	b9bff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc02040b0:	18051163          	bnez	a0,ffffffffc0204232 <vmm_init+0x2ca>
ffffffffc02040b4:	00893783          	ld	a5,8(s2)
ffffffffc02040b8:	0a879d63          	bne	a5,s0,ffffffffc0204172 <vmm_init+0x20a>
ffffffffc02040bc:	01093783          	ld	a5,16(s2)
ffffffffc02040c0:	0b479963          	bne	a5,s4,ffffffffc0204172 <vmm_init+0x20a>
ffffffffc02040c4:	0089b783          	ld	a5,8(s3)
ffffffffc02040c8:	0c879563          	bne	a5,s0,ffffffffc0204192 <vmm_init+0x22a>
ffffffffc02040cc:	0109b783          	ld	a5,16(s3)
ffffffffc02040d0:	0d479163          	bne	a5,s4,ffffffffc0204192 <vmm_init+0x22a>
ffffffffc02040d4:	0415                	addi	s0,s0,5
ffffffffc02040d6:	0a15                	addi	s4,s4,5
ffffffffc02040d8:	f9541be3          	bne	s0,s5,ffffffffc020406e <vmm_init+0x106>
ffffffffc02040dc:	4411                	li	s0,4
ffffffffc02040de:	597d                	li	s2,-1
ffffffffc02040e0:	85a2                	mv	a1,s0
ffffffffc02040e2:	8526                	mv	a0,s1
ffffffffc02040e4:	b63ff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc02040e8:	0004059b          	sext.w	a1,s0
ffffffffc02040ec:	c90d                	beqz	a0,ffffffffc020411e <vmm_init+0x1b6>
ffffffffc02040ee:	6914                	ld	a3,16(a0)
ffffffffc02040f0:	6510                	ld	a2,8(a0)
ffffffffc02040f2:	00009517          	auipc	a0,0x9
ffffffffc02040f6:	d9650513          	addi	a0,a0,-618 # ffffffffc020ce88 <default_pmm_manager+0xa18>
ffffffffc02040fa:	8acfc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02040fe:	00009697          	auipc	a3,0x9
ffffffffc0204102:	db268693          	addi	a3,a3,-590 # ffffffffc020ceb0 <default_pmm_manager+0xa40>
ffffffffc0204106:	00008617          	auipc	a2,0x8
ffffffffc020410a:	88260613          	addi	a2,a2,-1918 # ffffffffc020b988 <commands+0x210>
ffffffffc020410e:	15b00593          	li	a1,347
ffffffffc0204112:	00009517          	auipc	a0,0x9
ffffffffc0204116:	b9e50513          	addi	a0,a0,-1122 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc020411a:	b84fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020411e:	147d                	addi	s0,s0,-1
ffffffffc0204120:	fd2410e3          	bne	s0,s2,ffffffffc02040e0 <vmm_init+0x178>
ffffffffc0204124:	8526                	mv	a0,s1
ffffffffc0204126:	c31ff0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc020412a:	00009517          	auipc	a0,0x9
ffffffffc020412e:	d9e50513          	addi	a0,a0,-610 # ffffffffc020cec8 <default_pmm_manager+0xa58>
ffffffffc0204132:	874fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0204136:	7442                	ld	s0,48(sp)
ffffffffc0204138:	70e2                	ld	ra,56(sp)
ffffffffc020413a:	74a2                	ld	s1,40(sp)
ffffffffc020413c:	7902                	ld	s2,32(sp)
ffffffffc020413e:	69e2                	ld	s3,24(sp)
ffffffffc0204140:	6a42                	ld	s4,16(sp)
ffffffffc0204142:	6aa2                	ld	s5,8(sp)
ffffffffc0204144:	00009517          	auipc	a0,0x9
ffffffffc0204148:	da450513          	addi	a0,a0,-604 # ffffffffc020cee8 <default_pmm_manager+0xa78>
ffffffffc020414c:	6121                	addi	sp,sp,64
ffffffffc020414e:	858fc06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0204152:	00009697          	auipc	a3,0x9
ffffffffc0204156:	c4e68693          	addi	a3,a3,-946 # ffffffffc020cda0 <default_pmm_manager+0x930>
ffffffffc020415a:	00008617          	auipc	a2,0x8
ffffffffc020415e:	82e60613          	addi	a2,a2,-2002 # ffffffffc020b988 <commands+0x210>
ffffffffc0204162:	13f00593          	li	a1,319
ffffffffc0204166:	00009517          	auipc	a0,0x9
ffffffffc020416a:	b4a50513          	addi	a0,a0,-1206 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc020416e:	b30fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204172:	00009697          	auipc	a3,0x9
ffffffffc0204176:	cb668693          	addi	a3,a3,-842 # ffffffffc020ce28 <default_pmm_manager+0x9b8>
ffffffffc020417a:	00008617          	auipc	a2,0x8
ffffffffc020417e:	80e60613          	addi	a2,a2,-2034 # ffffffffc020b988 <commands+0x210>
ffffffffc0204182:	15000593          	li	a1,336
ffffffffc0204186:	00009517          	auipc	a0,0x9
ffffffffc020418a:	b2a50513          	addi	a0,a0,-1238 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc020418e:	b10fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204192:	00009697          	auipc	a3,0x9
ffffffffc0204196:	cc668693          	addi	a3,a3,-826 # ffffffffc020ce58 <default_pmm_manager+0x9e8>
ffffffffc020419a:	00007617          	auipc	a2,0x7
ffffffffc020419e:	7ee60613          	addi	a2,a2,2030 # ffffffffc020b988 <commands+0x210>
ffffffffc02041a2:	15100593          	li	a1,337
ffffffffc02041a6:	00009517          	auipc	a0,0x9
ffffffffc02041aa:	b0a50513          	addi	a0,a0,-1270 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc02041ae:	af0fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02041b2:	00009697          	auipc	a3,0x9
ffffffffc02041b6:	bd668693          	addi	a3,a3,-1066 # ffffffffc020cd88 <default_pmm_manager+0x918>
ffffffffc02041ba:	00007617          	auipc	a2,0x7
ffffffffc02041be:	7ce60613          	addi	a2,a2,1998 # ffffffffc020b988 <commands+0x210>
ffffffffc02041c2:	13d00593          	li	a1,317
ffffffffc02041c6:	00009517          	auipc	a0,0x9
ffffffffc02041ca:	aea50513          	addi	a0,a0,-1302 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc02041ce:	ad0fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02041d2:	00009697          	auipc	a3,0x9
ffffffffc02041d6:	c1668693          	addi	a3,a3,-1002 # ffffffffc020cde8 <default_pmm_manager+0x978>
ffffffffc02041da:	00007617          	auipc	a2,0x7
ffffffffc02041de:	7ae60613          	addi	a2,a2,1966 # ffffffffc020b988 <commands+0x210>
ffffffffc02041e2:	14800593          	li	a1,328
ffffffffc02041e6:	00009517          	auipc	a0,0x9
ffffffffc02041ea:	aca50513          	addi	a0,a0,-1334 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc02041ee:	ab0fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02041f2:	00009697          	auipc	a3,0x9
ffffffffc02041f6:	be668693          	addi	a3,a3,-1050 # ffffffffc020cdd8 <default_pmm_manager+0x968>
ffffffffc02041fa:	00007617          	auipc	a2,0x7
ffffffffc02041fe:	78e60613          	addi	a2,a2,1934 # ffffffffc020b988 <commands+0x210>
ffffffffc0204202:	14600593          	li	a1,326
ffffffffc0204206:	00009517          	auipc	a0,0x9
ffffffffc020420a:	aaa50513          	addi	a0,a0,-1366 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc020420e:	a90fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204212:	00009697          	auipc	a3,0x9
ffffffffc0204216:	be668693          	addi	a3,a3,-1050 # ffffffffc020cdf8 <default_pmm_manager+0x988>
ffffffffc020421a:	00007617          	auipc	a2,0x7
ffffffffc020421e:	76e60613          	addi	a2,a2,1902 # ffffffffc020b988 <commands+0x210>
ffffffffc0204222:	14a00593          	li	a1,330
ffffffffc0204226:	00009517          	auipc	a0,0x9
ffffffffc020422a:	a8a50513          	addi	a0,a0,-1398 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc020422e:	a70fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204232:	00009697          	auipc	a3,0x9
ffffffffc0204236:	be668693          	addi	a3,a3,-1050 # ffffffffc020ce18 <default_pmm_manager+0x9a8>
ffffffffc020423a:	00007617          	auipc	a2,0x7
ffffffffc020423e:	74e60613          	addi	a2,a2,1870 # ffffffffc020b988 <commands+0x210>
ffffffffc0204242:	14e00593          	li	a1,334
ffffffffc0204246:	00009517          	auipc	a0,0x9
ffffffffc020424a:	a6a50513          	addi	a0,a0,-1430 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc020424e:	a50fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204252:	00009697          	auipc	a3,0x9
ffffffffc0204256:	bb668693          	addi	a3,a3,-1098 # ffffffffc020ce08 <default_pmm_manager+0x998>
ffffffffc020425a:	00007617          	auipc	a2,0x7
ffffffffc020425e:	72e60613          	addi	a2,a2,1838 # ffffffffc020b988 <commands+0x210>
ffffffffc0204262:	14c00593          	li	a1,332
ffffffffc0204266:	00009517          	auipc	a0,0x9
ffffffffc020426a:	a4a50513          	addi	a0,a0,-1462 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc020426e:	a30fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204272:	00009697          	auipc	a3,0x9
ffffffffc0204276:	ac668693          	addi	a3,a3,-1338 # ffffffffc020cd38 <default_pmm_manager+0x8c8>
ffffffffc020427a:	00007617          	auipc	a2,0x7
ffffffffc020427e:	70e60613          	addi	a2,a2,1806 # ffffffffc020b988 <commands+0x210>
ffffffffc0204282:	12600593          	li	a1,294
ffffffffc0204286:	00009517          	auipc	a0,0x9
ffffffffc020428a:	a2a50513          	addi	a0,a0,-1494 # ffffffffc020ccb0 <default_pmm_manager+0x840>
ffffffffc020428e:	a10fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204292 <user_mem_check>:
ffffffffc0204292:	7179                	addi	sp,sp,-48
ffffffffc0204294:	f022                	sd	s0,32(sp)
ffffffffc0204296:	f406                	sd	ra,40(sp)
ffffffffc0204298:	ec26                	sd	s1,24(sp)
ffffffffc020429a:	e84a                	sd	s2,16(sp)
ffffffffc020429c:	e44e                	sd	s3,8(sp)
ffffffffc020429e:	e052                	sd	s4,0(sp)
ffffffffc02042a0:	842e                	mv	s0,a1
ffffffffc02042a2:	c135                	beqz	a0,ffffffffc0204306 <user_mem_check+0x74>
ffffffffc02042a4:	002007b7          	lui	a5,0x200
ffffffffc02042a8:	04f5e663          	bltu	a1,a5,ffffffffc02042f4 <user_mem_check+0x62>
ffffffffc02042ac:	00c584b3          	add	s1,a1,a2
ffffffffc02042b0:	0495f263          	bgeu	a1,s1,ffffffffc02042f4 <user_mem_check+0x62>
ffffffffc02042b4:	4785                	li	a5,1
ffffffffc02042b6:	07fe                	slli	a5,a5,0x1f
ffffffffc02042b8:	0297ee63          	bltu	a5,s1,ffffffffc02042f4 <user_mem_check+0x62>
ffffffffc02042bc:	892a                	mv	s2,a0
ffffffffc02042be:	89b6                	mv	s3,a3
ffffffffc02042c0:	6a05                	lui	s4,0x1
ffffffffc02042c2:	a821                	j	ffffffffc02042da <user_mem_check+0x48>
ffffffffc02042c4:	0027f693          	andi	a3,a5,2
ffffffffc02042c8:	9752                	add	a4,a4,s4
ffffffffc02042ca:	8ba1                	andi	a5,a5,8
ffffffffc02042cc:	c685                	beqz	a3,ffffffffc02042f4 <user_mem_check+0x62>
ffffffffc02042ce:	c399                	beqz	a5,ffffffffc02042d4 <user_mem_check+0x42>
ffffffffc02042d0:	02e46263          	bltu	s0,a4,ffffffffc02042f4 <user_mem_check+0x62>
ffffffffc02042d4:	6900                	ld	s0,16(a0)
ffffffffc02042d6:	04947663          	bgeu	s0,s1,ffffffffc0204322 <user_mem_check+0x90>
ffffffffc02042da:	85a2                	mv	a1,s0
ffffffffc02042dc:	854a                	mv	a0,s2
ffffffffc02042de:	969ff0ef          	jal	ra,ffffffffc0203c46 <find_vma>
ffffffffc02042e2:	c909                	beqz	a0,ffffffffc02042f4 <user_mem_check+0x62>
ffffffffc02042e4:	6518                	ld	a4,8(a0)
ffffffffc02042e6:	00e46763          	bltu	s0,a4,ffffffffc02042f4 <user_mem_check+0x62>
ffffffffc02042ea:	4d1c                	lw	a5,24(a0)
ffffffffc02042ec:	fc099ce3          	bnez	s3,ffffffffc02042c4 <user_mem_check+0x32>
ffffffffc02042f0:	8b85                	andi	a5,a5,1
ffffffffc02042f2:	f3ed                	bnez	a5,ffffffffc02042d4 <user_mem_check+0x42>
ffffffffc02042f4:	4501                	li	a0,0
ffffffffc02042f6:	70a2                	ld	ra,40(sp)
ffffffffc02042f8:	7402                	ld	s0,32(sp)
ffffffffc02042fa:	64e2                	ld	s1,24(sp)
ffffffffc02042fc:	6942                	ld	s2,16(sp)
ffffffffc02042fe:	69a2                	ld	s3,8(sp)
ffffffffc0204300:	6a02                	ld	s4,0(sp)
ffffffffc0204302:	6145                	addi	sp,sp,48
ffffffffc0204304:	8082                	ret
ffffffffc0204306:	c02007b7          	lui	a5,0xc0200
ffffffffc020430a:	4501                	li	a0,0
ffffffffc020430c:	fef5e5e3          	bltu	a1,a5,ffffffffc02042f6 <user_mem_check+0x64>
ffffffffc0204310:	962e                	add	a2,a2,a1
ffffffffc0204312:	fec5f2e3          	bgeu	a1,a2,ffffffffc02042f6 <user_mem_check+0x64>
ffffffffc0204316:	c8000537          	lui	a0,0xc8000
ffffffffc020431a:	0505                	addi	a0,a0,1
ffffffffc020431c:	00a63533          	sltu	a0,a2,a0
ffffffffc0204320:	bfd9                	j	ffffffffc02042f6 <user_mem_check+0x64>
ffffffffc0204322:	4505                	li	a0,1
ffffffffc0204324:	bfc9                	j	ffffffffc02042f6 <user_mem_check+0x64>

ffffffffc0204326 <copy_from_user>:
ffffffffc0204326:	1101                	addi	sp,sp,-32
ffffffffc0204328:	e822                	sd	s0,16(sp)
ffffffffc020432a:	e426                	sd	s1,8(sp)
ffffffffc020432c:	8432                	mv	s0,a2
ffffffffc020432e:	84b6                	mv	s1,a3
ffffffffc0204330:	e04a                	sd	s2,0(sp)
ffffffffc0204332:	86ba                	mv	a3,a4
ffffffffc0204334:	892e                	mv	s2,a1
ffffffffc0204336:	8626                	mv	a2,s1
ffffffffc0204338:	85a2                	mv	a1,s0
ffffffffc020433a:	ec06                	sd	ra,24(sp)
ffffffffc020433c:	f57ff0ef          	jal	ra,ffffffffc0204292 <user_mem_check>
ffffffffc0204340:	c519                	beqz	a0,ffffffffc020434e <copy_from_user+0x28>
ffffffffc0204342:	8626                	mv	a2,s1
ffffffffc0204344:	85a2                	mv	a1,s0
ffffffffc0204346:	854a                	mv	a0,s2
ffffffffc0204348:	1aa070ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc020434c:	4505                	li	a0,1
ffffffffc020434e:	60e2                	ld	ra,24(sp)
ffffffffc0204350:	6442                	ld	s0,16(sp)
ffffffffc0204352:	64a2                	ld	s1,8(sp)
ffffffffc0204354:	6902                	ld	s2,0(sp)
ffffffffc0204356:	6105                	addi	sp,sp,32
ffffffffc0204358:	8082                	ret

ffffffffc020435a <copy_to_user>:
ffffffffc020435a:	1101                	addi	sp,sp,-32
ffffffffc020435c:	e822                	sd	s0,16(sp)
ffffffffc020435e:	8436                	mv	s0,a3
ffffffffc0204360:	e04a                	sd	s2,0(sp)
ffffffffc0204362:	4685                	li	a3,1
ffffffffc0204364:	8932                	mv	s2,a2
ffffffffc0204366:	8622                	mv	a2,s0
ffffffffc0204368:	e426                	sd	s1,8(sp)
ffffffffc020436a:	ec06                	sd	ra,24(sp)
ffffffffc020436c:	84ae                	mv	s1,a1
ffffffffc020436e:	f25ff0ef          	jal	ra,ffffffffc0204292 <user_mem_check>
ffffffffc0204372:	c519                	beqz	a0,ffffffffc0204380 <copy_to_user+0x26>
ffffffffc0204374:	8622                	mv	a2,s0
ffffffffc0204376:	85ca                	mv	a1,s2
ffffffffc0204378:	8526                	mv	a0,s1
ffffffffc020437a:	178070ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc020437e:	4505                	li	a0,1
ffffffffc0204380:	60e2                	ld	ra,24(sp)
ffffffffc0204382:	6442                	ld	s0,16(sp)
ffffffffc0204384:	64a2                	ld	s1,8(sp)
ffffffffc0204386:	6902                	ld	s2,0(sp)
ffffffffc0204388:	6105                	addi	sp,sp,32
ffffffffc020438a:	8082                	ret

ffffffffc020438c <copy_string>:
ffffffffc020438c:	7139                	addi	sp,sp,-64
ffffffffc020438e:	ec4e                	sd	s3,24(sp)
ffffffffc0204390:	6985                	lui	s3,0x1
ffffffffc0204392:	99b2                	add	s3,s3,a2
ffffffffc0204394:	77fd                	lui	a5,0xfffff
ffffffffc0204396:	00f9f9b3          	and	s3,s3,a5
ffffffffc020439a:	f426                	sd	s1,40(sp)
ffffffffc020439c:	f04a                	sd	s2,32(sp)
ffffffffc020439e:	e852                	sd	s4,16(sp)
ffffffffc02043a0:	e456                	sd	s5,8(sp)
ffffffffc02043a2:	fc06                	sd	ra,56(sp)
ffffffffc02043a4:	f822                	sd	s0,48(sp)
ffffffffc02043a6:	84b2                	mv	s1,a2
ffffffffc02043a8:	8aaa                	mv	s5,a0
ffffffffc02043aa:	8a2e                	mv	s4,a1
ffffffffc02043ac:	8936                	mv	s2,a3
ffffffffc02043ae:	40c989b3          	sub	s3,s3,a2
ffffffffc02043b2:	a015                	j	ffffffffc02043d6 <copy_string+0x4a>
ffffffffc02043b4:	064070ef          	jal	ra,ffffffffc020b418 <strnlen>
ffffffffc02043b8:	87aa                	mv	a5,a0
ffffffffc02043ba:	85a6                	mv	a1,s1
ffffffffc02043bc:	8552                	mv	a0,s4
ffffffffc02043be:	8622                	mv	a2,s0
ffffffffc02043c0:	0487e363          	bltu	a5,s0,ffffffffc0204406 <copy_string+0x7a>
ffffffffc02043c4:	0329f763          	bgeu	s3,s2,ffffffffc02043f2 <copy_string+0x66>
ffffffffc02043c8:	12a070ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc02043cc:	9a22                	add	s4,s4,s0
ffffffffc02043ce:	94a2                	add	s1,s1,s0
ffffffffc02043d0:	40890933          	sub	s2,s2,s0
ffffffffc02043d4:	6985                	lui	s3,0x1
ffffffffc02043d6:	4681                	li	a3,0
ffffffffc02043d8:	85a6                	mv	a1,s1
ffffffffc02043da:	8556                	mv	a0,s5
ffffffffc02043dc:	844a                	mv	s0,s2
ffffffffc02043de:	0129f363          	bgeu	s3,s2,ffffffffc02043e4 <copy_string+0x58>
ffffffffc02043e2:	844e                	mv	s0,s3
ffffffffc02043e4:	8622                	mv	a2,s0
ffffffffc02043e6:	eadff0ef          	jal	ra,ffffffffc0204292 <user_mem_check>
ffffffffc02043ea:	87aa                	mv	a5,a0
ffffffffc02043ec:	85a2                	mv	a1,s0
ffffffffc02043ee:	8526                	mv	a0,s1
ffffffffc02043f0:	f3f1                	bnez	a5,ffffffffc02043b4 <copy_string+0x28>
ffffffffc02043f2:	4501                	li	a0,0
ffffffffc02043f4:	70e2                	ld	ra,56(sp)
ffffffffc02043f6:	7442                	ld	s0,48(sp)
ffffffffc02043f8:	74a2                	ld	s1,40(sp)
ffffffffc02043fa:	7902                	ld	s2,32(sp)
ffffffffc02043fc:	69e2                	ld	s3,24(sp)
ffffffffc02043fe:	6a42                	ld	s4,16(sp)
ffffffffc0204400:	6aa2                	ld	s5,8(sp)
ffffffffc0204402:	6121                	addi	sp,sp,64
ffffffffc0204404:	8082                	ret
ffffffffc0204406:	00178613          	addi	a2,a5,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc020440a:	0e8070ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc020440e:	4505                	li	a0,1
ffffffffc0204410:	b7d5                	j	ffffffffc02043f4 <copy_string+0x68>

ffffffffc0204412 <__down.constprop.0>:
ffffffffc0204412:	715d                	addi	sp,sp,-80
ffffffffc0204414:	e0a2                	sd	s0,64(sp)
ffffffffc0204416:	e486                	sd	ra,72(sp)
ffffffffc0204418:	fc26                	sd	s1,56(sp)
ffffffffc020441a:	842a                	mv	s0,a0
ffffffffc020441c:	100027f3          	csrr	a5,sstatus
ffffffffc0204420:	8b89                	andi	a5,a5,2
ffffffffc0204422:	ebb1                	bnez	a5,ffffffffc0204476 <__down.constprop.0+0x64>
ffffffffc0204424:	411c                	lw	a5,0(a0)
ffffffffc0204426:	00f05a63          	blez	a5,ffffffffc020443a <__down.constprop.0+0x28>
ffffffffc020442a:	37fd                	addiw	a5,a5,-1
ffffffffc020442c:	c11c                	sw	a5,0(a0)
ffffffffc020442e:	4501                	li	a0,0
ffffffffc0204430:	60a6                	ld	ra,72(sp)
ffffffffc0204432:	6406                	ld	s0,64(sp)
ffffffffc0204434:	74e2                	ld	s1,56(sp)
ffffffffc0204436:	6161                	addi	sp,sp,80
ffffffffc0204438:	8082                	ret
ffffffffc020443a:	00850413          	addi	s0,a0,8 # ffffffffc8000008 <end+0x7d696f8>
ffffffffc020443e:	0024                	addi	s1,sp,8
ffffffffc0204440:	10000613          	li	a2,256
ffffffffc0204444:	85a6                	mv	a1,s1
ffffffffc0204446:	8522                	mv	a0,s0
ffffffffc0204448:	2d8000ef          	jal	ra,ffffffffc0204720 <wait_current_set>
ffffffffc020444c:	6df020ef          	jal	ra,ffffffffc020732a <schedule>
ffffffffc0204450:	100027f3          	csrr	a5,sstatus
ffffffffc0204454:	8b89                	andi	a5,a5,2
ffffffffc0204456:	efb9                	bnez	a5,ffffffffc02044b4 <__down.constprop.0+0xa2>
ffffffffc0204458:	8526                	mv	a0,s1
ffffffffc020445a:	19c000ef          	jal	ra,ffffffffc02045f6 <wait_in_queue>
ffffffffc020445e:	e531                	bnez	a0,ffffffffc02044aa <__down.constprop.0+0x98>
ffffffffc0204460:	4542                	lw	a0,16(sp)
ffffffffc0204462:	10000793          	li	a5,256
ffffffffc0204466:	fcf515e3          	bne	a0,a5,ffffffffc0204430 <__down.constprop.0+0x1e>
ffffffffc020446a:	60a6                	ld	ra,72(sp)
ffffffffc020446c:	6406                	ld	s0,64(sp)
ffffffffc020446e:	74e2                	ld	s1,56(sp)
ffffffffc0204470:	4501                	li	a0,0
ffffffffc0204472:	6161                	addi	sp,sp,80
ffffffffc0204474:	8082                	ret
ffffffffc0204476:	ffcfc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020447a:	401c                	lw	a5,0(s0)
ffffffffc020447c:	00f05c63          	blez	a5,ffffffffc0204494 <__down.constprop.0+0x82>
ffffffffc0204480:	37fd                	addiw	a5,a5,-1
ffffffffc0204482:	c01c                	sw	a5,0(s0)
ffffffffc0204484:	fe8fc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0204488:	60a6                	ld	ra,72(sp)
ffffffffc020448a:	6406                	ld	s0,64(sp)
ffffffffc020448c:	74e2                	ld	s1,56(sp)
ffffffffc020448e:	4501                	li	a0,0
ffffffffc0204490:	6161                	addi	sp,sp,80
ffffffffc0204492:	8082                	ret
ffffffffc0204494:	0421                	addi	s0,s0,8
ffffffffc0204496:	0024                	addi	s1,sp,8
ffffffffc0204498:	10000613          	li	a2,256
ffffffffc020449c:	85a6                	mv	a1,s1
ffffffffc020449e:	8522                	mv	a0,s0
ffffffffc02044a0:	280000ef          	jal	ra,ffffffffc0204720 <wait_current_set>
ffffffffc02044a4:	fc8fc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02044a8:	b755                	j	ffffffffc020444c <__down.constprop.0+0x3a>
ffffffffc02044aa:	85a6                	mv	a1,s1
ffffffffc02044ac:	8522                	mv	a0,s0
ffffffffc02044ae:	0ee000ef          	jal	ra,ffffffffc020459c <wait_queue_del>
ffffffffc02044b2:	b77d                	j	ffffffffc0204460 <__down.constprop.0+0x4e>
ffffffffc02044b4:	fbefc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02044b8:	8526                	mv	a0,s1
ffffffffc02044ba:	13c000ef          	jal	ra,ffffffffc02045f6 <wait_in_queue>
ffffffffc02044be:	e501                	bnez	a0,ffffffffc02044c6 <__down.constprop.0+0xb4>
ffffffffc02044c0:	facfc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02044c4:	bf71                	j	ffffffffc0204460 <__down.constprop.0+0x4e>
ffffffffc02044c6:	85a6                	mv	a1,s1
ffffffffc02044c8:	8522                	mv	a0,s0
ffffffffc02044ca:	0d2000ef          	jal	ra,ffffffffc020459c <wait_queue_del>
ffffffffc02044ce:	bfcd                	j	ffffffffc02044c0 <__down.constprop.0+0xae>

ffffffffc02044d0 <__up.constprop.0>:
ffffffffc02044d0:	1101                	addi	sp,sp,-32
ffffffffc02044d2:	e822                	sd	s0,16(sp)
ffffffffc02044d4:	ec06                	sd	ra,24(sp)
ffffffffc02044d6:	e426                	sd	s1,8(sp)
ffffffffc02044d8:	e04a                	sd	s2,0(sp)
ffffffffc02044da:	842a                	mv	s0,a0
ffffffffc02044dc:	100027f3          	csrr	a5,sstatus
ffffffffc02044e0:	8b89                	andi	a5,a5,2
ffffffffc02044e2:	4901                	li	s2,0
ffffffffc02044e4:	eba1                	bnez	a5,ffffffffc0204534 <__up.constprop.0+0x64>
ffffffffc02044e6:	00840493          	addi	s1,s0,8
ffffffffc02044ea:	8526                	mv	a0,s1
ffffffffc02044ec:	0ee000ef          	jal	ra,ffffffffc02045da <wait_queue_first>
ffffffffc02044f0:	85aa                	mv	a1,a0
ffffffffc02044f2:	cd0d                	beqz	a0,ffffffffc020452c <__up.constprop.0+0x5c>
ffffffffc02044f4:	6118                	ld	a4,0(a0)
ffffffffc02044f6:	10000793          	li	a5,256
ffffffffc02044fa:	0ec72703          	lw	a4,236(a4)
ffffffffc02044fe:	02f71f63          	bne	a4,a5,ffffffffc020453c <__up.constprop.0+0x6c>
ffffffffc0204502:	4685                	li	a3,1
ffffffffc0204504:	10000613          	li	a2,256
ffffffffc0204508:	8526                	mv	a0,s1
ffffffffc020450a:	0fa000ef          	jal	ra,ffffffffc0204604 <wakeup_wait>
ffffffffc020450e:	00091863          	bnez	s2,ffffffffc020451e <__up.constprop.0+0x4e>
ffffffffc0204512:	60e2                	ld	ra,24(sp)
ffffffffc0204514:	6442                	ld	s0,16(sp)
ffffffffc0204516:	64a2                	ld	s1,8(sp)
ffffffffc0204518:	6902                	ld	s2,0(sp)
ffffffffc020451a:	6105                	addi	sp,sp,32
ffffffffc020451c:	8082                	ret
ffffffffc020451e:	6442                	ld	s0,16(sp)
ffffffffc0204520:	60e2                	ld	ra,24(sp)
ffffffffc0204522:	64a2                	ld	s1,8(sp)
ffffffffc0204524:	6902                	ld	s2,0(sp)
ffffffffc0204526:	6105                	addi	sp,sp,32
ffffffffc0204528:	f44fc06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc020452c:	401c                	lw	a5,0(s0)
ffffffffc020452e:	2785                	addiw	a5,a5,1
ffffffffc0204530:	c01c                	sw	a5,0(s0)
ffffffffc0204532:	bff1                	j	ffffffffc020450e <__up.constprop.0+0x3e>
ffffffffc0204534:	f3efc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0204538:	4905                	li	s2,1
ffffffffc020453a:	b775                	j	ffffffffc02044e6 <__up.constprop.0+0x16>
ffffffffc020453c:	00009697          	auipc	a3,0x9
ffffffffc0204540:	9d468693          	addi	a3,a3,-1580 # ffffffffc020cf10 <default_pmm_manager+0xaa0>
ffffffffc0204544:	00007617          	auipc	a2,0x7
ffffffffc0204548:	44460613          	addi	a2,a2,1092 # ffffffffc020b988 <commands+0x210>
ffffffffc020454c:	45e5                	li	a1,25
ffffffffc020454e:	00009517          	auipc	a0,0x9
ffffffffc0204552:	9ea50513          	addi	a0,a0,-1558 # ffffffffc020cf38 <default_pmm_manager+0xac8>
ffffffffc0204556:	f49fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020455a <sem_init>:
ffffffffc020455a:	c10c                	sw	a1,0(a0)
ffffffffc020455c:	0521                	addi	a0,a0,8
ffffffffc020455e:	a825                	j	ffffffffc0204596 <wait_queue_init>

ffffffffc0204560 <up>:
ffffffffc0204560:	f71ff06f          	j	ffffffffc02044d0 <__up.constprop.0>

ffffffffc0204564 <down>:
ffffffffc0204564:	1141                	addi	sp,sp,-16
ffffffffc0204566:	e406                	sd	ra,8(sp)
ffffffffc0204568:	eabff0ef          	jal	ra,ffffffffc0204412 <__down.constprop.0>
ffffffffc020456c:	2501                	sext.w	a0,a0
ffffffffc020456e:	e501                	bnez	a0,ffffffffc0204576 <down+0x12>
ffffffffc0204570:	60a2                	ld	ra,8(sp)
ffffffffc0204572:	0141                	addi	sp,sp,16
ffffffffc0204574:	8082                	ret
ffffffffc0204576:	00009697          	auipc	a3,0x9
ffffffffc020457a:	9d268693          	addi	a3,a3,-1582 # ffffffffc020cf48 <default_pmm_manager+0xad8>
ffffffffc020457e:	00007617          	auipc	a2,0x7
ffffffffc0204582:	40a60613          	addi	a2,a2,1034 # ffffffffc020b988 <commands+0x210>
ffffffffc0204586:	04000593          	li	a1,64
ffffffffc020458a:	00009517          	auipc	a0,0x9
ffffffffc020458e:	9ae50513          	addi	a0,a0,-1618 # ffffffffc020cf38 <default_pmm_manager+0xac8>
ffffffffc0204592:	f0dfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204596 <wait_queue_init>:
ffffffffc0204596:	e508                	sd	a0,8(a0)
ffffffffc0204598:	e108                	sd	a0,0(a0)
ffffffffc020459a:	8082                	ret

ffffffffc020459c <wait_queue_del>:
ffffffffc020459c:	7198                	ld	a4,32(a1)
ffffffffc020459e:	01858793          	addi	a5,a1,24
ffffffffc02045a2:	00e78b63          	beq	a5,a4,ffffffffc02045b8 <wait_queue_del+0x1c>
ffffffffc02045a6:	6994                	ld	a3,16(a1)
ffffffffc02045a8:	00a69863          	bne	a3,a0,ffffffffc02045b8 <wait_queue_del+0x1c>
ffffffffc02045ac:	6d94                	ld	a3,24(a1)
ffffffffc02045ae:	e698                	sd	a4,8(a3)
ffffffffc02045b0:	e314                	sd	a3,0(a4)
ffffffffc02045b2:	f19c                	sd	a5,32(a1)
ffffffffc02045b4:	ed9c                	sd	a5,24(a1)
ffffffffc02045b6:	8082                	ret
ffffffffc02045b8:	1141                	addi	sp,sp,-16
ffffffffc02045ba:	00009697          	auipc	a3,0x9
ffffffffc02045be:	9ee68693          	addi	a3,a3,-1554 # ffffffffc020cfa8 <default_pmm_manager+0xb38>
ffffffffc02045c2:	00007617          	auipc	a2,0x7
ffffffffc02045c6:	3c660613          	addi	a2,a2,966 # ffffffffc020b988 <commands+0x210>
ffffffffc02045ca:	45f1                	li	a1,28
ffffffffc02045cc:	00009517          	auipc	a0,0x9
ffffffffc02045d0:	9c450513          	addi	a0,a0,-1596 # ffffffffc020cf90 <default_pmm_manager+0xb20>
ffffffffc02045d4:	e406                	sd	ra,8(sp)
ffffffffc02045d6:	ec9fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02045da <wait_queue_first>:
ffffffffc02045da:	651c                	ld	a5,8(a0)
ffffffffc02045dc:	00f50563          	beq	a0,a5,ffffffffc02045e6 <wait_queue_first+0xc>
ffffffffc02045e0:	fe878513          	addi	a0,a5,-24
ffffffffc02045e4:	8082                	ret
ffffffffc02045e6:	4501                	li	a0,0
ffffffffc02045e8:	8082                	ret

ffffffffc02045ea <wait_queue_empty>:
ffffffffc02045ea:	651c                	ld	a5,8(a0)
ffffffffc02045ec:	40a78533          	sub	a0,a5,a0
ffffffffc02045f0:	00153513          	seqz	a0,a0
ffffffffc02045f4:	8082                	ret

ffffffffc02045f6 <wait_in_queue>:
ffffffffc02045f6:	711c                	ld	a5,32(a0)
ffffffffc02045f8:	0561                	addi	a0,a0,24
ffffffffc02045fa:	40a78533          	sub	a0,a5,a0
ffffffffc02045fe:	00a03533          	snez	a0,a0
ffffffffc0204602:	8082                	ret

ffffffffc0204604 <wakeup_wait>:
ffffffffc0204604:	e689                	bnez	a3,ffffffffc020460e <wakeup_wait+0xa>
ffffffffc0204606:	6188                	ld	a0,0(a1)
ffffffffc0204608:	c590                	sw	a2,8(a1)
ffffffffc020460a:	46f0206f          	j	ffffffffc0207278 <wakeup_proc>
ffffffffc020460e:	7198                	ld	a4,32(a1)
ffffffffc0204610:	01858793          	addi	a5,a1,24
ffffffffc0204614:	00e78e63          	beq	a5,a4,ffffffffc0204630 <wakeup_wait+0x2c>
ffffffffc0204618:	6994                	ld	a3,16(a1)
ffffffffc020461a:	00d51b63          	bne	a0,a3,ffffffffc0204630 <wakeup_wait+0x2c>
ffffffffc020461e:	6d94                	ld	a3,24(a1)
ffffffffc0204620:	6188                	ld	a0,0(a1)
ffffffffc0204622:	e698                	sd	a4,8(a3)
ffffffffc0204624:	e314                	sd	a3,0(a4)
ffffffffc0204626:	f19c                	sd	a5,32(a1)
ffffffffc0204628:	ed9c                	sd	a5,24(a1)
ffffffffc020462a:	c590                	sw	a2,8(a1)
ffffffffc020462c:	44d0206f          	j	ffffffffc0207278 <wakeup_proc>
ffffffffc0204630:	1141                	addi	sp,sp,-16
ffffffffc0204632:	00009697          	auipc	a3,0x9
ffffffffc0204636:	97668693          	addi	a3,a3,-1674 # ffffffffc020cfa8 <default_pmm_manager+0xb38>
ffffffffc020463a:	00007617          	auipc	a2,0x7
ffffffffc020463e:	34e60613          	addi	a2,a2,846 # ffffffffc020b988 <commands+0x210>
ffffffffc0204642:	45f1                	li	a1,28
ffffffffc0204644:	00009517          	auipc	a0,0x9
ffffffffc0204648:	94c50513          	addi	a0,a0,-1716 # ffffffffc020cf90 <default_pmm_manager+0xb20>
ffffffffc020464c:	e406                	sd	ra,8(sp)
ffffffffc020464e:	e51fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204652 <wakeup_queue>:
ffffffffc0204652:	651c                	ld	a5,8(a0)
ffffffffc0204654:	0ca78563          	beq	a5,a0,ffffffffc020471e <wakeup_queue+0xcc>
ffffffffc0204658:	1101                	addi	sp,sp,-32
ffffffffc020465a:	e822                	sd	s0,16(sp)
ffffffffc020465c:	e426                	sd	s1,8(sp)
ffffffffc020465e:	e04a                	sd	s2,0(sp)
ffffffffc0204660:	ec06                	sd	ra,24(sp)
ffffffffc0204662:	84aa                	mv	s1,a0
ffffffffc0204664:	892e                	mv	s2,a1
ffffffffc0204666:	fe878413          	addi	s0,a5,-24
ffffffffc020466a:	e23d                	bnez	a2,ffffffffc02046d0 <wakeup_queue+0x7e>
ffffffffc020466c:	6008                	ld	a0,0(s0)
ffffffffc020466e:	01242423          	sw	s2,8(s0)
ffffffffc0204672:	407020ef          	jal	ra,ffffffffc0207278 <wakeup_proc>
ffffffffc0204676:	701c                	ld	a5,32(s0)
ffffffffc0204678:	01840713          	addi	a4,s0,24
ffffffffc020467c:	02e78463          	beq	a5,a4,ffffffffc02046a4 <wakeup_queue+0x52>
ffffffffc0204680:	6818                	ld	a4,16(s0)
ffffffffc0204682:	02e49163          	bne	s1,a4,ffffffffc02046a4 <wakeup_queue+0x52>
ffffffffc0204686:	02f48f63          	beq	s1,a5,ffffffffc02046c4 <wakeup_queue+0x72>
ffffffffc020468a:	fe87b503          	ld	a0,-24(a5)
ffffffffc020468e:	ff27a823          	sw	s2,-16(a5)
ffffffffc0204692:	fe878413          	addi	s0,a5,-24
ffffffffc0204696:	3e3020ef          	jal	ra,ffffffffc0207278 <wakeup_proc>
ffffffffc020469a:	701c                	ld	a5,32(s0)
ffffffffc020469c:	01840713          	addi	a4,s0,24
ffffffffc02046a0:	fee790e3          	bne	a5,a4,ffffffffc0204680 <wakeup_queue+0x2e>
ffffffffc02046a4:	00009697          	auipc	a3,0x9
ffffffffc02046a8:	90468693          	addi	a3,a3,-1788 # ffffffffc020cfa8 <default_pmm_manager+0xb38>
ffffffffc02046ac:	00007617          	auipc	a2,0x7
ffffffffc02046b0:	2dc60613          	addi	a2,a2,732 # ffffffffc020b988 <commands+0x210>
ffffffffc02046b4:	02200593          	li	a1,34
ffffffffc02046b8:	00009517          	auipc	a0,0x9
ffffffffc02046bc:	8d850513          	addi	a0,a0,-1832 # ffffffffc020cf90 <default_pmm_manager+0xb20>
ffffffffc02046c0:	ddffb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02046c4:	60e2                	ld	ra,24(sp)
ffffffffc02046c6:	6442                	ld	s0,16(sp)
ffffffffc02046c8:	64a2                	ld	s1,8(sp)
ffffffffc02046ca:	6902                	ld	s2,0(sp)
ffffffffc02046cc:	6105                	addi	sp,sp,32
ffffffffc02046ce:	8082                	ret
ffffffffc02046d0:	6798                	ld	a4,8(a5)
ffffffffc02046d2:	02f70763          	beq	a4,a5,ffffffffc0204700 <wakeup_queue+0xae>
ffffffffc02046d6:	6814                	ld	a3,16(s0)
ffffffffc02046d8:	02d49463          	bne	s1,a3,ffffffffc0204700 <wakeup_queue+0xae>
ffffffffc02046dc:	6c14                	ld	a3,24(s0)
ffffffffc02046de:	6008                	ld	a0,0(s0)
ffffffffc02046e0:	e698                	sd	a4,8(a3)
ffffffffc02046e2:	e314                	sd	a3,0(a4)
ffffffffc02046e4:	f01c                	sd	a5,32(s0)
ffffffffc02046e6:	ec1c                	sd	a5,24(s0)
ffffffffc02046e8:	01242423          	sw	s2,8(s0)
ffffffffc02046ec:	38d020ef          	jal	ra,ffffffffc0207278 <wakeup_proc>
ffffffffc02046f0:	6480                	ld	s0,8(s1)
ffffffffc02046f2:	fc8489e3          	beq	s1,s0,ffffffffc02046c4 <wakeup_queue+0x72>
ffffffffc02046f6:	6418                	ld	a4,8(s0)
ffffffffc02046f8:	87a2                	mv	a5,s0
ffffffffc02046fa:	1421                	addi	s0,s0,-24
ffffffffc02046fc:	fce79de3          	bne	a5,a4,ffffffffc02046d6 <wakeup_queue+0x84>
ffffffffc0204700:	00009697          	auipc	a3,0x9
ffffffffc0204704:	8a868693          	addi	a3,a3,-1880 # ffffffffc020cfa8 <default_pmm_manager+0xb38>
ffffffffc0204708:	00007617          	auipc	a2,0x7
ffffffffc020470c:	28060613          	addi	a2,a2,640 # ffffffffc020b988 <commands+0x210>
ffffffffc0204710:	45f1                	li	a1,28
ffffffffc0204712:	00009517          	auipc	a0,0x9
ffffffffc0204716:	87e50513          	addi	a0,a0,-1922 # ffffffffc020cf90 <default_pmm_manager+0xb20>
ffffffffc020471a:	d85fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020471e:	8082                	ret

ffffffffc0204720 <wait_current_set>:
ffffffffc0204720:	00092797          	auipc	a5,0x92
ffffffffc0204724:	1a07b783          	ld	a5,416(a5) # ffffffffc02968c0 <current>
ffffffffc0204728:	c39d                	beqz	a5,ffffffffc020474e <wait_current_set+0x2e>
ffffffffc020472a:	01858713          	addi	a4,a1,24
ffffffffc020472e:	800006b7          	lui	a3,0x80000
ffffffffc0204732:	ed98                	sd	a4,24(a1)
ffffffffc0204734:	e19c                	sd	a5,0(a1)
ffffffffc0204736:	c594                	sw	a3,8(a1)
ffffffffc0204738:	4685                	li	a3,1
ffffffffc020473a:	c394                	sw	a3,0(a5)
ffffffffc020473c:	0ec7a623          	sw	a2,236(a5)
ffffffffc0204740:	611c                	ld	a5,0(a0)
ffffffffc0204742:	e988                	sd	a0,16(a1)
ffffffffc0204744:	e118                	sd	a4,0(a0)
ffffffffc0204746:	e798                	sd	a4,8(a5)
ffffffffc0204748:	f188                	sd	a0,32(a1)
ffffffffc020474a:	ed9c                	sd	a5,24(a1)
ffffffffc020474c:	8082                	ret
ffffffffc020474e:	1141                	addi	sp,sp,-16
ffffffffc0204750:	00009697          	auipc	a3,0x9
ffffffffc0204754:	89868693          	addi	a3,a3,-1896 # ffffffffc020cfe8 <default_pmm_manager+0xb78>
ffffffffc0204758:	00007617          	auipc	a2,0x7
ffffffffc020475c:	23060613          	addi	a2,a2,560 # ffffffffc020b988 <commands+0x210>
ffffffffc0204760:	07400593          	li	a1,116
ffffffffc0204764:	00009517          	auipc	a0,0x9
ffffffffc0204768:	82c50513          	addi	a0,a0,-2004 # ffffffffc020cf90 <default_pmm_manager+0xb20>
ffffffffc020476c:	e406                	sd	ra,8(sp)
ffffffffc020476e:	d31fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204772 <get_fd_array.part.0>:
ffffffffc0204772:	1141                	addi	sp,sp,-16
ffffffffc0204774:	00009697          	auipc	a3,0x9
ffffffffc0204778:	88468693          	addi	a3,a3,-1916 # ffffffffc020cff8 <default_pmm_manager+0xb88>
ffffffffc020477c:	00007617          	auipc	a2,0x7
ffffffffc0204780:	20c60613          	addi	a2,a2,524 # ffffffffc020b988 <commands+0x210>
ffffffffc0204784:	45d1                	li	a1,20
ffffffffc0204786:	00009517          	auipc	a0,0x9
ffffffffc020478a:	8a250513          	addi	a0,a0,-1886 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc020478e:	e406                	sd	ra,8(sp)
ffffffffc0204790:	d0ffb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204794 <fd_array_alloc>:
ffffffffc0204794:	00092797          	auipc	a5,0x92
ffffffffc0204798:	12c7b783          	ld	a5,300(a5) # ffffffffc02968c0 <current>
ffffffffc020479c:	1487b783          	ld	a5,328(a5)
ffffffffc02047a0:	1141                	addi	sp,sp,-16
ffffffffc02047a2:	e406                	sd	ra,8(sp)
ffffffffc02047a4:	c3a5                	beqz	a5,ffffffffc0204804 <fd_array_alloc+0x70>
ffffffffc02047a6:	4b98                	lw	a4,16(a5)
ffffffffc02047a8:	04e05e63          	blez	a4,ffffffffc0204804 <fd_array_alloc+0x70>
ffffffffc02047ac:	775d                	lui	a4,0xffff7
ffffffffc02047ae:	ad970713          	addi	a4,a4,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc02047b2:	679c                	ld	a5,8(a5)
ffffffffc02047b4:	02e50863          	beq	a0,a4,ffffffffc02047e4 <fd_array_alloc+0x50>
ffffffffc02047b8:	04700713          	li	a4,71
ffffffffc02047bc:	04a76263          	bltu	a4,a0,ffffffffc0204800 <fd_array_alloc+0x6c>
ffffffffc02047c0:	00351713          	slli	a4,a0,0x3
ffffffffc02047c4:	40a70533          	sub	a0,a4,a0
ffffffffc02047c8:	050e                	slli	a0,a0,0x3
ffffffffc02047ca:	97aa                	add	a5,a5,a0
ffffffffc02047cc:	4398                	lw	a4,0(a5)
ffffffffc02047ce:	e71d                	bnez	a4,ffffffffc02047fc <fd_array_alloc+0x68>
ffffffffc02047d0:	5b88                	lw	a0,48(a5)
ffffffffc02047d2:	e91d                	bnez	a0,ffffffffc0204808 <fd_array_alloc+0x74>
ffffffffc02047d4:	4705                	li	a4,1
ffffffffc02047d6:	c398                	sw	a4,0(a5)
ffffffffc02047d8:	0207b423          	sd	zero,40(a5)
ffffffffc02047dc:	e19c                	sd	a5,0(a1)
ffffffffc02047de:	60a2                	ld	ra,8(sp)
ffffffffc02047e0:	0141                	addi	sp,sp,16
ffffffffc02047e2:	8082                	ret
ffffffffc02047e4:	6685                	lui	a3,0x1
ffffffffc02047e6:	fc068693          	addi	a3,a3,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc02047ea:	96be                	add	a3,a3,a5
ffffffffc02047ec:	4398                	lw	a4,0(a5)
ffffffffc02047ee:	d36d                	beqz	a4,ffffffffc02047d0 <fd_array_alloc+0x3c>
ffffffffc02047f0:	03878793          	addi	a5,a5,56
ffffffffc02047f4:	fef69ce3          	bne	a3,a5,ffffffffc02047ec <fd_array_alloc+0x58>
ffffffffc02047f8:	5529                	li	a0,-22
ffffffffc02047fa:	b7d5                	j	ffffffffc02047de <fd_array_alloc+0x4a>
ffffffffc02047fc:	5545                	li	a0,-15
ffffffffc02047fe:	b7c5                	j	ffffffffc02047de <fd_array_alloc+0x4a>
ffffffffc0204800:	5575                	li	a0,-3
ffffffffc0204802:	bff1                	j	ffffffffc02047de <fd_array_alloc+0x4a>
ffffffffc0204804:	f6fff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>
ffffffffc0204808:	00009697          	auipc	a3,0x9
ffffffffc020480c:	83068693          	addi	a3,a3,-2000 # ffffffffc020d038 <default_pmm_manager+0xbc8>
ffffffffc0204810:	00007617          	auipc	a2,0x7
ffffffffc0204814:	17860613          	addi	a2,a2,376 # ffffffffc020b988 <commands+0x210>
ffffffffc0204818:	03b00593          	li	a1,59
ffffffffc020481c:	00009517          	auipc	a0,0x9
ffffffffc0204820:	80c50513          	addi	a0,a0,-2036 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc0204824:	c7bfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204828 <fd_array_free>:
ffffffffc0204828:	411c                	lw	a5,0(a0)
ffffffffc020482a:	1141                	addi	sp,sp,-16
ffffffffc020482c:	e022                	sd	s0,0(sp)
ffffffffc020482e:	e406                	sd	ra,8(sp)
ffffffffc0204830:	4705                	li	a4,1
ffffffffc0204832:	842a                	mv	s0,a0
ffffffffc0204834:	04e78063          	beq	a5,a4,ffffffffc0204874 <fd_array_free+0x4c>
ffffffffc0204838:	470d                	li	a4,3
ffffffffc020483a:	04e79563          	bne	a5,a4,ffffffffc0204884 <fd_array_free+0x5c>
ffffffffc020483e:	591c                	lw	a5,48(a0)
ffffffffc0204840:	c38d                	beqz	a5,ffffffffc0204862 <fd_array_free+0x3a>
ffffffffc0204842:	00008697          	auipc	a3,0x8
ffffffffc0204846:	7f668693          	addi	a3,a3,2038 # ffffffffc020d038 <default_pmm_manager+0xbc8>
ffffffffc020484a:	00007617          	auipc	a2,0x7
ffffffffc020484e:	13e60613          	addi	a2,a2,318 # ffffffffc020b988 <commands+0x210>
ffffffffc0204852:	04500593          	li	a1,69
ffffffffc0204856:	00008517          	auipc	a0,0x8
ffffffffc020485a:	7d250513          	addi	a0,a0,2002 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc020485e:	c41fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204862:	7408                	ld	a0,40(s0)
ffffffffc0204864:	08b030ef          	jal	ra,ffffffffc02080ee <vfs_close>
ffffffffc0204868:	60a2                	ld	ra,8(sp)
ffffffffc020486a:	00042023          	sw	zero,0(s0)
ffffffffc020486e:	6402                	ld	s0,0(sp)
ffffffffc0204870:	0141                	addi	sp,sp,16
ffffffffc0204872:	8082                	ret
ffffffffc0204874:	591c                	lw	a5,48(a0)
ffffffffc0204876:	f7f1                	bnez	a5,ffffffffc0204842 <fd_array_free+0x1a>
ffffffffc0204878:	60a2                	ld	ra,8(sp)
ffffffffc020487a:	00042023          	sw	zero,0(s0)
ffffffffc020487e:	6402                	ld	s0,0(sp)
ffffffffc0204880:	0141                	addi	sp,sp,16
ffffffffc0204882:	8082                	ret
ffffffffc0204884:	00008697          	auipc	a3,0x8
ffffffffc0204888:	7ec68693          	addi	a3,a3,2028 # ffffffffc020d070 <default_pmm_manager+0xc00>
ffffffffc020488c:	00007617          	auipc	a2,0x7
ffffffffc0204890:	0fc60613          	addi	a2,a2,252 # ffffffffc020b988 <commands+0x210>
ffffffffc0204894:	04400593          	li	a1,68
ffffffffc0204898:	00008517          	auipc	a0,0x8
ffffffffc020489c:	79050513          	addi	a0,a0,1936 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc02048a0:	bfffb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02048a4 <fd_array_release>:
ffffffffc02048a4:	4118                	lw	a4,0(a0)
ffffffffc02048a6:	1141                	addi	sp,sp,-16
ffffffffc02048a8:	e406                	sd	ra,8(sp)
ffffffffc02048aa:	4685                	li	a3,1
ffffffffc02048ac:	3779                	addiw	a4,a4,-2
ffffffffc02048ae:	04e6e063          	bltu	a3,a4,ffffffffc02048ee <fd_array_release+0x4a>
ffffffffc02048b2:	5918                	lw	a4,48(a0)
ffffffffc02048b4:	00e05d63          	blez	a4,ffffffffc02048ce <fd_array_release+0x2a>
ffffffffc02048b8:	fff7069b          	addiw	a3,a4,-1
ffffffffc02048bc:	d914                	sw	a3,48(a0)
ffffffffc02048be:	c681                	beqz	a3,ffffffffc02048c6 <fd_array_release+0x22>
ffffffffc02048c0:	60a2                	ld	ra,8(sp)
ffffffffc02048c2:	0141                	addi	sp,sp,16
ffffffffc02048c4:	8082                	ret
ffffffffc02048c6:	60a2                	ld	ra,8(sp)
ffffffffc02048c8:	0141                	addi	sp,sp,16
ffffffffc02048ca:	f5fff06f          	j	ffffffffc0204828 <fd_array_free>
ffffffffc02048ce:	00009697          	auipc	a3,0x9
ffffffffc02048d2:	81268693          	addi	a3,a3,-2030 # ffffffffc020d0e0 <default_pmm_manager+0xc70>
ffffffffc02048d6:	00007617          	auipc	a2,0x7
ffffffffc02048da:	0b260613          	addi	a2,a2,178 # ffffffffc020b988 <commands+0x210>
ffffffffc02048de:	05600593          	li	a1,86
ffffffffc02048e2:	00008517          	auipc	a0,0x8
ffffffffc02048e6:	74650513          	addi	a0,a0,1862 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc02048ea:	bb5fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02048ee:	00008697          	auipc	a3,0x8
ffffffffc02048f2:	7ba68693          	addi	a3,a3,1978 # ffffffffc020d0a8 <default_pmm_manager+0xc38>
ffffffffc02048f6:	00007617          	auipc	a2,0x7
ffffffffc02048fa:	09260613          	addi	a2,a2,146 # ffffffffc020b988 <commands+0x210>
ffffffffc02048fe:	05500593          	li	a1,85
ffffffffc0204902:	00008517          	auipc	a0,0x8
ffffffffc0204906:	72650513          	addi	a0,a0,1830 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc020490a:	b95fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020490e <fd_array_open.part.0>:
ffffffffc020490e:	1141                	addi	sp,sp,-16
ffffffffc0204910:	00008697          	auipc	a3,0x8
ffffffffc0204914:	7e868693          	addi	a3,a3,2024 # ffffffffc020d0f8 <default_pmm_manager+0xc88>
ffffffffc0204918:	00007617          	auipc	a2,0x7
ffffffffc020491c:	07060613          	addi	a2,a2,112 # ffffffffc020b988 <commands+0x210>
ffffffffc0204920:	05f00593          	li	a1,95
ffffffffc0204924:	00008517          	auipc	a0,0x8
ffffffffc0204928:	70450513          	addi	a0,a0,1796 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc020492c:	e406                	sd	ra,8(sp)
ffffffffc020492e:	b71fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204932 <fd_array_init>:
ffffffffc0204932:	4781                	li	a5,0
ffffffffc0204934:	04800713          	li	a4,72
ffffffffc0204938:	cd1c                	sw	a5,24(a0)
ffffffffc020493a:	02052823          	sw	zero,48(a0)
ffffffffc020493e:	00052023          	sw	zero,0(a0)
ffffffffc0204942:	2785                	addiw	a5,a5,1
ffffffffc0204944:	03850513          	addi	a0,a0,56
ffffffffc0204948:	fee798e3          	bne	a5,a4,ffffffffc0204938 <fd_array_init+0x6>
ffffffffc020494c:	8082                	ret

ffffffffc020494e <fd_array_close>:
ffffffffc020494e:	4118                	lw	a4,0(a0)
ffffffffc0204950:	1141                	addi	sp,sp,-16
ffffffffc0204952:	e406                	sd	ra,8(sp)
ffffffffc0204954:	e022                	sd	s0,0(sp)
ffffffffc0204956:	4789                	li	a5,2
ffffffffc0204958:	04f71a63          	bne	a4,a5,ffffffffc02049ac <fd_array_close+0x5e>
ffffffffc020495c:	591c                	lw	a5,48(a0)
ffffffffc020495e:	842a                	mv	s0,a0
ffffffffc0204960:	02f05663          	blez	a5,ffffffffc020498c <fd_array_close+0x3e>
ffffffffc0204964:	37fd                	addiw	a5,a5,-1
ffffffffc0204966:	470d                	li	a4,3
ffffffffc0204968:	c118                	sw	a4,0(a0)
ffffffffc020496a:	d91c                	sw	a5,48(a0)
ffffffffc020496c:	0007871b          	sext.w	a4,a5
ffffffffc0204970:	c709                	beqz	a4,ffffffffc020497a <fd_array_close+0x2c>
ffffffffc0204972:	60a2                	ld	ra,8(sp)
ffffffffc0204974:	6402                	ld	s0,0(sp)
ffffffffc0204976:	0141                	addi	sp,sp,16
ffffffffc0204978:	8082                	ret
ffffffffc020497a:	7508                	ld	a0,40(a0)
ffffffffc020497c:	772030ef          	jal	ra,ffffffffc02080ee <vfs_close>
ffffffffc0204980:	60a2                	ld	ra,8(sp)
ffffffffc0204982:	00042023          	sw	zero,0(s0)
ffffffffc0204986:	6402                	ld	s0,0(sp)
ffffffffc0204988:	0141                	addi	sp,sp,16
ffffffffc020498a:	8082                	ret
ffffffffc020498c:	00008697          	auipc	a3,0x8
ffffffffc0204990:	75468693          	addi	a3,a3,1876 # ffffffffc020d0e0 <default_pmm_manager+0xc70>
ffffffffc0204994:	00007617          	auipc	a2,0x7
ffffffffc0204998:	ff460613          	addi	a2,a2,-12 # ffffffffc020b988 <commands+0x210>
ffffffffc020499c:	06800593          	li	a1,104
ffffffffc02049a0:	00008517          	auipc	a0,0x8
ffffffffc02049a4:	68850513          	addi	a0,a0,1672 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc02049a8:	af7fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02049ac:	00008697          	auipc	a3,0x8
ffffffffc02049b0:	6a468693          	addi	a3,a3,1700 # ffffffffc020d050 <default_pmm_manager+0xbe0>
ffffffffc02049b4:	00007617          	auipc	a2,0x7
ffffffffc02049b8:	fd460613          	addi	a2,a2,-44 # ffffffffc020b988 <commands+0x210>
ffffffffc02049bc:	06700593          	li	a1,103
ffffffffc02049c0:	00008517          	auipc	a0,0x8
ffffffffc02049c4:	66850513          	addi	a0,a0,1640 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc02049c8:	ad7fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02049cc <fd_array_dup>:
ffffffffc02049cc:	7179                	addi	sp,sp,-48
ffffffffc02049ce:	e84a                	sd	s2,16(sp)
ffffffffc02049d0:	00052903          	lw	s2,0(a0)
ffffffffc02049d4:	f406                	sd	ra,40(sp)
ffffffffc02049d6:	f022                	sd	s0,32(sp)
ffffffffc02049d8:	ec26                	sd	s1,24(sp)
ffffffffc02049da:	e44e                	sd	s3,8(sp)
ffffffffc02049dc:	4785                	li	a5,1
ffffffffc02049de:	04f91663          	bne	s2,a5,ffffffffc0204a2a <fd_array_dup+0x5e>
ffffffffc02049e2:	0005a983          	lw	s3,0(a1)
ffffffffc02049e6:	4789                	li	a5,2
ffffffffc02049e8:	04f99163          	bne	s3,a5,ffffffffc0204a2a <fd_array_dup+0x5e>
ffffffffc02049ec:	7584                	ld	s1,40(a1)
ffffffffc02049ee:	699c                	ld	a5,16(a1)
ffffffffc02049f0:	7194                	ld	a3,32(a1)
ffffffffc02049f2:	6598                	ld	a4,8(a1)
ffffffffc02049f4:	842a                	mv	s0,a0
ffffffffc02049f6:	e91c                	sd	a5,16(a0)
ffffffffc02049f8:	f114                	sd	a3,32(a0)
ffffffffc02049fa:	e518                	sd	a4,8(a0)
ffffffffc02049fc:	8526                	mv	a0,s1
ffffffffc02049fe:	64f020ef          	jal	ra,ffffffffc020784c <inode_ref_inc>
ffffffffc0204a02:	8526                	mv	a0,s1
ffffffffc0204a04:	655020ef          	jal	ra,ffffffffc0207858 <inode_open_inc>
ffffffffc0204a08:	401c                	lw	a5,0(s0)
ffffffffc0204a0a:	f404                	sd	s1,40(s0)
ffffffffc0204a0c:	03279f63          	bne	a5,s2,ffffffffc0204a4a <fd_array_dup+0x7e>
ffffffffc0204a10:	cc8d                	beqz	s1,ffffffffc0204a4a <fd_array_dup+0x7e>
ffffffffc0204a12:	581c                	lw	a5,48(s0)
ffffffffc0204a14:	01342023          	sw	s3,0(s0)
ffffffffc0204a18:	70a2                	ld	ra,40(sp)
ffffffffc0204a1a:	2785                	addiw	a5,a5,1
ffffffffc0204a1c:	d81c                	sw	a5,48(s0)
ffffffffc0204a1e:	7402                	ld	s0,32(sp)
ffffffffc0204a20:	64e2                	ld	s1,24(sp)
ffffffffc0204a22:	6942                	ld	s2,16(sp)
ffffffffc0204a24:	69a2                	ld	s3,8(sp)
ffffffffc0204a26:	6145                	addi	sp,sp,48
ffffffffc0204a28:	8082                	ret
ffffffffc0204a2a:	00008697          	auipc	a3,0x8
ffffffffc0204a2e:	6fe68693          	addi	a3,a3,1790 # ffffffffc020d128 <default_pmm_manager+0xcb8>
ffffffffc0204a32:	00007617          	auipc	a2,0x7
ffffffffc0204a36:	f5660613          	addi	a2,a2,-170 # ffffffffc020b988 <commands+0x210>
ffffffffc0204a3a:	07300593          	li	a1,115
ffffffffc0204a3e:	00008517          	auipc	a0,0x8
ffffffffc0204a42:	5ea50513          	addi	a0,a0,1514 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc0204a46:	a59fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204a4a:	ec5ff0ef          	jal	ra,ffffffffc020490e <fd_array_open.part.0>

ffffffffc0204a4e <file_testfd>:
ffffffffc0204a4e:	04700793          	li	a5,71
ffffffffc0204a52:	04a7e263          	bltu	a5,a0,ffffffffc0204a96 <file_testfd+0x48>
ffffffffc0204a56:	00092797          	auipc	a5,0x92
ffffffffc0204a5a:	e6a7b783          	ld	a5,-406(a5) # ffffffffc02968c0 <current>
ffffffffc0204a5e:	1487b783          	ld	a5,328(a5)
ffffffffc0204a62:	cf85                	beqz	a5,ffffffffc0204a9a <file_testfd+0x4c>
ffffffffc0204a64:	4b98                	lw	a4,16(a5)
ffffffffc0204a66:	02e05a63          	blez	a4,ffffffffc0204a9a <file_testfd+0x4c>
ffffffffc0204a6a:	6798                	ld	a4,8(a5)
ffffffffc0204a6c:	00351793          	slli	a5,a0,0x3
ffffffffc0204a70:	8f89                	sub	a5,a5,a0
ffffffffc0204a72:	078e                	slli	a5,a5,0x3
ffffffffc0204a74:	97ba                	add	a5,a5,a4
ffffffffc0204a76:	4394                	lw	a3,0(a5)
ffffffffc0204a78:	4709                	li	a4,2
ffffffffc0204a7a:	00e69e63          	bne	a3,a4,ffffffffc0204a96 <file_testfd+0x48>
ffffffffc0204a7e:	4f98                	lw	a4,24(a5)
ffffffffc0204a80:	00a71b63          	bne	a4,a0,ffffffffc0204a96 <file_testfd+0x48>
ffffffffc0204a84:	c199                	beqz	a1,ffffffffc0204a8a <file_testfd+0x3c>
ffffffffc0204a86:	6788                	ld	a0,8(a5)
ffffffffc0204a88:	c901                	beqz	a0,ffffffffc0204a98 <file_testfd+0x4a>
ffffffffc0204a8a:	4505                	li	a0,1
ffffffffc0204a8c:	c611                	beqz	a2,ffffffffc0204a98 <file_testfd+0x4a>
ffffffffc0204a8e:	6b88                	ld	a0,16(a5)
ffffffffc0204a90:	00a03533          	snez	a0,a0
ffffffffc0204a94:	8082                	ret
ffffffffc0204a96:	4501                	li	a0,0
ffffffffc0204a98:	8082                	ret
ffffffffc0204a9a:	1141                	addi	sp,sp,-16
ffffffffc0204a9c:	e406                	sd	ra,8(sp)
ffffffffc0204a9e:	cd5ff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>

ffffffffc0204aa2 <file_open>:
ffffffffc0204aa2:	711d                	addi	sp,sp,-96
ffffffffc0204aa4:	ec86                	sd	ra,88(sp)
ffffffffc0204aa6:	e8a2                	sd	s0,80(sp)
ffffffffc0204aa8:	e4a6                	sd	s1,72(sp)
ffffffffc0204aaa:	e0ca                	sd	s2,64(sp)
ffffffffc0204aac:	fc4e                	sd	s3,56(sp)
ffffffffc0204aae:	f852                	sd	s4,48(sp)
ffffffffc0204ab0:	0035f793          	andi	a5,a1,3
ffffffffc0204ab4:	470d                	li	a4,3
ffffffffc0204ab6:	0ce78163          	beq	a5,a4,ffffffffc0204b78 <file_open+0xd6>
ffffffffc0204aba:	078e                	slli	a5,a5,0x3
ffffffffc0204abc:	00009717          	auipc	a4,0x9
ffffffffc0204ac0:	8dc70713          	addi	a4,a4,-1828 # ffffffffc020d398 <CSWTCH.79>
ffffffffc0204ac4:	892a                	mv	s2,a0
ffffffffc0204ac6:	00009697          	auipc	a3,0x9
ffffffffc0204aca:	8ba68693          	addi	a3,a3,-1862 # ffffffffc020d380 <CSWTCH.78>
ffffffffc0204ace:	755d                	lui	a0,0xffff7
ffffffffc0204ad0:	96be                	add	a3,a3,a5
ffffffffc0204ad2:	84ae                	mv	s1,a1
ffffffffc0204ad4:	97ba                	add	a5,a5,a4
ffffffffc0204ad6:	858a                	mv	a1,sp
ffffffffc0204ad8:	ad950513          	addi	a0,a0,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0204adc:	0006ba03          	ld	s4,0(a3)
ffffffffc0204ae0:	0007b983          	ld	s3,0(a5)
ffffffffc0204ae4:	cb1ff0ef          	jal	ra,ffffffffc0204794 <fd_array_alloc>
ffffffffc0204ae8:	842a                	mv	s0,a0
ffffffffc0204aea:	c911                	beqz	a0,ffffffffc0204afe <file_open+0x5c>
ffffffffc0204aec:	60e6                	ld	ra,88(sp)
ffffffffc0204aee:	8522                	mv	a0,s0
ffffffffc0204af0:	6446                	ld	s0,80(sp)
ffffffffc0204af2:	64a6                	ld	s1,72(sp)
ffffffffc0204af4:	6906                	ld	s2,64(sp)
ffffffffc0204af6:	79e2                	ld	s3,56(sp)
ffffffffc0204af8:	7a42                	ld	s4,48(sp)
ffffffffc0204afa:	6125                	addi	sp,sp,96
ffffffffc0204afc:	8082                	ret
ffffffffc0204afe:	0030                	addi	a2,sp,8
ffffffffc0204b00:	85a6                	mv	a1,s1
ffffffffc0204b02:	854a                	mv	a0,s2
ffffffffc0204b04:	444030ef          	jal	ra,ffffffffc0207f48 <vfs_open>
ffffffffc0204b08:	842a                	mv	s0,a0
ffffffffc0204b0a:	e13d                	bnez	a0,ffffffffc0204b70 <file_open+0xce>
ffffffffc0204b0c:	6782                	ld	a5,0(sp)
ffffffffc0204b0e:	0204f493          	andi	s1,s1,32
ffffffffc0204b12:	6422                	ld	s0,8(sp)
ffffffffc0204b14:	0207b023          	sd	zero,32(a5)
ffffffffc0204b18:	c885                	beqz	s1,ffffffffc0204b48 <file_open+0xa6>
ffffffffc0204b1a:	c03d                	beqz	s0,ffffffffc0204b80 <file_open+0xde>
ffffffffc0204b1c:	783c                	ld	a5,112(s0)
ffffffffc0204b1e:	c3ad                	beqz	a5,ffffffffc0204b80 <file_open+0xde>
ffffffffc0204b20:	779c                	ld	a5,40(a5)
ffffffffc0204b22:	cfb9                	beqz	a5,ffffffffc0204b80 <file_open+0xde>
ffffffffc0204b24:	8522                	mv	a0,s0
ffffffffc0204b26:	00008597          	auipc	a1,0x8
ffffffffc0204b2a:	68a58593          	addi	a1,a1,1674 # ffffffffc020d1b0 <default_pmm_manager+0xd40>
ffffffffc0204b2e:	537020ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0204b32:	783c                	ld	a5,112(s0)
ffffffffc0204b34:	6522                	ld	a0,8(sp)
ffffffffc0204b36:	080c                	addi	a1,sp,16
ffffffffc0204b38:	779c                	ld	a5,40(a5)
ffffffffc0204b3a:	9782                	jalr	a5
ffffffffc0204b3c:	842a                	mv	s0,a0
ffffffffc0204b3e:	e515                	bnez	a0,ffffffffc0204b6a <file_open+0xc8>
ffffffffc0204b40:	6782                	ld	a5,0(sp)
ffffffffc0204b42:	7722                	ld	a4,40(sp)
ffffffffc0204b44:	6422                	ld	s0,8(sp)
ffffffffc0204b46:	f398                	sd	a4,32(a5)
ffffffffc0204b48:	4394                	lw	a3,0(a5)
ffffffffc0204b4a:	f780                	sd	s0,40(a5)
ffffffffc0204b4c:	0147b423          	sd	s4,8(a5)
ffffffffc0204b50:	0137b823          	sd	s3,16(a5)
ffffffffc0204b54:	4705                	li	a4,1
ffffffffc0204b56:	02e69363          	bne	a3,a4,ffffffffc0204b7c <file_open+0xda>
ffffffffc0204b5a:	c00d                	beqz	s0,ffffffffc0204b7c <file_open+0xda>
ffffffffc0204b5c:	5b98                	lw	a4,48(a5)
ffffffffc0204b5e:	4689                	li	a3,2
ffffffffc0204b60:	4f80                	lw	s0,24(a5)
ffffffffc0204b62:	2705                	addiw	a4,a4,1
ffffffffc0204b64:	c394                	sw	a3,0(a5)
ffffffffc0204b66:	db98                	sw	a4,48(a5)
ffffffffc0204b68:	b751                	j	ffffffffc0204aec <file_open+0x4a>
ffffffffc0204b6a:	6522                	ld	a0,8(sp)
ffffffffc0204b6c:	582030ef          	jal	ra,ffffffffc02080ee <vfs_close>
ffffffffc0204b70:	6502                	ld	a0,0(sp)
ffffffffc0204b72:	cb7ff0ef          	jal	ra,ffffffffc0204828 <fd_array_free>
ffffffffc0204b76:	bf9d                	j	ffffffffc0204aec <file_open+0x4a>
ffffffffc0204b78:	5475                	li	s0,-3
ffffffffc0204b7a:	bf8d                	j	ffffffffc0204aec <file_open+0x4a>
ffffffffc0204b7c:	d93ff0ef          	jal	ra,ffffffffc020490e <fd_array_open.part.0>
ffffffffc0204b80:	00008697          	auipc	a3,0x8
ffffffffc0204b84:	5e068693          	addi	a3,a3,1504 # ffffffffc020d160 <default_pmm_manager+0xcf0>
ffffffffc0204b88:	00007617          	auipc	a2,0x7
ffffffffc0204b8c:	e0060613          	addi	a2,a2,-512 # ffffffffc020b988 <commands+0x210>
ffffffffc0204b90:	0b500593          	li	a1,181
ffffffffc0204b94:	00008517          	auipc	a0,0x8
ffffffffc0204b98:	49450513          	addi	a0,a0,1172 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc0204b9c:	903fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204ba0 <file_close>:
ffffffffc0204ba0:	04700713          	li	a4,71
ffffffffc0204ba4:	04a76563          	bltu	a4,a0,ffffffffc0204bee <file_close+0x4e>
ffffffffc0204ba8:	00092717          	auipc	a4,0x92
ffffffffc0204bac:	d1873703          	ld	a4,-744(a4) # ffffffffc02968c0 <current>
ffffffffc0204bb0:	14873703          	ld	a4,328(a4)
ffffffffc0204bb4:	1141                	addi	sp,sp,-16
ffffffffc0204bb6:	e406                	sd	ra,8(sp)
ffffffffc0204bb8:	cf0d                	beqz	a4,ffffffffc0204bf2 <file_close+0x52>
ffffffffc0204bba:	4b14                	lw	a3,16(a4)
ffffffffc0204bbc:	02d05b63          	blez	a3,ffffffffc0204bf2 <file_close+0x52>
ffffffffc0204bc0:	6718                	ld	a4,8(a4)
ffffffffc0204bc2:	87aa                	mv	a5,a0
ffffffffc0204bc4:	050e                	slli	a0,a0,0x3
ffffffffc0204bc6:	8d1d                	sub	a0,a0,a5
ffffffffc0204bc8:	050e                	slli	a0,a0,0x3
ffffffffc0204bca:	953a                	add	a0,a0,a4
ffffffffc0204bcc:	4114                	lw	a3,0(a0)
ffffffffc0204bce:	4709                	li	a4,2
ffffffffc0204bd0:	00e69b63          	bne	a3,a4,ffffffffc0204be6 <file_close+0x46>
ffffffffc0204bd4:	4d18                	lw	a4,24(a0)
ffffffffc0204bd6:	00f71863          	bne	a4,a5,ffffffffc0204be6 <file_close+0x46>
ffffffffc0204bda:	d75ff0ef          	jal	ra,ffffffffc020494e <fd_array_close>
ffffffffc0204bde:	60a2                	ld	ra,8(sp)
ffffffffc0204be0:	4501                	li	a0,0
ffffffffc0204be2:	0141                	addi	sp,sp,16
ffffffffc0204be4:	8082                	ret
ffffffffc0204be6:	60a2                	ld	ra,8(sp)
ffffffffc0204be8:	5575                	li	a0,-3
ffffffffc0204bea:	0141                	addi	sp,sp,16
ffffffffc0204bec:	8082                	ret
ffffffffc0204bee:	5575                	li	a0,-3
ffffffffc0204bf0:	8082                	ret
ffffffffc0204bf2:	b81ff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>

ffffffffc0204bf6 <file_read>:
ffffffffc0204bf6:	715d                	addi	sp,sp,-80
ffffffffc0204bf8:	e486                	sd	ra,72(sp)
ffffffffc0204bfa:	e0a2                	sd	s0,64(sp)
ffffffffc0204bfc:	fc26                	sd	s1,56(sp)
ffffffffc0204bfe:	f84a                	sd	s2,48(sp)
ffffffffc0204c00:	f44e                	sd	s3,40(sp)
ffffffffc0204c02:	f052                	sd	s4,32(sp)
ffffffffc0204c04:	0006b023          	sd	zero,0(a3)
ffffffffc0204c08:	04700793          	li	a5,71
ffffffffc0204c0c:	0aa7e463          	bltu	a5,a0,ffffffffc0204cb4 <file_read+0xbe>
ffffffffc0204c10:	00092797          	auipc	a5,0x92
ffffffffc0204c14:	cb07b783          	ld	a5,-848(a5) # ffffffffc02968c0 <current>
ffffffffc0204c18:	1487b783          	ld	a5,328(a5)
ffffffffc0204c1c:	cfd1                	beqz	a5,ffffffffc0204cb8 <file_read+0xc2>
ffffffffc0204c1e:	4b98                	lw	a4,16(a5)
ffffffffc0204c20:	08e05c63          	blez	a4,ffffffffc0204cb8 <file_read+0xc2>
ffffffffc0204c24:	6780                	ld	s0,8(a5)
ffffffffc0204c26:	00351793          	slli	a5,a0,0x3
ffffffffc0204c2a:	8f89                	sub	a5,a5,a0
ffffffffc0204c2c:	078e                	slli	a5,a5,0x3
ffffffffc0204c2e:	943e                	add	s0,s0,a5
ffffffffc0204c30:	00042983          	lw	s3,0(s0)
ffffffffc0204c34:	4789                	li	a5,2
ffffffffc0204c36:	06f99f63          	bne	s3,a5,ffffffffc0204cb4 <file_read+0xbe>
ffffffffc0204c3a:	4c1c                	lw	a5,24(s0)
ffffffffc0204c3c:	06a79c63          	bne	a5,a0,ffffffffc0204cb4 <file_read+0xbe>
ffffffffc0204c40:	641c                	ld	a5,8(s0)
ffffffffc0204c42:	cbad                	beqz	a5,ffffffffc0204cb4 <file_read+0xbe>
ffffffffc0204c44:	581c                	lw	a5,48(s0)
ffffffffc0204c46:	8a36                	mv	s4,a3
ffffffffc0204c48:	7014                	ld	a3,32(s0)
ffffffffc0204c4a:	2785                	addiw	a5,a5,1
ffffffffc0204c4c:	850a                	mv	a0,sp
ffffffffc0204c4e:	d81c                	sw	a5,48(s0)
ffffffffc0204c50:	792000ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc0204c54:	02843903          	ld	s2,40(s0)
ffffffffc0204c58:	84aa                	mv	s1,a0
ffffffffc0204c5a:	06090163          	beqz	s2,ffffffffc0204cbc <file_read+0xc6>
ffffffffc0204c5e:	07093783          	ld	a5,112(s2)
ffffffffc0204c62:	cfa9                	beqz	a5,ffffffffc0204cbc <file_read+0xc6>
ffffffffc0204c64:	6f9c                	ld	a5,24(a5)
ffffffffc0204c66:	cbb9                	beqz	a5,ffffffffc0204cbc <file_read+0xc6>
ffffffffc0204c68:	00008597          	auipc	a1,0x8
ffffffffc0204c6c:	5a058593          	addi	a1,a1,1440 # ffffffffc020d208 <default_pmm_manager+0xd98>
ffffffffc0204c70:	854a                	mv	a0,s2
ffffffffc0204c72:	3f3020ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0204c76:	07093783          	ld	a5,112(s2)
ffffffffc0204c7a:	7408                	ld	a0,40(s0)
ffffffffc0204c7c:	85a6                	mv	a1,s1
ffffffffc0204c7e:	6f9c                	ld	a5,24(a5)
ffffffffc0204c80:	9782                	jalr	a5
ffffffffc0204c82:	689c                	ld	a5,16(s1)
ffffffffc0204c84:	6c94                	ld	a3,24(s1)
ffffffffc0204c86:	4018                	lw	a4,0(s0)
ffffffffc0204c88:	84aa                	mv	s1,a0
ffffffffc0204c8a:	8f95                	sub	a5,a5,a3
ffffffffc0204c8c:	03370063          	beq	a4,s3,ffffffffc0204cac <file_read+0xb6>
ffffffffc0204c90:	00fa3023          	sd	a5,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0204c94:	8522                	mv	a0,s0
ffffffffc0204c96:	c0fff0ef          	jal	ra,ffffffffc02048a4 <fd_array_release>
ffffffffc0204c9a:	60a6                	ld	ra,72(sp)
ffffffffc0204c9c:	6406                	ld	s0,64(sp)
ffffffffc0204c9e:	7942                	ld	s2,48(sp)
ffffffffc0204ca0:	79a2                	ld	s3,40(sp)
ffffffffc0204ca2:	7a02                	ld	s4,32(sp)
ffffffffc0204ca4:	8526                	mv	a0,s1
ffffffffc0204ca6:	74e2                	ld	s1,56(sp)
ffffffffc0204ca8:	6161                	addi	sp,sp,80
ffffffffc0204caa:	8082                	ret
ffffffffc0204cac:	7018                	ld	a4,32(s0)
ffffffffc0204cae:	973e                	add	a4,a4,a5
ffffffffc0204cb0:	f018                	sd	a4,32(s0)
ffffffffc0204cb2:	bff9                	j	ffffffffc0204c90 <file_read+0x9a>
ffffffffc0204cb4:	54f5                	li	s1,-3
ffffffffc0204cb6:	b7d5                	j	ffffffffc0204c9a <file_read+0xa4>
ffffffffc0204cb8:	abbff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>
ffffffffc0204cbc:	00008697          	auipc	a3,0x8
ffffffffc0204cc0:	4fc68693          	addi	a3,a3,1276 # ffffffffc020d1b8 <default_pmm_manager+0xd48>
ffffffffc0204cc4:	00007617          	auipc	a2,0x7
ffffffffc0204cc8:	cc460613          	addi	a2,a2,-828 # ffffffffc020b988 <commands+0x210>
ffffffffc0204ccc:	0de00593          	li	a1,222
ffffffffc0204cd0:	00008517          	auipc	a0,0x8
ffffffffc0204cd4:	35850513          	addi	a0,a0,856 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc0204cd8:	fc6fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204cdc <file_write>:
ffffffffc0204cdc:	715d                	addi	sp,sp,-80
ffffffffc0204cde:	e486                	sd	ra,72(sp)
ffffffffc0204ce0:	e0a2                	sd	s0,64(sp)
ffffffffc0204ce2:	fc26                	sd	s1,56(sp)
ffffffffc0204ce4:	f84a                	sd	s2,48(sp)
ffffffffc0204ce6:	f44e                	sd	s3,40(sp)
ffffffffc0204ce8:	f052                	sd	s4,32(sp)
ffffffffc0204cea:	0006b023          	sd	zero,0(a3)
ffffffffc0204cee:	04700793          	li	a5,71
ffffffffc0204cf2:	0aa7e463          	bltu	a5,a0,ffffffffc0204d9a <file_write+0xbe>
ffffffffc0204cf6:	00092797          	auipc	a5,0x92
ffffffffc0204cfa:	bca7b783          	ld	a5,-1078(a5) # ffffffffc02968c0 <current>
ffffffffc0204cfe:	1487b783          	ld	a5,328(a5)
ffffffffc0204d02:	cfd1                	beqz	a5,ffffffffc0204d9e <file_write+0xc2>
ffffffffc0204d04:	4b98                	lw	a4,16(a5)
ffffffffc0204d06:	08e05c63          	blez	a4,ffffffffc0204d9e <file_write+0xc2>
ffffffffc0204d0a:	6780                	ld	s0,8(a5)
ffffffffc0204d0c:	00351793          	slli	a5,a0,0x3
ffffffffc0204d10:	8f89                	sub	a5,a5,a0
ffffffffc0204d12:	078e                	slli	a5,a5,0x3
ffffffffc0204d14:	943e                	add	s0,s0,a5
ffffffffc0204d16:	00042983          	lw	s3,0(s0)
ffffffffc0204d1a:	4789                	li	a5,2
ffffffffc0204d1c:	06f99f63          	bne	s3,a5,ffffffffc0204d9a <file_write+0xbe>
ffffffffc0204d20:	4c1c                	lw	a5,24(s0)
ffffffffc0204d22:	06a79c63          	bne	a5,a0,ffffffffc0204d9a <file_write+0xbe>
ffffffffc0204d26:	681c                	ld	a5,16(s0)
ffffffffc0204d28:	cbad                	beqz	a5,ffffffffc0204d9a <file_write+0xbe>
ffffffffc0204d2a:	581c                	lw	a5,48(s0)
ffffffffc0204d2c:	8a36                	mv	s4,a3
ffffffffc0204d2e:	7014                	ld	a3,32(s0)
ffffffffc0204d30:	2785                	addiw	a5,a5,1
ffffffffc0204d32:	850a                	mv	a0,sp
ffffffffc0204d34:	d81c                	sw	a5,48(s0)
ffffffffc0204d36:	6ac000ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc0204d3a:	02843903          	ld	s2,40(s0)
ffffffffc0204d3e:	84aa                	mv	s1,a0
ffffffffc0204d40:	06090163          	beqz	s2,ffffffffc0204da2 <file_write+0xc6>
ffffffffc0204d44:	07093783          	ld	a5,112(s2)
ffffffffc0204d48:	cfa9                	beqz	a5,ffffffffc0204da2 <file_write+0xc6>
ffffffffc0204d4a:	739c                	ld	a5,32(a5)
ffffffffc0204d4c:	cbb9                	beqz	a5,ffffffffc0204da2 <file_write+0xc6>
ffffffffc0204d4e:	00008597          	auipc	a1,0x8
ffffffffc0204d52:	51258593          	addi	a1,a1,1298 # ffffffffc020d260 <default_pmm_manager+0xdf0>
ffffffffc0204d56:	854a                	mv	a0,s2
ffffffffc0204d58:	30d020ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0204d5c:	07093783          	ld	a5,112(s2)
ffffffffc0204d60:	7408                	ld	a0,40(s0)
ffffffffc0204d62:	85a6                	mv	a1,s1
ffffffffc0204d64:	739c                	ld	a5,32(a5)
ffffffffc0204d66:	9782                	jalr	a5
ffffffffc0204d68:	689c                	ld	a5,16(s1)
ffffffffc0204d6a:	6c94                	ld	a3,24(s1)
ffffffffc0204d6c:	4018                	lw	a4,0(s0)
ffffffffc0204d6e:	84aa                	mv	s1,a0
ffffffffc0204d70:	8f95                	sub	a5,a5,a3
ffffffffc0204d72:	03370063          	beq	a4,s3,ffffffffc0204d92 <file_write+0xb6>
ffffffffc0204d76:	00fa3023          	sd	a5,0(s4)
ffffffffc0204d7a:	8522                	mv	a0,s0
ffffffffc0204d7c:	b29ff0ef          	jal	ra,ffffffffc02048a4 <fd_array_release>
ffffffffc0204d80:	60a6                	ld	ra,72(sp)
ffffffffc0204d82:	6406                	ld	s0,64(sp)
ffffffffc0204d84:	7942                	ld	s2,48(sp)
ffffffffc0204d86:	79a2                	ld	s3,40(sp)
ffffffffc0204d88:	7a02                	ld	s4,32(sp)
ffffffffc0204d8a:	8526                	mv	a0,s1
ffffffffc0204d8c:	74e2                	ld	s1,56(sp)
ffffffffc0204d8e:	6161                	addi	sp,sp,80
ffffffffc0204d90:	8082                	ret
ffffffffc0204d92:	7018                	ld	a4,32(s0)
ffffffffc0204d94:	973e                	add	a4,a4,a5
ffffffffc0204d96:	f018                	sd	a4,32(s0)
ffffffffc0204d98:	bff9                	j	ffffffffc0204d76 <file_write+0x9a>
ffffffffc0204d9a:	54f5                	li	s1,-3
ffffffffc0204d9c:	b7d5                	j	ffffffffc0204d80 <file_write+0xa4>
ffffffffc0204d9e:	9d5ff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>
ffffffffc0204da2:	00008697          	auipc	a3,0x8
ffffffffc0204da6:	46e68693          	addi	a3,a3,1134 # ffffffffc020d210 <default_pmm_manager+0xda0>
ffffffffc0204daa:	00007617          	auipc	a2,0x7
ffffffffc0204dae:	bde60613          	addi	a2,a2,-1058 # ffffffffc020b988 <commands+0x210>
ffffffffc0204db2:	0f800593          	li	a1,248
ffffffffc0204db6:	00008517          	auipc	a0,0x8
ffffffffc0204dba:	27250513          	addi	a0,a0,626 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc0204dbe:	ee0fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204dc2 <file_seek>:
ffffffffc0204dc2:	7139                	addi	sp,sp,-64
ffffffffc0204dc4:	fc06                	sd	ra,56(sp)
ffffffffc0204dc6:	f822                	sd	s0,48(sp)
ffffffffc0204dc8:	f426                	sd	s1,40(sp)
ffffffffc0204dca:	f04a                	sd	s2,32(sp)
ffffffffc0204dcc:	04700793          	li	a5,71
ffffffffc0204dd0:	08a7e863          	bltu	a5,a0,ffffffffc0204e60 <file_seek+0x9e>
ffffffffc0204dd4:	00092797          	auipc	a5,0x92
ffffffffc0204dd8:	aec7b783          	ld	a5,-1300(a5) # ffffffffc02968c0 <current>
ffffffffc0204ddc:	1487b783          	ld	a5,328(a5)
ffffffffc0204de0:	cfdd                	beqz	a5,ffffffffc0204e9e <file_seek+0xdc>
ffffffffc0204de2:	4b98                	lw	a4,16(a5)
ffffffffc0204de4:	0ae05d63          	blez	a4,ffffffffc0204e9e <file_seek+0xdc>
ffffffffc0204de8:	6780                	ld	s0,8(a5)
ffffffffc0204dea:	00351793          	slli	a5,a0,0x3
ffffffffc0204dee:	8f89                	sub	a5,a5,a0
ffffffffc0204df0:	078e                	slli	a5,a5,0x3
ffffffffc0204df2:	943e                	add	s0,s0,a5
ffffffffc0204df4:	4018                	lw	a4,0(s0)
ffffffffc0204df6:	4789                	li	a5,2
ffffffffc0204df8:	06f71463          	bne	a4,a5,ffffffffc0204e60 <file_seek+0x9e>
ffffffffc0204dfc:	4c1c                	lw	a5,24(s0)
ffffffffc0204dfe:	06a79163          	bne	a5,a0,ffffffffc0204e60 <file_seek+0x9e>
ffffffffc0204e02:	581c                	lw	a5,48(s0)
ffffffffc0204e04:	4685                	li	a3,1
ffffffffc0204e06:	892e                	mv	s2,a1
ffffffffc0204e08:	2785                	addiw	a5,a5,1
ffffffffc0204e0a:	d81c                	sw	a5,48(s0)
ffffffffc0204e0c:	02d60063          	beq	a2,a3,ffffffffc0204e2c <file_seek+0x6a>
ffffffffc0204e10:	06e60063          	beq	a2,a4,ffffffffc0204e70 <file_seek+0xae>
ffffffffc0204e14:	54f5                	li	s1,-3
ffffffffc0204e16:	ce11                	beqz	a2,ffffffffc0204e32 <file_seek+0x70>
ffffffffc0204e18:	8522                	mv	a0,s0
ffffffffc0204e1a:	a8bff0ef          	jal	ra,ffffffffc02048a4 <fd_array_release>
ffffffffc0204e1e:	70e2                	ld	ra,56(sp)
ffffffffc0204e20:	7442                	ld	s0,48(sp)
ffffffffc0204e22:	7902                	ld	s2,32(sp)
ffffffffc0204e24:	8526                	mv	a0,s1
ffffffffc0204e26:	74a2                	ld	s1,40(sp)
ffffffffc0204e28:	6121                	addi	sp,sp,64
ffffffffc0204e2a:	8082                	ret
ffffffffc0204e2c:	701c                	ld	a5,32(s0)
ffffffffc0204e2e:	00f58933          	add	s2,a1,a5
ffffffffc0204e32:	7404                	ld	s1,40(s0)
ffffffffc0204e34:	c4bd                	beqz	s1,ffffffffc0204ea2 <file_seek+0xe0>
ffffffffc0204e36:	78bc                	ld	a5,112(s1)
ffffffffc0204e38:	c7ad                	beqz	a5,ffffffffc0204ea2 <file_seek+0xe0>
ffffffffc0204e3a:	6fbc                	ld	a5,88(a5)
ffffffffc0204e3c:	c3bd                	beqz	a5,ffffffffc0204ea2 <file_seek+0xe0>
ffffffffc0204e3e:	8526                	mv	a0,s1
ffffffffc0204e40:	00008597          	auipc	a1,0x8
ffffffffc0204e44:	47858593          	addi	a1,a1,1144 # ffffffffc020d2b8 <default_pmm_manager+0xe48>
ffffffffc0204e48:	21d020ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0204e4c:	78bc                	ld	a5,112(s1)
ffffffffc0204e4e:	7408                	ld	a0,40(s0)
ffffffffc0204e50:	85ca                	mv	a1,s2
ffffffffc0204e52:	6fbc                	ld	a5,88(a5)
ffffffffc0204e54:	9782                	jalr	a5
ffffffffc0204e56:	84aa                	mv	s1,a0
ffffffffc0204e58:	f161                	bnez	a0,ffffffffc0204e18 <file_seek+0x56>
ffffffffc0204e5a:	03243023          	sd	s2,32(s0)
ffffffffc0204e5e:	bf6d                	j	ffffffffc0204e18 <file_seek+0x56>
ffffffffc0204e60:	70e2                	ld	ra,56(sp)
ffffffffc0204e62:	7442                	ld	s0,48(sp)
ffffffffc0204e64:	54f5                	li	s1,-3
ffffffffc0204e66:	7902                	ld	s2,32(sp)
ffffffffc0204e68:	8526                	mv	a0,s1
ffffffffc0204e6a:	74a2                	ld	s1,40(sp)
ffffffffc0204e6c:	6121                	addi	sp,sp,64
ffffffffc0204e6e:	8082                	ret
ffffffffc0204e70:	7404                	ld	s1,40(s0)
ffffffffc0204e72:	c8a1                	beqz	s1,ffffffffc0204ec2 <file_seek+0x100>
ffffffffc0204e74:	78bc                	ld	a5,112(s1)
ffffffffc0204e76:	c7b1                	beqz	a5,ffffffffc0204ec2 <file_seek+0x100>
ffffffffc0204e78:	779c                	ld	a5,40(a5)
ffffffffc0204e7a:	c7a1                	beqz	a5,ffffffffc0204ec2 <file_seek+0x100>
ffffffffc0204e7c:	8526                	mv	a0,s1
ffffffffc0204e7e:	00008597          	auipc	a1,0x8
ffffffffc0204e82:	33258593          	addi	a1,a1,818 # ffffffffc020d1b0 <default_pmm_manager+0xd40>
ffffffffc0204e86:	1df020ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0204e8a:	78bc                	ld	a5,112(s1)
ffffffffc0204e8c:	7408                	ld	a0,40(s0)
ffffffffc0204e8e:	858a                	mv	a1,sp
ffffffffc0204e90:	779c                	ld	a5,40(a5)
ffffffffc0204e92:	9782                	jalr	a5
ffffffffc0204e94:	84aa                	mv	s1,a0
ffffffffc0204e96:	f149                	bnez	a0,ffffffffc0204e18 <file_seek+0x56>
ffffffffc0204e98:	67e2                	ld	a5,24(sp)
ffffffffc0204e9a:	993e                	add	s2,s2,a5
ffffffffc0204e9c:	bf59                	j	ffffffffc0204e32 <file_seek+0x70>
ffffffffc0204e9e:	8d5ff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>
ffffffffc0204ea2:	00008697          	auipc	a3,0x8
ffffffffc0204ea6:	3c668693          	addi	a3,a3,966 # ffffffffc020d268 <default_pmm_manager+0xdf8>
ffffffffc0204eaa:	00007617          	auipc	a2,0x7
ffffffffc0204eae:	ade60613          	addi	a2,a2,-1314 # ffffffffc020b988 <commands+0x210>
ffffffffc0204eb2:	11a00593          	li	a1,282
ffffffffc0204eb6:	00008517          	auipc	a0,0x8
ffffffffc0204eba:	17250513          	addi	a0,a0,370 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc0204ebe:	de0fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204ec2:	00008697          	auipc	a3,0x8
ffffffffc0204ec6:	29e68693          	addi	a3,a3,670 # ffffffffc020d160 <default_pmm_manager+0xcf0>
ffffffffc0204eca:	00007617          	auipc	a2,0x7
ffffffffc0204ece:	abe60613          	addi	a2,a2,-1346 # ffffffffc020b988 <commands+0x210>
ffffffffc0204ed2:	11200593          	li	a1,274
ffffffffc0204ed6:	00008517          	auipc	a0,0x8
ffffffffc0204eda:	15250513          	addi	a0,a0,338 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc0204ede:	dc0fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204ee2 <file_fstat>:
ffffffffc0204ee2:	1101                	addi	sp,sp,-32
ffffffffc0204ee4:	ec06                	sd	ra,24(sp)
ffffffffc0204ee6:	e822                	sd	s0,16(sp)
ffffffffc0204ee8:	e426                	sd	s1,8(sp)
ffffffffc0204eea:	e04a                	sd	s2,0(sp)
ffffffffc0204eec:	04700793          	li	a5,71
ffffffffc0204ef0:	06a7ef63          	bltu	a5,a0,ffffffffc0204f6e <file_fstat+0x8c>
ffffffffc0204ef4:	00092797          	auipc	a5,0x92
ffffffffc0204ef8:	9cc7b783          	ld	a5,-1588(a5) # ffffffffc02968c0 <current>
ffffffffc0204efc:	1487b783          	ld	a5,328(a5)
ffffffffc0204f00:	cfd9                	beqz	a5,ffffffffc0204f9e <file_fstat+0xbc>
ffffffffc0204f02:	4b98                	lw	a4,16(a5)
ffffffffc0204f04:	08e05d63          	blez	a4,ffffffffc0204f9e <file_fstat+0xbc>
ffffffffc0204f08:	6780                	ld	s0,8(a5)
ffffffffc0204f0a:	00351793          	slli	a5,a0,0x3
ffffffffc0204f0e:	8f89                	sub	a5,a5,a0
ffffffffc0204f10:	078e                	slli	a5,a5,0x3
ffffffffc0204f12:	943e                	add	s0,s0,a5
ffffffffc0204f14:	4018                	lw	a4,0(s0)
ffffffffc0204f16:	4789                	li	a5,2
ffffffffc0204f18:	04f71b63          	bne	a4,a5,ffffffffc0204f6e <file_fstat+0x8c>
ffffffffc0204f1c:	4c1c                	lw	a5,24(s0)
ffffffffc0204f1e:	04a79863          	bne	a5,a0,ffffffffc0204f6e <file_fstat+0x8c>
ffffffffc0204f22:	581c                	lw	a5,48(s0)
ffffffffc0204f24:	02843903          	ld	s2,40(s0)
ffffffffc0204f28:	2785                	addiw	a5,a5,1
ffffffffc0204f2a:	d81c                	sw	a5,48(s0)
ffffffffc0204f2c:	04090963          	beqz	s2,ffffffffc0204f7e <file_fstat+0x9c>
ffffffffc0204f30:	07093783          	ld	a5,112(s2)
ffffffffc0204f34:	c7a9                	beqz	a5,ffffffffc0204f7e <file_fstat+0x9c>
ffffffffc0204f36:	779c                	ld	a5,40(a5)
ffffffffc0204f38:	c3b9                	beqz	a5,ffffffffc0204f7e <file_fstat+0x9c>
ffffffffc0204f3a:	84ae                	mv	s1,a1
ffffffffc0204f3c:	854a                	mv	a0,s2
ffffffffc0204f3e:	00008597          	auipc	a1,0x8
ffffffffc0204f42:	27258593          	addi	a1,a1,626 # ffffffffc020d1b0 <default_pmm_manager+0xd40>
ffffffffc0204f46:	11f020ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0204f4a:	07093783          	ld	a5,112(s2)
ffffffffc0204f4e:	7408                	ld	a0,40(s0)
ffffffffc0204f50:	85a6                	mv	a1,s1
ffffffffc0204f52:	779c                	ld	a5,40(a5)
ffffffffc0204f54:	9782                	jalr	a5
ffffffffc0204f56:	87aa                	mv	a5,a0
ffffffffc0204f58:	8522                	mv	a0,s0
ffffffffc0204f5a:	843e                	mv	s0,a5
ffffffffc0204f5c:	949ff0ef          	jal	ra,ffffffffc02048a4 <fd_array_release>
ffffffffc0204f60:	60e2                	ld	ra,24(sp)
ffffffffc0204f62:	8522                	mv	a0,s0
ffffffffc0204f64:	6442                	ld	s0,16(sp)
ffffffffc0204f66:	64a2                	ld	s1,8(sp)
ffffffffc0204f68:	6902                	ld	s2,0(sp)
ffffffffc0204f6a:	6105                	addi	sp,sp,32
ffffffffc0204f6c:	8082                	ret
ffffffffc0204f6e:	5475                	li	s0,-3
ffffffffc0204f70:	60e2                	ld	ra,24(sp)
ffffffffc0204f72:	8522                	mv	a0,s0
ffffffffc0204f74:	6442                	ld	s0,16(sp)
ffffffffc0204f76:	64a2                	ld	s1,8(sp)
ffffffffc0204f78:	6902                	ld	s2,0(sp)
ffffffffc0204f7a:	6105                	addi	sp,sp,32
ffffffffc0204f7c:	8082                	ret
ffffffffc0204f7e:	00008697          	auipc	a3,0x8
ffffffffc0204f82:	1e268693          	addi	a3,a3,482 # ffffffffc020d160 <default_pmm_manager+0xcf0>
ffffffffc0204f86:	00007617          	auipc	a2,0x7
ffffffffc0204f8a:	a0260613          	addi	a2,a2,-1534 # ffffffffc020b988 <commands+0x210>
ffffffffc0204f8e:	12c00593          	li	a1,300
ffffffffc0204f92:	00008517          	auipc	a0,0x8
ffffffffc0204f96:	09650513          	addi	a0,a0,150 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc0204f9a:	d04fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204f9e:	fd4ff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>

ffffffffc0204fa2 <file_fsync>:
ffffffffc0204fa2:	1101                	addi	sp,sp,-32
ffffffffc0204fa4:	ec06                	sd	ra,24(sp)
ffffffffc0204fa6:	e822                	sd	s0,16(sp)
ffffffffc0204fa8:	e426                	sd	s1,8(sp)
ffffffffc0204faa:	04700793          	li	a5,71
ffffffffc0204fae:	06a7e863          	bltu	a5,a0,ffffffffc020501e <file_fsync+0x7c>
ffffffffc0204fb2:	00092797          	auipc	a5,0x92
ffffffffc0204fb6:	90e7b783          	ld	a5,-1778(a5) # ffffffffc02968c0 <current>
ffffffffc0204fba:	1487b783          	ld	a5,328(a5)
ffffffffc0204fbe:	c7d9                	beqz	a5,ffffffffc020504c <file_fsync+0xaa>
ffffffffc0204fc0:	4b98                	lw	a4,16(a5)
ffffffffc0204fc2:	08e05563          	blez	a4,ffffffffc020504c <file_fsync+0xaa>
ffffffffc0204fc6:	6780                	ld	s0,8(a5)
ffffffffc0204fc8:	00351793          	slli	a5,a0,0x3
ffffffffc0204fcc:	8f89                	sub	a5,a5,a0
ffffffffc0204fce:	078e                	slli	a5,a5,0x3
ffffffffc0204fd0:	943e                	add	s0,s0,a5
ffffffffc0204fd2:	4018                	lw	a4,0(s0)
ffffffffc0204fd4:	4789                	li	a5,2
ffffffffc0204fd6:	04f71463          	bne	a4,a5,ffffffffc020501e <file_fsync+0x7c>
ffffffffc0204fda:	4c1c                	lw	a5,24(s0)
ffffffffc0204fdc:	04a79163          	bne	a5,a0,ffffffffc020501e <file_fsync+0x7c>
ffffffffc0204fe0:	581c                	lw	a5,48(s0)
ffffffffc0204fe2:	7404                	ld	s1,40(s0)
ffffffffc0204fe4:	2785                	addiw	a5,a5,1
ffffffffc0204fe6:	d81c                	sw	a5,48(s0)
ffffffffc0204fe8:	c0b1                	beqz	s1,ffffffffc020502c <file_fsync+0x8a>
ffffffffc0204fea:	78bc                	ld	a5,112(s1)
ffffffffc0204fec:	c3a1                	beqz	a5,ffffffffc020502c <file_fsync+0x8a>
ffffffffc0204fee:	7b9c                	ld	a5,48(a5)
ffffffffc0204ff0:	cf95                	beqz	a5,ffffffffc020502c <file_fsync+0x8a>
ffffffffc0204ff2:	00008597          	auipc	a1,0x8
ffffffffc0204ff6:	31e58593          	addi	a1,a1,798 # ffffffffc020d310 <default_pmm_manager+0xea0>
ffffffffc0204ffa:	8526                	mv	a0,s1
ffffffffc0204ffc:	069020ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0205000:	78bc                	ld	a5,112(s1)
ffffffffc0205002:	7408                	ld	a0,40(s0)
ffffffffc0205004:	7b9c                	ld	a5,48(a5)
ffffffffc0205006:	9782                	jalr	a5
ffffffffc0205008:	87aa                	mv	a5,a0
ffffffffc020500a:	8522                	mv	a0,s0
ffffffffc020500c:	843e                	mv	s0,a5
ffffffffc020500e:	897ff0ef          	jal	ra,ffffffffc02048a4 <fd_array_release>
ffffffffc0205012:	60e2                	ld	ra,24(sp)
ffffffffc0205014:	8522                	mv	a0,s0
ffffffffc0205016:	6442                	ld	s0,16(sp)
ffffffffc0205018:	64a2                	ld	s1,8(sp)
ffffffffc020501a:	6105                	addi	sp,sp,32
ffffffffc020501c:	8082                	ret
ffffffffc020501e:	5475                	li	s0,-3
ffffffffc0205020:	60e2                	ld	ra,24(sp)
ffffffffc0205022:	8522                	mv	a0,s0
ffffffffc0205024:	6442                	ld	s0,16(sp)
ffffffffc0205026:	64a2                	ld	s1,8(sp)
ffffffffc0205028:	6105                	addi	sp,sp,32
ffffffffc020502a:	8082                	ret
ffffffffc020502c:	00008697          	auipc	a3,0x8
ffffffffc0205030:	29468693          	addi	a3,a3,660 # ffffffffc020d2c0 <default_pmm_manager+0xe50>
ffffffffc0205034:	00007617          	auipc	a2,0x7
ffffffffc0205038:	95460613          	addi	a2,a2,-1708 # ffffffffc020b988 <commands+0x210>
ffffffffc020503c:	13a00593          	li	a1,314
ffffffffc0205040:	00008517          	auipc	a0,0x8
ffffffffc0205044:	fe850513          	addi	a0,a0,-24 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc0205048:	c56fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020504c:	f26ff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>

ffffffffc0205050 <file_getdirentry>:
ffffffffc0205050:	715d                	addi	sp,sp,-80
ffffffffc0205052:	e486                	sd	ra,72(sp)
ffffffffc0205054:	e0a2                	sd	s0,64(sp)
ffffffffc0205056:	fc26                	sd	s1,56(sp)
ffffffffc0205058:	f84a                	sd	s2,48(sp)
ffffffffc020505a:	f44e                	sd	s3,40(sp)
ffffffffc020505c:	04700793          	li	a5,71
ffffffffc0205060:	0aa7e063          	bltu	a5,a0,ffffffffc0205100 <file_getdirentry+0xb0>
ffffffffc0205064:	00092797          	auipc	a5,0x92
ffffffffc0205068:	85c7b783          	ld	a5,-1956(a5) # ffffffffc02968c0 <current>
ffffffffc020506c:	1487b783          	ld	a5,328(a5)
ffffffffc0205070:	c3e9                	beqz	a5,ffffffffc0205132 <file_getdirentry+0xe2>
ffffffffc0205072:	4b98                	lw	a4,16(a5)
ffffffffc0205074:	0ae05f63          	blez	a4,ffffffffc0205132 <file_getdirentry+0xe2>
ffffffffc0205078:	6780                	ld	s0,8(a5)
ffffffffc020507a:	00351793          	slli	a5,a0,0x3
ffffffffc020507e:	8f89                	sub	a5,a5,a0
ffffffffc0205080:	078e                	slli	a5,a5,0x3
ffffffffc0205082:	943e                	add	s0,s0,a5
ffffffffc0205084:	4018                	lw	a4,0(s0)
ffffffffc0205086:	4789                	li	a5,2
ffffffffc0205088:	06f71c63          	bne	a4,a5,ffffffffc0205100 <file_getdirentry+0xb0>
ffffffffc020508c:	4c1c                	lw	a5,24(s0)
ffffffffc020508e:	06a79963          	bne	a5,a0,ffffffffc0205100 <file_getdirentry+0xb0>
ffffffffc0205092:	581c                	lw	a5,48(s0)
ffffffffc0205094:	6194                	ld	a3,0(a1)
ffffffffc0205096:	84ae                	mv	s1,a1
ffffffffc0205098:	2785                	addiw	a5,a5,1
ffffffffc020509a:	10000613          	li	a2,256
ffffffffc020509e:	d81c                	sw	a5,48(s0)
ffffffffc02050a0:	05a1                	addi	a1,a1,8
ffffffffc02050a2:	850a                	mv	a0,sp
ffffffffc02050a4:	33e000ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc02050a8:	02843983          	ld	s3,40(s0)
ffffffffc02050ac:	892a                	mv	s2,a0
ffffffffc02050ae:	06098263          	beqz	s3,ffffffffc0205112 <file_getdirentry+0xc2>
ffffffffc02050b2:	0709b783          	ld	a5,112(s3) # 1070 <_binary_bin_swap_img_size-0x6c90>
ffffffffc02050b6:	cfb1                	beqz	a5,ffffffffc0205112 <file_getdirentry+0xc2>
ffffffffc02050b8:	63bc                	ld	a5,64(a5)
ffffffffc02050ba:	cfa1                	beqz	a5,ffffffffc0205112 <file_getdirentry+0xc2>
ffffffffc02050bc:	854e                	mv	a0,s3
ffffffffc02050be:	00008597          	auipc	a1,0x8
ffffffffc02050c2:	2b258593          	addi	a1,a1,690 # ffffffffc020d370 <default_pmm_manager+0xf00>
ffffffffc02050c6:	79e020ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc02050ca:	0709b783          	ld	a5,112(s3)
ffffffffc02050ce:	7408                	ld	a0,40(s0)
ffffffffc02050d0:	85ca                	mv	a1,s2
ffffffffc02050d2:	63bc                	ld	a5,64(a5)
ffffffffc02050d4:	9782                	jalr	a5
ffffffffc02050d6:	89aa                	mv	s3,a0
ffffffffc02050d8:	e909                	bnez	a0,ffffffffc02050ea <file_getdirentry+0x9a>
ffffffffc02050da:	609c                	ld	a5,0(s1)
ffffffffc02050dc:	01093683          	ld	a3,16(s2)
ffffffffc02050e0:	01893703          	ld	a4,24(s2)
ffffffffc02050e4:	97b6                	add	a5,a5,a3
ffffffffc02050e6:	8f99                	sub	a5,a5,a4
ffffffffc02050e8:	e09c                	sd	a5,0(s1)
ffffffffc02050ea:	8522                	mv	a0,s0
ffffffffc02050ec:	fb8ff0ef          	jal	ra,ffffffffc02048a4 <fd_array_release>
ffffffffc02050f0:	60a6                	ld	ra,72(sp)
ffffffffc02050f2:	6406                	ld	s0,64(sp)
ffffffffc02050f4:	74e2                	ld	s1,56(sp)
ffffffffc02050f6:	7942                	ld	s2,48(sp)
ffffffffc02050f8:	854e                	mv	a0,s3
ffffffffc02050fa:	79a2                	ld	s3,40(sp)
ffffffffc02050fc:	6161                	addi	sp,sp,80
ffffffffc02050fe:	8082                	ret
ffffffffc0205100:	60a6                	ld	ra,72(sp)
ffffffffc0205102:	6406                	ld	s0,64(sp)
ffffffffc0205104:	59f5                	li	s3,-3
ffffffffc0205106:	74e2                	ld	s1,56(sp)
ffffffffc0205108:	7942                	ld	s2,48(sp)
ffffffffc020510a:	854e                	mv	a0,s3
ffffffffc020510c:	79a2                	ld	s3,40(sp)
ffffffffc020510e:	6161                	addi	sp,sp,80
ffffffffc0205110:	8082                	ret
ffffffffc0205112:	00008697          	auipc	a3,0x8
ffffffffc0205116:	20668693          	addi	a3,a3,518 # ffffffffc020d318 <default_pmm_manager+0xea8>
ffffffffc020511a:	00007617          	auipc	a2,0x7
ffffffffc020511e:	86e60613          	addi	a2,a2,-1938 # ffffffffc020b988 <commands+0x210>
ffffffffc0205122:	14a00593          	li	a1,330
ffffffffc0205126:	00008517          	auipc	a0,0x8
ffffffffc020512a:	f0250513          	addi	a0,a0,-254 # ffffffffc020d028 <default_pmm_manager+0xbb8>
ffffffffc020512e:	b70fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205132:	e40ff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>

ffffffffc0205136 <file_dup>:
ffffffffc0205136:	04700713          	li	a4,71
ffffffffc020513a:	06a76463          	bltu	a4,a0,ffffffffc02051a2 <file_dup+0x6c>
ffffffffc020513e:	00091717          	auipc	a4,0x91
ffffffffc0205142:	78273703          	ld	a4,1922(a4) # ffffffffc02968c0 <current>
ffffffffc0205146:	14873703          	ld	a4,328(a4)
ffffffffc020514a:	1101                	addi	sp,sp,-32
ffffffffc020514c:	ec06                	sd	ra,24(sp)
ffffffffc020514e:	e822                	sd	s0,16(sp)
ffffffffc0205150:	cb39                	beqz	a4,ffffffffc02051a6 <file_dup+0x70>
ffffffffc0205152:	4b14                	lw	a3,16(a4)
ffffffffc0205154:	04d05963          	blez	a3,ffffffffc02051a6 <file_dup+0x70>
ffffffffc0205158:	6700                	ld	s0,8(a4)
ffffffffc020515a:	00351713          	slli	a4,a0,0x3
ffffffffc020515e:	8f09                	sub	a4,a4,a0
ffffffffc0205160:	070e                	slli	a4,a4,0x3
ffffffffc0205162:	943a                	add	s0,s0,a4
ffffffffc0205164:	4014                	lw	a3,0(s0)
ffffffffc0205166:	4709                	li	a4,2
ffffffffc0205168:	02e69863          	bne	a3,a4,ffffffffc0205198 <file_dup+0x62>
ffffffffc020516c:	4c18                	lw	a4,24(s0)
ffffffffc020516e:	02a71563          	bne	a4,a0,ffffffffc0205198 <file_dup+0x62>
ffffffffc0205172:	852e                	mv	a0,a1
ffffffffc0205174:	002c                	addi	a1,sp,8
ffffffffc0205176:	e1eff0ef          	jal	ra,ffffffffc0204794 <fd_array_alloc>
ffffffffc020517a:	c509                	beqz	a0,ffffffffc0205184 <file_dup+0x4e>
ffffffffc020517c:	60e2                	ld	ra,24(sp)
ffffffffc020517e:	6442                	ld	s0,16(sp)
ffffffffc0205180:	6105                	addi	sp,sp,32
ffffffffc0205182:	8082                	ret
ffffffffc0205184:	6522                	ld	a0,8(sp)
ffffffffc0205186:	85a2                	mv	a1,s0
ffffffffc0205188:	845ff0ef          	jal	ra,ffffffffc02049cc <fd_array_dup>
ffffffffc020518c:	67a2                	ld	a5,8(sp)
ffffffffc020518e:	60e2                	ld	ra,24(sp)
ffffffffc0205190:	6442                	ld	s0,16(sp)
ffffffffc0205192:	4f88                	lw	a0,24(a5)
ffffffffc0205194:	6105                	addi	sp,sp,32
ffffffffc0205196:	8082                	ret
ffffffffc0205198:	60e2                	ld	ra,24(sp)
ffffffffc020519a:	6442                	ld	s0,16(sp)
ffffffffc020519c:	5575                	li	a0,-3
ffffffffc020519e:	6105                	addi	sp,sp,32
ffffffffc02051a0:	8082                	ret
ffffffffc02051a2:	5575                	li	a0,-3
ffffffffc02051a4:	8082                	ret
ffffffffc02051a6:	dccff0ef          	jal	ra,ffffffffc0204772 <get_fd_array.part.0>

ffffffffc02051aa <fs_init>:
ffffffffc02051aa:	1141                	addi	sp,sp,-16
ffffffffc02051ac:	e406                	sd	ra,8(sp)
ffffffffc02051ae:	0d5020ef          	jal	ra,ffffffffc0207a82 <vfs_init>
ffffffffc02051b2:	5ac030ef          	jal	ra,ffffffffc020875e <dev_init>
ffffffffc02051b6:	60a2                	ld	ra,8(sp)
ffffffffc02051b8:	0141                	addi	sp,sp,16
ffffffffc02051ba:	6fd0306f          	j	ffffffffc02090b6 <sfs_init>

ffffffffc02051be <fs_cleanup>:
ffffffffc02051be:	3170206f          	j	ffffffffc0207cd4 <vfs_cleanup>

ffffffffc02051c2 <lock_files>:
ffffffffc02051c2:	0561                	addi	a0,a0,24
ffffffffc02051c4:	ba0ff06f          	j	ffffffffc0204564 <down>

ffffffffc02051c8 <unlock_files>:
ffffffffc02051c8:	0561                	addi	a0,a0,24
ffffffffc02051ca:	b96ff06f          	j	ffffffffc0204560 <up>

ffffffffc02051ce <files_create>:
ffffffffc02051ce:	1141                	addi	sp,sp,-16
ffffffffc02051d0:	6505                	lui	a0,0x1
ffffffffc02051d2:	e022                	sd	s0,0(sp)
ffffffffc02051d4:	e406                	sd	ra,8(sp)
ffffffffc02051d6:	db9fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc02051da:	842a                	mv	s0,a0
ffffffffc02051dc:	cd19                	beqz	a0,ffffffffc02051fa <files_create+0x2c>
ffffffffc02051de:	03050793          	addi	a5,a0,48 # 1030 <_binary_bin_swap_img_size-0x6cd0>
ffffffffc02051e2:	00043023          	sd	zero,0(s0)
ffffffffc02051e6:	0561                	addi	a0,a0,24
ffffffffc02051e8:	e41c                	sd	a5,8(s0)
ffffffffc02051ea:	00042823          	sw	zero,16(s0)
ffffffffc02051ee:	4585                	li	a1,1
ffffffffc02051f0:	b6aff0ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc02051f4:	6408                	ld	a0,8(s0)
ffffffffc02051f6:	f3cff0ef          	jal	ra,ffffffffc0204932 <fd_array_init>
ffffffffc02051fa:	60a2                	ld	ra,8(sp)
ffffffffc02051fc:	8522                	mv	a0,s0
ffffffffc02051fe:	6402                	ld	s0,0(sp)
ffffffffc0205200:	0141                	addi	sp,sp,16
ffffffffc0205202:	8082                	ret

ffffffffc0205204 <files_destroy>:
ffffffffc0205204:	7179                	addi	sp,sp,-48
ffffffffc0205206:	f406                	sd	ra,40(sp)
ffffffffc0205208:	f022                	sd	s0,32(sp)
ffffffffc020520a:	ec26                	sd	s1,24(sp)
ffffffffc020520c:	e84a                	sd	s2,16(sp)
ffffffffc020520e:	e44e                	sd	s3,8(sp)
ffffffffc0205210:	c52d                	beqz	a0,ffffffffc020527a <files_destroy+0x76>
ffffffffc0205212:	491c                	lw	a5,16(a0)
ffffffffc0205214:	89aa                	mv	s3,a0
ffffffffc0205216:	e3b5                	bnez	a5,ffffffffc020527a <files_destroy+0x76>
ffffffffc0205218:	6108                	ld	a0,0(a0)
ffffffffc020521a:	c119                	beqz	a0,ffffffffc0205220 <files_destroy+0x1c>
ffffffffc020521c:	6fe020ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc0205220:	0089b403          	ld	s0,8(s3)
ffffffffc0205224:	6485                	lui	s1,0x1
ffffffffc0205226:	fc048493          	addi	s1,s1,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc020522a:	94a2                	add	s1,s1,s0
ffffffffc020522c:	4909                	li	s2,2
ffffffffc020522e:	401c                	lw	a5,0(s0)
ffffffffc0205230:	03278063          	beq	a5,s2,ffffffffc0205250 <files_destroy+0x4c>
ffffffffc0205234:	e39d                	bnez	a5,ffffffffc020525a <files_destroy+0x56>
ffffffffc0205236:	03840413          	addi	s0,s0,56
ffffffffc020523a:	fe849ae3          	bne	s1,s0,ffffffffc020522e <files_destroy+0x2a>
ffffffffc020523e:	7402                	ld	s0,32(sp)
ffffffffc0205240:	70a2                	ld	ra,40(sp)
ffffffffc0205242:	64e2                	ld	s1,24(sp)
ffffffffc0205244:	6942                	ld	s2,16(sp)
ffffffffc0205246:	854e                	mv	a0,s3
ffffffffc0205248:	69a2                	ld	s3,8(sp)
ffffffffc020524a:	6145                	addi	sp,sp,48
ffffffffc020524c:	df3fc06f          	j	ffffffffc020203e <kfree>
ffffffffc0205250:	8522                	mv	a0,s0
ffffffffc0205252:	efcff0ef          	jal	ra,ffffffffc020494e <fd_array_close>
ffffffffc0205256:	401c                	lw	a5,0(s0)
ffffffffc0205258:	bff1                	j	ffffffffc0205234 <files_destroy+0x30>
ffffffffc020525a:	00008697          	auipc	a3,0x8
ffffffffc020525e:	19668693          	addi	a3,a3,406 # ffffffffc020d3f0 <CSWTCH.79+0x58>
ffffffffc0205262:	00006617          	auipc	a2,0x6
ffffffffc0205266:	72660613          	addi	a2,a2,1830 # ffffffffc020b988 <commands+0x210>
ffffffffc020526a:	03d00593          	li	a1,61
ffffffffc020526e:	00008517          	auipc	a0,0x8
ffffffffc0205272:	17250513          	addi	a0,a0,370 # ffffffffc020d3e0 <CSWTCH.79+0x48>
ffffffffc0205276:	a28fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020527a:	00008697          	auipc	a3,0x8
ffffffffc020527e:	13668693          	addi	a3,a3,310 # ffffffffc020d3b0 <CSWTCH.79+0x18>
ffffffffc0205282:	00006617          	auipc	a2,0x6
ffffffffc0205286:	70660613          	addi	a2,a2,1798 # ffffffffc020b988 <commands+0x210>
ffffffffc020528a:	03300593          	li	a1,51
ffffffffc020528e:	00008517          	auipc	a0,0x8
ffffffffc0205292:	15250513          	addi	a0,a0,338 # ffffffffc020d3e0 <CSWTCH.79+0x48>
ffffffffc0205296:	a08fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020529a <files_closeall>:
ffffffffc020529a:	1101                	addi	sp,sp,-32
ffffffffc020529c:	ec06                	sd	ra,24(sp)
ffffffffc020529e:	e822                	sd	s0,16(sp)
ffffffffc02052a0:	e426                	sd	s1,8(sp)
ffffffffc02052a2:	e04a                	sd	s2,0(sp)
ffffffffc02052a4:	c129                	beqz	a0,ffffffffc02052e6 <files_closeall+0x4c>
ffffffffc02052a6:	491c                	lw	a5,16(a0)
ffffffffc02052a8:	02f05f63          	blez	a5,ffffffffc02052e6 <files_closeall+0x4c>
ffffffffc02052ac:	6504                	ld	s1,8(a0)
ffffffffc02052ae:	6785                	lui	a5,0x1
ffffffffc02052b0:	fc078793          	addi	a5,a5,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc02052b4:	07048413          	addi	s0,s1,112
ffffffffc02052b8:	4909                	li	s2,2
ffffffffc02052ba:	94be                	add	s1,s1,a5
ffffffffc02052bc:	a029                	j	ffffffffc02052c6 <files_closeall+0x2c>
ffffffffc02052be:	03840413          	addi	s0,s0,56
ffffffffc02052c2:	00848c63          	beq	s1,s0,ffffffffc02052da <files_closeall+0x40>
ffffffffc02052c6:	401c                	lw	a5,0(s0)
ffffffffc02052c8:	ff279be3          	bne	a5,s2,ffffffffc02052be <files_closeall+0x24>
ffffffffc02052cc:	8522                	mv	a0,s0
ffffffffc02052ce:	03840413          	addi	s0,s0,56
ffffffffc02052d2:	e7cff0ef          	jal	ra,ffffffffc020494e <fd_array_close>
ffffffffc02052d6:	fe8498e3          	bne	s1,s0,ffffffffc02052c6 <files_closeall+0x2c>
ffffffffc02052da:	60e2                	ld	ra,24(sp)
ffffffffc02052dc:	6442                	ld	s0,16(sp)
ffffffffc02052de:	64a2                	ld	s1,8(sp)
ffffffffc02052e0:	6902                	ld	s2,0(sp)
ffffffffc02052e2:	6105                	addi	sp,sp,32
ffffffffc02052e4:	8082                	ret
ffffffffc02052e6:	00008697          	auipc	a3,0x8
ffffffffc02052ea:	d1268693          	addi	a3,a3,-750 # ffffffffc020cff8 <default_pmm_manager+0xb88>
ffffffffc02052ee:	00006617          	auipc	a2,0x6
ffffffffc02052f2:	69a60613          	addi	a2,a2,1690 # ffffffffc020b988 <commands+0x210>
ffffffffc02052f6:	04500593          	li	a1,69
ffffffffc02052fa:	00008517          	auipc	a0,0x8
ffffffffc02052fe:	0e650513          	addi	a0,a0,230 # ffffffffc020d3e0 <CSWTCH.79+0x48>
ffffffffc0205302:	99cfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205306 <dup_files>:
ffffffffc0205306:	7179                	addi	sp,sp,-48
ffffffffc0205308:	f406                	sd	ra,40(sp)
ffffffffc020530a:	f022                	sd	s0,32(sp)
ffffffffc020530c:	ec26                	sd	s1,24(sp)
ffffffffc020530e:	e84a                	sd	s2,16(sp)
ffffffffc0205310:	e44e                	sd	s3,8(sp)
ffffffffc0205312:	e052                	sd	s4,0(sp)
ffffffffc0205314:	c52d                	beqz	a0,ffffffffc020537e <dup_files+0x78>
ffffffffc0205316:	842e                	mv	s0,a1
ffffffffc0205318:	c1bd                	beqz	a1,ffffffffc020537e <dup_files+0x78>
ffffffffc020531a:	491c                	lw	a5,16(a0)
ffffffffc020531c:	84aa                	mv	s1,a0
ffffffffc020531e:	e3c1                	bnez	a5,ffffffffc020539e <dup_files+0x98>
ffffffffc0205320:	499c                	lw	a5,16(a1)
ffffffffc0205322:	06f05e63          	blez	a5,ffffffffc020539e <dup_files+0x98>
ffffffffc0205326:	6188                	ld	a0,0(a1)
ffffffffc0205328:	e088                	sd	a0,0(s1)
ffffffffc020532a:	c119                	beqz	a0,ffffffffc0205330 <dup_files+0x2a>
ffffffffc020532c:	520020ef          	jal	ra,ffffffffc020784c <inode_ref_inc>
ffffffffc0205330:	6400                	ld	s0,8(s0)
ffffffffc0205332:	6905                	lui	s2,0x1
ffffffffc0205334:	fc090913          	addi	s2,s2,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0205338:	6484                	ld	s1,8(s1)
ffffffffc020533a:	9922                	add	s2,s2,s0
ffffffffc020533c:	4989                	li	s3,2
ffffffffc020533e:	4a05                	li	s4,1
ffffffffc0205340:	a039                	j	ffffffffc020534e <dup_files+0x48>
ffffffffc0205342:	03840413          	addi	s0,s0,56
ffffffffc0205346:	03848493          	addi	s1,s1,56
ffffffffc020534a:	02890163          	beq	s2,s0,ffffffffc020536c <dup_files+0x66>
ffffffffc020534e:	401c                	lw	a5,0(s0)
ffffffffc0205350:	ff3799e3          	bne	a5,s3,ffffffffc0205342 <dup_files+0x3c>
ffffffffc0205354:	0144a023          	sw	s4,0(s1)
ffffffffc0205358:	85a2                	mv	a1,s0
ffffffffc020535a:	8526                	mv	a0,s1
ffffffffc020535c:	03840413          	addi	s0,s0,56
ffffffffc0205360:	e6cff0ef          	jal	ra,ffffffffc02049cc <fd_array_dup>
ffffffffc0205364:	03848493          	addi	s1,s1,56
ffffffffc0205368:	fe8913e3          	bne	s2,s0,ffffffffc020534e <dup_files+0x48>
ffffffffc020536c:	70a2                	ld	ra,40(sp)
ffffffffc020536e:	7402                	ld	s0,32(sp)
ffffffffc0205370:	64e2                	ld	s1,24(sp)
ffffffffc0205372:	6942                	ld	s2,16(sp)
ffffffffc0205374:	69a2                	ld	s3,8(sp)
ffffffffc0205376:	6a02                	ld	s4,0(sp)
ffffffffc0205378:	4501                	li	a0,0
ffffffffc020537a:	6145                	addi	sp,sp,48
ffffffffc020537c:	8082                	ret
ffffffffc020537e:	00008697          	auipc	a3,0x8
ffffffffc0205382:	9ca68693          	addi	a3,a3,-1590 # ffffffffc020cd48 <default_pmm_manager+0x8d8>
ffffffffc0205386:	00006617          	auipc	a2,0x6
ffffffffc020538a:	60260613          	addi	a2,a2,1538 # ffffffffc020b988 <commands+0x210>
ffffffffc020538e:	05300593          	li	a1,83
ffffffffc0205392:	00008517          	auipc	a0,0x8
ffffffffc0205396:	04e50513          	addi	a0,a0,78 # ffffffffc020d3e0 <CSWTCH.79+0x48>
ffffffffc020539a:	904fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020539e:	00008697          	auipc	a3,0x8
ffffffffc02053a2:	06a68693          	addi	a3,a3,106 # ffffffffc020d408 <CSWTCH.79+0x70>
ffffffffc02053a6:	00006617          	auipc	a2,0x6
ffffffffc02053aa:	5e260613          	addi	a2,a2,1506 # ffffffffc020b988 <commands+0x210>
ffffffffc02053ae:	05400593          	li	a1,84
ffffffffc02053b2:	00008517          	auipc	a0,0x8
ffffffffc02053b6:	02e50513          	addi	a0,a0,46 # ffffffffc020d3e0 <CSWTCH.79+0x48>
ffffffffc02053ba:	8e4fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02053be <iobuf_skip.part.0>:
ffffffffc02053be:	1141                	addi	sp,sp,-16
ffffffffc02053c0:	00008697          	auipc	a3,0x8
ffffffffc02053c4:	07868693          	addi	a3,a3,120 # ffffffffc020d438 <CSWTCH.79+0xa0>
ffffffffc02053c8:	00006617          	auipc	a2,0x6
ffffffffc02053cc:	5c060613          	addi	a2,a2,1472 # ffffffffc020b988 <commands+0x210>
ffffffffc02053d0:	04a00593          	li	a1,74
ffffffffc02053d4:	00008517          	auipc	a0,0x8
ffffffffc02053d8:	07c50513          	addi	a0,a0,124 # ffffffffc020d450 <CSWTCH.79+0xb8>
ffffffffc02053dc:	e406                	sd	ra,8(sp)
ffffffffc02053de:	8c0fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02053e2 <iobuf_init>:
ffffffffc02053e2:	e10c                	sd	a1,0(a0)
ffffffffc02053e4:	e514                	sd	a3,8(a0)
ffffffffc02053e6:	ed10                	sd	a2,24(a0)
ffffffffc02053e8:	e910                	sd	a2,16(a0)
ffffffffc02053ea:	8082                	ret

ffffffffc02053ec <iobuf_move>:
ffffffffc02053ec:	7179                	addi	sp,sp,-48
ffffffffc02053ee:	ec26                	sd	s1,24(sp)
ffffffffc02053f0:	6d04                	ld	s1,24(a0)
ffffffffc02053f2:	f022                	sd	s0,32(sp)
ffffffffc02053f4:	e84a                	sd	s2,16(sp)
ffffffffc02053f6:	e44e                	sd	s3,8(sp)
ffffffffc02053f8:	f406                	sd	ra,40(sp)
ffffffffc02053fa:	842a                	mv	s0,a0
ffffffffc02053fc:	8932                	mv	s2,a2
ffffffffc02053fe:	852e                	mv	a0,a1
ffffffffc0205400:	89ba                	mv	s3,a4
ffffffffc0205402:	00967363          	bgeu	a2,s1,ffffffffc0205408 <iobuf_move+0x1c>
ffffffffc0205406:	84b2                	mv	s1,a2
ffffffffc0205408:	c495                	beqz	s1,ffffffffc0205434 <iobuf_move+0x48>
ffffffffc020540a:	600c                	ld	a1,0(s0)
ffffffffc020540c:	c681                	beqz	a3,ffffffffc0205414 <iobuf_move+0x28>
ffffffffc020540e:	87ae                	mv	a5,a1
ffffffffc0205410:	85aa                	mv	a1,a0
ffffffffc0205412:	853e                	mv	a0,a5
ffffffffc0205414:	8626                	mv	a2,s1
ffffffffc0205416:	09c060ef          	jal	ra,ffffffffc020b4b2 <memmove>
ffffffffc020541a:	6c1c                	ld	a5,24(s0)
ffffffffc020541c:	0297ea63          	bltu	a5,s1,ffffffffc0205450 <iobuf_move+0x64>
ffffffffc0205420:	6014                	ld	a3,0(s0)
ffffffffc0205422:	6418                	ld	a4,8(s0)
ffffffffc0205424:	8f85                	sub	a5,a5,s1
ffffffffc0205426:	96a6                	add	a3,a3,s1
ffffffffc0205428:	9726                	add	a4,a4,s1
ffffffffc020542a:	e014                	sd	a3,0(s0)
ffffffffc020542c:	e418                	sd	a4,8(s0)
ffffffffc020542e:	ec1c                	sd	a5,24(s0)
ffffffffc0205430:	40990933          	sub	s2,s2,s1
ffffffffc0205434:	00098463          	beqz	s3,ffffffffc020543c <iobuf_move+0x50>
ffffffffc0205438:	0099b023          	sd	s1,0(s3)
ffffffffc020543c:	4501                	li	a0,0
ffffffffc020543e:	00091b63          	bnez	s2,ffffffffc0205454 <iobuf_move+0x68>
ffffffffc0205442:	70a2                	ld	ra,40(sp)
ffffffffc0205444:	7402                	ld	s0,32(sp)
ffffffffc0205446:	64e2                	ld	s1,24(sp)
ffffffffc0205448:	6942                	ld	s2,16(sp)
ffffffffc020544a:	69a2                	ld	s3,8(sp)
ffffffffc020544c:	6145                	addi	sp,sp,48
ffffffffc020544e:	8082                	ret
ffffffffc0205450:	f6fff0ef          	jal	ra,ffffffffc02053be <iobuf_skip.part.0>
ffffffffc0205454:	5571                	li	a0,-4
ffffffffc0205456:	b7f5                	j	ffffffffc0205442 <iobuf_move+0x56>

ffffffffc0205458 <iobuf_skip>:
ffffffffc0205458:	6d1c                	ld	a5,24(a0)
ffffffffc020545a:	00b7eb63          	bltu	a5,a1,ffffffffc0205470 <iobuf_skip+0x18>
ffffffffc020545e:	6114                	ld	a3,0(a0)
ffffffffc0205460:	6518                	ld	a4,8(a0)
ffffffffc0205462:	8f8d                	sub	a5,a5,a1
ffffffffc0205464:	96ae                	add	a3,a3,a1
ffffffffc0205466:	95ba                	add	a1,a1,a4
ffffffffc0205468:	e114                	sd	a3,0(a0)
ffffffffc020546a:	e50c                	sd	a1,8(a0)
ffffffffc020546c:	ed1c                	sd	a5,24(a0)
ffffffffc020546e:	8082                	ret
ffffffffc0205470:	1141                	addi	sp,sp,-16
ffffffffc0205472:	e406                	sd	ra,8(sp)
ffffffffc0205474:	f4bff0ef          	jal	ra,ffffffffc02053be <iobuf_skip.part.0>

ffffffffc0205478 <copy_path>:
ffffffffc0205478:	7139                	addi	sp,sp,-64
ffffffffc020547a:	f04a                	sd	s2,32(sp)
ffffffffc020547c:	00091917          	auipc	s2,0x91
ffffffffc0205480:	44490913          	addi	s2,s2,1092 # ffffffffc02968c0 <current>
ffffffffc0205484:	00093703          	ld	a4,0(s2)
ffffffffc0205488:	ec4e                	sd	s3,24(sp)
ffffffffc020548a:	89aa                	mv	s3,a0
ffffffffc020548c:	6505                	lui	a0,0x1
ffffffffc020548e:	f426                	sd	s1,40(sp)
ffffffffc0205490:	e852                	sd	s4,16(sp)
ffffffffc0205492:	fc06                	sd	ra,56(sp)
ffffffffc0205494:	f822                	sd	s0,48(sp)
ffffffffc0205496:	e456                	sd	s5,8(sp)
ffffffffc0205498:	02873a03          	ld	s4,40(a4)
ffffffffc020549c:	84ae                	mv	s1,a1
ffffffffc020549e:	af1fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc02054a2:	c141                	beqz	a0,ffffffffc0205522 <copy_path+0xaa>
ffffffffc02054a4:	842a                	mv	s0,a0
ffffffffc02054a6:	040a0563          	beqz	s4,ffffffffc02054f0 <copy_path+0x78>
ffffffffc02054aa:	038a0a93          	addi	s5,s4,56
ffffffffc02054ae:	8556                	mv	a0,s5
ffffffffc02054b0:	8b4ff0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc02054b4:	00093783          	ld	a5,0(s2)
ffffffffc02054b8:	cba1                	beqz	a5,ffffffffc0205508 <copy_path+0x90>
ffffffffc02054ba:	43dc                	lw	a5,4(a5)
ffffffffc02054bc:	6685                	lui	a3,0x1
ffffffffc02054be:	8626                	mv	a2,s1
ffffffffc02054c0:	04fa2823          	sw	a5,80(s4)
ffffffffc02054c4:	85a2                	mv	a1,s0
ffffffffc02054c6:	8552                	mv	a0,s4
ffffffffc02054c8:	ec5fe0ef          	jal	ra,ffffffffc020438c <copy_string>
ffffffffc02054cc:	c529                	beqz	a0,ffffffffc0205516 <copy_path+0x9e>
ffffffffc02054ce:	8556                	mv	a0,s5
ffffffffc02054d0:	890ff0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc02054d4:	040a2823          	sw	zero,80(s4)
ffffffffc02054d8:	0089b023          	sd	s0,0(s3)
ffffffffc02054dc:	4501                	li	a0,0
ffffffffc02054de:	70e2                	ld	ra,56(sp)
ffffffffc02054e0:	7442                	ld	s0,48(sp)
ffffffffc02054e2:	74a2                	ld	s1,40(sp)
ffffffffc02054e4:	7902                	ld	s2,32(sp)
ffffffffc02054e6:	69e2                	ld	s3,24(sp)
ffffffffc02054e8:	6a42                	ld	s4,16(sp)
ffffffffc02054ea:	6aa2                	ld	s5,8(sp)
ffffffffc02054ec:	6121                	addi	sp,sp,64
ffffffffc02054ee:	8082                	ret
ffffffffc02054f0:	85aa                	mv	a1,a0
ffffffffc02054f2:	6685                	lui	a3,0x1
ffffffffc02054f4:	8626                	mv	a2,s1
ffffffffc02054f6:	4501                	li	a0,0
ffffffffc02054f8:	e95fe0ef          	jal	ra,ffffffffc020438c <copy_string>
ffffffffc02054fc:	fd71                	bnez	a0,ffffffffc02054d8 <copy_path+0x60>
ffffffffc02054fe:	8522                	mv	a0,s0
ffffffffc0205500:	b3ffc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0205504:	5575                	li	a0,-3
ffffffffc0205506:	bfe1                	j	ffffffffc02054de <copy_path+0x66>
ffffffffc0205508:	6685                	lui	a3,0x1
ffffffffc020550a:	8626                	mv	a2,s1
ffffffffc020550c:	85a2                	mv	a1,s0
ffffffffc020550e:	8552                	mv	a0,s4
ffffffffc0205510:	e7dfe0ef          	jal	ra,ffffffffc020438c <copy_string>
ffffffffc0205514:	fd4d                	bnez	a0,ffffffffc02054ce <copy_path+0x56>
ffffffffc0205516:	8556                	mv	a0,s5
ffffffffc0205518:	848ff0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020551c:	040a2823          	sw	zero,80(s4)
ffffffffc0205520:	bff9                	j	ffffffffc02054fe <copy_path+0x86>
ffffffffc0205522:	5571                	li	a0,-4
ffffffffc0205524:	bf6d                	j	ffffffffc02054de <copy_path+0x66>

ffffffffc0205526 <sysfile_open>:
ffffffffc0205526:	7179                	addi	sp,sp,-48
ffffffffc0205528:	872a                	mv	a4,a0
ffffffffc020552a:	ec26                	sd	s1,24(sp)
ffffffffc020552c:	0028                	addi	a0,sp,8
ffffffffc020552e:	84ae                	mv	s1,a1
ffffffffc0205530:	85ba                	mv	a1,a4
ffffffffc0205532:	f022                	sd	s0,32(sp)
ffffffffc0205534:	f406                	sd	ra,40(sp)
ffffffffc0205536:	f43ff0ef          	jal	ra,ffffffffc0205478 <copy_path>
ffffffffc020553a:	842a                	mv	s0,a0
ffffffffc020553c:	e909                	bnez	a0,ffffffffc020554e <sysfile_open+0x28>
ffffffffc020553e:	6522                	ld	a0,8(sp)
ffffffffc0205540:	85a6                	mv	a1,s1
ffffffffc0205542:	d60ff0ef          	jal	ra,ffffffffc0204aa2 <file_open>
ffffffffc0205546:	842a                	mv	s0,a0
ffffffffc0205548:	6522                	ld	a0,8(sp)
ffffffffc020554a:	af5fc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020554e:	70a2                	ld	ra,40(sp)
ffffffffc0205550:	8522                	mv	a0,s0
ffffffffc0205552:	7402                	ld	s0,32(sp)
ffffffffc0205554:	64e2                	ld	s1,24(sp)
ffffffffc0205556:	6145                	addi	sp,sp,48
ffffffffc0205558:	8082                	ret

ffffffffc020555a <sysfile_close>:
ffffffffc020555a:	e46ff06f          	j	ffffffffc0204ba0 <file_close>

ffffffffc020555e <sysfile_read>:
ffffffffc020555e:	7159                	addi	sp,sp,-112
ffffffffc0205560:	f0a2                	sd	s0,96(sp)
ffffffffc0205562:	f486                	sd	ra,104(sp)
ffffffffc0205564:	eca6                	sd	s1,88(sp)
ffffffffc0205566:	e8ca                	sd	s2,80(sp)
ffffffffc0205568:	e4ce                	sd	s3,72(sp)
ffffffffc020556a:	e0d2                	sd	s4,64(sp)
ffffffffc020556c:	fc56                	sd	s5,56(sp)
ffffffffc020556e:	f85a                	sd	s6,48(sp)
ffffffffc0205570:	f45e                	sd	s7,40(sp)
ffffffffc0205572:	f062                	sd	s8,32(sp)
ffffffffc0205574:	ec66                	sd	s9,24(sp)
ffffffffc0205576:	4401                	li	s0,0
ffffffffc0205578:	ee19                	bnez	a2,ffffffffc0205596 <sysfile_read+0x38>
ffffffffc020557a:	70a6                	ld	ra,104(sp)
ffffffffc020557c:	8522                	mv	a0,s0
ffffffffc020557e:	7406                	ld	s0,96(sp)
ffffffffc0205580:	64e6                	ld	s1,88(sp)
ffffffffc0205582:	6946                	ld	s2,80(sp)
ffffffffc0205584:	69a6                	ld	s3,72(sp)
ffffffffc0205586:	6a06                	ld	s4,64(sp)
ffffffffc0205588:	7ae2                	ld	s5,56(sp)
ffffffffc020558a:	7b42                	ld	s6,48(sp)
ffffffffc020558c:	7ba2                	ld	s7,40(sp)
ffffffffc020558e:	7c02                	ld	s8,32(sp)
ffffffffc0205590:	6ce2                	ld	s9,24(sp)
ffffffffc0205592:	6165                	addi	sp,sp,112
ffffffffc0205594:	8082                	ret
ffffffffc0205596:	00091c97          	auipc	s9,0x91
ffffffffc020559a:	32ac8c93          	addi	s9,s9,810 # ffffffffc02968c0 <current>
ffffffffc020559e:	000cb783          	ld	a5,0(s9)
ffffffffc02055a2:	84b2                	mv	s1,a2
ffffffffc02055a4:	8b2e                	mv	s6,a1
ffffffffc02055a6:	4601                	li	a2,0
ffffffffc02055a8:	4585                	li	a1,1
ffffffffc02055aa:	0287b903          	ld	s2,40(a5)
ffffffffc02055ae:	8aaa                	mv	s5,a0
ffffffffc02055b0:	c9eff0ef          	jal	ra,ffffffffc0204a4e <file_testfd>
ffffffffc02055b4:	c959                	beqz	a0,ffffffffc020564a <sysfile_read+0xec>
ffffffffc02055b6:	6505                	lui	a0,0x1
ffffffffc02055b8:	9d7fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc02055bc:	89aa                	mv	s3,a0
ffffffffc02055be:	c941                	beqz	a0,ffffffffc020564e <sysfile_read+0xf0>
ffffffffc02055c0:	4b81                	li	s7,0
ffffffffc02055c2:	6a05                	lui	s4,0x1
ffffffffc02055c4:	03890c13          	addi	s8,s2,56
ffffffffc02055c8:	0744ec63          	bltu	s1,s4,ffffffffc0205640 <sysfile_read+0xe2>
ffffffffc02055cc:	e452                	sd	s4,8(sp)
ffffffffc02055ce:	6605                	lui	a2,0x1
ffffffffc02055d0:	0034                	addi	a3,sp,8
ffffffffc02055d2:	85ce                	mv	a1,s3
ffffffffc02055d4:	8556                	mv	a0,s5
ffffffffc02055d6:	e20ff0ef          	jal	ra,ffffffffc0204bf6 <file_read>
ffffffffc02055da:	66a2                	ld	a3,8(sp)
ffffffffc02055dc:	842a                	mv	s0,a0
ffffffffc02055de:	ca9d                	beqz	a3,ffffffffc0205614 <sysfile_read+0xb6>
ffffffffc02055e0:	00090c63          	beqz	s2,ffffffffc02055f8 <sysfile_read+0x9a>
ffffffffc02055e4:	8562                	mv	a0,s8
ffffffffc02055e6:	f7ffe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc02055ea:	000cb783          	ld	a5,0(s9)
ffffffffc02055ee:	cfa1                	beqz	a5,ffffffffc0205646 <sysfile_read+0xe8>
ffffffffc02055f0:	43dc                	lw	a5,4(a5)
ffffffffc02055f2:	66a2                	ld	a3,8(sp)
ffffffffc02055f4:	04f92823          	sw	a5,80(s2)
ffffffffc02055f8:	864e                	mv	a2,s3
ffffffffc02055fa:	85da                	mv	a1,s6
ffffffffc02055fc:	854a                	mv	a0,s2
ffffffffc02055fe:	d5dfe0ef          	jal	ra,ffffffffc020435a <copy_to_user>
ffffffffc0205602:	c50d                	beqz	a0,ffffffffc020562c <sysfile_read+0xce>
ffffffffc0205604:	67a2                	ld	a5,8(sp)
ffffffffc0205606:	04f4e663          	bltu	s1,a5,ffffffffc0205652 <sysfile_read+0xf4>
ffffffffc020560a:	9b3e                	add	s6,s6,a5
ffffffffc020560c:	8c9d                	sub	s1,s1,a5
ffffffffc020560e:	9bbe                	add	s7,s7,a5
ffffffffc0205610:	02091263          	bnez	s2,ffffffffc0205634 <sysfile_read+0xd6>
ffffffffc0205614:	e401                	bnez	s0,ffffffffc020561c <sysfile_read+0xbe>
ffffffffc0205616:	67a2                	ld	a5,8(sp)
ffffffffc0205618:	c391                	beqz	a5,ffffffffc020561c <sysfile_read+0xbe>
ffffffffc020561a:	f4dd                	bnez	s1,ffffffffc02055c8 <sysfile_read+0x6a>
ffffffffc020561c:	854e                	mv	a0,s3
ffffffffc020561e:	a21fc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0205622:	f40b8ce3          	beqz	s7,ffffffffc020557a <sysfile_read+0x1c>
ffffffffc0205626:	000b841b          	sext.w	s0,s7
ffffffffc020562a:	bf81                	j	ffffffffc020557a <sysfile_read+0x1c>
ffffffffc020562c:	e011                	bnez	s0,ffffffffc0205630 <sysfile_read+0xd2>
ffffffffc020562e:	5475                	li	s0,-3
ffffffffc0205630:	fe0906e3          	beqz	s2,ffffffffc020561c <sysfile_read+0xbe>
ffffffffc0205634:	8562                	mv	a0,s8
ffffffffc0205636:	f2bfe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020563a:	04092823          	sw	zero,80(s2)
ffffffffc020563e:	bfd9                	j	ffffffffc0205614 <sysfile_read+0xb6>
ffffffffc0205640:	e426                	sd	s1,8(sp)
ffffffffc0205642:	8626                	mv	a2,s1
ffffffffc0205644:	b771                	j	ffffffffc02055d0 <sysfile_read+0x72>
ffffffffc0205646:	66a2                	ld	a3,8(sp)
ffffffffc0205648:	bf45                	j	ffffffffc02055f8 <sysfile_read+0x9a>
ffffffffc020564a:	5475                	li	s0,-3
ffffffffc020564c:	b73d                	j	ffffffffc020557a <sysfile_read+0x1c>
ffffffffc020564e:	5471                	li	s0,-4
ffffffffc0205650:	b72d                	j	ffffffffc020557a <sysfile_read+0x1c>
ffffffffc0205652:	00008697          	auipc	a3,0x8
ffffffffc0205656:	e0e68693          	addi	a3,a3,-498 # ffffffffc020d460 <CSWTCH.79+0xc8>
ffffffffc020565a:	00006617          	auipc	a2,0x6
ffffffffc020565e:	32e60613          	addi	a2,a2,814 # ffffffffc020b988 <commands+0x210>
ffffffffc0205662:	05500593          	li	a1,85
ffffffffc0205666:	00008517          	auipc	a0,0x8
ffffffffc020566a:	e0a50513          	addi	a0,a0,-502 # ffffffffc020d470 <CSWTCH.79+0xd8>
ffffffffc020566e:	e31fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205672 <sysfile_write>:
ffffffffc0205672:	7159                	addi	sp,sp,-112
ffffffffc0205674:	e8ca                	sd	s2,80(sp)
ffffffffc0205676:	f486                	sd	ra,104(sp)
ffffffffc0205678:	f0a2                	sd	s0,96(sp)
ffffffffc020567a:	eca6                	sd	s1,88(sp)
ffffffffc020567c:	e4ce                	sd	s3,72(sp)
ffffffffc020567e:	e0d2                	sd	s4,64(sp)
ffffffffc0205680:	fc56                	sd	s5,56(sp)
ffffffffc0205682:	f85a                	sd	s6,48(sp)
ffffffffc0205684:	f45e                	sd	s7,40(sp)
ffffffffc0205686:	f062                	sd	s8,32(sp)
ffffffffc0205688:	ec66                	sd	s9,24(sp)
ffffffffc020568a:	4901                	li	s2,0
ffffffffc020568c:	ee19                	bnez	a2,ffffffffc02056aa <sysfile_write+0x38>
ffffffffc020568e:	70a6                	ld	ra,104(sp)
ffffffffc0205690:	7406                	ld	s0,96(sp)
ffffffffc0205692:	64e6                	ld	s1,88(sp)
ffffffffc0205694:	69a6                	ld	s3,72(sp)
ffffffffc0205696:	6a06                	ld	s4,64(sp)
ffffffffc0205698:	7ae2                	ld	s5,56(sp)
ffffffffc020569a:	7b42                	ld	s6,48(sp)
ffffffffc020569c:	7ba2                	ld	s7,40(sp)
ffffffffc020569e:	7c02                	ld	s8,32(sp)
ffffffffc02056a0:	6ce2                	ld	s9,24(sp)
ffffffffc02056a2:	854a                	mv	a0,s2
ffffffffc02056a4:	6946                	ld	s2,80(sp)
ffffffffc02056a6:	6165                	addi	sp,sp,112
ffffffffc02056a8:	8082                	ret
ffffffffc02056aa:	00091c17          	auipc	s8,0x91
ffffffffc02056ae:	216c0c13          	addi	s8,s8,534 # ffffffffc02968c0 <current>
ffffffffc02056b2:	000c3783          	ld	a5,0(s8)
ffffffffc02056b6:	8432                	mv	s0,a2
ffffffffc02056b8:	89ae                	mv	s3,a1
ffffffffc02056ba:	4605                	li	a2,1
ffffffffc02056bc:	4581                	li	a1,0
ffffffffc02056be:	7784                	ld	s1,40(a5)
ffffffffc02056c0:	8baa                	mv	s7,a0
ffffffffc02056c2:	b8cff0ef          	jal	ra,ffffffffc0204a4e <file_testfd>
ffffffffc02056c6:	cd59                	beqz	a0,ffffffffc0205764 <sysfile_write+0xf2>
ffffffffc02056c8:	6505                	lui	a0,0x1
ffffffffc02056ca:	8c5fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc02056ce:	8a2a                	mv	s4,a0
ffffffffc02056d0:	cd41                	beqz	a0,ffffffffc0205768 <sysfile_write+0xf6>
ffffffffc02056d2:	4c81                	li	s9,0
ffffffffc02056d4:	6a85                	lui	s5,0x1
ffffffffc02056d6:	03848b13          	addi	s6,s1,56
ffffffffc02056da:	05546a63          	bltu	s0,s5,ffffffffc020572e <sysfile_write+0xbc>
ffffffffc02056de:	e456                	sd	s5,8(sp)
ffffffffc02056e0:	c8a9                	beqz	s1,ffffffffc0205732 <sysfile_write+0xc0>
ffffffffc02056e2:	855a                	mv	a0,s6
ffffffffc02056e4:	e81fe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc02056e8:	000c3783          	ld	a5,0(s8)
ffffffffc02056ec:	c399                	beqz	a5,ffffffffc02056f2 <sysfile_write+0x80>
ffffffffc02056ee:	43dc                	lw	a5,4(a5)
ffffffffc02056f0:	c8bc                	sw	a5,80(s1)
ffffffffc02056f2:	66a2                	ld	a3,8(sp)
ffffffffc02056f4:	4701                	li	a4,0
ffffffffc02056f6:	864e                	mv	a2,s3
ffffffffc02056f8:	85d2                	mv	a1,s4
ffffffffc02056fa:	8526                	mv	a0,s1
ffffffffc02056fc:	c2bfe0ef          	jal	ra,ffffffffc0204326 <copy_from_user>
ffffffffc0205700:	c139                	beqz	a0,ffffffffc0205746 <sysfile_write+0xd4>
ffffffffc0205702:	855a                	mv	a0,s6
ffffffffc0205704:	e5dfe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0205708:	0404a823          	sw	zero,80(s1)
ffffffffc020570c:	6622                	ld	a2,8(sp)
ffffffffc020570e:	0034                	addi	a3,sp,8
ffffffffc0205710:	85d2                	mv	a1,s4
ffffffffc0205712:	855e                	mv	a0,s7
ffffffffc0205714:	dc8ff0ef          	jal	ra,ffffffffc0204cdc <file_write>
ffffffffc0205718:	67a2                	ld	a5,8(sp)
ffffffffc020571a:	892a                	mv	s2,a0
ffffffffc020571c:	ef85                	bnez	a5,ffffffffc0205754 <sysfile_write+0xe2>
ffffffffc020571e:	8552                	mv	a0,s4
ffffffffc0205720:	91ffc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0205724:	f60c85e3          	beqz	s9,ffffffffc020568e <sysfile_write+0x1c>
ffffffffc0205728:	000c891b          	sext.w	s2,s9
ffffffffc020572c:	b78d                	j	ffffffffc020568e <sysfile_write+0x1c>
ffffffffc020572e:	e422                	sd	s0,8(sp)
ffffffffc0205730:	f8cd                	bnez	s1,ffffffffc02056e2 <sysfile_write+0x70>
ffffffffc0205732:	66a2                	ld	a3,8(sp)
ffffffffc0205734:	4701                	li	a4,0
ffffffffc0205736:	864e                	mv	a2,s3
ffffffffc0205738:	85d2                	mv	a1,s4
ffffffffc020573a:	4501                	li	a0,0
ffffffffc020573c:	bebfe0ef          	jal	ra,ffffffffc0204326 <copy_from_user>
ffffffffc0205740:	f571                	bnez	a0,ffffffffc020570c <sysfile_write+0x9a>
ffffffffc0205742:	5975                	li	s2,-3
ffffffffc0205744:	bfe9                	j	ffffffffc020571e <sysfile_write+0xac>
ffffffffc0205746:	855a                	mv	a0,s6
ffffffffc0205748:	e19fe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020574c:	5975                	li	s2,-3
ffffffffc020574e:	0404a823          	sw	zero,80(s1)
ffffffffc0205752:	b7f1                	j	ffffffffc020571e <sysfile_write+0xac>
ffffffffc0205754:	00f46c63          	bltu	s0,a5,ffffffffc020576c <sysfile_write+0xfa>
ffffffffc0205758:	99be                	add	s3,s3,a5
ffffffffc020575a:	8c1d                	sub	s0,s0,a5
ffffffffc020575c:	9cbe                	add	s9,s9,a5
ffffffffc020575e:	f161                	bnez	a0,ffffffffc020571e <sysfile_write+0xac>
ffffffffc0205760:	fc2d                	bnez	s0,ffffffffc02056da <sysfile_write+0x68>
ffffffffc0205762:	bf75                	j	ffffffffc020571e <sysfile_write+0xac>
ffffffffc0205764:	5975                	li	s2,-3
ffffffffc0205766:	b725                	j	ffffffffc020568e <sysfile_write+0x1c>
ffffffffc0205768:	5971                	li	s2,-4
ffffffffc020576a:	b715                	j	ffffffffc020568e <sysfile_write+0x1c>
ffffffffc020576c:	00008697          	auipc	a3,0x8
ffffffffc0205770:	cf468693          	addi	a3,a3,-780 # ffffffffc020d460 <CSWTCH.79+0xc8>
ffffffffc0205774:	00006617          	auipc	a2,0x6
ffffffffc0205778:	21460613          	addi	a2,a2,532 # ffffffffc020b988 <commands+0x210>
ffffffffc020577c:	08a00593          	li	a1,138
ffffffffc0205780:	00008517          	auipc	a0,0x8
ffffffffc0205784:	cf050513          	addi	a0,a0,-784 # ffffffffc020d470 <CSWTCH.79+0xd8>
ffffffffc0205788:	d17fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020578c <sysfile_seek>:
ffffffffc020578c:	e36ff06f          	j	ffffffffc0204dc2 <file_seek>

ffffffffc0205790 <sysfile_fstat>:
ffffffffc0205790:	715d                	addi	sp,sp,-80
ffffffffc0205792:	f44e                	sd	s3,40(sp)
ffffffffc0205794:	00091997          	auipc	s3,0x91
ffffffffc0205798:	12c98993          	addi	s3,s3,300 # ffffffffc02968c0 <current>
ffffffffc020579c:	0009b703          	ld	a4,0(s3)
ffffffffc02057a0:	fc26                	sd	s1,56(sp)
ffffffffc02057a2:	84ae                	mv	s1,a1
ffffffffc02057a4:	858a                	mv	a1,sp
ffffffffc02057a6:	e0a2                	sd	s0,64(sp)
ffffffffc02057a8:	f84a                	sd	s2,48(sp)
ffffffffc02057aa:	e486                	sd	ra,72(sp)
ffffffffc02057ac:	02873903          	ld	s2,40(a4)
ffffffffc02057b0:	f052                	sd	s4,32(sp)
ffffffffc02057b2:	f30ff0ef          	jal	ra,ffffffffc0204ee2 <file_fstat>
ffffffffc02057b6:	842a                	mv	s0,a0
ffffffffc02057b8:	e91d                	bnez	a0,ffffffffc02057ee <sysfile_fstat+0x5e>
ffffffffc02057ba:	04090363          	beqz	s2,ffffffffc0205800 <sysfile_fstat+0x70>
ffffffffc02057be:	03890a13          	addi	s4,s2,56
ffffffffc02057c2:	8552                	mv	a0,s4
ffffffffc02057c4:	da1fe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc02057c8:	0009b783          	ld	a5,0(s3)
ffffffffc02057cc:	c3b9                	beqz	a5,ffffffffc0205812 <sysfile_fstat+0x82>
ffffffffc02057ce:	43dc                	lw	a5,4(a5)
ffffffffc02057d0:	02000693          	li	a3,32
ffffffffc02057d4:	860a                	mv	a2,sp
ffffffffc02057d6:	04f92823          	sw	a5,80(s2)
ffffffffc02057da:	85a6                	mv	a1,s1
ffffffffc02057dc:	854a                	mv	a0,s2
ffffffffc02057de:	b7dfe0ef          	jal	ra,ffffffffc020435a <copy_to_user>
ffffffffc02057e2:	c121                	beqz	a0,ffffffffc0205822 <sysfile_fstat+0x92>
ffffffffc02057e4:	8552                	mv	a0,s4
ffffffffc02057e6:	d7bfe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc02057ea:	04092823          	sw	zero,80(s2)
ffffffffc02057ee:	60a6                	ld	ra,72(sp)
ffffffffc02057f0:	8522                	mv	a0,s0
ffffffffc02057f2:	6406                	ld	s0,64(sp)
ffffffffc02057f4:	74e2                	ld	s1,56(sp)
ffffffffc02057f6:	7942                	ld	s2,48(sp)
ffffffffc02057f8:	79a2                	ld	s3,40(sp)
ffffffffc02057fa:	7a02                	ld	s4,32(sp)
ffffffffc02057fc:	6161                	addi	sp,sp,80
ffffffffc02057fe:	8082                	ret
ffffffffc0205800:	02000693          	li	a3,32
ffffffffc0205804:	860a                	mv	a2,sp
ffffffffc0205806:	85a6                	mv	a1,s1
ffffffffc0205808:	b53fe0ef          	jal	ra,ffffffffc020435a <copy_to_user>
ffffffffc020580c:	f16d                	bnez	a0,ffffffffc02057ee <sysfile_fstat+0x5e>
ffffffffc020580e:	5475                	li	s0,-3
ffffffffc0205810:	bff9                	j	ffffffffc02057ee <sysfile_fstat+0x5e>
ffffffffc0205812:	02000693          	li	a3,32
ffffffffc0205816:	860a                	mv	a2,sp
ffffffffc0205818:	85a6                	mv	a1,s1
ffffffffc020581a:	854a                	mv	a0,s2
ffffffffc020581c:	b3ffe0ef          	jal	ra,ffffffffc020435a <copy_to_user>
ffffffffc0205820:	f171                	bnez	a0,ffffffffc02057e4 <sysfile_fstat+0x54>
ffffffffc0205822:	8552                	mv	a0,s4
ffffffffc0205824:	d3dfe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0205828:	5475                	li	s0,-3
ffffffffc020582a:	04092823          	sw	zero,80(s2)
ffffffffc020582e:	b7c1                	j	ffffffffc02057ee <sysfile_fstat+0x5e>

ffffffffc0205830 <sysfile_fsync>:
ffffffffc0205830:	f72ff06f          	j	ffffffffc0204fa2 <file_fsync>

ffffffffc0205834 <sysfile_getcwd>:
ffffffffc0205834:	715d                	addi	sp,sp,-80
ffffffffc0205836:	f44e                	sd	s3,40(sp)
ffffffffc0205838:	00091997          	auipc	s3,0x91
ffffffffc020583c:	08898993          	addi	s3,s3,136 # ffffffffc02968c0 <current>
ffffffffc0205840:	0009b783          	ld	a5,0(s3)
ffffffffc0205844:	f84a                	sd	s2,48(sp)
ffffffffc0205846:	e486                	sd	ra,72(sp)
ffffffffc0205848:	e0a2                	sd	s0,64(sp)
ffffffffc020584a:	fc26                	sd	s1,56(sp)
ffffffffc020584c:	f052                	sd	s4,32(sp)
ffffffffc020584e:	0287b903          	ld	s2,40(a5)
ffffffffc0205852:	cda9                	beqz	a1,ffffffffc02058ac <sysfile_getcwd+0x78>
ffffffffc0205854:	842e                	mv	s0,a1
ffffffffc0205856:	84aa                	mv	s1,a0
ffffffffc0205858:	04090363          	beqz	s2,ffffffffc020589e <sysfile_getcwd+0x6a>
ffffffffc020585c:	03890a13          	addi	s4,s2,56
ffffffffc0205860:	8552                	mv	a0,s4
ffffffffc0205862:	d03fe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0205866:	0009b783          	ld	a5,0(s3)
ffffffffc020586a:	c781                	beqz	a5,ffffffffc0205872 <sysfile_getcwd+0x3e>
ffffffffc020586c:	43dc                	lw	a5,4(a5)
ffffffffc020586e:	04f92823          	sw	a5,80(s2)
ffffffffc0205872:	4685                	li	a3,1
ffffffffc0205874:	8622                	mv	a2,s0
ffffffffc0205876:	85a6                	mv	a1,s1
ffffffffc0205878:	854a                	mv	a0,s2
ffffffffc020587a:	a19fe0ef          	jal	ra,ffffffffc0204292 <user_mem_check>
ffffffffc020587e:	e90d                	bnez	a0,ffffffffc02058b0 <sysfile_getcwd+0x7c>
ffffffffc0205880:	5475                	li	s0,-3
ffffffffc0205882:	8552                	mv	a0,s4
ffffffffc0205884:	cddfe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0205888:	04092823          	sw	zero,80(s2)
ffffffffc020588c:	60a6                	ld	ra,72(sp)
ffffffffc020588e:	8522                	mv	a0,s0
ffffffffc0205890:	6406                	ld	s0,64(sp)
ffffffffc0205892:	74e2                	ld	s1,56(sp)
ffffffffc0205894:	7942                	ld	s2,48(sp)
ffffffffc0205896:	79a2                	ld	s3,40(sp)
ffffffffc0205898:	7a02                	ld	s4,32(sp)
ffffffffc020589a:	6161                	addi	sp,sp,80
ffffffffc020589c:	8082                	ret
ffffffffc020589e:	862e                	mv	a2,a1
ffffffffc02058a0:	4685                	li	a3,1
ffffffffc02058a2:	85aa                	mv	a1,a0
ffffffffc02058a4:	4501                	li	a0,0
ffffffffc02058a6:	9edfe0ef          	jal	ra,ffffffffc0204292 <user_mem_check>
ffffffffc02058aa:	ed09                	bnez	a0,ffffffffc02058c4 <sysfile_getcwd+0x90>
ffffffffc02058ac:	5475                	li	s0,-3
ffffffffc02058ae:	bff9                	j	ffffffffc020588c <sysfile_getcwd+0x58>
ffffffffc02058b0:	8622                	mv	a2,s0
ffffffffc02058b2:	4681                	li	a3,0
ffffffffc02058b4:	85a6                	mv	a1,s1
ffffffffc02058b6:	850a                	mv	a0,sp
ffffffffc02058b8:	b2bff0ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc02058bc:	34f020ef          	jal	ra,ffffffffc020840a <vfs_getcwd>
ffffffffc02058c0:	842a                	mv	s0,a0
ffffffffc02058c2:	b7c1                	j	ffffffffc0205882 <sysfile_getcwd+0x4e>
ffffffffc02058c4:	8622                	mv	a2,s0
ffffffffc02058c6:	4681                	li	a3,0
ffffffffc02058c8:	85a6                	mv	a1,s1
ffffffffc02058ca:	850a                	mv	a0,sp
ffffffffc02058cc:	b17ff0ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc02058d0:	33b020ef          	jal	ra,ffffffffc020840a <vfs_getcwd>
ffffffffc02058d4:	842a                	mv	s0,a0
ffffffffc02058d6:	bf5d                	j	ffffffffc020588c <sysfile_getcwd+0x58>

ffffffffc02058d8 <sysfile_getdirentry>:
ffffffffc02058d8:	7139                	addi	sp,sp,-64
ffffffffc02058da:	e852                	sd	s4,16(sp)
ffffffffc02058dc:	00091a17          	auipc	s4,0x91
ffffffffc02058e0:	fe4a0a13          	addi	s4,s4,-28 # ffffffffc02968c0 <current>
ffffffffc02058e4:	000a3703          	ld	a4,0(s4)
ffffffffc02058e8:	ec4e                	sd	s3,24(sp)
ffffffffc02058ea:	89aa                	mv	s3,a0
ffffffffc02058ec:	10800513          	li	a0,264
ffffffffc02058f0:	f426                	sd	s1,40(sp)
ffffffffc02058f2:	f04a                	sd	s2,32(sp)
ffffffffc02058f4:	fc06                	sd	ra,56(sp)
ffffffffc02058f6:	f822                	sd	s0,48(sp)
ffffffffc02058f8:	e456                	sd	s5,8(sp)
ffffffffc02058fa:	7704                	ld	s1,40(a4)
ffffffffc02058fc:	892e                	mv	s2,a1
ffffffffc02058fe:	e90fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0205902:	c169                	beqz	a0,ffffffffc02059c4 <sysfile_getdirentry+0xec>
ffffffffc0205904:	842a                	mv	s0,a0
ffffffffc0205906:	c8c1                	beqz	s1,ffffffffc0205996 <sysfile_getdirentry+0xbe>
ffffffffc0205908:	03848a93          	addi	s5,s1,56
ffffffffc020590c:	8556                	mv	a0,s5
ffffffffc020590e:	c57fe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0205912:	000a3783          	ld	a5,0(s4)
ffffffffc0205916:	c399                	beqz	a5,ffffffffc020591c <sysfile_getdirentry+0x44>
ffffffffc0205918:	43dc                	lw	a5,4(a5)
ffffffffc020591a:	c8bc                	sw	a5,80(s1)
ffffffffc020591c:	4705                	li	a4,1
ffffffffc020591e:	46a1                	li	a3,8
ffffffffc0205920:	864a                	mv	a2,s2
ffffffffc0205922:	85a2                	mv	a1,s0
ffffffffc0205924:	8526                	mv	a0,s1
ffffffffc0205926:	a01fe0ef          	jal	ra,ffffffffc0204326 <copy_from_user>
ffffffffc020592a:	e505                	bnez	a0,ffffffffc0205952 <sysfile_getdirentry+0x7a>
ffffffffc020592c:	8556                	mv	a0,s5
ffffffffc020592e:	c33fe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0205932:	59f5                	li	s3,-3
ffffffffc0205934:	0404a823          	sw	zero,80(s1)
ffffffffc0205938:	8522                	mv	a0,s0
ffffffffc020593a:	f04fc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020593e:	70e2                	ld	ra,56(sp)
ffffffffc0205940:	7442                	ld	s0,48(sp)
ffffffffc0205942:	74a2                	ld	s1,40(sp)
ffffffffc0205944:	7902                	ld	s2,32(sp)
ffffffffc0205946:	6a42                	ld	s4,16(sp)
ffffffffc0205948:	6aa2                	ld	s5,8(sp)
ffffffffc020594a:	854e                	mv	a0,s3
ffffffffc020594c:	69e2                	ld	s3,24(sp)
ffffffffc020594e:	6121                	addi	sp,sp,64
ffffffffc0205950:	8082                	ret
ffffffffc0205952:	8556                	mv	a0,s5
ffffffffc0205954:	c0dfe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0205958:	854e                	mv	a0,s3
ffffffffc020595a:	85a2                	mv	a1,s0
ffffffffc020595c:	0404a823          	sw	zero,80(s1)
ffffffffc0205960:	ef0ff0ef          	jal	ra,ffffffffc0205050 <file_getdirentry>
ffffffffc0205964:	89aa                	mv	s3,a0
ffffffffc0205966:	f969                	bnez	a0,ffffffffc0205938 <sysfile_getdirentry+0x60>
ffffffffc0205968:	8556                	mv	a0,s5
ffffffffc020596a:	bfbfe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020596e:	000a3783          	ld	a5,0(s4)
ffffffffc0205972:	c399                	beqz	a5,ffffffffc0205978 <sysfile_getdirentry+0xa0>
ffffffffc0205974:	43dc                	lw	a5,4(a5)
ffffffffc0205976:	c8bc                	sw	a5,80(s1)
ffffffffc0205978:	10800693          	li	a3,264
ffffffffc020597c:	8622                	mv	a2,s0
ffffffffc020597e:	85ca                	mv	a1,s2
ffffffffc0205980:	8526                	mv	a0,s1
ffffffffc0205982:	9d9fe0ef          	jal	ra,ffffffffc020435a <copy_to_user>
ffffffffc0205986:	e111                	bnez	a0,ffffffffc020598a <sysfile_getdirentry+0xb2>
ffffffffc0205988:	59f5                	li	s3,-3
ffffffffc020598a:	8556                	mv	a0,s5
ffffffffc020598c:	bd5fe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0205990:	0404a823          	sw	zero,80(s1)
ffffffffc0205994:	b755                	j	ffffffffc0205938 <sysfile_getdirentry+0x60>
ffffffffc0205996:	85aa                	mv	a1,a0
ffffffffc0205998:	4705                	li	a4,1
ffffffffc020599a:	46a1                	li	a3,8
ffffffffc020599c:	864a                	mv	a2,s2
ffffffffc020599e:	4501                	li	a0,0
ffffffffc02059a0:	987fe0ef          	jal	ra,ffffffffc0204326 <copy_from_user>
ffffffffc02059a4:	cd11                	beqz	a0,ffffffffc02059c0 <sysfile_getdirentry+0xe8>
ffffffffc02059a6:	854e                	mv	a0,s3
ffffffffc02059a8:	85a2                	mv	a1,s0
ffffffffc02059aa:	ea6ff0ef          	jal	ra,ffffffffc0205050 <file_getdirentry>
ffffffffc02059ae:	89aa                	mv	s3,a0
ffffffffc02059b0:	f541                	bnez	a0,ffffffffc0205938 <sysfile_getdirentry+0x60>
ffffffffc02059b2:	10800693          	li	a3,264
ffffffffc02059b6:	8622                	mv	a2,s0
ffffffffc02059b8:	85ca                	mv	a1,s2
ffffffffc02059ba:	9a1fe0ef          	jal	ra,ffffffffc020435a <copy_to_user>
ffffffffc02059be:	fd2d                	bnez	a0,ffffffffc0205938 <sysfile_getdirentry+0x60>
ffffffffc02059c0:	59f5                	li	s3,-3
ffffffffc02059c2:	bf9d                	j	ffffffffc0205938 <sysfile_getdirentry+0x60>
ffffffffc02059c4:	59f1                	li	s3,-4
ffffffffc02059c6:	bfa5                	j	ffffffffc020593e <sysfile_getdirentry+0x66>

ffffffffc02059c8 <sysfile_dup>:
ffffffffc02059c8:	f6eff06f          	j	ffffffffc0205136 <file_dup>

ffffffffc02059cc <kernel_thread_entry>:
ffffffffc02059cc:	8526                	mv	a0,s1
ffffffffc02059ce:	9402                	jalr	s0
ffffffffc02059d0:	62c000ef          	jal	ra,ffffffffc0205ffc <do_exit>

ffffffffc02059d4 <alloc_proc>:
ffffffffc02059d4:	1141                	addi	sp,sp,-16
ffffffffc02059d6:	15000513          	li	a0,336
ffffffffc02059da:	e022                	sd	s0,0(sp)
ffffffffc02059dc:	e406                	sd	ra,8(sp)
ffffffffc02059de:	db0fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc02059e2:	842a                	mv	s0,a0
ffffffffc02059e4:	cd35                	beqz	a0,ffffffffc0205a60 <alloc_proc+0x8c>
ffffffffc02059e6:	57fd                	li	a5,-1
ffffffffc02059e8:	1782                	slli	a5,a5,0x20
ffffffffc02059ea:	e11c                	sd	a5,0(a0)
ffffffffc02059ec:	07000613          	li	a2,112
ffffffffc02059f0:	4581                	li	a1,0
ffffffffc02059f2:	00052423          	sw	zero,8(a0)
ffffffffc02059f6:	00053823          	sd	zero,16(a0)
ffffffffc02059fa:	00053c23          	sd	zero,24(a0)
ffffffffc02059fe:	02053023          	sd	zero,32(a0)
ffffffffc0205a02:	02053423          	sd	zero,40(a0)
ffffffffc0205a06:	03050513          	addi	a0,a0,48
ffffffffc0205a0a:	297050ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0205a0e:	00091797          	auipc	a5,0x91
ffffffffc0205a12:	e827b783          	ld	a5,-382(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0205a16:	f45c                	sd	a5,168(s0)
ffffffffc0205a18:	0a043023          	sd	zero,160(s0)
ffffffffc0205a1c:	0a042823          	sw	zero,176(s0)
ffffffffc0205a20:	463d                	li	a2,15
ffffffffc0205a22:	4581                	li	a1,0
ffffffffc0205a24:	0b440513          	addi	a0,s0,180
ffffffffc0205a28:	279050ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0205a2c:	11040793          	addi	a5,s0,272
ffffffffc0205a30:	0e042623          	sw	zero,236(s0)
ffffffffc0205a34:	0e043c23          	sd	zero,248(s0)
ffffffffc0205a38:	10043023          	sd	zero,256(s0)
ffffffffc0205a3c:	0e043823          	sd	zero,240(s0)
ffffffffc0205a40:	10043423          	sd	zero,264(s0)
ffffffffc0205a44:	10f43c23          	sd	a5,280(s0)
ffffffffc0205a48:	10f43823          	sd	a5,272(s0)
ffffffffc0205a4c:	12042023          	sw	zero,288(s0)
ffffffffc0205a50:	12043423          	sd	zero,296(s0)
ffffffffc0205a54:	12043823          	sd	zero,304(s0)
ffffffffc0205a58:	12043c23          	sd	zero,312(s0)
ffffffffc0205a5c:	14043023          	sd	zero,320(s0)
ffffffffc0205a60:	60a2                	ld	ra,8(sp)
ffffffffc0205a62:	8522                	mv	a0,s0
ffffffffc0205a64:	6402                	ld	s0,0(sp)
ffffffffc0205a66:	0141                	addi	sp,sp,16
ffffffffc0205a68:	8082                	ret

ffffffffc0205a6a <forkret>:
ffffffffc0205a6a:	00091797          	auipc	a5,0x91
ffffffffc0205a6e:	e567b783          	ld	a5,-426(a5) # ffffffffc02968c0 <current>
ffffffffc0205a72:	73c8                	ld	a0,160(a5)
ffffffffc0205a74:	837fb06f          	j	ffffffffc02012aa <forkrets>

ffffffffc0205a78 <put_pgdir.isra.0>:
ffffffffc0205a78:	1141                	addi	sp,sp,-16
ffffffffc0205a7a:	e406                	sd	ra,8(sp)
ffffffffc0205a7c:	c02007b7          	lui	a5,0xc0200
ffffffffc0205a80:	02f56e63          	bltu	a0,a5,ffffffffc0205abc <put_pgdir.isra.0+0x44>
ffffffffc0205a84:	00091697          	auipc	a3,0x91
ffffffffc0205a88:	e346b683          	ld	a3,-460(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0205a8c:	8d15                	sub	a0,a0,a3
ffffffffc0205a8e:	8131                	srli	a0,a0,0xc
ffffffffc0205a90:	00091797          	auipc	a5,0x91
ffffffffc0205a94:	e107b783          	ld	a5,-496(a5) # ffffffffc02968a0 <npage>
ffffffffc0205a98:	02f57f63          	bgeu	a0,a5,ffffffffc0205ad6 <put_pgdir.isra.0+0x5e>
ffffffffc0205a9c:	0000a697          	auipc	a3,0xa
ffffffffc0205aa0:	d1c6b683          	ld	a3,-740(a3) # ffffffffc020f7b8 <nbase>
ffffffffc0205aa4:	60a2                	ld	ra,8(sp)
ffffffffc0205aa6:	8d15                	sub	a0,a0,a3
ffffffffc0205aa8:	00091797          	auipc	a5,0x91
ffffffffc0205aac:	e007b783          	ld	a5,-512(a5) # ffffffffc02968a8 <pages>
ffffffffc0205ab0:	051a                	slli	a0,a0,0x6
ffffffffc0205ab2:	4585                	li	a1,1
ffffffffc0205ab4:	953e                	add	a0,a0,a5
ffffffffc0205ab6:	0141                	addi	sp,sp,16
ffffffffc0205ab8:	ef2fc06f          	j	ffffffffc02021aa <free_pages>
ffffffffc0205abc:	86aa                	mv	a3,a0
ffffffffc0205abe:	00007617          	auipc	a2,0x7
ffffffffc0205ac2:	a9260613          	addi	a2,a2,-1390 # ffffffffc020c550 <default_pmm_manager+0xe0>
ffffffffc0205ac6:	07700593          	li	a1,119
ffffffffc0205aca:	00007517          	auipc	a0,0x7
ffffffffc0205ace:	a0650513          	addi	a0,a0,-1530 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0205ad2:	9cdfa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205ad6:	00007617          	auipc	a2,0x7
ffffffffc0205ada:	aa260613          	addi	a2,a2,-1374 # ffffffffc020c578 <default_pmm_manager+0x108>
ffffffffc0205ade:	06900593          	li	a1,105
ffffffffc0205ae2:	00007517          	auipc	a0,0x7
ffffffffc0205ae6:	9ee50513          	addi	a0,a0,-1554 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0205aea:	9b5fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205aee <proc_run>:
ffffffffc0205aee:	7179                	addi	sp,sp,-48
ffffffffc0205af0:	ec4a                	sd	s2,24(sp)
ffffffffc0205af2:	00091917          	auipc	s2,0x91
ffffffffc0205af6:	dce90913          	addi	s2,s2,-562 # ffffffffc02968c0 <current>
ffffffffc0205afa:	f026                	sd	s1,32(sp)
ffffffffc0205afc:	00093483          	ld	s1,0(s2)
ffffffffc0205b00:	f406                	sd	ra,40(sp)
ffffffffc0205b02:	e84e                	sd	s3,16(sp)
ffffffffc0205b04:	02a48a63          	beq	s1,a0,ffffffffc0205b38 <proc_run+0x4a>
ffffffffc0205b08:	100027f3          	csrr	a5,sstatus
ffffffffc0205b0c:	8b89                	andi	a5,a5,2
ffffffffc0205b0e:	4981                	li	s3,0
ffffffffc0205b10:	e3a9                	bnez	a5,ffffffffc0205b52 <proc_run+0x64>
ffffffffc0205b12:	755c                	ld	a5,168(a0)
ffffffffc0205b14:	577d                	li	a4,-1
ffffffffc0205b16:	177e                	slli	a4,a4,0x3f
ffffffffc0205b18:	83b1                	srli	a5,a5,0xc
ffffffffc0205b1a:	00a93023          	sd	a0,0(s2)
ffffffffc0205b1e:	8fd9                	or	a5,a5,a4
ffffffffc0205b20:	18079073          	csrw	satp,a5
ffffffffc0205b24:	12000073          	sfence.vma
ffffffffc0205b28:	03050593          	addi	a1,a0,48
ffffffffc0205b2c:	03048513          	addi	a0,s1,48
ffffffffc0205b30:	5a4010ef          	jal	ra,ffffffffc02070d4 <switch_to>
ffffffffc0205b34:	00099863          	bnez	s3,ffffffffc0205b44 <proc_run+0x56>
ffffffffc0205b38:	70a2                	ld	ra,40(sp)
ffffffffc0205b3a:	7482                	ld	s1,32(sp)
ffffffffc0205b3c:	6962                	ld	s2,24(sp)
ffffffffc0205b3e:	69c2                	ld	s3,16(sp)
ffffffffc0205b40:	6145                	addi	sp,sp,48
ffffffffc0205b42:	8082                	ret
ffffffffc0205b44:	70a2                	ld	ra,40(sp)
ffffffffc0205b46:	7482                	ld	s1,32(sp)
ffffffffc0205b48:	6962                	ld	s2,24(sp)
ffffffffc0205b4a:	69c2                	ld	s3,16(sp)
ffffffffc0205b4c:	6145                	addi	sp,sp,48
ffffffffc0205b4e:	91efb06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0205b52:	e42a                	sd	a0,8(sp)
ffffffffc0205b54:	91efb0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0205b58:	6522                	ld	a0,8(sp)
ffffffffc0205b5a:	4985                	li	s3,1
ffffffffc0205b5c:	bf5d                	j	ffffffffc0205b12 <proc_run+0x24>

ffffffffc0205b5e <do_fork>:
ffffffffc0205b5e:	7119                	addi	sp,sp,-128
ffffffffc0205b60:	f0ca                	sd	s2,96(sp)
ffffffffc0205b62:	00091917          	auipc	s2,0x91
ffffffffc0205b66:	d7690913          	addi	s2,s2,-650 # ffffffffc02968d8 <nr_process>
ffffffffc0205b6a:	00092703          	lw	a4,0(s2)
ffffffffc0205b6e:	fc86                	sd	ra,120(sp)
ffffffffc0205b70:	f8a2                	sd	s0,112(sp)
ffffffffc0205b72:	f4a6                	sd	s1,104(sp)
ffffffffc0205b74:	ecce                	sd	s3,88(sp)
ffffffffc0205b76:	e8d2                	sd	s4,80(sp)
ffffffffc0205b78:	e4d6                	sd	s5,72(sp)
ffffffffc0205b7a:	e0da                	sd	s6,64(sp)
ffffffffc0205b7c:	fc5e                	sd	s7,56(sp)
ffffffffc0205b7e:	f862                	sd	s8,48(sp)
ffffffffc0205b80:	f466                	sd	s9,40(sp)
ffffffffc0205b82:	f06a                	sd	s10,32(sp)
ffffffffc0205b84:	ec6e                	sd	s11,24(sp)
ffffffffc0205b86:	6785                	lui	a5,0x1
ffffffffc0205b88:	e032                	sd	a2,0(sp)
ffffffffc0205b8a:	36f75c63          	bge	a4,a5,ffffffffc0205f02 <do_fork+0x3a4>
ffffffffc0205b8e:	89aa                	mv	s3,a0
ffffffffc0205b90:	8a2e                	mv	s4,a1
ffffffffc0205b92:	e43ff0ef          	jal	ra,ffffffffc02059d4 <alloc_proc>
ffffffffc0205b96:	842a                	mv	s0,a0
ffffffffc0205b98:	34050e63          	beqz	a0,ffffffffc0205ef4 <do_fork+0x396>
ffffffffc0205b9c:	00091d97          	auipc	s11,0x91
ffffffffc0205ba0:	d24d8d93          	addi	s11,s11,-732 # ffffffffc02968c0 <current>
ffffffffc0205ba4:	000db783          	ld	a5,0(s11)
ffffffffc0205ba8:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_bin_swap_img_size-0x6c14>
ffffffffc0205bac:	f11c                	sd	a5,32(a0)
ffffffffc0205bae:	3c071f63          	bnez	a4,ffffffffc0205f8c <do_fork+0x42e>
ffffffffc0205bb2:	4509                	li	a0,2
ffffffffc0205bb4:	db8fc0ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0205bb8:	32050b63          	beqz	a0,ffffffffc0205eee <do_fork+0x390>
ffffffffc0205bbc:	00091b97          	auipc	s7,0x91
ffffffffc0205bc0:	cecb8b93          	addi	s7,s7,-788 # ffffffffc02968a8 <pages>
ffffffffc0205bc4:	000bb683          	ld	a3,0(s7)
ffffffffc0205bc8:	00091b17          	auipc	s6,0x91
ffffffffc0205bcc:	cd8b0b13          	addi	s6,s6,-808 # ffffffffc02968a0 <npage>
ffffffffc0205bd0:	0000aa97          	auipc	s5,0xa
ffffffffc0205bd4:	be8aba83          	ld	s5,-1048(s5) # ffffffffc020f7b8 <nbase>
ffffffffc0205bd8:	40d506b3          	sub	a3,a0,a3
ffffffffc0205bdc:	8699                	srai	a3,a3,0x6
ffffffffc0205bde:	5c7d                	li	s8,-1
ffffffffc0205be0:	000b3783          	ld	a5,0(s6)
ffffffffc0205be4:	96d6                	add	a3,a3,s5
ffffffffc0205be6:	00cc5c13          	srli	s8,s8,0xc
ffffffffc0205bea:	0186f733          	and	a4,a3,s8
ffffffffc0205bee:	06b2                	slli	a3,a3,0xc
ffffffffc0205bf0:	34f77663          	bgeu	a4,a5,ffffffffc0205f3c <do_fork+0x3de>
ffffffffc0205bf4:	000db603          	ld	a2,0(s11)
ffffffffc0205bf8:	00091c97          	auipc	s9,0x91
ffffffffc0205bfc:	cc0c8c93          	addi	s9,s9,-832 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0205c00:	000cb703          	ld	a4,0(s9)
ffffffffc0205c04:	7604                	ld	s1,40(a2)
ffffffffc0205c06:	96ba                	add	a3,a3,a4
ffffffffc0205c08:	e814                	sd	a3,16(s0)
ffffffffc0205c0a:	c485                	beqz	s1,ffffffffc0205c32 <do_fork+0xd4>
ffffffffc0205c0c:	1009f713          	andi	a4,s3,256
ffffffffc0205c10:	20070863          	beqz	a4,ffffffffc0205e20 <do_fork+0x2c2>
ffffffffc0205c14:	5898                	lw	a4,48(s1)
ffffffffc0205c16:	6c94                	ld	a3,24(s1)
ffffffffc0205c18:	c0200637          	lui	a2,0xc0200
ffffffffc0205c1c:	2705                	addiw	a4,a4,1
ffffffffc0205c1e:	d898                	sw	a4,48(s1)
ffffffffc0205c20:	f404                	sd	s1,40(s0)
ffffffffc0205c22:	30c6e163          	bltu	a3,a2,ffffffffc0205f24 <do_fork+0x3c6>
ffffffffc0205c26:	000cb783          	ld	a5,0(s9)
ffffffffc0205c2a:	000db603          	ld	a2,0(s11)
ffffffffc0205c2e:	8e9d                	sub	a3,a3,a5
ffffffffc0205c30:	f454                	sd	a3,168(s0)
ffffffffc0205c32:	14863c03          	ld	s8,328(a2) # ffffffffc0200148 <readline+0x96>
ffffffffc0205c36:	320c0b63          	beqz	s8,ffffffffc0205f6c <do_fork+0x40e>
ffffffffc0205c3a:	00b9d993          	srli	s3,s3,0xb
ffffffffc0205c3e:	0019f993          	andi	s3,s3,1
ffffffffc0205c42:	1a098763          	beqz	s3,ffffffffc0205df0 <do_fork+0x292>
ffffffffc0205c46:	010c2783          	lw	a5,16(s8)
ffffffffc0205c4a:	6818                	ld	a4,16(s0)
ffffffffc0205c4c:	6602                	ld	a2,0(sp)
ffffffffc0205c4e:	2785                	addiw	a5,a5,1
ffffffffc0205c50:	00fc2823          	sw	a5,16(s8)
ffffffffc0205c54:	6789                	lui	a5,0x2
ffffffffc0205c56:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0205c5a:	973e                	add	a4,a4,a5
ffffffffc0205c5c:	15843423          	sd	s8,328(s0)
ffffffffc0205c60:	f058                	sd	a4,160(s0)
ffffffffc0205c62:	87ba                	mv	a5,a4
ffffffffc0205c64:	12060893          	addi	a7,a2,288
ffffffffc0205c68:	00063803          	ld	a6,0(a2)
ffffffffc0205c6c:	6608                	ld	a0,8(a2)
ffffffffc0205c6e:	6a0c                	ld	a1,16(a2)
ffffffffc0205c70:	6e14                	ld	a3,24(a2)
ffffffffc0205c72:	0107b023          	sd	a6,0(a5)
ffffffffc0205c76:	e788                	sd	a0,8(a5)
ffffffffc0205c78:	eb8c                	sd	a1,16(a5)
ffffffffc0205c7a:	ef94                	sd	a3,24(a5)
ffffffffc0205c7c:	02060613          	addi	a2,a2,32
ffffffffc0205c80:	02078793          	addi	a5,a5,32
ffffffffc0205c84:	ff1612e3          	bne	a2,a7,ffffffffc0205c68 <do_fork+0x10a>
ffffffffc0205c88:	04073823          	sd	zero,80(a4)
ffffffffc0205c8c:	120a0f63          	beqz	s4,ffffffffc0205dca <do_fork+0x26c>
ffffffffc0205c90:	01473823          	sd	s4,16(a4)
ffffffffc0205c94:	00000797          	auipc	a5,0x0
ffffffffc0205c98:	dd678793          	addi	a5,a5,-554 # ffffffffc0205a6a <forkret>
ffffffffc0205c9c:	f81c                	sd	a5,48(s0)
ffffffffc0205c9e:	fc18                	sd	a4,56(s0)
ffffffffc0205ca0:	100027f3          	csrr	a5,sstatus
ffffffffc0205ca4:	8b89                	andi	a5,a5,2
ffffffffc0205ca6:	4981                	li	s3,0
ffffffffc0205ca8:	14079063          	bnez	a5,ffffffffc0205de8 <do_fork+0x28a>
ffffffffc0205cac:	0008b817          	auipc	a6,0x8b
ffffffffc0205cb0:	3ac80813          	addi	a6,a6,940 # ffffffffc0291058 <last_pid.1>
ffffffffc0205cb4:	00082783          	lw	a5,0(a6)
ffffffffc0205cb8:	6709                	lui	a4,0x2
ffffffffc0205cba:	0017851b          	addiw	a0,a5,1
ffffffffc0205cbe:	00a82023          	sw	a0,0(a6)
ffffffffc0205cc2:	08e55d63          	bge	a0,a4,ffffffffc0205d5c <do_fork+0x1fe>
ffffffffc0205cc6:	0008b317          	auipc	t1,0x8b
ffffffffc0205cca:	39630313          	addi	t1,t1,918 # ffffffffc029105c <next_safe.0>
ffffffffc0205cce:	00032783          	lw	a5,0(t1)
ffffffffc0205cd2:	00090497          	auipc	s1,0x90
ffffffffc0205cd6:	aee48493          	addi	s1,s1,-1298 # ffffffffc02957c0 <proc_list>
ffffffffc0205cda:	08f55963          	bge	a0,a5,ffffffffc0205d6c <do_fork+0x20e>
ffffffffc0205cde:	c048                	sw	a0,4(s0)
ffffffffc0205ce0:	45a9                	li	a1,10
ffffffffc0205ce2:	2501                	sext.w	a0,a0
ffffffffc0205ce4:	288050ef          	jal	ra,ffffffffc020af6c <hash32>
ffffffffc0205ce8:	02051793          	slli	a5,a0,0x20
ffffffffc0205cec:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0205cf0:	0008c797          	auipc	a5,0x8c
ffffffffc0205cf4:	ad078793          	addi	a5,a5,-1328 # ffffffffc02917c0 <hash_list>
ffffffffc0205cf8:	953e                	add	a0,a0,a5
ffffffffc0205cfa:	650c                	ld	a1,8(a0)
ffffffffc0205cfc:	7014                	ld	a3,32(s0)
ffffffffc0205cfe:	0d840793          	addi	a5,s0,216
ffffffffc0205d02:	e19c                	sd	a5,0(a1)
ffffffffc0205d04:	6490                	ld	a2,8(s1)
ffffffffc0205d06:	e51c                	sd	a5,8(a0)
ffffffffc0205d08:	7af8                	ld	a4,240(a3)
ffffffffc0205d0a:	0c840793          	addi	a5,s0,200
ffffffffc0205d0e:	f06c                	sd	a1,224(s0)
ffffffffc0205d10:	ec68                	sd	a0,216(s0)
ffffffffc0205d12:	e21c                	sd	a5,0(a2)
ffffffffc0205d14:	e49c                	sd	a5,8(s1)
ffffffffc0205d16:	e870                	sd	a2,208(s0)
ffffffffc0205d18:	e464                	sd	s1,200(s0)
ffffffffc0205d1a:	0e043c23          	sd	zero,248(s0)
ffffffffc0205d1e:	10e43023          	sd	a4,256(s0)
ffffffffc0205d22:	c311                	beqz	a4,ffffffffc0205d26 <do_fork+0x1c8>
ffffffffc0205d24:	ff60                	sd	s0,248(a4)
ffffffffc0205d26:	00092783          	lw	a5,0(s2)
ffffffffc0205d2a:	fae0                	sd	s0,240(a3)
ffffffffc0205d2c:	2785                	addiw	a5,a5,1
ffffffffc0205d2e:	00f92023          	sw	a5,0(s2)
ffffffffc0205d32:	16099563          	bnez	s3,ffffffffc0205e9c <do_fork+0x33e>
ffffffffc0205d36:	8522                	mv	a0,s0
ffffffffc0205d38:	540010ef          	jal	ra,ffffffffc0207278 <wakeup_proc>
ffffffffc0205d3c:	4048                	lw	a0,4(s0)
ffffffffc0205d3e:	70e6                	ld	ra,120(sp)
ffffffffc0205d40:	7446                	ld	s0,112(sp)
ffffffffc0205d42:	74a6                	ld	s1,104(sp)
ffffffffc0205d44:	7906                	ld	s2,96(sp)
ffffffffc0205d46:	69e6                	ld	s3,88(sp)
ffffffffc0205d48:	6a46                	ld	s4,80(sp)
ffffffffc0205d4a:	6aa6                	ld	s5,72(sp)
ffffffffc0205d4c:	6b06                	ld	s6,64(sp)
ffffffffc0205d4e:	7be2                	ld	s7,56(sp)
ffffffffc0205d50:	7c42                	ld	s8,48(sp)
ffffffffc0205d52:	7ca2                	ld	s9,40(sp)
ffffffffc0205d54:	7d02                	ld	s10,32(sp)
ffffffffc0205d56:	6de2                	ld	s11,24(sp)
ffffffffc0205d58:	6109                	addi	sp,sp,128
ffffffffc0205d5a:	8082                	ret
ffffffffc0205d5c:	4785                	li	a5,1
ffffffffc0205d5e:	00f82023          	sw	a5,0(a6)
ffffffffc0205d62:	4505                	li	a0,1
ffffffffc0205d64:	0008b317          	auipc	t1,0x8b
ffffffffc0205d68:	2f830313          	addi	t1,t1,760 # ffffffffc029105c <next_safe.0>
ffffffffc0205d6c:	00090497          	auipc	s1,0x90
ffffffffc0205d70:	a5448493          	addi	s1,s1,-1452 # ffffffffc02957c0 <proc_list>
ffffffffc0205d74:	0084be03          	ld	t3,8(s1)
ffffffffc0205d78:	6789                	lui	a5,0x2
ffffffffc0205d7a:	00f32023          	sw	a5,0(t1)
ffffffffc0205d7e:	86aa                	mv	a3,a0
ffffffffc0205d80:	4581                	li	a1,0
ffffffffc0205d82:	6e89                	lui	t4,0x2
ffffffffc0205d84:	169e0a63          	beq	t3,s1,ffffffffc0205ef8 <do_fork+0x39a>
ffffffffc0205d88:	88ae                	mv	a7,a1
ffffffffc0205d8a:	87f2                	mv	a5,t3
ffffffffc0205d8c:	6609                	lui	a2,0x2
ffffffffc0205d8e:	a811                	j	ffffffffc0205da2 <do_fork+0x244>
ffffffffc0205d90:	00e6d663          	bge	a3,a4,ffffffffc0205d9c <do_fork+0x23e>
ffffffffc0205d94:	00c75463          	bge	a4,a2,ffffffffc0205d9c <do_fork+0x23e>
ffffffffc0205d98:	863a                	mv	a2,a4
ffffffffc0205d9a:	4885                	li	a7,1
ffffffffc0205d9c:	679c                	ld	a5,8(a5)
ffffffffc0205d9e:	00978d63          	beq	a5,s1,ffffffffc0205db8 <do_fork+0x25a>
ffffffffc0205da2:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_bin_swap_img_size-0x5dc4>
ffffffffc0205da6:	fed715e3          	bne	a4,a3,ffffffffc0205d90 <do_fork+0x232>
ffffffffc0205daa:	2685                	addiw	a3,a3,1
ffffffffc0205dac:	0ec6db63          	bge	a3,a2,ffffffffc0205ea2 <do_fork+0x344>
ffffffffc0205db0:	679c                	ld	a5,8(a5)
ffffffffc0205db2:	4585                	li	a1,1
ffffffffc0205db4:	fe9797e3          	bne	a5,s1,ffffffffc0205da2 <do_fork+0x244>
ffffffffc0205db8:	c581                	beqz	a1,ffffffffc0205dc0 <do_fork+0x262>
ffffffffc0205dba:	00d82023          	sw	a3,0(a6)
ffffffffc0205dbe:	8536                	mv	a0,a3
ffffffffc0205dc0:	f0088fe3          	beqz	a7,ffffffffc0205cde <do_fork+0x180>
ffffffffc0205dc4:	00c32023          	sw	a2,0(t1)
ffffffffc0205dc8:	bf19                	j	ffffffffc0205cde <do_fork+0x180>
ffffffffc0205dca:	8a3a                	mv	s4,a4
ffffffffc0205dcc:	01473823          	sd	s4,16(a4) # 2010 <_binary_bin_swap_img_size-0x5cf0>
ffffffffc0205dd0:	00000797          	auipc	a5,0x0
ffffffffc0205dd4:	c9a78793          	addi	a5,a5,-870 # ffffffffc0205a6a <forkret>
ffffffffc0205dd8:	f81c                	sd	a5,48(s0)
ffffffffc0205dda:	fc18                	sd	a4,56(s0)
ffffffffc0205ddc:	100027f3          	csrr	a5,sstatus
ffffffffc0205de0:	8b89                	andi	a5,a5,2
ffffffffc0205de2:	4981                	li	s3,0
ffffffffc0205de4:	ec0784e3          	beqz	a5,ffffffffc0205cac <do_fork+0x14e>
ffffffffc0205de8:	e8bfa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0205dec:	4985                	li	s3,1
ffffffffc0205dee:	bd7d                	j	ffffffffc0205cac <do_fork+0x14e>
ffffffffc0205df0:	bdeff0ef          	jal	ra,ffffffffc02051ce <files_create>
ffffffffc0205df4:	89aa                	mv	s3,a0
ffffffffc0205df6:	c911                	beqz	a0,ffffffffc0205e0a <do_fork+0x2ac>
ffffffffc0205df8:	85e2                	mv	a1,s8
ffffffffc0205dfa:	d0cff0ef          	jal	ra,ffffffffc0205306 <dup_files>
ffffffffc0205dfe:	8c4e                	mv	s8,s3
ffffffffc0205e00:	e40503e3          	beqz	a0,ffffffffc0205c46 <do_fork+0xe8>
ffffffffc0205e04:	854e                	mv	a0,s3
ffffffffc0205e06:	bfeff0ef          	jal	ra,ffffffffc0205204 <files_destroy>
ffffffffc0205e0a:	14843503          	ld	a0,328(s0)
ffffffffc0205e0e:	c94d                	beqz	a0,ffffffffc0205ec0 <do_fork+0x362>
ffffffffc0205e10:	491c                	lw	a5,16(a0)
ffffffffc0205e12:	fff7871b          	addiw	a4,a5,-1
ffffffffc0205e16:	c918                	sw	a4,16(a0)
ffffffffc0205e18:	e745                	bnez	a4,ffffffffc0205ec0 <do_fork+0x362>
ffffffffc0205e1a:	beaff0ef          	jal	ra,ffffffffc0205204 <files_destroy>
ffffffffc0205e1e:	a04d                	j	ffffffffc0205ec0 <do_fork+0x362>
ffffffffc0205e20:	de9fd0ef          	jal	ra,ffffffffc0203c08 <mm_create>
ffffffffc0205e24:	8d2a                	mv	s10,a0
ffffffffc0205e26:	cd49                	beqz	a0,ffffffffc0205ec0 <do_fork+0x362>
ffffffffc0205e28:	4505                	li	a0,1
ffffffffc0205e2a:	b42fc0ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0205e2e:	c551                	beqz	a0,ffffffffc0205eba <do_fork+0x35c>
ffffffffc0205e30:	000bb683          	ld	a3,0(s7)
ffffffffc0205e34:	000b3703          	ld	a4,0(s6)
ffffffffc0205e38:	40d506b3          	sub	a3,a0,a3
ffffffffc0205e3c:	8699                	srai	a3,a3,0x6
ffffffffc0205e3e:	96d6                	add	a3,a3,s5
ffffffffc0205e40:	0186fc33          	and	s8,a3,s8
ffffffffc0205e44:	06b2                	slli	a3,a3,0xc
ffffffffc0205e46:	0eec7b63          	bgeu	s8,a4,ffffffffc0205f3c <do_fork+0x3de>
ffffffffc0205e4a:	000cbc03          	ld	s8,0(s9)
ffffffffc0205e4e:	6605                	lui	a2,0x1
ffffffffc0205e50:	00091597          	auipc	a1,0x91
ffffffffc0205e54:	a485b583          	ld	a1,-1464(a1) # ffffffffc0296898 <boot_pgdir_va>
ffffffffc0205e58:	9c36                	add	s8,s8,a3
ffffffffc0205e5a:	8562                	mv	a0,s8
ffffffffc0205e5c:	696050ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc0205e60:	03848713          	addi	a4,s1,56
ffffffffc0205e64:	853a                	mv	a0,a4
ffffffffc0205e66:	018d3c23          	sd	s8,24(s10)
ffffffffc0205e6a:	e43a                	sd	a4,8(sp)
ffffffffc0205e6c:	ef8fe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0205e70:	000db683          	ld	a3,0(s11)
ffffffffc0205e74:	6722                	ld	a4,8(sp)
ffffffffc0205e76:	c299                	beqz	a3,ffffffffc0205e7c <do_fork+0x31e>
ffffffffc0205e78:	42d4                	lw	a3,4(a3)
ffffffffc0205e7a:	c8b4                	sw	a3,80(s1)
ffffffffc0205e7c:	85a6                	mv	a1,s1
ffffffffc0205e7e:	856a                	mv	a0,s10
ffffffffc0205e80:	e43a                	sd	a4,8(sp)
ffffffffc0205e82:	fd7fd0ef          	jal	ra,ffffffffc0203e58 <dup_mmap>
ffffffffc0205e86:	6722                	ld	a4,8(sp)
ffffffffc0205e88:	8c2a                	mv	s8,a0
ffffffffc0205e8a:	853a                	mv	a0,a4
ffffffffc0205e8c:	ed4fe0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0205e90:	0404a823          	sw	zero,80(s1)
ffffffffc0205e94:	000c1c63          	bnez	s8,ffffffffc0205eac <do_fork+0x34e>
ffffffffc0205e98:	84ea                	mv	s1,s10
ffffffffc0205e9a:	bbad                	j	ffffffffc0205c14 <do_fork+0xb6>
ffffffffc0205e9c:	dd1fa0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0205ea0:	bd59                	j	ffffffffc0205d36 <do_fork+0x1d8>
ffffffffc0205ea2:	01d6c363          	blt	a3,t4,ffffffffc0205ea8 <do_fork+0x34a>
ffffffffc0205ea6:	4685                	li	a3,1
ffffffffc0205ea8:	4585                	li	a1,1
ffffffffc0205eaa:	bde9                	j	ffffffffc0205d84 <do_fork+0x226>
ffffffffc0205eac:	856a                	mv	a0,s10
ffffffffc0205eae:	844fe0ef          	jal	ra,ffffffffc0203ef2 <exit_mmap>
ffffffffc0205eb2:	018d3503          	ld	a0,24(s10)
ffffffffc0205eb6:	bc3ff0ef          	jal	ra,ffffffffc0205a78 <put_pgdir.isra.0>
ffffffffc0205eba:	856a                	mv	a0,s10
ffffffffc0205ebc:	e9bfd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc0205ec0:	6814                	ld	a3,16(s0)
ffffffffc0205ec2:	c02007b7          	lui	a5,0xc0200
ffffffffc0205ec6:	04f6e363          	bltu	a3,a5,ffffffffc0205f0c <do_fork+0x3ae>
ffffffffc0205eca:	000cb783          	ld	a5,0(s9)
ffffffffc0205ece:	000b3703          	ld	a4,0(s6)
ffffffffc0205ed2:	40f687b3          	sub	a5,a3,a5
ffffffffc0205ed6:	83b1                	srli	a5,a5,0xc
ffffffffc0205ed8:	06e7fe63          	bgeu	a5,a4,ffffffffc0205f54 <do_fork+0x3f6>
ffffffffc0205edc:	000bb503          	ld	a0,0(s7)
ffffffffc0205ee0:	415787b3          	sub	a5,a5,s5
ffffffffc0205ee4:	079a                	slli	a5,a5,0x6
ffffffffc0205ee6:	4589                	li	a1,2
ffffffffc0205ee8:	953e                	add	a0,a0,a5
ffffffffc0205eea:	ac0fc0ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0205eee:	8522                	mv	a0,s0
ffffffffc0205ef0:	94efc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0205ef4:	5571                	li	a0,-4
ffffffffc0205ef6:	b5a1                	j	ffffffffc0205d3e <do_fork+0x1e0>
ffffffffc0205ef8:	c599                	beqz	a1,ffffffffc0205f06 <do_fork+0x3a8>
ffffffffc0205efa:	00d82023          	sw	a3,0(a6)
ffffffffc0205efe:	8536                	mv	a0,a3
ffffffffc0205f00:	bbf9                	j	ffffffffc0205cde <do_fork+0x180>
ffffffffc0205f02:	556d                	li	a0,-5
ffffffffc0205f04:	bd2d                	j	ffffffffc0205d3e <do_fork+0x1e0>
ffffffffc0205f06:	00082503          	lw	a0,0(a6)
ffffffffc0205f0a:	bbd1                	j	ffffffffc0205cde <do_fork+0x180>
ffffffffc0205f0c:	00006617          	auipc	a2,0x6
ffffffffc0205f10:	64460613          	addi	a2,a2,1604 # ffffffffc020c550 <default_pmm_manager+0xe0>
ffffffffc0205f14:	07700593          	li	a1,119
ffffffffc0205f18:	00006517          	auipc	a0,0x6
ffffffffc0205f1c:	5b850513          	addi	a0,a0,1464 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0205f20:	d7efa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205f24:	00006617          	auipc	a2,0x6
ffffffffc0205f28:	62c60613          	addi	a2,a2,1580 # ffffffffc020c550 <default_pmm_manager+0xe0>
ffffffffc0205f2c:	1b000593          	li	a1,432
ffffffffc0205f30:	00007517          	auipc	a0,0x7
ffffffffc0205f34:	57850513          	addi	a0,a0,1400 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0205f38:	d66fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205f3c:	00006617          	auipc	a2,0x6
ffffffffc0205f40:	56c60613          	addi	a2,a2,1388 # ffffffffc020c4a8 <default_pmm_manager+0x38>
ffffffffc0205f44:	07100593          	li	a1,113
ffffffffc0205f48:	00006517          	auipc	a0,0x6
ffffffffc0205f4c:	58850513          	addi	a0,a0,1416 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0205f50:	d4efa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205f54:	00006617          	auipc	a2,0x6
ffffffffc0205f58:	62460613          	addi	a2,a2,1572 # ffffffffc020c578 <default_pmm_manager+0x108>
ffffffffc0205f5c:	06900593          	li	a1,105
ffffffffc0205f60:	00006517          	auipc	a0,0x6
ffffffffc0205f64:	57050513          	addi	a0,a0,1392 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0205f68:	d36fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205f6c:	00007697          	auipc	a3,0x7
ffffffffc0205f70:	55468693          	addi	a3,a3,1364 # ffffffffc020d4c0 <CSWTCH.79+0x128>
ffffffffc0205f74:	00006617          	auipc	a2,0x6
ffffffffc0205f78:	a1460613          	addi	a2,a2,-1516 # ffffffffc020b988 <commands+0x210>
ffffffffc0205f7c:	1d000593          	li	a1,464
ffffffffc0205f80:	00007517          	auipc	a0,0x7
ffffffffc0205f84:	52850513          	addi	a0,a0,1320 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0205f88:	d16fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205f8c:	00007697          	auipc	a3,0x7
ffffffffc0205f90:	4fc68693          	addi	a3,a3,1276 # ffffffffc020d488 <CSWTCH.79+0xf0>
ffffffffc0205f94:	00006617          	auipc	a2,0x6
ffffffffc0205f98:	9f460613          	addi	a2,a2,-1548 # ffffffffc020b988 <commands+0x210>
ffffffffc0205f9c:	23500593          	li	a1,565
ffffffffc0205fa0:	00007517          	auipc	a0,0x7
ffffffffc0205fa4:	50850513          	addi	a0,a0,1288 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0205fa8:	cf6fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205fac <kernel_thread>:
ffffffffc0205fac:	7129                	addi	sp,sp,-320
ffffffffc0205fae:	fa22                	sd	s0,304(sp)
ffffffffc0205fb0:	f626                	sd	s1,296(sp)
ffffffffc0205fb2:	f24a                	sd	s2,288(sp)
ffffffffc0205fb4:	84ae                	mv	s1,a1
ffffffffc0205fb6:	892a                	mv	s2,a0
ffffffffc0205fb8:	8432                	mv	s0,a2
ffffffffc0205fba:	4581                	li	a1,0
ffffffffc0205fbc:	12000613          	li	a2,288
ffffffffc0205fc0:	850a                	mv	a0,sp
ffffffffc0205fc2:	fe06                	sd	ra,312(sp)
ffffffffc0205fc4:	4dc050ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0205fc8:	e0ca                	sd	s2,64(sp)
ffffffffc0205fca:	e4a6                	sd	s1,72(sp)
ffffffffc0205fcc:	100027f3          	csrr	a5,sstatus
ffffffffc0205fd0:	edd7f793          	andi	a5,a5,-291
ffffffffc0205fd4:	1207e793          	ori	a5,a5,288
ffffffffc0205fd8:	e23e                	sd	a5,256(sp)
ffffffffc0205fda:	860a                	mv	a2,sp
ffffffffc0205fdc:	10046513          	ori	a0,s0,256
ffffffffc0205fe0:	00000797          	auipc	a5,0x0
ffffffffc0205fe4:	9ec78793          	addi	a5,a5,-1556 # ffffffffc02059cc <kernel_thread_entry>
ffffffffc0205fe8:	4581                	li	a1,0
ffffffffc0205fea:	e63e                	sd	a5,264(sp)
ffffffffc0205fec:	b73ff0ef          	jal	ra,ffffffffc0205b5e <do_fork>
ffffffffc0205ff0:	70f2                	ld	ra,312(sp)
ffffffffc0205ff2:	7452                	ld	s0,304(sp)
ffffffffc0205ff4:	74b2                	ld	s1,296(sp)
ffffffffc0205ff6:	7912                	ld	s2,288(sp)
ffffffffc0205ff8:	6131                	addi	sp,sp,320
ffffffffc0205ffa:	8082                	ret

ffffffffc0205ffc <do_exit>:
ffffffffc0205ffc:	7179                	addi	sp,sp,-48
ffffffffc0205ffe:	f022                	sd	s0,32(sp)
ffffffffc0206000:	00091417          	auipc	s0,0x91
ffffffffc0206004:	8c040413          	addi	s0,s0,-1856 # ffffffffc02968c0 <current>
ffffffffc0206008:	601c                	ld	a5,0(s0)
ffffffffc020600a:	f406                	sd	ra,40(sp)
ffffffffc020600c:	ec26                	sd	s1,24(sp)
ffffffffc020600e:	e84a                	sd	s2,16(sp)
ffffffffc0206010:	e44e                	sd	s3,8(sp)
ffffffffc0206012:	e052                	sd	s4,0(sp)
ffffffffc0206014:	00091717          	auipc	a4,0x91
ffffffffc0206018:	8b473703          	ld	a4,-1868(a4) # ffffffffc02968c8 <idleproc>
ffffffffc020601c:	0ee78763          	beq	a5,a4,ffffffffc020610a <do_exit+0x10e>
ffffffffc0206020:	00091497          	auipc	s1,0x91
ffffffffc0206024:	8b048493          	addi	s1,s1,-1872 # ffffffffc02968d0 <initproc>
ffffffffc0206028:	6098                	ld	a4,0(s1)
ffffffffc020602a:	10e78763          	beq	a5,a4,ffffffffc0206138 <do_exit+0x13c>
ffffffffc020602e:	0287b983          	ld	s3,40(a5)
ffffffffc0206032:	892a                	mv	s2,a0
ffffffffc0206034:	02098e63          	beqz	s3,ffffffffc0206070 <do_exit+0x74>
ffffffffc0206038:	00091797          	auipc	a5,0x91
ffffffffc020603c:	8587b783          	ld	a5,-1960(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0206040:	577d                	li	a4,-1
ffffffffc0206042:	177e                	slli	a4,a4,0x3f
ffffffffc0206044:	83b1                	srli	a5,a5,0xc
ffffffffc0206046:	8fd9                	or	a5,a5,a4
ffffffffc0206048:	18079073          	csrw	satp,a5
ffffffffc020604c:	0309a783          	lw	a5,48(s3)
ffffffffc0206050:	fff7871b          	addiw	a4,a5,-1
ffffffffc0206054:	02e9a823          	sw	a4,48(s3)
ffffffffc0206058:	c769                	beqz	a4,ffffffffc0206122 <do_exit+0x126>
ffffffffc020605a:	601c                	ld	a5,0(s0)
ffffffffc020605c:	1487b503          	ld	a0,328(a5)
ffffffffc0206060:	0207b423          	sd	zero,40(a5)
ffffffffc0206064:	c511                	beqz	a0,ffffffffc0206070 <do_exit+0x74>
ffffffffc0206066:	491c                	lw	a5,16(a0)
ffffffffc0206068:	fff7871b          	addiw	a4,a5,-1
ffffffffc020606c:	c918                	sw	a4,16(a0)
ffffffffc020606e:	cb59                	beqz	a4,ffffffffc0206104 <do_exit+0x108>
ffffffffc0206070:	601c                	ld	a5,0(s0)
ffffffffc0206072:	470d                	li	a4,3
ffffffffc0206074:	c398                	sw	a4,0(a5)
ffffffffc0206076:	0f27a423          	sw	s2,232(a5)
ffffffffc020607a:	100027f3          	csrr	a5,sstatus
ffffffffc020607e:	8b89                	andi	a5,a5,2
ffffffffc0206080:	4a01                	li	s4,0
ffffffffc0206082:	e7f9                	bnez	a5,ffffffffc0206150 <do_exit+0x154>
ffffffffc0206084:	6018                	ld	a4,0(s0)
ffffffffc0206086:	800007b7          	lui	a5,0x80000
ffffffffc020608a:	0785                	addi	a5,a5,1
ffffffffc020608c:	7308                	ld	a0,32(a4)
ffffffffc020608e:	0ec52703          	lw	a4,236(a0)
ffffffffc0206092:	0cf70363          	beq	a4,a5,ffffffffc0206158 <do_exit+0x15c>
ffffffffc0206096:	6018                	ld	a4,0(s0)
ffffffffc0206098:	7b7c                	ld	a5,240(a4)
ffffffffc020609a:	c3a1                	beqz	a5,ffffffffc02060da <do_exit+0xde>
ffffffffc020609c:	800009b7          	lui	s3,0x80000
ffffffffc02060a0:	490d                	li	s2,3
ffffffffc02060a2:	0985                	addi	s3,s3,1
ffffffffc02060a4:	a021                	j	ffffffffc02060ac <do_exit+0xb0>
ffffffffc02060a6:	6018                	ld	a4,0(s0)
ffffffffc02060a8:	7b7c                	ld	a5,240(a4)
ffffffffc02060aa:	cb85                	beqz	a5,ffffffffc02060da <do_exit+0xde>
ffffffffc02060ac:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_bin_sfs_img_size+0xffffffff7ff8ae00>
ffffffffc02060b0:	6088                	ld	a0,0(s1)
ffffffffc02060b2:	fb74                	sd	a3,240(a4)
ffffffffc02060b4:	7978                	ld	a4,240(a0)
ffffffffc02060b6:	0e07bc23          	sd	zero,248(a5)
ffffffffc02060ba:	10e7b023          	sd	a4,256(a5)
ffffffffc02060be:	c311                	beqz	a4,ffffffffc02060c2 <do_exit+0xc6>
ffffffffc02060c0:	ff7c                	sd	a5,248(a4)
ffffffffc02060c2:	4398                	lw	a4,0(a5)
ffffffffc02060c4:	f388                	sd	a0,32(a5)
ffffffffc02060c6:	f97c                	sd	a5,240(a0)
ffffffffc02060c8:	fd271fe3          	bne	a4,s2,ffffffffc02060a6 <do_exit+0xaa>
ffffffffc02060cc:	0ec52783          	lw	a5,236(a0)
ffffffffc02060d0:	fd379be3          	bne	a5,s3,ffffffffc02060a6 <do_exit+0xaa>
ffffffffc02060d4:	1a4010ef          	jal	ra,ffffffffc0207278 <wakeup_proc>
ffffffffc02060d8:	b7f9                	j	ffffffffc02060a6 <do_exit+0xaa>
ffffffffc02060da:	020a1263          	bnez	s4,ffffffffc02060fe <do_exit+0x102>
ffffffffc02060de:	24c010ef          	jal	ra,ffffffffc020732a <schedule>
ffffffffc02060e2:	601c                	ld	a5,0(s0)
ffffffffc02060e4:	00007617          	auipc	a2,0x7
ffffffffc02060e8:	41460613          	addi	a2,a2,1044 # ffffffffc020d4f8 <CSWTCH.79+0x160>
ffffffffc02060ec:	2a300593          	li	a1,675
ffffffffc02060f0:	43d4                	lw	a3,4(a5)
ffffffffc02060f2:	00007517          	auipc	a0,0x7
ffffffffc02060f6:	3b650513          	addi	a0,a0,950 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc02060fa:	ba4fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02060fe:	b6ffa0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0206102:	bff1                	j	ffffffffc02060de <do_exit+0xe2>
ffffffffc0206104:	900ff0ef          	jal	ra,ffffffffc0205204 <files_destroy>
ffffffffc0206108:	b7a5                	j	ffffffffc0206070 <do_exit+0x74>
ffffffffc020610a:	00007617          	auipc	a2,0x7
ffffffffc020610e:	3ce60613          	addi	a2,a2,974 # ffffffffc020d4d8 <CSWTCH.79+0x140>
ffffffffc0206112:	26e00593          	li	a1,622
ffffffffc0206116:	00007517          	auipc	a0,0x7
ffffffffc020611a:	39250513          	addi	a0,a0,914 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc020611e:	b80fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206122:	854e                	mv	a0,s3
ffffffffc0206124:	dcffd0ef          	jal	ra,ffffffffc0203ef2 <exit_mmap>
ffffffffc0206128:	0189b503          	ld	a0,24(s3) # ffffffff80000018 <_binary_bin_sfs_img_size+0xffffffff7ff8ad18>
ffffffffc020612c:	94dff0ef          	jal	ra,ffffffffc0205a78 <put_pgdir.isra.0>
ffffffffc0206130:	854e                	mv	a0,s3
ffffffffc0206132:	c25fd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc0206136:	b715                	j	ffffffffc020605a <do_exit+0x5e>
ffffffffc0206138:	00007617          	auipc	a2,0x7
ffffffffc020613c:	3b060613          	addi	a2,a2,944 # ffffffffc020d4e8 <CSWTCH.79+0x150>
ffffffffc0206140:	27200593          	li	a1,626
ffffffffc0206144:	00007517          	auipc	a0,0x7
ffffffffc0206148:	36450513          	addi	a0,a0,868 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc020614c:	b52fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206150:	b23fa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0206154:	4a05                	li	s4,1
ffffffffc0206156:	b73d                	j	ffffffffc0206084 <do_exit+0x88>
ffffffffc0206158:	120010ef          	jal	ra,ffffffffc0207278 <wakeup_proc>
ffffffffc020615c:	bf2d                	j	ffffffffc0206096 <do_exit+0x9a>

ffffffffc020615e <do_wait.part.0>:
ffffffffc020615e:	715d                	addi	sp,sp,-80
ffffffffc0206160:	f84a                	sd	s2,48(sp)
ffffffffc0206162:	f44e                	sd	s3,40(sp)
ffffffffc0206164:	80000937          	lui	s2,0x80000
ffffffffc0206168:	6989                	lui	s3,0x2
ffffffffc020616a:	fc26                	sd	s1,56(sp)
ffffffffc020616c:	f052                	sd	s4,32(sp)
ffffffffc020616e:	ec56                	sd	s5,24(sp)
ffffffffc0206170:	e85a                	sd	s6,16(sp)
ffffffffc0206172:	e45e                	sd	s7,8(sp)
ffffffffc0206174:	e486                	sd	ra,72(sp)
ffffffffc0206176:	e0a2                	sd	s0,64(sp)
ffffffffc0206178:	84aa                	mv	s1,a0
ffffffffc020617a:	8a2e                	mv	s4,a1
ffffffffc020617c:	00090b97          	auipc	s7,0x90
ffffffffc0206180:	744b8b93          	addi	s7,s7,1860 # ffffffffc02968c0 <current>
ffffffffc0206184:	00050b1b          	sext.w	s6,a0
ffffffffc0206188:	fff50a9b          	addiw	s5,a0,-1
ffffffffc020618c:	19f9                	addi	s3,s3,-2
ffffffffc020618e:	0905                	addi	s2,s2,1
ffffffffc0206190:	ccbd                	beqz	s1,ffffffffc020620e <do_wait.part.0+0xb0>
ffffffffc0206192:	0359e863          	bltu	s3,s5,ffffffffc02061c2 <do_wait.part.0+0x64>
ffffffffc0206196:	45a9                	li	a1,10
ffffffffc0206198:	855a                	mv	a0,s6
ffffffffc020619a:	5d3040ef          	jal	ra,ffffffffc020af6c <hash32>
ffffffffc020619e:	02051793          	slli	a5,a0,0x20
ffffffffc02061a2:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02061a6:	0008b797          	auipc	a5,0x8b
ffffffffc02061aa:	61a78793          	addi	a5,a5,1562 # ffffffffc02917c0 <hash_list>
ffffffffc02061ae:	953e                	add	a0,a0,a5
ffffffffc02061b0:	842a                	mv	s0,a0
ffffffffc02061b2:	a029                	j	ffffffffc02061bc <do_wait.part.0+0x5e>
ffffffffc02061b4:	f2c42783          	lw	a5,-212(s0)
ffffffffc02061b8:	02978163          	beq	a5,s1,ffffffffc02061da <do_wait.part.0+0x7c>
ffffffffc02061bc:	6400                	ld	s0,8(s0)
ffffffffc02061be:	fe851be3          	bne	a0,s0,ffffffffc02061b4 <do_wait.part.0+0x56>
ffffffffc02061c2:	5579                	li	a0,-2
ffffffffc02061c4:	60a6                	ld	ra,72(sp)
ffffffffc02061c6:	6406                	ld	s0,64(sp)
ffffffffc02061c8:	74e2                	ld	s1,56(sp)
ffffffffc02061ca:	7942                	ld	s2,48(sp)
ffffffffc02061cc:	79a2                	ld	s3,40(sp)
ffffffffc02061ce:	7a02                	ld	s4,32(sp)
ffffffffc02061d0:	6ae2                	ld	s5,24(sp)
ffffffffc02061d2:	6b42                	ld	s6,16(sp)
ffffffffc02061d4:	6ba2                	ld	s7,8(sp)
ffffffffc02061d6:	6161                	addi	sp,sp,80
ffffffffc02061d8:	8082                	ret
ffffffffc02061da:	000bb683          	ld	a3,0(s7)
ffffffffc02061de:	f4843783          	ld	a5,-184(s0)
ffffffffc02061e2:	fed790e3          	bne	a5,a3,ffffffffc02061c2 <do_wait.part.0+0x64>
ffffffffc02061e6:	f2842703          	lw	a4,-216(s0)
ffffffffc02061ea:	478d                	li	a5,3
ffffffffc02061ec:	0ef70b63          	beq	a4,a5,ffffffffc02062e2 <do_wait.part.0+0x184>
ffffffffc02061f0:	4785                	li	a5,1
ffffffffc02061f2:	c29c                	sw	a5,0(a3)
ffffffffc02061f4:	0f26a623          	sw	s2,236(a3)
ffffffffc02061f8:	132010ef          	jal	ra,ffffffffc020732a <schedule>
ffffffffc02061fc:	000bb783          	ld	a5,0(s7)
ffffffffc0206200:	0b07a783          	lw	a5,176(a5)
ffffffffc0206204:	8b85                	andi	a5,a5,1
ffffffffc0206206:	d7c9                	beqz	a5,ffffffffc0206190 <do_wait.part.0+0x32>
ffffffffc0206208:	555d                	li	a0,-9
ffffffffc020620a:	df3ff0ef          	jal	ra,ffffffffc0205ffc <do_exit>
ffffffffc020620e:	000bb683          	ld	a3,0(s7)
ffffffffc0206212:	7ae0                	ld	s0,240(a3)
ffffffffc0206214:	d45d                	beqz	s0,ffffffffc02061c2 <do_wait.part.0+0x64>
ffffffffc0206216:	470d                	li	a4,3
ffffffffc0206218:	a021                	j	ffffffffc0206220 <do_wait.part.0+0xc2>
ffffffffc020621a:	10043403          	ld	s0,256(s0)
ffffffffc020621e:	d869                	beqz	s0,ffffffffc02061f0 <do_wait.part.0+0x92>
ffffffffc0206220:	401c                	lw	a5,0(s0)
ffffffffc0206222:	fee79ce3          	bne	a5,a4,ffffffffc020621a <do_wait.part.0+0xbc>
ffffffffc0206226:	00090797          	auipc	a5,0x90
ffffffffc020622a:	6a27b783          	ld	a5,1698(a5) # ffffffffc02968c8 <idleproc>
ffffffffc020622e:	0c878963          	beq	a5,s0,ffffffffc0206300 <do_wait.part.0+0x1a2>
ffffffffc0206232:	00090797          	auipc	a5,0x90
ffffffffc0206236:	69e7b783          	ld	a5,1694(a5) # ffffffffc02968d0 <initproc>
ffffffffc020623a:	0cf40363          	beq	s0,a5,ffffffffc0206300 <do_wait.part.0+0x1a2>
ffffffffc020623e:	000a0663          	beqz	s4,ffffffffc020624a <do_wait.part.0+0xec>
ffffffffc0206242:	0e842783          	lw	a5,232(s0)
ffffffffc0206246:	00fa2023          	sw	a5,0(s4)
ffffffffc020624a:	100027f3          	csrr	a5,sstatus
ffffffffc020624e:	8b89                	andi	a5,a5,2
ffffffffc0206250:	4581                	li	a1,0
ffffffffc0206252:	e7c1                	bnez	a5,ffffffffc02062da <do_wait.part.0+0x17c>
ffffffffc0206254:	6c70                	ld	a2,216(s0)
ffffffffc0206256:	7074                	ld	a3,224(s0)
ffffffffc0206258:	10043703          	ld	a4,256(s0)
ffffffffc020625c:	7c7c                	ld	a5,248(s0)
ffffffffc020625e:	e614                	sd	a3,8(a2)
ffffffffc0206260:	e290                	sd	a2,0(a3)
ffffffffc0206262:	6470                	ld	a2,200(s0)
ffffffffc0206264:	6874                	ld	a3,208(s0)
ffffffffc0206266:	e614                	sd	a3,8(a2)
ffffffffc0206268:	e290                	sd	a2,0(a3)
ffffffffc020626a:	c319                	beqz	a4,ffffffffc0206270 <do_wait.part.0+0x112>
ffffffffc020626c:	ff7c                	sd	a5,248(a4)
ffffffffc020626e:	7c7c                	ld	a5,248(s0)
ffffffffc0206270:	c3b5                	beqz	a5,ffffffffc02062d4 <do_wait.part.0+0x176>
ffffffffc0206272:	10e7b023          	sd	a4,256(a5)
ffffffffc0206276:	00090717          	auipc	a4,0x90
ffffffffc020627a:	66270713          	addi	a4,a4,1634 # ffffffffc02968d8 <nr_process>
ffffffffc020627e:	431c                	lw	a5,0(a4)
ffffffffc0206280:	37fd                	addiw	a5,a5,-1
ffffffffc0206282:	c31c                	sw	a5,0(a4)
ffffffffc0206284:	e5a9                	bnez	a1,ffffffffc02062ce <do_wait.part.0+0x170>
ffffffffc0206286:	6814                	ld	a3,16(s0)
ffffffffc0206288:	c02007b7          	lui	a5,0xc0200
ffffffffc020628c:	04f6ee63          	bltu	a3,a5,ffffffffc02062e8 <do_wait.part.0+0x18a>
ffffffffc0206290:	00090797          	auipc	a5,0x90
ffffffffc0206294:	6287b783          	ld	a5,1576(a5) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206298:	8e9d                	sub	a3,a3,a5
ffffffffc020629a:	82b1                	srli	a3,a3,0xc
ffffffffc020629c:	00090797          	auipc	a5,0x90
ffffffffc02062a0:	6047b783          	ld	a5,1540(a5) # ffffffffc02968a0 <npage>
ffffffffc02062a4:	06f6fa63          	bgeu	a3,a5,ffffffffc0206318 <do_wait.part.0+0x1ba>
ffffffffc02062a8:	00009517          	auipc	a0,0x9
ffffffffc02062ac:	51053503          	ld	a0,1296(a0) # ffffffffc020f7b8 <nbase>
ffffffffc02062b0:	8e89                	sub	a3,a3,a0
ffffffffc02062b2:	069a                	slli	a3,a3,0x6
ffffffffc02062b4:	00090517          	auipc	a0,0x90
ffffffffc02062b8:	5f453503          	ld	a0,1524(a0) # ffffffffc02968a8 <pages>
ffffffffc02062bc:	9536                	add	a0,a0,a3
ffffffffc02062be:	4589                	li	a1,2
ffffffffc02062c0:	eebfb0ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02062c4:	8522                	mv	a0,s0
ffffffffc02062c6:	d79fb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02062ca:	4501                	li	a0,0
ffffffffc02062cc:	bde5                	j	ffffffffc02061c4 <do_wait.part.0+0x66>
ffffffffc02062ce:	99ffa0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02062d2:	bf55                	j	ffffffffc0206286 <do_wait.part.0+0x128>
ffffffffc02062d4:	701c                	ld	a5,32(s0)
ffffffffc02062d6:	fbf8                	sd	a4,240(a5)
ffffffffc02062d8:	bf79                	j	ffffffffc0206276 <do_wait.part.0+0x118>
ffffffffc02062da:	999fa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02062de:	4585                	li	a1,1
ffffffffc02062e0:	bf95                	j	ffffffffc0206254 <do_wait.part.0+0xf6>
ffffffffc02062e2:	f2840413          	addi	s0,s0,-216
ffffffffc02062e6:	b781                	j	ffffffffc0206226 <do_wait.part.0+0xc8>
ffffffffc02062e8:	00006617          	auipc	a2,0x6
ffffffffc02062ec:	26860613          	addi	a2,a2,616 # ffffffffc020c550 <default_pmm_manager+0xe0>
ffffffffc02062f0:	07700593          	li	a1,119
ffffffffc02062f4:	00006517          	auipc	a0,0x6
ffffffffc02062f8:	1dc50513          	addi	a0,a0,476 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc02062fc:	9a2fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206300:	00007617          	auipc	a2,0x7
ffffffffc0206304:	21860613          	addi	a2,a2,536 # ffffffffc020d518 <CSWTCH.79+0x180>
ffffffffc0206308:	42c00593          	li	a1,1068
ffffffffc020630c:	00007517          	auipc	a0,0x7
ffffffffc0206310:	19c50513          	addi	a0,a0,412 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0206314:	98afa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206318:	00006617          	auipc	a2,0x6
ffffffffc020631c:	26060613          	addi	a2,a2,608 # ffffffffc020c578 <default_pmm_manager+0x108>
ffffffffc0206320:	06900593          	li	a1,105
ffffffffc0206324:	00006517          	auipc	a0,0x6
ffffffffc0206328:	1ac50513          	addi	a0,a0,428 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc020632c:	972fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0206330 <init_main>:
ffffffffc0206330:	1141                	addi	sp,sp,-16
ffffffffc0206332:	00007517          	auipc	a0,0x7
ffffffffc0206336:	20650513          	addi	a0,a0,518 # ffffffffc020d538 <CSWTCH.79+0x1a0>
ffffffffc020633a:	e406                	sd	ra,8(sp)
ffffffffc020633c:	75e010ef          	jal	ra,ffffffffc0207a9a <vfs_set_bootfs>
ffffffffc0206340:	e179                	bnez	a0,ffffffffc0206406 <init_main+0xd6>
ffffffffc0206342:	ea9fb0ef          	jal	ra,ffffffffc02021ea <nr_free_pages>
ffffffffc0206346:	c45fb0ef          	jal	ra,ffffffffc0201f8a <kallocated>
ffffffffc020634a:	4601                	li	a2,0
ffffffffc020634c:	4581                	li	a1,0
ffffffffc020634e:	00001517          	auipc	a0,0x1
ffffffffc0206352:	98450513          	addi	a0,a0,-1660 # ffffffffc0206cd2 <user_main>
ffffffffc0206356:	c57ff0ef          	jal	ra,ffffffffc0205fac <kernel_thread>
ffffffffc020635a:	00a04563          	bgtz	a0,ffffffffc0206364 <init_main+0x34>
ffffffffc020635e:	a841                	j	ffffffffc02063ee <init_main+0xbe>
ffffffffc0206360:	7cb000ef          	jal	ra,ffffffffc020732a <schedule>
ffffffffc0206364:	4581                	li	a1,0
ffffffffc0206366:	4501                	li	a0,0
ffffffffc0206368:	df7ff0ef          	jal	ra,ffffffffc020615e <do_wait.part.0>
ffffffffc020636c:	d975                	beqz	a0,ffffffffc0206360 <init_main+0x30>
ffffffffc020636e:	e51fe0ef          	jal	ra,ffffffffc02051be <fs_cleanup>
ffffffffc0206372:	00007517          	auipc	a0,0x7
ffffffffc0206376:	20e50513          	addi	a0,a0,526 # ffffffffc020d580 <CSWTCH.79+0x1e8>
ffffffffc020637a:	e2df90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020637e:	00090797          	auipc	a5,0x90
ffffffffc0206382:	5527b783          	ld	a5,1362(a5) # ffffffffc02968d0 <initproc>
ffffffffc0206386:	7bf8                	ld	a4,240(a5)
ffffffffc0206388:	e339                	bnez	a4,ffffffffc02063ce <init_main+0x9e>
ffffffffc020638a:	7ff8                	ld	a4,248(a5)
ffffffffc020638c:	e329                	bnez	a4,ffffffffc02063ce <init_main+0x9e>
ffffffffc020638e:	1007b703          	ld	a4,256(a5)
ffffffffc0206392:	ef15                	bnez	a4,ffffffffc02063ce <init_main+0x9e>
ffffffffc0206394:	00090697          	auipc	a3,0x90
ffffffffc0206398:	5446a683          	lw	a3,1348(a3) # ffffffffc02968d8 <nr_process>
ffffffffc020639c:	4709                	li	a4,2
ffffffffc020639e:	0ce69163          	bne	a3,a4,ffffffffc0206460 <init_main+0x130>
ffffffffc02063a2:	0008f717          	auipc	a4,0x8f
ffffffffc02063a6:	41e70713          	addi	a4,a4,1054 # ffffffffc02957c0 <proc_list>
ffffffffc02063aa:	6714                	ld	a3,8(a4)
ffffffffc02063ac:	0c878793          	addi	a5,a5,200
ffffffffc02063b0:	08d79863          	bne	a5,a3,ffffffffc0206440 <init_main+0x110>
ffffffffc02063b4:	6318                	ld	a4,0(a4)
ffffffffc02063b6:	06e79563          	bne	a5,a4,ffffffffc0206420 <init_main+0xf0>
ffffffffc02063ba:	00007517          	auipc	a0,0x7
ffffffffc02063be:	2ae50513          	addi	a0,a0,686 # ffffffffc020d668 <CSWTCH.79+0x2d0>
ffffffffc02063c2:	de5f90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02063c6:	60a2                	ld	ra,8(sp)
ffffffffc02063c8:	4501                	li	a0,0
ffffffffc02063ca:	0141                	addi	sp,sp,16
ffffffffc02063cc:	8082                	ret
ffffffffc02063ce:	00007697          	auipc	a3,0x7
ffffffffc02063d2:	1da68693          	addi	a3,a3,474 # ffffffffc020d5a8 <CSWTCH.79+0x210>
ffffffffc02063d6:	00005617          	auipc	a2,0x5
ffffffffc02063da:	5b260613          	addi	a2,a2,1458 # ffffffffc020b988 <commands+0x210>
ffffffffc02063de:	4a200593          	li	a1,1186
ffffffffc02063e2:	00007517          	auipc	a0,0x7
ffffffffc02063e6:	0c650513          	addi	a0,a0,198 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc02063ea:	8b4fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02063ee:	00007617          	auipc	a2,0x7
ffffffffc02063f2:	17260613          	addi	a2,a2,370 # ffffffffc020d560 <CSWTCH.79+0x1c8>
ffffffffc02063f6:	49500593          	li	a1,1173
ffffffffc02063fa:	00007517          	auipc	a0,0x7
ffffffffc02063fe:	0ae50513          	addi	a0,a0,174 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0206402:	89cfa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206406:	86aa                	mv	a3,a0
ffffffffc0206408:	00007617          	auipc	a2,0x7
ffffffffc020640c:	13860613          	addi	a2,a2,312 # ffffffffc020d540 <CSWTCH.79+0x1a8>
ffffffffc0206410:	48d00593          	li	a1,1165
ffffffffc0206414:	00007517          	auipc	a0,0x7
ffffffffc0206418:	09450513          	addi	a0,a0,148 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc020641c:	882fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206420:	00007697          	auipc	a3,0x7
ffffffffc0206424:	21868693          	addi	a3,a3,536 # ffffffffc020d638 <CSWTCH.79+0x2a0>
ffffffffc0206428:	00005617          	auipc	a2,0x5
ffffffffc020642c:	56060613          	addi	a2,a2,1376 # ffffffffc020b988 <commands+0x210>
ffffffffc0206430:	4a500593          	li	a1,1189
ffffffffc0206434:	00007517          	auipc	a0,0x7
ffffffffc0206438:	07450513          	addi	a0,a0,116 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc020643c:	862fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206440:	00007697          	auipc	a3,0x7
ffffffffc0206444:	1c868693          	addi	a3,a3,456 # ffffffffc020d608 <CSWTCH.79+0x270>
ffffffffc0206448:	00005617          	auipc	a2,0x5
ffffffffc020644c:	54060613          	addi	a2,a2,1344 # ffffffffc020b988 <commands+0x210>
ffffffffc0206450:	4a400593          	li	a1,1188
ffffffffc0206454:	00007517          	auipc	a0,0x7
ffffffffc0206458:	05450513          	addi	a0,a0,84 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc020645c:	842fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206460:	00007697          	auipc	a3,0x7
ffffffffc0206464:	19868693          	addi	a3,a3,408 # ffffffffc020d5f8 <CSWTCH.79+0x260>
ffffffffc0206468:	00005617          	auipc	a2,0x5
ffffffffc020646c:	52060613          	addi	a2,a2,1312 # ffffffffc020b988 <commands+0x210>
ffffffffc0206470:	4a300593          	li	a1,1187
ffffffffc0206474:	00007517          	auipc	a0,0x7
ffffffffc0206478:	03450513          	addi	a0,a0,52 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc020647c:	822fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0206480 <do_execve>:
ffffffffc0206480:	c9010113          	addi	sp,sp,-880
ffffffffc0206484:	33513c23          	sd	s5,824(sp)
ffffffffc0206488:	00090a97          	auipc	s5,0x90
ffffffffc020648c:	438a8a93          	addi	s5,s5,1080 # ffffffffc02968c0 <current>
ffffffffc0206490:	000ab683          	ld	a3,0(s5)
ffffffffc0206494:	fff5871b          	addiw	a4,a1,-1
ffffffffc0206498:	33713423          	sd	s7,808(sp)
ffffffffc020649c:	36113423          	sd	ra,872(sp)
ffffffffc02064a0:	36813023          	sd	s0,864(sp)
ffffffffc02064a4:	34913c23          	sd	s1,856(sp)
ffffffffc02064a8:	35213823          	sd	s2,848(sp)
ffffffffc02064ac:	35313423          	sd	s3,840(sp)
ffffffffc02064b0:	35413023          	sd	s4,832(sp)
ffffffffc02064b4:	33613823          	sd	s6,816(sp)
ffffffffc02064b8:	33813023          	sd	s8,800(sp)
ffffffffc02064bc:	31913c23          	sd	s9,792(sp)
ffffffffc02064c0:	31a13823          	sd	s10,784(sp)
ffffffffc02064c4:	31b13423          	sd	s11,776(sp)
ffffffffc02064c8:	c83a                	sw	a4,16(sp)
ffffffffc02064ca:	47fd                	li	a5,31
ffffffffc02064cc:	0286bb83          	ld	s7,40(a3)
ffffffffc02064d0:	5ee7ea63          	bltu	a5,a4,ffffffffc0206ac4 <do_execve+0x644>
ffffffffc02064d4:	842e                	mv	s0,a1
ffffffffc02064d6:	84aa                	mv	s1,a0
ffffffffc02064d8:	8b32                	mv	s6,a2
ffffffffc02064da:	4581                	li	a1,0
ffffffffc02064dc:	4641                	li	a2,16
ffffffffc02064de:	1888                	addi	a0,sp,112
ffffffffc02064e0:	7c1040ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc02064e4:	000b8c63          	beqz	s7,ffffffffc02064fc <do_execve+0x7c>
ffffffffc02064e8:	038b8513          	addi	a0,s7,56
ffffffffc02064ec:	878fe0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc02064f0:	000ab783          	ld	a5,0(s5)
ffffffffc02064f4:	c781                	beqz	a5,ffffffffc02064fc <do_execve+0x7c>
ffffffffc02064f6:	43dc                	lw	a5,4(a5)
ffffffffc02064f8:	04fba823          	sw	a5,80(s7)
ffffffffc02064fc:	24048263          	beqz	s1,ffffffffc0206740 <do_execve+0x2c0>
ffffffffc0206500:	46c1                	li	a3,16
ffffffffc0206502:	8626                	mv	a2,s1
ffffffffc0206504:	188c                	addi	a1,sp,112
ffffffffc0206506:	855e                	mv	a0,s7
ffffffffc0206508:	e85fd0ef          	jal	ra,ffffffffc020438c <copy_string>
ffffffffc020650c:	6a050963          	beqz	a0,ffffffffc0206bbe <do_execve+0x73e>
ffffffffc0206510:	00341d93          	slli	s11,s0,0x3
ffffffffc0206514:	4681                	li	a3,0
ffffffffc0206516:	866e                	mv	a2,s11
ffffffffc0206518:	85da                	mv	a1,s6
ffffffffc020651a:	855e                	mv	a0,s7
ffffffffc020651c:	d77fd0ef          	jal	ra,ffffffffc0204292 <user_mem_check>
ffffffffc0206520:	89da                	mv	s3,s6
ffffffffc0206522:	68050a63          	beqz	a0,ffffffffc0206bb6 <do_execve+0x736>
ffffffffc0206526:	0f810a13          	addi	s4,sp,248
ffffffffc020652a:	4481                	li	s1,0
ffffffffc020652c:	a011                	j	ffffffffc0206530 <do_execve+0xb0>
ffffffffc020652e:	84e2                	mv	s1,s8
ffffffffc0206530:	6505                	lui	a0,0x1
ffffffffc0206532:	a5dfb0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0206536:	892a                	mv	s2,a0
ffffffffc0206538:	18050163          	beqz	a0,ffffffffc02066ba <do_execve+0x23a>
ffffffffc020653c:	0009b603          	ld	a2,0(s3) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc0206540:	85aa                	mv	a1,a0
ffffffffc0206542:	6685                	lui	a3,0x1
ffffffffc0206544:	855e                	mv	a0,s7
ffffffffc0206546:	e47fd0ef          	jal	ra,ffffffffc020438c <copy_string>
ffffffffc020654a:	1e050663          	beqz	a0,ffffffffc0206736 <do_execve+0x2b6>
ffffffffc020654e:	012a3023          	sd	s2,0(s4)
ffffffffc0206552:	00148c1b          	addiw	s8,s1,1
ffffffffc0206556:	0a21                	addi	s4,s4,8
ffffffffc0206558:	09a1                	addi	s3,s3,8
ffffffffc020655a:	fd841ae3          	bne	s0,s8,ffffffffc020652e <do_execve+0xae>
ffffffffc020655e:	000b3903          	ld	s2,0(s6)
ffffffffc0206562:	100b8963          	beqz	s7,ffffffffc0206674 <do_execve+0x1f4>
ffffffffc0206566:	038b8513          	addi	a0,s7,56
ffffffffc020656a:	ff7fd0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020656e:	000ab703          	ld	a4,0(s5)
ffffffffc0206572:	040ba823          	sw	zero,80(s7)
ffffffffc0206576:	14873503          	ld	a0,328(a4)
ffffffffc020657a:	d21fe0ef          	jal	ra,ffffffffc020529a <files_closeall>
ffffffffc020657e:	854a                	mv	a0,s2
ffffffffc0206580:	4581                	li	a1,0
ffffffffc0206582:	fa5fe0ef          	jal	ra,ffffffffc0205526 <sysfile_open>
ffffffffc0206586:	892a                	mv	s2,a0
ffffffffc0206588:	0c054163          	bltz	a0,ffffffffc020664a <do_execve+0x1ca>
ffffffffc020658c:	00090717          	auipc	a4,0x90
ffffffffc0206590:	30473703          	ld	a4,772(a4) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0206594:	56fd                	li	a3,-1
ffffffffc0206596:	16fe                	slli	a3,a3,0x3f
ffffffffc0206598:	8331                	srli	a4,a4,0xc
ffffffffc020659a:	8f55                	or	a4,a4,a3
ffffffffc020659c:	18071073          	csrw	satp,a4
ffffffffc02065a0:	030ba703          	lw	a4,48(s7)
ffffffffc02065a4:	fff7069b          	addiw	a3,a4,-1
ffffffffc02065a8:	02dba823          	sw	a3,48(s7)
ffffffffc02065ac:	1a068663          	beqz	a3,ffffffffc0206758 <do_execve+0x2d8>
ffffffffc02065b0:	000ab703          	ld	a4,0(s5)
ffffffffc02065b4:	02073423          	sd	zero,40(a4)
ffffffffc02065b8:	e50fd0ef          	jal	ra,ffffffffc0203c08 <mm_create>
ffffffffc02065bc:	89aa                	mv	s3,a0
ffffffffc02065be:	0e050c63          	beqz	a0,ffffffffc02066b6 <do_execve+0x236>
ffffffffc02065c2:	4505                	li	a0,1
ffffffffc02065c4:	ba9fb0ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02065c8:	0e050463          	beqz	a0,ffffffffc02066b0 <do_execve+0x230>
ffffffffc02065cc:	00090c97          	auipc	s9,0x90
ffffffffc02065d0:	2dcc8c93          	addi	s9,s9,732 # ffffffffc02968a8 <pages>
ffffffffc02065d4:	000cb683          	ld	a3,0(s9)
ffffffffc02065d8:	00090d17          	auipc	s10,0x90
ffffffffc02065dc:	2c8d0d13          	addi	s10,s10,712 # ffffffffc02968a0 <npage>
ffffffffc02065e0:	00009797          	auipc	a5,0x9
ffffffffc02065e4:	1d87b783          	ld	a5,472(a5) # ffffffffc020f7b8 <nbase>
ffffffffc02065e8:	40d506b3          	sub	a3,a0,a3
ffffffffc02065ec:	567d                	li	a2,-1
ffffffffc02065ee:	8699                	srai	a3,a3,0x6
ffffffffc02065f0:	000d3703          	ld	a4,0(s10)
ffffffffc02065f4:	96be                	add	a3,a3,a5
ffffffffc02065f6:	f03e                	sd	a5,32(sp)
ffffffffc02065f8:	00c65793          	srli	a5,a2,0xc
ffffffffc02065fc:	00f6f633          	and	a2,a3,a5
ffffffffc0206600:	e43e                	sd	a5,8(sp)
ffffffffc0206602:	06b2                	slli	a3,a3,0xc
ffffffffc0206604:	60e67e63          	bgeu	a2,a4,ffffffffc0206c20 <do_execve+0x7a0>
ffffffffc0206608:	00090797          	auipc	a5,0x90
ffffffffc020660c:	2b078793          	addi	a5,a5,688 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206610:	0007ba03          	ld	s4,0(a5)
ffffffffc0206614:	6605                	lui	a2,0x1
ffffffffc0206616:	00090597          	auipc	a1,0x90
ffffffffc020661a:	2825b583          	ld	a1,642(a1) # ffffffffc0296898 <boot_pgdir_va>
ffffffffc020661e:	9a36                	add	s4,s4,a3
ffffffffc0206620:	8552                	mv	a0,s4
ffffffffc0206622:	6d1040ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc0206626:	4601                	li	a2,0
ffffffffc0206628:	0149bc23          	sd	s4,24(s3)
ffffffffc020662c:	4581                	li	a1,0
ffffffffc020662e:	854a                	mv	a0,s2
ffffffffc0206630:	95cff0ef          	jal	ra,ffffffffc020578c <sysfile_seek>
ffffffffc0206634:	8b2a                	mv	s6,a0
ffffffffc0206636:	12050c63          	beqz	a0,ffffffffc020676e <do_execve+0x2ee>
ffffffffc020663a:	0189b503          	ld	a0,24(s3)
ffffffffc020663e:	895a                	mv	s2,s6
ffffffffc0206640:	c38ff0ef          	jal	ra,ffffffffc0205a78 <put_pgdir.isra.0>
ffffffffc0206644:	854e                	mv	a0,s3
ffffffffc0206646:	f10fd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc020664a:	67c2                	ld	a5,16(sp)
ffffffffc020664c:	147d                	addi	s0,s0,-1
ffffffffc020664e:	11a4                	addi	s1,sp,232
ffffffffc0206650:	02079713          	slli	a4,a5,0x20
ffffffffc0206654:	01d75793          	srli	a5,a4,0x1d
ffffffffc0206658:	040e                	slli	s0,s0,0x3
ffffffffc020665a:	94ee                	add	s1,s1,s11
ffffffffc020665c:	19b8                	addi	a4,sp,248
ffffffffc020665e:	943a                	add	s0,s0,a4
ffffffffc0206660:	8c9d                	sub	s1,s1,a5
ffffffffc0206662:	6008                	ld	a0,0(s0)
ffffffffc0206664:	1461                	addi	s0,s0,-8
ffffffffc0206666:	9d9fb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020666a:	fe941ce3          	bne	s0,s1,ffffffffc0206662 <do_execve+0x1e2>
ffffffffc020666e:	854a                	mv	a0,s2
ffffffffc0206670:	98dff0ef          	jal	ra,ffffffffc0205ffc <do_exit>
ffffffffc0206674:	000ab703          	ld	a4,0(s5)
ffffffffc0206678:	14873503          	ld	a0,328(a4)
ffffffffc020667c:	c1ffe0ef          	jal	ra,ffffffffc020529a <files_closeall>
ffffffffc0206680:	854a                	mv	a0,s2
ffffffffc0206682:	4581                	li	a1,0
ffffffffc0206684:	ea3fe0ef          	jal	ra,ffffffffc0205526 <sysfile_open>
ffffffffc0206688:	892a                	mv	s2,a0
ffffffffc020668a:	fc0540e3          	bltz	a0,ffffffffc020664a <do_execve+0x1ca>
ffffffffc020668e:	000ab703          	ld	a4,0(s5)
ffffffffc0206692:	7718                	ld	a4,40(a4)
ffffffffc0206694:	f20702e3          	beqz	a4,ffffffffc02065b8 <do_execve+0x138>
ffffffffc0206698:	00007617          	auipc	a2,0x7
ffffffffc020669c:	00060613          	mv	a2,a2
ffffffffc02066a0:	2d600593          	li	a1,726
ffffffffc02066a4:	00007517          	auipc	a0,0x7
ffffffffc02066a8:	e0450513          	addi	a0,a0,-508 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc02066ac:	df3f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02066b0:	854e                	mv	a0,s3
ffffffffc02066b2:	ea4fd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc02066b6:	5971                	li	s2,-4
ffffffffc02066b8:	bf49                	j	ffffffffc020664a <do_execve+0x1ca>
ffffffffc02066ba:	5b71                	li	s6,-4
ffffffffc02066bc:	c49d                	beqz	s1,ffffffffc02066ea <do_execve+0x26a>
ffffffffc02066be:	00349713          	slli	a4,s1,0x3
ffffffffc02066c2:	fff48413          	addi	s0,s1,-1
ffffffffc02066c6:	11bc                	addi	a5,sp,232
ffffffffc02066c8:	34fd                	addiw	s1,s1,-1
ffffffffc02066ca:	97ba                	add	a5,a5,a4
ffffffffc02066cc:	02049713          	slli	a4,s1,0x20
ffffffffc02066d0:	01d75493          	srli	s1,a4,0x1d
ffffffffc02066d4:	040e                	slli	s0,s0,0x3
ffffffffc02066d6:	19b8                	addi	a4,sp,248
ffffffffc02066d8:	943a                	add	s0,s0,a4
ffffffffc02066da:	409784b3          	sub	s1,a5,s1
ffffffffc02066de:	6008                	ld	a0,0(s0)
ffffffffc02066e0:	1461                	addi	s0,s0,-8
ffffffffc02066e2:	95dfb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02066e6:	fe849ce3          	bne	s1,s0,ffffffffc02066de <do_execve+0x25e>
ffffffffc02066ea:	000b8863          	beqz	s7,ffffffffc02066fa <do_execve+0x27a>
ffffffffc02066ee:	038b8513          	addi	a0,s7,56
ffffffffc02066f2:	e6ffd0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc02066f6:	040ba823          	sw	zero,80(s7)
ffffffffc02066fa:	36813083          	ld	ra,872(sp)
ffffffffc02066fe:	36013403          	ld	s0,864(sp)
ffffffffc0206702:	35813483          	ld	s1,856(sp)
ffffffffc0206706:	35013903          	ld	s2,848(sp)
ffffffffc020670a:	34813983          	ld	s3,840(sp)
ffffffffc020670e:	34013a03          	ld	s4,832(sp)
ffffffffc0206712:	33813a83          	ld	s5,824(sp)
ffffffffc0206716:	32813b83          	ld	s7,808(sp)
ffffffffc020671a:	32013c03          	ld	s8,800(sp)
ffffffffc020671e:	31813c83          	ld	s9,792(sp)
ffffffffc0206722:	31013d03          	ld	s10,784(sp)
ffffffffc0206726:	30813d83          	ld	s11,776(sp)
ffffffffc020672a:	855a                	mv	a0,s6
ffffffffc020672c:	33013b03          	ld	s6,816(sp)
ffffffffc0206730:	37010113          	addi	sp,sp,880
ffffffffc0206734:	8082                	ret
ffffffffc0206736:	854a                	mv	a0,s2
ffffffffc0206738:	907fb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020673c:	5b75                	li	s6,-3
ffffffffc020673e:	bfbd                	j	ffffffffc02066bc <do_execve+0x23c>
ffffffffc0206740:	000ab783          	ld	a5,0(s5)
ffffffffc0206744:	00007617          	auipc	a2,0x7
ffffffffc0206748:	f4460613          	addi	a2,a2,-188 # ffffffffc020d688 <CSWTCH.79+0x2f0>
ffffffffc020674c:	45c1                	li	a1,16
ffffffffc020674e:	43d4                	lw	a3,4(a5)
ffffffffc0206750:	1888                	addi	a0,sp,112
ffffffffc0206752:	45f040ef          	jal	ra,ffffffffc020b3b0 <snprintf>
ffffffffc0206756:	bb6d                	j	ffffffffc0206510 <do_execve+0x90>
ffffffffc0206758:	855e                	mv	a0,s7
ffffffffc020675a:	f98fd0ef          	jal	ra,ffffffffc0203ef2 <exit_mmap>
ffffffffc020675e:	018bb503          	ld	a0,24(s7)
ffffffffc0206762:	b16ff0ef          	jal	ra,ffffffffc0205a78 <put_pgdir.isra.0>
ffffffffc0206766:	855e                	mv	a0,s7
ffffffffc0206768:	deefd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc020676c:	b591                	j	ffffffffc02065b0 <do_execve+0x130>
ffffffffc020676e:	04000613          	li	a2,64
ffffffffc0206772:	192c                	addi	a1,sp,184
ffffffffc0206774:	854a                	mv	a0,s2
ffffffffc0206776:	de9fe0ef          	jal	ra,ffffffffc020555e <sysfile_read>
ffffffffc020677a:	04000713          	li	a4,64
ffffffffc020677e:	00e50863          	beq	a0,a4,ffffffffc020678e <do_execve+0x30e>
ffffffffc0206782:	00050b1b          	sext.w	s6,a0
ffffffffc0206786:	ea054ae3          	bltz	a0,ffffffffc020663a <do_execve+0x1ba>
ffffffffc020678a:	5b7d                	li	s6,-1
ffffffffc020678c:	b57d                	j	ffffffffc020663a <do_execve+0x1ba>
ffffffffc020678e:	56ea                	lw	a3,184(sp)
ffffffffc0206790:	464c4737          	lui	a4,0x464c4
ffffffffc0206794:	57f70713          	addi	a4,a4,1407 # 464c457f <_binary_bin_sfs_img_size+0x4644f27f>
ffffffffc0206798:	20e69f63          	bne	a3,a4,ffffffffc02069b6 <do_execve+0x536>
ffffffffc020679c:	0f015703          	lhu	a4,240(sp)
ffffffffc02067a0:	e882                	sd	zero,80(sp)
ffffffffc02067a2:	f402                	sd	zero,40(sp)
ffffffffc02067a4:	cb49                	beqz	a4,ffffffffc0206836 <do_execve+0x3b6>
ffffffffc02067a6:	fc6e                	sd	s11,56(sp)
ffffffffc02067a8:	f0e2                	sd	s8,96(sp)
ffffffffc02067aa:	f4a6                	sd	s1,104(sp)
ffffffffc02067ac:	ecda                	sd	s6,88(sp)
ffffffffc02067ae:	e0a2                	sd	s0,64(sp)
ffffffffc02067b0:	65ee                	ld	a1,216(sp)
ffffffffc02067b2:	77a2                	ld	a5,40(sp)
ffffffffc02067b4:	4601                	li	a2,0
ffffffffc02067b6:	854a                	mv	a0,s2
ffffffffc02067b8:	95be                	add	a1,a1,a5
ffffffffc02067ba:	fd3fe0ef          	jal	ra,ffffffffc020578c <sysfile_seek>
ffffffffc02067be:	e02a                	sd	a0,0(sp)
ffffffffc02067c0:	1e051863          	bnez	a0,ffffffffc02069b0 <do_execve+0x530>
ffffffffc02067c4:	03800613          	li	a2,56
ffffffffc02067c8:	010c                	addi	a1,sp,128
ffffffffc02067ca:	854a                	mv	a0,s2
ffffffffc02067cc:	d93fe0ef          	jal	ra,ffffffffc020555e <sysfile_read>
ffffffffc02067d0:	03800793          	li	a5,56
ffffffffc02067d4:	02f50763          	beq	a0,a5,ffffffffc0206802 <do_execve+0x382>
ffffffffc02067d8:	7de2                	ld	s11,56(sp)
ffffffffc02067da:	6406                	ld	s0,64(sp)
ffffffffc02067dc:	8a2a                	mv	s4,a0
ffffffffc02067de:	00054363          	bltz	a0,ffffffffc02067e4 <do_execve+0x364>
ffffffffc02067e2:	5a7d                	li	s4,-1
ffffffffc02067e4:	000a079b          	sext.w	a5,s4
ffffffffc02067e8:	e03e                	sd	a5,0(sp)
ffffffffc02067ea:	854e                	mv	a0,s3
ffffffffc02067ec:	f06fd0ef          	jal	ra,ffffffffc0203ef2 <exit_mmap>
ffffffffc02067f0:	0189b503          	ld	a0,24(s3)
ffffffffc02067f4:	6902                	ld	s2,0(sp)
ffffffffc02067f6:	a82ff0ef          	jal	ra,ffffffffc0205a78 <put_pgdir.isra.0>
ffffffffc02067fa:	854e                	mv	a0,s3
ffffffffc02067fc:	d5afd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc0206800:	b5a9                	j	ffffffffc020664a <do_execve+0x1ca>
ffffffffc0206802:	478a                	lw	a5,128(sp)
ffffffffc0206804:	4705                	li	a4,1
ffffffffc0206806:	00e79863          	bne	a5,a4,ffffffffc0206816 <do_execve+0x396>
ffffffffc020680a:	762a                	ld	a2,168(sp)
ffffffffc020680c:	778a                	ld	a5,160(sp)
ffffffffc020680e:	3cf66263          	bltu	a2,a5,ffffffffc0206bd2 <do_execve+0x752>
ffffffffc0206812:	1a061b63          	bnez	a2,ffffffffc02069c8 <do_execve+0x548>
ffffffffc0206816:	6746                	ld	a4,80(sp)
ffffffffc0206818:	76a2                	ld	a3,40(sp)
ffffffffc020681a:	0f015783          	lhu	a5,240(sp)
ffffffffc020681e:	2705                	addiw	a4,a4,1
ffffffffc0206820:	03868693          	addi	a3,a3,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc0206824:	e8ba                	sd	a4,80(sp)
ffffffffc0206826:	f436                	sd	a3,40(sp)
ffffffffc0206828:	f8f744e3          	blt	a4,a5,ffffffffc02067b0 <do_execve+0x330>
ffffffffc020682c:	7de2                	ld	s11,56(sp)
ffffffffc020682e:	7c06                	ld	s8,96(sp)
ffffffffc0206830:	74a6                	ld	s1,104(sp)
ffffffffc0206832:	6b66                	ld	s6,88(sp)
ffffffffc0206834:	6406                	ld	s0,64(sp)
ffffffffc0206836:	4701                	li	a4,0
ffffffffc0206838:	46ad                	li	a3,11
ffffffffc020683a:	00100637          	lui	a2,0x100
ffffffffc020683e:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0206842:	854e                	mv	a0,s3
ffffffffc0206844:	d64fd0ef          	jal	ra,ffffffffc0203da8 <mm_map>
ffffffffc0206848:	e02a                	sd	a0,0(sp)
ffffffffc020684a:	f145                	bnez	a0,ffffffffc02067ea <do_execve+0x36a>
ffffffffc020684c:	0189b503          	ld	a0,24(s3)
ffffffffc0206850:	467d                	li	a2,31
ffffffffc0206852:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0206856:	accfd0ef          	jal	ra,ffffffffc0203b22 <pgdir_alloc_page>
ffffffffc020685a:	44050c63          	beqz	a0,ffffffffc0206cb2 <do_execve+0x832>
ffffffffc020685e:	0189b503          	ld	a0,24(s3)
ffffffffc0206862:	467d                	li	a2,31
ffffffffc0206864:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0206868:	abafd0ef          	jal	ra,ffffffffc0203b22 <pgdir_alloc_page>
ffffffffc020686c:	42050363          	beqz	a0,ffffffffc0206c92 <do_execve+0x812>
ffffffffc0206870:	0189b503          	ld	a0,24(s3)
ffffffffc0206874:	467d                	li	a2,31
ffffffffc0206876:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc020687a:	aa8fd0ef          	jal	ra,ffffffffc0203b22 <pgdir_alloc_page>
ffffffffc020687e:	3e050a63          	beqz	a0,ffffffffc0206c72 <do_execve+0x7f2>
ffffffffc0206882:	0189b503          	ld	a0,24(s3)
ffffffffc0206886:	467d                	li	a2,31
ffffffffc0206888:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc020688c:	a96fd0ef          	jal	ra,ffffffffc0203b22 <pgdir_alloc_page>
ffffffffc0206890:	3c050163          	beqz	a0,ffffffffc0206c52 <do_execve+0x7d2>
ffffffffc0206894:	0309a703          	lw	a4,48(s3)
ffffffffc0206898:	000ab603          	ld	a2,0(s5)
ffffffffc020689c:	0189b683          	ld	a3,24(s3)
ffffffffc02068a0:	2705                	addiw	a4,a4,1
ffffffffc02068a2:	02e9a823          	sw	a4,48(s3)
ffffffffc02068a6:	03363423          	sd	s3,40(a2) # 100028 <_binary_bin_sfs_img_size+0x8ad28>
ffffffffc02068aa:	c0200737          	lui	a4,0xc0200
ffffffffc02068ae:	34e6ec63          	bltu	a3,a4,ffffffffc0206c06 <do_execve+0x786>
ffffffffc02068b2:	00090797          	auipc	a5,0x90
ffffffffc02068b6:	00678793          	addi	a5,a5,6 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02068ba:	6398                	ld	a4,0(a5)
ffffffffc02068bc:	8e99                	sub	a3,a3,a4
ffffffffc02068be:	00c6d713          	srli	a4,a3,0xc
ffffffffc02068c2:	f654                	sd	a3,168(a2)
ffffffffc02068c4:	56fd                	li	a3,-1
ffffffffc02068c6:	16fe                	slli	a3,a3,0x3f
ffffffffc02068c8:	8f55                	or	a4,a4,a3
ffffffffc02068ca:	18071073          	csrw	satp,a4
ffffffffc02068ce:	12000073          	sfence.vma
ffffffffc02068d2:	4905                	li	s2,1
ffffffffc02068d4:	6a02                	ld	s4,0(sp)
ffffffffc02068d6:	1f810b93          	addi	s7,sp,504
ffffffffc02068da:	0f810c93          	addi	s9,sp,248
ffffffffc02068de:	097e                	slli	s2,s2,0x1f
ffffffffc02068e0:	a011                	j	ffffffffc02068e4 <do_execve+0x464>
ffffffffc02068e2:	8a3e                	mv	s4,a5
ffffffffc02068e4:	000cbd03          	ld	s10,0(s9)
ffffffffc02068e8:	856a                	mv	a0,s10
ffffffffc02068ea:	315040ef          	jal	ra,ffffffffc020b3fe <strlen>
ffffffffc02068ee:	00150693          	addi	a3,a0,1
ffffffffc02068f2:	40d90933          	sub	s2,s2,a3
ffffffffc02068f6:	866a                	mv	a2,s10
ffffffffc02068f8:	85ca                	mv	a1,s2
ffffffffc02068fa:	854e                	mv	a0,s3
ffffffffc02068fc:	012bb023          	sd	s2,0(s7)
ffffffffc0206900:	a5bfd0ef          	jal	ra,ffffffffc020435a <copy_to_user>
ffffffffc0206904:	2e050263          	beqz	a0,ffffffffc0206be8 <do_execve+0x768>
ffffffffc0206908:	001a079b          	addiw	a5,s4,1
ffffffffc020690c:	0ca1                	addi	s9,s9,8
ffffffffc020690e:	0ba1                	addi	s7,s7,8
ffffffffc0206910:	fc9a49e3          	blt	s4,s1,ffffffffc02068e2 <do_execve+0x462>
ffffffffc0206914:	008d8693          	addi	a3,s11,8
ffffffffc0206918:	ff897493          	andi	s1,s2,-8
ffffffffc020691c:	003c1793          	slli	a5,s8,0x3
ffffffffc0206920:	0618                	addi	a4,sp,768
ffffffffc0206922:	8c95                	sub	s1,s1,a3
ffffffffc0206924:	97ba                	add	a5,a5,a4
ffffffffc0206926:	1bb0                	addi	a2,sp,504
ffffffffc0206928:	85a6                	mv	a1,s1
ffffffffc020692a:	854e                	mv	a0,s3
ffffffffc020692c:	ee07bc23          	sd	zero,-264(a5)
ffffffffc0206930:	a2bfd0ef          	jal	ra,ffffffffc020435a <copy_to_user>
ffffffffc0206934:	2a050d63          	beqz	a0,ffffffffc0206bee <do_execve+0x76e>
ffffffffc0206938:	000ab783          	ld	a5,0(s5)
ffffffffc020693c:	12000613          	li	a2,288
ffffffffc0206940:	4581                	li	a1,0
ffffffffc0206942:	0a07b903          	ld	s2,160(a5)
ffffffffc0206946:	10093983          	ld	s3,256(s2) # ffffffff80000100 <_binary_bin_sfs_img_size+0xffffffff7ff8ae00>
ffffffffc020694a:	854a                	mv	a0,s2
ffffffffc020694c:	355040ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0206950:	674e                	ld	a4,208(sp)
ffffffffc0206952:	edf9f793          	andi	a5,s3,-289
ffffffffc0206956:	0207e793          	ori	a5,a5,32
ffffffffc020695a:	00993823          	sd	s1,16(s2)
ffffffffc020695e:	10e93423          	sd	a4,264(s2)
ffffffffc0206962:	10f93023          	sd	a5,256(s2)
ffffffffc0206966:	04893823          	sd	s0,80(s2)
ffffffffc020696a:	04993c23          	sd	s1,88(s2)
ffffffffc020696e:	67c2                	ld	a5,16(sp)
ffffffffc0206970:	147d                	addi	s0,s0,-1
ffffffffc0206972:	11a4                	addi	s1,sp,232
ffffffffc0206974:	02079713          	slli	a4,a5,0x20
ffffffffc0206978:	01d75793          	srli	a5,a4,0x1d
ffffffffc020697c:	040e                	slli	s0,s0,0x3
ffffffffc020697e:	94ee                	add	s1,s1,s11
ffffffffc0206980:	19b8                	addi	a4,sp,248
ffffffffc0206982:	943a                	add	s0,s0,a4
ffffffffc0206984:	8c9d                	sub	s1,s1,a5
ffffffffc0206986:	6008                	ld	a0,0(s0)
ffffffffc0206988:	1461                	addi	s0,s0,-8
ffffffffc020698a:	eb4fb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020698e:	fe941ce3          	bne	s0,s1,ffffffffc0206986 <do_execve+0x506>
ffffffffc0206992:	000ab403          	ld	s0,0(s5)
ffffffffc0206996:	4641                	li	a2,16
ffffffffc0206998:	4581                	li	a1,0
ffffffffc020699a:	0b440413          	addi	s0,s0,180
ffffffffc020699e:	8522                	mv	a0,s0
ffffffffc02069a0:	301040ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc02069a4:	463d                	li	a2,15
ffffffffc02069a6:	188c                	addi	a1,sp,112
ffffffffc02069a8:	8522                	mv	a0,s0
ffffffffc02069aa:	349040ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc02069ae:	b3b1                	j	ffffffffc02066fa <do_execve+0x27a>
ffffffffc02069b0:	7de2                	ld	s11,56(sp)
ffffffffc02069b2:	6406                	ld	s0,64(sp)
ffffffffc02069b4:	bd1d                	j	ffffffffc02067ea <do_execve+0x36a>
ffffffffc02069b6:	0189b503          	ld	a0,24(s3)
ffffffffc02069ba:	5961                	li	s2,-8
ffffffffc02069bc:	8bcff0ef          	jal	ra,ffffffffc0205a78 <put_pgdir.isra.0>
ffffffffc02069c0:	854e                	mv	a0,s3
ffffffffc02069c2:	b94fd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc02069c6:	b151                	j	ffffffffc020664a <do_execve+0x1ca>
ffffffffc02069c8:	479a                	lw	a5,132(sp)
ffffffffc02069ca:	0017f693          	andi	a3,a5,1
ffffffffc02069ce:	c291                	beqz	a3,ffffffffc02069d2 <do_execve+0x552>
ffffffffc02069d0:	4691                	li	a3,4
ffffffffc02069d2:	0027f713          	andi	a4,a5,2
ffffffffc02069d6:	8b91                	andi	a5,a5,4
ffffffffc02069d8:	e771                	bnez	a4,ffffffffc0206aa4 <do_execve+0x624>
ffffffffc02069da:	4745                	li	a4,17
ffffffffc02069dc:	e4ba                	sd	a4,72(sp)
ffffffffc02069de:	c789                	beqz	a5,ffffffffc02069e8 <do_execve+0x568>
ffffffffc02069e0:	47cd                	li	a5,19
ffffffffc02069e2:	0016e693          	ori	a3,a3,1
ffffffffc02069e6:	e4be                	sd	a5,72(sp)
ffffffffc02069e8:	0026f793          	andi	a5,a3,2
ffffffffc02069ec:	efdd                	bnez	a5,ffffffffc0206aaa <do_execve+0x62a>
ffffffffc02069ee:	0046f793          	andi	a5,a3,4
ffffffffc02069f2:	c789                	beqz	a5,ffffffffc02069fc <do_execve+0x57c>
ffffffffc02069f4:	67a6                	ld	a5,72(sp)
ffffffffc02069f6:	0087e793          	ori	a5,a5,8
ffffffffc02069fa:	e4be                	sd	a5,72(sp)
ffffffffc02069fc:	65ca                	ld	a1,144(sp)
ffffffffc02069fe:	4701                	li	a4,0
ffffffffc0206a00:	854e                	mv	a0,s3
ffffffffc0206a02:	ba6fd0ef          	jal	ra,ffffffffc0203da8 <mm_map>
ffffffffc0206a06:	e02a                	sd	a0,0(sp)
ffffffffc0206a08:	f545                	bnez	a0,ffffffffc02069b0 <do_execve+0x530>
ffffffffc0206a0a:	644a                	ld	s0,144(sp)
ffffffffc0206a0c:	7c0a                	ld	s8,160(sp)
ffffffffc0206a0e:	77fd                	lui	a5,0xfffff
ffffffffc0206a10:	6baa                	ld	s7,136(sp)
ffffffffc0206a12:	01840a33          	add	s4,s0,s8
ffffffffc0206a16:	00f47b33          	and	s6,s0,a5
ffffffffc0206a1a:	1d447163          	bgeu	s0,s4,ffffffffc0206bdc <do_execve+0x75c>
ffffffffc0206a1e:	57f1                	li	a5,-4
ffffffffc0206a20:	e03e                	sd	a5,0(sp)
ffffffffc0206a22:	ec4e                	sd	s3,24(sp)
ffffffffc0206a24:	8c5a                	mv	s8,s6
ffffffffc0206a26:	67e2                	ld	a5,24(sp)
ffffffffc0206a28:	6626                	ld	a2,72(sp)
ffffffffc0206a2a:	85e2                	mv	a1,s8
ffffffffc0206a2c:	6f88                	ld	a0,24(a5)
ffffffffc0206a2e:	8f4fd0ef          	jal	ra,ffffffffc0203b22 <pgdir_alloc_page>
ffffffffc0206a32:	8daa                	mv	s11,a0
ffffffffc0206a34:	c951                	beqz	a0,ffffffffc0206ac8 <do_execve+0x648>
ffffffffc0206a36:	6785                	lui	a5,0x1
ffffffffc0206a38:	00fc0b33          	add	s6,s8,a5
ffffffffc0206a3c:	408b09b3          	sub	s3,s6,s0
ffffffffc0206a40:	016a7463          	bgeu	s4,s6,ffffffffc0206a48 <do_execve+0x5c8>
ffffffffc0206a44:	408a09b3          	sub	s3,s4,s0
ffffffffc0206a48:	000cb483          	ld	s1,0(s9)
ffffffffc0206a4c:	7782                	ld	a5,32(sp)
ffffffffc0206a4e:	000d3603          	ld	a2,0(s10)
ffffffffc0206a52:	409d84b3          	sub	s1,s11,s1
ffffffffc0206a56:	8499                	srai	s1,s1,0x6
ffffffffc0206a58:	94be                	add	s1,s1,a5
ffffffffc0206a5a:	67a2                	ld	a5,8(sp)
ffffffffc0206a5c:	00f4f5b3          	and	a1,s1,a5
ffffffffc0206a60:	04b2                	slli	s1,s1,0xc
ffffffffc0206a62:	1ac5fe63          	bgeu	a1,a2,ffffffffc0206c1e <do_execve+0x79e>
ffffffffc0206a66:	00090797          	auipc	a5,0x90
ffffffffc0206a6a:	e5278793          	addi	a5,a5,-430 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206a6e:	639c                	ld	a5,0(a5)
ffffffffc0206a70:	4601                	li	a2,0
ffffffffc0206a72:	85de                	mv	a1,s7
ffffffffc0206a74:	854a                	mv	a0,s2
ffffffffc0206a76:	f83e                	sd	a5,48(sp)
ffffffffc0206a78:	d15fe0ef          	jal	ra,ffffffffc020578c <sysfile_seek>
ffffffffc0206a7c:	e02a                	sd	a0,0(sp)
ffffffffc0206a7e:	ed1d                	bnez	a0,ffffffffc0206abc <do_execve+0x63c>
ffffffffc0206a80:	77c2                	ld	a5,48(sp)
ffffffffc0206a82:	418405b3          	sub	a1,s0,s8
ffffffffc0206a86:	864e                	mv	a2,s3
ffffffffc0206a88:	94be                	add	s1,s1,a5
ffffffffc0206a8a:	95a6                	add	a1,a1,s1
ffffffffc0206a8c:	854a                	mv	a0,s2
ffffffffc0206a8e:	ad1fe0ef          	jal	ra,ffffffffc020555e <sysfile_read>
ffffffffc0206a92:	00a98f63          	beq	s3,a0,ffffffffc0206ab0 <do_execve+0x630>
ffffffffc0206a96:	7de2                	ld	s11,56(sp)
ffffffffc0206a98:	69e2                	ld	s3,24(sp)
ffffffffc0206a9a:	6406                	ld	s0,64(sp)
ffffffffc0206a9c:	8a2a                	mv	s4,a0
ffffffffc0206a9e:	d40552e3          	bgez	a0,ffffffffc02067e2 <do_execve+0x362>
ffffffffc0206aa2:	b389                	j	ffffffffc02067e4 <do_execve+0x364>
ffffffffc0206aa4:	0026e693          	ori	a3,a3,2
ffffffffc0206aa8:	ff85                	bnez	a5,ffffffffc02069e0 <do_execve+0x560>
ffffffffc0206aaa:	47dd                	li	a5,23
ffffffffc0206aac:	e4be                	sd	a5,72(sp)
ffffffffc0206aae:	b781                	j	ffffffffc02069ee <do_execve+0x56e>
ffffffffc0206ab0:	944e                	add	s0,s0,s3
ffffffffc0206ab2:	9bce                	add	s7,s7,s3
ffffffffc0206ab4:	03447d63          	bgeu	s0,s4,ffffffffc0206aee <do_execve+0x66e>
ffffffffc0206ab8:	8c5a                	mv	s8,s6
ffffffffc0206aba:	b7b5                	j	ffffffffc0206a26 <do_execve+0x5a6>
ffffffffc0206abc:	7de2                	ld	s11,56(sp)
ffffffffc0206abe:	69e2                	ld	s3,24(sp)
ffffffffc0206ac0:	6406                	ld	s0,64(sp)
ffffffffc0206ac2:	b325                	j	ffffffffc02067ea <do_execve+0x36a>
ffffffffc0206ac4:	5b75                	li	s6,-3
ffffffffc0206ac6:	b915                	j	ffffffffc02066fa <do_execve+0x27a>
ffffffffc0206ac8:	7de2                	ld	s11,56(sp)
ffffffffc0206aca:	69e2                	ld	s3,24(sp)
ffffffffc0206acc:	6b66                	ld	s6,88(sp)
ffffffffc0206ace:	6406                	ld	s0,64(sp)
ffffffffc0206ad0:	854e                	mv	a0,s3
ffffffffc0206ad2:	c20fd0ef          	jal	ra,ffffffffc0203ef2 <exit_mmap>
ffffffffc0206ad6:	0189b503          	ld	a0,24(s3)
ffffffffc0206ada:	f9ffe0ef          	jal	ra,ffffffffc0205a78 <put_pgdir.isra.0>
ffffffffc0206ade:	854e                	mv	a0,s3
ffffffffc0206ae0:	a76fd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc0206ae4:	6782                	ld	a5,0(sp)
ffffffffc0206ae6:	e80784e3          	beqz	a5,ffffffffc020696e <do_execve+0x4ee>
ffffffffc0206aea:	6902                	ld	s2,0(sp)
ffffffffc0206aec:	beb9                	j	ffffffffc020664a <do_execve+0x1ca>
ffffffffc0206aee:	69e2                	ld	s3,24(sp)
ffffffffc0206af0:	64ca                	ld	s1,144(sp)
ffffffffc0206af2:	8a5a                	mv	s4,s6
ffffffffc0206af4:	762a                	ld	a2,168(sp)
ffffffffc0206af6:	94b2                	add	s1,s1,a2
ffffffffc0206af8:	05447b63          	bgeu	s0,s4,ffffffffc0206b4e <do_execve+0x6ce>
ffffffffc0206afc:	d0947de3          	bgeu	s0,s1,ffffffffc0206816 <do_execve+0x396>
ffffffffc0206b00:	6785                	lui	a5,0x1
ffffffffc0206b02:	00f40533          	add	a0,s0,a5
ffffffffc0206b06:	41450533          	sub	a0,a0,s4
ffffffffc0206b0a:	40848b33          	sub	s6,s1,s0
ffffffffc0206b0e:	0144e463          	bltu	s1,s4,ffffffffc0206b16 <do_execve+0x696>
ffffffffc0206b12:	408a0b33          	sub	s6,s4,s0
ffffffffc0206b16:	000cb583          	ld	a1,0(s9)
ffffffffc0206b1a:	7782                	ld	a5,32(sp)
ffffffffc0206b1c:	000d3603          	ld	a2,0(s10)
ffffffffc0206b20:	40bd86b3          	sub	a3,s11,a1
ffffffffc0206b24:	8699                	srai	a3,a3,0x6
ffffffffc0206b26:	96be                	add	a3,a3,a5
ffffffffc0206b28:	67a2                	ld	a5,8(sp)
ffffffffc0206b2a:	00f6f5b3          	and	a1,a3,a5
ffffffffc0206b2e:	06b2                	slli	a3,a3,0xc
ffffffffc0206b30:	0ec5f863          	bgeu	a1,a2,ffffffffc0206c20 <do_execve+0x7a0>
ffffffffc0206b34:	00090797          	auipc	a5,0x90
ffffffffc0206b38:	d8478793          	addi	a5,a5,-636 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206b3c:	0007b803          	ld	a6,0(a5)
ffffffffc0206b40:	865a                	mv	a2,s6
ffffffffc0206b42:	4581                	li	a1,0
ffffffffc0206b44:	96c2                	add	a3,a3,a6
ffffffffc0206b46:	9536                	add	a0,a0,a3
ffffffffc0206b48:	159040ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0206b4c:	945a                	add	s0,s0,s6
ffffffffc0206b4e:	cc9474e3          	bgeu	s0,s1,ffffffffc0206816 <do_execve+0x396>
ffffffffc0206b52:	6b26                	ld	s6,72(sp)
ffffffffc0206b54:	7b82                	ld	s7,32(sp)
ffffffffc0206b56:	a0a9                	j	ffffffffc0206ba0 <do_execve+0x720>
ffffffffc0206b58:	6785                	lui	a5,0x1
ffffffffc0206b5a:	41440733          	sub	a4,s0,s4
ffffffffc0206b5e:	9a3e                	add	s4,s4,a5
ffffffffc0206b60:	408a0633          	sub	a2,s4,s0
ffffffffc0206b64:	0144f463          	bgeu	s1,s4,ffffffffc0206b6c <do_execve+0x6ec>
ffffffffc0206b68:	40848633          	sub	a2,s1,s0
ffffffffc0206b6c:	000cb783          	ld	a5,0(s9)
ffffffffc0206b70:	65a2                	ld	a1,8(sp)
ffffffffc0206b72:	000d3683          	ld	a3,0(s10)
ffffffffc0206b76:	40f507b3          	sub	a5,a0,a5
ffffffffc0206b7a:	8799                	srai	a5,a5,0x6
ffffffffc0206b7c:	97de                	add	a5,a5,s7
ffffffffc0206b7e:	8dfd                	and	a1,a1,a5
ffffffffc0206b80:	07b2                	slli	a5,a5,0xc
ffffffffc0206b82:	0ad5fb63          	bgeu	a1,a3,ffffffffc0206c38 <do_execve+0x7b8>
ffffffffc0206b86:	00090697          	auipc	a3,0x90
ffffffffc0206b8a:	d3268693          	addi	a3,a3,-718 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206b8e:	6288                	ld	a0,0(a3)
ffffffffc0206b90:	9432                	add	s0,s0,a2
ffffffffc0206b92:	4581                	li	a1,0
ffffffffc0206b94:	953e                	add	a0,a0,a5
ffffffffc0206b96:	953a                	add	a0,a0,a4
ffffffffc0206b98:	109040ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0206b9c:	c6947de3          	bgeu	s0,s1,ffffffffc0206816 <do_execve+0x396>
ffffffffc0206ba0:	0189b503          	ld	a0,24(s3)
ffffffffc0206ba4:	865a                	mv	a2,s6
ffffffffc0206ba6:	85d2                	mv	a1,s4
ffffffffc0206ba8:	f7bfc0ef          	jal	ra,ffffffffc0203b22 <pgdir_alloc_page>
ffffffffc0206bac:	f555                	bnez	a0,ffffffffc0206b58 <do_execve+0x6d8>
ffffffffc0206bae:	7de2                	ld	s11,56(sp)
ffffffffc0206bb0:	6b66                	ld	s6,88(sp)
ffffffffc0206bb2:	6406                	ld	s0,64(sp)
ffffffffc0206bb4:	bf31                	j	ffffffffc0206ad0 <do_execve+0x650>
ffffffffc0206bb6:	5b75                	li	s6,-3
ffffffffc0206bb8:	b20b9be3          	bnez	s7,ffffffffc02066ee <do_execve+0x26e>
ffffffffc0206bbc:	be3d                	j	ffffffffc02066fa <do_execve+0x27a>
ffffffffc0206bbe:	f00b83e3          	beqz	s7,ffffffffc0206ac4 <do_execve+0x644>
ffffffffc0206bc2:	038b8513          	addi	a0,s7,56
ffffffffc0206bc6:	99bfd0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0206bca:	5b75                	li	s6,-3
ffffffffc0206bcc:	040ba823          	sw	zero,80(s7)
ffffffffc0206bd0:	b62d                	j	ffffffffc02066fa <do_execve+0x27a>
ffffffffc0206bd2:	57e1                	li	a5,-8
ffffffffc0206bd4:	7de2                	ld	s11,56(sp)
ffffffffc0206bd6:	6406                	ld	s0,64(sp)
ffffffffc0206bd8:	e03e                	sd	a5,0(sp)
ffffffffc0206bda:	b901                	j	ffffffffc02067ea <do_execve+0x36a>
ffffffffc0206bdc:	57f1                	li	a5,-4
ffffffffc0206bde:	84a2                	mv	s1,s0
ffffffffc0206be0:	8a5a                	mv	s4,s6
ffffffffc0206be2:	4d81                	li	s11,0
ffffffffc0206be4:	e03e                	sd	a5,0(sp)
ffffffffc0206be6:	b739                	j	ffffffffc0206af4 <do_execve+0x674>
ffffffffc0206be8:	57f5                	li	a5,-3
ffffffffc0206bea:	e03e                	sd	a5,0(sp)
ffffffffc0206bec:	befd                	j	ffffffffc02067ea <do_execve+0x36a>
ffffffffc0206bee:	854e                	mv	a0,s3
ffffffffc0206bf0:	b02fd0ef          	jal	ra,ffffffffc0203ef2 <exit_mmap>
ffffffffc0206bf4:	0189b503          	ld	a0,24(s3)
ffffffffc0206bf8:	5975                	li	s2,-3
ffffffffc0206bfa:	e7ffe0ef          	jal	ra,ffffffffc0205a78 <put_pgdir.isra.0>
ffffffffc0206bfe:	854e                	mv	a0,s3
ffffffffc0206c00:	956fd0ef          	jal	ra,ffffffffc0203d56 <mm_destroy>
ffffffffc0206c04:	b499                	j	ffffffffc020664a <do_execve+0x1ca>
ffffffffc0206c06:	00006617          	auipc	a2,0x6
ffffffffc0206c0a:	94a60613          	addi	a2,a2,-1718 # ffffffffc020c550 <default_pmm_manager+0xe0>
ffffffffc0206c0e:	34800593          	li	a1,840
ffffffffc0206c12:	00007517          	auipc	a0,0x7
ffffffffc0206c16:	89650513          	addi	a0,a0,-1898 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0206c1a:	885f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206c1e:	86a6                	mv	a3,s1
ffffffffc0206c20:	00006617          	auipc	a2,0x6
ffffffffc0206c24:	88860613          	addi	a2,a2,-1912 # ffffffffc020c4a8 <default_pmm_manager+0x38>
ffffffffc0206c28:	07100593          	li	a1,113
ffffffffc0206c2c:	00006517          	auipc	a0,0x6
ffffffffc0206c30:	8a450513          	addi	a0,a0,-1884 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0206c34:	86bf90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206c38:	86be                	mv	a3,a5
ffffffffc0206c3a:	00006617          	auipc	a2,0x6
ffffffffc0206c3e:	86e60613          	addi	a2,a2,-1938 # ffffffffc020c4a8 <default_pmm_manager+0x38>
ffffffffc0206c42:	07100593          	li	a1,113
ffffffffc0206c46:	00006517          	auipc	a0,0x6
ffffffffc0206c4a:	88a50513          	addi	a0,a0,-1910 # ffffffffc020c4d0 <default_pmm_manager+0x60>
ffffffffc0206c4e:	851f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206c52:	00007697          	auipc	a3,0x7
ffffffffc0206c56:	b4668693          	addi	a3,a3,-1210 # ffffffffc020d798 <CSWTCH.79+0x400>
ffffffffc0206c5a:	00005617          	auipc	a2,0x5
ffffffffc0206c5e:	d2e60613          	addi	a2,a2,-722 # ffffffffc020b988 <commands+0x210>
ffffffffc0206c62:	34300593          	li	a1,835
ffffffffc0206c66:	00007517          	auipc	a0,0x7
ffffffffc0206c6a:	84250513          	addi	a0,a0,-1982 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0206c6e:	831f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206c72:	00007697          	auipc	a3,0x7
ffffffffc0206c76:	ade68693          	addi	a3,a3,-1314 # ffffffffc020d750 <CSWTCH.79+0x3b8>
ffffffffc0206c7a:	00005617          	auipc	a2,0x5
ffffffffc0206c7e:	d0e60613          	addi	a2,a2,-754 # ffffffffc020b988 <commands+0x210>
ffffffffc0206c82:	34200593          	li	a1,834
ffffffffc0206c86:	00007517          	auipc	a0,0x7
ffffffffc0206c8a:	82250513          	addi	a0,a0,-2014 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0206c8e:	811f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206c92:	00007697          	auipc	a3,0x7
ffffffffc0206c96:	a7668693          	addi	a3,a3,-1418 # ffffffffc020d708 <CSWTCH.79+0x370>
ffffffffc0206c9a:	00005617          	auipc	a2,0x5
ffffffffc0206c9e:	cee60613          	addi	a2,a2,-786 # ffffffffc020b988 <commands+0x210>
ffffffffc0206ca2:	34100593          	li	a1,833
ffffffffc0206ca6:	00007517          	auipc	a0,0x7
ffffffffc0206caa:	80250513          	addi	a0,a0,-2046 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0206cae:	ff0f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206cb2:	00007697          	auipc	a3,0x7
ffffffffc0206cb6:	a0e68693          	addi	a3,a3,-1522 # ffffffffc020d6c0 <CSWTCH.79+0x328>
ffffffffc0206cba:	00005617          	auipc	a2,0x5
ffffffffc0206cbe:	cce60613          	addi	a2,a2,-818 # ffffffffc020b988 <commands+0x210>
ffffffffc0206cc2:	34000593          	li	a1,832
ffffffffc0206cc6:	00006517          	auipc	a0,0x6
ffffffffc0206cca:	7e250513          	addi	a0,a0,2018 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0206cce:	fd0f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0206cd2 <user_main>:
ffffffffc0206cd2:	7179                	addi	sp,sp,-48
ffffffffc0206cd4:	e84a                	sd	s2,16(sp)
ffffffffc0206cd6:	00090917          	auipc	s2,0x90
ffffffffc0206cda:	bea90913          	addi	s2,s2,-1046 # ffffffffc02968c0 <current>
ffffffffc0206cde:	00093783          	ld	a5,0(s2)
ffffffffc0206ce2:	00007617          	auipc	a2,0x7
ffffffffc0206ce6:	afe60613          	addi	a2,a2,-1282 # ffffffffc020d7e0 <CSWTCH.79+0x448>
ffffffffc0206cea:	00007517          	auipc	a0,0x7
ffffffffc0206cee:	afe50513          	addi	a0,a0,-1282 # ffffffffc020d7e8 <CSWTCH.79+0x450>
ffffffffc0206cf2:	43cc                	lw	a1,4(a5)
ffffffffc0206cf4:	f406                	sd	ra,40(sp)
ffffffffc0206cf6:	f022                	sd	s0,32(sp)
ffffffffc0206cf8:	ec26                	sd	s1,24(sp)
ffffffffc0206cfa:	e032                	sd	a2,0(sp)
ffffffffc0206cfc:	e402                	sd	zero,8(sp)
ffffffffc0206cfe:	ca8f90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0206d02:	6782                	ld	a5,0(sp)
ffffffffc0206d04:	cfb9                	beqz	a5,ffffffffc0206d62 <user_main+0x90>
ffffffffc0206d06:	003c                	addi	a5,sp,8
ffffffffc0206d08:	4401                	li	s0,0
ffffffffc0206d0a:	6398                	ld	a4,0(a5)
ffffffffc0206d0c:	0405                	addi	s0,s0,1
ffffffffc0206d0e:	07a1                	addi	a5,a5,8
ffffffffc0206d10:	ff6d                	bnez	a4,ffffffffc0206d0a <user_main+0x38>
ffffffffc0206d12:	00093783          	ld	a5,0(s2)
ffffffffc0206d16:	12000613          	li	a2,288
ffffffffc0206d1a:	6b84                	ld	s1,16(a5)
ffffffffc0206d1c:	73cc                	ld	a1,160(a5)
ffffffffc0206d1e:	6789                	lui	a5,0x2
ffffffffc0206d20:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0206d24:	94be                	add	s1,s1,a5
ffffffffc0206d26:	8526                	mv	a0,s1
ffffffffc0206d28:	7ca040ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc0206d2c:	00093783          	ld	a5,0(s2)
ffffffffc0206d30:	860a                	mv	a2,sp
ffffffffc0206d32:	0004059b          	sext.w	a1,s0
ffffffffc0206d36:	f3c4                	sd	s1,160(a5)
ffffffffc0206d38:	00007517          	auipc	a0,0x7
ffffffffc0206d3c:	aa850513          	addi	a0,a0,-1368 # ffffffffc020d7e0 <CSWTCH.79+0x448>
ffffffffc0206d40:	f40ff0ef          	jal	ra,ffffffffc0206480 <do_execve>
ffffffffc0206d44:	8126                	mv	sp,s1
ffffffffc0206d46:	d0afa06f          	j	ffffffffc0201250 <__trapret>
ffffffffc0206d4a:	00007617          	auipc	a2,0x7
ffffffffc0206d4e:	ac660613          	addi	a2,a2,-1338 # ffffffffc020d810 <CSWTCH.79+0x478>
ffffffffc0206d52:	48300593          	li	a1,1155
ffffffffc0206d56:	00006517          	auipc	a0,0x6
ffffffffc0206d5a:	75250513          	addi	a0,a0,1874 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0206d5e:	f40f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206d62:	4401                	li	s0,0
ffffffffc0206d64:	b77d                	j	ffffffffc0206d12 <user_main+0x40>

ffffffffc0206d66 <do_yield>:
ffffffffc0206d66:	00090797          	auipc	a5,0x90
ffffffffc0206d6a:	b5a7b783          	ld	a5,-1190(a5) # ffffffffc02968c0 <current>
ffffffffc0206d6e:	4705                	li	a4,1
ffffffffc0206d70:	ef98                	sd	a4,24(a5)
ffffffffc0206d72:	4501                	li	a0,0
ffffffffc0206d74:	8082                	ret

ffffffffc0206d76 <do_wait>:
ffffffffc0206d76:	1101                	addi	sp,sp,-32
ffffffffc0206d78:	e822                	sd	s0,16(sp)
ffffffffc0206d7a:	e426                	sd	s1,8(sp)
ffffffffc0206d7c:	ec06                	sd	ra,24(sp)
ffffffffc0206d7e:	842e                	mv	s0,a1
ffffffffc0206d80:	84aa                	mv	s1,a0
ffffffffc0206d82:	c999                	beqz	a1,ffffffffc0206d98 <do_wait+0x22>
ffffffffc0206d84:	00090797          	auipc	a5,0x90
ffffffffc0206d88:	b3c7b783          	ld	a5,-1220(a5) # ffffffffc02968c0 <current>
ffffffffc0206d8c:	7788                	ld	a0,40(a5)
ffffffffc0206d8e:	4685                	li	a3,1
ffffffffc0206d90:	4611                	li	a2,4
ffffffffc0206d92:	d00fd0ef          	jal	ra,ffffffffc0204292 <user_mem_check>
ffffffffc0206d96:	c909                	beqz	a0,ffffffffc0206da8 <do_wait+0x32>
ffffffffc0206d98:	85a2                	mv	a1,s0
ffffffffc0206d9a:	6442                	ld	s0,16(sp)
ffffffffc0206d9c:	60e2                	ld	ra,24(sp)
ffffffffc0206d9e:	8526                	mv	a0,s1
ffffffffc0206da0:	64a2                	ld	s1,8(sp)
ffffffffc0206da2:	6105                	addi	sp,sp,32
ffffffffc0206da4:	bbaff06f          	j	ffffffffc020615e <do_wait.part.0>
ffffffffc0206da8:	60e2                	ld	ra,24(sp)
ffffffffc0206daa:	6442                	ld	s0,16(sp)
ffffffffc0206dac:	64a2                	ld	s1,8(sp)
ffffffffc0206dae:	5575                	li	a0,-3
ffffffffc0206db0:	6105                	addi	sp,sp,32
ffffffffc0206db2:	8082                	ret

ffffffffc0206db4 <do_kill>:
ffffffffc0206db4:	1141                	addi	sp,sp,-16
ffffffffc0206db6:	6789                	lui	a5,0x2
ffffffffc0206db8:	e406                	sd	ra,8(sp)
ffffffffc0206dba:	e022                	sd	s0,0(sp)
ffffffffc0206dbc:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206dc0:	17f9                	addi	a5,a5,-2
ffffffffc0206dc2:	02e7e963          	bltu	a5,a4,ffffffffc0206df4 <do_kill+0x40>
ffffffffc0206dc6:	842a                	mv	s0,a0
ffffffffc0206dc8:	45a9                	li	a1,10
ffffffffc0206dca:	2501                	sext.w	a0,a0
ffffffffc0206dcc:	1a0040ef          	jal	ra,ffffffffc020af6c <hash32>
ffffffffc0206dd0:	02051793          	slli	a5,a0,0x20
ffffffffc0206dd4:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206dd8:	0008b797          	auipc	a5,0x8b
ffffffffc0206ddc:	9e878793          	addi	a5,a5,-1560 # ffffffffc02917c0 <hash_list>
ffffffffc0206de0:	953e                	add	a0,a0,a5
ffffffffc0206de2:	87aa                	mv	a5,a0
ffffffffc0206de4:	a029                	j	ffffffffc0206dee <do_kill+0x3a>
ffffffffc0206de6:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0206dea:	00870b63          	beq	a4,s0,ffffffffc0206e00 <do_kill+0x4c>
ffffffffc0206dee:	679c                	ld	a5,8(a5)
ffffffffc0206df0:	fef51be3          	bne	a0,a5,ffffffffc0206de6 <do_kill+0x32>
ffffffffc0206df4:	5475                	li	s0,-3
ffffffffc0206df6:	60a2                	ld	ra,8(sp)
ffffffffc0206df8:	8522                	mv	a0,s0
ffffffffc0206dfa:	6402                	ld	s0,0(sp)
ffffffffc0206dfc:	0141                	addi	sp,sp,16
ffffffffc0206dfe:	8082                	ret
ffffffffc0206e00:	fd87a703          	lw	a4,-40(a5)
ffffffffc0206e04:	00177693          	andi	a3,a4,1
ffffffffc0206e08:	e295                	bnez	a3,ffffffffc0206e2c <do_kill+0x78>
ffffffffc0206e0a:	4bd4                	lw	a3,20(a5)
ffffffffc0206e0c:	00176713          	ori	a4,a4,1
ffffffffc0206e10:	fce7ac23          	sw	a4,-40(a5)
ffffffffc0206e14:	4401                	li	s0,0
ffffffffc0206e16:	fe06d0e3          	bgez	a3,ffffffffc0206df6 <do_kill+0x42>
ffffffffc0206e1a:	f2878513          	addi	a0,a5,-216
ffffffffc0206e1e:	45a000ef          	jal	ra,ffffffffc0207278 <wakeup_proc>
ffffffffc0206e22:	60a2                	ld	ra,8(sp)
ffffffffc0206e24:	8522                	mv	a0,s0
ffffffffc0206e26:	6402                	ld	s0,0(sp)
ffffffffc0206e28:	0141                	addi	sp,sp,16
ffffffffc0206e2a:	8082                	ret
ffffffffc0206e2c:	545d                	li	s0,-9
ffffffffc0206e2e:	b7e1                	j	ffffffffc0206df6 <do_kill+0x42>

ffffffffc0206e30 <proc_init>:
ffffffffc0206e30:	1101                	addi	sp,sp,-32
ffffffffc0206e32:	e426                	sd	s1,8(sp)
ffffffffc0206e34:	0008f797          	auipc	a5,0x8f
ffffffffc0206e38:	98c78793          	addi	a5,a5,-1652 # ffffffffc02957c0 <proc_list>
ffffffffc0206e3c:	ec06                	sd	ra,24(sp)
ffffffffc0206e3e:	e822                	sd	s0,16(sp)
ffffffffc0206e40:	e04a                	sd	s2,0(sp)
ffffffffc0206e42:	0008b497          	auipc	s1,0x8b
ffffffffc0206e46:	97e48493          	addi	s1,s1,-1666 # ffffffffc02917c0 <hash_list>
ffffffffc0206e4a:	e79c                	sd	a5,8(a5)
ffffffffc0206e4c:	e39c                	sd	a5,0(a5)
ffffffffc0206e4e:	0008f717          	auipc	a4,0x8f
ffffffffc0206e52:	97270713          	addi	a4,a4,-1678 # ffffffffc02957c0 <proc_list>
ffffffffc0206e56:	87a6                	mv	a5,s1
ffffffffc0206e58:	e79c                	sd	a5,8(a5)
ffffffffc0206e5a:	e39c                	sd	a5,0(a5)
ffffffffc0206e5c:	07c1                	addi	a5,a5,16
ffffffffc0206e5e:	fef71de3          	bne	a4,a5,ffffffffc0206e58 <proc_init+0x28>
ffffffffc0206e62:	b73fe0ef          	jal	ra,ffffffffc02059d4 <alloc_proc>
ffffffffc0206e66:	00090917          	auipc	s2,0x90
ffffffffc0206e6a:	a6290913          	addi	s2,s2,-1438 # ffffffffc02968c8 <idleproc>
ffffffffc0206e6e:	00a93023          	sd	a0,0(s2)
ffffffffc0206e72:	842a                	mv	s0,a0
ffffffffc0206e74:	12050863          	beqz	a0,ffffffffc0206fa4 <proc_init+0x174>
ffffffffc0206e78:	4789                	li	a5,2
ffffffffc0206e7a:	e11c                	sd	a5,0(a0)
ffffffffc0206e7c:	0000a797          	auipc	a5,0xa
ffffffffc0206e80:	18478793          	addi	a5,a5,388 # ffffffffc0211000 <bootstack>
ffffffffc0206e84:	e91c                	sd	a5,16(a0)
ffffffffc0206e86:	4785                	li	a5,1
ffffffffc0206e88:	ed1c                	sd	a5,24(a0)
ffffffffc0206e8a:	b44fe0ef          	jal	ra,ffffffffc02051ce <files_create>
ffffffffc0206e8e:	14a43423          	sd	a0,328(s0)
ffffffffc0206e92:	0e050d63          	beqz	a0,ffffffffc0206f8c <proc_init+0x15c>
ffffffffc0206e96:	00093403          	ld	s0,0(s2)
ffffffffc0206e9a:	4641                	li	a2,16
ffffffffc0206e9c:	4581                	li	a1,0
ffffffffc0206e9e:	14843703          	ld	a4,328(s0)
ffffffffc0206ea2:	0b440413          	addi	s0,s0,180
ffffffffc0206ea6:	8522                	mv	a0,s0
ffffffffc0206ea8:	4b1c                	lw	a5,16(a4)
ffffffffc0206eaa:	2785                	addiw	a5,a5,1
ffffffffc0206eac:	cb1c                	sw	a5,16(a4)
ffffffffc0206eae:	5f2040ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0206eb2:	463d                	li	a2,15
ffffffffc0206eb4:	00007597          	auipc	a1,0x7
ffffffffc0206eb8:	9bc58593          	addi	a1,a1,-1604 # ffffffffc020d870 <CSWTCH.79+0x4d8>
ffffffffc0206ebc:	8522                	mv	a0,s0
ffffffffc0206ebe:	634040ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc0206ec2:	00090717          	auipc	a4,0x90
ffffffffc0206ec6:	a1670713          	addi	a4,a4,-1514 # ffffffffc02968d8 <nr_process>
ffffffffc0206eca:	431c                	lw	a5,0(a4)
ffffffffc0206ecc:	00093683          	ld	a3,0(s2)
ffffffffc0206ed0:	4601                	li	a2,0
ffffffffc0206ed2:	2785                	addiw	a5,a5,1
ffffffffc0206ed4:	4581                	li	a1,0
ffffffffc0206ed6:	fffff517          	auipc	a0,0xfffff
ffffffffc0206eda:	45a50513          	addi	a0,a0,1114 # ffffffffc0206330 <init_main>
ffffffffc0206ede:	c31c                	sw	a5,0(a4)
ffffffffc0206ee0:	00090797          	auipc	a5,0x90
ffffffffc0206ee4:	9ed7b023          	sd	a3,-1568(a5) # ffffffffc02968c0 <current>
ffffffffc0206ee8:	8c4ff0ef          	jal	ra,ffffffffc0205fac <kernel_thread>
ffffffffc0206eec:	842a                	mv	s0,a0
ffffffffc0206eee:	08a05363          	blez	a0,ffffffffc0206f74 <proc_init+0x144>
ffffffffc0206ef2:	6789                	lui	a5,0x2
ffffffffc0206ef4:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206ef8:	17f9                	addi	a5,a5,-2
ffffffffc0206efa:	2501                	sext.w	a0,a0
ffffffffc0206efc:	02e7e363          	bltu	a5,a4,ffffffffc0206f22 <proc_init+0xf2>
ffffffffc0206f00:	45a9                	li	a1,10
ffffffffc0206f02:	06a040ef          	jal	ra,ffffffffc020af6c <hash32>
ffffffffc0206f06:	02051793          	slli	a5,a0,0x20
ffffffffc0206f0a:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0206f0e:	96a6                	add	a3,a3,s1
ffffffffc0206f10:	87b6                	mv	a5,a3
ffffffffc0206f12:	a029                	j	ffffffffc0206f1c <proc_init+0xec>
ffffffffc0206f14:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_bin_swap_img_size-0x5dd4>
ffffffffc0206f18:	04870b63          	beq	a4,s0,ffffffffc0206f6e <proc_init+0x13e>
ffffffffc0206f1c:	679c                	ld	a5,8(a5)
ffffffffc0206f1e:	fef69be3          	bne	a3,a5,ffffffffc0206f14 <proc_init+0xe4>
ffffffffc0206f22:	4781                	li	a5,0
ffffffffc0206f24:	0b478493          	addi	s1,a5,180
ffffffffc0206f28:	4641                	li	a2,16
ffffffffc0206f2a:	4581                	li	a1,0
ffffffffc0206f2c:	00090417          	auipc	s0,0x90
ffffffffc0206f30:	9a440413          	addi	s0,s0,-1628 # ffffffffc02968d0 <initproc>
ffffffffc0206f34:	8526                	mv	a0,s1
ffffffffc0206f36:	e01c                	sd	a5,0(s0)
ffffffffc0206f38:	568040ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0206f3c:	463d                	li	a2,15
ffffffffc0206f3e:	00007597          	auipc	a1,0x7
ffffffffc0206f42:	95a58593          	addi	a1,a1,-1702 # ffffffffc020d898 <CSWTCH.79+0x500>
ffffffffc0206f46:	8526                	mv	a0,s1
ffffffffc0206f48:	5aa040ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc0206f4c:	00093783          	ld	a5,0(s2)
ffffffffc0206f50:	c7d1                	beqz	a5,ffffffffc0206fdc <proc_init+0x1ac>
ffffffffc0206f52:	43dc                	lw	a5,4(a5)
ffffffffc0206f54:	e7c1                	bnez	a5,ffffffffc0206fdc <proc_init+0x1ac>
ffffffffc0206f56:	601c                	ld	a5,0(s0)
ffffffffc0206f58:	c3b5                	beqz	a5,ffffffffc0206fbc <proc_init+0x18c>
ffffffffc0206f5a:	43d8                	lw	a4,4(a5)
ffffffffc0206f5c:	4785                	li	a5,1
ffffffffc0206f5e:	04f71f63          	bne	a4,a5,ffffffffc0206fbc <proc_init+0x18c>
ffffffffc0206f62:	60e2                	ld	ra,24(sp)
ffffffffc0206f64:	6442                	ld	s0,16(sp)
ffffffffc0206f66:	64a2                	ld	s1,8(sp)
ffffffffc0206f68:	6902                	ld	s2,0(sp)
ffffffffc0206f6a:	6105                	addi	sp,sp,32
ffffffffc0206f6c:	8082                	ret
ffffffffc0206f6e:	f2878793          	addi	a5,a5,-216
ffffffffc0206f72:	bf4d                	j	ffffffffc0206f24 <proc_init+0xf4>
ffffffffc0206f74:	00007617          	auipc	a2,0x7
ffffffffc0206f78:	90460613          	addi	a2,a2,-1788 # ffffffffc020d878 <CSWTCH.79+0x4e0>
ffffffffc0206f7c:	4cf00593          	li	a1,1231
ffffffffc0206f80:	00006517          	auipc	a0,0x6
ffffffffc0206f84:	52850513          	addi	a0,a0,1320 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0206f88:	d16f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206f8c:	00007617          	auipc	a2,0x7
ffffffffc0206f90:	8bc60613          	addi	a2,a2,-1860 # ffffffffc020d848 <CSWTCH.79+0x4b0>
ffffffffc0206f94:	4c300593          	li	a1,1219
ffffffffc0206f98:	00006517          	auipc	a0,0x6
ffffffffc0206f9c:	51050513          	addi	a0,a0,1296 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0206fa0:	cfef90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206fa4:	00007617          	auipc	a2,0x7
ffffffffc0206fa8:	88c60613          	addi	a2,a2,-1908 # ffffffffc020d830 <CSWTCH.79+0x498>
ffffffffc0206fac:	4b900593          	li	a1,1209
ffffffffc0206fb0:	00006517          	auipc	a0,0x6
ffffffffc0206fb4:	4f850513          	addi	a0,a0,1272 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0206fb8:	ce6f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206fbc:	00007697          	auipc	a3,0x7
ffffffffc0206fc0:	90c68693          	addi	a3,a3,-1780 # ffffffffc020d8c8 <CSWTCH.79+0x530>
ffffffffc0206fc4:	00005617          	auipc	a2,0x5
ffffffffc0206fc8:	9c460613          	addi	a2,a2,-1596 # ffffffffc020b988 <commands+0x210>
ffffffffc0206fcc:	4d600593          	li	a1,1238
ffffffffc0206fd0:	00006517          	auipc	a0,0x6
ffffffffc0206fd4:	4d850513          	addi	a0,a0,1240 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0206fd8:	cc6f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206fdc:	00007697          	auipc	a3,0x7
ffffffffc0206fe0:	8c468693          	addi	a3,a3,-1852 # ffffffffc020d8a0 <CSWTCH.79+0x508>
ffffffffc0206fe4:	00005617          	auipc	a2,0x5
ffffffffc0206fe8:	9a460613          	addi	a2,a2,-1628 # ffffffffc020b988 <commands+0x210>
ffffffffc0206fec:	4d500593          	li	a1,1237
ffffffffc0206ff0:	00006517          	auipc	a0,0x6
ffffffffc0206ff4:	4b850513          	addi	a0,a0,1208 # ffffffffc020d4a8 <CSWTCH.79+0x110>
ffffffffc0206ff8:	ca6f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0206ffc <cpu_idle>:
ffffffffc0206ffc:	1141                	addi	sp,sp,-16
ffffffffc0206ffe:	e022                	sd	s0,0(sp)
ffffffffc0207000:	e406                	sd	ra,8(sp)
ffffffffc0207002:	00090417          	auipc	s0,0x90
ffffffffc0207006:	8be40413          	addi	s0,s0,-1858 # ffffffffc02968c0 <current>
ffffffffc020700a:	6018                	ld	a4,0(s0)
ffffffffc020700c:	6f1c                	ld	a5,24(a4)
ffffffffc020700e:	dffd                	beqz	a5,ffffffffc020700c <cpu_idle+0x10>
ffffffffc0207010:	31a000ef          	jal	ra,ffffffffc020732a <schedule>
ffffffffc0207014:	bfdd                	j	ffffffffc020700a <cpu_idle+0xe>

ffffffffc0207016 <lab6_set_priority>:
ffffffffc0207016:	1141                	addi	sp,sp,-16
ffffffffc0207018:	e022                	sd	s0,0(sp)
ffffffffc020701a:	85aa                	mv	a1,a0
ffffffffc020701c:	842a                	mv	s0,a0
ffffffffc020701e:	00007517          	auipc	a0,0x7
ffffffffc0207022:	8d250513          	addi	a0,a0,-1838 # ffffffffc020d8f0 <CSWTCH.79+0x558>
ffffffffc0207026:	e406                	sd	ra,8(sp)
ffffffffc0207028:	97ef90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020702c:	00090797          	auipc	a5,0x90
ffffffffc0207030:	8947b783          	ld	a5,-1900(a5) # ffffffffc02968c0 <current>
ffffffffc0207034:	e801                	bnez	s0,ffffffffc0207044 <lab6_set_priority+0x2e>
ffffffffc0207036:	60a2                	ld	ra,8(sp)
ffffffffc0207038:	6402                	ld	s0,0(sp)
ffffffffc020703a:	4705                	li	a4,1
ffffffffc020703c:	14e7a223          	sw	a4,324(a5)
ffffffffc0207040:	0141                	addi	sp,sp,16
ffffffffc0207042:	8082                	ret
ffffffffc0207044:	60a2                	ld	ra,8(sp)
ffffffffc0207046:	1487a223          	sw	s0,324(a5)
ffffffffc020704a:	6402                	ld	s0,0(sp)
ffffffffc020704c:	0141                	addi	sp,sp,16
ffffffffc020704e:	8082                	ret

ffffffffc0207050 <do_sleep>:
ffffffffc0207050:	c539                	beqz	a0,ffffffffc020709e <do_sleep+0x4e>
ffffffffc0207052:	7179                	addi	sp,sp,-48
ffffffffc0207054:	f022                	sd	s0,32(sp)
ffffffffc0207056:	f406                	sd	ra,40(sp)
ffffffffc0207058:	842a                	mv	s0,a0
ffffffffc020705a:	100027f3          	csrr	a5,sstatus
ffffffffc020705e:	8b89                	andi	a5,a5,2
ffffffffc0207060:	e3a9                	bnez	a5,ffffffffc02070a2 <do_sleep+0x52>
ffffffffc0207062:	00090797          	auipc	a5,0x90
ffffffffc0207066:	85e7b783          	ld	a5,-1954(a5) # ffffffffc02968c0 <current>
ffffffffc020706a:	0818                	addi	a4,sp,16
ffffffffc020706c:	c02a                	sw	a0,0(sp)
ffffffffc020706e:	ec3a                	sd	a4,24(sp)
ffffffffc0207070:	e83a                	sd	a4,16(sp)
ffffffffc0207072:	e43e                	sd	a5,8(sp)
ffffffffc0207074:	4705                	li	a4,1
ffffffffc0207076:	c398                	sw	a4,0(a5)
ffffffffc0207078:	80000737          	lui	a4,0x80000
ffffffffc020707c:	840a                	mv	s0,sp
ffffffffc020707e:	0709                	addi	a4,a4,2
ffffffffc0207080:	0ee7a623          	sw	a4,236(a5)
ffffffffc0207084:	8522                	mv	a0,s0
ffffffffc0207086:	364000ef          	jal	ra,ffffffffc02073ea <add_timer>
ffffffffc020708a:	2a0000ef          	jal	ra,ffffffffc020732a <schedule>
ffffffffc020708e:	8522                	mv	a0,s0
ffffffffc0207090:	422000ef          	jal	ra,ffffffffc02074b2 <del_timer>
ffffffffc0207094:	70a2                	ld	ra,40(sp)
ffffffffc0207096:	7402                	ld	s0,32(sp)
ffffffffc0207098:	4501                	li	a0,0
ffffffffc020709a:	6145                	addi	sp,sp,48
ffffffffc020709c:	8082                	ret
ffffffffc020709e:	4501                	li	a0,0
ffffffffc02070a0:	8082                	ret
ffffffffc02070a2:	bd1f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02070a6:	00090797          	auipc	a5,0x90
ffffffffc02070aa:	81a7b783          	ld	a5,-2022(a5) # ffffffffc02968c0 <current>
ffffffffc02070ae:	0818                	addi	a4,sp,16
ffffffffc02070b0:	c022                	sw	s0,0(sp)
ffffffffc02070b2:	e43e                	sd	a5,8(sp)
ffffffffc02070b4:	ec3a                	sd	a4,24(sp)
ffffffffc02070b6:	e83a                	sd	a4,16(sp)
ffffffffc02070b8:	4705                	li	a4,1
ffffffffc02070ba:	c398                	sw	a4,0(a5)
ffffffffc02070bc:	80000737          	lui	a4,0x80000
ffffffffc02070c0:	0709                	addi	a4,a4,2
ffffffffc02070c2:	840a                	mv	s0,sp
ffffffffc02070c4:	8522                	mv	a0,s0
ffffffffc02070c6:	0ee7a623          	sw	a4,236(a5)
ffffffffc02070ca:	320000ef          	jal	ra,ffffffffc02073ea <add_timer>
ffffffffc02070ce:	b9ff90ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02070d2:	bf65                	j	ffffffffc020708a <do_sleep+0x3a>

ffffffffc02070d4 <switch_to>:
ffffffffc02070d4:	00153023          	sd	ra,0(a0)
ffffffffc02070d8:	00253423          	sd	sp,8(a0)
ffffffffc02070dc:	e900                	sd	s0,16(a0)
ffffffffc02070de:	ed04                	sd	s1,24(a0)
ffffffffc02070e0:	03253023          	sd	s2,32(a0)
ffffffffc02070e4:	03353423          	sd	s3,40(a0)
ffffffffc02070e8:	03453823          	sd	s4,48(a0)
ffffffffc02070ec:	03553c23          	sd	s5,56(a0)
ffffffffc02070f0:	05653023          	sd	s6,64(a0)
ffffffffc02070f4:	05753423          	sd	s7,72(a0)
ffffffffc02070f8:	05853823          	sd	s8,80(a0)
ffffffffc02070fc:	05953c23          	sd	s9,88(a0)
ffffffffc0207100:	07a53023          	sd	s10,96(a0)
ffffffffc0207104:	07b53423          	sd	s11,104(a0)
ffffffffc0207108:	0005b083          	ld	ra,0(a1)
ffffffffc020710c:	0085b103          	ld	sp,8(a1)
ffffffffc0207110:	6980                	ld	s0,16(a1)
ffffffffc0207112:	6d84                	ld	s1,24(a1)
ffffffffc0207114:	0205b903          	ld	s2,32(a1)
ffffffffc0207118:	0285b983          	ld	s3,40(a1)
ffffffffc020711c:	0305ba03          	ld	s4,48(a1)
ffffffffc0207120:	0385ba83          	ld	s5,56(a1)
ffffffffc0207124:	0405bb03          	ld	s6,64(a1)
ffffffffc0207128:	0485bb83          	ld	s7,72(a1)
ffffffffc020712c:	0505bc03          	ld	s8,80(a1)
ffffffffc0207130:	0585bc83          	ld	s9,88(a1)
ffffffffc0207134:	0605bd03          	ld	s10,96(a1)
ffffffffc0207138:	0685bd83          	ld	s11,104(a1)
ffffffffc020713c:	8082                	ret

ffffffffc020713e <RR_init>:
ffffffffc020713e:	e508                	sd	a0,8(a0)
ffffffffc0207140:	e108                	sd	a0,0(a0)
ffffffffc0207142:	00052823          	sw	zero,16(a0)
ffffffffc0207146:	8082                	ret

ffffffffc0207148 <RR_pick_next>:
ffffffffc0207148:	651c                	ld	a5,8(a0)
ffffffffc020714a:	00f50563          	beq	a0,a5,ffffffffc0207154 <RR_pick_next+0xc>
ffffffffc020714e:	ef078513          	addi	a0,a5,-272
ffffffffc0207152:	8082                	ret
ffffffffc0207154:	4501                	li	a0,0
ffffffffc0207156:	8082                	ret

ffffffffc0207158 <RR_proc_tick>:
ffffffffc0207158:	1205a783          	lw	a5,288(a1)
ffffffffc020715c:	00f05563          	blez	a5,ffffffffc0207166 <RR_proc_tick+0xe>
ffffffffc0207160:	37fd                	addiw	a5,a5,-1
ffffffffc0207162:	12f5a023          	sw	a5,288(a1)
ffffffffc0207166:	e399                	bnez	a5,ffffffffc020716c <RR_proc_tick+0x14>
ffffffffc0207168:	4785                	li	a5,1
ffffffffc020716a:	ed9c                	sd	a5,24(a1)
ffffffffc020716c:	8082                	ret

ffffffffc020716e <RR_dequeue>:
ffffffffc020716e:	1185b703          	ld	a4,280(a1)
ffffffffc0207172:	11058793          	addi	a5,a1,272
ffffffffc0207176:	02e78363          	beq	a5,a4,ffffffffc020719c <RR_dequeue+0x2e>
ffffffffc020717a:	1085b683          	ld	a3,264(a1)
ffffffffc020717e:	00a69f63          	bne	a3,a0,ffffffffc020719c <RR_dequeue+0x2e>
ffffffffc0207182:	1105b503          	ld	a0,272(a1)
ffffffffc0207186:	4a90                	lw	a2,16(a3)
ffffffffc0207188:	e518                	sd	a4,8(a0)
ffffffffc020718a:	e308                	sd	a0,0(a4)
ffffffffc020718c:	10f5bc23          	sd	a5,280(a1)
ffffffffc0207190:	10f5b823          	sd	a5,272(a1)
ffffffffc0207194:	fff6079b          	addiw	a5,a2,-1
ffffffffc0207198:	ca9c                	sw	a5,16(a3)
ffffffffc020719a:	8082                	ret
ffffffffc020719c:	1141                	addi	sp,sp,-16
ffffffffc020719e:	00006697          	auipc	a3,0x6
ffffffffc02071a2:	76a68693          	addi	a3,a3,1898 # ffffffffc020d908 <CSWTCH.79+0x570>
ffffffffc02071a6:	00004617          	auipc	a2,0x4
ffffffffc02071aa:	7e260613          	addi	a2,a2,2018 # ffffffffc020b988 <commands+0x210>
ffffffffc02071ae:	03c00593          	li	a1,60
ffffffffc02071b2:	00006517          	auipc	a0,0x6
ffffffffc02071b6:	78e50513          	addi	a0,a0,1934 # ffffffffc020d940 <CSWTCH.79+0x5a8>
ffffffffc02071ba:	e406                	sd	ra,8(sp)
ffffffffc02071bc:	ae2f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02071c0 <RR_enqueue>:
ffffffffc02071c0:	1185b703          	ld	a4,280(a1)
ffffffffc02071c4:	11058793          	addi	a5,a1,272
ffffffffc02071c8:	02e79d63          	bne	a5,a4,ffffffffc0207202 <RR_enqueue+0x42>
ffffffffc02071cc:	6118                	ld	a4,0(a0)
ffffffffc02071ce:	1205a683          	lw	a3,288(a1)
ffffffffc02071d2:	e11c                	sd	a5,0(a0)
ffffffffc02071d4:	e71c                	sd	a5,8(a4)
ffffffffc02071d6:	10a5bc23          	sd	a0,280(a1)
ffffffffc02071da:	10e5b823          	sd	a4,272(a1)
ffffffffc02071de:	495c                	lw	a5,20(a0)
ffffffffc02071e0:	ea89                	bnez	a3,ffffffffc02071f2 <RR_enqueue+0x32>
ffffffffc02071e2:	12f5a023          	sw	a5,288(a1)
ffffffffc02071e6:	491c                	lw	a5,16(a0)
ffffffffc02071e8:	10a5b423          	sd	a0,264(a1)
ffffffffc02071ec:	2785                	addiw	a5,a5,1
ffffffffc02071ee:	c91c                	sw	a5,16(a0)
ffffffffc02071f0:	8082                	ret
ffffffffc02071f2:	fed7c8e3          	blt	a5,a3,ffffffffc02071e2 <RR_enqueue+0x22>
ffffffffc02071f6:	491c                	lw	a5,16(a0)
ffffffffc02071f8:	10a5b423          	sd	a0,264(a1)
ffffffffc02071fc:	2785                	addiw	a5,a5,1
ffffffffc02071fe:	c91c                	sw	a5,16(a0)
ffffffffc0207200:	8082                	ret
ffffffffc0207202:	1141                	addi	sp,sp,-16
ffffffffc0207204:	00006697          	auipc	a3,0x6
ffffffffc0207208:	75c68693          	addi	a3,a3,1884 # ffffffffc020d960 <CSWTCH.79+0x5c8>
ffffffffc020720c:	00004617          	auipc	a2,0x4
ffffffffc0207210:	77c60613          	addi	a2,a2,1916 # ffffffffc020b988 <commands+0x210>
ffffffffc0207214:	02800593          	li	a1,40
ffffffffc0207218:	00006517          	auipc	a0,0x6
ffffffffc020721c:	72850513          	addi	a0,a0,1832 # ffffffffc020d940 <CSWTCH.79+0x5a8>
ffffffffc0207220:	e406                	sd	ra,8(sp)
ffffffffc0207222:	a7cf90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207226 <sched_init>:
ffffffffc0207226:	1141                	addi	sp,sp,-16
ffffffffc0207228:	0008a717          	auipc	a4,0x8a
ffffffffc020722c:	df870713          	addi	a4,a4,-520 # ffffffffc0291020 <default_sched_class>
ffffffffc0207230:	e022                	sd	s0,0(sp)
ffffffffc0207232:	e406                	sd	ra,8(sp)
ffffffffc0207234:	0008e797          	auipc	a5,0x8e
ffffffffc0207238:	5bc78793          	addi	a5,a5,1468 # ffffffffc02957f0 <timer_list>
ffffffffc020723c:	6714                	ld	a3,8(a4)
ffffffffc020723e:	0008e517          	auipc	a0,0x8e
ffffffffc0207242:	59250513          	addi	a0,a0,1426 # ffffffffc02957d0 <__rq>
ffffffffc0207246:	e79c                	sd	a5,8(a5)
ffffffffc0207248:	e39c                	sd	a5,0(a5)
ffffffffc020724a:	4795                	li	a5,5
ffffffffc020724c:	c95c                	sw	a5,20(a0)
ffffffffc020724e:	0008f417          	auipc	s0,0x8f
ffffffffc0207252:	69a40413          	addi	s0,s0,1690 # ffffffffc02968e8 <sched_class>
ffffffffc0207256:	0008f797          	auipc	a5,0x8f
ffffffffc020725a:	68a7b523          	sd	a0,1674(a5) # ffffffffc02968e0 <rq>
ffffffffc020725e:	e018                	sd	a4,0(s0)
ffffffffc0207260:	9682                	jalr	a3
ffffffffc0207262:	601c                	ld	a5,0(s0)
ffffffffc0207264:	6402                	ld	s0,0(sp)
ffffffffc0207266:	60a2                	ld	ra,8(sp)
ffffffffc0207268:	638c                	ld	a1,0(a5)
ffffffffc020726a:	00006517          	auipc	a0,0x6
ffffffffc020726e:	72650513          	addi	a0,a0,1830 # ffffffffc020d990 <CSWTCH.79+0x5f8>
ffffffffc0207272:	0141                	addi	sp,sp,16
ffffffffc0207274:	f33f806f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0207278 <wakeup_proc>:
ffffffffc0207278:	4118                	lw	a4,0(a0)
ffffffffc020727a:	1101                	addi	sp,sp,-32
ffffffffc020727c:	ec06                	sd	ra,24(sp)
ffffffffc020727e:	e822                	sd	s0,16(sp)
ffffffffc0207280:	e426                	sd	s1,8(sp)
ffffffffc0207282:	478d                	li	a5,3
ffffffffc0207284:	08f70363          	beq	a4,a5,ffffffffc020730a <wakeup_proc+0x92>
ffffffffc0207288:	842a                	mv	s0,a0
ffffffffc020728a:	100027f3          	csrr	a5,sstatus
ffffffffc020728e:	8b89                	andi	a5,a5,2
ffffffffc0207290:	4481                	li	s1,0
ffffffffc0207292:	e7bd                	bnez	a5,ffffffffc0207300 <wakeup_proc+0x88>
ffffffffc0207294:	4789                	li	a5,2
ffffffffc0207296:	04f70863          	beq	a4,a5,ffffffffc02072e6 <wakeup_proc+0x6e>
ffffffffc020729a:	c01c                	sw	a5,0(s0)
ffffffffc020729c:	0e042623          	sw	zero,236(s0)
ffffffffc02072a0:	0008f797          	auipc	a5,0x8f
ffffffffc02072a4:	6207b783          	ld	a5,1568(a5) # ffffffffc02968c0 <current>
ffffffffc02072a8:	02878363          	beq	a5,s0,ffffffffc02072ce <wakeup_proc+0x56>
ffffffffc02072ac:	0008f797          	auipc	a5,0x8f
ffffffffc02072b0:	61c7b783          	ld	a5,1564(a5) # ffffffffc02968c8 <idleproc>
ffffffffc02072b4:	00f40d63          	beq	s0,a5,ffffffffc02072ce <wakeup_proc+0x56>
ffffffffc02072b8:	0008f797          	auipc	a5,0x8f
ffffffffc02072bc:	6307b783          	ld	a5,1584(a5) # ffffffffc02968e8 <sched_class>
ffffffffc02072c0:	6b9c                	ld	a5,16(a5)
ffffffffc02072c2:	85a2                	mv	a1,s0
ffffffffc02072c4:	0008f517          	auipc	a0,0x8f
ffffffffc02072c8:	61c53503          	ld	a0,1564(a0) # ffffffffc02968e0 <rq>
ffffffffc02072cc:	9782                	jalr	a5
ffffffffc02072ce:	e491                	bnez	s1,ffffffffc02072da <wakeup_proc+0x62>
ffffffffc02072d0:	60e2                	ld	ra,24(sp)
ffffffffc02072d2:	6442                	ld	s0,16(sp)
ffffffffc02072d4:	64a2                	ld	s1,8(sp)
ffffffffc02072d6:	6105                	addi	sp,sp,32
ffffffffc02072d8:	8082                	ret
ffffffffc02072da:	6442                	ld	s0,16(sp)
ffffffffc02072dc:	60e2                	ld	ra,24(sp)
ffffffffc02072de:	64a2                	ld	s1,8(sp)
ffffffffc02072e0:	6105                	addi	sp,sp,32
ffffffffc02072e2:	98bf906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc02072e6:	00006617          	auipc	a2,0x6
ffffffffc02072ea:	6fa60613          	addi	a2,a2,1786 # ffffffffc020d9e0 <CSWTCH.79+0x648>
ffffffffc02072ee:	05200593          	li	a1,82
ffffffffc02072f2:	00006517          	auipc	a0,0x6
ffffffffc02072f6:	6d650513          	addi	a0,a0,1750 # ffffffffc020d9c8 <CSWTCH.79+0x630>
ffffffffc02072fa:	a0cf90ef          	jal	ra,ffffffffc0200506 <__warn>
ffffffffc02072fe:	bfc1                	j	ffffffffc02072ce <wakeup_proc+0x56>
ffffffffc0207300:	973f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0207304:	4018                	lw	a4,0(s0)
ffffffffc0207306:	4485                	li	s1,1
ffffffffc0207308:	b771                	j	ffffffffc0207294 <wakeup_proc+0x1c>
ffffffffc020730a:	00006697          	auipc	a3,0x6
ffffffffc020730e:	69e68693          	addi	a3,a3,1694 # ffffffffc020d9a8 <CSWTCH.79+0x610>
ffffffffc0207312:	00004617          	auipc	a2,0x4
ffffffffc0207316:	67660613          	addi	a2,a2,1654 # ffffffffc020b988 <commands+0x210>
ffffffffc020731a:	04300593          	li	a1,67
ffffffffc020731e:	00006517          	auipc	a0,0x6
ffffffffc0207322:	6aa50513          	addi	a0,a0,1706 # ffffffffc020d9c8 <CSWTCH.79+0x630>
ffffffffc0207326:	978f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020732a <schedule>:
ffffffffc020732a:	7179                	addi	sp,sp,-48
ffffffffc020732c:	f406                	sd	ra,40(sp)
ffffffffc020732e:	f022                	sd	s0,32(sp)
ffffffffc0207330:	ec26                	sd	s1,24(sp)
ffffffffc0207332:	e84a                	sd	s2,16(sp)
ffffffffc0207334:	e44e                	sd	s3,8(sp)
ffffffffc0207336:	e052                	sd	s4,0(sp)
ffffffffc0207338:	100027f3          	csrr	a5,sstatus
ffffffffc020733c:	8b89                	andi	a5,a5,2
ffffffffc020733e:	4a01                	li	s4,0
ffffffffc0207340:	e3cd                	bnez	a5,ffffffffc02073e2 <schedule+0xb8>
ffffffffc0207342:	0008f497          	auipc	s1,0x8f
ffffffffc0207346:	57e48493          	addi	s1,s1,1406 # ffffffffc02968c0 <current>
ffffffffc020734a:	608c                	ld	a1,0(s1)
ffffffffc020734c:	0008f997          	auipc	s3,0x8f
ffffffffc0207350:	59c98993          	addi	s3,s3,1436 # ffffffffc02968e8 <sched_class>
ffffffffc0207354:	0008f917          	auipc	s2,0x8f
ffffffffc0207358:	58c90913          	addi	s2,s2,1420 # ffffffffc02968e0 <rq>
ffffffffc020735c:	4194                	lw	a3,0(a1)
ffffffffc020735e:	0005bc23          	sd	zero,24(a1)
ffffffffc0207362:	4709                	li	a4,2
ffffffffc0207364:	0009b783          	ld	a5,0(s3)
ffffffffc0207368:	00093503          	ld	a0,0(s2)
ffffffffc020736c:	04e68e63          	beq	a3,a4,ffffffffc02073c8 <schedule+0x9e>
ffffffffc0207370:	739c                	ld	a5,32(a5)
ffffffffc0207372:	9782                	jalr	a5
ffffffffc0207374:	842a                	mv	s0,a0
ffffffffc0207376:	c521                	beqz	a0,ffffffffc02073be <schedule+0x94>
ffffffffc0207378:	0009b783          	ld	a5,0(s3)
ffffffffc020737c:	00093503          	ld	a0,0(s2)
ffffffffc0207380:	85a2                	mv	a1,s0
ffffffffc0207382:	6f9c                	ld	a5,24(a5)
ffffffffc0207384:	9782                	jalr	a5
ffffffffc0207386:	441c                	lw	a5,8(s0)
ffffffffc0207388:	6098                	ld	a4,0(s1)
ffffffffc020738a:	2785                	addiw	a5,a5,1
ffffffffc020738c:	c41c                	sw	a5,8(s0)
ffffffffc020738e:	00870563          	beq	a4,s0,ffffffffc0207398 <schedule+0x6e>
ffffffffc0207392:	8522                	mv	a0,s0
ffffffffc0207394:	f5afe0ef          	jal	ra,ffffffffc0205aee <proc_run>
ffffffffc0207398:	000a1a63          	bnez	s4,ffffffffc02073ac <schedule+0x82>
ffffffffc020739c:	70a2                	ld	ra,40(sp)
ffffffffc020739e:	7402                	ld	s0,32(sp)
ffffffffc02073a0:	64e2                	ld	s1,24(sp)
ffffffffc02073a2:	6942                	ld	s2,16(sp)
ffffffffc02073a4:	69a2                	ld	s3,8(sp)
ffffffffc02073a6:	6a02                	ld	s4,0(sp)
ffffffffc02073a8:	6145                	addi	sp,sp,48
ffffffffc02073aa:	8082                	ret
ffffffffc02073ac:	7402                	ld	s0,32(sp)
ffffffffc02073ae:	70a2                	ld	ra,40(sp)
ffffffffc02073b0:	64e2                	ld	s1,24(sp)
ffffffffc02073b2:	6942                	ld	s2,16(sp)
ffffffffc02073b4:	69a2                	ld	s3,8(sp)
ffffffffc02073b6:	6a02                	ld	s4,0(sp)
ffffffffc02073b8:	6145                	addi	sp,sp,48
ffffffffc02073ba:	8b3f906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc02073be:	0008f417          	auipc	s0,0x8f
ffffffffc02073c2:	50a43403          	ld	s0,1290(s0) # ffffffffc02968c8 <idleproc>
ffffffffc02073c6:	b7c1                	j	ffffffffc0207386 <schedule+0x5c>
ffffffffc02073c8:	0008f717          	auipc	a4,0x8f
ffffffffc02073cc:	50073703          	ld	a4,1280(a4) # ffffffffc02968c8 <idleproc>
ffffffffc02073d0:	fae580e3          	beq	a1,a4,ffffffffc0207370 <schedule+0x46>
ffffffffc02073d4:	6b9c                	ld	a5,16(a5)
ffffffffc02073d6:	9782                	jalr	a5
ffffffffc02073d8:	0009b783          	ld	a5,0(s3)
ffffffffc02073dc:	00093503          	ld	a0,0(s2)
ffffffffc02073e0:	bf41                	j	ffffffffc0207370 <schedule+0x46>
ffffffffc02073e2:	891f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02073e6:	4a05                	li	s4,1
ffffffffc02073e8:	bfa9                	j	ffffffffc0207342 <schedule+0x18>

ffffffffc02073ea <add_timer>:
ffffffffc02073ea:	1141                	addi	sp,sp,-16
ffffffffc02073ec:	e022                	sd	s0,0(sp)
ffffffffc02073ee:	e406                	sd	ra,8(sp)
ffffffffc02073f0:	842a                	mv	s0,a0
ffffffffc02073f2:	100027f3          	csrr	a5,sstatus
ffffffffc02073f6:	8b89                	andi	a5,a5,2
ffffffffc02073f8:	4501                	li	a0,0
ffffffffc02073fa:	eba5                	bnez	a5,ffffffffc020746a <add_timer+0x80>
ffffffffc02073fc:	401c                	lw	a5,0(s0)
ffffffffc02073fe:	cbb5                	beqz	a5,ffffffffc0207472 <add_timer+0x88>
ffffffffc0207400:	6418                	ld	a4,8(s0)
ffffffffc0207402:	cb25                	beqz	a4,ffffffffc0207472 <add_timer+0x88>
ffffffffc0207404:	6c18                	ld	a4,24(s0)
ffffffffc0207406:	01040593          	addi	a1,s0,16
ffffffffc020740a:	08e59463          	bne	a1,a4,ffffffffc0207492 <add_timer+0xa8>
ffffffffc020740e:	0008e617          	auipc	a2,0x8e
ffffffffc0207412:	3e260613          	addi	a2,a2,994 # ffffffffc02957f0 <timer_list>
ffffffffc0207416:	6618                	ld	a4,8(a2)
ffffffffc0207418:	00c71863          	bne	a4,a2,ffffffffc0207428 <add_timer+0x3e>
ffffffffc020741c:	a80d                	j	ffffffffc020744e <add_timer+0x64>
ffffffffc020741e:	6718                	ld	a4,8(a4)
ffffffffc0207420:	9f95                	subw	a5,a5,a3
ffffffffc0207422:	c01c                	sw	a5,0(s0)
ffffffffc0207424:	02c70563          	beq	a4,a2,ffffffffc020744e <add_timer+0x64>
ffffffffc0207428:	ff072683          	lw	a3,-16(a4)
ffffffffc020742c:	fed7f9e3          	bgeu	a5,a3,ffffffffc020741e <add_timer+0x34>
ffffffffc0207430:	40f687bb          	subw	a5,a3,a5
ffffffffc0207434:	fef72823          	sw	a5,-16(a4)
ffffffffc0207438:	631c                	ld	a5,0(a4)
ffffffffc020743a:	e30c                	sd	a1,0(a4)
ffffffffc020743c:	e78c                	sd	a1,8(a5)
ffffffffc020743e:	ec18                	sd	a4,24(s0)
ffffffffc0207440:	e81c                	sd	a5,16(s0)
ffffffffc0207442:	c105                	beqz	a0,ffffffffc0207462 <add_timer+0x78>
ffffffffc0207444:	6402                	ld	s0,0(sp)
ffffffffc0207446:	60a2                	ld	ra,8(sp)
ffffffffc0207448:	0141                	addi	sp,sp,16
ffffffffc020744a:	823f906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc020744e:	0008e717          	auipc	a4,0x8e
ffffffffc0207452:	3a270713          	addi	a4,a4,930 # ffffffffc02957f0 <timer_list>
ffffffffc0207456:	631c                	ld	a5,0(a4)
ffffffffc0207458:	e30c                	sd	a1,0(a4)
ffffffffc020745a:	e78c                	sd	a1,8(a5)
ffffffffc020745c:	ec18                	sd	a4,24(s0)
ffffffffc020745e:	e81c                	sd	a5,16(s0)
ffffffffc0207460:	f175                	bnez	a0,ffffffffc0207444 <add_timer+0x5a>
ffffffffc0207462:	60a2                	ld	ra,8(sp)
ffffffffc0207464:	6402                	ld	s0,0(sp)
ffffffffc0207466:	0141                	addi	sp,sp,16
ffffffffc0207468:	8082                	ret
ffffffffc020746a:	809f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020746e:	4505                	li	a0,1
ffffffffc0207470:	b771                	j	ffffffffc02073fc <add_timer+0x12>
ffffffffc0207472:	00006697          	auipc	a3,0x6
ffffffffc0207476:	58e68693          	addi	a3,a3,1422 # ffffffffc020da00 <CSWTCH.79+0x668>
ffffffffc020747a:	00004617          	auipc	a2,0x4
ffffffffc020747e:	50e60613          	addi	a2,a2,1294 # ffffffffc020b988 <commands+0x210>
ffffffffc0207482:	07a00593          	li	a1,122
ffffffffc0207486:	00006517          	auipc	a0,0x6
ffffffffc020748a:	54250513          	addi	a0,a0,1346 # ffffffffc020d9c8 <CSWTCH.79+0x630>
ffffffffc020748e:	810f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207492:	00006697          	auipc	a3,0x6
ffffffffc0207496:	59e68693          	addi	a3,a3,1438 # ffffffffc020da30 <CSWTCH.79+0x698>
ffffffffc020749a:	00004617          	auipc	a2,0x4
ffffffffc020749e:	4ee60613          	addi	a2,a2,1262 # ffffffffc020b988 <commands+0x210>
ffffffffc02074a2:	07b00593          	li	a1,123
ffffffffc02074a6:	00006517          	auipc	a0,0x6
ffffffffc02074aa:	52250513          	addi	a0,a0,1314 # ffffffffc020d9c8 <CSWTCH.79+0x630>
ffffffffc02074ae:	ff1f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02074b2 <del_timer>:
ffffffffc02074b2:	1101                	addi	sp,sp,-32
ffffffffc02074b4:	e822                	sd	s0,16(sp)
ffffffffc02074b6:	ec06                	sd	ra,24(sp)
ffffffffc02074b8:	e426                	sd	s1,8(sp)
ffffffffc02074ba:	842a                	mv	s0,a0
ffffffffc02074bc:	100027f3          	csrr	a5,sstatus
ffffffffc02074c0:	8b89                	andi	a5,a5,2
ffffffffc02074c2:	01050493          	addi	s1,a0,16
ffffffffc02074c6:	eb9d                	bnez	a5,ffffffffc02074fc <del_timer+0x4a>
ffffffffc02074c8:	6d1c                	ld	a5,24(a0)
ffffffffc02074ca:	02978463          	beq	a5,s1,ffffffffc02074f2 <del_timer+0x40>
ffffffffc02074ce:	4114                	lw	a3,0(a0)
ffffffffc02074d0:	6918                	ld	a4,16(a0)
ffffffffc02074d2:	ce81                	beqz	a3,ffffffffc02074ea <del_timer+0x38>
ffffffffc02074d4:	0008e617          	auipc	a2,0x8e
ffffffffc02074d8:	31c60613          	addi	a2,a2,796 # ffffffffc02957f0 <timer_list>
ffffffffc02074dc:	00c78763          	beq	a5,a2,ffffffffc02074ea <del_timer+0x38>
ffffffffc02074e0:	ff07a603          	lw	a2,-16(a5)
ffffffffc02074e4:	9eb1                	addw	a3,a3,a2
ffffffffc02074e6:	fed7a823          	sw	a3,-16(a5)
ffffffffc02074ea:	e71c                	sd	a5,8(a4)
ffffffffc02074ec:	e398                	sd	a4,0(a5)
ffffffffc02074ee:	ec04                	sd	s1,24(s0)
ffffffffc02074f0:	e804                	sd	s1,16(s0)
ffffffffc02074f2:	60e2                	ld	ra,24(sp)
ffffffffc02074f4:	6442                	ld	s0,16(sp)
ffffffffc02074f6:	64a2                	ld	s1,8(sp)
ffffffffc02074f8:	6105                	addi	sp,sp,32
ffffffffc02074fa:	8082                	ret
ffffffffc02074fc:	f76f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0207500:	6c1c                	ld	a5,24(s0)
ffffffffc0207502:	02978463          	beq	a5,s1,ffffffffc020752a <del_timer+0x78>
ffffffffc0207506:	4014                	lw	a3,0(s0)
ffffffffc0207508:	6818                	ld	a4,16(s0)
ffffffffc020750a:	ce81                	beqz	a3,ffffffffc0207522 <del_timer+0x70>
ffffffffc020750c:	0008e617          	auipc	a2,0x8e
ffffffffc0207510:	2e460613          	addi	a2,a2,740 # ffffffffc02957f0 <timer_list>
ffffffffc0207514:	00c78763          	beq	a5,a2,ffffffffc0207522 <del_timer+0x70>
ffffffffc0207518:	ff07a603          	lw	a2,-16(a5)
ffffffffc020751c:	9eb1                	addw	a3,a3,a2
ffffffffc020751e:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207522:	e71c                	sd	a5,8(a4)
ffffffffc0207524:	e398                	sd	a4,0(a5)
ffffffffc0207526:	ec04                	sd	s1,24(s0)
ffffffffc0207528:	e804                	sd	s1,16(s0)
ffffffffc020752a:	6442                	ld	s0,16(sp)
ffffffffc020752c:	60e2                	ld	ra,24(sp)
ffffffffc020752e:	64a2                	ld	s1,8(sp)
ffffffffc0207530:	6105                	addi	sp,sp,32
ffffffffc0207532:	f3af906f          	j	ffffffffc0200c6c <intr_enable>

ffffffffc0207536 <run_timer_list>:
ffffffffc0207536:	7139                	addi	sp,sp,-64
ffffffffc0207538:	fc06                	sd	ra,56(sp)
ffffffffc020753a:	f822                	sd	s0,48(sp)
ffffffffc020753c:	f426                	sd	s1,40(sp)
ffffffffc020753e:	f04a                	sd	s2,32(sp)
ffffffffc0207540:	ec4e                	sd	s3,24(sp)
ffffffffc0207542:	e852                	sd	s4,16(sp)
ffffffffc0207544:	e456                	sd	s5,8(sp)
ffffffffc0207546:	e05a                	sd	s6,0(sp)
ffffffffc0207548:	100027f3          	csrr	a5,sstatus
ffffffffc020754c:	8b89                	andi	a5,a5,2
ffffffffc020754e:	4b01                	li	s6,0
ffffffffc0207550:	efe9                	bnez	a5,ffffffffc020762a <run_timer_list+0xf4>
ffffffffc0207552:	0008e997          	auipc	s3,0x8e
ffffffffc0207556:	29e98993          	addi	s3,s3,670 # ffffffffc02957f0 <timer_list>
ffffffffc020755a:	0089b403          	ld	s0,8(s3)
ffffffffc020755e:	07340a63          	beq	s0,s3,ffffffffc02075d2 <run_timer_list+0x9c>
ffffffffc0207562:	ff042783          	lw	a5,-16(s0)
ffffffffc0207566:	ff040913          	addi	s2,s0,-16
ffffffffc020756a:	0e078763          	beqz	a5,ffffffffc0207658 <run_timer_list+0x122>
ffffffffc020756e:	fff7871b          	addiw	a4,a5,-1
ffffffffc0207572:	fee42823          	sw	a4,-16(s0)
ffffffffc0207576:	ef31                	bnez	a4,ffffffffc02075d2 <run_timer_list+0x9c>
ffffffffc0207578:	00006a97          	auipc	s5,0x6
ffffffffc020757c:	520a8a93          	addi	s5,s5,1312 # ffffffffc020da98 <CSWTCH.79+0x700>
ffffffffc0207580:	00006a17          	auipc	s4,0x6
ffffffffc0207584:	448a0a13          	addi	s4,s4,1096 # ffffffffc020d9c8 <CSWTCH.79+0x630>
ffffffffc0207588:	a005                	j	ffffffffc02075a8 <run_timer_list+0x72>
ffffffffc020758a:	0a07d763          	bgez	a5,ffffffffc0207638 <run_timer_list+0x102>
ffffffffc020758e:	8526                	mv	a0,s1
ffffffffc0207590:	ce9ff0ef          	jal	ra,ffffffffc0207278 <wakeup_proc>
ffffffffc0207594:	854a                	mv	a0,s2
ffffffffc0207596:	f1dff0ef          	jal	ra,ffffffffc02074b2 <del_timer>
ffffffffc020759a:	03340c63          	beq	s0,s3,ffffffffc02075d2 <run_timer_list+0x9c>
ffffffffc020759e:	ff042783          	lw	a5,-16(s0)
ffffffffc02075a2:	ff040913          	addi	s2,s0,-16
ffffffffc02075a6:	e795                	bnez	a5,ffffffffc02075d2 <run_timer_list+0x9c>
ffffffffc02075a8:	00893483          	ld	s1,8(s2)
ffffffffc02075ac:	6400                	ld	s0,8(s0)
ffffffffc02075ae:	0ec4a783          	lw	a5,236(s1)
ffffffffc02075b2:	ffe1                	bnez	a5,ffffffffc020758a <run_timer_list+0x54>
ffffffffc02075b4:	40d4                	lw	a3,4(s1)
ffffffffc02075b6:	8656                	mv	a2,s5
ffffffffc02075b8:	0ba00593          	li	a1,186
ffffffffc02075bc:	8552                	mv	a0,s4
ffffffffc02075be:	f49f80ef          	jal	ra,ffffffffc0200506 <__warn>
ffffffffc02075c2:	8526                	mv	a0,s1
ffffffffc02075c4:	cb5ff0ef          	jal	ra,ffffffffc0207278 <wakeup_proc>
ffffffffc02075c8:	854a                	mv	a0,s2
ffffffffc02075ca:	ee9ff0ef          	jal	ra,ffffffffc02074b2 <del_timer>
ffffffffc02075ce:	fd3418e3          	bne	s0,s3,ffffffffc020759e <run_timer_list+0x68>
ffffffffc02075d2:	0008f597          	auipc	a1,0x8f
ffffffffc02075d6:	2ee5b583          	ld	a1,750(a1) # ffffffffc02968c0 <current>
ffffffffc02075da:	c18d                	beqz	a1,ffffffffc02075fc <run_timer_list+0xc6>
ffffffffc02075dc:	0008f797          	auipc	a5,0x8f
ffffffffc02075e0:	2ec7b783          	ld	a5,748(a5) # ffffffffc02968c8 <idleproc>
ffffffffc02075e4:	04f58763          	beq	a1,a5,ffffffffc0207632 <run_timer_list+0xfc>
ffffffffc02075e8:	0008f797          	auipc	a5,0x8f
ffffffffc02075ec:	3007b783          	ld	a5,768(a5) # ffffffffc02968e8 <sched_class>
ffffffffc02075f0:	779c                	ld	a5,40(a5)
ffffffffc02075f2:	0008f517          	auipc	a0,0x8f
ffffffffc02075f6:	2ee53503          	ld	a0,750(a0) # ffffffffc02968e0 <rq>
ffffffffc02075fa:	9782                	jalr	a5
ffffffffc02075fc:	000b1c63          	bnez	s6,ffffffffc0207614 <run_timer_list+0xde>
ffffffffc0207600:	70e2                	ld	ra,56(sp)
ffffffffc0207602:	7442                	ld	s0,48(sp)
ffffffffc0207604:	74a2                	ld	s1,40(sp)
ffffffffc0207606:	7902                	ld	s2,32(sp)
ffffffffc0207608:	69e2                	ld	s3,24(sp)
ffffffffc020760a:	6a42                	ld	s4,16(sp)
ffffffffc020760c:	6aa2                	ld	s5,8(sp)
ffffffffc020760e:	6b02                	ld	s6,0(sp)
ffffffffc0207610:	6121                	addi	sp,sp,64
ffffffffc0207612:	8082                	ret
ffffffffc0207614:	7442                	ld	s0,48(sp)
ffffffffc0207616:	70e2                	ld	ra,56(sp)
ffffffffc0207618:	74a2                	ld	s1,40(sp)
ffffffffc020761a:	7902                	ld	s2,32(sp)
ffffffffc020761c:	69e2                	ld	s3,24(sp)
ffffffffc020761e:	6a42                	ld	s4,16(sp)
ffffffffc0207620:	6aa2                	ld	s5,8(sp)
ffffffffc0207622:	6b02                	ld	s6,0(sp)
ffffffffc0207624:	6121                	addi	sp,sp,64
ffffffffc0207626:	e46f906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc020762a:	e48f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020762e:	4b05                	li	s6,1
ffffffffc0207630:	b70d                	j	ffffffffc0207552 <run_timer_list+0x1c>
ffffffffc0207632:	4785                	li	a5,1
ffffffffc0207634:	ed9c                	sd	a5,24(a1)
ffffffffc0207636:	b7d9                	j	ffffffffc02075fc <run_timer_list+0xc6>
ffffffffc0207638:	00006697          	auipc	a3,0x6
ffffffffc020763c:	43868693          	addi	a3,a3,1080 # ffffffffc020da70 <CSWTCH.79+0x6d8>
ffffffffc0207640:	00004617          	auipc	a2,0x4
ffffffffc0207644:	34860613          	addi	a2,a2,840 # ffffffffc020b988 <commands+0x210>
ffffffffc0207648:	0b600593          	li	a1,182
ffffffffc020764c:	00006517          	auipc	a0,0x6
ffffffffc0207650:	37c50513          	addi	a0,a0,892 # ffffffffc020d9c8 <CSWTCH.79+0x630>
ffffffffc0207654:	e4bf80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207658:	00006697          	auipc	a3,0x6
ffffffffc020765c:	40068693          	addi	a3,a3,1024 # ffffffffc020da58 <CSWTCH.79+0x6c0>
ffffffffc0207660:	00004617          	auipc	a2,0x4
ffffffffc0207664:	32860613          	addi	a2,a2,808 # ffffffffc020b988 <commands+0x210>
ffffffffc0207668:	0ae00593          	li	a1,174
ffffffffc020766c:	00006517          	auipc	a0,0x6
ffffffffc0207670:	35c50513          	addi	a0,a0,860 # ffffffffc020d9c8 <CSWTCH.79+0x630>
ffffffffc0207674:	e2bf80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207678 <sys_getpid>:
ffffffffc0207678:	0008f797          	auipc	a5,0x8f
ffffffffc020767c:	2487b783          	ld	a5,584(a5) # ffffffffc02968c0 <current>
ffffffffc0207680:	43c8                	lw	a0,4(a5)
ffffffffc0207682:	8082                	ret

ffffffffc0207684 <sys_pgdir>:
ffffffffc0207684:	4501                	li	a0,0
ffffffffc0207686:	8082                	ret

ffffffffc0207688 <sys_gettime>:
ffffffffc0207688:	0008f797          	auipc	a5,0x8f
ffffffffc020768c:	1e87b783          	ld	a5,488(a5) # ffffffffc0296870 <ticks>
ffffffffc0207690:	0027951b          	slliw	a0,a5,0x2
ffffffffc0207694:	9d3d                	addw	a0,a0,a5
ffffffffc0207696:	0015151b          	slliw	a0,a0,0x1
ffffffffc020769a:	8082                	ret

ffffffffc020769c <sys_lab6_set_priority>:
ffffffffc020769c:	4108                	lw	a0,0(a0)
ffffffffc020769e:	1141                	addi	sp,sp,-16
ffffffffc02076a0:	e406                	sd	ra,8(sp)
ffffffffc02076a2:	975ff0ef          	jal	ra,ffffffffc0207016 <lab6_set_priority>
ffffffffc02076a6:	60a2                	ld	ra,8(sp)
ffffffffc02076a8:	4501                	li	a0,0
ffffffffc02076aa:	0141                	addi	sp,sp,16
ffffffffc02076ac:	8082                	ret

ffffffffc02076ae <sys_dup>:
ffffffffc02076ae:	450c                	lw	a1,8(a0)
ffffffffc02076b0:	4108                	lw	a0,0(a0)
ffffffffc02076b2:	b16fe06f          	j	ffffffffc02059c8 <sysfile_dup>

ffffffffc02076b6 <sys_getdirentry>:
ffffffffc02076b6:	650c                	ld	a1,8(a0)
ffffffffc02076b8:	4108                	lw	a0,0(a0)
ffffffffc02076ba:	a1efe06f          	j	ffffffffc02058d8 <sysfile_getdirentry>

ffffffffc02076be <sys_getcwd>:
ffffffffc02076be:	650c                	ld	a1,8(a0)
ffffffffc02076c0:	6108                	ld	a0,0(a0)
ffffffffc02076c2:	972fe06f          	j	ffffffffc0205834 <sysfile_getcwd>

ffffffffc02076c6 <sys_fsync>:
ffffffffc02076c6:	4108                	lw	a0,0(a0)
ffffffffc02076c8:	968fe06f          	j	ffffffffc0205830 <sysfile_fsync>

ffffffffc02076cc <sys_fstat>:
ffffffffc02076cc:	650c                	ld	a1,8(a0)
ffffffffc02076ce:	4108                	lw	a0,0(a0)
ffffffffc02076d0:	8c0fe06f          	j	ffffffffc0205790 <sysfile_fstat>

ffffffffc02076d4 <sys_seek>:
ffffffffc02076d4:	4910                	lw	a2,16(a0)
ffffffffc02076d6:	650c                	ld	a1,8(a0)
ffffffffc02076d8:	4108                	lw	a0,0(a0)
ffffffffc02076da:	8b2fe06f          	j	ffffffffc020578c <sysfile_seek>

ffffffffc02076de <sys_write>:
ffffffffc02076de:	6910                	ld	a2,16(a0)
ffffffffc02076e0:	650c                	ld	a1,8(a0)
ffffffffc02076e2:	4108                	lw	a0,0(a0)
ffffffffc02076e4:	f8ffd06f          	j	ffffffffc0205672 <sysfile_write>

ffffffffc02076e8 <sys_read>:
ffffffffc02076e8:	6910                	ld	a2,16(a0)
ffffffffc02076ea:	650c                	ld	a1,8(a0)
ffffffffc02076ec:	4108                	lw	a0,0(a0)
ffffffffc02076ee:	e71fd06f          	j	ffffffffc020555e <sysfile_read>

ffffffffc02076f2 <sys_close>:
ffffffffc02076f2:	4108                	lw	a0,0(a0)
ffffffffc02076f4:	e67fd06f          	j	ffffffffc020555a <sysfile_close>

ffffffffc02076f8 <sys_open>:
ffffffffc02076f8:	450c                	lw	a1,8(a0)
ffffffffc02076fa:	6108                	ld	a0,0(a0)
ffffffffc02076fc:	e2bfd06f          	j	ffffffffc0205526 <sysfile_open>

ffffffffc0207700 <sys_putc>:
ffffffffc0207700:	4108                	lw	a0,0(a0)
ffffffffc0207702:	1141                	addi	sp,sp,-16
ffffffffc0207704:	e406                	sd	ra,8(sp)
ffffffffc0207706:	addf80ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc020770a:	60a2                	ld	ra,8(sp)
ffffffffc020770c:	4501                	li	a0,0
ffffffffc020770e:	0141                	addi	sp,sp,16
ffffffffc0207710:	8082                	ret

ffffffffc0207712 <sys_kill>:
ffffffffc0207712:	4108                	lw	a0,0(a0)
ffffffffc0207714:	ea0ff06f          	j	ffffffffc0206db4 <do_kill>

ffffffffc0207718 <sys_sleep>:
ffffffffc0207718:	4108                	lw	a0,0(a0)
ffffffffc020771a:	937ff06f          	j	ffffffffc0207050 <do_sleep>

ffffffffc020771e <sys_yield>:
ffffffffc020771e:	e48ff06f          	j	ffffffffc0206d66 <do_yield>

ffffffffc0207722 <sys_exec>:
ffffffffc0207722:	6910                	ld	a2,16(a0)
ffffffffc0207724:	450c                	lw	a1,8(a0)
ffffffffc0207726:	6108                	ld	a0,0(a0)
ffffffffc0207728:	d59fe06f          	j	ffffffffc0206480 <do_execve>

ffffffffc020772c <sys_wait>:
ffffffffc020772c:	650c                	ld	a1,8(a0)
ffffffffc020772e:	4108                	lw	a0,0(a0)
ffffffffc0207730:	e46ff06f          	j	ffffffffc0206d76 <do_wait>

ffffffffc0207734 <sys_fork>:
ffffffffc0207734:	0008f797          	auipc	a5,0x8f
ffffffffc0207738:	18c7b783          	ld	a5,396(a5) # ffffffffc02968c0 <current>
ffffffffc020773c:	73d0                	ld	a2,160(a5)
ffffffffc020773e:	4501                	li	a0,0
ffffffffc0207740:	6a0c                	ld	a1,16(a2)
ffffffffc0207742:	c1cfe06f          	j	ffffffffc0205b5e <do_fork>

ffffffffc0207746 <sys_exit>:
ffffffffc0207746:	4108                	lw	a0,0(a0)
ffffffffc0207748:	8b5fe06f          	j	ffffffffc0205ffc <do_exit>

ffffffffc020774c <syscall>:
ffffffffc020774c:	715d                	addi	sp,sp,-80
ffffffffc020774e:	fc26                	sd	s1,56(sp)
ffffffffc0207750:	0008f497          	auipc	s1,0x8f
ffffffffc0207754:	17048493          	addi	s1,s1,368 # ffffffffc02968c0 <current>
ffffffffc0207758:	6098                	ld	a4,0(s1)
ffffffffc020775a:	e0a2                	sd	s0,64(sp)
ffffffffc020775c:	f84a                	sd	s2,48(sp)
ffffffffc020775e:	7340                	ld	s0,160(a4)
ffffffffc0207760:	e486                	sd	ra,72(sp)
ffffffffc0207762:	0ff00793          	li	a5,255
ffffffffc0207766:	05042903          	lw	s2,80(s0)
ffffffffc020776a:	0327ee63          	bltu	a5,s2,ffffffffc02077a6 <syscall+0x5a>
ffffffffc020776e:	00391713          	slli	a4,s2,0x3
ffffffffc0207772:	00006797          	auipc	a5,0x6
ffffffffc0207776:	38e78793          	addi	a5,a5,910 # ffffffffc020db00 <syscalls>
ffffffffc020777a:	97ba                	add	a5,a5,a4
ffffffffc020777c:	639c                	ld	a5,0(a5)
ffffffffc020777e:	c785                	beqz	a5,ffffffffc02077a6 <syscall+0x5a>
ffffffffc0207780:	6c28                	ld	a0,88(s0)
ffffffffc0207782:	702c                	ld	a1,96(s0)
ffffffffc0207784:	7430                	ld	a2,104(s0)
ffffffffc0207786:	7834                	ld	a3,112(s0)
ffffffffc0207788:	7c38                	ld	a4,120(s0)
ffffffffc020778a:	e42a                	sd	a0,8(sp)
ffffffffc020778c:	e82e                	sd	a1,16(sp)
ffffffffc020778e:	ec32                	sd	a2,24(sp)
ffffffffc0207790:	f036                	sd	a3,32(sp)
ffffffffc0207792:	f43a                	sd	a4,40(sp)
ffffffffc0207794:	0028                	addi	a0,sp,8
ffffffffc0207796:	9782                	jalr	a5
ffffffffc0207798:	60a6                	ld	ra,72(sp)
ffffffffc020779a:	e828                	sd	a0,80(s0)
ffffffffc020779c:	6406                	ld	s0,64(sp)
ffffffffc020779e:	74e2                	ld	s1,56(sp)
ffffffffc02077a0:	7942                	ld	s2,48(sp)
ffffffffc02077a2:	6161                	addi	sp,sp,80
ffffffffc02077a4:	8082                	ret
ffffffffc02077a6:	8522                	mv	a0,s0
ffffffffc02077a8:	fe2f90ef          	jal	ra,ffffffffc0200f8a <print_trapframe>
ffffffffc02077ac:	609c                	ld	a5,0(s1)
ffffffffc02077ae:	86ca                	mv	a3,s2
ffffffffc02077b0:	00006617          	auipc	a2,0x6
ffffffffc02077b4:	30860613          	addi	a2,a2,776 # ffffffffc020dab8 <CSWTCH.79+0x720>
ffffffffc02077b8:	43d8                	lw	a4,4(a5)
ffffffffc02077ba:	0d800593          	li	a1,216
ffffffffc02077be:	0b478793          	addi	a5,a5,180
ffffffffc02077c2:	00006517          	auipc	a0,0x6
ffffffffc02077c6:	32650513          	addi	a0,a0,806 # ffffffffc020dae8 <CSWTCH.79+0x750>
ffffffffc02077ca:	cd5f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02077ce <__alloc_inode>:
ffffffffc02077ce:	1141                	addi	sp,sp,-16
ffffffffc02077d0:	e022                	sd	s0,0(sp)
ffffffffc02077d2:	842a                	mv	s0,a0
ffffffffc02077d4:	07800513          	li	a0,120
ffffffffc02077d8:	e406                	sd	ra,8(sp)
ffffffffc02077da:	fb4fa0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc02077de:	c111                	beqz	a0,ffffffffc02077e2 <__alloc_inode+0x14>
ffffffffc02077e0:	cd20                	sw	s0,88(a0)
ffffffffc02077e2:	60a2                	ld	ra,8(sp)
ffffffffc02077e4:	6402                	ld	s0,0(sp)
ffffffffc02077e6:	0141                	addi	sp,sp,16
ffffffffc02077e8:	8082                	ret

ffffffffc02077ea <inode_init>:
ffffffffc02077ea:	4785                	li	a5,1
ffffffffc02077ec:	06052023          	sw	zero,96(a0)
ffffffffc02077f0:	f92c                	sd	a1,112(a0)
ffffffffc02077f2:	f530                	sd	a2,104(a0)
ffffffffc02077f4:	cd7c                	sw	a5,92(a0)
ffffffffc02077f6:	8082                	ret

ffffffffc02077f8 <inode_kill>:
ffffffffc02077f8:	4d78                	lw	a4,92(a0)
ffffffffc02077fa:	1141                	addi	sp,sp,-16
ffffffffc02077fc:	e406                	sd	ra,8(sp)
ffffffffc02077fe:	e719                	bnez	a4,ffffffffc020780c <inode_kill+0x14>
ffffffffc0207800:	513c                	lw	a5,96(a0)
ffffffffc0207802:	e78d                	bnez	a5,ffffffffc020782c <inode_kill+0x34>
ffffffffc0207804:	60a2                	ld	ra,8(sp)
ffffffffc0207806:	0141                	addi	sp,sp,16
ffffffffc0207808:	837fa06f          	j	ffffffffc020203e <kfree>
ffffffffc020780c:	00007697          	auipc	a3,0x7
ffffffffc0207810:	af468693          	addi	a3,a3,-1292 # ffffffffc020e300 <syscalls+0x800>
ffffffffc0207814:	00004617          	auipc	a2,0x4
ffffffffc0207818:	17460613          	addi	a2,a2,372 # ffffffffc020b988 <commands+0x210>
ffffffffc020781c:	02900593          	li	a1,41
ffffffffc0207820:	00007517          	auipc	a0,0x7
ffffffffc0207824:	b0050513          	addi	a0,a0,-1280 # ffffffffc020e320 <syscalls+0x820>
ffffffffc0207828:	c77f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020782c:	00007697          	auipc	a3,0x7
ffffffffc0207830:	b0c68693          	addi	a3,a3,-1268 # ffffffffc020e338 <syscalls+0x838>
ffffffffc0207834:	00004617          	auipc	a2,0x4
ffffffffc0207838:	15460613          	addi	a2,a2,340 # ffffffffc020b988 <commands+0x210>
ffffffffc020783c:	02a00593          	li	a1,42
ffffffffc0207840:	00007517          	auipc	a0,0x7
ffffffffc0207844:	ae050513          	addi	a0,a0,-1312 # ffffffffc020e320 <syscalls+0x820>
ffffffffc0207848:	c57f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020784c <inode_ref_inc>:
ffffffffc020784c:	4d7c                	lw	a5,92(a0)
ffffffffc020784e:	2785                	addiw	a5,a5,1
ffffffffc0207850:	cd7c                	sw	a5,92(a0)
ffffffffc0207852:	0007851b          	sext.w	a0,a5
ffffffffc0207856:	8082                	ret

ffffffffc0207858 <inode_open_inc>:
ffffffffc0207858:	513c                	lw	a5,96(a0)
ffffffffc020785a:	2785                	addiw	a5,a5,1
ffffffffc020785c:	d13c                	sw	a5,96(a0)
ffffffffc020785e:	0007851b          	sext.w	a0,a5
ffffffffc0207862:	8082                	ret

ffffffffc0207864 <inode_check>:
ffffffffc0207864:	1141                	addi	sp,sp,-16
ffffffffc0207866:	e406                	sd	ra,8(sp)
ffffffffc0207868:	c90d                	beqz	a0,ffffffffc020789a <inode_check+0x36>
ffffffffc020786a:	793c                	ld	a5,112(a0)
ffffffffc020786c:	c79d                	beqz	a5,ffffffffc020789a <inode_check+0x36>
ffffffffc020786e:	6398                	ld	a4,0(a5)
ffffffffc0207870:	4625d7b7          	lui	a5,0x4625d
ffffffffc0207874:	0786                	slli	a5,a5,0x1
ffffffffc0207876:	47678793          	addi	a5,a5,1142 # 4625d476 <_binary_bin_sfs_img_size+0x461e8176>
ffffffffc020787a:	08f71063          	bne	a4,a5,ffffffffc02078fa <inode_check+0x96>
ffffffffc020787e:	4d78                	lw	a4,92(a0)
ffffffffc0207880:	513c                	lw	a5,96(a0)
ffffffffc0207882:	04f74c63          	blt	a4,a5,ffffffffc02078da <inode_check+0x76>
ffffffffc0207886:	0407ca63          	bltz	a5,ffffffffc02078da <inode_check+0x76>
ffffffffc020788a:	66c1                	lui	a3,0x10
ffffffffc020788c:	02d75763          	bge	a4,a3,ffffffffc02078ba <inode_check+0x56>
ffffffffc0207890:	02d7d563          	bge	a5,a3,ffffffffc02078ba <inode_check+0x56>
ffffffffc0207894:	60a2                	ld	ra,8(sp)
ffffffffc0207896:	0141                	addi	sp,sp,16
ffffffffc0207898:	8082                	ret
ffffffffc020789a:	00007697          	auipc	a3,0x7
ffffffffc020789e:	abe68693          	addi	a3,a3,-1346 # ffffffffc020e358 <syscalls+0x858>
ffffffffc02078a2:	00004617          	auipc	a2,0x4
ffffffffc02078a6:	0e660613          	addi	a2,a2,230 # ffffffffc020b988 <commands+0x210>
ffffffffc02078aa:	06e00593          	li	a1,110
ffffffffc02078ae:	00007517          	auipc	a0,0x7
ffffffffc02078b2:	a7250513          	addi	a0,a0,-1422 # ffffffffc020e320 <syscalls+0x820>
ffffffffc02078b6:	be9f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02078ba:	00007697          	auipc	a3,0x7
ffffffffc02078be:	b1e68693          	addi	a3,a3,-1250 # ffffffffc020e3d8 <syscalls+0x8d8>
ffffffffc02078c2:	00004617          	auipc	a2,0x4
ffffffffc02078c6:	0c660613          	addi	a2,a2,198 # ffffffffc020b988 <commands+0x210>
ffffffffc02078ca:	07200593          	li	a1,114
ffffffffc02078ce:	00007517          	auipc	a0,0x7
ffffffffc02078d2:	a5250513          	addi	a0,a0,-1454 # ffffffffc020e320 <syscalls+0x820>
ffffffffc02078d6:	bc9f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02078da:	00007697          	auipc	a3,0x7
ffffffffc02078de:	ace68693          	addi	a3,a3,-1330 # ffffffffc020e3a8 <syscalls+0x8a8>
ffffffffc02078e2:	00004617          	auipc	a2,0x4
ffffffffc02078e6:	0a660613          	addi	a2,a2,166 # ffffffffc020b988 <commands+0x210>
ffffffffc02078ea:	07100593          	li	a1,113
ffffffffc02078ee:	00007517          	auipc	a0,0x7
ffffffffc02078f2:	a3250513          	addi	a0,a0,-1486 # ffffffffc020e320 <syscalls+0x820>
ffffffffc02078f6:	ba9f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02078fa:	00007697          	auipc	a3,0x7
ffffffffc02078fe:	a8668693          	addi	a3,a3,-1402 # ffffffffc020e380 <syscalls+0x880>
ffffffffc0207902:	00004617          	auipc	a2,0x4
ffffffffc0207906:	08660613          	addi	a2,a2,134 # ffffffffc020b988 <commands+0x210>
ffffffffc020790a:	06f00593          	li	a1,111
ffffffffc020790e:	00007517          	auipc	a0,0x7
ffffffffc0207912:	a1250513          	addi	a0,a0,-1518 # ffffffffc020e320 <syscalls+0x820>
ffffffffc0207916:	b89f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020791a <inode_ref_dec>:
ffffffffc020791a:	4d7c                	lw	a5,92(a0)
ffffffffc020791c:	1101                	addi	sp,sp,-32
ffffffffc020791e:	ec06                	sd	ra,24(sp)
ffffffffc0207920:	e822                	sd	s0,16(sp)
ffffffffc0207922:	e426                	sd	s1,8(sp)
ffffffffc0207924:	e04a                	sd	s2,0(sp)
ffffffffc0207926:	06f05e63          	blez	a5,ffffffffc02079a2 <inode_ref_dec+0x88>
ffffffffc020792a:	fff7849b          	addiw	s1,a5,-1
ffffffffc020792e:	cd64                	sw	s1,92(a0)
ffffffffc0207930:	842a                	mv	s0,a0
ffffffffc0207932:	e09d                	bnez	s1,ffffffffc0207958 <inode_ref_dec+0x3e>
ffffffffc0207934:	793c                	ld	a5,112(a0)
ffffffffc0207936:	c7b1                	beqz	a5,ffffffffc0207982 <inode_ref_dec+0x68>
ffffffffc0207938:	0487b903          	ld	s2,72(a5)
ffffffffc020793c:	04090363          	beqz	s2,ffffffffc0207982 <inode_ref_dec+0x68>
ffffffffc0207940:	00007597          	auipc	a1,0x7
ffffffffc0207944:	b4858593          	addi	a1,a1,-1208 # ffffffffc020e488 <syscalls+0x988>
ffffffffc0207948:	f1dff0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc020794c:	8522                	mv	a0,s0
ffffffffc020794e:	9902                	jalr	s2
ffffffffc0207950:	c501                	beqz	a0,ffffffffc0207958 <inode_ref_dec+0x3e>
ffffffffc0207952:	57c5                	li	a5,-15
ffffffffc0207954:	00f51963          	bne	a0,a5,ffffffffc0207966 <inode_ref_dec+0x4c>
ffffffffc0207958:	60e2                	ld	ra,24(sp)
ffffffffc020795a:	6442                	ld	s0,16(sp)
ffffffffc020795c:	6902                	ld	s2,0(sp)
ffffffffc020795e:	8526                	mv	a0,s1
ffffffffc0207960:	64a2                	ld	s1,8(sp)
ffffffffc0207962:	6105                	addi	sp,sp,32
ffffffffc0207964:	8082                	ret
ffffffffc0207966:	85aa                	mv	a1,a0
ffffffffc0207968:	00007517          	auipc	a0,0x7
ffffffffc020796c:	b2850513          	addi	a0,a0,-1240 # ffffffffc020e490 <syscalls+0x990>
ffffffffc0207970:	837f80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0207974:	60e2                	ld	ra,24(sp)
ffffffffc0207976:	6442                	ld	s0,16(sp)
ffffffffc0207978:	6902                	ld	s2,0(sp)
ffffffffc020797a:	8526                	mv	a0,s1
ffffffffc020797c:	64a2                	ld	s1,8(sp)
ffffffffc020797e:	6105                	addi	sp,sp,32
ffffffffc0207980:	8082                	ret
ffffffffc0207982:	00007697          	auipc	a3,0x7
ffffffffc0207986:	ab668693          	addi	a3,a3,-1354 # ffffffffc020e438 <syscalls+0x938>
ffffffffc020798a:	00004617          	auipc	a2,0x4
ffffffffc020798e:	ffe60613          	addi	a2,a2,-2 # ffffffffc020b988 <commands+0x210>
ffffffffc0207992:	04400593          	li	a1,68
ffffffffc0207996:	00007517          	auipc	a0,0x7
ffffffffc020799a:	98a50513          	addi	a0,a0,-1654 # ffffffffc020e320 <syscalls+0x820>
ffffffffc020799e:	b01f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02079a2:	00007697          	auipc	a3,0x7
ffffffffc02079a6:	a7668693          	addi	a3,a3,-1418 # ffffffffc020e418 <syscalls+0x918>
ffffffffc02079aa:	00004617          	auipc	a2,0x4
ffffffffc02079ae:	fde60613          	addi	a2,a2,-34 # ffffffffc020b988 <commands+0x210>
ffffffffc02079b2:	03f00593          	li	a1,63
ffffffffc02079b6:	00007517          	auipc	a0,0x7
ffffffffc02079ba:	96a50513          	addi	a0,a0,-1686 # ffffffffc020e320 <syscalls+0x820>
ffffffffc02079be:	ae1f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02079c2 <inode_open_dec>:
ffffffffc02079c2:	513c                	lw	a5,96(a0)
ffffffffc02079c4:	1101                	addi	sp,sp,-32
ffffffffc02079c6:	ec06                	sd	ra,24(sp)
ffffffffc02079c8:	e822                	sd	s0,16(sp)
ffffffffc02079ca:	e426                	sd	s1,8(sp)
ffffffffc02079cc:	e04a                	sd	s2,0(sp)
ffffffffc02079ce:	06f05b63          	blez	a5,ffffffffc0207a44 <inode_open_dec+0x82>
ffffffffc02079d2:	fff7849b          	addiw	s1,a5,-1
ffffffffc02079d6:	d124                	sw	s1,96(a0)
ffffffffc02079d8:	842a                	mv	s0,a0
ffffffffc02079da:	e085                	bnez	s1,ffffffffc02079fa <inode_open_dec+0x38>
ffffffffc02079dc:	793c                	ld	a5,112(a0)
ffffffffc02079de:	c3b9                	beqz	a5,ffffffffc0207a24 <inode_open_dec+0x62>
ffffffffc02079e0:	0107b903          	ld	s2,16(a5)
ffffffffc02079e4:	04090063          	beqz	s2,ffffffffc0207a24 <inode_open_dec+0x62>
ffffffffc02079e8:	00007597          	auipc	a1,0x7
ffffffffc02079ec:	b3858593          	addi	a1,a1,-1224 # ffffffffc020e520 <syscalls+0xa20>
ffffffffc02079f0:	e75ff0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc02079f4:	8522                	mv	a0,s0
ffffffffc02079f6:	9902                	jalr	s2
ffffffffc02079f8:	e901                	bnez	a0,ffffffffc0207a08 <inode_open_dec+0x46>
ffffffffc02079fa:	60e2                	ld	ra,24(sp)
ffffffffc02079fc:	6442                	ld	s0,16(sp)
ffffffffc02079fe:	6902                	ld	s2,0(sp)
ffffffffc0207a00:	8526                	mv	a0,s1
ffffffffc0207a02:	64a2                	ld	s1,8(sp)
ffffffffc0207a04:	6105                	addi	sp,sp,32
ffffffffc0207a06:	8082                	ret
ffffffffc0207a08:	85aa                	mv	a1,a0
ffffffffc0207a0a:	00007517          	auipc	a0,0x7
ffffffffc0207a0e:	b1e50513          	addi	a0,a0,-1250 # ffffffffc020e528 <syscalls+0xa28>
ffffffffc0207a12:	f94f80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0207a16:	60e2                	ld	ra,24(sp)
ffffffffc0207a18:	6442                	ld	s0,16(sp)
ffffffffc0207a1a:	6902                	ld	s2,0(sp)
ffffffffc0207a1c:	8526                	mv	a0,s1
ffffffffc0207a1e:	64a2                	ld	s1,8(sp)
ffffffffc0207a20:	6105                	addi	sp,sp,32
ffffffffc0207a22:	8082                	ret
ffffffffc0207a24:	00007697          	auipc	a3,0x7
ffffffffc0207a28:	aac68693          	addi	a3,a3,-1364 # ffffffffc020e4d0 <syscalls+0x9d0>
ffffffffc0207a2c:	00004617          	auipc	a2,0x4
ffffffffc0207a30:	f5c60613          	addi	a2,a2,-164 # ffffffffc020b988 <commands+0x210>
ffffffffc0207a34:	06100593          	li	a1,97
ffffffffc0207a38:	00007517          	auipc	a0,0x7
ffffffffc0207a3c:	8e850513          	addi	a0,a0,-1816 # ffffffffc020e320 <syscalls+0x820>
ffffffffc0207a40:	a5ff80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207a44:	00007697          	auipc	a3,0x7
ffffffffc0207a48:	a6c68693          	addi	a3,a3,-1428 # ffffffffc020e4b0 <syscalls+0x9b0>
ffffffffc0207a4c:	00004617          	auipc	a2,0x4
ffffffffc0207a50:	f3c60613          	addi	a2,a2,-196 # ffffffffc020b988 <commands+0x210>
ffffffffc0207a54:	05c00593          	li	a1,92
ffffffffc0207a58:	00007517          	auipc	a0,0x7
ffffffffc0207a5c:	8c850513          	addi	a0,a0,-1848 # ffffffffc020e320 <syscalls+0x820>
ffffffffc0207a60:	a3ff80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207a64 <__alloc_fs>:
ffffffffc0207a64:	1141                	addi	sp,sp,-16
ffffffffc0207a66:	e022                	sd	s0,0(sp)
ffffffffc0207a68:	842a                	mv	s0,a0
ffffffffc0207a6a:	0d800513          	li	a0,216
ffffffffc0207a6e:	e406                	sd	ra,8(sp)
ffffffffc0207a70:	d1efa0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0207a74:	c119                	beqz	a0,ffffffffc0207a7a <__alloc_fs+0x16>
ffffffffc0207a76:	0a852823          	sw	s0,176(a0)
ffffffffc0207a7a:	60a2                	ld	ra,8(sp)
ffffffffc0207a7c:	6402                	ld	s0,0(sp)
ffffffffc0207a7e:	0141                	addi	sp,sp,16
ffffffffc0207a80:	8082                	ret

ffffffffc0207a82 <vfs_init>:
ffffffffc0207a82:	1141                	addi	sp,sp,-16
ffffffffc0207a84:	4585                	li	a1,1
ffffffffc0207a86:	0008e517          	auipc	a0,0x8e
ffffffffc0207a8a:	d7a50513          	addi	a0,a0,-646 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207a8e:	e406                	sd	ra,8(sp)
ffffffffc0207a90:	acbfc0ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc0207a94:	60a2                	ld	ra,8(sp)
ffffffffc0207a96:	0141                	addi	sp,sp,16
ffffffffc0207a98:	a40d                	j	ffffffffc0207cba <vfs_devlist_init>

ffffffffc0207a9a <vfs_set_bootfs>:
ffffffffc0207a9a:	7179                	addi	sp,sp,-48
ffffffffc0207a9c:	f022                	sd	s0,32(sp)
ffffffffc0207a9e:	f406                	sd	ra,40(sp)
ffffffffc0207aa0:	ec26                	sd	s1,24(sp)
ffffffffc0207aa2:	e402                	sd	zero,8(sp)
ffffffffc0207aa4:	842a                	mv	s0,a0
ffffffffc0207aa6:	c915                	beqz	a0,ffffffffc0207ada <vfs_set_bootfs+0x40>
ffffffffc0207aa8:	03a00593          	li	a1,58
ffffffffc0207aac:	1df030ef          	jal	ra,ffffffffc020b48a <strchr>
ffffffffc0207ab0:	c135                	beqz	a0,ffffffffc0207b14 <vfs_set_bootfs+0x7a>
ffffffffc0207ab2:	00154783          	lbu	a5,1(a0)
ffffffffc0207ab6:	efb9                	bnez	a5,ffffffffc0207b14 <vfs_set_bootfs+0x7a>
ffffffffc0207ab8:	8522                	mv	a0,s0
ffffffffc0207aba:	11f000ef          	jal	ra,ffffffffc02083d8 <vfs_chdir>
ffffffffc0207abe:	842a                	mv	s0,a0
ffffffffc0207ac0:	c519                	beqz	a0,ffffffffc0207ace <vfs_set_bootfs+0x34>
ffffffffc0207ac2:	70a2                	ld	ra,40(sp)
ffffffffc0207ac4:	8522                	mv	a0,s0
ffffffffc0207ac6:	7402                	ld	s0,32(sp)
ffffffffc0207ac8:	64e2                	ld	s1,24(sp)
ffffffffc0207aca:	6145                	addi	sp,sp,48
ffffffffc0207acc:	8082                	ret
ffffffffc0207ace:	0028                	addi	a0,sp,8
ffffffffc0207ad0:	013000ef          	jal	ra,ffffffffc02082e2 <vfs_get_curdir>
ffffffffc0207ad4:	842a                	mv	s0,a0
ffffffffc0207ad6:	f575                	bnez	a0,ffffffffc0207ac2 <vfs_set_bootfs+0x28>
ffffffffc0207ad8:	6422                	ld	s0,8(sp)
ffffffffc0207ada:	0008e517          	auipc	a0,0x8e
ffffffffc0207ade:	d2650513          	addi	a0,a0,-730 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207ae2:	a83fc0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0207ae6:	0008f797          	auipc	a5,0x8f
ffffffffc0207aea:	e0a78793          	addi	a5,a5,-502 # ffffffffc02968f0 <bootfs_node>
ffffffffc0207aee:	6384                	ld	s1,0(a5)
ffffffffc0207af0:	0008e517          	auipc	a0,0x8e
ffffffffc0207af4:	d1050513          	addi	a0,a0,-752 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207af8:	e380                	sd	s0,0(a5)
ffffffffc0207afa:	4401                	li	s0,0
ffffffffc0207afc:	a65fc0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0207b00:	d0e9                	beqz	s1,ffffffffc0207ac2 <vfs_set_bootfs+0x28>
ffffffffc0207b02:	8526                	mv	a0,s1
ffffffffc0207b04:	e17ff0ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc0207b08:	70a2                	ld	ra,40(sp)
ffffffffc0207b0a:	8522                	mv	a0,s0
ffffffffc0207b0c:	7402                	ld	s0,32(sp)
ffffffffc0207b0e:	64e2                	ld	s1,24(sp)
ffffffffc0207b10:	6145                	addi	sp,sp,48
ffffffffc0207b12:	8082                	ret
ffffffffc0207b14:	5475                	li	s0,-3
ffffffffc0207b16:	b775                	j	ffffffffc0207ac2 <vfs_set_bootfs+0x28>

ffffffffc0207b18 <vfs_get_bootfs>:
ffffffffc0207b18:	1101                	addi	sp,sp,-32
ffffffffc0207b1a:	e426                	sd	s1,8(sp)
ffffffffc0207b1c:	0008f497          	auipc	s1,0x8f
ffffffffc0207b20:	dd448493          	addi	s1,s1,-556 # ffffffffc02968f0 <bootfs_node>
ffffffffc0207b24:	609c                	ld	a5,0(s1)
ffffffffc0207b26:	ec06                	sd	ra,24(sp)
ffffffffc0207b28:	e822                	sd	s0,16(sp)
ffffffffc0207b2a:	c3a1                	beqz	a5,ffffffffc0207b6a <vfs_get_bootfs+0x52>
ffffffffc0207b2c:	842a                	mv	s0,a0
ffffffffc0207b2e:	0008e517          	auipc	a0,0x8e
ffffffffc0207b32:	cd250513          	addi	a0,a0,-814 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207b36:	a2ffc0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0207b3a:	6084                	ld	s1,0(s1)
ffffffffc0207b3c:	c08d                	beqz	s1,ffffffffc0207b5e <vfs_get_bootfs+0x46>
ffffffffc0207b3e:	8526                	mv	a0,s1
ffffffffc0207b40:	d0dff0ef          	jal	ra,ffffffffc020784c <inode_ref_inc>
ffffffffc0207b44:	0008e517          	auipc	a0,0x8e
ffffffffc0207b48:	cbc50513          	addi	a0,a0,-836 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207b4c:	a15fc0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0207b50:	4501                	li	a0,0
ffffffffc0207b52:	e004                	sd	s1,0(s0)
ffffffffc0207b54:	60e2                	ld	ra,24(sp)
ffffffffc0207b56:	6442                	ld	s0,16(sp)
ffffffffc0207b58:	64a2                	ld	s1,8(sp)
ffffffffc0207b5a:	6105                	addi	sp,sp,32
ffffffffc0207b5c:	8082                	ret
ffffffffc0207b5e:	0008e517          	auipc	a0,0x8e
ffffffffc0207b62:	ca250513          	addi	a0,a0,-862 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207b66:	9fbfc0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0207b6a:	5541                	li	a0,-16
ffffffffc0207b6c:	b7e5                	j	ffffffffc0207b54 <vfs_get_bootfs+0x3c>

ffffffffc0207b6e <vfs_do_add>:
ffffffffc0207b6e:	7139                	addi	sp,sp,-64
ffffffffc0207b70:	fc06                	sd	ra,56(sp)
ffffffffc0207b72:	f822                	sd	s0,48(sp)
ffffffffc0207b74:	f426                	sd	s1,40(sp)
ffffffffc0207b76:	f04a                	sd	s2,32(sp)
ffffffffc0207b78:	ec4e                	sd	s3,24(sp)
ffffffffc0207b7a:	e852                	sd	s4,16(sp)
ffffffffc0207b7c:	e456                	sd	s5,8(sp)
ffffffffc0207b7e:	e05a                	sd	s6,0(sp)
ffffffffc0207b80:	0e050b63          	beqz	a0,ffffffffc0207c76 <vfs_do_add+0x108>
ffffffffc0207b84:	842a                	mv	s0,a0
ffffffffc0207b86:	8a2e                	mv	s4,a1
ffffffffc0207b88:	8b32                	mv	s6,a2
ffffffffc0207b8a:	8ab6                	mv	s5,a3
ffffffffc0207b8c:	c5cd                	beqz	a1,ffffffffc0207c36 <vfs_do_add+0xc8>
ffffffffc0207b8e:	4db8                	lw	a4,88(a1)
ffffffffc0207b90:	6785                	lui	a5,0x1
ffffffffc0207b92:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207b96:	0af71163          	bne	a4,a5,ffffffffc0207c38 <vfs_do_add+0xca>
ffffffffc0207b9a:	8522                	mv	a0,s0
ffffffffc0207b9c:	063030ef          	jal	ra,ffffffffc020b3fe <strlen>
ffffffffc0207ba0:	47fd                	li	a5,31
ffffffffc0207ba2:	0ca7e663          	bltu	a5,a0,ffffffffc0207c6e <vfs_do_add+0x100>
ffffffffc0207ba6:	8522                	mv	a0,s0
ffffffffc0207ba8:	e4cf80ef          	jal	ra,ffffffffc02001f4 <strdup>
ffffffffc0207bac:	84aa                	mv	s1,a0
ffffffffc0207bae:	c171                	beqz	a0,ffffffffc0207c72 <vfs_do_add+0x104>
ffffffffc0207bb0:	03000513          	li	a0,48
ffffffffc0207bb4:	bdafa0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0207bb8:	89aa                	mv	s3,a0
ffffffffc0207bba:	c92d                	beqz	a0,ffffffffc0207c2c <vfs_do_add+0xbe>
ffffffffc0207bbc:	0008e517          	auipc	a0,0x8e
ffffffffc0207bc0:	c6c50513          	addi	a0,a0,-916 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207bc4:	0008e917          	auipc	s2,0x8e
ffffffffc0207bc8:	c5490913          	addi	s2,s2,-940 # ffffffffc0295818 <vdev_list>
ffffffffc0207bcc:	999fc0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0207bd0:	844a                	mv	s0,s2
ffffffffc0207bd2:	a039                	j	ffffffffc0207be0 <vfs_do_add+0x72>
ffffffffc0207bd4:	fe043503          	ld	a0,-32(s0)
ffffffffc0207bd8:	85a6                	mv	a1,s1
ffffffffc0207bda:	06d030ef          	jal	ra,ffffffffc020b446 <strcmp>
ffffffffc0207bde:	cd2d                	beqz	a0,ffffffffc0207c58 <vfs_do_add+0xea>
ffffffffc0207be0:	6400                	ld	s0,8(s0)
ffffffffc0207be2:	ff2419e3          	bne	s0,s2,ffffffffc0207bd4 <vfs_do_add+0x66>
ffffffffc0207be6:	6418                	ld	a4,8(s0)
ffffffffc0207be8:	02098793          	addi	a5,s3,32
ffffffffc0207bec:	0099b023          	sd	s1,0(s3)
ffffffffc0207bf0:	0149b423          	sd	s4,8(s3)
ffffffffc0207bf4:	0159bc23          	sd	s5,24(s3)
ffffffffc0207bf8:	0169b823          	sd	s6,16(s3)
ffffffffc0207bfc:	e31c                	sd	a5,0(a4)
ffffffffc0207bfe:	0289b023          	sd	s0,32(s3)
ffffffffc0207c02:	02e9b423          	sd	a4,40(s3)
ffffffffc0207c06:	0008e517          	auipc	a0,0x8e
ffffffffc0207c0a:	c2250513          	addi	a0,a0,-990 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207c0e:	e41c                	sd	a5,8(s0)
ffffffffc0207c10:	4401                	li	s0,0
ffffffffc0207c12:	94ffc0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0207c16:	70e2                	ld	ra,56(sp)
ffffffffc0207c18:	8522                	mv	a0,s0
ffffffffc0207c1a:	7442                	ld	s0,48(sp)
ffffffffc0207c1c:	74a2                	ld	s1,40(sp)
ffffffffc0207c1e:	7902                	ld	s2,32(sp)
ffffffffc0207c20:	69e2                	ld	s3,24(sp)
ffffffffc0207c22:	6a42                	ld	s4,16(sp)
ffffffffc0207c24:	6aa2                	ld	s5,8(sp)
ffffffffc0207c26:	6b02                	ld	s6,0(sp)
ffffffffc0207c28:	6121                	addi	sp,sp,64
ffffffffc0207c2a:	8082                	ret
ffffffffc0207c2c:	5471                	li	s0,-4
ffffffffc0207c2e:	8526                	mv	a0,s1
ffffffffc0207c30:	c0efa0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0207c34:	b7cd                	j	ffffffffc0207c16 <vfs_do_add+0xa8>
ffffffffc0207c36:	d2b5                	beqz	a3,ffffffffc0207b9a <vfs_do_add+0x2c>
ffffffffc0207c38:	00007697          	auipc	a3,0x7
ffffffffc0207c3c:	93868693          	addi	a3,a3,-1736 # ffffffffc020e570 <syscalls+0xa70>
ffffffffc0207c40:	00004617          	auipc	a2,0x4
ffffffffc0207c44:	d4860613          	addi	a2,a2,-696 # ffffffffc020b988 <commands+0x210>
ffffffffc0207c48:	08f00593          	li	a1,143
ffffffffc0207c4c:	00007517          	auipc	a0,0x7
ffffffffc0207c50:	90c50513          	addi	a0,a0,-1780 # ffffffffc020e558 <syscalls+0xa58>
ffffffffc0207c54:	84bf80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207c58:	0008e517          	auipc	a0,0x8e
ffffffffc0207c5c:	bd050513          	addi	a0,a0,-1072 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207c60:	901fc0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0207c64:	854e                	mv	a0,s3
ffffffffc0207c66:	bd8fa0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0207c6a:	5425                	li	s0,-23
ffffffffc0207c6c:	b7c9                	j	ffffffffc0207c2e <vfs_do_add+0xc0>
ffffffffc0207c6e:	5451                	li	s0,-12
ffffffffc0207c70:	b75d                	j	ffffffffc0207c16 <vfs_do_add+0xa8>
ffffffffc0207c72:	5471                	li	s0,-4
ffffffffc0207c74:	b74d                	j	ffffffffc0207c16 <vfs_do_add+0xa8>
ffffffffc0207c76:	00007697          	auipc	a3,0x7
ffffffffc0207c7a:	8d268693          	addi	a3,a3,-1838 # ffffffffc020e548 <syscalls+0xa48>
ffffffffc0207c7e:	00004617          	auipc	a2,0x4
ffffffffc0207c82:	d0a60613          	addi	a2,a2,-758 # ffffffffc020b988 <commands+0x210>
ffffffffc0207c86:	08e00593          	li	a1,142
ffffffffc0207c8a:	00007517          	auipc	a0,0x7
ffffffffc0207c8e:	8ce50513          	addi	a0,a0,-1842 # ffffffffc020e558 <syscalls+0xa58>
ffffffffc0207c92:	80df80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207c96 <find_mount.part.0>:
ffffffffc0207c96:	1141                	addi	sp,sp,-16
ffffffffc0207c98:	00007697          	auipc	a3,0x7
ffffffffc0207c9c:	8b068693          	addi	a3,a3,-1872 # ffffffffc020e548 <syscalls+0xa48>
ffffffffc0207ca0:	00004617          	auipc	a2,0x4
ffffffffc0207ca4:	ce860613          	addi	a2,a2,-792 # ffffffffc020b988 <commands+0x210>
ffffffffc0207ca8:	0cd00593          	li	a1,205
ffffffffc0207cac:	00007517          	auipc	a0,0x7
ffffffffc0207cb0:	8ac50513          	addi	a0,a0,-1876 # ffffffffc020e558 <syscalls+0xa58>
ffffffffc0207cb4:	e406                	sd	ra,8(sp)
ffffffffc0207cb6:	fe8f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207cba <vfs_devlist_init>:
ffffffffc0207cba:	0008e797          	auipc	a5,0x8e
ffffffffc0207cbe:	b5e78793          	addi	a5,a5,-1186 # ffffffffc0295818 <vdev_list>
ffffffffc0207cc2:	4585                	li	a1,1
ffffffffc0207cc4:	0008e517          	auipc	a0,0x8e
ffffffffc0207cc8:	b6450513          	addi	a0,a0,-1180 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207ccc:	e79c                	sd	a5,8(a5)
ffffffffc0207cce:	e39c                	sd	a5,0(a5)
ffffffffc0207cd0:	88bfc06f          	j	ffffffffc020455a <sem_init>

ffffffffc0207cd4 <vfs_cleanup>:
ffffffffc0207cd4:	1101                	addi	sp,sp,-32
ffffffffc0207cd6:	e426                	sd	s1,8(sp)
ffffffffc0207cd8:	0008e497          	auipc	s1,0x8e
ffffffffc0207cdc:	b4048493          	addi	s1,s1,-1216 # ffffffffc0295818 <vdev_list>
ffffffffc0207ce0:	649c                	ld	a5,8(s1)
ffffffffc0207ce2:	ec06                	sd	ra,24(sp)
ffffffffc0207ce4:	e822                	sd	s0,16(sp)
ffffffffc0207ce6:	02978e63          	beq	a5,s1,ffffffffc0207d22 <vfs_cleanup+0x4e>
ffffffffc0207cea:	0008e517          	auipc	a0,0x8e
ffffffffc0207cee:	b3e50513          	addi	a0,a0,-1218 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207cf2:	873fc0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0207cf6:	6480                	ld	s0,8(s1)
ffffffffc0207cf8:	00940b63          	beq	s0,s1,ffffffffc0207d0e <vfs_cleanup+0x3a>
ffffffffc0207cfc:	ff043783          	ld	a5,-16(s0)
ffffffffc0207d00:	853e                	mv	a0,a5
ffffffffc0207d02:	c399                	beqz	a5,ffffffffc0207d08 <vfs_cleanup+0x34>
ffffffffc0207d04:	6bfc                	ld	a5,208(a5)
ffffffffc0207d06:	9782                	jalr	a5
ffffffffc0207d08:	6400                	ld	s0,8(s0)
ffffffffc0207d0a:	fe9419e3          	bne	s0,s1,ffffffffc0207cfc <vfs_cleanup+0x28>
ffffffffc0207d0e:	6442                	ld	s0,16(sp)
ffffffffc0207d10:	60e2                	ld	ra,24(sp)
ffffffffc0207d12:	64a2                	ld	s1,8(sp)
ffffffffc0207d14:	0008e517          	auipc	a0,0x8e
ffffffffc0207d18:	b1450513          	addi	a0,a0,-1260 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207d1c:	6105                	addi	sp,sp,32
ffffffffc0207d1e:	843fc06f          	j	ffffffffc0204560 <up>
ffffffffc0207d22:	60e2                	ld	ra,24(sp)
ffffffffc0207d24:	6442                	ld	s0,16(sp)
ffffffffc0207d26:	64a2                	ld	s1,8(sp)
ffffffffc0207d28:	6105                	addi	sp,sp,32
ffffffffc0207d2a:	8082                	ret

ffffffffc0207d2c <vfs_get_root>:
ffffffffc0207d2c:	7179                	addi	sp,sp,-48
ffffffffc0207d2e:	f406                	sd	ra,40(sp)
ffffffffc0207d30:	f022                	sd	s0,32(sp)
ffffffffc0207d32:	ec26                	sd	s1,24(sp)
ffffffffc0207d34:	e84a                	sd	s2,16(sp)
ffffffffc0207d36:	e44e                	sd	s3,8(sp)
ffffffffc0207d38:	e052                	sd	s4,0(sp)
ffffffffc0207d3a:	c541                	beqz	a0,ffffffffc0207dc2 <vfs_get_root+0x96>
ffffffffc0207d3c:	0008e917          	auipc	s2,0x8e
ffffffffc0207d40:	adc90913          	addi	s2,s2,-1316 # ffffffffc0295818 <vdev_list>
ffffffffc0207d44:	00893783          	ld	a5,8(s2)
ffffffffc0207d48:	07278b63          	beq	a5,s2,ffffffffc0207dbe <vfs_get_root+0x92>
ffffffffc0207d4c:	89aa                	mv	s3,a0
ffffffffc0207d4e:	0008e517          	auipc	a0,0x8e
ffffffffc0207d52:	ada50513          	addi	a0,a0,-1318 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207d56:	8a2e                	mv	s4,a1
ffffffffc0207d58:	844a                	mv	s0,s2
ffffffffc0207d5a:	80bfc0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0207d5e:	a801                	j	ffffffffc0207d6e <vfs_get_root+0x42>
ffffffffc0207d60:	fe043583          	ld	a1,-32(s0)
ffffffffc0207d64:	854e                	mv	a0,s3
ffffffffc0207d66:	6e0030ef          	jal	ra,ffffffffc020b446 <strcmp>
ffffffffc0207d6a:	84aa                	mv	s1,a0
ffffffffc0207d6c:	c505                	beqz	a0,ffffffffc0207d94 <vfs_get_root+0x68>
ffffffffc0207d6e:	6400                	ld	s0,8(s0)
ffffffffc0207d70:	ff2418e3          	bne	s0,s2,ffffffffc0207d60 <vfs_get_root+0x34>
ffffffffc0207d74:	54cd                	li	s1,-13
ffffffffc0207d76:	0008e517          	auipc	a0,0x8e
ffffffffc0207d7a:	ab250513          	addi	a0,a0,-1358 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207d7e:	fe2fc0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0207d82:	70a2                	ld	ra,40(sp)
ffffffffc0207d84:	7402                	ld	s0,32(sp)
ffffffffc0207d86:	6942                	ld	s2,16(sp)
ffffffffc0207d88:	69a2                	ld	s3,8(sp)
ffffffffc0207d8a:	6a02                	ld	s4,0(sp)
ffffffffc0207d8c:	8526                	mv	a0,s1
ffffffffc0207d8e:	64e2                	ld	s1,24(sp)
ffffffffc0207d90:	6145                	addi	sp,sp,48
ffffffffc0207d92:	8082                	ret
ffffffffc0207d94:	ff043503          	ld	a0,-16(s0)
ffffffffc0207d98:	c519                	beqz	a0,ffffffffc0207da6 <vfs_get_root+0x7a>
ffffffffc0207d9a:	617c                	ld	a5,192(a0)
ffffffffc0207d9c:	9782                	jalr	a5
ffffffffc0207d9e:	c519                	beqz	a0,ffffffffc0207dac <vfs_get_root+0x80>
ffffffffc0207da0:	00aa3023          	sd	a0,0(s4)
ffffffffc0207da4:	bfc9                	j	ffffffffc0207d76 <vfs_get_root+0x4a>
ffffffffc0207da6:	ff843783          	ld	a5,-8(s0)
ffffffffc0207daa:	c399                	beqz	a5,ffffffffc0207db0 <vfs_get_root+0x84>
ffffffffc0207dac:	54c9                	li	s1,-14
ffffffffc0207dae:	b7e1                	j	ffffffffc0207d76 <vfs_get_root+0x4a>
ffffffffc0207db0:	fe843503          	ld	a0,-24(s0)
ffffffffc0207db4:	a99ff0ef          	jal	ra,ffffffffc020784c <inode_ref_inc>
ffffffffc0207db8:	fe843503          	ld	a0,-24(s0)
ffffffffc0207dbc:	b7cd                	j	ffffffffc0207d9e <vfs_get_root+0x72>
ffffffffc0207dbe:	54cd                	li	s1,-13
ffffffffc0207dc0:	b7c9                	j	ffffffffc0207d82 <vfs_get_root+0x56>
ffffffffc0207dc2:	00006697          	auipc	a3,0x6
ffffffffc0207dc6:	78668693          	addi	a3,a3,1926 # ffffffffc020e548 <syscalls+0xa48>
ffffffffc0207dca:	00004617          	auipc	a2,0x4
ffffffffc0207dce:	bbe60613          	addi	a2,a2,-1090 # ffffffffc020b988 <commands+0x210>
ffffffffc0207dd2:	04500593          	li	a1,69
ffffffffc0207dd6:	00006517          	auipc	a0,0x6
ffffffffc0207dda:	78250513          	addi	a0,a0,1922 # ffffffffc020e558 <syscalls+0xa58>
ffffffffc0207dde:	ec0f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207de2 <vfs_get_devname>:
ffffffffc0207de2:	0008e697          	auipc	a3,0x8e
ffffffffc0207de6:	a3668693          	addi	a3,a3,-1482 # ffffffffc0295818 <vdev_list>
ffffffffc0207dea:	87b6                	mv	a5,a3
ffffffffc0207dec:	e511                	bnez	a0,ffffffffc0207df8 <vfs_get_devname+0x16>
ffffffffc0207dee:	a829                	j	ffffffffc0207e08 <vfs_get_devname+0x26>
ffffffffc0207df0:	ff07b703          	ld	a4,-16(a5)
ffffffffc0207df4:	00a70763          	beq	a4,a0,ffffffffc0207e02 <vfs_get_devname+0x20>
ffffffffc0207df8:	679c                	ld	a5,8(a5)
ffffffffc0207dfa:	fed79be3          	bne	a5,a3,ffffffffc0207df0 <vfs_get_devname+0xe>
ffffffffc0207dfe:	4501                	li	a0,0
ffffffffc0207e00:	8082                	ret
ffffffffc0207e02:	fe07b503          	ld	a0,-32(a5)
ffffffffc0207e06:	8082                	ret
ffffffffc0207e08:	1141                	addi	sp,sp,-16
ffffffffc0207e0a:	00006697          	auipc	a3,0x6
ffffffffc0207e0e:	7c668693          	addi	a3,a3,1990 # ffffffffc020e5d0 <syscalls+0xad0>
ffffffffc0207e12:	00004617          	auipc	a2,0x4
ffffffffc0207e16:	b7660613          	addi	a2,a2,-1162 # ffffffffc020b988 <commands+0x210>
ffffffffc0207e1a:	06a00593          	li	a1,106
ffffffffc0207e1e:	00006517          	auipc	a0,0x6
ffffffffc0207e22:	73a50513          	addi	a0,a0,1850 # ffffffffc020e558 <syscalls+0xa58>
ffffffffc0207e26:	e406                	sd	ra,8(sp)
ffffffffc0207e28:	e76f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207e2c <vfs_add_dev>:
ffffffffc0207e2c:	86b2                	mv	a3,a2
ffffffffc0207e2e:	4601                	li	a2,0
ffffffffc0207e30:	d3fff06f          	j	ffffffffc0207b6e <vfs_do_add>

ffffffffc0207e34 <vfs_mount>:
ffffffffc0207e34:	7179                	addi	sp,sp,-48
ffffffffc0207e36:	e84a                	sd	s2,16(sp)
ffffffffc0207e38:	892a                	mv	s2,a0
ffffffffc0207e3a:	0008e517          	auipc	a0,0x8e
ffffffffc0207e3e:	9ee50513          	addi	a0,a0,-1554 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207e42:	e44e                	sd	s3,8(sp)
ffffffffc0207e44:	f406                	sd	ra,40(sp)
ffffffffc0207e46:	f022                	sd	s0,32(sp)
ffffffffc0207e48:	ec26                	sd	s1,24(sp)
ffffffffc0207e4a:	89ae                	mv	s3,a1
ffffffffc0207e4c:	f18fc0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0207e50:	08090a63          	beqz	s2,ffffffffc0207ee4 <vfs_mount+0xb0>
ffffffffc0207e54:	0008e497          	auipc	s1,0x8e
ffffffffc0207e58:	9c448493          	addi	s1,s1,-1596 # ffffffffc0295818 <vdev_list>
ffffffffc0207e5c:	6480                	ld	s0,8(s1)
ffffffffc0207e5e:	00941663          	bne	s0,s1,ffffffffc0207e6a <vfs_mount+0x36>
ffffffffc0207e62:	a8ad                	j	ffffffffc0207edc <vfs_mount+0xa8>
ffffffffc0207e64:	6400                	ld	s0,8(s0)
ffffffffc0207e66:	06940b63          	beq	s0,s1,ffffffffc0207edc <vfs_mount+0xa8>
ffffffffc0207e6a:	ff843783          	ld	a5,-8(s0)
ffffffffc0207e6e:	dbfd                	beqz	a5,ffffffffc0207e64 <vfs_mount+0x30>
ffffffffc0207e70:	fe043503          	ld	a0,-32(s0)
ffffffffc0207e74:	85ca                	mv	a1,s2
ffffffffc0207e76:	5d0030ef          	jal	ra,ffffffffc020b446 <strcmp>
ffffffffc0207e7a:	f56d                	bnez	a0,ffffffffc0207e64 <vfs_mount+0x30>
ffffffffc0207e7c:	ff043783          	ld	a5,-16(s0)
ffffffffc0207e80:	e3a5                	bnez	a5,ffffffffc0207ee0 <vfs_mount+0xac>
ffffffffc0207e82:	fe043783          	ld	a5,-32(s0)
ffffffffc0207e86:	c3c9                	beqz	a5,ffffffffc0207f08 <vfs_mount+0xd4>
ffffffffc0207e88:	ff843783          	ld	a5,-8(s0)
ffffffffc0207e8c:	cfb5                	beqz	a5,ffffffffc0207f08 <vfs_mount+0xd4>
ffffffffc0207e8e:	fe843503          	ld	a0,-24(s0)
ffffffffc0207e92:	c939                	beqz	a0,ffffffffc0207ee8 <vfs_mount+0xb4>
ffffffffc0207e94:	4d38                	lw	a4,88(a0)
ffffffffc0207e96:	6785                	lui	a5,0x1
ffffffffc0207e98:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207e9c:	04f71663          	bne	a4,a5,ffffffffc0207ee8 <vfs_mount+0xb4>
ffffffffc0207ea0:	ff040593          	addi	a1,s0,-16
ffffffffc0207ea4:	9982                	jalr	s3
ffffffffc0207ea6:	84aa                	mv	s1,a0
ffffffffc0207ea8:	ed01                	bnez	a0,ffffffffc0207ec0 <vfs_mount+0x8c>
ffffffffc0207eaa:	ff043783          	ld	a5,-16(s0)
ffffffffc0207eae:	cfad                	beqz	a5,ffffffffc0207f28 <vfs_mount+0xf4>
ffffffffc0207eb0:	fe043583          	ld	a1,-32(s0)
ffffffffc0207eb4:	00006517          	auipc	a0,0x6
ffffffffc0207eb8:	7ac50513          	addi	a0,a0,1964 # ffffffffc020e660 <syscalls+0xb60>
ffffffffc0207ebc:	aeaf80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0207ec0:	0008e517          	auipc	a0,0x8e
ffffffffc0207ec4:	96850513          	addi	a0,a0,-1688 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207ec8:	e98fc0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc0207ecc:	70a2                	ld	ra,40(sp)
ffffffffc0207ece:	7402                	ld	s0,32(sp)
ffffffffc0207ed0:	6942                	ld	s2,16(sp)
ffffffffc0207ed2:	69a2                	ld	s3,8(sp)
ffffffffc0207ed4:	8526                	mv	a0,s1
ffffffffc0207ed6:	64e2                	ld	s1,24(sp)
ffffffffc0207ed8:	6145                	addi	sp,sp,48
ffffffffc0207eda:	8082                	ret
ffffffffc0207edc:	54cd                	li	s1,-13
ffffffffc0207ede:	b7cd                	j	ffffffffc0207ec0 <vfs_mount+0x8c>
ffffffffc0207ee0:	54c5                	li	s1,-15
ffffffffc0207ee2:	bff9                	j	ffffffffc0207ec0 <vfs_mount+0x8c>
ffffffffc0207ee4:	db3ff0ef          	jal	ra,ffffffffc0207c96 <find_mount.part.0>
ffffffffc0207ee8:	00006697          	auipc	a3,0x6
ffffffffc0207eec:	72868693          	addi	a3,a3,1832 # ffffffffc020e610 <syscalls+0xb10>
ffffffffc0207ef0:	00004617          	auipc	a2,0x4
ffffffffc0207ef4:	a9860613          	addi	a2,a2,-1384 # ffffffffc020b988 <commands+0x210>
ffffffffc0207ef8:	0ed00593          	li	a1,237
ffffffffc0207efc:	00006517          	auipc	a0,0x6
ffffffffc0207f00:	65c50513          	addi	a0,a0,1628 # ffffffffc020e558 <syscalls+0xa58>
ffffffffc0207f04:	d9af80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207f08:	00006697          	auipc	a3,0x6
ffffffffc0207f0c:	6d868693          	addi	a3,a3,1752 # ffffffffc020e5e0 <syscalls+0xae0>
ffffffffc0207f10:	00004617          	auipc	a2,0x4
ffffffffc0207f14:	a7860613          	addi	a2,a2,-1416 # ffffffffc020b988 <commands+0x210>
ffffffffc0207f18:	0eb00593          	li	a1,235
ffffffffc0207f1c:	00006517          	auipc	a0,0x6
ffffffffc0207f20:	63c50513          	addi	a0,a0,1596 # ffffffffc020e558 <syscalls+0xa58>
ffffffffc0207f24:	d7af80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207f28:	00006697          	auipc	a3,0x6
ffffffffc0207f2c:	72068693          	addi	a3,a3,1824 # ffffffffc020e648 <syscalls+0xb48>
ffffffffc0207f30:	00004617          	auipc	a2,0x4
ffffffffc0207f34:	a5860613          	addi	a2,a2,-1448 # ffffffffc020b988 <commands+0x210>
ffffffffc0207f38:	0ef00593          	li	a1,239
ffffffffc0207f3c:	00006517          	auipc	a0,0x6
ffffffffc0207f40:	61c50513          	addi	a0,a0,1564 # ffffffffc020e558 <syscalls+0xa58>
ffffffffc0207f44:	d5af80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207f48 <vfs_open>:
ffffffffc0207f48:	711d                	addi	sp,sp,-96
ffffffffc0207f4a:	e4a6                	sd	s1,72(sp)
ffffffffc0207f4c:	e0ca                	sd	s2,64(sp)
ffffffffc0207f4e:	fc4e                	sd	s3,56(sp)
ffffffffc0207f50:	ec86                	sd	ra,88(sp)
ffffffffc0207f52:	e8a2                	sd	s0,80(sp)
ffffffffc0207f54:	f852                	sd	s4,48(sp)
ffffffffc0207f56:	f456                	sd	s5,40(sp)
ffffffffc0207f58:	0035f793          	andi	a5,a1,3
ffffffffc0207f5c:	84ae                	mv	s1,a1
ffffffffc0207f5e:	892a                	mv	s2,a0
ffffffffc0207f60:	89b2                	mv	s3,a2
ffffffffc0207f62:	0e078663          	beqz	a5,ffffffffc020804e <vfs_open+0x106>
ffffffffc0207f66:	470d                	li	a4,3
ffffffffc0207f68:	0105fa93          	andi	s5,a1,16
ffffffffc0207f6c:	0ce78f63          	beq	a5,a4,ffffffffc020804a <vfs_open+0x102>
ffffffffc0207f70:	002c                	addi	a1,sp,8
ffffffffc0207f72:	854a                	mv	a0,s2
ffffffffc0207f74:	2ae000ef          	jal	ra,ffffffffc0208222 <vfs_lookup>
ffffffffc0207f78:	842a                	mv	s0,a0
ffffffffc0207f7a:	0044fa13          	andi	s4,s1,4
ffffffffc0207f7e:	e159                	bnez	a0,ffffffffc0208004 <vfs_open+0xbc>
ffffffffc0207f80:	00c4f793          	andi	a5,s1,12
ffffffffc0207f84:	4731                	li	a4,12
ffffffffc0207f86:	0ee78263          	beq	a5,a4,ffffffffc020806a <vfs_open+0x122>
ffffffffc0207f8a:	6422                	ld	s0,8(sp)
ffffffffc0207f8c:	12040163          	beqz	s0,ffffffffc02080ae <vfs_open+0x166>
ffffffffc0207f90:	783c                	ld	a5,112(s0)
ffffffffc0207f92:	cff1                	beqz	a5,ffffffffc020806e <vfs_open+0x126>
ffffffffc0207f94:	679c                	ld	a5,8(a5)
ffffffffc0207f96:	cfe1                	beqz	a5,ffffffffc020806e <vfs_open+0x126>
ffffffffc0207f98:	8522                	mv	a0,s0
ffffffffc0207f9a:	00006597          	auipc	a1,0x6
ffffffffc0207f9e:	7a658593          	addi	a1,a1,1958 # ffffffffc020e740 <syscalls+0xc40>
ffffffffc0207fa2:	8c3ff0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0207fa6:	783c                	ld	a5,112(s0)
ffffffffc0207fa8:	6522                	ld	a0,8(sp)
ffffffffc0207faa:	85a6                	mv	a1,s1
ffffffffc0207fac:	679c                	ld	a5,8(a5)
ffffffffc0207fae:	9782                	jalr	a5
ffffffffc0207fb0:	842a                	mv	s0,a0
ffffffffc0207fb2:	6522                	ld	a0,8(sp)
ffffffffc0207fb4:	e845                	bnez	s0,ffffffffc0208064 <vfs_open+0x11c>
ffffffffc0207fb6:	015a6a33          	or	s4,s4,s5
ffffffffc0207fba:	89fff0ef          	jal	ra,ffffffffc0207858 <inode_open_inc>
ffffffffc0207fbe:	020a0663          	beqz	s4,ffffffffc0207fea <vfs_open+0xa2>
ffffffffc0207fc2:	64a2                	ld	s1,8(sp)
ffffffffc0207fc4:	c4e9                	beqz	s1,ffffffffc020808e <vfs_open+0x146>
ffffffffc0207fc6:	78bc                	ld	a5,112(s1)
ffffffffc0207fc8:	c3f9                	beqz	a5,ffffffffc020808e <vfs_open+0x146>
ffffffffc0207fca:	73bc                	ld	a5,96(a5)
ffffffffc0207fcc:	c3e9                	beqz	a5,ffffffffc020808e <vfs_open+0x146>
ffffffffc0207fce:	00006597          	auipc	a1,0x6
ffffffffc0207fd2:	7d258593          	addi	a1,a1,2002 # ffffffffc020e7a0 <syscalls+0xca0>
ffffffffc0207fd6:	8526                	mv	a0,s1
ffffffffc0207fd8:	88dff0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0207fdc:	78bc                	ld	a5,112(s1)
ffffffffc0207fde:	6522                	ld	a0,8(sp)
ffffffffc0207fe0:	4581                	li	a1,0
ffffffffc0207fe2:	73bc                	ld	a5,96(a5)
ffffffffc0207fe4:	9782                	jalr	a5
ffffffffc0207fe6:	87aa                	mv	a5,a0
ffffffffc0207fe8:	e92d                	bnez	a0,ffffffffc020805a <vfs_open+0x112>
ffffffffc0207fea:	67a2                	ld	a5,8(sp)
ffffffffc0207fec:	00f9b023          	sd	a5,0(s3)
ffffffffc0207ff0:	60e6                	ld	ra,88(sp)
ffffffffc0207ff2:	8522                	mv	a0,s0
ffffffffc0207ff4:	6446                	ld	s0,80(sp)
ffffffffc0207ff6:	64a6                	ld	s1,72(sp)
ffffffffc0207ff8:	6906                	ld	s2,64(sp)
ffffffffc0207ffa:	79e2                	ld	s3,56(sp)
ffffffffc0207ffc:	7a42                	ld	s4,48(sp)
ffffffffc0207ffe:	7aa2                	ld	s5,40(sp)
ffffffffc0208000:	6125                	addi	sp,sp,96
ffffffffc0208002:	8082                	ret
ffffffffc0208004:	57c1                	li	a5,-16
ffffffffc0208006:	fef515e3          	bne	a0,a5,ffffffffc0207ff0 <vfs_open+0xa8>
ffffffffc020800a:	fe0a03e3          	beqz	s4,ffffffffc0207ff0 <vfs_open+0xa8>
ffffffffc020800e:	0810                	addi	a2,sp,16
ffffffffc0208010:	082c                	addi	a1,sp,24
ffffffffc0208012:	854a                	mv	a0,s2
ffffffffc0208014:	2a4000ef          	jal	ra,ffffffffc02082b8 <vfs_lookup_parent>
ffffffffc0208018:	842a                	mv	s0,a0
ffffffffc020801a:	f979                	bnez	a0,ffffffffc0207ff0 <vfs_open+0xa8>
ffffffffc020801c:	6462                	ld	s0,24(sp)
ffffffffc020801e:	c845                	beqz	s0,ffffffffc02080ce <vfs_open+0x186>
ffffffffc0208020:	783c                	ld	a5,112(s0)
ffffffffc0208022:	c7d5                	beqz	a5,ffffffffc02080ce <vfs_open+0x186>
ffffffffc0208024:	77bc                	ld	a5,104(a5)
ffffffffc0208026:	c7c5                	beqz	a5,ffffffffc02080ce <vfs_open+0x186>
ffffffffc0208028:	8522                	mv	a0,s0
ffffffffc020802a:	00006597          	auipc	a1,0x6
ffffffffc020802e:	6ae58593          	addi	a1,a1,1710 # ffffffffc020e6d8 <syscalls+0xbd8>
ffffffffc0208032:	833ff0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0208036:	783c                	ld	a5,112(s0)
ffffffffc0208038:	65c2                	ld	a1,16(sp)
ffffffffc020803a:	6562                	ld	a0,24(sp)
ffffffffc020803c:	77bc                	ld	a5,104(a5)
ffffffffc020803e:	4034d613          	srai	a2,s1,0x3
ffffffffc0208042:	0034                	addi	a3,sp,8
ffffffffc0208044:	8a05                	andi	a2,a2,1
ffffffffc0208046:	9782                	jalr	a5
ffffffffc0208048:	b789                	j	ffffffffc0207f8a <vfs_open+0x42>
ffffffffc020804a:	5475                	li	s0,-3
ffffffffc020804c:	b755                	j	ffffffffc0207ff0 <vfs_open+0xa8>
ffffffffc020804e:	0105fa93          	andi	s5,a1,16
ffffffffc0208052:	5475                	li	s0,-3
ffffffffc0208054:	f80a9ee3          	bnez	s5,ffffffffc0207ff0 <vfs_open+0xa8>
ffffffffc0208058:	bf21                	j	ffffffffc0207f70 <vfs_open+0x28>
ffffffffc020805a:	6522                	ld	a0,8(sp)
ffffffffc020805c:	843e                	mv	s0,a5
ffffffffc020805e:	965ff0ef          	jal	ra,ffffffffc02079c2 <inode_open_dec>
ffffffffc0208062:	6522                	ld	a0,8(sp)
ffffffffc0208064:	8b7ff0ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc0208068:	b761                	j	ffffffffc0207ff0 <vfs_open+0xa8>
ffffffffc020806a:	5425                	li	s0,-23
ffffffffc020806c:	b751                	j	ffffffffc0207ff0 <vfs_open+0xa8>
ffffffffc020806e:	00006697          	auipc	a3,0x6
ffffffffc0208072:	68268693          	addi	a3,a3,1666 # ffffffffc020e6f0 <syscalls+0xbf0>
ffffffffc0208076:	00004617          	auipc	a2,0x4
ffffffffc020807a:	91260613          	addi	a2,a2,-1774 # ffffffffc020b988 <commands+0x210>
ffffffffc020807e:	03300593          	li	a1,51
ffffffffc0208082:	00006517          	auipc	a0,0x6
ffffffffc0208086:	63e50513          	addi	a0,a0,1598 # ffffffffc020e6c0 <syscalls+0xbc0>
ffffffffc020808a:	c14f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020808e:	00006697          	auipc	a3,0x6
ffffffffc0208092:	6ba68693          	addi	a3,a3,1722 # ffffffffc020e748 <syscalls+0xc48>
ffffffffc0208096:	00004617          	auipc	a2,0x4
ffffffffc020809a:	8f260613          	addi	a2,a2,-1806 # ffffffffc020b988 <commands+0x210>
ffffffffc020809e:	03a00593          	li	a1,58
ffffffffc02080a2:	00006517          	auipc	a0,0x6
ffffffffc02080a6:	61e50513          	addi	a0,a0,1566 # ffffffffc020e6c0 <syscalls+0xbc0>
ffffffffc02080aa:	bf4f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02080ae:	00006697          	auipc	a3,0x6
ffffffffc02080b2:	63268693          	addi	a3,a3,1586 # ffffffffc020e6e0 <syscalls+0xbe0>
ffffffffc02080b6:	00004617          	auipc	a2,0x4
ffffffffc02080ba:	8d260613          	addi	a2,a2,-1838 # ffffffffc020b988 <commands+0x210>
ffffffffc02080be:	03100593          	li	a1,49
ffffffffc02080c2:	00006517          	auipc	a0,0x6
ffffffffc02080c6:	5fe50513          	addi	a0,a0,1534 # ffffffffc020e6c0 <syscalls+0xbc0>
ffffffffc02080ca:	bd4f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02080ce:	00006697          	auipc	a3,0x6
ffffffffc02080d2:	5a268693          	addi	a3,a3,1442 # ffffffffc020e670 <syscalls+0xb70>
ffffffffc02080d6:	00004617          	auipc	a2,0x4
ffffffffc02080da:	8b260613          	addi	a2,a2,-1870 # ffffffffc020b988 <commands+0x210>
ffffffffc02080de:	02c00593          	li	a1,44
ffffffffc02080e2:	00006517          	auipc	a0,0x6
ffffffffc02080e6:	5de50513          	addi	a0,a0,1502 # ffffffffc020e6c0 <syscalls+0xbc0>
ffffffffc02080ea:	bb4f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02080ee <vfs_close>:
ffffffffc02080ee:	1141                	addi	sp,sp,-16
ffffffffc02080f0:	e406                	sd	ra,8(sp)
ffffffffc02080f2:	e022                	sd	s0,0(sp)
ffffffffc02080f4:	842a                	mv	s0,a0
ffffffffc02080f6:	8cdff0ef          	jal	ra,ffffffffc02079c2 <inode_open_dec>
ffffffffc02080fa:	8522                	mv	a0,s0
ffffffffc02080fc:	81fff0ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc0208100:	60a2                	ld	ra,8(sp)
ffffffffc0208102:	6402                	ld	s0,0(sp)
ffffffffc0208104:	4501                	li	a0,0
ffffffffc0208106:	0141                	addi	sp,sp,16
ffffffffc0208108:	8082                	ret

ffffffffc020810a <get_device>:
ffffffffc020810a:	7179                	addi	sp,sp,-48
ffffffffc020810c:	ec26                	sd	s1,24(sp)
ffffffffc020810e:	e84a                	sd	s2,16(sp)
ffffffffc0208110:	f406                	sd	ra,40(sp)
ffffffffc0208112:	f022                	sd	s0,32(sp)
ffffffffc0208114:	00054303          	lbu	t1,0(a0)
ffffffffc0208118:	892e                	mv	s2,a1
ffffffffc020811a:	84b2                	mv	s1,a2
ffffffffc020811c:	02030463          	beqz	t1,ffffffffc0208144 <get_device+0x3a>
ffffffffc0208120:	00150413          	addi	s0,a0,1
ffffffffc0208124:	86a2                	mv	a3,s0
ffffffffc0208126:	879a                	mv	a5,t1
ffffffffc0208128:	4701                	li	a4,0
ffffffffc020812a:	03a00813          	li	a6,58
ffffffffc020812e:	02f00893          	li	a7,47
ffffffffc0208132:	03078263          	beq	a5,a6,ffffffffc0208156 <get_device+0x4c>
ffffffffc0208136:	05178963          	beq	a5,a7,ffffffffc0208188 <get_device+0x7e>
ffffffffc020813a:	0006c783          	lbu	a5,0(a3)
ffffffffc020813e:	2705                	addiw	a4,a4,1
ffffffffc0208140:	0685                	addi	a3,a3,1
ffffffffc0208142:	fbe5                	bnez	a5,ffffffffc0208132 <get_device+0x28>
ffffffffc0208144:	7402                	ld	s0,32(sp)
ffffffffc0208146:	00a93023          	sd	a0,0(s2)
ffffffffc020814a:	70a2                	ld	ra,40(sp)
ffffffffc020814c:	6942                	ld	s2,16(sp)
ffffffffc020814e:	8526                	mv	a0,s1
ffffffffc0208150:	64e2                	ld	s1,24(sp)
ffffffffc0208152:	6145                	addi	sp,sp,48
ffffffffc0208154:	a279                	j	ffffffffc02082e2 <vfs_get_curdir>
ffffffffc0208156:	cb15                	beqz	a4,ffffffffc020818a <get_device+0x80>
ffffffffc0208158:	00e507b3          	add	a5,a0,a4
ffffffffc020815c:	0705                	addi	a4,a4,1
ffffffffc020815e:	00078023          	sb	zero,0(a5)
ffffffffc0208162:	972a                	add	a4,a4,a0
ffffffffc0208164:	02f00613          	li	a2,47
ffffffffc0208168:	00074783          	lbu	a5,0(a4)
ffffffffc020816c:	86ba                	mv	a3,a4
ffffffffc020816e:	0705                	addi	a4,a4,1
ffffffffc0208170:	fec78ce3          	beq	a5,a2,ffffffffc0208168 <get_device+0x5e>
ffffffffc0208174:	7402                	ld	s0,32(sp)
ffffffffc0208176:	70a2                	ld	ra,40(sp)
ffffffffc0208178:	00d93023          	sd	a3,0(s2)
ffffffffc020817c:	85a6                	mv	a1,s1
ffffffffc020817e:	6942                	ld	s2,16(sp)
ffffffffc0208180:	64e2                	ld	s1,24(sp)
ffffffffc0208182:	6145                	addi	sp,sp,48
ffffffffc0208184:	ba9ff06f          	j	ffffffffc0207d2c <vfs_get_root>
ffffffffc0208188:	ff55                	bnez	a4,ffffffffc0208144 <get_device+0x3a>
ffffffffc020818a:	02f00793          	li	a5,47
ffffffffc020818e:	04f30563          	beq	t1,a5,ffffffffc02081d8 <get_device+0xce>
ffffffffc0208192:	03a00793          	li	a5,58
ffffffffc0208196:	06f31663          	bne	t1,a5,ffffffffc0208202 <get_device+0xf8>
ffffffffc020819a:	0028                	addi	a0,sp,8
ffffffffc020819c:	146000ef          	jal	ra,ffffffffc02082e2 <vfs_get_curdir>
ffffffffc02081a0:	e515                	bnez	a0,ffffffffc02081cc <get_device+0xc2>
ffffffffc02081a2:	67a2                	ld	a5,8(sp)
ffffffffc02081a4:	77a8                	ld	a0,104(a5)
ffffffffc02081a6:	cd15                	beqz	a0,ffffffffc02081e2 <get_device+0xd8>
ffffffffc02081a8:	617c                	ld	a5,192(a0)
ffffffffc02081aa:	9782                	jalr	a5
ffffffffc02081ac:	87aa                	mv	a5,a0
ffffffffc02081ae:	6522                	ld	a0,8(sp)
ffffffffc02081b0:	e09c                	sd	a5,0(s1)
ffffffffc02081b2:	f68ff0ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc02081b6:	02f00713          	li	a4,47
ffffffffc02081ba:	a011                	j	ffffffffc02081be <get_device+0xb4>
ffffffffc02081bc:	0405                	addi	s0,s0,1
ffffffffc02081be:	00044783          	lbu	a5,0(s0)
ffffffffc02081c2:	fee78de3          	beq	a5,a4,ffffffffc02081bc <get_device+0xb2>
ffffffffc02081c6:	00893023          	sd	s0,0(s2)
ffffffffc02081ca:	4501                	li	a0,0
ffffffffc02081cc:	70a2                	ld	ra,40(sp)
ffffffffc02081ce:	7402                	ld	s0,32(sp)
ffffffffc02081d0:	64e2                	ld	s1,24(sp)
ffffffffc02081d2:	6942                	ld	s2,16(sp)
ffffffffc02081d4:	6145                	addi	sp,sp,48
ffffffffc02081d6:	8082                	ret
ffffffffc02081d8:	8526                	mv	a0,s1
ffffffffc02081da:	93fff0ef          	jal	ra,ffffffffc0207b18 <vfs_get_bootfs>
ffffffffc02081de:	dd61                	beqz	a0,ffffffffc02081b6 <get_device+0xac>
ffffffffc02081e0:	b7f5                	j	ffffffffc02081cc <get_device+0xc2>
ffffffffc02081e2:	00006697          	auipc	a3,0x6
ffffffffc02081e6:	5f668693          	addi	a3,a3,1526 # ffffffffc020e7d8 <syscalls+0xcd8>
ffffffffc02081ea:	00003617          	auipc	a2,0x3
ffffffffc02081ee:	79e60613          	addi	a2,a2,1950 # ffffffffc020b988 <commands+0x210>
ffffffffc02081f2:	03900593          	li	a1,57
ffffffffc02081f6:	00006517          	auipc	a0,0x6
ffffffffc02081fa:	5ca50513          	addi	a0,a0,1482 # ffffffffc020e7c0 <syscalls+0xcc0>
ffffffffc02081fe:	aa0f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208202:	00006697          	auipc	a3,0x6
ffffffffc0208206:	5ae68693          	addi	a3,a3,1454 # ffffffffc020e7b0 <syscalls+0xcb0>
ffffffffc020820a:	00003617          	auipc	a2,0x3
ffffffffc020820e:	77e60613          	addi	a2,a2,1918 # ffffffffc020b988 <commands+0x210>
ffffffffc0208212:	03300593          	li	a1,51
ffffffffc0208216:	00006517          	auipc	a0,0x6
ffffffffc020821a:	5aa50513          	addi	a0,a0,1450 # ffffffffc020e7c0 <syscalls+0xcc0>
ffffffffc020821e:	a80f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208222 <vfs_lookup>:
ffffffffc0208222:	7139                	addi	sp,sp,-64
ffffffffc0208224:	f426                	sd	s1,40(sp)
ffffffffc0208226:	0830                	addi	a2,sp,24
ffffffffc0208228:	84ae                	mv	s1,a1
ffffffffc020822a:	002c                	addi	a1,sp,8
ffffffffc020822c:	f822                	sd	s0,48(sp)
ffffffffc020822e:	fc06                	sd	ra,56(sp)
ffffffffc0208230:	f04a                	sd	s2,32(sp)
ffffffffc0208232:	e42a                	sd	a0,8(sp)
ffffffffc0208234:	ed7ff0ef          	jal	ra,ffffffffc020810a <get_device>
ffffffffc0208238:	842a                	mv	s0,a0
ffffffffc020823a:	ed1d                	bnez	a0,ffffffffc0208278 <vfs_lookup+0x56>
ffffffffc020823c:	67a2                	ld	a5,8(sp)
ffffffffc020823e:	6962                	ld	s2,24(sp)
ffffffffc0208240:	0007c783          	lbu	a5,0(a5)
ffffffffc0208244:	c3a9                	beqz	a5,ffffffffc0208286 <vfs_lookup+0x64>
ffffffffc0208246:	04090963          	beqz	s2,ffffffffc0208298 <vfs_lookup+0x76>
ffffffffc020824a:	07093783          	ld	a5,112(s2)
ffffffffc020824e:	c7a9                	beqz	a5,ffffffffc0208298 <vfs_lookup+0x76>
ffffffffc0208250:	7bbc                	ld	a5,112(a5)
ffffffffc0208252:	c3b9                	beqz	a5,ffffffffc0208298 <vfs_lookup+0x76>
ffffffffc0208254:	854a                	mv	a0,s2
ffffffffc0208256:	00006597          	auipc	a1,0x6
ffffffffc020825a:	5ea58593          	addi	a1,a1,1514 # ffffffffc020e840 <syscalls+0xd40>
ffffffffc020825e:	e06ff0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0208262:	07093783          	ld	a5,112(s2)
ffffffffc0208266:	65a2                	ld	a1,8(sp)
ffffffffc0208268:	6562                	ld	a0,24(sp)
ffffffffc020826a:	7bbc                	ld	a5,112(a5)
ffffffffc020826c:	8626                	mv	a2,s1
ffffffffc020826e:	9782                	jalr	a5
ffffffffc0208270:	842a                	mv	s0,a0
ffffffffc0208272:	6562                	ld	a0,24(sp)
ffffffffc0208274:	ea6ff0ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc0208278:	70e2                	ld	ra,56(sp)
ffffffffc020827a:	8522                	mv	a0,s0
ffffffffc020827c:	7442                	ld	s0,48(sp)
ffffffffc020827e:	74a2                	ld	s1,40(sp)
ffffffffc0208280:	7902                	ld	s2,32(sp)
ffffffffc0208282:	6121                	addi	sp,sp,64
ffffffffc0208284:	8082                	ret
ffffffffc0208286:	70e2                	ld	ra,56(sp)
ffffffffc0208288:	8522                	mv	a0,s0
ffffffffc020828a:	7442                	ld	s0,48(sp)
ffffffffc020828c:	0124b023          	sd	s2,0(s1)
ffffffffc0208290:	74a2                	ld	s1,40(sp)
ffffffffc0208292:	7902                	ld	s2,32(sp)
ffffffffc0208294:	6121                	addi	sp,sp,64
ffffffffc0208296:	8082                	ret
ffffffffc0208298:	00006697          	auipc	a3,0x6
ffffffffc020829c:	55868693          	addi	a3,a3,1368 # ffffffffc020e7f0 <syscalls+0xcf0>
ffffffffc02082a0:	00003617          	auipc	a2,0x3
ffffffffc02082a4:	6e860613          	addi	a2,a2,1768 # ffffffffc020b988 <commands+0x210>
ffffffffc02082a8:	04f00593          	li	a1,79
ffffffffc02082ac:	00006517          	auipc	a0,0x6
ffffffffc02082b0:	51450513          	addi	a0,a0,1300 # ffffffffc020e7c0 <syscalls+0xcc0>
ffffffffc02082b4:	9eaf80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02082b8 <vfs_lookup_parent>:
ffffffffc02082b8:	7139                	addi	sp,sp,-64
ffffffffc02082ba:	f822                	sd	s0,48(sp)
ffffffffc02082bc:	f426                	sd	s1,40(sp)
ffffffffc02082be:	842e                	mv	s0,a1
ffffffffc02082c0:	84b2                	mv	s1,a2
ffffffffc02082c2:	002c                	addi	a1,sp,8
ffffffffc02082c4:	0830                	addi	a2,sp,24
ffffffffc02082c6:	fc06                	sd	ra,56(sp)
ffffffffc02082c8:	e42a                	sd	a0,8(sp)
ffffffffc02082ca:	e41ff0ef          	jal	ra,ffffffffc020810a <get_device>
ffffffffc02082ce:	e509                	bnez	a0,ffffffffc02082d8 <vfs_lookup_parent+0x20>
ffffffffc02082d0:	67a2                	ld	a5,8(sp)
ffffffffc02082d2:	e09c                	sd	a5,0(s1)
ffffffffc02082d4:	67e2                	ld	a5,24(sp)
ffffffffc02082d6:	e01c                	sd	a5,0(s0)
ffffffffc02082d8:	70e2                	ld	ra,56(sp)
ffffffffc02082da:	7442                	ld	s0,48(sp)
ffffffffc02082dc:	74a2                	ld	s1,40(sp)
ffffffffc02082de:	6121                	addi	sp,sp,64
ffffffffc02082e0:	8082                	ret

ffffffffc02082e2 <vfs_get_curdir>:
ffffffffc02082e2:	0008e797          	auipc	a5,0x8e
ffffffffc02082e6:	5de7b783          	ld	a5,1502(a5) # ffffffffc02968c0 <current>
ffffffffc02082ea:	1487b783          	ld	a5,328(a5)
ffffffffc02082ee:	1101                	addi	sp,sp,-32
ffffffffc02082f0:	e426                	sd	s1,8(sp)
ffffffffc02082f2:	6384                	ld	s1,0(a5)
ffffffffc02082f4:	ec06                	sd	ra,24(sp)
ffffffffc02082f6:	e822                	sd	s0,16(sp)
ffffffffc02082f8:	cc81                	beqz	s1,ffffffffc0208310 <vfs_get_curdir+0x2e>
ffffffffc02082fa:	842a                	mv	s0,a0
ffffffffc02082fc:	8526                	mv	a0,s1
ffffffffc02082fe:	d4eff0ef          	jal	ra,ffffffffc020784c <inode_ref_inc>
ffffffffc0208302:	4501                	li	a0,0
ffffffffc0208304:	e004                	sd	s1,0(s0)
ffffffffc0208306:	60e2                	ld	ra,24(sp)
ffffffffc0208308:	6442                	ld	s0,16(sp)
ffffffffc020830a:	64a2                	ld	s1,8(sp)
ffffffffc020830c:	6105                	addi	sp,sp,32
ffffffffc020830e:	8082                	ret
ffffffffc0208310:	5541                	li	a0,-16
ffffffffc0208312:	bfd5                	j	ffffffffc0208306 <vfs_get_curdir+0x24>

ffffffffc0208314 <vfs_set_curdir>:
ffffffffc0208314:	7139                	addi	sp,sp,-64
ffffffffc0208316:	f04a                	sd	s2,32(sp)
ffffffffc0208318:	0008e917          	auipc	s2,0x8e
ffffffffc020831c:	5a890913          	addi	s2,s2,1448 # ffffffffc02968c0 <current>
ffffffffc0208320:	00093783          	ld	a5,0(s2)
ffffffffc0208324:	f822                	sd	s0,48(sp)
ffffffffc0208326:	842a                	mv	s0,a0
ffffffffc0208328:	1487b503          	ld	a0,328(a5)
ffffffffc020832c:	ec4e                	sd	s3,24(sp)
ffffffffc020832e:	fc06                	sd	ra,56(sp)
ffffffffc0208330:	f426                	sd	s1,40(sp)
ffffffffc0208332:	e91fc0ef          	jal	ra,ffffffffc02051c2 <lock_files>
ffffffffc0208336:	00093783          	ld	a5,0(s2)
ffffffffc020833a:	1487b503          	ld	a0,328(a5)
ffffffffc020833e:	00053983          	ld	s3,0(a0)
ffffffffc0208342:	07340963          	beq	s0,s3,ffffffffc02083b4 <vfs_set_curdir+0xa0>
ffffffffc0208346:	cc39                	beqz	s0,ffffffffc02083a4 <vfs_set_curdir+0x90>
ffffffffc0208348:	783c                	ld	a5,112(s0)
ffffffffc020834a:	c7bd                	beqz	a5,ffffffffc02083b8 <vfs_set_curdir+0xa4>
ffffffffc020834c:	6bbc                	ld	a5,80(a5)
ffffffffc020834e:	c7ad                	beqz	a5,ffffffffc02083b8 <vfs_set_curdir+0xa4>
ffffffffc0208350:	00006597          	auipc	a1,0x6
ffffffffc0208354:	56058593          	addi	a1,a1,1376 # ffffffffc020e8b0 <syscalls+0xdb0>
ffffffffc0208358:	8522                	mv	a0,s0
ffffffffc020835a:	d0aff0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc020835e:	783c                	ld	a5,112(s0)
ffffffffc0208360:	006c                	addi	a1,sp,12
ffffffffc0208362:	8522                	mv	a0,s0
ffffffffc0208364:	6bbc                	ld	a5,80(a5)
ffffffffc0208366:	9782                	jalr	a5
ffffffffc0208368:	84aa                	mv	s1,a0
ffffffffc020836a:	e901                	bnez	a0,ffffffffc020837a <vfs_set_curdir+0x66>
ffffffffc020836c:	47b2                	lw	a5,12(sp)
ffffffffc020836e:	669d                	lui	a3,0x7
ffffffffc0208370:	6709                	lui	a4,0x2
ffffffffc0208372:	8ff5                	and	a5,a5,a3
ffffffffc0208374:	54b9                	li	s1,-18
ffffffffc0208376:	02e78063          	beq	a5,a4,ffffffffc0208396 <vfs_set_curdir+0x82>
ffffffffc020837a:	00093783          	ld	a5,0(s2)
ffffffffc020837e:	1487b503          	ld	a0,328(a5)
ffffffffc0208382:	e47fc0ef          	jal	ra,ffffffffc02051c8 <unlock_files>
ffffffffc0208386:	70e2                	ld	ra,56(sp)
ffffffffc0208388:	7442                	ld	s0,48(sp)
ffffffffc020838a:	7902                	ld	s2,32(sp)
ffffffffc020838c:	69e2                	ld	s3,24(sp)
ffffffffc020838e:	8526                	mv	a0,s1
ffffffffc0208390:	74a2                	ld	s1,40(sp)
ffffffffc0208392:	6121                	addi	sp,sp,64
ffffffffc0208394:	8082                	ret
ffffffffc0208396:	8522                	mv	a0,s0
ffffffffc0208398:	cb4ff0ef          	jal	ra,ffffffffc020784c <inode_ref_inc>
ffffffffc020839c:	00093783          	ld	a5,0(s2)
ffffffffc02083a0:	1487b503          	ld	a0,328(a5)
ffffffffc02083a4:	e100                	sd	s0,0(a0)
ffffffffc02083a6:	4481                	li	s1,0
ffffffffc02083a8:	fc098de3          	beqz	s3,ffffffffc0208382 <vfs_set_curdir+0x6e>
ffffffffc02083ac:	854e                	mv	a0,s3
ffffffffc02083ae:	d6cff0ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc02083b2:	b7e1                	j	ffffffffc020837a <vfs_set_curdir+0x66>
ffffffffc02083b4:	4481                	li	s1,0
ffffffffc02083b6:	b7f1                	j	ffffffffc0208382 <vfs_set_curdir+0x6e>
ffffffffc02083b8:	00006697          	auipc	a3,0x6
ffffffffc02083bc:	49068693          	addi	a3,a3,1168 # ffffffffc020e848 <syscalls+0xd48>
ffffffffc02083c0:	00003617          	auipc	a2,0x3
ffffffffc02083c4:	5c860613          	addi	a2,a2,1480 # ffffffffc020b988 <commands+0x210>
ffffffffc02083c8:	04300593          	li	a1,67
ffffffffc02083cc:	00006517          	auipc	a0,0x6
ffffffffc02083d0:	4cc50513          	addi	a0,a0,1228 # ffffffffc020e898 <syscalls+0xd98>
ffffffffc02083d4:	8caf80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02083d8 <vfs_chdir>:
ffffffffc02083d8:	1101                	addi	sp,sp,-32
ffffffffc02083da:	002c                	addi	a1,sp,8
ffffffffc02083dc:	e822                	sd	s0,16(sp)
ffffffffc02083de:	ec06                	sd	ra,24(sp)
ffffffffc02083e0:	e43ff0ef          	jal	ra,ffffffffc0208222 <vfs_lookup>
ffffffffc02083e4:	842a                	mv	s0,a0
ffffffffc02083e6:	c511                	beqz	a0,ffffffffc02083f2 <vfs_chdir+0x1a>
ffffffffc02083e8:	60e2                	ld	ra,24(sp)
ffffffffc02083ea:	8522                	mv	a0,s0
ffffffffc02083ec:	6442                	ld	s0,16(sp)
ffffffffc02083ee:	6105                	addi	sp,sp,32
ffffffffc02083f0:	8082                	ret
ffffffffc02083f2:	6522                	ld	a0,8(sp)
ffffffffc02083f4:	f21ff0ef          	jal	ra,ffffffffc0208314 <vfs_set_curdir>
ffffffffc02083f8:	842a                	mv	s0,a0
ffffffffc02083fa:	6522                	ld	a0,8(sp)
ffffffffc02083fc:	d1eff0ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc0208400:	60e2                	ld	ra,24(sp)
ffffffffc0208402:	8522                	mv	a0,s0
ffffffffc0208404:	6442                	ld	s0,16(sp)
ffffffffc0208406:	6105                	addi	sp,sp,32
ffffffffc0208408:	8082                	ret

ffffffffc020840a <vfs_getcwd>:
ffffffffc020840a:	0008e797          	auipc	a5,0x8e
ffffffffc020840e:	4b67b783          	ld	a5,1206(a5) # ffffffffc02968c0 <current>
ffffffffc0208412:	1487b783          	ld	a5,328(a5)
ffffffffc0208416:	7179                	addi	sp,sp,-48
ffffffffc0208418:	ec26                	sd	s1,24(sp)
ffffffffc020841a:	6384                	ld	s1,0(a5)
ffffffffc020841c:	f406                	sd	ra,40(sp)
ffffffffc020841e:	f022                	sd	s0,32(sp)
ffffffffc0208420:	e84a                	sd	s2,16(sp)
ffffffffc0208422:	ccbd                	beqz	s1,ffffffffc02084a0 <vfs_getcwd+0x96>
ffffffffc0208424:	892a                	mv	s2,a0
ffffffffc0208426:	8526                	mv	a0,s1
ffffffffc0208428:	c24ff0ef          	jal	ra,ffffffffc020784c <inode_ref_inc>
ffffffffc020842c:	74a8                	ld	a0,104(s1)
ffffffffc020842e:	c93d                	beqz	a0,ffffffffc02084a4 <vfs_getcwd+0x9a>
ffffffffc0208430:	9b3ff0ef          	jal	ra,ffffffffc0207de2 <vfs_get_devname>
ffffffffc0208434:	842a                	mv	s0,a0
ffffffffc0208436:	7c9020ef          	jal	ra,ffffffffc020b3fe <strlen>
ffffffffc020843a:	862a                	mv	a2,a0
ffffffffc020843c:	85a2                	mv	a1,s0
ffffffffc020843e:	4701                	li	a4,0
ffffffffc0208440:	4685                	li	a3,1
ffffffffc0208442:	854a                	mv	a0,s2
ffffffffc0208444:	fa9fc0ef          	jal	ra,ffffffffc02053ec <iobuf_move>
ffffffffc0208448:	842a                	mv	s0,a0
ffffffffc020844a:	c919                	beqz	a0,ffffffffc0208460 <vfs_getcwd+0x56>
ffffffffc020844c:	8526                	mv	a0,s1
ffffffffc020844e:	cccff0ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc0208452:	70a2                	ld	ra,40(sp)
ffffffffc0208454:	8522                	mv	a0,s0
ffffffffc0208456:	7402                	ld	s0,32(sp)
ffffffffc0208458:	64e2                	ld	s1,24(sp)
ffffffffc020845a:	6942                	ld	s2,16(sp)
ffffffffc020845c:	6145                	addi	sp,sp,48
ffffffffc020845e:	8082                	ret
ffffffffc0208460:	03a00793          	li	a5,58
ffffffffc0208464:	4701                	li	a4,0
ffffffffc0208466:	4685                	li	a3,1
ffffffffc0208468:	4605                	li	a2,1
ffffffffc020846a:	00f10593          	addi	a1,sp,15
ffffffffc020846e:	854a                	mv	a0,s2
ffffffffc0208470:	00f107a3          	sb	a5,15(sp)
ffffffffc0208474:	f79fc0ef          	jal	ra,ffffffffc02053ec <iobuf_move>
ffffffffc0208478:	842a                	mv	s0,a0
ffffffffc020847a:	f969                	bnez	a0,ffffffffc020844c <vfs_getcwd+0x42>
ffffffffc020847c:	78bc                	ld	a5,112(s1)
ffffffffc020847e:	c3b9                	beqz	a5,ffffffffc02084c4 <vfs_getcwd+0xba>
ffffffffc0208480:	7f9c                	ld	a5,56(a5)
ffffffffc0208482:	c3a9                	beqz	a5,ffffffffc02084c4 <vfs_getcwd+0xba>
ffffffffc0208484:	00006597          	auipc	a1,0x6
ffffffffc0208488:	48c58593          	addi	a1,a1,1164 # ffffffffc020e910 <syscalls+0xe10>
ffffffffc020848c:	8526                	mv	a0,s1
ffffffffc020848e:	bd6ff0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0208492:	78bc                	ld	a5,112(s1)
ffffffffc0208494:	85ca                	mv	a1,s2
ffffffffc0208496:	8526                	mv	a0,s1
ffffffffc0208498:	7f9c                	ld	a5,56(a5)
ffffffffc020849a:	9782                	jalr	a5
ffffffffc020849c:	842a                	mv	s0,a0
ffffffffc020849e:	b77d                	j	ffffffffc020844c <vfs_getcwd+0x42>
ffffffffc02084a0:	5441                	li	s0,-16
ffffffffc02084a2:	bf45                	j	ffffffffc0208452 <vfs_getcwd+0x48>
ffffffffc02084a4:	00006697          	auipc	a3,0x6
ffffffffc02084a8:	33468693          	addi	a3,a3,820 # ffffffffc020e7d8 <syscalls+0xcd8>
ffffffffc02084ac:	00003617          	auipc	a2,0x3
ffffffffc02084b0:	4dc60613          	addi	a2,a2,1244 # ffffffffc020b988 <commands+0x210>
ffffffffc02084b4:	06e00593          	li	a1,110
ffffffffc02084b8:	00006517          	auipc	a0,0x6
ffffffffc02084bc:	3e050513          	addi	a0,a0,992 # ffffffffc020e898 <syscalls+0xd98>
ffffffffc02084c0:	fdff70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02084c4:	00006697          	auipc	a3,0x6
ffffffffc02084c8:	3f468693          	addi	a3,a3,1012 # ffffffffc020e8b8 <syscalls+0xdb8>
ffffffffc02084cc:	00003617          	auipc	a2,0x3
ffffffffc02084d0:	4bc60613          	addi	a2,a2,1212 # ffffffffc020b988 <commands+0x210>
ffffffffc02084d4:	07800593          	li	a1,120
ffffffffc02084d8:	00006517          	auipc	a0,0x6
ffffffffc02084dc:	3c050513          	addi	a0,a0,960 # ffffffffc020e898 <syscalls+0xd98>
ffffffffc02084e0:	fbff70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02084e4 <dev_lookup>:
ffffffffc02084e4:	0005c783          	lbu	a5,0(a1)
ffffffffc02084e8:	e385                	bnez	a5,ffffffffc0208508 <dev_lookup+0x24>
ffffffffc02084ea:	1101                	addi	sp,sp,-32
ffffffffc02084ec:	e822                	sd	s0,16(sp)
ffffffffc02084ee:	e426                	sd	s1,8(sp)
ffffffffc02084f0:	ec06                	sd	ra,24(sp)
ffffffffc02084f2:	84aa                	mv	s1,a0
ffffffffc02084f4:	8432                	mv	s0,a2
ffffffffc02084f6:	b56ff0ef          	jal	ra,ffffffffc020784c <inode_ref_inc>
ffffffffc02084fa:	60e2                	ld	ra,24(sp)
ffffffffc02084fc:	e004                	sd	s1,0(s0)
ffffffffc02084fe:	6442                	ld	s0,16(sp)
ffffffffc0208500:	64a2                	ld	s1,8(sp)
ffffffffc0208502:	4501                	li	a0,0
ffffffffc0208504:	6105                	addi	sp,sp,32
ffffffffc0208506:	8082                	ret
ffffffffc0208508:	5541                	li	a0,-16
ffffffffc020850a:	8082                	ret

ffffffffc020850c <dev_fstat>:
ffffffffc020850c:	1101                	addi	sp,sp,-32
ffffffffc020850e:	e426                	sd	s1,8(sp)
ffffffffc0208510:	84ae                	mv	s1,a1
ffffffffc0208512:	e822                	sd	s0,16(sp)
ffffffffc0208514:	02000613          	li	a2,32
ffffffffc0208518:	842a                	mv	s0,a0
ffffffffc020851a:	4581                	li	a1,0
ffffffffc020851c:	8526                	mv	a0,s1
ffffffffc020851e:	ec06                	sd	ra,24(sp)
ffffffffc0208520:	781020ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0208524:	c429                	beqz	s0,ffffffffc020856e <dev_fstat+0x62>
ffffffffc0208526:	783c                	ld	a5,112(s0)
ffffffffc0208528:	c3b9                	beqz	a5,ffffffffc020856e <dev_fstat+0x62>
ffffffffc020852a:	6bbc                	ld	a5,80(a5)
ffffffffc020852c:	c3a9                	beqz	a5,ffffffffc020856e <dev_fstat+0x62>
ffffffffc020852e:	00006597          	auipc	a1,0x6
ffffffffc0208532:	38258593          	addi	a1,a1,898 # ffffffffc020e8b0 <syscalls+0xdb0>
ffffffffc0208536:	8522                	mv	a0,s0
ffffffffc0208538:	b2cff0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc020853c:	783c                	ld	a5,112(s0)
ffffffffc020853e:	85a6                	mv	a1,s1
ffffffffc0208540:	8522                	mv	a0,s0
ffffffffc0208542:	6bbc                	ld	a5,80(a5)
ffffffffc0208544:	9782                	jalr	a5
ffffffffc0208546:	ed19                	bnez	a0,ffffffffc0208564 <dev_fstat+0x58>
ffffffffc0208548:	4c38                	lw	a4,88(s0)
ffffffffc020854a:	6785                	lui	a5,0x1
ffffffffc020854c:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208550:	02f71f63          	bne	a4,a5,ffffffffc020858e <dev_fstat+0x82>
ffffffffc0208554:	6018                	ld	a4,0(s0)
ffffffffc0208556:	641c                	ld	a5,8(s0)
ffffffffc0208558:	4685                	li	a3,1
ffffffffc020855a:	e494                	sd	a3,8(s1)
ffffffffc020855c:	02e787b3          	mul	a5,a5,a4
ffffffffc0208560:	e898                	sd	a4,16(s1)
ffffffffc0208562:	ec9c                	sd	a5,24(s1)
ffffffffc0208564:	60e2                	ld	ra,24(sp)
ffffffffc0208566:	6442                	ld	s0,16(sp)
ffffffffc0208568:	64a2                	ld	s1,8(sp)
ffffffffc020856a:	6105                	addi	sp,sp,32
ffffffffc020856c:	8082                	ret
ffffffffc020856e:	00006697          	auipc	a3,0x6
ffffffffc0208572:	2da68693          	addi	a3,a3,730 # ffffffffc020e848 <syscalls+0xd48>
ffffffffc0208576:	00003617          	auipc	a2,0x3
ffffffffc020857a:	41260613          	addi	a2,a2,1042 # ffffffffc020b988 <commands+0x210>
ffffffffc020857e:	04200593          	li	a1,66
ffffffffc0208582:	00006517          	auipc	a0,0x6
ffffffffc0208586:	39e50513          	addi	a0,a0,926 # ffffffffc020e920 <syscalls+0xe20>
ffffffffc020858a:	f15f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020858e:	00006697          	auipc	a3,0x6
ffffffffc0208592:	08268693          	addi	a3,a3,130 # ffffffffc020e610 <syscalls+0xb10>
ffffffffc0208596:	00003617          	auipc	a2,0x3
ffffffffc020859a:	3f260613          	addi	a2,a2,1010 # ffffffffc020b988 <commands+0x210>
ffffffffc020859e:	04500593          	li	a1,69
ffffffffc02085a2:	00006517          	auipc	a0,0x6
ffffffffc02085a6:	37e50513          	addi	a0,a0,894 # ffffffffc020e920 <syscalls+0xe20>
ffffffffc02085aa:	ef5f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02085ae <dev_ioctl>:
ffffffffc02085ae:	c909                	beqz	a0,ffffffffc02085c0 <dev_ioctl+0x12>
ffffffffc02085b0:	4d34                	lw	a3,88(a0)
ffffffffc02085b2:	6705                	lui	a4,0x1
ffffffffc02085b4:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02085b8:	00e69463          	bne	a3,a4,ffffffffc02085c0 <dev_ioctl+0x12>
ffffffffc02085bc:	751c                	ld	a5,40(a0)
ffffffffc02085be:	8782                	jr	a5
ffffffffc02085c0:	1141                	addi	sp,sp,-16
ffffffffc02085c2:	00006697          	auipc	a3,0x6
ffffffffc02085c6:	04e68693          	addi	a3,a3,78 # ffffffffc020e610 <syscalls+0xb10>
ffffffffc02085ca:	00003617          	auipc	a2,0x3
ffffffffc02085ce:	3be60613          	addi	a2,a2,958 # ffffffffc020b988 <commands+0x210>
ffffffffc02085d2:	03500593          	li	a1,53
ffffffffc02085d6:	00006517          	auipc	a0,0x6
ffffffffc02085da:	34a50513          	addi	a0,a0,842 # ffffffffc020e920 <syscalls+0xe20>
ffffffffc02085de:	e406                	sd	ra,8(sp)
ffffffffc02085e0:	ebff70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02085e4 <dev_tryseek>:
ffffffffc02085e4:	c51d                	beqz	a0,ffffffffc0208612 <dev_tryseek+0x2e>
ffffffffc02085e6:	4d38                	lw	a4,88(a0)
ffffffffc02085e8:	6785                	lui	a5,0x1
ffffffffc02085ea:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02085ee:	02f71263          	bne	a4,a5,ffffffffc0208612 <dev_tryseek+0x2e>
ffffffffc02085f2:	611c                	ld	a5,0(a0)
ffffffffc02085f4:	cf89                	beqz	a5,ffffffffc020860e <dev_tryseek+0x2a>
ffffffffc02085f6:	6518                	ld	a4,8(a0)
ffffffffc02085f8:	02e5f6b3          	remu	a3,a1,a4
ffffffffc02085fc:	ea89                	bnez	a3,ffffffffc020860e <dev_tryseek+0x2a>
ffffffffc02085fe:	0005c863          	bltz	a1,ffffffffc020860e <dev_tryseek+0x2a>
ffffffffc0208602:	02e787b3          	mul	a5,a5,a4
ffffffffc0208606:	00f5f463          	bgeu	a1,a5,ffffffffc020860e <dev_tryseek+0x2a>
ffffffffc020860a:	4501                	li	a0,0
ffffffffc020860c:	8082                	ret
ffffffffc020860e:	5575                	li	a0,-3
ffffffffc0208610:	8082                	ret
ffffffffc0208612:	1141                	addi	sp,sp,-16
ffffffffc0208614:	00006697          	auipc	a3,0x6
ffffffffc0208618:	ffc68693          	addi	a3,a3,-4 # ffffffffc020e610 <syscalls+0xb10>
ffffffffc020861c:	00003617          	auipc	a2,0x3
ffffffffc0208620:	36c60613          	addi	a2,a2,876 # ffffffffc020b988 <commands+0x210>
ffffffffc0208624:	05f00593          	li	a1,95
ffffffffc0208628:	00006517          	auipc	a0,0x6
ffffffffc020862c:	2f850513          	addi	a0,a0,760 # ffffffffc020e920 <syscalls+0xe20>
ffffffffc0208630:	e406                	sd	ra,8(sp)
ffffffffc0208632:	e6df70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208636 <dev_gettype>:
ffffffffc0208636:	c10d                	beqz	a0,ffffffffc0208658 <dev_gettype+0x22>
ffffffffc0208638:	4d38                	lw	a4,88(a0)
ffffffffc020863a:	6785                	lui	a5,0x1
ffffffffc020863c:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208640:	00f71c63          	bne	a4,a5,ffffffffc0208658 <dev_gettype+0x22>
ffffffffc0208644:	6118                	ld	a4,0(a0)
ffffffffc0208646:	6795                	lui	a5,0x5
ffffffffc0208648:	c701                	beqz	a4,ffffffffc0208650 <dev_gettype+0x1a>
ffffffffc020864a:	c19c                	sw	a5,0(a1)
ffffffffc020864c:	4501                	li	a0,0
ffffffffc020864e:	8082                	ret
ffffffffc0208650:	6791                	lui	a5,0x4
ffffffffc0208652:	c19c                	sw	a5,0(a1)
ffffffffc0208654:	4501                	li	a0,0
ffffffffc0208656:	8082                	ret
ffffffffc0208658:	1141                	addi	sp,sp,-16
ffffffffc020865a:	00006697          	auipc	a3,0x6
ffffffffc020865e:	fb668693          	addi	a3,a3,-74 # ffffffffc020e610 <syscalls+0xb10>
ffffffffc0208662:	00003617          	auipc	a2,0x3
ffffffffc0208666:	32660613          	addi	a2,a2,806 # ffffffffc020b988 <commands+0x210>
ffffffffc020866a:	05300593          	li	a1,83
ffffffffc020866e:	00006517          	auipc	a0,0x6
ffffffffc0208672:	2b250513          	addi	a0,a0,690 # ffffffffc020e920 <syscalls+0xe20>
ffffffffc0208676:	e406                	sd	ra,8(sp)
ffffffffc0208678:	e27f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020867c <dev_write>:
ffffffffc020867c:	c911                	beqz	a0,ffffffffc0208690 <dev_write+0x14>
ffffffffc020867e:	4d34                	lw	a3,88(a0)
ffffffffc0208680:	6705                	lui	a4,0x1
ffffffffc0208682:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208686:	00e69563          	bne	a3,a4,ffffffffc0208690 <dev_write+0x14>
ffffffffc020868a:	711c                	ld	a5,32(a0)
ffffffffc020868c:	4605                	li	a2,1
ffffffffc020868e:	8782                	jr	a5
ffffffffc0208690:	1141                	addi	sp,sp,-16
ffffffffc0208692:	00006697          	auipc	a3,0x6
ffffffffc0208696:	f7e68693          	addi	a3,a3,-130 # ffffffffc020e610 <syscalls+0xb10>
ffffffffc020869a:	00003617          	auipc	a2,0x3
ffffffffc020869e:	2ee60613          	addi	a2,a2,750 # ffffffffc020b988 <commands+0x210>
ffffffffc02086a2:	02c00593          	li	a1,44
ffffffffc02086a6:	00006517          	auipc	a0,0x6
ffffffffc02086aa:	27a50513          	addi	a0,a0,634 # ffffffffc020e920 <syscalls+0xe20>
ffffffffc02086ae:	e406                	sd	ra,8(sp)
ffffffffc02086b0:	deff70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02086b4 <dev_read>:
ffffffffc02086b4:	c911                	beqz	a0,ffffffffc02086c8 <dev_read+0x14>
ffffffffc02086b6:	4d34                	lw	a3,88(a0)
ffffffffc02086b8:	6705                	lui	a4,0x1
ffffffffc02086ba:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02086be:	00e69563          	bne	a3,a4,ffffffffc02086c8 <dev_read+0x14>
ffffffffc02086c2:	711c                	ld	a5,32(a0)
ffffffffc02086c4:	4601                	li	a2,0
ffffffffc02086c6:	8782                	jr	a5
ffffffffc02086c8:	1141                	addi	sp,sp,-16
ffffffffc02086ca:	00006697          	auipc	a3,0x6
ffffffffc02086ce:	f4668693          	addi	a3,a3,-186 # ffffffffc020e610 <syscalls+0xb10>
ffffffffc02086d2:	00003617          	auipc	a2,0x3
ffffffffc02086d6:	2b660613          	addi	a2,a2,694 # ffffffffc020b988 <commands+0x210>
ffffffffc02086da:	02300593          	li	a1,35
ffffffffc02086de:	00006517          	auipc	a0,0x6
ffffffffc02086e2:	24250513          	addi	a0,a0,578 # ffffffffc020e920 <syscalls+0xe20>
ffffffffc02086e6:	e406                	sd	ra,8(sp)
ffffffffc02086e8:	db7f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02086ec <dev_close>:
ffffffffc02086ec:	c909                	beqz	a0,ffffffffc02086fe <dev_close+0x12>
ffffffffc02086ee:	4d34                	lw	a3,88(a0)
ffffffffc02086f0:	6705                	lui	a4,0x1
ffffffffc02086f2:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02086f6:	00e69463          	bne	a3,a4,ffffffffc02086fe <dev_close+0x12>
ffffffffc02086fa:	6d1c                	ld	a5,24(a0)
ffffffffc02086fc:	8782                	jr	a5
ffffffffc02086fe:	1141                	addi	sp,sp,-16
ffffffffc0208700:	00006697          	auipc	a3,0x6
ffffffffc0208704:	f1068693          	addi	a3,a3,-240 # ffffffffc020e610 <syscalls+0xb10>
ffffffffc0208708:	00003617          	auipc	a2,0x3
ffffffffc020870c:	28060613          	addi	a2,a2,640 # ffffffffc020b988 <commands+0x210>
ffffffffc0208710:	45e9                	li	a1,26
ffffffffc0208712:	00006517          	auipc	a0,0x6
ffffffffc0208716:	20e50513          	addi	a0,a0,526 # ffffffffc020e920 <syscalls+0xe20>
ffffffffc020871a:	e406                	sd	ra,8(sp)
ffffffffc020871c:	d83f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208720 <dev_open>:
ffffffffc0208720:	03c5f713          	andi	a4,a1,60
ffffffffc0208724:	eb11                	bnez	a4,ffffffffc0208738 <dev_open+0x18>
ffffffffc0208726:	c919                	beqz	a0,ffffffffc020873c <dev_open+0x1c>
ffffffffc0208728:	4d34                	lw	a3,88(a0)
ffffffffc020872a:	6705                	lui	a4,0x1
ffffffffc020872c:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208730:	00e69663          	bne	a3,a4,ffffffffc020873c <dev_open+0x1c>
ffffffffc0208734:	691c                	ld	a5,16(a0)
ffffffffc0208736:	8782                	jr	a5
ffffffffc0208738:	5575                	li	a0,-3
ffffffffc020873a:	8082                	ret
ffffffffc020873c:	1141                	addi	sp,sp,-16
ffffffffc020873e:	00006697          	auipc	a3,0x6
ffffffffc0208742:	ed268693          	addi	a3,a3,-302 # ffffffffc020e610 <syscalls+0xb10>
ffffffffc0208746:	00003617          	auipc	a2,0x3
ffffffffc020874a:	24260613          	addi	a2,a2,578 # ffffffffc020b988 <commands+0x210>
ffffffffc020874e:	45c5                	li	a1,17
ffffffffc0208750:	00006517          	auipc	a0,0x6
ffffffffc0208754:	1d050513          	addi	a0,a0,464 # ffffffffc020e920 <syscalls+0xe20>
ffffffffc0208758:	e406                	sd	ra,8(sp)
ffffffffc020875a:	d45f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020875e <dev_init>:
ffffffffc020875e:	1141                	addi	sp,sp,-16
ffffffffc0208760:	e406                	sd	ra,8(sp)
ffffffffc0208762:	542000ef          	jal	ra,ffffffffc0208ca4 <dev_init_stdin>
ffffffffc0208766:	65a000ef          	jal	ra,ffffffffc0208dc0 <dev_init_stdout>
ffffffffc020876a:	60a2                	ld	ra,8(sp)
ffffffffc020876c:	0141                	addi	sp,sp,16
ffffffffc020876e:	a439                	j	ffffffffc020897c <dev_init_disk0>

ffffffffc0208770 <dev_create_inode>:
ffffffffc0208770:	6505                	lui	a0,0x1
ffffffffc0208772:	1141                	addi	sp,sp,-16
ffffffffc0208774:	23450513          	addi	a0,a0,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208778:	e022                	sd	s0,0(sp)
ffffffffc020877a:	e406                	sd	ra,8(sp)
ffffffffc020877c:	852ff0ef          	jal	ra,ffffffffc02077ce <__alloc_inode>
ffffffffc0208780:	842a                	mv	s0,a0
ffffffffc0208782:	c901                	beqz	a0,ffffffffc0208792 <dev_create_inode+0x22>
ffffffffc0208784:	4601                	li	a2,0
ffffffffc0208786:	00006597          	auipc	a1,0x6
ffffffffc020878a:	1b258593          	addi	a1,a1,434 # ffffffffc020e938 <dev_node_ops>
ffffffffc020878e:	85cff0ef          	jal	ra,ffffffffc02077ea <inode_init>
ffffffffc0208792:	60a2                	ld	ra,8(sp)
ffffffffc0208794:	8522                	mv	a0,s0
ffffffffc0208796:	6402                	ld	s0,0(sp)
ffffffffc0208798:	0141                	addi	sp,sp,16
ffffffffc020879a:	8082                	ret

ffffffffc020879c <disk0_open>:
ffffffffc020879c:	4501                	li	a0,0
ffffffffc020879e:	8082                	ret

ffffffffc02087a0 <disk0_close>:
ffffffffc02087a0:	4501                	li	a0,0
ffffffffc02087a2:	8082                	ret

ffffffffc02087a4 <disk0_ioctl>:
ffffffffc02087a4:	5531                	li	a0,-20
ffffffffc02087a6:	8082                	ret

ffffffffc02087a8 <disk0_io>:
ffffffffc02087a8:	659c                	ld	a5,8(a1)
ffffffffc02087aa:	7159                	addi	sp,sp,-112
ffffffffc02087ac:	eca6                	sd	s1,88(sp)
ffffffffc02087ae:	f45e                	sd	s7,40(sp)
ffffffffc02087b0:	6d84                	ld	s1,24(a1)
ffffffffc02087b2:	6b85                	lui	s7,0x1
ffffffffc02087b4:	1bfd                	addi	s7,s7,-1
ffffffffc02087b6:	e4ce                	sd	s3,72(sp)
ffffffffc02087b8:	43f7d993          	srai	s3,a5,0x3f
ffffffffc02087bc:	0179f9b3          	and	s3,s3,s7
ffffffffc02087c0:	99be                	add	s3,s3,a5
ffffffffc02087c2:	8fc5                	or	a5,a5,s1
ffffffffc02087c4:	f486                	sd	ra,104(sp)
ffffffffc02087c6:	f0a2                	sd	s0,96(sp)
ffffffffc02087c8:	e8ca                	sd	s2,80(sp)
ffffffffc02087ca:	e0d2                	sd	s4,64(sp)
ffffffffc02087cc:	fc56                	sd	s5,56(sp)
ffffffffc02087ce:	f85a                	sd	s6,48(sp)
ffffffffc02087d0:	f062                	sd	s8,32(sp)
ffffffffc02087d2:	ec66                	sd	s9,24(sp)
ffffffffc02087d4:	e86a                	sd	s10,16(sp)
ffffffffc02087d6:	0177f7b3          	and	a5,a5,s7
ffffffffc02087da:	10079d63          	bnez	a5,ffffffffc02088f4 <disk0_io+0x14c>
ffffffffc02087de:	40c9d993          	srai	s3,s3,0xc
ffffffffc02087e2:	00c4d713          	srli	a4,s1,0xc
ffffffffc02087e6:	2981                	sext.w	s3,s3
ffffffffc02087e8:	2701                	sext.w	a4,a4
ffffffffc02087ea:	00e987bb          	addw	a5,s3,a4
ffffffffc02087ee:	6114                	ld	a3,0(a0)
ffffffffc02087f0:	1782                	slli	a5,a5,0x20
ffffffffc02087f2:	9381                	srli	a5,a5,0x20
ffffffffc02087f4:	10f6e063          	bltu	a3,a5,ffffffffc02088f4 <disk0_io+0x14c>
ffffffffc02087f8:	4501                	li	a0,0
ffffffffc02087fa:	ef19                	bnez	a4,ffffffffc0208818 <disk0_io+0x70>
ffffffffc02087fc:	70a6                	ld	ra,104(sp)
ffffffffc02087fe:	7406                	ld	s0,96(sp)
ffffffffc0208800:	64e6                	ld	s1,88(sp)
ffffffffc0208802:	6946                	ld	s2,80(sp)
ffffffffc0208804:	69a6                	ld	s3,72(sp)
ffffffffc0208806:	6a06                	ld	s4,64(sp)
ffffffffc0208808:	7ae2                	ld	s5,56(sp)
ffffffffc020880a:	7b42                	ld	s6,48(sp)
ffffffffc020880c:	7ba2                	ld	s7,40(sp)
ffffffffc020880e:	7c02                	ld	s8,32(sp)
ffffffffc0208810:	6ce2                	ld	s9,24(sp)
ffffffffc0208812:	6d42                	ld	s10,16(sp)
ffffffffc0208814:	6165                	addi	sp,sp,112
ffffffffc0208816:	8082                	ret
ffffffffc0208818:	0008d517          	auipc	a0,0x8d
ffffffffc020881c:	02850513          	addi	a0,a0,40 # ffffffffc0295840 <disk0_sem>
ffffffffc0208820:	8b2e                	mv	s6,a1
ffffffffc0208822:	8c32                	mv	s8,a2
ffffffffc0208824:	0008ea97          	auipc	s5,0x8e
ffffffffc0208828:	0d4a8a93          	addi	s5,s5,212 # ffffffffc02968f8 <disk0_buffer>
ffffffffc020882c:	d39fb0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc0208830:	6c91                	lui	s9,0x4
ffffffffc0208832:	e4b9                	bnez	s1,ffffffffc0208880 <disk0_io+0xd8>
ffffffffc0208834:	a845                	j	ffffffffc02088e4 <disk0_io+0x13c>
ffffffffc0208836:	00c4d413          	srli	s0,s1,0xc
ffffffffc020883a:	0034169b          	slliw	a3,s0,0x3
ffffffffc020883e:	00068d1b          	sext.w	s10,a3
ffffffffc0208842:	1682                	slli	a3,a3,0x20
ffffffffc0208844:	2401                	sext.w	s0,s0
ffffffffc0208846:	9281                	srli	a3,a3,0x20
ffffffffc0208848:	8926                	mv	s2,s1
ffffffffc020884a:	00399a1b          	slliw	s4,s3,0x3
ffffffffc020884e:	862e                	mv	a2,a1
ffffffffc0208850:	4509                	li	a0,2
ffffffffc0208852:	85d2                	mv	a1,s4
ffffffffc0208854:	aecf80ef          	jal	ra,ffffffffc0200b40 <ide_read_secs>
ffffffffc0208858:	e165                	bnez	a0,ffffffffc0208938 <disk0_io+0x190>
ffffffffc020885a:	000ab583          	ld	a1,0(s5)
ffffffffc020885e:	0038                	addi	a4,sp,8
ffffffffc0208860:	4685                	li	a3,1
ffffffffc0208862:	864a                	mv	a2,s2
ffffffffc0208864:	855a                	mv	a0,s6
ffffffffc0208866:	b87fc0ef          	jal	ra,ffffffffc02053ec <iobuf_move>
ffffffffc020886a:	67a2                	ld	a5,8(sp)
ffffffffc020886c:	09279663          	bne	a5,s2,ffffffffc02088f8 <disk0_io+0x150>
ffffffffc0208870:	017977b3          	and	a5,s2,s7
ffffffffc0208874:	e3d1                	bnez	a5,ffffffffc02088f8 <disk0_io+0x150>
ffffffffc0208876:	412484b3          	sub	s1,s1,s2
ffffffffc020887a:	013409bb          	addw	s3,s0,s3
ffffffffc020887e:	c0bd                	beqz	s1,ffffffffc02088e4 <disk0_io+0x13c>
ffffffffc0208880:	000ab583          	ld	a1,0(s5)
ffffffffc0208884:	000c1b63          	bnez	s8,ffffffffc020889a <disk0_io+0xf2>
ffffffffc0208888:	fb94e7e3          	bltu	s1,s9,ffffffffc0208836 <disk0_io+0x8e>
ffffffffc020888c:	02000693          	li	a3,32
ffffffffc0208890:	02000d13          	li	s10,32
ffffffffc0208894:	4411                	li	s0,4
ffffffffc0208896:	6911                	lui	s2,0x4
ffffffffc0208898:	bf4d                	j	ffffffffc020884a <disk0_io+0xa2>
ffffffffc020889a:	0038                	addi	a4,sp,8
ffffffffc020889c:	4681                	li	a3,0
ffffffffc020889e:	6611                	lui	a2,0x4
ffffffffc02088a0:	855a                	mv	a0,s6
ffffffffc02088a2:	b4bfc0ef          	jal	ra,ffffffffc02053ec <iobuf_move>
ffffffffc02088a6:	6422                	ld	s0,8(sp)
ffffffffc02088a8:	c825                	beqz	s0,ffffffffc0208918 <disk0_io+0x170>
ffffffffc02088aa:	0684e763          	bltu	s1,s0,ffffffffc0208918 <disk0_io+0x170>
ffffffffc02088ae:	017477b3          	and	a5,s0,s7
ffffffffc02088b2:	e3bd                	bnez	a5,ffffffffc0208918 <disk0_io+0x170>
ffffffffc02088b4:	8031                	srli	s0,s0,0xc
ffffffffc02088b6:	0034179b          	slliw	a5,s0,0x3
ffffffffc02088ba:	000ab603          	ld	a2,0(s5)
ffffffffc02088be:	0039991b          	slliw	s2,s3,0x3
ffffffffc02088c2:	02079693          	slli	a3,a5,0x20
ffffffffc02088c6:	9281                	srli	a3,a3,0x20
ffffffffc02088c8:	85ca                	mv	a1,s2
ffffffffc02088ca:	4509                	li	a0,2
ffffffffc02088cc:	2401                	sext.w	s0,s0
ffffffffc02088ce:	00078a1b          	sext.w	s4,a5
ffffffffc02088d2:	b04f80ef          	jal	ra,ffffffffc0200bd6 <ide_write_secs>
ffffffffc02088d6:	e151                	bnez	a0,ffffffffc020895a <disk0_io+0x1b2>
ffffffffc02088d8:	6922                	ld	s2,8(sp)
ffffffffc02088da:	013409bb          	addw	s3,s0,s3
ffffffffc02088de:	412484b3          	sub	s1,s1,s2
ffffffffc02088e2:	fcd9                	bnez	s1,ffffffffc0208880 <disk0_io+0xd8>
ffffffffc02088e4:	0008d517          	auipc	a0,0x8d
ffffffffc02088e8:	f5c50513          	addi	a0,a0,-164 # ffffffffc0295840 <disk0_sem>
ffffffffc02088ec:	c75fb0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc02088f0:	4501                	li	a0,0
ffffffffc02088f2:	b729                	j	ffffffffc02087fc <disk0_io+0x54>
ffffffffc02088f4:	5575                	li	a0,-3
ffffffffc02088f6:	b719                	j	ffffffffc02087fc <disk0_io+0x54>
ffffffffc02088f8:	00006697          	auipc	a3,0x6
ffffffffc02088fc:	1b868693          	addi	a3,a3,440 # ffffffffc020eab0 <dev_node_ops+0x178>
ffffffffc0208900:	00003617          	auipc	a2,0x3
ffffffffc0208904:	08860613          	addi	a2,a2,136 # ffffffffc020b988 <commands+0x210>
ffffffffc0208908:	06200593          	li	a1,98
ffffffffc020890c:	00006517          	auipc	a0,0x6
ffffffffc0208910:	0ec50513          	addi	a0,a0,236 # ffffffffc020e9f8 <dev_node_ops+0xc0>
ffffffffc0208914:	b8bf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208918:	00006697          	auipc	a3,0x6
ffffffffc020891c:	0a068693          	addi	a3,a3,160 # ffffffffc020e9b8 <dev_node_ops+0x80>
ffffffffc0208920:	00003617          	auipc	a2,0x3
ffffffffc0208924:	06860613          	addi	a2,a2,104 # ffffffffc020b988 <commands+0x210>
ffffffffc0208928:	05700593          	li	a1,87
ffffffffc020892c:	00006517          	auipc	a0,0x6
ffffffffc0208930:	0cc50513          	addi	a0,a0,204 # ffffffffc020e9f8 <dev_node_ops+0xc0>
ffffffffc0208934:	b6bf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208938:	88aa                	mv	a7,a0
ffffffffc020893a:	886a                	mv	a6,s10
ffffffffc020893c:	87a2                	mv	a5,s0
ffffffffc020893e:	8752                	mv	a4,s4
ffffffffc0208940:	86ce                	mv	a3,s3
ffffffffc0208942:	00006617          	auipc	a2,0x6
ffffffffc0208946:	12660613          	addi	a2,a2,294 # ffffffffc020ea68 <dev_node_ops+0x130>
ffffffffc020894a:	02d00593          	li	a1,45
ffffffffc020894e:	00006517          	auipc	a0,0x6
ffffffffc0208952:	0aa50513          	addi	a0,a0,170 # ffffffffc020e9f8 <dev_node_ops+0xc0>
ffffffffc0208956:	b49f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020895a:	88aa                	mv	a7,a0
ffffffffc020895c:	8852                	mv	a6,s4
ffffffffc020895e:	87a2                	mv	a5,s0
ffffffffc0208960:	874a                	mv	a4,s2
ffffffffc0208962:	86ce                	mv	a3,s3
ffffffffc0208964:	00006617          	auipc	a2,0x6
ffffffffc0208968:	0b460613          	addi	a2,a2,180 # ffffffffc020ea18 <dev_node_ops+0xe0>
ffffffffc020896c:	03700593          	li	a1,55
ffffffffc0208970:	00006517          	auipc	a0,0x6
ffffffffc0208974:	08850513          	addi	a0,a0,136 # ffffffffc020e9f8 <dev_node_ops+0xc0>
ffffffffc0208978:	b27f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020897c <dev_init_disk0>:
ffffffffc020897c:	1101                	addi	sp,sp,-32
ffffffffc020897e:	ec06                	sd	ra,24(sp)
ffffffffc0208980:	e822                	sd	s0,16(sp)
ffffffffc0208982:	e426                	sd	s1,8(sp)
ffffffffc0208984:	dedff0ef          	jal	ra,ffffffffc0208770 <dev_create_inode>
ffffffffc0208988:	c541                	beqz	a0,ffffffffc0208a10 <dev_init_disk0+0x94>
ffffffffc020898a:	4d38                	lw	a4,88(a0)
ffffffffc020898c:	6485                	lui	s1,0x1
ffffffffc020898e:	23448793          	addi	a5,s1,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208992:	842a                	mv	s0,a0
ffffffffc0208994:	0cf71f63          	bne	a4,a5,ffffffffc0208a72 <dev_init_disk0+0xf6>
ffffffffc0208998:	4509                	li	a0,2
ffffffffc020899a:	95af80ef          	jal	ra,ffffffffc0200af4 <ide_device_valid>
ffffffffc020899e:	cd55                	beqz	a0,ffffffffc0208a5a <dev_init_disk0+0xde>
ffffffffc02089a0:	4509                	li	a0,2
ffffffffc02089a2:	976f80ef          	jal	ra,ffffffffc0200b18 <ide_device_size>
ffffffffc02089a6:	00355793          	srli	a5,a0,0x3
ffffffffc02089aa:	e01c                	sd	a5,0(s0)
ffffffffc02089ac:	00000797          	auipc	a5,0x0
ffffffffc02089b0:	df078793          	addi	a5,a5,-528 # ffffffffc020879c <disk0_open>
ffffffffc02089b4:	e81c                	sd	a5,16(s0)
ffffffffc02089b6:	00000797          	auipc	a5,0x0
ffffffffc02089ba:	dea78793          	addi	a5,a5,-534 # ffffffffc02087a0 <disk0_close>
ffffffffc02089be:	ec1c                	sd	a5,24(s0)
ffffffffc02089c0:	00000797          	auipc	a5,0x0
ffffffffc02089c4:	de878793          	addi	a5,a5,-536 # ffffffffc02087a8 <disk0_io>
ffffffffc02089c8:	f01c                	sd	a5,32(s0)
ffffffffc02089ca:	00000797          	auipc	a5,0x0
ffffffffc02089ce:	dda78793          	addi	a5,a5,-550 # ffffffffc02087a4 <disk0_ioctl>
ffffffffc02089d2:	f41c                	sd	a5,40(s0)
ffffffffc02089d4:	4585                	li	a1,1
ffffffffc02089d6:	0008d517          	auipc	a0,0x8d
ffffffffc02089da:	e6a50513          	addi	a0,a0,-406 # ffffffffc0295840 <disk0_sem>
ffffffffc02089de:	e404                	sd	s1,8(s0)
ffffffffc02089e0:	b7bfb0ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc02089e4:	6511                	lui	a0,0x4
ffffffffc02089e6:	da8f90ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc02089ea:	0008e797          	auipc	a5,0x8e
ffffffffc02089ee:	f0a7b723          	sd	a0,-242(a5) # ffffffffc02968f8 <disk0_buffer>
ffffffffc02089f2:	c921                	beqz	a0,ffffffffc0208a42 <dev_init_disk0+0xc6>
ffffffffc02089f4:	4605                	li	a2,1
ffffffffc02089f6:	85a2                	mv	a1,s0
ffffffffc02089f8:	00006517          	auipc	a0,0x6
ffffffffc02089fc:	14850513          	addi	a0,a0,328 # ffffffffc020eb40 <dev_node_ops+0x208>
ffffffffc0208a00:	c2cff0ef          	jal	ra,ffffffffc0207e2c <vfs_add_dev>
ffffffffc0208a04:	e115                	bnez	a0,ffffffffc0208a28 <dev_init_disk0+0xac>
ffffffffc0208a06:	60e2                	ld	ra,24(sp)
ffffffffc0208a08:	6442                	ld	s0,16(sp)
ffffffffc0208a0a:	64a2                	ld	s1,8(sp)
ffffffffc0208a0c:	6105                	addi	sp,sp,32
ffffffffc0208a0e:	8082                	ret
ffffffffc0208a10:	00006617          	auipc	a2,0x6
ffffffffc0208a14:	0d060613          	addi	a2,a2,208 # ffffffffc020eae0 <dev_node_ops+0x1a8>
ffffffffc0208a18:	08700593          	li	a1,135
ffffffffc0208a1c:	00006517          	auipc	a0,0x6
ffffffffc0208a20:	fdc50513          	addi	a0,a0,-36 # ffffffffc020e9f8 <dev_node_ops+0xc0>
ffffffffc0208a24:	a7bf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208a28:	86aa                	mv	a3,a0
ffffffffc0208a2a:	00006617          	auipc	a2,0x6
ffffffffc0208a2e:	11e60613          	addi	a2,a2,286 # ffffffffc020eb48 <dev_node_ops+0x210>
ffffffffc0208a32:	08d00593          	li	a1,141
ffffffffc0208a36:	00006517          	auipc	a0,0x6
ffffffffc0208a3a:	fc250513          	addi	a0,a0,-62 # ffffffffc020e9f8 <dev_node_ops+0xc0>
ffffffffc0208a3e:	a61f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208a42:	00006617          	auipc	a2,0x6
ffffffffc0208a46:	0de60613          	addi	a2,a2,222 # ffffffffc020eb20 <dev_node_ops+0x1e8>
ffffffffc0208a4a:	07f00593          	li	a1,127
ffffffffc0208a4e:	00006517          	auipc	a0,0x6
ffffffffc0208a52:	faa50513          	addi	a0,a0,-86 # ffffffffc020e9f8 <dev_node_ops+0xc0>
ffffffffc0208a56:	a49f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208a5a:	00006617          	auipc	a2,0x6
ffffffffc0208a5e:	0a660613          	addi	a2,a2,166 # ffffffffc020eb00 <dev_node_ops+0x1c8>
ffffffffc0208a62:	07300593          	li	a1,115
ffffffffc0208a66:	00006517          	auipc	a0,0x6
ffffffffc0208a6a:	f9250513          	addi	a0,a0,-110 # ffffffffc020e9f8 <dev_node_ops+0xc0>
ffffffffc0208a6e:	a31f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208a72:	00006697          	auipc	a3,0x6
ffffffffc0208a76:	b9e68693          	addi	a3,a3,-1122 # ffffffffc020e610 <syscalls+0xb10>
ffffffffc0208a7a:	00003617          	auipc	a2,0x3
ffffffffc0208a7e:	f0e60613          	addi	a2,a2,-242 # ffffffffc020b988 <commands+0x210>
ffffffffc0208a82:	08900593          	li	a1,137
ffffffffc0208a86:	00006517          	auipc	a0,0x6
ffffffffc0208a8a:	f7250513          	addi	a0,a0,-142 # ffffffffc020e9f8 <dev_node_ops+0xc0>
ffffffffc0208a8e:	a11f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208a92 <stdin_open>:
ffffffffc0208a92:	4501                	li	a0,0
ffffffffc0208a94:	e191                	bnez	a1,ffffffffc0208a98 <stdin_open+0x6>
ffffffffc0208a96:	8082                	ret
ffffffffc0208a98:	5575                	li	a0,-3
ffffffffc0208a9a:	8082                	ret

ffffffffc0208a9c <stdin_close>:
ffffffffc0208a9c:	4501                	li	a0,0
ffffffffc0208a9e:	8082                	ret

ffffffffc0208aa0 <stdin_ioctl>:
ffffffffc0208aa0:	5575                	li	a0,-3
ffffffffc0208aa2:	8082                	ret

ffffffffc0208aa4 <stdin_io>:
ffffffffc0208aa4:	7135                	addi	sp,sp,-160
ffffffffc0208aa6:	ed06                	sd	ra,152(sp)
ffffffffc0208aa8:	e922                	sd	s0,144(sp)
ffffffffc0208aaa:	e526                	sd	s1,136(sp)
ffffffffc0208aac:	e14a                	sd	s2,128(sp)
ffffffffc0208aae:	fcce                	sd	s3,120(sp)
ffffffffc0208ab0:	f8d2                	sd	s4,112(sp)
ffffffffc0208ab2:	f4d6                	sd	s5,104(sp)
ffffffffc0208ab4:	f0da                	sd	s6,96(sp)
ffffffffc0208ab6:	ecde                	sd	s7,88(sp)
ffffffffc0208ab8:	e8e2                	sd	s8,80(sp)
ffffffffc0208aba:	e4e6                	sd	s9,72(sp)
ffffffffc0208abc:	e0ea                	sd	s10,64(sp)
ffffffffc0208abe:	fc6e                	sd	s11,56(sp)
ffffffffc0208ac0:	14061163          	bnez	a2,ffffffffc0208c02 <stdin_io+0x15e>
ffffffffc0208ac4:	0005bd83          	ld	s11,0(a1)
ffffffffc0208ac8:	0185bd03          	ld	s10,24(a1)
ffffffffc0208acc:	8b2e                	mv	s6,a1
ffffffffc0208ace:	100027f3          	csrr	a5,sstatus
ffffffffc0208ad2:	8b89                	andi	a5,a5,2
ffffffffc0208ad4:	10079e63          	bnez	a5,ffffffffc0208bf0 <stdin_io+0x14c>
ffffffffc0208ad8:	4401                	li	s0,0
ffffffffc0208ada:	100d0963          	beqz	s10,ffffffffc0208bec <stdin_io+0x148>
ffffffffc0208ade:	0008e997          	auipc	s3,0x8e
ffffffffc0208ae2:	e2298993          	addi	s3,s3,-478 # ffffffffc0296900 <p_rpos>
ffffffffc0208ae6:	0009b783          	ld	a5,0(s3)
ffffffffc0208aea:	800004b7          	lui	s1,0x80000
ffffffffc0208aee:	6c85                	lui	s9,0x1
ffffffffc0208af0:	4a81                	li	s5,0
ffffffffc0208af2:	0008ea17          	auipc	s4,0x8e
ffffffffc0208af6:	e16a0a13          	addi	s4,s4,-490 # ffffffffc0296908 <p_wpos>
ffffffffc0208afa:	0491                	addi	s1,s1,4
ffffffffc0208afc:	0008d917          	auipc	s2,0x8d
ffffffffc0208b00:	d5c90913          	addi	s2,s2,-676 # ffffffffc0295858 <__wait_queue>
ffffffffc0208b04:	1cfd                	addi	s9,s9,-1
ffffffffc0208b06:	000a3703          	ld	a4,0(s4)
ffffffffc0208b0a:	000a8c1b          	sext.w	s8,s5
ffffffffc0208b0e:	8be2                	mv	s7,s8
ffffffffc0208b10:	02e7d763          	bge	a5,a4,ffffffffc0208b3e <stdin_io+0x9a>
ffffffffc0208b14:	a859                	j	ffffffffc0208baa <stdin_io+0x106>
ffffffffc0208b16:	815fe0ef          	jal	ra,ffffffffc020732a <schedule>
ffffffffc0208b1a:	100027f3          	csrr	a5,sstatus
ffffffffc0208b1e:	8b89                	andi	a5,a5,2
ffffffffc0208b20:	4401                	li	s0,0
ffffffffc0208b22:	ef8d                	bnez	a5,ffffffffc0208b5c <stdin_io+0xb8>
ffffffffc0208b24:	0028                	addi	a0,sp,8
ffffffffc0208b26:	ad1fb0ef          	jal	ra,ffffffffc02045f6 <wait_in_queue>
ffffffffc0208b2a:	e121                	bnez	a0,ffffffffc0208b6a <stdin_io+0xc6>
ffffffffc0208b2c:	47c2                	lw	a5,16(sp)
ffffffffc0208b2e:	04979563          	bne	a5,s1,ffffffffc0208b78 <stdin_io+0xd4>
ffffffffc0208b32:	0009b783          	ld	a5,0(s3)
ffffffffc0208b36:	000a3703          	ld	a4,0(s4)
ffffffffc0208b3a:	06e7c863          	blt	a5,a4,ffffffffc0208baa <stdin_io+0x106>
ffffffffc0208b3e:	8626                	mv	a2,s1
ffffffffc0208b40:	002c                	addi	a1,sp,8
ffffffffc0208b42:	854a                	mv	a0,s2
ffffffffc0208b44:	bddfb0ef          	jal	ra,ffffffffc0204720 <wait_current_set>
ffffffffc0208b48:	d479                	beqz	s0,ffffffffc0208b16 <stdin_io+0x72>
ffffffffc0208b4a:	922f80ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208b4e:	fdcfe0ef          	jal	ra,ffffffffc020732a <schedule>
ffffffffc0208b52:	100027f3          	csrr	a5,sstatus
ffffffffc0208b56:	8b89                	andi	a5,a5,2
ffffffffc0208b58:	4401                	li	s0,0
ffffffffc0208b5a:	d7e9                	beqz	a5,ffffffffc0208b24 <stdin_io+0x80>
ffffffffc0208b5c:	916f80ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208b60:	0028                	addi	a0,sp,8
ffffffffc0208b62:	4405                	li	s0,1
ffffffffc0208b64:	a93fb0ef          	jal	ra,ffffffffc02045f6 <wait_in_queue>
ffffffffc0208b68:	d171                	beqz	a0,ffffffffc0208b2c <stdin_io+0x88>
ffffffffc0208b6a:	002c                	addi	a1,sp,8
ffffffffc0208b6c:	854a                	mv	a0,s2
ffffffffc0208b6e:	a2ffb0ef          	jal	ra,ffffffffc020459c <wait_queue_del>
ffffffffc0208b72:	47c2                	lw	a5,16(sp)
ffffffffc0208b74:	fa978fe3          	beq	a5,s1,ffffffffc0208b32 <stdin_io+0x8e>
ffffffffc0208b78:	e435                	bnez	s0,ffffffffc0208be4 <stdin_io+0x140>
ffffffffc0208b7a:	060b8963          	beqz	s7,ffffffffc0208bec <stdin_io+0x148>
ffffffffc0208b7e:	018b3783          	ld	a5,24(s6)
ffffffffc0208b82:	41578ab3          	sub	s5,a5,s5
ffffffffc0208b86:	015b3c23          	sd	s5,24(s6)
ffffffffc0208b8a:	60ea                	ld	ra,152(sp)
ffffffffc0208b8c:	644a                	ld	s0,144(sp)
ffffffffc0208b8e:	64aa                	ld	s1,136(sp)
ffffffffc0208b90:	690a                	ld	s2,128(sp)
ffffffffc0208b92:	79e6                	ld	s3,120(sp)
ffffffffc0208b94:	7a46                	ld	s4,112(sp)
ffffffffc0208b96:	7aa6                	ld	s5,104(sp)
ffffffffc0208b98:	7b06                	ld	s6,96(sp)
ffffffffc0208b9a:	6c46                	ld	s8,80(sp)
ffffffffc0208b9c:	6ca6                	ld	s9,72(sp)
ffffffffc0208b9e:	6d06                	ld	s10,64(sp)
ffffffffc0208ba0:	7de2                	ld	s11,56(sp)
ffffffffc0208ba2:	855e                	mv	a0,s7
ffffffffc0208ba4:	6be6                	ld	s7,88(sp)
ffffffffc0208ba6:	610d                	addi	sp,sp,160
ffffffffc0208ba8:	8082                	ret
ffffffffc0208baa:	43f7d713          	srai	a4,a5,0x3f
ffffffffc0208bae:	03475693          	srli	a3,a4,0x34
ffffffffc0208bb2:	00d78733          	add	a4,a5,a3
ffffffffc0208bb6:	01977733          	and	a4,a4,s9
ffffffffc0208bba:	8f15                	sub	a4,a4,a3
ffffffffc0208bbc:	0008d697          	auipc	a3,0x8d
ffffffffc0208bc0:	cac68693          	addi	a3,a3,-852 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208bc4:	9736                	add	a4,a4,a3
ffffffffc0208bc6:	00074683          	lbu	a3,0(a4)
ffffffffc0208bca:	0785                	addi	a5,a5,1
ffffffffc0208bcc:	015d8733          	add	a4,s11,s5
ffffffffc0208bd0:	00d70023          	sb	a3,0(a4)
ffffffffc0208bd4:	00f9b023          	sd	a5,0(s3)
ffffffffc0208bd8:	0a85                	addi	s5,s5,1
ffffffffc0208bda:	001c0b9b          	addiw	s7,s8,1
ffffffffc0208bde:	f3aae4e3          	bltu	s5,s10,ffffffffc0208b06 <stdin_io+0x62>
ffffffffc0208be2:	dc51                	beqz	s0,ffffffffc0208b7e <stdin_io+0xda>
ffffffffc0208be4:	888f80ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208be8:	f80b9be3          	bnez	s7,ffffffffc0208b7e <stdin_io+0xda>
ffffffffc0208bec:	4b81                	li	s7,0
ffffffffc0208bee:	bf71                	j	ffffffffc0208b8a <stdin_io+0xe6>
ffffffffc0208bf0:	882f80ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208bf4:	4405                	li	s0,1
ffffffffc0208bf6:	ee0d14e3          	bnez	s10,ffffffffc0208ade <stdin_io+0x3a>
ffffffffc0208bfa:	872f80ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208bfe:	4b81                	li	s7,0
ffffffffc0208c00:	b769                	j	ffffffffc0208b8a <stdin_io+0xe6>
ffffffffc0208c02:	5bf5                	li	s7,-3
ffffffffc0208c04:	b759                	j	ffffffffc0208b8a <stdin_io+0xe6>

ffffffffc0208c06 <dev_stdin_write>:
ffffffffc0208c06:	e111                	bnez	a0,ffffffffc0208c0a <dev_stdin_write+0x4>
ffffffffc0208c08:	8082                	ret
ffffffffc0208c0a:	1101                	addi	sp,sp,-32
ffffffffc0208c0c:	e822                	sd	s0,16(sp)
ffffffffc0208c0e:	ec06                	sd	ra,24(sp)
ffffffffc0208c10:	e426                	sd	s1,8(sp)
ffffffffc0208c12:	842a                	mv	s0,a0
ffffffffc0208c14:	100027f3          	csrr	a5,sstatus
ffffffffc0208c18:	8b89                	andi	a5,a5,2
ffffffffc0208c1a:	4481                	li	s1,0
ffffffffc0208c1c:	e3c1                	bnez	a5,ffffffffc0208c9c <dev_stdin_write+0x96>
ffffffffc0208c1e:	0008e597          	auipc	a1,0x8e
ffffffffc0208c22:	cea58593          	addi	a1,a1,-790 # ffffffffc0296908 <p_wpos>
ffffffffc0208c26:	6198                	ld	a4,0(a1)
ffffffffc0208c28:	6605                	lui	a2,0x1
ffffffffc0208c2a:	fff60513          	addi	a0,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0208c2e:	43f75693          	srai	a3,a4,0x3f
ffffffffc0208c32:	92d1                	srli	a3,a3,0x34
ffffffffc0208c34:	00d707b3          	add	a5,a4,a3
ffffffffc0208c38:	8fe9                	and	a5,a5,a0
ffffffffc0208c3a:	8f95                	sub	a5,a5,a3
ffffffffc0208c3c:	0008d697          	auipc	a3,0x8d
ffffffffc0208c40:	c2c68693          	addi	a3,a3,-980 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208c44:	97b6                	add	a5,a5,a3
ffffffffc0208c46:	00878023          	sb	s0,0(a5)
ffffffffc0208c4a:	0008e797          	auipc	a5,0x8e
ffffffffc0208c4e:	cb67b783          	ld	a5,-842(a5) # ffffffffc0296900 <p_rpos>
ffffffffc0208c52:	40f707b3          	sub	a5,a4,a5
ffffffffc0208c56:	00c7d463          	bge	a5,a2,ffffffffc0208c5e <dev_stdin_write+0x58>
ffffffffc0208c5a:	0705                	addi	a4,a4,1
ffffffffc0208c5c:	e198                	sd	a4,0(a1)
ffffffffc0208c5e:	0008d517          	auipc	a0,0x8d
ffffffffc0208c62:	bfa50513          	addi	a0,a0,-1030 # ffffffffc0295858 <__wait_queue>
ffffffffc0208c66:	985fb0ef          	jal	ra,ffffffffc02045ea <wait_queue_empty>
ffffffffc0208c6a:	cd09                	beqz	a0,ffffffffc0208c84 <dev_stdin_write+0x7e>
ffffffffc0208c6c:	e491                	bnez	s1,ffffffffc0208c78 <dev_stdin_write+0x72>
ffffffffc0208c6e:	60e2                	ld	ra,24(sp)
ffffffffc0208c70:	6442                	ld	s0,16(sp)
ffffffffc0208c72:	64a2                	ld	s1,8(sp)
ffffffffc0208c74:	6105                	addi	sp,sp,32
ffffffffc0208c76:	8082                	ret
ffffffffc0208c78:	6442                	ld	s0,16(sp)
ffffffffc0208c7a:	60e2                	ld	ra,24(sp)
ffffffffc0208c7c:	64a2                	ld	s1,8(sp)
ffffffffc0208c7e:	6105                	addi	sp,sp,32
ffffffffc0208c80:	fedf706f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0208c84:	800005b7          	lui	a1,0x80000
ffffffffc0208c88:	4605                	li	a2,1
ffffffffc0208c8a:	0591                	addi	a1,a1,4
ffffffffc0208c8c:	0008d517          	auipc	a0,0x8d
ffffffffc0208c90:	bcc50513          	addi	a0,a0,-1076 # ffffffffc0295858 <__wait_queue>
ffffffffc0208c94:	9bffb0ef          	jal	ra,ffffffffc0204652 <wakeup_queue>
ffffffffc0208c98:	d8f9                	beqz	s1,ffffffffc0208c6e <dev_stdin_write+0x68>
ffffffffc0208c9a:	bff9                	j	ffffffffc0208c78 <dev_stdin_write+0x72>
ffffffffc0208c9c:	fd7f70ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208ca0:	4485                	li	s1,1
ffffffffc0208ca2:	bfb5                	j	ffffffffc0208c1e <dev_stdin_write+0x18>

ffffffffc0208ca4 <dev_init_stdin>:
ffffffffc0208ca4:	1141                	addi	sp,sp,-16
ffffffffc0208ca6:	e406                	sd	ra,8(sp)
ffffffffc0208ca8:	e022                	sd	s0,0(sp)
ffffffffc0208caa:	ac7ff0ef          	jal	ra,ffffffffc0208770 <dev_create_inode>
ffffffffc0208cae:	c93d                	beqz	a0,ffffffffc0208d24 <dev_init_stdin+0x80>
ffffffffc0208cb0:	4d38                	lw	a4,88(a0)
ffffffffc0208cb2:	6785                	lui	a5,0x1
ffffffffc0208cb4:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208cb8:	842a                	mv	s0,a0
ffffffffc0208cba:	08f71e63          	bne	a4,a5,ffffffffc0208d56 <dev_init_stdin+0xb2>
ffffffffc0208cbe:	4785                	li	a5,1
ffffffffc0208cc0:	e41c                	sd	a5,8(s0)
ffffffffc0208cc2:	00000797          	auipc	a5,0x0
ffffffffc0208cc6:	dd078793          	addi	a5,a5,-560 # ffffffffc0208a92 <stdin_open>
ffffffffc0208cca:	e81c                	sd	a5,16(s0)
ffffffffc0208ccc:	00000797          	auipc	a5,0x0
ffffffffc0208cd0:	dd078793          	addi	a5,a5,-560 # ffffffffc0208a9c <stdin_close>
ffffffffc0208cd4:	ec1c                	sd	a5,24(s0)
ffffffffc0208cd6:	00000797          	auipc	a5,0x0
ffffffffc0208cda:	dce78793          	addi	a5,a5,-562 # ffffffffc0208aa4 <stdin_io>
ffffffffc0208cde:	f01c                	sd	a5,32(s0)
ffffffffc0208ce0:	00000797          	auipc	a5,0x0
ffffffffc0208ce4:	dc078793          	addi	a5,a5,-576 # ffffffffc0208aa0 <stdin_ioctl>
ffffffffc0208ce8:	f41c                	sd	a5,40(s0)
ffffffffc0208cea:	0008d517          	auipc	a0,0x8d
ffffffffc0208cee:	b6e50513          	addi	a0,a0,-1170 # ffffffffc0295858 <__wait_queue>
ffffffffc0208cf2:	00043023          	sd	zero,0(s0)
ffffffffc0208cf6:	0008e797          	auipc	a5,0x8e
ffffffffc0208cfa:	c007b923          	sd	zero,-1006(a5) # ffffffffc0296908 <p_wpos>
ffffffffc0208cfe:	0008e797          	auipc	a5,0x8e
ffffffffc0208d02:	c007b123          	sd	zero,-1022(a5) # ffffffffc0296900 <p_rpos>
ffffffffc0208d06:	891fb0ef          	jal	ra,ffffffffc0204596 <wait_queue_init>
ffffffffc0208d0a:	4601                	li	a2,0
ffffffffc0208d0c:	85a2                	mv	a1,s0
ffffffffc0208d0e:	00006517          	auipc	a0,0x6
ffffffffc0208d12:	e9a50513          	addi	a0,a0,-358 # ffffffffc020eba8 <dev_node_ops+0x270>
ffffffffc0208d16:	916ff0ef          	jal	ra,ffffffffc0207e2c <vfs_add_dev>
ffffffffc0208d1a:	e10d                	bnez	a0,ffffffffc0208d3c <dev_init_stdin+0x98>
ffffffffc0208d1c:	60a2                	ld	ra,8(sp)
ffffffffc0208d1e:	6402                	ld	s0,0(sp)
ffffffffc0208d20:	0141                	addi	sp,sp,16
ffffffffc0208d22:	8082                	ret
ffffffffc0208d24:	00006617          	auipc	a2,0x6
ffffffffc0208d28:	e4460613          	addi	a2,a2,-444 # ffffffffc020eb68 <dev_node_ops+0x230>
ffffffffc0208d2c:	07500593          	li	a1,117
ffffffffc0208d30:	00006517          	auipc	a0,0x6
ffffffffc0208d34:	e5850513          	addi	a0,a0,-424 # ffffffffc020eb88 <dev_node_ops+0x250>
ffffffffc0208d38:	f66f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208d3c:	86aa                	mv	a3,a0
ffffffffc0208d3e:	00006617          	auipc	a2,0x6
ffffffffc0208d42:	e7260613          	addi	a2,a2,-398 # ffffffffc020ebb0 <dev_node_ops+0x278>
ffffffffc0208d46:	07b00593          	li	a1,123
ffffffffc0208d4a:	00006517          	auipc	a0,0x6
ffffffffc0208d4e:	e3e50513          	addi	a0,a0,-450 # ffffffffc020eb88 <dev_node_ops+0x250>
ffffffffc0208d52:	f4cf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208d56:	00006697          	auipc	a3,0x6
ffffffffc0208d5a:	8ba68693          	addi	a3,a3,-1862 # ffffffffc020e610 <syscalls+0xb10>
ffffffffc0208d5e:	00003617          	auipc	a2,0x3
ffffffffc0208d62:	c2a60613          	addi	a2,a2,-982 # ffffffffc020b988 <commands+0x210>
ffffffffc0208d66:	07700593          	li	a1,119
ffffffffc0208d6a:	00006517          	auipc	a0,0x6
ffffffffc0208d6e:	e1e50513          	addi	a0,a0,-482 # ffffffffc020eb88 <dev_node_ops+0x250>
ffffffffc0208d72:	f2cf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208d76 <stdout_open>:
ffffffffc0208d76:	4785                	li	a5,1
ffffffffc0208d78:	4501                	li	a0,0
ffffffffc0208d7a:	00f59363          	bne	a1,a5,ffffffffc0208d80 <stdout_open+0xa>
ffffffffc0208d7e:	8082                	ret
ffffffffc0208d80:	5575                	li	a0,-3
ffffffffc0208d82:	8082                	ret

ffffffffc0208d84 <stdout_close>:
ffffffffc0208d84:	4501                	li	a0,0
ffffffffc0208d86:	8082                	ret

ffffffffc0208d88 <stdout_ioctl>:
ffffffffc0208d88:	5575                	li	a0,-3
ffffffffc0208d8a:	8082                	ret

ffffffffc0208d8c <stdout_io>:
ffffffffc0208d8c:	ca05                	beqz	a2,ffffffffc0208dbc <stdout_io+0x30>
ffffffffc0208d8e:	6d9c                	ld	a5,24(a1)
ffffffffc0208d90:	1101                	addi	sp,sp,-32
ffffffffc0208d92:	e822                	sd	s0,16(sp)
ffffffffc0208d94:	e426                	sd	s1,8(sp)
ffffffffc0208d96:	ec06                	sd	ra,24(sp)
ffffffffc0208d98:	6180                	ld	s0,0(a1)
ffffffffc0208d9a:	84ae                	mv	s1,a1
ffffffffc0208d9c:	cb91                	beqz	a5,ffffffffc0208db0 <stdout_io+0x24>
ffffffffc0208d9e:	00044503          	lbu	a0,0(s0)
ffffffffc0208da2:	0405                	addi	s0,s0,1
ffffffffc0208da4:	c3ef70ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0208da8:	6c9c                	ld	a5,24(s1)
ffffffffc0208daa:	17fd                	addi	a5,a5,-1
ffffffffc0208dac:	ec9c                	sd	a5,24(s1)
ffffffffc0208dae:	fbe5                	bnez	a5,ffffffffc0208d9e <stdout_io+0x12>
ffffffffc0208db0:	60e2                	ld	ra,24(sp)
ffffffffc0208db2:	6442                	ld	s0,16(sp)
ffffffffc0208db4:	64a2                	ld	s1,8(sp)
ffffffffc0208db6:	4501                	li	a0,0
ffffffffc0208db8:	6105                	addi	sp,sp,32
ffffffffc0208dba:	8082                	ret
ffffffffc0208dbc:	5575                	li	a0,-3
ffffffffc0208dbe:	8082                	ret

ffffffffc0208dc0 <dev_init_stdout>:
ffffffffc0208dc0:	1141                	addi	sp,sp,-16
ffffffffc0208dc2:	e406                	sd	ra,8(sp)
ffffffffc0208dc4:	9adff0ef          	jal	ra,ffffffffc0208770 <dev_create_inode>
ffffffffc0208dc8:	c939                	beqz	a0,ffffffffc0208e1e <dev_init_stdout+0x5e>
ffffffffc0208dca:	4d38                	lw	a4,88(a0)
ffffffffc0208dcc:	6785                	lui	a5,0x1
ffffffffc0208dce:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208dd2:	85aa                	mv	a1,a0
ffffffffc0208dd4:	06f71e63          	bne	a4,a5,ffffffffc0208e50 <dev_init_stdout+0x90>
ffffffffc0208dd8:	4785                	li	a5,1
ffffffffc0208dda:	e51c                	sd	a5,8(a0)
ffffffffc0208ddc:	00000797          	auipc	a5,0x0
ffffffffc0208de0:	f9a78793          	addi	a5,a5,-102 # ffffffffc0208d76 <stdout_open>
ffffffffc0208de4:	e91c                	sd	a5,16(a0)
ffffffffc0208de6:	00000797          	auipc	a5,0x0
ffffffffc0208dea:	f9e78793          	addi	a5,a5,-98 # ffffffffc0208d84 <stdout_close>
ffffffffc0208dee:	ed1c                	sd	a5,24(a0)
ffffffffc0208df0:	00000797          	auipc	a5,0x0
ffffffffc0208df4:	f9c78793          	addi	a5,a5,-100 # ffffffffc0208d8c <stdout_io>
ffffffffc0208df8:	f11c                	sd	a5,32(a0)
ffffffffc0208dfa:	00000797          	auipc	a5,0x0
ffffffffc0208dfe:	f8e78793          	addi	a5,a5,-114 # ffffffffc0208d88 <stdout_ioctl>
ffffffffc0208e02:	00053023          	sd	zero,0(a0)
ffffffffc0208e06:	f51c                	sd	a5,40(a0)
ffffffffc0208e08:	4601                	li	a2,0
ffffffffc0208e0a:	00006517          	auipc	a0,0x6
ffffffffc0208e0e:	e0650513          	addi	a0,a0,-506 # ffffffffc020ec10 <dev_node_ops+0x2d8>
ffffffffc0208e12:	81aff0ef          	jal	ra,ffffffffc0207e2c <vfs_add_dev>
ffffffffc0208e16:	e105                	bnez	a0,ffffffffc0208e36 <dev_init_stdout+0x76>
ffffffffc0208e18:	60a2                	ld	ra,8(sp)
ffffffffc0208e1a:	0141                	addi	sp,sp,16
ffffffffc0208e1c:	8082                	ret
ffffffffc0208e1e:	00006617          	auipc	a2,0x6
ffffffffc0208e22:	db260613          	addi	a2,a2,-590 # ffffffffc020ebd0 <dev_node_ops+0x298>
ffffffffc0208e26:	03700593          	li	a1,55
ffffffffc0208e2a:	00006517          	auipc	a0,0x6
ffffffffc0208e2e:	dc650513          	addi	a0,a0,-570 # ffffffffc020ebf0 <dev_node_ops+0x2b8>
ffffffffc0208e32:	e6cf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208e36:	86aa                	mv	a3,a0
ffffffffc0208e38:	00006617          	auipc	a2,0x6
ffffffffc0208e3c:	de060613          	addi	a2,a2,-544 # ffffffffc020ec18 <dev_node_ops+0x2e0>
ffffffffc0208e40:	03d00593          	li	a1,61
ffffffffc0208e44:	00006517          	auipc	a0,0x6
ffffffffc0208e48:	dac50513          	addi	a0,a0,-596 # ffffffffc020ebf0 <dev_node_ops+0x2b8>
ffffffffc0208e4c:	e52f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208e50:	00005697          	auipc	a3,0x5
ffffffffc0208e54:	7c068693          	addi	a3,a3,1984 # ffffffffc020e610 <syscalls+0xb10>
ffffffffc0208e58:	00003617          	auipc	a2,0x3
ffffffffc0208e5c:	b3060613          	addi	a2,a2,-1232 # ffffffffc020b988 <commands+0x210>
ffffffffc0208e60:	03900593          	li	a1,57
ffffffffc0208e64:	00006517          	auipc	a0,0x6
ffffffffc0208e68:	d8c50513          	addi	a0,a0,-628 # ffffffffc020ebf0 <dev_node_ops+0x2b8>
ffffffffc0208e6c:	e32f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208e70 <bitmap_translate.part.0>:
ffffffffc0208e70:	1141                	addi	sp,sp,-16
ffffffffc0208e72:	00006697          	auipc	a3,0x6
ffffffffc0208e76:	dc668693          	addi	a3,a3,-570 # ffffffffc020ec38 <dev_node_ops+0x300>
ffffffffc0208e7a:	00003617          	auipc	a2,0x3
ffffffffc0208e7e:	b0e60613          	addi	a2,a2,-1266 # ffffffffc020b988 <commands+0x210>
ffffffffc0208e82:	04c00593          	li	a1,76
ffffffffc0208e86:	00006517          	auipc	a0,0x6
ffffffffc0208e8a:	dca50513          	addi	a0,a0,-566 # ffffffffc020ec50 <dev_node_ops+0x318>
ffffffffc0208e8e:	e406                	sd	ra,8(sp)
ffffffffc0208e90:	e0ef70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208e94 <bitmap_create>:
ffffffffc0208e94:	7139                	addi	sp,sp,-64
ffffffffc0208e96:	fc06                	sd	ra,56(sp)
ffffffffc0208e98:	f822                	sd	s0,48(sp)
ffffffffc0208e9a:	f426                	sd	s1,40(sp)
ffffffffc0208e9c:	f04a                	sd	s2,32(sp)
ffffffffc0208e9e:	ec4e                	sd	s3,24(sp)
ffffffffc0208ea0:	e852                	sd	s4,16(sp)
ffffffffc0208ea2:	e456                	sd	s5,8(sp)
ffffffffc0208ea4:	c14d                	beqz	a0,ffffffffc0208f46 <bitmap_create+0xb2>
ffffffffc0208ea6:	842a                	mv	s0,a0
ffffffffc0208ea8:	4541                	li	a0,16
ffffffffc0208eaa:	8e4f90ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0208eae:	84aa                	mv	s1,a0
ffffffffc0208eb0:	cd25                	beqz	a0,ffffffffc0208f28 <bitmap_create+0x94>
ffffffffc0208eb2:	02041a13          	slli	s4,s0,0x20
ffffffffc0208eb6:	020a5a13          	srli	s4,s4,0x20
ffffffffc0208eba:	01fa0793          	addi	a5,s4,31
ffffffffc0208ebe:	0057d993          	srli	s3,a5,0x5
ffffffffc0208ec2:	00299a93          	slli	s5,s3,0x2
ffffffffc0208ec6:	8556                	mv	a0,s5
ffffffffc0208ec8:	894e                	mv	s2,s3
ffffffffc0208eca:	8c4f90ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0208ece:	c53d                	beqz	a0,ffffffffc0208f3c <bitmap_create+0xa8>
ffffffffc0208ed0:	0134a223          	sw	s3,4(s1) # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc0208ed4:	c080                	sw	s0,0(s1)
ffffffffc0208ed6:	8656                	mv	a2,s5
ffffffffc0208ed8:	0ff00593          	li	a1,255
ffffffffc0208edc:	5c4020ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0208ee0:	e488                	sd	a0,8(s1)
ffffffffc0208ee2:	0996                	slli	s3,s3,0x5
ffffffffc0208ee4:	053a0263          	beq	s4,s3,ffffffffc0208f28 <bitmap_create+0x94>
ffffffffc0208ee8:	fff9079b          	addiw	a5,s2,-1
ffffffffc0208eec:	0057969b          	slliw	a3,a5,0x5
ffffffffc0208ef0:	0054561b          	srliw	a2,s0,0x5
ffffffffc0208ef4:	40d4073b          	subw	a4,s0,a3
ffffffffc0208ef8:	0054541b          	srliw	s0,s0,0x5
ffffffffc0208efc:	08f61463          	bne	a2,a5,ffffffffc0208f84 <bitmap_create+0xf0>
ffffffffc0208f00:	fff7069b          	addiw	a3,a4,-1
ffffffffc0208f04:	47f9                	li	a5,30
ffffffffc0208f06:	04d7ef63          	bltu	a5,a3,ffffffffc0208f64 <bitmap_create+0xd0>
ffffffffc0208f0a:	1402                	slli	s0,s0,0x20
ffffffffc0208f0c:	8079                	srli	s0,s0,0x1e
ffffffffc0208f0e:	9522                	add	a0,a0,s0
ffffffffc0208f10:	411c                	lw	a5,0(a0)
ffffffffc0208f12:	4585                	li	a1,1
ffffffffc0208f14:	02000613          	li	a2,32
ffffffffc0208f18:	00e596bb          	sllw	a3,a1,a4
ffffffffc0208f1c:	8fb5                	xor	a5,a5,a3
ffffffffc0208f1e:	2705                	addiw	a4,a4,1
ffffffffc0208f20:	2781                	sext.w	a5,a5
ffffffffc0208f22:	fec71be3          	bne	a4,a2,ffffffffc0208f18 <bitmap_create+0x84>
ffffffffc0208f26:	c11c                	sw	a5,0(a0)
ffffffffc0208f28:	70e2                	ld	ra,56(sp)
ffffffffc0208f2a:	7442                	ld	s0,48(sp)
ffffffffc0208f2c:	7902                	ld	s2,32(sp)
ffffffffc0208f2e:	69e2                	ld	s3,24(sp)
ffffffffc0208f30:	6a42                	ld	s4,16(sp)
ffffffffc0208f32:	6aa2                	ld	s5,8(sp)
ffffffffc0208f34:	8526                	mv	a0,s1
ffffffffc0208f36:	74a2                	ld	s1,40(sp)
ffffffffc0208f38:	6121                	addi	sp,sp,64
ffffffffc0208f3a:	8082                	ret
ffffffffc0208f3c:	8526                	mv	a0,s1
ffffffffc0208f3e:	900f90ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0208f42:	4481                	li	s1,0
ffffffffc0208f44:	b7d5                	j	ffffffffc0208f28 <bitmap_create+0x94>
ffffffffc0208f46:	00006697          	auipc	a3,0x6
ffffffffc0208f4a:	d2268693          	addi	a3,a3,-734 # ffffffffc020ec68 <dev_node_ops+0x330>
ffffffffc0208f4e:	00003617          	auipc	a2,0x3
ffffffffc0208f52:	a3a60613          	addi	a2,a2,-1478 # ffffffffc020b988 <commands+0x210>
ffffffffc0208f56:	45d5                	li	a1,21
ffffffffc0208f58:	00006517          	auipc	a0,0x6
ffffffffc0208f5c:	cf850513          	addi	a0,a0,-776 # ffffffffc020ec50 <dev_node_ops+0x318>
ffffffffc0208f60:	d3ef70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208f64:	00006697          	auipc	a3,0x6
ffffffffc0208f68:	d4468693          	addi	a3,a3,-700 # ffffffffc020eca8 <dev_node_ops+0x370>
ffffffffc0208f6c:	00003617          	auipc	a2,0x3
ffffffffc0208f70:	a1c60613          	addi	a2,a2,-1508 # ffffffffc020b988 <commands+0x210>
ffffffffc0208f74:	02b00593          	li	a1,43
ffffffffc0208f78:	00006517          	auipc	a0,0x6
ffffffffc0208f7c:	cd850513          	addi	a0,a0,-808 # ffffffffc020ec50 <dev_node_ops+0x318>
ffffffffc0208f80:	d1ef70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208f84:	00006697          	auipc	a3,0x6
ffffffffc0208f88:	d0c68693          	addi	a3,a3,-756 # ffffffffc020ec90 <dev_node_ops+0x358>
ffffffffc0208f8c:	00003617          	auipc	a2,0x3
ffffffffc0208f90:	9fc60613          	addi	a2,a2,-1540 # ffffffffc020b988 <commands+0x210>
ffffffffc0208f94:	02a00593          	li	a1,42
ffffffffc0208f98:	00006517          	auipc	a0,0x6
ffffffffc0208f9c:	cb850513          	addi	a0,a0,-840 # ffffffffc020ec50 <dev_node_ops+0x318>
ffffffffc0208fa0:	cfef70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208fa4 <bitmap_alloc>:
ffffffffc0208fa4:	4150                	lw	a2,4(a0)
ffffffffc0208fa6:	651c                	ld	a5,8(a0)
ffffffffc0208fa8:	c231                	beqz	a2,ffffffffc0208fec <bitmap_alloc+0x48>
ffffffffc0208faa:	4701                	li	a4,0
ffffffffc0208fac:	a029                	j	ffffffffc0208fb6 <bitmap_alloc+0x12>
ffffffffc0208fae:	2705                	addiw	a4,a4,1
ffffffffc0208fb0:	0791                	addi	a5,a5,4
ffffffffc0208fb2:	02e60d63          	beq	a2,a4,ffffffffc0208fec <bitmap_alloc+0x48>
ffffffffc0208fb6:	4394                	lw	a3,0(a5)
ffffffffc0208fb8:	dafd                	beqz	a3,ffffffffc0208fae <bitmap_alloc+0xa>
ffffffffc0208fba:	4501                	li	a0,0
ffffffffc0208fbc:	4885                	li	a7,1
ffffffffc0208fbe:	8e36                	mv	t3,a3
ffffffffc0208fc0:	02000313          	li	t1,32
ffffffffc0208fc4:	a021                	j	ffffffffc0208fcc <bitmap_alloc+0x28>
ffffffffc0208fc6:	2505                	addiw	a0,a0,1
ffffffffc0208fc8:	02650463          	beq	a0,t1,ffffffffc0208ff0 <bitmap_alloc+0x4c>
ffffffffc0208fcc:	00a8983b          	sllw	a6,a7,a0
ffffffffc0208fd0:	0106f633          	and	a2,a3,a6
ffffffffc0208fd4:	2601                	sext.w	a2,a2
ffffffffc0208fd6:	da65                	beqz	a2,ffffffffc0208fc6 <bitmap_alloc+0x22>
ffffffffc0208fd8:	010e4833          	xor	a6,t3,a6
ffffffffc0208fdc:	0057171b          	slliw	a4,a4,0x5
ffffffffc0208fe0:	9f29                	addw	a4,a4,a0
ffffffffc0208fe2:	0107a023          	sw	a6,0(a5)
ffffffffc0208fe6:	c198                	sw	a4,0(a1)
ffffffffc0208fe8:	4501                	li	a0,0
ffffffffc0208fea:	8082                	ret
ffffffffc0208fec:	5571                	li	a0,-4
ffffffffc0208fee:	8082                	ret
ffffffffc0208ff0:	1141                	addi	sp,sp,-16
ffffffffc0208ff2:	00004697          	auipc	a3,0x4
ffffffffc0208ff6:	a1668693          	addi	a3,a3,-1514 # ffffffffc020ca08 <default_pmm_manager+0x598>
ffffffffc0208ffa:	00003617          	auipc	a2,0x3
ffffffffc0208ffe:	98e60613          	addi	a2,a2,-1650 # ffffffffc020b988 <commands+0x210>
ffffffffc0209002:	04300593          	li	a1,67
ffffffffc0209006:	00006517          	auipc	a0,0x6
ffffffffc020900a:	c4a50513          	addi	a0,a0,-950 # ffffffffc020ec50 <dev_node_ops+0x318>
ffffffffc020900e:	e406                	sd	ra,8(sp)
ffffffffc0209010:	c8ef70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209014 <bitmap_test>:
ffffffffc0209014:	411c                	lw	a5,0(a0)
ffffffffc0209016:	00f5ff63          	bgeu	a1,a5,ffffffffc0209034 <bitmap_test+0x20>
ffffffffc020901a:	651c                	ld	a5,8(a0)
ffffffffc020901c:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0209020:	070a                	slli	a4,a4,0x2
ffffffffc0209022:	97ba                	add	a5,a5,a4
ffffffffc0209024:	4388                	lw	a0,0(a5)
ffffffffc0209026:	4785                	li	a5,1
ffffffffc0209028:	00b795bb          	sllw	a1,a5,a1
ffffffffc020902c:	8d6d                	and	a0,a0,a1
ffffffffc020902e:	1502                	slli	a0,a0,0x20
ffffffffc0209030:	9101                	srli	a0,a0,0x20
ffffffffc0209032:	8082                	ret
ffffffffc0209034:	1141                	addi	sp,sp,-16
ffffffffc0209036:	e406                	sd	ra,8(sp)
ffffffffc0209038:	e39ff0ef          	jal	ra,ffffffffc0208e70 <bitmap_translate.part.0>

ffffffffc020903c <bitmap_free>:
ffffffffc020903c:	411c                	lw	a5,0(a0)
ffffffffc020903e:	1141                	addi	sp,sp,-16
ffffffffc0209040:	e406                	sd	ra,8(sp)
ffffffffc0209042:	02f5f463          	bgeu	a1,a5,ffffffffc020906a <bitmap_free+0x2e>
ffffffffc0209046:	651c                	ld	a5,8(a0)
ffffffffc0209048:	0055d71b          	srliw	a4,a1,0x5
ffffffffc020904c:	070a                	slli	a4,a4,0x2
ffffffffc020904e:	97ba                	add	a5,a5,a4
ffffffffc0209050:	4398                	lw	a4,0(a5)
ffffffffc0209052:	4685                	li	a3,1
ffffffffc0209054:	00b695bb          	sllw	a1,a3,a1
ffffffffc0209058:	00b776b3          	and	a3,a4,a1
ffffffffc020905c:	2681                	sext.w	a3,a3
ffffffffc020905e:	ea81                	bnez	a3,ffffffffc020906e <bitmap_free+0x32>
ffffffffc0209060:	60a2                	ld	ra,8(sp)
ffffffffc0209062:	8f4d                	or	a4,a4,a1
ffffffffc0209064:	c398                	sw	a4,0(a5)
ffffffffc0209066:	0141                	addi	sp,sp,16
ffffffffc0209068:	8082                	ret
ffffffffc020906a:	e07ff0ef          	jal	ra,ffffffffc0208e70 <bitmap_translate.part.0>
ffffffffc020906e:	00006697          	auipc	a3,0x6
ffffffffc0209072:	c6268693          	addi	a3,a3,-926 # ffffffffc020ecd0 <dev_node_ops+0x398>
ffffffffc0209076:	00003617          	auipc	a2,0x3
ffffffffc020907a:	91260613          	addi	a2,a2,-1774 # ffffffffc020b988 <commands+0x210>
ffffffffc020907e:	05f00593          	li	a1,95
ffffffffc0209082:	00006517          	auipc	a0,0x6
ffffffffc0209086:	bce50513          	addi	a0,a0,-1074 # ffffffffc020ec50 <dev_node_ops+0x318>
ffffffffc020908a:	c14f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020908e <bitmap_destroy>:
ffffffffc020908e:	1141                	addi	sp,sp,-16
ffffffffc0209090:	e022                	sd	s0,0(sp)
ffffffffc0209092:	842a                	mv	s0,a0
ffffffffc0209094:	6508                	ld	a0,8(a0)
ffffffffc0209096:	e406                	sd	ra,8(sp)
ffffffffc0209098:	fa7f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020909c:	8522                	mv	a0,s0
ffffffffc020909e:	6402                	ld	s0,0(sp)
ffffffffc02090a0:	60a2                	ld	ra,8(sp)
ffffffffc02090a2:	0141                	addi	sp,sp,16
ffffffffc02090a4:	f9bf806f          	j	ffffffffc020203e <kfree>

ffffffffc02090a8 <bitmap_getdata>:
ffffffffc02090a8:	c589                	beqz	a1,ffffffffc02090b2 <bitmap_getdata+0xa>
ffffffffc02090aa:	00456783          	lwu	a5,4(a0)
ffffffffc02090ae:	078a                	slli	a5,a5,0x2
ffffffffc02090b0:	e19c                	sd	a5,0(a1)
ffffffffc02090b2:	6508                	ld	a0,8(a0)
ffffffffc02090b4:	8082                	ret

ffffffffc02090b6 <sfs_init>:
ffffffffc02090b6:	1141                	addi	sp,sp,-16
ffffffffc02090b8:	00006517          	auipc	a0,0x6
ffffffffc02090bc:	a8850513          	addi	a0,a0,-1400 # ffffffffc020eb40 <dev_node_ops+0x208>
ffffffffc02090c0:	e406                	sd	ra,8(sp)
ffffffffc02090c2:	554000ef          	jal	ra,ffffffffc0209616 <sfs_mount>
ffffffffc02090c6:	e501                	bnez	a0,ffffffffc02090ce <sfs_init+0x18>
ffffffffc02090c8:	60a2                	ld	ra,8(sp)
ffffffffc02090ca:	0141                	addi	sp,sp,16
ffffffffc02090cc:	8082                	ret
ffffffffc02090ce:	86aa                	mv	a3,a0
ffffffffc02090d0:	00006617          	auipc	a2,0x6
ffffffffc02090d4:	c1060613          	addi	a2,a2,-1008 # ffffffffc020ece0 <dev_node_ops+0x3a8>
ffffffffc02090d8:	45c1                	li	a1,16
ffffffffc02090da:	00006517          	auipc	a0,0x6
ffffffffc02090de:	c2650513          	addi	a0,a0,-986 # ffffffffc020ed00 <dev_node_ops+0x3c8>
ffffffffc02090e2:	bbcf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02090e6 <sfs_unmount>:
ffffffffc02090e6:	1141                	addi	sp,sp,-16
ffffffffc02090e8:	e406                	sd	ra,8(sp)
ffffffffc02090ea:	e022                	sd	s0,0(sp)
ffffffffc02090ec:	cd1d                	beqz	a0,ffffffffc020912a <sfs_unmount+0x44>
ffffffffc02090ee:	0b052783          	lw	a5,176(a0)
ffffffffc02090f2:	842a                	mv	s0,a0
ffffffffc02090f4:	eb9d                	bnez	a5,ffffffffc020912a <sfs_unmount+0x44>
ffffffffc02090f6:	7158                	ld	a4,160(a0)
ffffffffc02090f8:	09850793          	addi	a5,a0,152
ffffffffc02090fc:	02f71563          	bne	a4,a5,ffffffffc0209126 <sfs_unmount+0x40>
ffffffffc0209100:	613c                	ld	a5,64(a0)
ffffffffc0209102:	e7a1                	bnez	a5,ffffffffc020914a <sfs_unmount+0x64>
ffffffffc0209104:	7d08                	ld	a0,56(a0)
ffffffffc0209106:	f89ff0ef          	jal	ra,ffffffffc020908e <bitmap_destroy>
ffffffffc020910a:	6428                	ld	a0,72(s0)
ffffffffc020910c:	f33f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0209110:	7448                	ld	a0,168(s0)
ffffffffc0209112:	f2df80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0209116:	8522                	mv	a0,s0
ffffffffc0209118:	f27f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020911c:	4501                	li	a0,0
ffffffffc020911e:	60a2                	ld	ra,8(sp)
ffffffffc0209120:	6402                	ld	s0,0(sp)
ffffffffc0209122:	0141                	addi	sp,sp,16
ffffffffc0209124:	8082                	ret
ffffffffc0209126:	5545                	li	a0,-15
ffffffffc0209128:	bfdd                	j	ffffffffc020911e <sfs_unmount+0x38>
ffffffffc020912a:	00006697          	auipc	a3,0x6
ffffffffc020912e:	bee68693          	addi	a3,a3,-1042 # ffffffffc020ed18 <dev_node_ops+0x3e0>
ffffffffc0209132:	00003617          	auipc	a2,0x3
ffffffffc0209136:	85660613          	addi	a2,a2,-1962 # ffffffffc020b988 <commands+0x210>
ffffffffc020913a:	04100593          	li	a1,65
ffffffffc020913e:	00006517          	auipc	a0,0x6
ffffffffc0209142:	c0a50513          	addi	a0,a0,-1014 # ffffffffc020ed48 <dev_node_ops+0x410>
ffffffffc0209146:	b58f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020914a:	00006697          	auipc	a3,0x6
ffffffffc020914e:	c1668693          	addi	a3,a3,-1002 # ffffffffc020ed60 <dev_node_ops+0x428>
ffffffffc0209152:	00003617          	auipc	a2,0x3
ffffffffc0209156:	83660613          	addi	a2,a2,-1994 # ffffffffc020b988 <commands+0x210>
ffffffffc020915a:	04500593          	li	a1,69
ffffffffc020915e:	00006517          	auipc	a0,0x6
ffffffffc0209162:	bea50513          	addi	a0,a0,-1046 # ffffffffc020ed48 <dev_node_ops+0x410>
ffffffffc0209166:	b38f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020916a <sfs_cleanup>:
ffffffffc020916a:	1101                	addi	sp,sp,-32
ffffffffc020916c:	ec06                	sd	ra,24(sp)
ffffffffc020916e:	e822                	sd	s0,16(sp)
ffffffffc0209170:	e426                	sd	s1,8(sp)
ffffffffc0209172:	e04a                	sd	s2,0(sp)
ffffffffc0209174:	c525                	beqz	a0,ffffffffc02091dc <sfs_cleanup+0x72>
ffffffffc0209176:	0b052783          	lw	a5,176(a0)
ffffffffc020917a:	84aa                	mv	s1,a0
ffffffffc020917c:	e3a5                	bnez	a5,ffffffffc02091dc <sfs_cleanup+0x72>
ffffffffc020917e:	4158                	lw	a4,4(a0)
ffffffffc0209180:	4514                	lw	a3,8(a0)
ffffffffc0209182:	00c50913          	addi	s2,a0,12
ffffffffc0209186:	85ca                	mv	a1,s2
ffffffffc0209188:	40d7063b          	subw	a2,a4,a3
ffffffffc020918c:	00006517          	auipc	a0,0x6
ffffffffc0209190:	bec50513          	addi	a0,a0,-1044 # ffffffffc020ed78 <dev_node_ops+0x440>
ffffffffc0209194:	812f70ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0209198:	02000413          	li	s0,32
ffffffffc020919c:	a019                	j	ffffffffc02091a2 <sfs_cleanup+0x38>
ffffffffc020919e:	347d                	addiw	s0,s0,-1
ffffffffc02091a0:	c819                	beqz	s0,ffffffffc02091b6 <sfs_cleanup+0x4c>
ffffffffc02091a2:	7cdc                	ld	a5,184(s1)
ffffffffc02091a4:	8526                	mv	a0,s1
ffffffffc02091a6:	9782                	jalr	a5
ffffffffc02091a8:	f97d                	bnez	a0,ffffffffc020919e <sfs_cleanup+0x34>
ffffffffc02091aa:	60e2                	ld	ra,24(sp)
ffffffffc02091ac:	6442                	ld	s0,16(sp)
ffffffffc02091ae:	64a2                	ld	s1,8(sp)
ffffffffc02091b0:	6902                	ld	s2,0(sp)
ffffffffc02091b2:	6105                	addi	sp,sp,32
ffffffffc02091b4:	8082                	ret
ffffffffc02091b6:	6442                	ld	s0,16(sp)
ffffffffc02091b8:	60e2                	ld	ra,24(sp)
ffffffffc02091ba:	64a2                	ld	s1,8(sp)
ffffffffc02091bc:	86ca                	mv	a3,s2
ffffffffc02091be:	6902                	ld	s2,0(sp)
ffffffffc02091c0:	872a                	mv	a4,a0
ffffffffc02091c2:	00006617          	auipc	a2,0x6
ffffffffc02091c6:	bd660613          	addi	a2,a2,-1066 # ffffffffc020ed98 <dev_node_ops+0x460>
ffffffffc02091ca:	05f00593          	li	a1,95
ffffffffc02091ce:	00006517          	auipc	a0,0x6
ffffffffc02091d2:	b7a50513          	addi	a0,a0,-1158 # ffffffffc020ed48 <dev_node_ops+0x410>
ffffffffc02091d6:	6105                	addi	sp,sp,32
ffffffffc02091d8:	b2ef706f          	j	ffffffffc0200506 <__warn>
ffffffffc02091dc:	00006697          	auipc	a3,0x6
ffffffffc02091e0:	b3c68693          	addi	a3,a3,-1220 # ffffffffc020ed18 <dev_node_ops+0x3e0>
ffffffffc02091e4:	00002617          	auipc	a2,0x2
ffffffffc02091e8:	7a460613          	addi	a2,a2,1956 # ffffffffc020b988 <commands+0x210>
ffffffffc02091ec:	05400593          	li	a1,84
ffffffffc02091f0:	00006517          	auipc	a0,0x6
ffffffffc02091f4:	b5850513          	addi	a0,a0,-1192 # ffffffffc020ed48 <dev_node_ops+0x410>
ffffffffc02091f8:	aa6f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02091fc <sfs_sync>:
ffffffffc02091fc:	7179                	addi	sp,sp,-48
ffffffffc02091fe:	f406                	sd	ra,40(sp)
ffffffffc0209200:	f022                	sd	s0,32(sp)
ffffffffc0209202:	ec26                	sd	s1,24(sp)
ffffffffc0209204:	e84a                	sd	s2,16(sp)
ffffffffc0209206:	e44e                	sd	s3,8(sp)
ffffffffc0209208:	e052                	sd	s4,0(sp)
ffffffffc020920a:	cd4d                	beqz	a0,ffffffffc02092c4 <sfs_sync+0xc8>
ffffffffc020920c:	0b052783          	lw	a5,176(a0)
ffffffffc0209210:	8a2a                	mv	s4,a0
ffffffffc0209212:	ebcd                	bnez	a5,ffffffffc02092c4 <sfs_sync+0xc8>
ffffffffc0209214:	539010ef          	jal	ra,ffffffffc020af4c <lock_sfs_fs>
ffffffffc0209218:	0a0a3403          	ld	s0,160(s4)
ffffffffc020921c:	098a0913          	addi	s2,s4,152
ffffffffc0209220:	02890763          	beq	s2,s0,ffffffffc020924e <sfs_sync+0x52>
ffffffffc0209224:	00004997          	auipc	s3,0x4
ffffffffc0209228:	0ec98993          	addi	s3,s3,236 # ffffffffc020d310 <default_pmm_manager+0xea0>
ffffffffc020922c:	7c1c                	ld	a5,56(s0)
ffffffffc020922e:	fc840493          	addi	s1,s0,-56
ffffffffc0209232:	cbb5                	beqz	a5,ffffffffc02092a6 <sfs_sync+0xaa>
ffffffffc0209234:	7b9c                	ld	a5,48(a5)
ffffffffc0209236:	cba5                	beqz	a5,ffffffffc02092a6 <sfs_sync+0xaa>
ffffffffc0209238:	85ce                	mv	a1,s3
ffffffffc020923a:	8526                	mv	a0,s1
ffffffffc020923c:	e28fe0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0209240:	7c1c                	ld	a5,56(s0)
ffffffffc0209242:	8526                	mv	a0,s1
ffffffffc0209244:	7b9c                	ld	a5,48(a5)
ffffffffc0209246:	9782                	jalr	a5
ffffffffc0209248:	6400                	ld	s0,8(s0)
ffffffffc020924a:	fe8911e3          	bne	s2,s0,ffffffffc020922c <sfs_sync+0x30>
ffffffffc020924e:	8552                	mv	a0,s4
ffffffffc0209250:	50d010ef          	jal	ra,ffffffffc020af5c <unlock_sfs_fs>
ffffffffc0209254:	040a3783          	ld	a5,64(s4)
ffffffffc0209258:	4501                	li	a0,0
ffffffffc020925a:	eb89                	bnez	a5,ffffffffc020926c <sfs_sync+0x70>
ffffffffc020925c:	70a2                	ld	ra,40(sp)
ffffffffc020925e:	7402                	ld	s0,32(sp)
ffffffffc0209260:	64e2                	ld	s1,24(sp)
ffffffffc0209262:	6942                	ld	s2,16(sp)
ffffffffc0209264:	69a2                	ld	s3,8(sp)
ffffffffc0209266:	6a02                	ld	s4,0(sp)
ffffffffc0209268:	6145                	addi	sp,sp,48
ffffffffc020926a:	8082                	ret
ffffffffc020926c:	040a3023          	sd	zero,64(s4)
ffffffffc0209270:	8552                	mv	a0,s4
ffffffffc0209272:	3bf010ef          	jal	ra,ffffffffc020ae30 <sfs_sync_super>
ffffffffc0209276:	cd01                	beqz	a0,ffffffffc020928e <sfs_sync+0x92>
ffffffffc0209278:	70a2                	ld	ra,40(sp)
ffffffffc020927a:	7402                	ld	s0,32(sp)
ffffffffc020927c:	4785                	li	a5,1
ffffffffc020927e:	04fa3023          	sd	a5,64(s4)
ffffffffc0209282:	64e2                	ld	s1,24(sp)
ffffffffc0209284:	6942                	ld	s2,16(sp)
ffffffffc0209286:	69a2                	ld	s3,8(sp)
ffffffffc0209288:	6a02                	ld	s4,0(sp)
ffffffffc020928a:	6145                	addi	sp,sp,48
ffffffffc020928c:	8082                	ret
ffffffffc020928e:	8552                	mv	a0,s4
ffffffffc0209290:	3e7010ef          	jal	ra,ffffffffc020ae76 <sfs_sync_freemap>
ffffffffc0209294:	f175                	bnez	a0,ffffffffc0209278 <sfs_sync+0x7c>
ffffffffc0209296:	70a2                	ld	ra,40(sp)
ffffffffc0209298:	7402                	ld	s0,32(sp)
ffffffffc020929a:	64e2                	ld	s1,24(sp)
ffffffffc020929c:	6942                	ld	s2,16(sp)
ffffffffc020929e:	69a2                	ld	s3,8(sp)
ffffffffc02092a0:	6a02                	ld	s4,0(sp)
ffffffffc02092a2:	6145                	addi	sp,sp,48
ffffffffc02092a4:	8082                	ret
ffffffffc02092a6:	00004697          	auipc	a3,0x4
ffffffffc02092aa:	01a68693          	addi	a3,a3,26 # ffffffffc020d2c0 <default_pmm_manager+0xe50>
ffffffffc02092ae:	00002617          	auipc	a2,0x2
ffffffffc02092b2:	6da60613          	addi	a2,a2,1754 # ffffffffc020b988 <commands+0x210>
ffffffffc02092b6:	45ed                	li	a1,27
ffffffffc02092b8:	00006517          	auipc	a0,0x6
ffffffffc02092bc:	a9050513          	addi	a0,a0,-1392 # ffffffffc020ed48 <dev_node_ops+0x410>
ffffffffc02092c0:	9def70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02092c4:	00006697          	auipc	a3,0x6
ffffffffc02092c8:	a5468693          	addi	a3,a3,-1452 # ffffffffc020ed18 <dev_node_ops+0x3e0>
ffffffffc02092cc:	00002617          	auipc	a2,0x2
ffffffffc02092d0:	6bc60613          	addi	a2,a2,1724 # ffffffffc020b988 <commands+0x210>
ffffffffc02092d4:	45d5                	li	a1,21
ffffffffc02092d6:	00006517          	auipc	a0,0x6
ffffffffc02092da:	a7250513          	addi	a0,a0,-1422 # ffffffffc020ed48 <dev_node_ops+0x410>
ffffffffc02092de:	9c0f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02092e2 <sfs_get_root>:
ffffffffc02092e2:	1101                	addi	sp,sp,-32
ffffffffc02092e4:	ec06                	sd	ra,24(sp)
ffffffffc02092e6:	cd09                	beqz	a0,ffffffffc0209300 <sfs_get_root+0x1e>
ffffffffc02092e8:	0b052783          	lw	a5,176(a0)
ffffffffc02092ec:	eb91                	bnez	a5,ffffffffc0209300 <sfs_get_root+0x1e>
ffffffffc02092ee:	4605                	li	a2,1
ffffffffc02092f0:	002c                	addi	a1,sp,8
ffffffffc02092f2:	370010ef          	jal	ra,ffffffffc020a662 <sfs_load_inode>
ffffffffc02092f6:	e50d                	bnez	a0,ffffffffc0209320 <sfs_get_root+0x3e>
ffffffffc02092f8:	60e2                	ld	ra,24(sp)
ffffffffc02092fa:	6522                	ld	a0,8(sp)
ffffffffc02092fc:	6105                	addi	sp,sp,32
ffffffffc02092fe:	8082                	ret
ffffffffc0209300:	00006697          	auipc	a3,0x6
ffffffffc0209304:	a1868693          	addi	a3,a3,-1512 # ffffffffc020ed18 <dev_node_ops+0x3e0>
ffffffffc0209308:	00002617          	auipc	a2,0x2
ffffffffc020930c:	68060613          	addi	a2,a2,1664 # ffffffffc020b988 <commands+0x210>
ffffffffc0209310:	03600593          	li	a1,54
ffffffffc0209314:	00006517          	auipc	a0,0x6
ffffffffc0209318:	a3450513          	addi	a0,a0,-1484 # ffffffffc020ed48 <dev_node_ops+0x410>
ffffffffc020931c:	982f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209320:	86aa                	mv	a3,a0
ffffffffc0209322:	00006617          	auipc	a2,0x6
ffffffffc0209326:	a9660613          	addi	a2,a2,-1386 # ffffffffc020edb8 <dev_node_ops+0x480>
ffffffffc020932a:	03700593          	li	a1,55
ffffffffc020932e:	00006517          	auipc	a0,0x6
ffffffffc0209332:	a1a50513          	addi	a0,a0,-1510 # ffffffffc020ed48 <dev_node_ops+0x410>
ffffffffc0209336:	968f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020933a <sfs_do_mount>:
ffffffffc020933a:	6518                	ld	a4,8(a0)
ffffffffc020933c:	7171                	addi	sp,sp,-176
ffffffffc020933e:	f506                	sd	ra,168(sp)
ffffffffc0209340:	f122                	sd	s0,160(sp)
ffffffffc0209342:	ed26                	sd	s1,152(sp)
ffffffffc0209344:	e94a                	sd	s2,144(sp)
ffffffffc0209346:	e54e                	sd	s3,136(sp)
ffffffffc0209348:	e152                	sd	s4,128(sp)
ffffffffc020934a:	fcd6                	sd	s5,120(sp)
ffffffffc020934c:	f8da                	sd	s6,112(sp)
ffffffffc020934e:	f4de                	sd	s7,104(sp)
ffffffffc0209350:	f0e2                	sd	s8,96(sp)
ffffffffc0209352:	ece6                	sd	s9,88(sp)
ffffffffc0209354:	e8ea                	sd	s10,80(sp)
ffffffffc0209356:	e4ee                	sd	s11,72(sp)
ffffffffc0209358:	6785                	lui	a5,0x1
ffffffffc020935a:	24f71663          	bne	a4,a5,ffffffffc02095a6 <sfs_do_mount+0x26c>
ffffffffc020935e:	892a                	mv	s2,a0
ffffffffc0209360:	4501                	li	a0,0
ffffffffc0209362:	8aae                	mv	s5,a1
ffffffffc0209364:	f00fe0ef          	jal	ra,ffffffffc0207a64 <__alloc_fs>
ffffffffc0209368:	842a                	mv	s0,a0
ffffffffc020936a:	24050463          	beqz	a0,ffffffffc02095b2 <sfs_do_mount+0x278>
ffffffffc020936e:	0b052b03          	lw	s6,176(a0)
ffffffffc0209372:	260b1263          	bnez	s6,ffffffffc02095d6 <sfs_do_mount+0x29c>
ffffffffc0209376:	03253823          	sd	s2,48(a0)
ffffffffc020937a:	6505                	lui	a0,0x1
ffffffffc020937c:	c13f80ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0209380:	e428                	sd	a0,72(s0)
ffffffffc0209382:	84aa                	mv	s1,a0
ffffffffc0209384:	16050363          	beqz	a0,ffffffffc02094ea <sfs_do_mount+0x1b0>
ffffffffc0209388:	85aa                	mv	a1,a0
ffffffffc020938a:	4681                	li	a3,0
ffffffffc020938c:	6605                	lui	a2,0x1
ffffffffc020938e:	1008                	addi	a0,sp,32
ffffffffc0209390:	852fc0ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc0209394:	02093783          	ld	a5,32(s2)
ffffffffc0209398:	85aa                	mv	a1,a0
ffffffffc020939a:	4601                	li	a2,0
ffffffffc020939c:	854a                	mv	a0,s2
ffffffffc020939e:	9782                	jalr	a5
ffffffffc02093a0:	8a2a                	mv	s4,a0
ffffffffc02093a2:	10051e63          	bnez	a0,ffffffffc02094be <sfs_do_mount+0x184>
ffffffffc02093a6:	408c                	lw	a1,0(s1)
ffffffffc02093a8:	2f8dc637          	lui	a2,0x2f8dc
ffffffffc02093ac:	e2a60613          	addi	a2,a2,-470 # 2f8dbe2a <_binary_bin_sfs_img_size+0x2f866b2a>
ffffffffc02093b0:	14c59863          	bne	a1,a2,ffffffffc0209500 <sfs_do_mount+0x1c6>
ffffffffc02093b4:	40dc                	lw	a5,4(s1)
ffffffffc02093b6:	00093603          	ld	a2,0(s2)
ffffffffc02093ba:	02079713          	slli	a4,a5,0x20
ffffffffc02093be:	9301                	srli	a4,a4,0x20
ffffffffc02093c0:	12e66763          	bltu	a2,a4,ffffffffc02094ee <sfs_do_mount+0x1b4>
ffffffffc02093c4:	020485a3          	sb	zero,43(s1)
ffffffffc02093c8:	0084af03          	lw	t5,8(s1)
ffffffffc02093cc:	00c4ae83          	lw	t4,12(s1)
ffffffffc02093d0:	0104ae03          	lw	t3,16(s1)
ffffffffc02093d4:	0144a303          	lw	t1,20(s1)
ffffffffc02093d8:	0184a883          	lw	a7,24(s1)
ffffffffc02093dc:	01c4a803          	lw	a6,28(s1)
ffffffffc02093e0:	5090                	lw	a2,32(s1)
ffffffffc02093e2:	50d4                	lw	a3,36(s1)
ffffffffc02093e4:	5498                	lw	a4,40(s1)
ffffffffc02093e6:	6511                	lui	a0,0x4
ffffffffc02093e8:	c00c                	sw	a1,0(s0)
ffffffffc02093ea:	c05c                	sw	a5,4(s0)
ffffffffc02093ec:	01e42423          	sw	t5,8(s0)
ffffffffc02093f0:	01d42623          	sw	t4,12(s0)
ffffffffc02093f4:	01c42823          	sw	t3,16(s0)
ffffffffc02093f8:	00642a23          	sw	t1,20(s0)
ffffffffc02093fc:	01142c23          	sw	a7,24(s0)
ffffffffc0209400:	01042e23          	sw	a6,28(s0)
ffffffffc0209404:	d010                	sw	a2,32(s0)
ffffffffc0209406:	d054                	sw	a3,36(s0)
ffffffffc0209408:	d418                	sw	a4,40(s0)
ffffffffc020940a:	b85f80ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020940e:	f448                	sd	a0,168(s0)
ffffffffc0209410:	8c2a                	mv	s8,a0
ffffffffc0209412:	18050c63          	beqz	a0,ffffffffc02095aa <sfs_do_mount+0x270>
ffffffffc0209416:	6711                	lui	a4,0x4
ffffffffc0209418:	87aa                	mv	a5,a0
ffffffffc020941a:	972a                	add	a4,a4,a0
ffffffffc020941c:	e79c                	sd	a5,8(a5)
ffffffffc020941e:	e39c                	sd	a5,0(a5)
ffffffffc0209420:	07c1                	addi	a5,a5,16
ffffffffc0209422:	fee79de3          	bne	a5,a4,ffffffffc020941c <sfs_do_mount+0xe2>
ffffffffc0209426:	0044eb83          	lwu	s7,4(s1)
ffffffffc020942a:	67a1                	lui	a5,0x8
ffffffffc020942c:	fff78993          	addi	s3,a5,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc0209430:	9bce                	add	s7,s7,s3
ffffffffc0209432:	77e1                	lui	a5,0xffff8
ffffffffc0209434:	00fbfbb3          	and	s7,s7,a5
ffffffffc0209438:	2b81                	sext.w	s7,s7
ffffffffc020943a:	855e                	mv	a0,s7
ffffffffc020943c:	a59ff0ef          	jal	ra,ffffffffc0208e94 <bitmap_create>
ffffffffc0209440:	fc08                	sd	a0,56(s0)
ffffffffc0209442:	8d2a                	mv	s10,a0
ffffffffc0209444:	14050f63          	beqz	a0,ffffffffc02095a2 <sfs_do_mount+0x268>
ffffffffc0209448:	0044e783          	lwu	a5,4(s1)
ffffffffc020944c:	082c                	addi	a1,sp,24
ffffffffc020944e:	97ce                	add	a5,a5,s3
ffffffffc0209450:	00f7d713          	srli	a4,a5,0xf
ffffffffc0209454:	e43a                	sd	a4,8(sp)
ffffffffc0209456:	40f7d993          	srai	s3,a5,0xf
ffffffffc020945a:	c4fff0ef          	jal	ra,ffffffffc02090a8 <bitmap_getdata>
ffffffffc020945e:	14050c63          	beqz	a0,ffffffffc02095b6 <sfs_do_mount+0x27c>
ffffffffc0209462:	00c9979b          	slliw	a5,s3,0xc
ffffffffc0209466:	66e2                	ld	a3,24(sp)
ffffffffc0209468:	1782                	slli	a5,a5,0x20
ffffffffc020946a:	9381                	srli	a5,a5,0x20
ffffffffc020946c:	14d79563          	bne	a5,a3,ffffffffc02095b6 <sfs_do_mount+0x27c>
ffffffffc0209470:	6722                	ld	a4,8(sp)
ffffffffc0209472:	6d89                	lui	s11,0x2
ffffffffc0209474:	89aa                	mv	s3,a0
ffffffffc0209476:	00c71c93          	slli	s9,a4,0xc
ffffffffc020947a:	9caa                	add	s9,s9,a0
ffffffffc020947c:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0209480:	e711                	bnez	a4,ffffffffc020948c <sfs_do_mount+0x152>
ffffffffc0209482:	a079                	j	ffffffffc0209510 <sfs_do_mount+0x1d6>
ffffffffc0209484:	6785                	lui	a5,0x1
ffffffffc0209486:	99be                	add	s3,s3,a5
ffffffffc0209488:	093c8463          	beq	s9,s3,ffffffffc0209510 <sfs_do_mount+0x1d6>
ffffffffc020948c:	013d86bb          	addw	a3,s11,s3
ffffffffc0209490:	1682                	slli	a3,a3,0x20
ffffffffc0209492:	6605                	lui	a2,0x1
ffffffffc0209494:	85ce                	mv	a1,s3
ffffffffc0209496:	9281                	srli	a3,a3,0x20
ffffffffc0209498:	1008                	addi	a0,sp,32
ffffffffc020949a:	f49fb0ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc020949e:	02093783          	ld	a5,32(s2)
ffffffffc02094a2:	85aa                	mv	a1,a0
ffffffffc02094a4:	4601                	li	a2,0
ffffffffc02094a6:	854a                	mv	a0,s2
ffffffffc02094a8:	9782                	jalr	a5
ffffffffc02094aa:	dd69                	beqz	a0,ffffffffc0209484 <sfs_do_mount+0x14a>
ffffffffc02094ac:	e42a                	sd	a0,8(sp)
ffffffffc02094ae:	856a                	mv	a0,s10
ffffffffc02094b0:	bdfff0ef          	jal	ra,ffffffffc020908e <bitmap_destroy>
ffffffffc02094b4:	67a2                	ld	a5,8(sp)
ffffffffc02094b6:	8a3e                	mv	s4,a5
ffffffffc02094b8:	8562                	mv	a0,s8
ffffffffc02094ba:	b85f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02094be:	8526                	mv	a0,s1
ffffffffc02094c0:	b7ff80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02094c4:	8522                	mv	a0,s0
ffffffffc02094c6:	b79f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02094ca:	70aa                	ld	ra,168(sp)
ffffffffc02094cc:	740a                	ld	s0,160(sp)
ffffffffc02094ce:	64ea                	ld	s1,152(sp)
ffffffffc02094d0:	694a                	ld	s2,144(sp)
ffffffffc02094d2:	69aa                	ld	s3,136(sp)
ffffffffc02094d4:	7ae6                	ld	s5,120(sp)
ffffffffc02094d6:	7b46                	ld	s6,112(sp)
ffffffffc02094d8:	7ba6                	ld	s7,104(sp)
ffffffffc02094da:	7c06                	ld	s8,96(sp)
ffffffffc02094dc:	6ce6                	ld	s9,88(sp)
ffffffffc02094de:	6d46                	ld	s10,80(sp)
ffffffffc02094e0:	6da6                	ld	s11,72(sp)
ffffffffc02094e2:	8552                	mv	a0,s4
ffffffffc02094e4:	6a0a                	ld	s4,128(sp)
ffffffffc02094e6:	614d                	addi	sp,sp,176
ffffffffc02094e8:	8082                	ret
ffffffffc02094ea:	5a71                	li	s4,-4
ffffffffc02094ec:	bfe1                	j	ffffffffc02094c4 <sfs_do_mount+0x18a>
ffffffffc02094ee:	85be                	mv	a1,a5
ffffffffc02094f0:	00006517          	auipc	a0,0x6
ffffffffc02094f4:	92050513          	addi	a0,a0,-1760 # ffffffffc020ee10 <dev_node_ops+0x4d8>
ffffffffc02094f8:	caff60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02094fc:	5a75                	li	s4,-3
ffffffffc02094fe:	b7c1                	j	ffffffffc02094be <sfs_do_mount+0x184>
ffffffffc0209500:	00006517          	auipc	a0,0x6
ffffffffc0209504:	8d850513          	addi	a0,a0,-1832 # ffffffffc020edd8 <dev_node_ops+0x4a0>
ffffffffc0209508:	c9ff60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020950c:	5a75                	li	s4,-3
ffffffffc020950e:	bf45                	j	ffffffffc02094be <sfs_do_mount+0x184>
ffffffffc0209510:	00442903          	lw	s2,4(s0)
ffffffffc0209514:	4481                	li	s1,0
ffffffffc0209516:	080b8c63          	beqz	s7,ffffffffc02095ae <sfs_do_mount+0x274>
ffffffffc020951a:	85a6                	mv	a1,s1
ffffffffc020951c:	856a                	mv	a0,s10
ffffffffc020951e:	af7ff0ef          	jal	ra,ffffffffc0209014 <bitmap_test>
ffffffffc0209522:	c111                	beqz	a0,ffffffffc0209526 <sfs_do_mount+0x1ec>
ffffffffc0209524:	2b05                	addiw	s6,s6,1
ffffffffc0209526:	2485                	addiw	s1,s1,1
ffffffffc0209528:	fe9b99e3          	bne	s7,s1,ffffffffc020951a <sfs_do_mount+0x1e0>
ffffffffc020952c:	441c                	lw	a5,8(s0)
ffffffffc020952e:	0d679463          	bne	a5,s6,ffffffffc02095f6 <sfs_do_mount+0x2bc>
ffffffffc0209532:	4585                	li	a1,1
ffffffffc0209534:	05040513          	addi	a0,s0,80
ffffffffc0209538:	04043023          	sd	zero,64(s0)
ffffffffc020953c:	81efb0ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc0209540:	4585                	li	a1,1
ffffffffc0209542:	06840513          	addi	a0,s0,104
ffffffffc0209546:	814fb0ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc020954a:	4585                	li	a1,1
ffffffffc020954c:	08040513          	addi	a0,s0,128
ffffffffc0209550:	80afb0ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc0209554:	09840793          	addi	a5,s0,152
ffffffffc0209558:	f05c                	sd	a5,160(s0)
ffffffffc020955a:	ec5c                	sd	a5,152(s0)
ffffffffc020955c:	874a                	mv	a4,s2
ffffffffc020955e:	86da                	mv	a3,s6
ffffffffc0209560:	4169063b          	subw	a2,s2,s6
ffffffffc0209564:	00c40593          	addi	a1,s0,12
ffffffffc0209568:	00006517          	auipc	a0,0x6
ffffffffc020956c:	93850513          	addi	a0,a0,-1736 # ffffffffc020eea0 <dev_node_ops+0x568>
ffffffffc0209570:	c37f60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0209574:	00000797          	auipc	a5,0x0
ffffffffc0209578:	c8878793          	addi	a5,a5,-888 # ffffffffc02091fc <sfs_sync>
ffffffffc020957c:	fc5c                	sd	a5,184(s0)
ffffffffc020957e:	00000797          	auipc	a5,0x0
ffffffffc0209582:	d6478793          	addi	a5,a5,-668 # ffffffffc02092e2 <sfs_get_root>
ffffffffc0209586:	e07c                	sd	a5,192(s0)
ffffffffc0209588:	00000797          	auipc	a5,0x0
ffffffffc020958c:	b5e78793          	addi	a5,a5,-1186 # ffffffffc02090e6 <sfs_unmount>
ffffffffc0209590:	e47c                	sd	a5,200(s0)
ffffffffc0209592:	00000797          	auipc	a5,0x0
ffffffffc0209596:	bd878793          	addi	a5,a5,-1064 # ffffffffc020916a <sfs_cleanup>
ffffffffc020959a:	e87c                	sd	a5,208(s0)
ffffffffc020959c:	008ab023          	sd	s0,0(s5)
ffffffffc02095a0:	b72d                	j	ffffffffc02094ca <sfs_do_mount+0x190>
ffffffffc02095a2:	5a71                	li	s4,-4
ffffffffc02095a4:	bf11                	j	ffffffffc02094b8 <sfs_do_mount+0x17e>
ffffffffc02095a6:	5a49                	li	s4,-14
ffffffffc02095a8:	b70d                	j	ffffffffc02094ca <sfs_do_mount+0x190>
ffffffffc02095aa:	5a71                	li	s4,-4
ffffffffc02095ac:	bf09                	j	ffffffffc02094be <sfs_do_mount+0x184>
ffffffffc02095ae:	4b01                	li	s6,0
ffffffffc02095b0:	bfb5                	j	ffffffffc020952c <sfs_do_mount+0x1f2>
ffffffffc02095b2:	5a71                	li	s4,-4
ffffffffc02095b4:	bf19                	j	ffffffffc02094ca <sfs_do_mount+0x190>
ffffffffc02095b6:	00006697          	auipc	a3,0x6
ffffffffc02095ba:	88a68693          	addi	a3,a3,-1910 # ffffffffc020ee40 <dev_node_ops+0x508>
ffffffffc02095be:	00002617          	auipc	a2,0x2
ffffffffc02095c2:	3ca60613          	addi	a2,a2,970 # ffffffffc020b988 <commands+0x210>
ffffffffc02095c6:	08300593          	li	a1,131
ffffffffc02095ca:	00005517          	auipc	a0,0x5
ffffffffc02095ce:	77e50513          	addi	a0,a0,1918 # ffffffffc020ed48 <dev_node_ops+0x410>
ffffffffc02095d2:	ecdf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02095d6:	00005697          	auipc	a3,0x5
ffffffffc02095da:	74268693          	addi	a3,a3,1858 # ffffffffc020ed18 <dev_node_ops+0x3e0>
ffffffffc02095de:	00002617          	auipc	a2,0x2
ffffffffc02095e2:	3aa60613          	addi	a2,a2,938 # ffffffffc020b988 <commands+0x210>
ffffffffc02095e6:	0a300593          	li	a1,163
ffffffffc02095ea:	00005517          	auipc	a0,0x5
ffffffffc02095ee:	75e50513          	addi	a0,a0,1886 # ffffffffc020ed48 <dev_node_ops+0x410>
ffffffffc02095f2:	eadf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02095f6:	00006697          	auipc	a3,0x6
ffffffffc02095fa:	87a68693          	addi	a3,a3,-1926 # ffffffffc020ee70 <dev_node_ops+0x538>
ffffffffc02095fe:	00002617          	auipc	a2,0x2
ffffffffc0209602:	38a60613          	addi	a2,a2,906 # ffffffffc020b988 <commands+0x210>
ffffffffc0209606:	0e000593          	li	a1,224
ffffffffc020960a:	00005517          	auipc	a0,0x5
ffffffffc020960e:	73e50513          	addi	a0,a0,1854 # ffffffffc020ed48 <dev_node_ops+0x410>
ffffffffc0209612:	e8df60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209616 <sfs_mount>:
ffffffffc0209616:	00000597          	auipc	a1,0x0
ffffffffc020961a:	d2458593          	addi	a1,a1,-732 # ffffffffc020933a <sfs_do_mount>
ffffffffc020961e:	817fe06f          	j	ffffffffc0207e34 <vfs_mount>

ffffffffc0209622 <sfs_opendir>:
ffffffffc0209622:	0235f593          	andi	a1,a1,35
ffffffffc0209626:	4501                	li	a0,0
ffffffffc0209628:	e191                	bnez	a1,ffffffffc020962c <sfs_opendir+0xa>
ffffffffc020962a:	8082                	ret
ffffffffc020962c:	553d                	li	a0,-17
ffffffffc020962e:	8082                	ret

ffffffffc0209630 <sfs_openfile>:
ffffffffc0209630:	4501                	li	a0,0
ffffffffc0209632:	8082                	ret

ffffffffc0209634 <sfs_gettype>:
ffffffffc0209634:	1141                	addi	sp,sp,-16
ffffffffc0209636:	e406                	sd	ra,8(sp)
ffffffffc0209638:	c939                	beqz	a0,ffffffffc020968e <sfs_gettype+0x5a>
ffffffffc020963a:	4d34                	lw	a3,88(a0)
ffffffffc020963c:	6785                	lui	a5,0x1
ffffffffc020963e:	23578713          	addi	a4,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209642:	04e69663          	bne	a3,a4,ffffffffc020968e <sfs_gettype+0x5a>
ffffffffc0209646:	6114                	ld	a3,0(a0)
ffffffffc0209648:	4709                	li	a4,2
ffffffffc020964a:	0046d683          	lhu	a3,4(a3)
ffffffffc020964e:	02e68a63          	beq	a3,a4,ffffffffc0209682 <sfs_gettype+0x4e>
ffffffffc0209652:	470d                	li	a4,3
ffffffffc0209654:	02e68163          	beq	a3,a4,ffffffffc0209676 <sfs_gettype+0x42>
ffffffffc0209658:	4705                	li	a4,1
ffffffffc020965a:	00e68f63          	beq	a3,a4,ffffffffc0209678 <sfs_gettype+0x44>
ffffffffc020965e:	00006617          	auipc	a2,0x6
ffffffffc0209662:	8b260613          	addi	a2,a2,-1870 # ffffffffc020ef10 <dev_node_ops+0x5d8>
ffffffffc0209666:	38e00593          	li	a1,910
ffffffffc020966a:	00006517          	auipc	a0,0x6
ffffffffc020966e:	88e50513          	addi	a0,a0,-1906 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209672:	e2df60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209676:	678d                	lui	a5,0x3
ffffffffc0209678:	60a2                	ld	ra,8(sp)
ffffffffc020967a:	c19c                	sw	a5,0(a1)
ffffffffc020967c:	4501                	li	a0,0
ffffffffc020967e:	0141                	addi	sp,sp,16
ffffffffc0209680:	8082                	ret
ffffffffc0209682:	60a2                	ld	ra,8(sp)
ffffffffc0209684:	6789                	lui	a5,0x2
ffffffffc0209686:	c19c                	sw	a5,0(a1)
ffffffffc0209688:	4501                	li	a0,0
ffffffffc020968a:	0141                	addi	sp,sp,16
ffffffffc020968c:	8082                	ret
ffffffffc020968e:	00006697          	auipc	a3,0x6
ffffffffc0209692:	83268693          	addi	a3,a3,-1998 # ffffffffc020eec0 <dev_node_ops+0x588>
ffffffffc0209696:	00002617          	auipc	a2,0x2
ffffffffc020969a:	2f260613          	addi	a2,a2,754 # ffffffffc020b988 <commands+0x210>
ffffffffc020969e:	38200593          	li	a1,898
ffffffffc02096a2:	00006517          	auipc	a0,0x6
ffffffffc02096a6:	85650513          	addi	a0,a0,-1962 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc02096aa:	df5f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02096ae <sfs_fsync>:
ffffffffc02096ae:	7179                	addi	sp,sp,-48
ffffffffc02096b0:	ec26                	sd	s1,24(sp)
ffffffffc02096b2:	7524                	ld	s1,104(a0)
ffffffffc02096b4:	f406                	sd	ra,40(sp)
ffffffffc02096b6:	f022                	sd	s0,32(sp)
ffffffffc02096b8:	e84a                	sd	s2,16(sp)
ffffffffc02096ba:	e44e                	sd	s3,8(sp)
ffffffffc02096bc:	c4bd                	beqz	s1,ffffffffc020972a <sfs_fsync+0x7c>
ffffffffc02096be:	0b04a783          	lw	a5,176(s1)
ffffffffc02096c2:	e7a5                	bnez	a5,ffffffffc020972a <sfs_fsync+0x7c>
ffffffffc02096c4:	4d38                	lw	a4,88(a0)
ffffffffc02096c6:	6785                	lui	a5,0x1
ffffffffc02096c8:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02096cc:	842a                	mv	s0,a0
ffffffffc02096ce:	06f71e63          	bne	a4,a5,ffffffffc020974a <sfs_fsync+0x9c>
ffffffffc02096d2:	691c                	ld	a5,16(a0)
ffffffffc02096d4:	4901                	li	s2,0
ffffffffc02096d6:	eb89                	bnez	a5,ffffffffc02096e8 <sfs_fsync+0x3a>
ffffffffc02096d8:	70a2                	ld	ra,40(sp)
ffffffffc02096da:	7402                	ld	s0,32(sp)
ffffffffc02096dc:	64e2                	ld	s1,24(sp)
ffffffffc02096de:	69a2                	ld	s3,8(sp)
ffffffffc02096e0:	854a                	mv	a0,s2
ffffffffc02096e2:	6942                	ld	s2,16(sp)
ffffffffc02096e4:	6145                	addi	sp,sp,48
ffffffffc02096e6:	8082                	ret
ffffffffc02096e8:	02050993          	addi	s3,a0,32
ffffffffc02096ec:	854e                	mv	a0,s3
ffffffffc02096ee:	e77fa0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc02096f2:	681c                	ld	a5,16(s0)
ffffffffc02096f4:	ef81                	bnez	a5,ffffffffc020970c <sfs_fsync+0x5e>
ffffffffc02096f6:	854e                	mv	a0,s3
ffffffffc02096f8:	e69fa0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc02096fc:	70a2                	ld	ra,40(sp)
ffffffffc02096fe:	7402                	ld	s0,32(sp)
ffffffffc0209700:	64e2                	ld	s1,24(sp)
ffffffffc0209702:	69a2                	ld	s3,8(sp)
ffffffffc0209704:	854a                	mv	a0,s2
ffffffffc0209706:	6942                	ld	s2,16(sp)
ffffffffc0209708:	6145                	addi	sp,sp,48
ffffffffc020970a:	8082                	ret
ffffffffc020970c:	4414                	lw	a3,8(s0)
ffffffffc020970e:	600c                	ld	a1,0(s0)
ffffffffc0209710:	00043823          	sd	zero,16(s0)
ffffffffc0209714:	4701                	li	a4,0
ffffffffc0209716:	04000613          	li	a2,64
ffffffffc020971a:	8526                	mv	a0,s1
ffffffffc020971c:	680010ef          	jal	ra,ffffffffc020ad9c <sfs_wbuf>
ffffffffc0209720:	892a                	mv	s2,a0
ffffffffc0209722:	d971                	beqz	a0,ffffffffc02096f6 <sfs_fsync+0x48>
ffffffffc0209724:	4785                	li	a5,1
ffffffffc0209726:	e81c                	sd	a5,16(s0)
ffffffffc0209728:	b7f9                	j	ffffffffc02096f6 <sfs_fsync+0x48>
ffffffffc020972a:	00005697          	auipc	a3,0x5
ffffffffc020972e:	5ee68693          	addi	a3,a3,1518 # ffffffffc020ed18 <dev_node_ops+0x3e0>
ffffffffc0209732:	00002617          	auipc	a2,0x2
ffffffffc0209736:	25660613          	addi	a2,a2,598 # ffffffffc020b988 <commands+0x210>
ffffffffc020973a:	2c600593          	li	a1,710
ffffffffc020973e:	00005517          	auipc	a0,0x5
ffffffffc0209742:	7ba50513          	addi	a0,a0,1978 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209746:	d59f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020974a:	00005697          	auipc	a3,0x5
ffffffffc020974e:	77668693          	addi	a3,a3,1910 # ffffffffc020eec0 <dev_node_ops+0x588>
ffffffffc0209752:	00002617          	auipc	a2,0x2
ffffffffc0209756:	23660613          	addi	a2,a2,566 # ffffffffc020b988 <commands+0x210>
ffffffffc020975a:	2c700593          	li	a1,711
ffffffffc020975e:	00005517          	auipc	a0,0x5
ffffffffc0209762:	79a50513          	addi	a0,a0,1946 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209766:	d39f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020976a <sfs_fstat>:
ffffffffc020976a:	1101                	addi	sp,sp,-32
ffffffffc020976c:	e426                	sd	s1,8(sp)
ffffffffc020976e:	84ae                	mv	s1,a1
ffffffffc0209770:	e822                	sd	s0,16(sp)
ffffffffc0209772:	02000613          	li	a2,32
ffffffffc0209776:	842a                	mv	s0,a0
ffffffffc0209778:	4581                	li	a1,0
ffffffffc020977a:	8526                	mv	a0,s1
ffffffffc020977c:	ec06                	sd	ra,24(sp)
ffffffffc020977e:	523010ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc0209782:	c439                	beqz	s0,ffffffffc02097d0 <sfs_fstat+0x66>
ffffffffc0209784:	783c                	ld	a5,112(s0)
ffffffffc0209786:	c7a9                	beqz	a5,ffffffffc02097d0 <sfs_fstat+0x66>
ffffffffc0209788:	6bbc                	ld	a5,80(a5)
ffffffffc020978a:	c3b9                	beqz	a5,ffffffffc02097d0 <sfs_fstat+0x66>
ffffffffc020978c:	00005597          	auipc	a1,0x5
ffffffffc0209790:	12458593          	addi	a1,a1,292 # ffffffffc020e8b0 <syscalls+0xdb0>
ffffffffc0209794:	8522                	mv	a0,s0
ffffffffc0209796:	8cefe0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc020979a:	783c                	ld	a5,112(s0)
ffffffffc020979c:	85a6                	mv	a1,s1
ffffffffc020979e:	8522                	mv	a0,s0
ffffffffc02097a0:	6bbc                	ld	a5,80(a5)
ffffffffc02097a2:	9782                	jalr	a5
ffffffffc02097a4:	e10d                	bnez	a0,ffffffffc02097c6 <sfs_fstat+0x5c>
ffffffffc02097a6:	4c38                	lw	a4,88(s0)
ffffffffc02097a8:	6785                	lui	a5,0x1
ffffffffc02097aa:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02097ae:	04f71163          	bne	a4,a5,ffffffffc02097f0 <sfs_fstat+0x86>
ffffffffc02097b2:	601c                	ld	a5,0(s0)
ffffffffc02097b4:	0067d683          	lhu	a3,6(a5)
ffffffffc02097b8:	0087e703          	lwu	a4,8(a5)
ffffffffc02097bc:	0007e783          	lwu	a5,0(a5)
ffffffffc02097c0:	e494                	sd	a3,8(s1)
ffffffffc02097c2:	e898                	sd	a4,16(s1)
ffffffffc02097c4:	ec9c                	sd	a5,24(s1)
ffffffffc02097c6:	60e2                	ld	ra,24(sp)
ffffffffc02097c8:	6442                	ld	s0,16(sp)
ffffffffc02097ca:	64a2                	ld	s1,8(sp)
ffffffffc02097cc:	6105                	addi	sp,sp,32
ffffffffc02097ce:	8082                	ret
ffffffffc02097d0:	00005697          	auipc	a3,0x5
ffffffffc02097d4:	07868693          	addi	a3,a3,120 # ffffffffc020e848 <syscalls+0xd48>
ffffffffc02097d8:	00002617          	auipc	a2,0x2
ffffffffc02097dc:	1b060613          	addi	a2,a2,432 # ffffffffc020b988 <commands+0x210>
ffffffffc02097e0:	2b700593          	li	a1,695
ffffffffc02097e4:	00005517          	auipc	a0,0x5
ffffffffc02097e8:	71450513          	addi	a0,a0,1812 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc02097ec:	cb3f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02097f0:	00005697          	auipc	a3,0x5
ffffffffc02097f4:	6d068693          	addi	a3,a3,1744 # ffffffffc020eec0 <dev_node_ops+0x588>
ffffffffc02097f8:	00002617          	auipc	a2,0x2
ffffffffc02097fc:	19060613          	addi	a2,a2,400 # ffffffffc020b988 <commands+0x210>
ffffffffc0209800:	2ba00593          	li	a1,698
ffffffffc0209804:	00005517          	auipc	a0,0x5
ffffffffc0209808:	6f450513          	addi	a0,a0,1780 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020980c:	c93f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209810 <sfs_tryseek>:
ffffffffc0209810:	080007b7          	lui	a5,0x8000
ffffffffc0209814:	04f5fd63          	bgeu	a1,a5,ffffffffc020986e <sfs_tryseek+0x5e>
ffffffffc0209818:	1101                	addi	sp,sp,-32
ffffffffc020981a:	e822                	sd	s0,16(sp)
ffffffffc020981c:	ec06                	sd	ra,24(sp)
ffffffffc020981e:	e426                	sd	s1,8(sp)
ffffffffc0209820:	842a                	mv	s0,a0
ffffffffc0209822:	c921                	beqz	a0,ffffffffc0209872 <sfs_tryseek+0x62>
ffffffffc0209824:	4d38                	lw	a4,88(a0)
ffffffffc0209826:	6785                	lui	a5,0x1
ffffffffc0209828:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020982c:	04f71363          	bne	a4,a5,ffffffffc0209872 <sfs_tryseek+0x62>
ffffffffc0209830:	611c                	ld	a5,0(a0)
ffffffffc0209832:	84ae                	mv	s1,a1
ffffffffc0209834:	0007e783          	lwu	a5,0(a5)
ffffffffc0209838:	02b7d563          	bge	a5,a1,ffffffffc0209862 <sfs_tryseek+0x52>
ffffffffc020983c:	793c                	ld	a5,112(a0)
ffffffffc020983e:	cbb1                	beqz	a5,ffffffffc0209892 <sfs_tryseek+0x82>
ffffffffc0209840:	73bc                	ld	a5,96(a5)
ffffffffc0209842:	cba1                	beqz	a5,ffffffffc0209892 <sfs_tryseek+0x82>
ffffffffc0209844:	00005597          	auipc	a1,0x5
ffffffffc0209848:	f5c58593          	addi	a1,a1,-164 # ffffffffc020e7a0 <syscalls+0xca0>
ffffffffc020984c:	818fe0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0209850:	783c                	ld	a5,112(s0)
ffffffffc0209852:	8522                	mv	a0,s0
ffffffffc0209854:	6442                	ld	s0,16(sp)
ffffffffc0209856:	60e2                	ld	ra,24(sp)
ffffffffc0209858:	73bc                	ld	a5,96(a5)
ffffffffc020985a:	85a6                	mv	a1,s1
ffffffffc020985c:	64a2                	ld	s1,8(sp)
ffffffffc020985e:	6105                	addi	sp,sp,32
ffffffffc0209860:	8782                	jr	a5
ffffffffc0209862:	60e2                	ld	ra,24(sp)
ffffffffc0209864:	6442                	ld	s0,16(sp)
ffffffffc0209866:	64a2                	ld	s1,8(sp)
ffffffffc0209868:	4501                	li	a0,0
ffffffffc020986a:	6105                	addi	sp,sp,32
ffffffffc020986c:	8082                	ret
ffffffffc020986e:	5575                	li	a0,-3
ffffffffc0209870:	8082                	ret
ffffffffc0209872:	00005697          	auipc	a3,0x5
ffffffffc0209876:	64e68693          	addi	a3,a3,1614 # ffffffffc020eec0 <dev_node_ops+0x588>
ffffffffc020987a:	00002617          	auipc	a2,0x2
ffffffffc020987e:	10e60613          	addi	a2,a2,270 # ffffffffc020b988 <commands+0x210>
ffffffffc0209882:	39900593          	li	a1,921
ffffffffc0209886:	00005517          	auipc	a0,0x5
ffffffffc020988a:	67250513          	addi	a0,a0,1650 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020988e:	c11f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209892:	00005697          	auipc	a3,0x5
ffffffffc0209896:	eb668693          	addi	a3,a3,-330 # ffffffffc020e748 <syscalls+0xc48>
ffffffffc020989a:	00002617          	auipc	a2,0x2
ffffffffc020989e:	0ee60613          	addi	a2,a2,238 # ffffffffc020b988 <commands+0x210>
ffffffffc02098a2:	39b00593          	li	a1,923
ffffffffc02098a6:	00005517          	auipc	a0,0x5
ffffffffc02098aa:	65250513          	addi	a0,a0,1618 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc02098ae:	bf1f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02098b2 <sfs_close>:
ffffffffc02098b2:	1141                	addi	sp,sp,-16
ffffffffc02098b4:	e406                	sd	ra,8(sp)
ffffffffc02098b6:	e022                	sd	s0,0(sp)
ffffffffc02098b8:	c11d                	beqz	a0,ffffffffc02098de <sfs_close+0x2c>
ffffffffc02098ba:	793c                	ld	a5,112(a0)
ffffffffc02098bc:	842a                	mv	s0,a0
ffffffffc02098be:	c385                	beqz	a5,ffffffffc02098de <sfs_close+0x2c>
ffffffffc02098c0:	7b9c                	ld	a5,48(a5)
ffffffffc02098c2:	cf91                	beqz	a5,ffffffffc02098de <sfs_close+0x2c>
ffffffffc02098c4:	00004597          	auipc	a1,0x4
ffffffffc02098c8:	a4c58593          	addi	a1,a1,-1460 # ffffffffc020d310 <default_pmm_manager+0xea0>
ffffffffc02098cc:	f99fd0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc02098d0:	783c                	ld	a5,112(s0)
ffffffffc02098d2:	8522                	mv	a0,s0
ffffffffc02098d4:	6402                	ld	s0,0(sp)
ffffffffc02098d6:	60a2                	ld	ra,8(sp)
ffffffffc02098d8:	7b9c                	ld	a5,48(a5)
ffffffffc02098da:	0141                	addi	sp,sp,16
ffffffffc02098dc:	8782                	jr	a5
ffffffffc02098de:	00004697          	auipc	a3,0x4
ffffffffc02098e2:	9e268693          	addi	a3,a3,-1566 # ffffffffc020d2c0 <default_pmm_manager+0xe50>
ffffffffc02098e6:	00002617          	auipc	a2,0x2
ffffffffc02098ea:	0a260613          	addi	a2,a2,162 # ffffffffc020b988 <commands+0x210>
ffffffffc02098ee:	21c00593          	li	a1,540
ffffffffc02098f2:	00005517          	auipc	a0,0x5
ffffffffc02098f6:	60650513          	addi	a0,a0,1542 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc02098fa:	ba5f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02098fe <sfs_io.part.0>:
ffffffffc02098fe:	1141                	addi	sp,sp,-16
ffffffffc0209900:	00005697          	auipc	a3,0x5
ffffffffc0209904:	5c068693          	addi	a3,a3,1472 # ffffffffc020eec0 <dev_node_ops+0x588>
ffffffffc0209908:	00002617          	auipc	a2,0x2
ffffffffc020990c:	08060613          	addi	a2,a2,128 # ffffffffc020b988 <commands+0x210>
ffffffffc0209910:	29600593          	li	a1,662
ffffffffc0209914:	00005517          	auipc	a0,0x5
ffffffffc0209918:	5e450513          	addi	a0,a0,1508 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020991c:	e406                	sd	ra,8(sp)
ffffffffc020991e:	b81f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209922 <sfs_block_free>:
ffffffffc0209922:	1101                	addi	sp,sp,-32
ffffffffc0209924:	e426                	sd	s1,8(sp)
ffffffffc0209926:	ec06                	sd	ra,24(sp)
ffffffffc0209928:	e822                	sd	s0,16(sp)
ffffffffc020992a:	4154                	lw	a3,4(a0)
ffffffffc020992c:	84ae                	mv	s1,a1
ffffffffc020992e:	c595                	beqz	a1,ffffffffc020995a <sfs_block_free+0x38>
ffffffffc0209930:	02d5f563          	bgeu	a1,a3,ffffffffc020995a <sfs_block_free+0x38>
ffffffffc0209934:	842a                	mv	s0,a0
ffffffffc0209936:	7d08                	ld	a0,56(a0)
ffffffffc0209938:	edcff0ef          	jal	ra,ffffffffc0209014 <bitmap_test>
ffffffffc020993c:	ed05                	bnez	a0,ffffffffc0209974 <sfs_block_free+0x52>
ffffffffc020993e:	7c08                	ld	a0,56(s0)
ffffffffc0209940:	85a6                	mv	a1,s1
ffffffffc0209942:	efaff0ef          	jal	ra,ffffffffc020903c <bitmap_free>
ffffffffc0209946:	441c                	lw	a5,8(s0)
ffffffffc0209948:	4705                	li	a4,1
ffffffffc020994a:	60e2                	ld	ra,24(sp)
ffffffffc020994c:	2785                	addiw	a5,a5,1
ffffffffc020994e:	e038                	sd	a4,64(s0)
ffffffffc0209950:	c41c                	sw	a5,8(s0)
ffffffffc0209952:	6442                	ld	s0,16(sp)
ffffffffc0209954:	64a2                	ld	s1,8(sp)
ffffffffc0209956:	6105                	addi	sp,sp,32
ffffffffc0209958:	8082                	ret
ffffffffc020995a:	8726                	mv	a4,s1
ffffffffc020995c:	00005617          	auipc	a2,0x5
ffffffffc0209960:	5cc60613          	addi	a2,a2,1484 # ffffffffc020ef28 <dev_node_ops+0x5f0>
ffffffffc0209964:	05300593          	li	a1,83
ffffffffc0209968:	00005517          	auipc	a0,0x5
ffffffffc020996c:	59050513          	addi	a0,a0,1424 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209970:	b2ff60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209974:	00005697          	auipc	a3,0x5
ffffffffc0209978:	5ec68693          	addi	a3,a3,1516 # ffffffffc020ef60 <dev_node_ops+0x628>
ffffffffc020997c:	00002617          	auipc	a2,0x2
ffffffffc0209980:	00c60613          	addi	a2,a2,12 # ffffffffc020b988 <commands+0x210>
ffffffffc0209984:	06a00593          	li	a1,106
ffffffffc0209988:	00005517          	auipc	a0,0x5
ffffffffc020998c:	57050513          	addi	a0,a0,1392 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209990:	b0ff60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209994 <sfs_reclaim>:
ffffffffc0209994:	1101                	addi	sp,sp,-32
ffffffffc0209996:	e426                	sd	s1,8(sp)
ffffffffc0209998:	7524                	ld	s1,104(a0)
ffffffffc020999a:	ec06                	sd	ra,24(sp)
ffffffffc020999c:	e822                	sd	s0,16(sp)
ffffffffc020999e:	e04a                	sd	s2,0(sp)
ffffffffc02099a0:	0e048a63          	beqz	s1,ffffffffc0209a94 <sfs_reclaim+0x100>
ffffffffc02099a4:	0b04a783          	lw	a5,176(s1)
ffffffffc02099a8:	0e079663          	bnez	a5,ffffffffc0209a94 <sfs_reclaim+0x100>
ffffffffc02099ac:	4d38                	lw	a4,88(a0)
ffffffffc02099ae:	6785                	lui	a5,0x1
ffffffffc02099b0:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02099b4:	842a                	mv	s0,a0
ffffffffc02099b6:	10f71f63          	bne	a4,a5,ffffffffc0209ad4 <sfs_reclaim+0x140>
ffffffffc02099ba:	8526                	mv	a0,s1
ffffffffc02099bc:	590010ef          	jal	ra,ffffffffc020af4c <lock_sfs_fs>
ffffffffc02099c0:	4c1c                	lw	a5,24(s0)
ffffffffc02099c2:	0ef05963          	blez	a5,ffffffffc0209ab4 <sfs_reclaim+0x120>
ffffffffc02099c6:	fff7871b          	addiw	a4,a5,-1
ffffffffc02099ca:	cc18                	sw	a4,24(s0)
ffffffffc02099cc:	eb59                	bnez	a4,ffffffffc0209a62 <sfs_reclaim+0xce>
ffffffffc02099ce:	05c42903          	lw	s2,92(s0)
ffffffffc02099d2:	08091863          	bnez	s2,ffffffffc0209a62 <sfs_reclaim+0xce>
ffffffffc02099d6:	601c                	ld	a5,0(s0)
ffffffffc02099d8:	0067d783          	lhu	a5,6(a5)
ffffffffc02099dc:	e785                	bnez	a5,ffffffffc0209a04 <sfs_reclaim+0x70>
ffffffffc02099de:	783c                	ld	a5,112(s0)
ffffffffc02099e0:	10078a63          	beqz	a5,ffffffffc0209af4 <sfs_reclaim+0x160>
ffffffffc02099e4:	73bc                	ld	a5,96(a5)
ffffffffc02099e6:	10078763          	beqz	a5,ffffffffc0209af4 <sfs_reclaim+0x160>
ffffffffc02099ea:	00005597          	auipc	a1,0x5
ffffffffc02099ee:	db658593          	addi	a1,a1,-586 # ffffffffc020e7a0 <syscalls+0xca0>
ffffffffc02099f2:	8522                	mv	a0,s0
ffffffffc02099f4:	e71fd0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc02099f8:	783c                	ld	a5,112(s0)
ffffffffc02099fa:	4581                	li	a1,0
ffffffffc02099fc:	8522                	mv	a0,s0
ffffffffc02099fe:	73bc                	ld	a5,96(a5)
ffffffffc0209a00:	9782                	jalr	a5
ffffffffc0209a02:	e559                	bnez	a0,ffffffffc0209a90 <sfs_reclaim+0xfc>
ffffffffc0209a04:	681c                	ld	a5,16(s0)
ffffffffc0209a06:	c39d                	beqz	a5,ffffffffc0209a2c <sfs_reclaim+0x98>
ffffffffc0209a08:	783c                	ld	a5,112(s0)
ffffffffc0209a0a:	10078563          	beqz	a5,ffffffffc0209b14 <sfs_reclaim+0x180>
ffffffffc0209a0e:	7b9c                	ld	a5,48(a5)
ffffffffc0209a10:	10078263          	beqz	a5,ffffffffc0209b14 <sfs_reclaim+0x180>
ffffffffc0209a14:	8522                	mv	a0,s0
ffffffffc0209a16:	00004597          	auipc	a1,0x4
ffffffffc0209a1a:	8fa58593          	addi	a1,a1,-1798 # ffffffffc020d310 <default_pmm_manager+0xea0>
ffffffffc0209a1e:	e47fd0ef          	jal	ra,ffffffffc0207864 <inode_check>
ffffffffc0209a22:	783c                	ld	a5,112(s0)
ffffffffc0209a24:	8522                	mv	a0,s0
ffffffffc0209a26:	7b9c                	ld	a5,48(a5)
ffffffffc0209a28:	9782                	jalr	a5
ffffffffc0209a2a:	e13d                	bnez	a0,ffffffffc0209a90 <sfs_reclaim+0xfc>
ffffffffc0209a2c:	7c18                	ld	a4,56(s0)
ffffffffc0209a2e:	603c                	ld	a5,64(s0)
ffffffffc0209a30:	8526                	mv	a0,s1
ffffffffc0209a32:	e71c                	sd	a5,8(a4)
ffffffffc0209a34:	e398                	sd	a4,0(a5)
ffffffffc0209a36:	6438                	ld	a4,72(s0)
ffffffffc0209a38:	683c                	ld	a5,80(s0)
ffffffffc0209a3a:	e71c                	sd	a5,8(a4)
ffffffffc0209a3c:	e398                	sd	a4,0(a5)
ffffffffc0209a3e:	51e010ef          	jal	ra,ffffffffc020af5c <unlock_sfs_fs>
ffffffffc0209a42:	6008                	ld	a0,0(s0)
ffffffffc0209a44:	00655783          	lhu	a5,6(a0)
ffffffffc0209a48:	cb85                	beqz	a5,ffffffffc0209a78 <sfs_reclaim+0xe4>
ffffffffc0209a4a:	df4f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0209a4e:	8522                	mv	a0,s0
ffffffffc0209a50:	da9fd0ef          	jal	ra,ffffffffc02077f8 <inode_kill>
ffffffffc0209a54:	60e2                	ld	ra,24(sp)
ffffffffc0209a56:	6442                	ld	s0,16(sp)
ffffffffc0209a58:	64a2                	ld	s1,8(sp)
ffffffffc0209a5a:	854a                	mv	a0,s2
ffffffffc0209a5c:	6902                	ld	s2,0(sp)
ffffffffc0209a5e:	6105                	addi	sp,sp,32
ffffffffc0209a60:	8082                	ret
ffffffffc0209a62:	5945                	li	s2,-15
ffffffffc0209a64:	8526                	mv	a0,s1
ffffffffc0209a66:	4f6010ef          	jal	ra,ffffffffc020af5c <unlock_sfs_fs>
ffffffffc0209a6a:	60e2                	ld	ra,24(sp)
ffffffffc0209a6c:	6442                	ld	s0,16(sp)
ffffffffc0209a6e:	64a2                	ld	s1,8(sp)
ffffffffc0209a70:	854a                	mv	a0,s2
ffffffffc0209a72:	6902                	ld	s2,0(sp)
ffffffffc0209a74:	6105                	addi	sp,sp,32
ffffffffc0209a76:	8082                	ret
ffffffffc0209a78:	440c                	lw	a1,8(s0)
ffffffffc0209a7a:	8526                	mv	a0,s1
ffffffffc0209a7c:	ea7ff0ef          	jal	ra,ffffffffc0209922 <sfs_block_free>
ffffffffc0209a80:	6008                	ld	a0,0(s0)
ffffffffc0209a82:	5d4c                	lw	a1,60(a0)
ffffffffc0209a84:	d1f9                	beqz	a1,ffffffffc0209a4a <sfs_reclaim+0xb6>
ffffffffc0209a86:	8526                	mv	a0,s1
ffffffffc0209a88:	e9bff0ef          	jal	ra,ffffffffc0209922 <sfs_block_free>
ffffffffc0209a8c:	6008                	ld	a0,0(s0)
ffffffffc0209a8e:	bf75                	j	ffffffffc0209a4a <sfs_reclaim+0xb6>
ffffffffc0209a90:	892a                	mv	s2,a0
ffffffffc0209a92:	bfc9                	j	ffffffffc0209a64 <sfs_reclaim+0xd0>
ffffffffc0209a94:	00005697          	auipc	a3,0x5
ffffffffc0209a98:	28468693          	addi	a3,a3,644 # ffffffffc020ed18 <dev_node_ops+0x3e0>
ffffffffc0209a9c:	00002617          	auipc	a2,0x2
ffffffffc0209aa0:	eec60613          	addi	a2,a2,-276 # ffffffffc020b988 <commands+0x210>
ffffffffc0209aa4:	35700593          	li	a1,855
ffffffffc0209aa8:	00005517          	auipc	a0,0x5
ffffffffc0209aac:	45050513          	addi	a0,a0,1104 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209ab0:	9eff60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209ab4:	00005697          	auipc	a3,0x5
ffffffffc0209ab8:	4cc68693          	addi	a3,a3,1228 # ffffffffc020ef80 <dev_node_ops+0x648>
ffffffffc0209abc:	00002617          	auipc	a2,0x2
ffffffffc0209ac0:	ecc60613          	addi	a2,a2,-308 # ffffffffc020b988 <commands+0x210>
ffffffffc0209ac4:	35d00593          	li	a1,861
ffffffffc0209ac8:	00005517          	auipc	a0,0x5
ffffffffc0209acc:	43050513          	addi	a0,a0,1072 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209ad0:	9cff60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209ad4:	00005697          	auipc	a3,0x5
ffffffffc0209ad8:	3ec68693          	addi	a3,a3,1004 # ffffffffc020eec0 <dev_node_ops+0x588>
ffffffffc0209adc:	00002617          	auipc	a2,0x2
ffffffffc0209ae0:	eac60613          	addi	a2,a2,-340 # ffffffffc020b988 <commands+0x210>
ffffffffc0209ae4:	35800593          	li	a1,856
ffffffffc0209ae8:	00005517          	auipc	a0,0x5
ffffffffc0209aec:	41050513          	addi	a0,a0,1040 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209af0:	9aff60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209af4:	00005697          	auipc	a3,0x5
ffffffffc0209af8:	c5468693          	addi	a3,a3,-940 # ffffffffc020e748 <syscalls+0xc48>
ffffffffc0209afc:	00002617          	auipc	a2,0x2
ffffffffc0209b00:	e8c60613          	addi	a2,a2,-372 # ffffffffc020b988 <commands+0x210>
ffffffffc0209b04:	36200593          	li	a1,866
ffffffffc0209b08:	00005517          	auipc	a0,0x5
ffffffffc0209b0c:	3f050513          	addi	a0,a0,1008 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209b10:	98ff60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209b14:	00003697          	auipc	a3,0x3
ffffffffc0209b18:	7ac68693          	addi	a3,a3,1964 # ffffffffc020d2c0 <default_pmm_manager+0xe50>
ffffffffc0209b1c:	00002617          	auipc	a2,0x2
ffffffffc0209b20:	e6c60613          	addi	a2,a2,-404 # ffffffffc020b988 <commands+0x210>
ffffffffc0209b24:	36700593          	li	a1,871
ffffffffc0209b28:	00005517          	auipc	a0,0x5
ffffffffc0209b2c:	3d050513          	addi	a0,a0,976 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209b30:	96ff60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209b34 <sfs_block_alloc>:
ffffffffc0209b34:	1101                	addi	sp,sp,-32
ffffffffc0209b36:	e822                	sd	s0,16(sp)
ffffffffc0209b38:	842a                	mv	s0,a0
ffffffffc0209b3a:	7d08                	ld	a0,56(a0)
ffffffffc0209b3c:	e426                	sd	s1,8(sp)
ffffffffc0209b3e:	ec06                	sd	ra,24(sp)
ffffffffc0209b40:	84ae                	mv	s1,a1
ffffffffc0209b42:	c62ff0ef          	jal	ra,ffffffffc0208fa4 <bitmap_alloc>
ffffffffc0209b46:	e90d                	bnez	a0,ffffffffc0209b78 <sfs_block_alloc+0x44>
ffffffffc0209b48:	441c                	lw	a5,8(s0)
ffffffffc0209b4a:	cbad                	beqz	a5,ffffffffc0209bbc <sfs_block_alloc+0x88>
ffffffffc0209b4c:	37fd                	addiw	a5,a5,-1
ffffffffc0209b4e:	c41c                	sw	a5,8(s0)
ffffffffc0209b50:	408c                	lw	a1,0(s1)
ffffffffc0209b52:	4785                	li	a5,1
ffffffffc0209b54:	e03c                	sd	a5,64(s0)
ffffffffc0209b56:	4054                	lw	a3,4(s0)
ffffffffc0209b58:	c58d                	beqz	a1,ffffffffc0209b82 <sfs_block_alloc+0x4e>
ffffffffc0209b5a:	02d5f463          	bgeu	a1,a3,ffffffffc0209b82 <sfs_block_alloc+0x4e>
ffffffffc0209b5e:	7c08                	ld	a0,56(s0)
ffffffffc0209b60:	cb4ff0ef          	jal	ra,ffffffffc0209014 <bitmap_test>
ffffffffc0209b64:	ed05                	bnez	a0,ffffffffc0209b9c <sfs_block_alloc+0x68>
ffffffffc0209b66:	8522                	mv	a0,s0
ffffffffc0209b68:	6442                	ld	s0,16(sp)
ffffffffc0209b6a:	408c                	lw	a1,0(s1)
ffffffffc0209b6c:	60e2                	ld	ra,24(sp)
ffffffffc0209b6e:	64a2                	ld	s1,8(sp)
ffffffffc0209b70:	4605                	li	a2,1
ffffffffc0209b72:	6105                	addi	sp,sp,32
ffffffffc0209b74:	3780106f          	j	ffffffffc020aeec <sfs_clear_block>
ffffffffc0209b78:	60e2                	ld	ra,24(sp)
ffffffffc0209b7a:	6442                	ld	s0,16(sp)
ffffffffc0209b7c:	64a2                	ld	s1,8(sp)
ffffffffc0209b7e:	6105                	addi	sp,sp,32
ffffffffc0209b80:	8082                	ret
ffffffffc0209b82:	872e                	mv	a4,a1
ffffffffc0209b84:	00005617          	auipc	a2,0x5
ffffffffc0209b88:	3a460613          	addi	a2,a2,932 # ffffffffc020ef28 <dev_node_ops+0x5f0>
ffffffffc0209b8c:	05300593          	li	a1,83
ffffffffc0209b90:	00005517          	auipc	a0,0x5
ffffffffc0209b94:	36850513          	addi	a0,a0,872 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209b98:	907f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209b9c:	00005697          	auipc	a3,0x5
ffffffffc0209ba0:	41c68693          	addi	a3,a3,1052 # ffffffffc020efb8 <dev_node_ops+0x680>
ffffffffc0209ba4:	00002617          	auipc	a2,0x2
ffffffffc0209ba8:	de460613          	addi	a2,a2,-540 # ffffffffc020b988 <commands+0x210>
ffffffffc0209bac:	06100593          	li	a1,97
ffffffffc0209bb0:	00005517          	auipc	a0,0x5
ffffffffc0209bb4:	34850513          	addi	a0,a0,840 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209bb8:	8e7f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209bbc:	00005697          	auipc	a3,0x5
ffffffffc0209bc0:	3dc68693          	addi	a3,a3,988 # ffffffffc020ef98 <dev_node_ops+0x660>
ffffffffc0209bc4:	00002617          	auipc	a2,0x2
ffffffffc0209bc8:	dc460613          	addi	a2,a2,-572 # ffffffffc020b988 <commands+0x210>
ffffffffc0209bcc:	05f00593          	li	a1,95
ffffffffc0209bd0:	00005517          	auipc	a0,0x5
ffffffffc0209bd4:	32850513          	addi	a0,a0,808 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209bd8:	8c7f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209bdc <sfs_bmap_load_nolock>:
ffffffffc0209bdc:	7159                	addi	sp,sp,-112
ffffffffc0209bde:	f85a                	sd	s6,48(sp)
ffffffffc0209be0:	0005bb03          	ld	s6,0(a1)
ffffffffc0209be4:	f45e                	sd	s7,40(sp)
ffffffffc0209be6:	f486                	sd	ra,104(sp)
ffffffffc0209be8:	008b2b83          	lw	s7,8(s6)
ffffffffc0209bec:	f0a2                	sd	s0,96(sp)
ffffffffc0209bee:	eca6                	sd	s1,88(sp)
ffffffffc0209bf0:	e8ca                	sd	s2,80(sp)
ffffffffc0209bf2:	e4ce                	sd	s3,72(sp)
ffffffffc0209bf4:	e0d2                	sd	s4,64(sp)
ffffffffc0209bf6:	fc56                	sd	s5,56(sp)
ffffffffc0209bf8:	f062                	sd	s8,32(sp)
ffffffffc0209bfa:	ec66                	sd	s9,24(sp)
ffffffffc0209bfc:	18cbe363          	bltu	s7,a2,ffffffffc0209d82 <sfs_bmap_load_nolock+0x1a6>
ffffffffc0209c00:	47ad                	li	a5,11
ffffffffc0209c02:	8aae                	mv	s5,a1
ffffffffc0209c04:	8432                	mv	s0,a2
ffffffffc0209c06:	84aa                	mv	s1,a0
ffffffffc0209c08:	89b6                	mv	s3,a3
ffffffffc0209c0a:	04c7f563          	bgeu	a5,a2,ffffffffc0209c54 <sfs_bmap_load_nolock+0x78>
ffffffffc0209c0e:	ff46071b          	addiw	a4,a2,-12
ffffffffc0209c12:	0007069b          	sext.w	a3,a4
ffffffffc0209c16:	3ff00793          	li	a5,1023
ffffffffc0209c1a:	1ad7e163          	bltu	a5,a3,ffffffffc0209dbc <sfs_bmap_load_nolock+0x1e0>
ffffffffc0209c1e:	03cb2a03          	lw	s4,60(s6)
ffffffffc0209c22:	02071793          	slli	a5,a4,0x20
ffffffffc0209c26:	c602                	sw	zero,12(sp)
ffffffffc0209c28:	c452                	sw	s4,8(sp)
ffffffffc0209c2a:	01e7dc13          	srli	s8,a5,0x1e
ffffffffc0209c2e:	0e0a1e63          	bnez	s4,ffffffffc0209d2a <sfs_bmap_load_nolock+0x14e>
ffffffffc0209c32:	0acb8663          	beq	s7,a2,ffffffffc0209cde <sfs_bmap_load_nolock+0x102>
ffffffffc0209c36:	4a01                	li	s4,0
ffffffffc0209c38:	40d4                	lw	a3,4(s1)
ffffffffc0209c3a:	8752                	mv	a4,s4
ffffffffc0209c3c:	00005617          	auipc	a2,0x5
ffffffffc0209c40:	2ec60613          	addi	a2,a2,748 # ffffffffc020ef28 <dev_node_ops+0x5f0>
ffffffffc0209c44:	05300593          	li	a1,83
ffffffffc0209c48:	00005517          	auipc	a0,0x5
ffffffffc0209c4c:	2b050513          	addi	a0,a0,688 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209c50:	84ff60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209c54:	02061793          	slli	a5,a2,0x20
ffffffffc0209c58:	01e7da13          	srli	s4,a5,0x1e
ffffffffc0209c5c:	9a5a                	add	s4,s4,s6
ffffffffc0209c5e:	00ca2583          	lw	a1,12(s4)
ffffffffc0209c62:	c22e                	sw	a1,4(sp)
ffffffffc0209c64:	ed99                	bnez	a1,ffffffffc0209c82 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209c66:	fccb98e3          	bne	s7,a2,ffffffffc0209c36 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209c6a:	004c                	addi	a1,sp,4
ffffffffc0209c6c:	ec9ff0ef          	jal	ra,ffffffffc0209b34 <sfs_block_alloc>
ffffffffc0209c70:	892a                	mv	s2,a0
ffffffffc0209c72:	e921                	bnez	a0,ffffffffc0209cc2 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209c74:	4592                	lw	a1,4(sp)
ffffffffc0209c76:	4705                	li	a4,1
ffffffffc0209c78:	00ba2623          	sw	a1,12(s4)
ffffffffc0209c7c:	00eab823          	sd	a4,16(s5)
ffffffffc0209c80:	d9dd                	beqz	a1,ffffffffc0209c36 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209c82:	40d4                	lw	a3,4(s1)
ffffffffc0209c84:	10d5ff63          	bgeu	a1,a3,ffffffffc0209da2 <sfs_bmap_load_nolock+0x1c6>
ffffffffc0209c88:	7c88                	ld	a0,56(s1)
ffffffffc0209c8a:	b8aff0ef          	jal	ra,ffffffffc0209014 <bitmap_test>
ffffffffc0209c8e:	18051363          	bnez	a0,ffffffffc0209e14 <sfs_bmap_load_nolock+0x238>
ffffffffc0209c92:	4a12                	lw	s4,4(sp)
ffffffffc0209c94:	fa0a02e3          	beqz	s4,ffffffffc0209c38 <sfs_bmap_load_nolock+0x5c>
ffffffffc0209c98:	40dc                	lw	a5,4(s1)
ffffffffc0209c9a:	f8fa7fe3          	bgeu	s4,a5,ffffffffc0209c38 <sfs_bmap_load_nolock+0x5c>
ffffffffc0209c9e:	7c88                	ld	a0,56(s1)
ffffffffc0209ca0:	85d2                	mv	a1,s4
ffffffffc0209ca2:	b72ff0ef          	jal	ra,ffffffffc0209014 <bitmap_test>
ffffffffc0209ca6:	12051763          	bnez	a0,ffffffffc0209dd4 <sfs_bmap_load_nolock+0x1f8>
ffffffffc0209caa:	008b9763          	bne	s7,s0,ffffffffc0209cb8 <sfs_bmap_load_nolock+0xdc>
ffffffffc0209cae:	008b2783          	lw	a5,8(s6)
ffffffffc0209cb2:	2785                	addiw	a5,a5,1
ffffffffc0209cb4:	00fb2423          	sw	a5,8(s6)
ffffffffc0209cb8:	4901                	li	s2,0
ffffffffc0209cba:	00098463          	beqz	s3,ffffffffc0209cc2 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209cbe:	0149a023          	sw	s4,0(s3)
ffffffffc0209cc2:	70a6                	ld	ra,104(sp)
ffffffffc0209cc4:	7406                	ld	s0,96(sp)
ffffffffc0209cc6:	64e6                	ld	s1,88(sp)
ffffffffc0209cc8:	69a6                	ld	s3,72(sp)
ffffffffc0209cca:	6a06                	ld	s4,64(sp)
ffffffffc0209ccc:	7ae2                	ld	s5,56(sp)
ffffffffc0209cce:	7b42                	ld	s6,48(sp)
ffffffffc0209cd0:	7ba2                	ld	s7,40(sp)
ffffffffc0209cd2:	7c02                	ld	s8,32(sp)
ffffffffc0209cd4:	6ce2                	ld	s9,24(sp)
ffffffffc0209cd6:	854a                	mv	a0,s2
ffffffffc0209cd8:	6946                	ld	s2,80(sp)
ffffffffc0209cda:	6165                	addi	sp,sp,112
ffffffffc0209cdc:	8082                	ret
ffffffffc0209cde:	002c                	addi	a1,sp,8
ffffffffc0209ce0:	e55ff0ef          	jal	ra,ffffffffc0209b34 <sfs_block_alloc>
ffffffffc0209ce4:	892a                	mv	s2,a0
ffffffffc0209ce6:	00c10c93          	addi	s9,sp,12
ffffffffc0209cea:	fd61                	bnez	a0,ffffffffc0209cc2 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209cec:	85e6                	mv	a1,s9
ffffffffc0209cee:	8526                	mv	a0,s1
ffffffffc0209cf0:	e45ff0ef          	jal	ra,ffffffffc0209b34 <sfs_block_alloc>
ffffffffc0209cf4:	892a                	mv	s2,a0
ffffffffc0209cf6:	e925                	bnez	a0,ffffffffc0209d66 <sfs_bmap_load_nolock+0x18a>
ffffffffc0209cf8:	46a2                	lw	a3,8(sp)
ffffffffc0209cfa:	85e6                	mv	a1,s9
ffffffffc0209cfc:	8762                	mv	a4,s8
ffffffffc0209cfe:	4611                	li	a2,4
ffffffffc0209d00:	8526                	mv	a0,s1
ffffffffc0209d02:	09a010ef          	jal	ra,ffffffffc020ad9c <sfs_wbuf>
ffffffffc0209d06:	45b2                	lw	a1,12(sp)
ffffffffc0209d08:	892a                	mv	s2,a0
ffffffffc0209d0a:	e939                	bnez	a0,ffffffffc0209d60 <sfs_bmap_load_nolock+0x184>
ffffffffc0209d0c:	03cb2683          	lw	a3,60(s6)
ffffffffc0209d10:	4722                	lw	a4,8(sp)
ffffffffc0209d12:	c22e                	sw	a1,4(sp)
ffffffffc0209d14:	f6d706e3          	beq	a4,a3,ffffffffc0209c80 <sfs_bmap_load_nolock+0xa4>
ffffffffc0209d18:	eef1                	bnez	a3,ffffffffc0209df4 <sfs_bmap_load_nolock+0x218>
ffffffffc0209d1a:	02eb2e23          	sw	a4,60(s6)
ffffffffc0209d1e:	4705                	li	a4,1
ffffffffc0209d20:	00eab823          	sd	a4,16(s5)
ffffffffc0209d24:	f00589e3          	beqz	a1,ffffffffc0209c36 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209d28:	bfa9                	j	ffffffffc0209c82 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209d2a:	00c10c93          	addi	s9,sp,12
ffffffffc0209d2e:	8762                	mv	a4,s8
ffffffffc0209d30:	86d2                	mv	a3,s4
ffffffffc0209d32:	4611                	li	a2,4
ffffffffc0209d34:	85e6                	mv	a1,s9
ffffffffc0209d36:	7e7000ef          	jal	ra,ffffffffc020ad1c <sfs_rbuf>
ffffffffc0209d3a:	892a                	mv	s2,a0
ffffffffc0209d3c:	f159                	bnez	a0,ffffffffc0209cc2 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209d3e:	45b2                	lw	a1,12(sp)
ffffffffc0209d40:	e995                	bnez	a1,ffffffffc0209d74 <sfs_bmap_load_nolock+0x198>
ffffffffc0209d42:	fa8b85e3          	beq	s7,s0,ffffffffc0209cec <sfs_bmap_load_nolock+0x110>
ffffffffc0209d46:	03cb2703          	lw	a4,60(s6)
ffffffffc0209d4a:	47a2                	lw	a5,8(sp)
ffffffffc0209d4c:	c202                	sw	zero,4(sp)
ffffffffc0209d4e:	eee784e3          	beq	a5,a4,ffffffffc0209c36 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209d52:	e34d                	bnez	a4,ffffffffc0209df4 <sfs_bmap_load_nolock+0x218>
ffffffffc0209d54:	02fb2e23          	sw	a5,60(s6)
ffffffffc0209d58:	4785                	li	a5,1
ffffffffc0209d5a:	00fab823          	sd	a5,16(s5)
ffffffffc0209d5e:	bde1                	j	ffffffffc0209c36 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209d60:	8526                	mv	a0,s1
ffffffffc0209d62:	bc1ff0ef          	jal	ra,ffffffffc0209922 <sfs_block_free>
ffffffffc0209d66:	45a2                	lw	a1,8(sp)
ffffffffc0209d68:	f4ba0de3          	beq	s4,a1,ffffffffc0209cc2 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209d6c:	8526                	mv	a0,s1
ffffffffc0209d6e:	bb5ff0ef          	jal	ra,ffffffffc0209922 <sfs_block_free>
ffffffffc0209d72:	bf81                	j	ffffffffc0209cc2 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209d74:	03cb2683          	lw	a3,60(s6)
ffffffffc0209d78:	4722                	lw	a4,8(sp)
ffffffffc0209d7a:	c22e                	sw	a1,4(sp)
ffffffffc0209d7c:	f8e69ee3          	bne	a3,a4,ffffffffc0209d18 <sfs_bmap_load_nolock+0x13c>
ffffffffc0209d80:	b709                	j	ffffffffc0209c82 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209d82:	00005697          	auipc	a3,0x5
ffffffffc0209d86:	25e68693          	addi	a3,a3,606 # ffffffffc020efe0 <dev_node_ops+0x6a8>
ffffffffc0209d8a:	00002617          	auipc	a2,0x2
ffffffffc0209d8e:	bfe60613          	addi	a2,a2,-1026 # ffffffffc020b988 <commands+0x210>
ffffffffc0209d92:	16400593          	li	a1,356
ffffffffc0209d96:	00005517          	auipc	a0,0x5
ffffffffc0209d9a:	16250513          	addi	a0,a0,354 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209d9e:	f00f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209da2:	872e                	mv	a4,a1
ffffffffc0209da4:	00005617          	auipc	a2,0x5
ffffffffc0209da8:	18460613          	addi	a2,a2,388 # ffffffffc020ef28 <dev_node_ops+0x5f0>
ffffffffc0209dac:	05300593          	li	a1,83
ffffffffc0209db0:	00005517          	auipc	a0,0x5
ffffffffc0209db4:	14850513          	addi	a0,a0,328 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209db8:	ee6f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209dbc:	00005617          	auipc	a2,0x5
ffffffffc0209dc0:	25460613          	addi	a2,a2,596 # ffffffffc020f010 <dev_node_ops+0x6d8>
ffffffffc0209dc4:	11e00593          	li	a1,286
ffffffffc0209dc8:	00005517          	auipc	a0,0x5
ffffffffc0209dcc:	13050513          	addi	a0,a0,304 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209dd0:	ecef60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209dd4:	00005697          	auipc	a3,0x5
ffffffffc0209dd8:	18c68693          	addi	a3,a3,396 # ffffffffc020ef60 <dev_node_ops+0x628>
ffffffffc0209ddc:	00002617          	auipc	a2,0x2
ffffffffc0209de0:	bac60613          	addi	a2,a2,-1108 # ffffffffc020b988 <commands+0x210>
ffffffffc0209de4:	16b00593          	li	a1,363
ffffffffc0209de8:	00005517          	auipc	a0,0x5
ffffffffc0209dec:	11050513          	addi	a0,a0,272 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209df0:	eaef60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209df4:	00005697          	auipc	a3,0x5
ffffffffc0209df8:	20468693          	addi	a3,a3,516 # ffffffffc020eff8 <dev_node_ops+0x6c0>
ffffffffc0209dfc:	00002617          	auipc	a2,0x2
ffffffffc0209e00:	b8c60613          	addi	a2,a2,-1140 # ffffffffc020b988 <commands+0x210>
ffffffffc0209e04:	11800593          	li	a1,280
ffffffffc0209e08:	00005517          	auipc	a0,0x5
ffffffffc0209e0c:	0f050513          	addi	a0,a0,240 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209e10:	e8ef60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209e14:	00005697          	auipc	a3,0x5
ffffffffc0209e18:	22c68693          	addi	a3,a3,556 # ffffffffc020f040 <dev_node_ops+0x708>
ffffffffc0209e1c:	00002617          	auipc	a2,0x2
ffffffffc0209e20:	b6c60613          	addi	a2,a2,-1172 # ffffffffc020b988 <commands+0x210>
ffffffffc0209e24:	12100593          	li	a1,289
ffffffffc0209e28:	00005517          	auipc	a0,0x5
ffffffffc0209e2c:	0d050513          	addi	a0,a0,208 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc0209e30:	e6ef60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209e34 <sfs_io_nolock>:
ffffffffc0209e34:	7175                	addi	sp,sp,-144
ffffffffc0209e36:	f0d2                	sd	s4,96(sp)
ffffffffc0209e38:	8a2e                	mv	s4,a1
ffffffffc0209e3a:	618c                	ld	a1,0(a1)
ffffffffc0209e3c:	e506                	sd	ra,136(sp)
ffffffffc0209e3e:	e122                	sd	s0,128(sp)
ffffffffc0209e40:	0045d883          	lhu	a7,4(a1)
ffffffffc0209e44:	fca6                	sd	s1,120(sp)
ffffffffc0209e46:	f8ca                	sd	s2,112(sp)
ffffffffc0209e48:	f4ce                	sd	s3,104(sp)
ffffffffc0209e4a:	ecd6                	sd	s5,88(sp)
ffffffffc0209e4c:	e8da                	sd	s6,80(sp)
ffffffffc0209e4e:	e4de                	sd	s7,72(sp)
ffffffffc0209e50:	e0e2                	sd	s8,64(sp)
ffffffffc0209e52:	fc66                	sd	s9,56(sp)
ffffffffc0209e54:	f86a                	sd	s10,48(sp)
ffffffffc0209e56:	f46e                	sd	s11,40(sp)
ffffffffc0209e58:	4809                	li	a6,2
ffffffffc0209e5a:	19088c63          	beq	a7,a6,ffffffffc0209ff2 <sfs_io_nolock+0x1be>
ffffffffc0209e5e:	00073a83          	ld	s5,0(a4) # 4000 <_binary_bin_swap_img_size-0x3d00>
ffffffffc0209e62:	8cbe                	mv	s9,a5
ffffffffc0209e64:	00073023          	sd	zero,0(a4)
ffffffffc0209e68:	080007b7          	lui	a5,0x8000
ffffffffc0209e6c:	8936                	mv	s2,a3
ffffffffc0209e6e:	8c3a                	mv	s8,a4
ffffffffc0209e70:	9ab6                	add	s5,s5,a3
ffffffffc0209e72:	16f6fe63          	bgeu	a3,a5,ffffffffc0209fee <sfs_io_nolock+0x1ba>
ffffffffc0209e76:	16dacc63          	blt	s5,a3,ffffffffc0209fee <sfs_io_nolock+0x1ba>
ffffffffc0209e7a:	84aa                	mv	s1,a0
ffffffffc0209e7c:	4501                	li	a0,0
ffffffffc0209e7e:	0d568963          	beq	a3,s5,ffffffffc0209f50 <sfs_io_nolock+0x11c>
ffffffffc0209e82:	8432                	mv	s0,a2
ffffffffc0209e84:	0157f463          	bgeu	a5,s5,ffffffffc0209e8c <sfs_io_nolock+0x58>
ffffffffc0209e88:	08000ab7          	lui	s5,0x8000
ffffffffc0209e8c:	0e0c8163          	beqz	s9,ffffffffc0209f6e <sfs_io_nolock+0x13a>
ffffffffc0209e90:	00001797          	auipc	a5,0x1
ffffffffc0209e94:	f0c78793          	addi	a5,a5,-244 # ffffffffc020ad9c <sfs_wbuf>
ffffffffc0209e98:	00001d17          	auipc	s10,0x1
ffffffffc0209e9c:	e24d0d13          	addi	s10,s10,-476 # ffffffffc020acbc <sfs_wblock>
ffffffffc0209ea0:	e03e                	sd	a5,0(sp)
ffffffffc0209ea2:	6705                	lui	a4,0x1
ffffffffc0209ea4:	40c95793          	srai	a5,s2,0xc
ffffffffc0209ea8:	40cadb13          	srai	s6,s5,0xc
ffffffffc0209eac:	fff70b93          	addi	s7,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0209eb0:	40fb083b          	subw	a6,s6,a5
ffffffffc0209eb4:	01797bb3          	and	s7,s2,s7
ffffffffc0209eb8:	8b42                	mv	s6,a6
ffffffffc0209eba:	00078d9b          	sext.w	s11,a5
ffffffffc0209ebe:	89de                	mv	s3,s7
ffffffffc0209ec0:	020b8d63          	beqz	s7,ffffffffc0209efa <sfs_io_nolock+0xc6>
ffffffffc0209ec4:	412a89b3          	sub	s3,s5,s2
ffffffffc0209ec8:	0c081463          	bnez	a6,ffffffffc0209f90 <sfs_io_nolock+0x15c>
ffffffffc0209ecc:	0874                	addi	a3,sp,28
ffffffffc0209ece:	866e                	mv	a2,s11
ffffffffc0209ed0:	85d2                	mv	a1,s4
ffffffffc0209ed2:	8526                	mv	a0,s1
ffffffffc0209ed4:	e442                	sd	a6,8(sp)
ffffffffc0209ed6:	d07ff0ef          	jal	ra,ffffffffc0209bdc <sfs_bmap_load_nolock>
ffffffffc0209eda:	e569                	bnez	a0,ffffffffc0209fa4 <sfs_io_nolock+0x170>
ffffffffc0209edc:	46f2                	lw	a3,28(sp)
ffffffffc0209ede:	6782                	ld	a5,0(sp)
ffffffffc0209ee0:	875e                	mv	a4,s7
ffffffffc0209ee2:	864e                	mv	a2,s3
ffffffffc0209ee4:	85a2                	mv	a1,s0
ffffffffc0209ee6:	8526                	mv	a0,s1
ffffffffc0209ee8:	9782                	jalr	a5
ffffffffc0209eea:	ed4d                	bnez	a0,ffffffffc0209fa4 <sfs_io_nolock+0x170>
ffffffffc0209eec:	6822                	ld	a6,8(sp)
ffffffffc0209eee:	02080e63          	beqz	a6,ffffffffc0209f2a <sfs_io_nolock+0xf6>
ffffffffc0209ef2:	944e                	add	s0,s0,s3
ffffffffc0209ef4:	2d85                	addiw	s11,s11,1
ffffffffc0209ef6:	fffb081b          	addiw	a6,s6,-1
ffffffffc0209efa:	0c080263          	beqz	a6,ffffffffc0209fbe <sfs_io_nolock+0x18a>
ffffffffc0209efe:	01b80bbb          	addw	s7,a6,s11
ffffffffc0209f02:	6b05                	lui	s6,0x1
ffffffffc0209f04:	a821                	j	ffffffffc0209f1c <sfs_io_nolock+0xe8>
ffffffffc0209f06:	4672                	lw	a2,28(sp)
ffffffffc0209f08:	4685                	li	a3,1
ffffffffc0209f0a:	85a2                	mv	a1,s0
ffffffffc0209f0c:	8526                	mv	a0,s1
ffffffffc0209f0e:	9d02                	jalr	s10
ffffffffc0209f10:	ed09                	bnez	a0,ffffffffc0209f2a <sfs_io_nolock+0xf6>
ffffffffc0209f12:	2d85                	addiw	s11,s11,1
ffffffffc0209f14:	99da                	add	s3,s3,s6
ffffffffc0209f16:	945a                	add	s0,s0,s6
ffffffffc0209f18:	0bbb8463          	beq	s7,s11,ffffffffc0209fc0 <sfs_io_nolock+0x18c>
ffffffffc0209f1c:	0874                	addi	a3,sp,28
ffffffffc0209f1e:	866e                	mv	a2,s11
ffffffffc0209f20:	85d2                	mv	a1,s4
ffffffffc0209f22:	8526                	mv	a0,s1
ffffffffc0209f24:	cb9ff0ef          	jal	ra,ffffffffc0209bdc <sfs_bmap_load_nolock>
ffffffffc0209f28:	dd79                	beqz	a0,ffffffffc0209f06 <sfs_io_nolock+0xd2>
ffffffffc0209f2a:	013c3023          	sd	s3,0(s8)
ffffffffc0209f2e:	020c8163          	beqz	s9,ffffffffc0209f50 <sfs_io_nolock+0x11c>
ffffffffc0209f32:	000a3703          	ld	a4,0(s4)
ffffffffc0209f36:	013907b3          	add	a5,s2,s3
ffffffffc0209f3a:	00076683          	lwu	a3,0(a4)
ffffffffc0209f3e:	00f6f963          	bgeu	a3,a5,ffffffffc0209f50 <sfs_io_nolock+0x11c>
ffffffffc0209f42:	0139093b          	addw	s2,s2,s3
ffffffffc0209f46:	01272023          	sw	s2,0(a4)
ffffffffc0209f4a:	4785                	li	a5,1
ffffffffc0209f4c:	00fa3823          	sd	a5,16(s4)
ffffffffc0209f50:	60aa                	ld	ra,136(sp)
ffffffffc0209f52:	640a                	ld	s0,128(sp)
ffffffffc0209f54:	74e6                	ld	s1,120(sp)
ffffffffc0209f56:	7946                	ld	s2,112(sp)
ffffffffc0209f58:	79a6                	ld	s3,104(sp)
ffffffffc0209f5a:	7a06                	ld	s4,96(sp)
ffffffffc0209f5c:	6ae6                	ld	s5,88(sp)
ffffffffc0209f5e:	6b46                	ld	s6,80(sp)
ffffffffc0209f60:	6ba6                	ld	s7,72(sp)
ffffffffc0209f62:	6c06                	ld	s8,64(sp)
ffffffffc0209f64:	7ce2                	ld	s9,56(sp)
ffffffffc0209f66:	7d42                	ld	s10,48(sp)
ffffffffc0209f68:	7da2                	ld	s11,40(sp)
ffffffffc0209f6a:	6149                	addi	sp,sp,144
ffffffffc0209f6c:	8082                	ret
ffffffffc0209f6e:	0005e783          	lwu	a5,0(a1)
ffffffffc0209f72:	4501                	li	a0,0
ffffffffc0209f74:	fcf95ee3          	bge	s2,a5,ffffffffc0209f50 <sfs_io_nolock+0x11c>
ffffffffc0209f78:	0357c863          	blt	a5,s5,ffffffffc0209fa8 <sfs_io_nolock+0x174>
ffffffffc0209f7c:	00001797          	auipc	a5,0x1
ffffffffc0209f80:	da078793          	addi	a5,a5,-608 # ffffffffc020ad1c <sfs_rbuf>
ffffffffc0209f84:	00001d17          	auipc	s10,0x1
ffffffffc0209f88:	cd8d0d13          	addi	s10,s10,-808 # ffffffffc020ac5c <sfs_rblock>
ffffffffc0209f8c:	e03e                	sd	a5,0(sp)
ffffffffc0209f8e:	bf11                	j	ffffffffc0209ea2 <sfs_io_nolock+0x6e>
ffffffffc0209f90:	0874                	addi	a3,sp,28
ffffffffc0209f92:	866e                	mv	a2,s11
ffffffffc0209f94:	85d2                	mv	a1,s4
ffffffffc0209f96:	8526                	mv	a0,s1
ffffffffc0209f98:	417709b3          	sub	s3,a4,s7
ffffffffc0209f9c:	e442                	sd	a6,8(sp)
ffffffffc0209f9e:	c3fff0ef          	jal	ra,ffffffffc0209bdc <sfs_bmap_load_nolock>
ffffffffc0209fa2:	dd0d                	beqz	a0,ffffffffc0209edc <sfs_io_nolock+0xa8>
ffffffffc0209fa4:	4981                	li	s3,0
ffffffffc0209fa6:	b751                	j	ffffffffc0209f2a <sfs_io_nolock+0xf6>
ffffffffc0209fa8:	8abe                	mv	s5,a5
ffffffffc0209faa:	00001797          	auipc	a5,0x1
ffffffffc0209fae:	d7278793          	addi	a5,a5,-654 # ffffffffc020ad1c <sfs_rbuf>
ffffffffc0209fb2:	00001d17          	auipc	s10,0x1
ffffffffc0209fb6:	caad0d13          	addi	s10,s10,-854 # ffffffffc020ac5c <sfs_rblock>
ffffffffc0209fba:	e03e                	sd	a5,0(sp)
ffffffffc0209fbc:	b5dd                	j	ffffffffc0209ea2 <sfs_io_nolock+0x6e>
ffffffffc0209fbe:	8bee                	mv	s7,s11
ffffffffc0209fc0:	1ad2                	slli	s5,s5,0x34
ffffffffc0209fc2:	034adb13          	srli	s6,s5,0x34
ffffffffc0209fc6:	4501                	li	a0,0
ffffffffc0209fc8:	f60a81e3          	beqz	s5,ffffffffc0209f2a <sfs_io_nolock+0xf6>
ffffffffc0209fcc:	0874                	addi	a3,sp,28
ffffffffc0209fce:	865e                	mv	a2,s7
ffffffffc0209fd0:	85d2                	mv	a1,s4
ffffffffc0209fd2:	8526                	mv	a0,s1
ffffffffc0209fd4:	c09ff0ef          	jal	ra,ffffffffc0209bdc <sfs_bmap_load_nolock>
ffffffffc0209fd8:	f929                	bnez	a0,ffffffffc0209f2a <sfs_io_nolock+0xf6>
ffffffffc0209fda:	46f2                	lw	a3,28(sp)
ffffffffc0209fdc:	6782                	ld	a5,0(sp)
ffffffffc0209fde:	4701                	li	a4,0
ffffffffc0209fe0:	865a                	mv	a2,s6
ffffffffc0209fe2:	85a2                	mv	a1,s0
ffffffffc0209fe4:	8526                	mv	a0,s1
ffffffffc0209fe6:	9782                	jalr	a5
ffffffffc0209fe8:	f129                	bnez	a0,ffffffffc0209f2a <sfs_io_nolock+0xf6>
ffffffffc0209fea:	99da                	add	s3,s3,s6
ffffffffc0209fec:	bf3d                	j	ffffffffc0209f2a <sfs_io_nolock+0xf6>
ffffffffc0209fee:	5575                	li	a0,-3
ffffffffc0209ff0:	b785                	j	ffffffffc0209f50 <sfs_io_nolock+0x11c>
ffffffffc0209ff2:	00005697          	auipc	a3,0x5
ffffffffc0209ff6:	07668693          	addi	a3,a3,118 # ffffffffc020f068 <dev_node_ops+0x730>
ffffffffc0209ffa:	00002617          	auipc	a2,0x2
ffffffffc0209ffe:	98e60613          	addi	a2,a2,-1650 # ffffffffc020b988 <commands+0x210>
ffffffffc020a002:	22b00593          	li	a1,555
ffffffffc020a006:	00005517          	auipc	a0,0x5
ffffffffc020a00a:	ef250513          	addi	a0,a0,-270 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a00e:	c90f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a012 <sfs_read>:
ffffffffc020a012:	7139                	addi	sp,sp,-64
ffffffffc020a014:	f04a                	sd	s2,32(sp)
ffffffffc020a016:	06853903          	ld	s2,104(a0)
ffffffffc020a01a:	fc06                	sd	ra,56(sp)
ffffffffc020a01c:	f822                	sd	s0,48(sp)
ffffffffc020a01e:	f426                	sd	s1,40(sp)
ffffffffc020a020:	ec4e                	sd	s3,24(sp)
ffffffffc020a022:	04090f63          	beqz	s2,ffffffffc020a080 <sfs_read+0x6e>
ffffffffc020a026:	0b092783          	lw	a5,176(s2)
ffffffffc020a02a:	ebb9                	bnez	a5,ffffffffc020a080 <sfs_read+0x6e>
ffffffffc020a02c:	4d38                	lw	a4,88(a0)
ffffffffc020a02e:	6785                	lui	a5,0x1
ffffffffc020a030:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a034:	842a                	mv	s0,a0
ffffffffc020a036:	06f71563          	bne	a4,a5,ffffffffc020a0a0 <sfs_read+0x8e>
ffffffffc020a03a:	02050993          	addi	s3,a0,32
ffffffffc020a03e:	854e                	mv	a0,s3
ffffffffc020a040:	84ae                	mv	s1,a1
ffffffffc020a042:	d22fa0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020a046:	0184b803          	ld	a6,24(s1)
ffffffffc020a04a:	6494                	ld	a3,8(s1)
ffffffffc020a04c:	6090                	ld	a2,0(s1)
ffffffffc020a04e:	85a2                	mv	a1,s0
ffffffffc020a050:	4781                	li	a5,0
ffffffffc020a052:	0038                	addi	a4,sp,8
ffffffffc020a054:	854a                	mv	a0,s2
ffffffffc020a056:	e442                	sd	a6,8(sp)
ffffffffc020a058:	dddff0ef          	jal	ra,ffffffffc0209e34 <sfs_io_nolock>
ffffffffc020a05c:	65a2                	ld	a1,8(sp)
ffffffffc020a05e:	842a                	mv	s0,a0
ffffffffc020a060:	ed81                	bnez	a1,ffffffffc020a078 <sfs_read+0x66>
ffffffffc020a062:	854e                	mv	a0,s3
ffffffffc020a064:	cfcfa0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020a068:	70e2                	ld	ra,56(sp)
ffffffffc020a06a:	8522                	mv	a0,s0
ffffffffc020a06c:	7442                	ld	s0,48(sp)
ffffffffc020a06e:	74a2                	ld	s1,40(sp)
ffffffffc020a070:	7902                	ld	s2,32(sp)
ffffffffc020a072:	69e2                	ld	s3,24(sp)
ffffffffc020a074:	6121                	addi	sp,sp,64
ffffffffc020a076:	8082                	ret
ffffffffc020a078:	8526                	mv	a0,s1
ffffffffc020a07a:	bdefb0ef          	jal	ra,ffffffffc0205458 <iobuf_skip>
ffffffffc020a07e:	b7d5                	j	ffffffffc020a062 <sfs_read+0x50>
ffffffffc020a080:	00005697          	auipc	a3,0x5
ffffffffc020a084:	c9868693          	addi	a3,a3,-872 # ffffffffc020ed18 <dev_node_ops+0x3e0>
ffffffffc020a088:	00002617          	auipc	a2,0x2
ffffffffc020a08c:	90060613          	addi	a2,a2,-1792 # ffffffffc020b988 <commands+0x210>
ffffffffc020a090:	29500593          	li	a1,661
ffffffffc020a094:	00005517          	auipc	a0,0x5
ffffffffc020a098:	e6450513          	addi	a0,a0,-412 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a09c:	c02f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a0a0:	85fff0ef          	jal	ra,ffffffffc02098fe <sfs_io.part.0>

ffffffffc020a0a4 <sfs_write>:
ffffffffc020a0a4:	7139                	addi	sp,sp,-64
ffffffffc020a0a6:	f04a                	sd	s2,32(sp)
ffffffffc020a0a8:	06853903          	ld	s2,104(a0)
ffffffffc020a0ac:	fc06                	sd	ra,56(sp)
ffffffffc020a0ae:	f822                	sd	s0,48(sp)
ffffffffc020a0b0:	f426                	sd	s1,40(sp)
ffffffffc020a0b2:	ec4e                	sd	s3,24(sp)
ffffffffc020a0b4:	04090f63          	beqz	s2,ffffffffc020a112 <sfs_write+0x6e>
ffffffffc020a0b8:	0b092783          	lw	a5,176(s2)
ffffffffc020a0bc:	ebb9                	bnez	a5,ffffffffc020a112 <sfs_write+0x6e>
ffffffffc020a0be:	4d38                	lw	a4,88(a0)
ffffffffc020a0c0:	6785                	lui	a5,0x1
ffffffffc020a0c2:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a0c6:	842a                	mv	s0,a0
ffffffffc020a0c8:	06f71563          	bne	a4,a5,ffffffffc020a132 <sfs_write+0x8e>
ffffffffc020a0cc:	02050993          	addi	s3,a0,32
ffffffffc020a0d0:	854e                	mv	a0,s3
ffffffffc020a0d2:	84ae                	mv	s1,a1
ffffffffc020a0d4:	c90fa0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020a0d8:	0184b803          	ld	a6,24(s1)
ffffffffc020a0dc:	6494                	ld	a3,8(s1)
ffffffffc020a0de:	6090                	ld	a2,0(s1)
ffffffffc020a0e0:	85a2                	mv	a1,s0
ffffffffc020a0e2:	4785                	li	a5,1
ffffffffc020a0e4:	0038                	addi	a4,sp,8
ffffffffc020a0e6:	854a                	mv	a0,s2
ffffffffc020a0e8:	e442                	sd	a6,8(sp)
ffffffffc020a0ea:	d4bff0ef          	jal	ra,ffffffffc0209e34 <sfs_io_nolock>
ffffffffc020a0ee:	65a2                	ld	a1,8(sp)
ffffffffc020a0f0:	842a                	mv	s0,a0
ffffffffc020a0f2:	ed81                	bnez	a1,ffffffffc020a10a <sfs_write+0x66>
ffffffffc020a0f4:	854e                	mv	a0,s3
ffffffffc020a0f6:	c6afa0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020a0fa:	70e2                	ld	ra,56(sp)
ffffffffc020a0fc:	8522                	mv	a0,s0
ffffffffc020a0fe:	7442                	ld	s0,48(sp)
ffffffffc020a100:	74a2                	ld	s1,40(sp)
ffffffffc020a102:	7902                	ld	s2,32(sp)
ffffffffc020a104:	69e2                	ld	s3,24(sp)
ffffffffc020a106:	6121                	addi	sp,sp,64
ffffffffc020a108:	8082                	ret
ffffffffc020a10a:	8526                	mv	a0,s1
ffffffffc020a10c:	b4cfb0ef          	jal	ra,ffffffffc0205458 <iobuf_skip>
ffffffffc020a110:	b7d5                	j	ffffffffc020a0f4 <sfs_write+0x50>
ffffffffc020a112:	00005697          	auipc	a3,0x5
ffffffffc020a116:	c0668693          	addi	a3,a3,-1018 # ffffffffc020ed18 <dev_node_ops+0x3e0>
ffffffffc020a11a:	00002617          	auipc	a2,0x2
ffffffffc020a11e:	86e60613          	addi	a2,a2,-1938 # ffffffffc020b988 <commands+0x210>
ffffffffc020a122:	29500593          	li	a1,661
ffffffffc020a126:	00005517          	auipc	a0,0x5
ffffffffc020a12a:	dd250513          	addi	a0,a0,-558 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a12e:	b70f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a132:	fccff0ef          	jal	ra,ffffffffc02098fe <sfs_io.part.0>

ffffffffc020a136 <sfs_dirent_read_nolock>:
ffffffffc020a136:	6198                	ld	a4,0(a1)
ffffffffc020a138:	7179                	addi	sp,sp,-48
ffffffffc020a13a:	f406                	sd	ra,40(sp)
ffffffffc020a13c:	00475883          	lhu	a7,4(a4)
ffffffffc020a140:	f022                	sd	s0,32(sp)
ffffffffc020a142:	ec26                	sd	s1,24(sp)
ffffffffc020a144:	4809                	li	a6,2
ffffffffc020a146:	05089b63          	bne	a7,a6,ffffffffc020a19c <sfs_dirent_read_nolock+0x66>
ffffffffc020a14a:	4718                	lw	a4,8(a4)
ffffffffc020a14c:	87b2                	mv	a5,a2
ffffffffc020a14e:	2601                	sext.w	a2,a2
ffffffffc020a150:	04e7f663          	bgeu	a5,a4,ffffffffc020a19c <sfs_dirent_read_nolock+0x66>
ffffffffc020a154:	84b6                	mv	s1,a3
ffffffffc020a156:	0074                	addi	a3,sp,12
ffffffffc020a158:	842a                	mv	s0,a0
ffffffffc020a15a:	a83ff0ef          	jal	ra,ffffffffc0209bdc <sfs_bmap_load_nolock>
ffffffffc020a15e:	c511                	beqz	a0,ffffffffc020a16a <sfs_dirent_read_nolock+0x34>
ffffffffc020a160:	70a2                	ld	ra,40(sp)
ffffffffc020a162:	7402                	ld	s0,32(sp)
ffffffffc020a164:	64e2                	ld	s1,24(sp)
ffffffffc020a166:	6145                	addi	sp,sp,48
ffffffffc020a168:	8082                	ret
ffffffffc020a16a:	45b2                	lw	a1,12(sp)
ffffffffc020a16c:	4054                	lw	a3,4(s0)
ffffffffc020a16e:	c5b9                	beqz	a1,ffffffffc020a1bc <sfs_dirent_read_nolock+0x86>
ffffffffc020a170:	04d5f663          	bgeu	a1,a3,ffffffffc020a1bc <sfs_dirent_read_nolock+0x86>
ffffffffc020a174:	7c08                	ld	a0,56(s0)
ffffffffc020a176:	e9ffe0ef          	jal	ra,ffffffffc0209014 <bitmap_test>
ffffffffc020a17a:	ed31                	bnez	a0,ffffffffc020a1d6 <sfs_dirent_read_nolock+0xa0>
ffffffffc020a17c:	46b2                	lw	a3,12(sp)
ffffffffc020a17e:	4701                	li	a4,0
ffffffffc020a180:	10400613          	li	a2,260
ffffffffc020a184:	85a6                	mv	a1,s1
ffffffffc020a186:	8522                	mv	a0,s0
ffffffffc020a188:	395000ef          	jal	ra,ffffffffc020ad1c <sfs_rbuf>
ffffffffc020a18c:	f971                	bnez	a0,ffffffffc020a160 <sfs_dirent_read_nolock+0x2a>
ffffffffc020a18e:	100481a3          	sb	zero,259(s1)
ffffffffc020a192:	70a2                	ld	ra,40(sp)
ffffffffc020a194:	7402                	ld	s0,32(sp)
ffffffffc020a196:	64e2                	ld	s1,24(sp)
ffffffffc020a198:	6145                	addi	sp,sp,48
ffffffffc020a19a:	8082                	ret
ffffffffc020a19c:	00005697          	auipc	a3,0x5
ffffffffc020a1a0:	eec68693          	addi	a3,a3,-276 # ffffffffc020f088 <dev_node_ops+0x750>
ffffffffc020a1a4:	00001617          	auipc	a2,0x1
ffffffffc020a1a8:	7e460613          	addi	a2,a2,2020 # ffffffffc020b988 <commands+0x210>
ffffffffc020a1ac:	18e00593          	li	a1,398
ffffffffc020a1b0:	00005517          	auipc	a0,0x5
ffffffffc020a1b4:	d4850513          	addi	a0,a0,-696 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a1b8:	ae6f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a1bc:	872e                	mv	a4,a1
ffffffffc020a1be:	00005617          	auipc	a2,0x5
ffffffffc020a1c2:	d6a60613          	addi	a2,a2,-662 # ffffffffc020ef28 <dev_node_ops+0x5f0>
ffffffffc020a1c6:	05300593          	li	a1,83
ffffffffc020a1ca:	00005517          	auipc	a0,0x5
ffffffffc020a1ce:	d2e50513          	addi	a0,a0,-722 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a1d2:	accf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a1d6:	00005697          	auipc	a3,0x5
ffffffffc020a1da:	d8a68693          	addi	a3,a3,-630 # ffffffffc020ef60 <dev_node_ops+0x628>
ffffffffc020a1de:	00001617          	auipc	a2,0x1
ffffffffc020a1e2:	7aa60613          	addi	a2,a2,1962 # ffffffffc020b988 <commands+0x210>
ffffffffc020a1e6:	19500593          	li	a1,405
ffffffffc020a1ea:	00005517          	auipc	a0,0x5
ffffffffc020a1ee:	d0e50513          	addi	a0,a0,-754 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a1f2:	aacf60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a1f6 <sfs_getdirentry>:
ffffffffc020a1f6:	715d                	addi	sp,sp,-80
ffffffffc020a1f8:	ec56                	sd	s5,24(sp)
ffffffffc020a1fa:	8aaa                	mv	s5,a0
ffffffffc020a1fc:	10400513          	li	a0,260
ffffffffc020a200:	e85a                	sd	s6,16(sp)
ffffffffc020a202:	e486                	sd	ra,72(sp)
ffffffffc020a204:	e0a2                	sd	s0,64(sp)
ffffffffc020a206:	fc26                	sd	s1,56(sp)
ffffffffc020a208:	f84a                	sd	s2,48(sp)
ffffffffc020a20a:	f44e                	sd	s3,40(sp)
ffffffffc020a20c:	f052                	sd	s4,32(sp)
ffffffffc020a20e:	e45e                	sd	s7,8(sp)
ffffffffc020a210:	e062                	sd	s8,0(sp)
ffffffffc020a212:	8b2e                	mv	s6,a1
ffffffffc020a214:	d7bf70ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020a218:	cd61                	beqz	a0,ffffffffc020a2f0 <sfs_getdirentry+0xfa>
ffffffffc020a21a:	068abb83          	ld	s7,104(s5) # 8000068 <_binary_bin_sfs_img_size+0x7f8ad68>
ffffffffc020a21e:	0c0b8b63          	beqz	s7,ffffffffc020a2f4 <sfs_getdirentry+0xfe>
ffffffffc020a222:	0b0ba783          	lw	a5,176(s7) # 10b0 <_binary_bin_swap_img_size-0x6c50>
ffffffffc020a226:	e7f9                	bnez	a5,ffffffffc020a2f4 <sfs_getdirentry+0xfe>
ffffffffc020a228:	058aa703          	lw	a4,88(s5)
ffffffffc020a22c:	6785                	lui	a5,0x1
ffffffffc020a22e:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a232:	0ef71163          	bne	a4,a5,ffffffffc020a314 <sfs_getdirentry+0x11e>
ffffffffc020a236:	008b3983          	ld	s3,8(s6) # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc020a23a:	892a                	mv	s2,a0
ffffffffc020a23c:	0a09c163          	bltz	s3,ffffffffc020a2de <sfs_getdirentry+0xe8>
ffffffffc020a240:	0ff9f793          	zext.b	a5,s3
ffffffffc020a244:	efc9                	bnez	a5,ffffffffc020a2de <sfs_getdirentry+0xe8>
ffffffffc020a246:	000ab783          	ld	a5,0(s5)
ffffffffc020a24a:	0089d993          	srli	s3,s3,0x8
ffffffffc020a24e:	2981                	sext.w	s3,s3
ffffffffc020a250:	479c                	lw	a5,8(a5)
ffffffffc020a252:	0937eb63          	bltu	a5,s3,ffffffffc020a2e8 <sfs_getdirentry+0xf2>
ffffffffc020a256:	020a8c13          	addi	s8,s5,32
ffffffffc020a25a:	8562                	mv	a0,s8
ffffffffc020a25c:	b08fa0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020a260:	000ab783          	ld	a5,0(s5)
ffffffffc020a264:	0087aa03          	lw	s4,8(a5)
ffffffffc020a268:	07405663          	blez	s4,ffffffffc020a2d4 <sfs_getdirentry+0xde>
ffffffffc020a26c:	4481                	li	s1,0
ffffffffc020a26e:	a811                	j	ffffffffc020a282 <sfs_getdirentry+0x8c>
ffffffffc020a270:	00092783          	lw	a5,0(s2)
ffffffffc020a274:	c781                	beqz	a5,ffffffffc020a27c <sfs_getdirentry+0x86>
ffffffffc020a276:	02098263          	beqz	s3,ffffffffc020a29a <sfs_getdirentry+0xa4>
ffffffffc020a27a:	39fd                	addiw	s3,s3,-1
ffffffffc020a27c:	2485                	addiw	s1,s1,1
ffffffffc020a27e:	049a0b63          	beq	s4,s1,ffffffffc020a2d4 <sfs_getdirentry+0xde>
ffffffffc020a282:	86ca                	mv	a3,s2
ffffffffc020a284:	8626                	mv	a2,s1
ffffffffc020a286:	85d6                	mv	a1,s5
ffffffffc020a288:	855e                	mv	a0,s7
ffffffffc020a28a:	eadff0ef          	jal	ra,ffffffffc020a136 <sfs_dirent_read_nolock>
ffffffffc020a28e:	842a                	mv	s0,a0
ffffffffc020a290:	d165                	beqz	a0,ffffffffc020a270 <sfs_getdirentry+0x7a>
ffffffffc020a292:	8562                	mv	a0,s8
ffffffffc020a294:	accfa0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020a298:	a831                	j	ffffffffc020a2b4 <sfs_getdirentry+0xbe>
ffffffffc020a29a:	8562                	mv	a0,s8
ffffffffc020a29c:	ac4fa0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020a2a0:	4701                	li	a4,0
ffffffffc020a2a2:	4685                	li	a3,1
ffffffffc020a2a4:	10000613          	li	a2,256
ffffffffc020a2a8:	00490593          	addi	a1,s2,4
ffffffffc020a2ac:	855a                	mv	a0,s6
ffffffffc020a2ae:	93efb0ef          	jal	ra,ffffffffc02053ec <iobuf_move>
ffffffffc020a2b2:	842a                	mv	s0,a0
ffffffffc020a2b4:	854a                	mv	a0,s2
ffffffffc020a2b6:	d89f70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a2ba:	60a6                	ld	ra,72(sp)
ffffffffc020a2bc:	8522                	mv	a0,s0
ffffffffc020a2be:	6406                	ld	s0,64(sp)
ffffffffc020a2c0:	74e2                	ld	s1,56(sp)
ffffffffc020a2c2:	7942                	ld	s2,48(sp)
ffffffffc020a2c4:	79a2                	ld	s3,40(sp)
ffffffffc020a2c6:	7a02                	ld	s4,32(sp)
ffffffffc020a2c8:	6ae2                	ld	s5,24(sp)
ffffffffc020a2ca:	6b42                	ld	s6,16(sp)
ffffffffc020a2cc:	6ba2                	ld	s7,8(sp)
ffffffffc020a2ce:	6c02                	ld	s8,0(sp)
ffffffffc020a2d0:	6161                	addi	sp,sp,80
ffffffffc020a2d2:	8082                	ret
ffffffffc020a2d4:	8562                	mv	a0,s8
ffffffffc020a2d6:	5441                	li	s0,-16
ffffffffc020a2d8:	a88fa0ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020a2dc:	bfe1                	j	ffffffffc020a2b4 <sfs_getdirentry+0xbe>
ffffffffc020a2de:	854a                	mv	a0,s2
ffffffffc020a2e0:	d5ff70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a2e4:	5475                	li	s0,-3
ffffffffc020a2e6:	bfd1                	j	ffffffffc020a2ba <sfs_getdirentry+0xc4>
ffffffffc020a2e8:	d57f70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a2ec:	5441                	li	s0,-16
ffffffffc020a2ee:	b7f1                	j	ffffffffc020a2ba <sfs_getdirentry+0xc4>
ffffffffc020a2f0:	5471                	li	s0,-4
ffffffffc020a2f2:	b7e1                	j	ffffffffc020a2ba <sfs_getdirentry+0xc4>
ffffffffc020a2f4:	00005697          	auipc	a3,0x5
ffffffffc020a2f8:	a2468693          	addi	a3,a3,-1500 # ffffffffc020ed18 <dev_node_ops+0x3e0>
ffffffffc020a2fc:	00001617          	auipc	a2,0x1
ffffffffc020a300:	68c60613          	addi	a2,a2,1676 # ffffffffc020b988 <commands+0x210>
ffffffffc020a304:	33900593          	li	a1,825
ffffffffc020a308:	00005517          	auipc	a0,0x5
ffffffffc020a30c:	bf050513          	addi	a0,a0,-1040 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a310:	98ef60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a314:	00005697          	auipc	a3,0x5
ffffffffc020a318:	bac68693          	addi	a3,a3,-1108 # ffffffffc020eec0 <dev_node_ops+0x588>
ffffffffc020a31c:	00001617          	auipc	a2,0x1
ffffffffc020a320:	66c60613          	addi	a2,a2,1644 # ffffffffc020b988 <commands+0x210>
ffffffffc020a324:	33a00593          	li	a1,826
ffffffffc020a328:	00005517          	auipc	a0,0x5
ffffffffc020a32c:	bd050513          	addi	a0,a0,-1072 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a330:	96ef60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a334 <sfs_dirent_search_nolock.constprop.0>:
ffffffffc020a334:	715d                	addi	sp,sp,-80
ffffffffc020a336:	f052                	sd	s4,32(sp)
ffffffffc020a338:	8a2a                	mv	s4,a0
ffffffffc020a33a:	8532                	mv	a0,a2
ffffffffc020a33c:	f44e                	sd	s3,40(sp)
ffffffffc020a33e:	e85a                	sd	s6,16(sp)
ffffffffc020a340:	e45e                	sd	s7,8(sp)
ffffffffc020a342:	e486                	sd	ra,72(sp)
ffffffffc020a344:	e0a2                	sd	s0,64(sp)
ffffffffc020a346:	fc26                	sd	s1,56(sp)
ffffffffc020a348:	f84a                	sd	s2,48(sp)
ffffffffc020a34a:	ec56                	sd	s5,24(sp)
ffffffffc020a34c:	e062                	sd	s8,0(sp)
ffffffffc020a34e:	8b32                	mv	s6,a2
ffffffffc020a350:	89ae                	mv	s3,a1
ffffffffc020a352:	8bb6                	mv	s7,a3
ffffffffc020a354:	0aa010ef          	jal	ra,ffffffffc020b3fe <strlen>
ffffffffc020a358:	0ff00793          	li	a5,255
ffffffffc020a35c:	06a7ef63          	bltu	a5,a0,ffffffffc020a3da <sfs_dirent_search_nolock.constprop.0+0xa6>
ffffffffc020a360:	10400513          	li	a0,260
ffffffffc020a364:	c2bf70ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020a368:	892a                	mv	s2,a0
ffffffffc020a36a:	c535                	beqz	a0,ffffffffc020a3d6 <sfs_dirent_search_nolock.constprop.0+0xa2>
ffffffffc020a36c:	0009b783          	ld	a5,0(s3)
ffffffffc020a370:	0087aa83          	lw	s5,8(a5)
ffffffffc020a374:	05505a63          	blez	s5,ffffffffc020a3c8 <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc020a378:	4481                	li	s1,0
ffffffffc020a37a:	00450c13          	addi	s8,a0,4
ffffffffc020a37e:	a829                	j	ffffffffc020a398 <sfs_dirent_search_nolock.constprop.0+0x64>
ffffffffc020a380:	00092783          	lw	a5,0(s2)
ffffffffc020a384:	c799                	beqz	a5,ffffffffc020a392 <sfs_dirent_search_nolock.constprop.0+0x5e>
ffffffffc020a386:	85e2                	mv	a1,s8
ffffffffc020a388:	855a                	mv	a0,s6
ffffffffc020a38a:	0bc010ef          	jal	ra,ffffffffc020b446 <strcmp>
ffffffffc020a38e:	842a                	mv	s0,a0
ffffffffc020a390:	cd15                	beqz	a0,ffffffffc020a3cc <sfs_dirent_search_nolock.constprop.0+0x98>
ffffffffc020a392:	2485                	addiw	s1,s1,1
ffffffffc020a394:	029a8a63          	beq	s5,s1,ffffffffc020a3c8 <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc020a398:	86ca                	mv	a3,s2
ffffffffc020a39a:	8626                	mv	a2,s1
ffffffffc020a39c:	85ce                	mv	a1,s3
ffffffffc020a39e:	8552                	mv	a0,s4
ffffffffc020a3a0:	d97ff0ef          	jal	ra,ffffffffc020a136 <sfs_dirent_read_nolock>
ffffffffc020a3a4:	842a                	mv	s0,a0
ffffffffc020a3a6:	dd69                	beqz	a0,ffffffffc020a380 <sfs_dirent_search_nolock.constprop.0+0x4c>
ffffffffc020a3a8:	854a                	mv	a0,s2
ffffffffc020a3aa:	c95f70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a3ae:	60a6                	ld	ra,72(sp)
ffffffffc020a3b0:	8522                	mv	a0,s0
ffffffffc020a3b2:	6406                	ld	s0,64(sp)
ffffffffc020a3b4:	74e2                	ld	s1,56(sp)
ffffffffc020a3b6:	7942                	ld	s2,48(sp)
ffffffffc020a3b8:	79a2                	ld	s3,40(sp)
ffffffffc020a3ba:	7a02                	ld	s4,32(sp)
ffffffffc020a3bc:	6ae2                	ld	s5,24(sp)
ffffffffc020a3be:	6b42                	ld	s6,16(sp)
ffffffffc020a3c0:	6ba2                	ld	s7,8(sp)
ffffffffc020a3c2:	6c02                	ld	s8,0(sp)
ffffffffc020a3c4:	6161                	addi	sp,sp,80
ffffffffc020a3c6:	8082                	ret
ffffffffc020a3c8:	5441                	li	s0,-16
ffffffffc020a3ca:	bff9                	j	ffffffffc020a3a8 <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc020a3cc:	00092783          	lw	a5,0(s2)
ffffffffc020a3d0:	00fba023          	sw	a5,0(s7)
ffffffffc020a3d4:	bfd1                	j	ffffffffc020a3a8 <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc020a3d6:	5471                	li	s0,-4
ffffffffc020a3d8:	bfd9                	j	ffffffffc020a3ae <sfs_dirent_search_nolock.constprop.0+0x7a>
ffffffffc020a3da:	00005697          	auipc	a3,0x5
ffffffffc020a3de:	cfe68693          	addi	a3,a3,-770 # ffffffffc020f0d8 <dev_node_ops+0x7a0>
ffffffffc020a3e2:	00001617          	auipc	a2,0x1
ffffffffc020a3e6:	5a660613          	addi	a2,a2,1446 # ffffffffc020b988 <commands+0x210>
ffffffffc020a3ea:	1ba00593          	li	a1,442
ffffffffc020a3ee:	00005517          	auipc	a0,0x5
ffffffffc020a3f2:	b0a50513          	addi	a0,a0,-1270 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a3f6:	8a8f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a3fa <sfs_truncfile>:
ffffffffc020a3fa:	7175                	addi	sp,sp,-144
ffffffffc020a3fc:	e506                	sd	ra,136(sp)
ffffffffc020a3fe:	e122                	sd	s0,128(sp)
ffffffffc020a400:	fca6                	sd	s1,120(sp)
ffffffffc020a402:	f8ca                	sd	s2,112(sp)
ffffffffc020a404:	f4ce                	sd	s3,104(sp)
ffffffffc020a406:	f0d2                	sd	s4,96(sp)
ffffffffc020a408:	ecd6                	sd	s5,88(sp)
ffffffffc020a40a:	e8da                	sd	s6,80(sp)
ffffffffc020a40c:	e4de                	sd	s7,72(sp)
ffffffffc020a40e:	e0e2                	sd	s8,64(sp)
ffffffffc020a410:	fc66                	sd	s9,56(sp)
ffffffffc020a412:	f86a                	sd	s10,48(sp)
ffffffffc020a414:	f46e                	sd	s11,40(sp)
ffffffffc020a416:	080007b7          	lui	a5,0x8000
ffffffffc020a41a:	16b7e463          	bltu	a5,a1,ffffffffc020a582 <sfs_truncfile+0x188>
ffffffffc020a41e:	06853c83          	ld	s9,104(a0)
ffffffffc020a422:	89aa                	mv	s3,a0
ffffffffc020a424:	160c8163          	beqz	s9,ffffffffc020a586 <sfs_truncfile+0x18c>
ffffffffc020a428:	0b0ca783          	lw	a5,176(s9) # 10b0 <_binary_bin_swap_img_size-0x6c50>
ffffffffc020a42c:	14079d63          	bnez	a5,ffffffffc020a586 <sfs_truncfile+0x18c>
ffffffffc020a430:	4d38                	lw	a4,88(a0)
ffffffffc020a432:	6405                	lui	s0,0x1
ffffffffc020a434:	23540793          	addi	a5,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a438:	16f71763          	bne	a4,a5,ffffffffc020a5a6 <sfs_truncfile+0x1ac>
ffffffffc020a43c:	00053a83          	ld	s5,0(a0)
ffffffffc020a440:	147d                	addi	s0,s0,-1
ffffffffc020a442:	942e                	add	s0,s0,a1
ffffffffc020a444:	000ae783          	lwu	a5,0(s5)
ffffffffc020a448:	8031                	srli	s0,s0,0xc
ffffffffc020a44a:	8a2e                	mv	s4,a1
ffffffffc020a44c:	2401                	sext.w	s0,s0
ffffffffc020a44e:	02b79763          	bne	a5,a1,ffffffffc020a47c <sfs_truncfile+0x82>
ffffffffc020a452:	008aa783          	lw	a5,8(s5)
ffffffffc020a456:	4901                	li	s2,0
ffffffffc020a458:	18879763          	bne	a5,s0,ffffffffc020a5e6 <sfs_truncfile+0x1ec>
ffffffffc020a45c:	60aa                	ld	ra,136(sp)
ffffffffc020a45e:	640a                	ld	s0,128(sp)
ffffffffc020a460:	74e6                	ld	s1,120(sp)
ffffffffc020a462:	79a6                	ld	s3,104(sp)
ffffffffc020a464:	7a06                	ld	s4,96(sp)
ffffffffc020a466:	6ae6                	ld	s5,88(sp)
ffffffffc020a468:	6b46                	ld	s6,80(sp)
ffffffffc020a46a:	6ba6                	ld	s7,72(sp)
ffffffffc020a46c:	6c06                	ld	s8,64(sp)
ffffffffc020a46e:	7ce2                	ld	s9,56(sp)
ffffffffc020a470:	7d42                	ld	s10,48(sp)
ffffffffc020a472:	7da2                	ld	s11,40(sp)
ffffffffc020a474:	854a                	mv	a0,s2
ffffffffc020a476:	7946                	ld	s2,112(sp)
ffffffffc020a478:	6149                	addi	sp,sp,144
ffffffffc020a47a:	8082                	ret
ffffffffc020a47c:	02050b13          	addi	s6,a0,32
ffffffffc020a480:	855a                	mv	a0,s6
ffffffffc020a482:	8e2fa0ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020a486:	008aa483          	lw	s1,8(s5)
ffffffffc020a48a:	0a84e663          	bltu	s1,s0,ffffffffc020a536 <sfs_truncfile+0x13c>
ffffffffc020a48e:	0c947163          	bgeu	s0,s1,ffffffffc020a550 <sfs_truncfile+0x156>
ffffffffc020a492:	4dad                	li	s11,11
ffffffffc020a494:	4b85                	li	s7,1
ffffffffc020a496:	a09d                	j	ffffffffc020a4fc <sfs_truncfile+0x102>
ffffffffc020a498:	ff37091b          	addiw	s2,a4,-13
ffffffffc020a49c:	0009079b          	sext.w	a5,s2
ffffffffc020a4a0:	3ff00713          	li	a4,1023
ffffffffc020a4a4:	04f76563          	bltu	a4,a5,ffffffffc020a4ee <sfs_truncfile+0xf4>
ffffffffc020a4a8:	03cd2c03          	lw	s8,60(s10)
ffffffffc020a4ac:	040c0163          	beqz	s8,ffffffffc020a4ee <sfs_truncfile+0xf4>
ffffffffc020a4b0:	004ca783          	lw	a5,4(s9)
ffffffffc020a4b4:	18fc7963          	bgeu	s8,a5,ffffffffc020a646 <sfs_truncfile+0x24c>
ffffffffc020a4b8:	038cb503          	ld	a0,56(s9)
ffffffffc020a4bc:	85e2                	mv	a1,s8
ffffffffc020a4be:	b57fe0ef          	jal	ra,ffffffffc0209014 <bitmap_test>
ffffffffc020a4c2:	16051263          	bnez	a0,ffffffffc020a626 <sfs_truncfile+0x22c>
ffffffffc020a4c6:	02091793          	slli	a5,s2,0x20
ffffffffc020a4ca:	01e7d713          	srli	a4,a5,0x1e
ffffffffc020a4ce:	86e2                	mv	a3,s8
ffffffffc020a4d0:	4611                	li	a2,4
ffffffffc020a4d2:	082c                	addi	a1,sp,24
ffffffffc020a4d4:	8566                	mv	a0,s9
ffffffffc020a4d6:	e43a                	sd	a4,8(sp)
ffffffffc020a4d8:	ce02                	sw	zero,28(sp)
ffffffffc020a4da:	043000ef          	jal	ra,ffffffffc020ad1c <sfs_rbuf>
ffffffffc020a4de:	892a                	mv	s2,a0
ffffffffc020a4e0:	e141                	bnez	a0,ffffffffc020a560 <sfs_truncfile+0x166>
ffffffffc020a4e2:	47e2                	lw	a5,24(sp)
ffffffffc020a4e4:	6722                	ld	a4,8(sp)
ffffffffc020a4e6:	e3c9                	bnez	a5,ffffffffc020a568 <sfs_truncfile+0x16e>
ffffffffc020a4e8:	008d2603          	lw	a2,8(s10)
ffffffffc020a4ec:	367d                	addiw	a2,a2,-1
ffffffffc020a4ee:	00cd2423          	sw	a2,8(s10)
ffffffffc020a4f2:	0179b823          	sd	s7,16(s3)
ffffffffc020a4f6:	34fd                	addiw	s1,s1,-1
ffffffffc020a4f8:	04940a63          	beq	s0,s1,ffffffffc020a54c <sfs_truncfile+0x152>
ffffffffc020a4fc:	0009bd03          	ld	s10,0(s3)
ffffffffc020a500:	008d2703          	lw	a4,8(s10)
ffffffffc020a504:	c369                	beqz	a4,ffffffffc020a5c6 <sfs_truncfile+0x1cc>
ffffffffc020a506:	fff7079b          	addiw	a5,a4,-1
ffffffffc020a50a:	0007861b          	sext.w	a2,a5
ffffffffc020a50e:	f8cde5e3          	bltu	s11,a2,ffffffffc020a498 <sfs_truncfile+0x9e>
ffffffffc020a512:	02079713          	slli	a4,a5,0x20
ffffffffc020a516:	01e75793          	srli	a5,a4,0x1e
ffffffffc020a51a:	00fd0933          	add	s2,s10,a5
ffffffffc020a51e:	00c92583          	lw	a1,12(s2)
ffffffffc020a522:	d5f1                	beqz	a1,ffffffffc020a4ee <sfs_truncfile+0xf4>
ffffffffc020a524:	8566                	mv	a0,s9
ffffffffc020a526:	bfcff0ef          	jal	ra,ffffffffc0209922 <sfs_block_free>
ffffffffc020a52a:	00092623          	sw	zero,12(s2)
ffffffffc020a52e:	008d2603          	lw	a2,8(s10)
ffffffffc020a532:	367d                	addiw	a2,a2,-1
ffffffffc020a534:	bf6d                	j	ffffffffc020a4ee <sfs_truncfile+0xf4>
ffffffffc020a536:	4681                	li	a3,0
ffffffffc020a538:	8626                	mv	a2,s1
ffffffffc020a53a:	85ce                	mv	a1,s3
ffffffffc020a53c:	8566                	mv	a0,s9
ffffffffc020a53e:	e9eff0ef          	jal	ra,ffffffffc0209bdc <sfs_bmap_load_nolock>
ffffffffc020a542:	892a                	mv	s2,a0
ffffffffc020a544:	ed11                	bnez	a0,ffffffffc020a560 <sfs_truncfile+0x166>
ffffffffc020a546:	2485                	addiw	s1,s1,1
ffffffffc020a548:	fe9417e3          	bne	s0,s1,ffffffffc020a536 <sfs_truncfile+0x13c>
ffffffffc020a54c:	008aa483          	lw	s1,8(s5)
ffffffffc020a550:	0a941b63          	bne	s0,s1,ffffffffc020a606 <sfs_truncfile+0x20c>
ffffffffc020a554:	014aa023          	sw	s4,0(s5)
ffffffffc020a558:	4785                	li	a5,1
ffffffffc020a55a:	00f9b823          	sd	a5,16(s3)
ffffffffc020a55e:	4901                	li	s2,0
ffffffffc020a560:	855a                	mv	a0,s6
ffffffffc020a562:	ffff90ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020a566:	bddd                	j	ffffffffc020a45c <sfs_truncfile+0x62>
ffffffffc020a568:	86e2                	mv	a3,s8
ffffffffc020a56a:	4611                	li	a2,4
ffffffffc020a56c:	086c                	addi	a1,sp,28
ffffffffc020a56e:	8566                	mv	a0,s9
ffffffffc020a570:	02d000ef          	jal	ra,ffffffffc020ad9c <sfs_wbuf>
ffffffffc020a574:	892a                	mv	s2,a0
ffffffffc020a576:	f56d                	bnez	a0,ffffffffc020a560 <sfs_truncfile+0x166>
ffffffffc020a578:	45e2                	lw	a1,24(sp)
ffffffffc020a57a:	8566                	mv	a0,s9
ffffffffc020a57c:	ba6ff0ef          	jal	ra,ffffffffc0209922 <sfs_block_free>
ffffffffc020a580:	b7a5                	j	ffffffffc020a4e8 <sfs_truncfile+0xee>
ffffffffc020a582:	5975                	li	s2,-3
ffffffffc020a584:	bde1                	j	ffffffffc020a45c <sfs_truncfile+0x62>
ffffffffc020a586:	00004697          	auipc	a3,0x4
ffffffffc020a58a:	79268693          	addi	a3,a3,1938 # ffffffffc020ed18 <dev_node_ops+0x3e0>
ffffffffc020a58e:	00001617          	auipc	a2,0x1
ffffffffc020a592:	3fa60613          	addi	a2,a2,1018 # ffffffffc020b988 <commands+0x210>
ffffffffc020a596:	3a800593          	li	a1,936
ffffffffc020a59a:	00005517          	auipc	a0,0x5
ffffffffc020a59e:	95e50513          	addi	a0,a0,-1698 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a5a2:	efdf50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a5a6:	00005697          	auipc	a3,0x5
ffffffffc020a5aa:	91a68693          	addi	a3,a3,-1766 # ffffffffc020eec0 <dev_node_ops+0x588>
ffffffffc020a5ae:	00001617          	auipc	a2,0x1
ffffffffc020a5b2:	3da60613          	addi	a2,a2,986 # ffffffffc020b988 <commands+0x210>
ffffffffc020a5b6:	3a900593          	li	a1,937
ffffffffc020a5ba:	00005517          	auipc	a0,0x5
ffffffffc020a5be:	93e50513          	addi	a0,a0,-1730 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a5c2:	eddf50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a5c6:	00005697          	auipc	a3,0x5
ffffffffc020a5ca:	b5268693          	addi	a3,a3,-1198 # ffffffffc020f118 <dev_node_ops+0x7e0>
ffffffffc020a5ce:	00001617          	auipc	a2,0x1
ffffffffc020a5d2:	3ba60613          	addi	a2,a2,954 # ffffffffc020b988 <commands+0x210>
ffffffffc020a5d6:	17b00593          	li	a1,379
ffffffffc020a5da:	00005517          	auipc	a0,0x5
ffffffffc020a5de:	91e50513          	addi	a0,a0,-1762 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a5e2:	ebdf50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a5e6:	00005697          	auipc	a3,0x5
ffffffffc020a5ea:	b1a68693          	addi	a3,a3,-1254 # ffffffffc020f100 <dev_node_ops+0x7c8>
ffffffffc020a5ee:	00001617          	auipc	a2,0x1
ffffffffc020a5f2:	39a60613          	addi	a2,a2,922 # ffffffffc020b988 <commands+0x210>
ffffffffc020a5f6:	3b000593          	li	a1,944
ffffffffc020a5fa:	00005517          	auipc	a0,0x5
ffffffffc020a5fe:	8fe50513          	addi	a0,a0,-1794 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a602:	e9df50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a606:	00005697          	auipc	a3,0x5
ffffffffc020a60a:	b6268693          	addi	a3,a3,-1182 # ffffffffc020f168 <dev_node_ops+0x830>
ffffffffc020a60e:	00001617          	auipc	a2,0x1
ffffffffc020a612:	37a60613          	addi	a2,a2,890 # ffffffffc020b988 <commands+0x210>
ffffffffc020a616:	3c900593          	li	a1,969
ffffffffc020a61a:	00005517          	auipc	a0,0x5
ffffffffc020a61e:	8de50513          	addi	a0,a0,-1826 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a622:	e7df50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a626:	00005697          	auipc	a3,0x5
ffffffffc020a62a:	b0a68693          	addi	a3,a3,-1270 # ffffffffc020f130 <dev_node_ops+0x7f8>
ffffffffc020a62e:	00001617          	auipc	a2,0x1
ffffffffc020a632:	35a60613          	addi	a2,a2,858 # ffffffffc020b988 <commands+0x210>
ffffffffc020a636:	12b00593          	li	a1,299
ffffffffc020a63a:	00005517          	auipc	a0,0x5
ffffffffc020a63e:	8be50513          	addi	a0,a0,-1858 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a642:	e5df50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a646:	8762                	mv	a4,s8
ffffffffc020a648:	86be                	mv	a3,a5
ffffffffc020a64a:	00005617          	auipc	a2,0x5
ffffffffc020a64e:	8de60613          	addi	a2,a2,-1826 # ffffffffc020ef28 <dev_node_ops+0x5f0>
ffffffffc020a652:	05300593          	li	a1,83
ffffffffc020a656:	00005517          	auipc	a0,0x5
ffffffffc020a65a:	8a250513          	addi	a0,a0,-1886 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a65e:	e41f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a662 <sfs_load_inode>:
ffffffffc020a662:	7139                	addi	sp,sp,-64
ffffffffc020a664:	fc06                	sd	ra,56(sp)
ffffffffc020a666:	f822                	sd	s0,48(sp)
ffffffffc020a668:	f426                	sd	s1,40(sp)
ffffffffc020a66a:	f04a                	sd	s2,32(sp)
ffffffffc020a66c:	84b2                	mv	s1,a2
ffffffffc020a66e:	892a                	mv	s2,a0
ffffffffc020a670:	ec4e                	sd	s3,24(sp)
ffffffffc020a672:	e852                	sd	s4,16(sp)
ffffffffc020a674:	89ae                	mv	s3,a1
ffffffffc020a676:	e456                	sd	s5,8(sp)
ffffffffc020a678:	0d5000ef          	jal	ra,ffffffffc020af4c <lock_sfs_fs>
ffffffffc020a67c:	45a9                	li	a1,10
ffffffffc020a67e:	8526                	mv	a0,s1
ffffffffc020a680:	0a893403          	ld	s0,168(s2)
ffffffffc020a684:	0e9000ef          	jal	ra,ffffffffc020af6c <hash32>
ffffffffc020a688:	02051793          	slli	a5,a0,0x20
ffffffffc020a68c:	01c7d713          	srli	a4,a5,0x1c
ffffffffc020a690:	9722                	add	a4,a4,s0
ffffffffc020a692:	843a                	mv	s0,a4
ffffffffc020a694:	a029                	j	ffffffffc020a69e <sfs_load_inode+0x3c>
ffffffffc020a696:	fc042783          	lw	a5,-64(s0)
ffffffffc020a69a:	10978863          	beq	a5,s1,ffffffffc020a7aa <sfs_load_inode+0x148>
ffffffffc020a69e:	6400                	ld	s0,8(s0)
ffffffffc020a6a0:	fe871be3          	bne	a4,s0,ffffffffc020a696 <sfs_load_inode+0x34>
ffffffffc020a6a4:	04000513          	li	a0,64
ffffffffc020a6a8:	8e7f70ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020a6ac:	8aaa                	mv	s5,a0
ffffffffc020a6ae:	16050563          	beqz	a0,ffffffffc020a818 <sfs_load_inode+0x1b6>
ffffffffc020a6b2:	00492683          	lw	a3,4(s2)
ffffffffc020a6b6:	18048363          	beqz	s1,ffffffffc020a83c <sfs_load_inode+0x1da>
ffffffffc020a6ba:	18d4f163          	bgeu	s1,a3,ffffffffc020a83c <sfs_load_inode+0x1da>
ffffffffc020a6be:	03893503          	ld	a0,56(s2)
ffffffffc020a6c2:	85a6                	mv	a1,s1
ffffffffc020a6c4:	951fe0ef          	jal	ra,ffffffffc0209014 <bitmap_test>
ffffffffc020a6c8:	18051763          	bnez	a0,ffffffffc020a856 <sfs_load_inode+0x1f4>
ffffffffc020a6cc:	4701                	li	a4,0
ffffffffc020a6ce:	86a6                	mv	a3,s1
ffffffffc020a6d0:	04000613          	li	a2,64
ffffffffc020a6d4:	85d6                	mv	a1,s5
ffffffffc020a6d6:	854a                	mv	a0,s2
ffffffffc020a6d8:	644000ef          	jal	ra,ffffffffc020ad1c <sfs_rbuf>
ffffffffc020a6dc:	842a                	mv	s0,a0
ffffffffc020a6de:	0e051563          	bnez	a0,ffffffffc020a7c8 <sfs_load_inode+0x166>
ffffffffc020a6e2:	006ad783          	lhu	a5,6(s5)
ffffffffc020a6e6:	12078b63          	beqz	a5,ffffffffc020a81c <sfs_load_inode+0x1ba>
ffffffffc020a6ea:	6405                	lui	s0,0x1
ffffffffc020a6ec:	23540513          	addi	a0,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a6f0:	8defd0ef          	jal	ra,ffffffffc02077ce <__alloc_inode>
ffffffffc020a6f4:	8a2a                	mv	s4,a0
ffffffffc020a6f6:	c961                	beqz	a0,ffffffffc020a7c6 <sfs_load_inode+0x164>
ffffffffc020a6f8:	004ad683          	lhu	a3,4(s5)
ffffffffc020a6fc:	4785                	li	a5,1
ffffffffc020a6fe:	0cf69c63          	bne	a3,a5,ffffffffc020a7d6 <sfs_load_inode+0x174>
ffffffffc020a702:	864a                	mv	a2,s2
ffffffffc020a704:	00005597          	auipc	a1,0x5
ffffffffc020a708:	b7458593          	addi	a1,a1,-1164 # ffffffffc020f278 <sfs_node_fileops>
ffffffffc020a70c:	8defd0ef          	jal	ra,ffffffffc02077ea <inode_init>
ffffffffc020a710:	058a2783          	lw	a5,88(s4)
ffffffffc020a714:	23540413          	addi	s0,s0,565
ffffffffc020a718:	0e879063          	bne	a5,s0,ffffffffc020a7f8 <sfs_load_inode+0x196>
ffffffffc020a71c:	4785                	li	a5,1
ffffffffc020a71e:	00fa2c23          	sw	a5,24(s4)
ffffffffc020a722:	015a3023          	sd	s5,0(s4)
ffffffffc020a726:	009a2423          	sw	s1,8(s4)
ffffffffc020a72a:	000a3823          	sd	zero,16(s4)
ffffffffc020a72e:	4585                	li	a1,1
ffffffffc020a730:	020a0513          	addi	a0,s4,32
ffffffffc020a734:	e27f90ef          	jal	ra,ffffffffc020455a <sem_init>
ffffffffc020a738:	058a2703          	lw	a4,88(s4)
ffffffffc020a73c:	6785                	lui	a5,0x1
ffffffffc020a73e:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a742:	14f71663          	bne	a4,a5,ffffffffc020a88e <sfs_load_inode+0x22c>
ffffffffc020a746:	0a093703          	ld	a4,160(s2)
ffffffffc020a74a:	038a0793          	addi	a5,s4,56
ffffffffc020a74e:	008a2503          	lw	a0,8(s4)
ffffffffc020a752:	e31c                	sd	a5,0(a4)
ffffffffc020a754:	0af93023          	sd	a5,160(s2)
ffffffffc020a758:	09890793          	addi	a5,s2,152
ffffffffc020a75c:	0a893403          	ld	s0,168(s2)
ffffffffc020a760:	45a9                	li	a1,10
ffffffffc020a762:	04ea3023          	sd	a4,64(s4)
ffffffffc020a766:	02fa3c23          	sd	a5,56(s4)
ffffffffc020a76a:	003000ef          	jal	ra,ffffffffc020af6c <hash32>
ffffffffc020a76e:	02051713          	slli	a4,a0,0x20
ffffffffc020a772:	01c75793          	srli	a5,a4,0x1c
ffffffffc020a776:	97a2                	add	a5,a5,s0
ffffffffc020a778:	6798                	ld	a4,8(a5)
ffffffffc020a77a:	048a0693          	addi	a3,s4,72
ffffffffc020a77e:	e314                	sd	a3,0(a4)
ffffffffc020a780:	e794                	sd	a3,8(a5)
ffffffffc020a782:	04ea3823          	sd	a4,80(s4)
ffffffffc020a786:	04fa3423          	sd	a5,72(s4)
ffffffffc020a78a:	854a                	mv	a0,s2
ffffffffc020a78c:	7d0000ef          	jal	ra,ffffffffc020af5c <unlock_sfs_fs>
ffffffffc020a790:	4401                	li	s0,0
ffffffffc020a792:	0149b023          	sd	s4,0(s3)
ffffffffc020a796:	70e2                	ld	ra,56(sp)
ffffffffc020a798:	8522                	mv	a0,s0
ffffffffc020a79a:	7442                	ld	s0,48(sp)
ffffffffc020a79c:	74a2                	ld	s1,40(sp)
ffffffffc020a79e:	7902                	ld	s2,32(sp)
ffffffffc020a7a0:	69e2                	ld	s3,24(sp)
ffffffffc020a7a2:	6a42                	ld	s4,16(sp)
ffffffffc020a7a4:	6aa2                	ld	s5,8(sp)
ffffffffc020a7a6:	6121                	addi	sp,sp,64
ffffffffc020a7a8:	8082                	ret
ffffffffc020a7aa:	fb840a13          	addi	s4,s0,-72
ffffffffc020a7ae:	8552                	mv	a0,s4
ffffffffc020a7b0:	89cfd0ef          	jal	ra,ffffffffc020784c <inode_ref_inc>
ffffffffc020a7b4:	4785                	li	a5,1
ffffffffc020a7b6:	fcf51ae3          	bne	a0,a5,ffffffffc020a78a <sfs_load_inode+0x128>
ffffffffc020a7ba:	fd042783          	lw	a5,-48(s0)
ffffffffc020a7be:	2785                	addiw	a5,a5,1
ffffffffc020a7c0:	fcf42823          	sw	a5,-48(s0)
ffffffffc020a7c4:	b7d9                	j	ffffffffc020a78a <sfs_load_inode+0x128>
ffffffffc020a7c6:	5471                	li	s0,-4
ffffffffc020a7c8:	8556                	mv	a0,s5
ffffffffc020a7ca:	875f70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a7ce:	854a                	mv	a0,s2
ffffffffc020a7d0:	78c000ef          	jal	ra,ffffffffc020af5c <unlock_sfs_fs>
ffffffffc020a7d4:	b7c9                	j	ffffffffc020a796 <sfs_load_inode+0x134>
ffffffffc020a7d6:	4789                	li	a5,2
ffffffffc020a7d8:	08f69f63          	bne	a3,a5,ffffffffc020a876 <sfs_load_inode+0x214>
ffffffffc020a7dc:	864a                	mv	a2,s2
ffffffffc020a7de:	00005597          	auipc	a1,0x5
ffffffffc020a7e2:	a1a58593          	addi	a1,a1,-1510 # ffffffffc020f1f8 <sfs_node_dirops>
ffffffffc020a7e6:	804fd0ef          	jal	ra,ffffffffc02077ea <inode_init>
ffffffffc020a7ea:	058a2703          	lw	a4,88(s4)
ffffffffc020a7ee:	6785                	lui	a5,0x1
ffffffffc020a7f0:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a7f4:	f2f704e3          	beq	a4,a5,ffffffffc020a71c <sfs_load_inode+0xba>
ffffffffc020a7f8:	00004697          	auipc	a3,0x4
ffffffffc020a7fc:	6c868693          	addi	a3,a3,1736 # ffffffffc020eec0 <dev_node_ops+0x588>
ffffffffc020a800:	00001617          	auipc	a2,0x1
ffffffffc020a804:	18860613          	addi	a2,a2,392 # ffffffffc020b988 <commands+0x210>
ffffffffc020a808:	07700593          	li	a1,119
ffffffffc020a80c:	00004517          	auipc	a0,0x4
ffffffffc020a810:	6ec50513          	addi	a0,a0,1772 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a814:	c8bf50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a818:	5471                	li	s0,-4
ffffffffc020a81a:	bf55                	j	ffffffffc020a7ce <sfs_load_inode+0x16c>
ffffffffc020a81c:	00005697          	auipc	a3,0x5
ffffffffc020a820:	96468693          	addi	a3,a3,-1692 # ffffffffc020f180 <dev_node_ops+0x848>
ffffffffc020a824:	00001617          	auipc	a2,0x1
ffffffffc020a828:	16460613          	addi	a2,a2,356 # ffffffffc020b988 <commands+0x210>
ffffffffc020a82c:	0ad00593          	li	a1,173
ffffffffc020a830:	00004517          	auipc	a0,0x4
ffffffffc020a834:	6c850513          	addi	a0,a0,1736 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a838:	c67f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a83c:	8726                	mv	a4,s1
ffffffffc020a83e:	00004617          	auipc	a2,0x4
ffffffffc020a842:	6ea60613          	addi	a2,a2,1770 # ffffffffc020ef28 <dev_node_ops+0x5f0>
ffffffffc020a846:	05300593          	li	a1,83
ffffffffc020a84a:	00004517          	auipc	a0,0x4
ffffffffc020a84e:	6ae50513          	addi	a0,a0,1710 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a852:	c4df50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a856:	00004697          	auipc	a3,0x4
ffffffffc020a85a:	70a68693          	addi	a3,a3,1802 # ffffffffc020ef60 <dev_node_ops+0x628>
ffffffffc020a85e:	00001617          	auipc	a2,0x1
ffffffffc020a862:	12a60613          	addi	a2,a2,298 # ffffffffc020b988 <commands+0x210>
ffffffffc020a866:	0a800593          	li	a1,168
ffffffffc020a86a:	00004517          	auipc	a0,0x4
ffffffffc020a86e:	68e50513          	addi	a0,a0,1678 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a872:	c2df50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a876:	00004617          	auipc	a2,0x4
ffffffffc020a87a:	69a60613          	addi	a2,a2,1690 # ffffffffc020ef10 <dev_node_ops+0x5d8>
ffffffffc020a87e:	02e00593          	li	a1,46
ffffffffc020a882:	00004517          	auipc	a0,0x4
ffffffffc020a886:	67650513          	addi	a0,a0,1654 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a88a:	c15f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a88e:	00004697          	auipc	a3,0x4
ffffffffc020a892:	63268693          	addi	a3,a3,1586 # ffffffffc020eec0 <dev_node_ops+0x588>
ffffffffc020a896:	00001617          	auipc	a2,0x1
ffffffffc020a89a:	0f260613          	addi	a2,a2,242 # ffffffffc020b988 <commands+0x210>
ffffffffc020a89e:	0b100593          	li	a1,177
ffffffffc020a8a2:	00004517          	auipc	a0,0x4
ffffffffc020a8a6:	65650513          	addi	a0,a0,1622 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a8aa:	bf5f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a8ae <sfs_lookup>:
ffffffffc020a8ae:	7139                	addi	sp,sp,-64
ffffffffc020a8b0:	ec4e                	sd	s3,24(sp)
ffffffffc020a8b2:	06853983          	ld	s3,104(a0)
ffffffffc020a8b6:	fc06                	sd	ra,56(sp)
ffffffffc020a8b8:	f822                	sd	s0,48(sp)
ffffffffc020a8ba:	f426                	sd	s1,40(sp)
ffffffffc020a8bc:	f04a                	sd	s2,32(sp)
ffffffffc020a8be:	e852                	sd	s4,16(sp)
ffffffffc020a8c0:	0a098c63          	beqz	s3,ffffffffc020a978 <sfs_lookup+0xca>
ffffffffc020a8c4:	0b09a783          	lw	a5,176(s3)
ffffffffc020a8c8:	ebc5                	bnez	a5,ffffffffc020a978 <sfs_lookup+0xca>
ffffffffc020a8ca:	0005c783          	lbu	a5,0(a1)
ffffffffc020a8ce:	84ae                	mv	s1,a1
ffffffffc020a8d0:	c7c1                	beqz	a5,ffffffffc020a958 <sfs_lookup+0xaa>
ffffffffc020a8d2:	02f00713          	li	a4,47
ffffffffc020a8d6:	08e78163          	beq	a5,a4,ffffffffc020a958 <sfs_lookup+0xaa>
ffffffffc020a8da:	842a                	mv	s0,a0
ffffffffc020a8dc:	8a32                	mv	s4,a2
ffffffffc020a8de:	f6ffc0ef          	jal	ra,ffffffffc020784c <inode_ref_inc>
ffffffffc020a8e2:	4c38                	lw	a4,88(s0)
ffffffffc020a8e4:	6785                	lui	a5,0x1
ffffffffc020a8e6:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a8ea:	0af71763          	bne	a4,a5,ffffffffc020a998 <sfs_lookup+0xea>
ffffffffc020a8ee:	6018                	ld	a4,0(s0)
ffffffffc020a8f0:	4789                	li	a5,2
ffffffffc020a8f2:	00475703          	lhu	a4,4(a4)
ffffffffc020a8f6:	04f71c63          	bne	a4,a5,ffffffffc020a94e <sfs_lookup+0xa0>
ffffffffc020a8fa:	02040913          	addi	s2,s0,32
ffffffffc020a8fe:	854a                	mv	a0,s2
ffffffffc020a900:	c65f90ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020a904:	8626                	mv	a2,s1
ffffffffc020a906:	0054                	addi	a3,sp,4
ffffffffc020a908:	85a2                	mv	a1,s0
ffffffffc020a90a:	854e                	mv	a0,s3
ffffffffc020a90c:	a29ff0ef          	jal	ra,ffffffffc020a334 <sfs_dirent_search_nolock.constprop.0>
ffffffffc020a910:	84aa                	mv	s1,a0
ffffffffc020a912:	854a                	mv	a0,s2
ffffffffc020a914:	c4df90ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020a918:	cc89                	beqz	s1,ffffffffc020a932 <sfs_lookup+0x84>
ffffffffc020a91a:	8522                	mv	a0,s0
ffffffffc020a91c:	ffffc0ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc020a920:	70e2                	ld	ra,56(sp)
ffffffffc020a922:	7442                	ld	s0,48(sp)
ffffffffc020a924:	7902                	ld	s2,32(sp)
ffffffffc020a926:	69e2                	ld	s3,24(sp)
ffffffffc020a928:	6a42                	ld	s4,16(sp)
ffffffffc020a92a:	8526                	mv	a0,s1
ffffffffc020a92c:	74a2                	ld	s1,40(sp)
ffffffffc020a92e:	6121                	addi	sp,sp,64
ffffffffc020a930:	8082                	ret
ffffffffc020a932:	4612                	lw	a2,4(sp)
ffffffffc020a934:	002c                	addi	a1,sp,8
ffffffffc020a936:	854e                	mv	a0,s3
ffffffffc020a938:	d2bff0ef          	jal	ra,ffffffffc020a662 <sfs_load_inode>
ffffffffc020a93c:	84aa                	mv	s1,a0
ffffffffc020a93e:	8522                	mv	a0,s0
ffffffffc020a940:	fdbfc0ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc020a944:	fcf1                	bnez	s1,ffffffffc020a920 <sfs_lookup+0x72>
ffffffffc020a946:	67a2                	ld	a5,8(sp)
ffffffffc020a948:	00fa3023          	sd	a5,0(s4)
ffffffffc020a94c:	bfd1                	j	ffffffffc020a920 <sfs_lookup+0x72>
ffffffffc020a94e:	8522                	mv	a0,s0
ffffffffc020a950:	fcbfc0ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc020a954:	54b9                	li	s1,-18
ffffffffc020a956:	b7e9                	j	ffffffffc020a920 <sfs_lookup+0x72>
ffffffffc020a958:	00005697          	auipc	a3,0x5
ffffffffc020a95c:	84068693          	addi	a3,a3,-1984 # ffffffffc020f198 <dev_node_ops+0x860>
ffffffffc020a960:	00001617          	auipc	a2,0x1
ffffffffc020a964:	02860613          	addi	a2,a2,40 # ffffffffc020b988 <commands+0x210>
ffffffffc020a968:	3da00593          	li	a1,986
ffffffffc020a96c:	00004517          	auipc	a0,0x4
ffffffffc020a970:	58c50513          	addi	a0,a0,1420 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a974:	b2bf50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a978:	00004697          	auipc	a3,0x4
ffffffffc020a97c:	3a068693          	addi	a3,a3,928 # ffffffffc020ed18 <dev_node_ops+0x3e0>
ffffffffc020a980:	00001617          	auipc	a2,0x1
ffffffffc020a984:	00860613          	addi	a2,a2,8 # ffffffffc020b988 <commands+0x210>
ffffffffc020a988:	3d900593          	li	a1,985
ffffffffc020a98c:	00004517          	auipc	a0,0x4
ffffffffc020a990:	56c50513          	addi	a0,a0,1388 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a994:	b0bf50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a998:	00004697          	auipc	a3,0x4
ffffffffc020a99c:	52868693          	addi	a3,a3,1320 # ffffffffc020eec0 <dev_node_ops+0x588>
ffffffffc020a9a0:	00001617          	auipc	a2,0x1
ffffffffc020a9a4:	fe860613          	addi	a2,a2,-24 # ffffffffc020b988 <commands+0x210>
ffffffffc020a9a8:	3dc00593          	li	a1,988
ffffffffc020a9ac:	00004517          	auipc	a0,0x4
ffffffffc020a9b0:	54c50513          	addi	a0,a0,1356 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020a9b4:	aebf50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a9b8 <sfs_namefile>:
ffffffffc020a9b8:	6d98                	ld	a4,24(a1)
ffffffffc020a9ba:	7175                	addi	sp,sp,-144
ffffffffc020a9bc:	e506                	sd	ra,136(sp)
ffffffffc020a9be:	e122                	sd	s0,128(sp)
ffffffffc020a9c0:	fca6                	sd	s1,120(sp)
ffffffffc020a9c2:	f8ca                	sd	s2,112(sp)
ffffffffc020a9c4:	f4ce                	sd	s3,104(sp)
ffffffffc020a9c6:	f0d2                	sd	s4,96(sp)
ffffffffc020a9c8:	ecd6                	sd	s5,88(sp)
ffffffffc020a9ca:	e8da                	sd	s6,80(sp)
ffffffffc020a9cc:	e4de                	sd	s7,72(sp)
ffffffffc020a9ce:	e0e2                	sd	s8,64(sp)
ffffffffc020a9d0:	fc66                	sd	s9,56(sp)
ffffffffc020a9d2:	f86a                	sd	s10,48(sp)
ffffffffc020a9d4:	f46e                	sd	s11,40(sp)
ffffffffc020a9d6:	e42e                	sd	a1,8(sp)
ffffffffc020a9d8:	4789                	li	a5,2
ffffffffc020a9da:	1ae7f363          	bgeu	a5,a4,ffffffffc020ab80 <sfs_namefile+0x1c8>
ffffffffc020a9de:	89aa                	mv	s3,a0
ffffffffc020a9e0:	10400513          	li	a0,260
ffffffffc020a9e4:	daaf70ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020a9e8:	842a                	mv	s0,a0
ffffffffc020a9ea:	18050b63          	beqz	a0,ffffffffc020ab80 <sfs_namefile+0x1c8>
ffffffffc020a9ee:	0689b483          	ld	s1,104(s3)
ffffffffc020a9f2:	1e048963          	beqz	s1,ffffffffc020abe4 <sfs_namefile+0x22c>
ffffffffc020a9f6:	0b04a783          	lw	a5,176(s1)
ffffffffc020a9fa:	1e079563          	bnez	a5,ffffffffc020abe4 <sfs_namefile+0x22c>
ffffffffc020a9fe:	0589ac83          	lw	s9,88(s3)
ffffffffc020aa02:	6785                	lui	a5,0x1
ffffffffc020aa04:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020aa08:	1afc9e63          	bne	s9,a5,ffffffffc020abc4 <sfs_namefile+0x20c>
ffffffffc020aa0c:	6722                	ld	a4,8(sp)
ffffffffc020aa0e:	854e                	mv	a0,s3
ffffffffc020aa10:	8ace                	mv	s5,s3
ffffffffc020aa12:	6f1c                	ld	a5,24(a4)
ffffffffc020aa14:	00073b03          	ld	s6,0(a4)
ffffffffc020aa18:	02098a13          	addi	s4,s3,32
ffffffffc020aa1c:	ffe78b93          	addi	s7,a5,-2
ffffffffc020aa20:	9b3e                	add	s6,s6,a5
ffffffffc020aa22:	00004d17          	auipc	s10,0x4
ffffffffc020aa26:	796d0d13          	addi	s10,s10,1942 # ffffffffc020f1b8 <dev_node_ops+0x880>
ffffffffc020aa2a:	e23fc0ef          	jal	ra,ffffffffc020784c <inode_ref_inc>
ffffffffc020aa2e:	00440c13          	addi	s8,s0,4
ffffffffc020aa32:	e066                	sd	s9,0(sp)
ffffffffc020aa34:	8552                	mv	a0,s4
ffffffffc020aa36:	b2ff90ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020aa3a:	0854                	addi	a3,sp,20
ffffffffc020aa3c:	866a                	mv	a2,s10
ffffffffc020aa3e:	85d6                	mv	a1,s5
ffffffffc020aa40:	8526                	mv	a0,s1
ffffffffc020aa42:	8f3ff0ef          	jal	ra,ffffffffc020a334 <sfs_dirent_search_nolock.constprop.0>
ffffffffc020aa46:	8daa                	mv	s11,a0
ffffffffc020aa48:	8552                	mv	a0,s4
ffffffffc020aa4a:	b17f90ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020aa4e:	020d8863          	beqz	s11,ffffffffc020aa7e <sfs_namefile+0xc6>
ffffffffc020aa52:	854e                	mv	a0,s3
ffffffffc020aa54:	ec7fc0ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc020aa58:	8522                	mv	a0,s0
ffffffffc020aa5a:	de4f70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020aa5e:	60aa                	ld	ra,136(sp)
ffffffffc020aa60:	640a                	ld	s0,128(sp)
ffffffffc020aa62:	74e6                	ld	s1,120(sp)
ffffffffc020aa64:	7946                	ld	s2,112(sp)
ffffffffc020aa66:	79a6                	ld	s3,104(sp)
ffffffffc020aa68:	7a06                	ld	s4,96(sp)
ffffffffc020aa6a:	6ae6                	ld	s5,88(sp)
ffffffffc020aa6c:	6b46                	ld	s6,80(sp)
ffffffffc020aa6e:	6ba6                	ld	s7,72(sp)
ffffffffc020aa70:	6c06                	ld	s8,64(sp)
ffffffffc020aa72:	7ce2                	ld	s9,56(sp)
ffffffffc020aa74:	7d42                	ld	s10,48(sp)
ffffffffc020aa76:	856e                	mv	a0,s11
ffffffffc020aa78:	7da2                	ld	s11,40(sp)
ffffffffc020aa7a:	6149                	addi	sp,sp,144
ffffffffc020aa7c:	8082                	ret
ffffffffc020aa7e:	4652                	lw	a2,20(sp)
ffffffffc020aa80:	082c                	addi	a1,sp,24
ffffffffc020aa82:	8526                	mv	a0,s1
ffffffffc020aa84:	bdfff0ef          	jal	ra,ffffffffc020a662 <sfs_load_inode>
ffffffffc020aa88:	8daa                	mv	s11,a0
ffffffffc020aa8a:	f561                	bnez	a0,ffffffffc020aa52 <sfs_namefile+0x9a>
ffffffffc020aa8c:	854e                	mv	a0,s3
ffffffffc020aa8e:	008aa903          	lw	s2,8(s5)
ffffffffc020aa92:	e89fc0ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc020aa96:	6ce2                	ld	s9,24(sp)
ffffffffc020aa98:	0b3c8463          	beq	s9,s3,ffffffffc020ab40 <sfs_namefile+0x188>
ffffffffc020aa9c:	100c8463          	beqz	s9,ffffffffc020aba4 <sfs_namefile+0x1ec>
ffffffffc020aaa0:	058ca703          	lw	a4,88(s9)
ffffffffc020aaa4:	6782                	ld	a5,0(sp)
ffffffffc020aaa6:	0ef71f63          	bne	a4,a5,ffffffffc020aba4 <sfs_namefile+0x1ec>
ffffffffc020aaaa:	008ca703          	lw	a4,8(s9)
ffffffffc020aaae:	8ae6                	mv	s5,s9
ffffffffc020aab0:	0d270a63          	beq	a4,s2,ffffffffc020ab84 <sfs_namefile+0x1cc>
ffffffffc020aab4:	000cb703          	ld	a4,0(s9)
ffffffffc020aab8:	4789                	li	a5,2
ffffffffc020aaba:	00475703          	lhu	a4,4(a4)
ffffffffc020aabe:	0cf71363          	bne	a4,a5,ffffffffc020ab84 <sfs_namefile+0x1cc>
ffffffffc020aac2:	020c8a13          	addi	s4,s9,32
ffffffffc020aac6:	8552                	mv	a0,s4
ffffffffc020aac8:	a9df90ef          	jal	ra,ffffffffc0204564 <down>
ffffffffc020aacc:	000cb703          	ld	a4,0(s9)
ffffffffc020aad0:	00872983          	lw	s3,8(a4)
ffffffffc020aad4:	01304963          	bgtz	s3,ffffffffc020aae6 <sfs_namefile+0x12e>
ffffffffc020aad8:	a899                	j	ffffffffc020ab2e <sfs_namefile+0x176>
ffffffffc020aada:	4018                	lw	a4,0(s0)
ffffffffc020aadc:	01270e63          	beq	a4,s2,ffffffffc020aaf8 <sfs_namefile+0x140>
ffffffffc020aae0:	2d85                	addiw	s11,s11,1
ffffffffc020aae2:	05b98663          	beq	s3,s11,ffffffffc020ab2e <sfs_namefile+0x176>
ffffffffc020aae6:	86a2                	mv	a3,s0
ffffffffc020aae8:	866e                	mv	a2,s11
ffffffffc020aaea:	85e6                	mv	a1,s9
ffffffffc020aaec:	8526                	mv	a0,s1
ffffffffc020aaee:	e48ff0ef          	jal	ra,ffffffffc020a136 <sfs_dirent_read_nolock>
ffffffffc020aaf2:	872a                	mv	a4,a0
ffffffffc020aaf4:	d17d                	beqz	a0,ffffffffc020aada <sfs_namefile+0x122>
ffffffffc020aaf6:	a82d                	j	ffffffffc020ab30 <sfs_namefile+0x178>
ffffffffc020aaf8:	8552                	mv	a0,s4
ffffffffc020aafa:	a67f90ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020aafe:	8562                	mv	a0,s8
ffffffffc020ab00:	0ff000ef          	jal	ra,ffffffffc020b3fe <strlen>
ffffffffc020ab04:	00150793          	addi	a5,a0,1
ffffffffc020ab08:	862a                	mv	a2,a0
ffffffffc020ab0a:	06fbe863          	bltu	s7,a5,ffffffffc020ab7a <sfs_namefile+0x1c2>
ffffffffc020ab0e:	fff64913          	not	s2,a2
ffffffffc020ab12:	995a                	add	s2,s2,s6
ffffffffc020ab14:	85e2                	mv	a1,s8
ffffffffc020ab16:	854a                	mv	a0,s2
ffffffffc020ab18:	40fb8bb3          	sub	s7,s7,a5
ffffffffc020ab1c:	1d7000ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc020ab20:	02f00793          	li	a5,47
ffffffffc020ab24:	fefb0fa3          	sb	a5,-1(s6)
ffffffffc020ab28:	89e6                	mv	s3,s9
ffffffffc020ab2a:	8b4a                	mv	s6,s2
ffffffffc020ab2c:	b721                	j	ffffffffc020aa34 <sfs_namefile+0x7c>
ffffffffc020ab2e:	5741                	li	a4,-16
ffffffffc020ab30:	8552                	mv	a0,s4
ffffffffc020ab32:	e03a                	sd	a4,0(sp)
ffffffffc020ab34:	a2df90ef          	jal	ra,ffffffffc0204560 <up>
ffffffffc020ab38:	6702                	ld	a4,0(sp)
ffffffffc020ab3a:	89e6                	mv	s3,s9
ffffffffc020ab3c:	8dba                	mv	s11,a4
ffffffffc020ab3e:	bf11                	j	ffffffffc020aa52 <sfs_namefile+0x9a>
ffffffffc020ab40:	854e                	mv	a0,s3
ffffffffc020ab42:	dd9fc0ef          	jal	ra,ffffffffc020791a <inode_ref_dec>
ffffffffc020ab46:	64a2                	ld	s1,8(sp)
ffffffffc020ab48:	85da                	mv	a1,s6
ffffffffc020ab4a:	6c98                	ld	a4,24(s1)
ffffffffc020ab4c:	6088                	ld	a0,0(s1)
ffffffffc020ab4e:	1779                	addi	a4,a4,-2
ffffffffc020ab50:	41770bb3          	sub	s7,a4,s7
ffffffffc020ab54:	865e                	mv	a2,s7
ffffffffc020ab56:	0505                	addi	a0,a0,1
ffffffffc020ab58:	15b000ef          	jal	ra,ffffffffc020b4b2 <memmove>
ffffffffc020ab5c:	02f00713          	li	a4,47
ffffffffc020ab60:	fee50fa3          	sb	a4,-1(a0)
ffffffffc020ab64:	955e                	add	a0,a0,s7
ffffffffc020ab66:	00050023          	sb	zero,0(a0)
ffffffffc020ab6a:	85de                	mv	a1,s7
ffffffffc020ab6c:	8526                	mv	a0,s1
ffffffffc020ab6e:	8ebfa0ef          	jal	ra,ffffffffc0205458 <iobuf_skip>
ffffffffc020ab72:	8522                	mv	a0,s0
ffffffffc020ab74:	ccaf70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020ab78:	b5dd                	j	ffffffffc020aa5e <sfs_namefile+0xa6>
ffffffffc020ab7a:	89e6                	mv	s3,s9
ffffffffc020ab7c:	5df1                	li	s11,-4
ffffffffc020ab7e:	bdd1                	j	ffffffffc020aa52 <sfs_namefile+0x9a>
ffffffffc020ab80:	5df1                	li	s11,-4
ffffffffc020ab82:	bdf1                	j	ffffffffc020aa5e <sfs_namefile+0xa6>
ffffffffc020ab84:	00004697          	auipc	a3,0x4
ffffffffc020ab88:	63c68693          	addi	a3,a3,1596 # ffffffffc020f1c0 <dev_node_ops+0x888>
ffffffffc020ab8c:	00001617          	auipc	a2,0x1
ffffffffc020ab90:	dfc60613          	addi	a2,a2,-516 # ffffffffc020b988 <commands+0x210>
ffffffffc020ab94:	2f800593          	li	a1,760
ffffffffc020ab98:	00004517          	auipc	a0,0x4
ffffffffc020ab9c:	36050513          	addi	a0,a0,864 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020aba0:	8fff50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020aba4:	00004697          	auipc	a3,0x4
ffffffffc020aba8:	31c68693          	addi	a3,a3,796 # ffffffffc020eec0 <dev_node_ops+0x588>
ffffffffc020abac:	00001617          	auipc	a2,0x1
ffffffffc020abb0:	ddc60613          	addi	a2,a2,-548 # ffffffffc020b988 <commands+0x210>
ffffffffc020abb4:	2f700593          	li	a1,759
ffffffffc020abb8:	00004517          	auipc	a0,0x4
ffffffffc020abbc:	34050513          	addi	a0,a0,832 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020abc0:	8dff50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020abc4:	00004697          	auipc	a3,0x4
ffffffffc020abc8:	2fc68693          	addi	a3,a3,764 # ffffffffc020eec0 <dev_node_ops+0x588>
ffffffffc020abcc:	00001617          	auipc	a2,0x1
ffffffffc020abd0:	dbc60613          	addi	a2,a2,-580 # ffffffffc020b988 <commands+0x210>
ffffffffc020abd4:	2e400593          	li	a1,740
ffffffffc020abd8:	00004517          	auipc	a0,0x4
ffffffffc020abdc:	32050513          	addi	a0,a0,800 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020abe0:	8bff50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020abe4:	00004697          	auipc	a3,0x4
ffffffffc020abe8:	13468693          	addi	a3,a3,308 # ffffffffc020ed18 <dev_node_ops+0x3e0>
ffffffffc020abec:	00001617          	auipc	a2,0x1
ffffffffc020abf0:	d9c60613          	addi	a2,a2,-612 # ffffffffc020b988 <commands+0x210>
ffffffffc020abf4:	2e300593          	li	a1,739
ffffffffc020abf8:	00004517          	auipc	a0,0x4
ffffffffc020abfc:	30050513          	addi	a0,a0,768 # ffffffffc020eef8 <dev_node_ops+0x5c0>
ffffffffc020ac00:	89ff50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020ac04 <sfs_rwblock_nolock>:
ffffffffc020ac04:	7139                	addi	sp,sp,-64
ffffffffc020ac06:	f822                	sd	s0,48(sp)
ffffffffc020ac08:	f426                	sd	s1,40(sp)
ffffffffc020ac0a:	fc06                	sd	ra,56(sp)
ffffffffc020ac0c:	842a                	mv	s0,a0
ffffffffc020ac0e:	84b6                	mv	s1,a3
ffffffffc020ac10:	e211                	bnez	a2,ffffffffc020ac14 <sfs_rwblock_nolock+0x10>
ffffffffc020ac12:	e715                	bnez	a4,ffffffffc020ac3e <sfs_rwblock_nolock+0x3a>
ffffffffc020ac14:	405c                	lw	a5,4(s0)
ffffffffc020ac16:	02f67463          	bgeu	a2,a5,ffffffffc020ac3e <sfs_rwblock_nolock+0x3a>
ffffffffc020ac1a:	00c6169b          	slliw	a3,a2,0xc
ffffffffc020ac1e:	1682                	slli	a3,a3,0x20
ffffffffc020ac20:	6605                	lui	a2,0x1
ffffffffc020ac22:	9281                	srli	a3,a3,0x20
ffffffffc020ac24:	850a                	mv	a0,sp
ffffffffc020ac26:	fbcfa0ef          	jal	ra,ffffffffc02053e2 <iobuf_init>
ffffffffc020ac2a:	85aa                	mv	a1,a0
ffffffffc020ac2c:	7808                	ld	a0,48(s0)
ffffffffc020ac2e:	8626                	mv	a2,s1
ffffffffc020ac30:	7118                	ld	a4,32(a0)
ffffffffc020ac32:	9702                	jalr	a4
ffffffffc020ac34:	70e2                	ld	ra,56(sp)
ffffffffc020ac36:	7442                	ld	s0,48(sp)
ffffffffc020ac38:	74a2                	ld	s1,40(sp)
ffffffffc020ac3a:	6121                	addi	sp,sp,64
ffffffffc020ac3c:	8082                	ret
ffffffffc020ac3e:	00004697          	auipc	a3,0x4
ffffffffc020ac42:	6ba68693          	addi	a3,a3,1722 # ffffffffc020f2f8 <sfs_node_fileops+0x80>
ffffffffc020ac46:	00001617          	auipc	a2,0x1
ffffffffc020ac4a:	d4260613          	addi	a2,a2,-702 # ffffffffc020b988 <commands+0x210>
ffffffffc020ac4e:	45d5                	li	a1,21
ffffffffc020ac50:	00004517          	auipc	a0,0x4
ffffffffc020ac54:	6e050513          	addi	a0,a0,1760 # ffffffffc020f330 <sfs_node_fileops+0xb8>
ffffffffc020ac58:	847f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020ac5c <sfs_rblock>:
ffffffffc020ac5c:	7139                	addi	sp,sp,-64
ffffffffc020ac5e:	ec4e                	sd	s3,24(sp)
ffffffffc020ac60:	89b6                	mv	s3,a3
ffffffffc020ac62:	f822                	sd	s0,48(sp)
ffffffffc020ac64:	f04a                	sd	s2,32(sp)
ffffffffc020ac66:	e852                	sd	s4,16(sp)
ffffffffc020ac68:	fc06                	sd	ra,56(sp)
ffffffffc020ac6a:	f426                	sd	s1,40(sp)
ffffffffc020ac6c:	e456                	sd	s5,8(sp)
ffffffffc020ac6e:	8a2a                	mv	s4,a0
ffffffffc020ac70:	892e                	mv	s2,a1
ffffffffc020ac72:	8432                	mv	s0,a2
ffffffffc020ac74:	2e0000ef          	jal	ra,ffffffffc020af54 <lock_sfs_io>
ffffffffc020ac78:	04098063          	beqz	s3,ffffffffc020acb8 <sfs_rblock+0x5c>
ffffffffc020ac7c:	013409bb          	addw	s3,s0,s3
ffffffffc020ac80:	6a85                	lui	s5,0x1
ffffffffc020ac82:	a021                	j	ffffffffc020ac8a <sfs_rblock+0x2e>
ffffffffc020ac84:	9956                	add	s2,s2,s5
ffffffffc020ac86:	02898963          	beq	s3,s0,ffffffffc020acb8 <sfs_rblock+0x5c>
ffffffffc020ac8a:	8622                	mv	a2,s0
ffffffffc020ac8c:	85ca                	mv	a1,s2
ffffffffc020ac8e:	4705                	li	a4,1
ffffffffc020ac90:	4681                	li	a3,0
ffffffffc020ac92:	8552                	mv	a0,s4
ffffffffc020ac94:	f71ff0ef          	jal	ra,ffffffffc020ac04 <sfs_rwblock_nolock>
ffffffffc020ac98:	84aa                	mv	s1,a0
ffffffffc020ac9a:	2405                	addiw	s0,s0,1
ffffffffc020ac9c:	d565                	beqz	a0,ffffffffc020ac84 <sfs_rblock+0x28>
ffffffffc020ac9e:	8552                	mv	a0,s4
ffffffffc020aca0:	2c4000ef          	jal	ra,ffffffffc020af64 <unlock_sfs_io>
ffffffffc020aca4:	70e2                	ld	ra,56(sp)
ffffffffc020aca6:	7442                	ld	s0,48(sp)
ffffffffc020aca8:	7902                	ld	s2,32(sp)
ffffffffc020acaa:	69e2                	ld	s3,24(sp)
ffffffffc020acac:	6a42                	ld	s4,16(sp)
ffffffffc020acae:	6aa2                	ld	s5,8(sp)
ffffffffc020acb0:	8526                	mv	a0,s1
ffffffffc020acb2:	74a2                	ld	s1,40(sp)
ffffffffc020acb4:	6121                	addi	sp,sp,64
ffffffffc020acb6:	8082                	ret
ffffffffc020acb8:	4481                	li	s1,0
ffffffffc020acba:	b7d5                	j	ffffffffc020ac9e <sfs_rblock+0x42>

ffffffffc020acbc <sfs_wblock>:
ffffffffc020acbc:	7139                	addi	sp,sp,-64
ffffffffc020acbe:	ec4e                	sd	s3,24(sp)
ffffffffc020acc0:	89b6                	mv	s3,a3
ffffffffc020acc2:	f822                	sd	s0,48(sp)
ffffffffc020acc4:	f04a                	sd	s2,32(sp)
ffffffffc020acc6:	e852                	sd	s4,16(sp)
ffffffffc020acc8:	fc06                	sd	ra,56(sp)
ffffffffc020acca:	f426                	sd	s1,40(sp)
ffffffffc020accc:	e456                	sd	s5,8(sp)
ffffffffc020acce:	8a2a                	mv	s4,a0
ffffffffc020acd0:	892e                	mv	s2,a1
ffffffffc020acd2:	8432                	mv	s0,a2
ffffffffc020acd4:	280000ef          	jal	ra,ffffffffc020af54 <lock_sfs_io>
ffffffffc020acd8:	04098063          	beqz	s3,ffffffffc020ad18 <sfs_wblock+0x5c>
ffffffffc020acdc:	013409bb          	addw	s3,s0,s3
ffffffffc020ace0:	6a85                	lui	s5,0x1
ffffffffc020ace2:	a021                	j	ffffffffc020acea <sfs_wblock+0x2e>
ffffffffc020ace4:	9956                	add	s2,s2,s5
ffffffffc020ace6:	02898963          	beq	s3,s0,ffffffffc020ad18 <sfs_wblock+0x5c>
ffffffffc020acea:	8622                	mv	a2,s0
ffffffffc020acec:	85ca                	mv	a1,s2
ffffffffc020acee:	4705                	li	a4,1
ffffffffc020acf0:	4685                	li	a3,1
ffffffffc020acf2:	8552                	mv	a0,s4
ffffffffc020acf4:	f11ff0ef          	jal	ra,ffffffffc020ac04 <sfs_rwblock_nolock>
ffffffffc020acf8:	84aa                	mv	s1,a0
ffffffffc020acfa:	2405                	addiw	s0,s0,1
ffffffffc020acfc:	d565                	beqz	a0,ffffffffc020ace4 <sfs_wblock+0x28>
ffffffffc020acfe:	8552                	mv	a0,s4
ffffffffc020ad00:	264000ef          	jal	ra,ffffffffc020af64 <unlock_sfs_io>
ffffffffc020ad04:	70e2                	ld	ra,56(sp)
ffffffffc020ad06:	7442                	ld	s0,48(sp)
ffffffffc020ad08:	7902                	ld	s2,32(sp)
ffffffffc020ad0a:	69e2                	ld	s3,24(sp)
ffffffffc020ad0c:	6a42                	ld	s4,16(sp)
ffffffffc020ad0e:	6aa2                	ld	s5,8(sp)
ffffffffc020ad10:	8526                	mv	a0,s1
ffffffffc020ad12:	74a2                	ld	s1,40(sp)
ffffffffc020ad14:	6121                	addi	sp,sp,64
ffffffffc020ad16:	8082                	ret
ffffffffc020ad18:	4481                	li	s1,0
ffffffffc020ad1a:	b7d5                	j	ffffffffc020acfe <sfs_wblock+0x42>

ffffffffc020ad1c <sfs_rbuf>:
ffffffffc020ad1c:	7179                	addi	sp,sp,-48
ffffffffc020ad1e:	f406                	sd	ra,40(sp)
ffffffffc020ad20:	f022                	sd	s0,32(sp)
ffffffffc020ad22:	ec26                	sd	s1,24(sp)
ffffffffc020ad24:	e84a                	sd	s2,16(sp)
ffffffffc020ad26:	e44e                	sd	s3,8(sp)
ffffffffc020ad28:	e052                	sd	s4,0(sp)
ffffffffc020ad2a:	6785                	lui	a5,0x1
ffffffffc020ad2c:	04f77863          	bgeu	a4,a5,ffffffffc020ad7c <sfs_rbuf+0x60>
ffffffffc020ad30:	84ba                	mv	s1,a4
ffffffffc020ad32:	9732                	add	a4,a4,a2
ffffffffc020ad34:	89b2                	mv	s3,a2
ffffffffc020ad36:	04e7e363          	bltu	a5,a4,ffffffffc020ad7c <sfs_rbuf+0x60>
ffffffffc020ad3a:	8936                	mv	s2,a3
ffffffffc020ad3c:	842a                	mv	s0,a0
ffffffffc020ad3e:	8a2e                	mv	s4,a1
ffffffffc020ad40:	214000ef          	jal	ra,ffffffffc020af54 <lock_sfs_io>
ffffffffc020ad44:	642c                	ld	a1,72(s0)
ffffffffc020ad46:	864a                	mv	a2,s2
ffffffffc020ad48:	4705                	li	a4,1
ffffffffc020ad4a:	4681                	li	a3,0
ffffffffc020ad4c:	8522                	mv	a0,s0
ffffffffc020ad4e:	eb7ff0ef          	jal	ra,ffffffffc020ac04 <sfs_rwblock_nolock>
ffffffffc020ad52:	892a                	mv	s2,a0
ffffffffc020ad54:	cd09                	beqz	a0,ffffffffc020ad6e <sfs_rbuf+0x52>
ffffffffc020ad56:	8522                	mv	a0,s0
ffffffffc020ad58:	20c000ef          	jal	ra,ffffffffc020af64 <unlock_sfs_io>
ffffffffc020ad5c:	70a2                	ld	ra,40(sp)
ffffffffc020ad5e:	7402                	ld	s0,32(sp)
ffffffffc020ad60:	64e2                	ld	s1,24(sp)
ffffffffc020ad62:	69a2                	ld	s3,8(sp)
ffffffffc020ad64:	6a02                	ld	s4,0(sp)
ffffffffc020ad66:	854a                	mv	a0,s2
ffffffffc020ad68:	6942                	ld	s2,16(sp)
ffffffffc020ad6a:	6145                	addi	sp,sp,48
ffffffffc020ad6c:	8082                	ret
ffffffffc020ad6e:	642c                	ld	a1,72(s0)
ffffffffc020ad70:	864e                	mv	a2,s3
ffffffffc020ad72:	8552                	mv	a0,s4
ffffffffc020ad74:	95a6                	add	a1,a1,s1
ffffffffc020ad76:	77c000ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc020ad7a:	bff1                	j	ffffffffc020ad56 <sfs_rbuf+0x3a>
ffffffffc020ad7c:	00004697          	auipc	a3,0x4
ffffffffc020ad80:	5cc68693          	addi	a3,a3,1484 # ffffffffc020f348 <sfs_node_fileops+0xd0>
ffffffffc020ad84:	00001617          	auipc	a2,0x1
ffffffffc020ad88:	c0460613          	addi	a2,a2,-1020 # ffffffffc020b988 <commands+0x210>
ffffffffc020ad8c:	05500593          	li	a1,85
ffffffffc020ad90:	00004517          	auipc	a0,0x4
ffffffffc020ad94:	5a050513          	addi	a0,a0,1440 # ffffffffc020f330 <sfs_node_fileops+0xb8>
ffffffffc020ad98:	f06f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020ad9c <sfs_wbuf>:
ffffffffc020ad9c:	7139                	addi	sp,sp,-64
ffffffffc020ad9e:	fc06                	sd	ra,56(sp)
ffffffffc020ada0:	f822                	sd	s0,48(sp)
ffffffffc020ada2:	f426                	sd	s1,40(sp)
ffffffffc020ada4:	f04a                	sd	s2,32(sp)
ffffffffc020ada6:	ec4e                	sd	s3,24(sp)
ffffffffc020ada8:	e852                	sd	s4,16(sp)
ffffffffc020adaa:	e456                	sd	s5,8(sp)
ffffffffc020adac:	6785                	lui	a5,0x1
ffffffffc020adae:	06f77163          	bgeu	a4,a5,ffffffffc020ae10 <sfs_wbuf+0x74>
ffffffffc020adb2:	893a                	mv	s2,a4
ffffffffc020adb4:	9732                	add	a4,a4,a2
ffffffffc020adb6:	8a32                	mv	s4,a2
ffffffffc020adb8:	04e7ec63          	bltu	a5,a4,ffffffffc020ae10 <sfs_wbuf+0x74>
ffffffffc020adbc:	842a                	mv	s0,a0
ffffffffc020adbe:	89b6                	mv	s3,a3
ffffffffc020adc0:	8aae                	mv	s5,a1
ffffffffc020adc2:	192000ef          	jal	ra,ffffffffc020af54 <lock_sfs_io>
ffffffffc020adc6:	642c                	ld	a1,72(s0)
ffffffffc020adc8:	4705                	li	a4,1
ffffffffc020adca:	4681                	li	a3,0
ffffffffc020adcc:	864e                	mv	a2,s3
ffffffffc020adce:	8522                	mv	a0,s0
ffffffffc020add0:	e35ff0ef          	jal	ra,ffffffffc020ac04 <sfs_rwblock_nolock>
ffffffffc020add4:	84aa                	mv	s1,a0
ffffffffc020add6:	cd11                	beqz	a0,ffffffffc020adf2 <sfs_wbuf+0x56>
ffffffffc020add8:	8522                	mv	a0,s0
ffffffffc020adda:	18a000ef          	jal	ra,ffffffffc020af64 <unlock_sfs_io>
ffffffffc020adde:	70e2                	ld	ra,56(sp)
ffffffffc020ade0:	7442                	ld	s0,48(sp)
ffffffffc020ade2:	7902                	ld	s2,32(sp)
ffffffffc020ade4:	69e2                	ld	s3,24(sp)
ffffffffc020ade6:	6a42                	ld	s4,16(sp)
ffffffffc020ade8:	6aa2                	ld	s5,8(sp)
ffffffffc020adea:	8526                	mv	a0,s1
ffffffffc020adec:	74a2                	ld	s1,40(sp)
ffffffffc020adee:	6121                	addi	sp,sp,64
ffffffffc020adf0:	8082                	ret
ffffffffc020adf2:	6428                	ld	a0,72(s0)
ffffffffc020adf4:	8652                	mv	a2,s4
ffffffffc020adf6:	85d6                	mv	a1,s5
ffffffffc020adf8:	954a                	add	a0,a0,s2
ffffffffc020adfa:	6f8000ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc020adfe:	642c                	ld	a1,72(s0)
ffffffffc020ae00:	4705                	li	a4,1
ffffffffc020ae02:	4685                	li	a3,1
ffffffffc020ae04:	864e                	mv	a2,s3
ffffffffc020ae06:	8522                	mv	a0,s0
ffffffffc020ae08:	dfdff0ef          	jal	ra,ffffffffc020ac04 <sfs_rwblock_nolock>
ffffffffc020ae0c:	84aa                	mv	s1,a0
ffffffffc020ae0e:	b7e9                	j	ffffffffc020add8 <sfs_wbuf+0x3c>
ffffffffc020ae10:	00004697          	auipc	a3,0x4
ffffffffc020ae14:	53868693          	addi	a3,a3,1336 # ffffffffc020f348 <sfs_node_fileops+0xd0>
ffffffffc020ae18:	00001617          	auipc	a2,0x1
ffffffffc020ae1c:	b7060613          	addi	a2,a2,-1168 # ffffffffc020b988 <commands+0x210>
ffffffffc020ae20:	06b00593          	li	a1,107
ffffffffc020ae24:	00004517          	auipc	a0,0x4
ffffffffc020ae28:	50c50513          	addi	a0,a0,1292 # ffffffffc020f330 <sfs_node_fileops+0xb8>
ffffffffc020ae2c:	e72f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020ae30 <sfs_sync_super>:
ffffffffc020ae30:	1101                	addi	sp,sp,-32
ffffffffc020ae32:	ec06                	sd	ra,24(sp)
ffffffffc020ae34:	e822                	sd	s0,16(sp)
ffffffffc020ae36:	e426                	sd	s1,8(sp)
ffffffffc020ae38:	842a                	mv	s0,a0
ffffffffc020ae3a:	11a000ef          	jal	ra,ffffffffc020af54 <lock_sfs_io>
ffffffffc020ae3e:	6428                	ld	a0,72(s0)
ffffffffc020ae40:	6605                	lui	a2,0x1
ffffffffc020ae42:	4581                	li	a1,0
ffffffffc020ae44:	65c000ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc020ae48:	6428                	ld	a0,72(s0)
ffffffffc020ae4a:	85a2                	mv	a1,s0
ffffffffc020ae4c:	02c00613          	li	a2,44
ffffffffc020ae50:	6a2000ef          	jal	ra,ffffffffc020b4f2 <memcpy>
ffffffffc020ae54:	642c                	ld	a1,72(s0)
ffffffffc020ae56:	4701                	li	a4,0
ffffffffc020ae58:	4685                	li	a3,1
ffffffffc020ae5a:	4601                	li	a2,0
ffffffffc020ae5c:	8522                	mv	a0,s0
ffffffffc020ae5e:	da7ff0ef          	jal	ra,ffffffffc020ac04 <sfs_rwblock_nolock>
ffffffffc020ae62:	84aa                	mv	s1,a0
ffffffffc020ae64:	8522                	mv	a0,s0
ffffffffc020ae66:	0fe000ef          	jal	ra,ffffffffc020af64 <unlock_sfs_io>
ffffffffc020ae6a:	60e2                	ld	ra,24(sp)
ffffffffc020ae6c:	6442                	ld	s0,16(sp)
ffffffffc020ae6e:	8526                	mv	a0,s1
ffffffffc020ae70:	64a2                	ld	s1,8(sp)
ffffffffc020ae72:	6105                	addi	sp,sp,32
ffffffffc020ae74:	8082                	ret

ffffffffc020ae76 <sfs_sync_freemap>:
ffffffffc020ae76:	7139                	addi	sp,sp,-64
ffffffffc020ae78:	ec4e                	sd	s3,24(sp)
ffffffffc020ae7a:	e852                	sd	s4,16(sp)
ffffffffc020ae7c:	00456983          	lwu	s3,4(a0)
ffffffffc020ae80:	8a2a                	mv	s4,a0
ffffffffc020ae82:	7d08                	ld	a0,56(a0)
ffffffffc020ae84:	67a1                	lui	a5,0x8
ffffffffc020ae86:	17fd                	addi	a5,a5,-1
ffffffffc020ae88:	4581                	li	a1,0
ffffffffc020ae8a:	f822                	sd	s0,48(sp)
ffffffffc020ae8c:	fc06                	sd	ra,56(sp)
ffffffffc020ae8e:	f426                	sd	s1,40(sp)
ffffffffc020ae90:	f04a                	sd	s2,32(sp)
ffffffffc020ae92:	e456                	sd	s5,8(sp)
ffffffffc020ae94:	99be                	add	s3,s3,a5
ffffffffc020ae96:	a12fe0ef          	jal	ra,ffffffffc02090a8 <bitmap_getdata>
ffffffffc020ae9a:	00f9d993          	srli	s3,s3,0xf
ffffffffc020ae9e:	842a                	mv	s0,a0
ffffffffc020aea0:	8552                	mv	a0,s4
ffffffffc020aea2:	0b2000ef          	jal	ra,ffffffffc020af54 <lock_sfs_io>
ffffffffc020aea6:	04098163          	beqz	s3,ffffffffc020aee8 <sfs_sync_freemap+0x72>
ffffffffc020aeaa:	09b2                	slli	s3,s3,0xc
ffffffffc020aeac:	99a2                	add	s3,s3,s0
ffffffffc020aeae:	4909                	li	s2,2
ffffffffc020aeb0:	6a85                	lui	s5,0x1
ffffffffc020aeb2:	a021                	j	ffffffffc020aeba <sfs_sync_freemap+0x44>
ffffffffc020aeb4:	2905                	addiw	s2,s2,1
ffffffffc020aeb6:	02898963          	beq	s3,s0,ffffffffc020aee8 <sfs_sync_freemap+0x72>
ffffffffc020aeba:	85a2                	mv	a1,s0
ffffffffc020aebc:	864a                	mv	a2,s2
ffffffffc020aebe:	4705                	li	a4,1
ffffffffc020aec0:	4685                	li	a3,1
ffffffffc020aec2:	8552                	mv	a0,s4
ffffffffc020aec4:	d41ff0ef          	jal	ra,ffffffffc020ac04 <sfs_rwblock_nolock>
ffffffffc020aec8:	84aa                	mv	s1,a0
ffffffffc020aeca:	9456                	add	s0,s0,s5
ffffffffc020aecc:	d565                	beqz	a0,ffffffffc020aeb4 <sfs_sync_freemap+0x3e>
ffffffffc020aece:	8552                	mv	a0,s4
ffffffffc020aed0:	094000ef          	jal	ra,ffffffffc020af64 <unlock_sfs_io>
ffffffffc020aed4:	70e2                	ld	ra,56(sp)
ffffffffc020aed6:	7442                	ld	s0,48(sp)
ffffffffc020aed8:	7902                	ld	s2,32(sp)
ffffffffc020aeda:	69e2                	ld	s3,24(sp)
ffffffffc020aedc:	6a42                	ld	s4,16(sp)
ffffffffc020aede:	6aa2                	ld	s5,8(sp)
ffffffffc020aee0:	8526                	mv	a0,s1
ffffffffc020aee2:	74a2                	ld	s1,40(sp)
ffffffffc020aee4:	6121                	addi	sp,sp,64
ffffffffc020aee6:	8082                	ret
ffffffffc020aee8:	4481                	li	s1,0
ffffffffc020aeea:	b7d5                	j	ffffffffc020aece <sfs_sync_freemap+0x58>

ffffffffc020aeec <sfs_clear_block>:
ffffffffc020aeec:	7179                	addi	sp,sp,-48
ffffffffc020aeee:	f022                	sd	s0,32(sp)
ffffffffc020aef0:	e84a                	sd	s2,16(sp)
ffffffffc020aef2:	e44e                	sd	s3,8(sp)
ffffffffc020aef4:	f406                	sd	ra,40(sp)
ffffffffc020aef6:	89b2                	mv	s3,a2
ffffffffc020aef8:	ec26                	sd	s1,24(sp)
ffffffffc020aefa:	892a                	mv	s2,a0
ffffffffc020aefc:	842e                	mv	s0,a1
ffffffffc020aefe:	056000ef          	jal	ra,ffffffffc020af54 <lock_sfs_io>
ffffffffc020af02:	04893503          	ld	a0,72(s2)
ffffffffc020af06:	6605                	lui	a2,0x1
ffffffffc020af08:	4581                	li	a1,0
ffffffffc020af0a:	596000ef          	jal	ra,ffffffffc020b4a0 <memset>
ffffffffc020af0e:	02098d63          	beqz	s3,ffffffffc020af48 <sfs_clear_block+0x5c>
ffffffffc020af12:	013409bb          	addw	s3,s0,s3
ffffffffc020af16:	a019                	j	ffffffffc020af1c <sfs_clear_block+0x30>
ffffffffc020af18:	02898863          	beq	s3,s0,ffffffffc020af48 <sfs_clear_block+0x5c>
ffffffffc020af1c:	04893583          	ld	a1,72(s2)
ffffffffc020af20:	8622                	mv	a2,s0
ffffffffc020af22:	4705                	li	a4,1
ffffffffc020af24:	4685                	li	a3,1
ffffffffc020af26:	854a                	mv	a0,s2
ffffffffc020af28:	cddff0ef          	jal	ra,ffffffffc020ac04 <sfs_rwblock_nolock>
ffffffffc020af2c:	84aa                	mv	s1,a0
ffffffffc020af2e:	2405                	addiw	s0,s0,1
ffffffffc020af30:	d565                	beqz	a0,ffffffffc020af18 <sfs_clear_block+0x2c>
ffffffffc020af32:	854a                	mv	a0,s2
ffffffffc020af34:	030000ef          	jal	ra,ffffffffc020af64 <unlock_sfs_io>
ffffffffc020af38:	70a2                	ld	ra,40(sp)
ffffffffc020af3a:	7402                	ld	s0,32(sp)
ffffffffc020af3c:	6942                	ld	s2,16(sp)
ffffffffc020af3e:	69a2                	ld	s3,8(sp)
ffffffffc020af40:	8526                	mv	a0,s1
ffffffffc020af42:	64e2                	ld	s1,24(sp)
ffffffffc020af44:	6145                	addi	sp,sp,48
ffffffffc020af46:	8082                	ret
ffffffffc020af48:	4481                	li	s1,0
ffffffffc020af4a:	b7e5                	j	ffffffffc020af32 <sfs_clear_block+0x46>

ffffffffc020af4c <lock_sfs_fs>:
ffffffffc020af4c:	05050513          	addi	a0,a0,80
ffffffffc020af50:	e14f906f          	j	ffffffffc0204564 <down>

ffffffffc020af54 <lock_sfs_io>:
ffffffffc020af54:	06850513          	addi	a0,a0,104
ffffffffc020af58:	e0cf906f          	j	ffffffffc0204564 <down>

ffffffffc020af5c <unlock_sfs_fs>:
ffffffffc020af5c:	05050513          	addi	a0,a0,80
ffffffffc020af60:	e00f906f          	j	ffffffffc0204560 <up>

ffffffffc020af64 <unlock_sfs_io>:
ffffffffc020af64:	06850513          	addi	a0,a0,104
ffffffffc020af68:	df8f906f          	j	ffffffffc0204560 <up>

ffffffffc020af6c <hash32>:
ffffffffc020af6c:	9e3707b7          	lui	a5,0x9e370
ffffffffc020af70:	2785                	addiw	a5,a5,1
ffffffffc020af72:	02a7853b          	mulw	a0,a5,a0
ffffffffc020af76:	02000793          	li	a5,32
ffffffffc020af7a:	9f8d                	subw	a5,a5,a1
ffffffffc020af7c:	00f5553b          	srlw	a0,a0,a5
ffffffffc020af80:	8082                	ret

ffffffffc020af82 <printnum>:
ffffffffc020af82:	02071893          	slli	a7,a4,0x20
ffffffffc020af86:	7139                	addi	sp,sp,-64
ffffffffc020af88:	0208d893          	srli	a7,a7,0x20
ffffffffc020af8c:	e456                	sd	s5,8(sp)
ffffffffc020af8e:	0316fab3          	remu	s5,a3,a7
ffffffffc020af92:	f822                	sd	s0,48(sp)
ffffffffc020af94:	f426                	sd	s1,40(sp)
ffffffffc020af96:	f04a                	sd	s2,32(sp)
ffffffffc020af98:	ec4e                	sd	s3,24(sp)
ffffffffc020af9a:	fc06                	sd	ra,56(sp)
ffffffffc020af9c:	e852                	sd	s4,16(sp)
ffffffffc020af9e:	84aa                	mv	s1,a0
ffffffffc020afa0:	89ae                	mv	s3,a1
ffffffffc020afa2:	8932                	mv	s2,a2
ffffffffc020afa4:	fff7841b          	addiw	s0,a5,-1
ffffffffc020afa8:	2a81                	sext.w	s5,s5
ffffffffc020afaa:	0516f163          	bgeu	a3,a7,ffffffffc020afec <printnum+0x6a>
ffffffffc020afae:	8a42                	mv	s4,a6
ffffffffc020afb0:	00805863          	blez	s0,ffffffffc020afc0 <printnum+0x3e>
ffffffffc020afb4:	347d                	addiw	s0,s0,-1
ffffffffc020afb6:	864e                	mv	a2,s3
ffffffffc020afb8:	85ca                	mv	a1,s2
ffffffffc020afba:	8552                	mv	a0,s4
ffffffffc020afbc:	9482                	jalr	s1
ffffffffc020afbe:	f87d                	bnez	s0,ffffffffc020afb4 <printnum+0x32>
ffffffffc020afc0:	1a82                	slli	s5,s5,0x20
ffffffffc020afc2:	00004797          	auipc	a5,0x4
ffffffffc020afc6:	3ce78793          	addi	a5,a5,974 # ffffffffc020f390 <sfs_node_fileops+0x118>
ffffffffc020afca:	020ada93          	srli	s5,s5,0x20
ffffffffc020afce:	9abe                	add	s5,s5,a5
ffffffffc020afd0:	7442                	ld	s0,48(sp)
ffffffffc020afd2:	000ac503          	lbu	a0,0(s5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc020afd6:	70e2                	ld	ra,56(sp)
ffffffffc020afd8:	6a42                	ld	s4,16(sp)
ffffffffc020afda:	6aa2                	ld	s5,8(sp)
ffffffffc020afdc:	864e                	mv	a2,s3
ffffffffc020afde:	85ca                	mv	a1,s2
ffffffffc020afe0:	69e2                	ld	s3,24(sp)
ffffffffc020afe2:	7902                	ld	s2,32(sp)
ffffffffc020afe4:	87a6                	mv	a5,s1
ffffffffc020afe6:	74a2                	ld	s1,40(sp)
ffffffffc020afe8:	6121                	addi	sp,sp,64
ffffffffc020afea:	8782                	jr	a5
ffffffffc020afec:	0316d6b3          	divu	a3,a3,a7
ffffffffc020aff0:	87a2                	mv	a5,s0
ffffffffc020aff2:	f91ff0ef          	jal	ra,ffffffffc020af82 <printnum>
ffffffffc020aff6:	b7e9                	j	ffffffffc020afc0 <printnum+0x3e>

ffffffffc020aff8 <sprintputch>:
ffffffffc020aff8:	499c                	lw	a5,16(a1)
ffffffffc020affa:	6198                	ld	a4,0(a1)
ffffffffc020affc:	6594                	ld	a3,8(a1)
ffffffffc020affe:	2785                	addiw	a5,a5,1
ffffffffc020b000:	c99c                	sw	a5,16(a1)
ffffffffc020b002:	00d77763          	bgeu	a4,a3,ffffffffc020b010 <sprintputch+0x18>
ffffffffc020b006:	00170793          	addi	a5,a4,1
ffffffffc020b00a:	e19c                	sd	a5,0(a1)
ffffffffc020b00c:	00a70023          	sb	a0,0(a4)
ffffffffc020b010:	8082                	ret

ffffffffc020b012 <vprintfmt>:
ffffffffc020b012:	7119                	addi	sp,sp,-128
ffffffffc020b014:	f4a6                	sd	s1,104(sp)
ffffffffc020b016:	f0ca                	sd	s2,96(sp)
ffffffffc020b018:	ecce                	sd	s3,88(sp)
ffffffffc020b01a:	e8d2                	sd	s4,80(sp)
ffffffffc020b01c:	e4d6                	sd	s5,72(sp)
ffffffffc020b01e:	e0da                	sd	s6,64(sp)
ffffffffc020b020:	fc5e                	sd	s7,56(sp)
ffffffffc020b022:	ec6e                	sd	s11,24(sp)
ffffffffc020b024:	fc86                	sd	ra,120(sp)
ffffffffc020b026:	f8a2                	sd	s0,112(sp)
ffffffffc020b028:	f862                	sd	s8,48(sp)
ffffffffc020b02a:	f466                	sd	s9,40(sp)
ffffffffc020b02c:	f06a                	sd	s10,32(sp)
ffffffffc020b02e:	89aa                	mv	s3,a0
ffffffffc020b030:	892e                	mv	s2,a1
ffffffffc020b032:	84b2                	mv	s1,a2
ffffffffc020b034:	8db6                	mv	s11,a3
ffffffffc020b036:	8aba                	mv	s5,a4
ffffffffc020b038:	02500a13          	li	s4,37
ffffffffc020b03c:	5bfd                	li	s7,-1
ffffffffc020b03e:	00004b17          	auipc	s6,0x4
ffffffffc020b042:	37eb0b13          	addi	s6,s6,894 # ffffffffc020f3bc <sfs_node_fileops+0x144>
ffffffffc020b046:	000dc503          	lbu	a0,0(s11) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc020b04a:	001d8413          	addi	s0,s11,1
ffffffffc020b04e:	01450b63          	beq	a0,s4,ffffffffc020b064 <vprintfmt+0x52>
ffffffffc020b052:	c129                	beqz	a0,ffffffffc020b094 <vprintfmt+0x82>
ffffffffc020b054:	864a                	mv	a2,s2
ffffffffc020b056:	85a6                	mv	a1,s1
ffffffffc020b058:	0405                	addi	s0,s0,1
ffffffffc020b05a:	9982                	jalr	s3
ffffffffc020b05c:	fff44503          	lbu	a0,-1(s0)
ffffffffc020b060:	ff4519e3          	bne	a0,s4,ffffffffc020b052 <vprintfmt+0x40>
ffffffffc020b064:	00044583          	lbu	a1,0(s0)
ffffffffc020b068:	02000813          	li	a6,32
ffffffffc020b06c:	4d01                	li	s10,0
ffffffffc020b06e:	4301                	li	t1,0
ffffffffc020b070:	5cfd                	li	s9,-1
ffffffffc020b072:	5c7d                	li	s8,-1
ffffffffc020b074:	05500513          	li	a0,85
ffffffffc020b078:	48a5                	li	a7,9
ffffffffc020b07a:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b07e:	0ff67613          	zext.b	a2,a2
ffffffffc020b082:	00140d93          	addi	s11,s0,1
ffffffffc020b086:	04c56263          	bltu	a0,a2,ffffffffc020b0ca <vprintfmt+0xb8>
ffffffffc020b08a:	060a                	slli	a2,a2,0x2
ffffffffc020b08c:	965a                	add	a2,a2,s6
ffffffffc020b08e:	4214                	lw	a3,0(a2)
ffffffffc020b090:	96da                	add	a3,a3,s6
ffffffffc020b092:	8682                	jr	a3
ffffffffc020b094:	70e6                	ld	ra,120(sp)
ffffffffc020b096:	7446                	ld	s0,112(sp)
ffffffffc020b098:	74a6                	ld	s1,104(sp)
ffffffffc020b09a:	7906                	ld	s2,96(sp)
ffffffffc020b09c:	69e6                	ld	s3,88(sp)
ffffffffc020b09e:	6a46                	ld	s4,80(sp)
ffffffffc020b0a0:	6aa6                	ld	s5,72(sp)
ffffffffc020b0a2:	6b06                	ld	s6,64(sp)
ffffffffc020b0a4:	7be2                	ld	s7,56(sp)
ffffffffc020b0a6:	7c42                	ld	s8,48(sp)
ffffffffc020b0a8:	7ca2                	ld	s9,40(sp)
ffffffffc020b0aa:	7d02                	ld	s10,32(sp)
ffffffffc020b0ac:	6de2                	ld	s11,24(sp)
ffffffffc020b0ae:	6109                	addi	sp,sp,128
ffffffffc020b0b0:	8082                	ret
ffffffffc020b0b2:	882e                	mv	a6,a1
ffffffffc020b0b4:	00144583          	lbu	a1,1(s0)
ffffffffc020b0b8:	846e                	mv	s0,s11
ffffffffc020b0ba:	00140d93          	addi	s11,s0,1
ffffffffc020b0be:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b0c2:	0ff67613          	zext.b	a2,a2
ffffffffc020b0c6:	fcc572e3          	bgeu	a0,a2,ffffffffc020b08a <vprintfmt+0x78>
ffffffffc020b0ca:	864a                	mv	a2,s2
ffffffffc020b0cc:	85a6                	mv	a1,s1
ffffffffc020b0ce:	02500513          	li	a0,37
ffffffffc020b0d2:	9982                	jalr	s3
ffffffffc020b0d4:	fff44783          	lbu	a5,-1(s0)
ffffffffc020b0d8:	8da2                	mv	s11,s0
ffffffffc020b0da:	f74786e3          	beq	a5,s4,ffffffffc020b046 <vprintfmt+0x34>
ffffffffc020b0de:	ffedc783          	lbu	a5,-2(s11)
ffffffffc020b0e2:	1dfd                	addi	s11,s11,-1
ffffffffc020b0e4:	ff479de3          	bne	a5,s4,ffffffffc020b0de <vprintfmt+0xcc>
ffffffffc020b0e8:	bfb9                	j	ffffffffc020b046 <vprintfmt+0x34>
ffffffffc020b0ea:	fd058c9b          	addiw	s9,a1,-48
ffffffffc020b0ee:	00144583          	lbu	a1,1(s0)
ffffffffc020b0f2:	846e                	mv	s0,s11
ffffffffc020b0f4:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b0f8:	0005861b          	sext.w	a2,a1
ffffffffc020b0fc:	02d8e463          	bltu	a7,a3,ffffffffc020b124 <vprintfmt+0x112>
ffffffffc020b100:	00144583          	lbu	a1,1(s0)
ffffffffc020b104:	002c969b          	slliw	a3,s9,0x2
ffffffffc020b108:	0196873b          	addw	a4,a3,s9
ffffffffc020b10c:	0017171b          	slliw	a4,a4,0x1
ffffffffc020b110:	9f31                	addw	a4,a4,a2
ffffffffc020b112:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b116:	0405                	addi	s0,s0,1
ffffffffc020b118:	fd070c9b          	addiw	s9,a4,-48
ffffffffc020b11c:	0005861b          	sext.w	a2,a1
ffffffffc020b120:	fed8f0e3          	bgeu	a7,a3,ffffffffc020b100 <vprintfmt+0xee>
ffffffffc020b124:	f40c5be3          	bgez	s8,ffffffffc020b07a <vprintfmt+0x68>
ffffffffc020b128:	8c66                	mv	s8,s9
ffffffffc020b12a:	5cfd                	li	s9,-1
ffffffffc020b12c:	b7b9                	j	ffffffffc020b07a <vprintfmt+0x68>
ffffffffc020b12e:	fffc4693          	not	a3,s8
ffffffffc020b132:	96fd                	srai	a3,a3,0x3f
ffffffffc020b134:	00dc77b3          	and	a5,s8,a3
ffffffffc020b138:	00144583          	lbu	a1,1(s0)
ffffffffc020b13c:	00078c1b          	sext.w	s8,a5
ffffffffc020b140:	846e                	mv	s0,s11
ffffffffc020b142:	bf25                	j	ffffffffc020b07a <vprintfmt+0x68>
ffffffffc020b144:	000aac83          	lw	s9,0(s5)
ffffffffc020b148:	00144583          	lbu	a1,1(s0)
ffffffffc020b14c:	0aa1                	addi	s5,s5,8
ffffffffc020b14e:	846e                	mv	s0,s11
ffffffffc020b150:	bfd1                	j	ffffffffc020b124 <vprintfmt+0x112>
ffffffffc020b152:	4705                	li	a4,1
ffffffffc020b154:	008a8613          	addi	a2,s5,8
ffffffffc020b158:	00674463          	blt	a4,t1,ffffffffc020b160 <vprintfmt+0x14e>
ffffffffc020b15c:	1c030c63          	beqz	t1,ffffffffc020b334 <vprintfmt+0x322>
ffffffffc020b160:	000ab683          	ld	a3,0(s5)
ffffffffc020b164:	4741                	li	a4,16
ffffffffc020b166:	8ab2                	mv	s5,a2
ffffffffc020b168:	2801                	sext.w	a6,a6
ffffffffc020b16a:	87e2                	mv	a5,s8
ffffffffc020b16c:	8626                	mv	a2,s1
ffffffffc020b16e:	85ca                	mv	a1,s2
ffffffffc020b170:	854e                	mv	a0,s3
ffffffffc020b172:	e11ff0ef          	jal	ra,ffffffffc020af82 <printnum>
ffffffffc020b176:	bdc1                	j	ffffffffc020b046 <vprintfmt+0x34>
ffffffffc020b178:	000aa503          	lw	a0,0(s5)
ffffffffc020b17c:	864a                	mv	a2,s2
ffffffffc020b17e:	85a6                	mv	a1,s1
ffffffffc020b180:	0aa1                	addi	s5,s5,8
ffffffffc020b182:	9982                	jalr	s3
ffffffffc020b184:	b5c9                	j	ffffffffc020b046 <vprintfmt+0x34>
ffffffffc020b186:	4705                	li	a4,1
ffffffffc020b188:	008a8613          	addi	a2,s5,8
ffffffffc020b18c:	00674463          	blt	a4,t1,ffffffffc020b194 <vprintfmt+0x182>
ffffffffc020b190:	18030d63          	beqz	t1,ffffffffc020b32a <vprintfmt+0x318>
ffffffffc020b194:	000ab683          	ld	a3,0(s5)
ffffffffc020b198:	4729                	li	a4,10
ffffffffc020b19a:	8ab2                	mv	s5,a2
ffffffffc020b19c:	b7f1                	j	ffffffffc020b168 <vprintfmt+0x156>
ffffffffc020b19e:	00144583          	lbu	a1,1(s0)
ffffffffc020b1a2:	4d05                	li	s10,1
ffffffffc020b1a4:	846e                	mv	s0,s11
ffffffffc020b1a6:	bdd1                	j	ffffffffc020b07a <vprintfmt+0x68>
ffffffffc020b1a8:	864a                	mv	a2,s2
ffffffffc020b1aa:	85a6                	mv	a1,s1
ffffffffc020b1ac:	02500513          	li	a0,37
ffffffffc020b1b0:	9982                	jalr	s3
ffffffffc020b1b2:	bd51                	j	ffffffffc020b046 <vprintfmt+0x34>
ffffffffc020b1b4:	00144583          	lbu	a1,1(s0)
ffffffffc020b1b8:	2305                	addiw	t1,t1,1
ffffffffc020b1ba:	846e                	mv	s0,s11
ffffffffc020b1bc:	bd7d                	j	ffffffffc020b07a <vprintfmt+0x68>
ffffffffc020b1be:	4705                	li	a4,1
ffffffffc020b1c0:	008a8613          	addi	a2,s5,8
ffffffffc020b1c4:	00674463          	blt	a4,t1,ffffffffc020b1cc <vprintfmt+0x1ba>
ffffffffc020b1c8:	14030c63          	beqz	t1,ffffffffc020b320 <vprintfmt+0x30e>
ffffffffc020b1cc:	000ab683          	ld	a3,0(s5)
ffffffffc020b1d0:	4721                	li	a4,8
ffffffffc020b1d2:	8ab2                	mv	s5,a2
ffffffffc020b1d4:	bf51                	j	ffffffffc020b168 <vprintfmt+0x156>
ffffffffc020b1d6:	03000513          	li	a0,48
ffffffffc020b1da:	864a                	mv	a2,s2
ffffffffc020b1dc:	85a6                	mv	a1,s1
ffffffffc020b1de:	e042                	sd	a6,0(sp)
ffffffffc020b1e0:	9982                	jalr	s3
ffffffffc020b1e2:	864a                	mv	a2,s2
ffffffffc020b1e4:	85a6                	mv	a1,s1
ffffffffc020b1e6:	07800513          	li	a0,120
ffffffffc020b1ea:	9982                	jalr	s3
ffffffffc020b1ec:	0aa1                	addi	s5,s5,8
ffffffffc020b1ee:	6802                	ld	a6,0(sp)
ffffffffc020b1f0:	4741                	li	a4,16
ffffffffc020b1f2:	ff8ab683          	ld	a3,-8(s5)
ffffffffc020b1f6:	bf8d                	j	ffffffffc020b168 <vprintfmt+0x156>
ffffffffc020b1f8:	000ab403          	ld	s0,0(s5)
ffffffffc020b1fc:	008a8793          	addi	a5,s5,8
ffffffffc020b200:	e03e                	sd	a5,0(sp)
ffffffffc020b202:	14040c63          	beqz	s0,ffffffffc020b35a <vprintfmt+0x348>
ffffffffc020b206:	11805063          	blez	s8,ffffffffc020b306 <vprintfmt+0x2f4>
ffffffffc020b20a:	02d00693          	li	a3,45
ffffffffc020b20e:	0cd81963          	bne	a6,a3,ffffffffc020b2e0 <vprintfmt+0x2ce>
ffffffffc020b212:	00044683          	lbu	a3,0(s0)
ffffffffc020b216:	0006851b          	sext.w	a0,a3
ffffffffc020b21a:	ce8d                	beqz	a3,ffffffffc020b254 <vprintfmt+0x242>
ffffffffc020b21c:	00140a93          	addi	s5,s0,1
ffffffffc020b220:	05e00413          	li	s0,94
ffffffffc020b224:	000cc563          	bltz	s9,ffffffffc020b22e <vprintfmt+0x21c>
ffffffffc020b228:	3cfd                	addiw	s9,s9,-1
ffffffffc020b22a:	037c8363          	beq	s9,s7,ffffffffc020b250 <vprintfmt+0x23e>
ffffffffc020b22e:	864a                	mv	a2,s2
ffffffffc020b230:	85a6                	mv	a1,s1
ffffffffc020b232:	100d0663          	beqz	s10,ffffffffc020b33e <vprintfmt+0x32c>
ffffffffc020b236:	3681                	addiw	a3,a3,-32
ffffffffc020b238:	10d47363          	bgeu	s0,a3,ffffffffc020b33e <vprintfmt+0x32c>
ffffffffc020b23c:	03f00513          	li	a0,63
ffffffffc020b240:	9982                	jalr	s3
ffffffffc020b242:	000ac683          	lbu	a3,0(s5)
ffffffffc020b246:	3c7d                	addiw	s8,s8,-1
ffffffffc020b248:	0a85                	addi	s5,s5,1
ffffffffc020b24a:	0006851b          	sext.w	a0,a3
ffffffffc020b24e:	faf9                	bnez	a3,ffffffffc020b224 <vprintfmt+0x212>
ffffffffc020b250:	01805a63          	blez	s8,ffffffffc020b264 <vprintfmt+0x252>
ffffffffc020b254:	3c7d                	addiw	s8,s8,-1
ffffffffc020b256:	864a                	mv	a2,s2
ffffffffc020b258:	85a6                	mv	a1,s1
ffffffffc020b25a:	02000513          	li	a0,32
ffffffffc020b25e:	9982                	jalr	s3
ffffffffc020b260:	fe0c1ae3          	bnez	s8,ffffffffc020b254 <vprintfmt+0x242>
ffffffffc020b264:	6a82                	ld	s5,0(sp)
ffffffffc020b266:	b3c5                	j	ffffffffc020b046 <vprintfmt+0x34>
ffffffffc020b268:	4705                	li	a4,1
ffffffffc020b26a:	008a8d13          	addi	s10,s5,8
ffffffffc020b26e:	00674463          	blt	a4,t1,ffffffffc020b276 <vprintfmt+0x264>
ffffffffc020b272:	0a030463          	beqz	t1,ffffffffc020b31a <vprintfmt+0x308>
ffffffffc020b276:	000ab403          	ld	s0,0(s5)
ffffffffc020b27a:	0c044463          	bltz	s0,ffffffffc020b342 <vprintfmt+0x330>
ffffffffc020b27e:	86a2                	mv	a3,s0
ffffffffc020b280:	8aea                	mv	s5,s10
ffffffffc020b282:	4729                	li	a4,10
ffffffffc020b284:	b5d5                	j	ffffffffc020b168 <vprintfmt+0x156>
ffffffffc020b286:	000aa783          	lw	a5,0(s5)
ffffffffc020b28a:	46e1                	li	a3,24
ffffffffc020b28c:	0aa1                	addi	s5,s5,8
ffffffffc020b28e:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020b292:	8fb9                	xor	a5,a5,a4
ffffffffc020b294:	40e7873b          	subw	a4,a5,a4
ffffffffc020b298:	02e6c663          	blt	a3,a4,ffffffffc020b2c4 <vprintfmt+0x2b2>
ffffffffc020b29c:	00371793          	slli	a5,a4,0x3
ffffffffc020b2a0:	00004697          	auipc	a3,0x4
ffffffffc020b2a4:	45068693          	addi	a3,a3,1104 # ffffffffc020f6f0 <error_string>
ffffffffc020b2a8:	97b6                	add	a5,a5,a3
ffffffffc020b2aa:	639c                	ld	a5,0(a5)
ffffffffc020b2ac:	cf81                	beqz	a5,ffffffffc020b2c4 <vprintfmt+0x2b2>
ffffffffc020b2ae:	873e                	mv	a4,a5
ffffffffc020b2b0:	00000697          	auipc	a3,0x0
ffffffffc020b2b4:	28868693          	addi	a3,a3,648 # ffffffffc020b538 <etext+0x2e>
ffffffffc020b2b8:	8626                	mv	a2,s1
ffffffffc020b2ba:	85ca                	mv	a1,s2
ffffffffc020b2bc:	854e                	mv	a0,s3
ffffffffc020b2be:	0d4000ef          	jal	ra,ffffffffc020b392 <printfmt>
ffffffffc020b2c2:	b351                	j	ffffffffc020b046 <vprintfmt+0x34>
ffffffffc020b2c4:	00004697          	auipc	a3,0x4
ffffffffc020b2c8:	0ec68693          	addi	a3,a3,236 # ffffffffc020f3b0 <sfs_node_fileops+0x138>
ffffffffc020b2cc:	8626                	mv	a2,s1
ffffffffc020b2ce:	85ca                	mv	a1,s2
ffffffffc020b2d0:	854e                	mv	a0,s3
ffffffffc020b2d2:	0c0000ef          	jal	ra,ffffffffc020b392 <printfmt>
ffffffffc020b2d6:	bb85                	j	ffffffffc020b046 <vprintfmt+0x34>
ffffffffc020b2d8:	00004417          	auipc	s0,0x4
ffffffffc020b2dc:	0d040413          	addi	s0,s0,208 # ffffffffc020f3a8 <sfs_node_fileops+0x130>
ffffffffc020b2e0:	85e6                	mv	a1,s9
ffffffffc020b2e2:	8522                	mv	a0,s0
ffffffffc020b2e4:	e442                	sd	a6,8(sp)
ffffffffc020b2e6:	132000ef          	jal	ra,ffffffffc020b418 <strnlen>
ffffffffc020b2ea:	40ac0c3b          	subw	s8,s8,a0
ffffffffc020b2ee:	01805c63          	blez	s8,ffffffffc020b306 <vprintfmt+0x2f4>
ffffffffc020b2f2:	6822                	ld	a6,8(sp)
ffffffffc020b2f4:	00080a9b          	sext.w	s5,a6
ffffffffc020b2f8:	3c7d                	addiw	s8,s8,-1
ffffffffc020b2fa:	864a                	mv	a2,s2
ffffffffc020b2fc:	85a6                	mv	a1,s1
ffffffffc020b2fe:	8556                	mv	a0,s5
ffffffffc020b300:	9982                	jalr	s3
ffffffffc020b302:	fe0c1be3          	bnez	s8,ffffffffc020b2f8 <vprintfmt+0x2e6>
ffffffffc020b306:	00044683          	lbu	a3,0(s0)
ffffffffc020b30a:	00140a93          	addi	s5,s0,1
ffffffffc020b30e:	0006851b          	sext.w	a0,a3
ffffffffc020b312:	daa9                	beqz	a3,ffffffffc020b264 <vprintfmt+0x252>
ffffffffc020b314:	05e00413          	li	s0,94
ffffffffc020b318:	b731                	j	ffffffffc020b224 <vprintfmt+0x212>
ffffffffc020b31a:	000aa403          	lw	s0,0(s5)
ffffffffc020b31e:	bfb1                	j	ffffffffc020b27a <vprintfmt+0x268>
ffffffffc020b320:	000ae683          	lwu	a3,0(s5)
ffffffffc020b324:	4721                	li	a4,8
ffffffffc020b326:	8ab2                	mv	s5,a2
ffffffffc020b328:	b581                	j	ffffffffc020b168 <vprintfmt+0x156>
ffffffffc020b32a:	000ae683          	lwu	a3,0(s5)
ffffffffc020b32e:	4729                	li	a4,10
ffffffffc020b330:	8ab2                	mv	s5,a2
ffffffffc020b332:	bd1d                	j	ffffffffc020b168 <vprintfmt+0x156>
ffffffffc020b334:	000ae683          	lwu	a3,0(s5)
ffffffffc020b338:	4741                	li	a4,16
ffffffffc020b33a:	8ab2                	mv	s5,a2
ffffffffc020b33c:	b535                	j	ffffffffc020b168 <vprintfmt+0x156>
ffffffffc020b33e:	9982                	jalr	s3
ffffffffc020b340:	b709                	j	ffffffffc020b242 <vprintfmt+0x230>
ffffffffc020b342:	864a                	mv	a2,s2
ffffffffc020b344:	85a6                	mv	a1,s1
ffffffffc020b346:	02d00513          	li	a0,45
ffffffffc020b34a:	e042                	sd	a6,0(sp)
ffffffffc020b34c:	9982                	jalr	s3
ffffffffc020b34e:	6802                	ld	a6,0(sp)
ffffffffc020b350:	8aea                	mv	s5,s10
ffffffffc020b352:	408006b3          	neg	a3,s0
ffffffffc020b356:	4729                	li	a4,10
ffffffffc020b358:	bd01                	j	ffffffffc020b168 <vprintfmt+0x156>
ffffffffc020b35a:	03805163          	blez	s8,ffffffffc020b37c <vprintfmt+0x36a>
ffffffffc020b35e:	02d00693          	li	a3,45
ffffffffc020b362:	f6d81be3          	bne	a6,a3,ffffffffc020b2d8 <vprintfmt+0x2c6>
ffffffffc020b366:	00004417          	auipc	s0,0x4
ffffffffc020b36a:	04240413          	addi	s0,s0,66 # ffffffffc020f3a8 <sfs_node_fileops+0x130>
ffffffffc020b36e:	02800693          	li	a3,40
ffffffffc020b372:	02800513          	li	a0,40
ffffffffc020b376:	00140a93          	addi	s5,s0,1
ffffffffc020b37a:	b55d                	j	ffffffffc020b220 <vprintfmt+0x20e>
ffffffffc020b37c:	00004a97          	auipc	s5,0x4
ffffffffc020b380:	02da8a93          	addi	s5,s5,45 # ffffffffc020f3a9 <sfs_node_fileops+0x131>
ffffffffc020b384:	02800513          	li	a0,40
ffffffffc020b388:	02800693          	li	a3,40
ffffffffc020b38c:	05e00413          	li	s0,94
ffffffffc020b390:	bd51                	j	ffffffffc020b224 <vprintfmt+0x212>

ffffffffc020b392 <printfmt>:
ffffffffc020b392:	7139                	addi	sp,sp,-64
ffffffffc020b394:	02010313          	addi	t1,sp,32
ffffffffc020b398:	f03a                	sd	a4,32(sp)
ffffffffc020b39a:	871a                	mv	a4,t1
ffffffffc020b39c:	ec06                	sd	ra,24(sp)
ffffffffc020b39e:	f43e                	sd	a5,40(sp)
ffffffffc020b3a0:	f842                	sd	a6,48(sp)
ffffffffc020b3a2:	fc46                	sd	a7,56(sp)
ffffffffc020b3a4:	e41a                	sd	t1,8(sp)
ffffffffc020b3a6:	c6dff0ef          	jal	ra,ffffffffc020b012 <vprintfmt>
ffffffffc020b3aa:	60e2                	ld	ra,24(sp)
ffffffffc020b3ac:	6121                	addi	sp,sp,64
ffffffffc020b3ae:	8082                	ret

ffffffffc020b3b0 <snprintf>:
ffffffffc020b3b0:	711d                	addi	sp,sp,-96
ffffffffc020b3b2:	15fd                	addi	a1,a1,-1
ffffffffc020b3b4:	03810313          	addi	t1,sp,56
ffffffffc020b3b8:	95aa                	add	a1,a1,a0
ffffffffc020b3ba:	f406                	sd	ra,40(sp)
ffffffffc020b3bc:	fc36                	sd	a3,56(sp)
ffffffffc020b3be:	e0ba                	sd	a4,64(sp)
ffffffffc020b3c0:	e4be                	sd	a5,72(sp)
ffffffffc020b3c2:	e8c2                	sd	a6,80(sp)
ffffffffc020b3c4:	ecc6                	sd	a7,88(sp)
ffffffffc020b3c6:	e01a                	sd	t1,0(sp)
ffffffffc020b3c8:	e42a                	sd	a0,8(sp)
ffffffffc020b3ca:	e82e                	sd	a1,16(sp)
ffffffffc020b3cc:	cc02                	sw	zero,24(sp)
ffffffffc020b3ce:	c515                	beqz	a0,ffffffffc020b3fa <snprintf+0x4a>
ffffffffc020b3d0:	02a5e563          	bltu	a1,a0,ffffffffc020b3fa <snprintf+0x4a>
ffffffffc020b3d4:	75dd                	lui	a1,0xffff7
ffffffffc020b3d6:	86b2                	mv	a3,a2
ffffffffc020b3d8:	00000517          	auipc	a0,0x0
ffffffffc020b3dc:	c2050513          	addi	a0,a0,-992 # ffffffffc020aff8 <sprintputch>
ffffffffc020b3e0:	871a                	mv	a4,t1
ffffffffc020b3e2:	0030                	addi	a2,sp,8
ffffffffc020b3e4:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020b3e8:	c2bff0ef          	jal	ra,ffffffffc020b012 <vprintfmt>
ffffffffc020b3ec:	67a2                	ld	a5,8(sp)
ffffffffc020b3ee:	00078023          	sb	zero,0(a5)
ffffffffc020b3f2:	4562                	lw	a0,24(sp)
ffffffffc020b3f4:	70a2                	ld	ra,40(sp)
ffffffffc020b3f6:	6125                	addi	sp,sp,96
ffffffffc020b3f8:	8082                	ret
ffffffffc020b3fa:	5575                	li	a0,-3
ffffffffc020b3fc:	bfe5                	j	ffffffffc020b3f4 <snprintf+0x44>

ffffffffc020b3fe <strlen>:
ffffffffc020b3fe:	00054783          	lbu	a5,0(a0)
ffffffffc020b402:	872a                	mv	a4,a0
ffffffffc020b404:	4501                	li	a0,0
ffffffffc020b406:	cb81                	beqz	a5,ffffffffc020b416 <strlen+0x18>
ffffffffc020b408:	0505                	addi	a0,a0,1
ffffffffc020b40a:	00a707b3          	add	a5,a4,a0
ffffffffc020b40e:	0007c783          	lbu	a5,0(a5)
ffffffffc020b412:	fbfd                	bnez	a5,ffffffffc020b408 <strlen+0xa>
ffffffffc020b414:	8082                	ret
ffffffffc020b416:	8082                	ret

ffffffffc020b418 <strnlen>:
ffffffffc020b418:	4781                	li	a5,0
ffffffffc020b41a:	e589                	bnez	a1,ffffffffc020b424 <strnlen+0xc>
ffffffffc020b41c:	a811                	j	ffffffffc020b430 <strnlen+0x18>
ffffffffc020b41e:	0785                	addi	a5,a5,1
ffffffffc020b420:	00f58863          	beq	a1,a5,ffffffffc020b430 <strnlen+0x18>
ffffffffc020b424:	00f50733          	add	a4,a0,a5
ffffffffc020b428:	00074703          	lbu	a4,0(a4)
ffffffffc020b42c:	fb6d                	bnez	a4,ffffffffc020b41e <strnlen+0x6>
ffffffffc020b42e:	85be                	mv	a1,a5
ffffffffc020b430:	852e                	mv	a0,a1
ffffffffc020b432:	8082                	ret

ffffffffc020b434 <strcpy>:
ffffffffc020b434:	87aa                	mv	a5,a0
ffffffffc020b436:	0005c703          	lbu	a4,0(a1)
ffffffffc020b43a:	0785                	addi	a5,a5,1
ffffffffc020b43c:	0585                	addi	a1,a1,1
ffffffffc020b43e:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b442:	fb75                	bnez	a4,ffffffffc020b436 <strcpy+0x2>
ffffffffc020b444:	8082                	ret

ffffffffc020b446 <strcmp>:
ffffffffc020b446:	00054783          	lbu	a5,0(a0)
ffffffffc020b44a:	0005c703          	lbu	a4,0(a1)
ffffffffc020b44e:	cb89                	beqz	a5,ffffffffc020b460 <strcmp+0x1a>
ffffffffc020b450:	0505                	addi	a0,a0,1
ffffffffc020b452:	0585                	addi	a1,a1,1
ffffffffc020b454:	fee789e3          	beq	a5,a4,ffffffffc020b446 <strcmp>
ffffffffc020b458:	0007851b          	sext.w	a0,a5
ffffffffc020b45c:	9d19                	subw	a0,a0,a4
ffffffffc020b45e:	8082                	ret
ffffffffc020b460:	4501                	li	a0,0
ffffffffc020b462:	bfed                	j	ffffffffc020b45c <strcmp+0x16>

ffffffffc020b464 <strncmp>:
ffffffffc020b464:	c20d                	beqz	a2,ffffffffc020b486 <strncmp+0x22>
ffffffffc020b466:	962e                	add	a2,a2,a1
ffffffffc020b468:	a031                	j	ffffffffc020b474 <strncmp+0x10>
ffffffffc020b46a:	0505                	addi	a0,a0,1
ffffffffc020b46c:	00e79a63          	bne	a5,a4,ffffffffc020b480 <strncmp+0x1c>
ffffffffc020b470:	00b60b63          	beq	a2,a1,ffffffffc020b486 <strncmp+0x22>
ffffffffc020b474:	00054783          	lbu	a5,0(a0)
ffffffffc020b478:	0585                	addi	a1,a1,1
ffffffffc020b47a:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020b47e:	f7f5                	bnez	a5,ffffffffc020b46a <strncmp+0x6>
ffffffffc020b480:	40e7853b          	subw	a0,a5,a4
ffffffffc020b484:	8082                	ret
ffffffffc020b486:	4501                	li	a0,0
ffffffffc020b488:	8082                	ret

ffffffffc020b48a <strchr>:
ffffffffc020b48a:	00054783          	lbu	a5,0(a0)
ffffffffc020b48e:	c799                	beqz	a5,ffffffffc020b49c <strchr+0x12>
ffffffffc020b490:	00f58763          	beq	a1,a5,ffffffffc020b49e <strchr+0x14>
ffffffffc020b494:	00154783          	lbu	a5,1(a0)
ffffffffc020b498:	0505                	addi	a0,a0,1
ffffffffc020b49a:	fbfd                	bnez	a5,ffffffffc020b490 <strchr+0x6>
ffffffffc020b49c:	4501                	li	a0,0
ffffffffc020b49e:	8082                	ret

ffffffffc020b4a0 <memset>:
ffffffffc020b4a0:	ca01                	beqz	a2,ffffffffc020b4b0 <memset+0x10>
ffffffffc020b4a2:	962a                	add	a2,a2,a0
ffffffffc020b4a4:	87aa                	mv	a5,a0
ffffffffc020b4a6:	0785                	addi	a5,a5,1
ffffffffc020b4a8:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020b4ac:	fec79de3          	bne	a5,a2,ffffffffc020b4a6 <memset+0x6>
ffffffffc020b4b0:	8082                	ret

ffffffffc020b4b2 <memmove>:
ffffffffc020b4b2:	02a5f263          	bgeu	a1,a0,ffffffffc020b4d6 <memmove+0x24>
ffffffffc020b4b6:	00c587b3          	add	a5,a1,a2
ffffffffc020b4ba:	00f57e63          	bgeu	a0,a5,ffffffffc020b4d6 <memmove+0x24>
ffffffffc020b4be:	00c50733          	add	a4,a0,a2
ffffffffc020b4c2:	c615                	beqz	a2,ffffffffc020b4ee <memmove+0x3c>
ffffffffc020b4c4:	fff7c683          	lbu	a3,-1(a5)
ffffffffc020b4c8:	17fd                	addi	a5,a5,-1
ffffffffc020b4ca:	177d                	addi	a4,a4,-1
ffffffffc020b4cc:	00d70023          	sb	a3,0(a4)
ffffffffc020b4d0:	fef59ae3          	bne	a1,a5,ffffffffc020b4c4 <memmove+0x12>
ffffffffc020b4d4:	8082                	ret
ffffffffc020b4d6:	00c586b3          	add	a3,a1,a2
ffffffffc020b4da:	87aa                	mv	a5,a0
ffffffffc020b4dc:	ca11                	beqz	a2,ffffffffc020b4f0 <memmove+0x3e>
ffffffffc020b4de:	0005c703          	lbu	a4,0(a1)
ffffffffc020b4e2:	0585                	addi	a1,a1,1
ffffffffc020b4e4:	0785                	addi	a5,a5,1
ffffffffc020b4e6:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b4ea:	fed59ae3          	bne	a1,a3,ffffffffc020b4de <memmove+0x2c>
ffffffffc020b4ee:	8082                	ret
ffffffffc020b4f0:	8082                	ret

ffffffffc020b4f2 <memcpy>:
ffffffffc020b4f2:	ca19                	beqz	a2,ffffffffc020b508 <memcpy+0x16>
ffffffffc020b4f4:	962e                	add	a2,a2,a1
ffffffffc020b4f6:	87aa                	mv	a5,a0
ffffffffc020b4f8:	0005c703          	lbu	a4,0(a1)
ffffffffc020b4fc:	0585                	addi	a1,a1,1
ffffffffc020b4fe:	0785                	addi	a5,a5,1
ffffffffc020b500:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b504:	fec59ae3          	bne	a1,a2,ffffffffc020b4f8 <memcpy+0x6>
ffffffffc020b508:	8082                	ret
