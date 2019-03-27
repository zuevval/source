#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <climits>
//TODO: make gtests
//TODO: check with valgrind

enum draughtMove {
    leftMv = -1, centerMv, rightMv
};

int process(std::istream &, std::ostream &);

int main() {

    std::ifstream in;
    in.open("input.txt");
    if (!in) {
        std::cerr << "oops, file not found";
        return 0;
    }
    int res = process(in, std::cout);
    in.close();
    return res;
}


int process(std::istream& in, std::ostream& out) {
    size_t n;
    out << "enter n (positive integer):" << std::endl;
    in >> n;
    if (n <= 1) {
        out << "moves impossible, field too small";
        return 0;
    }

    std::vector<std::vector<int>> A;
    A.reserve(n);
    for (std::vector<int> &col : A)
        col.reserve(n);


    out << "enter matrix values one by one:" << std::endl;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            int tmp;
            in >> tmp;
            A[i].push_back(tmp);
        }
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++)
            out << A[i][j] << " ";
        out << std::endl;
    }

    std::vector<std::vector<draughtMove>> P; //P[n-1][n]
    P.reserve(n-1);
    for(std::vector<draughtMove> & p : P)
        p.reserve(n);

    /*
     *  table:
     *
     *       j 0 1 2 3 ...
     *  i        / |\
     *  0     r(1) c  l(-1)
     *  1
     *  2   l(-1) c(0) r(1)
     *  3       \ | /
     *  4
     *  ...
     * */

    std::vector<std::vector<int>> T;
    T.reserve(n);
    for (auto &col : T)
        col.reserve(n);

    //TODO: make separate function that calculates T
    //TODO: eliminate magic numbers
    const int mvBack = -1;
    const int mvForth = 1;
    for (int j = 0; j < n; j++)
        T[0].push_back(A[0][j]);
    for (int i = 1; i < n; i++) {
        T[i].push_back(std::max(T[i + mvBack][0], T[i + mvBack][0 + rightMv]) + A[i][0]);
        if (T[i + mvBack][0] > T[i + mvBack][0 + rightMv])
            P[i + mvBack].push_back(centerMv); //P[i-1][0]
        else
            P[i + mvBack].push_back(rightMv); //P[i-1][0]
        for (int j = 1; j < n - 1; j++) {
            T[i][j] = std::max(T[i - 1][j - 1], std::max(T[i + mvBack][j], T[i + mvBack][j + rightMv])) + A[i][j];
            if (T[i + mvBack][j] > std::max(T[i + mvBack][j - 1], T[i + mvBack][j + 1]))
                P[i + mvBack].push_back(centerMv); //P[i - 1][j]
            else if (T[i + mvBack][j + 1] > std::max(T[i + mvBack][j +leftMv], T[i + mvBack][j]))
                P[i + mvBack].push_back(rightMv); //P[i - 1][j]
            else
                P[i + mvBack].push_back(leftMv); //P[i - 1][j]
        }
        T[i][n - 1] = std::max(T[i + mvBack][n - 1 + leftMv], T[i + mvBack][n - 1]) + A[i][n - 1];
        if (T[i + mvBack][n - 1] > T[i + mvBack][n - 2])
            P[i + mvBack].push_back(centerMv); //P[i - 1][n - 1]
        else
            P[i + mvBack].push_back(leftMv); //P[i - 1][n - 1]
    }
    out << std::endl;

    //TODO: make separate func "printMovesMatrix"

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++)
            out << T[i][j] << " ";
        out << std::endl;
    }

    for (int i = 0; i < n - 1; i++) {
        for(int j=0; j<n; j++)
            out << A[i][j] << " ";
        out << std::endl;
        for (int j = 0; j < n; j++) {
            if (P[i][j] == centerMv)
                out << "| ";
            else if (P[i][j] == rightMv)
                out << " /";
            else
                out << "\\ ";
        }
        out << std::endl;
    }
    for(int j=0; j<n; j++)
        out << A[n-1][j] << " ";
    out << std::endl;


    int maxCache = INT_MIN;
    int finishIndex = 0;
    for (int j = 0; j < n; j++) {
        if (T[n - 1][j] > maxCache) {
            finishIndex = j;
            maxCache = T[n - 1][j];
        }
    }
    out << "points collected by draught: " << maxCache << std::endl;

    int j = finishIndex;
    std::vector<int> path;
    path.reserve(n - 1);
    for (int i = n - 2; i >= 0; i--) {
        path.push_back((int) P[i][j]);
        j += (int) P[i][j];
    }
    reverse(path.begin(), path.end()); // O(n) :(
    for (int i = 0; i < n - 1; i++) {
        if (path[i] == centerMv)
            out << "| " << std::endl;
        else if (path[i] == rightMv)
            out << "/ " << std::endl;
        else
            out << "\\ " << std::endl;
    }
    out << finishIndex << "(" << A[n-1][finishIndex] << ")" << std::endl;
    return 0;
}

