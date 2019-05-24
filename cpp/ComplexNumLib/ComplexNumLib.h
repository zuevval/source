#ifndef ZUEV_VALERII_H_COMPLEX_NUMBER
#define ZUEV_VALERII_H_COMPLEX_NUMBER

#ifdef COMPLEXNUMLIB_EXPORTS
#define COMPLEXNUMLIB_API __declspec(dllexport)
#else
#define COMPLEXNUMLIB_API __declspec(dllimport)
#endif

#include<cmath>
#include<iostream>

class COMPLEXNUMLIB_API ComplexNum {
	double re;
	double im;
public:
	ComplexNum() : re(0.0), im(0.0) {};
	ComplexNum(double r, double i) : re(r), im(i) {};
	double Re() { return re; };
	double Im() { return im; };
	double Abs() { return sqrt(im * im + re * re); };
	//operator double() { return re; }; //or return abs would be better?
	COMPLEXNUMLIB_API friend std::ostream & operator<<(std::ostream &out, ComplexNum c);
	ComplexNum operator+(ComplexNum);
	ComplexNum operator-(ComplexNum);
	ComplexNum operator*(ComplexNum);
	ComplexNum operator=(ComplexNum parent);
	bool operator==(ComplexNum);
	//TODO:- * / += -= *= /= >>
};

#endif
