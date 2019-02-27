#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#define ERR_FLAG (-1)

int myMax(int num, ...);
void readMatrix(const int n, const char * filename, int * A);
void printMatrix(const int n, const int * M);
void calcB (const int n, const int * A, int * B);

int main() {
    const int n = 5;
    int * A, * B;
    char  filename [] = "input.txt";
    A = calloc(n*n, sizeof(int));
    B = calloc(n*n, sizeof(int));
    readMatrix(n, filename, A);
    calcB(n, A, B);
    printMatrix(n, A);
    printMatrix(n, B);
    free(A);
    free(B);
    return 0;
}

void calcB (const int n, const int * A, int * B){
    int i, j;
    for (i=0; i<n; i++)
        B[n*i+(n-1)] = A[n*i+(n-1)];
    for(j=n-2; j>=0; j--){
        B[n*0+j] = myMax(3,A[n*0+j], B[n*0+(j+1)], B[n*1+(j+1)]);
        for(i=1; i<n-1; i++)
            B[n*i+j] = myMax(4, A[n*i+j], B[n*(i-1)+(j+1)], B[n*i+(j+1)], B[n*(i+1)+(j+1)]);
        B[n*(n-1)+j] = myMax(3,A[n*(n-1)+j], B[n*(n-2)+(j+1)], B[n*(n-1)+(j+1)]);
    }

}

void readMatrix(const int n, const char * filename, int * A){
    int i, j;
    FILE * fp;
    int buf;
    fp = fopen(filename, "r");
    if (fp == NULL) {
        printf("error reading data\n");
        return;
    }
    for(i=0; i<n; i++){
        for(j=0; j<n; j++) {
            fscanf(fp, "%d\t", &buf);
            A[n*i+j] = buf;
        }
    }
}

void printMatrix(const int n, const int * M) {
    int i, j, t;
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            t = M[n*i + j];
            if (t >= 0)
                printf(" ");
            printf(" %d", t);
        }
        printf("\n");
    }
    printf("\n");
}

int myMax(int num, ...){
    va_list v;
    int max, t;
    int i;
    va_start(v, num);
    if(num <= 0)
        return ERR_FLAG;
    max = va_arg(v, int);
    for (i=1; i<num; i++){
        t = va_arg(v, int);
        if (t > max)
            max = t;
    }
    va_end(v);
    return max;
}