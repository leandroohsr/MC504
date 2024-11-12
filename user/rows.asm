
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
  d2:	d7a7b783          	ld	a5,-646(a5) # e48 <malloc+0x20e>
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
 182:	ba360613          	add	a2,a2,-1117 # d21 <malloc+0xe7>
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

    t0 = uptime_nolock();
 1ae:	656000ef          	jal	804 <uptime_nolock>
 1b2:	8baa                	mv	s7,a0
    fd = open(filename, O_CREATE | O_RDWR);
 1b4:	20200593          	li	a1,514
 1b8:	f8840513          	add	a0,s0,-120
 1bc:	5b0000ef          	jal	76c <open>
 1c0:	8c2a                	mv	s8,a0
    t1 = uptime_nolock();
 1c2:	642000ef          	jal	804 <uptime_nolock>
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
 1e6:	b6690913          	add	s2,s2,-1178 # d48 <malloc+0x10e>
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
        t0 = uptime_nolock();
 206:	5fe000ef          	jal	804 <uptime_nolock>
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
            t1 = uptime_nolock();
 222:	5e2000ef          	jal	804 <uptime_nolock>
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
        t0 = uptime_nolock();
 242:	5c2000ef          	jal	804 <uptime_nolock>
 246:	84aa                	mv	s1,a0
        linhas[j] = malloc(102 * sizeof(char)); // allocate memory for each string
 248:	06600513          	li	a0,102
 24c:	1ef000ef          	jal	c3a <malloc>
 250:	00a93023          	sd	a0,0(s2)
        t1 = uptime_nolock();
 254:	5b0000ef          	jal	804 <uptime_nolock>
        total_overhead += t1 - t0;
 258:	409504bb          	subw	s1,a0,s1
 25c:	017484bb          	addw	s1,s1,s7
 260:	00048b9b          	sext.w	s7,s1
    for (int j = 0; j < 100; j++) {
 264:	0921                	add	s2,s2,8
 266:	fd2a1ee3          	bne	s4,s2,242 <main+0x1ce>
    }

    t0 = uptime_nolock();
 26a:	59a000ef          	jal	804 <uptime_nolock>
 26e:	892a                	mv	s2,a0
    fd = open(filename, O_RDONLY);
 270:	4581                	li	a1,0
 272:	f8840513          	add	a0,s0,-120
 276:	4f6000ef          	jal	76c <open>
 27a:	8b2a                	mv	s6,a0
    t1 = uptime_nolock();
 27c:	588000ef          	jal	804 <uptime_nolock>
    total_overhead += t1 - t0;
 280:	4125093b          	subw	s2,a0,s2
 284:	0099093b          	addw	s2,s2,s1
    if (fd < 0) {
 288:	020b4d63          	bltz	s6,2c2 <main+0x24e>
    }

    char buf[101];
    int n;
    i = 0;
    t0 = uptime_nolock();
 28c:	578000ef          	jal	804 <uptime_nolock>
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
 2a6:	a8650513          	add	a0,a0,-1402 # d28 <malloc+0xee>
 2aa:	0dd000ef          	jal	b86 <printf>
 2ae:	b705                	j	1ce <main+0x15a>
            printf("error, write failed\n");
 2b0:	00001517          	auipc	a0,0x1
 2b4:	ae050513          	add	a0,a0,-1312 # d90 <malloc+0x156>
 2b8:	0cf000ef          	jal	b86 <printf>
            exit(1);
 2bc:	4505                	li	a0,1
 2be:	46e000ef          	jal	72c <exit>
        printf("Erro ao abrir o arquivo %s\n", filename);
 2c2:	f8840593          	add	a1,s0,-120
 2c6:	00001517          	auipc	a0,0x1
 2ca:	ae250513          	add	a0,a0,-1310 # da8 <malloc+0x16e>
 2ce:	0b9000ef          	jal	b86 <printf>
        exit(1);
 2d2:	4505                	li	a0,1
 2d4:	458000ef          	jal	72c <exit>
        t1 = uptime_nolock();
 2d8:	52c000ef          	jal	804 <uptime_nolock>
        total_eficiencia += t1 - t0;
 2dc:	409507bb          	subw	a5,a0,s1
 2e0:	01578abb          	addw	s5,a5,s5
        strcpy(linhas[i], buf);
 2e4:	b8840593          	add	a1,s0,-1144
 2e8:	000bb503          	ld	a0,0(s7)
 2ec:	1e8000ef          	jal	4d4 <strcpy>
        i++;
        t0 = uptime_nolock();
 2f0:	514000ef          	jal	804 <uptime_nolock>
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
    t0 = uptime_nolock();
 310:	4f4000ef          	jal	804 <uptime_nolock>
 314:	8d2a                	mv	s10,a0
    tmp = malloc(102*sizeof(char));
 316:	06600513          	li	a0,102
 31a:	121000ef          	jal	c3a <malloc>
 31e:	8baa                	mv	s7,a0
    t1 = uptime_nolock();
 320:	4e4000ef          	jal	804 <uptime_nolock>
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
    t0 = uptime_nolock();
 37e:	486000ef          	jal	804 <uptime_nolock>
 382:	84aa                	mv	s1,a0
    free(tmp);
 384:	855e                	mv	a0,s7
 386:	033000ef          	jal	bb8 <free>
    t1 = uptime_nolock();
 38a:	47a000ef          	jal	804 <uptime_nolock>
    total_overhead += t1 - t0;
 38e:	409504bb          	subw	s1,a0,s1
 392:	01a484bb          	addw	s1,s1,s10

    //rewriting file after permutations
    t0 = uptime_nolock();
 396:	46e000ef          	jal	804 <uptime_nolock>
 39a:	892a                	mv	s2,a0
    fd = open(filename, O_RDWR);
 39c:	4589                	li	a1,2
 39e:	f8840513          	add	a0,s0,-120
 3a2:	3ca000ef          	jal	76c <open>
 3a6:	8baa                	mv	s7,a0
    t1 = uptime_nolock();
 3a8:	45c000ef          	jal	804 <uptime_nolock>
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
        t0 = uptime_nolock();
 3ba:	44a000ef          	jal	804 <uptime_nolock>
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
            t1 = uptime_nolock();
 3d6:	42e000ef          	jal	804 <uptime_nolock>
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
    t0 = uptime_nolock();
 3f2:	412000ef          	jal	804 <uptime_nolock>
 3f6:	8aaa                	mv	s5,a0
    if (unlink(filename) < 0){
 3f8:	f8840513          	add	a0,s0,-120
 3fc:	380000ef          	jal	77c <unlink>
 400:	0a054863          	bltz	a0,4b0 <main+0x43c>
        printf("Erro ao remover o arquivo\n");
        exit(1);
    } else {
        t1 = uptime_nolock();
 404:	400000ef          	jal	804 <uptime_nolock>
        total_eficiencia += t1 - t0;
 408:	41550abb          	subw	s5,a0,s5
 40c:	009a8abb          	addw	s5,s5,s1
    }


    //free malloc for linhas
    for (int j = 0; j < 100; j++) {
        t0 = uptime_nolock();
 410:	3f4000ef          	jal	804 <uptime_nolock>
 414:	84aa                	mv	s1,a0
        free(linhas[j]);
 416:	0009b503          	ld	a0,0(s3)
 41a:	79e000ef          	jal	bb8 <free>
        t1 = uptime_nolock();
 41e:	3e6000ef          	jal	804 <uptime_nolock>
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
 490:	93c50513          	add	a0,a0,-1732 # dc8 <malloc+0x18e>
 494:	6f2000ef          	jal	b86 <printf>
        exit(1);
 498:	4505                	li	a0,1
 49a:	292000ef          	jal	72c <exit>
            printf("error, write permut failed\n");
 49e:	00001517          	auipc	a0,0x1
 4a2:	96a50513          	add	a0,a0,-1686 # e08 <malloc+0x1ce>
 4a6:	6e0000ef          	jal	b86 <printf>
            exit(1);
 4aa:	4505                	li	a0,1
 4ac:	280000ef          	jal	72c <exit>
        printf("Erro ao remover o arquivo\n");
 4b0:	00001517          	auipc	a0,0x1
 4b4:	97850513          	add	a0,a0,-1672 # e28 <malloc+0x1ee>
 4b8:	6ce000ef          	jal	b86 <printf>
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

0000000000000804 <uptime_nolock>:
.global uptime_nolock
uptime_nolock:
 li a7, SYS_uptime_nolock
 804:	48f5                	li	a7,29
 ecall
 806:	00000073          	ecall
 ret
 80a:	8082                	ret

000000000000080c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 80c:	1101                	add	sp,sp,-32
 80e:	ec06                	sd	ra,24(sp)
 810:	e822                	sd	s0,16(sp)
 812:	1000                	add	s0,sp,32
 814:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 818:	4605                	li	a2,1
 81a:	fef40593          	add	a1,s0,-17
 81e:	f2fff0ef          	jal	74c <write>
}
 822:	60e2                	ld	ra,24(sp)
 824:	6442                	ld	s0,16(sp)
 826:	6105                	add	sp,sp,32
 828:	8082                	ret

000000000000082a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 82a:	7139                	add	sp,sp,-64
 82c:	fc06                	sd	ra,56(sp)
 82e:	f822                	sd	s0,48(sp)
 830:	f426                	sd	s1,40(sp)
 832:	f04a                	sd	s2,32(sp)
 834:	ec4e                	sd	s3,24(sp)
 836:	0080                	add	s0,sp,64
 838:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 83a:	c299                	beqz	a3,840 <printint+0x16>
 83c:	0805c763          	bltz	a1,8ca <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 840:	2581                	sext.w	a1,a1
  neg = 0;
 842:	4881                	li	a7,0
 844:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 848:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 84a:	2601                	sext.w	a2,a2
 84c:	00000517          	auipc	a0,0x0
 850:	61c50513          	add	a0,a0,1564 # e68 <digits>
 854:	883a                	mv	a6,a4
 856:	2705                	addw	a4,a4,1
 858:	02c5f7bb          	remuw	a5,a1,a2
 85c:	1782                	sll	a5,a5,0x20
 85e:	9381                	srl	a5,a5,0x20
 860:	97aa                	add	a5,a5,a0
 862:	0007c783          	lbu	a5,0(a5)
 866:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 86a:	0005879b          	sext.w	a5,a1
 86e:	02c5d5bb          	divuw	a1,a1,a2
 872:	0685                	add	a3,a3,1
 874:	fec7f0e3          	bgeu	a5,a2,854 <printint+0x2a>
  if(neg)
 878:	00088c63          	beqz	a7,890 <printint+0x66>
    buf[i++] = '-';
 87c:	fd070793          	add	a5,a4,-48
 880:	00878733          	add	a4,a5,s0
 884:	02d00793          	li	a5,45
 888:	fef70823          	sb	a5,-16(a4)
 88c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 890:	02e05663          	blez	a4,8bc <printint+0x92>
 894:	fc040793          	add	a5,s0,-64
 898:	00e78933          	add	s2,a5,a4
 89c:	fff78993          	add	s3,a5,-1
 8a0:	99ba                	add	s3,s3,a4
 8a2:	377d                	addw	a4,a4,-1
 8a4:	1702                	sll	a4,a4,0x20
 8a6:	9301                	srl	a4,a4,0x20
 8a8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 8ac:	fff94583          	lbu	a1,-1(s2)
 8b0:	8526                	mv	a0,s1
 8b2:	f5bff0ef          	jal	80c <putc>
  while(--i >= 0)
 8b6:	197d                	add	s2,s2,-1
 8b8:	ff391ae3          	bne	s2,s3,8ac <printint+0x82>
}
 8bc:	70e2                	ld	ra,56(sp)
 8be:	7442                	ld	s0,48(sp)
 8c0:	74a2                	ld	s1,40(sp)
 8c2:	7902                	ld	s2,32(sp)
 8c4:	69e2                	ld	s3,24(sp)
 8c6:	6121                	add	sp,sp,64
 8c8:	8082                	ret
    x = -xx;
 8ca:	40b005bb          	negw	a1,a1
    neg = 1;
 8ce:	4885                	li	a7,1
    x = -xx;
 8d0:	bf95                	j	844 <printint+0x1a>

00000000000008d2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8d2:	711d                	add	sp,sp,-96
 8d4:	ec86                	sd	ra,88(sp)
 8d6:	e8a2                	sd	s0,80(sp)
 8d8:	e4a6                	sd	s1,72(sp)
 8da:	e0ca                	sd	s2,64(sp)
 8dc:	fc4e                	sd	s3,56(sp)
 8de:	f852                	sd	s4,48(sp)
 8e0:	f456                	sd	s5,40(sp)
 8e2:	f05a                	sd	s6,32(sp)
 8e4:	ec5e                	sd	s7,24(sp)
 8e6:	e862                	sd	s8,16(sp)
 8e8:	e466                	sd	s9,8(sp)
 8ea:	e06a                	sd	s10,0(sp)
 8ec:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8ee:	0005c903          	lbu	s2,0(a1)
 8f2:	24090763          	beqz	s2,b40 <vprintf+0x26e>
 8f6:	8b2a                	mv	s6,a0
 8f8:	8a2e                	mv	s4,a1
 8fa:	8bb2                	mv	s7,a2
  state = 0;
 8fc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 8fe:	4481                	li	s1,0
 900:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 902:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 906:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 90a:	06c00c93          	li	s9,108
 90e:	a005                	j	92e <vprintf+0x5c>
        putc(fd, c0);
 910:	85ca                	mv	a1,s2
 912:	855a                	mv	a0,s6
 914:	ef9ff0ef          	jal	80c <putc>
 918:	a019                	j	91e <vprintf+0x4c>
    } else if(state == '%'){
 91a:	03598263          	beq	s3,s5,93e <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 91e:	2485                	addw	s1,s1,1
 920:	8726                	mv	a4,s1
 922:	009a07b3          	add	a5,s4,s1
 926:	0007c903          	lbu	s2,0(a5)
 92a:	20090b63          	beqz	s2,b40 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 92e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 932:	fe0994e3          	bnez	s3,91a <vprintf+0x48>
      if(c0 == '%'){
 936:	fd579de3          	bne	a5,s5,910 <vprintf+0x3e>
        state = '%';
 93a:	89be                	mv	s3,a5
 93c:	b7cd                	j	91e <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 93e:	c7c9                	beqz	a5,9c8 <vprintf+0xf6>
 940:	00ea06b3          	add	a3,s4,a4
 944:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 948:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 94a:	c681                	beqz	a3,952 <vprintf+0x80>
 94c:	9752                	add	a4,a4,s4
 94e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 952:	03878f63          	beq	a5,s8,990 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 956:	05978963          	beq	a5,s9,9a8 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 95a:	07500713          	li	a4,117
 95e:	0ee78363          	beq	a5,a4,a44 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 962:	07800713          	li	a4,120
 966:	12e78563          	beq	a5,a4,a90 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 96a:	07000713          	li	a4,112
 96e:	14e78a63          	beq	a5,a4,ac2 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 972:	07300713          	li	a4,115
 976:	18e78863          	beq	a5,a4,b06 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 97a:	02500713          	li	a4,37
 97e:	04e79563          	bne	a5,a4,9c8 <vprintf+0xf6>
        putc(fd, '%');
 982:	02500593          	li	a1,37
 986:	855a                	mv	a0,s6
 988:	e85ff0ef          	jal	80c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 98c:	4981                	li	s3,0
 98e:	bf41                	j	91e <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 990:	008b8913          	add	s2,s7,8
 994:	4685                	li	a3,1
 996:	4629                	li	a2,10
 998:	000ba583          	lw	a1,0(s7)
 99c:	855a                	mv	a0,s6
 99e:	e8dff0ef          	jal	82a <printint>
 9a2:	8bca                	mv	s7,s2
      state = 0;
 9a4:	4981                	li	s3,0
 9a6:	bfa5                	j	91e <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 9a8:	06400793          	li	a5,100
 9ac:	02f68963          	beq	a3,a5,9de <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9b0:	06c00793          	li	a5,108
 9b4:	04f68263          	beq	a3,a5,9f8 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 9b8:	07500793          	li	a5,117
 9bc:	0af68063          	beq	a3,a5,a5c <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 9c0:	07800793          	li	a5,120
 9c4:	0ef68263          	beq	a3,a5,aa8 <vprintf+0x1d6>
        putc(fd, '%');
 9c8:	02500593          	li	a1,37
 9cc:	855a                	mv	a0,s6
 9ce:	e3fff0ef          	jal	80c <putc>
        putc(fd, c0);
 9d2:	85ca                	mv	a1,s2
 9d4:	855a                	mv	a0,s6
 9d6:	e37ff0ef          	jal	80c <putc>
      state = 0;
 9da:	4981                	li	s3,0
 9dc:	b789                	j	91e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9de:	008b8913          	add	s2,s7,8
 9e2:	4685                	li	a3,1
 9e4:	4629                	li	a2,10
 9e6:	000ba583          	lw	a1,0(s7)
 9ea:	855a                	mv	a0,s6
 9ec:	e3fff0ef          	jal	82a <printint>
        i += 1;
 9f0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 9f2:	8bca                	mv	s7,s2
      state = 0;
 9f4:	4981                	li	s3,0
        i += 1;
 9f6:	b725                	j	91e <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9f8:	06400793          	li	a5,100
 9fc:	02f60763          	beq	a2,a5,a2a <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a00:	07500793          	li	a5,117
 a04:	06f60963          	beq	a2,a5,a76 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a08:	07800793          	li	a5,120
 a0c:	faf61ee3          	bne	a2,a5,9c8 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a10:	008b8913          	add	s2,s7,8
 a14:	4681                	li	a3,0
 a16:	4641                	li	a2,16
 a18:	000ba583          	lw	a1,0(s7)
 a1c:	855a                	mv	a0,s6
 a1e:	e0dff0ef          	jal	82a <printint>
        i += 2;
 a22:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a24:	8bca                	mv	s7,s2
      state = 0;
 a26:	4981                	li	s3,0
        i += 2;
 a28:	bddd                	j	91e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a2a:	008b8913          	add	s2,s7,8
 a2e:	4685                	li	a3,1
 a30:	4629                	li	a2,10
 a32:	000ba583          	lw	a1,0(s7)
 a36:	855a                	mv	a0,s6
 a38:	df3ff0ef          	jal	82a <printint>
        i += 2;
 a3c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a3e:	8bca                	mv	s7,s2
      state = 0;
 a40:	4981                	li	s3,0
        i += 2;
 a42:	bdf1                	j	91e <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 a44:	008b8913          	add	s2,s7,8
 a48:	4681                	li	a3,0
 a4a:	4629                	li	a2,10
 a4c:	000ba583          	lw	a1,0(s7)
 a50:	855a                	mv	a0,s6
 a52:	dd9ff0ef          	jal	82a <printint>
 a56:	8bca                	mv	s7,s2
      state = 0;
 a58:	4981                	li	s3,0
 a5a:	b5d1                	j	91e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a5c:	008b8913          	add	s2,s7,8
 a60:	4681                	li	a3,0
 a62:	4629                	li	a2,10
 a64:	000ba583          	lw	a1,0(s7)
 a68:	855a                	mv	a0,s6
 a6a:	dc1ff0ef          	jal	82a <printint>
        i += 1;
 a6e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a70:	8bca                	mv	s7,s2
      state = 0;
 a72:	4981                	li	s3,0
        i += 1;
 a74:	b56d                	j	91e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a76:	008b8913          	add	s2,s7,8
 a7a:	4681                	li	a3,0
 a7c:	4629                	li	a2,10
 a7e:	000ba583          	lw	a1,0(s7)
 a82:	855a                	mv	a0,s6
 a84:	da7ff0ef          	jal	82a <printint>
        i += 2;
 a88:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a8a:	8bca                	mv	s7,s2
      state = 0;
 a8c:	4981                	li	s3,0
        i += 2;
 a8e:	bd41                	j	91e <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 a90:	008b8913          	add	s2,s7,8
 a94:	4681                	li	a3,0
 a96:	4641                	li	a2,16
 a98:	000ba583          	lw	a1,0(s7)
 a9c:	855a                	mv	a0,s6
 a9e:	d8dff0ef          	jal	82a <printint>
 aa2:	8bca                	mv	s7,s2
      state = 0;
 aa4:	4981                	li	s3,0
 aa6:	bda5                	j	91e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 aa8:	008b8913          	add	s2,s7,8
 aac:	4681                	li	a3,0
 aae:	4641                	li	a2,16
 ab0:	000ba583          	lw	a1,0(s7)
 ab4:	855a                	mv	a0,s6
 ab6:	d75ff0ef          	jal	82a <printint>
        i += 1;
 aba:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 abc:	8bca                	mv	s7,s2
      state = 0;
 abe:	4981                	li	s3,0
        i += 1;
 ac0:	bdb9                	j	91e <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 ac2:	008b8d13          	add	s10,s7,8
 ac6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 aca:	03000593          	li	a1,48
 ace:	855a                	mv	a0,s6
 ad0:	d3dff0ef          	jal	80c <putc>
  putc(fd, 'x');
 ad4:	07800593          	li	a1,120
 ad8:	855a                	mv	a0,s6
 ada:	d33ff0ef          	jal	80c <putc>
 ade:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 ae0:	00000b97          	auipc	s7,0x0
 ae4:	388b8b93          	add	s7,s7,904 # e68 <digits>
 ae8:	03c9d793          	srl	a5,s3,0x3c
 aec:	97de                	add	a5,a5,s7
 aee:	0007c583          	lbu	a1,0(a5)
 af2:	855a                	mv	a0,s6
 af4:	d19ff0ef          	jal	80c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 af8:	0992                	sll	s3,s3,0x4
 afa:	397d                	addw	s2,s2,-1
 afc:	fe0916e3          	bnez	s2,ae8 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 b00:	8bea                	mv	s7,s10
      state = 0;
 b02:	4981                	li	s3,0
 b04:	bd29                	j	91e <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 b06:	008b8993          	add	s3,s7,8
 b0a:	000bb903          	ld	s2,0(s7)
 b0e:	00090f63          	beqz	s2,b2c <vprintf+0x25a>
        for(; *s; s++)
 b12:	00094583          	lbu	a1,0(s2)
 b16:	c195                	beqz	a1,b3a <vprintf+0x268>
          putc(fd, *s);
 b18:	855a                	mv	a0,s6
 b1a:	cf3ff0ef          	jal	80c <putc>
        for(; *s; s++)
 b1e:	0905                	add	s2,s2,1
 b20:	00094583          	lbu	a1,0(s2)
 b24:	f9f5                	bnez	a1,b18 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b26:	8bce                	mv	s7,s3
      state = 0;
 b28:	4981                	li	s3,0
 b2a:	bbd5                	j	91e <vprintf+0x4c>
          s = "(null)";
 b2c:	00000917          	auipc	s2,0x0
 b30:	33490913          	add	s2,s2,820 # e60 <malloc+0x226>
        for(; *s; s++)
 b34:	02800593          	li	a1,40
 b38:	b7c5                	j	b18 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b3a:	8bce                	mv	s7,s3
      state = 0;
 b3c:	4981                	li	s3,0
 b3e:	b3c5                	j	91e <vprintf+0x4c>
    }
  }
}
 b40:	60e6                	ld	ra,88(sp)
 b42:	6446                	ld	s0,80(sp)
 b44:	64a6                	ld	s1,72(sp)
 b46:	6906                	ld	s2,64(sp)
 b48:	79e2                	ld	s3,56(sp)
 b4a:	7a42                	ld	s4,48(sp)
 b4c:	7aa2                	ld	s5,40(sp)
 b4e:	7b02                	ld	s6,32(sp)
 b50:	6be2                	ld	s7,24(sp)
 b52:	6c42                	ld	s8,16(sp)
 b54:	6ca2                	ld	s9,8(sp)
 b56:	6d02                	ld	s10,0(sp)
 b58:	6125                	add	sp,sp,96
 b5a:	8082                	ret

0000000000000b5c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b5c:	715d                	add	sp,sp,-80
 b5e:	ec06                	sd	ra,24(sp)
 b60:	e822                	sd	s0,16(sp)
 b62:	1000                	add	s0,sp,32
 b64:	e010                	sd	a2,0(s0)
 b66:	e414                	sd	a3,8(s0)
 b68:	e818                	sd	a4,16(s0)
 b6a:	ec1c                	sd	a5,24(s0)
 b6c:	03043023          	sd	a6,32(s0)
 b70:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b74:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b78:	8622                	mv	a2,s0
 b7a:	d59ff0ef          	jal	8d2 <vprintf>
}
 b7e:	60e2                	ld	ra,24(sp)
 b80:	6442                	ld	s0,16(sp)
 b82:	6161                	add	sp,sp,80
 b84:	8082                	ret

0000000000000b86 <printf>:

void
printf(const char *fmt, ...)
{
 b86:	711d                	add	sp,sp,-96
 b88:	ec06                	sd	ra,24(sp)
 b8a:	e822                	sd	s0,16(sp)
 b8c:	1000                	add	s0,sp,32
 b8e:	e40c                	sd	a1,8(s0)
 b90:	e810                	sd	a2,16(s0)
 b92:	ec14                	sd	a3,24(s0)
 b94:	f018                	sd	a4,32(s0)
 b96:	f41c                	sd	a5,40(s0)
 b98:	03043823          	sd	a6,48(s0)
 b9c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ba0:	00840613          	add	a2,s0,8
 ba4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ba8:	85aa                	mv	a1,a0
 baa:	4505                	li	a0,1
 bac:	d27ff0ef          	jal	8d2 <vprintf>
}
 bb0:	60e2                	ld	ra,24(sp)
 bb2:	6442                	ld	s0,16(sp)
 bb4:	6125                	add	sp,sp,96
 bb6:	8082                	ret

0000000000000bb8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bb8:	1141                	add	sp,sp,-16
 bba:	e422                	sd	s0,8(sp)
 bbc:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bbe:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc2:	00000797          	auipc	a5,0x0
 bc6:	44e7b783          	ld	a5,1102(a5) # 1010 <freep>
 bca:	a02d                	j	bf4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 bcc:	4618                	lw	a4,8(a2)
 bce:	9f2d                	addw	a4,a4,a1
 bd0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 bd4:	6398                	ld	a4,0(a5)
 bd6:	6310                	ld	a2,0(a4)
 bd8:	a83d                	j	c16 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 bda:	ff852703          	lw	a4,-8(a0)
 bde:	9f31                	addw	a4,a4,a2
 be0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 be2:	ff053683          	ld	a3,-16(a0)
 be6:	a091                	j	c2a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 be8:	6398                	ld	a4,0(a5)
 bea:	00e7e463          	bltu	a5,a4,bf2 <free+0x3a>
 bee:	00e6ea63          	bltu	a3,a4,c02 <free+0x4a>
{
 bf2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bf4:	fed7fae3          	bgeu	a5,a3,be8 <free+0x30>
 bf8:	6398                	ld	a4,0(a5)
 bfa:	00e6e463          	bltu	a3,a4,c02 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bfe:	fee7eae3          	bltu	a5,a4,bf2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 c02:	ff852583          	lw	a1,-8(a0)
 c06:	6390                	ld	a2,0(a5)
 c08:	02059813          	sll	a6,a1,0x20
 c0c:	01c85713          	srl	a4,a6,0x1c
 c10:	9736                	add	a4,a4,a3
 c12:	fae60de3          	beq	a2,a4,bcc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 c16:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c1a:	4790                	lw	a2,8(a5)
 c1c:	02061593          	sll	a1,a2,0x20
 c20:	01c5d713          	srl	a4,a1,0x1c
 c24:	973e                	add	a4,a4,a5
 c26:	fae68ae3          	beq	a3,a4,bda <free+0x22>
    p->s.ptr = bp->s.ptr;
 c2a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c2c:	00000717          	auipc	a4,0x0
 c30:	3ef73223          	sd	a5,996(a4) # 1010 <freep>
}
 c34:	6422                	ld	s0,8(sp)
 c36:	0141                	add	sp,sp,16
 c38:	8082                	ret

0000000000000c3a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c3a:	7139                	add	sp,sp,-64
 c3c:	fc06                	sd	ra,56(sp)
 c3e:	f822                	sd	s0,48(sp)
 c40:	f426                	sd	s1,40(sp)
 c42:	f04a                	sd	s2,32(sp)
 c44:	ec4e                	sd	s3,24(sp)
 c46:	e852                	sd	s4,16(sp)
 c48:	e456                	sd	s5,8(sp)
 c4a:	e05a                	sd	s6,0(sp)
 c4c:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c4e:	02051493          	sll	s1,a0,0x20
 c52:	9081                	srl	s1,s1,0x20
 c54:	04bd                	add	s1,s1,15
 c56:	8091                	srl	s1,s1,0x4
 c58:	0014899b          	addw	s3,s1,1
 c5c:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 c5e:	00000517          	auipc	a0,0x0
 c62:	3b253503          	ld	a0,946(a0) # 1010 <freep>
 c66:	c515                	beqz	a0,c92 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c68:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c6a:	4798                	lw	a4,8(a5)
 c6c:	02977f63          	bgeu	a4,s1,caa <malloc+0x70>
  if(nu < 4096)
 c70:	8a4e                	mv	s4,s3
 c72:	0009871b          	sext.w	a4,s3
 c76:	6685                	lui	a3,0x1
 c78:	00d77363          	bgeu	a4,a3,c7e <malloc+0x44>
 c7c:	6a05                	lui	s4,0x1
 c7e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c82:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c86:	00000917          	auipc	s2,0x0
 c8a:	38a90913          	add	s2,s2,906 # 1010 <freep>
  if(p == (char*)-1)
 c8e:	5afd                	li	s5,-1
 c90:	a885                	j	d00 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 c92:	00000797          	auipc	a5,0x0
 c96:	38e78793          	add	a5,a5,910 # 1020 <base>
 c9a:	00000717          	auipc	a4,0x0
 c9e:	36f73b23          	sd	a5,886(a4) # 1010 <freep>
 ca2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ca4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ca8:	b7e1                	j	c70 <malloc+0x36>
      if(p->s.size == nunits)
 caa:	02e48c63          	beq	s1,a4,ce2 <malloc+0xa8>
        p->s.size -= nunits;
 cae:	4137073b          	subw	a4,a4,s3
 cb2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cb4:	02071693          	sll	a3,a4,0x20
 cb8:	01c6d713          	srl	a4,a3,0x1c
 cbc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 cbe:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 cc2:	00000717          	auipc	a4,0x0
 cc6:	34a73723          	sd	a0,846(a4) # 1010 <freep>
      return (void*)(p + 1);
 cca:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 cce:	70e2                	ld	ra,56(sp)
 cd0:	7442                	ld	s0,48(sp)
 cd2:	74a2                	ld	s1,40(sp)
 cd4:	7902                	ld	s2,32(sp)
 cd6:	69e2                	ld	s3,24(sp)
 cd8:	6a42                	ld	s4,16(sp)
 cda:	6aa2                	ld	s5,8(sp)
 cdc:	6b02                	ld	s6,0(sp)
 cde:	6121                	add	sp,sp,64
 ce0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 ce2:	6398                	ld	a4,0(a5)
 ce4:	e118                	sd	a4,0(a0)
 ce6:	bff1                	j	cc2 <malloc+0x88>
  hp->s.size = nu;
 ce8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cec:	0541                	add	a0,a0,16
 cee:	ecbff0ef          	jal	bb8 <free>
  return freep;
 cf2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cf6:	dd61                	beqz	a0,cce <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cf8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cfa:	4798                	lw	a4,8(a5)
 cfc:	fa9777e3          	bgeu	a4,s1,caa <malloc+0x70>
    if(p == freep)
 d00:	00093703          	ld	a4,0(s2)
 d04:	853e                	mv	a0,a5
 d06:	fef719e3          	bne	a4,a5,cf8 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 d0a:	8552                	mv	a0,s4
 d0c:	aa9ff0ef          	jal	7b4 <sbrk>
  if(p == (char*)-1)
 d10:	fd551ce3          	bne	a0,s5,ce8 <malloc+0xae>
        return 0;
 d14:	4501                	li	a0,0
 d16:	bf65                	j	cce <malloc+0x94>
