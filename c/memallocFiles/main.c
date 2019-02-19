#include<stdio.h>
#include<stdlib.h>
#define NUM (20)
#define TESTNUM (150)
#define __MY__CONFIGURATION__ (RELEASE)
/*memallocator stress test
 *compatible with any type of memallocator (one-dir/two-dir, best-/first-fit)
 *there is no try-catch mechanism in C, so you may only detect an error via
 *receiving "<myproject> has stopped working" message, or in memdone
 *copyleft ZUEVV 2018, all rights violated*/


#include"memallocator.h"
int main(void) {
	enum {
		RELEASE,
		DEBUG1,
		DEBUG2
	} myconfig;
	int len = memgetminimumsize();
	char **a = (char **)malloc(sizeof(char *)*NUM);
	int sizes[NUM];
	int i, j, k, r;
	int allocSensor = 0;
	int freeSensor = 0;
	void *pMem;
	myconfig = __MY__CONFIGURATION__;
	sizes[0] = 0; //zero-len block
	for (i = 1; i < NUM; i++) {
		sizes[i] = i;
		len += i + memgetblocksize();
	}
	pMem = malloc(len);
	meminit(pMem, len);
	for (i = 0; i < TESTNUM; i++) {
		for (j = 0; j < NUM; j++) {
			r = rand() % 2;
			if (r && sizes[j] > 0) {
				if (myconfig == DEBUG2)
					printf("i=%d, j=%d, allocSensor=%d; starting memalloc\n", i, j, allocSensor);
				sizes[j] = -1;
				a[j] = (char *)memalloc(j);
				allocSensor++;
				if (myconfig == DEBUG1)
					printf("Allocation no. %d, everything's OK\n", allocSensor);
				else if (myconfig == DEBUG2)
					printf("i=%d, j=%d, allocSensor=%d; memalloc finished\n", i, j, allocSensor);
				for (k = 0; k < j; k++) {
					if (myconfig == DEBUG2)
						printf("i=%d, j=%d, k=%d; starting filling data\n", i, j, k);
					a[j][k] = 'a'; //filling in user's data
					if (myconfig == DEBUG2)
						printf("i=%d, j=%d, k=%d; data cell filled\n", i, j, k);
				}
			}
		}
		for (j = 0; j < NUM; j++) {
			r = rand() % 2;
			if (r&&sizes[j] < 0) {
				if (myconfig == DEBUG2)
					printf("i=%d, j=%d, freeSensor=%d; starting memfree\n", i, j, freeSensor);
				sizes[j] = j;
				memfree(a[j]);
				freeSensor++;
				if(myconfig == DEBUG1)
					printf("Free No. %d, everything's OK\n", freeSensor, i);
				else if (myconfig == DEBUG2)
					printf("i=%d, j=%d, freeSensor=%d; memfree finished\n", i, j, freeSensor);
			}
		}
	}
	for (j = 0; j < NUM; j++) {
		if (sizes[j] < 0) {
			sizes[j] = j;
			memfree(a[j]);
			freeSensor++;
			if (myconfig == DEBUG1)
				printf("Free No. %d, everything's OK\n", freeSensor);
		}
	}
	memdone();
	free(a);
	free(pMem);
	return 0;

}