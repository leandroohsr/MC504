
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
 100:	9e450513          	add	a0,a0,-1564 # ae0 <malloc+0x112>
 104:	017000ef          	jal	91a <printf>
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
 136:	97e58593          	add	a1,a1,-1666 # ab0 <malloc+0xe2>
 13a:	4509                	li	a0,2
 13c:	7b4000ef          	jal	8f0 <fprintf>
    return;
 140:	b7f9                	j	10e <ls+0x76>
    fprintf(2, "ls: cannot stat %s\n", path);
 142:	864a                	mv	a2,s2
 144:	00001597          	auipc	a1,0x1
 148:	98458593          	add	a1,a1,-1660 # ac8 <malloc+0xfa>
 14c:	4509                	li	a0,2
 14e:	7a2000ef          	jal	8f0 <fprintf>
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
 16e:	98650513          	add	a0,a0,-1658 # af0 <malloc+0x122>
 172:	7a8000ef          	jal	91a <printf>
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
 1a6:	93ea0a13          	add	s4,s4,-1730 # ae0 <malloc+0x112>
        printf("ls: cannot stat %s\n", buf);
 1aa:	00001a97          	auipc	s5,0x1
 1ae:	91ea8a93          	add	s5,s5,-1762 # ac8 <malloc+0xfa>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b2:	a031                	j	1be <ls+0x126>
        printf("ls: cannot stat %s\n", buf);
 1b4:	dc040593          	add	a1,s0,-576
 1b8:	8556                	mv	a0,s5
 1ba:	760000ef          	jal	91a <printf>
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
 20e:	70c000ef          	jal	91a <printf>
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
 250:	8bc50513          	add	a0,a0,-1860 # b08 <malloc+0x13a>
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

00000000000005a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5a0:	1101                	add	sp,sp,-32
 5a2:	ec06                	sd	ra,24(sp)
 5a4:	e822                	sd	s0,16(sp)
 5a6:	1000                	add	s0,sp,32
 5a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ac:	4605                	li	a2,1
 5ae:	fef40593          	add	a1,s0,-17
 5b2:	f37ff0ef          	jal	4e8 <write>
}
 5b6:	60e2                	ld	ra,24(sp)
 5b8:	6442                	ld	s0,16(sp)
 5ba:	6105                	add	sp,sp,32
 5bc:	8082                	ret

00000000000005be <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5be:	7139                	add	sp,sp,-64
 5c0:	fc06                	sd	ra,56(sp)
 5c2:	f822                	sd	s0,48(sp)
 5c4:	f426                	sd	s1,40(sp)
 5c6:	f04a                	sd	s2,32(sp)
 5c8:	ec4e                	sd	s3,24(sp)
 5ca:	0080                	add	s0,sp,64
 5cc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ce:	c299                	beqz	a3,5d4 <printint+0x16>
 5d0:	0805c763          	bltz	a1,65e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5d4:	2581                	sext.w	a1,a1
  neg = 0;
 5d6:	4881                	li	a7,0
 5d8:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 5dc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5de:	2601                	sext.w	a2,a2
 5e0:	00000517          	auipc	a0,0x0
 5e4:	53850513          	add	a0,a0,1336 # b18 <digits>
 5e8:	883a                	mv	a6,a4
 5ea:	2705                	addw	a4,a4,1
 5ec:	02c5f7bb          	remuw	a5,a1,a2
 5f0:	1782                	sll	a5,a5,0x20
 5f2:	9381                	srl	a5,a5,0x20
 5f4:	97aa                	add	a5,a5,a0
 5f6:	0007c783          	lbu	a5,0(a5)
 5fa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5fe:	0005879b          	sext.w	a5,a1
 602:	02c5d5bb          	divuw	a1,a1,a2
 606:	0685                	add	a3,a3,1
 608:	fec7f0e3          	bgeu	a5,a2,5e8 <printint+0x2a>
  if(neg)
 60c:	00088c63          	beqz	a7,624 <printint+0x66>
    buf[i++] = '-';
 610:	fd070793          	add	a5,a4,-48
 614:	00878733          	add	a4,a5,s0
 618:	02d00793          	li	a5,45
 61c:	fef70823          	sb	a5,-16(a4)
 620:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 624:	02e05663          	blez	a4,650 <printint+0x92>
 628:	fc040793          	add	a5,s0,-64
 62c:	00e78933          	add	s2,a5,a4
 630:	fff78993          	add	s3,a5,-1
 634:	99ba                	add	s3,s3,a4
 636:	377d                	addw	a4,a4,-1
 638:	1702                	sll	a4,a4,0x20
 63a:	9301                	srl	a4,a4,0x20
 63c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 640:	fff94583          	lbu	a1,-1(s2)
 644:	8526                	mv	a0,s1
 646:	f5bff0ef          	jal	5a0 <putc>
  while(--i >= 0)
 64a:	197d                	add	s2,s2,-1
 64c:	ff391ae3          	bne	s2,s3,640 <printint+0x82>
}
 650:	70e2                	ld	ra,56(sp)
 652:	7442                	ld	s0,48(sp)
 654:	74a2                	ld	s1,40(sp)
 656:	7902                	ld	s2,32(sp)
 658:	69e2                	ld	s3,24(sp)
 65a:	6121                	add	sp,sp,64
 65c:	8082                	ret
    x = -xx;
 65e:	40b005bb          	negw	a1,a1
    neg = 1;
 662:	4885                	li	a7,1
    x = -xx;
 664:	bf95                	j	5d8 <printint+0x1a>

0000000000000666 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 666:	711d                	add	sp,sp,-96
 668:	ec86                	sd	ra,88(sp)
 66a:	e8a2                	sd	s0,80(sp)
 66c:	e4a6                	sd	s1,72(sp)
 66e:	e0ca                	sd	s2,64(sp)
 670:	fc4e                	sd	s3,56(sp)
 672:	f852                	sd	s4,48(sp)
 674:	f456                	sd	s5,40(sp)
 676:	f05a                	sd	s6,32(sp)
 678:	ec5e                	sd	s7,24(sp)
 67a:	e862                	sd	s8,16(sp)
 67c:	e466                	sd	s9,8(sp)
 67e:	e06a                	sd	s10,0(sp)
 680:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 682:	0005c903          	lbu	s2,0(a1)
 686:	24090763          	beqz	s2,8d4 <vprintf+0x26e>
 68a:	8b2a                	mv	s6,a0
 68c:	8a2e                	mv	s4,a1
 68e:	8bb2                	mv	s7,a2
  state = 0;
 690:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 692:	4481                	li	s1,0
 694:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 696:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 69a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 69e:	06c00c93          	li	s9,108
 6a2:	a005                	j	6c2 <vprintf+0x5c>
        putc(fd, c0);
 6a4:	85ca                	mv	a1,s2
 6a6:	855a                	mv	a0,s6
 6a8:	ef9ff0ef          	jal	5a0 <putc>
 6ac:	a019                	j	6b2 <vprintf+0x4c>
    } else if(state == '%'){
 6ae:	03598263          	beq	s3,s5,6d2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6b2:	2485                	addw	s1,s1,1
 6b4:	8726                	mv	a4,s1
 6b6:	009a07b3          	add	a5,s4,s1
 6ba:	0007c903          	lbu	s2,0(a5)
 6be:	20090b63          	beqz	s2,8d4 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6c2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6c6:	fe0994e3          	bnez	s3,6ae <vprintf+0x48>
      if(c0 == '%'){
 6ca:	fd579de3          	bne	a5,s5,6a4 <vprintf+0x3e>
        state = '%';
 6ce:	89be                	mv	s3,a5
 6d0:	b7cd                	j	6b2 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 6d2:	c7c9                	beqz	a5,75c <vprintf+0xf6>
 6d4:	00ea06b3          	add	a3,s4,a4
 6d8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6dc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6de:	c681                	beqz	a3,6e6 <vprintf+0x80>
 6e0:	9752                	add	a4,a4,s4
 6e2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6e6:	03878f63          	beq	a5,s8,724 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 6ea:	05978963          	beq	a5,s9,73c <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6ee:	07500713          	li	a4,117
 6f2:	0ee78363          	beq	a5,a4,7d8 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6f6:	07800713          	li	a4,120
 6fa:	12e78563          	beq	a5,a4,824 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6fe:	07000713          	li	a4,112
 702:	14e78a63          	beq	a5,a4,856 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 706:	07300713          	li	a4,115
 70a:	18e78863          	beq	a5,a4,89a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 70e:	02500713          	li	a4,37
 712:	04e79563          	bne	a5,a4,75c <vprintf+0xf6>
        putc(fd, '%');
 716:	02500593          	li	a1,37
 71a:	855a                	mv	a0,s6
 71c:	e85ff0ef          	jal	5a0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 720:	4981                	li	s3,0
 722:	bf41                	j	6b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 724:	008b8913          	add	s2,s7,8
 728:	4685                	li	a3,1
 72a:	4629                	li	a2,10
 72c:	000ba583          	lw	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	e8dff0ef          	jal	5be <printint>
 736:	8bca                	mv	s7,s2
      state = 0;
 738:	4981                	li	s3,0
 73a:	bfa5                	j	6b2 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 73c:	06400793          	li	a5,100
 740:	02f68963          	beq	a3,a5,772 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 744:	06c00793          	li	a5,108
 748:	04f68263          	beq	a3,a5,78c <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 74c:	07500793          	li	a5,117
 750:	0af68063          	beq	a3,a5,7f0 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 754:	07800793          	li	a5,120
 758:	0ef68263          	beq	a3,a5,83c <vprintf+0x1d6>
        putc(fd, '%');
 75c:	02500593          	li	a1,37
 760:	855a                	mv	a0,s6
 762:	e3fff0ef          	jal	5a0 <putc>
        putc(fd, c0);
 766:	85ca                	mv	a1,s2
 768:	855a                	mv	a0,s6
 76a:	e37ff0ef          	jal	5a0 <putc>
      state = 0;
 76e:	4981                	li	s3,0
 770:	b789                	j	6b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 772:	008b8913          	add	s2,s7,8
 776:	4685                	li	a3,1
 778:	4629                	li	a2,10
 77a:	000ba583          	lw	a1,0(s7)
 77e:	855a                	mv	a0,s6
 780:	e3fff0ef          	jal	5be <printint>
        i += 1;
 784:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 786:	8bca                	mv	s7,s2
      state = 0;
 788:	4981                	li	s3,0
        i += 1;
 78a:	b725                	j	6b2 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 78c:	06400793          	li	a5,100
 790:	02f60763          	beq	a2,a5,7be <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 794:	07500793          	li	a5,117
 798:	06f60963          	beq	a2,a5,80a <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 79c:	07800793          	li	a5,120
 7a0:	faf61ee3          	bne	a2,a5,75c <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a4:	008b8913          	add	s2,s7,8
 7a8:	4681                	li	a3,0
 7aa:	4641                	li	a2,16
 7ac:	000ba583          	lw	a1,0(s7)
 7b0:	855a                	mv	a0,s6
 7b2:	e0dff0ef          	jal	5be <printint>
        i += 2;
 7b6:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b8:	8bca                	mv	s7,s2
      state = 0;
 7ba:	4981                	li	s3,0
        i += 2;
 7bc:	bddd                	j	6b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7be:	008b8913          	add	s2,s7,8
 7c2:	4685                	li	a3,1
 7c4:	4629                	li	a2,10
 7c6:	000ba583          	lw	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	df3ff0ef          	jal	5be <printint>
        i += 2;
 7d0:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d2:	8bca                	mv	s7,s2
      state = 0;
 7d4:	4981                	li	s3,0
        i += 2;
 7d6:	bdf1                	j	6b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 7d8:	008b8913          	add	s2,s7,8
 7dc:	4681                	li	a3,0
 7de:	4629                	li	a2,10
 7e0:	000ba583          	lw	a1,0(s7)
 7e4:	855a                	mv	a0,s6
 7e6:	dd9ff0ef          	jal	5be <printint>
 7ea:	8bca                	mv	s7,s2
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	b5d1                	j	6b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f0:	008b8913          	add	s2,s7,8
 7f4:	4681                	li	a3,0
 7f6:	4629                	li	a2,10
 7f8:	000ba583          	lw	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	dc1ff0ef          	jal	5be <printint>
        i += 1;
 802:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 804:	8bca                	mv	s7,s2
      state = 0;
 806:	4981                	li	s3,0
        i += 1;
 808:	b56d                	j	6b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 80a:	008b8913          	add	s2,s7,8
 80e:	4681                	li	a3,0
 810:	4629                	li	a2,10
 812:	000ba583          	lw	a1,0(s7)
 816:	855a                	mv	a0,s6
 818:	da7ff0ef          	jal	5be <printint>
        i += 2;
 81c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 81e:	8bca                	mv	s7,s2
      state = 0;
 820:	4981                	li	s3,0
        i += 2;
 822:	bd41                	j	6b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 824:	008b8913          	add	s2,s7,8
 828:	4681                	li	a3,0
 82a:	4641                	li	a2,16
 82c:	000ba583          	lw	a1,0(s7)
 830:	855a                	mv	a0,s6
 832:	d8dff0ef          	jal	5be <printint>
 836:	8bca                	mv	s7,s2
      state = 0;
 838:	4981                	li	s3,0
 83a:	bda5                	j	6b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 83c:	008b8913          	add	s2,s7,8
 840:	4681                	li	a3,0
 842:	4641                	li	a2,16
 844:	000ba583          	lw	a1,0(s7)
 848:	855a                	mv	a0,s6
 84a:	d75ff0ef          	jal	5be <printint>
        i += 1;
 84e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 850:	8bca                	mv	s7,s2
      state = 0;
 852:	4981                	li	s3,0
        i += 1;
 854:	bdb9                	j	6b2 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 856:	008b8d13          	add	s10,s7,8
 85a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 85e:	03000593          	li	a1,48
 862:	855a                	mv	a0,s6
 864:	d3dff0ef          	jal	5a0 <putc>
  putc(fd, 'x');
 868:	07800593          	li	a1,120
 86c:	855a                	mv	a0,s6
 86e:	d33ff0ef          	jal	5a0 <putc>
 872:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 874:	00000b97          	auipc	s7,0x0
 878:	2a4b8b93          	add	s7,s7,676 # b18 <digits>
 87c:	03c9d793          	srl	a5,s3,0x3c
 880:	97de                	add	a5,a5,s7
 882:	0007c583          	lbu	a1,0(a5)
 886:	855a                	mv	a0,s6
 888:	d19ff0ef          	jal	5a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 88c:	0992                	sll	s3,s3,0x4
 88e:	397d                	addw	s2,s2,-1
 890:	fe0916e3          	bnez	s2,87c <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 894:	8bea                	mv	s7,s10
      state = 0;
 896:	4981                	li	s3,0
 898:	bd29                	j	6b2 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 89a:	008b8993          	add	s3,s7,8
 89e:	000bb903          	ld	s2,0(s7)
 8a2:	00090f63          	beqz	s2,8c0 <vprintf+0x25a>
        for(; *s; s++)
 8a6:	00094583          	lbu	a1,0(s2)
 8aa:	c195                	beqz	a1,8ce <vprintf+0x268>
          putc(fd, *s);
 8ac:	855a                	mv	a0,s6
 8ae:	cf3ff0ef          	jal	5a0 <putc>
        for(; *s; s++)
 8b2:	0905                	add	s2,s2,1
 8b4:	00094583          	lbu	a1,0(s2)
 8b8:	f9f5                	bnez	a1,8ac <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8ba:	8bce                	mv	s7,s3
      state = 0;
 8bc:	4981                	li	s3,0
 8be:	bbd5                	j	6b2 <vprintf+0x4c>
          s = "(null)";
 8c0:	00000917          	auipc	s2,0x0
 8c4:	25090913          	add	s2,s2,592 # b10 <malloc+0x142>
        for(; *s; s++)
 8c8:	02800593          	li	a1,40
 8cc:	b7c5                	j	8ac <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8ce:	8bce                	mv	s7,s3
      state = 0;
 8d0:	4981                	li	s3,0
 8d2:	b3c5                	j	6b2 <vprintf+0x4c>
    }
  }
}
 8d4:	60e6                	ld	ra,88(sp)
 8d6:	6446                	ld	s0,80(sp)
 8d8:	64a6                	ld	s1,72(sp)
 8da:	6906                	ld	s2,64(sp)
 8dc:	79e2                	ld	s3,56(sp)
 8de:	7a42                	ld	s4,48(sp)
 8e0:	7aa2                	ld	s5,40(sp)
 8e2:	7b02                	ld	s6,32(sp)
 8e4:	6be2                	ld	s7,24(sp)
 8e6:	6c42                	ld	s8,16(sp)
 8e8:	6ca2                	ld	s9,8(sp)
 8ea:	6d02                	ld	s10,0(sp)
 8ec:	6125                	add	sp,sp,96
 8ee:	8082                	ret

00000000000008f0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f0:	715d                	add	sp,sp,-80
 8f2:	ec06                	sd	ra,24(sp)
 8f4:	e822                	sd	s0,16(sp)
 8f6:	1000                	add	s0,sp,32
 8f8:	e010                	sd	a2,0(s0)
 8fa:	e414                	sd	a3,8(s0)
 8fc:	e818                	sd	a4,16(s0)
 8fe:	ec1c                	sd	a5,24(s0)
 900:	03043023          	sd	a6,32(s0)
 904:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 908:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 90c:	8622                	mv	a2,s0
 90e:	d59ff0ef          	jal	666 <vprintf>
}
 912:	60e2                	ld	ra,24(sp)
 914:	6442                	ld	s0,16(sp)
 916:	6161                	add	sp,sp,80
 918:	8082                	ret

000000000000091a <printf>:

void
printf(const char *fmt, ...)
{
 91a:	711d                	add	sp,sp,-96
 91c:	ec06                	sd	ra,24(sp)
 91e:	e822                	sd	s0,16(sp)
 920:	1000                	add	s0,sp,32
 922:	e40c                	sd	a1,8(s0)
 924:	e810                	sd	a2,16(s0)
 926:	ec14                	sd	a3,24(s0)
 928:	f018                	sd	a4,32(s0)
 92a:	f41c                	sd	a5,40(s0)
 92c:	03043823          	sd	a6,48(s0)
 930:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 934:	00840613          	add	a2,s0,8
 938:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 93c:	85aa                	mv	a1,a0
 93e:	4505                	li	a0,1
 940:	d27ff0ef          	jal	666 <vprintf>
}
 944:	60e2                	ld	ra,24(sp)
 946:	6442                	ld	s0,16(sp)
 948:	6125                	add	sp,sp,96
 94a:	8082                	ret

000000000000094c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 94c:	1141                	add	sp,sp,-16
 94e:	e422                	sd	s0,8(sp)
 950:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 952:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 956:	00000797          	auipc	a5,0x0
 95a:	6aa7b783          	ld	a5,1706(a5) # 1000 <freep>
 95e:	a02d                	j	988 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 960:	4618                	lw	a4,8(a2)
 962:	9f2d                	addw	a4,a4,a1
 964:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 968:	6398                	ld	a4,0(a5)
 96a:	6310                	ld	a2,0(a4)
 96c:	a83d                	j	9aa <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 96e:	ff852703          	lw	a4,-8(a0)
 972:	9f31                	addw	a4,a4,a2
 974:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 976:	ff053683          	ld	a3,-16(a0)
 97a:	a091                	j	9be <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97c:	6398                	ld	a4,0(a5)
 97e:	00e7e463          	bltu	a5,a4,986 <free+0x3a>
 982:	00e6ea63          	bltu	a3,a4,996 <free+0x4a>
{
 986:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 988:	fed7fae3          	bgeu	a5,a3,97c <free+0x30>
 98c:	6398                	ld	a4,0(a5)
 98e:	00e6e463          	bltu	a3,a4,996 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 992:	fee7eae3          	bltu	a5,a4,986 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 996:	ff852583          	lw	a1,-8(a0)
 99a:	6390                	ld	a2,0(a5)
 99c:	02059813          	sll	a6,a1,0x20
 9a0:	01c85713          	srl	a4,a6,0x1c
 9a4:	9736                	add	a4,a4,a3
 9a6:	fae60de3          	beq	a2,a4,960 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9aa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ae:	4790                	lw	a2,8(a5)
 9b0:	02061593          	sll	a1,a2,0x20
 9b4:	01c5d713          	srl	a4,a1,0x1c
 9b8:	973e                	add	a4,a4,a5
 9ba:	fae68ae3          	beq	a3,a4,96e <free+0x22>
    p->s.ptr = bp->s.ptr;
 9be:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9c0:	00000717          	auipc	a4,0x0
 9c4:	64f73023          	sd	a5,1600(a4) # 1000 <freep>
}
 9c8:	6422                	ld	s0,8(sp)
 9ca:	0141                	add	sp,sp,16
 9cc:	8082                	ret

00000000000009ce <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ce:	7139                	add	sp,sp,-64
 9d0:	fc06                	sd	ra,56(sp)
 9d2:	f822                	sd	s0,48(sp)
 9d4:	f426                	sd	s1,40(sp)
 9d6:	f04a                	sd	s2,32(sp)
 9d8:	ec4e                	sd	s3,24(sp)
 9da:	e852                	sd	s4,16(sp)
 9dc:	e456                	sd	s5,8(sp)
 9de:	e05a                	sd	s6,0(sp)
 9e0:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e2:	02051493          	sll	s1,a0,0x20
 9e6:	9081                	srl	s1,s1,0x20
 9e8:	04bd                	add	s1,s1,15
 9ea:	8091                	srl	s1,s1,0x4
 9ec:	0014899b          	addw	s3,s1,1
 9f0:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 9f2:	00000517          	auipc	a0,0x0
 9f6:	60e53503          	ld	a0,1550(a0) # 1000 <freep>
 9fa:	c515                	beqz	a0,a26 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9fe:	4798                	lw	a4,8(a5)
 a00:	02977f63          	bgeu	a4,s1,a3e <malloc+0x70>
  if(nu < 4096)
 a04:	8a4e                	mv	s4,s3
 a06:	0009871b          	sext.w	a4,s3
 a0a:	6685                	lui	a3,0x1
 a0c:	00d77363          	bgeu	a4,a3,a12 <malloc+0x44>
 a10:	6a05                	lui	s4,0x1
 a12:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a16:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a1a:	00000917          	auipc	s2,0x0
 a1e:	5e690913          	add	s2,s2,1510 # 1000 <freep>
  if(p == (char*)-1)
 a22:	5afd                	li	s5,-1
 a24:	a885                	j	a94 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 a26:	00000797          	auipc	a5,0x0
 a2a:	5fa78793          	add	a5,a5,1530 # 1020 <base>
 a2e:	00000717          	auipc	a4,0x0
 a32:	5cf73923          	sd	a5,1490(a4) # 1000 <freep>
 a36:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a38:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a3c:	b7e1                	j	a04 <malloc+0x36>
      if(p->s.size == nunits)
 a3e:	02e48c63          	beq	s1,a4,a76 <malloc+0xa8>
        p->s.size -= nunits;
 a42:	4137073b          	subw	a4,a4,s3
 a46:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a48:	02071693          	sll	a3,a4,0x20
 a4c:	01c6d713          	srl	a4,a3,0x1c
 a50:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a52:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a56:	00000717          	auipc	a4,0x0
 a5a:	5aa73523          	sd	a0,1450(a4) # 1000 <freep>
      return (void*)(p + 1);
 a5e:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a62:	70e2                	ld	ra,56(sp)
 a64:	7442                	ld	s0,48(sp)
 a66:	74a2                	ld	s1,40(sp)
 a68:	7902                	ld	s2,32(sp)
 a6a:	69e2                	ld	s3,24(sp)
 a6c:	6a42                	ld	s4,16(sp)
 a6e:	6aa2                	ld	s5,8(sp)
 a70:	6b02                	ld	s6,0(sp)
 a72:	6121                	add	sp,sp,64
 a74:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a76:	6398                	ld	a4,0(a5)
 a78:	e118                	sd	a4,0(a0)
 a7a:	bff1                	j	a56 <malloc+0x88>
  hp->s.size = nu;
 a7c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a80:	0541                	add	a0,a0,16
 a82:	ecbff0ef          	jal	94c <free>
  return freep;
 a86:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a8a:	dd61                	beqz	a0,a62 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a8e:	4798                	lw	a4,8(a5)
 a90:	fa9777e3          	bgeu	a4,s1,a3e <malloc+0x70>
    if(p == freep)
 a94:	00093703          	ld	a4,0(s2)
 a98:	853e                	mv	a0,a5
 a9a:	fef719e3          	bne	a4,a5,a8c <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 a9e:	8552                	mv	a0,s4
 aa0:	ab1ff0ef          	jal	550 <sbrk>
  if(p == (char*)-1)
 aa4:	fd551ce3          	bne	a0,s5,a7c <malloc+0xae>
        return 0;
 aa8:	4501                	li	a0,0
 aaa:	bf65                	j	a62 <malloc+0x94>
