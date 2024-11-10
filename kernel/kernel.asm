
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	8f013103          	ld	sp,-1808(sp) # 800078f0 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    8000006e:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd77f>
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
    800000fa:	0ca020ef          	jal	800021c4 <either_copyin>
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
    80000150:	80450513          	add	a0,a0,-2044 # 8000f950 <cons>
    80000154:	24d000ef          	jal	80000ba0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000158:	0000f497          	auipc	s1,0xf
    8000015c:	7f848493          	add	s1,s1,2040 # 8000f950 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000160:	00010917          	auipc	s2,0x10
    80000164:	88890913          	add	s2,s2,-1912 # 8000f9e8 <cons+0x98>
  while(n > 0){
    80000168:	07305a63          	blez	s3,800001dc <consoleread+0xb0>
    while(cons.r == cons.w){
    8000016c:	0984a783          	lw	a5,152(s1)
    80000170:	09c4a703          	lw	a4,156(s1)
    80000174:	02f71163          	bne	a4,a5,80000196 <consoleread+0x6a>
      if(killed(myproc())){
    80000178:	6b8010ef          	jal	80001830 <myproc>
    8000017c:	6db010ef          	jal	80002056 <killed>
    80000180:	e53d                	bnez	a0,800001ee <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80000182:	85a6                	mv	a1,s1
    80000184:	854a                	mv	a0,s2
    80000186:	499010ef          	jal	80001e1e <sleep>
    while(cons.r == cons.w){
    8000018a:	0984a783          	lw	a5,152(s1)
    8000018e:	09c4a703          	lw	a4,156(s1)
    80000192:	fef703e3          	beq	a4,a5,80000178 <consoleread+0x4c>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80000196:	0000f717          	auipc	a4,0xf
    8000019a:	7ba70713          	add	a4,a4,1978 # 8000f950 <cons>
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
    800001c8:	7b3010ef          	jal	8000217a <either_copyout>
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
    800001e0:	77450513          	add	a0,a0,1908 # 8000f950 <cons>
    800001e4:	255000ef          	jal	80000c38 <release>

  return target - n;
    800001e8:	413b053b          	subw	a0,s6,s3
    800001ec:	a801                	j	800001fc <consoleread+0xd0>
        release(&cons.lock);
    800001ee:	0000f517          	auipc	a0,0xf
    800001f2:	76250513          	add	a0,a0,1890 # 8000f950 <cons>
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
    8000021e:	7cf72723          	sw	a5,1998(a4) # 8000f9e8 <cons+0x98>
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
    80000268:	6ec50513          	add	a0,a0,1772 # 8000f950 <cons>
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
    80000286:	789010ef          	jal	8000220e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000028a:	0000f517          	auipc	a0,0xf
    8000028e:	6c650513          	add	a0,a0,1734 # 8000f950 <cons>
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
    800002ae:	6a670713          	add	a4,a4,1702 # 8000f950 <cons>
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
    800002d4:	68078793          	add	a5,a5,1664 # 8000f950 <cons>
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
    80000302:	6ea7a783          	lw	a5,1770(a5) # 8000f9e8 <cons+0x98>
    80000306:	9f1d                	subw	a4,a4,a5
    80000308:	08000793          	li	a5,128
    8000030c:	f6f71fe3          	bne	a4,a5,8000028a <consoleintr+0x34>
    80000310:	a04d                	j	800003b2 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80000312:	0000f717          	auipc	a4,0xf
    80000316:	63e70713          	add	a4,a4,1598 # 8000f950 <cons>
    8000031a:	0a072783          	lw	a5,160(a4)
    8000031e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000322:	0000f497          	auipc	s1,0xf
    80000326:	62e48493          	add	s1,s1,1582 # 8000f950 <cons>
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
    8000035e:	5f670713          	add	a4,a4,1526 # 8000f950 <cons>
    80000362:	0a072783          	lw	a5,160(a4)
    80000366:	09c72703          	lw	a4,156(a4)
    8000036a:	f2f700e3          	beq	a4,a5,8000028a <consoleintr+0x34>
      cons.e--;
    8000036e:	37fd                	addw	a5,a5,-1
    80000370:	0000f717          	auipc	a4,0xf
    80000374:	68f72023          	sw	a5,1664(a4) # 8000f9f0 <cons+0xa0>
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
    80000392:	5c278793          	add	a5,a5,1474 # 8000f950 <cons>
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
    800003b6:	62c7ad23          	sw	a2,1594(a5) # 8000f9ec <cons+0x9c>
        wakeup(&cons.r);
    800003ba:	0000f517          	auipc	a0,0xf
    800003be:	62e50513          	add	a0,a0,1582 # 8000f9e8 <cons+0x98>
    800003c2:	2a9010ef          	jal	80001e6a <wakeup>
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
    800003dc:	57850513          	add	a0,a0,1400 # 8000f950 <cons>
    800003e0:	740000ef          	jal	80000b20 <initlock>

  uartinit();
    800003e4:	3e2000ef          	jal	800007c6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800003e8:	00020797          	auipc	a5,0x20
    800003ec:	b0078793          	add	a5,a5,-1280 # 8001fee8 <devsw>
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
    800004d4:	5407a783          	lw	a5,1344(a5) # 8000fa10 <pr+0x18>
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
    8000050e:	4ee50513          	add	a0,a0,1262 # 8000f9f8 <pr>
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
    80000528:	4d450513          	add	a0,a0,1236 # 8000f9f8 <pr>
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
    8000076e:	2a07a323          	sw	zero,678(a5) # 8000fa10 <pr+0x18>
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
    80000792:	18f72123          	sw	a5,386(a4) # 80007910 <panicked>
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
    800007a6:	25648493          	add	s1,s1,598 # 8000f9f8 <pr>
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
    80000802:	21a50513          	add	a0,a0,538 # 8000fa18 <uart_tx_lock>
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
    80000826:	0ee7a783          	lw	a5,238(a5) # 80007910 <panicked>
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
    8000085a:	0c27b783          	ld	a5,194(a5) # 80007918 <uart_tx_r>
    8000085e:	00007717          	auipc	a4,0x7
    80000862:	0c273703          	ld	a4,194(a4) # 80007920 <uart_tx_w>
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
    80000884:	198a0a13          	add	s4,s4,408 # 8000fa18 <uart_tx_lock>
    uart_tx_r += 1;
    80000888:	00007497          	auipc	s1,0x7
    8000088c:	09048493          	add	s1,s1,144 # 80007918 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000890:	00007997          	auipc	s3,0x7
    80000894:	09098993          	add	s3,s3,144 # 80007920 <uart_tx_w>
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
    800008b2:	5b8010ef          	jal	80001e6a <wakeup>
    
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
    800008fe:	11e50513          	add	a0,a0,286 # 8000fa18 <uart_tx_lock>
    80000902:	29e000ef          	jal	80000ba0 <acquire>
  if(panicked){
    80000906:	00007797          	auipc	a5,0x7
    8000090a:	00a7a783          	lw	a5,10(a5) # 80007910 <panicked>
    8000090e:	efbd                	bnez	a5,8000098c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000910:	00007717          	auipc	a4,0x7
    80000914:	01073703          	ld	a4,16(a4) # 80007920 <uart_tx_w>
    80000918:	00007797          	auipc	a5,0x7
    8000091c:	0007b783          	ld	a5,0(a5) # 80007918 <uart_tx_r>
    80000920:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000924:	0000f997          	auipc	s3,0xf
    80000928:	0f498993          	add	s3,s3,244 # 8000fa18 <uart_tx_lock>
    8000092c:	00007497          	auipc	s1,0x7
    80000930:	fec48493          	add	s1,s1,-20 # 80007918 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000934:	00007917          	auipc	s2,0x7
    80000938:	fec90913          	add	s2,s2,-20 # 80007920 <uart_tx_w>
    8000093c:	00e79d63          	bne	a5,a4,80000956 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000940:	85ce                	mv	a1,s3
    80000942:	8526                	mv	a0,s1
    80000944:	4da010ef          	jal	80001e1e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000948:	00093703          	ld	a4,0(s2)
    8000094c:	609c                	ld	a5,0(s1)
    8000094e:	02078793          	add	a5,a5,32
    80000952:	fee787e3          	beq	a5,a4,80000940 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000956:	0000f497          	auipc	s1,0xf
    8000095a:	0c248493          	add	s1,s1,194 # 8000fa18 <uart_tx_lock>
    8000095e:	01f77793          	and	a5,a4,31
    80000962:	97a6                	add	a5,a5,s1
    80000964:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000968:	0705                	add	a4,a4,1
    8000096a:	00007797          	auipc	a5,0x7
    8000096e:	fae7bb23          	sd	a4,-74(a5) # 80007920 <uart_tx_w>
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
    800009d0:	04c48493          	add	s1,s1,76 # 8000fa18 <uart_tx_lock>
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
    80000a02:	00020797          	auipc	a5,0x20
    80000a06:	67e78793          	add	a5,a5,1662 # 80021080 <end>
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
    80000a22:	03290913          	add	s2,s2,50 # 8000fa50 <kmem>
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
    80000ab0:	fa450513          	add	a0,a0,-92 # 8000fa50 <kmem>
    80000ab4:	06c000ef          	jal	80000b20 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab8:	45c5                	li	a1,17
    80000aba:	05ee                	sll	a1,a1,0x1b
    80000abc:	00020517          	auipc	a0,0x20
    80000ac0:	5c450513          	add	a0,a0,1476 # 80021080 <end>
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
    80000ade:	f7648493          	add	s1,s1,-138 # 8000fa50 <kmem>
    80000ae2:	8526                	mv	a0,s1
    80000ae4:	0bc000ef          	jal	80000ba0 <acquire>
  r = kmem.freelist;
    80000ae8:	6c84                	ld	s1,24(s1)
  if(r)
    80000aea:	c485                	beqz	s1,80000b12 <kalloc+0x42>
    kmem.freelist = r->next;
    80000aec:	609c                	ld	a5,0(s1)
    80000aee:	0000f517          	auipc	a0,0xf
    80000af2:	f6250513          	add	a0,a0,-158 # 8000fa50 <kmem>
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
    80000b16:	f3e50513          	add	a0,a0,-194 # 8000fa50 <kmem>
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
    80000ce8:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffddf81>
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
    80000e24:	b0870713          	add	a4,a4,-1272 # 80007928 <started>
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
    80000e4a:	64c010ef          	jal	80002496 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e4e:	396040ef          	jal	800051e4 <plicinithart>
  }

  scheduler();        
    80000e52:	61d000ef          	jal	80001c6e <scheduler>
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
    80000e92:	5e0010ef          	jal	80002472 <trapinit>
    trapinithart();  // install kernel trap vector
    80000e96:	600010ef          	jal	80002496 <trapinithart>
    plicinit();      // set up interrupt controller
    80000e9a:	334040ef          	jal	800051ce <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000e9e:	346040ef          	jal	800051e4 <plicinithart>
    binit();         // buffer cache
    80000ea2:	41f010ef          	jal	80002ac0 <binit>
    iinit();         // inode table
    80000ea6:	1f8020ef          	jal	8000309e <iinit>
    fileinit();      // file table
    80000eaa:	76b020ef          	jal	80003e14 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000eae:	426040ef          	jal	800052d4 <virtio_disk_init>
    userinit();      // first user process
    80000eb2:	3f3000ef          	jal	80001aa4 <userinit>
    __sync_synchronize();
    80000eb6:	0ff0000f          	fence
    started = 1;
    80000eba:	4785                	li	a5,1
    80000ebc:	00007717          	auipc	a4,0x7
    80000ec0:	a6f72623          	sw	a5,-1428(a4) # 80007928 <started>
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
    80000ed4:	a607b783          	ld	a5,-1440(a5) # 80007930 <kernel_pagetable>
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
    80000f42:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffddf77>
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
    8000115c:	00006797          	auipc	a5,0x6
    80001160:	7ca7ba23          	sd	a0,2004(a5) # 80007930 <kernel_pagetable>
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
    800016b6:	14fd                	add	s1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffddf7f>
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
    800016e8:	0000e497          	auipc	s1,0xe
    800016ec:	7b848493          	add	s1,s1,1976 # 8000fea0 <proc>
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
    80001702:	00014a17          	auipc	s4,0x14
    80001706:	59ea0a13          	add	s4,s4,1438 # 80015ca0 <tickslock>
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
    8000177c:	2f850513          	add	a0,a0,760 # 8000fa70 <pid_lock>
    80001780:	ba0ff0ef          	jal	80000b20 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001784:	00006597          	auipc	a1,0x6
    80001788:	a9c58593          	add	a1,a1,-1380 # 80007220 <digits+0x1e8>
    8000178c:	0000e517          	auipc	a0,0xe
    80001790:	2fc50513          	add	a0,a0,764 # 8000fa88 <wait_lock>
    80001794:	b8cff0ef          	jal	80000b20 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001798:	0000e497          	auipc	s1,0xe
    8000179c:	70848493          	add	s1,s1,1800 # 8000fea0 <proc>
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
    800017ba:	00014997          	auipc	s3,0x14
    800017be:	4e698993          	add	s3,s3,1254 # 80015ca0 <tickslock>
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
    80001824:	28050513          	add	a0,a0,640 # 8000faa0 <cpus>
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
    80001848:	22c70713          	add	a4,a4,556 # 8000fa70 <pid_lock>
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
    80001874:	0307a783          	lw	a5,48(a5) # 800078a0 <first.1>
    80001878:	e799                	bnez	a5,80001886 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    8000187a:	435000ef          	jal	800024ae <usertrapret>
}
    8000187e:	60a2                	ld	ra,8(sp)
    80001880:	6402                	ld	s0,0(sp)
    80001882:	0141                	add	sp,sp,16
    80001884:	8082                	ret
    fsinit(ROOTDEV);
    80001886:	4505                	li	a0,1
    80001888:	7aa010ef          	jal	80003032 <fsinit>
    first = 0;
    8000188c:	00006797          	auipc	a5,0x6
    80001890:	0007aa23          	sw	zero,20(a5) # 800078a0 <first.1>
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
    800018aa:	1ca90913          	add	s2,s2,458 # 8000fa70 <pid_lock>
    800018ae:	854a                	mv	a0,s2
    800018b0:	af0ff0ef          	jal	80000ba0 <acquire>
  pid = nextpid;
    800018b4:	00006797          	auipc	a5,0x6
    800018b8:	ff078793          	add	a5,a5,-16 # 800078a4 <nextpid>
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
    80001a02:	4a248493          	add	s1,s1,1186 # 8000fea0 <proc>
    80001a06:	00014917          	auipc	s2,0x14
    80001a0a:	29a90913          	add	s2,s2,666 # 80015ca0 <tickslock>
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
    80001a28:	a0b9                	j	80001a76 <allocproc+0x84>
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
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001a40:	890ff0ef          	jal	80000ad0 <kalloc>
    80001a44:	892a                	mv	s2,a0
    80001a46:	eca8                	sd	a0,88(s1)
    80001a48:	cd15                	beqz	a0,80001a84 <allocproc+0x92>
  p->pagetable = proc_pagetable(p);
    80001a4a:	8526                	mv	a0,s1
    80001a4c:	e8dff0ef          	jal	800018d8 <proc_pagetable>
    80001a50:	892a                	mv	s2,a0
    80001a52:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001a54:	c121                	beqz	a0,80001a94 <allocproc+0xa2>
  memset(&p->context, 0, sizeof(p->context));
    80001a56:	07000613          	li	a2,112
    80001a5a:	4581                	li	a1,0
    80001a5c:	06048513          	add	a0,s1,96
    80001a60:	a14ff0ef          	jal	80000c74 <memset>
  p->context.ra = (uint64)forkret;
    80001a64:	00000797          	auipc	a5,0x0
    80001a68:	dfc78793          	add	a5,a5,-516 # 80001860 <forkret>
    80001a6c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001a6e:	60bc                	ld	a5,64(s1)
    80001a70:	6705                	lui	a4,0x1
    80001a72:	97ba                	add	a5,a5,a4
    80001a74:	f4bc                	sd	a5,104(s1)
}
    80001a76:	8526                	mv	a0,s1
    80001a78:	60e2                	ld	ra,24(sp)
    80001a7a:	6442                	ld	s0,16(sp)
    80001a7c:	64a2                	ld	s1,8(sp)
    80001a7e:	6902                	ld	s2,0(sp)
    80001a80:	6105                	add	sp,sp,32
    80001a82:	8082                	ret
    freeproc(p);
    80001a84:	8526                	mv	a0,s1
    80001a86:	f1dff0ef          	jal	800019a2 <freeproc>
    release(&p->lock);
    80001a8a:	8526                	mv	a0,s1
    80001a8c:	9acff0ef          	jal	80000c38 <release>
    return 0;
    80001a90:	84ca                	mv	s1,s2
    80001a92:	b7d5                	j	80001a76 <allocproc+0x84>
    freeproc(p);
    80001a94:	8526                	mv	a0,s1
    80001a96:	f0dff0ef          	jal	800019a2 <freeproc>
    release(&p->lock);
    80001a9a:	8526                	mv	a0,s1
    80001a9c:	99cff0ef          	jal	80000c38 <release>
    return 0;
    80001aa0:	84ca                	mv	s1,s2
    80001aa2:	bfd1                	j	80001a76 <allocproc+0x84>

0000000080001aa4 <userinit>:
{
    80001aa4:	1101                	add	sp,sp,-32
    80001aa6:	ec06                	sd	ra,24(sp)
    80001aa8:	e822                	sd	s0,16(sp)
    80001aaa:	e426                	sd	s1,8(sp)
    80001aac:	1000                	add	s0,sp,32
  p = allocproc();
    80001aae:	f45ff0ef          	jal	800019f2 <allocproc>
    80001ab2:	84aa                	mv	s1,a0
  initproc = p;
    80001ab4:	00006797          	auipc	a5,0x6
    80001ab8:	e8a7b223          	sd	a0,-380(a5) # 80007938 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001abc:	03400613          	li	a2,52
    80001ac0:	00006597          	auipc	a1,0x6
    80001ac4:	df058593          	add	a1,a1,-528 # 800078b0 <initcode>
    80001ac8:	6928                	ld	a0,80(a0)
    80001aca:	f74ff0ef          	jal	8000123e <uvmfirst>
  p->sz = PGSIZE;
    80001ace:	6785                	lui	a5,0x1
    80001ad0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ad2:	6cb8                	ld	a4,88(s1)
    80001ad4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001ad8:	6cb8                	ld	a4,88(s1)
    80001ada:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001adc:	4641                	li	a2,16
    80001ade:	00005597          	auipc	a1,0x5
    80001ae2:	75a58593          	add	a1,a1,1882 # 80007238 <digits+0x200>
    80001ae6:	15848513          	add	a0,s1,344
    80001aea:	aceff0ef          	jal	80000db8 <safestrcpy>
  p->cwd = namei("/");
    80001aee:	00005517          	auipc	a0,0x5
    80001af2:	75a50513          	add	a0,a0,1882 # 80007248 <digits+0x210>
    80001af6:	617010ef          	jal	8000390c <namei>
    80001afa:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001afe:	478d                	li	a5,3
    80001b00:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001b02:	8526                	mv	a0,s1
    80001b04:	934ff0ef          	jal	80000c38 <release>
}
    80001b08:	60e2                	ld	ra,24(sp)
    80001b0a:	6442                	ld	s0,16(sp)
    80001b0c:	64a2                	ld	s1,8(sp)
    80001b0e:	6105                	add	sp,sp,32
    80001b10:	8082                	ret

0000000080001b12 <growproc>:
{
    80001b12:	1101                	add	sp,sp,-32
    80001b14:	ec06                	sd	ra,24(sp)
    80001b16:	e822                	sd	s0,16(sp)
    80001b18:	e426                	sd	s1,8(sp)
    80001b1a:	e04a                	sd	s2,0(sp)
    80001b1c:	1000                	add	s0,sp,32
    80001b1e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001b20:	d11ff0ef          	jal	80001830 <myproc>
    80001b24:	84aa                	mv	s1,a0
  sz = p->sz;
    80001b26:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001b28:	01204c63          	bgtz	s2,80001b40 <growproc+0x2e>
  } else if(n < 0){
    80001b2c:	02094463          	bltz	s2,80001b54 <growproc+0x42>
  p->sz = sz;
    80001b30:	e4ac                	sd	a1,72(s1)
  return 0;
    80001b32:	4501                	li	a0,0
}
    80001b34:	60e2                	ld	ra,24(sp)
    80001b36:	6442                	ld	s0,16(sp)
    80001b38:	64a2                	ld	s1,8(sp)
    80001b3a:	6902                	ld	s2,0(sp)
    80001b3c:	6105                	add	sp,sp,32
    80001b3e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001b40:	4691                	li	a3,4
    80001b42:	00b90633          	add	a2,s2,a1
    80001b46:	6928                	ld	a0,80(a0)
    80001b48:	f98ff0ef          	jal	800012e0 <uvmalloc>
    80001b4c:	85aa                	mv	a1,a0
    80001b4e:	f16d                	bnez	a0,80001b30 <growproc+0x1e>
      return -1;
    80001b50:	557d                	li	a0,-1
    80001b52:	b7cd                	j	80001b34 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001b54:	00b90633          	add	a2,s2,a1
    80001b58:	6928                	ld	a0,80(a0)
    80001b5a:	f42ff0ef          	jal	8000129c <uvmdealloc>
    80001b5e:	85aa                	mv	a1,a0
    80001b60:	bfc1                	j	80001b30 <growproc+0x1e>

0000000080001b62 <fork>:
{
    80001b62:	7139                	add	sp,sp,-64
    80001b64:	fc06                	sd	ra,56(sp)
    80001b66:	f822                	sd	s0,48(sp)
    80001b68:	f426                	sd	s1,40(sp)
    80001b6a:	f04a                	sd	s2,32(sp)
    80001b6c:	ec4e                	sd	s3,24(sp)
    80001b6e:	e852                	sd	s4,16(sp)
    80001b70:	e456                	sd	s5,8(sp)
    80001b72:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001b74:	cbdff0ef          	jal	80001830 <myproc>
    80001b78:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001b7a:	e79ff0ef          	jal	800019f2 <allocproc>
    80001b7e:	0e050663          	beqz	a0,80001c6a <fork+0x108>
    80001b82:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001b84:	048ab603          	ld	a2,72(s5)
    80001b88:	692c                	ld	a1,80(a0)
    80001b8a:	050ab503          	ld	a0,80(s5)
    80001b8e:	87fff0ef          	jal	8000140c <uvmcopy>
    80001b92:	04054863          	bltz	a0,80001be2 <fork+0x80>
  np->sz = p->sz;
    80001b96:	048ab783          	ld	a5,72(s5)
    80001b9a:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001b9e:	058ab683          	ld	a3,88(s5)
    80001ba2:	87b6                	mv	a5,a3
    80001ba4:	058a3703          	ld	a4,88(s4)
    80001ba8:	12068693          	add	a3,a3,288
    80001bac:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001bb0:	6788                	ld	a0,8(a5)
    80001bb2:	6b8c                	ld	a1,16(a5)
    80001bb4:	6f90                	ld	a2,24(a5)
    80001bb6:	01073023          	sd	a6,0(a4)
    80001bba:	e708                	sd	a0,8(a4)
    80001bbc:	eb0c                	sd	a1,16(a4)
    80001bbe:	ef10                	sd	a2,24(a4)
    80001bc0:	02078793          	add	a5,a5,32
    80001bc4:	02070713          	add	a4,a4,32
    80001bc8:	fed792e3          	bne	a5,a3,80001bac <fork+0x4a>
  np->trapframe->a0 = 0;
    80001bcc:	058a3783          	ld	a5,88(s4)
    80001bd0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001bd4:	0d0a8493          	add	s1,s5,208
    80001bd8:	0d0a0913          	add	s2,s4,208
    80001bdc:	150a8993          	add	s3,s5,336
    80001be0:	a829                	j	80001bfa <fork+0x98>
    freeproc(np);
    80001be2:	8552                	mv	a0,s4
    80001be4:	dbfff0ef          	jal	800019a2 <freeproc>
    release(&np->lock);
    80001be8:	8552                	mv	a0,s4
    80001bea:	84eff0ef          	jal	80000c38 <release>
    return -1;
    80001bee:	597d                	li	s2,-1
    80001bf0:	a09d                	j	80001c56 <fork+0xf4>
  for(i = 0; i < NOFILE; i++)
    80001bf2:	04a1                	add	s1,s1,8
    80001bf4:	0921                	add	s2,s2,8
    80001bf6:	01348963          	beq	s1,s3,80001c08 <fork+0xa6>
    if(p->ofile[i])
    80001bfa:	6088                	ld	a0,0(s1)
    80001bfc:	d97d                	beqz	a0,80001bf2 <fork+0x90>
      np->ofile[i] = filedup(p->ofile[i]);
    80001bfe:	298020ef          	jal	80003e96 <filedup>
    80001c02:	00a93023          	sd	a0,0(s2)
    80001c06:	b7f5                	j	80001bf2 <fork+0x90>
  np->cwd = idup(p->cwd);
    80001c08:	150ab503          	ld	a0,336(s5)
    80001c0c:	618010ef          	jal	80003224 <idup>
    80001c10:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c14:	4641                	li	a2,16
    80001c16:	158a8593          	add	a1,s5,344
    80001c1a:	158a0513          	add	a0,s4,344
    80001c1e:	99aff0ef          	jal	80000db8 <safestrcpy>
  pid = np->pid;
    80001c22:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001c26:	8552                	mv	a0,s4
    80001c28:	810ff0ef          	jal	80000c38 <release>
  acquire(&wait_lock);
    80001c2c:	0000e497          	auipc	s1,0xe
    80001c30:	e5c48493          	add	s1,s1,-420 # 8000fa88 <wait_lock>
    80001c34:	8526                	mv	a0,s1
    80001c36:	f6bfe0ef          	jal	80000ba0 <acquire>
  np->parent = p;
    80001c3a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001c3e:	8526                	mv	a0,s1
    80001c40:	ff9fe0ef          	jal	80000c38 <release>
  acquire(&np->lock);
    80001c44:	8552                	mv	a0,s4
    80001c46:	f5bfe0ef          	jal	80000ba0 <acquire>
  np->state = RUNNABLE;
    80001c4a:	478d                	li	a5,3
    80001c4c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001c50:	8552                	mv	a0,s4
    80001c52:	fe7fe0ef          	jal	80000c38 <release>
}
    80001c56:	854a                	mv	a0,s2
    80001c58:	70e2                	ld	ra,56(sp)
    80001c5a:	7442                	ld	s0,48(sp)
    80001c5c:	74a2                	ld	s1,40(sp)
    80001c5e:	7902                	ld	s2,32(sp)
    80001c60:	69e2                	ld	s3,24(sp)
    80001c62:	6a42                	ld	s4,16(sp)
    80001c64:	6aa2                	ld	s5,8(sp)
    80001c66:	6121                	add	sp,sp,64
    80001c68:	8082                	ret
    return -1;
    80001c6a:	597d                	li	s2,-1
    80001c6c:	b7ed                	j	80001c56 <fork+0xf4>

0000000080001c6e <scheduler>:
{
    80001c6e:	715d                	add	sp,sp,-80
    80001c70:	e486                	sd	ra,72(sp)
    80001c72:	e0a2                	sd	s0,64(sp)
    80001c74:	fc26                	sd	s1,56(sp)
    80001c76:	f84a                	sd	s2,48(sp)
    80001c78:	f44e                	sd	s3,40(sp)
    80001c7a:	f052                	sd	s4,32(sp)
    80001c7c:	ec56                	sd	s5,24(sp)
    80001c7e:	e85a                	sd	s6,16(sp)
    80001c80:	e45e                	sd	s7,8(sp)
    80001c82:	e062                	sd	s8,0(sp)
    80001c84:	0880                	add	s0,sp,80
    80001c86:	8792                	mv	a5,tp
  int id = r_tp();
    80001c88:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001c8a:	00779a93          	sll	s5,a5,0x7
    80001c8e:	0000e717          	auipc	a4,0xe
    80001c92:	de270713          	add	a4,a4,-542 # 8000fa70 <pid_lock>
    80001c96:	9756                	add	a4,a4,s5
    80001c98:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001c9c:	0000e717          	auipc	a4,0xe
    80001ca0:	e0c70713          	add	a4,a4,-500 # 8000faa8 <cpus+0x8>
    80001ca4:	9aba                	add	s5,s5,a4
        p->state = RUNNING;
    80001ca6:	4b91                	li	s7,4
        c->proc = p;
    80001ca8:	079e                	sll	a5,a5,0x7
    80001caa:	0000ea17          	auipc	s4,0xe
    80001cae:	dc6a0a13          	add	s4,s4,-570 # 8000fa70 <pid_lock>
    80001cb2:	9a3e                	add	s4,s4,a5
        found = 1;
    80001cb4:	4b05                	li	s6,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cb6:	00014997          	auipc	s3,0x14
    80001cba:	fea98993          	add	s3,s3,-22 # 80015ca0 <tickslock>
    80001cbe:	a085                	j	80001d1e <scheduler+0xb0>
      release(&p->lock);
    80001cc0:	8526                	mv	a0,s1
    80001cc2:	f77fe0ef          	jal	80000c38 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cc6:	17848493          	add	s1,s1,376
    80001cca:	05348063          	beq	s1,s3,80001d0a <scheduler+0x9c>
      acquire(&p->lock);
    80001cce:	8526                	mv	a0,s1
    80001cd0:	ed1fe0ef          	jal	80000ba0 <acquire>
      if(p->state == RUNNABLE) {
    80001cd4:	4c9c                	lw	a5,24(s1)
    80001cd6:	ff2795e3          	bne	a5,s2,80001cc0 <scheduler+0x52>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001cda:	c0102c73          	rdtime	s8
        p->state = RUNNING;
    80001cde:	0174ac23          	sw	s7,24(s1)
        c->proc = p;
    80001ce2:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001ce6:	06048593          	add	a1,s1,96
    80001cea:	8556                	mv	a0,s5
    80001cec:	71c000ef          	jal	80002408 <swtch>
    80001cf0:	c0102773          	rdtime	a4
        p->tempo_total += tempo_final - tempo_inicio;
    80001cf4:	1684a783          	lw	a5,360(s1)
    80001cf8:	9fb9                	addw	a5,a5,a4
    80001cfa:	418787bb          	subw	a5,a5,s8
    80001cfe:	16f4a423          	sw	a5,360(s1)
        c->proc = 0;
    80001d02:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001d06:	8c5a                	mv	s8,s6
    80001d08:	bf65                	j	80001cc0 <scheduler+0x52>
    if(found == 0) {
    80001d0a:	000c1a63          	bnez	s8,80001d1e <scheduler+0xb0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d0e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d12:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d16:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001d1a:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d1e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d22:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d26:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001d2a:	4c01                	li	s8,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d2c:	0000e497          	auipc	s1,0xe
    80001d30:	17448493          	add	s1,s1,372 # 8000fea0 <proc>
      if(p->state == RUNNABLE) {
    80001d34:	490d                	li	s2,3
    80001d36:	bf61                	j	80001cce <scheduler+0x60>

0000000080001d38 <sched>:
{
    80001d38:	7179                	add	sp,sp,-48
    80001d3a:	f406                	sd	ra,40(sp)
    80001d3c:	f022                	sd	s0,32(sp)
    80001d3e:	ec26                	sd	s1,24(sp)
    80001d40:	e84a                	sd	s2,16(sp)
    80001d42:	e44e                	sd	s3,8(sp)
    80001d44:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001d46:	aebff0ef          	jal	80001830 <myproc>
    80001d4a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001d4c:	debfe0ef          	jal	80000b36 <holding>
    80001d50:	c92d                	beqz	a0,80001dc2 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d52:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001d54:	2781                	sext.w	a5,a5
    80001d56:	079e                	sll	a5,a5,0x7
    80001d58:	0000e717          	auipc	a4,0xe
    80001d5c:	d1870713          	add	a4,a4,-744 # 8000fa70 <pid_lock>
    80001d60:	97ba                	add	a5,a5,a4
    80001d62:	0a87a703          	lw	a4,168(a5)
    80001d66:	4785                	li	a5,1
    80001d68:	06f71363          	bne	a4,a5,80001dce <sched+0x96>
  if(p->state == RUNNING)
    80001d6c:	4c98                	lw	a4,24(s1)
    80001d6e:	4791                	li	a5,4
    80001d70:	06f70563          	beq	a4,a5,80001dda <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d74:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d78:	8b89                	and	a5,a5,2
  if(intr_get())
    80001d7a:	e7b5                	bnez	a5,80001de6 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d7c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001d7e:	0000e917          	auipc	s2,0xe
    80001d82:	cf290913          	add	s2,s2,-782 # 8000fa70 <pid_lock>
    80001d86:	2781                	sext.w	a5,a5
    80001d88:	079e                	sll	a5,a5,0x7
    80001d8a:	97ca                	add	a5,a5,s2
    80001d8c:	0ac7a983          	lw	s3,172(a5)
    80001d90:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001d92:	2781                	sext.w	a5,a5
    80001d94:	079e                	sll	a5,a5,0x7
    80001d96:	0000e597          	auipc	a1,0xe
    80001d9a:	d1258593          	add	a1,a1,-750 # 8000faa8 <cpus+0x8>
    80001d9e:	95be                	add	a1,a1,a5
    80001da0:	06048513          	add	a0,s1,96
    80001da4:	664000ef          	jal	80002408 <swtch>
    80001da8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001daa:	2781                	sext.w	a5,a5
    80001dac:	079e                	sll	a5,a5,0x7
    80001dae:	993e                	add	s2,s2,a5
    80001db0:	0b392623          	sw	s3,172(s2)
}
    80001db4:	70a2                	ld	ra,40(sp)
    80001db6:	7402                	ld	s0,32(sp)
    80001db8:	64e2                	ld	s1,24(sp)
    80001dba:	6942                	ld	s2,16(sp)
    80001dbc:	69a2                	ld	s3,8(sp)
    80001dbe:	6145                	add	sp,sp,48
    80001dc0:	8082                	ret
    panic("sched p->lock");
    80001dc2:	00005517          	auipc	a0,0x5
    80001dc6:	48e50513          	add	a0,a0,1166 # 80007250 <digits+0x218>
    80001dca:	995fe0ef          	jal	8000075e <panic>
    panic("sched locks");
    80001dce:	00005517          	auipc	a0,0x5
    80001dd2:	49250513          	add	a0,a0,1170 # 80007260 <digits+0x228>
    80001dd6:	989fe0ef          	jal	8000075e <panic>
    panic("sched running");
    80001dda:	00005517          	auipc	a0,0x5
    80001dde:	49650513          	add	a0,a0,1174 # 80007270 <digits+0x238>
    80001de2:	97dfe0ef          	jal	8000075e <panic>
    panic("sched interruptible");
    80001de6:	00005517          	auipc	a0,0x5
    80001dea:	49a50513          	add	a0,a0,1178 # 80007280 <digits+0x248>
    80001dee:	971fe0ef          	jal	8000075e <panic>

0000000080001df2 <yield>:
{
    80001df2:	1101                	add	sp,sp,-32
    80001df4:	ec06                	sd	ra,24(sp)
    80001df6:	e822                	sd	s0,16(sp)
    80001df8:	e426                	sd	s1,8(sp)
    80001dfa:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80001dfc:	a35ff0ef          	jal	80001830 <myproc>
    80001e00:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001e02:	d9ffe0ef          	jal	80000ba0 <acquire>
  p->state = RUNNABLE;
    80001e06:	478d                	li	a5,3
    80001e08:	cc9c                	sw	a5,24(s1)
  sched();
    80001e0a:	f2fff0ef          	jal	80001d38 <sched>
  release(&p->lock);
    80001e0e:	8526                	mv	a0,s1
    80001e10:	e29fe0ef          	jal	80000c38 <release>
}
    80001e14:	60e2                	ld	ra,24(sp)
    80001e16:	6442                	ld	s0,16(sp)
    80001e18:	64a2                	ld	s1,8(sp)
    80001e1a:	6105                	add	sp,sp,32
    80001e1c:	8082                	ret

0000000080001e1e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001e1e:	7179                	add	sp,sp,-48
    80001e20:	f406                	sd	ra,40(sp)
    80001e22:	f022                	sd	s0,32(sp)
    80001e24:	ec26                	sd	s1,24(sp)
    80001e26:	e84a                	sd	s2,16(sp)
    80001e28:	e44e                	sd	s3,8(sp)
    80001e2a:	1800                	add	s0,sp,48
    80001e2c:	89aa                	mv	s3,a0
    80001e2e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e30:	a01ff0ef          	jal	80001830 <myproc>
    80001e34:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001e36:	d6bfe0ef          	jal	80000ba0 <acquire>
  release(lk);
    80001e3a:	854a                	mv	a0,s2
    80001e3c:	dfdfe0ef          	jal	80000c38 <release>

  // Go to sleep.
  p->chan = chan;
    80001e40:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001e44:	4789                	li	a5,2
    80001e46:	cc9c                	sw	a5,24(s1)

  sched();
    80001e48:	ef1ff0ef          	jal	80001d38 <sched>

  // Tidy up.
  p->chan = 0;
    80001e4c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001e50:	8526                	mv	a0,s1
    80001e52:	de7fe0ef          	jal	80000c38 <release>
  acquire(lk);
    80001e56:	854a                	mv	a0,s2
    80001e58:	d49fe0ef          	jal	80000ba0 <acquire>
}
    80001e5c:	70a2                	ld	ra,40(sp)
    80001e5e:	7402                	ld	s0,32(sp)
    80001e60:	64e2                	ld	s1,24(sp)
    80001e62:	6942                	ld	s2,16(sp)
    80001e64:	69a2                	ld	s3,8(sp)
    80001e66:	6145                	add	sp,sp,48
    80001e68:	8082                	ret

0000000080001e6a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001e6a:	7139                	add	sp,sp,-64
    80001e6c:	fc06                	sd	ra,56(sp)
    80001e6e:	f822                	sd	s0,48(sp)
    80001e70:	f426                	sd	s1,40(sp)
    80001e72:	f04a                	sd	s2,32(sp)
    80001e74:	ec4e                	sd	s3,24(sp)
    80001e76:	e852                	sd	s4,16(sp)
    80001e78:	e456                	sd	s5,8(sp)
    80001e7a:	0080                	add	s0,sp,64
    80001e7c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001e7e:	0000e497          	auipc	s1,0xe
    80001e82:	02248493          	add	s1,s1,34 # 8000fea0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001e86:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001e88:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e8a:	00014917          	auipc	s2,0x14
    80001e8e:	e1690913          	add	s2,s2,-490 # 80015ca0 <tickslock>
    80001e92:	a801                	j	80001ea2 <wakeup+0x38>
      }
      release(&p->lock);
    80001e94:	8526                	mv	a0,s1
    80001e96:	da3fe0ef          	jal	80000c38 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e9a:	17848493          	add	s1,s1,376
    80001e9e:	03248263          	beq	s1,s2,80001ec2 <wakeup+0x58>
    if(p != myproc()){
    80001ea2:	98fff0ef          	jal	80001830 <myproc>
    80001ea6:	fea48ae3          	beq	s1,a0,80001e9a <wakeup+0x30>
      acquire(&p->lock);
    80001eaa:	8526                	mv	a0,s1
    80001eac:	cf5fe0ef          	jal	80000ba0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001eb0:	4c9c                	lw	a5,24(s1)
    80001eb2:	ff3791e3          	bne	a5,s3,80001e94 <wakeup+0x2a>
    80001eb6:	709c                	ld	a5,32(s1)
    80001eb8:	fd479ee3          	bne	a5,s4,80001e94 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001ebc:	0154ac23          	sw	s5,24(s1)
    80001ec0:	bfd1                	j	80001e94 <wakeup+0x2a>
    }
  }
}
    80001ec2:	70e2                	ld	ra,56(sp)
    80001ec4:	7442                	ld	s0,48(sp)
    80001ec6:	74a2                	ld	s1,40(sp)
    80001ec8:	7902                	ld	s2,32(sp)
    80001eca:	69e2                	ld	s3,24(sp)
    80001ecc:	6a42                	ld	s4,16(sp)
    80001ece:	6aa2                	ld	s5,8(sp)
    80001ed0:	6121                	add	sp,sp,64
    80001ed2:	8082                	ret

0000000080001ed4 <reparent>:
{
    80001ed4:	7179                	add	sp,sp,-48
    80001ed6:	f406                	sd	ra,40(sp)
    80001ed8:	f022                	sd	s0,32(sp)
    80001eda:	ec26                	sd	s1,24(sp)
    80001edc:	e84a                	sd	s2,16(sp)
    80001ede:	e44e                	sd	s3,8(sp)
    80001ee0:	e052                	sd	s4,0(sp)
    80001ee2:	1800                	add	s0,sp,48
    80001ee4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ee6:	0000e497          	auipc	s1,0xe
    80001eea:	fba48493          	add	s1,s1,-70 # 8000fea0 <proc>
      pp->parent = initproc;
    80001eee:	00006a17          	auipc	s4,0x6
    80001ef2:	a4aa0a13          	add	s4,s4,-1462 # 80007938 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ef6:	00014997          	auipc	s3,0x14
    80001efa:	daa98993          	add	s3,s3,-598 # 80015ca0 <tickslock>
    80001efe:	a029                	j	80001f08 <reparent+0x34>
    80001f00:	17848493          	add	s1,s1,376
    80001f04:	01348b63          	beq	s1,s3,80001f1a <reparent+0x46>
    if(pp->parent == p){
    80001f08:	7c9c                	ld	a5,56(s1)
    80001f0a:	ff279be3          	bne	a5,s2,80001f00 <reparent+0x2c>
      pp->parent = initproc;
    80001f0e:	000a3503          	ld	a0,0(s4)
    80001f12:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001f14:	f57ff0ef          	jal	80001e6a <wakeup>
    80001f18:	b7e5                	j	80001f00 <reparent+0x2c>
}
    80001f1a:	70a2                	ld	ra,40(sp)
    80001f1c:	7402                	ld	s0,32(sp)
    80001f1e:	64e2                	ld	s1,24(sp)
    80001f20:	6942                	ld	s2,16(sp)
    80001f22:	69a2                	ld	s3,8(sp)
    80001f24:	6a02                	ld	s4,0(sp)
    80001f26:	6145                	add	sp,sp,48
    80001f28:	8082                	ret

0000000080001f2a <exit>:
{
    80001f2a:	7179                	add	sp,sp,-48
    80001f2c:	f406                	sd	ra,40(sp)
    80001f2e:	f022                	sd	s0,32(sp)
    80001f30:	ec26                	sd	s1,24(sp)
    80001f32:	e84a                	sd	s2,16(sp)
    80001f34:	e44e                	sd	s3,8(sp)
    80001f36:	e052                	sd	s4,0(sp)
    80001f38:	1800                	add	s0,sp,48
    80001f3a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001f3c:	8f5ff0ef          	jal	80001830 <myproc>
    80001f40:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f42:	00006797          	auipc	a5,0x6
    80001f46:	9f67b783          	ld	a5,-1546(a5) # 80007938 <initproc>
    80001f4a:	0d050493          	add	s1,a0,208
    80001f4e:	15050913          	add	s2,a0,336
    80001f52:	00a79f63          	bne	a5,a0,80001f70 <exit+0x46>
    panic("init exiting");
    80001f56:	00005517          	auipc	a0,0x5
    80001f5a:	34250513          	add	a0,a0,834 # 80007298 <digits+0x260>
    80001f5e:	801fe0ef          	jal	8000075e <panic>
      fileclose(f);
    80001f62:	77b010ef          	jal	80003edc <fileclose>
      p->ofile[fd] = 0;
    80001f66:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001f6a:	04a1                	add	s1,s1,8
    80001f6c:	01248563          	beq	s1,s2,80001f76 <exit+0x4c>
    if(p->ofile[fd]){
    80001f70:	6088                	ld	a0,0(s1)
    80001f72:	f965                	bnez	a0,80001f62 <exit+0x38>
    80001f74:	bfdd                	j	80001f6a <exit+0x40>
  begin_op();
    80001f76:	353010ef          	jal	80003ac8 <begin_op>
  iput(p->cwd);
    80001f7a:	1509b503          	ld	a0,336(s3)
    80001f7e:	45a010ef          	jal	800033d8 <iput>
  end_op();
    80001f82:	3b1010ef          	jal	80003b32 <end_op>
  p->cwd = 0;
    80001f86:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001f8a:	0000e497          	auipc	s1,0xe
    80001f8e:	afe48493          	add	s1,s1,-1282 # 8000fa88 <wait_lock>
    80001f92:	8526                	mv	a0,s1
    80001f94:	c0dfe0ef          	jal	80000ba0 <acquire>
  reparent(p);
    80001f98:	854e                	mv	a0,s3
    80001f9a:	f3bff0ef          	jal	80001ed4 <reparent>
  wakeup(p->parent);
    80001f9e:	0389b503          	ld	a0,56(s3)
    80001fa2:	ec9ff0ef          	jal	80001e6a <wakeup>
  acquire(&p->lock);
    80001fa6:	854e                	mv	a0,s3
    80001fa8:	bf9fe0ef          	jal	80000ba0 <acquire>
  p->xstate = status;
    80001fac:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001fb0:	4795                	li	a5,5
    80001fb2:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001fb6:	8526                	mv	a0,s1
    80001fb8:	c81fe0ef          	jal	80000c38 <release>
  sched();
    80001fbc:	d7dff0ef          	jal	80001d38 <sched>
  panic("zombie exit");
    80001fc0:	00005517          	auipc	a0,0x5
    80001fc4:	2e850513          	add	a0,a0,744 # 800072a8 <digits+0x270>
    80001fc8:	f96fe0ef          	jal	8000075e <panic>

0000000080001fcc <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001fcc:	7179                	add	sp,sp,-48
    80001fce:	f406                	sd	ra,40(sp)
    80001fd0:	f022                	sd	s0,32(sp)
    80001fd2:	ec26                	sd	s1,24(sp)
    80001fd4:	e84a                	sd	s2,16(sp)
    80001fd6:	e44e                	sd	s3,8(sp)
    80001fd8:	1800                	add	s0,sp,48
    80001fda:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001fdc:	0000e497          	auipc	s1,0xe
    80001fe0:	ec448493          	add	s1,s1,-316 # 8000fea0 <proc>
    80001fe4:	00014997          	auipc	s3,0x14
    80001fe8:	cbc98993          	add	s3,s3,-836 # 80015ca0 <tickslock>
    acquire(&p->lock);
    80001fec:	8526                	mv	a0,s1
    80001fee:	bb3fe0ef          	jal	80000ba0 <acquire>
    if(p->pid == pid){
    80001ff2:	589c                	lw	a5,48(s1)
    80001ff4:	01278b63          	beq	a5,s2,8000200a <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001ff8:	8526                	mv	a0,s1
    80001ffa:	c3ffe0ef          	jal	80000c38 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ffe:	17848493          	add	s1,s1,376
    80002002:	ff3495e3          	bne	s1,s3,80001fec <kill+0x20>
  }
  return -1;
    80002006:	557d                	li	a0,-1
    80002008:	a819                	j	8000201e <kill+0x52>
      p->killed = 1;
    8000200a:	4785                	li	a5,1
    8000200c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000200e:	4c98                	lw	a4,24(s1)
    80002010:	4789                	li	a5,2
    80002012:	00f70d63          	beq	a4,a5,8000202c <kill+0x60>
      release(&p->lock);
    80002016:	8526                	mv	a0,s1
    80002018:	c21fe0ef          	jal	80000c38 <release>
      return 0;
    8000201c:	4501                	li	a0,0
}
    8000201e:	70a2                	ld	ra,40(sp)
    80002020:	7402                	ld	s0,32(sp)
    80002022:	64e2                	ld	s1,24(sp)
    80002024:	6942                	ld	s2,16(sp)
    80002026:	69a2                	ld	s3,8(sp)
    80002028:	6145                	add	sp,sp,48
    8000202a:	8082                	ret
        p->state = RUNNABLE;
    8000202c:	478d                	li	a5,3
    8000202e:	cc9c                	sw	a5,24(s1)
    80002030:	b7dd                	j	80002016 <kill+0x4a>

0000000080002032 <setkilled>:

void
setkilled(struct proc *p)
{
    80002032:	1101                	add	sp,sp,-32
    80002034:	ec06                	sd	ra,24(sp)
    80002036:	e822                	sd	s0,16(sp)
    80002038:	e426                	sd	s1,8(sp)
    8000203a:	1000                	add	s0,sp,32
    8000203c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000203e:	b63fe0ef          	jal	80000ba0 <acquire>
  p->killed = 1;
    80002042:	4785                	li	a5,1
    80002044:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002046:	8526                	mv	a0,s1
    80002048:	bf1fe0ef          	jal	80000c38 <release>
}
    8000204c:	60e2                	ld	ra,24(sp)
    8000204e:	6442                	ld	s0,16(sp)
    80002050:	64a2                	ld	s1,8(sp)
    80002052:	6105                	add	sp,sp,32
    80002054:	8082                	ret

0000000080002056 <killed>:

int
killed(struct proc *p)
{
    80002056:	1101                	add	sp,sp,-32
    80002058:	ec06                	sd	ra,24(sp)
    8000205a:	e822                	sd	s0,16(sp)
    8000205c:	e426                	sd	s1,8(sp)
    8000205e:	e04a                	sd	s2,0(sp)
    80002060:	1000                	add	s0,sp,32
    80002062:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002064:	b3dfe0ef          	jal	80000ba0 <acquire>
  k = p->killed;
    80002068:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000206c:	8526                	mv	a0,s1
    8000206e:	bcbfe0ef          	jal	80000c38 <release>
  return k;
}
    80002072:	854a                	mv	a0,s2
    80002074:	60e2                	ld	ra,24(sp)
    80002076:	6442                	ld	s0,16(sp)
    80002078:	64a2                	ld	s1,8(sp)
    8000207a:	6902                	ld	s2,0(sp)
    8000207c:	6105                	add	sp,sp,32
    8000207e:	8082                	ret

0000000080002080 <wait>:
{
    80002080:	715d                	add	sp,sp,-80
    80002082:	e486                	sd	ra,72(sp)
    80002084:	e0a2                	sd	s0,64(sp)
    80002086:	fc26                	sd	s1,56(sp)
    80002088:	f84a                	sd	s2,48(sp)
    8000208a:	f44e                	sd	s3,40(sp)
    8000208c:	f052                	sd	s4,32(sp)
    8000208e:	ec56                	sd	s5,24(sp)
    80002090:	e85a                	sd	s6,16(sp)
    80002092:	e45e                	sd	s7,8(sp)
    80002094:	e062                	sd	s8,0(sp)
    80002096:	0880                	add	s0,sp,80
    80002098:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000209a:	f96ff0ef          	jal	80001830 <myproc>
    8000209e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800020a0:	0000e517          	auipc	a0,0xe
    800020a4:	9e850513          	add	a0,a0,-1560 # 8000fa88 <wait_lock>
    800020a8:	af9fe0ef          	jal	80000ba0 <acquire>
    havekids = 0;
    800020ac:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800020ae:	4a15                	li	s4,5
        havekids = 1;
    800020b0:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800020b2:	00014997          	auipc	s3,0x14
    800020b6:	bee98993          	add	s3,s3,-1042 # 80015ca0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800020ba:	0000ec17          	auipc	s8,0xe
    800020be:	9cec0c13          	add	s8,s8,-1586 # 8000fa88 <wait_lock>
    800020c2:	a871                	j	8000215e <wait+0xde>
          pid = pp->pid;
    800020c4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800020c8:	000b0c63          	beqz	s6,800020e0 <wait+0x60>
    800020cc:	4691                	li	a3,4
    800020ce:	02c48613          	add	a2,s1,44
    800020d2:	85da                	mv	a1,s6
    800020d4:	05093503          	ld	a0,80(s2)
    800020d8:	c10ff0ef          	jal	800014e8 <copyout>
    800020dc:	02054b63          	bltz	a0,80002112 <wait+0x92>
          freeproc(pp);
    800020e0:	8526                	mv	a0,s1
    800020e2:	8c1ff0ef          	jal	800019a2 <freeproc>
          release(&pp->lock);
    800020e6:	8526                	mv	a0,s1
    800020e8:	b51fe0ef          	jal	80000c38 <release>
          release(&wait_lock);
    800020ec:	0000e517          	auipc	a0,0xe
    800020f0:	99c50513          	add	a0,a0,-1636 # 8000fa88 <wait_lock>
    800020f4:	b45fe0ef          	jal	80000c38 <release>
}
    800020f8:	854e                	mv	a0,s3
    800020fa:	60a6                	ld	ra,72(sp)
    800020fc:	6406                	ld	s0,64(sp)
    800020fe:	74e2                	ld	s1,56(sp)
    80002100:	7942                	ld	s2,48(sp)
    80002102:	79a2                	ld	s3,40(sp)
    80002104:	7a02                	ld	s4,32(sp)
    80002106:	6ae2                	ld	s5,24(sp)
    80002108:	6b42                	ld	s6,16(sp)
    8000210a:	6ba2                	ld	s7,8(sp)
    8000210c:	6c02                	ld	s8,0(sp)
    8000210e:	6161                	add	sp,sp,80
    80002110:	8082                	ret
            release(&pp->lock);
    80002112:	8526                	mv	a0,s1
    80002114:	b25fe0ef          	jal	80000c38 <release>
            release(&wait_lock);
    80002118:	0000e517          	auipc	a0,0xe
    8000211c:	97050513          	add	a0,a0,-1680 # 8000fa88 <wait_lock>
    80002120:	b19fe0ef          	jal	80000c38 <release>
            return -1;
    80002124:	59fd                	li	s3,-1
    80002126:	bfc9                	j	800020f8 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002128:	17848493          	add	s1,s1,376
    8000212c:	03348063          	beq	s1,s3,8000214c <wait+0xcc>
      if(pp->parent == p){
    80002130:	7c9c                	ld	a5,56(s1)
    80002132:	ff279be3          	bne	a5,s2,80002128 <wait+0xa8>
        acquire(&pp->lock);
    80002136:	8526                	mv	a0,s1
    80002138:	a69fe0ef          	jal	80000ba0 <acquire>
        if(pp->state == ZOMBIE){
    8000213c:	4c9c                	lw	a5,24(s1)
    8000213e:	f94783e3          	beq	a5,s4,800020c4 <wait+0x44>
        release(&pp->lock);
    80002142:	8526                	mv	a0,s1
    80002144:	af5fe0ef          	jal	80000c38 <release>
        havekids = 1;
    80002148:	8756                	mv	a4,s5
    8000214a:	bff9                	j	80002128 <wait+0xa8>
    if(!havekids || killed(p)){
    8000214c:	cf19                	beqz	a4,8000216a <wait+0xea>
    8000214e:	854a                	mv	a0,s2
    80002150:	f07ff0ef          	jal	80002056 <killed>
    80002154:	e919                	bnez	a0,8000216a <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002156:	85e2                	mv	a1,s8
    80002158:	854a                	mv	a0,s2
    8000215a:	cc5ff0ef          	jal	80001e1e <sleep>
    havekids = 0;
    8000215e:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002160:	0000e497          	auipc	s1,0xe
    80002164:	d4048493          	add	s1,s1,-704 # 8000fea0 <proc>
    80002168:	b7e1                	j	80002130 <wait+0xb0>
      release(&wait_lock);
    8000216a:	0000e517          	auipc	a0,0xe
    8000216e:	91e50513          	add	a0,a0,-1762 # 8000fa88 <wait_lock>
    80002172:	ac7fe0ef          	jal	80000c38 <release>
      return -1;
    80002176:	59fd                	li	s3,-1
    80002178:	b741                	j	800020f8 <wait+0x78>

000000008000217a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000217a:	7179                	add	sp,sp,-48
    8000217c:	f406                	sd	ra,40(sp)
    8000217e:	f022                	sd	s0,32(sp)
    80002180:	ec26                	sd	s1,24(sp)
    80002182:	e84a                	sd	s2,16(sp)
    80002184:	e44e                	sd	s3,8(sp)
    80002186:	e052                	sd	s4,0(sp)
    80002188:	1800                	add	s0,sp,48
    8000218a:	84aa                	mv	s1,a0
    8000218c:	892e                	mv	s2,a1
    8000218e:	89b2                	mv	s3,a2
    80002190:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002192:	e9eff0ef          	jal	80001830 <myproc>
  if(user_dst){
    80002196:	cc99                	beqz	s1,800021b4 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002198:	86d2                	mv	a3,s4
    8000219a:	864e                	mv	a2,s3
    8000219c:	85ca                	mv	a1,s2
    8000219e:	6928                	ld	a0,80(a0)
    800021a0:	b48ff0ef          	jal	800014e8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800021a4:	70a2                	ld	ra,40(sp)
    800021a6:	7402                	ld	s0,32(sp)
    800021a8:	64e2                	ld	s1,24(sp)
    800021aa:	6942                	ld	s2,16(sp)
    800021ac:	69a2                	ld	s3,8(sp)
    800021ae:	6a02                	ld	s4,0(sp)
    800021b0:	6145                	add	sp,sp,48
    800021b2:	8082                	ret
    memmove((char *)dst, src, len);
    800021b4:	000a061b          	sext.w	a2,s4
    800021b8:	85ce                	mv	a1,s3
    800021ba:	854a                	mv	a0,s2
    800021bc:	b15fe0ef          	jal	80000cd0 <memmove>
    return 0;
    800021c0:	8526                	mv	a0,s1
    800021c2:	b7cd                	j	800021a4 <either_copyout+0x2a>

00000000800021c4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800021c4:	7179                	add	sp,sp,-48
    800021c6:	f406                	sd	ra,40(sp)
    800021c8:	f022                	sd	s0,32(sp)
    800021ca:	ec26                	sd	s1,24(sp)
    800021cc:	e84a                	sd	s2,16(sp)
    800021ce:	e44e                	sd	s3,8(sp)
    800021d0:	e052                	sd	s4,0(sp)
    800021d2:	1800                	add	s0,sp,48
    800021d4:	892a                	mv	s2,a0
    800021d6:	84ae                	mv	s1,a1
    800021d8:	89b2                	mv	s3,a2
    800021da:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800021dc:	e54ff0ef          	jal	80001830 <myproc>
  if(user_src){
    800021e0:	cc99                	beqz	s1,800021fe <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800021e2:	86d2                	mv	a3,s4
    800021e4:	864e                	mv	a2,s3
    800021e6:	85ca                	mv	a1,s2
    800021e8:	6928                	ld	a0,80(a0)
    800021ea:	bb6ff0ef          	jal	800015a0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800021ee:	70a2                	ld	ra,40(sp)
    800021f0:	7402                	ld	s0,32(sp)
    800021f2:	64e2                	ld	s1,24(sp)
    800021f4:	6942                	ld	s2,16(sp)
    800021f6:	69a2                	ld	s3,8(sp)
    800021f8:	6a02                	ld	s4,0(sp)
    800021fa:	6145                	add	sp,sp,48
    800021fc:	8082                	ret
    memmove(dst, (char*)src, len);
    800021fe:	000a061b          	sext.w	a2,s4
    80002202:	85ce                	mv	a1,s3
    80002204:	854a                	mv	a0,s2
    80002206:	acbfe0ef          	jal	80000cd0 <memmove>
    return 0;
    8000220a:	8526                	mv	a0,s1
    8000220c:	b7cd                	j	800021ee <either_copyin+0x2a>

000000008000220e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000220e:	715d                	add	sp,sp,-80
    80002210:	e486                	sd	ra,72(sp)
    80002212:	e0a2                	sd	s0,64(sp)
    80002214:	fc26                	sd	s1,56(sp)
    80002216:	f84a                	sd	s2,48(sp)
    80002218:	f44e                	sd	s3,40(sp)
    8000221a:	f052                	sd	s4,32(sp)
    8000221c:	ec56                	sd	s5,24(sp)
    8000221e:	e85a                	sd	s6,16(sp)
    80002220:	e45e                	sd	s7,8(sp)
    80002222:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002224:	00005517          	auipc	a0,0x5
    80002228:	e9c50513          	add	a0,a0,-356 # 800070c0 <digits+0x88>
    8000222c:	a72fe0ef          	jal	8000049e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002230:	0000e497          	auipc	s1,0xe
    80002234:	dc848493          	add	s1,s1,-568 # 8000fff8 <proc+0x158>
    80002238:	00014917          	auipc	s2,0x14
    8000223c:	bc090913          	add	s2,s2,-1088 # 80015df8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002240:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002242:	00005997          	auipc	s3,0x5
    80002246:	07698993          	add	s3,s3,118 # 800072b8 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    8000224a:	00005a97          	auipc	s5,0x5
    8000224e:	076a8a93          	add	s5,s5,118 # 800072c0 <digits+0x288>
    printf("\n");
    80002252:	00005a17          	auipc	s4,0x5
    80002256:	e6ea0a13          	add	s4,s4,-402 # 800070c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000225a:	00005b97          	auipc	s7,0x5
    8000225e:	0a6b8b93          	add	s7,s7,166 # 80007300 <states.0>
    80002262:	a829                	j	8000227c <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002264:	ed86a583          	lw	a1,-296(a3)
    80002268:	8556                	mv	a0,s5
    8000226a:	a34fe0ef          	jal	8000049e <printf>
    printf("\n");
    8000226e:	8552                	mv	a0,s4
    80002270:	a2efe0ef          	jal	8000049e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002274:	17848493          	add	s1,s1,376
    80002278:	03248263          	beq	s1,s2,8000229c <procdump+0x8e>
    if(p->state == UNUSED)
    8000227c:	86a6                	mv	a3,s1
    8000227e:	ec04a783          	lw	a5,-320(s1)
    80002282:	dbed                	beqz	a5,80002274 <procdump+0x66>
      state = "???";
    80002284:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002286:	fcfb6fe3          	bltu	s6,a5,80002264 <procdump+0x56>
    8000228a:	02079713          	sll	a4,a5,0x20
    8000228e:	01d75793          	srl	a5,a4,0x1d
    80002292:	97de                	add	a5,a5,s7
    80002294:	6390                	ld	a2,0(a5)
    80002296:	f679                	bnez	a2,80002264 <procdump+0x56>
      state = "???";
    80002298:	864e                	mv	a2,s3
    8000229a:	b7e9                	j	80002264 <procdump+0x56>
  }
}
    8000229c:	60a6                	ld	ra,72(sp)
    8000229e:	6406                	ld	s0,64(sp)
    800022a0:	74e2                	ld	s1,56(sp)
    800022a2:	7942                	ld	s2,48(sp)
    800022a4:	79a2                	ld	s3,40(sp)
    800022a6:	7a02                	ld	s4,32(sp)
    800022a8:	6ae2                	ld	s5,24(sp)
    800022aa:	6b42                	ld	s6,16(sp)
    800022ac:	6ba2                	ld	s7,8(sp)
    800022ae:	6161                	add	sp,sp,80
    800022b0:	8082                	ret

00000000800022b2 <sys_tempo_total>:


int sys_tempo_total(void){
    800022b2:	1101                	add	sp,sp,-32
    800022b4:	ec06                	sd	ra,24(sp)
    800022b6:	e822                	sd	s0,16(sp)
    800022b8:	1000                	add	s0,sp,32
  int pid;
  struct proc *p;

  argint(0, &pid);  //Chama a função, que modifica o valor de pid
    800022ba:	fec40593          	add	a1,s0,-20
    800022be:	4501                	li	a0,0
    800022c0:	596000ef          	jal	80002856 <argint>
  if (pid < 0) {
    800022c4:	fec42683          	lw	a3,-20(s0)
    800022c8:	0206c963          	bltz	a3,800022fa <sys_tempo_total+0x48>
      // Tratar erro, já que o pid não pode ser negativo
      return -1;
  }
  //Busca o processo com o PID fornecido
  for(p = proc; p < &proc[NPROC]; p++) {
    800022cc:	0000e797          	auipc	a5,0xe
    800022d0:	bd478793          	add	a5,a5,-1068 # 8000fea0 <proc>
    800022d4:	00014617          	auipc	a2,0x14
    800022d8:	9cc60613          	add	a2,a2,-1588 # 80015ca0 <tickslock>
      if(p->pid == pid) {
    800022dc:	5b98                	lw	a4,48(a5)
    800022de:	00d70863          	beq	a4,a3,800022ee <sys_tempo_total+0x3c>
  for(p = proc; p < &proc[NPROC]; p++) {
    800022e2:	17878793          	add	a5,a5,376
    800022e6:	fec79be3          	bne	a5,a2,800022dc <sys_tempo_total+0x2a>
          return p->tempo_total;
      }
  }

  return -1;  //Se o processo não for encontrado
    800022ea:	557d                	li	a0,-1
    800022ec:	a019                	j	800022f2 <sys_tempo_total+0x40>
          return p->tempo_total;
    800022ee:	1687a503          	lw	a0,360(a5)
}
    800022f2:	60e2                	ld	ra,24(sp)
    800022f4:	6442                	ld	s0,16(sp)
    800022f6:	6105                	add	sp,sp,32
    800022f8:	8082                	ret
      return -1;
    800022fa:	557d                	li	a0,-1
    800022fc:	bfdd                	j	800022f2 <sys_tempo_total+0x40>

00000000800022fe <sys_get_overhead>:


int sys_get_overhead(void){
    800022fe:	1101                	add	sp,sp,-32
    80002300:	ec06                	sd	ra,24(sp)
    80002302:	e822                	sd	s0,16(sp)
    80002304:	1000                	add	s0,sp,32
  int pid;
  struct proc *p;

  argint(0, &pid);
    80002306:	fec40593          	add	a1,s0,-20
    8000230a:	4501                	li	a0,0
    8000230c:	54a000ef          	jal	80002856 <argint>
  for(p = proc; p < &proc[NPROC]; p++) {
    if(p->pid == pid) {
    80002310:	fec42683          	lw	a3,-20(s0)
  for(p = proc; p < &proc[NPROC]; p++) {
    80002314:	0000e797          	auipc	a5,0xe
    80002318:	b8c78793          	add	a5,a5,-1140 # 8000fea0 <proc>
    8000231c:	00014617          	auipc	a2,0x14
    80002320:	98460613          	add	a2,a2,-1660 # 80015ca0 <tickslock>
    if(p->pid == pid) {
    80002324:	5b98                	lw	a4,48(a5)
    80002326:	00d70863          	beq	a4,a3,80002336 <sys_get_overhead+0x38>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000232a:	17878793          	add	a5,a5,376
    8000232e:	fec79be3          	bne	a5,a2,80002324 <sys_get_overhead+0x26>
        return p->overhead;
    }
  }

  return -1;
    80002332:	557d                	li	a0,-1
    80002334:	a019                	j	8000233a <sys_get_overhead+0x3c>
        return p->overhead;
    80002336:	16c7a503          	lw	a0,364(a5)

}
    8000233a:	60e2                	ld	ra,24(sp)
    8000233c:	6442                	ld	s0,16(sp)
    8000233e:	6105                	add	sp,sp,32
    80002340:	8082                	ret

0000000080002342 <sys_get_eficiencia>:


int sys_get_eficiencia(void){
    80002342:	1101                	add	sp,sp,-32
    80002344:	ec06                	sd	ra,24(sp)
    80002346:	e822                	sd	s0,16(sp)
    80002348:	1000                	add	s0,sp,32
  int pid;
  struct proc *p;

  argint(0, &pid);
    8000234a:	fec40593          	add	a1,s0,-20
    8000234e:	4501                	li	a0,0
    80002350:	506000ef          	jal	80002856 <argint>
  for(p = proc; p < &proc[NPROC]; p++) {
    if(p->pid == pid) {
    80002354:	fec42683          	lw	a3,-20(s0)
  for(p = proc; p < &proc[NPROC]; p++) {
    80002358:	0000e797          	auipc	a5,0xe
    8000235c:	b4878793          	add	a5,a5,-1208 # 8000fea0 <proc>
    80002360:	00014617          	auipc	a2,0x14
    80002364:	94060613          	add	a2,a2,-1728 # 80015ca0 <tickslock>
    if(p->pid == pid) {
    80002368:	5b98                	lw	a4,48(a5)
    8000236a:	00d70863          	beq	a4,a3,8000237a <sys_get_eficiencia+0x38>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000236e:	17878793          	add	a5,a5,376
    80002372:	fec79be3          	bne	a5,a2,80002368 <sys_get_eficiencia+0x26>
        return p->eficiencia;
    }
  }

  return -1;
    80002376:	557d                	li	a0,-1
    80002378:	a019                	j	8000237e <sys_get_eficiencia+0x3c>
        return p->eficiencia;
    8000237a:	1707a503          	lw	a0,368(a5)

}
    8000237e:	60e2                	ld	ra,24(sp)
    80002380:	6442                	ld	s0,16(sp)
    80002382:	6105                	add	sp,sp,32
    80002384:	8082                	ret

0000000080002386 <sys_increment_metric>:

int sys_increment_metric(void){
    80002386:	1101                	add	sp,sp,-32
    80002388:	ec06                	sd	ra,24(sp)
    8000238a:	e822                	sd	s0,16(sp)
    8000238c:	1000                	add	s0,sp,32
  int pid, amount, mode;
  struct proc *p;

  argint(0, &pid);
    8000238e:	fec40593          	add	a1,s0,-20
    80002392:	4501                	li	a0,0
    80002394:	4c2000ef          	jal	80002856 <argint>
  argint(1, &amount);
    80002398:	fe840593          	add	a1,s0,-24
    8000239c:	4505                	li	a0,1
    8000239e:	4b8000ef          	jal	80002856 <argint>
  argint(2, &mode);
    800023a2:	fe440593          	add	a1,s0,-28
    800023a6:	4509                	li	a0,2
    800023a8:	4ae000ef          	jal	80002856 <argint>

  for(p = proc; p < &proc[NPROC]; p++) {
    if(p->pid == pid) {
    800023ac:	fec42603          	lw	a2,-20(s0)
        if(mode == MODE_OVERHEAD){
    800023b0:	fe442583          	lw	a1,-28(s0)
          p->overhead += amount;
        } else if(mode == MODE_EFICIENCIA) {
          p->eficiencia += amount;
    800023b4:	fe842883          	lw	a7,-24(s0)
  for(p = proc; p < &proc[NPROC]; p++) {
    800023b8:	0000e797          	auipc	a5,0xe
    800023bc:	ae878793          	add	a5,a5,-1304 # 8000fea0 <proc>
        if(mode == MODE_OVERHEAD){
    800023c0:	4521                	li	a0,8
        } else if(mode == MODE_EFICIENCIA) {
    800023c2:	4829                	li	a6,10
  for(p = proc; p < &proc[NPROC]; p++) {
    800023c4:	00014697          	auipc	a3,0x14
    800023c8:	8dc68693          	add	a3,a3,-1828 # 80015ca0 <tickslock>
    800023cc:	a819                	j	800023e2 <sys_increment_metric+0x5c>
          p->overhead += amount;
    800023ce:	16c7a703          	lw	a4,364(a5)
    800023d2:	0117073b          	addw	a4,a4,a7
    800023d6:	16e7a623          	sw	a4,364(a5)
  for(p = proc; p < &proc[NPROC]; p++) {
    800023da:	17878793          	add	a5,a5,376
    800023de:	02d78063          	beq	a5,a3,800023fe <sys_increment_metric+0x78>
    if(p->pid == pid) {
    800023e2:	5b98                	lw	a4,48(a5)
    800023e4:	fec71be3          	bne	a4,a2,800023da <sys_increment_metric+0x54>
        if(mode == MODE_OVERHEAD){
    800023e8:	fea583e3          	beq	a1,a0,800023ce <sys_increment_metric+0x48>
        } else if(mode == MODE_EFICIENCIA) {
    800023ec:	ff0597e3          	bne	a1,a6,800023da <sys_increment_metric+0x54>
          p->eficiencia += amount;
    800023f0:	1707a703          	lw	a4,368(a5)
    800023f4:	0117073b          	addw	a4,a4,a7
    800023f8:	16e7a823          	sw	a4,368(a5)
    800023fc:	bff9                	j	800023da <sys_increment_metric+0x54>
    }
  }

  return -1;

    800023fe:	557d                	li	a0,-1
    80002400:	60e2                	ld	ra,24(sp)
    80002402:	6442                	ld	s0,16(sp)
    80002404:	6105                	add	sp,sp,32
    80002406:	8082                	ret

0000000080002408 <swtch>:
    80002408:	00153023          	sd	ra,0(a0)
    8000240c:	00253423          	sd	sp,8(a0)
    80002410:	e900                	sd	s0,16(a0)
    80002412:	ed04                	sd	s1,24(a0)
    80002414:	03253023          	sd	s2,32(a0)
    80002418:	03353423          	sd	s3,40(a0)
    8000241c:	03453823          	sd	s4,48(a0)
    80002420:	03553c23          	sd	s5,56(a0)
    80002424:	05653023          	sd	s6,64(a0)
    80002428:	05753423          	sd	s7,72(a0)
    8000242c:	05853823          	sd	s8,80(a0)
    80002430:	05953c23          	sd	s9,88(a0)
    80002434:	07a53023          	sd	s10,96(a0)
    80002438:	07b53423          	sd	s11,104(a0)
    8000243c:	0005b083          	ld	ra,0(a1)
    80002440:	0085b103          	ld	sp,8(a1)
    80002444:	6980                	ld	s0,16(a1)
    80002446:	6d84                	ld	s1,24(a1)
    80002448:	0205b903          	ld	s2,32(a1)
    8000244c:	0285b983          	ld	s3,40(a1)
    80002450:	0305ba03          	ld	s4,48(a1)
    80002454:	0385ba83          	ld	s5,56(a1)
    80002458:	0405bb03          	ld	s6,64(a1)
    8000245c:	0485bb83          	ld	s7,72(a1)
    80002460:	0505bc03          	ld	s8,80(a1)
    80002464:	0585bc83          	ld	s9,88(a1)
    80002468:	0605bd03          	ld	s10,96(a1)
    8000246c:	0685bd83          	ld	s11,104(a1)
    80002470:	8082                	ret

0000000080002472 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002472:	1141                	add	sp,sp,-16
    80002474:	e406                	sd	ra,8(sp)
    80002476:	e022                	sd	s0,0(sp)
    80002478:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    8000247a:	00005597          	auipc	a1,0x5
    8000247e:	eb658593          	add	a1,a1,-330 # 80007330 <states.0+0x30>
    80002482:	00014517          	auipc	a0,0x14
    80002486:	81e50513          	add	a0,a0,-2018 # 80015ca0 <tickslock>
    8000248a:	e96fe0ef          	jal	80000b20 <initlock>
}
    8000248e:	60a2                	ld	ra,8(sp)
    80002490:	6402                	ld	s0,0(sp)
    80002492:	0141                	add	sp,sp,16
    80002494:	8082                	ret

0000000080002496 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002496:	1141                	add	sp,sp,-16
    80002498:	e422                	sd	s0,8(sp)
    8000249a:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000249c:	00003797          	auipc	a5,0x3
    800024a0:	cd478793          	add	a5,a5,-812 # 80005170 <kernelvec>
    800024a4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800024a8:	6422                	ld	s0,8(sp)
    800024aa:	0141                	add	sp,sp,16
    800024ac:	8082                	ret

00000000800024ae <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800024ae:	1141                	add	sp,sp,-16
    800024b0:	e406                	sd	ra,8(sp)
    800024b2:	e022                	sd	s0,0(sp)
    800024b4:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    800024b6:	b7aff0ef          	jal	80001830 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024ba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800024be:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024c0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800024c4:	00004697          	auipc	a3,0x4
    800024c8:	b3c68693          	add	a3,a3,-1220 # 80006000 <_trampoline>
    800024cc:	00004717          	auipc	a4,0x4
    800024d0:	b3470713          	add	a4,a4,-1228 # 80006000 <_trampoline>
    800024d4:	8f15                	sub	a4,a4,a3
    800024d6:	040007b7          	lui	a5,0x4000
    800024da:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800024dc:	07b2                	sll	a5,a5,0xc
    800024de:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024e0:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800024e4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800024e6:	18002673          	csrr	a2,satp
    800024ea:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800024ec:	6d30                	ld	a2,88(a0)
    800024ee:	6138                	ld	a4,64(a0)
    800024f0:	6585                	lui	a1,0x1
    800024f2:	972e                	add	a4,a4,a1
    800024f4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800024f6:	6d38                	ld	a4,88(a0)
    800024f8:	00000617          	auipc	a2,0x0
    800024fc:	10c60613          	add	a2,a2,268 # 80002604 <usertrap>
    80002500:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002502:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002504:	8612                	mv	a2,tp
    80002506:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002508:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000250c:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002510:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002514:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002518:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000251a:	6f18                	ld	a4,24(a4)
    8000251c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002520:	6928                	ld	a0,80(a0)
    80002522:	8131                	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002524:	00004717          	auipc	a4,0x4
    80002528:	b7870713          	add	a4,a4,-1160 # 8000609c <userret>
    8000252c:	8f15                	sub	a4,a4,a3
    8000252e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002530:	577d                	li	a4,-1
    80002532:	177e                	sll	a4,a4,0x3f
    80002534:	8d59                	or	a0,a0,a4
    80002536:	9782                	jalr	a5
}
    80002538:	60a2                	ld	ra,8(sp)
    8000253a:	6402                	ld	s0,0(sp)
    8000253c:	0141                	add	sp,sp,16
    8000253e:	8082                	ret

0000000080002540 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002540:	1101                	add	sp,sp,-32
    80002542:	ec06                	sd	ra,24(sp)
    80002544:	e822                	sd	s0,16(sp)
    80002546:	e426                	sd	s1,8(sp)
    80002548:	1000                	add	s0,sp,32
  if(cpuid() == 0){
    8000254a:	abaff0ef          	jal	80001804 <cpuid>
    8000254e:	cd19                	beqz	a0,8000256c <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002550:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002554:	000f4737          	lui	a4,0xf4
    80002558:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000255c:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000255e:	14d79073          	csrw	stimecmp,a5
}
    80002562:	60e2                	ld	ra,24(sp)
    80002564:	6442                	ld	s0,16(sp)
    80002566:	64a2                	ld	s1,8(sp)
    80002568:	6105                	add	sp,sp,32
    8000256a:	8082                	ret
    acquire(&tickslock);
    8000256c:	00013497          	auipc	s1,0x13
    80002570:	73448493          	add	s1,s1,1844 # 80015ca0 <tickslock>
    80002574:	8526                	mv	a0,s1
    80002576:	e2afe0ef          	jal	80000ba0 <acquire>
    ticks++;
    8000257a:	00005517          	auipc	a0,0x5
    8000257e:	3c650513          	add	a0,a0,966 # 80007940 <ticks>
    80002582:	411c                	lw	a5,0(a0)
    80002584:	2785                	addw	a5,a5,1
    80002586:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002588:	8e3ff0ef          	jal	80001e6a <wakeup>
    release(&tickslock);
    8000258c:	8526                	mv	a0,s1
    8000258e:	eaafe0ef          	jal	80000c38 <release>
    80002592:	bf7d                	j	80002550 <clockintr+0x10>

0000000080002594 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002594:	1101                	add	sp,sp,-32
    80002596:	ec06                	sd	ra,24(sp)
    80002598:	e822                	sd	s0,16(sp)
    8000259a:	e426                	sd	s1,8(sp)
    8000259c:	1000                	add	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000259e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800025a2:	57fd                	li	a5,-1
    800025a4:	17fe                	sll	a5,a5,0x3f
    800025a6:	07a5                	add	a5,a5,9
    800025a8:	00f70d63          	beq	a4,a5,800025c2 <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800025ac:	57fd                	li	a5,-1
    800025ae:	17fe                	sll	a5,a5,0x3f
    800025b0:	0795                	add	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800025b2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800025b4:	04f70463          	beq	a4,a5,800025fc <devintr+0x68>
  }
}
    800025b8:	60e2                	ld	ra,24(sp)
    800025ba:	6442                	ld	s0,16(sp)
    800025bc:	64a2                	ld	s1,8(sp)
    800025be:	6105                	add	sp,sp,32
    800025c0:	8082                	ret
    int irq = plic_claim();
    800025c2:	457020ef          	jal	80005218 <plic_claim>
    800025c6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800025c8:	47a9                	li	a5,10
    800025ca:	02f50363          	beq	a0,a5,800025f0 <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    800025ce:	4785                	li	a5,1
    800025d0:	02f50363          	beq	a0,a5,800025f6 <devintr+0x62>
    return 1;
    800025d4:	4505                	li	a0,1
    } else if(irq){
    800025d6:	d0ed                	beqz	s1,800025b8 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    800025d8:	85a6                	mv	a1,s1
    800025da:	00005517          	auipc	a0,0x5
    800025de:	d5e50513          	add	a0,a0,-674 # 80007338 <states.0+0x38>
    800025e2:	ebdfd0ef          	jal	8000049e <printf>
      plic_complete(irq);
    800025e6:	8526                	mv	a0,s1
    800025e8:	451020ef          	jal	80005238 <plic_complete>
    return 1;
    800025ec:	4505                	li	a0,1
    800025ee:	b7e9                	j	800025b8 <devintr+0x24>
      uartintr();
    800025f0:	bc2fe0ef          	jal	800009b2 <uartintr>
    if(irq)
    800025f4:	bfcd                	j	800025e6 <devintr+0x52>
      virtio_disk_intr();
    800025f6:	0ac030ef          	jal	800056a2 <virtio_disk_intr>
    if(irq)
    800025fa:	b7f5                	j	800025e6 <devintr+0x52>
    clockintr();
    800025fc:	f45ff0ef          	jal	80002540 <clockintr>
    return 2;
    80002600:	4509                	li	a0,2
    80002602:	bf5d                	j	800025b8 <devintr+0x24>

0000000080002604 <usertrap>:
{
    80002604:	1101                	add	sp,sp,-32
    80002606:	ec06                	sd	ra,24(sp)
    80002608:	e822                	sd	s0,16(sp)
    8000260a:	e426                	sd	s1,8(sp)
    8000260c:	e04a                	sd	s2,0(sp)
    8000260e:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002610:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002614:	1007f793          	and	a5,a5,256
    80002618:	ef85                	bnez	a5,80002650 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000261a:	00003797          	auipc	a5,0x3
    8000261e:	b5678793          	add	a5,a5,-1194 # 80005170 <kernelvec>
    80002622:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002626:	a0aff0ef          	jal	80001830 <myproc>
    8000262a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000262c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000262e:	14102773          	csrr	a4,sepc
    80002632:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002634:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002638:	47a1                	li	a5,8
    8000263a:	02f70163          	beq	a4,a5,8000265c <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    8000263e:	f57ff0ef          	jal	80002594 <devintr>
    80002642:	892a                	mv	s2,a0
    80002644:	c135                	beqz	a0,800026a8 <usertrap+0xa4>
  if(killed(p))
    80002646:	8526                	mv	a0,s1
    80002648:	a0fff0ef          	jal	80002056 <killed>
    8000264c:	cd1d                	beqz	a0,8000268a <usertrap+0x86>
    8000264e:	a81d                	j	80002684 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80002650:	00005517          	auipc	a0,0x5
    80002654:	d0850513          	add	a0,a0,-760 # 80007358 <states.0+0x58>
    80002658:	906fe0ef          	jal	8000075e <panic>
    if(killed(p))
    8000265c:	9fbff0ef          	jal	80002056 <killed>
    80002660:	e121                	bnez	a0,800026a0 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80002662:	6cb8                	ld	a4,88(s1)
    80002664:	6f1c                	ld	a5,24(a4)
    80002666:	0791                	add	a5,a5,4
    80002668:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000266a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000266e:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002672:	10079073          	csrw	sstatus,a5
    syscall();
    80002676:	248000ef          	jal	800028be <syscall>
  if(killed(p))
    8000267a:	8526                	mv	a0,s1
    8000267c:	9dbff0ef          	jal	80002056 <killed>
    80002680:	c901                	beqz	a0,80002690 <usertrap+0x8c>
    80002682:	4901                	li	s2,0
    exit(-1);
    80002684:	557d                	li	a0,-1
    80002686:	8a5ff0ef          	jal	80001f2a <exit>
  if(which_dev == 2)
    8000268a:	4789                	li	a5,2
    8000268c:	04f90563          	beq	s2,a5,800026d6 <usertrap+0xd2>
  usertrapret();
    80002690:	e1fff0ef          	jal	800024ae <usertrapret>
}
    80002694:	60e2                	ld	ra,24(sp)
    80002696:	6442                	ld	s0,16(sp)
    80002698:	64a2                	ld	s1,8(sp)
    8000269a:	6902                	ld	s2,0(sp)
    8000269c:	6105                	add	sp,sp,32
    8000269e:	8082                	ret
      exit(-1);
    800026a0:	557d                	li	a0,-1
    800026a2:	889ff0ef          	jal	80001f2a <exit>
    800026a6:	bf75                	j	80002662 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026a8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800026ac:	5890                	lw	a2,48(s1)
    800026ae:	00005517          	auipc	a0,0x5
    800026b2:	cca50513          	add	a0,a0,-822 # 80007378 <states.0+0x78>
    800026b6:	de9fd0ef          	jal	8000049e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026ba:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800026be:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800026c2:	00005517          	auipc	a0,0x5
    800026c6:	ce650513          	add	a0,a0,-794 # 800073a8 <states.0+0xa8>
    800026ca:	dd5fd0ef          	jal	8000049e <printf>
    setkilled(p);
    800026ce:	8526                	mv	a0,s1
    800026d0:	963ff0ef          	jal	80002032 <setkilled>
    800026d4:	b75d                	j	8000267a <usertrap+0x76>
    yield();
    800026d6:	f1cff0ef          	jal	80001df2 <yield>
    800026da:	bf5d                	j	80002690 <usertrap+0x8c>

00000000800026dc <kerneltrap>:
{
    800026dc:	7179                	add	sp,sp,-48
    800026de:	f406                	sd	ra,40(sp)
    800026e0:	f022                	sd	s0,32(sp)
    800026e2:	ec26                	sd	s1,24(sp)
    800026e4:	e84a                	sd	s2,16(sp)
    800026e6:	e44e                	sd	s3,8(sp)
    800026e8:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026ea:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026ee:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026f2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800026f6:	1004f793          	and	a5,s1,256
    800026fa:	c795                	beqz	a5,80002726 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026fc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002700:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80002702:	eb85                	bnez	a5,80002732 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002704:	e91ff0ef          	jal	80002594 <devintr>
    80002708:	c91d                	beqz	a0,8000273e <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    8000270a:	4789                	li	a5,2
    8000270c:	04f50a63          	beq	a0,a5,80002760 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002710:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002714:	10049073          	csrw	sstatus,s1
}
    80002718:	70a2                	ld	ra,40(sp)
    8000271a:	7402                	ld	s0,32(sp)
    8000271c:	64e2                	ld	s1,24(sp)
    8000271e:	6942                	ld	s2,16(sp)
    80002720:	69a2                	ld	s3,8(sp)
    80002722:	6145                	add	sp,sp,48
    80002724:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002726:	00005517          	auipc	a0,0x5
    8000272a:	caa50513          	add	a0,a0,-854 # 800073d0 <states.0+0xd0>
    8000272e:	830fe0ef          	jal	8000075e <panic>
    panic("kerneltrap: interrupts enabled");
    80002732:	00005517          	auipc	a0,0x5
    80002736:	cc650513          	add	a0,a0,-826 # 800073f8 <states.0+0xf8>
    8000273a:	824fe0ef          	jal	8000075e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000273e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002742:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002746:	85ce                	mv	a1,s3
    80002748:	00005517          	auipc	a0,0x5
    8000274c:	cd050513          	add	a0,a0,-816 # 80007418 <states.0+0x118>
    80002750:	d4ffd0ef          	jal	8000049e <printf>
    panic("kerneltrap");
    80002754:	00005517          	auipc	a0,0x5
    80002758:	cec50513          	add	a0,a0,-788 # 80007440 <states.0+0x140>
    8000275c:	802fe0ef          	jal	8000075e <panic>
  if(which_dev == 2 && myproc() != 0)
    80002760:	8d0ff0ef          	jal	80001830 <myproc>
    80002764:	d555                	beqz	a0,80002710 <kerneltrap+0x34>
    yield();
    80002766:	e8cff0ef          	jal	80001df2 <yield>
    8000276a:	b75d                	j	80002710 <kerneltrap+0x34>

000000008000276c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000276c:	1101                	add	sp,sp,-32
    8000276e:	ec06                	sd	ra,24(sp)
    80002770:	e822                	sd	s0,16(sp)
    80002772:	e426                	sd	s1,8(sp)
    80002774:	1000                	add	s0,sp,32
    80002776:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002778:	8b8ff0ef          	jal	80001830 <myproc>
  switch (n) {
    8000277c:	4795                	li	a5,5
    8000277e:	0497e163          	bltu	a5,s1,800027c0 <argraw+0x54>
    80002782:	048a                	sll	s1,s1,0x2
    80002784:	00005717          	auipc	a4,0x5
    80002788:	cf470713          	add	a4,a4,-780 # 80007478 <states.0+0x178>
    8000278c:	94ba                	add	s1,s1,a4
    8000278e:	409c                	lw	a5,0(s1)
    80002790:	97ba                	add	a5,a5,a4
    80002792:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002794:	6d3c                	ld	a5,88(a0)
    80002796:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002798:	60e2                	ld	ra,24(sp)
    8000279a:	6442                	ld	s0,16(sp)
    8000279c:	64a2                	ld	s1,8(sp)
    8000279e:	6105                	add	sp,sp,32
    800027a0:	8082                	ret
    return p->trapframe->a1;
    800027a2:	6d3c                	ld	a5,88(a0)
    800027a4:	7fa8                	ld	a0,120(a5)
    800027a6:	bfcd                	j	80002798 <argraw+0x2c>
    return p->trapframe->a2;
    800027a8:	6d3c                	ld	a5,88(a0)
    800027aa:	63c8                	ld	a0,128(a5)
    800027ac:	b7f5                	j	80002798 <argraw+0x2c>
    return p->trapframe->a3;
    800027ae:	6d3c                	ld	a5,88(a0)
    800027b0:	67c8                	ld	a0,136(a5)
    800027b2:	b7dd                	j	80002798 <argraw+0x2c>
    return p->trapframe->a4;
    800027b4:	6d3c                	ld	a5,88(a0)
    800027b6:	6bc8                	ld	a0,144(a5)
    800027b8:	b7c5                	j	80002798 <argraw+0x2c>
    return p->trapframe->a5;
    800027ba:	6d3c                	ld	a5,88(a0)
    800027bc:	6fc8                	ld	a0,152(a5)
    800027be:	bfe9                	j	80002798 <argraw+0x2c>
  panic("argraw");
    800027c0:	00005517          	auipc	a0,0x5
    800027c4:	c9050513          	add	a0,a0,-880 # 80007450 <states.0+0x150>
    800027c8:	f97fd0ef          	jal	8000075e <panic>

00000000800027cc <fetchaddr>:
{
    800027cc:	1101                	add	sp,sp,-32
    800027ce:	ec06                	sd	ra,24(sp)
    800027d0:	e822                	sd	s0,16(sp)
    800027d2:	e426                	sd	s1,8(sp)
    800027d4:	e04a                	sd	s2,0(sp)
    800027d6:	1000                	add	s0,sp,32
    800027d8:	84aa                	mv	s1,a0
    800027da:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027dc:	854ff0ef          	jal	80001830 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800027e0:	653c                	ld	a5,72(a0)
    800027e2:	02f4f663          	bgeu	s1,a5,8000280e <fetchaddr+0x42>
    800027e6:	00848713          	add	a4,s1,8
    800027ea:	02e7e463          	bltu	a5,a4,80002812 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800027ee:	46a1                	li	a3,8
    800027f0:	8626                	mv	a2,s1
    800027f2:	85ca                	mv	a1,s2
    800027f4:	6928                	ld	a0,80(a0)
    800027f6:	dabfe0ef          	jal	800015a0 <copyin>
    800027fa:	00a03533          	snez	a0,a0
    800027fe:	40a00533          	neg	a0,a0
}
    80002802:	60e2                	ld	ra,24(sp)
    80002804:	6442                	ld	s0,16(sp)
    80002806:	64a2                	ld	s1,8(sp)
    80002808:	6902                	ld	s2,0(sp)
    8000280a:	6105                	add	sp,sp,32
    8000280c:	8082                	ret
    return -1;
    8000280e:	557d                	li	a0,-1
    80002810:	bfcd                	j	80002802 <fetchaddr+0x36>
    80002812:	557d                	li	a0,-1
    80002814:	b7fd                	j	80002802 <fetchaddr+0x36>

0000000080002816 <fetchstr>:
{
    80002816:	7179                	add	sp,sp,-48
    80002818:	f406                	sd	ra,40(sp)
    8000281a:	f022                	sd	s0,32(sp)
    8000281c:	ec26                	sd	s1,24(sp)
    8000281e:	e84a                	sd	s2,16(sp)
    80002820:	e44e                	sd	s3,8(sp)
    80002822:	1800                	add	s0,sp,48
    80002824:	892a                	mv	s2,a0
    80002826:	84ae                	mv	s1,a1
    80002828:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000282a:	806ff0ef          	jal	80001830 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000282e:	86ce                	mv	a3,s3
    80002830:	864a                	mv	a2,s2
    80002832:	85a6                	mv	a1,s1
    80002834:	6928                	ld	a0,80(a0)
    80002836:	df1fe0ef          	jal	80001626 <copyinstr>
    8000283a:	00054c63          	bltz	a0,80002852 <fetchstr+0x3c>
  return strlen(buf);
    8000283e:	8526                	mv	a0,s1
    80002840:	daafe0ef          	jal	80000dea <strlen>
}
    80002844:	70a2                	ld	ra,40(sp)
    80002846:	7402                	ld	s0,32(sp)
    80002848:	64e2                	ld	s1,24(sp)
    8000284a:	6942                	ld	s2,16(sp)
    8000284c:	69a2                	ld	s3,8(sp)
    8000284e:	6145                	add	sp,sp,48
    80002850:	8082                	ret
    return -1;
    80002852:	557d                	li	a0,-1
    80002854:	bfc5                	j	80002844 <fetchstr+0x2e>

0000000080002856 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002856:	1101                	add	sp,sp,-32
    80002858:	ec06                	sd	ra,24(sp)
    8000285a:	e822                	sd	s0,16(sp)
    8000285c:	e426                	sd	s1,8(sp)
    8000285e:	1000                	add	s0,sp,32
    80002860:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002862:	f0bff0ef          	jal	8000276c <argraw>
    80002866:	c088                	sw	a0,0(s1)
}
    80002868:	60e2                	ld	ra,24(sp)
    8000286a:	6442                	ld	s0,16(sp)
    8000286c:	64a2                	ld	s1,8(sp)
    8000286e:	6105                	add	sp,sp,32
    80002870:	8082                	ret

0000000080002872 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002872:	1101                	add	sp,sp,-32
    80002874:	ec06                	sd	ra,24(sp)
    80002876:	e822                	sd	s0,16(sp)
    80002878:	e426                	sd	s1,8(sp)
    8000287a:	1000                	add	s0,sp,32
    8000287c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000287e:	eefff0ef          	jal	8000276c <argraw>
    80002882:	e088                	sd	a0,0(s1)
}
    80002884:	60e2                	ld	ra,24(sp)
    80002886:	6442                	ld	s0,16(sp)
    80002888:	64a2                	ld	s1,8(sp)
    8000288a:	6105                	add	sp,sp,32
    8000288c:	8082                	ret

000000008000288e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000288e:	7179                	add	sp,sp,-48
    80002890:	f406                	sd	ra,40(sp)
    80002892:	f022                	sd	s0,32(sp)
    80002894:	ec26                	sd	s1,24(sp)
    80002896:	e84a                	sd	s2,16(sp)
    80002898:	1800                	add	s0,sp,48
    8000289a:	84ae                	mv	s1,a1
    8000289c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000289e:	fd840593          	add	a1,s0,-40
    800028a2:	fd1ff0ef          	jal	80002872 <argaddr>
  return fetchstr(addr, buf, max);
    800028a6:	864a                	mv	a2,s2
    800028a8:	85a6                	mv	a1,s1
    800028aa:	fd843503          	ld	a0,-40(s0)
    800028ae:	f69ff0ef          	jal	80002816 <fetchstr>
}
    800028b2:	70a2                	ld	ra,40(sp)
    800028b4:	7402                	ld	s0,32(sp)
    800028b6:	64e2                	ld	s1,24(sp)
    800028b8:	6942                	ld	s2,16(sp)
    800028ba:	6145                	add	sp,sp,48
    800028bc:	8082                	ret

00000000800028be <syscall>:
[SYS_increment_metric] sys_increment_metric
};

void
syscall(void)
{
    800028be:	1101                	add	sp,sp,-32
    800028c0:	ec06                	sd	ra,24(sp)
    800028c2:	e822                	sd	s0,16(sp)
    800028c4:	e426                	sd	s1,8(sp)
    800028c6:	e04a                	sd	s2,0(sp)
    800028c8:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    800028ca:	f67fe0ef          	jal	80001830 <myproc>
    800028ce:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800028d0:	05853903          	ld	s2,88(a0)
    800028d4:	0a893783          	ld	a5,168(s2)
    800028d8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800028dc:	37fd                	addw	a5,a5,-1
    800028de:	4761                	li	a4,24
    800028e0:	00f76f63          	bltu	a4,a5,800028fe <syscall+0x40>
    800028e4:	00369713          	sll	a4,a3,0x3
    800028e8:	00005797          	auipc	a5,0x5
    800028ec:	ba878793          	add	a5,a5,-1112 # 80007490 <syscalls>
    800028f0:	97ba                	add	a5,a5,a4
    800028f2:	639c                	ld	a5,0(a5)
    800028f4:	c789                	beqz	a5,800028fe <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800028f6:	9782                	jalr	a5
    800028f8:	06a93823          	sd	a0,112(s2)
    800028fc:	a829                	j	80002916 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800028fe:	15848613          	add	a2,s1,344
    80002902:	588c                	lw	a1,48(s1)
    80002904:	00005517          	auipc	a0,0x5
    80002908:	b5450513          	add	a0,a0,-1196 # 80007458 <states.0+0x158>
    8000290c:	b93fd0ef          	jal	8000049e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002910:	6cbc                	ld	a5,88(s1)
    80002912:	577d                	li	a4,-1
    80002914:	fbb8                	sd	a4,112(a5)
  }
}
    80002916:	60e2                	ld	ra,24(sp)
    80002918:	6442                	ld	s0,16(sp)
    8000291a:	64a2                	ld	s1,8(sp)
    8000291c:	6902                	ld	s2,0(sp)
    8000291e:	6105                	add	sp,sp,32
    80002920:	8082                	ret

0000000080002922 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002922:	1101                	add	sp,sp,-32
    80002924:	ec06                	sd	ra,24(sp)
    80002926:	e822                	sd	s0,16(sp)
    80002928:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    8000292a:	fec40593          	add	a1,s0,-20
    8000292e:	4501                	li	a0,0
    80002930:	f27ff0ef          	jal	80002856 <argint>
  exit(n);
    80002934:	fec42503          	lw	a0,-20(s0)
    80002938:	df2ff0ef          	jal	80001f2a <exit>
  return 0;  // not reached
}
    8000293c:	4501                	li	a0,0
    8000293e:	60e2                	ld	ra,24(sp)
    80002940:	6442                	ld	s0,16(sp)
    80002942:	6105                	add	sp,sp,32
    80002944:	8082                	ret

0000000080002946 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002946:	1141                	add	sp,sp,-16
    80002948:	e406                	sd	ra,8(sp)
    8000294a:	e022                	sd	s0,0(sp)
    8000294c:	0800                	add	s0,sp,16
  return myproc()->pid;
    8000294e:	ee3fe0ef          	jal	80001830 <myproc>
}
    80002952:	5908                	lw	a0,48(a0)
    80002954:	60a2                	ld	ra,8(sp)
    80002956:	6402                	ld	s0,0(sp)
    80002958:	0141                	add	sp,sp,16
    8000295a:	8082                	ret

000000008000295c <sys_fork>:

uint64
sys_fork(void)
{
    8000295c:	1141                	add	sp,sp,-16
    8000295e:	e406                	sd	ra,8(sp)
    80002960:	e022                	sd	s0,0(sp)
    80002962:	0800                	add	s0,sp,16
  return fork();
    80002964:	9feff0ef          	jal	80001b62 <fork>
}
    80002968:	60a2                	ld	ra,8(sp)
    8000296a:	6402                	ld	s0,0(sp)
    8000296c:	0141                	add	sp,sp,16
    8000296e:	8082                	ret

0000000080002970 <sys_wait>:

uint64
sys_wait(void)
{
    80002970:	1101                	add	sp,sp,-32
    80002972:	ec06                	sd	ra,24(sp)
    80002974:	e822                	sd	s0,16(sp)
    80002976:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002978:	fe840593          	add	a1,s0,-24
    8000297c:	4501                	li	a0,0
    8000297e:	ef5ff0ef          	jal	80002872 <argaddr>
  return wait(p);
    80002982:	fe843503          	ld	a0,-24(s0)
    80002986:	efaff0ef          	jal	80002080 <wait>
}
    8000298a:	60e2                	ld	ra,24(sp)
    8000298c:	6442                	ld	s0,16(sp)
    8000298e:	6105                	add	sp,sp,32
    80002990:	8082                	ret

0000000080002992 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002992:	7179                	add	sp,sp,-48
    80002994:	f406                	sd	ra,40(sp)
    80002996:	f022                	sd	s0,32(sp)
    80002998:	ec26                	sd	s1,24(sp)
    8000299a:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000299c:	fdc40593          	add	a1,s0,-36
    800029a0:	4501                	li	a0,0
    800029a2:	eb5ff0ef          	jal	80002856 <argint>
  addr = myproc()->sz;
    800029a6:	e8bfe0ef          	jal	80001830 <myproc>
    800029aa:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800029ac:	fdc42503          	lw	a0,-36(s0)
    800029b0:	962ff0ef          	jal	80001b12 <growproc>
    800029b4:	00054863          	bltz	a0,800029c4 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    800029b8:	8526                	mv	a0,s1
    800029ba:	70a2                	ld	ra,40(sp)
    800029bc:	7402                	ld	s0,32(sp)
    800029be:	64e2                	ld	s1,24(sp)
    800029c0:	6145                	add	sp,sp,48
    800029c2:	8082                	ret
    return -1;
    800029c4:	54fd                	li	s1,-1
    800029c6:	bfcd                	j	800029b8 <sys_sbrk+0x26>

00000000800029c8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800029c8:	7139                	add	sp,sp,-64
    800029ca:	fc06                	sd	ra,56(sp)
    800029cc:	f822                	sd	s0,48(sp)
    800029ce:	f426                	sd	s1,40(sp)
    800029d0:	f04a                	sd	s2,32(sp)
    800029d2:	ec4e                	sd	s3,24(sp)
    800029d4:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800029d6:	fcc40593          	add	a1,s0,-52
    800029da:	4501                	li	a0,0
    800029dc:	e7bff0ef          	jal	80002856 <argint>
  if(n < 0)
    800029e0:	fcc42783          	lw	a5,-52(s0)
    800029e4:	0607c563          	bltz	a5,80002a4e <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    800029e8:	00013517          	auipc	a0,0x13
    800029ec:	2b850513          	add	a0,a0,696 # 80015ca0 <tickslock>
    800029f0:	9b0fe0ef          	jal	80000ba0 <acquire>
  ticks0 = ticks;
    800029f4:	00005917          	auipc	s2,0x5
    800029f8:	f4c92903          	lw	s2,-180(s2) # 80007940 <ticks>
  while(ticks - ticks0 < n){
    800029fc:	fcc42783          	lw	a5,-52(s0)
    80002a00:	cb8d                	beqz	a5,80002a32 <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002a02:	00013997          	auipc	s3,0x13
    80002a06:	29e98993          	add	s3,s3,670 # 80015ca0 <tickslock>
    80002a0a:	00005497          	auipc	s1,0x5
    80002a0e:	f3648493          	add	s1,s1,-202 # 80007940 <ticks>
    if(killed(myproc())){
    80002a12:	e1ffe0ef          	jal	80001830 <myproc>
    80002a16:	e40ff0ef          	jal	80002056 <killed>
    80002a1a:	ed0d                	bnez	a0,80002a54 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002a1c:	85ce                	mv	a1,s3
    80002a1e:	8526                	mv	a0,s1
    80002a20:	bfeff0ef          	jal	80001e1e <sleep>
  while(ticks - ticks0 < n){
    80002a24:	409c                	lw	a5,0(s1)
    80002a26:	412787bb          	subw	a5,a5,s2
    80002a2a:	fcc42703          	lw	a4,-52(s0)
    80002a2e:	fee7e2e3          	bltu	a5,a4,80002a12 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002a32:	00013517          	auipc	a0,0x13
    80002a36:	26e50513          	add	a0,a0,622 # 80015ca0 <tickslock>
    80002a3a:	9fefe0ef          	jal	80000c38 <release>
  return 0;
    80002a3e:	4501                	li	a0,0
}
    80002a40:	70e2                	ld	ra,56(sp)
    80002a42:	7442                	ld	s0,48(sp)
    80002a44:	74a2                	ld	s1,40(sp)
    80002a46:	7902                	ld	s2,32(sp)
    80002a48:	69e2                	ld	s3,24(sp)
    80002a4a:	6121                	add	sp,sp,64
    80002a4c:	8082                	ret
    n = 0;
    80002a4e:	fc042623          	sw	zero,-52(s0)
    80002a52:	bf59                	j	800029e8 <sys_sleep+0x20>
      release(&tickslock);
    80002a54:	00013517          	auipc	a0,0x13
    80002a58:	24c50513          	add	a0,a0,588 # 80015ca0 <tickslock>
    80002a5c:	9dcfe0ef          	jal	80000c38 <release>
      return -1;
    80002a60:	557d                	li	a0,-1
    80002a62:	bff9                	j	80002a40 <sys_sleep+0x78>

0000000080002a64 <sys_kill>:

uint64
sys_kill(void)
{
    80002a64:	1101                	add	sp,sp,-32
    80002a66:	ec06                	sd	ra,24(sp)
    80002a68:	e822                	sd	s0,16(sp)
    80002a6a:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002a6c:	fec40593          	add	a1,s0,-20
    80002a70:	4501                	li	a0,0
    80002a72:	de5ff0ef          	jal	80002856 <argint>
  return kill(pid);
    80002a76:	fec42503          	lw	a0,-20(s0)
    80002a7a:	d52ff0ef          	jal	80001fcc <kill>
}
    80002a7e:	60e2                	ld	ra,24(sp)
    80002a80:	6442                	ld	s0,16(sp)
    80002a82:	6105                	add	sp,sp,32
    80002a84:	8082                	ret

0000000080002a86 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002a86:	1101                	add	sp,sp,-32
    80002a88:	ec06                	sd	ra,24(sp)
    80002a8a:	e822                	sd	s0,16(sp)
    80002a8c:	e426                	sd	s1,8(sp)
    80002a8e:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002a90:	00013517          	auipc	a0,0x13
    80002a94:	21050513          	add	a0,a0,528 # 80015ca0 <tickslock>
    80002a98:	908fe0ef          	jal	80000ba0 <acquire>
  xticks = ticks;
    80002a9c:	00005497          	auipc	s1,0x5
    80002aa0:	ea44a483          	lw	s1,-348(s1) # 80007940 <ticks>
  release(&tickslock);
    80002aa4:	00013517          	auipc	a0,0x13
    80002aa8:	1fc50513          	add	a0,a0,508 # 80015ca0 <tickslock>
    80002aac:	98cfe0ef          	jal	80000c38 <release>
  return xticks;
}
    80002ab0:	02049513          	sll	a0,s1,0x20
    80002ab4:	9101                	srl	a0,a0,0x20
    80002ab6:	60e2                	ld	ra,24(sp)
    80002ab8:	6442                	ld	s0,16(sp)
    80002aba:	64a2                	ld	s1,8(sp)
    80002abc:	6105                	add	sp,sp,32
    80002abe:	8082                	ret

0000000080002ac0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ac0:	7179                	add	sp,sp,-48
    80002ac2:	f406                	sd	ra,40(sp)
    80002ac4:	f022                	sd	s0,32(sp)
    80002ac6:	ec26                	sd	s1,24(sp)
    80002ac8:	e84a                	sd	s2,16(sp)
    80002aca:	e44e                	sd	s3,8(sp)
    80002acc:	e052                	sd	s4,0(sp)
    80002ace:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002ad0:	00005597          	auipc	a1,0x5
    80002ad4:	a9058593          	add	a1,a1,-1392 # 80007560 <syscalls+0xd0>
    80002ad8:	00013517          	auipc	a0,0x13
    80002adc:	1e050513          	add	a0,a0,480 # 80015cb8 <bcache>
    80002ae0:	840fe0ef          	jal	80000b20 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002ae4:	0001b797          	auipc	a5,0x1b
    80002ae8:	1d478793          	add	a5,a5,468 # 8001dcb8 <bcache+0x8000>
    80002aec:	0001b717          	auipc	a4,0x1b
    80002af0:	43470713          	add	a4,a4,1076 # 8001df20 <bcache+0x8268>
    80002af4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002af8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002afc:	00013497          	auipc	s1,0x13
    80002b00:	1d448493          	add	s1,s1,468 # 80015cd0 <bcache+0x18>
    b->next = bcache.head.next;
    80002b04:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002b06:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002b08:	00005a17          	auipc	s4,0x5
    80002b0c:	a60a0a13          	add	s4,s4,-1440 # 80007568 <syscalls+0xd8>
    b->next = bcache.head.next;
    80002b10:	2b893783          	ld	a5,696(s2)
    80002b14:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002b16:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002b1a:	85d2                	mv	a1,s4
    80002b1c:	01048513          	add	a0,s1,16
    80002b20:	1f6010ef          	jal	80003d16 <initsleeplock>
    bcache.head.next->prev = b;
    80002b24:	2b893783          	ld	a5,696(s2)
    80002b28:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002b2a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b2e:	45848493          	add	s1,s1,1112
    80002b32:	fd349fe3          	bne	s1,s3,80002b10 <binit+0x50>
  }
}
    80002b36:	70a2                	ld	ra,40(sp)
    80002b38:	7402                	ld	s0,32(sp)
    80002b3a:	64e2                	ld	s1,24(sp)
    80002b3c:	6942                	ld	s2,16(sp)
    80002b3e:	69a2                	ld	s3,8(sp)
    80002b40:	6a02                	ld	s4,0(sp)
    80002b42:	6145                	add	sp,sp,48
    80002b44:	8082                	ret

0000000080002b46 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002b46:	7179                	add	sp,sp,-48
    80002b48:	f406                	sd	ra,40(sp)
    80002b4a:	f022                	sd	s0,32(sp)
    80002b4c:	ec26                	sd	s1,24(sp)
    80002b4e:	e84a                	sd	s2,16(sp)
    80002b50:	e44e                	sd	s3,8(sp)
    80002b52:	1800                	add	s0,sp,48
    80002b54:	892a                	mv	s2,a0
    80002b56:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002b58:	00013517          	auipc	a0,0x13
    80002b5c:	16050513          	add	a0,a0,352 # 80015cb8 <bcache>
    80002b60:	840fe0ef          	jal	80000ba0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002b64:	0001b497          	auipc	s1,0x1b
    80002b68:	40c4b483          	ld	s1,1036(s1) # 8001df70 <bcache+0x82b8>
    80002b6c:	0001b797          	auipc	a5,0x1b
    80002b70:	3b478793          	add	a5,a5,948 # 8001df20 <bcache+0x8268>
    80002b74:	02f48b63          	beq	s1,a5,80002baa <bread+0x64>
    80002b78:	873e                	mv	a4,a5
    80002b7a:	a021                	j	80002b82 <bread+0x3c>
    80002b7c:	68a4                	ld	s1,80(s1)
    80002b7e:	02e48663          	beq	s1,a4,80002baa <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002b82:	449c                	lw	a5,8(s1)
    80002b84:	ff279ce3          	bne	a5,s2,80002b7c <bread+0x36>
    80002b88:	44dc                	lw	a5,12(s1)
    80002b8a:	ff3799e3          	bne	a5,s3,80002b7c <bread+0x36>
      b->refcnt++;
    80002b8e:	40bc                	lw	a5,64(s1)
    80002b90:	2785                	addw	a5,a5,1
    80002b92:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002b94:	00013517          	auipc	a0,0x13
    80002b98:	12450513          	add	a0,a0,292 # 80015cb8 <bcache>
    80002b9c:	89cfe0ef          	jal	80000c38 <release>
      acquiresleep(&b->lock);
    80002ba0:	01048513          	add	a0,s1,16
    80002ba4:	1a8010ef          	jal	80003d4c <acquiresleep>
      return b;
    80002ba8:	a889                	j	80002bfa <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002baa:	0001b497          	auipc	s1,0x1b
    80002bae:	3be4b483          	ld	s1,958(s1) # 8001df68 <bcache+0x82b0>
    80002bb2:	0001b797          	auipc	a5,0x1b
    80002bb6:	36e78793          	add	a5,a5,878 # 8001df20 <bcache+0x8268>
    80002bba:	00f48863          	beq	s1,a5,80002bca <bread+0x84>
    80002bbe:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002bc0:	40bc                	lw	a5,64(s1)
    80002bc2:	cb91                	beqz	a5,80002bd6 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002bc4:	64a4                	ld	s1,72(s1)
    80002bc6:	fee49de3          	bne	s1,a4,80002bc0 <bread+0x7a>
  panic("bget: no buffers");
    80002bca:	00005517          	auipc	a0,0x5
    80002bce:	9a650513          	add	a0,a0,-1626 # 80007570 <syscalls+0xe0>
    80002bd2:	b8dfd0ef          	jal	8000075e <panic>
      b->dev = dev;
    80002bd6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002bda:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002bde:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002be2:	4785                	li	a5,1
    80002be4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002be6:	00013517          	auipc	a0,0x13
    80002bea:	0d250513          	add	a0,a0,210 # 80015cb8 <bcache>
    80002bee:	84afe0ef          	jal	80000c38 <release>
      acquiresleep(&b->lock);
    80002bf2:	01048513          	add	a0,s1,16
    80002bf6:	156010ef          	jal	80003d4c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002bfa:	409c                	lw	a5,0(s1)
    80002bfc:	cb89                	beqz	a5,80002c0e <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002bfe:	8526                	mv	a0,s1
    80002c00:	70a2                	ld	ra,40(sp)
    80002c02:	7402                	ld	s0,32(sp)
    80002c04:	64e2                	ld	s1,24(sp)
    80002c06:	6942                	ld	s2,16(sp)
    80002c08:	69a2                	ld	s3,8(sp)
    80002c0a:	6145                	add	sp,sp,48
    80002c0c:	8082                	ret
    virtio_disk_rw(b, 0);
    80002c0e:	4581                	li	a1,0
    80002c10:	8526                	mv	a0,s1
    80002c12:	079020ef          	jal	8000548a <virtio_disk_rw>
    b->valid = 1;
    80002c16:	4785                	li	a5,1
    80002c18:	c09c                	sw	a5,0(s1)
  return b;
    80002c1a:	b7d5                	j	80002bfe <bread+0xb8>

0000000080002c1c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002c1c:	1101                	add	sp,sp,-32
    80002c1e:	ec06                	sd	ra,24(sp)
    80002c20:	e822                	sd	s0,16(sp)
    80002c22:	e426                	sd	s1,8(sp)
    80002c24:	1000                	add	s0,sp,32
    80002c26:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c28:	0541                	add	a0,a0,16
    80002c2a:	1a0010ef          	jal	80003dca <holdingsleep>
    80002c2e:	c911                	beqz	a0,80002c42 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002c30:	4585                	li	a1,1
    80002c32:	8526                	mv	a0,s1
    80002c34:	057020ef          	jal	8000548a <virtio_disk_rw>
}
    80002c38:	60e2                	ld	ra,24(sp)
    80002c3a:	6442                	ld	s0,16(sp)
    80002c3c:	64a2                	ld	s1,8(sp)
    80002c3e:	6105                	add	sp,sp,32
    80002c40:	8082                	ret
    panic("bwrite");
    80002c42:	00005517          	auipc	a0,0x5
    80002c46:	94650513          	add	a0,a0,-1722 # 80007588 <syscalls+0xf8>
    80002c4a:	b15fd0ef          	jal	8000075e <panic>

0000000080002c4e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002c4e:	1101                	add	sp,sp,-32
    80002c50:	ec06                	sd	ra,24(sp)
    80002c52:	e822                	sd	s0,16(sp)
    80002c54:	e426                	sd	s1,8(sp)
    80002c56:	e04a                	sd	s2,0(sp)
    80002c58:	1000                	add	s0,sp,32
    80002c5a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c5c:	01050913          	add	s2,a0,16
    80002c60:	854a                	mv	a0,s2
    80002c62:	168010ef          	jal	80003dca <holdingsleep>
    80002c66:	c135                	beqz	a0,80002cca <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002c68:	854a                	mv	a0,s2
    80002c6a:	128010ef          	jal	80003d92 <releasesleep>

  acquire(&bcache.lock);
    80002c6e:	00013517          	auipc	a0,0x13
    80002c72:	04a50513          	add	a0,a0,74 # 80015cb8 <bcache>
    80002c76:	f2bfd0ef          	jal	80000ba0 <acquire>
  b->refcnt--;
    80002c7a:	40bc                	lw	a5,64(s1)
    80002c7c:	37fd                	addw	a5,a5,-1
    80002c7e:	0007871b          	sext.w	a4,a5
    80002c82:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002c84:	e71d                	bnez	a4,80002cb2 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002c86:	68b8                	ld	a4,80(s1)
    80002c88:	64bc                	ld	a5,72(s1)
    80002c8a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002c8c:	68b8                	ld	a4,80(s1)
    80002c8e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002c90:	0001b797          	auipc	a5,0x1b
    80002c94:	02878793          	add	a5,a5,40 # 8001dcb8 <bcache+0x8000>
    80002c98:	2b87b703          	ld	a4,696(a5)
    80002c9c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002c9e:	0001b717          	auipc	a4,0x1b
    80002ca2:	28270713          	add	a4,a4,642 # 8001df20 <bcache+0x8268>
    80002ca6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002ca8:	2b87b703          	ld	a4,696(a5)
    80002cac:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002cae:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002cb2:	00013517          	auipc	a0,0x13
    80002cb6:	00650513          	add	a0,a0,6 # 80015cb8 <bcache>
    80002cba:	f7ffd0ef          	jal	80000c38 <release>
}
    80002cbe:	60e2                	ld	ra,24(sp)
    80002cc0:	6442                	ld	s0,16(sp)
    80002cc2:	64a2                	ld	s1,8(sp)
    80002cc4:	6902                	ld	s2,0(sp)
    80002cc6:	6105                	add	sp,sp,32
    80002cc8:	8082                	ret
    panic("brelse");
    80002cca:	00005517          	auipc	a0,0x5
    80002cce:	8c650513          	add	a0,a0,-1850 # 80007590 <syscalls+0x100>
    80002cd2:	a8dfd0ef          	jal	8000075e <panic>

0000000080002cd6 <bpin>:

void
bpin(struct buf *b) {
    80002cd6:	1101                	add	sp,sp,-32
    80002cd8:	ec06                	sd	ra,24(sp)
    80002cda:	e822                	sd	s0,16(sp)
    80002cdc:	e426                	sd	s1,8(sp)
    80002cde:	1000                	add	s0,sp,32
    80002ce0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002ce2:	00013517          	auipc	a0,0x13
    80002ce6:	fd650513          	add	a0,a0,-42 # 80015cb8 <bcache>
    80002cea:	eb7fd0ef          	jal	80000ba0 <acquire>
  b->refcnt++;
    80002cee:	40bc                	lw	a5,64(s1)
    80002cf0:	2785                	addw	a5,a5,1
    80002cf2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002cf4:	00013517          	auipc	a0,0x13
    80002cf8:	fc450513          	add	a0,a0,-60 # 80015cb8 <bcache>
    80002cfc:	f3dfd0ef          	jal	80000c38 <release>
}
    80002d00:	60e2                	ld	ra,24(sp)
    80002d02:	6442                	ld	s0,16(sp)
    80002d04:	64a2                	ld	s1,8(sp)
    80002d06:	6105                	add	sp,sp,32
    80002d08:	8082                	ret

0000000080002d0a <bunpin>:

void
bunpin(struct buf *b) {
    80002d0a:	1101                	add	sp,sp,-32
    80002d0c:	ec06                	sd	ra,24(sp)
    80002d0e:	e822                	sd	s0,16(sp)
    80002d10:	e426                	sd	s1,8(sp)
    80002d12:	1000                	add	s0,sp,32
    80002d14:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d16:	00013517          	auipc	a0,0x13
    80002d1a:	fa250513          	add	a0,a0,-94 # 80015cb8 <bcache>
    80002d1e:	e83fd0ef          	jal	80000ba0 <acquire>
  b->refcnt--;
    80002d22:	40bc                	lw	a5,64(s1)
    80002d24:	37fd                	addw	a5,a5,-1
    80002d26:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d28:	00013517          	auipc	a0,0x13
    80002d2c:	f9050513          	add	a0,a0,-112 # 80015cb8 <bcache>
    80002d30:	f09fd0ef          	jal	80000c38 <release>
}
    80002d34:	60e2                	ld	ra,24(sp)
    80002d36:	6442                	ld	s0,16(sp)
    80002d38:	64a2                	ld	s1,8(sp)
    80002d3a:	6105                	add	sp,sp,32
    80002d3c:	8082                	ret

0000000080002d3e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002d3e:	1101                	add	sp,sp,-32
    80002d40:	ec06                	sd	ra,24(sp)
    80002d42:	e822                	sd	s0,16(sp)
    80002d44:	e426                	sd	s1,8(sp)
    80002d46:	e04a                	sd	s2,0(sp)
    80002d48:	1000                	add	s0,sp,32
    80002d4a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002d4c:	00d5d59b          	srlw	a1,a1,0xd
    80002d50:	0001b797          	auipc	a5,0x1b
    80002d54:	6447a783          	lw	a5,1604(a5) # 8001e394 <sb+0x1c>
    80002d58:	9dbd                	addw	a1,a1,a5
    80002d5a:	dedff0ef          	jal	80002b46 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002d5e:	0074f713          	and	a4,s1,7
    80002d62:	4785                	li	a5,1
    80002d64:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002d68:	14ce                	sll	s1,s1,0x33
    80002d6a:	90d9                	srl	s1,s1,0x36
    80002d6c:	00950733          	add	a4,a0,s1
    80002d70:	05874703          	lbu	a4,88(a4)
    80002d74:	00e7f6b3          	and	a3,a5,a4
    80002d78:	c29d                	beqz	a3,80002d9e <bfree+0x60>
    80002d7a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002d7c:	94aa                	add	s1,s1,a0
    80002d7e:	fff7c793          	not	a5,a5
    80002d82:	8f7d                	and	a4,a4,a5
    80002d84:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002d88:	6bf000ef          	jal	80003c46 <log_write>
  brelse(bp);
    80002d8c:	854a                	mv	a0,s2
    80002d8e:	ec1ff0ef          	jal	80002c4e <brelse>
}
    80002d92:	60e2                	ld	ra,24(sp)
    80002d94:	6442                	ld	s0,16(sp)
    80002d96:	64a2                	ld	s1,8(sp)
    80002d98:	6902                	ld	s2,0(sp)
    80002d9a:	6105                	add	sp,sp,32
    80002d9c:	8082                	ret
    panic("freeing free block");
    80002d9e:	00004517          	auipc	a0,0x4
    80002da2:	7fa50513          	add	a0,a0,2042 # 80007598 <syscalls+0x108>
    80002da6:	9b9fd0ef          	jal	8000075e <panic>

0000000080002daa <balloc>:
{
    80002daa:	711d                	add	sp,sp,-96
    80002dac:	ec86                	sd	ra,88(sp)
    80002dae:	e8a2                	sd	s0,80(sp)
    80002db0:	e4a6                	sd	s1,72(sp)
    80002db2:	e0ca                	sd	s2,64(sp)
    80002db4:	fc4e                	sd	s3,56(sp)
    80002db6:	f852                	sd	s4,48(sp)
    80002db8:	f456                	sd	s5,40(sp)
    80002dba:	f05a                	sd	s6,32(sp)
    80002dbc:	ec5e                	sd	s7,24(sp)
    80002dbe:	e862                	sd	s8,16(sp)
    80002dc0:	e466                	sd	s9,8(sp)
    80002dc2:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002dc4:	0001b797          	auipc	a5,0x1b
    80002dc8:	5b87a783          	lw	a5,1464(a5) # 8001e37c <sb+0x4>
    80002dcc:	cff1                	beqz	a5,80002ea8 <balloc+0xfe>
    80002dce:	8baa                	mv	s7,a0
    80002dd0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002dd2:	0001bb17          	auipc	s6,0x1b
    80002dd6:	5a6b0b13          	add	s6,s6,1446 # 8001e378 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002dda:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002ddc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002dde:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002de0:	6c89                	lui	s9,0x2
    80002de2:	a0b5                	j	80002e4e <balloc+0xa4>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002de4:	97ca                	add	a5,a5,s2
    80002de6:	8e55                	or	a2,a2,a3
    80002de8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002dec:	854a                	mv	a0,s2
    80002dee:	659000ef          	jal	80003c46 <log_write>
        brelse(bp);
    80002df2:	854a                	mv	a0,s2
    80002df4:	e5bff0ef          	jal	80002c4e <brelse>
  bp = bread(dev, bno);
    80002df8:	85a6                	mv	a1,s1
    80002dfa:	855e                	mv	a0,s7
    80002dfc:	d4bff0ef          	jal	80002b46 <bread>
    80002e00:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002e02:	40000613          	li	a2,1024
    80002e06:	4581                	li	a1,0
    80002e08:	05850513          	add	a0,a0,88
    80002e0c:	e69fd0ef          	jal	80000c74 <memset>
  log_write(bp);
    80002e10:	854a                	mv	a0,s2
    80002e12:	635000ef          	jal	80003c46 <log_write>
  brelse(bp);
    80002e16:	854a                	mv	a0,s2
    80002e18:	e37ff0ef          	jal	80002c4e <brelse>
}
    80002e1c:	8526                	mv	a0,s1
    80002e1e:	60e6                	ld	ra,88(sp)
    80002e20:	6446                	ld	s0,80(sp)
    80002e22:	64a6                	ld	s1,72(sp)
    80002e24:	6906                	ld	s2,64(sp)
    80002e26:	79e2                	ld	s3,56(sp)
    80002e28:	7a42                	ld	s4,48(sp)
    80002e2a:	7aa2                	ld	s5,40(sp)
    80002e2c:	7b02                	ld	s6,32(sp)
    80002e2e:	6be2                	ld	s7,24(sp)
    80002e30:	6c42                	ld	s8,16(sp)
    80002e32:	6ca2                	ld	s9,8(sp)
    80002e34:	6125                	add	sp,sp,96
    80002e36:	8082                	ret
    brelse(bp);
    80002e38:	854a                	mv	a0,s2
    80002e3a:	e15ff0ef          	jal	80002c4e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002e3e:	015c87bb          	addw	a5,s9,s5
    80002e42:	00078a9b          	sext.w	s5,a5
    80002e46:	004b2703          	lw	a4,4(s6)
    80002e4a:	04eaff63          	bgeu	s5,a4,80002ea8 <balloc+0xfe>
    bp = bread(dev, BBLOCK(b, sb));
    80002e4e:	41fad79b          	sraw	a5,s5,0x1f
    80002e52:	0137d79b          	srlw	a5,a5,0x13
    80002e56:	015787bb          	addw	a5,a5,s5
    80002e5a:	40d7d79b          	sraw	a5,a5,0xd
    80002e5e:	01cb2583          	lw	a1,28(s6)
    80002e62:	9dbd                	addw	a1,a1,a5
    80002e64:	855e                	mv	a0,s7
    80002e66:	ce1ff0ef          	jal	80002b46 <bread>
    80002e6a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e6c:	004b2503          	lw	a0,4(s6)
    80002e70:	000a849b          	sext.w	s1,s5
    80002e74:	8762                	mv	a4,s8
    80002e76:	fca4f1e3          	bgeu	s1,a0,80002e38 <balloc+0x8e>
      m = 1 << (bi % 8);
    80002e7a:	00777693          	and	a3,a4,7
    80002e7e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002e82:	41f7579b          	sraw	a5,a4,0x1f
    80002e86:	01d7d79b          	srlw	a5,a5,0x1d
    80002e8a:	9fb9                	addw	a5,a5,a4
    80002e8c:	4037d79b          	sraw	a5,a5,0x3
    80002e90:	00f90633          	add	a2,s2,a5
    80002e94:	05864603          	lbu	a2,88(a2)
    80002e98:	00c6f5b3          	and	a1,a3,a2
    80002e9c:	d5a1                	beqz	a1,80002de4 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e9e:	2705                	addw	a4,a4,1
    80002ea0:	2485                	addw	s1,s1,1
    80002ea2:	fd471ae3          	bne	a4,s4,80002e76 <balloc+0xcc>
    80002ea6:	bf49                	j	80002e38 <balloc+0x8e>
  printf("balloc: out of blocks\n");
    80002ea8:	00004517          	auipc	a0,0x4
    80002eac:	70850513          	add	a0,a0,1800 # 800075b0 <syscalls+0x120>
    80002eb0:	deefd0ef          	jal	8000049e <printf>
  return 0;
    80002eb4:	4481                	li	s1,0
    80002eb6:	b79d                	j	80002e1c <balloc+0x72>

0000000080002eb8 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002eb8:	7179                	add	sp,sp,-48
    80002eba:	f406                	sd	ra,40(sp)
    80002ebc:	f022                	sd	s0,32(sp)
    80002ebe:	ec26                	sd	s1,24(sp)
    80002ec0:	e84a                	sd	s2,16(sp)
    80002ec2:	e44e                	sd	s3,8(sp)
    80002ec4:	e052                	sd	s4,0(sp)
    80002ec6:	1800                	add	s0,sp,48
    80002ec8:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002eca:	47ad                	li	a5,11
    80002ecc:	02b7e663          	bltu	a5,a1,80002ef8 <bmap+0x40>
    if((addr = ip->addrs[bn]) == 0){
    80002ed0:	02059793          	sll	a5,a1,0x20
    80002ed4:	01e7d593          	srl	a1,a5,0x1e
    80002ed8:	00b504b3          	add	s1,a0,a1
    80002edc:	0504a903          	lw	s2,80(s1)
    80002ee0:	06091663          	bnez	s2,80002f4c <bmap+0x94>
      addr = balloc(ip->dev);
    80002ee4:	4108                	lw	a0,0(a0)
    80002ee6:	ec5ff0ef          	jal	80002daa <balloc>
    80002eea:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002eee:	04090f63          	beqz	s2,80002f4c <bmap+0x94>
        return 0;
      ip->addrs[bn] = addr;
    80002ef2:	0524a823          	sw	s2,80(s1)
    80002ef6:	a899                	j	80002f4c <bmap+0x94>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002ef8:	ff45849b          	addw	s1,a1,-12
    80002efc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002f00:	0ff00793          	li	a5,255
    80002f04:	06e7eb63          	bltu	a5,a4,80002f7a <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002f08:	08052903          	lw	s2,128(a0)
    80002f0c:	00091b63          	bnez	s2,80002f22 <bmap+0x6a>
      addr = balloc(ip->dev);
    80002f10:	4108                	lw	a0,0(a0)
    80002f12:	e99ff0ef          	jal	80002daa <balloc>
    80002f16:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002f1a:	02090963          	beqz	s2,80002f4c <bmap+0x94>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002f1e:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002f22:	85ca                	mv	a1,s2
    80002f24:	0009a503          	lw	a0,0(s3)
    80002f28:	c1fff0ef          	jal	80002b46 <bread>
    80002f2c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002f2e:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80002f32:	02049713          	sll	a4,s1,0x20
    80002f36:	01e75593          	srl	a1,a4,0x1e
    80002f3a:	00b784b3          	add	s1,a5,a1
    80002f3e:	0004a903          	lw	s2,0(s1)
    80002f42:	00090e63          	beqz	s2,80002f5e <bmap+0xa6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002f46:	8552                	mv	a0,s4
    80002f48:	d07ff0ef          	jal	80002c4e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002f4c:	854a                	mv	a0,s2
    80002f4e:	70a2                	ld	ra,40(sp)
    80002f50:	7402                	ld	s0,32(sp)
    80002f52:	64e2                	ld	s1,24(sp)
    80002f54:	6942                	ld	s2,16(sp)
    80002f56:	69a2                	ld	s3,8(sp)
    80002f58:	6a02                	ld	s4,0(sp)
    80002f5a:	6145                	add	sp,sp,48
    80002f5c:	8082                	ret
      addr = balloc(ip->dev);
    80002f5e:	0009a503          	lw	a0,0(s3)
    80002f62:	e49ff0ef          	jal	80002daa <balloc>
    80002f66:	0005091b          	sext.w	s2,a0
      if(addr){
    80002f6a:	fc090ee3          	beqz	s2,80002f46 <bmap+0x8e>
        a[bn] = addr;
    80002f6e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002f72:	8552                	mv	a0,s4
    80002f74:	4d3000ef          	jal	80003c46 <log_write>
    80002f78:	b7f9                	j	80002f46 <bmap+0x8e>
  panic("bmap: out of range");
    80002f7a:	00004517          	auipc	a0,0x4
    80002f7e:	64e50513          	add	a0,a0,1614 # 800075c8 <syscalls+0x138>
    80002f82:	fdcfd0ef          	jal	8000075e <panic>

0000000080002f86 <iget>:
{
    80002f86:	7179                	add	sp,sp,-48
    80002f88:	f406                	sd	ra,40(sp)
    80002f8a:	f022                	sd	s0,32(sp)
    80002f8c:	ec26                	sd	s1,24(sp)
    80002f8e:	e84a                	sd	s2,16(sp)
    80002f90:	e44e                	sd	s3,8(sp)
    80002f92:	e052                	sd	s4,0(sp)
    80002f94:	1800                	add	s0,sp,48
    80002f96:	89aa                	mv	s3,a0
    80002f98:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002f9a:	0001b517          	auipc	a0,0x1b
    80002f9e:	3fe50513          	add	a0,a0,1022 # 8001e398 <itable>
    80002fa2:	bfffd0ef          	jal	80000ba0 <acquire>
  empty = 0;
    80002fa6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002fa8:	0001b497          	auipc	s1,0x1b
    80002fac:	40848493          	add	s1,s1,1032 # 8001e3b0 <itable+0x18>
    80002fb0:	0001d697          	auipc	a3,0x1d
    80002fb4:	e9068693          	add	a3,a3,-368 # 8001fe40 <log>
    80002fb8:	a039                	j	80002fc6 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002fba:	02090963          	beqz	s2,80002fec <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002fbe:	08848493          	add	s1,s1,136
    80002fc2:	02d48863          	beq	s1,a3,80002ff2 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002fc6:	449c                	lw	a5,8(s1)
    80002fc8:	fef059e3          	blez	a5,80002fba <iget+0x34>
    80002fcc:	4098                	lw	a4,0(s1)
    80002fce:	ff3716e3          	bne	a4,s3,80002fba <iget+0x34>
    80002fd2:	40d8                	lw	a4,4(s1)
    80002fd4:	ff4713e3          	bne	a4,s4,80002fba <iget+0x34>
      ip->ref++;
    80002fd8:	2785                	addw	a5,a5,1
    80002fda:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002fdc:	0001b517          	auipc	a0,0x1b
    80002fe0:	3bc50513          	add	a0,a0,956 # 8001e398 <itable>
    80002fe4:	c55fd0ef          	jal	80000c38 <release>
      return ip;
    80002fe8:	8926                	mv	s2,s1
    80002fea:	a02d                	j	80003014 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002fec:	fbe9                	bnez	a5,80002fbe <iget+0x38>
    80002fee:	8926                	mv	s2,s1
    80002ff0:	b7f9                	j	80002fbe <iget+0x38>
  if(empty == 0)
    80002ff2:	02090a63          	beqz	s2,80003026 <iget+0xa0>
  ip->dev = dev;
    80002ff6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ffa:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ffe:	4785                	li	a5,1
    80003000:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003004:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003008:	0001b517          	auipc	a0,0x1b
    8000300c:	39050513          	add	a0,a0,912 # 8001e398 <itable>
    80003010:	c29fd0ef          	jal	80000c38 <release>
}
    80003014:	854a                	mv	a0,s2
    80003016:	70a2                	ld	ra,40(sp)
    80003018:	7402                	ld	s0,32(sp)
    8000301a:	64e2                	ld	s1,24(sp)
    8000301c:	6942                	ld	s2,16(sp)
    8000301e:	69a2                	ld	s3,8(sp)
    80003020:	6a02                	ld	s4,0(sp)
    80003022:	6145                	add	sp,sp,48
    80003024:	8082                	ret
    panic("iget: no inodes");
    80003026:	00004517          	auipc	a0,0x4
    8000302a:	5ba50513          	add	a0,a0,1466 # 800075e0 <syscalls+0x150>
    8000302e:	f30fd0ef          	jal	8000075e <panic>

0000000080003032 <fsinit>:
fsinit(int dev) {
    80003032:	7179                	add	sp,sp,-48
    80003034:	f406                	sd	ra,40(sp)
    80003036:	f022                	sd	s0,32(sp)
    80003038:	ec26                	sd	s1,24(sp)
    8000303a:	e84a                	sd	s2,16(sp)
    8000303c:	e44e                	sd	s3,8(sp)
    8000303e:	1800                	add	s0,sp,48
    80003040:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003042:	4585                	li	a1,1
    80003044:	b03ff0ef          	jal	80002b46 <bread>
    80003048:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000304a:	0001b997          	auipc	s3,0x1b
    8000304e:	32e98993          	add	s3,s3,814 # 8001e378 <sb>
    80003052:	02000613          	li	a2,32
    80003056:	05850593          	add	a1,a0,88
    8000305a:	854e                	mv	a0,s3
    8000305c:	c75fd0ef          	jal	80000cd0 <memmove>
  brelse(bp);
    80003060:	8526                	mv	a0,s1
    80003062:	bedff0ef          	jal	80002c4e <brelse>
  if(sb.magic != FSMAGIC)
    80003066:	0009a703          	lw	a4,0(s3)
    8000306a:	102037b7          	lui	a5,0x10203
    8000306e:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003072:	02f71063          	bne	a4,a5,80003092 <fsinit+0x60>
  initlog(dev, &sb);
    80003076:	0001b597          	auipc	a1,0x1b
    8000307a:	30258593          	add	a1,a1,770 # 8001e378 <sb>
    8000307e:	854a                	mv	a0,s2
    80003080:	1c5000ef          	jal	80003a44 <initlog>
}
    80003084:	70a2                	ld	ra,40(sp)
    80003086:	7402                	ld	s0,32(sp)
    80003088:	64e2                	ld	s1,24(sp)
    8000308a:	6942                	ld	s2,16(sp)
    8000308c:	69a2                	ld	s3,8(sp)
    8000308e:	6145                	add	sp,sp,48
    80003090:	8082                	ret
    panic("invalid file system");
    80003092:	00004517          	auipc	a0,0x4
    80003096:	55e50513          	add	a0,a0,1374 # 800075f0 <syscalls+0x160>
    8000309a:	ec4fd0ef          	jal	8000075e <panic>

000000008000309e <iinit>:
{
    8000309e:	7179                	add	sp,sp,-48
    800030a0:	f406                	sd	ra,40(sp)
    800030a2:	f022                	sd	s0,32(sp)
    800030a4:	ec26                	sd	s1,24(sp)
    800030a6:	e84a                	sd	s2,16(sp)
    800030a8:	e44e                	sd	s3,8(sp)
    800030aa:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    800030ac:	00004597          	auipc	a1,0x4
    800030b0:	55c58593          	add	a1,a1,1372 # 80007608 <syscalls+0x178>
    800030b4:	0001b517          	auipc	a0,0x1b
    800030b8:	2e450513          	add	a0,a0,740 # 8001e398 <itable>
    800030bc:	a65fd0ef          	jal	80000b20 <initlock>
  for(i = 0; i < NINODE; i++) {
    800030c0:	0001b497          	auipc	s1,0x1b
    800030c4:	30048493          	add	s1,s1,768 # 8001e3c0 <itable+0x28>
    800030c8:	0001d997          	auipc	s3,0x1d
    800030cc:	d8898993          	add	s3,s3,-632 # 8001fe50 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800030d0:	00004917          	auipc	s2,0x4
    800030d4:	54090913          	add	s2,s2,1344 # 80007610 <syscalls+0x180>
    800030d8:	85ca                	mv	a1,s2
    800030da:	8526                	mv	a0,s1
    800030dc:	43b000ef          	jal	80003d16 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800030e0:	08848493          	add	s1,s1,136
    800030e4:	ff349ae3          	bne	s1,s3,800030d8 <iinit+0x3a>
}
    800030e8:	70a2                	ld	ra,40(sp)
    800030ea:	7402                	ld	s0,32(sp)
    800030ec:	64e2                	ld	s1,24(sp)
    800030ee:	6942                	ld	s2,16(sp)
    800030f0:	69a2                	ld	s3,8(sp)
    800030f2:	6145                	add	sp,sp,48
    800030f4:	8082                	ret

00000000800030f6 <ialloc>:
{
    800030f6:	7139                	add	sp,sp,-64
    800030f8:	fc06                	sd	ra,56(sp)
    800030fa:	f822                	sd	s0,48(sp)
    800030fc:	f426                	sd	s1,40(sp)
    800030fe:	f04a                	sd	s2,32(sp)
    80003100:	ec4e                	sd	s3,24(sp)
    80003102:	e852                	sd	s4,16(sp)
    80003104:	e456                	sd	s5,8(sp)
    80003106:	e05a                	sd	s6,0(sp)
    80003108:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000310a:	0001b717          	auipc	a4,0x1b
    8000310e:	27a72703          	lw	a4,634(a4) # 8001e384 <sb+0xc>
    80003112:	4785                	li	a5,1
    80003114:	04e7f463          	bgeu	a5,a4,8000315c <ialloc+0x66>
    80003118:	8aaa                	mv	s5,a0
    8000311a:	8b2e                	mv	s6,a1
    8000311c:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000311e:	0001ba17          	auipc	s4,0x1b
    80003122:	25aa0a13          	add	s4,s4,602 # 8001e378 <sb>
    80003126:	00495593          	srl	a1,s2,0x4
    8000312a:	018a2783          	lw	a5,24(s4)
    8000312e:	9dbd                	addw	a1,a1,a5
    80003130:	8556                	mv	a0,s5
    80003132:	a15ff0ef          	jal	80002b46 <bread>
    80003136:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003138:	05850993          	add	s3,a0,88
    8000313c:	00f97793          	and	a5,s2,15
    80003140:	079a                	sll	a5,a5,0x6
    80003142:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003144:	00099783          	lh	a5,0(s3)
    80003148:	cb9d                	beqz	a5,8000317e <ialloc+0x88>
    brelse(bp);
    8000314a:	b05ff0ef          	jal	80002c4e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000314e:	0905                	add	s2,s2,1
    80003150:	00ca2703          	lw	a4,12(s4)
    80003154:	0009079b          	sext.w	a5,s2
    80003158:	fce7e7e3          	bltu	a5,a4,80003126 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    8000315c:	00004517          	auipc	a0,0x4
    80003160:	4bc50513          	add	a0,a0,1212 # 80007618 <syscalls+0x188>
    80003164:	b3afd0ef          	jal	8000049e <printf>
  return 0;
    80003168:	4501                	li	a0,0
}
    8000316a:	70e2                	ld	ra,56(sp)
    8000316c:	7442                	ld	s0,48(sp)
    8000316e:	74a2                	ld	s1,40(sp)
    80003170:	7902                	ld	s2,32(sp)
    80003172:	69e2                	ld	s3,24(sp)
    80003174:	6a42                	ld	s4,16(sp)
    80003176:	6aa2                	ld	s5,8(sp)
    80003178:	6b02                	ld	s6,0(sp)
    8000317a:	6121                	add	sp,sp,64
    8000317c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000317e:	04000613          	li	a2,64
    80003182:	4581                	li	a1,0
    80003184:	854e                	mv	a0,s3
    80003186:	aeffd0ef          	jal	80000c74 <memset>
      dip->type = type;
    8000318a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000318e:	8526                	mv	a0,s1
    80003190:	2b7000ef          	jal	80003c46 <log_write>
      brelse(bp);
    80003194:	8526                	mv	a0,s1
    80003196:	ab9ff0ef          	jal	80002c4e <brelse>
      return iget(dev, inum);
    8000319a:	0009059b          	sext.w	a1,s2
    8000319e:	8556                	mv	a0,s5
    800031a0:	de7ff0ef          	jal	80002f86 <iget>
    800031a4:	b7d9                	j	8000316a <ialloc+0x74>

00000000800031a6 <iupdate>:
{
    800031a6:	1101                	add	sp,sp,-32
    800031a8:	ec06                	sd	ra,24(sp)
    800031aa:	e822                	sd	s0,16(sp)
    800031ac:	e426                	sd	s1,8(sp)
    800031ae:	e04a                	sd	s2,0(sp)
    800031b0:	1000                	add	s0,sp,32
    800031b2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800031b4:	415c                	lw	a5,4(a0)
    800031b6:	0047d79b          	srlw	a5,a5,0x4
    800031ba:	0001b597          	auipc	a1,0x1b
    800031be:	1d65a583          	lw	a1,470(a1) # 8001e390 <sb+0x18>
    800031c2:	9dbd                	addw	a1,a1,a5
    800031c4:	4108                	lw	a0,0(a0)
    800031c6:	981ff0ef          	jal	80002b46 <bread>
    800031ca:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800031cc:	05850793          	add	a5,a0,88
    800031d0:	40d8                	lw	a4,4(s1)
    800031d2:	8b3d                	and	a4,a4,15
    800031d4:	071a                	sll	a4,a4,0x6
    800031d6:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800031d8:	04449703          	lh	a4,68(s1)
    800031dc:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800031e0:	04649703          	lh	a4,70(s1)
    800031e4:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800031e8:	04849703          	lh	a4,72(s1)
    800031ec:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800031f0:	04a49703          	lh	a4,74(s1)
    800031f4:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800031f8:	44f8                	lw	a4,76(s1)
    800031fa:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800031fc:	03400613          	li	a2,52
    80003200:	05048593          	add	a1,s1,80
    80003204:	00c78513          	add	a0,a5,12
    80003208:	ac9fd0ef          	jal	80000cd0 <memmove>
  log_write(bp);
    8000320c:	854a                	mv	a0,s2
    8000320e:	239000ef          	jal	80003c46 <log_write>
  brelse(bp);
    80003212:	854a                	mv	a0,s2
    80003214:	a3bff0ef          	jal	80002c4e <brelse>
}
    80003218:	60e2                	ld	ra,24(sp)
    8000321a:	6442                	ld	s0,16(sp)
    8000321c:	64a2                	ld	s1,8(sp)
    8000321e:	6902                	ld	s2,0(sp)
    80003220:	6105                	add	sp,sp,32
    80003222:	8082                	ret

0000000080003224 <idup>:
{
    80003224:	1101                	add	sp,sp,-32
    80003226:	ec06                	sd	ra,24(sp)
    80003228:	e822                	sd	s0,16(sp)
    8000322a:	e426                	sd	s1,8(sp)
    8000322c:	1000                	add	s0,sp,32
    8000322e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003230:	0001b517          	auipc	a0,0x1b
    80003234:	16850513          	add	a0,a0,360 # 8001e398 <itable>
    80003238:	969fd0ef          	jal	80000ba0 <acquire>
  ip->ref++;
    8000323c:	449c                	lw	a5,8(s1)
    8000323e:	2785                	addw	a5,a5,1
    80003240:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003242:	0001b517          	auipc	a0,0x1b
    80003246:	15650513          	add	a0,a0,342 # 8001e398 <itable>
    8000324a:	9effd0ef          	jal	80000c38 <release>
}
    8000324e:	8526                	mv	a0,s1
    80003250:	60e2                	ld	ra,24(sp)
    80003252:	6442                	ld	s0,16(sp)
    80003254:	64a2                	ld	s1,8(sp)
    80003256:	6105                	add	sp,sp,32
    80003258:	8082                	ret

000000008000325a <ilock>:
{
    8000325a:	1101                	add	sp,sp,-32
    8000325c:	ec06                	sd	ra,24(sp)
    8000325e:	e822                	sd	s0,16(sp)
    80003260:	e426                	sd	s1,8(sp)
    80003262:	e04a                	sd	s2,0(sp)
    80003264:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003266:	c105                	beqz	a0,80003286 <ilock+0x2c>
    80003268:	84aa                	mv	s1,a0
    8000326a:	451c                	lw	a5,8(a0)
    8000326c:	00f05d63          	blez	a5,80003286 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003270:	0541                	add	a0,a0,16
    80003272:	2db000ef          	jal	80003d4c <acquiresleep>
  if(ip->valid == 0){
    80003276:	40bc                	lw	a5,64(s1)
    80003278:	cf89                	beqz	a5,80003292 <ilock+0x38>
}
    8000327a:	60e2                	ld	ra,24(sp)
    8000327c:	6442                	ld	s0,16(sp)
    8000327e:	64a2                	ld	s1,8(sp)
    80003280:	6902                	ld	s2,0(sp)
    80003282:	6105                	add	sp,sp,32
    80003284:	8082                	ret
    panic("ilock");
    80003286:	00004517          	auipc	a0,0x4
    8000328a:	3aa50513          	add	a0,a0,938 # 80007630 <syscalls+0x1a0>
    8000328e:	cd0fd0ef          	jal	8000075e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003292:	40dc                	lw	a5,4(s1)
    80003294:	0047d79b          	srlw	a5,a5,0x4
    80003298:	0001b597          	auipc	a1,0x1b
    8000329c:	0f85a583          	lw	a1,248(a1) # 8001e390 <sb+0x18>
    800032a0:	9dbd                	addw	a1,a1,a5
    800032a2:	4088                	lw	a0,0(s1)
    800032a4:	8a3ff0ef          	jal	80002b46 <bread>
    800032a8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800032aa:	05850593          	add	a1,a0,88
    800032ae:	40dc                	lw	a5,4(s1)
    800032b0:	8bbd                	and	a5,a5,15
    800032b2:	079a                	sll	a5,a5,0x6
    800032b4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800032b6:	00059783          	lh	a5,0(a1)
    800032ba:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800032be:	00259783          	lh	a5,2(a1)
    800032c2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800032c6:	00459783          	lh	a5,4(a1)
    800032ca:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800032ce:	00659783          	lh	a5,6(a1)
    800032d2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800032d6:	459c                	lw	a5,8(a1)
    800032d8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800032da:	03400613          	li	a2,52
    800032de:	05b1                	add	a1,a1,12
    800032e0:	05048513          	add	a0,s1,80
    800032e4:	9edfd0ef          	jal	80000cd0 <memmove>
    brelse(bp);
    800032e8:	854a                	mv	a0,s2
    800032ea:	965ff0ef          	jal	80002c4e <brelse>
    ip->valid = 1;
    800032ee:	4785                	li	a5,1
    800032f0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800032f2:	04449783          	lh	a5,68(s1)
    800032f6:	f3d1                	bnez	a5,8000327a <ilock+0x20>
      panic("ilock: no type");
    800032f8:	00004517          	auipc	a0,0x4
    800032fc:	34050513          	add	a0,a0,832 # 80007638 <syscalls+0x1a8>
    80003300:	c5efd0ef          	jal	8000075e <panic>

0000000080003304 <iunlock>:
{
    80003304:	1101                	add	sp,sp,-32
    80003306:	ec06                	sd	ra,24(sp)
    80003308:	e822                	sd	s0,16(sp)
    8000330a:	e426                	sd	s1,8(sp)
    8000330c:	e04a                	sd	s2,0(sp)
    8000330e:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003310:	c505                	beqz	a0,80003338 <iunlock+0x34>
    80003312:	84aa                	mv	s1,a0
    80003314:	01050913          	add	s2,a0,16
    80003318:	854a                	mv	a0,s2
    8000331a:	2b1000ef          	jal	80003dca <holdingsleep>
    8000331e:	cd09                	beqz	a0,80003338 <iunlock+0x34>
    80003320:	449c                	lw	a5,8(s1)
    80003322:	00f05b63          	blez	a5,80003338 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003326:	854a                	mv	a0,s2
    80003328:	26b000ef          	jal	80003d92 <releasesleep>
}
    8000332c:	60e2                	ld	ra,24(sp)
    8000332e:	6442                	ld	s0,16(sp)
    80003330:	64a2                	ld	s1,8(sp)
    80003332:	6902                	ld	s2,0(sp)
    80003334:	6105                	add	sp,sp,32
    80003336:	8082                	ret
    panic("iunlock");
    80003338:	00004517          	auipc	a0,0x4
    8000333c:	31050513          	add	a0,a0,784 # 80007648 <syscalls+0x1b8>
    80003340:	c1efd0ef          	jal	8000075e <panic>

0000000080003344 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003344:	7179                	add	sp,sp,-48
    80003346:	f406                	sd	ra,40(sp)
    80003348:	f022                	sd	s0,32(sp)
    8000334a:	ec26                	sd	s1,24(sp)
    8000334c:	e84a                	sd	s2,16(sp)
    8000334e:	e44e                	sd	s3,8(sp)
    80003350:	e052                	sd	s4,0(sp)
    80003352:	1800                	add	s0,sp,48
    80003354:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003356:	05050493          	add	s1,a0,80
    8000335a:	08050913          	add	s2,a0,128
    8000335e:	a021                	j	80003366 <itrunc+0x22>
    80003360:	0491                	add	s1,s1,4
    80003362:	01248b63          	beq	s1,s2,80003378 <itrunc+0x34>
    if(ip->addrs[i]){
    80003366:	408c                	lw	a1,0(s1)
    80003368:	dde5                	beqz	a1,80003360 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000336a:	0009a503          	lw	a0,0(s3)
    8000336e:	9d1ff0ef          	jal	80002d3e <bfree>
      ip->addrs[i] = 0;
    80003372:	0004a023          	sw	zero,0(s1)
    80003376:	b7ed                	j	80003360 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003378:	0809a583          	lw	a1,128(s3)
    8000337c:	ed91                	bnez	a1,80003398 <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000337e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003382:	854e                	mv	a0,s3
    80003384:	e23ff0ef          	jal	800031a6 <iupdate>
}
    80003388:	70a2                	ld	ra,40(sp)
    8000338a:	7402                	ld	s0,32(sp)
    8000338c:	64e2                	ld	s1,24(sp)
    8000338e:	6942                	ld	s2,16(sp)
    80003390:	69a2                	ld	s3,8(sp)
    80003392:	6a02                	ld	s4,0(sp)
    80003394:	6145                	add	sp,sp,48
    80003396:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003398:	0009a503          	lw	a0,0(s3)
    8000339c:	faaff0ef          	jal	80002b46 <bread>
    800033a0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800033a2:	05850493          	add	s1,a0,88
    800033a6:	45850913          	add	s2,a0,1112
    800033aa:	a021                	j	800033b2 <itrunc+0x6e>
    800033ac:	0491                	add	s1,s1,4
    800033ae:	01248963          	beq	s1,s2,800033c0 <itrunc+0x7c>
      if(a[j])
    800033b2:	408c                	lw	a1,0(s1)
    800033b4:	dde5                	beqz	a1,800033ac <itrunc+0x68>
        bfree(ip->dev, a[j]);
    800033b6:	0009a503          	lw	a0,0(s3)
    800033ba:	985ff0ef          	jal	80002d3e <bfree>
    800033be:	b7fd                	j	800033ac <itrunc+0x68>
    brelse(bp);
    800033c0:	8552                	mv	a0,s4
    800033c2:	88dff0ef          	jal	80002c4e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800033c6:	0809a583          	lw	a1,128(s3)
    800033ca:	0009a503          	lw	a0,0(s3)
    800033ce:	971ff0ef          	jal	80002d3e <bfree>
    ip->addrs[NDIRECT] = 0;
    800033d2:	0809a023          	sw	zero,128(s3)
    800033d6:	b765                	j	8000337e <itrunc+0x3a>

00000000800033d8 <iput>:
{
    800033d8:	1101                	add	sp,sp,-32
    800033da:	ec06                	sd	ra,24(sp)
    800033dc:	e822                	sd	s0,16(sp)
    800033de:	e426                	sd	s1,8(sp)
    800033e0:	e04a                	sd	s2,0(sp)
    800033e2:	1000                	add	s0,sp,32
    800033e4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800033e6:	0001b517          	auipc	a0,0x1b
    800033ea:	fb250513          	add	a0,a0,-78 # 8001e398 <itable>
    800033ee:	fb2fd0ef          	jal	80000ba0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800033f2:	4498                	lw	a4,8(s1)
    800033f4:	4785                	li	a5,1
    800033f6:	02f70163          	beq	a4,a5,80003418 <iput+0x40>
  ip->ref--;
    800033fa:	449c                	lw	a5,8(s1)
    800033fc:	37fd                	addw	a5,a5,-1
    800033fe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003400:	0001b517          	auipc	a0,0x1b
    80003404:	f9850513          	add	a0,a0,-104 # 8001e398 <itable>
    80003408:	831fd0ef          	jal	80000c38 <release>
}
    8000340c:	60e2                	ld	ra,24(sp)
    8000340e:	6442                	ld	s0,16(sp)
    80003410:	64a2                	ld	s1,8(sp)
    80003412:	6902                	ld	s2,0(sp)
    80003414:	6105                	add	sp,sp,32
    80003416:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003418:	40bc                	lw	a5,64(s1)
    8000341a:	d3e5                	beqz	a5,800033fa <iput+0x22>
    8000341c:	04a49783          	lh	a5,74(s1)
    80003420:	ffe9                	bnez	a5,800033fa <iput+0x22>
    acquiresleep(&ip->lock);
    80003422:	01048913          	add	s2,s1,16
    80003426:	854a                	mv	a0,s2
    80003428:	125000ef          	jal	80003d4c <acquiresleep>
    release(&itable.lock);
    8000342c:	0001b517          	auipc	a0,0x1b
    80003430:	f6c50513          	add	a0,a0,-148 # 8001e398 <itable>
    80003434:	805fd0ef          	jal	80000c38 <release>
    itrunc(ip);
    80003438:	8526                	mv	a0,s1
    8000343a:	f0bff0ef          	jal	80003344 <itrunc>
    ip->type = 0;
    8000343e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003442:	8526                	mv	a0,s1
    80003444:	d63ff0ef          	jal	800031a6 <iupdate>
    ip->valid = 0;
    80003448:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000344c:	854a                	mv	a0,s2
    8000344e:	145000ef          	jal	80003d92 <releasesleep>
    acquire(&itable.lock);
    80003452:	0001b517          	auipc	a0,0x1b
    80003456:	f4650513          	add	a0,a0,-186 # 8001e398 <itable>
    8000345a:	f46fd0ef          	jal	80000ba0 <acquire>
    8000345e:	bf71                	j	800033fa <iput+0x22>

0000000080003460 <iunlockput>:
{
    80003460:	1101                	add	sp,sp,-32
    80003462:	ec06                	sd	ra,24(sp)
    80003464:	e822                	sd	s0,16(sp)
    80003466:	e426                	sd	s1,8(sp)
    80003468:	1000                	add	s0,sp,32
    8000346a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000346c:	e99ff0ef          	jal	80003304 <iunlock>
  iput(ip);
    80003470:	8526                	mv	a0,s1
    80003472:	f67ff0ef          	jal	800033d8 <iput>
}
    80003476:	60e2                	ld	ra,24(sp)
    80003478:	6442                	ld	s0,16(sp)
    8000347a:	64a2                	ld	s1,8(sp)
    8000347c:	6105                	add	sp,sp,32
    8000347e:	8082                	ret

0000000080003480 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003480:	1141                	add	sp,sp,-16
    80003482:	e422                	sd	s0,8(sp)
    80003484:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003486:	411c                	lw	a5,0(a0)
    80003488:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000348a:	415c                	lw	a5,4(a0)
    8000348c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000348e:	04451783          	lh	a5,68(a0)
    80003492:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003496:	04a51783          	lh	a5,74(a0)
    8000349a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000349e:	04c56783          	lwu	a5,76(a0)
    800034a2:	e99c                	sd	a5,16(a1)
}
    800034a4:	6422                	ld	s0,8(sp)
    800034a6:	0141                	add	sp,sp,16
    800034a8:	8082                	ret

00000000800034aa <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800034aa:	457c                	lw	a5,76(a0)
    800034ac:	0cd7ef63          	bltu	a5,a3,8000358a <readi+0xe0>
{
    800034b0:	7159                	add	sp,sp,-112
    800034b2:	f486                	sd	ra,104(sp)
    800034b4:	f0a2                	sd	s0,96(sp)
    800034b6:	eca6                	sd	s1,88(sp)
    800034b8:	e8ca                	sd	s2,80(sp)
    800034ba:	e4ce                	sd	s3,72(sp)
    800034bc:	e0d2                	sd	s4,64(sp)
    800034be:	fc56                	sd	s5,56(sp)
    800034c0:	f85a                	sd	s6,48(sp)
    800034c2:	f45e                	sd	s7,40(sp)
    800034c4:	f062                	sd	s8,32(sp)
    800034c6:	ec66                	sd	s9,24(sp)
    800034c8:	e86a                	sd	s10,16(sp)
    800034ca:	e46e                	sd	s11,8(sp)
    800034cc:	1880                	add	s0,sp,112
    800034ce:	8b2a                	mv	s6,a0
    800034d0:	8bae                	mv	s7,a1
    800034d2:	8a32                	mv	s4,a2
    800034d4:	84b6                	mv	s1,a3
    800034d6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800034d8:	9f35                	addw	a4,a4,a3
    return 0;
    800034da:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800034dc:	08d76663          	bltu	a4,a3,80003568 <readi+0xbe>
  if(off + n > ip->size)
    800034e0:	00e7f463          	bgeu	a5,a4,800034e8 <readi+0x3e>
    n = ip->size - off;
    800034e4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800034e8:	080a8f63          	beqz	s5,80003586 <readi+0xdc>
    800034ec:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800034ee:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800034f2:	5c7d                	li	s8,-1
    800034f4:	a80d                	j	80003526 <readi+0x7c>
    800034f6:	020d1d93          	sll	s11,s10,0x20
    800034fa:	020ddd93          	srl	s11,s11,0x20
    800034fe:	05890613          	add	a2,s2,88
    80003502:	86ee                	mv	a3,s11
    80003504:	963a                	add	a2,a2,a4
    80003506:	85d2                	mv	a1,s4
    80003508:	855e                	mv	a0,s7
    8000350a:	c71fe0ef          	jal	8000217a <either_copyout>
    8000350e:	05850763          	beq	a0,s8,8000355c <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003512:	854a                	mv	a0,s2
    80003514:	f3aff0ef          	jal	80002c4e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003518:	013d09bb          	addw	s3,s10,s3
    8000351c:	009d04bb          	addw	s1,s10,s1
    80003520:	9a6e                	add	s4,s4,s11
    80003522:	0559f163          	bgeu	s3,s5,80003564 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    80003526:	00a4d59b          	srlw	a1,s1,0xa
    8000352a:	855a                	mv	a0,s6
    8000352c:	98dff0ef          	jal	80002eb8 <bmap>
    80003530:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003534:	c985                	beqz	a1,80003564 <readi+0xba>
    bp = bread(ip->dev, addr);
    80003536:	000b2503          	lw	a0,0(s6)
    8000353a:	e0cff0ef          	jal	80002b46 <bread>
    8000353e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003540:	3ff4f713          	and	a4,s1,1023
    80003544:	40ec87bb          	subw	a5,s9,a4
    80003548:	413a86bb          	subw	a3,s5,s3
    8000354c:	8d3e                	mv	s10,a5
    8000354e:	2781                	sext.w	a5,a5
    80003550:	0006861b          	sext.w	a2,a3
    80003554:	faf671e3          	bgeu	a2,a5,800034f6 <readi+0x4c>
    80003558:	8d36                	mv	s10,a3
    8000355a:	bf71                	j	800034f6 <readi+0x4c>
      brelse(bp);
    8000355c:	854a                	mv	a0,s2
    8000355e:	ef0ff0ef          	jal	80002c4e <brelse>
      tot = -1;
    80003562:	59fd                	li	s3,-1
  }
  return tot;
    80003564:	0009851b          	sext.w	a0,s3
}
    80003568:	70a6                	ld	ra,104(sp)
    8000356a:	7406                	ld	s0,96(sp)
    8000356c:	64e6                	ld	s1,88(sp)
    8000356e:	6946                	ld	s2,80(sp)
    80003570:	69a6                	ld	s3,72(sp)
    80003572:	6a06                	ld	s4,64(sp)
    80003574:	7ae2                	ld	s5,56(sp)
    80003576:	7b42                	ld	s6,48(sp)
    80003578:	7ba2                	ld	s7,40(sp)
    8000357a:	7c02                	ld	s8,32(sp)
    8000357c:	6ce2                	ld	s9,24(sp)
    8000357e:	6d42                	ld	s10,16(sp)
    80003580:	6da2                	ld	s11,8(sp)
    80003582:	6165                	add	sp,sp,112
    80003584:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003586:	89d6                	mv	s3,s5
    80003588:	bff1                	j	80003564 <readi+0xba>
    return 0;
    8000358a:	4501                	li	a0,0
}
    8000358c:	8082                	ret

000000008000358e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000358e:	457c                	lw	a5,76(a0)
    80003590:	0ed7ea63          	bltu	a5,a3,80003684 <writei+0xf6>
{
    80003594:	7159                	add	sp,sp,-112
    80003596:	f486                	sd	ra,104(sp)
    80003598:	f0a2                	sd	s0,96(sp)
    8000359a:	eca6                	sd	s1,88(sp)
    8000359c:	e8ca                	sd	s2,80(sp)
    8000359e:	e4ce                	sd	s3,72(sp)
    800035a0:	e0d2                	sd	s4,64(sp)
    800035a2:	fc56                	sd	s5,56(sp)
    800035a4:	f85a                	sd	s6,48(sp)
    800035a6:	f45e                	sd	s7,40(sp)
    800035a8:	f062                	sd	s8,32(sp)
    800035aa:	ec66                	sd	s9,24(sp)
    800035ac:	e86a                	sd	s10,16(sp)
    800035ae:	e46e                	sd	s11,8(sp)
    800035b0:	1880                	add	s0,sp,112
    800035b2:	8aaa                	mv	s5,a0
    800035b4:	8bae                	mv	s7,a1
    800035b6:	8a32                	mv	s4,a2
    800035b8:	8936                	mv	s2,a3
    800035ba:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800035bc:	00e687bb          	addw	a5,a3,a4
    800035c0:	0cd7e463          	bltu	a5,a3,80003688 <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800035c4:	00043737          	lui	a4,0x43
    800035c8:	0cf76263          	bltu	a4,a5,8000368c <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800035cc:	0a0b0a63          	beqz	s6,80003680 <writei+0xf2>
    800035d0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800035d2:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800035d6:	5c7d                	li	s8,-1
    800035d8:	a825                	j	80003610 <writei+0x82>
    800035da:	020d1d93          	sll	s11,s10,0x20
    800035de:	020ddd93          	srl	s11,s11,0x20
    800035e2:	05848513          	add	a0,s1,88
    800035e6:	86ee                	mv	a3,s11
    800035e8:	8652                	mv	a2,s4
    800035ea:	85de                	mv	a1,s7
    800035ec:	953a                	add	a0,a0,a4
    800035ee:	bd7fe0ef          	jal	800021c4 <either_copyin>
    800035f2:	05850a63          	beq	a0,s8,80003646 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800035f6:	8526                	mv	a0,s1
    800035f8:	64e000ef          	jal	80003c46 <log_write>
    brelse(bp);
    800035fc:	8526                	mv	a0,s1
    800035fe:	e50ff0ef          	jal	80002c4e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003602:	013d09bb          	addw	s3,s10,s3
    80003606:	012d093b          	addw	s2,s10,s2
    8000360a:	9a6e                	add	s4,s4,s11
    8000360c:	0569f063          	bgeu	s3,s6,8000364c <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003610:	00a9559b          	srlw	a1,s2,0xa
    80003614:	8556                	mv	a0,s5
    80003616:	8a3ff0ef          	jal	80002eb8 <bmap>
    8000361a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000361e:	c59d                	beqz	a1,8000364c <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003620:	000aa503          	lw	a0,0(s5)
    80003624:	d22ff0ef          	jal	80002b46 <bread>
    80003628:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000362a:	3ff97713          	and	a4,s2,1023
    8000362e:	40ec87bb          	subw	a5,s9,a4
    80003632:	413b06bb          	subw	a3,s6,s3
    80003636:	8d3e                	mv	s10,a5
    80003638:	2781                	sext.w	a5,a5
    8000363a:	0006861b          	sext.w	a2,a3
    8000363e:	f8f67ee3          	bgeu	a2,a5,800035da <writei+0x4c>
    80003642:	8d36                	mv	s10,a3
    80003644:	bf59                	j	800035da <writei+0x4c>
      brelse(bp);
    80003646:	8526                	mv	a0,s1
    80003648:	e06ff0ef          	jal	80002c4e <brelse>
  }

  if(off > ip->size)
    8000364c:	04caa783          	lw	a5,76(s5)
    80003650:	0127f463          	bgeu	a5,s2,80003658 <writei+0xca>
    ip->size = off;
    80003654:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003658:	8556                	mv	a0,s5
    8000365a:	b4dff0ef          	jal	800031a6 <iupdate>

  return tot;
    8000365e:	0009851b          	sext.w	a0,s3
}
    80003662:	70a6                	ld	ra,104(sp)
    80003664:	7406                	ld	s0,96(sp)
    80003666:	64e6                	ld	s1,88(sp)
    80003668:	6946                	ld	s2,80(sp)
    8000366a:	69a6                	ld	s3,72(sp)
    8000366c:	6a06                	ld	s4,64(sp)
    8000366e:	7ae2                	ld	s5,56(sp)
    80003670:	7b42                	ld	s6,48(sp)
    80003672:	7ba2                	ld	s7,40(sp)
    80003674:	7c02                	ld	s8,32(sp)
    80003676:	6ce2                	ld	s9,24(sp)
    80003678:	6d42                	ld	s10,16(sp)
    8000367a:	6da2                	ld	s11,8(sp)
    8000367c:	6165                	add	sp,sp,112
    8000367e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003680:	89da                	mv	s3,s6
    80003682:	bfd9                	j	80003658 <writei+0xca>
    return -1;
    80003684:	557d                	li	a0,-1
}
    80003686:	8082                	ret
    return -1;
    80003688:	557d                	li	a0,-1
    8000368a:	bfe1                	j	80003662 <writei+0xd4>
    return -1;
    8000368c:	557d                	li	a0,-1
    8000368e:	bfd1                	j	80003662 <writei+0xd4>

0000000080003690 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003690:	1141                	add	sp,sp,-16
    80003692:	e406                	sd	ra,8(sp)
    80003694:	e022                	sd	s0,0(sp)
    80003696:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003698:	4639                	li	a2,14
    8000369a:	ea6fd0ef          	jal	80000d40 <strncmp>
}
    8000369e:	60a2                	ld	ra,8(sp)
    800036a0:	6402                	ld	s0,0(sp)
    800036a2:	0141                	add	sp,sp,16
    800036a4:	8082                	ret

00000000800036a6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800036a6:	7139                	add	sp,sp,-64
    800036a8:	fc06                	sd	ra,56(sp)
    800036aa:	f822                	sd	s0,48(sp)
    800036ac:	f426                	sd	s1,40(sp)
    800036ae:	f04a                	sd	s2,32(sp)
    800036b0:	ec4e                	sd	s3,24(sp)
    800036b2:	e852                	sd	s4,16(sp)
    800036b4:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800036b6:	04451703          	lh	a4,68(a0)
    800036ba:	4785                	li	a5,1
    800036bc:	00f71a63          	bne	a4,a5,800036d0 <dirlookup+0x2a>
    800036c0:	892a                	mv	s2,a0
    800036c2:	89ae                	mv	s3,a1
    800036c4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800036c6:	457c                	lw	a5,76(a0)
    800036c8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800036ca:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800036cc:	e39d                	bnez	a5,800036f2 <dirlookup+0x4c>
    800036ce:	a095                	j	80003732 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800036d0:	00004517          	auipc	a0,0x4
    800036d4:	f8050513          	add	a0,a0,-128 # 80007650 <syscalls+0x1c0>
    800036d8:	886fd0ef          	jal	8000075e <panic>
      panic("dirlookup read");
    800036dc:	00004517          	auipc	a0,0x4
    800036e0:	f8c50513          	add	a0,a0,-116 # 80007668 <syscalls+0x1d8>
    800036e4:	87afd0ef          	jal	8000075e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800036e8:	24c1                	addw	s1,s1,16
    800036ea:	04c92783          	lw	a5,76(s2)
    800036ee:	04f4f163          	bgeu	s1,a5,80003730 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800036f2:	4741                	li	a4,16
    800036f4:	86a6                	mv	a3,s1
    800036f6:	fc040613          	add	a2,s0,-64
    800036fa:	4581                	li	a1,0
    800036fc:	854a                	mv	a0,s2
    800036fe:	dadff0ef          	jal	800034aa <readi>
    80003702:	47c1                	li	a5,16
    80003704:	fcf51ce3          	bne	a0,a5,800036dc <dirlookup+0x36>
    if(de.inum == 0)
    80003708:	fc045783          	lhu	a5,-64(s0)
    8000370c:	dff1                	beqz	a5,800036e8 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    8000370e:	fc240593          	add	a1,s0,-62
    80003712:	854e                	mv	a0,s3
    80003714:	f7dff0ef          	jal	80003690 <namecmp>
    80003718:	f961                	bnez	a0,800036e8 <dirlookup+0x42>
      if(poff)
    8000371a:	000a0463          	beqz	s4,80003722 <dirlookup+0x7c>
        *poff = off;
    8000371e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003722:	fc045583          	lhu	a1,-64(s0)
    80003726:	00092503          	lw	a0,0(s2)
    8000372a:	85dff0ef          	jal	80002f86 <iget>
    8000372e:	a011                	j	80003732 <dirlookup+0x8c>
  return 0;
    80003730:	4501                	li	a0,0
}
    80003732:	70e2                	ld	ra,56(sp)
    80003734:	7442                	ld	s0,48(sp)
    80003736:	74a2                	ld	s1,40(sp)
    80003738:	7902                	ld	s2,32(sp)
    8000373a:	69e2                	ld	s3,24(sp)
    8000373c:	6a42                	ld	s4,16(sp)
    8000373e:	6121                	add	sp,sp,64
    80003740:	8082                	ret

0000000080003742 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003742:	711d                	add	sp,sp,-96
    80003744:	ec86                	sd	ra,88(sp)
    80003746:	e8a2                	sd	s0,80(sp)
    80003748:	e4a6                	sd	s1,72(sp)
    8000374a:	e0ca                	sd	s2,64(sp)
    8000374c:	fc4e                	sd	s3,56(sp)
    8000374e:	f852                	sd	s4,48(sp)
    80003750:	f456                	sd	s5,40(sp)
    80003752:	f05a                	sd	s6,32(sp)
    80003754:	ec5e                	sd	s7,24(sp)
    80003756:	e862                	sd	s8,16(sp)
    80003758:	e466                	sd	s9,8(sp)
    8000375a:	1080                	add	s0,sp,96
    8000375c:	84aa                	mv	s1,a0
    8000375e:	8b2e                	mv	s6,a1
    80003760:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003762:	00054703          	lbu	a4,0(a0)
    80003766:	02f00793          	li	a5,47
    8000376a:	00f70e63          	beq	a4,a5,80003786 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000376e:	8c2fe0ef          	jal	80001830 <myproc>
    80003772:	15053503          	ld	a0,336(a0)
    80003776:	aafff0ef          	jal	80003224 <idup>
    8000377a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000377c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003780:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003782:	4b85                	li	s7,1
    80003784:	a871                	j	80003820 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003786:	4585                	li	a1,1
    80003788:	4505                	li	a0,1
    8000378a:	ffcff0ef          	jal	80002f86 <iget>
    8000378e:	8a2a                	mv	s4,a0
    80003790:	b7f5                	j	8000377c <namex+0x3a>
      iunlockput(ip);
    80003792:	8552                	mv	a0,s4
    80003794:	ccdff0ef          	jal	80003460 <iunlockput>
      return 0;
    80003798:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000379a:	8552                	mv	a0,s4
    8000379c:	60e6                	ld	ra,88(sp)
    8000379e:	6446                	ld	s0,80(sp)
    800037a0:	64a6                	ld	s1,72(sp)
    800037a2:	6906                	ld	s2,64(sp)
    800037a4:	79e2                	ld	s3,56(sp)
    800037a6:	7a42                	ld	s4,48(sp)
    800037a8:	7aa2                	ld	s5,40(sp)
    800037aa:	7b02                	ld	s6,32(sp)
    800037ac:	6be2                	ld	s7,24(sp)
    800037ae:	6c42                	ld	s8,16(sp)
    800037b0:	6ca2                	ld	s9,8(sp)
    800037b2:	6125                	add	sp,sp,96
    800037b4:	8082                	ret
      iunlock(ip);
    800037b6:	8552                	mv	a0,s4
    800037b8:	b4dff0ef          	jal	80003304 <iunlock>
      return ip;
    800037bc:	bff9                	j	8000379a <namex+0x58>
      iunlockput(ip);
    800037be:	8552                	mv	a0,s4
    800037c0:	ca1ff0ef          	jal	80003460 <iunlockput>
      return 0;
    800037c4:	8a4e                	mv	s4,s3
    800037c6:	bfd1                	j	8000379a <namex+0x58>
  len = path - s;
    800037c8:	40998633          	sub	a2,s3,s1
    800037cc:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800037d0:	099c5063          	bge	s8,s9,80003850 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    800037d4:	4639                	li	a2,14
    800037d6:	85a6                	mv	a1,s1
    800037d8:	8556                	mv	a0,s5
    800037da:	cf6fd0ef          	jal	80000cd0 <memmove>
    800037de:	84ce                	mv	s1,s3
  while(*path == '/')
    800037e0:	0004c783          	lbu	a5,0(s1)
    800037e4:	01279763          	bne	a5,s2,800037f2 <namex+0xb0>
    path++;
    800037e8:	0485                	add	s1,s1,1
  while(*path == '/')
    800037ea:	0004c783          	lbu	a5,0(s1)
    800037ee:	ff278de3          	beq	a5,s2,800037e8 <namex+0xa6>
    ilock(ip);
    800037f2:	8552                	mv	a0,s4
    800037f4:	a67ff0ef          	jal	8000325a <ilock>
    if(ip->type != T_DIR){
    800037f8:	044a1783          	lh	a5,68(s4)
    800037fc:	f9779be3          	bne	a5,s7,80003792 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003800:	000b0563          	beqz	s6,8000380a <namex+0xc8>
    80003804:	0004c783          	lbu	a5,0(s1)
    80003808:	d7dd                	beqz	a5,800037b6 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000380a:	4601                	li	a2,0
    8000380c:	85d6                	mv	a1,s5
    8000380e:	8552                	mv	a0,s4
    80003810:	e97ff0ef          	jal	800036a6 <dirlookup>
    80003814:	89aa                	mv	s3,a0
    80003816:	d545                	beqz	a0,800037be <namex+0x7c>
    iunlockput(ip);
    80003818:	8552                	mv	a0,s4
    8000381a:	c47ff0ef          	jal	80003460 <iunlockput>
    ip = next;
    8000381e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003820:	0004c783          	lbu	a5,0(s1)
    80003824:	01279763          	bne	a5,s2,80003832 <namex+0xf0>
    path++;
    80003828:	0485                	add	s1,s1,1
  while(*path == '/')
    8000382a:	0004c783          	lbu	a5,0(s1)
    8000382e:	ff278de3          	beq	a5,s2,80003828 <namex+0xe6>
  if(*path == 0)
    80003832:	cb8d                	beqz	a5,80003864 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003834:	0004c783          	lbu	a5,0(s1)
    80003838:	89a6                	mv	s3,s1
  len = path - s;
    8000383a:	4c81                	li	s9,0
    8000383c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000383e:	01278963          	beq	a5,s2,80003850 <namex+0x10e>
    80003842:	d3d9                	beqz	a5,800037c8 <namex+0x86>
    path++;
    80003844:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003846:	0009c783          	lbu	a5,0(s3)
    8000384a:	ff279ce3          	bne	a5,s2,80003842 <namex+0x100>
    8000384e:	bfad                	j	800037c8 <namex+0x86>
    memmove(name, s, len);
    80003850:	2601                	sext.w	a2,a2
    80003852:	85a6                	mv	a1,s1
    80003854:	8556                	mv	a0,s5
    80003856:	c7afd0ef          	jal	80000cd0 <memmove>
    name[len] = 0;
    8000385a:	9cd6                	add	s9,s9,s5
    8000385c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003860:	84ce                	mv	s1,s3
    80003862:	bfbd                	j	800037e0 <namex+0x9e>
  if(nameiparent){
    80003864:	f20b0be3          	beqz	s6,8000379a <namex+0x58>
    iput(ip);
    80003868:	8552                	mv	a0,s4
    8000386a:	b6fff0ef          	jal	800033d8 <iput>
    return 0;
    8000386e:	4a01                	li	s4,0
    80003870:	b72d                	j	8000379a <namex+0x58>

0000000080003872 <dirlink>:
{
    80003872:	7139                	add	sp,sp,-64
    80003874:	fc06                	sd	ra,56(sp)
    80003876:	f822                	sd	s0,48(sp)
    80003878:	f426                	sd	s1,40(sp)
    8000387a:	f04a                	sd	s2,32(sp)
    8000387c:	ec4e                	sd	s3,24(sp)
    8000387e:	e852                	sd	s4,16(sp)
    80003880:	0080                	add	s0,sp,64
    80003882:	892a                	mv	s2,a0
    80003884:	8a2e                	mv	s4,a1
    80003886:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003888:	4601                	li	a2,0
    8000388a:	e1dff0ef          	jal	800036a6 <dirlookup>
    8000388e:	e52d                	bnez	a0,800038f8 <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003890:	04c92483          	lw	s1,76(s2)
    80003894:	c48d                	beqz	s1,800038be <dirlink+0x4c>
    80003896:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003898:	4741                	li	a4,16
    8000389a:	86a6                	mv	a3,s1
    8000389c:	fc040613          	add	a2,s0,-64
    800038a0:	4581                	li	a1,0
    800038a2:	854a                	mv	a0,s2
    800038a4:	c07ff0ef          	jal	800034aa <readi>
    800038a8:	47c1                	li	a5,16
    800038aa:	04f51b63          	bne	a0,a5,80003900 <dirlink+0x8e>
    if(de.inum == 0)
    800038ae:	fc045783          	lhu	a5,-64(s0)
    800038b2:	c791                	beqz	a5,800038be <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038b4:	24c1                	addw	s1,s1,16
    800038b6:	04c92783          	lw	a5,76(s2)
    800038ba:	fcf4efe3          	bltu	s1,a5,80003898 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800038be:	4639                	li	a2,14
    800038c0:	85d2                	mv	a1,s4
    800038c2:	fc240513          	add	a0,s0,-62
    800038c6:	cb6fd0ef          	jal	80000d7c <strncpy>
  de.inum = inum;
    800038ca:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800038ce:	4741                	li	a4,16
    800038d0:	86a6                	mv	a3,s1
    800038d2:	fc040613          	add	a2,s0,-64
    800038d6:	4581                	li	a1,0
    800038d8:	854a                	mv	a0,s2
    800038da:	cb5ff0ef          	jal	8000358e <writei>
    800038de:	1541                	add	a0,a0,-16
    800038e0:	00a03533          	snez	a0,a0
    800038e4:	40a00533          	neg	a0,a0
}
    800038e8:	70e2                	ld	ra,56(sp)
    800038ea:	7442                	ld	s0,48(sp)
    800038ec:	74a2                	ld	s1,40(sp)
    800038ee:	7902                	ld	s2,32(sp)
    800038f0:	69e2                	ld	s3,24(sp)
    800038f2:	6a42                	ld	s4,16(sp)
    800038f4:	6121                	add	sp,sp,64
    800038f6:	8082                	ret
    iput(ip);
    800038f8:	ae1ff0ef          	jal	800033d8 <iput>
    return -1;
    800038fc:	557d                	li	a0,-1
    800038fe:	b7ed                	j	800038e8 <dirlink+0x76>
      panic("dirlink read");
    80003900:	00004517          	auipc	a0,0x4
    80003904:	d7850513          	add	a0,a0,-648 # 80007678 <syscalls+0x1e8>
    80003908:	e57fc0ef          	jal	8000075e <panic>

000000008000390c <namei>:

struct inode*
namei(char *path)
{
    8000390c:	1101                	add	sp,sp,-32
    8000390e:	ec06                	sd	ra,24(sp)
    80003910:	e822                	sd	s0,16(sp)
    80003912:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003914:	fe040613          	add	a2,s0,-32
    80003918:	4581                	li	a1,0
    8000391a:	e29ff0ef          	jal	80003742 <namex>
}
    8000391e:	60e2                	ld	ra,24(sp)
    80003920:	6442                	ld	s0,16(sp)
    80003922:	6105                	add	sp,sp,32
    80003924:	8082                	ret

0000000080003926 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003926:	1141                	add	sp,sp,-16
    80003928:	e406                	sd	ra,8(sp)
    8000392a:	e022                	sd	s0,0(sp)
    8000392c:	0800                	add	s0,sp,16
    8000392e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003930:	4585                	li	a1,1
    80003932:	e11ff0ef          	jal	80003742 <namex>
}
    80003936:	60a2                	ld	ra,8(sp)
    80003938:	6402                	ld	s0,0(sp)
    8000393a:	0141                	add	sp,sp,16
    8000393c:	8082                	ret

000000008000393e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000393e:	1101                	add	sp,sp,-32
    80003940:	ec06                	sd	ra,24(sp)
    80003942:	e822                	sd	s0,16(sp)
    80003944:	e426                	sd	s1,8(sp)
    80003946:	e04a                	sd	s2,0(sp)
    80003948:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000394a:	0001c917          	auipc	s2,0x1c
    8000394e:	4f690913          	add	s2,s2,1270 # 8001fe40 <log>
    80003952:	01892583          	lw	a1,24(s2)
    80003956:	02892503          	lw	a0,40(s2)
    8000395a:	9ecff0ef          	jal	80002b46 <bread>
    8000395e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003960:	02c92603          	lw	a2,44(s2)
    80003964:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003966:	00c05f63          	blez	a2,80003984 <write_head+0x46>
    8000396a:	0001c717          	auipc	a4,0x1c
    8000396e:	50670713          	add	a4,a4,1286 # 8001fe70 <log+0x30>
    80003972:	87aa                	mv	a5,a0
    80003974:	060a                	sll	a2,a2,0x2
    80003976:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003978:	4314                	lw	a3,0(a4)
    8000397a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000397c:	0711                	add	a4,a4,4
    8000397e:	0791                	add	a5,a5,4
    80003980:	fec79ce3          	bne	a5,a2,80003978 <write_head+0x3a>
  }
  bwrite(buf);
    80003984:	8526                	mv	a0,s1
    80003986:	a96ff0ef          	jal	80002c1c <bwrite>
  brelse(buf);
    8000398a:	8526                	mv	a0,s1
    8000398c:	ac2ff0ef          	jal	80002c4e <brelse>
}
    80003990:	60e2                	ld	ra,24(sp)
    80003992:	6442                	ld	s0,16(sp)
    80003994:	64a2                	ld	s1,8(sp)
    80003996:	6902                	ld	s2,0(sp)
    80003998:	6105                	add	sp,sp,32
    8000399a:	8082                	ret

000000008000399c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000399c:	0001c797          	auipc	a5,0x1c
    800039a0:	4d07a783          	lw	a5,1232(a5) # 8001fe6c <log+0x2c>
    800039a4:	08f05f63          	blez	a5,80003a42 <install_trans+0xa6>
{
    800039a8:	7139                	add	sp,sp,-64
    800039aa:	fc06                	sd	ra,56(sp)
    800039ac:	f822                	sd	s0,48(sp)
    800039ae:	f426                	sd	s1,40(sp)
    800039b0:	f04a                	sd	s2,32(sp)
    800039b2:	ec4e                	sd	s3,24(sp)
    800039b4:	e852                	sd	s4,16(sp)
    800039b6:	e456                	sd	s5,8(sp)
    800039b8:	e05a                	sd	s6,0(sp)
    800039ba:	0080                	add	s0,sp,64
    800039bc:	8b2a                	mv	s6,a0
    800039be:	0001ca97          	auipc	s5,0x1c
    800039c2:	4b2a8a93          	add	s5,s5,1202 # 8001fe70 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039c6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800039c8:	0001c997          	auipc	s3,0x1c
    800039cc:	47898993          	add	s3,s3,1144 # 8001fe40 <log>
    800039d0:	a829                	j	800039ea <install_trans+0x4e>
    brelse(lbuf);
    800039d2:	854a                	mv	a0,s2
    800039d4:	a7aff0ef          	jal	80002c4e <brelse>
    brelse(dbuf);
    800039d8:	8526                	mv	a0,s1
    800039da:	a74ff0ef          	jal	80002c4e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039de:	2a05                	addw	s4,s4,1
    800039e0:	0a91                	add	s5,s5,4
    800039e2:	02c9a783          	lw	a5,44(s3)
    800039e6:	04fa5463          	bge	s4,a5,80003a2e <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800039ea:	0189a583          	lw	a1,24(s3)
    800039ee:	014585bb          	addw	a1,a1,s4
    800039f2:	2585                	addw	a1,a1,1
    800039f4:	0289a503          	lw	a0,40(s3)
    800039f8:	94eff0ef          	jal	80002b46 <bread>
    800039fc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800039fe:	000aa583          	lw	a1,0(s5)
    80003a02:	0289a503          	lw	a0,40(s3)
    80003a06:	940ff0ef          	jal	80002b46 <bread>
    80003a0a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003a0c:	40000613          	li	a2,1024
    80003a10:	05890593          	add	a1,s2,88
    80003a14:	05850513          	add	a0,a0,88
    80003a18:	ab8fd0ef          	jal	80000cd0 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003a1c:	8526                	mv	a0,s1
    80003a1e:	9feff0ef          	jal	80002c1c <bwrite>
    if(recovering == 0)
    80003a22:	fa0b18e3          	bnez	s6,800039d2 <install_trans+0x36>
      bunpin(dbuf);
    80003a26:	8526                	mv	a0,s1
    80003a28:	ae2ff0ef          	jal	80002d0a <bunpin>
    80003a2c:	b75d                	j	800039d2 <install_trans+0x36>
}
    80003a2e:	70e2                	ld	ra,56(sp)
    80003a30:	7442                	ld	s0,48(sp)
    80003a32:	74a2                	ld	s1,40(sp)
    80003a34:	7902                	ld	s2,32(sp)
    80003a36:	69e2                	ld	s3,24(sp)
    80003a38:	6a42                	ld	s4,16(sp)
    80003a3a:	6aa2                	ld	s5,8(sp)
    80003a3c:	6b02                	ld	s6,0(sp)
    80003a3e:	6121                	add	sp,sp,64
    80003a40:	8082                	ret
    80003a42:	8082                	ret

0000000080003a44 <initlog>:
{
    80003a44:	7179                	add	sp,sp,-48
    80003a46:	f406                	sd	ra,40(sp)
    80003a48:	f022                	sd	s0,32(sp)
    80003a4a:	ec26                	sd	s1,24(sp)
    80003a4c:	e84a                	sd	s2,16(sp)
    80003a4e:	e44e                	sd	s3,8(sp)
    80003a50:	1800                	add	s0,sp,48
    80003a52:	892a                	mv	s2,a0
    80003a54:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003a56:	0001c497          	auipc	s1,0x1c
    80003a5a:	3ea48493          	add	s1,s1,1002 # 8001fe40 <log>
    80003a5e:	00004597          	auipc	a1,0x4
    80003a62:	c2a58593          	add	a1,a1,-982 # 80007688 <syscalls+0x1f8>
    80003a66:	8526                	mv	a0,s1
    80003a68:	8b8fd0ef          	jal	80000b20 <initlock>
  log.start = sb->logstart;
    80003a6c:	0149a583          	lw	a1,20(s3)
    80003a70:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003a72:	0109a783          	lw	a5,16(s3)
    80003a76:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003a78:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003a7c:	854a                	mv	a0,s2
    80003a7e:	8c8ff0ef          	jal	80002b46 <bread>
  log.lh.n = lh->n;
    80003a82:	4d30                	lw	a2,88(a0)
    80003a84:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003a86:	00c05f63          	blez	a2,80003aa4 <initlog+0x60>
    80003a8a:	87aa                	mv	a5,a0
    80003a8c:	0001c717          	auipc	a4,0x1c
    80003a90:	3e470713          	add	a4,a4,996 # 8001fe70 <log+0x30>
    80003a94:	060a                	sll	a2,a2,0x2
    80003a96:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003a98:	4ff4                	lw	a3,92(a5)
    80003a9a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003a9c:	0791                	add	a5,a5,4
    80003a9e:	0711                	add	a4,a4,4
    80003aa0:	fec79ce3          	bne	a5,a2,80003a98 <initlog+0x54>
  brelse(buf);
    80003aa4:	9aaff0ef          	jal	80002c4e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003aa8:	4505                	li	a0,1
    80003aaa:	ef3ff0ef          	jal	8000399c <install_trans>
  log.lh.n = 0;
    80003aae:	0001c797          	auipc	a5,0x1c
    80003ab2:	3a07af23          	sw	zero,958(a5) # 8001fe6c <log+0x2c>
  write_head(); // clear the log
    80003ab6:	e89ff0ef          	jal	8000393e <write_head>
}
    80003aba:	70a2                	ld	ra,40(sp)
    80003abc:	7402                	ld	s0,32(sp)
    80003abe:	64e2                	ld	s1,24(sp)
    80003ac0:	6942                	ld	s2,16(sp)
    80003ac2:	69a2                	ld	s3,8(sp)
    80003ac4:	6145                	add	sp,sp,48
    80003ac6:	8082                	ret

0000000080003ac8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003ac8:	1101                	add	sp,sp,-32
    80003aca:	ec06                	sd	ra,24(sp)
    80003acc:	e822                	sd	s0,16(sp)
    80003ace:	e426                	sd	s1,8(sp)
    80003ad0:	e04a                	sd	s2,0(sp)
    80003ad2:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80003ad4:	0001c517          	auipc	a0,0x1c
    80003ad8:	36c50513          	add	a0,a0,876 # 8001fe40 <log>
    80003adc:	8c4fd0ef          	jal	80000ba0 <acquire>
  while(1){
    if(log.committing){
    80003ae0:	0001c497          	auipc	s1,0x1c
    80003ae4:	36048493          	add	s1,s1,864 # 8001fe40 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ae8:	4979                	li	s2,30
    80003aea:	a029                	j	80003af4 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003aec:	85a6                	mv	a1,s1
    80003aee:	8526                	mv	a0,s1
    80003af0:	b2efe0ef          	jal	80001e1e <sleep>
    if(log.committing){
    80003af4:	50dc                	lw	a5,36(s1)
    80003af6:	fbfd                	bnez	a5,80003aec <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003af8:	5098                	lw	a4,32(s1)
    80003afa:	2705                	addw	a4,a4,1
    80003afc:	0027179b          	sllw	a5,a4,0x2
    80003b00:	9fb9                	addw	a5,a5,a4
    80003b02:	0017979b          	sllw	a5,a5,0x1
    80003b06:	54d4                	lw	a3,44(s1)
    80003b08:	9fb5                	addw	a5,a5,a3
    80003b0a:	00f95763          	bge	s2,a5,80003b18 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003b0e:	85a6                	mv	a1,s1
    80003b10:	8526                	mv	a0,s1
    80003b12:	b0cfe0ef          	jal	80001e1e <sleep>
    80003b16:	bff9                	j	80003af4 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003b18:	0001c517          	auipc	a0,0x1c
    80003b1c:	32850513          	add	a0,a0,808 # 8001fe40 <log>
    80003b20:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003b22:	916fd0ef          	jal	80000c38 <release>
      break;
    }
  }
}
    80003b26:	60e2                	ld	ra,24(sp)
    80003b28:	6442                	ld	s0,16(sp)
    80003b2a:	64a2                	ld	s1,8(sp)
    80003b2c:	6902                	ld	s2,0(sp)
    80003b2e:	6105                	add	sp,sp,32
    80003b30:	8082                	ret

0000000080003b32 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003b32:	7139                	add	sp,sp,-64
    80003b34:	fc06                	sd	ra,56(sp)
    80003b36:	f822                	sd	s0,48(sp)
    80003b38:	f426                	sd	s1,40(sp)
    80003b3a:	f04a                	sd	s2,32(sp)
    80003b3c:	ec4e                	sd	s3,24(sp)
    80003b3e:	e852                	sd	s4,16(sp)
    80003b40:	e456                	sd	s5,8(sp)
    80003b42:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003b44:	0001c497          	auipc	s1,0x1c
    80003b48:	2fc48493          	add	s1,s1,764 # 8001fe40 <log>
    80003b4c:	8526                	mv	a0,s1
    80003b4e:	852fd0ef          	jal	80000ba0 <acquire>
  log.outstanding -= 1;
    80003b52:	509c                	lw	a5,32(s1)
    80003b54:	37fd                	addw	a5,a5,-1
    80003b56:	0007891b          	sext.w	s2,a5
    80003b5a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003b5c:	50dc                	lw	a5,36(s1)
    80003b5e:	ef9d                	bnez	a5,80003b9c <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003b60:	04091463          	bnez	s2,80003ba8 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003b64:	0001c497          	auipc	s1,0x1c
    80003b68:	2dc48493          	add	s1,s1,732 # 8001fe40 <log>
    80003b6c:	4785                	li	a5,1
    80003b6e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003b70:	8526                	mv	a0,s1
    80003b72:	8c6fd0ef          	jal	80000c38 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003b76:	54dc                	lw	a5,44(s1)
    80003b78:	04f04b63          	bgtz	a5,80003bce <end_op+0x9c>
    acquire(&log.lock);
    80003b7c:	0001c497          	auipc	s1,0x1c
    80003b80:	2c448493          	add	s1,s1,708 # 8001fe40 <log>
    80003b84:	8526                	mv	a0,s1
    80003b86:	81afd0ef          	jal	80000ba0 <acquire>
    log.committing = 0;
    80003b8a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003b8e:	8526                	mv	a0,s1
    80003b90:	adafe0ef          	jal	80001e6a <wakeup>
    release(&log.lock);
    80003b94:	8526                	mv	a0,s1
    80003b96:	8a2fd0ef          	jal	80000c38 <release>
}
    80003b9a:	a00d                	j	80003bbc <end_op+0x8a>
    panic("log.committing");
    80003b9c:	00004517          	auipc	a0,0x4
    80003ba0:	af450513          	add	a0,a0,-1292 # 80007690 <syscalls+0x200>
    80003ba4:	bbbfc0ef          	jal	8000075e <panic>
    wakeup(&log);
    80003ba8:	0001c497          	auipc	s1,0x1c
    80003bac:	29848493          	add	s1,s1,664 # 8001fe40 <log>
    80003bb0:	8526                	mv	a0,s1
    80003bb2:	ab8fe0ef          	jal	80001e6a <wakeup>
  release(&log.lock);
    80003bb6:	8526                	mv	a0,s1
    80003bb8:	880fd0ef          	jal	80000c38 <release>
}
    80003bbc:	70e2                	ld	ra,56(sp)
    80003bbe:	7442                	ld	s0,48(sp)
    80003bc0:	74a2                	ld	s1,40(sp)
    80003bc2:	7902                	ld	s2,32(sp)
    80003bc4:	69e2                	ld	s3,24(sp)
    80003bc6:	6a42                	ld	s4,16(sp)
    80003bc8:	6aa2                	ld	s5,8(sp)
    80003bca:	6121                	add	sp,sp,64
    80003bcc:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bce:	0001ca97          	auipc	s5,0x1c
    80003bd2:	2a2a8a93          	add	s5,s5,674 # 8001fe70 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003bd6:	0001ca17          	auipc	s4,0x1c
    80003bda:	26aa0a13          	add	s4,s4,618 # 8001fe40 <log>
    80003bde:	018a2583          	lw	a1,24(s4)
    80003be2:	012585bb          	addw	a1,a1,s2
    80003be6:	2585                	addw	a1,a1,1
    80003be8:	028a2503          	lw	a0,40(s4)
    80003bec:	f5bfe0ef          	jal	80002b46 <bread>
    80003bf0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003bf2:	000aa583          	lw	a1,0(s5)
    80003bf6:	028a2503          	lw	a0,40(s4)
    80003bfa:	f4dfe0ef          	jal	80002b46 <bread>
    80003bfe:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003c00:	40000613          	li	a2,1024
    80003c04:	05850593          	add	a1,a0,88
    80003c08:	05848513          	add	a0,s1,88
    80003c0c:	8c4fd0ef          	jal	80000cd0 <memmove>
    bwrite(to);  // write the log
    80003c10:	8526                	mv	a0,s1
    80003c12:	80aff0ef          	jal	80002c1c <bwrite>
    brelse(from);
    80003c16:	854e                	mv	a0,s3
    80003c18:	836ff0ef          	jal	80002c4e <brelse>
    brelse(to);
    80003c1c:	8526                	mv	a0,s1
    80003c1e:	830ff0ef          	jal	80002c4e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c22:	2905                	addw	s2,s2,1
    80003c24:	0a91                	add	s5,s5,4
    80003c26:	02ca2783          	lw	a5,44(s4)
    80003c2a:	faf94ae3          	blt	s2,a5,80003bde <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003c2e:	d11ff0ef          	jal	8000393e <write_head>
    install_trans(0); // Now install writes to home locations
    80003c32:	4501                	li	a0,0
    80003c34:	d69ff0ef          	jal	8000399c <install_trans>
    log.lh.n = 0;
    80003c38:	0001c797          	auipc	a5,0x1c
    80003c3c:	2207aa23          	sw	zero,564(a5) # 8001fe6c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003c40:	cffff0ef          	jal	8000393e <write_head>
    80003c44:	bf25                	j	80003b7c <end_op+0x4a>

0000000080003c46 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003c46:	1101                	add	sp,sp,-32
    80003c48:	ec06                	sd	ra,24(sp)
    80003c4a:	e822                	sd	s0,16(sp)
    80003c4c:	e426                	sd	s1,8(sp)
    80003c4e:	e04a                	sd	s2,0(sp)
    80003c50:	1000                	add	s0,sp,32
    80003c52:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003c54:	0001c917          	auipc	s2,0x1c
    80003c58:	1ec90913          	add	s2,s2,492 # 8001fe40 <log>
    80003c5c:	854a                	mv	a0,s2
    80003c5e:	f43fc0ef          	jal	80000ba0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003c62:	02c92603          	lw	a2,44(s2)
    80003c66:	47f5                	li	a5,29
    80003c68:	06c7c363          	blt	a5,a2,80003cce <log_write+0x88>
    80003c6c:	0001c797          	auipc	a5,0x1c
    80003c70:	1f07a783          	lw	a5,496(a5) # 8001fe5c <log+0x1c>
    80003c74:	37fd                	addw	a5,a5,-1
    80003c76:	04f65c63          	bge	a2,a5,80003cce <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003c7a:	0001c797          	auipc	a5,0x1c
    80003c7e:	1e67a783          	lw	a5,486(a5) # 8001fe60 <log+0x20>
    80003c82:	04f05c63          	blez	a5,80003cda <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003c86:	4781                	li	a5,0
    80003c88:	04c05f63          	blez	a2,80003ce6 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003c8c:	44cc                	lw	a1,12(s1)
    80003c8e:	0001c717          	auipc	a4,0x1c
    80003c92:	1e270713          	add	a4,a4,482 # 8001fe70 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003c96:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003c98:	4314                	lw	a3,0(a4)
    80003c9a:	04b68663          	beq	a3,a1,80003ce6 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003c9e:	2785                	addw	a5,a5,1
    80003ca0:	0711                	add	a4,a4,4
    80003ca2:	fef61be3          	bne	a2,a5,80003c98 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003ca6:	0621                	add	a2,a2,8
    80003ca8:	060a                	sll	a2,a2,0x2
    80003caa:	0001c797          	auipc	a5,0x1c
    80003cae:	19678793          	add	a5,a5,406 # 8001fe40 <log>
    80003cb2:	97b2                	add	a5,a5,a2
    80003cb4:	44d8                	lw	a4,12(s1)
    80003cb6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003cb8:	8526                	mv	a0,s1
    80003cba:	81cff0ef          	jal	80002cd6 <bpin>
    log.lh.n++;
    80003cbe:	0001c717          	auipc	a4,0x1c
    80003cc2:	18270713          	add	a4,a4,386 # 8001fe40 <log>
    80003cc6:	575c                	lw	a5,44(a4)
    80003cc8:	2785                	addw	a5,a5,1
    80003cca:	d75c                	sw	a5,44(a4)
    80003ccc:	a80d                	j	80003cfe <log_write+0xb8>
    panic("too big a transaction");
    80003cce:	00004517          	auipc	a0,0x4
    80003cd2:	9d250513          	add	a0,a0,-1582 # 800076a0 <syscalls+0x210>
    80003cd6:	a89fc0ef          	jal	8000075e <panic>
    panic("log_write outside of trans");
    80003cda:	00004517          	auipc	a0,0x4
    80003cde:	9de50513          	add	a0,a0,-1570 # 800076b8 <syscalls+0x228>
    80003ce2:	a7dfc0ef          	jal	8000075e <panic>
  log.lh.block[i] = b->blockno;
    80003ce6:	00878693          	add	a3,a5,8
    80003cea:	068a                	sll	a3,a3,0x2
    80003cec:	0001c717          	auipc	a4,0x1c
    80003cf0:	15470713          	add	a4,a4,340 # 8001fe40 <log>
    80003cf4:	9736                	add	a4,a4,a3
    80003cf6:	44d4                	lw	a3,12(s1)
    80003cf8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003cfa:	faf60fe3          	beq	a2,a5,80003cb8 <log_write+0x72>
  }
  release(&log.lock);
    80003cfe:	0001c517          	auipc	a0,0x1c
    80003d02:	14250513          	add	a0,a0,322 # 8001fe40 <log>
    80003d06:	f33fc0ef          	jal	80000c38 <release>
}
    80003d0a:	60e2                	ld	ra,24(sp)
    80003d0c:	6442                	ld	s0,16(sp)
    80003d0e:	64a2                	ld	s1,8(sp)
    80003d10:	6902                	ld	s2,0(sp)
    80003d12:	6105                	add	sp,sp,32
    80003d14:	8082                	ret

0000000080003d16 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003d16:	1101                	add	sp,sp,-32
    80003d18:	ec06                	sd	ra,24(sp)
    80003d1a:	e822                	sd	s0,16(sp)
    80003d1c:	e426                	sd	s1,8(sp)
    80003d1e:	e04a                	sd	s2,0(sp)
    80003d20:	1000                	add	s0,sp,32
    80003d22:	84aa                	mv	s1,a0
    80003d24:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003d26:	00004597          	auipc	a1,0x4
    80003d2a:	9b258593          	add	a1,a1,-1614 # 800076d8 <syscalls+0x248>
    80003d2e:	0521                	add	a0,a0,8
    80003d30:	df1fc0ef          	jal	80000b20 <initlock>
  lk->name = name;
    80003d34:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003d38:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003d3c:	0204a423          	sw	zero,40(s1)
}
    80003d40:	60e2                	ld	ra,24(sp)
    80003d42:	6442                	ld	s0,16(sp)
    80003d44:	64a2                	ld	s1,8(sp)
    80003d46:	6902                	ld	s2,0(sp)
    80003d48:	6105                	add	sp,sp,32
    80003d4a:	8082                	ret

0000000080003d4c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003d4c:	1101                	add	sp,sp,-32
    80003d4e:	ec06                	sd	ra,24(sp)
    80003d50:	e822                	sd	s0,16(sp)
    80003d52:	e426                	sd	s1,8(sp)
    80003d54:	e04a                	sd	s2,0(sp)
    80003d56:	1000                	add	s0,sp,32
    80003d58:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003d5a:	00850913          	add	s2,a0,8
    80003d5e:	854a                	mv	a0,s2
    80003d60:	e41fc0ef          	jal	80000ba0 <acquire>
  while (lk->locked) {
    80003d64:	409c                	lw	a5,0(s1)
    80003d66:	c799                	beqz	a5,80003d74 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003d68:	85ca                	mv	a1,s2
    80003d6a:	8526                	mv	a0,s1
    80003d6c:	8b2fe0ef          	jal	80001e1e <sleep>
  while (lk->locked) {
    80003d70:	409c                	lw	a5,0(s1)
    80003d72:	fbfd                	bnez	a5,80003d68 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003d74:	4785                	li	a5,1
    80003d76:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003d78:	ab9fd0ef          	jal	80001830 <myproc>
    80003d7c:	591c                	lw	a5,48(a0)
    80003d7e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003d80:	854a                	mv	a0,s2
    80003d82:	eb7fc0ef          	jal	80000c38 <release>
}
    80003d86:	60e2                	ld	ra,24(sp)
    80003d88:	6442                	ld	s0,16(sp)
    80003d8a:	64a2                	ld	s1,8(sp)
    80003d8c:	6902                	ld	s2,0(sp)
    80003d8e:	6105                	add	sp,sp,32
    80003d90:	8082                	ret

0000000080003d92 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003d92:	1101                	add	sp,sp,-32
    80003d94:	ec06                	sd	ra,24(sp)
    80003d96:	e822                	sd	s0,16(sp)
    80003d98:	e426                	sd	s1,8(sp)
    80003d9a:	e04a                	sd	s2,0(sp)
    80003d9c:	1000                	add	s0,sp,32
    80003d9e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003da0:	00850913          	add	s2,a0,8
    80003da4:	854a                	mv	a0,s2
    80003da6:	dfbfc0ef          	jal	80000ba0 <acquire>
  lk->locked = 0;
    80003daa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003dae:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003db2:	8526                	mv	a0,s1
    80003db4:	8b6fe0ef          	jal	80001e6a <wakeup>
  release(&lk->lk);
    80003db8:	854a                	mv	a0,s2
    80003dba:	e7ffc0ef          	jal	80000c38 <release>
}
    80003dbe:	60e2                	ld	ra,24(sp)
    80003dc0:	6442                	ld	s0,16(sp)
    80003dc2:	64a2                	ld	s1,8(sp)
    80003dc4:	6902                	ld	s2,0(sp)
    80003dc6:	6105                	add	sp,sp,32
    80003dc8:	8082                	ret

0000000080003dca <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003dca:	7179                	add	sp,sp,-48
    80003dcc:	f406                	sd	ra,40(sp)
    80003dce:	f022                	sd	s0,32(sp)
    80003dd0:	ec26                	sd	s1,24(sp)
    80003dd2:	e84a                	sd	s2,16(sp)
    80003dd4:	e44e                	sd	s3,8(sp)
    80003dd6:	1800                	add	s0,sp,48
    80003dd8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003dda:	00850913          	add	s2,a0,8
    80003dde:	854a                	mv	a0,s2
    80003de0:	dc1fc0ef          	jal	80000ba0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003de4:	409c                	lw	a5,0(s1)
    80003de6:	ef89                	bnez	a5,80003e00 <holdingsleep+0x36>
    80003de8:	4481                	li	s1,0
  release(&lk->lk);
    80003dea:	854a                	mv	a0,s2
    80003dec:	e4dfc0ef          	jal	80000c38 <release>
  return r;
}
    80003df0:	8526                	mv	a0,s1
    80003df2:	70a2                	ld	ra,40(sp)
    80003df4:	7402                	ld	s0,32(sp)
    80003df6:	64e2                	ld	s1,24(sp)
    80003df8:	6942                	ld	s2,16(sp)
    80003dfa:	69a2                	ld	s3,8(sp)
    80003dfc:	6145                	add	sp,sp,48
    80003dfe:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003e00:	0284a983          	lw	s3,40(s1)
    80003e04:	a2dfd0ef          	jal	80001830 <myproc>
    80003e08:	5904                	lw	s1,48(a0)
    80003e0a:	413484b3          	sub	s1,s1,s3
    80003e0e:	0014b493          	seqz	s1,s1
    80003e12:	bfe1                	j	80003dea <holdingsleep+0x20>

0000000080003e14 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003e14:	1141                	add	sp,sp,-16
    80003e16:	e406                	sd	ra,8(sp)
    80003e18:	e022                	sd	s0,0(sp)
    80003e1a:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003e1c:	00004597          	auipc	a1,0x4
    80003e20:	8cc58593          	add	a1,a1,-1844 # 800076e8 <syscalls+0x258>
    80003e24:	0001c517          	auipc	a0,0x1c
    80003e28:	16450513          	add	a0,a0,356 # 8001ff88 <ftable>
    80003e2c:	cf5fc0ef          	jal	80000b20 <initlock>
}
    80003e30:	60a2                	ld	ra,8(sp)
    80003e32:	6402                	ld	s0,0(sp)
    80003e34:	0141                	add	sp,sp,16
    80003e36:	8082                	ret

0000000080003e38 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003e38:	1101                	add	sp,sp,-32
    80003e3a:	ec06                	sd	ra,24(sp)
    80003e3c:	e822                	sd	s0,16(sp)
    80003e3e:	e426                	sd	s1,8(sp)
    80003e40:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003e42:	0001c517          	auipc	a0,0x1c
    80003e46:	14650513          	add	a0,a0,326 # 8001ff88 <ftable>
    80003e4a:	d57fc0ef          	jal	80000ba0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e4e:	0001c497          	auipc	s1,0x1c
    80003e52:	15248493          	add	s1,s1,338 # 8001ffa0 <ftable+0x18>
    80003e56:	0001d717          	auipc	a4,0x1d
    80003e5a:	0ea70713          	add	a4,a4,234 # 80020f40 <disk>
    if(f->ref == 0){
    80003e5e:	40dc                	lw	a5,4(s1)
    80003e60:	cf89                	beqz	a5,80003e7a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e62:	02848493          	add	s1,s1,40
    80003e66:	fee49ce3          	bne	s1,a4,80003e5e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003e6a:	0001c517          	auipc	a0,0x1c
    80003e6e:	11e50513          	add	a0,a0,286 # 8001ff88 <ftable>
    80003e72:	dc7fc0ef          	jal	80000c38 <release>
  return 0;
    80003e76:	4481                	li	s1,0
    80003e78:	a809                	j	80003e8a <filealloc+0x52>
      f->ref = 1;
    80003e7a:	4785                	li	a5,1
    80003e7c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003e7e:	0001c517          	auipc	a0,0x1c
    80003e82:	10a50513          	add	a0,a0,266 # 8001ff88 <ftable>
    80003e86:	db3fc0ef          	jal	80000c38 <release>
}
    80003e8a:	8526                	mv	a0,s1
    80003e8c:	60e2                	ld	ra,24(sp)
    80003e8e:	6442                	ld	s0,16(sp)
    80003e90:	64a2                	ld	s1,8(sp)
    80003e92:	6105                	add	sp,sp,32
    80003e94:	8082                	ret

0000000080003e96 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003e96:	1101                	add	sp,sp,-32
    80003e98:	ec06                	sd	ra,24(sp)
    80003e9a:	e822                	sd	s0,16(sp)
    80003e9c:	e426                	sd	s1,8(sp)
    80003e9e:	1000                	add	s0,sp,32
    80003ea0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ea2:	0001c517          	auipc	a0,0x1c
    80003ea6:	0e650513          	add	a0,a0,230 # 8001ff88 <ftable>
    80003eaa:	cf7fc0ef          	jal	80000ba0 <acquire>
  if(f->ref < 1)
    80003eae:	40dc                	lw	a5,4(s1)
    80003eb0:	02f05063          	blez	a5,80003ed0 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003eb4:	2785                	addw	a5,a5,1
    80003eb6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003eb8:	0001c517          	auipc	a0,0x1c
    80003ebc:	0d050513          	add	a0,a0,208 # 8001ff88 <ftable>
    80003ec0:	d79fc0ef          	jal	80000c38 <release>
  return f;
}
    80003ec4:	8526                	mv	a0,s1
    80003ec6:	60e2                	ld	ra,24(sp)
    80003ec8:	6442                	ld	s0,16(sp)
    80003eca:	64a2                	ld	s1,8(sp)
    80003ecc:	6105                	add	sp,sp,32
    80003ece:	8082                	ret
    panic("filedup");
    80003ed0:	00004517          	auipc	a0,0x4
    80003ed4:	82050513          	add	a0,a0,-2016 # 800076f0 <syscalls+0x260>
    80003ed8:	887fc0ef          	jal	8000075e <panic>

0000000080003edc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003edc:	7139                	add	sp,sp,-64
    80003ede:	fc06                	sd	ra,56(sp)
    80003ee0:	f822                	sd	s0,48(sp)
    80003ee2:	f426                	sd	s1,40(sp)
    80003ee4:	f04a                	sd	s2,32(sp)
    80003ee6:	ec4e                	sd	s3,24(sp)
    80003ee8:	e852                	sd	s4,16(sp)
    80003eea:	e456                	sd	s5,8(sp)
    80003eec:	0080                	add	s0,sp,64
    80003eee:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ef0:	0001c517          	auipc	a0,0x1c
    80003ef4:	09850513          	add	a0,a0,152 # 8001ff88 <ftable>
    80003ef8:	ca9fc0ef          	jal	80000ba0 <acquire>
  if(f->ref < 1)
    80003efc:	40dc                	lw	a5,4(s1)
    80003efe:	04f05963          	blez	a5,80003f50 <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    80003f02:	37fd                	addw	a5,a5,-1
    80003f04:	0007871b          	sext.w	a4,a5
    80003f08:	c0dc                	sw	a5,4(s1)
    80003f0a:	04e04963          	bgtz	a4,80003f5c <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003f0e:	0004a903          	lw	s2,0(s1)
    80003f12:	0094ca83          	lbu	s5,9(s1)
    80003f16:	0104ba03          	ld	s4,16(s1)
    80003f1a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003f1e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003f22:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003f26:	0001c517          	auipc	a0,0x1c
    80003f2a:	06250513          	add	a0,a0,98 # 8001ff88 <ftable>
    80003f2e:	d0bfc0ef          	jal	80000c38 <release>

  if(ff.type == FD_PIPE){
    80003f32:	4785                	li	a5,1
    80003f34:	04f90363          	beq	s2,a5,80003f7a <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003f38:	3979                	addw	s2,s2,-2
    80003f3a:	4785                	li	a5,1
    80003f3c:	0327e663          	bltu	a5,s2,80003f68 <fileclose+0x8c>
    begin_op();
    80003f40:	b89ff0ef          	jal	80003ac8 <begin_op>
    iput(ff.ip);
    80003f44:	854e                	mv	a0,s3
    80003f46:	c92ff0ef          	jal	800033d8 <iput>
    end_op();
    80003f4a:	be9ff0ef          	jal	80003b32 <end_op>
    80003f4e:	a829                	j	80003f68 <fileclose+0x8c>
    panic("fileclose");
    80003f50:	00003517          	auipc	a0,0x3
    80003f54:	7a850513          	add	a0,a0,1960 # 800076f8 <syscalls+0x268>
    80003f58:	807fc0ef          	jal	8000075e <panic>
    release(&ftable.lock);
    80003f5c:	0001c517          	auipc	a0,0x1c
    80003f60:	02c50513          	add	a0,a0,44 # 8001ff88 <ftable>
    80003f64:	cd5fc0ef          	jal	80000c38 <release>
  }
}
    80003f68:	70e2                	ld	ra,56(sp)
    80003f6a:	7442                	ld	s0,48(sp)
    80003f6c:	74a2                	ld	s1,40(sp)
    80003f6e:	7902                	ld	s2,32(sp)
    80003f70:	69e2                	ld	s3,24(sp)
    80003f72:	6a42                	ld	s4,16(sp)
    80003f74:	6aa2                	ld	s5,8(sp)
    80003f76:	6121                	add	sp,sp,64
    80003f78:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003f7a:	85d6                	mv	a1,s5
    80003f7c:	8552                	mv	a0,s4
    80003f7e:	2e8000ef          	jal	80004266 <pipeclose>
    80003f82:	b7dd                	j	80003f68 <fileclose+0x8c>

0000000080003f84 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003f84:	715d                	add	sp,sp,-80
    80003f86:	e486                	sd	ra,72(sp)
    80003f88:	e0a2                	sd	s0,64(sp)
    80003f8a:	fc26                	sd	s1,56(sp)
    80003f8c:	f84a                	sd	s2,48(sp)
    80003f8e:	f44e                	sd	s3,40(sp)
    80003f90:	0880                	add	s0,sp,80
    80003f92:	84aa                	mv	s1,a0
    80003f94:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003f96:	89bfd0ef          	jal	80001830 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003f9a:	409c                	lw	a5,0(s1)
    80003f9c:	37f9                	addw	a5,a5,-2
    80003f9e:	4705                	li	a4,1
    80003fa0:	02f76f63          	bltu	a4,a5,80003fde <filestat+0x5a>
    80003fa4:	892a                	mv	s2,a0
    ilock(f->ip);
    80003fa6:	6c88                	ld	a0,24(s1)
    80003fa8:	ab2ff0ef          	jal	8000325a <ilock>
    stati(f->ip, &st);
    80003fac:	fb840593          	add	a1,s0,-72
    80003fb0:	6c88                	ld	a0,24(s1)
    80003fb2:	cceff0ef          	jal	80003480 <stati>
    iunlock(f->ip);
    80003fb6:	6c88                	ld	a0,24(s1)
    80003fb8:	b4cff0ef          	jal	80003304 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003fbc:	46e1                	li	a3,24
    80003fbe:	fb840613          	add	a2,s0,-72
    80003fc2:	85ce                	mv	a1,s3
    80003fc4:	05093503          	ld	a0,80(s2)
    80003fc8:	d20fd0ef          	jal	800014e8 <copyout>
    80003fcc:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003fd0:	60a6                	ld	ra,72(sp)
    80003fd2:	6406                	ld	s0,64(sp)
    80003fd4:	74e2                	ld	s1,56(sp)
    80003fd6:	7942                	ld	s2,48(sp)
    80003fd8:	79a2                	ld	s3,40(sp)
    80003fda:	6161                	add	sp,sp,80
    80003fdc:	8082                	ret
  return -1;
    80003fde:	557d                	li	a0,-1
    80003fe0:	bfc5                	j	80003fd0 <filestat+0x4c>

0000000080003fe2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003fe2:	7179                	add	sp,sp,-48
    80003fe4:	f406                	sd	ra,40(sp)
    80003fe6:	f022                	sd	s0,32(sp)
    80003fe8:	ec26                	sd	s1,24(sp)
    80003fea:	e84a                	sd	s2,16(sp)
    80003fec:	e44e                	sd	s3,8(sp)
    80003fee:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ff0:	00854783          	lbu	a5,8(a0)
    80003ff4:	cbc1                	beqz	a5,80004084 <fileread+0xa2>
    80003ff6:	84aa                	mv	s1,a0
    80003ff8:	89ae                	mv	s3,a1
    80003ffa:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ffc:	411c                	lw	a5,0(a0)
    80003ffe:	4705                	li	a4,1
    80004000:	04e78363          	beq	a5,a4,80004046 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004004:	470d                	li	a4,3
    80004006:	04e78563          	beq	a5,a4,80004050 <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000400a:	4709                	li	a4,2
    8000400c:	06e79663          	bne	a5,a4,80004078 <fileread+0x96>
    ilock(f->ip);
    80004010:	6d08                	ld	a0,24(a0)
    80004012:	a48ff0ef          	jal	8000325a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004016:	874a                	mv	a4,s2
    80004018:	5094                	lw	a3,32(s1)
    8000401a:	864e                	mv	a2,s3
    8000401c:	4585                	li	a1,1
    8000401e:	6c88                	ld	a0,24(s1)
    80004020:	c8aff0ef          	jal	800034aa <readi>
    80004024:	892a                	mv	s2,a0
    80004026:	00a05563          	blez	a0,80004030 <fileread+0x4e>
      f->off += r;
    8000402a:	509c                	lw	a5,32(s1)
    8000402c:	9fa9                	addw	a5,a5,a0
    8000402e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004030:	6c88                	ld	a0,24(s1)
    80004032:	ad2ff0ef          	jal	80003304 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004036:	854a                	mv	a0,s2
    80004038:	70a2                	ld	ra,40(sp)
    8000403a:	7402                	ld	s0,32(sp)
    8000403c:	64e2                	ld	s1,24(sp)
    8000403e:	6942                	ld	s2,16(sp)
    80004040:	69a2                	ld	s3,8(sp)
    80004042:	6145                	add	sp,sp,48
    80004044:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004046:	6908                	ld	a0,16(a0)
    80004048:	34a000ef          	jal	80004392 <piperead>
    8000404c:	892a                	mv	s2,a0
    8000404e:	b7e5                	j	80004036 <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004050:	02451783          	lh	a5,36(a0)
    80004054:	03079693          	sll	a3,a5,0x30
    80004058:	92c1                	srl	a3,a3,0x30
    8000405a:	4725                	li	a4,9
    8000405c:	02d76663          	bltu	a4,a3,80004088 <fileread+0xa6>
    80004060:	0792                	sll	a5,a5,0x4
    80004062:	0001c717          	auipc	a4,0x1c
    80004066:	e8670713          	add	a4,a4,-378 # 8001fee8 <devsw>
    8000406a:	97ba                	add	a5,a5,a4
    8000406c:	639c                	ld	a5,0(a5)
    8000406e:	cf99                	beqz	a5,8000408c <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    80004070:	4505                	li	a0,1
    80004072:	9782                	jalr	a5
    80004074:	892a                	mv	s2,a0
    80004076:	b7c1                	j	80004036 <fileread+0x54>
    panic("fileread");
    80004078:	00003517          	auipc	a0,0x3
    8000407c:	69050513          	add	a0,a0,1680 # 80007708 <syscalls+0x278>
    80004080:	edefc0ef          	jal	8000075e <panic>
    return -1;
    80004084:	597d                	li	s2,-1
    80004086:	bf45                	j	80004036 <fileread+0x54>
      return -1;
    80004088:	597d                	li	s2,-1
    8000408a:	b775                	j	80004036 <fileread+0x54>
    8000408c:	597d                	li	s2,-1
    8000408e:	b765                	j	80004036 <fileread+0x54>

0000000080004090 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004090:	00954783          	lbu	a5,9(a0)
    80004094:	10078063          	beqz	a5,80004194 <filewrite+0x104>
{
    80004098:	715d                	add	sp,sp,-80
    8000409a:	e486                	sd	ra,72(sp)
    8000409c:	e0a2                	sd	s0,64(sp)
    8000409e:	fc26                	sd	s1,56(sp)
    800040a0:	f84a                	sd	s2,48(sp)
    800040a2:	f44e                	sd	s3,40(sp)
    800040a4:	f052                	sd	s4,32(sp)
    800040a6:	ec56                	sd	s5,24(sp)
    800040a8:	e85a                	sd	s6,16(sp)
    800040aa:	e45e                	sd	s7,8(sp)
    800040ac:	e062                	sd	s8,0(sp)
    800040ae:	0880                	add	s0,sp,80
    800040b0:	892a                	mv	s2,a0
    800040b2:	8b2e                	mv	s6,a1
    800040b4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800040b6:	411c                	lw	a5,0(a0)
    800040b8:	4705                	li	a4,1
    800040ba:	02e78263          	beq	a5,a4,800040de <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800040be:	470d                	li	a4,3
    800040c0:	02e78363          	beq	a5,a4,800040e6 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800040c4:	4709                	li	a4,2
    800040c6:	0ce79163          	bne	a5,a4,80004188 <filewrite+0xf8>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800040ca:	08c05f63          	blez	a2,80004168 <filewrite+0xd8>
    int i = 0;
    800040ce:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800040d0:	6b85                	lui	s7,0x1
    800040d2:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800040d6:	6c05                	lui	s8,0x1
    800040d8:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800040dc:	a8b5                	j	80004158 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800040de:	6908                	ld	a0,16(a0)
    800040e0:	1de000ef          	jal	800042be <pipewrite>
    800040e4:	a071                	j	80004170 <filewrite+0xe0>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800040e6:	02451783          	lh	a5,36(a0)
    800040ea:	03079693          	sll	a3,a5,0x30
    800040ee:	92c1                	srl	a3,a3,0x30
    800040f0:	4725                	li	a4,9
    800040f2:	0ad76363          	bltu	a4,a3,80004198 <filewrite+0x108>
    800040f6:	0792                	sll	a5,a5,0x4
    800040f8:	0001c717          	auipc	a4,0x1c
    800040fc:	df070713          	add	a4,a4,-528 # 8001fee8 <devsw>
    80004100:	97ba                	add	a5,a5,a4
    80004102:	679c                	ld	a5,8(a5)
    80004104:	cfc1                	beqz	a5,8000419c <filewrite+0x10c>
    ret = devsw[f->major].write(1, addr, n);
    80004106:	4505                	li	a0,1
    80004108:	9782                	jalr	a5
    8000410a:	a09d                	j	80004170 <filewrite+0xe0>
      if(n1 > max)
    8000410c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004110:	9b9ff0ef          	jal	80003ac8 <begin_op>
      ilock(f->ip);
    80004114:	01893503          	ld	a0,24(s2)
    80004118:	942ff0ef          	jal	8000325a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000411c:	8756                	mv	a4,s5
    8000411e:	02092683          	lw	a3,32(s2)
    80004122:	01698633          	add	a2,s3,s6
    80004126:	4585                	li	a1,1
    80004128:	01893503          	ld	a0,24(s2)
    8000412c:	c62ff0ef          	jal	8000358e <writei>
    80004130:	84aa                	mv	s1,a0
    80004132:	00a05763          	blez	a0,80004140 <filewrite+0xb0>
        f->off += r;
    80004136:	02092783          	lw	a5,32(s2)
    8000413a:	9fa9                	addw	a5,a5,a0
    8000413c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004140:	01893503          	ld	a0,24(s2)
    80004144:	9c0ff0ef          	jal	80003304 <iunlock>
      end_op();
    80004148:	9ebff0ef          	jal	80003b32 <end_op>

      if(r != n1){
    8000414c:	009a9f63          	bne	s5,s1,8000416a <filewrite+0xda>
        // error from writei
        break;
      }
      i += r;
    80004150:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004154:	0149db63          	bge	s3,s4,8000416a <filewrite+0xda>
      int n1 = n - i;
    80004158:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000415c:	0004879b          	sext.w	a5,s1
    80004160:	fafbd6e3          	bge	s7,a5,8000410c <filewrite+0x7c>
    80004164:	84e2                	mv	s1,s8
    80004166:	b75d                	j	8000410c <filewrite+0x7c>
    int i = 0;
    80004168:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    8000416a:	033a1b63          	bne	s4,s3,800041a0 <filewrite+0x110>
    8000416e:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004170:	60a6                	ld	ra,72(sp)
    80004172:	6406                	ld	s0,64(sp)
    80004174:	74e2                	ld	s1,56(sp)
    80004176:	7942                	ld	s2,48(sp)
    80004178:	79a2                	ld	s3,40(sp)
    8000417a:	7a02                	ld	s4,32(sp)
    8000417c:	6ae2                	ld	s5,24(sp)
    8000417e:	6b42                	ld	s6,16(sp)
    80004180:	6ba2                	ld	s7,8(sp)
    80004182:	6c02                	ld	s8,0(sp)
    80004184:	6161                	add	sp,sp,80
    80004186:	8082                	ret
    panic("filewrite");
    80004188:	00003517          	auipc	a0,0x3
    8000418c:	59050513          	add	a0,a0,1424 # 80007718 <syscalls+0x288>
    80004190:	dcefc0ef          	jal	8000075e <panic>
    return -1;
    80004194:	557d                	li	a0,-1
}
    80004196:	8082                	ret
      return -1;
    80004198:	557d                	li	a0,-1
    8000419a:	bfd9                	j	80004170 <filewrite+0xe0>
    8000419c:	557d                	li	a0,-1
    8000419e:	bfc9                	j	80004170 <filewrite+0xe0>
    ret = (i == n ? n : -1);
    800041a0:	557d                	li	a0,-1
    800041a2:	b7f9                	j	80004170 <filewrite+0xe0>

00000000800041a4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800041a4:	7179                	add	sp,sp,-48
    800041a6:	f406                	sd	ra,40(sp)
    800041a8:	f022                	sd	s0,32(sp)
    800041aa:	ec26                	sd	s1,24(sp)
    800041ac:	e84a                	sd	s2,16(sp)
    800041ae:	e44e                	sd	s3,8(sp)
    800041b0:	e052                	sd	s4,0(sp)
    800041b2:	1800                	add	s0,sp,48
    800041b4:	84aa                	mv	s1,a0
    800041b6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800041b8:	0005b023          	sd	zero,0(a1)
    800041bc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800041c0:	c79ff0ef          	jal	80003e38 <filealloc>
    800041c4:	e088                	sd	a0,0(s1)
    800041c6:	cd35                	beqz	a0,80004242 <pipealloc+0x9e>
    800041c8:	c71ff0ef          	jal	80003e38 <filealloc>
    800041cc:	00aa3023          	sd	a0,0(s4)
    800041d0:	c52d                	beqz	a0,8000423a <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800041d2:	8fffc0ef          	jal	80000ad0 <kalloc>
    800041d6:	892a                	mv	s2,a0
    800041d8:	cd31                	beqz	a0,80004234 <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    800041da:	4985                	li	s3,1
    800041dc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800041e0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800041e4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800041e8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800041ec:	00003597          	auipc	a1,0x3
    800041f0:	53c58593          	add	a1,a1,1340 # 80007728 <syscalls+0x298>
    800041f4:	92dfc0ef          	jal	80000b20 <initlock>
  (*f0)->type = FD_PIPE;
    800041f8:	609c                	ld	a5,0(s1)
    800041fa:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800041fe:	609c                	ld	a5,0(s1)
    80004200:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004204:	609c                	ld	a5,0(s1)
    80004206:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000420a:	609c                	ld	a5,0(s1)
    8000420c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004210:	000a3783          	ld	a5,0(s4)
    80004214:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004218:	000a3783          	ld	a5,0(s4)
    8000421c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004220:	000a3783          	ld	a5,0(s4)
    80004224:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004228:	000a3783          	ld	a5,0(s4)
    8000422c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004230:	4501                	li	a0,0
    80004232:	a005                	j	80004252 <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004234:	6088                	ld	a0,0(s1)
    80004236:	e501                	bnez	a0,8000423e <pipealloc+0x9a>
    80004238:	a029                	j	80004242 <pipealloc+0x9e>
    8000423a:	6088                	ld	a0,0(s1)
    8000423c:	c11d                	beqz	a0,80004262 <pipealloc+0xbe>
    fileclose(*f0);
    8000423e:	c9fff0ef          	jal	80003edc <fileclose>
  if(*f1)
    80004242:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004246:	557d                	li	a0,-1
  if(*f1)
    80004248:	c789                	beqz	a5,80004252 <pipealloc+0xae>
    fileclose(*f1);
    8000424a:	853e                	mv	a0,a5
    8000424c:	c91ff0ef          	jal	80003edc <fileclose>
  return -1;
    80004250:	557d                	li	a0,-1
}
    80004252:	70a2                	ld	ra,40(sp)
    80004254:	7402                	ld	s0,32(sp)
    80004256:	64e2                	ld	s1,24(sp)
    80004258:	6942                	ld	s2,16(sp)
    8000425a:	69a2                	ld	s3,8(sp)
    8000425c:	6a02                	ld	s4,0(sp)
    8000425e:	6145                	add	sp,sp,48
    80004260:	8082                	ret
  return -1;
    80004262:	557d                	li	a0,-1
    80004264:	b7fd                	j	80004252 <pipealloc+0xae>

0000000080004266 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004266:	1101                	add	sp,sp,-32
    80004268:	ec06                	sd	ra,24(sp)
    8000426a:	e822                	sd	s0,16(sp)
    8000426c:	e426                	sd	s1,8(sp)
    8000426e:	e04a                	sd	s2,0(sp)
    80004270:	1000                	add	s0,sp,32
    80004272:	84aa                	mv	s1,a0
    80004274:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004276:	92bfc0ef          	jal	80000ba0 <acquire>
  if(writable){
    8000427a:	02090763          	beqz	s2,800042a8 <pipeclose+0x42>
    pi->writeopen = 0;
    8000427e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004282:	21848513          	add	a0,s1,536
    80004286:	be5fd0ef          	jal	80001e6a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000428a:	2204b783          	ld	a5,544(s1)
    8000428e:	e785                	bnez	a5,800042b6 <pipeclose+0x50>
    release(&pi->lock);
    80004290:	8526                	mv	a0,s1
    80004292:	9a7fc0ef          	jal	80000c38 <release>
    kfree((char*)pi);
    80004296:	8526                	mv	a0,s1
    80004298:	f56fc0ef          	jal	800009ee <kfree>
  } else
    release(&pi->lock);
}
    8000429c:	60e2                	ld	ra,24(sp)
    8000429e:	6442                	ld	s0,16(sp)
    800042a0:	64a2                	ld	s1,8(sp)
    800042a2:	6902                	ld	s2,0(sp)
    800042a4:	6105                	add	sp,sp,32
    800042a6:	8082                	ret
    pi->readopen = 0;
    800042a8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800042ac:	21c48513          	add	a0,s1,540
    800042b0:	bbbfd0ef          	jal	80001e6a <wakeup>
    800042b4:	bfd9                	j	8000428a <pipeclose+0x24>
    release(&pi->lock);
    800042b6:	8526                	mv	a0,s1
    800042b8:	981fc0ef          	jal	80000c38 <release>
}
    800042bc:	b7c5                	j	8000429c <pipeclose+0x36>

00000000800042be <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800042be:	711d                	add	sp,sp,-96
    800042c0:	ec86                	sd	ra,88(sp)
    800042c2:	e8a2                	sd	s0,80(sp)
    800042c4:	e4a6                	sd	s1,72(sp)
    800042c6:	e0ca                	sd	s2,64(sp)
    800042c8:	fc4e                	sd	s3,56(sp)
    800042ca:	f852                	sd	s4,48(sp)
    800042cc:	f456                	sd	s5,40(sp)
    800042ce:	f05a                	sd	s6,32(sp)
    800042d0:	ec5e                	sd	s7,24(sp)
    800042d2:	e862                	sd	s8,16(sp)
    800042d4:	1080                	add	s0,sp,96
    800042d6:	84aa                	mv	s1,a0
    800042d8:	8aae                	mv	s5,a1
    800042da:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800042dc:	d54fd0ef          	jal	80001830 <myproc>
    800042e0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800042e2:	8526                	mv	a0,s1
    800042e4:	8bdfc0ef          	jal	80000ba0 <acquire>
  while(i < n){
    800042e8:	09405c63          	blez	s4,80004380 <pipewrite+0xc2>
  int i = 0;
    800042ec:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800042ee:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800042f0:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800042f4:	21c48b93          	add	s7,s1,540
    800042f8:	a81d                	j	8000432e <pipewrite+0x70>
      release(&pi->lock);
    800042fa:	8526                	mv	a0,s1
    800042fc:	93dfc0ef          	jal	80000c38 <release>
      return -1;
    80004300:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004302:	854a                	mv	a0,s2
    80004304:	60e6                	ld	ra,88(sp)
    80004306:	6446                	ld	s0,80(sp)
    80004308:	64a6                	ld	s1,72(sp)
    8000430a:	6906                	ld	s2,64(sp)
    8000430c:	79e2                	ld	s3,56(sp)
    8000430e:	7a42                	ld	s4,48(sp)
    80004310:	7aa2                	ld	s5,40(sp)
    80004312:	7b02                	ld	s6,32(sp)
    80004314:	6be2                	ld	s7,24(sp)
    80004316:	6c42                	ld	s8,16(sp)
    80004318:	6125                	add	sp,sp,96
    8000431a:	8082                	ret
      wakeup(&pi->nread);
    8000431c:	8562                	mv	a0,s8
    8000431e:	b4dfd0ef          	jal	80001e6a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004322:	85a6                	mv	a1,s1
    80004324:	855e                	mv	a0,s7
    80004326:	af9fd0ef          	jal	80001e1e <sleep>
  while(i < n){
    8000432a:	05495c63          	bge	s2,s4,80004382 <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    8000432e:	2204a783          	lw	a5,544(s1)
    80004332:	d7e1                	beqz	a5,800042fa <pipewrite+0x3c>
    80004334:	854e                	mv	a0,s3
    80004336:	d21fd0ef          	jal	80002056 <killed>
    8000433a:	f161                	bnez	a0,800042fa <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000433c:	2184a783          	lw	a5,536(s1)
    80004340:	21c4a703          	lw	a4,540(s1)
    80004344:	2007879b          	addw	a5,a5,512
    80004348:	fcf70ae3          	beq	a4,a5,8000431c <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000434c:	4685                	li	a3,1
    8000434e:	01590633          	add	a2,s2,s5
    80004352:	faf40593          	add	a1,s0,-81
    80004356:	0509b503          	ld	a0,80(s3)
    8000435a:	a46fd0ef          	jal	800015a0 <copyin>
    8000435e:	03650263          	beq	a0,s6,80004382 <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004362:	21c4a783          	lw	a5,540(s1)
    80004366:	0017871b          	addw	a4,a5,1
    8000436a:	20e4ae23          	sw	a4,540(s1)
    8000436e:	1ff7f793          	and	a5,a5,511
    80004372:	97a6                	add	a5,a5,s1
    80004374:	faf44703          	lbu	a4,-81(s0)
    80004378:	00e78c23          	sb	a4,24(a5)
      i++;
    8000437c:	2905                	addw	s2,s2,1
    8000437e:	b775                	j	8000432a <pipewrite+0x6c>
  int i = 0;
    80004380:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004382:	21848513          	add	a0,s1,536
    80004386:	ae5fd0ef          	jal	80001e6a <wakeup>
  release(&pi->lock);
    8000438a:	8526                	mv	a0,s1
    8000438c:	8adfc0ef          	jal	80000c38 <release>
  return i;
    80004390:	bf8d                	j	80004302 <pipewrite+0x44>

0000000080004392 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004392:	715d                	add	sp,sp,-80
    80004394:	e486                	sd	ra,72(sp)
    80004396:	e0a2                	sd	s0,64(sp)
    80004398:	fc26                	sd	s1,56(sp)
    8000439a:	f84a                	sd	s2,48(sp)
    8000439c:	f44e                	sd	s3,40(sp)
    8000439e:	f052                	sd	s4,32(sp)
    800043a0:	ec56                	sd	s5,24(sp)
    800043a2:	e85a                	sd	s6,16(sp)
    800043a4:	0880                	add	s0,sp,80
    800043a6:	84aa                	mv	s1,a0
    800043a8:	892e                	mv	s2,a1
    800043aa:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800043ac:	c84fd0ef          	jal	80001830 <myproc>
    800043b0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800043b2:	8526                	mv	a0,s1
    800043b4:	fecfc0ef          	jal	80000ba0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043b8:	2184a703          	lw	a4,536(s1)
    800043bc:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800043c0:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043c4:	02f71363          	bne	a4,a5,800043ea <piperead+0x58>
    800043c8:	2244a783          	lw	a5,548(s1)
    800043cc:	cf99                	beqz	a5,800043ea <piperead+0x58>
    if(killed(pr)){
    800043ce:	8552                	mv	a0,s4
    800043d0:	c87fd0ef          	jal	80002056 <killed>
    800043d4:	e149                	bnez	a0,80004456 <piperead+0xc4>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800043d6:	85a6                	mv	a1,s1
    800043d8:	854e                	mv	a0,s3
    800043da:	a45fd0ef          	jal	80001e1e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043de:	2184a703          	lw	a4,536(s1)
    800043e2:	21c4a783          	lw	a5,540(s1)
    800043e6:	fef701e3          	beq	a4,a5,800043c8 <piperead+0x36>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800043ea:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800043ec:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800043ee:	05505263          	blez	s5,80004432 <piperead+0xa0>
    if(pi->nread == pi->nwrite)
    800043f2:	2184a783          	lw	a5,536(s1)
    800043f6:	21c4a703          	lw	a4,540(s1)
    800043fa:	02f70c63          	beq	a4,a5,80004432 <piperead+0xa0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800043fe:	0017871b          	addw	a4,a5,1
    80004402:	20e4ac23          	sw	a4,536(s1)
    80004406:	1ff7f793          	and	a5,a5,511
    8000440a:	97a6                	add	a5,a5,s1
    8000440c:	0187c783          	lbu	a5,24(a5)
    80004410:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004414:	4685                	li	a3,1
    80004416:	fbf40613          	add	a2,s0,-65
    8000441a:	85ca                	mv	a1,s2
    8000441c:	050a3503          	ld	a0,80(s4)
    80004420:	8c8fd0ef          	jal	800014e8 <copyout>
    80004424:	01650763          	beq	a0,s6,80004432 <piperead+0xa0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004428:	2985                	addw	s3,s3,1
    8000442a:	0905                	add	s2,s2,1
    8000442c:	fd3a93e3          	bne	s5,s3,800043f2 <piperead+0x60>
    80004430:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004432:	21c48513          	add	a0,s1,540
    80004436:	a35fd0ef          	jal	80001e6a <wakeup>
  release(&pi->lock);
    8000443a:	8526                	mv	a0,s1
    8000443c:	ffcfc0ef          	jal	80000c38 <release>
  return i;
}
    80004440:	854e                	mv	a0,s3
    80004442:	60a6                	ld	ra,72(sp)
    80004444:	6406                	ld	s0,64(sp)
    80004446:	74e2                	ld	s1,56(sp)
    80004448:	7942                	ld	s2,48(sp)
    8000444a:	79a2                	ld	s3,40(sp)
    8000444c:	7a02                	ld	s4,32(sp)
    8000444e:	6ae2                	ld	s5,24(sp)
    80004450:	6b42                	ld	s6,16(sp)
    80004452:	6161                	add	sp,sp,80
    80004454:	8082                	ret
      release(&pi->lock);
    80004456:	8526                	mv	a0,s1
    80004458:	fe0fc0ef          	jal	80000c38 <release>
      return -1;
    8000445c:	59fd                	li	s3,-1
    8000445e:	b7cd                	j	80004440 <piperead+0xae>

0000000080004460 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004460:	1141                	add	sp,sp,-16
    80004462:	e422                	sd	s0,8(sp)
    80004464:	0800                	add	s0,sp,16
    80004466:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004468:	8905                	and	a0,a0,1
    8000446a:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000446c:	8b89                	and	a5,a5,2
    8000446e:	c399                	beqz	a5,80004474 <flags2perm+0x14>
      perm |= PTE_W;
    80004470:	00456513          	or	a0,a0,4
    return perm;
}
    80004474:	6422                	ld	s0,8(sp)
    80004476:	0141                	add	sp,sp,16
    80004478:	8082                	ret

000000008000447a <exec>:

int
exec(char *path, char **argv)
{
    8000447a:	df010113          	add	sp,sp,-528
    8000447e:	20113423          	sd	ra,520(sp)
    80004482:	20813023          	sd	s0,512(sp)
    80004486:	ffa6                	sd	s1,504(sp)
    80004488:	fbca                	sd	s2,496(sp)
    8000448a:	f7ce                	sd	s3,488(sp)
    8000448c:	f3d2                	sd	s4,480(sp)
    8000448e:	efd6                	sd	s5,472(sp)
    80004490:	ebda                	sd	s6,464(sp)
    80004492:	e7de                	sd	s7,456(sp)
    80004494:	e3e2                	sd	s8,448(sp)
    80004496:	ff66                	sd	s9,440(sp)
    80004498:	fb6a                	sd	s10,432(sp)
    8000449a:	f76e                	sd	s11,424(sp)
    8000449c:	0c00                	add	s0,sp,528
    8000449e:	892a                	mv	s2,a0
    800044a0:	dea43c23          	sd	a0,-520(s0)
    800044a4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800044a8:	b88fd0ef          	jal	80001830 <myproc>
    800044ac:	84aa                	mv	s1,a0

  begin_op();
    800044ae:	e1aff0ef          	jal	80003ac8 <begin_op>

  if((ip = namei(path)) == 0){
    800044b2:	854a                	mv	a0,s2
    800044b4:	c58ff0ef          	jal	8000390c <namei>
    800044b8:	c12d                	beqz	a0,8000451a <exec+0xa0>
    800044ba:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800044bc:	d9ffe0ef          	jal	8000325a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800044c0:	04000713          	li	a4,64
    800044c4:	4681                	li	a3,0
    800044c6:	e5040613          	add	a2,s0,-432
    800044ca:	4581                	li	a1,0
    800044cc:	8552                	mv	a0,s4
    800044ce:	fddfe0ef          	jal	800034aa <readi>
    800044d2:	04000793          	li	a5,64
    800044d6:	00f51a63          	bne	a0,a5,800044ea <exec+0x70>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800044da:	e5042703          	lw	a4,-432(s0)
    800044de:	464c47b7          	lui	a5,0x464c4
    800044e2:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800044e6:	02f70e63          	beq	a4,a5,80004522 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800044ea:	8552                	mv	a0,s4
    800044ec:	f75fe0ef          	jal	80003460 <iunlockput>
    end_op();
    800044f0:	e42ff0ef          	jal	80003b32 <end_op>
  }
  return -1;
    800044f4:	557d                	li	a0,-1
}
    800044f6:	20813083          	ld	ra,520(sp)
    800044fa:	20013403          	ld	s0,512(sp)
    800044fe:	74fe                	ld	s1,504(sp)
    80004500:	795e                	ld	s2,496(sp)
    80004502:	79be                	ld	s3,488(sp)
    80004504:	7a1e                	ld	s4,480(sp)
    80004506:	6afe                	ld	s5,472(sp)
    80004508:	6b5e                	ld	s6,464(sp)
    8000450a:	6bbe                	ld	s7,456(sp)
    8000450c:	6c1e                	ld	s8,448(sp)
    8000450e:	7cfa                	ld	s9,440(sp)
    80004510:	7d5a                	ld	s10,432(sp)
    80004512:	7dba                	ld	s11,424(sp)
    80004514:	21010113          	add	sp,sp,528
    80004518:	8082                	ret
    end_op();
    8000451a:	e18ff0ef          	jal	80003b32 <end_op>
    return -1;
    8000451e:	557d                	li	a0,-1
    80004520:	bfd9                	j	800044f6 <exec+0x7c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004522:	8526                	mv	a0,s1
    80004524:	bb4fd0ef          	jal	800018d8 <proc_pagetable>
    80004528:	8b2a                	mv	s6,a0
    8000452a:	d161                	beqz	a0,800044ea <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000452c:	e7042d03          	lw	s10,-400(s0)
    80004530:	e8845783          	lhu	a5,-376(s0)
    80004534:	0e078863          	beqz	a5,80004624 <exec+0x1aa>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004538:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000453a:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    8000453c:	6c85                	lui	s9,0x1
    8000453e:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004542:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004546:	6a85                	lui	s5,0x1
    80004548:	a085                	j	800045a8 <exec+0x12e>
      panic("loadseg: address should exist");
    8000454a:	00003517          	auipc	a0,0x3
    8000454e:	1e650513          	add	a0,a0,486 # 80007730 <syscalls+0x2a0>
    80004552:	a0cfc0ef          	jal	8000075e <panic>
    if(sz - i < PGSIZE)
    80004556:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004558:	8726                	mv	a4,s1
    8000455a:	012c06bb          	addw	a3,s8,s2
    8000455e:	4581                	li	a1,0
    80004560:	8552                	mv	a0,s4
    80004562:	f49fe0ef          	jal	800034aa <readi>
    80004566:	2501                	sext.w	a0,a0
    80004568:	20a49a63          	bne	s1,a0,8000477c <exec+0x302>
  for(i = 0; i < sz; i += PGSIZE){
    8000456c:	012a893b          	addw	s2,s5,s2
    80004570:	03397363          	bgeu	s2,s3,80004596 <exec+0x11c>
    pa = walkaddr(pagetable, va + i);
    80004574:	02091593          	sll	a1,s2,0x20
    80004578:	9181                	srl	a1,a1,0x20
    8000457a:	95de                	add	a1,a1,s7
    8000457c:	855a                	mv	a0,s6
    8000457e:	a0bfc0ef          	jal	80000f88 <walkaddr>
    80004582:	862a                	mv	a2,a0
    if(pa == 0)
    80004584:	d179                	beqz	a0,8000454a <exec+0xd0>
    if(sz - i < PGSIZE)
    80004586:	412984bb          	subw	s1,s3,s2
    8000458a:	0004879b          	sext.w	a5,s1
    8000458e:	fcfcf4e3          	bgeu	s9,a5,80004556 <exec+0xdc>
    80004592:	84d6                	mv	s1,s5
    80004594:	b7c9                	j	80004556 <exec+0xdc>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004596:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000459a:	2d85                	addw	s11,s11,1
    8000459c:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800045a0:	e8845783          	lhu	a5,-376(s0)
    800045a4:	08fdd163          	bge	s11,a5,80004626 <exec+0x1ac>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045a8:	2d01                	sext.w	s10,s10
    800045aa:	03800713          	li	a4,56
    800045ae:	86ea                	mv	a3,s10
    800045b0:	e1840613          	add	a2,s0,-488
    800045b4:	4581                	li	a1,0
    800045b6:	8552                	mv	a0,s4
    800045b8:	ef3fe0ef          	jal	800034aa <readi>
    800045bc:	03800793          	li	a5,56
    800045c0:	1af51c63          	bne	a0,a5,80004778 <exec+0x2fe>
    if(ph.type != ELF_PROG_LOAD)
    800045c4:	e1842783          	lw	a5,-488(s0)
    800045c8:	4705                	li	a4,1
    800045ca:	fce798e3          	bne	a5,a4,8000459a <exec+0x120>
    if(ph.memsz < ph.filesz)
    800045ce:	e4043483          	ld	s1,-448(s0)
    800045d2:	e3843783          	ld	a5,-456(s0)
    800045d6:	1af4ec63          	bltu	s1,a5,8000478e <exec+0x314>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045da:	e2843783          	ld	a5,-472(s0)
    800045de:	94be                	add	s1,s1,a5
    800045e0:	1af4ea63          	bltu	s1,a5,80004794 <exec+0x31a>
    if(ph.vaddr % PGSIZE != 0)
    800045e4:	df043703          	ld	a4,-528(s0)
    800045e8:	8ff9                	and	a5,a5,a4
    800045ea:	1a079863          	bnez	a5,8000479a <exec+0x320>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045ee:	e1c42503          	lw	a0,-484(s0)
    800045f2:	e6fff0ef          	jal	80004460 <flags2perm>
    800045f6:	86aa                	mv	a3,a0
    800045f8:	8626                	mv	a2,s1
    800045fa:	85ca                	mv	a1,s2
    800045fc:	855a                	mv	a0,s6
    800045fe:	ce3fc0ef          	jal	800012e0 <uvmalloc>
    80004602:	e0a43423          	sd	a0,-504(s0)
    80004606:	18050d63          	beqz	a0,800047a0 <exec+0x326>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000460a:	e2843b83          	ld	s7,-472(s0)
    8000460e:	e2042c03          	lw	s8,-480(s0)
    80004612:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004616:	00098463          	beqz	s3,8000461e <exec+0x1a4>
    8000461a:	4901                	li	s2,0
    8000461c:	bfa1                	j	80004574 <exec+0xfa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000461e:	e0843903          	ld	s2,-504(s0)
    80004622:	bfa5                	j	8000459a <exec+0x120>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004624:	4901                	li	s2,0
  iunlockput(ip);
    80004626:	8552                	mv	a0,s4
    80004628:	e39fe0ef          	jal	80003460 <iunlockput>
  end_op();
    8000462c:	d06ff0ef          	jal	80003b32 <end_op>
  p = myproc();
    80004630:	a00fd0ef          	jal	80001830 <myproc>
    80004634:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004636:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000463a:	6985                	lui	s3,0x1
    8000463c:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000463e:	99ca                	add	s3,s3,s2
    80004640:	77fd                	lui	a5,0xfffff
    80004642:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004646:	4691                	li	a3,4
    80004648:	6609                	lui	a2,0x2
    8000464a:	964e                	add	a2,a2,s3
    8000464c:	85ce                	mv	a1,s3
    8000464e:	855a                	mv	a0,s6
    80004650:	c91fc0ef          	jal	800012e0 <uvmalloc>
    80004654:	892a                	mv	s2,a0
    80004656:	e0a43423          	sd	a0,-504(s0)
    8000465a:	e509                	bnez	a0,80004664 <exec+0x1ea>
  if(pagetable)
    8000465c:	e1343423          	sd	s3,-504(s0)
    80004660:	4a01                	li	s4,0
    80004662:	aa29                	j	8000477c <exec+0x302>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004664:	75f9                	lui	a1,0xffffe
    80004666:	95aa                	add	a1,a1,a0
    80004668:	855a                	mv	a0,s6
    8000466a:	e55fc0ef          	jal	800014be <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    8000466e:	7bfd                	lui	s7,0xfffff
    80004670:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004672:	e0043783          	ld	a5,-512(s0)
    80004676:	6388                	ld	a0,0(a5)
    80004678:	cd39                	beqz	a0,800046d6 <exec+0x25c>
    8000467a:	e9040993          	add	s3,s0,-368
    8000467e:	f9040c13          	add	s8,s0,-112
    80004682:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004684:	f66fc0ef          	jal	80000dea <strlen>
    80004688:	0015079b          	addw	a5,a0,1
    8000468c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004690:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004694:	11796963          	bltu	s2,s7,800047a6 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004698:	e0043d03          	ld	s10,-512(s0)
    8000469c:	000d3a03          	ld	s4,0(s10)
    800046a0:	8552                	mv	a0,s4
    800046a2:	f48fc0ef          	jal	80000dea <strlen>
    800046a6:	0015069b          	addw	a3,a0,1
    800046aa:	8652                	mv	a2,s4
    800046ac:	85ca                	mv	a1,s2
    800046ae:	855a                	mv	a0,s6
    800046b0:	e39fc0ef          	jal	800014e8 <copyout>
    800046b4:	0e054b63          	bltz	a0,800047aa <exec+0x330>
    ustack[argc] = sp;
    800046b8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800046bc:	0485                	add	s1,s1,1
    800046be:	008d0793          	add	a5,s10,8
    800046c2:	e0f43023          	sd	a5,-512(s0)
    800046c6:	008d3503          	ld	a0,8(s10)
    800046ca:	c909                	beqz	a0,800046dc <exec+0x262>
    if(argc >= MAXARG)
    800046cc:	09a1                	add	s3,s3,8
    800046ce:	fb899be3          	bne	s3,s8,80004684 <exec+0x20a>
  ip = 0;
    800046d2:	4a01                	li	s4,0
    800046d4:	a065                	j	8000477c <exec+0x302>
  sp = sz;
    800046d6:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800046da:	4481                	li	s1,0
  ustack[argc] = 0;
    800046dc:	00349793          	sll	a5,s1,0x3
    800046e0:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffddf10>
    800046e4:	97a2                	add	a5,a5,s0
    800046e6:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800046ea:	00148693          	add	a3,s1,1
    800046ee:	068e                	sll	a3,a3,0x3
    800046f0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800046f4:	ff097913          	and	s2,s2,-16
  sz = sz1;
    800046f8:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800046fc:	f77960e3          	bltu	s2,s7,8000465c <exec+0x1e2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004700:	e9040613          	add	a2,s0,-368
    80004704:	85ca                	mv	a1,s2
    80004706:	855a                	mv	a0,s6
    80004708:	de1fc0ef          	jal	800014e8 <copyout>
    8000470c:	0a054163          	bltz	a0,800047ae <exec+0x334>
  p->trapframe->a1 = sp;
    80004710:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004714:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004718:	df843783          	ld	a5,-520(s0)
    8000471c:	0007c703          	lbu	a4,0(a5)
    80004720:	cf11                	beqz	a4,8000473c <exec+0x2c2>
    80004722:	0785                	add	a5,a5,1
    if(*s == '/')
    80004724:	02f00693          	li	a3,47
    80004728:	a039                	j	80004736 <exec+0x2bc>
      last = s+1;
    8000472a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000472e:	0785                	add	a5,a5,1
    80004730:	fff7c703          	lbu	a4,-1(a5)
    80004734:	c701                	beqz	a4,8000473c <exec+0x2c2>
    if(*s == '/')
    80004736:	fed71ce3          	bne	a4,a3,8000472e <exec+0x2b4>
    8000473a:	bfc5                	j	8000472a <exec+0x2b0>
  safestrcpy(p->name, last, sizeof(p->name));
    8000473c:	4641                	li	a2,16
    8000473e:	df843583          	ld	a1,-520(s0)
    80004742:	158a8513          	add	a0,s5,344
    80004746:	e72fc0ef          	jal	80000db8 <safestrcpy>
  oldpagetable = p->pagetable;
    8000474a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000474e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004752:	e0843783          	ld	a5,-504(s0)
    80004756:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000475a:	058ab783          	ld	a5,88(s5)
    8000475e:	e6843703          	ld	a4,-408(s0)
    80004762:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004764:	058ab783          	ld	a5,88(s5)
    80004768:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000476c:	85e6                	mv	a1,s9
    8000476e:	9eefd0ef          	jal	8000195c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004772:	0004851b          	sext.w	a0,s1
    80004776:	b341                	j	800044f6 <exec+0x7c>
    80004778:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000477c:	e0843583          	ld	a1,-504(s0)
    80004780:	855a                	mv	a0,s6
    80004782:	9dafd0ef          	jal	8000195c <proc_freepagetable>
  return -1;
    80004786:	557d                	li	a0,-1
  if(ip){
    80004788:	d60a07e3          	beqz	s4,800044f6 <exec+0x7c>
    8000478c:	bbb9                	j	800044ea <exec+0x70>
    8000478e:	e1243423          	sd	s2,-504(s0)
    80004792:	b7ed                	j	8000477c <exec+0x302>
    80004794:	e1243423          	sd	s2,-504(s0)
    80004798:	b7d5                	j	8000477c <exec+0x302>
    8000479a:	e1243423          	sd	s2,-504(s0)
    8000479e:	bff9                	j	8000477c <exec+0x302>
    800047a0:	e1243423          	sd	s2,-504(s0)
    800047a4:	bfe1                	j	8000477c <exec+0x302>
  ip = 0;
    800047a6:	4a01                	li	s4,0
    800047a8:	bfd1                	j	8000477c <exec+0x302>
    800047aa:	4a01                	li	s4,0
  if(pagetable)
    800047ac:	bfc1                	j	8000477c <exec+0x302>
  sz = sz1;
    800047ae:	e0843983          	ld	s3,-504(s0)
    800047b2:	b56d                	j	8000465c <exec+0x1e2>

00000000800047b4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800047b4:	7179                	add	sp,sp,-48
    800047b6:	f406                	sd	ra,40(sp)
    800047b8:	f022                	sd	s0,32(sp)
    800047ba:	ec26                	sd	s1,24(sp)
    800047bc:	e84a                	sd	s2,16(sp)
    800047be:	1800                	add	s0,sp,48
    800047c0:	892e                	mv	s2,a1
    800047c2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800047c4:	fdc40593          	add	a1,s0,-36
    800047c8:	88efe0ef          	jal	80002856 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800047cc:	fdc42703          	lw	a4,-36(s0)
    800047d0:	47bd                	li	a5,15
    800047d2:	02e7e963          	bltu	a5,a4,80004804 <argfd+0x50>
    800047d6:	85afd0ef          	jal	80001830 <myproc>
    800047da:	fdc42703          	lw	a4,-36(s0)
    800047de:	01a70793          	add	a5,a4,26
    800047e2:	078e                	sll	a5,a5,0x3
    800047e4:	953e                	add	a0,a0,a5
    800047e6:	611c                	ld	a5,0(a0)
    800047e8:	c385                	beqz	a5,80004808 <argfd+0x54>
    return -1;
  if(pfd)
    800047ea:	00090463          	beqz	s2,800047f2 <argfd+0x3e>
    *pfd = fd;
    800047ee:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800047f2:	4501                	li	a0,0
  if(pf)
    800047f4:	c091                	beqz	s1,800047f8 <argfd+0x44>
    *pf = f;
    800047f6:	e09c                	sd	a5,0(s1)
}
    800047f8:	70a2                	ld	ra,40(sp)
    800047fa:	7402                	ld	s0,32(sp)
    800047fc:	64e2                	ld	s1,24(sp)
    800047fe:	6942                	ld	s2,16(sp)
    80004800:	6145                	add	sp,sp,48
    80004802:	8082                	ret
    return -1;
    80004804:	557d                	li	a0,-1
    80004806:	bfcd                	j	800047f8 <argfd+0x44>
    80004808:	557d                	li	a0,-1
    8000480a:	b7fd                	j	800047f8 <argfd+0x44>

000000008000480c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000480c:	1101                	add	sp,sp,-32
    8000480e:	ec06                	sd	ra,24(sp)
    80004810:	e822                	sd	s0,16(sp)
    80004812:	e426                	sd	s1,8(sp)
    80004814:	1000                	add	s0,sp,32
    80004816:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004818:	818fd0ef          	jal	80001830 <myproc>
    8000481c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000481e:	0d050793          	add	a5,a0,208
    80004822:	4501                	li	a0,0
    80004824:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004826:	6398                	ld	a4,0(a5)
    80004828:	cb19                	beqz	a4,8000483e <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    8000482a:	2505                	addw	a0,a0,1
    8000482c:	07a1                	add	a5,a5,8
    8000482e:	fed51ce3          	bne	a0,a3,80004826 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004832:	557d                	li	a0,-1
}
    80004834:	60e2                	ld	ra,24(sp)
    80004836:	6442                	ld	s0,16(sp)
    80004838:	64a2                	ld	s1,8(sp)
    8000483a:	6105                	add	sp,sp,32
    8000483c:	8082                	ret
      p->ofile[fd] = f;
    8000483e:	01a50793          	add	a5,a0,26
    80004842:	078e                	sll	a5,a5,0x3
    80004844:	963e                	add	a2,a2,a5
    80004846:	e204                	sd	s1,0(a2)
      return fd;
    80004848:	b7f5                	j	80004834 <fdalloc+0x28>

000000008000484a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000484a:	715d                	add	sp,sp,-80
    8000484c:	e486                	sd	ra,72(sp)
    8000484e:	e0a2                	sd	s0,64(sp)
    80004850:	fc26                	sd	s1,56(sp)
    80004852:	f84a                	sd	s2,48(sp)
    80004854:	f44e                	sd	s3,40(sp)
    80004856:	f052                	sd	s4,32(sp)
    80004858:	ec56                	sd	s5,24(sp)
    8000485a:	e85a                	sd	s6,16(sp)
    8000485c:	0880                	add	s0,sp,80
    8000485e:	8b2e                	mv	s6,a1
    80004860:	89b2                	mv	s3,a2
    80004862:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004864:	fb040593          	add	a1,s0,-80
    80004868:	8beff0ef          	jal	80003926 <nameiparent>
    8000486c:	84aa                	mv	s1,a0
    8000486e:	10050763          	beqz	a0,8000497c <create+0x132>
    return 0;

  ilock(dp);
    80004872:	9e9fe0ef          	jal	8000325a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004876:	4601                	li	a2,0
    80004878:	fb040593          	add	a1,s0,-80
    8000487c:	8526                	mv	a0,s1
    8000487e:	e29fe0ef          	jal	800036a6 <dirlookup>
    80004882:	8aaa                	mv	s5,a0
    80004884:	c131                	beqz	a0,800048c8 <create+0x7e>
    iunlockput(dp);
    80004886:	8526                	mv	a0,s1
    80004888:	bd9fe0ef          	jal	80003460 <iunlockput>
    ilock(ip);
    8000488c:	8556                	mv	a0,s5
    8000488e:	9cdfe0ef          	jal	8000325a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004892:	4789                	li	a5,2
    80004894:	02fb1563          	bne	s6,a5,800048be <create+0x74>
    80004898:	044ad783          	lhu	a5,68(s5)
    8000489c:	37f9                	addw	a5,a5,-2
    8000489e:	17c2                	sll	a5,a5,0x30
    800048a0:	93c1                	srl	a5,a5,0x30
    800048a2:	4705                	li	a4,1
    800048a4:	00f76d63          	bltu	a4,a5,800048be <create+0x74>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800048a8:	8556                	mv	a0,s5
    800048aa:	60a6                	ld	ra,72(sp)
    800048ac:	6406                	ld	s0,64(sp)
    800048ae:	74e2                	ld	s1,56(sp)
    800048b0:	7942                	ld	s2,48(sp)
    800048b2:	79a2                	ld	s3,40(sp)
    800048b4:	7a02                	ld	s4,32(sp)
    800048b6:	6ae2                	ld	s5,24(sp)
    800048b8:	6b42                	ld	s6,16(sp)
    800048ba:	6161                	add	sp,sp,80
    800048bc:	8082                	ret
    iunlockput(ip);
    800048be:	8556                	mv	a0,s5
    800048c0:	ba1fe0ef          	jal	80003460 <iunlockput>
    return 0;
    800048c4:	4a81                	li	s5,0
    800048c6:	b7cd                	j	800048a8 <create+0x5e>
  if((ip = ialloc(dp->dev, type)) == 0){
    800048c8:	85da                	mv	a1,s6
    800048ca:	4088                	lw	a0,0(s1)
    800048cc:	82bfe0ef          	jal	800030f6 <ialloc>
    800048d0:	8a2a                	mv	s4,a0
    800048d2:	cd0d                	beqz	a0,8000490c <create+0xc2>
  ilock(ip);
    800048d4:	987fe0ef          	jal	8000325a <ilock>
  ip->major = major;
    800048d8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800048dc:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800048e0:	4905                	li	s2,1
    800048e2:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800048e6:	8552                	mv	a0,s4
    800048e8:	8bffe0ef          	jal	800031a6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800048ec:	032b0563          	beq	s6,s2,80004916 <create+0xcc>
  if(dirlink(dp, name, ip->inum) < 0)
    800048f0:	004a2603          	lw	a2,4(s4)
    800048f4:	fb040593          	add	a1,s0,-80
    800048f8:	8526                	mv	a0,s1
    800048fa:	f79fe0ef          	jal	80003872 <dirlink>
    800048fe:	06054363          	bltz	a0,80004964 <create+0x11a>
  iunlockput(dp);
    80004902:	8526                	mv	a0,s1
    80004904:	b5dfe0ef          	jal	80003460 <iunlockput>
  return ip;
    80004908:	8ad2                	mv	s5,s4
    8000490a:	bf79                	j	800048a8 <create+0x5e>
    iunlockput(dp);
    8000490c:	8526                	mv	a0,s1
    8000490e:	b53fe0ef          	jal	80003460 <iunlockput>
    return 0;
    80004912:	8ad2                	mv	s5,s4
    80004914:	bf51                	j	800048a8 <create+0x5e>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004916:	004a2603          	lw	a2,4(s4)
    8000491a:	00003597          	auipc	a1,0x3
    8000491e:	e3658593          	add	a1,a1,-458 # 80007750 <syscalls+0x2c0>
    80004922:	8552                	mv	a0,s4
    80004924:	f4ffe0ef          	jal	80003872 <dirlink>
    80004928:	02054e63          	bltz	a0,80004964 <create+0x11a>
    8000492c:	40d0                	lw	a2,4(s1)
    8000492e:	00003597          	auipc	a1,0x3
    80004932:	e2a58593          	add	a1,a1,-470 # 80007758 <syscalls+0x2c8>
    80004936:	8552                	mv	a0,s4
    80004938:	f3bfe0ef          	jal	80003872 <dirlink>
    8000493c:	02054463          	bltz	a0,80004964 <create+0x11a>
  if(dirlink(dp, name, ip->inum) < 0)
    80004940:	004a2603          	lw	a2,4(s4)
    80004944:	fb040593          	add	a1,s0,-80
    80004948:	8526                	mv	a0,s1
    8000494a:	f29fe0ef          	jal	80003872 <dirlink>
    8000494e:	00054b63          	bltz	a0,80004964 <create+0x11a>
    dp->nlink++;  // for ".."
    80004952:	04a4d783          	lhu	a5,74(s1)
    80004956:	2785                	addw	a5,a5,1
    80004958:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000495c:	8526                	mv	a0,s1
    8000495e:	849fe0ef          	jal	800031a6 <iupdate>
    80004962:	b745                	j	80004902 <create+0xb8>
  ip->nlink = 0;
    80004964:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004968:	8552                	mv	a0,s4
    8000496a:	83dfe0ef          	jal	800031a6 <iupdate>
  iunlockput(ip);
    8000496e:	8552                	mv	a0,s4
    80004970:	af1fe0ef          	jal	80003460 <iunlockput>
  iunlockput(dp);
    80004974:	8526                	mv	a0,s1
    80004976:	aebfe0ef          	jal	80003460 <iunlockput>
  return 0;
    8000497a:	b73d                	j	800048a8 <create+0x5e>
    return 0;
    8000497c:	8aaa                	mv	s5,a0
    8000497e:	b72d                	j	800048a8 <create+0x5e>

0000000080004980 <sys_dup>:
{
    80004980:	7179                	add	sp,sp,-48
    80004982:	f406                	sd	ra,40(sp)
    80004984:	f022                	sd	s0,32(sp)
    80004986:	ec26                	sd	s1,24(sp)
    80004988:	e84a                	sd	s2,16(sp)
    8000498a:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000498c:	fd840613          	add	a2,s0,-40
    80004990:	4581                	li	a1,0
    80004992:	4501                	li	a0,0
    80004994:	e21ff0ef          	jal	800047b4 <argfd>
    return -1;
    80004998:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000499a:	00054f63          	bltz	a0,800049b8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
    8000499e:	fd843903          	ld	s2,-40(s0)
    800049a2:	854a                	mv	a0,s2
    800049a4:	e69ff0ef          	jal	8000480c <fdalloc>
    800049a8:	84aa                	mv	s1,a0
    return -1;
    800049aa:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800049ac:	00054663          	bltz	a0,800049b8 <sys_dup+0x38>
  filedup(f);
    800049b0:	854a                	mv	a0,s2
    800049b2:	ce4ff0ef          	jal	80003e96 <filedup>
  return fd;
    800049b6:	87a6                	mv	a5,s1
}
    800049b8:	853e                	mv	a0,a5
    800049ba:	70a2                	ld	ra,40(sp)
    800049bc:	7402                	ld	s0,32(sp)
    800049be:	64e2                	ld	s1,24(sp)
    800049c0:	6942                	ld	s2,16(sp)
    800049c2:	6145                	add	sp,sp,48
    800049c4:	8082                	ret

00000000800049c6 <sys_read>:
{
    800049c6:	7179                	add	sp,sp,-48
    800049c8:	f406                	sd	ra,40(sp)
    800049ca:	f022                	sd	s0,32(sp)
    800049cc:	1800                	add	s0,sp,48
  argaddr(1, &p);
    800049ce:	fd840593          	add	a1,s0,-40
    800049d2:	4505                	li	a0,1
    800049d4:	e9ffd0ef          	jal	80002872 <argaddr>
  argint(2, &n);
    800049d8:	fe440593          	add	a1,s0,-28
    800049dc:	4509                	li	a0,2
    800049de:	e79fd0ef          	jal	80002856 <argint>
  if(argfd(0, 0, &f) < 0)
    800049e2:	fe840613          	add	a2,s0,-24
    800049e6:	4581                	li	a1,0
    800049e8:	4501                	li	a0,0
    800049ea:	dcbff0ef          	jal	800047b4 <argfd>
    800049ee:	87aa                	mv	a5,a0
    return -1;
    800049f0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049f2:	0007ca63          	bltz	a5,80004a06 <sys_read+0x40>
  return fileread(f, p, n);
    800049f6:	fe442603          	lw	a2,-28(s0)
    800049fa:	fd843583          	ld	a1,-40(s0)
    800049fe:	fe843503          	ld	a0,-24(s0)
    80004a02:	de0ff0ef          	jal	80003fe2 <fileread>
}
    80004a06:	70a2                	ld	ra,40(sp)
    80004a08:	7402                	ld	s0,32(sp)
    80004a0a:	6145                	add	sp,sp,48
    80004a0c:	8082                	ret

0000000080004a0e <sys_write>:
{
    80004a0e:	7179                	add	sp,sp,-48
    80004a10:	f406                	sd	ra,40(sp)
    80004a12:	f022                	sd	s0,32(sp)
    80004a14:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004a16:	fd840593          	add	a1,s0,-40
    80004a1a:	4505                	li	a0,1
    80004a1c:	e57fd0ef          	jal	80002872 <argaddr>
  argint(2, &n);
    80004a20:	fe440593          	add	a1,s0,-28
    80004a24:	4509                	li	a0,2
    80004a26:	e31fd0ef          	jal	80002856 <argint>
  if(argfd(0, 0, &f) < 0)
    80004a2a:	fe840613          	add	a2,s0,-24
    80004a2e:	4581                	li	a1,0
    80004a30:	4501                	li	a0,0
    80004a32:	d83ff0ef          	jal	800047b4 <argfd>
    80004a36:	87aa                	mv	a5,a0
    return -1;
    80004a38:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a3a:	0007ca63          	bltz	a5,80004a4e <sys_write+0x40>
  return filewrite(f, p, n);
    80004a3e:	fe442603          	lw	a2,-28(s0)
    80004a42:	fd843583          	ld	a1,-40(s0)
    80004a46:	fe843503          	ld	a0,-24(s0)
    80004a4a:	e46ff0ef          	jal	80004090 <filewrite>
}
    80004a4e:	70a2                	ld	ra,40(sp)
    80004a50:	7402                	ld	s0,32(sp)
    80004a52:	6145                	add	sp,sp,48
    80004a54:	8082                	ret

0000000080004a56 <sys_close>:
{
    80004a56:	1101                	add	sp,sp,-32
    80004a58:	ec06                	sd	ra,24(sp)
    80004a5a:	e822                	sd	s0,16(sp)
    80004a5c:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004a5e:	fe040613          	add	a2,s0,-32
    80004a62:	fec40593          	add	a1,s0,-20
    80004a66:	4501                	li	a0,0
    80004a68:	d4dff0ef          	jal	800047b4 <argfd>
    return -1;
    80004a6c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004a6e:	02054063          	bltz	a0,80004a8e <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004a72:	dbffc0ef          	jal	80001830 <myproc>
    80004a76:	fec42783          	lw	a5,-20(s0)
    80004a7a:	07e9                	add	a5,a5,26
    80004a7c:	078e                	sll	a5,a5,0x3
    80004a7e:	953e                	add	a0,a0,a5
    80004a80:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004a84:	fe043503          	ld	a0,-32(s0)
    80004a88:	c54ff0ef          	jal	80003edc <fileclose>
  return 0;
    80004a8c:	4781                	li	a5,0
}
    80004a8e:	853e                	mv	a0,a5
    80004a90:	60e2                	ld	ra,24(sp)
    80004a92:	6442                	ld	s0,16(sp)
    80004a94:	6105                	add	sp,sp,32
    80004a96:	8082                	ret

0000000080004a98 <sys_fstat>:
{
    80004a98:	1101                	add	sp,sp,-32
    80004a9a:	ec06                	sd	ra,24(sp)
    80004a9c:	e822                	sd	s0,16(sp)
    80004a9e:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80004aa0:	fe040593          	add	a1,s0,-32
    80004aa4:	4505                	li	a0,1
    80004aa6:	dcdfd0ef          	jal	80002872 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004aaa:	fe840613          	add	a2,s0,-24
    80004aae:	4581                	li	a1,0
    80004ab0:	4501                	li	a0,0
    80004ab2:	d03ff0ef          	jal	800047b4 <argfd>
    80004ab6:	87aa                	mv	a5,a0
    return -1;
    80004ab8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004aba:	0007c863          	bltz	a5,80004aca <sys_fstat+0x32>
  return filestat(f, st);
    80004abe:	fe043583          	ld	a1,-32(s0)
    80004ac2:	fe843503          	ld	a0,-24(s0)
    80004ac6:	cbeff0ef          	jal	80003f84 <filestat>
}
    80004aca:	60e2                	ld	ra,24(sp)
    80004acc:	6442                	ld	s0,16(sp)
    80004ace:	6105                	add	sp,sp,32
    80004ad0:	8082                	ret

0000000080004ad2 <sys_link>:
{
    80004ad2:	7169                	add	sp,sp,-304
    80004ad4:	f606                	sd	ra,296(sp)
    80004ad6:	f222                	sd	s0,288(sp)
    80004ad8:	ee26                	sd	s1,280(sp)
    80004ada:	ea4a                	sd	s2,272(sp)
    80004adc:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ade:	08000613          	li	a2,128
    80004ae2:	ed040593          	add	a1,s0,-304
    80004ae6:	4501                	li	a0,0
    80004ae8:	da7fd0ef          	jal	8000288e <argstr>
    return -1;
    80004aec:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004aee:	0c054663          	bltz	a0,80004bba <sys_link+0xe8>
    80004af2:	08000613          	li	a2,128
    80004af6:	f5040593          	add	a1,s0,-176
    80004afa:	4505                	li	a0,1
    80004afc:	d93fd0ef          	jal	8000288e <argstr>
    return -1;
    80004b00:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b02:	0a054c63          	bltz	a0,80004bba <sys_link+0xe8>
  begin_op();
    80004b06:	fc3fe0ef          	jal	80003ac8 <begin_op>
  if((ip = namei(old)) == 0){
    80004b0a:	ed040513          	add	a0,s0,-304
    80004b0e:	dfffe0ef          	jal	8000390c <namei>
    80004b12:	84aa                	mv	s1,a0
    80004b14:	c525                	beqz	a0,80004b7c <sys_link+0xaa>
  ilock(ip);
    80004b16:	f44fe0ef          	jal	8000325a <ilock>
  if(ip->type == T_DIR){
    80004b1a:	04449703          	lh	a4,68(s1)
    80004b1e:	4785                	li	a5,1
    80004b20:	06f70263          	beq	a4,a5,80004b84 <sys_link+0xb2>
  ip->nlink++;
    80004b24:	04a4d783          	lhu	a5,74(s1)
    80004b28:	2785                	addw	a5,a5,1
    80004b2a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b2e:	8526                	mv	a0,s1
    80004b30:	e76fe0ef          	jal	800031a6 <iupdate>
  iunlock(ip);
    80004b34:	8526                	mv	a0,s1
    80004b36:	fcefe0ef          	jal	80003304 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004b3a:	fd040593          	add	a1,s0,-48
    80004b3e:	f5040513          	add	a0,s0,-176
    80004b42:	de5fe0ef          	jal	80003926 <nameiparent>
    80004b46:	892a                	mv	s2,a0
    80004b48:	c921                	beqz	a0,80004b98 <sys_link+0xc6>
  ilock(dp);
    80004b4a:	f10fe0ef          	jal	8000325a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b4e:	00092703          	lw	a4,0(s2)
    80004b52:	409c                	lw	a5,0(s1)
    80004b54:	02f71f63          	bne	a4,a5,80004b92 <sys_link+0xc0>
    80004b58:	40d0                	lw	a2,4(s1)
    80004b5a:	fd040593          	add	a1,s0,-48
    80004b5e:	854a                	mv	a0,s2
    80004b60:	d13fe0ef          	jal	80003872 <dirlink>
    80004b64:	02054763          	bltz	a0,80004b92 <sys_link+0xc0>
  iunlockput(dp);
    80004b68:	854a                	mv	a0,s2
    80004b6a:	8f7fe0ef          	jal	80003460 <iunlockput>
  iput(ip);
    80004b6e:	8526                	mv	a0,s1
    80004b70:	869fe0ef          	jal	800033d8 <iput>
  end_op();
    80004b74:	fbffe0ef          	jal	80003b32 <end_op>
  return 0;
    80004b78:	4781                	li	a5,0
    80004b7a:	a081                	j	80004bba <sys_link+0xe8>
    end_op();
    80004b7c:	fb7fe0ef          	jal	80003b32 <end_op>
    return -1;
    80004b80:	57fd                	li	a5,-1
    80004b82:	a825                	j	80004bba <sys_link+0xe8>
    iunlockput(ip);
    80004b84:	8526                	mv	a0,s1
    80004b86:	8dbfe0ef          	jal	80003460 <iunlockput>
    end_op();
    80004b8a:	fa9fe0ef          	jal	80003b32 <end_op>
    return -1;
    80004b8e:	57fd                	li	a5,-1
    80004b90:	a02d                	j	80004bba <sys_link+0xe8>
    iunlockput(dp);
    80004b92:	854a                	mv	a0,s2
    80004b94:	8cdfe0ef          	jal	80003460 <iunlockput>
  ilock(ip);
    80004b98:	8526                	mv	a0,s1
    80004b9a:	ec0fe0ef          	jal	8000325a <ilock>
  ip->nlink--;
    80004b9e:	04a4d783          	lhu	a5,74(s1)
    80004ba2:	37fd                	addw	a5,a5,-1
    80004ba4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ba8:	8526                	mv	a0,s1
    80004baa:	dfcfe0ef          	jal	800031a6 <iupdate>
  iunlockput(ip);
    80004bae:	8526                	mv	a0,s1
    80004bb0:	8b1fe0ef          	jal	80003460 <iunlockput>
  end_op();
    80004bb4:	f7ffe0ef          	jal	80003b32 <end_op>
  return -1;
    80004bb8:	57fd                	li	a5,-1
}
    80004bba:	853e                	mv	a0,a5
    80004bbc:	70b2                	ld	ra,296(sp)
    80004bbe:	7412                	ld	s0,288(sp)
    80004bc0:	64f2                	ld	s1,280(sp)
    80004bc2:	6952                	ld	s2,272(sp)
    80004bc4:	6155                	add	sp,sp,304
    80004bc6:	8082                	ret

0000000080004bc8 <sys_unlink>:
{
    80004bc8:	7151                	add	sp,sp,-240
    80004bca:	f586                	sd	ra,232(sp)
    80004bcc:	f1a2                	sd	s0,224(sp)
    80004bce:	eda6                	sd	s1,216(sp)
    80004bd0:	e9ca                	sd	s2,208(sp)
    80004bd2:	e5ce                	sd	s3,200(sp)
    80004bd4:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004bd6:	08000613          	li	a2,128
    80004bda:	f3040593          	add	a1,s0,-208
    80004bde:	4501                	li	a0,0
    80004be0:	caffd0ef          	jal	8000288e <argstr>
    80004be4:	12054b63          	bltz	a0,80004d1a <sys_unlink+0x152>
  begin_op();
    80004be8:	ee1fe0ef          	jal	80003ac8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004bec:	fb040593          	add	a1,s0,-80
    80004bf0:	f3040513          	add	a0,s0,-208
    80004bf4:	d33fe0ef          	jal	80003926 <nameiparent>
    80004bf8:	84aa                	mv	s1,a0
    80004bfa:	c54d                	beqz	a0,80004ca4 <sys_unlink+0xdc>
  ilock(dp);
    80004bfc:	e5efe0ef          	jal	8000325a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c00:	00003597          	auipc	a1,0x3
    80004c04:	b5058593          	add	a1,a1,-1200 # 80007750 <syscalls+0x2c0>
    80004c08:	fb040513          	add	a0,s0,-80
    80004c0c:	a85fe0ef          	jal	80003690 <namecmp>
    80004c10:	10050a63          	beqz	a0,80004d24 <sys_unlink+0x15c>
    80004c14:	00003597          	auipc	a1,0x3
    80004c18:	b4458593          	add	a1,a1,-1212 # 80007758 <syscalls+0x2c8>
    80004c1c:	fb040513          	add	a0,s0,-80
    80004c20:	a71fe0ef          	jal	80003690 <namecmp>
    80004c24:	10050063          	beqz	a0,80004d24 <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c28:	f2c40613          	add	a2,s0,-212
    80004c2c:	fb040593          	add	a1,s0,-80
    80004c30:	8526                	mv	a0,s1
    80004c32:	a75fe0ef          	jal	800036a6 <dirlookup>
    80004c36:	892a                	mv	s2,a0
    80004c38:	0e050663          	beqz	a0,80004d24 <sys_unlink+0x15c>
  ilock(ip);
    80004c3c:	e1efe0ef          	jal	8000325a <ilock>
  if(ip->nlink < 1)
    80004c40:	04a91783          	lh	a5,74(s2)
    80004c44:	06f05463          	blez	a5,80004cac <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c48:	04491703          	lh	a4,68(s2)
    80004c4c:	4785                	li	a5,1
    80004c4e:	06f70563          	beq	a4,a5,80004cb8 <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004c52:	4641                	li	a2,16
    80004c54:	4581                	li	a1,0
    80004c56:	fc040513          	add	a0,s0,-64
    80004c5a:	81afc0ef          	jal	80000c74 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c5e:	4741                	li	a4,16
    80004c60:	f2c42683          	lw	a3,-212(s0)
    80004c64:	fc040613          	add	a2,s0,-64
    80004c68:	4581                	li	a1,0
    80004c6a:	8526                	mv	a0,s1
    80004c6c:	923fe0ef          	jal	8000358e <writei>
    80004c70:	47c1                	li	a5,16
    80004c72:	08f51563          	bne	a0,a5,80004cfc <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004c76:	04491703          	lh	a4,68(s2)
    80004c7a:	4785                	li	a5,1
    80004c7c:	08f70663          	beq	a4,a5,80004d08 <sys_unlink+0x140>
  iunlockput(dp);
    80004c80:	8526                	mv	a0,s1
    80004c82:	fdefe0ef          	jal	80003460 <iunlockput>
  ip->nlink--;
    80004c86:	04a95783          	lhu	a5,74(s2)
    80004c8a:	37fd                	addw	a5,a5,-1
    80004c8c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c90:	854a                	mv	a0,s2
    80004c92:	d14fe0ef          	jal	800031a6 <iupdate>
  iunlockput(ip);
    80004c96:	854a                	mv	a0,s2
    80004c98:	fc8fe0ef          	jal	80003460 <iunlockput>
  end_op();
    80004c9c:	e97fe0ef          	jal	80003b32 <end_op>
  return 0;
    80004ca0:	4501                	li	a0,0
    80004ca2:	a079                	j	80004d30 <sys_unlink+0x168>
    end_op();
    80004ca4:	e8ffe0ef          	jal	80003b32 <end_op>
    return -1;
    80004ca8:	557d                	li	a0,-1
    80004caa:	a059                	j	80004d30 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004cac:	00003517          	auipc	a0,0x3
    80004cb0:	ab450513          	add	a0,a0,-1356 # 80007760 <syscalls+0x2d0>
    80004cb4:	aabfb0ef          	jal	8000075e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cb8:	04c92703          	lw	a4,76(s2)
    80004cbc:	02000793          	li	a5,32
    80004cc0:	f8e7f9e3          	bgeu	a5,a4,80004c52 <sys_unlink+0x8a>
    80004cc4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cc8:	4741                	li	a4,16
    80004cca:	86ce                	mv	a3,s3
    80004ccc:	f1840613          	add	a2,s0,-232
    80004cd0:	4581                	li	a1,0
    80004cd2:	854a                	mv	a0,s2
    80004cd4:	fd6fe0ef          	jal	800034aa <readi>
    80004cd8:	47c1                	li	a5,16
    80004cda:	00f51b63          	bne	a0,a5,80004cf0 <sys_unlink+0x128>
    if(de.inum != 0)
    80004cde:	f1845783          	lhu	a5,-232(s0)
    80004ce2:	ef95                	bnez	a5,80004d1e <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ce4:	29c1                	addw	s3,s3,16
    80004ce6:	04c92783          	lw	a5,76(s2)
    80004cea:	fcf9efe3          	bltu	s3,a5,80004cc8 <sys_unlink+0x100>
    80004cee:	b795                	j	80004c52 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004cf0:	00003517          	auipc	a0,0x3
    80004cf4:	a8850513          	add	a0,a0,-1400 # 80007778 <syscalls+0x2e8>
    80004cf8:	a67fb0ef          	jal	8000075e <panic>
    panic("unlink: writei");
    80004cfc:	00003517          	auipc	a0,0x3
    80004d00:	a9450513          	add	a0,a0,-1388 # 80007790 <syscalls+0x300>
    80004d04:	a5bfb0ef          	jal	8000075e <panic>
    dp->nlink--;
    80004d08:	04a4d783          	lhu	a5,74(s1)
    80004d0c:	37fd                	addw	a5,a5,-1
    80004d0e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d12:	8526                	mv	a0,s1
    80004d14:	c92fe0ef          	jal	800031a6 <iupdate>
    80004d18:	b7a5                	j	80004c80 <sys_unlink+0xb8>
    return -1;
    80004d1a:	557d                	li	a0,-1
    80004d1c:	a811                	j	80004d30 <sys_unlink+0x168>
    iunlockput(ip);
    80004d1e:	854a                	mv	a0,s2
    80004d20:	f40fe0ef          	jal	80003460 <iunlockput>
  iunlockput(dp);
    80004d24:	8526                	mv	a0,s1
    80004d26:	f3afe0ef          	jal	80003460 <iunlockput>
  end_op();
    80004d2a:	e09fe0ef          	jal	80003b32 <end_op>
  return -1;
    80004d2e:	557d                	li	a0,-1
}
    80004d30:	70ae                	ld	ra,232(sp)
    80004d32:	740e                	ld	s0,224(sp)
    80004d34:	64ee                	ld	s1,216(sp)
    80004d36:	694e                	ld	s2,208(sp)
    80004d38:	69ae                	ld	s3,200(sp)
    80004d3a:	616d                	add	sp,sp,240
    80004d3c:	8082                	ret

0000000080004d3e <sys_open>:

uint64
sys_open(void)
{
    80004d3e:	7131                	add	sp,sp,-192
    80004d40:	fd06                	sd	ra,184(sp)
    80004d42:	f922                	sd	s0,176(sp)
    80004d44:	f526                	sd	s1,168(sp)
    80004d46:	f14a                	sd	s2,160(sp)
    80004d48:	ed4e                	sd	s3,152(sp)
    80004d4a:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d4c:	f4c40593          	add	a1,s0,-180
    80004d50:	4505                	li	a0,1
    80004d52:	b05fd0ef          	jal	80002856 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d56:	08000613          	li	a2,128
    80004d5a:	f5040593          	add	a1,s0,-176
    80004d5e:	4501                	li	a0,0
    80004d60:	b2ffd0ef          	jal	8000288e <argstr>
    80004d64:	87aa                	mv	a5,a0
    return -1;
    80004d66:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d68:	0807cc63          	bltz	a5,80004e00 <sys_open+0xc2>

  begin_op();
    80004d6c:	d5dfe0ef          	jal	80003ac8 <begin_op>

  if(omode & O_CREATE){
    80004d70:	f4c42783          	lw	a5,-180(s0)
    80004d74:	2007f793          	and	a5,a5,512
    80004d78:	cfd9                	beqz	a5,80004e16 <sys_open+0xd8>
    ip = create(path, T_FILE, 0, 0);
    80004d7a:	4681                	li	a3,0
    80004d7c:	4601                	li	a2,0
    80004d7e:	4589                	li	a1,2
    80004d80:	f5040513          	add	a0,s0,-176
    80004d84:	ac7ff0ef          	jal	8000484a <create>
    80004d88:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d8a:	c151                	beqz	a0,80004e0e <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d8c:	04449703          	lh	a4,68(s1)
    80004d90:	478d                	li	a5,3
    80004d92:	00f71763          	bne	a4,a5,80004da0 <sys_open+0x62>
    80004d96:	0464d703          	lhu	a4,70(s1)
    80004d9a:	47a5                	li	a5,9
    80004d9c:	0ae7e863          	bltu	a5,a4,80004e4c <sys_open+0x10e>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004da0:	898ff0ef          	jal	80003e38 <filealloc>
    80004da4:	892a                	mv	s2,a0
    80004da6:	cd4d                	beqz	a0,80004e60 <sys_open+0x122>
    80004da8:	a65ff0ef          	jal	8000480c <fdalloc>
    80004dac:	89aa                	mv	s3,a0
    80004dae:	0a054663          	bltz	a0,80004e5a <sys_open+0x11c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004db2:	04449703          	lh	a4,68(s1)
    80004db6:	478d                	li	a5,3
    80004db8:	0af70b63          	beq	a4,a5,80004e6e <sys_open+0x130>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dbc:	4789                	li	a5,2
    80004dbe:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004dc2:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004dc6:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004dca:	f4c42783          	lw	a5,-180(s0)
    80004dce:	0017c713          	xor	a4,a5,1
    80004dd2:	8b05                	and	a4,a4,1
    80004dd4:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004dd8:	0037f713          	and	a4,a5,3
    80004ddc:	00e03733          	snez	a4,a4
    80004de0:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004de4:	4007f793          	and	a5,a5,1024
    80004de8:	c791                	beqz	a5,80004df4 <sys_open+0xb6>
    80004dea:	04449703          	lh	a4,68(s1)
    80004dee:	4789                	li	a5,2
    80004df0:	08f70663          	beq	a4,a5,80004e7c <sys_open+0x13e>
    itrunc(ip);
  }

  iunlock(ip);
    80004df4:	8526                	mv	a0,s1
    80004df6:	d0efe0ef          	jal	80003304 <iunlock>
  end_op();
    80004dfa:	d39fe0ef          	jal	80003b32 <end_op>

  return fd;
    80004dfe:	854e                	mv	a0,s3
}
    80004e00:	70ea                	ld	ra,184(sp)
    80004e02:	744a                	ld	s0,176(sp)
    80004e04:	74aa                	ld	s1,168(sp)
    80004e06:	790a                	ld	s2,160(sp)
    80004e08:	69ea                	ld	s3,152(sp)
    80004e0a:	6129                	add	sp,sp,192
    80004e0c:	8082                	ret
      end_op();
    80004e0e:	d25fe0ef          	jal	80003b32 <end_op>
      return -1;
    80004e12:	557d                	li	a0,-1
    80004e14:	b7f5                	j	80004e00 <sys_open+0xc2>
    if((ip = namei(path)) == 0){
    80004e16:	f5040513          	add	a0,s0,-176
    80004e1a:	af3fe0ef          	jal	8000390c <namei>
    80004e1e:	84aa                	mv	s1,a0
    80004e20:	c115                	beqz	a0,80004e44 <sys_open+0x106>
    ilock(ip);
    80004e22:	c38fe0ef          	jal	8000325a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e26:	04449703          	lh	a4,68(s1)
    80004e2a:	4785                	li	a5,1
    80004e2c:	f6f710e3          	bne	a4,a5,80004d8c <sys_open+0x4e>
    80004e30:	f4c42783          	lw	a5,-180(s0)
    80004e34:	d7b5                	beqz	a5,80004da0 <sys_open+0x62>
      iunlockput(ip);
    80004e36:	8526                	mv	a0,s1
    80004e38:	e28fe0ef          	jal	80003460 <iunlockput>
      end_op();
    80004e3c:	cf7fe0ef          	jal	80003b32 <end_op>
      return -1;
    80004e40:	557d                	li	a0,-1
    80004e42:	bf7d                	j	80004e00 <sys_open+0xc2>
      end_op();
    80004e44:	ceffe0ef          	jal	80003b32 <end_op>
      return -1;
    80004e48:	557d                	li	a0,-1
    80004e4a:	bf5d                	j	80004e00 <sys_open+0xc2>
    iunlockput(ip);
    80004e4c:	8526                	mv	a0,s1
    80004e4e:	e12fe0ef          	jal	80003460 <iunlockput>
    end_op();
    80004e52:	ce1fe0ef          	jal	80003b32 <end_op>
    return -1;
    80004e56:	557d                	li	a0,-1
    80004e58:	b765                	j	80004e00 <sys_open+0xc2>
      fileclose(f);
    80004e5a:	854a                	mv	a0,s2
    80004e5c:	880ff0ef          	jal	80003edc <fileclose>
    iunlockput(ip);
    80004e60:	8526                	mv	a0,s1
    80004e62:	dfefe0ef          	jal	80003460 <iunlockput>
    end_op();
    80004e66:	ccdfe0ef          	jal	80003b32 <end_op>
    return -1;
    80004e6a:	557d                	li	a0,-1
    80004e6c:	bf51                	j	80004e00 <sys_open+0xc2>
    f->type = FD_DEVICE;
    80004e6e:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004e72:	04649783          	lh	a5,70(s1)
    80004e76:	02f91223          	sh	a5,36(s2)
    80004e7a:	b7b1                	j	80004dc6 <sys_open+0x88>
    itrunc(ip);
    80004e7c:	8526                	mv	a0,s1
    80004e7e:	cc6fe0ef          	jal	80003344 <itrunc>
    80004e82:	bf8d                	j	80004df4 <sys_open+0xb6>

0000000080004e84 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e84:	7175                	add	sp,sp,-144
    80004e86:	e506                	sd	ra,136(sp)
    80004e88:	e122                	sd	s0,128(sp)
    80004e8a:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e8c:	c3dfe0ef          	jal	80003ac8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e90:	08000613          	li	a2,128
    80004e94:	f7040593          	add	a1,s0,-144
    80004e98:	4501                	li	a0,0
    80004e9a:	9f5fd0ef          	jal	8000288e <argstr>
    80004e9e:	02054363          	bltz	a0,80004ec4 <sys_mkdir+0x40>
    80004ea2:	4681                	li	a3,0
    80004ea4:	4601                	li	a2,0
    80004ea6:	4585                	li	a1,1
    80004ea8:	f7040513          	add	a0,s0,-144
    80004eac:	99fff0ef          	jal	8000484a <create>
    80004eb0:	c911                	beqz	a0,80004ec4 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eb2:	daefe0ef          	jal	80003460 <iunlockput>
  end_op();
    80004eb6:	c7dfe0ef          	jal	80003b32 <end_op>
  return 0;
    80004eba:	4501                	li	a0,0
}
    80004ebc:	60aa                	ld	ra,136(sp)
    80004ebe:	640a                	ld	s0,128(sp)
    80004ec0:	6149                	add	sp,sp,144
    80004ec2:	8082                	ret
    end_op();
    80004ec4:	c6ffe0ef          	jal	80003b32 <end_op>
    return -1;
    80004ec8:	557d                	li	a0,-1
    80004eca:	bfcd                	j	80004ebc <sys_mkdir+0x38>

0000000080004ecc <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ecc:	7135                	add	sp,sp,-160
    80004ece:	ed06                	sd	ra,152(sp)
    80004ed0:	e922                	sd	s0,144(sp)
    80004ed2:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ed4:	bf5fe0ef          	jal	80003ac8 <begin_op>
  argint(1, &major);
    80004ed8:	f6c40593          	add	a1,s0,-148
    80004edc:	4505                	li	a0,1
    80004ede:	979fd0ef          	jal	80002856 <argint>
  argint(2, &minor);
    80004ee2:	f6840593          	add	a1,s0,-152
    80004ee6:	4509                	li	a0,2
    80004ee8:	96ffd0ef          	jal	80002856 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eec:	08000613          	li	a2,128
    80004ef0:	f7040593          	add	a1,s0,-144
    80004ef4:	4501                	li	a0,0
    80004ef6:	999fd0ef          	jal	8000288e <argstr>
    80004efa:	02054563          	bltz	a0,80004f24 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004efe:	f6841683          	lh	a3,-152(s0)
    80004f02:	f6c41603          	lh	a2,-148(s0)
    80004f06:	458d                	li	a1,3
    80004f08:	f7040513          	add	a0,s0,-144
    80004f0c:	93fff0ef          	jal	8000484a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f10:	c911                	beqz	a0,80004f24 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f12:	d4efe0ef          	jal	80003460 <iunlockput>
  end_op();
    80004f16:	c1dfe0ef          	jal	80003b32 <end_op>
  return 0;
    80004f1a:	4501                	li	a0,0
}
    80004f1c:	60ea                	ld	ra,152(sp)
    80004f1e:	644a                	ld	s0,144(sp)
    80004f20:	610d                	add	sp,sp,160
    80004f22:	8082                	ret
    end_op();
    80004f24:	c0ffe0ef          	jal	80003b32 <end_op>
    return -1;
    80004f28:	557d                	li	a0,-1
    80004f2a:	bfcd                	j	80004f1c <sys_mknod+0x50>

0000000080004f2c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f2c:	7135                	add	sp,sp,-160
    80004f2e:	ed06                	sd	ra,152(sp)
    80004f30:	e922                	sd	s0,144(sp)
    80004f32:	e526                	sd	s1,136(sp)
    80004f34:	e14a                	sd	s2,128(sp)
    80004f36:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f38:	8f9fc0ef          	jal	80001830 <myproc>
    80004f3c:	892a                	mv	s2,a0
  
  begin_op();
    80004f3e:	b8bfe0ef          	jal	80003ac8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f42:	08000613          	li	a2,128
    80004f46:	f6040593          	add	a1,s0,-160
    80004f4a:	4501                	li	a0,0
    80004f4c:	943fd0ef          	jal	8000288e <argstr>
    80004f50:	04054163          	bltz	a0,80004f92 <sys_chdir+0x66>
    80004f54:	f6040513          	add	a0,s0,-160
    80004f58:	9b5fe0ef          	jal	8000390c <namei>
    80004f5c:	84aa                	mv	s1,a0
    80004f5e:	c915                	beqz	a0,80004f92 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f60:	afafe0ef          	jal	8000325a <ilock>
  if(ip->type != T_DIR){
    80004f64:	04449703          	lh	a4,68(s1)
    80004f68:	4785                	li	a5,1
    80004f6a:	02f71863          	bne	a4,a5,80004f9a <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f6e:	8526                	mv	a0,s1
    80004f70:	b94fe0ef          	jal	80003304 <iunlock>
  iput(p->cwd);
    80004f74:	15093503          	ld	a0,336(s2)
    80004f78:	c60fe0ef          	jal	800033d8 <iput>
  end_op();
    80004f7c:	bb7fe0ef          	jal	80003b32 <end_op>
  p->cwd = ip;
    80004f80:	14993823          	sd	s1,336(s2)
  return 0;
    80004f84:	4501                	li	a0,0
}
    80004f86:	60ea                	ld	ra,152(sp)
    80004f88:	644a                	ld	s0,144(sp)
    80004f8a:	64aa                	ld	s1,136(sp)
    80004f8c:	690a                	ld	s2,128(sp)
    80004f8e:	610d                	add	sp,sp,160
    80004f90:	8082                	ret
    end_op();
    80004f92:	ba1fe0ef          	jal	80003b32 <end_op>
    return -1;
    80004f96:	557d                	li	a0,-1
    80004f98:	b7fd                	j	80004f86 <sys_chdir+0x5a>
    iunlockput(ip);
    80004f9a:	8526                	mv	a0,s1
    80004f9c:	cc4fe0ef          	jal	80003460 <iunlockput>
    end_op();
    80004fa0:	b93fe0ef          	jal	80003b32 <end_op>
    return -1;
    80004fa4:	557d                	li	a0,-1
    80004fa6:	b7c5                	j	80004f86 <sys_chdir+0x5a>

0000000080004fa8 <sys_exec>:

uint64
sys_exec(void)
{
    80004fa8:	7121                	add	sp,sp,-448
    80004faa:	ff06                	sd	ra,440(sp)
    80004fac:	fb22                	sd	s0,432(sp)
    80004fae:	f726                	sd	s1,424(sp)
    80004fb0:	f34a                	sd	s2,416(sp)
    80004fb2:	ef4e                	sd	s3,408(sp)
    80004fb4:	eb52                	sd	s4,400(sp)
    80004fb6:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004fb8:	e4840593          	add	a1,s0,-440
    80004fbc:	4505                	li	a0,1
    80004fbe:	8b5fd0ef          	jal	80002872 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004fc2:	08000613          	li	a2,128
    80004fc6:	f5040593          	add	a1,s0,-176
    80004fca:	4501                	li	a0,0
    80004fcc:	8c3fd0ef          	jal	8000288e <argstr>
    80004fd0:	87aa                	mv	a5,a0
    return -1;
    80004fd2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004fd4:	0a07c463          	bltz	a5,8000507c <sys_exec+0xd4>
  }
  memset(argv, 0, sizeof(argv));
    80004fd8:	10000613          	li	a2,256
    80004fdc:	4581                	li	a1,0
    80004fde:	e5040513          	add	a0,s0,-432
    80004fe2:	c93fb0ef          	jal	80000c74 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fe6:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004fea:	89a6                	mv	s3,s1
    80004fec:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fee:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ff2:	00391513          	sll	a0,s2,0x3
    80004ff6:	e4040593          	add	a1,s0,-448
    80004ffa:	e4843783          	ld	a5,-440(s0)
    80004ffe:	953e                	add	a0,a0,a5
    80005000:	fccfd0ef          	jal	800027cc <fetchaddr>
    80005004:	02054663          	bltz	a0,80005030 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80005008:	e4043783          	ld	a5,-448(s0)
    8000500c:	cf8d                	beqz	a5,80005046 <sys_exec+0x9e>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000500e:	ac3fb0ef          	jal	80000ad0 <kalloc>
    80005012:	85aa                	mv	a1,a0
    80005014:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005018:	cd01                	beqz	a0,80005030 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000501a:	6605                	lui	a2,0x1
    8000501c:	e4043503          	ld	a0,-448(s0)
    80005020:	ff6fd0ef          	jal	80002816 <fetchstr>
    80005024:	00054663          	bltz	a0,80005030 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80005028:	0905                	add	s2,s2,1
    8000502a:	09a1                	add	s3,s3,8
    8000502c:	fd4913e3          	bne	s2,s4,80004ff2 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005030:	f5040913          	add	s2,s0,-176
    80005034:	6088                	ld	a0,0(s1)
    80005036:	c131                	beqz	a0,8000507a <sys_exec+0xd2>
    kfree(argv[i]);
    80005038:	9b7fb0ef          	jal	800009ee <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000503c:	04a1                	add	s1,s1,8
    8000503e:	ff249be3          	bne	s1,s2,80005034 <sys_exec+0x8c>
  return -1;
    80005042:	557d                	li	a0,-1
    80005044:	a825                	j	8000507c <sys_exec+0xd4>
      argv[i] = 0;
    80005046:	0009079b          	sext.w	a5,s2
    8000504a:	078e                	sll	a5,a5,0x3
    8000504c:	fd078793          	add	a5,a5,-48
    80005050:	97a2                	add	a5,a5,s0
    80005052:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005056:	e5040593          	add	a1,s0,-432
    8000505a:	f5040513          	add	a0,s0,-176
    8000505e:	c1cff0ef          	jal	8000447a <exec>
    80005062:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005064:	f5040993          	add	s3,s0,-176
    80005068:	6088                	ld	a0,0(s1)
    8000506a:	c511                	beqz	a0,80005076 <sys_exec+0xce>
    kfree(argv[i]);
    8000506c:	983fb0ef          	jal	800009ee <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005070:	04a1                	add	s1,s1,8
    80005072:	ff349be3          	bne	s1,s3,80005068 <sys_exec+0xc0>
  return ret;
    80005076:	854a                	mv	a0,s2
    80005078:	a011                	j	8000507c <sys_exec+0xd4>
  return -1;
    8000507a:	557d                	li	a0,-1
}
    8000507c:	70fa                	ld	ra,440(sp)
    8000507e:	745a                	ld	s0,432(sp)
    80005080:	74ba                	ld	s1,424(sp)
    80005082:	791a                	ld	s2,416(sp)
    80005084:	69fa                	ld	s3,408(sp)
    80005086:	6a5a                	ld	s4,400(sp)
    80005088:	6139                	add	sp,sp,448
    8000508a:	8082                	ret

000000008000508c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000508c:	7139                	add	sp,sp,-64
    8000508e:	fc06                	sd	ra,56(sp)
    80005090:	f822                	sd	s0,48(sp)
    80005092:	f426                	sd	s1,40(sp)
    80005094:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005096:	f9afc0ef          	jal	80001830 <myproc>
    8000509a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000509c:	fd840593          	add	a1,s0,-40
    800050a0:	4501                	li	a0,0
    800050a2:	fd0fd0ef          	jal	80002872 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800050a6:	fc840593          	add	a1,s0,-56
    800050aa:	fd040513          	add	a0,s0,-48
    800050ae:	8f6ff0ef          	jal	800041a4 <pipealloc>
    return -1;
    800050b2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050b4:	0a054463          	bltz	a0,8000515c <sys_pipe+0xd0>
  fd0 = -1;
    800050b8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050bc:	fd043503          	ld	a0,-48(s0)
    800050c0:	f4cff0ef          	jal	8000480c <fdalloc>
    800050c4:	fca42223          	sw	a0,-60(s0)
    800050c8:	08054163          	bltz	a0,8000514a <sys_pipe+0xbe>
    800050cc:	fc843503          	ld	a0,-56(s0)
    800050d0:	f3cff0ef          	jal	8000480c <fdalloc>
    800050d4:	fca42023          	sw	a0,-64(s0)
    800050d8:	06054063          	bltz	a0,80005138 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050dc:	4691                	li	a3,4
    800050de:	fc440613          	add	a2,s0,-60
    800050e2:	fd843583          	ld	a1,-40(s0)
    800050e6:	68a8                	ld	a0,80(s1)
    800050e8:	c00fc0ef          	jal	800014e8 <copyout>
    800050ec:	00054e63          	bltz	a0,80005108 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050f0:	4691                	li	a3,4
    800050f2:	fc040613          	add	a2,s0,-64
    800050f6:	fd843583          	ld	a1,-40(s0)
    800050fa:	0591                	add	a1,a1,4
    800050fc:	68a8                	ld	a0,80(s1)
    800050fe:	beafc0ef          	jal	800014e8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005102:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005104:	04055c63          	bgez	a0,8000515c <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005108:	fc442783          	lw	a5,-60(s0)
    8000510c:	07e9                	add	a5,a5,26
    8000510e:	078e                	sll	a5,a5,0x3
    80005110:	97a6                	add	a5,a5,s1
    80005112:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005116:	fc042783          	lw	a5,-64(s0)
    8000511a:	07e9                	add	a5,a5,26
    8000511c:	078e                	sll	a5,a5,0x3
    8000511e:	94be                	add	s1,s1,a5
    80005120:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005124:	fd043503          	ld	a0,-48(s0)
    80005128:	db5fe0ef          	jal	80003edc <fileclose>
    fileclose(wf);
    8000512c:	fc843503          	ld	a0,-56(s0)
    80005130:	dadfe0ef          	jal	80003edc <fileclose>
    return -1;
    80005134:	57fd                	li	a5,-1
    80005136:	a01d                	j	8000515c <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005138:	fc442783          	lw	a5,-60(s0)
    8000513c:	0007c763          	bltz	a5,8000514a <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005140:	07e9                	add	a5,a5,26
    80005142:	078e                	sll	a5,a5,0x3
    80005144:	97a6                	add	a5,a5,s1
    80005146:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000514a:	fd043503          	ld	a0,-48(s0)
    8000514e:	d8ffe0ef          	jal	80003edc <fileclose>
    fileclose(wf);
    80005152:	fc843503          	ld	a0,-56(s0)
    80005156:	d87fe0ef          	jal	80003edc <fileclose>
    return -1;
    8000515a:	57fd                	li	a5,-1
}
    8000515c:	853e                	mv	a0,a5
    8000515e:	70e2                	ld	ra,56(sp)
    80005160:	7442                	ld	s0,48(sp)
    80005162:	74a2                	ld	s1,40(sp)
    80005164:	6121                	add	sp,sp,64
    80005166:	8082                	ret
	...

0000000080005170 <kernelvec>:
    80005170:	7111                	add	sp,sp,-256
    80005172:	e006                	sd	ra,0(sp)
    80005174:	e40a                	sd	sp,8(sp)
    80005176:	e80e                	sd	gp,16(sp)
    80005178:	ec12                	sd	tp,24(sp)
    8000517a:	f016                	sd	t0,32(sp)
    8000517c:	f41a                	sd	t1,40(sp)
    8000517e:	f81e                	sd	t2,48(sp)
    80005180:	e4aa                	sd	a0,72(sp)
    80005182:	e8ae                	sd	a1,80(sp)
    80005184:	ecb2                	sd	a2,88(sp)
    80005186:	f0b6                	sd	a3,96(sp)
    80005188:	f4ba                	sd	a4,104(sp)
    8000518a:	f8be                	sd	a5,112(sp)
    8000518c:	fcc2                	sd	a6,120(sp)
    8000518e:	e146                	sd	a7,128(sp)
    80005190:	edf2                	sd	t3,216(sp)
    80005192:	f1f6                	sd	t4,224(sp)
    80005194:	f5fa                	sd	t5,232(sp)
    80005196:	f9fe                	sd	t6,240(sp)
    80005198:	d44fd0ef          	jal	800026dc <kerneltrap>
    8000519c:	6082                	ld	ra,0(sp)
    8000519e:	6122                	ld	sp,8(sp)
    800051a0:	61c2                	ld	gp,16(sp)
    800051a2:	7282                	ld	t0,32(sp)
    800051a4:	7322                	ld	t1,40(sp)
    800051a6:	73c2                	ld	t2,48(sp)
    800051a8:	6526                	ld	a0,72(sp)
    800051aa:	65c6                	ld	a1,80(sp)
    800051ac:	6666                	ld	a2,88(sp)
    800051ae:	7686                	ld	a3,96(sp)
    800051b0:	7726                	ld	a4,104(sp)
    800051b2:	77c6                	ld	a5,112(sp)
    800051b4:	7866                	ld	a6,120(sp)
    800051b6:	688a                	ld	a7,128(sp)
    800051b8:	6e6e                	ld	t3,216(sp)
    800051ba:	7e8e                	ld	t4,224(sp)
    800051bc:	7f2e                	ld	t5,232(sp)
    800051be:	7fce                	ld	t6,240(sp)
    800051c0:	6111                	add	sp,sp,256
    800051c2:	10200073          	sret
	...

00000000800051ce <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051ce:	1141                	add	sp,sp,-16
    800051d0:	e422                	sd	s0,8(sp)
    800051d2:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051d4:	0c0007b7          	lui	a5,0xc000
    800051d8:	4705                	li	a4,1
    800051da:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051dc:	c3d8                	sw	a4,4(a5)
}
    800051de:	6422                	ld	s0,8(sp)
    800051e0:	0141                	add	sp,sp,16
    800051e2:	8082                	ret

00000000800051e4 <plicinithart>:

void
plicinithart(void)
{
    800051e4:	1141                	add	sp,sp,-16
    800051e6:	e406                	sd	ra,8(sp)
    800051e8:	e022                	sd	s0,0(sp)
    800051ea:	0800                	add	s0,sp,16
  int hart = cpuid();
    800051ec:	e18fc0ef          	jal	80001804 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051f0:	0085171b          	sllw	a4,a0,0x8
    800051f4:	0c0027b7          	lui	a5,0xc002
    800051f8:	97ba                	add	a5,a5,a4
    800051fa:	40200713          	li	a4,1026
    800051fe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005202:	00d5151b          	sllw	a0,a0,0xd
    80005206:	0c2017b7          	lui	a5,0xc201
    8000520a:	97aa                	add	a5,a5,a0
    8000520c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005210:	60a2                	ld	ra,8(sp)
    80005212:	6402                	ld	s0,0(sp)
    80005214:	0141                	add	sp,sp,16
    80005216:	8082                	ret

0000000080005218 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005218:	1141                	add	sp,sp,-16
    8000521a:	e406                	sd	ra,8(sp)
    8000521c:	e022                	sd	s0,0(sp)
    8000521e:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005220:	de4fc0ef          	jal	80001804 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005224:	00d5151b          	sllw	a0,a0,0xd
    80005228:	0c2017b7          	lui	a5,0xc201
    8000522c:	97aa                	add	a5,a5,a0
  return irq;
}
    8000522e:	43c8                	lw	a0,4(a5)
    80005230:	60a2                	ld	ra,8(sp)
    80005232:	6402                	ld	s0,0(sp)
    80005234:	0141                	add	sp,sp,16
    80005236:	8082                	ret

0000000080005238 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005238:	1101                	add	sp,sp,-32
    8000523a:	ec06                	sd	ra,24(sp)
    8000523c:	e822                	sd	s0,16(sp)
    8000523e:	e426                	sd	s1,8(sp)
    80005240:	1000                	add	s0,sp,32
    80005242:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005244:	dc0fc0ef          	jal	80001804 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005248:	00d5151b          	sllw	a0,a0,0xd
    8000524c:	0c2017b7          	lui	a5,0xc201
    80005250:	97aa                	add	a5,a5,a0
    80005252:	c3c4                	sw	s1,4(a5)
}
    80005254:	60e2                	ld	ra,24(sp)
    80005256:	6442                	ld	s0,16(sp)
    80005258:	64a2                	ld	s1,8(sp)
    8000525a:	6105                	add	sp,sp,32
    8000525c:	8082                	ret

000000008000525e <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000525e:	1141                	add	sp,sp,-16
    80005260:	e406                	sd	ra,8(sp)
    80005262:	e022                	sd	s0,0(sp)
    80005264:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005266:	479d                	li	a5,7
    80005268:	04a7ca63          	blt	a5,a0,800052bc <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    8000526c:	0001c797          	auipc	a5,0x1c
    80005270:	cd478793          	add	a5,a5,-812 # 80020f40 <disk>
    80005274:	97aa                	add	a5,a5,a0
    80005276:	0187c783          	lbu	a5,24(a5)
    8000527a:	e7b9                	bnez	a5,800052c8 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000527c:	00451693          	sll	a3,a0,0x4
    80005280:	0001c797          	auipc	a5,0x1c
    80005284:	cc078793          	add	a5,a5,-832 # 80020f40 <disk>
    80005288:	6398                	ld	a4,0(a5)
    8000528a:	9736                	add	a4,a4,a3
    8000528c:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005290:	6398                	ld	a4,0(a5)
    80005292:	9736                	add	a4,a4,a3
    80005294:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005298:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000529c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800052a0:	97aa                	add	a5,a5,a0
    800052a2:	4705                	li	a4,1
    800052a4:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800052a8:	0001c517          	auipc	a0,0x1c
    800052ac:	cb050513          	add	a0,a0,-848 # 80020f58 <disk+0x18>
    800052b0:	bbbfc0ef          	jal	80001e6a <wakeup>
}
    800052b4:	60a2                	ld	ra,8(sp)
    800052b6:	6402                	ld	s0,0(sp)
    800052b8:	0141                	add	sp,sp,16
    800052ba:	8082                	ret
    panic("free_desc 1");
    800052bc:	00002517          	auipc	a0,0x2
    800052c0:	4e450513          	add	a0,a0,1252 # 800077a0 <syscalls+0x310>
    800052c4:	c9afb0ef          	jal	8000075e <panic>
    panic("free_desc 2");
    800052c8:	00002517          	auipc	a0,0x2
    800052cc:	4e850513          	add	a0,a0,1256 # 800077b0 <syscalls+0x320>
    800052d0:	c8efb0ef          	jal	8000075e <panic>

00000000800052d4 <virtio_disk_init>:
{
    800052d4:	1101                	add	sp,sp,-32
    800052d6:	ec06                	sd	ra,24(sp)
    800052d8:	e822                	sd	s0,16(sp)
    800052da:	e426                	sd	s1,8(sp)
    800052dc:	e04a                	sd	s2,0(sp)
    800052de:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052e0:	00002597          	auipc	a1,0x2
    800052e4:	4e058593          	add	a1,a1,1248 # 800077c0 <syscalls+0x330>
    800052e8:	0001c517          	auipc	a0,0x1c
    800052ec:	d8050513          	add	a0,a0,-640 # 80021068 <disk+0x128>
    800052f0:	831fb0ef          	jal	80000b20 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052f4:	100017b7          	lui	a5,0x10001
    800052f8:	4398                	lw	a4,0(a5)
    800052fa:	2701                	sext.w	a4,a4
    800052fc:	747277b7          	lui	a5,0x74727
    80005300:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005304:	12f71f63          	bne	a4,a5,80005442 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005308:	100017b7          	lui	a5,0x10001
    8000530c:	43dc                	lw	a5,4(a5)
    8000530e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005310:	4709                	li	a4,2
    80005312:	12e79863          	bne	a5,a4,80005442 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005316:	100017b7          	lui	a5,0x10001
    8000531a:	479c                	lw	a5,8(a5)
    8000531c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000531e:	12e79263          	bne	a5,a4,80005442 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005322:	100017b7          	lui	a5,0x10001
    80005326:	47d8                	lw	a4,12(a5)
    80005328:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000532a:	554d47b7          	lui	a5,0x554d4
    8000532e:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005332:	10f71863          	bne	a4,a5,80005442 <virtio_disk_init+0x16e>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005336:	100017b7          	lui	a5,0x10001
    8000533a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000533e:	4705                	li	a4,1
    80005340:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005342:	470d                	li	a4,3
    80005344:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005346:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005348:	c7ffe6b7          	lui	a3,0xc7ffe
    8000534c:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd6df>
    80005350:	8f75                	and	a4,a4,a3
    80005352:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005354:	472d                	li	a4,11
    80005356:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005358:	5bbc                	lw	a5,112(a5)
    8000535a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000535e:	8ba1                	and	a5,a5,8
    80005360:	0e078763          	beqz	a5,8000544e <virtio_disk_init+0x17a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005364:	100017b7          	lui	a5,0x10001
    80005368:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000536c:	43fc                	lw	a5,68(a5)
    8000536e:	2781                	sext.w	a5,a5
    80005370:	0e079563          	bnez	a5,8000545a <virtio_disk_init+0x186>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005374:	100017b7          	lui	a5,0x10001
    80005378:	5bdc                	lw	a5,52(a5)
    8000537a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000537c:	0e078563          	beqz	a5,80005466 <virtio_disk_init+0x192>
  if(max < NUM)
    80005380:	471d                	li	a4,7
    80005382:	0ef77863          	bgeu	a4,a5,80005472 <virtio_disk_init+0x19e>
  disk.desc = kalloc();
    80005386:	f4afb0ef          	jal	80000ad0 <kalloc>
    8000538a:	0001c497          	auipc	s1,0x1c
    8000538e:	bb648493          	add	s1,s1,-1098 # 80020f40 <disk>
    80005392:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005394:	f3cfb0ef          	jal	80000ad0 <kalloc>
    80005398:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000539a:	f36fb0ef          	jal	80000ad0 <kalloc>
    8000539e:	87aa                	mv	a5,a0
    800053a0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800053a2:	6088                	ld	a0,0(s1)
    800053a4:	cd69                	beqz	a0,8000547e <virtio_disk_init+0x1aa>
    800053a6:	0001c717          	auipc	a4,0x1c
    800053aa:	ba273703          	ld	a4,-1118(a4) # 80020f48 <disk+0x8>
    800053ae:	cb61                	beqz	a4,8000547e <virtio_disk_init+0x1aa>
    800053b0:	c7f9                	beqz	a5,8000547e <virtio_disk_init+0x1aa>
  memset(disk.desc, 0, PGSIZE);
    800053b2:	6605                	lui	a2,0x1
    800053b4:	4581                	li	a1,0
    800053b6:	8bffb0ef          	jal	80000c74 <memset>
  memset(disk.avail, 0, PGSIZE);
    800053ba:	0001c497          	auipc	s1,0x1c
    800053be:	b8648493          	add	s1,s1,-1146 # 80020f40 <disk>
    800053c2:	6605                	lui	a2,0x1
    800053c4:	4581                	li	a1,0
    800053c6:	6488                	ld	a0,8(s1)
    800053c8:	8adfb0ef          	jal	80000c74 <memset>
  memset(disk.used, 0, PGSIZE);
    800053cc:	6605                	lui	a2,0x1
    800053ce:	4581                	li	a1,0
    800053d0:	6888                	ld	a0,16(s1)
    800053d2:	8a3fb0ef          	jal	80000c74 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053d6:	100017b7          	lui	a5,0x10001
    800053da:	4721                	li	a4,8
    800053dc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800053de:	4098                	lw	a4,0(s1)
    800053e0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800053e4:	40d8                	lw	a4,4(s1)
    800053e6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800053ea:	6498                	ld	a4,8(s1)
    800053ec:	0007069b          	sext.w	a3,a4
    800053f0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053f4:	9701                	sra	a4,a4,0x20
    800053f6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053fa:	6898                	ld	a4,16(s1)
    800053fc:	0007069b          	sext.w	a3,a4
    80005400:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005404:	9701                	sra	a4,a4,0x20
    80005406:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000540a:	4705                	li	a4,1
    8000540c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000540e:	00e48c23          	sb	a4,24(s1)
    80005412:	00e48ca3          	sb	a4,25(s1)
    80005416:	00e48d23          	sb	a4,26(s1)
    8000541a:	00e48da3          	sb	a4,27(s1)
    8000541e:	00e48e23          	sb	a4,28(s1)
    80005422:	00e48ea3          	sb	a4,29(s1)
    80005426:	00e48f23          	sb	a4,30(s1)
    8000542a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000542e:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005432:	0727a823          	sw	s2,112(a5)
}
    80005436:	60e2                	ld	ra,24(sp)
    80005438:	6442                	ld	s0,16(sp)
    8000543a:	64a2                	ld	s1,8(sp)
    8000543c:	6902                	ld	s2,0(sp)
    8000543e:	6105                	add	sp,sp,32
    80005440:	8082                	ret
    panic("could not find virtio disk");
    80005442:	00002517          	auipc	a0,0x2
    80005446:	38e50513          	add	a0,a0,910 # 800077d0 <syscalls+0x340>
    8000544a:	b14fb0ef          	jal	8000075e <panic>
    panic("virtio disk FEATURES_OK unset");
    8000544e:	00002517          	auipc	a0,0x2
    80005452:	3a250513          	add	a0,a0,930 # 800077f0 <syscalls+0x360>
    80005456:	b08fb0ef          	jal	8000075e <panic>
    panic("virtio disk should not be ready");
    8000545a:	00002517          	auipc	a0,0x2
    8000545e:	3b650513          	add	a0,a0,950 # 80007810 <syscalls+0x380>
    80005462:	afcfb0ef          	jal	8000075e <panic>
    panic("virtio disk has no queue 0");
    80005466:	00002517          	auipc	a0,0x2
    8000546a:	3ca50513          	add	a0,a0,970 # 80007830 <syscalls+0x3a0>
    8000546e:	af0fb0ef          	jal	8000075e <panic>
    panic("virtio disk max queue too short");
    80005472:	00002517          	auipc	a0,0x2
    80005476:	3de50513          	add	a0,a0,990 # 80007850 <syscalls+0x3c0>
    8000547a:	ae4fb0ef          	jal	8000075e <panic>
    panic("virtio disk kalloc");
    8000547e:	00002517          	auipc	a0,0x2
    80005482:	3f250513          	add	a0,a0,1010 # 80007870 <syscalls+0x3e0>
    80005486:	ad8fb0ef          	jal	8000075e <panic>

000000008000548a <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000548a:	7159                	add	sp,sp,-112
    8000548c:	f486                	sd	ra,104(sp)
    8000548e:	f0a2                	sd	s0,96(sp)
    80005490:	eca6                	sd	s1,88(sp)
    80005492:	e8ca                	sd	s2,80(sp)
    80005494:	e4ce                	sd	s3,72(sp)
    80005496:	e0d2                	sd	s4,64(sp)
    80005498:	fc56                	sd	s5,56(sp)
    8000549a:	f85a                	sd	s6,48(sp)
    8000549c:	f45e                	sd	s7,40(sp)
    8000549e:	f062                	sd	s8,32(sp)
    800054a0:	ec66                	sd	s9,24(sp)
    800054a2:	e86a                	sd	s10,16(sp)
    800054a4:	1880                	add	s0,sp,112
    800054a6:	8a2a                	mv	s4,a0
    800054a8:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054aa:	00c52c83          	lw	s9,12(a0)
    800054ae:	001c9c9b          	sllw	s9,s9,0x1
    800054b2:	1c82                	sll	s9,s9,0x20
    800054b4:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054b8:	0001c517          	auipc	a0,0x1c
    800054bc:	bb050513          	add	a0,a0,-1104 # 80021068 <disk+0x128>
    800054c0:	ee0fb0ef          	jal	80000ba0 <acquire>
  for(int i = 0; i < 3; i++){
    800054c4:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800054c6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800054c8:	0001cb17          	auipc	s6,0x1c
    800054cc:	a78b0b13          	add	s6,s6,-1416 # 80020f40 <disk>
  for(int i = 0; i < 3; i++){
    800054d0:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054d2:	0001cc17          	auipc	s8,0x1c
    800054d6:	b96c0c13          	add	s8,s8,-1130 # 80021068 <disk+0x128>
    800054da:	a8b1                	j	80005536 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800054dc:	00fb0733          	add	a4,s6,a5
    800054e0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800054e4:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800054e6:	0207c563          	bltz	a5,80005510 <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    800054ea:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800054ec:	0591                	add	a1,a1,4
    800054ee:	05560963          	beq	a2,s5,80005540 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    800054f2:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800054f4:	0001c717          	auipc	a4,0x1c
    800054f8:	a4c70713          	add	a4,a4,-1460 # 80020f40 <disk>
    800054fc:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800054fe:	01874683          	lbu	a3,24(a4)
    80005502:	fee9                	bnez	a3,800054dc <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005504:	2785                	addw	a5,a5,1
    80005506:	0705                	add	a4,a4,1
    80005508:	fe979be3          	bne	a5,s1,800054fe <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    8000550c:	57fd                	li	a5,-1
    8000550e:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80005510:	00c05c63          	blez	a2,80005528 <virtio_disk_rw+0x9e>
    80005514:	060a                	sll	a2,a2,0x2
    80005516:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    8000551a:	0009a503          	lw	a0,0(s3)
    8000551e:	d41ff0ef          	jal	8000525e <free_desc>
      for(int j = 0; j < i; j++)
    80005522:	0991                	add	s3,s3,4
    80005524:	ffa99be3          	bne	s3,s10,8000551a <virtio_disk_rw+0x90>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005528:	85e2                	mv	a1,s8
    8000552a:	0001c517          	auipc	a0,0x1c
    8000552e:	a2e50513          	add	a0,a0,-1490 # 80020f58 <disk+0x18>
    80005532:	8edfc0ef          	jal	80001e1e <sleep>
  for(int i = 0; i < 3; i++){
    80005536:	f9040993          	add	s3,s0,-112
{
    8000553a:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    8000553c:	864a                	mv	a2,s2
    8000553e:	bf55                	j	800054f2 <virtio_disk_rw+0x68>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005540:	f9042503          	lw	a0,-112(s0)
    80005544:	00a50713          	add	a4,a0,10
    80005548:	0712                	sll	a4,a4,0x4

  if(write)
    8000554a:	0001c797          	auipc	a5,0x1c
    8000554e:	9f678793          	add	a5,a5,-1546 # 80020f40 <disk>
    80005552:	00e786b3          	add	a3,a5,a4
    80005556:	01703633          	snez	a2,s7
    8000555a:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000555c:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005560:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005564:	f6070613          	add	a2,a4,-160
    80005568:	6394                	ld	a3,0(a5)
    8000556a:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000556c:	00870593          	add	a1,a4,8
    80005570:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005572:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005574:	0007b803          	ld	a6,0(a5)
    80005578:	9642                	add	a2,a2,a6
    8000557a:	46c1                	li	a3,16
    8000557c:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000557e:	4585                	li	a1,1
    80005580:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005584:	f9442683          	lw	a3,-108(s0)
    80005588:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000558c:	0692                	sll	a3,a3,0x4
    8000558e:	9836                	add	a6,a6,a3
    80005590:	058a0613          	add	a2,s4,88
    80005594:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80005598:	0007b803          	ld	a6,0(a5)
    8000559c:	96c2                	add	a3,a3,a6
    8000559e:	40000613          	li	a2,1024
    800055a2:	c690                	sw	a2,8(a3)
  if(write)
    800055a4:	001bb613          	seqz	a2,s7
    800055a8:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055ac:	00166613          	or	a2,a2,1
    800055b0:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055b4:	f9842603          	lw	a2,-104(s0)
    800055b8:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055bc:	00250693          	add	a3,a0,2
    800055c0:	0692                	sll	a3,a3,0x4
    800055c2:	96be                	add	a3,a3,a5
    800055c4:	58fd                	li	a7,-1
    800055c6:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055ca:	0612                	sll	a2,a2,0x4
    800055cc:	9832                	add	a6,a6,a2
    800055ce:	f9070713          	add	a4,a4,-112
    800055d2:	973e                	add	a4,a4,a5
    800055d4:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800055d8:	6398                	ld	a4,0(a5)
    800055da:	9732                	add	a4,a4,a2
    800055dc:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055de:	4609                	li	a2,2
    800055e0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800055e4:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055e8:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800055ec:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055f0:	6794                	ld	a3,8(a5)
    800055f2:	0026d703          	lhu	a4,2(a3)
    800055f6:	8b1d                	and	a4,a4,7
    800055f8:	0706                	sll	a4,a4,0x1
    800055fa:	96ba                	add	a3,a3,a4
    800055fc:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005600:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005604:	6798                	ld	a4,8(a5)
    80005606:	00275783          	lhu	a5,2(a4)
    8000560a:	2785                	addw	a5,a5,1
    8000560c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005610:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005614:	100017b7          	lui	a5,0x10001
    80005618:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000561c:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005620:	0001c917          	auipc	s2,0x1c
    80005624:	a4890913          	add	s2,s2,-1464 # 80021068 <disk+0x128>
  while(b->disk == 1) {
    80005628:	4485                	li	s1,1
    8000562a:	00b79a63          	bne	a5,a1,8000563e <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    8000562e:	85ca                	mv	a1,s2
    80005630:	8552                	mv	a0,s4
    80005632:	fecfc0ef          	jal	80001e1e <sleep>
  while(b->disk == 1) {
    80005636:	004a2783          	lw	a5,4(s4)
    8000563a:	fe978ae3          	beq	a5,s1,8000562e <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    8000563e:	f9042903          	lw	s2,-112(s0)
    80005642:	00290713          	add	a4,s2,2
    80005646:	0712                	sll	a4,a4,0x4
    80005648:	0001c797          	auipc	a5,0x1c
    8000564c:	8f878793          	add	a5,a5,-1800 # 80020f40 <disk>
    80005650:	97ba                	add	a5,a5,a4
    80005652:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005656:	0001c997          	auipc	s3,0x1c
    8000565a:	8ea98993          	add	s3,s3,-1814 # 80020f40 <disk>
    8000565e:	00491713          	sll	a4,s2,0x4
    80005662:	0009b783          	ld	a5,0(s3)
    80005666:	97ba                	add	a5,a5,a4
    80005668:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000566c:	854a                	mv	a0,s2
    8000566e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005672:	bedff0ef          	jal	8000525e <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005676:	8885                	and	s1,s1,1
    80005678:	f0fd                	bnez	s1,8000565e <virtio_disk_rw+0x1d4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000567a:	0001c517          	auipc	a0,0x1c
    8000567e:	9ee50513          	add	a0,a0,-1554 # 80021068 <disk+0x128>
    80005682:	db6fb0ef          	jal	80000c38 <release>
}
    80005686:	70a6                	ld	ra,104(sp)
    80005688:	7406                	ld	s0,96(sp)
    8000568a:	64e6                	ld	s1,88(sp)
    8000568c:	6946                	ld	s2,80(sp)
    8000568e:	69a6                	ld	s3,72(sp)
    80005690:	6a06                	ld	s4,64(sp)
    80005692:	7ae2                	ld	s5,56(sp)
    80005694:	7b42                	ld	s6,48(sp)
    80005696:	7ba2                	ld	s7,40(sp)
    80005698:	7c02                	ld	s8,32(sp)
    8000569a:	6ce2                	ld	s9,24(sp)
    8000569c:	6d42                	ld	s10,16(sp)
    8000569e:	6165                	add	sp,sp,112
    800056a0:	8082                	ret

00000000800056a2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056a2:	1101                	add	sp,sp,-32
    800056a4:	ec06                	sd	ra,24(sp)
    800056a6:	e822                	sd	s0,16(sp)
    800056a8:	e426                	sd	s1,8(sp)
    800056aa:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056ac:	0001c497          	auipc	s1,0x1c
    800056b0:	89448493          	add	s1,s1,-1900 # 80020f40 <disk>
    800056b4:	0001c517          	auipc	a0,0x1c
    800056b8:	9b450513          	add	a0,a0,-1612 # 80021068 <disk+0x128>
    800056bc:	ce4fb0ef          	jal	80000ba0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056c0:	10001737          	lui	a4,0x10001
    800056c4:	533c                	lw	a5,96(a4)
    800056c6:	8b8d                	and	a5,a5,3
    800056c8:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056ca:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056ce:	689c                	ld	a5,16(s1)
    800056d0:	0204d703          	lhu	a4,32(s1)
    800056d4:	0027d783          	lhu	a5,2(a5)
    800056d8:	04f70663          	beq	a4,a5,80005724 <virtio_disk_intr+0x82>
    __sync_synchronize();
    800056dc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056e0:	6898                	ld	a4,16(s1)
    800056e2:	0204d783          	lhu	a5,32(s1)
    800056e6:	8b9d                	and	a5,a5,7
    800056e8:	078e                	sll	a5,a5,0x3
    800056ea:	97ba                	add	a5,a5,a4
    800056ec:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056ee:	00278713          	add	a4,a5,2
    800056f2:	0712                	sll	a4,a4,0x4
    800056f4:	9726                	add	a4,a4,s1
    800056f6:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800056fa:	e321                	bnez	a4,8000573a <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056fc:	0789                	add	a5,a5,2
    800056fe:	0792                	sll	a5,a5,0x4
    80005700:	97a6                	add	a5,a5,s1
    80005702:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005704:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005708:	f62fc0ef          	jal	80001e6a <wakeup>

    disk.used_idx += 1;
    8000570c:	0204d783          	lhu	a5,32(s1)
    80005710:	2785                	addw	a5,a5,1
    80005712:	17c2                	sll	a5,a5,0x30
    80005714:	93c1                	srl	a5,a5,0x30
    80005716:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000571a:	6898                	ld	a4,16(s1)
    8000571c:	00275703          	lhu	a4,2(a4)
    80005720:	faf71ee3          	bne	a4,a5,800056dc <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    80005724:	0001c517          	auipc	a0,0x1c
    80005728:	94450513          	add	a0,a0,-1724 # 80021068 <disk+0x128>
    8000572c:	d0cfb0ef          	jal	80000c38 <release>
}
    80005730:	60e2                	ld	ra,24(sp)
    80005732:	6442                	ld	s0,16(sp)
    80005734:	64a2                	ld	s1,8(sp)
    80005736:	6105                	add	sp,sp,32
    80005738:	8082                	ret
      panic("virtio_disk_intr status");
    8000573a:	00002517          	auipc	a0,0x2
    8000573e:	14e50513          	add	a0,a0,334 # 80007888 <syscalls+0x3f8>
    80005742:	81cfb0ef          	jal	8000075e <panic>
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
