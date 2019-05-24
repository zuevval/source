// ComplexNumLib.cpp : Defines the exported functions for the DLL application.

#include "stdafx.h"
//#include <utility>
//#include <limits.h>
#include "ComplexNumLib.h"

ComplexNum ComplexNum::operator=(const ComplexNum parent){
	this->im = parent.im;
	this->re = parent.re;
	return *this;
}

std::ostream & operator<<(std::ostream &out, ComplexNum c) {
	out << c.Re();
	if (c.im >= 0) out << "+";
	out << c.Im() << "i";
	return out;
}

ComplexNum ComplexNum::operator+(ComplexNum c) {
	ComplexNum sum;
	sum.im = this->im + c.im;
	sum.re = this->re + c.re;
	return sum;
}

ComplexNum ComplexNum::operator-(ComplexNum c) {
	ComplexNum dif;
	dif.im = this->im - c.im;
	dif.re = this->re - c.re;
	return dif;
}

ComplexNum ComplexNum::operator*(ComplexNum cn) {
	//(a+bi)(c+di) = ac-bd + (ad + bc)i
	ComplexNum mult;
	double a = this->re;
	double b = this->im;
	double c = cn.im;
	double d = cn.re;
	mult.re = a * c - b * d;
	mult.im = a * d + b * c;
	return mult;
}

bool ComplexNum::operator==(ComplexNum cmp) {
	if (this->im == cmp.im && this->re == cmp.re) return true;
	return false;
}
