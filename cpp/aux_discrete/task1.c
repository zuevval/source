#include <stdio.h>
//#include <stdint.h>
#include <limits.h>
#pragma warning(disable : 4996) //for VS to permit fopen, scanf, etc

unsigned int P(unsigned int n) {
	int i;
	unsigned int res = 1;
	for (i = 1; i <= n; i++) {
		if (UINT_MAX / i > res)
			res *= i;
		else
			return 0;
	}
	return res;
}

int main()
{
	unsigned int n;
	unsigned int Pn;
	scanf("%u", &n);
	Pn = P(n);
	if (Pn == 0)
		printf("Overflow");
	else
		printf("%u\n", Pn);
	return 0;
}