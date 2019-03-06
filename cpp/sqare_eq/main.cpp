#include <iostream>
#include <fstream>
#include <cmath>
#define ERR_FLAG (-1)
using namespace std;

struct eq_roots{
    int roots_qty;
    double x1;
    double x2;
};

class my_equation{
private:
    double a;
    double b;
    double c;
    eq_roots roots;
    void solve();
public:
    friend istream &operator>>(istream &in, my_equation * eq);
    void print_roots();
};

void lin_eq (const double k, const double b, eq_roots * eq_rts) { //kx+b=0
    if (k == 0) {
        eq_rts->roots_qty = 0;
        return;
    }
    eq_rts->roots_qty = 1;
    eq_rts->x1 = -b / k;
    eq_rts->x2 = eq_rts->x1;
}

int main(int argc, char* argv[]) {
    ifstream in("input.txt");
    if(!in){
        cout << "oops, file not found";
        return 0;
    }
    my_equation eq1;
    in >> &eq1;
    eq1.print_roots();
    return 0;
}

istream &operator>>(istream &in, my_equation * eq){
    if(!in){
        cout << "oops, wrong input stream";
        return in;
    }
    double a, b, c;
    if(!(in >> a)) { cout << "no a"; return in;}
    if(!(in >> b)) { cout << "no b"; return in;}
    if(!(in >> c)) { cout << "no c"; return in;}
    eq->a = a;
    eq->b = b;
    eq->c = c;
    eq->solve();
    return in;
}

void my_equation::solve() {
    double a = this->a;
    double b = this->b;
    double c = this->c;
    if(a==0){
        lin_eq(b, c, &(this->roots));
        return;
    }
    double d = b*b-4*a*c;
    if (d < 0){
        this->roots.roots_qty = 0;
        return;
    }
    this->roots.x1 =0.5*(-b+sqrt(d));
    this->roots.x2 =0.5*(-b-sqrt(d));
    if(this->roots.x1 == this->roots.x2)
        this->roots.roots_qty = 1;
    else
        this->roots.roots_qty = 2;
}

void my_equation::print_roots() {
    if(this->roots.roots_qty){
        cout << "x1=";
        cout << this->roots.x1;
        if(this->roots.roots_qty > 1){
            cout << "\nx2=";
            cout << this->roots.x2;
        }
    } else
        cout << "no roots in real numbers";
}