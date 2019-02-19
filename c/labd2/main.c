#include <stdio.h>
#include <ctype.h>
#include"functions.h"
const int errFlag = -1;
const int indexShift = 1;
const int maxNumLen = 10;
const int digitShiftMultiple = 10;

int getno(int *num, FILE *in);
int putno(int num, FILE *out);

int main() {
    FILE *in = fopen("../input.txt", "r");
    FILE *out = fopen("../output.txt", "w");
    Item *list;
    int *x;
    int flag;
    int i, u = 0/*quantity*/, b = 0 /*capacity*/, k = 0 /*minimal cost*/;
    if (in == NULL || out == NULL || feof(in) || feof(out)) {
        if(in != NULL) fclose(in);
        if (out != NULL) fclose(out);
        return errFlag;
    }
    flag = getno(&u, in);
    if (flag == errFlag) return -1;
    flag = getno(&b, in);
    if (flag == errFlag) return -1;
    flag = getno(&k, in);
    if (flag == errFlag) return -1;
    printf("u=%d, b=%d, k=%d\n", u, b, k);

    list = (Item *) malloc(sizeof(struct Item) * u);

    for (i = 0; i < u; i++) {
        list[i].no = i + indexShift;
        flag = getno(&(list[i].s), in); //space occupied by item
        if (flag == errFlag) return -1;
    }
    for (i = 0; i < u; i++) {
        flag = getno(&(list[i].v), in); //value of item
        if (flag == errFlag) return -1;
        list[i].vsratio = ((double)list[i].v)/list[i].s;
        printf("list[%d].s=%d, ", i, list[i].s);
        printf("v=%d, ", list[i].v);
    }
    fclose(in);
    quicksort(list, 0, u-1); //sort by vsratio

    x = (int *) calloc(u, sizeof(int));
    flag = fill(u, b, k, x, list); //trying to fill a backpack with items
    if (flag == -1) { //if there is no solution
        fputc('0', out);
    } else {
        for (i = 0; i < u; i++) {
            if (x[i]) {
                flag = putno(list[i].no, out);
                if (flag == errFlag) return errFlag;
                fputc(' ', out);
            }
        }
    }
    fputc('\n', out);
    fclose(out);
    free(list);
    return 0;
}

int getno(int *num, FILE *in) {
    int sym;
    sym = fgetc(in);
    while (isdigit(sym)) {
        int multiple = digitShiftMultiple;
        if (feof(in)) return errFlag;
        *num *= multiple;
        *num += sym - '0';
        sym = fgetc(in);
    }
    if (feof(in)) return errFlag;
    return 0;
}

int putno(int num, FILE *out) {
    char *sym = (char *) calloc(sizeof(char), maxNumLen);
    int divisor = digitShiftMultiple;
    int i = 0;
    while (num > 0) {
        sym[i] = (char) (num % divisor + '0');
        num /= divisor;
        if (feof(out)) return errFlag;
        i++;
    }
    if (feof(out)) return errFlag;
    for (--i; i >= 0; i--)
        fputc(sym[i], out);
    return 0;
}