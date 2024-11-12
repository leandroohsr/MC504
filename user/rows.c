#include "kernel/types.h"
#include "user/user.h"
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

unsigned long rand_next = 13;

int
rand(void)
{
    return (do_rand(&rand_next));
}

int main(int agrc, char *argv[]){
    int t0, t1;
    int total_eficiencia = 0, total_overhead = 0;


    int index = 0;
    index += (argv[1][0] - '0') * 10;
    index += (argv[1][1] - '0');

    int fd;
    char filename[20] = "iobound";
    char pid_str[10];
    char *suffix = ".txt";

    int pid = getpid();

    pid += 1000; //valores baixos dão problema

    int i = 0;
    do {
        pid_str[i++] = pid % 10 + '0';   // próximo digito
    } while ((pid /= 10) > 0);
    pid_str[i] = '\0';

    int j;
    char temp;
    for (j = 0, i--; j < i; j++, i--) {
        temp = pid_str[j];
        pid_str[j] = pid_str[i];
        pid_str[i] = temp;
    }

    i = 7;
    while (pid_str[j] != '\0') {
        filename[i++] = pid_str[j++];
    }
    j = 0;
    while (suffix[j] != '\0') {
        filename[i++] = suffix[j++];
    }
    filename[i] = '\0';

    t0 = uptime_nolock();
    fd = open(filename, O_CREATE | O_RDWR);
    t1 = uptime_nolock();
    total_overhead += t1 - t0;

    if (fd < 0){
        printf("erro ao criar o arquivo %s\n", filename);
    }

    char *caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$&*()";

    char linha[101];
    linha[100] = '\n';
    int size = 101;
    for(i=0;i<100;i++){ //lines
        for(int j=0;j<100;j++){ //characters
            int c = rand() % 70;
            linha[j] = caracteres[c];
        }
        t0 = uptime_nolock();
        if(write(fd, linha, size) != size){
            printf("error, write failed\n");
            exit(1);
        } else {  //wrote succesfully
            t1 = uptime_nolock();
            total_eficiencia += t1 - t0;
        }
    }
    close(fd);



    char *linhas[100];
    for (int j = 0; j < 100; j++) {
        t0 = uptime_nolock();
        linhas[j] = malloc(102 * sizeof(char)); // allocate memory for each string
        t1 = uptime_nolock();
        total_overhead += t1 - t0;
    }

    t0 = uptime_nolock();
    fd = open(filename, O_RDONLY);
    t1 = uptime_nolock();
    total_overhead += t1 - t0;
    if (fd < 0) {
        printf("Erro ao abrir o arquivo %s\n", filename);
        exit(1);
    }

    char buf[101];
    int n;
    i = 0;
    t0 = uptime_nolock();
    while((n = read(fd, buf, sizeof(buf))) > 0) {
        t1 = uptime_nolock();
        total_eficiencia += t1 - t0;
        strcpy(linhas[i], buf);
        i++;
        t0 = uptime_nolock();
    }

    close(fd);


    char *tmp;
    t0 = uptime_nolock();
    tmp = malloc(102*sizeof(char));
    t1 = uptime_nolock();
    total_overhead += t1 - t0;

    for (i = 0; i < 50; i++){
        //getting random rows
        int row1 = rand() % 100;
        int row2 = rand() % 100;

        //swapping them
        strcpy(tmp, linhas[row1]);
        strcpy(linhas[row1], linhas[row2]);
        strcpy(linhas[row2], tmp);
    }
    t0 = uptime_nolock();
    free(tmp);
    t1 = uptime_nolock();
    total_overhead += t1 - t0;

    //rewriting file after permutations
    t0 = uptime_nolock();
    fd = open(filename, O_RDWR);
    t1 = uptime_nolock();
    total_overhead += t1 - t0;
    if (fd < 0) {
        printf("Erro ao reabrir o arquivo %s para escrever as permutações\n", filename);
        exit(1);
    }

    size = 101;
    for (int i = 0; i < 100; i++){
        t0 = uptime_nolock();
        if(write(fd, linhas[i], size) != size){
            printf("error, write permut failed\n");
            exit(1);
        } else {
            t1 = uptime_nolock();
            total_eficiencia += t1 - t0;
        }
    }

    close(fd);

    //removing file
    t0 = uptime_nolock();
    if (unlink(filename) < 0){
        printf("Erro ao remover o arquivo\n");
        exit(1);
    } else {
        t1 = uptime_nolock();
        total_eficiencia += t1 - t0;
    }


    //free malloc for linhas
    for (int j = 0; j < 100; j++) {
        t0 = uptime_nolock();
        free(linhas[j]);
        t1 = uptime_nolock();
        total_overhead += t1 - t0;
    }


    increment_metric(index, total_eficiencia, MODE_EFICIENCIA);
    increment_metric(index, total_overhead, MODE_OVERHEAD);

    pid = getpid();
    set_justica(index, pid);

    return 0;
}