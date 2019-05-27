#include"classes.h"
#include<iostream>

vector <valarray<double>> Solution::adams44(vector<double> X, int n, valarray<double> Y0Init) {
	double h = (b0 - a0) / (n - 1);
	vector<double> X1;
	for (int i = 0; i < n; i++)
		X1.push_back(a0 + h * i);
	vector<valarray<double>> Y1;
	Y1.resize(n);
	Y1[0] = Y0Init;
	vector<valarray<double>> eta;
	eta.resize(4); //TODO: make const like 'RungeOrder'
	valarray<double> dyi;
	for (int i = 0; i < 3; i++) {
		eta[0] = f(X1[i], Y1[i]);
		eta[1] = f(X1[i] + h / 2, Y1[i] + (h / 2)*eta[0]);
		eta[2] = f(X1[i] + h / 2, Y1[i] + (h / 2)*eta[1]);
		eta[3] = f(X1[i] + h, Y1[i] + h * eta[2]);
		dyi = (h / 6)*(eta[0] + 2.0 * eta[1] + 2.0 * eta[2] + eta[3]);
		Y1[i + 1] = Y1[i] + dyi;
		//Y1[i + 1] = Y1[i] + h*eta[0]; //simple Euler's method
	}
	valarray<double> f1, f2, f3, f4;
	valarray<double> fi1; //for corrector: f(x_{i+1})
	for (int i = 3; i < n - 1; i++) {
		f1 = f(X1[i], Y1[i]);
		f2 = f(X1[i - 1], Y1[i - 1]);
		f3 = f(X1[i - 2], Y1[i - 2]);
		f4 = f(X1[i - 3], Y1[i - 3]);
		dyi = (h / 24)*(55.0 * f1 - 59.0 * f2 + 37.0 * f3 - 9.0 * f4);
		Y1[i + 1] = Y1[i] + dyi; //predictor
		fi1 = f(X1[i + 1], Y1[i + 1]);
		dyi = (h / 24)*(9.0 * fi1 + 19.0 * f1 - 5.0 * f2 + f3);
		Y1[i + 1] = Y1[i] + dyi; //corrector
	}
	int delta = (int)(n - 1) / (X.size() - 1);
	vector <valarray<double>> Y;
	for (int i = 0; i < X.size(); i++) {
		if (delta * i < n) Y.push_back(Y1[delta*i]);
	}
	return Y;
}

vector <valarray<double>> Solution::adams4(vector<double> X, int n, valarray<double> Y0Init) {
	double h = (b0 - a0) / (n - 1);
	vector<double> X1;
	for (int i = 0; i < n; i++)
		X1.push_back(a0 + h * i);
	vector<valarray<double>> Y1;
	Y1.resize(n);
	Y1[0] = Y0Init;
	vector<valarray<double>> eta;
	eta.resize(4); //TODO: make const like 'RungeOrder'
	valarray<double> dyi;
	for (int i = 0; i < 3; i++) {
		eta[0] = f(X1[i], Y1[i]);
		eta[1] = f(X1[i] + h / 2, Y1[i] + (h / 2)*eta[0]);
		eta[2] = f(X1[i] + h / 2, Y1[i] + (h / 2)*eta[1]);
		eta[3] = f(X1[i] + h, Y1[i] + h * eta[2]);
		dyi = (h / 6)*(eta[0] + 2.0 * eta[1] + 2.0 * eta[2] + eta[3]);
		Y1[i + 1] = Y1[i] + dyi;
		//Y1[i + 1] = Y1[i] + h*eta[0]; //simple Euler's method
	}
	valarray<double> f1, f2, f3, f4;
	for (int i = 3; i < n - 1; i++) {
		f1 = f(X1[i], Y1[i]);
		f2 = f(X1[i - 1], Y1[i - 1]);
		f3 = f(X1[i - 2], Y1[i - 2]);
		f4 = f(X1[i - 3], Y1[i - 3]);
		dyi = (h / 24)*(55.0 * f1 - 59.0 * f2 + 37.0 * f3 - 9.0 * f4);
		Y1[i + 1] = Y1[i] + dyi;
	}
	int delta = (int)(n - 1) / (X.size() - 1);
	vector <valarray<double>> Y;
	for (int i = 0; i < X.size(); i++) {
		if (delta * i < n) Y.push_back(Y1[delta*i]);
	}
	return Y;
}

vector <valarray<double>> Solution::border(vector<double> X0, int n, method mtd) {
	Y0u = { 0, 1 };
	Y0v = { A, 0 };
	//Y = CU(x) + V(x)
	vector<valarray<double>> U;
	vector<valarray<double>> V;
	switch (mtd) {
	case RKuttaBorder:
		U = rungeKutta(X0, n, Y0u);
		V = rungeKutta(X0, n, Y0v);
		break;
	case Adams4Border:
		U = adams4(X0, n, Y0u);
		V = adams4(X0, n, Y0v);
		break;
	case Adams44Border:
		U = adams44(X0, n, Y0u);
		V = adams44(X0, n, Y0v);
		break;
	default:
		return {};
	}
	double ub = U[U.size()-1][0];
	double vb = V[V.size()-1][0];
	//y(b)=B => B=C*ub+vb
	double C = (B - vb) / ub;
	cout << "C=" << C << " n=" << n << endl;
	vector<valarray<double>> Y;
	for (int i = 0; i < V.size(); i++) {
		Y.push_back(V[i] + C * U[i]);
	}
	return Y;
}

vector <valarray<double>> Solution::rungeKutta(vector<double> X, int n, valarray<double> Y0Init) {
	double h = (b0 - a0) / (n - 1);
	vector<double> X1;
	for (int i = 0; i < n; i++)
		X1.push_back(a0 + h * i);
	vector<valarray<double>> Y1;
	Y1.resize(n);
	Y1[0] = Y0Init;
	vector<valarray<double>> eta;
	eta.resize(4); //TODO: make const like 'RungeOrder'
	valarray<double> dyi;
	for (int i = 0; i < n - 1; i++) {
		eta[0] = f(X1[i], Y1[i]);
		eta[1] = f(X1[i] + h / 2, Y1[i] + (h / 2)*eta[0]);
		eta[2] = f(X1[i] + h / 2, Y1[i] + (h / 2)*eta[1]);
		eta[3] = f(X1[i] + h, Y1[i] + h * eta[2]);
		dyi = (h / 6)*(eta[0] + 2.0 * eta[1] + 2.0 * eta[2] + eta[3]);
		Y1[i + 1] = Y1[i] + dyi;
		//Y1[i + 1] = Y1[i] + h*eta[0]; //simple Euler's method
	}
	int delta = (int)(n - 1) / (X.size() - 1);
	vector <valarray<double>> Y;
	for (int i = 0; i < X.size(); i++) {
		if (delta * i < n) Y.push_back(Y1[delta*i]);
	}
	return Y;
}

vector<vector<double>> Solution::dev(int n0, int m, method mtd) {
	double h0 = (b0 - a0) / (n0 - 1);
	vector<double> X0;
	vector <valarray<double>> Yprecise;
	for (int i = 0; i < n0; i++) {
		X0.push_back(a0 + h0 * i);
		Yprecise.push_back(F(X0[i]));
	}
	assert(X0[n0 - 1] == b0);
	vector<vector<double>> Delta;
	Delta.resize(m);
	int n = n0;
	for (int i = 0; i < m; i++) {
		vector<valarray<double>> Y;
		switch (mtd) {
		case Adams44:
			Y = adams44(X0, n, Y0);
			break;
		case Adams4:
			Y = adams4(X0, n, Y0);
			break;
		case RKutta:
			Y = rungeKutta(X0, n, Y0);
			break;
		default:
			Y = border(X0, n, mtd);
		}
		for (int j = 0; j < n0; j++)
			Delta[i].push_back(Y[j][0] - Yprecise[j][0]);
		n = n * 2 - 1;
	}
	return Delta;
}

vector<vector<double>> Solution::devPerturb(double dy, int n, int m, method mtd, toChange toPerturb) {
	vector<vector<double>> Dev0 = dev(n, m, mtd);
	Y0[0] += dy;
	A += dy;
	vector<vector<double>> Dev = dev(n, m, mtd);
	for (int i = 0; i < m; i++) {
		for (int j = 0; j < n; j++)
			Dev[i][j] -= Dev0[i][j];
	}
	Y0[0] -= dy;
	A -= dy;
	return Dev;
}