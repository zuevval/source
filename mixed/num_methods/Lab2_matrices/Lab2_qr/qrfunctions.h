#ifndef H_QRFUNCTIONS
#define H_QRFUNCTIONS
void qrdecompose(double * Ab, int n, int m);
int ifnotzero(double * Ab, int i, int n, int m);
void rotate(double * Ab, double cij, double sij, int i, int j, int n, int m);
void solveTriang(double * Ab, int n, int m, double * x);
double checkSolution(double *Ab0, int n, int m, double *x);
double sumDiff(double *x1, double*x2, int len);
/*returns sum(abs(x1_i-x2_i))*/
double vectorNorm(double *x, int len);
void devVector(double *v, int len);
/*makes small deviavions in V*/
double Ab_ANorm(double *M, int n, int m);
/*input: Ab; output: norm(A)*/
#endif
