#include<math.h>
#include"functions.h"
void calcLagrangeMids(lp L){
	int i, j, s;
	double t;
	int n =L.n;
	for (s=0; s<n; s++){
		L.Lnmid[s] = 0;
		for(i=0; i<n+1; i++){
			t=1;
			for(j=0; j<n+1; j++){
				if(i == j) continue;
				t = t*(L.Xmid[s]-L.X[j]); //t = t*(Xmid(1,s) - X(1,j))
				t = t/(L.X[i]-L.X[j]); //t = t/(X(1,i)-X(1,j))
			}
			L.Lnmid[s] += t*L.Y[i];
		}
	}
}

void calcDeviation(lp * Lptr){
	int i;
	int n = Lptr->n;
	double t=0;
	Lptr->maxDeviation = 0;
	Lptr->averageDeviation = 0;
	for(i=0; i<n; i++){
		t = Myabs(Lptr->Ymid[i]-Lptr->Lnmid[i]);
		Lptr->averageDeviation += t;
		if(Lptr->maxDeviation < t){
			Lptr->maxDeviation = t;
		}
	}
	Lptr->averageDeviation /= n;
}

void makeChebishNet(lp L){
	//TODO: render function here as a parameter and calculate Y, Ymid too
	int i=0, n = L.n;
	for (i = 0; i < n+1; i++)
		L.X[i] = cos(3.1416*(2.0*i + 1) / (2.0*n + 2));//X(1,i+1) = cos(pi*(2*i+1)/(2*n+2))
	for(i = 0; i < n; i++)
		L.Xmid[i] = 0.5*(L.X[i] + L.X[i + 1]);//Xmid(1,i) = 0.5*(X(1,i)+X(1,i+1));
}