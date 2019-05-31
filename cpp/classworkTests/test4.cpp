/**@author G. P.*/
#include <iostream>

class A {
public:
	A() { std::cout << "A" << std::endl; }
	A(const A &) { std::cout << "A->A" << std::endl; }
	virtual ~A() { std::cout << "~A" << std::endl; }
	virtual void f() { std::cout << "f(A)" << std::endl; }
};

class D : public A {
public:
	D() { std::cout << "D" << std::endl; }
	~D() { std::cout << "~D" << std::endl; }
	void f() { std::cout << "f(D)" << std::endl; }
private:
	A m_a;
};

class E : public D {
public:
	void f() { std::cout << "f(E)" << std::endl; }
	E() { std::cout << "E" << std::endl; }
	~E() { std::cout << "~E" << std::endl; }
};

template <class U, class T>
void do_some_stuff() {
	class C : public T {
	public:
		void f() { std::cout << "f(C)" << std::endl; }
	private:
		A m_a;
	};

	U * c = new C;
	c->f();
	delete c;
}

int main() {
	D d;
	E e;
	A a = d;
	do_some_stuff<D, E>();
}