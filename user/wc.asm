
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	add	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	add	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	add	s11,s11,-30 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	978a0a13          	add	s4,s4,-1672 # 9b0 <malloc+0xe2>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a035                	j	6e <wc+0x6e>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	1b6000ef          	jal	1fc <strchr>
  4a:	c919                	beqz	a0,60 <wc+0x60>
        inword = 0;
  4c:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  4e:	0485                	add	s1,s1,1
  50:	00998d63          	beq	s3,s1,6a <wc+0x6a>
      if(buf[i] == '\n')
  54:	0004c583          	lbu	a1,0(s1)
  58:	ff5596e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  5c:	2c05                	addw	s8,s8,1
  5e:	b7dd                	j	44 <wc+0x44>
      else if(!inword){
  60:	fe0917e3          	bnez	s2,4e <wc+0x4e>
        w++;
  64:	2c85                	addw	s9,s9,1
        inword = 1;
  66:	4905                	li	s2,1
  68:	b7dd                	j	4e <wc+0x4e>
      c++;
  6a:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6e:	20000613          	li	a2,512
  72:	85ee                	mv	a1,s11
  74:	f8843503          	ld	a0,-120(s0)
  78:	360000ef          	jal	3d8 <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
    for(i=0; i<n; i++){
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	add	s1,s1,-114 # 1010 <buf>
  8a:	009509b3          	add	s3,a0,s1
  8e:	b7d9                	j	54 <wc+0x54>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86ea                	mv	a3,s10
  9a:	8666                	mv	a2,s9
  9c:	85e2                	mv	a1,s8
  9e:	00001517          	auipc	a0,0x1
  a2:	92a50513          	add	a0,a0,-1750 # 9c8 <malloc+0xfa>
  a6:	774000ef          	jal	81a <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	add	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	8f050513          	add	a0,a0,-1808 # 9b8 <malloc+0xea>
  d0:	74a000ef          	jal	81a <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	2ea000ef          	jal	3c0 <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	add	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	ec26                	sd	s1,24(sp)
  e2:	e84a                	sd	s2,16(sp)
  e4:	e44e                	sd	s3,8(sp)
  e6:	1800                	add	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e8:	4785                	li	a5,1
  ea:	04a7d163          	bge	a5,a0,12c <main+0x52>
  ee:	00858913          	add	s2,a1,8
  f2:	ffe5099b          	addw	s3,a0,-2
  f6:	02099793          	sll	a5,s3,0x20
  fa:	01d7d993          	srl	s3,a5,0x1d
  fe:	05c1                	add	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	2f8000ef          	jal	400 <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054963          	bltz	a0,140 <main+0x66>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	2cc000ef          	jal	3e8 <close>
  for(i = 1; i < argc; i++){
 120:	0921                	add	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	298000ef          	jal	3c0 <exit>
    wc(0, "");
 12c:	00001597          	auipc	a1,0x1
 130:	8ac58593          	add	a1,a1,-1876 # 9d8 <malloc+0x10a>
 134:	4501                	li	a0,0
 136:	ecbff0ef          	jal	0 <wc>
    exit(0);
 13a:	4501                	li	a0,0
 13c:	284000ef          	jal	3c0 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 140:	00093583          	ld	a1,0(s2)
 144:	00001517          	auipc	a0,0x1
 148:	89c50513          	add	a0,a0,-1892 # 9e0 <malloc+0x112>
 14c:	6ce000ef          	jal	81a <printf>
      exit(1);
 150:	4505                	li	a0,1
 152:	26e000ef          	jal	3c0 <exit>

0000000000000156 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 156:	1141                	add	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	add	s0,sp,16
  extern int main();
  main();
 15e:	f7dff0ef          	jal	da <main>
  exit(0);
 162:	4501                	li	a0,0
 164:	25c000ef          	jal	3c0 <exit>

0000000000000168 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 168:	1141                	add	sp,sp,-16
 16a:	e422                	sd	s0,8(sp)
 16c:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16e:	87aa                	mv	a5,a0
 170:	0585                	add	a1,a1,1
 172:	0785                	add	a5,a5,1
 174:	fff5c703          	lbu	a4,-1(a1)
 178:	fee78fa3          	sb	a4,-1(a5)
 17c:	fb75                	bnez	a4,170 <strcpy+0x8>
    ;
  return os;
}
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	add	sp,sp,16
 182:	8082                	ret

0000000000000184 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 184:	1141                	add	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cb91                	beqz	a5,1a2 <strcmp+0x1e>
 190:	0005c703          	lbu	a4,0(a1)
 194:	00f71763          	bne	a4,a5,1a2 <strcmp+0x1e>
    p++, q++;
 198:	0505                	add	a0,a0,1
 19a:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	fbe5                	bnez	a5,190 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a2:	0005c503          	lbu	a0,0(a1)
}
 1a6:	40a7853b          	subw	a0,a5,a0
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	add	sp,sp,16
 1ae:	8082                	ret

00000000000001b0 <strlen>:

uint
strlen(const char *s)
{
 1b0:	1141                	add	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	cf91                	beqz	a5,1d6 <strlen+0x26>
 1bc:	0505                	add	a0,a0,1
 1be:	87aa                	mv	a5,a0
 1c0:	86be                	mv	a3,a5
 1c2:	0785                	add	a5,a5,1
 1c4:	fff7c703          	lbu	a4,-1(a5)
 1c8:	ff65                	bnez	a4,1c0 <strlen+0x10>
 1ca:	40a6853b          	subw	a0,a3,a0
 1ce:	2505                	addw	a0,a0,1
    ;
  return n;
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	add	sp,sp,16
 1d4:	8082                	ret
  for(n = 0; s[n]; n++)
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <strlen+0x20>

00000000000001da <memset>:

void*
memset(void *dst, int c, uint n)
{
 1da:	1141                	add	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e0:	ca19                	beqz	a2,1f6 <memset+0x1c>
 1e2:	87aa                	mv	a5,a0
 1e4:	1602                	sll	a2,a2,0x20
 1e6:	9201                	srl	a2,a2,0x20
 1e8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1ec:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f0:	0785                	add	a5,a5,1
 1f2:	fee79de3          	bne	a5,a4,1ec <memset+0x12>
  }
  return dst;
}
 1f6:	6422                	ld	s0,8(sp)
 1f8:	0141                	add	sp,sp,16
 1fa:	8082                	ret

00000000000001fc <strchr>:

char*
strchr(const char *s, char c)
{
 1fc:	1141                	add	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	add	s0,sp,16
  for(; *s; s++)
 202:	00054783          	lbu	a5,0(a0)
 206:	cb99                	beqz	a5,21c <strchr+0x20>
    if(*s == c)
 208:	00f58763          	beq	a1,a5,216 <strchr+0x1a>
  for(; *s; s++)
 20c:	0505                	add	a0,a0,1
 20e:	00054783          	lbu	a5,0(a0)
 212:	fbfd                	bnez	a5,208 <strchr+0xc>
      return (char*)s;
  return 0;
 214:	4501                	li	a0,0
}
 216:	6422                	ld	s0,8(sp)
 218:	0141                	add	sp,sp,16
 21a:	8082                	ret
  return 0;
 21c:	4501                	li	a0,0
 21e:	bfe5                	j	216 <strchr+0x1a>

0000000000000220 <gets>:

char*
gets(char *buf, int max)
{
 220:	711d                	add	sp,sp,-96
 222:	ec86                	sd	ra,88(sp)
 224:	e8a2                	sd	s0,80(sp)
 226:	e4a6                	sd	s1,72(sp)
 228:	e0ca                	sd	s2,64(sp)
 22a:	fc4e                	sd	s3,56(sp)
 22c:	f852                	sd	s4,48(sp)
 22e:	f456                	sd	s5,40(sp)
 230:	f05a                	sd	s6,32(sp)
 232:	ec5e                	sd	s7,24(sp)
 234:	1080                	add	s0,sp,96
 236:	8baa                	mv	s7,a0
 238:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23a:	892a                	mv	s2,a0
 23c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 23e:	4aa9                	li	s5,10
 240:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 242:	89a6                	mv	s3,s1
 244:	2485                	addw	s1,s1,1
 246:	0344d663          	bge	s1,s4,272 <gets+0x52>
    cc = read(0, &c, 1);
 24a:	4605                	li	a2,1
 24c:	faf40593          	add	a1,s0,-81
 250:	4501                	li	a0,0
 252:	186000ef          	jal	3d8 <read>
    if(cc < 1)
 256:	00a05e63          	blez	a0,272 <gets+0x52>
    buf[i++] = c;
 25a:	faf44783          	lbu	a5,-81(s0)
 25e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 262:	01578763          	beq	a5,s5,270 <gets+0x50>
 266:	0905                	add	s2,s2,1
 268:	fd679de3          	bne	a5,s6,242 <gets+0x22>
  for(i=0; i+1 < max; ){
 26c:	89a6                	mv	s3,s1
 26e:	a011                	j	272 <gets+0x52>
 270:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 272:	99de                	add	s3,s3,s7
 274:	00098023          	sb	zero,0(s3)
  return buf;
}
 278:	855e                	mv	a0,s7
 27a:	60e6                	ld	ra,88(sp)
 27c:	6446                	ld	s0,80(sp)
 27e:	64a6                	ld	s1,72(sp)
 280:	6906                	ld	s2,64(sp)
 282:	79e2                	ld	s3,56(sp)
 284:	7a42                	ld	s4,48(sp)
 286:	7aa2                	ld	s5,40(sp)
 288:	7b02                	ld	s6,32(sp)
 28a:	6be2                	ld	s7,24(sp)
 28c:	6125                	add	sp,sp,96
 28e:	8082                	ret

0000000000000290 <stat>:

int
stat(const char *n, struct stat *st)
{
 290:	1101                	add	sp,sp,-32
 292:	ec06                	sd	ra,24(sp)
 294:	e822                	sd	s0,16(sp)
 296:	e426                	sd	s1,8(sp)
 298:	e04a                	sd	s2,0(sp)
 29a:	1000                	add	s0,sp,32
 29c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29e:	4581                	li	a1,0
 2a0:	160000ef          	jal	400 <open>
  if(fd < 0)
 2a4:	02054163          	bltz	a0,2c6 <stat+0x36>
 2a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2aa:	85ca                	mv	a1,s2
 2ac:	16c000ef          	jal	418 <fstat>
 2b0:	892a                	mv	s2,a0
  close(fd);
 2b2:	8526                	mv	a0,s1
 2b4:	134000ef          	jal	3e8 <close>
  return r;
}
 2b8:	854a                	mv	a0,s2
 2ba:	60e2                	ld	ra,24(sp)
 2bc:	6442                	ld	s0,16(sp)
 2be:	64a2                	ld	s1,8(sp)
 2c0:	6902                	ld	s2,0(sp)
 2c2:	6105                	add	sp,sp,32
 2c4:	8082                	ret
    return -1;
 2c6:	597d                	li	s2,-1
 2c8:	bfc5                	j	2b8 <stat+0x28>

00000000000002ca <atoi>:

int
atoi(const char *s)
{
 2ca:	1141                	add	sp,sp,-16
 2cc:	e422                	sd	s0,8(sp)
 2ce:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d0:	00054683          	lbu	a3,0(a0)
 2d4:	fd06879b          	addw	a5,a3,-48
 2d8:	0ff7f793          	zext.b	a5,a5
 2dc:	4625                	li	a2,9
 2de:	02f66863          	bltu	a2,a5,30e <atoi+0x44>
 2e2:	872a                	mv	a4,a0
  n = 0;
 2e4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2e6:	0705                	add	a4,a4,1
 2e8:	0025179b          	sllw	a5,a0,0x2
 2ec:	9fa9                	addw	a5,a5,a0
 2ee:	0017979b          	sllw	a5,a5,0x1
 2f2:	9fb5                	addw	a5,a5,a3
 2f4:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2f8:	00074683          	lbu	a3,0(a4)
 2fc:	fd06879b          	addw	a5,a3,-48
 300:	0ff7f793          	zext.b	a5,a5
 304:	fef671e3          	bgeu	a2,a5,2e6 <atoi+0x1c>
  return n;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	add	sp,sp,16
 30c:	8082                	ret
  n = 0;
 30e:	4501                	li	a0,0
 310:	bfe5                	j	308 <atoi+0x3e>

0000000000000312 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 312:	1141                	add	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 318:	02b57463          	bgeu	a0,a1,340 <memmove+0x2e>
    while(n-- > 0)
 31c:	00c05f63          	blez	a2,33a <memmove+0x28>
 320:	1602                	sll	a2,a2,0x20
 322:	9201                	srl	a2,a2,0x20
 324:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 328:	872a                	mv	a4,a0
      *dst++ = *src++;
 32a:	0585                	add	a1,a1,1
 32c:	0705                	add	a4,a4,1
 32e:	fff5c683          	lbu	a3,-1(a1)
 332:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 336:	fee79ae3          	bne	a5,a4,32a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 33a:	6422                	ld	s0,8(sp)
 33c:	0141                	add	sp,sp,16
 33e:	8082                	ret
    dst += n;
 340:	00c50733          	add	a4,a0,a2
    src += n;
 344:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 346:	fec05ae3          	blez	a2,33a <memmove+0x28>
 34a:	fff6079b          	addw	a5,a2,-1
 34e:	1782                	sll	a5,a5,0x20
 350:	9381                	srl	a5,a5,0x20
 352:	fff7c793          	not	a5,a5
 356:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 358:	15fd                	add	a1,a1,-1
 35a:	177d                	add	a4,a4,-1
 35c:	0005c683          	lbu	a3,0(a1)
 360:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 364:	fee79ae3          	bne	a5,a4,358 <memmove+0x46>
 368:	bfc9                	j	33a <memmove+0x28>

000000000000036a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 36a:	1141                	add	sp,sp,-16
 36c:	e422                	sd	s0,8(sp)
 36e:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 370:	ca05                	beqz	a2,3a0 <memcmp+0x36>
 372:	fff6069b          	addw	a3,a2,-1
 376:	1682                	sll	a3,a3,0x20
 378:	9281                	srl	a3,a3,0x20
 37a:	0685                	add	a3,a3,1
 37c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 37e:	00054783          	lbu	a5,0(a0)
 382:	0005c703          	lbu	a4,0(a1)
 386:	00e79863          	bne	a5,a4,396 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 38a:	0505                	add	a0,a0,1
    p2++;
 38c:	0585                	add	a1,a1,1
  while (n-- > 0) {
 38e:	fed518e3          	bne	a0,a3,37e <memcmp+0x14>
  }
  return 0;
 392:	4501                	li	a0,0
 394:	a019                	j	39a <memcmp+0x30>
      return *p1 - *p2;
 396:	40e7853b          	subw	a0,a5,a4
}
 39a:	6422                	ld	s0,8(sp)
 39c:	0141                	add	sp,sp,16
 39e:	8082                	ret
  return 0;
 3a0:	4501                	li	a0,0
 3a2:	bfe5                	j	39a <memcmp+0x30>

00000000000003a4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3a4:	1141                	add	sp,sp,-16
 3a6:	e406                	sd	ra,8(sp)
 3a8:	e022                	sd	s0,0(sp)
 3aa:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 3ac:	f67ff0ef          	jal	312 <memmove>
}
 3b0:	60a2                	ld	ra,8(sp)
 3b2:	6402                	ld	s0,0(sp)
 3b4:	0141                	add	sp,sp,16
 3b6:	8082                	ret

00000000000003b8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b8:	4885                	li	a7,1
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c0:	4889                	li	a7,2
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c8:	488d                	li	a7,3
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d0:	4891                	li	a7,4
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <read>:
.global read
read:
 li a7, SYS_read
 3d8:	4895                	li	a7,5
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <write>:
.global write
write:
 li a7, SYS_write
 3e0:	48c1                	li	a7,16
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <close>:
.global close
close:
 li a7, SYS_close
 3e8:	48d5                	li	a7,21
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f0:	4899                	li	a7,6
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f8:	489d                	li	a7,7
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <open>:
.global open
open:
 li a7, SYS_open
 400:	48bd                	li	a7,15
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 408:	48c5                	li	a7,17
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 410:	48c9                	li	a7,18
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 418:	48a1                	li	a7,8
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <link>:
.global link
link:
 li a7, SYS_link
 420:	48cd                	li	a7,19
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 428:	48d1                	li	a7,20
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 430:	48a5                	li	a7,9
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <dup>:
.global dup
dup:
 li a7, SYS_dup
 438:	48a9                	li	a7,10
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 440:	48ad                	li	a7,11
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 448:	48b1                	li	a7,12
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 450:	48b5                	li	a7,13
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 458:	48b9                	li	a7,14
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 460:	48d9                	li	a7,22
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 468:	48dd                	li	a7,23
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 470:	48e1                	li	a7,24
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 478:	48e5                	li	a7,25
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 480:	48e9                	li	a7,26
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 488:	48ed                	li	a7,27
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 490:	48f1                	li	a7,28
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <uptime_nolock>:
.global uptime_nolock
uptime_nolock:
 li a7, SYS_uptime_nolock
 498:	48f5                	li	a7,29
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a0:	1101                	add	sp,sp,-32
 4a2:	ec06                	sd	ra,24(sp)
 4a4:	e822                	sd	s0,16(sp)
 4a6:	1000                	add	s0,sp,32
 4a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ac:	4605                	li	a2,1
 4ae:	fef40593          	add	a1,s0,-17
 4b2:	f2fff0ef          	jal	3e0 <write>
}
 4b6:	60e2                	ld	ra,24(sp)
 4b8:	6442                	ld	s0,16(sp)
 4ba:	6105                	add	sp,sp,32
 4bc:	8082                	ret

00000000000004be <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4be:	7139                	add	sp,sp,-64
 4c0:	fc06                	sd	ra,56(sp)
 4c2:	f822                	sd	s0,48(sp)
 4c4:	f426                	sd	s1,40(sp)
 4c6:	f04a                	sd	s2,32(sp)
 4c8:	ec4e                	sd	s3,24(sp)
 4ca:	0080                	add	s0,sp,64
 4cc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ce:	c299                	beqz	a3,4d4 <printint+0x16>
 4d0:	0805c763          	bltz	a1,55e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d4:	2581                	sext.w	a1,a1
  neg = 0;
 4d6:	4881                	li	a7,0
 4d8:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 4dc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4de:	2601                	sext.w	a2,a2
 4e0:	00000517          	auipc	a0,0x0
 4e4:	52050513          	add	a0,a0,1312 # a00 <digits>
 4e8:	883a                	mv	a6,a4
 4ea:	2705                	addw	a4,a4,1
 4ec:	02c5f7bb          	remuw	a5,a1,a2
 4f0:	1782                	sll	a5,a5,0x20
 4f2:	9381                	srl	a5,a5,0x20
 4f4:	97aa                	add	a5,a5,a0
 4f6:	0007c783          	lbu	a5,0(a5)
 4fa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4fe:	0005879b          	sext.w	a5,a1
 502:	02c5d5bb          	divuw	a1,a1,a2
 506:	0685                	add	a3,a3,1
 508:	fec7f0e3          	bgeu	a5,a2,4e8 <printint+0x2a>
  if(neg)
 50c:	00088c63          	beqz	a7,524 <printint+0x66>
    buf[i++] = '-';
 510:	fd070793          	add	a5,a4,-48
 514:	00878733          	add	a4,a5,s0
 518:	02d00793          	li	a5,45
 51c:	fef70823          	sb	a5,-16(a4)
 520:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 524:	02e05663          	blez	a4,550 <printint+0x92>
 528:	fc040793          	add	a5,s0,-64
 52c:	00e78933          	add	s2,a5,a4
 530:	fff78993          	add	s3,a5,-1
 534:	99ba                	add	s3,s3,a4
 536:	377d                	addw	a4,a4,-1
 538:	1702                	sll	a4,a4,0x20
 53a:	9301                	srl	a4,a4,0x20
 53c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 540:	fff94583          	lbu	a1,-1(s2)
 544:	8526                	mv	a0,s1
 546:	f5bff0ef          	jal	4a0 <putc>
  while(--i >= 0)
 54a:	197d                	add	s2,s2,-1
 54c:	ff391ae3          	bne	s2,s3,540 <printint+0x82>
}
 550:	70e2                	ld	ra,56(sp)
 552:	7442                	ld	s0,48(sp)
 554:	74a2                	ld	s1,40(sp)
 556:	7902                	ld	s2,32(sp)
 558:	69e2                	ld	s3,24(sp)
 55a:	6121                	add	sp,sp,64
 55c:	8082                	ret
    x = -xx;
 55e:	40b005bb          	negw	a1,a1
    neg = 1;
 562:	4885                	li	a7,1
    x = -xx;
 564:	bf95                	j	4d8 <printint+0x1a>

0000000000000566 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 566:	711d                	add	sp,sp,-96
 568:	ec86                	sd	ra,88(sp)
 56a:	e8a2                	sd	s0,80(sp)
 56c:	e4a6                	sd	s1,72(sp)
 56e:	e0ca                	sd	s2,64(sp)
 570:	fc4e                	sd	s3,56(sp)
 572:	f852                	sd	s4,48(sp)
 574:	f456                	sd	s5,40(sp)
 576:	f05a                	sd	s6,32(sp)
 578:	ec5e                	sd	s7,24(sp)
 57a:	e862                	sd	s8,16(sp)
 57c:	e466                	sd	s9,8(sp)
 57e:	e06a                	sd	s10,0(sp)
 580:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 582:	0005c903          	lbu	s2,0(a1)
 586:	24090763          	beqz	s2,7d4 <vprintf+0x26e>
 58a:	8b2a                	mv	s6,a0
 58c:	8a2e                	mv	s4,a1
 58e:	8bb2                	mv	s7,a2
  state = 0;
 590:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 592:	4481                	li	s1,0
 594:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 596:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 59a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 59e:	06c00c93          	li	s9,108
 5a2:	a005                	j	5c2 <vprintf+0x5c>
        putc(fd, c0);
 5a4:	85ca                	mv	a1,s2
 5a6:	855a                	mv	a0,s6
 5a8:	ef9ff0ef          	jal	4a0 <putc>
 5ac:	a019                	j	5b2 <vprintf+0x4c>
    } else if(state == '%'){
 5ae:	03598263          	beq	s3,s5,5d2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 5b2:	2485                	addw	s1,s1,1
 5b4:	8726                	mv	a4,s1
 5b6:	009a07b3          	add	a5,s4,s1
 5ba:	0007c903          	lbu	s2,0(a5)
 5be:	20090b63          	beqz	s2,7d4 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5c2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5c6:	fe0994e3          	bnez	s3,5ae <vprintf+0x48>
      if(c0 == '%'){
 5ca:	fd579de3          	bne	a5,s5,5a4 <vprintf+0x3e>
        state = '%';
 5ce:	89be                	mv	s3,a5
 5d0:	b7cd                	j	5b2 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 5d2:	c7c9                	beqz	a5,65c <vprintf+0xf6>
 5d4:	00ea06b3          	add	a3,s4,a4
 5d8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5dc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5de:	c681                	beqz	a3,5e6 <vprintf+0x80>
 5e0:	9752                	add	a4,a4,s4
 5e2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5e6:	03878f63          	beq	a5,s8,624 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 5ea:	05978963          	beq	a5,s9,63c <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5ee:	07500713          	li	a4,117
 5f2:	0ee78363          	beq	a5,a4,6d8 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5f6:	07800713          	li	a4,120
 5fa:	12e78563          	beq	a5,a4,724 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5fe:	07000713          	li	a4,112
 602:	14e78a63          	beq	a5,a4,756 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 606:	07300713          	li	a4,115
 60a:	18e78863          	beq	a5,a4,79a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 60e:	02500713          	li	a4,37
 612:	04e79563          	bne	a5,a4,65c <vprintf+0xf6>
        putc(fd, '%');
 616:	02500593          	li	a1,37
 61a:	855a                	mv	a0,s6
 61c:	e85ff0ef          	jal	4a0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 620:	4981                	li	s3,0
 622:	bf41                	j	5b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 624:	008b8913          	add	s2,s7,8
 628:	4685                	li	a3,1
 62a:	4629                	li	a2,10
 62c:	000ba583          	lw	a1,0(s7)
 630:	855a                	mv	a0,s6
 632:	e8dff0ef          	jal	4be <printint>
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	bfa5                	j	5b2 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 63c:	06400793          	li	a5,100
 640:	02f68963          	beq	a3,a5,672 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 644:	06c00793          	li	a5,108
 648:	04f68263          	beq	a3,a5,68c <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 64c:	07500793          	li	a5,117
 650:	0af68063          	beq	a3,a5,6f0 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 654:	07800793          	li	a5,120
 658:	0ef68263          	beq	a3,a5,73c <vprintf+0x1d6>
        putc(fd, '%');
 65c:	02500593          	li	a1,37
 660:	855a                	mv	a0,s6
 662:	e3fff0ef          	jal	4a0 <putc>
        putc(fd, c0);
 666:	85ca                	mv	a1,s2
 668:	855a                	mv	a0,s6
 66a:	e37ff0ef          	jal	4a0 <putc>
      state = 0;
 66e:	4981                	li	s3,0
 670:	b789                	j	5b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 672:	008b8913          	add	s2,s7,8
 676:	4685                	li	a3,1
 678:	4629                	li	a2,10
 67a:	000ba583          	lw	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	e3fff0ef          	jal	4be <printint>
        i += 1;
 684:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 686:	8bca                	mv	s7,s2
      state = 0;
 688:	4981                	li	s3,0
        i += 1;
 68a:	b725                	j	5b2 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 68c:	06400793          	li	a5,100
 690:	02f60763          	beq	a2,a5,6be <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 694:	07500793          	li	a5,117
 698:	06f60963          	beq	a2,a5,70a <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 69c:	07800793          	li	a5,120
 6a0:	faf61ee3          	bne	a2,a5,65c <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a4:	008b8913          	add	s2,s7,8
 6a8:	4681                	li	a3,0
 6aa:	4641                	li	a2,16
 6ac:	000ba583          	lw	a1,0(s7)
 6b0:	855a                	mv	a0,s6
 6b2:	e0dff0ef          	jal	4be <printint>
        i += 2;
 6b6:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b8:	8bca                	mv	s7,s2
      state = 0;
 6ba:	4981                	li	s3,0
        i += 2;
 6bc:	bddd                	j	5b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6be:	008b8913          	add	s2,s7,8
 6c2:	4685                	li	a3,1
 6c4:	4629                	li	a2,10
 6c6:	000ba583          	lw	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	df3ff0ef          	jal	4be <printint>
        i += 2;
 6d0:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d2:	8bca                	mv	s7,s2
      state = 0;
 6d4:	4981                	li	s3,0
        i += 2;
 6d6:	bdf1                	j	5b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 6d8:	008b8913          	add	s2,s7,8
 6dc:	4681                	li	a3,0
 6de:	4629                	li	a2,10
 6e0:	000ba583          	lw	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	dd9ff0ef          	jal	4be <printint>
 6ea:	8bca                	mv	s7,s2
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	b5d1                	j	5b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f0:	008b8913          	add	s2,s7,8
 6f4:	4681                	li	a3,0
 6f6:	4629                	li	a2,10
 6f8:	000ba583          	lw	a1,0(s7)
 6fc:	855a                	mv	a0,s6
 6fe:	dc1ff0ef          	jal	4be <printint>
        i += 1;
 702:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 704:	8bca                	mv	s7,s2
      state = 0;
 706:	4981                	li	s3,0
        i += 1;
 708:	b56d                	j	5b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 70a:	008b8913          	add	s2,s7,8
 70e:	4681                	li	a3,0
 710:	4629                	li	a2,10
 712:	000ba583          	lw	a1,0(s7)
 716:	855a                	mv	a0,s6
 718:	da7ff0ef          	jal	4be <printint>
        i += 2;
 71c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
        i += 2;
 722:	bd41                	j	5b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 724:	008b8913          	add	s2,s7,8
 728:	4681                	li	a3,0
 72a:	4641                	li	a2,16
 72c:	000ba583          	lw	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	d8dff0ef          	jal	4be <printint>
 736:	8bca                	mv	s7,s2
      state = 0;
 738:	4981                	li	s3,0
 73a:	bda5                	j	5b2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 73c:	008b8913          	add	s2,s7,8
 740:	4681                	li	a3,0
 742:	4641                	li	a2,16
 744:	000ba583          	lw	a1,0(s7)
 748:	855a                	mv	a0,s6
 74a:	d75ff0ef          	jal	4be <printint>
        i += 1;
 74e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 750:	8bca                	mv	s7,s2
      state = 0;
 752:	4981                	li	s3,0
        i += 1;
 754:	bdb9                	j	5b2 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 756:	008b8d13          	add	s10,s7,8
 75a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 75e:	03000593          	li	a1,48
 762:	855a                	mv	a0,s6
 764:	d3dff0ef          	jal	4a0 <putc>
  putc(fd, 'x');
 768:	07800593          	li	a1,120
 76c:	855a                	mv	a0,s6
 76e:	d33ff0ef          	jal	4a0 <putc>
 772:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 774:	00000b97          	auipc	s7,0x0
 778:	28cb8b93          	add	s7,s7,652 # a00 <digits>
 77c:	03c9d793          	srl	a5,s3,0x3c
 780:	97de                	add	a5,a5,s7
 782:	0007c583          	lbu	a1,0(a5)
 786:	855a                	mv	a0,s6
 788:	d19ff0ef          	jal	4a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 78c:	0992                	sll	s3,s3,0x4
 78e:	397d                	addw	s2,s2,-1
 790:	fe0916e3          	bnez	s2,77c <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 794:	8bea                	mv	s7,s10
      state = 0;
 796:	4981                	li	s3,0
 798:	bd29                	j	5b2 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 79a:	008b8993          	add	s3,s7,8
 79e:	000bb903          	ld	s2,0(s7)
 7a2:	00090f63          	beqz	s2,7c0 <vprintf+0x25a>
        for(; *s; s++)
 7a6:	00094583          	lbu	a1,0(s2)
 7aa:	c195                	beqz	a1,7ce <vprintf+0x268>
          putc(fd, *s);
 7ac:	855a                	mv	a0,s6
 7ae:	cf3ff0ef          	jal	4a0 <putc>
        for(; *s; s++)
 7b2:	0905                	add	s2,s2,1
 7b4:	00094583          	lbu	a1,0(s2)
 7b8:	f9f5                	bnez	a1,7ac <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7ba:	8bce                	mv	s7,s3
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	bbd5                	j	5b2 <vprintf+0x4c>
          s = "(null)";
 7c0:	00000917          	auipc	s2,0x0
 7c4:	23890913          	add	s2,s2,568 # 9f8 <malloc+0x12a>
        for(; *s; s++)
 7c8:	02800593          	li	a1,40
 7cc:	b7c5                	j	7ac <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7ce:	8bce                	mv	s7,s3
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	b3c5                	j	5b2 <vprintf+0x4c>
    }
  }
}
 7d4:	60e6                	ld	ra,88(sp)
 7d6:	6446                	ld	s0,80(sp)
 7d8:	64a6                	ld	s1,72(sp)
 7da:	6906                	ld	s2,64(sp)
 7dc:	79e2                	ld	s3,56(sp)
 7de:	7a42                	ld	s4,48(sp)
 7e0:	7aa2                	ld	s5,40(sp)
 7e2:	7b02                	ld	s6,32(sp)
 7e4:	6be2                	ld	s7,24(sp)
 7e6:	6c42                	ld	s8,16(sp)
 7e8:	6ca2                	ld	s9,8(sp)
 7ea:	6d02                	ld	s10,0(sp)
 7ec:	6125                	add	sp,sp,96
 7ee:	8082                	ret

00000000000007f0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7f0:	715d                	add	sp,sp,-80
 7f2:	ec06                	sd	ra,24(sp)
 7f4:	e822                	sd	s0,16(sp)
 7f6:	1000                	add	s0,sp,32
 7f8:	e010                	sd	a2,0(s0)
 7fa:	e414                	sd	a3,8(s0)
 7fc:	e818                	sd	a4,16(s0)
 7fe:	ec1c                	sd	a5,24(s0)
 800:	03043023          	sd	a6,32(s0)
 804:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 808:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 80c:	8622                	mv	a2,s0
 80e:	d59ff0ef          	jal	566 <vprintf>
}
 812:	60e2                	ld	ra,24(sp)
 814:	6442                	ld	s0,16(sp)
 816:	6161                	add	sp,sp,80
 818:	8082                	ret

000000000000081a <printf>:

void
printf(const char *fmt, ...)
{
 81a:	711d                	add	sp,sp,-96
 81c:	ec06                	sd	ra,24(sp)
 81e:	e822                	sd	s0,16(sp)
 820:	1000                	add	s0,sp,32
 822:	e40c                	sd	a1,8(s0)
 824:	e810                	sd	a2,16(s0)
 826:	ec14                	sd	a3,24(s0)
 828:	f018                	sd	a4,32(s0)
 82a:	f41c                	sd	a5,40(s0)
 82c:	03043823          	sd	a6,48(s0)
 830:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 834:	00840613          	add	a2,s0,8
 838:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 83c:	85aa                	mv	a1,a0
 83e:	4505                	li	a0,1
 840:	d27ff0ef          	jal	566 <vprintf>
}
 844:	60e2                	ld	ra,24(sp)
 846:	6442                	ld	s0,16(sp)
 848:	6125                	add	sp,sp,96
 84a:	8082                	ret

000000000000084c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84c:	1141                	add	sp,sp,-16
 84e:	e422                	sd	s0,8(sp)
 850:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 852:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 856:	00000797          	auipc	a5,0x0
 85a:	7aa7b783          	ld	a5,1962(a5) # 1000 <freep>
 85e:	a02d                	j	888 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 860:	4618                	lw	a4,8(a2)
 862:	9f2d                	addw	a4,a4,a1
 864:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 868:	6398                	ld	a4,0(a5)
 86a:	6310                	ld	a2,0(a4)
 86c:	a83d                	j	8aa <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 86e:	ff852703          	lw	a4,-8(a0)
 872:	9f31                	addw	a4,a4,a2
 874:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 876:	ff053683          	ld	a3,-16(a0)
 87a:	a091                	j	8be <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87c:	6398                	ld	a4,0(a5)
 87e:	00e7e463          	bltu	a5,a4,886 <free+0x3a>
 882:	00e6ea63          	bltu	a3,a4,896 <free+0x4a>
{
 886:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 888:	fed7fae3          	bgeu	a5,a3,87c <free+0x30>
 88c:	6398                	ld	a4,0(a5)
 88e:	00e6e463          	bltu	a3,a4,896 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 892:	fee7eae3          	bltu	a5,a4,886 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 896:	ff852583          	lw	a1,-8(a0)
 89a:	6390                	ld	a2,0(a5)
 89c:	02059813          	sll	a6,a1,0x20
 8a0:	01c85713          	srl	a4,a6,0x1c
 8a4:	9736                	add	a4,a4,a3
 8a6:	fae60de3          	beq	a2,a4,860 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8aa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ae:	4790                	lw	a2,8(a5)
 8b0:	02061593          	sll	a1,a2,0x20
 8b4:	01c5d713          	srl	a4,a1,0x1c
 8b8:	973e                	add	a4,a4,a5
 8ba:	fae68ae3          	beq	a3,a4,86e <free+0x22>
    p->s.ptr = bp->s.ptr;
 8be:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8c0:	00000717          	auipc	a4,0x0
 8c4:	74f73023          	sd	a5,1856(a4) # 1000 <freep>
}
 8c8:	6422                	ld	s0,8(sp)
 8ca:	0141                	add	sp,sp,16
 8cc:	8082                	ret

00000000000008ce <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ce:	7139                	add	sp,sp,-64
 8d0:	fc06                	sd	ra,56(sp)
 8d2:	f822                	sd	s0,48(sp)
 8d4:	f426                	sd	s1,40(sp)
 8d6:	f04a                	sd	s2,32(sp)
 8d8:	ec4e                	sd	s3,24(sp)
 8da:	e852                	sd	s4,16(sp)
 8dc:	e456                	sd	s5,8(sp)
 8de:	e05a                	sd	s6,0(sp)
 8e0:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e2:	02051493          	sll	s1,a0,0x20
 8e6:	9081                	srl	s1,s1,0x20
 8e8:	04bd                	add	s1,s1,15
 8ea:	8091                	srl	s1,s1,0x4
 8ec:	0014899b          	addw	s3,s1,1
 8f0:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 8f2:	00000517          	auipc	a0,0x0
 8f6:	70e53503          	ld	a0,1806(a0) # 1000 <freep>
 8fa:	c515                	beqz	a0,926 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fe:	4798                	lw	a4,8(a5)
 900:	02977f63          	bgeu	a4,s1,93e <malloc+0x70>
  if(nu < 4096)
 904:	8a4e                	mv	s4,s3
 906:	0009871b          	sext.w	a4,s3
 90a:	6685                	lui	a3,0x1
 90c:	00d77363          	bgeu	a4,a3,912 <malloc+0x44>
 910:	6a05                	lui	s4,0x1
 912:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 916:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 91a:	00000917          	auipc	s2,0x0
 91e:	6e690913          	add	s2,s2,1766 # 1000 <freep>
  if(p == (char*)-1)
 922:	5afd                	li	s5,-1
 924:	a885                	j	994 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 926:	00001797          	auipc	a5,0x1
 92a:	8ea78793          	add	a5,a5,-1814 # 1210 <base>
 92e:	00000717          	auipc	a4,0x0
 932:	6cf73923          	sd	a5,1746(a4) # 1000 <freep>
 936:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 938:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 93c:	b7e1                	j	904 <malloc+0x36>
      if(p->s.size == nunits)
 93e:	02e48c63          	beq	s1,a4,976 <malloc+0xa8>
        p->s.size -= nunits;
 942:	4137073b          	subw	a4,a4,s3
 946:	c798                	sw	a4,8(a5)
        p += p->s.size;
 948:	02071693          	sll	a3,a4,0x20
 94c:	01c6d713          	srl	a4,a3,0x1c
 950:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 952:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 956:	00000717          	auipc	a4,0x0
 95a:	6aa73523          	sd	a0,1706(a4) # 1000 <freep>
      return (void*)(p + 1);
 95e:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 962:	70e2                	ld	ra,56(sp)
 964:	7442                	ld	s0,48(sp)
 966:	74a2                	ld	s1,40(sp)
 968:	7902                	ld	s2,32(sp)
 96a:	69e2                	ld	s3,24(sp)
 96c:	6a42                	ld	s4,16(sp)
 96e:	6aa2                	ld	s5,8(sp)
 970:	6b02                	ld	s6,0(sp)
 972:	6121                	add	sp,sp,64
 974:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 976:	6398                	ld	a4,0(a5)
 978:	e118                	sd	a4,0(a0)
 97a:	bff1                	j	956 <malloc+0x88>
  hp->s.size = nu;
 97c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 980:	0541                	add	a0,a0,16
 982:	ecbff0ef          	jal	84c <free>
  return freep;
 986:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 98a:	dd61                	beqz	a0,962 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98e:	4798                	lw	a4,8(a5)
 990:	fa9777e3          	bgeu	a4,s1,93e <malloc+0x70>
    if(p == freep)
 994:	00093703          	ld	a4,0(s2)
 998:	853e                	mv	a0,a5
 99a:	fef719e3          	bne	a4,a5,98c <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 99e:	8552                	mv	a0,s4
 9a0:	aa9ff0ef          	jal	448 <sbrk>
  if(p == (char*)-1)
 9a4:	fd551ce3          	bne	a0,s5,97c <malloc+0xae>
        return 0;
 9a8:	4501                	li	a0,0
 9aa:	bf65                	j	962 <malloc+0x94>
