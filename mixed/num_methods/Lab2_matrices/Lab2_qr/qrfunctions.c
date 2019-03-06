#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>
#include"qrfunctions.h"
#pragma warning(disable : 4996) //for VS to permit fopen
#ifndef MY_ABS
#define MY_ABS
#define Myabs(a) ((a)>0?(a):(-(a)))
#endif
void devVector(double *v, int len) {
	int i;
	for (i = 0; i < len; i++)
		v[i] += v[i] * rand(10000) / 10000.0 / 300;
	//printf("%f\n", v[i]);
}

double vectorNorm(double *x, int len) {
	//1st norm
	int i;
	double sum = 0;
	for (i = 0; i < len; i++)
		sum += Myabs(x[i]);
	return sum;
}
double sumDiff(double *x1, double*x2, int len) {
	int i;
	double sum = 0;
	for (i = 0; i < len; i++) {
		sum += Myabs(x1[i] - x2[i]);
	}
	return sum;
}
void qrdecompose(double * Ab, int n, int m) {
	int i, j, flag = 1;
	double cij, sij, sq;
	for (i = 0; i < n - 1; i++) {
		flag = ifnotzero(Ab, i, n, m);
		if (flag == 0) { //if (A_ij == 0, j == i:n)
			printf("Determinant = 0\n");
			exit(-1);
		}
		for (j = i + 1; j < n; j++) {
			sq = sqrt(pow(Ab[m*i + i], 2) + pow(Ab[m*j + i], 2));
			cij = Ab[m*i + i] / sq; //cosine
			sij = Ab[m*j + i] / sq; //sine
			//printf("c=%f, s=%f, s^2+c^2=%f, i=%d, j=%d\n", cij, sij, cij*cij+sij*sij, i, j);
			rotate(Ab, cij, sij, i, j, n, m);
		}
	}
}
void rotate(double * Ab, double c, double s, int i, int j, int n, int m) {
	static double * Qt;
	static short QtInit = 0;
	double t;
	int k;
	if (QtInit == 0) {
		QtInit = 1;
		Qt = (double *)calloc(n*n, sizeof(double));
		for (k = 0; k < n; k++)
			Qt[n*k + k] = 1;
	}
	for (k = i; k < m; k++) {
		t = Ab[m*i + k] * c + Ab[m*j + k] * s;
		Ab[m*j + k] = Ab[m*i + k] * (-s) + Ab[m*j + k] * c;
		Ab[m*i + k] = t;
		t = Qt[n*i + k] * c + Qt[n*j + k] * s;
		Qt[n*j + k] = Qt[n*i + k] * (-s) + Qt[n*j + k] * c;
		Qt[n*i + k] = t;
	}
}
int ifnotzero(double * Ab, int i, int n, int m) {
	int j;
	if (Ab[m*i + i] != 0)
		return 1;
	else {
		for (j = i; j < n; j++) {
			if (Ab[m*j + i] != 0)
				return 1;
		}
	}
	return 0;
}
void solveTriang(double * Ab, int n, int m, double * x) {
	int i, j;
	double t;
	for (i = n - 1; i >= 0; i--) {
		t = Ab[m*i + n];
		for (j = n - 1; j > i; j--)
			t -= x[j] * Ab[m*i + j];
		t /= Ab[m*i + i];
		x[i] = t;
	}
}
double checkSolution(double *Ab, int n, int m, double *x) {
	double *b1 = (double *)calloc(n, sizeof(double));
	int i, j;
	double res = 0; // res=||Ax-b||
	for (i = 0; i < n; i++) {
		for (j = 0; j < n; j++)
			b1[i] += Ab[m*i + j] * x[j];
	}
	for (i = 0; i < n; i++)
		res += Myabs(b1[i] - Ab[m*i + n]); // res=||Ax-b||
	return res;
}

double Ab_ANorm(double *M, int n, int m) {
	double res = 0;
	double t;
	int i;
	for (i = 0; i < n; i++) {
		double * row = M + m * i;
		t = vectorNorm(row, n);
		if (t > res)
			res = t;
	}
	return res;
}