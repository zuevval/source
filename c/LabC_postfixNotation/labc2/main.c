#include <stdio.h>
#include <stdlib.h>
#include "functions2.h"
//TODO: unit-test //DONE
//TODO: crtdbg //~DONE (valgrind)
#define MAXLEN (100)
const unsigned int resMarkerLen = 1;
void initPs(char *ps);
int main() {
    char *ps0 = (char *)malloc((MAXLEN+1) * sizeof(char));
    char *res0 = (char *)calloc((MAXLEN+1), sizeof(char));
    char *ps = ps0;
    char *res = res0;
    int len = 0;
    int outlen = 0;
    char buf;
    FILE *fpIn;
    FILE *fpOut;
    res[0] = '\0';
    res += resMarkerLen;
    fpIn = fopen("../input.txt", "r");
    fpOut = fopen("../output.txt", "w");
    if(fpIn==NULL){
        printf("error opening input file");
        if (fpOut != NULL) fclose(fpOut);
        free(ps0);
        free(res0);
        return 0;
    }
    if(fpOut==NULL){
        printf("error opening output file");
        if (fpIn != NULL) fclose(fpIn);
        free(ps0);
        free(res0);
        return 0;
    }
    printf("Input expression:\n");
    while((buf = fgetc(fpIn)) != EOF && buf != '\n') {
        *ps = buf;
        printf("%c", buf);
        ps++;
        len++;
    }
    fclose(fpIn);
    printf("\n");
    if (len == 0)
        printf("<empty>\n");
    ps -= len;
    outlen=0;
    rpn(ps, res, &len, &outlen);
    res+=outlen-resMarkerLen;
    printf("Resulting expression:\n");
    if (outlen > 0) {
        while (*res != '\0') {
            printf("%c", *res);
            fputc(*res, fpOut);
            res--;
        }
    }
    fputc('\n', fpOut);
    fclose(fpOut);
    free(ps0);
    free(res0);
    return 0;
}
void initPs(char *ps) {
    ps[0] = 'a';
    ps[1] = '-';
    ps[2] = 'b';
    ps[3] = '+';
    ps[4] = 'c';
    ps[5] = '/';
    ps[6] = '(';
    ps[7] = 'd';
    ps[8] = '+';
    ps[9] = '-';
    ps[10] = 'e';
    ps[11] = ')';
}