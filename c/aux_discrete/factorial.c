#include<stdio.h>
#include<stdlib.h>
#include<limits.h>

#pragma warning(disable : 4996) //for VS to permit fopen, scanf, etc

unsigned int factRecur(unsigned int n) {
	unsigned int res;
	if (n == 1 || n == 0)
		return 1;
	res = factRecur(n - 1);
	if (res == 0 || UINT_MAX / n < res)
		return 0;
	return n * factRecur(n - 1);
}

unsigned int factIter(unsigned int n) {
	unsigned int res = 1;
	int i;
	if (n == 1 || n == 0)
		return 1;
	for (i = 2; i <= n; i++) {
		if (UINT_MAX / i < res)
			return 0;
		res *= i;
	}
	return res;
}

int main(void) {
	unsigned int n;
	unsigned int f;
	scanf("%u", &n);
	f = factRecur(n);
	if (f == 0)
		printf("Overflow");
	else
		printf("%u\n", f);
	f = factIter(n);
	if (f == 0)
		printf("Overflow");
	else
		printf("%u\n", f);
	return 0;
}