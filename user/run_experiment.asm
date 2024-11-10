
user/_run_experiment:     file format elf64-littleriscv


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

0000000000000074 <main>:


int main(){
  74:	7155                	add	sp,sp,-208
  76:	e586                	sd	ra,200(sp)
  78:	e1a2                	sd	s0,192(sp)
  7a:	fd26                	sd	s1,184(sp)
  7c:	f94a                	sd	s2,176(sp)
  7e:	f54e                	sd	s3,168(sp)
  80:	f152                	sd	s4,160(sp)
  82:	ed56                	sd	s5,152(sp)
  84:	e95a                	sd	s6,144(sp)
  86:	e55e                	sd	s7,136(sp)
  88:	e162                	sd	s8,128(sp)
  8a:	fce6                	sd	s9,120(sp)
  8c:	f8ea                	sd	s10,112(sp)
  8e:	f4ee                	sd	s11,104(sp)
  90:	0980                	add	s0,sp,208
    char *args[3];

    int pipe_eficiencia[2];
    int pipe_overhead[2];

    pipe(pipe_eficiencia);
  92:	f7040513          	add	a0,s0,-144
  96:	6f4000ef          	jal	78a <pipe>
    pipe(pipe_overhead);
  9a:	f6840513          	add	a0,s0,-152
  9e:	6ec000ef          	jal	78a <pipe>
    
    //PIPE: EFICIENCIA
    int temp_int = pipe_eficiencia[1];
  a2:	f7442683          	lw	a3,-140(s0)
    char temp_efici[10];
    int i = 0;
  a6:	f5840613          	add	a2,s0,-168
    int temp_int = pipe_eficiencia[1];
  aa:	8732                	mv	a4,a2
    do {
        temp_efici[i++] = temp_int % 10 + '0';   // próximo digito
  ac:	45a9                	li	a1,10
    } while ((temp_int /= 10) > 0);
  ae:	4525                	li	a0,9
        temp_efici[i++] = temp_int % 10 + '0';   // próximo digito
  b0:	02b6e7bb          	remw	a5,a3,a1
  b4:	0307879b          	addw	a5,a5,48
  b8:	00f70023          	sb	a5,0(a4) # ffffffff80000000 <base+0xffffffff7fffefe0>
    } while ((temp_int /= 10) > 0);
  bc:	8836                	mv	a6,a3
  be:	02b6c6bb          	divw	a3,a3,a1
  c2:	87ba                	mv	a5,a4
  c4:	0705                	add	a4,a4,1
  c6:	ff0545e3          	blt	a0,a6,b0 <main+0x3c>
        temp_efici[i++] = temp_int % 10 + '0';   // próximo digito
  ca:	9f91                	subw	a5,a5,a2
    temp_efici[i] = '\0';
  cc:	2785                	addw	a5,a5,1
  ce:	f9078793          	add	a5,a5,-112
  d2:	97a2                	add	a5,a5,s0
  d4:	fc078423          	sb	zero,-56(a5)
    args[1] = temp_efici;
  d8:	f5840793          	add	a5,s0,-168
  dc:	f8f43023          	sd	a5,-128(s0)

    //PIPE: OVERHEAD
    temp_int = pipe_overhead[1];
  e0:	f6c42683          	lw	a3,-148(s0)
    char temp_overh[10];
    i = 0;
  e4:	f4840613          	add	a2,s0,-184
    temp_int = pipe_overhead[1];
  e8:	8732                	mv	a4,a2
    do {
        temp_overh[i++] = temp_int % 10 + '0';   // próximo digito
  ea:	45a9                	li	a1,10
    } while ((temp_int /= 10) > 0);
  ec:	4525                	li	a0,9
        temp_overh[i++] = temp_int % 10 + '0';   // próximo digito
  ee:	02b6e7bb          	remw	a5,a3,a1
  f2:	0307879b          	addw	a5,a5,48
  f6:	00f70023          	sb	a5,0(a4)
    } while ((temp_int /= 10) > 0);
  fa:	8836                	mv	a6,a3
  fc:	02b6c6bb          	divw	a3,a3,a1
 100:	87ba                	mv	a5,a4
 102:	0705                	add	a4,a4,1
 104:	ff0545e3          	blt	a0,a6,ee <main+0x7a>
        temp_overh[i++] = temp_int % 10 + '0';   // próximo digito
 108:	9f91                	subw	a5,a5,a2
    temp_overh[i] = '\0';
 10a:	2785                	addw	a5,a5,1
 10c:	f9078793          	add	a5,a5,-112
 110:	97a2                	add	a5,a5,s0
 112:	fa078c23          	sb	zero,-72(a5)
    args[2] = temp_overh;
 116:	f4840793          	add	a5,s0,-184
 11a:	f8f43423          	sd	a5,-120(s0)


    for (i = 1; i <= 30; i++){
 11e:	4d05                	li	s10,1
                } else {       //pai
                    //processos[j-1] = pid;
                }
            } else {
                //IO-BOUND
                args[0] = "rows";
 120:	00001b97          	auipc	s7,0x1
 124:	c58b8b93          	add	s7,s7,-936 # d78 <malloc+0x110>
                args[0] = "graphs";
 128:	00001b17          	auipc	s6,0x1
 12c:	c28b0b13          	add	s6,s6,-984 # d50 <malloc+0xe8>

        //ele perdia o valor de vazao_norm depois de ler o pipe, não sei o porque, mas ele n perde se for uma string
        char vazao_str[10];
        int k = 0;
        do {
            vazao_str[k++] = vazao_norm % 10 + '0';   // próximo digito
 130:	4d85                	li	s11,1
 132:	f3840793          	add	a5,s0,-200
 136:	40fd8dbb          	subw	s11,s11,a5
 13a:	ae49                	j	4cc <main+0x458>
                args[0] = "rows";
 13c:	f7743c23          	sd	s7,-136(s0)
                pid = fork();
 140:	632000ef          	jal	772 <fork>
                if (pid == 0){ //filho
 144:	cd0d                	beqz	a0,17e <main+0x10a>
        for (int j = 1; j < 21; j++){
 146:	2485                	addw	s1,s1,1
 148:	05248b63          	beq	s1,s2,19e <main+0x12a>
            if (j <= X){
 14c:	0004879b          	sext.w	a5,s1
 150:	fef9e6e3          	bltu	s3,a5,13c <main+0xc8>
                args[0] = "graphs";
 154:	f7643c23          	sd	s6,-136(s0)
                pid = fork();
 158:	61a000ef          	jal	772 <fork>
                if (pid == 0){ //filho
 15c:	f56d                	bnez	a0,146 <main+0xd2>
                    ret = exec("graphs", args);
 15e:	f7840593          	add	a1,s0,-136
 162:	855a                	mv	a0,s6
 164:	64e000ef          	jal	7b2 <exec>
                    if (ret == -1){
 168:	fd451fe3          	bne	a0,s4,146 <main+0xd2>
                        printf("erro ao executar graphs.c\n");
 16c:	00001517          	auipc	a0,0x1
 170:	bec50513          	add	a0,a0,-1044 # d58 <malloc+0xf0>
 174:	241000ef          	jal	bb4 <printf>
                        exit(1);
 178:	4505                	li	a0,1
 17a:	600000ef          	jal	77a <exit>
                    ret = exec("rows", args);
 17e:	f7840593          	add	a1,s0,-136
 182:	855e                	mv	a0,s7
 184:	62e000ef          	jal	7b2 <exec>
                    if (ret == -1){
 188:	fb451fe3          	bne	a0,s4,146 <main+0xd2>
                        printf("erro ao executar rows.c\n");
 18c:	00001517          	auipc	a0,0x1
 190:	bf450513          	add	a0,a0,-1036 # d80 <malloc+0x118>
 194:	221000ef          	jal	bb4 <printf>
                        exit(1);
 198:	4505                	li	a0,1
 19a:	5e0000ef          	jal	77a <exit>
        int *terminos = malloc(20 * sizeof(int));
 19e:	05000513          	li	a0,80
 1a2:	2c7000ef          	jal	c68 <malloc>
 1a6:	8a2a                	mv	s4,a0
        for (int j = 0; j < 20; j++){
 1a8:	05050913          	add	s2,a0,80
        int *terminos = malloc(20 * sizeof(int));
 1ac:	84aa                	mv	s1,a0
            if (proc == -1){
 1ae:	59fd                	li	s3,-1
                printf("pocesso falhou");
 1b0:	00001c17          	auipc	s8,0x1
 1b4:	bf0c0c13          	add	s8,s8,-1040 # da0 <malloc+0x138>
 1b8:	a039                	j	1c6 <main+0x152>
 1ba:	8562                	mv	a0,s8
 1bc:	1f9000ef          	jal	bb4 <printf>
        for (int j = 0; j < 20; j++){
 1c0:	0491                	add	s1,s1,4
 1c2:	01248d63          	beq	s1,s2,1dc <main+0x168>
            proc = wait(0);
 1c6:	4501                	li	a0,0
 1c8:	5ba000ef          	jal	782 <wait>
            if (proc == -1){
 1cc:	ff3507e3          	beq	a0,s3,1ba <main+0x146>
                tempo_atual = uptime();
 1d0:	642000ef          	jal	812 <uptime>
                terminos[j] = (tempo_atual - t0_rodada);
 1d4:	4155053b          	subw	a0,a0,s5
 1d8:	c088                	sw	a0,0(s1)
 1da:	b7dd                	j	1c0 <main+0x14c>
        tempo_atual = uptime();
 1dc:	636000ef          	jal	812 <uptime>
        printf("RODADA %d ======================\n", i);
 1e0:	85ea                	mv	a1,s10
 1e2:	00001517          	auipc	a0,0x1
 1e6:	bce50513          	add	a0,a0,-1074 # db0 <malloc+0x148>
 1ea:	1cb000ef          	jal	bb4 <printf>
        for (int j = 0; j < 20; j++){
 1ee:	004a0613          	add	a2,s4,4
 1f2:	054a0813          	add	a6,s4,84
        printf("RODADA %d ======================\n", i);
 1f6:	4501                	li	a0,0
 1f8:	4349                	li	t1,18
 1fa:	008a0893          	add	a7,s4,8
 1fe:	a005                	j	21e <main+0x1aa>
            for (int k = j+1; k < 20; k++){
 200:	0791                	add	a5,a5,4
 202:	00d78a63          	beq	a5,a3,216 <main+0x1a2>
                if (terminos[k] < terminos[j]){
 206:	4398                	lw	a4,0(a5)
 208:	ffc62583          	lw	a1,-4(a2)
 20c:	feb75ae3          	bge	a4,a1,200 <main+0x18c>
                    terminos[j] = terminos[k];
 210:	fee62e23          	sw	a4,-4(a2)
                    terminos[k] = temp;
 214:	b7f5                	j	200 <main+0x18c>
        for (int j = 0; j < 20; j++){
 216:	0505                	add	a0,a0,1
 218:	0611                	add	a2,a2,4
 21a:	01060f63          	beq	a2,a6,238 <main+0x1c4>
            for (int k = j+1; k < 20; k++){
 21e:	0005079b          	sext.w	a5,a0
 222:	01260b63          	beq	a2,s2,238 <main+0x1c4>
 226:	40f306bb          	subw	a3,t1,a5
 22a:	1682                	sll	a3,a3,0x20
 22c:	9281                	srl	a3,a3,0x20
 22e:	96aa                	add	a3,a3,a0
 230:	068a                	sll	a3,a3,0x2
 232:	96c6                	add	a3,a3,a7
 234:	87b2                	mv	a5,a2
 236:	bfc1                	j	206 <main+0x192>
        int *vazoes = malloc(50 * sizeof(int));
 238:	0c800513          	li	a0,200
 23c:	22d000ef          	jal	c68 <malloc>
 240:	892a                	mv	s2,a0
        for (int j = 0; j < 50; j++){
 242:	86aa                	mv	a3,a0
 244:	0c850713          	add	a4,a0,200
        int *vazoes = malloc(50 * sizeof(int));
 248:	87aa                	mv	a5,a0
            vazoes[j] = 0;
 24a:	0007a023          	sw	zero,0(a5)
        for (int j = 0; j < 50; j++){
 24e:	0791                	add	a5,a5,4
 250:	fee79de3          	bne	a5,a4,24a <main+0x1d6>
        int segundo_atual = 0;
 254:	4601                	li	a2,0
        int index = 0;
 256:	4581                	li	a1,0
        while (index < 20){
 258:	454d                	li	a0,19
 25a:	a021                	j	262 <main+0x1ee>
                segundo_atual += 1;
 25c:	2605                	addw	a2,a2,1
        while (index < 20){
 25e:	02b54563          	blt	a0,a1,288 <main+0x214>
            if (10 * segundo_atual >= terminos[index]){
 262:	0026179b          	sllw	a5,a2,0x2
 266:	9fb1                	addw	a5,a5,a2
 268:	00259713          	sll	a4,a1,0x2
 26c:	9752                	add	a4,a4,s4
 26e:	0017979b          	sllw	a5,a5,0x1
 272:	4318                	lw	a4,0(a4)
 274:	fee7c4e3          	blt	a5,a4,25c <main+0x1e8>
                index += 1;
 278:	2585                	addw	a1,a1,1
                vazoes[segundo_atual] += 1;
 27a:	00261793          	sll	a5,a2,0x2
 27e:	97ca                	add	a5,a5,s2
 280:	4398                	lw	a4,0(a5)
 282:	2705                	addw	a4,a4,1
 284:	c398                	sw	a4,0(a5)
 286:	bfe1                	j	25e <main+0x1ea>
        for (int j = 0; j <= lim; j++){
 288:	02064f63          	bltz	a2,2c6 <main+0x252>
 28c:	02061793          	sll	a5,a2,0x20
 290:	01e7d813          	srl	a6,a5,0x1e
 294:	00490793          	add	a5,s2,4
 298:	983e                	add	a6,a6,a5
        int vazao_min = 10000;
 29a:	6709                	lui	a4,0x2
 29c:	71070713          	add	a4,a4,1808 # 2710 <base+0x16f0>
        int vazao_max = -10;
 2a0:	55d9                	li	a1,-10
 2a2:	a031                	j	2ae <main+0x23a>
 2a4:	0005059b          	sext.w	a1,a0
        for (int j = 0; j <= lim; j++){
 2a8:	0691                	add	a3,a3,4
 2aa:	02d80263          	beq	a6,a3,2ce <main+0x25a>
            if (vazoes[j] < vazao_min) {
 2ae:	429c                	lw	a5,0(a3)
 2b0:	853e                	mv	a0,a5
 2b2:	00f75363          	bge	a4,a5,2b8 <main+0x244>
 2b6:	853a                	mv	a0,a4
 2b8:	0005071b          	sext.w	a4,a0
            if (vazoes[j] > vazao_max) {
 2bc:	853e                	mv	a0,a5
 2be:	feb7d3e3          	bge	a5,a1,2a4 <main+0x230>
 2c2:	852e                	mv	a0,a1
 2c4:	b7c5                	j	2a4 <main+0x230>
        int vazao_min = 10000;
 2c6:	6709                	lui	a4,0x2
 2c8:	71070713          	add	a4,a4,1808 # 2710 <base+0x16f0>
        int vazao_max = -10;
 2cc:	55d9                	li	a1,-10
        vazao_min *= 1000;
 2ce:	3e800693          	li	a3,1000
 2d2:	02e6873b          	mulw	a4,a3,a4
        int vazao_media = (20 * 1000) / lim;
 2d6:	6495                	lui	s1,0x5
 2d8:	e204849b          	addw	s1,s1,-480 # 4e20 <base+0x3e00>
 2dc:	02c4c4bb          	divw	s1,s1,a2
        int nominador = vazao_media - vazao_min;
 2e0:	9c99                	subw	s1,s1,a4
        int res = 1000 - (nominador * 1000 / denominador);
 2e2:	02d484bb          	mulw	s1,s1,a3
        vazao_max *= 1000;
 2e6:	02b687bb          	mulw	a5,a3,a1
        int denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero
 2ea:	9f99                	subw	a5,a5,a4
        int res = 1000 - (nominador * 1000 / denominador);
 2ec:	02f4c4bb          	divw	s1,s1,a5
 2f0:	409684bb          	subw	s1,a3,s1
        int vazao_norm = res % 1000; //o valor é sempre de 0-1, não faz sentido pegar o valor maior e 1
 2f4:	02d4e4bb          	remw	s1,s1,a3
        printf("vazao normalizada: %de-03\n", vazao_norm);
 2f8:	85a6                	mv	a1,s1
 2fa:	00001517          	auipc	a0,0x1
 2fe:	ade50513          	add	a0,a0,-1314 # dd8 <malloc+0x170>
 302:	0b3000ef          	jal	bb4 <printf>
 306:	f3840793          	add	a5,s0,-200
            vazao_str[k++] = vazao_norm % 10 + '0';   // próximo digito
 30a:	46a9                	li	a3,10
        } while ((vazao_norm /= 10) > 0);
 30c:	45a5                	li	a1,9
            vazao_str[k++] = vazao_norm % 10 + '0';   // próximo digito
 30e:	02d4e73b          	remw	a4,s1,a3
 312:	0307071b          	addw	a4,a4,48
 316:	00e78023          	sb	a4,0(a5)
        } while ((vazao_norm /= 10) > 0);
 31a:	8726                	mv	a4,s1
 31c:	02d4c4bb          	divw	s1,s1,a3
 320:	863e                	mv	a2,a5
 322:	0785                	add	a5,a5,1
 324:	fee5c5e3          	blt	a1,a4,30e <main+0x29a>
        vazao_str[k] = '\0';
 328:	00cd87bb          	addw	a5,s11,a2
 32c:	f9078793          	add	a5,a5,-112
 330:	97a2                	add	a5,a5,s0
 332:	fa078423          	sb	zero,-88(a5)
        free(terminos);
 336:	8552                	mv	a0,s4
 338:	0af000ef          	jal	be6 <free>
        free(vazoes);
 33c:	854a                	mv	a0,s2
 33e:	0a9000ef          	jal	be6 <free>
        

        // EFICIENCIA DO SISTEMA DE ARQUIVOS, lembrando que só IO-BOUND tem essa métrica
        int *eficiencias = malloc(Y * sizeof(int));
 342:	002c951b          	sllw	a0,s9,0x2
 346:	123000ef          	jal	c68 <malloc>
 34a:	8a2a                	mv	s4,a0
        
        
        //lendo os dados do pipe
        for (int j = 0; j < Y; j++){
 34c:	84aa                	mv	s1,a0
 34e:	020c9793          	sll	a5,s9,0x20
 352:	01e7d993          	srl	s3,a5,0x1e
 356:	00a98933          	add	s2,s3,a0
        int *eficiencias = malloc(Y * sizeof(int));
 35a:	8aaa                	mv	s5,a0
            read(pipe_eficiencia[0], &eficiencias[j], sizeof(int));
 35c:	4611                	li	a2,4
 35e:	85d6                	mv	a1,s5
 360:	f7042503          	lw	a0,-144(s0)
 364:	42e000ef          	jal	792 <read>
        for (int j = 0; j < Y; j++){
 368:	0a91                	add	s5,s5,4
 36a:	ff5919e3          	bne	s2,s5,35c <main+0x2e8>
        //close(pipe_eficiencia[0]);
        
        //pegando maximo e minimo
        int eficiencia_max = -10;
        int eficiencia_min = 100000;
        int eficiencia_soma = 0;
 36e:	4501                	li	a0,0
        int eficiencia_min = 100000;
 370:	66e1                	lui	a3,0x18
 372:	6a068693          	add	a3,a3,1696 # 186a0 <base+0x17680>
        int eficiencia_max = -10;
 376:	55d9                	li	a1,-10
 378:	a031                	j	384 <main+0x310>
 37a:	0006059b          	sext.w	a1,a2
        
        for(int j = 0; j < Y; j ++){
 37e:	0491                	add	s1,s1,4
 380:	03248263          	beq	s1,s2,3a4 <main+0x330>
            eficiencia_soma += eficiencias[j];
 384:	409c                	lw	a5,0(s1)
 386:	00a7873b          	addw	a4,a5,a0
 38a:	0007051b          	sext.w	a0,a4
            if (eficiencias[j] < eficiencia_min){
 38e:	863e                	mv	a2,a5
 390:	00f6d363          	bge	a3,a5,396 <main+0x322>
 394:	8636                	mv	a2,a3
 396:	0006069b          	sext.w	a3,a2
                eficiencia_min = eficiencias[j];
            }
            if (eficiencias[j] > eficiencia_max) {
 39a:	863e                	mv	a2,a5
 39c:	fcb7dfe3          	bge	a5,a1,37a <main+0x306>
 3a0:	862e                	mv	a2,a1
 3a2:	bfe1                	j	37a <main+0x306>
        }

        //normalizando
        int eficiencia_media = (1000 * eficiencia_soma) / Y;
        eficiencia_max *= 1000;
        eficiencia_min *= 1000;
 3a4:	3e800593          	li	a1,1000
 3a8:	02d586bb          	mulw	a3,a1,a3
        int eficiencia_media = (1000 * eficiencia_soma) / Y;
 3ac:	02e5893b          	mulw	s2,a1,a4
 3b0:	0399593b          	divuw	s2,s2,s9

        nominador = eficiencia_media - eficiencia_min;
 3b4:	40d9093b          	subw	s2,s2,a3
        denominador = eficiencia_max - eficiencia_min;
        
        res = 1000 - (nominador * 1000 / denominador);
 3b8:	02b9093b          	mulw	s2,s2,a1
        eficiencia_max *= 1000;
 3bc:	02c587bb          	mulw	a5,a1,a2
        denominador = eficiencia_max - eficiencia_min;
 3c0:	9f95                	subw	a5,a5,a3
        res = 1000 - (nominador * 1000 / denominador);
 3c2:	02f9493b          	divw	s2,s2,a5
 3c6:	4125893b          	subw	s2,a1,s2
        int eficiencia_norm = res % 1000;
 3ca:	02b9693b          	remw	s2,s2,a1
        printf("eficiencia normalizada: %de-03\n", eficiencia_norm);
 3ce:	0009059b          	sext.w	a1,s2
 3d2:	00001517          	auipc	a0,0x1
 3d6:	a2650513          	add	a0,a0,-1498 # df8 <malloc+0x190>
 3da:	7da000ef          	jal	bb4 <printf>
        free(eficiencias);
 3de:	8552                	mv	a0,s4
 3e0:	007000ef          	jal	be6 <free>


        //OVERHEAD
        int *overheads = malloc(20 * sizeof(int));
 3e4:	05000513          	li	a0,80
 3e8:	081000ef          	jal	c68 <malloc>
 3ec:	8a2a                	mv	s4,a0
        

        //lendo os dados do pipe
        for (int j = 0; j < Y; j++){
 3ee:	84aa                	mv	s1,a0
 3f0:	99aa                	add	s3,s3,a0
        int *overheads = malloc(20 * sizeof(int));
 3f2:	8aaa                	mv	s5,a0
            read(pipe_overhead[0], &overheads[j], sizeof(int));
 3f4:	4611                	li	a2,4
 3f6:	85d6                	mv	a1,s5
 3f8:	f6842503          	lw	a0,-152(s0)
 3fc:	396000ef          	jal	792 <read>
        for (int j = 0; j < Y; j++){
 400:	0a91                	add	s5,s5,4
 402:	ff3a99e3          	bne	s5,s3,3f4 <main+0x380>
        //close(pipe_overhead[0]);

        //pegando maximo e minimo
        int overhead_max = -10;
        int overhead_min = 100000;
        int overhead_soma = 0;
 406:	4501                	li	a0,0
        int overhead_min = 100000;
 408:	66e1                	lui	a3,0x18
 40a:	6a068693          	add	a3,a3,1696 # 186a0 <base+0x17680>
        int overhead_max = -10;
 40e:	55d9                	li	a1,-10
 410:	a031                	j	41c <main+0x3a8>
 412:	0006059b          	sext.w	a1,a2
        
        for(int j = 0; j < Y; j ++){
 416:	0491                	add	s1,s1,4
 418:	03348263          	beq	s1,s3,43c <main+0x3c8>
            overhead_soma += overheads[j];
 41c:	409c                	lw	a5,0(s1)
 41e:	00a7873b          	addw	a4,a5,a0
 422:	0007051b          	sext.w	a0,a4
            if (overheads[j] < overhead_min){
 426:	863e                	mv	a2,a5
 428:	00f6d363          	bge	a3,a5,42e <main+0x3ba>
 42c:	8636                	mv	a2,a3
 42e:	0006069b          	sext.w	a3,a2
                overhead_min = overheads[j];
            }
            if (overheads[j] > overhead_max) {
 432:	863e                	mv	a2,a5
 434:	fcb7dfe3          	bge	a5,a1,412 <main+0x39e>
 438:	862e                	mv	a2,a1
 43a:	bfe1                	j	412 <main+0x39e>
            }
        }

        int overhead_media = (1000 * overhead_soma) / Y;
        overhead_max *= 1000;
        overhead_min *= 1000;
 43c:	3e800593          	li	a1,1000
 440:	02d586bb          	mulw	a3,a1,a3
        int overhead_media = (1000 * overhead_soma) / Y;
 444:	02e584bb          	mulw	s1,a1,a4
 448:	0394d4bb          	divuw	s1,s1,s9

        nominador = overhead_media - overhead_min;
 44c:	9c95                	subw	s1,s1,a3
        denominador = overhead_max - overhead_min;
        res = 1000 - (nominador * 1000 / denominador);
 44e:	02b484bb          	mulw	s1,s1,a1
        overhead_max *= 1000;
 452:	02c587bb          	mulw	a5,a1,a2
        denominador = overhead_max - overhead_min;
 456:	9f95                	subw	a5,a5,a3
        res = 1000 - (nominador * 1000 / denominador);
 458:	02f4c4bb          	divw	s1,s1,a5
 45c:	409584bb          	subw	s1,a1,s1
        int overhead_norm = res % 1000;
 460:	02b4e4bb          	remw	s1,s1,a1
        printf("overhead normalizado: %de-03\n", overhead_norm);
 464:	0004859b          	sext.w	a1,s1
 468:	00001517          	auipc	a0,0x1
 46c:	9b050513          	add	a0,a0,-1616 # e18 <malloc+0x1b0>
 470:	744000ef          	jal	bb4 <printf>
        free(overheads);
 474:	8552                	mv	a0,s4
 476:	770000ef          	jal	be6 <free>

        //DESEMPENHO
        //recuperando vazao_norm pela string
        vazao_norm = 0;
        vazao_norm += vazao_str[0] - '0';
        vazao_norm += 10*(vazao_str[1] - '0');
 47a:	f3944703          	lbu	a4,-199(s0)
 47e:	fd07071b          	addw	a4,a4,-48
 482:	0027179b          	sllw	a5,a4,0x2
 486:	9fb9                	addw	a5,a5,a4
 488:	0017979b          	sllw	a5,a5,0x1
        vazao_norm += vazao_str[0] - '0';
 48c:	f3844703          	lbu	a4,-200(s0)
 490:	fd07071b          	addw	a4,a4,-48
        vazao_norm += 10*(vazao_str[1] - '0');
 494:	9fb9                	addw	a5,a5,a4
        vazao_norm += 100*(vazao_str[2] - '0');
 496:	f3a44583          	lbu	a1,-198(s0)
 49a:	fd05859b          	addw	a1,a1,-48
 49e:	06400713          	li	a4,100
 4a2:	02e585bb          	mulw	a1,a1,a4
 4a6:	9dbd                	addw	a1,a1,a5

        int justica_norm = 1000;
        int desempenho = (overhead_norm + eficiencia_norm + vazao_norm + justica_norm);
 4a8:	0099093b          	addw	s2,s2,s1
 4ac:	012585bb          	addw	a1,a1,s2
 4b0:	3e85859b          	addw	a1,a1,1000
        desempenho = desempenho >> 2;
        printf("desempenho: %de-03\n", desempenho);
 4b4:	4025d59b          	sraw	a1,a1,0x2
 4b8:	00001517          	auipc	a0,0x1
 4bc:	98050513          	add	a0,a0,-1664 # e38 <malloc+0x1d0>
 4c0:	6f4000ef          	jal	bb4 <printf>
    for (i = 1; i <= 30; i++){
 4c4:	2d05                	addw	s10,s10,1
 4c6:	47fd                	li	a5,31
 4c8:	02fd0463          	beq	s10,a5,4f0 <main+0x47c>
        t0_rodada = uptime();
 4cc:	346000ef          	jal	812 <uptime>
 4d0:	8aaa                	mv	s5,a0
        uint X = (rand() % 9) + 6;
 4d2:	b87ff0ef          	jal	58 <rand>
 4d6:	47a5                	li	a5,9
 4d8:	02f567bb          	remw	a5,a0,a5
 4dc:	2799                	addw	a5,a5,6
 4de:	0007899b          	sext.w	s3,a5
        uint Y = 20 - X;
 4e2:	4cd1                	li	s9,20
 4e4:	40fc8cbb          	subw	s9,s9,a5
        for (int j = 1; j < 21; j++){
 4e8:	4485                	li	s1,1
                    if (ret == -1){
 4ea:	5a7d                	li	s4,-1
        for (int j = 1; j < 21; j++){
 4ec:	4955                	li	s2,21
 4ee:	b9b9                	j	14c <main+0xd8>

    }
    return 0;
 4f0:	4501                	li	a0,0
 4f2:	60ae                	ld	ra,200(sp)
 4f4:	640e                	ld	s0,192(sp)
 4f6:	74ea                	ld	s1,184(sp)
 4f8:	794a                	ld	s2,176(sp)
 4fa:	79aa                	ld	s3,168(sp)
 4fc:	7a0a                	ld	s4,160(sp)
 4fe:	6aea                	ld	s5,152(sp)
 500:	6b4a                	ld	s6,144(sp)
 502:	6baa                	ld	s7,136(sp)
 504:	6c0a                	ld	s8,128(sp)
 506:	7ce6                	ld	s9,120(sp)
 508:	7d46                	ld	s10,112(sp)
 50a:	7da6                	ld	s11,104(sp)
 50c:	6169                	add	sp,sp,208
 50e:	8082                	ret

0000000000000510 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 510:	1141                	add	sp,sp,-16
 512:	e406                	sd	ra,8(sp)
 514:	e022                	sd	s0,0(sp)
 516:	0800                	add	s0,sp,16
  extern int main();
  main();
 518:	b5dff0ef          	jal	74 <main>
  exit(0);
 51c:	4501                	li	a0,0
 51e:	25c000ef          	jal	77a <exit>

0000000000000522 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 522:	1141                	add	sp,sp,-16
 524:	e422                	sd	s0,8(sp)
 526:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 528:	87aa                	mv	a5,a0
 52a:	0585                	add	a1,a1,1
 52c:	0785                	add	a5,a5,1
 52e:	fff5c703          	lbu	a4,-1(a1)
 532:	fee78fa3          	sb	a4,-1(a5)
 536:	fb75                	bnez	a4,52a <strcpy+0x8>
    ;
  return os;
}
 538:	6422                	ld	s0,8(sp)
 53a:	0141                	add	sp,sp,16
 53c:	8082                	ret

000000000000053e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 53e:	1141                	add	sp,sp,-16
 540:	e422                	sd	s0,8(sp)
 542:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 544:	00054783          	lbu	a5,0(a0)
 548:	cb91                	beqz	a5,55c <strcmp+0x1e>
 54a:	0005c703          	lbu	a4,0(a1)
 54e:	00f71763          	bne	a4,a5,55c <strcmp+0x1e>
    p++, q++;
 552:	0505                	add	a0,a0,1
 554:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 556:	00054783          	lbu	a5,0(a0)
 55a:	fbe5                	bnez	a5,54a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 55c:	0005c503          	lbu	a0,0(a1)
}
 560:	40a7853b          	subw	a0,a5,a0
 564:	6422                	ld	s0,8(sp)
 566:	0141                	add	sp,sp,16
 568:	8082                	ret

000000000000056a <strlen>:

uint
strlen(const char *s)
{
 56a:	1141                	add	sp,sp,-16
 56c:	e422                	sd	s0,8(sp)
 56e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 570:	00054783          	lbu	a5,0(a0)
 574:	cf91                	beqz	a5,590 <strlen+0x26>
 576:	0505                	add	a0,a0,1
 578:	87aa                	mv	a5,a0
 57a:	86be                	mv	a3,a5
 57c:	0785                	add	a5,a5,1
 57e:	fff7c703          	lbu	a4,-1(a5)
 582:	ff65                	bnez	a4,57a <strlen+0x10>
 584:	40a6853b          	subw	a0,a3,a0
 588:	2505                	addw	a0,a0,1
    ;
  return n;
}
 58a:	6422                	ld	s0,8(sp)
 58c:	0141                	add	sp,sp,16
 58e:	8082                	ret
  for(n = 0; s[n]; n++)
 590:	4501                	li	a0,0
 592:	bfe5                	j	58a <strlen+0x20>

0000000000000594 <memset>:

void*
memset(void *dst, int c, uint n)
{
 594:	1141                	add	sp,sp,-16
 596:	e422                	sd	s0,8(sp)
 598:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 59a:	ca19                	beqz	a2,5b0 <memset+0x1c>
 59c:	87aa                	mv	a5,a0
 59e:	1602                	sll	a2,a2,0x20
 5a0:	9201                	srl	a2,a2,0x20
 5a2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5a6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5aa:	0785                	add	a5,a5,1
 5ac:	fee79de3          	bne	a5,a4,5a6 <memset+0x12>
  }
  return dst;
}
 5b0:	6422                	ld	s0,8(sp)
 5b2:	0141                	add	sp,sp,16
 5b4:	8082                	ret

00000000000005b6 <strchr>:

char*
strchr(const char *s, char c)
{
 5b6:	1141                	add	sp,sp,-16
 5b8:	e422                	sd	s0,8(sp)
 5ba:	0800                	add	s0,sp,16
  for(; *s; s++)
 5bc:	00054783          	lbu	a5,0(a0)
 5c0:	cb99                	beqz	a5,5d6 <strchr+0x20>
    if(*s == c)
 5c2:	00f58763          	beq	a1,a5,5d0 <strchr+0x1a>
  for(; *s; s++)
 5c6:	0505                	add	a0,a0,1
 5c8:	00054783          	lbu	a5,0(a0)
 5cc:	fbfd                	bnez	a5,5c2 <strchr+0xc>
      return (char*)s;
  return 0;
 5ce:	4501                	li	a0,0
}
 5d0:	6422                	ld	s0,8(sp)
 5d2:	0141                	add	sp,sp,16
 5d4:	8082                	ret
  return 0;
 5d6:	4501                	li	a0,0
 5d8:	bfe5                	j	5d0 <strchr+0x1a>

00000000000005da <gets>:

char*
gets(char *buf, int max)
{
 5da:	711d                	add	sp,sp,-96
 5dc:	ec86                	sd	ra,88(sp)
 5de:	e8a2                	sd	s0,80(sp)
 5e0:	e4a6                	sd	s1,72(sp)
 5e2:	e0ca                	sd	s2,64(sp)
 5e4:	fc4e                	sd	s3,56(sp)
 5e6:	f852                	sd	s4,48(sp)
 5e8:	f456                	sd	s5,40(sp)
 5ea:	f05a                	sd	s6,32(sp)
 5ec:	ec5e                	sd	s7,24(sp)
 5ee:	1080                	add	s0,sp,96
 5f0:	8baa                	mv	s7,a0
 5f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5f4:	892a                	mv	s2,a0
 5f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5f8:	4aa9                	li	s5,10
 5fa:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5fc:	89a6                	mv	s3,s1
 5fe:	2485                	addw	s1,s1,1
 600:	0344d663          	bge	s1,s4,62c <gets+0x52>
    cc = read(0, &c, 1);
 604:	4605                	li	a2,1
 606:	faf40593          	add	a1,s0,-81
 60a:	4501                	li	a0,0
 60c:	186000ef          	jal	792 <read>
    if(cc < 1)
 610:	00a05e63          	blez	a0,62c <gets+0x52>
    buf[i++] = c;
 614:	faf44783          	lbu	a5,-81(s0)
 618:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 61c:	01578763          	beq	a5,s5,62a <gets+0x50>
 620:	0905                	add	s2,s2,1
 622:	fd679de3          	bne	a5,s6,5fc <gets+0x22>
  for(i=0; i+1 < max; ){
 626:	89a6                	mv	s3,s1
 628:	a011                	j	62c <gets+0x52>
 62a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 62c:	99de                	add	s3,s3,s7
 62e:	00098023          	sb	zero,0(s3)
  return buf;
}
 632:	855e                	mv	a0,s7
 634:	60e6                	ld	ra,88(sp)
 636:	6446                	ld	s0,80(sp)
 638:	64a6                	ld	s1,72(sp)
 63a:	6906                	ld	s2,64(sp)
 63c:	79e2                	ld	s3,56(sp)
 63e:	7a42                	ld	s4,48(sp)
 640:	7aa2                	ld	s5,40(sp)
 642:	7b02                	ld	s6,32(sp)
 644:	6be2                	ld	s7,24(sp)
 646:	6125                	add	sp,sp,96
 648:	8082                	ret

000000000000064a <stat>:

int
stat(const char *n, struct stat *st)
{
 64a:	1101                	add	sp,sp,-32
 64c:	ec06                	sd	ra,24(sp)
 64e:	e822                	sd	s0,16(sp)
 650:	e426                	sd	s1,8(sp)
 652:	e04a                	sd	s2,0(sp)
 654:	1000                	add	s0,sp,32
 656:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 658:	4581                	li	a1,0
 65a:	160000ef          	jal	7ba <open>
  if(fd < 0)
 65e:	02054163          	bltz	a0,680 <stat+0x36>
 662:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 664:	85ca                	mv	a1,s2
 666:	16c000ef          	jal	7d2 <fstat>
 66a:	892a                	mv	s2,a0
  close(fd);
 66c:	8526                	mv	a0,s1
 66e:	134000ef          	jal	7a2 <close>
  return r;
}
 672:	854a                	mv	a0,s2
 674:	60e2                	ld	ra,24(sp)
 676:	6442                	ld	s0,16(sp)
 678:	64a2                	ld	s1,8(sp)
 67a:	6902                	ld	s2,0(sp)
 67c:	6105                	add	sp,sp,32
 67e:	8082                	ret
    return -1;
 680:	597d                	li	s2,-1
 682:	bfc5                	j	672 <stat+0x28>

0000000000000684 <atoi>:

int
atoi(const char *s)
{
 684:	1141                	add	sp,sp,-16
 686:	e422                	sd	s0,8(sp)
 688:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 68a:	00054683          	lbu	a3,0(a0)
 68e:	fd06879b          	addw	a5,a3,-48
 692:	0ff7f793          	zext.b	a5,a5
 696:	4625                	li	a2,9
 698:	02f66863          	bltu	a2,a5,6c8 <atoi+0x44>
 69c:	872a                	mv	a4,a0
  n = 0;
 69e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 6a0:	0705                	add	a4,a4,1
 6a2:	0025179b          	sllw	a5,a0,0x2
 6a6:	9fa9                	addw	a5,a5,a0
 6a8:	0017979b          	sllw	a5,a5,0x1
 6ac:	9fb5                	addw	a5,a5,a3
 6ae:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6b2:	00074683          	lbu	a3,0(a4)
 6b6:	fd06879b          	addw	a5,a3,-48
 6ba:	0ff7f793          	zext.b	a5,a5
 6be:	fef671e3          	bgeu	a2,a5,6a0 <atoi+0x1c>
  return n;
}
 6c2:	6422                	ld	s0,8(sp)
 6c4:	0141                	add	sp,sp,16
 6c6:	8082                	ret
  n = 0;
 6c8:	4501                	li	a0,0
 6ca:	bfe5                	j	6c2 <atoi+0x3e>

00000000000006cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6cc:	1141                	add	sp,sp,-16
 6ce:	e422                	sd	s0,8(sp)
 6d0:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6d2:	02b57463          	bgeu	a0,a1,6fa <memmove+0x2e>
    while(n-- > 0)
 6d6:	00c05f63          	blez	a2,6f4 <memmove+0x28>
 6da:	1602                	sll	a2,a2,0x20
 6dc:	9201                	srl	a2,a2,0x20
 6de:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6e2:	872a                	mv	a4,a0
      *dst++ = *src++;
 6e4:	0585                	add	a1,a1,1
 6e6:	0705                	add	a4,a4,1
 6e8:	fff5c683          	lbu	a3,-1(a1)
 6ec:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6f0:	fee79ae3          	bne	a5,a4,6e4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6f4:	6422                	ld	s0,8(sp)
 6f6:	0141                	add	sp,sp,16
 6f8:	8082                	ret
    dst += n;
 6fa:	00c50733          	add	a4,a0,a2
    src += n;
 6fe:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 700:	fec05ae3          	blez	a2,6f4 <memmove+0x28>
 704:	fff6079b          	addw	a5,a2,-1
 708:	1782                	sll	a5,a5,0x20
 70a:	9381                	srl	a5,a5,0x20
 70c:	fff7c793          	not	a5,a5
 710:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 712:	15fd                	add	a1,a1,-1
 714:	177d                	add	a4,a4,-1
 716:	0005c683          	lbu	a3,0(a1)
 71a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 71e:	fee79ae3          	bne	a5,a4,712 <memmove+0x46>
 722:	bfc9                	j	6f4 <memmove+0x28>

0000000000000724 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 724:	1141                	add	sp,sp,-16
 726:	e422                	sd	s0,8(sp)
 728:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 72a:	ca05                	beqz	a2,75a <memcmp+0x36>
 72c:	fff6069b          	addw	a3,a2,-1
 730:	1682                	sll	a3,a3,0x20
 732:	9281                	srl	a3,a3,0x20
 734:	0685                	add	a3,a3,1
 736:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 738:	00054783          	lbu	a5,0(a0)
 73c:	0005c703          	lbu	a4,0(a1)
 740:	00e79863          	bne	a5,a4,750 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 744:	0505                	add	a0,a0,1
    p2++;
 746:	0585                	add	a1,a1,1
  while (n-- > 0) {
 748:	fed518e3          	bne	a0,a3,738 <memcmp+0x14>
  }
  return 0;
 74c:	4501                	li	a0,0
 74e:	a019                	j	754 <memcmp+0x30>
      return *p1 - *p2;
 750:	40e7853b          	subw	a0,a5,a4
}
 754:	6422                	ld	s0,8(sp)
 756:	0141                	add	sp,sp,16
 758:	8082                	ret
  return 0;
 75a:	4501                	li	a0,0
 75c:	bfe5                	j	754 <memcmp+0x30>

000000000000075e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 75e:	1141                	add	sp,sp,-16
 760:	e406                	sd	ra,8(sp)
 762:	e022                	sd	s0,0(sp)
 764:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 766:	f67ff0ef          	jal	6cc <memmove>
}
 76a:	60a2                	ld	ra,8(sp)
 76c:	6402                	ld	s0,0(sp)
 76e:	0141                	add	sp,sp,16
 770:	8082                	ret

0000000000000772 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 772:	4885                	li	a7,1
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <exit>:
.global exit
exit:
 li a7, SYS_exit
 77a:	4889                	li	a7,2
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <wait>:
.global wait
wait:
 li a7, SYS_wait
 782:	488d                	li	a7,3
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 78a:	4891                	li	a7,4
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <read>:
.global read
read:
 li a7, SYS_read
 792:	4895                	li	a7,5
 ecall
 794:	00000073          	ecall
 ret
 798:	8082                	ret

000000000000079a <write>:
.global write
write:
 li a7, SYS_write
 79a:	48c1                	li	a7,16
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <close>:
.global close
close:
 li a7, SYS_close
 7a2:	48d5                	li	a7,21
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <kill>:
.global kill
kill:
 li a7, SYS_kill
 7aa:	4899                	li	a7,6
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 7b2:	489d                	li	a7,7
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	8082                	ret

00000000000007ba <open>:
.global open
open:
 li a7, SYS_open
 7ba:	48bd                	li	a7,15
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7c2:	48c5                	li	a7,17
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7ca:	48c9                	li	a7,18
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7d2:	48a1                	li	a7,8
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	8082                	ret

00000000000007da <link>:
.global link
link:
 li a7, SYS_link
 7da:	48cd                	li	a7,19
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7e2:	48d1                	li	a7,20
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7ea:	48a5                	li	a7,9
 ecall
 7ec:	00000073          	ecall
 ret
 7f0:	8082                	ret

00000000000007f2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7f2:	48a9                	li	a7,10
 ecall
 7f4:	00000073          	ecall
 ret
 7f8:	8082                	ret

00000000000007fa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7fa:	48ad                	li	a7,11
 ecall
 7fc:	00000073          	ecall
 ret
 800:	8082                	ret

0000000000000802 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 802:	48b1                	li	a7,12
 ecall
 804:	00000073          	ecall
 ret
 808:	8082                	ret

000000000000080a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 80a:	48b5                	li	a7,13
 ecall
 80c:	00000073          	ecall
 ret
 810:	8082                	ret

0000000000000812 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 812:	48b9                	li	a7,14
 ecall
 814:	00000073          	ecall
 ret
 818:	8082                	ret

000000000000081a <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 81a:	48d9                	li	a7,22
 ecall
 81c:	00000073          	ecall
 ret
 820:	8082                	ret

0000000000000822 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 822:	48e1                	li	a7,24
 ecall
 824:	00000073          	ecall
 ret
 828:	8082                	ret

000000000000082a <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 82a:	48dd                	li	a7,23
 ecall
 82c:	00000073          	ecall
 ret
 830:	8082                	ret

0000000000000832 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 832:	48e5                	li	a7,25
 ecall
 834:	00000073          	ecall
 ret
 838:	8082                	ret

000000000000083a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 83a:	1101                	add	sp,sp,-32
 83c:	ec06                	sd	ra,24(sp)
 83e:	e822                	sd	s0,16(sp)
 840:	1000                	add	s0,sp,32
 842:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 846:	4605                	li	a2,1
 848:	fef40593          	add	a1,s0,-17
 84c:	f4fff0ef          	jal	79a <write>
}
 850:	60e2                	ld	ra,24(sp)
 852:	6442                	ld	s0,16(sp)
 854:	6105                	add	sp,sp,32
 856:	8082                	ret

0000000000000858 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 858:	7139                	add	sp,sp,-64
 85a:	fc06                	sd	ra,56(sp)
 85c:	f822                	sd	s0,48(sp)
 85e:	f426                	sd	s1,40(sp)
 860:	f04a                	sd	s2,32(sp)
 862:	ec4e                	sd	s3,24(sp)
 864:	0080                	add	s0,sp,64
 866:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 868:	c299                	beqz	a3,86e <printint+0x16>
 86a:	0805c763          	bltz	a1,8f8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 86e:	2581                	sext.w	a1,a1
  neg = 0;
 870:	4881                	li	a7,0
 872:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 876:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 878:	2601                	sext.w	a2,a2
 87a:	00000517          	auipc	a0,0x0
 87e:	5de50513          	add	a0,a0,1502 # e58 <digits>
 882:	883a                	mv	a6,a4
 884:	2705                	addw	a4,a4,1
 886:	02c5f7bb          	remuw	a5,a1,a2
 88a:	1782                	sll	a5,a5,0x20
 88c:	9381                	srl	a5,a5,0x20
 88e:	97aa                	add	a5,a5,a0
 890:	0007c783          	lbu	a5,0(a5)
 894:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 898:	0005879b          	sext.w	a5,a1
 89c:	02c5d5bb          	divuw	a1,a1,a2
 8a0:	0685                	add	a3,a3,1
 8a2:	fec7f0e3          	bgeu	a5,a2,882 <printint+0x2a>
  if(neg)
 8a6:	00088c63          	beqz	a7,8be <printint+0x66>
    buf[i++] = '-';
 8aa:	fd070793          	add	a5,a4,-48
 8ae:	00878733          	add	a4,a5,s0
 8b2:	02d00793          	li	a5,45
 8b6:	fef70823          	sb	a5,-16(a4)
 8ba:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 8be:	02e05663          	blez	a4,8ea <printint+0x92>
 8c2:	fc040793          	add	a5,s0,-64
 8c6:	00e78933          	add	s2,a5,a4
 8ca:	fff78993          	add	s3,a5,-1
 8ce:	99ba                	add	s3,s3,a4
 8d0:	377d                	addw	a4,a4,-1
 8d2:	1702                	sll	a4,a4,0x20
 8d4:	9301                	srl	a4,a4,0x20
 8d6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 8da:	fff94583          	lbu	a1,-1(s2)
 8de:	8526                	mv	a0,s1
 8e0:	f5bff0ef          	jal	83a <putc>
  while(--i >= 0)
 8e4:	197d                	add	s2,s2,-1
 8e6:	ff391ae3          	bne	s2,s3,8da <printint+0x82>
}
 8ea:	70e2                	ld	ra,56(sp)
 8ec:	7442                	ld	s0,48(sp)
 8ee:	74a2                	ld	s1,40(sp)
 8f0:	7902                	ld	s2,32(sp)
 8f2:	69e2                	ld	s3,24(sp)
 8f4:	6121                	add	sp,sp,64
 8f6:	8082                	ret
    x = -xx;
 8f8:	40b005bb          	negw	a1,a1
    neg = 1;
 8fc:	4885                	li	a7,1
    x = -xx;
 8fe:	bf95                	j	872 <printint+0x1a>

0000000000000900 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 900:	711d                	add	sp,sp,-96
 902:	ec86                	sd	ra,88(sp)
 904:	e8a2                	sd	s0,80(sp)
 906:	e4a6                	sd	s1,72(sp)
 908:	e0ca                	sd	s2,64(sp)
 90a:	fc4e                	sd	s3,56(sp)
 90c:	f852                	sd	s4,48(sp)
 90e:	f456                	sd	s5,40(sp)
 910:	f05a                	sd	s6,32(sp)
 912:	ec5e                	sd	s7,24(sp)
 914:	e862                	sd	s8,16(sp)
 916:	e466                	sd	s9,8(sp)
 918:	e06a                	sd	s10,0(sp)
 91a:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 91c:	0005c903          	lbu	s2,0(a1)
 920:	24090763          	beqz	s2,b6e <vprintf+0x26e>
 924:	8b2a                	mv	s6,a0
 926:	8a2e                	mv	s4,a1
 928:	8bb2                	mv	s7,a2
  state = 0;
 92a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 92c:	4481                	li	s1,0
 92e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 930:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 934:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 938:	06c00c93          	li	s9,108
 93c:	a005                	j	95c <vprintf+0x5c>
        putc(fd, c0);
 93e:	85ca                	mv	a1,s2
 940:	855a                	mv	a0,s6
 942:	ef9ff0ef          	jal	83a <putc>
 946:	a019                	j	94c <vprintf+0x4c>
    } else if(state == '%'){
 948:	03598263          	beq	s3,s5,96c <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 94c:	2485                	addw	s1,s1,1
 94e:	8726                	mv	a4,s1
 950:	009a07b3          	add	a5,s4,s1
 954:	0007c903          	lbu	s2,0(a5)
 958:	20090b63          	beqz	s2,b6e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 95c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 960:	fe0994e3          	bnez	s3,948 <vprintf+0x48>
      if(c0 == '%'){
 964:	fd579de3          	bne	a5,s5,93e <vprintf+0x3e>
        state = '%';
 968:	89be                	mv	s3,a5
 96a:	b7cd                	j	94c <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 96c:	c7c9                	beqz	a5,9f6 <vprintf+0xf6>
 96e:	00ea06b3          	add	a3,s4,a4
 972:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 976:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 978:	c681                	beqz	a3,980 <vprintf+0x80>
 97a:	9752                	add	a4,a4,s4
 97c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 980:	03878f63          	beq	a5,s8,9be <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 984:	05978963          	beq	a5,s9,9d6 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 988:	07500713          	li	a4,117
 98c:	0ee78363          	beq	a5,a4,a72 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 990:	07800713          	li	a4,120
 994:	12e78563          	beq	a5,a4,abe <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 998:	07000713          	li	a4,112
 99c:	14e78a63          	beq	a5,a4,af0 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 9a0:	07300713          	li	a4,115
 9a4:	18e78863          	beq	a5,a4,b34 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 9a8:	02500713          	li	a4,37
 9ac:	04e79563          	bne	a5,a4,9f6 <vprintf+0xf6>
        putc(fd, '%');
 9b0:	02500593          	li	a1,37
 9b4:	855a                	mv	a0,s6
 9b6:	e85ff0ef          	jal	83a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 9ba:	4981                	li	s3,0
 9bc:	bf41                	j	94c <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 9be:	008b8913          	add	s2,s7,8
 9c2:	4685                	li	a3,1
 9c4:	4629                	li	a2,10
 9c6:	000ba583          	lw	a1,0(s7)
 9ca:	855a                	mv	a0,s6
 9cc:	e8dff0ef          	jal	858 <printint>
 9d0:	8bca                	mv	s7,s2
      state = 0;
 9d2:	4981                	li	s3,0
 9d4:	bfa5                	j	94c <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 9d6:	06400793          	li	a5,100
 9da:	02f68963          	beq	a3,a5,a0c <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9de:	06c00793          	li	a5,108
 9e2:	04f68263          	beq	a3,a5,a26 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 9e6:	07500793          	li	a5,117
 9ea:	0af68063          	beq	a3,a5,a8a <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 9ee:	07800793          	li	a5,120
 9f2:	0ef68263          	beq	a3,a5,ad6 <vprintf+0x1d6>
        putc(fd, '%');
 9f6:	02500593          	li	a1,37
 9fa:	855a                	mv	a0,s6
 9fc:	e3fff0ef          	jal	83a <putc>
        putc(fd, c0);
 a00:	85ca                	mv	a1,s2
 a02:	855a                	mv	a0,s6
 a04:	e37ff0ef          	jal	83a <putc>
      state = 0;
 a08:	4981                	li	s3,0
 a0a:	b789                	j	94c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a0c:	008b8913          	add	s2,s7,8
 a10:	4685                	li	a3,1
 a12:	4629                	li	a2,10
 a14:	000ba583          	lw	a1,0(s7)
 a18:	855a                	mv	a0,s6
 a1a:	e3fff0ef          	jal	858 <printint>
        i += 1;
 a1e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a20:	8bca                	mv	s7,s2
      state = 0;
 a22:	4981                	li	s3,0
        i += 1;
 a24:	b725                	j	94c <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a26:	06400793          	li	a5,100
 a2a:	02f60763          	beq	a2,a5,a58 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a2e:	07500793          	li	a5,117
 a32:	06f60963          	beq	a2,a5,aa4 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a36:	07800793          	li	a5,120
 a3a:	faf61ee3          	bne	a2,a5,9f6 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a3e:	008b8913          	add	s2,s7,8
 a42:	4681                	li	a3,0
 a44:	4641                	li	a2,16
 a46:	000ba583          	lw	a1,0(s7)
 a4a:	855a                	mv	a0,s6
 a4c:	e0dff0ef          	jal	858 <printint>
        i += 2;
 a50:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a52:	8bca                	mv	s7,s2
      state = 0;
 a54:	4981                	li	s3,0
        i += 2;
 a56:	bddd                	j	94c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a58:	008b8913          	add	s2,s7,8
 a5c:	4685                	li	a3,1
 a5e:	4629                	li	a2,10
 a60:	000ba583          	lw	a1,0(s7)
 a64:	855a                	mv	a0,s6
 a66:	df3ff0ef          	jal	858 <printint>
        i += 2;
 a6a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a6c:	8bca                	mv	s7,s2
      state = 0;
 a6e:	4981                	li	s3,0
        i += 2;
 a70:	bdf1                	j	94c <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 a72:	008b8913          	add	s2,s7,8
 a76:	4681                	li	a3,0
 a78:	4629                	li	a2,10
 a7a:	000ba583          	lw	a1,0(s7)
 a7e:	855a                	mv	a0,s6
 a80:	dd9ff0ef          	jal	858 <printint>
 a84:	8bca                	mv	s7,s2
      state = 0;
 a86:	4981                	li	s3,0
 a88:	b5d1                	j	94c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a8a:	008b8913          	add	s2,s7,8
 a8e:	4681                	li	a3,0
 a90:	4629                	li	a2,10
 a92:	000ba583          	lw	a1,0(s7)
 a96:	855a                	mv	a0,s6
 a98:	dc1ff0ef          	jal	858 <printint>
        i += 1;
 a9c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a9e:	8bca                	mv	s7,s2
      state = 0;
 aa0:	4981                	li	s3,0
        i += 1;
 aa2:	b56d                	j	94c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 aa4:	008b8913          	add	s2,s7,8
 aa8:	4681                	li	a3,0
 aaa:	4629                	li	a2,10
 aac:	000ba583          	lw	a1,0(s7)
 ab0:	855a                	mv	a0,s6
 ab2:	da7ff0ef          	jal	858 <printint>
        i += 2;
 ab6:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 ab8:	8bca                	mv	s7,s2
      state = 0;
 aba:	4981                	li	s3,0
        i += 2;
 abc:	bd41                	j	94c <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 abe:	008b8913          	add	s2,s7,8
 ac2:	4681                	li	a3,0
 ac4:	4641                	li	a2,16
 ac6:	000ba583          	lw	a1,0(s7)
 aca:	855a                	mv	a0,s6
 acc:	d8dff0ef          	jal	858 <printint>
 ad0:	8bca                	mv	s7,s2
      state = 0;
 ad2:	4981                	li	s3,0
 ad4:	bda5                	j	94c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 ad6:	008b8913          	add	s2,s7,8
 ada:	4681                	li	a3,0
 adc:	4641                	li	a2,16
 ade:	000ba583          	lw	a1,0(s7)
 ae2:	855a                	mv	a0,s6
 ae4:	d75ff0ef          	jal	858 <printint>
        i += 1;
 ae8:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 aea:	8bca                	mv	s7,s2
      state = 0;
 aec:	4981                	li	s3,0
        i += 1;
 aee:	bdb9                	j	94c <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 af0:	008b8d13          	add	s10,s7,8
 af4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 af8:	03000593          	li	a1,48
 afc:	855a                	mv	a0,s6
 afe:	d3dff0ef          	jal	83a <putc>
  putc(fd, 'x');
 b02:	07800593          	li	a1,120
 b06:	855a                	mv	a0,s6
 b08:	d33ff0ef          	jal	83a <putc>
 b0c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b0e:	00000b97          	auipc	s7,0x0
 b12:	34ab8b93          	add	s7,s7,842 # e58 <digits>
 b16:	03c9d793          	srl	a5,s3,0x3c
 b1a:	97de                	add	a5,a5,s7
 b1c:	0007c583          	lbu	a1,0(a5)
 b20:	855a                	mv	a0,s6
 b22:	d19ff0ef          	jal	83a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b26:	0992                	sll	s3,s3,0x4
 b28:	397d                	addw	s2,s2,-1
 b2a:	fe0916e3          	bnez	s2,b16 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 b2e:	8bea                	mv	s7,s10
      state = 0;
 b30:	4981                	li	s3,0
 b32:	bd29                	j	94c <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 b34:	008b8993          	add	s3,s7,8
 b38:	000bb903          	ld	s2,0(s7)
 b3c:	00090f63          	beqz	s2,b5a <vprintf+0x25a>
        for(; *s; s++)
 b40:	00094583          	lbu	a1,0(s2)
 b44:	c195                	beqz	a1,b68 <vprintf+0x268>
          putc(fd, *s);
 b46:	855a                	mv	a0,s6
 b48:	cf3ff0ef          	jal	83a <putc>
        for(; *s; s++)
 b4c:	0905                	add	s2,s2,1
 b4e:	00094583          	lbu	a1,0(s2)
 b52:	f9f5                	bnez	a1,b46 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b54:	8bce                	mv	s7,s3
      state = 0;
 b56:	4981                	li	s3,0
 b58:	bbd5                	j	94c <vprintf+0x4c>
          s = "(null)";
 b5a:	00000917          	auipc	s2,0x0
 b5e:	2f690913          	add	s2,s2,758 # e50 <malloc+0x1e8>
        for(; *s; s++)
 b62:	02800593          	li	a1,40
 b66:	b7c5                	j	b46 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b68:	8bce                	mv	s7,s3
      state = 0;
 b6a:	4981                	li	s3,0
 b6c:	b3c5                	j	94c <vprintf+0x4c>
    }
  }
}
 b6e:	60e6                	ld	ra,88(sp)
 b70:	6446                	ld	s0,80(sp)
 b72:	64a6                	ld	s1,72(sp)
 b74:	6906                	ld	s2,64(sp)
 b76:	79e2                	ld	s3,56(sp)
 b78:	7a42                	ld	s4,48(sp)
 b7a:	7aa2                	ld	s5,40(sp)
 b7c:	7b02                	ld	s6,32(sp)
 b7e:	6be2                	ld	s7,24(sp)
 b80:	6c42                	ld	s8,16(sp)
 b82:	6ca2                	ld	s9,8(sp)
 b84:	6d02                	ld	s10,0(sp)
 b86:	6125                	add	sp,sp,96
 b88:	8082                	ret

0000000000000b8a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b8a:	715d                	add	sp,sp,-80
 b8c:	ec06                	sd	ra,24(sp)
 b8e:	e822                	sd	s0,16(sp)
 b90:	1000                	add	s0,sp,32
 b92:	e010                	sd	a2,0(s0)
 b94:	e414                	sd	a3,8(s0)
 b96:	e818                	sd	a4,16(s0)
 b98:	ec1c                	sd	a5,24(s0)
 b9a:	03043023          	sd	a6,32(s0)
 b9e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 ba2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 ba6:	8622                	mv	a2,s0
 ba8:	d59ff0ef          	jal	900 <vprintf>
}
 bac:	60e2                	ld	ra,24(sp)
 bae:	6442                	ld	s0,16(sp)
 bb0:	6161                	add	sp,sp,80
 bb2:	8082                	ret

0000000000000bb4 <printf>:

void
printf(const char *fmt, ...)
{
 bb4:	711d                	add	sp,sp,-96
 bb6:	ec06                	sd	ra,24(sp)
 bb8:	e822                	sd	s0,16(sp)
 bba:	1000                	add	s0,sp,32
 bbc:	e40c                	sd	a1,8(s0)
 bbe:	e810                	sd	a2,16(s0)
 bc0:	ec14                	sd	a3,24(s0)
 bc2:	f018                	sd	a4,32(s0)
 bc4:	f41c                	sd	a5,40(s0)
 bc6:	03043823          	sd	a6,48(s0)
 bca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 bce:	00840613          	add	a2,s0,8
 bd2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 bd6:	85aa                	mv	a1,a0
 bd8:	4505                	li	a0,1
 bda:	d27ff0ef          	jal	900 <vprintf>
}
 bde:	60e2                	ld	ra,24(sp)
 be0:	6442                	ld	s0,16(sp)
 be2:	6125                	add	sp,sp,96
 be4:	8082                	ret

0000000000000be6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 be6:	1141                	add	sp,sp,-16
 be8:	e422                	sd	s0,8(sp)
 bea:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bec:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bf0:	00000797          	auipc	a5,0x0
 bf4:	4207b783          	ld	a5,1056(a5) # 1010 <freep>
 bf8:	a02d                	j	c22 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 bfa:	4618                	lw	a4,8(a2)
 bfc:	9f2d                	addw	a4,a4,a1
 bfe:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c02:	6398                	ld	a4,0(a5)
 c04:	6310                	ld	a2,0(a4)
 c06:	a83d                	j	c44 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c08:	ff852703          	lw	a4,-8(a0)
 c0c:	9f31                	addw	a4,a4,a2
 c0e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c10:	ff053683          	ld	a3,-16(a0)
 c14:	a091                	j	c58 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c16:	6398                	ld	a4,0(a5)
 c18:	00e7e463          	bltu	a5,a4,c20 <free+0x3a>
 c1c:	00e6ea63          	bltu	a3,a4,c30 <free+0x4a>
{
 c20:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c22:	fed7fae3          	bgeu	a5,a3,c16 <free+0x30>
 c26:	6398                	ld	a4,0(a5)
 c28:	00e6e463          	bltu	a3,a4,c30 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c2c:	fee7eae3          	bltu	a5,a4,c20 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 c30:	ff852583          	lw	a1,-8(a0)
 c34:	6390                	ld	a2,0(a5)
 c36:	02059813          	sll	a6,a1,0x20
 c3a:	01c85713          	srl	a4,a6,0x1c
 c3e:	9736                	add	a4,a4,a3
 c40:	fae60de3          	beq	a2,a4,bfa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 c44:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c48:	4790                	lw	a2,8(a5)
 c4a:	02061593          	sll	a1,a2,0x20
 c4e:	01c5d713          	srl	a4,a1,0x1c
 c52:	973e                	add	a4,a4,a5
 c54:	fae68ae3          	beq	a3,a4,c08 <free+0x22>
    p->s.ptr = bp->s.ptr;
 c58:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c5a:	00000717          	auipc	a4,0x0
 c5e:	3af73b23          	sd	a5,950(a4) # 1010 <freep>
}
 c62:	6422                	ld	s0,8(sp)
 c64:	0141                	add	sp,sp,16
 c66:	8082                	ret

0000000000000c68 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c68:	7139                	add	sp,sp,-64
 c6a:	fc06                	sd	ra,56(sp)
 c6c:	f822                	sd	s0,48(sp)
 c6e:	f426                	sd	s1,40(sp)
 c70:	f04a                	sd	s2,32(sp)
 c72:	ec4e                	sd	s3,24(sp)
 c74:	e852                	sd	s4,16(sp)
 c76:	e456                	sd	s5,8(sp)
 c78:	e05a                	sd	s6,0(sp)
 c7a:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c7c:	02051493          	sll	s1,a0,0x20
 c80:	9081                	srl	s1,s1,0x20
 c82:	04bd                	add	s1,s1,15
 c84:	8091                	srl	s1,s1,0x4
 c86:	0014899b          	addw	s3,s1,1
 c8a:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 c8c:	00000517          	auipc	a0,0x0
 c90:	38453503          	ld	a0,900(a0) # 1010 <freep>
 c94:	c515                	beqz	a0,cc0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c96:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c98:	4798                	lw	a4,8(a5)
 c9a:	02977f63          	bgeu	a4,s1,cd8 <malloc+0x70>
  if(nu < 4096)
 c9e:	8a4e                	mv	s4,s3
 ca0:	0009871b          	sext.w	a4,s3
 ca4:	6685                	lui	a3,0x1
 ca6:	00d77363          	bgeu	a4,a3,cac <malloc+0x44>
 caa:	6a05                	lui	s4,0x1
 cac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 cb0:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 cb4:	00000917          	auipc	s2,0x0
 cb8:	35c90913          	add	s2,s2,860 # 1010 <freep>
  if(p == (char*)-1)
 cbc:	5afd                	li	s5,-1
 cbe:	a885                	j	d2e <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 cc0:	00000797          	auipc	a5,0x0
 cc4:	36078793          	add	a5,a5,864 # 1020 <base>
 cc8:	00000717          	auipc	a4,0x0
 ccc:	34f73423          	sd	a5,840(a4) # 1010 <freep>
 cd0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 cd2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 cd6:	b7e1                	j	c9e <malloc+0x36>
      if(p->s.size == nunits)
 cd8:	02e48c63          	beq	s1,a4,d10 <malloc+0xa8>
        p->s.size -= nunits;
 cdc:	4137073b          	subw	a4,a4,s3
 ce0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ce2:	02071693          	sll	a3,a4,0x20
 ce6:	01c6d713          	srl	a4,a3,0x1c
 cea:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 cec:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 cf0:	00000717          	auipc	a4,0x0
 cf4:	32a73023          	sd	a0,800(a4) # 1010 <freep>
      return (void*)(p + 1);
 cf8:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 cfc:	70e2                	ld	ra,56(sp)
 cfe:	7442                	ld	s0,48(sp)
 d00:	74a2                	ld	s1,40(sp)
 d02:	7902                	ld	s2,32(sp)
 d04:	69e2                	ld	s3,24(sp)
 d06:	6a42                	ld	s4,16(sp)
 d08:	6aa2                	ld	s5,8(sp)
 d0a:	6b02                	ld	s6,0(sp)
 d0c:	6121                	add	sp,sp,64
 d0e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 d10:	6398                	ld	a4,0(a5)
 d12:	e118                	sd	a4,0(a0)
 d14:	bff1                	j	cf0 <malloc+0x88>
  hp->s.size = nu;
 d16:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d1a:	0541                	add	a0,a0,16
 d1c:	ecbff0ef          	jal	be6 <free>
  return freep;
 d20:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d24:	dd61                	beqz	a0,cfc <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d26:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d28:	4798                	lw	a4,8(a5)
 d2a:	fa9777e3          	bgeu	a4,s1,cd8 <malloc+0x70>
    if(p == freep)
 d2e:	00093703          	ld	a4,0(s2)
 d32:	853e                	mv	a0,a5
 d34:	fef719e3          	bne	a4,a5,d26 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 d38:	8552                	mv	a0,s4
 d3a:	ac9ff0ef          	jal	802 <sbrk>
  if(p == (char*)-1)
 d3e:	fd551ce3          	bne	a0,s5,d16 <malloc+0xae>
        return 0;
 d42:	4501                	li	a0,0
 d44:	bf65                	j	cfc <malloc+0x94>
