//works well, to send for check
/* Eucledian algorithm
] d=gcd(m,s), s>=m
] s=k0*m+r1
  m=k1*r1+r2
  r1=k2*r2+r3
  r2=k3*r3+r4
...
  r(i-1)=ki*ri+r(i+1)
...
  r(n-2)=k(n-1)*r(n-1)+rn
  r(n-1)=kn*rn+0
Hence, rn=d */
#include<stdio.h>
//#include<math.h>
int main(){
	int A, B, s, m, ri, riMinus1, riPlus1, ki, res;
	scanf("%d%d",&A,&B);
	if(A>B){
		s=A;
		m=B;
	} else {
		s=B;
		m=A;
	}
	riMinus1=s;
	ri=m;
	ki=riMinus1/ri;
	riPlus1=riMinus1%ri;
	//printf("r1Plus1=%d\n",riPlus1);
	//printf("r1=%d\n",ri);
	while(riPlus1!=0){
		riMinus1=ri;
		ri=riPlus1;
		ki=riMinus1/ri;
		riPlus1=riMinus1%ri;
	}
	printf("%d", ri);
}
