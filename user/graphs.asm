
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
  ca:	c4010113          	add	sp,sp,-960
  ce:	3a113c23          	sd	ra,952(sp)
  d2:	3a813823          	sd	s0,944(sp)
  d6:	3a913423          	sd	s1,936(sp)
  da:	3b213023          	sd	s2,928(sp)
  de:	39313c23          	sd	s3,920(sp)
  e2:	39413823          	sd	s4,912(sp)
  e6:	39513423          	sd	s5,904(sp)
  ea:	39613023          	sd	s6,896(sp)
  ee:	37713c23          	sd	s7,888(sp)
  f2:	37813823          	sd	s8,880(sp)
  f6:	37913423          	sd	s9,872(sp)
  fa:	37a13023          	sd	s10,864(sp)
  fe:	35b13c23          	sd	s11,856(sp)
 102:	0780                	add	s0,sp,960

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
 122:	c4f43023          	sd	a5,-960(s0)
 126:	3e800793          	li	a5,1000
 12a:	c4f43c23          	sd	a5,-936(s0)

    int t0, t1;
    int tempo_overhead = 0;
 12e:	4c01                	li	s8,0
        
        //gerar arestas aleatórias
        int u, v;
        for (int j = 0; j < num_edges; j++){
            generate_random_edge(matrix, num_vertices, &u, &v);
            matrix[u][v] = 1;
 130:	4b85                	li	s7,1
 132:	a87d                	j	1f0 <main+0x126>
        int esq = 0;
        int dir = 0;
        int atual;
        while (esq <= dir) {
            atual = fila[esq];
            for (int j = 0; j < num_vertices; j++){
 134:	0785                	add	a5,a5,1
 136:	0691                	add	a3,a3,4
 138:	0007871b          	sext.w	a4,a5
 13c:	02977263          	bgeu	a4,s1,160 <main+0x96>
                if (matrix[atual][j] && !visitado[j]){
 140:	6198                	ld	a4,0(a1)
 142:	00279613          	sll	a2,a5,0x2
 146:	9732                	add	a4,a4,a2
 148:	4318                	lw	a4,0(a4)
 14a:	d76d                	beqz	a4,134 <main+0x6a>
 14c:	4298                	lw	a4,0(a3)
 14e:	f37d                	bnez	a4,134 <main+0x6a>
                    visitado[j] = 1;
 150:	0176a023          	sw	s7,0(a3)
                    distancia[j] = distancia[atual] + 1;
                    dir++;
 154:	2505                	addw	a0,a0,1
                    fila[dir] = j;
 156:	00251713          	sll	a4,a0,0x2
 15a:	974e                	add	a4,a4,s3
 15c:	c31c                	sw	a5,0(a4)
 15e:	bfd9                	j	134 <main+0x6a>
                }
            }
            esq++;
 160:	2805                	addw	a6,a6,1
        while (esq <= dir) {
 162:	0891                	add	a7,a7,4
 164:	01054b63          	blt	a0,a6,17a <main+0xb0>
            atual = fila[esq];
 168:	0008a583          	lw	a1,0(a7)
            for (int j = 0; j < num_vertices; j++){
 16c:	d8f5                	beqz	s1,160 <main+0x96>
                if (matrix[atual][j] && !visitado[j]){
 16e:	058e                	sll	a1,a1,0x3
 170:	95da                	add	a1,a1,s6
 172:	c7040693          	add	a3,s0,-912
 176:	4781                	li	a5,0
 178:	b7e1                	j	140 <main+0x76>
        }

        //libera a matrix
        t0 = uptime();
 17a:	51c000ef          	jal	696 <uptime>
 17e:	892a                	mv	s2,a0
        free(fila);
 180:	854e                	mv	a0,s3
 182:	101000ef          	jal	a82 <free>
        t1 = uptime();
 186:	510000ef          	jal	696 <uptime>
        tempo_overhead+= t1 - t0;
 18a:	4125093b          	subw	s2,a0,s2
 18e:	0149093b          	addw	s2,s2,s4
        for (int i = 0; i < num_vertices; i++) {
 192:	cc85                	beqz	s1,1ca <main+0x100>
 194:	84da                	mv	s1,s6
 196:	c4c42783          	lw	a5,-948(s0)
 19a:	0637899b          	addw	s3,a5,99
 19e:	02099793          	sll	a5,s3,0x20
 1a2:	01d7d993          	srl	s3,a5,0x1d
 1a6:	008b0793          	add	a5,s6,8
 1aa:	99be                	add	s3,s3,a5
            t0 = uptime();
 1ac:	4ea000ef          	jal	696 <uptime>
 1b0:	8a2a                	mv	s4,a0
            free(matrix[i]); 
 1b2:	6088                	ld	a0,0(s1)
 1b4:	0cf000ef          	jal	a82 <free>
            t1 = uptime();
 1b8:	4de000ef          	jal	696 <uptime>
            tempo_overhead+= t1 - t0; 
 1bc:	4145053b          	subw	a0,a0,s4
 1c0:	0125093b          	addw	s2,a0,s2
        for (int i = 0; i < num_vertices; i++) {
 1c4:	04a1                	add	s1,s1,8
 1c6:	fe9993e3          	bne	s3,s1,1ac <main+0xe2>
        }
        t0 = uptime();
 1ca:	4cc000ef          	jal	696 <uptime>
 1ce:	8c2a                	mv	s8,a0
        free(matrix);
 1d0:	855a                	mv	a0,s6
 1d2:	0b1000ef          	jal	a82 <free>
        t1 = uptime();
 1d6:	4c0000ef          	jal	696 <uptime>
        tempo_overhead+= t1 - t0;
 1da:	41850c3b          	subw	s8,a0,s8
 1de:	012c0c3b          	addw	s8,s8,s2
    for (int i = 0; i < max_iter; i++){
 1e2:	c5843783          	ld	a5,-936(s0)
 1e6:	37fd                	addw	a5,a5,-1
 1e8:	c4f43c23          	sd	a5,-936(s0)
 1ec:	14078463          	beqz	a5,334 <main+0x26a>
        uint num_vertices = (rand() % 101) + 100;
 1f0:	e69ff0ef          	jal	58 <rand>
 1f4:	06500793          	li	a5,101
 1f8:	02f569bb          	remw	s3,a0,a5
 1fc:	c5342623          	sw	s3,-948(s0)
 200:	06498c9b          	addw	s9,s3,100
 204:	000c8d9b          	sext.w	s11,s9
 208:	84ee                	mv	s1,s11
        int num_edges = (rand() % 351) + 50;
 20a:	e4fff0ef          	jal	58 <rand>
 20e:	15f00793          	li	a5,351
 212:	02f567bb          	remw	a5,a0,a5
 216:	c4f42423          	sw	a5,-952(s0)
 21a:	2781                	sext.w	a5,a5
 21c:	c4f43823          	sd	a5,-944(s0)
        t0 = uptime();
 220:	476000ef          	jal	696 <uptime>
 224:	892a                	mv	s2,a0
        int **matrix = malloc(num_vertices * sizeof(int *));
 226:	003c951b          	sllw	a0,s9,0x3
 22a:	0db000ef          	jal	b04 <malloc>
 22e:	8b2a                	mv	s6,a0
        t1 = uptime();
 230:	466000ef          	jal	696 <uptime>
        tempo_overhead+= t1 - t0;
 234:	412507bb          	subw	a5,a0,s2
 238:	01878c3b          	addw	s8,a5,s8
        for (int j = 0; j < num_vertices; j++){
 23c:	040d8c63          	beqz	s11,294 <main+0x1ca>
            matrix[j] = malloc(num_vertices * sizeof(int));
 240:	002c9c9b          	sllw	s9,s9,0x2
 244:	8a5a                	mv	s4,s6
 246:	0639879b          	addw	a5,s3,99
 24a:	1782                	sll	a5,a5,0x20
 24c:	9381                	srl	a5,a5,0x20
 24e:	008b0d13          	add	s10,s6,8
 252:	00379713          	sll	a4,a5,0x3
 256:	9d3a                	add	s10,s10,a4
 258:	0785                	add	a5,a5,1
 25a:	00279993          	sll	s3,a5,0x2
            t0 = uptime();
 25e:	438000ef          	jal	696 <uptime>
 262:	8aaa                	mv	s5,a0
            matrix[j] = malloc(num_vertices * sizeof(int));
 264:	8566                	mv	a0,s9
 266:	09f000ef          	jal	b04 <malloc>
 26a:	8952                	mv	s2,s4
 26c:	00aa3023          	sd	a0,0(s4)
            t1 = uptime();
 270:	426000ef          	jal	696 <uptime>
            tempo_overhead+= t1 - t0;
 274:	4155053b          	subw	a0,a0,s5
 278:	01850c3b          	addw	s8,a0,s8
 27c:	4781                	li	a5,0
                matrix[j][k] = 0;
 27e:	00093703          	ld	a4,0(s2)
 282:	973e                	add	a4,a4,a5
 284:	00072023          	sw	zero,0(a4)
            for (int k = 0; k < num_vertices; k++){
 288:	0791                	add	a5,a5,4
 28a:	fef99ae3          	bne	s3,a5,27e <main+0x1b4>
        for (int j = 0; j < num_vertices; j++){
 28e:	0a21                	add	s4,s4,8
 290:	fdaa17e3          	bne	s4,s10,25e <main+0x194>
        for (int j = 0; j < num_edges; j++){
 294:	fcf00793          	li	a5,-49
 298:	c5043703          	ld	a4,-944(s0)
 29c:	02f74d63          	blt	a4,a5,2d6 <main+0x20c>
 2a0:	c4842783          	lw	a5,-952(s0)
 2a4:	0327899b          	addw	s3,a5,50
 2a8:	4901                	li	s2,0
            generate_random_edge(matrix, num_vertices, &u, &v);
 2aa:	c6c40693          	add	a3,s0,-916
 2ae:	c6840613          	add	a2,s0,-920
 2b2:	85ee                	mv	a1,s11
 2b4:	855a                	mv	a0,s6
 2b6:	dbfff0ef          	jal	74 <generate_random_edge>
            matrix[u][v] = 1;
 2ba:	c6842783          	lw	a5,-920(s0)
 2be:	078e                	sll	a5,a5,0x3
 2c0:	97da                	add	a5,a5,s6
 2c2:	c6c42703          	lw	a4,-916(s0)
 2c6:	639c                	ld	a5,0(a5)
 2c8:	070a                	sll	a4,a4,0x2
 2ca:	97ba                	add	a5,a5,a4
 2cc:	0177a023          	sw	s7,0(a5)
        for (int j = 0; j < num_edges; j++){
 2d0:	2905                	addw	s2,s2,1
 2d2:	fd391ce3          	bne	s2,s3,2aa <main+0x1e0>
            u = rand() % num_vertices;
 2d6:	d83ff0ef          	jal	58 <rand>
 2da:	0295793b          	remuw	s2,a0,s1
 2de:	0009099b          	sext.w	s3,s2
 2e2:	c7242423          	sw	s2,-920(s0)
            v = rand() % num_vertices;
 2e6:	d73ff0ef          	jal	58 <rand>
 2ea:	0295753b          	remuw	a0,a0,s1
 2ee:	0005079b          	sext.w	a5,a0
 2f2:	c6a42623          	sw	a0,-916(s0)
        } while (u == v);
 2f6:	fef980e3          	beq	s3,a5,2d6 <main+0x20c>
        t0 = uptime();
 2fa:	39c000ef          	jal	696 <uptime>
 2fe:	8a2a                	mv	s4,a0
        int *fila = malloc(tam * sizeof(int));
 300:	64000513          	li	a0,1600
 304:	001000ef          	jal	b04 <malloc>
 308:	89aa                	mv	s3,a0
        t1 = uptime();
 30a:	38c000ef          	jal	696 <uptime>
        tempo_overhead+= t1 - t0;
 30e:	41450a3b          	subw	s4,a0,s4
 312:	018a0a3b          	addw	s4,s4,s8
        for (int i = 0; i < 200; i++){
 316:	f9040713          	add	a4,s0,-112
        tempo_overhead+= t1 - t0;
 31a:	c7040793          	add	a5,s0,-912
            visitado[i] = 0;
 31e:	0007a023          	sw	zero,0(a5)
        for (int i = 0; i < 200; i++){
 322:	0791                	add	a5,a5,4
 324:	fee79de3          	bne	a5,a4,31e <main+0x254>
        fila[0] = u;
 328:	0129a023          	sw	s2,0(s3)
        while (esq <= dir) {
 32c:	88ce                	mv	a7,s3
        int dir = 0;
 32e:	4501                	li	a0,0
        int esq = 0;
 330:	4801                	li	a6,0
 332:	bd1d                	j	168 <main+0x9e>

    }

    increment_metric(index, -1, MODE_EFICIENCIA);
 334:	4629                	li	a2,10
 336:	55fd                	li	a1,-1
 338:	c4043483          	ld	s1,-960(s0)
 33c:	8526                	mv	a0,s1
 33e:	378000ef          	jal	6b6 <increment_metric>
    increment_metric(index, tempo_overhead, MODE_OVERHEAD);
 342:	4621                	li	a2,8
 344:	85e2                	mv	a1,s8
 346:	8526                	mv	a0,s1
 348:	36e000ef          	jal	6b6 <increment_metric>

    int pid = getpid();
 34c:	332000ef          	jal	67e <getpid>
 350:	85aa                	mv	a1,a0
    set_justica(index, pid);
 352:	8526                	mv	a0,s1
 354:	37a000ef          	jal	6ce <set_justica>

    return 0;
 358:	4501                	li	a0,0
 35a:	3b813083          	ld	ra,952(sp)
 35e:	3b013403          	ld	s0,944(sp)
 362:	3a813483          	ld	s1,936(sp)
 366:	3a013903          	ld	s2,928(sp)
 36a:	39813983          	ld	s3,920(sp)
 36e:	39013a03          	ld	s4,912(sp)
 372:	38813a83          	ld	s5,904(sp)
 376:	38013b03          	ld	s6,896(sp)
 37a:	37813b83          	ld	s7,888(sp)
 37e:	37013c03          	ld	s8,880(sp)
 382:	36813c83          	ld	s9,872(sp)
 386:	36013d03          	ld	s10,864(sp)
 38a:	35813d83          	ld	s11,856(sp)
 38e:	3c010113          	add	sp,sp,960
 392:	8082                	ret

0000000000000394 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 394:	1141                	add	sp,sp,-16
 396:	e406                	sd	ra,8(sp)
 398:	e022                	sd	s0,0(sp)
 39a:	0800                	add	s0,sp,16
  extern int main();
  main();
 39c:	d2fff0ef          	jal	ca <main>
  exit(0);
 3a0:	4501                	li	a0,0
 3a2:	25c000ef          	jal	5fe <exit>

00000000000003a6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3a6:	1141                	add	sp,sp,-16
 3a8:	e422                	sd	s0,8(sp)
 3aa:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3ac:	87aa                	mv	a5,a0
 3ae:	0585                	add	a1,a1,1
 3b0:	0785                	add	a5,a5,1
 3b2:	fff5c703          	lbu	a4,-1(a1)
 3b6:	fee78fa3          	sb	a4,-1(a5)
 3ba:	fb75                	bnez	a4,3ae <strcpy+0x8>
    ;
  return os;
}
 3bc:	6422                	ld	s0,8(sp)
 3be:	0141                	add	sp,sp,16
 3c0:	8082                	ret

00000000000003c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c2:	1141                	add	sp,sp,-16
 3c4:	e422                	sd	s0,8(sp)
 3c6:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 3c8:	00054783          	lbu	a5,0(a0)
 3cc:	cb91                	beqz	a5,3e0 <strcmp+0x1e>
 3ce:	0005c703          	lbu	a4,0(a1)
 3d2:	00f71763          	bne	a4,a5,3e0 <strcmp+0x1e>
    p++, q++;
 3d6:	0505                	add	a0,a0,1
 3d8:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 3da:	00054783          	lbu	a5,0(a0)
 3de:	fbe5                	bnez	a5,3ce <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3e0:	0005c503          	lbu	a0,0(a1)
}
 3e4:	40a7853b          	subw	a0,a5,a0
 3e8:	6422                	ld	s0,8(sp)
 3ea:	0141                	add	sp,sp,16
 3ec:	8082                	ret

00000000000003ee <strlen>:

uint
strlen(const char *s)
{
 3ee:	1141                	add	sp,sp,-16
 3f0:	e422                	sd	s0,8(sp)
 3f2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3f4:	00054783          	lbu	a5,0(a0)
 3f8:	cf91                	beqz	a5,414 <strlen+0x26>
 3fa:	0505                	add	a0,a0,1
 3fc:	87aa                	mv	a5,a0
 3fe:	86be                	mv	a3,a5
 400:	0785                	add	a5,a5,1
 402:	fff7c703          	lbu	a4,-1(a5)
 406:	ff65                	bnez	a4,3fe <strlen+0x10>
 408:	40a6853b          	subw	a0,a3,a0
 40c:	2505                	addw	a0,a0,1
    ;
  return n;
}
 40e:	6422                	ld	s0,8(sp)
 410:	0141                	add	sp,sp,16
 412:	8082                	ret
  for(n = 0; s[n]; n++)
 414:	4501                	li	a0,0
 416:	bfe5                	j	40e <strlen+0x20>

0000000000000418 <memset>:

void*
memset(void *dst, int c, uint n)
{
 418:	1141                	add	sp,sp,-16
 41a:	e422                	sd	s0,8(sp)
 41c:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 41e:	ca19                	beqz	a2,434 <memset+0x1c>
 420:	87aa                	mv	a5,a0
 422:	1602                	sll	a2,a2,0x20
 424:	9201                	srl	a2,a2,0x20
 426:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 42a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 42e:	0785                	add	a5,a5,1
 430:	fee79de3          	bne	a5,a4,42a <memset+0x12>
  }
  return dst;
}
 434:	6422                	ld	s0,8(sp)
 436:	0141                	add	sp,sp,16
 438:	8082                	ret

000000000000043a <strchr>:

char*
strchr(const char *s, char c)
{
 43a:	1141                	add	sp,sp,-16
 43c:	e422                	sd	s0,8(sp)
 43e:	0800                	add	s0,sp,16
  for(; *s; s++)
 440:	00054783          	lbu	a5,0(a0)
 444:	cb99                	beqz	a5,45a <strchr+0x20>
    if(*s == c)
 446:	00f58763          	beq	a1,a5,454 <strchr+0x1a>
  for(; *s; s++)
 44a:	0505                	add	a0,a0,1
 44c:	00054783          	lbu	a5,0(a0)
 450:	fbfd                	bnez	a5,446 <strchr+0xc>
      return (char*)s;
  return 0;
 452:	4501                	li	a0,0
}
 454:	6422                	ld	s0,8(sp)
 456:	0141                	add	sp,sp,16
 458:	8082                	ret
  return 0;
 45a:	4501                	li	a0,0
 45c:	bfe5                	j	454 <strchr+0x1a>

000000000000045e <gets>:

char*
gets(char *buf, int max)
{
 45e:	711d                	add	sp,sp,-96
 460:	ec86                	sd	ra,88(sp)
 462:	e8a2                	sd	s0,80(sp)
 464:	e4a6                	sd	s1,72(sp)
 466:	e0ca                	sd	s2,64(sp)
 468:	fc4e                	sd	s3,56(sp)
 46a:	f852                	sd	s4,48(sp)
 46c:	f456                	sd	s5,40(sp)
 46e:	f05a                	sd	s6,32(sp)
 470:	ec5e                	sd	s7,24(sp)
 472:	1080                	add	s0,sp,96
 474:	8baa                	mv	s7,a0
 476:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 478:	892a                	mv	s2,a0
 47a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 47c:	4aa9                	li	s5,10
 47e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 480:	89a6                	mv	s3,s1
 482:	2485                	addw	s1,s1,1
 484:	0344d663          	bge	s1,s4,4b0 <gets+0x52>
    cc = read(0, &c, 1);
 488:	4605                	li	a2,1
 48a:	faf40593          	add	a1,s0,-81
 48e:	4501                	li	a0,0
 490:	186000ef          	jal	616 <read>
    if(cc < 1)
 494:	00a05e63          	blez	a0,4b0 <gets+0x52>
    buf[i++] = c;
 498:	faf44783          	lbu	a5,-81(s0)
 49c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4a0:	01578763          	beq	a5,s5,4ae <gets+0x50>
 4a4:	0905                	add	s2,s2,1
 4a6:	fd679de3          	bne	a5,s6,480 <gets+0x22>
  for(i=0; i+1 < max; ){
 4aa:	89a6                	mv	s3,s1
 4ac:	a011                	j	4b0 <gets+0x52>
 4ae:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4b0:	99de                	add	s3,s3,s7
 4b2:	00098023          	sb	zero,0(s3)
  return buf;
}
 4b6:	855e                	mv	a0,s7
 4b8:	60e6                	ld	ra,88(sp)
 4ba:	6446                	ld	s0,80(sp)
 4bc:	64a6                	ld	s1,72(sp)
 4be:	6906                	ld	s2,64(sp)
 4c0:	79e2                	ld	s3,56(sp)
 4c2:	7a42                	ld	s4,48(sp)
 4c4:	7aa2                	ld	s5,40(sp)
 4c6:	7b02                	ld	s6,32(sp)
 4c8:	6be2                	ld	s7,24(sp)
 4ca:	6125                	add	sp,sp,96
 4cc:	8082                	ret

00000000000004ce <stat>:

int
stat(const char *n, struct stat *st)
{
 4ce:	1101                	add	sp,sp,-32
 4d0:	ec06                	sd	ra,24(sp)
 4d2:	e822                	sd	s0,16(sp)
 4d4:	e426                	sd	s1,8(sp)
 4d6:	e04a                	sd	s2,0(sp)
 4d8:	1000                	add	s0,sp,32
 4da:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4dc:	4581                	li	a1,0
 4de:	160000ef          	jal	63e <open>
  if(fd < 0)
 4e2:	02054163          	bltz	a0,504 <stat+0x36>
 4e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4e8:	85ca                	mv	a1,s2
 4ea:	16c000ef          	jal	656 <fstat>
 4ee:	892a                	mv	s2,a0
  close(fd);
 4f0:	8526                	mv	a0,s1
 4f2:	134000ef          	jal	626 <close>
  return r;
}
 4f6:	854a                	mv	a0,s2
 4f8:	60e2                	ld	ra,24(sp)
 4fa:	6442                	ld	s0,16(sp)
 4fc:	64a2                	ld	s1,8(sp)
 4fe:	6902                	ld	s2,0(sp)
 500:	6105                	add	sp,sp,32
 502:	8082                	ret
    return -1;
 504:	597d                	li	s2,-1
 506:	bfc5                	j	4f6 <stat+0x28>

0000000000000508 <atoi>:

int
atoi(const char *s)
{
 508:	1141                	add	sp,sp,-16
 50a:	e422                	sd	s0,8(sp)
 50c:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 50e:	00054683          	lbu	a3,0(a0)
 512:	fd06879b          	addw	a5,a3,-48
 516:	0ff7f793          	zext.b	a5,a5
 51a:	4625                	li	a2,9
 51c:	02f66863          	bltu	a2,a5,54c <atoi+0x44>
 520:	872a                	mv	a4,a0
  n = 0;
 522:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 524:	0705                	add	a4,a4,1
 526:	0025179b          	sllw	a5,a0,0x2
 52a:	9fa9                	addw	a5,a5,a0
 52c:	0017979b          	sllw	a5,a5,0x1
 530:	9fb5                	addw	a5,a5,a3
 532:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 536:	00074683          	lbu	a3,0(a4)
 53a:	fd06879b          	addw	a5,a3,-48
 53e:	0ff7f793          	zext.b	a5,a5
 542:	fef671e3          	bgeu	a2,a5,524 <atoi+0x1c>
  return n;
}
 546:	6422                	ld	s0,8(sp)
 548:	0141                	add	sp,sp,16
 54a:	8082                	ret
  n = 0;
 54c:	4501                	li	a0,0
 54e:	bfe5                	j	546 <atoi+0x3e>

0000000000000550 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 550:	1141                	add	sp,sp,-16
 552:	e422                	sd	s0,8(sp)
 554:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 556:	02b57463          	bgeu	a0,a1,57e <memmove+0x2e>
    while(n-- > 0)
 55a:	00c05f63          	blez	a2,578 <memmove+0x28>
 55e:	1602                	sll	a2,a2,0x20
 560:	9201                	srl	a2,a2,0x20
 562:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 566:	872a                	mv	a4,a0
      *dst++ = *src++;
 568:	0585                	add	a1,a1,1
 56a:	0705                	add	a4,a4,1
 56c:	fff5c683          	lbu	a3,-1(a1)
 570:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 574:	fee79ae3          	bne	a5,a4,568 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 578:	6422                	ld	s0,8(sp)
 57a:	0141                	add	sp,sp,16
 57c:	8082                	ret
    dst += n;
 57e:	00c50733          	add	a4,a0,a2
    src += n;
 582:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 584:	fec05ae3          	blez	a2,578 <memmove+0x28>
 588:	fff6079b          	addw	a5,a2,-1
 58c:	1782                	sll	a5,a5,0x20
 58e:	9381                	srl	a5,a5,0x20
 590:	fff7c793          	not	a5,a5
 594:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 596:	15fd                	add	a1,a1,-1
 598:	177d                	add	a4,a4,-1
 59a:	0005c683          	lbu	a3,0(a1)
 59e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5a2:	fee79ae3          	bne	a5,a4,596 <memmove+0x46>
 5a6:	bfc9                	j	578 <memmove+0x28>

00000000000005a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5a8:	1141                	add	sp,sp,-16
 5aa:	e422                	sd	s0,8(sp)
 5ac:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5ae:	ca05                	beqz	a2,5de <memcmp+0x36>
 5b0:	fff6069b          	addw	a3,a2,-1
 5b4:	1682                	sll	a3,a3,0x20
 5b6:	9281                	srl	a3,a3,0x20
 5b8:	0685                	add	a3,a3,1
 5ba:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5bc:	00054783          	lbu	a5,0(a0)
 5c0:	0005c703          	lbu	a4,0(a1)
 5c4:	00e79863          	bne	a5,a4,5d4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5c8:	0505                	add	a0,a0,1
    p2++;
 5ca:	0585                	add	a1,a1,1
  while (n-- > 0) {
 5cc:	fed518e3          	bne	a0,a3,5bc <memcmp+0x14>
  }
  return 0;
 5d0:	4501                	li	a0,0
 5d2:	a019                	j	5d8 <memcmp+0x30>
      return *p1 - *p2;
 5d4:	40e7853b          	subw	a0,a5,a4
}
 5d8:	6422                	ld	s0,8(sp)
 5da:	0141                	add	sp,sp,16
 5dc:	8082                	ret
  return 0;
 5de:	4501                	li	a0,0
 5e0:	bfe5                	j	5d8 <memcmp+0x30>

00000000000005e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5e2:	1141                	add	sp,sp,-16
 5e4:	e406                	sd	ra,8(sp)
 5e6:	e022                	sd	s0,0(sp)
 5e8:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 5ea:	f67ff0ef          	jal	550 <memmove>
}
 5ee:	60a2                	ld	ra,8(sp)
 5f0:	6402                	ld	s0,0(sp)
 5f2:	0141                	add	sp,sp,16
 5f4:	8082                	ret

00000000000005f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5f6:	4885                	li	a7,1
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 5fe:	4889                	li	a7,2
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <wait>:
.global wait
wait:
 li a7, SYS_wait
 606:	488d                	li	a7,3
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 60e:	4891                	li	a7,4
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <read>:
.global read
read:
 li a7, SYS_read
 616:	4895                	li	a7,5
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <write>:
.global write
write:
 li a7, SYS_write
 61e:	48c1                	li	a7,16
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <close>:
.global close
close:
 li a7, SYS_close
 626:	48d5                	li	a7,21
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <kill>:
.global kill
kill:
 li a7, SYS_kill
 62e:	4899                	li	a7,6
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <exec>:
.global exec
exec:
 li a7, SYS_exec
 636:	489d                	li	a7,7
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <open>:
.global open
open:
 li a7, SYS_open
 63e:	48bd                	li	a7,15
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 646:	48c5                	li	a7,17
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 64e:	48c9                	li	a7,18
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 656:	48a1                	li	a7,8
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <link>:
.global link
link:
 li a7, SYS_link
 65e:	48cd                	li	a7,19
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 666:	48d1                	li	a7,20
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 66e:	48a5                	li	a7,9
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <dup>:
.global dup
dup:
 li a7, SYS_dup
 676:	48a9                	li	a7,10
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 67e:	48ad                	li	a7,11
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 686:	48b1                	li	a7,12
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 68e:	48b5                	li	a7,13
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 696:	48b9                	li	a7,14
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 69e:	48d9                	li	a7,22
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 6a6:	48dd                	li	a7,23
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 6ae:	48e1                	li	a7,24
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 6b6:	48e5                	li	a7,25
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 6be:	48e9                	li	a7,26
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 6c6:	48ed                	li	a7,27
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 6ce:	48f1                	li	a7,28
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6d6:	1101                	add	sp,sp,-32
 6d8:	ec06                	sd	ra,24(sp)
 6da:	e822                	sd	s0,16(sp)
 6dc:	1000                	add	s0,sp,32
 6de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6e2:	4605                	li	a2,1
 6e4:	fef40593          	add	a1,s0,-17
 6e8:	f37ff0ef          	jal	61e <write>
}
 6ec:	60e2                	ld	ra,24(sp)
 6ee:	6442                	ld	s0,16(sp)
 6f0:	6105                	add	sp,sp,32
 6f2:	8082                	ret

00000000000006f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6f4:	7139                	add	sp,sp,-64
 6f6:	fc06                	sd	ra,56(sp)
 6f8:	f822                	sd	s0,48(sp)
 6fa:	f426                	sd	s1,40(sp)
 6fc:	f04a                	sd	s2,32(sp)
 6fe:	ec4e                	sd	s3,24(sp)
 700:	0080                	add	s0,sp,64
 702:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 704:	c299                	beqz	a3,70a <printint+0x16>
 706:	0805c763          	bltz	a1,794 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 70a:	2581                	sext.w	a1,a1
  neg = 0;
 70c:	4881                	li	a7,0
 70e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 712:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 714:	2601                	sext.w	a2,a2
 716:	00000517          	auipc	a0,0x0
 71a:	4e250513          	add	a0,a0,1250 # bf8 <digits>
 71e:	883a                	mv	a6,a4
 720:	2705                	addw	a4,a4,1
 722:	02c5f7bb          	remuw	a5,a1,a2
 726:	1782                	sll	a5,a5,0x20
 728:	9381                	srl	a5,a5,0x20
 72a:	97aa                	add	a5,a5,a0
 72c:	0007c783          	lbu	a5,0(a5)
 730:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 734:	0005879b          	sext.w	a5,a1
 738:	02c5d5bb          	divuw	a1,a1,a2
 73c:	0685                	add	a3,a3,1
 73e:	fec7f0e3          	bgeu	a5,a2,71e <printint+0x2a>
  if(neg)
 742:	00088c63          	beqz	a7,75a <printint+0x66>
    buf[i++] = '-';
 746:	fd070793          	add	a5,a4,-48
 74a:	00878733          	add	a4,a5,s0
 74e:	02d00793          	li	a5,45
 752:	fef70823          	sb	a5,-16(a4)
 756:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 75a:	02e05663          	blez	a4,786 <printint+0x92>
 75e:	fc040793          	add	a5,s0,-64
 762:	00e78933          	add	s2,a5,a4
 766:	fff78993          	add	s3,a5,-1
 76a:	99ba                	add	s3,s3,a4
 76c:	377d                	addw	a4,a4,-1
 76e:	1702                	sll	a4,a4,0x20
 770:	9301                	srl	a4,a4,0x20
 772:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 776:	fff94583          	lbu	a1,-1(s2)
 77a:	8526                	mv	a0,s1
 77c:	f5bff0ef          	jal	6d6 <putc>
  while(--i >= 0)
 780:	197d                	add	s2,s2,-1
 782:	ff391ae3          	bne	s2,s3,776 <printint+0x82>
}
 786:	70e2                	ld	ra,56(sp)
 788:	7442                	ld	s0,48(sp)
 78a:	74a2                	ld	s1,40(sp)
 78c:	7902                	ld	s2,32(sp)
 78e:	69e2                	ld	s3,24(sp)
 790:	6121                	add	sp,sp,64
 792:	8082                	ret
    x = -xx;
 794:	40b005bb          	negw	a1,a1
    neg = 1;
 798:	4885                	li	a7,1
    x = -xx;
 79a:	bf95                	j	70e <printint+0x1a>

000000000000079c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 79c:	711d                	add	sp,sp,-96
 79e:	ec86                	sd	ra,88(sp)
 7a0:	e8a2                	sd	s0,80(sp)
 7a2:	e4a6                	sd	s1,72(sp)
 7a4:	e0ca                	sd	s2,64(sp)
 7a6:	fc4e                	sd	s3,56(sp)
 7a8:	f852                	sd	s4,48(sp)
 7aa:	f456                	sd	s5,40(sp)
 7ac:	f05a                	sd	s6,32(sp)
 7ae:	ec5e                	sd	s7,24(sp)
 7b0:	e862                	sd	s8,16(sp)
 7b2:	e466                	sd	s9,8(sp)
 7b4:	e06a                	sd	s10,0(sp)
 7b6:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7b8:	0005c903          	lbu	s2,0(a1)
 7bc:	24090763          	beqz	s2,a0a <vprintf+0x26e>
 7c0:	8b2a                	mv	s6,a0
 7c2:	8a2e                	mv	s4,a1
 7c4:	8bb2                	mv	s7,a2
  state = 0;
 7c6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 7c8:	4481                	li	s1,0
 7ca:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 7cc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 7d0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 7d4:	06c00c93          	li	s9,108
 7d8:	a005                	j	7f8 <vprintf+0x5c>
        putc(fd, c0);
 7da:	85ca                	mv	a1,s2
 7dc:	855a                	mv	a0,s6
 7de:	ef9ff0ef          	jal	6d6 <putc>
 7e2:	a019                	j	7e8 <vprintf+0x4c>
    } else if(state == '%'){
 7e4:	03598263          	beq	s3,s5,808 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 7e8:	2485                	addw	s1,s1,1
 7ea:	8726                	mv	a4,s1
 7ec:	009a07b3          	add	a5,s4,s1
 7f0:	0007c903          	lbu	s2,0(a5)
 7f4:	20090b63          	beqz	s2,a0a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 7f8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 7fc:	fe0994e3          	bnez	s3,7e4 <vprintf+0x48>
      if(c0 == '%'){
 800:	fd579de3          	bne	a5,s5,7da <vprintf+0x3e>
        state = '%';
 804:	89be                	mv	s3,a5
 806:	b7cd                	j	7e8 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 808:	c7c9                	beqz	a5,892 <vprintf+0xf6>
 80a:	00ea06b3          	add	a3,s4,a4
 80e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 812:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 814:	c681                	beqz	a3,81c <vprintf+0x80>
 816:	9752                	add	a4,a4,s4
 818:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 81c:	03878f63          	beq	a5,s8,85a <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 820:	05978963          	beq	a5,s9,872 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 824:	07500713          	li	a4,117
 828:	0ee78363          	beq	a5,a4,90e <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 82c:	07800713          	li	a4,120
 830:	12e78563          	beq	a5,a4,95a <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 834:	07000713          	li	a4,112
 838:	14e78a63          	beq	a5,a4,98c <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 83c:	07300713          	li	a4,115
 840:	18e78863          	beq	a5,a4,9d0 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 844:	02500713          	li	a4,37
 848:	04e79563          	bne	a5,a4,892 <vprintf+0xf6>
        putc(fd, '%');
 84c:	02500593          	li	a1,37
 850:	855a                	mv	a0,s6
 852:	e85ff0ef          	jal	6d6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 856:	4981                	li	s3,0
 858:	bf41                	j	7e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 85a:	008b8913          	add	s2,s7,8
 85e:	4685                	li	a3,1
 860:	4629                	li	a2,10
 862:	000ba583          	lw	a1,0(s7)
 866:	855a                	mv	a0,s6
 868:	e8dff0ef          	jal	6f4 <printint>
 86c:	8bca                	mv	s7,s2
      state = 0;
 86e:	4981                	li	s3,0
 870:	bfa5                	j	7e8 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 872:	06400793          	li	a5,100
 876:	02f68963          	beq	a3,a5,8a8 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 87a:	06c00793          	li	a5,108
 87e:	04f68263          	beq	a3,a5,8c2 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 882:	07500793          	li	a5,117
 886:	0af68063          	beq	a3,a5,926 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 88a:	07800793          	li	a5,120
 88e:	0ef68263          	beq	a3,a5,972 <vprintf+0x1d6>
        putc(fd, '%');
 892:	02500593          	li	a1,37
 896:	855a                	mv	a0,s6
 898:	e3fff0ef          	jal	6d6 <putc>
        putc(fd, c0);
 89c:	85ca                	mv	a1,s2
 89e:	855a                	mv	a0,s6
 8a0:	e37ff0ef          	jal	6d6 <putc>
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	b789                	j	7e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8a8:	008b8913          	add	s2,s7,8
 8ac:	4685                	li	a3,1
 8ae:	4629                	li	a2,10
 8b0:	000ba583          	lw	a1,0(s7)
 8b4:	855a                	mv	a0,s6
 8b6:	e3fff0ef          	jal	6f4 <printint>
        i += 1;
 8ba:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8bc:	8bca                	mv	s7,s2
      state = 0;
 8be:	4981                	li	s3,0
        i += 1;
 8c0:	b725                	j	7e8 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8c2:	06400793          	li	a5,100
 8c6:	02f60763          	beq	a2,a5,8f4 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8ca:	07500793          	li	a5,117
 8ce:	06f60963          	beq	a2,a5,940 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8d2:	07800793          	li	a5,120
 8d6:	faf61ee3          	bne	a2,a5,892 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8da:	008b8913          	add	s2,s7,8
 8de:	4681                	li	a3,0
 8e0:	4641                	li	a2,16
 8e2:	000ba583          	lw	a1,0(s7)
 8e6:	855a                	mv	a0,s6
 8e8:	e0dff0ef          	jal	6f4 <printint>
        i += 2;
 8ec:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 8ee:	8bca                	mv	s7,s2
      state = 0;
 8f0:	4981                	li	s3,0
        i += 2;
 8f2:	bddd                	j	7e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8f4:	008b8913          	add	s2,s7,8
 8f8:	4685                	li	a3,1
 8fa:	4629                	li	a2,10
 8fc:	000ba583          	lw	a1,0(s7)
 900:	855a                	mv	a0,s6
 902:	df3ff0ef          	jal	6f4 <printint>
        i += 2;
 906:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 908:	8bca                	mv	s7,s2
      state = 0;
 90a:	4981                	li	s3,0
        i += 2;
 90c:	bdf1                	j	7e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 90e:	008b8913          	add	s2,s7,8
 912:	4681                	li	a3,0
 914:	4629                	li	a2,10
 916:	000ba583          	lw	a1,0(s7)
 91a:	855a                	mv	a0,s6
 91c:	dd9ff0ef          	jal	6f4 <printint>
 920:	8bca                	mv	s7,s2
      state = 0;
 922:	4981                	li	s3,0
 924:	b5d1                	j	7e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 926:	008b8913          	add	s2,s7,8
 92a:	4681                	li	a3,0
 92c:	4629                	li	a2,10
 92e:	000ba583          	lw	a1,0(s7)
 932:	855a                	mv	a0,s6
 934:	dc1ff0ef          	jal	6f4 <printint>
        i += 1;
 938:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 93a:	8bca                	mv	s7,s2
      state = 0;
 93c:	4981                	li	s3,0
        i += 1;
 93e:	b56d                	j	7e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 940:	008b8913          	add	s2,s7,8
 944:	4681                	li	a3,0
 946:	4629                	li	a2,10
 948:	000ba583          	lw	a1,0(s7)
 94c:	855a                	mv	a0,s6
 94e:	da7ff0ef          	jal	6f4 <printint>
        i += 2;
 952:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 954:	8bca                	mv	s7,s2
      state = 0;
 956:	4981                	li	s3,0
        i += 2;
 958:	bd41                	j	7e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 95a:	008b8913          	add	s2,s7,8
 95e:	4681                	li	a3,0
 960:	4641                	li	a2,16
 962:	000ba583          	lw	a1,0(s7)
 966:	855a                	mv	a0,s6
 968:	d8dff0ef          	jal	6f4 <printint>
 96c:	8bca                	mv	s7,s2
      state = 0;
 96e:	4981                	li	s3,0
 970:	bda5                	j	7e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 972:	008b8913          	add	s2,s7,8
 976:	4681                	li	a3,0
 978:	4641                	li	a2,16
 97a:	000ba583          	lw	a1,0(s7)
 97e:	855a                	mv	a0,s6
 980:	d75ff0ef          	jal	6f4 <printint>
        i += 1;
 984:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 986:	8bca                	mv	s7,s2
      state = 0;
 988:	4981                	li	s3,0
        i += 1;
 98a:	bdb9                	j	7e8 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 98c:	008b8d13          	add	s10,s7,8
 990:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 994:	03000593          	li	a1,48
 998:	855a                	mv	a0,s6
 99a:	d3dff0ef          	jal	6d6 <putc>
  putc(fd, 'x');
 99e:	07800593          	li	a1,120
 9a2:	855a                	mv	a0,s6
 9a4:	d33ff0ef          	jal	6d6 <putc>
 9a8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9aa:	00000b97          	auipc	s7,0x0
 9ae:	24eb8b93          	add	s7,s7,590 # bf8 <digits>
 9b2:	03c9d793          	srl	a5,s3,0x3c
 9b6:	97de                	add	a5,a5,s7
 9b8:	0007c583          	lbu	a1,0(a5)
 9bc:	855a                	mv	a0,s6
 9be:	d19ff0ef          	jal	6d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9c2:	0992                	sll	s3,s3,0x4
 9c4:	397d                	addw	s2,s2,-1
 9c6:	fe0916e3          	bnez	s2,9b2 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 9ca:	8bea                	mv	s7,s10
      state = 0;
 9cc:	4981                	li	s3,0
 9ce:	bd29                	j	7e8 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 9d0:	008b8993          	add	s3,s7,8
 9d4:	000bb903          	ld	s2,0(s7)
 9d8:	00090f63          	beqz	s2,9f6 <vprintf+0x25a>
        for(; *s; s++)
 9dc:	00094583          	lbu	a1,0(s2)
 9e0:	c195                	beqz	a1,a04 <vprintf+0x268>
          putc(fd, *s);
 9e2:	855a                	mv	a0,s6
 9e4:	cf3ff0ef          	jal	6d6 <putc>
        for(; *s; s++)
 9e8:	0905                	add	s2,s2,1
 9ea:	00094583          	lbu	a1,0(s2)
 9ee:	f9f5                	bnez	a1,9e2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 9f0:	8bce                	mv	s7,s3
      state = 0;
 9f2:	4981                	li	s3,0
 9f4:	bbd5                	j	7e8 <vprintf+0x4c>
          s = "(null)";
 9f6:	00000917          	auipc	s2,0x0
 9fa:	1fa90913          	add	s2,s2,506 # bf0 <malloc+0xec>
        for(; *s; s++)
 9fe:	02800593          	li	a1,40
 a02:	b7c5                	j	9e2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 a04:	8bce                	mv	s7,s3
      state = 0;
 a06:	4981                	li	s3,0
 a08:	b3c5                	j	7e8 <vprintf+0x4c>
    }
  }
}
 a0a:	60e6                	ld	ra,88(sp)
 a0c:	6446                	ld	s0,80(sp)
 a0e:	64a6                	ld	s1,72(sp)
 a10:	6906                	ld	s2,64(sp)
 a12:	79e2                	ld	s3,56(sp)
 a14:	7a42                	ld	s4,48(sp)
 a16:	7aa2                	ld	s5,40(sp)
 a18:	7b02                	ld	s6,32(sp)
 a1a:	6be2                	ld	s7,24(sp)
 a1c:	6c42                	ld	s8,16(sp)
 a1e:	6ca2                	ld	s9,8(sp)
 a20:	6d02                	ld	s10,0(sp)
 a22:	6125                	add	sp,sp,96
 a24:	8082                	ret

0000000000000a26 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a26:	715d                	add	sp,sp,-80
 a28:	ec06                	sd	ra,24(sp)
 a2a:	e822                	sd	s0,16(sp)
 a2c:	1000                	add	s0,sp,32
 a2e:	e010                	sd	a2,0(s0)
 a30:	e414                	sd	a3,8(s0)
 a32:	e818                	sd	a4,16(s0)
 a34:	ec1c                	sd	a5,24(s0)
 a36:	03043023          	sd	a6,32(s0)
 a3a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a3e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a42:	8622                	mv	a2,s0
 a44:	d59ff0ef          	jal	79c <vprintf>
}
 a48:	60e2                	ld	ra,24(sp)
 a4a:	6442                	ld	s0,16(sp)
 a4c:	6161                	add	sp,sp,80
 a4e:	8082                	ret

0000000000000a50 <printf>:

void
printf(const char *fmt, ...)
{
 a50:	711d                	add	sp,sp,-96
 a52:	ec06                	sd	ra,24(sp)
 a54:	e822                	sd	s0,16(sp)
 a56:	1000                	add	s0,sp,32
 a58:	e40c                	sd	a1,8(s0)
 a5a:	e810                	sd	a2,16(s0)
 a5c:	ec14                	sd	a3,24(s0)
 a5e:	f018                	sd	a4,32(s0)
 a60:	f41c                	sd	a5,40(s0)
 a62:	03043823          	sd	a6,48(s0)
 a66:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a6a:	00840613          	add	a2,s0,8
 a6e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a72:	85aa                	mv	a1,a0
 a74:	4505                	li	a0,1
 a76:	d27ff0ef          	jal	79c <vprintf>
}
 a7a:	60e2                	ld	ra,24(sp)
 a7c:	6442                	ld	s0,16(sp)
 a7e:	6125                	add	sp,sp,96
 a80:	8082                	ret

0000000000000a82 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a82:	1141                	add	sp,sp,-16
 a84:	e422                	sd	s0,8(sp)
 a86:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a88:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a8c:	00000797          	auipc	a5,0x0
 a90:	5847b783          	ld	a5,1412(a5) # 1010 <freep>
 a94:	a02d                	j	abe <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a96:	4618                	lw	a4,8(a2)
 a98:	9f2d                	addw	a4,a4,a1
 a9a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a9e:	6398                	ld	a4,0(a5)
 aa0:	6310                	ld	a2,0(a4)
 aa2:	a83d                	j	ae0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 aa4:	ff852703          	lw	a4,-8(a0)
 aa8:	9f31                	addw	a4,a4,a2
 aaa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 aac:	ff053683          	ld	a3,-16(a0)
 ab0:	a091                	j	af4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ab2:	6398                	ld	a4,0(a5)
 ab4:	00e7e463          	bltu	a5,a4,abc <free+0x3a>
 ab8:	00e6ea63          	bltu	a3,a4,acc <free+0x4a>
{
 abc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 abe:	fed7fae3          	bgeu	a5,a3,ab2 <free+0x30>
 ac2:	6398                	ld	a4,0(a5)
 ac4:	00e6e463          	bltu	a3,a4,acc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac8:	fee7eae3          	bltu	a5,a4,abc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 acc:	ff852583          	lw	a1,-8(a0)
 ad0:	6390                	ld	a2,0(a5)
 ad2:	02059813          	sll	a6,a1,0x20
 ad6:	01c85713          	srl	a4,a6,0x1c
 ada:	9736                	add	a4,a4,a3
 adc:	fae60de3          	beq	a2,a4,a96 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 ae0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ae4:	4790                	lw	a2,8(a5)
 ae6:	02061593          	sll	a1,a2,0x20
 aea:	01c5d713          	srl	a4,a1,0x1c
 aee:	973e                	add	a4,a4,a5
 af0:	fae68ae3          	beq	a3,a4,aa4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 af4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 af6:	00000717          	auipc	a4,0x0
 afa:	50f73d23          	sd	a5,1306(a4) # 1010 <freep>
}
 afe:	6422                	ld	s0,8(sp)
 b00:	0141                	add	sp,sp,16
 b02:	8082                	ret

0000000000000b04 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b04:	7139                	add	sp,sp,-64
 b06:	fc06                	sd	ra,56(sp)
 b08:	f822                	sd	s0,48(sp)
 b0a:	f426                	sd	s1,40(sp)
 b0c:	f04a                	sd	s2,32(sp)
 b0e:	ec4e                	sd	s3,24(sp)
 b10:	e852                	sd	s4,16(sp)
 b12:	e456                	sd	s5,8(sp)
 b14:	e05a                	sd	s6,0(sp)
 b16:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b18:	02051493          	sll	s1,a0,0x20
 b1c:	9081                	srl	s1,s1,0x20
 b1e:	04bd                	add	s1,s1,15
 b20:	8091                	srl	s1,s1,0x4
 b22:	0014899b          	addw	s3,s1,1
 b26:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 b28:	00000517          	auipc	a0,0x0
 b2c:	4e853503          	ld	a0,1256(a0) # 1010 <freep>
 b30:	c515                	beqz	a0,b5c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b32:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b34:	4798                	lw	a4,8(a5)
 b36:	02977f63          	bgeu	a4,s1,b74 <malloc+0x70>
  if(nu < 4096)
 b3a:	8a4e                	mv	s4,s3
 b3c:	0009871b          	sext.w	a4,s3
 b40:	6685                	lui	a3,0x1
 b42:	00d77363          	bgeu	a4,a3,b48 <malloc+0x44>
 b46:	6a05                	lui	s4,0x1
 b48:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b4c:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b50:	00000917          	auipc	s2,0x0
 b54:	4c090913          	add	s2,s2,1216 # 1010 <freep>
  if(p == (char*)-1)
 b58:	5afd                	li	s5,-1
 b5a:	a885                	j	bca <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 b5c:	00000797          	auipc	a5,0x0
 b60:	4c478793          	add	a5,a5,1220 # 1020 <base>
 b64:	00000717          	auipc	a4,0x0
 b68:	4af73623          	sd	a5,1196(a4) # 1010 <freep>
 b6c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b6e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b72:	b7e1                	j	b3a <malloc+0x36>
      if(p->s.size == nunits)
 b74:	02e48c63          	beq	s1,a4,bac <malloc+0xa8>
        p->s.size -= nunits;
 b78:	4137073b          	subw	a4,a4,s3
 b7c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b7e:	02071693          	sll	a3,a4,0x20
 b82:	01c6d713          	srl	a4,a3,0x1c
 b86:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b88:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b8c:	00000717          	auipc	a4,0x0
 b90:	48a73223          	sd	a0,1156(a4) # 1010 <freep>
      return (void*)(p + 1);
 b94:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b98:	70e2                	ld	ra,56(sp)
 b9a:	7442                	ld	s0,48(sp)
 b9c:	74a2                	ld	s1,40(sp)
 b9e:	7902                	ld	s2,32(sp)
 ba0:	69e2                	ld	s3,24(sp)
 ba2:	6a42                	ld	s4,16(sp)
 ba4:	6aa2                	ld	s5,8(sp)
 ba6:	6b02                	ld	s6,0(sp)
 ba8:	6121                	add	sp,sp,64
 baa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bac:	6398                	ld	a4,0(a5)
 bae:	e118                	sd	a4,0(a0)
 bb0:	bff1                	j	b8c <malloc+0x88>
  hp->s.size = nu;
 bb2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bb6:	0541                	add	a0,a0,16
 bb8:	ecbff0ef          	jal	a82 <free>
  return freep;
 bbc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bc0:	dd61                	beqz	a0,b98 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bc2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bc4:	4798                	lw	a4,8(a5)
 bc6:	fa9777e3          	bgeu	a4,s1,b74 <malloc+0x70>
    if(p == freep)
 bca:	00093703          	ld	a4,0(s2)
 bce:	853e                	mv	a0,a5
 bd0:	fef719e3          	bne	a4,a5,bc2 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 bd4:	8552                	mv	a0,s4
 bd6:	ab1ff0ef          	jal	686 <sbrk>
  if(p == (char*)-1)
 bda:	fd551ce3          	bne	a0,s5,bb2 <malloc+0xae>
        return 0;
 bde:	4501                	li	a0,0
 be0:	bf65                	j	b98 <malloc+0x94>
