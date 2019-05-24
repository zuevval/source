#include<iostream>
#include<fstream>
#include<vector>
#include "rungeKutta.h"
using namespace std;

double f1 (double x, double y){
	return x * x + 2 * x + y / (x + 2);
	//return x * x + 2 * x - y;
}

double F1 (double x){
	return (x + 2)*(x*x / 2 + 1);
	//return x*x;
}

double f2(double x, double y) {
	return x * x + 2 * x + y / (x + 2);
}

double F2(double x) {
	return (x + 2)*(x*x / 2 + 1);
}

void process(istream & in) {
	double a0 = -1;
	double b0 = 1;
	double y0 = 1.5;
	ofstream out("output.txt");
	//double y0 = 1;
	Solution s(f1, F1, a0, b0, y0);
	cout << "choose method:" << endl
		<< "1 - Runge-Kutta" << endl
		<< "2 - Adams (explicit)" << endl
		<< "3 - Adams (implicit, predictor - 3 rank, corrector - 4)" << endl
		<< "4 - Adams (implicit, predictor - 4 rank, corrector - 4)" << endl;
	int mtdBuf;
	in >> mtdBuf;
	method mtd = RKutta;
	switch (mtdBuf) {
	case 1: 
		mtd = RKutta;
		break;
	case 2: 
		mtd = Adams4;
		break;
	case 3: 
		mtd = Adams34;
		break;
	case 4: 
		mtd = Adams44;
		break;
	default:
		cout << "wrong format: input between 1 and 4, entered " << mtdBuf << endl;
		return;
	}
	cout << "enter number of control points:" << endl;
	int n;
	in >> n;
	cout << "enter number of iterations:" << endl;
	int m;
	in >> m;
	vector<vector<double>> Dif = s.rungeDev(n, m, mtd);
	cout << "deviation in control points:" << endl;
	cout.precision(2);
	/*
	for(auto & row: Dif){
		for (double y: row) cout << y << " ";
		cout << endl;
	}*/
	for (int i = 0; i < Dif.size(); i++) {
		for (int j = 0; j < (Dif[i]).size(); j++) cout << Dif[i][j] << " ";
		for (int j = 0; j < (Dif[i]).size(); j++) out << Dif[i][j] << " ";
		cout << endl;
		out << endl;
	}
	double eps;
	while (true) {
		cout << "enter epsilon (0=exit):" << endl;
		in >> eps;
		if (eps == 0) break;
		jAns j1 = s.rkRungeEstimate(eps);
		cout << "integral:" << j1.data << endl;
		cout << "steps:" << j1.steps << endl;
	}
	double dif;
	while (true) {
		cout << "enter perturbation (0=exit):" << endl;
		in >> dif;
		if (dif == 0) break;
		out << "dif=" << dif << endl;
		Dif = s.devPerturb(dif, n, m);
		cout << "deviation from the same RungeKutta solution with initial y0 in control points:" << endl;
		cout.precision(3);
		/*
		for (auto & row : Dif) {
			for (double y : row) cout << y << " ";
			cout << endl;
		}*/
		for (int i = 0; i < Dif.size(); i++) {
			for (int j = 0; j < (Dif[i]).size(); j++) cout << Dif[i][j] << " ";
			for (int j = 0; j < (Dif[i]).size(); j++) out << Dif[i][j] << " ";
			cout << endl;
			out << endl;
		}
	}
	out.close();
}

int main(void){
	cout << "choose input: 1 - input.txt, 2 - std::cin" << endl;
	int inputType;
	cin >> inputType;
	if (inputType == 1) {
		ifstream in("input.txt");
		process(in);
		in.close();
	}
	else if (inputType == 2) {
		process(cin);
	}
	else {
		cout << "wrong format" << endl;
	}
	return 0;
}