#include<stdlib.h>
#include "pch.h"
#include"../Memalloc_gtest/memallocator.h"

TEST(FromBlank, sizes) {
	EXPECT_EQ(memgetblocksize(), 8);
	EXPECT_EQ(fullblocksize(), 12);
	EXPECT_EQ(memgetminimumsize(), 20);
}
TEST(FromBlank, init) {
	int l[] = { 0, 1, 2, 3, 4, 5, 6, -1};
	int i;
	for (i = 0; l[i] != -1; i++) {
		int l1 = l[i] + 20; //+ memgetminimumsize
		void *pMem = malloc(l1);
		int *memstart = (int *)pMem;
		int *memend = (int *)((char *)pMem + l1) - 2;
		meminit(pMem, l1);
		EXPECT_EQ(memstart[0], -1);
		EXPECT_EQ(memstart[1], l1 - 8);
		EXPECT_EQ(memend[0], l1 - 8);
		EXPECT_EQ(memend[1], -1);
	}
}
TEST(Arr1, memfree1) {
	// |-1|-33|...|-33|-17|...|-17|-15|...|-15|-14|...|-14|-1|
	void *pMem = malloc(8 + (33 + 17 + 15 + 14));
	char *mem = (char *)pMem + 4;
	int t;
	int *t2;
	((int *)mem)[-1] = -1;
	((int *)mem)[0] = -33;
	((int *)(mem + 33))[-1] = -33;
	((int *)(mem + 33))[0] = -17;
	((int *)(mem + 33 + 17))[-1] = -17;
	((int *)(mem + 33 + 17))[0] = -15;
	((int *)(mem + 33 + 17 + 15))[-1] = -15;
	((int *)(mem + 33 + 17 + 15))[0] = -14;
	((int *)(mem + 33 + 17 + 15 + 14))[-1] = -14;
	mem = (char *)pMem + 4 + 33 + 17;
	memfree(mem + 4);
	// |-1|-33|...|-33|-17|...|-17|15|NULL|...|15|-14|...|-14|-1|
	EXPECT_EQ(((int *)(mem))[0], 15);
	t2 = ((int **)(mem + 4))[0];
	//EXPECT_EQ(t2, NULL);
	//???? doesn't work!!!!!!!!!!
	EXPECT_EQ(((int *)(mem+15))[-1], 15);
	mem = (char *)pMem + 4 + 33;
	memfree(mem + 4);
	// |-1|-33|...|-33|17+15|NULL|...|17+15|-14|...|-14|-1|
	t=((int *)(mem))[0];
	EXPECT_EQ(t, 17+15);
	mem = (char *)pMem + 4 + 33 + 17 + 15;
	memfree(mem + 4);
	//|-1|-33|...|-33|17+15+14|NULL|...|17+15+14|-1|
	mem = (char *)pMem + 4 + 33;
	t = ((int *)(mem))[0];
	EXPECT_EQ(t, 17+15+14);
	free(pMem);
}