#include<iostream>
#include"ComplexNumLib.h"
using namespace std;

int main(void) {
	ComplexNum a(1, 1);
	ComplexNum b(2,-3);
	cout <<"a, real part: " << a.Re() << endl;
	cout <<"a, imaginary part: " << a.Im() << endl;
	cout <<"a, absolute value: " << a.Abs() << endl;
	cout << "a: " << a << endl;
	a = a + b;
	cout << a << endl;
	cout << (a + b) << endl;
	a = a - b;
	cout << a << endl;
	a = a - (a - b);
	cout << a << endl;
	b = a;
	return 0;
}