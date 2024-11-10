#include "kernel/types.h"
#include "kernel/param.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"


//cópia do grind.c
int
do_rand(unsigned long *ctx)
{
    long hi, lo, x;

    x = (*ctx % 0x7ffffffe) + 1;
    hi = x / 127773;
    lo = x % 127773;
    x = 16807 * lo - 2836 * hi;
    if (x < 0)
        x += 0x7fffffff;
    x--;
    *ctx = x;
    return (x);
}

unsigned long rand_next = 7;

int
rand(void)
{
    return (do_rand(&rand_next));
}


int main(){
    //30 rodadas
    int  t0_rodada, tempo_atual;
    char *args[3];

    int pipe_eficiencia[2];
    int pipe_overhead[2];

    pipe(pipe_eficiencia);
    pipe(pipe_overhead);
    
    //PIPE: EFICIENCIA
    int temp_int = pipe_eficiencia[1];
    char temp_efici[10];
    int i = 0;
    do {
        temp_efici[i++] = temp_int % 10 + '0';   // próximo digito
    } while ((temp_int /= 10) > 0);
    temp_efici[i] = '\0';
    args[1] = temp_efici;

    //PIPE: OVERHEAD
    temp_int = pipe_overhead[1];
    char temp_overh[10];
    i = 0;
    do {
        temp_overh[i++] = temp_int % 10 + '0';   // próximo digito
    } while ((temp_int /= 10) > 0);
    temp_overh[i] = '\0';
    args[2] = temp_overh;


    for (i = 1; i <= 30; i++){
        t0_rodada = uptime();
        uint X = (rand() % 9) + 6;
        uint Y = 20 - X;
        //int processos[20];
        int pid;
        int ret;
        for (int j = 1; j < 21; j++){
            if (j <= X){
                //CPU-BOUND
                args[0] = "graphs";
                pid = fork();

                if (pid == 0){ //filho
                    ret = exec("graphs", args);
                    if (ret == -1){
                        printf("erro ao executar graphs.c\n");
                        exit(1);
                    }
                } else {       //pai
                    //processos[j-1] = pid;
                }
            } else {
                //IO-BOUND
                args[0] = "rows";
                pid = fork();
                if (pid == 0){ //filho
                    ret = exec("rows", args);
                    if (ret == -1){
                        printf("erro ao executar rows.c\n");
                        exit(1);
                    }
                } else {       //pai
                    //processos[j-1] = pid;
                }
            }
        }

        int proc;
        int *terminos = malloc(20 * sizeof(int));
        for (int j = 0; j < 20; j++){
            proc = wait(0);
            if (proc == -1){
                printf("pocesso falhou");
            } else {
                tempo_atual = uptime();
                terminos[j] = (tempo_atual - t0_rodada);
            }
        }


        tempo_atual = uptime();
        printf("RODADA %d ======================\n", i);

        // VAZÃO
        for (int j = 0; j < 20; j++){
            for (int k = j+1; k < 20; k++){
                if (terminos[k] < terminos[j]){
                    int temp = terminos[k];
                    terminos[j] = terminos[k];
                    terminos[k] = temp;
                }
            }
        }

        int *vazoes = malloc(50 * sizeof(int));
        for (int j = 0; j < 50; j++){
            vazoes[j] = 0;
        }
        int index = 0;
        int segundo_atual = 0;
        while (index < 20){
            if (10 * segundo_atual >= terminos[index]){
                index += 1;
                vazoes[segundo_atual] += 1;
            } else {
                segundo_atual += 1;
            }
        }

        //pegando max e min
        int lim = segundo_atual;
        int vazao_max = -10;
        int vazao_min = 10000;
        for (int j = 0; j <= lim; j++){
            if (vazoes[j] < vazao_min) {
                vazao_min = vazoes[j];
            }
            if (vazoes[j] > vazao_max) {
                vazao_max = vazoes[j];
            }
        }

        //normalizando
        int vazao_media = (20 * 1000) / lim;
        vazao_max *= 1000;
        vazao_min *= 1000;

        int nominador = vazao_media - vazao_min;
        int denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero

        int res = 1000 - (nominador * 1000 / denominador);
        int vazao_norm = res % 1000; //o valor é sempre de 0-1, não faz sentido pegar o valor maior e 1
        printf("vazao normalizada: %de-03\n", vazao_norm);


        //ele perdia o valor de vazao_norm depois de ler o pipe, não sei o porque, mas ele n perde se for uma string
        char vazao_str[10];
        int k = 0;
        do {
            vazao_str[k++] = vazao_norm % 10 + '0';   // próximo digito
        } while ((vazao_norm /= 10) > 0);
        vazao_str[k] = '\0';
        free(terminos);
        free(vazoes);
        

        // EFICIENCIA DO SISTEMA DE ARQUIVOS, lembrando que só IO-BOUND tem essa métrica
        int *eficiencias = malloc(Y * sizeof(int));
        
        
        //lendo os dados do pipe
        for (int j = 0; j < Y; j++){
            read(pipe_eficiencia[0], &eficiencias[j], sizeof(int));
        }
        //close(pipe_eficiencia[0]);
        
        //pegando maximo e minimo
        int eficiencia_max = -10;
        int eficiencia_min = 100000;
        int eficiencia_soma = 0;
        
        for(int j = 0; j < Y; j ++){
            eficiencia_soma += eficiencias[j];
            if (eficiencias[j] < eficiencia_min){
                eficiencia_min = eficiencias[j];
            }
            if (eficiencias[j] > eficiencia_max) {
                eficiencia_max = eficiencias[j];
            }
        }

        //normalizando
        int eficiencia_media = (1000 * eficiencia_soma) / Y;
        eficiencia_max *= 1000;
        eficiencia_min *= 1000;

        nominador = eficiencia_media - eficiencia_min;
        denominador = eficiencia_max - eficiencia_min;
        
        res = 1000 - (nominador * 1000 / denominador);
        int eficiencia_norm = res % 1000;
        printf("eficiencia normalizada: %de-03\n", eficiencia_norm);
        free(eficiencias);


        //OVERHEAD
        int *overheads = malloc(20 * sizeof(int));
        

        //lendo os dados do pipe
        for (int j = 0; j < Y; j++){
            read(pipe_overhead[0], &overheads[j], sizeof(int));
        }
        //close(pipe_overhead[0]);

        //pegando maximo e minimo
        int overhead_max = -10;
        int overhead_min = 100000;
        int overhead_soma = 0;
        
        for(int j = 0; j < Y; j ++){
            overhead_soma += overheads[j];
            if (overheads[j] < overhead_min){
                overhead_min = overheads[j];
            }
            if (overheads[j] > overhead_max) {
                overhead_max = overheads[j];
            }
        }

        int overhead_media = (1000 * overhead_soma) / Y;
        overhead_max *= 1000;
        overhead_min *= 1000;

        nominador = overhead_media - overhead_min;
        denominador = overhead_max - overhead_min;
        res = 1000 - (nominador * 1000 / denominador);
        int overhead_norm = res % 1000;
        printf("overhead normalizado: %de-03\n", overhead_norm);
        free(overheads);


        //DESEMPENHO
        //recuperando vazao_norm pela string
        vazao_norm = 0;
        vazao_norm += vazao_str[0] - '0';
        vazao_norm += 10*(vazao_str[1] - '0');
        vazao_norm += 100*(vazao_str[2] - '0');

        int justica_norm = 1000;
        int desempenho = (overhead_norm + eficiencia_norm + vazao_norm + justica_norm);
        desempenho = desempenho >> 2;
        printf("desempenho: %de-03\n", desempenho);

    }
    return 0;
}