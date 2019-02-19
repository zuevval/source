#ifdef __cplusplus
extern "C" {
#endif

#ifndef H_FUNCTIONS_MY
#define H_FUNCTIONS_MY
#include<stdlib.h>
#include<assert.h>

typedef struct Item {
    int no;
    int v;
    int s;
    double vsratio;
} Item;

int fill(int u, int b, int k, int *x, struct Item *list);
//int h_partition (Item *list, int lo, int hi);
void quicksort (Item *list, int lo, int hi);
#endif

#ifdef __cplusplus
}
#endif