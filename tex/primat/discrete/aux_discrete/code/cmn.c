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
	if (n > m / 2) return C(m, m - n);
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

unsigned int cWrapper(unsigned int m, unsigned int n){
	myUint cmn = C(m, n);
	if(cmn.isOverflow) return UINT_MAX;
	else return cmn.data;
}