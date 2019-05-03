#include<cmn.h>

myUint V(unsigned int m, unsigned int n) {
	myUint Cmn;
	unsigned int m1 = m + n - 1;
	if (m + n - 1 < 0) {
		Cmn.data = 0;
		return Cmn;
	}
	if (m1 > 0 && n > m1 / 2) Cmn = C(m1, m1 - n);
	else Cmn = C(m1, n);
	return Cmn;
}

unsigned int vWrapper(unsigned int m, unsigned int n){
	myUint vmn = V(m, n);
	if(vmn.isOverflow) return UINT_MAX;
	else return vmn.data;
}