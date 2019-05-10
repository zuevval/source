struct myUint {
	char isOverflow;
	unsigned int data;
};
typedef struct myUint myUint;

myUint cmn (unsigned int m, unsigned int n) {
	int i, j;
	unsigned int nmr=1; //numerator
	unsigned int dnm=1; //denominator
	myUint res;
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
	if (n > m / 2) return cmn(m, m - n);
	for (i = n; i >= 1; i--) {
		dnm *= i;
	}
	if(dnm == 0) {res.isOverflow = 1; return res;} //dnm == 0 <=> overflow
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
		for (j = (int)sqrt((double)nmr)+1; j > 1; j--) {
			if (nmr % j == 0 && dnm % j == 0) {
				nmr /= j;
				dnm /= j;
			}
		}
	}
	res.data = nmr / dnm;
	return res;
}

unsigned int C(unsigned int m, unsigned int n){
	myUint res = cmn(m, n);
	if(res.isOverflow) return UINT_MAX;
	else return res.data;
}