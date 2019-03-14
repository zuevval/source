#include <iostream>
#include <algorithm>
#include <bits/stdc++.h>

using namespace std;
enum draughtMove{
    leftMv=-1, centerMv, rightMv
};

int process(std::istream *, std::ostream *);

int main() {
    ifstream in;
    in.open("input.txt");
    if(!in){
        cout << "oops, file not found";
        return 0;
    }
    int res = process(&in, &cout);
    in.close();
    return res;
}


int process(std::istream * in, std::ostream * out){
    unsigned int n;
    *out << "enter n (positive integer):" << endl;
    *in >> n;
    if(n<=1){
        *out << "moves impossible, field too small";
        return 0;
    }

    int A [n][n];
    *out << "enter matrix values one by one:" << endl;
    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++)
            *in >> A[i][j];
    }

    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++)
            *out << A[i][j] << " ";
        *out << endl;
    }

    int T[n][n];
    draughtMove P[n-1][n];

    /*
     *  table:
     *
     *  *    j 0 1 2 3 ...
     *  i        / |\
     *  0     r(2) c  l(0)
     *  1
     *  2   l(0) c(1) r(2)
     *  3       \ |/
     *  4
     *  ...
     * */

    for(int j = 0; j < n; j++)
        T[0][j] = A[0][j];
    for(int i=1; i<n; i++){
        T[i][0] = max(T[i-1][0], T[i-1][1]) + A[i][0];
        if(T[i-1][0]>T[i-1][1])
            P[i-1][0] = centerMv;
        else
            P[i-1][0] = rightMv;
        for(int j = 1; j < n-1; j++){
            T[i][j] = max(T[i-1][j-1], max(T[i-1][j], T[i-1][j+1])) + A[i][j];
            if(T[i-1][j] > max(T[i-1][j-1],T[i-1][j+1]))
                P[i-1][j] = centerMv;
            else if(T[i-1][j+1] > max(T[i-1][j-1],T[i-1][j]))
                P[i-1][j] = rightMv;
            else
                P[i-1][j] = leftMv;
        }
        T[i][n-1] = max(T[i-1][n-2], T[i-1][n-1]) + A[i][n-1];
        if(T[i-1][n-1]>T[i-1][n-2])
            P[i-1][n-1] = centerMv;
        else
            P[i-1][n-1] = leftMv;
    }
    for(int i=0; i<n-1; i++){
        for(int j=0; j<n; j++){
            if(P[i][j] == centerMv)
                *out << "| ";
            else if(P[i][j] == rightMv)
                *out << "/ ";
            else
                *out << "\\ ";
        }
        *out << endl;
    }


    int maxCache = INT_MIN;
    int finishIndex = 0;
    for(int j=0; j<n; j++){
        if(T[n-1][j] > maxCache){
            finishIndex = j;
            maxCache = T[n-1][j];
        }
    }
    *out <<"points collected by draught: " << maxCache << endl;

    int j = finishIndex;
    int * path = new int(n - 1);
    for(int i=n-2; i>=0; i--){
        path[i] = (int)P[i][j];
        j+= (int)P[i][j];
    }
    for(int i=0; i<n-1; i++){
        if(path[i] == centerMv)
            *out << "| "<<endl;
        else if(path[i] == rightMv)
            *out << "/ "<<endl;
        else
            *out << "\\ "<<endl;
    }
    cout << finishIndex << endl;

    return 0;
}

