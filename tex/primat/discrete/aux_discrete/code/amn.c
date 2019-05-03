unsigned int A(unsigned int m, unsigned int n) {
	int i;
	unsigned int res = 1;
	if(m == 0 && n == 0) return 1;
	if (m == 0 || n > m) return 0;
	if (m == 1)	return 1;

	for (i = 0; i < n; i++) {
		if (UINT_MAX / (m-i) > res) res *= m-i;
		else return UINT_MAX;
	}
	return res;
}