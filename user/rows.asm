
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
  74:	b8010113          	add	sp,sp,-1152
  78:	46113c23          	sd	ra,1144(sp)
  7c:	46813823          	sd	s0,1136(sp)
  80:	46913423          	sd	s1,1128(sp)
  84:	47213023          	sd	s2,1120(sp)
  88:	45313c23          	sd	s3,1112(sp)
  8c:	45413823          	sd	s4,1104(sp)
  90:	45513423          	sd	s5,1096(sp)
  94:	45613023          	sd	s6,1088(sp)
  98:	43713c23          	sd	s7,1080(sp)
  9c:	43813823          	sd	s8,1072(sp)
  a0:	43913423          	sd	s9,1064(sp)
  a4:	43a13023          	sd	s10,1056(sp)
  a8:	48010413          	add	s0,sp,1152
    int t0, t1;
    int total_eficiencia = 0, total_overhead = 0;


    int index = 0;
    index += (argv[1][0] - '0') * 10;
  ac:	6598                	ld	a4,8(a1)
  ae:	00074783          	lbu	a5,0(a4) # ffffffff80000000 <base+0xffffffff7fffefe0>
  b2:	fd07879b          	addw	a5,a5,-48
  b6:	00279c9b          	sllw	s9,a5,0x2
  ba:	00fc8cbb          	addw	s9,s9,a5
  be:	001c9c9b          	sllw	s9,s9,0x1
    index += (argv[1][1] - '0');
  c2:	00174783          	lbu	a5,1(a4)
  c6:	fd07879b          	addw	a5,a5,-48
  ca:	00fc8cbb          	addw	s9,s9,a5

    int fd;
    char filename[20] = "iobound";
  ce:	00001797          	auipc	a5,0x1
  d2:	d6a7b783          	ld	a5,-662(a5) # e38 <malloc+0x206>
  d6:	f8f43423          	sd	a5,-120(s0)
  da:	f8043823          	sd	zero,-112(s0)
  de:	f8042c23          	sw	zero,-104(s0)
    char pid_str[10];
    char *suffix = ".txt";

    int pid = getpid();
  e2:	6ca000ef          	jal	7ac <getpid>

    pid += 1000; //valores baixos dão problema
  e6:	3e85071b          	addw	a4,a0,1000

    int i = 0;
  ea:	f7840693          	add	a3,s0,-136
    pid += 1000; //valores baixos dão problema
  ee:	8636                	mv	a2,a3
    int i = 0;
  f0:	4781                	li	a5,0
    do {
        pid_str[i++] = pid % 10 + '0';   // próximo digito
  f2:	4829                	li	a6,10
    } while ((pid /= 10) > 0);
  f4:	48a5                	li	a7,9
        pid_str[i++] = pid % 10 + '0';   // próximo digito
  f6:	85be                	mv	a1,a5
  f8:	2785                	addw	a5,a5,1
  fa:	0307653b          	remw	a0,a4,a6
  fe:	0305051b          	addw	a0,a0,48
 102:	00a60023          	sb	a0,0(a2)
    } while ((pid /= 10) > 0);
 106:	853a                	mv	a0,a4
 108:	0307473b          	divw	a4,a4,a6
 10c:	0605                	add	a2,a2,1
 10e:	fea8c4e3          	blt	a7,a0,f6 <main+0x82>
    pid_str[i] = '\0';
 112:	fa078793          	add	a5,a5,-96
 116:	97a2                	add	a5,a5,s0
 118:	fc078c23          	sb	zero,-40(a5)

    int j;
    char temp;
    for (j = 0, i--; j < i; j++, i--) {
 11c:	16b05d63          	blez	a1,296 <main+0x222>
 120:	f7840793          	add	a5,s0,-136
 124:	97ae                	add	a5,a5,a1
 126:	4701                	li	a4,0
        temp = pid_str[j];
 128:	0006c603          	lbu	a2,0(a3)
        pid_str[j] = pid_str[i];
 12c:	0007c503          	lbu	a0,0(a5)
 130:	00a68023          	sb	a0,0(a3)
        pid_str[i] = temp;
 134:	00c78023          	sb	a2,0(a5)
    for (j = 0, i--; j < i; j++, i--) {
 138:	0017061b          	addw	a2,a4,1
 13c:	0006071b          	sext.w	a4,a2
 140:	0685                	add	a3,a3,1
 142:	17fd                	add	a5,a5,-1
 144:	40c5863b          	subw	a2,a1,a2
 148:	fec740e3          	blt	a4,a2,128 <main+0xb4>
    }

    i = 7;
    while (pid_str[j] != '\0') {
 14c:	fa070793          	add	a5,a4,-96
 150:	97a2                	add	a5,a5,s0
 152:	fd87c603          	lbu	a2,-40(a5)
 156:	14060263          	beqz	a2,29a <main+0x226>
 15a:	46a1                	li	a3,8
        filename[i++] = pid_str[j++];
 15c:	f8840793          	add	a5,s0,-120
 160:	97b6                	add	a5,a5,a3
 162:	fec78fa3          	sb	a2,-1(a5)
    while (pid_str[j] != '\0') {
 166:	87b6                	mv	a5,a3
 168:	0685                	add	a3,a3,1
 16a:	00d70633          	add	a2,a4,a3
 16e:	f7840593          	add	a1,s0,-136
 172:	962e                	add	a2,a2,a1
 174:	ff864603          	lbu	a2,-8(a2)
 178:	f275                	bnez	a2,15c <main+0xe8>
        filename[i++] = pid_str[j++];
 17a:	2781                	sext.w	a5,a5
    }
    j = 0;
    while (suffix[j] != '\0') {
 17c:	2785                	addw	a5,a5,1
 17e:	00001617          	auipc	a2,0x1
 182:	b9360613          	add	a2,a2,-1133 # d11 <malloc+0xdf>
 186:	02e00693          	li	a3,46
        filename[i++] = suffix[j++];
 18a:	f8840713          	add	a4,s0,-120
 18e:	973e                	add	a4,a4,a5
 190:	fed70fa3          	sb	a3,-1(a4)
    while (suffix[j] != '\0') {
 194:	00064683          	lbu	a3,0(a2)
 198:	873e                	mv	a4,a5
 19a:	0785                	add	a5,a5,1
 19c:	0605                	add	a2,a2,1
 19e:	f6f5                	bnez	a3,18a <main+0x116>
    }
    filename[i] = '\0';
 1a0:	0007079b          	sext.w	a5,a4
 1a4:	fa078793          	add	a5,a5,-96
 1a8:	97a2                	add	a5,a5,s0
 1aa:	fe078423          	sb	zero,-24(a5)

    t0 = uptime();
 1ae:	616000ef          	jal	7c4 <uptime>
 1b2:	8baa                	mv	s7,a0
    fd = open(filename, O_CREATE | O_RDWR);
 1b4:	20200593          	li	a1,514
 1b8:	f8840513          	add	a0,s0,-120
 1bc:	5b0000ef          	jal	76c <open>
 1c0:	8c2a                	mv	s8,a0
    t1 = uptime();
 1c2:	602000ef          	jal	7c4 <uptime>
    total_overhead += t1 - t0;
 1c6:	41750bbb          	subw	s7,a0,s7

    if (fd < 0){
 1ca:	0c0c4a63          	bltz	s8,29e <main+0x22a>
    }

    char *caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$&*()";

    char linha[101];
    linha[100] = '\n';
 1ce:	47a9                	li	a5,10
 1d0:	f6f40a23          	sb	a5,-140(s0)
 1d4:	06400b13          	li	s6,100
    int total_eficiencia = 0, total_overhead = 0;
 1d8:	4a81                	li	s5,0
 1da:	f7440a13          	add	s4,s0,-140
    int size = 101;
    for(i=0;i<100;i++){ //lines
        for(int j=0;j<100;j++){ //characters
            int c = rand() % 70;
 1de:	04600993          	li	s3,70
            linha[j] = caracteres[c];
 1e2:	00001917          	auipc	s2,0x1
 1e6:	b5690913          	add	s2,s2,-1194 # d38 <malloc+0x106>
        for(int j=0;j<100;j++){ //characters
 1ea:	f1040493          	add	s1,s0,-240
            int c = rand() % 70;
 1ee:	e6bff0ef          	jal	58 <rand>
            linha[j] = caracteres[c];
 1f2:	0335653b          	remw	a0,a0,s3
 1f6:	954a                	add	a0,a0,s2
 1f8:	00054783          	lbu	a5,0(a0)
 1fc:	00f48023          	sb	a5,0(s1)
        for(int j=0;j<100;j++){ //characters
 200:	0485                	add	s1,s1,1
 202:	fe9a16e3          	bne	s4,s1,1ee <main+0x17a>
        }
        t0 = uptime();
 206:	5be000ef          	jal	7c4 <uptime>
 20a:	84aa                	mv	s1,a0
        if(write(fd, linha, size) != size){
 20c:	06500613          	li	a2,101
 210:	f1040593          	add	a1,s0,-240
 214:	8562                	mv	a0,s8
 216:	536000ef          	jal	74c <write>
 21a:	06500793          	li	a5,101
 21e:	08f51963          	bne	a0,a5,2b0 <main+0x23c>
            printf("error, write failed\n");
            exit(1);
        } else {  //wrote succesfully
            t1 = uptime();
 222:	5a2000ef          	jal	7c4 <uptime>
            total_eficiencia += t1 - t0;
 226:	9d05                	subw	a0,a0,s1
 228:	01550abb          	addw	s5,a0,s5
    for(i=0;i<100;i++){ //lines
 22c:	3b7d                	addw	s6,s6,-1
 22e:	fa0b1ee3          	bnez	s6,1ea <main+0x176>
        }
    }
    close(fd);
 232:	8562                	mv	a0,s8
 234:	520000ef          	jal	754 <close>



    char *linhas[100];
    for (int j = 0; j < 100; j++) {
 238:	bf040993          	add	s3,s0,-1040
 23c:	f1040a13          	add	s4,s0,-240
    close(fd);
 240:	894e                	mv	s2,s3
        t0 = uptime();
 242:	582000ef          	jal	7c4 <uptime>
 246:	84aa                	mv	s1,a0
        linhas[j] = malloc(102 * sizeof(char)); // allocate memory for each string
 248:	06600513          	li	a0,102
 24c:	1e7000ef          	jal	c32 <malloc>
 250:	00a93023          	sd	a0,0(s2)
        t1 = uptime();
 254:	570000ef          	jal	7c4 <uptime>
        total_overhead += t1 - t0;
 258:	409504bb          	subw	s1,a0,s1
 25c:	017484bb          	addw	s1,s1,s7
 260:	00048b9b          	sext.w	s7,s1
    for (int j = 0; j < 100; j++) {
 264:	0921                	add	s2,s2,8
 266:	fd2a1ee3          	bne	s4,s2,242 <main+0x1ce>
    }

    t0 = uptime();
 26a:	55a000ef          	jal	7c4 <uptime>
 26e:	892a                	mv	s2,a0
    fd = open(filename, O_RDONLY);
 270:	4581                	li	a1,0
 272:	f8840513          	add	a0,s0,-120
 276:	4f6000ef          	jal	76c <open>
 27a:	8b2a                	mv	s6,a0
    t1 = uptime();
 27c:	548000ef          	jal	7c4 <uptime>
    total_overhead += t1 - t0;
 280:	4125093b          	subw	s2,a0,s2
 284:	0099093b          	addw	s2,s2,s1
    if (fd < 0) {
 288:	020b4d63          	bltz	s6,2c2 <main+0x24e>
    }

    char buf[101];
    int n;
    i = 0;
    t0 = uptime();
 28c:	538000ef          	jal	7c4 <uptime>
 290:	84aa                	mv	s1,a0
    while((n = read(fd, buf, sizeof(buf))) > 0) {
 292:	8bce                	mv	s7,s3
 294:	a095                	j	2f8 <main+0x284>
    for (j = 0, i--; j < i; j++, i--) {
 296:	4701                	li	a4,0
 298:	bd55                	j	14c <main+0xd8>
    i = 7;
 29a:	479d                	li	a5,7
 29c:	b5c5                	j	17c <main+0x108>
        printf("erro ao criar o arquivo %s\n", filename);
 29e:	f8840593          	add	a1,s0,-120
 2a2:	00001517          	auipc	a0,0x1
 2a6:	a7650513          	add	a0,a0,-1418 # d18 <malloc+0xe6>
 2aa:	0d5000ef          	jal	b7e <printf>
 2ae:	b705                	j	1ce <main+0x15a>
            printf("error, write failed\n");
 2b0:	00001517          	auipc	a0,0x1
 2b4:	ad050513          	add	a0,a0,-1328 # d80 <malloc+0x14e>
 2b8:	0c7000ef          	jal	b7e <printf>
            exit(1);
 2bc:	4505                	li	a0,1
 2be:	46e000ef          	jal	72c <exit>
        printf("Erro ao abrir o arquivo %s\n", filename);
 2c2:	f8840593          	add	a1,s0,-120
 2c6:	00001517          	auipc	a0,0x1
 2ca:	ad250513          	add	a0,a0,-1326 # d98 <malloc+0x166>
 2ce:	0b1000ef          	jal	b7e <printf>
        exit(1);
 2d2:	4505                	li	a0,1
 2d4:	458000ef          	jal	72c <exit>
        t1 = uptime();
 2d8:	4ec000ef          	jal	7c4 <uptime>
        total_eficiencia += t1 - t0;
 2dc:	409507bb          	subw	a5,a0,s1
 2e0:	01578abb          	addw	s5,a5,s5
        strcpy(linhas[i], buf);
 2e4:	b8840593          	add	a1,s0,-1144
 2e8:	000bb503          	ld	a0,0(s7)
 2ec:	1e8000ef          	jal	4d4 <strcpy>
        i++;
        t0 = uptime();
 2f0:	4d4000ef          	jal	7c4 <uptime>
 2f4:	84aa                	mv	s1,a0
 2f6:	0ba1                	add	s7,s7,8
    while((n = read(fd, buf, sizeof(buf))) > 0) {
 2f8:	06500613          	li	a2,101
 2fc:	b8840593          	add	a1,s0,-1144
 300:	855a                	mv	a0,s6
 302:	442000ef          	jal	744 <read>
 306:	fca049e3          	bgtz	a0,2d8 <main+0x264>
    }

    close(fd);
 30a:	855a                	mv	a0,s6
 30c:	448000ef          	jal	754 <close>


    char *tmp;
    t0 = uptime();
 310:	4b4000ef          	jal	7c4 <uptime>
 314:	8d2a                	mv	s10,a0
    tmp = malloc(102*sizeof(char));
 316:	06600513          	li	a0,102
 31a:	119000ef          	jal	c32 <malloc>
 31e:	8baa                	mv	s7,a0
    t1 = uptime();
 320:	4a4000ef          	jal	7c4 <uptime>
    total_overhead += t1 - t0;
 324:	41a50d3b          	subw	s10,a0,s10
 328:	012d0d3b          	addw	s10,s10,s2
 32c:	03200b13          	li	s6,50

    for (i = 0; i < 50; i++){
        //getting random rows
        int row1 = rand() % 100;
 330:	06400c13          	li	s8,100
 334:	d25ff0ef          	jal	58 <rand>
 338:	892a                	mv	s2,a0
        int row2 = rand() % 100;
 33a:	d1fff0ef          	jal	58 <rand>
 33e:	84aa                	mv	s1,a0

        //swapping them
        strcpy(tmp, linhas[row1]);
 340:	038967bb          	remw	a5,s2,s8
 344:	078e                	sll	a5,a5,0x3
 346:	fa078793          	add	a5,a5,-96
 34a:	97a2                	add	a5,a5,s0
 34c:	c507b903          	ld	s2,-944(a5)
 350:	85ca                	mv	a1,s2
 352:	855e                	mv	a0,s7
 354:	180000ef          	jal	4d4 <strcpy>
        strcpy(linhas[row1], linhas[row2]);
 358:	0384e7bb          	remw	a5,s1,s8
 35c:	078e                	sll	a5,a5,0x3
 35e:	fa078793          	add	a5,a5,-96
 362:	97a2                	add	a5,a5,s0
 364:	c507b483          	ld	s1,-944(a5)
 368:	85a6                	mv	a1,s1
 36a:	854a                	mv	a0,s2
 36c:	168000ef          	jal	4d4 <strcpy>
        strcpy(linhas[row2], tmp);
 370:	85de                	mv	a1,s7
 372:	8526                	mv	a0,s1
 374:	160000ef          	jal	4d4 <strcpy>
    for (i = 0; i < 50; i++){
 378:	3b7d                	addw	s6,s6,-1
 37a:	fa0b1de3          	bnez	s6,334 <main+0x2c0>
    }
    t0 = uptime();
 37e:	446000ef          	jal	7c4 <uptime>
 382:	84aa                	mv	s1,a0
    free(tmp);
 384:	855e                	mv	a0,s7
 386:	02b000ef          	jal	bb0 <free>
    t1 = uptime();
 38a:	43a000ef          	jal	7c4 <uptime>
    total_overhead += t1 - t0;
 38e:	409504bb          	subw	s1,a0,s1
 392:	01a484bb          	addw	s1,s1,s10

    //rewriting file after permutations
    t0 = uptime();
 396:	42e000ef          	jal	7c4 <uptime>
 39a:	892a                	mv	s2,a0
    fd = open(filename, O_RDWR);
 39c:	4589                	li	a1,2
 39e:	f8840513          	add	a0,s0,-120
 3a2:	3ca000ef          	jal	76c <open>
 3a6:	8baa                	mv	s7,a0
    t1 = uptime();
 3a8:	41c000ef          	jal	7c4 <uptime>
    total_overhead += t1 - t0;
 3ac:	4125093b          	subw	s2,a0,s2
 3b0:	0099093b          	addw	s2,s2,s1
    if (fd < 0) {
 3b4:	8b4e                	mv	s6,s3
 3b6:	0c0bc963          	bltz	s7,488 <main+0x414>
        exit(1);
    }

    size = 101;
    for (int i = 0; i < 100; i++){
        t0 = uptime();
 3ba:	40a000ef          	jal	7c4 <uptime>
 3be:	84aa                	mv	s1,a0
        if(write(fd, linhas[i], size) != size){
 3c0:	06500613          	li	a2,101
 3c4:	000b3583          	ld	a1,0(s6)
 3c8:	855e                	mv	a0,s7
 3ca:	382000ef          	jal	74c <write>
 3ce:	06500793          	li	a5,101
 3d2:	0cf51663          	bne	a0,a5,49e <main+0x42a>
            printf("error, write permut failed\n");
            exit(1);
        } else {
            t1 = uptime();
 3d6:	3ee000ef          	jal	7c4 <uptime>
            total_eficiencia += t1 - t0;
 3da:	409504bb          	subw	s1,a0,s1
 3de:	015484bb          	addw	s1,s1,s5
 3e2:	00048a9b          	sext.w	s5,s1
    for (int i = 0; i < 100; i++){
 3e6:	0b21                	add	s6,s6,8
 3e8:	fd6a19e3          	bne	s4,s6,3ba <main+0x346>
        }
    }

    close(fd);
 3ec:	855e                	mv	a0,s7
 3ee:	366000ef          	jal	754 <close>

    //removing file
    t0 = uptime();
 3f2:	3d2000ef          	jal	7c4 <uptime>
 3f6:	8aaa                	mv	s5,a0
    if (unlink(filename) < 0){
 3f8:	f8840513          	add	a0,s0,-120
 3fc:	380000ef          	jal	77c <unlink>
 400:	0a054863          	bltz	a0,4b0 <main+0x43c>
        printf("Erro ao remover o arquivo\n");
        exit(1);
    } else {
        t1 = uptime();
 404:	3c0000ef          	jal	7c4 <uptime>
        total_eficiencia += t1 - t0;
 408:	41550abb          	subw	s5,a0,s5
 40c:	009a8abb          	addw	s5,s5,s1
    }


    //free malloc for linhas
    for (int j = 0; j < 100; j++) {
        t0 = uptime();
 410:	3b4000ef          	jal	7c4 <uptime>
 414:	84aa                	mv	s1,a0
        free(linhas[j]);
 416:	0009b503          	ld	a0,0(s3)
 41a:	796000ef          	jal	bb0 <free>
        t1 = uptime();
 41e:	3a6000ef          	jal	7c4 <uptime>
        total_overhead += t1 - t0;
 422:	409507bb          	subw	a5,a0,s1
 426:	0127893b          	addw	s2,a5,s2
    for (int j = 0; j < 100; j++) {
 42a:	09a1                	add	s3,s3,8
 42c:	ff3a12e3          	bne	s4,s3,410 <main+0x39c>
    }


    increment_metric(index, total_eficiencia, MODE_EFICIENCIA);
 430:	4629                	li	a2,10
 432:	85d6                	mv	a1,s5
 434:	8566                	mv	a0,s9
 436:	3ae000ef          	jal	7e4 <increment_metric>
    increment_metric(index, total_overhead, MODE_OVERHEAD);
 43a:	4621                	li	a2,8
 43c:	85ca                	mv	a1,s2
 43e:	8566                	mv	a0,s9
 440:	3a4000ef          	jal	7e4 <increment_metric>

    pid = getpid();
 444:	368000ef          	jal	7ac <getpid>
 448:	85aa                	mv	a1,a0
    set_justica(index, pid);
 44a:	8566                	mv	a0,s9
 44c:	3b0000ef          	jal	7fc <set_justica>

    return 0;
 450:	4501                	li	a0,0
 452:	47813083          	ld	ra,1144(sp)
 456:	47013403          	ld	s0,1136(sp)
 45a:	46813483          	ld	s1,1128(sp)
 45e:	46013903          	ld	s2,1120(sp)
 462:	45813983          	ld	s3,1112(sp)
 466:	45013a03          	ld	s4,1104(sp)
 46a:	44813a83          	ld	s5,1096(sp)
 46e:	44013b03          	ld	s6,1088(sp)
 472:	43813b83          	ld	s7,1080(sp)
 476:	43013c03          	ld	s8,1072(sp)
 47a:	42813c83          	ld	s9,1064(sp)
 47e:	42013d03          	ld	s10,1056(sp)
 482:	48010113          	add	sp,sp,1152
 486:	8082                	ret
        printf("Erro ao reabrir o arquivo %s para escrever as permutações\n", filename);
 488:	f8840593          	add	a1,s0,-120
 48c:	00001517          	auipc	a0,0x1
 490:	92c50513          	add	a0,a0,-1748 # db8 <malloc+0x186>
 494:	6ea000ef          	jal	b7e <printf>
        exit(1);
 498:	4505                	li	a0,1
 49a:	292000ef          	jal	72c <exit>
            printf("error, write permut failed\n");
 49e:	00001517          	auipc	a0,0x1
 4a2:	95a50513          	add	a0,a0,-1702 # df8 <malloc+0x1c6>
 4a6:	6d8000ef          	jal	b7e <printf>
            exit(1);
 4aa:	4505                	li	a0,1
 4ac:	280000ef          	jal	72c <exit>
        printf("Erro ao remover o arquivo\n");
 4b0:	00001517          	auipc	a0,0x1
 4b4:	96850513          	add	a0,a0,-1688 # e18 <malloc+0x1e6>
 4b8:	6c6000ef          	jal	b7e <printf>
        exit(1);
 4bc:	4505                	li	a0,1
 4be:	26e000ef          	jal	72c <exit>

00000000000004c2 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 4c2:	1141                	add	sp,sp,-16
 4c4:	e406                	sd	ra,8(sp)
 4c6:	e022                	sd	s0,0(sp)
 4c8:	0800                	add	s0,sp,16
  extern int main();
  main();
 4ca:	babff0ef          	jal	74 <main>
  exit(0);
 4ce:	4501                	li	a0,0
 4d0:	25c000ef          	jal	72c <exit>

00000000000004d4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 4d4:	1141                	add	sp,sp,-16
 4d6:	e422                	sd	s0,8(sp)
 4d8:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4da:	87aa                	mv	a5,a0
 4dc:	0585                	add	a1,a1,1
 4de:	0785                	add	a5,a5,1
 4e0:	fff5c703          	lbu	a4,-1(a1)
 4e4:	fee78fa3          	sb	a4,-1(a5)
 4e8:	fb75                	bnez	a4,4dc <strcpy+0x8>
    ;
  return os;
}
 4ea:	6422                	ld	s0,8(sp)
 4ec:	0141                	add	sp,sp,16
 4ee:	8082                	ret

00000000000004f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4f0:	1141                	add	sp,sp,-16
 4f2:	e422                	sd	s0,8(sp)
 4f4:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 4f6:	00054783          	lbu	a5,0(a0)
 4fa:	cb91                	beqz	a5,50e <strcmp+0x1e>
 4fc:	0005c703          	lbu	a4,0(a1)
 500:	00f71763          	bne	a4,a5,50e <strcmp+0x1e>
    p++, q++;
 504:	0505                	add	a0,a0,1
 506:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 508:	00054783          	lbu	a5,0(a0)
 50c:	fbe5                	bnez	a5,4fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 50e:	0005c503          	lbu	a0,0(a1)
}
 512:	40a7853b          	subw	a0,a5,a0
 516:	6422                	ld	s0,8(sp)
 518:	0141                	add	sp,sp,16
 51a:	8082                	ret

000000000000051c <strlen>:

uint
strlen(const char *s)
{
 51c:	1141                	add	sp,sp,-16
 51e:	e422                	sd	s0,8(sp)
 520:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 522:	00054783          	lbu	a5,0(a0)
 526:	cf91                	beqz	a5,542 <strlen+0x26>
 528:	0505                	add	a0,a0,1
 52a:	87aa                	mv	a5,a0
 52c:	86be                	mv	a3,a5
 52e:	0785                	add	a5,a5,1
 530:	fff7c703          	lbu	a4,-1(a5)
 534:	ff65                	bnez	a4,52c <strlen+0x10>
 536:	40a6853b          	subw	a0,a3,a0
 53a:	2505                	addw	a0,a0,1
    ;
  return n;
}
 53c:	6422                	ld	s0,8(sp)
 53e:	0141                	add	sp,sp,16
 540:	8082                	ret
  for(n = 0; s[n]; n++)
 542:	4501                	li	a0,0
 544:	bfe5                	j	53c <strlen+0x20>

0000000000000546 <memset>:

void*
memset(void *dst, int c, uint n)
{
 546:	1141                	add	sp,sp,-16
 548:	e422                	sd	s0,8(sp)
 54a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 54c:	ca19                	beqz	a2,562 <memset+0x1c>
 54e:	87aa                	mv	a5,a0
 550:	1602                	sll	a2,a2,0x20
 552:	9201                	srl	a2,a2,0x20
 554:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 558:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 55c:	0785                	add	a5,a5,1
 55e:	fee79de3          	bne	a5,a4,558 <memset+0x12>
  }
  return dst;
}
 562:	6422                	ld	s0,8(sp)
 564:	0141                	add	sp,sp,16
 566:	8082                	ret

0000000000000568 <strchr>:

char*
strchr(const char *s, char c)
{
 568:	1141                	add	sp,sp,-16
 56a:	e422                	sd	s0,8(sp)
 56c:	0800                	add	s0,sp,16
  for(; *s; s++)
 56e:	00054783          	lbu	a5,0(a0)
 572:	cb99                	beqz	a5,588 <strchr+0x20>
    if(*s == c)
 574:	00f58763          	beq	a1,a5,582 <strchr+0x1a>
  for(; *s; s++)
 578:	0505                	add	a0,a0,1
 57a:	00054783          	lbu	a5,0(a0)
 57e:	fbfd                	bnez	a5,574 <strchr+0xc>
      return (char*)s;
  return 0;
 580:	4501                	li	a0,0
}
 582:	6422                	ld	s0,8(sp)
 584:	0141                	add	sp,sp,16
 586:	8082                	ret
  return 0;
 588:	4501                	li	a0,0
 58a:	bfe5                	j	582 <strchr+0x1a>

000000000000058c <gets>:

char*
gets(char *buf, int max)
{
 58c:	711d                	add	sp,sp,-96
 58e:	ec86                	sd	ra,88(sp)
 590:	e8a2                	sd	s0,80(sp)
 592:	e4a6                	sd	s1,72(sp)
 594:	e0ca                	sd	s2,64(sp)
 596:	fc4e                	sd	s3,56(sp)
 598:	f852                	sd	s4,48(sp)
 59a:	f456                	sd	s5,40(sp)
 59c:	f05a                	sd	s6,32(sp)
 59e:	ec5e                	sd	s7,24(sp)
 5a0:	1080                	add	s0,sp,96
 5a2:	8baa                	mv	s7,a0
 5a4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5a6:	892a                	mv	s2,a0
 5a8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5aa:	4aa9                	li	s5,10
 5ac:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5ae:	89a6                	mv	s3,s1
 5b0:	2485                	addw	s1,s1,1
 5b2:	0344d663          	bge	s1,s4,5de <gets+0x52>
    cc = read(0, &c, 1);
 5b6:	4605                	li	a2,1
 5b8:	faf40593          	add	a1,s0,-81
 5bc:	4501                	li	a0,0
 5be:	186000ef          	jal	744 <read>
    if(cc < 1)
 5c2:	00a05e63          	blez	a0,5de <gets+0x52>
    buf[i++] = c;
 5c6:	faf44783          	lbu	a5,-81(s0)
 5ca:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5ce:	01578763          	beq	a5,s5,5dc <gets+0x50>
 5d2:	0905                	add	s2,s2,1
 5d4:	fd679de3          	bne	a5,s6,5ae <gets+0x22>
  for(i=0; i+1 < max; ){
 5d8:	89a6                	mv	s3,s1
 5da:	a011                	j	5de <gets+0x52>
 5dc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5de:	99de                	add	s3,s3,s7
 5e0:	00098023          	sb	zero,0(s3)
  return buf;
}
 5e4:	855e                	mv	a0,s7
 5e6:	60e6                	ld	ra,88(sp)
 5e8:	6446                	ld	s0,80(sp)
 5ea:	64a6                	ld	s1,72(sp)
 5ec:	6906                	ld	s2,64(sp)
 5ee:	79e2                	ld	s3,56(sp)
 5f0:	7a42                	ld	s4,48(sp)
 5f2:	7aa2                	ld	s5,40(sp)
 5f4:	7b02                	ld	s6,32(sp)
 5f6:	6be2                	ld	s7,24(sp)
 5f8:	6125                	add	sp,sp,96
 5fa:	8082                	ret

00000000000005fc <stat>:

int
stat(const char *n, struct stat *st)
{
 5fc:	1101                	add	sp,sp,-32
 5fe:	ec06                	sd	ra,24(sp)
 600:	e822                	sd	s0,16(sp)
 602:	e426                	sd	s1,8(sp)
 604:	e04a                	sd	s2,0(sp)
 606:	1000                	add	s0,sp,32
 608:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 60a:	4581                	li	a1,0
 60c:	160000ef          	jal	76c <open>
  if(fd < 0)
 610:	02054163          	bltz	a0,632 <stat+0x36>
 614:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 616:	85ca                	mv	a1,s2
 618:	16c000ef          	jal	784 <fstat>
 61c:	892a                	mv	s2,a0
  close(fd);
 61e:	8526                	mv	a0,s1
 620:	134000ef          	jal	754 <close>
  return r;
}
 624:	854a                	mv	a0,s2
 626:	60e2                	ld	ra,24(sp)
 628:	6442                	ld	s0,16(sp)
 62a:	64a2                	ld	s1,8(sp)
 62c:	6902                	ld	s2,0(sp)
 62e:	6105                	add	sp,sp,32
 630:	8082                	ret
    return -1;
 632:	597d                	li	s2,-1
 634:	bfc5                	j	624 <stat+0x28>

0000000000000636 <atoi>:

int
atoi(const char *s)
{
 636:	1141                	add	sp,sp,-16
 638:	e422                	sd	s0,8(sp)
 63a:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 63c:	00054683          	lbu	a3,0(a0)
 640:	fd06879b          	addw	a5,a3,-48
 644:	0ff7f793          	zext.b	a5,a5
 648:	4625                	li	a2,9
 64a:	02f66863          	bltu	a2,a5,67a <atoi+0x44>
 64e:	872a                	mv	a4,a0
  n = 0;
 650:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 652:	0705                	add	a4,a4,1
 654:	0025179b          	sllw	a5,a0,0x2
 658:	9fa9                	addw	a5,a5,a0
 65a:	0017979b          	sllw	a5,a5,0x1
 65e:	9fb5                	addw	a5,a5,a3
 660:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 664:	00074683          	lbu	a3,0(a4)
 668:	fd06879b          	addw	a5,a3,-48
 66c:	0ff7f793          	zext.b	a5,a5
 670:	fef671e3          	bgeu	a2,a5,652 <atoi+0x1c>
  return n;
}
 674:	6422                	ld	s0,8(sp)
 676:	0141                	add	sp,sp,16
 678:	8082                	ret
  n = 0;
 67a:	4501                	li	a0,0
 67c:	bfe5                	j	674 <atoi+0x3e>

000000000000067e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 67e:	1141                	add	sp,sp,-16
 680:	e422                	sd	s0,8(sp)
 682:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 684:	02b57463          	bgeu	a0,a1,6ac <memmove+0x2e>
    while(n-- > 0)
 688:	00c05f63          	blez	a2,6a6 <memmove+0x28>
 68c:	1602                	sll	a2,a2,0x20
 68e:	9201                	srl	a2,a2,0x20
 690:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 694:	872a                	mv	a4,a0
      *dst++ = *src++;
 696:	0585                	add	a1,a1,1
 698:	0705                	add	a4,a4,1
 69a:	fff5c683          	lbu	a3,-1(a1)
 69e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6a2:	fee79ae3          	bne	a5,a4,696 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6a6:	6422                	ld	s0,8(sp)
 6a8:	0141                	add	sp,sp,16
 6aa:	8082                	ret
    dst += n;
 6ac:	00c50733          	add	a4,a0,a2
    src += n;
 6b0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6b2:	fec05ae3          	blez	a2,6a6 <memmove+0x28>
 6b6:	fff6079b          	addw	a5,a2,-1
 6ba:	1782                	sll	a5,a5,0x20
 6bc:	9381                	srl	a5,a5,0x20
 6be:	fff7c793          	not	a5,a5
 6c2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6c4:	15fd                	add	a1,a1,-1
 6c6:	177d                	add	a4,a4,-1
 6c8:	0005c683          	lbu	a3,0(a1)
 6cc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6d0:	fee79ae3          	bne	a5,a4,6c4 <memmove+0x46>
 6d4:	bfc9                	j	6a6 <memmove+0x28>

00000000000006d6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6d6:	1141                	add	sp,sp,-16
 6d8:	e422                	sd	s0,8(sp)
 6da:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6dc:	ca05                	beqz	a2,70c <memcmp+0x36>
 6de:	fff6069b          	addw	a3,a2,-1
 6e2:	1682                	sll	a3,a3,0x20
 6e4:	9281                	srl	a3,a3,0x20
 6e6:	0685                	add	a3,a3,1
 6e8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6ea:	00054783          	lbu	a5,0(a0)
 6ee:	0005c703          	lbu	a4,0(a1)
 6f2:	00e79863          	bne	a5,a4,702 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6f6:	0505                	add	a0,a0,1
    p2++;
 6f8:	0585                	add	a1,a1,1
  while (n-- > 0) {
 6fa:	fed518e3          	bne	a0,a3,6ea <memcmp+0x14>
  }
  return 0;
 6fe:	4501                	li	a0,0
 700:	a019                	j	706 <memcmp+0x30>
      return *p1 - *p2;
 702:	40e7853b          	subw	a0,a5,a4
}
 706:	6422                	ld	s0,8(sp)
 708:	0141                	add	sp,sp,16
 70a:	8082                	ret
  return 0;
 70c:	4501                	li	a0,0
 70e:	bfe5                	j	706 <memcmp+0x30>

0000000000000710 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 710:	1141                	add	sp,sp,-16
 712:	e406                	sd	ra,8(sp)
 714:	e022                	sd	s0,0(sp)
 716:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 718:	f67ff0ef          	jal	67e <memmove>
}
 71c:	60a2                	ld	ra,8(sp)
 71e:	6402                	ld	s0,0(sp)
 720:	0141                	add	sp,sp,16
 722:	8082                	ret

0000000000000724 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 724:	4885                	li	a7,1
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <exit>:
.global exit
exit:
 li a7, SYS_exit
 72c:	4889                	li	a7,2
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <wait>:
.global wait
wait:
 li a7, SYS_wait
 734:	488d                	li	a7,3
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 73c:	4891                	li	a7,4
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <read>:
.global read
read:
 li a7, SYS_read
 744:	4895                	li	a7,5
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <write>:
.global write
write:
 li a7, SYS_write
 74c:	48c1                	li	a7,16
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <close>:
.global close
close:
 li a7, SYS_close
 754:	48d5                	li	a7,21
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <kill>:
.global kill
kill:
 li a7, SYS_kill
 75c:	4899                	li	a7,6
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <exec>:
.global exec
exec:
 li a7, SYS_exec
 764:	489d                	li	a7,7
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <open>:
.global open
open:
 li a7, SYS_open
 76c:	48bd                	li	a7,15
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 774:	48c5                	li	a7,17
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 77c:	48c9                	li	a7,18
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 784:	48a1                	li	a7,8
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <link>:
.global link
link:
 li a7, SYS_link
 78c:	48cd                	li	a7,19
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 794:	48d1                	li	a7,20
 ecall
 796:	00000073          	ecall
 ret
 79a:	8082                	ret

000000000000079c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 79c:	48a5                	li	a7,9
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7a4:	48a9                	li	a7,10
 ecall
 7a6:	00000073          	ecall
 ret
 7aa:	8082                	ret

00000000000007ac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7ac:	48ad                	li	a7,11
 ecall
 7ae:	00000073          	ecall
 ret
 7b2:	8082                	ret

00000000000007b4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7b4:	48b1                	li	a7,12
 ecall
 7b6:	00000073          	ecall
 ret
 7ba:	8082                	ret

00000000000007bc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7bc:	48b5                	li	a7,13
 ecall
 7be:	00000073          	ecall
 ret
 7c2:	8082                	ret

00000000000007c4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7c4:	48b9                	li	a7,14
 ecall
 7c6:	00000073          	ecall
 ret
 7ca:	8082                	ret

00000000000007cc <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 7cc:	48d9                	li	a7,22
 ecall
 7ce:	00000073          	ecall
 ret
 7d2:	8082                	ret

00000000000007d4 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 7d4:	48dd                	li	a7,23
 ecall
 7d6:	00000073          	ecall
 ret
 7da:	8082                	ret

00000000000007dc <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 7dc:	48e1                	li	a7,24
 ecall
 7de:	00000073          	ecall
 ret
 7e2:	8082                	ret

00000000000007e4 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 7e4:	48e5                	li	a7,25
 ecall
 7e6:	00000073          	ecall
 ret
 7ea:	8082                	ret

00000000000007ec <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 7ec:	48e9                	li	a7,26
 ecall
 7ee:	00000073          	ecall
 ret
 7f2:	8082                	ret

00000000000007f4 <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 7f4:	48ed                	li	a7,27
 ecall
 7f6:	00000073          	ecall
 ret
 7fa:	8082                	ret

00000000000007fc <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 7fc:	48f1                	li	a7,28
 ecall
 7fe:	00000073          	ecall
 ret
 802:	8082                	ret

0000000000000804 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 804:	1101                	add	sp,sp,-32
 806:	ec06                	sd	ra,24(sp)
 808:	e822                	sd	s0,16(sp)
 80a:	1000                	add	s0,sp,32
 80c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 810:	4605                	li	a2,1
 812:	fef40593          	add	a1,s0,-17
 816:	f37ff0ef          	jal	74c <write>
}
 81a:	60e2                	ld	ra,24(sp)
 81c:	6442                	ld	s0,16(sp)
 81e:	6105                	add	sp,sp,32
 820:	8082                	ret

0000000000000822 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 822:	7139                	add	sp,sp,-64
 824:	fc06                	sd	ra,56(sp)
 826:	f822                	sd	s0,48(sp)
 828:	f426                	sd	s1,40(sp)
 82a:	f04a                	sd	s2,32(sp)
 82c:	ec4e                	sd	s3,24(sp)
 82e:	0080                	add	s0,sp,64
 830:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 832:	c299                	beqz	a3,838 <printint+0x16>
 834:	0805c763          	bltz	a1,8c2 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 838:	2581                	sext.w	a1,a1
  neg = 0;
 83a:	4881                	li	a7,0
 83c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 840:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 842:	2601                	sext.w	a2,a2
 844:	00000517          	auipc	a0,0x0
 848:	61450513          	add	a0,a0,1556 # e58 <digits>
 84c:	883a                	mv	a6,a4
 84e:	2705                	addw	a4,a4,1
 850:	02c5f7bb          	remuw	a5,a1,a2
 854:	1782                	sll	a5,a5,0x20
 856:	9381                	srl	a5,a5,0x20
 858:	97aa                	add	a5,a5,a0
 85a:	0007c783          	lbu	a5,0(a5)
 85e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 862:	0005879b          	sext.w	a5,a1
 866:	02c5d5bb          	divuw	a1,a1,a2
 86a:	0685                	add	a3,a3,1
 86c:	fec7f0e3          	bgeu	a5,a2,84c <printint+0x2a>
  if(neg)
 870:	00088c63          	beqz	a7,888 <printint+0x66>
    buf[i++] = '-';
 874:	fd070793          	add	a5,a4,-48
 878:	00878733          	add	a4,a5,s0
 87c:	02d00793          	li	a5,45
 880:	fef70823          	sb	a5,-16(a4)
 884:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 888:	02e05663          	blez	a4,8b4 <printint+0x92>
 88c:	fc040793          	add	a5,s0,-64
 890:	00e78933          	add	s2,a5,a4
 894:	fff78993          	add	s3,a5,-1
 898:	99ba                	add	s3,s3,a4
 89a:	377d                	addw	a4,a4,-1
 89c:	1702                	sll	a4,a4,0x20
 89e:	9301                	srl	a4,a4,0x20
 8a0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 8a4:	fff94583          	lbu	a1,-1(s2)
 8a8:	8526                	mv	a0,s1
 8aa:	f5bff0ef          	jal	804 <putc>
  while(--i >= 0)
 8ae:	197d                	add	s2,s2,-1
 8b0:	ff391ae3          	bne	s2,s3,8a4 <printint+0x82>
}
 8b4:	70e2                	ld	ra,56(sp)
 8b6:	7442                	ld	s0,48(sp)
 8b8:	74a2                	ld	s1,40(sp)
 8ba:	7902                	ld	s2,32(sp)
 8bc:	69e2                	ld	s3,24(sp)
 8be:	6121                	add	sp,sp,64
 8c0:	8082                	ret
    x = -xx;
 8c2:	40b005bb          	negw	a1,a1
    neg = 1;
 8c6:	4885                	li	a7,1
    x = -xx;
 8c8:	bf95                	j	83c <printint+0x1a>

00000000000008ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8ca:	711d                	add	sp,sp,-96
 8cc:	ec86                	sd	ra,88(sp)
 8ce:	e8a2                	sd	s0,80(sp)
 8d0:	e4a6                	sd	s1,72(sp)
 8d2:	e0ca                	sd	s2,64(sp)
 8d4:	fc4e                	sd	s3,56(sp)
 8d6:	f852                	sd	s4,48(sp)
 8d8:	f456                	sd	s5,40(sp)
 8da:	f05a                	sd	s6,32(sp)
 8dc:	ec5e                	sd	s7,24(sp)
 8de:	e862                	sd	s8,16(sp)
 8e0:	e466                	sd	s9,8(sp)
 8e2:	e06a                	sd	s10,0(sp)
 8e4:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8e6:	0005c903          	lbu	s2,0(a1)
 8ea:	24090763          	beqz	s2,b38 <vprintf+0x26e>
 8ee:	8b2a                	mv	s6,a0
 8f0:	8a2e                	mv	s4,a1
 8f2:	8bb2                	mv	s7,a2
  state = 0;
 8f4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 8f6:	4481                	li	s1,0
 8f8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 8fa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 8fe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 902:	06c00c93          	li	s9,108
 906:	a005                	j	926 <vprintf+0x5c>
        putc(fd, c0);
 908:	85ca                	mv	a1,s2
 90a:	855a                	mv	a0,s6
 90c:	ef9ff0ef          	jal	804 <putc>
 910:	a019                	j	916 <vprintf+0x4c>
    } else if(state == '%'){
 912:	03598263          	beq	s3,s5,936 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 916:	2485                	addw	s1,s1,1
 918:	8726                	mv	a4,s1
 91a:	009a07b3          	add	a5,s4,s1
 91e:	0007c903          	lbu	s2,0(a5)
 922:	20090b63          	beqz	s2,b38 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 926:	0009079b          	sext.w	a5,s2
    if(state == 0){
 92a:	fe0994e3          	bnez	s3,912 <vprintf+0x48>
      if(c0 == '%'){
 92e:	fd579de3          	bne	a5,s5,908 <vprintf+0x3e>
        state = '%';
 932:	89be                	mv	s3,a5
 934:	b7cd                	j	916 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 936:	c7c9                	beqz	a5,9c0 <vprintf+0xf6>
 938:	00ea06b3          	add	a3,s4,a4
 93c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 940:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 942:	c681                	beqz	a3,94a <vprintf+0x80>
 944:	9752                	add	a4,a4,s4
 946:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 94a:	03878f63          	beq	a5,s8,988 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 94e:	05978963          	beq	a5,s9,9a0 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 952:	07500713          	li	a4,117
 956:	0ee78363          	beq	a5,a4,a3c <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 95a:	07800713          	li	a4,120
 95e:	12e78563          	beq	a5,a4,a88 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 962:	07000713          	li	a4,112
 966:	14e78a63          	beq	a5,a4,aba <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 96a:	07300713          	li	a4,115
 96e:	18e78863          	beq	a5,a4,afe <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 972:	02500713          	li	a4,37
 976:	04e79563          	bne	a5,a4,9c0 <vprintf+0xf6>
        putc(fd, '%');
 97a:	02500593          	li	a1,37
 97e:	855a                	mv	a0,s6
 980:	e85ff0ef          	jal	804 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 984:	4981                	li	s3,0
 986:	bf41                	j	916 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 988:	008b8913          	add	s2,s7,8
 98c:	4685                	li	a3,1
 98e:	4629                	li	a2,10
 990:	000ba583          	lw	a1,0(s7)
 994:	855a                	mv	a0,s6
 996:	e8dff0ef          	jal	822 <printint>
 99a:	8bca                	mv	s7,s2
      state = 0;
 99c:	4981                	li	s3,0
 99e:	bfa5                	j	916 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 9a0:	06400793          	li	a5,100
 9a4:	02f68963          	beq	a3,a5,9d6 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9a8:	06c00793          	li	a5,108
 9ac:	04f68263          	beq	a3,a5,9f0 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 9b0:	07500793          	li	a5,117
 9b4:	0af68063          	beq	a3,a5,a54 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 9b8:	07800793          	li	a5,120
 9bc:	0ef68263          	beq	a3,a5,aa0 <vprintf+0x1d6>
        putc(fd, '%');
 9c0:	02500593          	li	a1,37
 9c4:	855a                	mv	a0,s6
 9c6:	e3fff0ef          	jal	804 <putc>
        putc(fd, c0);
 9ca:	85ca                	mv	a1,s2
 9cc:	855a                	mv	a0,s6
 9ce:	e37ff0ef          	jal	804 <putc>
      state = 0;
 9d2:	4981                	li	s3,0
 9d4:	b789                	j	916 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9d6:	008b8913          	add	s2,s7,8
 9da:	4685                	li	a3,1
 9dc:	4629                	li	a2,10
 9de:	000ba583          	lw	a1,0(s7)
 9e2:	855a                	mv	a0,s6
 9e4:	e3fff0ef          	jal	822 <printint>
        i += 1;
 9e8:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 9ea:	8bca                	mv	s7,s2
      state = 0;
 9ec:	4981                	li	s3,0
        i += 1;
 9ee:	b725                	j	916 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9f0:	06400793          	li	a5,100
 9f4:	02f60763          	beq	a2,a5,a22 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 9f8:	07500793          	li	a5,117
 9fc:	06f60963          	beq	a2,a5,a6e <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a00:	07800793          	li	a5,120
 a04:	faf61ee3          	bne	a2,a5,9c0 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a08:	008b8913          	add	s2,s7,8
 a0c:	4681                	li	a3,0
 a0e:	4641                	li	a2,16
 a10:	000ba583          	lw	a1,0(s7)
 a14:	855a                	mv	a0,s6
 a16:	e0dff0ef          	jal	822 <printint>
        i += 2;
 a1a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a1c:	8bca                	mv	s7,s2
      state = 0;
 a1e:	4981                	li	s3,0
        i += 2;
 a20:	bddd                	j	916 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a22:	008b8913          	add	s2,s7,8
 a26:	4685                	li	a3,1
 a28:	4629                	li	a2,10
 a2a:	000ba583          	lw	a1,0(s7)
 a2e:	855a                	mv	a0,s6
 a30:	df3ff0ef          	jal	822 <printint>
        i += 2;
 a34:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a36:	8bca                	mv	s7,s2
      state = 0;
 a38:	4981                	li	s3,0
        i += 2;
 a3a:	bdf1                	j	916 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 a3c:	008b8913          	add	s2,s7,8
 a40:	4681                	li	a3,0
 a42:	4629                	li	a2,10
 a44:	000ba583          	lw	a1,0(s7)
 a48:	855a                	mv	a0,s6
 a4a:	dd9ff0ef          	jal	822 <printint>
 a4e:	8bca                	mv	s7,s2
      state = 0;
 a50:	4981                	li	s3,0
 a52:	b5d1                	j	916 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a54:	008b8913          	add	s2,s7,8
 a58:	4681                	li	a3,0
 a5a:	4629                	li	a2,10
 a5c:	000ba583          	lw	a1,0(s7)
 a60:	855a                	mv	a0,s6
 a62:	dc1ff0ef          	jal	822 <printint>
        i += 1;
 a66:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a68:	8bca                	mv	s7,s2
      state = 0;
 a6a:	4981                	li	s3,0
        i += 1;
 a6c:	b56d                	j	916 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a6e:	008b8913          	add	s2,s7,8
 a72:	4681                	li	a3,0
 a74:	4629                	li	a2,10
 a76:	000ba583          	lw	a1,0(s7)
 a7a:	855a                	mv	a0,s6
 a7c:	da7ff0ef          	jal	822 <printint>
        i += 2;
 a80:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a82:	8bca                	mv	s7,s2
      state = 0;
 a84:	4981                	li	s3,0
        i += 2;
 a86:	bd41                	j	916 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 a88:	008b8913          	add	s2,s7,8
 a8c:	4681                	li	a3,0
 a8e:	4641                	li	a2,16
 a90:	000ba583          	lw	a1,0(s7)
 a94:	855a                	mv	a0,s6
 a96:	d8dff0ef          	jal	822 <printint>
 a9a:	8bca                	mv	s7,s2
      state = 0;
 a9c:	4981                	li	s3,0
 a9e:	bda5                	j	916 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 aa0:	008b8913          	add	s2,s7,8
 aa4:	4681                	li	a3,0
 aa6:	4641                	li	a2,16
 aa8:	000ba583          	lw	a1,0(s7)
 aac:	855a                	mv	a0,s6
 aae:	d75ff0ef          	jal	822 <printint>
        i += 1;
 ab2:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 ab4:	8bca                	mv	s7,s2
      state = 0;
 ab6:	4981                	li	s3,0
        i += 1;
 ab8:	bdb9                	j	916 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 aba:	008b8d13          	add	s10,s7,8
 abe:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 ac2:	03000593          	li	a1,48
 ac6:	855a                	mv	a0,s6
 ac8:	d3dff0ef          	jal	804 <putc>
  putc(fd, 'x');
 acc:	07800593          	li	a1,120
 ad0:	855a                	mv	a0,s6
 ad2:	d33ff0ef          	jal	804 <putc>
 ad6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 ad8:	00000b97          	auipc	s7,0x0
 adc:	380b8b93          	add	s7,s7,896 # e58 <digits>
 ae0:	03c9d793          	srl	a5,s3,0x3c
 ae4:	97de                	add	a5,a5,s7
 ae6:	0007c583          	lbu	a1,0(a5)
 aea:	855a                	mv	a0,s6
 aec:	d19ff0ef          	jal	804 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 af0:	0992                	sll	s3,s3,0x4
 af2:	397d                	addw	s2,s2,-1
 af4:	fe0916e3          	bnez	s2,ae0 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 af8:	8bea                	mv	s7,s10
      state = 0;
 afa:	4981                	li	s3,0
 afc:	bd29                	j	916 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 afe:	008b8993          	add	s3,s7,8
 b02:	000bb903          	ld	s2,0(s7)
 b06:	00090f63          	beqz	s2,b24 <vprintf+0x25a>
        for(; *s; s++)
 b0a:	00094583          	lbu	a1,0(s2)
 b0e:	c195                	beqz	a1,b32 <vprintf+0x268>
          putc(fd, *s);
 b10:	855a                	mv	a0,s6
 b12:	cf3ff0ef          	jal	804 <putc>
        for(; *s; s++)
 b16:	0905                	add	s2,s2,1
 b18:	00094583          	lbu	a1,0(s2)
 b1c:	f9f5                	bnez	a1,b10 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b1e:	8bce                	mv	s7,s3
      state = 0;
 b20:	4981                	li	s3,0
 b22:	bbd5                	j	916 <vprintf+0x4c>
          s = "(null)";
 b24:	00000917          	auipc	s2,0x0
 b28:	32c90913          	add	s2,s2,812 # e50 <malloc+0x21e>
        for(; *s; s++)
 b2c:	02800593          	li	a1,40
 b30:	b7c5                	j	b10 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b32:	8bce                	mv	s7,s3
      state = 0;
 b34:	4981                	li	s3,0
 b36:	b3c5                	j	916 <vprintf+0x4c>
    }
  }
}
 b38:	60e6                	ld	ra,88(sp)
 b3a:	6446                	ld	s0,80(sp)
 b3c:	64a6                	ld	s1,72(sp)
 b3e:	6906                	ld	s2,64(sp)
 b40:	79e2                	ld	s3,56(sp)
 b42:	7a42                	ld	s4,48(sp)
 b44:	7aa2                	ld	s5,40(sp)
 b46:	7b02                	ld	s6,32(sp)
 b48:	6be2                	ld	s7,24(sp)
 b4a:	6c42                	ld	s8,16(sp)
 b4c:	6ca2                	ld	s9,8(sp)
 b4e:	6d02                	ld	s10,0(sp)
 b50:	6125                	add	sp,sp,96
 b52:	8082                	ret

0000000000000b54 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b54:	715d                	add	sp,sp,-80
 b56:	ec06                	sd	ra,24(sp)
 b58:	e822                	sd	s0,16(sp)
 b5a:	1000                	add	s0,sp,32
 b5c:	e010                	sd	a2,0(s0)
 b5e:	e414                	sd	a3,8(s0)
 b60:	e818                	sd	a4,16(s0)
 b62:	ec1c                	sd	a5,24(s0)
 b64:	03043023          	sd	a6,32(s0)
 b68:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b6c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b70:	8622                	mv	a2,s0
 b72:	d59ff0ef          	jal	8ca <vprintf>
}
 b76:	60e2                	ld	ra,24(sp)
 b78:	6442                	ld	s0,16(sp)
 b7a:	6161                	add	sp,sp,80
 b7c:	8082                	ret

0000000000000b7e <printf>:

void
printf(const char *fmt, ...)
{
 b7e:	711d                	add	sp,sp,-96
 b80:	ec06                	sd	ra,24(sp)
 b82:	e822                	sd	s0,16(sp)
 b84:	1000                	add	s0,sp,32
 b86:	e40c                	sd	a1,8(s0)
 b88:	e810                	sd	a2,16(s0)
 b8a:	ec14                	sd	a3,24(s0)
 b8c:	f018                	sd	a4,32(s0)
 b8e:	f41c                	sd	a5,40(s0)
 b90:	03043823          	sd	a6,48(s0)
 b94:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b98:	00840613          	add	a2,s0,8
 b9c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ba0:	85aa                	mv	a1,a0
 ba2:	4505                	li	a0,1
 ba4:	d27ff0ef          	jal	8ca <vprintf>
}
 ba8:	60e2                	ld	ra,24(sp)
 baa:	6442                	ld	s0,16(sp)
 bac:	6125                	add	sp,sp,96
 bae:	8082                	ret

0000000000000bb0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bb0:	1141                	add	sp,sp,-16
 bb2:	e422                	sd	s0,8(sp)
 bb4:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bb6:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bba:	00000797          	auipc	a5,0x0
 bbe:	4567b783          	ld	a5,1110(a5) # 1010 <freep>
 bc2:	a02d                	j	bec <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 bc4:	4618                	lw	a4,8(a2)
 bc6:	9f2d                	addw	a4,a4,a1
 bc8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 bcc:	6398                	ld	a4,0(a5)
 bce:	6310                	ld	a2,0(a4)
 bd0:	a83d                	j	c0e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 bd2:	ff852703          	lw	a4,-8(a0)
 bd6:	9f31                	addw	a4,a4,a2
 bd8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bda:	ff053683          	ld	a3,-16(a0)
 bde:	a091                	j	c22 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 be0:	6398                	ld	a4,0(a5)
 be2:	00e7e463          	bltu	a5,a4,bea <free+0x3a>
 be6:	00e6ea63          	bltu	a3,a4,bfa <free+0x4a>
{
 bea:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bec:	fed7fae3          	bgeu	a5,a3,be0 <free+0x30>
 bf0:	6398                	ld	a4,0(a5)
 bf2:	00e6e463          	bltu	a3,a4,bfa <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bf6:	fee7eae3          	bltu	a5,a4,bea <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 bfa:	ff852583          	lw	a1,-8(a0)
 bfe:	6390                	ld	a2,0(a5)
 c00:	02059813          	sll	a6,a1,0x20
 c04:	01c85713          	srl	a4,a6,0x1c
 c08:	9736                	add	a4,a4,a3
 c0a:	fae60de3          	beq	a2,a4,bc4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 c0e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c12:	4790                	lw	a2,8(a5)
 c14:	02061593          	sll	a1,a2,0x20
 c18:	01c5d713          	srl	a4,a1,0x1c
 c1c:	973e                	add	a4,a4,a5
 c1e:	fae68ae3          	beq	a3,a4,bd2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 c22:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c24:	00000717          	auipc	a4,0x0
 c28:	3ef73623          	sd	a5,1004(a4) # 1010 <freep>
}
 c2c:	6422                	ld	s0,8(sp)
 c2e:	0141                	add	sp,sp,16
 c30:	8082                	ret

0000000000000c32 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c32:	7139                	add	sp,sp,-64
 c34:	fc06                	sd	ra,56(sp)
 c36:	f822                	sd	s0,48(sp)
 c38:	f426                	sd	s1,40(sp)
 c3a:	f04a                	sd	s2,32(sp)
 c3c:	ec4e                	sd	s3,24(sp)
 c3e:	e852                	sd	s4,16(sp)
 c40:	e456                	sd	s5,8(sp)
 c42:	e05a                	sd	s6,0(sp)
 c44:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c46:	02051493          	sll	s1,a0,0x20
 c4a:	9081                	srl	s1,s1,0x20
 c4c:	04bd                	add	s1,s1,15
 c4e:	8091                	srl	s1,s1,0x4
 c50:	0014899b          	addw	s3,s1,1
 c54:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 c56:	00000517          	auipc	a0,0x0
 c5a:	3ba53503          	ld	a0,954(a0) # 1010 <freep>
 c5e:	c515                	beqz	a0,c8a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c60:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c62:	4798                	lw	a4,8(a5)
 c64:	02977f63          	bgeu	a4,s1,ca2 <malloc+0x70>
  if(nu < 4096)
 c68:	8a4e                	mv	s4,s3
 c6a:	0009871b          	sext.w	a4,s3
 c6e:	6685                	lui	a3,0x1
 c70:	00d77363          	bgeu	a4,a3,c76 <malloc+0x44>
 c74:	6a05                	lui	s4,0x1
 c76:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c7a:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c7e:	00000917          	auipc	s2,0x0
 c82:	39290913          	add	s2,s2,914 # 1010 <freep>
  if(p == (char*)-1)
 c86:	5afd                	li	s5,-1
 c88:	a885                	j	cf8 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 c8a:	00000797          	auipc	a5,0x0
 c8e:	39678793          	add	a5,a5,918 # 1020 <base>
 c92:	00000717          	auipc	a4,0x0
 c96:	36f73f23          	sd	a5,894(a4) # 1010 <freep>
 c9a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c9c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ca0:	b7e1                	j	c68 <malloc+0x36>
      if(p->s.size == nunits)
 ca2:	02e48c63          	beq	s1,a4,cda <malloc+0xa8>
        p->s.size -= nunits;
 ca6:	4137073b          	subw	a4,a4,s3
 caa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cac:	02071693          	sll	a3,a4,0x20
 cb0:	01c6d713          	srl	a4,a3,0x1c
 cb4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 cb6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 cba:	00000717          	auipc	a4,0x0
 cbe:	34a73b23          	sd	a0,854(a4) # 1010 <freep>
      return (void*)(p + 1);
 cc2:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 cc6:	70e2                	ld	ra,56(sp)
 cc8:	7442                	ld	s0,48(sp)
 cca:	74a2                	ld	s1,40(sp)
 ccc:	7902                	ld	s2,32(sp)
 cce:	69e2                	ld	s3,24(sp)
 cd0:	6a42                	ld	s4,16(sp)
 cd2:	6aa2                	ld	s5,8(sp)
 cd4:	6b02                	ld	s6,0(sp)
 cd6:	6121                	add	sp,sp,64
 cd8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 cda:	6398                	ld	a4,0(a5)
 cdc:	e118                	sd	a4,0(a0)
 cde:	bff1                	j	cba <malloc+0x88>
  hp->s.size = nu;
 ce0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ce4:	0541                	add	a0,a0,16
 ce6:	ecbff0ef          	jal	bb0 <free>
  return freep;
 cea:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cee:	dd61                	beqz	a0,cc6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cf0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cf2:	4798                	lw	a4,8(a5)
 cf4:	fa9777e3          	bgeu	a4,s1,ca2 <malloc+0x70>
    if(p == freep)
 cf8:	00093703          	ld	a4,0(s2)
 cfc:	853e                	mv	a0,a5
 cfe:	fef719e3          	bne	a4,a5,cf0 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 d02:	8552                	mv	a0,s4
 d04:	ab1ff0ef          	jal	7b4 <sbrk>
  if(p == (char*)-1)
 d08:	fd551ce3          	bne	a0,s5,ce0 <malloc+0xae>
        return 0;
 d0c:	4501                	li	a0,0
 d0e:	bf65                	j	cc6 <malloc+0x94>
