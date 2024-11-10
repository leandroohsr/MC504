
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
  96:	401000ef          	jal	c96 <malloc>
  9a:	f6a43023          	sd	a0,-160(s0)

    for (int i = 1; i <= 30; i++){
  9e:	4785                	li	a5,1
  a0:	f6f43423          	sd	a5,-152(s0)
                } else {       //pai
                    processos[j-1] = pid;
                }
            } else {
                //IO-BOUND
                args[0] = "rows";
  a4:	00001c17          	auipc	s8,0x1
  a8:	d04c0c13          	add	s8,s8,-764 # da8 <malloc+0x112>
                args[0] = "graphs";
  ac:	00001b97          	auipc	s7,0x1
  b0:	cd4b8b93          	add	s7,s7,-812 # d80 <malloc+0xea>
        }

        //pegando max e min
        int lim = segundo_atual;
        int vazao_max = -10;
        int vazao_min = 10000;
  b4:	6789                	lui	a5,0x2
  b6:	71078793          	add	a5,a5,1808 # 2710 <base+0x16f0>
  ba:	f4f43c23          	sd	a5,-168(s0)
  be:	a911                	j	4d2 <main+0x45e>
                index_str[1] = index + '0';
  c0:	02f4879b          	addw	a5,s1,47
  c4:	0ff7f793          	zext.b	a5,a5
                index_str[2] = '\0';
  c8:	03000693          	li	a3,48
  cc:	a881                	j	11c <main+0xa8>
                    ret = exec("graphs", args);
  ce:	f8040593          	add	a1,s0,-128
  d2:	855e                	mv	a0,s7
  d4:	6f4000ef          	jal	7c8 <exec>
                    if (ret == -1){
  d8:	03651263          	bne	a0,s6,fc <main+0x88>
                        printf("erro ao executar graphs.c\n");
  dc:	00001517          	auipc	a0,0x1
  e0:	cac50513          	add	a0,a0,-852 # d88 <malloc+0xf2>
  e4:	2ff000ef          	jal	be2 <printf>
                        exit(1);
  e8:	4505                	li	a0,1
  ea:	6a6000ef          	jal	790 <exit>
                args[0] = "rows";
  ee:	f9843023          	sd	s8,-128(s0)
                pid = fork();
  f2:	696000ef          	jal	788 <fork>
                if (pid == 0){ //filho
  f6:	c529                	beqz	a0,140 <main+0xcc>
                    processos[j-1] = pid;
  f8:	00a92023          	sw	a0,0(s2)
        for (int j = 1; j < 21; j++){
  fc:	2485                	addw	s1,s1,1
  fe:	0911                	add	s2,s2,4
 100:	47d5                	li	a5,21
 102:	04f48f63          	beq	s1,a5,160 <main+0xec>
            if (index < 10) {
 106:	0004871b          	sext.w	a4,s1
 10a:	fff4879b          	addw	a5,s1,-1
 10e:	fafa59e3          	bge	s4,a5,c0 <main+0x4c>
                index_str[1] = (index - 10) + '0';
 112:	0254879b          	addw	a5,s1,37
 116:	0ff7f793          	zext.b	a5,a5
 11a:	86ea                	mv	a3,s10
                index_str[0] = '0';
 11c:	f6d40c23          	sb	a3,-136(s0)
                index_str[1] = index + '0';
 120:	f6f40ca3          	sb	a5,-135(s0)
                index_str[2] = '\0';
 124:	f6040d23          	sb	zero,-134(s0)
            args[1] = index_str;
 128:	f9343423          	sd	s3,-120(s0)
            if (j <= X){
 12c:	fceae1e3          	bltu	s5,a4,ee <main+0x7a>
                args[0] = "graphs";
 130:	f9743023          	sd	s7,-128(s0)
                pid = fork();
 134:	654000ef          	jal	788 <fork>
                if (pid == 0){ //filho
 138:	d959                	beqz	a0,ce <main+0x5a>
                    processos[j-1] = pid;
 13a:	00a92023          	sw	a0,0(s2)
 13e:	bf7d                	j	fc <main+0x88>
                    ret = exec("rows", args);
 140:	f8040593          	add	a1,s0,-128
 144:	8562                	mv	a0,s8
 146:	682000ef          	jal	7c8 <exec>
                    if (ret == -1){
 14a:	fb6519e3          	bne	a0,s6,fc <main+0x88>
                        printf("erro ao executar rows.c\n");
 14e:	00001517          	auipc	a0,0x1
 152:	c6250513          	add	a0,a0,-926 # db0 <malloc+0x11a>
 156:	28d000ef          	jal	be2 <printf>
                        exit(1);
 15a:	4505                	li	a0,1
 15c:	634000ef          	jal	790 <exit>
        int *terminos = malloc(20 * sizeof(int));
 160:	05000513          	li	a0,80
 164:	333000ef          	jal	c96 <malloc>
 168:	8b2a                	mv	s6,a0
        for (int j = 0; j < 20; j++){
 16a:	05050993          	add	s3,a0,80
        int *terminos = malloc(20 * sizeof(int));
 16e:	84aa                	mv	s1,a0
            if (proc == -1){
 170:	597d                	li	s2,-1
                printf("pocesso falhou");
 172:	00001a17          	auipc	s4,0x1
 176:	c5ea0a13          	add	s4,s4,-930 # dd0 <malloc+0x13a>
 17a:	a809                	j	18c <main+0x118>
                tempo_atual = uptime();
 17c:	6ac000ef          	jal	828 <uptime>
                terminos[j] = (tempo_atual - t0_rodada);
 180:	4195053b          	subw	a0,a0,s9
 184:	c088                	sw	a0,0(s1)
        for (int j = 0; j < 20; j++){
 186:	0491                	add	s1,s1,4
 188:	01348b63          	beq	s1,s3,19e <main+0x12a>
            proc = wait(0);
 18c:	4501                	li	a0,0
 18e:	60a000ef          	jal	798 <wait>
            if (proc == -1){
 192:	ff2515e3          	bne	a0,s2,17c <main+0x108>
                printf("pocesso falhou");
 196:	8552                	mv	a0,s4
 198:	24b000ef          	jal	be2 <printf>
 19c:	b7ed                	j	186 <main+0x112>
        tempo_atual = uptime();
 19e:	68a000ef          	jal	828 <uptime>
        printf("RODADA %d ======================\n", i);
 1a2:	f6843583          	ld	a1,-152(s0)
 1a6:	00001517          	auipc	a0,0x1
 1aa:	c3a50513          	add	a0,a0,-966 # de0 <malloc+0x14a>
 1ae:	235000ef          	jal	be2 <printf>
        for (int j = 0; j < 20; j++){
 1b2:	004b0593          	add	a1,s6,4
        printf("RODADA %d ======================\n", i);
 1b6:	4801                	li	a6,0
        for (int j = 0; j < 20; j++){
 1b8:	4501                	li	a0,0
            for (int k = j+1; k < 20; k++){
 1ba:	48d1                	li	a7,20
 1bc:	4e4d                	li	t3,19
 1be:	008b0313          	add	t1,s6,8
 1c2:	a831                	j	1de <main+0x16a>
 1c4:	0791                	add	a5,a5,4
 1c6:	00d78a63          	beq	a5,a3,1da <main+0x166>
                if (terminos[k] < terminos[j]){
 1ca:	4398                	lw	a4,0(a5)
 1cc:	ffc5a603          	lw	a2,-4(a1)
 1d0:	fec75ae3          	bge	a4,a2,1c4 <main+0x150>
                    terminos[j] = terminos[k];
 1d4:	fee5ae23          	sw	a4,-4(a1)
                    terminos[k] = temp;
 1d8:	b7f5                	j	1c4 <main+0x150>
        for (int j = 0; j < 20; j++){
 1da:	0805                	add	a6,a6,1
 1dc:	0591                	add	a1,a1,4
            for (int k = j+1; k < 20; k++){
 1de:	0015079b          	addw	a5,a0,1
 1e2:	0007851b          	sext.w	a0,a5
 1e6:	01150b63          	beq	a0,a7,1fc <main+0x188>
 1ea:	40fe06bb          	subw	a3,t3,a5
 1ee:	1682                	sll	a3,a3,0x20
 1f0:	9281                	srl	a3,a3,0x20
 1f2:	96c2                	add	a3,a3,a6
 1f4:	068a                	sll	a3,a3,0x2
 1f6:	969a                	add	a3,a3,t1
 1f8:	87ae                	mv	a5,a1
 1fa:	bfc1                	j	1ca <main+0x156>
        int *vazoes = malloc(50 * sizeof(int));
 1fc:	0c800513          	li	a0,200
 200:	297000ef          	jal	c96 <malloc>
 204:	8caa                	mv	s9,a0
        for (int j = 0; j < 50; j++){
 206:	8a2a                	mv	s4,a0
 208:	0c850713          	add	a4,a0,200
        int *vazoes = malloc(50 * sizeof(int));
 20c:	87aa                	mv	a5,a0
            vazoes[j] = 0;
 20e:	0007a023          	sw	zero,0(a5)
        for (int j = 0; j < 50; j++){
 212:	0791                	add	a5,a5,4
 214:	fef71de3          	bne	a4,a5,20e <main+0x19a>
        int segundo_atual = 0;
 218:	4481                	li	s1,0
        int index = 0;
 21a:	4681                	li	a3,0
        while (index < 20){
 21c:	464d                	li	a2,19
 21e:	a021                	j	226 <main+0x1b2>
                segundo_atual += 1;
 220:	2485                	addw	s1,s1,1
        while (index < 20){
 222:	02d64563          	blt	a2,a3,24c <main+0x1d8>
            if (10 * segundo_atual >= terminos[index]){
 226:	0024979b          	sllw	a5,s1,0x2
 22a:	9fa5                	addw	a5,a5,s1
 22c:	00269713          	sll	a4,a3,0x2
 230:	975a                	add	a4,a4,s6
 232:	0017979b          	sllw	a5,a5,0x1
 236:	4318                	lw	a4,0(a4)
 238:	fee7c4e3          	blt	a5,a4,220 <main+0x1ac>
                index += 1;
 23c:	2685                	addw	a3,a3,1
                vazoes[segundo_atual] += 1;
 23e:	00249793          	sll	a5,s1,0x2
 242:	97e6                	add	a5,a5,s9
 244:	4398                	lw	a4,0(a5)
 246:	2705                	addw	a4,a4,1 # ffffffff80000001 <base+0xffffffff7fffefe1>
 248:	c398                	sw	a4,0(a5)
 24a:	bfe1                	j	222 <main+0x1ae>
        for (int j = 0; j <= lim; j++){
 24c:	0404c263          	bltz	s1,290 <main+0x21c>
 250:	4901                	li	s2,0
        int vazao_min = 10000;
 252:	f5843a83          	ld	s5,-168(s0)
        int vazao_max = -10;
 256:	59d9                	li	s3,-10
                vazao_min = vazoes[j];
            }
            if (vazoes[j] > vazao_max) {
                vazao_max = vazoes[j];
            }
            printf("vazoes[%d]: %d\n", j, vazoes[j]);
 258:	00001d17          	auipc	s10,0x1
 25c:	bb0d0d13          	add	s10,s10,-1104 # e08 <malloc+0x172>
 260:	a819                	j	276 <main+0x202>
 262:	0007899b          	sext.w	s3,a5
 266:	85ca                	mv	a1,s2
 268:	856a                	mv	a0,s10
 26a:	179000ef          	jal	be2 <printf>
        for (int j = 0; j <= lim; j++){
 26e:	2905                	addw	s2,s2,1
 270:	0a11                	add	s4,s4,4
 272:	0324c263          	blt	s1,s2,296 <main+0x222>
            if (vazoes[j] < vazao_min) {
 276:	000a2603          	lw	a2,0(s4)
 27a:	87b2                	mv	a5,a2
 27c:	00cad363          	bge	s5,a2,282 <main+0x20e>
 280:	87d6                	mv	a5,s5
 282:	00078a9b          	sext.w	s5,a5
            if (vazoes[j] > vazao_max) {
 286:	87b2                	mv	a5,a2
 288:	fd365de3          	bge	a2,s3,262 <main+0x1ee>
 28c:	87ce                	mv	a5,s3
 28e:	bfd1                	j	262 <main+0x1ee>
        int vazao_min = 10000;
 290:	f5843a83          	ld	s5,-168(s0)
        int vazao_max = -10;
 294:	59d9                	li	s3,-10
        }

        //normalizando
        int vazao_media = (20 * 1000) / lim;
        vazao_max *= 1000;
        vazao_min *= 1000;
 296:	3e800693          	li	a3,1000
 29a:	03568abb          	mulw	s5,a3,s5
        int vazao_media = (20 * 1000) / lim;
 29e:	6715                	lui	a4,0x5
 2a0:	e207071b          	addw	a4,a4,-480 # 4e20 <base+0x3e00>
 2a4:	0297473b          	divw	a4,a4,s1

        int nominador = vazao_media - vazao_min;
 2a8:	4157073b          	subw	a4,a4,s5
        int denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero

        int res = 1000 - (nominador * 1000 / denominador);
 2ac:	02d7073b          	mulw	a4,a4,a3
        vazao_max *= 1000;
 2b0:	033687bb          	mulw	a5,a3,s3
        int denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero
 2b4:	415787bb          	subw	a5,a5,s5
        int res = 1000 - (nominador * 1000 / denominador);
 2b8:	02f74abb          	divw	s5,a4,a5
 2bc:	41568abb          	subw	s5,a3,s5
        int vazao_norm = res % 1000; //o valor é sempre de 0-1, não faz sentido pegar o valor maior e 1
 2c0:	02daeabb          	remw	s5,s5,a3
        printf("vazao normalizada: %de-03\n", vazao_norm);
 2c4:	000a859b          	sext.w	a1,s5
 2c8:	00001517          	auipc	a0,0x1
 2cc:	b5050513          	add	a0,a0,-1200 # e18 <malloc+0x182>
 2d0:	113000ef          	jal	be2 <printf>

        free(terminos);
 2d4:	855a                	mv	a0,s6
 2d6:	13f000ef          	jal	c14 <free>
        free(vazoes);
 2da:	8566                	mv	a0,s9
 2dc:	139000ef          	jal	c14 <free>
        

        // EFICIENCIA DO SISTEMA DE ARQUIVOS
        int *eficiencias = malloc(Y * sizeof(int));
 2e0:	002d951b          	sllw	a0,s11,0x2
 2e4:	1b3000ef          	jal	c96 <malloc>
 2e8:	892a                	mv	s2,a0
        
        //lendo os dados da struct processo

        int l = 0;           //graphs.c não gera métricas overhead
        int eficiencia_atual;
        for (int k = 0; k < 20; k++){
 2ea:	4481                	li	s1,0
        int l = 0;           //graphs.c não gera métricas overhead
 2ec:	4981                	li	s3,0
        for (int k = 0; k < 20; k++){
 2ee:	4a51                	li	s4,20
 2f0:	a021                	j	2f8 <main+0x284>
 2f2:	2485                	addw	s1,s1,1
 2f4:	01448d63          	beq	s1,s4,30e <main+0x29a>
            eficiencia_atual = get_eficiencia(k);
 2f8:	8526                	mv	a0,s1
 2fa:	53e000ef          	jal	838 <get_eficiencia>
            if (eficiencia_atual >= 0 ){
 2fe:	fe054ae3          	bltz	a0,2f2 <main+0x27e>
                eficiencias[l] = eficiencia_atual;
 302:	00299793          	sll	a5,s3,0x2
 306:	97ca                	add	a5,a5,s2
 308:	c388                	sw	a0,0(a5)
                l += 1;
 30a:	2985                	addw	s3,s3,1
 30c:	b7dd                	j	2f2 <main+0x27e>
 30e:	874a                	mv	a4,s2
 310:	020d9793          	sll	a5,s11,0x20
 314:	01e7dc93          	srl	s9,a5,0x1e
 318:	019908b3          	add	a7,s2,s9
        }
        
        //pegando maximo e minimo
        int eficiencia_max = -10;
        int eficiencia_min = 100000;
        int eficiencia_soma = 0;
 31c:	4801                	li	a6,0
        int eficiencia_min = 100000;
 31e:	6661                	lui	a2,0x18
 320:	6a060613          	add	a2,a2,1696 # 186a0 <base+0x17680>
        int eficiencia_max = -10;
 324:	5559                	li	a0,-10
 326:	a031                	j	332 <main+0x2be>
 328:	0005851b          	sext.w	a0,a1
        
        for(int j = 0; j < Y; j ++){
 32c:	0711                	add	a4,a4,4
 32e:	03170263          	beq	a4,a7,352 <main+0x2de>
            eficiencia_soma += eficiencias[j];
 332:	431c                	lw	a5,0(a4)
 334:	010786bb          	addw	a3,a5,a6
 338:	0006881b          	sext.w	a6,a3
            if (eficiencias[j] < eficiencia_min){
 33c:	85be                	mv	a1,a5
 33e:	00f65363          	bge	a2,a5,344 <main+0x2d0>
 342:	85b2                	mv	a1,a2
 344:	0005861b          	sext.w	a2,a1
                eficiencia_min = eficiencias[j];
            }
            if (eficiencias[j] > eficiencia_max) {
 348:	85be                	mv	a1,a5
 34a:	fca7dfe3          	bge	a5,a0,328 <main+0x2b4>
 34e:	85aa                	mv	a1,a0
 350:	bfe1                	j	328 <main+0x2b4>
        }

        //normalizando
        int eficiencia_media = (1000 * eficiencia_soma) / Y;
        eficiencia_max *= 1000;
        eficiencia_min *= 1000;
 352:	3e800713          	li	a4,1000
 356:	02c7063b          	mulw	a2,a4,a2
        int eficiencia_media = (1000 * eficiencia_soma) / Y;
 35a:	02d709bb          	mulw	s3,a4,a3
 35e:	03b9d9bb          	divuw	s3,s3,s11

        nominador = eficiencia_media - eficiencia_min;
 362:	40c989bb          	subw	s3,s3,a2
        denominador = eficiencia_max - eficiencia_min;
        
        res = 1000 - (nominador * 1000 / denominador);
 366:	02e989bb          	mulw	s3,s3,a4
        eficiencia_max *= 1000;
 36a:	02b707bb          	mulw	a5,a4,a1
        denominador = eficiencia_max - eficiencia_min;
 36e:	9f91                	subw	a5,a5,a2
        res = 1000 - (nominador * 1000 / denominador);
 370:	02f9c9bb          	divw	s3,s3,a5
 374:	413709bb          	subw	s3,a4,s3
        int eficiencia_norm = res % 1000;
 378:	02e9e9bb          	remw	s3,s3,a4
        printf("eficiencia normalizada: %de-03\n", eficiencia_norm);
 37c:	0009859b          	sext.w	a1,s3
 380:	00001517          	auipc	a0,0x1
 384:	ab850513          	add	a0,a0,-1352 # e38 <malloc+0x1a2>
 388:	05b000ef          	jal	be2 <printf>
        free(eficiencias);
 38c:	854a                	mv	a0,s2
 38e:	087000ef          	jal	c14 <free>


        //OVERHEAD
        int *overheads = malloc(20 * sizeof(int));
 392:	05000513          	li	a0,80
 396:	101000ef          	jal	c96 <malloc>
 39a:	8d2a                	mv	s10,a0
        

        //lendo os dados da struct do processo
        int overhead_atual;
        for (int k = 0; k < 20; k++){
 39c:	8a2a                	mv	s4,a0
        int *overheads = malloc(20 * sizeof(int));
 39e:	892a                	mv	s2,a0
        for (int k = 0; k < 20; k++){
 3a0:	4481                	li	s1,0
 3a2:	4b51                	li	s6,20
            overhead_atual = get_overhead(k);
 3a4:	8526                	mv	a0,s1
 3a6:	49a000ef          	jal	840 <get_overhead>
            overheads[k] = overhead_atual;
 3aa:	00a92023          	sw	a0,0(s2)
        for (int k = 0; k < 20; k++){
 3ae:	2485                	addw	s1,s1,1
 3b0:	0911                	add	s2,s2,4
 3b2:	ff6499e3          	bne	s1,s6,3a4 <main+0x330>
 3b6:	9cea                	add	s9,s9,s10
        }

        //pegando maximo e minimo
        int overhead_max = -10;
        int overhead_min = 100000;
        int overhead_soma = 0;
 3b8:	4501                	li	a0,0
        int overhead_min = 100000;
 3ba:	6761                	lui	a4,0x18
 3bc:	6a070713          	add	a4,a4,1696 # 186a0 <base+0x17680>
        int overhead_max = -10;
 3c0:	5659                	li	a2,-10
 3c2:	a031                	j	3ce <main+0x35a>
 3c4:	0006861b          	sext.w	a2,a3
        
        for(int j = 0; j < Y; j ++){
 3c8:	0a11                	add	s4,s4,4
 3ca:	034c8363          	beq	s9,s4,3f0 <main+0x37c>
            overhead_soma += overheads[j];
 3ce:	000a2783          	lw	a5,0(s4)
 3d2:	00a785bb          	addw	a1,a5,a0
 3d6:	0005851b          	sext.w	a0,a1
            if (overheads[j] < overhead_min){
 3da:	86be                	mv	a3,a5
 3dc:	00f75363          	bge	a4,a5,3e2 <main+0x36e>
 3e0:	86ba                	mv	a3,a4
 3e2:	0006871b          	sext.w	a4,a3
                overhead_min = overheads[j];
            }
            if (overheads[j] > overhead_max) {
 3e6:	86be                	mv	a3,a5
 3e8:	fcc7dee3          	bge	a5,a2,3c4 <main+0x350>
 3ec:	86b2                	mv	a3,a2
 3ee:	bfd9                	j	3c4 <main+0x350>
        }

        //normalizando
        int overhead_media = (1000 * overhead_soma) / 20;
        overhead_max *= 1000;
        overhead_min *= 1000;
 3f0:	3e800613          	li	a2,1000
 3f4:	02e6073b          	mulw	a4,a2,a4
        int overhead_media = (1000 * overhead_soma) / 20;
 3f8:	03200b13          	li	s6,50
 3fc:	02bb0b3b          	mulw	s6,s6,a1

        nominador = overhead_media - overhead_min;
 400:	40eb0b3b          	subw	s6,s6,a4
        denominador = overhead_max - overhead_min;
        res = 1000 - (nominador * 1000 / denominador);
 404:	02cb0b3b          	mulw	s6,s6,a2
        overhead_max *= 1000;
 408:	02d607bb          	mulw	a5,a2,a3
        denominador = overhead_max - overhead_min;
 40c:	9f99                	subw	a5,a5,a4
        res = 1000 - (nominador * 1000 / denominador);
 40e:	02fb4b3b          	divw	s6,s6,a5
 412:	41660b3b          	subw	s6,a2,s6
        int overhead_norm = res % 1000;
 416:	02cb6b3b          	remw	s6,s6,a2
        printf("overhead normalizado: %de-03\n", overhead_norm);
 41a:	000b059b          	sext.w	a1,s6
 41e:	00001517          	auipc	a0,0x1
 422:	a3a50513          	add	a0,a0,-1478 # e58 <malloc+0x1c2>
 426:	7bc000ef          	jal	be2 <printf>
        free(overheads);
 42a:	856a                	mv	a0,s10
 42c:	7e8000ef          	jal	c14 <free>

        //JUSTIÇA
        int *justicas = malloc(20 * sizeof(int));
 430:	05000513          	li	a0,80
 434:	063000ef          	jal	c96 <malloc>
 438:	84aa                	mv	s1,a0
 43a:	8a2a                	mv	s4,a0
        //lendo do proc.c
        for (int k = 0; k < 20; k++){
 43c:	4901                	li	s2,0
 43e:	4cd1                	li	s9,20
            justicas[k] = get_justica(k);
 440:	854a                	mv	a0,s2
 442:	416000ef          	jal	858 <get_justica>
 446:	00aa2023          	sw	a0,0(s4)
        for (int k = 0; k < 20; k++){
 44a:	2905                	addw	s2,s2,1
 44c:	0a11                	add	s4,s4,4
 44e:	ff9919e3          	bne	s2,s9,440 <main+0x3cc>
 452:	05048593          	add	a1,s1,80

        //pegando máximo e mínimo
        int justica_max = -10;
        int justica_min = 100000;
        int justica_soma = 0;
        int justica_soma_quadrado = 0;
 456:	4601                	li	a2,0
        int justica_soma = 0;
 458:	4681                	li	a3,0
        for (int k = 0; k < 20; k++){
            justica_soma += justicas[k];
 45a:	409c                	lw	a5,0(s1)
 45c:	00d7873b          	addw	a4,a5,a3
 460:	0007069b          	sext.w	a3,a4
            justica_soma_quadrado += justicas[k] * justicas[k];
 464:	02f787bb          	mulw	a5,a5,a5
 468:	9fb1                	addw	a5,a5,a2
 46a:	0007861b          	sext.w	a2,a5
        for (int k = 0; k < 20; k++){
 46e:	0491                	add	s1,s1,4
 470:	feb495e3          	bne	s1,a1,45a <main+0x3e6>
                justica_max = justicas[k];
            }
        }

        //normalizando
        nominador = justica_soma * justica_soma;
 474:	02e7073b          	mulw	a4,a4,a4
        denominador = 20 * justica_soma_quadrado;
        res = 1000 - (nominador * 1000 / denominador);
 478:	3e800693          	li	a3,1000
 47c:	02d704bb          	mulw	s1,a4,a3
        denominador = 20 * justica_soma_quadrado;
 480:	0027971b          	sllw	a4,a5,0x2
 484:	9fb9                	addw	a5,a5,a4
 486:	0027979b          	sllw	a5,a5,0x2
        res = 1000 - (nominador * 1000 / denominador);
 48a:	02f4c4bb          	divw	s1,s1,a5
 48e:	409684bb          	subw	s1,a3,s1
        int justica_norm = res % 1000;
 492:	02d4e4bb          	remw	s1,s1,a3
        printf("justica normalizada: %de-03\n", justica_norm);
 496:	0004859b          	sext.w	a1,s1
 49a:	00001517          	auipc	a0,0x1
 49e:	9de50513          	add	a0,a0,-1570 # e78 <malloc+0x1e2>
 4a2:	740000ef          	jal	be2 <printf>

        //DESEMPENHO
        int desempenho = (overhead_norm + eficiencia_norm + vazao_norm + justica_norm);
 4a6:	016985bb          	addw	a1,s3,s6
 4aa:	015585bb          	addw	a1,a1,s5
 4ae:	9da5                	addw	a1,a1,s1
        desempenho = desempenho >> 2;
        printf("desempenho: %de-03\n", desempenho);
 4b0:	4025d59b          	sraw	a1,a1,0x2
 4b4:	00001517          	auipc	a0,0x1
 4b8:	9e450513          	add	a0,a0,-1564 # e98 <malloc+0x202>
 4bc:	726000ef          	jal	be2 <printf>
    for (int i = 1; i <= 30; i++){
 4c0:	f6843783          	ld	a5,-152(s0)
 4c4:	2785                	addw	a5,a5,1
 4c6:	873e                	mv	a4,a5
 4c8:	f6f43423          	sd	a5,-152(s0)
 4cc:	47fd                	li	a5,31
 4ce:	02f70c63          	beq	a4,a5,506 <main+0x492>
        initialize_metrics();
 4d2:	37e000ef          	jal	850 <initialize_metrics>
        t0_rodada = uptime();
 4d6:	352000ef          	jal	828 <uptime>
 4da:	8caa                	mv	s9,a0
        uint X = (rand() % 9) + 6;
 4dc:	b7dff0ef          	jal	58 <rand>
 4e0:	47a5                	li	a5,9
 4e2:	02f567bb          	remw	a5,a0,a5
 4e6:	2799                	addw	a5,a5,6
 4e8:	00078a9b          	sext.w	s5,a5
        uint Y = 20 - X;
 4ec:	4dd1                	li	s11,20
 4ee:	40fd8dbb          	subw	s11,s11,a5
        for (int j = 1; j < 21; j++){
 4f2:	f6043903          	ld	s2,-160(s0)
 4f6:	4485                	li	s1,1
            if (index < 10) {
 4f8:	4a25                	li	s4,9
                index_str[1] = (index - 10) + '0';
 4fa:	03100d13          	li	s10,49
            args[1] = index_str;
 4fe:	f7840993          	add	s3,s0,-136
                    if (ret == -1){
 502:	5b7d                	li	s6,-1
 504:	b109                	j	106 <main+0x92>
    }
    return 0;
 506:	4501                	li	a0,0
 508:	70aa                	ld	ra,168(sp)
 50a:	740a                	ld	s0,160(sp)
 50c:	64ea                	ld	s1,152(sp)
 50e:	694a                	ld	s2,144(sp)
 510:	69aa                	ld	s3,136(sp)
 512:	6a0a                	ld	s4,128(sp)
 514:	7ae6                	ld	s5,120(sp)
 516:	7b46                	ld	s6,112(sp)
 518:	7ba6                	ld	s7,104(sp)
 51a:	7c06                	ld	s8,96(sp)
 51c:	6ce6                	ld	s9,88(sp)
 51e:	6d46                	ld	s10,80(sp)
 520:	6da6                	ld	s11,72(sp)
 522:	614d                	add	sp,sp,176
 524:	8082                	ret

0000000000000526 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 526:	1141                	add	sp,sp,-16
 528:	e406                	sd	ra,8(sp)
 52a:	e022                	sd	s0,0(sp)
 52c:	0800                	add	s0,sp,16
  extern int main();
  main();
 52e:	b47ff0ef          	jal	74 <main>
  exit(0);
 532:	4501                	li	a0,0
 534:	25c000ef          	jal	790 <exit>

0000000000000538 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 538:	1141                	add	sp,sp,-16
 53a:	e422                	sd	s0,8(sp)
 53c:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 53e:	87aa                	mv	a5,a0
 540:	0585                	add	a1,a1,1
 542:	0785                	add	a5,a5,1
 544:	fff5c703          	lbu	a4,-1(a1)
 548:	fee78fa3          	sb	a4,-1(a5)
 54c:	fb75                	bnez	a4,540 <strcpy+0x8>
    ;
  return os;
}
 54e:	6422                	ld	s0,8(sp)
 550:	0141                	add	sp,sp,16
 552:	8082                	ret

0000000000000554 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 554:	1141                	add	sp,sp,-16
 556:	e422                	sd	s0,8(sp)
 558:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 55a:	00054783          	lbu	a5,0(a0)
 55e:	cb91                	beqz	a5,572 <strcmp+0x1e>
 560:	0005c703          	lbu	a4,0(a1)
 564:	00f71763          	bne	a4,a5,572 <strcmp+0x1e>
    p++, q++;
 568:	0505                	add	a0,a0,1
 56a:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 56c:	00054783          	lbu	a5,0(a0)
 570:	fbe5                	bnez	a5,560 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 572:	0005c503          	lbu	a0,0(a1)
}
 576:	40a7853b          	subw	a0,a5,a0
 57a:	6422                	ld	s0,8(sp)
 57c:	0141                	add	sp,sp,16
 57e:	8082                	ret

0000000000000580 <strlen>:

uint
strlen(const char *s)
{
 580:	1141                	add	sp,sp,-16
 582:	e422                	sd	s0,8(sp)
 584:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 586:	00054783          	lbu	a5,0(a0)
 58a:	cf91                	beqz	a5,5a6 <strlen+0x26>
 58c:	0505                	add	a0,a0,1
 58e:	87aa                	mv	a5,a0
 590:	86be                	mv	a3,a5
 592:	0785                	add	a5,a5,1
 594:	fff7c703          	lbu	a4,-1(a5)
 598:	ff65                	bnez	a4,590 <strlen+0x10>
 59a:	40a6853b          	subw	a0,a3,a0
 59e:	2505                	addw	a0,a0,1
    ;
  return n;
}
 5a0:	6422                	ld	s0,8(sp)
 5a2:	0141                	add	sp,sp,16
 5a4:	8082                	ret
  for(n = 0; s[n]; n++)
 5a6:	4501                	li	a0,0
 5a8:	bfe5                	j	5a0 <strlen+0x20>

00000000000005aa <memset>:

void*
memset(void *dst, int c, uint n)
{
 5aa:	1141                	add	sp,sp,-16
 5ac:	e422                	sd	s0,8(sp)
 5ae:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5b0:	ca19                	beqz	a2,5c6 <memset+0x1c>
 5b2:	87aa                	mv	a5,a0
 5b4:	1602                	sll	a2,a2,0x20
 5b6:	9201                	srl	a2,a2,0x20
 5b8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5bc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5c0:	0785                	add	a5,a5,1
 5c2:	fee79de3          	bne	a5,a4,5bc <memset+0x12>
  }
  return dst;
}
 5c6:	6422                	ld	s0,8(sp)
 5c8:	0141                	add	sp,sp,16
 5ca:	8082                	ret

00000000000005cc <strchr>:

char*
strchr(const char *s, char c)
{
 5cc:	1141                	add	sp,sp,-16
 5ce:	e422                	sd	s0,8(sp)
 5d0:	0800                	add	s0,sp,16
  for(; *s; s++)
 5d2:	00054783          	lbu	a5,0(a0)
 5d6:	cb99                	beqz	a5,5ec <strchr+0x20>
    if(*s == c)
 5d8:	00f58763          	beq	a1,a5,5e6 <strchr+0x1a>
  for(; *s; s++)
 5dc:	0505                	add	a0,a0,1
 5de:	00054783          	lbu	a5,0(a0)
 5e2:	fbfd                	bnez	a5,5d8 <strchr+0xc>
      return (char*)s;
  return 0;
 5e4:	4501                	li	a0,0
}
 5e6:	6422                	ld	s0,8(sp)
 5e8:	0141                	add	sp,sp,16
 5ea:	8082                	ret
  return 0;
 5ec:	4501                	li	a0,0
 5ee:	bfe5                	j	5e6 <strchr+0x1a>

00000000000005f0 <gets>:

char*
gets(char *buf, int max)
{
 5f0:	711d                	add	sp,sp,-96
 5f2:	ec86                	sd	ra,88(sp)
 5f4:	e8a2                	sd	s0,80(sp)
 5f6:	e4a6                	sd	s1,72(sp)
 5f8:	e0ca                	sd	s2,64(sp)
 5fa:	fc4e                	sd	s3,56(sp)
 5fc:	f852                	sd	s4,48(sp)
 5fe:	f456                	sd	s5,40(sp)
 600:	f05a                	sd	s6,32(sp)
 602:	ec5e                	sd	s7,24(sp)
 604:	1080                	add	s0,sp,96
 606:	8baa                	mv	s7,a0
 608:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 60a:	892a                	mv	s2,a0
 60c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 60e:	4aa9                	li	s5,10
 610:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 612:	89a6                	mv	s3,s1
 614:	2485                	addw	s1,s1,1
 616:	0344d663          	bge	s1,s4,642 <gets+0x52>
    cc = read(0, &c, 1);
 61a:	4605                	li	a2,1
 61c:	faf40593          	add	a1,s0,-81
 620:	4501                	li	a0,0
 622:	186000ef          	jal	7a8 <read>
    if(cc < 1)
 626:	00a05e63          	blez	a0,642 <gets+0x52>
    buf[i++] = c;
 62a:	faf44783          	lbu	a5,-81(s0)
 62e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 632:	01578763          	beq	a5,s5,640 <gets+0x50>
 636:	0905                	add	s2,s2,1
 638:	fd679de3          	bne	a5,s6,612 <gets+0x22>
  for(i=0; i+1 < max; ){
 63c:	89a6                	mv	s3,s1
 63e:	a011                	j	642 <gets+0x52>
 640:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 642:	99de                	add	s3,s3,s7
 644:	00098023          	sb	zero,0(s3)
  return buf;
}
 648:	855e                	mv	a0,s7
 64a:	60e6                	ld	ra,88(sp)
 64c:	6446                	ld	s0,80(sp)
 64e:	64a6                	ld	s1,72(sp)
 650:	6906                	ld	s2,64(sp)
 652:	79e2                	ld	s3,56(sp)
 654:	7a42                	ld	s4,48(sp)
 656:	7aa2                	ld	s5,40(sp)
 658:	7b02                	ld	s6,32(sp)
 65a:	6be2                	ld	s7,24(sp)
 65c:	6125                	add	sp,sp,96
 65e:	8082                	ret

0000000000000660 <stat>:

int
stat(const char *n, struct stat *st)
{
 660:	1101                	add	sp,sp,-32
 662:	ec06                	sd	ra,24(sp)
 664:	e822                	sd	s0,16(sp)
 666:	e426                	sd	s1,8(sp)
 668:	e04a                	sd	s2,0(sp)
 66a:	1000                	add	s0,sp,32
 66c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 66e:	4581                	li	a1,0
 670:	160000ef          	jal	7d0 <open>
  if(fd < 0)
 674:	02054163          	bltz	a0,696 <stat+0x36>
 678:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 67a:	85ca                	mv	a1,s2
 67c:	16c000ef          	jal	7e8 <fstat>
 680:	892a                	mv	s2,a0
  close(fd);
 682:	8526                	mv	a0,s1
 684:	134000ef          	jal	7b8 <close>
  return r;
}
 688:	854a                	mv	a0,s2
 68a:	60e2                	ld	ra,24(sp)
 68c:	6442                	ld	s0,16(sp)
 68e:	64a2                	ld	s1,8(sp)
 690:	6902                	ld	s2,0(sp)
 692:	6105                	add	sp,sp,32
 694:	8082                	ret
    return -1;
 696:	597d                	li	s2,-1
 698:	bfc5                	j	688 <stat+0x28>

000000000000069a <atoi>:

int
atoi(const char *s)
{
 69a:	1141                	add	sp,sp,-16
 69c:	e422                	sd	s0,8(sp)
 69e:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6a0:	00054683          	lbu	a3,0(a0)
 6a4:	fd06879b          	addw	a5,a3,-48
 6a8:	0ff7f793          	zext.b	a5,a5
 6ac:	4625                	li	a2,9
 6ae:	02f66863          	bltu	a2,a5,6de <atoi+0x44>
 6b2:	872a                	mv	a4,a0
  n = 0;
 6b4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 6b6:	0705                	add	a4,a4,1
 6b8:	0025179b          	sllw	a5,a0,0x2
 6bc:	9fa9                	addw	a5,a5,a0
 6be:	0017979b          	sllw	a5,a5,0x1
 6c2:	9fb5                	addw	a5,a5,a3
 6c4:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6c8:	00074683          	lbu	a3,0(a4)
 6cc:	fd06879b          	addw	a5,a3,-48
 6d0:	0ff7f793          	zext.b	a5,a5
 6d4:	fef671e3          	bgeu	a2,a5,6b6 <atoi+0x1c>
  return n;
}
 6d8:	6422                	ld	s0,8(sp)
 6da:	0141                	add	sp,sp,16
 6dc:	8082                	ret
  n = 0;
 6de:	4501                	li	a0,0
 6e0:	bfe5                	j	6d8 <atoi+0x3e>

00000000000006e2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6e2:	1141                	add	sp,sp,-16
 6e4:	e422                	sd	s0,8(sp)
 6e6:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6e8:	02b57463          	bgeu	a0,a1,710 <memmove+0x2e>
    while(n-- > 0)
 6ec:	00c05f63          	blez	a2,70a <memmove+0x28>
 6f0:	1602                	sll	a2,a2,0x20
 6f2:	9201                	srl	a2,a2,0x20
 6f4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6f8:	872a                	mv	a4,a0
      *dst++ = *src++;
 6fa:	0585                	add	a1,a1,1
 6fc:	0705                	add	a4,a4,1
 6fe:	fff5c683          	lbu	a3,-1(a1)
 702:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 706:	fee79ae3          	bne	a5,a4,6fa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 70a:	6422                	ld	s0,8(sp)
 70c:	0141                	add	sp,sp,16
 70e:	8082                	ret
    dst += n;
 710:	00c50733          	add	a4,a0,a2
    src += n;
 714:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 716:	fec05ae3          	blez	a2,70a <memmove+0x28>
 71a:	fff6079b          	addw	a5,a2,-1
 71e:	1782                	sll	a5,a5,0x20
 720:	9381                	srl	a5,a5,0x20
 722:	fff7c793          	not	a5,a5
 726:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 728:	15fd                	add	a1,a1,-1
 72a:	177d                	add	a4,a4,-1
 72c:	0005c683          	lbu	a3,0(a1)
 730:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 734:	fee79ae3          	bne	a5,a4,728 <memmove+0x46>
 738:	bfc9                	j	70a <memmove+0x28>

000000000000073a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 73a:	1141                	add	sp,sp,-16
 73c:	e422                	sd	s0,8(sp)
 73e:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 740:	ca05                	beqz	a2,770 <memcmp+0x36>
 742:	fff6069b          	addw	a3,a2,-1
 746:	1682                	sll	a3,a3,0x20
 748:	9281                	srl	a3,a3,0x20
 74a:	0685                	add	a3,a3,1
 74c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 74e:	00054783          	lbu	a5,0(a0)
 752:	0005c703          	lbu	a4,0(a1)
 756:	00e79863          	bne	a5,a4,766 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 75a:	0505                	add	a0,a0,1
    p2++;
 75c:	0585                	add	a1,a1,1
  while (n-- > 0) {
 75e:	fed518e3          	bne	a0,a3,74e <memcmp+0x14>
  }
  return 0;
 762:	4501                	li	a0,0
 764:	a019                	j	76a <memcmp+0x30>
      return *p1 - *p2;
 766:	40e7853b          	subw	a0,a5,a4
}
 76a:	6422                	ld	s0,8(sp)
 76c:	0141                	add	sp,sp,16
 76e:	8082                	ret
  return 0;
 770:	4501                	li	a0,0
 772:	bfe5                	j	76a <memcmp+0x30>

0000000000000774 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 774:	1141                	add	sp,sp,-16
 776:	e406                	sd	ra,8(sp)
 778:	e022                	sd	s0,0(sp)
 77a:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 77c:	f67ff0ef          	jal	6e2 <memmove>
}
 780:	60a2                	ld	ra,8(sp)
 782:	6402                	ld	s0,0(sp)
 784:	0141                	add	sp,sp,16
 786:	8082                	ret

0000000000000788 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 788:	4885                	li	a7,1
 ecall
 78a:	00000073          	ecall
 ret
 78e:	8082                	ret

0000000000000790 <exit>:
.global exit
exit:
 li a7, SYS_exit
 790:	4889                	li	a7,2
 ecall
 792:	00000073          	ecall
 ret
 796:	8082                	ret

0000000000000798 <wait>:
.global wait
wait:
 li a7, SYS_wait
 798:	488d                	li	a7,3
 ecall
 79a:	00000073          	ecall
 ret
 79e:	8082                	ret

00000000000007a0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7a0:	4891                	li	a7,4
 ecall
 7a2:	00000073          	ecall
 ret
 7a6:	8082                	ret

00000000000007a8 <read>:
.global read
read:
 li a7, SYS_read
 7a8:	4895                	li	a7,5
 ecall
 7aa:	00000073          	ecall
 ret
 7ae:	8082                	ret

00000000000007b0 <write>:
.global write
write:
 li a7, SYS_write
 7b0:	48c1                	li	a7,16
 ecall
 7b2:	00000073          	ecall
 ret
 7b6:	8082                	ret

00000000000007b8 <close>:
.global close
close:
 li a7, SYS_close
 7b8:	48d5                	li	a7,21
 ecall
 7ba:	00000073          	ecall
 ret
 7be:	8082                	ret

00000000000007c0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 7c0:	4899                	li	a7,6
 ecall
 7c2:	00000073          	ecall
 ret
 7c6:	8082                	ret

00000000000007c8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 7c8:	489d                	li	a7,7
 ecall
 7ca:	00000073          	ecall
 ret
 7ce:	8082                	ret

00000000000007d0 <open>:
.global open
open:
 li a7, SYS_open
 7d0:	48bd                	li	a7,15
 ecall
 7d2:	00000073          	ecall
 ret
 7d6:	8082                	ret

00000000000007d8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7d8:	48c5                	li	a7,17
 ecall
 7da:	00000073          	ecall
 ret
 7de:	8082                	ret

00000000000007e0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7e0:	48c9                	li	a7,18
 ecall
 7e2:	00000073          	ecall
 ret
 7e6:	8082                	ret

00000000000007e8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7e8:	48a1                	li	a7,8
 ecall
 7ea:	00000073          	ecall
 ret
 7ee:	8082                	ret

00000000000007f0 <link>:
.global link
link:
 li a7, SYS_link
 7f0:	48cd                	li	a7,19
 ecall
 7f2:	00000073          	ecall
 ret
 7f6:	8082                	ret

00000000000007f8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7f8:	48d1                	li	a7,20
 ecall
 7fa:	00000073          	ecall
 ret
 7fe:	8082                	ret

0000000000000800 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 800:	48a5                	li	a7,9
 ecall
 802:	00000073          	ecall
 ret
 806:	8082                	ret

0000000000000808 <dup>:
.global dup
dup:
 li a7, SYS_dup
 808:	48a9                	li	a7,10
 ecall
 80a:	00000073          	ecall
 ret
 80e:	8082                	ret

0000000000000810 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 810:	48ad                	li	a7,11
 ecall
 812:	00000073          	ecall
 ret
 816:	8082                	ret

0000000000000818 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 818:	48b1                	li	a7,12
 ecall
 81a:	00000073          	ecall
 ret
 81e:	8082                	ret

0000000000000820 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 820:	48b5                	li	a7,13
 ecall
 822:	00000073          	ecall
 ret
 826:	8082                	ret

0000000000000828 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 828:	48b9                	li	a7,14
 ecall
 82a:	00000073          	ecall
 ret
 82e:	8082                	ret

0000000000000830 <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 830:	48d9                	li	a7,22
 ecall
 832:	00000073          	ecall
 ret
 836:	8082                	ret

0000000000000838 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 838:	48dd                	li	a7,23
 ecall
 83a:	00000073          	ecall
 ret
 83e:	8082                	ret

0000000000000840 <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 840:	48e1                	li	a7,24
 ecall
 842:	00000073          	ecall
 ret
 846:	8082                	ret

0000000000000848 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 848:	48e5                	li	a7,25
 ecall
 84a:	00000073          	ecall
 ret
 84e:	8082                	ret

0000000000000850 <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 850:	48e9                	li	a7,26
 ecall
 852:	00000073          	ecall
 ret
 856:	8082                	ret

0000000000000858 <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 858:	48ed                	li	a7,27
 ecall
 85a:	00000073          	ecall
 ret
 85e:	8082                	ret

0000000000000860 <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 860:	48f1                	li	a7,28
 ecall
 862:	00000073          	ecall
 ret
 866:	8082                	ret

0000000000000868 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 868:	1101                	add	sp,sp,-32
 86a:	ec06                	sd	ra,24(sp)
 86c:	e822                	sd	s0,16(sp)
 86e:	1000                	add	s0,sp,32
 870:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 874:	4605                	li	a2,1
 876:	fef40593          	add	a1,s0,-17
 87a:	f37ff0ef          	jal	7b0 <write>
}
 87e:	60e2                	ld	ra,24(sp)
 880:	6442                	ld	s0,16(sp)
 882:	6105                	add	sp,sp,32
 884:	8082                	ret

0000000000000886 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 886:	7139                	add	sp,sp,-64
 888:	fc06                	sd	ra,56(sp)
 88a:	f822                	sd	s0,48(sp)
 88c:	f426                	sd	s1,40(sp)
 88e:	f04a                	sd	s2,32(sp)
 890:	ec4e                	sd	s3,24(sp)
 892:	0080                	add	s0,sp,64
 894:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 896:	c299                	beqz	a3,89c <printint+0x16>
 898:	0805c763          	bltz	a1,926 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 89c:	2581                	sext.w	a1,a1
  neg = 0;
 89e:	4881                	li	a7,0
 8a0:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 8a4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8a6:	2601                	sext.w	a2,a2
 8a8:	00000517          	auipc	a0,0x0
 8ac:	61050513          	add	a0,a0,1552 # eb8 <digits>
 8b0:	883a                	mv	a6,a4
 8b2:	2705                	addw	a4,a4,1
 8b4:	02c5f7bb          	remuw	a5,a1,a2
 8b8:	1782                	sll	a5,a5,0x20
 8ba:	9381                	srl	a5,a5,0x20
 8bc:	97aa                	add	a5,a5,a0
 8be:	0007c783          	lbu	a5,0(a5)
 8c2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8c6:	0005879b          	sext.w	a5,a1
 8ca:	02c5d5bb          	divuw	a1,a1,a2
 8ce:	0685                	add	a3,a3,1
 8d0:	fec7f0e3          	bgeu	a5,a2,8b0 <printint+0x2a>
  if(neg)
 8d4:	00088c63          	beqz	a7,8ec <printint+0x66>
    buf[i++] = '-';
 8d8:	fd070793          	add	a5,a4,-48
 8dc:	00878733          	add	a4,a5,s0
 8e0:	02d00793          	li	a5,45
 8e4:	fef70823          	sb	a5,-16(a4)
 8e8:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 8ec:	02e05663          	blez	a4,918 <printint+0x92>
 8f0:	fc040793          	add	a5,s0,-64
 8f4:	00e78933          	add	s2,a5,a4
 8f8:	fff78993          	add	s3,a5,-1
 8fc:	99ba                	add	s3,s3,a4
 8fe:	377d                	addw	a4,a4,-1
 900:	1702                	sll	a4,a4,0x20
 902:	9301                	srl	a4,a4,0x20
 904:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 908:	fff94583          	lbu	a1,-1(s2)
 90c:	8526                	mv	a0,s1
 90e:	f5bff0ef          	jal	868 <putc>
  while(--i >= 0)
 912:	197d                	add	s2,s2,-1
 914:	ff391ae3          	bne	s2,s3,908 <printint+0x82>
}
 918:	70e2                	ld	ra,56(sp)
 91a:	7442                	ld	s0,48(sp)
 91c:	74a2                	ld	s1,40(sp)
 91e:	7902                	ld	s2,32(sp)
 920:	69e2                	ld	s3,24(sp)
 922:	6121                	add	sp,sp,64
 924:	8082                	ret
    x = -xx;
 926:	40b005bb          	negw	a1,a1
    neg = 1;
 92a:	4885                	li	a7,1
    x = -xx;
 92c:	bf95                	j	8a0 <printint+0x1a>

000000000000092e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 92e:	711d                	add	sp,sp,-96
 930:	ec86                	sd	ra,88(sp)
 932:	e8a2                	sd	s0,80(sp)
 934:	e4a6                	sd	s1,72(sp)
 936:	e0ca                	sd	s2,64(sp)
 938:	fc4e                	sd	s3,56(sp)
 93a:	f852                	sd	s4,48(sp)
 93c:	f456                	sd	s5,40(sp)
 93e:	f05a                	sd	s6,32(sp)
 940:	ec5e                	sd	s7,24(sp)
 942:	e862                	sd	s8,16(sp)
 944:	e466                	sd	s9,8(sp)
 946:	e06a                	sd	s10,0(sp)
 948:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 94a:	0005c903          	lbu	s2,0(a1)
 94e:	24090763          	beqz	s2,b9c <vprintf+0x26e>
 952:	8b2a                	mv	s6,a0
 954:	8a2e                	mv	s4,a1
 956:	8bb2                	mv	s7,a2
  state = 0;
 958:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 95a:	4481                	li	s1,0
 95c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 95e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 962:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 966:	06c00c93          	li	s9,108
 96a:	a005                	j	98a <vprintf+0x5c>
        putc(fd, c0);
 96c:	85ca                	mv	a1,s2
 96e:	855a                	mv	a0,s6
 970:	ef9ff0ef          	jal	868 <putc>
 974:	a019                	j	97a <vprintf+0x4c>
    } else if(state == '%'){
 976:	03598263          	beq	s3,s5,99a <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 97a:	2485                	addw	s1,s1,1
 97c:	8726                	mv	a4,s1
 97e:	009a07b3          	add	a5,s4,s1
 982:	0007c903          	lbu	s2,0(a5)
 986:	20090b63          	beqz	s2,b9c <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 98a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 98e:	fe0994e3          	bnez	s3,976 <vprintf+0x48>
      if(c0 == '%'){
 992:	fd579de3          	bne	a5,s5,96c <vprintf+0x3e>
        state = '%';
 996:	89be                	mv	s3,a5
 998:	b7cd                	j	97a <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 99a:	c7c9                	beqz	a5,a24 <vprintf+0xf6>
 99c:	00ea06b3          	add	a3,s4,a4
 9a0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 9a4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 9a6:	c681                	beqz	a3,9ae <vprintf+0x80>
 9a8:	9752                	add	a4,a4,s4
 9aa:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 9ae:	03878f63          	beq	a5,s8,9ec <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 9b2:	05978963          	beq	a5,s9,a04 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 9b6:	07500713          	li	a4,117
 9ba:	0ee78363          	beq	a5,a4,aa0 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 9be:	07800713          	li	a4,120
 9c2:	12e78563          	beq	a5,a4,aec <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 9c6:	07000713          	li	a4,112
 9ca:	14e78a63          	beq	a5,a4,b1e <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 9ce:	07300713          	li	a4,115
 9d2:	18e78863          	beq	a5,a4,b62 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 9d6:	02500713          	li	a4,37
 9da:	04e79563          	bne	a5,a4,a24 <vprintf+0xf6>
        putc(fd, '%');
 9de:	02500593          	li	a1,37
 9e2:	855a                	mv	a0,s6
 9e4:	e85ff0ef          	jal	868 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 9e8:	4981                	li	s3,0
 9ea:	bf41                	j	97a <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 9ec:	008b8913          	add	s2,s7,8
 9f0:	4685                	li	a3,1
 9f2:	4629                	li	a2,10
 9f4:	000ba583          	lw	a1,0(s7)
 9f8:	855a                	mv	a0,s6
 9fa:	e8dff0ef          	jal	886 <printint>
 9fe:	8bca                	mv	s7,s2
      state = 0;
 a00:	4981                	li	s3,0
 a02:	bfa5                	j	97a <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 a04:	06400793          	li	a5,100
 a08:	02f68963          	beq	a3,a5,a3a <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a0c:	06c00793          	li	a5,108
 a10:	04f68263          	beq	a3,a5,a54 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 a14:	07500793          	li	a5,117
 a18:	0af68063          	beq	a3,a5,ab8 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 a1c:	07800793          	li	a5,120
 a20:	0ef68263          	beq	a3,a5,b04 <vprintf+0x1d6>
        putc(fd, '%');
 a24:	02500593          	li	a1,37
 a28:	855a                	mv	a0,s6
 a2a:	e3fff0ef          	jal	868 <putc>
        putc(fd, c0);
 a2e:	85ca                	mv	a1,s2
 a30:	855a                	mv	a0,s6
 a32:	e37ff0ef          	jal	868 <putc>
      state = 0;
 a36:	4981                	li	s3,0
 a38:	b789                	j	97a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a3a:	008b8913          	add	s2,s7,8
 a3e:	4685                	li	a3,1
 a40:	4629                	li	a2,10
 a42:	000ba583          	lw	a1,0(s7)
 a46:	855a                	mv	a0,s6
 a48:	e3fff0ef          	jal	886 <printint>
        i += 1;
 a4c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a4e:	8bca                	mv	s7,s2
      state = 0;
 a50:	4981                	li	s3,0
        i += 1;
 a52:	b725                	j	97a <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a54:	06400793          	li	a5,100
 a58:	02f60763          	beq	a2,a5,a86 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a5c:	07500793          	li	a5,117
 a60:	06f60963          	beq	a2,a5,ad2 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a64:	07800793          	li	a5,120
 a68:	faf61ee3          	bne	a2,a5,a24 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a6c:	008b8913          	add	s2,s7,8
 a70:	4681                	li	a3,0
 a72:	4641                	li	a2,16
 a74:	000ba583          	lw	a1,0(s7)
 a78:	855a                	mv	a0,s6
 a7a:	e0dff0ef          	jal	886 <printint>
        i += 2;
 a7e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a80:	8bca                	mv	s7,s2
      state = 0;
 a82:	4981                	li	s3,0
        i += 2;
 a84:	bddd                	j	97a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a86:	008b8913          	add	s2,s7,8
 a8a:	4685                	li	a3,1
 a8c:	4629                	li	a2,10
 a8e:	000ba583          	lw	a1,0(s7)
 a92:	855a                	mv	a0,s6
 a94:	df3ff0ef          	jal	886 <printint>
        i += 2;
 a98:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a9a:	8bca                	mv	s7,s2
      state = 0;
 a9c:	4981                	li	s3,0
        i += 2;
 a9e:	bdf1                	j	97a <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 aa0:	008b8913          	add	s2,s7,8
 aa4:	4681                	li	a3,0
 aa6:	4629                	li	a2,10
 aa8:	000ba583          	lw	a1,0(s7)
 aac:	855a                	mv	a0,s6
 aae:	dd9ff0ef          	jal	886 <printint>
 ab2:	8bca                	mv	s7,s2
      state = 0;
 ab4:	4981                	li	s3,0
 ab6:	b5d1                	j	97a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ab8:	008b8913          	add	s2,s7,8
 abc:	4681                	li	a3,0
 abe:	4629                	li	a2,10
 ac0:	000ba583          	lw	a1,0(s7)
 ac4:	855a                	mv	a0,s6
 ac6:	dc1ff0ef          	jal	886 <printint>
        i += 1;
 aca:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 acc:	8bca                	mv	s7,s2
      state = 0;
 ace:	4981                	li	s3,0
        i += 1;
 ad0:	b56d                	j	97a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ad2:	008b8913          	add	s2,s7,8
 ad6:	4681                	li	a3,0
 ad8:	4629                	li	a2,10
 ada:	000ba583          	lw	a1,0(s7)
 ade:	855a                	mv	a0,s6
 ae0:	da7ff0ef          	jal	886 <printint>
        i += 2;
 ae4:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 ae6:	8bca                	mv	s7,s2
      state = 0;
 ae8:	4981                	li	s3,0
        i += 2;
 aea:	bd41                	j	97a <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 aec:	008b8913          	add	s2,s7,8
 af0:	4681                	li	a3,0
 af2:	4641                	li	a2,16
 af4:	000ba583          	lw	a1,0(s7)
 af8:	855a                	mv	a0,s6
 afa:	d8dff0ef          	jal	886 <printint>
 afe:	8bca                	mv	s7,s2
      state = 0;
 b00:	4981                	li	s3,0
 b02:	bda5                	j	97a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 b04:	008b8913          	add	s2,s7,8
 b08:	4681                	li	a3,0
 b0a:	4641                	li	a2,16
 b0c:	000ba583          	lw	a1,0(s7)
 b10:	855a                	mv	a0,s6
 b12:	d75ff0ef          	jal	886 <printint>
        i += 1;
 b16:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 b18:	8bca                	mv	s7,s2
      state = 0;
 b1a:	4981                	li	s3,0
        i += 1;
 b1c:	bdb9                	j	97a <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 b1e:	008b8d13          	add	s10,s7,8
 b22:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b26:	03000593          	li	a1,48
 b2a:	855a                	mv	a0,s6
 b2c:	d3dff0ef          	jal	868 <putc>
  putc(fd, 'x');
 b30:	07800593          	li	a1,120
 b34:	855a                	mv	a0,s6
 b36:	d33ff0ef          	jal	868 <putc>
 b3a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b3c:	00000b97          	auipc	s7,0x0
 b40:	37cb8b93          	add	s7,s7,892 # eb8 <digits>
 b44:	03c9d793          	srl	a5,s3,0x3c
 b48:	97de                	add	a5,a5,s7
 b4a:	0007c583          	lbu	a1,0(a5)
 b4e:	855a                	mv	a0,s6
 b50:	d19ff0ef          	jal	868 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b54:	0992                	sll	s3,s3,0x4
 b56:	397d                	addw	s2,s2,-1
 b58:	fe0916e3          	bnez	s2,b44 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 b5c:	8bea                	mv	s7,s10
      state = 0;
 b5e:	4981                	li	s3,0
 b60:	bd29                	j	97a <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 b62:	008b8993          	add	s3,s7,8
 b66:	000bb903          	ld	s2,0(s7)
 b6a:	00090f63          	beqz	s2,b88 <vprintf+0x25a>
        for(; *s; s++)
 b6e:	00094583          	lbu	a1,0(s2)
 b72:	c195                	beqz	a1,b96 <vprintf+0x268>
          putc(fd, *s);
 b74:	855a                	mv	a0,s6
 b76:	cf3ff0ef          	jal	868 <putc>
        for(; *s; s++)
 b7a:	0905                	add	s2,s2,1
 b7c:	00094583          	lbu	a1,0(s2)
 b80:	f9f5                	bnez	a1,b74 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b82:	8bce                	mv	s7,s3
      state = 0;
 b84:	4981                	li	s3,0
 b86:	bbd5                	j	97a <vprintf+0x4c>
          s = "(null)";
 b88:	00000917          	auipc	s2,0x0
 b8c:	32890913          	add	s2,s2,808 # eb0 <malloc+0x21a>
        for(; *s; s++)
 b90:	02800593          	li	a1,40
 b94:	b7c5                	j	b74 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b96:	8bce                	mv	s7,s3
      state = 0;
 b98:	4981                	li	s3,0
 b9a:	b3c5                	j	97a <vprintf+0x4c>
    }
  }
}
 b9c:	60e6                	ld	ra,88(sp)
 b9e:	6446                	ld	s0,80(sp)
 ba0:	64a6                	ld	s1,72(sp)
 ba2:	6906                	ld	s2,64(sp)
 ba4:	79e2                	ld	s3,56(sp)
 ba6:	7a42                	ld	s4,48(sp)
 ba8:	7aa2                	ld	s5,40(sp)
 baa:	7b02                	ld	s6,32(sp)
 bac:	6be2                	ld	s7,24(sp)
 bae:	6c42                	ld	s8,16(sp)
 bb0:	6ca2                	ld	s9,8(sp)
 bb2:	6d02                	ld	s10,0(sp)
 bb4:	6125                	add	sp,sp,96
 bb6:	8082                	ret

0000000000000bb8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 bb8:	715d                	add	sp,sp,-80
 bba:	ec06                	sd	ra,24(sp)
 bbc:	e822                	sd	s0,16(sp)
 bbe:	1000                	add	s0,sp,32
 bc0:	e010                	sd	a2,0(s0)
 bc2:	e414                	sd	a3,8(s0)
 bc4:	e818                	sd	a4,16(s0)
 bc6:	ec1c                	sd	a5,24(s0)
 bc8:	03043023          	sd	a6,32(s0)
 bcc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 bd0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 bd4:	8622                	mv	a2,s0
 bd6:	d59ff0ef          	jal	92e <vprintf>
}
 bda:	60e2                	ld	ra,24(sp)
 bdc:	6442                	ld	s0,16(sp)
 bde:	6161                	add	sp,sp,80
 be0:	8082                	ret

0000000000000be2 <printf>:

void
printf(const char *fmt, ...)
{
 be2:	711d                	add	sp,sp,-96
 be4:	ec06                	sd	ra,24(sp)
 be6:	e822                	sd	s0,16(sp)
 be8:	1000                	add	s0,sp,32
 bea:	e40c                	sd	a1,8(s0)
 bec:	e810                	sd	a2,16(s0)
 bee:	ec14                	sd	a3,24(s0)
 bf0:	f018                	sd	a4,32(s0)
 bf2:	f41c                	sd	a5,40(s0)
 bf4:	03043823          	sd	a6,48(s0)
 bf8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 bfc:	00840613          	add	a2,s0,8
 c00:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 c04:	85aa                	mv	a1,a0
 c06:	4505                	li	a0,1
 c08:	d27ff0ef          	jal	92e <vprintf>
}
 c0c:	60e2                	ld	ra,24(sp)
 c0e:	6442                	ld	s0,16(sp)
 c10:	6125                	add	sp,sp,96
 c12:	8082                	ret

0000000000000c14 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c14:	1141                	add	sp,sp,-16
 c16:	e422                	sd	s0,8(sp)
 c18:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c1a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c1e:	00000797          	auipc	a5,0x0
 c22:	3f27b783          	ld	a5,1010(a5) # 1010 <freep>
 c26:	a02d                	j	c50 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c28:	4618                	lw	a4,8(a2)
 c2a:	9f2d                	addw	a4,a4,a1
 c2c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c30:	6398                	ld	a4,0(a5)
 c32:	6310                	ld	a2,0(a4)
 c34:	a83d                	j	c72 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c36:	ff852703          	lw	a4,-8(a0)
 c3a:	9f31                	addw	a4,a4,a2
 c3c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c3e:	ff053683          	ld	a3,-16(a0)
 c42:	a091                	j	c86 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c44:	6398                	ld	a4,0(a5)
 c46:	00e7e463          	bltu	a5,a4,c4e <free+0x3a>
 c4a:	00e6ea63          	bltu	a3,a4,c5e <free+0x4a>
{
 c4e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c50:	fed7fae3          	bgeu	a5,a3,c44 <free+0x30>
 c54:	6398                	ld	a4,0(a5)
 c56:	00e6e463          	bltu	a3,a4,c5e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c5a:	fee7eae3          	bltu	a5,a4,c4e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 c5e:	ff852583          	lw	a1,-8(a0)
 c62:	6390                	ld	a2,0(a5)
 c64:	02059813          	sll	a6,a1,0x20
 c68:	01c85713          	srl	a4,a6,0x1c
 c6c:	9736                	add	a4,a4,a3
 c6e:	fae60de3          	beq	a2,a4,c28 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 c72:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c76:	4790                	lw	a2,8(a5)
 c78:	02061593          	sll	a1,a2,0x20
 c7c:	01c5d713          	srl	a4,a1,0x1c
 c80:	973e                	add	a4,a4,a5
 c82:	fae68ae3          	beq	a3,a4,c36 <free+0x22>
    p->s.ptr = bp->s.ptr;
 c86:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c88:	00000717          	auipc	a4,0x0
 c8c:	38f73423          	sd	a5,904(a4) # 1010 <freep>
}
 c90:	6422                	ld	s0,8(sp)
 c92:	0141                	add	sp,sp,16
 c94:	8082                	ret

0000000000000c96 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c96:	7139                	add	sp,sp,-64
 c98:	fc06                	sd	ra,56(sp)
 c9a:	f822                	sd	s0,48(sp)
 c9c:	f426                	sd	s1,40(sp)
 c9e:	f04a                	sd	s2,32(sp)
 ca0:	ec4e                	sd	s3,24(sp)
 ca2:	e852                	sd	s4,16(sp)
 ca4:	e456                	sd	s5,8(sp)
 ca6:	e05a                	sd	s6,0(sp)
 ca8:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 caa:	02051493          	sll	s1,a0,0x20
 cae:	9081                	srl	s1,s1,0x20
 cb0:	04bd                	add	s1,s1,15
 cb2:	8091                	srl	s1,s1,0x4
 cb4:	0014899b          	addw	s3,s1,1
 cb8:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 cba:	00000517          	auipc	a0,0x0
 cbe:	35653503          	ld	a0,854(a0) # 1010 <freep>
 cc2:	c515                	beqz	a0,cee <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cc4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cc6:	4798                	lw	a4,8(a5)
 cc8:	02977f63          	bgeu	a4,s1,d06 <malloc+0x70>
  if(nu < 4096)
 ccc:	8a4e                	mv	s4,s3
 cce:	0009871b          	sext.w	a4,s3
 cd2:	6685                	lui	a3,0x1
 cd4:	00d77363          	bgeu	a4,a3,cda <malloc+0x44>
 cd8:	6a05                	lui	s4,0x1
 cda:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 cde:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ce2:	00000917          	auipc	s2,0x0
 ce6:	32e90913          	add	s2,s2,814 # 1010 <freep>
  if(p == (char*)-1)
 cea:	5afd                	li	s5,-1
 cec:	a885                	j	d5c <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 cee:	00000797          	auipc	a5,0x0
 cf2:	33278793          	add	a5,a5,818 # 1020 <base>
 cf6:	00000717          	auipc	a4,0x0
 cfa:	30f73d23          	sd	a5,794(a4) # 1010 <freep>
 cfe:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 d00:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 d04:	b7e1                	j	ccc <malloc+0x36>
      if(p->s.size == nunits)
 d06:	02e48c63          	beq	s1,a4,d3e <malloc+0xa8>
        p->s.size -= nunits;
 d0a:	4137073b          	subw	a4,a4,s3
 d0e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d10:	02071693          	sll	a3,a4,0x20
 d14:	01c6d713          	srl	a4,a3,0x1c
 d18:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d1a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d1e:	00000717          	auipc	a4,0x0
 d22:	2ea73923          	sd	a0,754(a4) # 1010 <freep>
      return (void*)(p + 1);
 d26:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 d2a:	70e2                	ld	ra,56(sp)
 d2c:	7442                	ld	s0,48(sp)
 d2e:	74a2                	ld	s1,40(sp)
 d30:	7902                	ld	s2,32(sp)
 d32:	69e2                	ld	s3,24(sp)
 d34:	6a42                	ld	s4,16(sp)
 d36:	6aa2                	ld	s5,8(sp)
 d38:	6b02                	ld	s6,0(sp)
 d3a:	6121                	add	sp,sp,64
 d3c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 d3e:	6398                	ld	a4,0(a5)
 d40:	e118                	sd	a4,0(a0)
 d42:	bff1                	j	d1e <malloc+0x88>
  hp->s.size = nu;
 d44:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d48:	0541                	add	a0,a0,16
 d4a:	ecbff0ef          	jal	c14 <free>
  return freep;
 d4e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d52:	dd61                	beqz	a0,d2a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d54:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d56:	4798                	lw	a4,8(a5)
 d58:	fa9777e3          	bgeu	a4,s1,d06 <malloc+0x70>
    if(p == freep)
 d5c:	00093703          	ld	a4,0(s2)
 d60:	853e                	mv	a0,a5
 d62:	fef719e3          	bne	a4,a5,d54 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 d66:	8552                	mv	a0,s4
 d68:	ab1ff0ef          	jal	818 <sbrk>
  if(p == (char*)-1)
 d6c:	fd551ce3          	bne	a0,s5,d44 <malloc+0xae>
        return 0;
 d70:	4501                	li	a0,0
 d72:	bf65                	j	d2a <malloc+0x94>
