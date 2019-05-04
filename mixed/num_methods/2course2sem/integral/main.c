#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#pragma warning(disable : 4996)
#define Myabs(a) ((a)>=0 ? (a) : (-(a)))
#define MY_TRUE (1)
#define MY_FALSE (0)

struct integrParams {
	double(*f)(double);
	double a; //left bound
	double b; //right bound
	double eps; //required precision
};
typedef struct integrParams integrParams;

struct answer {
	double res;
	char isCorrect;
};

double f1(double x) {
	return 1 / sqrt(Myabs(1 - x * x));
}

double f2(double x) {
	return x * x - 2 * x + 3;
}

double integral(integrParams p, int n) {
	double(*f)(double) = p.f;
	double a = p.a;
	double b = p.b;
	double h = (b - a) / (n - 1.0);
	double x;
	double j = 0;
	int i;
	for (i = 0; i < n; i++) {
		x = a + i * h;
		j += f(x);
	}
	j *= h;
	return j;
}
double radoIntegral(integrParams p, int n) {
	double(*f)(double) = p.f;
	const double a0 = p.a;
	const double b0 = p.b;
	const double h = (b0 - a0) / (n - 1.0);
	const double A1 = 1.5;
	const double A2 = 0.5;
	const double t1 = -1.0/3.0;
	double j = 0;
	int i;
	double x1, x2, a;
	for (i = 0; i < n-1; i++) {
		a = a0 + i * h;
		x1 = (2 * a + h) / 2 + h * t1 / 2;
		x2 = a + h; //x2 = b0
		j += (A1*f(x1) + A2 * f(x2))*h / 2;
	}
	return j;
}

struct answer integrPrecise(integrParams p) {
	int n = 3;
	int i = 0;
	double eps = p.eps;
	struct answer ans;
	double res;
	ans.isCorrect = MY_TRUE;
	//ans.res = integral(p, n);
	ans.res = radoIntegral(p, n);
	n *= 2;
	res = radoIntegral(p, n);
	while (Myabs(ans.res - res) > 3*eps) {
		ans.res = res;
		n *= 2;
		//res = integral(p, n);
		res = radoIntegral(p, n);
		if (i > 10.0 / eps) {
			ans.isCorrect = MY_FALSE;
			printf("NOOO\n");
			return ans;
		}
		i++;
	}
      printf("epsilon: %f, iterations until Runge criteria satisfied: %d\n", p.eps, i);
      printf("j: %f\n", ans);
	return ans;
}

#define k (6)
int main(void) {
	double epsArr [k] = {0.1, 0.01, 0.001, 1e-4, 1e-5, 1e-6};
	int i;
	integrParams p;
	struct answer integr;
	p.a = 0.5;
	p.b = 1.5;
	p.f = f1;
	//p.f = f2;
	//TODO: check the same for f2; write answer to table in report
	for(i=0; i<k; i++){
		p.eps = epsArr[i];
		integr = integrPrecise(p);
		if(!integr.isCorrect) printf("doesn't converge when eps = %f\n", p.eps);
	}
      /*
	int n;
	FILE * fp = fopen("output.txt", "w");
	integrParams p;
	struct answer integr;
	p.a = 0.0;
	p.b = 0.9;
	p.f = f1;
	p.eps = 0.001;
	integr = integrPrecise(p);
	printf("J=%f, eps=%f, isCorrect=%d\n", integr.res, p.eps, (int)integr.isCorrect);
	fprintf(fp, "f1:\n");
	for (n = 2; n < 50; n++)
		fprintf(fp, "%f\n", integral(p, n));
	fprintf(fp, "f2:\n");
	p.f = f2;
	for (n = 2; n < 50; n++)
		fprintf(fp, "%f\n", integral(p, n));
	fclose(fp);
	printf("trapezoidal integral from %.2f to %.2f, n= %d: %f\n", p.a, p.b, 10, integral(p, 10));
      */
	return 0;
}