#include <stdio.h>
#include <limits.h>
#pragma warning(disable : 4996) //for VS to permit fopen, scanf, etc

unsigned int A(unsigned int m, unsigned int n) {
	int i;
	unsigned int res = 1;
	if (m == 1)
		return 1;

	for (i = 0; i < n; i++) {
		if (UINT_MAX / (m-i) > res)
			res *= m-i;
		else
			return 0;
	}
	return res;
}

int main()
{
	unsigned int m;
	unsigned int n;
	unsigned int Amn;
	scanf("%u", &m);
	scanf("%u", &n);
	if(m == 0 && n == 0) {
		printf("%u\n", 1);
		return 0;
	}
	if (m == 0 || n > m) {
		printf("%u\n", 0);
		return 0;
	}
	Amn = A(m, n);
	if (Amn == 0)
		printf("Overflow");
	else
		printf("%u\n", Amn);
	return 0;
}