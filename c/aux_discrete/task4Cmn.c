#include<stdio.h>
#include<stdlib.h>
#include<limits.h>

#pragma warning(disable : 4996) //for VS to permit fopen, scanf, etc

unsigned int C(unsigned int m, unsigned int n) {
	int i, j;
	unsigned int col = n;
	unsigned int row = m - n;
	unsigned int res;
	unsigned int * Cmn;
	if (m == 1)
		return 1;
	if (n == 1)
		return m;

	if (m > 95000 && n > 1)
		return 0;

	Cmn = (unsigned int *)malloc(sizeof(unsigned int)*(col + 1));

	for (i = 0; i <= col; i++)
		Cmn[i] = 1;
	for (i = 1; i <= row; i++) {
		for (j = 1; j <= col; j++) {
			if (UINT_MAX - Cmn[j] < Cmn[j - 1]) {
				free(Cmn);
				return 0;
			}
			Cmn[j] += Cmn[j - 1];
		}
	}

	res = Cmn[col];
	free(Cmn);
	return res;
}

int main()
{
	unsigned int m;
	unsigned int n;
	unsigned int Cmn;
	scanf("%u", &m);
	scanf("%u", &n);
	if (m == 0 && n == 0) {
		printf("%u\n", 1);
		return 0;
	}
	if (m == 0 || n > m) {
		printf("%u\n", 0);
		return 0;
	}
	if (n > m / 2)
		Cmn = C(m, m - n);
	else
		Cmn = C(m, n);
	if (Cmn == 0)
		printf("Overflow");
	else
		printf("%u\n", Cmn);
	return 0;
}