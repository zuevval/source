#include<gtest/gtest.h>
#include"functions.h"


int main(){
    const int n = 2;
    std::vector<std::vector<int>> A;
    A.reserve(n);
    for (auto & row : A)
        row.reserve(n);
    A.push_back(std::vector<int>{0, 0});
    A.push_back(std::vector<int>{0, 0});
    std::vector<std::vector<draughtMove>> P;
    P.reserve(n-1);
    for (auto & row : P)
        row.reserve(n);
    std::vector<std::vector<int>> T;
    T.reserve(n);
    for (auto & row : T)
        row.reserve(n);
    calcMoves(n,A,T,P);
    return 0;
}
