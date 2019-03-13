#include <iostream>
#include <algorithm>
#include <bits/stdc++.h>

using namespace std;
enum move{
    left, center, right
};

int process(std::istream *, std::ostream *);

int main() {
    return process(&cin, &cout);
}


int process(std::istream * in, std::ostream * out){
    unsigned int n;
    *out << "enter n (positive integer):\n";
    *in >> n;
    if(n<=1){
        *out << "moves impossible, field too small";
        return 0;
    }

    int A [n][n];
    *out << "enter matrix values one by one:\n";
    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++) {
            *in >> A[i][j];
        }
    }

    int T[n][n];
    int P[n][n];


    for(int j=0; j<n; j++)
        T[0][j] = A[0][j];
    for(int i=1; i<n; i++){
        T[i][0] = max(T[i-1][0], T[i-1][1])+A[i][0];
        for(int j=1; j<n-1; j++)
            T[i][j] = max(T[i-1][j-1], max(T[i-1][j], T[i-1][j+1]))+A[i][j];
        T[i][n-1] = max(T[i-1][n-2], T[i-1][n-1])+A[i][n-1];
    }


    int maxCache = INT_MIN;
    int finishIndex = 0;
    for(int j=0; j<n; j++){
        if(T[n-1][j] > maxCache){
            finishIndex = j;
            maxCache = T[n-1][j];
        }
    }
    *out << maxCache;

    return 0;
}

