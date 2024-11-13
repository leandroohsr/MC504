
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	add	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	add	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  12:	4785                	li	a5,1
  14:	06a7d063          	bge	a5,a0,74 <main+0x74>
  18:	00858493          	add	s1,a1,8
  1c:	3579                	addw	a0,a0,-2
  1e:	02051793          	sll	a5,a0,0x20
  22:	01d7d513          	srl	a0,a5,0x1d
  26:	00a48a33          	add	s4,s1,a0
  2a:	05c1                	add	a1,a1,16
  2c:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  30:	00001a97          	auipc	s5,0x1
  34:	8b0a8a93          	add	s5,s5,-1872 # 8e0 <malloc+0xe6>
  38:	a809                	j	4a <main+0x4a>
  3a:	4605                	li	a2,1
  3c:	85d6                	mv	a1,s5
  3e:	4505                	li	a0,1
  40:	2c4000ef          	jal	304 <write>
  for(i = 1; i < argc; i++){
  44:	04a1                	add	s1,s1,8
  46:	03348763          	beq	s1,s3,74 <main+0x74>
    write(1, argv[i], strlen(argv[i]));
  4a:	0004b903          	ld	s2,0(s1)
  4e:	854a                	mv	a0,s2
  50:	084000ef          	jal	d4 <strlen>
  54:	0005061b          	sext.w	a2,a0
  58:	85ca                	mv	a1,s2
  5a:	4505                	li	a0,1
  5c:	2a8000ef          	jal	304 <write>
    if(i + 1 < argc){
  60:	fd449de3          	bne	s1,s4,3a <main+0x3a>
    } else {
      write(1, "\n", 1);
  64:	4605                	li	a2,1
  66:	00001597          	auipc	a1,0x1
  6a:	88258593          	add	a1,a1,-1918 # 8e8 <malloc+0xee>
  6e:	4505                	li	a0,1
  70:	294000ef          	jal	304 <write>
    }
  }
  exit(0);
  74:	4501                	li	a0,0
  76:	26e000ef          	jal	2e4 <exit>

000000000000007a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  7a:	1141                	add	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	add	s0,sp,16
  extern int main();
  main();
  82:	f7fff0ef          	jal	0 <main>
  exit(0);
  86:	4501                	li	a0,0
  88:	25c000ef          	jal	2e4 <exit>

000000000000008c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  8c:	1141                	add	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  92:	87aa                	mv	a5,a0
  94:	0585                	add	a1,a1,1
  96:	0785                	add	a5,a5,1
  98:	fff5c703          	lbu	a4,-1(a1)
  9c:	fee78fa3          	sb	a4,-1(a5)
  a0:	fb75                	bnez	a4,94 <strcpy+0x8>
    ;
  return os;
}
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	add	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a8:	1141                	add	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cb91                	beqz	a5,c6 <strcmp+0x1e>
  b4:	0005c703          	lbu	a4,0(a1)
  b8:	00f71763          	bne	a4,a5,c6 <strcmp+0x1e>
    p++, q++;
  bc:	0505                	add	a0,a0,1
  be:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	fbe5                	bnez	a5,b4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  c6:	0005c503          	lbu	a0,0(a1)
}
  ca:	40a7853b          	subw	a0,a5,a0
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	add	sp,sp,16
  d2:	8082                	ret

00000000000000d4 <strlen>:

uint
strlen(const char *s)
{
  d4:	1141                	add	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cf91                	beqz	a5,fa <strlen+0x26>
  e0:	0505                	add	a0,a0,1
  e2:	87aa                	mv	a5,a0
  e4:	86be                	mv	a3,a5
  e6:	0785                	add	a5,a5,1
  e8:	fff7c703          	lbu	a4,-1(a5)
  ec:	ff65                	bnez	a4,e4 <strlen+0x10>
  ee:	40a6853b          	subw	a0,a3,a0
  f2:	2505                	addw	a0,a0,1
    ;
  return n;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	add	sp,sp,16
  f8:	8082                	ret
  for(n = 0; s[n]; n++)
  fa:	4501                	li	a0,0
  fc:	bfe5                	j	f4 <strlen+0x20>

00000000000000fe <memset>:

void*
memset(void *dst, int c, uint n)
{
  fe:	1141                	add	sp,sp,-16
 100:	e422                	sd	s0,8(sp)
 102:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 104:	ca19                	beqz	a2,11a <memset+0x1c>
 106:	87aa                	mv	a5,a0
 108:	1602                	sll	a2,a2,0x20
 10a:	9201                	srl	a2,a2,0x20
 10c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 110:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 114:	0785                	add	a5,a5,1
 116:	fee79de3          	bne	a5,a4,110 <memset+0x12>
  }
  return dst;
}
 11a:	6422                	ld	s0,8(sp)
 11c:	0141                	add	sp,sp,16
 11e:	8082                	ret

0000000000000120 <strchr>:

char*
strchr(const char *s, char c)
{
 120:	1141                	add	sp,sp,-16
 122:	e422                	sd	s0,8(sp)
 124:	0800                	add	s0,sp,16
  for(; *s; s++)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cb99                	beqz	a5,140 <strchr+0x20>
    if(*s == c)
 12c:	00f58763          	beq	a1,a5,13a <strchr+0x1a>
  for(; *s; s++)
 130:	0505                	add	a0,a0,1
 132:	00054783          	lbu	a5,0(a0)
 136:	fbfd                	bnez	a5,12c <strchr+0xc>
      return (char*)s;
  return 0;
 138:	4501                	li	a0,0
}
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	add	sp,sp,16
 13e:	8082                	ret
  return 0;
 140:	4501                	li	a0,0
 142:	bfe5                	j	13a <strchr+0x1a>

0000000000000144 <gets>:

char*
gets(char *buf, int max)
{
 144:	711d                	add	sp,sp,-96
 146:	ec86                	sd	ra,88(sp)
 148:	e8a2                	sd	s0,80(sp)
 14a:	e4a6                	sd	s1,72(sp)
 14c:	e0ca                	sd	s2,64(sp)
 14e:	fc4e                	sd	s3,56(sp)
 150:	f852                	sd	s4,48(sp)
 152:	f456                	sd	s5,40(sp)
 154:	f05a                	sd	s6,32(sp)
 156:	ec5e                	sd	s7,24(sp)
 158:	1080                	add	s0,sp,96
 15a:	8baa                	mv	s7,a0
 15c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15e:	892a                	mv	s2,a0
 160:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 162:	4aa9                	li	s5,10
 164:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 166:	89a6                	mv	s3,s1
 168:	2485                	addw	s1,s1,1
 16a:	0344d663          	bge	s1,s4,196 <gets+0x52>
    cc = read(0, &c, 1);
 16e:	4605                	li	a2,1
 170:	faf40593          	add	a1,s0,-81
 174:	4501                	li	a0,0
 176:	186000ef          	jal	2fc <read>
    if(cc < 1)
 17a:	00a05e63          	blez	a0,196 <gets+0x52>
    buf[i++] = c;
 17e:	faf44783          	lbu	a5,-81(s0)
 182:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 186:	01578763          	beq	a5,s5,194 <gets+0x50>
 18a:	0905                	add	s2,s2,1
 18c:	fd679de3          	bne	a5,s6,166 <gets+0x22>
  for(i=0; i+1 < max; ){
 190:	89a6                	mv	s3,s1
 192:	a011                	j	196 <gets+0x52>
 194:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 196:	99de                	add	s3,s3,s7
 198:	00098023          	sb	zero,0(s3)
  return buf;
}
 19c:	855e                	mv	a0,s7
 19e:	60e6                	ld	ra,88(sp)
 1a0:	6446                	ld	s0,80(sp)
 1a2:	64a6                	ld	s1,72(sp)
 1a4:	6906                	ld	s2,64(sp)
 1a6:	79e2                	ld	s3,56(sp)
 1a8:	7a42                	ld	s4,48(sp)
 1aa:	7aa2                	ld	s5,40(sp)
 1ac:	7b02                	ld	s6,32(sp)
 1ae:	6be2                	ld	s7,24(sp)
 1b0:	6125                	add	sp,sp,96
 1b2:	8082                	ret

00000000000001b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b4:	1101                	add	sp,sp,-32
 1b6:	ec06                	sd	ra,24(sp)
 1b8:	e822                	sd	s0,16(sp)
 1ba:	e426                	sd	s1,8(sp)
 1bc:	e04a                	sd	s2,0(sp)
 1be:	1000                	add	s0,sp,32
 1c0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c2:	4581                	li	a1,0
 1c4:	160000ef          	jal	324 <open>
  if(fd < 0)
 1c8:	02054163          	bltz	a0,1ea <stat+0x36>
 1cc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ce:	85ca                	mv	a1,s2
 1d0:	16c000ef          	jal	33c <fstat>
 1d4:	892a                	mv	s2,a0
  close(fd);
 1d6:	8526                	mv	a0,s1
 1d8:	134000ef          	jal	30c <close>
  return r;
}
 1dc:	854a                	mv	a0,s2
 1de:	60e2                	ld	ra,24(sp)
 1e0:	6442                	ld	s0,16(sp)
 1e2:	64a2                	ld	s1,8(sp)
 1e4:	6902                	ld	s2,0(sp)
 1e6:	6105                	add	sp,sp,32
 1e8:	8082                	ret
    return -1;
 1ea:	597d                	li	s2,-1
 1ec:	bfc5                	j	1dc <stat+0x28>

00000000000001ee <atoi>:

int
atoi(const char *s)
{
 1ee:	1141                	add	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f4:	00054683          	lbu	a3,0(a0)
 1f8:	fd06879b          	addw	a5,a3,-48
 1fc:	0ff7f793          	zext.b	a5,a5
 200:	4625                	li	a2,9
 202:	02f66863          	bltu	a2,a5,232 <atoi+0x44>
 206:	872a                	mv	a4,a0
  n = 0;
 208:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 20a:	0705                	add	a4,a4,1
 20c:	0025179b          	sllw	a5,a0,0x2
 210:	9fa9                	addw	a5,a5,a0
 212:	0017979b          	sllw	a5,a5,0x1
 216:	9fb5                	addw	a5,a5,a3
 218:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21c:	00074683          	lbu	a3,0(a4)
 220:	fd06879b          	addw	a5,a3,-48
 224:	0ff7f793          	zext.b	a5,a5
 228:	fef671e3          	bgeu	a2,a5,20a <atoi+0x1c>
  return n;
}
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	add	sp,sp,16
 230:	8082                	ret
  n = 0;
 232:	4501                	li	a0,0
 234:	bfe5                	j	22c <atoi+0x3e>

0000000000000236 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 236:	1141                	add	sp,sp,-16
 238:	e422                	sd	s0,8(sp)
 23a:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23c:	02b57463          	bgeu	a0,a1,264 <memmove+0x2e>
    while(n-- > 0)
 240:	00c05f63          	blez	a2,25e <memmove+0x28>
 244:	1602                	sll	a2,a2,0x20
 246:	9201                	srl	a2,a2,0x20
 248:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24c:	872a                	mv	a4,a0
      *dst++ = *src++;
 24e:	0585                	add	a1,a1,1
 250:	0705                	add	a4,a4,1
 252:	fff5c683          	lbu	a3,-1(a1)
 256:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25a:	fee79ae3          	bne	a5,a4,24e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	add	sp,sp,16
 262:	8082                	ret
    dst += n;
 264:	00c50733          	add	a4,a0,a2
    src += n;
 268:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 26a:	fec05ae3          	blez	a2,25e <memmove+0x28>
 26e:	fff6079b          	addw	a5,a2,-1
 272:	1782                	sll	a5,a5,0x20
 274:	9381                	srl	a5,a5,0x20
 276:	fff7c793          	not	a5,a5
 27a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27c:	15fd                	add	a1,a1,-1
 27e:	177d                	add	a4,a4,-1
 280:	0005c683          	lbu	a3,0(a1)
 284:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 288:	fee79ae3          	bne	a5,a4,27c <memmove+0x46>
 28c:	bfc9                	j	25e <memmove+0x28>

000000000000028e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28e:	1141                	add	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 294:	ca05                	beqz	a2,2c4 <memcmp+0x36>
 296:	fff6069b          	addw	a3,a2,-1
 29a:	1682                	sll	a3,a3,0x20
 29c:	9281                	srl	a3,a3,0x20
 29e:	0685                	add	a3,a3,1
 2a0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	0005c703          	lbu	a4,0(a1)
 2aa:	00e79863          	bne	a5,a4,2ba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ae:	0505                	add	a0,a0,1
    p2++;
 2b0:	0585                	add	a1,a1,1
  while (n-- > 0) {
 2b2:	fed518e3          	bne	a0,a3,2a2 <memcmp+0x14>
  }
  return 0;
 2b6:	4501                	li	a0,0
 2b8:	a019                	j	2be <memcmp+0x30>
      return *p1 - *p2;
 2ba:	40e7853b          	subw	a0,a5,a4
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	add	sp,sp,16
 2c2:	8082                	ret
  return 0;
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <memcmp+0x30>

00000000000002c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c8:	1141                	add	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2d0:	f67ff0ef          	jal	236 <memmove>
}
 2d4:	60a2                	ld	ra,8(sp)
 2d6:	6402                	ld	s0,0(sp)
 2d8:	0141                	add	sp,sp,16
 2da:	8082                	ret

00000000000002dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2dc:	4885                	li	a7,1
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e4:	4889                	li	a7,2
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ec:	488d                	li	a7,3
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f4:	4891                	li	a7,4
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <read>:
.global read
read:
 li a7, SYS_read
 2fc:	4895                	li	a7,5
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <write>:
.global write
write:
 li a7, SYS_write
 304:	48c1                	li	a7,16
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <close>:
.global close
close:
 li a7, SYS_close
 30c:	48d5                	li	a7,21
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <kill>:
.global kill
kill:
 li a7, SYS_kill
 314:	4899                	li	a7,6
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <exec>:
.global exec
exec:
 li a7, SYS_exec
 31c:	489d                	li	a7,7
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <open>:
.global open
open:
 li a7, SYS_open
 324:	48bd                	li	a7,15
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 32c:	48c5                	li	a7,17
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 334:	48c9                	li	a7,18
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 33c:	48a1                	li	a7,8
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <link>:
.global link
link:
 li a7, SYS_link
 344:	48cd                	li	a7,19
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 34c:	48d1                	li	a7,20
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 354:	48a5                	li	a7,9
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <dup>:
.global dup
dup:
 li a7, SYS_dup
 35c:	48a9                	li	a7,10
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 364:	48ad                	li	a7,11
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 36c:	48b1                	li	a7,12
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 374:	48b5                	li	a7,13
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 37c:	48b9                	li	a7,14
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 384:	48d9                	li	a7,22
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 38c:	48dd                	li	a7,23
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 394:	48e1                	li	a7,24
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 39c:	48e5                	li	a7,25
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 3a4:	48e9                	li	a7,26
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 3ac:	48ed                	li	a7,27
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 3b4:	48f1                	li	a7,28
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <uptime_nolock>:
.global uptime_nolock
uptime_nolock:
 li a7, SYS_uptime_nolock
 3bc:	48f5                	li	a7,29
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <set_type>:
.global set_type
set_type:
 li a7, SYS_set_type
 3c4:	48f9                	li	a7,30
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3cc:	1101                	add	sp,sp,-32
 3ce:	ec06                	sd	ra,24(sp)
 3d0:	e822                	sd	s0,16(sp)
 3d2:	1000                	add	s0,sp,32
 3d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d8:	4605                	li	a2,1
 3da:	fef40593          	add	a1,s0,-17
 3de:	f27ff0ef          	jal	304 <write>
}
 3e2:	60e2                	ld	ra,24(sp)
 3e4:	6442                	ld	s0,16(sp)
 3e6:	6105                	add	sp,sp,32
 3e8:	8082                	ret

00000000000003ea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ea:	7139                	add	sp,sp,-64
 3ec:	fc06                	sd	ra,56(sp)
 3ee:	f822                	sd	s0,48(sp)
 3f0:	f426                	sd	s1,40(sp)
 3f2:	f04a                	sd	s2,32(sp)
 3f4:	ec4e                	sd	s3,24(sp)
 3f6:	0080                	add	s0,sp,64
 3f8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fa:	c299                	beqz	a3,400 <printint+0x16>
 3fc:	0805c763          	bltz	a1,48a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 400:	2581                	sext.w	a1,a1
  neg = 0;
 402:	4881                	li	a7,0
 404:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 408:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 40a:	2601                	sext.w	a2,a2
 40c:	00000517          	auipc	a0,0x0
 410:	4ec50513          	add	a0,a0,1260 # 8f8 <digits>
 414:	883a                	mv	a6,a4
 416:	2705                	addw	a4,a4,1
 418:	02c5f7bb          	remuw	a5,a1,a2
 41c:	1782                	sll	a5,a5,0x20
 41e:	9381                	srl	a5,a5,0x20
 420:	97aa                	add	a5,a5,a0
 422:	0007c783          	lbu	a5,0(a5)
 426:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 42a:	0005879b          	sext.w	a5,a1
 42e:	02c5d5bb          	divuw	a1,a1,a2
 432:	0685                	add	a3,a3,1
 434:	fec7f0e3          	bgeu	a5,a2,414 <printint+0x2a>
  if(neg)
 438:	00088c63          	beqz	a7,450 <printint+0x66>
    buf[i++] = '-';
 43c:	fd070793          	add	a5,a4,-48
 440:	00878733          	add	a4,a5,s0
 444:	02d00793          	li	a5,45
 448:	fef70823          	sb	a5,-16(a4)
 44c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 450:	02e05663          	blez	a4,47c <printint+0x92>
 454:	fc040793          	add	a5,s0,-64
 458:	00e78933          	add	s2,a5,a4
 45c:	fff78993          	add	s3,a5,-1
 460:	99ba                	add	s3,s3,a4
 462:	377d                	addw	a4,a4,-1
 464:	1702                	sll	a4,a4,0x20
 466:	9301                	srl	a4,a4,0x20
 468:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 46c:	fff94583          	lbu	a1,-1(s2)
 470:	8526                	mv	a0,s1
 472:	f5bff0ef          	jal	3cc <putc>
  while(--i >= 0)
 476:	197d                	add	s2,s2,-1
 478:	ff391ae3          	bne	s2,s3,46c <printint+0x82>
}
 47c:	70e2                	ld	ra,56(sp)
 47e:	7442                	ld	s0,48(sp)
 480:	74a2                	ld	s1,40(sp)
 482:	7902                	ld	s2,32(sp)
 484:	69e2                	ld	s3,24(sp)
 486:	6121                	add	sp,sp,64
 488:	8082                	ret
    x = -xx;
 48a:	40b005bb          	negw	a1,a1
    neg = 1;
 48e:	4885                	li	a7,1
    x = -xx;
 490:	bf95                	j	404 <printint+0x1a>

0000000000000492 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 492:	711d                	add	sp,sp,-96
 494:	ec86                	sd	ra,88(sp)
 496:	e8a2                	sd	s0,80(sp)
 498:	e4a6                	sd	s1,72(sp)
 49a:	e0ca                	sd	s2,64(sp)
 49c:	fc4e                	sd	s3,56(sp)
 49e:	f852                	sd	s4,48(sp)
 4a0:	f456                	sd	s5,40(sp)
 4a2:	f05a                	sd	s6,32(sp)
 4a4:	ec5e                	sd	s7,24(sp)
 4a6:	e862                	sd	s8,16(sp)
 4a8:	e466                	sd	s9,8(sp)
 4aa:	e06a                	sd	s10,0(sp)
 4ac:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ae:	0005c903          	lbu	s2,0(a1)
 4b2:	24090763          	beqz	s2,700 <vprintf+0x26e>
 4b6:	8b2a                	mv	s6,a0
 4b8:	8a2e                	mv	s4,a1
 4ba:	8bb2                	mv	s7,a2
  state = 0;
 4bc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4be:	4481                	li	s1,0
 4c0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4c2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4c6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ca:	06c00c93          	li	s9,108
 4ce:	a005                	j	4ee <vprintf+0x5c>
        putc(fd, c0);
 4d0:	85ca                	mv	a1,s2
 4d2:	855a                	mv	a0,s6
 4d4:	ef9ff0ef          	jal	3cc <putc>
 4d8:	a019                	j	4de <vprintf+0x4c>
    } else if(state == '%'){
 4da:	03598263          	beq	s3,s5,4fe <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4de:	2485                	addw	s1,s1,1
 4e0:	8726                	mv	a4,s1
 4e2:	009a07b3          	add	a5,s4,s1
 4e6:	0007c903          	lbu	s2,0(a5)
 4ea:	20090b63          	beqz	s2,700 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4ee:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4f2:	fe0994e3          	bnez	s3,4da <vprintf+0x48>
      if(c0 == '%'){
 4f6:	fd579de3          	bne	a5,s5,4d0 <vprintf+0x3e>
        state = '%';
 4fa:	89be                	mv	s3,a5
 4fc:	b7cd                	j	4de <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 4fe:	c7c9                	beqz	a5,588 <vprintf+0xf6>
 500:	00ea06b3          	add	a3,s4,a4
 504:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 508:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 50a:	c681                	beqz	a3,512 <vprintf+0x80>
 50c:	9752                	add	a4,a4,s4
 50e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 512:	03878f63          	beq	a5,s8,550 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 516:	05978963          	beq	a5,s9,568 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 51a:	07500713          	li	a4,117
 51e:	0ee78363          	beq	a5,a4,604 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 522:	07800713          	li	a4,120
 526:	12e78563          	beq	a5,a4,650 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 52a:	07000713          	li	a4,112
 52e:	14e78a63          	beq	a5,a4,682 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 532:	07300713          	li	a4,115
 536:	18e78863          	beq	a5,a4,6c6 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 53a:	02500713          	li	a4,37
 53e:	04e79563          	bne	a5,a4,588 <vprintf+0xf6>
        putc(fd, '%');
 542:	02500593          	li	a1,37
 546:	855a                	mv	a0,s6
 548:	e85ff0ef          	jal	3cc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 54c:	4981                	li	s3,0
 54e:	bf41                	j	4de <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 550:	008b8913          	add	s2,s7,8
 554:	4685                	li	a3,1
 556:	4629                	li	a2,10
 558:	000ba583          	lw	a1,0(s7)
 55c:	855a                	mv	a0,s6
 55e:	e8dff0ef          	jal	3ea <printint>
 562:	8bca                	mv	s7,s2
      state = 0;
 564:	4981                	li	s3,0
 566:	bfa5                	j	4de <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 568:	06400793          	li	a5,100
 56c:	02f68963          	beq	a3,a5,59e <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 570:	06c00793          	li	a5,108
 574:	04f68263          	beq	a3,a5,5b8 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 578:	07500793          	li	a5,117
 57c:	0af68063          	beq	a3,a5,61c <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 580:	07800793          	li	a5,120
 584:	0ef68263          	beq	a3,a5,668 <vprintf+0x1d6>
        putc(fd, '%');
 588:	02500593          	li	a1,37
 58c:	855a                	mv	a0,s6
 58e:	e3fff0ef          	jal	3cc <putc>
        putc(fd, c0);
 592:	85ca                	mv	a1,s2
 594:	855a                	mv	a0,s6
 596:	e37ff0ef          	jal	3cc <putc>
      state = 0;
 59a:	4981                	li	s3,0
 59c:	b789                	j	4de <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	008b8913          	add	s2,s7,8
 5a2:	4685                	li	a3,1
 5a4:	4629                	li	a2,10
 5a6:	000ba583          	lw	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	e3fff0ef          	jal	3ea <printint>
        i += 1;
 5b0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b2:	8bca                	mv	s7,s2
      state = 0;
 5b4:	4981                	li	s3,0
        i += 1;
 5b6:	b725                	j	4de <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b8:	06400793          	li	a5,100
 5bc:	02f60763          	beq	a2,a5,5ea <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5c0:	07500793          	li	a5,117
 5c4:	06f60963          	beq	a2,a5,636 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5c8:	07800793          	li	a5,120
 5cc:	faf61ee3          	bne	a2,a5,588 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d0:	008b8913          	add	s2,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4641                	li	a2,16
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	e0dff0ef          	jal	3ea <printint>
        i += 2;
 5e2:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e4:	8bca                	mv	s7,s2
      state = 0;
 5e6:	4981                	li	s3,0
        i += 2;
 5e8:	bddd                	j	4de <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ea:	008b8913          	add	s2,s7,8
 5ee:	4685                	li	a3,1
 5f0:	4629                	li	a2,10
 5f2:	000ba583          	lw	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	df3ff0ef          	jal	3ea <printint>
        i += 2;
 5fc:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
        i += 2;
 602:	bdf1                	j	4de <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 604:	008b8913          	add	s2,s7,8
 608:	4681                	li	a3,0
 60a:	4629                	li	a2,10
 60c:	000ba583          	lw	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	dd9ff0ef          	jal	3ea <printint>
 616:	8bca                	mv	s7,s2
      state = 0;
 618:	4981                	li	s3,0
 61a:	b5d1                	j	4de <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61c:	008b8913          	add	s2,s7,8
 620:	4681                	li	a3,0
 622:	4629                	li	a2,10
 624:	000ba583          	lw	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	dc1ff0ef          	jal	3ea <printint>
        i += 1;
 62e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 630:	8bca                	mv	s7,s2
      state = 0;
 632:	4981                	li	s3,0
        i += 1;
 634:	b56d                	j	4de <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 636:	008b8913          	add	s2,s7,8
 63a:	4681                	li	a3,0
 63c:	4629                	li	a2,10
 63e:	000ba583          	lw	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	da7ff0ef          	jal	3ea <printint>
        i += 2;
 648:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
        i += 2;
 64e:	bd41                	j	4de <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 650:	008b8913          	add	s2,s7,8
 654:	4681                	li	a3,0
 656:	4641                	li	a2,16
 658:	000ba583          	lw	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	d8dff0ef          	jal	3ea <printint>
 662:	8bca                	mv	s7,s2
      state = 0;
 664:	4981                	li	s3,0
 666:	bda5                	j	4de <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	008b8913          	add	s2,s7,8
 66c:	4681                	li	a3,0
 66e:	4641                	li	a2,16
 670:	000ba583          	lw	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	d75ff0ef          	jal	3ea <printint>
        i += 1;
 67a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
        i += 1;
 680:	bdb9                	j	4de <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 682:	008b8d13          	add	s10,s7,8
 686:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 68a:	03000593          	li	a1,48
 68e:	855a                	mv	a0,s6
 690:	d3dff0ef          	jal	3cc <putc>
  putc(fd, 'x');
 694:	07800593          	li	a1,120
 698:	855a                	mv	a0,s6
 69a:	d33ff0ef          	jal	3cc <putc>
 69e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a0:	00000b97          	auipc	s7,0x0
 6a4:	258b8b93          	add	s7,s7,600 # 8f8 <digits>
 6a8:	03c9d793          	srl	a5,s3,0x3c
 6ac:	97de                	add	a5,a5,s7
 6ae:	0007c583          	lbu	a1,0(a5)
 6b2:	855a                	mv	a0,s6
 6b4:	d19ff0ef          	jal	3cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b8:	0992                	sll	s3,s3,0x4
 6ba:	397d                	addw	s2,s2,-1
 6bc:	fe0916e3          	bnez	s2,6a8 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 6c0:	8bea                	mv	s7,s10
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	bd29                	j	4de <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 6c6:	008b8993          	add	s3,s7,8
 6ca:	000bb903          	ld	s2,0(s7)
 6ce:	00090f63          	beqz	s2,6ec <vprintf+0x25a>
        for(; *s; s++)
 6d2:	00094583          	lbu	a1,0(s2)
 6d6:	c195                	beqz	a1,6fa <vprintf+0x268>
          putc(fd, *s);
 6d8:	855a                	mv	a0,s6
 6da:	cf3ff0ef          	jal	3cc <putc>
        for(; *s; s++)
 6de:	0905                	add	s2,s2,1
 6e0:	00094583          	lbu	a1,0(s2)
 6e4:	f9f5                	bnez	a1,6d8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6e6:	8bce                	mv	s7,s3
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bbd5                	j	4de <vprintf+0x4c>
          s = "(null)";
 6ec:	00000917          	auipc	s2,0x0
 6f0:	20490913          	add	s2,s2,516 # 8f0 <malloc+0xf6>
        for(; *s; s++)
 6f4:	02800593          	li	a1,40
 6f8:	b7c5                	j	6d8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6fa:	8bce                	mv	s7,s3
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b3c5                	j	4de <vprintf+0x4c>
    }
  }
}
 700:	60e6                	ld	ra,88(sp)
 702:	6446                	ld	s0,80(sp)
 704:	64a6                	ld	s1,72(sp)
 706:	6906                	ld	s2,64(sp)
 708:	79e2                	ld	s3,56(sp)
 70a:	7a42                	ld	s4,48(sp)
 70c:	7aa2                	ld	s5,40(sp)
 70e:	7b02                	ld	s6,32(sp)
 710:	6be2                	ld	s7,24(sp)
 712:	6c42                	ld	s8,16(sp)
 714:	6ca2                	ld	s9,8(sp)
 716:	6d02                	ld	s10,0(sp)
 718:	6125                	add	sp,sp,96
 71a:	8082                	ret

000000000000071c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 71c:	715d                	add	sp,sp,-80
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	add	s0,sp,32
 724:	e010                	sd	a2,0(s0)
 726:	e414                	sd	a3,8(s0)
 728:	e818                	sd	a4,16(s0)
 72a:	ec1c                	sd	a5,24(s0)
 72c:	03043023          	sd	a6,32(s0)
 730:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 734:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 738:	8622                	mv	a2,s0
 73a:	d59ff0ef          	jal	492 <vprintf>
}
 73e:	60e2                	ld	ra,24(sp)
 740:	6442                	ld	s0,16(sp)
 742:	6161                	add	sp,sp,80
 744:	8082                	ret

0000000000000746 <printf>:

void
printf(const char *fmt, ...)
{
 746:	711d                	add	sp,sp,-96
 748:	ec06                	sd	ra,24(sp)
 74a:	e822                	sd	s0,16(sp)
 74c:	1000                	add	s0,sp,32
 74e:	e40c                	sd	a1,8(s0)
 750:	e810                	sd	a2,16(s0)
 752:	ec14                	sd	a3,24(s0)
 754:	f018                	sd	a4,32(s0)
 756:	f41c                	sd	a5,40(s0)
 758:	03043823          	sd	a6,48(s0)
 75c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 760:	00840613          	add	a2,s0,8
 764:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 768:	85aa                	mv	a1,a0
 76a:	4505                	li	a0,1
 76c:	d27ff0ef          	jal	492 <vprintf>
}
 770:	60e2                	ld	ra,24(sp)
 772:	6442                	ld	s0,16(sp)
 774:	6125                	add	sp,sp,96
 776:	8082                	ret

0000000000000778 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 778:	1141                	add	sp,sp,-16
 77a:	e422                	sd	s0,8(sp)
 77c:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77e:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 782:	00001797          	auipc	a5,0x1
 786:	87e7b783          	ld	a5,-1922(a5) # 1000 <freep>
 78a:	a02d                	j	7b4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 78c:	4618                	lw	a4,8(a2)
 78e:	9f2d                	addw	a4,a4,a1
 790:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 794:	6398                	ld	a4,0(a5)
 796:	6310                	ld	a2,0(a4)
 798:	a83d                	j	7d6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 79a:	ff852703          	lw	a4,-8(a0)
 79e:	9f31                	addw	a4,a4,a2
 7a0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7a2:	ff053683          	ld	a3,-16(a0)
 7a6:	a091                	j	7ea <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	6398                	ld	a4,0(a5)
 7aa:	00e7e463          	bltu	a5,a4,7b2 <free+0x3a>
 7ae:	00e6ea63          	bltu	a3,a4,7c2 <free+0x4a>
{
 7b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b4:	fed7fae3          	bgeu	a5,a3,7a8 <free+0x30>
 7b8:	6398                	ld	a4,0(a5)
 7ba:	00e6e463          	bltu	a3,a4,7c2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7be:	fee7eae3          	bltu	a5,a4,7b2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7c2:	ff852583          	lw	a1,-8(a0)
 7c6:	6390                	ld	a2,0(a5)
 7c8:	02059813          	sll	a6,a1,0x20
 7cc:	01c85713          	srl	a4,a6,0x1c
 7d0:	9736                	add	a4,a4,a3
 7d2:	fae60de3          	beq	a2,a4,78c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7da:	4790                	lw	a2,8(a5)
 7dc:	02061593          	sll	a1,a2,0x20
 7e0:	01c5d713          	srl	a4,a1,0x1c
 7e4:	973e                	add	a4,a4,a5
 7e6:	fae68ae3          	beq	a3,a4,79a <free+0x22>
    p->s.ptr = bp->s.ptr;
 7ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ec:	00001717          	auipc	a4,0x1
 7f0:	80f73a23          	sd	a5,-2028(a4) # 1000 <freep>
}
 7f4:	6422                	ld	s0,8(sp)
 7f6:	0141                	add	sp,sp,16
 7f8:	8082                	ret

00000000000007fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7fa:	7139                	add	sp,sp,-64
 7fc:	fc06                	sd	ra,56(sp)
 7fe:	f822                	sd	s0,48(sp)
 800:	f426                	sd	s1,40(sp)
 802:	f04a                	sd	s2,32(sp)
 804:	ec4e                	sd	s3,24(sp)
 806:	e852                	sd	s4,16(sp)
 808:	e456                	sd	s5,8(sp)
 80a:	e05a                	sd	s6,0(sp)
 80c:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80e:	02051493          	sll	s1,a0,0x20
 812:	9081                	srl	s1,s1,0x20
 814:	04bd                	add	s1,s1,15
 816:	8091                	srl	s1,s1,0x4
 818:	0014899b          	addw	s3,s1,1
 81c:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 81e:	00000517          	auipc	a0,0x0
 822:	7e253503          	ld	a0,2018(a0) # 1000 <freep>
 826:	c515                	beqz	a0,852 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82a:	4798                	lw	a4,8(a5)
 82c:	02977f63          	bgeu	a4,s1,86a <malloc+0x70>
  if(nu < 4096)
 830:	8a4e                	mv	s4,s3
 832:	0009871b          	sext.w	a4,s3
 836:	6685                	lui	a3,0x1
 838:	00d77363          	bgeu	a4,a3,83e <malloc+0x44>
 83c:	6a05                	lui	s4,0x1
 83e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 842:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 846:	00000917          	auipc	s2,0x0
 84a:	7ba90913          	add	s2,s2,1978 # 1000 <freep>
  if(p == (char*)-1)
 84e:	5afd                	li	s5,-1
 850:	a885                	j	8c0 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 852:	00000797          	auipc	a5,0x0
 856:	7be78793          	add	a5,a5,1982 # 1010 <base>
 85a:	00000717          	auipc	a4,0x0
 85e:	7af73323          	sd	a5,1958(a4) # 1000 <freep>
 862:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 864:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 868:	b7e1                	j	830 <malloc+0x36>
      if(p->s.size == nunits)
 86a:	02e48c63          	beq	s1,a4,8a2 <malloc+0xa8>
        p->s.size -= nunits;
 86e:	4137073b          	subw	a4,a4,s3
 872:	c798                	sw	a4,8(a5)
        p += p->s.size;
 874:	02071693          	sll	a3,a4,0x20
 878:	01c6d713          	srl	a4,a3,0x1c
 87c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 87e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 882:	00000717          	auipc	a4,0x0
 886:	76a73f23          	sd	a0,1918(a4) # 1000 <freep>
      return (void*)(p + 1);
 88a:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 88e:	70e2                	ld	ra,56(sp)
 890:	7442                	ld	s0,48(sp)
 892:	74a2                	ld	s1,40(sp)
 894:	7902                	ld	s2,32(sp)
 896:	69e2                	ld	s3,24(sp)
 898:	6a42                	ld	s4,16(sp)
 89a:	6aa2                	ld	s5,8(sp)
 89c:	6b02                	ld	s6,0(sp)
 89e:	6121                	add	sp,sp,64
 8a0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8a2:	6398                	ld	a4,0(a5)
 8a4:	e118                	sd	a4,0(a0)
 8a6:	bff1                	j	882 <malloc+0x88>
  hp->s.size = nu;
 8a8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ac:	0541                	add	a0,a0,16
 8ae:	ecbff0ef          	jal	778 <free>
  return freep;
 8b2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8b6:	dd61                	beqz	a0,88e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ba:	4798                	lw	a4,8(a5)
 8bc:	fa9777e3          	bgeu	a4,s1,86a <malloc+0x70>
    if(p == freep)
 8c0:	00093703          	ld	a4,0(s2)
 8c4:	853e                	mv	a0,a5
 8c6:	fef719e3          	bne	a4,a5,8b8 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 8ca:	8552                	mv	a0,s4
 8cc:	aa1ff0ef          	jal	36c <sbrk>
  if(p == (char*)-1)
 8d0:	fd551ce3          	bne	a0,s5,8a8 <malloc+0xae>
        return 0;
 8d4:	4501                	li	a0,0
 8d6:	bf65                	j	88e <malloc+0x94>
