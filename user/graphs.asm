
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
 104:	84ae                	mv	s1,a1
    int pid = getpid();
 106:	586000ef          	jal	68c <getpid>
 10a:	85aa                	mv	a1,a0

    set_type(CPU_BOUND, pid);
 10c:	4509                	li	a0,2
 10e:	5de000ef          	jal	6ec <set_type>

    int index = 0;
    index += (argv[1][0] - '0') * 10;
 112:	6494                	ld	a3,8(s1)
 114:	0006c703          	lbu	a4,0(a3)
 118:	fd07071b          	addw	a4,a4,-48 # 7fffffd0 <base+0x7fffefb0>
 11c:	0027179b          	sllw	a5,a4,0x2
 120:	9fb9                	addw	a5,a5,a4
 122:	0017979b          	sllw	a5,a5,0x1
    index += (argv[1][1] - '0');
 126:	0016c703          	lbu	a4,1(a3)
 12a:	fd07071b          	addw	a4,a4,-48
 12e:	9fb9                	addw	a5,a5,a4
 130:	c4f43023          	sd	a5,-960(s0)
 134:	3e800793          	li	a5,1000
 138:	c4f43c23          	sd	a5,-936(s0)

    int t0, t1;
    int tempo_overhead = 0;
 13c:	4c01                	li	s8,0
        
        //gerar arestas aleatórias
        int u, v;
        for (int j = 0; j < num_edges; j++){
            generate_random_edge(matrix, num_vertices, &u, &v);
            matrix[u][v] = 1;
 13e:	4b85                	li	s7,1
 140:	a87d                	j	1fe <main+0x134>
        int esq = 0;
        int dir = 0;
        int atual;
        while (esq <= dir) {
            atual = fila[esq];
            for (int j = 0; j < num_vertices; j++){
 142:	0785                	add	a5,a5,1
 144:	0691                	add	a3,a3,4
 146:	0007871b          	sext.w	a4,a5
 14a:	02977263          	bgeu	a4,s1,16e <main+0xa4>
                if (matrix[atual][j] && !visitado[j]){
 14e:	6198                	ld	a4,0(a1)
 150:	00279613          	sll	a2,a5,0x2
 154:	9732                	add	a4,a4,a2
 156:	4318                	lw	a4,0(a4)
 158:	d76d                	beqz	a4,142 <main+0x78>
 15a:	4298                	lw	a4,0(a3)
 15c:	f37d                	bnez	a4,142 <main+0x78>
                    visitado[j] = 1;
 15e:	0176a023          	sw	s7,0(a3)
                    distancia[j] = distancia[atual] + 1;
                    dir++;
 162:	2505                	addw	a0,a0,1
                    fila[dir] = j;
 164:	00251713          	sll	a4,a0,0x2
 168:	974e                	add	a4,a4,s3
 16a:	c31c                	sw	a5,0(a4)
 16c:	bfd9                	j	142 <main+0x78>
                }
            }
            esq++;
 16e:	2805                	addw	a6,a6,1
        while (esq <= dir) {
 170:	0891                	add	a7,a7,4
 172:	01054b63          	blt	a0,a6,188 <main+0xbe>
            atual = fila[esq];
 176:	0008a583          	lw	a1,0(a7)
            for (int j = 0; j < num_vertices; j++){
 17a:	d8f5                	beqz	s1,16e <main+0xa4>
                if (matrix[atual][j] && !visitado[j]){
 17c:	058e                	sll	a1,a1,0x3
 17e:	95da                	add	a1,a1,s6
 180:	c7040693          	add	a3,s0,-912
 184:	4781                	li	a5,0
 186:	b7e1                	j	14e <main+0x84>
        }

        //libera a matrix
        t0 = uptime_nolock();
 188:	55c000ef          	jal	6e4 <uptime_nolock>
 18c:	892a                	mv	s2,a0
        free(fila);
 18e:	854e                	mv	a0,s3
 190:	111000ef          	jal	aa0 <free>
        t1 = uptime_nolock();
 194:	550000ef          	jal	6e4 <uptime_nolock>
        tempo_overhead+= t1 - t0;
 198:	4125093b          	subw	s2,a0,s2
 19c:	0149093b          	addw	s2,s2,s4
        for (int i = 0; i < num_vertices; i++) {
 1a0:	cc85                	beqz	s1,1d8 <main+0x10e>
 1a2:	84da                	mv	s1,s6
 1a4:	c4c42783          	lw	a5,-948(s0)
 1a8:	0637899b          	addw	s3,a5,99
 1ac:	02099793          	sll	a5,s3,0x20
 1b0:	01d7d993          	srl	s3,a5,0x1d
 1b4:	008b0793          	add	a5,s6,8
 1b8:	99be                	add	s3,s3,a5
            t0 = uptime_nolock();
 1ba:	52a000ef          	jal	6e4 <uptime_nolock>
 1be:	8a2a                	mv	s4,a0
            free(matrix[i]); 
 1c0:	6088                	ld	a0,0(s1)
 1c2:	0df000ef          	jal	aa0 <free>
            t1 = uptime_nolock();
 1c6:	51e000ef          	jal	6e4 <uptime_nolock>
            tempo_overhead+= t1 - t0; 
 1ca:	4145053b          	subw	a0,a0,s4
 1ce:	0125093b          	addw	s2,a0,s2
        for (int i = 0; i < num_vertices; i++) {
 1d2:	04a1                	add	s1,s1,8
 1d4:	fe9993e3          	bne	s3,s1,1ba <main+0xf0>
        }
        t0 = uptime_nolock();
 1d8:	50c000ef          	jal	6e4 <uptime_nolock>
 1dc:	8c2a                	mv	s8,a0
        free(matrix);
 1de:	855a                	mv	a0,s6
 1e0:	0c1000ef          	jal	aa0 <free>
        t1 = uptime_nolock();
 1e4:	500000ef          	jal	6e4 <uptime_nolock>
        tempo_overhead+= t1 - t0;
 1e8:	41850c3b          	subw	s8,a0,s8
 1ec:	012c0c3b          	addw	s8,s8,s2
    for (int i = 0; i < max_iter; i++){
 1f0:	c5843783          	ld	a5,-936(s0)
 1f4:	37fd                	addw	a5,a5,-1
 1f6:	c4f43c23          	sd	a5,-936(s0)
 1fa:	14078463          	beqz	a5,342 <main+0x278>
        uint num_vertices = (rand() % 101) + 100;
 1fe:	e5bff0ef          	jal	58 <rand>
 202:	06500793          	li	a5,101
 206:	02f569bb          	remw	s3,a0,a5
 20a:	c5342623          	sw	s3,-948(s0)
 20e:	06498c9b          	addw	s9,s3,100
 212:	000c8d9b          	sext.w	s11,s9
 216:	84ee                	mv	s1,s11
        int num_edges = (rand() % 351) + 50;
 218:	e41ff0ef          	jal	58 <rand>
 21c:	15f00793          	li	a5,351
 220:	02f567bb          	remw	a5,a0,a5
 224:	c4f42423          	sw	a5,-952(s0)
 228:	2781                	sext.w	a5,a5
 22a:	c4f43823          	sd	a5,-944(s0)
        t0 = uptime_nolock();
 22e:	4b6000ef          	jal	6e4 <uptime_nolock>
 232:	892a                	mv	s2,a0
        int **matrix = malloc(num_vertices * sizeof(int *));
 234:	003c951b          	sllw	a0,s9,0x3
 238:	0eb000ef          	jal	b22 <malloc>
 23c:	8b2a                	mv	s6,a0
        t1 = uptime_nolock();
 23e:	4a6000ef          	jal	6e4 <uptime_nolock>
        tempo_overhead+= t1 - t0;
 242:	412507bb          	subw	a5,a0,s2
 246:	01878c3b          	addw	s8,a5,s8
        for (int j = 0; j < num_vertices; j++){
 24a:	040d8c63          	beqz	s11,2a2 <main+0x1d8>
            matrix[j] = malloc(num_vertices * sizeof(int));
 24e:	002c9c9b          	sllw	s9,s9,0x2
 252:	8a5a                	mv	s4,s6
 254:	0639879b          	addw	a5,s3,99
 258:	1782                	sll	a5,a5,0x20
 25a:	9381                	srl	a5,a5,0x20
 25c:	008b0d13          	add	s10,s6,8
 260:	00379713          	sll	a4,a5,0x3
 264:	9d3a                	add	s10,s10,a4
 266:	0785                	add	a5,a5,1
 268:	00279993          	sll	s3,a5,0x2
            t0 = uptime_nolock();
 26c:	478000ef          	jal	6e4 <uptime_nolock>
 270:	8aaa                	mv	s5,a0
            matrix[j] = malloc(num_vertices * sizeof(int));
 272:	8566                	mv	a0,s9
 274:	0af000ef          	jal	b22 <malloc>
 278:	8952                	mv	s2,s4
 27a:	00aa3023          	sd	a0,0(s4)
            t1 = uptime_nolock();
 27e:	466000ef          	jal	6e4 <uptime_nolock>
            tempo_overhead+= t1 - t0;
 282:	4155053b          	subw	a0,a0,s5
 286:	01850c3b          	addw	s8,a0,s8
 28a:	4781                	li	a5,0
                matrix[j][k] = 0;
 28c:	00093703          	ld	a4,0(s2)
 290:	973e                	add	a4,a4,a5
 292:	00072023          	sw	zero,0(a4)
            for (int k = 0; k < num_vertices; k++){
 296:	0791                	add	a5,a5,4
 298:	fef99ae3          	bne	s3,a5,28c <main+0x1c2>
        for (int j = 0; j < num_vertices; j++){
 29c:	0a21                	add	s4,s4,8
 29e:	fdaa17e3          	bne	s4,s10,26c <main+0x1a2>
        for (int j = 0; j < num_edges; j++){
 2a2:	fcf00793          	li	a5,-49
 2a6:	c5043703          	ld	a4,-944(s0)
 2aa:	02f74d63          	blt	a4,a5,2e4 <main+0x21a>
 2ae:	c4842783          	lw	a5,-952(s0)
 2b2:	0327899b          	addw	s3,a5,50
 2b6:	4901                	li	s2,0
            generate_random_edge(matrix, num_vertices, &u, &v);
 2b8:	c6c40693          	add	a3,s0,-916
 2bc:	c6840613          	add	a2,s0,-920
 2c0:	85ee                	mv	a1,s11
 2c2:	855a                	mv	a0,s6
 2c4:	db1ff0ef          	jal	74 <generate_random_edge>
            matrix[u][v] = 1;
 2c8:	c6842783          	lw	a5,-920(s0)
 2cc:	078e                	sll	a5,a5,0x3
 2ce:	97da                	add	a5,a5,s6
 2d0:	c6c42703          	lw	a4,-916(s0)
 2d4:	639c                	ld	a5,0(a5)
 2d6:	070a                	sll	a4,a4,0x2
 2d8:	97ba                	add	a5,a5,a4
 2da:	0177a023          	sw	s7,0(a5)
        for (int j = 0; j < num_edges; j++){
 2de:	2905                	addw	s2,s2,1
 2e0:	fd391ce3          	bne	s2,s3,2b8 <main+0x1ee>
            u = rand() % num_vertices;
 2e4:	d75ff0ef          	jal	58 <rand>
 2e8:	0295793b          	remuw	s2,a0,s1
 2ec:	0009099b          	sext.w	s3,s2
 2f0:	c7242423          	sw	s2,-920(s0)
            v = rand() % num_vertices;
 2f4:	d65ff0ef          	jal	58 <rand>
 2f8:	0295753b          	remuw	a0,a0,s1
 2fc:	0005079b          	sext.w	a5,a0
 300:	c6a42623          	sw	a0,-916(s0)
        } while (u == v);
 304:	fef980e3          	beq	s3,a5,2e4 <main+0x21a>
        t0 = uptime_nolock();
 308:	3dc000ef          	jal	6e4 <uptime_nolock>
 30c:	8a2a                	mv	s4,a0
        int *fila = malloc(tam * sizeof(int));
 30e:	64000513          	li	a0,1600
 312:	011000ef          	jal	b22 <malloc>
 316:	89aa                	mv	s3,a0
        t1 = uptime_nolock();
 318:	3cc000ef          	jal	6e4 <uptime_nolock>
        tempo_overhead+= t1 - t0;
 31c:	41450a3b          	subw	s4,a0,s4
 320:	018a0a3b          	addw	s4,s4,s8
        for (int i = 0; i < 200; i++){
 324:	f9040713          	add	a4,s0,-112
        tempo_overhead+= t1 - t0;
 328:	c7040793          	add	a5,s0,-912
            visitado[i] = 0;
 32c:	0007a023          	sw	zero,0(a5)
        for (int i = 0; i < 200; i++){
 330:	0791                	add	a5,a5,4
 332:	fee79de3          	bne	a5,a4,32c <main+0x262>
        fila[0] = u;
 336:	0129a023          	sw	s2,0(s3)
        while (esq <= dir) {
 33a:	88ce                	mv	a7,s3
        int dir = 0;
 33c:	4501                	li	a0,0
        int esq = 0;
 33e:	4801                	li	a6,0
 340:	bd1d                	j	176 <main+0xac>

    }

    increment_metric(index, -1, MODE_EFICIENCIA);
 342:	4629                	li	a2,10
 344:	55fd                	li	a1,-1
 346:	c4043483          	ld	s1,-960(s0)
 34a:	8526                	mv	a0,s1
 34c:	378000ef          	jal	6c4 <increment_metric>
    increment_metric(index, tempo_overhead, MODE_OVERHEAD);
 350:	4621                	li	a2,8
 352:	85e2                	mv	a1,s8
 354:	8526                	mv	a0,s1
 356:	36e000ef          	jal	6c4 <increment_metric>

    pid = getpid();
 35a:	332000ef          	jal	68c <getpid>
 35e:	85aa                	mv	a1,a0
    set_justica(index, pid);
 360:	8526                	mv	a0,s1
 362:	37a000ef          	jal	6dc <set_justica>

    return 0;
 366:	4501                	li	a0,0
 368:	3b813083          	ld	ra,952(sp)
 36c:	3b013403          	ld	s0,944(sp)
 370:	3a813483          	ld	s1,936(sp)
 374:	3a013903          	ld	s2,928(sp)
 378:	39813983          	ld	s3,920(sp)
 37c:	39013a03          	ld	s4,912(sp)
 380:	38813a83          	ld	s5,904(sp)
 384:	38013b03          	ld	s6,896(sp)
 388:	37813b83          	ld	s7,888(sp)
 38c:	37013c03          	ld	s8,880(sp)
 390:	36813c83          	ld	s9,872(sp)
 394:	36013d03          	ld	s10,864(sp)
 398:	35813d83          	ld	s11,856(sp)
 39c:	3c010113          	add	sp,sp,960
 3a0:	8082                	ret

00000000000003a2 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 3a2:	1141                	add	sp,sp,-16
 3a4:	e406                	sd	ra,8(sp)
 3a6:	e022                	sd	s0,0(sp)
 3a8:	0800                	add	s0,sp,16
  extern int main();
  main();
 3aa:	d21ff0ef          	jal	ca <main>
  exit(0);
 3ae:	4501                	li	a0,0
 3b0:	25c000ef          	jal	60c <exit>

00000000000003b4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3b4:	1141                	add	sp,sp,-16
 3b6:	e422                	sd	s0,8(sp)
 3b8:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3ba:	87aa                	mv	a5,a0
 3bc:	0585                	add	a1,a1,1
 3be:	0785                	add	a5,a5,1
 3c0:	fff5c703          	lbu	a4,-1(a1)
 3c4:	fee78fa3          	sb	a4,-1(a5)
 3c8:	fb75                	bnez	a4,3bc <strcpy+0x8>
    ;
  return os;
}
 3ca:	6422                	ld	s0,8(sp)
 3cc:	0141                	add	sp,sp,16
 3ce:	8082                	ret

00000000000003d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3d0:	1141                	add	sp,sp,-16
 3d2:	e422                	sd	s0,8(sp)
 3d4:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 3d6:	00054783          	lbu	a5,0(a0)
 3da:	cb91                	beqz	a5,3ee <strcmp+0x1e>
 3dc:	0005c703          	lbu	a4,0(a1)
 3e0:	00f71763          	bne	a4,a5,3ee <strcmp+0x1e>
    p++, q++;
 3e4:	0505                	add	a0,a0,1
 3e6:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 3e8:	00054783          	lbu	a5,0(a0)
 3ec:	fbe5                	bnez	a5,3dc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3ee:	0005c503          	lbu	a0,0(a1)
}
 3f2:	40a7853b          	subw	a0,a5,a0
 3f6:	6422                	ld	s0,8(sp)
 3f8:	0141                	add	sp,sp,16
 3fa:	8082                	ret

00000000000003fc <strlen>:

uint
strlen(const char *s)
{
 3fc:	1141                	add	sp,sp,-16
 3fe:	e422                	sd	s0,8(sp)
 400:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 402:	00054783          	lbu	a5,0(a0)
 406:	cf91                	beqz	a5,422 <strlen+0x26>
 408:	0505                	add	a0,a0,1
 40a:	87aa                	mv	a5,a0
 40c:	86be                	mv	a3,a5
 40e:	0785                	add	a5,a5,1
 410:	fff7c703          	lbu	a4,-1(a5)
 414:	ff65                	bnez	a4,40c <strlen+0x10>
 416:	40a6853b          	subw	a0,a3,a0
 41a:	2505                	addw	a0,a0,1
    ;
  return n;
}
 41c:	6422                	ld	s0,8(sp)
 41e:	0141                	add	sp,sp,16
 420:	8082                	ret
  for(n = 0; s[n]; n++)
 422:	4501                	li	a0,0
 424:	bfe5                	j	41c <strlen+0x20>

0000000000000426 <memset>:

void*
memset(void *dst, int c, uint n)
{
 426:	1141                	add	sp,sp,-16
 428:	e422                	sd	s0,8(sp)
 42a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 42c:	ca19                	beqz	a2,442 <memset+0x1c>
 42e:	87aa                	mv	a5,a0
 430:	1602                	sll	a2,a2,0x20
 432:	9201                	srl	a2,a2,0x20
 434:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 438:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 43c:	0785                	add	a5,a5,1
 43e:	fee79de3          	bne	a5,a4,438 <memset+0x12>
  }
  return dst;
}
 442:	6422                	ld	s0,8(sp)
 444:	0141                	add	sp,sp,16
 446:	8082                	ret

0000000000000448 <strchr>:

char*
strchr(const char *s, char c)
{
 448:	1141                	add	sp,sp,-16
 44a:	e422                	sd	s0,8(sp)
 44c:	0800                	add	s0,sp,16
  for(; *s; s++)
 44e:	00054783          	lbu	a5,0(a0)
 452:	cb99                	beqz	a5,468 <strchr+0x20>
    if(*s == c)
 454:	00f58763          	beq	a1,a5,462 <strchr+0x1a>
  for(; *s; s++)
 458:	0505                	add	a0,a0,1
 45a:	00054783          	lbu	a5,0(a0)
 45e:	fbfd                	bnez	a5,454 <strchr+0xc>
      return (char*)s;
  return 0;
 460:	4501                	li	a0,0
}
 462:	6422                	ld	s0,8(sp)
 464:	0141                	add	sp,sp,16
 466:	8082                	ret
  return 0;
 468:	4501                	li	a0,0
 46a:	bfe5                	j	462 <strchr+0x1a>

000000000000046c <gets>:

char*
gets(char *buf, int max)
{
 46c:	711d                	add	sp,sp,-96
 46e:	ec86                	sd	ra,88(sp)
 470:	e8a2                	sd	s0,80(sp)
 472:	e4a6                	sd	s1,72(sp)
 474:	e0ca                	sd	s2,64(sp)
 476:	fc4e                	sd	s3,56(sp)
 478:	f852                	sd	s4,48(sp)
 47a:	f456                	sd	s5,40(sp)
 47c:	f05a                	sd	s6,32(sp)
 47e:	ec5e                	sd	s7,24(sp)
 480:	1080                	add	s0,sp,96
 482:	8baa                	mv	s7,a0
 484:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 486:	892a                	mv	s2,a0
 488:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 48a:	4aa9                	li	s5,10
 48c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 48e:	89a6                	mv	s3,s1
 490:	2485                	addw	s1,s1,1
 492:	0344d663          	bge	s1,s4,4be <gets+0x52>
    cc = read(0, &c, 1);
 496:	4605                	li	a2,1
 498:	faf40593          	add	a1,s0,-81
 49c:	4501                	li	a0,0
 49e:	186000ef          	jal	624 <read>
    if(cc < 1)
 4a2:	00a05e63          	blez	a0,4be <gets+0x52>
    buf[i++] = c;
 4a6:	faf44783          	lbu	a5,-81(s0)
 4aa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4ae:	01578763          	beq	a5,s5,4bc <gets+0x50>
 4b2:	0905                	add	s2,s2,1
 4b4:	fd679de3          	bne	a5,s6,48e <gets+0x22>
  for(i=0; i+1 < max; ){
 4b8:	89a6                	mv	s3,s1
 4ba:	a011                	j	4be <gets+0x52>
 4bc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4be:	99de                	add	s3,s3,s7
 4c0:	00098023          	sb	zero,0(s3)
  return buf;
}
 4c4:	855e                	mv	a0,s7
 4c6:	60e6                	ld	ra,88(sp)
 4c8:	6446                	ld	s0,80(sp)
 4ca:	64a6                	ld	s1,72(sp)
 4cc:	6906                	ld	s2,64(sp)
 4ce:	79e2                	ld	s3,56(sp)
 4d0:	7a42                	ld	s4,48(sp)
 4d2:	7aa2                	ld	s5,40(sp)
 4d4:	7b02                	ld	s6,32(sp)
 4d6:	6be2                	ld	s7,24(sp)
 4d8:	6125                	add	sp,sp,96
 4da:	8082                	ret

00000000000004dc <stat>:

int
stat(const char *n, struct stat *st)
{
 4dc:	1101                	add	sp,sp,-32
 4de:	ec06                	sd	ra,24(sp)
 4e0:	e822                	sd	s0,16(sp)
 4e2:	e426                	sd	s1,8(sp)
 4e4:	e04a                	sd	s2,0(sp)
 4e6:	1000                	add	s0,sp,32
 4e8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4ea:	4581                	li	a1,0
 4ec:	160000ef          	jal	64c <open>
  if(fd < 0)
 4f0:	02054163          	bltz	a0,512 <stat+0x36>
 4f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4f6:	85ca                	mv	a1,s2
 4f8:	16c000ef          	jal	664 <fstat>
 4fc:	892a                	mv	s2,a0
  close(fd);
 4fe:	8526                	mv	a0,s1
 500:	134000ef          	jal	634 <close>
  return r;
}
 504:	854a                	mv	a0,s2
 506:	60e2                	ld	ra,24(sp)
 508:	6442                	ld	s0,16(sp)
 50a:	64a2                	ld	s1,8(sp)
 50c:	6902                	ld	s2,0(sp)
 50e:	6105                	add	sp,sp,32
 510:	8082                	ret
    return -1;
 512:	597d                	li	s2,-1
 514:	bfc5                	j	504 <stat+0x28>

0000000000000516 <atoi>:

int
atoi(const char *s)
{
 516:	1141                	add	sp,sp,-16
 518:	e422                	sd	s0,8(sp)
 51a:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 51c:	00054683          	lbu	a3,0(a0)
 520:	fd06879b          	addw	a5,a3,-48
 524:	0ff7f793          	zext.b	a5,a5
 528:	4625                	li	a2,9
 52a:	02f66863          	bltu	a2,a5,55a <atoi+0x44>
 52e:	872a                	mv	a4,a0
  n = 0;
 530:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 532:	0705                	add	a4,a4,1
 534:	0025179b          	sllw	a5,a0,0x2
 538:	9fa9                	addw	a5,a5,a0
 53a:	0017979b          	sllw	a5,a5,0x1
 53e:	9fb5                	addw	a5,a5,a3
 540:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 544:	00074683          	lbu	a3,0(a4)
 548:	fd06879b          	addw	a5,a3,-48
 54c:	0ff7f793          	zext.b	a5,a5
 550:	fef671e3          	bgeu	a2,a5,532 <atoi+0x1c>
  return n;
}
 554:	6422                	ld	s0,8(sp)
 556:	0141                	add	sp,sp,16
 558:	8082                	ret
  n = 0;
 55a:	4501                	li	a0,0
 55c:	bfe5                	j	554 <atoi+0x3e>

000000000000055e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 55e:	1141                	add	sp,sp,-16
 560:	e422                	sd	s0,8(sp)
 562:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 564:	02b57463          	bgeu	a0,a1,58c <memmove+0x2e>
    while(n-- > 0)
 568:	00c05f63          	blez	a2,586 <memmove+0x28>
 56c:	1602                	sll	a2,a2,0x20
 56e:	9201                	srl	a2,a2,0x20
 570:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 574:	872a                	mv	a4,a0
      *dst++ = *src++;
 576:	0585                	add	a1,a1,1
 578:	0705                	add	a4,a4,1
 57a:	fff5c683          	lbu	a3,-1(a1)
 57e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 582:	fee79ae3          	bne	a5,a4,576 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 586:	6422                	ld	s0,8(sp)
 588:	0141                	add	sp,sp,16
 58a:	8082                	ret
    dst += n;
 58c:	00c50733          	add	a4,a0,a2
    src += n;
 590:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 592:	fec05ae3          	blez	a2,586 <memmove+0x28>
 596:	fff6079b          	addw	a5,a2,-1
 59a:	1782                	sll	a5,a5,0x20
 59c:	9381                	srl	a5,a5,0x20
 59e:	fff7c793          	not	a5,a5
 5a2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5a4:	15fd                	add	a1,a1,-1
 5a6:	177d                	add	a4,a4,-1
 5a8:	0005c683          	lbu	a3,0(a1)
 5ac:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5b0:	fee79ae3          	bne	a5,a4,5a4 <memmove+0x46>
 5b4:	bfc9                	j	586 <memmove+0x28>

00000000000005b6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5b6:	1141                	add	sp,sp,-16
 5b8:	e422                	sd	s0,8(sp)
 5ba:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5bc:	ca05                	beqz	a2,5ec <memcmp+0x36>
 5be:	fff6069b          	addw	a3,a2,-1
 5c2:	1682                	sll	a3,a3,0x20
 5c4:	9281                	srl	a3,a3,0x20
 5c6:	0685                	add	a3,a3,1
 5c8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5ca:	00054783          	lbu	a5,0(a0)
 5ce:	0005c703          	lbu	a4,0(a1)
 5d2:	00e79863          	bne	a5,a4,5e2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5d6:	0505                	add	a0,a0,1
    p2++;
 5d8:	0585                	add	a1,a1,1
  while (n-- > 0) {
 5da:	fed518e3          	bne	a0,a3,5ca <memcmp+0x14>
  }
  return 0;
 5de:	4501                	li	a0,0
 5e0:	a019                	j	5e6 <memcmp+0x30>
      return *p1 - *p2;
 5e2:	40e7853b          	subw	a0,a5,a4
}
 5e6:	6422                	ld	s0,8(sp)
 5e8:	0141                	add	sp,sp,16
 5ea:	8082                	ret
  return 0;
 5ec:	4501                	li	a0,0
 5ee:	bfe5                	j	5e6 <memcmp+0x30>

00000000000005f0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5f0:	1141                	add	sp,sp,-16
 5f2:	e406                	sd	ra,8(sp)
 5f4:	e022                	sd	s0,0(sp)
 5f6:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 5f8:	f67ff0ef          	jal	55e <memmove>
}
 5fc:	60a2                	ld	ra,8(sp)
 5fe:	6402                	ld	s0,0(sp)
 600:	0141                	add	sp,sp,16
 602:	8082                	ret

0000000000000604 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 604:	4885                	li	a7,1
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <exit>:
.global exit
exit:
 li a7, SYS_exit
 60c:	4889                	li	a7,2
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <wait>:
.global wait
wait:
 li a7, SYS_wait
 614:	488d                	li	a7,3
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 61c:	4891                	li	a7,4
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <read>:
.global read
read:
 li a7, SYS_read
 624:	4895                	li	a7,5
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <write>:
.global write
write:
 li a7, SYS_write
 62c:	48c1                	li	a7,16
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <close>:
.global close
close:
 li a7, SYS_close
 634:	48d5                	li	a7,21
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <kill>:
.global kill
kill:
 li a7, SYS_kill
 63c:	4899                	li	a7,6
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <exec>:
.global exec
exec:
 li a7, SYS_exec
 644:	489d                	li	a7,7
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <open>:
.global open
open:
 li a7, SYS_open
 64c:	48bd                	li	a7,15
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 654:	48c5                	li	a7,17
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 65c:	48c9                	li	a7,18
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 664:	48a1                	li	a7,8
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <link>:
.global link
link:
 li a7, SYS_link
 66c:	48cd                	li	a7,19
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 674:	48d1                	li	a7,20
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 67c:	48a5                	li	a7,9
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <dup>:
.global dup
dup:
 li a7, SYS_dup
 684:	48a9                	li	a7,10
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 68c:	48ad                	li	a7,11
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 694:	48b1                	li	a7,12
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 69c:	48b5                	li	a7,13
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6a4:	48b9                	li	a7,14
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 6ac:	48d9                	li	a7,22
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 6b4:	48dd                	li	a7,23
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 6bc:	48e1                	li	a7,24
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 6c4:	48e5                	li	a7,25
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 6cc:	48e9                	li	a7,26
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 6d4:	48ed                	li	a7,27
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 6dc:	48f1                	li	a7,28
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <uptime_nolock>:
.global uptime_nolock
uptime_nolock:
 li a7, SYS_uptime_nolock
 6e4:	48f5                	li	a7,29
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <set_type>:
.global set_type
set_type:
 li a7, SYS_set_type
 6ec:	48f9                	li	a7,30
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6f4:	1101                	add	sp,sp,-32
 6f6:	ec06                	sd	ra,24(sp)
 6f8:	e822                	sd	s0,16(sp)
 6fa:	1000                	add	s0,sp,32
 6fc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 700:	4605                	li	a2,1
 702:	fef40593          	add	a1,s0,-17
 706:	f27ff0ef          	jal	62c <write>
}
 70a:	60e2                	ld	ra,24(sp)
 70c:	6442                	ld	s0,16(sp)
 70e:	6105                	add	sp,sp,32
 710:	8082                	ret

0000000000000712 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 712:	7139                	add	sp,sp,-64
 714:	fc06                	sd	ra,56(sp)
 716:	f822                	sd	s0,48(sp)
 718:	f426                	sd	s1,40(sp)
 71a:	f04a                	sd	s2,32(sp)
 71c:	ec4e                	sd	s3,24(sp)
 71e:	0080                	add	s0,sp,64
 720:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 722:	c299                	beqz	a3,728 <printint+0x16>
 724:	0805c763          	bltz	a1,7b2 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 728:	2581                	sext.w	a1,a1
  neg = 0;
 72a:	4881                	li	a7,0
 72c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 730:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 732:	2601                	sext.w	a2,a2
 734:	00000517          	auipc	a0,0x0
 738:	4d450513          	add	a0,a0,1236 # c08 <digits>
 73c:	883a                	mv	a6,a4
 73e:	2705                	addw	a4,a4,1
 740:	02c5f7bb          	remuw	a5,a1,a2
 744:	1782                	sll	a5,a5,0x20
 746:	9381                	srl	a5,a5,0x20
 748:	97aa                	add	a5,a5,a0
 74a:	0007c783          	lbu	a5,0(a5)
 74e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 752:	0005879b          	sext.w	a5,a1
 756:	02c5d5bb          	divuw	a1,a1,a2
 75a:	0685                	add	a3,a3,1
 75c:	fec7f0e3          	bgeu	a5,a2,73c <printint+0x2a>
  if(neg)
 760:	00088c63          	beqz	a7,778 <printint+0x66>
    buf[i++] = '-';
 764:	fd070793          	add	a5,a4,-48
 768:	00878733          	add	a4,a5,s0
 76c:	02d00793          	li	a5,45
 770:	fef70823          	sb	a5,-16(a4)
 774:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 778:	02e05663          	blez	a4,7a4 <printint+0x92>
 77c:	fc040793          	add	a5,s0,-64
 780:	00e78933          	add	s2,a5,a4
 784:	fff78993          	add	s3,a5,-1
 788:	99ba                	add	s3,s3,a4
 78a:	377d                	addw	a4,a4,-1
 78c:	1702                	sll	a4,a4,0x20
 78e:	9301                	srl	a4,a4,0x20
 790:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 794:	fff94583          	lbu	a1,-1(s2)
 798:	8526                	mv	a0,s1
 79a:	f5bff0ef          	jal	6f4 <putc>
  while(--i >= 0)
 79e:	197d                	add	s2,s2,-1
 7a0:	ff391ae3          	bne	s2,s3,794 <printint+0x82>
}
 7a4:	70e2                	ld	ra,56(sp)
 7a6:	7442                	ld	s0,48(sp)
 7a8:	74a2                	ld	s1,40(sp)
 7aa:	7902                	ld	s2,32(sp)
 7ac:	69e2                	ld	s3,24(sp)
 7ae:	6121                	add	sp,sp,64
 7b0:	8082                	ret
    x = -xx;
 7b2:	40b005bb          	negw	a1,a1
    neg = 1;
 7b6:	4885                	li	a7,1
    x = -xx;
 7b8:	bf95                	j	72c <printint+0x1a>

00000000000007ba <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7ba:	711d                	add	sp,sp,-96
 7bc:	ec86                	sd	ra,88(sp)
 7be:	e8a2                	sd	s0,80(sp)
 7c0:	e4a6                	sd	s1,72(sp)
 7c2:	e0ca                	sd	s2,64(sp)
 7c4:	fc4e                	sd	s3,56(sp)
 7c6:	f852                	sd	s4,48(sp)
 7c8:	f456                	sd	s5,40(sp)
 7ca:	f05a                	sd	s6,32(sp)
 7cc:	ec5e                	sd	s7,24(sp)
 7ce:	e862                	sd	s8,16(sp)
 7d0:	e466                	sd	s9,8(sp)
 7d2:	e06a                	sd	s10,0(sp)
 7d4:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7d6:	0005c903          	lbu	s2,0(a1)
 7da:	24090763          	beqz	s2,a28 <vprintf+0x26e>
 7de:	8b2a                	mv	s6,a0
 7e0:	8a2e                	mv	s4,a1
 7e2:	8bb2                	mv	s7,a2
  state = 0;
 7e4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 7e6:	4481                	li	s1,0
 7e8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 7ea:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 7ee:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 7f2:	06c00c93          	li	s9,108
 7f6:	a005                	j	816 <vprintf+0x5c>
        putc(fd, c0);
 7f8:	85ca                	mv	a1,s2
 7fa:	855a                	mv	a0,s6
 7fc:	ef9ff0ef          	jal	6f4 <putc>
 800:	a019                	j	806 <vprintf+0x4c>
    } else if(state == '%'){
 802:	03598263          	beq	s3,s5,826 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 806:	2485                	addw	s1,s1,1
 808:	8726                	mv	a4,s1
 80a:	009a07b3          	add	a5,s4,s1
 80e:	0007c903          	lbu	s2,0(a5)
 812:	20090b63          	beqz	s2,a28 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 816:	0009079b          	sext.w	a5,s2
    if(state == 0){
 81a:	fe0994e3          	bnez	s3,802 <vprintf+0x48>
      if(c0 == '%'){
 81e:	fd579de3          	bne	a5,s5,7f8 <vprintf+0x3e>
        state = '%';
 822:	89be                	mv	s3,a5
 824:	b7cd                	j	806 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 826:	c7c9                	beqz	a5,8b0 <vprintf+0xf6>
 828:	00ea06b3          	add	a3,s4,a4
 82c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 830:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 832:	c681                	beqz	a3,83a <vprintf+0x80>
 834:	9752                	add	a4,a4,s4
 836:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 83a:	03878f63          	beq	a5,s8,878 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 83e:	05978963          	beq	a5,s9,890 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 842:	07500713          	li	a4,117
 846:	0ee78363          	beq	a5,a4,92c <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 84a:	07800713          	li	a4,120
 84e:	12e78563          	beq	a5,a4,978 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 852:	07000713          	li	a4,112
 856:	14e78a63          	beq	a5,a4,9aa <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 85a:	07300713          	li	a4,115
 85e:	18e78863          	beq	a5,a4,9ee <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 862:	02500713          	li	a4,37
 866:	04e79563          	bne	a5,a4,8b0 <vprintf+0xf6>
        putc(fd, '%');
 86a:	02500593          	li	a1,37
 86e:	855a                	mv	a0,s6
 870:	e85ff0ef          	jal	6f4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 874:	4981                	li	s3,0
 876:	bf41                	j	806 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 878:	008b8913          	add	s2,s7,8
 87c:	4685                	li	a3,1
 87e:	4629                	li	a2,10
 880:	000ba583          	lw	a1,0(s7)
 884:	855a                	mv	a0,s6
 886:	e8dff0ef          	jal	712 <printint>
 88a:	8bca                	mv	s7,s2
      state = 0;
 88c:	4981                	li	s3,0
 88e:	bfa5                	j	806 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 890:	06400793          	li	a5,100
 894:	02f68963          	beq	a3,a5,8c6 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 898:	06c00793          	li	a5,108
 89c:	04f68263          	beq	a3,a5,8e0 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 8a0:	07500793          	li	a5,117
 8a4:	0af68063          	beq	a3,a5,944 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 8a8:	07800793          	li	a5,120
 8ac:	0ef68263          	beq	a3,a5,990 <vprintf+0x1d6>
        putc(fd, '%');
 8b0:	02500593          	li	a1,37
 8b4:	855a                	mv	a0,s6
 8b6:	e3fff0ef          	jal	6f4 <putc>
        putc(fd, c0);
 8ba:	85ca                	mv	a1,s2
 8bc:	855a                	mv	a0,s6
 8be:	e37ff0ef          	jal	6f4 <putc>
      state = 0;
 8c2:	4981                	li	s3,0
 8c4:	b789                	j	806 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8c6:	008b8913          	add	s2,s7,8
 8ca:	4685                	li	a3,1
 8cc:	4629                	li	a2,10
 8ce:	000ba583          	lw	a1,0(s7)
 8d2:	855a                	mv	a0,s6
 8d4:	e3fff0ef          	jal	712 <printint>
        i += 1;
 8d8:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8da:	8bca                	mv	s7,s2
      state = 0;
 8dc:	4981                	li	s3,0
        i += 1;
 8de:	b725                	j	806 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8e0:	06400793          	li	a5,100
 8e4:	02f60763          	beq	a2,a5,912 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8e8:	07500793          	li	a5,117
 8ec:	06f60963          	beq	a2,a5,95e <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8f0:	07800793          	li	a5,120
 8f4:	faf61ee3          	bne	a2,a5,8b0 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8f8:	008b8913          	add	s2,s7,8
 8fc:	4681                	li	a3,0
 8fe:	4641                	li	a2,16
 900:	000ba583          	lw	a1,0(s7)
 904:	855a                	mv	a0,s6
 906:	e0dff0ef          	jal	712 <printint>
        i += 2;
 90a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 90c:	8bca                	mv	s7,s2
      state = 0;
 90e:	4981                	li	s3,0
        i += 2;
 910:	bddd                	j	806 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 912:	008b8913          	add	s2,s7,8
 916:	4685                	li	a3,1
 918:	4629                	li	a2,10
 91a:	000ba583          	lw	a1,0(s7)
 91e:	855a                	mv	a0,s6
 920:	df3ff0ef          	jal	712 <printint>
        i += 2;
 924:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 926:	8bca                	mv	s7,s2
      state = 0;
 928:	4981                	li	s3,0
        i += 2;
 92a:	bdf1                	j	806 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 92c:	008b8913          	add	s2,s7,8
 930:	4681                	li	a3,0
 932:	4629                	li	a2,10
 934:	000ba583          	lw	a1,0(s7)
 938:	855a                	mv	a0,s6
 93a:	dd9ff0ef          	jal	712 <printint>
 93e:	8bca                	mv	s7,s2
      state = 0;
 940:	4981                	li	s3,0
 942:	b5d1                	j	806 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 944:	008b8913          	add	s2,s7,8
 948:	4681                	li	a3,0
 94a:	4629                	li	a2,10
 94c:	000ba583          	lw	a1,0(s7)
 950:	855a                	mv	a0,s6
 952:	dc1ff0ef          	jal	712 <printint>
        i += 1;
 956:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 958:	8bca                	mv	s7,s2
      state = 0;
 95a:	4981                	li	s3,0
        i += 1;
 95c:	b56d                	j	806 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 95e:	008b8913          	add	s2,s7,8
 962:	4681                	li	a3,0
 964:	4629                	li	a2,10
 966:	000ba583          	lw	a1,0(s7)
 96a:	855a                	mv	a0,s6
 96c:	da7ff0ef          	jal	712 <printint>
        i += 2;
 970:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 972:	8bca                	mv	s7,s2
      state = 0;
 974:	4981                	li	s3,0
        i += 2;
 976:	bd41                	j	806 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 978:	008b8913          	add	s2,s7,8
 97c:	4681                	li	a3,0
 97e:	4641                	li	a2,16
 980:	000ba583          	lw	a1,0(s7)
 984:	855a                	mv	a0,s6
 986:	d8dff0ef          	jal	712 <printint>
 98a:	8bca                	mv	s7,s2
      state = 0;
 98c:	4981                	li	s3,0
 98e:	bda5                	j	806 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 990:	008b8913          	add	s2,s7,8
 994:	4681                	li	a3,0
 996:	4641                	li	a2,16
 998:	000ba583          	lw	a1,0(s7)
 99c:	855a                	mv	a0,s6
 99e:	d75ff0ef          	jal	712 <printint>
        i += 1;
 9a2:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 9a4:	8bca                	mv	s7,s2
      state = 0;
 9a6:	4981                	li	s3,0
        i += 1;
 9a8:	bdb9                	j	806 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 9aa:	008b8d13          	add	s10,s7,8
 9ae:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9b2:	03000593          	li	a1,48
 9b6:	855a                	mv	a0,s6
 9b8:	d3dff0ef          	jal	6f4 <putc>
  putc(fd, 'x');
 9bc:	07800593          	li	a1,120
 9c0:	855a                	mv	a0,s6
 9c2:	d33ff0ef          	jal	6f4 <putc>
 9c6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9c8:	00000b97          	auipc	s7,0x0
 9cc:	240b8b93          	add	s7,s7,576 # c08 <digits>
 9d0:	03c9d793          	srl	a5,s3,0x3c
 9d4:	97de                	add	a5,a5,s7
 9d6:	0007c583          	lbu	a1,0(a5)
 9da:	855a                	mv	a0,s6
 9dc:	d19ff0ef          	jal	6f4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9e0:	0992                	sll	s3,s3,0x4
 9e2:	397d                	addw	s2,s2,-1
 9e4:	fe0916e3          	bnez	s2,9d0 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 9e8:	8bea                	mv	s7,s10
      state = 0;
 9ea:	4981                	li	s3,0
 9ec:	bd29                	j	806 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 9ee:	008b8993          	add	s3,s7,8
 9f2:	000bb903          	ld	s2,0(s7)
 9f6:	00090f63          	beqz	s2,a14 <vprintf+0x25a>
        for(; *s; s++)
 9fa:	00094583          	lbu	a1,0(s2)
 9fe:	c195                	beqz	a1,a22 <vprintf+0x268>
          putc(fd, *s);
 a00:	855a                	mv	a0,s6
 a02:	cf3ff0ef          	jal	6f4 <putc>
        for(; *s; s++)
 a06:	0905                	add	s2,s2,1
 a08:	00094583          	lbu	a1,0(s2)
 a0c:	f9f5                	bnez	a1,a00 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 a0e:	8bce                	mv	s7,s3
      state = 0;
 a10:	4981                	li	s3,0
 a12:	bbd5                	j	806 <vprintf+0x4c>
          s = "(null)";
 a14:	00000917          	auipc	s2,0x0
 a18:	1ec90913          	add	s2,s2,492 # c00 <malloc+0xde>
        for(; *s; s++)
 a1c:	02800593          	li	a1,40
 a20:	b7c5                	j	a00 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 a22:	8bce                	mv	s7,s3
      state = 0;
 a24:	4981                	li	s3,0
 a26:	b3c5                	j	806 <vprintf+0x4c>
    }
  }
}
 a28:	60e6                	ld	ra,88(sp)
 a2a:	6446                	ld	s0,80(sp)
 a2c:	64a6                	ld	s1,72(sp)
 a2e:	6906                	ld	s2,64(sp)
 a30:	79e2                	ld	s3,56(sp)
 a32:	7a42                	ld	s4,48(sp)
 a34:	7aa2                	ld	s5,40(sp)
 a36:	7b02                	ld	s6,32(sp)
 a38:	6be2                	ld	s7,24(sp)
 a3a:	6c42                	ld	s8,16(sp)
 a3c:	6ca2                	ld	s9,8(sp)
 a3e:	6d02                	ld	s10,0(sp)
 a40:	6125                	add	sp,sp,96
 a42:	8082                	ret

0000000000000a44 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a44:	715d                	add	sp,sp,-80
 a46:	ec06                	sd	ra,24(sp)
 a48:	e822                	sd	s0,16(sp)
 a4a:	1000                	add	s0,sp,32
 a4c:	e010                	sd	a2,0(s0)
 a4e:	e414                	sd	a3,8(s0)
 a50:	e818                	sd	a4,16(s0)
 a52:	ec1c                	sd	a5,24(s0)
 a54:	03043023          	sd	a6,32(s0)
 a58:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a5c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a60:	8622                	mv	a2,s0
 a62:	d59ff0ef          	jal	7ba <vprintf>
}
 a66:	60e2                	ld	ra,24(sp)
 a68:	6442                	ld	s0,16(sp)
 a6a:	6161                	add	sp,sp,80
 a6c:	8082                	ret

0000000000000a6e <printf>:

void
printf(const char *fmt, ...)
{
 a6e:	711d                	add	sp,sp,-96
 a70:	ec06                	sd	ra,24(sp)
 a72:	e822                	sd	s0,16(sp)
 a74:	1000                	add	s0,sp,32
 a76:	e40c                	sd	a1,8(s0)
 a78:	e810                	sd	a2,16(s0)
 a7a:	ec14                	sd	a3,24(s0)
 a7c:	f018                	sd	a4,32(s0)
 a7e:	f41c                	sd	a5,40(s0)
 a80:	03043823          	sd	a6,48(s0)
 a84:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a88:	00840613          	add	a2,s0,8
 a8c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a90:	85aa                	mv	a1,a0
 a92:	4505                	li	a0,1
 a94:	d27ff0ef          	jal	7ba <vprintf>
}
 a98:	60e2                	ld	ra,24(sp)
 a9a:	6442                	ld	s0,16(sp)
 a9c:	6125                	add	sp,sp,96
 a9e:	8082                	ret

0000000000000aa0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 aa0:	1141                	add	sp,sp,-16
 aa2:	e422                	sd	s0,8(sp)
 aa4:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aa6:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aaa:	00000797          	auipc	a5,0x0
 aae:	5667b783          	ld	a5,1382(a5) # 1010 <freep>
 ab2:	a02d                	j	adc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ab4:	4618                	lw	a4,8(a2)
 ab6:	9f2d                	addw	a4,a4,a1
 ab8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 abc:	6398                	ld	a4,0(a5)
 abe:	6310                	ld	a2,0(a4)
 ac0:	a83d                	j	afe <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ac2:	ff852703          	lw	a4,-8(a0)
 ac6:	9f31                	addw	a4,a4,a2
 ac8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 aca:	ff053683          	ld	a3,-16(a0)
 ace:	a091                	j	b12 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad0:	6398                	ld	a4,0(a5)
 ad2:	00e7e463          	bltu	a5,a4,ada <free+0x3a>
 ad6:	00e6ea63          	bltu	a3,a4,aea <free+0x4a>
{
 ada:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 adc:	fed7fae3          	bgeu	a5,a3,ad0 <free+0x30>
 ae0:	6398                	ld	a4,0(a5)
 ae2:	00e6e463          	bltu	a3,a4,aea <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae6:	fee7eae3          	bltu	a5,a4,ada <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 aea:	ff852583          	lw	a1,-8(a0)
 aee:	6390                	ld	a2,0(a5)
 af0:	02059813          	sll	a6,a1,0x20
 af4:	01c85713          	srl	a4,a6,0x1c
 af8:	9736                	add	a4,a4,a3
 afa:	fae60de3          	beq	a2,a4,ab4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 afe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b02:	4790                	lw	a2,8(a5)
 b04:	02061593          	sll	a1,a2,0x20
 b08:	01c5d713          	srl	a4,a1,0x1c
 b0c:	973e                	add	a4,a4,a5
 b0e:	fae68ae3          	beq	a3,a4,ac2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 b12:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b14:	00000717          	auipc	a4,0x0
 b18:	4ef73e23          	sd	a5,1276(a4) # 1010 <freep>
}
 b1c:	6422                	ld	s0,8(sp)
 b1e:	0141                	add	sp,sp,16
 b20:	8082                	ret

0000000000000b22 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b22:	7139                	add	sp,sp,-64
 b24:	fc06                	sd	ra,56(sp)
 b26:	f822                	sd	s0,48(sp)
 b28:	f426                	sd	s1,40(sp)
 b2a:	f04a                	sd	s2,32(sp)
 b2c:	ec4e                	sd	s3,24(sp)
 b2e:	e852                	sd	s4,16(sp)
 b30:	e456                	sd	s5,8(sp)
 b32:	e05a                	sd	s6,0(sp)
 b34:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b36:	02051493          	sll	s1,a0,0x20
 b3a:	9081                	srl	s1,s1,0x20
 b3c:	04bd                	add	s1,s1,15
 b3e:	8091                	srl	s1,s1,0x4
 b40:	0014899b          	addw	s3,s1,1
 b44:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 b46:	00000517          	auipc	a0,0x0
 b4a:	4ca53503          	ld	a0,1226(a0) # 1010 <freep>
 b4e:	c515                	beqz	a0,b7a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b50:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b52:	4798                	lw	a4,8(a5)
 b54:	02977f63          	bgeu	a4,s1,b92 <malloc+0x70>
  if(nu < 4096)
 b58:	8a4e                	mv	s4,s3
 b5a:	0009871b          	sext.w	a4,s3
 b5e:	6685                	lui	a3,0x1
 b60:	00d77363          	bgeu	a4,a3,b66 <malloc+0x44>
 b64:	6a05                	lui	s4,0x1
 b66:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b6a:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b6e:	00000917          	auipc	s2,0x0
 b72:	4a290913          	add	s2,s2,1186 # 1010 <freep>
  if(p == (char*)-1)
 b76:	5afd                	li	s5,-1
 b78:	a885                	j	be8 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 b7a:	00000797          	auipc	a5,0x0
 b7e:	4a678793          	add	a5,a5,1190 # 1020 <base>
 b82:	00000717          	auipc	a4,0x0
 b86:	48f73723          	sd	a5,1166(a4) # 1010 <freep>
 b8a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b8c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b90:	b7e1                	j	b58 <malloc+0x36>
      if(p->s.size == nunits)
 b92:	02e48c63          	beq	s1,a4,bca <malloc+0xa8>
        p->s.size -= nunits;
 b96:	4137073b          	subw	a4,a4,s3
 b9a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b9c:	02071693          	sll	a3,a4,0x20
 ba0:	01c6d713          	srl	a4,a3,0x1c
 ba4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ba6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 baa:	00000717          	auipc	a4,0x0
 bae:	46a73323          	sd	a0,1126(a4) # 1010 <freep>
      return (void*)(p + 1);
 bb2:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bb6:	70e2                	ld	ra,56(sp)
 bb8:	7442                	ld	s0,48(sp)
 bba:	74a2                	ld	s1,40(sp)
 bbc:	7902                	ld	s2,32(sp)
 bbe:	69e2                	ld	s3,24(sp)
 bc0:	6a42                	ld	s4,16(sp)
 bc2:	6aa2                	ld	s5,8(sp)
 bc4:	6b02                	ld	s6,0(sp)
 bc6:	6121                	add	sp,sp,64
 bc8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bca:	6398                	ld	a4,0(a5)
 bcc:	e118                	sd	a4,0(a0)
 bce:	bff1                	j	baa <malloc+0x88>
  hp->s.size = nu;
 bd0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bd4:	0541                	add	a0,a0,16
 bd6:	ecbff0ef          	jal	aa0 <free>
  return freep;
 bda:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bde:	dd61                	beqz	a0,bb6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 be0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 be2:	4798                	lw	a4,8(a5)
 be4:	fa9777e3          	bgeu	a4,s1,b92 <malloc+0x70>
    if(p == freep)
 be8:	00093703          	ld	a4,0(s2)
 bec:	853e                	mv	a0,a5
 bee:	fef719e3          	bne	a4,a5,be0 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 bf2:	8552                	mv	a0,s4
 bf4:	aa1ff0ef          	jal	694 <sbrk>
  if(p == (char*)-1)
 bf8:	fd551ce3          	bne	a0,s5,bd0 <malloc+0xae>
        return 0;
 bfc:	4501                	li	a0,0
 bfe:	bf65                	j	bb6 <malloc+0x94>
