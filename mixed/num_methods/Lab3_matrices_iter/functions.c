#include<stdio.h>
#include<stdlib.h>
#include"functions.h"
#pragma warning(disable : 4996) //for VS to permit fopen
void matrixMult(double *res, double * A, double * B, int n, int m, int k) {
	/* res(nxk)=A(nxm)*B(mxk)
	 * res(i,j)=res[n*i+j] */
	int i, j, s;
	for (i = 0; i < n; i++) {
		for (j = 0; j < k; j++) {
			res[k*i + j] = 0;
			for (s = 0; s < m; s++)
				res[k*i + j] += A[n*i + s] * B[k*s + j];
		}
	}
}
enum sign {
	minus,
	plus
};
void matrixAdd(double *res, double *added, int n, int m, enum sign sgn) {
	int i, j;
	for (i = 0; i < n; i++) {
		for (j = 0; j < m; j++) {
			if (sgn == plus)
				res[m*i + j] += added[m*i + j];
			else if (sgn == minus)
				res[m*i + j] -= added[m*i + j];
		}
	}
}
double infnorm(double *M, int n, int m) {
	int i, j;
	double t, res = 0.0;
	for (i = 0; i < n; i++) {
		t = 0.0;
		for (j = 0; j < m; j++)
			t += Myabs(M[m*i+j]);
		if (t > res)
			res = t;
	}
	return res;
}
void matrixCopy(double *res, double *donor, int n, int m) {
	int i, j;
	for (i = 0; i < n; i++) {
		for (j = 0; j < m; j++)
			res[m*i + j] = donor[m*i + j];
	}
}

void msi(double *x, double *C, double *g, double eps, int n) {
	int i;
	enum sign sg1;
	double *xk1 = (double *)calloc(n, sizeof(double));
	double *xk = (double *)calloc(n, sizeof(double));
	double *xdiff = (double *)calloc(n, sizeof(double));
	double nC = infnorm(C, n, n);
	double eps1 = (1 - nC) / nC * eps;
	matrixAdd(xk, g, n, 1, plus);
	matrixMult(xk1, C, xk, n, n, 1);
	matrixAdd(xk1, g, n, 1, plus);
	matrixAdd(xdiff, xk1, n, 1, plus);
	matrixAdd(xdiff, xk, n, 1, minus);
	while(infnorm(xdiff, n, 1) > eps1) {
		matrixCopy(xk, xk1, n, 1);
		matrixMult(xk1, C, xk, n, n, 1);
		matrixAdd(xk1, g, n, 1, plus);
		matrixAdd(xdiff, xdiff, n, 1, minus);
		matrixAdd(xdiff, xk1, n, 1, plus);
		matrixAdd(xdiff, xk, n, 1, minus);
	}
	printMatrix(xk1, n, 1, "xk1\n");
	//for some reason the sign is the opposite!
	free(xk1);
	free(xk);
	free(xdiff);
}

void calc_cg(double *C, double *g, double * D, double *Ab, int n, int m) {
	int i, j;
	for (i = 0; i < n; i++) {
		for (j = 0; j < n; j++) {
			C[n*i + j] = D[n*i + i] * Ab[m*i + j];
			if (i == j)
				C[n*i + j] += 1; //C = D*A-E
		}
		g[i] = D[n*i + i] * Ab[m*i + j];
	}
}

void calc_multiple(double *D, double *Ab, int n, int m) {
	int i;
	for (i = 0; i < n; i++) {
		D[n*i + i] = -1/Ab[m*i + i];
	}
}

void getMatrix(double *Ab, int n, int m) {
	char * filename = "../../matrices/M3no1.txt";
	FILE * fp;
	double buf;
	int i, j;
	fp = fopen(filename, "r");
	if (fp == NULL) {
		printf("error reading data\n");
		return;
	}
	for (i = 0; i < n; i++) {
		for (j = 0; j < n; j++) {
			fscanf(fp, "%lf\t", &buf);
			Ab[(m)*i + j] = buf;
		}
		fscanf(fp, "%lf\n", &buf);
		Ab[(m)*i + j] = buf;
	}
	fclose(fp);
}
void printMatrix(double * M, int rows, int columns, char *title) {
	int i, j;
	double t;
	printf("%s\n", title);
	for (i = 0; i < rows; i++) {
		for (j = 0; j < columns; j++) {
			t = M[columns*i + j];
			if (t >= 0)
				printf(" ");
			printf(" %f", t);
		}
		printf("\n");
	}
	printf("\n");
}
