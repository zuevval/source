#include<iostream>
#include<string>
using namespace std;

class base {
	string name;
public:
	virtual ~base(){ cout << "~base" << endl;};
};

class derived : public base {
	base * nestedBase;
public:
	derived() {
		nestedBase = new base();
	};
	virtual ~derived() {
		delete(nestedBase);
		cout << "~derived" << endl; 
	};
};

int main(void) {
	base * b = new derived;
	delete(b);
}