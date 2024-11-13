
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
  74:	7171                	add	sp,sp,-176
  76:	f506                	sd	ra,168(sp)
  78:	f122                	sd	s0,160(sp)
  7a:	ed26                	sd	s1,152(sp)
  7c:	e94a                	sd	s2,144(sp)
  7e:	e54e                	sd	s3,136(sp)
  80:	e152                	sd	s4,128(sp)
  82:	fcd6                	sd	s5,120(sp)
  84:	f8da                	sd	s6,112(sp)
  86:	f4de                	sd	s7,104(sp)
  88:	f0e2                	sd	s8,96(sp)
  8a:	ece6                	sd	s9,88(sp)
  8c:	e8ea                	sd	s10,80(sp)
  8e:	e4ee                	sd	s11,72(sp)
  90:	1900                	add	s0,sp,176
    //30 rodadas
    int  t0_rodada, tempo_atual, t0_total = uptime_nolock();
  92:	744000ef          	jal	7d6 <uptime_nolock>
  96:	f4a43c23          	sd	a0,-168(s0)
    char *args[2];

    for (int i = 1; i <= 30; i++){
  9a:	4d85                	li	s11,1
                } else {       //pai
                    set_type(CPU_BOUND, pid);
                }
            } else {
                //IO-BOUND
                args[0] = "rows";
  9c:	00001b97          	auipc	s7,0x1
  a0:	c8cb8b93          	add	s7,s7,-884 # d28 <malloc+0x114>
                args[0] = "graphs";
  a4:	00001b17          	auipc	s6,0x1
  a8:	c5cb0b13          	add	s6,s6,-932 # d00 <malloc+0xec>
        }

        //pegando max e min
        int lim = segundo_atual;
        long long vazao_max = -10;
        long long vazao_min = 10000;
  ac:	6789                	lui	a5,0x2
  ae:	71078793          	add	a5,a5,1808 # 2710 <base+0x16f0>
  b2:	f6f43023          	sd	a5,-160(s0)
  b6:	a6bd                	j	424 <main+0x3b0>
                index_str[1] = index + '0';
  b8:	02f4879b          	addw	a5,s1,47
  bc:	0ff7f793          	zext.b	a5,a5
                index_str[2] = '\0';
  c0:	86ea                	mv	a3,s10
  c2:	a025                	j	ea <main+0x76>
                    set_type(CPU_BOUND, pid);
  c4:	85aa                	mv	a1,a0
  c6:	4509                	li	a0,2
  c8:	716000ef          	jal	7de <set_type>
        for (int j = 1; j < 21; j++){
  cc:	2485                	addw	s1,s1,1
  ce:	47d5                	li	a5,21
  d0:	08f48663          	beq	s1,a5,15c <main+0xe8>
            if (index < 10) {
  d4:	0004871b          	sext.w	a4,s1
  d8:	fff4879b          	addw	a5,s1,-1
  dc:	fcf9dee3          	bge	s3,a5,b8 <main+0x44>
                index_str[1] = (index - 10) + '0';
  e0:	0254879b          	addw	a5,s1,37
  e4:	0ff7f793          	zext.b	a5,a5
  e8:	86e2                	mv	a3,s8
                index_str[0] = '0';
  ea:	f6d40c23          	sb	a3,-136(s0)
                index_str[1] = index + '0';
  ee:	f6f40ca3          	sb	a5,-135(s0)
                index_str[2] = '\0';
  f2:	f6040d23          	sb	zero,-134(s0)
            args[1] = index_str;
  f6:	f9243423          	sd	s2,-120(s0)
            if (j <= X){
  fa:	02ea6763          	bltu	s4,a4,128 <main+0xb4>
                args[0] = "graphs";
  fe:	f9643023          	sd	s6,-128(s0)
                pid = fork();
 102:	5f4000ef          	jal	6f6 <fork>
                if (pid == 0){ //filho
 106:	fd5d                	bnez	a0,c4 <main+0x50>
                    ret = exec("graphs", args);
 108:	f8040593          	add	a1,s0,-128
 10c:	855a                	mv	a0,s6
 10e:	628000ef          	jal	736 <exec>
                    if (ret == -1){
 112:	fb951de3          	bne	a0,s9,cc <main+0x58>
                        printf("erro ao executar graphs.c\n");
 116:	00001517          	auipc	a0,0x1
 11a:	bf250513          	add	a0,a0,-1038 # d08 <malloc+0xf4>
 11e:	243000ef          	jal	b60 <printf>
                        exit(1);
 122:	4505                	li	a0,1
 124:	5da000ef          	jal	6fe <exit>
                args[0] = "rows";
 128:	f9743023          	sd	s7,-128(s0)
                pid = fork();
 12c:	5ca000ef          	jal	6f6 <fork>
                if (pid == 0){ //filho
 130:	e10d                	bnez	a0,152 <main+0xde>
                    ret = exec("rows", args);
 132:	f8040593          	add	a1,s0,-128
 136:	855e                	mv	a0,s7
 138:	5fe000ef          	jal	736 <exec>
                    if (ret == -1){
 13c:	f99518e3          	bne	a0,s9,cc <main+0x58>
                        printf("erro ao executar rows.c\n");
 140:	00001517          	auipc	a0,0x1
 144:	bf050513          	add	a0,a0,-1040 # d30 <malloc+0x11c>
 148:	219000ef          	jal	b60 <printf>
                        exit(1);
 14c:	4505                	li	a0,1
 14e:	5b0000ef          	jal	6fe <exit>
                    set_type(IO_BOUND, pid);
 152:	85aa                	mv	a1,a0
 154:	450d                	li	a0,3
 156:	688000ef          	jal	7de <set_type>
 15a:	bf8d                	j	cc <main+0x58>
        int *terminos = malloc(20 * sizeof(int));
 15c:	05000513          	li	a0,80
 160:	2b5000ef          	jal	c14 <malloc>
 164:	8a2a                	mv	s4,a0
        for (int j = 0; j < 20; j++){
 166:	05050993          	add	s3,a0,80
        int *terminos = malloc(20 * sizeof(int));
 16a:	84aa                	mv	s1,a0
            if (proc == -1){
 16c:	597d                	li	s2,-1
                printf("pocesso falhou");
 16e:	00001c17          	auipc	s8,0x1
 172:	be2c0c13          	add	s8,s8,-1054 # d50 <malloc+0x13c>
 176:	a809                	j	188 <main+0x114>
                tempo_atual = uptime_nolock();
 178:	65e000ef          	jal	7d6 <uptime_nolock>
                terminos[j] = (tempo_atual - t0_rodada);
 17c:	4155053b          	subw	a0,a0,s5
 180:	c088                	sw	a0,0(s1)
        for (int j = 0; j < 20; j++){
 182:	0491                	add	s1,s1,4
 184:	01348b63          	beq	s1,s3,19a <main+0x126>
            proc = wait(0);
 188:	4501                	li	a0,0
 18a:	57c000ef          	jal	706 <wait>
            if (proc == -1){
 18e:	ff2515e3          	bne	a0,s2,178 <main+0x104>
                printf("pocesso falhou");
 192:	8562                	mv	a0,s8
 194:	1cd000ef          	jal	b60 <printf>
 198:	b7ed                	j	182 <main+0x10e>
        printf("RODADA %d ======================\n", i);
 19a:	85ee                	mv	a1,s11
 19c:	00001517          	auipc	a0,0x1
 1a0:	bc450513          	add	a0,a0,-1084 # d60 <malloc+0x14c>
 1a4:	1bd000ef          	jal	b60 <printf>
        for (int j = 0; j < 20; j++){
 1a8:	004a0593          	add	a1,s4,4
        printf("RODADA %d ======================\n", i);
 1ac:	4801                	li	a6,0
        for (int j = 0; j < 20; j++){
 1ae:	4501                	li	a0,0
            for (int k = j+1; k < 20; k++){
 1b0:	48d1                	li	a7,20
 1b2:	4e4d                	li	t3,19
 1b4:	008a0313          	add	t1,s4,8
 1b8:	a831                	j	1d4 <main+0x160>
 1ba:	0791                	add	a5,a5,4
 1bc:	00d78a63          	beq	a5,a3,1d0 <main+0x15c>
                if (terminos[k] < terminos[j]){
 1c0:	4398                	lw	a4,0(a5)
 1c2:	ffc5a603          	lw	a2,-4(a1)
 1c6:	fec75ae3          	bge	a4,a2,1ba <main+0x146>
                    terminos[j] = terminos[k];
 1ca:	fee5ae23          	sw	a4,-4(a1)
                    terminos[k] = temp;
 1ce:	b7f5                	j	1ba <main+0x146>
        for (int j = 0; j < 20; j++){
 1d0:	0805                	add	a6,a6,1
 1d2:	0591                	add	a1,a1,4
            for (int k = j+1; k < 20; k++){
 1d4:	0015079b          	addw	a5,a0,1
 1d8:	0007851b          	sext.w	a0,a5
 1dc:	01150b63          	beq	a0,a7,1f2 <main+0x17e>
 1e0:	40fe06bb          	subw	a3,t3,a5
 1e4:	1682                	sll	a3,a3,0x20
 1e6:	9281                	srl	a3,a3,0x20
 1e8:	96c2                	add	a3,a3,a6
 1ea:	068a                	sll	a3,a3,0x2
 1ec:	969a                	add	a3,a3,t1
 1ee:	87ae                	mv	a5,a1
 1f0:	bfc1                	j	1c0 <main+0x14c>
        int *vazoes = malloc(300 * sizeof(int));
 1f2:	4b000513          	li	a0,1200
 1f6:	21f000ef          	jal	c14 <malloc>
 1fa:	84aa                	mv	s1,a0
        for (int j = 0; j < 300; j++){
 1fc:	86aa                	mv	a3,a0
 1fe:	4b050713          	add	a4,a0,1200
        int *vazoes = malloc(300 * sizeof(int));
 202:	87aa                	mv	a5,a0
            vazoes[j] = 0;
 204:	0007a023          	sw	zero,0(a5)
        for (int j = 0; j < 300; j++){
 208:	0791                	add	a5,a5,4
 20a:	fef71de3          	bne	a4,a5,204 <main+0x190>
        int segundo_atual = 0;
 20e:	4601                	li	a2,0
        int index = 0;
 210:	4581                	li	a1,0
        while (index < 20){
 212:	454d                	li	a0,19
 214:	a021                	j	21c <main+0x1a8>
                segundo_atual += 1;
 216:	2605                	addw	a2,a2,1
        while (index < 20){
 218:	02b54563          	blt	a0,a1,242 <main+0x1ce>
            if (10 * segundo_atual >= terminos[index]){
 21c:	0026179b          	sllw	a5,a2,0x2
 220:	9fb1                	addw	a5,a5,a2
 222:	00259713          	sll	a4,a1,0x2
 226:	9752                	add	a4,a4,s4
 228:	0017979b          	sllw	a5,a5,0x1
 22c:	4318                	lw	a4,0(a4)
 22e:	fee7c4e3          	blt	a5,a4,216 <main+0x1a2>
                index += 1;
 232:	2585                	addw	a1,a1,1
                vazoes[segundo_atual] += 1;
 234:	00261793          	sll	a5,a2,0x2
 238:	97a6                	add	a5,a5,s1
 23a:	4398                	lw	a4,0(a5)
 23c:	2705                	addw	a4,a4,1 # ffffffff80000001 <base+0xffffffff7fffefe1>
 23e:	c398                	sw	a4,0(a5)
 240:	bfe1                	j	218 <main+0x1a4>
        for (int j = 0; j <= lim; j++){
 242:	02064863          	bltz	a2,272 <main+0x1fe>
 246:	02061793          	sll	a5,a2,0x20
 24a:	01e7d513          	srl	a0,a5,0x1e
 24e:	00448793          	add	a5,s1,4
 252:	953e                	add	a0,a0,a5
        long long vazao_min = 10000;
 254:	f6043583          	ld	a1,-160(s0)
        long long vazao_max = -10;
 258:	5759                	li	a4,-10
 25a:	a021                	j	262 <main+0x1ee>
        for (int j = 0; j <= lim; j++){
 25c:	0691                	add	a3,a3,4
 25e:	00a68d63          	beq	a3,a0,278 <main+0x204>
            if (vazoes[j] < vazao_min) {
 262:	429c                	lw	a5,0(a3)
 264:	00b7d363          	bge	a5,a1,26a <main+0x1f6>
 268:	85be                	mv	a1,a5
                vazao_min = vazoes[j];
            }
            if (vazoes[j] > vazao_max) {
 26a:	fef759e3          	bge	a4,a5,25c <main+0x1e8>
 26e:	873e                	mv	a4,a5
 270:	b7f5                	j	25c <main+0x1e8>
        long long vazao_min = 10000;
 272:	f6043583          	ld	a1,-160(s0)
        long long vazao_max = -10;
 276:	5759                	li	a4,-10
                vazao_max = vazoes[j];
            }
        }

        //normalizando
        long long vazao_media = (20 * 100000) / lim;
 278:	001e8937          	lui	s2,0x1e8
 27c:	4809091b          	addw	s2,s2,1152 # 1e8480 <base+0x1e7460>
 280:	02c9493b          	divw	s2,s2,a2
        vazao_max *= 100000;
        vazao_min *= 100000;
 284:	6c61                	lui	s8,0x18
 286:	6a0c0c13          	add	s8,s8,1696 # 186a0 <base+0x17680>
 28a:	038585b3          	mul	a1,a1,s8

        long long nominador = vazao_media - vazao_min;
 28e:	40b907b3          	sub	a5,s2,a1
        long long denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero

        long long res = 100000 - (nominador * 100000 / denominador);
 292:	038786b3          	mul	a3,a5,s8
        vazao_max *= 100000;
 296:	038707b3          	mul	a5,a4,s8
        long long denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero
 29a:	8f8d                	sub	a5,a5,a1
        long long res = 100000 - (nominador * 100000 / denominador);
 29c:	02f6c7b3          	div	a5,a3,a5
        int vazao_norm = res;
 2a0:	40fc0c3b          	subw	s8,s8,a5
        printf("vazao normalizada: %de-05\n", vazao_norm);
 2a4:	85e2                	mv	a1,s8
 2a6:	00001517          	auipc	a0,0x1
 2aa:	ae250513          	add	a0,a0,-1310 # d88 <malloc+0x174>
 2ae:	0b3000ef          	jal	b60 <printf>
        printf("media: %lld\n", vazao_media);
 2b2:	85ca                	mv	a1,s2
 2b4:	00001517          	auipc	a0,0x1
 2b8:	af450513          	add	a0,a0,-1292 # da8 <malloc+0x194>
 2bc:	0a5000ef          	jal	b60 <printf>

        free(terminos);
 2c0:	8552                	mv	a0,s4
 2c2:	0d1000ef          	jal	b92 <free>
        free(vazoes);
 2c6:	8526                	mv	a0,s1
 2c8:	0cb000ef          	jal	b92 <free>
        

        // EFICIENCIA DO SISTEMA DE ARQUIVOS
        int *eficiencias = malloc(Y * sizeof(int));
 2cc:	f6842783          	lw	a5,-152(s0)
 2d0:	0027951b          	sllw	a0,a5,0x2
 2d4:	141000ef          	jal	c14 <malloc>
 2d8:	89aa                	mv	s3,a0
        
        //lendo os dados da struct processo

        int l = 0;
        int eficiencia_atual;
        for (int k = 0; k < 20; k++){
 2da:	4481                	li	s1,0
        int l = 0;
 2dc:	4901                	li	s2,0
        for (int k = 0; k < 20; k++){
 2de:	4a51                	li	s4,20
 2e0:	a021                	j	2e8 <main+0x274>
 2e2:	2485                	addw	s1,s1,1
 2e4:	01448d63          	beq	s1,s4,2fe <main+0x28a>
            eficiencia_atual = get_eficiencia(k); //graphs.c devolve um valor negativo,
 2e8:	8526                	mv	a0,s1
 2ea:	4bc000ef          	jal	7a6 <get_eficiencia>
            if (eficiencia_atual >= 0 ){         //para que não impacte no cálculo
 2ee:	fe054ae3          	bltz	a0,2e2 <main+0x26e>
                eficiencias[l] = eficiencia_atual;
 2f2:	00291793          	sll	a5,s2,0x2
 2f6:	97ce                	add	a5,a5,s3
 2f8:	c388                	sw	a0,0(a5)
                l += 1;
 2fa:	2905                	addw	s2,s2,1
 2fc:	b7dd                	j	2e2 <main+0x26e>
 2fe:	874e                	mv	a4,s3
 300:	f6843683          	ld	a3,-152(s0)
 304:	02069793          	sll	a5,a3,0x20
 308:	01e7d613          	srl	a2,a5,0x1e
 30c:	964e                	add	a2,a2,s3
            }
        }
        
        //somando
        int eficiencia_soma = 0;
 30e:	4681                	li	a3,0
        
        for(int j = 0; j < Y; j ++){
            eficiencia_soma += eficiencias[j];
 310:	431c                	lw	a5,0(a4)
 312:	9fb5                	addw	a5,a5,a3
 314:	0007869b          	sext.w	a3,a5
        for(int j = 0; j < Y; j ++){
 318:	0711                	add	a4,a4,4
 31a:	fec71be3          	bne	a4,a2,310 <main+0x29c>
        }

        //invertendo
        res = 100000 / eficiencia_soma;
 31e:	6ae1                	lui	s5,0x18
 320:	6a0a8a9b          	addw	s5,s5,1696 # 186a0 <base+0x17680>
 324:	02facabb          	divw	s5,s5,a5
        int eficiencia_fim = res;
        printf("eficiencia: %de-05\n", eficiencia_fim);
 328:	000a859b          	sext.w	a1,s5
 32c:	00001517          	auipc	a0,0x1
 330:	a8c50513          	add	a0,a0,-1396 # db8 <malloc+0x1a4>
 334:	02d000ef          	jal	b60 <printf>
        free(eficiencias);
 338:	854e                	mv	a0,s3
 33a:	059000ef          	jal	b92 <free>


        //OVERHEAD
        int *overheads = malloc(20 * sizeof(int));
 33e:	05000513          	li	a0,80
 342:	0d3000ef          	jal	c14 <malloc>
 346:	8a2a                	mv	s4,a0
        

        //lendo os dados da struct do processo
        int overhead_atual;
        for (int k = 0; k < 20; k++){
 348:	84aa                	mv	s1,a0
        int *overheads = malloc(20 * sizeof(int));
 34a:	89aa                	mv	s3,a0
        for (int k = 0; k < 20; k++){
 34c:	4901                	li	s2,0
 34e:	4cd1                	li	s9,20
            overhead_atual = get_overhead(k);
 350:	854a                	mv	a0,s2
 352:	45c000ef          	jal	7ae <get_overhead>
            overheads[k] = overhead_atual;
 356:	00a9a023          	sw	a0,0(s3)
        for (int k = 0; k < 20; k++){
 35a:	2905                	addw	s2,s2,1
 35c:	0991                	add	s3,s3,4
 35e:	ff9919e3          	bne	s2,s9,350 <main+0x2dc>
 362:	050a0693          	add	a3,s4,80
        }


        int overhead_soma = 0;
 366:	4701                	li	a4,0
        
        for(int j = 0; j < 20; j ++){
            overhead_soma += overheads[j];
 368:	409c                	lw	a5,0(s1)
 36a:	9fb9                	addw	a5,a5,a4
 36c:	0007871b          	sext.w	a4,a5
        for(int j = 0; j < 20; j ++){
 370:	0491                	add	s1,s1,4
 372:	fe969be3          	bne	a3,s1,368 <main+0x2f4>
        }

        //invertendo
        res = (100000 / overhead_soma);
 376:	6ce1                	lui	s9,0x18
 378:	6a0c8c9b          	addw	s9,s9,1696 # 186a0 <base+0x17680>
 37c:	02fcccbb          	divw	s9,s9,a5
        int overhead_fim = res;
        printf("overhead: %de-05\n", overhead_fim);
 380:	000c859b          	sext.w	a1,s9
 384:	00001517          	auipc	a0,0x1
 388:	a4c50513          	add	a0,a0,-1460 # dd0 <malloc+0x1bc>
 38c:	7d4000ef          	jal	b60 <printf>
        free(overheads);
 390:	8552                	mv	a0,s4
 392:	001000ef          	jal	b92 <free>

        //JUSTIÇA
        int *justicas = malloc(20 * sizeof(int));
 396:	05000513          	li	a0,80
 39a:	07b000ef          	jal	c14 <malloc>
 39e:	8d2a                	mv	s10,a0

        //lendo do proc.c
        for (int k = 0; k < 20; k++){
 3a0:	84aa                	mv	s1,a0
        int *justicas = malloc(20 * sizeof(int));
 3a2:	89aa                	mv	s3,a0
        for (int k = 0; k < 20; k++){
 3a4:	4901                	li	s2,0
 3a6:	4a51                	li	s4,20
            justicas[k] = get_justica(k);
 3a8:	854a                	mv	a0,s2
 3aa:	41c000ef          	jal	7c6 <get_justica>
 3ae:	00a9a023          	sw	a0,0(s3)
        for (int k = 0; k < 20; k++){
 3b2:	2905                	addw	s2,s2,1
 3b4:	0991                	add	s3,s3,4
 3b6:	ff4919e3          	bne	s2,s4,3a8 <main+0x334>
 3ba:	050d0613          	add	a2,s10,80
        }

        //somando
        long long justica_soma = 0; 
        long long justica_soma_quadrado = 0;
 3be:	4681                	li	a3,0
        long long justica_soma = 0; 
 3c0:	4701                	li	a4,0
        for (int k = 0; k < 20; k++){
            justica_soma += justicas[k];
 3c2:	409c                	lw	a5,0(s1)
 3c4:	973e                	add	a4,a4,a5
            justica_soma_quadrado += justicas[k] * justicas[k];
 3c6:	02f787bb          	mulw	a5,a5,a5
 3ca:	96be                	add	a3,a3,a5
        for (int k = 0; k < 20; k++){
 3cc:	0491                	add	s1,s1,4
 3ce:	fec49ae3          	bne	s1,a2,3c2 <main+0x34e>
        }

        //normalizando
        long long nominador2 = justica_soma * justica_soma;
 3d2:	02e70733          	mul	a4,a4,a4
        long long denominador2 = 20 * justica_soma_quadrado;
        res = (nominador2 * 100000) / denominador2;
 3d6:	67e1                	lui	a5,0x18
 3d8:	6a078793          	add	a5,a5,1696 # 186a0 <base+0x17680>
 3dc:	02f704b3          	mul	s1,a4,a5
        long long denominador2 = 20 * justica_soma_quadrado;
 3e0:	00269793          	sll	a5,a3,0x2
 3e4:	97b6                	add	a5,a5,a3
 3e6:	078a                	sll	a5,a5,0x2
        res = (nominador2 * 100000) / denominador2;
 3e8:	02f4c4b3          	div	s1,s1,a5
        int justica_fim = res;
 3ec:	2481                	sext.w	s1,s1
        printf("justica : %de-05\n", justica_fim);
 3ee:	85a6                	mv	a1,s1
 3f0:	00001517          	auipc	a0,0x1
 3f4:	9f850513          	add	a0,a0,-1544 # de8 <malloc+0x1d4>
 3f8:	768000ef          	jal	b60 <printf>
        free(justicas);
 3fc:	856a                	mv	a0,s10
 3fe:	794000ef          	jal	b92 <free>

        //DESEMPENHO
        int desempenho = (overhead_fim + eficiencia_fim + vazao_norm + justica_fim);
 402:	019a85bb          	addw	a1,s5,s9
 406:	018585bb          	addw	a1,a1,s8
 40a:	9da5                	addw	a1,a1,s1
        desempenho = desempenho >> 2;
        printf("desempenho: %de-05\n", desempenho);
 40c:	4025d59b          	sraw	a1,a1,0x2
 410:	00001517          	auipc	a0,0x1
 414:	9f050513          	add	a0,a0,-1552 # e00 <malloc+0x1ec>
 418:	748000ef          	jal	b60 <printf>
    for (int i = 1; i <= 30; i++){
 41c:	2d85                	addw	s11,s11,1
 41e:	47fd                	li	a5,31
 420:	02fd8e63          	beq	s11,a5,45c <main+0x3e8>
        initialize_metrics();
 424:	39a000ef          	jal	7be <initialize_metrics>
        t0_rodada = uptime_nolock();
 428:	3ae000ef          	jal	7d6 <uptime_nolock>
 42c:	8aaa                	mv	s5,a0
        uint X = (rand() % 9) + 6;
 42e:	c2bff0ef          	jal	58 <rand>
 432:	47a5                	li	a5,9
 434:	02f567bb          	remw	a5,a0,a5
 438:	2799                	addw	a5,a5,6
 43a:	00078a1b          	sext.w	s4,a5
        uint Y = 20 - X;
 43e:	4751                	li	a4,20
 440:	40f707bb          	subw	a5,a4,a5
 444:	f6f42423          	sw	a5,-152(s0)
        for (int j = 1; j < 21; j++){
 448:	4485                	li	s1,1
            if (index < 10) {
 44a:	49a5                	li	s3,9
                index_str[1] = (index - 10) + '0';
 44c:	03100c13          	li	s8,49
 450:	03000d13          	li	s10,48
            args[1] = index_str;
 454:	f7840913          	add	s2,s0,-136
                    if (ret == -1){
 458:	5cfd                	li	s9,-1
 45a:	b9ad                	j	d4 <main+0x60>
    }

    int t_final = uptime_nolock();
 45c:	37a000ef          	jal	7d6 <uptime_nolock>
    int variação_total = t_final - t0_total;
    printf("Tempo total usado para as 30 rodadas: %d\n", variação_total);
 460:	f5843783          	ld	a5,-168(s0)
 464:	40f505bb          	subw	a1,a0,a5
 468:	00001517          	auipc	a0,0x1
 46c:	9b050513          	add	a0,a0,-1616 # e18 <malloc+0x204>
 470:	6f0000ef          	jal	b60 <printf>
    return 0;
 474:	4501                	li	a0,0
 476:	70aa                	ld	ra,168(sp)
 478:	740a                	ld	s0,160(sp)
 47a:	64ea                	ld	s1,152(sp)
 47c:	694a                	ld	s2,144(sp)
 47e:	69aa                	ld	s3,136(sp)
 480:	6a0a                	ld	s4,128(sp)
 482:	7ae6                	ld	s5,120(sp)
 484:	7b46                	ld	s6,112(sp)
 486:	7ba6                	ld	s7,104(sp)
 488:	7c06                	ld	s8,96(sp)
 48a:	6ce6                	ld	s9,88(sp)
 48c:	6d46                	ld	s10,80(sp)
 48e:	6da6                	ld	s11,72(sp)
 490:	614d                	add	sp,sp,176
 492:	8082                	ret

0000000000000494 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 494:	1141                	add	sp,sp,-16
 496:	e406                	sd	ra,8(sp)
 498:	e022                	sd	s0,0(sp)
 49a:	0800                	add	s0,sp,16
  extern int main();
  main();
 49c:	bd9ff0ef          	jal	74 <main>
  exit(0);
 4a0:	4501                	li	a0,0
 4a2:	25c000ef          	jal	6fe <exit>

00000000000004a6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 4a6:	1141                	add	sp,sp,-16
 4a8:	e422                	sd	s0,8(sp)
 4aa:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4ac:	87aa                	mv	a5,a0
 4ae:	0585                	add	a1,a1,1
 4b0:	0785                	add	a5,a5,1
 4b2:	fff5c703          	lbu	a4,-1(a1)
 4b6:	fee78fa3          	sb	a4,-1(a5)
 4ba:	fb75                	bnez	a4,4ae <strcpy+0x8>
    ;
  return os;
}
 4bc:	6422                	ld	s0,8(sp)
 4be:	0141                	add	sp,sp,16
 4c0:	8082                	ret

00000000000004c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4c2:	1141                	add	sp,sp,-16
 4c4:	e422                	sd	s0,8(sp)
 4c6:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 4c8:	00054783          	lbu	a5,0(a0)
 4cc:	cb91                	beqz	a5,4e0 <strcmp+0x1e>
 4ce:	0005c703          	lbu	a4,0(a1)
 4d2:	00f71763          	bne	a4,a5,4e0 <strcmp+0x1e>
    p++, q++;
 4d6:	0505                	add	a0,a0,1
 4d8:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 4da:	00054783          	lbu	a5,0(a0)
 4de:	fbe5                	bnez	a5,4ce <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4e0:	0005c503          	lbu	a0,0(a1)
}
 4e4:	40a7853b          	subw	a0,a5,a0
 4e8:	6422                	ld	s0,8(sp)
 4ea:	0141                	add	sp,sp,16
 4ec:	8082                	ret

00000000000004ee <strlen>:

uint
strlen(const char *s)
{
 4ee:	1141                	add	sp,sp,-16
 4f0:	e422                	sd	s0,8(sp)
 4f2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4f4:	00054783          	lbu	a5,0(a0)
 4f8:	cf91                	beqz	a5,514 <strlen+0x26>
 4fa:	0505                	add	a0,a0,1
 4fc:	87aa                	mv	a5,a0
 4fe:	86be                	mv	a3,a5
 500:	0785                	add	a5,a5,1
 502:	fff7c703          	lbu	a4,-1(a5)
 506:	ff65                	bnez	a4,4fe <strlen+0x10>
 508:	40a6853b          	subw	a0,a3,a0
 50c:	2505                	addw	a0,a0,1
    ;
  return n;
}
 50e:	6422                	ld	s0,8(sp)
 510:	0141                	add	sp,sp,16
 512:	8082                	ret
  for(n = 0; s[n]; n++)
 514:	4501                	li	a0,0
 516:	bfe5                	j	50e <strlen+0x20>

0000000000000518 <memset>:

void*
memset(void *dst, int c, uint n)
{
 518:	1141                	add	sp,sp,-16
 51a:	e422                	sd	s0,8(sp)
 51c:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 51e:	ca19                	beqz	a2,534 <memset+0x1c>
 520:	87aa                	mv	a5,a0
 522:	1602                	sll	a2,a2,0x20
 524:	9201                	srl	a2,a2,0x20
 526:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 52a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 52e:	0785                	add	a5,a5,1
 530:	fee79de3          	bne	a5,a4,52a <memset+0x12>
  }
  return dst;
}
 534:	6422                	ld	s0,8(sp)
 536:	0141                	add	sp,sp,16
 538:	8082                	ret

000000000000053a <strchr>:

char*
strchr(const char *s, char c)
{
 53a:	1141                	add	sp,sp,-16
 53c:	e422                	sd	s0,8(sp)
 53e:	0800                	add	s0,sp,16
  for(; *s; s++)
 540:	00054783          	lbu	a5,0(a0)
 544:	cb99                	beqz	a5,55a <strchr+0x20>
    if(*s == c)
 546:	00f58763          	beq	a1,a5,554 <strchr+0x1a>
  for(; *s; s++)
 54a:	0505                	add	a0,a0,1
 54c:	00054783          	lbu	a5,0(a0)
 550:	fbfd                	bnez	a5,546 <strchr+0xc>
      return (char*)s;
  return 0;
 552:	4501                	li	a0,0
}
 554:	6422                	ld	s0,8(sp)
 556:	0141                	add	sp,sp,16
 558:	8082                	ret
  return 0;
 55a:	4501                	li	a0,0
 55c:	bfe5                	j	554 <strchr+0x1a>

000000000000055e <gets>:

char*
gets(char *buf, int max)
{
 55e:	711d                	add	sp,sp,-96
 560:	ec86                	sd	ra,88(sp)
 562:	e8a2                	sd	s0,80(sp)
 564:	e4a6                	sd	s1,72(sp)
 566:	e0ca                	sd	s2,64(sp)
 568:	fc4e                	sd	s3,56(sp)
 56a:	f852                	sd	s4,48(sp)
 56c:	f456                	sd	s5,40(sp)
 56e:	f05a                	sd	s6,32(sp)
 570:	ec5e                	sd	s7,24(sp)
 572:	1080                	add	s0,sp,96
 574:	8baa                	mv	s7,a0
 576:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 578:	892a                	mv	s2,a0
 57a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 57c:	4aa9                	li	s5,10
 57e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 580:	89a6                	mv	s3,s1
 582:	2485                	addw	s1,s1,1
 584:	0344d663          	bge	s1,s4,5b0 <gets+0x52>
    cc = read(0, &c, 1);
 588:	4605                	li	a2,1
 58a:	faf40593          	add	a1,s0,-81
 58e:	4501                	li	a0,0
 590:	186000ef          	jal	716 <read>
    if(cc < 1)
 594:	00a05e63          	blez	a0,5b0 <gets+0x52>
    buf[i++] = c;
 598:	faf44783          	lbu	a5,-81(s0)
 59c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5a0:	01578763          	beq	a5,s5,5ae <gets+0x50>
 5a4:	0905                	add	s2,s2,1
 5a6:	fd679de3          	bne	a5,s6,580 <gets+0x22>
  for(i=0; i+1 < max; ){
 5aa:	89a6                	mv	s3,s1
 5ac:	a011                	j	5b0 <gets+0x52>
 5ae:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5b0:	99de                	add	s3,s3,s7
 5b2:	00098023          	sb	zero,0(s3)
  return buf;
}
 5b6:	855e                	mv	a0,s7
 5b8:	60e6                	ld	ra,88(sp)
 5ba:	6446                	ld	s0,80(sp)
 5bc:	64a6                	ld	s1,72(sp)
 5be:	6906                	ld	s2,64(sp)
 5c0:	79e2                	ld	s3,56(sp)
 5c2:	7a42                	ld	s4,48(sp)
 5c4:	7aa2                	ld	s5,40(sp)
 5c6:	7b02                	ld	s6,32(sp)
 5c8:	6be2                	ld	s7,24(sp)
 5ca:	6125                	add	sp,sp,96
 5cc:	8082                	ret

00000000000005ce <stat>:

int
stat(const char *n, struct stat *st)
{
 5ce:	1101                	add	sp,sp,-32
 5d0:	ec06                	sd	ra,24(sp)
 5d2:	e822                	sd	s0,16(sp)
 5d4:	e426                	sd	s1,8(sp)
 5d6:	e04a                	sd	s2,0(sp)
 5d8:	1000                	add	s0,sp,32
 5da:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5dc:	4581                	li	a1,0
 5de:	160000ef          	jal	73e <open>
  if(fd < 0)
 5e2:	02054163          	bltz	a0,604 <stat+0x36>
 5e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5e8:	85ca                	mv	a1,s2
 5ea:	16c000ef          	jal	756 <fstat>
 5ee:	892a                	mv	s2,a0
  close(fd);
 5f0:	8526                	mv	a0,s1
 5f2:	134000ef          	jal	726 <close>
  return r;
}
 5f6:	854a                	mv	a0,s2
 5f8:	60e2                	ld	ra,24(sp)
 5fa:	6442                	ld	s0,16(sp)
 5fc:	64a2                	ld	s1,8(sp)
 5fe:	6902                	ld	s2,0(sp)
 600:	6105                	add	sp,sp,32
 602:	8082                	ret
    return -1;
 604:	597d                	li	s2,-1
 606:	bfc5                	j	5f6 <stat+0x28>

0000000000000608 <atoi>:

int
atoi(const char *s)
{
 608:	1141                	add	sp,sp,-16
 60a:	e422                	sd	s0,8(sp)
 60c:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 60e:	00054683          	lbu	a3,0(a0)
 612:	fd06879b          	addw	a5,a3,-48
 616:	0ff7f793          	zext.b	a5,a5
 61a:	4625                	li	a2,9
 61c:	02f66863          	bltu	a2,a5,64c <atoi+0x44>
 620:	872a                	mv	a4,a0
  n = 0;
 622:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 624:	0705                	add	a4,a4,1
 626:	0025179b          	sllw	a5,a0,0x2
 62a:	9fa9                	addw	a5,a5,a0
 62c:	0017979b          	sllw	a5,a5,0x1
 630:	9fb5                	addw	a5,a5,a3
 632:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 636:	00074683          	lbu	a3,0(a4)
 63a:	fd06879b          	addw	a5,a3,-48
 63e:	0ff7f793          	zext.b	a5,a5
 642:	fef671e3          	bgeu	a2,a5,624 <atoi+0x1c>
  return n;
}
 646:	6422                	ld	s0,8(sp)
 648:	0141                	add	sp,sp,16
 64a:	8082                	ret
  n = 0;
 64c:	4501                	li	a0,0
 64e:	bfe5                	j	646 <atoi+0x3e>

0000000000000650 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 650:	1141                	add	sp,sp,-16
 652:	e422                	sd	s0,8(sp)
 654:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 656:	02b57463          	bgeu	a0,a1,67e <memmove+0x2e>
    while(n-- > 0)
 65a:	00c05f63          	blez	a2,678 <memmove+0x28>
 65e:	1602                	sll	a2,a2,0x20
 660:	9201                	srl	a2,a2,0x20
 662:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 666:	872a                	mv	a4,a0
      *dst++ = *src++;
 668:	0585                	add	a1,a1,1
 66a:	0705                	add	a4,a4,1
 66c:	fff5c683          	lbu	a3,-1(a1)
 670:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 674:	fee79ae3          	bne	a5,a4,668 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 678:	6422                	ld	s0,8(sp)
 67a:	0141                	add	sp,sp,16
 67c:	8082                	ret
    dst += n;
 67e:	00c50733          	add	a4,a0,a2
    src += n;
 682:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 684:	fec05ae3          	blez	a2,678 <memmove+0x28>
 688:	fff6079b          	addw	a5,a2,-1
 68c:	1782                	sll	a5,a5,0x20
 68e:	9381                	srl	a5,a5,0x20
 690:	fff7c793          	not	a5,a5
 694:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 696:	15fd                	add	a1,a1,-1
 698:	177d                	add	a4,a4,-1
 69a:	0005c683          	lbu	a3,0(a1)
 69e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6a2:	fee79ae3          	bne	a5,a4,696 <memmove+0x46>
 6a6:	bfc9                	j	678 <memmove+0x28>

00000000000006a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6a8:	1141                	add	sp,sp,-16
 6aa:	e422                	sd	s0,8(sp)
 6ac:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6ae:	ca05                	beqz	a2,6de <memcmp+0x36>
 6b0:	fff6069b          	addw	a3,a2,-1
 6b4:	1682                	sll	a3,a3,0x20
 6b6:	9281                	srl	a3,a3,0x20
 6b8:	0685                	add	a3,a3,1
 6ba:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6bc:	00054783          	lbu	a5,0(a0)
 6c0:	0005c703          	lbu	a4,0(a1)
 6c4:	00e79863          	bne	a5,a4,6d4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6c8:	0505                	add	a0,a0,1
    p2++;
 6ca:	0585                	add	a1,a1,1
  while (n-- > 0) {
 6cc:	fed518e3          	bne	a0,a3,6bc <memcmp+0x14>
  }
  return 0;
 6d0:	4501                	li	a0,0
 6d2:	a019                	j	6d8 <memcmp+0x30>
      return *p1 - *p2;
 6d4:	40e7853b          	subw	a0,a5,a4
}
 6d8:	6422                	ld	s0,8(sp)
 6da:	0141                	add	sp,sp,16
 6dc:	8082                	ret
  return 0;
 6de:	4501                	li	a0,0
 6e0:	bfe5                	j	6d8 <memcmp+0x30>

00000000000006e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6e2:	1141                	add	sp,sp,-16
 6e4:	e406                	sd	ra,8(sp)
 6e6:	e022                	sd	s0,0(sp)
 6e8:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 6ea:	f67ff0ef          	jal	650 <memmove>
}
 6ee:	60a2                	ld	ra,8(sp)
 6f0:	6402                	ld	s0,0(sp)
 6f2:	0141                	add	sp,sp,16
 6f4:	8082                	ret

00000000000006f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6f6:	4885                	li	a7,1
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 6fe:	4889                	li	a7,2
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <wait>:
.global wait
wait:
 li a7, SYS_wait
 706:	488d                	li	a7,3
 ecall
 708:	00000073          	ecall
 ret
 70c:	8082                	ret

000000000000070e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 70e:	4891                	li	a7,4
 ecall
 710:	00000073          	ecall
 ret
 714:	8082                	ret

0000000000000716 <read>:
.global read
read:
 li a7, SYS_read
 716:	4895                	li	a7,5
 ecall
 718:	00000073          	ecall
 ret
 71c:	8082                	ret

000000000000071e <write>:
.global write
write:
 li a7, SYS_write
 71e:	48c1                	li	a7,16
 ecall
 720:	00000073          	ecall
 ret
 724:	8082                	ret

0000000000000726 <close>:
.global close
close:
 li a7, SYS_close
 726:	48d5                	li	a7,21
 ecall
 728:	00000073          	ecall
 ret
 72c:	8082                	ret

000000000000072e <kill>:
.global kill
kill:
 li a7, SYS_kill
 72e:	4899                	li	a7,6
 ecall
 730:	00000073          	ecall
 ret
 734:	8082                	ret

0000000000000736 <exec>:
.global exec
exec:
 li a7, SYS_exec
 736:	489d                	li	a7,7
 ecall
 738:	00000073          	ecall
 ret
 73c:	8082                	ret

000000000000073e <open>:
.global open
open:
 li a7, SYS_open
 73e:	48bd                	li	a7,15
 ecall
 740:	00000073          	ecall
 ret
 744:	8082                	ret

0000000000000746 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 746:	48c5                	li	a7,17
 ecall
 748:	00000073          	ecall
 ret
 74c:	8082                	ret

000000000000074e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 74e:	48c9                	li	a7,18
 ecall
 750:	00000073          	ecall
 ret
 754:	8082                	ret

0000000000000756 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 756:	48a1                	li	a7,8
 ecall
 758:	00000073          	ecall
 ret
 75c:	8082                	ret

000000000000075e <link>:
.global link
link:
 li a7, SYS_link
 75e:	48cd                	li	a7,19
 ecall
 760:	00000073          	ecall
 ret
 764:	8082                	ret

0000000000000766 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 766:	48d1                	li	a7,20
 ecall
 768:	00000073          	ecall
 ret
 76c:	8082                	ret

000000000000076e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 76e:	48a5                	li	a7,9
 ecall
 770:	00000073          	ecall
 ret
 774:	8082                	ret

0000000000000776 <dup>:
.global dup
dup:
 li a7, SYS_dup
 776:	48a9                	li	a7,10
 ecall
 778:	00000073          	ecall
 ret
 77c:	8082                	ret

000000000000077e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 77e:	48ad                	li	a7,11
 ecall
 780:	00000073          	ecall
 ret
 784:	8082                	ret

0000000000000786 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 786:	48b1                	li	a7,12
 ecall
 788:	00000073          	ecall
 ret
 78c:	8082                	ret

000000000000078e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 78e:	48b5                	li	a7,13
 ecall
 790:	00000073          	ecall
 ret
 794:	8082                	ret

0000000000000796 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 796:	48b9                	li	a7,14
 ecall
 798:	00000073          	ecall
 ret
 79c:	8082                	ret

000000000000079e <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 79e:	48d9                	li	a7,22
 ecall
 7a0:	00000073          	ecall
 ret
 7a4:	8082                	ret

00000000000007a6 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 7a6:	48dd                	li	a7,23
 ecall
 7a8:	00000073          	ecall
 ret
 7ac:	8082                	ret

00000000000007ae <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 7ae:	48e1                	li	a7,24
 ecall
 7b0:	00000073          	ecall
 ret
 7b4:	8082                	ret

00000000000007b6 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 7b6:	48e5                	li	a7,25
 ecall
 7b8:	00000073          	ecall
 ret
 7bc:	8082                	ret

00000000000007be <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 7be:	48e9                	li	a7,26
 ecall
 7c0:	00000073          	ecall
 ret
 7c4:	8082                	ret

00000000000007c6 <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 7c6:	48ed                	li	a7,27
 ecall
 7c8:	00000073          	ecall
 ret
 7cc:	8082                	ret

00000000000007ce <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 7ce:	48f1                	li	a7,28
 ecall
 7d0:	00000073          	ecall
 ret
 7d4:	8082                	ret

00000000000007d6 <uptime_nolock>:
.global uptime_nolock
uptime_nolock:
 li a7, SYS_uptime_nolock
 7d6:	48f5                	li	a7,29
 ecall
 7d8:	00000073          	ecall
 ret
 7dc:	8082                	ret

00000000000007de <set_type>:
.global set_type
set_type:
 li a7, SYS_set_type
 7de:	48f9                	li	a7,30
 ecall
 7e0:	00000073          	ecall
 ret
 7e4:	8082                	ret

00000000000007e6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7e6:	1101                	add	sp,sp,-32
 7e8:	ec06                	sd	ra,24(sp)
 7ea:	e822                	sd	s0,16(sp)
 7ec:	1000                	add	s0,sp,32
 7ee:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7f2:	4605                	li	a2,1
 7f4:	fef40593          	add	a1,s0,-17
 7f8:	f27ff0ef          	jal	71e <write>
}
 7fc:	60e2                	ld	ra,24(sp)
 7fe:	6442                	ld	s0,16(sp)
 800:	6105                	add	sp,sp,32
 802:	8082                	ret

0000000000000804 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 804:	7139                	add	sp,sp,-64
 806:	fc06                	sd	ra,56(sp)
 808:	f822                	sd	s0,48(sp)
 80a:	f426                	sd	s1,40(sp)
 80c:	f04a                	sd	s2,32(sp)
 80e:	ec4e                	sd	s3,24(sp)
 810:	0080                	add	s0,sp,64
 812:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 814:	c299                	beqz	a3,81a <printint+0x16>
 816:	0805c763          	bltz	a1,8a4 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 81a:	2581                	sext.w	a1,a1
  neg = 0;
 81c:	4881                	li	a7,0
 81e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 822:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 824:	2601                	sext.w	a2,a2
 826:	00000517          	auipc	a0,0x0
 82a:	62a50513          	add	a0,a0,1578 # e50 <digits>
 82e:	883a                	mv	a6,a4
 830:	2705                	addw	a4,a4,1
 832:	02c5f7bb          	remuw	a5,a1,a2
 836:	1782                	sll	a5,a5,0x20
 838:	9381                	srl	a5,a5,0x20
 83a:	97aa                	add	a5,a5,a0
 83c:	0007c783          	lbu	a5,0(a5)
 840:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 844:	0005879b          	sext.w	a5,a1
 848:	02c5d5bb          	divuw	a1,a1,a2
 84c:	0685                	add	a3,a3,1
 84e:	fec7f0e3          	bgeu	a5,a2,82e <printint+0x2a>
  if(neg)
 852:	00088c63          	beqz	a7,86a <printint+0x66>
    buf[i++] = '-';
 856:	fd070793          	add	a5,a4,-48
 85a:	00878733          	add	a4,a5,s0
 85e:	02d00793          	li	a5,45
 862:	fef70823          	sb	a5,-16(a4)
 866:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 86a:	02e05663          	blez	a4,896 <printint+0x92>
 86e:	fc040793          	add	a5,s0,-64
 872:	00e78933          	add	s2,a5,a4
 876:	fff78993          	add	s3,a5,-1
 87a:	99ba                	add	s3,s3,a4
 87c:	377d                	addw	a4,a4,-1
 87e:	1702                	sll	a4,a4,0x20
 880:	9301                	srl	a4,a4,0x20
 882:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 886:	fff94583          	lbu	a1,-1(s2)
 88a:	8526                	mv	a0,s1
 88c:	f5bff0ef          	jal	7e6 <putc>
  while(--i >= 0)
 890:	197d                	add	s2,s2,-1
 892:	ff391ae3          	bne	s2,s3,886 <printint+0x82>
}
 896:	70e2                	ld	ra,56(sp)
 898:	7442                	ld	s0,48(sp)
 89a:	74a2                	ld	s1,40(sp)
 89c:	7902                	ld	s2,32(sp)
 89e:	69e2                	ld	s3,24(sp)
 8a0:	6121                	add	sp,sp,64
 8a2:	8082                	ret
    x = -xx;
 8a4:	40b005bb          	negw	a1,a1
    neg = 1;
 8a8:	4885                	li	a7,1
    x = -xx;
 8aa:	bf95                	j	81e <printint+0x1a>

00000000000008ac <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8ac:	711d                	add	sp,sp,-96
 8ae:	ec86                	sd	ra,88(sp)
 8b0:	e8a2                	sd	s0,80(sp)
 8b2:	e4a6                	sd	s1,72(sp)
 8b4:	e0ca                	sd	s2,64(sp)
 8b6:	fc4e                	sd	s3,56(sp)
 8b8:	f852                	sd	s4,48(sp)
 8ba:	f456                	sd	s5,40(sp)
 8bc:	f05a                	sd	s6,32(sp)
 8be:	ec5e                	sd	s7,24(sp)
 8c0:	e862                	sd	s8,16(sp)
 8c2:	e466                	sd	s9,8(sp)
 8c4:	e06a                	sd	s10,0(sp)
 8c6:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8c8:	0005c903          	lbu	s2,0(a1)
 8cc:	24090763          	beqz	s2,b1a <vprintf+0x26e>
 8d0:	8b2a                	mv	s6,a0
 8d2:	8a2e                	mv	s4,a1
 8d4:	8bb2                	mv	s7,a2
  state = 0;
 8d6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 8d8:	4481                	li	s1,0
 8da:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 8dc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 8e0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 8e4:	06c00c93          	li	s9,108
 8e8:	a005                	j	908 <vprintf+0x5c>
        putc(fd, c0);
 8ea:	85ca                	mv	a1,s2
 8ec:	855a                	mv	a0,s6
 8ee:	ef9ff0ef          	jal	7e6 <putc>
 8f2:	a019                	j	8f8 <vprintf+0x4c>
    } else if(state == '%'){
 8f4:	03598263          	beq	s3,s5,918 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 8f8:	2485                	addw	s1,s1,1
 8fa:	8726                	mv	a4,s1
 8fc:	009a07b3          	add	a5,s4,s1
 900:	0007c903          	lbu	s2,0(a5)
 904:	20090b63          	beqz	s2,b1a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 908:	0009079b          	sext.w	a5,s2
    if(state == 0){
 90c:	fe0994e3          	bnez	s3,8f4 <vprintf+0x48>
      if(c0 == '%'){
 910:	fd579de3          	bne	a5,s5,8ea <vprintf+0x3e>
        state = '%';
 914:	89be                	mv	s3,a5
 916:	b7cd                	j	8f8 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 918:	c7c9                	beqz	a5,9a2 <vprintf+0xf6>
 91a:	00ea06b3          	add	a3,s4,a4
 91e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 922:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 924:	c681                	beqz	a3,92c <vprintf+0x80>
 926:	9752                	add	a4,a4,s4
 928:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 92c:	03878f63          	beq	a5,s8,96a <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 930:	05978963          	beq	a5,s9,982 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 934:	07500713          	li	a4,117
 938:	0ee78363          	beq	a5,a4,a1e <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 93c:	07800713          	li	a4,120
 940:	12e78563          	beq	a5,a4,a6a <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 944:	07000713          	li	a4,112
 948:	14e78a63          	beq	a5,a4,a9c <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 94c:	07300713          	li	a4,115
 950:	18e78863          	beq	a5,a4,ae0 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 954:	02500713          	li	a4,37
 958:	04e79563          	bne	a5,a4,9a2 <vprintf+0xf6>
        putc(fd, '%');
 95c:	02500593          	li	a1,37
 960:	855a                	mv	a0,s6
 962:	e85ff0ef          	jal	7e6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 966:	4981                	li	s3,0
 968:	bf41                	j	8f8 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 96a:	008b8913          	add	s2,s7,8
 96e:	4685                	li	a3,1
 970:	4629                	li	a2,10
 972:	000ba583          	lw	a1,0(s7)
 976:	855a                	mv	a0,s6
 978:	e8dff0ef          	jal	804 <printint>
 97c:	8bca                	mv	s7,s2
      state = 0;
 97e:	4981                	li	s3,0
 980:	bfa5                	j	8f8 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 982:	06400793          	li	a5,100
 986:	02f68963          	beq	a3,a5,9b8 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 98a:	06c00793          	li	a5,108
 98e:	04f68263          	beq	a3,a5,9d2 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 992:	07500793          	li	a5,117
 996:	0af68063          	beq	a3,a5,a36 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 99a:	07800793          	li	a5,120
 99e:	0ef68263          	beq	a3,a5,a82 <vprintf+0x1d6>
        putc(fd, '%');
 9a2:	02500593          	li	a1,37
 9a6:	855a                	mv	a0,s6
 9a8:	e3fff0ef          	jal	7e6 <putc>
        putc(fd, c0);
 9ac:	85ca                	mv	a1,s2
 9ae:	855a                	mv	a0,s6
 9b0:	e37ff0ef          	jal	7e6 <putc>
      state = 0;
 9b4:	4981                	li	s3,0
 9b6:	b789                	j	8f8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9b8:	008b8913          	add	s2,s7,8
 9bc:	4685                	li	a3,1
 9be:	4629                	li	a2,10
 9c0:	000ba583          	lw	a1,0(s7)
 9c4:	855a                	mv	a0,s6
 9c6:	e3fff0ef          	jal	804 <printint>
        i += 1;
 9ca:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 9cc:	8bca                	mv	s7,s2
      state = 0;
 9ce:	4981                	li	s3,0
        i += 1;
 9d0:	b725                	j	8f8 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9d2:	06400793          	li	a5,100
 9d6:	02f60763          	beq	a2,a5,a04 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 9da:	07500793          	li	a5,117
 9de:	06f60963          	beq	a2,a5,a50 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 9e2:	07800793          	li	a5,120
 9e6:	faf61ee3          	bne	a2,a5,9a2 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9ea:	008b8913          	add	s2,s7,8
 9ee:	4681                	li	a3,0
 9f0:	4641                	li	a2,16
 9f2:	000ba583          	lw	a1,0(s7)
 9f6:	855a                	mv	a0,s6
 9f8:	e0dff0ef          	jal	804 <printint>
        i += 2;
 9fc:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 9fe:	8bca                	mv	s7,s2
      state = 0;
 a00:	4981                	li	s3,0
        i += 2;
 a02:	bddd                	j	8f8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a04:	008b8913          	add	s2,s7,8
 a08:	4685                	li	a3,1
 a0a:	4629                	li	a2,10
 a0c:	000ba583          	lw	a1,0(s7)
 a10:	855a                	mv	a0,s6
 a12:	df3ff0ef          	jal	804 <printint>
        i += 2;
 a16:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a18:	8bca                	mv	s7,s2
      state = 0;
 a1a:	4981                	li	s3,0
        i += 2;
 a1c:	bdf1                	j	8f8 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 a1e:	008b8913          	add	s2,s7,8
 a22:	4681                	li	a3,0
 a24:	4629                	li	a2,10
 a26:	000ba583          	lw	a1,0(s7)
 a2a:	855a                	mv	a0,s6
 a2c:	dd9ff0ef          	jal	804 <printint>
 a30:	8bca                	mv	s7,s2
      state = 0;
 a32:	4981                	li	s3,0
 a34:	b5d1                	j	8f8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a36:	008b8913          	add	s2,s7,8
 a3a:	4681                	li	a3,0
 a3c:	4629                	li	a2,10
 a3e:	000ba583          	lw	a1,0(s7)
 a42:	855a                	mv	a0,s6
 a44:	dc1ff0ef          	jal	804 <printint>
        i += 1;
 a48:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a4a:	8bca                	mv	s7,s2
      state = 0;
 a4c:	4981                	li	s3,0
        i += 1;
 a4e:	b56d                	j	8f8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a50:	008b8913          	add	s2,s7,8
 a54:	4681                	li	a3,0
 a56:	4629                	li	a2,10
 a58:	000ba583          	lw	a1,0(s7)
 a5c:	855a                	mv	a0,s6
 a5e:	da7ff0ef          	jal	804 <printint>
        i += 2;
 a62:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a64:	8bca                	mv	s7,s2
      state = 0;
 a66:	4981                	li	s3,0
        i += 2;
 a68:	bd41                	j	8f8 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 a6a:	008b8913          	add	s2,s7,8
 a6e:	4681                	li	a3,0
 a70:	4641                	li	a2,16
 a72:	000ba583          	lw	a1,0(s7)
 a76:	855a                	mv	a0,s6
 a78:	d8dff0ef          	jal	804 <printint>
 a7c:	8bca                	mv	s7,s2
      state = 0;
 a7e:	4981                	li	s3,0
 a80:	bda5                	j	8f8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a82:	008b8913          	add	s2,s7,8
 a86:	4681                	li	a3,0
 a88:	4641                	li	a2,16
 a8a:	000ba583          	lw	a1,0(s7)
 a8e:	855a                	mv	a0,s6
 a90:	d75ff0ef          	jal	804 <printint>
        i += 1;
 a94:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a96:	8bca                	mv	s7,s2
      state = 0;
 a98:	4981                	li	s3,0
        i += 1;
 a9a:	bdb9                	j	8f8 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 a9c:	008b8d13          	add	s10,s7,8
 aa0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 aa4:	03000593          	li	a1,48
 aa8:	855a                	mv	a0,s6
 aaa:	d3dff0ef          	jal	7e6 <putc>
  putc(fd, 'x');
 aae:	07800593          	li	a1,120
 ab2:	855a                	mv	a0,s6
 ab4:	d33ff0ef          	jal	7e6 <putc>
 ab8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 aba:	00000b97          	auipc	s7,0x0
 abe:	396b8b93          	add	s7,s7,918 # e50 <digits>
 ac2:	03c9d793          	srl	a5,s3,0x3c
 ac6:	97de                	add	a5,a5,s7
 ac8:	0007c583          	lbu	a1,0(a5)
 acc:	855a                	mv	a0,s6
 ace:	d19ff0ef          	jal	7e6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 ad2:	0992                	sll	s3,s3,0x4
 ad4:	397d                	addw	s2,s2,-1
 ad6:	fe0916e3          	bnez	s2,ac2 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 ada:	8bea                	mv	s7,s10
      state = 0;
 adc:	4981                	li	s3,0
 ade:	bd29                	j	8f8 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 ae0:	008b8993          	add	s3,s7,8
 ae4:	000bb903          	ld	s2,0(s7)
 ae8:	00090f63          	beqz	s2,b06 <vprintf+0x25a>
        for(; *s; s++)
 aec:	00094583          	lbu	a1,0(s2)
 af0:	c195                	beqz	a1,b14 <vprintf+0x268>
          putc(fd, *s);
 af2:	855a                	mv	a0,s6
 af4:	cf3ff0ef          	jal	7e6 <putc>
        for(; *s; s++)
 af8:	0905                	add	s2,s2,1
 afa:	00094583          	lbu	a1,0(s2)
 afe:	f9f5                	bnez	a1,af2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b00:	8bce                	mv	s7,s3
      state = 0;
 b02:	4981                	li	s3,0
 b04:	bbd5                	j	8f8 <vprintf+0x4c>
          s = "(null)";
 b06:	00000917          	auipc	s2,0x0
 b0a:	34290913          	add	s2,s2,834 # e48 <malloc+0x234>
        for(; *s; s++)
 b0e:	02800593          	li	a1,40
 b12:	b7c5                	j	af2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b14:	8bce                	mv	s7,s3
      state = 0;
 b16:	4981                	li	s3,0
 b18:	b3c5                	j	8f8 <vprintf+0x4c>
    }
  }
}
 b1a:	60e6                	ld	ra,88(sp)
 b1c:	6446                	ld	s0,80(sp)
 b1e:	64a6                	ld	s1,72(sp)
 b20:	6906                	ld	s2,64(sp)
 b22:	79e2                	ld	s3,56(sp)
 b24:	7a42                	ld	s4,48(sp)
 b26:	7aa2                	ld	s5,40(sp)
 b28:	7b02                	ld	s6,32(sp)
 b2a:	6be2                	ld	s7,24(sp)
 b2c:	6c42                	ld	s8,16(sp)
 b2e:	6ca2                	ld	s9,8(sp)
 b30:	6d02                	ld	s10,0(sp)
 b32:	6125                	add	sp,sp,96
 b34:	8082                	ret

0000000000000b36 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b36:	715d                	add	sp,sp,-80
 b38:	ec06                	sd	ra,24(sp)
 b3a:	e822                	sd	s0,16(sp)
 b3c:	1000                	add	s0,sp,32
 b3e:	e010                	sd	a2,0(s0)
 b40:	e414                	sd	a3,8(s0)
 b42:	e818                	sd	a4,16(s0)
 b44:	ec1c                	sd	a5,24(s0)
 b46:	03043023          	sd	a6,32(s0)
 b4a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b4e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b52:	8622                	mv	a2,s0
 b54:	d59ff0ef          	jal	8ac <vprintf>
}
 b58:	60e2                	ld	ra,24(sp)
 b5a:	6442                	ld	s0,16(sp)
 b5c:	6161                	add	sp,sp,80
 b5e:	8082                	ret

0000000000000b60 <printf>:

void
printf(const char *fmt, ...)
{
 b60:	711d                	add	sp,sp,-96
 b62:	ec06                	sd	ra,24(sp)
 b64:	e822                	sd	s0,16(sp)
 b66:	1000                	add	s0,sp,32
 b68:	e40c                	sd	a1,8(s0)
 b6a:	e810                	sd	a2,16(s0)
 b6c:	ec14                	sd	a3,24(s0)
 b6e:	f018                	sd	a4,32(s0)
 b70:	f41c                	sd	a5,40(s0)
 b72:	03043823          	sd	a6,48(s0)
 b76:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b7a:	00840613          	add	a2,s0,8
 b7e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b82:	85aa                	mv	a1,a0
 b84:	4505                	li	a0,1
 b86:	d27ff0ef          	jal	8ac <vprintf>
}
 b8a:	60e2                	ld	ra,24(sp)
 b8c:	6442                	ld	s0,16(sp)
 b8e:	6125                	add	sp,sp,96
 b90:	8082                	ret

0000000000000b92 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b92:	1141                	add	sp,sp,-16
 b94:	e422                	sd	s0,8(sp)
 b96:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b98:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b9c:	00000797          	auipc	a5,0x0
 ba0:	4747b783          	ld	a5,1140(a5) # 1010 <freep>
 ba4:	a02d                	j	bce <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ba6:	4618                	lw	a4,8(a2)
 ba8:	9f2d                	addw	a4,a4,a1
 baa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 bae:	6398                	ld	a4,0(a5)
 bb0:	6310                	ld	a2,0(a4)
 bb2:	a83d                	j	bf0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 bb4:	ff852703          	lw	a4,-8(a0)
 bb8:	9f31                	addw	a4,a4,a2
 bba:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bbc:	ff053683          	ld	a3,-16(a0)
 bc0:	a091                	j	c04 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bc2:	6398                	ld	a4,0(a5)
 bc4:	00e7e463          	bltu	a5,a4,bcc <free+0x3a>
 bc8:	00e6ea63          	bltu	a3,a4,bdc <free+0x4a>
{
 bcc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bce:	fed7fae3          	bgeu	a5,a3,bc2 <free+0x30>
 bd2:	6398                	ld	a4,0(a5)
 bd4:	00e6e463          	bltu	a3,a4,bdc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bd8:	fee7eae3          	bltu	a5,a4,bcc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 bdc:	ff852583          	lw	a1,-8(a0)
 be0:	6390                	ld	a2,0(a5)
 be2:	02059813          	sll	a6,a1,0x20
 be6:	01c85713          	srl	a4,a6,0x1c
 bea:	9736                	add	a4,a4,a3
 bec:	fae60de3          	beq	a2,a4,ba6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bf0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bf4:	4790                	lw	a2,8(a5)
 bf6:	02061593          	sll	a1,a2,0x20
 bfa:	01c5d713          	srl	a4,a1,0x1c
 bfe:	973e                	add	a4,a4,a5
 c00:	fae68ae3          	beq	a3,a4,bb4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 c04:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c06:	00000717          	auipc	a4,0x0
 c0a:	40f73523          	sd	a5,1034(a4) # 1010 <freep>
}
 c0e:	6422                	ld	s0,8(sp)
 c10:	0141                	add	sp,sp,16
 c12:	8082                	ret

0000000000000c14 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c14:	7139                	add	sp,sp,-64
 c16:	fc06                	sd	ra,56(sp)
 c18:	f822                	sd	s0,48(sp)
 c1a:	f426                	sd	s1,40(sp)
 c1c:	f04a                	sd	s2,32(sp)
 c1e:	ec4e                	sd	s3,24(sp)
 c20:	e852                	sd	s4,16(sp)
 c22:	e456                	sd	s5,8(sp)
 c24:	e05a                	sd	s6,0(sp)
 c26:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c28:	02051493          	sll	s1,a0,0x20
 c2c:	9081                	srl	s1,s1,0x20
 c2e:	04bd                	add	s1,s1,15
 c30:	8091                	srl	s1,s1,0x4
 c32:	0014899b          	addw	s3,s1,1
 c36:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 c38:	00000517          	auipc	a0,0x0
 c3c:	3d853503          	ld	a0,984(a0) # 1010 <freep>
 c40:	c515                	beqz	a0,c6c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c42:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c44:	4798                	lw	a4,8(a5)
 c46:	02977f63          	bgeu	a4,s1,c84 <malloc+0x70>
  if(nu < 4096)
 c4a:	8a4e                	mv	s4,s3
 c4c:	0009871b          	sext.w	a4,s3
 c50:	6685                	lui	a3,0x1
 c52:	00d77363          	bgeu	a4,a3,c58 <malloc+0x44>
 c56:	6a05                	lui	s4,0x1
 c58:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c5c:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c60:	00000917          	auipc	s2,0x0
 c64:	3b090913          	add	s2,s2,944 # 1010 <freep>
  if(p == (char*)-1)
 c68:	5afd                	li	s5,-1
 c6a:	a885                	j	cda <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 c6c:	00000797          	auipc	a5,0x0
 c70:	3b478793          	add	a5,a5,948 # 1020 <base>
 c74:	00000717          	auipc	a4,0x0
 c78:	38f73e23          	sd	a5,924(a4) # 1010 <freep>
 c7c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c7e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c82:	b7e1                	j	c4a <malloc+0x36>
      if(p->s.size == nunits)
 c84:	02e48c63          	beq	s1,a4,cbc <malloc+0xa8>
        p->s.size -= nunits;
 c88:	4137073b          	subw	a4,a4,s3
 c8c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c8e:	02071693          	sll	a3,a4,0x20
 c92:	01c6d713          	srl	a4,a3,0x1c
 c96:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c98:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c9c:	00000717          	auipc	a4,0x0
 ca0:	36a73a23          	sd	a0,884(a4) # 1010 <freep>
      return (void*)(p + 1);
 ca4:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ca8:	70e2                	ld	ra,56(sp)
 caa:	7442                	ld	s0,48(sp)
 cac:	74a2                	ld	s1,40(sp)
 cae:	7902                	ld	s2,32(sp)
 cb0:	69e2                	ld	s3,24(sp)
 cb2:	6a42                	ld	s4,16(sp)
 cb4:	6aa2                	ld	s5,8(sp)
 cb6:	6b02                	ld	s6,0(sp)
 cb8:	6121                	add	sp,sp,64
 cba:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 cbc:	6398                	ld	a4,0(a5)
 cbe:	e118                	sd	a4,0(a0)
 cc0:	bff1                	j	c9c <malloc+0x88>
  hp->s.size = nu;
 cc2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cc6:	0541                	add	a0,a0,16
 cc8:	ecbff0ef          	jal	b92 <free>
  return freep;
 ccc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cd0:	dd61                	beqz	a0,ca8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cd2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cd4:	4798                	lw	a4,8(a5)
 cd6:	fa9777e3          	bgeu	a4,s1,c84 <malloc+0x70>
    if(p == freep)
 cda:	00093703          	ld	a4,0(s2)
 cde:	853e                	mv	a0,a5
 ce0:	fef719e3          	bne	a4,a5,cd2 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 ce4:	8552                	mv	a0,s4
 ce6:	aa1ff0ef          	jal	786 <sbrk>
  if(p == (char*)-1)
 cea:	fd551ce3          	bne	a0,s5,cc2 <malloc+0xae>
        return 0;
 cee:	4501                	li	a0,0
 cf0:	bf65                	j	ca8 <malloc+0x94>
