#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#ifndef MY_ABS
#define MY_ABS
#define Myabs(a) (a >= 0 ? a : -(a))
#endif
struct root {
	double a;
	double b;
	double psi;
	double f_psi;
};
int fi_type=-1;
double q=2;
double func (double x){
	return pow(x,3.0)+0.5;
}
void find_fi (double a0, double b0, double eps){
	//fi1=f1+x; fi2=x-f1
	double t1=a0;
	double t2=a0+eps;
	double fi1_t1, fi1_t2, fi2_t1, fi2_t2, fi1_der, fi2_der;//der<=>derivative
	extern int fi_type;
	extern double q;
	double q_type1 = 0;
	double q_type2 = 0;
	while(t1<b0){
		fi1_t1=func(t1)+t1;
		fi1_t2=func(t2)+t2;
		fi1_der=(fi1_t2-fi1_t1)/(t2-t1);
		if(Myabs(fi1_der)>q_type1){
			q_type1=Myabs(fi1_der);
			//printf("q_type1=%f\n",q_type1);
		}
		fi2_t1=t1-func(t1);
		fi2_t2=t2-func(t2);
		fi2_der=(fi2_t2-fi2_t1)/(t2-t1);
		if(Myabs(fi2_der)>q_type2){
			q_type2=Myabs(fi2_der);
			//printf("%f\n",q_type2);
		}
		t1=t2;
		t2+=eps;
	}
	if(q_type1<1){
		q=q_type1;
		fi_type=1;
	}
	if(q_type2<1){
		if(q_type2<q_type1||fi_type==-1){
			q=q_type2;
			fi_type=2;
		}
	}
}