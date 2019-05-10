myUint vmn(unsigned int m, unsigned int n) {
	myUint Cmn;
	unsigned int m1 = m + n - 1;
	if (m + n - 1 < 0) {
		Cmn.data = 0;
		return Cmn;
	}
	if (m1 > 0 && n > m1 / 2) Cmn = cmn(m1, m1 - n);
	else Cmn = cmn(m1, n);
	return Cmn;
}

unsigned int V(unsigned int m, unsigned int n){
	myUint res = vmn(m, n);
	if(res.isOverflow) return UINT_MAX;
	else return res.data;
}