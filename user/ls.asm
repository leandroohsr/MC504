
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	add	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	2a8000ef          	jal	2b8 <strlen>
  14:	02051793          	sll	a5,a0,0x20
  18:	9381                	srl	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	add	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	add	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	280000ef          	jal	2b8 <strlen>
  3c:	2501                	sext.w	a0,a0
  3e:	47b5                	li	a5,13
  40:	00a7fa63          	bgeu	a5,a0,54 <fmtname+0x54>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  44:	8526                	mv	a0,s1
  46:	70a2                	ld	ra,40(sp)
  48:	7402                	ld	s0,32(sp)
  4a:	64e2                	ld	s1,24(sp)
  4c:	6942                	ld	s2,16(sp)
  4e:	69a2                	ld	s3,8(sp)
  50:	6145                	add	sp,sp,48
  52:	8082                	ret
  memmove(buf, p, strlen(p));
  54:	8526                	mv	a0,s1
  56:	262000ef          	jal	2b8 <strlen>
  5a:	00001997          	auipc	s3,0x1
  5e:	fb698993          	add	s3,s3,-74 # 1010 <buf.0>
  62:	0005061b          	sext.w	a2,a0
  66:	85a6                	mv	a1,s1
  68:	854e                	mv	a0,s3
  6a:	3b0000ef          	jal	41a <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6e:	8526                	mv	a0,s1
  70:	248000ef          	jal	2b8 <strlen>
  74:	0005091b          	sext.w	s2,a0
  78:	8526                	mv	a0,s1
  7a:	23e000ef          	jal	2b8 <strlen>
  7e:	1902                	sll	s2,s2,0x20
  80:	02095913          	srl	s2,s2,0x20
  84:	4639                	li	a2,14
  86:	9e09                	subw	a2,a2,a0
  88:	02000593          	li	a1,32
  8c:	01298533          	add	a0,s3,s2
  90:	252000ef          	jal	2e2 <memset>
  return buf;
  94:	84ce                	mv	s1,s3
  96:	b77d                	j	44 <fmtname+0x44>

0000000000000098 <ls>:

void
ls(char *path)
{
  98:	d9010113          	add	sp,sp,-624
  9c:	26113423          	sd	ra,616(sp)
  a0:	26813023          	sd	s0,608(sp)
  a4:	24913c23          	sd	s1,600(sp)
  a8:	25213823          	sd	s2,592(sp)
  ac:	25313423          	sd	s3,584(sp)
  b0:	25413023          	sd	s4,576(sp)
  b4:	23513c23          	sd	s5,568(sp)
  b8:	1c80                	add	s0,sp,624
  ba:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  bc:	4581                	li	a1,0
  be:	44a000ef          	jal	508 <open>
  c2:	06054763          	bltz	a0,130 <ls+0x98>
  c6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  c8:	d9840593          	add	a1,s0,-616
  cc:	454000ef          	jal	520 <fstat>
  d0:	06054963          	bltz	a0,142 <ls+0xaa>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  d4:	da041783          	lh	a5,-608(s0)
  d8:	4705                	li	a4,1
  da:	08e78063          	beq	a5,a4,15a <ls+0xc2>
  de:	37f9                	addw	a5,a5,-2
  e0:	17c2                	sll	a5,a5,0x30
  e2:	93c1                	srl	a5,a5,0x30
  e4:	02f76263          	bltu	a4,a5,108 <ls+0x70>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  e8:	854a                	mv	a0,s2
  ea:	f17ff0ef          	jal	0 <fmtname>
  ee:	85aa                	mv	a1,a0
  f0:	da842703          	lw	a4,-600(s0)
  f4:	d9c42683          	lw	a3,-612(s0)
  f8:	da041603          	lh	a2,-608(s0)
  fc:	00001517          	auipc	a0,0x1
 100:	9f450513          	add	a0,a0,-1548 # af0 <malloc+0x11a>
 104:	01f000ef          	jal	922 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
 108:	8526                	mv	a0,s1
 10a:	3e6000ef          	jal	4f0 <close>
}
 10e:	26813083          	ld	ra,616(sp)
 112:	26013403          	ld	s0,608(sp)
 116:	25813483          	ld	s1,600(sp)
 11a:	25013903          	ld	s2,592(sp)
 11e:	24813983          	ld	s3,584(sp)
 122:	24013a03          	ld	s4,576(sp)
 126:	23813a83          	ld	s5,568(sp)
 12a:	27010113          	add	sp,sp,624
 12e:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 130:	864a                	mv	a2,s2
 132:	00001597          	auipc	a1,0x1
 136:	98e58593          	add	a1,a1,-1650 # ac0 <malloc+0xea>
 13a:	4509                	li	a0,2
 13c:	7bc000ef          	jal	8f8 <fprintf>
    return;
 140:	b7f9                	j	10e <ls+0x76>
    fprintf(2, "ls: cannot stat %s\n", path);
 142:	864a                	mv	a2,s2
 144:	00001597          	auipc	a1,0x1
 148:	99458593          	add	a1,a1,-1644 # ad8 <malloc+0x102>
 14c:	4509                	li	a0,2
 14e:	7aa000ef          	jal	8f8 <fprintf>
    close(fd);
 152:	8526                	mv	a0,s1
 154:	39c000ef          	jal	4f0 <close>
    return;
 158:	bf5d                	j	10e <ls+0x76>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 15a:	854a                	mv	a0,s2
 15c:	15c000ef          	jal	2b8 <strlen>
 160:	2541                	addw	a0,a0,16
 162:	20000793          	li	a5,512
 166:	00a7f963          	bgeu	a5,a0,178 <ls+0xe0>
      printf("ls: path too long\n");
 16a:	00001517          	auipc	a0,0x1
 16e:	99650513          	add	a0,a0,-1642 # b00 <malloc+0x12a>
 172:	7b0000ef          	jal	922 <printf>
      break;
 176:	bf49                	j	108 <ls+0x70>
    strcpy(buf, path);
 178:	85ca                	mv	a1,s2
 17a:	dc040513          	add	a0,s0,-576
 17e:	0f2000ef          	jal	270 <strcpy>
    p = buf+strlen(buf);
 182:	dc040513          	add	a0,s0,-576
 186:	132000ef          	jal	2b8 <strlen>
 18a:	1502                	sll	a0,a0,0x20
 18c:	9101                	srl	a0,a0,0x20
 18e:	dc040793          	add	a5,s0,-576
 192:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 196:	00190993          	add	s3,s2,1
 19a:	02f00793          	li	a5,47
 19e:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1a2:	00001a17          	auipc	s4,0x1
 1a6:	94ea0a13          	add	s4,s4,-1714 # af0 <malloc+0x11a>
        printf("ls: cannot stat %s\n", buf);
 1aa:	00001a97          	auipc	s5,0x1
 1ae:	92ea8a93          	add	s5,s5,-1746 # ad8 <malloc+0x102>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b2:	a031                	j	1be <ls+0x126>
        printf("ls: cannot stat %s\n", buf);
 1b4:	dc040593          	add	a1,s0,-576
 1b8:	8556                	mv	a0,s5
 1ba:	768000ef          	jal	922 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1be:	4641                	li	a2,16
 1c0:	db040593          	add	a1,s0,-592
 1c4:	8526                	mv	a0,s1
 1c6:	31a000ef          	jal	4e0 <read>
 1ca:	47c1                	li	a5,16
 1cc:	f2f51ee3          	bne	a0,a5,108 <ls+0x70>
      if(de.inum == 0)
 1d0:	db045783          	lhu	a5,-592(s0)
 1d4:	d7ed                	beqz	a5,1be <ls+0x126>
      memmove(p, de.name, DIRSIZ);
 1d6:	4639                	li	a2,14
 1d8:	db240593          	add	a1,s0,-590
 1dc:	854e                	mv	a0,s3
 1de:	23c000ef          	jal	41a <memmove>
      p[DIRSIZ] = 0;
 1e2:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1e6:	d9840593          	add	a1,s0,-616
 1ea:	dc040513          	add	a0,s0,-576
 1ee:	1aa000ef          	jal	398 <stat>
 1f2:	fc0541e3          	bltz	a0,1b4 <ls+0x11c>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1f6:	dc040513          	add	a0,s0,-576
 1fa:	e07ff0ef          	jal	0 <fmtname>
 1fe:	85aa                	mv	a1,a0
 200:	da842703          	lw	a4,-600(s0)
 204:	d9c42683          	lw	a3,-612(s0)
 208:	da041603          	lh	a2,-608(s0)
 20c:	8552                	mv	a0,s4
 20e:	714000ef          	jal	922 <printf>
 212:	b775                	j	1be <ls+0x126>

0000000000000214 <main>:

int
main(int argc, char *argv[])
{
 214:	1101                	add	sp,sp,-32
 216:	ec06                	sd	ra,24(sp)
 218:	e822                	sd	s0,16(sp)
 21a:	e426                	sd	s1,8(sp)
 21c:	e04a                	sd	s2,0(sp)
 21e:	1000                	add	s0,sp,32
  int i;

  if(argc < 2){
 220:	4785                	li	a5,1
 222:	02a7d563          	bge	a5,a0,24c <main+0x38>
 226:	00858493          	add	s1,a1,8
 22a:	ffe5091b          	addw	s2,a0,-2
 22e:	02091793          	sll	a5,s2,0x20
 232:	01d7d913          	srl	s2,a5,0x1d
 236:	05c1                	add	a1,a1,16
 238:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 23a:	6088                	ld	a0,0(s1)
 23c:	e5dff0ef          	jal	98 <ls>
  for(i=1; i<argc; i++)
 240:	04a1                	add	s1,s1,8
 242:	ff249ce3          	bne	s1,s2,23a <main+0x26>
  exit(0);
 246:	4501                	li	a0,0
 248:	280000ef          	jal	4c8 <exit>
    ls(".");
 24c:	00001517          	auipc	a0,0x1
 250:	8cc50513          	add	a0,a0,-1844 # b18 <malloc+0x142>
 254:	e45ff0ef          	jal	98 <ls>
    exit(0);
 258:	4501                	li	a0,0
 25a:	26e000ef          	jal	4c8 <exit>

000000000000025e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 25e:	1141                	add	sp,sp,-16
 260:	e406                	sd	ra,8(sp)
 262:	e022                	sd	s0,0(sp)
 264:	0800                	add	s0,sp,16
  extern int main();
  main();
 266:	fafff0ef          	jal	214 <main>
  exit(0);
 26a:	4501                	li	a0,0
 26c:	25c000ef          	jal	4c8 <exit>

0000000000000270 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 270:	1141                	add	sp,sp,-16
 272:	e422                	sd	s0,8(sp)
 274:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 276:	87aa                	mv	a5,a0
 278:	0585                	add	a1,a1,1
 27a:	0785                	add	a5,a5,1
 27c:	fff5c703          	lbu	a4,-1(a1)
 280:	fee78fa3          	sb	a4,-1(a5)
 284:	fb75                	bnez	a4,278 <strcpy+0x8>
    ;
  return os;
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	add	sp,sp,16
 28a:	8082                	ret

000000000000028c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28c:	1141                	add	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 292:	00054783          	lbu	a5,0(a0)
 296:	cb91                	beqz	a5,2aa <strcmp+0x1e>
 298:	0005c703          	lbu	a4,0(a1)
 29c:	00f71763          	bne	a4,a5,2aa <strcmp+0x1e>
    p++, q++;
 2a0:	0505                	add	a0,a0,1
 2a2:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	fbe5                	bnez	a5,298 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2aa:	0005c503          	lbu	a0,0(a1)
}
 2ae:	40a7853b          	subw	a0,a5,a0
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	add	sp,sp,16
 2b6:	8082                	ret

00000000000002b8 <strlen>:

uint
strlen(const char *s)
{
 2b8:	1141                	add	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2be:	00054783          	lbu	a5,0(a0)
 2c2:	cf91                	beqz	a5,2de <strlen+0x26>
 2c4:	0505                	add	a0,a0,1
 2c6:	87aa                	mv	a5,a0
 2c8:	86be                	mv	a3,a5
 2ca:	0785                	add	a5,a5,1
 2cc:	fff7c703          	lbu	a4,-1(a5)
 2d0:	ff65                	bnez	a4,2c8 <strlen+0x10>
 2d2:	40a6853b          	subw	a0,a3,a0
 2d6:	2505                	addw	a0,a0,1
    ;
  return n;
}
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	add	sp,sp,16
 2dc:	8082                	ret
  for(n = 0; s[n]; n++)
 2de:	4501                	li	a0,0
 2e0:	bfe5                	j	2d8 <strlen+0x20>

00000000000002e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e2:	1141                	add	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2e8:	ca19                	beqz	a2,2fe <memset+0x1c>
 2ea:	87aa                	mv	a5,a0
 2ec:	1602                	sll	a2,a2,0x20
 2ee:	9201                	srl	a2,a2,0x20
 2f0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2f4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2f8:	0785                	add	a5,a5,1
 2fa:	fee79de3          	bne	a5,a4,2f4 <memset+0x12>
  }
  return dst;
}
 2fe:	6422                	ld	s0,8(sp)
 300:	0141                	add	sp,sp,16
 302:	8082                	ret

0000000000000304 <strchr>:

char*
strchr(const char *s, char c)
{
 304:	1141                	add	sp,sp,-16
 306:	e422                	sd	s0,8(sp)
 308:	0800                	add	s0,sp,16
  for(; *s; s++)
 30a:	00054783          	lbu	a5,0(a0)
 30e:	cb99                	beqz	a5,324 <strchr+0x20>
    if(*s == c)
 310:	00f58763          	beq	a1,a5,31e <strchr+0x1a>
  for(; *s; s++)
 314:	0505                	add	a0,a0,1
 316:	00054783          	lbu	a5,0(a0)
 31a:	fbfd                	bnez	a5,310 <strchr+0xc>
      return (char*)s;
  return 0;
 31c:	4501                	li	a0,0
}
 31e:	6422                	ld	s0,8(sp)
 320:	0141                	add	sp,sp,16
 322:	8082                	ret
  return 0;
 324:	4501                	li	a0,0
 326:	bfe5                	j	31e <strchr+0x1a>

0000000000000328 <gets>:

char*
gets(char *buf, int max)
{
 328:	711d                	add	sp,sp,-96
 32a:	ec86                	sd	ra,88(sp)
 32c:	e8a2                	sd	s0,80(sp)
 32e:	e4a6                	sd	s1,72(sp)
 330:	e0ca                	sd	s2,64(sp)
 332:	fc4e                	sd	s3,56(sp)
 334:	f852                	sd	s4,48(sp)
 336:	f456                	sd	s5,40(sp)
 338:	f05a                	sd	s6,32(sp)
 33a:	ec5e                	sd	s7,24(sp)
 33c:	1080                	add	s0,sp,96
 33e:	8baa                	mv	s7,a0
 340:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 342:	892a                	mv	s2,a0
 344:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 346:	4aa9                	li	s5,10
 348:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 34a:	89a6                	mv	s3,s1
 34c:	2485                	addw	s1,s1,1
 34e:	0344d663          	bge	s1,s4,37a <gets+0x52>
    cc = read(0, &c, 1);
 352:	4605                	li	a2,1
 354:	faf40593          	add	a1,s0,-81
 358:	4501                	li	a0,0
 35a:	186000ef          	jal	4e0 <read>
    if(cc < 1)
 35e:	00a05e63          	blez	a0,37a <gets+0x52>
    buf[i++] = c;
 362:	faf44783          	lbu	a5,-81(s0)
 366:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 36a:	01578763          	beq	a5,s5,378 <gets+0x50>
 36e:	0905                	add	s2,s2,1
 370:	fd679de3          	bne	a5,s6,34a <gets+0x22>
  for(i=0; i+1 < max; ){
 374:	89a6                	mv	s3,s1
 376:	a011                	j	37a <gets+0x52>
 378:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 37a:	99de                	add	s3,s3,s7
 37c:	00098023          	sb	zero,0(s3)
  return buf;
}
 380:	855e                	mv	a0,s7
 382:	60e6                	ld	ra,88(sp)
 384:	6446                	ld	s0,80(sp)
 386:	64a6                	ld	s1,72(sp)
 388:	6906                	ld	s2,64(sp)
 38a:	79e2                	ld	s3,56(sp)
 38c:	7a42                	ld	s4,48(sp)
 38e:	7aa2                	ld	s5,40(sp)
 390:	7b02                	ld	s6,32(sp)
 392:	6be2                	ld	s7,24(sp)
 394:	6125                	add	sp,sp,96
 396:	8082                	ret

0000000000000398 <stat>:

int
stat(const char *n, struct stat *st)
{
 398:	1101                	add	sp,sp,-32
 39a:	ec06                	sd	ra,24(sp)
 39c:	e822                	sd	s0,16(sp)
 39e:	e426                	sd	s1,8(sp)
 3a0:	e04a                	sd	s2,0(sp)
 3a2:	1000                	add	s0,sp,32
 3a4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a6:	4581                	li	a1,0
 3a8:	160000ef          	jal	508 <open>
  if(fd < 0)
 3ac:	02054163          	bltz	a0,3ce <stat+0x36>
 3b0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3b2:	85ca                	mv	a1,s2
 3b4:	16c000ef          	jal	520 <fstat>
 3b8:	892a                	mv	s2,a0
  close(fd);
 3ba:	8526                	mv	a0,s1
 3bc:	134000ef          	jal	4f0 <close>
  return r;
}
 3c0:	854a                	mv	a0,s2
 3c2:	60e2                	ld	ra,24(sp)
 3c4:	6442                	ld	s0,16(sp)
 3c6:	64a2                	ld	s1,8(sp)
 3c8:	6902                	ld	s2,0(sp)
 3ca:	6105                	add	sp,sp,32
 3cc:	8082                	ret
    return -1;
 3ce:	597d                	li	s2,-1
 3d0:	bfc5                	j	3c0 <stat+0x28>

00000000000003d2 <atoi>:

int
atoi(const char *s)
{
 3d2:	1141                	add	sp,sp,-16
 3d4:	e422                	sd	s0,8(sp)
 3d6:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3d8:	00054683          	lbu	a3,0(a0)
 3dc:	fd06879b          	addw	a5,a3,-48
 3e0:	0ff7f793          	zext.b	a5,a5
 3e4:	4625                	li	a2,9
 3e6:	02f66863          	bltu	a2,a5,416 <atoi+0x44>
 3ea:	872a                	mv	a4,a0
  n = 0;
 3ec:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3ee:	0705                	add	a4,a4,1
 3f0:	0025179b          	sllw	a5,a0,0x2
 3f4:	9fa9                	addw	a5,a5,a0
 3f6:	0017979b          	sllw	a5,a5,0x1
 3fa:	9fb5                	addw	a5,a5,a3
 3fc:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 400:	00074683          	lbu	a3,0(a4)
 404:	fd06879b          	addw	a5,a3,-48
 408:	0ff7f793          	zext.b	a5,a5
 40c:	fef671e3          	bgeu	a2,a5,3ee <atoi+0x1c>
  return n;
}
 410:	6422                	ld	s0,8(sp)
 412:	0141                	add	sp,sp,16
 414:	8082                	ret
  n = 0;
 416:	4501                	li	a0,0
 418:	bfe5                	j	410 <atoi+0x3e>

000000000000041a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 41a:	1141                	add	sp,sp,-16
 41c:	e422                	sd	s0,8(sp)
 41e:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 420:	02b57463          	bgeu	a0,a1,448 <memmove+0x2e>
    while(n-- > 0)
 424:	00c05f63          	blez	a2,442 <memmove+0x28>
 428:	1602                	sll	a2,a2,0x20
 42a:	9201                	srl	a2,a2,0x20
 42c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 430:	872a                	mv	a4,a0
      *dst++ = *src++;
 432:	0585                	add	a1,a1,1
 434:	0705                	add	a4,a4,1
 436:	fff5c683          	lbu	a3,-1(a1)
 43a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 43e:	fee79ae3          	bne	a5,a4,432 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 442:	6422                	ld	s0,8(sp)
 444:	0141                	add	sp,sp,16
 446:	8082                	ret
    dst += n;
 448:	00c50733          	add	a4,a0,a2
    src += n;
 44c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 44e:	fec05ae3          	blez	a2,442 <memmove+0x28>
 452:	fff6079b          	addw	a5,a2,-1
 456:	1782                	sll	a5,a5,0x20
 458:	9381                	srl	a5,a5,0x20
 45a:	fff7c793          	not	a5,a5
 45e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 460:	15fd                	add	a1,a1,-1
 462:	177d                	add	a4,a4,-1
 464:	0005c683          	lbu	a3,0(a1)
 468:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 46c:	fee79ae3          	bne	a5,a4,460 <memmove+0x46>
 470:	bfc9                	j	442 <memmove+0x28>

0000000000000472 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 472:	1141                	add	sp,sp,-16
 474:	e422                	sd	s0,8(sp)
 476:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 478:	ca05                	beqz	a2,4a8 <memcmp+0x36>
 47a:	fff6069b          	addw	a3,a2,-1
 47e:	1682                	sll	a3,a3,0x20
 480:	9281                	srl	a3,a3,0x20
 482:	0685                	add	a3,a3,1
 484:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 486:	00054783          	lbu	a5,0(a0)
 48a:	0005c703          	lbu	a4,0(a1)
 48e:	00e79863          	bne	a5,a4,49e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 492:	0505                	add	a0,a0,1
    p2++;
 494:	0585                	add	a1,a1,1
  while (n-- > 0) {
 496:	fed518e3          	bne	a0,a3,486 <memcmp+0x14>
  }
  return 0;
 49a:	4501                	li	a0,0
 49c:	a019                	j	4a2 <memcmp+0x30>
      return *p1 - *p2;
 49e:	40e7853b          	subw	a0,a5,a4
}
 4a2:	6422                	ld	s0,8(sp)
 4a4:	0141                	add	sp,sp,16
 4a6:	8082                	ret
  return 0;
 4a8:	4501                	li	a0,0
 4aa:	bfe5                	j	4a2 <memcmp+0x30>

00000000000004ac <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ac:	1141                	add	sp,sp,-16
 4ae:	e406                	sd	ra,8(sp)
 4b0:	e022                	sd	s0,0(sp)
 4b2:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 4b4:	f67ff0ef          	jal	41a <memmove>
}
 4b8:	60a2                	ld	ra,8(sp)
 4ba:	6402                	ld	s0,0(sp)
 4bc:	0141                	add	sp,sp,16
 4be:	8082                	ret

00000000000004c0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4c0:	4885                	li	a7,1
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4c8:	4889                	li	a7,2
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4d0:	488d                	li	a7,3
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4d8:	4891                	li	a7,4
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <read>:
.global read
read:
 li a7, SYS_read
 4e0:	4895                	li	a7,5
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <write>:
.global write
write:
 li a7, SYS_write
 4e8:	48c1                	li	a7,16
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <close>:
.global close
close:
 li a7, SYS_close
 4f0:	48d5                	li	a7,21
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4f8:	4899                	li	a7,6
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <exec>:
.global exec
exec:
 li a7, SYS_exec
 500:	489d                	li	a7,7
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <open>:
.global open
open:
 li a7, SYS_open
 508:	48bd                	li	a7,15
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 510:	48c5                	li	a7,17
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 518:	48c9                	li	a7,18
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 520:	48a1                	li	a7,8
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <link>:
.global link
link:
 li a7, SYS_link
 528:	48cd                	li	a7,19
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 530:	48d1                	li	a7,20
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 538:	48a5                	li	a7,9
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <dup>:
.global dup
dup:
 li a7, SYS_dup
 540:	48a9                	li	a7,10
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 548:	48ad                	li	a7,11
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 550:	48b1                	li	a7,12
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 558:	48b5                	li	a7,13
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 560:	48b9                	li	a7,14
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 568:	48d9                	li	a7,22
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 570:	48dd                	li	a7,23
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 578:	48e1                	li	a7,24
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 580:	48e5                	li	a7,25
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 588:	48e9                	li	a7,26
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 590:	48ed                	li	a7,27
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 598:	48f1                	li	a7,28
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <uptime_nolock>:
.global uptime_nolock
uptime_nolock:
 li a7, SYS_uptime_nolock
 5a0:	48f5                	li	a7,29
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5a8:	1101                	add	sp,sp,-32
 5aa:	ec06                	sd	ra,24(sp)
 5ac:	e822                	sd	s0,16(sp)
 5ae:	1000                	add	s0,sp,32
 5b0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5b4:	4605                	li	a2,1
 5b6:	fef40593          	add	a1,s0,-17
 5ba:	f2fff0ef          	jal	4e8 <write>
}
 5be:	60e2                	ld	ra,24(sp)
 5c0:	6442                	ld	s0,16(sp)
 5c2:	6105                	add	sp,sp,32
 5c4:	8082                	ret

00000000000005c6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c6:	7139                	add	sp,sp,-64
 5c8:	fc06                	sd	ra,56(sp)
 5ca:	f822                	sd	s0,48(sp)
 5cc:	f426                	sd	s1,40(sp)
 5ce:	f04a                	sd	s2,32(sp)
 5d0:	ec4e                	sd	s3,24(sp)
 5d2:	0080                	add	s0,sp,64
 5d4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5d6:	c299                	beqz	a3,5dc <printint+0x16>
 5d8:	0805c763          	bltz	a1,666 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5dc:	2581                	sext.w	a1,a1
  neg = 0;
 5de:	4881                	li	a7,0
 5e0:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 5e4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5e6:	2601                	sext.w	a2,a2
 5e8:	00000517          	auipc	a0,0x0
 5ec:	54050513          	add	a0,a0,1344 # b28 <digits>
 5f0:	883a                	mv	a6,a4
 5f2:	2705                	addw	a4,a4,1
 5f4:	02c5f7bb          	remuw	a5,a1,a2
 5f8:	1782                	sll	a5,a5,0x20
 5fa:	9381                	srl	a5,a5,0x20
 5fc:	97aa                	add	a5,a5,a0
 5fe:	0007c783          	lbu	a5,0(a5)
 602:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 606:	0005879b          	sext.w	a5,a1
 60a:	02c5d5bb          	divuw	a1,a1,a2
 60e:	0685                	add	a3,a3,1
 610:	fec7f0e3          	bgeu	a5,a2,5f0 <printint+0x2a>
  if(neg)
 614:	00088c63          	beqz	a7,62c <printint+0x66>
    buf[i++] = '-';
 618:	fd070793          	add	a5,a4,-48
 61c:	00878733          	add	a4,a5,s0
 620:	02d00793          	li	a5,45
 624:	fef70823          	sb	a5,-16(a4)
 628:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 62c:	02e05663          	blez	a4,658 <printint+0x92>
 630:	fc040793          	add	a5,s0,-64
 634:	00e78933          	add	s2,a5,a4
 638:	fff78993          	add	s3,a5,-1
 63c:	99ba                	add	s3,s3,a4
 63e:	377d                	addw	a4,a4,-1
 640:	1702                	sll	a4,a4,0x20
 642:	9301                	srl	a4,a4,0x20
 644:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 648:	fff94583          	lbu	a1,-1(s2)
 64c:	8526                	mv	a0,s1
 64e:	f5bff0ef          	jal	5a8 <putc>
  while(--i >= 0)
 652:	197d                	add	s2,s2,-1
 654:	ff391ae3          	bne	s2,s3,648 <printint+0x82>
}
 658:	70e2                	ld	ra,56(sp)
 65a:	7442                	ld	s0,48(sp)
 65c:	74a2                	ld	s1,40(sp)
 65e:	7902                	ld	s2,32(sp)
 660:	69e2                	ld	s3,24(sp)
 662:	6121                	add	sp,sp,64
 664:	8082                	ret
    x = -xx;
 666:	40b005bb          	negw	a1,a1
    neg = 1;
 66a:	4885                	li	a7,1
    x = -xx;
 66c:	bf95                	j	5e0 <printint+0x1a>

000000000000066e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 66e:	711d                	add	sp,sp,-96
 670:	ec86                	sd	ra,88(sp)
 672:	e8a2                	sd	s0,80(sp)
 674:	e4a6                	sd	s1,72(sp)
 676:	e0ca                	sd	s2,64(sp)
 678:	fc4e                	sd	s3,56(sp)
 67a:	f852                	sd	s4,48(sp)
 67c:	f456                	sd	s5,40(sp)
 67e:	f05a                	sd	s6,32(sp)
 680:	ec5e                	sd	s7,24(sp)
 682:	e862                	sd	s8,16(sp)
 684:	e466                	sd	s9,8(sp)
 686:	e06a                	sd	s10,0(sp)
 688:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 68a:	0005c903          	lbu	s2,0(a1)
 68e:	24090763          	beqz	s2,8dc <vprintf+0x26e>
 692:	8b2a                	mv	s6,a0
 694:	8a2e                	mv	s4,a1
 696:	8bb2                	mv	s7,a2
  state = 0;
 698:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 69a:	4481                	li	s1,0
 69c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 69e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6a2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6a6:	06c00c93          	li	s9,108
 6aa:	a005                	j	6ca <vprintf+0x5c>
        putc(fd, c0);
 6ac:	85ca                	mv	a1,s2
 6ae:	855a                	mv	a0,s6
 6b0:	ef9ff0ef          	jal	5a8 <putc>
 6b4:	a019                	j	6ba <vprintf+0x4c>
    } else if(state == '%'){
 6b6:	03598263          	beq	s3,s5,6da <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6ba:	2485                	addw	s1,s1,1
 6bc:	8726                	mv	a4,s1
 6be:	009a07b3          	add	a5,s4,s1
 6c2:	0007c903          	lbu	s2,0(a5)
 6c6:	20090b63          	beqz	s2,8dc <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6ca:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6ce:	fe0994e3          	bnez	s3,6b6 <vprintf+0x48>
      if(c0 == '%'){
 6d2:	fd579de3          	bne	a5,s5,6ac <vprintf+0x3e>
        state = '%';
 6d6:	89be                	mv	s3,a5
 6d8:	b7cd                	j	6ba <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 6da:	c7c9                	beqz	a5,764 <vprintf+0xf6>
 6dc:	00ea06b3          	add	a3,s4,a4
 6e0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6e4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6e6:	c681                	beqz	a3,6ee <vprintf+0x80>
 6e8:	9752                	add	a4,a4,s4
 6ea:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6ee:	03878f63          	beq	a5,s8,72c <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 6f2:	05978963          	beq	a5,s9,744 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6f6:	07500713          	li	a4,117
 6fa:	0ee78363          	beq	a5,a4,7e0 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6fe:	07800713          	li	a4,120
 702:	12e78563          	beq	a5,a4,82c <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 706:	07000713          	li	a4,112
 70a:	14e78a63          	beq	a5,a4,85e <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 70e:	07300713          	li	a4,115
 712:	18e78863          	beq	a5,a4,8a2 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 716:	02500713          	li	a4,37
 71a:	04e79563          	bne	a5,a4,764 <vprintf+0xf6>
        putc(fd, '%');
 71e:	02500593          	li	a1,37
 722:	855a                	mv	a0,s6
 724:	e85ff0ef          	jal	5a8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 728:	4981                	li	s3,0
 72a:	bf41                	j	6ba <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 72c:	008b8913          	add	s2,s7,8
 730:	4685                	li	a3,1
 732:	4629                	li	a2,10
 734:	000ba583          	lw	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	e8dff0ef          	jal	5c6 <printint>
 73e:	8bca                	mv	s7,s2
      state = 0;
 740:	4981                	li	s3,0
 742:	bfa5                	j	6ba <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 744:	06400793          	li	a5,100
 748:	02f68963          	beq	a3,a5,77a <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 74c:	06c00793          	li	a5,108
 750:	04f68263          	beq	a3,a5,794 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 754:	07500793          	li	a5,117
 758:	0af68063          	beq	a3,a5,7f8 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 75c:	07800793          	li	a5,120
 760:	0ef68263          	beq	a3,a5,844 <vprintf+0x1d6>
        putc(fd, '%');
 764:	02500593          	li	a1,37
 768:	855a                	mv	a0,s6
 76a:	e3fff0ef          	jal	5a8 <putc>
        putc(fd, c0);
 76e:	85ca                	mv	a1,s2
 770:	855a                	mv	a0,s6
 772:	e37ff0ef          	jal	5a8 <putc>
      state = 0;
 776:	4981                	li	s3,0
 778:	b789                	j	6ba <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 77a:	008b8913          	add	s2,s7,8
 77e:	4685                	li	a3,1
 780:	4629                	li	a2,10
 782:	000ba583          	lw	a1,0(s7)
 786:	855a                	mv	a0,s6
 788:	e3fff0ef          	jal	5c6 <printint>
        i += 1;
 78c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 78e:	8bca                	mv	s7,s2
      state = 0;
 790:	4981                	li	s3,0
        i += 1;
 792:	b725                	j	6ba <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 794:	06400793          	li	a5,100
 798:	02f60763          	beq	a2,a5,7c6 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 79c:	07500793          	li	a5,117
 7a0:	06f60963          	beq	a2,a5,812 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7a4:	07800793          	li	a5,120
 7a8:	faf61ee3          	bne	a2,a5,764 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ac:	008b8913          	add	s2,s7,8
 7b0:	4681                	li	a3,0
 7b2:	4641                	li	a2,16
 7b4:	000ba583          	lw	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	e0dff0ef          	jal	5c6 <printint>
        i += 2;
 7be:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c0:	8bca                	mv	s7,s2
      state = 0;
 7c2:	4981                	li	s3,0
        i += 2;
 7c4:	bddd                	j	6ba <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c6:	008b8913          	add	s2,s7,8
 7ca:	4685                	li	a3,1
 7cc:	4629                	li	a2,10
 7ce:	000ba583          	lw	a1,0(s7)
 7d2:	855a                	mv	a0,s6
 7d4:	df3ff0ef          	jal	5c6 <printint>
        i += 2;
 7d8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7da:	8bca                	mv	s7,s2
      state = 0;
 7dc:	4981                	li	s3,0
        i += 2;
 7de:	bdf1                	j	6ba <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 7e0:	008b8913          	add	s2,s7,8
 7e4:	4681                	li	a3,0
 7e6:	4629                	li	a2,10
 7e8:	000ba583          	lw	a1,0(s7)
 7ec:	855a                	mv	a0,s6
 7ee:	dd9ff0ef          	jal	5c6 <printint>
 7f2:	8bca                	mv	s7,s2
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	b5d1                	j	6ba <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f8:	008b8913          	add	s2,s7,8
 7fc:	4681                	li	a3,0
 7fe:	4629                	li	a2,10
 800:	000ba583          	lw	a1,0(s7)
 804:	855a                	mv	a0,s6
 806:	dc1ff0ef          	jal	5c6 <printint>
        i += 1;
 80a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 80c:	8bca                	mv	s7,s2
      state = 0;
 80e:	4981                	li	s3,0
        i += 1;
 810:	b56d                	j	6ba <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 812:	008b8913          	add	s2,s7,8
 816:	4681                	li	a3,0
 818:	4629                	li	a2,10
 81a:	000ba583          	lw	a1,0(s7)
 81e:	855a                	mv	a0,s6
 820:	da7ff0ef          	jal	5c6 <printint>
        i += 2;
 824:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 826:	8bca                	mv	s7,s2
      state = 0;
 828:	4981                	li	s3,0
        i += 2;
 82a:	bd41                	j	6ba <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 82c:	008b8913          	add	s2,s7,8
 830:	4681                	li	a3,0
 832:	4641                	li	a2,16
 834:	000ba583          	lw	a1,0(s7)
 838:	855a                	mv	a0,s6
 83a:	d8dff0ef          	jal	5c6 <printint>
 83e:	8bca                	mv	s7,s2
      state = 0;
 840:	4981                	li	s3,0
 842:	bda5                	j	6ba <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 844:	008b8913          	add	s2,s7,8
 848:	4681                	li	a3,0
 84a:	4641                	li	a2,16
 84c:	000ba583          	lw	a1,0(s7)
 850:	855a                	mv	a0,s6
 852:	d75ff0ef          	jal	5c6 <printint>
        i += 1;
 856:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 858:	8bca                	mv	s7,s2
      state = 0;
 85a:	4981                	li	s3,0
        i += 1;
 85c:	bdb9                	j	6ba <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 85e:	008b8d13          	add	s10,s7,8
 862:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 866:	03000593          	li	a1,48
 86a:	855a                	mv	a0,s6
 86c:	d3dff0ef          	jal	5a8 <putc>
  putc(fd, 'x');
 870:	07800593          	li	a1,120
 874:	855a                	mv	a0,s6
 876:	d33ff0ef          	jal	5a8 <putc>
 87a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 87c:	00000b97          	auipc	s7,0x0
 880:	2acb8b93          	add	s7,s7,684 # b28 <digits>
 884:	03c9d793          	srl	a5,s3,0x3c
 888:	97de                	add	a5,a5,s7
 88a:	0007c583          	lbu	a1,0(a5)
 88e:	855a                	mv	a0,s6
 890:	d19ff0ef          	jal	5a8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 894:	0992                	sll	s3,s3,0x4
 896:	397d                	addw	s2,s2,-1
 898:	fe0916e3          	bnez	s2,884 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 89c:	8bea                	mv	s7,s10
      state = 0;
 89e:	4981                	li	s3,0
 8a0:	bd29                	j	6ba <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 8a2:	008b8993          	add	s3,s7,8
 8a6:	000bb903          	ld	s2,0(s7)
 8aa:	00090f63          	beqz	s2,8c8 <vprintf+0x25a>
        for(; *s; s++)
 8ae:	00094583          	lbu	a1,0(s2)
 8b2:	c195                	beqz	a1,8d6 <vprintf+0x268>
          putc(fd, *s);
 8b4:	855a                	mv	a0,s6
 8b6:	cf3ff0ef          	jal	5a8 <putc>
        for(; *s; s++)
 8ba:	0905                	add	s2,s2,1
 8bc:	00094583          	lbu	a1,0(s2)
 8c0:	f9f5                	bnez	a1,8b4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8c2:	8bce                	mv	s7,s3
      state = 0;
 8c4:	4981                	li	s3,0
 8c6:	bbd5                	j	6ba <vprintf+0x4c>
          s = "(null)";
 8c8:	00000917          	auipc	s2,0x0
 8cc:	25890913          	add	s2,s2,600 # b20 <malloc+0x14a>
        for(; *s; s++)
 8d0:	02800593          	li	a1,40
 8d4:	b7c5                	j	8b4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8d6:	8bce                	mv	s7,s3
      state = 0;
 8d8:	4981                	li	s3,0
 8da:	b3c5                	j	6ba <vprintf+0x4c>
    }
  }
}
 8dc:	60e6                	ld	ra,88(sp)
 8de:	6446                	ld	s0,80(sp)
 8e0:	64a6                	ld	s1,72(sp)
 8e2:	6906                	ld	s2,64(sp)
 8e4:	79e2                	ld	s3,56(sp)
 8e6:	7a42                	ld	s4,48(sp)
 8e8:	7aa2                	ld	s5,40(sp)
 8ea:	7b02                	ld	s6,32(sp)
 8ec:	6be2                	ld	s7,24(sp)
 8ee:	6c42                	ld	s8,16(sp)
 8f0:	6ca2                	ld	s9,8(sp)
 8f2:	6d02                	ld	s10,0(sp)
 8f4:	6125                	add	sp,sp,96
 8f6:	8082                	ret

00000000000008f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f8:	715d                	add	sp,sp,-80
 8fa:	ec06                	sd	ra,24(sp)
 8fc:	e822                	sd	s0,16(sp)
 8fe:	1000                	add	s0,sp,32
 900:	e010                	sd	a2,0(s0)
 902:	e414                	sd	a3,8(s0)
 904:	e818                	sd	a4,16(s0)
 906:	ec1c                	sd	a5,24(s0)
 908:	03043023          	sd	a6,32(s0)
 90c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 910:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 914:	8622                	mv	a2,s0
 916:	d59ff0ef          	jal	66e <vprintf>
}
 91a:	60e2                	ld	ra,24(sp)
 91c:	6442                	ld	s0,16(sp)
 91e:	6161                	add	sp,sp,80
 920:	8082                	ret

0000000000000922 <printf>:

void
printf(const char *fmt, ...)
{
 922:	711d                	add	sp,sp,-96
 924:	ec06                	sd	ra,24(sp)
 926:	e822                	sd	s0,16(sp)
 928:	1000                	add	s0,sp,32
 92a:	e40c                	sd	a1,8(s0)
 92c:	e810                	sd	a2,16(s0)
 92e:	ec14                	sd	a3,24(s0)
 930:	f018                	sd	a4,32(s0)
 932:	f41c                	sd	a5,40(s0)
 934:	03043823          	sd	a6,48(s0)
 938:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 93c:	00840613          	add	a2,s0,8
 940:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 944:	85aa                	mv	a1,a0
 946:	4505                	li	a0,1
 948:	d27ff0ef          	jal	66e <vprintf>
}
 94c:	60e2                	ld	ra,24(sp)
 94e:	6442                	ld	s0,16(sp)
 950:	6125                	add	sp,sp,96
 952:	8082                	ret

0000000000000954 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 954:	1141                	add	sp,sp,-16
 956:	e422                	sd	s0,8(sp)
 958:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 95a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95e:	00000797          	auipc	a5,0x0
 962:	6a27b783          	ld	a5,1698(a5) # 1000 <freep>
 966:	a02d                	j	990 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 968:	4618                	lw	a4,8(a2)
 96a:	9f2d                	addw	a4,a4,a1
 96c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 970:	6398                	ld	a4,0(a5)
 972:	6310                	ld	a2,0(a4)
 974:	a83d                	j	9b2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 976:	ff852703          	lw	a4,-8(a0)
 97a:	9f31                	addw	a4,a4,a2
 97c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 97e:	ff053683          	ld	a3,-16(a0)
 982:	a091                	j	9c6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 984:	6398                	ld	a4,0(a5)
 986:	00e7e463          	bltu	a5,a4,98e <free+0x3a>
 98a:	00e6ea63          	bltu	a3,a4,99e <free+0x4a>
{
 98e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 990:	fed7fae3          	bgeu	a5,a3,984 <free+0x30>
 994:	6398                	ld	a4,0(a5)
 996:	00e6e463          	bltu	a3,a4,99e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99a:	fee7eae3          	bltu	a5,a4,98e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 99e:	ff852583          	lw	a1,-8(a0)
 9a2:	6390                	ld	a2,0(a5)
 9a4:	02059813          	sll	a6,a1,0x20
 9a8:	01c85713          	srl	a4,a6,0x1c
 9ac:	9736                	add	a4,a4,a3
 9ae:	fae60de3          	beq	a2,a4,968 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9b2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9b6:	4790                	lw	a2,8(a5)
 9b8:	02061593          	sll	a1,a2,0x20
 9bc:	01c5d713          	srl	a4,a1,0x1c
 9c0:	973e                	add	a4,a4,a5
 9c2:	fae68ae3          	beq	a3,a4,976 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9c6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9c8:	00000717          	auipc	a4,0x0
 9cc:	62f73c23          	sd	a5,1592(a4) # 1000 <freep>
}
 9d0:	6422                	ld	s0,8(sp)
 9d2:	0141                	add	sp,sp,16
 9d4:	8082                	ret

00000000000009d6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9d6:	7139                	add	sp,sp,-64
 9d8:	fc06                	sd	ra,56(sp)
 9da:	f822                	sd	s0,48(sp)
 9dc:	f426                	sd	s1,40(sp)
 9de:	f04a                	sd	s2,32(sp)
 9e0:	ec4e                	sd	s3,24(sp)
 9e2:	e852                	sd	s4,16(sp)
 9e4:	e456                	sd	s5,8(sp)
 9e6:	e05a                	sd	s6,0(sp)
 9e8:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ea:	02051493          	sll	s1,a0,0x20
 9ee:	9081                	srl	s1,s1,0x20
 9f0:	04bd                	add	s1,s1,15
 9f2:	8091                	srl	s1,s1,0x4
 9f4:	0014899b          	addw	s3,s1,1
 9f8:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 9fa:	00000517          	auipc	a0,0x0
 9fe:	60653503          	ld	a0,1542(a0) # 1000 <freep>
 a02:	c515                	beqz	a0,a2e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a04:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a06:	4798                	lw	a4,8(a5)
 a08:	02977f63          	bgeu	a4,s1,a46 <malloc+0x70>
  if(nu < 4096)
 a0c:	8a4e                	mv	s4,s3
 a0e:	0009871b          	sext.w	a4,s3
 a12:	6685                	lui	a3,0x1
 a14:	00d77363          	bgeu	a4,a3,a1a <malloc+0x44>
 a18:	6a05                	lui	s4,0x1
 a1a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a1e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a22:	00000917          	auipc	s2,0x0
 a26:	5de90913          	add	s2,s2,1502 # 1000 <freep>
  if(p == (char*)-1)
 a2a:	5afd                	li	s5,-1
 a2c:	a885                	j	a9c <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 a2e:	00000797          	auipc	a5,0x0
 a32:	5f278793          	add	a5,a5,1522 # 1020 <base>
 a36:	00000717          	auipc	a4,0x0
 a3a:	5cf73523          	sd	a5,1482(a4) # 1000 <freep>
 a3e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a40:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a44:	b7e1                	j	a0c <malloc+0x36>
      if(p->s.size == nunits)
 a46:	02e48c63          	beq	s1,a4,a7e <malloc+0xa8>
        p->s.size -= nunits;
 a4a:	4137073b          	subw	a4,a4,s3
 a4e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a50:	02071693          	sll	a3,a4,0x20
 a54:	01c6d713          	srl	a4,a3,0x1c
 a58:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a5a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a5e:	00000717          	auipc	a4,0x0
 a62:	5aa73123          	sd	a0,1442(a4) # 1000 <freep>
      return (void*)(p + 1);
 a66:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a6a:	70e2                	ld	ra,56(sp)
 a6c:	7442                	ld	s0,48(sp)
 a6e:	74a2                	ld	s1,40(sp)
 a70:	7902                	ld	s2,32(sp)
 a72:	69e2                	ld	s3,24(sp)
 a74:	6a42                	ld	s4,16(sp)
 a76:	6aa2                	ld	s5,8(sp)
 a78:	6b02                	ld	s6,0(sp)
 a7a:	6121                	add	sp,sp,64
 a7c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a7e:	6398                	ld	a4,0(a5)
 a80:	e118                	sd	a4,0(a0)
 a82:	bff1                	j	a5e <malloc+0x88>
  hp->s.size = nu;
 a84:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a88:	0541                	add	a0,a0,16
 a8a:	ecbff0ef          	jal	954 <free>
  return freep;
 a8e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a92:	dd61                	beqz	a0,a6a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a94:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a96:	4798                	lw	a4,8(a5)
 a98:	fa9777e3          	bgeu	a4,s1,a46 <malloc+0x70>
    if(p == freep)
 a9c:	00093703          	ld	a4,0(s2)
 aa0:	853e                	mv	a0,a5
 aa2:	fef719e3          	bne	a4,a5,a94 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 aa6:	8552                	mv	a0,s4
 aa8:	aa9ff0ef          	jal	550 <sbrk>
  if(p == (char*)-1)
 aac:	fd551ce3          	bne	a0,s5,a84 <malloc+0xae>
        return 0;
 ab0:	4501                	li	a0,0
 ab2:	bf65                	j	a6a <malloc+0x94>
