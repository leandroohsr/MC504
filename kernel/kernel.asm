
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	92013103          	ld	sp,-1760(sp) # 80007920 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	add	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	add	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	or	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	sll	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	or	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	add	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	add	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffcbc5f>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	d9478793          	add	a5,a5,-620 # 80000e14 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srl	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	add	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	add	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	fc26                	sd	s1,56(sp)
    800000d8:	f84a                	sd	s2,48(sp)
    800000da:	f44e                	sd	s3,40(sp)
    800000dc:	f052                	sd	s4,32(sp)
    800000de:	ec56                	sd	s5,24(sp)
    800000e0:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000e2:	04c05363          	blez	a2,80000128 <consolewrite+0x58>
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	add	a0,s0,-65
    800000fa:	14c020ef          	jal	80002246 <either_copyin>
    800000fe:	01550b63          	beq	a0,s5,80000114 <consolewrite+0x44>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	7e2000ef          	jal	800008e8 <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addw	s2,s2,1
    8000010c:	0485                	add	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
  }

  return i;
}
    80000114:	854a                	mv	a0,s2
    80000116:	60a6                	ld	ra,72(sp)
    80000118:	6406                	ld	s0,64(sp)
    8000011a:	74e2                	ld	s1,56(sp)
    8000011c:	7942                	ld	s2,48(sp)
    8000011e:	79a2                	ld	s3,40(sp)
    80000120:	7a02                	ld	s4,32(sp)
    80000122:	6ae2                	ld	s5,24(sp)
    80000124:	6161                	add	sp,sp,80
    80000126:	8082                	ret
  for(i = 0; i < n; i++){
    80000128:	4901                	li	s2,0
    8000012a:	b7ed                	j	80000114 <consolewrite+0x44>

000000008000012c <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000012c:	711d                	add	sp,sp,-96
    8000012e:	ec86                	sd	ra,88(sp)
    80000130:	e8a2                	sd	s0,80(sp)
    80000132:	e4a6                	sd	s1,72(sp)
    80000134:	e0ca                	sd	s2,64(sp)
    80000136:	fc4e                	sd	s3,56(sp)
    80000138:	f852                	sd	s4,48(sp)
    8000013a:	f456                	sd	s5,40(sp)
    8000013c:	f05a                	sd	s6,32(sp)
    8000013e:	ec5e                	sd	s7,24(sp)
    80000140:	1080                	add	s0,sp,96
    80000142:	8aaa                	mv	s5,a0
    80000144:	8a2e                	mv	s4,a1
    80000146:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000148:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000014c:	00010517          	auipc	a0,0x10
    80000150:	83450513          	add	a0,a0,-1996 # 8000f980 <cons>
    80000154:	24d000ef          	jal	80000ba0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000158:	00010497          	auipc	s1,0x10
    8000015c:	82848493          	add	s1,s1,-2008 # 8000f980 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000160:	00010917          	auipc	s2,0x10
    80000164:	8b890913          	add	s2,s2,-1864 # 8000fa18 <cons+0x98>
  while(n > 0){
    80000168:	07305a63          	blez	s3,800001dc <consoleread+0xb0>
    while(cons.r == cons.w){
    8000016c:	0984a783          	lw	a5,152(s1)
    80000170:	09c4a703          	lw	a4,156(s1)
    80000174:	02f71163          	bne	a4,a5,80000196 <consoleread+0x6a>
      if(killed(myproc())){
    80000178:	6b8010ef          	jal	80001830 <myproc>
    8000017c:	763010ef          	jal	800020de <killed>
    80000180:	e53d                	bnez	a0,800001ee <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80000182:	85a6                	mv	a1,s1
    80000184:	854a                	mv	a0,s2
    80000186:	521010ef          	jal	80001ea6 <sleep>
    while(cons.r == cons.w){
    8000018a:	0984a783          	lw	a5,152(s1)
    8000018e:	09c4a703          	lw	a4,156(s1)
    80000192:	fef703e3          	beq	a4,a5,80000178 <consoleread+0x4c>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80000196:	0000f717          	auipc	a4,0xf
    8000019a:	7ea70713          	add	a4,a4,2026 # 8000f980 <cons>
    8000019e:	0017869b          	addw	a3,a5,1
    800001a2:	08d72c23          	sw	a3,152(a4)
    800001a6:	07f7f693          	and	a3,a5,127
    800001aa:	9736                	add	a4,a4,a3
    800001ac:	01874703          	lbu	a4,24(a4)
    800001b0:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001b4:	4691                	li	a3,4
    800001b6:	04db8e63          	beq	s7,a3,80000212 <consoleread+0xe6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001ba:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001be:	4685                	li	a3,1
    800001c0:	faf40613          	add	a2,s0,-81
    800001c4:	85d2                	mv	a1,s4
    800001c6:	8556                	mv	a0,s5
    800001c8:	034020ef          	jal	800021fc <either_copyout>
    800001cc:	57fd                	li	a5,-1
    800001ce:	00f50763          	beq	a0,a5,800001dc <consoleread+0xb0>
      break;

    dst++;
    800001d2:	0a05                	add	s4,s4,1
    --n;
    800001d4:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    800001d6:	47a9                	li	a5,10
    800001d8:	f8fb98e3          	bne	s7,a5,80000168 <consoleread+0x3c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001dc:	0000f517          	auipc	a0,0xf
    800001e0:	7a450513          	add	a0,a0,1956 # 8000f980 <cons>
    800001e4:	255000ef          	jal	80000c38 <release>

  return target - n;
    800001e8:	413b053b          	subw	a0,s6,s3
    800001ec:	a801                	j	800001fc <consoleread+0xd0>
        release(&cons.lock);
    800001ee:	0000f517          	auipc	a0,0xf
    800001f2:	79250513          	add	a0,a0,1938 # 8000f980 <cons>
    800001f6:	243000ef          	jal	80000c38 <release>
        return -1;
    800001fa:	557d                	li	a0,-1
}
    800001fc:	60e6                	ld	ra,88(sp)
    800001fe:	6446                	ld	s0,80(sp)
    80000200:	64a6                	ld	s1,72(sp)
    80000202:	6906                	ld	s2,64(sp)
    80000204:	79e2                	ld	s3,56(sp)
    80000206:	7a42                	ld	s4,48(sp)
    80000208:	7aa2                	ld	s5,40(sp)
    8000020a:	7b02                	ld	s6,32(sp)
    8000020c:	6be2                	ld	s7,24(sp)
    8000020e:	6125                	add	sp,sp,96
    80000210:	8082                	ret
      if(n < target){
    80000212:	0009871b          	sext.w	a4,s3
    80000216:	fd6773e3          	bgeu	a4,s6,800001dc <consoleread+0xb0>
        cons.r--;
    8000021a:	0000f717          	auipc	a4,0xf
    8000021e:	7ef72f23          	sw	a5,2046(a4) # 8000fa18 <cons+0x98>
    80000222:	bf6d                	j	800001dc <consoleread+0xb0>

0000000080000224 <consputc>:
{
    80000224:	1141                	add	sp,sp,-16
    80000226:	e406                	sd	ra,8(sp)
    80000228:	e022                	sd	s0,0(sp)
    8000022a:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    8000022c:	10000793          	li	a5,256
    80000230:	00f50863          	beq	a0,a5,80000240 <consputc+0x1c>
    uartputc_sync(c);
    80000234:	5de000ef          	jal	80000812 <uartputc_sync>
}
    80000238:	60a2                	ld	ra,8(sp)
    8000023a:	6402                	ld	s0,0(sp)
    8000023c:	0141                	add	sp,sp,16
    8000023e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000240:	4521                	li	a0,8
    80000242:	5d0000ef          	jal	80000812 <uartputc_sync>
    80000246:	02000513          	li	a0,32
    8000024a:	5c8000ef          	jal	80000812 <uartputc_sync>
    8000024e:	4521                	li	a0,8
    80000250:	5c2000ef          	jal	80000812 <uartputc_sync>
    80000254:	b7d5                	j	80000238 <consputc+0x14>

0000000080000256 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000256:	1101                	add	sp,sp,-32
    80000258:	ec06                	sd	ra,24(sp)
    8000025a:	e822                	sd	s0,16(sp)
    8000025c:	e426                	sd	s1,8(sp)
    8000025e:	e04a                	sd	s2,0(sp)
    80000260:	1000                	add	s0,sp,32
    80000262:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80000264:	0000f517          	auipc	a0,0xf
    80000268:	71c50513          	add	a0,a0,1820 # 8000f980 <cons>
    8000026c:	135000ef          	jal	80000ba0 <acquire>

  switch(c){
    80000270:	47d5                	li	a5,21
    80000272:	0af48063          	beq	s1,a5,80000312 <consoleintr+0xbc>
    80000276:	0297c663          	blt	a5,s1,800002a2 <consoleintr+0x4c>
    8000027a:	47a1                	li	a5,8
    8000027c:	0cf48f63          	beq	s1,a5,8000035a <consoleintr+0x104>
    80000280:	47c1                	li	a5,16
    80000282:	10f49063          	bne	s1,a5,80000382 <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    80000286:	00a020ef          	jal	80002290 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000028a:	0000f517          	auipc	a0,0xf
    8000028e:	6f650513          	add	a0,a0,1782 # 8000f980 <cons>
    80000292:	1a7000ef          	jal	80000c38 <release>
}
    80000296:	60e2                	ld	ra,24(sp)
    80000298:	6442                	ld	s0,16(sp)
    8000029a:	64a2                	ld	s1,8(sp)
    8000029c:	6902                	ld	s2,0(sp)
    8000029e:	6105                	add	sp,sp,32
    800002a0:	8082                	ret
  switch(c){
    800002a2:	07f00793          	li	a5,127
    800002a6:	0af48a63          	beq	s1,a5,8000035a <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002aa:	0000f717          	auipc	a4,0xf
    800002ae:	6d670713          	add	a4,a4,1750 # 8000f980 <cons>
    800002b2:	0a072783          	lw	a5,160(a4)
    800002b6:	09872703          	lw	a4,152(a4)
    800002ba:	9f99                	subw	a5,a5,a4
    800002bc:	07f00713          	li	a4,127
    800002c0:	fcf765e3          	bltu	a4,a5,8000028a <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    800002c4:	47b5                	li	a5,13
    800002c6:	0cf48163          	beq	s1,a5,80000388 <consoleintr+0x132>
      consputc(c);
    800002ca:	8526                	mv	a0,s1
    800002cc:	f59ff0ef          	jal	80000224 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002d0:	0000f797          	auipc	a5,0xf
    800002d4:	6b078793          	add	a5,a5,1712 # 8000f980 <cons>
    800002d8:	0a07a683          	lw	a3,160(a5)
    800002dc:	0016871b          	addw	a4,a3,1
    800002e0:	0007061b          	sext.w	a2,a4
    800002e4:	0ae7a023          	sw	a4,160(a5)
    800002e8:	07f6f693          	and	a3,a3,127
    800002ec:	97b6                	add	a5,a5,a3
    800002ee:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800002f2:	47a9                	li	a5,10
    800002f4:	0af48f63          	beq	s1,a5,800003b2 <consoleintr+0x15c>
    800002f8:	4791                	li	a5,4
    800002fa:	0af48c63          	beq	s1,a5,800003b2 <consoleintr+0x15c>
    800002fe:	0000f797          	auipc	a5,0xf
    80000302:	71a7a783          	lw	a5,1818(a5) # 8000fa18 <cons+0x98>
    80000306:	9f1d                	subw	a4,a4,a5
    80000308:	08000793          	li	a5,128
    8000030c:	f6f71fe3          	bne	a4,a5,8000028a <consoleintr+0x34>
    80000310:	a04d                	j	800003b2 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80000312:	0000f717          	auipc	a4,0xf
    80000316:	66e70713          	add	a4,a4,1646 # 8000f980 <cons>
    8000031a:	0a072783          	lw	a5,160(a4)
    8000031e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000322:	0000f497          	auipc	s1,0xf
    80000326:	65e48493          	add	s1,s1,1630 # 8000f980 <cons>
    while(cons.e != cons.w &&
    8000032a:	4929                	li	s2,10
    8000032c:	f4f70fe3          	beq	a4,a5,8000028a <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000330:	37fd                	addw	a5,a5,-1
    80000332:	07f7f713          	and	a4,a5,127
    80000336:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000338:	01874703          	lbu	a4,24(a4)
    8000033c:	f52707e3          	beq	a4,s2,8000028a <consoleintr+0x34>
      cons.e--;
    80000340:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000344:	10000513          	li	a0,256
    80000348:	eddff0ef          	jal	80000224 <consputc>
    while(cons.e != cons.w &&
    8000034c:	0a04a783          	lw	a5,160(s1)
    80000350:	09c4a703          	lw	a4,156(s1)
    80000354:	fcf71ee3          	bne	a4,a5,80000330 <consoleintr+0xda>
    80000358:	bf0d                	j	8000028a <consoleintr+0x34>
    if(cons.e != cons.w){
    8000035a:	0000f717          	auipc	a4,0xf
    8000035e:	62670713          	add	a4,a4,1574 # 8000f980 <cons>
    80000362:	0a072783          	lw	a5,160(a4)
    80000366:	09c72703          	lw	a4,156(a4)
    8000036a:	f2f700e3          	beq	a4,a5,8000028a <consoleintr+0x34>
      cons.e--;
    8000036e:	37fd                	addw	a5,a5,-1
    80000370:	0000f717          	auipc	a4,0xf
    80000374:	6af72823          	sw	a5,1712(a4) # 8000fa20 <cons+0xa0>
      consputc(BACKSPACE);
    80000378:	10000513          	li	a0,256
    8000037c:	ea9ff0ef          	jal	80000224 <consputc>
    80000380:	b729                	j	8000028a <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000382:	f00484e3          	beqz	s1,8000028a <consoleintr+0x34>
    80000386:	b715                	j	800002aa <consoleintr+0x54>
      consputc(c);
    80000388:	4529                	li	a0,10
    8000038a:	e9bff0ef          	jal	80000224 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000038e:	0000f797          	auipc	a5,0xf
    80000392:	5f278793          	add	a5,a5,1522 # 8000f980 <cons>
    80000396:	0a07a703          	lw	a4,160(a5)
    8000039a:	0017069b          	addw	a3,a4,1
    8000039e:	0006861b          	sext.w	a2,a3
    800003a2:	0ad7a023          	sw	a3,160(a5)
    800003a6:	07f77713          	and	a4,a4,127
    800003aa:	97ba                	add	a5,a5,a4
    800003ac:	4729                	li	a4,10
    800003ae:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003b2:	0000f797          	auipc	a5,0xf
    800003b6:	66c7a523          	sw	a2,1642(a5) # 8000fa1c <cons+0x9c>
        wakeup(&cons.r);
    800003ba:	0000f517          	auipc	a0,0xf
    800003be:	65e50513          	add	a0,a0,1630 # 8000fa18 <cons+0x98>
    800003c2:	331010ef          	jal	80001ef2 <wakeup>
    800003c6:	b5d1                	j	8000028a <consoleintr+0x34>

00000000800003c8 <consoleinit>:

void
consoleinit(void)
{
    800003c8:	1141                	add	sp,sp,-16
    800003ca:	e406                	sd	ra,8(sp)
    800003cc:	e022                	sd	s0,0(sp)
    800003ce:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    800003d0:	00007597          	auipc	a1,0x7
    800003d4:	c4058593          	add	a1,a1,-960 # 80007010 <etext+0x10>
    800003d8:	0000f517          	auipc	a0,0xf
    800003dc:	5a850513          	add	a0,a0,1448 # 8000f980 <cons>
    800003e0:	740000ef          	jal	80000b20 <initlock>

  uartinit();
    800003e4:	3e2000ef          	jal	800007c6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800003e8:	00031797          	auipc	a5,0x31
    800003ec:	62078793          	add	a5,a5,1568 # 80031a08 <devsw>
    800003f0:	00000717          	auipc	a4,0x0
    800003f4:	d3c70713          	add	a4,a4,-708 # 8000012c <consoleread>
    800003f8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800003fa:	00000717          	auipc	a4,0x0
    800003fe:	cd670713          	add	a4,a4,-810 # 800000d0 <consolewrite>
    80000402:	ef98                	sd	a4,24(a5)
}
    80000404:	60a2                	ld	ra,8(sp)
    80000406:	6402                	ld	s0,0(sp)
    80000408:	0141                	add	sp,sp,16
    8000040a:	8082                	ret

000000008000040c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000040c:	7179                	add	sp,sp,-48
    8000040e:	f406                	sd	ra,40(sp)
    80000410:	f022                	sd	s0,32(sp)
    80000412:	ec26                	sd	s1,24(sp)
    80000414:	e84a                	sd	s2,16(sp)
    80000416:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000418:	c219                	beqz	a2,8000041e <printint+0x12>
    8000041a:	06054e63          	bltz	a0,80000496 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000041e:	4881                	li	a7,0
    80000420:	fd040693          	add	a3,s0,-48

  i = 0;
    80000424:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000426:	00007617          	auipc	a2,0x7
    8000042a:	c1260613          	add	a2,a2,-1006 # 80007038 <digits>
    8000042e:	883e                	mv	a6,a5
    80000430:	2785                	addw	a5,a5,1
    80000432:	02b57733          	remu	a4,a0,a1
    80000436:	9732                	add	a4,a4,a2
    80000438:	00074703          	lbu	a4,0(a4)
    8000043c:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000440:	872a                	mv	a4,a0
    80000442:	02b55533          	divu	a0,a0,a1
    80000446:	0685                	add	a3,a3,1
    80000448:	feb773e3          	bgeu	a4,a1,8000042e <printint+0x22>

  if(sign)
    8000044c:	00088a63          	beqz	a7,80000460 <printint+0x54>
    buf[i++] = '-';
    80000450:	1781                	add	a5,a5,-32
    80000452:	97a2                	add	a5,a5,s0
    80000454:	02d00713          	li	a4,45
    80000458:	fee78823          	sb	a4,-16(a5)
    8000045c:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
    80000460:	02f05563          	blez	a5,8000048a <printint+0x7e>
    80000464:	fd040713          	add	a4,s0,-48
    80000468:	00f704b3          	add	s1,a4,a5
    8000046c:	fff70913          	add	s2,a4,-1
    80000470:	993e                	add	s2,s2,a5
    80000472:	37fd                	addw	a5,a5,-1
    80000474:	1782                	sll	a5,a5,0x20
    80000476:	9381                	srl	a5,a5,0x20
    80000478:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000047c:	fff4c503          	lbu	a0,-1(s1)
    80000480:	da5ff0ef          	jal	80000224 <consputc>
  while(--i >= 0)
    80000484:	14fd                	add	s1,s1,-1
    80000486:	ff249be3          	bne	s1,s2,8000047c <printint+0x70>
}
    8000048a:	70a2                	ld	ra,40(sp)
    8000048c:	7402                	ld	s0,32(sp)
    8000048e:	64e2                	ld	s1,24(sp)
    80000490:	6942                	ld	s2,16(sp)
    80000492:	6145                	add	sp,sp,48
    80000494:	8082                	ret
    x = -xx;
    80000496:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000049a:	4885                	li	a7,1
    x = -xx;
    8000049c:	b751                	j	80000420 <printint+0x14>

000000008000049e <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    8000049e:	7155                	add	sp,sp,-208
    800004a0:	e506                	sd	ra,136(sp)
    800004a2:	e122                	sd	s0,128(sp)
    800004a4:	fca6                	sd	s1,120(sp)
    800004a6:	f8ca                	sd	s2,112(sp)
    800004a8:	f4ce                	sd	s3,104(sp)
    800004aa:	f0d2                	sd	s4,96(sp)
    800004ac:	ecd6                	sd	s5,88(sp)
    800004ae:	e8da                	sd	s6,80(sp)
    800004b0:	e4de                	sd	s7,72(sp)
    800004b2:	e0e2                	sd	s8,64(sp)
    800004b4:	fc66                	sd	s9,56(sp)
    800004b6:	f86a                	sd	s10,48(sp)
    800004b8:	f46e                	sd	s11,40(sp)
    800004ba:	0900                	add	s0,sp,144
    800004bc:	8a2a                	mv	s4,a0
    800004be:	e40c                	sd	a1,8(s0)
    800004c0:	e810                	sd	a2,16(s0)
    800004c2:	ec14                	sd	a3,24(s0)
    800004c4:	f018                	sd	a4,32(s0)
    800004c6:	f41c                	sd	a5,40(s0)
    800004c8:	03043823          	sd	a6,48(s0)
    800004cc:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004d0:	0000f797          	auipc	a5,0xf
    800004d4:	5707a783          	lw	a5,1392(a5) # 8000fa40 <pr+0x18>
    800004d8:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004dc:	e79d                	bnez	a5,8000050a <printf+0x6c>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004de:	00840793          	add	a5,s0,8
    800004e2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004e6:	00054503          	lbu	a0,0(a0)
    800004ea:	24050a63          	beqz	a0,8000073e <printf+0x2a0>
    800004ee:	4981                	li	s3,0
    if(cx != '%'){
    800004f0:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800004f4:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800004f8:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800004fc:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000500:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000504:	07000d93          	li	s11,112
    80000508:	a081                	j	80000548 <printf+0xaa>
    acquire(&pr.lock);
    8000050a:	0000f517          	auipc	a0,0xf
    8000050e:	51e50513          	add	a0,a0,1310 # 8000fa28 <pr>
    80000512:	68e000ef          	jal	80000ba0 <acquire>
  va_start(ap, fmt);
    80000516:	00840793          	add	a5,s0,8
    8000051a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000051e:	000a4503          	lbu	a0,0(s4)
    80000522:	f571                	bnez	a0,800004ee <printf+0x50>
#endif
  }
  va_end(ap);

  if(locking)
    release(&pr.lock);
    80000524:	0000f517          	auipc	a0,0xf
    80000528:	50450513          	add	a0,a0,1284 # 8000fa28 <pr>
    8000052c:	70c000ef          	jal	80000c38 <release>
    80000530:	a439                	j	8000073e <printf+0x2a0>
      consputc(cx);
    80000532:	cf3ff0ef          	jal	80000224 <consputc>
      continue;
    80000536:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000538:	0014899b          	addw	s3,s1,1
    8000053c:	013a07b3          	add	a5,s4,s3
    80000540:	0007c503          	lbu	a0,0(a5)
    80000544:	1e050963          	beqz	a0,80000736 <printf+0x298>
    if(cx != '%'){
    80000548:	ff5515e3          	bne	a0,s5,80000532 <printf+0x94>
    i++;
    8000054c:	0019849b          	addw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000550:	009a07b3          	add	a5,s4,s1
    80000554:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000558:	1c090f63          	beqz	s2,80000736 <printf+0x298>
    8000055c:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000560:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000562:	c789                	beqz	a5,8000056c <printf+0xce>
    80000564:	009a0733          	add	a4,s4,s1
    80000568:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    8000056c:	03690763          	beq	s2,s6,8000059a <printf+0xfc>
    } else if(c0 == 'l' && c1 == 'd'){
    80000570:	05890163          	beq	s2,s8,800005b2 <printf+0x114>
    } else if(c0 == 'u'){
    80000574:	0d990b63          	beq	s2,s9,8000064a <printf+0x1ac>
    } else if(c0 == 'x'){
    80000578:	13a90163          	beq	s2,s10,8000069a <printf+0x1fc>
    } else if(c0 == 'p'){
    8000057c:	13b90b63          	beq	s2,s11,800006b2 <printf+0x214>
    } else if(c0 == 's'){
    80000580:	07300793          	li	a5,115
    80000584:	16f90863          	beq	s2,a5,800006f4 <printf+0x256>
    } else if(c0 == '%'){
    80000588:	1b590263          	beq	s2,s5,8000072c <printf+0x28e>
      consputc('%');
    8000058c:	8556                	mv	a0,s5
    8000058e:	c97ff0ef          	jal	80000224 <consputc>
      consputc(c0);
    80000592:	854a                	mv	a0,s2
    80000594:	c91ff0ef          	jal	80000224 <consputc>
    80000598:	b745                	j	80000538 <printf+0x9a>
      printint(va_arg(ap, int), 10, 1);
    8000059a:	f8843783          	ld	a5,-120(s0)
    8000059e:	00878713          	add	a4,a5,8
    800005a2:	f8e43423          	sd	a4,-120(s0)
    800005a6:	4605                	li	a2,1
    800005a8:	45a9                	li	a1,10
    800005aa:	4388                	lw	a0,0(a5)
    800005ac:	e61ff0ef          	jal	8000040c <printint>
    800005b0:	b761                	j	80000538 <printf+0x9a>
    } else if(c0 == 'l' && c1 == 'd'){
    800005b2:	03678663          	beq	a5,s6,800005de <printf+0x140>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005b6:	05878263          	beq	a5,s8,800005fa <printf+0x15c>
    } else if(c0 == 'l' && c1 == 'u'){
    800005ba:	0b978463          	beq	a5,s9,80000662 <printf+0x1c4>
    } else if(c0 == 'l' && c1 == 'x'){
    800005be:	fda797e3          	bne	a5,s10,8000058c <printf+0xee>
      printint(va_arg(ap, uint64), 16, 0);
    800005c2:	f8843783          	ld	a5,-120(s0)
    800005c6:	00878713          	add	a4,a5,8
    800005ca:	f8e43423          	sd	a4,-120(s0)
    800005ce:	4601                	li	a2,0
    800005d0:	45c1                	li	a1,16
    800005d2:	6388                	ld	a0,0(a5)
    800005d4:	e39ff0ef          	jal	8000040c <printint>
      i += 1;
    800005d8:	0029849b          	addw	s1,s3,2
    800005dc:	bfb1                	j	80000538 <printf+0x9a>
      printint(va_arg(ap, uint64), 10, 1);
    800005de:	f8843783          	ld	a5,-120(s0)
    800005e2:	00878713          	add	a4,a5,8
    800005e6:	f8e43423          	sd	a4,-120(s0)
    800005ea:	4605                	li	a2,1
    800005ec:	45a9                	li	a1,10
    800005ee:	6388                	ld	a0,0(a5)
    800005f0:	e1dff0ef          	jal	8000040c <printint>
      i += 1;
    800005f4:	0029849b          	addw	s1,s3,2
    800005f8:	b781                	j	80000538 <printf+0x9a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005fa:	06400793          	li	a5,100
    800005fe:	02f68863          	beq	a3,a5,8000062e <printf+0x190>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000602:	07500793          	li	a5,117
    80000606:	06f68c63          	beq	a3,a5,8000067e <printf+0x1e0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000060a:	07800793          	li	a5,120
    8000060e:	f6f69fe3          	bne	a3,a5,8000058c <printf+0xee>
      printint(va_arg(ap, uint64), 16, 0);
    80000612:	f8843783          	ld	a5,-120(s0)
    80000616:	00878713          	add	a4,a5,8
    8000061a:	f8e43423          	sd	a4,-120(s0)
    8000061e:	4601                	li	a2,0
    80000620:	45c1                	li	a1,16
    80000622:	6388                	ld	a0,0(a5)
    80000624:	de9ff0ef          	jal	8000040c <printint>
      i += 2;
    80000628:	0039849b          	addw	s1,s3,3
    8000062c:	b731                	j	80000538 <printf+0x9a>
      printint(va_arg(ap, uint64), 10, 1);
    8000062e:	f8843783          	ld	a5,-120(s0)
    80000632:	00878713          	add	a4,a5,8
    80000636:	f8e43423          	sd	a4,-120(s0)
    8000063a:	4605                	li	a2,1
    8000063c:	45a9                	li	a1,10
    8000063e:	6388                	ld	a0,0(a5)
    80000640:	dcdff0ef          	jal	8000040c <printint>
      i += 2;
    80000644:	0039849b          	addw	s1,s3,3
    80000648:	bdc5                	j	80000538 <printf+0x9a>
      printint(va_arg(ap, int), 10, 0);
    8000064a:	f8843783          	ld	a5,-120(s0)
    8000064e:	00878713          	add	a4,a5,8
    80000652:	f8e43423          	sd	a4,-120(s0)
    80000656:	4601                	li	a2,0
    80000658:	45a9                	li	a1,10
    8000065a:	4388                	lw	a0,0(a5)
    8000065c:	db1ff0ef          	jal	8000040c <printint>
    80000660:	bde1                	j	80000538 <printf+0x9a>
      printint(va_arg(ap, uint64), 10, 0);
    80000662:	f8843783          	ld	a5,-120(s0)
    80000666:	00878713          	add	a4,a5,8
    8000066a:	f8e43423          	sd	a4,-120(s0)
    8000066e:	4601                	li	a2,0
    80000670:	45a9                	li	a1,10
    80000672:	6388                	ld	a0,0(a5)
    80000674:	d99ff0ef          	jal	8000040c <printint>
      i += 1;
    80000678:	0029849b          	addw	s1,s3,2
    8000067c:	bd75                	j	80000538 <printf+0x9a>
      printint(va_arg(ap, uint64), 10, 0);
    8000067e:	f8843783          	ld	a5,-120(s0)
    80000682:	00878713          	add	a4,a5,8
    80000686:	f8e43423          	sd	a4,-120(s0)
    8000068a:	4601                	li	a2,0
    8000068c:	45a9                	li	a1,10
    8000068e:	6388                	ld	a0,0(a5)
    80000690:	d7dff0ef          	jal	8000040c <printint>
      i += 2;
    80000694:	0039849b          	addw	s1,s3,3
    80000698:	b545                	j	80000538 <printf+0x9a>
      printint(va_arg(ap, int), 16, 0);
    8000069a:	f8843783          	ld	a5,-120(s0)
    8000069e:	00878713          	add	a4,a5,8
    800006a2:	f8e43423          	sd	a4,-120(s0)
    800006a6:	4601                	li	a2,0
    800006a8:	45c1                	li	a1,16
    800006aa:	4388                	lw	a0,0(a5)
    800006ac:	d61ff0ef          	jal	8000040c <printint>
    800006b0:	b561                	j	80000538 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	add	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006c2:	03000513          	li	a0,48
    800006c6:	b5fff0ef          	jal	80000224 <consputc>
  consputc('x');
    800006ca:	07800513          	li	a0,120
    800006ce:	b57ff0ef          	jal	80000224 <consputc>
    800006d2:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006d4:	00007b97          	auipc	s7,0x7
    800006d8:	964b8b93          	add	s7,s7,-1692 # 80007038 <digits>
    800006dc:	03c9d793          	srl	a5,s3,0x3c
    800006e0:	97de                	add	a5,a5,s7
    800006e2:	0007c503          	lbu	a0,0(a5)
    800006e6:	b3fff0ef          	jal	80000224 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006ea:	0992                	sll	s3,s3,0x4
    800006ec:	397d                	addw	s2,s2,-1
    800006ee:	fe0917e3          	bnez	s2,800006dc <printf+0x23e>
    800006f2:	b599                	j	80000538 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006f4:	f8843783          	ld	a5,-120(s0)
    800006f8:	00878713          	add	a4,a5,8
    800006fc:	f8e43423          	sd	a4,-120(s0)
    80000700:	0007b903          	ld	s2,0(a5)
    80000704:	00090d63          	beqz	s2,8000071e <printf+0x280>
      for(; *s; s++)
    80000708:	00094503          	lbu	a0,0(s2)
    8000070c:	e20506e3          	beqz	a0,80000538 <printf+0x9a>
        consputc(*s);
    80000710:	b15ff0ef          	jal	80000224 <consputc>
      for(; *s; s++)
    80000714:	0905                	add	s2,s2,1
    80000716:	00094503          	lbu	a0,0(s2)
    8000071a:	f97d                	bnez	a0,80000710 <printf+0x272>
    8000071c:	bd31                	j	80000538 <printf+0x9a>
        s = "(null)";
    8000071e:	00007917          	auipc	s2,0x7
    80000722:	8fa90913          	add	s2,s2,-1798 # 80007018 <etext+0x18>
      for(; *s; s++)
    80000726:	02800513          	li	a0,40
    8000072a:	b7dd                	j	80000710 <printf+0x272>
      consputc('%');
    8000072c:	02500513          	li	a0,37
    80000730:	af5ff0ef          	jal	80000224 <consputc>
    80000734:	b511                	j	80000538 <printf+0x9a>
  if(locking)
    80000736:	f7843783          	ld	a5,-136(s0)
    8000073a:	de0795e3          	bnez	a5,80000524 <printf+0x86>

  return 0;
}
    8000073e:	4501                	li	a0,0
    80000740:	60aa                	ld	ra,136(sp)
    80000742:	640a                	ld	s0,128(sp)
    80000744:	74e6                	ld	s1,120(sp)
    80000746:	7946                	ld	s2,112(sp)
    80000748:	79a6                	ld	s3,104(sp)
    8000074a:	7a06                	ld	s4,96(sp)
    8000074c:	6ae6                	ld	s5,88(sp)
    8000074e:	6b46                	ld	s6,80(sp)
    80000750:	6ba6                	ld	s7,72(sp)
    80000752:	6c06                	ld	s8,64(sp)
    80000754:	7ce2                	ld	s9,56(sp)
    80000756:	7d42                	ld	s10,48(sp)
    80000758:	7da2                	ld	s11,40(sp)
    8000075a:	6169                	add	sp,sp,208
    8000075c:	8082                	ret

000000008000075e <panic>:

void
panic(char *s)
{
    8000075e:	1101                	add	sp,sp,-32
    80000760:	ec06                	sd	ra,24(sp)
    80000762:	e822                	sd	s0,16(sp)
    80000764:	e426                	sd	s1,8(sp)
    80000766:	1000                	add	s0,sp,32
    80000768:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000076a:	0000f797          	auipc	a5,0xf
    8000076e:	2c07ab23          	sw	zero,726(a5) # 8000fa40 <pr+0x18>
  printf("panic: ");
    80000772:	00007517          	auipc	a0,0x7
    80000776:	8ae50513          	add	a0,a0,-1874 # 80007020 <etext+0x20>
    8000077a:	d25ff0ef          	jal	8000049e <printf>
  printf("%s\n", s);
    8000077e:	85a6                	mv	a1,s1
    80000780:	00007517          	auipc	a0,0x7
    80000784:	8a850513          	add	a0,a0,-1880 # 80007028 <etext+0x28>
    80000788:	d17ff0ef          	jal	8000049e <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000078c:	4785                	li	a5,1
    8000078e:	00007717          	auipc	a4,0x7
    80000792:	1af72923          	sw	a5,434(a4) # 80007940 <panicked>
  for(;;)
    80000796:	a001                	j	80000796 <panic+0x38>

0000000080000798 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000798:	1101                	add	sp,sp,-32
    8000079a:	ec06                	sd	ra,24(sp)
    8000079c:	e822                	sd	s0,16(sp)
    8000079e:	e426                	sd	s1,8(sp)
    800007a0:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    800007a2:	0000f497          	auipc	s1,0xf
    800007a6:	28648493          	add	s1,s1,646 # 8000fa28 <pr>
    800007aa:	00007597          	auipc	a1,0x7
    800007ae:	88658593          	add	a1,a1,-1914 # 80007030 <etext+0x30>
    800007b2:	8526                	mv	a0,s1
    800007b4:	36c000ef          	jal	80000b20 <initlock>
  pr.locking = 1;
    800007b8:	4785                	li	a5,1
    800007ba:	cc9c                	sw	a5,24(s1)
}
    800007bc:	60e2                	ld	ra,24(sp)
    800007be:	6442                	ld	s0,16(sp)
    800007c0:	64a2                	ld	s1,8(sp)
    800007c2:	6105                	add	sp,sp,32
    800007c4:	8082                	ret

00000000800007c6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007c6:	1141                	add	sp,sp,-16
    800007c8:	e406                	sd	ra,8(sp)
    800007ca:	e022                	sd	s0,0(sp)
    800007cc:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ce:	100007b7          	lui	a5,0x10000
    800007d2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007d6:	f8000713          	li	a4,-128
    800007da:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007de:	470d                	li	a4,3
    800007e0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007e4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007e8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007ec:	469d                	li	a3,7
    800007ee:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007f2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007f6:	00007597          	auipc	a1,0x7
    800007fa:	85a58593          	add	a1,a1,-1958 # 80007050 <digits+0x18>
    800007fe:	0000f517          	auipc	a0,0xf
    80000802:	24a50513          	add	a0,a0,586 # 8000fa48 <uart_tx_lock>
    80000806:	31a000ef          	jal	80000b20 <initlock>
}
    8000080a:	60a2                	ld	ra,8(sp)
    8000080c:	6402                	ld	s0,0(sp)
    8000080e:	0141                	add	sp,sp,16
    80000810:	8082                	ret

0000000080000812 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000812:	1101                	add	sp,sp,-32
    80000814:	ec06                	sd	ra,24(sp)
    80000816:	e822                	sd	s0,16(sp)
    80000818:	e426                	sd	s1,8(sp)
    8000081a:	1000                	add	s0,sp,32
    8000081c:	84aa                	mv	s1,a0
  push_off();
    8000081e:	342000ef          	jal	80000b60 <push_off>

  if(panicked){
    80000822:	00007797          	auipc	a5,0x7
    80000826:	11e7a783          	lw	a5,286(a5) # 80007940 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000082a:	10000737          	lui	a4,0x10000
  if(panicked){
    8000082e:	c391                	beqz	a5,80000832 <uartputc_sync+0x20>
    for(;;)
    80000830:	a001                	j	80000830 <uartputc_sync+0x1e>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000832:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000836:	0207f793          	and	a5,a5,32
    8000083a:	dfe5                	beqz	a5,80000832 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000083c:	0ff4f513          	zext.b	a0,s1
    80000840:	100007b7          	lui	a5,0x10000
    80000844:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000848:	39c000ef          	jal	80000be4 <pop_off>
}
    8000084c:	60e2                	ld	ra,24(sp)
    8000084e:	6442                	ld	s0,16(sp)
    80000850:	64a2                	ld	s1,8(sp)
    80000852:	6105                	add	sp,sp,32
    80000854:	8082                	ret

0000000080000856 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000856:	00007797          	auipc	a5,0x7
    8000085a:	0f27b783          	ld	a5,242(a5) # 80007948 <uart_tx_r>
    8000085e:	00007717          	auipc	a4,0x7
    80000862:	0f273703          	ld	a4,242(a4) # 80007950 <uart_tx_w>
    80000866:	06f70c63          	beq	a4,a5,800008de <uartstart+0x88>
{
    8000086a:	7139                	add	sp,sp,-64
    8000086c:	fc06                	sd	ra,56(sp)
    8000086e:	f822                	sd	s0,48(sp)
    80000870:	f426                	sd	s1,40(sp)
    80000872:	f04a                	sd	s2,32(sp)
    80000874:	ec4e                	sd	s3,24(sp)
    80000876:	e852                	sd	s4,16(sp)
    80000878:	e456                	sd	s5,8(sp)
    8000087a:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000087c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000880:	0000fa17          	auipc	s4,0xf
    80000884:	1c8a0a13          	add	s4,s4,456 # 8000fa48 <uart_tx_lock>
    uart_tx_r += 1;
    80000888:	00007497          	auipc	s1,0x7
    8000088c:	0c048493          	add	s1,s1,192 # 80007948 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000890:	00007997          	auipc	s3,0x7
    80000894:	0c098993          	add	s3,s3,192 # 80007950 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000898:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000089c:	02077713          	and	a4,a4,32
    800008a0:	c715                	beqz	a4,800008cc <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008a2:	01f7f713          	and	a4,a5,31
    800008a6:	9752                	add	a4,a4,s4
    800008a8:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800008ac:	0785                	add	a5,a5,1
    800008ae:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008b0:	8526                	mv	a0,s1
    800008b2:	640010ef          	jal	80001ef2 <wakeup>
    
    WriteReg(THR, c);
    800008b6:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008ba:	609c                	ld	a5,0(s1)
    800008bc:	0009b703          	ld	a4,0(s3)
    800008c0:	fcf71ce3          	bne	a4,a5,80000898 <uartstart+0x42>
      ReadReg(ISR);
    800008c4:	100007b7          	lui	a5,0x10000
    800008c8:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    800008cc:	70e2                	ld	ra,56(sp)
    800008ce:	7442                	ld	s0,48(sp)
    800008d0:	74a2                	ld	s1,40(sp)
    800008d2:	7902                	ld	s2,32(sp)
    800008d4:	69e2                	ld	s3,24(sp)
    800008d6:	6a42                	ld	s4,16(sp)
    800008d8:	6aa2                	ld	s5,8(sp)
    800008da:	6121                	add	sp,sp,64
    800008dc:	8082                	ret
      ReadReg(ISR);
    800008de:	100007b7          	lui	a5,0x10000
    800008e2:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800008e6:	8082                	ret

00000000800008e8 <uartputc>:
{
    800008e8:	7179                	add	sp,sp,-48
    800008ea:	f406                	sd	ra,40(sp)
    800008ec:	f022                	sd	s0,32(sp)
    800008ee:	ec26                	sd	s1,24(sp)
    800008f0:	e84a                	sd	s2,16(sp)
    800008f2:	e44e                	sd	s3,8(sp)
    800008f4:	e052                	sd	s4,0(sp)
    800008f6:	1800                	add	s0,sp,48
    800008f8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008fa:	0000f517          	auipc	a0,0xf
    800008fe:	14e50513          	add	a0,a0,334 # 8000fa48 <uart_tx_lock>
    80000902:	29e000ef          	jal	80000ba0 <acquire>
  if(panicked){
    80000906:	00007797          	auipc	a5,0x7
    8000090a:	03a7a783          	lw	a5,58(a5) # 80007940 <panicked>
    8000090e:	efbd                	bnez	a5,8000098c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000910:	00007717          	auipc	a4,0x7
    80000914:	04073703          	ld	a4,64(a4) # 80007950 <uart_tx_w>
    80000918:	00007797          	auipc	a5,0x7
    8000091c:	0307b783          	ld	a5,48(a5) # 80007948 <uart_tx_r>
    80000920:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000924:	0000f997          	auipc	s3,0xf
    80000928:	12498993          	add	s3,s3,292 # 8000fa48 <uart_tx_lock>
    8000092c:	00007497          	auipc	s1,0x7
    80000930:	01c48493          	add	s1,s1,28 # 80007948 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000934:	00007917          	auipc	s2,0x7
    80000938:	01c90913          	add	s2,s2,28 # 80007950 <uart_tx_w>
    8000093c:	00e79d63          	bne	a5,a4,80000956 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000940:	85ce                	mv	a1,s3
    80000942:	8526                	mv	a0,s1
    80000944:	562010ef          	jal	80001ea6 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000948:	00093703          	ld	a4,0(s2)
    8000094c:	609c                	ld	a5,0(s1)
    8000094e:	02078793          	add	a5,a5,32
    80000952:	fee787e3          	beq	a5,a4,80000940 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000956:	0000f497          	auipc	s1,0xf
    8000095a:	0f248493          	add	s1,s1,242 # 8000fa48 <uart_tx_lock>
    8000095e:	01f77793          	and	a5,a4,31
    80000962:	97a6                	add	a5,a5,s1
    80000964:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000968:	0705                	add	a4,a4,1
    8000096a:	00007797          	auipc	a5,0x7
    8000096e:	fee7b323          	sd	a4,-26(a5) # 80007950 <uart_tx_w>
  uartstart();
    80000972:	ee5ff0ef          	jal	80000856 <uartstart>
  release(&uart_tx_lock);
    80000976:	8526                	mv	a0,s1
    80000978:	2c0000ef          	jal	80000c38 <release>
}
    8000097c:	70a2                	ld	ra,40(sp)
    8000097e:	7402                	ld	s0,32(sp)
    80000980:	64e2                	ld	s1,24(sp)
    80000982:	6942                	ld	s2,16(sp)
    80000984:	69a2                	ld	s3,8(sp)
    80000986:	6a02                	ld	s4,0(sp)
    80000988:	6145                	add	sp,sp,48
    8000098a:	8082                	ret
    for(;;)
    8000098c:	a001                	j	8000098c <uartputc+0xa4>

000000008000098e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000098e:	1141                	add	sp,sp,-16
    80000990:	e422                	sd	s0,8(sp)
    80000992:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000994:	100007b7          	lui	a5,0x10000
    80000998:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000099c:	8b85                	and	a5,a5,1
    8000099e:	cb81                	beqz	a5,800009ae <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800009a0:	100007b7          	lui	a5,0x10000
    800009a4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009a8:	6422                	ld	s0,8(sp)
    800009aa:	0141                	add	sp,sp,16
    800009ac:	8082                	ret
    return -1;
    800009ae:	557d                	li	a0,-1
    800009b0:	bfe5                	j	800009a8 <uartgetc+0x1a>

00000000800009b2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009b2:	1101                	add	sp,sp,-32
    800009b4:	ec06                	sd	ra,24(sp)
    800009b6:	e822                	sd	s0,16(sp)
    800009b8:	e426                	sd	s1,8(sp)
    800009ba:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009bc:	54fd                	li	s1,-1
    800009be:	a019                	j	800009c4 <uartintr+0x12>
      break;
    consoleintr(c);
    800009c0:	897ff0ef          	jal	80000256 <consoleintr>
    int c = uartgetc();
    800009c4:	fcbff0ef          	jal	8000098e <uartgetc>
    if(c == -1)
    800009c8:	fe951ce3          	bne	a0,s1,800009c0 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009cc:	0000f497          	auipc	s1,0xf
    800009d0:	07c48493          	add	s1,s1,124 # 8000fa48 <uart_tx_lock>
    800009d4:	8526                	mv	a0,s1
    800009d6:	1ca000ef          	jal	80000ba0 <acquire>
  uartstart();
    800009da:	e7dff0ef          	jal	80000856 <uartstart>
  release(&uart_tx_lock);
    800009de:	8526                	mv	a0,s1
    800009e0:	258000ef          	jal	80000c38 <release>
}
    800009e4:	60e2                	ld	ra,24(sp)
    800009e6:	6442                	ld	s0,16(sp)
    800009e8:	64a2                	ld	s1,8(sp)
    800009ea:	6105                	add	sp,sp,32
    800009ec:	8082                	ret

00000000800009ee <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009ee:	1101                	add	sp,sp,-32
    800009f0:	ec06                	sd	ra,24(sp)
    800009f2:	e822                	sd	s0,16(sp)
    800009f4:	e426                	sd	s1,8(sp)
    800009f6:	e04a                	sd	s2,0(sp)
    800009f8:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009fa:	03451793          	sll	a5,a0,0x34
    800009fe:	e7a9                	bnez	a5,80000a48 <kfree+0x5a>
    80000a00:	84aa                	mv	s1,a0
    80000a02:	00032797          	auipc	a5,0x32
    80000a06:	19e78793          	add	a5,a5,414 # 80032ba0 <end>
    80000a0a:	02f56f63          	bltu	a0,a5,80000a48 <kfree+0x5a>
    80000a0e:	47c5                	li	a5,17
    80000a10:	07ee                	sll	a5,a5,0x1b
    80000a12:	02f57b63          	bgeu	a0,a5,80000a48 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a16:	6605                	lui	a2,0x1
    80000a18:	4585                	li	a1,1
    80000a1a:	25a000ef          	jal	80000c74 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a1e:	0000f917          	auipc	s2,0xf
    80000a22:	06290913          	add	s2,s2,98 # 8000fa80 <kmem>
    80000a26:	854a                	mv	a0,s2
    80000a28:	178000ef          	jal	80000ba0 <acquire>
  r->next = kmem.freelist;
    80000a2c:	01893783          	ld	a5,24(s2)
    80000a30:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a32:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a36:	854a                	mv	a0,s2
    80000a38:	200000ef          	jal	80000c38 <release>
}
    80000a3c:	60e2                	ld	ra,24(sp)
    80000a3e:	6442                	ld	s0,16(sp)
    80000a40:	64a2                	ld	s1,8(sp)
    80000a42:	6902                	ld	s2,0(sp)
    80000a44:	6105                	add	sp,sp,32
    80000a46:	8082                	ret
    panic("kfree");
    80000a48:	00006517          	auipc	a0,0x6
    80000a4c:	61050513          	add	a0,a0,1552 # 80007058 <digits+0x20>
    80000a50:	d0fff0ef          	jal	8000075e <panic>

0000000080000a54 <freerange>:
{
    80000a54:	7179                	add	sp,sp,-48
    80000a56:	f406                	sd	ra,40(sp)
    80000a58:	f022                	sd	s0,32(sp)
    80000a5a:	ec26                	sd	s1,24(sp)
    80000a5c:	e84a                	sd	s2,16(sp)
    80000a5e:	e44e                	sd	s3,8(sp)
    80000a60:	e052                	sd	s4,0(sp)
    80000a62:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a64:	6785                	lui	a5,0x1
    80000a66:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a6a:	00e504b3          	add	s1,a0,a4
    80000a6e:	777d                	lui	a4,0xfffff
    80000a70:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a72:	94be                	add	s1,s1,a5
    80000a74:	0095ec63          	bltu	a1,s1,80000a8c <freerange+0x38>
    80000a78:	892e                	mv	s2,a1
    kfree(p);
    80000a7a:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a7c:	6985                	lui	s3,0x1
    kfree(p);
    80000a7e:	01448533          	add	a0,s1,s4
    80000a82:	f6dff0ef          	jal	800009ee <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a86:	94ce                	add	s1,s1,s3
    80000a88:	fe997be3          	bgeu	s2,s1,80000a7e <freerange+0x2a>
}
    80000a8c:	70a2                	ld	ra,40(sp)
    80000a8e:	7402                	ld	s0,32(sp)
    80000a90:	64e2                	ld	s1,24(sp)
    80000a92:	6942                	ld	s2,16(sp)
    80000a94:	69a2                	ld	s3,8(sp)
    80000a96:	6a02                	ld	s4,0(sp)
    80000a98:	6145                	add	sp,sp,48
    80000a9a:	8082                	ret

0000000080000a9c <kinit>:
{
    80000a9c:	1141                	add	sp,sp,-16
    80000a9e:	e406                	sd	ra,8(sp)
    80000aa0:	e022                	sd	s0,0(sp)
    80000aa2:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000aa4:	00006597          	auipc	a1,0x6
    80000aa8:	5bc58593          	add	a1,a1,1468 # 80007060 <digits+0x28>
    80000aac:	0000f517          	auipc	a0,0xf
    80000ab0:	fd450513          	add	a0,a0,-44 # 8000fa80 <kmem>
    80000ab4:	06c000ef          	jal	80000b20 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab8:	45c5                	li	a1,17
    80000aba:	05ee                	sll	a1,a1,0x1b
    80000abc:	00032517          	auipc	a0,0x32
    80000ac0:	0e450513          	add	a0,a0,228 # 80032ba0 <end>
    80000ac4:	f91ff0ef          	jal	80000a54 <freerange>
}
    80000ac8:	60a2                	ld	ra,8(sp)
    80000aca:	6402                	ld	s0,0(sp)
    80000acc:	0141                	add	sp,sp,16
    80000ace:	8082                	ret

0000000080000ad0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ad0:	1101                	add	sp,sp,-32
    80000ad2:	ec06                	sd	ra,24(sp)
    80000ad4:	e822                	sd	s0,16(sp)
    80000ad6:	e426                	sd	s1,8(sp)
    80000ad8:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000ada:	0000f497          	auipc	s1,0xf
    80000ade:	fa648493          	add	s1,s1,-90 # 8000fa80 <kmem>
    80000ae2:	8526                	mv	a0,s1
    80000ae4:	0bc000ef          	jal	80000ba0 <acquire>
  r = kmem.freelist;
    80000ae8:	6c84                	ld	s1,24(s1)
  if(r)
    80000aea:	c485                	beqz	s1,80000b12 <kalloc+0x42>
    kmem.freelist = r->next;
    80000aec:	609c                	ld	a5,0(s1)
    80000aee:	0000f517          	auipc	a0,0xf
    80000af2:	f9250513          	add	a0,a0,-110 # 8000fa80 <kmem>
    80000af6:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000af8:	140000ef          	jal	80000c38 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000afc:	6605                	lui	a2,0x1
    80000afe:	4595                	li	a1,5
    80000b00:	8526                	mv	a0,s1
    80000b02:	172000ef          	jal	80000c74 <memset>
  return (void*)r;
}
    80000b06:	8526                	mv	a0,s1
    80000b08:	60e2                	ld	ra,24(sp)
    80000b0a:	6442                	ld	s0,16(sp)
    80000b0c:	64a2                	ld	s1,8(sp)
    80000b0e:	6105                	add	sp,sp,32
    80000b10:	8082                	ret
  release(&kmem.lock);
    80000b12:	0000f517          	auipc	a0,0xf
    80000b16:	f6e50513          	add	a0,a0,-146 # 8000fa80 <kmem>
    80000b1a:	11e000ef          	jal	80000c38 <release>
  if(r)
    80000b1e:	b7e5                	j	80000b06 <kalloc+0x36>

0000000080000b20 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b20:	1141                	add	sp,sp,-16
    80000b22:	e422                	sd	s0,8(sp)
    80000b24:	0800                	add	s0,sp,16
  lk->name = name;
    80000b26:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b28:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b2c:	00053823          	sd	zero,16(a0)
}
    80000b30:	6422                	ld	s0,8(sp)
    80000b32:	0141                	add	sp,sp,16
    80000b34:	8082                	ret

0000000080000b36 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b36:	411c                	lw	a5,0(a0)
    80000b38:	e399                	bnez	a5,80000b3e <holding+0x8>
    80000b3a:	4501                	li	a0,0
  return r;
}
    80000b3c:	8082                	ret
{
    80000b3e:	1101                	add	sp,sp,-32
    80000b40:	ec06                	sd	ra,24(sp)
    80000b42:	e822                	sd	s0,16(sp)
    80000b44:	e426                	sd	s1,8(sp)
    80000b46:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b48:	6904                	ld	s1,16(a0)
    80000b4a:	4cb000ef          	jal	80001814 <mycpu>
    80000b4e:	40a48533          	sub	a0,s1,a0
    80000b52:	00153513          	seqz	a0,a0
}
    80000b56:	60e2                	ld	ra,24(sp)
    80000b58:	6442                	ld	s0,16(sp)
    80000b5a:	64a2                	ld	s1,8(sp)
    80000b5c:	6105                	add	sp,sp,32
    80000b5e:	8082                	ret

0000000080000b60 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b60:	1101                	add	sp,sp,-32
    80000b62:	ec06                	sd	ra,24(sp)
    80000b64:	e822                	sd	s0,16(sp)
    80000b66:	e426                	sd	s1,8(sp)
    80000b68:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b6a:	100024f3          	csrr	s1,sstatus
    80000b6e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b72:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b74:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b78:	49d000ef          	jal	80001814 <mycpu>
    80000b7c:	5d3c                	lw	a5,120(a0)
    80000b7e:	cb99                	beqz	a5,80000b94 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b80:	495000ef          	jal	80001814 <mycpu>
    80000b84:	5d3c                	lw	a5,120(a0)
    80000b86:	2785                	addw	a5,a5,1
    80000b88:	dd3c                	sw	a5,120(a0)
}
    80000b8a:	60e2                	ld	ra,24(sp)
    80000b8c:	6442                	ld	s0,16(sp)
    80000b8e:	64a2                	ld	s1,8(sp)
    80000b90:	6105                	add	sp,sp,32
    80000b92:	8082                	ret
    mycpu()->intena = old;
    80000b94:	481000ef          	jal	80001814 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000b98:	8085                	srl	s1,s1,0x1
    80000b9a:	8885                	and	s1,s1,1
    80000b9c:	dd64                	sw	s1,124(a0)
    80000b9e:	b7cd                	j	80000b80 <push_off+0x20>

0000000080000ba0 <acquire>:
{
    80000ba0:	1101                	add	sp,sp,-32
    80000ba2:	ec06                	sd	ra,24(sp)
    80000ba4:	e822                	sd	s0,16(sp)
    80000ba6:	e426                	sd	s1,8(sp)
    80000ba8:	1000                	add	s0,sp,32
    80000baa:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bac:	fb5ff0ef          	jal	80000b60 <push_off>
  if(holding(lk))
    80000bb0:	8526                	mv	a0,s1
    80000bb2:	f85ff0ef          	jal	80000b36 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bb6:	4705                	li	a4,1
  if(holding(lk))
    80000bb8:	e105                	bnez	a0,80000bd8 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bba:	87ba                	mv	a5,a4
    80000bbc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bc0:	2781                	sext.w	a5,a5
    80000bc2:	ffe5                	bnez	a5,80000bba <acquire+0x1a>
  __sync_synchronize();
    80000bc4:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bc8:	44d000ef          	jal	80001814 <mycpu>
    80000bcc:	e888                	sd	a0,16(s1)
}
    80000bce:	60e2                	ld	ra,24(sp)
    80000bd0:	6442                	ld	s0,16(sp)
    80000bd2:	64a2                	ld	s1,8(sp)
    80000bd4:	6105                	add	sp,sp,32
    80000bd6:	8082                	ret
    panic("acquire");
    80000bd8:	00006517          	auipc	a0,0x6
    80000bdc:	49050513          	add	a0,a0,1168 # 80007068 <digits+0x30>
    80000be0:	b7fff0ef          	jal	8000075e <panic>

0000000080000be4 <pop_off>:

void
pop_off(void)
{
    80000be4:	1141                	add	sp,sp,-16
    80000be6:	e406                	sd	ra,8(sp)
    80000be8:	e022                	sd	s0,0(sp)
    80000bea:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80000bec:	429000ef          	jal	80001814 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bf0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000bf4:	8b89                	and	a5,a5,2
  if(intr_get())
    80000bf6:	e78d                	bnez	a5,80000c20 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000bf8:	5d3c                	lw	a5,120(a0)
    80000bfa:	02f05963          	blez	a5,80000c2c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000bfe:	37fd                	addw	a5,a5,-1
    80000c00:	0007871b          	sext.w	a4,a5
    80000c04:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c06:	eb09                	bnez	a4,80000c18 <pop_off+0x34>
    80000c08:	5d7c                	lw	a5,124(a0)
    80000c0a:	c799                	beqz	a5,80000c18 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c0c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c10:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c14:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c18:	60a2                	ld	ra,8(sp)
    80000c1a:	6402                	ld	s0,0(sp)
    80000c1c:	0141                	add	sp,sp,16
    80000c1e:	8082                	ret
    panic("pop_off - interruptible");
    80000c20:	00006517          	auipc	a0,0x6
    80000c24:	45050513          	add	a0,a0,1104 # 80007070 <digits+0x38>
    80000c28:	b37ff0ef          	jal	8000075e <panic>
    panic("pop_off");
    80000c2c:	00006517          	auipc	a0,0x6
    80000c30:	45c50513          	add	a0,a0,1116 # 80007088 <digits+0x50>
    80000c34:	b2bff0ef          	jal	8000075e <panic>

0000000080000c38 <release>:
{
    80000c38:	1101                	add	sp,sp,-32
    80000c3a:	ec06                	sd	ra,24(sp)
    80000c3c:	e822                	sd	s0,16(sp)
    80000c3e:	e426                	sd	s1,8(sp)
    80000c40:	1000                	add	s0,sp,32
    80000c42:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c44:	ef3ff0ef          	jal	80000b36 <holding>
    80000c48:	c105                	beqz	a0,80000c68 <release+0x30>
  lk->cpu = 0;
    80000c4a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c4e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c52:	0f50000f          	fence	iorw,ow
    80000c56:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c5a:	f8bff0ef          	jal	80000be4 <pop_off>
}
    80000c5e:	60e2                	ld	ra,24(sp)
    80000c60:	6442                	ld	s0,16(sp)
    80000c62:	64a2                	ld	s1,8(sp)
    80000c64:	6105                	add	sp,sp,32
    80000c66:	8082                	ret
    panic("release");
    80000c68:	00006517          	auipc	a0,0x6
    80000c6c:	42850513          	add	a0,a0,1064 # 80007090 <digits+0x58>
    80000c70:	aefff0ef          	jal	8000075e <panic>

0000000080000c74 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000c74:	1141                	add	sp,sp,-16
    80000c76:	e422                	sd	s0,8(sp)
    80000c78:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000c7a:	ca19                	beqz	a2,80000c90 <memset+0x1c>
    80000c7c:	87aa                	mv	a5,a0
    80000c7e:	1602                	sll	a2,a2,0x20
    80000c80:	9201                	srl	a2,a2,0x20
    80000c82:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000c86:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000c8a:	0785                	add	a5,a5,1
    80000c8c:	fee79de3          	bne	a5,a4,80000c86 <memset+0x12>
  }
  return dst;
}
    80000c90:	6422                	ld	s0,8(sp)
    80000c92:	0141                	add	sp,sp,16
    80000c94:	8082                	ret

0000000080000c96 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000c96:	1141                	add	sp,sp,-16
    80000c98:	e422                	sd	s0,8(sp)
    80000c9a:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000c9c:	ca05                	beqz	a2,80000ccc <memcmp+0x36>
    80000c9e:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000ca2:	1682                	sll	a3,a3,0x20
    80000ca4:	9281                	srl	a3,a3,0x20
    80000ca6:	0685                	add	a3,a3,1
    80000ca8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000caa:	00054783          	lbu	a5,0(a0)
    80000cae:	0005c703          	lbu	a4,0(a1)
    80000cb2:	00e79863          	bne	a5,a4,80000cc2 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000cb6:	0505                	add	a0,a0,1
    80000cb8:	0585                	add	a1,a1,1
  while(n-- > 0){
    80000cba:	fed518e3          	bne	a0,a3,80000caa <memcmp+0x14>
  }

  return 0;
    80000cbe:	4501                	li	a0,0
    80000cc0:	a019                	j	80000cc6 <memcmp+0x30>
      return *s1 - *s2;
    80000cc2:	40e7853b          	subw	a0,a5,a4
}
    80000cc6:	6422                	ld	s0,8(sp)
    80000cc8:	0141                	add	sp,sp,16
    80000cca:	8082                	ret
  return 0;
    80000ccc:	4501                	li	a0,0
    80000cce:	bfe5                	j	80000cc6 <memcmp+0x30>

0000000080000cd0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000cd0:	1141                	add	sp,sp,-16
    80000cd2:	e422                	sd	s0,8(sp)
    80000cd4:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000cd6:	c205                	beqz	a2,80000cf6 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000cd8:	02a5e263          	bltu	a1,a0,80000cfc <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000cdc:	1602                	sll	a2,a2,0x20
    80000cde:	9201                	srl	a2,a2,0x20
    80000ce0:	00c587b3          	add	a5,a1,a2
{
    80000ce4:	872a                	mv	a4,a0
      *d++ = *s++;
    80000ce6:	0585                	add	a1,a1,1
    80000ce8:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffcc461>
    80000cea:	fff5c683          	lbu	a3,-1(a1)
    80000cee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000cf2:	fef59ae3          	bne	a1,a5,80000ce6 <memmove+0x16>

  return dst;
}
    80000cf6:	6422                	ld	s0,8(sp)
    80000cf8:	0141                	add	sp,sp,16
    80000cfa:	8082                	ret
  if(s < d && s + n > d){
    80000cfc:	02061693          	sll	a3,a2,0x20
    80000d00:	9281                	srl	a3,a3,0x20
    80000d02:	00d58733          	add	a4,a1,a3
    80000d06:	fce57be3          	bgeu	a0,a4,80000cdc <memmove+0xc>
    d += n;
    80000d0a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d0c:	fff6079b          	addw	a5,a2,-1
    80000d10:	1782                	sll	a5,a5,0x20
    80000d12:	9381                	srl	a5,a5,0x20
    80000d14:	fff7c793          	not	a5,a5
    80000d18:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d1a:	177d                	add	a4,a4,-1
    80000d1c:	16fd                	add	a3,a3,-1
    80000d1e:	00074603          	lbu	a2,0(a4)
    80000d22:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d26:	fee79ae3          	bne	a5,a4,80000d1a <memmove+0x4a>
    80000d2a:	b7f1                	j	80000cf6 <memmove+0x26>

0000000080000d2c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d2c:	1141                	add	sp,sp,-16
    80000d2e:	e406                	sd	ra,8(sp)
    80000d30:	e022                	sd	s0,0(sp)
    80000d32:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000d34:	f9dff0ef          	jal	80000cd0 <memmove>
}
    80000d38:	60a2                	ld	ra,8(sp)
    80000d3a:	6402                	ld	s0,0(sp)
    80000d3c:	0141                	add	sp,sp,16
    80000d3e:	8082                	ret

0000000080000d40 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d40:	1141                	add	sp,sp,-16
    80000d42:	e422                	sd	s0,8(sp)
    80000d44:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d46:	ce11                	beqz	a2,80000d62 <strncmp+0x22>
    80000d48:	00054783          	lbu	a5,0(a0)
    80000d4c:	cf89                	beqz	a5,80000d66 <strncmp+0x26>
    80000d4e:	0005c703          	lbu	a4,0(a1)
    80000d52:	00f71a63          	bne	a4,a5,80000d66 <strncmp+0x26>
    n--, p++, q++;
    80000d56:	367d                	addw	a2,a2,-1
    80000d58:	0505                	add	a0,a0,1
    80000d5a:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000d5c:	f675                	bnez	a2,80000d48 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000d5e:	4501                	li	a0,0
    80000d60:	a809                	j	80000d72 <strncmp+0x32>
    80000d62:	4501                	li	a0,0
    80000d64:	a039                	j	80000d72 <strncmp+0x32>
  if(n == 0)
    80000d66:	ca09                	beqz	a2,80000d78 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000d68:	00054503          	lbu	a0,0(a0)
    80000d6c:	0005c783          	lbu	a5,0(a1)
    80000d70:	9d1d                	subw	a0,a0,a5
}
    80000d72:	6422                	ld	s0,8(sp)
    80000d74:	0141                	add	sp,sp,16
    80000d76:	8082                	ret
    return 0;
    80000d78:	4501                	li	a0,0
    80000d7a:	bfe5                	j	80000d72 <strncmp+0x32>

0000000080000d7c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000d7c:	1141                	add	sp,sp,-16
    80000d7e:	e422                	sd	s0,8(sp)
    80000d80:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000d82:	87aa                	mv	a5,a0
    80000d84:	86b2                	mv	a3,a2
    80000d86:	367d                	addw	a2,a2,-1
    80000d88:	00d05963          	blez	a3,80000d9a <strncpy+0x1e>
    80000d8c:	0785                	add	a5,a5,1
    80000d8e:	0005c703          	lbu	a4,0(a1)
    80000d92:	fee78fa3          	sb	a4,-1(a5)
    80000d96:	0585                	add	a1,a1,1
    80000d98:	f775                	bnez	a4,80000d84 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000d9a:	873e                	mv	a4,a5
    80000d9c:	9fb5                	addw	a5,a5,a3
    80000d9e:	37fd                	addw	a5,a5,-1
    80000da0:	00c05963          	blez	a2,80000db2 <strncpy+0x36>
    *s++ = 0;
    80000da4:	0705                	add	a4,a4,1
    80000da6:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000daa:	40e786bb          	subw	a3,a5,a4
    80000dae:	fed04be3          	bgtz	a3,80000da4 <strncpy+0x28>
  return os;
}
    80000db2:	6422                	ld	s0,8(sp)
    80000db4:	0141                	add	sp,sp,16
    80000db6:	8082                	ret

0000000080000db8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000db8:	1141                	add	sp,sp,-16
    80000dba:	e422                	sd	s0,8(sp)
    80000dbc:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000dbe:	02c05363          	blez	a2,80000de4 <safestrcpy+0x2c>
    80000dc2:	fff6069b          	addw	a3,a2,-1
    80000dc6:	1682                	sll	a3,a3,0x20
    80000dc8:	9281                	srl	a3,a3,0x20
    80000dca:	96ae                	add	a3,a3,a1
    80000dcc:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000dce:	00d58963          	beq	a1,a3,80000de0 <safestrcpy+0x28>
    80000dd2:	0585                	add	a1,a1,1
    80000dd4:	0785                	add	a5,a5,1
    80000dd6:	fff5c703          	lbu	a4,-1(a1)
    80000dda:	fee78fa3          	sb	a4,-1(a5)
    80000dde:	fb65                	bnez	a4,80000dce <safestrcpy+0x16>
    ;
  *s = 0;
    80000de0:	00078023          	sb	zero,0(a5)
  return os;
}
    80000de4:	6422                	ld	s0,8(sp)
    80000de6:	0141                	add	sp,sp,16
    80000de8:	8082                	ret

0000000080000dea <strlen>:

int
strlen(const char *s)
{
    80000dea:	1141                	add	sp,sp,-16
    80000dec:	e422                	sd	s0,8(sp)
    80000dee:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000df0:	00054783          	lbu	a5,0(a0)
    80000df4:	cf91                	beqz	a5,80000e10 <strlen+0x26>
    80000df6:	0505                	add	a0,a0,1
    80000df8:	87aa                	mv	a5,a0
    80000dfa:	86be                	mv	a3,a5
    80000dfc:	0785                	add	a5,a5,1
    80000dfe:	fff7c703          	lbu	a4,-1(a5)
    80000e02:	ff65                	bnez	a4,80000dfa <strlen+0x10>
    80000e04:	40a6853b          	subw	a0,a3,a0
    80000e08:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000e0a:	6422                	ld	s0,8(sp)
    80000e0c:	0141                	add	sp,sp,16
    80000e0e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e10:	4501                	li	a0,0
    80000e12:	bfe5                	j	80000e0a <strlen+0x20>

0000000080000e14 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e14:	1141                	add	sp,sp,-16
    80000e16:	e406                	sd	ra,8(sp)
    80000e18:	e022                	sd	s0,0(sp)
    80000e1a:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000e1c:	1e9000ef          	jal	80001804 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e20:	00007717          	auipc	a4,0x7
    80000e24:	b3870713          	add	a4,a4,-1224 # 80007958 <started>
  if(cpuid() == 0){
    80000e28:	c51d                	beqz	a0,80000e56 <main+0x42>
    while(started == 0)
    80000e2a:	431c                	lw	a5,0(a4)
    80000e2c:	2781                	sext.w	a5,a5
    80000e2e:	dff5                	beqz	a5,80000e2a <main+0x16>
      ;
    __sync_synchronize();
    80000e30:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e34:	1d1000ef          	jal	80001804 <cpuid>
    80000e38:	85aa                	mv	a1,a0
    80000e3a:	00006517          	auipc	a0,0x6
    80000e3e:	27650513          	add	a0,a0,630 # 800070b0 <digits+0x78>
    80000e42:	e5cff0ef          	jal	8000049e <printf>
    kvminithart();    // turn on paging
    80000e46:	080000ef          	jal	80000ec6 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e4a:	7c8010ef          	jal	80002612 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e4e:	516040ef          	jal	80005364 <plicinithart>
  }

  scheduler();        
    80000e52:	635000ef          	jal	80001c86 <scheduler>
    consoleinit();
    80000e56:	d72ff0ef          	jal	800003c8 <consoleinit>
    printfinit();
    80000e5a:	93fff0ef          	jal	80000798 <printfinit>
    printf("\n");
    80000e5e:	00006517          	auipc	a0,0x6
    80000e62:	26250513          	add	a0,a0,610 # 800070c0 <digits+0x88>
    80000e66:	e38ff0ef          	jal	8000049e <printf>
    printf("xv6 kernel is booting\n");
    80000e6a:	00006517          	auipc	a0,0x6
    80000e6e:	22e50513          	add	a0,a0,558 # 80007098 <digits+0x60>
    80000e72:	e2cff0ef          	jal	8000049e <printf>
    printf("\n");
    80000e76:	00006517          	auipc	a0,0x6
    80000e7a:	24a50513          	add	a0,a0,586 # 800070c0 <digits+0x88>
    80000e7e:	e20ff0ef          	jal	8000049e <printf>
    kinit();         // physical page allocator
    80000e82:	c1bff0ef          	jal	80000a9c <kinit>
    kvminit();       // create kernel page table
    80000e86:	2ca000ef          	jal	80001150 <kvminit>
    kvminithart();   // turn on paging
    80000e8a:	03c000ef          	jal	80000ec6 <kvminithart>
    procinit();      // process table
    80000e8e:	0cf000ef          	jal	8000175c <procinit>
    trapinit();      // trap vectors
    80000e92:	75c010ef          	jal	800025ee <trapinit>
    trapinithart();  // install kernel trap vector
    80000e96:	77c010ef          	jal	80002612 <trapinithart>
    plicinit();      // set up interrupt controller
    80000e9a:	4b4040ef          	jal	8000534e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000e9e:	4c6040ef          	jal	80005364 <plicinithart>
    binit();         // buffer cache
    80000ea2:	59b010ef          	jal	80002c3c <binit>
    iinit();         // inode table
    80000ea6:	374020ef          	jal	8000321a <iinit>
    fileinit();      // file table
    80000eaa:	0e6030ef          	jal	80003f90 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000eae:	5a6040ef          	jal	80005454 <virtio_disk_init>
    userinit();      // first user process
    80000eb2:	3f7000ef          	jal	80001aa8 <userinit>
    __sync_synchronize();
    80000eb6:	0ff0000f          	fence
    started = 1;
    80000eba:	4785                	li	a5,1
    80000ebc:	00007717          	auipc	a4,0x7
    80000ec0:	a8f72e23          	sw	a5,-1380(a4) # 80007958 <started>
    80000ec4:	b779                	j	80000e52 <main+0x3e>

0000000080000ec6 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000ec6:	1141                	add	sp,sp,-16
    80000ec8:	e422                	sd	s0,8(sp)
    80000eca:	0800                	add	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000ecc:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000ed0:	00007797          	auipc	a5,0x7
    80000ed4:	a907b783          	ld	a5,-1392(a5) # 80007960 <kernel_pagetable>
    80000ed8:	83b1                	srl	a5,a5,0xc
    80000eda:	577d                	li	a4,-1
    80000edc:	177e                	sll	a4,a4,0x3f
    80000ede:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000ee0:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000ee4:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000ee8:	6422                	ld	s0,8(sp)
    80000eea:	0141                	add	sp,sp,16
    80000eec:	8082                	ret

0000000080000eee <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000eee:	7139                	add	sp,sp,-64
    80000ef0:	fc06                	sd	ra,56(sp)
    80000ef2:	f822                	sd	s0,48(sp)
    80000ef4:	f426                	sd	s1,40(sp)
    80000ef6:	f04a                	sd	s2,32(sp)
    80000ef8:	ec4e                	sd	s3,24(sp)
    80000efa:	e852                	sd	s4,16(sp)
    80000efc:	e456                	sd	s5,8(sp)
    80000efe:	e05a                	sd	s6,0(sp)
    80000f00:	0080                	add	s0,sp,64
    80000f02:	84aa                	mv	s1,a0
    80000f04:	89ae                	mv	s3,a1
    80000f06:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f08:	57fd                	li	a5,-1
    80000f0a:	83e9                	srl	a5,a5,0x1a
    80000f0c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f0e:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f10:	02b7fc63          	bgeu	a5,a1,80000f48 <walk+0x5a>
    panic("walk");
    80000f14:	00006517          	auipc	a0,0x6
    80000f18:	1b450513          	add	a0,a0,436 # 800070c8 <digits+0x90>
    80000f1c:	843ff0ef          	jal	8000075e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f20:	060a8263          	beqz	s5,80000f84 <walk+0x96>
    80000f24:	badff0ef          	jal	80000ad0 <kalloc>
    80000f28:	84aa                	mv	s1,a0
    80000f2a:	c139                	beqz	a0,80000f70 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f2c:	6605                	lui	a2,0x1
    80000f2e:	4581                	li	a1,0
    80000f30:	d45ff0ef          	jal	80000c74 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f34:	00c4d793          	srl	a5,s1,0xc
    80000f38:	07aa                	sll	a5,a5,0xa
    80000f3a:	0017e793          	or	a5,a5,1
    80000f3e:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f42:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffcc457>
    80000f44:	036a0063          	beq	s4,s6,80000f64 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f48:	0149d933          	srl	s2,s3,s4
    80000f4c:	1ff97913          	and	s2,s2,511
    80000f50:	090e                	sll	s2,s2,0x3
    80000f52:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f54:	00093483          	ld	s1,0(s2)
    80000f58:	0014f793          	and	a5,s1,1
    80000f5c:	d3f1                	beqz	a5,80000f20 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f5e:	80a9                	srl	s1,s1,0xa
    80000f60:	04b2                	sll	s1,s1,0xc
    80000f62:	b7c5                	j	80000f42 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000f64:	00c9d513          	srl	a0,s3,0xc
    80000f68:	1ff57513          	and	a0,a0,511
    80000f6c:	050e                	sll	a0,a0,0x3
    80000f6e:	9526                	add	a0,a0,s1
}
    80000f70:	70e2                	ld	ra,56(sp)
    80000f72:	7442                	ld	s0,48(sp)
    80000f74:	74a2                	ld	s1,40(sp)
    80000f76:	7902                	ld	s2,32(sp)
    80000f78:	69e2                	ld	s3,24(sp)
    80000f7a:	6a42                	ld	s4,16(sp)
    80000f7c:	6aa2                	ld	s5,8(sp)
    80000f7e:	6b02                	ld	s6,0(sp)
    80000f80:	6121                	add	sp,sp,64
    80000f82:	8082                	ret
        return 0;
    80000f84:	4501                	li	a0,0
    80000f86:	b7ed                	j	80000f70 <walk+0x82>

0000000080000f88 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000f88:	57fd                	li	a5,-1
    80000f8a:	83e9                	srl	a5,a5,0x1a
    80000f8c:	00b7f463          	bgeu	a5,a1,80000f94 <walkaddr+0xc>
    return 0;
    80000f90:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000f92:	8082                	ret
{
    80000f94:	1141                	add	sp,sp,-16
    80000f96:	e406                	sd	ra,8(sp)
    80000f98:	e022                	sd	s0,0(sp)
    80000f9a:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f9c:	4601                	li	a2,0
    80000f9e:	f51ff0ef          	jal	80000eee <walk>
  if(pte == 0)
    80000fa2:	c105                	beqz	a0,80000fc2 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000fa4:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000fa6:	0117f693          	and	a3,a5,17
    80000faa:	4745                	li	a4,17
    return 0;
    80000fac:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000fae:	00e68663          	beq	a3,a4,80000fba <walkaddr+0x32>
}
    80000fb2:	60a2                	ld	ra,8(sp)
    80000fb4:	6402                	ld	s0,0(sp)
    80000fb6:	0141                	add	sp,sp,16
    80000fb8:	8082                	ret
  pa = PTE2PA(*pte);
    80000fba:	83a9                	srl	a5,a5,0xa
    80000fbc:	00c79513          	sll	a0,a5,0xc
  return pa;
    80000fc0:	bfcd                	j	80000fb2 <walkaddr+0x2a>
    return 0;
    80000fc2:	4501                	li	a0,0
    80000fc4:	b7fd                	j	80000fb2 <walkaddr+0x2a>

0000000080000fc6 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000fc6:	715d                	add	sp,sp,-80
    80000fc8:	e486                	sd	ra,72(sp)
    80000fca:	e0a2                	sd	s0,64(sp)
    80000fcc:	fc26                	sd	s1,56(sp)
    80000fce:	f84a                	sd	s2,48(sp)
    80000fd0:	f44e                	sd	s3,40(sp)
    80000fd2:	f052                	sd	s4,32(sp)
    80000fd4:	ec56                	sd	s5,24(sp)
    80000fd6:	e85a                	sd	s6,16(sp)
    80000fd8:	e45e                	sd	s7,8(sp)
    80000fda:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000fdc:	03459793          	sll	a5,a1,0x34
    80000fe0:	e7a9                	bnez	a5,8000102a <mappages+0x64>
    80000fe2:	8aaa                	mv	s5,a0
    80000fe4:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000fe6:	03461793          	sll	a5,a2,0x34
    80000fea:	e7b1                	bnez	a5,80001036 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80000fec:	ca39                	beqz	a2,80001042 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000fee:	77fd                	lui	a5,0xfffff
    80000ff0:	963e                	add	a2,a2,a5
    80000ff2:	00b609b3          	add	s3,a2,a1
  a = va;
    80000ff6:	892e                	mv	s2,a1
    80000ff8:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000ffc:	6b85                	lui	s7,0x1
    80000ffe:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001002:	4605                	li	a2,1
    80001004:	85ca                	mv	a1,s2
    80001006:	8556                	mv	a0,s5
    80001008:	ee7ff0ef          	jal	80000eee <walk>
    8000100c:	c539                	beqz	a0,8000105a <mappages+0x94>
    if(*pte & PTE_V)
    8000100e:	611c                	ld	a5,0(a0)
    80001010:	8b85                	and	a5,a5,1
    80001012:	ef95                	bnez	a5,8000104e <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001014:	80b1                	srl	s1,s1,0xc
    80001016:	04aa                	sll	s1,s1,0xa
    80001018:	0164e4b3          	or	s1,s1,s6
    8000101c:	0014e493          	or	s1,s1,1
    80001020:	e104                	sd	s1,0(a0)
    if(a == last)
    80001022:	05390863          	beq	s2,s3,80001072 <mappages+0xac>
    a += PGSIZE;
    80001026:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001028:	bfd9                	j	80000ffe <mappages+0x38>
    panic("mappages: va not aligned");
    8000102a:	00006517          	auipc	a0,0x6
    8000102e:	0a650513          	add	a0,a0,166 # 800070d0 <digits+0x98>
    80001032:	f2cff0ef          	jal	8000075e <panic>
    panic("mappages: size not aligned");
    80001036:	00006517          	auipc	a0,0x6
    8000103a:	0ba50513          	add	a0,a0,186 # 800070f0 <digits+0xb8>
    8000103e:	f20ff0ef          	jal	8000075e <panic>
    panic("mappages: size");
    80001042:	00006517          	auipc	a0,0x6
    80001046:	0ce50513          	add	a0,a0,206 # 80007110 <digits+0xd8>
    8000104a:	f14ff0ef          	jal	8000075e <panic>
      panic("mappages: remap");
    8000104e:	00006517          	auipc	a0,0x6
    80001052:	0d250513          	add	a0,a0,210 # 80007120 <digits+0xe8>
    80001056:	f08ff0ef          	jal	8000075e <panic>
      return -1;
    8000105a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000105c:	60a6                	ld	ra,72(sp)
    8000105e:	6406                	ld	s0,64(sp)
    80001060:	74e2                	ld	s1,56(sp)
    80001062:	7942                	ld	s2,48(sp)
    80001064:	79a2                	ld	s3,40(sp)
    80001066:	7a02                	ld	s4,32(sp)
    80001068:	6ae2                	ld	s5,24(sp)
    8000106a:	6b42                	ld	s6,16(sp)
    8000106c:	6ba2                	ld	s7,8(sp)
    8000106e:	6161                	add	sp,sp,80
    80001070:	8082                	ret
  return 0;
    80001072:	4501                	li	a0,0
    80001074:	b7e5                	j	8000105c <mappages+0x96>

0000000080001076 <kvmmap>:
{
    80001076:	1141                	add	sp,sp,-16
    80001078:	e406                	sd	ra,8(sp)
    8000107a:	e022                	sd	s0,0(sp)
    8000107c:	0800                	add	s0,sp,16
    8000107e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001080:	86b2                	mv	a3,a2
    80001082:	863e                	mv	a2,a5
    80001084:	f43ff0ef          	jal	80000fc6 <mappages>
    80001088:	e509                	bnez	a0,80001092 <kvmmap+0x1c>
}
    8000108a:	60a2                	ld	ra,8(sp)
    8000108c:	6402                	ld	s0,0(sp)
    8000108e:	0141                	add	sp,sp,16
    80001090:	8082                	ret
    panic("kvmmap");
    80001092:	00006517          	auipc	a0,0x6
    80001096:	09e50513          	add	a0,a0,158 # 80007130 <digits+0xf8>
    8000109a:	ec4ff0ef          	jal	8000075e <panic>

000000008000109e <kvmmake>:
{
    8000109e:	1101                	add	sp,sp,-32
    800010a0:	ec06                	sd	ra,24(sp)
    800010a2:	e822                	sd	s0,16(sp)
    800010a4:	e426                	sd	s1,8(sp)
    800010a6:	e04a                	sd	s2,0(sp)
    800010a8:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010aa:	a27ff0ef          	jal	80000ad0 <kalloc>
    800010ae:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010b0:	6605                	lui	a2,0x1
    800010b2:	4581                	li	a1,0
    800010b4:	bc1ff0ef          	jal	80000c74 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800010b8:	4719                	li	a4,6
    800010ba:	6685                	lui	a3,0x1
    800010bc:	10000637          	lui	a2,0x10000
    800010c0:	100005b7          	lui	a1,0x10000
    800010c4:	8526                	mv	a0,s1
    800010c6:	fb1ff0ef          	jal	80001076 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800010ca:	4719                	li	a4,6
    800010cc:	6685                	lui	a3,0x1
    800010ce:	10001637          	lui	a2,0x10001
    800010d2:	100015b7          	lui	a1,0x10001
    800010d6:	8526                	mv	a0,s1
    800010d8:	f9fff0ef          	jal	80001076 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800010dc:	4719                	li	a4,6
    800010de:	040006b7          	lui	a3,0x4000
    800010e2:	0c000637          	lui	a2,0xc000
    800010e6:	0c0005b7          	lui	a1,0xc000
    800010ea:	8526                	mv	a0,s1
    800010ec:	f8bff0ef          	jal	80001076 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800010f0:	00006917          	auipc	s2,0x6
    800010f4:	f1090913          	add	s2,s2,-240 # 80007000 <etext>
    800010f8:	4729                	li	a4,10
    800010fa:	80006697          	auipc	a3,0x80006
    800010fe:	f0668693          	add	a3,a3,-250 # 7000 <_entry-0x7fff9000>
    80001102:	4605                	li	a2,1
    80001104:	067e                	sll	a2,a2,0x1f
    80001106:	85b2                	mv	a1,a2
    80001108:	8526                	mv	a0,s1
    8000110a:	f6dff0ef          	jal	80001076 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000110e:	4719                	li	a4,6
    80001110:	46c5                	li	a3,17
    80001112:	06ee                	sll	a3,a3,0x1b
    80001114:	412686b3          	sub	a3,a3,s2
    80001118:	864a                	mv	a2,s2
    8000111a:	85ca                	mv	a1,s2
    8000111c:	8526                	mv	a0,s1
    8000111e:	f59ff0ef          	jal	80001076 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001122:	4729                	li	a4,10
    80001124:	6685                	lui	a3,0x1
    80001126:	00005617          	auipc	a2,0x5
    8000112a:	eda60613          	add	a2,a2,-294 # 80006000 <_trampoline>
    8000112e:	040005b7          	lui	a1,0x4000
    80001132:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001134:	05b2                	sll	a1,a1,0xc
    80001136:	8526                	mv	a0,s1
    80001138:	f3fff0ef          	jal	80001076 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000113c:	8526                	mv	a0,s1
    8000113e:	594000ef          	jal	800016d2 <proc_mapstacks>
}
    80001142:	8526                	mv	a0,s1
    80001144:	60e2                	ld	ra,24(sp)
    80001146:	6442                	ld	s0,16(sp)
    80001148:	64a2                	ld	s1,8(sp)
    8000114a:	6902                	ld	s2,0(sp)
    8000114c:	6105                	add	sp,sp,32
    8000114e:	8082                	ret

0000000080001150 <kvminit>:
{
    80001150:	1141                	add	sp,sp,-16
    80001152:	e406                	sd	ra,8(sp)
    80001154:	e022                	sd	s0,0(sp)
    80001156:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80001158:	f47ff0ef          	jal	8000109e <kvmmake>
    8000115c:	00007797          	auipc	a5,0x7
    80001160:	80a7b223          	sd	a0,-2044(a5) # 80007960 <kernel_pagetable>
}
    80001164:	60a2                	ld	ra,8(sp)
    80001166:	6402                	ld	s0,0(sp)
    80001168:	0141                	add	sp,sp,16
    8000116a:	8082                	ret

000000008000116c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000116c:	715d                	add	sp,sp,-80
    8000116e:	e486                	sd	ra,72(sp)
    80001170:	e0a2                	sd	s0,64(sp)
    80001172:	fc26                	sd	s1,56(sp)
    80001174:	f84a                	sd	s2,48(sp)
    80001176:	f44e                	sd	s3,40(sp)
    80001178:	f052                	sd	s4,32(sp)
    8000117a:	ec56                	sd	s5,24(sp)
    8000117c:	e85a                	sd	s6,16(sp)
    8000117e:	e45e                	sd	s7,8(sp)
    80001180:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001182:	03459793          	sll	a5,a1,0x34
    80001186:	e795                	bnez	a5,800011b2 <uvmunmap+0x46>
    80001188:	8a2a                	mv	s4,a0
    8000118a:	892e                	mv	s2,a1
    8000118c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000118e:	0632                	sll	a2,a2,0xc
    80001190:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001194:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001196:	6b05                	lui	s6,0x1
    80001198:	0535ea63          	bltu	a1,s3,800011ec <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000119c:	60a6                	ld	ra,72(sp)
    8000119e:	6406                	ld	s0,64(sp)
    800011a0:	74e2                	ld	s1,56(sp)
    800011a2:	7942                	ld	s2,48(sp)
    800011a4:	79a2                	ld	s3,40(sp)
    800011a6:	7a02                	ld	s4,32(sp)
    800011a8:	6ae2                	ld	s5,24(sp)
    800011aa:	6b42                	ld	s6,16(sp)
    800011ac:	6ba2                	ld	s7,8(sp)
    800011ae:	6161                	add	sp,sp,80
    800011b0:	8082                	ret
    panic("uvmunmap: not aligned");
    800011b2:	00006517          	auipc	a0,0x6
    800011b6:	f8650513          	add	a0,a0,-122 # 80007138 <digits+0x100>
    800011ba:	da4ff0ef          	jal	8000075e <panic>
      panic("uvmunmap: walk");
    800011be:	00006517          	auipc	a0,0x6
    800011c2:	f9250513          	add	a0,a0,-110 # 80007150 <digits+0x118>
    800011c6:	d98ff0ef          	jal	8000075e <panic>
      panic("uvmunmap: not mapped");
    800011ca:	00006517          	auipc	a0,0x6
    800011ce:	f9650513          	add	a0,a0,-106 # 80007160 <digits+0x128>
    800011d2:	d8cff0ef          	jal	8000075e <panic>
      panic("uvmunmap: not a leaf");
    800011d6:	00006517          	auipc	a0,0x6
    800011da:	fa250513          	add	a0,a0,-94 # 80007178 <digits+0x140>
    800011de:	d80ff0ef          	jal	8000075e <panic>
    *pte = 0;
    800011e2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011e6:	995a                	add	s2,s2,s6
    800011e8:	fb397ae3          	bgeu	s2,s3,8000119c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800011ec:	4601                	li	a2,0
    800011ee:	85ca                	mv	a1,s2
    800011f0:	8552                	mv	a0,s4
    800011f2:	cfdff0ef          	jal	80000eee <walk>
    800011f6:	84aa                	mv	s1,a0
    800011f8:	d179                	beqz	a0,800011be <uvmunmap+0x52>
    if((*pte & PTE_V) == 0)
    800011fa:	6108                	ld	a0,0(a0)
    800011fc:	00157793          	and	a5,a0,1
    80001200:	d7e9                	beqz	a5,800011ca <uvmunmap+0x5e>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001202:	3ff57793          	and	a5,a0,1023
    80001206:	fd7788e3          	beq	a5,s7,800011d6 <uvmunmap+0x6a>
    if(do_free){
    8000120a:	fc0a8ce3          	beqz	s5,800011e2 <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    8000120e:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    80001210:	0532                	sll	a0,a0,0xc
    80001212:	fdcff0ef          	jal	800009ee <kfree>
    80001216:	b7f1                	j	800011e2 <uvmunmap+0x76>

0000000080001218 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001218:	1101                	add	sp,sp,-32
    8000121a:	ec06                	sd	ra,24(sp)
    8000121c:	e822                	sd	s0,16(sp)
    8000121e:	e426                	sd	s1,8(sp)
    80001220:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001222:	8afff0ef          	jal	80000ad0 <kalloc>
    80001226:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001228:	c509                	beqz	a0,80001232 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000122a:	6605                	lui	a2,0x1
    8000122c:	4581                	li	a1,0
    8000122e:	a47ff0ef          	jal	80000c74 <memset>
  return pagetable;
}
    80001232:	8526                	mv	a0,s1
    80001234:	60e2                	ld	ra,24(sp)
    80001236:	6442                	ld	s0,16(sp)
    80001238:	64a2                	ld	s1,8(sp)
    8000123a:	6105                	add	sp,sp,32
    8000123c:	8082                	ret

000000008000123e <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000123e:	7179                	add	sp,sp,-48
    80001240:	f406                	sd	ra,40(sp)
    80001242:	f022                	sd	s0,32(sp)
    80001244:	ec26                	sd	s1,24(sp)
    80001246:	e84a                	sd	s2,16(sp)
    80001248:	e44e                	sd	s3,8(sp)
    8000124a:	e052                	sd	s4,0(sp)
    8000124c:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000124e:	6785                	lui	a5,0x1
    80001250:	04f67063          	bgeu	a2,a5,80001290 <uvmfirst+0x52>
    80001254:	8a2a                	mv	s4,a0
    80001256:	89ae                	mv	s3,a1
    80001258:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000125a:	877ff0ef          	jal	80000ad0 <kalloc>
    8000125e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001260:	6605                	lui	a2,0x1
    80001262:	4581                	li	a1,0
    80001264:	a11ff0ef          	jal	80000c74 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001268:	4779                	li	a4,30
    8000126a:	86ca                	mv	a3,s2
    8000126c:	6605                	lui	a2,0x1
    8000126e:	4581                	li	a1,0
    80001270:	8552                	mv	a0,s4
    80001272:	d55ff0ef          	jal	80000fc6 <mappages>
  memmove(mem, src, sz);
    80001276:	8626                	mv	a2,s1
    80001278:	85ce                	mv	a1,s3
    8000127a:	854a                	mv	a0,s2
    8000127c:	a55ff0ef          	jal	80000cd0 <memmove>
}
    80001280:	70a2                	ld	ra,40(sp)
    80001282:	7402                	ld	s0,32(sp)
    80001284:	64e2                	ld	s1,24(sp)
    80001286:	6942                	ld	s2,16(sp)
    80001288:	69a2                	ld	s3,8(sp)
    8000128a:	6a02                	ld	s4,0(sp)
    8000128c:	6145                	add	sp,sp,48
    8000128e:	8082                	ret
    panic("uvmfirst: more than a page");
    80001290:	00006517          	auipc	a0,0x6
    80001294:	f0050513          	add	a0,a0,-256 # 80007190 <digits+0x158>
    80001298:	cc6ff0ef          	jal	8000075e <panic>

000000008000129c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000129c:	1101                	add	sp,sp,-32
    8000129e:	ec06                	sd	ra,24(sp)
    800012a0:	e822                	sd	s0,16(sp)
    800012a2:	e426                	sd	s1,8(sp)
    800012a4:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800012a6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800012a8:	00b67d63          	bgeu	a2,a1,800012c2 <uvmdealloc+0x26>
    800012ac:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800012ae:	6785                	lui	a5,0x1
    800012b0:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012b2:	00f60733          	add	a4,a2,a5
    800012b6:	76fd                	lui	a3,0xfffff
    800012b8:	8f75                	and	a4,a4,a3
    800012ba:	97ae                	add	a5,a5,a1
    800012bc:	8ff5                	and	a5,a5,a3
    800012be:	00f76863          	bltu	a4,a5,800012ce <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800012c2:	8526                	mv	a0,s1
    800012c4:	60e2                	ld	ra,24(sp)
    800012c6:	6442                	ld	s0,16(sp)
    800012c8:	64a2                	ld	s1,8(sp)
    800012ca:	6105                	add	sp,sp,32
    800012cc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012ce:	8f99                	sub	a5,a5,a4
    800012d0:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012d2:	4685                	li	a3,1
    800012d4:	0007861b          	sext.w	a2,a5
    800012d8:	85ba                	mv	a1,a4
    800012da:	e93ff0ef          	jal	8000116c <uvmunmap>
    800012de:	b7d5                	j	800012c2 <uvmdealloc+0x26>

00000000800012e0 <uvmalloc>:
  if(newsz < oldsz)
    800012e0:	08b66963          	bltu	a2,a1,80001372 <uvmalloc+0x92>
{
    800012e4:	7139                	add	sp,sp,-64
    800012e6:	fc06                	sd	ra,56(sp)
    800012e8:	f822                	sd	s0,48(sp)
    800012ea:	f426                	sd	s1,40(sp)
    800012ec:	f04a                	sd	s2,32(sp)
    800012ee:	ec4e                	sd	s3,24(sp)
    800012f0:	e852                	sd	s4,16(sp)
    800012f2:	e456                	sd	s5,8(sp)
    800012f4:	e05a                	sd	s6,0(sp)
    800012f6:	0080                	add	s0,sp,64
    800012f8:	8aaa                	mv	s5,a0
    800012fa:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012fc:	6785                	lui	a5,0x1
    800012fe:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001300:	95be                	add	a1,a1,a5
    80001302:	77fd                	lui	a5,0xfffff
    80001304:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001308:	06c9f763          	bgeu	s3,a2,80001376 <uvmalloc+0x96>
    8000130c:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000130e:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    80001312:	fbeff0ef          	jal	80000ad0 <kalloc>
    80001316:	84aa                	mv	s1,a0
    if(mem == 0){
    80001318:	c11d                	beqz	a0,8000133e <uvmalloc+0x5e>
    memset(mem, 0, PGSIZE);
    8000131a:	6605                	lui	a2,0x1
    8000131c:	4581                	li	a1,0
    8000131e:	957ff0ef          	jal	80000c74 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001322:	875a                	mv	a4,s6
    80001324:	86a6                	mv	a3,s1
    80001326:	6605                	lui	a2,0x1
    80001328:	85ca                	mv	a1,s2
    8000132a:	8556                	mv	a0,s5
    8000132c:	c9bff0ef          	jal	80000fc6 <mappages>
    80001330:	e51d                	bnez	a0,8000135e <uvmalloc+0x7e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001332:	6785                	lui	a5,0x1
    80001334:	993e                	add	s2,s2,a5
    80001336:	fd496ee3          	bltu	s2,s4,80001312 <uvmalloc+0x32>
  return newsz;
    8000133a:	8552                	mv	a0,s4
    8000133c:	a039                	j	8000134a <uvmalloc+0x6a>
      uvmdealloc(pagetable, a, oldsz);
    8000133e:	864e                	mv	a2,s3
    80001340:	85ca                	mv	a1,s2
    80001342:	8556                	mv	a0,s5
    80001344:	f59ff0ef          	jal	8000129c <uvmdealloc>
      return 0;
    80001348:	4501                	li	a0,0
}
    8000134a:	70e2                	ld	ra,56(sp)
    8000134c:	7442                	ld	s0,48(sp)
    8000134e:	74a2                	ld	s1,40(sp)
    80001350:	7902                	ld	s2,32(sp)
    80001352:	69e2                	ld	s3,24(sp)
    80001354:	6a42                	ld	s4,16(sp)
    80001356:	6aa2                	ld	s5,8(sp)
    80001358:	6b02                	ld	s6,0(sp)
    8000135a:	6121                	add	sp,sp,64
    8000135c:	8082                	ret
      kfree(mem);
    8000135e:	8526                	mv	a0,s1
    80001360:	e8eff0ef          	jal	800009ee <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001364:	864e                	mv	a2,s3
    80001366:	85ca                	mv	a1,s2
    80001368:	8556                	mv	a0,s5
    8000136a:	f33ff0ef          	jal	8000129c <uvmdealloc>
      return 0;
    8000136e:	4501                	li	a0,0
    80001370:	bfe9                	j	8000134a <uvmalloc+0x6a>
    return oldsz;
    80001372:	852e                	mv	a0,a1
}
    80001374:	8082                	ret
  return newsz;
    80001376:	8532                	mv	a0,a2
    80001378:	bfc9                	j	8000134a <uvmalloc+0x6a>

000000008000137a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000137a:	7179                	add	sp,sp,-48
    8000137c:	f406                	sd	ra,40(sp)
    8000137e:	f022                	sd	s0,32(sp)
    80001380:	ec26                	sd	s1,24(sp)
    80001382:	e84a                	sd	s2,16(sp)
    80001384:	e44e                	sd	s3,8(sp)
    80001386:	e052                	sd	s4,0(sp)
    80001388:	1800                	add	s0,sp,48
    8000138a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000138c:	84aa                	mv	s1,a0
    8000138e:	6905                	lui	s2,0x1
    80001390:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001392:	4985                	li	s3,1
    80001394:	a819                	j	800013aa <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001396:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001398:	00c79513          	sll	a0,a5,0xc
    8000139c:	fdfff0ef          	jal	8000137a <freewalk>
      pagetable[i] = 0;
    800013a0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800013a4:	04a1                	add	s1,s1,8
    800013a6:	01248f63          	beq	s1,s2,800013c4 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800013aa:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013ac:	00f7f713          	and	a4,a5,15
    800013b0:	ff3703e3          	beq	a4,s3,80001396 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800013b4:	8b85                	and	a5,a5,1
    800013b6:	d7fd                	beqz	a5,800013a4 <freewalk+0x2a>
      panic("freewalk: leaf");
    800013b8:	00006517          	auipc	a0,0x6
    800013bc:	df850513          	add	a0,a0,-520 # 800071b0 <digits+0x178>
    800013c0:	b9eff0ef          	jal	8000075e <panic>
    }
  }
  kfree((void*)pagetable);
    800013c4:	8552                	mv	a0,s4
    800013c6:	e28ff0ef          	jal	800009ee <kfree>
}
    800013ca:	70a2                	ld	ra,40(sp)
    800013cc:	7402                	ld	s0,32(sp)
    800013ce:	64e2                	ld	s1,24(sp)
    800013d0:	6942                	ld	s2,16(sp)
    800013d2:	69a2                	ld	s3,8(sp)
    800013d4:	6a02                	ld	s4,0(sp)
    800013d6:	6145                	add	sp,sp,48
    800013d8:	8082                	ret

00000000800013da <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013da:	1101                	add	sp,sp,-32
    800013dc:	ec06                	sd	ra,24(sp)
    800013de:	e822                	sd	s0,16(sp)
    800013e0:	e426                	sd	s1,8(sp)
    800013e2:	1000                	add	s0,sp,32
    800013e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800013e6:	e989                	bnez	a1,800013f8 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800013e8:	8526                	mv	a0,s1
    800013ea:	f91ff0ef          	jal	8000137a <freewalk>
}
    800013ee:	60e2                	ld	ra,24(sp)
    800013f0:	6442                	ld	s0,16(sp)
    800013f2:	64a2                	ld	s1,8(sp)
    800013f4:	6105                	add	sp,sp,32
    800013f6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800013f8:	6785                	lui	a5,0x1
    800013fa:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013fc:	95be                	add	a1,a1,a5
    800013fe:	4685                	li	a3,1
    80001400:	00c5d613          	srl	a2,a1,0xc
    80001404:	4581                	li	a1,0
    80001406:	d67ff0ef          	jal	8000116c <uvmunmap>
    8000140a:	bff9                	j	800013e8 <uvmfree+0xe>

000000008000140c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000140c:	c65d                	beqz	a2,800014ba <uvmcopy+0xae>
{
    8000140e:	715d                	add	sp,sp,-80
    80001410:	e486                	sd	ra,72(sp)
    80001412:	e0a2                	sd	s0,64(sp)
    80001414:	fc26                	sd	s1,56(sp)
    80001416:	f84a                	sd	s2,48(sp)
    80001418:	f44e                	sd	s3,40(sp)
    8000141a:	f052                	sd	s4,32(sp)
    8000141c:	ec56                	sd	s5,24(sp)
    8000141e:	e85a                	sd	s6,16(sp)
    80001420:	e45e                	sd	s7,8(sp)
    80001422:	0880                	add	s0,sp,80
    80001424:	8b2a                	mv	s6,a0
    80001426:	8aae                	mv	s5,a1
    80001428:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000142a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000142c:	4601                	li	a2,0
    8000142e:	85ce                	mv	a1,s3
    80001430:	855a                	mv	a0,s6
    80001432:	abdff0ef          	jal	80000eee <walk>
    80001436:	c121                	beqz	a0,80001476 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001438:	6118                	ld	a4,0(a0)
    8000143a:	00177793          	and	a5,a4,1
    8000143e:	c3b1                	beqz	a5,80001482 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001440:	00a75593          	srl	a1,a4,0xa
    80001444:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001448:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000144c:	e84ff0ef          	jal	80000ad0 <kalloc>
    80001450:	892a                	mv	s2,a0
    80001452:	c129                	beqz	a0,80001494 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001454:	6605                	lui	a2,0x1
    80001456:	85de                	mv	a1,s7
    80001458:	879ff0ef          	jal	80000cd0 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000145c:	8726                	mv	a4,s1
    8000145e:	86ca                	mv	a3,s2
    80001460:	6605                	lui	a2,0x1
    80001462:	85ce                	mv	a1,s3
    80001464:	8556                	mv	a0,s5
    80001466:	b61ff0ef          	jal	80000fc6 <mappages>
    8000146a:	e115                	bnez	a0,8000148e <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    8000146c:	6785                	lui	a5,0x1
    8000146e:	99be                	add	s3,s3,a5
    80001470:	fb49eee3          	bltu	s3,s4,8000142c <uvmcopy+0x20>
    80001474:	a805                	j	800014a4 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80001476:	00006517          	auipc	a0,0x6
    8000147a:	d4a50513          	add	a0,a0,-694 # 800071c0 <digits+0x188>
    8000147e:	ae0ff0ef          	jal	8000075e <panic>
      panic("uvmcopy: page not present");
    80001482:	00006517          	auipc	a0,0x6
    80001486:	d5e50513          	add	a0,a0,-674 # 800071e0 <digits+0x1a8>
    8000148a:	ad4ff0ef          	jal	8000075e <panic>
      kfree(mem);
    8000148e:	854a                	mv	a0,s2
    80001490:	d5eff0ef          	jal	800009ee <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001494:	4685                	li	a3,1
    80001496:	00c9d613          	srl	a2,s3,0xc
    8000149a:	4581                	li	a1,0
    8000149c:	8556                	mv	a0,s5
    8000149e:	ccfff0ef          	jal	8000116c <uvmunmap>
  return -1;
    800014a2:	557d                	li	a0,-1
}
    800014a4:	60a6                	ld	ra,72(sp)
    800014a6:	6406                	ld	s0,64(sp)
    800014a8:	74e2                	ld	s1,56(sp)
    800014aa:	7942                	ld	s2,48(sp)
    800014ac:	79a2                	ld	s3,40(sp)
    800014ae:	7a02                	ld	s4,32(sp)
    800014b0:	6ae2                	ld	s5,24(sp)
    800014b2:	6b42                	ld	s6,16(sp)
    800014b4:	6ba2                	ld	s7,8(sp)
    800014b6:	6161                	add	sp,sp,80
    800014b8:	8082                	ret
  return 0;
    800014ba:	4501                	li	a0,0
}
    800014bc:	8082                	ret

00000000800014be <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014be:	1141                	add	sp,sp,-16
    800014c0:	e406                	sd	ra,8(sp)
    800014c2:	e022                	sd	s0,0(sp)
    800014c4:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800014c6:	4601                	li	a2,0
    800014c8:	a27ff0ef          	jal	80000eee <walk>
  if(pte == 0)
    800014cc:	c901                	beqz	a0,800014dc <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800014ce:	611c                	ld	a5,0(a0)
    800014d0:	9bbd                	and	a5,a5,-17
    800014d2:	e11c                	sd	a5,0(a0)
}
    800014d4:	60a2                	ld	ra,8(sp)
    800014d6:	6402                	ld	s0,0(sp)
    800014d8:	0141                	add	sp,sp,16
    800014da:	8082                	ret
    panic("uvmclear");
    800014dc:	00006517          	auipc	a0,0x6
    800014e0:	d2450513          	add	a0,a0,-732 # 80007200 <digits+0x1c8>
    800014e4:	a7aff0ef          	jal	8000075e <panic>

00000000800014e8 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800014e8:	c6c9                	beqz	a3,80001572 <copyout+0x8a>
{
    800014ea:	711d                	add	sp,sp,-96
    800014ec:	ec86                	sd	ra,88(sp)
    800014ee:	e8a2                	sd	s0,80(sp)
    800014f0:	e4a6                	sd	s1,72(sp)
    800014f2:	e0ca                	sd	s2,64(sp)
    800014f4:	fc4e                	sd	s3,56(sp)
    800014f6:	f852                	sd	s4,48(sp)
    800014f8:	f456                	sd	s5,40(sp)
    800014fa:	f05a                	sd	s6,32(sp)
    800014fc:	ec5e                	sd	s7,24(sp)
    800014fe:	e862                	sd	s8,16(sp)
    80001500:	e466                	sd	s9,8(sp)
    80001502:	e06a                	sd	s10,0(sp)
    80001504:	1080                	add	s0,sp,96
    80001506:	8baa                	mv	s7,a0
    80001508:	8aae                	mv	s5,a1
    8000150a:	8b32                	mv	s6,a2
    8000150c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000150e:	74fd                	lui	s1,0xfffff
    80001510:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001512:	57fd                	li	a5,-1
    80001514:	83e9                	srl	a5,a5,0x1a
    80001516:	0697e063          	bltu	a5,s1,80001576 <copyout+0x8e>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    8000151a:	4cd5                	li	s9,21
    8000151c:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    8000151e:	8c3e                	mv	s8,a5
    80001520:	a025                	j	80001548 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80001522:	83a9                	srl	a5,a5,0xa
    80001524:	07b2                	sll	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001526:	409a8533          	sub	a0,s5,s1
    8000152a:	0009061b          	sext.w	a2,s2
    8000152e:	85da                	mv	a1,s6
    80001530:	953e                	add	a0,a0,a5
    80001532:	f9eff0ef          	jal	80000cd0 <memmove>

    len -= n;
    80001536:	412989b3          	sub	s3,s3,s2
    src += n;
    8000153a:	9b4a                	add	s6,s6,s2
  while(len > 0){
    8000153c:	02098963          	beqz	s3,8000156e <copyout+0x86>
    if(va0 >= MAXVA)
    80001540:	034c6d63          	bltu	s8,s4,8000157a <copyout+0x92>
    va0 = PGROUNDDOWN(dstva);
    80001544:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80001546:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80001548:	4601                	li	a2,0
    8000154a:	85a6                	mv	a1,s1
    8000154c:	855e                	mv	a0,s7
    8000154e:	9a1ff0ef          	jal	80000eee <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001552:	c515                	beqz	a0,8000157e <copyout+0x96>
    80001554:	611c                	ld	a5,0(a0)
    80001556:	0157f713          	and	a4,a5,21
    8000155a:	05971163          	bne	a4,s9,8000159c <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    8000155e:	01a48a33          	add	s4,s1,s10
    80001562:	415a0933          	sub	s2,s4,s5
    80001566:	fb29fee3          	bgeu	s3,s2,80001522 <copyout+0x3a>
    8000156a:	894e                	mv	s2,s3
    8000156c:	bf5d                	j	80001522 <copyout+0x3a>
  }
  return 0;
    8000156e:	4501                	li	a0,0
    80001570:	a801                	j	80001580 <copyout+0x98>
    80001572:	4501                	li	a0,0
}
    80001574:	8082                	ret
      return -1;
    80001576:	557d                	li	a0,-1
    80001578:	a021                	j	80001580 <copyout+0x98>
    8000157a:	557d                	li	a0,-1
    8000157c:	a011                	j	80001580 <copyout+0x98>
      return -1;
    8000157e:	557d                	li	a0,-1
}
    80001580:	60e6                	ld	ra,88(sp)
    80001582:	6446                	ld	s0,80(sp)
    80001584:	64a6                	ld	s1,72(sp)
    80001586:	6906                	ld	s2,64(sp)
    80001588:	79e2                	ld	s3,56(sp)
    8000158a:	7a42                	ld	s4,48(sp)
    8000158c:	7aa2                	ld	s5,40(sp)
    8000158e:	7b02                	ld	s6,32(sp)
    80001590:	6be2                	ld	s7,24(sp)
    80001592:	6c42                	ld	s8,16(sp)
    80001594:	6ca2                	ld	s9,8(sp)
    80001596:	6d02                	ld	s10,0(sp)
    80001598:	6125                	add	sp,sp,96
    8000159a:	8082                	ret
      return -1;
    8000159c:	557d                	li	a0,-1
    8000159e:	b7cd                	j	80001580 <copyout+0x98>

00000000800015a0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800015a0:	c6a5                	beqz	a3,80001608 <copyin+0x68>
{
    800015a2:	715d                	add	sp,sp,-80
    800015a4:	e486                	sd	ra,72(sp)
    800015a6:	e0a2                	sd	s0,64(sp)
    800015a8:	fc26                	sd	s1,56(sp)
    800015aa:	f84a                	sd	s2,48(sp)
    800015ac:	f44e                	sd	s3,40(sp)
    800015ae:	f052                	sd	s4,32(sp)
    800015b0:	ec56                	sd	s5,24(sp)
    800015b2:	e85a                	sd	s6,16(sp)
    800015b4:	e45e                	sd	s7,8(sp)
    800015b6:	e062                	sd	s8,0(sp)
    800015b8:	0880                	add	s0,sp,80
    800015ba:	8b2a                	mv	s6,a0
    800015bc:	8a2e                	mv	s4,a1
    800015be:	8c32                	mv	s8,a2
    800015c0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800015c2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800015c4:	6a85                	lui	s5,0x1
    800015c6:	a00d                	j	800015e8 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800015c8:	018505b3          	add	a1,a0,s8
    800015cc:	0004861b          	sext.w	a2,s1
    800015d0:	412585b3          	sub	a1,a1,s2
    800015d4:	8552                	mv	a0,s4
    800015d6:	efaff0ef          	jal	80000cd0 <memmove>

    len -= n;
    800015da:	409989b3          	sub	s3,s3,s1
    dst += n;
    800015de:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800015e0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800015e4:	02098063          	beqz	s3,80001604 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    800015e8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800015ec:	85ca                	mv	a1,s2
    800015ee:	855a                	mv	a0,s6
    800015f0:	999ff0ef          	jal	80000f88 <walkaddr>
    if(pa0 == 0)
    800015f4:	cd01                	beqz	a0,8000160c <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    800015f6:	418904b3          	sub	s1,s2,s8
    800015fa:	94d6                	add	s1,s1,s5
    800015fc:	fc99f6e3          	bgeu	s3,s1,800015c8 <copyin+0x28>
    80001600:	84ce                	mv	s1,s3
    80001602:	b7d9                	j	800015c8 <copyin+0x28>
  }
  return 0;
    80001604:	4501                	li	a0,0
    80001606:	a021                	j	8000160e <copyin+0x6e>
    80001608:	4501                	li	a0,0
}
    8000160a:	8082                	ret
      return -1;
    8000160c:	557d                	li	a0,-1
}
    8000160e:	60a6                	ld	ra,72(sp)
    80001610:	6406                	ld	s0,64(sp)
    80001612:	74e2                	ld	s1,56(sp)
    80001614:	7942                	ld	s2,48(sp)
    80001616:	79a2                	ld	s3,40(sp)
    80001618:	7a02                	ld	s4,32(sp)
    8000161a:	6ae2                	ld	s5,24(sp)
    8000161c:	6b42                	ld	s6,16(sp)
    8000161e:	6ba2                	ld	s7,8(sp)
    80001620:	6c02                	ld	s8,0(sp)
    80001622:	6161                	add	sp,sp,80
    80001624:	8082                	ret

0000000080001626 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001626:	c2cd                	beqz	a3,800016c8 <copyinstr+0xa2>
{
    80001628:	715d                	add	sp,sp,-80
    8000162a:	e486                	sd	ra,72(sp)
    8000162c:	e0a2                	sd	s0,64(sp)
    8000162e:	fc26                	sd	s1,56(sp)
    80001630:	f84a                	sd	s2,48(sp)
    80001632:	f44e                	sd	s3,40(sp)
    80001634:	f052                	sd	s4,32(sp)
    80001636:	ec56                	sd	s5,24(sp)
    80001638:	e85a                	sd	s6,16(sp)
    8000163a:	e45e                	sd	s7,8(sp)
    8000163c:	0880                	add	s0,sp,80
    8000163e:	8a2a                	mv	s4,a0
    80001640:	8b2e                	mv	s6,a1
    80001642:	8bb2                	mv	s7,a2
    80001644:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001646:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001648:	6985                	lui	s3,0x1
    8000164a:	a02d                	j	80001674 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000164c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001650:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001652:	37fd                	addw	a5,a5,-1
    80001654:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001658:	60a6                	ld	ra,72(sp)
    8000165a:	6406                	ld	s0,64(sp)
    8000165c:	74e2                	ld	s1,56(sp)
    8000165e:	7942                	ld	s2,48(sp)
    80001660:	79a2                	ld	s3,40(sp)
    80001662:	7a02                	ld	s4,32(sp)
    80001664:	6ae2                	ld	s5,24(sp)
    80001666:	6b42                	ld	s6,16(sp)
    80001668:	6ba2                	ld	s7,8(sp)
    8000166a:	6161                	add	sp,sp,80
    8000166c:	8082                	ret
    srcva = va0 + PGSIZE;
    8000166e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001672:	c4b9                	beqz	s1,800016c0 <copyinstr+0x9a>
    va0 = PGROUNDDOWN(srcva);
    80001674:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001678:	85ca                	mv	a1,s2
    8000167a:	8552                	mv	a0,s4
    8000167c:	90dff0ef          	jal	80000f88 <walkaddr>
    if(pa0 == 0)
    80001680:	c131                	beqz	a0,800016c4 <copyinstr+0x9e>
    n = PGSIZE - (srcva - va0);
    80001682:	417906b3          	sub	a3,s2,s7
    80001686:	96ce                	add	a3,a3,s3
    80001688:	00d4f363          	bgeu	s1,a3,8000168e <copyinstr+0x68>
    8000168c:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000168e:	955e                	add	a0,a0,s7
    80001690:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001694:	dee9                	beqz	a3,8000166e <copyinstr+0x48>
    80001696:	87da                	mv	a5,s6
    80001698:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000169a:	41650633          	sub	a2,a0,s6
    while(n > 0){
    8000169e:	96da                	add	a3,a3,s6
    800016a0:	85be                	mv	a1,a5
      if(*p == '\0'){
    800016a2:	00f60733          	add	a4,a2,a5
    800016a6:	00074703          	lbu	a4,0(a4)
    800016aa:	d34d                	beqz	a4,8000164c <copyinstr+0x26>
        *dst = *p;
    800016ac:	00e78023          	sb	a4,0(a5)
      dst++;
    800016b0:	0785                	add	a5,a5,1
    while(n > 0){
    800016b2:	fed797e3          	bne	a5,a3,800016a0 <copyinstr+0x7a>
    800016b6:	14fd                	add	s1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffcc45f>
    800016b8:	94c2                	add	s1,s1,a6
      --max;
    800016ba:	8c8d                	sub	s1,s1,a1
      dst++;
    800016bc:	8b3e                	mv	s6,a5
    800016be:	bf45                	j	8000166e <copyinstr+0x48>
    800016c0:	4781                	li	a5,0
    800016c2:	bf41                	j	80001652 <copyinstr+0x2c>
      return -1;
    800016c4:	557d                	li	a0,-1
    800016c6:	bf49                	j	80001658 <copyinstr+0x32>
  int got_null = 0;
    800016c8:	4781                	li	a5,0
  if(got_null){
    800016ca:	37fd                	addw	a5,a5,-1
    800016cc:	0007851b          	sext.w	a0,a5
}
    800016d0:	8082                	ret

00000000800016d2 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800016d2:	7139                	add	sp,sp,-64
    800016d4:	fc06                	sd	ra,56(sp)
    800016d6:	f822                	sd	s0,48(sp)
    800016d8:	f426                	sd	s1,40(sp)
    800016da:	f04a                	sd	s2,32(sp)
    800016dc:	ec4e                	sd	s3,24(sp)
    800016de:	e852                	sd	s4,16(sp)
    800016e0:	e456                	sd	s5,8(sp)
    800016e2:	e05a                	sd	s6,0(sp)
    800016e4:	0080                	add	s0,sp,64
    800016e6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800016e8:	0000f497          	auipc	s1,0xf
    800016ec:	8d848493          	add	s1,s1,-1832 # 8000ffc0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800016f0:	8b26                	mv	s6,s1
    800016f2:	00006a97          	auipc	s5,0x6
    800016f6:	90ea8a93          	add	s5,s5,-1778 # 80007000 <etext>
    800016fa:	04000937          	lui	s2,0x4000
    800016fe:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001700:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001702:	00026a17          	auipc	s4,0x26
    80001706:	0bea0a13          	add	s4,s4,190 # 800277c0 <tickslock>
    char *pa = kalloc();
    8000170a:	bc6ff0ef          	jal	80000ad0 <kalloc>
    8000170e:	862a                	mv	a2,a0
    if(pa == 0)
    80001710:	c121                	beqz	a0,80001750 <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    80001712:	416485b3          	sub	a1,s1,s6
    80001716:	858d                	sra	a1,a1,0x3
    80001718:	000ab783          	ld	a5,0(s5)
    8000171c:	02f585b3          	mul	a1,a1,a5
    80001720:	2585                	addw	a1,a1,1
    80001722:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001726:	4719                	li	a4,6
    80001728:	6685                	lui	a3,0x1
    8000172a:	40b905b3          	sub	a1,s2,a1
    8000172e:	854e                	mv	a0,s3
    80001730:	947ff0ef          	jal	80001076 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001734:	17848493          	add	s1,s1,376
    80001738:	fd4499e3          	bne	s1,s4,8000170a <proc_mapstacks+0x38>
  }
}
    8000173c:	70e2                	ld	ra,56(sp)
    8000173e:	7442                	ld	s0,48(sp)
    80001740:	74a2                	ld	s1,40(sp)
    80001742:	7902                	ld	s2,32(sp)
    80001744:	69e2                	ld	s3,24(sp)
    80001746:	6a42                	ld	s4,16(sp)
    80001748:	6aa2                	ld	s5,8(sp)
    8000174a:	6b02                	ld	s6,0(sp)
    8000174c:	6121                	add	sp,sp,64
    8000174e:	8082                	ret
      panic("kalloc");
    80001750:	00006517          	auipc	a0,0x6
    80001754:	ac050513          	add	a0,a0,-1344 # 80007210 <digits+0x1d8>
    80001758:	806ff0ef          	jal	8000075e <panic>

000000008000175c <procinit>:

// initialize the proc table.
void
procinit(void)
{
    8000175c:	7139                	add	sp,sp,-64
    8000175e:	fc06                	sd	ra,56(sp)
    80001760:	f822                	sd	s0,48(sp)
    80001762:	f426                	sd	s1,40(sp)
    80001764:	f04a                	sd	s2,32(sp)
    80001766:	ec4e                	sd	s3,24(sp)
    80001768:	e852                	sd	s4,16(sp)
    8000176a:	e456                	sd	s5,8(sp)
    8000176c:	e05a                	sd	s6,0(sp)
    8000176e:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001770:	00006597          	auipc	a1,0x6
    80001774:	aa858593          	add	a1,a1,-1368 # 80007218 <digits+0x1e0>
    80001778:	0000e517          	auipc	a0,0xe
    8000177c:	32850513          	add	a0,a0,808 # 8000faa0 <pid_lock>
    80001780:	ba0ff0ef          	jal	80000b20 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001784:	00006597          	auipc	a1,0x6
    80001788:	a9c58593          	add	a1,a1,-1380 # 80007220 <digits+0x1e8>
    8000178c:	0000e517          	auipc	a0,0xe
    80001790:	32c50513          	add	a0,a0,812 # 8000fab8 <wait_lock>
    80001794:	b8cff0ef          	jal	80000b20 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001798:	0000f497          	auipc	s1,0xf
    8000179c:	82848493          	add	s1,s1,-2008 # 8000ffc0 <proc>
      initlock(&p->lock, "proc");
    800017a0:	00006b17          	auipc	s6,0x6
    800017a4:	a90b0b13          	add	s6,s6,-1392 # 80007230 <digits+0x1f8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    800017a8:	8aa6                	mv	s5,s1
    800017aa:	00006a17          	auipc	s4,0x6
    800017ae:	856a0a13          	add	s4,s4,-1962 # 80007000 <etext>
    800017b2:	04000937          	lui	s2,0x4000
    800017b6:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    800017b8:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ba:	00026997          	auipc	s3,0x26
    800017be:	00698993          	add	s3,s3,6 # 800277c0 <tickslock>
      initlock(&p->lock, "proc");
    800017c2:	85da                	mv	a1,s6
    800017c4:	8526                	mv	a0,s1
    800017c6:	b5aff0ef          	jal	80000b20 <initlock>
      p->state = UNUSED;
    800017ca:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800017ce:	415487b3          	sub	a5,s1,s5
    800017d2:	878d                	sra	a5,a5,0x3
    800017d4:	000a3703          	ld	a4,0(s4)
    800017d8:	02e787b3          	mul	a5,a5,a4
    800017dc:	2785                	addw	a5,a5,1
    800017de:	00d7979b          	sllw	a5,a5,0xd
    800017e2:	40f907b3          	sub	a5,s2,a5
    800017e6:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e8:	17848493          	add	s1,s1,376
    800017ec:	fd349be3          	bne	s1,s3,800017c2 <procinit+0x66>
  }
}
    800017f0:	70e2                	ld	ra,56(sp)
    800017f2:	7442                	ld	s0,48(sp)
    800017f4:	74a2                	ld	s1,40(sp)
    800017f6:	7902                	ld	s2,32(sp)
    800017f8:	69e2                	ld	s3,24(sp)
    800017fa:	6a42                	ld	s4,16(sp)
    800017fc:	6aa2                	ld	s5,8(sp)
    800017fe:	6b02                	ld	s6,0(sp)
    80001800:	6121                	add	sp,sp,64
    80001802:	8082                	ret

0000000080001804 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001804:	1141                	add	sp,sp,-16
    80001806:	e422                	sd	s0,8(sp)
    80001808:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000180a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000180c:	2501                	sext.w	a0,a0
    8000180e:	6422                	ld	s0,8(sp)
    80001810:	0141                	add	sp,sp,16
    80001812:	8082                	ret

0000000080001814 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001814:	1141                	add	sp,sp,-16
    80001816:	e422                	sd	s0,8(sp)
    80001818:	0800                	add	s0,sp,16
    8000181a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000181c:	2781                	sext.w	a5,a5
    8000181e:	079e                	sll	a5,a5,0x7
  return c;
}
    80001820:	0000e517          	auipc	a0,0xe
    80001824:	2b050513          	add	a0,a0,688 # 8000fad0 <cpus>
    80001828:	953e                	add	a0,a0,a5
    8000182a:	6422                	ld	s0,8(sp)
    8000182c:	0141                	add	sp,sp,16
    8000182e:	8082                	ret

0000000080001830 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001830:	1101                	add	sp,sp,-32
    80001832:	ec06                	sd	ra,24(sp)
    80001834:	e822                	sd	s0,16(sp)
    80001836:	e426                	sd	s1,8(sp)
    80001838:	1000                	add	s0,sp,32
  push_off();
    8000183a:	b26ff0ef          	jal	80000b60 <push_off>
    8000183e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001840:	2781                	sext.w	a5,a5
    80001842:	079e                	sll	a5,a5,0x7
    80001844:	0000e717          	auipc	a4,0xe
    80001848:	25c70713          	add	a4,a4,604 # 8000faa0 <pid_lock>
    8000184c:	97ba                	add	a5,a5,a4
    8000184e:	7b84                	ld	s1,48(a5)
  pop_off();
    80001850:	b94ff0ef          	jal	80000be4 <pop_off>
  return p;
}
    80001854:	8526                	mv	a0,s1
    80001856:	60e2                	ld	ra,24(sp)
    80001858:	6442                	ld	s0,16(sp)
    8000185a:	64a2                	ld	s1,8(sp)
    8000185c:	6105                	add	sp,sp,32
    8000185e:	8082                	ret

0000000080001860 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001860:	1141                	add	sp,sp,-16
    80001862:	e406                	sd	ra,8(sp)
    80001864:	e022                	sd	s0,0(sp)
    80001866:	0800                	add	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001868:	fc9ff0ef          	jal	80001830 <myproc>
    8000186c:	bccff0ef          	jal	80000c38 <release>

  if (first) {
    80001870:	00006797          	auipc	a5,0x6
    80001874:	0607a783          	lw	a5,96(a5) # 800078d0 <first.1>
    80001878:	e799                	bnez	a5,80001886 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    8000187a:	5b1000ef          	jal	8000262a <usertrapret>
}
    8000187e:	60a2                	ld	ra,8(sp)
    80001880:	6402                	ld	s0,0(sp)
    80001882:	0141                	add	sp,sp,16
    80001884:	8082                	ret
    fsinit(ROOTDEV);
    80001886:	4505                	li	a0,1
    80001888:	127010ef          	jal	800031ae <fsinit>
    first = 0;
    8000188c:	00006797          	auipc	a5,0x6
    80001890:	0407a223          	sw	zero,68(a5) # 800078d0 <first.1>
    __sync_synchronize();
    80001894:	0ff0000f          	fence
    80001898:	b7cd                	j	8000187a <forkret+0x1a>

000000008000189a <allocpid>:
{
    8000189a:	1101                	add	sp,sp,-32
    8000189c:	ec06                	sd	ra,24(sp)
    8000189e:	e822                	sd	s0,16(sp)
    800018a0:	e426                	sd	s1,8(sp)
    800018a2:	e04a                	sd	s2,0(sp)
    800018a4:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    800018a6:	0000e917          	auipc	s2,0xe
    800018aa:	1fa90913          	add	s2,s2,506 # 8000faa0 <pid_lock>
    800018ae:	854a                	mv	a0,s2
    800018b0:	af0ff0ef          	jal	80000ba0 <acquire>
  pid = nextpid;
    800018b4:	00006797          	auipc	a5,0x6
    800018b8:	02078793          	add	a5,a5,32 # 800078d4 <nextpid>
    800018bc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018be:	0014871b          	addw	a4,s1,1
    800018c2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018c4:	854a                	mv	a0,s2
    800018c6:	b72ff0ef          	jal	80000c38 <release>
}
    800018ca:	8526                	mv	a0,s1
    800018cc:	60e2                	ld	ra,24(sp)
    800018ce:	6442                	ld	s0,16(sp)
    800018d0:	64a2                	ld	s1,8(sp)
    800018d2:	6902                	ld	s2,0(sp)
    800018d4:	6105                	add	sp,sp,32
    800018d6:	8082                	ret

00000000800018d8 <proc_pagetable>:
{
    800018d8:	1101                	add	sp,sp,-32
    800018da:	ec06                	sd	ra,24(sp)
    800018dc:	e822                	sd	s0,16(sp)
    800018de:	e426                	sd	s1,8(sp)
    800018e0:	e04a                	sd	s2,0(sp)
    800018e2:	1000                	add	s0,sp,32
    800018e4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800018e6:	933ff0ef          	jal	80001218 <uvmcreate>
    800018ea:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800018ec:	cd05                	beqz	a0,80001924 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800018ee:	4729                	li	a4,10
    800018f0:	00004697          	auipc	a3,0x4
    800018f4:	71068693          	add	a3,a3,1808 # 80006000 <_trampoline>
    800018f8:	6605                	lui	a2,0x1
    800018fa:	040005b7          	lui	a1,0x4000
    800018fe:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001900:	05b2                	sll	a1,a1,0xc
    80001902:	ec4ff0ef          	jal	80000fc6 <mappages>
    80001906:	02054663          	bltz	a0,80001932 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000190a:	4719                	li	a4,6
    8000190c:	05893683          	ld	a3,88(s2)
    80001910:	6605                	lui	a2,0x1
    80001912:	020005b7          	lui	a1,0x2000
    80001916:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001918:	05b6                	sll	a1,a1,0xd
    8000191a:	8526                	mv	a0,s1
    8000191c:	eaaff0ef          	jal	80000fc6 <mappages>
    80001920:	00054f63          	bltz	a0,8000193e <proc_pagetable+0x66>
}
    80001924:	8526                	mv	a0,s1
    80001926:	60e2                	ld	ra,24(sp)
    80001928:	6442                	ld	s0,16(sp)
    8000192a:	64a2                	ld	s1,8(sp)
    8000192c:	6902                	ld	s2,0(sp)
    8000192e:	6105                	add	sp,sp,32
    80001930:	8082                	ret
    uvmfree(pagetable, 0);
    80001932:	4581                	li	a1,0
    80001934:	8526                	mv	a0,s1
    80001936:	aa5ff0ef          	jal	800013da <uvmfree>
    return 0;
    8000193a:	4481                	li	s1,0
    8000193c:	b7e5                	j	80001924 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000193e:	4681                	li	a3,0
    80001940:	4605                	li	a2,1
    80001942:	040005b7          	lui	a1,0x4000
    80001946:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001948:	05b2                	sll	a1,a1,0xc
    8000194a:	8526                	mv	a0,s1
    8000194c:	821ff0ef          	jal	8000116c <uvmunmap>
    uvmfree(pagetable, 0);
    80001950:	4581                	li	a1,0
    80001952:	8526                	mv	a0,s1
    80001954:	a87ff0ef          	jal	800013da <uvmfree>
    return 0;
    80001958:	4481                	li	s1,0
    8000195a:	b7e9                	j	80001924 <proc_pagetable+0x4c>

000000008000195c <proc_freepagetable>:
{
    8000195c:	1101                	add	sp,sp,-32
    8000195e:	ec06                	sd	ra,24(sp)
    80001960:	e822                	sd	s0,16(sp)
    80001962:	e426                	sd	s1,8(sp)
    80001964:	e04a                	sd	s2,0(sp)
    80001966:	1000                	add	s0,sp,32
    80001968:	84aa                	mv	s1,a0
    8000196a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000196c:	4681                	li	a3,0
    8000196e:	4605                	li	a2,1
    80001970:	040005b7          	lui	a1,0x4000
    80001974:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001976:	05b2                	sll	a1,a1,0xc
    80001978:	ff4ff0ef          	jal	8000116c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000197c:	4681                	li	a3,0
    8000197e:	4605                	li	a2,1
    80001980:	020005b7          	lui	a1,0x2000
    80001984:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001986:	05b6                	sll	a1,a1,0xd
    80001988:	8526                	mv	a0,s1
    8000198a:	fe2ff0ef          	jal	8000116c <uvmunmap>
  uvmfree(pagetable, sz);
    8000198e:	85ca                	mv	a1,s2
    80001990:	8526                	mv	a0,s1
    80001992:	a49ff0ef          	jal	800013da <uvmfree>
}
    80001996:	60e2                	ld	ra,24(sp)
    80001998:	6442                	ld	s0,16(sp)
    8000199a:	64a2                	ld	s1,8(sp)
    8000199c:	6902                	ld	s2,0(sp)
    8000199e:	6105                	add	sp,sp,32
    800019a0:	8082                	ret

00000000800019a2 <freeproc>:
{
    800019a2:	1101                	add	sp,sp,-32
    800019a4:	ec06                	sd	ra,24(sp)
    800019a6:	e822                	sd	s0,16(sp)
    800019a8:	e426                	sd	s1,8(sp)
    800019aa:	1000                	add	s0,sp,32
    800019ac:	84aa                	mv	s1,a0
  if(p->trapframe)
    800019ae:	6d28                	ld	a0,88(a0)
    800019b0:	c119                	beqz	a0,800019b6 <freeproc+0x14>
    kfree((void*)p->trapframe);
    800019b2:	83cff0ef          	jal	800009ee <kfree>
  p->trapframe = 0;
    800019b6:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800019ba:	68a8                	ld	a0,80(s1)
    800019bc:	c501                	beqz	a0,800019c4 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800019be:	64ac                	ld	a1,72(s1)
    800019c0:	f9dff0ef          	jal	8000195c <proc_freepagetable>
  p->pagetable = 0;
    800019c4:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800019c8:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800019cc:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800019d0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800019d4:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800019d8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800019dc:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800019e0:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800019e4:	0004ac23          	sw	zero,24(s1)
}
    800019e8:	60e2                	ld	ra,24(sp)
    800019ea:	6442                	ld	s0,16(sp)
    800019ec:	64a2                	ld	s1,8(sp)
    800019ee:	6105                	add	sp,sp,32
    800019f0:	8082                	ret

00000000800019f2 <allocproc>:
{
    800019f2:	1101                	add	sp,sp,-32
    800019f4:	ec06                	sd	ra,24(sp)
    800019f6:	e822                	sd	s0,16(sp)
    800019f8:	e426                	sd	s1,8(sp)
    800019fa:	e04a                	sd	s2,0(sp)
    800019fc:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800019fe:	0000e497          	auipc	s1,0xe
    80001a02:	5c248493          	add	s1,s1,1474 # 8000ffc0 <proc>
    80001a06:	00026917          	auipc	s2,0x26
    80001a0a:	dba90913          	add	s2,s2,-582 # 800277c0 <tickslock>
    acquire(&p->lock);
    80001a0e:	8526                	mv	a0,s1
    80001a10:	990ff0ef          	jal	80000ba0 <acquire>
    if(p->state == UNUSED) {
    80001a14:	4c9c                	lw	a5,24(s1)
    80001a16:	cb91                	beqz	a5,80001a2a <allocproc+0x38>
      release(&p->lock);
    80001a18:	8526                	mv	a0,s1
    80001a1a:	a1eff0ef          	jal	80000c38 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a1e:	17848493          	add	s1,s1,376
    80001a22:	ff2496e3          	bne	s1,s2,80001a0e <allocproc+0x1c>
  return 0;
    80001a26:	4481                	li	s1,0
    80001a28:	a889                	j	80001a7a <allocproc+0x88>
  p->pid = allocpid();
    80001a2a:	e71ff0ef          	jal	8000189a <allocpid>
    80001a2e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001a30:	4785                	li	a5,1
    80001a32:	cc9c                	sw	a5,24(s1)
  p->tempo_total = 0;
    80001a34:	1604a423          	sw	zero,360(s1)
  p->overhead = 0;
    80001a38:	1604a623          	sw	zero,364(s1)
  p->eficiencia = 0;
    80001a3c:	1604a823          	sw	zero,368(s1)
  p->type = DEFAULT;
    80001a40:	16f4aa23          	sw	a5,372(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001a44:	88cff0ef          	jal	80000ad0 <kalloc>
    80001a48:	892a                	mv	s2,a0
    80001a4a:	eca8                	sd	a0,88(s1)
    80001a4c:	cd15                	beqz	a0,80001a88 <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    80001a4e:	8526                	mv	a0,s1
    80001a50:	e89ff0ef          	jal	800018d8 <proc_pagetable>
    80001a54:	892a                	mv	s2,a0
    80001a56:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001a58:	c121                	beqz	a0,80001a98 <allocproc+0xa6>
  memset(&p->context, 0, sizeof(p->context));
    80001a5a:	07000613          	li	a2,112
    80001a5e:	4581                	li	a1,0
    80001a60:	06048513          	add	a0,s1,96
    80001a64:	a10ff0ef          	jal	80000c74 <memset>
  p->context.ra = (uint64)forkret;
    80001a68:	00000797          	auipc	a5,0x0
    80001a6c:	df878793          	add	a5,a5,-520 # 80001860 <forkret>
    80001a70:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001a72:	60bc                	ld	a5,64(s1)
    80001a74:	6705                	lui	a4,0x1
    80001a76:	97ba                	add	a5,a5,a4
    80001a78:	f4bc                	sd	a5,104(s1)
}
    80001a7a:	8526                	mv	a0,s1
    80001a7c:	60e2                	ld	ra,24(sp)
    80001a7e:	6442                	ld	s0,16(sp)
    80001a80:	64a2                	ld	s1,8(sp)
    80001a82:	6902                	ld	s2,0(sp)
    80001a84:	6105                	add	sp,sp,32
    80001a86:	8082                	ret
    freeproc(p);
    80001a88:	8526                	mv	a0,s1
    80001a8a:	f19ff0ef          	jal	800019a2 <freeproc>
    release(&p->lock);
    80001a8e:	8526                	mv	a0,s1
    80001a90:	9a8ff0ef          	jal	80000c38 <release>
    return 0;
    80001a94:	84ca                	mv	s1,s2
    80001a96:	b7d5                	j	80001a7a <allocproc+0x88>
    freeproc(p);
    80001a98:	8526                	mv	a0,s1
    80001a9a:	f09ff0ef          	jal	800019a2 <freeproc>
    release(&p->lock);
    80001a9e:	8526                	mv	a0,s1
    80001aa0:	998ff0ef          	jal	80000c38 <release>
    return 0;
    80001aa4:	84ca                	mv	s1,s2
    80001aa6:	bfd1                	j	80001a7a <allocproc+0x88>

0000000080001aa8 <userinit>:
{
    80001aa8:	1101                	add	sp,sp,-32
    80001aaa:	ec06                	sd	ra,24(sp)
    80001aac:	e822                	sd	s0,16(sp)
    80001aae:	e426                	sd	s1,8(sp)
    80001ab0:	1000                	add	s0,sp,32
  p = allocproc();
    80001ab2:	f41ff0ef          	jal	800019f2 <allocproc>
    80001ab6:	84aa                	mv	s1,a0
  initproc = p;
    80001ab8:	00006797          	auipc	a5,0x6
    80001abc:	eaa7b823          	sd	a0,-336(a5) # 80007968 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001ac0:	03400613          	li	a2,52
    80001ac4:	00006597          	auipc	a1,0x6
    80001ac8:	e1c58593          	add	a1,a1,-484 # 800078e0 <initcode>
    80001acc:	6928                	ld	a0,80(a0)
    80001ace:	f70ff0ef          	jal	8000123e <uvmfirst>
  p->sz = PGSIZE;
    80001ad2:	6785                	lui	a5,0x1
    80001ad4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ad6:	6cb8                	ld	a4,88(s1)
    80001ad8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001adc:	6cb8                	ld	a4,88(s1)
    80001ade:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ae0:	4641                	li	a2,16
    80001ae2:	00005597          	auipc	a1,0x5
    80001ae6:	75658593          	add	a1,a1,1878 # 80007238 <digits+0x200>
    80001aea:	15848513          	add	a0,s1,344
    80001aee:	acaff0ef          	jal	80000db8 <safestrcpy>
  p->cwd = namei("/");
    80001af2:	00005517          	auipc	a0,0x5
    80001af6:	75650513          	add	a0,a0,1878 # 80007248 <digits+0x210>
    80001afa:	78f010ef          	jal	80003a88 <namei>
    80001afe:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001b02:	478d                	li	a5,3
    80001b04:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001b06:	8526                	mv	a0,s1
    80001b08:	930ff0ef          	jal	80000c38 <release>
}
    80001b0c:	60e2                	ld	ra,24(sp)
    80001b0e:	6442                	ld	s0,16(sp)
    80001b10:	64a2                	ld	s1,8(sp)
    80001b12:	6105                	add	sp,sp,32
    80001b14:	8082                	ret

0000000080001b16 <growproc>:
{
    80001b16:	1101                	add	sp,sp,-32
    80001b18:	ec06                	sd	ra,24(sp)
    80001b1a:	e822                	sd	s0,16(sp)
    80001b1c:	e426                	sd	s1,8(sp)
    80001b1e:	e04a                	sd	s2,0(sp)
    80001b20:	1000                	add	s0,sp,32
    80001b22:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001b24:	d0dff0ef          	jal	80001830 <myproc>
    80001b28:	84aa                	mv	s1,a0
  sz = p->sz;
    80001b2a:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001b2c:	01204c63          	bgtz	s2,80001b44 <growproc+0x2e>
  } else if(n < 0){
    80001b30:	02094463          	bltz	s2,80001b58 <growproc+0x42>
  p->sz = sz;
    80001b34:	e4ac                	sd	a1,72(s1)
  return 0;
    80001b36:	4501                	li	a0,0
}
    80001b38:	60e2                	ld	ra,24(sp)
    80001b3a:	6442                	ld	s0,16(sp)
    80001b3c:	64a2                	ld	s1,8(sp)
    80001b3e:	6902                	ld	s2,0(sp)
    80001b40:	6105                	add	sp,sp,32
    80001b42:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001b44:	4691                	li	a3,4
    80001b46:	00b90633          	add	a2,s2,a1
    80001b4a:	6928                	ld	a0,80(a0)
    80001b4c:	f94ff0ef          	jal	800012e0 <uvmalloc>
    80001b50:	85aa                	mv	a1,a0
    80001b52:	f16d                	bnez	a0,80001b34 <growproc+0x1e>
      return -1;
    80001b54:	557d                	li	a0,-1
    80001b56:	b7cd                	j	80001b38 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001b58:	00b90633          	add	a2,s2,a1
    80001b5c:	6928                	ld	a0,80(a0)
    80001b5e:	f3eff0ef          	jal	8000129c <uvmdealloc>
    80001b62:	85aa                	mv	a1,a0
    80001b64:	bfc1                	j	80001b34 <growproc+0x1e>

0000000080001b66 <fork>:
{
    80001b66:	7139                	add	sp,sp,-64
    80001b68:	fc06                	sd	ra,56(sp)
    80001b6a:	f822                	sd	s0,48(sp)
    80001b6c:	f426                	sd	s1,40(sp)
    80001b6e:	f04a                	sd	s2,32(sp)
    80001b70:	ec4e                	sd	s3,24(sp)
    80001b72:	e852                	sd	s4,16(sp)
    80001b74:	e456                	sd	s5,8(sp)
    80001b76:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001b78:	cb9ff0ef          	jal	80001830 <myproc>
    80001b7c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001b7e:	e75ff0ef          	jal	800019f2 <allocproc>
    80001b82:	0e050663          	beqz	a0,80001c6e <fork+0x108>
    80001b86:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001b88:	048ab603          	ld	a2,72(s5)
    80001b8c:	692c                	ld	a1,80(a0)
    80001b8e:	050ab503          	ld	a0,80(s5)
    80001b92:	87bff0ef          	jal	8000140c <uvmcopy>
    80001b96:	04054863          	bltz	a0,80001be6 <fork+0x80>
  np->sz = p->sz;
    80001b9a:	048ab783          	ld	a5,72(s5)
    80001b9e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001ba2:	058ab683          	ld	a3,88(s5)
    80001ba6:	87b6                	mv	a5,a3
    80001ba8:	058a3703          	ld	a4,88(s4)
    80001bac:	12068693          	add	a3,a3,288
    80001bb0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001bb4:	6788                	ld	a0,8(a5)
    80001bb6:	6b8c                	ld	a1,16(a5)
    80001bb8:	6f90                	ld	a2,24(a5)
    80001bba:	01073023          	sd	a6,0(a4)
    80001bbe:	e708                	sd	a0,8(a4)
    80001bc0:	eb0c                	sd	a1,16(a4)
    80001bc2:	ef10                	sd	a2,24(a4)
    80001bc4:	02078793          	add	a5,a5,32
    80001bc8:	02070713          	add	a4,a4,32
    80001bcc:	fed792e3          	bne	a5,a3,80001bb0 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001bd0:	058a3783          	ld	a5,88(s4)
    80001bd4:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001bd8:	0d0a8493          	add	s1,s5,208
    80001bdc:	0d0a0913          	add	s2,s4,208
    80001be0:	150a8993          	add	s3,s5,336
    80001be4:	a829                	j	80001bfe <fork+0x98>
    freeproc(np);
    80001be6:	8552                	mv	a0,s4
    80001be8:	dbbff0ef          	jal	800019a2 <freeproc>
    release(&np->lock);
    80001bec:	8552                	mv	a0,s4
    80001bee:	84aff0ef          	jal	80000c38 <release>
    return -1;
    80001bf2:	597d                	li	s2,-1
    80001bf4:	a09d                	j	80001c5a <fork+0xf4>
  for(i = 0; i < NOFILE; i++)
    80001bf6:	04a1                	add	s1,s1,8
    80001bf8:	0921                	add	s2,s2,8
    80001bfa:	01348963          	beq	s1,s3,80001c0c <fork+0xa6>
    if(p->ofile[i])
    80001bfe:	6088                	ld	a0,0(s1)
    80001c00:	d97d                	beqz	a0,80001bf6 <fork+0x90>
      np->ofile[i] = filedup(p->ofile[i]);
    80001c02:	410020ef          	jal	80004012 <filedup>
    80001c06:	00a93023          	sd	a0,0(s2)
    80001c0a:	b7f5                	j	80001bf6 <fork+0x90>
  np->cwd = idup(p->cwd);
    80001c0c:	150ab503          	ld	a0,336(s5)
    80001c10:	790010ef          	jal	800033a0 <idup>
    80001c14:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c18:	4641                	li	a2,16
    80001c1a:	158a8593          	add	a1,s5,344
    80001c1e:	158a0513          	add	a0,s4,344
    80001c22:	996ff0ef          	jal	80000db8 <safestrcpy>
  pid = np->pid;
    80001c26:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001c2a:	8552                	mv	a0,s4
    80001c2c:	80cff0ef          	jal	80000c38 <release>
  acquire(&wait_lock);
    80001c30:	0000e497          	auipc	s1,0xe
    80001c34:	e8848493          	add	s1,s1,-376 # 8000fab8 <wait_lock>
    80001c38:	8526                	mv	a0,s1
    80001c3a:	f67fe0ef          	jal	80000ba0 <acquire>
  np->parent = p;
    80001c3e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001c42:	8526                	mv	a0,s1
    80001c44:	ff5fe0ef          	jal	80000c38 <release>
  acquire(&np->lock);
    80001c48:	8552                	mv	a0,s4
    80001c4a:	f57fe0ef          	jal	80000ba0 <acquire>
  np->state = RUNNABLE;
    80001c4e:	478d                	li	a5,3
    80001c50:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001c54:	8552                	mv	a0,s4
    80001c56:	fe3fe0ef          	jal	80000c38 <release>
}
    80001c5a:	854a                	mv	a0,s2
    80001c5c:	70e2                	ld	ra,56(sp)
    80001c5e:	7442                	ld	s0,48(sp)
    80001c60:	74a2                	ld	s1,40(sp)
    80001c62:	7902                	ld	s2,32(sp)
    80001c64:	69e2                	ld	s3,24(sp)
    80001c66:	6a42                	ld	s4,16(sp)
    80001c68:	6aa2                	ld	s5,8(sp)
    80001c6a:	6121                	add	sp,sp,64
    80001c6c:	8082                	ret
    return -1;
    80001c6e:	597d                	li	s2,-1
    80001c70:	b7ed                	j	80001c5a <fork+0xf4>

0000000080001c72 <sys_uptime_nolock>:
{
    80001c72:	1141                	add	sp,sp,-16
    80001c74:	e422                	sd	s0,8(sp)
    80001c76:	0800                	add	s0,sp,16
}
    80001c78:	00006517          	auipc	a0,0x6
    80001c7c:	cf856503          	lwu	a0,-776(a0) # 80007970 <ticks>
    80001c80:	6422                	ld	s0,8(sp)
    80001c82:	0141                	add	sp,sp,16
    80001c84:	8082                	ret

0000000080001c86 <scheduler>:
{
    80001c86:	7159                	add	sp,sp,-112
    80001c88:	f486                	sd	ra,104(sp)
    80001c8a:	f0a2                	sd	s0,96(sp)
    80001c8c:	eca6                	sd	s1,88(sp)
    80001c8e:	e8ca                	sd	s2,80(sp)
    80001c90:	e4ce                	sd	s3,72(sp)
    80001c92:	e0d2                	sd	s4,64(sp)
    80001c94:	fc56                	sd	s5,56(sp)
    80001c96:	f85a                	sd	s6,48(sp)
    80001c98:	f45e                	sd	s7,40(sp)
    80001c9a:	f062                	sd	s8,32(sp)
    80001c9c:	ec66                	sd	s9,24(sp)
    80001c9e:	e86a                	sd	s10,16(sp)
    80001ca0:	e46e                	sd	s11,8(sp)
    80001ca2:	1880                	add	s0,sp,112
    80001ca4:	8792                	mv	a5,tp
  int id = r_tp();
    80001ca6:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ca8:	00779d13          	sll	s10,a5,0x7
    80001cac:	0000e717          	auipc	a4,0xe
    80001cb0:	df470713          	add	a4,a4,-524 # 8000faa0 <pid_lock>
    80001cb4:	976a                	add	a4,a4,s10
    80001cb6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &run_proc->context);
    80001cba:	0000e717          	auipc	a4,0xe
    80001cbe:	e1e70713          	add	a4,a4,-482 # 8000fad8 <cpus+0x8>
    80001cc2:	9d3a                	add	s10,s10,a4
        if (p->type == CPU_BOUND && !cpu_proc){
    80001cc4:	4a89                	li	s5,2
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cc6:	00026997          	auipc	s3,0x26
    80001cca:	afa98993          	add	s3,s3,-1286 # 800277c0 <tickslock>
  xticks = ticks;
    80001cce:	00006c17          	auipc	s8,0x6
    80001cd2:	ca2c0c13          	add	s8,s8,-862 # 80007970 <ticks>
        c->proc = run_proc;
    80001cd6:	079e                	sll	a5,a5,0x7
    80001cd8:	0000eb97          	auipc	s7,0xe
    80001cdc:	dc8b8b93          	add	s7,s7,-568 # 8000faa0 <pid_lock>
    80001ce0:	9bbe                	add	s7,s7,a5
    80001ce2:	a871                	j	80001d7e <scheduler+0xf8>
        if (p->type == CPU_BOUND && !cpu_proc){
    80001ce4:	020b0b63          	beqz	s6,80001d1a <scheduler+0x94>
      release(&p->lock);
    80001ce8:	8526                	mv	a0,s1
    80001cea:	f4ffe0ef          	jal	80000c38 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cee:	17848493          	add	s1,s1,376
    80001cf2:	03348a63          	beq	s1,s3,80001d26 <scheduler+0xa0>
      acquire(&p->lock);
    80001cf6:	8526                	mv	a0,s1
    80001cf8:	ea9fe0ef          	jal	80000ba0 <acquire>
      if(p->state == RUNNABLE) {
    80001cfc:	4c9c                	lw	a5,24(s1)
    80001cfe:	ff2795e3          	bne	a5,s2,80001ce8 <scheduler+0x62>
        if (p->type == CPU_BOUND && !cpu_proc){
    80001d02:	1744a783          	lw	a5,372(s1)
    80001d06:	fd578fe3          	beq	a5,s5,80001ce4 <scheduler+0x5e>
        } else if (p-> type == IO_BOUND && !io_proc) {
    80001d0a:	01278a63          	beq	a5,s2,80001d1e <scheduler+0x98>
        } else if (p->type == DEFAULT && !default_proc){
    80001d0e:	fdb79de3          	bne	a5,s11,80001ce8 <scheduler+0x62>
    80001d12:	fc0c9be3          	bnez	s9,80001ce8 <scheduler+0x62>
    80001d16:	8ca6                	mv	s9,s1
    80001d18:	bfc1                	j	80001ce8 <scheduler+0x62>
        if (p->type == CPU_BOUND && !cpu_proc){
    80001d1a:	8b26                	mv	s6,s1
    80001d1c:	b7f1                	j	80001ce8 <scheduler+0x62>
        } else if (p-> type == IO_BOUND && !io_proc) {
    80001d1e:	fc0a15e3          	bnez	s4,80001ce8 <scheduler+0x62>
    80001d22:	8a26                	mv	s4,s1
    80001d24:	b7d1                	j	80001ce8 <scheduler+0x62>
    if (cpu_proc || io_proc){
    80001d26:	060b0c63          	beqz	s6,80001d9e <scheduler+0x118>
      run_proc = io_proc ? io_proc : cpu_proc; //prioritizes IO
    80001d2a:	080a0763          	beqz	s4,80001db8 <scheduler+0x132>
      acquire(&run_proc->lock);
    80001d2e:	8dd2                	mv	s11,s4
    80001d30:	8552                	mv	a0,s4
    80001d32:	e6ffe0ef          	jal	80000ba0 <acquire>
      while (run_proc->state == RUNNABLE){
    80001d36:	018a2703          	lw	a4,24(s4)
    80001d3a:	478d                	li	a5,3
    80001d3c:	02f71e63          	bne	a4,a5,80001d78 <scheduler+0xf2>
        run_proc->state = RUNNING;
    80001d40:	4c91                	li	s9,4
        swtch(&c->context, &run_proc->context);
    80001d42:	060a0b13          	add	s6,s4,96
      while (run_proc->state == RUNNABLE){
    80001d46:	490d                	li	s2,3
  xticks = ticks;
    80001d48:	000c2483          	lw	s1,0(s8)
        run_proc->state = RUNNING;
    80001d4c:	019a2c23          	sw	s9,24(s4)
        c->proc = run_proc;
    80001d50:	034bb823          	sd	s4,48(s7)
        swtch(&c->context, &run_proc->context);
    80001d54:	85da                	mv	a1,s6
    80001d56:	856a                	mv	a0,s10
    80001d58:	02d000ef          	jal	80002584 <swtch>
        run_proc->tempo_total += tempo_final - tempo_inicio;
    80001d5c:	000c2783          	lw	a5,0(s8)
    80001d60:	9f85                	subw	a5,a5,s1
    80001d62:	168a2703          	lw	a4,360(s4)
    80001d66:	9fb9                	addw	a5,a5,a4
    80001d68:	16fa2423          	sw	a5,360(s4)
        c->proc = 0;
    80001d6c:	020bb823          	sd	zero,48(s7)
      while (run_proc->state == RUNNABLE){
    80001d70:	018a2783          	lw	a5,24(s4)
    80001d74:	fd278ae3          	beq	a5,s2,80001d48 <scheduler+0xc2>
      release(&run_proc->lock);
    80001d78:	856e                	mv	a0,s11
    80001d7a:	ebffe0ef          	jal	80000c38 <release>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d7e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d82:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d86:	10079073          	csrw	sstatus,a5
    struct proc *default_proc = 0;
    80001d8a:	4c81                	li	s9,0
    struct proc *io_proc = 0;
    80001d8c:	4a01                	li	s4,0
    struct proc *cpu_proc = 0;
    80001d8e:	4b01                	li	s6,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d90:	0000e497          	auipc	s1,0xe
    80001d94:	23048493          	add	s1,s1,560 # 8000ffc0 <proc>
      if(p->state == RUNNABLE) {
    80001d98:	490d                	li	s2,3
        } else if (p->type == DEFAULT && !default_proc){
    80001d9a:	4d85                	li	s11,1
    80001d9c:	bfa9                	j	80001cf6 <scheduler+0x70>
    if (cpu_proc || io_proc){
    80001d9e:	f80a18e3          	bnez	s4,80001d2e <scheduler+0xa8>
    if (run_proc){
    80001da2:	000c9d63          	bnez	s9,80001dbc <scheduler+0x136>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001daa:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dae:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001db2:	10500073          	wfi
    80001db6:	b7e1                	j	80001d7e <scheduler+0xf8>
    80001db8:	8a5a                	mv	s4,s6
    80001dba:	bf95                	j	80001d2e <scheduler+0xa8>
    80001dbc:	8a66                	mv	s4,s9
    80001dbe:	bf85                	j	80001d2e <scheduler+0xa8>

0000000080001dc0 <sched>:
{
    80001dc0:	7179                	add	sp,sp,-48
    80001dc2:	f406                	sd	ra,40(sp)
    80001dc4:	f022                	sd	s0,32(sp)
    80001dc6:	ec26                	sd	s1,24(sp)
    80001dc8:	e84a                	sd	s2,16(sp)
    80001dca:	e44e                	sd	s3,8(sp)
    80001dcc:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001dce:	a63ff0ef          	jal	80001830 <myproc>
    80001dd2:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001dd4:	d63fe0ef          	jal	80000b36 <holding>
    80001dd8:	c92d                	beqz	a0,80001e4a <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001dda:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001ddc:	2781                	sext.w	a5,a5
    80001dde:	079e                	sll	a5,a5,0x7
    80001de0:	0000e717          	auipc	a4,0xe
    80001de4:	cc070713          	add	a4,a4,-832 # 8000faa0 <pid_lock>
    80001de8:	97ba                	add	a5,a5,a4
    80001dea:	0a87a703          	lw	a4,168(a5)
    80001dee:	4785                	li	a5,1
    80001df0:	06f71363          	bne	a4,a5,80001e56 <sched+0x96>
  if(p->state == RUNNING)
    80001df4:	4c98                	lw	a4,24(s1)
    80001df6:	4791                	li	a5,4
    80001df8:	06f70563          	beq	a4,a5,80001e62 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dfc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e00:	8b89                	and	a5,a5,2
  if(intr_get())
    80001e02:	e7b5                	bnez	a5,80001e6e <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e04:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e06:	0000e917          	auipc	s2,0xe
    80001e0a:	c9a90913          	add	s2,s2,-870 # 8000faa0 <pid_lock>
    80001e0e:	2781                	sext.w	a5,a5
    80001e10:	079e                	sll	a5,a5,0x7
    80001e12:	97ca                	add	a5,a5,s2
    80001e14:	0ac7a983          	lw	s3,172(a5)
    80001e18:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e1a:	2781                	sext.w	a5,a5
    80001e1c:	079e                	sll	a5,a5,0x7
    80001e1e:	0000e597          	auipc	a1,0xe
    80001e22:	cba58593          	add	a1,a1,-838 # 8000fad8 <cpus+0x8>
    80001e26:	95be                	add	a1,a1,a5
    80001e28:	06048513          	add	a0,s1,96
    80001e2c:	758000ef          	jal	80002584 <swtch>
    80001e30:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e32:	2781                	sext.w	a5,a5
    80001e34:	079e                	sll	a5,a5,0x7
    80001e36:	993e                	add	s2,s2,a5
    80001e38:	0b392623          	sw	s3,172(s2)
}
    80001e3c:	70a2                	ld	ra,40(sp)
    80001e3e:	7402                	ld	s0,32(sp)
    80001e40:	64e2                	ld	s1,24(sp)
    80001e42:	6942                	ld	s2,16(sp)
    80001e44:	69a2                	ld	s3,8(sp)
    80001e46:	6145                	add	sp,sp,48
    80001e48:	8082                	ret
    panic("sched p->lock");
    80001e4a:	00005517          	auipc	a0,0x5
    80001e4e:	40650513          	add	a0,a0,1030 # 80007250 <digits+0x218>
    80001e52:	90dfe0ef          	jal	8000075e <panic>
    panic("sched locks");
    80001e56:	00005517          	auipc	a0,0x5
    80001e5a:	40a50513          	add	a0,a0,1034 # 80007260 <digits+0x228>
    80001e5e:	901fe0ef          	jal	8000075e <panic>
    panic("sched running");
    80001e62:	00005517          	auipc	a0,0x5
    80001e66:	40e50513          	add	a0,a0,1038 # 80007270 <digits+0x238>
    80001e6a:	8f5fe0ef          	jal	8000075e <panic>
    panic("sched interruptible");
    80001e6e:	00005517          	auipc	a0,0x5
    80001e72:	41250513          	add	a0,a0,1042 # 80007280 <digits+0x248>
    80001e76:	8e9fe0ef          	jal	8000075e <panic>

0000000080001e7a <yield>:
{
    80001e7a:	1101                	add	sp,sp,-32
    80001e7c:	ec06                	sd	ra,24(sp)
    80001e7e:	e822                	sd	s0,16(sp)
    80001e80:	e426                	sd	s1,8(sp)
    80001e82:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80001e84:	9adff0ef          	jal	80001830 <myproc>
    80001e88:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001e8a:	d17fe0ef          	jal	80000ba0 <acquire>
  p->state = RUNNABLE;
    80001e8e:	478d                	li	a5,3
    80001e90:	cc9c                	sw	a5,24(s1)
  sched();
    80001e92:	f2fff0ef          	jal	80001dc0 <sched>
  release(&p->lock);
    80001e96:	8526                	mv	a0,s1
    80001e98:	da1fe0ef          	jal	80000c38 <release>
}
    80001e9c:	60e2                	ld	ra,24(sp)
    80001e9e:	6442                	ld	s0,16(sp)
    80001ea0:	64a2                	ld	s1,8(sp)
    80001ea2:	6105                	add	sp,sp,32
    80001ea4:	8082                	ret

0000000080001ea6 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001ea6:	7179                	add	sp,sp,-48
    80001ea8:	f406                	sd	ra,40(sp)
    80001eaa:	f022                	sd	s0,32(sp)
    80001eac:	ec26                	sd	s1,24(sp)
    80001eae:	e84a                	sd	s2,16(sp)
    80001eb0:	e44e                	sd	s3,8(sp)
    80001eb2:	1800                	add	s0,sp,48
    80001eb4:	89aa                	mv	s3,a0
    80001eb6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001eb8:	979ff0ef          	jal	80001830 <myproc>
    80001ebc:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001ebe:	ce3fe0ef          	jal	80000ba0 <acquire>
  release(lk);
    80001ec2:	854a                	mv	a0,s2
    80001ec4:	d75fe0ef          	jal	80000c38 <release>

  // Go to sleep.
  p->chan = chan;
    80001ec8:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001ecc:	4789                	li	a5,2
    80001ece:	cc9c                	sw	a5,24(s1)

  sched();
    80001ed0:	ef1ff0ef          	jal	80001dc0 <sched>

  // Tidy up.
  p->chan = 0;
    80001ed4:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001ed8:	8526                	mv	a0,s1
    80001eda:	d5ffe0ef          	jal	80000c38 <release>
  acquire(lk);
    80001ede:	854a                	mv	a0,s2
    80001ee0:	cc1fe0ef          	jal	80000ba0 <acquire>
}
    80001ee4:	70a2                	ld	ra,40(sp)
    80001ee6:	7402                	ld	s0,32(sp)
    80001ee8:	64e2                	ld	s1,24(sp)
    80001eea:	6942                	ld	s2,16(sp)
    80001eec:	69a2                	ld	s3,8(sp)
    80001eee:	6145                	add	sp,sp,48
    80001ef0:	8082                	ret

0000000080001ef2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001ef2:	7139                	add	sp,sp,-64
    80001ef4:	fc06                	sd	ra,56(sp)
    80001ef6:	f822                	sd	s0,48(sp)
    80001ef8:	f426                	sd	s1,40(sp)
    80001efa:	f04a                	sd	s2,32(sp)
    80001efc:	ec4e                	sd	s3,24(sp)
    80001efe:	e852                	sd	s4,16(sp)
    80001f00:	e456                	sd	s5,8(sp)
    80001f02:	0080                	add	s0,sp,64
    80001f04:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f06:	0000e497          	auipc	s1,0xe
    80001f0a:	0ba48493          	add	s1,s1,186 # 8000ffc0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001f0e:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f10:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f12:	00026917          	auipc	s2,0x26
    80001f16:	8ae90913          	add	s2,s2,-1874 # 800277c0 <tickslock>
    80001f1a:	a801                	j	80001f2a <wakeup+0x38>
      }
      release(&p->lock);
    80001f1c:	8526                	mv	a0,s1
    80001f1e:	d1bfe0ef          	jal	80000c38 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f22:	17848493          	add	s1,s1,376
    80001f26:	03248263          	beq	s1,s2,80001f4a <wakeup+0x58>
    if(p != myproc()){
    80001f2a:	907ff0ef          	jal	80001830 <myproc>
    80001f2e:	fea48ae3          	beq	s1,a0,80001f22 <wakeup+0x30>
      acquire(&p->lock);
    80001f32:	8526                	mv	a0,s1
    80001f34:	c6dfe0ef          	jal	80000ba0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001f38:	4c9c                	lw	a5,24(s1)
    80001f3a:	ff3791e3          	bne	a5,s3,80001f1c <wakeup+0x2a>
    80001f3e:	709c                	ld	a5,32(s1)
    80001f40:	fd479ee3          	bne	a5,s4,80001f1c <wakeup+0x2a>
        p->state = RUNNABLE;
    80001f44:	0154ac23          	sw	s5,24(s1)
    80001f48:	bfd1                	j	80001f1c <wakeup+0x2a>
    }
  }
}
    80001f4a:	70e2                	ld	ra,56(sp)
    80001f4c:	7442                	ld	s0,48(sp)
    80001f4e:	74a2                	ld	s1,40(sp)
    80001f50:	7902                	ld	s2,32(sp)
    80001f52:	69e2                	ld	s3,24(sp)
    80001f54:	6a42                	ld	s4,16(sp)
    80001f56:	6aa2                	ld	s5,8(sp)
    80001f58:	6121                	add	sp,sp,64
    80001f5a:	8082                	ret

0000000080001f5c <reparent>:
{
    80001f5c:	7179                	add	sp,sp,-48
    80001f5e:	f406                	sd	ra,40(sp)
    80001f60:	f022                	sd	s0,32(sp)
    80001f62:	ec26                	sd	s1,24(sp)
    80001f64:	e84a                	sd	s2,16(sp)
    80001f66:	e44e                	sd	s3,8(sp)
    80001f68:	e052                	sd	s4,0(sp)
    80001f6a:	1800                	add	s0,sp,48
    80001f6c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f6e:	0000e497          	auipc	s1,0xe
    80001f72:	05248493          	add	s1,s1,82 # 8000ffc0 <proc>
      pp->parent = initproc;
    80001f76:	00006a17          	auipc	s4,0x6
    80001f7a:	9f2a0a13          	add	s4,s4,-1550 # 80007968 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f7e:	00026997          	auipc	s3,0x26
    80001f82:	84298993          	add	s3,s3,-1982 # 800277c0 <tickslock>
    80001f86:	a029                	j	80001f90 <reparent+0x34>
    80001f88:	17848493          	add	s1,s1,376
    80001f8c:	01348b63          	beq	s1,s3,80001fa2 <reparent+0x46>
    if(pp->parent == p){
    80001f90:	7c9c                	ld	a5,56(s1)
    80001f92:	ff279be3          	bne	a5,s2,80001f88 <reparent+0x2c>
      pp->parent = initproc;
    80001f96:	000a3503          	ld	a0,0(s4)
    80001f9a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001f9c:	f57ff0ef          	jal	80001ef2 <wakeup>
    80001fa0:	b7e5                	j	80001f88 <reparent+0x2c>
}
    80001fa2:	70a2                	ld	ra,40(sp)
    80001fa4:	7402                	ld	s0,32(sp)
    80001fa6:	64e2                	ld	s1,24(sp)
    80001fa8:	6942                	ld	s2,16(sp)
    80001faa:	69a2                	ld	s3,8(sp)
    80001fac:	6a02                	ld	s4,0(sp)
    80001fae:	6145                	add	sp,sp,48
    80001fb0:	8082                	ret

0000000080001fb2 <exit>:
{
    80001fb2:	7179                	add	sp,sp,-48
    80001fb4:	f406                	sd	ra,40(sp)
    80001fb6:	f022                	sd	s0,32(sp)
    80001fb8:	ec26                	sd	s1,24(sp)
    80001fba:	e84a                	sd	s2,16(sp)
    80001fbc:	e44e                	sd	s3,8(sp)
    80001fbe:	e052                	sd	s4,0(sp)
    80001fc0:	1800                	add	s0,sp,48
    80001fc2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001fc4:	86dff0ef          	jal	80001830 <myproc>
    80001fc8:	89aa                	mv	s3,a0
  if(p == initproc)
    80001fca:	00006797          	auipc	a5,0x6
    80001fce:	99e7b783          	ld	a5,-1634(a5) # 80007968 <initproc>
    80001fd2:	0d050493          	add	s1,a0,208
    80001fd6:	15050913          	add	s2,a0,336
    80001fda:	00a79f63          	bne	a5,a0,80001ff8 <exit+0x46>
    panic("init exiting");
    80001fde:	00005517          	auipc	a0,0x5
    80001fe2:	2ba50513          	add	a0,a0,698 # 80007298 <digits+0x260>
    80001fe6:	f78fe0ef          	jal	8000075e <panic>
      fileclose(f);
    80001fea:	06e020ef          	jal	80004058 <fileclose>
      p->ofile[fd] = 0;
    80001fee:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001ff2:	04a1                	add	s1,s1,8
    80001ff4:	01248563          	beq	s1,s2,80001ffe <exit+0x4c>
    if(p->ofile[fd]){
    80001ff8:	6088                	ld	a0,0(s1)
    80001ffa:	f965                	bnez	a0,80001fea <exit+0x38>
    80001ffc:	bfdd                	j	80001ff2 <exit+0x40>
  begin_op();
    80001ffe:	447010ef          	jal	80003c44 <begin_op>
  iput(p->cwd);
    80002002:	1509b503          	ld	a0,336(s3)
    80002006:	54e010ef          	jal	80003554 <iput>
  end_op();
    8000200a:	4a5010ef          	jal	80003cae <end_op>
  p->cwd = 0;
    8000200e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002012:	0000e497          	auipc	s1,0xe
    80002016:	aa648493          	add	s1,s1,-1370 # 8000fab8 <wait_lock>
    8000201a:	8526                	mv	a0,s1
    8000201c:	b85fe0ef          	jal	80000ba0 <acquire>
  reparent(p);
    80002020:	854e                	mv	a0,s3
    80002022:	f3bff0ef          	jal	80001f5c <reparent>
  wakeup(p->parent);
    80002026:	0389b503          	ld	a0,56(s3)
    8000202a:	ec9ff0ef          	jal	80001ef2 <wakeup>
  acquire(&p->lock);
    8000202e:	854e                	mv	a0,s3
    80002030:	b71fe0ef          	jal	80000ba0 <acquire>
  p->xstate = status;
    80002034:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002038:	4795                	li	a5,5
    8000203a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000203e:	8526                	mv	a0,s1
    80002040:	bf9fe0ef          	jal	80000c38 <release>
  sched();
    80002044:	d7dff0ef          	jal	80001dc0 <sched>
  panic("zombie exit");
    80002048:	00005517          	auipc	a0,0x5
    8000204c:	26050513          	add	a0,a0,608 # 800072a8 <digits+0x270>
    80002050:	f0efe0ef          	jal	8000075e <panic>

0000000080002054 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002054:	7179                	add	sp,sp,-48
    80002056:	f406                	sd	ra,40(sp)
    80002058:	f022                	sd	s0,32(sp)
    8000205a:	ec26                	sd	s1,24(sp)
    8000205c:	e84a                	sd	s2,16(sp)
    8000205e:	e44e                	sd	s3,8(sp)
    80002060:	1800                	add	s0,sp,48
    80002062:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002064:	0000e497          	auipc	s1,0xe
    80002068:	f5c48493          	add	s1,s1,-164 # 8000ffc0 <proc>
    8000206c:	00025997          	auipc	s3,0x25
    80002070:	75498993          	add	s3,s3,1876 # 800277c0 <tickslock>
    acquire(&p->lock);
    80002074:	8526                	mv	a0,s1
    80002076:	b2bfe0ef          	jal	80000ba0 <acquire>
    if(p->pid == pid){
    8000207a:	589c                	lw	a5,48(s1)
    8000207c:	01278b63          	beq	a5,s2,80002092 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002080:	8526                	mv	a0,s1
    80002082:	bb7fe0ef          	jal	80000c38 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002086:	17848493          	add	s1,s1,376
    8000208a:	ff3495e3          	bne	s1,s3,80002074 <kill+0x20>
  }
  return -1;
    8000208e:	557d                	li	a0,-1
    80002090:	a819                	j	800020a6 <kill+0x52>
      p->killed = 1;
    80002092:	4785                	li	a5,1
    80002094:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002096:	4c98                	lw	a4,24(s1)
    80002098:	4789                	li	a5,2
    8000209a:	00f70d63          	beq	a4,a5,800020b4 <kill+0x60>
      release(&p->lock);
    8000209e:	8526                	mv	a0,s1
    800020a0:	b99fe0ef          	jal	80000c38 <release>
      return 0;
    800020a4:	4501                	li	a0,0
}
    800020a6:	70a2                	ld	ra,40(sp)
    800020a8:	7402                	ld	s0,32(sp)
    800020aa:	64e2                	ld	s1,24(sp)
    800020ac:	6942                	ld	s2,16(sp)
    800020ae:	69a2                	ld	s3,8(sp)
    800020b0:	6145                	add	sp,sp,48
    800020b2:	8082                	ret
        p->state = RUNNABLE;
    800020b4:	478d                	li	a5,3
    800020b6:	cc9c                	sw	a5,24(s1)
    800020b8:	b7dd                	j	8000209e <kill+0x4a>

00000000800020ba <setkilled>:

void
setkilled(struct proc *p)
{
    800020ba:	1101                	add	sp,sp,-32
    800020bc:	ec06                	sd	ra,24(sp)
    800020be:	e822                	sd	s0,16(sp)
    800020c0:	e426                	sd	s1,8(sp)
    800020c2:	1000                	add	s0,sp,32
    800020c4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020c6:	adbfe0ef          	jal	80000ba0 <acquire>
  p->killed = 1;
    800020ca:	4785                	li	a5,1
    800020cc:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800020ce:	8526                	mv	a0,s1
    800020d0:	b69fe0ef          	jal	80000c38 <release>
}
    800020d4:	60e2                	ld	ra,24(sp)
    800020d6:	6442                	ld	s0,16(sp)
    800020d8:	64a2                	ld	s1,8(sp)
    800020da:	6105                	add	sp,sp,32
    800020dc:	8082                	ret

00000000800020de <killed>:

int
killed(struct proc *p)
{
    800020de:	1101                	add	sp,sp,-32
    800020e0:	ec06                	sd	ra,24(sp)
    800020e2:	e822                	sd	s0,16(sp)
    800020e4:	e426                	sd	s1,8(sp)
    800020e6:	e04a                	sd	s2,0(sp)
    800020e8:	1000                	add	s0,sp,32
    800020ea:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800020ec:	ab5fe0ef          	jal	80000ba0 <acquire>
  k = p->killed;
    800020f0:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800020f4:	8526                	mv	a0,s1
    800020f6:	b43fe0ef          	jal	80000c38 <release>
  return k;
}
    800020fa:	854a                	mv	a0,s2
    800020fc:	60e2                	ld	ra,24(sp)
    800020fe:	6442                	ld	s0,16(sp)
    80002100:	64a2                	ld	s1,8(sp)
    80002102:	6902                	ld	s2,0(sp)
    80002104:	6105                	add	sp,sp,32
    80002106:	8082                	ret

0000000080002108 <wait>:
{
    80002108:	715d                	add	sp,sp,-80
    8000210a:	e486                	sd	ra,72(sp)
    8000210c:	e0a2                	sd	s0,64(sp)
    8000210e:	fc26                	sd	s1,56(sp)
    80002110:	f84a                	sd	s2,48(sp)
    80002112:	f44e                	sd	s3,40(sp)
    80002114:	f052                	sd	s4,32(sp)
    80002116:	ec56                	sd	s5,24(sp)
    80002118:	e85a                	sd	s6,16(sp)
    8000211a:	e45e                	sd	s7,8(sp)
    8000211c:	0880                	add	s0,sp,80
    8000211e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002120:	f10ff0ef          	jal	80001830 <myproc>
    80002124:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002126:	0000e517          	auipc	a0,0xe
    8000212a:	99250513          	add	a0,a0,-1646 # 8000fab8 <wait_lock>
    8000212e:	a73fe0ef          	jal	80000ba0 <acquire>
    havekids = 0;
    80002132:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002134:	4a15                	li	s4,5
        havekids = 1;
    80002136:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002138:	00025997          	auipc	s3,0x25
    8000213c:	68898993          	add	s3,s3,1672 # 800277c0 <tickslock>
    havekids = 0;
    80002140:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002142:	0000e497          	auipc	s1,0xe
    80002146:	e7e48493          	add	s1,s1,-386 # 8000ffc0 <proc>
    8000214a:	a0b5                	j	800021b6 <wait+0xae>
          pid = pp->pid;
    8000214c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002150:	000b0c63          	beqz	s6,80002168 <wait+0x60>
    80002154:	4691                	li	a3,4
    80002156:	02c48613          	add	a2,s1,44
    8000215a:	85da                	mv	a1,s6
    8000215c:	05093503          	ld	a0,80(s2)
    80002160:	b88ff0ef          	jal	800014e8 <copyout>
    80002164:	02054a63          	bltz	a0,80002198 <wait+0x90>
          freeproc(pp);
    80002168:	8526                	mv	a0,s1
    8000216a:	839ff0ef          	jal	800019a2 <freeproc>
          release(&pp->lock);
    8000216e:	8526                	mv	a0,s1
    80002170:	ac9fe0ef          	jal	80000c38 <release>
          release(&wait_lock);
    80002174:	0000e517          	auipc	a0,0xe
    80002178:	94450513          	add	a0,a0,-1724 # 8000fab8 <wait_lock>
    8000217c:	abdfe0ef          	jal	80000c38 <release>
}
    80002180:	854e                	mv	a0,s3
    80002182:	60a6                	ld	ra,72(sp)
    80002184:	6406                	ld	s0,64(sp)
    80002186:	74e2                	ld	s1,56(sp)
    80002188:	7942                	ld	s2,48(sp)
    8000218a:	79a2                	ld	s3,40(sp)
    8000218c:	7a02                	ld	s4,32(sp)
    8000218e:	6ae2                	ld	s5,24(sp)
    80002190:	6b42                	ld	s6,16(sp)
    80002192:	6ba2                	ld	s7,8(sp)
    80002194:	6161                	add	sp,sp,80
    80002196:	8082                	ret
            release(&pp->lock);
    80002198:	8526                	mv	a0,s1
    8000219a:	a9ffe0ef          	jal	80000c38 <release>
            release(&wait_lock);
    8000219e:	0000e517          	auipc	a0,0xe
    800021a2:	91a50513          	add	a0,a0,-1766 # 8000fab8 <wait_lock>
    800021a6:	a93fe0ef          	jal	80000c38 <release>
            return -1;
    800021aa:	59fd                	li	s3,-1
    800021ac:	bfd1                	j	80002180 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021ae:	17848493          	add	s1,s1,376
    800021b2:	03348063          	beq	s1,s3,800021d2 <wait+0xca>
      if(pp->parent == p){
    800021b6:	7c9c                	ld	a5,56(s1)
    800021b8:	ff279be3          	bne	a5,s2,800021ae <wait+0xa6>
        acquire(&pp->lock);
    800021bc:	8526                	mv	a0,s1
    800021be:	9e3fe0ef          	jal	80000ba0 <acquire>
        if(pp->state == ZOMBIE){
    800021c2:	4c9c                	lw	a5,24(s1)
    800021c4:	f94784e3          	beq	a5,s4,8000214c <wait+0x44>
        release(&pp->lock);
    800021c8:	8526                	mv	a0,s1
    800021ca:	a6ffe0ef          	jal	80000c38 <release>
        havekids = 1;
    800021ce:	8756                	mv	a4,s5
    800021d0:	bff9                	j	800021ae <wait+0xa6>
    if(!havekids || killed(p)){
    800021d2:	cf09                	beqz	a4,800021ec <wait+0xe4>
    800021d4:	854a                	mv	a0,s2
    800021d6:	f09ff0ef          	jal	800020de <killed>
    800021da:	e909                	bnez	a0,800021ec <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021dc:	0000e597          	auipc	a1,0xe
    800021e0:	8dc58593          	add	a1,a1,-1828 # 8000fab8 <wait_lock>
    800021e4:	854a                	mv	a0,s2
    800021e6:	cc1ff0ef          	jal	80001ea6 <sleep>
    havekids = 0;
    800021ea:	bf99                	j	80002140 <wait+0x38>
      release(&wait_lock);
    800021ec:	0000e517          	auipc	a0,0xe
    800021f0:	8cc50513          	add	a0,a0,-1844 # 8000fab8 <wait_lock>
    800021f4:	a45fe0ef          	jal	80000c38 <release>
      return -1;
    800021f8:	59fd                	li	s3,-1
    800021fa:	b759                	j	80002180 <wait+0x78>

00000000800021fc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800021fc:	7179                	add	sp,sp,-48
    800021fe:	f406                	sd	ra,40(sp)
    80002200:	f022                	sd	s0,32(sp)
    80002202:	ec26                	sd	s1,24(sp)
    80002204:	e84a                	sd	s2,16(sp)
    80002206:	e44e                	sd	s3,8(sp)
    80002208:	e052                	sd	s4,0(sp)
    8000220a:	1800                	add	s0,sp,48
    8000220c:	84aa                	mv	s1,a0
    8000220e:	892e                	mv	s2,a1
    80002210:	89b2                	mv	s3,a2
    80002212:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002214:	e1cff0ef          	jal	80001830 <myproc>
  if(user_dst){
    80002218:	cc99                	beqz	s1,80002236 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000221a:	86d2                	mv	a3,s4
    8000221c:	864e                	mv	a2,s3
    8000221e:	85ca                	mv	a1,s2
    80002220:	6928                	ld	a0,80(a0)
    80002222:	ac6ff0ef          	jal	800014e8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002226:	70a2                	ld	ra,40(sp)
    80002228:	7402                	ld	s0,32(sp)
    8000222a:	64e2                	ld	s1,24(sp)
    8000222c:	6942                	ld	s2,16(sp)
    8000222e:	69a2                	ld	s3,8(sp)
    80002230:	6a02                	ld	s4,0(sp)
    80002232:	6145                	add	sp,sp,48
    80002234:	8082                	ret
    memmove((char *)dst, src, len);
    80002236:	000a061b          	sext.w	a2,s4
    8000223a:	85ce                	mv	a1,s3
    8000223c:	854a                	mv	a0,s2
    8000223e:	a93fe0ef          	jal	80000cd0 <memmove>
    return 0;
    80002242:	8526                	mv	a0,s1
    80002244:	b7cd                	j	80002226 <either_copyout+0x2a>

0000000080002246 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002246:	7179                	add	sp,sp,-48
    80002248:	f406                	sd	ra,40(sp)
    8000224a:	f022                	sd	s0,32(sp)
    8000224c:	ec26                	sd	s1,24(sp)
    8000224e:	e84a                	sd	s2,16(sp)
    80002250:	e44e                	sd	s3,8(sp)
    80002252:	e052                	sd	s4,0(sp)
    80002254:	1800                	add	s0,sp,48
    80002256:	892a                	mv	s2,a0
    80002258:	84ae                	mv	s1,a1
    8000225a:	89b2                	mv	s3,a2
    8000225c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000225e:	dd2ff0ef          	jal	80001830 <myproc>
  if(user_src){
    80002262:	cc99                	beqz	s1,80002280 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002264:	86d2                	mv	a3,s4
    80002266:	864e                	mv	a2,s3
    80002268:	85ca                	mv	a1,s2
    8000226a:	6928                	ld	a0,80(a0)
    8000226c:	b34ff0ef          	jal	800015a0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002270:	70a2                	ld	ra,40(sp)
    80002272:	7402                	ld	s0,32(sp)
    80002274:	64e2                	ld	s1,24(sp)
    80002276:	6942                	ld	s2,16(sp)
    80002278:	69a2                	ld	s3,8(sp)
    8000227a:	6a02                	ld	s4,0(sp)
    8000227c:	6145                	add	sp,sp,48
    8000227e:	8082                	ret
    memmove(dst, (char*)src, len);
    80002280:	000a061b          	sext.w	a2,s4
    80002284:	85ce                	mv	a1,s3
    80002286:	854a                	mv	a0,s2
    80002288:	a49fe0ef          	jal	80000cd0 <memmove>
    return 0;
    8000228c:	8526                	mv	a0,s1
    8000228e:	b7cd                	j	80002270 <either_copyin+0x2a>

0000000080002290 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002290:	715d                	add	sp,sp,-80
    80002292:	e486                	sd	ra,72(sp)
    80002294:	e0a2                	sd	s0,64(sp)
    80002296:	fc26                	sd	s1,56(sp)
    80002298:	f84a                	sd	s2,48(sp)
    8000229a:	f44e                	sd	s3,40(sp)
    8000229c:	f052                	sd	s4,32(sp)
    8000229e:	ec56                	sd	s5,24(sp)
    800022a0:	e85a                	sd	s6,16(sp)
    800022a2:	e45e                	sd	s7,8(sp)
    800022a4:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800022a6:	00005517          	auipc	a0,0x5
    800022aa:	e1a50513          	add	a0,a0,-486 # 800070c0 <digits+0x88>
    800022ae:	9f0fe0ef          	jal	8000049e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800022b2:	0000e497          	auipc	s1,0xe
    800022b6:	e6648493          	add	s1,s1,-410 # 80010118 <proc+0x158>
    800022ba:	00025917          	auipc	s2,0x25
    800022be:	65e90913          	add	s2,s2,1630 # 80027918 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022c2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800022c4:	00005997          	auipc	s3,0x5
    800022c8:	ff498993          	add	s3,s3,-12 # 800072b8 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    800022cc:	00005a97          	auipc	s5,0x5
    800022d0:	ff4a8a93          	add	s5,s5,-12 # 800072c0 <digits+0x288>
    printf("\n");
    800022d4:	00005a17          	auipc	s4,0x5
    800022d8:	deca0a13          	add	s4,s4,-532 # 800070c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022dc:	00005b97          	auipc	s7,0x5
    800022e0:	024b8b93          	add	s7,s7,36 # 80007300 <states.0>
    800022e4:	a829                	j	800022fe <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800022e6:	ed86a583          	lw	a1,-296(a3)
    800022ea:	8556                	mv	a0,s5
    800022ec:	9b2fe0ef          	jal	8000049e <printf>
    printf("\n");
    800022f0:	8552                	mv	a0,s4
    800022f2:	9acfe0ef          	jal	8000049e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800022f6:	17848493          	add	s1,s1,376
    800022fa:	03248263          	beq	s1,s2,8000231e <procdump+0x8e>
    if(p->state == UNUSED)
    800022fe:	86a6                	mv	a3,s1
    80002300:	ec04a783          	lw	a5,-320(s1)
    80002304:	dbed                	beqz	a5,800022f6 <procdump+0x66>
      state = "???";
    80002306:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002308:	fcfb6fe3          	bltu	s6,a5,800022e6 <procdump+0x56>
    8000230c:	02079713          	sll	a4,a5,0x20
    80002310:	01d75793          	srl	a5,a4,0x1d
    80002314:	97de                	add	a5,a5,s7
    80002316:	6390                	ld	a2,0(a5)
    80002318:	f679                	bnez	a2,800022e6 <procdump+0x56>
      state = "???";
    8000231a:	864e                	mv	a2,s3
    8000231c:	b7e9                	j	800022e6 <procdump+0x56>
  }
}
    8000231e:	60a6                	ld	ra,72(sp)
    80002320:	6406                	ld	s0,64(sp)
    80002322:	74e2                	ld	s1,56(sp)
    80002324:	7942                	ld	s2,48(sp)
    80002326:	79a2                	ld	s3,40(sp)
    80002328:	7a02                	ld	s4,32(sp)
    8000232a:	6ae2                	ld	s5,24(sp)
    8000232c:	6b42                	ld	s6,16(sp)
    8000232e:	6ba2                	ld	s7,8(sp)
    80002330:	6161                	add	sp,sp,80
    80002332:	8082                	ret

0000000080002334 <sys_tempo_total>:


int sys_tempo_total(void){
    80002334:	1101                	add	sp,sp,-32
    80002336:	ec06                	sd	ra,24(sp)
    80002338:	e822                	sd	s0,16(sp)
    8000233a:	1000                	add	s0,sp,32
  int pid;
  struct proc *p;

  argint(0, &pid);  //Chama a função, que modifica o valor de pid
    8000233c:	fec40593          	add	a1,s0,-20
    80002340:	4501                	li	a0,0
    80002342:	690000ef          	jal	800029d2 <argint>
  if (pid < 0) {
    80002346:	fec42683          	lw	a3,-20(s0)
    8000234a:	0206c963          	bltz	a3,8000237c <sys_tempo_total+0x48>
      // Tratar erro, já que o pid não pode ser negativo
      return -1;
  }
  //Busca o processo com o PID fornecido
  for(p = proc; p < &proc[NPROC]; p++) {
    8000234e:	0000e797          	auipc	a5,0xe
    80002352:	c7278793          	add	a5,a5,-910 # 8000ffc0 <proc>
    80002356:	00025617          	auipc	a2,0x25
    8000235a:	46a60613          	add	a2,a2,1130 # 800277c0 <tickslock>
      if(p->pid == pid) {
    8000235e:	5b98                	lw	a4,48(a5)
    80002360:	00d70863          	beq	a4,a3,80002370 <sys_tempo_total+0x3c>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002364:	17878793          	add	a5,a5,376
    80002368:	fec79be3          	bne	a5,a2,8000235e <sys_tempo_total+0x2a>
          return p->tempo_total;
      }
  }

  return -1;  //Se o processo não for encontrado
    8000236c:	557d                	li	a0,-1
    8000236e:	a019                	j	80002374 <sys_tempo_total+0x40>
          return p->tempo_total;
    80002370:	1687a503          	lw	a0,360(a5)
}
    80002374:	60e2                	ld	ra,24(sp)
    80002376:	6442                	ld	s0,16(sp)
    80002378:	6105                	add	sp,sp,32
    8000237a:	8082                	ret
      return -1;
    8000237c:	557d                	li	a0,-1
    8000237e:	bfdd                	j	80002374 <sys_tempo_total+0x40>

0000000080002380 <sys_get_overhead>:


int sys_get_overhead(void){
    80002380:	1101                	add	sp,sp,-32
    80002382:	ec06                	sd	ra,24(sp)
    80002384:	e822                	sd	s0,16(sp)
    80002386:	1000                	add	s0,sp,32
  int index;

  argint(0, &index);
    80002388:	fec40593          	add	a1,s0,-20
    8000238c:	4501                	li	a0,0
    8000238e:	644000ef          	jal	800029d2 <argint>
  return overheads[index];
    80002392:	fec42703          	lw	a4,-20(s0)
    80002396:	070a                	sll	a4,a4,0x2
    80002398:	0000d797          	auipc	a5,0xd
    8000239c:	70878793          	add	a5,a5,1800 # 8000faa0 <pid_lock>
    800023a0:	97ba                	add	a5,a5,a4
}
    800023a2:	4307a503          	lw	a0,1072(a5)
    800023a6:	60e2                	ld	ra,24(sp)
    800023a8:	6442                	ld	s0,16(sp)
    800023aa:	6105                	add	sp,sp,32
    800023ac:	8082                	ret

00000000800023ae <sys_get_eficiencia>:


int sys_get_eficiencia(void){
    800023ae:	1101                	add	sp,sp,-32
    800023b0:	ec06                	sd	ra,24(sp)
    800023b2:	e822                	sd	s0,16(sp)
    800023b4:	1000                	add	s0,sp,32
  int index;
  
  argint(0, &index);
    800023b6:	fec40593          	add	a1,s0,-20
    800023ba:	4501                	li	a0,0
    800023bc:	616000ef          	jal	800029d2 <argint>
  return eficiencias[index];
    800023c0:	fec42703          	lw	a4,-20(s0)
    800023c4:	070a                	sll	a4,a4,0x2
    800023c6:	0000d797          	auipc	a5,0xd
    800023ca:	6da78793          	add	a5,a5,1754 # 8000faa0 <pid_lock>
    800023ce:	97ba                	add	a5,a5,a4
}
    800023d0:	4807a503          	lw	a0,1152(a5)
    800023d4:	60e2                	ld	ra,24(sp)
    800023d6:	6442                	ld	s0,16(sp)
    800023d8:	6105                	add	sp,sp,32
    800023da:	8082                	ret

00000000800023dc <sys_increment_metric>:

int sys_increment_metric(void){
    800023dc:	1101                	add	sp,sp,-32
    800023de:	ec06                	sd	ra,24(sp)
    800023e0:	e822                	sd	s0,16(sp)
    800023e2:	1000                	add	s0,sp,32
  int index, amount, mode;

  argint(0, &index);
    800023e4:	fec40593          	add	a1,s0,-20
    800023e8:	4501                	li	a0,0
    800023ea:	5e8000ef          	jal	800029d2 <argint>
  argint(1, &amount);
    800023ee:	fe840593          	add	a1,s0,-24
    800023f2:	4505                	li	a0,1
    800023f4:	5de000ef          	jal	800029d2 <argint>
  argint(2, &mode);
    800023f8:	fe440593          	add	a1,s0,-28
    800023fc:	4509                	li	a0,2
    800023fe:	5d4000ef          	jal	800029d2 <argint>

  if (mode == MODE_OVERHEAD){
    80002402:	fe442783          	lw	a5,-28(s0)
    80002406:	4721                	li	a4,8
    80002408:	02e78963          	beq	a5,a4,8000243a <sys_increment_metric+0x5e>
    overheads[index] += amount;
    return 0;
  } else if (mode == MODE_EFICIENCIA) {
    8000240c:	4729                	li	a4,10
    8000240e:	04e79763          	bne	a5,a4,8000245c <sys_increment_metric+0x80>
    eficiencias[index] += amount;
    80002412:	fec42703          	lw	a4,-20(s0)
    80002416:	070a                	sll	a4,a4,0x2
    80002418:	0000d797          	auipc	a5,0xd
    8000241c:	68878793          	add	a5,a5,1672 # 8000faa0 <pid_lock>
    80002420:	97ba                	add	a5,a5,a4
    80002422:	4807a683          	lw	a3,1152(a5)
    80002426:	fe842703          	lw	a4,-24(s0)
    8000242a:	9f35                	addw	a4,a4,a3
    8000242c:	48e7a023          	sw	a4,1152(a5)
    return 0;
    80002430:	4501                	li	a0,0
  }

  return -1;

}
    80002432:	60e2                	ld	ra,24(sp)
    80002434:	6442                	ld	s0,16(sp)
    80002436:	6105                	add	sp,sp,32
    80002438:	8082                	ret
    overheads[index] += amount;
    8000243a:	fec42703          	lw	a4,-20(s0)
    8000243e:	070a                	sll	a4,a4,0x2
    80002440:	0000d797          	auipc	a5,0xd
    80002444:	66078793          	add	a5,a5,1632 # 8000faa0 <pid_lock>
    80002448:	97ba                	add	a5,a5,a4
    8000244a:	4307a683          	lw	a3,1072(a5)
    8000244e:	fe842703          	lw	a4,-24(s0)
    80002452:	9f35                	addw	a4,a4,a3
    80002454:	42e7a823          	sw	a4,1072(a5)
    return 0;
    80002458:	4501                	li	a0,0
    8000245a:	bfe1                	j	80002432 <sys_increment_metric+0x56>
  return -1;
    8000245c:	557d                	li	a0,-1
    8000245e:	bfd1                	j	80002432 <sys_increment_metric+0x56>

0000000080002460 <sys_initialize_metrics>:

int sys_initialize_metrics(void){
    80002460:	1141                	add	sp,sp,-16
    80002462:	e422                	sd	s0,8(sp)
    80002464:	0800                	add	s0,sp,16
  for (int k = 0; k < 20; k++){
    80002466:	0000e797          	auipc	a5,0xe
    8000246a:	a6a78793          	add	a5,a5,-1430 # 8000fed0 <overheads>
    8000246e:	0000e717          	auipc	a4,0xe
    80002472:	ab270713          	add	a4,a4,-1358 # 8000ff20 <eficiencias>
    80002476:	0000e697          	auipc	a3,0xe
    8000247a:	afa68693          	add	a3,a3,-1286 # 8000ff70 <justicas>
    8000247e:	863a                	mv	a2,a4
    overheads[k] = 0;
    80002480:	0007a023          	sw	zero,0(a5)
    eficiencias[k] = 0;
    80002484:	00072023          	sw	zero,0(a4)
    justicas[k] = 0;
    80002488:	0006a023          	sw	zero,0(a3)
  for (int k = 0; k < 20; k++){
    8000248c:	0791                	add	a5,a5,4
    8000248e:	0711                	add	a4,a4,4
    80002490:	0691                	add	a3,a3,4
    80002492:	fec797e3          	bne	a5,a2,80002480 <sys_initialize_metrics+0x20>
  }
  return 0;
}
    80002496:	4501                	li	a0,0
    80002498:	6422                	ld	s0,8(sp)
    8000249a:	0141                	add	sp,sp,16
    8000249c:	8082                	ret

000000008000249e <sys_get_justica>:

int sys_get_justica(void){
    8000249e:	1101                	add	sp,sp,-32
    800024a0:	ec06                	sd	ra,24(sp)
    800024a2:	e822                	sd	s0,16(sp)
    800024a4:	1000                	add	s0,sp,32
  int index;
  argint(0, &index);
    800024a6:	fec40593          	add	a1,s0,-20
    800024aa:	4501                	li	a0,0
    800024ac:	526000ef          	jal	800029d2 <argint>
  return justicas[index];
    800024b0:	fec42703          	lw	a4,-20(s0)
    800024b4:	070a                	sll	a4,a4,0x2
    800024b6:	0000d797          	auipc	a5,0xd
    800024ba:	5ea78793          	add	a5,a5,1514 # 8000faa0 <pid_lock>
    800024be:	97ba                	add	a5,a5,a4
}
    800024c0:	4d07a503          	lw	a0,1232(a5)
    800024c4:	60e2                	ld	ra,24(sp)
    800024c6:	6442                	ld	s0,16(sp)
    800024c8:	6105                	add	sp,sp,32
    800024ca:	8082                	ret

00000000800024cc <sys_set_justica>:

int sys_set_justica(void){
    800024cc:	1101                	add	sp,sp,-32
    800024ce:	ec06                	sd	ra,24(sp)
    800024d0:	e822                	sd	s0,16(sp)
    800024d2:	1000                	add	s0,sp,32
  int index, pid;
  struct proc *p;

  argint(0, &index);
    800024d4:	fec40593          	add	a1,s0,-20
    800024d8:	4501                	li	a0,0
    800024da:	4f8000ef          	jal	800029d2 <argint>
  argint(1, &pid);
    800024de:	fe840593          	add	a1,s0,-24
    800024e2:	4505                	li	a0,1
    800024e4:	4ee000ef          	jal	800029d2 <argint>

  for(p = proc; p < &proc[NPROC]; p++) {
    if(p->pid == pid) {
    800024e8:	fe842683          	lw	a3,-24(s0)
  for(p = proc; p < &proc[NPROC]; p++) {
    800024ec:	0000e797          	auipc	a5,0xe
    800024f0:	ad478793          	add	a5,a5,-1324 # 8000ffc0 <proc>
    800024f4:	00025617          	auipc	a2,0x25
    800024f8:	2cc60613          	add	a2,a2,716 # 800277c0 <tickslock>
    if(p->pid == pid) {
    800024fc:	5b98                	lw	a4,48(a5)
    800024fe:	00d70863          	beq	a4,a3,8000250e <sys_set_justica+0x42>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002502:	17878793          	add	a5,a5,376
    80002506:	fec79be3          	bne	a5,a2,800024fc <sys_set_justica+0x30>
        justicas[index] = p->tempo_total;
        return 0;
    }
  }
  return -1;
    8000250a:	557d                	li	a0,-1
    8000250c:	a831                	j	80002528 <sys_set_justica+0x5c>
        justicas[index] = p->tempo_total;
    8000250e:	fec42683          	lw	a3,-20(s0)
    80002512:	068a                	sll	a3,a3,0x2
    80002514:	0000d717          	auipc	a4,0xd
    80002518:	58c70713          	add	a4,a4,1420 # 8000faa0 <pid_lock>
    8000251c:	9736                	add	a4,a4,a3
    8000251e:	1687a783          	lw	a5,360(a5)
    80002522:	4cf72823          	sw	a5,1232(a4)
        return 0;
    80002526:	4501                	li	a0,0
}
    80002528:	60e2                	ld	ra,24(sp)
    8000252a:	6442                	ld	s0,16(sp)
    8000252c:	6105                	add	sp,sp,32
    8000252e:	8082                	ret

0000000080002530 <sys_set_type>:

int sys_set_type(void){
    80002530:	1101                	add	sp,sp,-32
    80002532:	ec06                	sd	ra,24(sp)
    80002534:	e822                	sd	s0,16(sp)
    80002536:	1000                	add	s0,sp,32
  int type, pid;
  struct proc *p;
  argint(0, &type);
    80002538:	fec40593          	add	a1,s0,-20
    8000253c:	4501                	li	a0,0
    8000253e:	494000ef          	jal	800029d2 <argint>
  argint(1, &pid);
    80002542:	fe840593          	add	a1,s0,-24
    80002546:	4505                	li	a0,1
    80002548:	48a000ef          	jal	800029d2 <argint>

  for(p = proc; p < &proc[NPROC]; p++) {
    if(p->pid == pid) {
    8000254c:	fe842683          	lw	a3,-24(s0)
  for(p = proc; p < &proc[NPROC]; p++) {
    80002550:	0000e797          	auipc	a5,0xe
    80002554:	a7078793          	add	a5,a5,-1424 # 8000ffc0 <proc>
    80002558:	00025617          	auipc	a2,0x25
    8000255c:	26860613          	add	a2,a2,616 # 800277c0 <tickslock>
    if(p->pid == pid) {
    80002560:	5b98                	lw	a4,48(a5)
    80002562:	00d70863          	beq	a4,a3,80002572 <sys_set_type+0x42>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002566:	17878793          	add	a5,a5,376
    8000256a:	fec79be3          	bne	a5,a2,80002560 <sys_set_type+0x30>
        p->type = type;
        return 0;
    }
  }
  return -1;
    8000256e:	557d                	li	a0,-1
    80002570:	a031                	j	8000257c <sys_set_type+0x4c>
        p->type = type;
    80002572:	fec42703          	lw	a4,-20(s0)
    80002576:	16e7aa23          	sw	a4,372(a5)
        return 0;
    8000257a:	4501                	li	a0,0
    8000257c:	60e2                	ld	ra,24(sp)
    8000257e:	6442                	ld	s0,16(sp)
    80002580:	6105                	add	sp,sp,32
    80002582:	8082                	ret

0000000080002584 <swtch>:
    80002584:	00153023          	sd	ra,0(a0)
    80002588:	00253423          	sd	sp,8(a0)
    8000258c:	e900                	sd	s0,16(a0)
    8000258e:	ed04                	sd	s1,24(a0)
    80002590:	03253023          	sd	s2,32(a0)
    80002594:	03353423          	sd	s3,40(a0)
    80002598:	03453823          	sd	s4,48(a0)
    8000259c:	03553c23          	sd	s5,56(a0)
    800025a0:	05653023          	sd	s6,64(a0)
    800025a4:	05753423          	sd	s7,72(a0)
    800025a8:	05853823          	sd	s8,80(a0)
    800025ac:	05953c23          	sd	s9,88(a0)
    800025b0:	07a53023          	sd	s10,96(a0)
    800025b4:	07b53423          	sd	s11,104(a0)
    800025b8:	0005b083          	ld	ra,0(a1)
    800025bc:	0085b103          	ld	sp,8(a1)
    800025c0:	6980                	ld	s0,16(a1)
    800025c2:	6d84                	ld	s1,24(a1)
    800025c4:	0205b903          	ld	s2,32(a1)
    800025c8:	0285b983          	ld	s3,40(a1)
    800025cc:	0305ba03          	ld	s4,48(a1)
    800025d0:	0385ba83          	ld	s5,56(a1)
    800025d4:	0405bb03          	ld	s6,64(a1)
    800025d8:	0485bb83          	ld	s7,72(a1)
    800025dc:	0505bc03          	ld	s8,80(a1)
    800025e0:	0585bc83          	ld	s9,88(a1)
    800025e4:	0605bd03          	ld	s10,96(a1)
    800025e8:	0685bd83          	ld	s11,104(a1)
    800025ec:	8082                	ret

00000000800025ee <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800025ee:	1141                	add	sp,sp,-16
    800025f0:	e406                	sd	ra,8(sp)
    800025f2:	e022                	sd	s0,0(sp)
    800025f4:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    800025f6:	00005597          	auipc	a1,0x5
    800025fa:	d3a58593          	add	a1,a1,-710 # 80007330 <states.0+0x30>
    800025fe:	00025517          	auipc	a0,0x25
    80002602:	1c250513          	add	a0,a0,450 # 800277c0 <tickslock>
    80002606:	d1afe0ef          	jal	80000b20 <initlock>
}
    8000260a:	60a2                	ld	ra,8(sp)
    8000260c:	6402                	ld	s0,0(sp)
    8000260e:	0141                	add	sp,sp,16
    80002610:	8082                	ret

0000000080002612 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002612:	1141                	add	sp,sp,-16
    80002614:	e422                	sd	s0,8(sp)
    80002616:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002618:	00003797          	auipc	a5,0x3
    8000261c:	cd878793          	add	a5,a5,-808 # 800052f0 <kernelvec>
    80002620:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002624:	6422                	ld	s0,8(sp)
    80002626:	0141                	add	sp,sp,16
    80002628:	8082                	ret

000000008000262a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000262a:	1141                	add	sp,sp,-16
    8000262c:	e406                	sd	ra,8(sp)
    8000262e:	e022                	sd	s0,0(sp)
    80002630:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80002632:	9feff0ef          	jal	80001830 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002636:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000263a:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000263c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002640:	00004697          	auipc	a3,0x4
    80002644:	9c068693          	add	a3,a3,-1600 # 80006000 <_trampoline>
    80002648:	00004717          	auipc	a4,0x4
    8000264c:	9b870713          	add	a4,a4,-1608 # 80006000 <_trampoline>
    80002650:	8f15                	sub	a4,a4,a3
    80002652:	040007b7          	lui	a5,0x4000
    80002656:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002658:	07b2                	sll	a5,a5,0xc
    8000265a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000265c:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002660:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002662:	18002673          	csrr	a2,satp
    80002666:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002668:	6d30                	ld	a2,88(a0)
    8000266a:	6138                	ld	a4,64(a0)
    8000266c:	6585                	lui	a1,0x1
    8000266e:	972e                	add	a4,a4,a1
    80002670:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002672:	6d38                	ld	a4,88(a0)
    80002674:	00000617          	auipc	a2,0x0
    80002678:	10c60613          	add	a2,a2,268 # 80002780 <usertrap>
    8000267c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000267e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002680:	8612                	mv	a2,tp
    80002682:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002684:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002688:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000268c:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002690:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002694:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002696:	6f18                	ld	a4,24(a4)
    80002698:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000269c:	6928                	ld	a0,80(a0)
    8000269e:	8131                	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800026a0:	00004717          	auipc	a4,0x4
    800026a4:	9fc70713          	add	a4,a4,-1540 # 8000609c <userret>
    800026a8:	8f15                	sub	a4,a4,a3
    800026aa:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800026ac:	577d                	li	a4,-1
    800026ae:	177e                	sll	a4,a4,0x3f
    800026b0:	8d59                	or	a0,a0,a4
    800026b2:	9782                	jalr	a5
}
    800026b4:	60a2                	ld	ra,8(sp)
    800026b6:	6402                	ld	s0,0(sp)
    800026b8:	0141                	add	sp,sp,16
    800026ba:	8082                	ret

00000000800026bc <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800026bc:	1101                	add	sp,sp,-32
    800026be:	ec06                	sd	ra,24(sp)
    800026c0:	e822                	sd	s0,16(sp)
    800026c2:	e426                	sd	s1,8(sp)
    800026c4:	1000                	add	s0,sp,32
  if(cpuid() == 0){
    800026c6:	93eff0ef          	jal	80001804 <cpuid>
    800026ca:	cd19                	beqz	a0,800026e8 <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    800026cc:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800026d0:	000f4737          	lui	a4,0xf4
    800026d4:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800026d8:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800026da:	14d79073          	csrw	stimecmp,a5
}
    800026de:	60e2                	ld	ra,24(sp)
    800026e0:	6442                	ld	s0,16(sp)
    800026e2:	64a2                	ld	s1,8(sp)
    800026e4:	6105                	add	sp,sp,32
    800026e6:	8082                	ret
    acquire(&tickslock);
    800026e8:	00025497          	auipc	s1,0x25
    800026ec:	0d848493          	add	s1,s1,216 # 800277c0 <tickslock>
    800026f0:	8526                	mv	a0,s1
    800026f2:	caefe0ef          	jal	80000ba0 <acquire>
    ticks++;
    800026f6:	00005517          	auipc	a0,0x5
    800026fa:	27a50513          	add	a0,a0,634 # 80007970 <ticks>
    800026fe:	411c                	lw	a5,0(a0)
    80002700:	2785                	addw	a5,a5,1
    80002702:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002704:	feeff0ef          	jal	80001ef2 <wakeup>
    release(&tickslock);
    80002708:	8526                	mv	a0,s1
    8000270a:	d2efe0ef          	jal	80000c38 <release>
    8000270e:	bf7d                	j	800026cc <clockintr+0x10>

0000000080002710 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002710:	1101                	add	sp,sp,-32
    80002712:	ec06                	sd	ra,24(sp)
    80002714:	e822                	sd	s0,16(sp)
    80002716:	e426                	sd	s1,8(sp)
    80002718:	1000                	add	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000271a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000271e:	57fd                	li	a5,-1
    80002720:	17fe                	sll	a5,a5,0x3f
    80002722:	07a5                	add	a5,a5,9
    80002724:	00f70d63          	beq	a4,a5,8000273e <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002728:	57fd                	li	a5,-1
    8000272a:	17fe                	sll	a5,a5,0x3f
    8000272c:	0795                	add	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000272e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002730:	04f70463          	beq	a4,a5,80002778 <devintr+0x68>
  }
}
    80002734:	60e2                	ld	ra,24(sp)
    80002736:	6442                	ld	s0,16(sp)
    80002738:	64a2                	ld	s1,8(sp)
    8000273a:	6105                	add	sp,sp,32
    8000273c:	8082                	ret
    int irq = plic_claim();
    8000273e:	45b020ef          	jal	80005398 <plic_claim>
    80002742:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002744:	47a9                	li	a5,10
    80002746:	02f50363          	beq	a0,a5,8000276c <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    8000274a:	4785                	li	a5,1
    8000274c:	02f50363          	beq	a0,a5,80002772 <devintr+0x62>
    return 1;
    80002750:	4505                	li	a0,1
    } else if(irq){
    80002752:	d0ed                	beqz	s1,80002734 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80002754:	85a6                	mv	a1,s1
    80002756:	00005517          	auipc	a0,0x5
    8000275a:	be250513          	add	a0,a0,-1054 # 80007338 <states.0+0x38>
    8000275e:	d41fd0ef          	jal	8000049e <printf>
      plic_complete(irq);
    80002762:	8526                	mv	a0,s1
    80002764:	455020ef          	jal	800053b8 <plic_complete>
    return 1;
    80002768:	4505                	li	a0,1
    8000276a:	b7e9                	j	80002734 <devintr+0x24>
      uartintr();
    8000276c:	a46fe0ef          	jal	800009b2 <uartintr>
    if(irq)
    80002770:	bfcd                	j	80002762 <devintr+0x52>
      virtio_disk_intr();
    80002772:	0b0030ef          	jal	80005822 <virtio_disk_intr>
    if(irq)
    80002776:	b7f5                	j	80002762 <devintr+0x52>
    clockintr();
    80002778:	f45ff0ef          	jal	800026bc <clockintr>
    return 2;
    8000277c:	4509                	li	a0,2
    8000277e:	bf5d                	j	80002734 <devintr+0x24>

0000000080002780 <usertrap>:
{
    80002780:	1101                	add	sp,sp,-32
    80002782:	ec06                	sd	ra,24(sp)
    80002784:	e822                	sd	s0,16(sp)
    80002786:	e426                	sd	s1,8(sp)
    80002788:	e04a                	sd	s2,0(sp)
    8000278a:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000278c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002790:	1007f793          	and	a5,a5,256
    80002794:	ef85                	bnez	a5,800027cc <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002796:	00003797          	auipc	a5,0x3
    8000279a:	b5a78793          	add	a5,a5,-1190 # 800052f0 <kernelvec>
    8000279e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800027a2:	88eff0ef          	jal	80001830 <myproc>
    800027a6:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800027a8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027aa:	14102773          	csrr	a4,sepc
    800027ae:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027b0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800027b4:	47a1                	li	a5,8
    800027b6:	02f70163          	beq	a4,a5,800027d8 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800027ba:	f57ff0ef          	jal	80002710 <devintr>
    800027be:	892a                	mv	s2,a0
    800027c0:	c135                	beqz	a0,80002824 <usertrap+0xa4>
  if(killed(p))
    800027c2:	8526                	mv	a0,s1
    800027c4:	91bff0ef          	jal	800020de <killed>
    800027c8:	cd1d                	beqz	a0,80002806 <usertrap+0x86>
    800027ca:	a81d                	j	80002800 <usertrap+0x80>
    panic("usertrap: not from user mode");
    800027cc:	00005517          	auipc	a0,0x5
    800027d0:	b8c50513          	add	a0,a0,-1140 # 80007358 <states.0+0x58>
    800027d4:	f8bfd0ef          	jal	8000075e <panic>
    if(killed(p))
    800027d8:	907ff0ef          	jal	800020de <killed>
    800027dc:	e121                	bnez	a0,8000281c <usertrap+0x9c>
    p->trapframe->epc += 4;
    800027de:	6cb8                	ld	a4,88(s1)
    800027e0:	6f1c                	ld	a5,24(a4)
    800027e2:	0791                	add	a5,a5,4
    800027e4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027e6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800027ea:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027ee:	10079073          	csrw	sstatus,a5
    syscall();
    800027f2:	248000ef          	jal	80002a3a <syscall>
  if(killed(p))
    800027f6:	8526                	mv	a0,s1
    800027f8:	8e7ff0ef          	jal	800020de <killed>
    800027fc:	c901                	beqz	a0,8000280c <usertrap+0x8c>
    800027fe:	4901                	li	s2,0
    exit(-1);
    80002800:	557d                	li	a0,-1
    80002802:	fb0ff0ef          	jal	80001fb2 <exit>
  if(which_dev == 2)
    80002806:	4789                	li	a5,2
    80002808:	04f90563          	beq	s2,a5,80002852 <usertrap+0xd2>
  usertrapret();
    8000280c:	e1fff0ef          	jal	8000262a <usertrapret>
}
    80002810:	60e2                	ld	ra,24(sp)
    80002812:	6442                	ld	s0,16(sp)
    80002814:	64a2                	ld	s1,8(sp)
    80002816:	6902                	ld	s2,0(sp)
    80002818:	6105                	add	sp,sp,32
    8000281a:	8082                	ret
      exit(-1);
    8000281c:	557d                	li	a0,-1
    8000281e:	f94ff0ef          	jal	80001fb2 <exit>
    80002822:	bf75                	j	800027de <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002824:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002828:	5890                	lw	a2,48(s1)
    8000282a:	00005517          	auipc	a0,0x5
    8000282e:	b4e50513          	add	a0,a0,-1202 # 80007378 <states.0+0x78>
    80002832:	c6dfd0ef          	jal	8000049e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002836:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000283a:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000283e:	00005517          	auipc	a0,0x5
    80002842:	b6a50513          	add	a0,a0,-1174 # 800073a8 <states.0+0xa8>
    80002846:	c59fd0ef          	jal	8000049e <printf>
    setkilled(p);
    8000284a:	8526                	mv	a0,s1
    8000284c:	86fff0ef          	jal	800020ba <setkilled>
    80002850:	b75d                	j	800027f6 <usertrap+0x76>
    yield();
    80002852:	e28ff0ef          	jal	80001e7a <yield>
    80002856:	bf5d                	j	8000280c <usertrap+0x8c>

0000000080002858 <kerneltrap>:
{
    80002858:	7179                	add	sp,sp,-48
    8000285a:	f406                	sd	ra,40(sp)
    8000285c:	f022                	sd	s0,32(sp)
    8000285e:	ec26                	sd	s1,24(sp)
    80002860:	e84a                	sd	s2,16(sp)
    80002862:	e44e                	sd	s3,8(sp)
    80002864:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002866:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000286a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000286e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002872:	1004f793          	and	a5,s1,256
    80002876:	c795                	beqz	a5,800028a2 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002878:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000287c:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    8000287e:	eb85                	bnez	a5,800028ae <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002880:	e91ff0ef          	jal	80002710 <devintr>
    80002884:	c91d                	beqz	a0,800028ba <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002886:	4789                	li	a5,2
    80002888:	04f50a63          	beq	a0,a5,800028dc <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000288c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002890:	10049073          	csrw	sstatus,s1
}
    80002894:	70a2                	ld	ra,40(sp)
    80002896:	7402                	ld	s0,32(sp)
    80002898:	64e2                	ld	s1,24(sp)
    8000289a:	6942                	ld	s2,16(sp)
    8000289c:	69a2                	ld	s3,8(sp)
    8000289e:	6145                	add	sp,sp,48
    800028a0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800028a2:	00005517          	auipc	a0,0x5
    800028a6:	b2e50513          	add	a0,a0,-1234 # 800073d0 <states.0+0xd0>
    800028aa:	eb5fd0ef          	jal	8000075e <panic>
    panic("kerneltrap: interrupts enabled");
    800028ae:	00005517          	auipc	a0,0x5
    800028b2:	b4a50513          	add	a0,a0,-1206 # 800073f8 <states.0+0xf8>
    800028b6:	ea9fd0ef          	jal	8000075e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028ba:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800028be:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800028c2:	85ce                	mv	a1,s3
    800028c4:	00005517          	auipc	a0,0x5
    800028c8:	b5450513          	add	a0,a0,-1196 # 80007418 <states.0+0x118>
    800028cc:	bd3fd0ef          	jal	8000049e <printf>
    panic("kerneltrap");
    800028d0:	00005517          	auipc	a0,0x5
    800028d4:	b7050513          	add	a0,a0,-1168 # 80007440 <states.0+0x140>
    800028d8:	e87fd0ef          	jal	8000075e <panic>
  if(which_dev == 2 && myproc() != 0)
    800028dc:	f55fe0ef          	jal	80001830 <myproc>
    800028e0:	d555                	beqz	a0,8000288c <kerneltrap+0x34>
    yield();
    800028e2:	d98ff0ef          	jal	80001e7a <yield>
    800028e6:	b75d                	j	8000288c <kerneltrap+0x34>

00000000800028e8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800028e8:	1101                	add	sp,sp,-32
    800028ea:	ec06                	sd	ra,24(sp)
    800028ec:	e822                	sd	s0,16(sp)
    800028ee:	e426                	sd	s1,8(sp)
    800028f0:	1000                	add	s0,sp,32
    800028f2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800028f4:	f3dfe0ef          	jal	80001830 <myproc>
  switch (n) {
    800028f8:	4795                	li	a5,5
    800028fa:	0497e163          	bltu	a5,s1,8000293c <argraw+0x54>
    800028fe:	048a                	sll	s1,s1,0x2
    80002900:	00005717          	auipc	a4,0x5
    80002904:	b7870713          	add	a4,a4,-1160 # 80007478 <states.0+0x178>
    80002908:	94ba                	add	s1,s1,a4
    8000290a:	409c                	lw	a5,0(s1)
    8000290c:	97ba                	add	a5,a5,a4
    8000290e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002910:	6d3c                	ld	a5,88(a0)
    80002912:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002914:	60e2                	ld	ra,24(sp)
    80002916:	6442                	ld	s0,16(sp)
    80002918:	64a2                	ld	s1,8(sp)
    8000291a:	6105                	add	sp,sp,32
    8000291c:	8082                	ret
    return p->trapframe->a1;
    8000291e:	6d3c                	ld	a5,88(a0)
    80002920:	7fa8                	ld	a0,120(a5)
    80002922:	bfcd                	j	80002914 <argraw+0x2c>
    return p->trapframe->a2;
    80002924:	6d3c                	ld	a5,88(a0)
    80002926:	63c8                	ld	a0,128(a5)
    80002928:	b7f5                	j	80002914 <argraw+0x2c>
    return p->trapframe->a3;
    8000292a:	6d3c                	ld	a5,88(a0)
    8000292c:	67c8                	ld	a0,136(a5)
    8000292e:	b7dd                	j	80002914 <argraw+0x2c>
    return p->trapframe->a4;
    80002930:	6d3c                	ld	a5,88(a0)
    80002932:	6bc8                	ld	a0,144(a5)
    80002934:	b7c5                	j	80002914 <argraw+0x2c>
    return p->trapframe->a5;
    80002936:	6d3c                	ld	a5,88(a0)
    80002938:	6fc8                	ld	a0,152(a5)
    8000293a:	bfe9                	j	80002914 <argraw+0x2c>
  panic("argraw");
    8000293c:	00005517          	auipc	a0,0x5
    80002940:	b1450513          	add	a0,a0,-1260 # 80007450 <states.0+0x150>
    80002944:	e1bfd0ef          	jal	8000075e <panic>

0000000080002948 <fetchaddr>:
{
    80002948:	1101                	add	sp,sp,-32
    8000294a:	ec06                	sd	ra,24(sp)
    8000294c:	e822                	sd	s0,16(sp)
    8000294e:	e426                	sd	s1,8(sp)
    80002950:	e04a                	sd	s2,0(sp)
    80002952:	1000                	add	s0,sp,32
    80002954:	84aa                	mv	s1,a0
    80002956:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002958:	ed9fe0ef          	jal	80001830 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000295c:	653c                	ld	a5,72(a0)
    8000295e:	02f4f663          	bgeu	s1,a5,8000298a <fetchaddr+0x42>
    80002962:	00848713          	add	a4,s1,8
    80002966:	02e7e463          	bltu	a5,a4,8000298e <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000296a:	46a1                	li	a3,8
    8000296c:	8626                	mv	a2,s1
    8000296e:	85ca                	mv	a1,s2
    80002970:	6928                	ld	a0,80(a0)
    80002972:	c2ffe0ef          	jal	800015a0 <copyin>
    80002976:	00a03533          	snez	a0,a0
    8000297a:	40a00533          	neg	a0,a0
}
    8000297e:	60e2                	ld	ra,24(sp)
    80002980:	6442                	ld	s0,16(sp)
    80002982:	64a2                	ld	s1,8(sp)
    80002984:	6902                	ld	s2,0(sp)
    80002986:	6105                	add	sp,sp,32
    80002988:	8082                	ret
    return -1;
    8000298a:	557d                	li	a0,-1
    8000298c:	bfcd                	j	8000297e <fetchaddr+0x36>
    8000298e:	557d                	li	a0,-1
    80002990:	b7fd                	j	8000297e <fetchaddr+0x36>

0000000080002992 <fetchstr>:
{
    80002992:	7179                	add	sp,sp,-48
    80002994:	f406                	sd	ra,40(sp)
    80002996:	f022                	sd	s0,32(sp)
    80002998:	ec26                	sd	s1,24(sp)
    8000299a:	e84a                	sd	s2,16(sp)
    8000299c:	e44e                	sd	s3,8(sp)
    8000299e:	1800                	add	s0,sp,48
    800029a0:	892a                	mv	s2,a0
    800029a2:	84ae                	mv	s1,a1
    800029a4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800029a6:	e8bfe0ef          	jal	80001830 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800029aa:	86ce                	mv	a3,s3
    800029ac:	864a                	mv	a2,s2
    800029ae:	85a6                	mv	a1,s1
    800029b0:	6928                	ld	a0,80(a0)
    800029b2:	c75fe0ef          	jal	80001626 <copyinstr>
    800029b6:	00054c63          	bltz	a0,800029ce <fetchstr+0x3c>
  return strlen(buf);
    800029ba:	8526                	mv	a0,s1
    800029bc:	c2efe0ef          	jal	80000dea <strlen>
}
    800029c0:	70a2                	ld	ra,40(sp)
    800029c2:	7402                	ld	s0,32(sp)
    800029c4:	64e2                	ld	s1,24(sp)
    800029c6:	6942                	ld	s2,16(sp)
    800029c8:	69a2                	ld	s3,8(sp)
    800029ca:	6145                	add	sp,sp,48
    800029cc:	8082                	ret
    return -1;
    800029ce:	557d                	li	a0,-1
    800029d0:	bfc5                	j	800029c0 <fetchstr+0x2e>

00000000800029d2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800029d2:	1101                	add	sp,sp,-32
    800029d4:	ec06                	sd	ra,24(sp)
    800029d6:	e822                	sd	s0,16(sp)
    800029d8:	e426                	sd	s1,8(sp)
    800029da:	1000                	add	s0,sp,32
    800029dc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800029de:	f0bff0ef          	jal	800028e8 <argraw>
    800029e2:	c088                	sw	a0,0(s1)
}
    800029e4:	60e2                	ld	ra,24(sp)
    800029e6:	6442                	ld	s0,16(sp)
    800029e8:	64a2                	ld	s1,8(sp)
    800029ea:	6105                	add	sp,sp,32
    800029ec:	8082                	ret

00000000800029ee <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800029ee:	1101                	add	sp,sp,-32
    800029f0:	ec06                	sd	ra,24(sp)
    800029f2:	e822                	sd	s0,16(sp)
    800029f4:	e426                	sd	s1,8(sp)
    800029f6:	1000                	add	s0,sp,32
    800029f8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800029fa:	eefff0ef          	jal	800028e8 <argraw>
    800029fe:	e088                	sd	a0,0(s1)
}
    80002a00:	60e2                	ld	ra,24(sp)
    80002a02:	6442                	ld	s0,16(sp)
    80002a04:	64a2                	ld	s1,8(sp)
    80002a06:	6105                	add	sp,sp,32
    80002a08:	8082                	ret

0000000080002a0a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002a0a:	7179                	add	sp,sp,-48
    80002a0c:	f406                	sd	ra,40(sp)
    80002a0e:	f022                	sd	s0,32(sp)
    80002a10:	ec26                	sd	s1,24(sp)
    80002a12:	e84a                	sd	s2,16(sp)
    80002a14:	1800                	add	s0,sp,48
    80002a16:	84ae                	mv	s1,a1
    80002a18:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002a1a:	fd840593          	add	a1,s0,-40
    80002a1e:	fd1ff0ef          	jal	800029ee <argaddr>
  return fetchstr(addr, buf, max);
    80002a22:	864a                	mv	a2,s2
    80002a24:	85a6                	mv	a1,s1
    80002a26:	fd843503          	ld	a0,-40(s0)
    80002a2a:	f69ff0ef          	jal	80002992 <fetchstr>
}
    80002a2e:	70a2                	ld	ra,40(sp)
    80002a30:	7402                	ld	s0,32(sp)
    80002a32:	64e2                	ld	s1,24(sp)
    80002a34:	6942                	ld	s2,16(sp)
    80002a36:	6145                	add	sp,sp,48
    80002a38:	8082                	ret

0000000080002a3a <syscall>:
[SYS_set_type] sys_set_type
};

void
syscall(void)
{
    80002a3a:	1101                	add	sp,sp,-32
    80002a3c:	ec06                	sd	ra,24(sp)
    80002a3e:	e822                	sd	s0,16(sp)
    80002a40:	e426                	sd	s1,8(sp)
    80002a42:	e04a                	sd	s2,0(sp)
    80002a44:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002a46:	debfe0ef          	jal	80001830 <myproc>
    80002a4a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002a4c:	05853903          	ld	s2,88(a0)
    80002a50:	0a893783          	ld	a5,168(s2)
    80002a54:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002a58:	37fd                	addw	a5,a5,-1
    80002a5a:	4775                	li	a4,29
    80002a5c:	00f76f63          	bltu	a4,a5,80002a7a <syscall+0x40>
    80002a60:	00369713          	sll	a4,a3,0x3
    80002a64:	00005797          	auipc	a5,0x5
    80002a68:	a2c78793          	add	a5,a5,-1492 # 80007490 <syscalls>
    80002a6c:	97ba                	add	a5,a5,a4
    80002a6e:	639c                	ld	a5,0(a5)
    80002a70:	c789                	beqz	a5,80002a7a <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002a72:	9782                	jalr	a5
    80002a74:	06a93823          	sd	a0,112(s2)
    80002a78:	a829                	j	80002a92 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002a7a:	15848613          	add	a2,s1,344
    80002a7e:	588c                	lw	a1,48(s1)
    80002a80:	00005517          	auipc	a0,0x5
    80002a84:	9d850513          	add	a0,a0,-1576 # 80007458 <states.0+0x158>
    80002a88:	a17fd0ef          	jal	8000049e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002a8c:	6cbc                	ld	a5,88(s1)
    80002a8e:	577d                	li	a4,-1
    80002a90:	fbb8                	sd	a4,112(a5)
  }
}
    80002a92:	60e2                	ld	ra,24(sp)
    80002a94:	6442                	ld	s0,16(sp)
    80002a96:	64a2                	ld	s1,8(sp)
    80002a98:	6902                	ld	s2,0(sp)
    80002a9a:	6105                	add	sp,sp,32
    80002a9c:	8082                	ret

0000000080002a9e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002a9e:	1101                	add	sp,sp,-32
    80002aa0:	ec06                	sd	ra,24(sp)
    80002aa2:	e822                	sd	s0,16(sp)
    80002aa4:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    80002aa6:	fec40593          	add	a1,s0,-20
    80002aaa:	4501                	li	a0,0
    80002aac:	f27ff0ef          	jal	800029d2 <argint>
  exit(n);
    80002ab0:	fec42503          	lw	a0,-20(s0)
    80002ab4:	cfeff0ef          	jal	80001fb2 <exit>
  return 0;  // not reached
}
    80002ab8:	4501                	li	a0,0
    80002aba:	60e2                	ld	ra,24(sp)
    80002abc:	6442                	ld	s0,16(sp)
    80002abe:	6105                	add	sp,sp,32
    80002ac0:	8082                	ret

0000000080002ac2 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002ac2:	1141                	add	sp,sp,-16
    80002ac4:	e406                	sd	ra,8(sp)
    80002ac6:	e022                	sd	s0,0(sp)
    80002ac8:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002aca:	d67fe0ef          	jal	80001830 <myproc>
}
    80002ace:	5908                	lw	a0,48(a0)
    80002ad0:	60a2                	ld	ra,8(sp)
    80002ad2:	6402                	ld	s0,0(sp)
    80002ad4:	0141                	add	sp,sp,16
    80002ad6:	8082                	ret

0000000080002ad8 <sys_fork>:

uint64
sys_fork(void)
{
    80002ad8:	1141                	add	sp,sp,-16
    80002ada:	e406                	sd	ra,8(sp)
    80002adc:	e022                	sd	s0,0(sp)
    80002ade:	0800                	add	s0,sp,16
  return fork();
    80002ae0:	886ff0ef          	jal	80001b66 <fork>
}
    80002ae4:	60a2                	ld	ra,8(sp)
    80002ae6:	6402                	ld	s0,0(sp)
    80002ae8:	0141                	add	sp,sp,16
    80002aea:	8082                	ret

0000000080002aec <sys_wait>:

uint64
sys_wait(void)
{
    80002aec:	1101                	add	sp,sp,-32
    80002aee:	ec06                	sd	ra,24(sp)
    80002af0:	e822                	sd	s0,16(sp)
    80002af2:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002af4:	fe840593          	add	a1,s0,-24
    80002af8:	4501                	li	a0,0
    80002afa:	ef5ff0ef          	jal	800029ee <argaddr>
  return wait(p);
    80002afe:	fe843503          	ld	a0,-24(s0)
    80002b02:	e06ff0ef          	jal	80002108 <wait>
}
    80002b06:	60e2                	ld	ra,24(sp)
    80002b08:	6442                	ld	s0,16(sp)
    80002b0a:	6105                	add	sp,sp,32
    80002b0c:	8082                	ret

0000000080002b0e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002b0e:	7179                	add	sp,sp,-48
    80002b10:	f406                	sd	ra,40(sp)
    80002b12:	f022                	sd	s0,32(sp)
    80002b14:	ec26                	sd	s1,24(sp)
    80002b16:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002b18:	fdc40593          	add	a1,s0,-36
    80002b1c:	4501                	li	a0,0
    80002b1e:	eb5ff0ef          	jal	800029d2 <argint>
  addr = myproc()->sz;
    80002b22:	d0ffe0ef          	jal	80001830 <myproc>
    80002b26:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002b28:	fdc42503          	lw	a0,-36(s0)
    80002b2c:	febfe0ef          	jal	80001b16 <growproc>
    80002b30:	00054863          	bltz	a0,80002b40 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002b34:	8526                	mv	a0,s1
    80002b36:	70a2                	ld	ra,40(sp)
    80002b38:	7402                	ld	s0,32(sp)
    80002b3a:	64e2                	ld	s1,24(sp)
    80002b3c:	6145                	add	sp,sp,48
    80002b3e:	8082                	ret
    return -1;
    80002b40:	54fd                	li	s1,-1
    80002b42:	bfcd                	j	80002b34 <sys_sbrk+0x26>

0000000080002b44 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002b44:	7139                	add	sp,sp,-64
    80002b46:	fc06                	sd	ra,56(sp)
    80002b48:	f822                	sd	s0,48(sp)
    80002b4a:	f426                	sd	s1,40(sp)
    80002b4c:	f04a                	sd	s2,32(sp)
    80002b4e:	ec4e                	sd	s3,24(sp)
    80002b50:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002b52:	fcc40593          	add	a1,s0,-52
    80002b56:	4501                	li	a0,0
    80002b58:	e7bff0ef          	jal	800029d2 <argint>
  if(n < 0)
    80002b5c:	fcc42783          	lw	a5,-52(s0)
    80002b60:	0607c563          	bltz	a5,80002bca <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002b64:	00025517          	auipc	a0,0x25
    80002b68:	c5c50513          	add	a0,a0,-932 # 800277c0 <tickslock>
    80002b6c:	834fe0ef          	jal	80000ba0 <acquire>
  ticks0 = ticks;
    80002b70:	00005917          	auipc	s2,0x5
    80002b74:	e0092903          	lw	s2,-512(s2) # 80007970 <ticks>
  while(ticks - ticks0 < n){
    80002b78:	fcc42783          	lw	a5,-52(s0)
    80002b7c:	cb8d                	beqz	a5,80002bae <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002b7e:	00025997          	auipc	s3,0x25
    80002b82:	c4298993          	add	s3,s3,-958 # 800277c0 <tickslock>
    80002b86:	00005497          	auipc	s1,0x5
    80002b8a:	dea48493          	add	s1,s1,-534 # 80007970 <ticks>
    if(killed(myproc())){
    80002b8e:	ca3fe0ef          	jal	80001830 <myproc>
    80002b92:	d4cff0ef          	jal	800020de <killed>
    80002b96:	ed0d                	bnez	a0,80002bd0 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002b98:	85ce                	mv	a1,s3
    80002b9a:	8526                	mv	a0,s1
    80002b9c:	b0aff0ef          	jal	80001ea6 <sleep>
  while(ticks - ticks0 < n){
    80002ba0:	409c                	lw	a5,0(s1)
    80002ba2:	412787bb          	subw	a5,a5,s2
    80002ba6:	fcc42703          	lw	a4,-52(s0)
    80002baa:	fee7e2e3          	bltu	a5,a4,80002b8e <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002bae:	00025517          	auipc	a0,0x25
    80002bb2:	c1250513          	add	a0,a0,-1006 # 800277c0 <tickslock>
    80002bb6:	882fe0ef          	jal	80000c38 <release>
  return 0;
    80002bba:	4501                	li	a0,0
}
    80002bbc:	70e2                	ld	ra,56(sp)
    80002bbe:	7442                	ld	s0,48(sp)
    80002bc0:	74a2                	ld	s1,40(sp)
    80002bc2:	7902                	ld	s2,32(sp)
    80002bc4:	69e2                	ld	s3,24(sp)
    80002bc6:	6121                	add	sp,sp,64
    80002bc8:	8082                	ret
    n = 0;
    80002bca:	fc042623          	sw	zero,-52(s0)
    80002bce:	bf59                	j	80002b64 <sys_sleep+0x20>
      release(&tickslock);
    80002bd0:	00025517          	auipc	a0,0x25
    80002bd4:	bf050513          	add	a0,a0,-1040 # 800277c0 <tickslock>
    80002bd8:	860fe0ef          	jal	80000c38 <release>
      return -1;
    80002bdc:	557d                	li	a0,-1
    80002bde:	bff9                	j	80002bbc <sys_sleep+0x78>

0000000080002be0 <sys_kill>:

uint64
sys_kill(void)
{
    80002be0:	1101                	add	sp,sp,-32
    80002be2:	ec06                	sd	ra,24(sp)
    80002be4:	e822                	sd	s0,16(sp)
    80002be6:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002be8:	fec40593          	add	a1,s0,-20
    80002bec:	4501                	li	a0,0
    80002bee:	de5ff0ef          	jal	800029d2 <argint>
  return kill(pid);
    80002bf2:	fec42503          	lw	a0,-20(s0)
    80002bf6:	c5eff0ef          	jal	80002054 <kill>
}
    80002bfa:	60e2                	ld	ra,24(sp)
    80002bfc:	6442                	ld	s0,16(sp)
    80002bfe:	6105                	add	sp,sp,32
    80002c00:	8082                	ret

0000000080002c02 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002c02:	1101                	add	sp,sp,-32
    80002c04:	ec06                	sd	ra,24(sp)
    80002c06:	e822                	sd	s0,16(sp)
    80002c08:	e426                	sd	s1,8(sp)
    80002c0a:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002c0c:	00025517          	auipc	a0,0x25
    80002c10:	bb450513          	add	a0,a0,-1100 # 800277c0 <tickslock>
    80002c14:	f8dfd0ef          	jal	80000ba0 <acquire>
  xticks = ticks;
    80002c18:	00005497          	auipc	s1,0x5
    80002c1c:	d584a483          	lw	s1,-680(s1) # 80007970 <ticks>
  release(&tickslock);
    80002c20:	00025517          	auipc	a0,0x25
    80002c24:	ba050513          	add	a0,a0,-1120 # 800277c0 <tickslock>
    80002c28:	810fe0ef          	jal	80000c38 <release>
  return xticks;
}
    80002c2c:	02049513          	sll	a0,s1,0x20
    80002c30:	9101                	srl	a0,a0,0x20
    80002c32:	60e2                	ld	ra,24(sp)
    80002c34:	6442                	ld	s0,16(sp)
    80002c36:	64a2                	ld	s1,8(sp)
    80002c38:	6105                	add	sp,sp,32
    80002c3a:	8082                	ret

0000000080002c3c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002c3c:	7179                	add	sp,sp,-48
    80002c3e:	f406                	sd	ra,40(sp)
    80002c40:	f022                	sd	s0,32(sp)
    80002c42:	ec26                	sd	s1,24(sp)
    80002c44:	e84a                	sd	s2,16(sp)
    80002c46:	e44e                	sd	s3,8(sp)
    80002c48:	e052                	sd	s4,0(sp)
    80002c4a:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002c4c:	00005597          	auipc	a1,0x5
    80002c50:	93c58593          	add	a1,a1,-1732 # 80007588 <syscalls+0xf8>
    80002c54:	00025517          	auipc	a0,0x25
    80002c58:	b8450513          	add	a0,a0,-1148 # 800277d8 <bcache>
    80002c5c:	ec5fd0ef          	jal	80000b20 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002c60:	0002d797          	auipc	a5,0x2d
    80002c64:	b7878793          	add	a5,a5,-1160 # 8002f7d8 <bcache+0x8000>
    80002c68:	0002d717          	auipc	a4,0x2d
    80002c6c:	dd870713          	add	a4,a4,-552 # 8002fa40 <bcache+0x8268>
    80002c70:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002c74:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c78:	00025497          	auipc	s1,0x25
    80002c7c:	b7848493          	add	s1,s1,-1160 # 800277f0 <bcache+0x18>
    b->next = bcache.head.next;
    80002c80:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002c82:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002c84:	00005a17          	auipc	s4,0x5
    80002c88:	90ca0a13          	add	s4,s4,-1780 # 80007590 <syscalls+0x100>
    b->next = bcache.head.next;
    80002c8c:	2b893783          	ld	a5,696(s2)
    80002c90:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002c92:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002c96:	85d2                	mv	a1,s4
    80002c98:	01048513          	add	a0,s1,16
    80002c9c:	1f6010ef          	jal	80003e92 <initsleeplock>
    bcache.head.next->prev = b;
    80002ca0:	2b893783          	ld	a5,696(s2)
    80002ca4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002ca6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002caa:	45848493          	add	s1,s1,1112
    80002cae:	fd349fe3          	bne	s1,s3,80002c8c <binit+0x50>
  }
}
    80002cb2:	70a2                	ld	ra,40(sp)
    80002cb4:	7402                	ld	s0,32(sp)
    80002cb6:	64e2                	ld	s1,24(sp)
    80002cb8:	6942                	ld	s2,16(sp)
    80002cba:	69a2                	ld	s3,8(sp)
    80002cbc:	6a02                	ld	s4,0(sp)
    80002cbe:	6145                	add	sp,sp,48
    80002cc0:	8082                	ret

0000000080002cc2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002cc2:	7179                	add	sp,sp,-48
    80002cc4:	f406                	sd	ra,40(sp)
    80002cc6:	f022                	sd	s0,32(sp)
    80002cc8:	ec26                	sd	s1,24(sp)
    80002cca:	e84a                	sd	s2,16(sp)
    80002ccc:	e44e                	sd	s3,8(sp)
    80002cce:	1800                	add	s0,sp,48
    80002cd0:	892a                	mv	s2,a0
    80002cd2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002cd4:	00025517          	auipc	a0,0x25
    80002cd8:	b0450513          	add	a0,a0,-1276 # 800277d8 <bcache>
    80002cdc:	ec5fd0ef          	jal	80000ba0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002ce0:	0002d497          	auipc	s1,0x2d
    80002ce4:	db04b483          	ld	s1,-592(s1) # 8002fa90 <bcache+0x82b8>
    80002ce8:	0002d797          	auipc	a5,0x2d
    80002cec:	d5878793          	add	a5,a5,-680 # 8002fa40 <bcache+0x8268>
    80002cf0:	02f48b63          	beq	s1,a5,80002d26 <bread+0x64>
    80002cf4:	873e                	mv	a4,a5
    80002cf6:	a021                	j	80002cfe <bread+0x3c>
    80002cf8:	68a4                	ld	s1,80(s1)
    80002cfa:	02e48663          	beq	s1,a4,80002d26 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002cfe:	449c                	lw	a5,8(s1)
    80002d00:	ff279ce3          	bne	a5,s2,80002cf8 <bread+0x36>
    80002d04:	44dc                	lw	a5,12(s1)
    80002d06:	ff3799e3          	bne	a5,s3,80002cf8 <bread+0x36>
      b->refcnt++;
    80002d0a:	40bc                	lw	a5,64(s1)
    80002d0c:	2785                	addw	a5,a5,1
    80002d0e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d10:	00025517          	auipc	a0,0x25
    80002d14:	ac850513          	add	a0,a0,-1336 # 800277d8 <bcache>
    80002d18:	f21fd0ef          	jal	80000c38 <release>
      acquiresleep(&b->lock);
    80002d1c:	01048513          	add	a0,s1,16
    80002d20:	1a8010ef          	jal	80003ec8 <acquiresleep>
      return b;
    80002d24:	a889                	j	80002d76 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d26:	0002d497          	auipc	s1,0x2d
    80002d2a:	d624b483          	ld	s1,-670(s1) # 8002fa88 <bcache+0x82b0>
    80002d2e:	0002d797          	auipc	a5,0x2d
    80002d32:	d1278793          	add	a5,a5,-750 # 8002fa40 <bcache+0x8268>
    80002d36:	00f48863          	beq	s1,a5,80002d46 <bread+0x84>
    80002d3a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002d3c:	40bc                	lw	a5,64(s1)
    80002d3e:	cb91                	beqz	a5,80002d52 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d40:	64a4                	ld	s1,72(s1)
    80002d42:	fee49de3          	bne	s1,a4,80002d3c <bread+0x7a>
  panic("bget: no buffers");
    80002d46:	00005517          	auipc	a0,0x5
    80002d4a:	85250513          	add	a0,a0,-1966 # 80007598 <syscalls+0x108>
    80002d4e:	a11fd0ef          	jal	8000075e <panic>
      b->dev = dev;
    80002d52:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002d56:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002d5a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002d5e:	4785                	li	a5,1
    80002d60:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d62:	00025517          	auipc	a0,0x25
    80002d66:	a7650513          	add	a0,a0,-1418 # 800277d8 <bcache>
    80002d6a:	ecffd0ef          	jal	80000c38 <release>
      acquiresleep(&b->lock);
    80002d6e:	01048513          	add	a0,s1,16
    80002d72:	156010ef          	jal	80003ec8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002d76:	409c                	lw	a5,0(s1)
    80002d78:	cb89                	beqz	a5,80002d8a <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002d7a:	8526                	mv	a0,s1
    80002d7c:	70a2                	ld	ra,40(sp)
    80002d7e:	7402                	ld	s0,32(sp)
    80002d80:	64e2                	ld	s1,24(sp)
    80002d82:	6942                	ld	s2,16(sp)
    80002d84:	69a2                	ld	s3,8(sp)
    80002d86:	6145                	add	sp,sp,48
    80002d88:	8082                	ret
    virtio_disk_rw(b, 0);
    80002d8a:	4581                	li	a1,0
    80002d8c:	8526                	mv	a0,s1
    80002d8e:	07d020ef          	jal	8000560a <virtio_disk_rw>
    b->valid = 1;
    80002d92:	4785                	li	a5,1
    80002d94:	c09c                	sw	a5,0(s1)
  return b;
    80002d96:	b7d5                	j	80002d7a <bread+0xb8>

0000000080002d98 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002d98:	1101                	add	sp,sp,-32
    80002d9a:	ec06                	sd	ra,24(sp)
    80002d9c:	e822                	sd	s0,16(sp)
    80002d9e:	e426                	sd	s1,8(sp)
    80002da0:	1000                	add	s0,sp,32
    80002da2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002da4:	0541                	add	a0,a0,16
    80002da6:	1a0010ef          	jal	80003f46 <holdingsleep>
    80002daa:	c911                	beqz	a0,80002dbe <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002dac:	4585                	li	a1,1
    80002dae:	8526                	mv	a0,s1
    80002db0:	05b020ef          	jal	8000560a <virtio_disk_rw>
}
    80002db4:	60e2                	ld	ra,24(sp)
    80002db6:	6442                	ld	s0,16(sp)
    80002db8:	64a2                	ld	s1,8(sp)
    80002dba:	6105                	add	sp,sp,32
    80002dbc:	8082                	ret
    panic("bwrite");
    80002dbe:	00004517          	auipc	a0,0x4
    80002dc2:	7f250513          	add	a0,a0,2034 # 800075b0 <syscalls+0x120>
    80002dc6:	999fd0ef          	jal	8000075e <panic>

0000000080002dca <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002dca:	1101                	add	sp,sp,-32
    80002dcc:	ec06                	sd	ra,24(sp)
    80002dce:	e822                	sd	s0,16(sp)
    80002dd0:	e426                	sd	s1,8(sp)
    80002dd2:	e04a                	sd	s2,0(sp)
    80002dd4:	1000                	add	s0,sp,32
    80002dd6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002dd8:	01050913          	add	s2,a0,16
    80002ddc:	854a                	mv	a0,s2
    80002dde:	168010ef          	jal	80003f46 <holdingsleep>
    80002de2:	c135                	beqz	a0,80002e46 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002de4:	854a                	mv	a0,s2
    80002de6:	128010ef          	jal	80003f0e <releasesleep>

  acquire(&bcache.lock);
    80002dea:	00025517          	auipc	a0,0x25
    80002dee:	9ee50513          	add	a0,a0,-1554 # 800277d8 <bcache>
    80002df2:	daffd0ef          	jal	80000ba0 <acquire>
  b->refcnt--;
    80002df6:	40bc                	lw	a5,64(s1)
    80002df8:	37fd                	addw	a5,a5,-1
    80002dfa:	0007871b          	sext.w	a4,a5
    80002dfe:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002e00:	e71d                	bnez	a4,80002e2e <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002e02:	68b8                	ld	a4,80(s1)
    80002e04:	64bc                	ld	a5,72(s1)
    80002e06:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002e08:	68b8                	ld	a4,80(s1)
    80002e0a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002e0c:	0002d797          	auipc	a5,0x2d
    80002e10:	9cc78793          	add	a5,a5,-1588 # 8002f7d8 <bcache+0x8000>
    80002e14:	2b87b703          	ld	a4,696(a5)
    80002e18:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002e1a:	0002d717          	auipc	a4,0x2d
    80002e1e:	c2670713          	add	a4,a4,-986 # 8002fa40 <bcache+0x8268>
    80002e22:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002e24:	2b87b703          	ld	a4,696(a5)
    80002e28:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002e2a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002e2e:	00025517          	auipc	a0,0x25
    80002e32:	9aa50513          	add	a0,a0,-1622 # 800277d8 <bcache>
    80002e36:	e03fd0ef          	jal	80000c38 <release>
}
    80002e3a:	60e2                	ld	ra,24(sp)
    80002e3c:	6442                	ld	s0,16(sp)
    80002e3e:	64a2                	ld	s1,8(sp)
    80002e40:	6902                	ld	s2,0(sp)
    80002e42:	6105                	add	sp,sp,32
    80002e44:	8082                	ret
    panic("brelse");
    80002e46:	00004517          	auipc	a0,0x4
    80002e4a:	77250513          	add	a0,a0,1906 # 800075b8 <syscalls+0x128>
    80002e4e:	911fd0ef          	jal	8000075e <panic>

0000000080002e52 <bpin>:

void
bpin(struct buf *b) {
    80002e52:	1101                	add	sp,sp,-32
    80002e54:	ec06                	sd	ra,24(sp)
    80002e56:	e822                	sd	s0,16(sp)
    80002e58:	e426                	sd	s1,8(sp)
    80002e5a:	1000                	add	s0,sp,32
    80002e5c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e5e:	00025517          	auipc	a0,0x25
    80002e62:	97a50513          	add	a0,a0,-1670 # 800277d8 <bcache>
    80002e66:	d3bfd0ef          	jal	80000ba0 <acquire>
  b->refcnt++;
    80002e6a:	40bc                	lw	a5,64(s1)
    80002e6c:	2785                	addw	a5,a5,1
    80002e6e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e70:	00025517          	auipc	a0,0x25
    80002e74:	96850513          	add	a0,a0,-1688 # 800277d8 <bcache>
    80002e78:	dc1fd0ef          	jal	80000c38 <release>
}
    80002e7c:	60e2                	ld	ra,24(sp)
    80002e7e:	6442                	ld	s0,16(sp)
    80002e80:	64a2                	ld	s1,8(sp)
    80002e82:	6105                	add	sp,sp,32
    80002e84:	8082                	ret

0000000080002e86 <bunpin>:

void
bunpin(struct buf *b) {
    80002e86:	1101                	add	sp,sp,-32
    80002e88:	ec06                	sd	ra,24(sp)
    80002e8a:	e822                	sd	s0,16(sp)
    80002e8c:	e426                	sd	s1,8(sp)
    80002e8e:	1000                	add	s0,sp,32
    80002e90:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e92:	00025517          	auipc	a0,0x25
    80002e96:	94650513          	add	a0,a0,-1722 # 800277d8 <bcache>
    80002e9a:	d07fd0ef          	jal	80000ba0 <acquire>
  b->refcnt--;
    80002e9e:	40bc                	lw	a5,64(s1)
    80002ea0:	37fd                	addw	a5,a5,-1
    80002ea2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ea4:	00025517          	auipc	a0,0x25
    80002ea8:	93450513          	add	a0,a0,-1740 # 800277d8 <bcache>
    80002eac:	d8dfd0ef          	jal	80000c38 <release>
}
    80002eb0:	60e2                	ld	ra,24(sp)
    80002eb2:	6442                	ld	s0,16(sp)
    80002eb4:	64a2                	ld	s1,8(sp)
    80002eb6:	6105                	add	sp,sp,32
    80002eb8:	8082                	ret

0000000080002eba <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002eba:	1101                	add	sp,sp,-32
    80002ebc:	ec06                	sd	ra,24(sp)
    80002ebe:	e822                	sd	s0,16(sp)
    80002ec0:	e426                	sd	s1,8(sp)
    80002ec2:	e04a                	sd	s2,0(sp)
    80002ec4:	1000                	add	s0,sp,32
    80002ec6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002ec8:	00d5d59b          	srlw	a1,a1,0xd
    80002ecc:	0002d797          	auipc	a5,0x2d
    80002ed0:	fe87a783          	lw	a5,-24(a5) # 8002feb4 <sb+0x1c>
    80002ed4:	9dbd                	addw	a1,a1,a5
    80002ed6:	dedff0ef          	jal	80002cc2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002eda:	0074f713          	and	a4,s1,7
    80002ede:	4785                	li	a5,1
    80002ee0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002ee4:	14ce                	sll	s1,s1,0x33
    80002ee6:	90d9                	srl	s1,s1,0x36
    80002ee8:	00950733          	add	a4,a0,s1
    80002eec:	05874703          	lbu	a4,88(a4)
    80002ef0:	00e7f6b3          	and	a3,a5,a4
    80002ef4:	c29d                	beqz	a3,80002f1a <bfree+0x60>
    80002ef6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002ef8:	94aa                	add	s1,s1,a0
    80002efa:	fff7c793          	not	a5,a5
    80002efe:	8f7d                	and	a4,a4,a5
    80002f00:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002f04:	6bf000ef          	jal	80003dc2 <log_write>
  brelse(bp);
    80002f08:	854a                	mv	a0,s2
    80002f0a:	ec1ff0ef          	jal	80002dca <brelse>
}
    80002f0e:	60e2                	ld	ra,24(sp)
    80002f10:	6442                	ld	s0,16(sp)
    80002f12:	64a2                	ld	s1,8(sp)
    80002f14:	6902                	ld	s2,0(sp)
    80002f16:	6105                	add	sp,sp,32
    80002f18:	8082                	ret
    panic("freeing free block");
    80002f1a:	00004517          	auipc	a0,0x4
    80002f1e:	6a650513          	add	a0,a0,1702 # 800075c0 <syscalls+0x130>
    80002f22:	83dfd0ef          	jal	8000075e <panic>

0000000080002f26 <balloc>:
{
    80002f26:	711d                	add	sp,sp,-96
    80002f28:	ec86                	sd	ra,88(sp)
    80002f2a:	e8a2                	sd	s0,80(sp)
    80002f2c:	e4a6                	sd	s1,72(sp)
    80002f2e:	e0ca                	sd	s2,64(sp)
    80002f30:	fc4e                	sd	s3,56(sp)
    80002f32:	f852                	sd	s4,48(sp)
    80002f34:	f456                	sd	s5,40(sp)
    80002f36:	f05a                	sd	s6,32(sp)
    80002f38:	ec5e                	sd	s7,24(sp)
    80002f3a:	e862                	sd	s8,16(sp)
    80002f3c:	e466                	sd	s9,8(sp)
    80002f3e:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002f40:	0002d797          	auipc	a5,0x2d
    80002f44:	f5c7a783          	lw	a5,-164(a5) # 8002fe9c <sb+0x4>
    80002f48:	cff1                	beqz	a5,80003024 <balloc+0xfe>
    80002f4a:	8baa                	mv	s7,a0
    80002f4c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002f4e:	0002db17          	auipc	s6,0x2d
    80002f52:	f4ab0b13          	add	s6,s6,-182 # 8002fe98 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f56:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002f58:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f5a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002f5c:	6c89                	lui	s9,0x2
    80002f5e:	a0b5                	j	80002fca <balloc+0xa4>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002f60:	97ca                	add	a5,a5,s2
    80002f62:	8e55                	or	a2,a2,a3
    80002f64:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002f68:	854a                	mv	a0,s2
    80002f6a:	659000ef          	jal	80003dc2 <log_write>
        brelse(bp);
    80002f6e:	854a                	mv	a0,s2
    80002f70:	e5bff0ef          	jal	80002dca <brelse>
  bp = bread(dev, bno);
    80002f74:	85a6                	mv	a1,s1
    80002f76:	855e                	mv	a0,s7
    80002f78:	d4bff0ef          	jal	80002cc2 <bread>
    80002f7c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002f7e:	40000613          	li	a2,1024
    80002f82:	4581                	li	a1,0
    80002f84:	05850513          	add	a0,a0,88
    80002f88:	cedfd0ef          	jal	80000c74 <memset>
  log_write(bp);
    80002f8c:	854a                	mv	a0,s2
    80002f8e:	635000ef          	jal	80003dc2 <log_write>
  brelse(bp);
    80002f92:	854a                	mv	a0,s2
    80002f94:	e37ff0ef          	jal	80002dca <brelse>
}
    80002f98:	8526                	mv	a0,s1
    80002f9a:	60e6                	ld	ra,88(sp)
    80002f9c:	6446                	ld	s0,80(sp)
    80002f9e:	64a6                	ld	s1,72(sp)
    80002fa0:	6906                	ld	s2,64(sp)
    80002fa2:	79e2                	ld	s3,56(sp)
    80002fa4:	7a42                	ld	s4,48(sp)
    80002fa6:	7aa2                	ld	s5,40(sp)
    80002fa8:	7b02                	ld	s6,32(sp)
    80002faa:	6be2                	ld	s7,24(sp)
    80002fac:	6c42                	ld	s8,16(sp)
    80002fae:	6ca2                	ld	s9,8(sp)
    80002fb0:	6125                	add	sp,sp,96
    80002fb2:	8082                	ret
    brelse(bp);
    80002fb4:	854a                	mv	a0,s2
    80002fb6:	e15ff0ef          	jal	80002dca <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002fba:	015c87bb          	addw	a5,s9,s5
    80002fbe:	00078a9b          	sext.w	s5,a5
    80002fc2:	004b2703          	lw	a4,4(s6)
    80002fc6:	04eaff63          	bgeu	s5,a4,80003024 <balloc+0xfe>
    bp = bread(dev, BBLOCK(b, sb));
    80002fca:	41fad79b          	sraw	a5,s5,0x1f
    80002fce:	0137d79b          	srlw	a5,a5,0x13
    80002fd2:	015787bb          	addw	a5,a5,s5
    80002fd6:	40d7d79b          	sraw	a5,a5,0xd
    80002fda:	01cb2583          	lw	a1,28(s6)
    80002fde:	9dbd                	addw	a1,a1,a5
    80002fe0:	855e                	mv	a0,s7
    80002fe2:	ce1ff0ef          	jal	80002cc2 <bread>
    80002fe6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fe8:	004b2503          	lw	a0,4(s6)
    80002fec:	000a849b          	sext.w	s1,s5
    80002ff0:	8762                	mv	a4,s8
    80002ff2:	fca4f1e3          	bgeu	s1,a0,80002fb4 <balloc+0x8e>
      m = 1 << (bi % 8);
    80002ff6:	00777693          	and	a3,a4,7
    80002ffa:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002ffe:	41f7579b          	sraw	a5,a4,0x1f
    80003002:	01d7d79b          	srlw	a5,a5,0x1d
    80003006:	9fb9                	addw	a5,a5,a4
    80003008:	4037d79b          	sraw	a5,a5,0x3
    8000300c:	00f90633          	add	a2,s2,a5
    80003010:	05864603          	lbu	a2,88(a2)
    80003014:	00c6f5b3          	and	a1,a3,a2
    80003018:	d5a1                	beqz	a1,80002f60 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000301a:	2705                	addw	a4,a4,1
    8000301c:	2485                	addw	s1,s1,1
    8000301e:	fd471ae3          	bne	a4,s4,80002ff2 <balloc+0xcc>
    80003022:	bf49                	j	80002fb4 <balloc+0x8e>
  printf("balloc: out of blocks\n");
    80003024:	00004517          	auipc	a0,0x4
    80003028:	5b450513          	add	a0,a0,1460 # 800075d8 <syscalls+0x148>
    8000302c:	c72fd0ef          	jal	8000049e <printf>
  return 0;
    80003030:	4481                	li	s1,0
    80003032:	b79d                	j	80002f98 <balloc+0x72>

0000000080003034 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003034:	7179                	add	sp,sp,-48
    80003036:	f406                	sd	ra,40(sp)
    80003038:	f022                	sd	s0,32(sp)
    8000303a:	ec26                	sd	s1,24(sp)
    8000303c:	e84a                	sd	s2,16(sp)
    8000303e:	e44e                	sd	s3,8(sp)
    80003040:	e052                	sd	s4,0(sp)
    80003042:	1800                	add	s0,sp,48
    80003044:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003046:	47ad                	li	a5,11
    80003048:	02b7e663          	bltu	a5,a1,80003074 <bmap+0x40>
    if((addr = ip->addrs[bn]) == 0){
    8000304c:	02059793          	sll	a5,a1,0x20
    80003050:	01e7d593          	srl	a1,a5,0x1e
    80003054:	00b504b3          	add	s1,a0,a1
    80003058:	0504a903          	lw	s2,80(s1)
    8000305c:	06091663          	bnez	s2,800030c8 <bmap+0x94>
      addr = balloc(ip->dev);
    80003060:	4108                	lw	a0,0(a0)
    80003062:	ec5ff0ef          	jal	80002f26 <balloc>
    80003066:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000306a:	04090f63          	beqz	s2,800030c8 <bmap+0x94>
        return 0;
      ip->addrs[bn] = addr;
    8000306e:	0524a823          	sw	s2,80(s1)
    80003072:	a899                	j	800030c8 <bmap+0x94>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003074:	ff45849b          	addw	s1,a1,-12
    80003078:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000307c:	0ff00793          	li	a5,255
    80003080:	06e7eb63          	bltu	a5,a4,800030f6 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003084:	08052903          	lw	s2,128(a0)
    80003088:	00091b63          	bnez	s2,8000309e <bmap+0x6a>
      addr = balloc(ip->dev);
    8000308c:	4108                	lw	a0,0(a0)
    8000308e:	e99ff0ef          	jal	80002f26 <balloc>
    80003092:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003096:	02090963          	beqz	s2,800030c8 <bmap+0x94>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000309a:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000309e:	85ca                	mv	a1,s2
    800030a0:	0009a503          	lw	a0,0(s3)
    800030a4:	c1fff0ef          	jal	80002cc2 <bread>
    800030a8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800030aa:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    800030ae:	02049713          	sll	a4,s1,0x20
    800030b2:	01e75593          	srl	a1,a4,0x1e
    800030b6:	00b784b3          	add	s1,a5,a1
    800030ba:	0004a903          	lw	s2,0(s1)
    800030be:	00090e63          	beqz	s2,800030da <bmap+0xa6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800030c2:	8552                	mv	a0,s4
    800030c4:	d07ff0ef          	jal	80002dca <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800030c8:	854a                	mv	a0,s2
    800030ca:	70a2                	ld	ra,40(sp)
    800030cc:	7402                	ld	s0,32(sp)
    800030ce:	64e2                	ld	s1,24(sp)
    800030d0:	6942                	ld	s2,16(sp)
    800030d2:	69a2                	ld	s3,8(sp)
    800030d4:	6a02                	ld	s4,0(sp)
    800030d6:	6145                	add	sp,sp,48
    800030d8:	8082                	ret
      addr = balloc(ip->dev);
    800030da:	0009a503          	lw	a0,0(s3)
    800030de:	e49ff0ef          	jal	80002f26 <balloc>
    800030e2:	0005091b          	sext.w	s2,a0
      if(addr){
    800030e6:	fc090ee3          	beqz	s2,800030c2 <bmap+0x8e>
        a[bn] = addr;
    800030ea:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800030ee:	8552                	mv	a0,s4
    800030f0:	4d3000ef          	jal	80003dc2 <log_write>
    800030f4:	b7f9                	j	800030c2 <bmap+0x8e>
  panic("bmap: out of range");
    800030f6:	00004517          	auipc	a0,0x4
    800030fa:	4fa50513          	add	a0,a0,1274 # 800075f0 <syscalls+0x160>
    800030fe:	e60fd0ef          	jal	8000075e <panic>

0000000080003102 <iget>:
{
    80003102:	7179                	add	sp,sp,-48
    80003104:	f406                	sd	ra,40(sp)
    80003106:	f022                	sd	s0,32(sp)
    80003108:	ec26                	sd	s1,24(sp)
    8000310a:	e84a                	sd	s2,16(sp)
    8000310c:	e44e                	sd	s3,8(sp)
    8000310e:	e052                	sd	s4,0(sp)
    80003110:	1800                	add	s0,sp,48
    80003112:	89aa                	mv	s3,a0
    80003114:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003116:	0002d517          	auipc	a0,0x2d
    8000311a:	da250513          	add	a0,a0,-606 # 8002feb8 <itable>
    8000311e:	a83fd0ef          	jal	80000ba0 <acquire>
  empty = 0;
    80003122:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003124:	0002d497          	auipc	s1,0x2d
    80003128:	dac48493          	add	s1,s1,-596 # 8002fed0 <itable+0x18>
    8000312c:	0002f697          	auipc	a3,0x2f
    80003130:	83468693          	add	a3,a3,-1996 # 80031960 <log>
    80003134:	a039                	j	80003142 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003136:	02090963          	beqz	s2,80003168 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000313a:	08848493          	add	s1,s1,136
    8000313e:	02d48863          	beq	s1,a3,8000316e <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003142:	449c                	lw	a5,8(s1)
    80003144:	fef059e3          	blez	a5,80003136 <iget+0x34>
    80003148:	4098                	lw	a4,0(s1)
    8000314a:	ff3716e3          	bne	a4,s3,80003136 <iget+0x34>
    8000314e:	40d8                	lw	a4,4(s1)
    80003150:	ff4713e3          	bne	a4,s4,80003136 <iget+0x34>
      ip->ref++;
    80003154:	2785                	addw	a5,a5,1
    80003156:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003158:	0002d517          	auipc	a0,0x2d
    8000315c:	d6050513          	add	a0,a0,-672 # 8002feb8 <itable>
    80003160:	ad9fd0ef          	jal	80000c38 <release>
      return ip;
    80003164:	8926                	mv	s2,s1
    80003166:	a02d                	j	80003190 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003168:	fbe9                	bnez	a5,8000313a <iget+0x38>
    8000316a:	8926                	mv	s2,s1
    8000316c:	b7f9                	j	8000313a <iget+0x38>
  if(empty == 0)
    8000316e:	02090a63          	beqz	s2,800031a2 <iget+0xa0>
  ip->dev = dev;
    80003172:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003176:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000317a:	4785                	li	a5,1
    8000317c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003180:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003184:	0002d517          	auipc	a0,0x2d
    80003188:	d3450513          	add	a0,a0,-716 # 8002feb8 <itable>
    8000318c:	aadfd0ef          	jal	80000c38 <release>
}
    80003190:	854a                	mv	a0,s2
    80003192:	70a2                	ld	ra,40(sp)
    80003194:	7402                	ld	s0,32(sp)
    80003196:	64e2                	ld	s1,24(sp)
    80003198:	6942                	ld	s2,16(sp)
    8000319a:	69a2                	ld	s3,8(sp)
    8000319c:	6a02                	ld	s4,0(sp)
    8000319e:	6145                	add	sp,sp,48
    800031a0:	8082                	ret
    panic("iget: no inodes");
    800031a2:	00004517          	auipc	a0,0x4
    800031a6:	46650513          	add	a0,a0,1126 # 80007608 <syscalls+0x178>
    800031aa:	db4fd0ef          	jal	8000075e <panic>

00000000800031ae <fsinit>:
fsinit(int dev) {
    800031ae:	7179                	add	sp,sp,-48
    800031b0:	f406                	sd	ra,40(sp)
    800031b2:	f022                	sd	s0,32(sp)
    800031b4:	ec26                	sd	s1,24(sp)
    800031b6:	e84a                	sd	s2,16(sp)
    800031b8:	e44e                	sd	s3,8(sp)
    800031ba:	1800                	add	s0,sp,48
    800031bc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800031be:	4585                	li	a1,1
    800031c0:	b03ff0ef          	jal	80002cc2 <bread>
    800031c4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800031c6:	0002d997          	auipc	s3,0x2d
    800031ca:	cd298993          	add	s3,s3,-814 # 8002fe98 <sb>
    800031ce:	02000613          	li	a2,32
    800031d2:	05850593          	add	a1,a0,88
    800031d6:	854e                	mv	a0,s3
    800031d8:	af9fd0ef          	jal	80000cd0 <memmove>
  brelse(bp);
    800031dc:	8526                	mv	a0,s1
    800031de:	bedff0ef          	jal	80002dca <brelse>
  if(sb.magic != FSMAGIC)
    800031e2:	0009a703          	lw	a4,0(s3)
    800031e6:	102037b7          	lui	a5,0x10203
    800031ea:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800031ee:	02f71063          	bne	a4,a5,8000320e <fsinit+0x60>
  initlog(dev, &sb);
    800031f2:	0002d597          	auipc	a1,0x2d
    800031f6:	ca658593          	add	a1,a1,-858 # 8002fe98 <sb>
    800031fa:	854a                	mv	a0,s2
    800031fc:	1c5000ef          	jal	80003bc0 <initlog>
}
    80003200:	70a2                	ld	ra,40(sp)
    80003202:	7402                	ld	s0,32(sp)
    80003204:	64e2                	ld	s1,24(sp)
    80003206:	6942                	ld	s2,16(sp)
    80003208:	69a2                	ld	s3,8(sp)
    8000320a:	6145                	add	sp,sp,48
    8000320c:	8082                	ret
    panic("invalid file system");
    8000320e:	00004517          	auipc	a0,0x4
    80003212:	40a50513          	add	a0,a0,1034 # 80007618 <syscalls+0x188>
    80003216:	d48fd0ef          	jal	8000075e <panic>

000000008000321a <iinit>:
{
    8000321a:	7179                	add	sp,sp,-48
    8000321c:	f406                	sd	ra,40(sp)
    8000321e:	f022                	sd	s0,32(sp)
    80003220:	ec26                	sd	s1,24(sp)
    80003222:	e84a                	sd	s2,16(sp)
    80003224:	e44e                	sd	s3,8(sp)
    80003226:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80003228:	00004597          	auipc	a1,0x4
    8000322c:	40858593          	add	a1,a1,1032 # 80007630 <syscalls+0x1a0>
    80003230:	0002d517          	auipc	a0,0x2d
    80003234:	c8850513          	add	a0,a0,-888 # 8002feb8 <itable>
    80003238:	8e9fd0ef          	jal	80000b20 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000323c:	0002d497          	auipc	s1,0x2d
    80003240:	ca448493          	add	s1,s1,-860 # 8002fee0 <itable+0x28>
    80003244:	0002e997          	auipc	s3,0x2e
    80003248:	72c98993          	add	s3,s3,1836 # 80031970 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000324c:	00004917          	auipc	s2,0x4
    80003250:	3ec90913          	add	s2,s2,1004 # 80007638 <syscalls+0x1a8>
    80003254:	85ca                	mv	a1,s2
    80003256:	8526                	mv	a0,s1
    80003258:	43b000ef          	jal	80003e92 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000325c:	08848493          	add	s1,s1,136
    80003260:	ff349ae3          	bne	s1,s3,80003254 <iinit+0x3a>
}
    80003264:	70a2                	ld	ra,40(sp)
    80003266:	7402                	ld	s0,32(sp)
    80003268:	64e2                	ld	s1,24(sp)
    8000326a:	6942                	ld	s2,16(sp)
    8000326c:	69a2                	ld	s3,8(sp)
    8000326e:	6145                	add	sp,sp,48
    80003270:	8082                	ret

0000000080003272 <ialloc>:
{
    80003272:	7139                	add	sp,sp,-64
    80003274:	fc06                	sd	ra,56(sp)
    80003276:	f822                	sd	s0,48(sp)
    80003278:	f426                	sd	s1,40(sp)
    8000327a:	f04a                	sd	s2,32(sp)
    8000327c:	ec4e                	sd	s3,24(sp)
    8000327e:	e852                	sd	s4,16(sp)
    80003280:	e456                	sd	s5,8(sp)
    80003282:	e05a                	sd	s6,0(sp)
    80003284:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003286:	0002d717          	auipc	a4,0x2d
    8000328a:	c1e72703          	lw	a4,-994(a4) # 8002fea4 <sb+0xc>
    8000328e:	4785                	li	a5,1
    80003290:	04e7f463          	bgeu	a5,a4,800032d8 <ialloc+0x66>
    80003294:	8aaa                	mv	s5,a0
    80003296:	8b2e                	mv	s6,a1
    80003298:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000329a:	0002da17          	auipc	s4,0x2d
    8000329e:	bfea0a13          	add	s4,s4,-1026 # 8002fe98 <sb>
    800032a2:	00495593          	srl	a1,s2,0x4
    800032a6:	018a2783          	lw	a5,24(s4)
    800032aa:	9dbd                	addw	a1,a1,a5
    800032ac:	8556                	mv	a0,s5
    800032ae:	a15ff0ef          	jal	80002cc2 <bread>
    800032b2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800032b4:	05850993          	add	s3,a0,88
    800032b8:	00f97793          	and	a5,s2,15
    800032bc:	079a                	sll	a5,a5,0x6
    800032be:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800032c0:	00099783          	lh	a5,0(s3)
    800032c4:	cb9d                	beqz	a5,800032fa <ialloc+0x88>
    brelse(bp);
    800032c6:	b05ff0ef          	jal	80002dca <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800032ca:	0905                	add	s2,s2,1
    800032cc:	00ca2703          	lw	a4,12(s4)
    800032d0:	0009079b          	sext.w	a5,s2
    800032d4:	fce7e7e3          	bltu	a5,a4,800032a2 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    800032d8:	00004517          	auipc	a0,0x4
    800032dc:	36850513          	add	a0,a0,872 # 80007640 <syscalls+0x1b0>
    800032e0:	9befd0ef          	jal	8000049e <printf>
  return 0;
    800032e4:	4501                	li	a0,0
}
    800032e6:	70e2                	ld	ra,56(sp)
    800032e8:	7442                	ld	s0,48(sp)
    800032ea:	74a2                	ld	s1,40(sp)
    800032ec:	7902                	ld	s2,32(sp)
    800032ee:	69e2                	ld	s3,24(sp)
    800032f0:	6a42                	ld	s4,16(sp)
    800032f2:	6aa2                	ld	s5,8(sp)
    800032f4:	6b02                	ld	s6,0(sp)
    800032f6:	6121                	add	sp,sp,64
    800032f8:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800032fa:	04000613          	li	a2,64
    800032fe:	4581                	li	a1,0
    80003300:	854e                	mv	a0,s3
    80003302:	973fd0ef          	jal	80000c74 <memset>
      dip->type = type;
    80003306:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000330a:	8526                	mv	a0,s1
    8000330c:	2b7000ef          	jal	80003dc2 <log_write>
      brelse(bp);
    80003310:	8526                	mv	a0,s1
    80003312:	ab9ff0ef          	jal	80002dca <brelse>
      return iget(dev, inum);
    80003316:	0009059b          	sext.w	a1,s2
    8000331a:	8556                	mv	a0,s5
    8000331c:	de7ff0ef          	jal	80003102 <iget>
    80003320:	b7d9                	j	800032e6 <ialloc+0x74>

0000000080003322 <iupdate>:
{
    80003322:	1101                	add	sp,sp,-32
    80003324:	ec06                	sd	ra,24(sp)
    80003326:	e822                	sd	s0,16(sp)
    80003328:	e426                	sd	s1,8(sp)
    8000332a:	e04a                	sd	s2,0(sp)
    8000332c:	1000                	add	s0,sp,32
    8000332e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003330:	415c                	lw	a5,4(a0)
    80003332:	0047d79b          	srlw	a5,a5,0x4
    80003336:	0002d597          	auipc	a1,0x2d
    8000333a:	b7a5a583          	lw	a1,-1158(a1) # 8002feb0 <sb+0x18>
    8000333e:	9dbd                	addw	a1,a1,a5
    80003340:	4108                	lw	a0,0(a0)
    80003342:	981ff0ef          	jal	80002cc2 <bread>
    80003346:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003348:	05850793          	add	a5,a0,88
    8000334c:	40d8                	lw	a4,4(s1)
    8000334e:	8b3d                	and	a4,a4,15
    80003350:	071a                	sll	a4,a4,0x6
    80003352:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003354:	04449703          	lh	a4,68(s1)
    80003358:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000335c:	04649703          	lh	a4,70(s1)
    80003360:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003364:	04849703          	lh	a4,72(s1)
    80003368:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000336c:	04a49703          	lh	a4,74(s1)
    80003370:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003374:	44f8                	lw	a4,76(s1)
    80003376:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003378:	03400613          	li	a2,52
    8000337c:	05048593          	add	a1,s1,80
    80003380:	00c78513          	add	a0,a5,12
    80003384:	94dfd0ef          	jal	80000cd0 <memmove>
  log_write(bp);
    80003388:	854a                	mv	a0,s2
    8000338a:	239000ef          	jal	80003dc2 <log_write>
  brelse(bp);
    8000338e:	854a                	mv	a0,s2
    80003390:	a3bff0ef          	jal	80002dca <brelse>
}
    80003394:	60e2                	ld	ra,24(sp)
    80003396:	6442                	ld	s0,16(sp)
    80003398:	64a2                	ld	s1,8(sp)
    8000339a:	6902                	ld	s2,0(sp)
    8000339c:	6105                	add	sp,sp,32
    8000339e:	8082                	ret

00000000800033a0 <idup>:
{
    800033a0:	1101                	add	sp,sp,-32
    800033a2:	ec06                	sd	ra,24(sp)
    800033a4:	e822                	sd	s0,16(sp)
    800033a6:	e426                	sd	s1,8(sp)
    800033a8:	1000                	add	s0,sp,32
    800033aa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800033ac:	0002d517          	auipc	a0,0x2d
    800033b0:	b0c50513          	add	a0,a0,-1268 # 8002feb8 <itable>
    800033b4:	fecfd0ef          	jal	80000ba0 <acquire>
  ip->ref++;
    800033b8:	449c                	lw	a5,8(s1)
    800033ba:	2785                	addw	a5,a5,1
    800033bc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800033be:	0002d517          	auipc	a0,0x2d
    800033c2:	afa50513          	add	a0,a0,-1286 # 8002feb8 <itable>
    800033c6:	873fd0ef          	jal	80000c38 <release>
}
    800033ca:	8526                	mv	a0,s1
    800033cc:	60e2                	ld	ra,24(sp)
    800033ce:	6442                	ld	s0,16(sp)
    800033d0:	64a2                	ld	s1,8(sp)
    800033d2:	6105                	add	sp,sp,32
    800033d4:	8082                	ret

00000000800033d6 <ilock>:
{
    800033d6:	1101                	add	sp,sp,-32
    800033d8:	ec06                	sd	ra,24(sp)
    800033da:	e822                	sd	s0,16(sp)
    800033dc:	e426                	sd	s1,8(sp)
    800033de:	e04a                	sd	s2,0(sp)
    800033e0:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800033e2:	c105                	beqz	a0,80003402 <ilock+0x2c>
    800033e4:	84aa                	mv	s1,a0
    800033e6:	451c                	lw	a5,8(a0)
    800033e8:	00f05d63          	blez	a5,80003402 <ilock+0x2c>
  acquiresleep(&ip->lock);
    800033ec:	0541                	add	a0,a0,16
    800033ee:	2db000ef          	jal	80003ec8 <acquiresleep>
  if(ip->valid == 0){
    800033f2:	40bc                	lw	a5,64(s1)
    800033f4:	cf89                	beqz	a5,8000340e <ilock+0x38>
}
    800033f6:	60e2                	ld	ra,24(sp)
    800033f8:	6442                	ld	s0,16(sp)
    800033fa:	64a2                	ld	s1,8(sp)
    800033fc:	6902                	ld	s2,0(sp)
    800033fe:	6105                	add	sp,sp,32
    80003400:	8082                	ret
    panic("ilock");
    80003402:	00004517          	auipc	a0,0x4
    80003406:	25650513          	add	a0,a0,598 # 80007658 <syscalls+0x1c8>
    8000340a:	b54fd0ef          	jal	8000075e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000340e:	40dc                	lw	a5,4(s1)
    80003410:	0047d79b          	srlw	a5,a5,0x4
    80003414:	0002d597          	auipc	a1,0x2d
    80003418:	a9c5a583          	lw	a1,-1380(a1) # 8002feb0 <sb+0x18>
    8000341c:	9dbd                	addw	a1,a1,a5
    8000341e:	4088                	lw	a0,0(s1)
    80003420:	8a3ff0ef          	jal	80002cc2 <bread>
    80003424:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003426:	05850593          	add	a1,a0,88
    8000342a:	40dc                	lw	a5,4(s1)
    8000342c:	8bbd                	and	a5,a5,15
    8000342e:	079a                	sll	a5,a5,0x6
    80003430:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003432:	00059783          	lh	a5,0(a1)
    80003436:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000343a:	00259783          	lh	a5,2(a1)
    8000343e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003442:	00459783          	lh	a5,4(a1)
    80003446:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000344a:	00659783          	lh	a5,6(a1)
    8000344e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003452:	459c                	lw	a5,8(a1)
    80003454:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003456:	03400613          	li	a2,52
    8000345a:	05b1                	add	a1,a1,12
    8000345c:	05048513          	add	a0,s1,80
    80003460:	871fd0ef          	jal	80000cd0 <memmove>
    brelse(bp);
    80003464:	854a                	mv	a0,s2
    80003466:	965ff0ef          	jal	80002dca <brelse>
    ip->valid = 1;
    8000346a:	4785                	li	a5,1
    8000346c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000346e:	04449783          	lh	a5,68(s1)
    80003472:	f3d1                	bnez	a5,800033f6 <ilock+0x20>
      panic("ilock: no type");
    80003474:	00004517          	auipc	a0,0x4
    80003478:	1ec50513          	add	a0,a0,492 # 80007660 <syscalls+0x1d0>
    8000347c:	ae2fd0ef          	jal	8000075e <panic>

0000000080003480 <iunlock>:
{
    80003480:	1101                	add	sp,sp,-32
    80003482:	ec06                	sd	ra,24(sp)
    80003484:	e822                	sd	s0,16(sp)
    80003486:	e426                	sd	s1,8(sp)
    80003488:	e04a                	sd	s2,0(sp)
    8000348a:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000348c:	c505                	beqz	a0,800034b4 <iunlock+0x34>
    8000348e:	84aa                	mv	s1,a0
    80003490:	01050913          	add	s2,a0,16
    80003494:	854a                	mv	a0,s2
    80003496:	2b1000ef          	jal	80003f46 <holdingsleep>
    8000349a:	cd09                	beqz	a0,800034b4 <iunlock+0x34>
    8000349c:	449c                	lw	a5,8(s1)
    8000349e:	00f05b63          	blez	a5,800034b4 <iunlock+0x34>
  releasesleep(&ip->lock);
    800034a2:	854a                	mv	a0,s2
    800034a4:	26b000ef          	jal	80003f0e <releasesleep>
}
    800034a8:	60e2                	ld	ra,24(sp)
    800034aa:	6442                	ld	s0,16(sp)
    800034ac:	64a2                	ld	s1,8(sp)
    800034ae:	6902                	ld	s2,0(sp)
    800034b0:	6105                	add	sp,sp,32
    800034b2:	8082                	ret
    panic("iunlock");
    800034b4:	00004517          	auipc	a0,0x4
    800034b8:	1bc50513          	add	a0,a0,444 # 80007670 <syscalls+0x1e0>
    800034bc:	aa2fd0ef          	jal	8000075e <panic>

00000000800034c0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800034c0:	7179                	add	sp,sp,-48
    800034c2:	f406                	sd	ra,40(sp)
    800034c4:	f022                	sd	s0,32(sp)
    800034c6:	ec26                	sd	s1,24(sp)
    800034c8:	e84a                	sd	s2,16(sp)
    800034ca:	e44e                	sd	s3,8(sp)
    800034cc:	e052                	sd	s4,0(sp)
    800034ce:	1800                	add	s0,sp,48
    800034d0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800034d2:	05050493          	add	s1,a0,80
    800034d6:	08050913          	add	s2,a0,128
    800034da:	a021                	j	800034e2 <itrunc+0x22>
    800034dc:	0491                	add	s1,s1,4
    800034de:	01248b63          	beq	s1,s2,800034f4 <itrunc+0x34>
    if(ip->addrs[i]){
    800034e2:	408c                	lw	a1,0(s1)
    800034e4:	dde5                	beqz	a1,800034dc <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800034e6:	0009a503          	lw	a0,0(s3)
    800034ea:	9d1ff0ef          	jal	80002eba <bfree>
      ip->addrs[i] = 0;
    800034ee:	0004a023          	sw	zero,0(s1)
    800034f2:	b7ed                	j	800034dc <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800034f4:	0809a583          	lw	a1,128(s3)
    800034f8:	ed91                	bnez	a1,80003514 <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800034fa:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800034fe:	854e                	mv	a0,s3
    80003500:	e23ff0ef          	jal	80003322 <iupdate>
}
    80003504:	70a2                	ld	ra,40(sp)
    80003506:	7402                	ld	s0,32(sp)
    80003508:	64e2                	ld	s1,24(sp)
    8000350a:	6942                	ld	s2,16(sp)
    8000350c:	69a2                	ld	s3,8(sp)
    8000350e:	6a02                	ld	s4,0(sp)
    80003510:	6145                	add	sp,sp,48
    80003512:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003514:	0009a503          	lw	a0,0(s3)
    80003518:	faaff0ef          	jal	80002cc2 <bread>
    8000351c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000351e:	05850493          	add	s1,a0,88
    80003522:	45850913          	add	s2,a0,1112
    80003526:	a021                	j	8000352e <itrunc+0x6e>
    80003528:	0491                	add	s1,s1,4
    8000352a:	01248963          	beq	s1,s2,8000353c <itrunc+0x7c>
      if(a[j])
    8000352e:	408c                	lw	a1,0(s1)
    80003530:	dde5                	beqz	a1,80003528 <itrunc+0x68>
        bfree(ip->dev, a[j]);
    80003532:	0009a503          	lw	a0,0(s3)
    80003536:	985ff0ef          	jal	80002eba <bfree>
    8000353a:	b7fd                	j	80003528 <itrunc+0x68>
    brelse(bp);
    8000353c:	8552                	mv	a0,s4
    8000353e:	88dff0ef          	jal	80002dca <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003542:	0809a583          	lw	a1,128(s3)
    80003546:	0009a503          	lw	a0,0(s3)
    8000354a:	971ff0ef          	jal	80002eba <bfree>
    ip->addrs[NDIRECT] = 0;
    8000354e:	0809a023          	sw	zero,128(s3)
    80003552:	b765                	j	800034fa <itrunc+0x3a>

0000000080003554 <iput>:
{
    80003554:	1101                	add	sp,sp,-32
    80003556:	ec06                	sd	ra,24(sp)
    80003558:	e822                	sd	s0,16(sp)
    8000355a:	e426                	sd	s1,8(sp)
    8000355c:	e04a                	sd	s2,0(sp)
    8000355e:	1000                	add	s0,sp,32
    80003560:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003562:	0002d517          	auipc	a0,0x2d
    80003566:	95650513          	add	a0,a0,-1706 # 8002feb8 <itable>
    8000356a:	e36fd0ef          	jal	80000ba0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000356e:	4498                	lw	a4,8(s1)
    80003570:	4785                	li	a5,1
    80003572:	02f70163          	beq	a4,a5,80003594 <iput+0x40>
  ip->ref--;
    80003576:	449c                	lw	a5,8(s1)
    80003578:	37fd                	addw	a5,a5,-1
    8000357a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000357c:	0002d517          	auipc	a0,0x2d
    80003580:	93c50513          	add	a0,a0,-1732 # 8002feb8 <itable>
    80003584:	eb4fd0ef          	jal	80000c38 <release>
}
    80003588:	60e2                	ld	ra,24(sp)
    8000358a:	6442                	ld	s0,16(sp)
    8000358c:	64a2                	ld	s1,8(sp)
    8000358e:	6902                	ld	s2,0(sp)
    80003590:	6105                	add	sp,sp,32
    80003592:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003594:	40bc                	lw	a5,64(s1)
    80003596:	d3e5                	beqz	a5,80003576 <iput+0x22>
    80003598:	04a49783          	lh	a5,74(s1)
    8000359c:	ffe9                	bnez	a5,80003576 <iput+0x22>
    acquiresleep(&ip->lock);
    8000359e:	01048913          	add	s2,s1,16
    800035a2:	854a                	mv	a0,s2
    800035a4:	125000ef          	jal	80003ec8 <acquiresleep>
    release(&itable.lock);
    800035a8:	0002d517          	auipc	a0,0x2d
    800035ac:	91050513          	add	a0,a0,-1776 # 8002feb8 <itable>
    800035b0:	e88fd0ef          	jal	80000c38 <release>
    itrunc(ip);
    800035b4:	8526                	mv	a0,s1
    800035b6:	f0bff0ef          	jal	800034c0 <itrunc>
    ip->type = 0;
    800035ba:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800035be:	8526                	mv	a0,s1
    800035c0:	d63ff0ef          	jal	80003322 <iupdate>
    ip->valid = 0;
    800035c4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800035c8:	854a                	mv	a0,s2
    800035ca:	145000ef          	jal	80003f0e <releasesleep>
    acquire(&itable.lock);
    800035ce:	0002d517          	auipc	a0,0x2d
    800035d2:	8ea50513          	add	a0,a0,-1814 # 8002feb8 <itable>
    800035d6:	dcafd0ef          	jal	80000ba0 <acquire>
    800035da:	bf71                	j	80003576 <iput+0x22>

00000000800035dc <iunlockput>:
{
    800035dc:	1101                	add	sp,sp,-32
    800035de:	ec06                	sd	ra,24(sp)
    800035e0:	e822                	sd	s0,16(sp)
    800035e2:	e426                	sd	s1,8(sp)
    800035e4:	1000                	add	s0,sp,32
    800035e6:	84aa                	mv	s1,a0
  iunlock(ip);
    800035e8:	e99ff0ef          	jal	80003480 <iunlock>
  iput(ip);
    800035ec:	8526                	mv	a0,s1
    800035ee:	f67ff0ef          	jal	80003554 <iput>
}
    800035f2:	60e2                	ld	ra,24(sp)
    800035f4:	6442                	ld	s0,16(sp)
    800035f6:	64a2                	ld	s1,8(sp)
    800035f8:	6105                	add	sp,sp,32
    800035fa:	8082                	ret

00000000800035fc <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800035fc:	1141                	add	sp,sp,-16
    800035fe:	e422                	sd	s0,8(sp)
    80003600:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003602:	411c                	lw	a5,0(a0)
    80003604:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003606:	415c                	lw	a5,4(a0)
    80003608:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000360a:	04451783          	lh	a5,68(a0)
    8000360e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003612:	04a51783          	lh	a5,74(a0)
    80003616:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000361a:	04c56783          	lwu	a5,76(a0)
    8000361e:	e99c                	sd	a5,16(a1)
}
    80003620:	6422                	ld	s0,8(sp)
    80003622:	0141                	add	sp,sp,16
    80003624:	8082                	ret

0000000080003626 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003626:	457c                	lw	a5,76(a0)
    80003628:	0cd7ef63          	bltu	a5,a3,80003706 <readi+0xe0>
{
    8000362c:	7159                	add	sp,sp,-112
    8000362e:	f486                	sd	ra,104(sp)
    80003630:	f0a2                	sd	s0,96(sp)
    80003632:	eca6                	sd	s1,88(sp)
    80003634:	e8ca                	sd	s2,80(sp)
    80003636:	e4ce                	sd	s3,72(sp)
    80003638:	e0d2                	sd	s4,64(sp)
    8000363a:	fc56                	sd	s5,56(sp)
    8000363c:	f85a                	sd	s6,48(sp)
    8000363e:	f45e                	sd	s7,40(sp)
    80003640:	f062                	sd	s8,32(sp)
    80003642:	ec66                	sd	s9,24(sp)
    80003644:	e86a                	sd	s10,16(sp)
    80003646:	e46e                	sd	s11,8(sp)
    80003648:	1880                	add	s0,sp,112
    8000364a:	8b2a                	mv	s6,a0
    8000364c:	8bae                	mv	s7,a1
    8000364e:	8a32                	mv	s4,a2
    80003650:	84b6                	mv	s1,a3
    80003652:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003654:	9f35                	addw	a4,a4,a3
    return 0;
    80003656:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003658:	08d76663          	bltu	a4,a3,800036e4 <readi+0xbe>
  if(off + n > ip->size)
    8000365c:	00e7f463          	bgeu	a5,a4,80003664 <readi+0x3e>
    n = ip->size - off;
    80003660:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003664:	080a8f63          	beqz	s5,80003702 <readi+0xdc>
    80003668:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000366a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000366e:	5c7d                	li	s8,-1
    80003670:	a80d                	j	800036a2 <readi+0x7c>
    80003672:	020d1d93          	sll	s11,s10,0x20
    80003676:	020ddd93          	srl	s11,s11,0x20
    8000367a:	05890613          	add	a2,s2,88
    8000367e:	86ee                	mv	a3,s11
    80003680:	963a                	add	a2,a2,a4
    80003682:	85d2                	mv	a1,s4
    80003684:	855e                	mv	a0,s7
    80003686:	b77fe0ef          	jal	800021fc <either_copyout>
    8000368a:	05850763          	beq	a0,s8,800036d8 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000368e:	854a                	mv	a0,s2
    80003690:	f3aff0ef          	jal	80002dca <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003694:	013d09bb          	addw	s3,s10,s3
    80003698:	009d04bb          	addw	s1,s10,s1
    8000369c:	9a6e                	add	s4,s4,s11
    8000369e:	0559f163          	bgeu	s3,s5,800036e0 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    800036a2:	00a4d59b          	srlw	a1,s1,0xa
    800036a6:	855a                	mv	a0,s6
    800036a8:	98dff0ef          	jal	80003034 <bmap>
    800036ac:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800036b0:	c985                	beqz	a1,800036e0 <readi+0xba>
    bp = bread(ip->dev, addr);
    800036b2:	000b2503          	lw	a0,0(s6)
    800036b6:	e0cff0ef          	jal	80002cc2 <bread>
    800036ba:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800036bc:	3ff4f713          	and	a4,s1,1023
    800036c0:	40ec87bb          	subw	a5,s9,a4
    800036c4:	413a86bb          	subw	a3,s5,s3
    800036c8:	8d3e                	mv	s10,a5
    800036ca:	2781                	sext.w	a5,a5
    800036cc:	0006861b          	sext.w	a2,a3
    800036d0:	faf671e3          	bgeu	a2,a5,80003672 <readi+0x4c>
    800036d4:	8d36                	mv	s10,a3
    800036d6:	bf71                	j	80003672 <readi+0x4c>
      brelse(bp);
    800036d8:	854a                	mv	a0,s2
    800036da:	ef0ff0ef          	jal	80002dca <brelse>
      tot = -1;
    800036de:	59fd                	li	s3,-1
  }
  return tot;
    800036e0:	0009851b          	sext.w	a0,s3
}
    800036e4:	70a6                	ld	ra,104(sp)
    800036e6:	7406                	ld	s0,96(sp)
    800036e8:	64e6                	ld	s1,88(sp)
    800036ea:	6946                	ld	s2,80(sp)
    800036ec:	69a6                	ld	s3,72(sp)
    800036ee:	6a06                	ld	s4,64(sp)
    800036f0:	7ae2                	ld	s5,56(sp)
    800036f2:	7b42                	ld	s6,48(sp)
    800036f4:	7ba2                	ld	s7,40(sp)
    800036f6:	7c02                	ld	s8,32(sp)
    800036f8:	6ce2                	ld	s9,24(sp)
    800036fa:	6d42                	ld	s10,16(sp)
    800036fc:	6da2                	ld	s11,8(sp)
    800036fe:	6165                	add	sp,sp,112
    80003700:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003702:	89d6                	mv	s3,s5
    80003704:	bff1                	j	800036e0 <readi+0xba>
    return 0;
    80003706:	4501                	li	a0,0
}
    80003708:	8082                	ret

000000008000370a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000370a:	457c                	lw	a5,76(a0)
    8000370c:	0ed7ea63          	bltu	a5,a3,80003800 <writei+0xf6>
{
    80003710:	7159                	add	sp,sp,-112
    80003712:	f486                	sd	ra,104(sp)
    80003714:	f0a2                	sd	s0,96(sp)
    80003716:	eca6                	sd	s1,88(sp)
    80003718:	e8ca                	sd	s2,80(sp)
    8000371a:	e4ce                	sd	s3,72(sp)
    8000371c:	e0d2                	sd	s4,64(sp)
    8000371e:	fc56                	sd	s5,56(sp)
    80003720:	f85a                	sd	s6,48(sp)
    80003722:	f45e                	sd	s7,40(sp)
    80003724:	f062                	sd	s8,32(sp)
    80003726:	ec66                	sd	s9,24(sp)
    80003728:	e86a                	sd	s10,16(sp)
    8000372a:	e46e                	sd	s11,8(sp)
    8000372c:	1880                	add	s0,sp,112
    8000372e:	8aaa                	mv	s5,a0
    80003730:	8bae                	mv	s7,a1
    80003732:	8a32                	mv	s4,a2
    80003734:	8936                	mv	s2,a3
    80003736:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003738:	00e687bb          	addw	a5,a3,a4
    8000373c:	0cd7e463          	bltu	a5,a3,80003804 <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003740:	00043737          	lui	a4,0x43
    80003744:	0cf76263          	bltu	a4,a5,80003808 <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003748:	0a0b0a63          	beqz	s6,800037fc <writei+0xf2>
    8000374c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000374e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003752:	5c7d                	li	s8,-1
    80003754:	a825                	j	8000378c <writei+0x82>
    80003756:	020d1d93          	sll	s11,s10,0x20
    8000375a:	020ddd93          	srl	s11,s11,0x20
    8000375e:	05848513          	add	a0,s1,88
    80003762:	86ee                	mv	a3,s11
    80003764:	8652                	mv	a2,s4
    80003766:	85de                	mv	a1,s7
    80003768:	953a                	add	a0,a0,a4
    8000376a:	addfe0ef          	jal	80002246 <either_copyin>
    8000376e:	05850a63          	beq	a0,s8,800037c2 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003772:	8526                	mv	a0,s1
    80003774:	64e000ef          	jal	80003dc2 <log_write>
    brelse(bp);
    80003778:	8526                	mv	a0,s1
    8000377a:	e50ff0ef          	jal	80002dca <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000377e:	013d09bb          	addw	s3,s10,s3
    80003782:	012d093b          	addw	s2,s10,s2
    80003786:	9a6e                	add	s4,s4,s11
    80003788:	0569f063          	bgeu	s3,s6,800037c8 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8000378c:	00a9559b          	srlw	a1,s2,0xa
    80003790:	8556                	mv	a0,s5
    80003792:	8a3ff0ef          	jal	80003034 <bmap>
    80003796:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000379a:	c59d                	beqz	a1,800037c8 <writei+0xbe>
    bp = bread(ip->dev, addr);
    8000379c:	000aa503          	lw	a0,0(s5)
    800037a0:	d22ff0ef          	jal	80002cc2 <bread>
    800037a4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800037a6:	3ff97713          	and	a4,s2,1023
    800037aa:	40ec87bb          	subw	a5,s9,a4
    800037ae:	413b06bb          	subw	a3,s6,s3
    800037b2:	8d3e                	mv	s10,a5
    800037b4:	2781                	sext.w	a5,a5
    800037b6:	0006861b          	sext.w	a2,a3
    800037ba:	f8f67ee3          	bgeu	a2,a5,80003756 <writei+0x4c>
    800037be:	8d36                	mv	s10,a3
    800037c0:	bf59                	j	80003756 <writei+0x4c>
      brelse(bp);
    800037c2:	8526                	mv	a0,s1
    800037c4:	e06ff0ef          	jal	80002dca <brelse>
  }

  if(off > ip->size)
    800037c8:	04caa783          	lw	a5,76(s5)
    800037cc:	0127f463          	bgeu	a5,s2,800037d4 <writei+0xca>
    ip->size = off;
    800037d0:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800037d4:	8556                	mv	a0,s5
    800037d6:	b4dff0ef          	jal	80003322 <iupdate>

  return tot;
    800037da:	0009851b          	sext.w	a0,s3
}
    800037de:	70a6                	ld	ra,104(sp)
    800037e0:	7406                	ld	s0,96(sp)
    800037e2:	64e6                	ld	s1,88(sp)
    800037e4:	6946                	ld	s2,80(sp)
    800037e6:	69a6                	ld	s3,72(sp)
    800037e8:	6a06                	ld	s4,64(sp)
    800037ea:	7ae2                	ld	s5,56(sp)
    800037ec:	7b42                	ld	s6,48(sp)
    800037ee:	7ba2                	ld	s7,40(sp)
    800037f0:	7c02                	ld	s8,32(sp)
    800037f2:	6ce2                	ld	s9,24(sp)
    800037f4:	6d42                	ld	s10,16(sp)
    800037f6:	6da2                	ld	s11,8(sp)
    800037f8:	6165                	add	sp,sp,112
    800037fa:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037fc:	89da                	mv	s3,s6
    800037fe:	bfd9                	j	800037d4 <writei+0xca>
    return -1;
    80003800:	557d                	li	a0,-1
}
    80003802:	8082                	ret
    return -1;
    80003804:	557d                	li	a0,-1
    80003806:	bfe1                	j	800037de <writei+0xd4>
    return -1;
    80003808:	557d                	li	a0,-1
    8000380a:	bfd1                	j	800037de <writei+0xd4>

000000008000380c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000380c:	1141                	add	sp,sp,-16
    8000380e:	e406                	sd	ra,8(sp)
    80003810:	e022                	sd	s0,0(sp)
    80003812:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003814:	4639                	li	a2,14
    80003816:	d2afd0ef          	jal	80000d40 <strncmp>
}
    8000381a:	60a2                	ld	ra,8(sp)
    8000381c:	6402                	ld	s0,0(sp)
    8000381e:	0141                	add	sp,sp,16
    80003820:	8082                	ret

0000000080003822 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003822:	7139                	add	sp,sp,-64
    80003824:	fc06                	sd	ra,56(sp)
    80003826:	f822                	sd	s0,48(sp)
    80003828:	f426                	sd	s1,40(sp)
    8000382a:	f04a                	sd	s2,32(sp)
    8000382c:	ec4e                	sd	s3,24(sp)
    8000382e:	e852                	sd	s4,16(sp)
    80003830:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003832:	04451703          	lh	a4,68(a0)
    80003836:	4785                	li	a5,1
    80003838:	00f71a63          	bne	a4,a5,8000384c <dirlookup+0x2a>
    8000383c:	892a                	mv	s2,a0
    8000383e:	89ae                	mv	s3,a1
    80003840:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003842:	457c                	lw	a5,76(a0)
    80003844:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003846:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003848:	e39d                	bnez	a5,8000386e <dirlookup+0x4c>
    8000384a:	a095                	j	800038ae <dirlookup+0x8c>
    panic("dirlookup not DIR");
    8000384c:	00004517          	auipc	a0,0x4
    80003850:	e2c50513          	add	a0,a0,-468 # 80007678 <syscalls+0x1e8>
    80003854:	f0bfc0ef          	jal	8000075e <panic>
      panic("dirlookup read");
    80003858:	00004517          	auipc	a0,0x4
    8000385c:	e3850513          	add	a0,a0,-456 # 80007690 <syscalls+0x200>
    80003860:	efffc0ef          	jal	8000075e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003864:	24c1                	addw	s1,s1,16
    80003866:	04c92783          	lw	a5,76(s2)
    8000386a:	04f4f163          	bgeu	s1,a5,800038ac <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000386e:	4741                	li	a4,16
    80003870:	86a6                	mv	a3,s1
    80003872:	fc040613          	add	a2,s0,-64
    80003876:	4581                	li	a1,0
    80003878:	854a                	mv	a0,s2
    8000387a:	dadff0ef          	jal	80003626 <readi>
    8000387e:	47c1                	li	a5,16
    80003880:	fcf51ce3          	bne	a0,a5,80003858 <dirlookup+0x36>
    if(de.inum == 0)
    80003884:	fc045783          	lhu	a5,-64(s0)
    80003888:	dff1                	beqz	a5,80003864 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    8000388a:	fc240593          	add	a1,s0,-62
    8000388e:	854e                	mv	a0,s3
    80003890:	f7dff0ef          	jal	8000380c <namecmp>
    80003894:	f961                	bnez	a0,80003864 <dirlookup+0x42>
      if(poff)
    80003896:	000a0463          	beqz	s4,8000389e <dirlookup+0x7c>
        *poff = off;
    8000389a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000389e:	fc045583          	lhu	a1,-64(s0)
    800038a2:	00092503          	lw	a0,0(s2)
    800038a6:	85dff0ef          	jal	80003102 <iget>
    800038aa:	a011                	j	800038ae <dirlookup+0x8c>
  return 0;
    800038ac:	4501                	li	a0,0
}
    800038ae:	70e2                	ld	ra,56(sp)
    800038b0:	7442                	ld	s0,48(sp)
    800038b2:	74a2                	ld	s1,40(sp)
    800038b4:	7902                	ld	s2,32(sp)
    800038b6:	69e2                	ld	s3,24(sp)
    800038b8:	6a42                	ld	s4,16(sp)
    800038ba:	6121                	add	sp,sp,64
    800038bc:	8082                	ret

00000000800038be <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800038be:	711d                	add	sp,sp,-96
    800038c0:	ec86                	sd	ra,88(sp)
    800038c2:	e8a2                	sd	s0,80(sp)
    800038c4:	e4a6                	sd	s1,72(sp)
    800038c6:	e0ca                	sd	s2,64(sp)
    800038c8:	fc4e                	sd	s3,56(sp)
    800038ca:	f852                	sd	s4,48(sp)
    800038cc:	f456                	sd	s5,40(sp)
    800038ce:	f05a                	sd	s6,32(sp)
    800038d0:	ec5e                	sd	s7,24(sp)
    800038d2:	e862                	sd	s8,16(sp)
    800038d4:	e466                	sd	s9,8(sp)
    800038d6:	1080                	add	s0,sp,96
    800038d8:	84aa                	mv	s1,a0
    800038da:	8b2e                	mv	s6,a1
    800038dc:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800038de:	00054703          	lbu	a4,0(a0)
    800038e2:	02f00793          	li	a5,47
    800038e6:	00f70e63          	beq	a4,a5,80003902 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800038ea:	f47fd0ef          	jal	80001830 <myproc>
    800038ee:	15053503          	ld	a0,336(a0)
    800038f2:	aafff0ef          	jal	800033a0 <idup>
    800038f6:	8a2a                	mv	s4,a0
  while(*path == '/')
    800038f8:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800038fc:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800038fe:	4b85                	li	s7,1
    80003900:	a871                	j	8000399c <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003902:	4585                	li	a1,1
    80003904:	4505                	li	a0,1
    80003906:	ffcff0ef          	jal	80003102 <iget>
    8000390a:	8a2a                	mv	s4,a0
    8000390c:	b7f5                	j	800038f8 <namex+0x3a>
      iunlockput(ip);
    8000390e:	8552                	mv	a0,s4
    80003910:	ccdff0ef          	jal	800035dc <iunlockput>
      return 0;
    80003914:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003916:	8552                	mv	a0,s4
    80003918:	60e6                	ld	ra,88(sp)
    8000391a:	6446                	ld	s0,80(sp)
    8000391c:	64a6                	ld	s1,72(sp)
    8000391e:	6906                	ld	s2,64(sp)
    80003920:	79e2                	ld	s3,56(sp)
    80003922:	7a42                	ld	s4,48(sp)
    80003924:	7aa2                	ld	s5,40(sp)
    80003926:	7b02                	ld	s6,32(sp)
    80003928:	6be2                	ld	s7,24(sp)
    8000392a:	6c42                	ld	s8,16(sp)
    8000392c:	6ca2                	ld	s9,8(sp)
    8000392e:	6125                	add	sp,sp,96
    80003930:	8082                	ret
      iunlock(ip);
    80003932:	8552                	mv	a0,s4
    80003934:	b4dff0ef          	jal	80003480 <iunlock>
      return ip;
    80003938:	bff9                	j	80003916 <namex+0x58>
      iunlockput(ip);
    8000393a:	8552                	mv	a0,s4
    8000393c:	ca1ff0ef          	jal	800035dc <iunlockput>
      return 0;
    80003940:	8a4e                	mv	s4,s3
    80003942:	bfd1                	j	80003916 <namex+0x58>
  len = path - s;
    80003944:	40998633          	sub	a2,s3,s1
    80003948:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000394c:	099c5063          	bge	s8,s9,800039cc <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003950:	4639                	li	a2,14
    80003952:	85a6                	mv	a1,s1
    80003954:	8556                	mv	a0,s5
    80003956:	b7afd0ef          	jal	80000cd0 <memmove>
    8000395a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000395c:	0004c783          	lbu	a5,0(s1)
    80003960:	01279763          	bne	a5,s2,8000396e <namex+0xb0>
    path++;
    80003964:	0485                	add	s1,s1,1
  while(*path == '/')
    80003966:	0004c783          	lbu	a5,0(s1)
    8000396a:	ff278de3          	beq	a5,s2,80003964 <namex+0xa6>
    ilock(ip);
    8000396e:	8552                	mv	a0,s4
    80003970:	a67ff0ef          	jal	800033d6 <ilock>
    if(ip->type != T_DIR){
    80003974:	044a1783          	lh	a5,68(s4)
    80003978:	f9779be3          	bne	a5,s7,8000390e <namex+0x50>
    if(nameiparent && *path == '\0'){
    8000397c:	000b0563          	beqz	s6,80003986 <namex+0xc8>
    80003980:	0004c783          	lbu	a5,0(s1)
    80003984:	d7dd                	beqz	a5,80003932 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003986:	4601                	li	a2,0
    80003988:	85d6                	mv	a1,s5
    8000398a:	8552                	mv	a0,s4
    8000398c:	e97ff0ef          	jal	80003822 <dirlookup>
    80003990:	89aa                	mv	s3,a0
    80003992:	d545                	beqz	a0,8000393a <namex+0x7c>
    iunlockput(ip);
    80003994:	8552                	mv	a0,s4
    80003996:	c47ff0ef          	jal	800035dc <iunlockput>
    ip = next;
    8000399a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000399c:	0004c783          	lbu	a5,0(s1)
    800039a0:	01279763          	bne	a5,s2,800039ae <namex+0xf0>
    path++;
    800039a4:	0485                	add	s1,s1,1
  while(*path == '/')
    800039a6:	0004c783          	lbu	a5,0(s1)
    800039aa:	ff278de3          	beq	a5,s2,800039a4 <namex+0xe6>
  if(*path == 0)
    800039ae:	cb8d                	beqz	a5,800039e0 <namex+0x122>
  while(*path != '/' && *path != 0)
    800039b0:	0004c783          	lbu	a5,0(s1)
    800039b4:	89a6                	mv	s3,s1
  len = path - s;
    800039b6:	4c81                	li	s9,0
    800039b8:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800039ba:	01278963          	beq	a5,s2,800039cc <namex+0x10e>
    800039be:	d3d9                	beqz	a5,80003944 <namex+0x86>
    path++;
    800039c0:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    800039c2:	0009c783          	lbu	a5,0(s3)
    800039c6:	ff279ce3          	bne	a5,s2,800039be <namex+0x100>
    800039ca:	bfad                	j	80003944 <namex+0x86>
    memmove(name, s, len);
    800039cc:	2601                	sext.w	a2,a2
    800039ce:	85a6                	mv	a1,s1
    800039d0:	8556                	mv	a0,s5
    800039d2:	afefd0ef          	jal	80000cd0 <memmove>
    name[len] = 0;
    800039d6:	9cd6                	add	s9,s9,s5
    800039d8:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800039dc:	84ce                	mv	s1,s3
    800039de:	bfbd                	j	8000395c <namex+0x9e>
  if(nameiparent){
    800039e0:	f20b0be3          	beqz	s6,80003916 <namex+0x58>
    iput(ip);
    800039e4:	8552                	mv	a0,s4
    800039e6:	b6fff0ef          	jal	80003554 <iput>
    return 0;
    800039ea:	4a01                	li	s4,0
    800039ec:	b72d                	j	80003916 <namex+0x58>

00000000800039ee <dirlink>:
{
    800039ee:	7139                	add	sp,sp,-64
    800039f0:	fc06                	sd	ra,56(sp)
    800039f2:	f822                	sd	s0,48(sp)
    800039f4:	f426                	sd	s1,40(sp)
    800039f6:	f04a                	sd	s2,32(sp)
    800039f8:	ec4e                	sd	s3,24(sp)
    800039fa:	e852                	sd	s4,16(sp)
    800039fc:	0080                	add	s0,sp,64
    800039fe:	892a                	mv	s2,a0
    80003a00:	8a2e                	mv	s4,a1
    80003a02:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003a04:	4601                	li	a2,0
    80003a06:	e1dff0ef          	jal	80003822 <dirlookup>
    80003a0a:	e52d                	bnez	a0,80003a74 <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a0c:	04c92483          	lw	s1,76(s2)
    80003a10:	c48d                	beqz	s1,80003a3a <dirlink+0x4c>
    80003a12:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a14:	4741                	li	a4,16
    80003a16:	86a6                	mv	a3,s1
    80003a18:	fc040613          	add	a2,s0,-64
    80003a1c:	4581                	li	a1,0
    80003a1e:	854a                	mv	a0,s2
    80003a20:	c07ff0ef          	jal	80003626 <readi>
    80003a24:	47c1                	li	a5,16
    80003a26:	04f51b63          	bne	a0,a5,80003a7c <dirlink+0x8e>
    if(de.inum == 0)
    80003a2a:	fc045783          	lhu	a5,-64(s0)
    80003a2e:	c791                	beqz	a5,80003a3a <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a30:	24c1                	addw	s1,s1,16
    80003a32:	04c92783          	lw	a5,76(s2)
    80003a36:	fcf4efe3          	bltu	s1,a5,80003a14 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003a3a:	4639                	li	a2,14
    80003a3c:	85d2                	mv	a1,s4
    80003a3e:	fc240513          	add	a0,s0,-62
    80003a42:	b3afd0ef          	jal	80000d7c <strncpy>
  de.inum = inum;
    80003a46:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a4a:	4741                	li	a4,16
    80003a4c:	86a6                	mv	a3,s1
    80003a4e:	fc040613          	add	a2,s0,-64
    80003a52:	4581                	li	a1,0
    80003a54:	854a                	mv	a0,s2
    80003a56:	cb5ff0ef          	jal	8000370a <writei>
    80003a5a:	1541                	add	a0,a0,-16
    80003a5c:	00a03533          	snez	a0,a0
    80003a60:	40a00533          	neg	a0,a0
}
    80003a64:	70e2                	ld	ra,56(sp)
    80003a66:	7442                	ld	s0,48(sp)
    80003a68:	74a2                	ld	s1,40(sp)
    80003a6a:	7902                	ld	s2,32(sp)
    80003a6c:	69e2                	ld	s3,24(sp)
    80003a6e:	6a42                	ld	s4,16(sp)
    80003a70:	6121                	add	sp,sp,64
    80003a72:	8082                	ret
    iput(ip);
    80003a74:	ae1ff0ef          	jal	80003554 <iput>
    return -1;
    80003a78:	557d                	li	a0,-1
    80003a7a:	b7ed                	j	80003a64 <dirlink+0x76>
      panic("dirlink read");
    80003a7c:	00004517          	auipc	a0,0x4
    80003a80:	c2450513          	add	a0,a0,-988 # 800076a0 <syscalls+0x210>
    80003a84:	cdbfc0ef          	jal	8000075e <panic>

0000000080003a88 <namei>:

struct inode*
namei(char *path)
{
    80003a88:	1101                	add	sp,sp,-32
    80003a8a:	ec06                	sd	ra,24(sp)
    80003a8c:	e822                	sd	s0,16(sp)
    80003a8e:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003a90:	fe040613          	add	a2,s0,-32
    80003a94:	4581                	li	a1,0
    80003a96:	e29ff0ef          	jal	800038be <namex>
}
    80003a9a:	60e2                	ld	ra,24(sp)
    80003a9c:	6442                	ld	s0,16(sp)
    80003a9e:	6105                	add	sp,sp,32
    80003aa0:	8082                	ret

0000000080003aa2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003aa2:	1141                	add	sp,sp,-16
    80003aa4:	e406                	sd	ra,8(sp)
    80003aa6:	e022                	sd	s0,0(sp)
    80003aa8:	0800                	add	s0,sp,16
    80003aaa:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003aac:	4585                	li	a1,1
    80003aae:	e11ff0ef          	jal	800038be <namex>
}
    80003ab2:	60a2                	ld	ra,8(sp)
    80003ab4:	6402                	ld	s0,0(sp)
    80003ab6:	0141                	add	sp,sp,16
    80003ab8:	8082                	ret

0000000080003aba <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003aba:	1101                	add	sp,sp,-32
    80003abc:	ec06                	sd	ra,24(sp)
    80003abe:	e822                	sd	s0,16(sp)
    80003ac0:	e426                	sd	s1,8(sp)
    80003ac2:	e04a                	sd	s2,0(sp)
    80003ac4:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003ac6:	0002e917          	auipc	s2,0x2e
    80003aca:	e9a90913          	add	s2,s2,-358 # 80031960 <log>
    80003ace:	01892583          	lw	a1,24(s2)
    80003ad2:	02892503          	lw	a0,40(s2)
    80003ad6:	9ecff0ef          	jal	80002cc2 <bread>
    80003ada:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003adc:	02c92603          	lw	a2,44(s2)
    80003ae0:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003ae2:	00c05f63          	blez	a2,80003b00 <write_head+0x46>
    80003ae6:	0002e717          	auipc	a4,0x2e
    80003aea:	eaa70713          	add	a4,a4,-342 # 80031990 <log+0x30>
    80003aee:	87aa                	mv	a5,a0
    80003af0:	060a                	sll	a2,a2,0x2
    80003af2:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003af4:	4314                	lw	a3,0(a4)
    80003af6:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003af8:	0711                	add	a4,a4,4
    80003afa:	0791                	add	a5,a5,4
    80003afc:	fec79ce3          	bne	a5,a2,80003af4 <write_head+0x3a>
  }
  bwrite(buf);
    80003b00:	8526                	mv	a0,s1
    80003b02:	a96ff0ef          	jal	80002d98 <bwrite>
  brelse(buf);
    80003b06:	8526                	mv	a0,s1
    80003b08:	ac2ff0ef          	jal	80002dca <brelse>
}
    80003b0c:	60e2                	ld	ra,24(sp)
    80003b0e:	6442                	ld	s0,16(sp)
    80003b10:	64a2                	ld	s1,8(sp)
    80003b12:	6902                	ld	s2,0(sp)
    80003b14:	6105                	add	sp,sp,32
    80003b16:	8082                	ret

0000000080003b18 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b18:	0002e797          	auipc	a5,0x2e
    80003b1c:	e747a783          	lw	a5,-396(a5) # 8003198c <log+0x2c>
    80003b20:	08f05f63          	blez	a5,80003bbe <install_trans+0xa6>
{
    80003b24:	7139                	add	sp,sp,-64
    80003b26:	fc06                	sd	ra,56(sp)
    80003b28:	f822                	sd	s0,48(sp)
    80003b2a:	f426                	sd	s1,40(sp)
    80003b2c:	f04a                	sd	s2,32(sp)
    80003b2e:	ec4e                	sd	s3,24(sp)
    80003b30:	e852                	sd	s4,16(sp)
    80003b32:	e456                	sd	s5,8(sp)
    80003b34:	e05a                	sd	s6,0(sp)
    80003b36:	0080                	add	s0,sp,64
    80003b38:	8b2a                	mv	s6,a0
    80003b3a:	0002ea97          	auipc	s5,0x2e
    80003b3e:	e56a8a93          	add	s5,s5,-426 # 80031990 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b42:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b44:	0002e997          	auipc	s3,0x2e
    80003b48:	e1c98993          	add	s3,s3,-484 # 80031960 <log>
    80003b4c:	a829                	j	80003b66 <install_trans+0x4e>
    brelse(lbuf);
    80003b4e:	854a                	mv	a0,s2
    80003b50:	a7aff0ef          	jal	80002dca <brelse>
    brelse(dbuf);
    80003b54:	8526                	mv	a0,s1
    80003b56:	a74ff0ef          	jal	80002dca <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b5a:	2a05                	addw	s4,s4,1
    80003b5c:	0a91                	add	s5,s5,4
    80003b5e:	02c9a783          	lw	a5,44(s3)
    80003b62:	04fa5463          	bge	s4,a5,80003baa <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b66:	0189a583          	lw	a1,24(s3)
    80003b6a:	014585bb          	addw	a1,a1,s4
    80003b6e:	2585                	addw	a1,a1,1
    80003b70:	0289a503          	lw	a0,40(s3)
    80003b74:	94eff0ef          	jal	80002cc2 <bread>
    80003b78:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003b7a:	000aa583          	lw	a1,0(s5)
    80003b7e:	0289a503          	lw	a0,40(s3)
    80003b82:	940ff0ef          	jal	80002cc2 <bread>
    80003b86:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003b88:	40000613          	li	a2,1024
    80003b8c:	05890593          	add	a1,s2,88
    80003b90:	05850513          	add	a0,a0,88
    80003b94:	93cfd0ef          	jal	80000cd0 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003b98:	8526                	mv	a0,s1
    80003b9a:	9feff0ef          	jal	80002d98 <bwrite>
    if(recovering == 0)
    80003b9e:	fa0b18e3          	bnez	s6,80003b4e <install_trans+0x36>
      bunpin(dbuf);
    80003ba2:	8526                	mv	a0,s1
    80003ba4:	ae2ff0ef          	jal	80002e86 <bunpin>
    80003ba8:	b75d                	j	80003b4e <install_trans+0x36>
}
    80003baa:	70e2                	ld	ra,56(sp)
    80003bac:	7442                	ld	s0,48(sp)
    80003bae:	74a2                	ld	s1,40(sp)
    80003bb0:	7902                	ld	s2,32(sp)
    80003bb2:	69e2                	ld	s3,24(sp)
    80003bb4:	6a42                	ld	s4,16(sp)
    80003bb6:	6aa2                	ld	s5,8(sp)
    80003bb8:	6b02                	ld	s6,0(sp)
    80003bba:	6121                	add	sp,sp,64
    80003bbc:	8082                	ret
    80003bbe:	8082                	ret

0000000080003bc0 <initlog>:
{
    80003bc0:	7179                	add	sp,sp,-48
    80003bc2:	f406                	sd	ra,40(sp)
    80003bc4:	f022                	sd	s0,32(sp)
    80003bc6:	ec26                	sd	s1,24(sp)
    80003bc8:	e84a                	sd	s2,16(sp)
    80003bca:	e44e                	sd	s3,8(sp)
    80003bcc:	1800                	add	s0,sp,48
    80003bce:	892a                	mv	s2,a0
    80003bd0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003bd2:	0002e497          	auipc	s1,0x2e
    80003bd6:	d8e48493          	add	s1,s1,-626 # 80031960 <log>
    80003bda:	00004597          	auipc	a1,0x4
    80003bde:	ad658593          	add	a1,a1,-1322 # 800076b0 <syscalls+0x220>
    80003be2:	8526                	mv	a0,s1
    80003be4:	f3dfc0ef          	jal	80000b20 <initlock>
  log.start = sb->logstart;
    80003be8:	0149a583          	lw	a1,20(s3)
    80003bec:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003bee:	0109a783          	lw	a5,16(s3)
    80003bf2:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003bf4:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003bf8:	854a                	mv	a0,s2
    80003bfa:	8c8ff0ef          	jal	80002cc2 <bread>
  log.lh.n = lh->n;
    80003bfe:	4d30                	lw	a2,88(a0)
    80003c00:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003c02:	00c05f63          	blez	a2,80003c20 <initlog+0x60>
    80003c06:	87aa                	mv	a5,a0
    80003c08:	0002e717          	auipc	a4,0x2e
    80003c0c:	d8870713          	add	a4,a4,-632 # 80031990 <log+0x30>
    80003c10:	060a                	sll	a2,a2,0x2
    80003c12:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003c14:	4ff4                	lw	a3,92(a5)
    80003c16:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003c18:	0791                	add	a5,a5,4
    80003c1a:	0711                	add	a4,a4,4
    80003c1c:	fec79ce3          	bne	a5,a2,80003c14 <initlog+0x54>
  brelse(buf);
    80003c20:	9aaff0ef          	jal	80002dca <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003c24:	4505                	li	a0,1
    80003c26:	ef3ff0ef          	jal	80003b18 <install_trans>
  log.lh.n = 0;
    80003c2a:	0002e797          	auipc	a5,0x2e
    80003c2e:	d607a123          	sw	zero,-670(a5) # 8003198c <log+0x2c>
  write_head(); // clear the log
    80003c32:	e89ff0ef          	jal	80003aba <write_head>
}
    80003c36:	70a2                	ld	ra,40(sp)
    80003c38:	7402                	ld	s0,32(sp)
    80003c3a:	64e2                	ld	s1,24(sp)
    80003c3c:	6942                	ld	s2,16(sp)
    80003c3e:	69a2                	ld	s3,8(sp)
    80003c40:	6145                	add	sp,sp,48
    80003c42:	8082                	ret

0000000080003c44 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003c44:	1101                	add	sp,sp,-32
    80003c46:	ec06                	sd	ra,24(sp)
    80003c48:	e822                	sd	s0,16(sp)
    80003c4a:	e426                	sd	s1,8(sp)
    80003c4c:	e04a                	sd	s2,0(sp)
    80003c4e:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80003c50:	0002e517          	auipc	a0,0x2e
    80003c54:	d1050513          	add	a0,a0,-752 # 80031960 <log>
    80003c58:	f49fc0ef          	jal	80000ba0 <acquire>
  while(1){
    if(log.committing){
    80003c5c:	0002e497          	auipc	s1,0x2e
    80003c60:	d0448493          	add	s1,s1,-764 # 80031960 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003c64:	4979                	li	s2,30
    80003c66:	a029                	j	80003c70 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003c68:	85a6                	mv	a1,s1
    80003c6a:	8526                	mv	a0,s1
    80003c6c:	a3afe0ef          	jal	80001ea6 <sleep>
    if(log.committing){
    80003c70:	50dc                	lw	a5,36(s1)
    80003c72:	fbfd                	bnez	a5,80003c68 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003c74:	5098                	lw	a4,32(s1)
    80003c76:	2705                	addw	a4,a4,1
    80003c78:	0027179b          	sllw	a5,a4,0x2
    80003c7c:	9fb9                	addw	a5,a5,a4
    80003c7e:	0017979b          	sllw	a5,a5,0x1
    80003c82:	54d4                	lw	a3,44(s1)
    80003c84:	9fb5                	addw	a5,a5,a3
    80003c86:	00f95763          	bge	s2,a5,80003c94 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003c8a:	85a6                	mv	a1,s1
    80003c8c:	8526                	mv	a0,s1
    80003c8e:	a18fe0ef          	jal	80001ea6 <sleep>
    80003c92:	bff9                	j	80003c70 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003c94:	0002e517          	auipc	a0,0x2e
    80003c98:	ccc50513          	add	a0,a0,-820 # 80031960 <log>
    80003c9c:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003c9e:	f9bfc0ef          	jal	80000c38 <release>
      break;
    }
  }
}
    80003ca2:	60e2                	ld	ra,24(sp)
    80003ca4:	6442                	ld	s0,16(sp)
    80003ca6:	64a2                	ld	s1,8(sp)
    80003ca8:	6902                	ld	s2,0(sp)
    80003caa:	6105                	add	sp,sp,32
    80003cac:	8082                	ret

0000000080003cae <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003cae:	7139                	add	sp,sp,-64
    80003cb0:	fc06                	sd	ra,56(sp)
    80003cb2:	f822                	sd	s0,48(sp)
    80003cb4:	f426                	sd	s1,40(sp)
    80003cb6:	f04a                	sd	s2,32(sp)
    80003cb8:	ec4e                	sd	s3,24(sp)
    80003cba:	e852                	sd	s4,16(sp)
    80003cbc:	e456                	sd	s5,8(sp)
    80003cbe:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003cc0:	0002e497          	auipc	s1,0x2e
    80003cc4:	ca048493          	add	s1,s1,-864 # 80031960 <log>
    80003cc8:	8526                	mv	a0,s1
    80003cca:	ed7fc0ef          	jal	80000ba0 <acquire>
  log.outstanding -= 1;
    80003cce:	509c                	lw	a5,32(s1)
    80003cd0:	37fd                	addw	a5,a5,-1
    80003cd2:	0007891b          	sext.w	s2,a5
    80003cd6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003cd8:	50dc                	lw	a5,36(s1)
    80003cda:	ef9d                	bnez	a5,80003d18 <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003cdc:	04091463          	bnez	s2,80003d24 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003ce0:	0002e497          	auipc	s1,0x2e
    80003ce4:	c8048493          	add	s1,s1,-896 # 80031960 <log>
    80003ce8:	4785                	li	a5,1
    80003cea:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003cec:	8526                	mv	a0,s1
    80003cee:	f4bfc0ef          	jal	80000c38 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003cf2:	54dc                	lw	a5,44(s1)
    80003cf4:	04f04b63          	bgtz	a5,80003d4a <end_op+0x9c>
    acquire(&log.lock);
    80003cf8:	0002e497          	auipc	s1,0x2e
    80003cfc:	c6848493          	add	s1,s1,-920 # 80031960 <log>
    80003d00:	8526                	mv	a0,s1
    80003d02:	e9ffc0ef          	jal	80000ba0 <acquire>
    log.committing = 0;
    80003d06:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003d0a:	8526                	mv	a0,s1
    80003d0c:	9e6fe0ef          	jal	80001ef2 <wakeup>
    release(&log.lock);
    80003d10:	8526                	mv	a0,s1
    80003d12:	f27fc0ef          	jal	80000c38 <release>
}
    80003d16:	a00d                	j	80003d38 <end_op+0x8a>
    panic("log.committing");
    80003d18:	00004517          	auipc	a0,0x4
    80003d1c:	9a050513          	add	a0,a0,-1632 # 800076b8 <syscalls+0x228>
    80003d20:	a3ffc0ef          	jal	8000075e <panic>
    wakeup(&log);
    80003d24:	0002e497          	auipc	s1,0x2e
    80003d28:	c3c48493          	add	s1,s1,-964 # 80031960 <log>
    80003d2c:	8526                	mv	a0,s1
    80003d2e:	9c4fe0ef          	jal	80001ef2 <wakeup>
  release(&log.lock);
    80003d32:	8526                	mv	a0,s1
    80003d34:	f05fc0ef          	jal	80000c38 <release>
}
    80003d38:	70e2                	ld	ra,56(sp)
    80003d3a:	7442                	ld	s0,48(sp)
    80003d3c:	74a2                	ld	s1,40(sp)
    80003d3e:	7902                	ld	s2,32(sp)
    80003d40:	69e2                	ld	s3,24(sp)
    80003d42:	6a42                	ld	s4,16(sp)
    80003d44:	6aa2                	ld	s5,8(sp)
    80003d46:	6121                	add	sp,sp,64
    80003d48:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d4a:	0002ea97          	auipc	s5,0x2e
    80003d4e:	c46a8a93          	add	s5,s5,-954 # 80031990 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003d52:	0002ea17          	auipc	s4,0x2e
    80003d56:	c0ea0a13          	add	s4,s4,-1010 # 80031960 <log>
    80003d5a:	018a2583          	lw	a1,24(s4)
    80003d5e:	012585bb          	addw	a1,a1,s2
    80003d62:	2585                	addw	a1,a1,1
    80003d64:	028a2503          	lw	a0,40(s4)
    80003d68:	f5bfe0ef          	jal	80002cc2 <bread>
    80003d6c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003d6e:	000aa583          	lw	a1,0(s5)
    80003d72:	028a2503          	lw	a0,40(s4)
    80003d76:	f4dfe0ef          	jal	80002cc2 <bread>
    80003d7a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003d7c:	40000613          	li	a2,1024
    80003d80:	05850593          	add	a1,a0,88
    80003d84:	05848513          	add	a0,s1,88
    80003d88:	f49fc0ef          	jal	80000cd0 <memmove>
    bwrite(to);  // write the log
    80003d8c:	8526                	mv	a0,s1
    80003d8e:	80aff0ef          	jal	80002d98 <bwrite>
    brelse(from);
    80003d92:	854e                	mv	a0,s3
    80003d94:	836ff0ef          	jal	80002dca <brelse>
    brelse(to);
    80003d98:	8526                	mv	a0,s1
    80003d9a:	830ff0ef          	jal	80002dca <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d9e:	2905                	addw	s2,s2,1
    80003da0:	0a91                	add	s5,s5,4
    80003da2:	02ca2783          	lw	a5,44(s4)
    80003da6:	faf94ae3          	blt	s2,a5,80003d5a <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003daa:	d11ff0ef          	jal	80003aba <write_head>
    install_trans(0); // Now install writes to home locations
    80003dae:	4501                	li	a0,0
    80003db0:	d69ff0ef          	jal	80003b18 <install_trans>
    log.lh.n = 0;
    80003db4:	0002e797          	auipc	a5,0x2e
    80003db8:	bc07ac23          	sw	zero,-1064(a5) # 8003198c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003dbc:	cffff0ef          	jal	80003aba <write_head>
    80003dc0:	bf25                	j	80003cf8 <end_op+0x4a>

0000000080003dc2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003dc2:	1101                	add	sp,sp,-32
    80003dc4:	ec06                	sd	ra,24(sp)
    80003dc6:	e822                	sd	s0,16(sp)
    80003dc8:	e426                	sd	s1,8(sp)
    80003dca:	e04a                	sd	s2,0(sp)
    80003dcc:	1000                	add	s0,sp,32
    80003dce:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003dd0:	0002e917          	auipc	s2,0x2e
    80003dd4:	b9090913          	add	s2,s2,-1136 # 80031960 <log>
    80003dd8:	854a                	mv	a0,s2
    80003dda:	dc7fc0ef          	jal	80000ba0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003dde:	02c92603          	lw	a2,44(s2)
    80003de2:	47f5                	li	a5,29
    80003de4:	06c7c363          	blt	a5,a2,80003e4a <log_write+0x88>
    80003de8:	0002e797          	auipc	a5,0x2e
    80003dec:	b947a783          	lw	a5,-1132(a5) # 8003197c <log+0x1c>
    80003df0:	37fd                	addw	a5,a5,-1
    80003df2:	04f65c63          	bge	a2,a5,80003e4a <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003df6:	0002e797          	auipc	a5,0x2e
    80003dfa:	b8a7a783          	lw	a5,-1142(a5) # 80031980 <log+0x20>
    80003dfe:	04f05c63          	blez	a5,80003e56 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003e02:	4781                	li	a5,0
    80003e04:	04c05f63          	blez	a2,80003e62 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003e08:	44cc                	lw	a1,12(s1)
    80003e0a:	0002e717          	auipc	a4,0x2e
    80003e0e:	b8670713          	add	a4,a4,-1146 # 80031990 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003e12:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003e14:	4314                	lw	a3,0(a4)
    80003e16:	04b68663          	beq	a3,a1,80003e62 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003e1a:	2785                	addw	a5,a5,1
    80003e1c:	0711                	add	a4,a4,4
    80003e1e:	fef61be3          	bne	a2,a5,80003e14 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003e22:	0621                	add	a2,a2,8
    80003e24:	060a                	sll	a2,a2,0x2
    80003e26:	0002e797          	auipc	a5,0x2e
    80003e2a:	b3a78793          	add	a5,a5,-1222 # 80031960 <log>
    80003e2e:	97b2                	add	a5,a5,a2
    80003e30:	44d8                	lw	a4,12(s1)
    80003e32:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003e34:	8526                	mv	a0,s1
    80003e36:	81cff0ef          	jal	80002e52 <bpin>
    log.lh.n++;
    80003e3a:	0002e717          	auipc	a4,0x2e
    80003e3e:	b2670713          	add	a4,a4,-1242 # 80031960 <log>
    80003e42:	575c                	lw	a5,44(a4)
    80003e44:	2785                	addw	a5,a5,1
    80003e46:	d75c                	sw	a5,44(a4)
    80003e48:	a80d                	j	80003e7a <log_write+0xb8>
    panic("too big a transaction");
    80003e4a:	00004517          	auipc	a0,0x4
    80003e4e:	87e50513          	add	a0,a0,-1922 # 800076c8 <syscalls+0x238>
    80003e52:	90dfc0ef          	jal	8000075e <panic>
    panic("log_write outside of trans");
    80003e56:	00004517          	auipc	a0,0x4
    80003e5a:	88a50513          	add	a0,a0,-1910 # 800076e0 <syscalls+0x250>
    80003e5e:	901fc0ef          	jal	8000075e <panic>
  log.lh.block[i] = b->blockno;
    80003e62:	00878693          	add	a3,a5,8
    80003e66:	068a                	sll	a3,a3,0x2
    80003e68:	0002e717          	auipc	a4,0x2e
    80003e6c:	af870713          	add	a4,a4,-1288 # 80031960 <log>
    80003e70:	9736                	add	a4,a4,a3
    80003e72:	44d4                	lw	a3,12(s1)
    80003e74:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003e76:	faf60fe3          	beq	a2,a5,80003e34 <log_write+0x72>
  }
  release(&log.lock);
    80003e7a:	0002e517          	auipc	a0,0x2e
    80003e7e:	ae650513          	add	a0,a0,-1306 # 80031960 <log>
    80003e82:	db7fc0ef          	jal	80000c38 <release>
}
    80003e86:	60e2                	ld	ra,24(sp)
    80003e88:	6442                	ld	s0,16(sp)
    80003e8a:	64a2                	ld	s1,8(sp)
    80003e8c:	6902                	ld	s2,0(sp)
    80003e8e:	6105                	add	sp,sp,32
    80003e90:	8082                	ret

0000000080003e92 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003e92:	1101                	add	sp,sp,-32
    80003e94:	ec06                	sd	ra,24(sp)
    80003e96:	e822                	sd	s0,16(sp)
    80003e98:	e426                	sd	s1,8(sp)
    80003e9a:	e04a                	sd	s2,0(sp)
    80003e9c:	1000                	add	s0,sp,32
    80003e9e:	84aa                	mv	s1,a0
    80003ea0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003ea2:	00004597          	auipc	a1,0x4
    80003ea6:	85e58593          	add	a1,a1,-1954 # 80007700 <syscalls+0x270>
    80003eaa:	0521                	add	a0,a0,8
    80003eac:	c75fc0ef          	jal	80000b20 <initlock>
  lk->name = name;
    80003eb0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003eb4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003eb8:	0204a423          	sw	zero,40(s1)
}
    80003ebc:	60e2                	ld	ra,24(sp)
    80003ebe:	6442                	ld	s0,16(sp)
    80003ec0:	64a2                	ld	s1,8(sp)
    80003ec2:	6902                	ld	s2,0(sp)
    80003ec4:	6105                	add	sp,sp,32
    80003ec6:	8082                	ret

0000000080003ec8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003ec8:	1101                	add	sp,sp,-32
    80003eca:	ec06                	sd	ra,24(sp)
    80003ecc:	e822                	sd	s0,16(sp)
    80003ece:	e426                	sd	s1,8(sp)
    80003ed0:	e04a                	sd	s2,0(sp)
    80003ed2:	1000                	add	s0,sp,32
    80003ed4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ed6:	00850913          	add	s2,a0,8
    80003eda:	854a                	mv	a0,s2
    80003edc:	cc5fc0ef          	jal	80000ba0 <acquire>
  while (lk->locked) {
    80003ee0:	409c                	lw	a5,0(s1)
    80003ee2:	c799                	beqz	a5,80003ef0 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003ee4:	85ca                	mv	a1,s2
    80003ee6:	8526                	mv	a0,s1
    80003ee8:	fbffd0ef          	jal	80001ea6 <sleep>
  while (lk->locked) {
    80003eec:	409c                	lw	a5,0(s1)
    80003eee:	fbfd                	bnez	a5,80003ee4 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003ef0:	4785                	li	a5,1
    80003ef2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003ef4:	93dfd0ef          	jal	80001830 <myproc>
    80003ef8:	591c                	lw	a5,48(a0)
    80003efa:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003efc:	854a                	mv	a0,s2
    80003efe:	d3bfc0ef          	jal	80000c38 <release>
}
    80003f02:	60e2                	ld	ra,24(sp)
    80003f04:	6442                	ld	s0,16(sp)
    80003f06:	64a2                	ld	s1,8(sp)
    80003f08:	6902                	ld	s2,0(sp)
    80003f0a:	6105                	add	sp,sp,32
    80003f0c:	8082                	ret

0000000080003f0e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003f0e:	1101                	add	sp,sp,-32
    80003f10:	ec06                	sd	ra,24(sp)
    80003f12:	e822                	sd	s0,16(sp)
    80003f14:	e426                	sd	s1,8(sp)
    80003f16:	e04a                	sd	s2,0(sp)
    80003f18:	1000                	add	s0,sp,32
    80003f1a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003f1c:	00850913          	add	s2,a0,8
    80003f20:	854a                	mv	a0,s2
    80003f22:	c7ffc0ef          	jal	80000ba0 <acquire>
  lk->locked = 0;
    80003f26:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003f2a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003f2e:	8526                	mv	a0,s1
    80003f30:	fc3fd0ef          	jal	80001ef2 <wakeup>
  release(&lk->lk);
    80003f34:	854a                	mv	a0,s2
    80003f36:	d03fc0ef          	jal	80000c38 <release>
}
    80003f3a:	60e2                	ld	ra,24(sp)
    80003f3c:	6442                	ld	s0,16(sp)
    80003f3e:	64a2                	ld	s1,8(sp)
    80003f40:	6902                	ld	s2,0(sp)
    80003f42:	6105                	add	sp,sp,32
    80003f44:	8082                	ret

0000000080003f46 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003f46:	7179                	add	sp,sp,-48
    80003f48:	f406                	sd	ra,40(sp)
    80003f4a:	f022                	sd	s0,32(sp)
    80003f4c:	ec26                	sd	s1,24(sp)
    80003f4e:	e84a                	sd	s2,16(sp)
    80003f50:	e44e                	sd	s3,8(sp)
    80003f52:	1800                	add	s0,sp,48
    80003f54:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003f56:	00850913          	add	s2,a0,8
    80003f5a:	854a                	mv	a0,s2
    80003f5c:	c45fc0ef          	jal	80000ba0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f60:	409c                	lw	a5,0(s1)
    80003f62:	ef89                	bnez	a5,80003f7c <holdingsleep+0x36>
    80003f64:	4481                	li	s1,0
  release(&lk->lk);
    80003f66:	854a                	mv	a0,s2
    80003f68:	cd1fc0ef          	jal	80000c38 <release>
  return r;
}
    80003f6c:	8526                	mv	a0,s1
    80003f6e:	70a2                	ld	ra,40(sp)
    80003f70:	7402                	ld	s0,32(sp)
    80003f72:	64e2                	ld	s1,24(sp)
    80003f74:	6942                	ld	s2,16(sp)
    80003f76:	69a2                	ld	s3,8(sp)
    80003f78:	6145                	add	sp,sp,48
    80003f7a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f7c:	0284a983          	lw	s3,40(s1)
    80003f80:	8b1fd0ef          	jal	80001830 <myproc>
    80003f84:	5904                	lw	s1,48(a0)
    80003f86:	413484b3          	sub	s1,s1,s3
    80003f8a:	0014b493          	seqz	s1,s1
    80003f8e:	bfe1                	j	80003f66 <holdingsleep+0x20>

0000000080003f90 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003f90:	1141                	add	sp,sp,-16
    80003f92:	e406                	sd	ra,8(sp)
    80003f94:	e022                	sd	s0,0(sp)
    80003f96:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003f98:	00003597          	auipc	a1,0x3
    80003f9c:	77858593          	add	a1,a1,1912 # 80007710 <syscalls+0x280>
    80003fa0:	0002e517          	auipc	a0,0x2e
    80003fa4:	b0850513          	add	a0,a0,-1272 # 80031aa8 <ftable>
    80003fa8:	b79fc0ef          	jal	80000b20 <initlock>
}
    80003fac:	60a2                	ld	ra,8(sp)
    80003fae:	6402                	ld	s0,0(sp)
    80003fb0:	0141                	add	sp,sp,16
    80003fb2:	8082                	ret

0000000080003fb4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003fb4:	1101                	add	sp,sp,-32
    80003fb6:	ec06                	sd	ra,24(sp)
    80003fb8:	e822                	sd	s0,16(sp)
    80003fba:	e426                	sd	s1,8(sp)
    80003fbc:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003fbe:	0002e517          	auipc	a0,0x2e
    80003fc2:	aea50513          	add	a0,a0,-1302 # 80031aa8 <ftable>
    80003fc6:	bdbfc0ef          	jal	80000ba0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003fca:	0002e497          	auipc	s1,0x2e
    80003fce:	af648493          	add	s1,s1,-1290 # 80031ac0 <ftable+0x18>
    80003fd2:	0002f717          	auipc	a4,0x2f
    80003fd6:	a8e70713          	add	a4,a4,-1394 # 80032a60 <disk>
    if(f->ref == 0){
    80003fda:	40dc                	lw	a5,4(s1)
    80003fdc:	cf89                	beqz	a5,80003ff6 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003fde:	02848493          	add	s1,s1,40
    80003fe2:	fee49ce3          	bne	s1,a4,80003fda <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003fe6:	0002e517          	auipc	a0,0x2e
    80003fea:	ac250513          	add	a0,a0,-1342 # 80031aa8 <ftable>
    80003fee:	c4bfc0ef          	jal	80000c38 <release>
  return 0;
    80003ff2:	4481                	li	s1,0
    80003ff4:	a809                	j	80004006 <filealloc+0x52>
      f->ref = 1;
    80003ff6:	4785                	li	a5,1
    80003ff8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ffa:	0002e517          	auipc	a0,0x2e
    80003ffe:	aae50513          	add	a0,a0,-1362 # 80031aa8 <ftable>
    80004002:	c37fc0ef          	jal	80000c38 <release>
}
    80004006:	8526                	mv	a0,s1
    80004008:	60e2                	ld	ra,24(sp)
    8000400a:	6442                	ld	s0,16(sp)
    8000400c:	64a2                	ld	s1,8(sp)
    8000400e:	6105                	add	sp,sp,32
    80004010:	8082                	ret

0000000080004012 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004012:	1101                	add	sp,sp,-32
    80004014:	ec06                	sd	ra,24(sp)
    80004016:	e822                	sd	s0,16(sp)
    80004018:	e426                	sd	s1,8(sp)
    8000401a:	1000                	add	s0,sp,32
    8000401c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000401e:	0002e517          	auipc	a0,0x2e
    80004022:	a8a50513          	add	a0,a0,-1398 # 80031aa8 <ftable>
    80004026:	b7bfc0ef          	jal	80000ba0 <acquire>
  if(f->ref < 1)
    8000402a:	40dc                	lw	a5,4(s1)
    8000402c:	02f05063          	blez	a5,8000404c <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004030:	2785                	addw	a5,a5,1
    80004032:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004034:	0002e517          	auipc	a0,0x2e
    80004038:	a7450513          	add	a0,a0,-1420 # 80031aa8 <ftable>
    8000403c:	bfdfc0ef          	jal	80000c38 <release>
  return f;
}
    80004040:	8526                	mv	a0,s1
    80004042:	60e2                	ld	ra,24(sp)
    80004044:	6442                	ld	s0,16(sp)
    80004046:	64a2                	ld	s1,8(sp)
    80004048:	6105                	add	sp,sp,32
    8000404a:	8082                	ret
    panic("filedup");
    8000404c:	00003517          	auipc	a0,0x3
    80004050:	6cc50513          	add	a0,a0,1740 # 80007718 <syscalls+0x288>
    80004054:	f0afc0ef          	jal	8000075e <panic>

0000000080004058 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004058:	7139                	add	sp,sp,-64
    8000405a:	fc06                	sd	ra,56(sp)
    8000405c:	f822                	sd	s0,48(sp)
    8000405e:	f426                	sd	s1,40(sp)
    80004060:	f04a                	sd	s2,32(sp)
    80004062:	ec4e                	sd	s3,24(sp)
    80004064:	e852                	sd	s4,16(sp)
    80004066:	e456                	sd	s5,8(sp)
    80004068:	0080                	add	s0,sp,64
    8000406a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000406c:	0002e517          	auipc	a0,0x2e
    80004070:	a3c50513          	add	a0,a0,-1476 # 80031aa8 <ftable>
    80004074:	b2dfc0ef          	jal	80000ba0 <acquire>
  if(f->ref < 1)
    80004078:	40dc                	lw	a5,4(s1)
    8000407a:	04f05963          	blez	a5,800040cc <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    8000407e:	37fd                	addw	a5,a5,-1
    80004080:	0007871b          	sext.w	a4,a5
    80004084:	c0dc                	sw	a5,4(s1)
    80004086:	04e04963          	bgtz	a4,800040d8 <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000408a:	0004a903          	lw	s2,0(s1)
    8000408e:	0094ca83          	lbu	s5,9(s1)
    80004092:	0104ba03          	ld	s4,16(s1)
    80004096:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000409a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000409e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800040a2:	0002e517          	auipc	a0,0x2e
    800040a6:	a0650513          	add	a0,a0,-1530 # 80031aa8 <ftable>
    800040aa:	b8ffc0ef          	jal	80000c38 <release>

  if(ff.type == FD_PIPE){
    800040ae:	4785                	li	a5,1
    800040b0:	04f90363          	beq	s2,a5,800040f6 <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800040b4:	3979                	addw	s2,s2,-2
    800040b6:	4785                	li	a5,1
    800040b8:	0327e663          	bltu	a5,s2,800040e4 <fileclose+0x8c>
    begin_op();
    800040bc:	b89ff0ef          	jal	80003c44 <begin_op>
    iput(ff.ip);
    800040c0:	854e                	mv	a0,s3
    800040c2:	c92ff0ef          	jal	80003554 <iput>
    end_op();
    800040c6:	be9ff0ef          	jal	80003cae <end_op>
    800040ca:	a829                	j	800040e4 <fileclose+0x8c>
    panic("fileclose");
    800040cc:	00003517          	auipc	a0,0x3
    800040d0:	65450513          	add	a0,a0,1620 # 80007720 <syscalls+0x290>
    800040d4:	e8afc0ef          	jal	8000075e <panic>
    release(&ftable.lock);
    800040d8:	0002e517          	auipc	a0,0x2e
    800040dc:	9d050513          	add	a0,a0,-1584 # 80031aa8 <ftable>
    800040e0:	b59fc0ef          	jal	80000c38 <release>
  }
}
    800040e4:	70e2                	ld	ra,56(sp)
    800040e6:	7442                	ld	s0,48(sp)
    800040e8:	74a2                	ld	s1,40(sp)
    800040ea:	7902                	ld	s2,32(sp)
    800040ec:	69e2                	ld	s3,24(sp)
    800040ee:	6a42                	ld	s4,16(sp)
    800040f0:	6aa2                	ld	s5,8(sp)
    800040f2:	6121                	add	sp,sp,64
    800040f4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800040f6:	85d6                	mv	a1,s5
    800040f8:	8552                	mv	a0,s4
    800040fa:	2e8000ef          	jal	800043e2 <pipeclose>
    800040fe:	b7dd                	j	800040e4 <fileclose+0x8c>

0000000080004100 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004100:	715d                	add	sp,sp,-80
    80004102:	e486                	sd	ra,72(sp)
    80004104:	e0a2                	sd	s0,64(sp)
    80004106:	fc26                	sd	s1,56(sp)
    80004108:	f84a                	sd	s2,48(sp)
    8000410a:	f44e                	sd	s3,40(sp)
    8000410c:	0880                	add	s0,sp,80
    8000410e:	84aa                	mv	s1,a0
    80004110:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004112:	f1efd0ef          	jal	80001830 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004116:	409c                	lw	a5,0(s1)
    80004118:	37f9                	addw	a5,a5,-2
    8000411a:	4705                	li	a4,1
    8000411c:	02f76f63          	bltu	a4,a5,8000415a <filestat+0x5a>
    80004120:	892a                	mv	s2,a0
    ilock(f->ip);
    80004122:	6c88                	ld	a0,24(s1)
    80004124:	ab2ff0ef          	jal	800033d6 <ilock>
    stati(f->ip, &st);
    80004128:	fb840593          	add	a1,s0,-72
    8000412c:	6c88                	ld	a0,24(s1)
    8000412e:	cceff0ef          	jal	800035fc <stati>
    iunlock(f->ip);
    80004132:	6c88                	ld	a0,24(s1)
    80004134:	b4cff0ef          	jal	80003480 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004138:	46e1                	li	a3,24
    8000413a:	fb840613          	add	a2,s0,-72
    8000413e:	85ce                	mv	a1,s3
    80004140:	05093503          	ld	a0,80(s2)
    80004144:	ba4fd0ef          	jal	800014e8 <copyout>
    80004148:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000414c:	60a6                	ld	ra,72(sp)
    8000414e:	6406                	ld	s0,64(sp)
    80004150:	74e2                	ld	s1,56(sp)
    80004152:	7942                	ld	s2,48(sp)
    80004154:	79a2                	ld	s3,40(sp)
    80004156:	6161                	add	sp,sp,80
    80004158:	8082                	ret
  return -1;
    8000415a:	557d                	li	a0,-1
    8000415c:	bfc5                	j	8000414c <filestat+0x4c>

000000008000415e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000415e:	7179                	add	sp,sp,-48
    80004160:	f406                	sd	ra,40(sp)
    80004162:	f022                	sd	s0,32(sp)
    80004164:	ec26                	sd	s1,24(sp)
    80004166:	e84a                	sd	s2,16(sp)
    80004168:	e44e                	sd	s3,8(sp)
    8000416a:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000416c:	00854783          	lbu	a5,8(a0)
    80004170:	cbc1                	beqz	a5,80004200 <fileread+0xa2>
    80004172:	84aa                	mv	s1,a0
    80004174:	89ae                	mv	s3,a1
    80004176:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004178:	411c                	lw	a5,0(a0)
    8000417a:	4705                	li	a4,1
    8000417c:	04e78363          	beq	a5,a4,800041c2 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004180:	470d                	li	a4,3
    80004182:	04e78563          	beq	a5,a4,800041cc <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004186:	4709                	li	a4,2
    80004188:	06e79663          	bne	a5,a4,800041f4 <fileread+0x96>
    ilock(f->ip);
    8000418c:	6d08                	ld	a0,24(a0)
    8000418e:	a48ff0ef          	jal	800033d6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004192:	874a                	mv	a4,s2
    80004194:	5094                	lw	a3,32(s1)
    80004196:	864e                	mv	a2,s3
    80004198:	4585                	li	a1,1
    8000419a:	6c88                	ld	a0,24(s1)
    8000419c:	c8aff0ef          	jal	80003626 <readi>
    800041a0:	892a                	mv	s2,a0
    800041a2:	00a05563          	blez	a0,800041ac <fileread+0x4e>
      f->off += r;
    800041a6:	509c                	lw	a5,32(s1)
    800041a8:	9fa9                	addw	a5,a5,a0
    800041aa:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800041ac:	6c88                	ld	a0,24(s1)
    800041ae:	ad2ff0ef          	jal	80003480 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800041b2:	854a                	mv	a0,s2
    800041b4:	70a2                	ld	ra,40(sp)
    800041b6:	7402                	ld	s0,32(sp)
    800041b8:	64e2                	ld	s1,24(sp)
    800041ba:	6942                	ld	s2,16(sp)
    800041bc:	69a2                	ld	s3,8(sp)
    800041be:	6145                	add	sp,sp,48
    800041c0:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800041c2:	6908                	ld	a0,16(a0)
    800041c4:	34a000ef          	jal	8000450e <piperead>
    800041c8:	892a                	mv	s2,a0
    800041ca:	b7e5                	j	800041b2 <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800041cc:	02451783          	lh	a5,36(a0)
    800041d0:	03079693          	sll	a3,a5,0x30
    800041d4:	92c1                	srl	a3,a3,0x30
    800041d6:	4725                	li	a4,9
    800041d8:	02d76663          	bltu	a4,a3,80004204 <fileread+0xa6>
    800041dc:	0792                	sll	a5,a5,0x4
    800041de:	0002e717          	auipc	a4,0x2e
    800041e2:	82a70713          	add	a4,a4,-2006 # 80031a08 <devsw>
    800041e6:	97ba                	add	a5,a5,a4
    800041e8:	639c                	ld	a5,0(a5)
    800041ea:	cf99                	beqz	a5,80004208 <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    800041ec:	4505                	li	a0,1
    800041ee:	9782                	jalr	a5
    800041f0:	892a                	mv	s2,a0
    800041f2:	b7c1                	j	800041b2 <fileread+0x54>
    panic("fileread");
    800041f4:	00003517          	auipc	a0,0x3
    800041f8:	53c50513          	add	a0,a0,1340 # 80007730 <syscalls+0x2a0>
    800041fc:	d62fc0ef          	jal	8000075e <panic>
    return -1;
    80004200:	597d                	li	s2,-1
    80004202:	bf45                	j	800041b2 <fileread+0x54>
      return -1;
    80004204:	597d                	li	s2,-1
    80004206:	b775                	j	800041b2 <fileread+0x54>
    80004208:	597d                	li	s2,-1
    8000420a:	b765                	j	800041b2 <fileread+0x54>

000000008000420c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000420c:	00954783          	lbu	a5,9(a0)
    80004210:	10078063          	beqz	a5,80004310 <filewrite+0x104>
{
    80004214:	715d                	add	sp,sp,-80
    80004216:	e486                	sd	ra,72(sp)
    80004218:	e0a2                	sd	s0,64(sp)
    8000421a:	fc26                	sd	s1,56(sp)
    8000421c:	f84a                	sd	s2,48(sp)
    8000421e:	f44e                	sd	s3,40(sp)
    80004220:	f052                	sd	s4,32(sp)
    80004222:	ec56                	sd	s5,24(sp)
    80004224:	e85a                	sd	s6,16(sp)
    80004226:	e45e                	sd	s7,8(sp)
    80004228:	e062                	sd	s8,0(sp)
    8000422a:	0880                	add	s0,sp,80
    8000422c:	892a                	mv	s2,a0
    8000422e:	8b2e                	mv	s6,a1
    80004230:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004232:	411c                	lw	a5,0(a0)
    80004234:	4705                	li	a4,1
    80004236:	02e78263          	beq	a5,a4,8000425a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000423a:	470d                	li	a4,3
    8000423c:	02e78363          	beq	a5,a4,80004262 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004240:	4709                	li	a4,2
    80004242:	0ce79163          	bne	a5,a4,80004304 <filewrite+0xf8>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004246:	08c05f63          	blez	a2,800042e4 <filewrite+0xd8>
    int i = 0;
    8000424a:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000424c:	6b85                	lui	s7,0x1
    8000424e:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004252:	6c05                	lui	s8,0x1
    80004254:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004258:	a8b5                	j	800042d4 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    8000425a:	6908                	ld	a0,16(a0)
    8000425c:	1de000ef          	jal	8000443a <pipewrite>
    80004260:	a071                	j	800042ec <filewrite+0xe0>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004262:	02451783          	lh	a5,36(a0)
    80004266:	03079693          	sll	a3,a5,0x30
    8000426a:	92c1                	srl	a3,a3,0x30
    8000426c:	4725                	li	a4,9
    8000426e:	0ad76363          	bltu	a4,a3,80004314 <filewrite+0x108>
    80004272:	0792                	sll	a5,a5,0x4
    80004274:	0002d717          	auipc	a4,0x2d
    80004278:	79470713          	add	a4,a4,1940 # 80031a08 <devsw>
    8000427c:	97ba                	add	a5,a5,a4
    8000427e:	679c                	ld	a5,8(a5)
    80004280:	cfc1                	beqz	a5,80004318 <filewrite+0x10c>
    ret = devsw[f->major].write(1, addr, n);
    80004282:	4505                	li	a0,1
    80004284:	9782                	jalr	a5
    80004286:	a09d                	j	800042ec <filewrite+0xe0>
      if(n1 > max)
    80004288:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000428c:	9b9ff0ef          	jal	80003c44 <begin_op>
      ilock(f->ip);
    80004290:	01893503          	ld	a0,24(s2)
    80004294:	942ff0ef          	jal	800033d6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004298:	8756                	mv	a4,s5
    8000429a:	02092683          	lw	a3,32(s2)
    8000429e:	01698633          	add	a2,s3,s6
    800042a2:	4585                	li	a1,1
    800042a4:	01893503          	ld	a0,24(s2)
    800042a8:	c62ff0ef          	jal	8000370a <writei>
    800042ac:	84aa                	mv	s1,a0
    800042ae:	00a05763          	blez	a0,800042bc <filewrite+0xb0>
        f->off += r;
    800042b2:	02092783          	lw	a5,32(s2)
    800042b6:	9fa9                	addw	a5,a5,a0
    800042b8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800042bc:	01893503          	ld	a0,24(s2)
    800042c0:	9c0ff0ef          	jal	80003480 <iunlock>
      end_op();
    800042c4:	9ebff0ef          	jal	80003cae <end_op>

      if(r != n1){
    800042c8:	009a9f63          	bne	s5,s1,800042e6 <filewrite+0xda>
        // error from writei
        break;
      }
      i += r;
    800042cc:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800042d0:	0149db63          	bge	s3,s4,800042e6 <filewrite+0xda>
      int n1 = n - i;
    800042d4:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800042d8:	0004879b          	sext.w	a5,s1
    800042dc:	fafbd6e3          	bge	s7,a5,80004288 <filewrite+0x7c>
    800042e0:	84e2                	mv	s1,s8
    800042e2:	b75d                	j	80004288 <filewrite+0x7c>
    int i = 0;
    800042e4:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800042e6:	033a1b63          	bne	s4,s3,8000431c <filewrite+0x110>
    800042ea:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    800042ec:	60a6                	ld	ra,72(sp)
    800042ee:	6406                	ld	s0,64(sp)
    800042f0:	74e2                	ld	s1,56(sp)
    800042f2:	7942                	ld	s2,48(sp)
    800042f4:	79a2                	ld	s3,40(sp)
    800042f6:	7a02                	ld	s4,32(sp)
    800042f8:	6ae2                	ld	s5,24(sp)
    800042fa:	6b42                	ld	s6,16(sp)
    800042fc:	6ba2                	ld	s7,8(sp)
    800042fe:	6c02                	ld	s8,0(sp)
    80004300:	6161                	add	sp,sp,80
    80004302:	8082                	ret
    panic("filewrite");
    80004304:	00003517          	auipc	a0,0x3
    80004308:	43c50513          	add	a0,a0,1084 # 80007740 <syscalls+0x2b0>
    8000430c:	c52fc0ef          	jal	8000075e <panic>
    return -1;
    80004310:	557d                	li	a0,-1
}
    80004312:	8082                	ret
      return -1;
    80004314:	557d                	li	a0,-1
    80004316:	bfd9                	j	800042ec <filewrite+0xe0>
    80004318:	557d                	li	a0,-1
    8000431a:	bfc9                	j	800042ec <filewrite+0xe0>
    ret = (i == n ? n : -1);
    8000431c:	557d                	li	a0,-1
    8000431e:	b7f9                	j	800042ec <filewrite+0xe0>

0000000080004320 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004320:	7179                	add	sp,sp,-48
    80004322:	f406                	sd	ra,40(sp)
    80004324:	f022                	sd	s0,32(sp)
    80004326:	ec26                	sd	s1,24(sp)
    80004328:	e84a                	sd	s2,16(sp)
    8000432a:	e44e                	sd	s3,8(sp)
    8000432c:	e052                	sd	s4,0(sp)
    8000432e:	1800                	add	s0,sp,48
    80004330:	84aa                	mv	s1,a0
    80004332:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004334:	0005b023          	sd	zero,0(a1)
    80004338:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000433c:	c79ff0ef          	jal	80003fb4 <filealloc>
    80004340:	e088                	sd	a0,0(s1)
    80004342:	cd35                	beqz	a0,800043be <pipealloc+0x9e>
    80004344:	c71ff0ef          	jal	80003fb4 <filealloc>
    80004348:	00aa3023          	sd	a0,0(s4)
    8000434c:	c52d                	beqz	a0,800043b6 <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000434e:	f82fc0ef          	jal	80000ad0 <kalloc>
    80004352:	892a                	mv	s2,a0
    80004354:	cd31                	beqz	a0,800043b0 <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    80004356:	4985                	li	s3,1
    80004358:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000435c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004360:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004364:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004368:	00003597          	auipc	a1,0x3
    8000436c:	3e858593          	add	a1,a1,1000 # 80007750 <syscalls+0x2c0>
    80004370:	fb0fc0ef          	jal	80000b20 <initlock>
  (*f0)->type = FD_PIPE;
    80004374:	609c                	ld	a5,0(s1)
    80004376:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000437a:	609c                	ld	a5,0(s1)
    8000437c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004380:	609c                	ld	a5,0(s1)
    80004382:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004386:	609c                	ld	a5,0(s1)
    80004388:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000438c:	000a3783          	ld	a5,0(s4)
    80004390:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004394:	000a3783          	ld	a5,0(s4)
    80004398:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000439c:	000a3783          	ld	a5,0(s4)
    800043a0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800043a4:	000a3783          	ld	a5,0(s4)
    800043a8:	0127b823          	sd	s2,16(a5)
  return 0;
    800043ac:	4501                	li	a0,0
    800043ae:	a005                	j	800043ce <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800043b0:	6088                	ld	a0,0(s1)
    800043b2:	e501                	bnez	a0,800043ba <pipealloc+0x9a>
    800043b4:	a029                	j	800043be <pipealloc+0x9e>
    800043b6:	6088                	ld	a0,0(s1)
    800043b8:	c11d                	beqz	a0,800043de <pipealloc+0xbe>
    fileclose(*f0);
    800043ba:	c9fff0ef          	jal	80004058 <fileclose>
  if(*f1)
    800043be:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800043c2:	557d                	li	a0,-1
  if(*f1)
    800043c4:	c789                	beqz	a5,800043ce <pipealloc+0xae>
    fileclose(*f1);
    800043c6:	853e                	mv	a0,a5
    800043c8:	c91ff0ef          	jal	80004058 <fileclose>
  return -1;
    800043cc:	557d                	li	a0,-1
}
    800043ce:	70a2                	ld	ra,40(sp)
    800043d0:	7402                	ld	s0,32(sp)
    800043d2:	64e2                	ld	s1,24(sp)
    800043d4:	6942                	ld	s2,16(sp)
    800043d6:	69a2                	ld	s3,8(sp)
    800043d8:	6a02                	ld	s4,0(sp)
    800043da:	6145                	add	sp,sp,48
    800043dc:	8082                	ret
  return -1;
    800043de:	557d                	li	a0,-1
    800043e0:	b7fd                	j	800043ce <pipealloc+0xae>

00000000800043e2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800043e2:	1101                	add	sp,sp,-32
    800043e4:	ec06                	sd	ra,24(sp)
    800043e6:	e822                	sd	s0,16(sp)
    800043e8:	e426                	sd	s1,8(sp)
    800043ea:	e04a                	sd	s2,0(sp)
    800043ec:	1000                	add	s0,sp,32
    800043ee:	84aa                	mv	s1,a0
    800043f0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800043f2:	faefc0ef          	jal	80000ba0 <acquire>
  if(writable){
    800043f6:	02090763          	beqz	s2,80004424 <pipeclose+0x42>
    pi->writeopen = 0;
    800043fa:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800043fe:	21848513          	add	a0,s1,536
    80004402:	af1fd0ef          	jal	80001ef2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004406:	2204b783          	ld	a5,544(s1)
    8000440a:	e785                	bnez	a5,80004432 <pipeclose+0x50>
    release(&pi->lock);
    8000440c:	8526                	mv	a0,s1
    8000440e:	82bfc0ef          	jal	80000c38 <release>
    kfree((char*)pi);
    80004412:	8526                	mv	a0,s1
    80004414:	ddafc0ef          	jal	800009ee <kfree>
  } else
    release(&pi->lock);
}
    80004418:	60e2                	ld	ra,24(sp)
    8000441a:	6442                	ld	s0,16(sp)
    8000441c:	64a2                	ld	s1,8(sp)
    8000441e:	6902                	ld	s2,0(sp)
    80004420:	6105                	add	sp,sp,32
    80004422:	8082                	ret
    pi->readopen = 0;
    80004424:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004428:	21c48513          	add	a0,s1,540
    8000442c:	ac7fd0ef          	jal	80001ef2 <wakeup>
    80004430:	bfd9                	j	80004406 <pipeclose+0x24>
    release(&pi->lock);
    80004432:	8526                	mv	a0,s1
    80004434:	805fc0ef          	jal	80000c38 <release>
}
    80004438:	b7c5                	j	80004418 <pipeclose+0x36>

000000008000443a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000443a:	711d                	add	sp,sp,-96
    8000443c:	ec86                	sd	ra,88(sp)
    8000443e:	e8a2                	sd	s0,80(sp)
    80004440:	e4a6                	sd	s1,72(sp)
    80004442:	e0ca                	sd	s2,64(sp)
    80004444:	fc4e                	sd	s3,56(sp)
    80004446:	f852                	sd	s4,48(sp)
    80004448:	f456                	sd	s5,40(sp)
    8000444a:	f05a                	sd	s6,32(sp)
    8000444c:	ec5e                	sd	s7,24(sp)
    8000444e:	e862                	sd	s8,16(sp)
    80004450:	1080                	add	s0,sp,96
    80004452:	84aa                	mv	s1,a0
    80004454:	8aae                	mv	s5,a1
    80004456:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004458:	bd8fd0ef          	jal	80001830 <myproc>
    8000445c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000445e:	8526                	mv	a0,s1
    80004460:	f40fc0ef          	jal	80000ba0 <acquire>
  while(i < n){
    80004464:	09405c63          	blez	s4,800044fc <pipewrite+0xc2>
  int i = 0;
    80004468:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000446a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000446c:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004470:	21c48b93          	add	s7,s1,540
    80004474:	a81d                	j	800044aa <pipewrite+0x70>
      release(&pi->lock);
    80004476:	8526                	mv	a0,s1
    80004478:	fc0fc0ef          	jal	80000c38 <release>
      return -1;
    8000447c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000447e:	854a                	mv	a0,s2
    80004480:	60e6                	ld	ra,88(sp)
    80004482:	6446                	ld	s0,80(sp)
    80004484:	64a6                	ld	s1,72(sp)
    80004486:	6906                	ld	s2,64(sp)
    80004488:	79e2                	ld	s3,56(sp)
    8000448a:	7a42                	ld	s4,48(sp)
    8000448c:	7aa2                	ld	s5,40(sp)
    8000448e:	7b02                	ld	s6,32(sp)
    80004490:	6be2                	ld	s7,24(sp)
    80004492:	6c42                	ld	s8,16(sp)
    80004494:	6125                	add	sp,sp,96
    80004496:	8082                	ret
      wakeup(&pi->nread);
    80004498:	8562                	mv	a0,s8
    8000449a:	a59fd0ef          	jal	80001ef2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000449e:	85a6                	mv	a1,s1
    800044a0:	855e                	mv	a0,s7
    800044a2:	a05fd0ef          	jal	80001ea6 <sleep>
  while(i < n){
    800044a6:	05495c63          	bge	s2,s4,800044fe <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    800044aa:	2204a783          	lw	a5,544(s1)
    800044ae:	d7e1                	beqz	a5,80004476 <pipewrite+0x3c>
    800044b0:	854e                	mv	a0,s3
    800044b2:	c2dfd0ef          	jal	800020de <killed>
    800044b6:	f161                	bnez	a0,80004476 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800044b8:	2184a783          	lw	a5,536(s1)
    800044bc:	21c4a703          	lw	a4,540(s1)
    800044c0:	2007879b          	addw	a5,a5,512
    800044c4:	fcf70ae3          	beq	a4,a5,80004498 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800044c8:	4685                	li	a3,1
    800044ca:	01590633          	add	a2,s2,s5
    800044ce:	faf40593          	add	a1,s0,-81
    800044d2:	0509b503          	ld	a0,80(s3)
    800044d6:	8cafd0ef          	jal	800015a0 <copyin>
    800044da:	03650263          	beq	a0,s6,800044fe <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800044de:	21c4a783          	lw	a5,540(s1)
    800044e2:	0017871b          	addw	a4,a5,1
    800044e6:	20e4ae23          	sw	a4,540(s1)
    800044ea:	1ff7f793          	and	a5,a5,511
    800044ee:	97a6                	add	a5,a5,s1
    800044f0:	faf44703          	lbu	a4,-81(s0)
    800044f4:	00e78c23          	sb	a4,24(a5)
      i++;
    800044f8:	2905                	addw	s2,s2,1
    800044fa:	b775                	j	800044a6 <pipewrite+0x6c>
  int i = 0;
    800044fc:	4901                	li	s2,0
  wakeup(&pi->nread);
    800044fe:	21848513          	add	a0,s1,536
    80004502:	9f1fd0ef          	jal	80001ef2 <wakeup>
  release(&pi->lock);
    80004506:	8526                	mv	a0,s1
    80004508:	f30fc0ef          	jal	80000c38 <release>
  return i;
    8000450c:	bf8d                	j	8000447e <pipewrite+0x44>

000000008000450e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000450e:	715d                	add	sp,sp,-80
    80004510:	e486                	sd	ra,72(sp)
    80004512:	e0a2                	sd	s0,64(sp)
    80004514:	fc26                	sd	s1,56(sp)
    80004516:	f84a                	sd	s2,48(sp)
    80004518:	f44e                	sd	s3,40(sp)
    8000451a:	f052                	sd	s4,32(sp)
    8000451c:	ec56                	sd	s5,24(sp)
    8000451e:	e85a                	sd	s6,16(sp)
    80004520:	0880                	add	s0,sp,80
    80004522:	84aa                	mv	s1,a0
    80004524:	892e                	mv	s2,a1
    80004526:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004528:	b08fd0ef          	jal	80001830 <myproc>
    8000452c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000452e:	8526                	mv	a0,s1
    80004530:	e70fc0ef          	jal	80000ba0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004534:	2184a703          	lw	a4,536(s1)
    80004538:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000453c:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004540:	02f71363          	bne	a4,a5,80004566 <piperead+0x58>
    80004544:	2244a783          	lw	a5,548(s1)
    80004548:	cf99                	beqz	a5,80004566 <piperead+0x58>
    if(killed(pr)){
    8000454a:	8552                	mv	a0,s4
    8000454c:	b93fd0ef          	jal	800020de <killed>
    80004550:	e149                	bnez	a0,800045d2 <piperead+0xc4>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004552:	85a6                	mv	a1,s1
    80004554:	854e                	mv	a0,s3
    80004556:	951fd0ef          	jal	80001ea6 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000455a:	2184a703          	lw	a4,536(s1)
    8000455e:	21c4a783          	lw	a5,540(s1)
    80004562:	fef701e3          	beq	a4,a5,80004544 <piperead+0x36>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004566:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004568:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000456a:	05505263          	blez	s5,800045ae <piperead+0xa0>
    if(pi->nread == pi->nwrite)
    8000456e:	2184a783          	lw	a5,536(s1)
    80004572:	21c4a703          	lw	a4,540(s1)
    80004576:	02f70c63          	beq	a4,a5,800045ae <piperead+0xa0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000457a:	0017871b          	addw	a4,a5,1
    8000457e:	20e4ac23          	sw	a4,536(s1)
    80004582:	1ff7f793          	and	a5,a5,511
    80004586:	97a6                	add	a5,a5,s1
    80004588:	0187c783          	lbu	a5,24(a5)
    8000458c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004590:	4685                	li	a3,1
    80004592:	fbf40613          	add	a2,s0,-65
    80004596:	85ca                	mv	a1,s2
    80004598:	050a3503          	ld	a0,80(s4)
    8000459c:	f4dfc0ef          	jal	800014e8 <copyout>
    800045a0:	01650763          	beq	a0,s6,800045ae <piperead+0xa0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800045a4:	2985                	addw	s3,s3,1
    800045a6:	0905                	add	s2,s2,1
    800045a8:	fd3a93e3          	bne	s5,s3,8000456e <piperead+0x60>
    800045ac:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800045ae:	21c48513          	add	a0,s1,540
    800045b2:	941fd0ef          	jal	80001ef2 <wakeup>
  release(&pi->lock);
    800045b6:	8526                	mv	a0,s1
    800045b8:	e80fc0ef          	jal	80000c38 <release>
  return i;
}
    800045bc:	854e                	mv	a0,s3
    800045be:	60a6                	ld	ra,72(sp)
    800045c0:	6406                	ld	s0,64(sp)
    800045c2:	74e2                	ld	s1,56(sp)
    800045c4:	7942                	ld	s2,48(sp)
    800045c6:	79a2                	ld	s3,40(sp)
    800045c8:	7a02                	ld	s4,32(sp)
    800045ca:	6ae2                	ld	s5,24(sp)
    800045cc:	6b42                	ld	s6,16(sp)
    800045ce:	6161                	add	sp,sp,80
    800045d0:	8082                	ret
      release(&pi->lock);
    800045d2:	8526                	mv	a0,s1
    800045d4:	e64fc0ef          	jal	80000c38 <release>
      return -1;
    800045d8:	59fd                	li	s3,-1
    800045da:	b7cd                	j	800045bc <piperead+0xae>

00000000800045dc <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800045dc:	1141                	add	sp,sp,-16
    800045de:	e422                	sd	s0,8(sp)
    800045e0:	0800                	add	s0,sp,16
    800045e2:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800045e4:	8905                	and	a0,a0,1
    800045e6:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800045e8:	8b89                	and	a5,a5,2
    800045ea:	c399                	beqz	a5,800045f0 <flags2perm+0x14>
      perm |= PTE_W;
    800045ec:	00456513          	or	a0,a0,4
    return perm;
}
    800045f0:	6422                	ld	s0,8(sp)
    800045f2:	0141                	add	sp,sp,16
    800045f4:	8082                	ret

00000000800045f6 <exec>:

int
exec(char *path, char **argv)
{
    800045f6:	df010113          	add	sp,sp,-528
    800045fa:	20113423          	sd	ra,520(sp)
    800045fe:	20813023          	sd	s0,512(sp)
    80004602:	ffa6                	sd	s1,504(sp)
    80004604:	fbca                	sd	s2,496(sp)
    80004606:	f7ce                	sd	s3,488(sp)
    80004608:	f3d2                	sd	s4,480(sp)
    8000460a:	efd6                	sd	s5,472(sp)
    8000460c:	ebda                	sd	s6,464(sp)
    8000460e:	e7de                	sd	s7,456(sp)
    80004610:	e3e2                	sd	s8,448(sp)
    80004612:	ff66                	sd	s9,440(sp)
    80004614:	fb6a                	sd	s10,432(sp)
    80004616:	f76e                	sd	s11,424(sp)
    80004618:	0c00                	add	s0,sp,528
    8000461a:	892a                	mv	s2,a0
    8000461c:	dea43c23          	sd	a0,-520(s0)
    80004620:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004624:	a0cfd0ef          	jal	80001830 <myproc>
    80004628:	84aa                	mv	s1,a0

  begin_op();
    8000462a:	e1aff0ef          	jal	80003c44 <begin_op>

  if((ip = namei(path)) == 0){
    8000462e:	854a                	mv	a0,s2
    80004630:	c58ff0ef          	jal	80003a88 <namei>
    80004634:	c12d                	beqz	a0,80004696 <exec+0xa0>
    80004636:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004638:	d9ffe0ef          	jal	800033d6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000463c:	04000713          	li	a4,64
    80004640:	4681                	li	a3,0
    80004642:	e5040613          	add	a2,s0,-432
    80004646:	4581                	li	a1,0
    80004648:	8552                	mv	a0,s4
    8000464a:	fddfe0ef          	jal	80003626 <readi>
    8000464e:	04000793          	li	a5,64
    80004652:	00f51a63          	bne	a0,a5,80004666 <exec+0x70>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004656:	e5042703          	lw	a4,-432(s0)
    8000465a:	464c47b7          	lui	a5,0x464c4
    8000465e:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004662:	02f70e63          	beq	a4,a5,8000469e <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004666:	8552                	mv	a0,s4
    80004668:	f75fe0ef          	jal	800035dc <iunlockput>
    end_op();
    8000466c:	e42ff0ef          	jal	80003cae <end_op>
  }
  return -1;
    80004670:	557d                	li	a0,-1
}
    80004672:	20813083          	ld	ra,520(sp)
    80004676:	20013403          	ld	s0,512(sp)
    8000467a:	74fe                	ld	s1,504(sp)
    8000467c:	795e                	ld	s2,496(sp)
    8000467e:	79be                	ld	s3,488(sp)
    80004680:	7a1e                	ld	s4,480(sp)
    80004682:	6afe                	ld	s5,472(sp)
    80004684:	6b5e                	ld	s6,464(sp)
    80004686:	6bbe                	ld	s7,456(sp)
    80004688:	6c1e                	ld	s8,448(sp)
    8000468a:	7cfa                	ld	s9,440(sp)
    8000468c:	7d5a                	ld	s10,432(sp)
    8000468e:	7dba                	ld	s11,424(sp)
    80004690:	21010113          	add	sp,sp,528
    80004694:	8082                	ret
    end_op();
    80004696:	e18ff0ef          	jal	80003cae <end_op>
    return -1;
    8000469a:	557d                	li	a0,-1
    8000469c:	bfd9                	j	80004672 <exec+0x7c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000469e:	8526                	mv	a0,s1
    800046a0:	a38fd0ef          	jal	800018d8 <proc_pagetable>
    800046a4:	8b2a                	mv	s6,a0
    800046a6:	d161                	beqz	a0,80004666 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800046a8:	e7042d03          	lw	s10,-400(s0)
    800046ac:	e8845783          	lhu	a5,-376(s0)
    800046b0:	0e078863          	beqz	a5,800047a0 <exec+0x1aa>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800046b4:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800046b6:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800046b8:	6c85                	lui	s9,0x1
    800046ba:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    800046be:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800046c2:	6a85                	lui	s5,0x1
    800046c4:	a085                	j	80004724 <exec+0x12e>
      panic("loadseg: address should exist");
    800046c6:	00003517          	auipc	a0,0x3
    800046ca:	09250513          	add	a0,a0,146 # 80007758 <syscalls+0x2c8>
    800046ce:	890fc0ef          	jal	8000075e <panic>
    if(sz - i < PGSIZE)
    800046d2:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800046d4:	8726                	mv	a4,s1
    800046d6:	012c06bb          	addw	a3,s8,s2
    800046da:	4581                	li	a1,0
    800046dc:	8552                	mv	a0,s4
    800046de:	f49fe0ef          	jal	80003626 <readi>
    800046e2:	2501                	sext.w	a0,a0
    800046e4:	20a49a63          	bne	s1,a0,800048f8 <exec+0x302>
  for(i = 0; i < sz; i += PGSIZE){
    800046e8:	012a893b          	addw	s2,s5,s2
    800046ec:	03397363          	bgeu	s2,s3,80004712 <exec+0x11c>
    pa = walkaddr(pagetable, va + i);
    800046f0:	02091593          	sll	a1,s2,0x20
    800046f4:	9181                	srl	a1,a1,0x20
    800046f6:	95de                	add	a1,a1,s7
    800046f8:	855a                	mv	a0,s6
    800046fa:	88ffc0ef          	jal	80000f88 <walkaddr>
    800046fe:	862a                	mv	a2,a0
    if(pa == 0)
    80004700:	d179                	beqz	a0,800046c6 <exec+0xd0>
    if(sz - i < PGSIZE)
    80004702:	412984bb          	subw	s1,s3,s2
    80004706:	0004879b          	sext.w	a5,s1
    8000470a:	fcfcf4e3          	bgeu	s9,a5,800046d2 <exec+0xdc>
    8000470e:	84d6                	mv	s1,s5
    80004710:	b7c9                	j	800046d2 <exec+0xdc>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004712:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004716:	2d85                	addw	s11,s11,1
    80004718:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    8000471c:	e8845783          	lhu	a5,-376(s0)
    80004720:	08fdd163          	bge	s11,a5,800047a2 <exec+0x1ac>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004724:	2d01                	sext.w	s10,s10
    80004726:	03800713          	li	a4,56
    8000472a:	86ea                	mv	a3,s10
    8000472c:	e1840613          	add	a2,s0,-488
    80004730:	4581                	li	a1,0
    80004732:	8552                	mv	a0,s4
    80004734:	ef3fe0ef          	jal	80003626 <readi>
    80004738:	03800793          	li	a5,56
    8000473c:	1af51c63          	bne	a0,a5,800048f4 <exec+0x2fe>
    if(ph.type != ELF_PROG_LOAD)
    80004740:	e1842783          	lw	a5,-488(s0)
    80004744:	4705                	li	a4,1
    80004746:	fce798e3          	bne	a5,a4,80004716 <exec+0x120>
    if(ph.memsz < ph.filesz)
    8000474a:	e4043483          	ld	s1,-448(s0)
    8000474e:	e3843783          	ld	a5,-456(s0)
    80004752:	1af4ec63          	bltu	s1,a5,8000490a <exec+0x314>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004756:	e2843783          	ld	a5,-472(s0)
    8000475a:	94be                	add	s1,s1,a5
    8000475c:	1af4ea63          	bltu	s1,a5,80004910 <exec+0x31a>
    if(ph.vaddr % PGSIZE != 0)
    80004760:	df043703          	ld	a4,-528(s0)
    80004764:	8ff9                	and	a5,a5,a4
    80004766:	1a079863          	bnez	a5,80004916 <exec+0x320>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000476a:	e1c42503          	lw	a0,-484(s0)
    8000476e:	e6fff0ef          	jal	800045dc <flags2perm>
    80004772:	86aa                	mv	a3,a0
    80004774:	8626                	mv	a2,s1
    80004776:	85ca                	mv	a1,s2
    80004778:	855a                	mv	a0,s6
    8000477a:	b67fc0ef          	jal	800012e0 <uvmalloc>
    8000477e:	e0a43423          	sd	a0,-504(s0)
    80004782:	18050d63          	beqz	a0,8000491c <exec+0x326>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004786:	e2843b83          	ld	s7,-472(s0)
    8000478a:	e2042c03          	lw	s8,-480(s0)
    8000478e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004792:	00098463          	beqz	s3,8000479a <exec+0x1a4>
    80004796:	4901                	li	s2,0
    80004798:	bfa1                	j	800046f0 <exec+0xfa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000479a:	e0843903          	ld	s2,-504(s0)
    8000479e:	bfa5                	j	80004716 <exec+0x120>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800047a0:	4901                	li	s2,0
  iunlockput(ip);
    800047a2:	8552                	mv	a0,s4
    800047a4:	e39fe0ef          	jal	800035dc <iunlockput>
  end_op();
    800047a8:	d06ff0ef          	jal	80003cae <end_op>
  p = myproc();
    800047ac:	884fd0ef          	jal	80001830 <myproc>
    800047b0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800047b2:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800047b6:	6985                	lui	s3,0x1
    800047b8:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    800047ba:	99ca                	add	s3,s3,s2
    800047bc:	77fd                	lui	a5,0xfffff
    800047be:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800047c2:	4691                	li	a3,4
    800047c4:	6609                	lui	a2,0x2
    800047c6:	964e                	add	a2,a2,s3
    800047c8:	85ce                	mv	a1,s3
    800047ca:	855a                	mv	a0,s6
    800047cc:	b15fc0ef          	jal	800012e0 <uvmalloc>
    800047d0:	892a                	mv	s2,a0
    800047d2:	e0a43423          	sd	a0,-504(s0)
    800047d6:	e509                	bnez	a0,800047e0 <exec+0x1ea>
  if(pagetable)
    800047d8:	e1343423          	sd	s3,-504(s0)
    800047dc:	4a01                	li	s4,0
    800047de:	aa29                	j	800048f8 <exec+0x302>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800047e0:	75f9                	lui	a1,0xffffe
    800047e2:	95aa                	add	a1,a1,a0
    800047e4:	855a                	mv	a0,s6
    800047e6:	cd9fc0ef          	jal	800014be <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800047ea:	7bfd                	lui	s7,0xfffff
    800047ec:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800047ee:	e0043783          	ld	a5,-512(s0)
    800047f2:	6388                	ld	a0,0(a5)
    800047f4:	cd39                	beqz	a0,80004852 <exec+0x25c>
    800047f6:	e9040993          	add	s3,s0,-368
    800047fa:	f9040c13          	add	s8,s0,-112
    800047fe:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004800:	deafc0ef          	jal	80000dea <strlen>
    80004804:	0015079b          	addw	a5,a0,1
    80004808:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000480c:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004810:	11796963          	bltu	s2,s7,80004922 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004814:	e0043d03          	ld	s10,-512(s0)
    80004818:	000d3a03          	ld	s4,0(s10)
    8000481c:	8552                	mv	a0,s4
    8000481e:	dccfc0ef          	jal	80000dea <strlen>
    80004822:	0015069b          	addw	a3,a0,1
    80004826:	8652                	mv	a2,s4
    80004828:	85ca                	mv	a1,s2
    8000482a:	855a                	mv	a0,s6
    8000482c:	cbdfc0ef          	jal	800014e8 <copyout>
    80004830:	0e054b63          	bltz	a0,80004926 <exec+0x330>
    ustack[argc] = sp;
    80004834:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004838:	0485                	add	s1,s1,1
    8000483a:	008d0793          	add	a5,s10,8
    8000483e:	e0f43023          	sd	a5,-512(s0)
    80004842:	008d3503          	ld	a0,8(s10)
    80004846:	c909                	beqz	a0,80004858 <exec+0x262>
    if(argc >= MAXARG)
    80004848:	09a1                	add	s3,s3,8
    8000484a:	fb899be3          	bne	s3,s8,80004800 <exec+0x20a>
  ip = 0;
    8000484e:	4a01                	li	s4,0
    80004850:	a065                	j	800048f8 <exec+0x302>
  sp = sz;
    80004852:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004856:	4481                	li	s1,0
  ustack[argc] = 0;
    80004858:	00349793          	sll	a5,s1,0x3
    8000485c:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffcc3f0>
    80004860:	97a2                	add	a5,a5,s0
    80004862:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004866:	00148693          	add	a3,s1,1
    8000486a:	068e                	sll	a3,a3,0x3
    8000486c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004870:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004874:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004878:	f77960e3          	bltu	s2,s7,800047d8 <exec+0x1e2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000487c:	e9040613          	add	a2,s0,-368
    80004880:	85ca                	mv	a1,s2
    80004882:	855a                	mv	a0,s6
    80004884:	c65fc0ef          	jal	800014e8 <copyout>
    80004888:	0a054163          	bltz	a0,8000492a <exec+0x334>
  p->trapframe->a1 = sp;
    8000488c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004890:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004894:	df843783          	ld	a5,-520(s0)
    80004898:	0007c703          	lbu	a4,0(a5)
    8000489c:	cf11                	beqz	a4,800048b8 <exec+0x2c2>
    8000489e:	0785                	add	a5,a5,1
    if(*s == '/')
    800048a0:	02f00693          	li	a3,47
    800048a4:	a039                	j	800048b2 <exec+0x2bc>
      last = s+1;
    800048a6:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800048aa:	0785                	add	a5,a5,1
    800048ac:	fff7c703          	lbu	a4,-1(a5)
    800048b0:	c701                	beqz	a4,800048b8 <exec+0x2c2>
    if(*s == '/')
    800048b2:	fed71ce3          	bne	a4,a3,800048aa <exec+0x2b4>
    800048b6:	bfc5                	j	800048a6 <exec+0x2b0>
  safestrcpy(p->name, last, sizeof(p->name));
    800048b8:	4641                	li	a2,16
    800048ba:	df843583          	ld	a1,-520(s0)
    800048be:	158a8513          	add	a0,s5,344
    800048c2:	cf6fc0ef          	jal	80000db8 <safestrcpy>
  oldpagetable = p->pagetable;
    800048c6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800048ca:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800048ce:	e0843783          	ld	a5,-504(s0)
    800048d2:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800048d6:	058ab783          	ld	a5,88(s5)
    800048da:	e6843703          	ld	a4,-408(s0)
    800048de:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800048e0:	058ab783          	ld	a5,88(s5)
    800048e4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800048e8:	85e6                	mv	a1,s9
    800048ea:	872fd0ef          	jal	8000195c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800048ee:	0004851b          	sext.w	a0,s1
    800048f2:	b341                	j	80004672 <exec+0x7c>
    800048f4:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800048f8:	e0843583          	ld	a1,-504(s0)
    800048fc:	855a                	mv	a0,s6
    800048fe:	85efd0ef          	jal	8000195c <proc_freepagetable>
  return -1;
    80004902:	557d                	li	a0,-1
  if(ip){
    80004904:	d60a07e3          	beqz	s4,80004672 <exec+0x7c>
    80004908:	bbb9                	j	80004666 <exec+0x70>
    8000490a:	e1243423          	sd	s2,-504(s0)
    8000490e:	b7ed                	j	800048f8 <exec+0x302>
    80004910:	e1243423          	sd	s2,-504(s0)
    80004914:	b7d5                	j	800048f8 <exec+0x302>
    80004916:	e1243423          	sd	s2,-504(s0)
    8000491a:	bff9                	j	800048f8 <exec+0x302>
    8000491c:	e1243423          	sd	s2,-504(s0)
    80004920:	bfe1                	j	800048f8 <exec+0x302>
  ip = 0;
    80004922:	4a01                	li	s4,0
    80004924:	bfd1                	j	800048f8 <exec+0x302>
    80004926:	4a01                	li	s4,0
  if(pagetable)
    80004928:	bfc1                	j	800048f8 <exec+0x302>
  sz = sz1;
    8000492a:	e0843983          	ld	s3,-504(s0)
    8000492e:	b56d                	j	800047d8 <exec+0x1e2>

0000000080004930 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004930:	7179                	add	sp,sp,-48
    80004932:	f406                	sd	ra,40(sp)
    80004934:	f022                	sd	s0,32(sp)
    80004936:	ec26                	sd	s1,24(sp)
    80004938:	e84a                	sd	s2,16(sp)
    8000493a:	1800                	add	s0,sp,48
    8000493c:	892e                	mv	s2,a1
    8000493e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004940:	fdc40593          	add	a1,s0,-36
    80004944:	88efe0ef          	jal	800029d2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004948:	fdc42703          	lw	a4,-36(s0)
    8000494c:	47bd                	li	a5,15
    8000494e:	02e7e963          	bltu	a5,a4,80004980 <argfd+0x50>
    80004952:	edffc0ef          	jal	80001830 <myproc>
    80004956:	fdc42703          	lw	a4,-36(s0)
    8000495a:	01a70793          	add	a5,a4,26
    8000495e:	078e                	sll	a5,a5,0x3
    80004960:	953e                	add	a0,a0,a5
    80004962:	611c                	ld	a5,0(a0)
    80004964:	c385                	beqz	a5,80004984 <argfd+0x54>
    return -1;
  if(pfd)
    80004966:	00090463          	beqz	s2,8000496e <argfd+0x3e>
    *pfd = fd;
    8000496a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000496e:	4501                	li	a0,0
  if(pf)
    80004970:	c091                	beqz	s1,80004974 <argfd+0x44>
    *pf = f;
    80004972:	e09c                	sd	a5,0(s1)
}
    80004974:	70a2                	ld	ra,40(sp)
    80004976:	7402                	ld	s0,32(sp)
    80004978:	64e2                	ld	s1,24(sp)
    8000497a:	6942                	ld	s2,16(sp)
    8000497c:	6145                	add	sp,sp,48
    8000497e:	8082                	ret
    return -1;
    80004980:	557d                	li	a0,-1
    80004982:	bfcd                	j	80004974 <argfd+0x44>
    80004984:	557d                	li	a0,-1
    80004986:	b7fd                	j	80004974 <argfd+0x44>

0000000080004988 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004988:	1101                	add	sp,sp,-32
    8000498a:	ec06                	sd	ra,24(sp)
    8000498c:	e822                	sd	s0,16(sp)
    8000498e:	e426                	sd	s1,8(sp)
    80004990:	1000                	add	s0,sp,32
    80004992:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004994:	e9dfc0ef          	jal	80001830 <myproc>
    80004998:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000499a:	0d050793          	add	a5,a0,208
    8000499e:	4501                	li	a0,0
    800049a0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800049a2:	6398                	ld	a4,0(a5)
    800049a4:	cb19                	beqz	a4,800049ba <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800049a6:	2505                	addw	a0,a0,1
    800049a8:	07a1                	add	a5,a5,8
    800049aa:	fed51ce3          	bne	a0,a3,800049a2 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800049ae:	557d                	li	a0,-1
}
    800049b0:	60e2                	ld	ra,24(sp)
    800049b2:	6442                	ld	s0,16(sp)
    800049b4:	64a2                	ld	s1,8(sp)
    800049b6:	6105                	add	sp,sp,32
    800049b8:	8082                	ret
      p->ofile[fd] = f;
    800049ba:	01a50793          	add	a5,a0,26
    800049be:	078e                	sll	a5,a5,0x3
    800049c0:	963e                	add	a2,a2,a5
    800049c2:	e204                	sd	s1,0(a2)
      return fd;
    800049c4:	b7f5                	j	800049b0 <fdalloc+0x28>

00000000800049c6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800049c6:	715d                	add	sp,sp,-80
    800049c8:	e486                	sd	ra,72(sp)
    800049ca:	e0a2                	sd	s0,64(sp)
    800049cc:	fc26                	sd	s1,56(sp)
    800049ce:	f84a                	sd	s2,48(sp)
    800049d0:	f44e                	sd	s3,40(sp)
    800049d2:	f052                	sd	s4,32(sp)
    800049d4:	ec56                	sd	s5,24(sp)
    800049d6:	e85a                	sd	s6,16(sp)
    800049d8:	0880                	add	s0,sp,80
    800049da:	8b2e                	mv	s6,a1
    800049dc:	89b2                	mv	s3,a2
    800049de:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800049e0:	fb040593          	add	a1,s0,-80
    800049e4:	8beff0ef          	jal	80003aa2 <nameiparent>
    800049e8:	84aa                	mv	s1,a0
    800049ea:	10050763          	beqz	a0,80004af8 <create+0x132>
    return 0;

  ilock(dp);
    800049ee:	9e9fe0ef          	jal	800033d6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800049f2:	4601                	li	a2,0
    800049f4:	fb040593          	add	a1,s0,-80
    800049f8:	8526                	mv	a0,s1
    800049fa:	e29fe0ef          	jal	80003822 <dirlookup>
    800049fe:	8aaa                	mv	s5,a0
    80004a00:	c131                	beqz	a0,80004a44 <create+0x7e>
    iunlockput(dp);
    80004a02:	8526                	mv	a0,s1
    80004a04:	bd9fe0ef          	jal	800035dc <iunlockput>
    ilock(ip);
    80004a08:	8556                	mv	a0,s5
    80004a0a:	9cdfe0ef          	jal	800033d6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004a0e:	4789                	li	a5,2
    80004a10:	02fb1563          	bne	s6,a5,80004a3a <create+0x74>
    80004a14:	044ad783          	lhu	a5,68(s5)
    80004a18:	37f9                	addw	a5,a5,-2
    80004a1a:	17c2                	sll	a5,a5,0x30
    80004a1c:	93c1                	srl	a5,a5,0x30
    80004a1e:	4705                	li	a4,1
    80004a20:	00f76d63          	bltu	a4,a5,80004a3a <create+0x74>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004a24:	8556                	mv	a0,s5
    80004a26:	60a6                	ld	ra,72(sp)
    80004a28:	6406                	ld	s0,64(sp)
    80004a2a:	74e2                	ld	s1,56(sp)
    80004a2c:	7942                	ld	s2,48(sp)
    80004a2e:	79a2                	ld	s3,40(sp)
    80004a30:	7a02                	ld	s4,32(sp)
    80004a32:	6ae2                	ld	s5,24(sp)
    80004a34:	6b42                	ld	s6,16(sp)
    80004a36:	6161                	add	sp,sp,80
    80004a38:	8082                	ret
    iunlockput(ip);
    80004a3a:	8556                	mv	a0,s5
    80004a3c:	ba1fe0ef          	jal	800035dc <iunlockput>
    return 0;
    80004a40:	4a81                	li	s5,0
    80004a42:	b7cd                	j	80004a24 <create+0x5e>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004a44:	85da                	mv	a1,s6
    80004a46:	4088                	lw	a0,0(s1)
    80004a48:	82bfe0ef          	jal	80003272 <ialloc>
    80004a4c:	8a2a                	mv	s4,a0
    80004a4e:	cd0d                	beqz	a0,80004a88 <create+0xc2>
  ilock(ip);
    80004a50:	987fe0ef          	jal	800033d6 <ilock>
  ip->major = major;
    80004a54:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004a58:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004a5c:	4905                	li	s2,1
    80004a5e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004a62:	8552                	mv	a0,s4
    80004a64:	8bffe0ef          	jal	80003322 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004a68:	032b0563          	beq	s6,s2,80004a92 <create+0xcc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004a6c:	004a2603          	lw	a2,4(s4)
    80004a70:	fb040593          	add	a1,s0,-80
    80004a74:	8526                	mv	a0,s1
    80004a76:	f79fe0ef          	jal	800039ee <dirlink>
    80004a7a:	06054363          	bltz	a0,80004ae0 <create+0x11a>
  iunlockput(dp);
    80004a7e:	8526                	mv	a0,s1
    80004a80:	b5dfe0ef          	jal	800035dc <iunlockput>
  return ip;
    80004a84:	8ad2                	mv	s5,s4
    80004a86:	bf79                	j	80004a24 <create+0x5e>
    iunlockput(dp);
    80004a88:	8526                	mv	a0,s1
    80004a8a:	b53fe0ef          	jal	800035dc <iunlockput>
    return 0;
    80004a8e:	8ad2                	mv	s5,s4
    80004a90:	bf51                	j	80004a24 <create+0x5e>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004a92:	004a2603          	lw	a2,4(s4)
    80004a96:	00003597          	auipc	a1,0x3
    80004a9a:	ce258593          	add	a1,a1,-798 # 80007778 <syscalls+0x2e8>
    80004a9e:	8552                	mv	a0,s4
    80004aa0:	f4ffe0ef          	jal	800039ee <dirlink>
    80004aa4:	02054e63          	bltz	a0,80004ae0 <create+0x11a>
    80004aa8:	40d0                	lw	a2,4(s1)
    80004aaa:	00003597          	auipc	a1,0x3
    80004aae:	cd658593          	add	a1,a1,-810 # 80007780 <syscalls+0x2f0>
    80004ab2:	8552                	mv	a0,s4
    80004ab4:	f3bfe0ef          	jal	800039ee <dirlink>
    80004ab8:	02054463          	bltz	a0,80004ae0 <create+0x11a>
  if(dirlink(dp, name, ip->inum) < 0)
    80004abc:	004a2603          	lw	a2,4(s4)
    80004ac0:	fb040593          	add	a1,s0,-80
    80004ac4:	8526                	mv	a0,s1
    80004ac6:	f29fe0ef          	jal	800039ee <dirlink>
    80004aca:	00054b63          	bltz	a0,80004ae0 <create+0x11a>
    dp->nlink++;  // for ".."
    80004ace:	04a4d783          	lhu	a5,74(s1)
    80004ad2:	2785                	addw	a5,a5,1
    80004ad4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ad8:	8526                	mv	a0,s1
    80004ada:	849fe0ef          	jal	80003322 <iupdate>
    80004ade:	b745                	j	80004a7e <create+0xb8>
  ip->nlink = 0;
    80004ae0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004ae4:	8552                	mv	a0,s4
    80004ae6:	83dfe0ef          	jal	80003322 <iupdate>
  iunlockput(ip);
    80004aea:	8552                	mv	a0,s4
    80004aec:	af1fe0ef          	jal	800035dc <iunlockput>
  iunlockput(dp);
    80004af0:	8526                	mv	a0,s1
    80004af2:	aebfe0ef          	jal	800035dc <iunlockput>
  return 0;
    80004af6:	b73d                	j	80004a24 <create+0x5e>
    return 0;
    80004af8:	8aaa                	mv	s5,a0
    80004afa:	b72d                	j	80004a24 <create+0x5e>

0000000080004afc <sys_dup>:
{
    80004afc:	7179                	add	sp,sp,-48
    80004afe:	f406                	sd	ra,40(sp)
    80004b00:	f022                	sd	s0,32(sp)
    80004b02:	ec26                	sd	s1,24(sp)
    80004b04:	e84a                	sd	s2,16(sp)
    80004b06:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004b08:	fd840613          	add	a2,s0,-40
    80004b0c:	4581                	li	a1,0
    80004b0e:	4501                	li	a0,0
    80004b10:	e21ff0ef          	jal	80004930 <argfd>
    return -1;
    80004b14:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004b16:	00054f63          	bltz	a0,80004b34 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
    80004b1a:	fd843903          	ld	s2,-40(s0)
    80004b1e:	854a                	mv	a0,s2
    80004b20:	e69ff0ef          	jal	80004988 <fdalloc>
    80004b24:	84aa                	mv	s1,a0
    return -1;
    80004b26:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004b28:	00054663          	bltz	a0,80004b34 <sys_dup+0x38>
  filedup(f);
    80004b2c:	854a                	mv	a0,s2
    80004b2e:	ce4ff0ef          	jal	80004012 <filedup>
  return fd;
    80004b32:	87a6                	mv	a5,s1
}
    80004b34:	853e                	mv	a0,a5
    80004b36:	70a2                	ld	ra,40(sp)
    80004b38:	7402                	ld	s0,32(sp)
    80004b3a:	64e2                	ld	s1,24(sp)
    80004b3c:	6942                	ld	s2,16(sp)
    80004b3e:	6145                	add	sp,sp,48
    80004b40:	8082                	ret

0000000080004b42 <sys_read>:
{
    80004b42:	7179                	add	sp,sp,-48
    80004b44:	f406                	sd	ra,40(sp)
    80004b46:	f022                	sd	s0,32(sp)
    80004b48:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004b4a:	fd840593          	add	a1,s0,-40
    80004b4e:	4505                	li	a0,1
    80004b50:	e9ffd0ef          	jal	800029ee <argaddr>
  argint(2, &n);
    80004b54:	fe440593          	add	a1,s0,-28
    80004b58:	4509                	li	a0,2
    80004b5a:	e79fd0ef          	jal	800029d2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004b5e:	fe840613          	add	a2,s0,-24
    80004b62:	4581                	li	a1,0
    80004b64:	4501                	li	a0,0
    80004b66:	dcbff0ef          	jal	80004930 <argfd>
    80004b6a:	87aa                	mv	a5,a0
    return -1;
    80004b6c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b6e:	0007ca63          	bltz	a5,80004b82 <sys_read+0x40>
  return fileread(f, p, n);
    80004b72:	fe442603          	lw	a2,-28(s0)
    80004b76:	fd843583          	ld	a1,-40(s0)
    80004b7a:	fe843503          	ld	a0,-24(s0)
    80004b7e:	de0ff0ef          	jal	8000415e <fileread>
}
    80004b82:	70a2                	ld	ra,40(sp)
    80004b84:	7402                	ld	s0,32(sp)
    80004b86:	6145                	add	sp,sp,48
    80004b88:	8082                	ret

0000000080004b8a <sys_write>:
{
    80004b8a:	7179                	add	sp,sp,-48
    80004b8c:	f406                	sd	ra,40(sp)
    80004b8e:	f022                	sd	s0,32(sp)
    80004b90:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004b92:	fd840593          	add	a1,s0,-40
    80004b96:	4505                	li	a0,1
    80004b98:	e57fd0ef          	jal	800029ee <argaddr>
  argint(2, &n);
    80004b9c:	fe440593          	add	a1,s0,-28
    80004ba0:	4509                	li	a0,2
    80004ba2:	e31fd0ef          	jal	800029d2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004ba6:	fe840613          	add	a2,s0,-24
    80004baa:	4581                	li	a1,0
    80004bac:	4501                	li	a0,0
    80004bae:	d83ff0ef          	jal	80004930 <argfd>
    80004bb2:	87aa                	mv	a5,a0
    return -1;
    80004bb4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004bb6:	0007ca63          	bltz	a5,80004bca <sys_write+0x40>
  return filewrite(f, p, n);
    80004bba:	fe442603          	lw	a2,-28(s0)
    80004bbe:	fd843583          	ld	a1,-40(s0)
    80004bc2:	fe843503          	ld	a0,-24(s0)
    80004bc6:	e46ff0ef          	jal	8000420c <filewrite>
}
    80004bca:	70a2                	ld	ra,40(sp)
    80004bcc:	7402                	ld	s0,32(sp)
    80004bce:	6145                	add	sp,sp,48
    80004bd0:	8082                	ret

0000000080004bd2 <sys_close>:
{
    80004bd2:	1101                	add	sp,sp,-32
    80004bd4:	ec06                	sd	ra,24(sp)
    80004bd6:	e822                	sd	s0,16(sp)
    80004bd8:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004bda:	fe040613          	add	a2,s0,-32
    80004bde:	fec40593          	add	a1,s0,-20
    80004be2:	4501                	li	a0,0
    80004be4:	d4dff0ef          	jal	80004930 <argfd>
    return -1;
    80004be8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004bea:	02054063          	bltz	a0,80004c0a <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004bee:	c43fc0ef          	jal	80001830 <myproc>
    80004bf2:	fec42783          	lw	a5,-20(s0)
    80004bf6:	07e9                	add	a5,a5,26
    80004bf8:	078e                	sll	a5,a5,0x3
    80004bfa:	953e                	add	a0,a0,a5
    80004bfc:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004c00:	fe043503          	ld	a0,-32(s0)
    80004c04:	c54ff0ef          	jal	80004058 <fileclose>
  return 0;
    80004c08:	4781                	li	a5,0
}
    80004c0a:	853e                	mv	a0,a5
    80004c0c:	60e2                	ld	ra,24(sp)
    80004c0e:	6442                	ld	s0,16(sp)
    80004c10:	6105                	add	sp,sp,32
    80004c12:	8082                	ret

0000000080004c14 <sys_fstat>:
{
    80004c14:	1101                	add	sp,sp,-32
    80004c16:	ec06                	sd	ra,24(sp)
    80004c18:	e822                	sd	s0,16(sp)
    80004c1a:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80004c1c:	fe040593          	add	a1,s0,-32
    80004c20:	4505                	li	a0,1
    80004c22:	dcdfd0ef          	jal	800029ee <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004c26:	fe840613          	add	a2,s0,-24
    80004c2a:	4581                	li	a1,0
    80004c2c:	4501                	li	a0,0
    80004c2e:	d03ff0ef          	jal	80004930 <argfd>
    80004c32:	87aa                	mv	a5,a0
    return -1;
    80004c34:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c36:	0007c863          	bltz	a5,80004c46 <sys_fstat+0x32>
  return filestat(f, st);
    80004c3a:	fe043583          	ld	a1,-32(s0)
    80004c3e:	fe843503          	ld	a0,-24(s0)
    80004c42:	cbeff0ef          	jal	80004100 <filestat>
}
    80004c46:	60e2                	ld	ra,24(sp)
    80004c48:	6442                	ld	s0,16(sp)
    80004c4a:	6105                	add	sp,sp,32
    80004c4c:	8082                	ret

0000000080004c4e <sys_link>:
{
    80004c4e:	7169                	add	sp,sp,-304
    80004c50:	f606                	sd	ra,296(sp)
    80004c52:	f222                	sd	s0,288(sp)
    80004c54:	ee26                	sd	s1,280(sp)
    80004c56:	ea4a                	sd	s2,272(sp)
    80004c58:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c5a:	08000613          	li	a2,128
    80004c5e:	ed040593          	add	a1,s0,-304
    80004c62:	4501                	li	a0,0
    80004c64:	da7fd0ef          	jal	80002a0a <argstr>
    return -1;
    80004c68:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c6a:	0c054663          	bltz	a0,80004d36 <sys_link+0xe8>
    80004c6e:	08000613          	li	a2,128
    80004c72:	f5040593          	add	a1,s0,-176
    80004c76:	4505                	li	a0,1
    80004c78:	d93fd0ef          	jal	80002a0a <argstr>
    return -1;
    80004c7c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c7e:	0a054c63          	bltz	a0,80004d36 <sys_link+0xe8>
  begin_op();
    80004c82:	fc3fe0ef          	jal	80003c44 <begin_op>
  if((ip = namei(old)) == 0){
    80004c86:	ed040513          	add	a0,s0,-304
    80004c8a:	dfffe0ef          	jal	80003a88 <namei>
    80004c8e:	84aa                	mv	s1,a0
    80004c90:	c525                	beqz	a0,80004cf8 <sys_link+0xaa>
  ilock(ip);
    80004c92:	f44fe0ef          	jal	800033d6 <ilock>
  if(ip->type == T_DIR){
    80004c96:	04449703          	lh	a4,68(s1)
    80004c9a:	4785                	li	a5,1
    80004c9c:	06f70263          	beq	a4,a5,80004d00 <sys_link+0xb2>
  ip->nlink++;
    80004ca0:	04a4d783          	lhu	a5,74(s1)
    80004ca4:	2785                	addw	a5,a5,1
    80004ca6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004caa:	8526                	mv	a0,s1
    80004cac:	e76fe0ef          	jal	80003322 <iupdate>
  iunlock(ip);
    80004cb0:	8526                	mv	a0,s1
    80004cb2:	fcefe0ef          	jal	80003480 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004cb6:	fd040593          	add	a1,s0,-48
    80004cba:	f5040513          	add	a0,s0,-176
    80004cbe:	de5fe0ef          	jal	80003aa2 <nameiparent>
    80004cc2:	892a                	mv	s2,a0
    80004cc4:	c921                	beqz	a0,80004d14 <sys_link+0xc6>
  ilock(dp);
    80004cc6:	f10fe0ef          	jal	800033d6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004cca:	00092703          	lw	a4,0(s2)
    80004cce:	409c                	lw	a5,0(s1)
    80004cd0:	02f71f63          	bne	a4,a5,80004d0e <sys_link+0xc0>
    80004cd4:	40d0                	lw	a2,4(s1)
    80004cd6:	fd040593          	add	a1,s0,-48
    80004cda:	854a                	mv	a0,s2
    80004cdc:	d13fe0ef          	jal	800039ee <dirlink>
    80004ce0:	02054763          	bltz	a0,80004d0e <sys_link+0xc0>
  iunlockput(dp);
    80004ce4:	854a                	mv	a0,s2
    80004ce6:	8f7fe0ef          	jal	800035dc <iunlockput>
  iput(ip);
    80004cea:	8526                	mv	a0,s1
    80004cec:	869fe0ef          	jal	80003554 <iput>
  end_op();
    80004cf0:	fbffe0ef          	jal	80003cae <end_op>
  return 0;
    80004cf4:	4781                	li	a5,0
    80004cf6:	a081                	j	80004d36 <sys_link+0xe8>
    end_op();
    80004cf8:	fb7fe0ef          	jal	80003cae <end_op>
    return -1;
    80004cfc:	57fd                	li	a5,-1
    80004cfe:	a825                	j	80004d36 <sys_link+0xe8>
    iunlockput(ip);
    80004d00:	8526                	mv	a0,s1
    80004d02:	8dbfe0ef          	jal	800035dc <iunlockput>
    end_op();
    80004d06:	fa9fe0ef          	jal	80003cae <end_op>
    return -1;
    80004d0a:	57fd                	li	a5,-1
    80004d0c:	a02d                	j	80004d36 <sys_link+0xe8>
    iunlockput(dp);
    80004d0e:	854a                	mv	a0,s2
    80004d10:	8cdfe0ef          	jal	800035dc <iunlockput>
  ilock(ip);
    80004d14:	8526                	mv	a0,s1
    80004d16:	ec0fe0ef          	jal	800033d6 <ilock>
  ip->nlink--;
    80004d1a:	04a4d783          	lhu	a5,74(s1)
    80004d1e:	37fd                	addw	a5,a5,-1
    80004d20:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d24:	8526                	mv	a0,s1
    80004d26:	dfcfe0ef          	jal	80003322 <iupdate>
  iunlockput(ip);
    80004d2a:	8526                	mv	a0,s1
    80004d2c:	8b1fe0ef          	jal	800035dc <iunlockput>
  end_op();
    80004d30:	f7ffe0ef          	jal	80003cae <end_op>
  return -1;
    80004d34:	57fd                	li	a5,-1
}
    80004d36:	853e                	mv	a0,a5
    80004d38:	70b2                	ld	ra,296(sp)
    80004d3a:	7412                	ld	s0,288(sp)
    80004d3c:	64f2                	ld	s1,280(sp)
    80004d3e:	6952                	ld	s2,272(sp)
    80004d40:	6155                	add	sp,sp,304
    80004d42:	8082                	ret

0000000080004d44 <sys_unlink>:
{
    80004d44:	7151                	add	sp,sp,-240
    80004d46:	f586                	sd	ra,232(sp)
    80004d48:	f1a2                	sd	s0,224(sp)
    80004d4a:	eda6                	sd	s1,216(sp)
    80004d4c:	e9ca                	sd	s2,208(sp)
    80004d4e:	e5ce                	sd	s3,200(sp)
    80004d50:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004d52:	08000613          	li	a2,128
    80004d56:	f3040593          	add	a1,s0,-208
    80004d5a:	4501                	li	a0,0
    80004d5c:	caffd0ef          	jal	80002a0a <argstr>
    80004d60:	12054b63          	bltz	a0,80004e96 <sys_unlink+0x152>
  begin_op();
    80004d64:	ee1fe0ef          	jal	80003c44 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004d68:	fb040593          	add	a1,s0,-80
    80004d6c:	f3040513          	add	a0,s0,-208
    80004d70:	d33fe0ef          	jal	80003aa2 <nameiparent>
    80004d74:	84aa                	mv	s1,a0
    80004d76:	c54d                	beqz	a0,80004e20 <sys_unlink+0xdc>
  ilock(dp);
    80004d78:	e5efe0ef          	jal	800033d6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004d7c:	00003597          	auipc	a1,0x3
    80004d80:	9fc58593          	add	a1,a1,-1540 # 80007778 <syscalls+0x2e8>
    80004d84:	fb040513          	add	a0,s0,-80
    80004d88:	a85fe0ef          	jal	8000380c <namecmp>
    80004d8c:	10050a63          	beqz	a0,80004ea0 <sys_unlink+0x15c>
    80004d90:	00003597          	auipc	a1,0x3
    80004d94:	9f058593          	add	a1,a1,-1552 # 80007780 <syscalls+0x2f0>
    80004d98:	fb040513          	add	a0,s0,-80
    80004d9c:	a71fe0ef          	jal	8000380c <namecmp>
    80004da0:	10050063          	beqz	a0,80004ea0 <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004da4:	f2c40613          	add	a2,s0,-212
    80004da8:	fb040593          	add	a1,s0,-80
    80004dac:	8526                	mv	a0,s1
    80004dae:	a75fe0ef          	jal	80003822 <dirlookup>
    80004db2:	892a                	mv	s2,a0
    80004db4:	0e050663          	beqz	a0,80004ea0 <sys_unlink+0x15c>
  ilock(ip);
    80004db8:	e1efe0ef          	jal	800033d6 <ilock>
  if(ip->nlink < 1)
    80004dbc:	04a91783          	lh	a5,74(s2)
    80004dc0:	06f05463          	blez	a5,80004e28 <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004dc4:	04491703          	lh	a4,68(s2)
    80004dc8:	4785                	li	a5,1
    80004dca:	06f70563          	beq	a4,a5,80004e34 <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004dce:	4641                	li	a2,16
    80004dd0:	4581                	li	a1,0
    80004dd2:	fc040513          	add	a0,s0,-64
    80004dd6:	e9ffb0ef          	jal	80000c74 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004dda:	4741                	li	a4,16
    80004ddc:	f2c42683          	lw	a3,-212(s0)
    80004de0:	fc040613          	add	a2,s0,-64
    80004de4:	4581                	li	a1,0
    80004de6:	8526                	mv	a0,s1
    80004de8:	923fe0ef          	jal	8000370a <writei>
    80004dec:	47c1                	li	a5,16
    80004dee:	08f51563          	bne	a0,a5,80004e78 <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004df2:	04491703          	lh	a4,68(s2)
    80004df6:	4785                	li	a5,1
    80004df8:	08f70663          	beq	a4,a5,80004e84 <sys_unlink+0x140>
  iunlockput(dp);
    80004dfc:	8526                	mv	a0,s1
    80004dfe:	fdefe0ef          	jal	800035dc <iunlockput>
  ip->nlink--;
    80004e02:	04a95783          	lhu	a5,74(s2)
    80004e06:	37fd                	addw	a5,a5,-1
    80004e08:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004e0c:	854a                	mv	a0,s2
    80004e0e:	d14fe0ef          	jal	80003322 <iupdate>
  iunlockput(ip);
    80004e12:	854a                	mv	a0,s2
    80004e14:	fc8fe0ef          	jal	800035dc <iunlockput>
  end_op();
    80004e18:	e97fe0ef          	jal	80003cae <end_op>
  return 0;
    80004e1c:	4501                	li	a0,0
    80004e1e:	a079                	j	80004eac <sys_unlink+0x168>
    end_op();
    80004e20:	e8ffe0ef          	jal	80003cae <end_op>
    return -1;
    80004e24:	557d                	li	a0,-1
    80004e26:	a059                	j	80004eac <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004e28:	00003517          	auipc	a0,0x3
    80004e2c:	96050513          	add	a0,a0,-1696 # 80007788 <syscalls+0x2f8>
    80004e30:	92ffb0ef          	jal	8000075e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e34:	04c92703          	lw	a4,76(s2)
    80004e38:	02000793          	li	a5,32
    80004e3c:	f8e7f9e3          	bgeu	a5,a4,80004dce <sys_unlink+0x8a>
    80004e40:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e44:	4741                	li	a4,16
    80004e46:	86ce                	mv	a3,s3
    80004e48:	f1840613          	add	a2,s0,-232
    80004e4c:	4581                	li	a1,0
    80004e4e:	854a                	mv	a0,s2
    80004e50:	fd6fe0ef          	jal	80003626 <readi>
    80004e54:	47c1                	li	a5,16
    80004e56:	00f51b63          	bne	a0,a5,80004e6c <sys_unlink+0x128>
    if(de.inum != 0)
    80004e5a:	f1845783          	lhu	a5,-232(s0)
    80004e5e:	ef95                	bnez	a5,80004e9a <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e60:	29c1                	addw	s3,s3,16
    80004e62:	04c92783          	lw	a5,76(s2)
    80004e66:	fcf9efe3          	bltu	s3,a5,80004e44 <sys_unlink+0x100>
    80004e6a:	b795                	j	80004dce <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004e6c:	00003517          	auipc	a0,0x3
    80004e70:	93450513          	add	a0,a0,-1740 # 800077a0 <syscalls+0x310>
    80004e74:	8ebfb0ef          	jal	8000075e <panic>
    panic("unlink: writei");
    80004e78:	00003517          	auipc	a0,0x3
    80004e7c:	94050513          	add	a0,a0,-1728 # 800077b8 <syscalls+0x328>
    80004e80:	8dffb0ef          	jal	8000075e <panic>
    dp->nlink--;
    80004e84:	04a4d783          	lhu	a5,74(s1)
    80004e88:	37fd                	addw	a5,a5,-1
    80004e8a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e8e:	8526                	mv	a0,s1
    80004e90:	c92fe0ef          	jal	80003322 <iupdate>
    80004e94:	b7a5                	j	80004dfc <sys_unlink+0xb8>
    return -1;
    80004e96:	557d                	li	a0,-1
    80004e98:	a811                	j	80004eac <sys_unlink+0x168>
    iunlockput(ip);
    80004e9a:	854a                	mv	a0,s2
    80004e9c:	f40fe0ef          	jal	800035dc <iunlockput>
  iunlockput(dp);
    80004ea0:	8526                	mv	a0,s1
    80004ea2:	f3afe0ef          	jal	800035dc <iunlockput>
  end_op();
    80004ea6:	e09fe0ef          	jal	80003cae <end_op>
  return -1;
    80004eaa:	557d                	li	a0,-1
}
    80004eac:	70ae                	ld	ra,232(sp)
    80004eae:	740e                	ld	s0,224(sp)
    80004eb0:	64ee                	ld	s1,216(sp)
    80004eb2:	694e                	ld	s2,208(sp)
    80004eb4:	69ae                	ld	s3,200(sp)
    80004eb6:	616d                	add	sp,sp,240
    80004eb8:	8082                	ret

0000000080004eba <sys_open>:

uint64
sys_open(void)
{
    80004eba:	7131                	add	sp,sp,-192
    80004ebc:	fd06                	sd	ra,184(sp)
    80004ebe:	f922                	sd	s0,176(sp)
    80004ec0:	f526                	sd	s1,168(sp)
    80004ec2:	f14a                	sd	s2,160(sp)
    80004ec4:	ed4e                	sd	s3,152(sp)
    80004ec6:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004ec8:	f4c40593          	add	a1,s0,-180
    80004ecc:	4505                	li	a0,1
    80004ece:	b05fd0ef          	jal	800029d2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ed2:	08000613          	li	a2,128
    80004ed6:	f5040593          	add	a1,s0,-176
    80004eda:	4501                	li	a0,0
    80004edc:	b2ffd0ef          	jal	80002a0a <argstr>
    80004ee0:	87aa                	mv	a5,a0
    return -1;
    80004ee2:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ee4:	0807cc63          	bltz	a5,80004f7c <sys_open+0xc2>

  begin_op();
    80004ee8:	d5dfe0ef          	jal	80003c44 <begin_op>

  if(omode & O_CREATE){
    80004eec:	f4c42783          	lw	a5,-180(s0)
    80004ef0:	2007f793          	and	a5,a5,512
    80004ef4:	cfd9                	beqz	a5,80004f92 <sys_open+0xd8>
    ip = create(path, T_FILE, 0, 0);
    80004ef6:	4681                	li	a3,0
    80004ef8:	4601                	li	a2,0
    80004efa:	4589                	li	a1,2
    80004efc:	f5040513          	add	a0,s0,-176
    80004f00:	ac7ff0ef          	jal	800049c6 <create>
    80004f04:	84aa                	mv	s1,a0
    if(ip == 0){
    80004f06:	c151                	beqz	a0,80004f8a <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004f08:	04449703          	lh	a4,68(s1)
    80004f0c:	478d                	li	a5,3
    80004f0e:	00f71763          	bne	a4,a5,80004f1c <sys_open+0x62>
    80004f12:	0464d703          	lhu	a4,70(s1)
    80004f16:	47a5                	li	a5,9
    80004f18:	0ae7e863          	bltu	a5,a4,80004fc8 <sys_open+0x10e>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004f1c:	898ff0ef          	jal	80003fb4 <filealloc>
    80004f20:	892a                	mv	s2,a0
    80004f22:	cd4d                	beqz	a0,80004fdc <sys_open+0x122>
    80004f24:	a65ff0ef          	jal	80004988 <fdalloc>
    80004f28:	89aa                	mv	s3,a0
    80004f2a:	0a054663          	bltz	a0,80004fd6 <sys_open+0x11c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004f2e:	04449703          	lh	a4,68(s1)
    80004f32:	478d                	li	a5,3
    80004f34:	0af70b63          	beq	a4,a5,80004fea <sys_open+0x130>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004f38:	4789                	li	a5,2
    80004f3a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004f3e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004f42:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004f46:	f4c42783          	lw	a5,-180(s0)
    80004f4a:	0017c713          	xor	a4,a5,1
    80004f4e:	8b05                	and	a4,a4,1
    80004f50:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f54:	0037f713          	and	a4,a5,3
    80004f58:	00e03733          	snez	a4,a4
    80004f5c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f60:	4007f793          	and	a5,a5,1024
    80004f64:	c791                	beqz	a5,80004f70 <sys_open+0xb6>
    80004f66:	04449703          	lh	a4,68(s1)
    80004f6a:	4789                	li	a5,2
    80004f6c:	08f70663          	beq	a4,a5,80004ff8 <sys_open+0x13e>
    itrunc(ip);
  }

  iunlock(ip);
    80004f70:	8526                	mv	a0,s1
    80004f72:	d0efe0ef          	jal	80003480 <iunlock>
  end_op();
    80004f76:	d39fe0ef          	jal	80003cae <end_op>

  return fd;
    80004f7a:	854e                	mv	a0,s3
}
    80004f7c:	70ea                	ld	ra,184(sp)
    80004f7e:	744a                	ld	s0,176(sp)
    80004f80:	74aa                	ld	s1,168(sp)
    80004f82:	790a                	ld	s2,160(sp)
    80004f84:	69ea                	ld	s3,152(sp)
    80004f86:	6129                	add	sp,sp,192
    80004f88:	8082                	ret
      end_op();
    80004f8a:	d25fe0ef          	jal	80003cae <end_op>
      return -1;
    80004f8e:	557d                	li	a0,-1
    80004f90:	b7f5                	j	80004f7c <sys_open+0xc2>
    if((ip = namei(path)) == 0){
    80004f92:	f5040513          	add	a0,s0,-176
    80004f96:	af3fe0ef          	jal	80003a88 <namei>
    80004f9a:	84aa                	mv	s1,a0
    80004f9c:	c115                	beqz	a0,80004fc0 <sys_open+0x106>
    ilock(ip);
    80004f9e:	c38fe0ef          	jal	800033d6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004fa2:	04449703          	lh	a4,68(s1)
    80004fa6:	4785                	li	a5,1
    80004fa8:	f6f710e3          	bne	a4,a5,80004f08 <sys_open+0x4e>
    80004fac:	f4c42783          	lw	a5,-180(s0)
    80004fb0:	d7b5                	beqz	a5,80004f1c <sys_open+0x62>
      iunlockput(ip);
    80004fb2:	8526                	mv	a0,s1
    80004fb4:	e28fe0ef          	jal	800035dc <iunlockput>
      end_op();
    80004fb8:	cf7fe0ef          	jal	80003cae <end_op>
      return -1;
    80004fbc:	557d                	li	a0,-1
    80004fbe:	bf7d                	j	80004f7c <sys_open+0xc2>
      end_op();
    80004fc0:	ceffe0ef          	jal	80003cae <end_op>
      return -1;
    80004fc4:	557d                	li	a0,-1
    80004fc6:	bf5d                	j	80004f7c <sys_open+0xc2>
    iunlockput(ip);
    80004fc8:	8526                	mv	a0,s1
    80004fca:	e12fe0ef          	jal	800035dc <iunlockput>
    end_op();
    80004fce:	ce1fe0ef          	jal	80003cae <end_op>
    return -1;
    80004fd2:	557d                	li	a0,-1
    80004fd4:	b765                	j	80004f7c <sys_open+0xc2>
      fileclose(f);
    80004fd6:	854a                	mv	a0,s2
    80004fd8:	880ff0ef          	jal	80004058 <fileclose>
    iunlockput(ip);
    80004fdc:	8526                	mv	a0,s1
    80004fde:	dfefe0ef          	jal	800035dc <iunlockput>
    end_op();
    80004fe2:	ccdfe0ef          	jal	80003cae <end_op>
    return -1;
    80004fe6:	557d                	li	a0,-1
    80004fe8:	bf51                	j	80004f7c <sys_open+0xc2>
    f->type = FD_DEVICE;
    80004fea:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004fee:	04649783          	lh	a5,70(s1)
    80004ff2:	02f91223          	sh	a5,36(s2)
    80004ff6:	b7b1                	j	80004f42 <sys_open+0x88>
    itrunc(ip);
    80004ff8:	8526                	mv	a0,s1
    80004ffa:	cc6fe0ef          	jal	800034c0 <itrunc>
    80004ffe:	bf8d                	j	80004f70 <sys_open+0xb6>

0000000080005000 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005000:	7175                	add	sp,sp,-144
    80005002:	e506                	sd	ra,136(sp)
    80005004:	e122                	sd	s0,128(sp)
    80005006:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005008:	c3dfe0ef          	jal	80003c44 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000500c:	08000613          	li	a2,128
    80005010:	f7040593          	add	a1,s0,-144
    80005014:	4501                	li	a0,0
    80005016:	9f5fd0ef          	jal	80002a0a <argstr>
    8000501a:	02054363          	bltz	a0,80005040 <sys_mkdir+0x40>
    8000501e:	4681                	li	a3,0
    80005020:	4601                	li	a2,0
    80005022:	4585                	li	a1,1
    80005024:	f7040513          	add	a0,s0,-144
    80005028:	99fff0ef          	jal	800049c6 <create>
    8000502c:	c911                	beqz	a0,80005040 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000502e:	daefe0ef          	jal	800035dc <iunlockput>
  end_op();
    80005032:	c7dfe0ef          	jal	80003cae <end_op>
  return 0;
    80005036:	4501                	li	a0,0
}
    80005038:	60aa                	ld	ra,136(sp)
    8000503a:	640a                	ld	s0,128(sp)
    8000503c:	6149                	add	sp,sp,144
    8000503e:	8082                	ret
    end_op();
    80005040:	c6ffe0ef          	jal	80003cae <end_op>
    return -1;
    80005044:	557d                	li	a0,-1
    80005046:	bfcd                	j	80005038 <sys_mkdir+0x38>

0000000080005048 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005048:	7135                	add	sp,sp,-160
    8000504a:	ed06                	sd	ra,152(sp)
    8000504c:	e922                	sd	s0,144(sp)
    8000504e:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005050:	bf5fe0ef          	jal	80003c44 <begin_op>
  argint(1, &major);
    80005054:	f6c40593          	add	a1,s0,-148
    80005058:	4505                	li	a0,1
    8000505a:	979fd0ef          	jal	800029d2 <argint>
  argint(2, &minor);
    8000505e:	f6840593          	add	a1,s0,-152
    80005062:	4509                	li	a0,2
    80005064:	96ffd0ef          	jal	800029d2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005068:	08000613          	li	a2,128
    8000506c:	f7040593          	add	a1,s0,-144
    80005070:	4501                	li	a0,0
    80005072:	999fd0ef          	jal	80002a0a <argstr>
    80005076:	02054563          	bltz	a0,800050a0 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000507a:	f6841683          	lh	a3,-152(s0)
    8000507e:	f6c41603          	lh	a2,-148(s0)
    80005082:	458d                	li	a1,3
    80005084:	f7040513          	add	a0,s0,-144
    80005088:	93fff0ef          	jal	800049c6 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000508c:	c911                	beqz	a0,800050a0 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000508e:	d4efe0ef          	jal	800035dc <iunlockput>
  end_op();
    80005092:	c1dfe0ef          	jal	80003cae <end_op>
  return 0;
    80005096:	4501                	li	a0,0
}
    80005098:	60ea                	ld	ra,152(sp)
    8000509a:	644a                	ld	s0,144(sp)
    8000509c:	610d                	add	sp,sp,160
    8000509e:	8082                	ret
    end_op();
    800050a0:	c0ffe0ef          	jal	80003cae <end_op>
    return -1;
    800050a4:	557d                	li	a0,-1
    800050a6:	bfcd                	j	80005098 <sys_mknod+0x50>

00000000800050a8 <sys_chdir>:

uint64
sys_chdir(void)
{
    800050a8:	7135                	add	sp,sp,-160
    800050aa:	ed06                	sd	ra,152(sp)
    800050ac:	e922                	sd	s0,144(sp)
    800050ae:	e526                	sd	s1,136(sp)
    800050b0:	e14a                	sd	s2,128(sp)
    800050b2:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050b4:	f7cfc0ef          	jal	80001830 <myproc>
    800050b8:	892a                	mv	s2,a0
  
  begin_op();
    800050ba:	b8bfe0ef          	jal	80003c44 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800050be:	08000613          	li	a2,128
    800050c2:	f6040593          	add	a1,s0,-160
    800050c6:	4501                	li	a0,0
    800050c8:	943fd0ef          	jal	80002a0a <argstr>
    800050cc:	04054163          	bltz	a0,8000510e <sys_chdir+0x66>
    800050d0:	f6040513          	add	a0,s0,-160
    800050d4:	9b5fe0ef          	jal	80003a88 <namei>
    800050d8:	84aa                	mv	s1,a0
    800050da:	c915                	beqz	a0,8000510e <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800050dc:	afafe0ef          	jal	800033d6 <ilock>
  if(ip->type != T_DIR){
    800050e0:	04449703          	lh	a4,68(s1)
    800050e4:	4785                	li	a5,1
    800050e6:	02f71863          	bne	a4,a5,80005116 <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800050ea:	8526                	mv	a0,s1
    800050ec:	b94fe0ef          	jal	80003480 <iunlock>
  iput(p->cwd);
    800050f0:	15093503          	ld	a0,336(s2)
    800050f4:	c60fe0ef          	jal	80003554 <iput>
  end_op();
    800050f8:	bb7fe0ef          	jal	80003cae <end_op>
  p->cwd = ip;
    800050fc:	14993823          	sd	s1,336(s2)
  return 0;
    80005100:	4501                	li	a0,0
}
    80005102:	60ea                	ld	ra,152(sp)
    80005104:	644a                	ld	s0,144(sp)
    80005106:	64aa                	ld	s1,136(sp)
    80005108:	690a                	ld	s2,128(sp)
    8000510a:	610d                	add	sp,sp,160
    8000510c:	8082                	ret
    end_op();
    8000510e:	ba1fe0ef          	jal	80003cae <end_op>
    return -1;
    80005112:	557d                	li	a0,-1
    80005114:	b7fd                	j	80005102 <sys_chdir+0x5a>
    iunlockput(ip);
    80005116:	8526                	mv	a0,s1
    80005118:	cc4fe0ef          	jal	800035dc <iunlockput>
    end_op();
    8000511c:	b93fe0ef          	jal	80003cae <end_op>
    return -1;
    80005120:	557d                	li	a0,-1
    80005122:	b7c5                	j	80005102 <sys_chdir+0x5a>

0000000080005124 <sys_exec>:

uint64
sys_exec(void)
{
    80005124:	7121                	add	sp,sp,-448
    80005126:	ff06                	sd	ra,440(sp)
    80005128:	fb22                	sd	s0,432(sp)
    8000512a:	f726                	sd	s1,424(sp)
    8000512c:	f34a                	sd	s2,416(sp)
    8000512e:	ef4e                	sd	s3,408(sp)
    80005130:	eb52                	sd	s4,400(sp)
    80005132:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005134:	e4840593          	add	a1,s0,-440
    80005138:	4505                	li	a0,1
    8000513a:	8b5fd0ef          	jal	800029ee <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000513e:	08000613          	li	a2,128
    80005142:	f5040593          	add	a1,s0,-176
    80005146:	4501                	li	a0,0
    80005148:	8c3fd0ef          	jal	80002a0a <argstr>
    8000514c:	87aa                	mv	a5,a0
    return -1;
    8000514e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005150:	0a07c463          	bltz	a5,800051f8 <sys_exec+0xd4>
  }
  memset(argv, 0, sizeof(argv));
    80005154:	10000613          	li	a2,256
    80005158:	4581                	li	a1,0
    8000515a:	e5040513          	add	a0,s0,-432
    8000515e:	b17fb0ef          	jal	80000c74 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005162:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005166:	89a6                	mv	s3,s1
    80005168:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000516a:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000516e:	00391513          	sll	a0,s2,0x3
    80005172:	e4040593          	add	a1,s0,-448
    80005176:	e4843783          	ld	a5,-440(s0)
    8000517a:	953e                	add	a0,a0,a5
    8000517c:	fccfd0ef          	jal	80002948 <fetchaddr>
    80005180:	02054663          	bltz	a0,800051ac <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80005184:	e4043783          	ld	a5,-448(s0)
    80005188:	cf8d                	beqz	a5,800051c2 <sys_exec+0x9e>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000518a:	947fb0ef          	jal	80000ad0 <kalloc>
    8000518e:	85aa                	mv	a1,a0
    80005190:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005194:	cd01                	beqz	a0,800051ac <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005196:	6605                	lui	a2,0x1
    80005198:	e4043503          	ld	a0,-448(s0)
    8000519c:	ff6fd0ef          	jal	80002992 <fetchstr>
    800051a0:	00054663          	bltz	a0,800051ac <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800051a4:	0905                	add	s2,s2,1
    800051a6:	09a1                	add	s3,s3,8
    800051a8:	fd4913e3          	bne	s2,s4,8000516e <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051ac:	f5040913          	add	s2,s0,-176
    800051b0:	6088                	ld	a0,0(s1)
    800051b2:	c131                	beqz	a0,800051f6 <sys_exec+0xd2>
    kfree(argv[i]);
    800051b4:	83bfb0ef          	jal	800009ee <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051b8:	04a1                	add	s1,s1,8
    800051ba:	ff249be3          	bne	s1,s2,800051b0 <sys_exec+0x8c>
  return -1;
    800051be:	557d                	li	a0,-1
    800051c0:	a825                	j	800051f8 <sys_exec+0xd4>
      argv[i] = 0;
    800051c2:	0009079b          	sext.w	a5,s2
    800051c6:	078e                	sll	a5,a5,0x3
    800051c8:	fd078793          	add	a5,a5,-48
    800051cc:	97a2                	add	a5,a5,s0
    800051ce:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800051d2:	e5040593          	add	a1,s0,-432
    800051d6:	f5040513          	add	a0,s0,-176
    800051da:	c1cff0ef          	jal	800045f6 <exec>
    800051de:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051e0:	f5040993          	add	s3,s0,-176
    800051e4:	6088                	ld	a0,0(s1)
    800051e6:	c511                	beqz	a0,800051f2 <sys_exec+0xce>
    kfree(argv[i]);
    800051e8:	807fb0ef          	jal	800009ee <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051ec:	04a1                	add	s1,s1,8
    800051ee:	ff349be3          	bne	s1,s3,800051e4 <sys_exec+0xc0>
  return ret;
    800051f2:	854a                	mv	a0,s2
    800051f4:	a011                	j	800051f8 <sys_exec+0xd4>
  return -1;
    800051f6:	557d                	li	a0,-1
}
    800051f8:	70fa                	ld	ra,440(sp)
    800051fa:	745a                	ld	s0,432(sp)
    800051fc:	74ba                	ld	s1,424(sp)
    800051fe:	791a                	ld	s2,416(sp)
    80005200:	69fa                	ld	s3,408(sp)
    80005202:	6a5a                	ld	s4,400(sp)
    80005204:	6139                	add	sp,sp,448
    80005206:	8082                	ret

0000000080005208 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005208:	7139                	add	sp,sp,-64
    8000520a:	fc06                	sd	ra,56(sp)
    8000520c:	f822                	sd	s0,48(sp)
    8000520e:	f426                	sd	s1,40(sp)
    80005210:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005212:	e1efc0ef          	jal	80001830 <myproc>
    80005216:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005218:	fd840593          	add	a1,s0,-40
    8000521c:	4501                	li	a0,0
    8000521e:	fd0fd0ef          	jal	800029ee <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005222:	fc840593          	add	a1,s0,-56
    80005226:	fd040513          	add	a0,s0,-48
    8000522a:	8f6ff0ef          	jal	80004320 <pipealloc>
    return -1;
    8000522e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005230:	0a054463          	bltz	a0,800052d8 <sys_pipe+0xd0>
  fd0 = -1;
    80005234:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005238:	fd043503          	ld	a0,-48(s0)
    8000523c:	f4cff0ef          	jal	80004988 <fdalloc>
    80005240:	fca42223          	sw	a0,-60(s0)
    80005244:	08054163          	bltz	a0,800052c6 <sys_pipe+0xbe>
    80005248:	fc843503          	ld	a0,-56(s0)
    8000524c:	f3cff0ef          	jal	80004988 <fdalloc>
    80005250:	fca42023          	sw	a0,-64(s0)
    80005254:	06054063          	bltz	a0,800052b4 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005258:	4691                	li	a3,4
    8000525a:	fc440613          	add	a2,s0,-60
    8000525e:	fd843583          	ld	a1,-40(s0)
    80005262:	68a8                	ld	a0,80(s1)
    80005264:	a84fc0ef          	jal	800014e8 <copyout>
    80005268:	00054e63          	bltz	a0,80005284 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000526c:	4691                	li	a3,4
    8000526e:	fc040613          	add	a2,s0,-64
    80005272:	fd843583          	ld	a1,-40(s0)
    80005276:	0591                	add	a1,a1,4
    80005278:	68a8                	ld	a0,80(s1)
    8000527a:	a6efc0ef          	jal	800014e8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000527e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005280:	04055c63          	bgez	a0,800052d8 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005284:	fc442783          	lw	a5,-60(s0)
    80005288:	07e9                	add	a5,a5,26
    8000528a:	078e                	sll	a5,a5,0x3
    8000528c:	97a6                	add	a5,a5,s1
    8000528e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005292:	fc042783          	lw	a5,-64(s0)
    80005296:	07e9                	add	a5,a5,26
    80005298:	078e                	sll	a5,a5,0x3
    8000529a:	94be                	add	s1,s1,a5
    8000529c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800052a0:	fd043503          	ld	a0,-48(s0)
    800052a4:	db5fe0ef          	jal	80004058 <fileclose>
    fileclose(wf);
    800052a8:	fc843503          	ld	a0,-56(s0)
    800052ac:	dadfe0ef          	jal	80004058 <fileclose>
    return -1;
    800052b0:	57fd                	li	a5,-1
    800052b2:	a01d                	j	800052d8 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800052b4:	fc442783          	lw	a5,-60(s0)
    800052b8:	0007c763          	bltz	a5,800052c6 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800052bc:	07e9                	add	a5,a5,26
    800052be:	078e                	sll	a5,a5,0x3
    800052c0:	97a6                	add	a5,a5,s1
    800052c2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800052c6:	fd043503          	ld	a0,-48(s0)
    800052ca:	d8ffe0ef          	jal	80004058 <fileclose>
    fileclose(wf);
    800052ce:	fc843503          	ld	a0,-56(s0)
    800052d2:	d87fe0ef          	jal	80004058 <fileclose>
    return -1;
    800052d6:	57fd                	li	a5,-1
}
    800052d8:	853e                	mv	a0,a5
    800052da:	70e2                	ld	ra,56(sp)
    800052dc:	7442                	ld	s0,48(sp)
    800052de:	74a2                	ld	s1,40(sp)
    800052e0:	6121                	add	sp,sp,64
    800052e2:	8082                	ret
	...

00000000800052f0 <kernelvec>:
    800052f0:	7111                	add	sp,sp,-256
    800052f2:	e006                	sd	ra,0(sp)
    800052f4:	e40a                	sd	sp,8(sp)
    800052f6:	e80e                	sd	gp,16(sp)
    800052f8:	ec12                	sd	tp,24(sp)
    800052fa:	f016                	sd	t0,32(sp)
    800052fc:	f41a                	sd	t1,40(sp)
    800052fe:	f81e                	sd	t2,48(sp)
    80005300:	e4aa                	sd	a0,72(sp)
    80005302:	e8ae                	sd	a1,80(sp)
    80005304:	ecb2                	sd	a2,88(sp)
    80005306:	f0b6                	sd	a3,96(sp)
    80005308:	f4ba                	sd	a4,104(sp)
    8000530a:	f8be                	sd	a5,112(sp)
    8000530c:	fcc2                	sd	a6,120(sp)
    8000530e:	e146                	sd	a7,128(sp)
    80005310:	edf2                	sd	t3,216(sp)
    80005312:	f1f6                	sd	t4,224(sp)
    80005314:	f5fa                	sd	t5,232(sp)
    80005316:	f9fe                	sd	t6,240(sp)
    80005318:	d40fd0ef          	jal	80002858 <kerneltrap>
    8000531c:	6082                	ld	ra,0(sp)
    8000531e:	6122                	ld	sp,8(sp)
    80005320:	61c2                	ld	gp,16(sp)
    80005322:	7282                	ld	t0,32(sp)
    80005324:	7322                	ld	t1,40(sp)
    80005326:	73c2                	ld	t2,48(sp)
    80005328:	6526                	ld	a0,72(sp)
    8000532a:	65c6                	ld	a1,80(sp)
    8000532c:	6666                	ld	a2,88(sp)
    8000532e:	7686                	ld	a3,96(sp)
    80005330:	7726                	ld	a4,104(sp)
    80005332:	77c6                	ld	a5,112(sp)
    80005334:	7866                	ld	a6,120(sp)
    80005336:	688a                	ld	a7,128(sp)
    80005338:	6e6e                	ld	t3,216(sp)
    8000533a:	7e8e                	ld	t4,224(sp)
    8000533c:	7f2e                	ld	t5,232(sp)
    8000533e:	7fce                	ld	t6,240(sp)
    80005340:	6111                	add	sp,sp,256
    80005342:	10200073          	sret
	...

000000008000534e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000534e:	1141                	add	sp,sp,-16
    80005350:	e422                	sd	s0,8(sp)
    80005352:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005354:	0c0007b7          	lui	a5,0xc000
    80005358:	4705                	li	a4,1
    8000535a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000535c:	c3d8                	sw	a4,4(a5)
}
    8000535e:	6422                	ld	s0,8(sp)
    80005360:	0141                	add	sp,sp,16
    80005362:	8082                	ret

0000000080005364 <plicinithart>:

void
plicinithart(void)
{
    80005364:	1141                	add	sp,sp,-16
    80005366:	e406                	sd	ra,8(sp)
    80005368:	e022                	sd	s0,0(sp)
    8000536a:	0800                	add	s0,sp,16
  int hart = cpuid();
    8000536c:	c98fc0ef          	jal	80001804 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005370:	0085171b          	sllw	a4,a0,0x8
    80005374:	0c0027b7          	lui	a5,0xc002
    80005378:	97ba                	add	a5,a5,a4
    8000537a:	40200713          	li	a4,1026
    8000537e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005382:	00d5151b          	sllw	a0,a0,0xd
    80005386:	0c2017b7          	lui	a5,0xc201
    8000538a:	97aa                	add	a5,a5,a0
    8000538c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005390:	60a2                	ld	ra,8(sp)
    80005392:	6402                	ld	s0,0(sp)
    80005394:	0141                	add	sp,sp,16
    80005396:	8082                	ret

0000000080005398 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005398:	1141                	add	sp,sp,-16
    8000539a:	e406                	sd	ra,8(sp)
    8000539c:	e022                	sd	s0,0(sp)
    8000539e:	0800                	add	s0,sp,16
  int hart = cpuid();
    800053a0:	c64fc0ef          	jal	80001804 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053a4:	00d5151b          	sllw	a0,a0,0xd
    800053a8:	0c2017b7          	lui	a5,0xc201
    800053ac:	97aa                	add	a5,a5,a0
  return irq;
}
    800053ae:	43c8                	lw	a0,4(a5)
    800053b0:	60a2                	ld	ra,8(sp)
    800053b2:	6402                	ld	s0,0(sp)
    800053b4:	0141                	add	sp,sp,16
    800053b6:	8082                	ret

00000000800053b8 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053b8:	1101                	add	sp,sp,-32
    800053ba:	ec06                	sd	ra,24(sp)
    800053bc:	e822                	sd	s0,16(sp)
    800053be:	e426                	sd	s1,8(sp)
    800053c0:	1000                	add	s0,sp,32
    800053c2:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053c4:	c40fc0ef          	jal	80001804 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053c8:	00d5151b          	sllw	a0,a0,0xd
    800053cc:	0c2017b7          	lui	a5,0xc201
    800053d0:	97aa                	add	a5,a5,a0
    800053d2:	c3c4                	sw	s1,4(a5)
}
    800053d4:	60e2                	ld	ra,24(sp)
    800053d6:	6442                	ld	s0,16(sp)
    800053d8:	64a2                	ld	s1,8(sp)
    800053da:	6105                	add	sp,sp,32
    800053dc:	8082                	ret

00000000800053de <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053de:	1141                	add	sp,sp,-16
    800053e0:	e406                	sd	ra,8(sp)
    800053e2:	e022                	sd	s0,0(sp)
    800053e4:	0800                	add	s0,sp,16
  if(i >= NUM)
    800053e6:	479d                	li	a5,7
    800053e8:	04a7ca63          	blt	a5,a0,8000543c <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800053ec:	0002d797          	auipc	a5,0x2d
    800053f0:	67478793          	add	a5,a5,1652 # 80032a60 <disk>
    800053f4:	97aa                	add	a5,a5,a0
    800053f6:	0187c783          	lbu	a5,24(a5)
    800053fa:	e7b9                	bnez	a5,80005448 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053fc:	00451693          	sll	a3,a0,0x4
    80005400:	0002d797          	auipc	a5,0x2d
    80005404:	66078793          	add	a5,a5,1632 # 80032a60 <disk>
    80005408:	6398                	ld	a4,0(a5)
    8000540a:	9736                	add	a4,a4,a3
    8000540c:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005410:	6398                	ld	a4,0(a5)
    80005412:	9736                	add	a4,a4,a3
    80005414:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005418:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000541c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005420:	97aa                	add	a5,a5,a0
    80005422:	4705                	li	a4,1
    80005424:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005428:	0002d517          	auipc	a0,0x2d
    8000542c:	65050513          	add	a0,a0,1616 # 80032a78 <disk+0x18>
    80005430:	ac3fc0ef          	jal	80001ef2 <wakeup>
}
    80005434:	60a2                	ld	ra,8(sp)
    80005436:	6402                	ld	s0,0(sp)
    80005438:	0141                	add	sp,sp,16
    8000543a:	8082                	ret
    panic("free_desc 1");
    8000543c:	00002517          	auipc	a0,0x2
    80005440:	38c50513          	add	a0,a0,908 # 800077c8 <syscalls+0x338>
    80005444:	b1afb0ef          	jal	8000075e <panic>
    panic("free_desc 2");
    80005448:	00002517          	auipc	a0,0x2
    8000544c:	39050513          	add	a0,a0,912 # 800077d8 <syscalls+0x348>
    80005450:	b0efb0ef          	jal	8000075e <panic>

0000000080005454 <virtio_disk_init>:
{
    80005454:	1101                	add	sp,sp,-32
    80005456:	ec06                	sd	ra,24(sp)
    80005458:	e822                	sd	s0,16(sp)
    8000545a:	e426                	sd	s1,8(sp)
    8000545c:	e04a                	sd	s2,0(sp)
    8000545e:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005460:	00002597          	auipc	a1,0x2
    80005464:	38858593          	add	a1,a1,904 # 800077e8 <syscalls+0x358>
    80005468:	0002d517          	auipc	a0,0x2d
    8000546c:	72050513          	add	a0,a0,1824 # 80032b88 <disk+0x128>
    80005470:	eb0fb0ef          	jal	80000b20 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005474:	100017b7          	lui	a5,0x10001
    80005478:	4398                	lw	a4,0(a5)
    8000547a:	2701                	sext.w	a4,a4
    8000547c:	747277b7          	lui	a5,0x74727
    80005480:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005484:	12f71f63          	bne	a4,a5,800055c2 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005488:	100017b7          	lui	a5,0x10001
    8000548c:	43dc                	lw	a5,4(a5)
    8000548e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005490:	4709                	li	a4,2
    80005492:	12e79863          	bne	a5,a4,800055c2 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005496:	100017b7          	lui	a5,0x10001
    8000549a:	479c                	lw	a5,8(a5)
    8000549c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000549e:	12e79263          	bne	a5,a4,800055c2 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054a2:	100017b7          	lui	a5,0x10001
    800054a6:	47d8                	lw	a4,12(a5)
    800054a8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054aa:	554d47b7          	lui	a5,0x554d4
    800054ae:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054b2:	10f71863          	bne	a4,a5,800055c2 <virtio_disk_init+0x16e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054b6:	100017b7          	lui	a5,0x10001
    800054ba:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054be:	4705                	li	a4,1
    800054c0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054c2:	470d                	li	a4,3
    800054c4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054c6:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054c8:	c7ffe6b7          	lui	a3,0xc7ffe
    800054cc:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fcbbbf>
    800054d0:	8f75                	and	a4,a4,a3
    800054d2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054d4:	472d                	li	a4,11
    800054d6:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800054d8:	5bbc                	lw	a5,112(a5)
    800054da:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054de:	8ba1                	and	a5,a5,8
    800054e0:	0e078763          	beqz	a5,800055ce <virtio_disk_init+0x17a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054e4:	100017b7          	lui	a5,0x10001
    800054e8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054ec:	43fc                	lw	a5,68(a5)
    800054ee:	2781                	sext.w	a5,a5
    800054f0:	0e079563          	bnez	a5,800055da <virtio_disk_init+0x186>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054f4:	100017b7          	lui	a5,0x10001
    800054f8:	5bdc                	lw	a5,52(a5)
    800054fa:	2781                	sext.w	a5,a5
  if(max == 0)
    800054fc:	0e078563          	beqz	a5,800055e6 <virtio_disk_init+0x192>
  if(max < NUM)
    80005500:	471d                	li	a4,7
    80005502:	0ef77863          	bgeu	a4,a5,800055f2 <virtio_disk_init+0x19e>
  disk.desc = kalloc();
    80005506:	dcafb0ef          	jal	80000ad0 <kalloc>
    8000550a:	0002d497          	auipc	s1,0x2d
    8000550e:	55648493          	add	s1,s1,1366 # 80032a60 <disk>
    80005512:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005514:	dbcfb0ef          	jal	80000ad0 <kalloc>
    80005518:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000551a:	db6fb0ef          	jal	80000ad0 <kalloc>
    8000551e:	87aa                	mv	a5,a0
    80005520:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005522:	6088                	ld	a0,0(s1)
    80005524:	cd69                	beqz	a0,800055fe <virtio_disk_init+0x1aa>
    80005526:	0002d717          	auipc	a4,0x2d
    8000552a:	54273703          	ld	a4,1346(a4) # 80032a68 <disk+0x8>
    8000552e:	cb61                	beqz	a4,800055fe <virtio_disk_init+0x1aa>
    80005530:	c7f9                	beqz	a5,800055fe <virtio_disk_init+0x1aa>
  memset(disk.desc, 0, PGSIZE);
    80005532:	6605                	lui	a2,0x1
    80005534:	4581                	li	a1,0
    80005536:	f3efb0ef          	jal	80000c74 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000553a:	0002d497          	auipc	s1,0x2d
    8000553e:	52648493          	add	s1,s1,1318 # 80032a60 <disk>
    80005542:	6605                	lui	a2,0x1
    80005544:	4581                	li	a1,0
    80005546:	6488                	ld	a0,8(s1)
    80005548:	f2cfb0ef          	jal	80000c74 <memset>
  memset(disk.used, 0, PGSIZE);
    8000554c:	6605                	lui	a2,0x1
    8000554e:	4581                	li	a1,0
    80005550:	6888                	ld	a0,16(s1)
    80005552:	f22fb0ef          	jal	80000c74 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005556:	100017b7          	lui	a5,0x10001
    8000555a:	4721                	li	a4,8
    8000555c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000555e:	4098                	lw	a4,0(s1)
    80005560:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005564:	40d8                	lw	a4,4(s1)
    80005566:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000556a:	6498                	ld	a4,8(s1)
    8000556c:	0007069b          	sext.w	a3,a4
    80005570:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005574:	9701                	sra	a4,a4,0x20
    80005576:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000557a:	6898                	ld	a4,16(s1)
    8000557c:	0007069b          	sext.w	a3,a4
    80005580:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005584:	9701                	sra	a4,a4,0x20
    80005586:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000558a:	4705                	li	a4,1
    8000558c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000558e:	00e48c23          	sb	a4,24(s1)
    80005592:	00e48ca3          	sb	a4,25(s1)
    80005596:	00e48d23          	sb	a4,26(s1)
    8000559a:	00e48da3          	sb	a4,27(s1)
    8000559e:	00e48e23          	sb	a4,28(s1)
    800055a2:	00e48ea3          	sb	a4,29(s1)
    800055a6:	00e48f23          	sb	a4,30(s1)
    800055aa:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055ae:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055b2:	0727a823          	sw	s2,112(a5)
}
    800055b6:	60e2                	ld	ra,24(sp)
    800055b8:	6442                	ld	s0,16(sp)
    800055ba:	64a2                	ld	s1,8(sp)
    800055bc:	6902                	ld	s2,0(sp)
    800055be:	6105                	add	sp,sp,32
    800055c0:	8082                	ret
    panic("could not find virtio disk");
    800055c2:	00002517          	auipc	a0,0x2
    800055c6:	23650513          	add	a0,a0,566 # 800077f8 <syscalls+0x368>
    800055ca:	994fb0ef          	jal	8000075e <panic>
    panic("virtio disk FEATURES_OK unset");
    800055ce:	00002517          	auipc	a0,0x2
    800055d2:	24a50513          	add	a0,a0,586 # 80007818 <syscalls+0x388>
    800055d6:	988fb0ef          	jal	8000075e <panic>
    panic("virtio disk should not be ready");
    800055da:	00002517          	auipc	a0,0x2
    800055de:	25e50513          	add	a0,a0,606 # 80007838 <syscalls+0x3a8>
    800055e2:	97cfb0ef          	jal	8000075e <panic>
    panic("virtio disk has no queue 0");
    800055e6:	00002517          	auipc	a0,0x2
    800055ea:	27250513          	add	a0,a0,626 # 80007858 <syscalls+0x3c8>
    800055ee:	970fb0ef          	jal	8000075e <panic>
    panic("virtio disk max queue too short");
    800055f2:	00002517          	auipc	a0,0x2
    800055f6:	28650513          	add	a0,a0,646 # 80007878 <syscalls+0x3e8>
    800055fa:	964fb0ef          	jal	8000075e <panic>
    panic("virtio disk kalloc");
    800055fe:	00002517          	auipc	a0,0x2
    80005602:	29a50513          	add	a0,a0,666 # 80007898 <syscalls+0x408>
    80005606:	958fb0ef          	jal	8000075e <panic>

000000008000560a <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000560a:	7159                	add	sp,sp,-112
    8000560c:	f486                	sd	ra,104(sp)
    8000560e:	f0a2                	sd	s0,96(sp)
    80005610:	eca6                	sd	s1,88(sp)
    80005612:	e8ca                	sd	s2,80(sp)
    80005614:	e4ce                	sd	s3,72(sp)
    80005616:	e0d2                	sd	s4,64(sp)
    80005618:	fc56                	sd	s5,56(sp)
    8000561a:	f85a                	sd	s6,48(sp)
    8000561c:	f45e                	sd	s7,40(sp)
    8000561e:	f062                	sd	s8,32(sp)
    80005620:	ec66                	sd	s9,24(sp)
    80005622:	e86a                	sd	s10,16(sp)
    80005624:	1880                	add	s0,sp,112
    80005626:	8a2a                	mv	s4,a0
    80005628:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000562a:	00c52c83          	lw	s9,12(a0)
    8000562e:	001c9c9b          	sllw	s9,s9,0x1
    80005632:	1c82                	sll	s9,s9,0x20
    80005634:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005638:	0002d517          	auipc	a0,0x2d
    8000563c:	55050513          	add	a0,a0,1360 # 80032b88 <disk+0x128>
    80005640:	d60fb0ef          	jal	80000ba0 <acquire>
  for(int i = 0; i < 3; i++){
    80005644:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005646:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005648:	0002db17          	auipc	s6,0x2d
    8000564c:	418b0b13          	add	s6,s6,1048 # 80032a60 <disk>
  for(int i = 0; i < 3; i++){
    80005650:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005652:	0002dc17          	auipc	s8,0x2d
    80005656:	536c0c13          	add	s8,s8,1334 # 80032b88 <disk+0x128>
    8000565a:	a8b1                	j	800056b6 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    8000565c:	00fb0733          	add	a4,s6,a5
    80005660:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005664:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005666:	0207c563          	bltz	a5,80005690 <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    8000566a:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    8000566c:	0591                	add	a1,a1,4
    8000566e:	05560963          	beq	a2,s5,800056c0 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    80005672:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005674:	0002d717          	auipc	a4,0x2d
    80005678:	3ec70713          	add	a4,a4,1004 # 80032a60 <disk>
    8000567c:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000567e:	01874683          	lbu	a3,24(a4)
    80005682:	fee9                	bnez	a3,8000565c <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005684:	2785                	addw	a5,a5,1
    80005686:	0705                	add	a4,a4,1
    80005688:	fe979be3          	bne	a5,s1,8000567e <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    8000568c:	57fd                	li	a5,-1
    8000568e:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80005690:	00c05c63          	blez	a2,800056a8 <virtio_disk_rw+0x9e>
    80005694:	060a                	sll	a2,a2,0x2
    80005696:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    8000569a:	0009a503          	lw	a0,0(s3)
    8000569e:	d41ff0ef          	jal	800053de <free_desc>
      for(int j = 0; j < i; j++)
    800056a2:	0991                	add	s3,s3,4
    800056a4:	ffa99be3          	bne	s3,s10,8000569a <virtio_disk_rw+0x90>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056a8:	85e2                	mv	a1,s8
    800056aa:	0002d517          	auipc	a0,0x2d
    800056ae:	3ce50513          	add	a0,a0,974 # 80032a78 <disk+0x18>
    800056b2:	ff4fc0ef          	jal	80001ea6 <sleep>
  for(int i = 0; i < 3; i++){
    800056b6:	f9040993          	add	s3,s0,-112
{
    800056ba:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    800056bc:	864a                	mv	a2,s2
    800056be:	bf55                	j	80005672 <virtio_disk_rw+0x68>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056c0:	f9042503          	lw	a0,-112(s0)
    800056c4:	00a50713          	add	a4,a0,10
    800056c8:	0712                	sll	a4,a4,0x4

  if(write)
    800056ca:	0002d797          	auipc	a5,0x2d
    800056ce:	39678793          	add	a5,a5,918 # 80032a60 <disk>
    800056d2:	00e786b3          	add	a3,a5,a4
    800056d6:	01703633          	snez	a2,s7
    800056da:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056dc:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800056e0:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056e4:	f6070613          	add	a2,a4,-160
    800056e8:	6394                	ld	a3,0(a5)
    800056ea:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056ec:	00870593          	add	a1,a4,8
    800056f0:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800056f2:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056f4:	0007b803          	ld	a6,0(a5)
    800056f8:	9642                	add	a2,a2,a6
    800056fa:	46c1                	li	a3,16
    800056fc:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056fe:	4585                	li	a1,1
    80005700:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005704:	f9442683          	lw	a3,-108(s0)
    80005708:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000570c:	0692                	sll	a3,a3,0x4
    8000570e:	9836                	add	a6,a6,a3
    80005710:	058a0613          	add	a2,s4,88
    80005714:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80005718:	0007b803          	ld	a6,0(a5)
    8000571c:	96c2                	add	a3,a3,a6
    8000571e:	40000613          	li	a2,1024
    80005722:	c690                	sw	a2,8(a3)
  if(write)
    80005724:	001bb613          	seqz	a2,s7
    80005728:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000572c:	00166613          	or	a2,a2,1
    80005730:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005734:	f9842603          	lw	a2,-104(s0)
    80005738:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000573c:	00250693          	add	a3,a0,2
    80005740:	0692                	sll	a3,a3,0x4
    80005742:	96be                	add	a3,a3,a5
    80005744:	58fd                	li	a7,-1
    80005746:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000574a:	0612                	sll	a2,a2,0x4
    8000574c:	9832                	add	a6,a6,a2
    8000574e:	f9070713          	add	a4,a4,-112
    80005752:	973e                	add	a4,a4,a5
    80005754:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    80005758:	6398                	ld	a4,0(a5)
    8000575a:	9732                	add	a4,a4,a2
    8000575c:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000575e:	4609                	li	a2,2
    80005760:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005764:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005768:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    8000576c:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005770:	6794                	ld	a3,8(a5)
    80005772:	0026d703          	lhu	a4,2(a3)
    80005776:	8b1d                	and	a4,a4,7
    80005778:	0706                	sll	a4,a4,0x1
    8000577a:	96ba                	add	a3,a3,a4
    8000577c:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005780:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005784:	6798                	ld	a4,8(a5)
    80005786:	00275783          	lhu	a5,2(a4)
    8000578a:	2785                	addw	a5,a5,1
    8000578c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005790:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005794:	100017b7          	lui	a5,0x10001
    80005798:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000579c:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800057a0:	0002d917          	auipc	s2,0x2d
    800057a4:	3e890913          	add	s2,s2,1000 # 80032b88 <disk+0x128>
  while(b->disk == 1) {
    800057a8:	4485                	li	s1,1
    800057aa:	00b79a63          	bne	a5,a1,800057be <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    800057ae:	85ca                	mv	a1,s2
    800057b0:	8552                	mv	a0,s4
    800057b2:	ef4fc0ef          	jal	80001ea6 <sleep>
  while(b->disk == 1) {
    800057b6:	004a2783          	lw	a5,4(s4)
    800057ba:	fe978ae3          	beq	a5,s1,800057ae <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    800057be:	f9042903          	lw	s2,-112(s0)
    800057c2:	00290713          	add	a4,s2,2
    800057c6:	0712                	sll	a4,a4,0x4
    800057c8:	0002d797          	auipc	a5,0x2d
    800057cc:	29878793          	add	a5,a5,664 # 80032a60 <disk>
    800057d0:	97ba                	add	a5,a5,a4
    800057d2:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800057d6:	0002d997          	auipc	s3,0x2d
    800057da:	28a98993          	add	s3,s3,650 # 80032a60 <disk>
    800057de:	00491713          	sll	a4,s2,0x4
    800057e2:	0009b783          	ld	a5,0(s3)
    800057e6:	97ba                	add	a5,a5,a4
    800057e8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057ec:	854a                	mv	a0,s2
    800057ee:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057f2:	bedff0ef          	jal	800053de <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057f6:	8885                	and	s1,s1,1
    800057f8:	f0fd                	bnez	s1,800057de <virtio_disk_rw+0x1d4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057fa:	0002d517          	auipc	a0,0x2d
    800057fe:	38e50513          	add	a0,a0,910 # 80032b88 <disk+0x128>
    80005802:	c36fb0ef          	jal	80000c38 <release>
}
    80005806:	70a6                	ld	ra,104(sp)
    80005808:	7406                	ld	s0,96(sp)
    8000580a:	64e6                	ld	s1,88(sp)
    8000580c:	6946                	ld	s2,80(sp)
    8000580e:	69a6                	ld	s3,72(sp)
    80005810:	6a06                	ld	s4,64(sp)
    80005812:	7ae2                	ld	s5,56(sp)
    80005814:	7b42                	ld	s6,48(sp)
    80005816:	7ba2                	ld	s7,40(sp)
    80005818:	7c02                	ld	s8,32(sp)
    8000581a:	6ce2                	ld	s9,24(sp)
    8000581c:	6d42                	ld	s10,16(sp)
    8000581e:	6165                	add	sp,sp,112
    80005820:	8082                	ret

0000000080005822 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005822:	1101                	add	sp,sp,-32
    80005824:	ec06                	sd	ra,24(sp)
    80005826:	e822                	sd	s0,16(sp)
    80005828:	e426                	sd	s1,8(sp)
    8000582a:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000582c:	0002d497          	auipc	s1,0x2d
    80005830:	23448493          	add	s1,s1,564 # 80032a60 <disk>
    80005834:	0002d517          	auipc	a0,0x2d
    80005838:	35450513          	add	a0,a0,852 # 80032b88 <disk+0x128>
    8000583c:	b64fb0ef          	jal	80000ba0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005840:	10001737          	lui	a4,0x10001
    80005844:	533c                	lw	a5,96(a4)
    80005846:	8b8d                	and	a5,a5,3
    80005848:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000584a:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000584e:	689c                	ld	a5,16(s1)
    80005850:	0204d703          	lhu	a4,32(s1)
    80005854:	0027d783          	lhu	a5,2(a5)
    80005858:	04f70663          	beq	a4,a5,800058a4 <virtio_disk_intr+0x82>
    __sync_synchronize();
    8000585c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005860:	6898                	ld	a4,16(s1)
    80005862:	0204d783          	lhu	a5,32(s1)
    80005866:	8b9d                	and	a5,a5,7
    80005868:	078e                	sll	a5,a5,0x3
    8000586a:	97ba                	add	a5,a5,a4
    8000586c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000586e:	00278713          	add	a4,a5,2
    80005872:	0712                	sll	a4,a4,0x4
    80005874:	9726                	add	a4,a4,s1
    80005876:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000587a:	e321                	bnez	a4,800058ba <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000587c:	0789                	add	a5,a5,2
    8000587e:	0792                	sll	a5,a5,0x4
    80005880:	97a6                	add	a5,a5,s1
    80005882:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005884:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005888:	e6afc0ef          	jal	80001ef2 <wakeup>

    disk.used_idx += 1;
    8000588c:	0204d783          	lhu	a5,32(s1)
    80005890:	2785                	addw	a5,a5,1
    80005892:	17c2                	sll	a5,a5,0x30
    80005894:	93c1                	srl	a5,a5,0x30
    80005896:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000589a:	6898                	ld	a4,16(s1)
    8000589c:	00275703          	lhu	a4,2(a4)
    800058a0:	faf71ee3          	bne	a4,a5,8000585c <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    800058a4:	0002d517          	auipc	a0,0x2d
    800058a8:	2e450513          	add	a0,a0,740 # 80032b88 <disk+0x128>
    800058ac:	b8cfb0ef          	jal	80000c38 <release>
}
    800058b0:	60e2                	ld	ra,24(sp)
    800058b2:	6442                	ld	s0,16(sp)
    800058b4:	64a2                	ld	s1,8(sp)
    800058b6:	6105                	add	sp,sp,32
    800058b8:	8082                	ret
      panic("virtio_disk_intr status");
    800058ba:	00002517          	auipc	a0,0x2
    800058be:	ff650513          	add	a0,a0,-10 # 800078b0 <syscalls+0x420>
    800058c2:	e9dfa0ef          	jal	8000075e <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	sll	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	sll	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
