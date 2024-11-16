
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
  ac:	84ae                	mv	s1,a1
    int pid = getpid();
  ae:	70c000ef          	jal	7ba <getpid>
  b2:	85aa                	mv	a1,a0

    set_type(IO_BOUND, pid);
  b4:	450d                	li	a0,3
  b6:	764000ef          	jal	81a <set_type>
    int t0, t1;
    int total_eficiencia = 0, total_overhead = 0;


    int index = 0;
    index += (argv[1][0] - '0') * 10;
  ba:	6498                	ld	a4,8(s1)
  bc:	00074783          	lbu	a5,0(a4) # ffffffff80000000 <base+0xffffffff7fffefe0>
  c0:	fd07879b          	addw	a5,a5,-48
  c4:	00279c9b          	sllw	s9,a5,0x2
  c8:	00fc8cbb          	addw	s9,s9,a5
  cc:	001c9c9b          	sllw	s9,s9,0x1
    index += (argv[1][1] - '0');
  d0:	00174783          	lbu	a5,1(a4)
  d4:	fd07879b          	addw	a5,a5,-48
  d8:	00fc8cbb          	addw	s9,s9,a5

    int fd;
    char filename[20] = "iobound";
  dc:	00001797          	auipc	a5,0x1
  e0:	d7c7b783          	ld	a5,-644(a5) # e58 <malloc+0x208>
  e4:	f8f43423          	sd	a5,-120(s0)
  e8:	f8043823          	sd	zero,-112(s0)
  ec:	f8042c23          	sw	zero,-104(s0)
    char pid_str[10];
    char *suffix = ".txt";

    pid = getpid();
  f0:	6ca000ef          	jal	7ba <getpid>

    pid += 1000; //valores baixos dão problema
  f4:	3e85071b          	addw	a4,a0,1000

    int i = 0;
  f8:	f7840693          	add	a3,s0,-136
    pid += 1000; //valores baixos dão problema
  fc:	8636                	mv	a2,a3
    int i = 0;
  fe:	4781                	li	a5,0
    do {
        pid_str[i++] = pid % 10 + '0';   // próximo digito
 100:	4829                	li	a6,10
    } while ((pid /= 10) > 0);
 102:	48a5                	li	a7,9
        pid_str[i++] = pid % 10 + '0';   // próximo digito
 104:	85be                	mv	a1,a5
 106:	2785                	addw	a5,a5,1
 108:	0307653b          	remw	a0,a4,a6
 10c:	0305051b          	addw	a0,a0,48
 110:	00a60023          	sb	a0,0(a2)
    } while ((pid /= 10) > 0);
 114:	853a                	mv	a0,a4
 116:	0307473b          	divw	a4,a4,a6
 11a:	0605                	add	a2,a2,1
 11c:	fea8c4e3          	blt	a7,a0,104 <main+0x90>
    pid_str[i] = '\0';
 120:	fa078793          	add	a5,a5,-96
 124:	97a2                	add	a5,a5,s0
 126:	fc078c23          	sb	zero,-40(a5)

    int j;
    char temp;
    for (j = 0, i--; j < i; j++, i--) {
 12a:	16b05d63          	blez	a1,2a4 <main+0x230>
 12e:	f7840793          	add	a5,s0,-136
 132:	97ae                	add	a5,a5,a1
 134:	4701                	li	a4,0
        temp = pid_str[j];
 136:	0006c603          	lbu	a2,0(a3)
        pid_str[j] = pid_str[i];
 13a:	0007c503          	lbu	a0,0(a5)
 13e:	00a68023          	sb	a0,0(a3)
        pid_str[i] = temp;
 142:	00c78023          	sb	a2,0(a5)
    for (j = 0, i--; j < i; j++, i--) {
 146:	0017061b          	addw	a2,a4,1
 14a:	0006071b          	sext.w	a4,a2
 14e:	0685                	add	a3,a3,1
 150:	17fd                	add	a5,a5,-1
 152:	40c5863b          	subw	a2,a1,a2
 156:	fec740e3          	blt	a4,a2,136 <main+0xc2>
    }

    i = 7;
    while (pid_str[j] != '\0') {
 15a:	fa070793          	add	a5,a4,-96
 15e:	97a2                	add	a5,a5,s0
 160:	fd87c603          	lbu	a2,-40(a5)
 164:	14060263          	beqz	a2,2a8 <main+0x234>
 168:	46a1                	li	a3,8
        filename[i++] = pid_str[j++];
 16a:	f8840793          	add	a5,s0,-120
 16e:	97b6                	add	a5,a5,a3
 170:	fec78fa3          	sb	a2,-1(a5)
    while (pid_str[j] != '\0') {
 174:	87b6                	mv	a5,a3
 176:	0685                	add	a3,a3,1
 178:	00d70633          	add	a2,a4,a3
 17c:	f7840593          	add	a1,s0,-136
 180:	962e                	add	a2,a2,a1
 182:	ff864603          	lbu	a2,-8(a2)
 186:	f275                	bnez	a2,16a <main+0xf6>
        filename[i++] = pid_str[j++];
 188:	2781                	sext.w	a5,a5
    }
    j = 0;
    while (suffix[j] != '\0') {
 18a:	2785                	addw	a5,a5,1
 18c:	00001617          	auipc	a2,0x1
 190:	ba560613          	add	a2,a2,-1115 # d31 <malloc+0xe1>
 194:	02e00693          	li	a3,46
        filename[i++] = suffix[j++];
 198:	f8840713          	add	a4,s0,-120
 19c:	973e                	add	a4,a4,a5
 19e:	fed70fa3          	sb	a3,-1(a4)
    while (suffix[j] != '\0') {
 1a2:	00064683          	lbu	a3,0(a2)
 1a6:	873e                	mv	a4,a5
 1a8:	0785                	add	a5,a5,1
 1aa:	0605                	add	a2,a2,1
 1ac:	f6f5                	bnez	a3,198 <main+0x124>
    }
    filename[i] = '\0';
 1ae:	0007079b          	sext.w	a5,a4
 1b2:	fa078793          	add	a5,a5,-96
 1b6:	97a2                	add	a5,a5,s0
 1b8:	fe078423          	sb	zero,-24(a5)

    t0 = uptime_nolock();
 1bc:	656000ef          	jal	812 <uptime_nolock>
 1c0:	8baa                	mv	s7,a0
    fd = open(filename, O_CREATE | O_RDWR);
 1c2:	20200593          	li	a1,514
 1c6:	f8840513          	add	a0,s0,-120
 1ca:	5b0000ef          	jal	77a <open>
 1ce:	8c2a                	mv	s8,a0
    t1 = uptime_nolock();
 1d0:	642000ef          	jal	812 <uptime_nolock>
    total_overhead += t1 - t0;
 1d4:	41750bbb          	subw	s7,a0,s7

    if (fd < 0){
 1d8:	0c0c4a63          	bltz	s8,2ac <main+0x238>
    }

    char *caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$&*()";

    char linha[101];
    linha[100] = '\n';
 1dc:	47a9                	li	a5,10
 1de:	f6f40a23          	sb	a5,-140(s0)
 1e2:	06400b13          	li	s6,100
    int total_eficiencia = 0, total_overhead = 0;
 1e6:	4a81                	li	s5,0
 1e8:	f7440a13          	add	s4,s0,-140
    int size = 101;
    for(i=0;i<100;i++){ //lines
        for(int j=0;j<100;j++){ //characters
            int c = rand() % 70;
 1ec:	04600993          	li	s3,70
            linha[j] = caracteres[c];
 1f0:	00001917          	auipc	s2,0x1
 1f4:	b6890913          	add	s2,s2,-1176 # d58 <malloc+0x108>
        for(int j=0;j<100;j++){ //characters
 1f8:	f1040493          	add	s1,s0,-240
            int c = rand() % 70;
 1fc:	e5dff0ef          	jal	58 <rand>
            linha[j] = caracteres[c];
 200:	0335653b          	remw	a0,a0,s3
 204:	954a                	add	a0,a0,s2
 206:	00054783          	lbu	a5,0(a0)
 20a:	00f48023          	sb	a5,0(s1)
        for(int j=0;j<100;j++){ //characters
 20e:	0485                	add	s1,s1,1
 210:	fe9a16e3          	bne	s4,s1,1fc <main+0x188>
        }
        t0 = uptime_nolock();
 214:	5fe000ef          	jal	812 <uptime_nolock>
 218:	84aa                	mv	s1,a0
        if(write(fd, linha, size) != size){
 21a:	06500613          	li	a2,101
 21e:	f1040593          	add	a1,s0,-240
 222:	8562                	mv	a0,s8
 224:	536000ef          	jal	75a <write>
 228:	06500793          	li	a5,101
 22c:	08f51963          	bne	a0,a5,2be <main+0x24a>
            printf("error, write failed\n");
            exit(1);
        } else {  //wrote succesfully
            t1 = uptime_nolock();
 230:	5e2000ef          	jal	812 <uptime_nolock>
            total_eficiencia += t1 - t0;
 234:	9d05                	subw	a0,a0,s1
 236:	01550abb          	addw	s5,a0,s5
    for(i=0;i<100;i++){ //lines
 23a:	3b7d                	addw	s6,s6,-1
 23c:	fa0b1ee3          	bnez	s6,1f8 <main+0x184>
        }
    }
    close(fd);
 240:	8562                	mv	a0,s8
 242:	520000ef          	jal	762 <close>



    char *linhas[100];
    for (int j = 0; j < 100; j++) {
 246:	bf040993          	add	s3,s0,-1040
 24a:	f1040a13          	add	s4,s0,-240
    close(fd);
 24e:	894e                	mv	s2,s3
        t0 = uptime_nolock();
 250:	5c2000ef          	jal	812 <uptime_nolock>
 254:	84aa                	mv	s1,a0
        linhas[j] = malloc(102 * sizeof(char)); // allocate memory for each string
 256:	06600513          	li	a0,102
 25a:	1f7000ef          	jal	c50 <malloc>
 25e:	00a93023          	sd	a0,0(s2)
        t1 = uptime_nolock();
 262:	5b0000ef          	jal	812 <uptime_nolock>
        total_overhead += t1 - t0;
 266:	409504bb          	subw	s1,a0,s1
 26a:	017484bb          	addw	s1,s1,s7
 26e:	00048b9b          	sext.w	s7,s1
    for (int j = 0; j < 100; j++) {
 272:	0921                	add	s2,s2,8
 274:	fd2a1ee3          	bne	s4,s2,250 <main+0x1dc>
    }

    t0 = uptime_nolock();
 278:	59a000ef          	jal	812 <uptime_nolock>
 27c:	892a                	mv	s2,a0
    fd = open(filename, O_RDONLY);
 27e:	4581                	li	a1,0
 280:	f8840513          	add	a0,s0,-120
 284:	4f6000ef          	jal	77a <open>
 288:	8b2a                	mv	s6,a0
    t1 = uptime_nolock();
 28a:	588000ef          	jal	812 <uptime_nolock>
    total_overhead += t1 - t0;
 28e:	4125093b          	subw	s2,a0,s2
 292:	0099093b          	addw	s2,s2,s1
    if (fd < 0) {
 296:	020b4d63          	bltz	s6,2d0 <main+0x25c>
    }

    char buf[101];
    int n;
    i = 0;
    t0 = uptime_nolock();
 29a:	578000ef          	jal	812 <uptime_nolock>
 29e:	84aa                	mv	s1,a0
    while((n = read(fd, buf, sizeof(buf))) > 0) {
 2a0:	8bce                	mv	s7,s3
 2a2:	a095                	j	306 <main+0x292>
    for (j = 0, i--; j < i; j++, i--) {
 2a4:	4701                	li	a4,0
 2a6:	bd55                	j	15a <main+0xe6>
    i = 7;
 2a8:	479d                	li	a5,7
 2aa:	b5c5                	j	18a <main+0x116>
        printf("erro ao criar o arquivo %s\n", filename);
 2ac:	f8840593          	add	a1,s0,-120
 2b0:	00001517          	auipc	a0,0x1
 2b4:	a8850513          	add	a0,a0,-1400 # d38 <malloc+0xe8>
 2b8:	0e5000ef          	jal	b9c <printf>
 2bc:	b705                	j	1dc <main+0x168>
            printf("error, write failed\n");
 2be:	00001517          	auipc	a0,0x1
 2c2:	ae250513          	add	a0,a0,-1310 # da0 <malloc+0x150>
 2c6:	0d7000ef          	jal	b9c <printf>
            exit(1);
 2ca:	4505                	li	a0,1
 2cc:	46e000ef          	jal	73a <exit>
        printf("Erro ao abrir o arquivo %s\n", filename);
 2d0:	f8840593          	add	a1,s0,-120
 2d4:	00001517          	auipc	a0,0x1
 2d8:	ae450513          	add	a0,a0,-1308 # db8 <malloc+0x168>
 2dc:	0c1000ef          	jal	b9c <printf>
        exit(1);
 2e0:	4505                	li	a0,1
 2e2:	458000ef          	jal	73a <exit>
        t1 = uptime_nolock();
 2e6:	52c000ef          	jal	812 <uptime_nolock>
        total_eficiencia += t1 - t0;
 2ea:	409507bb          	subw	a5,a0,s1
 2ee:	01578abb          	addw	s5,a5,s5
        strcpy(linhas[i], buf);
 2f2:	b8840593          	add	a1,s0,-1144
 2f6:	000bb503          	ld	a0,0(s7)
 2fa:	1e8000ef          	jal	4e2 <strcpy>
        i++;
        t0 = uptime_nolock();
 2fe:	514000ef          	jal	812 <uptime_nolock>
 302:	84aa                	mv	s1,a0
 304:	0ba1                	add	s7,s7,8
    while((n = read(fd, buf, sizeof(buf))) > 0) {
 306:	06500613          	li	a2,101
 30a:	b8840593          	add	a1,s0,-1144
 30e:	855a                	mv	a0,s6
 310:	442000ef          	jal	752 <read>
 314:	fca049e3          	bgtz	a0,2e6 <main+0x272>
    }

    close(fd);
 318:	855a                	mv	a0,s6
 31a:	448000ef          	jal	762 <close>


    char *tmp;
    t0 = uptime_nolock();
 31e:	4f4000ef          	jal	812 <uptime_nolock>
 322:	8d2a                	mv	s10,a0
    tmp = malloc(102*sizeof(char));
 324:	06600513          	li	a0,102
 328:	129000ef          	jal	c50 <malloc>
 32c:	8baa                	mv	s7,a0
    t1 = uptime_nolock();
 32e:	4e4000ef          	jal	812 <uptime_nolock>
    total_overhead += t1 - t0;
 332:	41a50d3b          	subw	s10,a0,s10
 336:	012d0d3b          	addw	s10,s10,s2
 33a:	03200b13          	li	s6,50

    for (i = 0; i < 50; i++){
        //getting random rows
        int row1 = rand() % 100;
 33e:	06400c13          	li	s8,100
 342:	d17ff0ef          	jal	58 <rand>
 346:	892a                	mv	s2,a0
        int row2 = rand() % 100;
 348:	d11ff0ef          	jal	58 <rand>
 34c:	84aa                	mv	s1,a0

        //swapping them
        strcpy(tmp, linhas[row1]);
 34e:	038967bb          	remw	a5,s2,s8
 352:	078e                	sll	a5,a5,0x3
 354:	fa078793          	add	a5,a5,-96
 358:	97a2                	add	a5,a5,s0
 35a:	c507b903          	ld	s2,-944(a5)
 35e:	85ca                	mv	a1,s2
 360:	855e                	mv	a0,s7
 362:	180000ef          	jal	4e2 <strcpy>
        strcpy(linhas[row1], linhas[row2]);
 366:	0384e7bb          	remw	a5,s1,s8
 36a:	078e                	sll	a5,a5,0x3
 36c:	fa078793          	add	a5,a5,-96
 370:	97a2                	add	a5,a5,s0
 372:	c507b483          	ld	s1,-944(a5)
 376:	85a6                	mv	a1,s1
 378:	854a                	mv	a0,s2
 37a:	168000ef          	jal	4e2 <strcpy>
        strcpy(linhas[row2], tmp);
 37e:	85de                	mv	a1,s7
 380:	8526                	mv	a0,s1
 382:	160000ef          	jal	4e2 <strcpy>
    for (i = 0; i < 50; i++){
 386:	3b7d                	addw	s6,s6,-1
 388:	fa0b1de3          	bnez	s6,342 <main+0x2ce>
    }
    t0 = uptime_nolock();
 38c:	486000ef          	jal	812 <uptime_nolock>
 390:	84aa                	mv	s1,a0
    free(tmp);
 392:	855e                	mv	a0,s7
 394:	03b000ef          	jal	bce <free>
    t1 = uptime_nolock();
 398:	47a000ef          	jal	812 <uptime_nolock>
    total_overhead += t1 - t0;
 39c:	409504bb          	subw	s1,a0,s1
 3a0:	01a484bb          	addw	s1,s1,s10

    //rewriting file after permutations
    t0 = uptime_nolock();
 3a4:	46e000ef          	jal	812 <uptime_nolock>
 3a8:	892a                	mv	s2,a0
    fd = open(filename, O_RDWR);
 3aa:	4589                	li	a1,2
 3ac:	f8840513          	add	a0,s0,-120
 3b0:	3ca000ef          	jal	77a <open>
 3b4:	8baa                	mv	s7,a0
    t1 = uptime_nolock();
 3b6:	45c000ef          	jal	812 <uptime_nolock>
    total_overhead += t1 - t0;
 3ba:	4125093b          	subw	s2,a0,s2
 3be:	0099093b          	addw	s2,s2,s1
    if (fd < 0) {
 3c2:	8b4e                	mv	s6,s3
 3c4:	0c0bc963          	bltz	s7,496 <main+0x422>
        exit(1);
    }

    size = 101;
    for (int i = 0; i < 100; i++){
        t0 = uptime_nolock();
 3c8:	44a000ef          	jal	812 <uptime_nolock>
 3cc:	84aa                	mv	s1,a0
        if(write(fd, linhas[i], size) != size){
 3ce:	06500613          	li	a2,101
 3d2:	000b3583          	ld	a1,0(s6)
 3d6:	855e                	mv	a0,s7
 3d8:	382000ef          	jal	75a <write>
 3dc:	06500793          	li	a5,101
 3e0:	0cf51663          	bne	a0,a5,4ac <main+0x438>
            printf("error, write permut failed\n");
            exit(1);
        } else {
            t1 = uptime_nolock();
 3e4:	42e000ef          	jal	812 <uptime_nolock>
            total_eficiencia += t1 - t0;
 3e8:	409504bb          	subw	s1,a0,s1
 3ec:	015484bb          	addw	s1,s1,s5
 3f0:	00048a9b          	sext.w	s5,s1
    for (int i = 0; i < 100; i++){
 3f4:	0b21                	add	s6,s6,8
 3f6:	fd6a19e3          	bne	s4,s6,3c8 <main+0x354>
        }
    }

    close(fd);
 3fa:	855e                	mv	a0,s7
 3fc:	366000ef          	jal	762 <close>

    //removing file
    t0 = uptime_nolock();
 400:	412000ef          	jal	812 <uptime_nolock>
 404:	8aaa                	mv	s5,a0
    if (unlink(filename) < 0){
 406:	f8840513          	add	a0,s0,-120
 40a:	380000ef          	jal	78a <unlink>
 40e:	0a054863          	bltz	a0,4be <main+0x44a>
        printf("Erro ao remover o arquivo\n");
        exit(1);
    } else {
        t1 = uptime_nolock();
 412:	400000ef          	jal	812 <uptime_nolock>
        total_eficiencia += t1 - t0;
 416:	41550abb          	subw	s5,a0,s5
 41a:	009a8abb          	addw	s5,s5,s1
    }


    //free malloc for linhas
    for (int j = 0; j < 100; j++) {
        t0 = uptime_nolock();
 41e:	3f4000ef          	jal	812 <uptime_nolock>
 422:	84aa                	mv	s1,a0
        free(linhas[j]);
 424:	0009b503          	ld	a0,0(s3)
 428:	7a6000ef          	jal	bce <free>
        t1 = uptime_nolock();
 42c:	3e6000ef          	jal	812 <uptime_nolock>
        total_overhead += t1 - t0;
 430:	409507bb          	subw	a5,a0,s1
 434:	0127893b          	addw	s2,a5,s2
    for (int j = 0; j < 100; j++) {
 438:	09a1                	add	s3,s3,8
 43a:	ff3a12e3          	bne	s4,s3,41e <main+0x3aa>
    }


    increment_metric(index, total_eficiencia, MODE_EFICIENCIA);
 43e:	4629                	li	a2,10
 440:	85d6                	mv	a1,s5
 442:	8566                	mv	a0,s9
 444:	3ae000ef          	jal	7f2 <increment_metric>
    increment_metric(index, total_overhead, MODE_OVERHEAD);
 448:	4621                	li	a2,8
 44a:	85ca                	mv	a1,s2
 44c:	8566                	mv	a0,s9
 44e:	3a4000ef          	jal	7f2 <increment_metric>

    pid = getpid();
 452:	368000ef          	jal	7ba <getpid>
 456:	85aa                	mv	a1,a0
    set_justica(index, pid);
 458:	8566                	mv	a0,s9
 45a:	3b0000ef          	jal	80a <set_justica>

    return 0;
 45e:	4501                	li	a0,0
 460:	47813083          	ld	ra,1144(sp)
 464:	47013403          	ld	s0,1136(sp)
 468:	46813483          	ld	s1,1128(sp)
 46c:	46013903          	ld	s2,1120(sp)
 470:	45813983          	ld	s3,1112(sp)
 474:	45013a03          	ld	s4,1104(sp)
 478:	44813a83          	ld	s5,1096(sp)
 47c:	44013b03          	ld	s6,1088(sp)
 480:	43813b83          	ld	s7,1080(sp)
 484:	43013c03          	ld	s8,1072(sp)
 488:	42813c83          	ld	s9,1064(sp)
 48c:	42013d03          	ld	s10,1056(sp)
 490:	48010113          	add	sp,sp,1152
 494:	8082                	ret
        printf("Erro ao reabrir o arquivo %s para escrever as permutações\n", filename);
 496:	f8840593          	add	a1,s0,-120
 49a:	00001517          	auipc	a0,0x1
 49e:	93e50513          	add	a0,a0,-1730 # dd8 <malloc+0x188>
 4a2:	6fa000ef          	jal	b9c <printf>
        exit(1);
 4a6:	4505                	li	a0,1
 4a8:	292000ef          	jal	73a <exit>
            printf("error, write permut failed\n");
 4ac:	00001517          	auipc	a0,0x1
 4b0:	96c50513          	add	a0,a0,-1684 # e18 <malloc+0x1c8>
 4b4:	6e8000ef          	jal	b9c <printf>
            exit(1);
 4b8:	4505                	li	a0,1
 4ba:	280000ef          	jal	73a <exit>
        printf("Erro ao remover o arquivo\n");
 4be:	00001517          	auipc	a0,0x1
 4c2:	97a50513          	add	a0,a0,-1670 # e38 <malloc+0x1e8>
 4c6:	6d6000ef          	jal	b9c <printf>
        exit(1);
 4ca:	4505                	li	a0,1
 4cc:	26e000ef          	jal	73a <exit>

00000000000004d0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 4d0:	1141                	add	sp,sp,-16
 4d2:	e406                	sd	ra,8(sp)
 4d4:	e022                	sd	s0,0(sp)
 4d6:	0800                	add	s0,sp,16
  extern int main();
  main();
 4d8:	b9dff0ef          	jal	74 <main>
  exit(0);
 4dc:	4501                	li	a0,0
 4de:	25c000ef          	jal	73a <exit>

00000000000004e2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 4e2:	1141                	add	sp,sp,-16
 4e4:	e422                	sd	s0,8(sp)
 4e6:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4e8:	87aa                	mv	a5,a0
 4ea:	0585                	add	a1,a1,1
 4ec:	0785                	add	a5,a5,1
 4ee:	fff5c703          	lbu	a4,-1(a1)
 4f2:	fee78fa3          	sb	a4,-1(a5)
 4f6:	fb75                	bnez	a4,4ea <strcpy+0x8>
    ;
  return os;
}
 4f8:	6422                	ld	s0,8(sp)
 4fa:	0141                	add	sp,sp,16
 4fc:	8082                	ret

00000000000004fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4fe:	1141                	add	sp,sp,-16
 500:	e422                	sd	s0,8(sp)
 502:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 504:	00054783          	lbu	a5,0(a0)
 508:	cb91                	beqz	a5,51c <strcmp+0x1e>
 50a:	0005c703          	lbu	a4,0(a1)
 50e:	00f71763          	bne	a4,a5,51c <strcmp+0x1e>
    p++, q++;
 512:	0505                	add	a0,a0,1
 514:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 516:	00054783          	lbu	a5,0(a0)
 51a:	fbe5                	bnez	a5,50a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 51c:	0005c503          	lbu	a0,0(a1)
}
 520:	40a7853b          	subw	a0,a5,a0
 524:	6422                	ld	s0,8(sp)
 526:	0141                	add	sp,sp,16
 528:	8082                	ret

000000000000052a <strlen>:

uint
strlen(const char *s)
{
 52a:	1141                	add	sp,sp,-16
 52c:	e422                	sd	s0,8(sp)
 52e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 530:	00054783          	lbu	a5,0(a0)
 534:	cf91                	beqz	a5,550 <strlen+0x26>
 536:	0505                	add	a0,a0,1
 538:	87aa                	mv	a5,a0
 53a:	86be                	mv	a3,a5
 53c:	0785                	add	a5,a5,1
 53e:	fff7c703          	lbu	a4,-1(a5)
 542:	ff65                	bnez	a4,53a <strlen+0x10>
 544:	40a6853b          	subw	a0,a3,a0
 548:	2505                	addw	a0,a0,1
    ;
  return n;
}
 54a:	6422                	ld	s0,8(sp)
 54c:	0141                	add	sp,sp,16
 54e:	8082                	ret
  for(n = 0; s[n]; n++)
 550:	4501                	li	a0,0
 552:	bfe5                	j	54a <strlen+0x20>

0000000000000554 <memset>:

void*
memset(void *dst, int c, uint n)
{
 554:	1141                	add	sp,sp,-16
 556:	e422                	sd	s0,8(sp)
 558:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 55a:	ca19                	beqz	a2,570 <memset+0x1c>
 55c:	87aa                	mv	a5,a0
 55e:	1602                	sll	a2,a2,0x20
 560:	9201                	srl	a2,a2,0x20
 562:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 566:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 56a:	0785                	add	a5,a5,1
 56c:	fee79de3          	bne	a5,a4,566 <memset+0x12>
  }
  return dst;
}
 570:	6422                	ld	s0,8(sp)
 572:	0141                	add	sp,sp,16
 574:	8082                	ret

0000000000000576 <strchr>:

char*
strchr(const char *s, char c)
{
 576:	1141                	add	sp,sp,-16
 578:	e422                	sd	s0,8(sp)
 57a:	0800                	add	s0,sp,16
  for(; *s; s++)
 57c:	00054783          	lbu	a5,0(a0)
 580:	cb99                	beqz	a5,596 <strchr+0x20>
    if(*s == c)
 582:	00f58763          	beq	a1,a5,590 <strchr+0x1a>
  for(; *s; s++)
 586:	0505                	add	a0,a0,1
 588:	00054783          	lbu	a5,0(a0)
 58c:	fbfd                	bnez	a5,582 <strchr+0xc>
      return (char*)s;
  return 0;
 58e:	4501                	li	a0,0
}
 590:	6422                	ld	s0,8(sp)
 592:	0141                	add	sp,sp,16
 594:	8082                	ret
  return 0;
 596:	4501                	li	a0,0
 598:	bfe5                	j	590 <strchr+0x1a>

000000000000059a <gets>:

char*
gets(char *buf, int max)
{
 59a:	711d                	add	sp,sp,-96
 59c:	ec86                	sd	ra,88(sp)
 59e:	e8a2                	sd	s0,80(sp)
 5a0:	e4a6                	sd	s1,72(sp)
 5a2:	e0ca                	sd	s2,64(sp)
 5a4:	fc4e                	sd	s3,56(sp)
 5a6:	f852                	sd	s4,48(sp)
 5a8:	f456                	sd	s5,40(sp)
 5aa:	f05a                	sd	s6,32(sp)
 5ac:	ec5e                	sd	s7,24(sp)
 5ae:	1080                	add	s0,sp,96
 5b0:	8baa                	mv	s7,a0
 5b2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5b4:	892a                	mv	s2,a0
 5b6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5b8:	4aa9                	li	s5,10
 5ba:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5bc:	89a6                	mv	s3,s1
 5be:	2485                	addw	s1,s1,1
 5c0:	0344d663          	bge	s1,s4,5ec <gets+0x52>
    cc = read(0, &c, 1);
 5c4:	4605                	li	a2,1
 5c6:	faf40593          	add	a1,s0,-81
 5ca:	4501                	li	a0,0
 5cc:	186000ef          	jal	752 <read>
    if(cc < 1)
 5d0:	00a05e63          	blez	a0,5ec <gets+0x52>
    buf[i++] = c;
 5d4:	faf44783          	lbu	a5,-81(s0)
 5d8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5dc:	01578763          	beq	a5,s5,5ea <gets+0x50>
 5e0:	0905                	add	s2,s2,1
 5e2:	fd679de3          	bne	a5,s6,5bc <gets+0x22>
  for(i=0; i+1 < max; ){
 5e6:	89a6                	mv	s3,s1
 5e8:	a011                	j	5ec <gets+0x52>
 5ea:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5ec:	99de                	add	s3,s3,s7
 5ee:	00098023          	sb	zero,0(s3)
  return buf;
}
 5f2:	855e                	mv	a0,s7
 5f4:	60e6                	ld	ra,88(sp)
 5f6:	6446                	ld	s0,80(sp)
 5f8:	64a6                	ld	s1,72(sp)
 5fa:	6906                	ld	s2,64(sp)
 5fc:	79e2                	ld	s3,56(sp)
 5fe:	7a42                	ld	s4,48(sp)
 600:	7aa2                	ld	s5,40(sp)
 602:	7b02                	ld	s6,32(sp)
 604:	6be2                	ld	s7,24(sp)
 606:	6125                	add	sp,sp,96
 608:	8082                	ret

000000000000060a <stat>:

int
stat(const char *n, struct stat *st)
{
 60a:	1101                	add	sp,sp,-32
 60c:	ec06                	sd	ra,24(sp)
 60e:	e822                	sd	s0,16(sp)
 610:	e426                	sd	s1,8(sp)
 612:	e04a                	sd	s2,0(sp)
 614:	1000                	add	s0,sp,32
 616:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 618:	4581                	li	a1,0
 61a:	160000ef          	jal	77a <open>
  if(fd < 0)
 61e:	02054163          	bltz	a0,640 <stat+0x36>
 622:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 624:	85ca                	mv	a1,s2
 626:	16c000ef          	jal	792 <fstat>
 62a:	892a                	mv	s2,a0
  close(fd);
 62c:	8526                	mv	a0,s1
 62e:	134000ef          	jal	762 <close>
  return r;
}
 632:	854a                	mv	a0,s2
 634:	60e2                	ld	ra,24(sp)
 636:	6442                	ld	s0,16(sp)
 638:	64a2                	ld	s1,8(sp)
 63a:	6902                	ld	s2,0(sp)
 63c:	6105                	add	sp,sp,32
 63e:	8082                	ret
    return -1;
 640:	597d                	li	s2,-1
 642:	bfc5                	j	632 <stat+0x28>

0000000000000644 <atoi>:

int
atoi(const char *s)
{
 644:	1141                	add	sp,sp,-16
 646:	e422                	sd	s0,8(sp)
 648:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 64a:	00054683          	lbu	a3,0(a0)
 64e:	fd06879b          	addw	a5,a3,-48
 652:	0ff7f793          	zext.b	a5,a5
 656:	4625                	li	a2,9
 658:	02f66863          	bltu	a2,a5,688 <atoi+0x44>
 65c:	872a                	mv	a4,a0
  n = 0;
 65e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 660:	0705                	add	a4,a4,1
 662:	0025179b          	sllw	a5,a0,0x2
 666:	9fa9                	addw	a5,a5,a0
 668:	0017979b          	sllw	a5,a5,0x1
 66c:	9fb5                	addw	a5,a5,a3
 66e:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 672:	00074683          	lbu	a3,0(a4)
 676:	fd06879b          	addw	a5,a3,-48
 67a:	0ff7f793          	zext.b	a5,a5
 67e:	fef671e3          	bgeu	a2,a5,660 <atoi+0x1c>
  return n;
}
 682:	6422                	ld	s0,8(sp)
 684:	0141                	add	sp,sp,16
 686:	8082                	ret
  n = 0;
 688:	4501                	li	a0,0
 68a:	bfe5                	j	682 <atoi+0x3e>

000000000000068c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 68c:	1141                	add	sp,sp,-16
 68e:	e422                	sd	s0,8(sp)
 690:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 692:	02b57463          	bgeu	a0,a1,6ba <memmove+0x2e>
    while(n-- > 0)
 696:	00c05f63          	blez	a2,6b4 <memmove+0x28>
 69a:	1602                	sll	a2,a2,0x20
 69c:	9201                	srl	a2,a2,0x20
 69e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6a2:	872a                	mv	a4,a0
      *dst++ = *src++;
 6a4:	0585                	add	a1,a1,1
 6a6:	0705                	add	a4,a4,1
 6a8:	fff5c683          	lbu	a3,-1(a1)
 6ac:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6b0:	fee79ae3          	bne	a5,a4,6a4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6b4:	6422                	ld	s0,8(sp)
 6b6:	0141                	add	sp,sp,16
 6b8:	8082                	ret
    dst += n;
 6ba:	00c50733          	add	a4,a0,a2
    src += n;
 6be:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6c0:	fec05ae3          	blez	a2,6b4 <memmove+0x28>
 6c4:	fff6079b          	addw	a5,a2,-1
 6c8:	1782                	sll	a5,a5,0x20
 6ca:	9381                	srl	a5,a5,0x20
 6cc:	fff7c793          	not	a5,a5
 6d0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6d2:	15fd                	add	a1,a1,-1
 6d4:	177d                	add	a4,a4,-1
 6d6:	0005c683          	lbu	a3,0(a1)
 6da:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6de:	fee79ae3          	bne	a5,a4,6d2 <memmove+0x46>
 6e2:	bfc9                	j	6b4 <memmove+0x28>

00000000000006e4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6e4:	1141                	add	sp,sp,-16
 6e6:	e422                	sd	s0,8(sp)
 6e8:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6ea:	ca05                	beqz	a2,71a <memcmp+0x36>
 6ec:	fff6069b          	addw	a3,a2,-1
 6f0:	1682                	sll	a3,a3,0x20
 6f2:	9281                	srl	a3,a3,0x20
 6f4:	0685                	add	a3,a3,1
 6f6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6f8:	00054783          	lbu	a5,0(a0)
 6fc:	0005c703          	lbu	a4,0(a1)
 700:	00e79863          	bne	a5,a4,710 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 704:	0505                	add	a0,a0,1
    p2++;
 706:	0585                	add	a1,a1,1
  while (n-- > 0) {
 708:	fed518e3          	bne	a0,a3,6f8 <memcmp+0x14>
  }
  return 0;
 70c:	4501                	li	a0,0
 70e:	a019                	j	714 <memcmp+0x30>
      return *p1 - *p2;
 710:	40e7853b          	subw	a0,a5,a4
}
 714:	6422                	ld	s0,8(sp)
 716:	0141                	add	sp,sp,16
 718:	8082                	ret
  return 0;
 71a:	4501                	li	a0,0
 71c:	bfe5                	j	714 <memcmp+0x30>

000000000000071e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 71e:	1141                	add	sp,sp,-16
 720:	e406                	sd	ra,8(sp)
 722:	e022                	sd	s0,0(sp)
 724:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 726:	f67ff0ef          	jal	68c <memmove>
}
 72a:	60a2                	ld	ra,8(sp)
 72c:	6402                	ld	s0,0(sp)
 72e:	0141                	add	sp,sp,16
 730:	8082                	ret

0000000000000732 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 732:	4885                	li	a7,1
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <exit>:
.global exit
exit:
 li a7, SYS_exit
 73a:	4889                	li	a7,2
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <wait>:
.global wait
wait:
 li a7, SYS_wait
 742:	488d                	li	a7,3
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 74a:	4891                	li	a7,4
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <read>:
.global read
read:
 li a7, SYS_read
 752:	4895                	li	a7,5
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <write>:
.global write
write:
 li a7, SYS_write
 75a:	48c1                	li	a7,16
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <close>:
.global close
close:
 li a7, SYS_close
 762:	48d5                	li	a7,21
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <kill>:
.global kill
kill:
 li a7, SYS_kill
 76a:	4899                	li	a7,6
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <exec>:
.global exec
exec:
 li a7, SYS_exec
 772:	489d                	li	a7,7
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <open>:
.global open
open:
 li a7, SYS_open
 77a:	48bd                	li	a7,15
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 782:	48c5                	li	a7,17
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 78a:	48c9                	li	a7,18
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 792:	48a1                	li	a7,8
 ecall
 794:	00000073          	ecall
 ret
 798:	8082                	ret

000000000000079a <link>:
.global link
link:
 li a7, SYS_link
 79a:	48cd                	li	a7,19
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7a2:	48d1                	li	a7,20
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7aa:	48a5                	li	a7,9
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7b2:	48a9                	li	a7,10
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	8082                	ret

00000000000007ba <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7ba:	48ad                	li	a7,11
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7c2:	48b1                	li	a7,12
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7ca:	48b5                	li	a7,13
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7d2:	48b9                	li	a7,14
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	8082                	ret

00000000000007da <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 7da:	48d9                	li	a7,22
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 7e2:	48dd                	li	a7,23
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 7ea:	48e1                	li	a7,24
 ecall
 7ec:	00000073          	ecall
 ret
 7f0:	8082                	ret

00000000000007f2 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 7f2:	48e5                	li	a7,25
 ecall
 7f4:	00000073          	ecall
 ret
 7f8:	8082                	ret

00000000000007fa <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 7fa:	48e9                	li	a7,26
 ecall
 7fc:	00000073          	ecall
 ret
 800:	8082                	ret

0000000000000802 <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 802:	48ed                	li	a7,27
 ecall
 804:	00000073          	ecall
 ret
 808:	8082                	ret

000000000000080a <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 80a:	48f1                	li	a7,28
 ecall
 80c:	00000073          	ecall
 ret
 810:	8082                	ret

0000000000000812 <uptime_nolock>:
.global uptime_nolock
uptime_nolock:
 li a7, SYS_uptime_nolock
 812:	48f5                	li	a7,29
 ecall
 814:	00000073          	ecall
 ret
 818:	8082                	ret

000000000000081a <set_type>:
.global set_type
set_type:
 li a7, SYS_set_type
 81a:	48f9                	li	a7,30
 ecall
 81c:	00000073          	ecall
 ret
 820:	8082                	ret

0000000000000822 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 822:	1101                	add	sp,sp,-32
 824:	ec06                	sd	ra,24(sp)
 826:	e822                	sd	s0,16(sp)
 828:	1000                	add	s0,sp,32
 82a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 82e:	4605                	li	a2,1
 830:	fef40593          	add	a1,s0,-17
 834:	f27ff0ef          	jal	75a <write>
}
 838:	60e2                	ld	ra,24(sp)
 83a:	6442                	ld	s0,16(sp)
 83c:	6105                	add	sp,sp,32
 83e:	8082                	ret

0000000000000840 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 840:	7139                	add	sp,sp,-64
 842:	fc06                	sd	ra,56(sp)
 844:	f822                	sd	s0,48(sp)
 846:	f426                	sd	s1,40(sp)
 848:	f04a                	sd	s2,32(sp)
 84a:	ec4e                	sd	s3,24(sp)
 84c:	0080                	add	s0,sp,64
 84e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 850:	c299                	beqz	a3,856 <printint+0x16>
 852:	0805c763          	bltz	a1,8e0 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 856:	2581                	sext.w	a1,a1
  neg = 0;
 858:	4881                	li	a7,0
 85a:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 85e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 860:	2601                	sext.w	a2,a2
 862:	00000517          	auipc	a0,0x0
 866:	61650513          	add	a0,a0,1558 # e78 <digits>
 86a:	883a                	mv	a6,a4
 86c:	2705                	addw	a4,a4,1
 86e:	02c5f7bb          	remuw	a5,a1,a2
 872:	1782                	sll	a5,a5,0x20
 874:	9381                	srl	a5,a5,0x20
 876:	97aa                	add	a5,a5,a0
 878:	0007c783          	lbu	a5,0(a5)
 87c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 880:	0005879b          	sext.w	a5,a1
 884:	02c5d5bb          	divuw	a1,a1,a2
 888:	0685                	add	a3,a3,1
 88a:	fec7f0e3          	bgeu	a5,a2,86a <printint+0x2a>
  if(neg)
 88e:	00088c63          	beqz	a7,8a6 <printint+0x66>
    buf[i++] = '-';
 892:	fd070793          	add	a5,a4,-48
 896:	00878733          	add	a4,a5,s0
 89a:	02d00793          	li	a5,45
 89e:	fef70823          	sb	a5,-16(a4)
 8a2:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 8a6:	02e05663          	blez	a4,8d2 <printint+0x92>
 8aa:	fc040793          	add	a5,s0,-64
 8ae:	00e78933          	add	s2,a5,a4
 8b2:	fff78993          	add	s3,a5,-1
 8b6:	99ba                	add	s3,s3,a4
 8b8:	377d                	addw	a4,a4,-1
 8ba:	1702                	sll	a4,a4,0x20
 8bc:	9301                	srl	a4,a4,0x20
 8be:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 8c2:	fff94583          	lbu	a1,-1(s2)
 8c6:	8526                	mv	a0,s1
 8c8:	f5bff0ef          	jal	822 <putc>
  while(--i >= 0)
 8cc:	197d                	add	s2,s2,-1
 8ce:	ff391ae3          	bne	s2,s3,8c2 <printint+0x82>
}
 8d2:	70e2                	ld	ra,56(sp)
 8d4:	7442                	ld	s0,48(sp)
 8d6:	74a2                	ld	s1,40(sp)
 8d8:	7902                	ld	s2,32(sp)
 8da:	69e2                	ld	s3,24(sp)
 8dc:	6121                	add	sp,sp,64
 8de:	8082                	ret
    x = -xx;
 8e0:	40b005bb          	negw	a1,a1
    neg = 1;
 8e4:	4885                	li	a7,1
    x = -xx;
 8e6:	bf95                	j	85a <printint+0x1a>

00000000000008e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8e8:	711d                	add	sp,sp,-96
 8ea:	ec86                	sd	ra,88(sp)
 8ec:	e8a2                	sd	s0,80(sp)
 8ee:	e4a6                	sd	s1,72(sp)
 8f0:	e0ca                	sd	s2,64(sp)
 8f2:	fc4e                	sd	s3,56(sp)
 8f4:	f852                	sd	s4,48(sp)
 8f6:	f456                	sd	s5,40(sp)
 8f8:	f05a                	sd	s6,32(sp)
 8fa:	ec5e                	sd	s7,24(sp)
 8fc:	e862                	sd	s8,16(sp)
 8fe:	e466                	sd	s9,8(sp)
 900:	e06a                	sd	s10,0(sp)
 902:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 904:	0005c903          	lbu	s2,0(a1)
 908:	24090763          	beqz	s2,b56 <vprintf+0x26e>
 90c:	8b2a                	mv	s6,a0
 90e:	8a2e                	mv	s4,a1
 910:	8bb2                	mv	s7,a2
  state = 0;
 912:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 914:	4481                	li	s1,0
 916:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 918:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 91c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 920:	06c00c93          	li	s9,108
 924:	a005                	j	944 <vprintf+0x5c>
        putc(fd, c0);
 926:	85ca                	mv	a1,s2
 928:	855a                	mv	a0,s6
 92a:	ef9ff0ef          	jal	822 <putc>
 92e:	a019                	j	934 <vprintf+0x4c>
    } else if(state == '%'){
 930:	03598263          	beq	s3,s5,954 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 934:	2485                	addw	s1,s1,1
 936:	8726                	mv	a4,s1
 938:	009a07b3          	add	a5,s4,s1
 93c:	0007c903          	lbu	s2,0(a5)
 940:	20090b63          	beqz	s2,b56 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 944:	0009079b          	sext.w	a5,s2
    if(state == 0){
 948:	fe0994e3          	bnez	s3,930 <vprintf+0x48>
      if(c0 == '%'){
 94c:	fd579de3          	bne	a5,s5,926 <vprintf+0x3e>
        state = '%';
 950:	89be                	mv	s3,a5
 952:	b7cd                	j	934 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 954:	c7c9                	beqz	a5,9de <vprintf+0xf6>
 956:	00ea06b3          	add	a3,s4,a4
 95a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 95e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 960:	c681                	beqz	a3,968 <vprintf+0x80>
 962:	9752                	add	a4,a4,s4
 964:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 968:	03878f63          	beq	a5,s8,9a6 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 96c:	05978963          	beq	a5,s9,9be <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 970:	07500713          	li	a4,117
 974:	0ee78363          	beq	a5,a4,a5a <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 978:	07800713          	li	a4,120
 97c:	12e78563          	beq	a5,a4,aa6 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 980:	07000713          	li	a4,112
 984:	14e78a63          	beq	a5,a4,ad8 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 988:	07300713          	li	a4,115
 98c:	18e78863          	beq	a5,a4,b1c <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 990:	02500713          	li	a4,37
 994:	04e79563          	bne	a5,a4,9de <vprintf+0xf6>
        putc(fd, '%');
 998:	02500593          	li	a1,37
 99c:	855a                	mv	a0,s6
 99e:	e85ff0ef          	jal	822 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 9a2:	4981                	li	s3,0
 9a4:	bf41                	j	934 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 9a6:	008b8913          	add	s2,s7,8
 9aa:	4685                	li	a3,1
 9ac:	4629                	li	a2,10
 9ae:	000ba583          	lw	a1,0(s7)
 9b2:	855a                	mv	a0,s6
 9b4:	e8dff0ef          	jal	840 <printint>
 9b8:	8bca                	mv	s7,s2
      state = 0;
 9ba:	4981                	li	s3,0
 9bc:	bfa5                	j	934 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 9be:	06400793          	li	a5,100
 9c2:	02f68963          	beq	a3,a5,9f4 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9c6:	06c00793          	li	a5,108
 9ca:	04f68263          	beq	a3,a5,a0e <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 9ce:	07500793          	li	a5,117
 9d2:	0af68063          	beq	a3,a5,a72 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 9d6:	07800793          	li	a5,120
 9da:	0ef68263          	beq	a3,a5,abe <vprintf+0x1d6>
        putc(fd, '%');
 9de:	02500593          	li	a1,37
 9e2:	855a                	mv	a0,s6
 9e4:	e3fff0ef          	jal	822 <putc>
        putc(fd, c0);
 9e8:	85ca                	mv	a1,s2
 9ea:	855a                	mv	a0,s6
 9ec:	e37ff0ef          	jal	822 <putc>
      state = 0;
 9f0:	4981                	li	s3,0
 9f2:	b789                	j	934 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9f4:	008b8913          	add	s2,s7,8
 9f8:	4685                	li	a3,1
 9fa:	4629                	li	a2,10
 9fc:	000ba583          	lw	a1,0(s7)
 a00:	855a                	mv	a0,s6
 a02:	e3fff0ef          	jal	840 <printint>
        i += 1;
 a06:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a08:	8bca                	mv	s7,s2
      state = 0;
 a0a:	4981                	li	s3,0
        i += 1;
 a0c:	b725                	j	934 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a0e:	06400793          	li	a5,100
 a12:	02f60763          	beq	a2,a5,a40 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a16:	07500793          	li	a5,117
 a1a:	06f60963          	beq	a2,a5,a8c <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a1e:	07800793          	li	a5,120
 a22:	faf61ee3          	bne	a2,a5,9de <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a26:	008b8913          	add	s2,s7,8
 a2a:	4681                	li	a3,0
 a2c:	4641                	li	a2,16
 a2e:	000ba583          	lw	a1,0(s7)
 a32:	855a                	mv	a0,s6
 a34:	e0dff0ef          	jal	840 <printint>
        i += 2;
 a38:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a3a:	8bca                	mv	s7,s2
      state = 0;
 a3c:	4981                	li	s3,0
        i += 2;
 a3e:	bddd                	j	934 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a40:	008b8913          	add	s2,s7,8
 a44:	4685                	li	a3,1
 a46:	4629                	li	a2,10
 a48:	000ba583          	lw	a1,0(s7)
 a4c:	855a                	mv	a0,s6
 a4e:	df3ff0ef          	jal	840 <printint>
        i += 2;
 a52:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a54:	8bca                	mv	s7,s2
      state = 0;
 a56:	4981                	li	s3,0
        i += 2;
 a58:	bdf1                	j	934 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 a5a:	008b8913          	add	s2,s7,8
 a5e:	4681                	li	a3,0
 a60:	4629                	li	a2,10
 a62:	000ba583          	lw	a1,0(s7)
 a66:	855a                	mv	a0,s6
 a68:	dd9ff0ef          	jal	840 <printint>
 a6c:	8bca                	mv	s7,s2
      state = 0;
 a6e:	4981                	li	s3,0
 a70:	b5d1                	j	934 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a72:	008b8913          	add	s2,s7,8
 a76:	4681                	li	a3,0
 a78:	4629                	li	a2,10
 a7a:	000ba583          	lw	a1,0(s7)
 a7e:	855a                	mv	a0,s6
 a80:	dc1ff0ef          	jal	840 <printint>
        i += 1;
 a84:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a86:	8bca                	mv	s7,s2
      state = 0;
 a88:	4981                	li	s3,0
        i += 1;
 a8a:	b56d                	j	934 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a8c:	008b8913          	add	s2,s7,8
 a90:	4681                	li	a3,0
 a92:	4629                	li	a2,10
 a94:	000ba583          	lw	a1,0(s7)
 a98:	855a                	mv	a0,s6
 a9a:	da7ff0ef          	jal	840 <printint>
        i += 2;
 a9e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 aa0:	8bca                	mv	s7,s2
      state = 0;
 aa2:	4981                	li	s3,0
        i += 2;
 aa4:	bd41                	j	934 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 aa6:	008b8913          	add	s2,s7,8
 aaa:	4681                	li	a3,0
 aac:	4641                	li	a2,16
 aae:	000ba583          	lw	a1,0(s7)
 ab2:	855a                	mv	a0,s6
 ab4:	d8dff0ef          	jal	840 <printint>
 ab8:	8bca                	mv	s7,s2
      state = 0;
 aba:	4981                	li	s3,0
 abc:	bda5                	j	934 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 abe:	008b8913          	add	s2,s7,8
 ac2:	4681                	li	a3,0
 ac4:	4641                	li	a2,16
 ac6:	000ba583          	lw	a1,0(s7)
 aca:	855a                	mv	a0,s6
 acc:	d75ff0ef          	jal	840 <printint>
        i += 1;
 ad0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 ad2:	8bca                	mv	s7,s2
      state = 0;
 ad4:	4981                	li	s3,0
        i += 1;
 ad6:	bdb9                	j	934 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 ad8:	008b8d13          	add	s10,s7,8
 adc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 ae0:	03000593          	li	a1,48
 ae4:	855a                	mv	a0,s6
 ae6:	d3dff0ef          	jal	822 <putc>
  putc(fd, 'x');
 aea:	07800593          	li	a1,120
 aee:	855a                	mv	a0,s6
 af0:	d33ff0ef          	jal	822 <putc>
 af4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 af6:	00000b97          	auipc	s7,0x0
 afa:	382b8b93          	add	s7,s7,898 # e78 <digits>
 afe:	03c9d793          	srl	a5,s3,0x3c
 b02:	97de                	add	a5,a5,s7
 b04:	0007c583          	lbu	a1,0(a5)
 b08:	855a                	mv	a0,s6
 b0a:	d19ff0ef          	jal	822 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b0e:	0992                	sll	s3,s3,0x4
 b10:	397d                	addw	s2,s2,-1
 b12:	fe0916e3          	bnez	s2,afe <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 b16:	8bea                	mv	s7,s10
      state = 0;
 b18:	4981                	li	s3,0
 b1a:	bd29                	j	934 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 b1c:	008b8993          	add	s3,s7,8
 b20:	000bb903          	ld	s2,0(s7)
 b24:	00090f63          	beqz	s2,b42 <vprintf+0x25a>
        for(; *s; s++)
 b28:	00094583          	lbu	a1,0(s2)
 b2c:	c195                	beqz	a1,b50 <vprintf+0x268>
          putc(fd, *s);
 b2e:	855a                	mv	a0,s6
 b30:	cf3ff0ef          	jal	822 <putc>
        for(; *s; s++)
 b34:	0905                	add	s2,s2,1
 b36:	00094583          	lbu	a1,0(s2)
 b3a:	f9f5                	bnez	a1,b2e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b3c:	8bce                	mv	s7,s3
      state = 0;
 b3e:	4981                	li	s3,0
 b40:	bbd5                	j	934 <vprintf+0x4c>
          s = "(null)";
 b42:	00000917          	auipc	s2,0x0
 b46:	32e90913          	add	s2,s2,814 # e70 <malloc+0x220>
        for(; *s; s++)
 b4a:	02800593          	li	a1,40
 b4e:	b7c5                	j	b2e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b50:	8bce                	mv	s7,s3
      state = 0;
 b52:	4981                	li	s3,0
 b54:	b3c5                	j	934 <vprintf+0x4c>
    }
  }
}
 b56:	60e6                	ld	ra,88(sp)
 b58:	6446                	ld	s0,80(sp)
 b5a:	64a6                	ld	s1,72(sp)
 b5c:	6906                	ld	s2,64(sp)
 b5e:	79e2                	ld	s3,56(sp)
 b60:	7a42                	ld	s4,48(sp)
 b62:	7aa2                	ld	s5,40(sp)
 b64:	7b02                	ld	s6,32(sp)
 b66:	6be2                	ld	s7,24(sp)
 b68:	6c42                	ld	s8,16(sp)
 b6a:	6ca2                	ld	s9,8(sp)
 b6c:	6d02                	ld	s10,0(sp)
 b6e:	6125                	add	sp,sp,96
 b70:	8082                	ret

0000000000000b72 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b72:	715d                	add	sp,sp,-80
 b74:	ec06                	sd	ra,24(sp)
 b76:	e822                	sd	s0,16(sp)
 b78:	1000                	add	s0,sp,32
 b7a:	e010                	sd	a2,0(s0)
 b7c:	e414                	sd	a3,8(s0)
 b7e:	e818                	sd	a4,16(s0)
 b80:	ec1c                	sd	a5,24(s0)
 b82:	03043023          	sd	a6,32(s0)
 b86:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b8a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b8e:	8622                	mv	a2,s0
 b90:	d59ff0ef          	jal	8e8 <vprintf>
}
 b94:	60e2                	ld	ra,24(sp)
 b96:	6442                	ld	s0,16(sp)
 b98:	6161                	add	sp,sp,80
 b9a:	8082                	ret

0000000000000b9c <printf>:

void
printf(const char *fmt, ...)
{
 b9c:	711d                	add	sp,sp,-96
 b9e:	ec06                	sd	ra,24(sp)
 ba0:	e822                	sd	s0,16(sp)
 ba2:	1000                	add	s0,sp,32
 ba4:	e40c                	sd	a1,8(s0)
 ba6:	e810                	sd	a2,16(s0)
 ba8:	ec14                	sd	a3,24(s0)
 baa:	f018                	sd	a4,32(s0)
 bac:	f41c                	sd	a5,40(s0)
 bae:	03043823          	sd	a6,48(s0)
 bb2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 bb6:	00840613          	add	a2,s0,8
 bba:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 bbe:	85aa                	mv	a1,a0
 bc0:	4505                	li	a0,1
 bc2:	d27ff0ef          	jal	8e8 <vprintf>
}
 bc6:	60e2                	ld	ra,24(sp)
 bc8:	6442                	ld	s0,16(sp)
 bca:	6125                	add	sp,sp,96
 bcc:	8082                	ret

0000000000000bce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bce:	1141                	add	sp,sp,-16
 bd0:	e422                	sd	s0,8(sp)
 bd2:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bd4:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bd8:	00000797          	auipc	a5,0x0
 bdc:	4387b783          	ld	a5,1080(a5) # 1010 <freep>
 be0:	a02d                	j	c0a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 be2:	4618                	lw	a4,8(a2)
 be4:	9f2d                	addw	a4,a4,a1
 be6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 bea:	6398                	ld	a4,0(a5)
 bec:	6310                	ld	a2,0(a4)
 bee:	a83d                	j	c2c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 bf0:	ff852703          	lw	a4,-8(a0)
 bf4:	9f31                	addw	a4,a4,a2
 bf6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bf8:	ff053683          	ld	a3,-16(a0)
 bfc:	a091                	j	c40 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bfe:	6398                	ld	a4,0(a5)
 c00:	00e7e463          	bltu	a5,a4,c08 <free+0x3a>
 c04:	00e6ea63          	bltu	a3,a4,c18 <free+0x4a>
{
 c08:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c0a:	fed7fae3          	bgeu	a5,a3,bfe <free+0x30>
 c0e:	6398                	ld	a4,0(a5)
 c10:	00e6e463          	bltu	a3,a4,c18 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c14:	fee7eae3          	bltu	a5,a4,c08 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 c18:	ff852583          	lw	a1,-8(a0)
 c1c:	6390                	ld	a2,0(a5)
 c1e:	02059813          	sll	a6,a1,0x20
 c22:	01c85713          	srl	a4,a6,0x1c
 c26:	9736                	add	a4,a4,a3
 c28:	fae60de3          	beq	a2,a4,be2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 c2c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c30:	4790                	lw	a2,8(a5)
 c32:	02061593          	sll	a1,a2,0x20
 c36:	01c5d713          	srl	a4,a1,0x1c
 c3a:	973e                	add	a4,a4,a5
 c3c:	fae68ae3          	beq	a3,a4,bf0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 c40:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c42:	00000717          	auipc	a4,0x0
 c46:	3cf73723          	sd	a5,974(a4) # 1010 <freep>
}
 c4a:	6422                	ld	s0,8(sp)
 c4c:	0141                	add	sp,sp,16
 c4e:	8082                	ret

0000000000000c50 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c50:	7139                	add	sp,sp,-64
 c52:	fc06                	sd	ra,56(sp)
 c54:	f822                	sd	s0,48(sp)
 c56:	f426                	sd	s1,40(sp)
 c58:	f04a                	sd	s2,32(sp)
 c5a:	ec4e                	sd	s3,24(sp)
 c5c:	e852                	sd	s4,16(sp)
 c5e:	e456                	sd	s5,8(sp)
 c60:	e05a                	sd	s6,0(sp)
 c62:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c64:	02051493          	sll	s1,a0,0x20
 c68:	9081                	srl	s1,s1,0x20
 c6a:	04bd                	add	s1,s1,15
 c6c:	8091                	srl	s1,s1,0x4
 c6e:	0014899b          	addw	s3,s1,1
 c72:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 c74:	00000517          	auipc	a0,0x0
 c78:	39c53503          	ld	a0,924(a0) # 1010 <freep>
 c7c:	c515                	beqz	a0,ca8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c7e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c80:	4798                	lw	a4,8(a5)
 c82:	02977f63          	bgeu	a4,s1,cc0 <malloc+0x70>
  if(nu < 4096)
 c86:	8a4e                	mv	s4,s3
 c88:	0009871b          	sext.w	a4,s3
 c8c:	6685                	lui	a3,0x1
 c8e:	00d77363          	bgeu	a4,a3,c94 <malloc+0x44>
 c92:	6a05                	lui	s4,0x1
 c94:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c98:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c9c:	00000917          	auipc	s2,0x0
 ca0:	37490913          	add	s2,s2,884 # 1010 <freep>
  if(p == (char*)-1)
 ca4:	5afd                	li	s5,-1
 ca6:	a885                	j	d16 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 ca8:	00000797          	auipc	a5,0x0
 cac:	37878793          	add	a5,a5,888 # 1020 <base>
 cb0:	00000717          	auipc	a4,0x0
 cb4:	36f73023          	sd	a5,864(a4) # 1010 <freep>
 cb8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 cba:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 cbe:	b7e1                	j	c86 <malloc+0x36>
      if(p->s.size == nunits)
 cc0:	02e48c63          	beq	s1,a4,cf8 <malloc+0xa8>
        p->s.size -= nunits;
 cc4:	4137073b          	subw	a4,a4,s3
 cc8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cca:	02071693          	sll	a3,a4,0x20
 cce:	01c6d713          	srl	a4,a3,0x1c
 cd2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 cd4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 cd8:	00000717          	auipc	a4,0x0
 cdc:	32a73c23          	sd	a0,824(a4) # 1010 <freep>
      return (void*)(p + 1);
 ce0:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ce4:	70e2                	ld	ra,56(sp)
 ce6:	7442                	ld	s0,48(sp)
 ce8:	74a2                	ld	s1,40(sp)
 cea:	7902                	ld	s2,32(sp)
 cec:	69e2                	ld	s3,24(sp)
 cee:	6a42                	ld	s4,16(sp)
 cf0:	6aa2                	ld	s5,8(sp)
 cf2:	6b02                	ld	s6,0(sp)
 cf4:	6121                	add	sp,sp,64
 cf6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 cf8:	6398                	ld	a4,0(a5)
 cfa:	e118                	sd	a4,0(a0)
 cfc:	bff1                	j	cd8 <malloc+0x88>
  hp->s.size = nu;
 cfe:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d02:	0541                	add	a0,a0,16
 d04:	ecbff0ef          	jal	bce <free>
  return freep;
 d08:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d0c:	dd61                	beqz	a0,ce4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d0e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d10:	4798                	lw	a4,8(a5)
 d12:	fa9777e3          	bgeu	a4,s1,cc0 <malloc+0x70>
    if(p == freep)
 d16:	00093703          	ld	a4,0(s2)
 d1a:	853e                	mv	a0,a5
 d1c:	fef719e3          	bne	a4,a5,d0e <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 d20:	8552                	mv	a0,s4
 d22:	aa1ff0ef          	jal	7c2 <sbrk>
  if(p == (char*)-1)
 d26:	fd551ce3          	bne	a0,s5,cfe <malloc+0xae>
        return 0;
 d2a:	4501                	li	a0,0
 d2c:	bf65                	j	ce4 <malloc+0x94>
