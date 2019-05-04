#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include"functions.h"
void calcLagrange(const int n, FILE * output);


int main (void){
	//TODO: shift from indices 1 and 2 to array lp * L
	int n;
	FILE * output = fopen("output.txt", "w");
	if (output == NULL)
		return 0;
	for (n = 3; n < 11; n++)
		calcLagrange(n, output);
	fclose(output);
	return 0;
}

void calcLagrange(const int n, const FILE * output) {
	int i;
	lp L1, L2;
	double * X = (double *)malloc((n + 1) * sizeof(double));
	double * Y1 = (double *)malloc((n + 1) * sizeof(double));
	double * Y2 = (double *)malloc((n + 1) * sizeof(double));
	double * Xmid = (double *)malloc(n * sizeof(double));
	double * Ymid1 = (double *)malloc(n * sizeof(double));
	double * Ymid2 = (double *)malloc(n * sizeof(double));
	double * Lnmid1 = (double *)calloc(n, sizeof(double));
	double * Lnmid2 = (double *)calloc(n, sizeof(double));
	
	for (i = 0; i < n + 1; i++) {
		X[i] = -1 + i * 2.0 / n; //X = -1:2/n:1;
		Y1[i] = cos(3.1416*X[i]);  //Y1 = cos(pi.*X);
		Y2[i] = 1.0 / (1.0 + 25 * X[i] * X[i]);//Y2 = 1./(1+25.*(X.*2));
	}
	for (i = 0; i < n; i++) {
		Xmid[i] = -1 + 1.0 / n + i * (2.0 / n);//Xmid = -1+1/n:2/n:1;
		Ymid1[i] = cos(3.1416*Xmid[i]); //Ymid1 = cos(pi.*Xmid);
		Ymid2[i] = 1.0 / (1.0 + 25 * Xmid[i] * Xmid[i]);//Ymid2 = 1./(1+25.*(Xmid.^2));
	}
	L1.n = n;
	L1.X = X;
	L1.Y = Y1;
	L1.Xmid = Xmid;
	L1.Ymid = Ymid1;
	L1.Lnmid = Lnmid1;
	calcLagrangeMids(L1);
	L2.n = n;
	L2.X = X;
	L2.Y = Y2;
	L2.Xmid = Xmid;
	L2.Ymid = Ymid2;
	L2.Lnmid = Lnmid2;
	calcLagrangeMids(L2);
	calcDeviation(&L1);
	calcDeviation(&L2);
	printf("n=%d\n", n);
	printf("deviation (periodic net):\n function      average         maximum\n");
	printf("cos(pi*X) %12.5f %15.5f\n", L1.averageDeviation, L1.maxDeviation);
	printf("1/(1+25*(X^2)) %5.5f %15.5f\n", L2.averageDeviation, L2.maxDeviation);
	/*
	fprintf(output, "n=%d\n", n);
	fprintf(output, "deviation (periodic net):\n function      average         maximum\n");
	fprintf(output, "cos(pi*X) %12.5f %15.5f\n", L1.averageDeviation, L1.maxDeviation);
	fprintf(output, "1/(1+25*(X*2)) %5.5f %15.5f\n", L2.averageDeviation, L2.maxDeviation);
	*/
	//fprintf(output, "%.5f\n", L1.averageDeviation);
	//fprintf(output, "%.5f\n", L1.maxDeviation);
	//fprintf(output, "eq_step, cos-aver\n");
	//fprintf(output, "%.5f\n", L1.averageDeviation);
	//fprintf(output, "eq_step, poly-max\n");
	fprintf(output, "%.5f\n", L2.maxDeviation);
	//fprintf(output, "%.5f\n", L2.averageDeviation);

	makeChebishNet(L1);
	makeChebishNet(L2);
	for (i = 0; i < n+1; i++) {
		Y1[i] = cos(3.1416*X[i]);  //Y1 = cos(pi.*X);
		Y2[i] = 1.0 / (1.0 + 25 * X[i] * X[i]);//Y2 = 1./(1+25.*(X.*2));
	}
	for (i = 0; i < n; i++) {
		Ymid1[i] = cos(3.1416*Xmid[i]); //Ymid1 = cos(pi.*Xmid);
		Ymid2[i] = 1.0 / (1.0 + 25 * Xmid[i] * Xmid[i]);//Ymid2 = 1./(1+25.*(Xmid.*2));
	}
	calcLagrangeMids(L1);
	calcLagrangeMids(L2);
	calcDeviation(&L1);
	calcDeviation(&L2);
	
	printf("deviation (Chebishev net):\n function      average         maximum\n");
	printf("cos(pi*X) %12.5f %15.5f\n", L1.averageDeviation, L1.maxDeviation);
	printf("1/(1+25*(X*2)) %5.5f %15.5f\n", L2.averageDeviation, L2.maxDeviation);

	/*
	fprintf(output, "deviation (Chebishev net):\n function      average         maximum\n");
	fprintf(output, "cos(pi*X) %12.5f %15.5f\n", L1.averageDeviation, L1.maxDeviation);
	fprintf(output, "1/(1+25*(X*2)) %5.5f %15.5f\n", L2.averageDeviation, L2.maxDeviation);
	*/
	//fprintf(output, "%.5f\n", L1.averageDeviation);
	//fprintf(output, "%.5f\n", L1.maxDeviation);
	//fprintf(output, "eq_step, cos-aver\n");
	//fprintf(output, "%.5f\n", L1.averageDeviation);
	//fprintf(output, "eq_step, poly-max\n");
	//fprintf(output, "%.5f\n", L2.maxDeviation);
	//fprintf(output, "%.5f\n", L2.averageDeviation);

	free(X);
	free(Y1);
	free(Y2);
	free(Xmid);
	free(Ymid1);
	free(Ymid2);
	free(Lnmid1);
	free(Lnmid2);
}