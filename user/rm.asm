
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7d563          	bge	a5,a0,38 <main+0x38>
  12:	00858493          	add	s1,a1,8
  16:	ffe5091b          	addw	s2,a0,-2
  1a:	02091793          	sll	a5,s2,0x20
  1e:	01d7d913          	srl	s2,a5,0x1d
  22:	05c1                	add	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	2f4000ef          	jal	31c <unlink>
  2c:	02054063          	bltz	a0,4c <main+0x4c>
  for(i = 1; i < argc; i++){
  30:	04a1                	add	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  36:	a01d                	j	5c <main+0x5c>
    fprintf(2, "Usage: rm files...\n");
  38:	00001597          	auipc	a1,0x1
  3c:	86858593          	add	a1,a1,-1944 # 8a0 <malloc+0xe6>
  40:	4509                	li	a0,2
  42:	69a000ef          	jal	6dc <fprintf>
    exit(1);
  46:	4505                	li	a0,1
  48:	284000ef          	jal	2cc <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  4c:	6090                	ld	a2,0(s1)
  4e:	00001597          	auipc	a1,0x1
  52:	86a58593          	add	a1,a1,-1942 # 8b8 <malloc+0xfe>
  56:	4509                	li	a0,2
  58:	684000ef          	jal	6dc <fprintf>
      break;
    }
  }

  exit(0);
  5c:	4501                	li	a0,0
  5e:	26e000ef          	jal	2cc <exit>

0000000000000062 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  62:	1141                	add	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	add	s0,sp,16
  extern int main();
  main();
  6a:	f97ff0ef          	jal	0 <main>
  exit(0);
  6e:	4501                	li	a0,0
  70:	25c000ef          	jal	2cc <exit>

0000000000000074 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  74:	1141                	add	sp,sp,-16
  76:	e422                	sd	s0,8(sp)
  78:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7a:	87aa                	mv	a5,a0
  7c:	0585                	add	a1,a1,1
  7e:	0785                	add	a5,a5,1
  80:	fff5c703          	lbu	a4,-1(a1)
  84:	fee78fa3          	sb	a4,-1(a5)
  88:	fb75                	bnez	a4,7c <strcpy+0x8>
    ;
  return os;
}
  8a:	6422                	ld	s0,8(sp)
  8c:	0141                	add	sp,sp,16
  8e:	8082                	ret

0000000000000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	1141                	add	sp,sp,-16
  92:	e422                	sd	s0,8(sp)
  94:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  96:	00054783          	lbu	a5,0(a0)
  9a:	cb91                	beqz	a5,ae <strcmp+0x1e>
  9c:	0005c703          	lbu	a4,0(a1)
  a0:	00f71763          	bne	a4,a5,ae <strcmp+0x1e>
    p++, q++;
  a4:	0505                	add	a0,a0,1
  a6:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  a8:	00054783          	lbu	a5,0(a0)
  ac:	fbe5                	bnez	a5,9c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ae:	0005c503          	lbu	a0,0(a1)
}
  b2:	40a7853b          	subw	a0,a5,a0
  b6:	6422                	ld	s0,8(sp)
  b8:	0141                	add	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strlen>:

uint
strlen(const char *s)
{
  bc:	1141                	add	sp,sp,-16
  be:	e422                	sd	s0,8(sp)
  c0:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c2:	00054783          	lbu	a5,0(a0)
  c6:	cf91                	beqz	a5,e2 <strlen+0x26>
  c8:	0505                	add	a0,a0,1
  ca:	87aa                	mv	a5,a0
  cc:	86be                	mv	a3,a5
  ce:	0785                	add	a5,a5,1
  d0:	fff7c703          	lbu	a4,-1(a5)
  d4:	ff65                	bnez	a4,cc <strlen+0x10>
  d6:	40a6853b          	subw	a0,a3,a0
  da:	2505                	addw	a0,a0,1
    ;
  return n;
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	add	sp,sp,16
  e0:	8082                	ret
  for(n = 0; s[n]; n++)
  e2:	4501                	li	a0,0
  e4:	bfe5                	j	dc <strlen+0x20>

00000000000000e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e6:	1141                	add	sp,sp,-16
  e8:	e422                	sd	s0,8(sp)
  ea:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ec:	ca19                	beqz	a2,102 <memset+0x1c>
  ee:	87aa                	mv	a5,a0
  f0:	1602                	sll	a2,a2,0x20
  f2:	9201                	srl	a2,a2,0x20
  f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  fc:	0785                	add	a5,a5,1
  fe:	fee79de3          	bne	a5,a4,f8 <memset+0x12>
  }
  return dst;
}
 102:	6422                	ld	s0,8(sp)
 104:	0141                	add	sp,sp,16
 106:	8082                	ret

0000000000000108 <strchr>:

char*
strchr(const char *s, char c)
{
 108:	1141                	add	sp,sp,-16
 10a:	e422                	sd	s0,8(sp)
 10c:	0800                	add	s0,sp,16
  for(; *s; s++)
 10e:	00054783          	lbu	a5,0(a0)
 112:	cb99                	beqz	a5,128 <strchr+0x20>
    if(*s == c)
 114:	00f58763          	beq	a1,a5,122 <strchr+0x1a>
  for(; *s; s++)
 118:	0505                	add	a0,a0,1
 11a:	00054783          	lbu	a5,0(a0)
 11e:	fbfd                	bnez	a5,114 <strchr+0xc>
      return (char*)s;
  return 0;
 120:	4501                	li	a0,0
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	add	sp,sp,16
 126:	8082                	ret
  return 0;
 128:	4501                	li	a0,0
 12a:	bfe5                	j	122 <strchr+0x1a>

000000000000012c <gets>:

char*
gets(char *buf, int max)
{
 12c:	711d                	add	sp,sp,-96
 12e:	ec86                	sd	ra,88(sp)
 130:	e8a2                	sd	s0,80(sp)
 132:	e4a6                	sd	s1,72(sp)
 134:	e0ca                	sd	s2,64(sp)
 136:	fc4e                	sd	s3,56(sp)
 138:	f852                	sd	s4,48(sp)
 13a:	f456                	sd	s5,40(sp)
 13c:	f05a                	sd	s6,32(sp)
 13e:	ec5e                	sd	s7,24(sp)
 140:	1080                	add	s0,sp,96
 142:	8baa                	mv	s7,a0
 144:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 146:	892a                	mv	s2,a0
 148:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14a:	4aa9                	li	s5,10
 14c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 14e:	89a6                	mv	s3,s1
 150:	2485                	addw	s1,s1,1
 152:	0344d663          	bge	s1,s4,17e <gets+0x52>
    cc = read(0, &c, 1);
 156:	4605                	li	a2,1
 158:	faf40593          	add	a1,s0,-81
 15c:	4501                	li	a0,0
 15e:	186000ef          	jal	2e4 <read>
    if(cc < 1)
 162:	00a05e63          	blez	a0,17e <gets+0x52>
    buf[i++] = c;
 166:	faf44783          	lbu	a5,-81(s0)
 16a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 16e:	01578763          	beq	a5,s5,17c <gets+0x50>
 172:	0905                	add	s2,s2,1
 174:	fd679de3          	bne	a5,s6,14e <gets+0x22>
  for(i=0; i+1 < max; ){
 178:	89a6                	mv	s3,s1
 17a:	a011                	j	17e <gets+0x52>
 17c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 17e:	99de                	add	s3,s3,s7
 180:	00098023          	sb	zero,0(s3)
  return buf;
}
 184:	855e                	mv	a0,s7
 186:	60e6                	ld	ra,88(sp)
 188:	6446                	ld	s0,80(sp)
 18a:	64a6                	ld	s1,72(sp)
 18c:	6906                	ld	s2,64(sp)
 18e:	79e2                	ld	s3,56(sp)
 190:	7a42                	ld	s4,48(sp)
 192:	7aa2                	ld	s5,40(sp)
 194:	7b02                	ld	s6,32(sp)
 196:	6be2                	ld	s7,24(sp)
 198:	6125                	add	sp,sp,96
 19a:	8082                	ret

000000000000019c <stat>:

int
stat(const char *n, struct stat *st)
{
 19c:	1101                	add	sp,sp,-32
 19e:	ec06                	sd	ra,24(sp)
 1a0:	e822                	sd	s0,16(sp)
 1a2:	e426                	sd	s1,8(sp)
 1a4:	e04a                	sd	s2,0(sp)
 1a6:	1000                	add	s0,sp,32
 1a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	4581                	li	a1,0
 1ac:	160000ef          	jal	30c <open>
  if(fd < 0)
 1b0:	02054163          	bltz	a0,1d2 <stat+0x36>
 1b4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b6:	85ca                	mv	a1,s2
 1b8:	16c000ef          	jal	324 <fstat>
 1bc:	892a                	mv	s2,a0
  close(fd);
 1be:	8526                	mv	a0,s1
 1c0:	134000ef          	jal	2f4 <close>
  return r;
}
 1c4:	854a                	mv	a0,s2
 1c6:	60e2                	ld	ra,24(sp)
 1c8:	6442                	ld	s0,16(sp)
 1ca:	64a2                	ld	s1,8(sp)
 1cc:	6902                	ld	s2,0(sp)
 1ce:	6105                	add	sp,sp,32
 1d0:	8082                	ret
    return -1;
 1d2:	597d                	li	s2,-1
 1d4:	bfc5                	j	1c4 <stat+0x28>

00000000000001d6 <atoi>:

int
atoi(const char *s)
{
 1d6:	1141                	add	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1dc:	00054683          	lbu	a3,0(a0)
 1e0:	fd06879b          	addw	a5,a3,-48
 1e4:	0ff7f793          	zext.b	a5,a5
 1e8:	4625                	li	a2,9
 1ea:	02f66863          	bltu	a2,a5,21a <atoi+0x44>
 1ee:	872a                	mv	a4,a0
  n = 0;
 1f0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f2:	0705                	add	a4,a4,1
 1f4:	0025179b          	sllw	a5,a0,0x2
 1f8:	9fa9                	addw	a5,a5,a0
 1fa:	0017979b          	sllw	a5,a5,0x1
 1fe:	9fb5                	addw	a5,a5,a3
 200:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 204:	00074683          	lbu	a3,0(a4)
 208:	fd06879b          	addw	a5,a3,-48
 20c:	0ff7f793          	zext.b	a5,a5
 210:	fef671e3          	bgeu	a2,a5,1f2 <atoi+0x1c>
  return n;
}
 214:	6422                	ld	s0,8(sp)
 216:	0141                	add	sp,sp,16
 218:	8082                	ret
  n = 0;
 21a:	4501                	li	a0,0
 21c:	bfe5                	j	214 <atoi+0x3e>

000000000000021e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21e:	1141                	add	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 224:	02b57463          	bgeu	a0,a1,24c <memmove+0x2e>
    while(n-- > 0)
 228:	00c05f63          	blez	a2,246 <memmove+0x28>
 22c:	1602                	sll	a2,a2,0x20
 22e:	9201                	srl	a2,a2,0x20
 230:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 234:	872a                	mv	a4,a0
      *dst++ = *src++;
 236:	0585                	add	a1,a1,1
 238:	0705                	add	a4,a4,1
 23a:	fff5c683          	lbu	a3,-1(a1)
 23e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 242:	fee79ae3          	bne	a5,a4,236 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 246:	6422                	ld	s0,8(sp)
 248:	0141                	add	sp,sp,16
 24a:	8082                	ret
    dst += n;
 24c:	00c50733          	add	a4,a0,a2
    src += n;
 250:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 252:	fec05ae3          	blez	a2,246 <memmove+0x28>
 256:	fff6079b          	addw	a5,a2,-1
 25a:	1782                	sll	a5,a5,0x20
 25c:	9381                	srl	a5,a5,0x20
 25e:	fff7c793          	not	a5,a5
 262:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 264:	15fd                	add	a1,a1,-1
 266:	177d                	add	a4,a4,-1
 268:	0005c683          	lbu	a3,0(a1)
 26c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 270:	fee79ae3          	bne	a5,a4,264 <memmove+0x46>
 274:	bfc9                	j	246 <memmove+0x28>

0000000000000276 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 276:	1141                	add	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 27c:	ca05                	beqz	a2,2ac <memcmp+0x36>
 27e:	fff6069b          	addw	a3,a2,-1
 282:	1682                	sll	a3,a3,0x20
 284:	9281                	srl	a3,a3,0x20
 286:	0685                	add	a3,a3,1
 288:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 28a:	00054783          	lbu	a5,0(a0)
 28e:	0005c703          	lbu	a4,0(a1)
 292:	00e79863          	bne	a5,a4,2a2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 296:	0505                	add	a0,a0,1
    p2++;
 298:	0585                	add	a1,a1,1
  while (n-- > 0) {
 29a:	fed518e3          	bne	a0,a3,28a <memcmp+0x14>
  }
  return 0;
 29e:	4501                	li	a0,0
 2a0:	a019                	j	2a6 <memcmp+0x30>
      return *p1 - *p2;
 2a2:	40e7853b          	subw	a0,a5,a4
}
 2a6:	6422                	ld	s0,8(sp)
 2a8:	0141                	add	sp,sp,16
 2aa:	8082                	ret
  return 0;
 2ac:	4501                	li	a0,0
 2ae:	bfe5                	j	2a6 <memcmp+0x30>

00000000000002b0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b0:	1141                	add	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2b8:	f67ff0ef          	jal	21e <memmove>
}
 2bc:	60a2                	ld	ra,8(sp)
 2be:	6402                	ld	s0,0(sp)
 2c0:	0141                	add	sp,sp,16
 2c2:	8082                	ret

00000000000002c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c4:	4885                	li	a7,1
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2cc:	4889                	li	a7,2
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d4:	488d                	li	a7,3
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2dc:	4891                	li	a7,4
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <read>:
.global read
read:
 li a7, SYS_read
 2e4:	4895                	li	a7,5
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <write>:
.global write
write:
 li a7, SYS_write
 2ec:	48c1                	li	a7,16
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <close>:
.global close
close:
 li a7, SYS_close
 2f4:	48d5                	li	a7,21
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <kill>:
.global kill
kill:
 li a7, SYS_kill
 2fc:	4899                	li	a7,6
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exec>:
.global exec
exec:
 li a7, SYS_exec
 304:	489d                	li	a7,7
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <open>:
.global open
open:
 li a7, SYS_open
 30c:	48bd                	li	a7,15
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 314:	48c5                	li	a7,17
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 31c:	48c9                	li	a7,18
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 324:	48a1                	li	a7,8
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <link>:
.global link
link:
 li a7, SYS_link
 32c:	48cd                	li	a7,19
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 334:	48d1                	li	a7,20
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 33c:	48a5                	li	a7,9
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <dup>:
.global dup
dup:
 li a7, SYS_dup
 344:	48a9                	li	a7,10
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 34c:	48ad                	li	a7,11
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 354:	48b1                	li	a7,12
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 35c:	48b5                	li	a7,13
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 364:	48b9                	li	a7,14
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 36c:	48d9                	li	a7,22
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 374:	48e1                	li	a7,24
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 37c:	48dd                	li	a7,23
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 384:	48e5                	li	a7,25
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 38c:	1101                	add	sp,sp,-32
 38e:	ec06                	sd	ra,24(sp)
 390:	e822                	sd	s0,16(sp)
 392:	1000                	add	s0,sp,32
 394:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 398:	4605                	li	a2,1
 39a:	fef40593          	add	a1,s0,-17
 39e:	f4fff0ef          	jal	2ec <write>
}
 3a2:	60e2                	ld	ra,24(sp)
 3a4:	6442                	ld	s0,16(sp)
 3a6:	6105                	add	sp,sp,32
 3a8:	8082                	ret

00000000000003aa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3aa:	7139                	add	sp,sp,-64
 3ac:	fc06                	sd	ra,56(sp)
 3ae:	f822                	sd	s0,48(sp)
 3b0:	f426                	sd	s1,40(sp)
 3b2:	f04a                	sd	s2,32(sp)
 3b4:	ec4e                	sd	s3,24(sp)
 3b6:	0080                	add	s0,sp,64
 3b8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ba:	c299                	beqz	a3,3c0 <printint+0x16>
 3bc:	0805c763          	bltz	a1,44a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c0:	2581                	sext.w	a1,a1
  neg = 0;
 3c2:	4881                	li	a7,0
 3c4:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3c8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ca:	2601                	sext.w	a2,a2
 3cc:	00000517          	auipc	a0,0x0
 3d0:	51450513          	add	a0,a0,1300 # 8e0 <digits>
 3d4:	883a                	mv	a6,a4
 3d6:	2705                	addw	a4,a4,1
 3d8:	02c5f7bb          	remuw	a5,a1,a2
 3dc:	1782                	sll	a5,a5,0x20
 3de:	9381                	srl	a5,a5,0x20
 3e0:	97aa                	add	a5,a5,a0
 3e2:	0007c783          	lbu	a5,0(a5)
 3e6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ea:	0005879b          	sext.w	a5,a1
 3ee:	02c5d5bb          	divuw	a1,a1,a2
 3f2:	0685                	add	a3,a3,1
 3f4:	fec7f0e3          	bgeu	a5,a2,3d4 <printint+0x2a>
  if(neg)
 3f8:	00088c63          	beqz	a7,410 <printint+0x66>
    buf[i++] = '-';
 3fc:	fd070793          	add	a5,a4,-48
 400:	00878733          	add	a4,a5,s0
 404:	02d00793          	li	a5,45
 408:	fef70823          	sb	a5,-16(a4)
 40c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 410:	02e05663          	blez	a4,43c <printint+0x92>
 414:	fc040793          	add	a5,s0,-64
 418:	00e78933          	add	s2,a5,a4
 41c:	fff78993          	add	s3,a5,-1
 420:	99ba                	add	s3,s3,a4
 422:	377d                	addw	a4,a4,-1
 424:	1702                	sll	a4,a4,0x20
 426:	9301                	srl	a4,a4,0x20
 428:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 42c:	fff94583          	lbu	a1,-1(s2)
 430:	8526                	mv	a0,s1
 432:	f5bff0ef          	jal	38c <putc>
  while(--i >= 0)
 436:	197d                	add	s2,s2,-1
 438:	ff391ae3          	bne	s2,s3,42c <printint+0x82>
}
 43c:	70e2                	ld	ra,56(sp)
 43e:	7442                	ld	s0,48(sp)
 440:	74a2                	ld	s1,40(sp)
 442:	7902                	ld	s2,32(sp)
 444:	69e2                	ld	s3,24(sp)
 446:	6121                	add	sp,sp,64
 448:	8082                	ret
    x = -xx;
 44a:	40b005bb          	negw	a1,a1
    neg = 1;
 44e:	4885                	li	a7,1
    x = -xx;
 450:	bf95                	j	3c4 <printint+0x1a>

0000000000000452 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 452:	711d                	add	sp,sp,-96
 454:	ec86                	sd	ra,88(sp)
 456:	e8a2                	sd	s0,80(sp)
 458:	e4a6                	sd	s1,72(sp)
 45a:	e0ca                	sd	s2,64(sp)
 45c:	fc4e                	sd	s3,56(sp)
 45e:	f852                	sd	s4,48(sp)
 460:	f456                	sd	s5,40(sp)
 462:	f05a                	sd	s6,32(sp)
 464:	ec5e                	sd	s7,24(sp)
 466:	e862                	sd	s8,16(sp)
 468:	e466                	sd	s9,8(sp)
 46a:	e06a                	sd	s10,0(sp)
 46c:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 46e:	0005c903          	lbu	s2,0(a1)
 472:	24090763          	beqz	s2,6c0 <vprintf+0x26e>
 476:	8b2a                	mv	s6,a0
 478:	8a2e                	mv	s4,a1
 47a:	8bb2                	mv	s7,a2
  state = 0;
 47c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 47e:	4481                	li	s1,0
 480:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 482:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 486:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 48a:	06c00c93          	li	s9,108
 48e:	a005                	j	4ae <vprintf+0x5c>
        putc(fd, c0);
 490:	85ca                	mv	a1,s2
 492:	855a                	mv	a0,s6
 494:	ef9ff0ef          	jal	38c <putc>
 498:	a019                	j	49e <vprintf+0x4c>
    } else if(state == '%'){
 49a:	03598263          	beq	s3,s5,4be <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 49e:	2485                	addw	s1,s1,1
 4a0:	8726                	mv	a4,s1
 4a2:	009a07b3          	add	a5,s4,s1
 4a6:	0007c903          	lbu	s2,0(a5)
 4aa:	20090b63          	beqz	s2,6c0 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4ae:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4b2:	fe0994e3          	bnez	s3,49a <vprintf+0x48>
      if(c0 == '%'){
 4b6:	fd579de3          	bne	a5,s5,490 <vprintf+0x3e>
        state = '%';
 4ba:	89be                	mv	s3,a5
 4bc:	b7cd                	j	49e <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 4be:	c7c9                	beqz	a5,548 <vprintf+0xf6>
 4c0:	00ea06b3          	add	a3,s4,a4
 4c4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4c8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4ca:	c681                	beqz	a3,4d2 <vprintf+0x80>
 4cc:	9752                	add	a4,a4,s4
 4ce:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4d2:	03878f63          	beq	a5,s8,510 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 4d6:	05978963          	beq	a5,s9,528 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4da:	07500713          	li	a4,117
 4de:	0ee78363          	beq	a5,a4,5c4 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4e2:	07800713          	li	a4,120
 4e6:	12e78563          	beq	a5,a4,610 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4ea:	07000713          	li	a4,112
 4ee:	14e78a63          	beq	a5,a4,642 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4f2:	07300713          	li	a4,115
 4f6:	18e78863          	beq	a5,a4,686 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4fa:	02500713          	li	a4,37
 4fe:	04e79563          	bne	a5,a4,548 <vprintf+0xf6>
        putc(fd, '%');
 502:	02500593          	li	a1,37
 506:	855a                	mv	a0,s6
 508:	e85ff0ef          	jal	38c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 50c:	4981                	li	s3,0
 50e:	bf41                	j	49e <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 510:	008b8913          	add	s2,s7,8
 514:	4685                	li	a3,1
 516:	4629                	li	a2,10
 518:	000ba583          	lw	a1,0(s7)
 51c:	855a                	mv	a0,s6
 51e:	e8dff0ef          	jal	3aa <printint>
 522:	8bca                	mv	s7,s2
      state = 0;
 524:	4981                	li	s3,0
 526:	bfa5                	j	49e <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 528:	06400793          	li	a5,100
 52c:	02f68963          	beq	a3,a5,55e <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 530:	06c00793          	li	a5,108
 534:	04f68263          	beq	a3,a5,578 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 538:	07500793          	li	a5,117
 53c:	0af68063          	beq	a3,a5,5dc <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 540:	07800793          	li	a5,120
 544:	0ef68263          	beq	a3,a5,628 <vprintf+0x1d6>
        putc(fd, '%');
 548:	02500593          	li	a1,37
 54c:	855a                	mv	a0,s6
 54e:	e3fff0ef          	jal	38c <putc>
        putc(fd, c0);
 552:	85ca                	mv	a1,s2
 554:	855a                	mv	a0,s6
 556:	e37ff0ef          	jal	38c <putc>
      state = 0;
 55a:	4981                	li	s3,0
 55c:	b789                	j	49e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 55e:	008b8913          	add	s2,s7,8
 562:	4685                	li	a3,1
 564:	4629                	li	a2,10
 566:	000ba583          	lw	a1,0(s7)
 56a:	855a                	mv	a0,s6
 56c:	e3fff0ef          	jal	3aa <printint>
        i += 1;
 570:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 572:	8bca                	mv	s7,s2
      state = 0;
 574:	4981                	li	s3,0
        i += 1;
 576:	b725                	j	49e <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 578:	06400793          	li	a5,100
 57c:	02f60763          	beq	a2,a5,5aa <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 580:	07500793          	li	a5,117
 584:	06f60963          	beq	a2,a5,5f6 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 588:	07800793          	li	a5,120
 58c:	faf61ee3          	bne	a2,a5,548 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 590:	008b8913          	add	s2,s7,8
 594:	4681                	li	a3,0
 596:	4641                	li	a2,16
 598:	000ba583          	lw	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	e0dff0ef          	jal	3aa <printint>
        i += 2;
 5a2:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
        i += 2;
 5a8:	bddd                	j	49e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5aa:	008b8913          	add	s2,s7,8
 5ae:	4685                	li	a3,1
 5b0:	4629                	li	a2,10
 5b2:	000ba583          	lw	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	df3ff0ef          	jal	3aa <printint>
        i += 2;
 5bc:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5be:	8bca                	mv	s7,s2
      state = 0;
 5c0:	4981                	li	s3,0
        i += 2;
 5c2:	bdf1                	j	49e <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 5c4:	008b8913          	add	s2,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4629                	li	a2,10
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	dd9ff0ef          	jal	3aa <printint>
 5d6:	8bca                	mv	s7,s2
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b5d1                	j	49e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	008b8913          	add	s2,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4629                	li	a2,10
 5e4:	000ba583          	lw	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	dc1ff0ef          	jal	3aa <printint>
        i += 1;
 5ee:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f0:	8bca                	mv	s7,s2
      state = 0;
 5f2:	4981                	li	s3,0
        i += 1;
 5f4:	b56d                	j	49e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f6:	008b8913          	add	s2,s7,8
 5fa:	4681                	li	a3,0
 5fc:	4629                	li	a2,10
 5fe:	000ba583          	lw	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	da7ff0ef          	jal	3aa <printint>
        i += 2;
 608:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
        i += 2;
 60e:	bd41                	j	49e <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 610:	008b8913          	add	s2,s7,8
 614:	4681                	li	a3,0
 616:	4641                	li	a2,16
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	d8dff0ef          	jal	3aa <printint>
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
 626:	bda5                	j	49e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 628:	008b8913          	add	s2,s7,8
 62c:	4681                	li	a3,0
 62e:	4641                	li	a2,16
 630:	000ba583          	lw	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	d75ff0ef          	jal	3aa <printint>
        i += 1;
 63a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
        i += 1;
 640:	bdb9                	j	49e <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 642:	008b8d13          	add	s10,s7,8
 646:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 64a:	03000593          	li	a1,48
 64e:	855a                	mv	a0,s6
 650:	d3dff0ef          	jal	38c <putc>
  putc(fd, 'x');
 654:	07800593          	li	a1,120
 658:	855a                	mv	a0,s6
 65a:	d33ff0ef          	jal	38c <putc>
 65e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 660:	00000b97          	auipc	s7,0x0
 664:	280b8b93          	add	s7,s7,640 # 8e0 <digits>
 668:	03c9d793          	srl	a5,s3,0x3c
 66c:	97de                	add	a5,a5,s7
 66e:	0007c583          	lbu	a1,0(a5)
 672:	855a                	mv	a0,s6
 674:	d19ff0ef          	jal	38c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 678:	0992                	sll	s3,s3,0x4
 67a:	397d                	addw	s2,s2,-1
 67c:	fe0916e3          	bnez	s2,668 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 680:	8bea                	mv	s7,s10
      state = 0;
 682:	4981                	li	s3,0
 684:	bd29                	j	49e <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 686:	008b8993          	add	s3,s7,8
 68a:	000bb903          	ld	s2,0(s7)
 68e:	00090f63          	beqz	s2,6ac <vprintf+0x25a>
        for(; *s; s++)
 692:	00094583          	lbu	a1,0(s2)
 696:	c195                	beqz	a1,6ba <vprintf+0x268>
          putc(fd, *s);
 698:	855a                	mv	a0,s6
 69a:	cf3ff0ef          	jal	38c <putc>
        for(; *s; s++)
 69e:	0905                	add	s2,s2,1
 6a0:	00094583          	lbu	a1,0(s2)
 6a4:	f9f5                	bnez	a1,698 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6a6:	8bce                	mv	s7,s3
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	bbd5                	j	49e <vprintf+0x4c>
          s = "(null)";
 6ac:	00000917          	auipc	s2,0x0
 6b0:	22c90913          	add	s2,s2,556 # 8d8 <malloc+0x11e>
        for(; *s; s++)
 6b4:	02800593          	li	a1,40
 6b8:	b7c5                	j	698 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6ba:	8bce                	mv	s7,s3
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	b3c5                	j	49e <vprintf+0x4c>
    }
  }
}
 6c0:	60e6                	ld	ra,88(sp)
 6c2:	6446                	ld	s0,80(sp)
 6c4:	64a6                	ld	s1,72(sp)
 6c6:	6906                	ld	s2,64(sp)
 6c8:	79e2                	ld	s3,56(sp)
 6ca:	7a42                	ld	s4,48(sp)
 6cc:	7aa2                	ld	s5,40(sp)
 6ce:	7b02                	ld	s6,32(sp)
 6d0:	6be2                	ld	s7,24(sp)
 6d2:	6c42                	ld	s8,16(sp)
 6d4:	6ca2                	ld	s9,8(sp)
 6d6:	6d02                	ld	s10,0(sp)
 6d8:	6125                	add	sp,sp,96
 6da:	8082                	ret

00000000000006dc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6dc:	715d                	add	sp,sp,-80
 6de:	ec06                	sd	ra,24(sp)
 6e0:	e822                	sd	s0,16(sp)
 6e2:	1000                	add	s0,sp,32
 6e4:	e010                	sd	a2,0(s0)
 6e6:	e414                	sd	a3,8(s0)
 6e8:	e818                	sd	a4,16(s0)
 6ea:	ec1c                	sd	a5,24(s0)
 6ec:	03043023          	sd	a6,32(s0)
 6f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6f4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6f8:	8622                	mv	a2,s0
 6fa:	d59ff0ef          	jal	452 <vprintf>
}
 6fe:	60e2                	ld	ra,24(sp)
 700:	6442                	ld	s0,16(sp)
 702:	6161                	add	sp,sp,80
 704:	8082                	ret

0000000000000706 <printf>:

void
printf(const char *fmt, ...)
{
 706:	711d                	add	sp,sp,-96
 708:	ec06                	sd	ra,24(sp)
 70a:	e822                	sd	s0,16(sp)
 70c:	1000                	add	s0,sp,32
 70e:	e40c                	sd	a1,8(s0)
 710:	e810                	sd	a2,16(s0)
 712:	ec14                	sd	a3,24(s0)
 714:	f018                	sd	a4,32(s0)
 716:	f41c                	sd	a5,40(s0)
 718:	03043823          	sd	a6,48(s0)
 71c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 720:	00840613          	add	a2,s0,8
 724:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 728:	85aa                	mv	a1,a0
 72a:	4505                	li	a0,1
 72c:	d27ff0ef          	jal	452 <vprintf>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6125                	add	sp,sp,96
 736:	8082                	ret

0000000000000738 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 738:	1141                	add	sp,sp,-16
 73a:	e422                	sd	s0,8(sp)
 73c:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73e:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 742:	00001797          	auipc	a5,0x1
 746:	8be7b783          	ld	a5,-1858(a5) # 1000 <freep>
 74a:	a02d                	j	774 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 74c:	4618                	lw	a4,8(a2)
 74e:	9f2d                	addw	a4,a4,a1
 750:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 754:	6398                	ld	a4,0(a5)
 756:	6310                	ld	a2,0(a4)
 758:	a83d                	j	796 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 75a:	ff852703          	lw	a4,-8(a0)
 75e:	9f31                	addw	a4,a4,a2
 760:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 762:	ff053683          	ld	a3,-16(a0)
 766:	a091                	j	7aa <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 768:	6398                	ld	a4,0(a5)
 76a:	00e7e463          	bltu	a5,a4,772 <free+0x3a>
 76e:	00e6ea63          	bltu	a3,a4,782 <free+0x4a>
{
 772:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 774:	fed7fae3          	bgeu	a5,a3,768 <free+0x30>
 778:	6398                	ld	a4,0(a5)
 77a:	00e6e463          	bltu	a3,a4,782 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77e:	fee7eae3          	bltu	a5,a4,772 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 782:	ff852583          	lw	a1,-8(a0)
 786:	6390                	ld	a2,0(a5)
 788:	02059813          	sll	a6,a1,0x20
 78c:	01c85713          	srl	a4,a6,0x1c
 790:	9736                	add	a4,a4,a3
 792:	fae60de3          	beq	a2,a4,74c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 796:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 79a:	4790                	lw	a2,8(a5)
 79c:	02061593          	sll	a1,a2,0x20
 7a0:	01c5d713          	srl	a4,a1,0x1c
 7a4:	973e                	add	a4,a4,a5
 7a6:	fae68ae3          	beq	a3,a4,75a <free+0x22>
    p->s.ptr = bp->s.ptr;
 7aa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ac:	00001717          	auipc	a4,0x1
 7b0:	84f73a23          	sd	a5,-1964(a4) # 1000 <freep>
}
 7b4:	6422                	ld	s0,8(sp)
 7b6:	0141                	add	sp,sp,16
 7b8:	8082                	ret

00000000000007ba <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ba:	7139                	add	sp,sp,-64
 7bc:	fc06                	sd	ra,56(sp)
 7be:	f822                	sd	s0,48(sp)
 7c0:	f426                	sd	s1,40(sp)
 7c2:	f04a                	sd	s2,32(sp)
 7c4:	ec4e                	sd	s3,24(sp)
 7c6:	e852                	sd	s4,16(sp)
 7c8:	e456                	sd	s5,8(sp)
 7ca:	e05a                	sd	s6,0(sp)
 7cc:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ce:	02051493          	sll	s1,a0,0x20
 7d2:	9081                	srl	s1,s1,0x20
 7d4:	04bd                	add	s1,s1,15
 7d6:	8091                	srl	s1,s1,0x4
 7d8:	0014899b          	addw	s3,s1,1
 7dc:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7de:	00001517          	auipc	a0,0x1
 7e2:	82253503          	ld	a0,-2014(a0) # 1000 <freep>
 7e6:	c515                	beqz	a0,812 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ea:	4798                	lw	a4,8(a5)
 7ec:	02977f63          	bgeu	a4,s1,82a <malloc+0x70>
  if(nu < 4096)
 7f0:	8a4e                	mv	s4,s3
 7f2:	0009871b          	sext.w	a4,s3
 7f6:	6685                	lui	a3,0x1
 7f8:	00d77363          	bgeu	a4,a3,7fe <malloc+0x44>
 7fc:	6a05                	lui	s4,0x1
 7fe:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 802:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 806:	00000917          	auipc	s2,0x0
 80a:	7fa90913          	add	s2,s2,2042 # 1000 <freep>
  if(p == (char*)-1)
 80e:	5afd                	li	s5,-1
 810:	a885                	j	880 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 812:	00000797          	auipc	a5,0x0
 816:	7fe78793          	add	a5,a5,2046 # 1010 <base>
 81a:	00000717          	auipc	a4,0x0
 81e:	7ef73323          	sd	a5,2022(a4) # 1000 <freep>
 822:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 824:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 828:	b7e1                	j	7f0 <malloc+0x36>
      if(p->s.size == nunits)
 82a:	02e48c63          	beq	s1,a4,862 <malloc+0xa8>
        p->s.size -= nunits;
 82e:	4137073b          	subw	a4,a4,s3
 832:	c798                	sw	a4,8(a5)
        p += p->s.size;
 834:	02071693          	sll	a3,a4,0x20
 838:	01c6d713          	srl	a4,a3,0x1c
 83c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 83e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 842:	00000717          	auipc	a4,0x0
 846:	7aa73f23          	sd	a0,1982(a4) # 1000 <freep>
      return (void*)(p + 1);
 84a:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 84e:	70e2                	ld	ra,56(sp)
 850:	7442                	ld	s0,48(sp)
 852:	74a2                	ld	s1,40(sp)
 854:	7902                	ld	s2,32(sp)
 856:	69e2                	ld	s3,24(sp)
 858:	6a42                	ld	s4,16(sp)
 85a:	6aa2                	ld	s5,8(sp)
 85c:	6b02                	ld	s6,0(sp)
 85e:	6121                	add	sp,sp,64
 860:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 862:	6398                	ld	a4,0(a5)
 864:	e118                	sd	a4,0(a0)
 866:	bff1                	j	842 <malloc+0x88>
  hp->s.size = nu;
 868:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 86c:	0541                	add	a0,a0,16
 86e:	ecbff0ef          	jal	738 <free>
  return freep;
 872:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 876:	dd61                	beqz	a0,84e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 878:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87a:	4798                	lw	a4,8(a5)
 87c:	fa9777e3          	bgeu	a4,s1,82a <malloc+0x70>
    if(p == freep)
 880:	00093703          	ld	a4,0(s2)
 884:	853e                	mv	a0,a5
 886:	fef719e3          	bne	a4,a5,878 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 88a:	8552                	mv	a0,s4
 88c:	ac9ff0ef          	jal	354 <sbrk>
  if(p == (char*)-1)
 890:	fd551ce3          	bne	a0,s5,868 <malloc+0xae>
        return 0;
 894:	4501                	li	a0,0
 896:	bf65                	j	84e <malloc+0x94>
