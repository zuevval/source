#include <iostream>

class bfun { //Boolean function
public:
    char * name;
    int argsno; //number of input arguments

};

int main() {
    //std::cout << "Hello, World!" << std::endl;
    bfun myand;
    myand.argsno = 2;
    return 0;
}