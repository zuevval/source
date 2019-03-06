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
#define NUM_STR "10" //3, 4, 5, 6, 7, 8, 9, 10, 11
#define NAME_STR "B" //A, B
#define NO_STR "no9" //empty OR IF n=10 AND NAME = B ->no+ 1,2,3,...
void printMatrix(double * M, int rows, int columns, char *title);
void getExtendedMatrix1(double *Ab, int n, int m, char * nostr);
void getExtendedMatrixDev(double *Ab, int n, int m, char * nostr);
void compareDerivedMatrix(int n, char * nostr);
void compareDerivedVector(int n, char * nostr);

int main(void) {
	char * nostr = (char *)calloc(sizeof(char), 10);
	int i, n = (int)(NUM_STR[0] - '0'); 
	if (NUM_STR[1] != '\0') {
		n *= 10;
		n += (int)(NUM_STR[1] - '0');
	}
	nostr[0] = 'n';
	nostr[1] = 'o';
	for (i = 0; i < 10; i++) {
		nostr[2] = i + '0';
		compareDerivedMatrix(n, nostr);
		compareDerivedVector(n, nostr);
	}
	free(nostr);
	return 0;
}
void compareDerivedMatrix(int n, char * nostr) {
	int m = n + 1;
	int i, j;
	double diff;
	double *x;
	double *xDev;
	double diffNorm, xNorm, deltaANorm, ANorm;
	double * Ab;
	double * AbInitial;
	double *b;
	double coeff = 1, k1;
	printf("n=%d\n", n);
	printf("No=%s\n", nostr);
	Ab = (double *)calloc(n*m, sizeof(double));
	AbInitial = (double *)calloc(n*m, sizeof(double));
	//A_ij <=> Ab[m*i+j]; b_i <=> Ab[m*i+n]; enum starts from 0
	getExtendedMatrix1(Ab, n, m, nostr);
	x = (double*)calloc(n, sizeof(double));
	qrdecompose(Ab, n, m); //rotations
	solveTriang(Ab, n, m, x);

	getExtendedMatrix1(AbInitial, n, m, nostr);
	ANorm = Ab_ANorm(Ab, n, m);
	diff = checkSolution(AbInitial, n, m, x);
	printf("||Ax-b|| = %.25lf\n", diff);

	getExtendedMatrixDev(Ab, n, m, nostr);
	for (i = 0; i < n; i++) { //AbInitial->deltaAb
			for (j = 0; j < n; j++) {
				AbInitial[m*i + j] -= Ab[m*i + j];
			}
	}
	deltaANorm = coeff * Ab_ANorm(AbInitial, n, m);
	xDev = (double*)calloc(n, sizeof(double));
	qrdecompose(Ab, n, m); //rotations
	solveTriang(Ab, n, m, xDev);
	diffNorm = sumDiff(x, xDev, n);
	xNorm = vectorNorm(x, n);
	//printf("||x||=%lf\n", xNorm);
	//printf("deviations in A: (||delta A||)/||A||=%lf\n", deltaANorm / ANorm);
	//printf("deviations in A: ||delta X||=%lf\n", diffNorm);
	printf("deviations in A: (||delta X||)/(||X||) =%lf\n", diffNorm / xNorm);
	k1 = (diffNorm / xNorm) / (deltaANorm / ANorm);
	printf("deviations in A: k1 =%lf\n", k1);
	free(Ab);
	free(AbInitial);
	free(x);
	free(xDev);
}
void compareDerivedVector(int n, char * nostr) {
	int m = n + 1;
	int i;
	double *x;
	double *xDev;
	double diffNorm, xNorm, deltaBNorm, bNorm;
	double * Ab;
	double *delta_b;
	double *bDev;
	double coeff = 0.01, k2;
	Ab = (double *)calloc(n*m, sizeof(double));
	//A_ij <=> Ab[m*i+j]; b_i <=> Ab[m*i+n]; enum starts from 0
	getExtendedMatrix1(Ab, n, m, nostr);
	x = (double*)calloc(n, sizeof(double));
	qrdecompose(Ab, n, m); //rotations
	solveTriang(Ab, n, m, x);

	delta_b = calloc(n, sizeof(double));
	bDev = calloc(n, sizeof(double));
	for (i = 0; i < n; i++)
		bDev[i] = 1;
	devVector(bDev, n);
	for (i = 0; i < n; i++) {
		Ab[m*i + n] = bDev[i];
		delta_b[i] = bDev[i] - 1;
	}
	bNorm = vectorNorm(bDev, n);
	free(bDev);

	deltaBNorm = vectorNorm(delta_b, n);

	xDev = (double*)calloc(n, sizeof(double));
	qrdecompose(Ab, n, m); //rotations
	solveTriang(Ab, n, m, xDev);
	diffNorm = coeff * sumDiff(x, xDev, n);
	xNorm = vectorNorm(x, n);
	//printf("deviations in b: ||delta X||=%lf\n", diffNorm);
	printf("deviations in b: (||delta X||)/(||X||) =%lf\n", diffNorm / xNorm);
	//printf("deviations in b: (||delta b||)/||b + delta b||=%lf\n", deltaBNorm / bNorm);
	k2 = (diffNorm / xNorm) / (deltaBNorm / bNorm);
	printf("deviations in b: k2 =%lf\n", k2);
	free(Ab);
	free(x);
	free(xDev);
}

void getExtendedMatrix1(double *Ab, int n, int m, char * nostr) {
	char filename1 [] = "../../matrices4/"NAME_STR NUM_STR;
	char filename2 [] = ".txt";
	char *filename = (char *)calloc(100, sizeof(char));
	FILE * fp;
	double buf;
	int i = 0, j;
	strcat(filename, filename1);
	strcat(filename, nostr);
	strcat(filename, filename2);
	fp = fopen(filename, "r");
	for (i = 0; i < n; i++) {
		for (j = 0; j < n-1; j++) {
			fscanf(fp, "%lf\t", &buf);
			Ab[(n + 1)*i + j] = buf;
		}
		fscanf(fp, "%lf\n", &buf);
		Ab[(n + 1)*i + j] = buf;
	}
	fclose(fp);
	for (i = 0; i < n; i++) {
		Ab[m*i+n] = 1;
	}
	free(filename);
}
void getExtendedMatrixDev(double *Ab, int n, int m, char * nostr) {
	char filename1[] = "../../matrices4/"NAME_STR"dev"NUM_STR;
	char filename2[] = ".txt";
	char *filename = (char *)calloc(100, sizeof(char));
	FILE * fp;
	double buf;
	int i, j;
	strcat(filename, filename1);
	strcat(filename, nostr);
	strcat(filename, filename2);
	fp = fopen(filename, "r");
	for (i = 0; i < n; i++) {
		for (j = 0; j < n - 1; j++) {
			fscanf(fp, "%lf\t", &buf);
			Ab[(n + 1)*i + j] = buf;
		}
		fscanf(fp, "%lf\n", &buf);
		Ab[(n + 1)*i + j] = buf;
	}
	fclose(fp);
	for (i = 0; i < n; i++) {
		Ab[m*i + n] = 1;
	}
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