#include <stdio.h>
#pragma warning(disable : 4996) //for VS to permit fopen, scanf, etc

unsigned int fib(unsigned int n) {
	int fib1=1, fib2=1, t, i;
	if (n == 1 || n == 2)
		return 1;
	for (i = 3; i <= n; i++) {
		t = fib1 + fib2;
		fib1 = fib2;
		fib2 = t;
	}
	return fib2;
	
}

int main()
{
	unsigned int n;
	scanf("%u", &n);
	if (n == 0) {
		printf("Error\n");
		return 0;
	}
	printf("%u\n", fib(n));
	return 0;
}