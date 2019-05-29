#include<iostream>
#include<string>
using namespace std;
class base {
	string getType() { return " type is base "; };
public:
	void f1() { cout << "base.f1" << this->getType() << endl; };
	void f2() { cout << "base.f2" << this->getType() << endl; };
	virtual void f3() { cout << "base.f3" << this->getType() << endl; };
	virtual void f4() { cout << "base.f4" << this->getType() << endl; };
};

class derived :public base {
	string getType() { return " type is derived "; };
public:
	void f1() { cout << "derived.f1" << this->getType() << endl; };
	virtual void f2() { cout << "derived.f2" << this->getType() << endl; };
	void f3() { cout << "derived.f3" << this->getType() << endl; };
	virtual void f4() { cout << "derived.f4" << this->getType() << endl; };
};

int main(void) {
	base b;
	b.f1();
	b.f2();
	b.f3();
	b.f4();
	derived d;
	d.f1();
	d.f2();
	d.f3();
	d.f4();
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
