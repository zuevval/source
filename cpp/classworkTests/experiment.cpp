#include<iostream>
#include<string>
using namespace std;
class base {
	string getType() { return " type is base "; };
public:
	void f1() { cout << "base.f1" << getType() << endl; };
	void f2() { cout << "base.f2" << getType() << endl; };
	virtual void f3() { cout << "base.f3" << getType() << endl; };
	virtual void f4() { cout << "base.f4" << getType() << endl; };
};

class derived :public base {
	string getType() { return " type is derived "; };
public:
	void f1() { cout << "derived.f1" << getType() << endl; };
	virtual void f2() { cout << "derived.f2" << getType() << endl; };
	void f3() { cout << "derived.f3" << getType() << endl; };
	virtual void f4() { cout << "derived.f4" << getType() << endl; };
};

int main(void) {
	base b;
	derived d;
	b = d;
	b.f1();
	b.f2();
	b.f3();
	b.f4();
	base * bp = &d;
	bp->f1();
	bp->f2();
	bp->f3();
	bp->f4();
	//derived * dp = &b; //error
	//d = b; //error

}
