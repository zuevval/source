unsigned int P(unsigned int n) {
	int i;
	unsigned int res = 1;
	for (i = 1; i <= n; i++) {
		if (UINT_MAX / i > res) res *= i;
		else return UINT_MAX;
	}
	return res;
}