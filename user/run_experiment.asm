
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
  92:	734000ef          	jal	7c6 <uptime_nolock>
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
  a0:	c7cb8b93          	add	s7,s7,-900 # d18 <malloc+0x114>
                args[0] = "graphs";
  a4:	00001b17          	auipc	s6,0x1
  a8:	c4cb0b13          	add	s6,s6,-948 # cf0 <malloc+0xec>
        }

        //pegando max e min
        int lim = segundo_atual;
        long long vazao_max = -10;
        long long vazao_min = 10000;
  ac:	6789                	lui	a5,0x2
  ae:	71078793          	add	a5,a5,1808 # 2710 <base+0x16f0>
  b2:	f6f43023          	sd	a5,-160(s0)
  b6:	aeb9                	j	414 <main+0x3a0>
                index_str[1] = index + '0';
  b8:	02f4879b          	addw	a5,s1,47
  bc:	0ff7f793          	zext.b	a5,a5
                index_str[2] = '\0';
  c0:	86ea                	mv	a3,s10
  c2:	a025                	j	ea <main+0x76>
                    set_type(CPU_BOUND, pid);
  c4:	85aa                	mv	a1,a0
  c6:	4509                	li	a0,2
  c8:	706000ef          	jal	7ce <set_type>
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
 102:	5e4000ef          	jal	6e6 <fork>
                if (pid == 0){ //filho
 106:	fd5d                	bnez	a0,c4 <main+0x50>
                    ret = exec("graphs", args);
 108:	f8040593          	add	a1,s0,-128
 10c:	855a                	mv	a0,s6
 10e:	618000ef          	jal	726 <exec>
                    if (ret == -1){
 112:	fb951de3          	bne	a0,s9,cc <main+0x58>
                        printf("erro ao executar graphs.c\n");
 116:	00001517          	auipc	a0,0x1
 11a:	be250513          	add	a0,a0,-1054 # cf8 <malloc+0xf4>
 11e:	233000ef          	jal	b50 <printf>
                        exit(1);
 122:	4505                	li	a0,1
 124:	5ca000ef          	jal	6ee <exit>
                args[0] = "rows";
 128:	f9743023          	sd	s7,-128(s0)
                pid = fork();
 12c:	5ba000ef          	jal	6e6 <fork>
                if (pid == 0){ //filho
 130:	e10d                	bnez	a0,152 <main+0xde>
                    ret = exec("rows", args);
 132:	f8040593          	add	a1,s0,-128
 136:	855e                	mv	a0,s7
 138:	5ee000ef          	jal	726 <exec>
                    if (ret == -1){
 13c:	f99518e3          	bne	a0,s9,cc <main+0x58>
                        printf("erro ao executar rows.c\n");
 140:	00001517          	auipc	a0,0x1
 144:	be050513          	add	a0,a0,-1056 # d20 <malloc+0x11c>
 148:	209000ef          	jal	b50 <printf>
                        exit(1);
 14c:	4505                	li	a0,1
 14e:	5a0000ef          	jal	6ee <exit>
                    set_type(IO_BOUND, pid);
 152:	85aa                	mv	a1,a0
 154:	450d                	li	a0,3
 156:	678000ef          	jal	7ce <set_type>
 15a:	bf8d                	j	cc <main+0x58>
        int *terminos = malloc(20 * sizeof(int));
 15c:	05000513          	li	a0,80
 160:	2a5000ef          	jal	c04 <malloc>
 164:	8a2a                	mv	s4,a0
        for (int j = 0; j < 20; j++){
 166:	05050993          	add	s3,a0,80
        int *terminos = malloc(20 * sizeof(int));
 16a:	84aa                	mv	s1,a0
            if (proc == -1){
 16c:	597d                	li	s2,-1
                printf("pocesso falhou");
 16e:	00001c17          	auipc	s8,0x1
 172:	bd2c0c13          	add	s8,s8,-1070 # d40 <malloc+0x13c>
 176:	a809                	j	188 <main+0x114>
                tempo_atual = uptime_nolock();
 178:	64e000ef          	jal	7c6 <uptime_nolock>
                terminos[j] = (tempo_atual - t0_rodada);
 17c:	4155053b          	subw	a0,a0,s5
 180:	c088                	sw	a0,0(s1)
        for (int j = 0; j < 20; j++){
 182:	0491                	add	s1,s1,4
 184:	01348b63          	beq	s1,s3,19a <main+0x126>
            proc = wait(0);
 188:	4501                	li	a0,0
 18a:	56c000ef          	jal	6f6 <wait>
            if (proc == -1){
 18e:	ff2515e3          	bne	a0,s2,178 <main+0x104>
                printf("pocesso falhou");
 192:	8562                	mv	a0,s8
 194:	1bd000ef          	jal	b50 <printf>
 198:	b7ed                	j	182 <main+0x10e>
        printf("RODADA %d ======================\n", i);
 19a:	85ee                	mv	a1,s11
 19c:	00001517          	auipc	a0,0x1
 1a0:	bb450513          	add	a0,a0,-1100 # d50 <malloc+0x14c>
 1a4:	1ad000ef          	jal	b50 <printf>
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
 1f6:	20f000ef          	jal	c04 <malloc>
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
        }

        //normalizando
        long long vazao_media = (20 * 100000) / lim;
        vazao_max *= 100000;
        vazao_min *= 100000;
 278:	6c61                	lui	s8,0x18
 27a:	6a0c0c13          	add	s8,s8,1696 # 186a0 <base+0x17680>
 27e:	038585b3          	mul	a1,a1,s8
        long long vazao_media = (20 * 100000) / lim;
 282:	001e87b7          	lui	a5,0x1e8
 286:	4807879b          	addw	a5,a5,1152 # 1e8480 <base+0x1e7460>
 28a:	02c7c7bb          	divw	a5,a5,a2

        long long nominador = vazao_media - vazao_min;
 28e:	8f8d                	sub	a5,a5,a1
        long long denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero

        long long res = 100000 - (nominador * 100000 / denominador);
 290:	038786b3          	mul	a3,a5,s8
        vazao_max *= 100000;
 294:	038707b3          	mul	a5,a4,s8
        long long denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero
 298:	8f8d                	sub	a5,a5,a1
        long long res = 100000 - (nominador * 100000 / denominador);
 29a:	02f6c7b3          	div	a5,a3,a5
        int vazao_norm = res;
 29e:	40fc0c3b          	subw	s8,s8,a5
        printf("vazao normalizada: %de-05\n", vazao_norm);
 2a2:	85e2                	mv	a1,s8
 2a4:	00001517          	auipc	a0,0x1
 2a8:	ad450513          	add	a0,a0,-1324 # d78 <malloc+0x174>
 2ac:	0a5000ef          	jal	b50 <printf>

        free(terminos);
 2b0:	8552                	mv	a0,s4
 2b2:	0d1000ef          	jal	b82 <free>
        free(vazoes);
 2b6:	8526                	mv	a0,s1
 2b8:	0cb000ef          	jal	b82 <free>
        

        // EFICIENCIA DO SISTEMA DE ARQUIVOS
        int *eficiencias = malloc(Y * sizeof(int));
 2bc:	f6842783          	lw	a5,-152(s0)
 2c0:	0027951b          	sllw	a0,a5,0x2
 2c4:	141000ef          	jal	c04 <malloc>
 2c8:	89aa                	mv	s3,a0
        
        //lendo os dados da struct processo

        int l = 0;
        int eficiencia_atual;
        for (int k = 0; k < 20; k++){
 2ca:	4481                	li	s1,0
        int l = 0;
 2cc:	4901                	li	s2,0
        for (int k = 0; k < 20; k++){
 2ce:	4a51                	li	s4,20
 2d0:	a021                	j	2d8 <main+0x264>
 2d2:	2485                	addw	s1,s1,1
 2d4:	01448d63          	beq	s1,s4,2ee <main+0x27a>
            eficiencia_atual = get_eficiencia(k); //graphs.c devolve um valor negativo,
 2d8:	8526                	mv	a0,s1
 2da:	4bc000ef          	jal	796 <get_eficiencia>
            if (eficiencia_atual >= 0 ){         //para que não impacte no cálculo
 2de:	fe054ae3          	bltz	a0,2d2 <main+0x25e>
                eficiencias[l] = eficiencia_atual;
 2e2:	00291793          	sll	a5,s2,0x2
 2e6:	97ce                	add	a5,a5,s3
 2e8:	c388                	sw	a0,0(a5)
                l += 1;
 2ea:	2905                	addw	s2,s2,1
 2ec:	b7dd                	j	2d2 <main+0x25e>
 2ee:	874e                	mv	a4,s3
 2f0:	f6843683          	ld	a3,-152(s0)
 2f4:	02069793          	sll	a5,a3,0x20
 2f8:	01e7d613          	srl	a2,a5,0x1e
 2fc:	964e                	add	a2,a2,s3
            }
        }
        
        //somando
        int eficiencia_soma = 0;
 2fe:	4681                	li	a3,0
        
        for(int j = 0; j < Y; j ++){
            eficiencia_soma += eficiencias[j];
 300:	431c                	lw	a5,0(a4)
 302:	9fb5                	addw	a5,a5,a3
 304:	0007869b          	sext.w	a3,a5
        for(int j = 0; j < Y; j ++){
 308:	0711                	add	a4,a4,4
 30a:	fec71be3          	bne	a4,a2,300 <main+0x28c>
        }

        //invertendo
        res = 100000 / eficiencia_soma;
 30e:	6ae1                	lui	s5,0x18
 310:	6a0a8a9b          	addw	s5,s5,1696 # 186a0 <base+0x17680>
 314:	02facabb          	divw	s5,s5,a5
        int eficiencia_fim = res;
        printf("eficiencia: %de-05\n", eficiencia_fim);
 318:	000a859b          	sext.w	a1,s5
 31c:	00001517          	auipc	a0,0x1
 320:	a7c50513          	add	a0,a0,-1412 # d98 <malloc+0x194>
 324:	02d000ef          	jal	b50 <printf>
        free(eficiencias);
 328:	854e                	mv	a0,s3
 32a:	059000ef          	jal	b82 <free>


        //OVERHEAD
        int *overheads = malloc(20 * sizeof(int));
 32e:	05000513          	li	a0,80
 332:	0d3000ef          	jal	c04 <malloc>
 336:	8a2a                	mv	s4,a0
        

        //lendo os dados da struct do processo
        int overhead_atual;
        for (int k = 0; k < 20; k++){
 338:	84aa                	mv	s1,a0
        int *overheads = malloc(20 * sizeof(int));
 33a:	89aa                	mv	s3,a0
        for (int k = 0; k < 20; k++){
 33c:	4901                	li	s2,0
 33e:	4cd1                	li	s9,20
            overhead_atual = get_overhead(k);
 340:	854a                	mv	a0,s2
 342:	45c000ef          	jal	79e <get_overhead>
            overheads[k] = overhead_atual;
 346:	00a9a023          	sw	a0,0(s3)
        for (int k = 0; k < 20; k++){
 34a:	2905                	addw	s2,s2,1
 34c:	0991                	add	s3,s3,4
 34e:	ff9919e3          	bne	s2,s9,340 <main+0x2cc>
 352:	050a0693          	add	a3,s4,80
        }


        int overhead_soma = 0;
 356:	4701                	li	a4,0
        
        for(int j = 0; j < 20; j ++){
            overhead_soma += overheads[j];
 358:	409c                	lw	a5,0(s1)
 35a:	9fb9                	addw	a5,a5,a4
 35c:	0007871b          	sext.w	a4,a5
        for(int j = 0; j < 20; j ++){
 360:	0491                	add	s1,s1,4
 362:	fe969be3          	bne	a3,s1,358 <main+0x2e4>
        }

        //invertendo
        res = (100000 / overhead_soma);
 366:	6ce1                	lui	s9,0x18
 368:	6a0c8c9b          	addw	s9,s9,1696 # 186a0 <base+0x17680>
 36c:	02fcccbb          	divw	s9,s9,a5
        int overhead_fim = res;
        printf("overhead: %de-05\n", overhead_fim);
 370:	000c859b          	sext.w	a1,s9
 374:	00001517          	auipc	a0,0x1
 378:	a3c50513          	add	a0,a0,-1476 # db0 <malloc+0x1ac>
 37c:	7d4000ef          	jal	b50 <printf>
        free(overheads);
 380:	8552                	mv	a0,s4
 382:	001000ef          	jal	b82 <free>

        //JUSTIÇA
        int *justicas = malloc(20 * sizeof(int));
 386:	05000513          	li	a0,80
 38a:	07b000ef          	jal	c04 <malloc>
 38e:	8d2a                	mv	s10,a0

        //lendo do proc.c
        for (int k = 0; k < 20; k++){
 390:	84aa                	mv	s1,a0
        int *justicas = malloc(20 * sizeof(int));
 392:	89aa                	mv	s3,a0
        for (int k = 0; k < 20; k++){
 394:	4901                	li	s2,0
 396:	4a51                	li	s4,20
            justicas[k] = get_justica(k);
 398:	854a                	mv	a0,s2
 39a:	41c000ef          	jal	7b6 <get_justica>
 39e:	00a9a023          	sw	a0,0(s3)
        for (int k = 0; k < 20; k++){
 3a2:	2905                	addw	s2,s2,1
 3a4:	0991                	add	s3,s3,4
 3a6:	ff4919e3          	bne	s2,s4,398 <main+0x324>
 3aa:	050d0613          	add	a2,s10,80
        }

        //somando
        long long justica_soma = 0; 
        long long justica_soma_quadrado = 0;
 3ae:	4681                	li	a3,0
        long long justica_soma = 0; 
 3b0:	4701                	li	a4,0
        for (int k = 0; k < 20; k++){
            justica_soma += justicas[k];
 3b2:	409c                	lw	a5,0(s1)
 3b4:	973e                	add	a4,a4,a5
            justica_soma_quadrado += justicas[k] * justicas[k];
 3b6:	02f787bb          	mulw	a5,a5,a5
 3ba:	96be                	add	a3,a3,a5
        for (int k = 0; k < 20; k++){
 3bc:	0491                	add	s1,s1,4
 3be:	fec49ae3          	bne	s1,a2,3b2 <main+0x33e>
        }

        //normalizando
        long long nominador2 = justica_soma * justica_soma;
 3c2:	02e70733          	mul	a4,a4,a4
        long long denominador2 = 20 * justica_soma_quadrado;
        res = (nominador2 * 100000) / denominador2;
 3c6:	67e1                	lui	a5,0x18
 3c8:	6a078793          	add	a5,a5,1696 # 186a0 <base+0x17680>
 3cc:	02f704b3          	mul	s1,a4,a5
        long long denominador2 = 20 * justica_soma_quadrado;
 3d0:	00269793          	sll	a5,a3,0x2
 3d4:	97b6                	add	a5,a5,a3
 3d6:	078a                	sll	a5,a5,0x2
        res = (nominador2 * 100000) / denominador2;
 3d8:	02f4c4b3          	div	s1,s1,a5
        int justica_fim = res;
 3dc:	2481                	sext.w	s1,s1
        printf("justica : %de-05\n", justica_fim);
 3de:	85a6                	mv	a1,s1
 3e0:	00001517          	auipc	a0,0x1
 3e4:	9e850513          	add	a0,a0,-1560 # dc8 <malloc+0x1c4>
 3e8:	768000ef          	jal	b50 <printf>
        free(justicas);
 3ec:	856a                	mv	a0,s10
 3ee:	794000ef          	jal	b82 <free>

        //DESEMPENHO
        int desempenho = (overhead_fim + eficiencia_fim + vazao_norm + justica_fim);
 3f2:	019a85bb          	addw	a1,s5,s9
 3f6:	018585bb          	addw	a1,a1,s8
 3fa:	9da5                	addw	a1,a1,s1
        desempenho = desempenho >> 2;
        printf("desempenho: %de-05\n", desempenho);
 3fc:	4025d59b          	sraw	a1,a1,0x2
 400:	00001517          	auipc	a0,0x1
 404:	9e050513          	add	a0,a0,-1568 # de0 <malloc+0x1dc>
 408:	748000ef          	jal	b50 <printf>
    for (int i = 1; i <= 30; i++){
 40c:	2d85                	addw	s11,s11,1
 40e:	47fd                	li	a5,31
 410:	02fd8e63          	beq	s11,a5,44c <main+0x3d8>
        initialize_metrics();
 414:	39a000ef          	jal	7ae <initialize_metrics>
        t0_rodada = uptime_nolock();
 418:	3ae000ef          	jal	7c6 <uptime_nolock>
 41c:	8aaa                	mv	s5,a0
        uint X = (rand() % 9) + 6;
 41e:	c3bff0ef          	jal	58 <rand>
 422:	47a5                	li	a5,9
 424:	02f567bb          	remw	a5,a0,a5
 428:	2799                	addw	a5,a5,6
 42a:	00078a1b          	sext.w	s4,a5
        uint Y = 20 - X;
 42e:	4751                	li	a4,20
 430:	40f707bb          	subw	a5,a4,a5
 434:	f6f42423          	sw	a5,-152(s0)
        for (int j = 1; j < 21; j++){
 438:	4485                	li	s1,1
            if (index < 10) {
 43a:	49a5                	li	s3,9
                index_str[1] = (index - 10) + '0';
 43c:	03100c13          	li	s8,49
 440:	03000d13          	li	s10,48
            args[1] = index_str;
 444:	f7840913          	add	s2,s0,-136
                    if (ret == -1){
 448:	5cfd                	li	s9,-1
 44a:	b169                	j	d4 <main+0x60>
    }

    int t_final = uptime_nolock();
 44c:	37a000ef          	jal	7c6 <uptime_nolock>
    int variação_total = t_final - t0_total;
    printf("Tempo total usado para as 30 rodadas: %d\n", variação_total);
 450:	f5843783          	ld	a5,-168(s0)
 454:	40f505bb          	subw	a1,a0,a5
 458:	00001517          	auipc	a0,0x1
 45c:	9a050513          	add	a0,a0,-1632 # df8 <malloc+0x1f4>
 460:	6f0000ef          	jal	b50 <printf>
    return 0;
 464:	4501                	li	a0,0
 466:	70aa                	ld	ra,168(sp)
 468:	740a                	ld	s0,160(sp)
 46a:	64ea                	ld	s1,152(sp)
 46c:	694a                	ld	s2,144(sp)
 46e:	69aa                	ld	s3,136(sp)
 470:	6a0a                	ld	s4,128(sp)
 472:	7ae6                	ld	s5,120(sp)
 474:	7b46                	ld	s6,112(sp)
 476:	7ba6                	ld	s7,104(sp)
 478:	7c06                	ld	s8,96(sp)
 47a:	6ce6                	ld	s9,88(sp)
 47c:	6d46                	ld	s10,80(sp)
 47e:	6da6                	ld	s11,72(sp)
 480:	614d                	add	sp,sp,176
 482:	8082                	ret

0000000000000484 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 484:	1141                	add	sp,sp,-16
 486:	e406                	sd	ra,8(sp)
 488:	e022                	sd	s0,0(sp)
 48a:	0800                	add	s0,sp,16
  extern int main();
  main();
 48c:	be9ff0ef          	jal	74 <main>
  exit(0);
 490:	4501                	li	a0,0
 492:	25c000ef          	jal	6ee <exit>

0000000000000496 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 496:	1141                	add	sp,sp,-16
 498:	e422                	sd	s0,8(sp)
 49a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 49c:	87aa                	mv	a5,a0
 49e:	0585                	add	a1,a1,1
 4a0:	0785                	add	a5,a5,1
 4a2:	fff5c703          	lbu	a4,-1(a1)
 4a6:	fee78fa3          	sb	a4,-1(a5)
 4aa:	fb75                	bnez	a4,49e <strcpy+0x8>
    ;
  return os;
}
 4ac:	6422                	ld	s0,8(sp)
 4ae:	0141                	add	sp,sp,16
 4b0:	8082                	ret

00000000000004b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4b2:	1141                	add	sp,sp,-16
 4b4:	e422                	sd	s0,8(sp)
 4b6:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 4b8:	00054783          	lbu	a5,0(a0)
 4bc:	cb91                	beqz	a5,4d0 <strcmp+0x1e>
 4be:	0005c703          	lbu	a4,0(a1)
 4c2:	00f71763          	bne	a4,a5,4d0 <strcmp+0x1e>
    p++, q++;
 4c6:	0505                	add	a0,a0,1
 4c8:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 4ca:	00054783          	lbu	a5,0(a0)
 4ce:	fbe5                	bnez	a5,4be <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4d0:	0005c503          	lbu	a0,0(a1)
}
 4d4:	40a7853b          	subw	a0,a5,a0
 4d8:	6422                	ld	s0,8(sp)
 4da:	0141                	add	sp,sp,16
 4dc:	8082                	ret

00000000000004de <strlen>:

uint
strlen(const char *s)
{
 4de:	1141                	add	sp,sp,-16
 4e0:	e422                	sd	s0,8(sp)
 4e2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4e4:	00054783          	lbu	a5,0(a0)
 4e8:	cf91                	beqz	a5,504 <strlen+0x26>
 4ea:	0505                	add	a0,a0,1
 4ec:	87aa                	mv	a5,a0
 4ee:	86be                	mv	a3,a5
 4f0:	0785                	add	a5,a5,1
 4f2:	fff7c703          	lbu	a4,-1(a5)
 4f6:	ff65                	bnez	a4,4ee <strlen+0x10>
 4f8:	40a6853b          	subw	a0,a3,a0
 4fc:	2505                	addw	a0,a0,1
    ;
  return n;
}
 4fe:	6422                	ld	s0,8(sp)
 500:	0141                	add	sp,sp,16
 502:	8082                	ret
  for(n = 0; s[n]; n++)
 504:	4501                	li	a0,0
 506:	bfe5                	j	4fe <strlen+0x20>

0000000000000508 <memset>:

void*
memset(void *dst, int c, uint n)
{
 508:	1141                	add	sp,sp,-16
 50a:	e422                	sd	s0,8(sp)
 50c:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 50e:	ca19                	beqz	a2,524 <memset+0x1c>
 510:	87aa                	mv	a5,a0
 512:	1602                	sll	a2,a2,0x20
 514:	9201                	srl	a2,a2,0x20
 516:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 51a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 51e:	0785                	add	a5,a5,1
 520:	fee79de3          	bne	a5,a4,51a <memset+0x12>
  }
  return dst;
}
 524:	6422                	ld	s0,8(sp)
 526:	0141                	add	sp,sp,16
 528:	8082                	ret

000000000000052a <strchr>:

char*
strchr(const char *s, char c)
{
 52a:	1141                	add	sp,sp,-16
 52c:	e422                	sd	s0,8(sp)
 52e:	0800                	add	s0,sp,16
  for(; *s; s++)
 530:	00054783          	lbu	a5,0(a0)
 534:	cb99                	beqz	a5,54a <strchr+0x20>
    if(*s == c)
 536:	00f58763          	beq	a1,a5,544 <strchr+0x1a>
  for(; *s; s++)
 53a:	0505                	add	a0,a0,1
 53c:	00054783          	lbu	a5,0(a0)
 540:	fbfd                	bnez	a5,536 <strchr+0xc>
      return (char*)s;
  return 0;
 542:	4501                	li	a0,0
}
 544:	6422                	ld	s0,8(sp)
 546:	0141                	add	sp,sp,16
 548:	8082                	ret
  return 0;
 54a:	4501                	li	a0,0
 54c:	bfe5                	j	544 <strchr+0x1a>

000000000000054e <gets>:

char*
gets(char *buf, int max)
{
 54e:	711d                	add	sp,sp,-96
 550:	ec86                	sd	ra,88(sp)
 552:	e8a2                	sd	s0,80(sp)
 554:	e4a6                	sd	s1,72(sp)
 556:	e0ca                	sd	s2,64(sp)
 558:	fc4e                	sd	s3,56(sp)
 55a:	f852                	sd	s4,48(sp)
 55c:	f456                	sd	s5,40(sp)
 55e:	f05a                	sd	s6,32(sp)
 560:	ec5e                	sd	s7,24(sp)
 562:	1080                	add	s0,sp,96
 564:	8baa                	mv	s7,a0
 566:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 568:	892a                	mv	s2,a0
 56a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 56c:	4aa9                	li	s5,10
 56e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 570:	89a6                	mv	s3,s1
 572:	2485                	addw	s1,s1,1
 574:	0344d663          	bge	s1,s4,5a0 <gets+0x52>
    cc = read(0, &c, 1);
 578:	4605                	li	a2,1
 57a:	faf40593          	add	a1,s0,-81
 57e:	4501                	li	a0,0
 580:	186000ef          	jal	706 <read>
    if(cc < 1)
 584:	00a05e63          	blez	a0,5a0 <gets+0x52>
    buf[i++] = c;
 588:	faf44783          	lbu	a5,-81(s0)
 58c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 590:	01578763          	beq	a5,s5,59e <gets+0x50>
 594:	0905                	add	s2,s2,1
 596:	fd679de3          	bne	a5,s6,570 <gets+0x22>
  for(i=0; i+1 < max; ){
 59a:	89a6                	mv	s3,s1
 59c:	a011                	j	5a0 <gets+0x52>
 59e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5a0:	99de                	add	s3,s3,s7
 5a2:	00098023          	sb	zero,0(s3)
  return buf;
}
 5a6:	855e                	mv	a0,s7
 5a8:	60e6                	ld	ra,88(sp)
 5aa:	6446                	ld	s0,80(sp)
 5ac:	64a6                	ld	s1,72(sp)
 5ae:	6906                	ld	s2,64(sp)
 5b0:	79e2                	ld	s3,56(sp)
 5b2:	7a42                	ld	s4,48(sp)
 5b4:	7aa2                	ld	s5,40(sp)
 5b6:	7b02                	ld	s6,32(sp)
 5b8:	6be2                	ld	s7,24(sp)
 5ba:	6125                	add	sp,sp,96
 5bc:	8082                	ret

00000000000005be <stat>:

int
stat(const char *n, struct stat *st)
{
 5be:	1101                	add	sp,sp,-32
 5c0:	ec06                	sd	ra,24(sp)
 5c2:	e822                	sd	s0,16(sp)
 5c4:	e426                	sd	s1,8(sp)
 5c6:	e04a                	sd	s2,0(sp)
 5c8:	1000                	add	s0,sp,32
 5ca:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5cc:	4581                	li	a1,0
 5ce:	160000ef          	jal	72e <open>
  if(fd < 0)
 5d2:	02054163          	bltz	a0,5f4 <stat+0x36>
 5d6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5d8:	85ca                	mv	a1,s2
 5da:	16c000ef          	jal	746 <fstat>
 5de:	892a                	mv	s2,a0
  close(fd);
 5e0:	8526                	mv	a0,s1
 5e2:	134000ef          	jal	716 <close>
  return r;
}
 5e6:	854a                	mv	a0,s2
 5e8:	60e2                	ld	ra,24(sp)
 5ea:	6442                	ld	s0,16(sp)
 5ec:	64a2                	ld	s1,8(sp)
 5ee:	6902                	ld	s2,0(sp)
 5f0:	6105                	add	sp,sp,32
 5f2:	8082                	ret
    return -1;
 5f4:	597d                	li	s2,-1
 5f6:	bfc5                	j	5e6 <stat+0x28>

00000000000005f8 <atoi>:

int
atoi(const char *s)
{
 5f8:	1141                	add	sp,sp,-16
 5fa:	e422                	sd	s0,8(sp)
 5fc:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5fe:	00054683          	lbu	a3,0(a0)
 602:	fd06879b          	addw	a5,a3,-48
 606:	0ff7f793          	zext.b	a5,a5
 60a:	4625                	li	a2,9
 60c:	02f66863          	bltu	a2,a5,63c <atoi+0x44>
 610:	872a                	mv	a4,a0
  n = 0;
 612:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 614:	0705                	add	a4,a4,1
 616:	0025179b          	sllw	a5,a0,0x2
 61a:	9fa9                	addw	a5,a5,a0
 61c:	0017979b          	sllw	a5,a5,0x1
 620:	9fb5                	addw	a5,a5,a3
 622:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 626:	00074683          	lbu	a3,0(a4)
 62a:	fd06879b          	addw	a5,a3,-48
 62e:	0ff7f793          	zext.b	a5,a5
 632:	fef671e3          	bgeu	a2,a5,614 <atoi+0x1c>
  return n;
}
 636:	6422                	ld	s0,8(sp)
 638:	0141                	add	sp,sp,16
 63a:	8082                	ret
  n = 0;
 63c:	4501                	li	a0,0
 63e:	bfe5                	j	636 <atoi+0x3e>

0000000000000640 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 640:	1141                	add	sp,sp,-16
 642:	e422                	sd	s0,8(sp)
 644:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 646:	02b57463          	bgeu	a0,a1,66e <memmove+0x2e>
    while(n-- > 0)
 64a:	00c05f63          	blez	a2,668 <memmove+0x28>
 64e:	1602                	sll	a2,a2,0x20
 650:	9201                	srl	a2,a2,0x20
 652:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 656:	872a                	mv	a4,a0
      *dst++ = *src++;
 658:	0585                	add	a1,a1,1
 65a:	0705                	add	a4,a4,1
 65c:	fff5c683          	lbu	a3,-1(a1)
 660:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 664:	fee79ae3          	bne	a5,a4,658 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 668:	6422                	ld	s0,8(sp)
 66a:	0141                	add	sp,sp,16
 66c:	8082                	ret
    dst += n;
 66e:	00c50733          	add	a4,a0,a2
    src += n;
 672:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 674:	fec05ae3          	blez	a2,668 <memmove+0x28>
 678:	fff6079b          	addw	a5,a2,-1
 67c:	1782                	sll	a5,a5,0x20
 67e:	9381                	srl	a5,a5,0x20
 680:	fff7c793          	not	a5,a5
 684:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 686:	15fd                	add	a1,a1,-1
 688:	177d                	add	a4,a4,-1
 68a:	0005c683          	lbu	a3,0(a1)
 68e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 692:	fee79ae3          	bne	a5,a4,686 <memmove+0x46>
 696:	bfc9                	j	668 <memmove+0x28>

0000000000000698 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 698:	1141                	add	sp,sp,-16
 69a:	e422                	sd	s0,8(sp)
 69c:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 69e:	ca05                	beqz	a2,6ce <memcmp+0x36>
 6a0:	fff6069b          	addw	a3,a2,-1
 6a4:	1682                	sll	a3,a3,0x20
 6a6:	9281                	srl	a3,a3,0x20
 6a8:	0685                	add	a3,a3,1
 6aa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6ac:	00054783          	lbu	a5,0(a0)
 6b0:	0005c703          	lbu	a4,0(a1)
 6b4:	00e79863          	bne	a5,a4,6c4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6b8:	0505                	add	a0,a0,1
    p2++;
 6ba:	0585                	add	a1,a1,1
  while (n-- > 0) {
 6bc:	fed518e3          	bne	a0,a3,6ac <memcmp+0x14>
  }
  return 0;
 6c0:	4501                	li	a0,0
 6c2:	a019                	j	6c8 <memcmp+0x30>
      return *p1 - *p2;
 6c4:	40e7853b          	subw	a0,a5,a4
}
 6c8:	6422                	ld	s0,8(sp)
 6ca:	0141                	add	sp,sp,16
 6cc:	8082                	ret
  return 0;
 6ce:	4501                	li	a0,0
 6d0:	bfe5                	j	6c8 <memcmp+0x30>

00000000000006d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6d2:	1141                	add	sp,sp,-16
 6d4:	e406                	sd	ra,8(sp)
 6d6:	e022                	sd	s0,0(sp)
 6d8:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 6da:	f67ff0ef          	jal	640 <memmove>
}
 6de:	60a2                	ld	ra,8(sp)
 6e0:	6402                	ld	s0,0(sp)
 6e2:	0141                	add	sp,sp,16
 6e4:	8082                	ret

00000000000006e6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6e6:	4885                	li	a7,1
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <exit>:
.global exit
exit:
 li a7, SYS_exit
 6ee:	4889                	li	a7,2
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6f6:	488d                	li	a7,3
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6fe:	4891                	li	a7,4
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <read>:
.global read
read:
 li a7, SYS_read
 706:	4895                	li	a7,5
 ecall
 708:	00000073          	ecall
 ret
 70c:	8082                	ret

000000000000070e <write>:
.global write
write:
 li a7, SYS_write
 70e:	48c1                	li	a7,16
 ecall
 710:	00000073          	ecall
 ret
 714:	8082                	ret

0000000000000716 <close>:
.global close
close:
 li a7, SYS_close
 716:	48d5                	li	a7,21
 ecall
 718:	00000073          	ecall
 ret
 71c:	8082                	ret

000000000000071e <kill>:
.global kill
kill:
 li a7, SYS_kill
 71e:	4899                	li	a7,6
 ecall
 720:	00000073          	ecall
 ret
 724:	8082                	ret

0000000000000726 <exec>:
.global exec
exec:
 li a7, SYS_exec
 726:	489d                	li	a7,7
 ecall
 728:	00000073          	ecall
 ret
 72c:	8082                	ret

000000000000072e <open>:
.global open
open:
 li a7, SYS_open
 72e:	48bd                	li	a7,15
 ecall
 730:	00000073          	ecall
 ret
 734:	8082                	ret

0000000000000736 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 736:	48c5                	li	a7,17
 ecall
 738:	00000073          	ecall
 ret
 73c:	8082                	ret

000000000000073e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 73e:	48c9                	li	a7,18
 ecall
 740:	00000073          	ecall
 ret
 744:	8082                	ret

0000000000000746 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 746:	48a1                	li	a7,8
 ecall
 748:	00000073          	ecall
 ret
 74c:	8082                	ret

000000000000074e <link>:
.global link
link:
 li a7, SYS_link
 74e:	48cd                	li	a7,19
 ecall
 750:	00000073          	ecall
 ret
 754:	8082                	ret

0000000000000756 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 756:	48d1                	li	a7,20
 ecall
 758:	00000073          	ecall
 ret
 75c:	8082                	ret

000000000000075e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 75e:	48a5                	li	a7,9
 ecall
 760:	00000073          	ecall
 ret
 764:	8082                	ret

0000000000000766 <dup>:
.global dup
dup:
 li a7, SYS_dup
 766:	48a9                	li	a7,10
 ecall
 768:	00000073          	ecall
 ret
 76c:	8082                	ret

000000000000076e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 76e:	48ad                	li	a7,11
 ecall
 770:	00000073          	ecall
 ret
 774:	8082                	ret

0000000000000776 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 776:	48b1                	li	a7,12
 ecall
 778:	00000073          	ecall
 ret
 77c:	8082                	ret

000000000000077e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 77e:	48b5                	li	a7,13
 ecall
 780:	00000073          	ecall
 ret
 784:	8082                	ret

0000000000000786 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 786:	48b9                	li	a7,14
 ecall
 788:	00000073          	ecall
 ret
 78c:	8082                	ret

000000000000078e <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
 78e:	48d9                	li	a7,22
 ecall
 790:	00000073          	ecall
 ret
 794:	8082                	ret

0000000000000796 <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
 796:	48dd                	li	a7,23
 ecall
 798:	00000073          	ecall
 ret
 79c:	8082                	ret

000000000000079e <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
 79e:	48e1                	li	a7,24
 ecall
 7a0:	00000073          	ecall
 ret
 7a4:	8082                	ret

00000000000007a6 <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
 7a6:	48e5                	li	a7,25
 ecall
 7a8:	00000073          	ecall
 ret
 7ac:	8082                	ret

00000000000007ae <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
 7ae:	48e9                	li	a7,26
 ecall
 7b0:	00000073          	ecall
 ret
 7b4:	8082                	ret

00000000000007b6 <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
 7b6:	48ed                	li	a7,27
 ecall
 7b8:	00000073          	ecall
 ret
 7bc:	8082                	ret

00000000000007be <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
 7be:	48f1                	li	a7,28
 ecall
 7c0:	00000073          	ecall
 ret
 7c4:	8082                	ret

00000000000007c6 <uptime_nolock>:
.global uptime_nolock
uptime_nolock:
 li a7, SYS_uptime_nolock
 7c6:	48f5                	li	a7,29
 ecall
 7c8:	00000073          	ecall
 ret
 7cc:	8082                	ret

00000000000007ce <set_type>:
.global set_type
set_type:
 li a7, SYS_set_type
 7ce:	48f9                	li	a7,30
 ecall
 7d0:	00000073          	ecall
 ret
 7d4:	8082                	ret

00000000000007d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7d6:	1101                	add	sp,sp,-32
 7d8:	ec06                	sd	ra,24(sp)
 7da:	e822                	sd	s0,16(sp)
 7dc:	1000                	add	s0,sp,32
 7de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7e2:	4605                	li	a2,1
 7e4:	fef40593          	add	a1,s0,-17
 7e8:	f27ff0ef          	jal	70e <write>
}
 7ec:	60e2                	ld	ra,24(sp)
 7ee:	6442                	ld	s0,16(sp)
 7f0:	6105                	add	sp,sp,32
 7f2:	8082                	ret

00000000000007f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7f4:	7139                	add	sp,sp,-64
 7f6:	fc06                	sd	ra,56(sp)
 7f8:	f822                	sd	s0,48(sp)
 7fa:	f426                	sd	s1,40(sp)
 7fc:	f04a                	sd	s2,32(sp)
 7fe:	ec4e                	sd	s3,24(sp)
 800:	0080                	add	s0,sp,64
 802:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 804:	c299                	beqz	a3,80a <printint+0x16>
 806:	0805c763          	bltz	a1,894 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 80a:	2581                	sext.w	a1,a1
  neg = 0;
 80c:	4881                	li	a7,0
 80e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 812:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 814:	2601                	sext.w	a2,a2
 816:	00000517          	auipc	a0,0x0
 81a:	61a50513          	add	a0,a0,1562 # e30 <digits>
 81e:	883a                	mv	a6,a4
 820:	2705                	addw	a4,a4,1
 822:	02c5f7bb          	remuw	a5,a1,a2
 826:	1782                	sll	a5,a5,0x20
 828:	9381                	srl	a5,a5,0x20
 82a:	97aa                	add	a5,a5,a0
 82c:	0007c783          	lbu	a5,0(a5)
 830:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 834:	0005879b          	sext.w	a5,a1
 838:	02c5d5bb          	divuw	a1,a1,a2
 83c:	0685                	add	a3,a3,1
 83e:	fec7f0e3          	bgeu	a5,a2,81e <printint+0x2a>
  if(neg)
 842:	00088c63          	beqz	a7,85a <printint+0x66>
    buf[i++] = '-';
 846:	fd070793          	add	a5,a4,-48
 84a:	00878733          	add	a4,a5,s0
 84e:	02d00793          	li	a5,45
 852:	fef70823          	sb	a5,-16(a4)
 856:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 85a:	02e05663          	blez	a4,886 <printint+0x92>
 85e:	fc040793          	add	a5,s0,-64
 862:	00e78933          	add	s2,a5,a4
 866:	fff78993          	add	s3,a5,-1
 86a:	99ba                	add	s3,s3,a4
 86c:	377d                	addw	a4,a4,-1
 86e:	1702                	sll	a4,a4,0x20
 870:	9301                	srl	a4,a4,0x20
 872:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 876:	fff94583          	lbu	a1,-1(s2)
 87a:	8526                	mv	a0,s1
 87c:	f5bff0ef          	jal	7d6 <putc>
  while(--i >= 0)
 880:	197d                	add	s2,s2,-1
 882:	ff391ae3          	bne	s2,s3,876 <printint+0x82>
}
 886:	70e2                	ld	ra,56(sp)
 888:	7442                	ld	s0,48(sp)
 88a:	74a2                	ld	s1,40(sp)
 88c:	7902                	ld	s2,32(sp)
 88e:	69e2                	ld	s3,24(sp)
 890:	6121                	add	sp,sp,64
 892:	8082                	ret
    x = -xx;
 894:	40b005bb          	negw	a1,a1
    neg = 1;
 898:	4885                	li	a7,1
    x = -xx;
 89a:	bf95                	j	80e <printint+0x1a>

000000000000089c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 89c:	711d                	add	sp,sp,-96
 89e:	ec86                	sd	ra,88(sp)
 8a0:	e8a2                	sd	s0,80(sp)
 8a2:	e4a6                	sd	s1,72(sp)
 8a4:	e0ca                	sd	s2,64(sp)
 8a6:	fc4e                	sd	s3,56(sp)
 8a8:	f852                	sd	s4,48(sp)
 8aa:	f456                	sd	s5,40(sp)
 8ac:	f05a                	sd	s6,32(sp)
 8ae:	ec5e                	sd	s7,24(sp)
 8b0:	e862                	sd	s8,16(sp)
 8b2:	e466                	sd	s9,8(sp)
 8b4:	e06a                	sd	s10,0(sp)
 8b6:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8b8:	0005c903          	lbu	s2,0(a1)
 8bc:	24090763          	beqz	s2,b0a <vprintf+0x26e>
 8c0:	8b2a                	mv	s6,a0
 8c2:	8a2e                	mv	s4,a1
 8c4:	8bb2                	mv	s7,a2
  state = 0;
 8c6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 8c8:	4481                	li	s1,0
 8ca:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 8cc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 8d0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 8d4:	06c00c93          	li	s9,108
 8d8:	a005                	j	8f8 <vprintf+0x5c>
        putc(fd, c0);
 8da:	85ca                	mv	a1,s2
 8dc:	855a                	mv	a0,s6
 8de:	ef9ff0ef          	jal	7d6 <putc>
 8e2:	a019                	j	8e8 <vprintf+0x4c>
    } else if(state == '%'){
 8e4:	03598263          	beq	s3,s5,908 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 8e8:	2485                	addw	s1,s1,1
 8ea:	8726                	mv	a4,s1
 8ec:	009a07b3          	add	a5,s4,s1
 8f0:	0007c903          	lbu	s2,0(a5)
 8f4:	20090b63          	beqz	s2,b0a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 8f8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8fc:	fe0994e3          	bnez	s3,8e4 <vprintf+0x48>
      if(c0 == '%'){
 900:	fd579de3          	bne	a5,s5,8da <vprintf+0x3e>
        state = '%';
 904:	89be                	mv	s3,a5
 906:	b7cd                	j	8e8 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 908:	c7c9                	beqz	a5,992 <vprintf+0xf6>
 90a:	00ea06b3          	add	a3,s4,a4
 90e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 912:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 914:	c681                	beqz	a3,91c <vprintf+0x80>
 916:	9752                	add	a4,a4,s4
 918:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 91c:	03878f63          	beq	a5,s8,95a <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 920:	05978963          	beq	a5,s9,972 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 924:	07500713          	li	a4,117
 928:	0ee78363          	beq	a5,a4,a0e <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 92c:	07800713          	li	a4,120
 930:	12e78563          	beq	a5,a4,a5a <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 934:	07000713          	li	a4,112
 938:	14e78a63          	beq	a5,a4,a8c <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 93c:	07300713          	li	a4,115
 940:	18e78863          	beq	a5,a4,ad0 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 944:	02500713          	li	a4,37
 948:	04e79563          	bne	a5,a4,992 <vprintf+0xf6>
        putc(fd, '%');
 94c:	02500593          	li	a1,37
 950:	855a                	mv	a0,s6
 952:	e85ff0ef          	jal	7d6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 956:	4981                	li	s3,0
 958:	bf41                	j	8e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 95a:	008b8913          	add	s2,s7,8
 95e:	4685                	li	a3,1
 960:	4629                	li	a2,10
 962:	000ba583          	lw	a1,0(s7)
 966:	855a                	mv	a0,s6
 968:	e8dff0ef          	jal	7f4 <printint>
 96c:	8bca                	mv	s7,s2
      state = 0;
 96e:	4981                	li	s3,0
 970:	bfa5                	j	8e8 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 972:	06400793          	li	a5,100
 976:	02f68963          	beq	a3,a5,9a8 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 97a:	06c00793          	li	a5,108
 97e:	04f68263          	beq	a3,a5,9c2 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 982:	07500793          	li	a5,117
 986:	0af68063          	beq	a3,a5,a26 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 98a:	07800793          	li	a5,120
 98e:	0ef68263          	beq	a3,a5,a72 <vprintf+0x1d6>
        putc(fd, '%');
 992:	02500593          	li	a1,37
 996:	855a                	mv	a0,s6
 998:	e3fff0ef          	jal	7d6 <putc>
        putc(fd, c0);
 99c:	85ca                	mv	a1,s2
 99e:	855a                	mv	a0,s6
 9a0:	e37ff0ef          	jal	7d6 <putc>
      state = 0;
 9a4:	4981                	li	s3,0
 9a6:	b789                	j	8e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9a8:	008b8913          	add	s2,s7,8
 9ac:	4685                	li	a3,1
 9ae:	4629                	li	a2,10
 9b0:	000ba583          	lw	a1,0(s7)
 9b4:	855a                	mv	a0,s6
 9b6:	e3fff0ef          	jal	7f4 <printint>
        i += 1;
 9ba:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 9bc:	8bca                	mv	s7,s2
      state = 0;
 9be:	4981                	li	s3,0
        i += 1;
 9c0:	b725                	j	8e8 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9c2:	06400793          	li	a5,100
 9c6:	02f60763          	beq	a2,a5,9f4 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 9ca:	07500793          	li	a5,117
 9ce:	06f60963          	beq	a2,a5,a40 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 9d2:	07800793          	li	a5,120
 9d6:	faf61ee3          	bne	a2,a5,992 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9da:	008b8913          	add	s2,s7,8
 9de:	4681                	li	a3,0
 9e0:	4641                	li	a2,16
 9e2:	000ba583          	lw	a1,0(s7)
 9e6:	855a                	mv	a0,s6
 9e8:	e0dff0ef          	jal	7f4 <printint>
        i += 2;
 9ec:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 9ee:	8bca                	mv	s7,s2
      state = 0;
 9f0:	4981                	li	s3,0
        i += 2;
 9f2:	bddd                	j	8e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9f4:	008b8913          	add	s2,s7,8
 9f8:	4685                	li	a3,1
 9fa:	4629                	li	a2,10
 9fc:	000ba583          	lw	a1,0(s7)
 a00:	855a                	mv	a0,s6
 a02:	df3ff0ef          	jal	7f4 <printint>
        i += 2;
 a06:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a08:	8bca                	mv	s7,s2
      state = 0;
 a0a:	4981                	li	s3,0
        i += 2;
 a0c:	bdf1                	j	8e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 a0e:	008b8913          	add	s2,s7,8
 a12:	4681                	li	a3,0
 a14:	4629                	li	a2,10
 a16:	000ba583          	lw	a1,0(s7)
 a1a:	855a                	mv	a0,s6
 a1c:	dd9ff0ef          	jal	7f4 <printint>
 a20:	8bca                	mv	s7,s2
      state = 0;
 a22:	4981                	li	s3,0
 a24:	b5d1                	j	8e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a26:	008b8913          	add	s2,s7,8
 a2a:	4681                	li	a3,0
 a2c:	4629                	li	a2,10
 a2e:	000ba583          	lw	a1,0(s7)
 a32:	855a                	mv	a0,s6
 a34:	dc1ff0ef          	jal	7f4 <printint>
        i += 1;
 a38:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a3a:	8bca                	mv	s7,s2
      state = 0;
 a3c:	4981                	li	s3,0
        i += 1;
 a3e:	b56d                	j	8e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a40:	008b8913          	add	s2,s7,8
 a44:	4681                	li	a3,0
 a46:	4629                	li	a2,10
 a48:	000ba583          	lw	a1,0(s7)
 a4c:	855a                	mv	a0,s6
 a4e:	da7ff0ef          	jal	7f4 <printint>
        i += 2;
 a52:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a54:	8bca                	mv	s7,s2
      state = 0;
 a56:	4981                	li	s3,0
        i += 2;
 a58:	bd41                	j	8e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 a5a:	008b8913          	add	s2,s7,8
 a5e:	4681                	li	a3,0
 a60:	4641                	li	a2,16
 a62:	000ba583          	lw	a1,0(s7)
 a66:	855a                	mv	a0,s6
 a68:	d8dff0ef          	jal	7f4 <printint>
 a6c:	8bca                	mv	s7,s2
      state = 0;
 a6e:	4981                	li	s3,0
 a70:	bda5                	j	8e8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a72:	008b8913          	add	s2,s7,8
 a76:	4681                	li	a3,0
 a78:	4641                	li	a2,16
 a7a:	000ba583          	lw	a1,0(s7)
 a7e:	855a                	mv	a0,s6
 a80:	d75ff0ef          	jal	7f4 <printint>
        i += 1;
 a84:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a86:	8bca                	mv	s7,s2
      state = 0;
 a88:	4981                	li	s3,0
        i += 1;
 a8a:	bdb9                	j	8e8 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 a8c:	008b8d13          	add	s10,s7,8
 a90:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a94:	03000593          	li	a1,48
 a98:	855a                	mv	a0,s6
 a9a:	d3dff0ef          	jal	7d6 <putc>
  putc(fd, 'x');
 a9e:	07800593          	li	a1,120
 aa2:	855a                	mv	a0,s6
 aa4:	d33ff0ef          	jal	7d6 <putc>
 aa8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 aaa:	00000b97          	auipc	s7,0x0
 aae:	386b8b93          	add	s7,s7,902 # e30 <digits>
 ab2:	03c9d793          	srl	a5,s3,0x3c
 ab6:	97de                	add	a5,a5,s7
 ab8:	0007c583          	lbu	a1,0(a5)
 abc:	855a                	mv	a0,s6
 abe:	d19ff0ef          	jal	7d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 ac2:	0992                	sll	s3,s3,0x4
 ac4:	397d                	addw	s2,s2,-1
 ac6:	fe0916e3          	bnez	s2,ab2 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 aca:	8bea                	mv	s7,s10
      state = 0;
 acc:	4981                	li	s3,0
 ace:	bd29                	j	8e8 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 ad0:	008b8993          	add	s3,s7,8
 ad4:	000bb903          	ld	s2,0(s7)
 ad8:	00090f63          	beqz	s2,af6 <vprintf+0x25a>
        for(; *s; s++)
 adc:	00094583          	lbu	a1,0(s2)
 ae0:	c195                	beqz	a1,b04 <vprintf+0x268>
          putc(fd, *s);
 ae2:	855a                	mv	a0,s6
 ae4:	cf3ff0ef          	jal	7d6 <putc>
        for(; *s; s++)
 ae8:	0905                	add	s2,s2,1
 aea:	00094583          	lbu	a1,0(s2)
 aee:	f9f5                	bnez	a1,ae2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 af0:	8bce                	mv	s7,s3
      state = 0;
 af2:	4981                	li	s3,0
 af4:	bbd5                	j	8e8 <vprintf+0x4c>
          s = "(null)";
 af6:	00000917          	auipc	s2,0x0
 afa:	33290913          	add	s2,s2,818 # e28 <malloc+0x224>
        for(; *s; s++)
 afe:	02800593          	li	a1,40
 b02:	b7c5                	j	ae2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b04:	8bce                	mv	s7,s3
      state = 0;
 b06:	4981                	li	s3,0
 b08:	b3c5                	j	8e8 <vprintf+0x4c>
    }
  }
}
 b0a:	60e6                	ld	ra,88(sp)
 b0c:	6446                	ld	s0,80(sp)
 b0e:	64a6                	ld	s1,72(sp)
 b10:	6906                	ld	s2,64(sp)
 b12:	79e2                	ld	s3,56(sp)
 b14:	7a42                	ld	s4,48(sp)
 b16:	7aa2                	ld	s5,40(sp)
 b18:	7b02                	ld	s6,32(sp)
 b1a:	6be2                	ld	s7,24(sp)
 b1c:	6c42                	ld	s8,16(sp)
 b1e:	6ca2                	ld	s9,8(sp)
 b20:	6d02                	ld	s10,0(sp)
 b22:	6125                	add	sp,sp,96
 b24:	8082                	ret

0000000000000b26 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b26:	715d                	add	sp,sp,-80
 b28:	ec06                	sd	ra,24(sp)
 b2a:	e822                	sd	s0,16(sp)
 b2c:	1000                	add	s0,sp,32
 b2e:	e010                	sd	a2,0(s0)
 b30:	e414                	sd	a3,8(s0)
 b32:	e818                	sd	a4,16(s0)
 b34:	ec1c                	sd	a5,24(s0)
 b36:	03043023          	sd	a6,32(s0)
 b3a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b3e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b42:	8622                	mv	a2,s0
 b44:	d59ff0ef          	jal	89c <vprintf>
}
 b48:	60e2                	ld	ra,24(sp)
 b4a:	6442                	ld	s0,16(sp)
 b4c:	6161                	add	sp,sp,80
 b4e:	8082                	ret

0000000000000b50 <printf>:

void
printf(const char *fmt, ...)
{
 b50:	711d                	add	sp,sp,-96
 b52:	ec06                	sd	ra,24(sp)
 b54:	e822                	sd	s0,16(sp)
 b56:	1000                	add	s0,sp,32
 b58:	e40c                	sd	a1,8(s0)
 b5a:	e810                	sd	a2,16(s0)
 b5c:	ec14                	sd	a3,24(s0)
 b5e:	f018                	sd	a4,32(s0)
 b60:	f41c                	sd	a5,40(s0)
 b62:	03043823          	sd	a6,48(s0)
 b66:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b6a:	00840613          	add	a2,s0,8
 b6e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b72:	85aa                	mv	a1,a0
 b74:	4505                	li	a0,1
 b76:	d27ff0ef          	jal	89c <vprintf>
}
 b7a:	60e2                	ld	ra,24(sp)
 b7c:	6442                	ld	s0,16(sp)
 b7e:	6125                	add	sp,sp,96
 b80:	8082                	ret

0000000000000b82 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b82:	1141                	add	sp,sp,-16
 b84:	e422                	sd	s0,8(sp)
 b86:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b88:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b8c:	00000797          	auipc	a5,0x0
 b90:	4847b783          	ld	a5,1156(a5) # 1010 <freep>
 b94:	a02d                	j	bbe <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b96:	4618                	lw	a4,8(a2)
 b98:	9f2d                	addw	a4,a4,a1
 b9a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b9e:	6398                	ld	a4,0(a5)
 ba0:	6310                	ld	a2,0(a4)
 ba2:	a83d                	j	be0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ba4:	ff852703          	lw	a4,-8(a0)
 ba8:	9f31                	addw	a4,a4,a2
 baa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bac:	ff053683          	ld	a3,-16(a0)
 bb0:	a091                	j	bf4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bb2:	6398                	ld	a4,0(a5)
 bb4:	00e7e463          	bltu	a5,a4,bbc <free+0x3a>
 bb8:	00e6ea63          	bltu	a3,a4,bcc <free+0x4a>
{
 bbc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bbe:	fed7fae3          	bgeu	a5,a3,bb2 <free+0x30>
 bc2:	6398                	ld	a4,0(a5)
 bc4:	00e6e463          	bltu	a3,a4,bcc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bc8:	fee7eae3          	bltu	a5,a4,bbc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 bcc:	ff852583          	lw	a1,-8(a0)
 bd0:	6390                	ld	a2,0(a5)
 bd2:	02059813          	sll	a6,a1,0x20
 bd6:	01c85713          	srl	a4,a6,0x1c
 bda:	9736                	add	a4,a4,a3
 bdc:	fae60de3          	beq	a2,a4,b96 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 be0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 be4:	4790                	lw	a2,8(a5)
 be6:	02061593          	sll	a1,a2,0x20
 bea:	01c5d713          	srl	a4,a1,0x1c
 bee:	973e                	add	a4,a4,a5
 bf0:	fae68ae3          	beq	a3,a4,ba4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 bf4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bf6:	00000717          	auipc	a4,0x0
 bfa:	40f73d23          	sd	a5,1050(a4) # 1010 <freep>
}
 bfe:	6422                	ld	s0,8(sp)
 c00:	0141                	add	sp,sp,16
 c02:	8082                	ret

0000000000000c04 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c04:	7139                	add	sp,sp,-64
 c06:	fc06                	sd	ra,56(sp)
 c08:	f822                	sd	s0,48(sp)
 c0a:	f426                	sd	s1,40(sp)
 c0c:	f04a                	sd	s2,32(sp)
 c0e:	ec4e                	sd	s3,24(sp)
 c10:	e852                	sd	s4,16(sp)
 c12:	e456                	sd	s5,8(sp)
 c14:	e05a                	sd	s6,0(sp)
 c16:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c18:	02051493          	sll	s1,a0,0x20
 c1c:	9081                	srl	s1,s1,0x20
 c1e:	04bd                	add	s1,s1,15
 c20:	8091                	srl	s1,s1,0x4
 c22:	0014899b          	addw	s3,s1,1
 c26:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 c28:	00000517          	auipc	a0,0x0
 c2c:	3e853503          	ld	a0,1000(a0) # 1010 <freep>
 c30:	c515                	beqz	a0,c5c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c32:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c34:	4798                	lw	a4,8(a5)
 c36:	02977f63          	bgeu	a4,s1,c74 <malloc+0x70>
  if(nu < 4096)
 c3a:	8a4e                	mv	s4,s3
 c3c:	0009871b          	sext.w	a4,s3
 c40:	6685                	lui	a3,0x1
 c42:	00d77363          	bgeu	a4,a3,c48 <malloc+0x44>
 c46:	6a05                	lui	s4,0x1
 c48:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c4c:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c50:	00000917          	auipc	s2,0x0
 c54:	3c090913          	add	s2,s2,960 # 1010 <freep>
  if(p == (char*)-1)
 c58:	5afd                	li	s5,-1
 c5a:	a885                	j	cca <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 c5c:	00000797          	auipc	a5,0x0
 c60:	3c478793          	add	a5,a5,964 # 1020 <base>
 c64:	00000717          	auipc	a4,0x0
 c68:	3af73623          	sd	a5,940(a4) # 1010 <freep>
 c6c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c6e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c72:	b7e1                	j	c3a <malloc+0x36>
      if(p->s.size == nunits)
 c74:	02e48c63          	beq	s1,a4,cac <malloc+0xa8>
        p->s.size -= nunits;
 c78:	4137073b          	subw	a4,a4,s3
 c7c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c7e:	02071693          	sll	a3,a4,0x20
 c82:	01c6d713          	srl	a4,a3,0x1c
 c86:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c88:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c8c:	00000717          	auipc	a4,0x0
 c90:	38a73223          	sd	a0,900(a4) # 1010 <freep>
      return (void*)(p + 1);
 c94:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c98:	70e2                	ld	ra,56(sp)
 c9a:	7442                	ld	s0,48(sp)
 c9c:	74a2                	ld	s1,40(sp)
 c9e:	7902                	ld	s2,32(sp)
 ca0:	69e2                	ld	s3,24(sp)
 ca2:	6a42                	ld	s4,16(sp)
 ca4:	6aa2                	ld	s5,8(sp)
 ca6:	6b02                	ld	s6,0(sp)
 ca8:	6121                	add	sp,sp,64
 caa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 cac:	6398                	ld	a4,0(a5)
 cae:	e118                	sd	a4,0(a0)
 cb0:	bff1                	j	c8c <malloc+0x88>
  hp->s.size = nu;
 cb2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cb6:	0541                	add	a0,a0,16
 cb8:	ecbff0ef          	jal	b82 <free>
  return freep;
 cbc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cc0:	dd61                	beqz	a0,c98 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cc2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cc4:	4798                	lw	a4,8(a5)
 cc6:	fa9777e3          	bgeu	a4,s1,c74 <malloc+0x70>
    if(p == freep)
 cca:	00093703          	ld	a4,0(s2)
 cce:	853e                	mv	a0,a5
 cd0:	fef719e3          	bne	a4,a5,cc2 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 cd4:	8552                	mv	a0,s4
 cd6:	aa1ff0ef          	jal	776 <sbrk>
  if(p == (char*)-1)
 cda:	fd551ce3          	bne	a0,s5,cb2 <malloc+0xae>
        return 0;
 cde:	4501                	li	a0,0
 ce0:	bf65                	j	c98 <malloc+0x94>
