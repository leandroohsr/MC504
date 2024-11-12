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
        t0_rodada = uptime_nolock();
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
                tempo_atual = uptime_nolock();
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
        int vazao_media = (20 * 100000) / lim;
        vazao_max *= 100000;
        vazao_min *= 100000;

        int nominador = vazao_media - vazao_min;
        int denominador = vazao_max - vazao_min; //é possível, por azar, isso ser zero

        long long res = 100000 - (nominador * 100000 / denominador);
        int vazao_norm = res % 100000;
        printf("vazao normalizada: %de-05\n", vazao_norm);

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
        
        //somando
        int eficiencia_soma = 0;
        
        for(int j = 0; j < Y; j ++){
            eficiencia_soma += eficiencias[j];
        }

        //invertendo
        res = 100000 / eficiencia_soma;
        int eficiencia_fim = res;
        printf("eficiencia normalizada: %de-05\n", eficiencia_fim);
        free(eficiencias);


        //OVERHEAD
        int *overheads = malloc(20 * sizeof(int));
        

        //lendo os dados da struct do processo
        int overhead_atual;
        for (int k = 0; k < 20; k++){
            overhead_atual = get_overhead(k);
            overheads[k] = overhead_atual;
        }


        int overhead_soma = 0;
        
        for(int j = 0; j < 20; j ++){
            overhead_soma += overheads[j];
        }

        //invertendo
        res = (100000 / overhead_soma);
        int overhead_fim = res;
        printf("overhead final: %de-05\n", overhead_fim);
        free(overheads);

        //JUSTIÇA
        int *justicas = malloc(20 * sizeof(int));

        //lendo do proc.c
        for (int k = 0; k < 20; k++){
            justicas[k] = get_justica(k);
        }

        //somando
        long long justica_soma = 0; 
        long long justica_soma_quadrado = 0;
        for (int k = 0; k < 20; k++){
            justica_soma += justicas[k];
            justica_soma_quadrado += justicas[k] * justicas[k];
        }

        //normalizando
        long long nominador2 = justica_soma * justica_soma;
        long long denominador2 = 20 * justica_soma_quadrado;
        printf("nominador: %lld | denominador: %lld\n", nominador2, denominador2);
        res = (nominador2 * 100000) / denominador2;
        int justica_fim = res;
        printf("justica_fim: %de-05\n", justica_fim);
        free(justicas);

        //DESEMPENHO
        int desempenho = (overhead_fim + eficiencia_fim + vazao_norm + justica_fim);
        desempenho = desempenho >> 2;
        printf("desempenho: %de-05\n", desempenho);
    }
    return 0;
}