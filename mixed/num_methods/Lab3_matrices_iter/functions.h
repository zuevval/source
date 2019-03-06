#ifndef H_FUNCS_MY
#define H_FUNCS_MY
void getMatrix(double *Ab, int n, int m);
void printMatrix(double * M, int rows, int columns, char *title);
void calc_multiple(double *D, double *Ab, int n, int m);
void calc_cg(double *C, double *g, double * D, double *Ab, int n, int m);
void msi(double *x, double *C, double *g, double eps, int n);
#ifndef MY_ABS
#define MY_ABS
#define Myabs(a) ((a)>0?(a):(-(a)))
#endif
#endif
