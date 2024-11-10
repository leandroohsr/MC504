
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	add	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	346000ef          	jal	366 <read>
  24:	84aa                	mv	s1,a0
  26:	02a05363          	blez	a0,4c <cat+0x4c>
    if (write(1, buf, n) != n) {
  2a:	8626                	mv	a2,s1
  2c:	85ca                	mv	a1,s2
  2e:	4505                	li	a0,1
  30:	33e000ef          	jal	36e <write>
  34:	fe9502e3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  38:	00001597          	auipc	a1,0x1
  3c:	8e858593          	add	a1,a1,-1816 # 920 <malloc+0xe4>
  40:	4509                	li	a0,2
  42:	71c000ef          	jal	75e <fprintf>
      exit(1);
  46:	4505                	li	a0,1
  48:	306000ef          	jal	34e <exit>
    }
  }
  if(n < 0){
  4c:	00054963          	bltz	a0,5e <cat+0x5e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  50:	70a2                	ld	ra,40(sp)
  52:	7402                	ld	s0,32(sp)
  54:	64e2                	ld	s1,24(sp)
  56:	6942                	ld	s2,16(sp)
  58:	69a2                	ld	s3,8(sp)
  5a:	6145                	add	sp,sp,48
  5c:	8082                	ret
    fprintf(2, "cat: read error\n");
  5e:	00001597          	auipc	a1,0x1
  62:	8da58593          	add	a1,a1,-1830 # 938 <malloc+0xfc>
  66:	4509                	li	a0,2
  68:	6f6000ef          	jal	75e <fprintf>
    exit(1);
  6c:	4505                	li	a0,1
  6e:	2e0000ef          	jal	34e <exit>

0000000000000072 <main>:

int
main(int argc, char *argv[])
{
  72:	7179                	add	sp,sp,-48
  74:	f406                	sd	ra,40(sp)
  76:	f022                	sd	s0,32(sp)
  78:	ec26                	sd	s1,24(sp)
  7a:	e84a                	sd	s2,16(sp)
  7c:	e44e                	sd	s3,8(sp)
  7e:	1800                	add	s0,sp,48
  int fd, i;

  if(argc <= 1){
  80:	4785                	li	a5,1
  82:	02a7df63          	bge	a5,a0,c0 <main+0x4e>
  86:	00858913          	add	s2,a1,8
  8a:	ffe5099b          	addw	s3,a0,-2
  8e:	02099793          	sll	a5,s3,0x20
  92:	01d7d993          	srl	s3,a5,0x1d
  96:	05c1                	add	a1,a1,16
  98:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  9a:	4581                	li	a1,0
  9c:	00093503          	ld	a0,0(s2) # 1010 <buf>
  a0:	2ee000ef          	jal	38e <open>
  a4:	84aa                	mv	s1,a0
  a6:	02054363          	bltz	a0,cc <main+0x5a>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  aa:	f57ff0ef          	jal	0 <cat>
    close(fd);
  ae:	8526                	mv	a0,s1
  b0:	2c6000ef          	jal	376 <close>
  for(i = 1; i < argc; i++){
  b4:	0921                	add	s2,s2,8
  b6:	ff3912e3          	bne	s2,s3,9a <main+0x28>
  }
  exit(0);
  ba:	4501                	li	a0,0
  bc:	292000ef          	jal	34e <exit>
    cat(0);
  c0:	4501                	li	a0,0
  c2:	f3fff0ef          	jal	0 <cat>
    exit(0);
  c6:	4501                	li	a0,0
  c8:	286000ef          	jal	34e <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  cc:	00093603          	ld	a2,0(s2)
  d0:	00001597          	auipc	a1,0x1
  d4:	88058593          	add	a1,a1,-1920 # 950 <malloc+0x114>
  d8:	4509                	li	a0,2
  da:	684000ef          	jal	75e <fprintf>
      exit(1);
  de:	4505                	li	a0,1
  e0:	26e000ef          	jal	34e <exit>

00000000000000e4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  e4:	1141                	add	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	add	s0,sp,16
  extern int main();
  main();
  ec:	f87ff0ef          	jal	72 <main>
  exit(0);
  f0:	4501                	li	a0,0
  f2:	25c000ef          	jal	34e <exit>

00000000000000f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f6:	1141                	add	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fc:	87aa                	mv	a5,a0
  fe:	0585                	add	a1,a1,1
 100:	0785                	add	a5,a5,1
 102:	fff5c703          	lbu	a4,-1(a1)
 106:	fee78fa3          	sb	a4,-1(a5)
 10a:	fb75                	bnez	a4,fe <strcpy+0x8>
    ;
  return os;
}
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	add	sp,sp,16
 110:	8082                	ret

0000000000000112 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 112:	1141                	add	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 118:	00054783          	lbu	a5,0(a0)
 11c:	cb91                	beqz	a5,130 <strcmp+0x1e>
 11e:	0005c703          	lbu	a4,0(a1)
 122:	00f71763          	bne	a4,a5,130 <strcmp+0x1e>
    p++, q++;
 126:	0505                	add	a0,a0,1
 128:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	fbe5                	bnez	a5,11e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 130:	0005c503          	lbu	a0,0(a1)
}
 134:	40a7853b          	subw	a0,a5,a0
 138:	6422                	ld	s0,8(sp)
 13a:	0141                	add	sp,sp,16
 13c:	8082                	ret

000000000000013e <strlen>:

uint
strlen(const char *s)
{
 13e:	1141                	add	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 144:	00054783          	lbu	a5,0(a0)
 148:	cf91                	beqz	a5,164 <strlen+0x26>
 14a:	0505                	add	a0,a0,1
 14c:	87aa                	mv	a5,a0
 14e:	86be                	mv	a3,a5
 150:	0785                	add	a5,a5,1
 152:	fff7c703          	lbu	a4,-1(a5)
 156:	ff65                	bnez	a4,14e <strlen+0x10>
 158:	40a6853b          	subw	a0,a3,a0
 15c:	2505                	addw	a0,a0,1
    ;
  return n;
}
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	add	sp,sp,16
 162:	8082                	ret
  for(n = 0; s[n]; n++)
 164:	4501                	li	a0,0
 166:	bfe5                	j	15e <strlen+0x20>

0000000000000168 <memset>:

void*
memset(void *dst, int c, uint n)
{
 168:	1141                	add	sp,sp,-16
 16a:	e422                	sd	s0,8(sp)
 16c:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 16e:	ca19                	beqz	a2,184 <memset+0x1c>
 170:	87aa                	mv	a5,a0
 172:	1602                	sll	a2,a2,0x20
 174:	9201                	srl	a2,a2,0x20
 176:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 17e:	0785                	add	a5,a5,1
 180:	fee79de3          	bne	a5,a4,17a <memset+0x12>
  }
  return dst;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	add	sp,sp,16
 188:	8082                	ret

000000000000018a <strchr>:

char*
strchr(const char *s, char c)
{
 18a:	1141                	add	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	add	s0,sp,16
  for(; *s; s++)
 190:	00054783          	lbu	a5,0(a0)
 194:	cb99                	beqz	a5,1aa <strchr+0x20>
    if(*s == c)
 196:	00f58763          	beq	a1,a5,1a4 <strchr+0x1a>
  for(; *s; s++)
 19a:	0505                	add	a0,a0,1
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	fbfd                	bnez	a5,196 <strchr+0xc>
      return (char*)s;
  return 0;
 1a2:	4501                	li	a0,0
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	add	sp,sp,16
 1a8:	8082                	ret
  return 0;
 1aa:	4501                	li	a0,0
 1ac:	bfe5                	j	1a4 <strchr+0x1a>

00000000000001ae <gets>:

char*
gets(char *buf, int max)
{
 1ae:	711d                	add	sp,sp,-96
 1b0:	ec86                	sd	ra,88(sp)
 1b2:	e8a2                	sd	s0,80(sp)
 1b4:	e4a6                	sd	s1,72(sp)
 1b6:	e0ca                	sd	s2,64(sp)
 1b8:	fc4e                	sd	s3,56(sp)
 1ba:	f852                	sd	s4,48(sp)
 1bc:	f456                	sd	s5,40(sp)
 1be:	f05a                	sd	s6,32(sp)
 1c0:	ec5e                	sd	s7,24(sp)
 1c2:	1080                	add	s0,sp,96
 1c4:	8baa                	mv	s7,a0
 1c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c8:	892a                	mv	s2,a0
 1ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1cc:	4aa9                	li	s5,10
 1ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d0:	89a6                	mv	s3,s1
 1d2:	2485                	addw	s1,s1,1
 1d4:	0344d663          	bge	s1,s4,200 <gets+0x52>
    cc = read(0, &c, 1);
 1d8:	4605                	li	a2,1
 1da:	faf40593          	add	a1,s0,-81
 1de:	4501                	li	a0,0
 1e0:	186000ef          	jal	366 <read>
    if(cc < 1)
 1e4:	00a05e63          	blez	a0,200 <gets+0x52>
    buf[i++] = c;
 1e8:	faf44783          	lbu	a5,-81(s0)
 1ec:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f0:	01578763          	beq	a5,s5,1fe <gets+0x50>
 1f4:	0905                	add	s2,s2,1
 1f6:	fd679de3          	bne	a5,s6,1d0 <gets+0x22>
  for(i=0; i+1 < max; ){
 1fa:	89a6                	mv	s3,s1
 1fc:	a011                	j	200 <gets+0x52>
 1fe:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 200:	99de                	add	s3,s3,s7
 202:	00098023          	sb	zero,0(s3)
  return buf;
}
 206:	855e                	mv	a0,s7
 208:	60e6                	ld	ra,88(sp)
 20a:	6446                	ld	s0,80(sp)
 20c:	64a6                	ld	s1,72(sp)
 20e:	6906                	ld	s2,64(sp)
 210:	79e2                	ld	s3,56(sp)
 212:	7a42                	ld	s4,48(sp)
 214:	7aa2                	ld	s5,40(sp)
 216:	7b02                	ld	s6,32(sp)
 218:	6be2                	ld	s7,24(sp)
 21a:	6125                	add	sp,sp,96
 21c:	8082                	ret

000000000000021e <stat>:

int
stat(const char *n, struct stat *st)
{
 21e:	1101                	add	sp,sp,-32
 220:	ec06                	sd	ra,24(sp)
 222:	e822                	sd	s0,16(sp)
 224:	e426                	sd	s1,8(sp)
 226:	e04a                	sd	s2,0(sp)
 228:	1000                	add	s0,sp,32
 22a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22c:	4581                	li	a1,0
 22e:	160000ef          	jal	38e <open>
  if(fd < 0)
 232:	02054163          	bltz	a0,254 <stat+0x36>
 236:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 238:	85ca                	mv	a1,s2
 23a:	16c000ef          	jal	3a6 <fstat>
 23e:	892a                	mv	s2,a0
  close(fd);
 240:	8526                	mv	a0,s1
 242:	134000ef          	jal	376 <close>
  return r;
}
 246:	854a                	mv	a0,s2
 248:	60e2                	ld	ra,24(sp)
 24a:	6442                	ld	s0,16(sp)
 24c:	64a2                	ld	s1,8(sp)
 24e:	6902                	ld	s2,0(sp)
 250:	6105                	add	sp,sp,32
 252:	8082                	ret
    return -1;
 254:	597d                	li	s2,-1
 256:	bfc5                	j	246 <stat+0x28>

0000000000000258 <atoi>:

int
atoi(const char *s)
{
 258:	1141                	add	sp,sp,-16
 25a:	e422                	sd	s0,8(sp)
 25c:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25e:	00054683          	lbu	a3,0(a0)
 262:	fd06879b          	addw	a5,a3,-48
 266:	0ff7f793          	zext.b	a5,a5
 26a:	4625                	li	a2,9
 26c:	02f66863          	bltu	a2,a5,29c <atoi+0x44>
 270:	872a                	mv	a4,a0
  n = 0;
 272:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 274:	0705                	add	a4,a4,1
 276:	0025179b          	sllw	a5,a0,0x2
 27a:	9fa9                	addw	a5,a5,a0
 27c:	0017979b          	sllw	a5,a5,0x1
 280:	9fb5                	addw	a5,a5,a3
 282:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 286:	00074683          	lbu	a3,0(a4)
 28a:	fd06879b          	addw	a5,a3,-48
 28e:	0ff7f793          	zext.b	a5,a5
 292:	fef671e3          	bgeu	a2,a5,274 <atoi+0x1c>
  return n;
}
 296:	6422                	ld	s0,8(sp)
 298:	0141                	add	sp,sp,16
 29a:	8082                	ret
  n = 0;
 29c:	4501                	li	a0,0
 29e:	bfe5                	j	296 <atoi+0x3e>

00000000000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	1141                	add	sp,sp,-16
 2a2:	e422                	sd	s0,8(sp)
 2a4:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a6:	02b57463          	bgeu	a0,a1,2ce <memmove+0x2e>
    while(n-- > 0)
 2aa:	00c05f63          	blez	a2,2c8 <memmove+0x28>
 2ae:	1602                	sll	a2,a2,0x20
 2b0:	9201                	srl	a2,a2,0x20
 2b2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b8:	0585                	add	a1,a1,1
 2ba:	0705                	add	a4,a4,1
 2bc:	fff5c683          	lbu	a3,-1(a1)
 2c0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c4:	fee79ae3          	bne	a5,a4,2b8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	add	sp,sp,16
 2cc:	8082                	ret
    dst += n;
 2ce:	00c50733          	add	a4,a0,a2
    src += n;
 2d2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2d4:	fec05ae3          	blez	a2,2c8 <memmove+0x28>
 2d8:	fff6079b          	addw	a5,a2,-1
 2dc:	1782                	sll	a5,a5,0x20
 2de:	9381                	srl	a5,a5,0x20
 2e0:	fff7c793          	not	a5,a5
 2e4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e6:	15fd                	add	a1,a1,-1
 2e8:	177d                	add	a4,a4,-1
 2ea:	0005c683          	lbu	a3,0(a1)
 2ee:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f2:	fee79ae3          	bne	a5,a4,2e6 <memmove+0x46>
 2f6:	bfc9                	j	2c8 <memmove+0x28>

00000000000002f8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f8:	1141                	add	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fe:	ca05                	beqz	a2,32e <memcmp+0x36>
 300:	fff6069b          	addw	a3,a2,-1
 304:	1682                	sll	a3,a3,0x20
 306:	9281                	srl	a3,a3,0x20
 308:	0685                	add	a3,a3,1
 30a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 30c:	00054783          	lbu	a5,0(a0)
 310:	0005c703          	lbu	a4,0(a1)
 314:	00e79863          	bne	a5,a4,324 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 318:	0505                	add	a0,a0,1
    p2++;
 31a:	0585                	add	a1,a1,1
  while (n-- > 0) {
 31c:	fed518e3          	bne	a0,a3,30c <memcmp+0x14>
  }
  return 0;
 320:	4501                	li	a0,0
 322:	a019                	j	328 <memcmp+0x30>
      return *p1 - *p2;
 324:	40e7853b          	subw	a0,a5,a4
}
 328:	6422                	ld	s0,8(sp)
 32a:	0141                	add	sp,sp,16
 32c:	8082                	ret
  return 0;
 32e:	4501                	li	a0,0
 330:	bfe5                	j	328 <memcmp+0x30>

0000000000000332 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 332:	1141                	add	sp,sp,-16
 334:	e406                	sd	ra,8(sp)
 336:	e022                	sd	s0,0(sp)
 338:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 33a:	f67ff0ef          	jal	2a0 <memmove>
}
 33e:	60a2                	ld	ra,8(sp)
 340:	6402                	ld	s0,0(sp)
 342:	0141                	add	sp,sp,16
 344:	8082                	ret

0000000000000346 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 346:	4885                	li	a7,1
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <exit>:
.global exit
exit:
 li a7, SYS_exit
 34e:	4889                	li	a7,2
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <wait>:
.global wait
wait:
 li a7, SYS_wait
 356:	488d                	li	a7,3
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 35e:	4891                	li	a7,4
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <read>:
.global read
read:
 li a7, SYS_read
 366:	4895                	li	a7,5
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <write>:
.global write
write:
 li a7, SYS_write
 36e:	48c1                	li	a7,16
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <close>:
.global close
close:
 li a7, SYS_close
 376:	48d5                	li	a7,21
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <kill>:
.global kill
kill:
 li a7, SYS_kill
 37e:	4899                	li	a7,6
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <exec>:
.global exec
exec:
 li a7, SYS_exec
 386:	489d                	li	a7,7
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <open>:
.global open
open:
 li a7, SYS_open
 38e:	48bd                	li	a7,15
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 396:	48c5                	li	a7,17
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 39e:	48c9                	li	a7,18
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a6:	48a1                	li	a7,8
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <link>:
.global link
link:
 li a7, SYS_link
 3ae:	48cd                	li	a7,19
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b6:	48d1                	li	a7,20
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3be:	48a5                	li	a7,9
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c6:	48a9                	li	a7,10
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ce:	48ad                	li	a7,11
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d6:	48b1                	li	a7,12
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3de:	48b5                	li	a7,13
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e6:	48b9                	li	a7,14
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 3ee:	48d9                	li	a7,22
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 3f6:	48e1                	li	a7,24
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 3fe:	48dd                	li	a7,23
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 406:	48e5                	li	a7,25
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40e:	1101                	add	sp,sp,-32
 410:	ec06                	sd	ra,24(sp)
 412:	e822                	sd	s0,16(sp)
 414:	1000                	add	s0,sp,32
 416:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41a:	4605                	li	a2,1
 41c:	fef40593          	add	a1,s0,-17
 420:	f4fff0ef          	jal	36e <write>
}
 424:	60e2                	ld	ra,24(sp)
 426:	6442                	ld	s0,16(sp)
 428:	6105                	add	sp,sp,32
 42a:	8082                	ret

000000000000042c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42c:	7139                	add	sp,sp,-64
 42e:	fc06                	sd	ra,56(sp)
 430:	f822                	sd	s0,48(sp)
 432:	f426                	sd	s1,40(sp)
 434:	f04a                	sd	s2,32(sp)
 436:	ec4e                	sd	s3,24(sp)
 438:	0080                	add	s0,sp,64
 43a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43c:	c299                	beqz	a3,442 <printint+0x16>
 43e:	0805c763          	bltz	a1,4cc <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 442:	2581                	sext.w	a1,a1
  neg = 0;
 444:	4881                	li	a7,0
 446:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 44a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 44c:	2601                	sext.w	a2,a2
 44e:	00000517          	auipc	a0,0x0
 452:	52250513          	add	a0,a0,1314 # 970 <digits>
 456:	883a                	mv	a6,a4
 458:	2705                	addw	a4,a4,1
 45a:	02c5f7bb          	remuw	a5,a1,a2
 45e:	1782                	sll	a5,a5,0x20
 460:	9381                	srl	a5,a5,0x20
 462:	97aa                	add	a5,a5,a0
 464:	0007c783          	lbu	a5,0(a5)
 468:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 46c:	0005879b          	sext.w	a5,a1
 470:	02c5d5bb          	divuw	a1,a1,a2
 474:	0685                	add	a3,a3,1
 476:	fec7f0e3          	bgeu	a5,a2,456 <printint+0x2a>
  if(neg)
 47a:	00088c63          	beqz	a7,492 <printint+0x66>
    buf[i++] = '-';
 47e:	fd070793          	add	a5,a4,-48
 482:	00878733          	add	a4,a5,s0
 486:	02d00793          	li	a5,45
 48a:	fef70823          	sb	a5,-16(a4)
 48e:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 492:	02e05663          	blez	a4,4be <printint+0x92>
 496:	fc040793          	add	a5,s0,-64
 49a:	00e78933          	add	s2,a5,a4
 49e:	fff78993          	add	s3,a5,-1
 4a2:	99ba                	add	s3,s3,a4
 4a4:	377d                	addw	a4,a4,-1
 4a6:	1702                	sll	a4,a4,0x20
 4a8:	9301                	srl	a4,a4,0x20
 4aa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ae:	fff94583          	lbu	a1,-1(s2)
 4b2:	8526                	mv	a0,s1
 4b4:	f5bff0ef          	jal	40e <putc>
  while(--i >= 0)
 4b8:	197d                	add	s2,s2,-1
 4ba:	ff391ae3          	bne	s2,s3,4ae <printint+0x82>
}
 4be:	70e2                	ld	ra,56(sp)
 4c0:	7442                	ld	s0,48(sp)
 4c2:	74a2                	ld	s1,40(sp)
 4c4:	7902                	ld	s2,32(sp)
 4c6:	69e2                	ld	s3,24(sp)
 4c8:	6121                	add	sp,sp,64
 4ca:	8082                	ret
    x = -xx;
 4cc:	40b005bb          	negw	a1,a1
    neg = 1;
 4d0:	4885                	li	a7,1
    x = -xx;
 4d2:	bf95                	j	446 <printint+0x1a>

00000000000004d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d4:	711d                	add	sp,sp,-96
 4d6:	ec86                	sd	ra,88(sp)
 4d8:	e8a2                	sd	s0,80(sp)
 4da:	e4a6                	sd	s1,72(sp)
 4dc:	e0ca                	sd	s2,64(sp)
 4de:	fc4e                	sd	s3,56(sp)
 4e0:	f852                	sd	s4,48(sp)
 4e2:	f456                	sd	s5,40(sp)
 4e4:	f05a                	sd	s6,32(sp)
 4e6:	ec5e                	sd	s7,24(sp)
 4e8:	e862                	sd	s8,16(sp)
 4ea:	e466                	sd	s9,8(sp)
 4ec:	e06a                	sd	s10,0(sp)
 4ee:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f0:	0005c903          	lbu	s2,0(a1)
 4f4:	24090763          	beqz	s2,742 <vprintf+0x26e>
 4f8:	8b2a                	mv	s6,a0
 4fa:	8a2e                	mv	s4,a1
 4fc:	8bb2                	mv	s7,a2
  state = 0;
 4fe:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 500:	4481                	li	s1,0
 502:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 504:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 508:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 50c:	06c00c93          	li	s9,108
 510:	a005                	j	530 <vprintf+0x5c>
        putc(fd, c0);
 512:	85ca                	mv	a1,s2
 514:	855a                	mv	a0,s6
 516:	ef9ff0ef          	jal	40e <putc>
 51a:	a019                	j	520 <vprintf+0x4c>
    } else if(state == '%'){
 51c:	03598263          	beq	s3,s5,540 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 520:	2485                	addw	s1,s1,1
 522:	8726                	mv	a4,s1
 524:	009a07b3          	add	a5,s4,s1
 528:	0007c903          	lbu	s2,0(a5)
 52c:	20090b63          	beqz	s2,742 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 530:	0009079b          	sext.w	a5,s2
    if(state == 0){
 534:	fe0994e3          	bnez	s3,51c <vprintf+0x48>
      if(c0 == '%'){
 538:	fd579de3          	bne	a5,s5,512 <vprintf+0x3e>
        state = '%';
 53c:	89be                	mv	s3,a5
 53e:	b7cd                	j	520 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 540:	c7c9                	beqz	a5,5ca <vprintf+0xf6>
 542:	00ea06b3          	add	a3,s4,a4
 546:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 54a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 54c:	c681                	beqz	a3,554 <vprintf+0x80>
 54e:	9752                	add	a4,a4,s4
 550:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 554:	03878f63          	beq	a5,s8,592 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 558:	05978963          	beq	a5,s9,5aa <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 55c:	07500713          	li	a4,117
 560:	0ee78363          	beq	a5,a4,646 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 564:	07800713          	li	a4,120
 568:	12e78563          	beq	a5,a4,692 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 56c:	07000713          	li	a4,112
 570:	14e78a63          	beq	a5,a4,6c4 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 574:	07300713          	li	a4,115
 578:	18e78863          	beq	a5,a4,708 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 57c:	02500713          	li	a4,37
 580:	04e79563          	bne	a5,a4,5ca <vprintf+0xf6>
        putc(fd, '%');
 584:	02500593          	li	a1,37
 588:	855a                	mv	a0,s6
 58a:	e85ff0ef          	jal	40e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 58e:	4981                	li	s3,0
 590:	bf41                	j	520 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 592:	008b8913          	add	s2,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	e8dff0ef          	jal	42c <printint>
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	bfa5                	j	520 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 5aa:	06400793          	li	a5,100
 5ae:	02f68963          	beq	a3,a5,5e0 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b2:	06c00793          	li	a5,108
 5b6:	04f68263          	beq	a3,a5,5fa <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 5ba:	07500793          	li	a5,117
 5be:	0af68063          	beq	a3,a5,65e <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 5c2:	07800793          	li	a5,120
 5c6:	0ef68263          	beq	a3,a5,6aa <vprintf+0x1d6>
        putc(fd, '%');
 5ca:	02500593          	li	a1,37
 5ce:	855a                	mv	a0,s6
 5d0:	e3fff0ef          	jal	40e <putc>
        putc(fd, c0);
 5d4:	85ca                	mv	a1,s2
 5d6:	855a                	mv	a0,s6
 5d8:	e37ff0ef          	jal	40e <putc>
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b789                	j	520 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e0:	008b8913          	add	s2,s7,8
 5e4:	4685                	li	a3,1
 5e6:	4629                	li	a2,10
 5e8:	000ba583          	lw	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	e3fff0ef          	jal	42c <printint>
        i += 1;
 5f2:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
        i += 1;
 5f8:	b725                	j	520 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5fa:	06400793          	li	a5,100
 5fe:	02f60763          	beq	a2,a5,62c <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 602:	07500793          	li	a5,117
 606:	06f60963          	beq	a2,a5,678 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 60a:	07800793          	li	a5,120
 60e:	faf61ee3          	bne	a2,a5,5ca <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 612:	008b8913          	add	s2,s7,8
 616:	4681                	li	a3,0
 618:	4641                	li	a2,16
 61a:	000ba583          	lw	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	e0dff0ef          	jal	42c <printint>
        i += 2;
 624:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 626:	8bca                	mv	s7,s2
      state = 0;
 628:	4981                	li	s3,0
        i += 2;
 62a:	bddd                	j	520 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 62c:	008b8913          	add	s2,s7,8
 630:	4685                	li	a3,1
 632:	4629                	li	a2,10
 634:	000ba583          	lw	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	df3ff0ef          	jal	42c <printint>
        i += 2;
 63e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 640:	8bca                	mv	s7,s2
      state = 0;
 642:	4981                	li	s3,0
        i += 2;
 644:	bdf1                	j	520 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 646:	008b8913          	add	s2,s7,8
 64a:	4681                	li	a3,0
 64c:	4629                	li	a2,10
 64e:	000ba583          	lw	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	dd9ff0ef          	jal	42c <printint>
 658:	8bca                	mv	s7,s2
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b5d1                	j	520 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65e:	008b8913          	add	s2,s7,8
 662:	4681                	li	a3,0
 664:	4629                	li	a2,10
 666:	000ba583          	lw	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	dc1ff0ef          	jal	42c <printint>
        i += 1;
 670:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 672:	8bca                	mv	s7,s2
      state = 0;
 674:	4981                	li	s3,0
        i += 1;
 676:	b56d                	j	520 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 678:	008b8913          	add	s2,s7,8
 67c:	4681                	li	a3,0
 67e:	4629                	li	a2,10
 680:	000ba583          	lw	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	da7ff0ef          	jal	42c <printint>
        i += 2;
 68a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 68c:	8bca                	mv	s7,s2
      state = 0;
 68e:	4981                	li	s3,0
        i += 2;
 690:	bd41                	j	520 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 692:	008b8913          	add	s2,s7,8
 696:	4681                	li	a3,0
 698:	4641                	li	a2,16
 69a:	000ba583          	lw	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	d8dff0ef          	jal	42c <printint>
 6a4:	8bca                	mv	s7,s2
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bda5                	j	520 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6aa:	008b8913          	add	s2,s7,8
 6ae:	4681                	li	a3,0
 6b0:	4641                	li	a2,16
 6b2:	000ba583          	lw	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	d75ff0ef          	jal	42c <printint>
        i += 1;
 6bc:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6be:	8bca                	mv	s7,s2
      state = 0;
 6c0:	4981                	li	s3,0
        i += 1;
 6c2:	bdb9                	j	520 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 6c4:	008b8d13          	add	s10,s7,8
 6c8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6cc:	03000593          	li	a1,48
 6d0:	855a                	mv	a0,s6
 6d2:	d3dff0ef          	jal	40e <putc>
  putc(fd, 'x');
 6d6:	07800593          	li	a1,120
 6da:	855a                	mv	a0,s6
 6dc:	d33ff0ef          	jal	40e <putc>
 6e0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e2:	00000b97          	auipc	s7,0x0
 6e6:	28eb8b93          	add	s7,s7,654 # 970 <digits>
 6ea:	03c9d793          	srl	a5,s3,0x3c
 6ee:	97de                	add	a5,a5,s7
 6f0:	0007c583          	lbu	a1,0(a5)
 6f4:	855a                	mv	a0,s6
 6f6:	d19ff0ef          	jal	40e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6fa:	0992                	sll	s3,s3,0x4
 6fc:	397d                	addw	s2,s2,-1
 6fe:	fe0916e3          	bnez	s2,6ea <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 702:	8bea                	mv	s7,s10
      state = 0;
 704:	4981                	li	s3,0
 706:	bd29                	j	520 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 708:	008b8993          	add	s3,s7,8
 70c:	000bb903          	ld	s2,0(s7)
 710:	00090f63          	beqz	s2,72e <vprintf+0x25a>
        for(; *s; s++)
 714:	00094583          	lbu	a1,0(s2)
 718:	c195                	beqz	a1,73c <vprintf+0x268>
          putc(fd, *s);
 71a:	855a                	mv	a0,s6
 71c:	cf3ff0ef          	jal	40e <putc>
        for(; *s; s++)
 720:	0905                	add	s2,s2,1
 722:	00094583          	lbu	a1,0(s2)
 726:	f9f5                	bnez	a1,71a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 728:	8bce                	mv	s7,s3
      state = 0;
 72a:	4981                	li	s3,0
 72c:	bbd5                	j	520 <vprintf+0x4c>
          s = "(null)";
 72e:	00000917          	auipc	s2,0x0
 732:	23a90913          	add	s2,s2,570 # 968 <malloc+0x12c>
        for(; *s; s++)
 736:	02800593          	li	a1,40
 73a:	b7c5                	j	71a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 73c:	8bce                	mv	s7,s3
      state = 0;
 73e:	4981                	li	s3,0
 740:	b3c5                	j	520 <vprintf+0x4c>
    }
  }
}
 742:	60e6                	ld	ra,88(sp)
 744:	6446                	ld	s0,80(sp)
 746:	64a6                	ld	s1,72(sp)
 748:	6906                	ld	s2,64(sp)
 74a:	79e2                	ld	s3,56(sp)
 74c:	7a42                	ld	s4,48(sp)
 74e:	7aa2                	ld	s5,40(sp)
 750:	7b02                	ld	s6,32(sp)
 752:	6be2                	ld	s7,24(sp)
 754:	6c42                	ld	s8,16(sp)
 756:	6ca2                	ld	s9,8(sp)
 758:	6d02                	ld	s10,0(sp)
 75a:	6125                	add	sp,sp,96
 75c:	8082                	ret

000000000000075e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 75e:	715d                	add	sp,sp,-80
 760:	ec06                	sd	ra,24(sp)
 762:	e822                	sd	s0,16(sp)
 764:	1000                	add	s0,sp,32
 766:	e010                	sd	a2,0(s0)
 768:	e414                	sd	a3,8(s0)
 76a:	e818                	sd	a4,16(s0)
 76c:	ec1c                	sd	a5,24(s0)
 76e:	03043023          	sd	a6,32(s0)
 772:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 776:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 77a:	8622                	mv	a2,s0
 77c:	d59ff0ef          	jal	4d4 <vprintf>
}
 780:	60e2                	ld	ra,24(sp)
 782:	6442                	ld	s0,16(sp)
 784:	6161                	add	sp,sp,80
 786:	8082                	ret

0000000000000788 <printf>:

void
printf(const char *fmt, ...)
{
 788:	711d                	add	sp,sp,-96
 78a:	ec06                	sd	ra,24(sp)
 78c:	e822                	sd	s0,16(sp)
 78e:	1000                	add	s0,sp,32
 790:	e40c                	sd	a1,8(s0)
 792:	e810                	sd	a2,16(s0)
 794:	ec14                	sd	a3,24(s0)
 796:	f018                	sd	a4,32(s0)
 798:	f41c                	sd	a5,40(s0)
 79a:	03043823          	sd	a6,48(s0)
 79e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a2:	00840613          	add	a2,s0,8
 7a6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7aa:	85aa                	mv	a1,a0
 7ac:	4505                	li	a0,1
 7ae:	d27ff0ef          	jal	4d4 <vprintf>
}
 7b2:	60e2                	ld	ra,24(sp)
 7b4:	6442                	ld	s0,16(sp)
 7b6:	6125                	add	sp,sp,96
 7b8:	8082                	ret

00000000000007ba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ba:	1141                	add	sp,sp,-16
 7bc:	e422                	sd	s0,8(sp)
 7be:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c0:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c4:	00001797          	auipc	a5,0x1
 7c8:	83c7b783          	ld	a5,-1988(a5) # 1000 <freep>
 7cc:	a02d                	j	7f6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ce:	4618                	lw	a4,8(a2)
 7d0:	9f2d                	addw	a4,a4,a1
 7d2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	6398                	ld	a4,0(a5)
 7d8:	6310                	ld	a2,0(a4)
 7da:	a83d                	j	818 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7dc:	ff852703          	lw	a4,-8(a0)
 7e0:	9f31                	addw	a4,a4,a2
 7e2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7e4:	ff053683          	ld	a3,-16(a0)
 7e8:	a091                	j	82c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ea:	6398                	ld	a4,0(a5)
 7ec:	00e7e463          	bltu	a5,a4,7f4 <free+0x3a>
 7f0:	00e6ea63          	bltu	a3,a4,804 <free+0x4a>
{
 7f4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f6:	fed7fae3          	bgeu	a5,a3,7ea <free+0x30>
 7fa:	6398                	ld	a4,0(a5)
 7fc:	00e6e463          	bltu	a3,a4,804 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 800:	fee7eae3          	bltu	a5,a4,7f4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 804:	ff852583          	lw	a1,-8(a0)
 808:	6390                	ld	a2,0(a5)
 80a:	02059813          	sll	a6,a1,0x20
 80e:	01c85713          	srl	a4,a6,0x1c
 812:	9736                	add	a4,a4,a3
 814:	fae60de3          	beq	a2,a4,7ce <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 818:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 81c:	4790                	lw	a2,8(a5)
 81e:	02061593          	sll	a1,a2,0x20
 822:	01c5d713          	srl	a4,a1,0x1c
 826:	973e                	add	a4,a4,a5
 828:	fae68ae3          	beq	a3,a4,7dc <free+0x22>
    p->s.ptr = bp->s.ptr;
 82c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 82e:	00000717          	auipc	a4,0x0
 832:	7cf73923          	sd	a5,2002(a4) # 1000 <freep>
}
 836:	6422                	ld	s0,8(sp)
 838:	0141                	add	sp,sp,16
 83a:	8082                	ret

000000000000083c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 83c:	7139                	add	sp,sp,-64
 83e:	fc06                	sd	ra,56(sp)
 840:	f822                	sd	s0,48(sp)
 842:	f426                	sd	s1,40(sp)
 844:	f04a                	sd	s2,32(sp)
 846:	ec4e                	sd	s3,24(sp)
 848:	e852                	sd	s4,16(sp)
 84a:	e456                	sd	s5,8(sp)
 84c:	e05a                	sd	s6,0(sp)
 84e:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 850:	02051493          	sll	s1,a0,0x20
 854:	9081                	srl	s1,s1,0x20
 856:	04bd                	add	s1,s1,15
 858:	8091                	srl	s1,s1,0x4
 85a:	0014899b          	addw	s3,s1,1
 85e:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 860:	00000517          	auipc	a0,0x0
 864:	7a053503          	ld	a0,1952(a0) # 1000 <freep>
 868:	c515                	beqz	a0,894 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86c:	4798                	lw	a4,8(a5)
 86e:	02977f63          	bgeu	a4,s1,8ac <malloc+0x70>
  if(nu < 4096)
 872:	8a4e                	mv	s4,s3
 874:	0009871b          	sext.w	a4,s3
 878:	6685                	lui	a3,0x1
 87a:	00d77363          	bgeu	a4,a3,880 <malloc+0x44>
 87e:	6a05                	lui	s4,0x1
 880:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 884:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 888:	00000917          	auipc	s2,0x0
 88c:	77890913          	add	s2,s2,1912 # 1000 <freep>
  if(p == (char*)-1)
 890:	5afd                	li	s5,-1
 892:	a885                	j	902 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 894:	00001797          	auipc	a5,0x1
 898:	97c78793          	add	a5,a5,-1668 # 1210 <base>
 89c:	00000717          	auipc	a4,0x0
 8a0:	76f73223          	sd	a5,1892(a4) # 1000 <freep>
 8a4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8aa:	b7e1                	j	872 <malloc+0x36>
      if(p->s.size == nunits)
 8ac:	02e48c63          	beq	s1,a4,8e4 <malloc+0xa8>
        p->s.size -= nunits;
 8b0:	4137073b          	subw	a4,a4,s3
 8b4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b6:	02071693          	sll	a3,a4,0x20
 8ba:	01c6d713          	srl	a4,a3,0x1c
 8be:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c4:	00000717          	auipc	a4,0x0
 8c8:	72a73e23          	sd	a0,1852(a4) # 1000 <freep>
      return (void*)(p + 1);
 8cc:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8d0:	70e2                	ld	ra,56(sp)
 8d2:	7442                	ld	s0,48(sp)
 8d4:	74a2                	ld	s1,40(sp)
 8d6:	7902                	ld	s2,32(sp)
 8d8:	69e2                	ld	s3,24(sp)
 8da:	6a42                	ld	s4,16(sp)
 8dc:	6aa2                	ld	s5,8(sp)
 8de:	6b02                	ld	s6,0(sp)
 8e0:	6121                	add	sp,sp,64
 8e2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8e4:	6398                	ld	a4,0(a5)
 8e6:	e118                	sd	a4,0(a0)
 8e8:	bff1                	j	8c4 <malloc+0x88>
  hp->s.size = nu;
 8ea:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ee:	0541                	add	a0,a0,16
 8f0:	ecbff0ef          	jal	7ba <free>
  return freep;
 8f4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f8:	dd61                	beqz	a0,8d0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fc:	4798                	lw	a4,8(a5)
 8fe:	fa9777e3          	bgeu	a4,s1,8ac <malloc+0x70>
    if(p == freep)
 902:	00093703          	ld	a4,0(s2)
 906:	853e                	mv	a0,a5
 908:	fef719e3          	bne	a4,a5,8fa <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 90c:	8552                	mv	a0,s4
 90e:	ac9ff0ef          	jal	3d6 <sbrk>
  if(p == (char*)-1)
 912:	fd551ce3          	bne	a0,s5,8ea <malloc+0xae>
        return 0;
 916:	4501                	li	a0,0
 918:	bf65                	j	8d0 <malloc+0x94>
