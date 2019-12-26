#include <iostream>

class base{
    static void a(){std::cout<<"base::a"<<std::endl;};
public:
    static void b(){a();};
};

class derived:public base{
    static void a(){std::cout<<"derived::a"<<std::endl;};
};

int main() {
    derived::b(); // output: 'base::a'
    return 0;
}