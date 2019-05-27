#ifndef H_CLASSES_MY
#define H_CLASSES_MY
#include<valarray>
#include<vector>
#include<cmath>
#include<cassert>
using namespace std;
const double PI = std::atan(1.0) * 4;
enum method {
	RKutta,
	RKuttaBorder,
	Adams4,
	Adams4Border,
	Adams44,
	Adams44Border
};

enum toChange {
	zeroDerivative,
	firstDerivative
};

class Solution {
	valarray<double>(*f)(double x, valarray<double> Y);
	valarray<double>(*F)(double);
	double a0;
	double b0;
	int dim; //dimension of Y valarray
	//-------------border------------------
	valarray<double> Y0u;
	valarray<double> Y0v;
	vector <valarray<double>> border(vector<double> X0, int n, method mtd);
	double A; //A=y(a) = Y[0][0]
	double B; //B=y(b) = Y[Y.size()][0]
	//------------Cauchy-------------------
	valarray<double> Y0;
	vector <valarray<double>> rungeKutta(vector<double> X0, int n, valarray<double> Y0Init);
	vector <valarray<double>> adams4(vector<double> X0, int n, valarray<double> Y0Init);
	vector <valarray<double>> adams44(vector<double> X0, int n, valarray<double> Y0Init);
public:
	Solution(valarray<double>(*fun)(double x, valarray<double> Y),
		valarray<double>(*Fun)(double),
		double a0Init, double b0Init, double AInit, double BInit, valarray<double> y0) {
		f = fun;
		F = Fun;
		a0 = a0Init;
		b0 = b0Init;
		//border
		A = AInit;
		B = BInit;
		//Cauchy
		Y0 = y0;
	}
	vector<vector<double>> dev(int n, int m, method mtd);
	vector<vector<double>> devPerturb(double dy, int n, int m, method mtd, toChange toPerturb);
};
#endif
