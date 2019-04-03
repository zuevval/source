#include <stdio.h>
#include <limits.h>
#pragma warning(disable : 4996) //for VS to permit fopen, scanf, etc

unsigned int U(unsigned int m, unsigned int n) {
	int i;
	unsigned int res = 1;
	if (m == 1)
		return 1;

	for (i = 1; i <= n; i++) {
		if (UINT_MAX / m > res)
			res *= m;
		else
			return 0;
	}
	return res;
}

int main()
{
	unsigned int m;
	unsigned int n;
	unsigned int Umn;
	scanf("%u", &m);
	scanf("%u", &n);
	if (m == 0) {
		printf("%u\n", 0);
		return 0;
	}
	Umn = U(m, n);
	if (Umn == 0)
		printf("Overflow");
	else
		printf("%u\n", Umn);
	return 0;
}