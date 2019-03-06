#include<stdio.h>
#include<stdlib.h>
#include"functions.h"
#pragma warning(disable : 4996) //for VS to permit fopen
int main(void) {
	int n = 3;
	int m = n + 1, i, j;
	double eps = 0.0000001;
	double * Ab = (double *)calloc(n*m, sizeof(double));
	double * D = (double *)calloc(n*n, sizeof(double));
	double * C = (double *)calloc(n*n, sizeof(double));
	double * g = (double *)calloc(n, sizeof(double));
	double *x = (double *)calloc(n, sizeof(double));
	getMatrix(Ab, n, m);
	calc_multiple(D, Ab, n, m);
	calc_cg(C, g, D, Ab, n, m);
	printMatrix(C, n, n, "C:");
	printMatrix(g, n, 1, "g:");
	msi(x, C, g, eps, n);
	free(Ab);
	free(D);
	free(C);
	free(g);
	free(x);
	return 0;
}