#include <iostream>

using namespace std;

typedef enum BFType {
    VTab, PDNF, PCNF, RDNF, ZheP, Karn
};

class bfun {
private:
    int n;
    BFType btype;
    unsigned int *vtab; //truck table
    //unsigned int * pdnf; //СДНФ - совершенная дизъюнктивная нормальная форма
    //unsigned int * pcnf; //СКНФ - совершенная конъюнктивная нормальная форма
    unsigned int *rdnf; //РДНФ - редуцированная дизъюнктивная нормальная форма
    unsigned int *zhep; //коэффициенты полинома Жегалкина

public:
    bfun(int num, BFType initType = VTab);

    friend ostream &operator<<(ostream &st, bfun &data);

    friend istream &operator>>(istream &st, bfun &data);

    void convert(const unsigned int *input, const BFType convFrom, const BFType convTo, unsigned int *output);


};

int main(int argc, char *argv[]) {
    bfun b1(3);
    cout << b1;
    return 0;
}

ostream &operator<<(ostream &st, bfun &data) {
    st << data.n;
}

istream &operator>>(istream &st, bfun &data) {
    return st;
}

bfun::bfun(int num, BFType initType) {
    n = num;
    btype = initType;
}

