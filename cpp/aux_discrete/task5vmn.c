#include<stdio.h>
#include<stdlib.h>
#include<limits.h>
#include<math.h>
#pragma warning(disable : 4996) //for VS to permit fopen, scanf, etc

struct myUint {
	char isOverflow;
	unsigned data;
};
typedef struct myUint myUint;

myUint C(unsigned int m, unsigned int n) {
	int i, j;
	unsigned int nmr = 1; //numerator
	unsigned int dnm = 1; //denominator
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
	for (i = n; i >= 1; i--) {
		dnm *= i;
	}
	if (dnm == 0) { res.isOverflow = 1; return res; } //dnm == 0 <=> overflow
	for (i = n; i >= 1; i--) {
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
		}
		else {
			res.isOverflow = 1;
			return res;
		}
		for (j = sqrt(nmr) + 1; j > 1; j--) {
			if (nmr % j == 0 && dnm % j == 0) {
				nmr /= j;
				dnm /= j;
			}
		}
	}
	res.data = nmr / dnm;
	return res;
}

myUint V(unsigned int m, unsigned int n) {
	myUint Cmn;
	unsigned int m1 = m + n - 1;
	if (m + n - 1 < 0) {
		Cmn.data = 0;
		return Cmn;
	}
	if (m1 > 0 && n > m1 / 2)
		Cmn = C(m1, m1 - n);
	else
		Cmn = C(m1, n);
	return Cmn;
}

int main()
{
	unsigned int m = 0;
	unsigned int n;
	myUint Vmn;
	scanf("%u", &m);
	scanf("%u", &n);
	Vmn = V(m, n);
	if (Vmn.isOverflow)
		printf("Overflow");
	else
		printf("%u\n", Vmn.data);
	return 0;
}