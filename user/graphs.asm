
user/_graphs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#define MAX_VERT 200

//cópia do grind.c
int
do_rand(unsigned long *ctx)
{
   0:	1141                	add	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	add	s0,sp,16
    long hi, lo, x;

    x = (*ctx % 0x7ffffffe) + 1;
   6:	611c                	ld	a5,0(a0)
   8:	80000737          	lui	a4,0x80000
   c:	ffe74713          	xor	a4,a4,-2
  10:	02e7f7b3          	remu	a5,a5,a4
  14:	0785                	add	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
  16:	66fd                	lui	a3,0x1f
  18:	31d68693          	add	a3,a3,797 # 1f31d <base+0x1e2fd>
  1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
  20:	6611                	lui	a2,0x4
  22:	1a760613          	add	a2,a2,423 # 41a7 <base+0x3187>
  26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
  2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
  2e:	76fd                	lui	a3,0xfffff
  30:	4ec68693          	add	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffe4cc>
  34:	02d787b3          	mul	a5,a5,a3
  38:	97ba                	add	a5,a5,a4
    if (x < 0)
  3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    x--;
  3e:	17fd                	add	a5,a5,-1
    *ctx = x;
  40:	e11c                	sd	a5,0(a0)
    return (x);
}
  42:	0007851b          	sext.w	a0,a5
  46:	6422                	ld	s0,8(sp)
  48:	0141                	add	sp,sp,16
  4a:	8082                	ret
        x += 0x7fffffff;
  4c:	80000737          	lui	a4,0x80000
  50:	fff74713          	not	a4,a4
  54:	97ba                	add	a5,a5,a4
  56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 7;

int
rand(void)
{
  58:	1141                	add	sp,sp,-16
  5a:	e406                	sd	ra,8(sp)
  5c:	e022                	sd	s0,0(sp)
  5e:	0800                	add	s0,sp,16
    return (do_rand(&rand_next));
  60:	00001517          	auipc	a0,0x1
  64:	fa050513          	add	a0,a0,-96 # 1000 <rand_next>
  68:	f99ff0ef          	jal	0 <do_rand>
}
  6c:	60a2                	ld	ra,8(sp)
  6e:	6402                	ld	s0,0(sp)
  70:	0141                	add	sp,sp,16
  72:	8082                	ret

0000000000000074 <generate_random_edge>:

void generate_random_edge(int **matrix, int num_vertices, int *vert1, int *vert2){
  74:	7179                	add	sp,sp,-48
  76:	f406                	sd	ra,40(sp)
  78:	f022                	sd	s0,32(sp)
  7a:	ec26                	sd	s1,24(sp)
  7c:	e84a                	sd	s2,16(sp)
  7e:	e44e                	sd	s3,8(sp)
  80:	e052                	sd	s4,0(sp)
  82:	1800                	add	s0,sp,48
  84:	8a2a                	mv	s4,a0
  86:	892e                	mv	s2,a1
  88:	84b2                	mv	s1,a2
  8a:	89b6                	mv	s3,a3
    do {
        *vert1 = rand() % num_vertices;
  8c:	fcdff0ef          	jal	58 <rand>
  90:	0325653b          	remw	a0,a0,s2
  94:	c088                	sw	a0,0(s1)
        *vert2 = rand() % num_vertices;
  96:	fc3ff0ef          	jal	58 <rand>
  9a:	0325653b          	remw	a0,a0,s2
  9e:	0005071b          	sext.w	a4,a0
  a2:	00a9a023          	sw	a0,0(s3)
    } while (*vert1 == *vert2 || matrix[*vert1][*vert2]);
  a6:	409c                	lw	a5,0(s1)
  a8:	fef702e3          	beq	a4,a5,8c <generate_random_edge+0x18>
  ac:	078e                	sll	a5,a5,0x3
  ae:	97d2                	add	a5,a5,s4
  b0:	639c                	ld	a5,0(a5)
  b2:	070a                	sll	a4,a4,0x2
  b4:	97ba                	add	a5,a5,a4
  b6:	439c                	lw	a5,0(a5)
  b8:	fbf1                	bnez	a5,8c <generate_random_edge+0x18>
}
  ba:	70a2                	ld	ra,40(sp)
  bc:	7402                	ld	s0,32(sp)
  be:	64e2                	ld	s1,24(sp)
  c0:	6942                	ld	s2,16(sp)
  c2:	69a2                	ld	s3,8(sp)
  c4:	6a02                	ld	s4,0(sp)
  c6:	6145                	add	sp,sp,48
  c8:	8082                	ret

00000000000000ca <main>:


int main(int agrc, char *argv[]){
  ca:	c5010113          	add	sp,sp,-944
  ce:	3a113423          	sd	ra,936(sp)
  d2:	3a813023          	sd	s0,928(sp)
  d6:	38913c23          	sd	s1,920(sp)
  da:	39213823          	sd	s2,912(sp)
  de:	39313423          	sd	s3,904(sp)
  e2:	39413023          	sd	s4,896(sp)
  e6:	37513c23          	sd	s5,888(sp)
  ea:	37613823          	sd	s6,880(sp)
  ee:	37713423          	sd	s7,872(sp)
  f2:	37813023          	sd	s8,864(sp)
  f6:	35913c23          	sd	s9,856(sp)
  fa:	35a13823          	sd	s10,848(sp)
  fe:	35b13423          	sd	s11,840(sp)
 102:	1f00                	add	s0,sp,944

    int index = 0;
    index += (argv[1][0] - '0') * 10;
 104:	6594                	ld	a3,8(a1)
 106:	0006c703          	lbu	a4,0(a3)
 10a:	fd07071b          	addw	a4,a4,-48 # 7fffffd0 <base+0x7fffefb0>
 10e:	0027179b          	sllw	a5,a4,0x2
 112:	9fb9                	addw	a5,a5,a4
 114:	0017979b          	sllw	a5,a5,0x1
    index += (argv[1][1] - '0');
 118:	0016c703          	lbu	a4,1(a3)
 11c:	fd07071b          	addw	a4,a4,-48
 120:	9fb9                	addw	a5,a5,a4
 122:	c4f43823          	sd	a5,-944(s0)
 126:	3e800d13          	li	s10,1000
        
        //gerar arestas aleatórias
        int u, v;
        for (int j = 0; j < num_edges; j++){
            generate_random_edge(matrix, num_vertices, &u, &v);
            matrix[u][v] = 1;
 12a:	4a85                	li	s5,1
 12c:	a8ad                	j	1a6 <main+0xdc>
        int esq = 0;
        int dir = 0;
        int atual;
        while (esq <= dir) {
            atual = fila[esq];
            for (int j = 0; j < num_vertices; j++){
 12e:	0785                	add	a5,a5,1
 130:	0691                	add	a3,a3,4
 132:	0007871b          	sext.w	a4,a5
 136:	02977263          	bgeu	a4,s1,15a <main+0x90>
                if (matrix[atual][j] && !visitado[j]){
 13a:	6198                	ld	a4,0(a1)
 13c:	00279613          	sll	a2,a5,0x2
 140:	9732                	add	a4,a4,a2
 142:	4318                	lw	a4,0(a4)
 144:	d76d                	beqz	a4,12e <main+0x64>
 146:	4298                	lw	a4,0(a3)
 148:	f37d                	bnez	a4,12e <main+0x64>
                    visitado[j] = 1;
 14a:	0156a023          	sw	s5,0(a3)
                    distancia[j] = distancia[atual] + 1;
                    dir++;
 14e:	2805                	addw	a6,a6,1
                    fila[dir] = j;
 150:	00281713          	sll	a4,a6,0x2
 154:	972a                	add	a4,a4,a0
 156:	c31c                	sw	a5,0(a4)
 158:	bfd9                	j	12e <main+0x64>
                }
            }
            esq++;
 15a:	2885                	addw	a7,a7,1
        while (esq <= dir) {
 15c:	0311                	add	t1,t1,4
 15e:	01184b63          	blt	a6,a7,174 <main+0xaa>
            atual = fila[esq];
 162:	00032583          	lw	a1,0(t1)
            for (int j = 0; j < num_vertices; j++){
 166:	d8f5                	beqz	s1,15a <main+0x90>
                if (matrix[atual][j] && !visitado[j]){
 168:	058e                	sll	a1,a1,0x3
 16a:	95d2                	add	a1,a1,s4
 16c:	c7040693          	add	a3,s0,-912
 170:	4781                	li	a5,0
 172:	b7e1                	j	13a <main+0x70>
        }

        //libera a matrix
        free(fila);
 174:	083000ef          	jal	9f6 <free>
        for (int i = 0; i < num_vertices; i++) {
 178:	c08d                	beqz	s1,19a <main+0xd0>
 17a:	84d2                	mv	s1,s4
 17c:	063b091b          	addw	s2,s6,99
 180:	02091793          	sll	a5,s2,0x20
 184:	01d7d913          	srl	s2,a5,0x1d
 188:	008a0793          	add	a5,s4,8
 18c:	993e                	add	s2,s2,a5
            free(matrix[i]);  
 18e:	6088                	ld	a0,0(s1)
 190:	067000ef          	jal	9f6 <free>
        for (int i = 0; i < num_vertices; i++) {
 194:	04a1                	add	s1,s1,8
 196:	ff249ce3          	bne	s1,s2,18e <main+0xc4>
        }
        free(matrix);
 19a:	8552                	mv	a0,s4
 19c:	05b000ef          	jal	9f6 <free>
    for (int i = 0; i < max_iter; i++){
 1a0:	3d7d                	addw	s10,s10,-1
 1a2:	100d0263          	beqz	s10,2a6 <main+0x1dc>
        uint num_vertices = (rand() % 101) + 100;
 1a6:	eb3ff0ef          	jal	58 <rand>
 1aa:	06500793          	li	a5,101
 1ae:	02f56b3b          	remw	s6,a0,a5
 1b2:	064b0b9b          	addw	s7,s6,100
 1b6:	000b8c9b          	sext.w	s9,s7
 1ba:	84e6                	mv	s1,s9
        int num_edges = (rand() % 351) + 50;
 1bc:	e9dff0ef          	jal	58 <rand>
 1c0:	15f00793          	li	a5,351
 1c4:	02f567bb          	remw	a5,a0,a5
 1c8:	c4f42e23          	sw	a5,-932(s0)
 1cc:	00078d9b          	sext.w	s11,a5
        int **matrix = malloc(num_vertices * sizeof(int *));
 1d0:	003b951b          	sllw	a0,s7,0x3
 1d4:	0a5000ef          	jal	a78 <malloc>
 1d8:	8a2a                	mv	s4,a0
        for (int j = 0; j < num_vertices; j++){
 1da:	040c8263          	beqz	s9,21e <main+0x154>
            matrix[j] = malloc(num_vertices * sizeof(int));
 1de:	002b9b9b          	sllw	s7,s7,0x2
 1e2:	89aa                	mv	s3,a0
 1e4:	063b079b          	addw	a5,s6,99
 1e8:	1782                	sll	a5,a5,0x20
 1ea:	9381                	srl	a5,a5,0x20
 1ec:	00850c13          	add	s8,a0,8
 1f0:	00379713          	sll	a4,a5,0x3
 1f4:	9c3a                	add	s8,s8,a4
 1f6:	0785                	add	a5,a5,1
 1f8:	00279913          	sll	s2,a5,0x2
 1fc:	855e                	mv	a0,s7
 1fe:	07b000ef          	jal	a78 <malloc>
 202:	86ce                	mv	a3,s3
 204:	00a9b023          	sd	a0,0(s3)
 208:	4781                	li	a5,0
                matrix[j][k] = 0;
 20a:	6298                	ld	a4,0(a3)
 20c:	973e                	add	a4,a4,a5
 20e:	00072023          	sw	zero,0(a4)
            for (int k = 0; k < num_vertices; k++){
 212:	0791                	add	a5,a5,4
 214:	ff279be3          	bne	a5,s2,20a <main+0x140>
        for (int j = 0; j < num_vertices; j++){
 218:	09a1                	add	s3,s3,8
 21a:	ff8991e3          	bne	s3,s8,1fc <main+0x132>
        for (int j = 0; j < num_edges; j++){
 21e:	fcf00793          	li	a5,-49
 222:	02fdcd63          	blt	s11,a5,25c <main+0x192>
 226:	c5c42783          	lw	a5,-932(s0)
 22a:	0327899b          	addw	s3,a5,50
 22e:	4901                	li	s2,0
            generate_random_edge(matrix, num_vertices, &u, &v);
 230:	c6c40693          	add	a3,s0,-916
 234:	c6840613          	add	a2,s0,-920
 238:	85e6                	mv	a1,s9
 23a:	8552                	mv	a0,s4
 23c:	e39ff0ef          	jal	74 <generate_random_edge>
            matrix[u][v] = 1;
 240:	c6842783          	lw	a5,-920(s0)
 244:	078e                	sll	a5,a5,0x3
 246:	97d2                	add	a5,a5,s4
 248:	c6c42703          	lw	a4,-916(s0)
 24c:	639c                	ld	a5,0(a5)
 24e:	070a                	sll	a4,a4,0x2
 250:	97ba                	add	a5,a5,a4
 252:	0157a023          	sw	s5,0(a5)
        for (int j = 0; j < num_edges; j++){
 256:	2905                	addw	s2,s2,1
 258:	fd391ce3          	bne	s2,s3,230 <main+0x166>
            u = rand() % num_vertices;
 25c:	dfdff0ef          	jal	58 <rand>
 260:	0295793b          	remuw	s2,a0,s1
 264:	0009099b          	sext.w	s3,s2
 268:	c7242423          	sw	s2,-920(s0)
            v = rand() % num_vertices;
 26c:	dedff0ef          	jal	58 <rand>
 270:	0295753b          	remuw	a0,a0,s1
 274:	0005079b          	sext.w	a5,a0
 278:	c6a42623          	sw	a0,-916(s0)
        } while (u == v);
 27c:	fef980e3          	beq	s3,a5,25c <main+0x192>
        int *fila = malloc(tam * sizeof(int));
 280:	64000513          	li	a0,1600
 284:	7f4000ef          	jal	a78 <malloc>
        for (int i = 0; i < 200; i++){
 288:	f9040713          	add	a4,s0,-112
        int *fila = malloc(tam * sizeof(int));
 28c:	c7040793          	add	a5,s0,-912
            visitado[i] = 0;
 290:	0007a023          	sw	zero,0(a5)
        for (int i = 0; i < 200; i++){
 294:	0791                	add	a5,a5,4
 296:	fef71de3          	bne	a4,a5,290 <main+0x1c6>
        fila[0] = u;
 29a:	01252023          	sw	s2,0(a0)
        while (esq <= dir) {
 29e:	832a                	mv	t1,a0
        int dir = 0;
 2a0:	4801                	li	a6,0
        int esq = 0;
 2a2:	4881                	li	a7,0
 2a4:	bd7d                	j	162 <main+0x98>

    }
    
    increment_metric(index, -1, MODE_EFICIENCIA);
 2a6:	4629                	li	a2,10
 2a8:	55fd                	li	a1,-1
 2aa:	c5043483          	ld	s1,-944(s0)
 2ae:	8526                	mv	a0,s1
 2b0:	37a000ef          	jal	62a <increment_metric>
    increment_metric(index, 123, MODE_OVERHEAD);
 2b4:	4621                	li	a2,8
 2b6:	07b00593          	li	a1,123
 2ba:	8526                	mv	a0,s1
 2bc:	36e000ef          	jal	62a <increment_metric>

    int pid = getpid();
 2c0:	332000ef          	jal	5f2 <getpid>
 2c4:	85aa                	mv	a1,a0
    set_justica(index, pid);
 2c6:	8526                	mv	a0,s1
 2c8:	37a000ef          	jal	642 <set_justica>

    return 0;
 2cc:	4501                	li	a0,0
 2ce:	3a813083          	ld	ra,936(sp)
 2d2:	3a013403          	ld	s0,928(sp)
 2d6:	39813483          	ld	s1,920(sp)
 2da:	39013903          	ld	s2,912(sp)
 2de:	38813983          	ld	s3,904(sp)
 2e2:	38013a03          	ld	s4,896(sp)
 2e6:	37813a83          	ld	s5,888(sp)
 2ea:	37013b03          	ld	s6,880(sp)
 2ee:	36813b83          	ld	s7,872(sp)
 2f2:	36013c03          	ld	s8,864(sp)
 2f6:	35813c83          	ld	s9,856(sp)
 2fa:	35013d03          	ld	s10,848(sp)
 2fe:	34813d83          	ld	s11,840(sp)
 302:	3b010113          	add	sp,sp,944
 306:	8082                	ret

0000000000000308 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 308:	1141                	add	sp,sp,-16
 30a:	e406                	sd	ra,8(sp)
 30c:	e022                	sd	s0,0(sp)
 30e:	0800                	add	s0,sp,16
  extern int main();
  main();
 310:	dbbff0ef          	jal	ca <main>
  exit(0);
 314:	4501                	li	a0,0
 316:	25c000ef          	jal	572 <exit>

000000000000031a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 31a:	1141                	add	sp,sp,-16
 31c:	e422                	sd	s0,8(sp)
 31e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 320:	87aa                	mv	a5,a0
 322:	0585                	add	a1,a1,1
 324:	0785                	add	a5,a5,1
 326:	fff5c703          	lbu	a4,-1(a1)
 32a:	fee78fa3          	sb	a4,-1(a5)
 32e:	fb75                	bnez	a4,322 <strcpy+0x8>
    ;
  return os;
}
 330:	6422                	ld	s0,8(sp)
 332:	0141                	add	sp,sp,16
 334:	8082                	ret

0000000000000336 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 336:	1141                	add	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 33c:	00054783          	lbu	a5,0(a0)
 340:	cb91                	beqz	a5,354 <strcmp+0x1e>
 342:	0005c703          	lbu	a4,0(a1)
 346:	00f71763          	bne	a4,a5,354 <strcmp+0x1e>
    p++, q++;
 34a:	0505                	add	a0,a0,1
 34c:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 34e:	00054783          	lbu	a5,0(a0)
 352:	fbe5                	bnez	a5,342 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 354:	0005c503          	lbu	a0,0(a1)
}
 358:	40a7853b          	subw	a0,a5,a0
 35c:	6422                	ld	s0,8(sp)
 35e:	0141                	add	sp,sp,16
 360:	8082                	ret

0000000000000362 <strlen>:

uint
strlen(const char *s)
{
 362:	1141                	add	sp,sp,-16
 364:	e422                	sd	s0,8(sp)
 366:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 368:	00054783          	lbu	a5,0(a0)
 36c:	cf91                	beqz	a5,388 <strlen+0x26>
 36e:	0505                	add	a0,a0,1
 370:	87aa                	mv	a5,a0
 372:	86be                	mv	a3,a5
 374:	0785                	add	a5,a5,1
 376:	fff7c703          	lbu	a4,-1(a5)
 37a:	ff65                	bnez	a4,372 <strlen+0x10>
 37c:	40a6853b          	subw	a0,a3,a0
 380:	2505                	addw	a0,a0,1
    ;
  return n;
}
 382:	6422                	ld	s0,8(sp)
 384:	0141                	add	sp,sp,16
 386:	8082                	ret
  for(n = 0; s[n]; n++)
 388:	4501                	li	a0,0
 38a:	bfe5                	j	382 <strlen+0x20>

000000000000038c <memset>:

void*
memset(void *dst, int c, uint n)
{
 38c:	1141                	add	sp,sp,-16
 38e:	e422                	sd	s0,8(sp)
 390:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 392:	ca19                	beqz	a2,3a8 <memset+0x1c>
 394:	87aa                	mv	a5,a0
 396:	1602                	sll	a2,a2,0x20
 398:	9201                	srl	a2,a2,0x20
 39a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 39e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3a2:	0785                	add	a5,a5,1
 3a4:	fee79de3          	bne	a5,a4,39e <memset+0x12>
  }
  return dst;
}
 3a8:	6422                	ld	s0,8(sp)
 3aa:	0141                	add	sp,sp,16
 3ac:	8082                	ret

00000000000003ae <strchr>:

char*
strchr(const char *s, char c)
{
 3ae:	1141                	add	sp,sp,-16
 3b0:	e422                	sd	s0,8(sp)
 3b2:	0800                	add	s0,sp,16
  for(; *s; s++)
 3b4:	00054783          	lbu	a5,0(a0)
 3b8:	cb99                	beqz	a5,3ce <strchr+0x20>
    if(*s == c)
 3ba:	00f58763          	beq	a1,a5,3c8 <strchr+0x1a>
  for(; *s; s++)
 3be:	0505                	add	a0,a0,1
 3c0:	00054783          	lbu	a5,0(a0)
 3c4:	fbfd                	bnez	a5,3ba <strchr+0xc>
      return (char*)s;
  return 0;
 3c6:	4501                	li	a0,0
}
 3c8:	6422                	ld	s0,8(sp)
 3ca:	0141                	add	sp,sp,16
 3cc:	8082                	ret
  return 0;
 3ce:	4501                	li	a0,0
 3d0:	bfe5                	j	3c8 <strchr+0x1a>

00000000000003d2 <gets>:

char*
gets(char *buf, int max)
{
 3d2:	711d                	add	sp,sp,-96
 3d4:	ec86                	sd	ra,88(sp)
 3d6:	e8a2                	sd	s0,80(sp)
 3d8:	e4a6                	sd	s1,72(sp)
 3da:	e0ca                	sd	s2,64(sp)
 3dc:	fc4e                	sd	s3,56(sp)
 3de:	f852                	sd	s4,48(sp)
 3e0:	f456                	sd	s5,40(sp)
 3e2:	f05a                	sd	s6,32(sp)
 3e4:	ec5e                	sd	s7,24(sp)
 3e6:	1080                	add	s0,sp,96
 3e8:	8baa                	mv	s7,a0
 3ea:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ec:	892a                	mv	s2,a0
 3ee:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3f0:	4aa9                	li	s5,10
 3f2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3f4:	89a6                	mv	s3,s1
 3f6:	2485                	addw	s1,s1,1
 3f8:	0344d663          	bge	s1,s4,424 <gets+0x52>
    cc = read(0, &c, 1);
 3fc:	4605                	li	a2,1
 3fe:	faf40593          	add	a1,s0,-81
 402:	4501                	li	a0,0
 404:	186000ef          	jal	58a <read>
    if(cc < 1)
 408:	00a05e63          	blez	a0,424 <gets+0x52>
    buf[i++] = c;
 40c:	faf44783          	lbu	a5,-81(s0)
 410:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 414:	01578763          	beq	a5,s5,422 <gets+0x50>
 418:	0905                	add	s2,s2,1
 41a:	fd679de3          	bne	a5,s6,3f4 <gets+0x22>
  for(i=0; i+1 < max; ){
 41e:	89a6                	mv	s3,s1
 420:	a011                	j	424 <gets+0x52>
 422:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 424:	99de                	add	s3,s3,s7
 426:	00098023          	sb	zero,0(s3)
  return buf;
}
 42a:	855e                	mv	a0,s7
 42c:	60e6                	ld	ra,88(sp)
 42e:	6446                	ld	s0,80(sp)
 430:	64a6                	ld	s1,72(sp)
 432:	6906                	ld	s2,64(sp)
 434:	79e2                	ld	s3,56(sp)
 436:	7a42                	ld	s4,48(sp)
 438:	7aa2                	ld	s5,40(sp)
 43a:	7b02                	ld	s6,32(sp)
 43c:	6be2                	ld	s7,24(sp)
 43e:	6125                	add	sp,sp,96
 440:	8082                	ret

0000000000000442 <stat>:

int
stat(const char *n, struct stat *st)
{
 442:	1101                	add	sp,sp,-32
 444:	ec06                	sd	ra,24(sp)
 446:	e822                	sd	s0,16(sp)
 448:	e426                	sd	s1,8(sp)
 44a:	e04a                	sd	s2,0(sp)
 44c:	1000                	add	s0,sp,32
 44e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 450:	4581                	li	a1,0
 452:	160000ef          	jal	5b2 <open>
  if(fd < 0)
 456:	02054163          	bltz	a0,478 <stat+0x36>
 45a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 45c:	85ca                	mv	a1,s2
 45e:	16c000ef          	jal	5ca <fstat>
 462:	892a                	mv	s2,a0
  close(fd);
 464:	8526                	mv	a0,s1
 466:	134000ef          	jal	59a <close>
  return r;
}
 46a:	854a                	mv	a0,s2
 46c:	60e2                	ld	ra,24(sp)
 46e:	6442                	ld	s0,16(sp)
 470:	64a2                	ld	s1,8(sp)
 472:	6902                	ld	s2,0(sp)
 474:	6105                	add	sp,sp,32
 476:	8082                	ret
    return -1;
 478:	597d                	li	s2,-1
 47a:	bfc5                	j	46a <stat+0x28>

000000000000047c <atoi>:

int
atoi(const char *s)
{
 47c:	1141                	add	sp,sp,-16
 47e:	e422                	sd	s0,8(sp)
 480:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 482:	00054683          	lbu	a3,0(a0)
 486:	fd06879b          	addw	a5,a3,-48
 48a:	0ff7f793          	zext.b	a5,a5
 48e:	4625                	li	a2,9
 490:	02f66863          	bltu	a2,a5,4c0 <atoi+0x44>
 494:	872a                	mv	a4,a0
  n = 0;
 496:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 498:	0705                	add	a4,a4,1
 49a:	0025179b          	sllw	a5,a0,0x2
 49e:	9fa9                	addw	a5,a5,a0
 4a0:	0017979b          	sllw	a5,a5,0x1
 4a4:	9fb5                	addw	a5,a5,a3
 4a6:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4aa:	00074683          	lbu	a3,0(a4)
 4ae:	fd06879b          	addw	a5,a3,-48
 4b2:	0ff7f793          	zext.b	a5,a5
 4b6:	fef671e3          	bgeu	a2,a5,498 <atoi+0x1c>
  return n;
}
 4ba:	6422                	ld	s0,8(sp)
 4bc:	0141                	add	sp,sp,16
 4be:	8082                	ret
  n = 0;
 4c0:	4501                	li	a0,0
 4c2:	bfe5                	j	4ba <atoi+0x3e>

00000000000004c4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4c4:	1141                	add	sp,sp,-16
 4c6:	e422                	sd	s0,8(sp)
 4c8:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4ca:	02b57463          	bgeu	a0,a1,4f2 <memmove+0x2e>
    while(n-- > 0)
 4ce:	00c05f63          	blez	a2,4ec <memmove+0x28>
 4d2:	1602                	sll	a2,a2,0x20
 4d4:	9201                	srl	a2,a2,0x20
 4d6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4da:	872a                	mv	a4,a0
      *dst++ = *src++;
 4dc:	0585                	add	a1,a1,1
 4de:	0705                	add	a4,a4,1
 4e0:	fff5c683          	lbu	a3,-1(a1)
 4e4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4e8:	fee79ae3          	bne	a5,a4,4dc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4ec:	6422                	ld	s0,8(sp)
 4ee:	0141                	add	sp,sp,16
 4f0:	8082                	ret
    dst += n;
 4f2:	00c50733          	add	a4,a0,a2
    src += n;
 4f6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4f8:	fec05ae3          	blez	a2,4ec <memmove+0x28>
 4fc:	fff6079b          	addw	a5,a2,-1
 500:	1782                	sll	a5,a5,0x20
 502:	9381                	srl	a5,a5,0x20
 504:	fff7c793          	not	a5,a5
 508:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 50a:	15fd                	add	a1,a1,-1
 50c:	177d                	add	a4,a4,-1
 50e:	0005c683          	lbu	a3,0(a1)
 512:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 516:	fee79ae3          	bne	a5,a4,50a <memmove+0x46>
 51a:	bfc9                	j	4ec <memmove+0x28>

000000000000051c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 51c:	1141                	add	sp,sp,-16
 51e:	e422                	sd	s0,8(sp)
 520:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 522:	ca05                	beqz	a2,552 <memcmp+0x36>
 524:	fff6069b          	addw	a3,a2,-1
 528:	1682                	sll	a3,a3,0x20
 52a:	9281                	srl	a3,a3,0x20
 52c:	0685                	add	a3,a3,1
 52e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 530:	00054783          	lbu	a5,0(a0)
 534:	0005c703          	lbu	a4,0(a1)
 538:	00e79863          	bne	a5,a4,548 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 53c:	0505                	add	a0,a0,1
    p2++;
 53e:	0585                	add	a1,a1,1
  while (n-- > 0) {
 540:	fed518e3          	bne	a0,a3,530 <memcmp+0x14>
  }
  return 0;
 544:	4501                	li	a0,0
 546:	a019                	j	54c <memcmp+0x30>
      return *p1 - *p2;
 548:	40e7853b          	subw	a0,a5,a4
}
 54c:	6422                	ld	s0,8(sp)
 54e:	0141                	add	sp,sp,16
 550:	8082                	ret
  return 0;
 552:	4501                	li	a0,0
 554:	bfe5                	j	54c <memcmp+0x30>

0000000000000556 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 556:	1141                	add	sp,sp,-16
 558:	e406                	sd	ra,8(sp)
 55a:	e022                	sd	s0,0(sp)
 55c:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 55e:	f67ff0ef          	jal	4c4 <memmove>
}
 562:	60a2                	ld	ra,8(sp)
 564:	6402                	ld	s0,0(sp)
 566:	0141                	add	sp,sp,16
 568:	8082                	ret

000000000000056a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 56a:	4885                	li	a7,1
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <exit>:
.global exit
exit:
 li a7, SYS_exit
 572:	4889                	li	a7,2
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <wait>:
.global wait
wait:
 li a7, SYS_wait
 57a:	488d                	li	a7,3
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 582:	4891                	li	a7,4
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <read>:
.global read
read:
 li a7, SYS_read
 58a:	4895                	li	a7,5
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <write>:
.global write
write:
 li a7, SYS_write
 592:	48c1                	li	a7,16
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <close>:
.global close
close:
 li a7, SYS_close
 59a:	48d5                	li	a7,21
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5a2:	4899                	li	a7,6
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <exec>:
.global exec
exec:
 li a7, SYS_exec
 5aa:	489d                	li	a7,7
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <open>:
.global open
open:
 li a7, SYS_open
 5b2:	48bd                	li	a7,15
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5ba:	48c5                	li	a7,17
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5c2:	48c9                	li	a7,18
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5ca:	48a1                	li	a7,8
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <link>:
.global link
link:
 li a7, SYS_link
 5d2:	48cd                	li	a7,19
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5da:	48d1                	li	a7,20
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5e2:	48a5                	li	a7,9
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ea:	48a9                	li	a7,10
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5f2:	48ad                	li	a7,11
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5fa:	48b1                	li	a7,12
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 602:	48b5                	li	a7,13
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 60a:	48b9                	li	a7,14
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 612:	48d9                	li	a7,22
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 61a:	48dd                	li	a7,23
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 622:	48e1                	li	a7,24
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 62a:	48e5                	li	a7,25
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 632:	48e9                	li	a7,26
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 63a:	48ed                	li	a7,27
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 642:	48f1                	li	a7,28
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 64a:	1101                	add	sp,sp,-32
 64c:	ec06                	sd	ra,24(sp)
 64e:	e822                	sd	s0,16(sp)
 650:	1000                	add	s0,sp,32
 652:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 656:	4605                	li	a2,1
 658:	fef40593          	add	a1,s0,-17
 65c:	f37ff0ef          	jal	592 <write>
}
 660:	60e2                	ld	ra,24(sp)
 662:	6442                	ld	s0,16(sp)
 664:	6105                	add	sp,sp,32
 666:	8082                	ret

0000000000000668 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 668:	7139                	add	sp,sp,-64
 66a:	fc06                	sd	ra,56(sp)
 66c:	f822                	sd	s0,48(sp)
 66e:	f426                	sd	s1,40(sp)
 670:	f04a                	sd	s2,32(sp)
 672:	ec4e                	sd	s3,24(sp)
 674:	0080                	add	s0,sp,64
 676:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 678:	c299                	beqz	a3,67e <printint+0x16>
 67a:	0805c763          	bltz	a1,708 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 67e:	2581                	sext.w	a1,a1
  neg = 0;
 680:	4881                	li	a7,0
 682:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 686:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 688:	2601                	sext.w	a2,a2
 68a:	00000517          	auipc	a0,0x0
 68e:	4de50513          	add	a0,a0,1246 # b68 <digits>
 692:	883a                	mv	a6,a4
 694:	2705                	addw	a4,a4,1
 696:	02c5f7bb          	remuw	a5,a1,a2
 69a:	1782                	sll	a5,a5,0x20
 69c:	9381                	srl	a5,a5,0x20
 69e:	97aa                	add	a5,a5,a0
 6a0:	0007c783          	lbu	a5,0(a5)
 6a4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6a8:	0005879b          	sext.w	a5,a1
 6ac:	02c5d5bb          	divuw	a1,a1,a2
 6b0:	0685                	add	a3,a3,1
 6b2:	fec7f0e3          	bgeu	a5,a2,692 <printint+0x2a>
  if(neg)
 6b6:	00088c63          	beqz	a7,6ce <printint+0x66>
    buf[i++] = '-';
 6ba:	fd070793          	add	a5,a4,-48
 6be:	00878733          	add	a4,a5,s0
 6c2:	02d00793          	li	a5,45
 6c6:	fef70823          	sb	a5,-16(a4)
 6ca:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 6ce:	02e05663          	blez	a4,6fa <printint+0x92>
 6d2:	fc040793          	add	a5,s0,-64
 6d6:	00e78933          	add	s2,a5,a4
 6da:	fff78993          	add	s3,a5,-1
 6de:	99ba                	add	s3,s3,a4
 6e0:	377d                	addw	a4,a4,-1
 6e2:	1702                	sll	a4,a4,0x20
 6e4:	9301                	srl	a4,a4,0x20
 6e6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6ea:	fff94583          	lbu	a1,-1(s2)
 6ee:	8526                	mv	a0,s1
 6f0:	f5bff0ef          	jal	64a <putc>
  while(--i >= 0)
 6f4:	197d                	add	s2,s2,-1
 6f6:	ff391ae3          	bne	s2,s3,6ea <printint+0x82>
}
 6fa:	70e2                	ld	ra,56(sp)
 6fc:	7442                	ld	s0,48(sp)
 6fe:	74a2                	ld	s1,40(sp)
 700:	7902                	ld	s2,32(sp)
 702:	69e2                	ld	s3,24(sp)
 704:	6121                	add	sp,sp,64
 706:	8082                	ret
    x = -xx;
 708:	40b005bb          	negw	a1,a1
    neg = 1;
 70c:	4885                	li	a7,1
    x = -xx;
 70e:	bf95                	j	682 <printint+0x1a>

0000000000000710 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 710:	711d                	add	sp,sp,-96
 712:	ec86                	sd	ra,88(sp)
 714:	e8a2                	sd	s0,80(sp)
 716:	e4a6                	sd	s1,72(sp)
 718:	e0ca                	sd	s2,64(sp)
 71a:	fc4e                	sd	s3,56(sp)
 71c:	f852                	sd	s4,48(sp)
 71e:	f456                	sd	s5,40(sp)
 720:	f05a                	sd	s6,32(sp)
 722:	ec5e                	sd	s7,24(sp)
 724:	e862                	sd	s8,16(sp)
 726:	e466                	sd	s9,8(sp)
 728:	e06a                	sd	s10,0(sp)
 72a:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 72c:	0005c903          	lbu	s2,0(a1)
 730:	24090763          	beqz	s2,97e <vprintf+0x26e>
 734:	8b2a                	mv	s6,a0
 736:	8a2e                	mv	s4,a1
 738:	8bb2                	mv	s7,a2
  state = 0;
 73a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 73c:	4481                	li	s1,0
 73e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 740:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 744:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 748:	06c00c93          	li	s9,108
 74c:	a005                	j	76c <vprintf+0x5c>
        putc(fd, c0);
 74e:	85ca                	mv	a1,s2
 750:	855a                	mv	a0,s6
 752:	ef9ff0ef          	jal	64a <putc>
 756:	a019                	j	75c <vprintf+0x4c>
    } else if(state == '%'){
 758:	03598263          	beq	s3,s5,77c <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 75c:	2485                	addw	s1,s1,1
 75e:	8726                	mv	a4,s1
 760:	009a07b3          	add	a5,s4,s1
 764:	0007c903          	lbu	s2,0(a5)
 768:	20090b63          	beqz	s2,97e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 76c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 770:	fe0994e3          	bnez	s3,758 <vprintf+0x48>
      if(c0 == '%'){
 774:	fd579de3          	bne	a5,s5,74e <vprintf+0x3e>
        state = '%';
 778:	89be                	mv	s3,a5
 77a:	b7cd                	j	75c <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 77c:	c7c9                	beqz	a5,806 <vprintf+0xf6>
 77e:	00ea06b3          	add	a3,s4,a4
 782:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 786:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 788:	c681                	beqz	a3,790 <vprintf+0x80>
 78a:	9752                	add	a4,a4,s4
 78c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 790:	03878f63          	beq	a5,s8,7ce <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 794:	05978963          	beq	a5,s9,7e6 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 798:	07500713          	li	a4,117
 79c:	0ee78363          	beq	a5,a4,882 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 7a0:	07800713          	li	a4,120
 7a4:	12e78563          	beq	a5,a4,8ce <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7a8:	07000713          	li	a4,112
 7ac:	14e78a63          	beq	a5,a4,900 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 7b0:	07300713          	li	a4,115
 7b4:	18e78863          	beq	a5,a4,944 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7b8:	02500713          	li	a4,37
 7bc:	04e79563          	bne	a5,a4,806 <vprintf+0xf6>
        putc(fd, '%');
 7c0:	02500593          	li	a1,37
 7c4:	855a                	mv	a0,s6
 7c6:	e85ff0ef          	jal	64a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	bf41                	j	75c <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 7ce:	008b8913          	add	s2,s7,8
 7d2:	4685                	li	a3,1
 7d4:	4629                	li	a2,10
 7d6:	000ba583          	lw	a1,0(s7)
 7da:	855a                	mv	a0,s6
 7dc:	e8dff0ef          	jal	668 <printint>
 7e0:	8bca                	mv	s7,s2
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	bfa5                	j	75c <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 7e6:	06400793          	li	a5,100
 7ea:	02f68963          	beq	a3,a5,81c <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7ee:	06c00793          	li	a5,108
 7f2:	04f68263          	beq	a3,a5,836 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 7f6:	07500793          	li	a5,117
 7fa:	0af68063          	beq	a3,a5,89a <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 7fe:	07800793          	li	a5,120
 802:	0ef68263          	beq	a3,a5,8e6 <vprintf+0x1d6>
        putc(fd, '%');
 806:	02500593          	li	a1,37
 80a:	855a                	mv	a0,s6
 80c:	e3fff0ef          	jal	64a <putc>
        putc(fd, c0);
 810:	85ca                	mv	a1,s2
 812:	855a                	mv	a0,s6
 814:	e37ff0ef          	jal	64a <putc>
      state = 0;
 818:	4981                	li	s3,0
 81a:	b789                	j	75c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 81c:	008b8913          	add	s2,s7,8
 820:	4685                	li	a3,1
 822:	4629                	li	a2,10
 824:	000ba583          	lw	a1,0(s7)
 828:	855a                	mv	a0,s6
 82a:	e3fff0ef          	jal	668 <printint>
        i += 1;
 82e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 830:	8bca                	mv	s7,s2
      state = 0;
 832:	4981                	li	s3,0
        i += 1;
 834:	b725                	j	75c <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 836:	06400793          	li	a5,100
 83a:	02f60763          	beq	a2,a5,868 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 83e:	07500793          	li	a5,117
 842:	06f60963          	beq	a2,a5,8b4 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 846:	07800793          	li	a5,120
 84a:	faf61ee3          	bne	a2,a5,806 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 84e:	008b8913          	add	s2,s7,8
 852:	4681                	li	a3,0
 854:	4641                	li	a2,16
 856:	000ba583          	lw	a1,0(s7)
 85a:	855a                	mv	a0,s6
 85c:	e0dff0ef          	jal	668 <printint>
        i += 2;
 860:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 862:	8bca                	mv	s7,s2
      state = 0;
 864:	4981                	li	s3,0
        i += 2;
 866:	bddd                	j	75c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 868:	008b8913          	add	s2,s7,8
 86c:	4685                	li	a3,1
 86e:	4629                	li	a2,10
 870:	000ba583          	lw	a1,0(s7)
 874:	855a                	mv	a0,s6
 876:	df3ff0ef          	jal	668 <printint>
        i += 2;
 87a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 87c:	8bca                	mv	s7,s2
      state = 0;
 87e:	4981                	li	s3,0
        i += 2;
 880:	bdf1                	j	75c <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 882:	008b8913          	add	s2,s7,8
 886:	4681                	li	a3,0
 888:	4629                	li	a2,10
 88a:	000ba583          	lw	a1,0(s7)
 88e:	855a                	mv	a0,s6
 890:	dd9ff0ef          	jal	668 <printint>
 894:	8bca                	mv	s7,s2
      state = 0;
 896:	4981                	li	s3,0
 898:	b5d1                	j	75c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 89a:	008b8913          	add	s2,s7,8
 89e:	4681                	li	a3,0
 8a0:	4629                	li	a2,10
 8a2:	000ba583          	lw	a1,0(s7)
 8a6:	855a                	mv	a0,s6
 8a8:	dc1ff0ef          	jal	668 <printint>
        i += 1;
 8ac:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ae:	8bca                	mv	s7,s2
      state = 0;
 8b0:	4981                	li	s3,0
        i += 1;
 8b2:	b56d                	j	75c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8b4:	008b8913          	add	s2,s7,8
 8b8:	4681                	li	a3,0
 8ba:	4629                	li	a2,10
 8bc:	000ba583          	lw	a1,0(s7)
 8c0:	855a                	mv	a0,s6
 8c2:	da7ff0ef          	jal	668 <printint>
        i += 2;
 8c6:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8c8:	8bca                	mv	s7,s2
      state = 0;
 8ca:	4981                	li	s3,0
        i += 2;
 8cc:	bd41                	j	75c <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 8ce:	008b8913          	add	s2,s7,8
 8d2:	4681                	li	a3,0
 8d4:	4641                	li	a2,16
 8d6:	000ba583          	lw	a1,0(s7)
 8da:	855a                	mv	a0,s6
 8dc:	d8dff0ef          	jal	668 <printint>
 8e0:	8bca                	mv	s7,s2
      state = 0;
 8e2:	4981                	li	s3,0
 8e4:	bda5                	j	75c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8e6:	008b8913          	add	s2,s7,8
 8ea:	4681                	li	a3,0
 8ec:	4641                	li	a2,16
 8ee:	000ba583          	lw	a1,0(s7)
 8f2:	855a                	mv	a0,s6
 8f4:	d75ff0ef          	jal	668 <printint>
        i += 1;
 8f8:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8fa:	8bca                	mv	s7,s2
      state = 0;
 8fc:	4981                	li	s3,0
        i += 1;
 8fe:	bdb9                	j	75c <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 900:	008b8d13          	add	s10,s7,8
 904:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 908:	03000593          	li	a1,48
 90c:	855a                	mv	a0,s6
 90e:	d3dff0ef          	jal	64a <putc>
  putc(fd, 'x');
 912:	07800593          	li	a1,120
 916:	855a                	mv	a0,s6
 918:	d33ff0ef          	jal	64a <putc>
 91c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 91e:	00000b97          	auipc	s7,0x0
 922:	24ab8b93          	add	s7,s7,586 # b68 <digits>
 926:	03c9d793          	srl	a5,s3,0x3c
 92a:	97de                	add	a5,a5,s7
 92c:	0007c583          	lbu	a1,0(a5)
 930:	855a                	mv	a0,s6
 932:	d19ff0ef          	jal	64a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 936:	0992                	sll	s3,s3,0x4
 938:	397d                	addw	s2,s2,-1
 93a:	fe0916e3          	bnez	s2,926 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 93e:	8bea                	mv	s7,s10
      state = 0;
 940:	4981                	li	s3,0
 942:	bd29                	j	75c <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 944:	008b8993          	add	s3,s7,8
 948:	000bb903          	ld	s2,0(s7)
 94c:	00090f63          	beqz	s2,96a <vprintf+0x25a>
        for(; *s; s++)
 950:	00094583          	lbu	a1,0(s2)
 954:	c195                	beqz	a1,978 <vprintf+0x268>
          putc(fd, *s);
 956:	855a                	mv	a0,s6
 958:	cf3ff0ef          	jal	64a <putc>
        for(; *s; s++)
 95c:	0905                	add	s2,s2,1
 95e:	00094583          	lbu	a1,0(s2)
 962:	f9f5                	bnez	a1,956 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 964:	8bce                	mv	s7,s3
      state = 0;
 966:	4981                	li	s3,0
 968:	bbd5                	j	75c <vprintf+0x4c>
          s = "(null)";
 96a:	00000917          	auipc	s2,0x0
 96e:	1f690913          	add	s2,s2,502 # b60 <malloc+0xe8>
        for(; *s; s++)
 972:	02800593          	li	a1,40
 976:	b7c5                	j	956 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 978:	8bce                	mv	s7,s3
      state = 0;
 97a:	4981                	li	s3,0
 97c:	b3c5                	j	75c <vprintf+0x4c>
    }
  }
}
 97e:	60e6                	ld	ra,88(sp)
 980:	6446                	ld	s0,80(sp)
 982:	64a6                	ld	s1,72(sp)
 984:	6906                	ld	s2,64(sp)
 986:	79e2                	ld	s3,56(sp)
 988:	7a42                	ld	s4,48(sp)
 98a:	7aa2                	ld	s5,40(sp)
 98c:	7b02                	ld	s6,32(sp)
 98e:	6be2                	ld	s7,24(sp)
 990:	6c42                	ld	s8,16(sp)
 992:	6ca2                	ld	s9,8(sp)
 994:	6d02                	ld	s10,0(sp)
 996:	6125                	add	sp,sp,96
 998:	8082                	ret

000000000000099a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 99a:	715d                	add	sp,sp,-80
 99c:	ec06                	sd	ra,24(sp)
 99e:	e822                	sd	s0,16(sp)
 9a0:	1000                	add	s0,sp,32
 9a2:	e010                	sd	a2,0(s0)
 9a4:	e414                	sd	a3,8(s0)
 9a6:	e818                	sd	a4,16(s0)
 9a8:	ec1c                	sd	a5,24(s0)
 9aa:	03043023          	sd	a6,32(s0)
 9ae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9b2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9b6:	8622                	mv	a2,s0
 9b8:	d59ff0ef          	jal	710 <vprintf>
}
 9bc:	60e2                	ld	ra,24(sp)
 9be:	6442                	ld	s0,16(sp)
 9c0:	6161                	add	sp,sp,80
 9c2:	8082                	ret

00000000000009c4 <printf>:

void
printf(const char *fmt, ...)
{
 9c4:	711d                	add	sp,sp,-96
 9c6:	ec06                	sd	ra,24(sp)
 9c8:	e822                	sd	s0,16(sp)
 9ca:	1000                	add	s0,sp,32
 9cc:	e40c                	sd	a1,8(s0)
 9ce:	e810                	sd	a2,16(s0)
 9d0:	ec14                	sd	a3,24(s0)
 9d2:	f018                	sd	a4,32(s0)
 9d4:	f41c                	sd	a5,40(s0)
 9d6:	03043823          	sd	a6,48(s0)
 9da:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9de:	00840613          	add	a2,s0,8
 9e2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9e6:	85aa                	mv	a1,a0
 9e8:	4505                	li	a0,1
 9ea:	d27ff0ef          	jal	710 <vprintf>
}
 9ee:	60e2                	ld	ra,24(sp)
 9f0:	6442                	ld	s0,16(sp)
 9f2:	6125                	add	sp,sp,96
 9f4:	8082                	ret

00000000000009f6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9f6:	1141                	add	sp,sp,-16
 9f8:	e422                	sd	s0,8(sp)
 9fa:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9fc:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a00:	00000797          	auipc	a5,0x0
 a04:	6107b783          	ld	a5,1552(a5) # 1010 <freep>
 a08:	a02d                	j	a32 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a0a:	4618                	lw	a4,8(a2)
 a0c:	9f2d                	addw	a4,a4,a1
 a0e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a12:	6398                	ld	a4,0(a5)
 a14:	6310                	ld	a2,0(a4)
 a16:	a83d                	j	a54 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a18:	ff852703          	lw	a4,-8(a0)
 a1c:	9f31                	addw	a4,a4,a2
 a1e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a20:	ff053683          	ld	a3,-16(a0)
 a24:	a091                	j	a68 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a26:	6398                	ld	a4,0(a5)
 a28:	00e7e463          	bltu	a5,a4,a30 <free+0x3a>
 a2c:	00e6ea63          	bltu	a3,a4,a40 <free+0x4a>
{
 a30:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a32:	fed7fae3          	bgeu	a5,a3,a26 <free+0x30>
 a36:	6398                	ld	a4,0(a5)
 a38:	00e6e463          	bltu	a3,a4,a40 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a3c:	fee7eae3          	bltu	a5,a4,a30 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a40:	ff852583          	lw	a1,-8(a0)
 a44:	6390                	ld	a2,0(a5)
 a46:	02059813          	sll	a6,a1,0x20
 a4a:	01c85713          	srl	a4,a6,0x1c
 a4e:	9736                	add	a4,a4,a3
 a50:	fae60de3          	beq	a2,a4,a0a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a54:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a58:	4790                	lw	a2,8(a5)
 a5a:	02061593          	sll	a1,a2,0x20
 a5e:	01c5d713          	srl	a4,a1,0x1c
 a62:	973e                	add	a4,a4,a5
 a64:	fae68ae3          	beq	a3,a4,a18 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a68:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a6a:	00000717          	auipc	a4,0x0
 a6e:	5af73323          	sd	a5,1446(a4) # 1010 <freep>
}
 a72:	6422                	ld	s0,8(sp)
 a74:	0141                	add	sp,sp,16
 a76:	8082                	ret

0000000000000a78 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a78:	7139                	add	sp,sp,-64
 a7a:	fc06                	sd	ra,56(sp)
 a7c:	f822                	sd	s0,48(sp)
 a7e:	f426                	sd	s1,40(sp)
 a80:	f04a                	sd	s2,32(sp)
 a82:	ec4e                	sd	s3,24(sp)
 a84:	e852                	sd	s4,16(sp)
 a86:	e456                	sd	s5,8(sp)
 a88:	e05a                	sd	s6,0(sp)
 a8a:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a8c:	02051493          	sll	s1,a0,0x20
 a90:	9081                	srl	s1,s1,0x20
 a92:	04bd                	add	s1,s1,15
 a94:	8091                	srl	s1,s1,0x4
 a96:	0014899b          	addw	s3,s1,1
 a9a:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 a9c:	00000517          	auipc	a0,0x0
 aa0:	57453503          	ld	a0,1396(a0) # 1010 <freep>
 aa4:	c515                	beqz	a0,ad0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa8:	4798                	lw	a4,8(a5)
 aaa:	02977f63          	bgeu	a4,s1,ae8 <malloc+0x70>
  if(nu < 4096)
 aae:	8a4e                	mv	s4,s3
 ab0:	0009871b          	sext.w	a4,s3
 ab4:	6685                	lui	a3,0x1
 ab6:	00d77363          	bgeu	a4,a3,abc <malloc+0x44>
 aba:	6a05                	lui	s4,0x1
 abc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ac0:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ac4:	00000917          	auipc	s2,0x0
 ac8:	54c90913          	add	s2,s2,1356 # 1010 <freep>
  if(p == (char*)-1)
 acc:	5afd                	li	s5,-1
 ace:	a885                	j	b3e <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 ad0:	00000797          	auipc	a5,0x0
 ad4:	55078793          	add	a5,a5,1360 # 1020 <base>
 ad8:	00000717          	auipc	a4,0x0
 adc:	52f73c23          	sd	a5,1336(a4) # 1010 <freep>
 ae0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ae2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ae6:	b7e1                	j	aae <malloc+0x36>
      if(p->s.size == nunits)
 ae8:	02e48c63          	beq	s1,a4,b20 <malloc+0xa8>
        p->s.size -= nunits;
 aec:	4137073b          	subw	a4,a4,s3
 af0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 af2:	02071693          	sll	a3,a4,0x20
 af6:	01c6d713          	srl	a4,a3,0x1c
 afa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 afc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b00:	00000717          	auipc	a4,0x0
 b04:	50a73823          	sd	a0,1296(a4) # 1010 <freep>
      return (void*)(p + 1);
 b08:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b0c:	70e2                	ld	ra,56(sp)
 b0e:	7442                	ld	s0,48(sp)
 b10:	74a2                	ld	s1,40(sp)
 b12:	7902                	ld	s2,32(sp)
 b14:	69e2                	ld	s3,24(sp)
 b16:	6a42                	ld	s4,16(sp)
 b18:	6aa2                	ld	s5,8(sp)
 b1a:	6b02                	ld	s6,0(sp)
 b1c:	6121                	add	sp,sp,64
 b1e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b20:	6398                	ld	a4,0(a5)
 b22:	e118                	sd	a4,0(a0)
 b24:	bff1                	j	b00 <malloc+0x88>
  hp->s.size = nu;
 b26:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b2a:	0541                	add	a0,a0,16
 b2c:	ecbff0ef          	jal	9f6 <free>
  return freep;
 b30:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b34:	dd61                	beqz	a0,b0c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b36:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b38:	4798                	lw	a4,8(a5)
 b3a:	fa9777e3          	bgeu	a4,s1,ae8 <malloc+0x70>
    if(p == freep)
 b3e:	00093703          	ld	a4,0(s2)
 b42:	853e                	mv	a0,a5
 b44:	fef719e3          	bne	a4,a5,b36 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 b48:	8552                	mv	a0,s4
 b4a:	ab1ff0ef          	jal	5fa <sbrk>
  if(p == (char*)-1)
 b4e:	fd551ce3          	bne	a0,s5,b26 <malloc+0xae>
        return 0;
 b52:	4501                	li	a0,0
 b54:	bf65                	j	b0c <malloc+0x94>
