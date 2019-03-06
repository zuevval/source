#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#ifndef MY_ABS
#define MY_ABS
#define Myabs(a) ((a) >= 0 ? (a) : (-(a)))
#endif
//we suppose that f'(x) > 0 or f'(x) < 0 in [a;b]
int sign_revert=1;
double f1(double x){
	/*double a=0.1254,b=-0.0027,c=-4.7285,d=-25.0263,e=-33.0434;
	return a*pow(x,4.0)+b*pow(x,3.0)+c*pow(x,2.0)+d*x+e;*/
	double y = 1.8*x*x + sin(10.0*x);
	return y;
}
double func(double x){
	extern int sign_revert;
	return f1(x)*sign_revert;
}
void f1_to_func(double a, double b){
	double fa, fb;
	fa=f1(a);
	fb=f1(b);
	sign_revert = fb-fa>0 ? 1 : -1;
}
double * der_bounds (double a, double b, double eps){
	/*returns two-element array bnd
	 *bnd[0]=min(f')
	 *bnd[1]=max(f')*/
	double eps_min = 0.00001;
	double x1, x2, fx1, fx2, t;
	double * bnd = (double*)malloc(sizeof(double)*2);
	if(eps<eps_min)
		eps=eps_min;
	bnd[0]=(func(b)-func(a))/(b-a);
	bnd[1]=0;
	for(x1=a, x2=a+eps; x2<b; x1=x2,x2+=eps){
		fx1=func(x1);
		fx2=func(x2);
		t=(fx2-fx1)/(x2-x1);
		if(bnd[0]>t) bnd[0]=t;
		if(bnd[1]<t) bnd[1]=t;
	}
	bnd[0]-=eps;
	bnd[1]+=eps;
	return bnd;
}
double fi_coef(double min, double max){
	double lambda = 2/(min+max);
	return lambda;
}
double q_0(double min, double max){
	double q = (max-min)/(min+max);
	if (q > 1) return -1;
	return q;
}
int ifrootnotfound(double x, double fi_x, double eps, double q){
	double dif = Myabs((fi_x-x));
	double compareto = eps*(1-q)/q;
	return dif > compareto ? 1 : 0;
}
double msi(double a, double b, double eps){
	double x, fi_x, q, lambda;
	int i, k;
	double * bnd = malloc(sizeof(double)*2);
	f1_to_func(a,b);
	bnd = der_bounds(a,b,eps);
	//printf("bnd: %lf %lf\n",bnd[0],bnd[1]);
	q=q_0(bnd[0],bnd[1]);
	if(q==-1) return -1;
	lambda=fi_coef(bnd[0],bnd[1]);
	//printf("lambda=%lf, q=%lf\n",lambda,q);
	x=a;
	fi_x=x-lambda*func(x);
	k=0;
	while(ifrootnotfound(x, fi_x, eps, q)){
		//printf("x_k: %lf, k: %d\n", x, k);
		x=Myabs(x)*fi_x/x;
		//x = fi_x;
		fi_x=x-lambda*func(x);
		k++;
	}
	printf("eps=%lf, q=%lf, k=%d\n",eps,q,k);
	free(bnd);
	return fi_x;
}