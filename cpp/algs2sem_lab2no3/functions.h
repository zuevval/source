//
// Created by zuevval on 27.03.19.
//

#ifndef ALGS2SEM_LAB2NO3_FUNCTIONS_H
#define ALGS2SEM_LAB2NO3_FUNCTIONS_H
#include <iostream>
#include <fstream>
#include <climits>
#include <algorithm>
#include <vector>

enum draughtMove {
    leftMv = -1, centerMv, rightMv
};
const int mvBack = -1;
const int mvForth = 1;

void calcMoves(
        const int n,
        const std::vector<std::vector<int>> & A,
        std::vector<std::vector<int>> & T,
        std::vector<std::vector<draughtMove>> & P);

void printMoves(const int n,
                const std::vector<std::vector<int>> & A,
                std::vector<std::vector<draughtMove>> & P,
                std::ostream & out);

void printMaxProfitPath(const int n,
                        const std::vector<std::vector<int>> & A,
                        std::vector<std::vector<int>> & T,
                        std::vector<std::vector<draughtMove>> & P,
                        std::ostream & out);

#endif //ALGS2SEM_LAB2NO3_FUNCTIONS_H
