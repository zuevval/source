#include"rungeKutta.h"

vector <double> Solution::adams4(vector<double> X, int n) {
	double h = (b0 - a0) / (n - 1);
	vector<double> X1;
	for (int i = 0; i < n; i++)
		X1.push_back(a0 + h * i);
	vector<double> Y1;
	Y1.resize(n);
	Y1[0] = y0;
	double n1i, n2i, n3i, n4i, dyi;
	for (int i = 0; i < 3; i++) {
		n1i = f(X1[i], Y1[i]);
		n2i = f(X1[i] + h / 2, Y1[i] + (h / 2)*n1i);
		n3i = f(X1[i] + h / 2, Y1[i] + (h / 2)*n2i);
		n4i = f(X1[i] + h, Y1[i] + h * n3i);
		dyi = (h / 6)*(n1i + 2 * n2i + 2 * n3i + n4i);
		Y1[i + 1] = Y1[i] + dyi;
	}
	double f1, f2, f3, f4;
	for (int i = 3; i < n - 1; i++) {
		f1 = f(X1[i], Y1[i]);
		f2 = f(X1[i - 1], Y1[i - 1]);
		f3 = f(X1[i - 2], Y1[i - 2]);
		f4 = f(X1[i - 3], Y1[i - 3]);
		dyi = (h / 24)*(55 * f1 - 59 * f2 + 37 * f3 - 9 * f4);
		Y1[i + 1] = Y1[i] + dyi;
	}
	int delta = (int)(n - 1) / (X.size() - 1);
	vector <double> Y;
	for (int i = 0; i < X.size(); i++) {
		if (delta * i < n) Y.push_back(Y1[delta*i]);
	}
	return Y;
}

