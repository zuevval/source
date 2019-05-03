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