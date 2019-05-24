#include<cassert>
#include<iostream>
#include"rungeKutta.h"
using namespace std;

jAns Solution::rkRungeEstimate(double eps){
	int n0 = 2; //starting points number
	int m = 22; //max number of iterations: if more required, we consider that integral doesn't converge
	double h0 = b0-a0;
	vector<double> X0;
	X0.push_back(a0); //for n0 = 2
	X0.push_back(b0); // for n0 = 2
	vector<vector<double>> Y;
	Y.resize(m);
	int n = n0;
	jAns res;
	for(int i=0; i<m; i++){
		Y[i] = rungeKutta(X0, n);
		n = n * 2 - 1;
		double control;
		if (i > 0) control = Y[i][n0-1] - Y[i-1][n0-1];
		if(i > 0 && Y[i][n0-1] - Y[i-1][n0-1] < 16*eps){
			res.steps = i;
			res.data = Y[i][n0-1];
			return res;
		}
	}
	res.steps = -1; //means "doesn't converge"
	return res;

}

vector<vector<double>> Solution::rungeDev (int n0, int m, method mtd){
	double h0 = (b0-a0)/(n0-1);
	vector<double> X0;
	vector<double> Yprecize;
	for(int i=0; i<n0; i++){
		X0.push_back(a0 + h0*i);
		Yprecize.push_back(F(X0[i]));
	}
	assert(X0[n0-1] == b0);
	vector<vector<double>> Delta;
	Delta.resize(m);
	//Delta = zeros(m,n);
	int n = n0;
	for(int i=0; i<m; i++){
		vector<double> Y;
		switch (mtd){
		case Adams4:
			Y = adams4(X0, n);
			cout << "Y = adams4" << endl;
			break;
		default: 
			Y = rungeKutta(X0, n);
			cout << "Y = rungeKutta" << endl;
		}
		for(int j=0; j<n0; j++)
			Delta[i].push_back(Y[j]-Yprecize[j]);
		n = n * 2 - 1;
	}
	return Delta;
}

vector <double> Solution::rungeKutta(vector<double> X, int n){
	double h = (b0-a0)/(n-1);
	//cout << "h: " << h << endl;
	vector<double> X1;
	for(int i=0; i<n; i++)
		X1.push_back(a0 + h*i);
	vector<double> Y1;
	Y1.resize(n);
	Y1[0] = y0;
	double n1i, n2i, n3i, n4i, dyi;
	for(int i=0; i<n-1; i++){
		n1i = f(X1[i], Y1[i]);
		n2i = f(X1[i] + h/2, Y1[i] + (h/2)*n1i);
		n3i = f(X1[i] + h/2, Y1[i] + (h/2)*n2i);
		n4i = f(X1[i] + h, Y1[i] + h*n3i);
		dyi = (h/6)*(n1i+2*n2i+2*n3i+n4i);
		Y1[i+1] = Y1[i] + dyi; 
	}
	int delta = (int)(n-1)/(X.size()-1);
	/*cout << "delta: " << delta << endl;
	cout << "n: " << n << endl;
	cout << "X.size(): " << X.size() << endl;*/
	vector <double> Y;
	for (int i=0; i<X.size(); i++){
		if(delta * i < n) Y.push_back(Y1[delta*i]);
		//cout << i << ": X[i]: " << X[i];
		//cout << ", X1[delta*i]: " << X1[delta*i] << endl;
	}
	return Y;
}

vector<vector<double>> Solution::devPerturb(double dy, int n0, int m) { //this function is not optimized
	double h0 = (b0-a0)/(n0-1);
	vector<double> X0;
	for(int i=0; i<n0; i++)X0.push_back(a0 + h0*i);
	assert(X0[n0-1] == b0);
	vector<vector<double>> Delta;
	Delta.resize(m);
	//Delta = zeros(m,n);
	int n = n0;
	for(int i=0; i<m; i++){
		double y0tmp = y0;
		y0 = y0 + dy;
		vector<double> Y = rungeKutta(X0, n);
		y0 = y0tmp;
		vector<double> Y0 = rungeKutta(X0, n);
		for(int j=0; j<n0; j++)
			Delta[i].push_back(Y[j]-Y0[j]);
		n = n * 2 - 1;
	}
	return Delta;
}