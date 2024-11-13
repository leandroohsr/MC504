
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
  92:	750000ef          	jal	7e2 <uptime_nolock>
  96:	f4a43823          	sd	a0,-176(s0)
    char *args[2];
    int *processos = malloc(20 * sizeof(int));
  9a:	05000513          	li	a0,80
  9e:	37b000ef          	jal	c18 <malloc>
  a2:	f6a43023          	sd	a0,-160(s0)

    for (int i = 1; i <= 30; i++){
  a6:	4d85                	li	s11,1
                } else {       //pai
                    processos[j-1] = pid;
                }
            } else {
                //IO-BOUND
                args[0] = "rows";
  a8:	00001c17          	auipc	s8,0x1
  ac:	c80c0c13          	add	s8,s8,-896 # d28 <malloc+0x110>
                args[0] = "graphs";
  b0:	00001b97          	auipc	s7,0x1
  b4:	c50b8b93          	add	s7,s7,-944 # d00 <malloc+0xe8>
        }

        //pegando max e min
        int lim = segundo_atual;
        int vazao_max = -10;
        int vazao_min = 10000;
  b8:	6789                	lui	a5,0x2
  ba:	71078793          	add	a5,a5,1808 # 2710 <base+0x16f0>
  be:	f4f43c23          	sd	a5,-168(s0)
  c2:	a6bd                	j	430 <main+0x3bc>
                index_str[1] = index + '0';
  c4:	02f4879b          	addw	a5,s1,47
  c8:	0ff7f793          	zext.b	a5,a5
                index_str[2] = '\0';
  cc:	03000693          	li	a3,48
  d0:	a881                	j	120 <main+0xac>
                    ret = exec("graphs", args);
  d2:	f8040593          	add	a1,s0,-128
  d6:	855e                	mv	a0,s7
  d8:	66a000ef          	jal	742 <exec>
                    if (ret == -1){
  dc:	03a51263          	bne	a0,s10,100 <main+0x8c>
                        printf("erro ao executar graphs.c\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	c2850513          	add	a0,a0,-984 # d08 <malloc+0xf0>
  e8:	27d000ef          	jal	b64 <printf>
                        exit(1);
  ec:	4505                	li	a0,1
  ee:	61c000ef          	jal	70a <exit>
                args[0] = "rows";
  f2:	f9843023          	sd	s8,-128(s0)
                pid = fork();
  f6:	60c000ef          	jal	702 <fork>
                if (pid == 0){ //filho
  fa:	c529                	beqz	a0,144 <main+0xd0>
                    processos[j-1] = pid;
  fc:	00a92023          	sw	a0,0(s2)
        for (int j = 1; j < 21; j++){
 100:	2485                	addw	s1,s1,1
 102:	0911                	add	s2,s2,4
 104:	47d5                	li	a5,21
 106:	04f48f63          	beq	s1,a5,164 <main+0xf0>
            if (index < 10) {
 10a:	0004871b          	sext.w	a4,s1
 10e:	fff4879b          	addw	a5,s1,-1
 112:	fafa59e3          	bge	s4,a5,c4 <main+0x50>
                index_str[1] = (index - 10) + '0';
 116:	0254879b          	addw	a5,s1,37
 11a:	0ff7f793          	zext.b	a5,a5
 11e:	86e6                	mv	a3,s9
                index_str[0] = '0';
 120:	f6d40c23          	sb	a3,-136(s0)
                index_str[1] = index + '0';
 124:	f6f40ca3          	sb	a5,-135(s0)
                index_str[2] = '\0';
 128:	f6040d23          	sb	zero,-134(s0)
            args[1] = index_str;
 12c:	f9343423          	sd	s3,-120(s0)
            if (j <= X){
 130:	fceae1e3          	bltu	s5,a4,f2 <main+0x7e>
                args[0] = "graphs";
 134:	f9743023          	sd	s7,-128(s0)
                pid = fork();
 138:	5ca000ef          	jal	702 <fork>
                if (pid == 0){ //filho
 13c:	d959                	beqz	a0,d2 <main+0x5e>
                    processos[j-1] = pid;
 13e:	00a92023          	sw	a0,0(s2)
 142:	bf7d                	j	100 <main+0x8c>
                    ret = exec("rows", args);
 144:	f8040593          	add	a1,s0,-128
 148:	8562                	mv	a0,s8
 14a:	5f8000ef          	jal	742 <exec>
                    if (ret == -1){
 14e:	fba519e3          	bne	a0,s10,100 <main+0x8c>
                        printf("erro ao executar rows.c\n");
 152:	00001517          	auipc	a0,0x1
 156:	bde50513          	add	a0,a0,-1058 # d30 <malloc+0x118>
 15a:	20b000ef          	jal	b64 <printf>
                        exit(1);
 15e:	4505                	li	a0,1
 160:	5aa000ef          	jal	70a <exit>
        int *terminos = malloc(20 * sizeof(int));
 164:	05000513          	li	a0,80
 168:	2b1000ef          	jal	c18 <malloc>
 16c:	8a2a                	mv	s4,a0
        for (int j = 0; j < 20; j++){
 16e:	05050993          	add	s3,a0,80
        int *terminos = malloc(20 * sizeof(int));
 172:	84aa                	mv	s1,a0
            if (proc == -1){
 174:	597d                	li	s2,-1
                printf("pocesso falhou");
 176:	00001a97          	auipc	s5,0x1
 17a:	bdaa8a93          	add	s5,s5,-1062 # d50 <malloc+0x138>
 17e:	a809                	j	190 <main+0x11c>
                tempo_atual = uptime_nolock();
 180:	662000ef          	jal	7e2 <uptime_nolock>
                terminos[j] = (tempo_atual - t0_rodada);
 184:	4165053b          	subw	a0,a0,s6
 188:	c088                	sw	a0,0(s1)
        for (int j = 0; j < 20; j++){
 18a:	0491                	add	s1,s1,4
 18c:	01348b63          	beq	s1,s3,1a2 <main+0x12e>
            proc = wait(0);
 190:	4501                	li	a0,0
 192:	580000ef          	jal	712 <wait>
            if (proc == -1){
 196:	ff2515e3          	bne	a0,s2,180 <main+0x10c>
                printf("pocesso falhou");
 19a:	8556                	mv	a0,s5
 19c:	1c9000ef          	jal	b64 <printf>
 1a0:	b7ed                	j	18a <main+0x116>
        printf("RODADA %d ======================\n", i);
 1a2:	85ee                	mv	a1,s11
 1a4:	00001517          	auipc	a0,0x1
 1a8:	bbc50513          	add	a0,a0,-1092 # d60 <malloc+0x148>
 1ac:	1b9000ef          	jal	b64 <printf>
        for (int j = 0; j < 20; j++){
 1b0:	004a0593          	add	a1,s4,4
        printf("RODADA %d ======================\n", i);
 1b4:	4801                	li	a6,0
        for (int j = 0; j < 20; j++){
 1b6:	4501                	li	a0,0
            for (int k = j+1; k < 20; k++){
 1b8:	48d1                	li	a7,20
 1ba:	4e4d                	li	t3,19
 1bc:	008a0313          	add	t1,s4,8
 1c0:	a831                	j	1dc <main+0x168>
 1c2:	0791                	add	a5,a5,4
 1c4:	00d78a63          	beq	a5,a3,1d8 <main+0x164>
                if (terminos[k] < terminos[j]){
 1c8:	4398                	lw	a4,0(a5)
 1ca:	ffc5a603          	lw	a2,-4(a1)
 1ce:	fec75ae3          	bge	a4,a2,1c2 <main+0x14e>
                    terminos[j] = terminos[k];
 1d2:	fee5ae23          	sw	a4,-4(a1)
                    terminos[k] = temp;
 1d6:	b7f5                	j	1c2 <main+0x14e>
        for (int j = 0; j < 20; j++){
 1d8:	0805                	add	a6,a6,1
 1da:	0591                	add	a1,a1,4
            for (int k = j+1; k < 20; k++){
 1dc:	0015079b          	addw	a5,a0,1
 1e0:	0007851b          	sext.w	a0,a5
 1e4:	01150b63          	beq	a0,a7,1fa <main+0x186>
 1e8:	40fe06bb          	subw	a3,t3,a5
 1ec:	1682                	sll	a3,a3,0x20
 1ee:	9281                	srl	a3,a3,0x20
 1f0:	96c2                	add	a3,a3,a6
 1f2:	068a                	sll	a3,a3,0x2
 1f4:	969a                	add	a3,a3,t1
 1f6:	87ae                	mv	a5,a1
 1f8:	bfc1                	j	1c8 <main+0x154>
        int *vazoes = malloc(300 * sizeof(int));
 1fa:	4b000513          	li	a0,1200
 1fe:	21b000ef          	jal	c18 <malloc>
 202:	84aa                	mv	s1,a0
        for (int j = 0; j < 300; j++){
 204:	86aa                	mv	a3,a0
 206:	4b050713          	add	a4,a0,1200
        int *vazoes = malloc(300 * sizeof(int));
 20a:	87aa                	mv	a5,a0
            vazoes[j] = 0;
 20c:	0007a023          	sw	zero,0(a5)
        for (int j = 0; j < 300; j++){
 210:	0791                	add	a5,a5,4
 212:	fef71de3          	bne	a4,a5,20c <main+0x198>
        int segundo_atual = 0;
 216:	4601                	li	a2,0
        int index = 0;
 218:	4581                	li	a1,0
        while (index < 20){
 21a:	454d                	li	a0,19
 21c:	a021                	j	224 <main+0x1b0>
                segundo_atual += 1;
 21e:	2605                	addw	a2,a2,1
        while (index < 20){
 220:	02b54563          	blt	a0,a1,24a <main+0x1d6>
            if (10 * segundo_atual >= terminos[index]){
 224:	0026179b          	sllw	a5,a2,0x2
 228:	9fb1                	addw	a5,a5,a2
 22a:	00259713          	sll	a4,a1,0x2
 22e:	9752                	add	a4,a4,s4
 230:	0017979b          	sllw	a5,a5,0x1
 234:	4318                	lw	a4,0(a4)
 236:	fee7c4e3          	blt	a5,a4,21e <main+0x1aa>
                index += 1;
 23a:	2585                	addw	a1,a1,1
                vazoes[segundo_atual] += 1;
 23c:	00261793          	sll	a5,a2,0x2
 240:	97a6                	add	a5,a5,s1
 242:	4398                	lw	a4,0(a5)
 244:	2705                	addw	a4,a4,1 # ffffffff80000001 <base+0xffffffff7fffefe1>
 246:	c398                	sw	a4,0(a5)
 248:	bfe1                	j	220 <main+0x1ac>
        for (int j = 0; j <= lim; j++){
 24a:	02064e63          	bltz	a2,286 <main+0x212>
 24e:	02061793          	sll	a5,a2,0x20
 252:	01e7d813          	srl	a6,a5,0x1e
 256:	00448793          	add	a5,s1,4
 25a:	983e                	add	a6,a6,a5
        int vazao_min = 10000;
 25c:	f5843583          	ld	a1,-168(s0)
        int vazao_max = -10;
 260:	5759                	li	a4,-10
 262:	a031                	j	26e <main+0x1fa>
 264:	0005071b          	sext.w	a4,a0
        for (int j = 0; j <= lim; j++){
 268:	0691                	add	a3,a3,4
 26a:	03068163          	beq	a3,a6,28c <main+0x218>
            if (vazoes[j] < vazao_min) {
 26e:	429c                	lw	a5,0(a3)
 270:	853e                	mv	a0,a5
 272:	00f5d363          	bge	a1,a5,278 <main+0x204>
 276:	852e                	mv	a0,a1
 278:	0005059b          	sext.w	a1,a0
                vazao_min = vazoes[j];
            }
            if (vazoes[j] > vazao_max) {
 27c:	853e                	mv	a0,a5
 27e:	fee7d3e3          	bge	a5,a4,264 <main+0x1f0>
 282:	853a                	mv	a0,a4
 284:	b7c5                	j	264 <main+0x1f0>
        int vazao_min = 10000;
 286:	f5843583          	ld	a1,-168(s0)
        int vazao_max = -10;
 28a:	5759                	li	a4,-10
        }

        //normalizando
        int vazao_media = (20 * 100000) / lim;
        vazao_max *= 100000;
        vazao_min *= 100000;
 28c:	6561                	lui	a0,0x18
 28e:	6a05051b          	addw	a0,a0,1696 # 186a0 <base+0x17680>
 292:	02a585bb          	mulw	a1,a1,a0
        int vazao_media = (20 * 100000) / lim;
 296:	001e87b7          	lui	a5,0x1e8
 29a:	4807879b          	addw	a5,a5,1152 # 1e8480 <base+0x1e7460>
 29e:	02c7c7bb          	divw	a5,a5,a2

        int nominador = vazao_media - vazao_min;
 2a2:	9f8d                	subw	a5,a5,a1
        int denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero

        long long res = 100000 - (nominador * 100000 / denominador);
 2a4:	02a786bb          	mulw	a3,a5,a0
        vazao_max *= 100000;
 2a8:	02a707bb          	mulw	a5,a4,a0
        int denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero
 2ac:	9f8d                	subw	a5,a5,a1
        long long res = 100000 - (nominador * 100000 / denominador);
 2ae:	02f6c7bb          	divw	a5,a3,a5
 2b2:	9d1d                	subw	a0,a0,a5
        int vazao_norm = res % 100000;
 2b4:	67e1                	lui	a5,0x18
 2b6:	6a078793          	add	a5,a5,1696 # 186a0 <base+0x17680>
 2ba:	02f56b33          	rem	s6,a0,a5
        printf("vazao normalizada: %de-05\n", vazao_norm);
 2be:	85da                	mv	a1,s6
 2c0:	00001517          	auipc	a0,0x1
 2c4:	ac850513          	add	a0,a0,-1336 # d88 <malloc+0x170>
 2c8:	09d000ef          	jal	b64 <printf>

        free(terminos);
 2cc:	8552                	mv	a0,s4
 2ce:	0c9000ef          	jal	b96 <free>
        free(vazoes);
 2d2:	8526                	mv	a0,s1
 2d4:	0c3000ef          	jal	b96 <free>
        

        // EFICIENCIA DO SISTEMA DE ARQUIVOS
        int *eficiencias = malloc(Y * sizeof(int));
 2d8:	f6842783          	lw	a5,-152(s0)
 2dc:	0027951b          	sllw	a0,a5,0x2
 2e0:	139000ef          	jal	c18 <malloc>
 2e4:	89aa                	mv	s3,a0
        
        //lendo os dados da struct processo

        int l = 0;
        int eficiencia_atual;
        for (int k = 0; k < 20; k++){
 2e6:	4481                	li	s1,0
        int l = 0;
 2e8:	4901                	li	s2,0
        for (int k = 0; k < 20; k++){
 2ea:	4a51                	li	s4,20
 2ec:	a021                	j	2f4 <main+0x280>
 2ee:	2485                	addw	s1,s1,1
 2f0:	01448d63          	beq	s1,s4,30a <main+0x296>
            eficiencia_atual = get_eficiencia(k); //graphs.c devolve um valor negativo,
 2f4:	8526                	mv	a0,s1
 2f6:	4bc000ef          	jal	7b2 <get_eficiencia>
            if (eficiencia_atual >= 0 ){         //para que não impacte no cálculo
 2fa:	fe054ae3          	bltz	a0,2ee <main+0x27a>
                eficiencias[l] = eficiencia_atual;
 2fe:	00291793          	sll	a5,s2,0x2
 302:	97ce                	add	a5,a5,s3
 304:	c388                	sw	a0,0(a5)
                l += 1;
 306:	2905                	addw	s2,s2,1
 308:	b7dd                	j	2ee <main+0x27a>
 30a:	874e                	mv	a4,s3
 30c:	f6843683          	ld	a3,-152(s0)
 310:	02069793          	sll	a5,a3,0x20
 314:	01e7d613          	srl	a2,a5,0x1e
 318:	964e                	add	a2,a2,s3
            }
        }
        
        //somando
        int eficiencia_soma = 0;
 31a:	4681                	li	a3,0
        
        for(int j = 0; j < Y; j ++){
            eficiencia_soma += eficiencias[j];
 31c:	431c                	lw	a5,0(a4)
 31e:	9fb5                	addw	a5,a5,a3
 320:	0007869b          	sext.w	a3,a5
        for(int j = 0; j < Y; j ++){
 324:	0711                	add	a4,a4,4
 326:	fec71be3          	bne	a4,a2,31c <main+0x2a8>
        }

        //invertendo
        res = 100000 / eficiencia_soma;
 32a:	6ae1                	lui	s5,0x18
 32c:	6a0a8a9b          	addw	s5,s5,1696 # 186a0 <base+0x17680>
 330:	02facabb          	divw	s5,s5,a5
        int eficiencia_fim = res;
        printf("eficiencia: %de-05\n", eficiencia_fim);
 334:	000a859b          	sext.w	a1,s5
 338:	00001517          	auipc	a0,0x1
 33c:	a7050513          	add	a0,a0,-1424 # da8 <malloc+0x190>
 340:	025000ef          	jal	b64 <printf>
        free(eficiencias);
 344:	854e                	mv	a0,s3
 346:	051000ef          	jal	b96 <free>


        //OVERHEAD
        int *overheads = malloc(20 * sizeof(int));
 34a:	05000513          	li	a0,80
 34e:	0cb000ef          	jal	c18 <malloc>
 352:	8a2a                	mv	s4,a0
        

        //lendo os dados da struct do processo
        int overhead_atual;
        for (int k = 0; k < 20; k++){
 354:	84aa                	mv	s1,a0
        int *overheads = malloc(20 * sizeof(int));
 356:	89aa                	mv	s3,a0
        for (int k = 0; k < 20; k++){
 358:	4901                	li	s2,0
 35a:	4cd1                	li	s9,20
            overhead_atual = get_overhead(k);
 35c:	854a                	mv	a0,s2
 35e:	45c000ef          	jal	7ba <get_overhead>
            overheads[k] = overhead_atual;
 362:	00a9a023          	sw	a0,0(s3)
        for (int k = 0; k < 20; k++){
 366:	2905                	addw	s2,s2,1
 368:	0991                	add	s3,s3,4
 36a:	ff9919e3          	bne	s2,s9,35c <main+0x2e8>
 36e:	050a0693          	add	a3,s4,80
        }


        int overhead_soma = 0;
 372:	4701                	li	a4,0
        
        for(int j = 0; j < 20; j ++){
            overhead_soma += overheads[j];
 374:	409c                	lw	a5,0(s1)
 376:	9fb9                	addw	a5,a5,a4
 378:	0007871b          	sext.w	a4,a5
        for(int j = 0; j < 20; j ++){
 37c:	0491                	add	s1,s1,4
 37e:	fe969be3          	bne	a3,s1,374 <main+0x300>
        }

        //invertendo
        res = (100000 / overhead_soma);
 382:	6ce1                	lui	s9,0x18
 384:	6a0c8c9b          	addw	s9,s9,1696 # 186a0 <base+0x17680>
 388:	02fcccbb          	divw	s9,s9,a5
        int overhead_fim = res;
        printf("overhead: %de-05\n", overhead_fim);
 38c:	000c859b          	sext.w	a1,s9
 390:	00001517          	auipc	a0,0x1
 394:	a3050513          	add	a0,a0,-1488 # dc0 <malloc+0x1a8>
 398:	7cc000ef          	jal	b64 <printf>
        free(overheads);
 39c:	8552                	mv	a0,s4
 39e:	7f8000ef          	jal	b96 <free>

        //JUSTIÇA
        int *justicas = malloc(20 * sizeof(int));
 3a2:	05000513          	li	a0,80
 3a6:	073000ef          	jal	c18 <malloc>
 3aa:	8d2a                	mv	s10,a0

        //lendo do proc.c
        for (int k = 0; k < 20; k++){
 3ac:	84aa                	mv	s1,a0
        int *justicas = malloc(20 * sizeof(int));
 3ae:	89aa                	mv	s3,a0
        for (int k = 0; k < 20; k++){
 3b0:	4901                	li	s2,0
 3b2:	4a51                	li	s4,20
            justicas[k] = get_justica(k);
 3b4:	854a                	mv	a0,s2
 3b6:	41c000ef          	jal	7d2 <get_justica>
 3ba:	00a9a023          	sw	a0,0(s3)
        for (int k = 0; k < 20; k++){
 3be:	2905                	addw	s2,s2,1
 3c0:	0991                	add	s3,s3,4
 3c2:	ff4919e3          	bne	s2,s4,3b4 <main+0x340>
 3c6:	050d0613          	add	a2,s10,80
        }

        //somando
        long long justica_soma = 0; 
        long long justica_soma_quadrado = 0;
 3ca:	4681                	li	a3,0
        long long justica_soma = 0; 
 3cc:	4701                	li	a4,0
        for (int k = 0; k < 20; k++){
            justica_soma += justicas[k];
 3ce:	409c                	lw	a5,0(s1)
 3d0:	973e                	add	a4,a4,a5
            justica_soma_quadrado += justicas[k] * justicas[k];
 3d2:	02f787bb          	mulw	a5,a5,a5
 3d6:	96be                	add	a3,a3,a5
        for (int k = 0; k < 20; k++){
 3d8:	0491                	add	s1,s1,4
 3da:	fec49ae3          	bne	s1,a2,3ce <main+0x35a>
        }

        //normalizando
        long long nominador2 = justica_soma * justica_soma;
 3de:	02e70733          	mul	a4,a4,a4
        long long denominador2 = 20 * justica_soma_quadrado;
        res = (nominador2 * 100000) / denominador2;
 3e2:	67e1                	lui	a5,0x18
 3e4:	6a078793          	add	a5,a5,1696 # 186a0 <base+0x17680>
 3e8:	02f704b3          	mul	s1,a4,a5
        long long denominador2 = 20 * justica_soma_quadrado;
 3ec:	00269793          	sll	a5,a3,0x2
 3f0:	97b6                	add	a5,a5,a3
 3f2:	078a                	sll	a5,a5,0x2
        res = (nominador2 * 100000) / denominador2;
 3f4:	02f4c4b3          	div	s1,s1,a5
        int justica_fim = res;
 3f8:	2481                	sext.w	s1,s1
        printf("justica : %de-05\n", justica_fim);
 3fa:	85a6                	mv	a1,s1
 3fc:	00001517          	auipc	a0,0x1
 400:	9dc50513          	add	a0,a0,-1572 # dd8 <malloc+0x1c0>
 404:	760000ef          	jal	b64 <printf>
        free(justicas);
 408:	856a                	mv	a0,s10
 40a:	78c000ef          	jal	b96 <free>

        //DESEMPENHO
        int desempenho = (overhead_fim + eficiencia_fim + vazao_norm + justica_fim);
 40e:	019a85bb          	addw	a1,s5,s9
 412:	016585bb          	addw	a1,a1,s6
 416:	9da5                	addw	a1,a1,s1
        desempenho = desempenho >> 2;
        printf("desempenho: %de-05\n", desempenho);
 418:	4025d59b          	sraw	a1,a1,0x2
 41c:	00001517          	auipc	a0,0x1
 420:	9d450513          	add	a0,a0,-1580 # df0 <malloc+0x1d8>
 424:	740000ef          	jal	b64 <printf>
    for (int i = 1; i <= 30; i++){
 428:	2d85                	addw	s11,s11,1
 42a:	47fd                	li	a5,31
 42c:	02fd8e63          	beq	s11,a5,468 <main+0x3f4>
        initialize_metrics();
 430:	39a000ef          	jal	7ca <initialize_metrics>
        t0_rodada = uptime_nolock();
 434:	3ae000ef          	jal	7e2 <uptime_nolock>
 438:	8b2a                	mv	s6,a0
        uint X = (rand() % 9) + 6;
 43a:	c1fff0ef          	jal	58 <rand>
 43e:	47a5                	li	a5,9
 440:	02f567bb          	remw	a5,a0,a5
 444:	2799                	addw	a5,a5,6
 446:	00078a9b          	sext.w	s5,a5
        uint Y = 20 - X;
 44a:	4751                	li	a4,20
 44c:	40f707bb          	subw	a5,a4,a5
 450:	f6f42423          	sw	a5,-152(s0)
        for (int j = 1; j < 21; j++){
 454:	f6043903          	ld	s2,-160(s0)
 458:	4485                	li	s1,1
            if (index < 10) {
 45a:	4a25                	li	s4,9
                index_str[1] = (index - 10) + '0';
 45c:	03100c93          	li	s9,49
            args[1] = index_str;
 460:	f7840993          	add	s3,s0,-136
                    if (ret == -1){
 464:	5d7d                	li	s10,-1
 466:	b155                	j	10a <main+0x96>
    }

    int t_final = uptime_nolock();
 468:	37a000ef          	jal	7e2 <uptime_nolock>
    int variação_total = t_final - t0_total;
    printf("Tempo total usado para as 30 rodadas: %d\n", variação_total);
 46c:	f5043783          	ld	a5,-176(s0)
 470:	40f505bb          	subw	a1,a0,a5
 474:	00001517          	auipc	a0,0x1
 478:	99450513          	add	a0,a0,-1644 # e08 <malloc+0x1f0>
 47c:	6e8000ef          	jal	b64 <printf>
    return 0;
 480:	4501                	li	a0,0
 482:	70aa                	ld	ra,168(sp)
 484:	740a                	ld	s0,160(sp)
 486:	64ea                	ld	s1,152(sp)
 488:	694a                	ld	s2,144(sp)
 48a:	69aa                	ld	s3,136(sp)
 48c:	6a0a                	ld	s4,128(sp)
 48e:	7ae6                	ld	s5,120(sp)
 490:	7b46                	ld	s6,112(sp)
 492:	7ba6                	ld	s7,104(sp)
 494:	7c06                	ld	s8,96(sp)
 496:	6ce6                	ld	s9,88(sp)
 498:	6d46                	ld	s10,80(sp)
 49a:	6da6                	ld	s11,72(sp)
 49c:	614d                	add	sp,sp,176
 49e:	8082                	ret

00000000000004a0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 4a0:	1141                	add	sp,sp,-16
 4a2:	e406                	sd	ra,8(sp)
 4a4:	e022                	sd	s0,0(sp)
 4a6:	0800                	add	s0,sp,16
  extern int main();
  main();
 4a8:	bcdff0ef          	jal	74 <main>
  exit(0);
 4ac:	4501                	li	a0,0
 4ae:	25c000ef          	jal	70a <exit>

00000000000004b2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 4b2:	1141                	add	sp,sp,-16
 4b4:	e422                	sd	s0,8(sp)
 4b6:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4b8:	87aa                	mv	a5,a0
 4ba:	0585                	add	a1,a1,1
 4bc:	0785                	add	a5,a5,1
 4be:	fff5c703          	lbu	a4,-1(a1)
 4c2:	fee78fa3          	sb	a4,-1(a5)
 4c6:	fb75                	bnez	a4,4ba <strcpy+0x8>
    ;
  return os;
}
 4c8:	6422                	ld	s0,8(sp)
 4ca:	0141                	add	sp,sp,16
 4cc:	8082                	ret

00000000000004ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4ce:	1141                	add	sp,sp,-16
 4d0:	e422                	sd	s0,8(sp)
 4d2:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 4d4:	00054783          	lbu	a5,0(a0)
 4d8:	cb91                	beqz	a5,4ec <strcmp+0x1e>
 4da:	0005c703          	lbu	a4,0(a1)
 4de:	00f71763          	bne	a4,a5,4ec <strcmp+0x1e>
    p++, q++;
 4e2:	0505                	add	a0,a0,1
 4e4:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 4e6:	00054783          	lbu	a5,0(a0)
 4ea:	fbe5                	bnez	a5,4da <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4ec:	0005c503          	lbu	a0,0(a1)
}
 4f0:	40a7853b          	subw	a0,a5,a0
 4f4:	6422                	ld	s0,8(sp)
 4f6:	0141                	add	sp,sp,16
 4f8:	8082                	ret

00000000000004fa <strlen>:

uint
strlen(const char *s)
{
 4fa:	1141                	add	sp,sp,-16
 4fc:	e422                	sd	s0,8(sp)
 4fe:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 500:	00054783          	lbu	a5,0(a0)
 504:	cf91                	beqz	a5,520 <strlen+0x26>
 506:	0505                	add	a0,a0,1
 508:	87aa                	mv	a5,a0
 50a:	86be                	mv	a3,a5
 50c:	0785                	add	a5,a5,1
 50e:	fff7c703          	lbu	a4,-1(a5)
 512:	ff65                	bnez	a4,50a <strlen+0x10>
 514:	40a6853b          	subw	a0,a3,a0
 518:	2505                	addw	a0,a0,1
    ;
  return n;
}
 51a:	6422                	ld	s0,8(sp)
 51c:	0141                	add	sp,sp,16
 51e:	8082                	ret
  for(n = 0; s[n]; n++)
 520:	4501                	li	a0,0
 522:	bfe5                	j	51a <strlen+0x20>

0000000000000524 <memset>:

void*
memset(void *dst, int c, uint n)
{
 524:	1141                	add	sp,sp,-16
 526:	e422                	sd	s0,8(sp)
 528:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 52a:	ca19                	beqz	a2,540 <memset+0x1c>
 52c:	87aa                	mv	a5,a0
 52e:	1602                	sll	a2,a2,0x20
 530:	9201                	srl	a2,a2,0x20
 532:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 536:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 53a:	0785                	add	a5,a5,1
 53c:	fee79de3          	bne	a5,a4,536 <memset+0x12>
  }
  return dst;
}
 540:	6422                	ld	s0,8(sp)
 542:	0141                	add	sp,sp,16
 544:	8082                	ret

0000000000000546 <strchr>:

char*
strchr(const char *s, char c)
{
 546:	1141                	add	sp,sp,-16
 548:	e422                	sd	s0,8(sp)
 54a:	0800                	add	s0,sp,16
  for(; *s; s++)
 54c:	00054783          	lbu	a5,0(a0)
 550:	cb99                	beqz	a5,566 <strchr+0x20>
    if(*s == c)
 552:	00f58763          	beq	a1,a5,560 <strchr+0x1a>
  for(; *s; s++)
 556:	0505                	add	a0,a0,1
 558:	00054783          	lbu	a5,0(a0)
 55c:	fbfd                	bnez	a5,552 <strchr+0xc>
      return (char*)s;
  return 0;
 55e:	4501                	li	a0,0
}
 560:	6422                	ld	s0,8(sp)
 562:	0141                	add	sp,sp,16
 564:	8082                	ret
  return 0;
 566:	4501                	li	a0,0
 568:	bfe5                	j	560 <strchr+0x1a>

000000000000056a <gets>:

char*
gets(char *buf, int max)
{
 56a:	711d                	add	sp,sp,-96
 56c:	ec86                	sd	ra,88(sp)
 56e:	e8a2                	sd	s0,80(sp)
 570:	e4a6                	sd	s1,72(sp)
 572:	e0ca                	sd	s2,64(sp)
 574:	fc4e                	sd	s3,56(sp)
 576:	f852                	sd	s4,48(sp)
 578:	f456                	sd	s5,40(sp)
 57a:	f05a                	sd	s6,32(sp)
 57c:	ec5e                	sd	s7,24(sp)
 57e:	1080                	add	s0,sp,96
 580:	8baa                	mv	s7,a0
 582:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 584:	892a                	mv	s2,a0
 586:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 588:	4aa9                	li	s5,10
 58a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 58c:	89a6                	mv	s3,s1
 58e:	2485                	addw	s1,s1,1
 590:	0344d663          	bge	s1,s4,5bc <gets+0x52>
    cc = read(0, &c, 1);
 594:	4605                	li	a2,1
 596:	faf40593          	add	a1,s0,-81
 59a:	4501                	li	a0,0
 59c:	186000ef          	jal	722 <read>
    if(cc < 1)
 5a0:	00a05e63          	blez	a0,5bc <gets+0x52>
    buf[i++] = c;
 5a4:	faf44783          	lbu	a5,-81(s0)
 5a8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5ac:	01578763          	beq	a5,s5,5ba <gets+0x50>
 5b0:	0905                	add	s2,s2,1
 5b2:	fd679de3          	bne	a5,s6,58c <gets+0x22>
  for(i=0; i+1 < max; ){
 5b6:	89a6                	mv	s3,s1
 5b8:	a011                	j	5bc <gets+0x52>
 5ba:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5bc:	99de                	add	s3,s3,s7
 5be:	00098023          	sb	zero,0(s3)
  return buf;
}
 5c2:	855e                	mv	a0,s7
 5c4:	60e6                	ld	ra,88(sp)
 5c6:	6446                	ld	s0,80(sp)
 5c8:	64a6                	ld	s1,72(sp)
 5ca:	6906                	ld	s2,64(sp)
 5cc:	79e2                	ld	s3,56(sp)
 5ce:	7a42                	ld	s4,48(sp)
 5d0:	7aa2                	ld	s5,40(sp)
 5d2:	7b02                	ld	s6,32(sp)
 5d4:	6be2                	ld	s7,24(sp)
 5d6:	6125                	add	sp,sp,96
 5d8:	8082                	ret

00000000000005da <stat>:

int
stat(const char *n, struct stat *st)
{
 5da:	1101                	add	sp,sp,-32
 5dc:	ec06                	sd	ra,24(sp)
 5de:	e822                	sd	s0,16(sp)
 5e0:	e426                	sd	s1,8(sp)
 5e2:	e04a                	sd	s2,0(sp)
 5e4:	1000                	add	s0,sp,32
 5e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5e8:	4581                	li	a1,0
 5ea:	160000ef          	jal	74a <open>
  if(fd < 0)
 5ee:	02054163          	bltz	a0,610 <stat+0x36>
 5f2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5f4:	85ca                	mv	a1,s2
 5f6:	16c000ef          	jal	762 <fstat>
 5fa:	892a                	mv	s2,a0
  close(fd);
 5fc:	8526                	mv	a0,s1
 5fe:	134000ef          	jal	732 <close>
  return r;
}
 602:	854a                	mv	a0,s2
 604:	60e2                	ld	ra,24(sp)
 606:	6442                	ld	s0,16(sp)
 608:	64a2                	ld	s1,8(sp)
 60a:	6902                	ld	s2,0(sp)
 60c:	6105                	add	sp,sp,32
 60e:	8082                	ret
    return -1;
 610:	597d                	li	s2,-1
 612:	bfc5                	j	602 <stat+0x28>

0000000000000614 <atoi>:

int
atoi(const char *s)
{
 614:	1141                	add	sp,sp,-16
 616:	e422                	sd	s0,8(sp)
 618:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 61a:	00054683          	lbu	a3,0(a0)
 61e:	fd06879b          	addw	a5,a3,-48
 622:	0ff7f793          	zext.b	a5,a5
 626:	4625                	li	a2,9
 628:	02f66863          	bltu	a2,a5,658 <atoi+0x44>
 62c:	872a                	mv	a4,a0
  n = 0;
 62e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 630:	0705                	add	a4,a4,1
 632:	0025179b          	sllw	a5,a0,0x2
 636:	9fa9                	addw	a5,a5,a0
 638:	0017979b          	sllw	a5,a5,0x1
 63c:	9fb5                	addw	a5,a5,a3
 63e:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 642:	00074683          	lbu	a3,0(a4)
 646:	fd06879b          	addw	a5,a3,-48
 64a:	0ff7f793          	zext.b	a5,a5
 64e:	fef671e3          	bgeu	a2,a5,630 <atoi+0x1c>
  return n;
}
 652:	6422                	ld	s0,8(sp)
 654:	0141                	add	sp,sp,16
 656:	8082                	ret
  n = 0;
 658:	4501                	li	a0,0
 65a:	bfe5                	j	652 <atoi+0x3e>

000000000000065c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 65c:	1141                	add	sp,sp,-16
 65e:	e422                	sd	s0,8(sp)
 660:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 662:	02b57463          	bgeu	a0,a1,68a <memmove+0x2e>
    while(n-- > 0)
 666:	00c05f63          	blez	a2,684 <memmove+0x28>
 66a:	1602                	sll	a2,a2,0x20
 66c:	9201                	srl	a2,a2,0x20
 66e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 672:	872a                	mv	a4,a0
      *dst++ = *src++;
 674:	0585                	add	a1,a1,1
 676:	0705                	add	a4,a4,1
 678:	fff5c683          	lbu	a3,-1(a1)
 67c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 680:	fee79ae3          	bne	a5,a4,674 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 684:	6422                	ld	s0,8(sp)
 686:	0141                	add	sp,sp,16
 688:	8082                	ret
    dst += n;
 68a:	00c50733          	add	a4,a0,a2
    src += n;
 68e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 690:	fec05ae3          	blez	a2,684 <memmove+0x28>
 694:	fff6079b          	addw	a5,a2,-1
 698:	1782                	sll	a5,a5,0x20
 69a:	9381                	srl	a5,a5,0x20
 69c:	fff7c793          	not	a5,a5
 6a0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6a2:	15fd                	add	a1,a1,-1
 6a4:	177d                	add	a4,a4,-1
 6a6:	0005c683          	lbu	a3,0(a1)
 6aa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6ae:	fee79ae3          	bne	a5,a4,6a2 <memmove+0x46>
 6b2:	bfc9                	j	684 <memmove+0x28>

00000000000006b4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6b4:	1141                	add	sp,sp,-16
 6b6:	e422                	sd	s0,8(sp)
 6b8:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6ba:	ca05                	beqz	a2,6ea <memcmp+0x36>
 6bc:	fff6069b          	addw	a3,a2,-1
 6c0:	1682                	sll	a3,a3,0x20
 6c2:	9281                	srl	a3,a3,0x20
 6c4:	0685                	add	a3,a3,1
 6c6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6c8:	00054783          	lbu	a5,0(a0)
 6cc:	0005c703          	lbu	a4,0(a1)
 6d0:	00e79863          	bne	a5,a4,6e0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6d4:	0505                	add	a0,a0,1
    p2++;
 6d6:	0585                	add	a1,a1,1
  while (n-- > 0) {
 6d8:	fed518e3          	bne	a0,a3,6c8 <memcmp+0x14>
  }
  return 0;
 6dc:	4501                	li	a0,0
 6de:	a019                	j	6e4 <memcmp+0x30>
      return *p1 - *p2;
 6e0:	40e7853b          	subw	a0,a5,a4
}
 6e4:	6422                	ld	s0,8(sp)
 6e6:	0141                	add	sp,sp,16
 6e8:	8082                	ret
  return 0;
 6ea:	4501                	li	a0,0
 6ec:	bfe5                	j	6e4 <memcmp+0x30>

00000000000006ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6ee:	1141                	add	sp,sp,-16
 6f0:	e406                	sd	ra,8(sp)
 6f2:	e022                	sd	s0,0(sp)
 6f4:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 6f6:	f67ff0ef          	jal	65c <memmove>
}
 6fa:	60a2                	ld	ra,8(sp)
 6fc:	6402                	ld	s0,0(sp)
 6fe:	0141                	add	sp,sp,16
 700:	8082                	ret

0000000000000702 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 702:	4885                	li	a7,1
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <exit>:
.global exit
exit:
 li a7, SYS_exit
 70a:	4889                	li	a7,2
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <wait>:
.global wait
wait:
 li a7, SYS_wait
 712:	488d                	li	a7,3
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 71a:	4891                	li	a7,4
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <read>:
.global read
read:
 li a7, SYS_read
 722:	4895                	li	a7,5
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <write>:
.global write
write:
 li a7, SYS_write
 72a:	48c1                	li	a7,16
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <close>:
.global close
close:
 li a7, SYS_close
 732:	48d5                	li	a7,21
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <kill>:
.global kill
kill:
 li a7, SYS_kill
 73a:	4899                	li	a7,6
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <exec>:
.global exec
exec:
 li a7, SYS_exec
 742:	489d                	li	a7,7
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <open>:
.global open
open:
 li a7, SYS_open
 74a:	48bd                	li	a7,15
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 752:	48c5                	li	a7,17
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 75a:	48c9                	li	a7,18
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 762:	48a1                	li	a7,8
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <link>:
.global link
link:
 li a7, SYS_link
 76a:	48cd                	li	a7,19
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 772:	48d1                	li	a7,20
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 77a:	48a5                	li	a7,9
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <dup>:
.global dup
dup:
 li a7, SYS_dup
 782:	48a9                	li	a7,10
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 78a:	48ad                	li	a7,11
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 792:	48b1                	li	a7,12
 ecall
 794:	00000073          	ecall
 ret
 798:	8082                	ret

000000000000079a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 79a:	48b5                	li	a7,13
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7a2:	48b9                	li	a7,14
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 7aa:	48d9                	li	a7,22
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 7b2:	48dd                	li	a7,23
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	8082                	ret

00000000000007ba <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 7ba:	48e1                	li	a7,24
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 7c2:	48e5                	li	a7,25
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 7ca:	48e9                	li	a7,26
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 7d2:	48ed                	li	a7,27
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	8082                	ret

00000000000007da <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 7da:	48f1                	li	a7,28
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <uptime_nolock>:
.global uptime_nolock
uptime_nolock:
 li a7, SYS_uptime_nolock
 7e2:	48f5                	li	a7,29
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7ea:	1101                	add	sp,sp,-32
 7ec:	ec06                	sd	ra,24(sp)
 7ee:	e822                	sd	s0,16(sp)
 7f0:	1000                	add	s0,sp,32
 7f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7f6:	4605                	li	a2,1
 7f8:	fef40593          	add	a1,s0,-17
 7fc:	f2fff0ef          	jal	72a <write>
}
 800:	60e2                	ld	ra,24(sp)
 802:	6442                	ld	s0,16(sp)
 804:	6105                	add	sp,sp,32
 806:	8082                	ret

0000000000000808 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 808:	7139                	add	sp,sp,-64
 80a:	fc06                	sd	ra,56(sp)
 80c:	f822                	sd	s0,48(sp)
 80e:	f426                	sd	s1,40(sp)
 810:	f04a                	sd	s2,32(sp)
 812:	ec4e                	sd	s3,24(sp)
 814:	0080                	add	s0,sp,64
 816:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 818:	c299                	beqz	a3,81e <printint+0x16>
 81a:	0805c763          	bltz	a1,8a8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 81e:	2581                	sext.w	a1,a1
  neg = 0;
 820:	4881                	li	a7,0
 822:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 826:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 828:	2601                	sext.w	a2,a2
 82a:	00000517          	auipc	a0,0x0
 82e:	61650513          	add	a0,a0,1558 # e40 <digits>
 832:	883a                	mv	a6,a4
 834:	2705                	addw	a4,a4,1
 836:	02c5f7bb          	remuw	a5,a1,a2
 83a:	1782                	sll	a5,a5,0x20
 83c:	9381                	srl	a5,a5,0x20
 83e:	97aa                	add	a5,a5,a0
 840:	0007c783          	lbu	a5,0(a5)
 844:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 848:	0005879b          	sext.w	a5,a1
 84c:	02c5d5bb          	divuw	a1,a1,a2
 850:	0685                	add	a3,a3,1
 852:	fec7f0e3          	bgeu	a5,a2,832 <printint+0x2a>
  if(neg)
 856:	00088c63          	beqz	a7,86e <printint+0x66>
    buf[i++] = '-';
 85a:	fd070793          	add	a5,a4,-48
 85e:	00878733          	add	a4,a5,s0
 862:	02d00793          	li	a5,45
 866:	fef70823          	sb	a5,-16(a4)
 86a:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 86e:	02e05663          	blez	a4,89a <printint+0x92>
 872:	fc040793          	add	a5,s0,-64
 876:	00e78933          	add	s2,a5,a4
 87a:	fff78993          	add	s3,a5,-1
 87e:	99ba                	add	s3,s3,a4
 880:	377d                	addw	a4,a4,-1
 882:	1702                	sll	a4,a4,0x20
 884:	9301                	srl	a4,a4,0x20
 886:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 88a:	fff94583          	lbu	a1,-1(s2)
 88e:	8526                	mv	a0,s1
 890:	f5bff0ef          	jal	7ea <putc>
  while(--i >= 0)
 894:	197d                	add	s2,s2,-1
 896:	ff391ae3          	bne	s2,s3,88a <printint+0x82>
}
 89a:	70e2                	ld	ra,56(sp)
 89c:	7442                	ld	s0,48(sp)
 89e:	74a2                	ld	s1,40(sp)
 8a0:	7902                	ld	s2,32(sp)
 8a2:	69e2                	ld	s3,24(sp)
 8a4:	6121                	add	sp,sp,64
 8a6:	8082                	ret
    x = -xx;
 8a8:	40b005bb          	negw	a1,a1
    neg = 1;
 8ac:	4885                	li	a7,1
    x = -xx;
 8ae:	bf95                	j	822 <printint+0x1a>

00000000000008b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8b0:	711d                	add	sp,sp,-96
 8b2:	ec86                	sd	ra,88(sp)
 8b4:	e8a2                	sd	s0,80(sp)
 8b6:	e4a6                	sd	s1,72(sp)
 8b8:	e0ca                	sd	s2,64(sp)
 8ba:	fc4e                	sd	s3,56(sp)
 8bc:	f852                	sd	s4,48(sp)
 8be:	f456                	sd	s5,40(sp)
 8c0:	f05a                	sd	s6,32(sp)
 8c2:	ec5e                	sd	s7,24(sp)
 8c4:	e862                	sd	s8,16(sp)
 8c6:	e466                	sd	s9,8(sp)
 8c8:	e06a                	sd	s10,0(sp)
 8ca:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8cc:	0005c903          	lbu	s2,0(a1)
 8d0:	24090763          	beqz	s2,b1e <vprintf+0x26e>
 8d4:	8b2a                	mv	s6,a0
 8d6:	8a2e                	mv	s4,a1
 8d8:	8bb2                	mv	s7,a2
  state = 0;
 8da:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 8dc:	4481                	li	s1,0
 8de:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 8e0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 8e4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 8e8:	06c00c93          	li	s9,108
 8ec:	a005                	j	90c <vprintf+0x5c>
        putc(fd, c0);
 8ee:	85ca                	mv	a1,s2
 8f0:	855a                	mv	a0,s6
 8f2:	ef9ff0ef          	jal	7ea <putc>
 8f6:	a019                	j	8fc <vprintf+0x4c>
    } else if(state == '%'){
 8f8:	03598263          	beq	s3,s5,91c <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 8fc:	2485                	addw	s1,s1,1
 8fe:	8726                	mv	a4,s1
 900:	009a07b3          	add	a5,s4,s1
 904:	0007c903          	lbu	s2,0(a5)
 908:	20090b63          	beqz	s2,b1e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 90c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 910:	fe0994e3          	bnez	s3,8f8 <vprintf+0x48>
      if(c0 == '%'){
 914:	fd579de3          	bne	a5,s5,8ee <vprintf+0x3e>
        state = '%';
 918:	89be                	mv	s3,a5
 91a:	b7cd                	j	8fc <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 91c:	c7c9                	beqz	a5,9a6 <vprintf+0xf6>
 91e:	00ea06b3          	add	a3,s4,a4
 922:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 926:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 928:	c681                	beqz	a3,930 <vprintf+0x80>
 92a:	9752                	add	a4,a4,s4
 92c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 930:	03878f63          	beq	a5,s8,96e <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 934:	05978963          	beq	a5,s9,986 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 938:	07500713          	li	a4,117
 93c:	0ee78363          	beq	a5,a4,a22 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 940:	07800713          	li	a4,120
 944:	12e78563          	beq	a5,a4,a6e <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 948:	07000713          	li	a4,112
 94c:	14e78a63          	beq	a5,a4,aa0 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 950:	07300713          	li	a4,115
 954:	18e78863          	beq	a5,a4,ae4 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 958:	02500713          	li	a4,37
 95c:	04e79563          	bne	a5,a4,9a6 <vprintf+0xf6>
        putc(fd, '%');
 960:	02500593          	li	a1,37
 964:	855a                	mv	a0,s6
 966:	e85ff0ef          	jal	7ea <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 96a:	4981                	li	s3,0
 96c:	bf41                	j	8fc <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 96e:	008b8913          	add	s2,s7,8
 972:	4685                	li	a3,1
 974:	4629                	li	a2,10
 976:	000ba583          	lw	a1,0(s7)
 97a:	855a                	mv	a0,s6
 97c:	e8dff0ef          	jal	808 <printint>
 980:	8bca                	mv	s7,s2
      state = 0;
 982:	4981                	li	s3,0
 984:	bfa5                	j	8fc <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 986:	06400793          	li	a5,100
 98a:	02f68963          	beq	a3,a5,9bc <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 98e:	06c00793          	li	a5,108
 992:	04f68263          	beq	a3,a5,9d6 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 996:	07500793          	li	a5,117
 99a:	0af68063          	beq	a3,a5,a3a <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 99e:	07800793          	li	a5,120
 9a2:	0ef68263          	beq	a3,a5,a86 <vprintf+0x1d6>
        putc(fd, '%');
 9a6:	02500593          	li	a1,37
 9aa:	855a                	mv	a0,s6
 9ac:	e3fff0ef          	jal	7ea <putc>
        putc(fd, c0);
 9b0:	85ca                	mv	a1,s2
 9b2:	855a                	mv	a0,s6
 9b4:	e37ff0ef          	jal	7ea <putc>
      state = 0;
 9b8:	4981                	li	s3,0
 9ba:	b789                	j	8fc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9bc:	008b8913          	add	s2,s7,8
 9c0:	4685                	li	a3,1
 9c2:	4629                	li	a2,10
 9c4:	000ba583          	lw	a1,0(s7)
 9c8:	855a                	mv	a0,s6
 9ca:	e3fff0ef          	jal	808 <printint>
        i += 1;
 9ce:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 9d0:	8bca                	mv	s7,s2
      state = 0;
 9d2:	4981                	li	s3,0
        i += 1;
 9d4:	b725                	j	8fc <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9d6:	06400793          	li	a5,100
 9da:	02f60763          	beq	a2,a5,a08 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 9de:	07500793          	li	a5,117
 9e2:	06f60963          	beq	a2,a5,a54 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 9e6:	07800793          	li	a5,120
 9ea:	faf61ee3          	bne	a2,a5,9a6 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9ee:	008b8913          	add	s2,s7,8
 9f2:	4681                	li	a3,0
 9f4:	4641                	li	a2,16
 9f6:	000ba583          	lw	a1,0(s7)
 9fa:	855a                	mv	a0,s6
 9fc:	e0dff0ef          	jal	808 <printint>
        i += 2;
 a00:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a02:	8bca                	mv	s7,s2
      state = 0;
 a04:	4981                	li	s3,0
        i += 2;
 a06:	bddd                	j	8fc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a08:	008b8913          	add	s2,s7,8
 a0c:	4685                	li	a3,1
 a0e:	4629                	li	a2,10
 a10:	000ba583          	lw	a1,0(s7)
 a14:	855a                	mv	a0,s6
 a16:	df3ff0ef          	jal	808 <printint>
        i += 2;
 a1a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a1c:	8bca                	mv	s7,s2
      state = 0;
 a1e:	4981                	li	s3,0
        i += 2;
 a20:	bdf1                	j	8fc <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 a22:	008b8913          	add	s2,s7,8
 a26:	4681                	li	a3,0
 a28:	4629                	li	a2,10
 a2a:	000ba583          	lw	a1,0(s7)
 a2e:	855a                	mv	a0,s6
 a30:	dd9ff0ef          	jal	808 <printint>
 a34:	8bca                	mv	s7,s2
      state = 0;
 a36:	4981                	li	s3,0
 a38:	b5d1                	j	8fc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a3a:	008b8913          	add	s2,s7,8
 a3e:	4681                	li	a3,0
 a40:	4629                	li	a2,10
 a42:	000ba583          	lw	a1,0(s7)
 a46:	855a                	mv	a0,s6
 a48:	dc1ff0ef          	jal	808 <printint>
        i += 1;
 a4c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a4e:	8bca                	mv	s7,s2
      state = 0;
 a50:	4981                	li	s3,0
        i += 1;
 a52:	b56d                	j	8fc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a54:	008b8913          	add	s2,s7,8
 a58:	4681                	li	a3,0
 a5a:	4629                	li	a2,10
 a5c:	000ba583          	lw	a1,0(s7)
 a60:	855a                	mv	a0,s6
 a62:	da7ff0ef          	jal	808 <printint>
        i += 2;
 a66:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a68:	8bca                	mv	s7,s2
      state = 0;
 a6a:	4981                	li	s3,0
        i += 2;
 a6c:	bd41                	j	8fc <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 a6e:	008b8913          	add	s2,s7,8
 a72:	4681                	li	a3,0
 a74:	4641                	li	a2,16
 a76:	000ba583          	lw	a1,0(s7)
 a7a:	855a                	mv	a0,s6
 a7c:	d8dff0ef          	jal	808 <printint>
 a80:	8bca                	mv	s7,s2
      state = 0;
 a82:	4981                	li	s3,0
 a84:	bda5                	j	8fc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a86:	008b8913          	add	s2,s7,8
 a8a:	4681                	li	a3,0
 a8c:	4641                	li	a2,16
 a8e:	000ba583          	lw	a1,0(s7)
 a92:	855a                	mv	a0,s6
 a94:	d75ff0ef          	jal	808 <printint>
        i += 1;
 a98:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a9a:	8bca                	mv	s7,s2
      state = 0;
 a9c:	4981                	li	s3,0
        i += 1;
 a9e:	bdb9                	j	8fc <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 aa0:	008b8d13          	add	s10,s7,8
 aa4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 aa8:	03000593          	li	a1,48
 aac:	855a                	mv	a0,s6
 aae:	d3dff0ef          	jal	7ea <putc>
  putc(fd, 'x');
 ab2:	07800593          	li	a1,120
 ab6:	855a                	mv	a0,s6
 ab8:	d33ff0ef          	jal	7ea <putc>
 abc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 abe:	00000b97          	auipc	s7,0x0
 ac2:	382b8b93          	add	s7,s7,898 # e40 <digits>
 ac6:	03c9d793          	srl	a5,s3,0x3c
 aca:	97de                	add	a5,a5,s7
 acc:	0007c583          	lbu	a1,0(a5)
 ad0:	855a                	mv	a0,s6
 ad2:	d19ff0ef          	jal	7ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 ad6:	0992                	sll	s3,s3,0x4
 ad8:	397d                	addw	s2,s2,-1
 ada:	fe0916e3          	bnez	s2,ac6 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 ade:	8bea                	mv	s7,s10
      state = 0;
 ae0:	4981                	li	s3,0
 ae2:	bd29                	j	8fc <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 ae4:	008b8993          	add	s3,s7,8
 ae8:	000bb903          	ld	s2,0(s7)
 aec:	00090f63          	beqz	s2,b0a <vprintf+0x25a>
        for(; *s; s++)
 af0:	00094583          	lbu	a1,0(s2)
 af4:	c195                	beqz	a1,b18 <vprintf+0x268>
          putc(fd, *s);
 af6:	855a                	mv	a0,s6
 af8:	cf3ff0ef          	jal	7ea <putc>
        for(; *s; s++)
 afc:	0905                	add	s2,s2,1
 afe:	00094583          	lbu	a1,0(s2)
 b02:	f9f5                	bnez	a1,af6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b04:	8bce                	mv	s7,s3
      state = 0;
 b06:	4981                	li	s3,0
 b08:	bbd5                	j	8fc <vprintf+0x4c>
          s = "(null)";
 b0a:	00000917          	auipc	s2,0x0
 b0e:	32e90913          	add	s2,s2,814 # e38 <malloc+0x220>
        for(; *s; s++)
 b12:	02800593          	li	a1,40
 b16:	b7c5                	j	af6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b18:	8bce                	mv	s7,s3
      state = 0;
 b1a:	4981                	li	s3,0
 b1c:	b3c5                	j	8fc <vprintf+0x4c>
    }
  }
}
 b1e:	60e6                	ld	ra,88(sp)
 b20:	6446                	ld	s0,80(sp)
 b22:	64a6                	ld	s1,72(sp)
 b24:	6906                	ld	s2,64(sp)
 b26:	79e2                	ld	s3,56(sp)
 b28:	7a42                	ld	s4,48(sp)
 b2a:	7aa2                	ld	s5,40(sp)
 b2c:	7b02                	ld	s6,32(sp)
 b2e:	6be2                	ld	s7,24(sp)
 b30:	6c42                	ld	s8,16(sp)
 b32:	6ca2                	ld	s9,8(sp)
 b34:	6d02                	ld	s10,0(sp)
 b36:	6125                	add	sp,sp,96
 b38:	8082                	ret

0000000000000b3a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b3a:	715d                	add	sp,sp,-80
 b3c:	ec06                	sd	ra,24(sp)
 b3e:	e822                	sd	s0,16(sp)
 b40:	1000                	add	s0,sp,32
 b42:	e010                	sd	a2,0(s0)
 b44:	e414                	sd	a3,8(s0)
 b46:	e818                	sd	a4,16(s0)
 b48:	ec1c                	sd	a5,24(s0)
 b4a:	03043023          	sd	a6,32(s0)
 b4e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b52:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b56:	8622                	mv	a2,s0
 b58:	d59ff0ef          	jal	8b0 <vprintf>
}
 b5c:	60e2                	ld	ra,24(sp)
 b5e:	6442                	ld	s0,16(sp)
 b60:	6161                	add	sp,sp,80
 b62:	8082                	ret

0000000000000b64 <printf>:

void
printf(const char *fmt, ...)
{
 b64:	711d                	add	sp,sp,-96
 b66:	ec06                	sd	ra,24(sp)
 b68:	e822                	sd	s0,16(sp)
 b6a:	1000                	add	s0,sp,32
 b6c:	e40c                	sd	a1,8(s0)
 b6e:	e810                	sd	a2,16(s0)
 b70:	ec14                	sd	a3,24(s0)
 b72:	f018                	sd	a4,32(s0)
 b74:	f41c                	sd	a5,40(s0)
 b76:	03043823          	sd	a6,48(s0)
 b7a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b7e:	00840613          	add	a2,s0,8
 b82:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b86:	85aa                	mv	a1,a0
 b88:	4505                	li	a0,1
 b8a:	d27ff0ef          	jal	8b0 <vprintf>
}
 b8e:	60e2                	ld	ra,24(sp)
 b90:	6442                	ld	s0,16(sp)
 b92:	6125                	add	sp,sp,96
 b94:	8082                	ret

0000000000000b96 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b96:	1141                	add	sp,sp,-16
 b98:	e422                	sd	s0,8(sp)
 b9a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b9c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ba0:	00000797          	auipc	a5,0x0
 ba4:	4707b783          	ld	a5,1136(a5) # 1010 <freep>
 ba8:	a02d                	j	bd2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 baa:	4618                	lw	a4,8(a2)
 bac:	9f2d                	addw	a4,a4,a1
 bae:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 bb2:	6398                	ld	a4,0(a5)
 bb4:	6310                	ld	a2,0(a4)
 bb6:	a83d                	j	bf4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 bb8:	ff852703          	lw	a4,-8(a0)
 bbc:	9f31                	addw	a4,a4,a2
 bbe:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bc0:	ff053683          	ld	a3,-16(a0)
 bc4:	a091                	j	c08 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bc6:	6398                	ld	a4,0(a5)
 bc8:	00e7e463          	bltu	a5,a4,bd0 <free+0x3a>
 bcc:	00e6ea63          	bltu	a3,a4,be0 <free+0x4a>
{
 bd0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bd2:	fed7fae3          	bgeu	a5,a3,bc6 <free+0x30>
 bd6:	6398                	ld	a4,0(a5)
 bd8:	00e6e463          	bltu	a3,a4,be0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bdc:	fee7eae3          	bltu	a5,a4,bd0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 be0:	ff852583          	lw	a1,-8(a0)
 be4:	6390                	ld	a2,0(a5)
 be6:	02059813          	sll	a6,a1,0x20
 bea:	01c85713          	srl	a4,a6,0x1c
 bee:	9736                	add	a4,a4,a3
 bf0:	fae60de3          	beq	a2,a4,baa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bf4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bf8:	4790                	lw	a2,8(a5)
 bfa:	02061593          	sll	a1,a2,0x20
 bfe:	01c5d713          	srl	a4,a1,0x1c
 c02:	973e                	add	a4,a4,a5
 c04:	fae68ae3          	beq	a3,a4,bb8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 c08:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c0a:	00000717          	auipc	a4,0x0
 c0e:	40f73323          	sd	a5,1030(a4) # 1010 <freep>
}
 c12:	6422                	ld	s0,8(sp)
 c14:	0141                	add	sp,sp,16
 c16:	8082                	ret

0000000000000c18 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c18:	7139                	add	sp,sp,-64
 c1a:	fc06                	sd	ra,56(sp)
 c1c:	f822                	sd	s0,48(sp)
 c1e:	f426                	sd	s1,40(sp)
 c20:	f04a                	sd	s2,32(sp)
 c22:	ec4e                	sd	s3,24(sp)
 c24:	e852                	sd	s4,16(sp)
 c26:	e456                	sd	s5,8(sp)
 c28:	e05a                	sd	s6,0(sp)
 c2a:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c2c:	02051493          	sll	s1,a0,0x20
 c30:	9081                	srl	s1,s1,0x20
 c32:	04bd                	add	s1,s1,15
 c34:	8091                	srl	s1,s1,0x4
 c36:	0014899b          	addw	s3,s1,1
 c3a:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 c3c:	00000517          	auipc	a0,0x0
 c40:	3d453503          	ld	a0,980(a0) # 1010 <freep>
 c44:	c515                	beqz	a0,c70 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c46:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c48:	4798                	lw	a4,8(a5)
 c4a:	02977f63          	bgeu	a4,s1,c88 <malloc+0x70>
  if(nu < 4096)
 c4e:	8a4e                	mv	s4,s3
 c50:	0009871b          	sext.w	a4,s3
 c54:	6685                	lui	a3,0x1
 c56:	00d77363          	bgeu	a4,a3,c5c <malloc+0x44>
 c5a:	6a05                	lui	s4,0x1
 c5c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c60:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c64:	00000917          	auipc	s2,0x0
 c68:	3ac90913          	add	s2,s2,940 # 1010 <freep>
  if(p == (char*)-1)
 c6c:	5afd                	li	s5,-1
 c6e:	a885                	j	cde <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 c70:	00000797          	auipc	a5,0x0
 c74:	3b078793          	add	a5,a5,944 # 1020 <base>
 c78:	00000717          	auipc	a4,0x0
 c7c:	38f73c23          	sd	a5,920(a4) # 1010 <freep>
 c80:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c82:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c86:	b7e1                	j	c4e <malloc+0x36>
      if(p->s.size == nunits)
 c88:	02e48c63          	beq	s1,a4,cc0 <malloc+0xa8>
        p->s.size -= nunits;
 c8c:	4137073b          	subw	a4,a4,s3
 c90:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c92:	02071693          	sll	a3,a4,0x20
 c96:	01c6d713          	srl	a4,a3,0x1c
 c9a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c9c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ca0:	00000717          	auipc	a4,0x0
 ca4:	36a73823          	sd	a0,880(a4) # 1010 <freep>
      return (void*)(p + 1);
 ca8:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 cac:	70e2                	ld	ra,56(sp)
 cae:	7442                	ld	s0,48(sp)
 cb0:	74a2                	ld	s1,40(sp)
 cb2:	7902                	ld	s2,32(sp)
 cb4:	69e2                	ld	s3,24(sp)
 cb6:	6a42                	ld	s4,16(sp)
 cb8:	6aa2                	ld	s5,8(sp)
 cba:	6b02                	ld	s6,0(sp)
 cbc:	6121                	add	sp,sp,64
 cbe:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 cc0:	6398                	ld	a4,0(a5)
 cc2:	e118                	sd	a4,0(a0)
 cc4:	bff1                	j	ca0 <malloc+0x88>
  hp->s.size = nu;
 cc6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cca:	0541                	add	a0,a0,16
 ccc:	ecbff0ef          	jal	b96 <free>
  return freep;
 cd0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cd4:	dd61                	beqz	a0,cac <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cd6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cd8:	4798                	lw	a4,8(a5)
 cda:	fa9777e3          	bgeu	a4,s1,c88 <malloc+0x70>
    if(p == freep)
 cde:	00093703          	ld	a4,0(s2)
 ce2:	853e                	mv	a0,a5
 ce4:	fef719e3          	bne	a4,a5,cd6 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 ce8:	8552                	mv	a0,s4
 cea:	aa9ff0ef          	jal	792 <sbrk>
  if(p == (char*)-1)
 cee:	fd551ce3          	bne	a0,s5,cc6 <malloc+0xae>
        return 0;
 cf2:	4501                	li	a0,0
 cf4:	bf65                	j	cac <malloc+0x94>
