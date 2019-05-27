#include<iostream>
#include<fstream>
#include<string>
#include"classes.h"

const int dim = 2; // Y dimension

valarray<double> f(double x, valarray<double> Y) {
	assert(Y.size() == dim);
	valarray<double> res;
	res.resize(dim);
	double y = Y[0];
	double z = Y[1];
	res[0] = z; //y'
	res[1] = 1 - sin(x) - y * sin(x) - z * cos(x); //z' = y''
	return res;
}

valarray<double> F(double x) {
	double y = sin(x);
	double z = cos(x);
	valarray<double> res = { y, z };
	return res;
}

void print(vector<vector<double>> & mtx, ostream & out, string comment = "") {
	out << comment << endl;
	for (auto & line : mtx) {
		for (double col : line) out << col << " ";
		out << endl;
	}
}

int main(void) {
	double x0 = 0;
	double a0 = 0;
	double b0 = PI/2;
	//border
	double A = F(0)[0];
	double B = F(PI / 2)[0];
	//Cauchy
	valarray<double> Y0 = F(x0);
	Solution s(f, F, a0, b0, A, B, Y0);
	method mtds [] = {RKutta, RKuttaBorder, Adams4, Adams4Border, Adams44, Adams44Border };
	cout << "enter number of control points:" << endl;
	int n;
	cin >> n;
	cout << "enter number of iterations (recommended <= 15, or processing will be slow):" << endl;
	int m;
	cin >> m;
	ofstream out("output.txt");
	for (auto mtd : mtds) {
		if (n <= 3 && mtd != RKutta && mtd != RKuttaBorder) {
			cout << "n < 4 => only Runge-Kutta possible" << endl;
			break;
		}
		auto Dif = s.dev(n, m, mtd);
		cout.precision(10);
		out.precision(10);
		string title;
		switch (mtd) {
		case RKutta:
			title = "deviation in control points: Runge-Kutta, Cauchy problem";
			break;
		case RKuttaBorder:
			title = "deviation in control points: Runge-Kutta, border ";
			break;
		case Adams4:
			title = "deviation in control points: Adams' method (4 rank, implicit), Cauchy problem";
			break;
		case Adams4Border:
			title = "deviation in control points: Adams' method (4 rank, implicit), border";
			break;
		case Adams44:
			title = "deviation in control points: Adams' method (4 rank, explicit), Cauchy problem";
			break;
		case Adams44Border:
			title = "deviation in control points: Adams' method (4 rank, explicit), border";
		}
		print(Dif, cout, title);
		print(Dif, out, title);
		double dif;
		toChange toPerturb[] = { zeroDerivative}; //other not implemented yet
		while (true) {
			for (auto tp : toPerturb) {
				if(tp == zeroDerivative) cout << "enter perturbation of A (0=exit):" << endl;
				else cout << "enter perturbation of second parameter (0=exit):" << endl;
				cin >> dif;
				if (dif == 0) goto break_while; //in Java it's possible to break nested loops; here goto is the simpliest method
				Dif = s.devPerturb(dif, n, m, mtd, zeroDerivative);
				title = "deviation from the same solution with initial A in control points:";
				print(Dif, cout, title);
				print(Dif, out, title);
			}
		}
	break_while: ;
	}
	out.close();
	return 0;
}