
user/_rows:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:


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

unsigned long rand_next = 13;

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

0000000000000074 <main>:

int main(int agrc, char *argv[]){
  74:	b6010113          	add	sp,sp,-1184
  78:	48113c23          	sd	ra,1176(sp)
  7c:	48813823          	sd	s0,1168(sp)
  80:	48913423          	sd	s1,1160(sp)
  84:	49213023          	sd	s2,1152(sp)
  88:	47313c23          	sd	s3,1144(sp)
  8c:	47413823          	sd	s4,1136(sp)
  90:	47513423          	sd	s5,1128(sp)
  94:	47613023          	sd	s6,1120(sp)
  98:	45713c23          	sd	s7,1112(sp)
  9c:	45813823          	sd	s8,1104(sp)
  a0:	45913423          	sd	s9,1096(sp)
  a4:	45a13023          	sd	s10,1088(sp)
  a8:	43b13c23          	sd	s11,1080(sp)
  ac:	4a010413          	add	s0,sp,1184
    int t0, t1;

    char *buff_eficiencia = argv[1];
    char *buff_overhead = argv[2];
  b0:	6984                	ld	s1,16(a1)

    int fd_eficiencia = atoi(buff_eficiencia);
  b2:	6588                	ld	a0,8(a1)
  b4:	5f8000ef          	jal	6ac <atoi>
  b8:	b6a43423          	sd	a0,-1176(s0)
    int fd_overhead = atoi(buff_overhead);
  bc:	8526                	mv	a0,s1
  be:	5ee000ef          	jal	6ac <atoi>
  c2:	b6a43023          	sd	a0,-1184(s0)

    int index_eficiencia = 0, index_overhead = 0;
    int *eficiencias = malloc(500 * sizeof(int));
  c6:	7d000513          	li	a0,2000
  ca:	3c7000ef          	jal	c90 <malloc>
  ce:	8baa                	mv	s7,a0
    int *overheads = malloc(500 * sizeof(int));
  d0:	7d000513          	li	a0,2000
  d4:	3bd000ef          	jal	c90 <malloc>
  d8:	8b2a                	mv	s6,a0

    int fd;
    char filename[20] = "iobound";
  da:	00001797          	auipc	a5,0x1
  de:	dbe7b783          	ld	a5,-578(a5) # e98 <malloc+0x208>
  e2:	f6f43c23          	sd	a5,-136(s0)
  e6:	f8043023          	sd	zero,-128(s0)
  ea:	f8042423          	sw	zero,-120(s0)
    char pid_str[10];
    char *suffix = ".txt";

    int pid = getpid();
  ee:	734000ef          	jal	822 <getpid>

    pid += 1000; //valores baixos dão problema
  f2:	3e85071b          	addw	a4,a0,1000

    int i = 0;
  f6:	f6840693          	add	a3,s0,-152
    pid += 1000; //valores baixos dão problema
  fa:	8636                	mv	a2,a3
    int i = 0;
  fc:	4781                	li	a5,0
    do {
        pid_str[i++] = pid % 10 + '0';   // próximo digito
  fe:	4829                	li	a6,10
    } while ((pid /= 10) > 0);
 100:	48a5                	li	a7,9
        pid_str[i++] = pid % 10 + '0';   // próximo digito
 102:	85be                	mv	a1,a5
 104:	2785                	addw	a5,a5,1
 106:	0307653b          	remw	a0,a4,a6
 10a:	0305051b          	addw	a0,a0,48
 10e:	00a60023          	sb	a0,0(a2)
    } while ((pid /= 10) > 0);
 112:	853a                	mv	a0,a4
 114:	0307473b          	divw	a4,a4,a6
 118:	0605                	add	a2,a2,1
 11a:	fea8c4e3          	blt	a7,a0,102 <main+0x8e>
    pid_str[i] = '\0';
 11e:	f9078793          	add	a5,a5,-112
 122:	97a2                	add	a5,a5,s0
 124:	fc078c23          	sb	zero,-40(a5)

    int j;
    char temp;
    for (j = 0, i--; j < i; j++, i--) {
 128:	18b05563          	blez	a1,2b2 <main+0x23e>
 12c:	f6840793          	add	a5,s0,-152
 130:	97ae                	add	a5,a5,a1
 132:	4701                	li	a4,0
        temp = pid_str[j];
 134:	0006c603          	lbu	a2,0(a3)
        pid_str[j] = pid_str[i];
 138:	0007c503          	lbu	a0,0(a5)
 13c:	00a68023          	sb	a0,0(a3)
        pid_str[i] = temp;
 140:	00c78023          	sb	a2,0(a5)
    for (j = 0, i--; j < i; j++, i--) {
 144:	0017061b          	addw	a2,a4,1 # ffffffff80000001 <base+0xffffffff7fffefe1>
 148:	0006071b          	sext.w	a4,a2
 14c:	0685                	add	a3,a3,1
 14e:	17fd                	add	a5,a5,-1
 150:	40c5863b          	subw	a2,a1,a2
 154:	fec740e3          	blt	a4,a2,134 <main+0xc0>
    }

    i = 7;
    while (pid_str[j] != '\0') {
 158:	f9070793          	add	a5,a4,-112
 15c:	97a2                	add	a5,a5,s0
 15e:	fd87c603          	lbu	a2,-40(a5)
 162:	14060a63          	beqz	a2,2b6 <main+0x242>
 166:	46a1                	li	a3,8
        filename[i++] = pid_str[j++];
 168:	f7840793          	add	a5,s0,-136
 16c:	97b6                	add	a5,a5,a3
 16e:	fec78fa3          	sb	a2,-1(a5)
    while (pid_str[j] != '\0') {
 172:	87b6                	mv	a5,a3
 174:	0685                	add	a3,a3,1
 176:	00d70633          	add	a2,a4,a3
 17a:	f6840593          	add	a1,s0,-152
 17e:	962e                	add	a2,a2,a1
 180:	ff864603          	lbu	a2,-8(a2)
 184:	f275                	bnez	a2,168 <main+0xf4>
        filename[i++] = pid_str[j++];
 186:	2781                	sext.w	a5,a5
    }
    j = 0;
    while (suffix[j] != '\0') {
 188:	2785                	addw	a5,a5,1
 18a:	00001617          	auipc	a2,0x1
 18e:	be760613          	add	a2,a2,-1049 # d71 <malloc+0xe1>
 192:	02e00693          	li	a3,46
        filename[i++] = suffix[j++];
 196:	f7840713          	add	a4,s0,-136
 19a:	973e                	add	a4,a4,a5
 19c:	fed70fa3          	sb	a3,-1(a4)
    while (suffix[j] != '\0') {
 1a0:	00064683          	lbu	a3,0(a2)
 1a4:	873e                	mv	a4,a5
 1a6:	0785                	add	a5,a5,1
 1a8:	0605                	add	a2,a2,1
 1aa:	f6f5                	bnez	a3,196 <main+0x122>
    }
    filename[i] = '\0';
 1ac:	0007079b          	sext.w	a5,a4
 1b0:	f9078793          	add	a5,a5,-112
 1b4:	97a2                	add	a5,a5,s0
 1b6:	fe078423          	sb	zero,-24(a5)

    t0 = uptime();
 1ba:	680000ef          	jal	83a <uptime>
 1be:	84aa                	mv	s1,a0
    fd = open(filename, O_CREATE | O_RDWR);
 1c0:	20200593          	li	a1,514
 1c4:	f7840513          	add	a0,s0,-136
 1c8:	61a000ef          	jal	7e2 <open>
 1cc:	8d2a                	mv	s10,a0
    t1 = uptime();
 1ce:	66c000ef          	jal	83a <uptime>
    overheads[index_overhead++] = t1 - t0;
 1d2:	409507bb          	subw	a5,a0,s1
 1d6:	00fb2023          	sw	a5,0(s6)

    if (fd < 0){
 1da:	0e0d4063          	bltz	s10,2ba <main+0x246>
    }

    char *caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$&*()";

    char linha[101];
    linha[100] = '\n';
 1de:	47a9                	li	a5,10
 1e0:	f6f40223          	sb	a5,-156(s0)
    int size = 101;
    for(i=0;i<100;i++){ //escreve as linhas
 1e4:	8c5e                	mv	s8,s7
    linha[100] = '\n';
 1e6:	8cde                	mv	s9,s7
    int index_eficiencia = 0, index_overhead = 0;
 1e8:	4a81                	li	s5,0
 1ea:	f6440a13          	add	s4,s0,-156
        for(int j=0;j<100;j++){ //escreve os caracteres
            int c = rand() % 70;
 1ee:	04600993          	li	s3,70
            linha[j] = caracteres[c];
 1f2:	00001917          	auipc	s2,0x1
 1f6:	ba690913          	add	s2,s2,-1114 # d98 <malloc+0x108>
    for(i=0;i<100;i++){ //escreve as linhas
 1fa:	06400d93          	li	s11,100
        for(int j=0;j<100;j++){ //escreve os caracteres
 1fe:	f0040493          	add	s1,s0,-256
            int c = rand() % 70;
 202:	e57ff0ef          	jal	58 <rand>
            linha[j] = caracteres[c];
 206:	0335653b          	remw	a0,a0,s3
 20a:	954a                	add	a0,a0,s2
 20c:	00054783          	lbu	a5,0(a0)
 210:	00f48023          	sb	a5,0(s1)
        for(int j=0;j<100;j++){ //escreve os caracteres
 214:	0485                	add	s1,s1,1
 216:	ff4496e3          	bne	s1,s4,202 <main+0x18e>
        }
        t0 = uptime();
 21a:	620000ef          	jal	83a <uptime>
 21e:	84aa                	mv	s1,a0
        if(write(fd, linha, size) != size){
 220:	06500613          	li	a2,101
 224:	f0040593          	add	a1,s0,-256
 228:	856a                	mv	a0,s10
 22a:	598000ef          	jal	7c2 <write>
 22e:	06500793          	li	a5,101
 232:	08f51d63          	bne	a0,a5,2cc <main+0x258>
            printf("error, write failed\n");
            exit(1);
        } else {  //a escrita deu certo
            t1 = uptime();
 236:	604000ef          	jal	83a <uptime>
            eficiencias[index_eficiencia++] = t1 - t0;
 23a:	2a85                	addw	s5,s5,1
 23c:	409507bb          	subw	a5,a0,s1
 240:	00fca023          	sw	a5,0(s9)
    for(i=0;i<100;i++){ //escreve as linhas
 244:	0c91                	add	s9,s9,4
 246:	fbba9ce3          	bne	s5,s11,1fe <main+0x18a>
        }
    }
    close(fd);
 24a:	856a                	mv	a0,s10
 24c:	57e000ef          	jal	7ca <close>



    char *linhas[100];
    for (int j = 0; j < 100; j++) {
 250:	be040993          	add	s3,s0,-1056
 254:	004b0913          	add	s2,s6,4
 258:	f0040c93          	add	s9,s0,-256
    close(fd);
 25c:	84ce                	mv	s1,s3
        t0 = uptime();
 25e:	5dc000ef          	jal	83a <uptime>
 262:	8a2a                	mv	s4,a0
        linhas[j] = malloc(102 * sizeof(char)); // Allocate memory for each string
 264:	06600513          	li	a0,102
 268:	229000ef          	jal	c90 <malloc>
 26c:	e088                	sd	a0,0(s1)
        t1 = uptime();
 26e:	5cc000ef          	jal	83a <uptime>
        overheads[index_overhead++] = t1 - t0;
 272:	4145053b          	subw	a0,a0,s4
 276:	00a92023          	sw	a0,0(s2)
    for (int j = 0; j < 100; j++) {
 27a:	04a1                	add	s1,s1,8
 27c:	0911                	add	s2,s2,4
 27e:	ff9490e3          	bne	s1,s9,25e <main+0x1ea>
    }

    t0 = uptime();
 282:	5b8000ef          	jal	83a <uptime>
 286:	892a                	mv	s2,a0
    fd = open(filename, O_RDONLY);
 288:	4581                	li	a1,0
 28a:	f7840513          	add	a0,s0,-136
 28e:	554000ef          	jal	7e2 <open>
 292:	84aa                	mv	s1,a0
    t1 = uptime();
 294:	5a6000ef          	jal	83a <uptime>
    overheads[index_overhead++] = t1 - t0;
 298:	412507bb          	subw	a5,a0,s2
 29c:	18fb2a23          	sw	a5,404(s6)
    if (fd < 0) {
 2a0:	0204cf63          	bltz	s1,2de <main+0x26a>
    }

    char buf[101];
    int n;
    i = 0;
    t0 = uptime();
 2a4:	596000ef          	jal	83a <uptime>
 2a8:	8d2a                	mv	s10,a0
    while((n = read(fd, buf, sizeof(buf))) > 0) {
 2aa:	190b8a13          	add	s4,s7,400
 2ae:	894e                	mv	s2,s3
 2b0:	a0a5                	j	318 <main+0x2a4>
    for (j = 0, i--; j < i; j++, i--) {
 2b2:	4701                	li	a4,0
 2b4:	b555                	j	158 <main+0xe4>
    i = 7;
 2b6:	479d                	li	a5,7
 2b8:	bdc1                	j	188 <main+0x114>
        printf("erro ao criar o arquivo %s\n", filename);
 2ba:	f7840593          	add	a1,s0,-136
 2be:	00001517          	auipc	a0,0x1
 2c2:	aba50513          	add	a0,a0,-1350 # d78 <malloc+0xe8>
 2c6:	117000ef          	jal	bdc <printf>
 2ca:	bf11                	j	1de <main+0x16a>
            printf("error, write failed\n");
 2cc:	00001517          	auipc	a0,0x1
 2d0:	b1450513          	add	a0,a0,-1260 # de0 <malloc+0x150>
 2d4:	109000ef          	jal	bdc <printf>
            exit(1);
 2d8:	4505                	li	a0,1
 2da:	4c8000ef          	jal	7a2 <exit>
        printf("Erro ao abrir o arquivo %s\n", filename);
 2de:	f7840593          	add	a1,s0,-136
 2e2:	00001517          	auipc	a0,0x1
 2e6:	b1650513          	add	a0,a0,-1258 # df8 <malloc+0x168>
 2ea:	0f3000ef          	jal	bdc <printf>
        exit(1);
 2ee:	4505                	li	a0,1
 2f0:	4b2000ef          	jal	7a2 <exit>
        t1 = uptime();
 2f4:	546000ef          	jal	83a <uptime>
        eficiencias[index_eficiencia++] = t1 - t0;
 2f8:	2a85                	addw	s5,s5,1
 2fa:	41a507bb          	subw	a5,a0,s10
 2fe:	00fa2023          	sw	a5,0(s4)
        strcpy(linhas[i], buf);
 302:	b7840593          	add	a1,s0,-1160
 306:	00093503          	ld	a0,0(s2)
 30a:	240000ef          	jal	54a <strcpy>
        i++;
        t0 = uptime();
 30e:	52c000ef          	jal	83a <uptime>
 312:	8d2a                	mv	s10,a0
 314:	0a11                	add	s4,s4,4
 316:	0921                	add	s2,s2,8
    while((n = read(fd, buf, sizeof(buf))) > 0) {
 318:	06500613          	li	a2,101
 31c:	b7840593          	add	a1,s0,-1160
 320:	8526                	mv	a0,s1
 322:	498000ef          	jal	7ba <read>
 326:	fca047e3          	bgtz	a0,2f4 <main+0x280>
    }

    close(fd);
 32a:	8526                	mv	a0,s1
 32c:	49e000ef          	jal	7ca <close>


    char *tmp;
    t0 = uptime();
 330:	50a000ef          	jal	83a <uptime>
 334:	84aa                	mv	s1,a0
    tmp = malloc(102*sizeof(char));
 336:	06600513          	li	a0,102
 33a:	157000ef          	jal	c90 <malloc>
 33e:	8d2a                	mv	s10,a0
    t1 = uptime();
 340:	4fa000ef          	jal	83a <uptime>
    overheads[index_overhead++] = t1 - t0;
 344:	409507bb          	subw	a5,a0,s1
 348:	18fb2c23          	sw	a5,408(s6)
 34c:	03200a13          	li	s4,50

    for (i = 0; i < 50; i++){
        //getting random rows
        int row1 = rand() % 100;
 350:	06400d93          	li	s11,100
 354:	d05ff0ef          	jal	58 <rand>
 358:	892a                	mv	s2,a0
        int row2 = rand() % 100;
 35a:	cffff0ef          	jal	58 <rand>
 35e:	84aa                	mv	s1,a0

        //swapping them
        strcpy(tmp, linhas[row1]);
 360:	03b967bb          	remw	a5,s2,s11
 364:	078e                	sll	a5,a5,0x3
 366:	f9078793          	add	a5,a5,-112
 36a:	97a2                	add	a5,a5,s0
 36c:	c507b903          	ld	s2,-944(a5)
 370:	85ca                	mv	a1,s2
 372:	856a                	mv	a0,s10
 374:	1d6000ef          	jal	54a <strcpy>
        strcpy(linhas[row1], linhas[row2]);
 378:	03b4e7bb          	remw	a5,s1,s11
 37c:	078e                	sll	a5,a5,0x3
 37e:	f9078793          	add	a5,a5,-112
 382:	97a2                	add	a5,a5,s0
 384:	c507b483          	ld	s1,-944(a5)
 388:	85a6                	mv	a1,s1
 38a:	854a                	mv	a0,s2
 38c:	1be000ef          	jal	54a <strcpy>
        strcpy(linhas[row2], tmp);
 390:	85ea                	mv	a1,s10
 392:	8526                	mv	a0,s1
 394:	1b6000ef          	jal	54a <strcpy>
    for (i = 0; i < 50; i++){
 398:	3a7d                	addw	s4,s4,-1
 39a:	fa0a1de3          	bnez	s4,354 <main+0x2e0>
    }
    t0 = uptime();
 39e:	49c000ef          	jal	83a <uptime>
 3a2:	84aa                	mv	s1,a0
    free(tmp);
 3a4:	856a                	mv	a0,s10
 3a6:	069000ef          	jal	c0e <free>
    t1 = uptime();
 3aa:	490000ef          	jal	83a <uptime>
    overheads[index_overhead++] = t1 - t0;
 3ae:	409507bb          	subw	a5,a0,s1
 3b2:	18fb2e23          	sw	a5,412(s6)

    //rewriting file after permutations
    t0 = uptime();
 3b6:	484000ef          	jal	83a <uptime>
 3ba:	84aa                	mv	s1,a0
    fd = open(filename, O_RDWR);
 3bc:	4589                	li	a1,2
 3be:	f7840513          	add	a0,s0,-136
 3c2:	420000ef          	jal	7e2 <open>
 3c6:	8daa                	mv	s11,a0
    t1 = uptime();
 3c8:	472000ef          	jal	83a <uptime>
    overheads[index_overhead++] = t1 - t0;
 3cc:	409507bb          	subw	a5,a0,s1
 3d0:	1afb2023          	sw	a5,416(s6)
    if (fd < 0) {
 3d4:	000dc763          	bltz	s11,3e2 <main+0x36e>
        printf("Erro ao reabrir o arquivo %s para escrever as permutações\n", filename);
        exit(1);
    }

    size = 101;
    for (int i = 0; i < 100; i++){
 3d8:	002a9a13          	sll	s4,s5,0x2
 3dc:	9a5e                	add	s4,s4,s7
    if (fd < 0) {
 3de:	84ce                	mv	s1,s3
 3e0:	a829                	j	3fa <main+0x386>
        printf("Erro ao reabrir o arquivo %s para escrever as permutações\n", filename);
 3e2:	f7840593          	add	a1,s0,-136
 3e6:	00001517          	auipc	a0,0x1
 3ea:	a3250513          	add	a0,a0,-1486 # e18 <malloc+0x188>
 3ee:	7ee000ef          	jal	bdc <printf>
        exit(1);
 3f2:	4505                	li	a0,1
 3f4:	3ae000ef          	jal	7a2 <exit>
        if(write(fd, linhas[i], size) != size){
            printf("error, write permut failed\n");
            exit(1);
        } else {
            t1 = uptime();
            eficiencias[index_eficiencia++] = t1 - t0;
 3f8:	8aea                	mv	s5,s10
        t0 = uptime();
 3fa:	440000ef          	jal	83a <uptime>
 3fe:	892a                	mv	s2,a0
        if(write(fd, linhas[i], size) != size){
 400:	06500613          	li	a2,101
 404:	608c                	ld	a1,0(s1)
 406:	856e                	mv	a0,s11
 408:	3ba000ef          	jal	7c2 <write>
 40c:	06500793          	li	a5,101
 410:	10f51263          	bne	a0,a5,514 <main+0x4a0>
            t1 = uptime();
 414:	426000ef          	jal	83a <uptime>
            eficiencias[index_eficiencia++] = t1 - t0;
 418:	001a8d1b          	addw	s10,s5,1
 41c:	412507bb          	subw	a5,a0,s2
 420:	00fa2023          	sw	a5,0(s4)
    for (int i = 0; i < 100; i++){
 424:	04a1                	add	s1,s1,8
 426:	0a11                	add	s4,s4,4
 428:	fd9498e3          	bne	s1,s9,3f8 <main+0x384>
        }
    }

    close(fd);
 42c:	856e                	mv	a0,s11
 42e:	39c000ef          	jal	7ca <close>

    //removing file
    t0 = uptime();
 432:	408000ef          	jal	83a <uptime>
 436:	84aa                	mv	s1,a0
    if (unlink(filename) < 0){
 438:	f7840513          	add	a0,s0,-136
 43c:	3b6000ef          	jal	7f2 <unlink>
 440:	0e054363          	bltz	a0,526 <main+0x4b2>
        printf("Erro ao remover o arquivo\n");
        exit(1);
    } else {
        t1 = uptime();
 444:	3f6000ef          	jal	83a <uptime>
        eficiencias[index_eficiencia++] = t1 - t0;
 448:	002d1793          	sll	a5,s10,0x2
 44c:	9bbe                	add	s7,s7,a5
 44e:	409507bb          	subw	a5,a0,s1
 452:	00fba023          	sw	a5,0(s7)
    }


    //free malloc for linhas
    for (int j = 0; j < 100; j++) {
 456:	1a4b0493          	add	s1,s6,420
        t0 = uptime();
 45a:	3e0000ef          	jal	83a <uptime>
 45e:	892a                	mv	s2,a0
        free(linhas[j]);
 460:	0009b503          	ld	a0,0(s3)
 464:	7aa000ef          	jal	c0e <free>
        t1 = uptime();
 468:	3d2000ef          	jal	83a <uptime>
        overheads[index_overhead++] = t1 - t0;
 46c:	412507bb          	subw	a5,a0,s2
 470:	c09c                	sw	a5,0(s1)
    for (int j = 0; j < 100; j++) {
 472:	09a1                	add	s3,s3,8
 474:	0491                	add	s1,s1,4
 476:	ff9992e3          	bne	s3,s9,45a <main+0x3e6>
    }

    int total_eficiencia = 0, total_overhead = 0;
 47a:	b6042a23          	sw	zero,-1164(s0)
 47e:	b6042823          	sw	zero,-1168(s0)


    //soma das métricas
    for (int i = 0; i < index_eficiencia; i++){
 482:	000d4f63          	bltz	s10,4a0 <main+0x42c>
 486:	4781                	li	a5,0
        total_eficiencia += eficiencias[i];
 488:	b7442683          	lw	a3,-1164(s0)
 48c:	000c2703          	lw	a4,0(s8)
 490:	9f35                	addw	a4,a4,a3
 492:	b6e42a23          	sw	a4,-1164(s0)
    for (int i = 0; i < index_eficiencia; i++){
 496:	873e                	mv	a4,a5
 498:	2785                	addw	a5,a5,1
 49a:	0c11                	add	s8,s8,4
 49c:	feead6e3          	bge	s5,a4,488 <main+0x414>
    }
    for (int i = 0; i < index_overhead; i++){
 4a0:	87da                	mv	a5,s6
 4a2:	334b0b13          	add	s6,s6,820
        total_overhead += overheads[i];
 4a6:	b7042683          	lw	a3,-1168(s0)
 4aa:	4398                	lw	a4,0(a5)
 4ac:	9f35                	addw	a4,a4,a3
 4ae:	b6e42823          	sw	a4,-1168(s0)
    for (int i = 0; i < index_overhead; i++){
 4b2:	0791                	add	a5,a5,4
 4b4:	fefb19e3          	bne	s6,a5,4a6 <main+0x432>
    }

    write(fd_eficiencia, &total_eficiencia, sizeof(int));
 4b8:	4611                	li	a2,4
 4ba:	b7440593          	add	a1,s0,-1164
 4be:	b6843503          	ld	a0,-1176(s0)
 4c2:	300000ef          	jal	7c2 <write>
    write(fd_overhead, &total_overhead, sizeof(int));
 4c6:	4611                	li	a2,4
 4c8:	b7040593          	add	a1,s0,-1168
 4cc:	b6043503          	ld	a0,-1184(s0)
 4d0:	2f2000ef          	jal	7c2 <write>

    pid = getpid();
 4d4:	34e000ef          	jal	822 <getpid>

    // int eficiencia = get_eficiencia(pid);
    // printf("Eficiência do processo %d: %d\n", pid, eficiencia);

    return 0;
 4d8:	4501                	li	a0,0
 4da:	49813083          	ld	ra,1176(sp)
 4de:	49013403          	ld	s0,1168(sp)
 4e2:	48813483          	ld	s1,1160(sp)
 4e6:	48013903          	ld	s2,1152(sp)
 4ea:	47813983          	ld	s3,1144(sp)
 4ee:	47013a03          	ld	s4,1136(sp)
 4f2:	46813a83          	ld	s5,1128(sp)
 4f6:	46013b03          	ld	s6,1120(sp)
 4fa:	45813b83          	ld	s7,1112(sp)
 4fe:	45013c03          	ld	s8,1104(sp)
 502:	44813c83          	ld	s9,1096(sp)
 506:	44013d03          	ld	s10,1088(sp)
 50a:	43813d83          	ld	s11,1080(sp)
 50e:	4a010113          	add	sp,sp,1184
 512:	8082                	ret
            printf("error, write permut failed\n");
 514:	00001517          	auipc	a0,0x1
 518:	94450513          	add	a0,a0,-1724 # e58 <malloc+0x1c8>
 51c:	6c0000ef          	jal	bdc <printf>
            exit(1);
 520:	4505                	li	a0,1
 522:	280000ef          	jal	7a2 <exit>
        printf("Erro ao remover o arquivo\n");
 526:	00001517          	auipc	a0,0x1
 52a:	95250513          	add	a0,a0,-1710 # e78 <malloc+0x1e8>
 52e:	6ae000ef          	jal	bdc <printf>
        exit(1);
 532:	4505                	li	a0,1
 534:	26e000ef          	jal	7a2 <exit>

0000000000000538 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 538:	1141                	add	sp,sp,-16
 53a:	e406                	sd	ra,8(sp)
 53c:	e022                	sd	s0,0(sp)
 53e:	0800                	add	s0,sp,16
  extern int main();
  main();
 540:	b35ff0ef          	jal	74 <main>
  exit(0);
 544:	4501                	li	a0,0
 546:	25c000ef          	jal	7a2 <exit>

000000000000054a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 54a:	1141                	add	sp,sp,-16
 54c:	e422                	sd	s0,8(sp)
 54e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 550:	87aa                	mv	a5,a0
 552:	0585                	add	a1,a1,1
 554:	0785                	add	a5,a5,1
 556:	fff5c703          	lbu	a4,-1(a1)
 55a:	fee78fa3          	sb	a4,-1(a5)
 55e:	fb75                	bnez	a4,552 <strcpy+0x8>
    ;
  return os;
}
 560:	6422                	ld	s0,8(sp)
 562:	0141                	add	sp,sp,16
 564:	8082                	ret

0000000000000566 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 566:	1141                	add	sp,sp,-16
 568:	e422                	sd	s0,8(sp)
 56a:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 56c:	00054783          	lbu	a5,0(a0)
 570:	cb91                	beqz	a5,584 <strcmp+0x1e>
 572:	0005c703          	lbu	a4,0(a1)
 576:	00f71763          	bne	a4,a5,584 <strcmp+0x1e>
    p++, q++;
 57a:	0505                	add	a0,a0,1
 57c:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 57e:	00054783          	lbu	a5,0(a0)
 582:	fbe5                	bnez	a5,572 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 584:	0005c503          	lbu	a0,0(a1)
}
 588:	40a7853b          	subw	a0,a5,a0
 58c:	6422                	ld	s0,8(sp)
 58e:	0141                	add	sp,sp,16
 590:	8082                	ret

0000000000000592 <strlen>:

uint
strlen(const char *s)
{
 592:	1141                	add	sp,sp,-16
 594:	e422                	sd	s0,8(sp)
 596:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 598:	00054783          	lbu	a5,0(a0)
 59c:	cf91                	beqz	a5,5b8 <strlen+0x26>
 59e:	0505                	add	a0,a0,1
 5a0:	87aa                	mv	a5,a0
 5a2:	86be                	mv	a3,a5
 5a4:	0785                	add	a5,a5,1
 5a6:	fff7c703          	lbu	a4,-1(a5)
 5aa:	ff65                	bnez	a4,5a2 <strlen+0x10>
 5ac:	40a6853b          	subw	a0,a3,a0
 5b0:	2505                	addw	a0,a0,1
    ;
  return n;
}
 5b2:	6422                	ld	s0,8(sp)
 5b4:	0141                	add	sp,sp,16
 5b6:	8082                	ret
  for(n = 0; s[n]; n++)
 5b8:	4501                	li	a0,0
 5ba:	bfe5                	j	5b2 <strlen+0x20>

00000000000005bc <memset>:

void*
memset(void *dst, int c, uint n)
{
 5bc:	1141                	add	sp,sp,-16
 5be:	e422                	sd	s0,8(sp)
 5c0:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5c2:	ca19                	beqz	a2,5d8 <memset+0x1c>
 5c4:	87aa                	mv	a5,a0
 5c6:	1602                	sll	a2,a2,0x20
 5c8:	9201                	srl	a2,a2,0x20
 5ca:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5ce:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5d2:	0785                	add	a5,a5,1
 5d4:	fee79de3          	bne	a5,a4,5ce <memset+0x12>
  }
  return dst;
}
 5d8:	6422                	ld	s0,8(sp)
 5da:	0141                	add	sp,sp,16
 5dc:	8082                	ret

00000000000005de <strchr>:

char*
strchr(const char *s, char c)
{
 5de:	1141                	add	sp,sp,-16
 5e0:	e422                	sd	s0,8(sp)
 5e2:	0800                	add	s0,sp,16
  for(; *s; s++)
 5e4:	00054783          	lbu	a5,0(a0)
 5e8:	cb99                	beqz	a5,5fe <strchr+0x20>
    if(*s == c)
 5ea:	00f58763          	beq	a1,a5,5f8 <strchr+0x1a>
  for(; *s; s++)
 5ee:	0505                	add	a0,a0,1
 5f0:	00054783          	lbu	a5,0(a0)
 5f4:	fbfd                	bnez	a5,5ea <strchr+0xc>
      return (char*)s;
  return 0;
 5f6:	4501                	li	a0,0
}
 5f8:	6422                	ld	s0,8(sp)
 5fa:	0141                	add	sp,sp,16
 5fc:	8082                	ret
  return 0;
 5fe:	4501                	li	a0,0
 600:	bfe5                	j	5f8 <strchr+0x1a>

0000000000000602 <gets>:

char*
gets(char *buf, int max)
{
 602:	711d                	add	sp,sp,-96
 604:	ec86                	sd	ra,88(sp)
 606:	e8a2                	sd	s0,80(sp)
 608:	e4a6                	sd	s1,72(sp)
 60a:	e0ca                	sd	s2,64(sp)
 60c:	fc4e                	sd	s3,56(sp)
 60e:	f852                	sd	s4,48(sp)
 610:	f456                	sd	s5,40(sp)
 612:	f05a                	sd	s6,32(sp)
 614:	ec5e                	sd	s7,24(sp)
 616:	1080                	add	s0,sp,96
 618:	8baa                	mv	s7,a0
 61a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 61c:	892a                	mv	s2,a0
 61e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 620:	4aa9                	li	s5,10
 622:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 624:	89a6                	mv	s3,s1
 626:	2485                	addw	s1,s1,1
 628:	0344d663          	bge	s1,s4,654 <gets+0x52>
    cc = read(0, &c, 1);
 62c:	4605                	li	a2,1
 62e:	faf40593          	add	a1,s0,-81
 632:	4501                	li	a0,0
 634:	186000ef          	jal	7ba <read>
    if(cc < 1)
 638:	00a05e63          	blez	a0,654 <gets+0x52>
    buf[i++] = c;
 63c:	faf44783          	lbu	a5,-81(s0)
 640:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 644:	01578763          	beq	a5,s5,652 <gets+0x50>
 648:	0905                	add	s2,s2,1
 64a:	fd679de3          	bne	a5,s6,624 <gets+0x22>
  for(i=0; i+1 < max; ){
 64e:	89a6                	mv	s3,s1
 650:	a011                	j	654 <gets+0x52>
 652:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 654:	99de                	add	s3,s3,s7
 656:	00098023          	sb	zero,0(s3)
  return buf;
}
 65a:	855e                	mv	a0,s7
 65c:	60e6                	ld	ra,88(sp)
 65e:	6446                	ld	s0,80(sp)
 660:	64a6                	ld	s1,72(sp)
 662:	6906                	ld	s2,64(sp)
 664:	79e2                	ld	s3,56(sp)
 666:	7a42                	ld	s4,48(sp)
 668:	7aa2                	ld	s5,40(sp)
 66a:	7b02                	ld	s6,32(sp)
 66c:	6be2                	ld	s7,24(sp)
 66e:	6125                	add	sp,sp,96
 670:	8082                	ret

0000000000000672 <stat>:

int
stat(const char *n, struct stat *st)
{
 672:	1101                	add	sp,sp,-32
 674:	ec06                	sd	ra,24(sp)
 676:	e822                	sd	s0,16(sp)
 678:	e426                	sd	s1,8(sp)
 67a:	e04a                	sd	s2,0(sp)
 67c:	1000                	add	s0,sp,32
 67e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 680:	4581                	li	a1,0
 682:	160000ef          	jal	7e2 <open>
  if(fd < 0)
 686:	02054163          	bltz	a0,6a8 <stat+0x36>
 68a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 68c:	85ca                	mv	a1,s2
 68e:	16c000ef          	jal	7fa <fstat>
 692:	892a                	mv	s2,a0
  close(fd);
 694:	8526                	mv	a0,s1
 696:	134000ef          	jal	7ca <close>
  return r;
}
 69a:	854a                	mv	a0,s2
 69c:	60e2                	ld	ra,24(sp)
 69e:	6442                	ld	s0,16(sp)
 6a0:	64a2                	ld	s1,8(sp)
 6a2:	6902                	ld	s2,0(sp)
 6a4:	6105                	add	sp,sp,32
 6a6:	8082                	ret
    return -1;
 6a8:	597d                	li	s2,-1
 6aa:	bfc5                	j	69a <stat+0x28>

00000000000006ac <atoi>:

int
atoi(const char *s)
{
 6ac:	1141                	add	sp,sp,-16
 6ae:	e422                	sd	s0,8(sp)
 6b0:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6b2:	00054683          	lbu	a3,0(a0)
 6b6:	fd06879b          	addw	a5,a3,-48
 6ba:	0ff7f793          	zext.b	a5,a5
 6be:	4625                	li	a2,9
 6c0:	02f66863          	bltu	a2,a5,6f0 <atoi+0x44>
 6c4:	872a                	mv	a4,a0
  n = 0;
 6c6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 6c8:	0705                	add	a4,a4,1
 6ca:	0025179b          	sllw	a5,a0,0x2
 6ce:	9fa9                	addw	a5,a5,a0
 6d0:	0017979b          	sllw	a5,a5,0x1
 6d4:	9fb5                	addw	a5,a5,a3
 6d6:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6da:	00074683          	lbu	a3,0(a4)
 6de:	fd06879b          	addw	a5,a3,-48
 6e2:	0ff7f793          	zext.b	a5,a5
 6e6:	fef671e3          	bgeu	a2,a5,6c8 <atoi+0x1c>
  return n;
}
 6ea:	6422                	ld	s0,8(sp)
 6ec:	0141                	add	sp,sp,16
 6ee:	8082                	ret
  n = 0;
 6f0:	4501                	li	a0,0
 6f2:	bfe5                	j	6ea <atoi+0x3e>

00000000000006f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6f4:	1141                	add	sp,sp,-16
 6f6:	e422                	sd	s0,8(sp)
 6f8:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6fa:	02b57463          	bgeu	a0,a1,722 <memmove+0x2e>
    while(n-- > 0)
 6fe:	00c05f63          	blez	a2,71c <memmove+0x28>
 702:	1602                	sll	a2,a2,0x20
 704:	9201                	srl	a2,a2,0x20
 706:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 70a:	872a                	mv	a4,a0
      *dst++ = *src++;
 70c:	0585                	add	a1,a1,1
 70e:	0705                	add	a4,a4,1
 710:	fff5c683          	lbu	a3,-1(a1)
 714:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 718:	fee79ae3          	bne	a5,a4,70c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 71c:	6422                	ld	s0,8(sp)
 71e:	0141                	add	sp,sp,16
 720:	8082                	ret
    dst += n;
 722:	00c50733          	add	a4,a0,a2
    src += n;
 726:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 728:	fec05ae3          	blez	a2,71c <memmove+0x28>
 72c:	fff6079b          	addw	a5,a2,-1
 730:	1782                	sll	a5,a5,0x20
 732:	9381                	srl	a5,a5,0x20
 734:	fff7c793          	not	a5,a5
 738:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 73a:	15fd                	add	a1,a1,-1
 73c:	177d                	add	a4,a4,-1
 73e:	0005c683          	lbu	a3,0(a1)
 742:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 746:	fee79ae3          	bne	a5,a4,73a <memmove+0x46>
 74a:	bfc9                	j	71c <memmove+0x28>

000000000000074c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 74c:	1141                	add	sp,sp,-16
 74e:	e422                	sd	s0,8(sp)
 750:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 752:	ca05                	beqz	a2,782 <memcmp+0x36>
 754:	fff6069b          	addw	a3,a2,-1
 758:	1682                	sll	a3,a3,0x20
 75a:	9281                	srl	a3,a3,0x20
 75c:	0685                	add	a3,a3,1
 75e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 760:	00054783          	lbu	a5,0(a0)
 764:	0005c703          	lbu	a4,0(a1)
 768:	00e79863          	bne	a5,a4,778 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 76c:	0505                	add	a0,a0,1
    p2++;
 76e:	0585                	add	a1,a1,1
  while (n-- > 0) {
 770:	fed518e3          	bne	a0,a3,760 <memcmp+0x14>
  }
  return 0;
 774:	4501                	li	a0,0
 776:	a019                	j	77c <memcmp+0x30>
      return *p1 - *p2;
 778:	40e7853b          	subw	a0,a5,a4
}
 77c:	6422                	ld	s0,8(sp)
 77e:	0141                	add	sp,sp,16
 780:	8082                	ret
  return 0;
 782:	4501                	li	a0,0
 784:	bfe5                	j	77c <memcmp+0x30>

0000000000000786 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 786:	1141                	add	sp,sp,-16
 788:	e406                	sd	ra,8(sp)
 78a:	e022                	sd	s0,0(sp)
 78c:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 78e:	f67ff0ef          	jal	6f4 <memmove>
}
 792:	60a2                	ld	ra,8(sp)
 794:	6402                	ld	s0,0(sp)
 796:	0141                	add	sp,sp,16
 798:	8082                	ret

000000000000079a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 79a:	4885                	li	a7,1
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 7a2:	4889                	li	a7,2
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <wait>:
.global wait
wait:
 li a7, SYS_wait
 7aa:	488d                	li	a7,3
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7b2:	4891                	li	a7,4
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	8082                	ret

00000000000007ba <read>:
.global read
read:
 li a7, SYS_read
 7ba:	4895                	li	a7,5
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <write>:
.global write
write:
 li a7, SYS_write
 7c2:	48c1                	li	a7,16
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <close>:
.global close
close:
 li a7, SYS_close
 7ca:	48d5                	li	a7,21
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 7d2:	4899                	li	a7,6
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	8082                	ret

00000000000007da <exec>:
.global exec
exec:
 li a7, SYS_exec
 7da:	489d                	li	a7,7
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <open>:
.global open
open:
 li a7, SYS_open
 7e2:	48bd                	li	a7,15
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7ea:	48c5                	li	a7,17
 ecall
 7ec:	00000073          	ecall
 ret
 7f0:	8082                	ret

00000000000007f2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7f2:	48c9                	li	a7,18
 ecall
 7f4:	00000073          	ecall
 ret
 7f8:	8082                	ret

00000000000007fa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7fa:	48a1                	li	a7,8
 ecall
 7fc:	00000073          	ecall
 ret
 800:	8082                	ret

0000000000000802 <link>:
.global link
link:
 li a7, SYS_link
 802:	48cd                	li	a7,19
 ecall
 804:	00000073          	ecall
 ret
 808:	8082                	ret

000000000000080a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 80a:	48d1                	li	a7,20
 ecall
 80c:	00000073          	ecall
 ret
 810:	8082                	ret

0000000000000812 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 812:	48a5                	li	a7,9
 ecall
 814:	00000073          	ecall
 ret
 818:	8082                	ret

000000000000081a <dup>:
.global dup
dup:
 li a7, SYS_dup
 81a:	48a9                	li	a7,10
 ecall
 81c:	00000073          	ecall
 ret
 820:	8082                	ret

0000000000000822 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 822:	48ad                	li	a7,11
 ecall
 824:	00000073          	ecall
 ret
 828:	8082                	ret

000000000000082a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 82a:	48b1                	li	a7,12
 ecall
 82c:	00000073          	ecall
 ret
 830:	8082                	ret

0000000000000832 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 832:	48b5                	li	a7,13
 ecall
 834:	00000073          	ecall
 ret
 838:	8082                	ret

000000000000083a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 83a:	48b9                	li	a7,14
 ecall
 83c:	00000073          	ecall
 ret
 840:	8082                	ret

0000000000000842 <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 842:	48d9                	li	a7,22
 ecall
 844:	00000073          	ecall
 ret
 848:	8082                	ret

000000000000084a <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 84a:	48e1                	li	a7,24
 ecall
 84c:	00000073          	ecall
 ret
 850:	8082                	ret

0000000000000852 <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 852:	48dd                	li	a7,23
 ecall
 854:	00000073          	ecall
 ret
 858:	8082                	ret

000000000000085a <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 85a:	48e5                	li	a7,25
 ecall
 85c:	00000073          	ecall
 ret
 860:	8082                	ret

0000000000000862 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 862:	1101                	add	sp,sp,-32
 864:	ec06                	sd	ra,24(sp)
 866:	e822                	sd	s0,16(sp)
 868:	1000                	add	s0,sp,32
 86a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 86e:	4605                	li	a2,1
 870:	fef40593          	add	a1,s0,-17
 874:	f4fff0ef          	jal	7c2 <write>
}
 878:	60e2                	ld	ra,24(sp)
 87a:	6442                	ld	s0,16(sp)
 87c:	6105                	add	sp,sp,32
 87e:	8082                	ret

0000000000000880 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 880:	7139                	add	sp,sp,-64
 882:	fc06                	sd	ra,56(sp)
 884:	f822                	sd	s0,48(sp)
 886:	f426                	sd	s1,40(sp)
 888:	f04a                	sd	s2,32(sp)
 88a:	ec4e                	sd	s3,24(sp)
 88c:	0080                	add	s0,sp,64
 88e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 890:	c299                	beqz	a3,896 <printint+0x16>
 892:	0805c763          	bltz	a1,920 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 896:	2581                	sext.w	a1,a1
  neg = 0;
 898:	4881                	li	a7,0
 89a:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 89e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8a0:	2601                	sext.w	a2,a2
 8a2:	00000517          	auipc	a0,0x0
 8a6:	61650513          	add	a0,a0,1558 # eb8 <digits>
 8aa:	883a                	mv	a6,a4
 8ac:	2705                	addw	a4,a4,1
 8ae:	02c5f7bb          	remuw	a5,a1,a2
 8b2:	1782                	sll	a5,a5,0x20
 8b4:	9381                	srl	a5,a5,0x20
 8b6:	97aa                	add	a5,a5,a0
 8b8:	0007c783          	lbu	a5,0(a5)
 8bc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8c0:	0005879b          	sext.w	a5,a1
 8c4:	02c5d5bb          	divuw	a1,a1,a2
 8c8:	0685                	add	a3,a3,1
 8ca:	fec7f0e3          	bgeu	a5,a2,8aa <printint+0x2a>
  if(neg)
 8ce:	00088c63          	beqz	a7,8e6 <printint+0x66>
    buf[i++] = '-';
 8d2:	fd070793          	add	a5,a4,-48
 8d6:	00878733          	add	a4,a5,s0
 8da:	02d00793          	li	a5,45
 8de:	fef70823          	sb	a5,-16(a4)
 8e2:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 8e6:	02e05663          	blez	a4,912 <printint+0x92>
 8ea:	fc040793          	add	a5,s0,-64
 8ee:	00e78933          	add	s2,a5,a4
 8f2:	fff78993          	add	s3,a5,-1
 8f6:	99ba                	add	s3,s3,a4
 8f8:	377d                	addw	a4,a4,-1
 8fa:	1702                	sll	a4,a4,0x20
 8fc:	9301                	srl	a4,a4,0x20
 8fe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 902:	fff94583          	lbu	a1,-1(s2)
 906:	8526                	mv	a0,s1
 908:	f5bff0ef          	jal	862 <putc>
  while(--i >= 0)
 90c:	197d                	add	s2,s2,-1
 90e:	ff391ae3          	bne	s2,s3,902 <printint+0x82>
}
 912:	70e2                	ld	ra,56(sp)
 914:	7442                	ld	s0,48(sp)
 916:	74a2                	ld	s1,40(sp)
 918:	7902                	ld	s2,32(sp)
 91a:	69e2                	ld	s3,24(sp)
 91c:	6121                	add	sp,sp,64
 91e:	8082                	ret
    x = -xx;
 920:	40b005bb          	negw	a1,a1
    neg = 1;
 924:	4885                	li	a7,1
    x = -xx;
 926:	bf95                	j	89a <printint+0x1a>

0000000000000928 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 928:	711d                	add	sp,sp,-96
 92a:	ec86                	sd	ra,88(sp)
 92c:	e8a2                	sd	s0,80(sp)
 92e:	e4a6                	sd	s1,72(sp)
 930:	e0ca                	sd	s2,64(sp)
 932:	fc4e                	sd	s3,56(sp)
 934:	f852                	sd	s4,48(sp)
 936:	f456                	sd	s5,40(sp)
 938:	f05a                	sd	s6,32(sp)
 93a:	ec5e                	sd	s7,24(sp)
 93c:	e862                	sd	s8,16(sp)
 93e:	e466                	sd	s9,8(sp)
 940:	e06a                	sd	s10,0(sp)
 942:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 944:	0005c903          	lbu	s2,0(a1)
 948:	24090763          	beqz	s2,b96 <vprintf+0x26e>
 94c:	8b2a                	mv	s6,a0
 94e:	8a2e                	mv	s4,a1
 950:	8bb2                	mv	s7,a2
  state = 0;
 952:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 954:	4481                	li	s1,0
 956:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 958:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 95c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 960:	06c00c93          	li	s9,108
 964:	a005                	j	984 <vprintf+0x5c>
        putc(fd, c0);
 966:	85ca                	mv	a1,s2
 968:	855a                	mv	a0,s6
 96a:	ef9ff0ef          	jal	862 <putc>
 96e:	a019                	j	974 <vprintf+0x4c>
    } else if(state == '%'){
 970:	03598263          	beq	s3,s5,994 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 974:	2485                	addw	s1,s1,1
 976:	8726                	mv	a4,s1
 978:	009a07b3          	add	a5,s4,s1
 97c:	0007c903          	lbu	s2,0(a5)
 980:	20090b63          	beqz	s2,b96 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 984:	0009079b          	sext.w	a5,s2
    if(state == 0){
 988:	fe0994e3          	bnez	s3,970 <vprintf+0x48>
      if(c0 == '%'){
 98c:	fd579de3          	bne	a5,s5,966 <vprintf+0x3e>
        state = '%';
 990:	89be                	mv	s3,a5
 992:	b7cd                	j	974 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 994:	c7c9                	beqz	a5,a1e <vprintf+0xf6>
 996:	00ea06b3          	add	a3,s4,a4
 99a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 99e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 9a0:	c681                	beqz	a3,9a8 <vprintf+0x80>
 9a2:	9752                	add	a4,a4,s4
 9a4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 9a8:	03878f63          	beq	a5,s8,9e6 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 9ac:	05978963          	beq	a5,s9,9fe <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 9b0:	07500713          	li	a4,117
 9b4:	0ee78363          	beq	a5,a4,a9a <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 9b8:	07800713          	li	a4,120
 9bc:	12e78563          	beq	a5,a4,ae6 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 9c0:	07000713          	li	a4,112
 9c4:	14e78a63          	beq	a5,a4,b18 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 9c8:	07300713          	li	a4,115
 9cc:	18e78863          	beq	a5,a4,b5c <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 9d0:	02500713          	li	a4,37
 9d4:	04e79563          	bne	a5,a4,a1e <vprintf+0xf6>
        putc(fd, '%');
 9d8:	02500593          	li	a1,37
 9dc:	855a                	mv	a0,s6
 9de:	e85ff0ef          	jal	862 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 9e2:	4981                	li	s3,0
 9e4:	bf41                	j	974 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 9e6:	008b8913          	add	s2,s7,8
 9ea:	4685                	li	a3,1
 9ec:	4629                	li	a2,10
 9ee:	000ba583          	lw	a1,0(s7)
 9f2:	855a                	mv	a0,s6
 9f4:	e8dff0ef          	jal	880 <printint>
 9f8:	8bca                	mv	s7,s2
      state = 0;
 9fa:	4981                	li	s3,0
 9fc:	bfa5                	j	974 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 9fe:	06400793          	li	a5,100
 a02:	02f68963          	beq	a3,a5,a34 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a06:	06c00793          	li	a5,108
 a0a:	04f68263          	beq	a3,a5,a4e <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 a0e:	07500793          	li	a5,117
 a12:	0af68063          	beq	a3,a5,ab2 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 a16:	07800793          	li	a5,120
 a1a:	0ef68263          	beq	a3,a5,afe <vprintf+0x1d6>
        putc(fd, '%');
 a1e:	02500593          	li	a1,37
 a22:	855a                	mv	a0,s6
 a24:	e3fff0ef          	jal	862 <putc>
        putc(fd, c0);
 a28:	85ca                	mv	a1,s2
 a2a:	855a                	mv	a0,s6
 a2c:	e37ff0ef          	jal	862 <putc>
      state = 0;
 a30:	4981                	li	s3,0
 a32:	b789                	j	974 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a34:	008b8913          	add	s2,s7,8
 a38:	4685                	li	a3,1
 a3a:	4629                	li	a2,10
 a3c:	000ba583          	lw	a1,0(s7)
 a40:	855a                	mv	a0,s6
 a42:	e3fff0ef          	jal	880 <printint>
        i += 1;
 a46:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a48:	8bca                	mv	s7,s2
      state = 0;
 a4a:	4981                	li	s3,0
        i += 1;
 a4c:	b725                	j	974 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a4e:	06400793          	li	a5,100
 a52:	02f60763          	beq	a2,a5,a80 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a56:	07500793          	li	a5,117
 a5a:	06f60963          	beq	a2,a5,acc <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a5e:	07800793          	li	a5,120
 a62:	faf61ee3          	bne	a2,a5,a1e <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a66:	008b8913          	add	s2,s7,8
 a6a:	4681                	li	a3,0
 a6c:	4641                	li	a2,16
 a6e:	000ba583          	lw	a1,0(s7)
 a72:	855a                	mv	a0,s6
 a74:	e0dff0ef          	jal	880 <printint>
        i += 2;
 a78:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a7a:	8bca                	mv	s7,s2
      state = 0;
 a7c:	4981                	li	s3,0
        i += 2;
 a7e:	bddd                	j	974 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a80:	008b8913          	add	s2,s7,8
 a84:	4685                	li	a3,1
 a86:	4629                	li	a2,10
 a88:	000ba583          	lw	a1,0(s7)
 a8c:	855a                	mv	a0,s6
 a8e:	df3ff0ef          	jal	880 <printint>
        i += 2;
 a92:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a94:	8bca                	mv	s7,s2
      state = 0;
 a96:	4981                	li	s3,0
        i += 2;
 a98:	bdf1                	j	974 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 a9a:	008b8913          	add	s2,s7,8
 a9e:	4681                	li	a3,0
 aa0:	4629                	li	a2,10
 aa2:	000ba583          	lw	a1,0(s7)
 aa6:	855a                	mv	a0,s6
 aa8:	dd9ff0ef          	jal	880 <printint>
 aac:	8bca                	mv	s7,s2
      state = 0;
 aae:	4981                	li	s3,0
 ab0:	b5d1                	j	974 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ab2:	008b8913          	add	s2,s7,8
 ab6:	4681                	li	a3,0
 ab8:	4629                	li	a2,10
 aba:	000ba583          	lw	a1,0(s7)
 abe:	855a                	mv	a0,s6
 ac0:	dc1ff0ef          	jal	880 <printint>
        i += 1;
 ac4:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 ac6:	8bca                	mv	s7,s2
      state = 0;
 ac8:	4981                	li	s3,0
        i += 1;
 aca:	b56d                	j	974 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 acc:	008b8913          	add	s2,s7,8
 ad0:	4681                	li	a3,0
 ad2:	4629                	li	a2,10
 ad4:	000ba583          	lw	a1,0(s7)
 ad8:	855a                	mv	a0,s6
 ada:	da7ff0ef          	jal	880 <printint>
        i += 2;
 ade:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 ae0:	8bca                	mv	s7,s2
      state = 0;
 ae2:	4981                	li	s3,0
        i += 2;
 ae4:	bd41                	j	974 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 ae6:	008b8913          	add	s2,s7,8
 aea:	4681                	li	a3,0
 aec:	4641                	li	a2,16
 aee:	000ba583          	lw	a1,0(s7)
 af2:	855a                	mv	a0,s6
 af4:	d8dff0ef          	jal	880 <printint>
 af8:	8bca                	mv	s7,s2
      state = 0;
 afa:	4981                	li	s3,0
 afc:	bda5                	j	974 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 afe:	008b8913          	add	s2,s7,8
 b02:	4681                	li	a3,0
 b04:	4641                	li	a2,16
 b06:	000ba583          	lw	a1,0(s7)
 b0a:	855a                	mv	a0,s6
 b0c:	d75ff0ef          	jal	880 <printint>
        i += 1;
 b10:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 b12:	8bca                	mv	s7,s2
      state = 0;
 b14:	4981                	li	s3,0
        i += 1;
 b16:	bdb9                	j	974 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 b18:	008b8d13          	add	s10,s7,8
 b1c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b20:	03000593          	li	a1,48
 b24:	855a                	mv	a0,s6
 b26:	d3dff0ef          	jal	862 <putc>
  putc(fd, 'x');
 b2a:	07800593          	li	a1,120
 b2e:	855a                	mv	a0,s6
 b30:	d33ff0ef          	jal	862 <putc>
 b34:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b36:	00000b97          	auipc	s7,0x0
 b3a:	382b8b93          	add	s7,s7,898 # eb8 <digits>
 b3e:	03c9d793          	srl	a5,s3,0x3c
 b42:	97de                	add	a5,a5,s7
 b44:	0007c583          	lbu	a1,0(a5)
 b48:	855a                	mv	a0,s6
 b4a:	d19ff0ef          	jal	862 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b4e:	0992                	sll	s3,s3,0x4
 b50:	397d                	addw	s2,s2,-1
 b52:	fe0916e3          	bnez	s2,b3e <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 b56:	8bea                	mv	s7,s10
      state = 0;
 b58:	4981                	li	s3,0
 b5a:	bd29                	j	974 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 b5c:	008b8993          	add	s3,s7,8
 b60:	000bb903          	ld	s2,0(s7)
 b64:	00090f63          	beqz	s2,b82 <vprintf+0x25a>
        for(; *s; s++)
 b68:	00094583          	lbu	a1,0(s2)
 b6c:	c195                	beqz	a1,b90 <vprintf+0x268>
          putc(fd, *s);
 b6e:	855a                	mv	a0,s6
 b70:	cf3ff0ef          	jal	862 <putc>
        for(; *s; s++)
 b74:	0905                	add	s2,s2,1
 b76:	00094583          	lbu	a1,0(s2)
 b7a:	f9f5                	bnez	a1,b6e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b7c:	8bce                	mv	s7,s3
      state = 0;
 b7e:	4981                	li	s3,0
 b80:	bbd5                	j	974 <vprintf+0x4c>
          s = "(null)";
 b82:	00000917          	auipc	s2,0x0
 b86:	32e90913          	add	s2,s2,814 # eb0 <malloc+0x220>
        for(; *s; s++)
 b8a:	02800593          	li	a1,40
 b8e:	b7c5                	j	b6e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b90:	8bce                	mv	s7,s3
      state = 0;
 b92:	4981                	li	s3,0
 b94:	b3c5                	j	974 <vprintf+0x4c>
    }
  }
}
 b96:	60e6                	ld	ra,88(sp)
 b98:	6446                	ld	s0,80(sp)
 b9a:	64a6                	ld	s1,72(sp)
 b9c:	6906                	ld	s2,64(sp)
 b9e:	79e2                	ld	s3,56(sp)
 ba0:	7a42                	ld	s4,48(sp)
 ba2:	7aa2                	ld	s5,40(sp)
 ba4:	7b02                	ld	s6,32(sp)
 ba6:	6be2                	ld	s7,24(sp)
 ba8:	6c42                	ld	s8,16(sp)
 baa:	6ca2                	ld	s9,8(sp)
 bac:	6d02                	ld	s10,0(sp)
 bae:	6125                	add	sp,sp,96
 bb0:	8082                	ret

0000000000000bb2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 bb2:	715d                	add	sp,sp,-80
 bb4:	ec06                	sd	ra,24(sp)
 bb6:	e822                	sd	s0,16(sp)
 bb8:	1000                	add	s0,sp,32
 bba:	e010                	sd	a2,0(s0)
 bbc:	e414                	sd	a3,8(s0)
 bbe:	e818                	sd	a4,16(s0)
 bc0:	ec1c                	sd	a5,24(s0)
 bc2:	03043023          	sd	a6,32(s0)
 bc6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 bca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 bce:	8622                	mv	a2,s0
 bd0:	d59ff0ef          	jal	928 <vprintf>
}
 bd4:	60e2                	ld	ra,24(sp)
 bd6:	6442                	ld	s0,16(sp)
 bd8:	6161                	add	sp,sp,80
 bda:	8082                	ret

0000000000000bdc <printf>:

void
printf(const char *fmt, ...)
{
 bdc:	711d                	add	sp,sp,-96
 bde:	ec06                	sd	ra,24(sp)
 be0:	e822                	sd	s0,16(sp)
 be2:	1000                	add	s0,sp,32
 be4:	e40c                	sd	a1,8(s0)
 be6:	e810                	sd	a2,16(s0)
 be8:	ec14                	sd	a3,24(s0)
 bea:	f018                	sd	a4,32(s0)
 bec:	f41c                	sd	a5,40(s0)
 bee:	03043823          	sd	a6,48(s0)
 bf2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 bf6:	00840613          	add	a2,s0,8
 bfa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 bfe:	85aa                	mv	a1,a0
 c00:	4505                	li	a0,1
 c02:	d27ff0ef          	jal	928 <vprintf>
}
 c06:	60e2                	ld	ra,24(sp)
 c08:	6442                	ld	s0,16(sp)
 c0a:	6125                	add	sp,sp,96
 c0c:	8082                	ret

0000000000000c0e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c0e:	1141                	add	sp,sp,-16
 c10:	e422                	sd	s0,8(sp)
 c12:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c14:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c18:	00000797          	auipc	a5,0x0
 c1c:	3f87b783          	ld	a5,1016(a5) # 1010 <freep>
 c20:	a02d                	j	c4a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c22:	4618                	lw	a4,8(a2)
 c24:	9f2d                	addw	a4,a4,a1
 c26:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c2a:	6398                	ld	a4,0(a5)
 c2c:	6310                	ld	a2,0(a4)
 c2e:	a83d                	j	c6c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c30:	ff852703          	lw	a4,-8(a0)
 c34:	9f31                	addw	a4,a4,a2
 c36:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c38:	ff053683          	ld	a3,-16(a0)
 c3c:	a091                	j	c80 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c3e:	6398                	ld	a4,0(a5)
 c40:	00e7e463          	bltu	a5,a4,c48 <free+0x3a>
 c44:	00e6ea63          	bltu	a3,a4,c58 <free+0x4a>
{
 c48:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c4a:	fed7fae3          	bgeu	a5,a3,c3e <free+0x30>
 c4e:	6398                	ld	a4,0(a5)
 c50:	00e6e463          	bltu	a3,a4,c58 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c54:	fee7eae3          	bltu	a5,a4,c48 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 c58:	ff852583          	lw	a1,-8(a0)
 c5c:	6390                	ld	a2,0(a5)
 c5e:	02059813          	sll	a6,a1,0x20
 c62:	01c85713          	srl	a4,a6,0x1c
 c66:	9736                	add	a4,a4,a3
 c68:	fae60de3          	beq	a2,a4,c22 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 c6c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c70:	4790                	lw	a2,8(a5)
 c72:	02061593          	sll	a1,a2,0x20
 c76:	01c5d713          	srl	a4,a1,0x1c
 c7a:	973e                	add	a4,a4,a5
 c7c:	fae68ae3          	beq	a3,a4,c30 <free+0x22>
    p->s.ptr = bp->s.ptr;
 c80:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c82:	00000717          	auipc	a4,0x0
 c86:	38f73723          	sd	a5,910(a4) # 1010 <freep>
}
 c8a:	6422                	ld	s0,8(sp)
 c8c:	0141                	add	sp,sp,16
 c8e:	8082                	ret

0000000000000c90 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c90:	7139                	add	sp,sp,-64
 c92:	fc06                	sd	ra,56(sp)
 c94:	f822                	sd	s0,48(sp)
 c96:	f426                	sd	s1,40(sp)
 c98:	f04a                	sd	s2,32(sp)
 c9a:	ec4e                	sd	s3,24(sp)
 c9c:	e852                	sd	s4,16(sp)
 c9e:	e456                	sd	s5,8(sp)
 ca0:	e05a                	sd	s6,0(sp)
 ca2:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ca4:	02051493          	sll	s1,a0,0x20
 ca8:	9081                	srl	s1,s1,0x20
 caa:	04bd                	add	s1,s1,15
 cac:	8091                	srl	s1,s1,0x4
 cae:	0014899b          	addw	s3,s1,1
 cb2:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 cb4:	00000517          	auipc	a0,0x0
 cb8:	35c53503          	ld	a0,860(a0) # 1010 <freep>
 cbc:	c515                	beqz	a0,ce8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cbe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cc0:	4798                	lw	a4,8(a5)
 cc2:	02977f63          	bgeu	a4,s1,d00 <malloc+0x70>
  if(nu < 4096)
 cc6:	8a4e                	mv	s4,s3
 cc8:	0009871b          	sext.w	a4,s3
 ccc:	6685                	lui	a3,0x1
 cce:	00d77363          	bgeu	a4,a3,cd4 <malloc+0x44>
 cd2:	6a05                	lui	s4,0x1
 cd4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 cd8:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 cdc:	00000917          	auipc	s2,0x0
 ce0:	33490913          	add	s2,s2,820 # 1010 <freep>
  if(p == (char*)-1)
 ce4:	5afd                	li	s5,-1
 ce6:	a885                	j	d56 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 ce8:	00000797          	auipc	a5,0x0
 cec:	33878793          	add	a5,a5,824 # 1020 <base>
 cf0:	00000717          	auipc	a4,0x0
 cf4:	32f73023          	sd	a5,800(a4) # 1010 <freep>
 cf8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 cfa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 cfe:	b7e1                	j	cc6 <malloc+0x36>
      if(p->s.size == nunits)
 d00:	02e48c63          	beq	s1,a4,d38 <malloc+0xa8>
        p->s.size -= nunits;
 d04:	4137073b          	subw	a4,a4,s3
 d08:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d0a:	02071693          	sll	a3,a4,0x20
 d0e:	01c6d713          	srl	a4,a3,0x1c
 d12:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d14:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d18:	00000717          	auipc	a4,0x0
 d1c:	2ea73c23          	sd	a0,760(a4) # 1010 <freep>
      return (void*)(p + 1);
 d20:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 d24:	70e2                	ld	ra,56(sp)
 d26:	7442                	ld	s0,48(sp)
 d28:	74a2                	ld	s1,40(sp)
 d2a:	7902                	ld	s2,32(sp)
 d2c:	69e2                	ld	s3,24(sp)
 d2e:	6a42                	ld	s4,16(sp)
 d30:	6aa2                	ld	s5,8(sp)
 d32:	6b02                	ld	s6,0(sp)
 d34:	6121                	add	sp,sp,64
 d36:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 d38:	6398                	ld	a4,0(a5)
 d3a:	e118                	sd	a4,0(a0)
 d3c:	bff1                	j	d18 <malloc+0x88>
  hp->s.size = nu;
 d3e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d42:	0541                	add	a0,a0,16
 d44:	ecbff0ef          	jal	c0e <free>
  return freep;
 d48:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d4c:	dd61                	beqz	a0,d24 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d4e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d50:	4798                	lw	a4,8(a5)
 d52:	fa9777e3          	bgeu	a4,s1,d00 <malloc+0x70>
    if(p == freep)
 d56:	00093703          	ld	a4,0(s2)
 d5a:	853e                	mv	a0,a5
 d5c:	fef719e3          	bne	a4,a5,d4e <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 d60:	8552                	mv	a0,s4
 d62:	ac9ff0ef          	jal	82a <sbrk>
  if(p == (char*)-1)
 d66:	fd551ce3          	bne	a0,s5,d3e <malloc+0xae>
        return 0;
 d6a:	4501                	li	a0,0
 d6c:	bf65                	j	d24 <malloc+0x94>
