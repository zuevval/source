#include"matrixFunctions.h"
double f(double x) { return(sin(3.1416*x)); }

double smallestSq(int n, int m, int range[2], double * A, double * BF) {
	double * X = calloc(n, sizeof(double));
	double * Xmid = calloc(n-1, sizeof(double));
	double * Y = calloc(n, sizeof(double));
	double * Yapprox = calloc(n, sizeof(double));
	double * YmidApprox = calloc(n-1, sizeof(double));
	double maxDev=0, maxDevMid=0;
	int i, j, k;
	double power;
	double coef = range[1] - range[0];
	for (i = 0; i < n; i++) {
		X[i] = range[0]+ coef*i / (n - 1.0); //X = range(1, 1) :1 / (n - 1) : range(1, 2);
		Y[i] = f(X[i]); //Y = f(X);
	}
	for (i = 0; i < m; i++) {
		BF[(m + 1)*i + m] = 0;
		for (k = 0; k < n; k++)
			BF[(m + 1)*i + m] += Y[k] * pow(X[k], (double)i);
		for (j = 0; j < m; j++) {
			power = i + j;
			for (k = 0; k < n; k++)
				BF[(m+1)*i + j] += pow(X[k], power);
		}
	}

	printMatrix(BF, m, k, "B|F");
	solveSystem(m, A, BF);
	printMatrix(A, m, 1, "A");

	maxDev = 0;
	for (i = 0; i < n; i++) {
		for (j = 0; j < m; j++) {
			Yapprox[i] += A[j] * pow(X[i], (double)j);
		}
		if (Myabs(Yapprox[i] - Y[i]) > maxDev)
			maxDev = Myabs(Yapprox[i] - Y[i]);
	}
	maxDevMid = 0;
	for (i = 0; i < n-1; i++) {
		Xmid[i] = 0.5*(X[i + 1] + X[i]);
		for (j = 0; j < m; j++)
			YmidApprox[i] += A[j] * pow(Xmid[i], (double)j);
		if (Myabs(YmidApprox[i] - Y[i]) > maxDevMid)
			maxDevMid = Myabs(YmidApprox[i] - Y[i]);
	}

	printMatrix(Y, n, 1, "Y");
	printMatrix(Yapprox, n, 1, "Yapprox");
	printf("max deviation: %f\n", maxDev);
	printf("max deviation in midpoints: %f\n", maxDevMid);
	free(X);
	free(Xmid);
	free(Y);
	free(Yapprox);
	free(YmidApprox);
	return maxDev;
}

void solveSystem(int n, double *x, double * Ab) {
	int m = n + 1;
	int i, j;
	qrdecompose(Ab, n, m); //rotations
	solveTriang(Ab, n, m, x);
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