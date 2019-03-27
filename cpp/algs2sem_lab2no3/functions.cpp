//
// Created by zuevval on 27.03.19.
//
#include"functions.h"

void calcMoves(
        const int n,
        const std::vector<std::vector<int>> & A,
        std::vector<std::vector<int>> & T,
        std::vector<std::vector<draughtMove>> & P){
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
    for (int j = 0; j < n; j++)
        T[0].push_back(A[0][j]);
    for (int i = 1; i < n; i++) {
        T[i].push_back(std::max(T[i + mvBack][0], T[i + mvBack][0 + rightMv]) + A[i][0]);
        if (T[i + mvBack][0] > T[i + mvBack][0 + rightMv])
            P[i + mvBack].push_back(centerMv); //P[i-1][0]
        else
            P[i + mvBack].push_back(rightMv); //P[i-1][0]
        for (int j = 1; j < n - 1; j++) {
            T[i][j] = std::max(T[i + mvBack][j + leftMv], std::max(T[i + mvBack][j], T[i + mvBack][j + rightMv])) + A[i][j];
            if (T[i + mvBack][j] > std::max(T[i + mvBack][j + leftMv], T[i + mvBack][j + rightMv]))
                P[i + mvBack].push_back(centerMv); //P[i - 1][j]
            else if (T[i + mvBack][j + rightMv] > std::max(T[i + mvBack][j + leftMv], T[i + mvBack][j]))
                P[i + mvBack].push_back(rightMv); //P[i - 1][j]
            else
                P[i + mvBack].push_back(leftMv); //P[i - 1][j]
        }
        T[i][n - 1] = std::max(T[i + mvBack][n - 1 + leftMv], T[i + mvBack][n - 1]) + A[i][n - 1];
        if (T[i + mvBack][n - 1] > T[i + mvBack][n - 1 + leftMv])
            P[i + mvBack].push_back(centerMv); //P[i - 1][n - 1]
        else
            P[i + mvBack].push_back(leftMv); //P[i - 1][n - 1]
    }
}

void printMoves(const int n,
                const std::vector<std::vector<int>> & A,
                std::vector<std::vector<draughtMove>> & P,
                std::ostream & out){
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
}

void printMaxProfitPath(const int n,
                        const std::vector<std::vector<int>> & A,
                        std::vector<std::vector<int>> & T,
                        std::vector<std::vector<draughtMove>> & P,
                        std::ostream & out){
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
}