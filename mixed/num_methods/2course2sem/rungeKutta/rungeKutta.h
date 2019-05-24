#include<vector>
using namespace std;
struct jAns {
	double data;
	int steps;
};

enum method {
	RKutta,
	Adams4,
	Adams44,
	Adams34
};

class Solution{
	double(*f)(double x, double y);
	double(*F)(double);
	double a0;
	double b0;
	double y0;
	vector <double> rungeKutta(vector<double> X0, int n);
	vector <double> adams4(vector<double> X0, int n);
	vector <double> adams44(vector<double> X0, int n);
	vector <double> adams34(vector<double> X0, int n);
public:
	Solution(double(*fun)(double x, double y),
		double(*Fun)(double),
		double A0, double B0, double Y0){
			f = fun;
			F = Fun;
			a0 = A0;
			b0 = B0;
			y0 = Y0;
		}
	vector<vector<double>> rungeDev (int n, int m, method mtd = RKutta);
	vector<vector<double>> devPerturb(double dy, int n, int m);
	jAns rkRungeEstimate(double eps);
};