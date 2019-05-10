//
// Created by zuevval on 09.05.19.
//
#ifdef __cplusplus
extern "C" {
#endif

#include "func-all.h"

struct myUint {
    char isOverflow;
    unsigned int data;
};
typedef struct myUint myUint;

myUint cmn (unsigned int m, unsigned int n) {
    int i, j;
    unsigned int nmr=1; //numerator
    unsigned int dnm=1; //denominator
    myUint res;
    res.isOverflow = 0;
    if (m == 0 && n == 0) {
        res.data = 1;
        return res;
    }

    if (m == 0 || n > m) {
        res.data = 0;
        return res;
    }
    if (n == 1) {
        res.data = m;
        return res;
    }
    if (n > m / 2) return cmn(m, m - n);
    for (i = n; i >= 1; i--) {
        dnm *= i;
    }
    if(dnm == 0) {res.isOverflow = 1; return res;} //dnm == 0 <=> overflow
    for (i = n; i >=1; i--) {
        if ((m - i + 1) % dnm == 0) {
            if (UINT_MAX / ((m - i + 1) / dnm) > nmr) {
                nmr *= ((m - i + 1) / dnm);
                dnm = 1;
                continue;
            }
            else {
                res.isOverflow = 1;
                return res;
            }
        }
        if (UINT_MAX / (m - i + 1) > nmr) {
            nmr *= (m - i + 1);
        } else {
            res.isOverflow = 1;
            return res;
        }
        for (j = (int)sqrt((double)nmr)+1; j > 1; j--) {
            if (nmr % j == 0 && dnm % j == 0) {
                nmr /= j;
                dnm /= j;
            }
        }
    }
    res.data = nmr / dnm;
    return res;
}

unsigned int C(unsigned int m, unsigned int n){
    myUint res = cmn(m, n);
    if(res.isOverflow) return UINT_MAX;
    else return res.data;
}

unsigned int A(unsigned int m, unsigned int n) {
    int i;
    unsigned int res = 1;
    if(m == 0 && n == 0) return 1;
    if (m == 0 || n > m) return 0;
    if (m == 1)	return 1;

    for (i = 0; i < n; i++) {
        if (UINT_MAX / (m-i) > res) res *= m-i;
        else return UINT_MAX;
    }
    return res;
}

unsigned int P(unsigned int n) {
    int i;
    unsigned int res = 1;
    for (i = 1; i <= n; i++) {
        if (UINT_MAX / i > res) res *= i;
        else return UINT_MAX;
    }
    return res;
}

unsigned int U(unsigned int m, unsigned int n) {
    int i;
    unsigned int res = 1;
    if (m == 0) return 0;
    if (m == 1) return 1;
    for (i = 1; i <= n; i++) {
        if (UINT_MAX / m > res) res *= m;
        else return UINT_MAX;
    }
    return res;
}

myUint vmn(unsigned int m, unsigned int n) {
    myUint Cmn;
    unsigned int m1 = m + n - 1;
    if (m + n - 1 < 0) {
        Cmn.data = 0;
        return Cmn;
    }
    if (m1 > 0 && n > m1 / 2) Cmn = cmn(m1, m1 - n);
    else Cmn = cmn(m1, n);
    return Cmn;
}

unsigned int V(unsigned int m, unsigned int n){
    myUint res = vmn(m, n);
    if(res.isOverflow) return UINT_MAX;
    else return res.data;
}

unsigned int fib(unsigned int n) {
    int fib1=1, fib2=1, t, i;
    if (n == 1 || n == 2)
        return 1;
    for (i = 3; i <= n; i++) {
        if (UINT_MAX - fib1 < fib2) return UINT_MAX;
        t = fib1 + fib2;
        fib1 = fib2;
        fib2 = t;
    }
    return fib2;
}

#ifdef __cplusplus
}
#endif
