#ifndef _H_Functions
#define _H_Functions

#pragma warning(disable : 4996)

#define Myabs(a) ((a)<0?-(a):(a))
struct LagrangeParams{
	int n;
	double *X;
	double *Y;
	double *Xmid;
	double *Ymid;
	double *Lnmid;
	double maxDeviation;
	double averageDeviation;
};
typedef struct LagrangeParams lp;

void calcLagrangeMids(lp L);
void calcDeviation(lp * Lptr);
void makeChebishNet(lp L);

#endif