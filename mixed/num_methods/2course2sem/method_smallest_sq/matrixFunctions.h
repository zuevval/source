#ifndef H_MTXFUNCTIONS
#define H_MTXFUNCTIONS
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include"qrfunctions.h"
#pragma warning(disable : 4996) //for VS to permit fopen
#ifndef MY_ABS
#define MY_ABS
#define Myabs(a) ((a)>0?(a):(-(a)))
#endif
double f(double x);
double smallestSq(int n, int m, int range[2], double *A, double *BF);
void solveSystem(int n, double *x, double * Ab);
void printMatrix(double * M, int rows, int columns, char *title);
#endif
