/**@author Arsen Varisov
   @see https://github.com/zuevval/source/ */
   
#include <iostream>
class A11
{
public:
	A11() { std::cout << "A" << std::endl; m_x = 0; }
	A11(int) { std::cout << "A" << std::endl; m_x = 1; }
	A11(const A11&) { std::cout << "A->a" << std::endl; }
	~A11() { std::cout << "~A(" << m_x << ")" << std::endl; }
private: 
	int m_x;
};

class B11
{
public:
	B11() { std::cout << "B" << std::endl; }
	B11(const A11&) { std::cout << "A->B" << std::endl; }
	B11(const B11&) { std::cout << "B->B" << std::endl; }
	virtual void do_some_stuff() { std::cout << "BBB" << std::endl; }
	virtual ~B11() { std::cout << "~B" << std::endl; }
};

class C11 : public B11
{
public:
	C11() { std::cout << "C" << std::endl; m_pg = NULL; }
	C11(int) : m_f(0) { std::cout << "C" << std::endl; m_pg = NULL; }
	~C11() { std::cout << "~C" << std::endl; if (m_pg != NULL) delete m_pg; }
	template <class T>
	void do_some_new_stuff (T** output) {
		class D11 : public T {
		public:
			virtual void do_some_stuff() { std::cout << "TTT" << std::endl; }
		private:
			T m_t;
		};
		*output = new D11(this);
	}
	template <>
	void do_some_new_stuff (C11** output) {
		class D11 : public C11
		{
		public:
			D11() : m_t(0) { std::cout << "D" << std::endl; }
			virtual void do_some_studd() { std::cout << "DDD" << std::endl; }
			~D11() { std::cout << "~D" << std::endl; }
		private:
			C11 m_t;
		};
		m_pg = new B11(*this);
		*output = new D11;
	}
private:
	A11 m_f;
	B11 *m_pg;
};

int main()
{
	C11 h;
	C11* ph;
	h.do_some_new_stuff(&ph);
	ph->do_some_stuff();
	delete ph;
}