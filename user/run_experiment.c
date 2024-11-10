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
    char *args[2];
    int *processos = malloc(20 * sizeof(int));

    for (int i = 1; i <= 30; i++){
        initialize_metrics();
        t0_rodada = uptime();
        uint X = (rand() % 9) + 6;
        uint Y = 20 - X;
        //int processos[20];
        int pid;
        int ret;
        for (int j = 1; j < 21; j++){
            int index = j - 1;
            char index_str[3];
            if (index < 10) {
                index_str[0] = '0';
                index_str[1] = index + '0';
                index_str[2] = '\0';
            } else{
                index_str[0] = '1';
                index_str[1] = (index - 10) + '0';
                index_str[2] = '\0';
            }
            
            args[1] = index_str;
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
                    processos[j-1] = pid;
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
                    processos[j-1] = pid;
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

        printf("RODADA %d ======================\n", i);

        // VAZÃO
        //ordenando vetor terminos
        for (int j = 0; j < 20; j++){
            for (int k = j+1; k < 20; k++){
                if (terminos[k] < terminos[j]){
                    int temp = terminos[k];
                    terminos[j] = terminos[k];
                    terminos[k] = temp;
                }
            }
        }

        int *vazoes = malloc(120 * sizeof(int));
        for (int j = 0; j < 120; j++){
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

        free(terminos);
        free(vazoes);
        

        // EFICIENCIA DO SISTEMA DE ARQUIVOS
        int *eficiencias = malloc(Y * sizeof(int));
        
        
        //lendo os dados da struct processo

        int l = 0;
        int eficiencia_atual;
        for (int k = 0; k < 20; k++){
            eficiencia_atual = get_eficiencia(k); //graphs.c devolve um valor negativo,
            if (eficiencia_atual >= 0 ){         //para que não impacte no cálculo
                eficiencias[l] = eficiencia_atual;
                l += 1;
            }
        }
        
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
        

        //lendo os dados da struct do processo
        int overhead_atual;
        for (int k = 0; k < 20; k++){
            overhead_atual = get_overhead(k);
            overheads[k] = overhead_atual;
        }

        //pegando maximo e minimo
        int overhead_max = -10;
        int overhead_min = 100000;
        int overhead_soma = 0;
        
        for(int j = 0; j < 20; j ++){
            overhead_soma += overheads[j];
            if (overheads[j] < overhead_min){
                overhead_min = overheads[j];
            }
            if (overheads[j] > overhead_max) {
                overhead_max = overheads[j];
            }
        }

        //normalizando
        int overhead_media = (1000 * overhead_soma) / 20;
        overhead_max *= 1000;
        overhead_min *= 1000;

        nominador = overhead_media - overhead_min;
        denominador = overhead_max - overhead_min;
        res = 1000 - (nominador * 1000 / denominador);
        int overhead_norm = res % 1000;
        printf("overhead normalizado: %de-03\n", overhead_norm);
        free(overheads);

        //JUSTIÇA
        int *justicas = malloc(20 * sizeof(int));
        //lendo do proc.c
        for (int k = 0; k < 20; k++){
            justicas[k] = get_justica(k);
        }

        //pegando máximo e mínimo
        int justica_max = -10;
        int justica_min = 100000;
        int justica_soma = 0;
        int justica_soma_quadrado = 0;
        for (int k = 0; k < 20; k++){
            justica_soma += justicas[k];
            justica_soma_quadrado += justicas[k] * justicas[k];
            if (justicas[k] < justica_min) {
                justica_min = justicas[k];
            }
            if (justicas[k] > justica_max){
                justica_max = justicas[k];
            }
        }

        //normalizando
        nominador = justica_soma * justica_soma;
        denominador = 20 * justica_soma_quadrado;
        res = 1000 - (nominador * 1000 / denominador);
        int justica_norm = res % 1000;
        printf("justica normalizada: %de-03\n", justica_norm);
        free(justicas);

        //DESEMPENHO
        int desempenho = (overhead_norm + eficiencia_norm + vazao_norm + justica_norm);
        desempenho = desempenho >> 2;
        printf("desempenho: %de-03\n", desempenho);
    }
    return 0;
}