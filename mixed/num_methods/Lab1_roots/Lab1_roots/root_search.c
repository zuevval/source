#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include"msifun.h"
#ifndef MY_ABS
#define MY_ABS
#define Myabs(a) ((a) >= 0 ? (a) : (-(a)))
#endif
#define EPS_QUANTITY 3
//const double epsilon[EPS_QUANTITY] = {pow(10.0,-5.0),0.01,0.001};
double epsilon[EPS_QUANTITY];
struct root {
	double a;
	double b;
	double psi;
	double f_psi;
};
double func1 (double x){
	double a=0.1254,b=-0.0027,c=-4.7285,d=-25.0263,e=-33.0434;
	return a*pow(x,4.0)+b*pow(x,3.0)+c*pow(x,2.0)+d*x+e;
}
double func2 (double x){
	double y = 1.8*x*x+sin(10.0*x);
	return y;
}
double bin_search (double a0, double b0, double eps);
void initEps(){
	extern double epsilon[EPS_QUANTITY];
	epsilon[0] = pow(10.0,-5.0);
	epsilon[1] = pow(10.0,-6.0);
	epsilon[2] = pow(10.0,-7.0);
}
//void mexFunction();

int main(void){
	int i=0;
	int j=0;
	extern double epsilon[EPS_QUANTITY];
	// algebraic equations
	struct root * r1 = (struct root*)malloc(2*sizeof(struct root));
	struct root * r2 = (struct root*)malloc(4*sizeof(struct root));
	initEps();
	//printf("%lf\n",func1(-1.987895766475397));//root found by fzero
	r1[0].a=-5.0;
	r1[0].b=-1.0;
	r1[1].a=6.0;
	r1[1].b=10.0;
	r2[0].a=-0.6;
	r2[0].b=-0.55;
	r2[1].a=-0.3;
	r2[1].b=-0.25;
	r2[2].a=-0.1;
	r2[2].b=0.1;
	r2[3].a=0.25;
	r2[3].b=0.4;
	/*printf("Binary search. Polynomial\n");
	for(i=0; i<2; i++){
		printf("\na=%.10lf, b=%lf\n",r1[i].a,r1[i].b);
		printf("\n  psi            f(psi)           epsilon\n\n");
		for(j=0; j<EPS_QUANTITY; j++){
			r1[i].psi = bin_search(r1[i].a,r1[i].b,epsilon[j]);
			r1[i].f_psi=func1(r1[i].psi);
			printf("%0.16lf %15.10lf %15.10lf\n",r1[i].psi,r1[i].f_psi,epsilon[j]);
		}
	}
	printf("\nSimple iterations. Polynomial\n");
	for(i=0; i<2; i++){
		printf("\na=%lf, b=%lf\n",r1[i].a,r1[i].b);
		printf("\n  psi            f(psi)           epsilon\n\n");
		for(j=0; j<EPS_QUANTITY; j++){
			r1[i].psi = msi(r1[i].a,r1[i].b,epsilon[j]);
			r1[i].f_psi=func1(r1[i].psi);
			printf("%0.16lf %15.10lf %15.10lf\n",r1[i].psi,r1[i].f_psi,epsilon[j]);
		}
	}*/

	/*printf("Binary search. Transcendent\n");
	for(i=0; i<4; i++){
		printf("\na=%.10lf, b=%lf\n",r1[i].a,r1[i].b);
		printf("\n  psi            f(psi)           epsilon\n\n");
		for(j=0; j<EPS_QUANTITY; j++){
			r2[i].psi = bin_search(r1[i].a,r1[i].b,epsilon[j]);
			r2[i].f_psi=func1(r1[i].psi);
			printf("%0.16lf %15.10lf %15.10lf\n",r1[i].psi,r1[i].f_psi,epsilon[j]);
		}
	}*/
	printf("\nSimple iterations. Transcendent\n");
	for(i=0; i<4; i++){
		printf("\na=%lf, b=%lf\n",r2[i].a,r2[i].b);
		printf("\n  psi            f(psi)           epsilon\n\n");
		for(j=0; j<EPS_QUANTITY; j++){
			r2[i].psi = msi(r2[i].a,r2[i].b,epsilon[j]);
			r2[i].f_psi=func2(r2[i].psi);
			printf("%0.16lf %15.10lf %15.10lf\n",r2[i].psi,r2[i].f_psi,epsilon[j]);
		}
	}

	free(r1);
	free(r2);
	return 0;
}

double bin_search (double a0, double b0, double eps){
	double ai, bi, mi;
	int i;
	int sign_revert;
	ai=a0;
	bi=b0;
	if(func1(a0)<0)
		sign_revert = 1;
	else
		sign_revert = -1;
	for(i=0;bi-ai>2*eps; i++){
		mi=(bi+ai)/2;
		if(sign_revert*func1(mi)==0)
			return mi;
		else if (sign_revert*func1(mi)<0)
			ai=mi;
		else
			bi=mi;
	}
	printf("k=%d\n", i);
	return (bi+ai)/2;
}