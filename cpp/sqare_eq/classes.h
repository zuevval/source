#ifndef H_CLASSES
#define H_CLASSES

#include <iostream>
#include <fstream>
#include <sstream>
#include<string>
#include <cmath>
#include <queue>
#include <map>

struct eqCoefs {
	double a;
	double b;
	double c;
};

struct eqRoots {
	int rootsQty;
	double x1;
	double x2;
};

class sqEquation {
private:
	eqCoefs abc;
	eqRoots roots;
	void solve();
public:
	sqEquation(eqCoefs abc);
	eqRoots printRoots();
};

struct ansInfo {
	std::string name;
	bool isCorrect;
};

/*
enum studType {
	bad, mid, good
};*/

struct student {
	int solved;
	int failed;
};

struct letter {
	eqCoefs eq;
	eqRoots ans;
	std::string name;
};

class inbox {
private:
	std::queue <letter> newMail;
protected:
	ansInfo checkNext();
public:
	void put(letter l);
};

class teacher:public inbox{
private:
	std::map <std::string, student> studs;
public:
	void putMany(std::istream & in);
	void checkAll();
	void printStat(std::ostream & out);
};

#endif
