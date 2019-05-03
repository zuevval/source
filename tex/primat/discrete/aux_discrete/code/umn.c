unsigned int U(unsigned int m, unsigned int n) {
	int i;
	unsigned int res = 1;
	if (m == 0) return 0;
    if (m == 1) return 1;
	for (i = 1; i <= n; i++) {
		if (UINT_MAX / m > res) res *= m;
		else return UINT_MAX;
	}
	return res;
}