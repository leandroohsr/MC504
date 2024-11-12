
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	91013103          	ld	sp,-1776(sp) # 80007910 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    8000006e:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffcbc6f>
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
    800000fa:	0e2020ef          	jal	800021dc <either_copyin>
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
    80000150:	82450513          	add	a0,a0,-2012 # 8000f970 <cons>
    80000154:	24d000ef          	jal	80000ba0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000158:	00010497          	auipc	s1,0x10
    8000015c:	81848493          	add	s1,s1,-2024 # 8000f970 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000160:	00010917          	auipc	s2,0x10
    80000164:	8a890913          	add	s2,s2,-1880 # 8000fa08 <cons+0x98>
  while(n > 0){
    80000168:	07305a63          	blez	s3,800001dc <consoleread+0xb0>
    while(cons.r == cons.w){
    8000016c:	0984a783          	lw	a5,152(s1)
    80000170:	09c4a703          	lw	a4,156(s1)
    80000174:	02f71163          	bne	a4,a5,80000196 <consoleread+0x6a>
      if(killed(myproc())){
    80000178:	6b8010ef          	jal	80001830 <myproc>
    8000017c:	6f9010ef          	jal	80002074 <killed>
    80000180:	e53d                	bnez	a0,800001ee <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80000182:	85a6                	mv	a1,s1
    80000184:	854a                	mv	a0,s2
    80000186:	4b7010ef          	jal	80001e3c <sleep>
    while(cons.r == cons.w){
    8000018a:	0984a783          	lw	a5,152(s1)
    8000018e:	09c4a703          	lw	a4,156(s1)
    80000192:	fef703e3          	beq	a4,a5,80000178 <consoleread+0x4c>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80000196:	0000f717          	auipc	a4,0xf
    8000019a:	7da70713          	add	a4,a4,2010 # 8000f970 <cons>
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
    800001c8:	7cb010ef          	jal	80002192 <either_copyout>
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
    800001e0:	79450513          	add	a0,a0,1940 # 8000f970 <cons>
    800001e4:	255000ef          	jal	80000c38 <release>

  return target - n;
    800001e8:	413b053b          	subw	a0,s6,s3
    800001ec:	a801                	j	800001fc <consoleread+0xd0>
        release(&cons.lock);
    800001ee:	0000f517          	auipc	a0,0xf
    800001f2:	78250513          	add	a0,a0,1922 # 8000f970 <cons>
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
    8000021e:	7ef72723          	sw	a5,2030(a4) # 8000fa08 <cons+0x98>
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
    80000268:	70c50513          	add	a0,a0,1804 # 8000f970 <cons>
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
    80000286:	7a1010ef          	jal	80002226 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000028a:	0000f517          	auipc	a0,0xf
    8000028e:	6e650513          	add	a0,a0,1766 # 8000f970 <cons>
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
    800002ae:	6c670713          	add	a4,a4,1734 # 8000f970 <cons>
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
    800002d4:	6a078793          	add	a5,a5,1696 # 8000f970 <cons>
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
    80000302:	70a7a783          	lw	a5,1802(a5) # 8000fa08 <cons+0x98>
    80000306:	9f1d                	subw	a4,a4,a5
    80000308:	08000793          	li	a5,128
    8000030c:	f6f71fe3          	bne	a4,a5,8000028a <consoleintr+0x34>
    80000310:	a04d                	j	800003b2 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80000312:	0000f717          	auipc	a4,0xf
    80000316:	65e70713          	add	a4,a4,1630 # 8000f970 <cons>
    8000031a:	0a072783          	lw	a5,160(a4)
    8000031e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000322:	0000f497          	auipc	s1,0xf
    80000326:	64e48493          	add	s1,s1,1614 # 8000f970 <cons>
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
    8000035e:	61670713          	add	a4,a4,1558 # 8000f970 <cons>
    80000362:	0a072783          	lw	a5,160(a4)
    80000366:	09c72703          	lw	a4,156(a4)
    8000036a:	f2f700e3          	beq	a4,a5,8000028a <consoleintr+0x34>
      cons.e--;
    8000036e:	37fd                	addw	a5,a5,-1
    80000370:	0000f717          	auipc	a4,0xf
    80000374:	6af72023          	sw	a5,1696(a4) # 8000fa10 <cons+0xa0>
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
    80000392:	5e278793          	add	a5,a5,1506 # 8000f970 <cons>
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
    800003b6:	64c7ad23          	sw	a2,1626(a5) # 8000fa0c <cons+0x9c>
        wakeup(&cons.r);
    800003ba:	0000f517          	auipc	a0,0xf
    800003be:	64e50513          	add	a0,a0,1614 # 8000fa08 <cons+0x98>
    800003c2:	2c7010ef          	jal	80001e88 <wakeup>
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
    800003dc:	59850513          	add	a0,a0,1432 # 8000f970 <cons>
    800003e0:	740000ef          	jal	80000b20 <initlock>

  uartinit();
    800003e4:	3e2000ef          	jal	800007c6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800003e8:	00031797          	auipc	a5,0x31
    800003ec:	61078793          	add	a5,a5,1552 # 800319f8 <devsw>
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
    800004d4:	5607a783          	lw	a5,1376(a5) # 8000fa30 <pr+0x18>
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
    8000050e:	50e50513          	add	a0,a0,1294 # 8000fa18 <pr>
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
    80000528:	4f450513          	add	a0,a0,1268 # 8000fa18 <pr>
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
    8000076e:	2c07a323          	sw	zero,710(a5) # 8000fa30 <pr+0x18>
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
    80000792:	1af72123          	sw	a5,418(a4) # 80007930 <panicked>
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
    800007a6:	27648493          	add	s1,s1,630 # 8000fa18 <pr>
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
    80000802:	23a50513          	add	a0,a0,570 # 8000fa38 <uart_tx_lock>
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
    80000826:	10e7a783          	lw	a5,270(a5) # 80007930 <panicked>
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
    8000085a:	0e27b783          	ld	a5,226(a5) # 80007938 <uart_tx_r>
    8000085e:	00007717          	auipc	a4,0x7
    80000862:	0e273703          	ld	a4,226(a4) # 80007940 <uart_tx_w>
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
    80000884:	1b8a0a13          	add	s4,s4,440 # 8000fa38 <uart_tx_lock>
    uart_tx_r += 1;
    80000888:	00007497          	auipc	s1,0x7
    8000088c:	0b048493          	add	s1,s1,176 # 80007938 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000890:	00007997          	auipc	s3,0x7
    80000894:	0b098993          	add	s3,s3,176 # 80007940 <uart_tx_w>
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
    800008b2:	5d6010ef          	jal	80001e88 <wakeup>
    
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
    800008fe:	13e50513          	add	a0,a0,318 # 8000fa38 <uart_tx_lock>
    80000902:	29e000ef          	jal	80000ba0 <acquire>
  if(panicked){
    80000906:	00007797          	auipc	a5,0x7
    8000090a:	02a7a783          	lw	a5,42(a5) # 80007930 <panicked>
    8000090e:	efbd                	bnez	a5,8000098c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000910:	00007717          	auipc	a4,0x7
    80000914:	03073703          	ld	a4,48(a4) # 80007940 <uart_tx_w>
    80000918:	00007797          	auipc	a5,0x7
    8000091c:	0207b783          	ld	a5,32(a5) # 80007938 <uart_tx_r>
    80000920:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000924:	0000f997          	auipc	s3,0xf
    80000928:	11498993          	add	s3,s3,276 # 8000fa38 <uart_tx_lock>
    8000092c:	00007497          	auipc	s1,0x7
    80000930:	00c48493          	add	s1,s1,12 # 80007938 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000934:	00007917          	auipc	s2,0x7
    80000938:	00c90913          	add	s2,s2,12 # 80007940 <uart_tx_w>
    8000093c:	00e79d63          	bne	a5,a4,80000956 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000940:	85ce                	mv	a1,s3
    80000942:	8526                	mv	a0,s1
    80000944:	4f8010ef          	jal	80001e3c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000948:	00093703          	ld	a4,0(s2)
    8000094c:	609c                	ld	a5,0(s1)
    8000094e:	02078793          	add	a5,a5,32
    80000952:	fee787e3          	beq	a5,a4,80000940 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000956:	0000f497          	auipc	s1,0xf
    8000095a:	0e248493          	add	s1,s1,226 # 8000fa38 <uart_tx_lock>
    8000095e:	01f77793          	and	a5,a4,31
    80000962:	97a6                	add	a5,a5,s1
    80000964:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000968:	0705                	add	a4,a4,1
    8000096a:	00007797          	auipc	a5,0x7
    8000096e:	fce7bb23          	sd	a4,-42(a5) # 80007940 <uart_tx_w>
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
    800009d0:	06c48493          	add	s1,s1,108 # 8000fa38 <uart_tx_lock>
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
    80000a06:	18e78793          	add	a5,a5,398 # 80032b90 <end>
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
    80000a22:	05290913          	add	s2,s2,82 # 8000fa70 <kmem>
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
    80000ab0:	fc450513          	add	a0,a0,-60 # 8000fa70 <kmem>
    80000ab4:	06c000ef          	jal	80000b20 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab8:	45c5                	li	a1,17
    80000aba:	05ee                	sll	a1,a1,0x1b
    80000abc:	00032517          	auipc	a0,0x32
    80000ac0:	0d450513          	add	a0,a0,212 # 80032b90 <end>
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
    80000ade:	f9648493          	add	s1,s1,-106 # 8000fa70 <kmem>
    80000ae2:	8526                	mv	a0,s1
    80000ae4:	0bc000ef          	jal	80000ba0 <acquire>
  r = kmem.freelist;
    80000ae8:	6c84                	ld	s1,24(s1)
  if(r)
    80000aea:	c485                	beqz	s1,80000b12 <kalloc+0x42>
    kmem.freelist = r->next;
    80000aec:	609c                	ld	a5,0(s1)
    80000aee:	0000f517          	auipc	a0,0xf
    80000af2:	f8250513          	add	a0,a0,-126 # 8000fa70 <kmem>
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
    80000b16:	f5e50513          	add	a0,a0,-162 # 8000fa70 <kmem>
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
    80000ce8:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffcc471>
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
    80000e24:	b2870713          	add	a4,a4,-1240 # 80007948 <started>
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
    80000e4a:	70a010ef          	jal	80002554 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e4e:	456040ef          	jal	800052a4 <plicinithart>
  }

  scheduler();        
    80000e52:	631000ef          	jal	80001c82 <scheduler>
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
    80000e92:	69e010ef          	jal	80002530 <trapinit>
    trapinithart();  // install kernel trap vector
    80000e96:	6be010ef          	jal	80002554 <trapinithart>
    plicinit();      // set up interrupt controller
    80000e9a:	3f4040ef          	jal	8000528e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000e9e:	406040ef          	jal	800052a4 <plicinithart>
    binit();         // buffer cache
    80000ea2:	4dd010ef          	jal	80002b7e <binit>
    iinit();         // inode table
    80000ea6:	2b6020ef          	jal	8000315c <iinit>
    fileinit();      // file table
    80000eaa:	028030ef          	jal	80003ed2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000eae:	4e6040ef          	jal	80005394 <virtio_disk_init>
    userinit();      // first user process
    80000eb2:	3f3000ef          	jal	80001aa4 <userinit>
    __sync_synchronize();
    80000eb6:	0ff0000f          	fence
    started = 1;
    80000eba:	4785                	li	a5,1
    80000ebc:	00007717          	auipc	a4,0x7
    80000ec0:	a8f72623          	sw	a5,-1396(a4) # 80007948 <started>
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
    80000ed4:	a807b783          	ld	a5,-1408(a5) # 80007950 <kernel_pagetable>
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
    80000f42:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffcc467>
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
    80001160:	7ea7ba23          	sd	a0,2036(a5) # 80007950 <kernel_pagetable>
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
    800016b6:	14fd                	add	s1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffcc46f>
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
    800016ec:	8c848493          	add	s1,s1,-1848 # 8000ffb0 <proc>
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
    80001706:	0aea0a13          	add	s4,s4,174 # 800277b0 <tickslock>
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
    8000177c:	31850513          	add	a0,a0,792 # 8000fa90 <pid_lock>
    80001780:	ba0ff0ef          	jal	80000b20 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001784:	00006597          	auipc	a1,0x6
    80001788:	a9c58593          	add	a1,a1,-1380 # 80007220 <digits+0x1e8>
    8000178c:	0000e517          	auipc	a0,0xe
    80001790:	31c50513          	add	a0,a0,796 # 8000faa8 <wait_lock>
    80001794:	b8cff0ef          	jal	80000b20 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001798:	0000f497          	auipc	s1,0xf
    8000179c:	81848493          	add	s1,s1,-2024 # 8000ffb0 <proc>
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
    800017be:	ff698993          	add	s3,s3,-10 # 800277b0 <tickslock>
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
    80001824:	2a050513          	add	a0,a0,672 # 8000fac0 <cpus>
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
    80001848:	24c70713          	add	a4,a4,588 # 8000fa90 <pid_lock>
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
    80001874:	0507a783          	lw	a5,80(a5) # 800078c0 <first.1>
    80001878:	e799                	bnez	a5,80001886 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    8000187a:	4f3000ef          	jal	8000256c <usertrapret>
}
    8000187e:	60a2                	ld	ra,8(sp)
    80001880:	6402                	ld	s0,0(sp)
    80001882:	0141                	add	sp,sp,16
    80001884:	8082                	ret
    fsinit(ROOTDEV);
    80001886:	4505                	li	a0,1
    80001888:	069010ef          	jal	800030f0 <fsinit>
    first = 0;
    8000188c:	00006797          	auipc	a5,0x6
    80001890:	0207aa23          	sw	zero,52(a5) # 800078c0 <first.1>
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
    800018aa:	1ea90913          	add	s2,s2,490 # 8000fa90 <pid_lock>
    800018ae:	854a                	mv	a0,s2
    800018b0:	af0ff0ef          	jal	80000ba0 <acquire>
  pid = nextpid;
    800018b4:	00006797          	auipc	a5,0x6
    800018b8:	01078793          	add	a5,a5,16 # 800078c4 <nextpid>
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
    80001a02:	5b248493          	add	s1,s1,1458 # 8000ffb0 <proc>
    80001a06:	00026917          	auipc	s2,0x26
    80001a0a:	daa90913          	add	s2,s2,-598 # 800277b0 <tickslock>
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
    80001ab8:	eaa7b223          	sd	a0,-348(a5) # 80007958 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001abc:	03400613          	li	a2,52
    80001ac0:	00006597          	auipc	a1,0x6
    80001ac4:	e1058593          	add	a1,a1,-496 # 800078d0 <initcode>
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
    80001af6:	6d5010ef          	jal	800039ca <namei>
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
    80001bfe:	356020ef          	jal	80003f54 <filedup>
    80001c02:	00a93023          	sd	a0,0(s2)
    80001c06:	b7f5                	j	80001bf2 <fork+0x90>
  np->cwd = idup(p->cwd);
    80001c08:	150ab503          	ld	a0,336(s5)
    80001c0c:	6d6010ef          	jal	800032e2 <idup>
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
    80001c30:	e7c48493          	add	s1,s1,-388 # 8000faa8 <wait_lock>
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

0000000080001c6e <sys_uptime_nolock>:
{
    80001c6e:	1141                	add	sp,sp,-16
    80001c70:	e422                	sd	s0,8(sp)
    80001c72:	0800                	add	s0,sp,16
}
    80001c74:	00006517          	auipc	a0,0x6
    80001c78:	cec56503          	lwu	a0,-788(a0) # 80007960 <ticks>
    80001c7c:	6422                	ld	s0,8(sp)
    80001c7e:	0141                	add	sp,sp,16
    80001c80:	8082                	ret

0000000080001c82 <scheduler>:
{
    80001c82:	711d                	add	sp,sp,-96
    80001c84:	ec86                	sd	ra,88(sp)
    80001c86:	e8a2                	sd	s0,80(sp)
    80001c88:	e4a6                	sd	s1,72(sp)
    80001c8a:	e0ca                	sd	s2,64(sp)
    80001c8c:	fc4e                	sd	s3,56(sp)
    80001c8e:	f852                	sd	s4,48(sp)
    80001c90:	f456                	sd	s5,40(sp)
    80001c92:	f05a                	sd	s6,32(sp)
    80001c94:	ec5e                	sd	s7,24(sp)
    80001c96:	e862                	sd	s8,16(sp)
    80001c98:	e466                	sd	s9,8(sp)
    80001c9a:	1080                	add	s0,sp,96
    80001c9c:	8792                	mv	a5,tp
  int id = r_tp();
    80001c9e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ca0:	00779b93          	sll	s7,a5,0x7
    80001ca4:	0000e717          	auipc	a4,0xe
    80001ca8:	dec70713          	add	a4,a4,-532 # 8000fa90 <pid_lock>
    80001cac:	975e                	add	a4,a4,s7
    80001cae:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001cb2:	0000e717          	auipc	a4,0xe
    80001cb6:	e1670713          	add	a4,a4,-490 # 8000fac8 <cpus+0x8>
    80001cba:	9bba                	add	s7,s7,a4
  xticks = ticks;
    80001cbc:	00006a97          	auipc	s5,0x6
    80001cc0:	ca4a8a93          	add	s5,s5,-860 # 80007960 <ticks>
        c->proc = p;
    80001cc4:	079e                	sll	a5,a5,0x7
    80001cc6:	0000ea17          	auipc	s4,0xe
    80001cca:	dcaa0a13          	add	s4,s4,-566 # 8000fa90 <pid_lock>
    80001cce:	9a3e                	add	s4,s4,a5
        found = 1;
    80001cd0:	4c05                	li	s8,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cd2:	00026997          	auipc	s3,0x26
    80001cd6:	ade98993          	add	s3,s3,-1314 # 800277b0 <tickslock>
    80001cda:	a085                	j	80001d3a <scheduler+0xb8>
      release(&p->lock);
    80001cdc:	8526                	mv	a0,s1
    80001cde:	f5bfe0ef          	jal	80000c38 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ce2:	17848493          	add	s1,s1,376
    80001ce6:	05348063          	beq	s1,s3,80001d26 <scheduler+0xa4>
      acquire(&p->lock);
    80001cea:	8526                	mv	a0,s1
    80001cec:	eb5fe0ef          	jal	80000ba0 <acquire>
      if(p->state == RUNNABLE) {
    80001cf0:	4c9c                	lw	a5,24(s1)
    80001cf2:	ff2795e3          	bne	a5,s2,80001cdc <scheduler+0x5a>
  xticks = ticks;
    80001cf6:	000aac83          	lw	s9,0(s5)
        p->state = RUNNING;
    80001cfa:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001cfe:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001d02:	06048593          	add	a1,s1,96
    80001d06:	855e                	mv	a0,s7
    80001d08:	7be000ef          	jal	800024c6 <swtch>
        p->tempo_total += tempo_final - tempo_inicio;
    80001d0c:	000aa783          	lw	a5,0(s5)
    80001d10:	419787bb          	subw	a5,a5,s9
    80001d14:	1684a703          	lw	a4,360(s1)
    80001d18:	9fb9                	addw	a5,a5,a4
    80001d1a:	16f4a423          	sw	a5,360(s1)
        c->proc = 0;
    80001d1e:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001d22:	8ce2                	mv	s9,s8
    80001d24:	bf65                	j	80001cdc <scheduler+0x5a>
    if(found == 0) {
    80001d26:	000c9a63          	bnez	s9,80001d3a <scheduler+0xb8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d2a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d2e:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d32:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001d36:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d3a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d3e:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d42:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001d46:	4c81                	li	s9,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d48:	0000e497          	auipc	s1,0xe
    80001d4c:	26848493          	add	s1,s1,616 # 8000ffb0 <proc>
      if(p->state == RUNNABLE) {
    80001d50:	490d                	li	s2,3
        p->state = RUNNING;
    80001d52:	4b11                	li	s6,4
    80001d54:	bf59                	j	80001cea <scheduler+0x68>

0000000080001d56 <sched>:
{
    80001d56:	7179                	add	sp,sp,-48
    80001d58:	f406                	sd	ra,40(sp)
    80001d5a:	f022                	sd	s0,32(sp)
    80001d5c:	ec26                	sd	s1,24(sp)
    80001d5e:	e84a                	sd	s2,16(sp)
    80001d60:	e44e                	sd	s3,8(sp)
    80001d62:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001d64:	acdff0ef          	jal	80001830 <myproc>
    80001d68:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001d6a:	dcdfe0ef          	jal	80000b36 <holding>
    80001d6e:	c92d                	beqz	a0,80001de0 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d70:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001d72:	2781                	sext.w	a5,a5
    80001d74:	079e                	sll	a5,a5,0x7
    80001d76:	0000e717          	auipc	a4,0xe
    80001d7a:	d1a70713          	add	a4,a4,-742 # 8000fa90 <pid_lock>
    80001d7e:	97ba                	add	a5,a5,a4
    80001d80:	0a87a703          	lw	a4,168(a5)
    80001d84:	4785                	li	a5,1
    80001d86:	06f71363          	bne	a4,a5,80001dec <sched+0x96>
  if(p->state == RUNNING)
    80001d8a:	4c98                	lw	a4,24(s1)
    80001d8c:	4791                	li	a5,4
    80001d8e:	06f70563          	beq	a4,a5,80001df8 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d92:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d96:	8b89                	and	a5,a5,2
  if(intr_get())
    80001d98:	e7b5                	bnez	a5,80001e04 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d9a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001d9c:	0000e917          	auipc	s2,0xe
    80001da0:	cf490913          	add	s2,s2,-780 # 8000fa90 <pid_lock>
    80001da4:	2781                	sext.w	a5,a5
    80001da6:	079e                	sll	a5,a5,0x7
    80001da8:	97ca                	add	a5,a5,s2
    80001daa:	0ac7a983          	lw	s3,172(a5)
    80001dae:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001db0:	2781                	sext.w	a5,a5
    80001db2:	079e                	sll	a5,a5,0x7
    80001db4:	0000e597          	auipc	a1,0xe
    80001db8:	d1458593          	add	a1,a1,-748 # 8000fac8 <cpus+0x8>
    80001dbc:	95be                	add	a1,a1,a5
    80001dbe:	06048513          	add	a0,s1,96
    80001dc2:	704000ef          	jal	800024c6 <swtch>
    80001dc6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001dc8:	2781                	sext.w	a5,a5
    80001dca:	079e                	sll	a5,a5,0x7
    80001dcc:	993e                	add	s2,s2,a5
    80001dce:	0b392623          	sw	s3,172(s2)
}
    80001dd2:	70a2                	ld	ra,40(sp)
    80001dd4:	7402                	ld	s0,32(sp)
    80001dd6:	64e2                	ld	s1,24(sp)
    80001dd8:	6942                	ld	s2,16(sp)
    80001dda:	69a2                	ld	s3,8(sp)
    80001ddc:	6145                	add	sp,sp,48
    80001dde:	8082                	ret
    panic("sched p->lock");
    80001de0:	00005517          	auipc	a0,0x5
    80001de4:	47050513          	add	a0,a0,1136 # 80007250 <digits+0x218>
    80001de8:	977fe0ef          	jal	8000075e <panic>
    panic("sched locks");
    80001dec:	00005517          	auipc	a0,0x5
    80001df0:	47450513          	add	a0,a0,1140 # 80007260 <digits+0x228>
    80001df4:	96bfe0ef          	jal	8000075e <panic>
    panic("sched running");
    80001df8:	00005517          	auipc	a0,0x5
    80001dfc:	47850513          	add	a0,a0,1144 # 80007270 <digits+0x238>
    80001e00:	95ffe0ef          	jal	8000075e <panic>
    panic("sched interruptible");
    80001e04:	00005517          	auipc	a0,0x5
    80001e08:	47c50513          	add	a0,a0,1148 # 80007280 <digits+0x248>
    80001e0c:	953fe0ef          	jal	8000075e <panic>

0000000080001e10 <yield>:
{
    80001e10:	1101                	add	sp,sp,-32
    80001e12:	ec06                	sd	ra,24(sp)
    80001e14:	e822                	sd	s0,16(sp)
    80001e16:	e426                	sd	s1,8(sp)
    80001e18:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80001e1a:	a17ff0ef          	jal	80001830 <myproc>
    80001e1e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001e20:	d81fe0ef          	jal	80000ba0 <acquire>
  p->state = RUNNABLE;
    80001e24:	478d                	li	a5,3
    80001e26:	cc9c                	sw	a5,24(s1)
  sched();
    80001e28:	f2fff0ef          	jal	80001d56 <sched>
  release(&p->lock);
    80001e2c:	8526                	mv	a0,s1
    80001e2e:	e0bfe0ef          	jal	80000c38 <release>
}
    80001e32:	60e2                	ld	ra,24(sp)
    80001e34:	6442                	ld	s0,16(sp)
    80001e36:	64a2                	ld	s1,8(sp)
    80001e38:	6105                	add	sp,sp,32
    80001e3a:	8082                	ret

0000000080001e3c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001e3c:	7179                	add	sp,sp,-48
    80001e3e:	f406                	sd	ra,40(sp)
    80001e40:	f022                	sd	s0,32(sp)
    80001e42:	ec26                	sd	s1,24(sp)
    80001e44:	e84a                	sd	s2,16(sp)
    80001e46:	e44e                	sd	s3,8(sp)
    80001e48:	1800                	add	s0,sp,48
    80001e4a:	89aa                	mv	s3,a0
    80001e4c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e4e:	9e3ff0ef          	jal	80001830 <myproc>
    80001e52:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001e54:	d4dfe0ef          	jal	80000ba0 <acquire>
  release(lk);
    80001e58:	854a                	mv	a0,s2
    80001e5a:	ddffe0ef          	jal	80000c38 <release>

  // Go to sleep.
  p->chan = chan;
    80001e5e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001e62:	4789                	li	a5,2
    80001e64:	cc9c                	sw	a5,24(s1)

  sched();
    80001e66:	ef1ff0ef          	jal	80001d56 <sched>

  // Tidy up.
  p->chan = 0;
    80001e6a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001e6e:	8526                	mv	a0,s1
    80001e70:	dc9fe0ef          	jal	80000c38 <release>
  acquire(lk);
    80001e74:	854a                	mv	a0,s2
    80001e76:	d2bfe0ef          	jal	80000ba0 <acquire>
}
    80001e7a:	70a2                	ld	ra,40(sp)
    80001e7c:	7402                	ld	s0,32(sp)
    80001e7e:	64e2                	ld	s1,24(sp)
    80001e80:	6942                	ld	s2,16(sp)
    80001e82:	69a2                	ld	s3,8(sp)
    80001e84:	6145                	add	sp,sp,48
    80001e86:	8082                	ret

0000000080001e88 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001e88:	7139                	add	sp,sp,-64
    80001e8a:	fc06                	sd	ra,56(sp)
    80001e8c:	f822                	sd	s0,48(sp)
    80001e8e:	f426                	sd	s1,40(sp)
    80001e90:	f04a                	sd	s2,32(sp)
    80001e92:	ec4e                	sd	s3,24(sp)
    80001e94:	e852                	sd	s4,16(sp)
    80001e96:	e456                	sd	s5,8(sp)
    80001e98:	0080                	add	s0,sp,64
    80001e9a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001e9c:	0000e497          	auipc	s1,0xe
    80001ea0:	11448493          	add	s1,s1,276 # 8000ffb0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001ea4:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001ea6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ea8:	00026917          	auipc	s2,0x26
    80001eac:	90890913          	add	s2,s2,-1784 # 800277b0 <tickslock>
    80001eb0:	a801                	j	80001ec0 <wakeup+0x38>
      }
      release(&p->lock);
    80001eb2:	8526                	mv	a0,s1
    80001eb4:	d85fe0ef          	jal	80000c38 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001eb8:	17848493          	add	s1,s1,376
    80001ebc:	03248263          	beq	s1,s2,80001ee0 <wakeup+0x58>
    if(p != myproc()){
    80001ec0:	971ff0ef          	jal	80001830 <myproc>
    80001ec4:	fea48ae3          	beq	s1,a0,80001eb8 <wakeup+0x30>
      acquire(&p->lock);
    80001ec8:	8526                	mv	a0,s1
    80001eca:	cd7fe0ef          	jal	80000ba0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001ece:	4c9c                	lw	a5,24(s1)
    80001ed0:	ff3791e3          	bne	a5,s3,80001eb2 <wakeup+0x2a>
    80001ed4:	709c                	ld	a5,32(s1)
    80001ed6:	fd479ee3          	bne	a5,s4,80001eb2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001eda:	0154ac23          	sw	s5,24(s1)
    80001ede:	bfd1                	j	80001eb2 <wakeup+0x2a>
    }
  }
}
    80001ee0:	70e2                	ld	ra,56(sp)
    80001ee2:	7442                	ld	s0,48(sp)
    80001ee4:	74a2                	ld	s1,40(sp)
    80001ee6:	7902                	ld	s2,32(sp)
    80001ee8:	69e2                	ld	s3,24(sp)
    80001eea:	6a42                	ld	s4,16(sp)
    80001eec:	6aa2                	ld	s5,8(sp)
    80001eee:	6121                	add	sp,sp,64
    80001ef0:	8082                	ret

0000000080001ef2 <reparent>:
{
    80001ef2:	7179                	add	sp,sp,-48
    80001ef4:	f406                	sd	ra,40(sp)
    80001ef6:	f022                	sd	s0,32(sp)
    80001ef8:	ec26                	sd	s1,24(sp)
    80001efa:	e84a                	sd	s2,16(sp)
    80001efc:	e44e                	sd	s3,8(sp)
    80001efe:	e052                	sd	s4,0(sp)
    80001f00:	1800                	add	s0,sp,48
    80001f02:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f04:	0000e497          	auipc	s1,0xe
    80001f08:	0ac48493          	add	s1,s1,172 # 8000ffb0 <proc>
      pp->parent = initproc;
    80001f0c:	00006a17          	auipc	s4,0x6
    80001f10:	a4ca0a13          	add	s4,s4,-1460 # 80007958 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f14:	00026997          	auipc	s3,0x26
    80001f18:	89c98993          	add	s3,s3,-1892 # 800277b0 <tickslock>
    80001f1c:	a029                	j	80001f26 <reparent+0x34>
    80001f1e:	17848493          	add	s1,s1,376
    80001f22:	01348b63          	beq	s1,s3,80001f38 <reparent+0x46>
    if(pp->parent == p){
    80001f26:	7c9c                	ld	a5,56(s1)
    80001f28:	ff279be3          	bne	a5,s2,80001f1e <reparent+0x2c>
      pp->parent = initproc;
    80001f2c:	000a3503          	ld	a0,0(s4)
    80001f30:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001f32:	f57ff0ef          	jal	80001e88 <wakeup>
    80001f36:	b7e5                	j	80001f1e <reparent+0x2c>
}
    80001f38:	70a2                	ld	ra,40(sp)
    80001f3a:	7402                	ld	s0,32(sp)
    80001f3c:	64e2                	ld	s1,24(sp)
    80001f3e:	6942                	ld	s2,16(sp)
    80001f40:	69a2                	ld	s3,8(sp)
    80001f42:	6a02                	ld	s4,0(sp)
    80001f44:	6145                	add	sp,sp,48
    80001f46:	8082                	ret

0000000080001f48 <exit>:
{
    80001f48:	7179                	add	sp,sp,-48
    80001f4a:	f406                	sd	ra,40(sp)
    80001f4c:	f022                	sd	s0,32(sp)
    80001f4e:	ec26                	sd	s1,24(sp)
    80001f50:	e84a                	sd	s2,16(sp)
    80001f52:	e44e                	sd	s3,8(sp)
    80001f54:	e052                	sd	s4,0(sp)
    80001f56:	1800                	add	s0,sp,48
    80001f58:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001f5a:	8d7ff0ef          	jal	80001830 <myproc>
    80001f5e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f60:	00006797          	auipc	a5,0x6
    80001f64:	9f87b783          	ld	a5,-1544(a5) # 80007958 <initproc>
    80001f68:	0d050493          	add	s1,a0,208
    80001f6c:	15050913          	add	s2,a0,336
    80001f70:	00a79f63          	bne	a5,a0,80001f8e <exit+0x46>
    panic("init exiting");
    80001f74:	00005517          	auipc	a0,0x5
    80001f78:	32450513          	add	a0,a0,804 # 80007298 <digits+0x260>
    80001f7c:	fe2fe0ef          	jal	8000075e <panic>
      fileclose(f);
    80001f80:	01a020ef          	jal	80003f9a <fileclose>
      p->ofile[fd] = 0;
    80001f84:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001f88:	04a1                	add	s1,s1,8
    80001f8a:	01248563          	beq	s1,s2,80001f94 <exit+0x4c>
    if(p->ofile[fd]){
    80001f8e:	6088                	ld	a0,0(s1)
    80001f90:	f965                	bnez	a0,80001f80 <exit+0x38>
    80001f92:	bfdd                	j	80001f88 <exit+0x40>
  begin_op();
    80001f94:	3f3010ef          	jal	80003b86 <begin_op>
  iput(p->cwd);
    80001f98:	1509b503          	ld	a0,336(s3)
    80001f9c:	4fa010ef          	jal	80003496 <iput>
  end_op();
    80001fa0:	451010ef          	jal	80003bf0 <end_op>
  p->cwd = 0;
    80001fa4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001fa8:	0000e497          	auipc	s1,0xe
    80001fac:	b0048493          	add	s1,s1,-1280 # 8000faa8 <wait_lock>
    80001fb0:	8526                	mv	a0,s1
    80001fb2:	beffe0ef          	jal	80000ba0 <acquire>
  reparent(p);
    80001fb6:	854e                	mv	a0,s3
    80001fb8:	f3bff0ef          	jal	80001ef2 <reparent>
  wakeup(p->parent);
    80001fbc:	0389b503          	ld	a0,56(s3)
    80001fc0:	ec9ff0ef          	jal	80001e88 <wakeup>
  acquire(&p->lock);
    80001fc4:	854e                	mv	a0,s3
    80001fc6:	bdbfe0ef          	jal	80000ba0 <acquire>
  p->xstate = status;
    80001fca:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001fce:	4795                	li	a5,5
    80001fd0:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001fd4:	8526                	mv	a0,s1
    80001fd6:	c63fe0ef          	jal	80000c38 <release>
  sched();
    80001fda:	d7dff0ef          	jal	80001d56 <sched>
  panic("zombie exit");
    80001fde:	00005517          	auipc	a0,0x5
    80001fe2:	2ca50513          	add	a0,a0,714 # 800072a8 <digits+0x270>
    80001fe6:	f78fe0ef          	jal	8000075e <panic>

0000000080001fea <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001fea:	7179                	add	sp,sp,-48
    80001fec:	f406                	sd	ra,40(sp)
    80001fee:	f022                	sd	s0,32(sp)
    80001ff0:	ec26                	sd	s1,24(sp)
    80001ff2:	e84a                	sd	s2,16(sp)
    80001ff4:	e44e                	sd	s3,8(sp)
    80001ff6:	1800                	add	s0,sp,48
    80001ff8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001ffa:	0000e497          	auipc	s1,0xe
    80001ffe:	fb648493          	add	s1,s1,-74 # 8000ffb0 <proc>
    80002002:	00025997          	auipc	s3,0x25
    80002006:	7ae98993          	add	s3,s3,1966 # 800277b0 <tickslock>
    acquire(&p->lock);
    8000200a:	8526                	mv	a0,s1
    8000200c:	b95fe0ef          	jal	80000ba0 <acquire>
    if(p->pid == pid){
    80002010:	589c                	lw	a5,48(s1)
    80002012:	01278b63          	beq	a5,s2,80002028 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002016:	8526                	mv	a0,s1
    80002018:	c21fe0ef          	jal	80000c38 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000201c:	17848493          	add	s1,s1,376
    80002020:	ff3495e3          	bne	s1,s3,8000200a <kill+0x20>
  }
  return -1;
    80002024:	557d                	li	a0,-1
    80002026:	a819                	j	8000203c <kill+0x52>
      p->killed = 1;
    80002028:	4785                	li	a5,1
    8000202a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000202c:	4c98                	lw	a4,24(s1)
    8000202e:	4789                	li	a5,2
    80002030:	00f70d63          	beq	a4,a5,8000204a <kill+0x60>
      release(&p->lock);
    80002034:	8526                	mv	a0,s1
    80002036:	c03fe0ef          	jal	80000c38 <release>
      return 0;
    8000203a:	4501                	li	a0,0
}
    8000203c:	70a2                	ld	ra,40(sp)
    8000203e:	7402                	ld	s0,32(sp)
    80002040:	64e2                	ld	s1,24(sp)
    80002042:	6942                	ld	s2,16(sp)
    80002044:	69a2                	ld	s3,8(sp)
    80002046:	6145                	add	sp,sp,48
    80002048:	8082                	ret
        p->state = RUNNABLE;
    8000204a:	478d                	li	a5,3
    8000204c:	cc9c                	sw	a5,24(s1)
    8000204e:	b7dd                	j	80002034 <kill+0x4a>

0000000080002050 <setkilled>:

void
setkilled(struct proc *p)
{
    80002050:	1101                	add	sp,sp,-32
    80002052:	ec06                	sd	ra,24(sp)
    80002054:	e822                	sd	s0,16(sp)
    80002056:	e426                	sd	s1,8(sp)
    80002058:	1000                	add	s0,sp,32
    8000205a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000205c:	b45fe0ef          	jal	80000ba0 <acquire>
  p->killed = 1;
    80002060:	4785                	li	a5,1
    80002062:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002064:	8526                	mv	a0,s1
    80002066:	bd3fe0ef          	jal	80000c38 <release>
}
    8000206a:	60e2                	ld	ra,24(sp)
    8000206c:	6442                	ld	s0,16(sp)
    8000206e:	64a2                	ld	s1,8(sp)
    80002070:	6105                	add	sp,sp,32
    80002072:	8082                	ret

0000000080002074 <killed>:

int
killed(struct proc *p)
{
    80002074:	1101                	add	sp,sp,-32
    80002076:	ec06                	sd	ra,24(sp)
    80002078:	e822                	sd	s0,16(sp)
    8000207a:	e426                	sd	s1,8(sp)
    8000207c:	e04a                	sd	s2,0(sp)
    8000207e:	1000                	add	s0,sp,32
    80002080:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002082:	b1ffe0ef          	jal	80000ba0 <acquire>
  k = p->killed;
    80002086:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000208a:	8526                	mv	a0,s1
    8000208c:	badfe0ef          	jal	80000c38 <release>
  return k;
}
    80002090:	854a                	mv	a0,s2
    80002092:	60e2                	ld	ra,24(sp)
    80002094:	6442                	ld	s0,16(sp)
    80002096:	64a2                	ld	s1,8(sp)
    80002098:	6902                	ld	s2,0(sp)
    8000209a:	6105                	add	sp,sp,32
    8000209c:	8082                	ret

000000008000209e <wait>:
{
    8000209e:	715d                	add	sp,sp,-80
    800020a0:	e486                	sd	ra,72(sp)
    800020a2:	e0a2                	sd	s0,64(sp)
    800020a4:	fc26                	sd	s1,56(sp)
    800020a6:	f84a                	sd	s2,48(sp)
    800020a8:	f44e                	sd	s3,40(sp)
    800020aa:	f052                	sd	s4,32(sp)
    800020ac:	ec56                	sd	s5,24(sp)
    800020ae:	e85a                	sd	s6,16(sp)
    800020b0:	e45e                	sd	s7,8(sp)
    800020b2:	0880                	add	s0,sp,80
    800020b4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800020b6:	f7aff0ef          	jal	80001830 <myproc>
    800020ba:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800020bc:	0000e517          	auipc	a0,0xe
    800020c0:	9ec50513          	add	a0,a0,-1556 # 8000faa8 <wait_lock>
    800020c4:	addfe0ef          	jal	80000ba0 <acquire>
    havekids = 0;
    800020c8:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800020ca:	4a15                	li	s4,5
        havekids = 1;
    800020cc:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800020ce:	00025997          	auipc	s3,0x25
    800020d2:	6e298993          	add	s3,s3,1762 # 800277b0 <tickslock>
    havekids = 0;
    800020d6:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800020d8:	0000e497          	auipc	s1,0xe
    800020dc:	ed848493          	add	s1,s1,-296 # 8000ffb0 <proc>
    800020e0:	a0b5                	j	8000214c <wait+0xae>
          pid = pp->pid;
    800020e2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800020e6:	000b0c63          	beqz	s6,800020fe <wait+0x60>
    800020ea:	4691                	li	a3,4
    800020ec:	02c48613          	add	a2,s1,44
    800020f0:	85da                	mv	a1,s6
    800020f2:	05093503          	ld	a0,80(s2)
    800020f6:	bf2ff0ef          	jal	800014e8 <copyout>
    800020fa:	02054a63          	bltz	a0,8000212e <wait+0x90>
          freeproc(pp);
    800020fe:	8526                	mv	a0,s1
    80002100:	8a3ff0ef          	jal	800019a2 <freeproc>
          release(&pp->lock);
    80002104:	8526                	mv	a0,s1
    80002106:	b33fe0ef          	jal	80000c38 <release>
          release(&wait_lock);
    8000210a:	0000e517          	auipc	a0,0xe
    8000210e:	99e50513          	add	a0,a0,-1634 # 8000faa8 <wait_lock>
    80002112:	b27fe0ef          	jal	80000c38 <release>
}
    80002116:	854e                	mv	a0,s3
    80002118:	60a6                	ld	ra,72(sp)
    8000211a:	6406                	ld	s0,64(sp)
    8000211c:	74e2                	ld	s1,56(sp)
    8000211e:	7942                	ld	s2,48(sp)
    80002120:	79a2                	ld	s3,40(sp)
    80002122:	7a02                	ld	s4,32(sp)
    80002124:	6ae2                	ld	s5,24(sp)
    80002126:	6b42                	ld	s6,16(sp)
    80002128:	6ba2                	ld	s7,8(sp)
    8000212a:	6161                	add	sp,sp,80
    8000212c:	8082                	ret
            release(&pp->lock);
    8000212e:	8526                	mv	a0,s1
    80002130:	b09fe0ef          	jal	80000c38 <release>
            release(&wait_lock);
    80002134:	0000e517          	auipc	a0,0xe
    80002138:	97450513          	add	a0,a0,-1676 # 8000faa8 <wait_lock>
    8000213c:	afdfe0ef          	jal	80000c38 <release>
            return -1;
    80002140:	59fd                	li	s3,-1
    80002142:	bfd1                	j	80002116 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002144:	17848493          	add	s1,s1,376
    80002148:	03348063          	beq	s1,s3,80002168 <wait+0xca>
      if(pp->parent == p){
    8000214c:	7c9c                	ld	a5,56(s1)
    8000214e:	ff279be3          	bne	a5,s2,80002144 <wait+0xa6>
        acquire(&pp->lock);
    80002152:	8526                	mv	a0,s1
    80002154:	a4dfe0ef          	jal	80000ba0 <acquire>
        if(pp->state == ZOMBIE){
    80002158:	4c9c                	lw	a5,24(s1)
    8000215a:	f94784e3          	beq	a5,s4,800020e2 <wait+0x44>
        release(&pp->lock);
    8000215e:	8526                	mv	a0,s1
    80002160:	ad9fe0ef          	jal	80000c38 <release>
        havekids = 1;
    80002164:	8756                	mv	a4,s5
    80002166:	bff9                	j	80002144 <wait+0xa6>
    if(!havekids || killed(p)){
    80002168:	cf09                	beqz	a4,80002182 <wait+0xe4>
    8000216a:	854a                	mv	a0,s2
    8000216c:	f09ff0ef          	jal	80002074 <killed>
    80002170:	e909                	bnez	a0,80002182 <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002172:	0000e597          	auipc	a1,0xe
    80002176:	93658593          	add	a1,a1,-1738 # 8000faa8 <wait_lock>
    8000217a:	854a                	mv	a0,s2
    8000217c:	cc1ff0ef          	jal	80001e3c <sleep>
    havekids = 0;
    80002180:	bf99                	j	800020d6 <wait+0x38>
      release(&wait_lock);
    80002182:	0000e517          	auipc	a0,0xe
    80002186:	92650513          	add	a0,a0,-1754 # 8000faa8 <wait_lock>
    8000218a:	aaffe0ef          	jal	80000c38 <release>
      return -1;
    8000218e:	59fd                	li	s3,-1
    80002190:	b759                	j	80002116 <wait+0x78>

0000000080002192 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002192:	7179                	add	sp,sp,-48
    80002194:	f406                	sd	ra,40(sp)
    80002196:	f022                	sd	s0,32(sp)
    80002198:	ec26                	sd	s1,24(sp)
    8000219a:	e84a                	sd	s2,16(sp)
    8000219c:	e44e                	sd	s3,8(sp)
    8000219e:	e052                	sd	s4,0(sp)
    800021a0:	1800                	add	s0,sp,48
    800021a2:	84aa                	mv	s1,a0
    800021a4:	892e                	mv	s2,a1
    800021a6:	89b2                	mv	s3,a2
    800021a8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800021aa:	e86ff0ef          	jal	80001830 <myproc>
  if(user_dst){
    800021ae:	cc99                	beqz	s1,800021cc <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800021b0:	86d2                	mv	a3,s4
    800021b2:	864e                	mv	a2,s3
    800021b4:	85ca                	mv	a1,s2
    800021b6:	6928                	ld	a0,80(a0)
    800021b8:	b30ff0ef          	jal	800014e8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800021bc:	70a2                	ld	ra,40(sp)
    800021be:	7402                	ld	s0,32(sp)
    800021c0:	64e2                	ld	s1,24(sp)
    800021c2:	6942                	ld	s2,16(sp)
    800021c4:	69a2                	ld	s3,8(sp)
    800021c6:	6a02                	ld	s4,0(sp)
    800021c8:	6145                	add	sp,sp,48
    800021ca:	8082                	ret
    memmove((char *)dst, src, len);
    800021cc:	000a061b          	sext.w	a2,s4
    800021d0:	85ce                	mv	a1,s3
    800021d2:	854a                	mv	a0,s2
    800021d4:	afdfe0ef          	jal	80000cd0 <memmove>
    return 0;
    800021d8:	8526                	mv	a0,s1
    800021da:	b7cd                	j	800021bc <either_copyout+0x2a>

00000000800021dc <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800021dc:	7179                	add	sp,sp,-48
    800021de:	f406                	sd	ra,40(sp)
    800021e0:	f022                	sd	s0,32(sp)
    800021e2:	ec26                	sd	s1,24(sp)
    800021e4:	e84a                	sd	s2,16(sp)
    800021e6:	e44e                	sd	s3,8(sp)
    800021e8:	e052                	sd	s4,0(sp)
    800021ea:	1800                	add	s0,sp,48
    800021ec:	892a                	mv	s2,a0
    800021ee:	84ae                	mv	s1,a1
    800021f0:	89b2                	mv	s3,a2
    800021f2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800021f4:	e3cff0ef          	jal	80001830 <myproc>
  if(user_src){
    800021f8:	cc99                	beqz	s1,80002216 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800021fa:	86d2                	mv	a3,s4
    800021fc:	864e                	mv	a2,s3
    800021fe:	85ca                	mv	a1,s2
    80002200:	6928                	ld	a0,80(a0)
    80002202:	b9eff0ef          	jal	800015a0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002206:	70a2                	ld	ra,40(sp)
    80002208:	7402                	ld	s0,32(sp)
    8000220a:	64e2                	ld	s1,24(sp)
    8000220c:	6942                	ld	s2,16(sp)
    8000220e:	69a2                	ld	s3,8(sp)
    80002210:	6a02                	ld	s4,0(sp)
    80002212:	6145                	add	sp,sp,48
    80002214:	8082                	ret
    memmove(dst, (char*)src, len);
    80002216:	000a061b          	sext.w	a2,s4
    8000221a:	85ce                	mv	a1,s3
    8000221c:	854a                	mv	a0,s2
    8000221e:	ab3fe0ef          	jal	80000cd0 <memmove>
    return 0;
    80002222:	8526                	mv	a0,s1
    80002224:	b7cd                	j	80002206 <either_copyin+0x2a>

0000000080002226 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002226:	715d                	add	sp,sp,-80
    80002228:	e486                	sd	ra,72(sp)
    8000222a:	e0a2                	sd	s0,64(sp)
    8000222c:	fc26                	sd	s1,56(sp)
    8000222e:	f84a                	sd	s2,48(sp)
    80002230:	f44e                	sd	s3,40(sp)
    80002232:	f052                	sd	s4,32(sp)
    80002234:	ec56                	sd	s5,24(sp)
    80002236:	e85a                	sd	s6,16(sp)
    80002238:	e45e                	sd	s7,8(sp)
    8000223a:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000223c:	00005517          	auipc	a0,0x5
    80002240:	e8450513          	add	a0,a0,-380 # 800070c0 <digits+0x88>
    80002244:	a5afe0ef          	jal	8000049e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002248:	0000e497          	auipc	s1,0xe
    8000224c:	ec048493          	add	s1,s1,-320 # 80010108 <proc+0x158>
    80002250:	00025917          	auipc	s2,0x25
    80002254:	6b890913          	add	s2,s2,1720 # 80027908 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002258:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000225a:	00005997          	auipc	s3,0x5
    8000225e:	05e98993          	add	s3,s3,94 # 800072b8 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    80002262:	00005a97          	auipc	s5,0x5
    80002266:	05ea8a93          	add	s5,s5,94 # 800072c0 <digits+0x288>
    printf("\n");
    8000226a:	00005a17          	auipc	s4,0x5
    8000226e:	e56a0a13          	add	s4,s4,-426 # 800070c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002272:	00005b97          	auipc	s7,0x5
    80002276:	08eb8b93          	add	s7,s7,142 # 80007300 <states.0>
    8000227a:	a829                	j	80002294 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000227c:	ed86a583          	lw	a1,-296(a3)
    80002280:	8556                	mv	a0,s5
    80002282:	a1cfe0ef          	jal	8000049e <printf>
    printf("\n");
    80002286:	8552                	mv	a0,s4
    80002288:	a16fe0ef          	jal	8000049e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000228c:	17848493          	add	s1,s1,376
    80002290:	03248263          	beq	s1,s2,800022b4 <procdump+0x8e>
    if(p->state == UNUSED)
    80002294:	86a6                	mv	a3,s1
    80002296:	ec04a783          	lw	a5,-320(s1)
    8000229a:	dbed                	beqz	a5,8000228c <procdump+0x66>
      state = "???";
    8000229c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000229e:	fcfb6fe3          	bltu	s6,a5,8000227c <procdump+0x56>
    800022a2:	02079713          	sll	a4,a5,0x20
    800022a6:	01d75793          	srl	a5,a4,0x1d
    800022aa:	97de                	add	a5,a5,s7
    800022ac:	6390                	ld	a2,0(a5)
    800022ae:	f679                	bnez	a2,8000227c <procdump+0x56>
      state = "???";
    800022b0:	864e                	mv	a2,s3
    800022b2:	b7e9                	j	8000227c <procdump+0x56>
  }
}
    800022b4:	60a6                	ld	ra,72(sp)
    800022b6:	6406                	ld	s0,64(sp)
    800022b8:	74e2                	ld	s1,56(sp)
    800022ba:	7942                	ld	s2,48(sp)
    800022bc:	79a2                	ld	s3,40(sp)
    800022be:	7a02                	ld	s4,32(sp)
    800022c0:	6ae2                	ld	s5,24(sp)
    800022c2:	6b42                	ld	s6,16(sp)
    800022c4:	6ba2                	ld	s7,8(sp)
    800022c6:	6161                	add	sp,sp,80
    800022c8:	8082                	ret

00000000800022ca <sys_tempo_total>:


int sys_tempo_total(void){
    800022ca:	1101                	add	sp,sp,-32
    800022cc:	ec06                	sd	ra,24(sp)
    800022ce:	e822                	sd	s0,16(sp)
    800022d0:	1000                	add	s0,sp,32
  int pid;
  struct proc *p;

  argint(0, &pid);  //Chama a função, que modifica o valor de pid
    800022d2:	fec40593          	add	a1,s0,-20
    800022d6:	4501                	li	a0,0
    800022d8:	63c000ef          	jal	80002914 <argint>
  if (pid < 0) {
    800022dc:	fec42683          	lw	a3,-20(s0)
    800022e0:	0206c963          	bltz	a3,80002312 <sys_tempo_total+0x48>
      // Tratar erro, já que o pid não pode ser negativo
      return -1;
  }
  //Busca o processo com o PID fornecido
  for(p = proc; p < &proc[NPROC]; p++) {
    800022e4:	0000e797          	auipc	a5,0xe
    800022e8:	ccc78793          	add	a5,a5,-820 # 8000ffb0 <proc>
    800022ec:	00025617          	auipc	a2,0x25
    800022f0:	4c460613          	add	a2,a2,1220 # 800277b0 <tickslock>
      if(p->pid == pid) {
    800022f4:	5b98                	lw	a4,48(a5)
    800022f6:	00d70863          	beq	a4,a3,80002306 <sys_tempo_total+0x3c>
  for(p = proc; p < &proc[NPROC]; p++) {
    800022fa:	17878793          	add	a5,a5,376
    800022fe:	fec79be3          	bne	a5,a2,800022f4 <sys_tempo_total+0x2a>
          return p->tempo_total;
      }
  }

  return -1;  //Se o processo não for encontrado
    80002302:	557d                	li	a0,-1
    80002304:	a019                	j	8000230a <sys_tempo_total+0x40>
          return p->tempo_total;
    80002306:	1687a503          	lw	a0,360(a5)
}
    8000230a:	60e2                	ld	ra,24(sp)
    8000230c:	6442                	ld	s0,16(sp)
    8000230e:	6105                	add	sp,sp,32
    80002310:	8082                	ret
      return -1;
    80002312:	557d                	li	a0,-1
    80002314:	bfdd                	j	8000230a <sys_tempo_total+0x40>

0000000080002316 <sys_get_overhead>:


int sys_get_overhead(void){
    80002316:	1101                	add	sp,sp,-32
    80002318:	ec06                	sd	ra,24(sp)
    8000231a:	e822                	sd	s0,16(sp)
    8000231c:	1000                	add	s0,sp,32
  int index;

  argint(0, &index);
    8000231e:	fec40593          	add	a1,s0,-20
    80002322:	4501                	li	a0,0
    80002324:	5f0000ef          	jal	80002914 <argint>
  return overheads[index];
    80002328:	fec42703          	lw	a4,-20(s0)
    8000232c:	070a                	sll	a4,a4,0x2
    8000232e:	0000d797          	auipc	a5,0xd
    80002332:	76278793          	add	a5,a5,1890 # 8000fa90 <pid_lock>
    80002336:	97ba                	add	a5,a5,a4
}
    80002338:	4307a503          	lw	a0,1072(a5)
    8000233c:	60e2                	ld	ra,24(sp)
    8000233e:	6442                	ld	s0,16(sp)
    80002340:	6105                	add	sp,sp,32
    80002342:	8082                	ret

0000000080002344 <sys_get_eficiencia>:


int sys_get_eficiencia(void){
    80002344:	1101                	add	sp,sp,-32
    80002346:	ec06                	sd	ra,24(sp)
    80002348:	e822                	sd	s0,16(sp)
    8000234a:	1000                	add	s0,sp,32
  int index;
  
  argint(0, &index);
    8000234c:	fec40593          	add	a1,s0,-20
    80002350:	4501                	li	a0,0
    80002352:	5c2000ef          	jal	80002914 <argint>
  return eficiencias[index];
    80002356:	fec42703          	lw	a4,-20(s0)
    8000235a:	070a                	sll	a4,a4,0x2
    8000235c:	0000d797          	auipc	a5,0xd
    80002360:	73478793          	add	a5,a5,1844 # 8000fa90 <pid_lock>
    80002364:	97ba                	add	a5,a5,a4
}
    80002366:	4807a503          	lw	a0,1152(a5)
    8000236a:	60e2                	ld	ra,24(sp)
    8000236c:	6442                	ld	s0,16(sp)
    8000236e:	6105                	add	sp,sp,32
    80002370:	8082                	ret

0000000080002372 <sys_increment_metric>:

int sys_increment_metric(void){
    80002372:	1101                	add	sp,sp,-32
    80002374:	ec06                	sd	ra,24(sp)
    80002376:	e822                	sd	s0,16(sp)
    80002378:	1000                	add	s0,sp,32
  int index, amount, mode;

  argint(0, &index);
    8000237a:	fec40593          	add	a1,s0,-20
    8000237e:	4501                	li	a0,0
    80002380:	594000ef          	jal	80002914 <argint>
  argint(1, &amount);
    80002384:	fe840593          	add	a1,s0,-24
    80002388:	4505                	li	a0,1
    8000238a:	58a000ef          	jal	80002914 <argint>
  argint(2, &mode);
    8000238e:	fe440593          	add	a1,s0,-28
    80002392:	4509                	li	a0,2
    80002394:	580000ef          	jal	80002914 <argint>

  if (mode == MODE_OVERHEAD){
    80002398:	fe442783          	lw	a5,-28(s0)
    8000239c:	4721                	li	a4,8
    8000239e:	02e78963          	beq	a5,a4,800023d0 <sys_increment_metric+0x5e>
    overheads[index] += amount;
    return 0;
  } else if (mode == MODE_EFICIENCIA) {
    800023a2:	4729                	li	a4,10
    800023a4:	04e79763          	bne	a5,a4,800023f2 <sys_increment_metric+0x80>
    eficiencias[index] += amount;
    800023a8:	fec42703          	lw	a4,-20(s0)
    800023ac:	070a                	sll	a4,a4,0x2
    800023ae:	0000d797          	auipc	a5,0xd
    800023b2:	6e278793          	add	a5,a5,1762 # 8000fa90 <pid_lock>
    800023b6:	97ba                	add	a5,a5,a4
    800023b8:	4807a683          	lw	a3,1152(a5)
    800023bc:	fe842703          	lw	a4,-24(s0)
    800023c0:	9f35                	addw	a4,a4,a3
    800023c2:	48e7a023          	sw	a4,1152(a5)
    return 0;
    800023c6:	4501                	li	a0,0
  }

  return -1;

}
    800023c8:	60e2                	ld	ra,24(sp)
    800023ca:	6442                	ld	s0,16(sp)
    800023cc:	6105                	add	sp,sp,32
    800023ce:	8082                	ret
    overheads[index] += amount;
    800023d0:	fec42703          	lw	a4,-20(s0)
    800023d4:	070a                	sll	a4,a4,0x2
    800023d6:	0000d797          	auipc	a5,0xd
    800023da:	6ba78793          	add	a5,a5,1722 # 8000fa90 <pid_lock>
    800023de:	97ba                	add	a5,a5,a4
    800023e0:	4307a683          	lw	a3,1072(a5)
    800023e4:	fe842703          	lw	a4,-24(s0)
    800023e8:	9f35                	addw	a4,a4,a3
    800023ea:	42e7a823          	sw	a4,1072(a5)
    return 0;
    800023ee:	4501                	li	a0,0
    800023f0:	bfe1                	j	800023c8 <sys_increment_metric+0x56>
  return -1;
    800023f2:	557d                	li	a0,-1
    800023f4:	bfd1                	j	800023c8 <sys_increment_metric+0x56>

00000000800023f6 <sys_initialize_metrics>:

int sys_initialize_metrics(void){
    800023f6:	1141                	add	sp,sp,-16
    800023f8:	e422                	sd	s0,8(sp)
    800023fa:	0800                	add	s0,sp,16
  for (int k = 0; k < 20; k++){
    800023fc:	0000e797          	auipc	a5,0xe
    80002400:	ac478793          	add	a5,a5,-1340 # 8000fec0 <overheads>
    80002404:	0000e717          	auipc	a4,0xe
    80002408:	b0c70713          	add	a4,a4,-1268 # 8000ff10 <eficiencias>
    8000240c:	0000e697          	auipc	a3,0xe
    80002410:	b5468693          	add	a3,a3,-1196 # 8000ff60 <justicas>
    80002414:	863a                	mv	a2,a4
    overheads[k] = 0;
    80002416:	0007a023          	sw	zero,0(a5)
    eficiencias[k] = 0;
    8000241a:	00072023          	sw	zero,0(a4)
    justicas[k] = 0;
    8000241e:	0006a023          	sw	zero,0(a3)
  for (int k = 0; k < 20; k++){
    80002422:	0791                	add	a5,a5,4
    80002424:	0711                	add	a4,a4,4
    80002426:	0691                	add	a3,a3,4
    80002428:	fec797e3          	bne	a5,a2,80002416 <sys_initialize_metrics+0x20>
  }
  return 0;
}
    8000242c:	4501                	li	a0,0
    8000242e:	6422                	ld	s0,8(sp)
    80002430:	0141                	add	sp,sp,16
    80002432:	8082                	ret

0000000080002434 <sys_get_justica>:

int sys_get_justica(void){
    80002434:	1101                	add	sp,sp,-32
    80002436:	ec06                	sd	ra,24(sp)
    80002438:	e822                	sd	s0,16(sp)
    8000243a:	1000                	add	s0,sp,32
  int index;
  argint(0, &index);
    8000243c:	fec40593          	add	a1,s0,-20
    80002440:	4501                	li	a0,0
    80002442:	4d2000ef          	jal	80002914 <argint>
  return justicas[index];
    80002446:	fec42703          	lw	a4,-20(s0)
    8000244a:	070a                	sll	a4,a4,0x2
    8000244c:	0000d797          	auipc	a5,0xd
    80002450:	64478793          	add	a5,a5,1604 # 8000fa90 <pid_lock>
    80002454:	97ba                	add	a5,a5,a4
}
    80002456:	4d07a503          	lw	a0,1232(a5)
    8000245a:	60e2                	ld	ra,24(sp)
    8000245c:	6442                	ld	s0,16(sp)
    8000245e:	6105                	add	sp,sp,32
    80002460:	8082                	ret

0000000080002462 <sys_set_justica>:

int sys_set_justica(void){
    80002462:	1101                	add	sp,sp,-32
    80002464:	ec06                	sd	ra,24(sp)
    80002466:	e822                	sd	s0,16(sp)
    80002468:	1000                	add	s0,sp,32
  int index, pid;
  struct proc *p;

  argint(0, &index);
    8000246a:	fec40593          	add	a1,s0,-20
    8000246e:	4501                	li	a0,0
    80002470:	4a4000ef          	jal	80002914 <argint>
  argint(1, &pid);
    80002474:	fe840593          	add	a1,s0,-24
    80002478:	4505                	li	a0,1
    8000247a:	49a000ef          	jal	80002914 <argint>

  for(p = proc; p < &proc[NPROC]; p++) {
    if(p->pid == pid) {
    8000247e:	fe842603          	lw	a2,-24(s0)
        justicas[index] = p->tempo_total;
    80002482:	fec42703          	lw	a4,-20(s0)
  for(p = proc; p < &proc[NPROC]; p++) {
    80002486:	0000e797          	auipc	a5,0xe
    8000248a:	b2a78793          	add	a5,a5,-1238 # 8000ffb0 <proc>
        justicas[index] = p->tempo_total;
    8000248e:	070a                	sll	a4,a4,0x2
    80002490:	0000d597          	auipc	a1,0xd
    80002494:	60058593          	add	a1,a1,1536 # 8000fa90 <pid_lock>
    80002498:	95ba                	add	a1,a1,a4
  for(p = proc; p < &proc[NPROC]; p++) {
    8000249a:	00025697          	auipc	a3,0x25
    8000249e:	31668693          	add	a3,a3,790 # 800277b0 <tickslock>
    800024a2:	a029                	j	800024ac <sys_set_justica+0x4a>
    800024a4:	17878793          	add	a5,a5,376
    800024a8:	00d78a63          	beq	a5,a3,800024bc <sys_set_justica+0x5a>
    if(p->pid == pid) {
    800024ac:	5b98                	lw	a4,48(a5)
    800024ae:	fec71be3          	bne	a4,a2,800024a4 <sys_set_justica+0x42>
        justicas[index] = p->tempo_total;
    800024b2:	1687a703          	lw	a4,360(a5)
    800024b6:	4ce5a823          	sw	a4,1232(a1)
    800024ba:	b7ed                	j	800024a4 <sys_set_justica+0x42>
    }
  }
  return 0;
    800024bc:	4501                	li	a0,0
    800024be:	60e2                	ld	ra,24(sp)
    800024c0:	6442                	ld	s0,16(sp)
    800024c2:	6105                	add	sp,sp,32
    800024c4:	8082                	ret

00000000800024c6 <swtch>:
    800024c6:	00153023          	sd	ra,0(a0)
    800024ca:	00253423          	sd	sp,8(a0)
    800024ce:	e900                	sd	s0,16(a0)
    800024d0:	ed04                	sd	s1,24(a0)
    800024d2:	03253023          	sd	s2,32(a0)
    800024d6:	03353423          	sd	s3,40(a0)
    800024da:	03453823          	sd	s4,48(a0)
    800024de:	03553c23          	sd	s5,56(a0)
    800024e2:	05653023          	sd	s6,64(a0)
    800024e6:	05753423          	sd	s7,72(a0)
    800024ea:	05853823          	sd	s8,80(a0)
    800024ee:	05953c23          	sd	s9,88(a0)
    800024f2:	07a53023          	sd	s10,96(a0)
    800024f6:	07b53423          	sd	s11,104(a0)
    800024fa:	0005b083          	ld	ra,0(a1)
    800024fe:	0085b103          	ld	sp,8(a1)
    80002502:	6980                	ld	s0,16(a1)
    80002504:	6d84                	ld	s1,24(a1)
    80002506:	0205b903          	ld	s2,32(a1)
    8000250a:	0285b983          	ld	s3,40(a1)
    8000250e:	0305ba03          	ld	s4,48(a1)
    80002512:	0385ba83          	ld	s5,56(a1)
    80002516:	0405bb03          	ld	s6,64(a1)
    8000251a:	0485bb83          	ld	s7,72(a1)
    8000251e:	0505bc03          	ld	s8,80(a1)
    80002522:	0585bc83          	ld	s9,88(a1)
    80002526:	0605bd03          	ld	s10,96(a1)
    8000252a:	0685bd83          	ld	s11,104(a1)
    8000252e:	8082                	ret

0000000080002530 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002530:	1141                	add	sp,sp,-16
    80002532:	e406                	sd	ra,8(sp)
    80002534:	e022                	sd	s0,0(sp)
    80002536:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80002538:	00005597          	auipc	a1,0x5
    8000253c:	df858593          	add	a1,a1,-520 # 80007330 <states.0+0x30>
    80002540:	00025517          	auipc	a0,0x25
    80002544:	27050513          	add	a0,a0,624 # 800277b0 <tickslock>
    80002548:	dd8fe0ef          	jal	80000b20 <initlock>
}
    8000254c:	60a2                	ld	ra,8(sp)
    8000254e:	6402                	ld	s0,0(sp)
    80002550:	0141                	add	sp,sp,16
    80002552:	8082                	ret

0000000080002554 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002554:	1141                	add	sp,sp,-16
    80002556:	e422                	sd	s0,8(sp)
    80002558:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000255a:	00003797          	auipc	a5,0x3
    8000255e:	cd678793          	add	a5,a5,-810 # 80005230 <kernelvec>
    80002562:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002566:	6422                	ld	s0,8(sp)
    80002568:	0141                	add	sp,sp,16
    8000256a:	8082                	ret

000000008000256c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000256c:	1141                	add	sp,sp,-16
    8000256e:	e406                	sd	ra,8(sp)
    80002570:	e022                	sd	s0,0(sp)
    80002572:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80002574:	abcff0ef          	jal	80001830 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002578:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000257c:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000257e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002582:	00004697          	auipc	a3,0x4
    80002586:	a7e68693          	add	a3,a3,-1410 # 80006000 <_trampoline>
    8000258a:	00004717          	auipc	a4,0x4
    8000258e:	a7670713          	add	a4,a4,-1418 # 80006000 <_trampoline>
    80002592:	8f15                	sub	a4,a4,a3
    80002594:	040007b7          	lui	a5,0x4000
    80002598:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000259a:	07b2                	sll	a5,a5,0xc
    8000259c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000259e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800025a2:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800025a4:	18002673          	csrr	a2,satp
    800025a8:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800025aa:	6d30                	ld	a2,88(a0)
    800025ac:	6138                	ld	a4,64(a0)
    800025ae:	6585                	lui	a1,0x1
    800025b0:	972e                	add	a4,a4,a1
    800025b2:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800025b4:	6d38                	ld	a4,88(a0)
    800025b6:	00000617          	auipc	a2,0x0
    800025ba:	10c60613          	add	a2,a2,268 # 800026c2 <usertrap>
    800025be:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800025c0:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800025c2:	8612                	mv	a2,tp
    800025c4:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025c6:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800025ca:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800025ce:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025d2:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800025d6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800025d8:	6f18                	ld	a4,24(a4)
    800025da:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800025de:	6928                	ld	a0,80(a0)
    800025e0:	8131                	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800025e2:	00004717          	auipc	a4,0x4
    800025e6:	aba70713          	add	a4,a4,-1350 # 8000609c <userret>
    800025ea:	8f15                	sub	a4,a4,a3
    800025ec:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800025ee:	577d                	li	a4,-1
    800025f0:	177e                	sll	a4,a4,0x3f
    800025f2:	8d59                	or	a0,a0,a4
    800025f4:	9782                	jalr	a5
}
    800025f6:	60a2                	ld	ra,8(sp)
    800025f8:	6402                	ld	s0,0(sp)
    800025fa:	0141                	add	sp,sp,16
    800025fc:	8082                	ret

00000000800025fe <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800025fe:	1101                	add	sp,sp,-32
    80002600:	ec06                	sd	ra,24(sp)
    80002602:	e822                	sd	s0,16(sp)
    80002604:	e426                	sd	s1,8(sp)
    80002606:	1000                	add	s0,sp,32
  if(cpuid() == 0){
    80002608:	9fcff0ef          	jal	80001804 <cpuid>
    8000260c:	cd19                	beqz	a0,8000262a <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000260e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002612:	000f4737          	lui	a4,0xf4
    80002616:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000261a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000261c:	14d79073          	csrw	stimecmp,a5
}
    80002620:	60e2                	ld	ra,24(sp)
    80002622:	6442                	ld	s0,16(sp)
    80002624:	64a2                	ld	s1,8(sp)
    80002626:	6105                	add	sp,sp,32
    80002628:	8082                	ret
    acquire(&tickslock);
    8000262a:	00025497          	auipc	s1,0x25
    8000262e:	18648493          	add	s1,s1,390 # 800277b0 <tickslock>
    80002632:	8526                	mv	a0,s1
    80002634:	d6cfe0ef          	jal	80000ba0 <acquire>
    ticks++;
    80002638:	00005517          	auipc	a0,0x5
    8000263c:	32850513          	add	a0,a0,808 # 80007960 <ticks>
    80002640:	411c                	lw	a5,0(a0)
    80002642:	2785                	addw	a5,a5,1
    80002644:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002646:	843ff0ef          	jal	80001e88 <wakeup>
    release(&tickslock);
    8000264a:	8526                	mv	a0,s1
    8000264c:	decfe0ef          	jal	80000c38 <release>
    80002650:	bf7d                	j	8000260e <clockintr+0x10>

0000000080002652 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002652:	1101                	add	sp,sp,-32
    80002654:	ec06                	sd	ra,24(sp)
    80002656:	e822                	sd	s0,16(sp)
    80002658:	e426                	sd	s1,8(sp)
    8000265a:	1000                	add	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000265c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002660:	57fd                	li	a5,-1
    80002662:	17fe                	sll	a5,a5,0x3f
    80002664:	07a5                	add	a5,a5,9
    80002666:	00f70d63          	beq	a4,a5,80002680 <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000266a:	57fd                	li	a5,-1
    8000266c:	17fe                	sll	a5,a5,0x3f
    8000266e:	0795                	add	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002670:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002672:	04f70463          	beq	a4,a5,800026ba <devintr+0x68>
  }
}
    80002676:	60e2                	ld	ra,24(sp)
    80002678:	6442                	ld	s0,16(sp)
    8000267a:	64a2                	ld	s1,8(sp)
    8000267c:	6105                	add	sp,sp,32
    8000267e:	8082                	ret
    int irq = plic_claim();
    80002680:	459020ef          	jal	800052d8 <plic_claim>
    80002684:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002686:	47a9                	li	a5,10
    80002688:	02f50363          	beq	a0,a5,800026ae <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    8000268c:	4785                	li	a5,1
    8000268e:	02f50363          	beq	a0,a5,800026b4 <devintr+0x62>
    return 1;
    80002692:	4505                	li	a0,1
    } else if(irq){
    80002694:	d0ed                	beqz	s1,80002676 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80002696:	85a6                	mv	a1,s1
    80002698:	00005517          	auipc	a0,0x5
    8000269c:	ca050513          	add	a0,a0,-864 # 80007338 <states.0+0x38>
    800026a0:	dfffd0ef          	jal	8000049e <printf>
      plic_complete(irq);
    800026a4:	8526                	mv	a0,s1
    800026a6:	453020ef          	jal	800052f8 <plic_complete>
    return 1;
    800026aa:	4505                	li	a0,1
    800026ac:	b7e9                	j	80002676 <devintr+0x24>
      uartintr();
    800026ae:	b04fe0ef          	jal	800009b2 <uartintr>
    if(irq)
    800026b2:	bfcd                	j	800026a4 <devintr+0x52>
      virtio_disk_intr();
    800026b4:	0ae030ef          	jal	80005762 <virtio_disk_intr>
    if(irq)
    800026b8:	b7f5                	j	800026a4 <devintr+0x52>
    clockintr();
    800026ba:	f45ff0ef          	jal	800025fe <clockintr>
    return 2;
    800026be:	4509                	li	a0,2
    800026c0:	bf5d                	j	80002676 <devintr+0x24>

00000000800026c2 <usertrap>:
{
    800026c2:	1101                	add	sp,sp,-32
    800026c4:	ec06                	sd	ra,24(sp)
    800026c6:	e822                	sd	s0,16(sp)
    800026c8:	e426                	sd	s1,8(sp)
    800026ca:	e04a                	sd	s2,0(sp)
    800026cc:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026ce:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800026d2:	1007f793          	and	a5,a5,256
    800026d6:	ef85                	bnez	a5,8000270e <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026d8:	00003797          	auipc	a5,0x3
    800026dc:	b5878793          	add	a5,a5,-1192 # 80005230 <kernelvec>
    800026e0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800026e4:	94cff0ef          	jal	80001830 <myproc>
    800026e8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800026ea:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026ec:	14102773          	csrr	a4,sepc
    800026f0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026f2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800026f6:	47a1                	li	a5,8
    800026f8:	02f70163          	beq	a4,a5,8000271a <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800026fc:	f57ff0ef          	jal	80002652 <devintr>
    80002700:	892a                	mv	s2,a0
    80002702:	c135                	beqz	a0,80002766 <usertrap+0xa4>
  if(killed(p))
    80002704:	8526                	mv	a0,s1
    80002706:	96fff0ef          	jal	80002074 <killed>
    8000270a:	cd1d                	beqz	a0,80002748 <usertrap+0x86>
    8000270c:	a81d                	j	80002742 <usertrap+0x80>
    panic("usertrap: not from user mode");
    8000270e:	00005517          	auipc	a0,0x5
    80002712:	c4a50513          	add	a0,a0,-950 # 80007358 <states.0+0x58>
    80002716:	848fe0ef          	jal	8000075e <panic>
    if(killed(p))
    8000271a:	95bff0ef          	jal	80002074 <killed>
    8000271e:	e121                	bnez	a0,8000275e <usertrap+0x9c>
    p->trapframe->epc += 4;
    80002720:	6cb8                	ld	a4,88(s1)
    80002722:	6f1c                	ld	a5,24(a4)
    80002724:	0791                	add	a5,a5,4
    80002726:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002728:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000272c:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002730:	10079073          	csrw	sstatus,a5
    syscall();
    80002734:	248000ef          	jal	8000297c <syscall>
  if(killed(p))
    80002738:	8526                	mv	a0,s1
    8000273a:	93bff0ef          	jal	80002074 <killed>
    8000273e:	c901                	beqz	a0,8000274e <usertrap+0x8c>
    80002740:	4901                	li	s2,0
    exit(-1);
    80002742:	557d                	li	a0,-1
    80002744:	805ff0ef          	jal	80001f48 <exit>
  if(which_dev == 2)
    80002748:	4789                	li	a5,2
    8000274a:	04f90563          	beq	s2,a5,80002794 <usertrap+0xd2>
  usertrapret();
    8000274e:	e1fff0ef          	jal	8000256c <usertrapret>
}
    80002752:	60e2                	ld	ra,24(sp)
    80002754:	6442                	ld	s0,16(sp)
    80002756:	64a2                	ld	s1,8(sp)
    80002758:	6902                	ld	s2,0(sp)
    8000275a:	6105                	add	sp,sp,32
    8000275c:	8082                	ret
      exit(-1);
    8000275e:	557d                	li	a0,-1
    80002760:	fe8ff0ef          	jal	80001f48 <exit>
    80002764:	bf75                	j	80002720 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002766:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000276a:	5890                	lw	a2,48(s1)
    8000276c:	00005517          	auipc	a0,0x5
    80002770:	c0c50513          	add	a0,a0,-1012 # 80007378 <states.0+0x78>
    80002774:	d2bfd0ef          	jal	8000049e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002778:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000277c:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002780:	00005517          	auipc	a0,0x5
    80002784:	c2850513          	add	a0,a0,-984 # 800073a8 <states.0+0xa8>
    80002788:	d17fd0ef          	jal	8000049e <printf>
    setkilled(p);
    8000278c:	8526                	mv	a0,s1
    8000278e:	8c3ff0ef          	jal	80002050 <setkilled>
    80002792:	b75d                	j	80002738 <usertrap+0x76>
    yield();
    80002794:	e7cff0ef          	jal	80001e10 <yield>
    80002798:	bf5d                	j	8000274e <usertrap+0x8c>

000000008000279a <kerneltrap>:
{
    8000279a:	7179                	add	sp,sp,-48
    8000279c:	f406                	sd	ra,40(sp)
    8000279e:	f022                	sd	s0,32(sp)
    800027a0:	ec26                	sd	s1,24(sp)
    800027a2:	e84a                	sd	s2,16(sp)
    800027a4:	e44e                	sd	s3,8(sp)
    800027a6:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027a8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ac:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027b0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800027b4:	1004f793          	and	a5,s1,256
    800027b8:	c795                	beqz	a5,800027e4 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800027be:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    800027c0:	eb85                	bnez	a5,800027f0 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800027c2:	e91ff0ef          	jal	80002652 <devintr>
    800027c6:	c91d                	beqz	a0,800027fc <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    800027c8:	4789                	li	a5,2
    800027ca:	04f50a63          	beq	a0,a5,8000281e <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800027ce:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027d2:	10049073          	csrw	sstatus,s1
}
    800027d6:	70a2                	ld	ra,40(sp)
    800027d8:	7402                	ld	s0,32(sp)
    800027da:	64e2                	ld	s1,24(sp)
    800027dc:	6942                	ld	s2,16(sp)
    800027de:	69a2                	ld	s3,8(sp)
    800027e0:	6145                	add	sp,sp,48
    800027e2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800027e4:	00005517          	auipc	a0,0x5
    800027e8:	bec50513          	add	a0,a0,-1044 # 800073d0 <states.0+0xd0>
    800027ec:	f73fd0ef          	jal	8000075e <panic>
    panic("kerneltrap: interrupts enabled");
    800027f0:	00005517          	auipc	a0,0x5
    800027f4:	c0850513          	add	a0,a0,-1016 # 800073f8 <states.0+0xf8>
    800027f8:	f67fd0ef          	jal	8000075e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027fc:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002800:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002804:	85ce                	mv	a1,s3
    80002806:	00005517          	auipc	a0,0x5
    8000280a:	c1250513          	add	a0,a0,-1006 # 80007418 <states.0+0x118>
    8000280e:	c91fd0ef          	jal	8000049e <printf>
    panic("kerneltrap");
    80002812:	00005517          	auipc	a0,0x5
    80002816:	c2e50513          	add	a0,a0,-978 # 80007440 <states.0+0x140>
    8000281a:	f45fd0ef          	jal	8000075e <panic>
  if(which_dev == 2 && myproc() != 0)
    8000281e:	812ff0ef          	jal	80001830 <myproc>
    80002822:	d555                	beqz	a0,800027ce <kerneltrap+0x34>
    yield();
    80002824:	decff0ef          	jal	80001e10 <yield>
    80002828:	b75d                	j	800027ce <kerneltrap+0x34>

000000008000282a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000282a:	1101                	add	sp,sp,-32
    8000282c:	ec06                	sd	ra,24(sp)
    8000282e:	e822                	sd	s0,16(sp)
    80002830:	e426                	sd	s1,8(sp)
    80002832:	1000                	add	s0,sp,32
    80002834:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002836:	ffbfe0ef          	jal	80001830 <myproc>
  switch (n) {
    8000283a:	4795                	li	a5,5
    8000283c:	0497e163          	bltu	a5,s1,8000287e <argraw+0x54>
    80002840:	048a                	sll	s1,s1,0x2
    80002842:	00005717          	auipc	a4,0x5
    80002846:	c3670713          	add	a4,a4,-970 # 80007478 <states.0+0x178>
    8000284a:	94ba                	add	s1,s1,a4
    8000284c:	409c                	lw	a5,0(s1)
    8000284e:	97ba                	add	a5,a5,a4
    80002850:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002852:	6d3c                	ld	a5,88(a0)
    80002854:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002856:	60e2                	ld	ra,24(sp)
    80002858:	6442                	ld	s0,16(sp)
    8000285a:	64a2                	ld	s1,8(sp)
    8000285c:	6105                	add	sp,sp,32
    8000285e:	8082                	ret
    return p->trapframe->a1;
    80002860:	6d3c                	ld	a5,88(a0)
    80002862:	7fa8                	ld	a0,120(a5)
    80002864:	bfcd                	j	80002856 <argraw+0x2c>
    return p->trapframe->a2;
    80002866:	6d3c                	ld	a5,88(a0)
    80002868:	63c8                	ld	a0,128(a5)
    8000286a:	b7f5                	j	80002856 <argraw+0x2c>
    return p->trapframe->a3;
    8000286c:	6d3c                	ld	a5,88(a0)
    8000286e:	67c8                	ld	a0,136(a5)
    80002870:	b7dd                	j	80002856 <argraw+0x2c>
    return p->trapframe->a4;
    80002872:	6d3c                	ld	a5,88(a0)
    80002874:	6bc8                	ld	a0,144(a5)
    80002876:	b7c5                	j	80002856 <argraw+0x2c>
    return p->trapframe->a5;
    80002878:	6d3c                	ld	a5,88(a0)
    8000287a:	6fc8                	ld	a0,152(a5)
    8000287c:	bfe9                	j	80002856 <argraw+0x2c>
  panic("argraw");
    8000287e:	00005517          	auipc	a0,0x5
    80002882:	bd250513          	add	a0,a0,-1070 # 80007450 <states.0+0x150>
    80002886:	ed9fd0ef          	jal	8000075e <panic>

000000008000288a <fetchaddr>:
{
    8000288a:	1101                	add	sp,sp,-32
    8000288c:	ec06                	sd	ra,24(sp)
    8000288e:	e822                	sd	s0,16(sp)
    80002890:	e426                	sd	s1,8(sp)
    80002892:	e04a                	sd	s2,0(sp)
    80002894:	1000                	add	s0,sp,32
    80002896:	84aa                	mv	s1,a0
    80002898:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000289a:	f97fe0ef          	jal	80001830 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000289e:	653c                	ld	a5,72(a0)
    800028a0:	02f4f663          	bgeu	s1,a5,800028cc <fetchaddr+0x42>
    800028a4:	00848713          	add	a4,s1,8
    800028a8:	02e7e463          	bltu	a5,a4,800028d0 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800028ac:	46a1                	li	a3,8
    800028ae:	8626                	mv	a2,s1
    800028b0:	85ca                	mv	a1,s2
    800028b2:	6928                	ld	a0,80(a0)
    800028b4:	cedfe0ef          	jal	800015a0 <copyin>
    800028b8:	00a03533          	snez	a0,a0
    800028bc:	40a00533          	neg	a0,a0
}
    800028c0:	60e2                	ld	ra,24(sp)
    800028c2:	6442                	ld	s0,16(sp)
    800028c4:	64a2                	ld	s1,8(sp)
    800028c6:	6902                	ld	s2,0(sp)
    800028c8:	6105                	add	sp,sp,32
    800028ca:	8082                	ret
    return -1;
    800028cc:	557d                	li	a0,-1
    800028ce:	bfcd                	j	800028c0 <fetchaddr+0x36>
    800028d0:	557d                	li	a0,-1
    800028d2:	b7fd                	j	800028c0 <fetchaddr+0x36>

00000000800028d4 <fetchstr>:
{
    800028d4:	7179                	add	sp,sp,-48
    800028d6:	f406                	sd	ra,40(sp)
    800028d8:	f022                	sd	s0,32(sp)
    800028da:	ec26                	sd	s1,24(sp)
    800028dc:	e84a                	sd	s2,16(sp)
    800028de:	e44e                	sd	s3,8(sp)
    800028e0:	1800                	add	s0,sp,48
    800028e2:	892a                	mv	s2,a0
    800028e4:	84ae                	mv	s1,a1
    800028e6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800028e8:	f49fe0ef          	jal	80001830 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800028ec:	86ce                	mv	a3,s3
    800028ee:	864a                	mv	a2,s2
    800028f0:	85a6                	mv	a1,s1
    800028f2:	6928                	ld	a0,80(a0)
    800028f4:	d33fe0ef          	jal	80001626 <copyinstr>
    800028f8:	00054c63          	bltz	a0,80002910 <fetchstr+0x3c>
  return strlen(buf);
    800028fc:	8526                	mv	a0,s1
    800028fe:	cecfe0ef          	jal	80000dea <strlen>
}
    80002902:	70a2                	ld	ra,40(sp)
    80002904:	7402                	ld	s0,32(sp)
    80002906:	64e2                	ld	s1,24(sp)
    80002908:	6942                	ld	s2,16(sp)
    8000290a:	69a2                	ld	s3,8(sp)
    8000290c:	6145                	add	sp,sp,48
    8000290e:	8082                	ret
    return -1;
    80002910:	557d                	li	a0,-1
    80002912:	bfc5                	j	80002902 <fetchstr+0x2e>

0000000080002914 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002914:	1101                	add	sp,sp,-32
    80002916:	ec06                	sd	ra,24(sp)
    80002918:	e822                	sd	s0,16(sp)
    8000291a:	e426                	sd	s1,8(sp)
    8000291c:	1000                	add	s0,sp,32
    8000291e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002920:	f0bff0ef          	jal	8000282a <argraw>
    80002924:	c088                	sw	a0,0(s1)
}
    80002926:	60e2                	ld	ra,24(sp)
    80002928:	6442                	ld	s0,16(sp)
    8000292a:	64a2                	ld	s1,8(sp)
    8000292c:	6105                	add	sp,sp,32
    8000292e:	8082                	ret

0000000080002930 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002930:	1101                	add	sp,sp,-32
    80002932:	ec06                	sd	ra,24(sp)
    80002934:	e822                	sd	s0,16(sp)
    80002936:	e426                	sd	s1,8(sp)
    80002938:	1000                	add	s0,sp,32
    8000293a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000293c:	eefff0ef          	jal	8000282a <argraw>
    80002940:	e088                	sd	a0,0(s1)
}
    80002942:	60e2                	ld	ra,24(sp)
    80002944:	6442                	ld	s0,16(sp)
    80002946:	64a2                	ld	s1,8(sp)
    80002948:	6105                	add	sp,sp,32
    8000294a:	8082                	ret

000000008000294c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000294c:	7179                	add	sp,sp,-48
    8000294e:	f406                	sd	ra,40(sp)
    80002950:	f022                	sd	s0,32(sp)
    80002952:	ec26                	sd	s1,24(sp)
    80002954:	e84a                	sd	s2,16(sp)
    80002956:	1800                	add	s0,sp,48
    80002958:	84ae                	mv	s1,a1
    8000295a:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000295c:	fd840593          	add	a1,s0,-40
    80002960:	fd1ff0ef          	jal	80002930 <argaddr>
  return fetchstr(addr, buf, max);
    80002964:	864a                	mv	a2,s2
    80002966:	85a6                	mv	a1,s1
    80002968:	fd843503          	ld	a0,-40(s0)
    8000296c:	f69ff0ef          	jal	800028d4 <fetchstr>
}
    80002970:	70a2                	ld	ra,40(sp)
    80002972:	7402                	ld	s0,32(sp)
    80002974:	64e2                	ld	s1,24(sp)
    80002976:	6942                	ld	s2,16(sp)
    80002978:	6145                	add	sp,sp,48
    8000297a:	8082                	ret

000000008000297c <syscall>:
[SYS_uptime_nolock] sys_uptime_nolock
};

void
syscall(void)
{
    8000297c:	1101                	add	sp,sp,-32
    8000297e:	ec06                	sd	ra,24(sp)
    80002980:	e822                	sd	s0,16(sp)
    80002982:	e426                	sd	s1,8(sp)
    80002984:	e04a                	sd	s2,0(sp)
    80002986:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002988:	ea9fe0ef          	jal	80001830 <myproc>
    8000298c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000298e:	05853903          	ld	s2,88(a0)
    80002992:	0a893783          	ld	a5,168(s2)
    80002996:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000299a:	37fd                	addw	a5,a5,-1
    8000299c:	4771                	li	a4,28
    8000299e:	00f76f63          	bltu	a4,a5,800029bc <syscall+0x40>
    800029a2:	00369713          	sll	a4,a3,0x3
    800029a6:	00005797          	auipc	a5,0x5
    800029aa:	aea78793          	add	a5,a5,-1302 # 80007490 <syscalls>
    800029ae:	97ba                	add	a5,a5,a4
    800029b0:	639c                	ld	a5,0(a5)
    800029b2:	c789                	beqz	a5,800029bc <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800029b4:	9782                	jalr	a5
    800029b6:	06a93823          	sd	a0,112(s2)
    800029ba:	a829                	j	800029d4 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800029bc:	15848613          	add	a2,s1,344
    800029c0:	588c                	lw	a1,48(s1)
    800029c2:	00005517          	auipc	a0,0x5
    800029c6:	a9650513          	add	a0,a0,-1386 # 80007458 <states.0+0x158>
    800029ca:	ad5fd0ef          	jal	8000049e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800029ce:	6cbc                	ld	a5,88(s1)
    800029d0:	577d                	li	a4,-1
    800029d2:	fbb8                	sd	a4,112(a5)
  }
}
    800029d4:	60e2                	ld	ra,24(sp)
    800029d6:	6442                	ld	s0,16(sp)
    800029d8:	64a2                	ld	s1,8(sp)
    800029da:	6902                	ld	s2,0(sp)
    800029dc:	6105                	add	sp,sp,32
    800029de:	8082                	ret

00000000800029e0 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800029e0:	1101                	add	sp,sp,-32
    800029e2:	ec06                	sd	ra,24(sp)
    800029e4:	e822                	sd	s0,16(sp)
    800029e6:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    800029e8:	fec40593          	add	a1,s0,-20
    800029ec:	4501                	li	a0,0
    800029ee:	f27ff0ef          	jal	80002914 <argint>
  exit(n);
    800029f2:	fec42503          	lw	a0,-20(s0)
    800029f6:	d52ff0ef          	jal	80001f48 <exit>
  return 0;  // not reached
}
    800029fa:	4501                	li	a0,0
    800029fc:	60e2                	ld	ra,24(sp)
    800029fe:	6442                	ld	s0,16(sp)
    80002a00:	6105                	add	sp,sp,32
    80002a02:	8082                	ret

0000000080002a04 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002a04:	1141                	add	sp,sp,-16
    80002a06:	e406                	sd	ra,8(sp)
    80002a08:	e022                	sd	s0,0(sp)
    80002a0a:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002a0c:	e25fe0ef          	jal	80001830 <myproc>
}
    80002a10:	5908                	lw	a0,48(a0)
    80002a12:	60a2                	ld	ra,8(sp)
    80002a14:	6402                	ld	s0,0(sp)
    80002a16:	0141                	add	sp,sp,16
    80002a18:	8082                	ret

0000000080002a1a <sys_fork>:

uint64
sys_fork(void)
{
    80002a1a:	1141                	add	sp,sp,-16
    80002a1c:	e406                	sd	ra,8(sp)
    80002a1e:	e022                	sd	s0,0(sp)
    80002a20:	0800                	add	s0,sp,16
  return fork();
    80002a22:	940ff0ef          	jal	80001b62 <fork>
}
    80002a26:	60a2                	ld	ra,8(sp)
    80002a28:	6402                	ld	s0,0(sp)
    80002a2a:	0141                	add	sp,sp,16
    80002a2c:	8082                	ret

0000000080002a2e <sys_wait>:

uint64
sys_wait(void)
{
    80002a2e:	1101                	add	sp,sp,-32
    80002a30:	ec06                	sd	ra,24(sp)
    80002a32:	e822                	sd	s0,16(sp)
    80002a34:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002a36:	fe840593          	add	a1,s0,-24
    80002a3a:	4501                	li	a0,0
    80002a3c:	ef5ff0ef          	jal	80002930 <argaddr>
  return wait(p);
    80002a40:	fe843503          	ld	a0,-24(s0)
    80002a44:	e5aff0ef          	jal	8000209e <wait>
}
    80002a48:	60e2                	ld	ra,24(sp)
    80002a4a:	6442                	ld	s0,16(sp)
    80002a4c:	6105                	add	sp,sp,32
    80002a4e:	8082                	ret

0000000080002a50 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002a50:	7179                	add	sp,sp,-48
    80002a52:	f406                	sd	ra,40(sp)
    80002a54:	f022                	sd	s0,32(sp)
    80002a56:	ec26                	sd	s1,24(sp)
    80002a58:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002a5a:	fdc40593          	add	a1,s0,-36
    80002a5e:	4501                	li	a0,0
    80002a60:	eb5ff0ef          	jal	80002914 <argint>
  addr = myproc()->sz;
    80002a64:	dcdfe0ef          	jal	80001830 <myproc>
    80002a68:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002a6a:	fdc42503          	lw	a0,-36(s0)
    80002a6e:	8a4ff0ef          	jal	80001b12 <growproc>
    80002a72:	00054863          	bltz	a0,80002a82 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002a76:	8526                	mv	a0,s1
    80002a78:	70a2                	ld	ra,40(sp)
    80002a7a:	7402                	ld	s0,32(sp)
    80002a7c:	64e2                	ld	s1,24(sp)
    80002a7e:	6145                	add	sp,sp,48
    80002a80:	8082                	ret
    return -1;
    80002a82:	54fd                	li	s1,-1
    80002a84:	bfcd                	j	80002a76 <sys_sbrk+0x26>

0000000080002a86 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002a86:	7139                	add	sp,sp,-64
    80002a88:	fc06                	sd	ra,56(sp)
    80002a8a:	f822                	sd	s0,48(sp)
    80002a8c:	f426                	sd	s1,40(sp)
    80002a8e:	f04a                	sd	s2,32(sp)
    80002a90:	ec4e                	sd	s3,24(sp)
    80002a92:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002a94:	fcc40593          	add	a1,s0,-52
    80002a98:	4501                	li	a0,0
    80002a9a:	e7bff0ef          	jal	80002914 <argint>
  if(n < 0)
    80002a9e:	fcc42783          	lw	a5,-52(s0)
    80002aa2:	0607c563          	bltz	a5,80002b0c <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002aa6:	00025517          	auipc	a0,0x25
    80002aaa:	d0a50513          	add	a0,a0,-758 # 800277b0 <tickslock>
    80002aae:	8f2fe0ef          	jal	80000ba0 <acquire>
  ticks0 = ticks;
    80002ab2:	00005917          	auipc	s2,0x5
    80002ab6:	eae92903          	lw	s2,-338(s2) # 80007960 <ticks>
  while(ticks - ticks0 < n){
    80002aba:	fcc42783          	lw	a5,-52(s0)
    80002abe:	cb8d                	beqz	a5,80002af0 <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002ac0:	00025997          	auipc	s3,0x25
    80002ac4:	cf098993          	add	s3,s3,-784 # 800277b0 <tickslock>
    80002ac8:	00005497          	auipc	s1,0x5
    80002acc:	e9848493          	add	s1,s1,-360 # 80007960 <ticks>
    if(killed(myproc())){
    80002ad0:	d61fe0ef          	jal	80001830 <myproc>
    80002ad4:	da0ff0ef          	jal	80002074 <killed>
    80002ad8:	ed0d                	bnez	a0,80002b12 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002ada:	85ce                	mv	a1,s3
    80002adc:	8526                	mv	a0,s1
    80002ade:	b5eff0ef          	jal	80001e3c <sleep>
  while(ticks - ticks0 < n){
    80002ae2:	409c                	lw	a5,0(s1)
    80002ae4:	412787bb          	subw	a5,a5,s2
    80002ae8:	fcc42703          	lw	a4,-52(s0)
    80002aec:	fee7e2e3          	bltu	a5,a4,80002ad0 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002af0:	00025517          	auipc	a0,0x25
    80002af4:	cc050513          	add	a0,a0,-832 # 800277b0 <tickslock>
    80002af8:	940fe0ef          	jal	80000c38 <release>
  return 0;
    80002afc:	4501                	li	a0,0
}
    80002afe:	70e2                	ld	ra,56(sp)
    80002b00:	7442                	ld	s0,48(sp)
    80002b02:	74a2                	ld	s1,40(sp)
    80002b04:	7902                	ld	s2,32(sp)
    80002b06:	69e2                	ld	s3,24(sp)
    80002b08:	6121                	add	sp,sp,64
    80002b0a:	8082                	ret
    n = 0;
    80002b0c:	fc042623          	sw	zero,-52(s0)
    80002b10:	bf59                	j	80002aa6 <sys_sleep+0x20>
      release(&tickslock);
    80002b12:	00025517          	auipc	a0,0x25
    80002b16:	c9e50513          	add	a0,a0,-866 # 800277b0 <tickslock>
    80002b1a:	91efe0ef          	jal	80000c38 <release>
      return -1;
    80002b1e:	557d                	li	a0,-1
    80002b20:	bff9                	j	80002afe <sys_sleep+0x78>

0000000080002b22 <sys_kill>:

uint64
sys_kill(void)
{
    80002b22:	1101                	add	sp,sp,-32
    80002b24:	ec06                	sd	ra,24(sp)
    80002b26:	e822                	sd	s0,16(sp)
    80002b28:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002b2a:	fec40593          	add	a1,s0,-20
    80002b2e:	4501                	li	a0,0
    80002b30:	de5ff0ef          	jal	80002914 <argint>
  return kill(pid);
    80002b34:	fec42503          	lw	a0,-20(s0)
    80002b38:	cb2ff0ef          	jal	80001fea <kill>
}
    80002b3c:	60e2                	ld	ra,24(sp)
    80002b3e:	6442                	ld	s0,16(sp)
    80002b40:	6105                	add	sp,sp,32
    80002b42:	8082                	ret

0000000080002b44 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002b44:	1101                	add	sp,sp,-32
    80002b46:	ec06                	sd	ra,24(sp)
    80002b48:	e822                	sd	s0,16(sp)
    80002b4a:	e426                	sd	s1,8(sp)
    80002b4c:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002b4e:	00025517          	auipc	a0,0x25
    80002b52:	c6250513          	add	a0,a0,-926 # 800277b0 <tickslock>
    80002b56:	84afe0ef          	jal	80000ba0 <acquire>
  xticks = ticks;
    80002b5a:	00005497          	auipc	s1,0x5
    80002b5e:	e064a483          	lw	s1,-506(s1) # 80007960 <ticks>
  release(&tickslock);
    80002b62:	00025517          	auipc	a0,0x25
    80002b66:	c4e50513          	add	a0,a0,-946 # 800277b0 <tickslock>
    80002b6a:	8cefe0ef          	jal	80000c38 <release>
  return xticks;
}
    80002b6e:	02049513          	sll	a0,s1,0x20
    80002b72:	9101                	srl	a0,a0,0x20
    80002b74:	60e2                	ld	ra,24(sp)
    80002b76:	6442                	ld	s0,16(sp)
    80002b78:	64a2                	ld	s1,8(sp)
    80002b7a:	6105                	add	sp,sp,32
    80002b7c:	8082                	ret

0000000080002b7e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002b7e:	7179                	add	sp,sp,-48
    80002b80:	f406                	sd	ra,40(sp)
    80002b82:	f022                	sd	s0,32(sp)
    80002b84:	ec26                	sd	s1,24(sp)
    80002b86:	e84a                	sd	s2,16(sp)
    80002b88:	e44e                	sd	s3,8(sp)
    80002b8a:	e052                	sd	s4,0(sp)
    80002b8c:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002b8e:	00005597          	auipc	a1,0x5
    80002b92:	9f258593          	add	a1,a1,-1550 # 80007580 <syscalls+0xf0>
    80002b96:	00025517          	auipc	a0,0x25
    80002b9a:	c3250513          	add	a0,a0,-974 # 800277c8 <bcache>
    80002b9e:	f83fd0ef          	jal	80000b20 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002ba2:	0002d797          	auipc	a5,0x2d
    80002ba6:	c2678793          	add	a5,a5,-986 # 8002f7c8 <bcache+0x8000>
    80002baa:	0002d717          	auipc	a4,0x2d
    80002bae:	e8670713          	add	a4,a4,-378 # 8002fa30 <bcache+0x8268>
    80002bb2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002bb6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002bba:	00025497          	auipc	s1,0x25
    80002bbe:	c2648493          	add	s1,s1,-986 # 800277e0 <bcache+0x18>
    b->next = bcache.head.next;
    80002bc2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002bc4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002bc6:	00005a17          	auipc	s4,0x5
    80002bca:	9c2a0a13          	add	s4,s4,-1598 # 80007588 <syscalls+0xf8>
    b->next = bcache.head.next;
    80002bce:	2b893783          	ld	a5,696(s2)
    80002bd2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002bd4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002bd8:	85d2                	mv	a1,s4
    80002bda:	01048513          	add	a0,s1,16
    80002bde:	1f6010ef          	jal	80003dd4 <initsleeplock>
    bcache.head.next->prev = b;
    80002be2:	2b893783          	ld	a5,696(s2)
    80002be6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002be8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002bec:	45848493          	add	s1,s1,1112
    80002bf0:	fd349fe3          	bne	s1,s3,80002bce <binit+0x50>
  }
}
    80002bf4:	70a2                	ld	ra,40(sp)
    80002bf6:	7402                	ld	s0,32(sp)
    80002bf8:	64e2                	ld	s1,24(sp)
    80002bfa:	6942                	ld	s2,16(sp)
    80002bfc:	69a2                	ld	s3,8(sp)
    80002bfe:	6a02                	ld	s4,0(sp)
    80002c00:	6145                	add	sp,sp,48
    80002c02:	8082                	ret

0000000080002c04 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002c04:	7179                	add	sp,sp,-48
    80002c06:	f406                	sd	ra,40(sp)
    80002c08:	f022                	sd	s0,32(sp)
    80002c0a:	ec26                	sd	s1,24(sp)
    80002c0c:	e84a                	sd	s2,16(sp)
    80002c0e:	e44e                	sd	s3,8(sp)
    80002c10:	1800                	add	s0,sp,48
    80002c12:	892a                	mv	s2,a0
    80002c14:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002c16:	00025517          	auipc	a0,0x25
    80002c1a:	bb250513          	add	a0,a0,-1102 # 800277c8 <bcache>
    80002c1e:	f83fd0ef          	jal	80000ba0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002c22:	0002d497          	auipc	s1,0x2d
    80002c26:	e5e4b483          	ld	s1,-418(s1) # 8002fa80 <bcache+0x82b8>
    80002c2a:	0002d797          	auipc	a5,0x2d
    80002c2e:	e0678793          	add	a5,a5,-506 # 8002fa30 <bcache+0x8268>
    80002c32:	02f48b63          	beq	s1,a5,80002c68 <bread+0x64>
    80002c36:	873e                	mv	a4,a5
    80002c38:	a021                	j	80002c40 <bread+0x3c>
    80002c3a:	68a4                	ld	s1,80(s1)
    80002c3c:	02e48663          	beq	s1,a4,80002c68 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002c40:	449c                	lw	a5,8(s1)
    80002c42:	ff279ce3          	bne	a5,s2,80002c3a <bread+0x36>
    80002c46:	44dc                	lw	a5,12(s1)
    80002c48:	ff3799e3          	bne	a5,s3,80002c3a <bread+0x36>
      b->refcnt++;
    80002c4c:	40bc                	lw	a5,64(s1)
    80002c4e:	2785                	addw	a5,a5,1
    80002c50:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c52:	00025517          	auipc	a0,0x25
    80002c56:	b7650513          	add	a0,a0,-1162 # 800277c8 <bcache>
    80002c5a:	fdffd0ef          	jal	80000c38 <release>
      acquiresleep(&b->lock);
    80002c5e:	01048513          	add	a0,s1,16
    80002c62:	1a8010ef          	jal	80003e0a <acquiresleep>
      return b;
    80002c66:	a889                	j	80002cb8 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c68:	0002d497          	auipc	s1,0x2d
    80002c6c:	e104b483          	ld	s1,-496(s1) # 8002fa78 <bcache+0x82b0>
    80002c70:	0002d797          	auipc	a5,0x2d
    80002c74:	dc078793          	add	a5,a5,-576 # 8002fa30 <bcache+0x8268>
    80002c78:	00f48863          	beq	s1,a5,80002c88 <bread+0x84>
    80002c7c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002c7e:	40bc                	lw	a5,64(s1)
    80002c80:	cb91                	beqz	a5,80002c94 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c82:	64a4                	ld	s1,72(s1)
    80002c84:	fee49de3          	bne	s1,a4,80002c7e <bread+0x7a>
  panic("bget: no buffers");
    80002c88:	00005517          	auipc	a0,0x5
    80002c8c:	90850513          	add	a0,a0,-1784 # 80007590 <syscalls+0x100>
    80002c90:	acffd0ef          	jal	8000075e <panic>
      b->dev = dev;
    80002c94:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002c98:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002c9c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002ca0:	4785                	li	a5,1
    80002ca2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ca4:	00025517          	auipc	a0,0x25
    80002ca8:	b2450513          	add	a0,a0,-1244 # 800277c8 <bcache>
    80002cac:	f8dfd0ef          	jal	80000c38 <release>
      acquiresleep(&b->lock);
    80002cb0:	01048513          	add	a0,s1,16
    80002cb4:	156010ef          	jal	80003e0a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002cb8:	409c                	lw	a5,0(s1)
    80002cba:	cb89                	beqz	a5,80002ccc <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002cbc:	8526                	mv	a0,s1
    80002cbe:	70a2                	ld	ra,40(sp)
    80002cc0:	7402                	ld	s0,32(sp)
    80002cc2:	64e2                	ld	s1,24(sp)
    80002cc4:	6942                	ld	s2,16(sp)
    80002cc6:	69a2                	ld	s3,8(sp)
    80002cc8:	6145                	add	sp,sp,48
    80002cca:	8082                	ret
    virtio_disk_rw(b, 0);
    80002ccc:	4581                	li	a1,0
    80002cce:	8526                	mv	a0,s1
    80002cd0:	07b020ef          	jal	8000554a <virtio_disk_rw>
    b->valid = 1;
    80002cd4:	4785                	li	a5,1
    80002cd6:	c09c                	sw	a5,0(s1)
  return b;
    80002cd8:	b7d5                	j	80002cbc <bread+0xb8>

0000000080002cda <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002cda:	1101                	add	sp,sp,-32
    80002cdc:	ec06                	sd	ra,24(sp)
    80002cde:	e822                	sd	s0,16(sp)
    80002ce0:	e426                	sd	s1,8(sp)
    80002ce2:	1000                	add	s0,sp,32
    80002ce4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ce6:	0541                	add	a0,a0,16
    80002ce8:	1a0010ef          	jal	80003e88 <holdingsleep>
    80002cec:	c911                	beqz	a0,80002d00 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002cee:	4585                	li	a1,1
    80002cf0:	8526                	mv	a0,s1
    80002cf2:	059020ef          	jal	8000554a <virtio_disk_rw>
}
    80002cf6:	60e2                	ld	ra,24(sp)
    80002cf8:	6442                	ld	s0,16(sp)
    80002cfa:	64a2                	ld	s1,8(sp)
    80002cfc:	6105                	add	sp,sp,32
    80002cfe:	8082                	ret
    panic("bwrite");
    80002d00:	00005517          	auipc	a0,0x5
    80002d04:	8a850513          	add	a0,a0,-1880 # 800075a8 <syscalls+0x118>
    80002d08:	a57fd0ef          	jal	8000075e <panic>

0000000080002d0c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002d0c:	1101                	add	sp,sp,-32
    80002d0e:	ec06                	sd	ra,24(sp)
    80002d10:	e822                	sd	s0,16(sp)
    80002d12:	e426                	sd	s1,8(sp)
    80002d14:	e04a                	sd	s2,0(sp)
    80002d16:	1000                	add	s0,sp,32
    80002d18:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d1a:	01050913          	add	s2,a0,16
    80002d1e:	854a                	mv	a0,s2
    80002d20:	168010ef          	jal	80003e88 <holdingsleep>
    80002d24:	c135                	beqz	a0,80002d88 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002d26:	854a                	mv	a0,s2
    80002d28:	128010ef          	jal	80003e50 <releasesleep>

  acquire(&bcache.lock);
    80002d2c:	00025517          	auipc	a0,0x25
    80002d30:	a9c50513          	add	a0,a0,-1380 # 800277c8 <bcache>
    80002d34:	e6dfd0ef          	jal	80000ba0 <acquire>
  b->refcnt--;
    80002d38:	40bc                	lw	a5,64(s1)
    80002d3a:	37fd                	addw	a5,a5,-1
    80002d3c:	0007871b          	sext.w	a4,a5
    80002d40:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002d42:	e71d                	bnez	a4,80002d70 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002d44:	68b8                	ld	a4,80(s1)
    80002d46:	64bc                	ld	a5,72(s1)
    80002d48:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002d4a:	68b8                	ld	a4,80(s1)
    80002d4c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002d4e:	0002d797          	auipc	a5,0x2d
    80002d52:	a7a78793          	add	a5,a5,-1414 # 8002f7c8 <bcache+0x8000>
    80002d56:	2b87b703          	ld	a4,696(a5)
    80002d5a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002d5c:	0002d717          	auipc	a4,0x2d
    80002d60:	cd470713          	add	a4,a4,-812 # 8002fa30 <bcache+0x8268>
    80002d64:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002d66:	2b87b703          	ld	a4,696(a5)
    80002d6a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002d6c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002d70:	00025517          	auipc	a0,0x25
    80002d74:	a5850513          	add	a0,a0,-1448 # 800277c8 <bcache>
    80002d78:	ec1fd0ef          	jal	80000c38 <release>
}
    80002d7c:	60e2                	ld	ra,24(sp)
    80002d7e:	6442                	ld	s0,16(sp)
    80002d80:	64a2                	ld	s1,8(sp)
    80002d82:	6902                	ld	s2,0(sp)
    80002d84:	6105                	add	sp,sp,32
    80002d86:	8082                	ret
    panic("brelse");
    80002d88:	00005517          	auipc	a0,0x5
    80002d8c:	82850513          	add	a0,a0,-2008 # 800075b0 <syscalls+0x120>
    80002d90:	9cffd0ef          	jal	8000075e <panic>

0000000080002d94 <bpin>:

void
bpin(struct buf *b) {
    80002d94:	1101                	add	sp,sp,-32
    80002d96:	ec06                	sd	ra,24(sp)
    80002d98:	e822                	sd	s0,16(sp)
    80002d9a:	e426                	sd	s1,8(sp)
    80002d9c:	1000                	add	s0,sp,32
    80002d9e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002da0:	00025517          	auipc	a0,0x25
    80002da4:	a2850513          	add	a0,a0,-1496 # 800277c8 <bcache>
    80002da8:	df9fd0ef          	jal	80000ba0 <acquire>
  b->refcnt++;
    80002dac:	40bc                	lw	a5,64(s1)
    80002dae:	2785                	addw	a5,a5,1
    80002db0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002db2:	00025517          	auipc	a0,0x25
    80002db6:	a1650513          	add	a0,a0,-1514 # 800277c8 <bcache>
    80002dba:	e7ffd0ef          	jal	80000c38 <release>
}
    80002dbe:	60e2                	ld	ra,24(sp)
    80002dc0:	6442                	ld	s0,16(sp)
    80002dc2:	64a2                	ld	s1,8(sp)
    80002dc4:	6105                	add	sp,sp,32
    80002dc6:	8082                	ret

0000000080002dc8 <bunpin>:

void
bunpin(struct buf *b) {
    80002dc8:	1101                	add	sp,sp,-32
    80002dca:	ec06                	sd	ra,24(sp)
    80002dcc:	e822                	sd	s0,16(sp)
    80002dce:	e426                	sd	s1,8(sp)
    80002dd0:	1000                	add	s0,sp,32
    80002dd2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002dd4:	00025517          	auipc	a0,0x25
    80002dd8:	9f450513          	add	a0,a0,-1548 # 800277c8 <bcache>
    80002ddc:	dc5fd0ef          	jal	80000ba0 <acquire>
  b->refcnt--;
    80002de0:	40bc                	lw	a5,64(s1)
    80002de2:	37fd                	addw	a5,a5,-1
    80002de4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002de6:	00025517          	auipc	a0,0x25
    80002dea:	9e250513          	add	a0,a0,-1566 # 800277c8 <bcache>
    80002dee:	e4bfd0ef          	jal	80000c38 <release>
}
    80002df2:	60e2                	ld	ra,24(sp)
    80002df4:	6442                	ld	s0,16(sp)
    80002df6:	64a2                	ld	s1,8(sp)
    80002df8:	6105                	add	sp,sp,32
    80002dfa:	8082                	ret

0000000080002dfc <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002dfc:	1101                	add	sp,sp,-32
    80002dfe:	ec06                	sd	ra,24(sp)
    80002e00:	e822                	sd	s0,16(sp)
    80002e02:	e426                	sd	s1,8(sp)
    80002e04:	e04a                	sd	s2,0(sp)
    80002e06:	1000                	add	s0,sp,32
    80002e08:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002e0a:	00d5d59b          	srlw	a1,a1,0xd
    80002e0e:	0002d797          	auipc	a5,0x2d
    80002e12:	0967a783          	lw	a5,150(a5) # 8002fea4 <sb+0x1c>
    80002e16:	9dbd                	addw	a1,a1,a5
    80002e18:	dedff0ef          	jal	80002c04 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002e1c:	0074f713          	and	a4,s1,7
    80002e20:	4785                	li	a5,1
    80002e22:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002e26:	14ce                	sll	s1,s1,0x33
    80002e28:	90d9                	srl	s1,s1,0x36
    80002e2a:	00950733          	add	a4,a0,s1
    80002e2e:	05874703          	lbu	a4,88(a4)
    80002e32:	00e7f6b3          	and	a3,a5,a4
    80002e36:	c29d                	beqz	a3,80002e5c <bfree+0x60>
    80002e38:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002e3a:	94aa                	add	s1,s1,a0
    80002e3c:	fff7c793          	not	a5,a5
    80002e40:	8f7d                	and	a4,a4,a5
    80002e42:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002e46:	6bf000ef          	jal	80003d04 <log_write>
  brelse(bp);
    80002e4a:	854a                	mv	a0,s2
    80002e4c:	ec1ff0ef          	jal	80002d0c <brelse>
}
    80002e50:	60e2                	ld	ra,24(sp)
    80002e52:	6442                	ld	s0,16(sp)
    80002e54:	64a2                	ld	s1,8(sp)
    80002e56:	6902                	ld	s2,0(sp)
    80002e58:	6105                	add	sp,sp,32
    80002e5a:	8082                	ret
    panic("freeing free block");
    80002e5c:	00004517          	auipc	a0,0x4
    80002e60:	75c50513          	add	a0,a0,1884 # 800075b8 <syscalls+0x128>
    80002e64:	8fbfd0ef          	jal	8000075e <panic>

0000000080002e68 <balloc>:
{
    80002e68:	711d                	add	sp,sp,-96
    80002e6a:	ec86                	sd	ra,88(sp)
    80002e6c:	e8a2                	sd	s0,80(sp)
    80002e6e:	e4a6                	sd	s1,72(sp)
    80002e70:	e0ca                	sd	s2,64(sp)
    80002e72:	fc4e                	sd	s3,56(sp)
    80002e74:	f852                	sd	s4,48(sp)
    80002e76:	f456                	sd	s5,40(sp)
    80002e78:	f05a                	sd	s6,32(sp)
    80002e7a:	ec5e                	sd	s7,24(sp)
    80002e7c:	e862                	sd	s8,16(sp)
    80002e7e:	e466                	sd	s9,8(sp)
    80002e80:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002e82:	0002d797          	auipc	a5,0x2d
    80002e86:	00a7a783          	lw	a5,10(a5) # 8002fe8c <sb+0x4>
    80002e8a:	cff1                	beqz	a5,80002f66 <balloc+0xfe>
    80002e8c:	8baa                	mv	s7,a0
    80002e8e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002e90:	0002db17          	auipc	s6,0x2d
    80002e94:	ff8b0b13          	add	s6,s6,-8 # 8002fe88 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e98:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002e9a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e9c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002e9e:	6c89                	lui	s9,0x2
    80002ea0:	a0b5                	j	80002f0c <balloc+0xa4>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002ea2:	97ca                	add	a5,a5,s2
    80002ea4:	8e55                	or	a2,a2,a3
    80002ea6:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002eaa:	854a                	mv	a0,s2
    80002eac:	659000ef          	jal	80003d04 <log_write>
        brelse(bp);
    80002eb0:	854a                	mv	a0,s2
    80002eb2:	e5bff0ef          	jal	80002d0c <brelse>
  bp = bread(dev, bno);
    80002eb6:	85a6                	mv	a1,s1
    80002eb8:	855e                	mv	a0,s7
    80002eba:	d4bff0ef          	jal	80002c04 <bread>
    80002ebe:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002ec0:	40000613          	li	a2,1024
    80002ec4:	4581                	li	a1,0
    80002ec6:	05850513          	add	a0,a0,88
    80002eca:	dabfd0ef          	jal	80000c74 <memset>
  log_write(bp);
    80002ece:	854a                	mv	a0,s2
    80002ed0:	635000ef          	jal	80003d04 <log_write>
  brelse(bp);
    80002ed4:	854a                	mv	a0,s2
    80002ed6:	e37ff0ef          	jal	80002d0c <brelse>
}
    80002eda:	8526                	mv	a0,s1
    80002edc:	60e6                	ld	ra,88(sp)
    80002ede:	6446                	ld	s0,80(sp)
    80002ee0:	64a6                	ld	s1,72(sp)
    80002ee2:	6906                	ld	s2,64(sp)
    80002ee4:	79e2                	ld	s3,56(sp)
    80002ee6:	7a42                	ld	s4,48(sp)
    80002ee8:	7aa2                	ld	s5,40(sp)
    80002eea:	7b02                	ld	s6,32(sp)
    80002eec:	6be2                	ld	s7,24(sp)
    80002eee:	6c42                	ld	s8,16(sp)
    80002ef0:	6ca2                	ld	s9,8(sp)
    80002ef2:	6125                	add	sp,sp,96
    80002ef4:	8082                	ret
    brelse(bp);
    80002ef6:	854a                	mv	a0,s2
    80002ef8:	e15ff0ef          	jal	80002d0c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002efc:	015c87bb          	addw	a5,s9,s5
    80002f00:	00078a9b          	sext.w	s5,a5
    80002f04:	004b2703          	lw	a4,4(s6)
    80002f08:	04eaff63          	bgeu	s5,a4,80002f66 <balloc+0xfe>
    bp = bread(dev, BBLOCK(b, sb));
    80002f0c:	41fad79b          	sraw	a5,s5,0x1f
    80002f10:	0137d79b          	srlw	a5,a5,0x13
    80002f14:	015787bb          	addw	a5,a5,s5
    80002f18:	40d7d79b          	sraw	a5,a5,0xd
    80002f1c:	01cb2583          	lw	a1,28(s6)
    80002f20:	9dbd                	addw	a1,a1,a5
    80002f22:	855e                	mv	a0,s7
    80002f24:	ce1ff0ef          	jal	80002c04 <bread>
    80002f28:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f2a:	004b2503          	lw	a0,4(s6)
    80002f2e:	000a849b          	sext.w	s1,s5
    80002f32:	8762                	mv	a4,s8
    80002f34:	fca4f1e3          	bgeu	s1,a0,80002ef6 <balloc+0x8e>
      m = 1 << (bi % 8);
    80002f38:	00777693          	and	a3,a4,7
    80002f3c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002f40:	41f7579b          	sraw	a5,a4,0x1f
    80002f44:	01d7d79b          	srlw	a5,a5,0x1d
    80002f48:	9fb9                	addw	a5,a5,a4
    80002f4a:	4037d79b          	sraw	a5,a5,0x3
    80002f4e:	00f90633          	add	a2,s2,a5
    80002f52:	05864603          	lbu	a2,88(a2)
    80002f56:	00c6f5b3          	and	a1,a3,a2
    80002f5a:	d5a1                	beqz	a1,80002ea2 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f5c:	2705                	addw	a4,a4,1
    80002f5e:	2485                	addw	s1,s1,1
    80002f60:	fd471ae3          	bne	a4,s4,80002f34 <balloc+0xcc>
    80002f64:	bf49                	j	80002ef6 <balloc+0x8e>
  printf("balloc: out of blocks\n");
    80002f66:	00004517          	auipc	a0,0x4
    80002f6a:	66a50513          	add	a0,a0,1642 # 800075d0 <syscalls+0x140>
    80002f6e:	d30fd0ef          	jal	8000049e <printf>
  return 0;
    80002f72:	4481                	li	s1,0
    80002f74:	b79d                	j	80002eda <balloc+0x72>

0000000080002f76 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002f76:	7179                	add	sp,sp,-48
    80002f78:	f406                	sd	ra,40(sp)
    80002f7a:	f022                	sd	s0,32(sp)
    80002f7c:	ec26                	sd	s1,24(sp)
    80002f7e:	e84a                	sd	s2,16(sp)
    80002f80:	e44e                	sd	s3,8(sp)
    80002f82:	e052                	sd	s4,0(sp)
    80002f84:	1800                	add	s0,sp,48
    80002f86:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002f88:	47ad                	li	a5,11
    80002f8a:	02b7e663          	bltu	a5,a1,80002fb6 <bmap+0x40>
    if((addr = ip->addrs[bn]) == 0){
    80002f8e:	02059793          	sll	a5,a1,0x20
    80002f92:	01e7d593          	srl	a1,a5,0x1e
    80002f96:	00b504b3          	add	s1,a0,a1
    80002f9a:	0504a903          	lw	s2,80(s1)
    80002f9e:	06091663          	bnez	s2,8000300a <bmap+0x94>
      addr = balloc(ip->dev);
    80002fa2:	4108                	lw	a0,0(a0)
    80002fa4:	ec5ff0ef          	jal	80002e68 <balloc>
    80002fa8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002fac:	04090f63          	beqz	s2,8000300a <bmap+0x94>
        return 0;
      ip->addrs[bn] = addr;
    80002fb0:	0524a823          	sw	s2,80(s1)
    80002fb4:	a899                	j	8000300a <bmap+0x94>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002fb6:	ff45849b          	addw	s1,a1,-12
    80002fba:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002fbe:	0ff00793          	li	a5,255
    80002fc2:	06e7eb63          	bltu	a5,a4,80003038 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002fc6:	08052903          	lw	s2,128(a0)
    80002fca:	00091b63          	bnez	s2,80002fe0 <bmap+0x6a>
      addr = balloc(ip->dev);
    80002fce:	4108                	lw	a0,0(a0)
    80002fd0:	e99ff0ef          	jal	80002e68 <balloc>
    80002fd4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002fd8:	02090963          	beqz	s2,8000300a <bmap+0x94>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002fdc:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002fe0:	85ca                	mv	a1,s2
    80002fe2:	0009a503          	lw	a0,0(s3)
    80002fe6:	c1fff0ef          	jal	80002c04 <bread>
    80002fea:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002fec:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80002ff0:	02049713          	sll	a4,s1,0x20
    80002ff4:	01e75593          	srl	a1,a4,0x1e
    80002ff8:	00b784b3          	add	s1,a5,a1
    80002ffc:	0004a903          	lw	s2,0(s1)
    80003000:	00090e63          	beqz	s2,8000301c <bmap+0xa6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003004:	8552                	mv	a0,s4
    80003006:	d07ff0ef          	jal	80002d0c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000300a:	854a                	mv	a0,s2
    8000300c:	70a2                	ld	ra,40(sp)
    8000300e:	7402                	ld	s0,32(sp)
    80003010:	64e2                	ld	s1,24(sp)
    80003012:	6942                	ld	s2,16(sp)
    80003014:	69a2                	ld	s3,8(sp)
    80003016:	6a02                	ld	s4,0(sp)
    80003018:	6145                	add	sp,sp,48
    8000301a:	8082                	ret
      addr = balloc(ip->dev);
    8000301c:	0009a503          	lw	a0,0(s3)
    80003020:	e49ff0ef          	jal	80002e68 <balloc>
    80003024:	0005091b          	sext.w	s2,a0
      if(addr){
    80003028:	fc090ee3          	beqz	s2,80003004 <bmap+0x8e>
        a[bn] = addr;
    8000302c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003030:	8552                	mv	a0,s4
    80003032:	4d3000ef          	jal	80003d04 <log_write>
    80003036:	b7f9                	j	80003004 <bmap+0x8e>
  panic("bmap: out of range");
    80003038:	00004517          	auipc	a0,0x4
    8000303c:	5b050513          	add	a0,a0,1456 # 800075e8 <syscalls+0x158>
    80003040:	f1efd0ef          	jal	8000075e <panic>

0000000080003044 <iget>:
{
    80003044:	7179                	add	sp,sp,-48
    80003046:	f406                	sd	ra,40(sp)
    80003048:	f022                	sd	s0,32(sp)
    8000304a:	ec26                	sd	s1,24(sp)
    8000304c:	e84a                	sd	s2,16(sp)
    8000304e:	e44e                	sd	s3,8(sp)
    80003050:	e052                	sd	s4,0(sp)
    80003052:	1800                	add	s0,sp,48
    80003054:	89aa                	mv	s3,a0
    80003056:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003058:	0002d517          	auipc	a0,0x2d
    8000305c:	e5050513          	add	a0,a0,-432 # 8002fea8 <itable>
    80003060:	b41fd0ef          	jal	80000ba0 <acquire>
  empty = 0;
    80003064:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003066:	0002d497          	auipc	s1,0x2d
    8000306a:	e5a48493          	add	s1,s1,-422 # 8002fec0 <itable+0x18>
    8000306e:	0002f697          	auipc	a3,0x2f
    80003072:	8e268693          	add	a3,a3,-1822 # 80031950 <log>
    80003076:	a039                	j	80003084 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003078:	02090963          	beqz	s2,800030aa <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000307c:	08848493          	add	s1,s1,136
    80003080:	02d48863          	beq	s1,a3,800030b0 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003084:	449c                	lw	a5,8(s1)
    80003086:	fef059e3          	blez	a5,80003078 <iget+0x34>
    8000308a:	4098                	lw	a4,0(s1)
    8000308c:	ff3716e3          	bne	a4,s3,80003078 <iget+0x34>
    80003090:	40d8                	lw	a4,4(s1)
    80003092:	ff4713e3          	bne	a4,s4,80003078 <iget+0x34>
      ip->ref++;
    80003096:	2785                	addw	a5,a5,1
    80003098:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000309a:	0002d517          	auipc	a0,0x2d
    8000309e:	e0e50513          	add	a0,a0,-498 # 8002fea8 <itable>
    800030a2:	b97fd0ef          	jal	80000c38 <release>
      return ip;
    800030a6:	8926                	mv	s2,s1
    800030a8:	a02d                	j	800030d2 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800030aa:	fbe9                	bnez	a5,8000307c <iget+0x38>
    800030ac:	8926                	mv	s2,s1
    800030ae:	b7f9                	j	8000307c <iget+0x38>
  if(empty == 0)
    800030b0:	02090a63          	beqz	s2,800030e4 <iget+0xa0>
  ip->dev = dev;
    800030b4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800030b8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800030bc:	4785                	li	a5,1
    800030be:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800030c2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800030c6:	0002d517          	auipc	a0,0x2d
    800030ca:	de250513          	add	a0,a0,-542 # 8002fea8 <itable>
    800030ce:	b6bfd0ef          	jal	80000c38 <release>
}
    800030d2:	854a                	mv	a0,s2
    800030d4:	70a2                	ld	ra,40(sp)
    800030d6:	7402                	ld	s0,32(sp)
    800030d8:	64e2                	ld	s1,24(sp)
    800030da:	6942                	ld	s2,16(sp)
    800030dc:	69a2                	ld	s3,8(sp)
    800030de:	6a02                	ld	s4,0(sp)
    800030e0:	6145                	add	sp,sp,48
    800030e2:	8082                	ret
    panic("iget: no inodes");
    800030e4:	00004517          	auipc	a0,0x4
    800030e8:	51c50513          	add	a0,a0,1308 # 80007600 <syscalls+0x170>
    800030ec:	e72fd0ef          	jal	8000075e <panic>

00000000800030f0 <fsinit>:
fsinit(int dev) {
    800030f0:	7179                	add	sp,sp,-48
    800030f2:	f406                	sd	ra,40(sp)
    800030f4:	f022                	sd	s0,32(sp)
    800030f6:	ec26                	sd	s1,24(sp)
    800030f8:	e84a                	sd	s2,16(sp)
    800030fa:	e44e                	sd	s3,8(sp)
    800030fc:	1800                	add	s0,sp,48
    800030fe:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003100:	4585                	li	a1,1
    80003102:	b03ff0ef          	jal	80002c04 <bread>
    80003106:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003108:	0002d997          	auipc	s3,0x2d
    8000310c:	d8098993          	add	s3,s3,-640 # 8002fe88 <sb>
    80003110:	02000613          	li	a2,32
    80003114:	05850593          	add	a1,a0,88
    80003118:	854e                	mv	a0,s3
    8000311a:	bb7fd0ef          	jal	80000cd0 <memmove>
  brelse(bp);
    8000311e:	8526                	mv	a0,s1
    80003120:	bedff0ef          	jal	80002d0c <brelse>
  if(sb.magic != FSMAGIC)
    80003124:	0009a703          	lw	a4,0(s3)
    80003128:	102037b7          	lui	a5,0x10203
    8000312c:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003130:	02f71063          	bne	a4,a5,80003150 <fsinit+0x60>
  initlog(dev, &sb);
    80003134:	0002d597          	auipc	a1,0x2d
    80003138:	d5458593          	add	a1,a1,-684 # 8002fe88 <sb>
    8000313c:	854a                	mv	a0,s2
    8000313e:	1c5000ef          	jal	80003b02 <initlog>
}
    80003142:	70a2                	ld	ra,40(sp)
    80003144:	7402                	ld	s0,32(sp)
    80003146:	64e2                	ld	s1,24(sp)
    80003148:	6942                	ld	s2,16(sp)
    8000314a:	69a2                	ld	s3,8(sp)
    8000314c:	6145                	add	sp,sp,48
    8000314e:	8082                	ret
    panic("invalid file system");
    80003150:	00004517          	auipc	a0,0x4
    80003154:	4c050513          	add	a0,a0,1216 # 80007610 <syscalls+0x180>
    80003158:	e06fd0ef          	jal	8000075e <panic>

000000008000315c <iinit>:
{
    8000315c:	7179                	add	sp,sp,-48
    8000315e:	f406                	sd	ra,40(sp)
    80003160:	f022                	sd	s0,32(sp)
    80003162:	ec26                	sd	s1,24(sp)
    80003164:	e84a                	sd	s2,16(sp)
    80003166:	e44e                	sd	s3,8(sp)
    80003168:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    8000316a:	00004597          	auipc	a1,0x4
    8000316e:	4be58593          	add	a1,a1,1214 # 80007628 <syscalls+0x198>
    80003172:	0002d517          	auipc	a0,0x2d
    80003176:	d3650513          	add	a0,a0,-714 # 8002fea8 <itable>
    8000317a:	9a7fd0ef          	jal	80000b20 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000317e:	0002d497          	auipc	s1,0x2d
    80003182:	d5248493          	add	s1,s1,-686 # 8002fed0 <itable+0x28>
    80003186:	0002e997          	auipc	s3,0x2e
    8000318a:	7da98993          	add	s3,s3,2010 # 80031960 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000318e:	00004917          	auipc	s2,0x4
    80003192:	4a290913          	add	s2,s2,1186 # 80007630 <syscalls+0x1a0>
    80003196:	85ca                	mv	a1,s2
    80003198:	8526                	mv	a0,s1
    8000319a:	43b000ef          	jal	80003dd4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000319e:	08848493          	add	s1,s1,136
    800031a2:	ff349ae3          	bne	s1,s3,80003196 <iinit+0x3a>
}
    800031a6:	70a2                	ld	ra,40(sp)
    800031a8:	7402                	ld	s0,32(sp)
    800031aa:	64e2                	ld	s1,24(sp)
    800031ac:	6942                	ld	s2,16(sp)
    800031ae:	69a2                	ld	s3,8(sp)
    800031b0:	6145                	add	sp,sp,48
    800031b2:	8082                	ret

00000000800031b4 <ialloc>:
{
    800031b4:	7139                	add	sp,sp,-64
    800031b6:	fc06                	sd	ra,56(sp)
    800031b8:	f822                	sd	s0,48(sp)
    800031ba:	f426                	sd	s1,40(sp)
    800031bc:	f04a                	sd	s2,32(sp)
    800031be:	ec4e                	sd	s3,24(sp)
    800031c0:	e852                	sd	s4,16(sp)
    800031c2:	e456                	sd	s5,8(sp)
    800031c4:	e05a                	sd	s6,0(sp)
    800031c6:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800031c8:	0002d717          	auipc	a4,0x2d
    800031cc:	ccc72703          	lw	a4,-820(a4) # 8002fe94 <sb+0xc>
    800031d0:	4785                	li	a5,1
    800031d2:	04e7f463          	bgeu	a5,a4,8000321a <ialloc+0x66>
    800031d6:	8aaa                	mv	s5,a0
    800031d8:	8b2e                	mv	s6,a1
    800031da:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800031dc:	0002da17          	auipc	s4,0x2d
    800031e0:	caca0a13          	add	s4,s4,-852 # 8002fe88 <sb>
    800031e4:	00495593          	srl	a1,s2,0x4
    800031e8:	018a2783          	lw	a5,24(s4)
    800031ec:	9dbd                	addw	a1,a1,a5
    800031ee:	8556                	mv	a0,s5
    800031f0:	a15ff0ef          	jal	80002c04 <bread>
    800031f4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800031f6:	05850993          	add	s3,a0,88
    800031fa:	00f97793          	and	a5,s2,15
    800031fe:	079a                	sll	a5,a5,0x6
    80003200:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003202:	00099783          	lh	a5,0(s3)
    80003206:	cb9d                	beqz	a5,8000323c <ialloc+0x88>
    brelse(bp);
    80003208:	b05ff0ef          	jal	80002d0c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000320c:	0905                	add	s2,s2,1
    8000320e:	00ca2703          	lw	a4,12(s4)
    80003212:	0009079b          	sext.w	a5,s2
    80003216:	fce7e7e3          	bltu	a5,a4,800031e4 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    8000321a:	00004517          	auipc	a0,0x4
    8000321e:	41e50513          	add	a0,a0,1054 # 80007638 <syscalls+0x1a8>
    80003222:	a7cfd0ef          	jal	8000049e <printf>
  return 0;
    80003226:	4501                	li	a0,0
}
    80003228:	70e2                	ld	ra,56(sp)
    8000322a:	7442                	ld	s0,48(sp)
    8000322c:	74a2                	ld	s1,40(sp)
    8000322e:	7902                	ld	s2,32(sp)
    80003230:	69e2                	ld	s3,24(sp)
    80003232:	6a42                	ld	s4,16(sp)
    80003234:	6aa2                	ld	s5,8(sp)
    80003236:	6b02                	ld	s6,0(sp)
    80003238:	6121                	add	sp,sp,64
    8000323a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000323c:	04000613          	li	a2,64
    80003240:	4581                	li	a1,0
    80003242:	854e                	mv	a0,s3
    80003244:	a31fd0ef          	jal	80000c74 <memset>
      dip->type = type;
    80003248:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000324c:	8526                	mv	a0,s1
    8000324e:	2b7000ef          	jal	80003d04 <log_write>
      brelse(bp);
    80003252:	8526                	mv	a0,s1
    80003254:	ab9ff0ef          	jal	80002d0c <brelse>
      return iget(dev, inum);
    80003258:	0009059b          	sext.w	a1,s2
    8000325c:	8556                	mv	a0,s5
    8000325e:	de7ff0ef          	jal	80003044 <iget>
    80003262:	b7d9                	j	80003228 <ialloc+0x74>

0000000080003264 <iupdate>:
{
    80003264:	1101                	add	sp,sp,-32
    80003266:	ec06                	sd	ra,24(sp)
    80003268:	e822                	sd	s0,16(sp)
    8000326a:	e426                	sd	s1,8(sp)
    8000326c:	e04a                	sd	s2,0(sp)
    8000326e:	1000                	add	s0,sp,32
    80003270:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003272:	415c                	lw	a5,4(a0)
    80003274:	0047d79b          	srlw	a5,a5,0x4
    80003278:	0002d597          	auipc	a1,0x2d
    8000327c:	c285a583          	lw	a1,-984(a1) # 8002fea0 <sb+0x18>
    80003280:	9dbd                	addw	a1,a1,a5
    80003282:	4108                	lw	a0,0(a0)
    80003284:	981ff0ef          	jal	80002c04 <bread>
    80003288:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000328a:	05850793          	add	a5,a0,88
    8000328e:	40d8                	lw	a4,4(s1)
    80003290:	8b3d                	and	a4,a4,15
    80003292:	071a                	sll	a4,a4,0x6
    80003294:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003296:	04449703          	lh	a4,68(s1)
    8000329a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000329e:	04649703          	lh	a4,70(s1)
    800032a2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800032a6:	04849703          	lh	a4,72(s1)
    800032aa:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800032ae:	04a49703          	lh	a4,74(s1)
    800032b2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800032b6:	44f8                	lw	a4,76(s1)
    800032b8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800032ba:	03400613          	li	a2,52
    800032be:	05048593          	add	a1,s1,80
    800032c2:	00c78513          	add	a0,a5,12
    800032c6:	a0bfd0ef          	jal	80000cd0 <memmove>
  log_write(bp);
    800032ca:	854a                	mv	a0,s2
    800032cc:	239000ef          	jal	80003d04 <log_write>
  brelse(bp);
    800032d0:	854a                	mv	a0,s2
    800032d2:	a3bff0ef          	jal	80002d0c <brelse>
}
    800032d6:	60e2                	ld	ra,24(sp)
    800032d8:	6442                	ld	s0,16(sp)
    800032da:	64a2                	ld	s1,8(sp)
    800032dc:	6902                	ld	s2,0(sp)
    800032de:	6105                	add	sp,sp,32
    800032e0:	8082                	ret

00000000800032e2 <idup>:
{
    800032e2:	1101                	add	sp,sp,-32
    800032e4:	ec06                	sd	ra,24(sp)
    800032e6:	e822                	sd	s0,16(sp)
    800032e8:	e426                	sd	s1,8(sp)
    800032ea:	1000                	add	s0,sp,32
    800032ec:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800032ee:	0002d517          	auipc	a0,0x2d
    800032f2:	bba50513          	add	a0,a0,-1094 # 8002fea8 <itable>
    800032f6:	8abfd0ef          	jal	80000ba0 <acquire>
  ip->ref++;
    800032fa:	449c                	lw	a5,8(s1)
    800032fc:	2785                	addw	a5,a5,1
    800032fe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003300:	0002d517          	auipc	a0,0x2d
    80003304:	ba850513          	add	a0,a0,-1112 # 8002fea8 <itable>
    80003308:	931fd0ef          	jal	80000c38 <release>
}
    8000330c:	8526                	mv	a0,s1
    8000330e:	60e2                	ld	ra,24(sp)
    80003310:	6442                	ld	s0,16(sp)
    80003312:	64a2                	ld	s1,8(sp)
    80003314:	6105                	add	sp,sp,32
    80003316:	8082                	ret

0000000080003318 <ilock>:
{
    80003318:	1101                	add	sp,sp,-32
    8000331a:	ec06                	sd	ra,24(sp)
    8000331c:	e822                	sd	s0,16(sp)
    8000331e:	e426                	sd	s1,8(sp)
    80003320:	e04a                	sd	s2,0(sp)
    80003322:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003324:	c105                	beqz	a0,80003344 <ilock+0x2c>
    80003326:	84aa                	mv	s1,a0
    80003328:	451c                	lw	a5,8(a0)
    8000332a:	00f05d63          	blez	a5,80003344 <ilock+0x2c>
  acquiresleep(&ip->lock);
    8000332e:	0541                	add	a0,a0,16
    80003330:	2db000ef          	jal	80003e0a <acquiresleep>
  if(ip->valid == 0){
    80003334:	40bc                	lw	a5,64(s1)
    80003336:	cf89                	beqz	a5,80003350 <ilock+0x38>
}
    80003338:	60e2                	ld	ra,24(sp)
    8000333a:	6442                	ld	s0,16(sp)
    8000333c:	64a2                	ld	s1,8(sp)
    8000333e:	6902                	ld	s2,0(sp)
    80003340:	6105                	add	sp,sp,32
    80003342:	8082                	ret
    panic("ilock");
    80003344:	00004517          	auipc	a0,0x4
    80003348:	30c50513          	add	a0,a0,780 # 80007650 <syscalls+0x1c0>
    8000334c:	c12fd0ef          	jal	8000075e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003350:	40dc                	lw	a5,4(s1)
    80003352:	0047d79b          	srlw	a5,a5,0x4
    80003356:	0002d597          	auipc	a1,0x2d
    8000335a:	b4a5a583          	lw	a1,-1206(a1) # 8002fea0 <sb+0x18>
    8000335e:	9dbd                	addw	a1,a1,a5
    80003360:	4088                	lw	a0,0(s1)
    80003362:	8a3ff0ef          	jal	80002c04 <bread>
    80003366:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003368:	05850593          	add	a1,a0,88
    8000336c:	40dc                	lw	a5,4(s1)
    8000336e:	8bbd                	and	a5,a5,15
    80003370:	079a                	sll	a5,a5,0x6
    80003372:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003374:	00059783          	lh	a5,0(a1)
    80003378:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000337c:	00259783          	lh	a5,2(a1)
    80003380:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003384:	00459783          	lh	a5,4(a1)
    80003388:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000338c:	00659783          	lh	a5,6(a1)
    80003390:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003394:	459c                	lw	a5,8(a1)
    80003396:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003398:	03400613          	li	a2,52
    8000339c:	05b1                	add	a1,a1,12
    8000339e:	05048513          	add	a0,s1,80
    800033a2:	92ffd0ef          	jal	80000cd0 <memmove>
    brelse(bp);
    800033a6:	854a                	mv	a0,s2
    800033a8:	965ff0ef          	jal	80002d0c <brelse>
    ip->valid = 1;
    800033ac:	4785                	li	a5,1
    800033ae:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800033b0:	04449783          	lh	a5,68(s1)
    800033b4:	f3d1                	bnez	a5,80003338 <ilock+0x20>
      panic("ilock: no type");
    800033b6:	00004517          	auipc	a0,0x4
    800033ba:	2a250513          	add	a0,a0,674 # 80007658 <syscalls+0x1c8>
    800033be:	ba0fd0ef          	jal	8000075e <panic>

00000000800033c2 <iunlock>:
{
    800033c2:	1101                	add	sp,sp,-32
    800033c4:	ec06                	sd	ra,24(sp)
    800033c6:	e822                	sd	s0,16(sp)
    800033c8:	e426                	sd	s1,8(sp)
    800033ca:	e04a                	sd	s2,0(sp)
    800033cc:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800033ce:	c505                	beqz	a0,800033f6 <iunlock+0x34>
    800033d0:	84aa                	mv	s1,a0
    800033d2:	01050913          	add	s2,a0,16
    800033d6:	854a                	mv	a0,s2
    800033d8:	2b1000ef          	jal	80003e88 <holdingsleep>
    800033dc:	cd09                	beqz	a0,800033f6 <iunlock+0x34>
    800033de:	449c                	lw	a5,8(s1)
    800033e0:	00f05b63          	blez	a5,800033f6 <iunlock+0x34>
  releasesleep(&ip->lock);
    800033e4:	854a                	mv	a0,s2
    800033e6:	26b000ef          	jal	80003e50 <releasesleep>
}
    800033ea:	60e2                	ld	ra,24(sp)
    800033ec:	6442                	ld	s0,16(sp)
    800033ee:	64a2                	ld	s1,8(sp)
    800033f0:	6902                	ld	s2,0(sp)
    800033f2:	6105                	add	sp,sp,32
    800033f4:	8082                	ret
    panic("iunlock");
    800033f6:	00004517          	auipc	a0,0x4
    800033fa:	27250513          	add	a0,a0,626 # 80007668 <syscalls+0x1d8>
    800033fe:	b60fd0ef          	jal	8000075e <panic>

0000000080003402 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003402:	7179                	add	sp,sp,-48
    80003404:	f406                	sd	ra,40(sp)
    80003406:	f022                	sd	s0,32(sp)
    80003408:	ec26                	sd	s1,24(sp)
    8000340a:	e84a                	sd	s2,16(sp)
    8000340c:	e44e                	sd	s3,8(sp)
    8000340e:	e052                	sd	s4,0(sp)
    80003410:	1800                	add	s0,sp,48
    80003412:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003414:	05050493          	add	s1,a0,80
    80003418:	08050913          	add	s2,a0,128
    8000341c:	a021                	j	80003424 <itrunc+0x22>
    8000341e:	0491                	add	s1,s1,4
    80003420:	01248b63          	beq	s1,s2,80003436 <itrunc+0x34>
    if(ip->addrs[i]){
    80003424:	408c                	lw	a1,0(s1)
    80003426:	dde5                	beqz	a1,8000341e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003428:	0009a503          	lw	a0,0(s3)
    8000342c:	9d1ff0ef          	jal	80002dfc <bfree>
      ip->addrs[i] = 0;
    80003430:	0004a023          	sw	zero,0(s1)
    80003434:	b7ed                	j	8000341e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003436:	0809a583          	lw	a1,128(s3)
    8000343a:	ed91                	bnez	a1,80003456 <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000343c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003440:	854e                	mv	a0,s3
    80003442:	e23ff0ef          	jal	80003264 <iupdate>
}
    80003446:	70a2                	ld	ra,40(sp)
    80003448:	7402                	ld	s0,32(sp)
    8000344a:	64e2                	ld	s1,24(sp)
    8000344c:	6942                	ld	s2,16(sp)
    8000344e:	69a2                	ld	s3,8(sp)
    80003450:	6a02                	ld	s4,0(sp)
    80003452:	6145                	add	sp,sp,48
    80003454:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003456:	0009a503          	lw	a0,0(s3)
    8000345a:	faaff0ef          	jal	80002c04 <bread>
    8000345e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003460:	05850493          	add	s1,a0,88
    80003464:	45850913          	add	s2,a0,1112
    80003468:	a021                	j	80003470 <itrunc+0x6e>
    8000346a:	0491                	add	s1,s1,4
    8000346c:	01248963          	beq	s1,s2,8000347e <itrunc+0x7c>
      if(a[j])
    80003470:	408c                	lw	a1,0(s1)
    80003472:	dde5                	beqz	a1,8000346a <itrunc+0x68>
        bfree(ip->dev, a[j]);
    80003474:	0009a503          	lw	a0,0(s3)
    80003478:	985ff0ef          	jal	80002dfc <bfree>
    8000347c:	b7fd                	j	8000346a <itrunc+0x68>
    brelse(bp);
    8000347e:	8552                	mv	a0,s4
    80003480:	88dff0ef          	jal	80002d0c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003484:	0809a583          	lw	a1,128(s3)
    80003488:	0009a503          	lw	a0,0(s3)
    8000348c:	971ff0ef          	jal	80002dfc <bfree>
    ip->addrs[NDIRECT] = 0;
    80003490:	0809a023          	sw	zero,128(s3)
    80003494:	b765                	j	8000343c <itrunc+0x3a>

0000000080003496 <iput>:
{
    80003496:	1101                	add	sp,sp,-32
    80003498:	ec06                	sd	ra,24(sp)
    8000349a:	e822                	sd	s0,16(sp)
    8000349c:	e426                	sd	s1,8(sp)
    8000349e:	e04a                	sd	s2,0(sp)
    800034a0:	1000                	add	s0,sp,32
    800034a2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800034a4:	0002d517          	auipc	a0,0x2d
    800034a8:	a0450513          	add	a0,a0,-1532 # 8002fea8 <itable>
    800034ac:	ef4fd0ef          	jal	80000ba0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800034b0:	4498                	lw	a4,8(s1)
    800034b2:	4785                	li	a5,1
    800034b4:	02f70163          	beq	a4,a5,800034d6 <iput+0x40>
  ip->ref--;
    800034b8:	449c                	lw	a5,8(s1)
    800034ba:	37fd                	addw	a5,a5,-1
    800034bc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800034be:	0002d517          	auipc	a0,0x2d
    800034c2:	9ea50513          	add	a0,a0,-1558 # 8002fea8 <itable>
    800034c6:	f72fd0ef          	jal	80000c38 <release>
}
    800034ca:	60e2                	ld	ra,24(sp)
    800034cc:	6442                	ld	s0,16(sp)
    800034ce:	64a2                	ld	s1,8(sp)
    800034d0:	6902                	ld	s2,0(sp)
    800034d2:	6105                	add	sp,sp,32
    800034d4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800034d6:	40bc                	lw	a5,64(s1)
    800034d8:	d3e5                	beqz	a5,800034b8 <iput+0x22>
    800034da:	04a49783          	lh	a5,74(s1)
    800034de:	ffe9                	bnez	a5,800034b8 <iput+0x22>
    acquiresleep(&ip->lock);
    800034e0:	01048913          	add	s2,s1,16
    800034e4:	854a                	mv	a0,s2
    800034e6:	125000ef          	jal	80003e0a <acquiresleep>
    release(&itable.lock);
    800034ea:	0002d517          	auipc	a0,0x2d
    800034ee:	9be50513          	add	a0,a0,-1602 # 8002fea8 <itable>
    800034f2:	f46fd0ef          	jal	80000c38 <release>
    itrunc(ip);
    800034f6:	8526                	mv	a0,s1
    800034f8:	f0bff0ef          	jal	80003402 <itrunc>
    ip->type = 0;
    800034fc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003500:	8526                	mv	a0,s1
    80003502:	d63ff0ef          	jal	80003264 <iupdate>
    ip->valid = 0;
    80003506:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000350a:	854a                	mv	a0,s2
    8000350c:	145000ef          	jal	80003e50 <releasesleep>
    acquire(&itable.lock);
    80003510:	0002d517          	auipc	a0,0x2d
    80003514:	99850513          	add	a0,a0,-1640 # 8002fea8 <itable>
    80003518:	e88fd0ef          	jal	80000ba0 <acquire>
    8000351c:	bf71                	j	800034b8 <iput+0x22>

000000008000351e <iunlockput>:
{
    8000351e:	1101                	add	sp,sp,-32
    80003520:	ec06                	sd	ra,24(sp)
    80003522:	e822                	sd	s0,16(sp)
    80003524:	e426                	sd	s1,8(sp)
    80003526:	1000                	add	s0,sp,32
    80003528:	84aa                	mv	s1,a0
  iunlock(ip);
    8000352a:	e99ff0ef          	jal	800033c2 <iunlock>
  iput(ip);
    8000352e:	8526                	mv	a0,s1
    80003530:	f67ff0ef          	jal	80003496 <iput>
}
    80003534:	60e2                	ld	ra,24(sp)
    80003536:	6442                	ld	s0,16(sp)
    80003538:	64a2                	ld	s1,8(sp)
    8000353a:	6105                	add	sp,sp,32
    8000353c:	8082                	ret

000000008000353e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000353e:	1141                	add	sp,sp,-16
    80003540:	e422                	sd	s0,8(sp)
    80003542:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003544:	411c                	lw	a5,0(a0)
    80003546:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003548:	415c                	lw	a5,4(a0)
    8000354a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000354c:	04451783          	lh	a5,68(a0)
    80003550:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003554:	04a51783          	lh	a5,74(a0)
    80003558:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000355c:	04c56783          	lwu	a5,76(a0)
    80003560:	e99c                	sd	a5,16(a1)
}
    80003562:	6422                	ld	s0,8(sp)
    80003564:	0141                	add	sp,sp,16
    80003566:	8082                	ret

0000000080003568 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003568:	457c                	lw	a5,76(a0)
    8000356a:	0cd7ef63          	bltu	a5,a3,80003648 <readi+0xe0>
{
    8000356e:	7159                	add	sp,sp,-112
    80003570:	f486                	sd	ra,104(sp)
    80003572:	f0a2                	sd	s0,96(sp)
    80003574:	eca6                	sd	s1,88(sp)
    80003576:	e8ca                	sd	s2,80(sp)
    80003578:	e4ce                	sd	s3,72(sp)
    8000357a:	e0d2                	sd	s4,64(sp)
    8000357c:	fc56                	sd	s5,56(sp)
    8000357e:	f85a                	sd	s6,48(sp)
    80003580:	f45e                	sd	s7,40(sp)
    80003582:	f062                	sd	s8,32(sp)
    80003584:	ec66                	sd	s9,24(sp)
    80003586:	e86a                	sd	s10,16(sp)
    80003588:	e46e                	sd	s11,8(sp)
    8000358a:	1880                	add	s0,sp,112
    8000358c:	8b2a                	mv	s6,a0
    8000358e:	8bae                	mv	s7,a1
    80003590:	8a32                	mv	s4,a2
    80003592:	84b6                	mv	s1,a3
    80003594:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003596:	9f35                	addw	a4,a4,a3
    return 0;
    80003598:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000359a:	08d76663          	bltu	a4,a3,80003626 <readi+0xbe>
  if(off + n > ip->size)
    8000359e:	00e7f463          	bgeu	a5,a4,800035a6 <readi+0x3e>
    n = ip->size - off;
    800035a2:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800035a6:	080a8f63          	beqz	s5,80003644 <readi+0xdc>
    800035aa:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800035ac:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800035b0:	5c7d                	li	s8,-1
    800035b2:	a80d                	j	800035e4 <readi+0x7c>
    800035b4:	020d1d93          	sll	s11,s10,0x20
    800035b8:	020ddd93          	srl	s11,s11,0x20
    800035bc:	05890613          	add	a2,s2,88
    800035c0:	86ee                	mv	a3,s11
    800035c2:	963a                	add	a2,a2,a4
    800035c4:	85d2                	mv	a1,s4
    800035c6:	855e                	mv	a0,s7
    800035c8:	bcbfe0ef          	jal	80002192 <either_copyout>
    800035cc:	05850763          	beq	a0,s8,8000361a <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800035d0:	854a                	mv	a0,s2
    800035d2:	f3aff0ef          	jal	80002d0c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800035d6:	013d09bb          	addw	s3,s10,s3
    800035da:	009d04bb          	addw	s1,s10,s1
    800035de:	9a6e                	add	s4,s4,s11
    800035e0:	0559f163          	bgeu	s3,s5,80003622 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    800035e4:	00a4d59b          	srlw	a1,s1,0xa
    800035e8:	855a                	mv	a0,s6
    800035ea:	98dff0ef          	jal	80002f76 <bmap>
    800035ee:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800035f2:	c985                	beqz	a1,80003622 <readi+0xba>
    bp = bread(ip->dev, addr);
    800035f4:	000b2503          	lw	a0,0(s6)
    800035f8:	e0cff0ef          	jal	80002c04 <bread>
    800035fc:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800035fe:	3ff4f713          	and	a4,s1,1023
    80003602:	40ec87bb          	subw	a5,s9,a4
    80003606:	413a86bb          	subw	a3,s5,s3
    8000360a:	8d3e                	mv	s10,a5
    8000360c:	2781                	sext.w	a5,a5
    8000360e:	0006861b          	sext.w	a2,a3
    80003612:	faf671e3          	bgeu	a2,a5,800035b4 <readi+0x4c>
    80003616:	8d36                	mv	s10,a3
    80003618:	bf71                	j	800035b4 <readi+0x4c>
      brelse(bp);
    8000361a:	854a                	mv	a0,s2
    8000361c:	ef0ff0ef          	jal	80002d0c <brelse>
      tot = -1;
    80003620:	59fd                	li	s3,-1
  }
  return tot;
    80003622:	0009851b          	sext.w	a0,s3
}
    80003626:	70a6                	ld	ra,104(sp)
    80003628:	7406                	ld	s0,96(sp)
    8000362a:	64e6                	ld	s1,88(sp)
    8000362c:	6946                	ld	s2,80(sp)
    8000362e:	69a6                	ld	s3,72(sp)
    80003630:	6a06                	ld	s4,64(sp)
    80003632:	7ae2                	ld	s5,56(sp)
    80003634:	7b42                	ld	s6,48(sp)
    80003636:	7ba2                	ld	s7,40(sp)
    80003638:	7c02                	ld	s8,32(sp)
    8000363a:	6ce2                	ld	s9,24(sp)
    8000363c:	6d42                	ld	s10,16(sp)
    8000363e:	6da2                	ld	s11,8(sp)
    80003640:	6165                	add	sp,sp,112
    80003642:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003644:	89d6                	mv	s3,s5
    80003646:	bff1                	j	80003622 <readi+0xba>
    return 0;
    80003648:	4501                	li	a0,0
}
    8000364a:	8082                	ret

000000008000364c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000364c:	457c                	lw	a5,76(a0)
    8000364e:	0ed7ea63          	bltu	a5,a3,80003742 <writei+0xf6>
{
    80003652:	7159                	add	sp,sp,-112
    80003654:	f486                	sd	ra,104(sp)
    80003656:	f0a2                	sd	s0,96(sp)
    80003658:	eca6                	sd	s1,88(sp)
    8000365a:	e8ca                	sd	s2,80(sp)
    8000365c:	e4ce                	sd	s3,72(sp)
    8000365e:	e0d2                	sd	s4,64(sp)
    80003660:	fc56                	sd	s5,56(sp)
    80003662:	f85a                	sd	s6,48(sp)
    80003664:	f45e                	sd	s7,40(sp)
    80003666:	f062                	sd	s8,32(sp)
    80003668:	ec66                	sd	s9,24(sp)
    8000366a:	e86a                	sd	s10,16(sp)
    8000366c:	e46e                	sd	s11,8(sp)
    8000366e:	1880                	add	s0,sp,112
    80003670:	8aaa                	mv	s5,a0
    80003672:	8bae                	mv	s7,a1
    80003674:	8a32                	mv	s4,a2
    80003676:	8936                	mv	s2,a3
    80003678:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000367a:	00e687bb          	addw	a5,a3,a4
    8000367e:	0cd7e463          	bltu	a5,a3,80003746 <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003682:	00043737          	lui	a4,0x43
    80003686:	0cf76263          	bltu	a4,a5,8000374a <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000368a:	0a0b0a63          	beqz	s6,8000373e <writei+0xf2>
    8000368e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003690:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003694:	5c7d                	li	s8,-1
    80003696:	a825                	j	800036ce <writei+0x82>
    80003698:	020d1d93          	sll	s11,s10,0x20
    8000369c:	020ddd93          	srl	s11,s11,0x20
    800036a0:	05848513          	add	a0,s1,88
    800036a4:	86ee                	mv	a3,s11
    800036a6:	8652                	mv	a2,s4
    800036a8:	85de                	mv	a1,s7
    800036aa:	953a                	add	a0,a0,a4
    800036ac:	b31fe0ef          	jal	800021dc <either_copyin>
    800036b0:	05850a63          	beq	a0,s8,80003704 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800036b4:	8526                	mv	a0,s1
    800036b6:	64e000ef          	jal	80003d04 <log_write>
    brelse(bp);
    800036ba:	8526                	mv	a0,s1
    800036bc:	e50ff0ef          	jal	80002d0c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800036c0:	013d09bb          	addw	s3,s10,s3
    800036c4:	012d093b          	addw	s2,s10,s2
    800036c8:	9a6e                	add	s4,s4,s11
    800036ca:	0569f063          	bgeu	s3,s6,8000370a <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800036ce:	00a9559b          	srlw	a1,s2,0xa
    800036d2:	8556                	mv	a0,s5
    800036d4:	8a3ff0ef          	jal	80002f76 <bmap>
    800036d8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800036dc:	c59d                	beqz	a1,8000370a <writei+0xbe>
    bp = bread(ip->dev, addr);
    800036de:	000aa503          	lw	a0,0(s5)
    800036e2:	d22ff0ef          	jal	80002c04 <bread>
    800036e6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800036e8:	3ff97713          	and	a4,s2,1023
    800036ec:	40ec87bb          	subw	a5,s9,a4
    800036f0:	413b06bb          	subw	a3,s6,s3
    800036f4:	8d3e                	mv	s10,a5
    800036f6:	2781                	sext.w	a5,a5
    800036f8:	0006861b          	sext.w	a2,a3
    800036fc:	f8f67ee3          	bgeu	a2,a5,80003698 <writei+0x4c>
    80003700:	8d36                	mv	s10,a3
    80003702:	bf59                	j	80003698 <writei+0x4c>
      brelse(bp);
    80003704:	8526                	mv	a0,s1
    80003706:	e06ff0ef          	jal	80002d0c <brelse>
  }

  if(off > ip->size)
    8000370a:	04caa783          	lw	a5,76(s5)
    8000370e:	0127f463          	bgeu	a5,s2,80003716 <writei+0xca>
    ip->size = off;
    80003712:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003716:	8556                	mv	a0,s5
    80003718:	b4dff0ef          	jal	80003264 <iupdate>

  return tot;
    8000371c:	0009851b          	sext.w	a0,s3
}
    80003720:	70a6                	ld	ra,104(sp)
    80003722:	7406                	ld	s0,96(sp)
    80003724:	64e6                	ld	s1,88(sp)
    80003726:	6946                	ld	s2,80(sp)
    80003728:	69a6                	ld	s3,72(sp)
    8000372a:	6a06                	ld	s4,64(sp)
    8000372c:	7ae2                	ld	s5,56(sp)
    8000372e:	7b42                	ld	s6,48(sp)
    80003730:	7ba2                	ld	s7,40(sp)
    80003732:	7c02                	ld	s8,32(sp)
    80003734:	6ce2                	ld	s9,24(sp)
    80003736:	6d42                	ld	s10,16(sp)
    80003738:	6da2                	ld	s11,8(sp)
    8000373a:	6165                	add	sp,sp,112
    8000373c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000373e:	89da                	mv	s3,s6
    80003740:	bfd9                	j	80003716 <writei+0xca>
    return -1;
    80003742:	557d                	li	a0,-1
}
    80003744:	8082                	ret
    return -1;
    80003746:	557d                	li	a0,-1
    80003748:	bfe1                	j	80003720 <writei+0xd4>
    return -1;
    8000374a:	557d                	li	a0,-1
    8000374c:	bfd1                	j	80003720 <writei+0xd4>

000000008000374e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000374e:	1141                	add	sp,sp,-16
    80003750:	e406                	sd	ra,8(sp)
    80003752:	e022                	sd	s0,0(sp)
    80003754:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003756:	4639                	li	a2,14
    80003758:	de8fd0ef          	jal	80000d40 <strncmp>
}
    8000375c:	60a2                	ld	ra,8(sp)
    8000375e:	6402                	ld	s0,0(sp)
    80003760:	0141                	add	sp,sp,16
    80003762:	8082                	ret

0000000080003764 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003764:	7139                	add	sp,sp,-64
    80003766:	fc06                	sd	ra,56(sp)
    80003768:	f822                	sd	s0,48(sp)
    8000376a:	f426                	sd	s1,40(sp)
    8000376c:	f04a                	sd	s2,32(sp)
    8000376e:	ec4e                	sd	s3,24(sp)
    80003770:	e852                	sd	s4,16(sp)
    80003772:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003774:	04451703          	lh	a4,68(a0)
    80003778:	4785                	li	a5,1
    8000377a:	00f71a63          	bne	a4,a5,8000378e <dirlookup+0x2a>
    8000377e:	892a                	mv	s2,a0
    80003780:	89ae                	mv	s3,a1
    80003782:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003784:	457c                	lw	a5,76(a0)
    80003786:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003788:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000378a:	e39d                	bnez	a5,800037b0 <dirlookup+0x4c>
    8000378c:	a095                	j	800037f0 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    8000378e:	00004517          	auipc	a0,0x4
    80003792:	ee250513          	add	a0,a0,-286 # 80007670 <syscalls+0x1e0>
    80003796:	fc9fc0ef          	jal	8000075e <panic>
      panic("dirlookup read");
    8000379a:	00004517          	auipc	a0,0x4
    8000379e:	eee50513          	add	a0,a0,-274 # 80007688 <syscalls+0x1f8>
    800037a2:	fbdfc0ef          	jal	8000075e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800037a6:	24c1                	addw	s1,s1,16
    800037a8:	04c92783          	lw	a5,76(s2)
    800037ac:	04f4f163          	bgeu	s1,a5,800037ee <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800037b0:	4741                	li	a4,16
    800037b2:	86a6                	mv	a3,s1
    800037b4:	fc040613          	add	a2,s0,-64
    800037b8:	4581                	li	a1,0
    800037ba:	854a                	mv	a0,s2
    800037bc:	dadff0ef          	jal	80003568 <readi>
    800037c0:	47c1                	li	a5,16
    800037c2:	fcf51ce3          	bne	a0,a5,8000379a <dirlookup+0x36>
    if(de.inum == 0)
    800037c6:	fc045783          	lhu	a5,-64(s0)
    800037ca:	dff1                	beqz	a5,800037a6 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800037cc:	fc240593          	add	a1,s0,-62
    800037d0:	854e                	mv	a0,s3
    800037d2:	f7dff0ef          	jal	8000374e <namecmp>
    800037d6:	f961                	bnez	a0,800037a6 <dirlookup+0x42>
      if(poff)
    800037d8:	000a0463          	beqz	s4,800037e0 <dirlookup+0x7c>
        *poff = off;
    800037dc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800037e0:	fc045583          	lhu	a1,-64(s0)
    800037e4:	00092503          	lw	a0,0(s2)
    800037e8:	85dff0ef          	jal	80003044 <iget>
    800037ec:	a011                	j	800037f0 <dirlookup+0x8c>
  return 0;
    800037ee:	4501                	li	a0,0
}
    800037f0:	70e2                	ld	ra,56(sp)
    800037f2:	7442                	ld	s0,48(sp)
    800037f4:	74a2                	ld	s1,40(sp)
    800037f6:	7902                	ld	s2,32(sp)
    800037f8:	69e2                	ld	s3,24(sp)
    800037fa:	6a42                	ld	s4,16(sp)
    800037fc:	6121                	add	sp,sp,64
    800037fe:	8082                	ret

0000000080003800 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003800:	711d                	add	sp,sp,-96
    80003802:	ec86                	sd	ra,88(sp)
    80003804:	e8a2                	sd	s0,80(sp)
    80003806:	e4a6                	sd	s1,72(sp)
    80003808:	e0ca                	sd	s2,64(sp)
    8000380a:	fc4e                	sd	s3,56(sp)
    8000380c:	f852                	sd	s4,48(sp)
    8000380e:	f456                	sd	s5,40(sp)
    80003810:	f05a                	sd	s6,32(sp)
    80003812:	ec5e                	sd	s7,24(sp)
    80003814:	e862                	sd	s8,16(sp)
    80003816:	e466                	sd	s9,8(sp)
    80003818:	1080                	add	s0,sp,96
    8000381a:	84aa                	mv	s1,a0
    8000381c:	8b2e                	mv	s6,a1
    8000381e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003820:	00054703          	lbu	a4,0(a0)
    80003824:	02f00793          	li	a5,47
    80003828:	00f70e63          	beq	a4,a5,80003844 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000382c:	804fe0ef          	jal	80001830 <myproc>
    80003830:	15053503          	ld	a0,336(a0)
    80003834:	aafff0ef          	jal	800032e2 <idup>
    80003838:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000383a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000383e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003840:	4b85                	li	s7,1
    80003842:	a871                	j	800038de <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003844:	4585                	li	a1,1
    80003846:	4505                	li	a0,1
    80003848:	ffcff0ef          	jal	80003044 <iget>
    8000384c:	8a2a                	mv	s4,a0
    8000384e:	b7f5                	j	8000383a <namex+0x3a>
      iunlockput(ip);
    80003850:	8552                	mv	a0,s4
    80003852:	ccdff0ef          	jal	8000351e <iunlockput>
      return 0;
    80003856:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003858:	8552                	mv	a0,s4
    8000385a:	60e6                	ld	ra,88(sp)
    8000385c:	6446                	ld	s0,80(sp)
    8000385e:	64a6                	ld	s1,72(sp)
    80003860:	6906                	ld	s2,64(sp)
    80003862:	79e2                	ld	s3,56(sp)
    80003864:	7a42                	ld	s4,48(sp)
    80003866:	7aa2                	ld	s5,40(sp)
    80003868:	7b02                	ld	s6,32(sp)
    8000386a:	6be2                	ld	s7,24(sp)
    8000386c:	6c42                	ld	s8,16(sp)
    8000386e:	6ca2                	ld	s9,8(sp)
    80003870:	6125                	add	sp,sp,96
    80003872:	8082                	ret
      iunlock(ip);
    80003874:	8552                	mv	a0,s4
    80003876:	b4dff0ef          	jal	800033c2 <iunlock>
      return ip;
    8000387a:	bff9                	j	80003858 <namex+0x58>
      iunlockput(ip);
    8000387c:	8552                	mv	a0,s4
    8000387e:	ca1ff0ef          	jal	8000351e <iunlockput>
      return 0;
    80003882:	8a4e                	mv	s4,s3
    80003884:	bfd1                	j	80003858 <namex+0x58>
  len = path - s;
    80003886:	40998633          	sub	a2,s3,s1
    8000388a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000388e:	099c5063          	bge	s8,s9,8000390e <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003892:	4639                	li	a2,14
    80003894:	85a6                	mv	a1,s1
    80003896:	8556                	mv	a0,s5
    80003898:	c38fd0ef          	jal	80000cd0 <memmove>
    8000389c:	84ce                	mv	s1,s3
  while(*path == '/')
    8000389e:	0004c783          	lbu	a5,0(s1)
    800038a2:	01279763          	bne	a5,s2,800038b0 <namex+0xb0>
    path++;
    800038a6:	0485                	add	s1,s1,1
  while(*path == '/')
    800038a8:	0004c783          	lbu	a5,0(s1)
    800038ac:	ff278de3          	beq	a5,s2,800038a6 <namex+0xa6>
    ilock(ip);
    800038b0:	8552                	mv	a0,s4
    800038b2:	a67ff0ef          	jal	80003318 <ilock>
    if(ip->type != T_DIR){
    800038b6:	044a1783          	lh	a5,68(s4)
    800038ba:	f9779be3          	bne	a5,s7,80003850 <namex+0x50>
    if(nameiparent && *path == '\0'){
    800038be:	000b0563          	beqz	s6,800038c8 <namex+0xc8>
    800038c2:	0004c783          	lbu	a5,0(s1)
    800038c6:	d7dd                	beqz	a5,80003874 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    800038c8:	4601                	li	a2,0
    800038ca:	85d6                	mv	a1,s5
    800038cc:	8552                	mv	a0,s4
    800038ce:	e97ff0ef          	jal	80003764 <dirlookup>
    800038d2:	89aa                	mv	s3,a0
    800038d4:	d545                	beqz	a0,8000387c <namex+0x7c>
    iunlockput(ip);
    800038d6:	8552                	mv	a0,s4
    800038d8:	c47ff0ef          	jal	8000351e <iunlockput>
    ip = next;
    800038dc:	8a4e                	mv	s4,s3
  while(*path == '/')
    800038de:	0004c783          	lbu	a5,0(s1)
    800038e2:	01279763          	bne	a5,s2,800038f0 <namex+0xf0>
    path++;
    800038e6:	0485                	add	s1,s1,1
  while(*path == '/')
    800038e8:	0004c783          	lbu	a5,0(s1)
    800038ec:	ff278de3          	beq	a5,s2,800038e6 <namex+0xe6>
  if(*path == 0)
    800038f0:	cb8d                	beqz	a5,80003922 <namex+0x122>
  while(*path != '/' && *path != 0)
    800038f2:	0004c783          	lbu	a5,0(s1)
    800038f6:	89a6                	mv	s3,s1
  len = path - s;
    800038f8:	4c81                	li	s9,0
    800038fa:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800038fc:	01278963          	beq	a5,s2,8000390e <namex+0x10e>
    80003900:	d3d9                	beqz	a5,80003886 <namex+0x86>
    path++;
    80003902:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003904:	0009c783          	lbu	a5,0(s3)
    80003908:	ff279ce3          	bne	a5,s2,80003900 <namex+0x100>
    8000390c:	bfad                	j	80003886 <namex+0x86>
    memmove(name, s, len);
    8000390e:	2601                	sext.w	a2,a2
    80003910:	85a6                	mv	a1,s1
    80003912:	8556                	mv	a0,s5
    80003914:	bbcfd0ef          	jal	80000cd0 <memmove>
    name[len] = 0;
    80003918:	9cd6                	add	s9,s9,s5
    8000391a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000391e:	84ce                	mv	s1,s3
    80003920:	bfbd                	j	8000389e <namex+0x9e>
  if(nameiparent){
    80003922:	f20b0be3          	beqz	s6,80003858 <namex+0x58>
    iput(ip);
    80003926:	8552                	mv	a0,s4
    80003928:	b6fff0ef          	jal	80003496 <iput>
    return 0;
    8000392c:	4a01                	li	s4,0
    8000392e:	b72d                	j	80003858 <namex+0x58>

0000000080003930 <dirlink>:
{
    80003930:	7139                	add	sp,sp,-64
    80003932:	fc06                	sd	ra,56(sp)
    80003934:	f822                	sd	s0,48(sp)
    80003936:	f426                	sd	s1,40(sp)
    80003938:	f04a                	sd	s2,32(sp)
    8000393a:	ec4e                	sd	s3,24(sp)
    8000393c:	e852                	sd	s4,16(sp)
    8000393e:	0080                	add	s0,sp,64
    80003940:	892a                	mv	s2,a0
    80003942:	8a2e                	mv	s4,a1
    80003944:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003946:	4601                	li	a2,0
    80003948:	e1dff0ef          	jal	80003764 <dirlookup>
    8000394c:	e52d                	bnez	a0,800039b6 <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000394e:	04c92483          	lw	s1,76(s2)
    80003952:	c48d                	beqz	s1,8000397c <dirlink+0x4c>
    80003954:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003956:	4741                	li	a4,16
    80003958:	86a6                	mv	a3,s1
    8000395a:	fc040613          	add	a2,s0,-64
    8000395e:	4581                	li	a1,0
    80003960:	854a                	mv	a0,s2
    80003962:	c07ff0ef          	jal	80003568 <readi>
    80003966:	47c1                	li	a5,16
    80003968:	04f51b63          	bne	a0,a5,800039be <dirlink+0x8e>
    if(de.inum == 0)
    8000396c:	fc045783          	lhu	a5,-64(s0)
    80003970:	c791                	beqz	a5,8000397c <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003972:	24c1                	addw	s1,s1,16
    80003974:	04c92783          	lw	a5,76(s2)
    80003978:	fcf4efe3          	bltu	s1,a5,80003956 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    8000397c:	4639                	li	a2,14
    8000397e:	85d2                	mv	a1,s4
    80003980:	fc240513          	add	a0,s0,-62
    80003984:	bf8fd0ef          	jal	80000d7c <strncpy>
  de.inum = inum;
    80003988:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000398c:	4741                	li	a4,16
    8000398e:	86a6                	mv	a3,s1
    80003990:	fc040613          	add	a2,s0,-64
    80003994:	4581                	li	a1,0
    80003996:	854a                	mv	a0,s2
    80003998:	cb5ff0ef          	jal	8000364c <writei>
    8000399c:	1541                	add	a0,a0,-16
    8000399e:	00a03533          	snez	a0,a0
    800039a2:	40a00533          	neg	a0,a0
}
    800039a6:	70e2                	ld	ra,56(sp)
    800039a8:	7442                	ld	s0,48(sp)
    800039aa:	74a2                	ld	s1,40(sp)
    800039ac:	7902                	ld	s2,32(sp)
    800039ae:	69e2                	ld	s3,24(sp)
    800039b0:	6a42                	ld	s4,16(sp)
    800039b2:	6121                	add	sp,sp,64
    800039b4:	8082                	ret
    iput(ip);
    800039b6:	ae1ff0ef          	jal	80003496 <iput>
    return -1;
    800039ba:	557d                	li	a0,-1
    800039bc:	b7ed                	j	800039a6 <dirlink+0x76>
      panic("dirlink read");
    800039be:	00004517          	auipc	a0,0x4
    800039c2:	cda50513          	add	a0,a0,-806 # 80007698 <syscalls+0x208>
    800039c6:	d99fc0ef          	jal	8000075e <panic>

00000000800039ca <namei>:

struct inode*
namei(char *path)
{
    800039ca:	1101                	add	sp,sp,-32
    800039cc:	ec06                	sd	ra,24(sp)
    800039ce:	e822                	sd	s0,16(sp)
    800039d0:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800039d2:	fe040613          	add	a2,s0,-32
    800039d6:	4581                	li	a1,0
    800039d8:	e29ff0ef          	jal	80003800 <namex>
}
    800039dc:	60e2                	ld	ra,24(sp)
    800039de:	6442                	ld	s0,16(sp)
    800039e0:	6105                	add	sp,sp,32
    800039e2:	8082                	ret

00000000800039e4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800039e4:	1141                	add	sp,sp,-16
    800039e6:	e406                	sd	ra,8(sp)
    800039e8:	e022                	sd	s0,0(sp)
    800039ea:	0800                	add	s0,sp,16
    800039ec:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800039ee:	4585                	li	a1,1
    800039f0:	e11ff0ef          	jal	80003800 <namex>
}
    800039f4:	60a2                	ld	ra,8(sp)
    800039f6:	6402                	ld	s0,0(sp)
    800039f8:	0141                	add	sp,sp,16
    800039fa:	8082                	ret

00000000800039fc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800039fc:	1101                	add	sp,sp,-32
    800039fe:	ec06                	sd	ra,24(sp)
    80003a00:	e822                	sd	s0,16(sp)
    80003a02:	e426                	sd	s1,8(sp)
    80003a04:	e04a                	sd	s2,0(sp)
    80003a06:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003a08:	0002e917          	auipc	s2,0x2e
    80003a0c:	f4890913          	add	s2,s2,-184 # 80031950 <log>
    80003a10:	01892583          	lw	a1,24(s2)
    80003a14:	02892503          	lw	a0,40(s2)
    80003a18:	9ecff0ef          	jal	80002c04 <bread>
    80003a1c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003a1e:	02c92603          	lw	a2,44(s2)
    80003a22:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003a24:	00c05f63          	blez	a2,80003a42 <write_head+0x46>
    80003a28:	0002e717          	auipc	a4,0x2e
    80003a2c:	f5870713          	add	a4,a4,-168 # 80031980 <log+0x30>
    80003a30:	87aa                	mv	a5,a0
    80003a32:	060a                	sll	a2,a2,0x2
    80003a34:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003a36:	4314                	lw	a3,0(a4)
    80003a38:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003a3a:	0711                	add	a4,a4,4
    80003a3c:	0791                	add	a5,a5,4
    80003a3e:	fec79ce3          	bne	a5,a2,80003a36 <write_head+0x3a>
  }
  bwrite(buf);
    80003a42:	8526                	mv	a0,s1
    80003a44:	a96ff0ef          	jal	80002cda <bwrite>
  brelse(buf);
    80003a48:	8526                	mv	a0,s1
    80003a4a:	ac2ff0ef          	jal	80002d0c <brelse>
}
    80003a4e:	60e2                	ld	ra,24(sp)
    80003a50:	6442                	ld	s0,16(sp)
    80003a52:	64a2                	ld	s1,8(sp)
    80003a54:	6902                	ld	s2,0(sp)
    80003a56:	6105                	add	sp,sp,32
    80003a58:	8082                	ret

0000000080003a5a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a5a:	0002e797          	auipc	a5,0x2e
    80003a5e:	f227a783          	lw	a5,-222(a5) # 8003197c <log+0x2c>
    80003a62:	08f05f63          	blez	a5,80003b00 <install_trans+0xa6>
{
    80003a66:	7139                	add	sp,sp,-64
    80003a68:	fc06                	sd	ra,56(sp)
    80003a6a:	f822                	sd	s0,48(sp)
    80003a6c:	f426                	sd	s1,40(sp)
    80003a6e:	f04a                	sd	s2,32(sp)
    80003a70:	ec4e                	sd	s3,24(sp)
    80003a72:	e852                	sd	s4,16(sp)
    80003a74:	e456                	sd	s5,8(sp)
    80003a76:	e05a                	sd	s6,0(sp)
    80003a78:	0080                	add	s0,sp,64
    80003a7a:	8b2a                	mv	s6,a0
    80003a7c:	0002ea97          	auipc	s5,0x2e
    80003a80:	f04a8a93          	add	s5,s5,-252 # 80031980 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a84:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003a86:	0002e997          	auipc	s3,0x2e
    80003a8a:	eca98993          	add	s3,s3,-310 # 80031950 <log>
    80003a8e:	a829                	j	80003aa8 <install_trans+0x4e>
    brelse(lbuf);
    80003a90:	854a                	mv	a0,s2
    80003a92:	a7aff0ef          	jal	80002d0c <brelse>
    brelse(dbuf);
    80003a96:	8526                	mv	a0,s1
    80003a98:	a74ff0ef          	jal	80002d0c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a9c:	2a05                	addw	s4,s4,1
    80003a9e:	0a91                	add	s5,s5,4
    80003aa0:	02c9a783          	lw	a5,44(s3)
    80003aa4:	04fa5463          	bge	s4,a5,80003aec <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003aa8:	0189a583          	lw	a1,24(s3)
    80003aac:	014585bb          	addw	a1,a1,s4
    80003ab0:	2585                	addw	a1,a1,1
    80003ab2:	0289a503          	lw	a0,40(s3)
    80003ab6:	94eff0ef          	jal	80002c04 <bread>
    80003aba:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003abc:	000aa583          	lw	a1,0(s5)
    80003ac0:	0289a503          	lw	a0,40(s3)
    80003ac4:	940ff0ef          	jal	80002c04 <bread>
    80003ac8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003aca:	40000613          	li	a2,1024
    80003ace:	05890593          	add	a1,s2,88
    80003ad2:	05850513          	add	a0,a0,88
    80003ad6:	9fafd0ef          	jal	80000cd0 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003ada:	8526                	mv	a0,s1
    80003adc:	9feff0ef          	jal	80002cda <bwrite>
    if(recovering == 0)
    80003ae0:	fa0b18e3          	bnez	s6,80003a90 <install_trans+0x36>
      bunpin(dbuf);
    80003ae4:	8526                	mv	a0,s1
    80003ae6:	ae2ff0ef          	jal	80002dc8 <bunpin>
    80003aea:	b75d                	j	80003a90 <install_trans+0x36>
}
    80003aec:	70e2                	ld	ra,56(sp)
    80003aee:	7442                	ld	s0,48(sp)
    80003af0:	74a2                	ld	s1,40(sp)
    80003af2:	7902                	ld	s2,32(sp)
    80003af4:	69e2                	ld	s3,24(sp)
    80003af6:	6a42                	ld	s4,16(sp)
    80003af8:	6aa2                	ld	s5,8(sp)
    80003afa:	6b02                	ld	s6,0(sp)
    80003afc:	6121                	add	sp,sp,64
    80003afe:	8082                	ret
    80003b00:	8082                	ret

0000000080003b02 <initlog>:
{
    80003b02:	7179                	add	sp,sp,-48
    80003b04:	f406                	sd	ra,40(sp)
    80003b06:	f022                	sd	s0,32(sp)
    80003b08:	ec26                	sd	s1,24(sp)
    80003b0a:	e84a                	sd	s2,16(sp)
    80003b0c:	e44e                	sd	s3,8(sp)
    80003b0e:	1800                	add	s0,sp,48
    80003b10:	892a                	mv	s2,a0
    80003b12:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003b14:	0002e497          	auipc	s1,0x2e
    80003b18:	e3c48493          	add	s1,s1,-452 # 80031950 <log>
    80003b1c:	00004597          	auipc	a1,0x4
    80003b20:	b8c58593          	add	a1,a1,-1140 # 800076a8 <syscalls+0x218>
    80003b24:	8526                	mv	a0,s1
    80003b26:	ffbfc0ef          	jal	80000b20 <initlock>
  log.start = sb->logstart;
    80003b2a:	0149a583          	lw	a1,20(s3)
    80003b2e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003b30:	0109a783          	lw	a5,16(s3)
    80003b34:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003b36:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003b3a:	854a                	mv	a0,s2
    80003b3c:	8c8ff0ef          	jal	80002c04 <bread>
  log.lh.n = lh->n;
    80003b40:	4d30                	lw	a2,88(a0)
    80003b42:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003b44:	00c05f63          	blez	a2,80003b62 <initlog+0x60>
    80003b48:	87aa                	mv	a5,a0
    80003b4a:	0002e717          	auipc	a4,0x2e
    80003b4e:	e3670713          	add	a4,a4,-458 # 80031980 <log+0x30>
    80003b52:	060a                	sll	a2,a2,0x2
    80003b54:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003b56:	4ff4                	lw	a3,92(a5)
    80003b58:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003b5a:	0791                	add	a5,a5,4
    80003b5c:	0711                	add	a4,a4,4
    80003b5e:	fec79ce3          	bne	a5,a2,80003b56 <initlog+0x54>
  brelse(buf);
    80003b62:	9aaff0ef          	jal	80002d0c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003b66:	4505                	li	a0,1
    80003b68:	ef3ff0ef          	jal	80003a5a <install_trans>
  log.lh.n = 0;
    80003b6c:	0002e797          	auipc	a5,0x2e
    80003b70:	e007a823          	sw	zero,-496(a5) # 8003197c <log+0x2c>
  write_head(); // clear the log
    80003b74:	e89ff0ef          	jal	800039fc <write_head>
}
    80003b78:	70a2                	ld	ra,40(sp)
    80003b7a:	7402                	ld	s0,32(sp)
    80003b7c:	64e2                	ld	s1,24(sp)
    80003b7e:	6942                	ld	s2,16(sp)
    80003b80:	69a2                	ld	s3,8(sp)
    80003b82:	6145                	add	sp,sp,48
    80003b84:	8082                	ret

0000000080003b86 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003b86:	1101                	add	sp,sp,-32
    80003b88:	ec06                	sd	ra,24(sp)
    80003b8a:	e822                	sd	s0,16(sp)
    80003b8c:	e426                	sd	s1,8(sp)
    80003b8e:	e04a                	sd	s2,0(sp)
    80003b90:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80003b92:	0002e517          	auipc	a0,0x2e
    80003b96:	dbe50513          	add	a0,a0,-578 # 80031950 <log>
    80003b9a:	806fd0ef          	jal	80000ba0 <acquire>
  while(1){
    if(log.committing){
    80003b9e:	0002e497          	auipc	s1,0x2e
    80003ba2:	db248493          	add	s1,s1,-590 # 80031950 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ba6:	4979                	li	s2,30
    80003ba8:	a029                	j	80003bb2 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003baa:	85a6                	mv	a1,s1
    80003bac:	8526                	mv	a0,s1
    80003bae:	a8efe0ef          	jal	80001e3c <sleep>
    if(log.committing){
    80003bb2:	50dc                	lw	a5,36(s1)
    80003bb4:	fbfd                	bnez	a5,80003baa <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003bb6:	5098                	lw	a4,32(s1)
    80003bb8:	2705                	addw	a4,a4,1
    80003bba:	0027179b          	sllw	a5,a4,0x2
    80003bbe:	9fb9                	addw	a5,a5,a4
    80003bc0:	0017979b          	sllw	a5,a5,0x1
    80003bc4:	54d4                	lw	a3,44(s1)
    80003bc6:	9fb5                	addw	a5,a5,a3
    80003bc8:	00f95763          	bge	s2,a5,80003bd6 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003bcc:	85a6                	mv	a1,s1
    80003bce:	8526                	mv	a0,s1
    80003bd0:	a6cfe0ef          	jal	80001e3c <sleep>
    80003bd4:	bff9                	j	80003bb2 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003bd6:	0002e517          	auipc	a0,0x2e
    80003bda:	d7a50513          	add	a0,a0,-646 # 80031950 <log>
    80003bde:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003be0:	858fd0ef          	jal	80000c38 <release>
      break;
    }
  }
}
    80003be4:	60e2                	ld	ra,24(sp)
    80003be6:	6442                	ld	s0,16(sp)
    80003be8:	64a2                	ld	s1,8(sp)
    80003bea:	6902                	ld	s2,0(sp)
    80003bec:	6105                	add	sp,sp,32
    80003bee:	8082                	ret

0000000080003bf0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003bf0:	7139                	add	sp,sp,-64
    80003bf2:	fc06                	sd	ra,56(sp)
    80003bf4:	f822                	sd	s0,48(sp)
    80003bf6:	f426                	sd	s1,40(sp)
    80003bf8:	f04a                	sd	s2,32(sp)
    80003bfa:	ec4e                	sd	s3,24(sp)
    80003bfc:	e852                	sd	s4,16(sp)
    80003bfe:	e456                	sd	s5,8(sp)
    80003c00:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003c02:	0002e497          	auipc	s1,0x2e
    80003c06:	d4e48493          	add	s1,s1,-690 # 80031950 <log>
    80003c0a:	8526                	mv	a0,s1
    80003c0c:	f95fc0ef          	jal	80000ba0 <acquire>
  log.outstanding -= 1;
    80003c10:	509c                	lw	a5,32(s1)
    80003c12:	37fd                	addw	a5,a5,-1
    80003c14:	0007891b          	sext.w	s2,a5
    80003c18:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003c1a:	50dc                	lw	a5,36(s1)
    80003c1c:	ef9d                	bnez	a5,80003c5a <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003c1e:	04091463          	bnez	s2,80003c66 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003c22:	0002e497          	auipc	s1,0x2e
    80003c26:	d2e48493          	add	s1,s1,-722 # 80031950 <log>
    80003c2a:	4785                	li	a5,1
    80003c2c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003c2e:	8526                	mv	a0,s1
    80003c30:	808fd0ef          	jal	80000c38 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003c34:	54dc                	lw	a5,44(s1)
    80003c36:	04f04b63          	bgtz	a5,80003c8c <end_op+0x9c>
    acquire(&log.lock);
    80003c3a:	0002e497          	auipc	s1,0x2e
    80003c3e:	d1648493          	add	s1,s1,-746 # 80031950 <log>
    80003c42:	8526                	mv	a0,s1
    80003c44:	f5dfc0ef          	jal	80000ba0 <acquire>
    log.committing = 0;
    80003c48:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003c4c:	8526                	mv	a0,s1
    80003c4e:	a3afe0ef          	jal	80001e88 <wakeup>
    release(&log.lock);
    80003c52:	8526                	mv	a0,s1
    80003c54:	fe5fc0ef          	jal	80000c38 <release>
}
    80003c58:	a00d                	j	80003c7a <end_op+0x8a>
    panic("log.committing");
    80003c5a:	00004517          	auipc	a0,0x4
    80003c5e:	a5650513          	add	a0,a0,-1450 # 800076b0 <syscalls+0x220>
    80003c62:	afdfc0ef          	jal	8000075e <panic>
    wakeup(&log);
    80003c66:	0002e497          	auipc	s1,0x2e
    80003c6a:	cea48493          	add	s1,s1,-790 # 80031950 <log>
    80003c6e:	8526                	mv	a0,s1
    80003c70:	a18fe0ef          	jal	80001e88 <wakeup>
  release(&log.lock);
    80003c74:	8526                	mv	a0,s1
    80003c76:	fc3fc0ef          	jal	80000c38 <release>
}
    80003c7a:	70e2                	ld	ra,56(sp)
    80003c7c:	7442                	ld	s0,48(sp)
    80003c7e:	74a2                	ld	s1,40(sp)
    80003c80:	7902                	ld	s2,32(sp)
    80003c82:	69e2                	ld	s3,24(sp)
    80003c84:	6a42                	ld	s4,16(sp)
    80003c86:	6aa2                	ld	s5,8(sp)
    80003c88:	6121                	add	sp,sp,64
    80003c8a:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c8c:	0002ea97          	auipc	s5,0x2e
    80003c90:	cf4a8a93          	add	s5,s5,-780 # 80031980 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003c94:	0002ea17          	auipc	s4,0x2e
    80003c98:	cbca0a13          	add	s4,s4,-836 # 80031950 <log>
    80003c9c:	018a2583          	lw	a1,24(s4)
    80003ca0:	012585bb          	addw	a1,a1,s2
    80003ca4:	2585                	addw	a1,a1,1
    80003ca6:	028a2503          	lw	a0,40(s4)
    80003caa:	f5bfe0ef          	jal	80002c04 <bread>
    80003cae:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003cb0:	000aa583          	lw	a1,0(s5)
    80003cb4:	028a2503          	lw	a0,40(s4)
    80003cb8:	f4dfe0ef          	jal	80002c04 <bread>
    80003cbc:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003cbe:	40000613          	li	a2,1024
    80003cc2:	05850593          	add	a1,a0,88
    80003cc6:	05848513          	add	a0,s1,88
    80003cca:	806fd0ef          	jal	80000cd0 <memmove>
    bwrite(to);  // write the log
    80003cce:	8526                	mv	a0,s1
    80003cd0:	80aff0ef          	jal	80002cda <bwrite>
    brelse(from);
    80003cd4:	854e                	mv	a0,s3
    80003cd6:	836ff0ef          	jal	80002d0c <brelse>
    brelse(to);
    80003cda:	8526                	mv	a0,s1
    80003cdc:	830ff0ef          	jal	80002d0c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ce0:	2905                	addw	s2,s2,1
    80003ce2:	0a91                	add	s5,s5,4
    80003ce4:	02ca2783          	lw	a5,44(s4)
    80003ce8:	faf94ae3          	blt	s2,a5,80003c9c <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003cec:	d11ff0ef          	jal	800039fc <write_head>
    install_trans(0); // Now install writes to home locations
    80003cf0:	4501                	li	a0,0
    80003cf2:	d69ff0ef          	jal	80003a5a <install_trans>
    log.lh.n = 0;
    80003cf6:	0002e797          	auipc	a5,0x2e
    80003cfa:	c807a323          	sw	zero,-890(a5) # 8003197c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003cfe:	cffff0ef          	jal	800039fc <write_head>
    80003d02:	bf25                	j	80003c3a <end_op+0x4a>

0000000080003d04 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003d04:	1101                	add	sp,sp,-32
    80003d06:	ec06                	sd	ra,24(sp)
    80003d08:	e822                	sd	s0,16(sp)
    80003d0a:	e426                	sd	s1,8(sp)
    80003d0c:	e04a                	sd	s2,0(sp)
    80003d0e:	1000                	add	s0,sp,32
    80003d10:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003d12:	0002e917          	auipc	s2,0x2e
    80003d16:	c3e90913          	add	s2,s2,-962 # 80031950 <log>
    80003d1a:	854a                	mv	a0,s2
    80003d1c:	e85fc0ef          	jal	80000ba0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003d20:	02c92603          	lw	a2,44(s2)
    80003d24:	47f5                	li	a5,29
    80003d26:	06c7c363          	blt	a5,a2,80003d8c <log_write+0x88>
    80003d2a:	0002e797          	auipc	a5,0x2e
    80003d2e:	c427a783          	lw	a5,-958(a5) # 8003196c <log+0x1c>
    80003d32:	37fd                	addw	a5,a5,-1
    80003d34:	04f65c63          	bge	a2,a5,80003d8c <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003d38:	0002e797          	auipc	a5,0x2e
    80003d3c:	c387a783          	lw	a5,-968(a5) # 80031970 <log+0x20>
    80003d40:	04f05c63          	blez	a5,80003d98 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003d44:	4781                	li	a5,0
    80003d46:	04c05f63          	blez	a2,80003da4 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003d4a:	44cc                	lw	a1,12(s1)
    80003d4c:	0002e717          	auipc	a4,0x2e
    80003d50:	c3470713          	add	a4,a4,-972 # 80031980 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003d54:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003d56:	4314                	lw	a3,0(a4)
    80003d58:	04b68663          	beq	a3,a1,80003da4 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003d5c:	2785                	addw	a5,a5,1
    80003d5e:	0711                	add	a4,a4,4
    80003d60:	fef61be3          	bne	a2,a5,80003d56 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003d64:	0621                	add	a2,a2,8
    80003d66:	060a                	sll	a2,a2,0x2
    80003d68:	0002e797          	auipc	a5,0x2e
    80003d6c:	be878793          	add	a5,a5,-1048 # 80031950 <log>
    80003d70:	97b2                	add	a5,a5,a2
    80003d72:	44d8                	lw	a4,12(s1)
    80003d74:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003d76:	8526                	mv	a0,s1
    80003d78:	81cff0ef          	jal	80002d94 <bpin>
    log.lh.n++;
    80003d7c:	0002e717          	auipc	a4,0x2e
    80003d80:	bd470713          	add	a4,a4,-1068 # 80031950 <log>
    80003d84:	575c                	lw	a5,44(a4)
    80003d86:	2785                	addw	a5,a5,1
    80003d88:	d75c                	sw	a5,44(a4)
    80003d8a:	a80d                	j	80003dbc <log_write+0xb8>
    panic("too big a transaction");
    80003d8c:	00004517          	auipc	a0,0x4
    80003d90:	93450513          	add	a0,a0,-1740 # 800076c0 <syscalls+0x230>
    80003d94:	9cbfc0ef          	jal	8000075e <panic>
    panic("log_write outside of trans");
    80003d98:	00004517          	auipc	a0,0x4
    80003d9c:	94050513          	add	a0,a0,-1728 # 800076d8 <syscalls+0x248>
    80003da0:	9bffc0ef          	jal	8000075e <panic>
  log.lh.block[i] = b->blockno;
    80003da4:	00878693          	add	a3,a5,8
    80003da8:	068a                	sll	a3,a3,0x2
    80003daa:	0002e717          	auipc	a4,0x2e
    80003dae:	ba670713          	add	a4,a4,-1114 # 80031950 <log>
    80003db2:	9736                	add	a4,a4,a3
    80003db4:	44d4                	lw	a3,12(s1)
    80003db6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003db8:	faf60fe3          	beq	a2,a5,80003d76 <log_write+0x72>
  }
  release(&log.lock);
    80003dbc:	0002e517          	auipc	a0,0x2e
    80003dc0:	b9450513          	add	a0,a0,-1132 # 80031950 <log>
    80003dc4:	e75fc0ef          	jal	80000c38 <release>
}
    80003dc8:	60e2                	ld	ra,24(sp)
    80003dca:	6442                	ld	s0,16(sp)
    80003dcc:	64a2                	ld	s1,8(sp)
    80003dce:	6902                	ld	s2,0(sp)
    80003dd0:	6105                	add	sp,sp,32
    80003dd2:	8082                	ret

0000000080003dd4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003dd4:	1101                	add	sp,sp,-32
    80003dd6:	ec06                	sd	ra,24(sp)
    80003dd8:	e822                	sd	s0,16(sp)
    80003dda:	e426                	sd	s1,8(sp)
    80003ddc:	e04a                	sd	s2,0(sp)
    80003dde:	1000                	add	s0,sp,32
    80003de0:	84aa                	mv	s1,a0
    80003de2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003de4:	00004597          	auipc	a1,0x4
    80003de8:	91458593          	add	a1,a1,-1772 # 800076f8 <syscalls+0x268>
    80003dec:	0521                	add	a0,a0,8
    80003dee:	d33fc0ef          	jal	80000b20 <initlock>
  lk->name = name;
    80003df2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003df6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003dfa:	0204a423          	sw	zero,40(s1)
}
    80003dfe:	60e2                	ld	ra,24(sp)
    80003e00:	6442                	ld	s0,16(sp)
    80003e02:	64a2                	ld	s1,8(sp)
    80003e04:	6902                	ld	s2,0(sp)
    80003e06:	6105                	add	sp,sp,32
    80003e08:	8082                	ret

0000000080003e0a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003e0a:	1101                	add	sp,sp,-32
    80003e0c:	ec06                	sd	ra,24(sp)
    80003e0e:	e822                	sd	s0,16(sp)
    80003e10:	e426                	sd	s1,8(sp)
    80003e12:	e04a                	sd	s2,0(sp)
    80003e14:	1000                	add	s0,sp,32
    80003e16:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003e18:	00850913          	add	s2,a0,8
    80003e1c:	854a                	mv	a0,s2
    80003e1e:	d83fc0ef          	jal	80000ba0 <acquire>
  while (lk->locked) {
    80003e22:	409c                	lw	a5,0(s1)
    80003e24:	c799                	beqz	a5,80003e32 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003e26:	85ca                	mv	a1,s2
    80003e28:	8526                	mv	a0,s1
    80003e2a:	812fe0ef          	jal	80001e3c <sleep>
  while (lk->locked) {
    80003e2e:	409c                	lw	a5,0(s1)
    80003e30:	fbfd                	bnez	a5,80003e26 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003e32:	4785                	li	a5,1
    80003e34:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003e36:	9fbfd0ef          	jal	80001830 <myproc>
    80003e3a:	591c                	lw	a5,48(a0)
    80003e3c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003e3e:	854a                	mv	a0,s2
    80003e40:	df9fc0ef          	jal	80000c38 <release>
}
    80003e44:	60e2                	ld	ra,24(sp)
    80003e46:	6442                	ld	s0,16(sp)
    80003e48:	64a2                	ld	s1,8(sp)
    80003e4a:	6902                	ld	s2,0(sp)
    80003e4c:	6105                	add	sp,sp,32
    80003e4e:	8082                	ret

0000000080003e50 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003e50:	1101                	add	sp,sp,-32
    80003e52:	ec06                	sd	ra,24(sp)
    80003e54:	e822                	sd	s0,16(sp)
    80003e56:	e426                	sd	s1,8(sp)
    80003e58:	e04a                	sd	s2,0(sp)
    80003e5a:	1000                	add	s0,sp,32
    80003e5c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003e5e:	00850913          	add	s2,a0,8
    80003e62:	854a                	mv	a0,s2
    80003e64:	d3dfc0ef          	jal	80000ba0 <acquire>
  lk->locked = 0;
    80003e68:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003e6c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003e70:	8526                	mv	a0,s1
    80003e72:	816fe0ef          	jal	80001e88 <wakeup>
  release(&lk->lk);
    80003e76:	854a                	mv	a0,s2
    80003e78:	dc1fc0ef          	jal	80000c38 <release>
}
    80003e7c:	60e2                	ld	ra,24(sp)
    80003e7e:	6442                	ld	s0,16(sp)
    80003e80:	64a2                	ld	s1,8(sp)
    80003e82:	6902                	ld	s2,0(sp)
    80003e84:	6105                	add	sp,sp,32
    80003e86:	8082                	ret

0000000080003e88 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003e88:	7179                	add	sp,sp,-48
    80003e8a:	f406                	sd	ra,40(sp)
    80003e8c:	f022                	sd	s0,32(sp)
    80003e8e:	ec26                	sd	s1,24(sp)
    80003e90:	e84a                	sd	s2,16(sp)
    80003e92:	e44e                	sd	s3,8(sp)
    80003e94:	1800                	add	s0,sp,48
    80003e96:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003e98:	00850913          	add	s2,a0,8
    80003e9c:	854a                	mv	a0,s2
    80003e9e:	d03fc0ef          	jal	80000ba0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ea2:	409c                	lw	a5,0(s1)
    80003ea4:	ef89                	bnez	a5,80003ebe <holdingsleep+0x36>
    80003ea6:	4481                	li	s1,0
  release(&lk->lk);
    80003ea8:	854a                	mv	a0,s2
    80003eaa:	d8ffc0ef          	jal	80000c38 <release>
  return r;
}
    80003eae:	8526                	mv	a0,s1
    80003eb0:	70a2                	ld	ra,40(sp)
    80003eb2:	7402                	ld	s0,32(sp)
    80003eb4:	64e2                	ld	s1,24(sp)
    80003eb6:	6942                	ld	s2,16(sp)
    80003eb8:	69a2                	ld	s3,8(sp)
    80003eba:	6145                	add	sp,sp,48
    80003ebc:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ebe:	0284a983          	lw	s3,40(s1)
    80003ec2:	96ffd0ef          	jal	80001830 <myproc>
    80003ec6:	5904                	lw	s1,48(a0)
    80003ec8:	413484b3          	sub	s1,s1,s3
    80003ecc:	0014b493          	seqz	s1,s1
    80003ed0:	bfe1                	j	80003ea8 <holdingsleep+0x20>

0000000080003ed2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ed2:	1141                	add	sp,sp,-16
    80003ed4:	e406                	sd	ra,8(sp)
    80003ed6:	e022                	sd	s0,0(sp)
    80003ed8:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003eda:	00004597          	auipc	a1,0x4
    80003ede:	82e58593          	add	a1,a1,-2002 # 80007708 <syscalls+0x278>
    80003ee2:	0002e517          	auipc	a0,0x2e
    80003ee6:	bb650513          	add	a0,a0,-1098 # 80031a98 <ftable>
    80003eea:	c37fc0ef          	jal	80000b20 <initlock>
}
    80003eee:	60a2                	ld	ra,8(sp)
    80003ef0:	6402                	ld	s0,0(sp)
    80003ef2:	0141                	add	sp,sp,16
    80003ef4:	8082                	ret

0000000080003ef6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ef6:	1101                	add	sp,sp,-32
    80003ef8:	ec06                	sd	ra,24(sp)
    80003efa:	e822                	sd	s0,16(sp)
    80003efc:	e426                	sd	s1,8(sp)
    80003efe:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003f00:	0002e517          	auipc	a0,0x2e
    80003f04:	b9850513          	add	a0,a0,-1128 # 80031a98 <ftable>
    80003f08:	c99fc0ef          	jal	80000ba0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003f0c:	0002e497          	auipc	s1,0x2e
    80003f10:	ba448493          	add	s1,s1,-1116 # 80031ab0 <ftable+0x18>
    80003f14:	0002f717          	auipc	a4,0x2f
    80003f18:	b3c70713          	add	a4,a4,-1220 # 80032a50 <disk>
    if(f->ref == 0){
    80003f1c:	40dc                	lw	a5,4(s1)
    80003f1e:	cf89                	beqz	a5,80003f38 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003f20:	02848493          	add	s1,s1,40
    80003f24:	fee49ce3          	bne	s1,a4,80003f1c <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003f28:	0002e517          	auipc	a0,0x2e
    80003f2c:	b7050513          	add	a0,a0,-1168 # 80031a98 <ftable>
    80003f30:	d09fc0ef          	jal	80000c38 <release>
  return 0;
    80003f34:	4481                	li	s1,0
    80003f36:	a809                	j	80003f48 <filealloc+0x52>
      f->ref = 1;
    80003f38:	4785                	li	a5,1
    80003f3a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003f3c:	0002e517          	auipc	a0,0x2e
    80003f40:	b5c50513          	add	a0,a0,-1188 # 80031a98 <ftable>
    80003f44:	cf5fc0ef          	jal	80000c38 <release>
}
    80003f48:	8526                	mv	a0,s1
    80003f4a:	60e2                	ld	ra,24(sp)
    80003f4c:	6442                	ld	s0,16(sp)
    80003f4e:	64a2                	ld	s1,8(sp)
    80003f50:	6105                	add	sp,sp,32
    80003f52:	8082                	ret

0000000080003f54 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003f54:	1101                	add	sp,sp,-32
    80003f56:	ec06                	sd	ra,24(sp)
    80003f58:	e822                	sd	s0,16(sp)
    80003f5a:	e426                	sd	s1,8(sp)
    80003f5c:	1000                	add	s0,sp,32
    80003f5e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003f60:	0002e517          	auipc	a0,0x2e
    80003f64:	b3850513          	add	a0,a0,-1224 # 80031a98 <ftable>
    80003f68:	c39fc0ef          	jal	80000ba0 <acquire>
  if(f->ref < 1)
    80003f6c:	40dc                	lw	a5,4(s1)
    80003f6e:	02f05063          	blez	a5,80003f8e <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003f72:	2785                	addw	a5,a5,1
    80003f74:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003f76:	0002e517          	auipc	a0,0x2e
    80003f7a:	b2250513          	add	a0,a0,-1246 # 80031a98 <ftable>
    80003f7e:	cbbfc0ef          	jal	80000c38 <release>
  return f;
}
    80003f82:	8526                	mv	a0,s1
    80003f84:	60e2                	ld	ra,24(sp)
    80003f86:	6442                	ld	s0,16(sp)
    80003f88:	64a2                	ld	s1,8(sp)
    80003f8a:	6105                	add	sp,sp,32
    80003f8c:	8082                	ret
    panic("filedup");
    80003f8e:	00003517          	auipc	a0,0x3
    80003f92:	78250513          	add	a0,a0,1922 # 80007710 <syscalls+0x280>
    80003f96:	fc8fc0ef          	jal	8000075e <panic>

0000000080003f9a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003f9a:	7139                	add	sp,sp,-64
    80003f9c:	fc06                	sd	ra,56(sp)
    80003f9e:	f822                	sd	s0,48(sp)
    80003fa0:	f426                	sd	s1,40(sp)
    80003fa2:	f04a                	sd	s2,32(sp)
    80003fa4:	ec4e                	sd	s3,24(sp)
    80003fa6:	e852                	sd	s4,16(sp)
    80003fa8:	e456                	sd	s5,8(sp)
    80003faa:	0080                	add	s0,sp,64
    80003fac:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003fae:	0002e517          	auipc	a0,0x2e
    80003fb2:	aea50513          	add	a0,a0,-1302 # 80031a98 <ftable>
    80003fb6:	bebfc0ef          	jal	80000ba0 <acquire>
  if(f->ref < 1)
    80003fba:	40dc                	lw	a5,4(s1)
    80003fbc:	04f05963          	blez	a5,8000400e <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    80003fc0:	37fd                	addw	a5,a5,-1
    80003fc2:	0007871b          	sext.w	a4,a5
    80003fc6:	c0dc                	sw	a5,4(s1)
    80003fc8:	04e04963          	bgtz	a4,8000401a <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003fcc:	0004a903          	lw	s2,0(s1)
    80003fd0:	0094ca83          	lbu	s5,9(s1)
    80003fd4:	0104ba03          	ld	s4,16(s1)
    80003fd8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003fdc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003fe0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003fe4:	0002e517          	auipc	a0,0x2e
    80003fe8:	ab450513          	add	a0,a0,-1356 # 80031a98 <ftable>
    80003fec:	c4dfc0ef          	jal	80000c38 <release>

  if(ff.type == FD_PIPE){
    80003ff0:	4785                	li	a5,1
    80003ff2:	04f90363          	beq	s2,a5,80004038 <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ff6:	3979                	addw	s2,s2,-2
    80003ff8:	4785                	li	a5,1
    80003ffa:	0327e663          	bltu	a5,s2,80004026 <fileclose+0x8c>
    begin_op();
    80003ffe:	b89ff0ef          	jal	80003b86 <begin_op>
    iput(ff.ip);
    80004002:	854e                	mv	a0,s3
    80004004:	c92ff0ef          	jal	80003496 <iput>
    end_op();
    80004008:	be9ff0ef          	jal	80003bf0 <end_op>
    8000400c:	a829                	j	80004026 <fileclose+0x8c>
    panic("fileclose");
    8000400e:	00003517          	auipc	a0,0x3
    80004012:	70a50513          	add	a0,a0,1802 # 80007718 <syscalls+0x288>
    80004016:	f48fc0ef          	jal	8000075e <panic>
    release(&ftable.lock);
    8000401a:	0002e517          	auipc	a0,0x2e
    8000401e:	a7e50513          	add	a0,a0,-1410 # 80031a98 <ftable>
    80004022:	c17fc0ef          	jal	80000c38 <release>
  }
}
    80004026:	70e2                	ld	ra,56(sp)
    80004028:	7442                	ld	s0,48(sp)
    8000402a:	74a2                	ld	s1,40(sp)
    8000402c:	7902                	ld	s2,32(sp)
    8000402e:	69e2                	ld	s3,24(sp)
    80004030:	6a42                	ld	s4,16(sp)
    80004032:	6aa2                	ld	s5,8(sp)
    80004034:	6121                	add	sp,sp,64
    80004036:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004038:	85d6                	mv	a1,s5
    8000403a:	8552                	mv	a0,s4
    8000403c:	2e8000ef          	jal	80004324 <pipeclose>
    80004040:	b7dd                	j	80004026 <fileclose+0x8c>

0000000080004042 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004042:	715d                	add	sp,sp,-80
    80004044:	e486                	sd	ra,72(sp)
    80004046:	e0a2                	sd	s0,64(sp)
    80004048:	fc26                	sd	s1,56(sp)
    8000404a:	f84a                	sd	s2,48(sp)
    8000404c:	f44e                	sd	s3,40(sp)
    8000404e:	0880                	add	s0,sp,80
    80004050:	84aa                	mv	s1,a0
    80004052:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004054:	fdcfd0ef          	jal	80001830 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004058:	409c                	lw	a5,0(s1)
    8000405a:	37f9                	addw	a5,a5,-2
    8000405c:	4705                	li	a4,1
    8000405e:	02f76f63          	bltu	a4,a5,8000409c <filestat+0x5a>
    80004062:	892a                	mv	s2,a0
    ilock(f->ip);
    80004064:	6c88                	ld	a0,24(s1)
    80004066:	ab2ff0ef          	jal	80003318 <ilock>
    stati(f->ip, &st);
    8000406a:	fb840593          	add	a1,s0,-72
    8000406e:	6c88                	ld	a0,24(s1)
    80004070:	cceff0ef          	jal	8000353e <stati>
    iunlock(f->ip);
    80004074:	6c88                	ld	a0,24(s1)
    80004076:	b4cff0ef          	jal	800033c2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000407a:	46e1                	li	a3,24
    8000407c:	fb840613          	add	a2,s0,-72
    80004080:	85ce                	mv	a1,s3
    80004082:	05093503          	ld	a0,80(s2)
    80004086:	c62fd0ef          	jal	800014e8 <copyout>
    8000408a:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000408e:	60a6                	ld	ra,72(sp)
    80004090:	6406                	ld	s0,64(sp)
    80004092:	74e2                	ld	s1,56(sp)
    80004094:	7942                	ld	s2,48(sp)
    80004096:	79a2                	ld	s3,40(sp)
    80004098:	6161                	add	sp,sp,80
    8000409a:	8082                	ret
  return -1;
    8000409c:	557d                	li	a0,-1
    8000409e:	bfc5                	j	8000408e <filestat+0x4c>

00000000800040a0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800040a0:	7179                	add	sp,sp,-48
    800040a2:	f406                	sd	ra,40(sp)
    800040a4:	f022                	sd	s0,32(sp)
    800040a6:	ec26                	sd	s1,24(sp)
    800040a8:	e84a                	sd	s2,16(sp)
    800040aa:	e44e                	sd	s3,8(sp)
    800040ac:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800040ae:	00854783          	lbu	a5,8(a0)
    800040b2:	cbc1                	beqz	a5,80004142 <fileread+0xa2>
    800040b4:	84aa                	mv	s1,a0
    800040b6:	89ae                	mv	s3,a1
    800040b8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800040ba:	411c                	lw	a5,0(a0)
    800040bc:	4705                	li	a4,1
    800040be:	04e78363          	beq	a5,a4,80004104 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800040c2:	470d                	li	a4,3
    800040c4:	04e78563          	beq	a5,a4,8000410e <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800040c8:	4709                	li	a4,2
    800040ca:	06e79663          	bne	a5,a4,80004136 <fileread+0x96>
    ilock(f->ip);
    800040ce:	6d08                	ld	a0,24(a0)
    800040d0:	a48ff0ef          	jal	80003318 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800040d4:	874a                	mv	a4,s2
    800040d6:	5094                	lw	a3,32(s1)
    800040d8:	864e                	mv	a2,s3
    800040da:	4585                	li	a1,1
    800040dc:	6c88                	ld	a0,24(s1)
    800040de:	c8aff0ef          	jal	80003568 <readi>
    800040e2:	892a                	mv	s2,a0
    800040e4:	00a05563          	blez	a0,800040ee <fileread+0x4e>
      f->off += r;
    800040e8:	509c                	lw	a5,32(s1)
    800040ea:	9fa9                	addw	a5,a5,a0
    800040ec:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800040ee:	6c88                	ld	a0,24(s1)
    800040f0:	ad2ff0ef          	jal	800033c2 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800040f4:	854a                	mv	a0,s2
    800040f6:	70a2                	ld	ra,40(sp)
    800040f8:	7402                	ld	s0,32(sp)
    800040fa:	64e2                	ld	s1,24(sp)
    800040fc:	6942                	ld	s2,16(sp)
    800040fe:	69a2                	ld	s3,8(sp)
    80004100:	6145                	add	sp,sp,48
    80004102:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004104:	6908                	ld	a0,16(a0)
    80004106:	34a000ef          	jal	80004450 <piperead>
    8000410a:	892a                	mv	s2,a0
    8000410c:	b7e5                	j	800040f4 <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000410e:	02451783          	lh	a5,36(a0)
    80004112:	03079693          	sll	a3,a5,0x30
    80004116:	92c1                	srl	a3,a3,0x30
    80004118:	4725                	li	a4,9
    8000411a:	02d76663          	bltu	a4,a3,80004146 <fileread+0xa6>
    8000411e:	0792                	sll	a5,a5,0x4
    80004120:	0002e717          	auipc	a4,0x2e
    80004124:	8d870713          	add	a4,a4,-1832 # 800319f8 <devsw>
    80004128:	97ba                	add	a5,a5,a4
    8000412a:	639c                	ld	a5,0(a5)
    8000412c:	cf99                	beqz	a5,8000414a <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    8000412e:	4505                	li	a0,1
    80004130:	9782                	jalr	a5
    80004132:	892a                	mv	s2,a0
    80004134:	b7c1                	j	800040f4 <fileread+0x54>
    panic("fileread");
    80004136:	00003517          	auipc	a0,0x3
    8000413a:	5f250513          	add	a0,a0,1522 # 80007728 <syscalls+0x298>
    8000413e:	e20fc0ef          	jal	8000075e <panic>
    return -1;
    80004142:	597d                	li	s2,-1
    80004144:	bf45                	j	800040f4 <fileread+0x54>
      return -1;
    80004146:	597d                	li	s2,-1
    80004148:	b775                	j	800040f4 <fileread+0x54>
    8000414a:	597d                	li	s2,-1
    8000414c:	b765                	j	800040f4 <fileread+0x54>

000000008000414e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000414e:	00954783          	lbu	a5,9(a0)
    80004152:	10078063          	beqz	a5,80004252 <filewrite+0x104>
{
    80004156:	715d                	add	sp,sp,-80
    80004158:	e486                	sd	ra,72(sp)
    8000415a:	e0a2                	sd	s0,64(sp)
    8000415c:	fc26                	sd	s1,56(sp)
    8000415e:	f84a                	sd	s2,48(sp)
    80004160:	f44e                	sd	s3,40(sp)
    80004162:	f052                	sd	s4,32(sp)
    80004164:	ec56                	sd	s5,24(sp)
    80004166:	e85a                	sd	s6,16(sp)
    80004168:	e45e                	sd	s7,8(sp)
    8000416a:	e062                	sd	s8,0(sp)
    8000416c:	0880                	add	s0,sp,80
    8000416e:	892a                	mv	s2,a0
    80004170:	8b2e                	mv	s6,a1
    80004172:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004174:	411c                	lw	a5,0(a0)
    80004176:	4705                	li	a4,1
    80004178:	02e78263          	beq	a5,a4,8000419c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000417c:	470d                	li	a4,3
    8000417e:	02e78363          	beq	a5,a4,800041a4 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004182:	4709                	li	a4,2
    80004184:	0ce79163          	bne	a5,a4,80004246 <filewrite+0xf8>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004188:	08c05f63          	blez	a2,80004226 <filewrite+0xd8>
    int i = 0;
    8000418c:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000418e:	6b85                	lui	s7,0x1
    80004190:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004194:	6c05                	lui	s8,0x1
    80004196:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000419a:	a8b5                	j	80004216 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    8000419c:	6908                	ld	a0,16(a0)
    8000419e:	1de000ef          	jal	8000437c <pipewrite>
    800041a2:	a071                	j	8000422e <filewrite+0xe0>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800041a4:	02451783          	lh	a5,36(a0)
    800041a8:	03079693          	sll	a3,a5,0x30
    800041ac:	92c1                	srl	a3,a3,0x30
    800041ae:	4725                	li	a4,9
    800041b0:	0ad76363          	bltu	a4,a3,80004256 <filewrite+0x108>
    800041b4:	0792                	sll	a5,a5,0x4
    800041b6:	0002e717          	auipc	a4,0x2e
    800041ba:	84270713          	add	a4,a4,-1982 # 800319f8 <devsw>
    800041be:	97ba                	add	a5,a5,a4
    800041c0:	679c                	ld	a5,8(a5)
    800041c2:	cfc1                	beqz	a5,8000425a <filewrite+0x10c>
    ret = devsw[f->major].write(1, addr, n);
    800041c4:	4505                	li	a0,1
    800041c6:	9782                	jalr	a5
    800041c8:	a09d                	j	8000422e <filewrite+0xe0>
      if(n1 > max)
    800041ca:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800041ce:	9b9ff0ef          	jal	80003b86 <begin_op>
      ilock(f->ip);
    800041d2:	01893503          	ld	a0,24(s2)
    800041d6:	942ff0ef          	jal	80003318 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800041da:	8756                	mv	a4,s5
    800041dc:	02092683          	lw	a3,32(s2)
    800041e0:	01698633          	add	a2,s3,s6
    800041e4:	4585                	li	a1,1
    800041e6:	01893503          	ld	a0,24(s2)
    800041ea:	c62ff0ef          	jal	8000364c <writei>
    800041ee:	84aa                	mv	s1,a0
    800041f0:	00a05763          	blez	a0,800041fe <filewrite+0xb0>
        f->off += r;
    800041f4:	02092783          	lw	a5,32(s2)
    800041f8:	9fa9                	addw	a5,a5,a0
    800041fa:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800041fe:	01893503          	ld	a0,24(s2)
    80004202:	9c0ff0ef          	jal	800033c2 <iunlock>
      end_op();
    80004206:	9ebff0ef          	jal	80003bf0 <end_op>

      if(r != n1){
    8000420a:	009a9f63          	bne	s5,s1,80004228 <filewrite+0xda>
        // error from writei
        break;
      }
      i += r;
    8000420e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004212:	0149db63          	bge	s3,s4,80004228 <filewrite+0xda>
      int n1 = n - i;
    80004216:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000421a:	0004879b          	sext.w	a5,s1
    8000421e:	fafbd6e3          	bge	s7,a5,800041ca <filewrite+0x7c>
    80004222:	84e2                	mv	s1,s8
    80004224:	b75d                	j	800041ca <filewrite+0x7c>
    int i = 0;
    80004226:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004228:	033a1b63          	bne	s4,s3,8000425e <filewrite+0x110>
    8000422c:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000422e:	60a6                	ld	ra,72(sp)
    80004230:	6406                	ld	s0,64(sp)
    80004232:	74e2                	ld	s1,56(sp)
    80004234:	7942                	ld	s2,48(sp)
    80004236:	79a2                	ld	s3,40(sp)
    80004238:	7a02                	ld	s4,32(sp)
    8000423a:	6ae2                	ld	s5,24(sp)
    8000423c:	6b42                	ld	s6,16(sp)
    8000423e:	6ba2                	ld	s7,8(sp)
    80004240:	6c02                	ld	s8,0(sp)
    80004242:	6161                	add	sp,sp,80
    80004244:	8082                	ret
    panic("filewrite");
    80004246:	00003517          	auipc	a0,0x3
    8000424a:	4f250513          	add	a0,a0,1266 # 80007738 <syscalls+0x2a8>
    8000424e:	d10fc0ef          	jal	8000075e <panic>
    return -1;
    80004252:	557d                	li	a0,-1
}
    80004254:	8082                	ret
      return -1;
    80004256:	557d                	li	a0,-1
    80004258:	bfd9                	j	8000422e <filewrite+0xe0>
    8000425a:	557d                	li	a0,-1
    8000425c:	bfc9                	j	8000422e <filewrite+0xe0>
    ret = (i == n ? n : -1);
    8000425e:	557d                	li	a0,-1
    80004260:	b7f9                	j	8000422e <filewrite+0xe0>

0000000080004262 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004262:	7179                	add	sp,sp,-48
    80004264:	f406                	sd	ra,40(sp)
    80004266:	f022                	sd	s0,32(sp)
    80004268:	ec26                	sd	s1,24(sp)
    8000426a:	e84a                	sd	s2,16(sp)
    8000426c:	e44e                	sd	s3,8(sp)
    8000426e:	e052                	sd	s4,0(sp)
    80004270:	1800                	add	s0,sp,48
    80004272:	84aa                	mv	s1,a0
    80004274:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004276:	0005b023          	sd	zero,0(a1)
    8000427a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000427e:	c79ff0ef          	jal	80003ef6 <filealloc>
    80004282:	e088                	sd	a0,0(s1)
    80004284:	cd35                	beqz	a0,80004300 <pipealloc+0x9e>
    80004286:	c71ff0ef          	jal	80003ef6 <filealloc>
    8000428a:	00aa3023          	sd	a0,0(s4)
    8000428e:	c52d                	beqz	a0,800042f8 <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004290:	841fc0ef          	jal	80000ad0 <kalloc>
    80004294:	892a                	mv	s2,a0
    80004296:	cd31                	beqz	a0,800042f2 <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    80004298:	4985                	li	s3,1
    8000429a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000429e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800042a2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800042a6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800042aa:	00003597          	auipc	a1,0x3
    800042ae:	49e58593          	add	a1,a1,1182 # 80007748 <syscalls+0x2b8>
    800042b2:	86ffc0ef          	jal	80000b20 <initlock>
  (*f0)->type = FD_PIPE;
    800042b6:	609c                	ld	a5,0(s1)
    800042b8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800042bc:	609c                	ld	a5,0(s1)
    800042be:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800042c2:	609c                	ld	a5,0(s1)
    800042c4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800042c8:	609c                	ld	a5,0(s1)
    800042ca:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800042ce:	000a3783          	ld	a5,0(s4)
    800042d2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800042d6:	000a3783          	ld	a5,0(s4)
    800042da:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800042de:	000a3783          	ld	a5,0(s4)
    800042e2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800042e6:	000a3783          	ld	a5,0(s4)
    800042ea:	0127b823          	sd	s2,16(a5)
  return 0;
    800042ee:	4501                	li	a0,0
    800042f0:	a005                	j	80004310 <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800042f2:	6088                	ld	a0,0(s1)
    800042f4:	e501                	bnez	a0,800042fc <pipealloc+0x9a>
    800042f6:	a029                	j	80004300 <pipealloc+0x9e>
    800042f8:	6088                	ld	a0,0(s1)
    800042fa:	c11d                	beqz	a0,80004320 <pipealloc+0xbe>
    fileclose(*f0);
    800042fc:	c9fff0ef          	jal	80003f9a <fileclose>
  if(*f1)
    80004300:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004304:	557d                	li	a0,-1
  if(*f1)
    80004306:	c789                	beqz	a5,80004310 <pipealloc+0xae>
    fileclose(*f1);
    80004308:	853e                	mv	a0,a5
    8000430a:	c91ff0ef          	jal	80003f9a <fileclose>
  return -1;
    8000430e:	557d                	li	a0,-1
}
    80004310:	70a2                	ld	ra,40(sp)
    80004312:	7402                	ld	s0,32(sp)
    80004314:	64e2                	ld	s1,24(sp)
    80004316:	6942                	ld	s2,16(sp)
    80004318:	69a2                	ld	s3,8(sp)
    8000431a:	6a02                	ld	s4,0(sp)
    8000431c:	6145                	add	sp,sp,48
    8000431e:	8082                	ret
  return -1;
    80004320:	557d                	li	a0,-1
    80004322:	b7fd                	j	80004310 <pipealloc+0xae>

0000000080004324 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004324:	1101                	add	sp,sp,-32
    80004326:	ec06                	sd	ra,24(sp)
    80004328:	e822                	sd	s0,16(sp)
    8000432a:	e426                	sd	s1,8(sp)
    8000432c:	e04a                	sd	s2,0(sp)
    8000432e:	1000                	add	s0,sp,32
    80004330:	84aa                	mv	s1,a0
    80004332:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004334:	86dfc0ef          	jal	80000ba0 <acquire>
  if(writable){
    80004338:	02090763          	beqz	s2,80004366 <pipeclose+0x42>
    pi->writeopen = 0;
    8000433c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004340:	21848513          	add	a0,s1,536
    80004344:	b45fd0ef          	jal	80001e88 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004348:	2204b783          	ld	a5,544(s1)
    8000434c:	e785                	bnez	a5,80004374 <pipeclose+0x50>
    release(&pi->lock);
    8000434e:	8526                	mv	a0,s1
    80004350:	8e9fc0ef          	jal	80000c38 <release>
    kfree((char*)pi);
    80004354:	8526                	mv	a0,s1
    80004356:	e98fc0ef          	jal	800009ee <kfree>
  } else
    release(&pi->lock);
}
    8000435a:	60e2                	ld	ra,24(sp)
    8000435c:	6442                	ld	s0,16(sp)
    8000435e:	64a2                	ld	s1,8(sp)
    80004360:	6902                	ld	s2,0(sp)
    80004362:	6105                	add	sp,sp,32
    80004364:	8082                	ret
    pi->readopen = 0;
    80004366:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000436a:	21c48513          	add	a0,s1,540
    8000436e:	b1bfd0ef          	jal	80001e88 <wakeup>
    80004372:	bfd9                	j	80004348 <pipeclose+0x24>
    release(&pi->lock);
    80004374:	8526                	mv	a0,s1
    80004376:	8c3fc0ef          	jal	80000c38 <release>
}
    8000437a:	b7c5                	j	8000435a <pipeclose+0x36>

000000008000437c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000437c:	711d                	add	sp,sp,-96
    8000437e:	ec86                	sd	ra,88(sp)
    80004380:	e8a2                	sd	s0,80(sp)
    80004382:	e4a6                	sd	s1,72(sp)
    80004384:	e0ca                	sd	s2,64(sp)
    80004386:	fc4e                	sd	s3,56(sp)
    80004388:	f852                	sd	s4,48(sp)
    8000438a:	f456                	sd	s5,40(sp)
    8000438c:	f05a                	sd	s6,32(sp)
    8000438e:	ec5e                	sd	s7,24(sp)
    80004390:	e862                	sd	s8,16(sp)
    80004392:	1080                	add	s0,sp,96
    80004394:	84aa                	mv	s1,a0
    80004396:	8aae                	mv	s5,a1
    80004398:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000439a:	c96fd0ef          	jal	80001830 <myproc>
    8000439e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800043a0:	8526                	mv	a0,s1
    800043a2:	ffefc0ef          	jal	80000ba0 <acquire>
  while(i < n){
    800043a6:	09405c63          	blez	s4,8000443e <pipewrite+0xc2>
  int i = 0;
    800043aa:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800043ac:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800043ae:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800043b2:	21c48b93          	add	s7,s1,540
    800043b6:	a81d                	j	800043ec <pipewrite+0x70>
      release(&pi->lock);
    800043b8:	8526                	mv	a0,s1
    800043ba:	87ffc0ef          	jal	80000c38 <release>
      return -1;
    800043be:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800043c0:	854a                	mv	a0,s2
    800043c2:	60e6                	ld	ra,88(sp)
    800043c4:	6446                	ld	s0,80(sp)
    800043c6:	64a6                	ld	s1,72(sp)
    800043c8:	6906                	ld	s2,64(sp)
    800043ca:	79e2                	ld	s3,56(sp)
    800043cc:	7a42                	ld	s4,48(sp)
    800043ce:	7aa2                	ld	s5,40(sp)
    800043d0:	7b02                	ld	s6,32(sp)
    800043d2:	6be2                	ld	s7,24(sp)
    800043d4:	6c42                	ld	s8,16(sp)
    800043d6:	6125                	add	sp,sp,96
    800043d8:	8082                	ret
      wakeup(&pi->nread);
    800043da:	8562                	mv	a0,s8
    800043dc:	aadfd0ef          	jal	80001e88 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800043e0:	85a6                	mv	a1,s1
    800043e2:	855e                	mv	a0,s7
    800043e4:	a59fd0ef          	jal	80001e3c <sleep>
  while(i < n){
    800043e8:	05495c63          	bge	s2,s4,80004440 <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    800043ec:	2204a783          	lw	a5,544(s1)
    800043f0:	d7e1                	beqz	a5,800043b8 <pipewrite+0x3c>
    800043f2:	854e                	mv	a0,s3
    800043f4:	c81fd0ef          	jal	80002074 <killed>
    800043f8:	f161                	bnez	a0,800043b8 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800043fa:	2184a783          	lw	a5,536(s1)
    800043fe:	21c4a703          	lw	a4,540(s1)
    80004402:	2007879b          	addw	a5,a5,512
    80004406:	fcf70ae3          	beq	a4,a5,800043da <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000440a:	4685                	li	a3,1
    8000440c:	01590633          	add	a2,s2,s5
    80004410:	faf40593          	add	a1,s0,-81
    80004414:	0509b503          	ld	a0,80(s3)
    80004418:	988fd0ef          	jal	800015a0 <copyin>
    8000441c:	03650263          	beq	a0,s6,80004440 <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004420:	21c4a783          	lw	a5,540(s1)
    80004424:	0017871b          	addw	a4,a5,1
    80004428:	20e4ae23          	sw	a4,540(s1)
    8000442c:	1ff7f793          	and	a5,a5,511
    80004430:	97a6                	add	a5,a5,s1
    80004432:	faf44703          	lbu	a4,-81(s0)
    80004436:	00e78c23          	sb	a4,24(a5)
      i++;
    8000443a:	2905                	addw	s2,s2,1
    8000443c:	b775                	j	800043e8 <pipewrite+0x6c>
  int i = 0;
    8000443e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004440:	21848513          	add	a0,s1,536
    80004444:	a45fd0ef          	jal	80001e88 <wakeup>
  release(&pi->lock);
    80004448:	8526                	mv	a0,s1
    8000444a:	feefc0ef          	jal	80000c38 <release>
  return i;
    8000444e:	bf8d                	j	800043c0 <pipewrite+0x44>

0000000080004450 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004450:	715d                	add	sp,sp,-80
    80004452:	e486                	sd	ra,72(sp)
    80004454:	e0a2                	sd	s0,64(sp)
    80004456:	fc26                	sd	s1,56(sp)
    80004458:	f84a                	sd	s2,48(sp)
    8000445a:	f44e                	sd	s3,40(sp)
    8000445c:	f052                	sd	s4,32(sp)
    8000445e:	ec56                	sd	s5,24(sp)
    80004460:	e85a                	sd	s6,16(sp)
    80004462:	0880                	add	s0,sp,80
    80004464:	84aa                	mv	s1,a0
    80004466:	892e                	mv	s2,a1
    80004468:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000446a:	bc6fd0ef          	jal	80001830 <myproc>
    8000446e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004470:	8526                	mv	a0,s1
    80004472:	f2efc0ef          	jal	80000ba0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004476:	2184a703          	lw	a4,536(s1)
    8000447a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000447e:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004482:	02f71363          	bne	a4,a5,800044a8 <piperead+0x58>
    80004486:	2244a783          	lw	a5,548(s1)
    8000448a:	cf99                	beqz	a5,800044a8 <piperead+0x58>
    if(killed(pr)){
    8000448c:	8552                	mv	a0,s4
    8000448e:	be7fd0ef          	jal	80002074 <killed>
    80004492:	e149                	bnez	a0,80004514 <piperead+0xc4>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004494:	85a6                	mv	a1,s1
    80004496:	854e                	mv	a0,s3
    80004498:	9a5fd0ef          	jal	80001e3c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000449c:	2184a703          	lw	a4,536(s1)
    800044a0:	21c4a783          	lw	a5,540(s1)
    800044a4:	fef701e3          	beq	a4,a5,80004486 <piperead+0x36>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800044a8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800044aa:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800044ac:	05505263          	blez	s5,800044f0 <piperead+0xa0>
    if(pi->nread == pi->nwrite)
    800044b0:	2184a783          	lw	a5,536(s1)
    800044b4:	21c4a703          	lw	a4,540(s1)
    800044b8:	02f70c63          	beq	a4,a5,800044f0 <piperead+0xa0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800044bc:	0017871b          	addw	a4,a5,1
    800044c0:	20e4ac23          	sw	a4,536(s1)
    800044c4:	1ff7f793          	and	a5,a5,511
    800044c8:	97a6                	add	a5,a5,s1
    800044ca:	0187c783          	lbu	a5,24(a5)
    800044ce:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800044d2:	4685                	li	a3,1
    800044d4:	fbf40613          	add	a2,s0,-65
    800044d8:	85ca                	mv	a1,s2
    800044da:	050a3503          	ld	a0,80(s4)
    800044de:	80afd0ef          	jal	800014e8 <copyout>
    800044e2:	01650763          	beq	a0,s6,800044f0 <piperead+0xa0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800044e6:	2985                	addw	s3,s3,1
    800044e8:	0905                	add	s2,s2,1
    800044ea:	fd3a93e3          	bne	s5,s3,800044b0 <piperead+0x60>
    800044ee:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800044f0:	21c48513          	add	a0,s1,540
    800044f4:	995fd0ef          	jal	80001e88 <wakeup>
  release(&pi->lock);
    800044f8:	8526                	mv	a0,s1
    800044fa:	f3efc0ef          	jal	80000c38 <release>
  return i;
}
    800044fe:	854e                	mv	a0,s3
    80004500:	60a6                	ld	ra,72(sp)
    80004502:	6406                	ld	s0,64(sp)
    80004504:	74e2                	ld	s1,56(sp)
    80004506:	7942                	ld	s2,48(sp)
    80004508:	79a2                	ld	s3,40(sp)
    8000450a:	7a02                	ld	s4,32(sp)
    8000450c:	6ae2                	ld	s5,24(sp)
    8000450e:	6b42                	ld	s6,16(sp)
    80004510:	6161                	add	sp,sp,80
    80004512:	8082                	ret
      release(&pi->lock);
    80004514:	8526                	mv	a0,s1
    80004516:	f22fc0ef          	jal	80000c38 <release>
      return -1;
    8000451a:	59fd                	li	s3,-1
    8000451c:	b7cd                	j	800044fe <piperead+0xae>

000000008000451e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000451e:	1141                	add	sp,sp,-16
    80004520:	e422                	sd	s0,8(sp)
    80004522:	0800                	add	s0,sp,16
    80004524:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004526:	8905                	and	a0,a0,1
    80004528:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000452a:	8b89                	and	a5,a5,2
    8000452c:	c399                	beqz	a5,80004532 <flags2perm+0x14>
      perm |= PTE_W;
    8000452e:	00456513          	or	a0,a0,4
    return perm;
}
    80004532:	6422                	ld	s0,8(sp)
    80004534:	0141                	add	sp,sp,16
    80004536:	8082                	ret

0000000080004538 <exec>:

int
exec(char *path, char **argv)
{
    80004538:	df010113          	add	sp,sp,-528
    8000453c:	20113423          	sd	ra,520(sp)
    80004540:	20813023          	sd	s0,512(sp)
    80004544:	ffa6                	sd	s1,504(sp)
    80004546:	fbca                	sd	s2,496(sp)
    80004548:	f7ce                	sd	s3,488(sp)
    8000454a:	f3d2                	sd	s4,480(sp)
    8000454c:	efd6                	sd	s5,472(sp)
    8000454e:	ebda                	sd	s6,464(sp)
    80004550:	e7de                	sd	s7,456(sp)
    80004552:	e3e2                	sd	s8,448(sp)
    80004554:	ff66                	sd	s9,440(sp)
    80004556:	fb6a                	sd	s10,432(sp)
    80004558:	f76e                	sd	s11,424(sp)
    8000455a:	0c00                	add	s0,sp,528
    8000455c:	892a                	mv	s2,a0
    8000455e:	dea43c23          	sd	a0,-520(s0)
    80004562:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004566:	acafd0ef          	jal	80001830 <myproc>
    8000456a:	84aa                	mv	s1,a0

  begin_op();
    8000456c:	e1aff0ef          	jal	80003b86 <begin_op>

  if((ip = namei(path)) == 0){
    80004570:	854a                	mv	a0,s2
    80004572:	c58ff0ef          	jal	800039ca <namei>
    80004576:	c12d                	beqz	a0,800045d8 <exec+0xa0>
    80004578:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000457a:	d9ffe0ef          	jal	80003318 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000457e:	04000713          	li	a4,64
    80004582:	4681                	li	a3,0
    80004584:	e5040613          	add	a2,s0,-432
    80004588:	4581                	li	a1,0
    8000458a:	8552                	mv	a0,s4
    8000458c:	fddfe0ef          	jal	80003568 <readi>
    80004590:	04000793          	li	a5,64
    80004594:	00f51a63          	bne	a0,a5,800045a8 <exec+0x70>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004598:	e5042703          	lw	a4,-432(s0)
    8000459c:	464c47b7          	lui	a5,0x464c4
    800045a0:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800045a4:	02f70e63          	beq	a4,a5,800045e0 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800045a8:	8552                	mv	a0,s4
    800045aa:	f75fe0ef          	jal	8000351e <iunlockput>
    end_op();
    800045ae:	e42ff0ef          	jal	80003bf0 <end_op>
  }
  return -1;
    800045b2:	557d                	li	a0,-1
}
    800045b4:	20813083          	ld	ra,520(sp)
    800045b8:	20013403          	ld	s0,512(sp)
    800045bc:	74fe                	ld	s1,504(sp)
    800045be:	795e                	ld	s2,496(sp)
    800045c0:	79be                	ld	s3,488(sp)
    800045c2:	7a1e                	ld	s4,480(sp)
    800045c4:	6afe                	ld	s5,472(sp)
    800045c6:	6b5e                	ld	s6,464(sp)
    800045c8:	6bbe                	ld	s7,456(sp)
    800045ca:	6c1e                	ld	s8,448(sp)
    800045cc:	7cfa                	ld	s9,440(sp)
    800045ce:	7d5a                	ld	s10,432(sp)
    800045d0:	7dba                	ld	s11,424(sp)
    800045d2:	21010113          	add	sp,sp,528
    800045d6:	8082                	ret
    end_op();
    800045d8:	e18ff0ef          	jal	80003bf0 <end_op>
    return -1;
    800045dc:	557d                	li	a0,-1
    800045de:	bfd9                	j	800045b4 <exec+0x7c>
  if((pagetable = proc_pagetable(p)) == 0)
    800045e0:	8526                	mv	a0,s1
    800045e2:	af6fd0ef          	jal	800018d8 <proc_pagetable>
    800045e6:	8b2a                	mv	s6,a0
    800045e8:	d161                	beqz	a0,800045a8 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045ea:	e7042d03          	lw	s10,-400(s0)
    800045ee:	e8845783          	lhu	a5,-376(s0)
    800045f2:	0e078863          	beqz	a5,800046e2 <exec+0x1aa>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800045f6:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045f8:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800045fa:	6c85                	lui	s9,0x1
    800045fc:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004600:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004604:	6a85                	lui	s5,0x1
    80004606:	a085                	j	80004666 <exec+0x12e>
      panic("loadseg: address should exist");
    80004608:	00003517          	auipc	a0,0x3
    8000460c:	14850513          	add	a0,a0,328 # 80007750 <syscalls+0x2c0>
    80004610:	94efc0ef          	jal	8000075e <panic>
    if(sz - i < PGSIZE)
    80004614:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004616:	8726                	mv	a4,s1
    80004618:	012c06bb          	addw	a3,s8,s2
    8000461c:	4581                	li	a1,0
    8000461e:	8552                	mv	a0,s4
    80004620:	f49fe0ef          	jal	80003568 <readi>
    80004624:	2501                	sext.w	a0,a0
    80004626:	20a49a63          	bne	s1,a0,8000483a <exec+0x302>
  for(i = 0; i < sz; i += PGSIZE){
    8000462a:	012a893b          	addw	s2,s5,s2
    8000462e:	03397363          	bgeu	s2,s3,80004654 <exec+0x11c>
    pa = walkaddr(pagetable, va + i);
    80004632:	02091593          	sll	a1,s2,0x20
    80004636:	9181                	srl	a1,a1,0x20
    80004638:	95de                	add	a1,a1,s7
    8000463a:	855a                	mv	a0,s6
    8000463c:	94dfc0ef          	jal	80000f88 <walkaddr>
    80004640:	862a                	mv	a2,a0
    if(pa == 0)
    80004642:	d179                	beqz	a0,80004608 <exec+0xd0>
    if(sz - i < PGSIZE)
    80004644:	412984bb          	subw	s1,s3,s2
    80004648:	0004879b          	sext.w	a5,s1
    8000464c:	fcfcf4e3          	bgeu	s9,a5,80004614 <exec+0xdc>
    80004650:	84d6                	mv	s1,s5
    80004652:	b7c9                	j	80004614 <exec+0xdc>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004654:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004658:	2d85                	addw	s11,s11,1
    8000465a:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    8000465e:	e8845783          	lhu	a5,-376(s0)
    80004662:	08fdd163          	bge	s11,a5,800046e4 <exec+0x1ac>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004666:	2d01                	sext.w	s10,s10
    80004668:	03800713          	li	a4,56
    8000466c:	86ea                	mv	a3,s10
    8000466e:	e1840613          	add	a2,s0,-488
    80004672:	4581                	li	a1,0
    80004674:	8552                	mv	a0,s4
    80004676:	ef3fe0ef          	jal	80003568 <readi>
    8000467a:	03800793          	li	a5,56
    8000467e:	1af51c63          	bne	a0,a5,80004836 <exec+0x2fe>
    if(ph.type != ELF_PROG_LOAD)
    80004682:	e1842783          	lw	a5,-488(s0)
    80004686:	4705                	li	a4,1
    80004688:	fce798e3          	bne	a5,a4,80004658 <exec+0x120>
    if(ph.memsz < ph.filesz)
    8000468c:	e4043483          	ld	s1,-448(s0)
    80004690:	e3843783          	ld	a5,-456(s0)
    80004694:	1af4ec63          	bltu	s1,a5,8000484c <exec+0x314>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004698:	e2843783          	ld	a5,-472(s0)
    8000469c:	94be                	add	s1,s1,a5
    8000469e:	1af4ea63          	bltu	s1,a5,80004852 <exec+0x31a>
    if(ph.vaddr % PGSIZE != 0)
    800046a2:	df043703          	ld	a4,-528(s0)
    800046a6:	8ff9                	and	a5,a5,a4
    800046a8:	1a079863          	bnez	a5,80004858 <exec+0x320>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800046ac:	e1c42503          	lw	a0,-484(s0)
    800046b0:	e6fff0ef          	jal	8000451e <flags2perm>
    800046b4:	86aa                	mv	a3,a0
    800046b6:	8626                	mv	a2,s1
    800046b8:	85ca                	mv	a1,s2
    800046ba:	855a                	mv	a0,s6
    800046bc:	c25fc0ef          	jal	800012e0 <uvmalloc>
    800046c0:	e0a43423          	sd	a0,-504(s0)
    800046c4:	18050d63          	beqz	a0,8000485e <exec+0x326>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800046c8:	e2843b83          	ld	s7,-472(s0)
    800046cc:	e2042c03          	lw	s8,-480(s0)
    800046d0:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800046d4:	00098463          	beqz	s3,800046dc <exec+0x1a4>
    800046d8:	4901                	li	s2,0
    800046da:	bfa1                	j	80004632 <exec+0xfa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800046dc:	e0843903          	ld	s2,-504(s0)
    800046e0:	bfa5                	j	80004658 <exec+0x120>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800046e2:	4901                	li	s2,0
  iunlockput(ip);
    800046e4:	8552                	mv	a0,s4
    800046e6:	e39fe0ef          	jal	8000351e <iunlockput>
  end_op();
    800046ea:	d06ff0ef          	jal	80003bf0 <end_op>
  p = myproc();
    800046ee:	942fd0ef          	jal	80001830 <myproc>
    800046f2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800046f4:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800046f8:	6985                	lui	s3,0x1
    800046fa:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    800046fc:	99ca                	add	s3,s3,s2
    800046fe:	77fd                	lui	a5,0xfffff
    80004700:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004704:	4691                	li	a3,4
    80004706:	6609                	lui	a2,0x2
    80004708:	964e                	add	a2,a2,s3
    8000470a:	85ce                	mv	a1,s3
    8000470c:	855a                	mv	a0,s6
    8000470e:	bd3fc0ef          	jal	800012e0 <uvmalloc>
    80004712:	892a                	mv	s2,a0
    80004714:	e0a43423          	sd	a0,-504(s0)
    80004718:	e509                	bnez	a0,80004722 <exec+0x1ea>
  if(pagetable)
    8000471a:	e1343423          	sd	s3,-504(s0)
    8000471e:	4a01                	li	s4,0
    80004720:	aa29                	j	8000483a <exec+0x302>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004722:	75f9                	lui	a1,0xffffe
    80004724:	95aa                	add	a1,a1,a0
    80004726:	855a                	mv	a0,s6
    80004728:	d97fc0ef          	jal	800014be <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    8000472c:	7bfd                	lui	s7,0xfffff
    8000472e:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004730:	e0043783          	ld	a5,-512(s0)
    80004734:	6388                	ld	a0,0(a5)
    80004736:	cd39                	beqz	a0,80004794 <exec+0x25c>
    80004738:	e9040993          	add	s3,s0,-368
    8000473c:	f9040c13          	add	s8,s0,-112
    80004740:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004742:	ea8fc0ef          	jal	80000dea <strlen>
    80004746:	0015079b          	addw	a5,a0,1
    8000474a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000474e:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004752:	11796963          	bltu	s2,s7,80004864 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004756:	e0043d03          	ld	s10,-512(s0)
    8000475a:	000d3a03          	ld	s4,0(s10)
    8000475e:	8552                	mv	a0,s4
    80004760:	e8afc0ef          	jal	80000dea <strlen>
    80004764:	0015069b          	addw	a3,a0,1
    80004768:	8652                	mv	a2,s4
    8000476a:	85ca                	mv	a1,s2
    8000476c:	855a                	mv	a0,s6
    8000476e:	d7bfc0ef          	jal	800014e8 <copyout>
    80004772:	0e054b63          	bltz	a0,80004868 <exec+0x330>
    ustack[argc] = sp;
    80004776:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000477a:	0485                	add	s1,s1,1
    8000477c:	008d0793          	add	a5,s10,8
    80004780:	e0f43023          	sd	a5,-512(s0)
    80004784:	008d3503          	ld	a0,8(s10)
    80004788:	c909                	beqz	a0,8000479a <exec+0x262>
    if(argc >= MAXARG)
    8000478a:	09a1                	add	s3,s3,8
    8000478c:	fb899be3          	bne	s3,s8,80004742 <exec+0x20a>
  ip = 0;
    80004790:	4a01                	li	s4,0
    80004792:	a065                	j	8000483a <exec+0x302>
  sp = sz;
    80004794:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004798:	4481                	li	s1,0
  ustack[argc] = 0;
    8000479a:	00349793          	sll	a5,s1,0x3
    8000479e:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffcc400>
    800047a2:	97a2                	add	a5,a5,s0
    800047a4:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800047a8:	00148693          	add	a3,s1,1
    800047ac:	068e                	sll	a3,a3,0x3
    800047ae:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800047b2:	ff097913          	and	s2,s2,-16
  sz = sz1;
    800047b6:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800047ba:	f77960e3          	bltu	s2,s7,8000471a <exec+0x1e2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800047be:	e9040613          	add	a2,s0,-368
    800047c2:	85ca                	mv	a1,s2
    800047c4:	855a                	mv	a0,s6
    800047c6:	d23fc0ef          	jal	800014e8 <copyout>
    800047ca:	0a054163          	bltz	a0,8000486c <exec+0x334>
  p->trapframe->a1 = sp;
    800047ce:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800047d2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800047d6:	df843783          	ld	a5,-520(s0)
    800047da:	0007c703          	lbu	a4,0(a5)
    800047de:	cf11                	beqz	a4,800047fa <exec+0x2c2>
    800047e0:	0785                	add	a5,a5,1
    if(*s == '/')
    800047e2:	02f00693          	li	a3,47
    800047e6:	a039                	j	800047f4 <exec+0x2bc>
      last = s+1;
    800047e8:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800047ec:	0785                	add	a5,a5,1
    800047ee:	fff7c703          	lbu	a4,-1(a5)
    800047f2:	c701                	beqz	a4,800047fa <exec+0x2c2>
    if(*s == '/')
    800047f4:	fed71ce3          	bne	a4,a3,800047ec <exec+0x2b4>
    800047f8:	bfc5                	j	800047e8 <exec+0x2b0>
  safestrcpy(p->name, last, sizeof(p->name));
    800047fa:	4641                	li	a2,16
    800047fc:	df843583          	ld	a1,-520(s0)
    80004800:	158a8513          	add	a0,s5,344
    80004804:	db4fc0ef          	jal	80000db8 <safestrcpy>
  oldpagetable = p->pagetable;
    80004808:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000480c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004810:	e0843783          	ld	a5,-504(s0)
    80004814:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004818:	058ab783          	ld	a5,88(s5)
    8000481c:	e6843703          	ld	a4,-408(s0)
    80004820:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004822:	058ab783          	ld	a5,88(s5)
    80004826:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000482a:	85e6                	mv	a1,s9
    8000482c:	930fd0ef          	jal	8000195c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004830:	0004851b          	sext.w	a0,s1
    80004834:	b341                	j	800045b4 <exec+0x7c>
    80004836:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000483a:	e0843583          	ld	a1,-504(s0)
    8000483e:	855a                	mv	a0,s6
    80004840:	91cfd0ef          	jal	8000195c <proc_freepagetable>
  return -1;
    80004844:	557d                	li	a0,-1
  if(ip){
    80004846:	d60a07e3          	beqz	s4,800045b4 <exec+0x7c>
    8000484a:	bbb9                	j	800045a8 <exec+0x70>
    8000484c:	e1243423          	sd	s2,-504(s0)
    80004850:	b7ed                	j	8000483a <exec+0x302>
    80004852:	e1243423          	sd	s2,-504(s0)
    80004856:	b7d5                	j	8000483a <exec+0x302>
    80004858:	e1243423          	sd	s2,-504(s0)
    8000485c:	bff9                	j	8000483a <exec+0x302>
    8000485e:	e1243423          	sd	s2,-504(s0)
    80004862:	bfe1                	j	8000483a <exec+0x302>
  ip = 0;
    80004864:	4a01                	li	s4,0
    80004866:	bfd1                	j	8000483a <exec+0x302>
    80004868:	4a01                	li	s4,0
  if(pagetable)
    8000486a:	bfc1                	j	8000483a <exec+0x302>
  sz = sz1;
    8000486c:	e0843983          	ld	s3,-504(s0)
    80004870:	b56d                	j	8000471a <exec+0x1e2>

0000000080004872 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004872:	7179                	add	sp,sp,-48
    80004874:	f406                	sd	ra,40(sp)
    80004876:	f022                	sd	s0,32(sp)
    80004878:	ec26                	sd	s1,24(sp)
    8000487a:	e84a                	sd	s2,16(sp)
    8000487c:	1800                	add	s0,sp,48
    8000487e:	892e                	mv	s2,a1
    80004880:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004882:	fdc40593          	add	a1,s0,-36
    80004886:	88efe0ef          	jal	80002914 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000488a:	fdc42703          	lw	a4,-36(s0)
    8000488e:	47bd                	li	a5,15
    80004890:	02e7e963          	bltu	a5,a4,800048c2 <argfd+0x50>
    80004894:	f9dfc0ef          	jal	80001830 <myproc>
    80004898:	fdc42703          	lw	a4,-36(s0)
    8000489c:	01a70793          	add	a5,a4,26
    800048a0:	078e                	sll	a5,a5,0x3
    800048a2:	953e                	add	a0,a0,a5
    800048a4:	611c                	ld	a5,0(a0)
    800048a6:	c385                	beqz	a5,800048c6 <argfd+0x54>
    return -1;
  if(pfd)
    800048a8:	00090463          	beqz	s2,800048b0 <argfd+0x3e>
    *pfd = fd;
    800048ac:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800048b0:	4501                	li	a0,0
  if(pf)
    800048b2:	c091                	beqz	s1,800048b6 <argfd+0x44>
    *pf = f;
    800048b4:	e09c                	sd	a5,0(s1)
}
    800048b6:	70a2                	ld	ra,40(sp)
    800048b8:	7402                	ld	s0,32(sp)
    800048ba:	64e2                	ld	s1,24(sp)
    800048bc:	6942                	ld	s2,16(sp)
    800048be:	6145                	add	sp,sp,48
    800048c0:	8082                	ret
    return -1;
    800048c2:	557d                	li	a0,-1
    800048c4:	bfcd                	j	800048b6 <argfd+0x44>
    800048c6:	557d                	li	a0,-1
    800048c8:	b7fd                	j	800048b6 <argfd+0x44>

00000000800048ca <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800048ca:	1101                	add	sp,sp,-32
    800048cc:	ec06                	sd	ra,24(sp)
    800048ce:	e822                	sd	s0,16(sp)
    800048d0:	e426                	sd	s1,8(sp)
    800048d2:	1000                	add	s0,sp,32
    800048d4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800048d6:	f5bfc0ef          	jal	80001830 <myproc>
    800048da:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800048dc:	0d050793          	add	a5,a0,208
    800048e0:	4501                	li	a0,0
    800048e2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800048e4:	6398                	ld	a4,0(a5)
    800048e6:	cb19                	beqz	a4,800048fc <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800048e8:	2505                	addw	a0,a0,1
    800048ea:	07a1                	add	a5,a5,8
    800048ec:	fed51ce3          	bne	a0,a3,800048e4 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800048f0:	557d                	li	a0,-1
}
    800048f2:	60e2                	ld	ra,24(sp)
    800048f4:	6442                	ld	s0,16(sp)
    800048f6:	64a2                	ld	s1,8(sp)
    800048f8:	6105                	add	sp,sp,32
    800048fa:	8082                	ret
      p->ofile[fd] = f;
    800048fc:	01a50793          	add	a5,a0,26
    80004900:	078e                	sll	a5,a5,0x3
    80004902:	963e                	add	a2,a2,a5
    80004904:	e204                	sd	s1,0(a2)
      return fd;
    80004906:	b7f5                	j	800048f2 <fdalloc+0x28>

0000000080004908 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004908:	715d                	add	sp,sp,-80
    8000490a:	e486                	sd	ra,72(sp)
    8000490c:	e0a2                	sd	s0,64(sp)
    8000490e:	fc26                	sd	s1,56(sp)
    80004910:	f84a                	sd	s2,48(sp)
    80004912:	f44e                	sd	s3,40(sp)
    80004914:	f052                	sd	s4,32(sp)
    80004916:	ec56                	sd	s5,24(sp)
    80004918:	e85a                	sd	s6,16(sp)
    8000491a:	0880                	add	s0,sp,80
    8000491c:	8b2e                	mv	s6,a1
    8000491e:	89b2                	mv	s3,a2
    80004920:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004922:	fb040593          	add	a1,s0,-80
    80004926:	8beff0ef          	jal	800039e4 <nameiparent>
    8000492a:	84aa                	mv	s1,a0
    8000492c:	10050763          	beqz	a0,80004a3a <create+0x132>
    return 0;

  ilock(dp);
    80004930:	9e9fe0ef          	jal	80003318 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004934:	4601                	li	a2,0
    80004936:	fb040593          	add	a1,s0,-80
    8000493a:	8526                	mv	a0,s1
    8000493c:	e29fe0ef          	jal	80003764 <dirlookup>
    80004940:	8aaa                	mv	s5,a0
    80004942:	c131                	beqz	a0,80004986 <create+0x7e>
    iunlockput(dp);
    80004944:	8526                	mv	a0,s1
    80004946:	bd9fe0ef          	jal	8000351e <iunlockput>
    ilock(ip);
    8000494a:	8556                	mv	a0,s5
    8000494c:	9cdfe0ef          	jal	80003318 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004950:	4789                	li	a5,2
    80004952:	02fb1563          	bne	s6,a5,8000497c <create+0x74>
    80004956:	044ad783          	lhu	a5,68(s5)
    8000495a:	37f9                	addw	a5,a5,-2
    8000495c:	17c2                	sll	a5,a5,0x30
    8000495e:	93c1                	srl	a5,a5,0x30
    80004960:	4705                	li	a4,1
    80004962:	00f76d63          	bltu	a4,a5,8000497c <create+0x74>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004966:	8556                	mv	a0,s5
    80004968:	60a6                	ld	ra,72(sp)
    8000496a:	6406                	ld	s0,64(sp)
    8000496c:	74e2                	ld	s1,56(sp)
    8000496e:	7942                	ld	s2,48(sp)
    80004970:	79a2                	ld	s3,40(sp)
    80004972:	7a02                	ld	s4,32(sp)
    80004974:	6ae2                	ld	s5,24(sp)
    80004976:	6b42                	ld	s6,16(sp)
    80004978:	6161                	add	sp,sp,80
    8000497a:	8082                	ret
    iunlockput(ip);
    8000497c:	8556                	mv	a0,s5
    8000497e:	ba1fe0ef          	jal	8000351e <iunlockput>
    return 0;
    80004982:	4a81                	li	s5,0
    80004984:	b7cd                	j	80004966 <create+0x5e>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004986:	85da                	mv	a1,s6
    80004988:	4088                	lw	a0,0(s1)
    8000498a:	82bfe0ef          	jal	800031b4 <ialloc>
    8000498e:	8a2a                	mv	s4,a0
    80004990:	cd0d                	beqz	a0,800049ca <create+0xc2>
  ilock(ip);
    80004992:	987fe0ef          	jal	80003318 <ilock>
  ip->major = major;
    80004996:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000499a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000499e:	4905                	li	s2,1
    800049a0:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800049a4:	8552                	mv	a0,s4
    800049a6:	8bffe0ef          	jal	80003264 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800049aa:	032b0563          	beq	s6,s2,800049d4 <create+0xcc>
  if(dirlink(dp, name, ip->inum) < 0)
    800049ae:	004a2603          	lw	a2,4(s4)
    800049b2:	fb040593          	add	a1,s0,-80
    800049b6:	8526                	mv	a0,s1
    800049b8:	f79fe0ef          	jal	80003930 <dirlink>
    800049bc:	06054363          	bltz	a0,80004a22 <create+0x11a>
  iunlockput(dp);
    800049c0:	8526                	mv	a0,s1
    800049c2:	b5dfe0ef          	jal	8000351e <iunlockput>
  return ip;
    800049c6:	8ad2                	mv	s5,s4
    800049c8:	bf79                	j	80004966 <create+0x5e>
    iunlockput(dp);
    800049ca:	8526                	mv	a0,s1
    800049cc:	b53fe0ef          	jal	8000351e <iunlockput>
    return 0;
    800049d0:	8ad2                	mv	s5,s4
    800049d2:	bf51                	j	80004966 <create+0x5e>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800049d4:	004a2603          	lw	a2,4(s4)
    800049d8:	00003597          	auipc	a1,0x3
    800049dc:	d9858593          	add	a1,a1,-616 # 80007770 <syscalls+0x2e0>
    800049e0:	8552                	mv	a0,s4
    800049e2:	f4ffe0ef          	jal	80003930 <dirlink>
    800049e6:	02054e63          	bltz	a0,80004a22 <create+0x11a>
    800049ea:	40d0                	lw	a2,4(s1)
    800049ec:	00003597          	auipc	a1,0x3
    800049f0:	d8c58593          	add	a1,a1,-628 # 80007778 <syscalls+0x2e8>
    800049f4:	8552                	mv	a0,s4
    800049f6:	f3bfe0ef          	jal	80003930 <dirlink>
    800049fa:	02054463          	bltz	a0,80004a22 <create+0x11a>
  if(dirlink(dp, name, ip->inum) < 0)
    800049fe:	004a2603          	lw	a2,4(s4)
    80004a02:	fb040593          	add	a1,s0,-80
    80004a06:	8526                	mv	a0,s1
    80004a08:	f29fe0ef          	jal	80003930 <dirlink>
    80004a0c:	00054b63          	bltz	a0,80004a22 <create+0x11a>
    dp->nlink++;  // for ".."
    80004a10:	04a4d783          	lhu	a5,74(s1)
    80004a14:	2785                	addw	a5,a5,1
    80004a16:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	849fe0ef          	jal	80003264 <iupdate>
    80004a20:	b745                	j	800049c0 <create+0xb8>
  ip->nlink = 0;
    80004a22:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004a26:	8552                	mv	a0,s4
    80004a28:	83dfe0ef          	jal	80003264 <iupdate>
  iunlockput(ip);
    80004a2c:	8552                	mv	a0,s4
    80004a2e:	af1fe0ef          	jal	8000351e <iunlockput>
  iunlockput(dp);
    80004a32:	8526                	mv	a0,s1
    80004a34:	aebfe0ef          	jal	8000351e <iunlockput>
  return 0;
    80004a38:	b73d                	j	80004966 <create+0x5e>
    return 0;
    80004a3a:	8aaa                	mv	s5,a0
    80004a3c:	b72d                	j	80004966 <create+0x5e>

0000000080004a3e <sys_dup>:
{
    80004a3e:	7179                	add	sp,sp,-48
    80004a40:	f406                	sd	ra,40(sp)
    80004a42:	f022                	sd	s0,32(sp)
    80004a44:	ec26                	sd	s1,24(sp)
    80004a46:	e84a                	sd	s2,16(sp)
    80004a48:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004a4a:	fd840613          	add	a2,s0,-40
    80004a4e:	4581                	li	a1,0
    80004a50:	4501                	li	a0,0
    80004a52:	e21ff0ef          	jal	80004872 <argfd>
    return -1;
    80004a56:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004a58:	00054f63          	bltz	a0,80004a76 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
    80004a5c:	fd843903          	ld	s2,-40(s0)
    80004a60:	854a                	mv	a0,s2
    80004a62:	e69ff0ef          	jal	800048ca <fdalloc>
    80004a66:	84aa                	mv	s1,a0
    return -1;
    80004a68:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004a6a:	00054663          	bltz	a0,80004a76 <sys_dup+0x38>
  filedup(f);
    80004a6e:	854a                	mv	a0,s2
    80004a70:	ce4ff0ef          	jal	80003f54 <filedup>
  return fd;
    80004a74:	87a6                	mv	a5,s1
}
    80004a76:	853e                	mv	a0,a5
    80004a78:	70a2                	ld	ra,40(sp)
    80004a7a:	7402                	ld	s0,32(sp)
    80004a7c:	64e2                	ld	s1,24(sp)
    80004a7e:	6942                	ld	s2,16(sp)
    80004a80:	6145                	add	sp,sp,48
    80004a82:	8082                	ret

0000000080004a84 <sys_read>:
{
    80004a84:	7179                	add	sp,sp,-48
    80004a86:	f406                	sd	ra,40(sp)
    80004a88:	f022                	sd	s0,32(sp)
    80004a8a:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004a8c:	fd840593          	add	a1,s0,-40
    80004a90:	4505                	li	a0,1
    80004a92:	e9ffd0ef          	jal	80002930 <argaddr>
  argint(2, &n);
    80004a96:	fe440593          	add	a1,s0,-28
    80004a9a:	4509                	li	a0,2
    80004a9c:	e79fd0ef          	jal	80002914 <argint>
  if(argfd(0, 0, &f) < 0)
    80004aa0:	fe840613          	add	a2,s0,-24
    80004aa4:	4581                	li	a1,0
    80004aa6:	4501                	li	a0,0
    80004aa8:	dcbff0ef          	jal	80004872 <argfd>
    80004aac:	87aa                	mv	a5,a0
    return -1;
    80004aae:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004ab0:	0007ca63          	bltz	a5,80004ac4 <sys_read+0x40>
  return fileread(f, p, n);
    80004ab4:	fe442603          	lw	a2,-28(s0)
    80004ab8:	fd843583          	ld	a1,-40(s0)
    80004abc:	fe843503          	ld	a0,-24(s0)
    80004ac0:	de0ff0ef          	jal	800040a0 <fileread>
}
    80004ac4:	70a2                	ld	ra,40(sp)
    80004ac6:	7402                	ld	s0,32(sp)
    80004ac8:	6145                	add	sp,sp,48
    80004aca:	8082                	ret

0000000080004acc <sys_write>:
{
    80004acc:	7179                	add	sp,sp,-48
    80004ace:	f406                	sd	ra,40(sp)
    80004ad0:	f022                	sd	s0,32(sp)
    80004ad2:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004ad4:	fd840593          	add	a1,s0,-40
    80004ad8:	4505                	li	a0,1
    80004ada:	e57fd0ef          	jal	80002930 <argaddr>
  argint(2, &n);
    80004ade:	fe440593          	add	a1,s0,-28
    80004ae2:	4509                	li	a0,2
    80004ae4:	e31fd0ef          	jal	80002914 <argint>
  if(argfd(0, 0, &f) < 0)
    80004ae8:	fe840613          	add	a2,s0,-24
    80004aec:	4581                	li	a1,0
    80004aee:	4501                	li	a0,0
    80004af0:	d83ff0ef          	jal	80004872 <argfd>
    80004af4:	87aa                	mv	a5,a0
    return -1;
    80004af6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004af8:	0007ca63          	bltz	a5,80004b0c <sys_write+0x40>
  return filewrite(f, p, n);
    80004afc:	fe442603          	lw	a2,-28(s0)
    80004b00:	fd843583          	ld	a1,-40(s0)
    80004b04:	fe843503          	ld	a0,-24(s0)
    80004b08:	e46ff0ef          	jal	8000414e <filewrite>
}
    80004b0c:	70a2                	ld	ra,40(sp)
    80004b0e:	7402                	ld	s0,32(sp)
    80004b10:	6145                	add	sp,sp,48
    80004b12:	8082                	ret

0000000080004b14 <sys_close>:
{
    80004b14:	1101                	add	sp,sp,-32
    80004b16:	ec06                	sd	ra,24(sp)
    80004b18:	e822                	sd	s0,16(sp)
    80004b1a:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004b1c:	fe040613          	add	a2,s0,-32
    80004b20:	fec40593          	add	a1,s0,-20
    80004b24:	4501                	li	a0,0
    80004b26:	d4dff0ef          	jal	80004872 <argfd>
    return -1;
    80004b2a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004b2c:	02054063          	bltz	a0,80004b4c <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004b30:	d01fc0ef          	jal	80001830 <myproc>
    80004b34:	fec42783          	lw	a5,-20(s0)
    80004b38:	07e9                	add	a5,a5,26
    80004b3a:	078e                	sll	a5,a5,0x3
    80004b3c:	953e                	add	a0,a0,a5
    80004b3e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004b42:	fe043503          	ld	a0,-32(s0)
    80004b46:	c54ff0ef          	jal	80003f9a <fileclose>
  return 0;
    80004b4a:	4781                	li	a5,0
}
    80004b4c:	853e                	mv	a0,a5
    80004b4e:	60e2                	ld	ra,24(sp)
    80004b50:	6442                	ld	s0,16(sp)
    80004b52:	6105                	add	sp,sp,32
    80004b54:	8082                	ret

0000000080004b56 <sys_fstat>:
{
    80004b56:	1101                	add	sp,sp,-32
    80004b58:	ec06                	sd	ra,24(sp)
    80004b5a:	e822                	sd	s0,16(sp)
    80004b5c:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80004b5e:	fe040593          	add	a1,s0,-32
    80004b62:	4505                	li	a0,1
    80004b64:	dcdfd0ef          	jal	80002930 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004b68:	fe840613          	add	a2,s0,-24
    80004b6c:	4581                	li	a1,0
    80004b6e:	4501                	li	a0,0
    80004b70:	d03ff0ef          	jal	80004872 <argfd>
    80004b74:	87aa                	mv	a5,a0
    return -1;
    80004b76:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b78:	0007c863          	bltz	a5,80004b88 <sys_fstat+0x32>
  return filestat(f, st);
    80004b7c:	fe043583          	ld	a1,-32(s0)
    80004b80:	fe843503          	ld	a0,-24(s0)
    80004b84:	cbeff0ef          	jal	80004042 <filestat>
}
    80004b88:	60e2                	ld	ra,24(sp)
    80004b8a:	6442                	ld	s0,16(sp)
    80004b8c:	6105                	add	sp,sp,32
    80004b8e:	8082                	ret

0000000080004b90 <sys_link>:
{
    80004b90:	7169                	add	sp,sp,-304
    80004b92:	f606                	sd	ra,296(sp)
    80004b94:	f222                	sd	s0,288(sp)
    80004b96:	ee26                	sd	s1,280(sp)
    80004b98:	ea4a                	sd	s2,272(sp)
    80004b9a:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b9c:	08000613          	li	a2,128
    80004ba0:	ed040593          	add	a1,s0,-304
    80004ba4:	4501                	li	a0,0
    80004ba6:	da7fd0ef          	jal	8000294c <argstr>
    return -1;
    80004baa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004bac:	0c054663          	bltz	a0,80004c78 <sys_link+0xe8>
    80004bb0:	08000613          	li	a2,128
    80004bb4:	f5040593          	add	a1,s0,-176
    80004bb8:	4505                	li	a0,1
    80004bba:	d93fd0ef          	jal	8000294c <argstr>
    return -1;
    80004bbe:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004bc0:	0a054c63          	bltz	a0,80004c78 <sys_link+0xe8>
  begin_op();
    80004bc4:	fc3fe0ef          	jal	80003b86 <begin_op>
  if((ip = namei(old)) == 0){
    80004bc8:	ed040513          	add	a0,s0,-304
    80004bcc:	dfffe0ef          	jal	800039ca <namei>
    80004bd0:	84aa                	mv	s1,a0
    80004bd2:	c525                	beqz	a0,80004c3a <sys_link+0xaa>
  ilock(ip);
    80004bd4:	f44fe0ef          	jal	80003318 <ilock>
  if(ip->type == T_DIR){
    80004bd8:	04449703          	lh	a4,68(s1)
    80004bdc:	4785                	li	a5,1
    80004bde:	06f70263          	beq	a4,a5,80004c42 <sys_link+0xb2>
  ip->nlink++;
    80004be2:	04a4d783          	lhu	a5,74(s1)
    80004be6:	2785                	addw	a5,a5,1
    80004be8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004bec:	8526                	mv	a0,s1
    80004bee:	e76fe0ef          	jal	80003264 <iupdate>
  iunlock(ip);
    80004bf2:	8526                	mv	a0,s1
    80004bf4:	fcefe0ef          	jal	800033c2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004bf8:	fd040593          	add	a1,s0,-48
    80004bfc:	f5040513          	add	a0,s0,-176
    80004c00:	de5fe0ef          	jal	800039e4 <nameiparent>
    80004c04:	892a                	mv	s2,a0
    80004c06:	c921                	beqz	a0,80004c56 <sys_link+0xc6>
  ilock(dp);
    80004c08:	f10fe0ef          	jal	80003318 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004c0c:	00092703          	lw	a4,0(s2)
    80004c10:	409c                	lw	a5,0(s1)
    80004c12:	02f71f63          	bne	a4,a5,80004c50 <sys_link+0xc0>
    80004c16:	40d0                	lw	a2,4(s1)
    80004c18:	fd040593          	add	a1,s0,-48
    80004c1c:	854a                	mv	a0,s2
    80004c1e:	d13fe0ef          	jal	80003930 <dirlink>
    80004c22:	02054763          	bltz	a0,80004c50 <sys_link+0xc0>
  iunlockput(dp);
    80004c26:	854a                	mv	a0,s2
    80004c28:	8f7fe0ef          	jal	8000351e <iunlockput>
  iput(ip);
    80004c2c:	8526                	mv	a0,s1
    80004c2e:	869fe0ef          	jal	80003496 <iput>
  end_op();
    80004c32:	fbffe0ef          	jal	80003bf0 <end_op>
  return 0;
    80004c36:	4781                	li	a5,0
    80004c38:	a081                	j	80004c78 <sys_link+0xe8>
    end_op();
    80004c3a:	fb7fe0ef          	jal	80003bf0 <end_op>
    return -1;
    80004c3e:	57fd                	li	a5,-1
    80004c40:	a825                	j	80004c78 <sys_link+0xe8>
    iunlockput(ip);
    80004c42:	8526                	mv	a0,s1
    80004c44:	8dbfe0ef          	jal	8000351e <iunlockput>
    end_op();
    80004c48:	fa9fe0ef          	jal	80003bf0 <end_op>
    return -1;
    80004c4c:	57fd                	li	a5,-1
    80004c4e:	a02d                	j	80004c78 <sys_link+0xe8>
    iunlockput(dp);
    80004c50:	854a                	mv	a0,s2
    80004c52:	8cdfe0ef          	jal	8000351e <iunlockput>
  ilock(ip);
    80004c56:	8526                	mv	a0,s1
    80004c58:	ec0fe0ef          	jal	80003318 <ilock>
  ip->nlink--;
    80004c5c:	04a4d783          	lhu	a5,74(s1)
    80004c60:	37fd                	addw	a5,a5,-1
    80004c62:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c66:	8526                	mv	a0,s1
    80004c68:	dfcfe0ef          	jal	80003264 <iupdate>
  iunlockput(ip);
    80004c6c:	8526                	mv	a0,s1
    80004c6e:	8b1fe0ef          	jal	8000351e <iunlockput>
  end_op();
    80004c72:	f7ffe0ef          	jal	80003bf0 <end_op>
  return -1;
    80004c76:	57fd                	li	a5,-1
}
    80004c78:	853e                	mv	a0,a5
    80004c7a:	70b2                	ld	ra,296(sp)
    80004c7c:	7412                	ld	s0,288(sp)
    80004c7e:	64f2                	ld	s1,280(sp)
    80004c80:	6952                	ld	s2,272(sp)
    80004c82:	6155                	add	sp,sp,304
    80004c84:	8082                	ret

0000000080004c86 <sys_unlink>:
{
    80004c86:	7151                	add	sp,sp,-240
    80004c88:	f586                	sd	ra,232(sp)
    80004c8a:	f1a2                	sd	s0,224(sp)
    80004c8c:	eda6                	sd	s1,216(sp)
    80004c8e:	e9ca                	sd	s2,208(sp)
    80004c90:	e5ce                	sd	s3,200(sp)
    80004c92:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c94:	08000613          	li	a2,128
    80004c98:	f3040593          	add	a1,s0,-208
    80004c9c:	4501                	li	a0,0
    80004c9e:	caffd0ef          	jal	8000294c <argstr>
    80004ca2:	12054b63          	bltz	a0,80004dd8 <sys_unlink+0x152>
  begin_op();
    80004ca6:	ee1fe0ef          	jal	80003b86 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004caa:	fb040593          	add	a1,s0,-80
    80004cae:	f3040513          	add	a0,s0,-208
    80004cb2:	d33fe0ef          	jal	800039e4 <nameiparent>
    80004cb6:	84aa                	mv	s1,a0
    80004cb8:	c54d                	beqz	a0,80004d62 <sys_unlink+0xdc>
  ilock(dp);
    80004cba:	e5efe0ef          	jal	80003318 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004cbe:	00003597          	auipc	a1,0x3
    80004cc2:	ab258593          	add	a1,a1,-1358 # 80007770 <syscalls+0x2e0>
    80004cc6:	fb040513          	add	a0,s0,-80
    80004cca:	a85fe0ef          	jal	8000374e <namecmp>
    80004cce:	10050a63          	beqz	a0,80004de2 <sys_unlink+0x15c>
    80004cd2:	00003597          	auipc	a1,0x3
    80004cd6:	aa658593          	add	a1,a1,-1370 # 80007778 <syscalls+0x2e8>
    80004cda:	fb040513          	add	a0,s0,-80
    80004cde:	a71fe0ef          	jal	8000374e <namecmp>
    80004ce2:	10050063          	beqz	a0,80004de2 <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ce6:	f2c40613          	add	a2,s0,-212
    80004cea:	fb040593          	add	a1,s0,-80
    80004cee:	8526                	mv	a0,s1
    80004cf0:	a75fe0ef          	jal	80003764 <dirlookup>
    80004cf4:	892a                	mv	s2,a0
    80004cf6:	0e050663          	beqz	a0,80004de2 <sys_unlink+0x15c>
  ilock(ip);
    80004cfa:	e1efe0ef          	jal	80003318 <ilock>
  if(ip->nlink < 1)
    80004cfe:	04a91783          	lh	a5,74(s2)
    80004d02:	06f05463          	blez	a5,80004d6a <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d06:	04491703          	lh	a4,68(s2)
    80004d0a:	4785                	li	a5,1
    80004d0c:	06f70563          	beq	a4,a5,80004d76 <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004d10:	4641                	li	a2,16
    80004d12:	4581                	li	a1,0
    80004d14:	fc040513          	add	a0,s0,-64
    80004d18:	f5dfb0ef          	jal	80000c74 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d1c:	4741                	li	a4,16
    80004d1e:	f2c42683          	lw	a3,-212(s0)
    80004d22:	fc040613          	add	a2,s0,-64
    80004d26:	4581                	li	a1,0
    80004d28:	8526                	mv	a0,s1
    80004d2a:	923fe0ef          	jal	8000364c <writei>
    80004d2e:	47c1                	li	a5,16
    80004d30:	08f51563          	bne	a0,a5,80004dba <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004d34:	04491703          	lh	a4,68(s2)
    80004d38:	4785                	li	a5,1
    80004d3a:	08f70663          	beq	a4,a5,80004dc6 <sys_unlink+0x140>
  iunlockput(dp);
    80004d3e:	8526                	mv	a0,s1
    80004d40:	fdefe0ef          	jal	8000351e <iunlockput>
  ip->nlink--;
    80004d44:	04a95783          	lhu	a5,74(s2)
    80004d48:	37fd                	addw	a5,a5,-1
    80004d4a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004d4e:	854a                	mv	a0,s2
    80004d50:	d14fe0ef          	jal	80003264 <iupdate>
  iunlockput(ip);
    80004d54:	854a                	mv	a0,s2
    80004d56:	fc8fe0ef          	jal	8000351e <iunlockput>
  end_op();
    80004d5a:	e97fe0ef          	jal	80003bf0 <end_op>
  return 0;
    80004d5e:	4501                	li	a0,0
    80004d60:	a079                	j	80004dee <sys_unlink+0x168>
    end_op();
    80004d62:	e8ffe0ef          	jal	80003bf0 <end_op>
    return -1;
    80004d66:	557d                	li	a0,-1
    80004d68:	a059                	j	80004dee <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004d6a:	00003517          	auipc	a0,0x3
    80004d6e:	a1650513          	add	a0,a0,-1514 # 80007780 <syscalls+0x2f0>
    80004d72:	9edfb0ef          	jal	8000075e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d76:	04c92703          	lw	a4,76(s2)
    80004d7a:	02000793          	li	a5,32
    80004d7e:	f8e7f9e3          	bgeu	a5,a4,80004d10 <sys_unlink+0x8a>
    80004d82:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d86:	4741                	li	a4,16
    80004d88:	86ce                	mv	a3,s3
    80004d8a:	f1840613          	add	a2,s0,-232
    80004d8e:	4581                	li	a1,0
    80004d90:	854a                	mv	a0,s2
    80004d92:	fd6fe0ef          	jal	80003568 <readi>
    80004d96:	47c1                	li	a5,16
    80004d98:	00f51b63          	bne	a0,a5,80004dae <sys_unlink+0x128>
    if(de.inum != 0)
    80004d9c:	f1845783          	lhu	a5,-232(s0)
    80004da0:	ef95                	bnez	a5,80004ddc <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004da2:	29c1                	addw	s3,s3,16
    80004da4:	04c92783          	lw	a5,76(s2)
    80004da8:	fcf9efe3          	bltu	s3,a5,80004d86 <sys_unlink+0x100>
    80004dac:	b795                	j	80004d10 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004dae:	00003517          	auipc	a0,0x3
    80004db2:	9ea50513          	add	a0,a0,-1558 # 80007798 <syscalls+0x308>
    80004db6:	9a9fb0ef          	jal	8000075e <panic>
    panic("unlink: writei");
    80004dba:	00003517          	auipc	a0,0x3
    80004dbe:	9f650513          	add	a0,a0,-1546 # 800077b0 <syscalls+0x320>
    80004dc2:	99dfb0ef          	jal	8000075e <panic>
    dp->nlink--;
    80004dc6:	04a4d783          	lhu	a5,74(s1)
    80004dca:	37fd                	addw	a5,a5,-1
    80004dcc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004dd0:	8526                	mv	a0,s1
    80004dd2:	c92fe0ef          	jal	80003264 <iupdate>
    80004dd6:	b7a5                	j	80004d3e <sys_unlink+0xb8>
    return -1;
    80004dd8:	557d                	li	a0,-1
    80004dda:	a811                	j	80004dee <sys_unlink+0x168>
    iunlockput(ip);
    80004ddc:	854a                	mv	a0,s2
    80004dde:	f40fe0ef          	jal	8000351e <iunlockput>
  iunlockput(dp);
    80004de2:	8526                	mv	a0,s1
    80004de4:	f3afe0ef          	jal	8000351e <iunlockput>
  end_op();
    80004de8:	e09fe0ef          	jal	80003bf0 <end_op>
  return -1;
    80004dec:	557d                	li	a0,-1
}
    80004dee:	70ae                	ld	ra,232(sp)
    80004df0:	740e                	ld	s0,224(sp)
    80004df2:	64ee                	ld	s1,216(sp)
    80004df4:	694e                	ld	s2,208(sp)
    80004df6:	69ae                	ld	s3,200(sp)
    80004df8:	616d                	add	sp,sp,240
    80004dfa:	8082                	ret

0000000080004dfc <sys_open>:

uint64
sys_open(void)
{
    80004dfc:	7131                	add	sp,sp,-192
    80004dfe:	fd06                	sd	ra,184(sp)
    80004e00:	f922                	sd	s0,176(sp)
    80004e02:	f526                	sd	s1,168(sp)
    80004e04:	f14a                	sd	s2,160(sp)
    80004e06:	ed4e                	sd	s3,152(sp)
    80004e08:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004e0a:	f4c40593          	add	a1,s0,-180
    80004e0e:	4505                	li	a0,1
    80004e10:	b05fd0ef          	jal	80002914 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004e14:	08000613          	li	a2,128
    80004e18:	f5040593          	add	a1,s0,-176
    80004e1c:	4501                	li	a0,0
    80004e1e:	b2ffd0ef          	jal	8000294c <argstr>
    80004e22:	87aa                	mv	a5,a0
    return -1;
    80004e24:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004e26:	0807cc63          	bltz	a5,80004ebe <sys_open+0xc2>

  begin_op();
    80004e2a:	d5dfe0ef          	jal	80003b86 <begin_op>

  if(omode & O_CREATE){
    80004e2e:	f4c42783          	lw	a5,-180(s0)
    80004e32:	2007f793          	and	a5,a5,512
    80004e36:	cfd9                	beqz	a5,80004ed4 <sys_open+0xd8>
    ip = create(path, T_FILE, 0, 0);
    80004e38:	4681                	li	a3,0
    80004e3a:	4601                	li	a2,0
    80004e3c:	4589                	li	a1,2
    80004e3e:	f5040513          	add	a0,s0,-176
    80004e42:	ac7ff0ef          	jal	80004908 <create>
    80004e46:	84aa                	mv	s1,a0
    if(ip == 0){
    80004e48:	c151                	beqz	a0,80004ecc <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004e4a:	04449703          	lh	a4,68(s1)
    80004e4e:	478d                	li	a5,3
    80004e50:	00f71763          	bne	a4,a5,80004e5e <sys_open+0x62>
    80004e54:	0464d703          	lhu	a4,70(s1)
    80004e58:	47a5                	li	a5,9
    80004e5a:	0ae7e863          	bltu	a5,a4,80004f0a <sys_open+0x10e>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e5e:	898ff0ef          	jal	80003ef6 <filealloc>
    80004e62:	892a                	mv	s2,a0
    80004e64:	cd4d                	beqz	a0,80004f1e <sys_open+0x122>
    80004e66:	a65ff0ef          	jal	800048ca <fdalloc>
    80004e6a:	89aa                	mv	s3,a0
    80004e6c:	0a054663          	bltz	a0,80004f18 <sys_open+0x11c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e70:	04449703          	lh	a4,68(s1)
    80004e74:	478d                	li	a5,3
    80004e76:	0af70b63          	beq	a4,a5,80004f2c <sys_open+0x130>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e7a:	4789                	li	a5,2
    80004e7c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004e80:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004e84:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004e88:	f4c42783          	lw	a5,-180(s0)
    80004e8c:	0017c713          	xor	a4,a5,1
    80004e90:	8b05                	and	a4,a4,1
    80004e92:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e96:	0037f713          	and	a4,a5,3
    80004e9a:	00e03733          	snez	a4,a4
    80004e9e:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004ea2:	4007f793          	and	a5,a5,1024
    80004ea6:	c791                	beqz	a5,80004eb2 <sys_open+0xb6>
    80004ea8:	04449703          	lh	a4,68(s1)
    80004eac:	4789                	li	a5,2
    80004eae:	08f70663          	beq	a4,a5,80004f3a <sys_open+0x13e>
    itrunc(ip);
  }

  iunlock(ip);
    80004eb2:	8526                	mv	a0,s1
    80004eb4:	d0efe0ef          	jal	800033c2 <iunlock>
  end_op();
    80004eb8:	d39fe0ef          	jal	80003bf0 <end_op>

  return fd;
    80004ebc:	854e                	mv	a0,s3
}
    80004ebe:	70ea                	ld	ra,184(sp)
    80004ec0:	744a                	ld	s0,176(sp)
    80004ec2:	74aa                	ld	s1,168(sp)
    80004ec4:	790a                	ld	s2,160(sp)
    80004ec6:	69ea                	ld	s3,152(sp)
    80004ec8:	6129                	add	sp,sp,192
    80004eca:	8082                	ret
      end_op();
    80004ecc:	d25fe0ef          	jal	80003bf0 <end_op>
      return -1;
    80004ed0:	557d                	li	a0,-1
    80004ed2:	b7f5                	j	80004ebe <sys_open+0xc2>
    if((ip = namei(path)) == 0){
    80004ed4:	f5040513          	add	a0,s0,-176
    80004ed8:	af3fe0ef          	jal	800039ca <namei>
    80004edc:	84aa                	mv	s1,a0
    80004ede:	c115                	beqz	a0,80004f02 <sys_open+0x106>
    ilock(ip);
    80004ee0:	c38fe0ef          	jal	80003318 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ee4:	04449703          	lh	a4,68(s1)
    80004ee8:	4785                	li	a5,1
    80004eea:	f6f710e3          	bne	a4,a5,80004e4a <sys_open+0x4e>
    80004eee:	f4c42783          	lw	a5,-180(s0)
    80004ef2:	d7b5                	beqz	a5,80004e5e <sys_open+0x62>
      iunlockput(ip);
    80004ef4:	8526                	mv	a0,s1
    80004ef6:	e28fe0ef          	jal	8000351e <iunlockput>
      end_op();
    80004efa:	cf7fe0ef          	jal	80003bf0 <end_op>
      return -1;
    80004efe:	557d                	li	a0,-1
    80004f00:	bf7d                	j	80004ebe <sys_open+0xc2>
      end_op();
    80004f02:	ceffe0ef          	jal	80003bf0 <end_op>
      return -1;
    80004f06:	557d                	li	a0,-1
    80004f08:	bf5d                	j	80004ebe <sys_open+0xc2>
    iunlockput(ip);
    80004f0a:	8526                	mv	a0,s1
    80004f0c:	e12fe0ef          	jal	8000351e <iunlockput>
    end_op();
    80004f10:	ce1fe0ef          	jal	80003bf0 <end_op>
    return -1;
    80004f14:	557d                	li	a0,-1
    80004f16:	b765                	j	80004ebe <sys_open+0xc2>
      fileclose(f);
    80004f18:	854a                	mv	a0,s2
    80004f1a:	880ff0ef          	jal	80003f9a <fileclose>
    iunlockput(ip);
    80004f1e:	8526                	mv	a0,s1
    80004f20:	dfefe0ef          	jal	8000351e <iunlockput>
    end_op();
    80004f24:	ccdfe0ef          	jal	80003bf0 <end_op>
    return -1;
    80004f28:	557d                	li	a0,-1
    80004f2a:	bf51                	j	80004ebe <sys_open+0xc2>
    f->type = FD_DEVICE;
    80004f2c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004f30:	04649783          	lh	a5,70(s1)
    80004f34:	02f91223          	sh	a5,36(s2)
    80004f38:	b7b1                	j	80004e84 <sys_open+0x88>
    itrunc(ip);
    80004f3a:	8526                	mv	a0,s1
    80004f3c:	cc6fe0ef          	jal	80003402 <itrunc>
    80004f40:	bf8d                	j	80004eb2 <sys_open+0xb6>

0000000080004f42 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f42:	7175                	add	sp,sp,-144
    80004f44:	e506                	sd	ra,136(sp)
    80004f46:	e122                	sd	s0,128(sp)
    80004f48:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f4a:	c3dfe0ef          	jal	80003b86 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f4e:	08000613          	li	a2,128
    80004f52:	f7040593          	add	a1,s0,-144
    80004f56:	4501                	li	a0,0
    80004f58:	9f5fd0ef          	jal	8000294c <argstr>
    80004f5c:	02054363          	bltz	a0,80004f82 <sys_mkdir+0x40>
    80004f60:	4681                	li	a3,0
    80004f62:	4601                	li	a2,0
    80004f64:	4585                	li	a1,1
    80004f66:	f7040513          	add	a0,s0,-144
    80004f6a:	99fff0ef          	jal	80004908 <create>
    80004f6e:	c911                	beqz	a0,80004f82 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f70:	daefe0ef          	jal	8000351e <iunlockput>
  end_op();
    80004f74:	c7dfe0ef          	jal	80003bf0 <end_op>
  return 0;
    80004f78:	4501                	li	a0,0
}
    80004f7a:	60aa                	ld	ra,136(sp)
    80004f7c:	640a                	ld	s0,128(sp)
    80004f7e:	6149                	add	sp,sp,144
    80004f80:	8082                	ret
    end_op();
    80004f82:	c6ffe0ef          	jal	80003bf0 <end_op>
    return -1;
    80004f86:	557d                	li	a0,-1
    80004f88:	bfcd                	j	80004f7a <sys_mkdir+0x38>

0000000080004f8a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f8a:	7135                	add	sp,sp,-160
    80004f8c:	ed06                	sd	ra,152(sp)
    80004f8e:	e922                	sd	s0,144(sp)
    80004f90:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f92:	bf5fe0ef          	jal	80003b86 <begin_op>
  argint(1, &major);
    80004f96:	f6c40593          	add	a1,s0,-148
    80004f9a:	4505                	li	a0,1
    80004f9c:	979fd0ef          	jal	80002914 <argint>
  argint(2, &minor);
    80004fa0:	f6840593          	add	a1,s0,-152
    80004fa4:	4509                	li	a0,2
    80004fa6:	96ffd0ef          	jal	80002914 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004faa:	08000613          	li	a2,128
    80004fae:	f7040593          	add	a1,s0,-144
    80004fb2:	4501                	li	a0,0
    80004fb4:	999fd0ef          	jal	8000294c <argstr>
    80004fb8:	02054563          	bltz	a0,80004fe2 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004fbc:	f6841683          	lh	a3,-152(s0)
    80004fc0:	f6c41603          	lh	a2,-148(s0)
    80004fc4:	458d                	li	a1,3
    80004fc6:	f7040513          	add	a0,s0,-144
    80004fca:	93fff0ef          	jal	80004908 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fce:	c911                	beqz	a0,80004fe2 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fd0:	d4efe0ef          	jal	8000351e <iunlockput>
  end_op();
    80004fd4:	c1dfe0ef          	jal	80003bf0 <end_op>
  return 0;
    80004fd8:	4501                	li	a0,0
}
    80004fda:	60ea                	ld	ra,152(sp)
    80004fdc:	644a                	ld	s0,144(sp)
    80004fde:	610d                	add	sp,sp,160
    80004fe0:	8082                	ret
    end_op();
    80004fe2:	c0ffe0ef          	jal	80003bf0 <end_op>
    return -1;
    80004fe6:	557d                	li	a0,-1
    80004fe8:	bfcd                	j	80004fda <sys_mknod+0x50>

0000000080004fea <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fea:	7135                	add	sp,sp,-160
    80004fec:	ed06                	sd	ra,152(sp)
    80004fee:	e922                	sd	s0,144(sp)
    80004ff0:	e526                	sd	s1,136(sp)
    80004ff2:	e14a                	sd	s2,128(sp)
    80004ff4:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ff6:	83bfc0ef          	jal	80001830 <myproc>
    80004ffa:	892a                	mv	s2,a0
  
  begin_op();
    80004ffc:	b8bfe0ef          	jal	80003b86 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005000:	08000613          	li	a2,128
    80005004:	f6040593          	add	a1,s0,-160
    80005008:	4501                	li	a0,0
    8000500a:	943fd0ef          	jal	8000294c <argstr>
    8000500e:	04054163          	bltz	a0,80005050 <sys_chdir+0x66>
    80005012:	f6040513          	add	a0,s0,-160
    80005016:	9b5fe0ef          	jal	800039ca <namei>
    8000501a:	84aa                	mv	s1,a0
    8000501c:	c915                	beqz	a0,80005050 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000501e:	afafe0ef          	jal	80003318 <ilock>
  if(ip->type != T_DIR){
    80005022:	04449703          	lh	a4,68(s1)
    80005026:	4785                	li	a5,1
    80005028:	02f71863          	bne	a4,a5,80005058 <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000502c:	8526                	mv	a0,s1
    8000502e:	b94fe0ef          	jal	800033c2 <iunlock>
  iput(p->cwd);
    80005032:	15093503          	ld	a0,336(s2)
    80005036:	c60fe0ef          	jal	80003496 <iput>
  end_op();
    8000503a:	bb7fe0ef          	jal	80003bf0 <end_op>
  p->cwd = ip;
    8000503e:	14993823          	sd	s1,336(s2)
  return 0;
    80005042:	4501                	li	a0,0
}
    80005044:	60ea                	ld	ra,152(sp)
    80005046:	644a                	ld	s0,144(sp)
    80005048:	64aa                	ld	s1,136(sp)
    8000504a:	690a                	ld	s2,128(sp)
    8000504c:	610d                	add	sp,sp,160
    8000504e:	8082                	ret
    end_op();
    80005050:	ba1fe0ef          	jal	80003bf0 <end_op>
    return -1;
    80005054:	557d                	li	a0,-1
    80005056:	b7fd                	j	80005044 <sys_chdir+0x5a>
    iunlockput(ip);
    80005058:	8526                	mv	a0,s1
    8000505a:	cc4fe0ef          	jal	8000351e <iunlockput>
    end_op();
    8000505e:	b93fe0ef          	jal	80003bf0 <end_op>
    return -1;
    80005062:	557d                	li	a0,-1
    80005064:	b7c5                	j	80005044 <sys_chdir+0x5a>

0000000080005066 <sys_exec>:

uint64
sys_exec(void)
{
    80005066:	7121                	add	sp,sp,-448
    80005068:	ff06                	sd	ra,440(sp)
    8000506a:	fb22                	sd	s0,432(sp)
    8000506c:	f726                	sd	s1,424(sp)
    8000506e:	f34a                	sd	s2,416(sp)
    80005070:	ef4e                	sd	s3,408(sp)
    80005072:	eb52                	sd	s4,400(sp)
    80005074:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005076:	e4840593          	add	a1,s0,-440
    8000507a:	4505                	li	a0,1
    8000507c:	8b5fd0ef          	jal	80002930 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005080:	08000613          	li	a2,128
    80005084:	f5040593          	add	a1,s0,-176
    80005088:	4501                	li	a0,0
    8000508a:	8c3fd0ef          	jal	8000294c <argstr>
    8000508e:	87aa                	mv	a5,a0
    return -1;
    80005090:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005092:	0a07c463          	bltz	a5,8000513a <sys_exec+0xd4>
  }
  memset(argv, 0, sizeof(argv));
    80005096:	10000613          	li	a2,256
    8000509a:	4581                	li	a1,0
    8000509c:	e5040513          	add	a0,s0,-432
    800050a0:	bd5fb0ef          	jal	80000c74 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050a4:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800050a8:	89a6                	mv	s3,s1
    800050aa:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050ac:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050b0:	00391513          	sll	a0,s2,0x3
    800050b4:	e4040593          	add	a1,s0,-448
    800050b8:	e4843783          	ld	a5,-440(s0)
    800050bc:	953e                	add	a0,a0,a5
    800050be:	fccfd0ef          	jal	8000288a <fetchaddr>
    800050c2:	02054663          	bltz	a0,800050ee <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800050c6:	e4043783          	ld	a5,-448(s0)
    800050ca:	cf8d                	beqz	a5,80005104 <sys_exec+0x9e>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050cc:	a05fb0ef          	jal	80000ad0 <kalloc>
    800050d0:	85aa                	mv	a1,a0
    800050d2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050d6:	cd01                	beqz	a0,800050ee <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050d8:	6605                	lui	a2,0x1
    800050da:	e4043503          	ld	a0,-448(s0)
    800050de:	ff6fd0ef          	jal	800028d4 <fetchstr>
    800050e2:	00054663          	bltz	a0,800050ee <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800050e6:	0905                	add	s2,s2,1
    800050e8:	09a1                	add	s3,s3,8
    800050ea:	fd4913e3          	bne	s2,s4,800050b0 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ee:	f5040913          	add	s2,s0,-176
    800050f2:	6088                	ld	a0,0(s1)
    800050f4:	c131                	beqz	a0,80005138 <sys_exec+0xd2>
    kfree(argv[i]);
    800050f6:	8f9fb0ef          	jal	800009ee <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050fa:	04a1                	add	s1,s1,8
    800050fc:	ff249be3          	bne	s1,s2,800050f2 <sys_exec+0x8c>
  return -1;
    80005100:	557d                	li	a0,-1
    80005102:	a825                	j	8000513a <sys_exec+0xd4>
      argv[i] = 0;
    80005104:	0009079b          	sext.w	a5,s2
    80005108:	078e                	sll	a5,a5,0x3
    8000510a:	fd078793          	add	a5,a5,-48
    8000510e:	97a2                	add	a5,a5,s0
    80005110:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005114:	e5040593          	add	a1,s0,-432
    80005118:	f5040513          	add	a0,s0,-176
    8000511c:	c1cff0ef          	jal	80004538 <exec>
    80005120:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005122:	f5040993          	add	s3,s0,-176
    80005126:	6088                	ld	a0,0(s1)
    80005128:	c511                	beqz	a0,80005134 <sys_exec+0xce>
    kfree(argv[i]);
    8000512a:	8c5fb0ef          	jal	800009ee <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000512e:	04a1                	add	s1,s1,8
    80005130:	ff349be3          	bne	s1,s3,80005126 <sys_exec+0xc0>
  return ret;
    80005134:	854a                	mv	a0,s2
    80005136:	a011                	j	8000513a <sys_exec+0xd4>
  return -1;
    80005138:	557d                	li	a0,-1
}
    8000513a:	70fa                	ld	ra,440(sp)
    8000513c:	745a                	ld	s0,432(sp)
    8000513e:	74ba                	ld	s1,424(sp)
    80005140:	791a                	ld	s2,416(sp)
    80005142:	69fa                	ld	s3,408(sp)
    80005144:	6a5a                	ld	s4,400(sp)
    80005146:	6139                	add	sp,sp,448
    80005148:	8082                	ret

000000008000514a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000514a:	7139                	add	sp,sp,-64
    8000514c:	fc06                	sd	ra,56(sp)
    8000514e:	f822                	sd	s0,48(sp)
    80005150:	f426                	sd	s1,40(sp)
    80005152:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005154:	edcfc0ef          	jal	80001830 <myproc>
    80005158:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000515a:	fd840593          	add	a1,s0,-40
    8000515e:	4501                	li	a0,0
    80005160:	fd0fd0ef          	jal	80002930 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005164:	fc840593          	add	a1,s0,-56
    80005168:	fd040513          	add	a0,s0,-48
    8000516c:	8f6ff0ef          	jal	80004262 <pipealloc>
    return -1;
    80005170:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005172:	0a054463          	bltz	a0,8000521a <sys_pipe+0xd0>
  fd0 = -1;
    80005176:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000517a:	fd043503          	ld	a0,-48(s0)
    8000517e:	f4cff0ef          	jal	800048ca <fdalloc>
    80005182:	fca42223          	sw	a0,-60(s0)
    80005186:	08054163          	bltz	a0,80005208 <sys_pipe+0xbe>
    8000518a:	fc843503          	ld	a0,-56(s0)
    8000518e:	f3cff0ef          	jal	800048ca <fdalloc>
    80005192:	fca42023          	sw	a0,-64(s0)
    80005196:	06054063          	bltz	a0,800051f6 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000519a:	4691                	li	a3,4
    8000519c:	fc440613          	add	a2,s0,-60
    800051a0:	fd843583          	ld	a1,-40(s0)
    800051a4:	68a8                	ld	a0,80(s1)
    800051a6:	b42fc0ef          	jal	800014e8 <copyout>
    800051aa:	00054e63          	bltz	a0,800051c6 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051ae:	4691                	li	a3,4
    800051b0:	fc040613          	add	a2,s0,-64
    800051b4:	fd843583          	ld	a1,-40(s0)
    800051b8:	0591                	add	a1,a1,4
    800051ba:	68a8                	ld	a0,80(s1)
    800051bc:	b2cfc0ef          	jal	800014e8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051c0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051c2:	04055c63          	bgez	a0,8000521a <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800051c6:	fc442783          	lw	a5,-60(s0)
    800051ca:	07e9                	add	a5,a5,26
    800051cc:	078e                	sll	a5,a5,0x3
    800051ce:	97a6                	add	a5,a5,s1
    800051d0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051d4:	fc042783          	lw	a5,-64(s0)
    800051d8:	07e9                	add	a5,a5,26
    800051da:	078e                	sll	a5,a5,0x3
    800051dc:	94be                	add	s1,s1,a5
    800051de:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800051e2:	fd043503          	ld	a0,-48(s0)
    800051e6:	db5fe0ef          	jal	80003f9a <fileclose>
    fileclose(wf);
    800051ea:	fc843503          	ld	a0,-56(s0)
    800051ee:	dadfe0ef          	jal	80003f9a <fileclose>
    return -1;
    800051f2:	57fd                	li	a5,-1
    800051f4:	a01d                	j	8000521a <sys_pipe+0xd0>
    if(fd0 >= 0)
    800051f6:	fc442783          	lw	a5,-60(s0)
    800051fa:	0007c763          	bltz	a5,80005208 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800051fe:	07e9                	add	a5,a5,26
    80005200:	078e                	sll	a5,a5,0x3
    80005202:	97a6                	add	a5,a5,s1
    80005204:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005208:	fd043503          	ld	a0,-48(s0)
    8000520c:	d8ffe0ef          	jal	80003f9a <fileclose>
    fileclose(wf);
    80005210:	fc843503          	ld	a0,-56(s0)
    80005214:	d87fe0ef          	jal	80003f9a <fileclose>
    return -1;
    80005218:	57fd                	li	a5,-1
}
    8000521a:	853e                	mv	a0,a5
    8000521c:	70e2                	ld	ra,56(sp)
    8000521e:	7442                	ld	s0,48(sp)
    80005220:	74a2                	ld	s1,40(sp)
    80005222:	6121                	add	sp,sp,64
    80005224:	8082                	ret
	...

0000000080005230 <kernelvec>:
    80005230:	7111                	add	sp,sp,-256
    80005232:	e006                	sd	ra,0(sp)
    80005234:	e40a                	sd	sp,8(sp)
    80005236:	e80e                	sd	gp,16(sp)
    80005238:	ec12                	sd	tp,24(sp)
    8000523a:	f016                	sd	t0,32(sp)
    8000523c:	f41a                	sd	t1,40(sp)
    8000523e:	f81e                	sd	t2,48(sp)
    80005240:	e4aa                	sd	a0,72(sp)
    80005242:	e8ae                	sd	a1,80(sp)
    80005244:	ecb2                	sd	a2,88(sp)
    80005246:	f0b6                	sd	a3,96(sp)
    80005248:	f4ba                	sd	a4,104(sp)
    8000524a:	f8be                	sd	a5,112(sp)
    8000524c:	fcc2                	sd	a6,120(sp)
    8000524e:	e146                	sd	a7,128(sp)
    80005250:	edf2                	sd	t3,216(sp)
    80005252:	f1f6                	sd	t4,224(sp)
    80005254:	f5fa                	sd	t5,232(sp)
    80005256:	f9fe                	sd	t6,240(sp)
    80005258:	d42fd0ef          	jal	8000279a <kerneltrap>
    8000525c:	6082                	ld	ra,0(sp)
    8000525e:	6122                	ld	sp,8(sp)
    80005260:	61c2                	ld	gp,16(sp)
    80005262:	7282                	ld	t0,32(sp)
    80005264:	7322                	ld	t1,40(sp)
    80005266:	73c2                	ld	t2,48(sp)
    80005268:	6526                	ld	a0,72(sp)
    8000526a:	65c6                	ld	a1,80(sp)
    8000526c:	6666                	ld	a2,88(sp)
    8000526e:	7686                	ld	a3,96(sp)
    80005270:	7726                	ld	a4,104(sp)
    80005272:	77c6                	ld	a5,112(sp)
    80005274:	7866                	ld	a6,120(sp)
    80005276:	688a                	ld	a7,128(sp)
    80005278:	6e6e                	ld	t3,216(sp)
    8000527a:	7e8e                	ld	t4,224(sp)
    8000527c:	7f2e                	ld	t5,232(sp)
    8000527e:	7fce                	ld	t6,240(sp)
    80005280:	6111                	add	sp,sp,256
    80005282:	10200073          	sret
	...

000000008000528e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000528e:	1141                	add	sp,sp,-16
    80005290:	e422                	sd	s0,8(sp)
    80005292:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005294:	0c0007b7          	lui	a5,0xc000
    80005298:	4705                	li	a4,1
    8000529a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000529c:	c3d8                	sw	a4,4(a5)
}
    8000529e:	6422                	ld	s0,8(sp)
    800052a0:	0141                	add	sp,sp,16
    800052a2:	8082                	ret

00000000800052a4 <plicinithart>:

void
plicinithart(void)
{
    800052a4:	1141                	add	sp,sp,-16
    800052a6:	e406                	sd	ra,8(sp)
    800052a8:	e022                	sd	s0,0(sp)
    800052aa:	0800                	add	s0,sp,16
  int hart = cpuid();
    800052ac:	d58fc0ef          	jal	80001804 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052b0:	0085171b          	sllw	a4,a0,0x8
    800052b4:	0c0027b7          	lui	a5,0xc002
    800052b8:	97ba                	add	a5,a5,a4
    800052ba:	40200713          	li	a4,1026
    800052be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052c2:	00d5151b          	sllw	a0,a0,0xd
    800052c6:	0c2017b7          	lui	a5,0xc201
    800052ca:	97aa                	add	a5,a5,a0
    800052cc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052d0:	60a2                	ld	ra,8(sp)
    800052d2:	6402                	ld	s0,0(sp)
    800052d4:	0141                	add	sp,sp,16
    800052d6:	8082                	ret

00000000800052d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052d8:	1141                	add	sp,sp,-16
    800052da:	e406                	sd	ra,8(sp)
    800052dc:	e022                	sd	s0,0(sp)
    800052de:	0800                	add	s0,sp,16
  int hart = cpuid();
    800052e0:	d24fc0ef          	jal	80001804 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052e4:	00d5151b          	sllw	a0,a0,0xd
    800052e8:	0c2017b7          	lui	a5,0xc201
    800052ec:	97aa                	add	a5,a5,a0
  return irq;
}
    800052ee:	43c8                	lw	a0,4(a5)
    800052f0:	60a2                	ld	ra,8(sp)
    800052f2:	6402                	ld	s0,0(sp)
    800052f4:	0141                	add	sp,sp,16
    800052f6:	8082                	ret

00000000800052f8 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052f8:	1101                	add	sp,sp,-32
    800052fa:	ec06                	sd	ra,24(sp)
    800052fc:	e822                	sd	s0,16(sp)
    800052fe:	e426                	sd	s1,8(sp)
    80005300:	1000                	add	s0,sp,32
    80005302:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005304:	d00fc0ef          	jal	80001804 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005308:	00d5151b          	sllw	a0,a0,0xd
    8000530c:	0c2017b7          	lui	a5,0xc201
    80005310:	97aa                	add	a5,a5,a0
    80005312:	c3c4                	sw	s1,4(a5)
}
    80005314:	60e2                	ld	ra,24(sp)
    80005316:	6442                	ld	s0,16(sp)
    80005318:	64a2                	ld	s1,8(sp)
    8000531a:	6105                	add	sp,sp,32
    8000531c:	8082                	ret

000000008000531e <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000531e:	1141                	add	sp,sp,-16
    80005320:	e406                	sd	ra,8(sp)
    80005322:	e022                	sd	s0,0(sp)
    80005324:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005326:	479d                	li	a5,7
    80005328:	04a7ca63          	blt	a5,a0,8000537c <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    8000532c:	0002d797          	auipc	a5,0x2d
    80005330:	72478793          	add	a5,a5,1828 # 80032a50 <disk>
    80005334:	97aa                	add	a5,a5,a0
    80005336:	0187c783          	lbu	a5,24(a5)
    8000533a:	e7b9                	bnez	a5,80005388 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000533c:	00451693          	sll	a3,a0,0x4
    80005340:	0002d797          	auipc	a5,0x2d
    80005344:	71078793          	add	a5,a5,1808 # 80032a50 <disk>
    80005348:	6398                	ld	a4,0(a5)
    8000534a:	9736                	add	a4,a4,a3
    8000534c:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005350:	6398                	ld	a4,0(a5)
    80005352:	9736                	add	a4,a4,a3
    80005354:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005358:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000535c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005360:	97aa                	add	a5,a5,a0
    80005362:	4705                	li	a4,1
    80005364:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005368:	0002d517          	auipc	a0,0x2d
    8000536c:	70050513          	add	a0,a0,1792 # 80032a68 <disk+0x18>
    80005370:	b19fc0ef          	jal	80001e88 <wakeup>
}
    80005374:	60a2                	ld	ra,8(sp)
    80005376:	6402                	ld	s0,0(sp)
    80005378:	0141                	add	sp,sp,16
    8000537a:	8082                	ret
    panic("free_desc 1");
    8000537c:	00002517          	auipc	a0,0x2
    80005380:	44450513          	add	a0,a0,1092 # 800077c0 <syscalls+0x330>
    80005384:	bdafb0ef          	jal	8000075e <panic>
    panic("free_desc 2");
    80005388:	00002517          	auipc	a0,0x2
    8000538c:	44850513          	add	a0,a0,1096 # 800077d0 <syscalls+0x340>
    80005390:	bcefb0ef          	jal	8000075e <panic>

0000000080005394 <virtio_disk_init>:
{
    80005394:	1101                	add	sp,sp,-32
    80005396:	ec06                	sd	ra,24(sp)
    80005398:	e822                	sd	s0,16(sp)
    8000539a:	e426                	sd	s1,8(sp)
    8000539c:	e04a                	sd	s2,0(sp)
    8000539e:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053a0:	00002597          	auipc	a1,0x2
    800053a4:	44058593          	add	a1,a1,1088 # 800077e0 <syscalls+0x350>
    800053a8:	0002d517          	auipc	a0,0x2d
    800053ac:	7d050513          	add	a0,a0,2000 # 80032b78 <disk+0x128>
    800053b0:	f70fb0ef          	jal	80000b20 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053b4:	100017b7          	lui	a5,0x10001
    800053b8:	4398                	lw	a4,0(a5)
    800053ba:	2701                	sext.w	a4,a4
    800053bc:	747277b7          	lui	a5,0x74727
    800053c0:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053c4:	12f71f63          	bne	a4,a5,80005502 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053c8:	100017b7          	lui	a5,0x10001
    800053cc:	43dc                	lw	a5,4(a5)
    800053ce:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053d0:	4709                	li	a4,2
    800053d2:	12e79863          	bne	a5,a4,80005502 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053d6:	100017b7          	lui	a5,0x10001
    800053da:	479c                	lw	a5,8(a5)
    800053dc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053de:	12e79263          	bne	a5,a4,80005502 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053e2:	100017b7          	lui	a5,0x10001
    800053e6:	47d8                	lw	a4,12(a5)
    800053e8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053ea:	554d47b7          	lui	a5,0x554d4
    800053ee:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053f2:	10f71863          	bne	a4,a5,80005502 <virtio_disk_init+0x16e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053f6:	100017b7          	lui	a5,0x10001
    800053fa:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053fe:	4705                	li	a4,1
    80005400:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005402:	470d                	li	a4,3
    80005404:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005406:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005408:	c7ffe6b7          	lui	a3,0xc7ffe
    8000540c:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fcbbcf>
    80005410:	8f75                	and	a4,a4,a3
    80005412:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005414:	472d                	li	a4,11
    80005416:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005418:	5bbc                	lw	a5,112(a5)
    8000541a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000541e:	8ba1                	and	a5,a5,8
    80005420:	0e078763          	beqz	a5,8000550e <virtio_disk_init+0x17a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005424:	100017b7          	lui	a5,0x10001
    80005428:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000542c:	43fc                	lw	a5,68(a5)
    8000542e:	2781                	sext.w	a5,a5
    80005430:	0e079563          	bnez	a5,8000551a <virtio_disk_init+0x186>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005434:	100017b7          	lui	a5,0x10001
    80005438:	5bdc                	lw	a5,52(a5)
    8000543a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000543c:	0e078563          	beqz	a5,80005526 <virtio_disk_init+0x192>
  if(max < NUM)
    80005440:	471d                	li	a4,7
    80005442:	0ef77863          	bgeu	a4,a5,80005532 <virtio_disk_init+0x19e>
  disk.desc = kalloc();
    80005446:	e8afb0ef          	jal	80000ad0 <kalloc>
    8000544a:	0002d497          	auipc	s1,0x2d
    8000544e:	60648493          	add	s1,s1,1542 # 80032a50 <disk>
    80005452:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005454:	e7cfb0ef          	jal	80000ad0 <kalloc>
    80005458:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000545a:	e76fb0ef          	jal	80000ad0 <kalloc>
    8000545e:	87aa                	mv	a5,a0
    80005460:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005462:	6088                	ld	a0,0(s1)
    80005464:	cd69                	beqz	a0,8000553e <virtio_disk_init+0x1aa>
    80005466:	0002d717          	auipc	a4,0x2d
    8000546a:	5f273703          	ld	a4,1522(a4) # 80032a58 <disk+0x8>
    8000546e:	cb61                	beqz	a4,8000553e <virtio_disk_init+0x1aa>
    80005470:	c7f9                	beqz	a5,8000553e <virtio_disk_init+0x1aa>
  memset(disk.desc, 0, PGSIZE);
    80005472:	6605                	lui	a2,0x1
    80005474:	4581                	li	a1,0
    80005476:	ffefb0ef          	jal	80000c74 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000547a:	0002d497          	auipc	s1,0x2d
    8000547e:	5d648493          	add	s1,s1,1494 # 80032a50 <disk>
    80005482:	6605                	lui	a2,0x1
    80005484:	4581                	li	a1,0
    80005486:	6488                	ld	a0,8(s1)
    80005488:	fecfb0ef          	jal	80000c74 <memset>
  memset(disk.used, 0, PGSIZE);
    8000548c:	6605                	lui	a2,0x1
    8000548e:	4581                	li	a1,0
    80005490:	6888                	ld	a0,16(s1)
    80005492:	fe2fb0ef          	jal	80000c74 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005496:	100017b7          	lui	a5,0x10001
    8000549a:	4721                	li	a4,8
    8000549c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000549e:	4098                	lw	a4,0(s1)
    800054a0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800054a4:	40d8                	lw	a4,4(s1)
    800054a6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800054aa:	6498                	ld	a4,8(s1)
    800054ac:	0007069b          	sext.w	a3,a4
    800054b0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800054b4:	9701                	sra	a4,a4,0x20
    800054b6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800054ba:	6898                	ld	a4,16(s1)
    800054bc:	0007069b          	sext.w	a3,a4
    800054c0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800054c4:	9701                	sra	a4,a4,0x20
    800054c6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800054ca:	4705                	li	a4,1
    800054cc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800054ce:	00e48c23          	sb	a4,24(s1)
    800054d2:	00e48ca3          	sb	a4,25(s1)
    800054d6:	00e48d23          	sb	a4,26(s1)
    800054da:	00e48da3          	sb	a4,27(s1)
    800054de:	00e48e23          	sb	a4,28(s1)
    800054e2:	00e48ea3          	sb	a4,29(s1)
    800054e6:	00e48f23          	sb	a4,30(s1)
    800054ea:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800054ee:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800054f2:	0727a823          	sw	s2,112(a5)
}
    800054f6:	60e2                	ld	ra,24(sp)
    800054f8:	6442                	ld	s0,16(sp)
    800054fa:	64a2                	ld	s1,8(sp)
    800054fc:	6902                	ld	s2,0(sp)
    800054fe:	6105                	add	sp,sp,32
    80005500:	8082                	ret
    panic("could not find virtio disk");
    80005502:	00002517          	auipc	a0,0x2
    80005506:	2ee50513          	add	a0,a0,750 # 800077f0 <syscalls+0x360>
    8000550a:	a54fb0ef          	jal	8000075e <panic>
    panic("virtio disk FEATURES_OK unset");
    8000550e:	00002517          	auipc	a0,0x2
    80005512:	30250513          	add	a0,a0,770 # 80007810 <syscalls+0x380>
    80005516:	a48fb0ef          	jal	8000075e <panic>
    panic("virtio disk should not be ready");
    8000551a:	00002517          	auipc	a0,0x2
    8000551e:	31650513          	add	a0,a0,790 # 80007830 <syscalls+0x3a0>
    80005522:	a3cfb0ef          	jal	8000075e <panic>
    panic("virtio disk has no queue 0");
    80005526:	00002517          	auipc	a0,0x2
    8000552a:	32a50513          	add	a0,a0,810 # 80007850 <syscalls+0x3c0>
    8000552e:	a30fb0ef          	jal	8000075e <panic>
    panic("virtio disk max queue too short");
    80005532:	00002517          	auipc	a0,0x2
    80005536:	33e50513          	add	a0,a0,830 # 80007870 <syscalls+0x3e0>
    8000553a:	a24fb0ef          	jal	8000075e <panic>
    panic("virtio disk kalloc");
    8000553e:	00002517          	auipc	a0,0x2
    80005542:	35250513          	add	a0,a0,850 # 80007890 <syscalls+0x400>
    80005546:	a18fb0ef          	jal	8000075e <panic>

000000008000554a <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000554a:	7159                	add	sp,sp,-112
    8000554c:	f486                	sd	ra,104(sp)
    8000554e:	f0a2                	sd	s0,96(sp)
    80005550:	eca6                	sd	s1,88(sp)
    80005552:	e8ca                	sd	s2,80(sp)
    80005554:	e4ce                	sd	s3,72(sp)
    80005556:	e0d2                	sd	s4,64(sp)
    80005558:	fc56                	sd	s5,56(sp)
    8000555a:	f85a                	sd	s6,48(sp)
    8000555c:	f45e                	sd	s7,40(sp)
    8000555e:	f062                	sd	s8,32(sp)
    80005560:	ec66                	sd	s9,24(sp)
    80005562:	e86a                	sd	s10,16(sp)
    80005564:	1880                	add	s0,sp,112
    80005566:	8a2a                	mv	s4,a0
    80005568:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000556a:	00c52c83          	lw	s9,12(a0)
    8000556e:	001c9c9b          	sllw	s9,s9,0x1
    80005572:	1c82                	sll	s9,s9,0x20
    80005574:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005578:	0002d517          	auipc	a0,0x2d
    8000557c:	60050513          	add	a0,a0,1536 # 80032b78 <disk+0x128>
    80005580:	e20fb0ef          	jal	80000ba0 <acquire>
  for(int i = 0; i < 3; i++){
    80005584:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005586:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005588:	0002db17          	auipc	s6,0x2d
    8000558c:	4c8b0b13          	add	s6,s6,1224 # 80032a50 <disk>
  for(int i = 0; i < 3; i++){
    80005590:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005592:	0002dc17          	auipc	s8,0x2d
    80005596:	5e6c0c13          	add	s8,s8,1510 # 80032b78 <disk+0x128>
    8000559a:	a8b1                	j	800055f6 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    8000559c:	00fb0733          	add	a4,s6,a5
    800055a0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800055a4:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800055a6:	0207c563          	bltz	a5,800055d0 <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    800055aa:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800055ac:	0591                	add	a1,a1,4
    800055ae:	05560963          	beq	a2,s5,80005600 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    800055b2:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800055b4:	0002d717          	auipc	a4,0x2d
    800055b8:	49c70713          	add	a4,a4,1180 # 80032a50 <disk>
    800055bc:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800055be:	01874683          	lbu	a3,24(a4)
    800055c2:	fee9                	bnez	a3,8000559c <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800055c4:	2785                	addw	a5,a5,1
    800055c6:	0705                	add	a4,a4,1
    800055c8:	fe979be3          	bne	a5,s1,800055be <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    800055cc:	57fd                	li	a5,-1
    800055ce:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800055d0:	00c05c63          	blez	a2,800055e8 <virtio_disk_rw+0x9e>
    800055d4:	060a                	sll	a2,a2,0x2
    800055d6:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800055da:	0009a503          	lw	a0,0(s3)
    800055de:	d41ff0ef          	jal	8000531e <free_desc>
      for(int j = 0; j < i; j++)
    800055e2:	0991                	add	s3,s3,4
    800055e4:	ffa99be3          	bne	s3,s10,800055da <virtio_disk_rw+0x90>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055e8:	85e2                	mv	a1,s8
    800055ea:	0002d517          	auipc	a0,0x2d
    800055ee:	47e50513          	add	a0,a0,1150 # 80032a68 <disk+0x18>
    800055f2:	84bfc0ef          	jal	80001e3c <sleep>
  for(int i = 0; i < 3; i++){
    800055f6:	f9040993          	add	s3,s0,-112
{
    800055fa:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    800055fc:	864a                	mv	a2,s2
    800055fe:	bf55                	j	800055b2 <virtio_disk_rw+0x68>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005600:	f9042503          	lw	a0,-112(s0)
    80005604:	00a50713          	add	a4,a0,10
    80005608:	0712                	sll	a4,a4,0x4

  if(write)
    8000560a:	0002d797          	auipc	a5,0x2d
    8000560e:	44678793          	add	a5,a5,1094 # 80032a50 <disk>
    80005612:	00e786b3          	add	a3,a5,a4
    80005616:	01703633          	snez	a2,s7
    8000561a:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000561c:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005620:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005624:	f6070613          	add	a2,a4,-160
    80005628:	6394                	ld	a3,0(a5)
    8000562a:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000562c:	00870593          	add	a1,a4,8
    80005630:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005632:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005634:	0007b803          	ld	a6,0(a5)
    80005638:	9642                	add	a2,a2,a6
    8000563a:	46c1                	li	a3,16
    8000563c:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000563e:	4585                	li	a1,1
    80005640:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005644:	f9442683          	lw	a3,-108(s0)
    80005648:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000564c:	0692                	sll	a3,a3,0x4
    8000564e:	9836                	add	a6,a6,a3
    80005650:	058a0613          	add	a2,s4,88
    80005654:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80005658:	0007b803          	ld	a6,0(a5)
    8000565c:	96c2                	add	a3,a3,a6
    8000565e:	40000613          	li	a2,1024
    80005662:	c690                	sw	a2,8(a3)
  if(write)
    80005664:	001bb613          	seqz	a2,s7
    80005668:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000566c:	00166613          	or	a2,a2,1
    80005670:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005674:	f9842603          	lw	a2,-104(s0)
    80005678:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000567c:	00250693          	add	a3,a0,2
    80005680:	0692                	sll	a3,a3,0x4
    80005682:	96be                	add	a3,a3,a5
    80005684:	58fd                	li	a7,-1
    80005686:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000568a:	0612                	sll	a2,a2,0x4
    8000568c:	9832                	add	a6,a6,a2
    8000568e:	f9070713          	add	a4,a4,-112
    80005692:	973e                	add	a4,a4,a5
    80005694:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    80005698:	6398                	ld	a4,0(a5)
    8000569a:	9732                	add	a4,a4,a2
    8000569c:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000569e:	4609                	li	a2,2
    800056a0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800056a4:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056a8:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800056ac:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056b0:	6794                	ld	a3,8(a5)
    800056b2:	0026d703          	lhu	a4,2(a3)
    800056b6:	8b1d                	and	a4,a4,7
    800056b8:	0706                	sll	a4,a4,0x1
    800056ba:	96ba                	add	a3,a3,a4
    800056bc:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800056c0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056c4:	6798                	ld	a4,8(a5)
    800056c6:	00275783          	lhu	a5,2(a4)
    800056ca:	2785                	addw	a5,a5,1
    800056cc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056d0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056d4:	100017b7          	lui	a5,0x10001
    800056d8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056dc:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800056e0:	0002d917          	auipc	s2,0x2d
    800056e4:	49890913          	add	s2,s2,1176 # 80032b78 <disk+0x128>
  while(b->disk == 1) {
    800056e8:	4485                	li	s1,1
    800056ea:	00b79a63          	bne	a5,a1,800056fe <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    800056ee:	85ca                	mv	a1,s2
    800056f0:	8552                	mv	a0,s4
    800056f2:	f4afc0ef          	jal	80001e3c <sleep>
  while(b->disk == 1) {
    800056f6:	004a2783          	lw	a5,4(s4)
    800056fa:	fe978ae3          	beq	a5,s1,800056ee <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    800056fe:	f9042903          	lw	s2,-112(s0)
    80005702:	00290713          	add	a4,s2,2
    80005706:	0712                	sll	a4,a4,0x4
    80005708:	0002d797          	auipc	a5,0x2d
    8000570c:	34878793          	add	a5,a5,840 # 80032a50 <disk>
    80005710:	97ba                	add	a5,a5,a4
    80005712:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005716:	0002d997          	auipc	s3,0x2d
    8000571a:	33a98993          	add	s3,s3,826 # 80032a50 <disk>
    8000571e:	00491713          	sll	a4,s2,0x4
    80005722:	0009b783          	ld	a5,0(s3)
    80005726:	97ba                	add	a5,a5,a4
    80005728:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000572c:	854a                	mv	a0,s2
    8000572e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005732:	bedff0ef          	jal	8000531e <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005736:	8885                	and	s1,s1,1
    80005738:	f0fd                	bnez	s1,8000571e <virtio_disk_rw+0x1d4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000573a:	0002d517          	auipc	a0,0x2d
    8000573e:	43e50513          	add	a0,a0,1086 # 80032b78 <disk+0x128>
    80005742:	cf6fb0ef          	jal	80000c38 <release>
}
    80005746:	70a6                	ld	ra,104(sp)
    80005748:	7406                	ld	s0,96(sp)
    8000574a:	64e6                	ld	s1,88(sp)
    8000574c:	6946                	ld	s2,80(sp)
    8000574e:	69a6                	ld	s3,72(sp)
    80005750:	6a06                	ld	s4,64(sp)
    80005752:	7ae2                	ld	s5,56(sp)
    80005754:	7b42                	ld	s6,48(sp)
    80005756:	7ba2                	ld	s7,40(sp)
    80005758:	7c02                	ld	s8,32(sp)
    8000575a:	6ce2                	ld	s9,24(sp)
    8000575c:	6d42                	ld	s10,16(sp)
    8000575e:	6165                	add	sp,sp,112
    80005760:	8082                	ret

0000000080005762 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005762:	1101                	add	sp,sp,-32
    80005764:	ec06                	sd	ra,24(sp)
    80005766:	e822                	sd	s0,16(sp)
    80005768:	e426                	sd	s1,8(sp)
    8000576a:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000576c:	0002d497          	auipc	s1,0x2d
    80005770:	2e448493          	add	s1,s1,740 # 80032a50 <disk>
    80005774:	0002d517          	auipc	a0,0x2d
    80005778:	40450513          	add	a0,a0,1028 # 80032b78 <disk+0x128>
    8000577c:	c24fb0ef          	jal	80000ba0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005780:	10001737          	lui	a4,0x10001
    80005784:	533c                	lw	a5,96(a4)
    80005786:	8b8d                	and	a5,a5,3
    80005788:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000578a:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000578e:	689c                	ld	a5,16(s1)
    80005790:	0204d703          	lhu	a4,32(s1)
    80005794:	0027d783          	lhu	a5,2(a5)
    80005798:	04f70663          	beq	a4,a5,800057e4 <virtio_disk_intr+0x82>
    __sync_synchronize();
    8000579c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057a0:	6898                	ld	a4,16(s1)
    800057a2:	0204d783          	lhu	a5,32(s1)
    800057a6:	8b9d                	and	a5,a5,7
    800057a8:	078e                	sll	a5,a5,0x3
    800057aa:	97ba                	add	a5,a5,a4
    800057ac:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057ae:	00278713          	add	a4,a5,2
    800057b2:	0712                	sll	a4,a4,0x4
    800057b4:	9726                	add	a4,a4,s1
    800057b6:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800057ba:	e321                	bnez	a4,800057fa <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057bc:	0789                	add	a5,a5,2
    800057be:	0792                	sll	a5,a5,0x4
    800057c0:	97a6                	add	a5,a5,s1
    800057c2:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800057c4:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057c8:	ec0fc0ef          	jal	80001e88 <wakeup>

    disk.used_idx += 1;
    800057cc:	0204d783          	lhu	a5,32(s1)
    800057d0:	2785                	addw	a5,a5,1
    800057d2:	17c2                	sll	a5,a5,0x30
    800057d4:	93c1                	srl	a5,a5,0x30
    800057d6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057da:	6898                	ld	a4,16(s1)
    800057dc:	00275703          	lhu	a4,2(a4)
    800057e0:	faf71ee3          	bne	a4,a5,8000579c <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    800057e4:	0002d517          	auipc	a0,0x2d
    800057e8:	39450513          	add	a0,a0,916 # 80032b78 <disk+0x128>
    800057ec:	c4cfb0ef          	jal	80000c38 <release>
}
    800057f0:	60e2                	ld	ra,24(sp)
    800057f2:	6442                	ld	s0,16(sp)
    800057f4:	64a2                	ld	s1,8(sp)
    800057f6:	6105                	add	sp,sp,32
    800057f8:	8082                	ret
      panic("virtio_disk_intr status");
    800057fa:	00002517          	auipc	a0,0x2
    800057fe:	0ae50513          	add	a0,a0,174 # 800078a8 <syscalls+0x418>
    80005802:	f5dfa0ef          	jal	8000075e <panic>
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
