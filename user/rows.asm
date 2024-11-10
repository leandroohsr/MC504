
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

    int index = 0;
    index += (argv[1][0] - '0') * 10;
  b0:	6598                	ld	a4,8(a1)
  b2:	00074783          	lbu	a5,0(a4) # ffffffff80000000 <base+0xffffffff7fffefe0>
  b6:	fd07879b          	addw	a5,a5,-48
  ba:	00279b9b          	sllw	s7,a5,0x2
  be:	00fb8bbb          	addw	s7,s7,a5
  c2:	001b9b9b          	sllw	s7,s7,0x1
    index += (argv[1][1] - '0');
  c6:	00174783          	lbu	a5,1(a4)
  ca:	fd07879b          	addw	a5,a5,-48
  ce:	00fb8bbb          	addw	s7,s7,a5

    int index_eficiencia = 0, index_overhead = 0;
    int *eficiencias = malloc(500 * sizeof(int));
  d2:	7d000513          	li	a0,2000
  d6:	3d7000ef          	jal	cac <malloc>
  da:	8c2a                	mv	s8,a0
    int *overheads = malloc(500 * sizeof(int));
  dc:	7d000513          	li	a0,2000
  e0:	3cd000ef          	jal	cac <malloc>
  e4:	8b2a                	mv	s6,a0

    int fd;
    char filename[20] = "iobound";
  e6:	00001797          	auipc	a5,0x1
  ea:	dd27b783          	ld	a5,-558(a5) # eb8 <malloc+0x20c>
  ee:	f6f43c23          	sd	a5,-136(s0)
  f2:	f8043023          	sd	zero,-128(s0)
  f6:	f8042423          	sw	zero,-120(s0)
    char pid_str[10];
    char *suffix = ".txt";

    int pid = getpid();
  fa:	72c000ef          	jal	826 <getpid>

    pid += 1000; //valores baixos dão problema
  fe:	3e85071b          	addw	a4,a0,1000

    int i = 0;
 102:	f6840693          	add	a3,s0,-152
    pid += 1000; //valores baixos dão problema
 106:	8636                	mv	a2,a3
    int i = 0;
 108:	4781                	li	a5,0
    do {
        pid_str[i++] = pid % 10 + '0';   // próximo digito
 10a:	4829                	li	a6,10
    } while ((pid /= 10) > 0);
 10c:	48a5                	li	a7,9
        pid_str[i++] = pid % 10 + '0';   // próximo digito
 10e:	85be                	mv	a1,a5
 110:	2785                	addw	a5,a5,1
 112:	0307653b          	remw	a0,a4,a6
 116:	0305051b          	addw	a0,a0,48
 11a:	00a60023          	sb	a0,0(a2)
    } while ((pid /= 10) > 0);
 11e:	853a                	mv	a0,a4
 120:	0307473b          	divw	a4,a4,a6
 124:	0605                	add	a2,a2,1
 126:	fea8c4e3          	blt	a7,a0,10e <main+0x9a>
    pid_str[i] = '\0';
 12a:	f9078793          	add	a5,a5,-112
 12e:	97a2                	add	a5,a5,s0
 130:	fc078c23          	sb	zero,-40(a5)

    int j;
    char temp;
    for (j = 0, i--; j < i; j++, i--) {
 134:	18b05663          	blez	a1,2c0 <main+0x24c>
 138:	f6840793          	add	a5,s0,-152
 13c:	97ae                	add	a5,a5,a1
 13e:	4701                	li	a4,0
        temp = pid_str[j];
 140:	0006c603          	lbu	a2,0(a3)
        pid_str[j] = pid_str[i];
 144:	0007c503          	lbu	a0,0(a5)
 148:	00a68023          	sb	a0,0(a3)
        pid_str[i] = temp;
 14c:	00c78023          	sb	a2,0(a5)
    for (j = 0, i--; j < i; j++, i--) {
 150:	0017061b          	addw	a2,a4,1
 154:	0006071b          	sext.w	a4,a2
 158:	0685                	add	a3,a3,1
 15a:	17fd                	add	a5,a5,-1
 15c:	40c5863b          	subw	a2,a1,a2
 160:	fec740e3          	blt	a4,a2,140 <main+0xcc>
    }

    i = 7;
    while (pid_str[j] != '\0') {
 164:	f9070793          	add	a5,a4,-112
 168:	97a2                	add	a5,a5,s0
 16a:	fd87c603          	lbu	a2,-40(a5)
 16e:	14060b63          	beqz	a2,2c4 <main+0x250>
 172:	46a1                	li	a3,8
        filename[i++] = pid_str[j++];
 174:	f7840793          	add	a5,s0,-136
 178:	97b6                	add	a5,a5,a3
 17a:	fec78fa3          	sb	a2,-1(a5)
    while (pid_str[j] != '\0') {
 17e:	87b6                	mv	a5,a3
 180:	0685                	add	a3,a3,1
 182:	00d70633          	add	a2,a4,a3
 186:	f6840593          	add	a1,s0,-152
 18a:	962e                	add	a2,a2,a1
 18c:	ff864603          	lbu	a2,-8(a2)
 190:	f275                	bnez	a2,174 <main+0x100>
        filename[i++] = pid_str[j++];
 192:	2781                	sext.w	a5,a5
    }
    j = 0;
    while (suffix[j] != '\0') {
 194:	2785                	addw	a5,a5,1
 196:	00001617          	auipc	a2,0x1
 19a:	bfb60613          	add	a2,a2,-1029 # d91 <malloc+0xe5>
 19e:	02e00693          	li	a3,46
        filename[i++] = suffix[j++];
 1a2:	f7840713          	add	a4,s0,-136
 1a6:	973e                	add	a4,a4,a5
 1a8:	fed70fa3          	sb	a3,-1(a4)
    while (suffix[j] != '\0') {
 1ac:	00064683          	lbu	a3,0(a2)
 1b0:	873e                	mv	a4,a5
 1b2:	0785                	add	a5,a5,1
 1b4:	0605                	add	a2,a2,1
 1b6:	f6f5                	bnez	a3,1a2 <main+0x12e>
    }
    filename[i] = '\0';
 1b8:	0007079b          	sext.w	a5,a4
 1bc:	f9078793          	add	a5,a5,-112
 1c0:	97a2                	add	a5,a5,s0
 1c2:	fe078423          	sb	zero,-24(a5)

    t0 = uptime();
 1c6:	678000ef          	jal	83e <uptime>
 1ca:	84aa                	mv	s1,a0
    fd = open(filename, O_CREATE | O_RDWR);
 1cc:	20200593          	li	a1,514
 1d0:	f7840513          	add	a0,s0,-136
 1d4:	612000ef          	jal	7e6 <open>
 1d8:	8d2a                	mv	s10,a0
    t1 = uptime();
 1da:	664000ef          	jal	83e <uptime>
    overheads[index_overhead++] = t1 - t0;
 1de:	409507bb          	subw	a5,a0,s1
 1e2:	00fb2023          	sw	a5,0(s6)

    if (fd < 0){
 1e6:	0e0d4163          	bltz	s10,2c8 <main+0x254>
    }

    char *caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$&*()";

    char linha[101];
    linha[100] = '\n';
 1ea:	47a9                	li	a5,10
 1ec:	f6f40223          	sb	a5,-156(s0)
    int size = 101;
    for(i=0;i<100;i++){ //escreve as linhas
 1f0:	b7843423          	sd	s8,-1176(s0)
    linha[100] = '\n';
 1f4:	8ce2                	mv	s9,s8
    int index_eficiencia = 0, index_overhead = 0;
 1f6:	4a81                	li	s5,0
 1f8:	f6440a13          	add	s4,s0,-156
        for(int j=0;j<100;j++){ //escreve os caracteres
            int c = rand() % 70;
 1fc:	04600993          	li	s3,70
            linha[j] = caracteres[c];
 200:	00001917          	auipc	s2,0x1
 204:	bb890913          	add	s2,s2,-1096 # db8 <malloc+0x10c>
    for(i=0;i<100;i++){ //escreve as linhas
 208:	06400d93          	li	s11,100
        for(int j=0;j<100;j++){ //escreve os caracteres
 20c:	f0040493          	add	s1,s0,-256
            int c = rand() % 70;
 210:	e49ff0ef          	jal	58 <rand>
            linha[j] = caracteres[c];
 214:	0335653b          	remw	a0,a0,s3
 218:	954a                	add	a0,a0,s2
 21a:	00054783          	lbu	a5,0(a0)
 21e:	00f48023          	sb	a5,0(s1)
        for(int j=0;j<100;j++){ //escreve os caracteres
 222:	0485                	add	s1,s1,1
 224:	ff4496e3          	bne	s1,s4,210 <main+0x19c>
        }
        t0 = uptime();
 228:	616000ef          	jal	83e <uptime>
 22c:	84aa                	mv	s1,a0
        if(write(fd, linha, size) != size){
 22e:	06500613          	li	a2,101
 232:	f0040593          	add	a1,s0,-256
 236:	856a                	mv	a0,s10
 238:	58e000ef          	jal	7c6 <write>
 23c:	06500793          	li	a5,101
 240:	08f51d63          	bne	a0,a5,2da <main+0x266>
            printf("error, write failed\n");
            exit(1);
        } else {  //a escrita deu certo
            t1 = uptime();
 244:	5fa000ef          	jal	83e <uptime>
            eficiencias[index_eficiencia++] = t1 - t0;
 248:	2a85                	addw	s5,s5,1
 24a:	409507bb          	subw	a5,a0,s1
 24e:	00fca023          	sw	a5,0(s9)
    for(i=0;i<100;i++){ //escreve as linhas
 252:	0c91                	add	s9,s9,4
 254:	fbba9ce3          	bne	s5,s11,20c <main+0x198>
        }
    }
    close(fd);
 258:	856a                	mv	a0,s10
 25a:	574000ef          	jal	7ce <close>



    char *linhas[100];
    for (int j = 0; j < 100; j++) {
 25e:	be040993          	add	s3,s0,-1056
 262:	004b0913          	add	s2,s6,4
 266:	f0040c93          	add	s9,s0,-256
    close(fd);
 26a:	84ce                	mv	s1,s3
        t0 = uptime();
 26c:	5d2000ef          	jal	83e <uptime>
 270:	8a2a                	mv	s4,a0
        linhas[j] = malloc(102 * sizeof(char)); // Allocate memory for each string
 272:	06600513          	li	a0,102
 276:	237000ef          	jal	cac <malloc>
 27a:	e088                	sd	a0,0(s1)
        t1 = uptime();
 27c:	5c2000ef          	jal	83e <uptime>
        overheads[index_overhead++] = t1 - t0;
 280:	4145053b          	subw	a0,a0,s4
 284:	00a92023          	sw	a0,0(s2)
    for (int j = 0; j < 100; j++) {
 288:	04a1                	add	s1,s1,8
 28a:	0911                	add	s2,s2,4
 28c:	ff9490e3          	bne	s1,s9,26c <main+0x1f8>
    }

    t0 = uptime();
 290:	5ae000ef          	jal	83e <uptime>
 294:	84aa                	mv	s1,a0
    fd = open(filename, O_RDONLY);
 296:	4581                	li	a1,0
 298:	f7840513          	add	a0,s0,-136
 29c:	54a000ef          	jal	7e6 <open>
 2a0:	892a                	mv	s2,a0
    t1 = uptime();
 2a2:	59c000ef          	jal	83e <uptime>
    overheads[index_overhead++] = t1 - t0;
 2a6:	409507bb          	subw	a5,a0,s1
 2aa:	18fb2a23          	sw	a5,404(s6)
    if (fd < 0) {
 2ae:	02094f63          	bltz	s2,2ec <main+0x278>
    }

    char buf[101];
    int n;
    i = 0;
    t0 = uptime();
 2b2:	58c000ef          	jal	83e <uptime>
 2b6:	84aa                	mv	s1,a0
    while((n = read(fd, buf, sizeof(buf))) > 0) {
 2b8:	190c0d13          	add	s10,s8,400
 2bc:	8a4e                	mv	s4,s3
 2be:	a0a5                	j	326 <main+0x2b2>
    for (j = 0, i--; j < i; j++, i--) {
 2c0:	4701                	li	a4,0
 2c2:	b54d                	j	164 <main+0xf0>
    i = 7;
 2c4:	479d                	li	a5,7
 2c6:	b5f9                	j	194 <main+0x120>
        printf("erro ao criar o arquivo %s\n", filename);
 2c8:	f7840593          	add	a1,s0,-136
 2cc:	00001517          	auipc	a0,0x1
 2d0:	acc50513          	add	a0,a0,-1332 # d98 <malloc+0xec>
 2d4:	125000ef          	jal	bf8 <printf>
 2d8:	bf09                	j	1ea <main+0x176>
            printf("error, write failed\n");
 2da:	00001517          	auipc	a0,0x1
 2de:	b2650513          	add	a0,a0,-1242 # e00 <malloc+0x154>
 2e2:	117000ef          	jal	bf8 <printf>
            exit(1);
 2e6:	4505                	li	a0,1
 2e8:	4be000ef          	jal	7a6 <exit>
        printf("Erro ao abrir o arquivo %s\n", filename);
 2ec:	f7840593          	add	a1,s0,-136
 2f0:	00001517          	auipc	a0,0x1
 2f4:	b2850513          	add	a0,a0,-1240 # e18 <malloc+0x16c>
 2f8:	101000ef          	jal	bf8 <printf>
        exit(1);
 2fc:	4505                	li	a0,1
 2fe:	4a8000ef          	jal	7a6 <exit>
        t1 = uptime();
 302:	53c000ef          	jal	83e <uptime>
        eficiencias[index_eficiencia++] = t1 - t0;
 306:	2a85                	addw	s5,s5,1
 308:	409507bb          	subw	a5,a0,s1
 30c:	00fd2023          	sw	a5,0(s10)
        strcpy(linhas[i], buf);
 310:	b7840593          	add	a1,s0,-1160
 314:	000a3503          	ld	a0,0(s4)
 318:	236000ef          	jal	54e <strcpy>
        i++;
        t0 = uptime();
 31c:	522000ef          	jal	83e <uptime>
 320:	84aa                	mv	s1,a0
 322:	0d11                	add	s10,s10,4
 324:	0a21                	add	s4,s4,8
    while((n = read(fd, buf, sizeof(buf))) > 0) {
 326:	06500613          	li	a2,101
 32a:	b7840593          	add	a1,s0,-1160
 32e:	854a                	mv	a0,s2
 330:	48e000ef          	jal	7be <read>
 334:	fca047e3          	bgtz	a0,302 <main+0x28e>
    }

    close(fd);
 338:	854a                	mv	a0,s2
 33a:	494000ef          	jal	7ce <close>


    char *tmp;
    t0 = uptime();
 33e:	500000ef          	jal	83e <uptime>
 342:	84aa                	mv	s1,a0
    tmp = malloc(102*sizeof(char));
 344:	06600513          	li	a0,102
 348:	165000ef          	jal	cac <malloc>
 34c:	8d2a                	mv	s10,a0
    t1 = uptime();
 34e:	4f0000ef          	jal	83e <uptime>
    overheads[index_overhead++] = t1 - t0;
 352:	409507bb          	subw	a5,a0,s1
 356:	18fb2c23          	sw	a5,408(s6)
 35a:	03200a13          	li	s4,50

    for (i = 0; i < 50; i++){
        //getting random rows
        int row1 = rand() % 100;
 35e:	06400d93          	li	s11,100
 362:	cf7ff0ef          	jal	58 <rand>
 366:	892a                	mv	s2,a0
        int row2 = rand() % 100;
 368:	cf1ff0ef          	jal	58 <rand>
 36c:	84aa                	mv	s1,a0

        //swapping them
        strcpy(tmp, linhas[row1]);
 36e:	03b967bb          	remw	a5,s2,s11
 372:	078e                	sll	a5,a5,0x3
 374:	f9078793          	add	a5,a5,-112
 378:	97a2                	add	a5,a5,s0
 37a:	c507b903          	ld	s2,-944(a5)
 37e:	85ca                	mv	a1,s2
 380:	856a                	mv	a0,s10
 382:	1cc000ef          	jal	54e <strcpy>
        strcpy(linhas[row1], linhas[row2]);
 386:	03b4e7bb          	remw	a5,s1,s11
 38a:	078e                	sll	a5,a5,0x3
 38c:	f9078793          	add	a5,a5,-112
 390:	97a2                	add	a5,a5,s0
 392:	c507b483          	ld	s1,-944(a5)
 396:	85a6                	mv	a1,s1
 398:	854a                	mv	a0,s2
 39a:	1b4000ef          	jal	54e <strcpy>
        strcpy(linhas[row2], tmp);
 39e:	85ea                	mv	a1,s10
 3a0:	8526                	mv	a0,s1
 3a2:	1ac000ef          	jal	54e <strcpy>
    for (i = 0; i < 50; i++){
 3a6:	3a7d                	addw	s4,s4,-1
 3a8:	fa0a1de3          	bnez	s4,362 <main+0x2ee>
    }
    t0 = uptime();
 3ac:	492000ef          	jal	83e <uptime>
 3b0:	84aa                	mv	s1,a0
    free(tmp);
 3b2:	856a                	mv	a0,s10
 3b4:	077000ef          	jal	c2a <free>
    t1 = uptime();
 3b8:	486000ef          	jal	83e <uptime>
    overheads[index_overhead++] = t1 - t0;
 3bc:	409507bb          	subw	a5,a0,s1
 3c0:	18fb2e23          	sw	a5,412(s6)

    //rewriting file after permutations
    t0 = uptime();
 3c4:	47a000ef          	jal	83e <uptime>
 3c8:	84aa                	mv	s1,a0
    fd = open(filename, O_RDWR);
 3ca:	4589                	li	a1,2
 3cc:	f7840513          	add	a0,s0,-136
 3d0:	416000ef          	jal	7e6 <open>
 3d4:	8daa                	mv	s11,a0
    t1 = uptime();
 3d6:	468000ef          	jal	83e <uptime>
    overheads[index_overhead++] = t1 - t0;
 3da:	409507bb          	subw	a5,a0,s1
 3de:	1afb2023          	sw	a5,416(s6)
    if (fd < 0) {
 3e2:	000dc763          	bltz	s11,3f0 <main+0x37c>
        printf("Erro ao reabrir o arquivo %s para escrever as permutações\n", filename);
        exit(1);
    }

    size = 101;
    for (int i = 0; i < 100; i++){
 3e6:	002a9a13          	sll	s4,s5,0x2
 3ea:	9a62                	add	s4,s4,s8
    if (fd < 0) {
 3ec:	84ce                	mv	s1,s3
 3ee:	a829                	j	408 <main+0x394>
        printf("Erro ao reabrir o arquivo %s para escrever as permutações\n", filename);
 3f0:	f7840593          	add	a1,s0,-136
 3f4:	00001517          	auipc	a0,0x1
 3f8:	a4450513          	add	a0,a0,-1468 # e38 <malloc+0x18c>
 3fc:	7fc000ef          	jal	bf8 <printf>
        exit(1);
 400:	4505                	li	a0,1
 402:	3a4000ef          	jal	7a6 <exit>
        if(write(fd, linhas[i], size) != size){
            printf("error, write permut failed\n");
            exit(1);
        } else {
            t1 = uptime();
            eficiencias[index_eficiencia++] = t1 - t0;
 406:	8aea                	mv	s5,s10
        t0 = uptime();
 408:	436000ef          	jal	83e <uptime>
 40c:	892a                	mv	s2,a0
        if(write(fd, linhas[i], size) != size){
 40e:	06500613          	li	a2,101
 412:	608c                	ld	a1,0(s1)
 414:	856e                	mv	a0,s11
 416:	3b0000ef          	jal	7c6 <write>
 41a:	06500793          	li	a5,101
 41e:	0ef51b63          	bne	a0,a5,514 <main+0x4a0>
            t1 = uptime();
 422:	41c000ef          	jal	83e <uptime>
            eficiencias[index_eficiencia++] = t1 - t0;
 426:	001a8d1b          	addw	s10,s5,1
 42a:	412507bb          	subw	a5,a0,s2
 42e:	00fa2023          	sw	a5,0(s4)
    for (int i = 0; i < 100; i++){
 432:	04a1                	add	s1,s1,8
 434:	0a11                	add	s4,s4,4
 436:	fd9498e3          	bne	s1,s9,406 <main+0x392>
        }
    }

    close(fd);
 43a:	856e                	mv	a0,s11
 43c:	392000ef          	jal	7ce <close>

    //removing file
    t0 = uptime();
 440:	3fe000ef          	jal	83e <uptime>
 444:	84aa                	mv	s1,a0
    if (unlink(filename) < 0){
 446:	f7840513          	add	a0,s0,-136
 44a:	3ac000ef          	jal	7f6 <unlink>
 44e:	0c054c63          	bltz	a0,526 <main+0x4b2>
        printf("Erro ao remover o arquivo\n");
        exit(1);
    } else {
        t1 = uptime();
 452:	3ec000ef          	jal	83e <uptime>
        eficiencias[index_eficiencia++] = t1 - t0;
 456:	002d1793          	sll	a5,s10,0x2
 45a:	9c3e                	add	s8,s8,a5
 45c:	409507bb          	subw	a5,a0,s1
 460:	00fc2023          	sw	a5,0(s8)
    }


    //free malloc for linhas
    for (int j = 0; j < 100; j++) {
 464:	1a4b0913          	add	s2,s6,420
        t0 = uptime();
 468:	3d6000ef          	jal	83e <uptime>
 46c:	84aa                	mv	s1,a0
        free(linhas[j]);
 46e:	0009b503          	ld	a0,0(s3)
 472:	7b8000ef          	jal	c2a <free>
        t1 = uptime();
 476:	3c8000ef          	jal	83e <uptime>
        overheads[index_overhead++] = t1 - t0;
 47a:	409507bb          	subw	a5,a0,s1
 47e:	00f92023          	sw	a5,0(s2)
    for (int j = 0; j < 100; j++) {
 482:	09a1                	add	s3,s3,8
 484:	0911                	add	s2,s2,4
 486:	ff9991e3          	bne	s3,s9,468 <main+0x3f4>

    int total_eficiencia = 0, total_overhead = 0;


    //soma das métricas
    for (int i = 0; i < index_eficiencia; i++){
 48a:	0a0d4763          	bltz	s10,538 <main+0x4c4>
 48e:	4781                	li	a5,0
    int total_eficiencia = 0, total_overhead = 0;
 490:	4581                	li	a1,0
        total_eficiencia += eficiencias[i];
 492:	b6843683          	ld	a3,-1176(s0)
 496:	4298                	lw	a4,0(a3)
 498:	9db9                	addw	a1,a1,a4
    for (int i = 0; i < index_eficiencia; i++){
 49a:	873e                	mv	a4,a5
 49c:	2785                	addw	a5,a5,1
 49e:	0691                	add	a3,a3,4
 4a0:	b6d43423          	sd	a3,-1176(s0)
 4a4:	feead7e3          	bge	s5,a4,492 <main+0x41e>
    }
    for (int i = 0; i < index_overhead; i++){
 4a8:	87da                	mv	a5,s6
 4aa:	334b0b13          	add	s6,s6,820
    int total_eficiencia = 0, total_overhead = 0;
 4ae:	4481                	li	s1,0
        total_overhead += overheads[i];
 4b0:	4398                	lw	a4,0(a5)
 4b2:	9cb9                	addw	s1,s1,a4
    for (int i = 0; i < index_overhead; i++){
 4b4:	0791                	add	a5,a5,4
 4b6:	fefb1de3          	bne	s6,a5,4b0 <main+0x43c>
    }


    increment_metric(index, total_eficiencia, MODE_EFICIENCIA);
 4ba:	4629                	li	a2,10
 4bc:	855e                	mv	a0,s7
 4be:	3a0000ef          	jal	85e <increment_metric>
    increment_metric(index, total_overhead, MODE_OVERHEAD);
 4c2:	4621                	li	a2,8
 4c4:	85a6                	mv	a1,s1
 4c6:	855e                	mv	a0,s7
 4c8:	396000ef          	jal	85e <increment_metric>

    pid = getpid();
 4cc:	35a000ef          	jal	826 <getpid>
 4d0:	85aa                	mv	a1,a0
    set_justica(index, pid);
 4d2:	855e                	mv	a0,s7
 4d4:	3a2000ef          	jal	876 <set_justica>

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
 518:	96450513          	add	a0,a0,-1692 # e78 <malloc+0x1cc>
 51c:	6dc000ef          	jal	bf8 <printf>
            exit(1);
 520:	4505                	li	a0,1
 522:	284000ef          	jal	7a6 <exit>
        printf("Erro ao remover o arquivo\n");
 526:	00001517          	auipc	a0,0x1
 52a:	97250513          	add	a0,a0,-1678 # e98 <malloc+0x1ec>
 52e:	6ca000ef          	jal	bf8 <printf>
        exit(1);
 532:	4505                	li	a0,1
 534:	272000ef          	jal	7a6 <exit>
    int total_eficiencia = 0, total_overhead = 0;
 538:	4581                	li	a1,0
 53a:	b7bd                	j	4a8 <main+0x434>

000000000000053c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 53c:	1141                	add	sp,sp,-16
 53e:	e406                	sd	ra,8(sp)
 540:	e022                	sd	s0,0(sp)
 542:	0800                	add	s0,sp,16
  extern int main();
  main();
 544:	b31ff0ef          	jal	74 <main>
  exit(0);
 548:	4501                	li	a0,0
 54a:	25c000ef          	jal	7a6 <exit>

000000000000054e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 54e:	1141                	add	sp,sp,-16
 550:	e422                	sd	s0,8(sp)
 552:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 554:	87aa                	mv	a5,a0
 556:	0585                	add	a1,a1,1
 558:	0785                	add	a5,a5,1
 55a:	fff5c703          	lbu	a4,-1(a1)
 55e:	fee78fa3          	sb	a4,-1(a5)
 562:	fb75                	bnez	a4,556 <strcpy+0x8>
    ;
  return os;
}
 564:	6422                	ld	s0,8(sp)
 566:	0141                	add	sp,sp,16
 568:	8082                	ret

000000000000056a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 56a:	1141                	add	sp,sp,-16
 56c:	e422                	sd	s0,8(sp)
 56e:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 570:	00054783          	lbu	a5,0(a0)
 574:	cb91                	beqz	a5,588 <strcmp+0x1e>
 576:	0005c703          	lbu	a4,0(a1)
 57a:	00f71763          	bne	a4,a5,588 <strcmp+0x1e>
    p++, q++;
 57e:	0505                	add	a0,a0,1
 580:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 582:	00054783          	lbu	a5,0(a0)
 586:	fbe5                	bnez	a5,576 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 588:	0005c503          	lbu	a0,0(a1)
}
 58c:	40a7853b          	subw	a0,a5,a0
 590:	6422                	ld	s0,8(sp)
 592:	0141                	add	sp,sp,16
 594:	8082                	ret

0000000000000596 <strlen>:

uint
strlen(const char *s)
{
 596:	1141                	add	sp,sp,-16
 598:	e422                	sd	s0,8(sp)
 59a:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 59c:	00054783          	lbu	a5,0(a0)
 5a0:	cf91                	beqz	a5,5bc <strlen+0x26>
 5a2:	0505                	add	a0,a0,1
 5a4:	87aa                	mv	a5,a0
 5a6:	86be                	mv	a3,a5
 5a8:	0785                	add	a5,a5,1
 5aa:	fff7c703          	lbu	a4,-1(a5)
 5ae:	ff65                	bnez	a4,5a6 <strlen+0x10>
 5b0:	40a6853b          	subw	a0,a3,a0
 5b4:	2505                	addw	a0,a0,1
    ;
  return n;
}
 5b6:	6422                	ld	s0,8(sp)
 5b8:	0141                	add	sp,sp,16
 5ba:	8082                	ret
  for(n = 0; s[n]; n++)
 5bc:	4501                	li	a0,0
 5be:	bfe5                	j	5b6 <strlen+0x20>

00000000000005c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5c0:	1141                	add	sp,sp,-16
 5c2:	e422                	sd	s0,8(sp)
 5c4:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5c6:	ca19                	beqz	a2,5dc <memset+0x1c>
 5c8:	87aa                	mv	a5,a0
 5ca:	1602                	sll	a2,a2,0x20
 5cc:	9201                	srl	a2,a2,0x20
 5ce:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5d2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5d6:	0785                	add	a5,a5,1
 5d8:	fee79de3          	bne	a5,a4,5d2 <memset+0x12>
  }
  return dst;
}
 5dc:	6422                	ld	s0,8(sp)
 5de:	0141                	add	sp,sp,16
 5e0:	8082                	ret

00000000000005e2 <strchr>:

char*
strchr(const char *s, char c)
{
 5e2:	1141                	add	sp,sp,-16
 5e4:	e422                	sd	s0,8(sp)
 5e6:	0800                	add	s0,sp,16
  for(; *s; s++)
 5e8:	00054783          	lbu	a5,0(a0)
 5ec:	cb99                	beqz	a5,602 <strchr+0x20>
    if(*s == c)
 5ee:	00f58763          	beq	a1,a5,5fc <strchr+0x1a>
  for(; *s; s++)
 5f2:	0505                	add	a0,a0,1
 5f4:	00054783          	lbu	a5,0(a0)
 5f8:	fbfd                	bnez	a5,5ee <strchr+0xc>
      return (char*)s;
  return 0;
 5fa:	4501                	li	a0,0
}
 5fc:	6422                	ld	s0,8(sp)
 5fe:	0141                	add	sp,sp,16
 600:	8082                	ret
  return 0;
 602:	4501                	li	a0,0
 604:	bfe5                	j	5fc <strchr+0x1a>

0000000000000606 <gets>:

char*
gets(char *buf, int max)
{
 606:	711d                	add	sp,sp,-96
 608:	ec86                	sd	ra,88(sp)
 60a:	e8a2                	sd	s0,80(sp)
 60c:	e4a6                	sd	s1,72(sp)
 60e:	e0ca                	sd	s2,64(sp)
 610:	fc4e                	sd	s3,56(sp)
 612:	f852                	sd	s4,48(sp)
 614:	f456                	sd	s5,40(sp)
 616:	f05a                	sd	s6,32(sp)
 618:	ec5e                	sd	s7,24(sp)
 61a:	1080                	add	s0,sp,96
 61c:	8baa                	mv	s7,a0
 61e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 620:	892a                	mv	s2,a0
 622:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 624:	4aa9                	li	s5,10
 626:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 628:	89a6                	mv	s3,s1
 62a:	2485                	addw	s1,s1,1
 62c:	0344d663          	bge	s1,s4,658 <gets+0x52>
    cc = read(0, &c, 1);
 630:	4605                	li	a2,1
 632:	faf40593          	add	a1,s0,-81
 636:	4501                	li	a0,0
 638:	186000ef          	jal	7be <read>
    if(cc < 1)
 63c:	00a05e63          	blez	a0,658 <gets+0x52>
    buf[i++] = c;
 640:	faf44783          	lbu	a5,-81(s0)
 644:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 648:	01578763          	beq	a5,s5,656 <gets+0x50>
 64c:	0905                	add	s2,s2,1
 64e:	fd679de3          	bne	a5,s6,628 <gets+0x22>
  for(i=0; i+1 < max; ){
 652:	89a6                	mv	s3,s1
 654:	a011                	j	658 <gets+0x52>
 656:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 658:	99de                	add	s3,s3,s7
 65a:	00098023          	sb	zero,0(s3)
  return buf;
}
 65e:	855e                	mv	a0,s7
 660:	60e6                	ld	ra,88(sp)
 662:	6446                	ld	s0,80(sp)
 664:	64a6                	ld	s1,72(sp)
 666:	6906                	ld	s2,64(sp)
 668:	79e2                	ld	s3,56(sp)
 66a:	7a42                	ld	s4,48(sp)
 66c:	7aa2                	ld	s5,40(sp)
 66e:	7b02                	ld	s6,32(sp)
 670:	6be2                	ld	s7,24(sp)
 672:	6125                	add	sp,sp,96
 674:	8082                	ret

0000000000000676 <stat>:

int
stat(const char *n, struct stat *st)
{
 676:	1101                	add	sp,sp,-32
 678:	ec06                	sd	ra,24(sp)
 67a:	e822                	sd	s0,16(sp)
 67c:	e426                	sd	s1,8(sp)
 67e:	e04a                	sd	s2,0(sp)
 680:	1000                	add	s0,sp,32
 682:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 684:	4581                	li	a1,0
 686:	160000ef          	jal	7e6 <open>
  if(fd < 0)
 68a:	02054163          	bltz	a0,6ac <stat+0x36>
 68e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 690:	85ca                	mv	a1,s2
 692:	16c000ef          	jal	7fe <fstat>
 696:	892a                	mv	s2,a0
  close(fd);
 698:	8526                	mv	a0,s1
 69a:	134000ef          	jal	7ce <close>
  return r;
}
 69e:	854a                	mv	a0,s2
 6a0:	60e2                	ld	ra,24(sp)
 6a2:	6442                	ld	s0,16(sp)
 6a4:	64a2                	ld	s1,8(sp)
 6a6:	6902                	ld	s2,0(sp)
 6a8:	6105                	add	sp,sp,32
 6aa:	8082                	ret
    return -1;
 6ac:	597d                	li	s2,-1
 6ae:	bfc5                	j	69e <stat+0x28>

00000000000006b0 <atoi>:

int
atoi(const char *s)
{
 6b0:	1141                	add	sp,sp,-16
 6b2:	e422                	sd	s0,8(sp)
 6b4:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6b6:	00054683          	lbu	a3,0(a0)
 6ba:	fd06879b          	addw	a5,a3,-48
 6be:	0ff7f793          	zext.b	a5,a5
 6c2:	4625                	li	a2,9
 6c4:	02f66863          	bltu	a2,a5,6f4 <atoi+0x44>
 6c8:	872a                	mv	a4,a0
  n = 0;
 6ca:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 6cc:	0705                	add	a4,a4,1
 6ce:	0025179b          	sllw	a5,a0,0x2
 6d2:	9fa9                	addw	a5,a5,a0
 6d4:	0017979b          	sllw	a5,a5,0x1
 6d8:	9fb5                	addw	a5,a5,a3
 6da:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6de:	00074683          	lbu	a3,0(a4)
 6e2:	fd06879b          	addw	a5,a3,-48
 6e6:	0ff7f793          	zext.b	a5,a5
 6ea:	fef671e3          	bgeu	a2,a5,6cc <atoi+0x1c>
  return n;
}
 6ee:	6422                	ld	s0,8(sp)
 6f0:	0141                	add	sp,sp,16
 6f2:	8082                	ret
  n = 0;
 6f4:	4501                	li	a0,0
 6f6:	bfe5                	j	6ee <atoi+0x3e>

00000000000006f8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6f8:	1141                	add	sp,sp,-16
 6fa:	e422                	sd	s0,8(sp)
 6fc:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6fe:	02b57463          	bgeu	a0,a1,726 <memmove+0x2e>
    while(n-- > 0)
 702:	00c05f63          	blez	a2,720 <memmove+0x28>
 706:	1602                	sll	a2,a2,0x20
 708:	9201                	srl	a2,a2,0x20
 70a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 70e:	872a                	mv	a4,a0
      *dst++ = *src++;
 710:	0585                	add	a1,a1,1
 712:	0705                	add	a4,a4,1
 714:	fff5c683          	lbu	a3,-1(a1)
 718:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 71c:	fee79ae3          	bne	a5,a4,710 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 720:	6422                	ld	s0,8(sp)
 722:	0141                	add	sp,sp,16
 724:	8082                	ret
    dst += n;
 726:	00c50733          	add	a4,a0,a2
    src += n;
 72a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 72c:	fec05ae3          	blez	a2,720 <memmove+0x28>
 730:	fff6079b          	addw	a5,a2,-1
 734:	1782                	sll	a5,a5,0x20
 736:	9381                	srl	a5,a5,0x20
 738:	fff7c793          	not	a5,a5
 73c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 73e:	15fd                	add	a1,a1,-1
 740:	177d                	add	a4,a4,-1
 742:	0005c683          	lbu	a3,0(a1)
 746:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 74a:	fee79ae3          	bne	a5,a4,73e <memmove+0x46>
 74e:	bfc9                	j	720 <memmove+0x28>

0000000000000750 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 750:	1141                	add	sp,sp,-16
 752:	e422                	sd	s0,8(sp)
 754:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 756:	ca05                	beqz	a2,786 <memcmp+0x36>
 758:	fff6069b          	addw	a3,a2,-1
 75c:	1682                	sll	a3,a3,0x20
 75e:	9281                	srl	a3,a3,0x20
 760:	0685                	add	a3,a3,1
 762:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 764:	00054783          	lbu	a5,0(a0)
 768:	0005c703          	lbu	a4,0(a1)
 76c:	00e79863          	bne	a5,a4,77c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 770:	0505                	add	a0,a0,1
    p2++;
 772:	0585                	add	a1,a1,1
  while (n-- > 0) {
 774:	fed518e3          	bne	a0,a3,764 <memcmp+0x14>
  }
  return 0;
 778:	4501                	li	a0,0
 77a:	a019                	j	780 <memcmp+0x30>
      return *p1 - *p2;
 77c:	40e7853b          	subw	a0,a5,a4
}
 780:	6422                	ld	s0,8(sp)
 782:	0141                	add	sp,sp,16
 784:	8082                	ret
  return 0;
 786:	4501                	li	a0,0
 788:	bfe5                	j	780 <memcmp+0x30>

000000000000078a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 78a:	1141                	add	sp,sp,-16
 78c:	e406                	sd	ra,8(sp)
 78e:	e022                	sd	s0,0(sp)
 790:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 792:	f67ff0ef          	jal	6f8 <memmove>
}
 796:	60a2                	ld	ra,8(sp)
 798:	6402                	ld	s0,0(sp)
 79a:	0141                	add	sp,sp,16
 79c:	8082                	ret

000000000000079e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 79e:	4885                	li	a7,1
 ecall
 7a0:	00000073          	ecall
 ret
 7a4:	8082                	ret

00000000000007a6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 7a6:	4889                	li	a7,2
 ecall
 7a8:	00000073          	ecall
 ret
 7ac:	8082                	ret

00000000000007ae <wait>:
.global wait
wait:
 li a7, SYS_wait
 7ae:	488d                	li	a7,3
 ecall
 7b0:	00000073          	ecall
 ret
 7b4:	8082                	ret

00000000000007b6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7b6:	4891                	li	a7,4
 ecall
 7b8:	00000073          	ecall
 ret
 7bc:	8082                	ret

00000000000007be <read>:
.global read
read:
 li a7, SYS_read
 7be:	4895                	li	a7,5
 ecall
 7c0:	00000073          	ecall
 ret
 7c4:	8082                	ret

00000000000007c6 <write>:
.global write
write:
 li a7, SYS_write
 7c6:	48c1                	li	a7,16
 ecall
 7c8:	00000073          	ecall
 ret
 7cc:	8082                	ret

00000000000007ce <close>:
.global close
close:
 li a7, SYS_close
 7ce:	48d5                	li	a7,21
 ecall
 7d0:	00000073          	ecall
 ret
 7d4:	8082                	ret

00000000000007d6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 7d6:	4899                	li	a7,6
 ecall
 7d8:	00000073          	ecall
 ret
 7dc:	8082                	ret

00000000000007de <exec>:
.global exec
exec:
 li a7, SYS_exec
 7de:	489d                	li	a7,7
 ecall
 7e0:	00000073          	ecall
 ret
 7e4:	8082                	ret

00000000000007e6 <open>:
.global open
open:
 li a7, SYS_open
 7e6:	48bd                	li	a7,15
 ecall
 7e8:	00000073          	ecall
 ret
 7ec:	8082                	ret

00000000000007ee <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7ee:	48c5                	li	a7,17
 ecall
 7f0:	00000073          	ecall
 ret
 7f4:	8082                	ret

00000000000007f6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7f6:	48c9                	li	a7,18
 ecall
 7f8:	00000073          	ecall
 ret
 7fc:	8082                	ret

00000000000007fe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7fe:	48a1                	li	a7,8
 ecall
 800:	00000073          	ecall
 ret
 804:	8082                	ret

0000000000000806 <link>:
.global link
link:
 li a7, SYS_link
 806:	48cd                	li	a7,19
 ecall
 808:	00000073          	ecall
 ret
 80c:	8082                	ret

000000000000080e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 80e:	48d1                	li	a7,20
 ecall
 810:	00000073          	ecall
 ret
 814:	8082                	ret

0000000000000816 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 816:	48a5                	li	a7,9
 ecall
 818:	00000073          	ecall
 ret
 81c:	8082                	ret

000000000000081e <dup>:
.global dup
dup:
 li a7, SYS_dup
 81e:	48a9                	li	a7,10
 ecall
 820:	00000073          	ecall
 ret
 824:	8082                	ret

0000000000000826 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 826:	48ad                	li	a7,11
 ecall
 828:	00000073          	ecall
 ret
 82c:	8082                	ret

000000000000082e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 82e:	48b1                	li	a7,12
 ecall
 830:	00000073          	ecall
 ret
 834:	8082                	ret

0000000000000836 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 836:	48b5                	li	a7,13
 ecall
 838:	00000073          	ecall
 ret
 83c:	8082                	ret

000000000000083e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 83e:	48b9                	li	a7,14
 ecall
 840:	00000073          	ecall
 ret
 844:	8082                	ret

0000000000000846 <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 846:	48d9                	li	a7,22
 ecall
 848:	00000073          	ecall
 ret
 84c:	8082                	ret

000000000000084e <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 84e:	48dd                	li	a7,23
 ecall
 850:	00000073          	ecall
 ret
 854:	8082                	ret

0000000000000856 <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 856:	48e1                	li	a7,24
 ecall
 858:	00000073          	ecall
 ret
 85c:	8082                	ret

000000000000085e <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 85e:	48e5                	li	a7,25
 ecall
 860:	00000073          	ecall
 ret
 864:	8082                	ret

0000000000000866 <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 866:	48e9                	li	a7,26
 ecall
 868:	00000073          	ecall
 ret
 86c:	8082                	ret

000000000000086e <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 86e:	48ed                	li	a7,27
 ecall
 870:	00000073          	ecall
 ret
 874:	8082                	ret

0000000000000876 <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 876:	48f1                	li	a7,28
 ecall
 878:	00000073          	ecall
 ret
 87c:	8082                	ret

000000000000087e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 87e:	1101                	add	sp,sp,-32
 880:	ec06                	sd	ra,24(sp)
 882:	e822                	sd	s0,16(sp)
 884:	1000                	add	s0,sp,32
 886:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 88a:	4605                	li	a2,1
 88c:	fef40593          	add	a1,s0,-17
 890:	f37ff0ef          	jal	7c6 <write>
}
 894:	60e2                	ld	ra,24(sp)
 896:	6442                	ld	s0,16(sp)
 898:	6105                	add	sp,sp,32
 89a:	8082                	ret

000000000000089c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 89c:	7139                	add	sp,sp,-64
 89e:	fc06                	sd	ra,56(sp)
 8a0:	f822                	sd	s0,48(sp)
 8a2:	f426                	sd	s1,40(sp)
 8a4:	f04a                	sd	s2,32(sp)
 8a6:	ec4e                	sd	s3,24(sp)
 8a8:	0080                	add	s0,sp,64
 8aa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 8ac:	c299                	beqz	a3,8b2 <printint+0x16>
 8ae:	0805c763          	bltz	a1,93c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 8b2:	2581                	sext.w	a1,a1
  neg = 0;
 8b4:	4881                	li	a7,0
 8b6:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 8ba:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8bc:	2601                	sext.w	a2,a2
 8be:	00000517          	auipc	a0,0x0
 8c2:	61a50513          	add	a0,a0,1562 # ed8 <digits>
 8c6:	883a                	mv	a6,a4
 8c8:	2705                	addw	a4,a4,1
 8ca:	02c5f7bb          	remuw	a5,a1,a2
 8ce:	1782                	sll	a5,a5,0x20
 8d0:	9381                	srl	a5,a5,0x20
 8d2:	97aa                	add	a5,a5,a0
 8d4:	0007c783          	lbu	a5,0(a5)
 8d8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8dc:	0005879b          	sext.w	a5,a1
 8e0:	02c5d5bb          	divuw	a1,a1,a2
 8e4:	0685                	add	a3,a3,1
 8e6:	fec7f0e3          	bgeu	a5,a2,8c6 <printint+0x2a>
  if(neg)
 8ea:	00088c63          	beqz	a7,902 <printint+0x66>
    buf[i++] = '-';
 8ee:	fd070793          	add	a5,a4,-48
 8f2:	00878733          	add	a4,a5,s0
 8f6:	02d00793          	li	a5,45
 8fa:	fef70823          	sb	a5,-16(a4)
 8fe:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 902:	02e05663          	blez	a4,92e <printint+0x92>
 906:	fc040793          	add	a5,s0,-64
 90a:	00e78933          	add	s2,a5,a4
 90e:	fff78993          	add	s3,a5,-1
 912:	99ba                	add	s3,s3,a4
 914:	377d                	addw	a4,a4,-1
 916:	1702                	sll	a4,a4,0x20
 918:	9301                	srl	a4,a4,0x20
 91a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 91e:	fff94583          	lbu	a1,-1(s2)
 922:	8526                	mv	a0,s1
 924:	f5bff0ef          	jal	87e <putc>
  while(--i >= 0)
 928:	197d                	add	s2,s2,-1
 92a:	ff391ae3          	bne	s2,s3,91e <printint+0x82>
}
 92e:	70e2                	ld	ra,56(sp)
 930:	7442                	ld	s0,48(sp)
 932:	74a2                	ld	s1,40(sp)
 934:	7902                	ld	s2,32(sp)
 936:	69e2                	ld	s3,24(sp)
 938:	6121                	add	sp,sp,64
 93a:	8082                	ret
    x = -xx;
 93c:	40b005bb          	negw	a1,a1
    neg = 1;
 940:	4885                	li	a7,1
    x = -xx;
 942:	bf95                	j	8b6 <printint+0x1a>

0000000000000944 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 944:	711d                	add	sp,sp,-96
 946:	ec86                	sd	ra,88(sp)
 948:	e8a2                	sd	s0,80(sp)
 94a:	e4a6                	sd	s1,72(sp)
 94c:	e0ca                	sd	s2,64(sp)
 94e:	fc4e                	sd	s3,56(sp)
 950:	f852                	sd	s4,48(sp)
 952:	f456                	sd	s5,40(sp)
 954:	f05a                	sd	s6,32(sp)
 956:	ec5e                	sd	s7,24(sp)
 958:	e862                	sd	s8,16(sp)
 95a:	e466                	sd	s9,8(sp)
 95c:	e06a                	sd	s10,0(sp)
 95e:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 960:	0005c903          	lbu	s2,0(a1)
 964:	24090763          	beqz	s2,bb2 <vprintf+0x26e>
 968:	8b2a                	mv	s6,a0
 96a:	8a2e                	mv	s4,a1
 96c:	8bb2                	mv	s7,a2
  state = 0;
 96e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 970:	4481                	li	s1,0
 972:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 974:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 978:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 97c:	06c00c93          	li	s9,108
 980:	a005                	j	9a0 <vprintf+0x5c>
        putc(fd, c0);
 982:	85ca                	mv	a1,s2
 984:	855a                	mv	a0,s6
 986:	ef9ff0ef          	jal	87e <putc>
 98a:	a019                	j	990 <vprintf+0x4c>
    } else if(state == '%'){
 98c:	03598263          	beq	s3,s5,9b0 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 990:	2485                	addw	s1,s1,1
 992:	8726                	mv	a4,s1
 994:	009a07b3          	add	a5,s4,s1
 998:	0007c903          	lbu	s2,0(a5)
 99c:	20090b63          	beqz	s2,bb2 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 9a0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 9a4:	fe0994e3          	bnez	s3,98c <vprintf+0x48>
      if(c0 == '%'){
 9a8:	fd579de3          	bne	a5,s5,982 <vprintf+0x3e>
        state = '%';
 9ac:	89be                	mv	s3,a5
 9ae:	b7cd                	j	990 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 9b0:	c7c9                	beqz	a5,a3a <vprintf+0xf6>
 9b2:	00ea06b3          	add	a3,s4,a4
 9b6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 9ba:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 9bc:	c681                	beqz	a3,9c4 <vprintf+0x80>
 9be:	9752                	add	a4,a4,s4
 9c0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 9c4:	03878f63          	beq	a5,s8,a02 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 9c8:	05978963          	beq	a5,s9,a1a <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 9cc:	07500713          	li	a4,117
 9d0:	0ee78363          	beq	a5,a4,ab6 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 9d4:	07800713          	li	a4,120
 9d8:	12e78563          	beq	a5,a4,b02 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 9dc:	07000713          	li	a4,112
 9e0:	14e78a63          	beq	a5,a4,b34 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 9e4:	07300713          	li	a4,115
 9e8:	18e78863          	beq	a5,a4,b78 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 9ec:	02500713          	li	a4,37
 9f0:	04e79563          	bne	a5,a4,a3a <vprintf+0xf6>
        putc(fd, '%');
 9f4:	02500593          	li	a1,37
 9f8:	855a                	mv	a0,s6
 9fa:	e85ff0ef          	jal	87e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 9fe:	4981                	li	s3,0
 a00:	bf41                	j	990 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 a02:	008b8913          	add	s2,s7,8
 a06:	4685                	li	a3,1
 a08:	4629                	li	a2,10
 a0a:	000ba583          	lw	a1,0(s7)
 a0e:	855a                	mv	a0,s6
 a10:	e8dff0ef          	jal	89c <printint>
 a14:	8bca                	mv	s7,s2
      state = 0;
 a16:	4981                	li	s3,0
 a18:	bfa5                	j	990 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 a1a:	06400793          	li	a5,100
 a1e:	02f68963          	beq	a3,a5,a50 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a22:	06c00793          	li	a5,108
 a26:	04f68263          	beq	a3,a5,a6a <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 a2a:	07500793          	li	a5,117
 a2e:	0af68063          	beq	a3,a5,ace <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 a32:	07800793          	li	a5,120
 a36:	0ef68263          	beq	a3,a5,b1a <vprintf+0x1d6>
        putc(fd, '%');
 a3a:	02500593          	li	a1,37
 a3e:	855a                	mv	a0,s6
 a40:	e3fff0ef          	jal	87e <putc>
        putc(fd, c0);
 a44:	85ca                	mv	a1,s2
 a46:	855a                	mv	a0,s6
 a48:	e37ff0ef          	jal	87e <putc>
      state = 0;
 a4c:	4981                	li	s3,0
 a4e:	b789                	j	990 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a50:	008b8913          	add	s2,s7,8
 a54:	4685                	li	a3,1
 a56:	4629                	li	a2,10
 a58:	000ba583          	lw	a1,0(s7)
 a5c:	855a                	mv	a0,s6
 a5e:	e3fff0ef          	jal	89c <printint>
        i += 1;
 a62:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a64:	8bca                	mv	s7,s2
      state = 0;
 a66:	4981                	li	s3,0
        i += 1;
 a68:	b725                	j	990 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a6a:	06400793          	li	a5,100
 a6e:	02f60763          	beq	a2,a5,a9c <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a72:	07500793          	li	a5,117
 a76:	06f60963          	beq	a2,a5,ae8 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a7a:	07800793          	li	a5,120
 a7e:	faf61ee3          	bne	a2,a5,a3a <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a82:	008b8913          	add	s2,s7,8
 a86:	4681                	li	a3,0
 a88:	4641                	li	a2,16
 a8a:	000ba583          	lw	a1,0(s7)
 a8e:	855a                	mv	a0,s6
 a90:	e0dff0ef          	jal	89c <printint>
        i += 2;
 a94:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a96:	8bca                	mv	s7,s2
      state = 0;
 a98:	4981                	li	s3,0
        i += 2;
 a9a:	bddd                	j	990 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a9c:	008b8913          	add	s2,s7,8
 aa0:	4685                	li	a3,1
 aa2:	4629                	li	a2,10
 aa4:	000ba583          	lw	a1,0(s7)
 aa8:	855a                	mv	a0,s6
 aaa:	df3ff0ef          	jal	89c <printint>
        i += 2;
 aae:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 ab0:	8bca                	mv	s7,s2
      state = 0;
 ab2:	4981                	li	s3,0
        i += 2;
 ab4:	bdf1                	j	990 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 ab6:	008b8913          	add	s2,s7,8
 aba:	4681                	li	a3,0
 abc:	4629                	li	a2,10
 abe:	000ba583          	lw	a1,0(s7)
 ac2:	855a                	mv	a0,s6
 ac4:	dd9ff0ef          	jal	89c <printint>
 ac8:	8bca                	mv	s7,s2
      state = 0;
 aca:	4981                	li	s3,0
 acc:	b5d1                	j	990 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ace:	008b8913          	add	s2,s7,8
 ad2:	4681                	li	a3,0
 ad4:	4629                	li	a2,10
 ad6:	000ba583          	lw	a1,0(s7)
 ada:	855a                	mv	a0,s6
 adc:	dc1ff0ef          	jal	89c <printint>
        i += 1;
 ae0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 ae2:	8bca                	mv	s7,s2
      state = 0;
 ae4:	4981                	li	s3,0
        i += 1;
 ae6:	b56d                	j	990 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ae8:	008b8913          	add	s2,s7,8
 aec:	4681                	li	a3,0
 aee:	4629                	li	a2,10
 af0:	000ba583          	lw	a1,0(s7)
 af4:	855a                	mv	a0,s6
 af6:	da7ff0ef          	jal	89c <printint>
        i += 2;
 afa:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 afc:	8bca                	mv	s7,s2
      state = 0;
 afe:	4981                	li	s3,0
        i += 2;
 b00:	bd41                	j	990 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 b02:	008b8913          	add	s2,s7,8
 b06:	4681                	li	a3,0
 b08:	4641                	li	a2,16
 b0a:	000ba583          	lw	a1,0(s7)
 b0e:	855a                	mv	a0,s6
 b10:	d8dff0ef          	jal	89c <printint>
 b14:	8bca                	mv	s7,s2
      state = 0;
 b16:	4981                	li	s3,0
 b18:	bda5                	j	990 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 b1a:	008b8913          	add	s2,s7,8
 b1e:	4681                	li	a3,0
 b20:	4641                	li	a2,16
 b22:	000ba583          	lw	a1,0(s7)
 b26:	855a                	mv	a0,s6
 b28:	d75ff0ef          	jal	89c <printint>
        i += 1;
 b2c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 b2e:	8bca                	mv	s7,s2
      state = 0;
 b30:	4981                	li	s3,0
        i += 1;
 b32:	bdb9                	j	990 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 b34:	008b8d13          	add	s10,s7,8
 b38:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b3c:	03000593          	li	a1,48
 b40:	855a                	mv	a0,s6
 b42:	d3dff0ef          	jal	87e <putc>
  putc(fd, 'x');
 b46:	07800593          	li	a1,120
 b4a:	855a                	mv	a0,s6
 b4c:	d33ff0ef          	jal	87e <putc>
 b50:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b52:	00000b97          	auipc	s7,0x0
 b56:	386b8b93          	add	s7,s7,902 # ed8 <digits>
 b5a:	03c9d793          	srl	a5,s3,0x3c
 b5e:	97de                	add	a5,a5,s7
 b60:	0007c583          	lbu	a1,0(a5)
 b64:	855a                	mv	a0,s6
 b66:	d19ff0ef          	jal	87e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b6a:	0992                	sll	s3,s3,0x4
 b6c:	397d                	addw	s2,s2,-1
 b6e:	fe0916e3          	bnez	s2,b5a <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 b72:	8bea                	mv	s7,s10
      state = 0;
 b74:	4981                	li	s3,0
 b76:	bd29                	j	990 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 b78:	008b8993          	add	s3,s7,8
 b7c:	000bb903          	ld	s2,0(s7)
 b80:	00090f63          	beqz	s2,b9e <vprintf+0x25a>
        for(; *s; s++)
 b84:	00094583          	lbu	a1,0(s2)
 b88:	c195                	beqz	a1,bac <vprintf+0x268>
          putc(fd, *s);
 b8a:	855a                	mv	a0,s6
 b8c:	cf3ff0ef          	jal	87e <putc>
        for(; *s; s++)
 b90:	0905                	add	s2,s2,1
 b92:	00094583          	lbu	a1,0(s2)
 b96:	f9f5                	bnez	a1,b8a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b98:	8bce                	mv	s7,s3
      state = 0;
 b9a:	4981                	li	s3,0
 b9c:	bbd5                	j	990 <vprintf+0x4c>
          s = "(null)";
 b9e:	00000917          	auipc	s2,0x0
 ba2:	33290913          	add	s2,s2,818 # ed0 <malloc+0x224>
        for(; *s; s++)
 ba6:	02800593          	li	a1,40
 baa:	b7c5                	j	b8a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 bac:	8bce                	mv	s7,s3
      state = 0;
 bae:	4981                	li	s3,0
 bb0:	b3c5                	j	990 <vprintf+0x4c>
    }
  }
}
 bb2:	60e6                	ld	ra,88(sp)
 bb4:	6446                	ld	s0,80(sp)
 bb6:	64a6                	ld	s1,72(sp)
 bb8:	6906                	ld	s2,64(sp)
 bba:	79e2                	ld	s3,56(sp)
 bbc:	7a42                	ld	s4,48(sp)
 bbe:	7aa2                	ld	s5,40(sp)
 bc0:	7b02                	ld	s6,32(sp)
 bc2:	6be2                	ld	s7,24(sp)
 bc4:	6c42                	ld	s8,16(sp)
 bc6:	6ca2                	ld	s9,8(sp)
 bc8:	6d02                	ld	s10,0(sp)
 bca:	6125                	add	sp,sp,96
 bcc:	8082                	ret

0000000000000bce <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 bce:	715d                	add	sp,sp,-80
 bd0:	ec06                	sd	ra,24(sp)
 bd2:	e822                	sd	s0,16(sp)
 bd4:	1000                	add	s0,sp,32
 bd6:	e010                	sd	a2,0(s0)
 bd8:	e414                	sd	a3,8(s0)
 bda:	e818                	sd	a4,16(s0)
 bdc:	ec1c                	sd	a5,24(s0)
 bde:	03043023          	sd	a6,32(s0)
 be2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 be6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 bea:	8622                	mv	a2,s0
 bec:	d59ff0ef          	jal	944 <vprintf>
}
 bf0:	60e2                	ld	ra,24(sp)
 bf2:	6442                	ld	s0,16(sp)
 bf4:	6161                	add	sp,sp,80
 bf6:	8082                	ret

0000000000000bf8 <printf>:

void
printf(const char *fmt, ...)
{
 bf8:	711d                	add	sp,sp,-96
 bfa:	ec06                	sd	ra,24(sp)
 bfc:	e822                	sd	s0,16(sp)
 bfe:	1000                	add	s0,sp,32
 c00:	e40c                	sd	a1,8(s0)
 c02:	e810                	sd	a2,16(s0)
 c04:	ec14                	sd	a3,24(s0)
 c06:	f018                	sd	a4,32(s0)
 c08:	f41c                	sd	a5,40(s0)
 c0a:	03043823          	sd	a6,48(s0)
 c0e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c12:	00840613          	add	a2,s0,8
 c16:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 c1a:	85aa                	mv	a1,a0
 c1c:	4505                	li	a0,1
 c1e:	d27ff0ef          	jal	944 <vprintf>
}
 c22:	60e2                	ld	ra,24(sp)
 c24:	6442                	ld	s0,16(sp)
 c26:	6125                	add	sp,sp,96
 c28:	8082                	ret

0000000000000c2a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c2a:	1141                	add	sp,sp,-16
 c2c:	e422                	sd	s0,8(sp)
 c2e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c30:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c34:	00000797          	auipc	a5,0x0
 c38:	3dc7b783          	ld	a5,988(a5) # 1010 <freep>
 c3c:	a02d                	j	c66 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c3e:	4618                	lw	a4,8(a2)
 c40:	9f2d                	addw	a4,a4,a1
 c42:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c46:	6398                	ld	a4,0(a5)
 c48:	6310                	ld	a2,0(a4)
 c4a:	a83d                	j	c88 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c4c:	ff852703          	lw	a4,-8(a0)
 c50:	9f31                	addw	a4,a4,a2
 c52:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c54:	ff053683          	ld	a3,-16(a0)
 c58:	a091                	j	c9c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c5a:	6398                	ld	a4,0(a5)
 c5c:	00e7e463          	bltu	a5,a4,c64 <free+0x3a>
 c60:	00e6ea63          	bltu	a3,a4,c74 <free+0x4a>
{
 c64:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c66:	fed7fae3          	bgeu	a5,a3,c5a <free+0x30>
 c6a:	6398                	ld	a4,0(a5)
 c6c:	00e6e463          	bltu	a3,a4,c74 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c70:	fee7eae3          	bltu	a5,a4,c64 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 c74:	ff852583          	lw	a1,-8(a0)
 c78:	6390                	ld	a2,0(a5)
 c7a:	02059813          	sll	a6,a1,0x20
 c7e:	01c85713          	srl	a4,a6,0x1c
 c82:	9736                	add	a4,a4,a3
 c84:	fae60de3          	beq	a2,a4,c3e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 c88:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c8c:	4790                	lw	a2,8(a5)
 c8e:	02061593          	sll	a1,a2,0x20
 c92:	01c5d713          	srl	a4,a1,0x1c
 c96:	973e                	add	a4,a4,a5
 c98:	fae68ae3          	beq	a3,a4,c4c <free+0x22>
    p->s.ptr = bp->s.ptr;
 c9c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c9e:	00000717          	auipc	a4,0x0
 ca2:	36f73923          	sd	a5,882(a4) # 1010 <freep>
}
 ca6:	6422                	ld	s0,8(sp)
 ca8:	0141                	add	sp,sp,16
 caa:	8082                	ret

0000000000000cac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 cac:	7139                	add	sp,sp,-64
 cae:	fc06                	sd	ra,56(sp)
 cb0:	f822                	sd	s0,48(sp)
 cb2:	f426                	sd	s1,40(sp)
 cb4:	f04a                	sd	s2,32(sp)
 cb6:	ec4e                	sd	s3,24(sp)
 cb8:	e852                	sd	s4,16(sp)
 cba:	e456                	sd	s5,8(sp)
 cbc:	e05a                	sd	s6,0(sp)
 cbe:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cc0:	02051493          	sll	s1,a0,0x20
 cc4:	9081                	srl	s1,s1,0x20
 cc6:	04bd                	add	s1,s1,15
 cc8:	8091                	srl	s1,s1,0x4
 cca:	0014899b          	addw	s3,s1,1
 cce:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 cd0:	00000517          	auipc	a0,0x0
 cd4:	34053503          	ld	a0,832(a0) # 1010 <freep>
 cd8:	c515                	beqz	a0,d04 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cda:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cdc:	4798                	lw	a4,8(a5)
 cde:	02977f63          	bgeu	a4,s1,d1c <malloc+0x70>
  if(nu < 4096)
 ce2:	8a4e                	mv	s4,s3
 ce4:	0009871b          	sext.w	a4,s3
 ce8:	6685                	lui	a3,0x1
 cea:	00d77363          	bgeu	a4,a3,cf0 <malloc+0x44>
 cee:	6a05                	lui	s4,0x1
 cf0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 cf4:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 cf8:	00000917          	auipc	s2,0x0
 cfc:	31890913          	add	s2,s2,792 # 1010 <freep>
  if(p == (char*)-1)
 d00:	5afd                	li	s5,-1
 d02:	a885                	j	d72 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 d04:	00000797          	auipc	a5,0x0
 d08:	31c78793          	add	a5,a5,796 # 1020 <base>
 d0c:	00000717          	auipc	a4,0x0
 d10:	30f73223          	sd	a5,772(a4) # 1010 <freep>
 d14:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 d16:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 d1a:	b7e1                	j	ce2 <malloc+0x36>
      if(p->s.size == nunits)
 d1c:	02e48c63          	beq	s1,a4,d54 <malloc+0xa8>
        p->s.size -= nunits;
 d20:	4137073b          	subw	a4,a4,s3
 d24:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d26:	02071693          	sll	a3,a4,0x20
 d2a:	01c6d713          	srl	a4,a3,0x1c
 d2e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d30:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d34:	00000717          	auipc	a4,0x0
 d38:	2ca73e23          	sd	a0,732(a4) # 1010 <freep>
      return (void*)(p + 1);
 d3c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 d40:	70e2                	ld	ra,56(sp)
 d42:	7442                	ld	s0,48(sp)
 d44:	74a2                	ld	s1,40(sp)
 d46:	7902                	ld	s2,32(sp)
 d48:	69e2                	ld	s3,24(sp)
 d4a:	6a42                	ld	s4,16(sp)
 d4c:	6aa2                	ld	s5,8(sp)
 d4e:	6b02                	ld	s6,0(sp)
 d50:	6121                	add	sp,sp,64
 d52:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 d54:	6398                	ld	a4,0(a5)
 d56:	e118                	sd	a4,0(a0)
 d58:	bff1                	j	d34 <malloc+0x88>
  hp->s.size = nu;
 d5a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d5e:	0541                	add	a0,a0,16
 d60:	ecbff0ef          	jal	c2a <free>
  return freep;
 d64:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d68:	dd61                	beqz	a0,d40 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d6a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d6c:	4798                	lw	a4,8(a5)
 d6e:	fa9777e3          	bgeu	a4,s1,d1c <malloc+0x70>
    if(p == freep)
 d72:	00093703          	ld	a4,0(s2)
 d76:	853e                	mv	a0,a5
 d78:	fef719e3          	bne	a4,a5,d6a <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 d7c:	8552                	mv	a0,s4
 d7e:	ab1ff0ef          	jal	82e <sbrk>
  if(p == (char*)-1)
 d82:	fd551ce3          	bne	a0,s5,d5a <malloc+0xae>
        return 0;
 d86:	4501                	li	a0,0
 d88:	bf65                	j	d40 <malloc+0x94>
