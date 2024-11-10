
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


int main(){
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
 104:	3e800d13          	li	s10,1000
        
        //gerar arestas aleatórias
        int u, v;
        for (int j = 0; j < num_edges; j++){
            generate_random_edge(matrix, num_vertices, &u, &v);
            matrix[u][v] = 1;
 108:	4a85                	li	s5,1
 10a:	a8ad                	j	184 <main+0xba>
        int esq = 0;
        int dir = 0;
        int atual;
        while (esq <= dir) {
            atual = fila[esq];
            for (int j = 0; j < num_vertices; j++){
 10c:	0785                	add	a5,a5,1
 10e:	0691                	add	a3,a3,4
 110:	0007871b          	sext.w	a4,a5
 114:	02977263          	bgeu	a4,s1,138 <main+0x6e>
                if (matrix[atual][j] && !visitado[j]){
 118:	6198                	ld	a4,0(a1)
 11a:	00279613          	sll	a2,a5,0x2
 11e:	9732                	add	a4,a4,a2
 120:	4318                	lw	a4,0(a4)
 122:	d76d                	beqz	a4,10c <main+0x42>
 124:	4298                	lw	a4,0(a3)
 126:	f37d                	bnez	a4,10c <main+0x42>
                    visitado[j] = 1;
 128:	0156a023          	sw	s5,0(a3)
                    distancia[j] = distancia[atual] + 1;
                    dir++;
 12c:	2805                	addw	a6,a6,1
                    fila[dir] = j;
 12e:	00281713          	sll	a4,a6,0x2
 132:	972a                	add	a4,a4,a0
 134:	c31c                	sw	a5,0(a4)
 136:	bfd9                	j	10c <main+0x42>
                }
            }
            esq++;
 138:	2885                	addw	a7,a7,1
        while (esq <= dir) {
 13a:	0311                	add	t1,t1,4
 13c:	01184b63          	blt	a6,a7,152 <main+0x88>
            atual = fila[esq];
 140:	00032583          	lw	a1,0(t1)
            for (int j = 0; j < num_vertices; j++){
 144:	d8f5                	beqz	s1,138 <main+0x6e>
                if (matrix[atual][j] && !visitado[j]){
 146:	058e                	sll	a1,a1,0x3
 148:	95d2                	add	a1,a1,s4
 14a:	c7040693          	add	a3,s0,-912
 14e:	4781                	li	a5,0
 150:	b7e1                	j	118 <main+0x4e>
        }

        //libera a matrix
        free(fila);
 152:	06b000ef          	jal	9bc <free>
        for (int i = 0; i < num_vertices; i++) {
 156:	c08d                	beqz	s1,178 <main+0xae>
 158:	84d2                	mv	s1,s4
 15a:	063b091b          	addw	s2,s6,99
 15e:	02091793          	sll	a5,s2,0x20
 162:	01d7d913          	srl	s2,a5,0x1d
 166:	008a0793          	add	a5,s4,8
 16a:	993e                	add	s2,s2,a5
            free(matrix[i]);  
 16c:	6088                	ld	a0,0(s1)
 16e:	04f000ef          	jal	9bc <free>
        for (int i = 0; i < num_vertices; i++) {
 172:	04a1                	add	s1,s1,8
 174:	ff249ce3          	bne	s1,s2,16c <main+0xa2>
        }
        free(matrix);
 178:	8552                	mv	a0,s4
 17a:	043000ef          	jal	9bc <free>
    for (int i = 0; i < max_iter; i++){
 17e:	3d7d                	addw	s10,s10,-1
 180:	100d0263          	beqz	s10,284 <main+0x1ba>
        uint num_vertices = (rand() % 101) + 100;
 184:	ed5ff0ef          	jal	58 <rand>
 188:	06500793          	li	a5,101
 18c:	02f56b3b          	remw	s6,a0,a5
 190:	064b0b9b          	addw	s7,s6,100
 194:	000b8c9b          	sext.w	s9,s7
 198:	84e6                	mv	s1,s9
        int num_edges = (rand() % 351) + 50;
 19a:	ebfff0ef          	jal	58 <rand>
 19e:	15f00793          	li	a5,351
 1a2:	02f567bb          	remw	a5,a0,a5
 1a6:	c4f42e23          	sw	a5,-932(s0)
 1aa:	00078d9b          	sext.w	s11,a5
        int **matrix = malloc(num_vertices * sizeof(int *));
 1ae:	003b951b          	sllw	a0,s7,0x3
 1b2:	08d000ef          	jal	a3e <malloc>
 1b6:	8a2a                	mv	s4,a0
        for (int j = 0; j < num_vertices; j++){
 1b8:	040c8263          	beqz	s9,1fc <main+0x132>
            matrix[j] = malloc(num_vertices * sizeof(int));
 1bc:	002b9b9b          	sllw	s7,s7,0x2
 1c0:	89aa                	mv	s3,a0
 1c2:	063b079b          	addw	a5,s6,99
 1c6:	1782                	sll	a5,a5,0x20
 1c8:	9381                	srl	a5,a5,0x20
 1ca:	00850c13          	add	s8,a0,8
 1ce:	00379713          	sll	a4,a5,0x3
 1d2:	9c3a                	add	s8,s8,a4
 1d4:	0785                	add	a5,a5,1
 1d6:	00279913          	sll	s2,a5,0x2
 1da:	855e                	mv	a0,s7
 1dc:	063000ef          	jal	a3e <malloc>
 1e0:	86ce                	mv	a3,s3
 1e2:	00a9b023          	sd	a0,0(s3)
 1e6:	4781                	li	a5,0
                matrix[j][k] = 0;
 1e8:	6298                	ld	a4,0(a3)
 1ea:	973e                	add	a4,a4,a5
 1ec:	00072023          	sw	zero,0(a4) # ffffffff80000000 <base+0xffffffff7fffefe0>
            for (int k = 0; k < num_vertices; k++){
 1f0:	0791                	add	a5,a5,4
 1f2:	ff279be3          	bne	a5,s2,1e8 <main+0x11e>
        for (int j = 0; j < num_vertices; j++){
 1f6:	09a1                	add	s3,s3,8
 1f8:	ff8991e3          	bne	s3,s8,1da <main+0x110>
        for (int j = 0; j < num_edges; j++){
 1fc:	fcf00793          	li	a5,-49
 200:	02fdcd63          	blt	s11,a5,23a <main+0x170>
 204:	c5c42783          	lw	a5,-932(s0)
 208:	0327899b          	addw	s3,a5,50
 20c:	4901                	li	s2,0
            generate_random_edge(matrix, num_vertices, &u, &v);
 20e:	c6c40693          	add	a3,s0,-916
 212:	c6840613          	add	a2,s0,-920
 216:	85e6                	mv	a1,s9
 218:	8552                	mv	a0,s4
 21a:	e5bff0ef          	jal	74 <generate_random_edge>
            matrix[u][v] = 1;
 21e:	c6842783          	lw	a5,-920(s0)
 222:	078e                	sll	a5,a5,0x3
 224:	97d2                	add	a5,a5,s4
 226:	c6c42703          	lw	a4,-916(s0)
 22a:	639c                	ld	a5,0(a5)
 22c:	070a                	sll	a4,a4,0x2
 22e:	97ba                	add	a5,a5,a4
 230:	0157a023          	sw	s5,0(a5)
        for (int j = 0; j < num_edges; j++){
 234:	2905                	addw	s2,s2,1
 236:	fd391ce3          	bne	s2,s3,20e <main+0x144>
            u = rand() % num_vertices;
 23a:	e1fff0ef          	jal	58 <rand>
 23e:	0295793b          	remuw	s2,a0,s1
 242:	0009099b          	sext.w	s3,s2
 246:	c7242423          	sw	s2,-920(s0)
            v = rand() % num_vertices;
 24a:	e0fff0ef          	jal	58 <rand>
 24e:	0295753b          	remuw	a0,a0,s1
 252:	0005079b          	sext.w	a5,a0
 256:	c6a42623          	sw	a0,-916(s0)
        } while (u == v);
 25a:	fef980e3          	beq	s3,a5,23a <main+0x170>
        int *fila = malloc(tam * sizeof(int));
 25e:	64000513          	li	a0,1600
 262:	7dc000ef          	jal	a3e <malloc>
        for (int i = 0; i < 200; i++){
 266:	f9040713          	add	a4,s0,-112
        int *fila = malloc(tam * sizeof(int));
 26a:	c7040793          	add	a5,s0,-912
            visitado[i] = 0;
 26e:	0007a023          	sw	zero,0(a5)
        for (int i = 0; i < 200; i++){
 272:	0791                	add	a5,a5,4
 274:	fef71de3          	bne	a4,a5,26e <main+0x1a4>
        fila[0] = u;
 278:	01252023          	sw	s2,0(a0)
        while (esq <= dir) {
 27c:	832a                	mv	t1,a0
        int dir = 0;
 27e:	4801                	li	a6,0
        int esq = 0;
 280:	4881                	li	a7,0
 282:	bd7d                	j	140 <main+0x76>

    }
    int pid = getpid();
 284:	34c000ef          	jal	5d0 <getpid>
 288:	892a                	mv	s2,a0
    // int runtime = tempo_total(pid);
    // printf("Tempo de execução do processo %d: %d\n", pid, runtime);

    int i = increment_metric(pid, 27, MODE_EFICIENCIA);
 28a:	4629                	li	a2,10
 28c:	45ed                	li	a1,27
 28e:	37a000ef          	jal	608 <increment_metric>
 292:	84aa                	mv	s1,a0
    int a = get_eficiencia(pid);
 294:	854a                	mv	a0,s2
 296:	362000ef          	jal	5f8 <get_eficiencia>
 29a:	862a                	mv	a2,a0

    printf("%d Eficiencia %d\n", i, a);
 29c:	85a6                	mv	a1,s1
 29e:	00001517          	auipc	a0,0x1
 2a2:	88250513          	add	a0,a0,-1918 # b20 <malloc+0xe2>
 2a6:	6e4000ef          	jal	98a <printf>
    return 0;
 2aa:	4501                	li	a0,0
 2ac:	3a813083          	ld	ra,936(sp)
 2b0:	3a013403          	ld	s0,928(sp)
 2b4:	39813483          	ld	s1,920(sp)
 2b8:	39013903          	ld	s2,912(sp)
 2bc:	38813983          	ld	s3,904(sp)
 2c0:	38013a03          	ld	s4,896(sp)
 2c4:	37813a83          	ld	s5,888(sp)
 2c8:	37013b03          	ld	s6,880(sp)
 2cc:	36813b83          	ld	s7,872(sp)
 2d0:	36013c03          	ld	s8,864(sp)
 2d4:	35813c83          	ld	s9,856(sp)
 2d8:	35013d03          	ld	s10,848(sp)
 2dc:	34813d83          	ld	s11,840(sp)
 2e0:	3b010113          	add	sp,sp,944
 2e4:	8082                	ret

00000000000002e6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 2e6:	1141                	add	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	add	s0,sp,16
  extern int main();
  main();
 2ee:	dddff0ef          	jal	ca <main>
  exit(0);
 2f2:	4501                	li	a0,0
 2f4:	25c000ef          	jal	550 <exit>

00000000000002f8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2f8:	1141                	add	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2fe:	87aa                	mv	a5,a0
 300:	0585                	add	a1,a1,1
 302:	0785                	add	a5,a5,1
 304:	fff5c703          	lbu	a4,-1(a1)
 308:	fee78fa3          	sb	a4,-1(a5)
 30c:	fb75                	bnez	a4,300 <strcpy+0x8>
    ;
  return os;
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	add	sp,sp,16
 312:	8082                	ret

0000000000000314 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 314:	1141                	add	sp,sp,-16
 316:	e422                	sd	s0,8(sp)
 318:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 31a:	00054783          	lbu	a5,0(a0)
 31e:	cb91                	beqz	a5,332 <strcmp+0x1e>
 320:	0005c703          	lbu	a4,0(a1)
 324:	00f71763          	bne	a4,a5,332 <strcmp+0x1e>
    p++, q++;
 328:	0505                	add	a0,a0,1
 32a:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 32c:	00054783          	lbu	a5,0(a0)
 330:	fbe5                	bnez	a5,320 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 332:	0005c503          	lbu	a0,0(a1)
}
 336:	40a7853b          	subw	a0,a5,a0
 33a:	6422                	ld	s0,8(sp)
 33c:	0141                	add	sp,sp,16
 33e:	8082                	ret

0000000000000340 <strlen>:

uint
strlen(const char *s)
{
 340:	1141                	add	sp,sp,-16
 342:	e422                	sd	s0,8(sp)
 344:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 346:	00054783          	lbu	a5,0(a0)
 34a:	cf91                	beqz	a5,366 <strlen+0x26>
 34c:	0505                	add	a0,a0,1
 34e:	87aa                	mv	a5,a0
 350:	86be                	mv	a3,a5
 352:	0785                	add	a5,a5,1
 354:	fff7c703          	lbu	a4,-1(a5)
 358:	ff65                	bnez	a4,350 <strlen+0x10>
 35a:	40a6853b          	subw	a0,a3,a0
 35e:	2505                	addw	a0,a0,1
    ;
  return n;
}
 360:	6422                	ld	s0,8(sp)
 362:	0141                	add	sp,sp,16
 364:	8082                	ret
  for(n = 0; s[n]; n++)
 366:	4501                	li	a0,0
 368:	bfe5                	j	360 <strlen+0x20>

000000000000036a <memset>:

void*
memset(void *dst, int c, uint n)
{
 36a:	1141                	add	sp,sp,-16
 36c:	e422                	sd	s0,8(sp)
 36e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 370:	ca19                	beqz	a2,386 <memset+0x1c>
 372:	87aa                	mv	a5,a0
 374:	1602                	sll	a2,a2,0x20
 376:	9201                	srl	a2,a2,0x20
 378:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 37c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 380:	0785                	add	a5,a5,1
 382:	fee79de3          	bne	a5,a4,37c <memset+0x12>
  }
  return dst;
}
 386:	6422                	ld	s0,8(sp)
 388:	0141                	add	sp,sp,16
 38a:	8082                	ret

000000000000038c <strchr>:

char*
strchr(const char *s, char c)
{
 38c:	1141                	add	sp,sp,-16
 38e:	e422                	sd	s0,8(sp)
 390:	0800                	add	s0,sp,16
  for(; *s; s++)
 392:	00054783          	lbu	a5,0(a0)
 396:	cb99                	beqz	a5,3ac <strchr+0x20>
    if(*s == c)
 398:	00f58763          	beq	a1,a5,3a6 <strchr+0x1a>
  for(; *s; s++)
 39c:	0505                	add	a0,a0,1
 39e:	00054783          	lbu	a5,0(a0)
 3a2:	fbfd                	bnez	a5,398 <strchr+0xc>
      return (char*)s;
  return 0;
 3a4:	4501                	li	a0,0
}
 3a6:	6422                	ld	s0,8(sp)
 3a8:	0141                	add	sp,sp,16
 3aa:	8082                	ret
  return 0;
 3ac:	4501                	li	a0,0
 3ae:	bfe5                	j	3a6 <strchr+0x1a>

00000000000003b0 <gets>:

char*
gets(char *buf, int max)
{
 3b0:	711d                	add	sp,sp,-96
 3b2:	ec86                	sd	ra,88(sp)
 3b4:	e8a2                	sd	s0,80(sp)
 3b6:	e4a6                	sd	s1,72(sp)
 3b8:	e0ca                	sd	s2,64(sp)
 3ba:	fc4e                	sd	s3,56(sp)
 3bc:	f852                	sd	s4,48(sp)
 3be:	f456                	sd	s5,40(sp)
 3c0:	f05a                	sd	s6,32(sp)
 3c2:	ec5e                	sd	s7,24(sp)
 3c4:	1080                	add	s0,sp,96
 3c6:	8baa                	mv	s7,a0
 3c8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ca:	892a                	mv	s2,a0
 3cc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3ce:	4aa9                	li	s5,10
 3d0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3d2:	89a6                	mv	s3,s1
 3d4:	2485                	addw	s1,s1,1
 3d6:	0344d663          	bge	s1,s4,402 <gets+0x52>
    cc = read(0, &c, 1);
 3da:	4605                	li	a2,1
 3dc:	faf40593          	add	a1,s0,-81
 3e0:	4501                	li	a0,0
 3e2:	186000ef          	jal	568 <read>
    if(cc < 1)
 3e6:	00a05e63          	blez	a0,402 <gets+0x52>
    buf[i++] = c;
 3ea:	faf44783          	lbu	a5,-81(s0)
 3ee:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3f2:	01578763          	beq	a5,s5,400 <gets+0x50>
 3f6:	0905                	add	s2,s2,1
 3f8:	fd679de3          	bne	a5,s6,3d2 <gets+0x22>
  for(i=0; i+1 < max; ){
 3fc:	89a6                	mv	s3,s1
 3fe:	a011                	j	402 <gets+0x52>
 400:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 402:	99de                	add	s3,s3,s7
 404:	00098023          	sb	zero,0(s3)
  return buf;
}
 408:	855e                	mv	a0,s7
 40a:	60e6                	ld	ra,88(sp)
 40c:	6446                	ld	s0,80(sp)
 40e:	64a6                	ld	s1,72(sp)
 410:	6906                	ld	s2,64(sp)
 412:	79e2                	ld	s3,56(sp)
 414:	7a42                	ld	s4,48(sp)
 416:	7aa2                	ld	s5,40(sp)
 418:	7b02                	ld	s6,32(sp)
 41a:	6be2                	ld	s7,24(sp)
 41c:	6125                	add	sp,sp,96
 41e:	8082                	ret

0000000000000420 <stat>:

int
stat(const char *n, struct stat *st)
{
 420:	1101                	add	sp,sp,-32
 422:	ec06                	sd	ra,24(sp)
 424:	e822                	sd	s0,16(sp)
 426:	e426                	sd	s1,8(sp)
 428:	e04a                	sd	s2,0(sp)
 42a:	1000                	add	s0,sp,32
 42c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 42e:	4581                	li	a1,0
 430:	160000ef          	jal	590 <open>
  if(fd < 0)
 434:	02054163          	bltz	a0,456 <stat+0x36>
 438:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 43a:	85ca                	mv	a1,s2
 43c:	16c000ef          	jal	5a8 <fstat>
 440:	892a                	mv	s2,a0
  close(fd);
 442:	8526                	mv	a0,s1
 444:	134000ef          	jal	578 <close>
  return r;
}
 448:	854a                	mv	a0,s2
 44a:	60e2                	ld	ra,24(sp)
 44c:	6442                	ld	s0,16(sp)
 44e:	64a2                	ld	s1,8(sp)
 450:	6902                	ld	s2,0(sp)
 452:	6105                	add	sp,sp,32
 454:	8082                	ret
    return -1;
 456:	597d                	li	s2,-1
 458:	bfc5                	j	448 <stat+0x28>

000000000000045a <atoi>:

int
atoi(const char *s)
{
 45a:	1141                	add	sp,sp,-16
 45c:	e422                	sd	s0,8(sp)
 45e:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 460:	00054683          	lbu	a3,0(a0)
 464:	fd06879b          	addw	a5,a3,-48
 468:	0ff7f793          	zext.b	a5,a5
 46c:	4625                	li	a2,9
 46e:	02f66863          	bltu	a2,a5,49e <atoi+0x44>
 472:	872a                	mv	a4,a0
  n = 0;
 474:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 476:	0705                	add	a4,a4,1
 478:	0025179b          	sllw	a5,a0,0x2
 47c:	9fa9                	addw	a5,a5,a0
 47e:	0017979b          	sllw	a5,a5,0x1
 482:	9fb5                	addw	a5,a5,a3
 484:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 488:	00074683          	lbu	a3,0(a4)
 48c:	fd06879b          	addw	a5,a3,-48
 490:	0ff7f793          	zext.b	a5,a5
 494:	fef671e3          	bgeu	a2,a5,476 <atoi+0x1c>
  return n;
}
 498:	6422                	ld	s0,8(sp)
 49a:	0141                	add	sp,sp,16
 49c:	8082                	ret
  n = 0;
 49e:	4501                	li	a0,0
 4a0:	bfe5                	j	498 <atoi+0x3e>

00000000000004a2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4a2:	1141                	add	sp,sp,-16
 4a4:	e422                	sd	s0,8(sp)
 4a6:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4a8:	02b57463          	bgeu	a0,a1,4d0 <memmove+0x2e>
    while(n-- > 0)
 4ac:	00c05f63          	blez	a2,4ca <memmove+0x28>
 4b0:	1602                	sll	a2,a2,0x20
 4b2:	9201                	srl	a2,a2,0x20
 4b4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4b8:	872a                	mv	a4,a0
      *dst++ = *src++;
 4ba:	0585                	add	a1,a1,1
 4bc:	0705                	add	a4,a4,1
 4be:	fff5c683          	lbu	a3,-1(a1)
 4c2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4c6:	fee79ae3          	bne	a5,a4,4ba <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4ca:	6422                	ld	s0,8(sp)
 4cc:	0141                	add	sp,sp,16
 4ce:	8082                	ret
    dst += n;
 4d0:	00c50733          	add	a4,a0,a2
    src += n;
 4d4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4d6:	fec05ae3          	blez	a2,4ca <memmove+0x28>
 4da:	fff6079b          	addw	a5,a2,-1
 4de:	1782                	sll	a5,a5,0x20
 4e0:	9381                	srl	a5,a5,0x20
 4e2:	fff7c793          	not	a5,a5
 4e6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4e8:	15fd                	add	a1,a1,-1
 4ea:	177d                	add	a4,a4,-1
 4ec:	0005c683          	lbu	a3,0(a1)
 4f0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4f4:	fee79ae3          	bne	a5,a4,4e8 <memmove+0x46>
 4f8:	bfc9                	j	4ca <memmove+0x28>

00000000000004fa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4fa:	1141                	add	sp,sp,-16
 4fc:	e422                	sd	s0,8(sp)
 4fe:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 500:	ca05                	beqz	a2,530 <memcmp+0x36>
 502:	fff6069b          	addw	a3,a2,-1
 506:	1682                	sll	a3,a3,0x20
 508:	9281                	srl	a3,a3,0x20
 50a:	0685                	add	a3,a3,1
 50c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 50e:	00054783          	lbu	a5,0(a0)
 512:	0005c703          	lbu	a4,0(a1)
 516:	00e79863          	bne	a5,a4,526 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 51a:	0505                	add	a0,a0,1
    p2++;
 51c:	0585                	add	a1,a1,1
  while (n-- > 0) {
 51e:	fed518e3          	bne	a0,a3,50e <memcmp+0x14>
  }
  return 0;
 522:	4501                	li	a0,0
 524:	a019                	j	52a <memcmp+0x30>
      return *p1 - *p2;
 526:	40e7853b          	subw	a0,a5,a4
}
 52a:	6422                	ld	s0,8(sp)
 52c:	0141                	add	sp,sp,16
 52e:	8082                	ret
  return 0;
 530:	4501                	li	a0,0
 532:	bfe5                	j	52a <memcmp+0x30>

0000000000000534 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 534:	1141                	add	sp,sp,-16
 536:	e406                	sd	ra,8(sp)
 538:	e022                	sd	s0,0(sp)
 53a:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 53c:	f67ff0ef          	jal	4a2 <memmove>
}
 540:	60a2                	ld	ra,8(sp)
 542:	6402                	ld	s0,0(sp)
 544:	0141                	add	sp,sp,16
 546:	8082                	ret

0000000000000548 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 548:	4885                	li	a7,1
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <exit>:
.global exit
exit:
 li a7, SYS_exit
 550:	4889                	li	a7,2
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <wait>:
.global wait
wait:
 li a7, SYS_wait
 558:	488d                	li	a7,3
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 560:	4891                	li	a7,4
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <read>:
.global read
read:
 li a7, SYS_read
 568:	4895                	li	a7,5
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <write>:
.global write
write:
 li a7, SYS_write
 570:	48c1                	li	a7,16
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <close>:
.global close
close:
 li a7, SYS_close
 578:	48d5                	li	a7,21
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <kill>:
.global kill
kill:
 li a7, SYS_kill
 580:	4899                	li	a7,6
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <exec>:
.global exec
exec:
 li a7, SYS_exec
 588:	489d                	li	a7,7
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <open>:
.global open
open:
 li a7, SYS_open
 590:	48bd                	li	a7,15
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 598:	48c5                	li	a7,17
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5a0:	48c9                	li	a7,18
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5a8:	48a1                	li	a7,8
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <link>:
.global link
link:
 li a7, SYS_link
 5b0:	48cd                	li	a7,19
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5b8:	48d1                	li	a7,20
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5c0:	48a5                	li	a7,9
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5c8:	48a9                	li	a7,10
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5d0:	48ad                	li	a7,11
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5d8:	48b1                	li	a7,12
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5e0:	48b5                	li	a7,13
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5e8:	48b9                	li	a7,14
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 5f0:	48d9                	li	a7,22
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 5f8:	48e1                	li	a7,24
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 600:	48dd                	li	a7,23
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 608:	48e5                	li	a7,25
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 610:	1101                	add	sp,sp,-32
 612:	ec06                	sd	ra,24(sp)
 614:	e822                	sd	s0,16(sp)
 616:	1000                	add	s0,sp,32
 618:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 61c:	4605                	li	a2,1
 61e:	fef40593          	add	a1,s0,-17
 622:	f4fff0ef          	jal	570 <write>
}
 626:	60e2                	ld	ra,24(sp)
 628:	6442                	ld	s0,16(sp)
 62a:	6105                	add	sp,sp,32
 62c:	8082                	ret

000000000000062e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 62e:	7139                	add	sp,sp,-64
 630:	fc06                	sd	ra,56(sp)
 632:	f822                	sd	s0,48(sp)
 634:	f426                	sd	s1,40(sp)
 636:	f04a                	sd	s2,32(sp)
 638:	ec4e                	sd	s3,24(sp)
 63a:	0080                	add	s0,sp,64
 63c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 63e:	c299                	beqz	a3,644 <printint+0x16>
 640:	0805c763          	bltz	a1,6ce <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 644:	2581                	sext.w	a1,a1
  neg = 0;
 646:	4881                	li	a7,0
 648:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 64c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 64e:	2601                	sext.w	a2,a2
 650:	00000517          	auipc	a0,0x0
 654:	4f050513          	add	a0,a0,1264 # b40 <digits>
 658:	883a                	mv	a6,a4
 65a:	2705                	addw	a4,a4,1
 65c:	02c5f7bb          	remuw	a5,a1,a2
 660:	1782                	sll	a5,a5,0x20
 662:	9381                	srl	a5,a5,0x20
 664:	97aa                	add	a5,a5,a0
 666:	0007c783          	lbu	a5,0(a5)
 66a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 66e:	0005879b          	sext.w	a5,a1
 672:	02c5d5bb          	divuw	a1,a1,a2
 676:	0685                	add	a3,a3,1
 678:	fec7f0e3          	bgeu	a5,a2,658 <printint+0x2a>
  if(neg)
 67c:	00088c63          	beqz	a7,694 <printint+0x66>
    buf[i++] = '-';
 680:	fd070793          	add	a5,a4,-48
 684:	00878733          	add	a4,a5,s0
 688:	02d00793          	li	a5,45
 68c:	fef70823          	sb	a5,-16(a4)
 690:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 694:	02e05663          	blez	a4,6c0 <printint+0x92>
 698:	fc040793          	add	a5,s0,-64
 69c:	00e78933          	add	s2,a5,a4
 6a0:	fff78993          	add	s3,a5,-1
 6a4:	99ba                	add	s3,s3,a4
 6a6:	377d                	addw	a4,a4,-1
 6a8:	1702                	sll	a4,a4,0x20
 6aa:	9301                	srl	a4,a4,0x20
 6ac:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6b0:	fff94583          	lbu	a1,-1(s2)
 6b4:	8526                	mv	a0,s1
 6b6:	f5bff0ef          	jal	610 <putc>
  while(--i >= 0)
 6ba:	197d                	add	s2,s2,-1
 6bc:	ff391ae3          	bne	s2,s3,6b0 <printint+0x82>
}
 6c0:	70e2                	ld	ra,56(sp)
 6c2:	7442                	ld	s0,48(sp)
 6c4:	74a2                	ld	s1,40(sp)
 6c6:	7902                	ld	s2,32(sp)
 6c8:	69e2                	ld	s3,24(sp)
 6ca:	6121                	add	sp,sp,64
 6cc:	8082                	ret
    x = -xx;
 6ce:	40b005bb          	negw	a1,a1
    neg = 1;
 6d2:	4885                	li	a7,1
    x = -xx;
 6d4:	bf95                	j	648 <printint+0x1a>

00000000000006d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6d6:	711d                	add	sp,sp,-96
 6d8:	ec86                	sd	ra,88(sp)
 6da:	e8a2                	sd	s0,80(sp)
 6dc:	e4a6                	sd	s1,72(sp)
 6de:	e0ca                	sd	s2,64(sp)
 6e0:	fc4e                	sd	s3,56(sp)
 6e2:	f852                	sd	s4,48(sp)
 6e4:	f456                	sd	s5,40(sp)
 6e6:	f05a                	sd	s6,32(sp)
 6e8:	ec5e                	sd	s7,24(sp)
 6ea:	e862                	sd	s8,16(sp)
 6ec:	e466                	sd	s9,8(sp)
 6ee:	e06a                	sd	s10,0(sp)
 6f0:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6f2:	0005c903          	lbu	s2,0(a1)
 6f6:	24090763          	beqz	s2,944 <vprintf+0x26e>
 6fa:	8b2a                	mv	s6,a0
 6fc:	8a2e                	mv	s4,a1
 6fe:	8bb2                	mv	s7,a2
  state = 0;
 700:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 702:	4481                	li	s1,0
 704:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 706:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 70a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 70e:	06c00c93          	li	s9,108
 712:	a005                	j	732 <vprintf+0x5c>
        putc(fd, c0);
 714:	85ca                	mv	a1,s2
 716:	855a                	mv	a0,s6
 718:	ef9ff0ef          	jal	610 <putc>
 71c:	a019                	j	722 <vprintf+0x4c>
    } else if(state == '%'){
 71e:	03598263          	beq	s3,s5,742 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 722:	2485                	addw	s1,s1,1
 724:	8726                	mv	a4,s1
 726:	009a07b3          	add	a5,s4,s1
 72a:	0007c903          	lbu	s2,0(a5)
 72e:	20090b63          	beqz	s2,944 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 732:	0009079b          	sext.w	a5,s2
    if(state == 0){
 736:	fe0994e3          	bnez	s3,71e <vprintf+0x48>
      if(c0 == '%'){
 73a:	fd579de3          	bne	a5,s5,714 <vprintf+0x3e>
        state = '%';
 73e:	89be                	mv	s3,a5
 740:	b7cd                	j	722 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 742:	c7c9                	beqz	a5,7cc <vprintf+0xf6>
 744:	00ea06b3          	add	a3,s4,a4
 748:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 74c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 74e:	c681                	beqz	a3,756 <vprintf+0x80>
 750:	9752                	add	a4,a4,s4
 752:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 756:	03878f63          	beq	a5,s8,794 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 75a:	05978963          	beq	a5,s9,7ac <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 75e:	07500713          	li	a4,117
 762:	0ee78363          	beq	a5,a4,848 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 766:	07800713          	li	a4,120
 76a:	12e78563          	beq	a5,a4,894 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 76e:	07000713          	li	a4,112
 772:	14e78a63          	beq	a5,a4,8c6 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 776:	07300713          	li	a4,115
 77a:	18e78863          	beq	a5,a4,90a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 77e:	02500713          	li	a4,37
 782:	04e79563          	bne	a5,a4,7cc <vprintf+0xf6>
        putc(fd, '%');
 786:	02500593          	li	a1,37
 78a:	855a                	mv	a0,s6
 78c:	e85ff0ef          	jal	610 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 790:	4981                	li	s3,0
 792:	bf41                	j	722 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 794:	008b8913          	add	s2,s7,8
 798:	4685                	li	a3,1
 79a:	4629                	li	a2,10
 79c:	000ba583          	lw	a1,0(s7)
 7a0:	855a                	mv	a0,s6
 7a2:	e8dff0ef          	jal	62e <printint>
 7a6:	8bca                	mv	s7,s2
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	bfa5                	j	722 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 7ac:	06400793          	li	a5,100
 7b0:	02f68963          	beq	a3,a5,7e2 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7b4:	06c00793          	li	a5,108
 7b8:	04f68263          	beq	a3,a5,7fc <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 7bc:	07500793          	li	a5,117
 7c0:	0af68063          	beq	a3,a5,860 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 7c4:	07800793          	li	a5,120
 7c8:	0ef68263          	beq	a3,a5,8ac <vprintf+0x1d6>
        putc(fd, '%');
 7cc:	02500593          	li	a1,37
 7d0:	855a                	mv	a0,s6
 7d2:	e3fff0ef          	jal	610 <putc>
        putc(fd, c0);
 7d6:	85ca                	mv	a1,s2
 7d8:	855a                	mv	a0,s6
 7da:	e37ff0ef          	jal	610 <putc>
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b789                	j	722 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7e2:	008b8913          	add	s2,s7,8
 7e6:	4685                	li	a3,1
 7e8:	4629                	li	a2,10
 7ea:	000ba583          	lw	a1,0(s7)
 7ee:	855a                	mv	a0,s6
 7f0:	e3fff0ef          	jal	62e <printint>
        i += 1;
 7f4:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f6:	8bca                	mv	s7,s2
      state = 0;
 7f8:	4981                	li	s3,0
        i += 1;
 7fa:	b725                	j	722 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7fc:	06400793          	li	a5,100
 800:	02f60763          	beq	a2,a5,82e <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 804:	07500793          	li	a5,117
 808:	06f60963          	beq	a2,a5,87a <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 80c:	07800793          	li	a5,120
 810:	faf61ee3          	bne	a2,a5,7cc <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 814:	008b8913          	add	s2,s7,8
 818:	4681                	li	a3,0
 81a:	4641                	li	a2,16
 81c:	000ba583          	lw	a1,0(s7)
 820:	855a                	mv	a0,s6
 822:	e0dff0ef          	jal	62e <printint>
        i += 2;
 826:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 828:	8bca                	mv	s7,s2
      state = 0;
 82a:	4981                	li	s3,0
        i += 2;
 82c:	bddd                	j	722 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 82e:	008b8913          	add	s2,s7,8
 832:	4685                	li	a3,1
 834:	4629                	li	a2,10
 836:	000ba583          	lw	a1,0(s7)
 83a:	855a                	mv	a0,s6
 83c:	df3ff0ef          	jal	62e <printint>
        i += 2;
 840:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 842:	8bca                	mv	s7,s2
      state = 0;
 844:	4981                	li	s3,0
        i += 2;
 846:	bdf1                	j	722 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 848:	008b8913          	add	s2,s7,8
 84c:	4681                	li	a3,0
 84e:	4629                	li	a2,10
 850:	000ba583          	lw	a1,0(s7)
 854:	855a                	mv	a0,s6
 856:	dd9ff0ef          	jal	62e <printint>
 85a:	8bca                	mv	s7,s2
      state = 0;
 85c:	4981                	li	s3,0
 85e:	b5d1                	j	722 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 860:	008b8913          	add	s2,s7,8
 864:	4681                	li	a3,0
 866:	4629                	li	a2,10
 868:	000ba583          	lw	a1,0(s7)
 86c:	855a                	mv	a0,s6
 86e:	dc1ff0ef          	jal	62e <printint>
        i += 1;
 872:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 874:	8bca                	mv	s7,s2
      state = 0;
 876:	4981                	li	s3,0
        i += 1;
 878:	b56d                	j	722 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 87a:	008b8913          	add	s2,s7,8
 87e:	4681                	li	a3,0
 880:	4629                	li	a2,10
 882:	000ba583          	lw	a1,0(s7)
 886:	855a                	mv	a0,s6
 888:	da7ff0ef          	jal	62e <printint>
        i += 2;
 88c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 88e:	8bca                	mv	s7,s2
      state = 0;
 890:	4981                	li	s3,0
        i += 2;
 892:	bd41                	j	722 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 894:	008b8913          	add	s2,s7,8
 898:	4681                	li	a3,0
 89a:	4641                	li	a2,16
 89c:	000ba583          	lw	a1,0(s7)
 8a0:	855a                	mv	a0,s6
 8a2:	d8dff0ef          	jal	62e <printint>
 8a6:	8bca                	mv	s7,s2
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	bda5                	j	722 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8ac:	008b8913          	add	s2,s7,8
 8b0:	4681                	li	a3,0
 8b2:	4641                	li	a2,16
 8b4:	000ba583          	lw	a1,0(s7)
 8b8:	855a                	mv	a0,s6
 8ba:	d75ff0ef          	jal	62e <printint>
        i += 1;
 8be:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8c0:	8bca                	mv	s7,s2
      state = 0;
 8c2:	4981                	li	s3,0
        i += 1;
 8c4:	bdb9                	j	722 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 8c6:	008b8d13          	add	s10,s7,8
 8ca:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8ce:	03000593          	li	a1,48
 8d2:	855a                	mv	a0,s6
 8d4:	d3dff0ef          	jal	610 <putc>
  putc(fd, 'x');
 8d8:	07800593          	li	a1,120
 8dc:	855a                	mv	a0,s6
 8de:	d33ff0ef          	jal	610 <putc>
 8e2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8e4:	00000b97          	auipc	s7,0x0
 8e8:	25cb8b93          	add	s7,s7,604 # b40 <digits>
 8ec:	03c9d793          	srl	a5,s3,0x3c
 8f0:	97de                	add	a5,a5,s7
 8f2:	0007c583          	lbu	a1,0(a5)
 8f6:	855a                	mv	a0,s6
 8f8:	d19ff0ef          	jal	610 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8fc:	0992                	sll	s3,s3,0x4
 8fe:	397d                	addw	s2,s2,-1
 900:	fe0916e3          	bnez	s2,8ec <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 904:	8bea                	mv	s7,s10
      state = 0;
 906:	4981                	li	s3,0
 908:	bd29                	j	722 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 90a:	008b8993          	add	s3,s7,8
 90e:	000bb903          	ld	s2,0(s7)
 912:	00090f63          	beqz	s2,930 <vprintf+0x25a>
        for(; *s; s++)
 916:	00094583          	lbu	a1,0(s2)
 91a:	c195                	beqz	a1,93e <vprintf+0x268>
          putc(fd, *s);
 91c:	855a                	mv	a0,s6
 91e:	cf3ff0ef          	jal	610 <putc>
        for(; *s; s++)
 922:	0905                	add	s2,s2,1
 924:	00094583          	lbu	a1,0(s2)
 928:	f9f5                	bnez	a1,91c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 92a:	8bce                	mv	s7,s3
      state = 0;
 92c:	4981                	li	s3,0
 92e:	bbd5                	j	722 <vprintf+0x4c>
          s = "(null)";
 930:	00000917          	auipc	s2,0x0
 934:	20890913          	add	s2,s2,520 # b38 <malloc+0xfa>
        for(; *s; s++)
 938:	02800593          	li	a1,40
 93c:	b7c5                	j	91c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 93e:	8bce                	mv	s7,s3
      state = 0;
 940:	4981                	li	s3,0
 942:	b3c5                	j	722 <vprintf+0x4c>
    }
  }
}
 944:	60e6                	ld	ra,88(sp)
 946:	6446                	ld	s0,80(sp)
 948:	64a6                	ld	s1,72(sp)
 94a:	6906                	ld	s2,64(sp)
 94c:	79e2                	ld	s3,56(sp)
 94e:	7a42                	ld	s4,48(sp)
 950:	7aa2                	ld	s5,40(sp)
 952:	7b02                	ld	s6,32(sp)
 954:	6be2                	ld	s7,24(sp)
 956:	6c42                	ld	s8,16(sp)
 958:	6ca2                	ld	s9,8(sp)
 95a:	6d02                	ld	s10,0(sp)
 95c:	6125                	add	sp,sp,96
 95e:	8082                	ret

0000000000000960 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 960:	715d                	add	sp,sp,-80
 962:	ec06                	sd	ra,24(sp)
 964:	e822                	sd	s0,16(sp)
 966:	1000                	add	s0,sp,32
 968:	e010                	sd	a2,0(s0)
 96a:	e414                	sd	a3,8(s0)
 96c:	e818                	sd	a4,16(s0)
 96e:	ec1c                	sd	a5,24(s0)
 970:	03043023          	sd	a6,32(s0)
 974:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 978:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 97c:	8622                	mv	a2,s0
 97e:	d59ff0ef          	jal	6d6 <vprintf>
}
 982:	60e2                	ld	ra,24(sp)
 984:	6442                	ld	s0,16(sp)
 986:	6161                	add	sp,sp,80
 988:	8082                	ret

000000000000098a <printf>:

void
printf(const char *fmt, ...)
{
 98a:	711d                	add	sp,sp,-96
 98c:	ec06                	sd	ra,24(sp)
 98e:	e822                	sd	s0,16(sp)
 990:	1000                	add	s0,sp,32
 992:	e40c                	sd	a1,8(s0)
 994:	e810                	sd	a2,16(s0)
 996:	ec14                	sd	a3,24(s0)
 998:	f018                	sd	a4,32(s0)
 99a:	f41c                	sd	a5,40(s0)
 99c:	03043823          	sd	a6,48(s0)
 9a0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9a4:	00840613          	add	a2,s0,8
 9a8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9ac:	85aa                	mv	a1,a0
 9ae:	4505                	li	a0,1
 9b0:	d27ff0ef          	jal	6d6 <vprintf>
}
 9b4:	60e2                	ld	ra,24(sp)
 9b6:	6442                	ld	s0,16(sp)
 9b8:	6125                	add	sp,sp,96
 9ba:	8082                	ret

00000000000009bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9bc:	1141                	add	sp,sp,-16
 9be:	e422                	sd	s0,8(sp)
 9c0:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9c2:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9c6:	00000797          	auipc	a5,0x0
 9ca:	64a7b783          	ld	a5,1610(a5) # 1010 <freep>
 9ce:	a02d                	j	9f8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9d0:	4618                	lw	a4,8(a2)
 9d2:	9f2d                	addw	a4,a4,a1
 9d4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9d8:	6398                	ld	a4,0(a5)
 9da:	6310                	ld	a2,0(a4)
 9dc:	a83d                	j	a1a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9de:	ff852703          	lw	a4,-8(a0)
 9e2:	9f31                	addw	a4,a4,a2
 9e4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9e6:	ff053683          	ld	a3,-16(a0)
 9ea:	a091                	j	a2e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ec:	6398                	ld	a4,0(a5)
 9ee:	00e7e463          	bltu	a5,a4,9f6 <free+0x3a>
 9f2:	00e6ea63          	bltu	a3,a4,a06 <free+0x4a>
{
 9f6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f8:	fed7fae3          	bgeu	a5,a3,9ec <free+0x30>
 9fc:	6398                	ld	a4,0(a5)
 9fe:	00e6e463          	bltu	a3,a4,a06 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a02:	fee7eae3          	bltu	a5,a4,9f6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a06:	ff852583          	lw	a1,-8(a0)
 a0a:	6390                	ld	a2,0(a5)
 a0c:	02059813          	sll	a6,a1,0x20
 a10:	01c85713          	srl	a4,a6,0x1c
 a14:	9736                	add	a4,a4,a3
 a16:	fae60de3          	beq	a2,a4,9d0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a1a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a1e:	4790                	lw	a2,8(a5)
 a20:	02061593          	sll	a1,a2,0x20
 a24:	01c5d713          	srl	a4,a1,0x1c
 a28:	973e                	add	a4,a4,a5
 a2a:	fae68ae3          	beq	a3,a4,9de <free+0x22>
    p->s.ptr = bp->s.ptr;
 a2e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a30:	00000717          	auipc	a4,0x0
 a34:	5ef73023          	sd	a5,1504(a4) # 1010 <freep>
}
 a38:	6422                	ld	s0,8(sp)
 a3a:	0141                	add	sp,sp,16
 a3c:	8082                	ret

0000000000000a3e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a3e:	7139                	add	sp,sp,-64
 a40:	fc06                	sd	ra,56(sp)
 a42:	f822                	sd	s0,48(sp)
 a44:	f426                	sd	s1,40(sp)
 a46:	f04a                	sd	s2,32(sp)
 a48:	ec4e                	sd	s3,24(sp)
 a4a:	e852                	sd	s4,16(sp)
 a4c:	e456                	sd	s5,8(sp)
 a4e:	e05a                	sd	s6,0(sp)
 a50:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a52:	02051493          	sll	s1,a0,0x20
 a56:	9081                	srl	s1,s1,0x20
 a58:	04bd                	add	s1,s1,15
 a5a:	8091                	srl	s1,s1,0x4
 a5c:	0014899b          	addw	s3,s1,1
 a60:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 a62:	00000517          	auipc	a0,0x0
 a66:	5ae53503          	ld	a0,1454(a0) # 1010 <freep>
 a6a:	c515                	beqz	a0,a96 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a6c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a6e:	4798                	lw	a4,8(a5)
 a70:	02977f63          	bgeu	a4,s1,aae <malloc+0x70>
  if(nu < 4096)
 a74:	8a4e                	mv	s4,s3
 a76:	0009871b          	sext.w	a4,s3
 a7a:	6685                	lui	a3,0x1
 a7c:	00d77363          	bgeu	a4,a3,a82 <malloc+0x44>
 a80:	6a05                	lui	s4,0x1
 a82:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a86:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a8a:	00000917          	auipc	s2,0x0
 a8e:	58690913          	add	s2,s2,1414 # 1010 <freep>
  if(p == (char*)-1)
 a92:	5afd                	li	s5,-1
 a94:	a885                	j	b04 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 a96:	00000797          	auipc	a5,0x0
 a9a:	58a78793          	add	a5,a5,1418 # 1020 <base>
 a9e:	00000717          	auipc	a4,0x0
 aa2:	56f73923          	sd	a5,1394(a4) # 1010 <freep>
 aa6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 aa8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 aac:	b7e1                	j	a74 <malloc+0x36>
      if(p->s.size == nunits)
 aae:	02e48c63          	beq	s1,a4,ae6 <malloc+0xa8>
        p->s.size -= nunits;
 ab2:	4137073b          	subw	a4,a4,s3
 ab6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ab8:	02071693          	sll	a3,a4,0x20
 abc:	01c6d713          	srl	a4,a3,0x1c
 ac0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ac2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ac6:	00000717          	auipc	a4,0x0
 aca:	54a73523          	sd	a0,1354(a4) # 1010 <freep>
      return (void*)(p + 1);
 ace:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ad2:	70e2                	ld	ra,56(sp)
 ad4:	7442                	ld	s0,48(sp)
 ad6:	74a2                	ld	s1,40(sp)
 ad8:	7902                	ld	s2,32(sp)
 ada:	69e2                	ld	s3,24(sp)
 adc:	6a42                	ld	s4,16(sp)
 ade:	6aa2                	ld	s5,8(sp)
 ae0:	6b02                	ld	s6,0(sp)
 ae2:	6121                	add	sp,sp,64
 ae4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 ae6:	6398                	ld	a4,0(a5)
 ae8:	e118                	sd	a4,0(a0)
 aea:	bff1                	j	ac6 <malloc+0x88>
  hp->s.size = nu;
 aec:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 af0:	0541                	add	a0,a0,16
 af2:	ecbff0ef          	jal	9bc <free>
  return freep;
 af6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 afa:	dd61                	beqz	a0,ad2 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 afc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 afe:	4798                	lw	a4,8(a5)
 b00:	fa9777e3          	bgeu	a4,s1,aae <malloc+0x70>
    if(p == freep)
 b04:	00093703          	ld	a4,0(s2)
 b08:	853e                	mv	a0,a5
 b0a:	fef719e3          	bne	a4,a5,afc <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 b0e:	8552                	mv	a0,s4
 b10:	ac9ff0ef          	jal	5d8 <sbrk>
  if(p == (char*)-1)
 b14:	fd551ce3          	bne	a0,s5,aec <malloc+0xae>
        return 0;
 b18:	4501                	li	a0,0
 b1a:	bf65                	j	ad2 <malloc+0x94>
