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
	for (i = n; i >= 1; i--) {
		dnm *= i;
	}
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
		/*if (UINT_MAX / i > dnm) {
			dnm *= i;
		} else {
			res.isOverflow = 1;
			return res;
		}*/
		for (j = sqrt(nmr)+1; j > 1; j--) {
			if (nmr % j == 0 && dnm % j == 0) {
				nmr /= j;
				dnm /= j;
			}
		}
	}
	res.data = nmr / dnm;
	return res;
}

int main()
{
	unsigned int m;
	unsigned int n;
	myUint Cmn;
	scanf("%u", &m);
	scanf("%u", &n);
	if (n > m / 2)
		Cmn = C(m, m - n);
	else
		Cmn = C(m, n);
	if (Cmn.isOverflow)
		printf("Overflow");
	else
		printf("%u\n", Cmn.data);
	return 0;
}