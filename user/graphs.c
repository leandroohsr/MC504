#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define max_iter 1000
#define INF 100000
#define MAX_VERT 200

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

void generate_random_edge(int **matrix, int num_vertices, int *vert1, int *vert2){
    do {
        *vert1 = rand() % num_vertices;
        *vert2 = rand() % num_vertices;
    } while (*vert1 == *vert2 || matrix[*vert1][*vert2]);
}


int main(int agrc, char *argv[]){

    int index = 0;
    index += (argv[1][0] - '0') * 10;
    index += (argv[1][1] - '0');

    int t0, t1;
    int tempo_overhead = 0;
    
    for (int i = 0; i < max_iter; i++){
        //vertices de 100 a 200 e arestas de 50 a 400
        uint num_vertices = (rand() % 101) + 100;
        int num_edges = (rand() % 351) + 50;

        t0 = uptime_nolock();
        int **matrix = malloc(num_vertices * sizeof(int *));
        t1 = uptime_nolock();
        tempo_overhead+= t1 - t0;

        //criar e zerar matrix
        for (int j = 0; j < num_vertices; j++){
            t0 = uptime_nolock();
            matrix[j] = malloc(num_vertices * sizeof(int));
            t1 = uptime_nolock();
            tempo_overhead+= t1 - t0;

            for (int k = 0; k < num_vertices; k++){
                matrix[j][k] = 0;
            }
        }
        
        //gerar arestas aleatórias
        int u, v;
        for (int j = 0; j < num_edges; j++){
            generate_random_edge(matrix, num_vertices, &u, &v);
            matrix[u][v] = 1;
        }

        //dois vértices aleatórios
        do {
            u = rand() % num_vertices;
            v = rand() % num_vertices;
        } while (u == v);

        // printf("Buscando caminho mínimo de %d a %d...\n", u, v);

        // resolver problema do caminho mínimo
        int distancia[MAX_VERT];


        // //buscando caminho mínimo
        int visitado[MAX_VERT];
        int tam = 2*MAX_VERT;
        t0 = uptime_nolock();
        int *fila = malloc(tam * sizeof(int));
        t1 = uptime_nolock();
        tempo_overhead+= t1 - t0;


        for (int i = 0; i < 200; i++){
            distancia[i] = INF;
            visitado[i] = 0;
        }

        // //busca começa em u
        fila[0] = u;
        distancia[u] = 0;


        //abstração de uma fila, quando esq > dir, a fila "está vazia"
        int esq = 0;
        int dir = 0;
        int atual;
        while (esq <= dir) {
            atual = fila[esq];
            for (int j = 0; j < num_vertices; j++){
                if (matrix[atual][j] && !visitado[j]){
                    visitado[j] = 1;
                    distancia[j] = distancia[atual] + 1;
                    dir++;
                    fila[dir] = j;
                }
            }
            esq++;
        }

        //libera a matrix
        t0 = uptime_nolock();
        free(fila);
        t1 = uptime_nolock();
        tempo_overhead+= t1 - t0;
        for (int i = 0; i < num_vertices; i++) {
            t0 = uptime_nolock();
            free(matrix[i]); 
            t1 = uptime_nolock();
            tempo_overhead+= t1 - t0; 
        }
        t0 = uptime_nolock();
        free(matrix);
        t1 = uptime_nolock();
        tempo_overhead+= t1 - t0;

    }

    increment_metric(index, -1, MODE_EFICIENCIA);
    increment_metric(index, tempo_overhead, MODE_OVERHEAD);

    int pid = getpid();
    set_justica(index, pid);

    return 0;
}