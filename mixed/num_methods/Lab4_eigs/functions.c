#include<stdio.h>
#include<stdlib.h>
#include"functions.h"
#pragma warning(disable : 4996) //for VStudio to permit fopen

double pervoe_sobst_chislo (double * A, double *x, int n, double eps, double lamb1) {
	double * B = calloc(n*n, sizeof(double));
	double * lE = calloc(n*n, sizeof(double));
	int i;
	double lamb2;

	for (i = 0; i < n; i++)
		lE[n*i + i] = 1; //lE <- eye(n)
	matrixTimesNo(lamb1, lE, n, n); //lE = lamb1*E
	matrixCopy(B, A, n, n);
	matrixAdd(B, lE, n, n, minus);//B=A-lamb1*E
	
	lamb2 = calcEig1(B, x, n, eps);
	lamb2 = lamb1 - lamb2;

	free(B);
	free(lE);
	return lamb2;
}

double vtoroe_sobst_chislo (double * A, double *xk, int n, double eps) {
	double * yk = (double *)malloc(n * sizeof(double));
	double * yk1 = (double *)malloc(n * sizeof(double));
	double * xk1 = (double *)malloc(n * sizeof(double));
	double lamb, lamb1;
	int i;

	for (i = 0; i < n; i++)
		yk[i] = 1;
	matrixCopy(xk, yk, 1, n);
	matrixTimesNo(1 / infnorm(yk, n, 1), xk, n, 1); //xk = yk/infnorm(yk)
	lamb = yk[0] / xk[0]; // lamb = 1
	matrixMult(yk1, A, xk, n, n, 1); // yk1 = A*xk
	matrixCopy(xk1, yk1, 1, n); //xk1 = yk1;
	matrixTimesNo(1 / infnorm(yk1, n, 1), xk1, n, 1); //xk1/=infnorm(yk) => xk1 = yk1/infnorm(yk)
	lamb1 = yk1[0] / xk1[0];
	numIters = 1;
	while (Myabs(lamb1 - lamb) > eps) {
		matrixCopy(yk, yk1, n, 1); //yk=yk1
		matrixCopy(xk, xk1, n, 1); //xk=xk1
		lamb = lamb1;
		matrixMult(yk1, A, xk, n, n, 1); // yk1 = A*xk
		matrixCopy(xk1, yk1, 1, n); //xk1 = yk1;
		matrixTimesNo(1 / infnorm(yk1, n, 1), xk1, n, 1); // xk1 /= infnorm(yk1) => xk1 = yk1/infnorm(yk1)
		lamb1 = yk1[0] / xk1[0];
		numIters++;
	}
	//printf("%d\n", i);

	free(yk);
	free(yk1);
	matrixCopy(xk, xk1, n, 1);
	free(xk1);
	return lamb1;
}


void getMatrix(double *A, int n, char *filename) {
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
			A[(n)*i + j] = buf;
		}
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
double infnorm(double *M, int n, int m) {
	int i, j;
	double t, res = 0.0;
	for (i = 0; i < n; i++) {
		t = 0.0;
		for (j = 0; j < m; j++)
			t += Myabs(M[m*i + j]);
		if (t > res)
			res = t;
	}
	return res;
}
void matrixTimesNo(double k, double * A, int n, int m) {
	int i, j;
	for (i = 0; i < n; i++) {
		for (j = 0; j < m; j++)
			A[m*i + j] *= k;
	}
}
void transpose(double * Res, double * Init, int n) {
	int i, j;
	for (i = 0; i < n; i++) {
		for (j = 0; j < n; j++)
			Res[n*i + j] = Init[n*j + i];
	}
}
void matrixCopy(double *res, double *donor, int n, int m) {
	int i, j;
	for (i = 0; i < n; i++) {
		for (j = 0; j < m; j++)
			res[m*i + j] = donor[m*i + j];
	}
}
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
