#include<stdio.h>
#include<stdlib.h>
#include"matrixFunctions.h"

int main(void) {
	int n = 3;
	int m = 2;
	int k = m + 1;
	double *A;
	double * BF;
	int range[2] = {0,1};
	A = (double*)calloc(m, sizeof(double));
	BF = (double *)calloc(m*(m+1), sizeof(double));
	//B[i,j] <=> BF[k*i + j]
	//F[i] <=> BF[k*i + n]
	smallestSq(n, m, range, A, BF);
	//printMatrix(BF, m, k, "B|F");
	free(A);
	free(BF);
	return 0;
}