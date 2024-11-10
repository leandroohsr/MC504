
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
  74:	7135                	add	sp,sp,-160
  76:	ed06                	sd	ra,152(sp)
  78:	e922                	sd	s0,144(sp)
  7a:	e526                	sd	s1,136(sp)
  7c:	e14a                	sd	s2,128(sp)
  7e:	fcce                	sd	s3,120(sp)
  80:	f8d2                	sd	s4,112(sp)
  82:	f4d6                	sd	s5,104(sp)
  84:	f0da                	sd	s6,96(sp)
  86:	ecde                	sd	s7,88(sp)
  88:	e8e2                	sd	s8,80(sp)
  8a:	e4e6                	sd	s9,72(sp)
  8c:	e0ea                	sd	s10,64(sp)
  8e:	fc6e                	sd	s11,56(sp)
  90:	1100                	add	s0,sp,160
    //30 rodadas
    int  t0_rodada, tempo_atual;
    char *args[2];
    int *processos = malloc(20 * sizeof(int));
  92:	05000513          	li	a0,80
  96:	3e7000ef          	jal	c7c <malloc>
  9a:	f6a43423          	sd	a0,-152(s0)

    for (int i = 1; i <= 30; i++){
  9e:	4d85                	li	s11,1
                } else {       //pai
                    processos[j-1] = pid;
                }
            } else {
                //IO-BOUND
                args[0] = "rows";
  a0:	00001c17          	auipc	s8,0x1
  a4:	ce8c0c13          	add	s8,s8,-792 # d88 <malloc+0x10c>
                args[0] = "graphs";
  a8:	00001b97          	auipc	s7,0x1
  ac:	cb8b8b93          	add	s7,s7,-840 # d60 <malloc+0xe4>
        }

        //pegando max e min
        int lim = segundo_atual;
        int vazao_max = -10;
        int vazao_min = 10000;
  b0:	6789                	lui	a5,0x2
  b2:	71078793          	add	a5,a5,1808 # 2710 <base+0x16f0>
  b6:	f6f43023          	sd	a5,-160(s0)
  ba:	a109                	j	4bc <main+0x448>
                index_str[1] = index + '0';
  bc:	02f4879b          	addw	a5,s1,47
  c0:	0ff7f793          	zext.b	a5,a5
                index_str[2] = '\0';
  c4:	03000693          	li	a3,48
  c8:	a889                	j	11a <main+0xa6>
                    ret = exec("graphs", args);
  ca:	f8040593          	add	a1,s0,-128
  ce:	855e                	mv	a0,s7
  d0:	6de000ef          	jal	7ae <exec>
                    if (ret == -1){
  d4:	03951263          	bne	a0,s9,f8 <main+0x84>
                        printf("erro ao executar graphs.c\n");
  d8:	00001517          	auipc	a0,0x1
  dc:	c9050513          	add	a0,a0,-880 # d68 <malloc+0xec>
  e0:	2e9000ef          	jal	bc8 <printf>
                        exit(1);
  e4:	4505                	li	a0,1
  e6:	690000ef          	jal	776 <exit>
                args[0] = "rows";
  ea:	f9843023          	sd	s8,-128(s0)
                pid = fork();
  ee:	680000ef          	jal	76e <fork>
                if (pid == 0){ //filho
  f2:	c531                	beqz	a0,13e <main+0xca>
                    processos[j-1] = pid;
  f4:	00a92023          	sw	a0,0(s2)
        for (int j = 1; j < 21; j++){
  f8:	2485                	addw	s1,s1,1
  fa:	0911                	add	s2,s2,4
  fc:	47d5                	li	a5,21
  fe:	06f48063          	beq	s1,a5,15e <main+0xea>
            if (index < 10) {
 102:	0004871b          	sext.w	a4,s1
 106:	fff4879b          	addw	a5,s1,-1
 10a:	fafa59e3          	bge	s4,a5,bc <main+0x48>
                index_str[1] = (index - 10) + '0';
 10e:	0254879b          	addw	a5,s1,37
 112:	0ff7f793          	zext.b	a5,a5
 116:	03100693          	li	a3,49
                index_str[0] = '0';
 11a:	f6d40c23          	sb	a3,-136(s0)
                index_str[1] = index + '0';
 11e:	f6f40ca3          	sb	a5,-135(s0)
                index_str[2] = '\0';
 122:	f6040d23          	sb	zero,-134(s0)
            args[1] = index_str;
 126:	f9343423          	sd	s3,-120(s0)
            if (j <= X){
 12a:	fceae0e3          	bltu	s5,a4,ea <main+0x76>
                args[0] = "graphs";
 12e:	f9743023          	sd	s7,-128(s0)
                pid = fork();
 132:	63c000ef          	jal	76e <fork>
                if (pid == 0){ //filho
 136:	d951                	beqz	a0,ca <main+0x56>
                    processos[j-1] = pid;
 138:	00a92023          	sw	a0,0(s2)
 13c:	bf75                	j	f8 <main+0x84>
                    ret = exec("rows", args);
 13e:	f8040593          	add	a1,s0,-128
 142:	8562                	mv	a0,s8
 144:	66a000ef          	jal	7ae <exec>
                    if (ret == -1){
 148:	fb9518e3          	bne	a0,s9,f8 <main+0x84>
                        printf("erro ao executar rows.c\n");
 14c:	00001517          	auipc	a0,0x1
 150:	c4450513          	add	a0,a0,-956 # d90 <malloc+0x114>
 154:	275000ef          	jal	bc8 <printf>
                        exit(1);
 158:	4505                	li	a0,1
 15a:	61c000ef          	jal	776 <exit>
        int *terminos = malloc(20 * sizeof(int));
 15e:	05000513          	li	a0,80
 162:	31b000ef          	jal	c7c <malloc>
 166:	8a2a                	mv	s4,a0
        for (int j = 0; j < 20; j++){
 168:	05050993          	add	s3,a0,80
        int *terminos = malloc(20 * sizeof(int));
 16c:	84aa                	mv	s1,a0
            if (proc == -1){
 16e:	597d                	li	s2,-1
                printf("pocesso falhou");
 170:	00001a97          	auipc	s5,0x1
 174:	c40a8a93          	add	s5,s5,-960 # db0 <malloc+0x134>
 178:	a809                	j	18a <main+0x116>
                tempo_atual = uptime();
 17a:	694000ef          	jal	80e <uptime>
                terminos[j] = (tempo_atual - t0_rodada);
 17e:	4165053b          	subw	a0,a0,s6
 182:	c088                	sw	a0,0(s1)
        for (int j = 0; j < 20; j++){
 184:	0491                	add	s1,s1,4
 186:	01348b63          	beq	s1,s3,19c <main+0x128>
            proc = wait(0);
 18a:	4501                	li	a0,0
 18c:	5f2000ef          	jal	77e <wait>
            if (proc == -1){
 190:	ff2515e3          	bne	a0,s2,17a <main+0x106>
                printf("pocesso falhou");
 194:	8556                	mv	a0,s5
 196:	233000ef          	jal	bc8 <printf>
 19a:	b7ed                	j	184 <main+0x110>
        printf("RODADA %d ======================\n", i);
 19c:	85ee                	mv	a1,s11
 19e:	00001517          	auipc	a0,0x1
 1a2:	c2250513          	add	a0,a0,-990 # dc0 <malloc+0x144>
 1a6:	223000ef          	jal	bc8 <printf>
        for (int j = 0; j < 20; j++){
 1aa:	004a0593          	add	a1,s4,4
        printf("RODADA %d ======================\n", i);
 1ae:	4801                	li	a6,0
        for (int j = 0; j < 20; j++){
 1b0:	4501                	li	a0,0
            for (int k = j+1; k < 20; k++){
 1b2:	48d1                	li	a7,20
 1b4:	4e4d                	li	t3,19
 1b6:	008a0313          	add	t1,s4,8
 1ba:	a831                	j	1d6 <main+0x162>
 1bc:	0791                	add	a5,a5,4
 1be:	00f68a63          	beq	a3,a5,1d2 <main+0x15e>
                if (terminos[k] < terminos[j]){
 1c2:	4398                	lw	a4,0(a5)
 1c4:	ffc5a603          	lw	a2,-4(a1)
 1c8:	fec75ae3          	bge	a4,a2,1bc <main+0x148>
                    terminos[j] = terminos[k];
 1cc:	fee5ae23          	sw	a4,-4(a1)
                    terminos[k] = temp;
 1d0:	b7f5                	j	1bc <main+0x148>
        for (int j = 0; j < 20; j++){
 1d2:	0805                	add	a6,a6,1
 1d4:	0591                	add	a1,a1,4
            for (int k = j+1; k < 20; k++){
 1d6:	0015079b          	addw	a5,a0,1
 1da:	0007851b          	sext.w	a0,a5
 1de:	01150b63          	beq	a0,a7,1f4 <main+0x180>
 1e2:	40fe06bb          	subw	a3,t3,a5
 1e6:	1682                	sll	a3,a3,0x20
 1e8:	9281                	srl	a3,a3,0x20
 1ea:	96c2                	add	a3,a3,a6
 1ec:	068a                	sll	a3,a3,0x2
 1ee:	969a                	add	a3,a3,t1
 1f0:	87ae                	mv	a5,a1
 1f2:	bfc1                	j	1c2 <main+0x14e>
        int *vazoes = malloc(120 * sizeof(int));
 1f4:	1e000513          	li	a0,480
 1f8:	285000ef          	jal	c7c <malloc>
 1fc:	84aa                	mv	s1,a0
        for (int j = 0; j < 120; j++){
 1fe:	86aa                	mv	a3,a0
 200:	1e050713          	add	a4,a0,480
        int *vazoes = malloc(120 * sizeof(int));
 204:	87aa                	mv	a5,a0
            vazoes[j] = 0;
 206:	0007a023          	sw	zero,0(a5)
        for (int j = 0; j < 120; j++){
 20a:	0791                	add	a5,a5,4
 20c:	fef71de3          	bne	a4,a5,206 <main+0x192>
        int segundo_atual = 0;
 210:	4601                	li	a2,0
        int index = 0;
 212:	4581                	li	a1,0
        while (index < 20){
 214:	454d                	li	a0,19
 216:	a021                	j	21e <main+0x1aa>
                segundo_atual += 1;
 218:	2605                	addw	a2,a2,1
        while (index < 20){
 21a:	02b54563          	blt	a0,a1,244 <main+0x1d0>
            if (10 * segundo_atual >= terminos[index]){
 21e:	0026179b          	sllw	a5,a2,0x2
 222:	9fb1                	addw	a5,a5,a2
 224:	00259713          	sll	a4,a1,0x2
 228:	9752                	add	a4,a4,s4
 22a:	0017979b          	sllw	a5,a5,0x1
 22e:	4318                	lw	a4,0(a4)
 230:	fee7c4e3          	blt	a5,a4,218 <main+0x1a4>
                index += 1;
 234:	2585                	addw	a1,a1,1
                vazoes[segundo_atual] += 1;
 236:	00261793          	sll	a5,a2,0x2
 23a:	97a6                	add	a5,a5,s1
 23c:	4398                	lw	a4,0(a5)
 23e:	2705                	addw	a4,a4,1 # ffffffff80000001 <base+0xffffffff7fffefe1>
 240:	c398                	sw	a4,0(a5)
 242:	bfe1                	j	21a <main+0x1a6>
        for (int j = 0; j <= lim; j++){
 244:	02064e63          	bltz	a2,280 <main+0x20c>
 248:	00448813          	add	a6,s1,4
 24c:	02061713          	sll	a4,a2,0x20
 250:	01e75793          	srl	a5,a4,0x1e
 254:	983e                	add	a6,a6,a5
        int vazao_min = 10000;
 256:	f6043583          	ld	a1,-160(s0)
        int vazao_max = -10;
 25a:	5759                	li	a4,-10
 25c:	a031                	j	268 <main+0x1f4>
 25e:	0005071b          	sext.w	a4,a0
        for (int j = 0; j <= lim; j++){
 262:	0691                	add	a3,a3,4
 264:	03068163          	beq	a3,a6,286 <main+0x212>
            if (vazoes[j] < vazao_min) {
 268:	429c                	lw	a5,0(a3)
 26a:	853e                	mv	a0,a5
 26c:	00f5d363          	bge	a1,a5,272 <main+0x1fe>
 270:	852e                	mv	a0,a1
 272:	0005059b          	sext.w	a1,a0
                vazao_min = vazoes[j];
            }
            if (vazoes[j] > vazao_max) {
 276:	853e                	mv	a0,a5
 278:	fee7d3e3          	bge	a5,a4,25e <main+0x1ea>
 27c:	853a                	mv	a0,a4
 27e:	b7c5                	j	25e <main+0x1ea>
        int vazao_min = 10000;
 280:	f6043583          	ld	a1,-160(s0)
        int vazao_max = -10;
 284:	5759                	li	a4,-10
        }

        //normalizando
        int vazao_media = (20 * 1000) / lim;
        vazao_max *= 1000;
        vazao_min *= 1000;
 286:	3e800693          	li	a3,1000
 28a:	02b685bb          	mulw	a1,a3,a1
        int vazao_media = (20 * 1000) / lim;
 28e:	6b15                	lui	s6,0x5
 290:	e20b0b1b          	addw	s6,s6,-480 # 4e20 <base+0x3e00>
 294:	02cb4b3b          	divw	s6,s6,a2

        int nominador = vazao_media - vazao_min;
 298:	40bb0b3b          	subw	s6,s6,a1
        int denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero

        int res = 1000 - (nominador * 1000 / denominador);
 29c:	02db0b3b          	mulw	s6,s6,a3
        vazao_max *= 1000;
 2a0:	02e687bb          	mulw	a5,a3,a4
        int denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero
 2a4:	9f8d                	subw	a5,a5,a1
        int res = 1000 - (nominador * 1000 / denominador);
 2a6:	02fb4b3b          	divw	s6,s6,a5
 2aa:	41668b3b          	subw	s6,a3,s6
        int vazao_norm = res % 1000; //o valor é sempre de 0-1, não faz sentido pegar o valor maior e 1
 2ae:	02db6b3b          	remw	s6,s6,a3
        printf("vazao normalizada: %de-03\n", vazao_norm);
 2b2:	000b059b          	sext.w	a1,s6
 2b6:	00001517          	auipc	a0,0x1
 2ba:	b3250513          	add	a0,a0,-1230 # de8 <malloc+0x16c>
 2be:	10b000ef          	jal	bc8 <printf>

        free(terminos);
 2c2:	8552                	mv	a0,s4
 2c4:	137000ef          	jal	bfa <free>
        free(vazoes);
 2c8:	8526                	mv	a0,s1
 2ca:	131000ef          	jal	bfa <free>
        

        // EFICIENCIA DO SISTEMA DE ARQUIVOS
        int *eficiencias = malloc(Y * sizeof(int));
 2ce:	002d151b          	sllw	a0,s10,0x2
 2d2:	1ab000ef          	jal	c7c <malloc>
 2d6:	89aa                	mv	s3,a0
        
        //lendo os dados da struct processo

        int l = 0;
        int eficiencia_atual;
        for (int k = 0; k < 20; k++){
 2d8:	4481                	li	s1,0
        int l = 0;
 2da:	4901                	li	s2,0
        for (int k = 0; k < 20; k++){
 2dc:	4a51                	li	s4,20
 2de:	a021                	j	2e6 <main+0x272>
 2e0:	2485                	addw	s1,s1,1
 2e2:	01448d63          	beq	s1,s4,2fc <main+0x288>
            eficiencia_atual = get_eficiencia(k); //graphs.c devolve um valor negativo,
 2e6:	8526                	mv	a0,s1
 2e8:	536000ef          	jal	81e <get_eficiencia>
            if (eficiencia_atual >= 0 ){         //para que não impacte no cálculo
 2ec:	fe054ae3          	bltz	a0,2e0 <main+0x26c>
                eficiencias[l] = eficiencia_atual;
 2f0:	00291793          	sll	a5,s2,0x2
 2f4:	97ce                	add	a5,a5,s3
 2f6:	c388                	sw	a0,0(a5)
                l += 1;
 2f8:	2905                	addw	s2,s2,1
 2fa:	b7dd                	j	2e0 <main+0x26c>
 2fc:	874e                	mv	a4,s3
 2fe:	020d1793          	sll	a5,s10,0x20
 302:	01e7d893          	srl	a7,a5,0x1e
 306:	98ce                	add	a7,a7,s3
        }
        
        //pegando maximo e minimo
        int eficiencia_max = -10;
        int eficiencia_min = 100000;
        int eficiencia_soma = 0;
 308:	4801                	li	a6,0
        int eficiencia_min = 100000;
 30a:	6661                	lui	a2,0x18
 30c:	6a060613          	add	a2,a2,1696 # 186a0 <base+0x17680>
        int eficiencia_max = -10;
 310:	5559                	li	a0,-10
 312:	a031                	j	31e <main+0x2aa>
 314:	0005851b          	sext.w	a0,a1
        
        for(int j = 0; j < Y; j ++){
 318:	0711                	add	a4,a4,4
 31a:	03170263          	beq	a4,a7,33e <main+0x2ca>
            eficiencia_soma += eficiencias[j];
 31e:	431c                	lw	a5,0(a4)
 320:	010786bb          	addw	a3,a5,a6
 324:	0006881b          	sext.w	a6,a3
            if (eficiencias[j] < eficiencia_min){
 328:	85be                	mv	a1,a5
 32a:	00f65363          	bge	a2,a5,330 <main+0x2bc>
 32e:	85b2                	mv	a1,a2
 330:	0005861b          	sext.w	a2,a1
                eficiencia_min = eficiencias[j];
            }
            if (eficiencias[j] > eficiencia_max) {
 334:	85be                	mv	a1,a5
 336:	fca7dfe3          	bge	a5,a0,314 <main+0x2a0>
 33a:	85aa                	mv	a1,a0
 33c:	bfe1                	j	314 <main+0x2a0>
        }

        //normalizando
        int eficiencia_media = (1000 * eficiencia_soma) / Y;
        eficiencia_max *= 1000;
        eficiencia_min *= 1000;
 33e:	3e800713          	li	a4,1000
 342:	02c7063b          	mulw	a2,a4,a2
        int eficiencia_media = (1000 * eficiencia_soma) / Y;
 346:	02d70a3b          	mulw	s4,a4,a3
 34a:	03aa5a3b          	divuw	s4,s4,s10

        nominador = eficiencia_media - eficiencia_min;
 34e:	40ca0a3b          	subw	s4,s4,a2
        denominador = eficiencia_max - eficiencia_min;
        
        res = 1000 - (nominador * 1000 / denominador);
 352:	02ea0a3b          	mulw	s4,s4,a4
        eficiencia_max *= 1000;
 356:	02b707bb          	mulw	a5,a4,a1
        denominador = eficiencia_max - eficiencia_min;
 35a:	9f91                	subw	a5,a5,a2
        res = 1000 - (nominador * 1000 / denominador);
 35c:	02fa4a3b          	divw	s4,s4,a5
 360:	41470a3b          	subw	s4,a4,s4
        int eficiencia_norm = res % 1000;
 364:	02ea6a3b          	remw	s4,s4,a4
        printf("eficiencia normalizada: %de-03\n", eficiencia_norm);
 368:	000a059b          	sext.w	a1,s4
 36c:	00001517          	auipc	a0,0x1
 370:	a9c50513          	add	a0,a0,-1380 # e08 <malloc+0x18c>
 374:	055000ef          	jal	bc8 <printf>
        free(eficiencias);
 378:	854e                	mv	a0,s3
 37a:	081000ef          	jal	bfa <free>


        //OVERHEAD
        int *overheads = malloc(20 * sizeof(int));
 37e:	05000513          	li	a0,80
 382:	0fb000ef          	jal	c7c <malloc>
 386:	8aaa                	mv	s5,a0
        

        //lendo os dados da struct do processo
        int overhead_atual;
        for (int k = 0; k < 20; k++){
 388:	84aa                	mv	s1,a0
        int *overheads = malloc(20 * sizeof(int));
 38a:	89aa                	mv	s3,a0
        for (int k = 0; k < 20; k++){
 38c:	4901                	li	s2,0
 38e:	4cd1                	li	s9,20
            overhead_atual = get_overhead(k);
 390:	854a                	mv	a0,s2
 392:	494000ef          	jal	826 <get_overhead>
            overheads[k] = overhead_atual;
 396:	00a9a023          	sw	a0,0(s3)
        for (int k = 0; k < 20; k++){
 39a:	2905                	addw	s2,s2,1
 39c:	0991                	add	s3,s3,4
 39e:	ff9919e3          	bne	s2,s9,390 <main+0x31c>
 3a2:	050a8813          	add	a6,s5,80
        }

        //pegando maximo e minimo
        int overhead_max = -10;
        int overhead_min = 100000;
        int overhead_soma = 0;
 3a6:	4501                	li	a0,0
        int overhead_min = 100000;
 3a8:	6761                	lui	a4,0x18
 3aa:	6a070713          	add	a4,a4,1696 # 186a0 <base+0x17680>
        int overhead_max = -10;
 3ae:	5659                	li	a2,-10
 3b0:	a031                	j	3bc <main+0x348>
 3b2:	0006861b          	sext.w	a2,a3
        
        for(int j = 0; j < 20; j ++){
 3b6:	0491                	add	s1,s1,4
 3b8:	02980263          	beq	a6,s1,3dc <main+0x368>
            overhead_soma += overheads[j];
 3bc:	409c                	lw	a5,0(s1)
 3be:	00a785bb          	addw	a1,a5,a0
 3c2:	0005851b          	sext.w	a0,a1
            if (overheads[j] < overhead_min){
 3c6:	86be                	mv	a3,a5
 3c8:	00f75363          	bge	a4,a5,3ce <main+0x35a>
 3cc:	86ba                	mv	a3,a4
 3ce:	0006871b          	sext.w	a4,a3
                overhead_min = overheads[j];
            }
            if (overheads[j] > overhead_max) {
 3d2:	86be                	mv	a3,a5
 3d4:	fcc7dfe3          	bge	a5,a2,3b2 <main+0x33e>
 3d8:	86b2                	mv	a3,a2
 3da:	bfe1                	j	3b2 <main+0x33e>
        }

        //normalizando
        int overhead_media = (1000 * overhead_soma) / 20;
        overhead_max *= 1000;
        overhead_min *= 1000;
 3dc:	3e800613          	li	a2,1000
 3e0:	02e6073b          	mulw	a4,a2,a4
        int overhead_media = (1000 * overhead_soma) / 20;
 3e4:	03200c93          	li	s9,50
 3e8:	02bc8cbb          	mulw	s9,s9,a1

        nominador = overhead_media - overhead_min;
 3ec:	40ec8cbb          	subw	s9,s9,a4
        denominador = overhead_max - overhead_min;
        res = 1000 - (nominador * 1000 / denominador);
 3f0:	02cc8cbb          	mulw	s9,s9,a2
        overhead_max *= 1000;
 3f4:	02d607bb          	mulw	a5,a2,a3
        denominador = overhead_max - overhead_min;
 3f8:	9f99                	subw	a5,a5,a4
        res = 1000 - (nominador * 1000 / denominador);
 3fa:	02fcccbb          	divw	s9,s9,a5
 3fe:	41960cbb          	subw	s9,a2,s9
        int overhead_norm = res % 1000;
 402:	02ccecbb          	remw	s9,s9,a2
        printf("overhead normalizado: %de-03\n", overhead_norm);
 406:	000c859b          	sext.w	a1,s9
 40a:	00001517          	auipc	a0,0x1
 40e:	a1e50513          	add	a0,a0,-1506 # e28 <malloc+0x1ac>
 412:	7b6000ef          	jal	bc8 <printf>
        free(overheads);
 416:	8556                	mv	a0,s5
 418:	7e2000ef          	jal	bfa <free>

        //JUSTIÇA
        int *justicas = malloc(20 * sizeof(int));
 41c:	05000513          	li	a0,80
 420:	05d000ef          	jal	c7c <malloc>
 424:	8d2a                	mv	s10,a0
        //lendo do proc.c
        for (int k = 0; k < 20; k++){
 426:	84aa                	mv	s1,a0
        int *justicas = malloc(20 * sizeof(int));
 428:	89aa                	mv	s3,a0
        for (int k = 0; k < 20; k++){
 42a:	4901                	li	s2,0
 42c:	4ad1                	li	s5,20
            justicas[k] = get_justica(k);
 42e:	854a                	mv	a0,s2
 430:	40e000ef          	jal	83e <get_justica>
 434:	00a9a023          	sw	a0,0(s3)
        for (int k = 0; k < 20; k++){
 438:	2905                	addw	s2,s2,1
 43a:	0991                	add	s3,s3,4
 43c:	ff5919e3          	bne	s2,s5,42e <main+0x3ba>
 440:	050d0593          	add	a1,s10,80

        //pegando máximo e mínimo
        int justica_max = -10;
        int justica_min = 100000;
        int justica_soma = 0;
        int justica_soma_quadrado = 0;
 444:	4601                	li	a2,0
        int justica_soma = 0;
 446:	4681                	li	a3,0
        for (int k = 0; k < 20; k++){
            justica_soma += justicas[k];
 448:	409c                	lw	a5,0(s1)
 44a:	00d7873b          	addw	a4,a5,a3
 44e:	0007069b          	sext.w	a3,a4
            justica_soma_quadrado += justicas[k] * justicas[k];
 452:	02f787bb          	mulw	a5,a5,a5
 456:	9fb1                	addw	a5,a5,a2
 458:	0007861b          	sext.w	a2,a5
        for (int k = 0; k < 20; k++){
 45c:	0491                	add	s1,s1,4
 45e:	fe9595e3          	bne	a1,s1,448 <main+0x3d4>
                justica_max = justicas[k];
            }
        }

        //normalizando
        nominador = justica_soma * justica_soma;
 462:	02e7073b          	mulw	a4,a4,a4
        denominador = 20 * justica_soma_quadrado;
        res = 1000 - (nominador * 1000 / denominador);
 466:	3e800693          	li	a3,1000
 46a:	02d704bb          	mulw	s1,a4,a3
        denominador = 20 * justica_soma_quadrado;
 46e:	0027971b          	sllw	a4,a5,0x2
 472:	9fb9                	addw	a5,a5,a4
 474:	0027979b          	sllw	a5,a5,0x2
        res = 1000 - (nominador * 1000 / denominador);
 478:	02f4c4bb          	divw	s1,s1,a5
 47c:	409684bb          	subw	s1,a3,s1
        int justica_norm = res % 1000;
 480:	02d4e4bb          	remw	s1,s1,a3
        printf("justica normalizada: %de-03\n", justica_norm);
 484:	0004859b          	sext.w	a1,s1
 488:	00001517          	auipc	a0,0x1
 48c:	9c050513          	add	a0,a0,-1600 # e48 <malloc+0x1cc>
 490:	738000ef          	jal	bc8 <printf>
        free(justicas);
 494:	856a                	mv	a0,s10
 496:	764000ef          	jal	bfa <free>

        //DESEMPENHO
        int desempenho = (overhead_norm + eficiencia_norm + vazao_norm + justica_norm);
 49a:	019a05bb          	addw	a1,s4,s9
 49e:	016585bb          	addw	a1,a1,s6
 4a2:	9da5                	addw	a1,a1,s1
        desempenho = desempenho >> 2;
        printf("desempenho: %de-03\n", desempenho);
 4a4:	4025d59b          	sraw	a1,a1,0x2
 4a8:	00001517          	auipc	a0,0x1
 4ac:	9c050513          	add	a0,a0,-1600 # e68 <malloc+0x1ec>
 4b0:	718000ef          	jal	bc8 <printf>
    for (int i = 1; i <= 30; i++){
 4b4:	2d85                	addw	s11,s11,1
 4b6:	47fd                	li	a5,31
 4b8:	02fd8a63          	beq	s11,a5,4ec <main+0x478>
        initialize_metrics();
 4bc:	37a000ef          	jal	836 <initialize_metrics>
        t0_rodada = uptime();
 4c0:	34e000ef          	jal	80e <uptime>
 4c4:	8b2a                	mv	s6,a0
        uint X = (rand() % 9) + 6;
 4c6:	b93ff0ef          	jal	58 <rand>
 4ca:	47a5                	li	a5,9
 4cc:	02f567bb          	remw	a5,a0,a5
 4d0:	2799                	addw	a5,a5,6
 4d2:	00078a9b          	sext.w	s5,a5
        uint Y = 20 - X;
 4d6:	4d51                	li	s10,20
 4d8:	40fd0d3b          	subw	s10,s10,a5
        for (int j = 1; j < 21; j++){
 4dc:	f6843903          	ld	s2,-152(s0)
 4e0:	4485                	li	s1,1
            if (index < 10) {
 4e2:	4a25                	li	s4,9
            args[1] = index_str;
 4e4:	f7840993          	add	s3,s0,-136
                    if (ret == -1){
 4e8:	5cfd                	li	s9,-1
 4ea:	b921                	j	102 <main+0x8e>
    }
    return 0;
 4ec:	4501                	li	a0,0
 4ee:	60ea                	ld	ra,152(sp)
 4f0:	644a                	ld	s0,144(sp)
 4f2:	64aa                	ld	s1,136(sp)
 4f4:	690a                	ld	s2,128(sp)
 4f6:	79e6                	ld	s3,120(sp)
 4f8:	7a46                	ld	s4,112(sp)
 4fa:	7aa6                	ld	s5,104(sp)
 4fc:	7b06                	ld	s6,96(sp)
 4fe:	6be6                	ld	s7,88(sp)
 500:	6c46                	ld	s8,80(sp)
 502:	6ca6                	ld	s9,72(sp)
 504:	6d06                	ld	s10,64(sp)
 506:	7de2                	ld	s11,56(sp)
 508:	610d                	add	sp,sp,160
 50a:	8082                	ret

000000000000050c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 50c:	1141                	add	sp,sp,-16
 50e:	e406                	sd	ra,8(sp)
 510:	e022                	sd	s0,0(sp)
 512:	0800                	add	s0,sp,16
  extern int main();
  main();
 514:	b61ff0ef          	jal	74 <main>
  exit(0);
 518:	4501                	li	a0,0
 51a:	25c000ef          	jal	776 <exit>

000000000000051e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 51e:	1141                	add	sp,sp,-16
 520:	e422                	sd	s0,8(sp)
 522:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 524:	87aa                	mv	a5,a0
 526:	0585                	add	a1,a1,1
 528:	0785                	add	a5,a5,1
 52a:	fff5c703          	lbu	a4,-1(a1)
 52e:	fee78fa3          	sb	a4,-1(a5)
 532:	fb75                	bnez	a4,526 <strcpy+0x8>
    ;
  return os;
}
 534:	6422                	ld	s0,8(sp)
 536:	0141                	add	sp,sp,16
 538:	8082                	ret

000000000000053a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 53a:	1141                	add	sp,sp,-16
 53c:	e422                	sd	s0,8(sp)
 53e:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 540:	00054783          	lbu	a5,0(a0)
 544:	cb91                	beqz	a5,558 <strcmp+0x1e>
 546:	0005c703          	lbu	a4,0(a1)
 54a:	00f71763          	bne	a4,a5,558 <strcmp+0x1e>
    p++, q++;
 54e:	0505                	add	a0,a0,1
 550:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 552:	00054783          	lbu	a5,0(a0)
 556:	fbe5                	bnez	a5,546 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 558:	0005c503          	lbu	a0,0(a1)
}
 55c:	40a7853b          	subw	a0,a5,a0
 560:	6422                	ld	s0,8(sp)
 562:	0141                	add	sp,sp,16
 564:	8082                	ret

0000000000000566 <strlen>:

uint
strlen(const char *s)
{
 566:	1141                	add	sp,sp,-16
 568:	e422                	sd	s0,8(sp)
 56a:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 56c:	00054783          	lbu	a5,0(a0)
 570:	cf91                	beqz	a5,58c <strlen+0x26>
 572:	0505                	add	a0,a0,1
 574:	87aa                	mv	a5,a0
 576:	86be                	mv	a3,a5
 578:	0785                	add	a5,a5,1
 57a:	fff7c703          	lbu	a4,-1(a5)
 57e:	ff65                	bnez	a4,576 <strlen+0x10>
 580:	40a6853b          	subw	a0,a3,a0
 584:	2505                	addw	a0,a0,1
    ;
  return n;
}
 586:	6422                	ld	s0,8(sp)
 588:	0141                	add	sp,sp,16
 58a:	8082                	ret
  for(n = 0; s[n]; n++)
 58c:	4501                	li	a0,0
 58e:	bfe5                	j	586 <strlen+0x20>

0000000000000590 <memset>:

void*
memset(void *dst, int c, uint n)
{
 590:	1141                	add	sp,sp,-16
 592:	e422                	sd	s0,8(sp)
 594:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 596:	ca19                	beqz	a2,5ac <memset+0x1c>
 598:	87aa                	mv	a5,a0
 59a:	1602                	sll	a2,a2,0x20
 59c:	9201                	srl	a2,a2,0x20
 59e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5a6:	0785                	add	a5,a5,1
 5a8:	fee79de3          	bne	a5,a4,5a2 <memset+0x12>
  }
  return dst;
}
 5ac:	6422                	ld	s0,8(sp)
 5ae:	0141                	add	sp,sp,16
 5b0:	8082                	ret

00000000000005b2 <strchr>:

char*
strchr(const char *s, char c)
{
 5b2:	1141                	add	sp,sp,-16
 5b4:	e422                	sd	s0,8(sp)
 5b6:	0800                	add	s0,sp,16
  for(; *s; s++)
 5b8:	00054783          	lbu	a5,0(a0)
 5bc:	cb99                	beqz	a5,5d2 <strchr+0x20>
    if(*s == c)
 5be:	00f58763          	beq	a1,a5,5cc <strchr+0x1a>
  for(; *s; s++)
 5c2:	0505                	add	a0,a0,1
 5c4:	00054783          	lbu	a5,0(a0)
 5c8:	fbfd                	bnez	a5,5be <strchr+0xc>
      return (char*)s;
  return 0;
 5ca:	4501                	li	a0,0
}
 5cc:	6422                	ld	s0,8(sp)
 5ce:	0141                	add	sp,sp,16
 5d0:	8082                	ret
  return 0;
 5d2:	4501                	li	a0,0
 5d4:	bfe5                	j	5cc <strchr+0x1a>

00000000000005d6 <gets>:

char*
gets(char *buf, int max)
{
 5d6:	711d                	add	sp,sp,-96
 5d8:	ec86                	sd	ra,88(sp)
 5da:	e8a2                	sd	s0,80(sp)
 5dc:	e4a6                	sd	s1,72(sp)
 5de:	e0ca                	sd	s2,64(sp)
 5e0:	fc4e                	sd	s3,56(sp)
 5e2:	f852                	sd	s4,48(sp)
 5e4:	f456                	sd	s5,40(sp)
 5e6:	f05a                	sd	s6,32(sp)
 5e8:	ec5e                	sd	s7,24(sp)
 5ea:	1080                	add	s0,sp,96
 5ec:	8baa                	mv	s7,a0
 5ee:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5f0:	892a                	mv	s2,a0
 5f2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5f4:	4aa9                	li	s5,10
 5f6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5f8:	89a6                	mv	s3,s1
 5fa:	2485                	addw	s1,s1,1
 5fc:	0344d663          	bge	s1,s4,628 <gets+0x52>
    cc = read(0, &c, 1);
 600:	4605                	li	a2,1
 602:	faf40593          	add	a1,s0,-81
 606:	4501                	li	a0,0
 608:	186000ef          	jal	78e <read>
    if(cc < 1)
 60c:	00a05e63          	blez	a0,628 <gets+0x52>
    buf[i++] = c;
 610:	faf44783          	lbu	a5,-81(s0)
 614:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 618:	01578763          	beq	a5,s5,626 <gets+0x50>
 61c:	0905                	add	s2,s2,1
 61e:	fd679de3          	bne	a5,s6,5f8 <gets+0x22>
  for(i=0; i+1 < max; ){
 622:	89a6                	mv	s3,s1
 624:	a011                	j	628 <gets+0x52>
 626:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 628:	99de                	add	s3,s3,s7
 62a:	00098023          	sb	zero,0(s3)
  return buf;
}
 62e:	855e                	mv	a0,s7
 630:	60e6                	ld	ra,88(sp)
 632:	6446                	ld	s0,80(sp)
 634:	64a6                	ld	s1,72(sp)
 636:	6906                	ld	s2,64(sp)
 638:	79e2                	ld	s3,56(sp)
 63a:	7a42                	ld	s4,48(sp)
 63c:	7aa2                	ld	s5,40(sp)
 63e:	7b02                	ld	s6,32(sp)
 640:	6be2                	ld	s7,24(sp)
 642:	6125                	add	sp,sp,96
 644:	8082                	ret

0000000000000646 <stat>:

int
stat(const char *n, struct stat *st)
{
 646:	1101                	add	sp,sp,-32
 648:	ec06                	sd	ra,24(sp)
 64a:	e822                	sd	s0,16(sp)
 64c:	e426                	sd	s1,8(sp)
 64e:	e04a                	sd	s2,0(sp)
 650:	1000                	add	s0,sp,32
 652:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 654:	4581                	li	a1,0
 656:	160000ef          	jal	7b6 <open>
  if(fd < 0)
 65a:	02054163          	bltz	a0,67c <stat+0x36>
 65e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 660:	85ca                	mv	a1,s2
 662:	16c000ef          	jal	7ce <fstat>
 666:	892a                	mv	s2,a0
  close(fd);
 668:	8526                	mv	a0,s1
 66a:	134000ef          	jal	79e <close>
  return r;
}
 66e:	854a                	mv	a0,s2
 670:	60e2                	ld	ra,24(sp)
 672:	6442                	ld	s0,16(sp)
 674:	64a2                	ld	s1,8(sp)
 676:	6902                	ld	s2,0(sp)
 678:	6105                	add	sp,sp,32
 67a:	8082                	ret
    return -1;
 67c:	597d                	li	s2,-1
 67e:	bfc5                	j	66e <stat+0x28>

0000000000000680 <atoi>:

int
atoi(const char *s)
{
 680:	1141                	add	sp,sp,-16
 682:	e422                	sd	s0,8(sp)
 684:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 686:	00054683          	lbu	a3,0(a0)
 68a:	fd06879b          	addw	a5,a3,-48
 68e:	0ff7f793          	zext.b	a5,a5
 692:	4625                	li	a2,9
 694:	02f66863          	bltu	a2,a5,6c4 <atoi+0x44>
 698:	872a                	mv	a4,a0
  n = 0;
 69a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 69c:	0705                	add	a4,a4,1
 69e:	0025179b          	sllw	a5,a0,0x2
 6a2:	9fa9                	addw	a5,a5,a0
 6a4:	0017979b          	sllw	a5,a5,0x1
 6a8:	9fb5                	addw	a5,a5,a3
 6aa:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6ae:	00074683          	lbu	a3,0(a4)
 6b2:	fd06879b          	addw	a5,a3,-48
 6b6:	0ff7f793          	zext.b	a5,a5
 6ba:	fef671e3          	bgeu	a2,a5,69c <atoi+0x1c>
  return n;
}
 6be:	6422                	ld	s0,8(sp)
 6c0:	0141                	add	sp,sp,16
 6c2:	8082                	ret
  n = 0;
 6c4:	4501                	li	a0,0
 6c6:	bfe5                	j	6be <atoi+0x3e>

00000000000006c8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6c8:	1141                	add	sp,sp,-16
 6ca:	e422                	sd	s0,8(sp)
 6cc:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6ce:	02b57463          	bgeu	a0,a1,6f6 <memmove+0x2e>
    while(n-- > 0)
 6d2:	00c05f63          	blez	a2,6f0 <memmove+0x28>
 6d6:	1602                	sll	a2,a2,0x20
 6d8:	9201                	srl	a2,a2,0x20
 6da:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6de:	872a                	mv	a4,a0
      *dst++ = *src++;
 6e0:	0585                	add	a1,a1,1
 6e2:	0705                	add	a4,a4,1
 6e4:	fff5c683          	lbu	a3,-1(a1)
 6e8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6ec:	fee79ae3          	bne	a5,a4,6e0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6f0:	6422                	ld	s0,8(sp)
 6f2:	0141                	add	sp,sp,16
 6f4:	8082                	ret
    dst += n;
 6f6:	00c50733          	add	a4,a0,a2
    src += n;
 6fa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6fc:	fec05ae3          	blez	a2,6f0 <memmove+0x28>
 700:	fff6079b          	addw	a5,a2,-1
 704:	1782                	sll	a5,a5,0x20
 706:	9381                	srl	a5,a5,0x20
 708:	fff7c793          	not	a5,a5
 70c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 70e:	15fd                	add	a1,a1,-1
 710:	177d                	add	a4,a4,-1
 712:	0005c683          	lbu	a3,0(a1)
 716:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 71a:	fee79ae3          	bne	a5,a4,70e <memmove+0x46>
 71e:	bfc9                	j	6f0 <memmove+0x28>

0000000000000720 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 720:	1141                	add	sp,sp,-16
 722:	e422                	sd	s0,8(sp)
 724:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 726:	ca05                	beqz	a2,756 <memcmp+0x36>
 728:	fff6069b          	addw	a3,a2,-1
 72c:	1682                	sll	a3,a3,0x20
 72e:	9281                	srl	a3,a3,0x20
 730:	0685                	add	a3,a3,1
 732:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 734:	00054783          	lbu	a5,0(a0)
 738:	0005c703          	lbu	a4,0(a1)
 73c:	00e79863          	bne	a5,a4,74c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 740:	0505                	add	a0,a0,1
    p2++;
 742:	0585                	add	a1,a1,1
  while (n-- > 0) {
 744:	fed518e3          	bne	a0,a3,734 <memcmp+0x14>
  }
  return 0;
 748:	4501                	li	a0,0
 74a:	a019                	j	750 <memcmp+0x30>
      return *p1 - *p2;
 74c:	40e7853b          	subw	a0,a5,a4
}
 750:	6422                	ld	s0,8(sp)
 752:	0141                	add	sp,sp,16
 754:	8082                	ret
  return 0;
 756:	4501                	li	a0,0
 758:	bfe5                	j	750 <memcmp+0x30>

000000000000075a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 75a:	1141                	add	sp,sp,-16
 75c:	e406                	sd	ra,8(sp)
 75e:	e022                	sd	s0,0(sp)
 760:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 762:	f67ff0ef          	jal	6c8 <memmove>
}
 766:	60a2                	ld	ra,8(sp)
 768:	6402                	ld	s0,0(sp)
 76a:	0141                	add	sp,sp,16
 76c:	8082                	ret

000000000000076e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 76e:	4885                	li	a7,1
 ecall
 770:	00000073          	ecall
 ret
 774:	8082                	ret

0000000000000776 <exit>:
.global exit
exit:
 li a7, SYS_exit
 776:	4889                	li	a7,2
 ecall
 778:	00000073          	ecall
 ret
 77c:	8082                	ret

000000000000077e <wait>:
.global wait
wait:
 li a7, SYS_wait
 77e:	488d                	li	a7,3
 ecall
 780:	00000073          	ecall
 ret
 784:	8082                	ret

0000000000000786 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 786:	4891                	li	a7,4
 ecall
 788:	00000073          	ecall
 ret
 78c:	8082                	ret

000000000000078e <read>:
.global read
read:
 li a7, SYS_read
 78e:	4895                	li	a7,5
 ecall
 790:	00000073          	ecall
 ret
 794:	8082                	ret

0000000000000796 <write>:
.global write
write:
 li a7, SYS_write
 796:	48c1                	li	a7,16
 ecall
 798:	00000073          	ecall
 ret
 79c:	8082                	ret

000000000000079e <close>:
.global close
close:
 li a7, SYS_close
 79e:	48d5                	li	a7,21
 ecall
 7a0:	00000073          	ecall
 ret
 7a4:	8082                	ret

00000000000007a6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 7a6:	4899                	li	a7,6
 ecall
 7a8:	00000073          	ecall
 ret
 7ac:	8082                	ret

00000000000007ae <exec>:
.global exec
exec:
 li a7, SYS_exec
 7ae:	489d                	li	a7,7
 ecall
 7b0:	00000073          	ecall
 ret
 7b4:	8082                	ret

00000000000007b6 <open>:
.global open
open:
 li a7, SYS_open
 7b6:	48bd                	li	a7,15
 ecall
 7b8:	00000073          	ecall
 ret
 7bc:	8082                	ret

00000000000007be <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7be:	48c5                	li	a7,17
 ecall
 7c0:	00000073          	ecall
 ret
 7c4:	8082                	ret

00000000000007c6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7c6:	48c9                	li	a7,18
 ecall
 7c8:	00000073          	ecall
 ret
 7cc:	8082                	ret

00000000000007ce <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7ce:	48a1                	li	a7,8
 ecall
 7d0:	00000073          	ecall
 ret
 7d4:	8082                	ret

00000000000007d6 <link>:
.global link
link:
 li a7, SYS_link
 7d6:	48cd                	li	a7,19
 ecall
 7d8:	00000073          	ecall
 ret
 7dc:	8082                	ret

00000000000007de <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7de:	48d1                	li	a7,20
 ecall
 7e0:	00000073          	ecall
 ret
 7e4:	8082                	ret

00000000000007e6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7e6:	48a5                	li	a7,9
 ecall
 7e8:	00000073          	ecall
 ret
 7ec:	8082                	ret

00000000000007ee <dup>:
.global dup
dup:
 li a7, SYS_dup
 7ee:	48a9                	li	a7,10
 ecall
 7f0:	00000073          	ecall
 ret
 7f4:	8082                	ret

00000000000007f6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7f6:	48ad                	li	a7,11
 ecall
 7f8:	00000073          	ecall
 ret
 7fc:	8082                	ret

00000000000007fe <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7fe:	48b1                	li	a7,12
 ecall
 800:	00000073          	ecall
 ret
 804:	8082                	ret

0000000000000806 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 806:	48b5                	li	a7,13
 ecall
 808:	00000073          	ecall
 ret
 80c:	8082                	ret

000000000000080e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 80e:	48b9                	li	a7,14
 ecall
 810:	00000073          	ecall
 ret
 814:	8082                	ret

0000000000000816 <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 816:	48d9                	li	a7,22
 ecall
 818:	00000073          	ecall
 ret
 81c:	8082                	ret

000000000000081e <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 81e:	48dd                	li	a7,23
 ecall
 820:	00000073          	ecall
 ret
 824:	8082                	ret

0000000000000826 <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 826:	48e1                	li	a7,24
 ecall
 828:	00000073          	ecall
 ret
 82c:	8082                	ret

000000000000082e <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 82e:	48e5                	li	a7,25
 ecall
 830:	00000073          	ecall
 ret
 834:	8082                	ret

0000000000000836 <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 836:	48e9                	li	a7,26
 ecall
 838:	00000073          	ecall
 ret
 83c:	8082                	ret

000000000000083e <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 83e:	48ed                	li	a7,27
 ecall
 840:	00000073          	ecall
 ret
 844:	8082                	ret

0000000000000846 <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 846:	48f1                	li	a7,28
 ecall
 848:	00000073          	ecall
 ret
 84c:	8082                	ret

000000000000084e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 84e:	1101                	add	sp,sp,-32
 850:	ec06                	sd	ra,24(sp)
 852:	e822                	sd	s0,16(sp)
 854:	1000                	add	s0,sp,32
 856:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 85a:	4605                	li	a2,1
 85c:	fef40593          	add	a1,s0,-17
 860:	f37ff0ef          	jal	796 <write>
}
 864:	60e2                	ld	ra,24(sp)
 866:	6442                	ld	s0,16(sp)
 868:	6105                	add	sp,sp,32
 86a:	8082                	ret

000000000000086c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 86c:	7139                	add	sp,sp,-64
 86e:	fc06                	sd	ra,56(sp)
 870:	f822                	sd	s0,48(sp)
 872:	f426                	sd	s1,40(sp)
 874:	f04a                	sd	s2,32(sp)
 876:	ec4e                	sd	s3,24(sp)
 878:	0080                	add	s0,sp,64
 87a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 87c:	c299                	beqz	a3,882 <printint+0x16>
 87e:	0805c763          	bltz	a1,90c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 882:	2581                	sext.w	a1,a1
  neg = 0;
 884:	4881                	li	a7,0
 886:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 88a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 88c:	2601                	sext.w	a2,a2
 88e:	00000517          	auipc	a0,0x0
 892:	5fa50513          	add	a0,a0,1530 # e88 <digits>
 896:	883a                	mv	a6,a4
 898:	2705                	addw	a4,a4,1
 89a:	02c5f7bb          	remuw	a5,a1,a2
 89e:	1782                	sll	a5,a5,0x20
 8a0:	9381                	srl	a5,a5,0x20
 8a2:	97aa                	add	a5,a5,a0
 8a4:	0007c783          	lbu	a5,0(a5)
 8a8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8ac:	0005879b          	sext.w	a5,a1
 8b0:	02c5d5bb          	divuw	a1,a1,a2
 8b4:	0685                	add	a3,a3,1
 8b6:	fec7f0e3          	bgeu	a5,a2,896 <printint+0x2a>
  if(neg)
 8ba:	00088c63          	beqz	a7,8d2 <printint+0x66>
    buf[i++] = '-';
 8be:	fd070793          	add	a5,a4,-48
 8c2:	00878733          	add	a4,a5,s0
 8c6:	02d00793          	li	a5,45
 8ca:	fef70823          	sb	a5,-16(a4)
 8ce:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 8d2:	02e05663          	blez	a4,8fe <printint+0x92>
 8d6:	fc040793          	add	a5,s0,-64
 8da:	00e78933          	add	s2,a5,a4
 8de:	fff78993          	add	s3,a5,-1
 8e2:	99ba                	add	s3,s3,a4
 8e4:	377d                	addw	a4,a4,-1
 8e6:	1702                	sll	a4,a4,0x20
 8e8:	9301                	srl	a4,a4,0x20
 8ea:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 8ee:	fff94583          	lbu	a1,-1(s2)
 8f2:	8526                	mv	a0,s1
 8f4:	f5bff0ef          	jal	84e <putc>
  while(--i >= 0)
 8f8:	197d                	add	s2,s2,-1
 8fa:	ff391ae3          	bne	s2,s3,8ee <printint+0x82>
}
 8fe:	70e2                	ld	ra,56(sp)
 900:	7442                	ld	s0,48(sp)
 902:	74a2                	ld	s1,40(sp)
 904:	7902                	ld	s2,32(sp)
 906:	69e2                	ld	s3,24(sp)
 908:	6121                	add	sp,sp,64
 90a:	8082                	ret
    x = -xx;
 90c:	40b005bb          	negw	a1,a1
    neg = 1;
 910:	4885                	li	a7,1
    x = -xx;
 912:	bf95                	j	886 <printint+0x1a>

0000000000000914 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 914:	711d                	add	sp,sp,-96
 916:	ec86                	sd	ra,88(sp)
 918:	e8a2                	sd	s0,80(sp)
 91a:	e4a6                	sd	s1,72(sp)
 91c:	e0ca                	sd	s2,64(sp)
 91e:	fc4e                	sd	s3,56(sp)
 920:	f852                	sd	s4,48(sp)
 922:	f456                	sd	s5,40(sp)
 924:	f05a                	sd	s6,32(sp)
 926:	ec5e                	sd	s7,24(sp)
 928:	e862                	sd	s8,16(sp)
 92a:	e466                	sd	s9,8(sp)
 92c:	e06a                	sd	s10,0(sp)
 92e:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 930:	0005c903          	lbu	s2,0(a1)
 934:	24090763          	beqz	s2,b82 <vprintf+0x26e>
 938:	8b2a                	mv	s6,a0
 93a:	8a2e                	mv	s4,a1
 93c:	8bb2                	mv	s7,a2
  state = 0;
 93e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 940:	4481                	li	s1,0
 942:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 944:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 948:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 94c:	06c00c93          	li	s9,108
 950:	a005                	j	970 <vprintf+0x5c>
        putc(fd, c0);
 952:	85ca                	mv	a1,s2
 954:	855a                	mv	a0,s6
 956:	ef9ff0ef          	jal	84e <putc>
 95a:	a019                	j	960 <vprintf+0x4c>
    } else if(state == '%'){
 95c:	03598263          	beq	s3,s5,980 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 960:	2485                	addw	s1,s1,1
 962:	8726                	mv	a4,s1
 964:	009a07b3          	add	a5,s4,s1
 968:	0007c903          	lbu	s2,0(a5)
 96c:	20090b63          	beqz	s2,b82 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 970:	0009079b          	sext.w	a5,s2
    if(state == 0){
 974:	fe0994e3          	bnez	s3,95c <vprintf+0x48>
      if(c0 == '%'){
 978:	fd579de3          	bne	a5,s5,952 <vprintf+0x3e>
        state = '%';
 97c:	89be                	mv	s3,a5
 97e:	b7cd                	j	960 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 980:	c7c9                	beqz	a5,a0a <vprintf+0xf6>
 982:	00ea06b3          	add	a3,s4,a4
 986:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 98a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 98c:	c681                	beqz	a3,994 <vprintf+0x80>
 98e:	9752                	add	a4,a4,s4
 990:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 994:	03878f63          	beq	a5,s8,9d2 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 998:	05978963          	beq	a5,s9,9ea <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 99c:	07500713          	li	a4,117
 9a0:	0ee78363          	beq	a5,a4,a86 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 9a4:	07800713          	li	a4,120
 9a8:	12e78563          	beq	a5,a4,ad2 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 9ac:	07000713          	li	a4,112
 9b0:	14e78a63          	beq	a5,a4,b04 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 9b4:	07300713          	li	a4,115
 9b8:	18e78863          	beq	a5,a4,b48 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 9bc:	02500713          	li	a4,37
 9c0:	04e79563          	bne	a5,a4,a0a <vprintf+0xf6>
        putc(fd, '%');
 9c4:	02500593          	li	a1,37
 9c8:	855a                	mv	a0,s6
 9ca:	e85ff0ef          	jal	84e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 9ce:	4981                	li	s3,0
 9d0:	bf41                	j	960 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 9d2:	008b8913          	add	s2,s7,8
 9d6:	4685                	li	a3,1
 9d8:	4629                	li	a2,10
 9da:	000ba583          	lw	a1,0(s7)
 9de:	855a                	mv	a0,s6
 9e0:	e8dff0ef          	jal	86c <printint>
 9e4:	8bca                	mv	s7,s2
      state = 0;
 9e6:	4981                	li	s3,0
 9e8:	bfa5                	j	960 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 9ea:	06400793          	li	a5,100
 9ee:	02f68963          	beq	a3,a5,a20 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9f2:	06c00793          	li	a5,108
 9f6:	04f68263          	beq	a3,a5,a3a <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 9fa:	07500793          	li	a5,117
 9fe:	0af68063          	beq	a3,a5,a9e <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 a02:	07800793          	li	a5,120
 a06:	0ef68263          	beq	a3,a5,aea <vprintf+0x1d6>
        putc(fd, '%');
 a0a:	02500593          	li	a1,37
 a0e:	855a                	mv	a0,s6
 a10:	e3fff0ef          	jal	84e <putc>
        putc(fd, c0);
 a14:	85ca                	mv	a1,s2
 a16:	855a                	mv	a0,s6
 a18:	e37ff0ef          	jal	84e <putc>
      state = 0;
 a1c:	4981                	li	s3,0
 a1e:	b789                	j	960 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a20:	008b8913          	add	s2,s7,8
 a24:	4685                	li	a3,1
 a26:	4629                	li	a2,10
 a28:	000ba583          	lw	a1,0(s7)
 a2c:	855a                	mv	a0,s6
 a2e:	e3fff0ef          	jal	86c <printint>
        i += 1;
 a32:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a34:	8bca                	mv	s7,s2
      state = 0;
 a36:	4981                	li	s3,0
        i += 1;
 a38:	b725                	j	960 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a3a:	06400793          	li	a5,100
 a3e:	02f60763          	beq	a2,a5,a6c <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a42:	07500793          	li	a5,117
 a46:	06f60963          	beq	a2,a5,ab8 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a4a:	07800793          	li	a5,120
 a4e:	faf61ee3          	bne	a2,a5,a0a <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a52:	008b8913          	add	s2,s7,8
 a56:	4681                	li	a3,0
 a58:	4641                	li	a2,16
 a5a:	000ba583          	lw	a1,0(s7)
 a5e:	855a                	mv	a0,s6
 a60:	e0dff0ef          	jal	86c <printint>
        i += 2;
 a64:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a66:	8bca                	mv	s7,s2
      state = 0;
 a68:	4981                	li	s3,0
        i += 2;
 a6a:	bddd                	j	960 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a6c:	008b8913          	add	s2,s7,8
 a70:	4685                	li	a3,1
 a72:	4629                	li	a2,10
 a74:	000ba583          	lw	a1,0(s7)
 a78:	855a                	mv	a0,s6
 a7a:	df3ff0ef          	jal	86c <printint>
        i += 2;
 a7e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a80:	8bca                	mv	s7,s2
      state = 0;
 a82:	4981                	li	s3,0
        i += 2;
 a84:	bdf1                	j	960 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 a86:	008b8913          	add	s2,s7,8
 a8a:	4681                	li	a3,0
 a8c:	4629                	li	a2,10
 a8e:	000ba583          	lw	a1,0(s7)
 a92:	855a                	mv	a0,s6
 a94:	dd9ff0ef          	jal	86c <printint>
 a98:	8bca                	mv	s7,s2
      state = 0;
 a9a:	4981                	li	s3,0
 a9c:	b5d1                	j	960 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a9e:	008b8913          	add	s2,s7,8
 aa2:	4681                	li	a3,0
 aa4:	4629                	li	a2,10
 aa6:	000ba583          	lw	a1,0(s7)
 aaa:	855a                	mv	a0,s6
 aac:	dc1ff0ef          	jal	86c <printint>
        i += 1;
 ab0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 ab2:	8bca                	mv	s7,s2
      state = 0;
 ab4:	4981                	li	s3,0
        i += 1;
 ab6:	b56d                	j	960 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ab8:	008b8913          	add	s2,s7,8
 abc:	4681                	li	a3,0
 abe:	4629                	li	a2,10
 ac0:	000ba583          	lw	a1,0(s7)
 ac4:	855a                	mv	a0,s6
 ac6:	da7ff0ef          	jal	86c <printint>
        i += 2;
 aca:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 acc:	8bca                	mv	s7,s2
      state = 0;
 ace:	4981                	li	s3,0
        i += 2;
 ad0:	bd41                	j	960 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 ad2:	008b8913          	add	s2,s7,8
 ad6:	4681                	li	a3,0
 ad8:	4641                	li	a2,16
 ada:	000ba583          	lw	a1,0(s7)
 ade:	855a                	mv	a0,s6
 ae0:	d8dff0ef          	jal	86c <printint>
 ae4:	8bca                	mv	s7,s2
      state = 0;
 ae6:	4981                	li	s3,0
 ae8:	bda5                	j	960 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 aea:	008b8913          	add	s2,s7,8
 aee:	4681                	li	a3,0
 af0:	4641                	li	a2,16
 af2:	000ba583          	lw	a1,0(s7)
 af6:	855a                	mv	a0,s6
 af8:	d75ff0ef          	jal	86c <printint>
        i += 1;
 afc:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 afe:	8bca                	mv	s7,s2
      state = 0;
 b00:	4981                	li	s3,0
        i += 1;
 b02:	bdb9                	j	960 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 b04:	008b8d13          	add	s10,s7,8
 b08:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b0c:	03000593          	li	a1,48
 b10:	855a                	mv	a0,s6
 b12:	d3dff0ef          	jal	84e <putc>
  putc(fd, 'x');
 b16:	07800593          	li	a1,120
 b1a:	855a                	mv	a0,s6
 b1c:	d33ff0ef          	jal	84e <putc>
 b20:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b22:	00000b97          	auipc	s7,0x0
 b26:	366b8b93          	add	s7,s7,870 # e88 <digits>
 b2a:	03c9d793          	srl	a5,s3,0x3c
 b2e:	97de                	add	a5,a5,s7
 b30:	0007c583          	lbu	a1,0(a5)
 b34:	855a                	mv	a0,s6
 b36:	d19ff0ef          	jal	84e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b3a:	0992                	sll	s3,s3,0x4
 b3c:	397d                	addw	s2,s2,-1
 b3e:	fe0916e3          	bnez	s2,b2a <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 b42:	8bea                	mv	s7,s10
      state = 0;
 b44:	4981                	li	s3,0
 b46:	bd29                	j	960 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 b48:	008b8993          	add	s3,s7,8
 b4c:	000bb903          	ld	s2,0(s7)
 b50:	00090f63          	beqz	s2,b6e <vprintf+0x25a>
        for(; *s; s++)
 b54:	00094583          	lbu	a1,0(s2)
 b58:	c195                	beqz	a1,b7c <vprintf+0x268>
          putc(fd, *s);
 b5a:	855a                	mv	a0,s6
 b5c:	cf3ff0ef          	jal	84e <putc>
        for(; *s; s++)
 b60:	0905                	add	s2,s2,1
 b62:	00094583          	lbu	a1,0(s2)
 b66:	f9f5                	bnez	a1,b5a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b68:	8bce                	mv	s7,s3
      state = 0;
 b6a:	4981                	li	s3,0
 b6c:	bbd5                	j	960 <vprintf+0x4c>
          s = "(null)";
 b6e:	00000917          	auipc	s2,0x0
 b72:	31290913          	add	s2,s2,786 # e80 <malloc+0x204>
        for(; *s; s++)
 b76:	02800593          	li	a1,40
 b7a:	b7c5                	j	b5a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b7c:	8bce                	mv	s7,s3
      state = 0;
 b7e:	4981                	li	s3,0
 b80:	b3c5                	j	960 <vprintf+0x4c>
    }
  }
}
 b82:	60e6                	ld	ra,88(sp)
 b84:	6446                	ld	s0,80(sp)
 b86:	64a6                	ld	s1,72(sp)
 b88:	6906                	ld	s2,64(sp)
 b8a:	79e2                	ld	s3,56(sp)
 b8c:	7a42                	ld	s4,48(sp)
 b8e:	7aa2                	ld	s5,40(sp)
 b90:	7b02                	ld	s6,32(sp)
 b92:	6be2                	ld	s7,24(sp)
 b94:	6c42                	ld	s8,16(sp)
 b96:	6ca2                	ld	s9,8(sp)
 b98:	6d02                	ld	s10,0(sp)
 b9a:	6125                	add	sp,sp,96
 b9c:	8082                	ret

0000000000000b9e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b9e:	715d                	add	sp,sp,-80
 ba0:	ec06                	sd	ra,24(sp)
 ba2:	e822                	sd	s0,16(sp)
 ba4:	1000                	add	s0,sp,32
 ba6:	e010                	sd	a2,0(s0)
 ba8:	e414                	sd	a3,8(s0)
 baa:	e818                	sd	a4,16(s0)
 bac:	ec1c                	sd	a5,24(s0)
 bae:	03043023          	sd	a6,32(s0)
 bb2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 bb6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 bba:	8622                	mv	a2,s0
 bbc:	d59ff0ef          	jal	914 <vprintf>
}
 bc0:	60e2                	ld	ra,24(sp)
 bc2:	6442                	ld	s0,16(sp)
 bc4:	6161                	add	sp,sp,80
 bc6:	8082                	ret

0000000000000bc8 <printf>:

void
printf(const char *fmt, ...)
{
 bc8:	711d                	add	sp,sp,-96
 bca:	ec06                	sd	ra,24(sp)
 bcc:	e822                	sd	s0,16(sp)
 bce:	1000                	add	s0,sp,32
 bd0:	e40c                	sd	a1,8(s0)
 bd2:	e810                	sd	a2,16(s0)
 bd4:	ec14                	sd	a3,24(s0)
 bd6:	f018                	sd	a4,32(s0)
 bd8:	f41c                	sd	a5,40(s0)
 bda:	03043823          	sd	a6,48(s0)
 bde:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 be2:	00840613          	add	a2,s0,8
 be6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 bea:	85aa                	mv	a1,a0
 bec:	4505                	li	a0,1
 bee:	d27ff0ef          	jal	914 <vprintf>
}
 bf2:	60e2                	ld	ra,24(sp)
 bf4:	6442                	ld	s0,16(sp)
 bf6:	6125                	add	sp,sp,96
 bf8:	8082                	ret

0000000000000bfa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bfa:	1141                	add	sp,sp,-16
 bfc:	e422                	sd	s0,8(sp)
 bfe:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c00:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c04:	00000797          	auipc	a5,0x0
 c08:	40c7b783          	ld	a5,1036(a5) # 1010 <freep>
 c0c:	a02d                	j	c36 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c0e:	4618                	lw	a4,8(a2)
 c10:	9f2d                	addw	a4,a4,a1
 c12:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c16:	6398                	ld	a4,0(a5)
 c18:	6310                	ld	a2,0(a4)
 c1a:	a83d                	j	c58 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c1c:	ff852703          	lw	a4,-8(a0)
 c20:	9f31                	addw	a4,a4,a2
 c22:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c24:	ff053683          	ld	a3,-16(a0)
 c28:	a091                	j	c6c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c2a:	6398                	ld	a4,0(a5)
 c2c:	00e7e463          	bltu	a5,a4,c34 <free+0x3a>
 c30:	00e6ea63          	bltu	a3,a4,c44 <free+0x4a>
{
 c34:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c36:	fed7fae3          	bgeu	a5,a3,c2a <free+0x30>
 c3a:	6398                	ld	a4,0(a5)
 c3c:	00e6e463          	bltu	a3,a4,c44 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c40:	fee7eae3          	bltu	a5,a4,c34 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 c44:	ff852583          	lw	a1,-8(a0)
 c48:	6390                	ld	a2,0(a5)
 c4a:	02059813          	sll	a6,a1,0x20
 c4e:	01c85713          	srl	a4,a6,0x1c
 c52:	9736                	add	a4,a4,a3
 c54:	fae60de3          	beq	a2,a4,c0e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 c58:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c5c:	4790                	lw	a2,8(a5)
 c5e:	02061593          	sll	a1,a2,0x20
 c62:	01c5d713          	srl	a4,a1,0x1c
 c66:	973e                	add	a4,a4,a5
 c68:	fae68ae3          	beq	a3,a4,c1c <free+0x22>
    p->s.ptr = bp->s.ptr;
 c6c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c6e:	00000717          	auipc	a4,0x0
 c72:	3af73123          	sd	a5,930(a4) # 1010 <freep>
}
 c76:	6422                	ld	s0,8(sp)
 c78:	0141                	add	sp,sp,16
 c7a:	8082                	ret

0000000000000c7c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c7c:	7139                	add	sp,sp,-64
 c7e:	fc06                	sd	ra,56(sp)
 c80:	f822                	sd	s0,48(sp)
 c82:	f426                	sd	s1,40(sp)
 c84:	f04a                	sd	s2,32(sp)
 c86:	ec4e                	sd	s3,24(sp)
 c88:	e852                	sd	s4,16(sp)
 c8a:	e456                	sd	s5,8(sp)
 c8c:	e05a                	sd	s6,0(sp)
 c8e:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c90:	02051493          	sll	s1,a0,0x20
 c94:	9081                	srl	s1,s1,0x20
 c96:	04bd                	add	s1,s1,15
 c98:	8091                	srl	s1,s1,0x4
 c9a:	0014899b          	addw	s3,s1,1
 c9e:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 ca0:	00000517          	auipc	a0,0x0
 ca4:	37053503          	ld	a0,880(a0) # 1010 <freep>
 ca8:	c515                	beqz	a0,cd4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 caa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cac:	4798                	lw	a4,8(a5)
 cae:	02977f63          	bgeu	a4,s1,cec <malloc+0x70>
  if(nu < 4096)
 cb2:	8a4e                	mv	s4,s3
 cb4:	0009871b          	sext.w	a4,s3
 cb8:	6685                	lui	a3,0x1
 cba:	00d77363          	bgeu	a4,a3,cc0 <malloc+0x44>
 cbe:	6a05                	lui	s4,0x1
 cc0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 cc4:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 cc8:	00000917          	auipc	s2,0x0
 ccc:	34890913          	add	s2,s2,840 # 1010 <freep>
  if(p == (char*)-1)
 cd0:	5afd                	li	s5,-1
 cd2:	a885                	j	d42 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 cd4:	00000797          	auipc	a5,0x0
 cd8:	34c78793          	add	a5,a5,844 # 1020 <base>
 cdc:	00000717          	auipc	a4,0x0
 ce0:	32f73a23          	sd	a5,820(a4) # 1010 <freep>
 ce4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ce6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 cea:	b7e1                	j	cb2 <malloc+0x36>
      if(p->s.size == nunits)
 cec:	02e48c63          	beq	s1,a4,d24 <malloc+0xa8>
        p->s.size -= nunits;
 cf0:	4137073b          	subw	a4,a4,s3
 cf4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cf6:	02071693          	sll	a3,a4,0x20
 cfa:	01c6d713          	srl	a4,a3,0x1c
 cfe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d00:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d04:	00000717          	auipc	a4,0x0
 d08:	30a73623          	sd	a0,780(a4) # 1010 <freep>
      return (void*)(p + 1);
 d0c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 d10:	70e2                	ld	ra,56(sp)
 d12:	7442                	ld	s0,48(sp)
 d14:	74a2                	ld	s1,40(sp)
 d16:	7902                	ld	s2,32(sp)
 d18:	69e2                	ld	s3,24(sp)
 d1a:	6a42                	ld	s4,16(sp)
 d1c:	6aa2                	ld	s5,8(sp)
 d1e:	6b02                	ld	s6,0(sp)
 d20:	6121                	add	sp,sp,64
 d22:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 d24:	6398                	ld	a4,0(a5)
 d26:	e118                	sd	a4,0(a0)
 d28:	bff1                	j	d04 <malloc+0x88>
  hp->s.size = nu;
 d2a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d2e:	0541                	add	a0,a0,16
 d30:	ecbff0ef          	jal	bfa <free>
  return freep;
 d34:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d38:	dd61                	beqz	a0,d10 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d3a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d3c:	4798                	lw	a4,8(a5)
 d3e:	fa9777e3          	bgeu	a4,s1,cec <malloc+0x70>
    if(p == freep)
 d42:	00093703          	ld	a4,0(s2)
 d46:	853e                	mv	a0,a5
 d48:	fef719e3          	bne	a4,a5,d3a <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 d4c:	8552                	mv	a0,s4
 d4e:	ab1ff0ef          	jal	7fe <sbrk>
  if(p == (char*)-1)
 d52:	fd551ce3          	bne	a0,s5,d2a <malloc+0xae>
        return 0;
 d56:	4501                	li	a0,0
 d58:	bf65                	j	d10 <malloc+0x94>
