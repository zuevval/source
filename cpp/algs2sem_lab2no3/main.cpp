#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <climits>

using namespace std;
enum draughtMove{
    leftMv=-1, centerMv, rightMv
};
/*
const int N = 1000;
int A[N][N];
int T[N][N];*/

//int process(std::istream&, std::ostream&);//by ref
int process(std::istream *, std::ostream *);//by ref

int main() {
    ifstream in;
    in.open("input.txt");
    if(!in){
        cerr << "oops, file not found";
        return 0;
    }
    int res = process(&in, &cout);//ref
    in.close();
    return res;
}


int process(std::istream * in, std::ostream * out){//ref
    size_t n;
    *out << "enter n (positive integer):" << endl;
    *in >> n;
    if(n <= 1){
        *out << "moves impossible, field too small";
        return 0;
    }

    vector<vector<int>> A;
    A.reserve(n);
    for (auto& col : A)
        col.reserve(n);


    *out << "enter matrix values one by one:" << endl;
    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++)
        {
            int tmp; *in >> tmp;
            A[i].push_back(tmp);
        }
    }

    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++)
            *out << A[i][j] << " ";
        *out << endl;
    }

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

    vector<vector<int>> T;
    T.reserve(n);
    for (auto& col : T)
        col.reserve(n);

    for(int j = 0; j < n; j++)
        T[0].push_back(A[0][j]);
    for(int i=1; i<n; i++){
        T[i].push_back(max(T[i-1][0], T[i-1][1]) + A[i][0]);
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
    vector<int> path;
    path.reserve(n - 1);
    for(int i=n-2; i>=0; i--){ //push_back
        path.push_back((int)P[i][j]);
        j+= (int)P[i][j];
    }
    reverse(path.begin(), path.end()); // O(n) :(
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

