
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
    int  t0_rodada, tempo_atual;
    char *args[2];
    int *processos = malloc(20 * sizeof(int));
  92:	05000513          	li	a0,80
  96:	36b000ef          	jal	c00 <malloc>
  9a:	f6a43023          	sd	a0,-160(s0)

    for (int i = 1; i <= 30; i++){
  9e:	4d85                	li	s11,1
                } else {       //pai
                    processos[j-1] = pid;
                }
            } else {
                //IO-BOUND
                args[0] = "rows";
  a0:	00001c17          	auipc	s8,0x1
  a4:	c68c0c13          	add	s8,s8,-920 # d08 <malloc+0x108>
                args[0] = "graphs";
  a8:	00001b97          	auipc	s7,0x1
  ac:	c38b8b93          	add	s7,s7,-968 # ce0 <malloc+0xe0>
        }

        //pegando max e min
        int lim = segundo_atual;
        int vazao_max = -10;
        int vazao_min = 10000;
  b0:	6789                	lui	a5,0x2
  b2:	71078793          	add	a5,a5,1808 # 2710 <base+0x16f0>
  b6:	f4f43c23          	sd	a5,-168(s0)
  ba:	aebd                	j	438 <main+0x3c4>
                index_str[1] = index + '0';
  bc:	02f4879b          	addw	a5,s1,47
  c0:	0ff7f793          	zext.b	a5,a5
                index_str[2] = '\0';
  c4:	03000693          	li	a3,48
  c8:	a881                	j	118 <main+0xa4>
                    ret = exec("graphs", args);
  ca:	f8040593          	add	a1,s0,-128
  ce:	855e                	mv	a0,s7
  d0:	662000ef          	jal	732 <exec>
                    if (ret == -1){
  d4:	03a51263          	bne	a0,s10,f8 <main+0x84>
                        printf("erro ao executar graphs.c\n");
  d8:	00001517          	auipc	a0,0x1
  dc:	c1050513          	add	a0,a0,-1008 # ce8 <malloc+0xe8>
  e0:	26d000ef          	jal	b4c <printf>
                        exit(1);
  e4:	4505                	li	a0,1
  e6:	614000ef          	jal	6fa <exit>
                args[0] = "rows";
  ea:	f9843023          	sd	s8,-128(s0)
                pid = fork();
  ee:	604000ef          	jal	6f2 <fork>
                if (pid == 0){ //filho
  f2:	c529                	beqz	a0,13c <main+0xc8>
                    processos[j-1] = pid;
  f4:	00a92023          	sw	a0,0(s2)
        for (int j = 1; j < 21; j++){
  f8:	2485                	addw	s1,s1,1
  fa:	0911                	add	s2,s2,4
  fc:	47d5                	li	a5,21
  fe:	04f48f63          	beq	s1,a5,15c <main+0xe8>
            if (index < 10) {
 102:	0004871b          	sext.w	a4,s1
 106:	fff4879b          	addw	a5,s1,-1
 10a:	fafa59e3          	bge	s4,a5,bc <main+0x48>
                index_str[1] = (index - 10) + '0';
 10e:	0254879b          	addw	a5,s1,37
 112:	0ff7f793          	zext.b	a5,a5
 116:	86e6                	mv	a3,s9
                index_str[0] = '0';
 118:	f6d40c23          	sb	a3,-136(s0)
                index_str[1] = index + '0';
 11c:	f6f40ca3          	sb	a5,-135(s0)
                index_str[2] = '\0';
 120:	f6040d23          	sb	zero,-134(s0)
            args[1] = index_str;
 124:	f9343423          	sd	s3,-120(s0)
            if (j <= X){
 128:	fceae1e3          	bltu	s5,a4,ea <main+0x76>
                args[0] = "graphs";
 12c:	f9743023          	sd	s7,-128(s0)
                pid = fork();
 130:	5c2000ef          	jal	6f2 <fork>
                if (pid == 0){ //filho
 134:	d959                	beqz	a0,ca <main+0x56>
                    processos[j-1] = pid;
 136:	00a92023          	sw	a0,0(s2)
 13a:	bf7d                	j	f8 <main+0x84>
                    ret = exec("rows", args);
 13c:	f8040593          	add	a1,s0,-128
 140:	8562                	mv	a0,s8
 142:	5f0000ef          	jal	732 <exec>
                    if (ret == -1){
 146:	fba519e3          	bne	a0,s10,f8 <main+0x84>
                        printf("erro ao executar rows.c\n");
 14a:	00001517          	auipc	a0,0x1
 14e:	bc650513          	add	a0,a0,-1082 # d10 <malloc+0x110>
 152:	1fb000ef          	jal	b4c <printf>
                        exit(1);
 156:	4505                	li	a0,1
 158:	5a2000ef          	jal	6fa <exit>
        int *terminos = malloc(20 * sizeof(int));
 15c:	05000513          	li	a0,80
 160:	2a1000ef          	jal	c00 <malloc>
 164:	8a2a                	mv	s4,a0
        for (int j = 0; j < 20; j++){
 166:	05050993          	add	s3,a0,80
        int *terminos = malloc(20 * sizeof(int));
 16a:	84aa                	mv	s1,a0
            if (proc == -1){
 16c:	597d                	li	s2,-1
                printf("pocesso falhou");
 16e:	00001a97          	auipc	s5,0x1
 172:	bc2a8a93          	add	s5,s5,-1086 # d30 <malloc+0x130>
 176:	a809                	j	188 <main+0x114>
                tempo_atual = uptime();
 178:	61a000ef          	jal	792 <uptime>
                terminos[j] = (tempo_atual - t0_rodada);
 17c:	4165053b          	subw	a0,a0,s6
 180:	c088                	sw	a0,0(s1)
        for (int j = 0; j < 20; j++){
 182:	0491                	add	s1,s1,4
 184:	01348b63          	beq	s1,s3,19a <main+0x126>
            proc = wait(0);
 188:	4501                	li	a0,0
 18a:	578000ef          	jal	702 <wait>
            if (proc == -1){
 18e:	ff2515e3          	bne	a0,s2,178 <main+0x104>
                printf("pocesso falhou");
 192:	8556                	mv	a0,s5
 194:	1b9000ef          	jal	b4c <printf>
 198:	b7ed                	j	182 <main+0x10e>
        printf("RODADA %d ======================\n", i);
 19a:	85ee                	mv	a1,s11
 19c:	00001517          	auipc	a0,0x1
 1a0:	ba450513          	add	a0,a0,-1116 # d40 <malloc+0x140>
 1a4:	1a9000ef          	jal	b4c <printf>
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
        int *vazoes = malloc(120 * sizeof(int));
 1f2:	1e000513          	li	a0,480
 1f6:	20b000ef          	jal	c00 <malloc>
 1fa:	84aa                	mv	s1,a0
        for (int j = 0; j < 120; j++){
 1fc:	86aa                	mv	a3,a0
 1fe:	1e050713          	add	a4,a0,480
        int *vazoes = malloc(120 * sizeof(int));
 202:	87aa                	mv	a5,a0
            vazoes[j] = 0;
 204:	0007a023          	sw	zero,0(a5)
        for (int j = 0; j < 120; j++){
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
 242:	02064e63          	bltz	a2,27e <main+0x20a>
 246:	02061793          	sll	a5,a2,0x20
 24a:	01e7d813          	srl	a6,a5,0x1e
 24e:	00448793          	add	a5,s1,4
 252:	983e                	add	a6,a6,a5
        int vazao_min = 10000;
 254:	f5843583          	ld	a1,-168(s0)
        int vazao_max = -10;
 258:	5759                	li	a4,-10
 25a:	a031                	j	266 <main+0x1f2>
 25c:	0005071b          	sext.w	a4,a0
        for (int j = 0; j <= lim; j++){
 260:	0691                	add	a3,a3,4
 262:	03068163          	beq	a3,a6,284 <main+0x210>
            if (vazoes[j] < vazao_min) {
 266:	429c                	lw	a5,0(a3)
 268:	853e                	mv	a0,a5
 26a:	00f5d363          	bge	a1,a5,270 <main+0x1fc>
 26e:	852e                	mv	a0,a1
 270:	0005059b          	sext.w	a1,a0
                vazao_min = vazoes[j];
            }
            if (vazoes[j] > vazao_max) {
 274:	853e                	mv	a0,a5
 276:	fee7d3e3          	bge	a5,a4,25c <main+0x1e8>
 27a:	853a                	mv	a0,a4
 27c:	b7c5                	j	25c <main+0x1e8>
        int vazao_min = 10000;
 27e:	f5843583          	ld	a1,-168(s0)
        int vazao_max = -10;
 282:	5759                	li	a4,-10
        }

        //normalizando
        int vazao_media = (20 * 100000) / lim;
        vazao_max *= 100000;
        vazao_min *= 100000;
 284:	6561                	lui	a0,0x18
 286:	6a05051b          	addw	a0,a0,1696 # 186a0 <base+0x17680>
 28a:	02a585bb          	mulw	a1,a1,a0
        int vazao_media = (20 * 100000) / lim;
 28e:	001e87b7          	lui	a5,0x1e8
 292:	4807879b          	addw	a5,a5,1152 # 1e8480 <base+0x1e7460>
 296:	02c7c7bb          	divw	a5,a5,a2

        int nominador = vazao_media - vazao_min;
 29a:	9f8d                	subw	a5,a5,a1
        int denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero

        long long res = 100000 - (nominador * 100000 / denominador);
 29c:	02a786bb          	mulw	a3,a5,a0
        vazao_max *= 100000;
 2a0:	02a707bb          	mulw	a5,a4,a0
        int denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero
 2a4:	9f8d                	subw	a5,a5,a1
        long long res = 100000 - (nominador * 100000 / denominador);
 2a6:	02f6c7bb          	divw	a5,a3,a5
 2aa:	9d1d                	subw	a0,a0,a5
        int vazao_norm = res % 100000;
 2ac:	67e1                	lui	a5,0x18
 2ae:	6a078793          	add	a5,a5,1696 # 186a0 <base+0x17680>
 2b2:	02f56b33          	rem	s6,a0,a5
        printf("vazao normalizada: %de-05\n", vazao_norm);
 2b6:	85da                	mv	a1,s6
 2b8:	00001517          	auipc	a0,0x1
 2bc:	ab050513          	add	a0,a0,-1360 # d68 <malloc+0x168>
 2c0:	08d000ef          	jal	b4c <printf>

        free(terminos);
 2c4:	8552                	mv	a0,s4
 2c6:	0b9000ef          	jal	b7e <free>
        free(vazoes);
 2ca:	8526                	mv	a0,s1
 2cc:	0b3000ef          	jal	b7e <free>
        

        // EFICIENCIA DO SISTEMA DE ARQUIVOS
        int *eficiencias = malloc(Y * sizeof(int));
 2d0:	f6842783          	lw	a5,-152(s0)
 2d4:	0027951b          	sllw	a0,a5,0x2
 2d8:	129000ef          	jal	c00 <malloc>
 2dc:	89aa                	mv	s3,a0
        
        //lendo os dados da struct processo

        int l = 0;
        int eficiencia_atual;
        for (int k = 0; k < 20; k++){
 2de:	4481                	li	s1,0
        int l = 0;
 2e0:	4901                	li	s2,0
        for (int k = 0; k < 20; k++){
 2e2:	4a51                	li	s4,20
 2e4:	a021                	j	2ec <main+0x278>
 2e6:	2485                	addw	s1,s1,1
 2e8:	01448d63          	beq	s1,s4,302 <main+0x28e>
            eficiencia_atual = get_eficiencia(k); //graphs.c devolve um valor negativo,
 2ec:	8526                	mv	a0,s1
 2ee:	4b4000ef          	jal	7a2 <get_eficiencia>
            if (eficiencia_atual >= 0 ){         //para que não impacte no cálculo
 2f2:	fe054ae3          	bltz	a0,2e6 <main+0x272>
                eficiencias[l] = eficiencia_atual;
 2f6:	00291793          	sll	a5,s2,0x2
 2fa:	97ce                	add	a5,a5,s3
 2fc:	c388                	sw	a0,0(a5)
                l += 1;
 2fe:	2905                	addw	s2,s2,1
 300:	b7dd                	j	2e6 <main+0x272>
 302:	874e                	mv	a4,s3
 304:	f6843683          	ld	a3,-152(s0)
 308:	02069793          	sll	a5,a3,0x20
 30c:	01e7d613          	srl	a2,a5,0x1e
 310:	964e                	add	a2,a2,s3
            }
        }
        
        //somando
        int eficiencia_soma = 0;
 312:	4681                	li	a3,0
        
        for(int j = 0; j < Y; j ++){
            eficiencia_soma += eficiencias[j];
 314:	431c                	lw	a5,0(a4)
 316:	9fb5                	addw	a5,a5,a3
 318:	0007869b          	sext.w	a3,a5
        for(int j = 0; j < Y; j ++){
 31c:	0711                	add	a4,a4,4
 31e:	fec71be3          	bne	a4,a2,314 <main+0x2a0>
        }

        //invertendo
        res = 100000 / eficiencia_soma;
 322:	6ae1                	lui	s5,0x18
 324:	6a0a8a9b          	addw	s5,s5,1696 # 186a0 <base+0x17680>
 328:	02facabb          	divw	s5,s5,a5
        int eficiencia_fim = res;
        printf("eficiencia normalizada: %de-05\n", eficiencia_fim);
 32c:	000a859b          	sext.w	a1,s5
 330:	00001517          	auipc	a0,0x1
 334:	a5850513          	add	a0,a0,-1448 # d88 <malloc+0x188>
 338:	015000ef          	jal	b4c <printf>
        free(eficiencias);
 33c:	854e                	mv	a0,s3
 33e:	041000ef          	jal	b7e <free>


        //OVERHEAD
        int *overheads = malloc(20 * sizeof(int));
 342:	05000513          	li	a0,80
 346:	0bb000ef          	jal	c00 <malloc>
 34a:	8a2a                	mv	s4,a0
        

        //lendo os dados da struct do processo
        int overhead_atual;
        for (int k = 0; k < 20; k++){
 34c:	84aa                	mv	s1,a0
        int *overheads = malloc(20 * sizeof(int));
 34e:	89aa                	mv	s3,a0
        for (int k = 0; k < 20; k++){
 350:	4901                	li	s2,0
 352:	4cd1                	li	s9,20
            overhead_atual = get_overhead(k);
 354:	854a                	mv	a0,s2
 356:	454000ef          	jal	7aa <get_overhead>
            overheads[k] = overhead_atual;
 35a:	00a9a023          	sw	a0,0(s3)
        for (int k = 0; k < 20; k++){
 35e:	2905                	addw	s2,s2,1
 360:	0991                	add	s3,s3,4
 362:	ff9919e3          	bne	s2,s9,354 <main+0x2e0>
 366:	050a0693          	add	a3,s4,80
        }


        int overhead_soma = 0;
 36a:	4701                	li	a4,0
        
        for(int j = 0; j < 20; j ++){
            overhead_soma += overheads[j];
 36c:	409c                	lw	a5,0(s1)
 36e:	9fb9                	addw	a5,a5,a4
 370:	0007871b          	sext.w	a4,a5
        for(int j = 0; j < 20; j ++){
 374:	0491                	add	s1,s1,4
 376:	fe969be3          	bne	a3,s1,36c <main+0x2f8>
        }

        //invertendo
        res = (100000 / overhead_soma);
 37a:	6ce1                	lui	s9,0x18
 37c:	6a0c8c9b          	addw	s9,s9,1696 # 186a0 <base+0x17680>
 380:	02fcccbb          	divw	s9,s9,a5
        int overhead_fim = res;
        printf("overhead final: %de-05\n", overhead_fim);
 384:	000c859b          	sext.w	a1,s9
 388:	00001517          	auipc	a0,0x1
 38c:	a2050513          	add	a0,a0,-1504 # da8 <malloc+0x1a8>
 390:	7bc000ef          	jal	b4c <printf>
        free(overheads);
 394:	8552                	mv	a0,s4
 396:	7e8000ef          	jal	b7e <free>

        //JUSTIÇA
        int *justicas = malloc(20 * sizeof(int));
 39a:	05000513          	li	a0,80
 39e:	063000ef          	jal	c00 <malloc>
 3a2:	8d2a                	mv	s10,a0

        //lendo do proc.c
        for (int k = 0; k < 20; k++){
 3a4:	84aa                	mv	s1,a0
        int *justicas = malloc(20 * sizeof(int));
 3a6:	89aa                	mv	s3,a0
        for (int k = 0; k < 20; k++){
 3a8:	4901                	li	s2,0
 3aa:	4a51                	li	s4,20
            justicas[k] = get_justica(k);
 3ac:	854a                	mv	a0,s2
 3ae:	414000ef          	jal	7c2 <get_justica>
 3b2:	00a9a023          	sw	a0,0(s3)
        for (int k = 0; k < 20; k++){
 3b6:	2905                	addw	s2,s2,1
 3b8:	0991                	add	s3,s3,4
 3ba:	ff4919e3          	bne	s2,s4,3ac <main+0x338>
 3be:	050d0613          	add	a2,s10,80
        }

        //somando
        long long justica_soma = 0; 
        long long justica_soma_quadrado = 0;
 3c2:	4701                	li	a4,0
        long long justica_soma = 0; 
 3c4:	4681                	li	a3,0
        for (int k = 0; k < 20; k++){
            justica_soma += justicas[k];
 3c6:	409c                	lw	a5,0(s1)
 3c8:	96be                	add	a3,a3,a5
            justica_soma_quadrado += justicas[k] * justicas[k];
 3ca:	02f787bb          	mulw	a5,a5,a5
 3ce:	973e                	add	a4,a4,a5
        for (int k = 0; k < 20; k++){
 3d0:	0491                	add	s1,s1,4
 3d2:	fec49ae3          	bne	s1,a2,3c6 <main+0x352>
        }

        //normalizando
        long long nominador2 = justica_soma * justica_soma;
 3d6:	02d684b3          	mul	s1,a3,a3
        long long denominador2 = 20 * justica_soma_quadrado;
 3da:	00271913          	sll	s2,a4,0x2
 3de:	993a                	add	s2,s2,a4
 3e0:	090a                	sll	s2,s2,0x2
        printf("nominador: %lld | denominador: %lld\n", nominador2, denominador2);
 3e2:	864a                	mv	a2,s2
 3e4:	85a6                	mv	a1,s1
 3e6:	00001517          	auipc	a0,0x1
 3ea:	9da50513          	add	a0,a0,-1574 # dc0 <malloc+0x1c0>
 3ee:	75e000ef          	jal	b4c <printf>
        res = (nominador2 * 100000) / denominador2;
 3f2:	67e1                	lui	a5,0x18
 3f4:	6a078793          	add	a5,a5,1696 # 186a0 <base+0x17680>
 3f8:	02f484b3          	mul	s1,s1,a5
 3fc:	0324c4b3          	div	s1,s1,s2
        int justica_fim = res;
 400:	2481                	sext.w	s1,s1
        printf("justica_fim: %de-05\n", justica_fim);
 402:	85a6                	mv	a1,s1
 404:	00001517          	auipc	a0,0x1
 408:	9e450513          	add	a0,a0,-1564 # de8 <malloc+0x1e8>
 40c:	740000ef          	jal	b4c <printf>
        free(justicas);
 410:	856a                	mv	a0,s10
 412:	76c000ef          	jal	b7e <free>

        //DESEMPENHO
        int desempenho = (overhead_fim + eficiencia_fim + vazao_norm + justica_fim);
 416:	019a85bb          	addw	a1,s5,s9
 41a:	016585bb          	addw	a1,a1,s6
 41e:	9da5                	addw	a1,a1,s1
        desempenho = desempenho >> 2;
        printf("desempenho: %de-05\n", desempenho);
 420:	4025d59b          	sraw	a1,a1,0x2
 424:	00001517          	auipc	a0,0x1
 428:	9dc50513          	add	a0,a0,-1572 # e00 <malloc+0x200>
 42c:	720000ef          	jal	b4c <printf>
    for (int i = 1; i <= 30; i++){
 430:	2d85                	addw	s11,s11,1
 432:	47fd                	li	a5,31
 434:	02fd8e63          	beq	s11,a5,470 <main+0x3fc>
        initialize_metrics();
 438:	382000ef          	jal	7ba <initialize_metrics>
        t0_rodada = uptime();
 43c:	356000ef          	jal	792 <uptime>
 440:	8b2a                	mv	s6,a0
        uint X = (rand() % 9) + 6;
 442:	c17ff0ef          	jal	58 <rand>
 446:	47a5                	li	a5,9
 448:	02f567bb          	remw	a5,a0,a5
 44c:	2799                	addw	a5,a5,6
 44e:	00078a9b          	sext.w	s5,a5
        uint Y = 20 - X;
 452:	4751                	li	a4,20
 454:	40f707bb          	subw	a5,a4,a5
 458:	f6f42423          	sw	a5,-152(s0)
        for (int j = 1; j < 21; j++){
 45c:	f6043903          	ld	s2,-160(s0)
 460:	4485                	li	s1,1
            if (index < 10) {
 462:	4a25                	li	s4,9
                index_str[1] = (index - 10) + '0';
 464:	03100c93          	li	s9,49
            args[1] = index_str;
 468:	f7840993          	add	s3,s0,-136
                    if (ret == -1){
 46c:	5d7d                	li	s10,-1
 46e:	b951                	j	102 <main+0x8e>
    }
    return 0;
 470:	4501                	li	a0,0
 472:	70aa                	ld	ra,168(sp)
 474:	740a                	ld	s0,160(sp)
 476:	64ea                	ld	s1,152(sp)
 478:	694a                	ld	s2,144(sp)
 47a:	69aa                	ld	s3,136(sp)
 47c:	6a0a                	ld	s4,128(sp)
 47e:	7ae6                	ld	s5,120(sp)
 480:	7b46                	ld	s6,112(sp)
 482:	7ba6                	ld	s7,104(sp)
 484:	7c06                	ld	s8,96(sp)
 486:	6ce6                	ld	s9,88(sp)
 488:	6d46                	ld	s10,80(sp)
 48a:	6da6                	ld	s11,72(sp)
 48c:	614d                	add	sp,sp,176
 48e:	8082                	ret

0000000000000490 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 490:	1141                	add	sp,sp,-16
 492:	e406                	sd	ra,8(sp)
 494:	e022                	sd	s0,0(sp)
 496:	0800                	add	s0,sp,16
  extern int main();
  main();
 498:	bddff0ef          	jal	74 <main>
  exit(0);
 49c:	4501                	li	a0,0
 49e:	25c000ef          	jal	6fa <exit>

00000000000004a2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 4a2:	1141                	add	sp,sp,-16
 4a4:	e422                	sd	s0,8(sp)
 4a6:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4a8:	87aa                	mv	a5,a0
 4aa:	0585                	add	a1,a1,1
 4ac:	0785                	add	a5,a5,1
 4ae:	fff5c703          	lbu	a4,-1(a1)
 4b2:	fee78fa3          	sb	a4,-1(a5)
 4b6:	fb75                	bnez	a4,4aa <strcpy+0x8>
    ;
  return os;
}
 4b8:	6422                	ld	s0,8(sp)
 4ba:	0141                	add	sp,sp,16
 4bc:	8082                	ret

00000000000004be <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4be:	1141                	add	sp,sp,-16
 4c0:	e422                	sd	s0,8(sp)
 4c2:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 4c4:	00054783          	lbu	a5,0(a0)
 4c8:	cb91                	beqz	a5,4dc <strcmp+0x1e>
 4ca:	0005c703          	lbu	a4,0(a1)
 4ce:	00f71763          	bne	a4,a5,4dc <strcmp+0x1e>
    p++, q++;
 4d2:	0505                	add	a0,a0,1
 4d4:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 4d6:	00054783          	lbu	a5,0(a0)
 4da:	fbe5                	bnez	a5,4ca <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4dc:	0005c503          	lbu	a0,0(a1)
}
 4e0:	40a7853b          	subw	a0,a5,a0
 4e4:	6422                	ld	s0,8(sp)
 4e6:	0141                	add	sp,sp,16
 4e8:	8082                	ret

00000000000004ea <strlen>:

uint
strlen(const char *s)
{
 4ea:	1141                	add	sp,sp,-16
 4ec:	e422                	sd	s0,8(sp)
 4ee:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4f0:	00054783          	lbu	a5,0(a0)
 4f4:	cf91                	beqz	a5,510 <strlen+0x26>
 4f6:	0505                	add	a0,a0,1
 4f8:	87aa                	mv	a5,a0
 4fa:	86be                	mv	a3,a5
 4fc:	0785                	add	a5,a5,1
 4fe:	fff7c703          	lbu	a4,-1(a5)
 502:	ff65                	bnez	a4,4fa <strlen+0x10>
 504:	40a6853b          	subw	a0,a3,a0
 508:	2505                	addw	a0,a0,1
    ;
  return n;
}
 50a:	6422                	ld	s0,8(sp)
 50c:	0141                	add	sp,sp,16
 50e:	8082                	ret
  for(n = 0; s[n]; n++)
 510:	4501                	li	a0,0
 512:	bfe5                	j	50a <strlen+0x20>

0000000000000514 <memset>:

void*
memset(void *dst, int c, uint n)
{
 514:	1141                	add	sp,sp,-16
 516:	e422                	sd	s0,8(sp)
 518:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 51a:	ca19                	beqz	a2,530 <memset+0x1c>
 51c:	87aa                	mv	a5,a0
 51e:	1602                	sll	a2,a2,0x20
 520:	9201                	srl	a2,a2,0x20
 522:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 526:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 52a:	0785                	add	a5,a5,1
 52c:	fee79de3          	bne	a5,a4,526 <memset+0x12>
  }
  return dst;
}
 530:	6422                	ld	s0,8(sp)
 532:	0141                	add	sp,sp,16
 534:	8082                	ret

0000000000000536 <strchr>:

char*
strchr(const char *s, char c)
{
 536:	1141                	add	sp,sp,-16
 538:	e422                	sd	s0,8(sp)
 53a:	0800                	add	s0,sp,16
  for(; *s; s++)
 53c:	00054783          	lbu	a5,0(a0)
 540:	cb99                	beqz	a5,556 <strchr+0x20>
    if(*s == c)
 542:	00f58763          	beq	a1,a5,550 <strchr+0x1a>
  for(; *s; s++)
 546:	0505                	add	a0,a0,1
 548:	00054783          	lbu	a5,0(a0)
 54c:	fbfd                	bnez	a5,542 <strchr+0xc>
      return (char*)s;
  return 0;
 54e:	4501                	li	a0,0
}
 550:	6422                	ld	s0,8(sp)
 552:	0141                	add	sp,sp,16
 554:	8082                	ret
  return 0;
 556:	4501                	li	a0,0
 558:	bfe5                	j	550 <strchr+0x1a>

000000000000055a <gets>:

char*
gets(char *buf, int max)
{
 55a:	711d                	add	sp,sp,-96
 55c:	ec86                	sd	ra,88(sp)
 55e:	e8a2                	sd	s0,80(sp)
 560:	e4a6                	sd	s1,72(sp)
 562:	e0ca                	sd	s2,64(sp)
 564:	fc4e                	sd	s3,56(sp)
 566:	f852                	sd	s4,48(sp)
 568:	f456                	sd	s5,40(sp)
 56a:	f05a                	sd	s6,32(sp)
 56c:	ec5e                	sd	s7,24(sp)
 56e:	1080                	add	s0,sp,96
 570:	8baa                	mv	s7,a0
 572:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 574:	892a                	mv	s2,a0
 576:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 578:	4aa9                	li	s5,10
 57a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 57c:	89a6                	mv	s3,s1
 57e:	2485                	addw	s1,s1,1
 580:	0344d663          	bge	s1,s4,5ac <gets+0x52>
    cc = read(0, &c, 1);
 584:	4605                	li	a2,1
 586:	faf40593          	add	a1,s0,-81
 58a:	4501                	li	a0,0
 58c:	186000ef          	jal	712 <read>
    if(cc < 1)
 590:	00a05e63          	blez	a0,5ac <gets+0x52>
    buf[i++] = c;
 594:	faf44783          	lbu	a5,-81(s0)
 598:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 59c:	01578763          	beq	a5,s5,5aa <gets+0x50>
 5a0:	0905                	add	s2,s2,1
 5a2:	fd679de3          	bne	a5,s6,57c <gets+0x22>
  for(i=0; i+1 < max; ){
 5a6:	89a6                	mv	s3,s1
 5a8:	a011                	j	5ac <gets+0x52>
 5aa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5ac:	99de                	add	s3,s3,s7
 5ae:	00098023          	sb	zero,0(s3)
  return buf;
}
 5b2:	855e                	mv	a0,s7
 5b4:	60e6                	ld	ra,88(sp)
 5b6:	6446                	ld	s0,80(sp)
 5b8:	64a6                	ld	s1,72(sp)
 5ba:	6906                	ld	s2,64(sp)
 5bc:	79e2                	ld	s3,56(sp)
 5be:	7a42                	ld	s4,48(sp)
 5c0:	7aa2                	ld	s5,40(sp)
 5c2:	7b02                	ld	s6,32(sp)
 5c4:	6be2                	ld	s7,24(sp)
 5c6:	6125                	add	sp,sp,96
 5c8:	8082                	ret

00000000000005ca <stat>:

int
stat(const char *n, struct stat *st)
{
 5ca:	1101                	add	sp,sp,-32
 5cc:	ec06                	sd	ra,24(sp)
 5ce:	e822                	sd	s0,16(sp)
 5d0:	e426                	sd	s1,8(sp)
 5d2:	e04a                	sd	s2,0(sp)
 5d4:	1000                	add	s0,sp,32
 5d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5d8:	4581                	li	a1,0
 5da:	160000ef          	jal	73a <open>
  if(fd < 0)
 5de:	02054163          	bltz	a0,600 <stat+0x36>
 5e2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5e4:	85ca                	mv	a1,s2
 5e6:	16c000ef          	jal	752 <fstat>
 5ea:	892a                	mv	s2,a0
  close(fd);
 5ec:	8526                	mv	a0,s1
 5ee:	134000ef          	jal	722 <close>
  return r;
}
 5f2:	854a                	mv	a0,s2
 5f4:	60e2                	ld	ra,24(sp)
 5f6:	6442                	ld	s0,16(sp)
 5f8:	64a2                	ld	s1,8(sp)
 5fa:	6902                	ld	s2,0(sp)
 5fc:	6105                	add	sp,sp,32
 5fe:	8082                	ret
    return -1;
 600:	597d                	li	s2,-1
 602:	bfc5                	j	5f2 <stat+0x28>

0000000000000604 <atoi>:

int
atoi(const char *s)
{
 604:	1141                	add	sp,sp,-16
 606:	e422                	sd	s0,8(sp)
 608:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 60a:	00054683          	lbu	a3,0(a0)
 60e:	fd06879b          	addw	a5,a3,-48
 612:	0ff7f793          	zext.b	a5,a5
 616:	4625                	li	a2,9
 618:	02f66863          	bltu	a2,a5,648 <atoi+0x44>
 61c:	872a                	mv	a4,a0
  n = 0;
 61e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 620:	0705                	add	a4,a4,1
 622:	0025179b          	sllw	a5,a0,0x2
 626:	9fa9                	addw	a5,a5,a0
 628:	0017979b          	sllw	a5,a5,0x1
 62c:	9fb5                	addw	a5,a5,a3
 62e:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 632:	00074683          	lbu	a3,0(a4)
 636:	fd06879b          	addw	a5,a3,-48
 63a:	0ff7f793          	zext.b	a5,a5
 63e:	fef671e3          	bgeu	a2,a5,620 <atoi+0x1c>
  return n;
}
 642:	6422                	ld	s0,8(sp)
 644:	0141                	add	sp,sp,16
 646:	8082                	ret
  n = 0;
 648:	4501                	li	a0,0
 64a:	bfe5                	j	642 <atoi+0x3e>

000000000000064c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 64c:	1141                	add	sp,sp,-16
 64e:	e422                	sd	s0,8(sp)
 650:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 652:	02b57463          	bgeu	a0,a1,67a <memmove+0x2e>
    while(n-- > 0)
 656:	00c05f63          	blez	a2,674 <memmove+0x28>
 65a:	1602                	sll	a2,a2,0x20
 65c:	9201                	srl	a2,a2,0x20
 65e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 662:	872a                	mv	a4,a0
      *dst++ = *src++;
 664:	0585                	add	a1,a1,1
 666:	0705                	add	a4,a4,1
 668:	fff5c683          	lbu	a3,-1(a1)
 66c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 670:	fee79ae3          	bne	a5,a4,664 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 674:	6422                	ld	s0,8(sp)
 676:	0141                	add	sp,sp,16
 678:	8082                	ret
    dst += n;
 67a:	00c50733          	add	a4,a0,a2
    src += n;
 67e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 680:	fec05ae3          	blez	a2,674 <memmove+0x28>
 684:	fff6079b          	addw	a5,a2,-1
 688:	1782                	sll	a5,a5,0x20
 68a:	9381                	srl	a5,a5,0x20
 68c:	fff7c793          	not	a5,a5
 690:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 692:	15fd                	add	a1,a1,-1
 694:	177d                	add	a4,a4,-1
 696:	0005c683          	lbu	a3,0(a1)
 69a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 69e:	fee79ae3          	bne	a5,a4,692 <memmove+0x46>
 6a2:	bfc9                	j	674 <memmove+0x28>

00000000000006a4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6a4:	1141                	add	sp,sp,-16
 6a6:	e422                	sd	s0,8(sp)
 6a8:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6aa:	ca05                	beqz	a2,6da <memcmp+0x36>
 6ac:	fff6069b          	addw	a3,a2,-1
 6b0:	1682                	sll	a3,a3,0x20
 6b2:	9281                	srl	a3,a3,0x20
 6b4:	0685                	add	a3,a3,1
 6b6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6b8:	00054783          	lbu	a5,0(a0)
 6bc:	0005c703          	lbu	a4,0(a1)
 6c0:	00e79863          	bne	a5,a4,6d0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6c4:	0505                	add	a0,a0,1
    p2++;
 6c6:	0585                	add	a1,a1,1
  while (n-- > 0) {
 6c8:	fed518e3          	bne	a0,a3,6b8 <memcmp+0x14>
  }
  return 0;
 6cc:	4501                	li	a0,0
 6ce:	a019                	j	6d4 <memcmp+0x30>
      return *p1 - *p2;
 6d0:	40e7853b          	subw	a0,a5,a4
}
 6d4:	6422                	ld	s0,8(sp)
 6d6:	0141                	add	sp,sp,16
 6d8:	8082                	ret
  return 0;
 6da:	4501                	li	a0,0
 6dc:	bfe5                	j	6d4 <memcmp+0x30>

00000000000006de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6de:	1141                	add	sp,sp,-16
 6e0:	e406                	sd	ra,8(sp)
 6e2:	e022                	sd	s0,0(sp)
 6e4:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 6e6:	f67ff0ef          	jal	64c <memmove>
}
 6ea:	60a2                	ld	ra,8(sp)
 6ec:	6402                	ld	s0,0(sp)
 6ee:	0141                	add	sp,sp,16
 6f0:	8082                	ret

00000000000006f2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6f2:	4885                	li	a7,1
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <exit>:
.global exit
exit:
 li a7, SYS_exit
 6fa:	4889                	li	a7,2
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <wait>:
.global wait
wait:
 li a7, SYS_wait
 702:	488d                	li	a7,3
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 70a:	4891                	li	a7,4
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <read>:
.global read
read:
 li a7, SYS_read
 712:	4895                	li	a7,5
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <write>:
.global write
write:
 li a7, SYS_write
 71a:	48c1                	li	a7,16
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <close>:
.global close
close:
 li a7, SYS_close
 722:	48d5                	li	a7,21
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <kill>:
.global kill
kill:
 li a7, SYS_kill
 72a:	4899                	li	a7,6
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <exec>:
.global exec
exec:
 li a7, SYS_exec
 732:	489d                	li	a7,7
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <open>:
.global open
open:
 li a7, SYS_open
 73a:	48bd                	li	a7,15
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 742:	48c5                	li	a7,17
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 74a:	48c9                	li	a7,18
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 752:	48a1                	li	a7,8
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <link>:
.global link
link:
 li a7, SYS_link
 75a:	48cd                	li	a7,19
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 762:	48d1                	li	a7,20
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 76a:	48a5                	li	a7,9
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <dup>:
.global dup
dup:
 li a7, SYS_dup
 772:	48a9                	li	a7,10
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 77a:	48ad                	li	a7,11
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 782:	48b1                	li	a7,12
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 78a:	48b5                	li	a7,13
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 792:	48b9                	li	a7,14
 ecall
 794:	00000073          	ecall
 ret
 798:	8082                	ret

000000000000079a <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 79a:	48d9                	li	a7,22
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 7a2:	48dd                	li	a7,23
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 7aa:	48e1                	li	a7,24
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 7b2:	48e5                	li	a7,25
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	8082                	ret

00000000000007ba <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 7ba:	48e9                	li	a7,26
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 7c2:	48ed                	li	a7,27
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 7ca:	48f1                	li	a7,28
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7d2:	1101                	add	sp,sp,-32
 7d4:	ec06                	sd	ra,24(sp)
 7d6:	e822                	sd	s0,16(sp)
 7d8:	1000                	add	s0,sp,32
 7da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7de:	4605                	li	a2,1
 7e0:	fef40593          	add	a1,s0,-17
 7e4:	f37ff0ef          	jal	71a <write>
}
 7e8:	60e2                	ld	ra,24(sp)
 7ea:	6442                	ld	s0,16(sp)
 7ec:	6105                	add	sp,sp,32
 7ee:	8082                	ret

00000000000007f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7f0:	7139                	add	sp,sp,-64
 7f2:	fc06                	sd	ra,56(sp)
 7f4:	f822                	sd	s0,48(sp)
 7f6:	f426                	sd	s1,40(sp)
 7f8:	f04a                	sd	s2,32(sp)
 7fa:	ec4e                	sd	s3,24(sp)
 7fc:	0080                	add	s0,sp,64
 7fe:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 800:	c299                	beqz	a3,806 <printint+0x16>
 802:	0805c763          	bltz	a1,890 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 806:	2581                	sext.w	a1,a1
  neg = 0;
 808:	4881                	li	a7,0
 80a:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 80e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 810:	2601                	sext.w	a2,a2
 812:	00000517          	auipc	a0,0x0
 816:	60e50513          	add	a0,a0,1550 # e20 <digits>
 81a:	883a                	mv	a6,a4
 81c:	2705                	addw	a4,a4,1
 81e:	02c5f7bb          	remuw	a5,a1,a2
 822:	1782                	sll	a5,a5,0x20
 824:	9381                	srl	a5,a5,0x20
 826:	97aa                	add	a5,a5,a0
 828:	0007c783          	lbu	a5,0(a5)
 82c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 830:	0005879b          	sext.w	a5,a1
 834:	02c5d5bb          	divuw	a1,a1,a2
 838:	0685                	add	a3,a3,1
 83a:	fec7f0e3          	bgeu	a5,a2,81a <printint+0x2a>
  if(neg)
 83e:	00088c63          	beqz	a7,856 <printint+0x66>
    buf[i++] = '-';
 842:	fd070793          	add	a5,a4,-48
 846:	00878733          	add	a4,a5,s0
 84a:	02d00793          	li	a5,45
 84e:	fef70823          	sb	a5,-16(a4)
 852:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 856:	02e05663          	blez	a4,882 <printint+0x92>
 85a:	fc040793          	add	a5,s0,-64
 85e:	00e78933          	add	s2,a5,a4
 862:	fff78993          	add	s3,a5,-1
 866:	99ba                	add	s3,s3,a4
 868:	377d                	addw	a4,a4,-1
 86a:	1702                	sll	a4,a4,0x20
 86c:	9301                	srl	a4,a4,0x20
 86e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 872:	fff94583          	lbu	a1,-1(s2)
 876:	8526                	mv	a0,s1
 878:	f5bff0ef          	jal	7d2 <putc>
  while(--i >= 0)
 87c:	197d                	add	s2,s2,-1
 87e:	ff391ae3          	bne	s2,s3,872 <printint+0x82>
}
 882:	70e2                	ld	ra,56(sp)
 884:	7442                	ld	s0,48(sp)
 886:	74a2                	ld	s1,40(sp)
 888:	7902                	ld	s2,32(sp)
 88a:	69e2                	ld	s3,24(sp)
 88c:	6121                	add	sp,sp,64
 88e:	8082                	ret
    x = -xx;
 890:	40b005bb          	negw	a1,a1
    neg = 1;
 894:	4885                	li	a7,1
    x = -xx;
 896:	bf95                	j	80a <printint+0x1a>

0000000000000898 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 898:	711d                	add	sp,sp,-96
 89a:	ec86                	sd	ra,88(sp)
 89c:	e8a2                	sd	s0,80(sp)
 89e:	e4a6                	sd	s1,72(sp)
 8a0:	e0ca                	sd	s2,64(sp)
 8a2:	fc4e                	sd	s3,56(sp)
 8a4:	f852                	sd	s4,48(sp)
 8a6:	f456                	sd	s5,40(sp)
 8a8:	f05a                	sd	s6,32(sp)
 8aa:	ec5e                	sd	s7,24(sp)
 8ac:	e862                	sd	s8,16(sp)
 8ae:	e466                	sd	s9,8(sp)
 8b0:	e06a                	sd	s10,0(sp)
 8b2:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8b4:	0005c903          	lbu	s2,0(a1)
 8b8:	24090763          	beqz	s2,b06 <vprintf+0x26e>
 8bc:	8b2a                	mv	s6,a0
 8be:	8a2e                	mv	s4,a1
 8c0:	8bb2                	mv	s7,a2
  state = 0;
 8c2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 8c4:	4481                	li	s1,0
 8c6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 8c8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 8cc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 8d0:	06c00c93          	li	s9,108
 8d4:	a005                	j	8f4 <vprintf+0x5c>
        putc(fd, c0);
 8d6:	85ca                	mv	a1,s2
 8d8:	855a                	mv	a0,s6
 8da:	ef9ff0ef          	jal	7d2 <putc>
 8de:	a019                	j	8e4 <vprintf+0x4c>
    } else if(state == '%'){
 8e0:	03598263          	beq	s3,s5,904 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 8e4:	2485                	addw	s1,s1,1
 8e6:	8726                	mv	a4,s1
 8e8:	009a07b3          	add	a5,s4,s1
 8ec:	0007c903          	lbu	s2,0(a5)
 8f0:	20090b63          	beqz	s2,b06 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 8f4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8f8:	fe0994e3          	bnez	s3,8e0 <vprintf+0x48>
      if(c0 == '%'){
 8fc:	fd579de3          	bne	a5,s5,8d6 <vprintf+0x3e>
        state = '%';
 900:	89be                	mv	s3,a5
 902:	b7cd                	j	8e4 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 904:	c7c9                	beqz	a5,98e <vprintf+0xf6>
 906:	00ea06b3          	add	a3,s4,a4
 90a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 90e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 910:	c681                	beqz	a3,918 <vprintf+0x80>
 912:	9752                	add	a4,a4,s4
 914:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 918:	03878f63          	beq	a5,s8,956 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 91c:	05978963          	beq	a5,s9,96e <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 920:	07500713          	li	a4,117
 924:	0ee78363          	beq	a5,a4,a0a <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 928:	07800713          	li	a4,120
 92c:	12e78563          	beq	a5,a4,a56 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 930:	07000713          	li	a4,112
 934:	14e78a63          	beq	a5,a4,a88 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 938:	07300713          	li	a4,115
 93c:	18e78863          	beq	a5,a4,acc <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 940:	02500713          	li	a4,37
 944:	04e79563          	bne	a5,a4,98e <vprintf+0xf6>
        putc(fd, '%');
 948:	02500593          	li	a1,37
 94c:	855a                	mv	a0,s6
 94e:	e85ff0ef          	jal	7d2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 952:	4981                	li	s3,0
 954:	bf41                	j	8e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 956:	008b8913          	add	s2,s7,8
 95a:	4685                	li	a3,1
 95c:	4629                	li	a2,10
 95e:	000ba583          	lw	a1,0(s7)
 962:	855a                	mv	a0,s6
 964:	e8dff0ef          	jal	7f0 <printint>
 968:	8bca                	mv	s7,s2
      state = 0;
 96a:	4981                	li	s3,0
 96c:	bfa5                	j	8e4 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 96e:	06400793          	li	a5,100
 972:	02f68963          	beq	a3,a5,9a4 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 976:	06c00793          	li	a5,108
 97a:	04f68263          	beq	a3,a5,9be <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 97e:	07500793          	li	a5,117
 982:	0af68063          	beq	a3,a5,a22 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 986:	07800793          	li	a5,120
 98a:	0ef68263          	beq	a3,a5,a6e <vprintf+0x1d6>
        putc(fd, '%');
 98e:	02500593          	li	a1,37
 992:	855a                	mv	a0,s6
 994:	e3fff0ef          	jal	7d2 <putc>
        putc(fd, c0);
 998:	85ca                	mv	a1,s2
 99a:	855a                	mv	a0,s6
 99c:	e37ff0ef          	jal	7d2 <putc>
      state = 0;
 9a0:	4981                	li	s3,0
 9a2:	b789                	j	8e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9a4:	008b8913          	add	s2,s7,8
 9a8:	4685                	li	a3,1
 9aa:	4629                	li	a2,10
 9ac:	000ba583          	lw	a1,0(s7)
 9b0:	855a                	mv	a0,s6
 9b2:	e3fff0ef          	jal	7f0 <printint>
        i += 1;
 9b6:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 9b8:	8bca                	mv	s7,s2
      state = 0;
 9ba:	4981                	li	s3,0
        i += 1;
 9bc:	b725                	j	8e4 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9be:	06400793          	li	a5,100
 9c2:	02f60763          	beq	a2,a5,9f0 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 9c6:	07500793          	li	a5,117
 9ca:	06f60963          	beq	a2,a5,a3c <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 9ce:	07800793          	li	a5,120
 9d2:	faf61ee3          	bne	a2,a5,98e <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9d6:	008b8913          	add	s2,s7,8
 9da:	4681                	li	a3,0
 9dc:	4641                	li	a2,16
 9de:	000ba583          	lw	a1,0(s7)
 9e2:	855a                	mv	a0,s6
 9e4:	e0dff0ef          	jal	7f0 <printint>
        i += 2;
 9e8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 9ea:	8bca                	mv	s7,s2
      state = 0;
 9ec:	4981                	li	s3,0
        i += 2;
 9ee:	bddd                	j	8e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9f0:	008b8913          	add	s2,s7,8
 9f4:	4685                	li	a3,1
 9f6:	4629                	li	a2,10
 9f8:	000ba583          	lw	a1,0(s7)
 9fc:	855a                	mv	a0,s6
 9fe:	df3ff0ef          	jal	7f0 <printint>
        i += 2;
 a02:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a04:	8bca                	mv	s7,s2
      state = 0;
 a06:	4981                	li	s3,0
        i += 2;
 a08:	bdf1                	j	8e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 a0a:	008b8913          	add	s2,s7,8
 a0e:	4681                	li	a3,0
 a10:	4629                	li	a2,10
 a12:	000ba583          	lw	a1,0(s7)
 a16:	855a                	mv	a0,s6
 a18:	dd9ff0ef          	jal	7f0 <printint>
 a1c:	8bca                	mv	s7,s2
      state = 0;
 a1e:	4981                	li	s3,0
 a20:	b5d1                	j	8e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a22:	008b8913          	add	s2,s7,8
 a26:	4681                	li	a3,0
 a28:	4629                	li	a2,10
 a2a:	000ba583          	lw	a1,0(s7)
 a2e:	855a                	mv	a0,s6
 a30:	dc1ff0ef          	jal	7f0 <printint>
        i += 1;
 a34:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a36:	8bca                	mv	s7,s2
      state = 0;
 a38:	4981                	li	s3,0
        i += 1;
 a3a:	b56d                	j	8e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a3c:	008b8913          	add	s2,s7,8
 a40:	4681                	li	a3,0
 a42:	4629                	li	a2,10
 a44:	000ba583          	lw	a1,0(s7)
 a48:	855a                	mv	a0,s6
 a4a:	da7ff0ef          	jal	7f0 <printint>
        i += 2;
 a4e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a50:	8bca                	mv	s7,s2
      state = 0;
 a52:	4981                	li	s3,0
        i += 2;
 a54:	bd41                	j	8e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 a56:	008b8913          	add	s2,s7,8
 a5a:	4681                	li	a3,0
 a5c:	4641                	li	a2,16
 a5e:	000ba583          	lw	a1,0(s7)
 a62:	855a                	mv	a0,s6
 a64:	d8dff0ef          	jal	7f0 <printint>
 a68:	8bca                	mv	s7,s2
      state = 0;
 a6a:	4981                	li	s3,0
 a6c:	bda5                	j	8e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a6e:	008b8913          	add	s2,s7,8
 a72:	4681                	li	a3,0
 a74:	4641                	li	a2,16
 a76:	000ba583          	lw	a1,0(s7)
 a7a:	855a                	mv	a0,s6
 a7c:	d75ff0ef          	jal	7f0 <printint>
        i += 1;
 a80:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a82:	8bca                	mv	s7,s2
      state = 0;
 a84:	4981                	li	s3,0
        i += 1;
 a86:	bdb9                	j	8e4 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 a88:	008b8d13          	add	s10,s7,8
 a8c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a90:	03000593          	li	a1,48
 a94:	855a                	mv	a0,s6
 a96:	d3dff0ef          	jal	7d2 <putc>
  putc(fd, 'x');
 a9a:	07800593          	li	a1,120
 a9e:	855a                	mv	a0,s6
 aa0:	d33ff0ef          	jal	7d2 <putc>
 aa4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 aa6:	00000b97          	auipc	s7,0x0
 aaa:	37ab8b93          	add	s7,s7,890 # e20 <digits>
 aae:	03c9d793          	srl	a5,s3,0x3c
 ab2:	97de                	add	a5,a5,s7
 ab4:	0007c583          	lbu	a1,0(a5)
 ab8:	855a                	mv	a0,s6
 aba:	d19ff0ef          	jal	7d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 abe:	0992                	sll	s3,s3,0x4
 ac0:	397d                	addw	s2,s2,-1
 ac2:	fe0916e3          	bnez	s2,aae <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 ac6:	8bea                	mv	s7,s10
      state = 0;
 ac8:	4981                	li	s3,0
 aca:	bd29                	j	8e4 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 acc:	008b8993          	add	s3,s7,8
 ad0:	000bb903          	ld	s2,0(s7)
 ad4:	00090f63          	beqz	s2,af2 <vprintf+0x25a>
        for(; *s; s++)
 ad8:	00094583          	lbu	a1,0(s2)
 adc:	c195                	beqz	a1,b00 <vprintf+0x268>
          putc(fd, *s);
 ade:	855a                	mv	a0,s6
 ae0:	cf3ff0ef          	jal	7d2 <putc>
        for(; *s; s++)
 ae4:	0905                	add	s2,s2,1
 ae6:	00094583          	lbu	a1,0(s2)
 aea:	f9f5                	bnez	a1,ade <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 aec:	8bce                	mv	s7,s3
      state = 0;
 aee:	4981                	li	s3,0
 af0:	bbd5                	j	8e4 <vprintf+0x4c>
          s = "(null)";
 af2:	00000917          	auipc	s2,0x0
 af6:	32690913          	add	s2,s2,806 # e18 <malloc+0x218>
        for(; *s; s++)
 afa:	02800593          	li	a1,40
 afe:	b7c5                	j	ade <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b00:	8bce                	mv	s7,s3
      state = 0;
 b02:	4981                	li	s3,0
 b04:	b3c5                	j	8e4 <vprintf+0x4c>
    }
  }
}
 b06:	60e6                	ld	ra,88(sp)
 b08:	6446                	ld	s0,80(sp)
 b0a:	64a6                	ld	s1,72(sp)
 b0c:	6906                	ld	s2,64(sp)
 b0e:	79e2                	ld	s3,56(sp)
 b10:	7a42                	ld	s4,48(sp)
 b12:	7aa2                	ld	s5,40(sp)
 b14:	7b02                	ld	s6,32(sp)
 b16:	6be2                	ld	s7,24(sp)
 b18:	6c42                	ld	s8,16(sp)
 b1a:	6ca2                	ld	s9,8(sp)
 b1c:	6d02                	ld	s10,0(sp)
 b1e:	6125                	add	sp,sp,96
 b20:	8082                	ret

0000000000000b22 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b22:	715d                	add	sp,sp,-80
 b24:	ec06                	sd	ra,24(sp)
 b26:	e822                	sd	s0,16(sp)
 b28:	1000                	add	s0,sp,32
 b2a:	e010                	sd	a2,0(s0)
 b2c:	e414                	sd	a3,8(s0)
 b2e:	e818                	sd	a4,16(s0)
 b30:	ec1c                	sd	a5,24(s0)
 b32:	03043023          	sd	a6,32(s0)
 b36:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b3a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b3e:	8622                	mv	a2,s0
 b40:	d59ff0ef          	jal	898 <vprintf>
}
 b44:	60e2                	ld	ra,24(sp)
 b46:	6442                	ld	s0,16(sp)
 b48:	6161                	add	sp,sp,80
 b4a:	8082                	ret

0000000000000b4c <printf>:

void
printf(const char *fmt, ...)
{
 b4c:	711d                	add	sp,sp,-96
 b4e:	ec06                	sd	ra,24(sp)
 b50:	e822                	sd	s0,16(sp)
 b52:	1000                	add	s0,sp,32
 b54:	e40c                	sd	a1,8(s0)
 b56:	e810                	sd	a2,16(s0)
 b58:	ec14                	sd	a3,24(s0)
 b5a:	f018                	sd	a4,32(s0)
 b5c:	f41c                	sd	a5,40(s0)
 b5e:	03043823          	sd	a6,48(s0)
 b62:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b66:	00840613          	add	a2,s0,8
 b6a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b6e:	85aa                	mv	a1,a0
 b70:	4505                	li	a0,1
 b72:	d27ff0ef          	jal	898 <vprintf>
}
 b76:	60e2                	ld	ra,24(sp)
 b78:	6442                	ld	s0,16(sp)
 b7a:	6125                	add	sp,sp,96
 b7c:	8082                	ret

0000000000000b7e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b7e:	1141                	add	sp,sp,-16
 b80:	e422                	sd	s0,8(sp)
 b82:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b84:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b88:	00000797          	auipc	a5,0x0
 b8c:	4887b783          	ld	a5,1160(a5) # 1010 <freep>
 b90:	a02d                	j	bba <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b92:	4618                	lw	a4,8(a2)
 b94:	9f2d                	addw	a4,a4,a1
 b96:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b9a:	6398                	ld	a4,0(a5)
 b9c:	6310                	ld	a2,0(a4)
 b9e:	a83d                	j	bdc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ba0:	ff852703          	lw	a4,-8(a0)
 ba4:	9f31                	addw	a4,a4,a2
 ba6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ba8:	ff053683          	ld	a3,-16(a0)
 bac:	a091                	j	bf0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bae:	6398                	ld	a4,0(a5)
 bb0:	00e7e463          	bltu	a5,a4,bb8 <free+0x3a>
 bb4:	00e6ea63          	bltu	a3,a4,bc8 <free+0x4a>
{
 bb8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bba:	fed7fae3          	bgeu	a5,a3,bae <free+0x30>
 bbe:	6398                	ld	a4,0(a5)
 bc0:	00e6e463          	bltu	a3,a4,bc8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bc4:	fee7eae3          	bltu	a5,a4,bb8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 bc8:	ff852583          	lw	a1,-8(a0)
 bcc:	6390                	ld	a2,0(a5)
 bce:	02059813          	sll	a6,a1,0x20
 bd2:	01c85713          	srl	a4,a6,0x1c
 bd6:	9736                	add	a4,a4,a3
 bd8:	fae60de3          	beq	a2,a4,b92 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bdc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 be0:	4790                	lw	a2,8(a5)
 be2:	02061593          	sll	a1,a2,0x20
 be6:	01c5d713          	srl	a4,a1,0x1c
 bea:	973e                	add	a4,a4,a5
 bec:	fae68ae3          	beq	a3,a4,ba0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 bf0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bf2:	00000717          	auipc	a4,0x0
 bf6:	40f73f23          	sd	a5,1054(a4) # 1010 <freep>
}
 bfa:	6422                	ld	s0,8(sp)
 bfc:	0141                	add	sp,sp,16
 bfe:	8082                	ret

0000000000000c00 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c00:	7139                	add	sp,sp,-64
 c02:	fc06                	sd	ra,56(sp)
 c04:	f822                	sd	s0,48(sp)
 c06:	f426                	sd	s1,40(sp)
 c08:	f04a                	sd	s2,32(sp)
 c0a:	ec4e                	sd	s3,24(sp)
 c0c:	e852                	sd	s4,16(sp)
 c0e:	e456                	sd	s5,8(sp)
 c10:	e05a                	sd	s6,0(sp)
 c12:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c14:	02051493          	sll	s1,a0,0x20
 c18:	9081                	srl	s1,s1,0x20
 c1a:	04bd                	add	s1,s1,15
 c1c:	8091                	srl	s1,s1,0x4
 c1e:	0014899b          	addw	s3,s1,1
 c22:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 c24:	00000517          	auipc	a0,0x0
 c28:	3ec53503          	ld	a0,1004(a0) # 1010 <freep>
 c2c:	c515                	beqz	a0,c58 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c2e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c30:	4798                	lw	a4,8(a5)
 c32:	02977f63          	bgeu	a4,s1,c70 <malloc+0x70>
  if(nu < 4096)
 c36:	8a4e                	mv	s4,s3
 c38:	0009871b          	sext.w	a4,s3
 c3c:	6685                	lui	a3,0x1
 c3e:	00d77363          	bgeu	a4,a3,c44 <malloc+0x44>
 c42:	6a05                	lui	s4,0x1
 c44:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c48:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c4c:	00000917          	auipc	s2,0x0
 c50:	3c490913          	add	s2,s2,964 # 1010 <freep>
  if(p == (char*)-1)
 c54:	5afd                	li	s5,-1
 c56:	a885                	j	cc6 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 c58:	00000797          	auipc	a5,0x0
 c5c:	3c878793          	add	a5,a5,968 # 1020 <base>
 c60:	00000717          	auipc	a4,0x0
 c64:	3af73823          	sd	a5,944(a4) # 1010 <freep>
 c68:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c6a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c6e:	b7e1                	j	c36 <malloc+0x36>
      if(p->s.size == nunits)
 c70:	02e48c63          	beq	s1,a4,ca8 <malloc+0xa8>
        p->s.size -= nunits;
 c74:	4137073b          	subw	a4,a4,s3
 c78:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c7a:	02071693          	sll	a3,a4,0x20
 c7e:	01c6d713          	srl	a4,a3,0x1c
 c82:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c84:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c88:	00000717          	auipc	a4,0x0
 c8c:	38a73423          	sd	a0,904(a4) # 1010 <freep>
      return (void*)(p + 1);
 c90:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c94:	70e2                	ld	ra,56(sp)
 c96:	7442                	ld	s0,48(sp)
 c98:	74a2                	ld	s1,40(sp)
 c9a:	7902                	ld	s2,32(sp)
 c9c:	69e2                	ld	s3,24(sp)
 c9e:	6a42                	ld	s4,16(sp)
 ca0:	6aa2                	ld	s5,8(sp)
 ca2:	6b02                	ld	s6,0(sp)
 ca4:	6121                	add	sp,sp,64
 ca6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 ca8:	6398                	ld	a4,0(a5)
 caa:	e118                	sd	a4,0(a0)
 cac:	bff1                	j	c88 <malloc+0x88>
  hp->s.size = nu;
 cae:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cb2:	0541                	add	a0,a0,16
 cb4:	ecbff0ef          	jal	b7e <free>
  return freep;
 cb8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cbc:	dd61                	beqz	a0,c94 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cbe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cc0:	4798                	lw	a4,8(a5)
 cc2:	fa9777e3          	bgeu	a4,s1,c70 <malloc+0x70>
    if(p == freep)
 cc6:	00093703          	ld	a4,0(s2)
 cca:	853e                	mv	a0,a5
 ccc:	fef719e3          	bne	a4,a5,cbe <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 cd0:	8552                	mv	a0,s4
 cd2:	ab1ff0ef          	jal	782 <sbrk>
  if(p == (char*)-1)
 cd6:	fd551ce3          	bne	a0,s5,cae <malloc+0xae>
        return 0;
 cda:	4501                	li	a0,0
 cdc:	bf65                	j	c94 <malloc+0x94>
