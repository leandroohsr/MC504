
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
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
   e:	02a7d763          	bge	a5,a0,3c <main+0x3c>
  12:	00858493          	add	s1,a1,8
  16:	ffe5091b          	addw	s2,a0,-2
  1a:	02091793          	sll	a5,s2,0x20
  1e:	01d7d913          	srl	s2,a5,0x1d
  22:	05c1                	add	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	19c000ef          	jal	1c4 <atoi>
  2c:	2be000ef          	jal	2ea <kill>
  for(i=1; i<argc; i++)
  30:	04a1                	add	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	282000ef          	jal	2ba <exit>
    fprintf(2, "usage: kill pid...\n");
  3c:	00001597          	auipc	a1,0x1
  40:	85458593          	add	a1,a1,-1964 # 890 <malloc+0xe8>
  44:	4509                	li	a0,2
  46:	684000ef          	jal	6ca <fprintf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	26e000ef          	jal	2ba <exit>

0000000000000050 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  50:	1141                	add	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	add	s0,sp,16
  extern int main();
  main();
  58:	fa9ff0ef          	jal	0 <main>
  exit(0);
  5c:	4501                	li	a0,0
  5e:	25c000ef          	jal	2ba <exit>

0000000000000062 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  62:	1141                	add	sp,sp,-16
  64:	e422                	sd	s0,8(sp)
  66:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  68:	87aa                	mv	a5,a0
  6a:	0585                	add	a1,a1,1
  6c:	0785                	add	a5,a5,1
  6e:	fff5c703          	lbu	a4,-1(a1)
  72:	fee78fa3          	sb	a4,-1(a5)
  76:	fb75                	bnez	a4,6a <strcpy+0x8>
    ;
  return os;
}
  78:	6422                	ld	s0,8(sp)
  7a:	0141                	add	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	add	sp,sp,-16
  80:	e422                	sd	s0,8(sp)
  82:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  84:	00054783          	lbu	a5,0(a0)
  88:	cb91                	beqz	a5,9c <strcmp+0x1e>
  8a:	0005c703          	lbu	a4,0(a1)
  8e:	00f71763          	bne	a4,a5,9c <strcmp+0x1e>
    p++, q++;
  92:	0505                	add	a0,a0,1
  94:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  96:	00054783          	lbu	a5,0(a0)
  9a:	fbe5                	bnez	a5,8a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9c:	0005c503          	lbu	a0,0(a1)
}
  a0:	40a7853b          	subw	a0,a5,a0
  a4:	6422                	ld	s0,8(sp)
  a6:	0141                	add	sp,sp,16
  a8:	8082                	ret

00000000000000aa <strlen>:

uint
strlen(const char *s)
{
  aa:	1141                	add	sp,sp,-16
  ac:	e422                	sd	s0,8(sp)
  ae:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	cf91                	beqz	a5,d0 <strlen+0x26>
  b6:	0505                	add	a0,a0,1
  b8:	87aa                	mv	a5,a0
  ba:	86be                	mv	a3,a5
  bc:	0785                	add	a5,a5,1
  be:	fff7c703          	lbu	a4,-1(a5)
  c2:	ff65                	bnez	a4,ba <strlen+0x10>
  c4:	40a6853b          	subw	a0,a3,a0
  c8:	2505                	addw	a0,a0,1
    ;
  return n;
}
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	add	sp,sp,16
  ce:	8082                	ret
  for(n = 0; s[n]; n++)
  d0:	4501                	li	a0,0
  d2:	bfe5                	j	ca <strlen+0x20>

00000000000000d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d4:	1141                	add	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  da:	ca19                	beqz	a2,f0 <memset+0x1c>
  dc:	87aa                	mv	a5,a0
  de:	1602                	sll	a2,a2,0x20
  e0:	9201                	srl	a2,a2,0x20
  e2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ea:	0785                	add	a5,a5,1
  ec:	fee79de3          	bne	a5,a4,e6 <memset+0x12>
  }
  return dst;
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	add	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strchr>:

char*
strchr(const char *s, char c)
{
  f6:	1141                	add	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	add	s0,sp,16
  for(; *s; s++)
  fc:	00054783          	lbu	a5,0(a0)
 100:	cb99                	beqz	a5,116 <strchr+0x20>
    if(*s == c)
 102:	00f58763          	beq	a1,a5,110 <strchr+0x1a>
  for(; *s; s++)
 106:	0505                	add	a0,a0,1
 108:	00054783          	lbu	a5,0(a0)
 10c:	fbfd                	bnez	a5,102 <strchr+0xc>
      return (char*)s;
  return 0;
 10e:	4501                	li	a0,0
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	add	sp,sp,16
 114:	8082                	ret
  return 0;
 116:	4501                	li	a0,0
 118:	bfe5                	j	110 <strchr+0x1a>

000000000000011a <gets>:

char*
gets(char *buf, int max)
{
 11a:	711d                	add	sp,sp,-96
 11c:	ec86                	sd	ra,88(sp)
 11e:	e8a2                	sd	s0,80(sp)
 120:	e4a6                	sd	s1,72(sp)
 122:	e0ca                	sd	s2,64(sp)
 124:	fc4e                	sd	s3,56(sp)
 126:	f852                	sd	s4,48(sp)
 128:	f456                	sd	s5,40(sp)
 12a:	f05a                	sd	s6,32(sp)
 12c:	ec5e                	sd	s7,24(sp)
 12e:	1080                	add	s0,sp,96
 130:	8baa                	mv	s7,a0
 132:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 134:	892a                	mv	s2,a0
 136:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 138:	4aa9                	li	s5,10
 13a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13c:	89a6                	mv	s3,s1
 13e:	2485                	addw	s1,s1,1
 140:	0344d663          	bge	s1,s4,16c <gets+0x52>
    cc = read(0, &c, 1);
 144:	4605                	li	a2,1
 146:	faf40593          	add	a1,s0,-81
 14a:	4501                	li	a0,0
 14c:	186000ef          	jal	2d2 <read>
    if(cc < 1)
 150:	00a05e63          	blez	a0,16c <gets+0x52>
    buf[i++] = c;
 154:	faf44783          	lbu	a5,-81(s0)
 158:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15c:	01578763          	beq	a5,s5,16a <gets+0x50>
 160:	0905                	add	s2,s2,1
 162:	fd679de3          	bne	a5,s6,13c <gets+0x22>
  for(i=0; i+1 < max; ){
 166:	89a6                	mv	s3,s1
 168:	a011                	j	16c <gets+0x52>
 16a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 16c:	99de                	add	s3,s3,s7
 16e:	00098023          	sb	zero,0(s3)
  return buf;
}
 172:	855e                	mv	a0,s7
 174:	60e6                	ld	ra,88(sp)
 176:	6446                	ld	s0,80(sp)
 178:	64a6                	ld	s1,72(sp)
 17a:	6906                	ld	s2,64(sp)
 17c:	79e2                	ld	s3,56(sp)
 17e:	7a42                	ld	s4,48(sp)
 180:	7aa2                	ld	s5,40(sp)
 182:	7b02                	ld	s6,32(sp)
 184:	6be2                	ld	s7,24(sp)
 186:	6125                	add	sp,sp,96
 188:	8082                	ret

000000000000018a <stat>:

int
stat(const char *n, struct stat *st)
{
 18a:	1101                	add	sp,sp,-32
 18c:	ec06                	sd	ra,24(sp)
 18e:	e822                	sd	s0,16(sp)
 190:	e426                	sd	s1,8(sp)
 192:	e04a                	sd	s2,0(sp)
 194:	1000                	add	s0,sp,32
 196:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 198:	4581                	li	a1,0
 19a:	160000ef          	jal	2fa <open>
  if(fd < 0)
 19e:	02054163          	bltz	a0,1c0 <stat+0x36>
 1a2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a4:	85ca                	mv	a1,s2
 1a6:	16c000ef          	jal	312 <fstat>
 1aa:	892a                	mv	s2,a0
  close(fd);
 1ac:	8526                	mv	a0,s1
 1ae:	134000ef          	jal	2e2 <close>
  return r;
}
 1b2:	854a                	mv	a0,s2
 1b4:	60e2                	ld	ra,24(sp)
 1b6:	6442                	ld	s0,16(sp)
 1b8:	64a2                	ld	s1,8(sp)
 1ba:	6902                	ld	s2,0(sp)
 1bc:	6105                	add	sp,sp,32
 1be:	8082                	ret
    return -1;
 1c0:	597d                	li	s2,-1
 1c2:	bfc5                	j	1b2 <stat+0x28>

00000000000001c4 <atoi>:

int
atoi(const char *s)
{
 1c4:	1141                	add	sp,sp,-16
 1c6:	e422                	sd	s0,8(sp)
 1c8:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ca:	00054683          	lbu	a3,0(a0)
 1ce:	fd06879b          	addw	a5,a3,-48
 1d2:	0ff7f793          	zext.b	a5,a5
 1d6:	4625                	li	a2,9
 1d8:	02f66863          	bltu	a2,a5,208 <atoi+0x44>
 1dc:	872a                	mv	a4,a0
  n = 0;
 1de:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1e0:	0705                	add	a4,a4,1
 1e2:	0025179b          	sllw	a5,a0,0x2
 1e6:	9fa9                	addw	a5,a5,a0
 1e8:	0017979b          	sllw	a5,a5,0x1
 1ec:	9fb5                	addw	a5,a5,a3
 1ee:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f2:	00074683          	lbu	a3,0(a4)
 1f6:	fd06879b          	addw	a5,a3,-48
 1fa:	0ff7f793          	zext.b	a5,a5
 1fe:	fef671e3          	bgeu	a2,a5,1e0 <atoi+0x1c>
  return n;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	add	sp,sp,16
 206:	8082                	ret
  n = 0;
 208:	4501                	li	a0,0
 20a:	bfe5                	j	202 <atoi+0x3e>

000000000000020c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20c:	1141                	add	sp,sp,-16
 20e:	e422                	sd	s0,8(sp)
 210:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 212:	02b57463          	bgeu	a0,a1,23a <memmove+0x2e>
    while(n-- > 0)
 216:	00c05f63          	blez	a2,234 <memmove+0x28>
 21a:	1602                	sll	a2,a2,0x20
 21c:	9201                	srl	a2,a2,0x20
 21e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 222:	872a                	mv	a4,a0
      *dst++ = *src++;
 224:	0585                	add	a1,a1,1
 226:	0705                	add	a4,a4,1
 228:	fff5c683          	lbu	a3,-1(a1)
 22c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 230:	fee79ae3          	bne	a5,a4,224 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 234:	6422                	ld	s0,8(sp)
 236:	0141                	add	sp,sp,16
 238:	8082                	ret
    dst += n;
 23a:	00c50733          	add	a4,a0,a2
    src += n;
 23e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 240:	fec05ae3          	blez	a2,234 <memmove+0x28>
 244:	fff6079b          	addw	a5,a2,-1
 248:	1782                	sll	a5,a5,0x20
 24a:	9381                	srl	a5,a5,0x20
 24c:	fff7c793          	not	a5,a5
 250:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 252:	15fd                	add	a1,a1,-1
 254:	177d                	add	a4,a4,-1
 256:	0005c683          	lbu	a3,0(a1)
 25a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25e:	fee79ae3          	bne	a5,a4,252 <memmove+0x46>
 262:	bfc9                	j	234 <memmove+0x28>

0000000000000264 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 264:	1141                	add	sp,sp,-16
 266:	e422                	sd	s0,8(sp)
 268:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26a:	ca05                	beqz	a2,29a <memcmp+0x36>
 26c:	fff6069b          	addw	a3,a2,-1
 270:	1682                	sll	a3,a3,0x20
 272:	9281                	srl	a3,a3,0x20
 274:	0685                	add	a3,a3,1
 276:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 278:	00054783          	lbu	a5,0(a0)
 27c:	0005c703          	lbu	a4,0(a1)
 280:	00e79863          	bne	a5,a4,290 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 284:	0505                	add	a0,a0,1
    p2++;
 286:	0585                	add	a1,a1,1
  while (n-- > 0) {
 288:	fed518e3          	bne	a0,a3,278 <memcmp+0x14>
  }
  return 0;
 28c:	4501                	li	a0,0
 28e:	a019                	j	294 <memcmp+0x30>
      return *p1 - *p2;
 290:	40e7853b          	subw	a0,a5,a4
}
 294:	6422                	ld	s0,8(sp)
 296:	0141                	add	sp,sp,16
 298:	8082                	ret
  return 0;
 29a:	4501                	li	a0,0
 29c:	bfe5                	j	294 <memcmp+0x30>

000000000000029e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29e:	1141                	add	sp,sp,-16
 2a0:	e406                	sd	ra,8(sp)
 2a2:	e022                	sd	s0,0(sp)
 2a4:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2a6:	f67ff0ef          	jal	20c <memmove>
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	add	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b2:	4885                	li	a7,1
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ba:	4889                	li	a7,2
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c2:	488d                	li	a7,3
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ca:	4891                	li	a7,4
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <read>:
.global read
read:
 li a7, SYS_read
 2d2:	4895                	li	a7,5
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <write>:
.global write
write:
 li a7, SYS_write
 2da:	48c1                	li	a7,16
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <close>:
.global close
close:
 li a7, SYS_close
 2e2:	48d5                	li	a7,21
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ea:	4899                	li	a7,6
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f2:	489d                	li	a7,7
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <open>:
.global open
open:
 li a7, SYS_open
 2fa:	48bd                	li	a7,15
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 302:	48c5                	li	a7,17
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30a:	48c9                	li	a7,18
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 312:	48a1                	li	a7,8
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <link>:
.global link
link:
 li a7, SYS_link
 31a:	48cd                	li	a7,19
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 322:	48d1                	li	a7,20
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32a:	48a5                	li	a7,9
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <dup>:
.global dup
dup:
 li a7, SYS_dup
 332:	48a9                	li	a7,10
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33a:	48ad                	li	a7,11
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 342:	48b1                	li	a7,12
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34a:	48b5                	li	a7,13
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 352:	48b9                	li	a7,14
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 35a:	48d9                	li	a7,22
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 362:	48e1                	li	a7,24
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 36a:	48dd                	li	a7,23
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 372:	48e5                	li	a7,25
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 37a:	1101                	add	sp,sp,-32
 37c:	ec06                	sd	ra,24(sp)
 37e:	e822                	sd	s0,16(sp)
 380:	1000                	add	s0,sp,32
 382:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 386:	4605                	li	a2,1
 388:	fef40593          	add	a1,s0,-17
 38c:	f4fff0ef          	jal	2da <write>
}
 390:	60e2                	ld	ra,24(sp)
 392:	6442                	ld	s0,16(sp)
 394:	6105                	add	sp,sp,32
 396:	8082                	ret

0000000000000398 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 398:	7139                	add	sp,sp,-64
 39a:	fc06                	sd	ra,56(sp)
 39c:	f822                	sd	s0,48(sp)
 39e:	f426                	sd	s1,40(sp)
 3a0:	f04a                	sd	s2,32(sp)
 3a2:	ec4e                	sd	s3,24(sp)
 3a4:	0080                	add	s0,sp,64
 3a6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a8:	c299                	beqz	a3,3ae <printint+0x16>
 3aa:	0805c763          	bltz	a1,438 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ae:	2581                	sext.w	a1,a1
  neg = 0;
 3b0:	4881                	li	a7,0
 3b2:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3b6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b8:	2601                	sext.w	a2,a2
 3ba:	00000517          	auipc	a0,0x0
 3be:	4f650513          	add	a0,a0,1270 # 8b0 <digits>
 3c2:	883a                	mv	a6,a4
 3c4:	2705                	addw	a4,a4,1
 3c6:	02c5f7bb          	remuw	a5,a1,a2
 3ca:	1782                	sll	a5,a5,0x20
 3cc:	9381                	srl	a5,a5,0x20
 3ce:	97aa                	add	a5,a5,a0
 3d0:	0007c783          	lbu	a5,0(a5)
 3d4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d8:	0005879b          	sext.w	a5,a1
 3dc:	02c5d5bb          	divuw	a1,a1,a2
 3e0:	0685                	add	a3,a3,1
 3e2:	fec7f0e3          	bgeu	a5,a2,3c2 <printint+0x2a>
  if(neg)
 3e6:	00088c63          	beqz	a7,3fe <printint+0x66>
    buf[i++] = '-';
 3ea:	fd070793          	add	a5,a4,-48
 3ee:	00878733          	add	a4,a5,s0
 3f2:	02d00793          	li	a5,45
 3f6:	fef70823          	sb	a5,-16(a4)
 3fa:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 3fe:	02e05663          	blez	a4,42a <printint+0x92>
 402:	fc040793          	add	a5,s0,-64
 406:	00e78933          	add	s2,a5,a4
 40a:	fff78993          	add	s3,a5,-1
 40e:	99ba                	add	s3,s3,a4
 410:	377d                	addw	a4,a4,-1
 412:	1702                	sll	a4,a4,0x20
 414:	9301                	srl	a4,a4,0x20
 416:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 41a:	fff94583          	lbu	a1,-1(s2)
 41e:	8526                	mv	a0,s1
 420:	f5bff0ef          	jal	37a <putc>
  while(--i >= 0)
 424:	197d                	add	s2,s2,-1
 426:	ff391ae3          	bne	s2,s3,41a <printint+0x82>
}
 42a:	70e2                	ld	ra,56(sp)
 42c:	7442                	ld	s0,48(sp)
 42e:	74a2                	ld	s1,40(sp)
 430:	7902                	ld	s2,32(sp)
 432:	69e2                	ld	s3,24(sp)
 434:	6121                	add	sp,sp,64
 436:	8082                	ret
    x = -xx;
 438:	40b005bb          	negw	a1,a1
    neg = 1;
 43c:	4885                	li	a7,1
    x = -xx;
 43e:	bf95                	j	3b2 <printint+0x1a>

0000000000000440 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 440:	711d                	add	sp,sp,-96
 442:	ec86                	sd	ra,88(sp)
 444:	e8a2                	sd	s0,80(sp)
 446:	e4a6                	sd	s1,72(sp)
 448:	e0ca                	sd	s2,64(sp)
 44a:	fc4e                	sd	s3,56(sp)
 44c:	f852                	sd	s4,48(sp)
 44e:	f456                	sd	s5,40(sp)
 450:	f05a                	sd	s6,32(sp)
 452:	ec5e                	sd	s7,24(sp)
 454:	e862                	sd	s8,16(sp)
 456:	e466                	sd	s9,8(sp)
 458:	e06a                	sd	s10,0(sp)
 45a:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 45c:	0005c903          	lbu	s2,0(a1)
 460:	24090763          	beqz	s2,6ae <vprintf+0x26e>
 464:	8b2a                	mv	s6,a0
 466:	8a2e                	mv	s4,a1
 468:	8bb2                	mv	s7,a2
  state = 0;
 46a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 46c:	4481                	li	s1,0
 46e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 470:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 474:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 478:	06c00c93          	li	s9,108
 47c:	a005                	j	49c <vprintf+0x5c>
        putc(fd, c0);
 47e:	85ca                	mv	a1,s2
 480:	855a                	mv	a0,s6
 482:	ef9ff0ef          	jal	37a <putc>
 486:	a019                	j	48c <vprintf+0x4c>
    } else if(state == '%'){
 488:	03598263          	beq	s3,s5,4ac <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 48c:	2485                	addw	s1,s1,1
 48e:	8726                	mv	a4,s1
 490:	009a07b3          	add	a5,s4,s1
 494:	0007c903          	lbu	s2,0(a5)
 498:	20090b63          	beqz	s2,6ae <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 49c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4a0:	fe0994e3          	bnez	s3,488 <vprintf+0x48>
      if(c0 == '%'){
 4a4:	fd579de3          	bne	a5,s5,47e <vprintf+0x3e>
        state = '%';
 4a8:	89be                	mv	s3,a5
 4aa:	b7cd                	j	48c <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ac:	c7c9                	beqz	a5,536 <vprintf+0xf6>
 4ae:	00ea06b3          	add	a3,s4,a4
 4b2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4b6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4b8:	c681                	beqz	a3,4c0 <vprintf+0x80>
 4ba:	9752                	add	a4,a4,s4
 4bc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4c0:	03878f63          	beq	a5,s8,4fe <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 4c4:	05978963          	beq	a5,s9,516 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4c8:	07500713          	li	a4,117
 4cc:	0ee78363          	beq	a5,a4,5b2 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4d0:	07800713          	li	a4,120
 4d4:	12e78563          	beq	a5,a4,5fe <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4d8:	07000713          	li	a4,112
 4dc:	14e78a63          	beq	a5,a4,630 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4e0:	07300713          	li	a4,115
 4e4:	18e78863          	beq	a5,a4,674 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4e8:	02500713          	li	a4,37
 4ec:	04e79563          	bne	a5,a4,536 <vprintf+0xf6>
        putc(fd, '%');
 4f0:	02500593          	li	a1,37
 4f4:	855a                	mv	a0,s6
 4f6:	e85ff0ef          	jal	37a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4fa:	4981                	li	s3,0
 4fc:	bf41                	j	48c <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 4fe:	008b8913          	add	s2,s7,8
 502:	4685                	li	a3,1
 504:	4629                	li	a2,10
 506:	000ba583          	lw	a1,0(s7)
 50a:	855a                	mv	a0,s6
 50c:	e8dff0ef          	jal	398 <printint>
 510:	8bca                	mv	s7,s2
      state = 0;
 512:	4981                	li	s3,0
 514:	bfa5                	j	48c <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 516:	06400793          	li	a5,100
 51a:	02f68963          	beq	a3,a5,54c <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 51e:	06c00793          	li	a5,108
 522:	04f68263          	beq	a3,a5,566 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 526:	07500793          	li	a5,117
 52a:	0af68063          	beq	a3,a5,5ca <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 52e:	07800793          	li	a5,120
 532:	0ef68263          	beq	a3,a5,616 <vprintf+0x1d6>
        putc(fd, '%');
 536:	02500593          	li	a1,37
 53a:	855a                	mv	a0,s6
 53c:	e3fff0ef          	jal	37a <putc>
        putc(fd, c0);
 540:	85ca                	mv	a1,s2
 542:	855a                	mv	a0,s6
 544:	e37ff0ef          	jal	37a <putc>
      state = 0;
 548:	4981                	li	s3,0
 54a:	b789                	j	48c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 54c:	008b8913          	add	s2,s7,8
 550:	4685                	li	a3,1
 552:	4629                	li	a2,10
 554:	000ba583          	lw	a1,0(s7)
 558:	855a                	mv	a0,s6
 55a:	e3fff0ef          	jal	398 <printint>
        i += 1;
 55e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 560:	8bca                	mv	s7,s2
      state = 0;
 562:	4981                	li	s3,0
        i += 1;
 564:	b725                	j	48c <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 566:	06400793          	li	a5,100
 56a:	02f60763          	beq	a2,a5,598 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 56e:	07500793          	li	a5,117
 572:	06f60963          	beq	a2,a5,5e4 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 576:	07800793          	li	a5,120
 57a:	faf61ee3          	bne	a2,a5,536 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 57e:	008b8913          	add	s2,s7,8
 582:	4681                	li	a3,0
 584:	4641                	li	a2,16
 586:	000ba583          	lw	a1,0(s7)
 58a:	855a                	mv	a0,s6
 58c:	e0dff0ef          	jal	398 <printint>
        i += 2;
 590:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 592:	8bca                	mv	s7,s2
      state = 0;
 594:	4981                	li	s3,0
        i += 2;
 596:	bddd                	j	48c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 598:	008b8913          	add	s2,s7,8
 59c:	4685                	li	a3,1
 59e:	4629                	li	a2,10
 5a0:	000ba583          	lw	a1,0(s7)
 5a4:	855a                	mv	a0,s6
 5a6:	df3ff0ef          	jal	398 <printint>
        i += 2;
 5aa:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ac:	8bca                	mv	s7,s2
      state = 0;
 5ae:	4981                	li	s3,0
        i += 2;
 5b0:	bdf1                	j	48c <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 5b2:	008b8913          	add	s2,s7,8
 5b6:	4681                	li	a3,0
 5b8:	4629                	li	a2,10
 5ba:	000ba583          	lw	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	dd9ff0ef          	jal	398 <printint>
 5c4:	8bca                	mv	s7,s2
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b5d1                	j	48c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	008b8913          	add	s2,s7,8
 5ce:	4681                	li	a3,0
 5d0:	4629                	li	a2,10
 5d2:	000ba583          	lw	a1,0(s7)
 5d6:	855a                	mv	a0,s6
 5d8:	dc1ff0ef          	jal	398 <printint>
        i += 1;
 5dc:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5de:	8bca                	mv	s7,s2
      state = 0;
 5e0:	4981                	li	s3,0
        i += 1;
 5e2:	b56d                	j	48c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e4:	008b8913          	add	s2,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4629                	li	a2,10
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	da7ff0ef          	jal	398 <printint>
        i += 2;
 5f6:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f8:	8bca                	mv	s7,s2
      state = 0;
 5fa:	4981                	li	s3,0
        i += 2;
 5fc:	bd41                	j	48c <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 5fe:	008b8913          	add	s2,s7,8
 602:	4681                	li	a3,0
 604:	4641                	li	a2,16
 606:	000ba583          	lw	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	d8dff0ef          	jal	398 <printint>
 610:	8bca                	mv	s7,s2
      state = 0;
 612:	4981                	li	s3,0
 614:	bda5                	j	48c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 616:	008b8913          	add	s2,s7,8
 61a:	4681                	li	a3,0
 61c:	4641                	li	a2,16
 61e:	000ba583          	lw	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	d75ff0ef          	jal	398 <printint>
        i += 1;
 628:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 62a:	8bca                	mv	s7,s2
      state = 0;
 62c:	4981                	li	s3,0
        i += 1;
 62e:	bdb9                	j	48c <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 630:	008b8d13          	add	s10,s7,8
 634:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 638:	03000593          	li	a1,48
 63c:	855a                	mv	a0,s6
 63e:	d3dff0ef          	jal	37a <putc>
  putc(fd, 'x');
 642:	07800593          	li	a1,120
 646:	855a                	mv	a0,s6
 648:	d33ff0ef          	jal	37a <putc>
 64c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 64e:	00000b97          	auipc	s7,0x0
 652:	262b8b93          	add	s7,s7,610 # 8b0 <digits>
 656:	03c9d793          	srl	a5,s3,0x3c
 65a:	97de                	add	a5,a5,s7
 65c:	0007c583          	lbu	a1,0(a5)
 660:	855a                	mv	a0,s6
 662:	d19ff0ef          	jal	37a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 666:	0992                	sll	s3,s3,0x4
 668:	397d                	addw	s2,s2,-1
 66a:	fe0916e3          	bnez	s2,656 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 66e:	8bea                	mv	s7,s10
      state = 0;
 670:	4981                	li	s3,0
 672:	bd29                	j	48c <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 674:	008b8993          	add	s3,s7,8
 678:	000bb903          	ld	s2,0(s7)
 67c:	00090f63          	beqz	s2,69a <vprintf+0x25a>
        for(; *s; s++)
 680:	00094583          	lbu	a1,0(s2)
 684:	c195                	beqz	a1,6a8 <vprintf+0x268>
          putc(fd, *s);
 686:	855a                	mv	a0,s6
 688:	cf3ff0ef          	jal	37a <putc>
        for(; *s; s++)
 68c:	0905                	add	s2,s2,1
 68e:	00094583          	lbu	a1,0(s2)
 692:	f9f5                	bnez	a1,686 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 694:	8bce                	mv	s7,s3
      state = 0;
 696:	4981                	li	s3,0
 698:	bbd5                	j	48c <vprintf+0x4c>
          s = "(null)";
 69a:	00000917          	auipc	s2,0x0
 69e:	20e90913          	add	s2,s2,526 # 8a8 <malloc+0x100>
        for(; *s; s++)
 6a2:	02800593          	li	a1,40
 6a6:	b7c5                	j	686 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6a8:	8bce                	mv	s7,s3
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b3c5                	j	48c <vprintf+0x4c>
    }
  }
}
 6ae:	60e6                	ld	ra,88(sp)
 6b0:	6446                	ld	s0,80(sp)
 6b2:	64a6                	ld	s1,72(sp)
 6b4:	6906                	ld	s2,64(sp)
 6b6:	79e2                	ld	s3,56(sp)
 6b8:	7a42                	ld	s4,48(sp)
 6ba:	7aa2                	ld	s5,40(sp)
 6bc:	7b02                	ld	s6,32(sp)
 6be:	6be2                	ld	s7,24(sp)
 6c0:	6c42                	ld	s8,16(sp)
 6c2:	6ca2                	ld	s9,8(sp)
 6c4:	6d02                	ld	s10,0(sp)
 6c6:	6125                	add	sp,sp,96
 6c8:	8082                	ret

00000000000006ca <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ca:	715d                	add	sp,sp,-80
 6cc:	ec06                	sd	ra,24(sp)
 6ce:	e822                	sd	s0,16(sp)
 6d0:	1000                	add	s0,sp,32
 6d2:	e010                	sd	a2,0(s0)
 6d4:	e414                	sd	a3,8(s0)
 6d6:	e818                	sd	a4,16(s0)
 6d8:	ec1c                	sd	a5,24(s0)
 6da:	03043023          	sd	a6,32(s0)
 6de:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e6:	8622                	mv	a2,s0
 6e8:	d59ff0ef          	jal	440 <vprintf>
}
 6ec:	60e2                	ld	ra,24(sp)
 6ee:	6442                	ld	s0,16(sp)
 6f0:	6161                	add	sp,sp,80
 6f2:	8082                	ret

00000000000006f4 <printf>:

void
printf(const char *fmt, ...)
{
 6f4:	711d                	add	sp,sp,-96
 6f6:	ec06                	sd	ra,24(sp)
 6f8:	e822                	sd	s0,16(sp)
 6fa:	1000                	add	s0,sp,32
 6fc:	e40c                	sd	a1,8(s0)
 6fe:	e810                	sd	a2,16(s0)
 700:	ec14                	sd	a3,24(s0)
 702:	f018                	sd	a4,32(s0)
 704:	f41c                	sd	a5,40(s0)
 706:	03043823          	sd	a6,48(s0)
 70a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 70e:	00840613          	add	a2,s0,8
 712:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 716:	85aa                	mv	a1,a0
 718:	4505                	li	a0,1
 71a:	d27ff0ef          	jal	440 <vprintf>
}
 71e:	60e2                	ld	ra,24(sp)
 720:	6442                	ld	s0,16(sp)
 722:	6125                	add	sp,sp,96
 724:	8082                	ret

0000000000000726 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 726:	1141                	add	sp,sp,-16
 728:	e422                	sd	s0,8(sp)
 72a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	00001797          	auipc	a5,0x1
 734:	8d07b783          	ld	a5,-1840(a5) # 1000 <freep>
 738:	a02d                	j	762 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 73a:	4618                	lw	a4,8(a2)
 73c:	9f2d                	addw	a4,a4,a1
 73e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 742:	6398                	ld	a4,0(a5)
 744:	6310                	ld	a2,0(a4)
 746:	a83d                	j	784 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 748:	ff852703          	lw	a4,-8(a0)
 74c:	9f31                	addw	a4,a4,a2
 74e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 750:	ff053683          	ld	a3,-16(a0)
 754:	a091                	j	798 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 756:	6398                	ld	a4,0(a5)
 758:	00e7e463          	bltu	a5,a4,760 <free+0x3a>
 75c:	00e6ea63          	bltu	a3,a4,770 <free+0x4a>
{
 760:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 762:	fed7fae3          	bgeu	a5,a3,756 <free+0x30>
 766:	6398                	ld	a4,0(a5)
 768:	00e6e463          	bltu	a3,a4,770 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76c:	fee7eae3          	bltu	a5,a4,760 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 770:	ff852583          	lw	a1,-8(a0)
 774:	6390                	ld	a2,0(a5)
 776:	02059813          	sll	a6,a1,0x20
 77a:	01c85713          	srl	a4,a6,0x1c
 77e:	9736                	add	a4,a4,a3
 780:	fae60de3          	beq	a2,a4,73a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 784:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 788:	4790                	lw	a2,8(a5)
 78a:	02061593          	sll	a1,a2,0x20
 78e:	01c5d713          	srl	a4,a1,0x1c
 792:	973e                	add	a4,a4,a5
 794:	fae68ae3          	beq	a3,a4,748 <free+0x22>
    p->s.ptr = bp->s.ptr;
 798:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 79a:	00001717          	auipc	a4,0x1
 79e:	86f73323          	sd	a5,-1946(a4) # 1000 <freep>
}
 7a2:	6422                	ld	s0,8(sp)
 7a4:	0141                	add	sp,sp,16
 7a6:	8082                	ret

00000000000007a8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a8:	7139                	add	sp,sp,-64
 7aa:	fc06                	sd	ra,56(sp)
 7ac:	f822                	sd	s0,48(sp)
 7ae:	f426                	sd	s1,40(sp)
 7b0:	f04a                	sd	s2,32(sp)
 7b2:	ec4e                	sd	s3,24(sp)
 7b4:	e852                	sd	s4,16(sp)
 7b6:	e456                	sd	s5,8(sp)
 7b8:	e05a                	sd	s6,0(sp)
 7ba:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7bc:	02051493          	sll	s1,a0,0x20
 7c0:	9081                	srl	s1,s1,0x20
 7c2:	04bd                	add	s1,s1,15
 7c4:	8091                	srl	s1,s1,0x4
 7c6:	0014899b          	addw	s3,s1,1
 7ca:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7cc:	00001517          	auipc	a0,0x1
 7d0:	83453503          	ld	a0,-1996(a0) # 1000 <freep>
 7d4:	c515                	beqz	a0,800 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d8:	4798                	lw	a4,8(a5)
 7da:	02977f63          	bgeu	a4,s1,818 <malloc+0x70>
  if(nu < 4096)
 7de:	8a4e                	mv	s4,s3
 7e0:	0009871b          	sext.w	a4,s3
 7e4:	6685                	lui	a3,0x1
 7e6:	00d77363          	bgeu	a4,a3,7ec <malloc+0x44>
 7ea:	6a05                	lui	s4,0x1
 7ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f0:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f4:	00001917          	auipc	s2,0x1
 7f8:	80c90913          	add	s2,s2,-2036 # 1000 <freep>
  if(p == (char*)-1)
 7fc:	5afd                	li	s5,-1
 7fe:	a885                	j	86e <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 800:	00001797          	auipc	a5,0x1
 804:	81078793          	add	a5,a5,-2032 # 1010 <base>
 808:	00000717          	auipc	a4,0x0
 80c:	7ef73c23          	sd	a5,2040(a4) # 1000 <freep>
 810:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 812:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 816:	b7e1                	j	7de <malloc+0x36>
      if(p->s.size == nunits)
 818:	02e48c63          	beq	s1,a4,850 <malloc+0xa8>
        p->s.size -= nunits;
 81c:	4137073b          	subw	a4,a4,s3
 820:	c798                	sw	a4,8(a5)
        p += p->s.size;
 822:	02071693          	sll	a3,a4,0x20
 826:	01c6d713          	srl	a4,a3,0x1c
 82a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 82c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 830:	00000717          	auipc	a4,0x0
 834:	7ca73823          	sd	a0,2000(a4) # 1000 <freep>
      return (void*)(p + 1);
 838:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 83c:	70e2                	ld	ra,56(sp)
 83e:	7442                	ld	s0,48(sp)
 840:	74a2                	ld	s1,40(sp)
 842:	7902                	ld	s2,32(sp)
 844:	69e2                	ld	s3,24(sp)
 846:	6a42                	ld	s4,16(sp)
 848:	6aa2                	ld	s5,8(sp)
 84a:	6b02                	ld	s6,0(sp)
 84c:	6121                	add	sp,sp,64
 84e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 850:	6398                	ld	a4,0(a5)
 852:	e118                	sd	a4,0(a0)
 854:	bff1                	j	830 <malloc+0x88>
  hp->s.size = nu;
 856:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 85a:	0541                	add	a0,a0,16
 85c:	ecbff0ef          	jal	726 <free>
  return freep;
 860:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 864:	dd61                	beqz	a0,83c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 866:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 868:	4798                	lw	a4,8(a5)
 86a:	fa9777e3          	bgeu	a4,s1,818 <malloc+0x70>
    if(p == freep)
 86e:	00093703          	ld	a4,0(s2)
 872:	853e                	mv	a0,a5
 874:	fef719e3          	bne	a4,a5,866 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 878:	8552                	mv	a0,s4
 87a:	ac9ff0ef          	jal	342 <sbrk>
  if(p == (char*)-1)
 87e:	fd551ce3          	bne	a0,s5,856 <malloc+0xae>
        return 0;
 882:	4501                	li	a0,0
 884:	bf65                	j	83c <malloc+0x94>
