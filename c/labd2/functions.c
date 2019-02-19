#ifdef __cplusplus
extern "C" {
#endif

#include<stdlib.h>
#include<assert.h>
#include"functions.h"

const int flg1 = 1; //if f[i] == flg1, we've been once before in this node
const int flg2 = 2; //if f[i] == flg2, we've been twice in this node
int fill(int u, int b, int k, int *x, Item *list) {
    int *f = (int *) calloc(u, sizeof(int));
    int i = 0, sum = 0, space = 0;
    if (u == 0) { //special case
        free(f);
        if (k == 0) return 0;
        else return -1;
    }
    while (i >= 0) {
        if (sum >= k && space <= b){
            free(f);
            return 0;
        }
        if (i >= u)
            i--;
        if (f[i] == 0) {
            assert(x[i] == 0);
            if (space + list[i].s > b)
                f[i] = flg2;
            else {
                f[i] = flg1;
                x[i] = flg1;
                sum += list[i].v;
                space += list[i].s;
            }
            i++;
        } else if (f[i] == flg1) {
            assert(x[i] == flg1);
            x[i] = 0;
            sum -= list[i].v;
            space -= list[i].s;
            f[i] = flg2;
            i++;
        } else {
            assert(f[i] == flg2);
            assert(x[i] == 0);
            f[i] = 0;
            i--;
        }
    }
    free(f);
    return -1;
}

void swap(Item *a, Item *b) {
    Item t = *a;
    *a = *b;
    *b = t;
}

int h_partition(Item *list, int lo, int hi) {
    int i = lo-1;
    int j = hi+1;
    double pivot = list[lo].vsratio;
    while (1) {
        i++;
        while (list[i].vsratio > pivot)
            i++;
        j--;
        while (list[j].vsratio < pivot)
            j--;
        if (i >= j)
            return j;
        swap(&(list[i]), &(list[j]));
    }
    /*result: |>=p|p|<p|*/
}

void quicksort(Item *list, int lo, int hi) {
    //reverse quicksort
    if (lo < hi) {
        int p = h_partition(list, lo, hi);
        quicksort(list, lo, p);
        quicksort(list, p+1, hi);
    }
}

#ifdef __cplusplus
}
#endif