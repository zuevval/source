//
// Created by zuevval on 29.03.19.
//

#ifndef AUX_DISCRETE_TESTS_FACTORIAL_H
#include<stdio.h>
#include<stdlib.h>
#include<limits.h>

//unsigned int factRecur(unsigned int n);
//unsigned int factIter(unsigned int n);
unsigned int factRecur(unsigned int n) {
    unsigned int res;
    if (n == 1 || n == 0)
        return 1;
    res = factRecur(n - 1);
    if (res == 0 || UINT_MAX / n < res)
        return 0;
    return n * factRecur(n - 1);
}

unsigned int factIter(unsigned int n) {
    unsigned int res = 1;
    int i;
    if (n == 1 || n == 0)
        return 1;
    for (i = 2; i <= n; i++) {
        if (UINT_MAX / i < res)
            return 0;
        res *= i;
    }
    return res;
}
#define AUX_DISCRETE_TESTS_FACTORIAL_H

#endif //AUX_DISCRETE_TESTS_FACTORIAL_H
