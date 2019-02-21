#include <iostream>
#include <fstream>
#include <cmath>
#define ERR_FLAG (-1)
using namespace std;
int lin_eq (const double k, const double b, double *x){ //kx+b=0
    int iserr = 0;
    if(k == 0){
        iserr = ERR_FLAG;
        return iserr;
    }
    *x = -b/k;
    return *x;
}


int sqr_eq (const double a, const double b, const double c, double *x1, double *x2){ //ax^2+bx+c=0
    int iserr = 0;
    if(a==0){
        iserr = lin_eq(b, c, x1);
        *x2 = * x1;
        return iserr;
    }
    double d = b*b-4*a*c;
    if (d < 0){
        iserr = ERR_FLAG;
        return iserr;
    }
    *x1 =0.5*(-b+sqrt(d));
    *x2 =0.5*(-b-sqrt(d));
    return iserr;
}

int main(int argc, char* argv[]) {
    ifstream in("input.txt");
    if(!in){
        cout << "oops, file not found";
        return 0;
    }
    double a, b, c, x1, x2;
    int err = 0;
    if(!(in >> a)) { cout << "no a"; return 0;}
    if(!(in >> b)) { cout << "no b"; return 0;}
    if(!(in >> c)) { cout << "no c"; return 0;}
    int iserr = sqr_eq(a, b, c, &x1, &x2);
    cout << "x1=";
    cout << x1;
    cout << "\nx2=";
    cout << x2;
    return 0;
}