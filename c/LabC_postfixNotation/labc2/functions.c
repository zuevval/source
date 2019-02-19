#ifdef __cplusplus
extern "C" {
#endif

#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include"functions.h"

#ifndef MY_ABS1
#define MY_ABS1
#define Myabs(a) ((a)>=0 ? (a) : (-(a)))
#endif
#define ERR_FLAG (-1)
    //TODO: no external/static variables
char *resPtr = NULL;

char *skipBrackets(char *t, int len) {
    while (*t != ')'&&len-- > 1)
        t++;
    if (*t != ')') {
        printf("unbalanced brackets\n");
        return NULL;
    }
    return t;
}
int printLastExpression(char *ps, char *res, int len, char operator1, char operator2) {
    char *buf = NULL;
    char *t = ps;
    if (*ps == '(') {
        char *t1 = t;
        t = skipBrackets(t, len - (t - ps));
        if (t == NULL){
            printf("unbalanced expression (error in printLastExpression)\n");
            return ERR_FLAG;
        }
    }
    if (*ps == '-') //special case when we can't check *(t-1)
        t++;
    for (t; t < ps + len; t++) {
        if (*t == operator1 || *t == operator2) {
            if (*(t - 1) == ')' || isalpha(*(t - 1)))
                buf = t;
        }
        if (*t == '(') {
            char *t1 = t;
            t = skipBrackets(t, len-(t-ps));
            if (t == NULL)
            {
                printf("unbalanced expression (error in printLastExpression)\n");
                return ERR_FLAG;
            }
        }
    }
    if (buf != NULL) {
        *resPtr = *buf;
        resPtr++;
        int flag;
        int leftLen = buf - ps;
        int rightLen = ps + (len - 1) - buf;
        buf++;
        flag = processExpr(buf, res, rightLen);
        return leftLen;
    }
    if (buf == NULL) { //if no binary '+' or '-'
        return -len;
    }
}
int processExpr(char *ps, char *res, int len) {
    static int initFlag = 0;
    if (initFlag == 0){
        resPtr = res;
        initFlag = 1;
    }
    char c;
    while (len > 0) {
        len = printLastExpression(ps, res, len, '+', '-');
    }
    len = Myabs(len);
    while (len > 0) {
        len = printLastExpression(ps, res, len, '*', '/');
    }
    len = Myabs(len);
    while (len > 0) {
        int flag;
        c = ps[0];
        switch (c) {
            case '(':
                if (ps[len - 1] != ')'){
                    printf("unbalanced expression\n");
                    return ERR_FLAG;
                }
                else {
                    int bracketsQty = 2;
                    len -= bracketsQty;
                    processExpr(++ps, res, len);
                    return resPtr - res;
                }
            case '-': //unary prefix '-'
                *resPtr = c;
                resPtr++;
                flag = processExpr(++ps, res, --len);
                *resPtr = '0';
                resPtr++;
                //TODO: process case "-()" in input

                return resPtr - res;
        }
        if (isalpha(c) && len == 1) {
            *resPtr = c;
            resPtr++;
            return resPtr - res;
        }
        else {
            printf("unbalanced expression\n");
            return ERR_FLAG;
        }
    }
    return resPtr - res;
}

#ifdef __cplusplus
}
#endif