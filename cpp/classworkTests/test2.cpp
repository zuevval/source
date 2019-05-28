#include<iostream>

class A5 {
public:
	A5() { std::cout << "A" << std::endl; }
	A5(const A5&) { std::cout << "A->A" << std::endl; }
	A5& operator =(const A5&a) {
		std::cout << "A = A" << std::endl;
		return *this;
	}
	~A5() { std::cout << "~A" << std::endl; }
};

class B5 {
public:
	B5() { std::cout << "B5" << std::endl; }
	~B5() { std::cout << "~B5" << std::endl; }

	A5 get_A() { return a; }
	
	void do_some_stuff() {
		class C :public A5 {
		public:
			C() { std::cout << "C" << std::endl; }
			~C() { std::cout << "~C" << std::endl; }
		};
		C *c = new C;
		A5 *a = new A5(*c);
		delete c;
		delete a;
	}
private:
	A5 a;
};

int main(void) {
	B5 b;
	b.do_some_stuff();
}