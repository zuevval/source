#ifdef __cplusplus
extern "C" {
#endif

#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include"functions2.h"

#ifndef MY_ABS1
#define MY_ABS1
#define Myabs(a) ((a)>=0 ? (a) : (-(a)))
#endif
#define ERR_FLAG (-1)
//TODO: no external/static variables //DONE

void error(char *message, int *inlen, int *outlen){
    inlen[0]=0;
    outlen[0]=0;
    //printf("%s\n",message);
    return;
}
char *skipBrackets(char *t, int len, int *inlen, int *outlen) {
    int bracketsQty = 1;
    while (bracketsQty!=0 && len > 1){
        t++;
        len--;
        if(t[0]==')')
            bracketsQty--;
        if(t[0]=='(')
            bracketsQty++;
    }
    if (bracketsQty!=0)
        error("unbalanced brackets", inlen, outlen);
    return t;
}
void printLastExpression(char *in, char *out, int *inlen, int *outlen, char operator1, char operator2) {
    char *buf = NULL;
    char *t = in;
    if (in[0] == '-') //special case when we can't check *(t-1)
        t++;
    for (t; t < in + inlen[0]; t++) {
        if (*t == '(')
            t = skipBrackets(t, inlen[0]-(t-in), inlen, outlen); //inlen isn't changed
        if (*t == operator1 || *t == operator2) {
            if (*(t - 1) == ')' || isalpha(*(t - 1)))
                buf = t;
        }
    }
    if (buf != NULL) { //if binary operator1 or operator2 found...
        int leftlen = buf - in;
        int rightlen = in + (inlen[0] - 1) - buf;
        out[outlen[0]]=buf[0]; //print operator into 'out'
        outlen[0]++;
        buf++;
        rpn(buf, out, &rightlen, outlen);
        inlen[0]=leftlen;
        return;
    }
    if (buf == NULL) { //if no binary operator1 or operator2
        inlen[0]*= -1;
        return;
    }
}
void rpn(char *in, char *out, int *inlen, int *outlen){
    char c;
    if(inlen[0]==0)
        return;
    while(inlen[0]>0)
        printLastExpression(in, out, inlen, outlen, '+', '-');
    inlen[0]=Myabs(inlen[0]);
    while(inlen[0]>0)
        printLastExpression(in, out, inlen, outlen, '*', '/');
    inlen[0]=Myabs(inlen[0]);
    if(inlen[0]==0)
        return;
    c=in[0];
    if(isalpha(c) && inlen[0]==1){
        out[outlen[0]]=c;
        outlen[0]++;
        return;
    }
    switch(c){
        case '(':
            if(in[inlen[0]-1]!=')')
                error("unbalanced brackets (error in rpn)", inlen, outlen);
            int bracketsQty = 2;
            inlen[0]-= bracketsQty;
            in++;
            rpn(in, out, inlen, outlen); //process the content of brackets
            return;
        case '-': //-<expression>0
            out[outlen[0]]='-';
            outlen[0]++;
            inlen[0]--;
            in++;
            rpn(in, out, inlen, outlen);
            out[outlen[0]]='0';
            outlen[0]++;
            return;
    }
    if(inlen[0]!=0)
        error("unbalanced expression", inlen, outlen);
    inlen[0]=0;
    outlen[0]=0;
    return;
}

#ifdef __cplusplus
}
#endif