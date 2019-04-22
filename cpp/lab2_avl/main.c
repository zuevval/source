//
// Created by zuevval on 21.04.19.
//
#include<stdio.h>
#include<stdlib.h>
#include"functions.h"

void print1 (node *t, int depth, int ifLeftSon){
    int i;
    if(t->r != NULL)
        print1(t->r, depth+1, 0);
    for(i=0; i<depth; i++){
        printf("%s","   ");
        if(i == depth - 1){
            if(ifLeftSon)
                printf("\\->");
            else
                printf("/->");
        }
    }
    printf("%d\n", t->key);
    if(t->l != NULL)
        print1(t->l, depth+1, 1);
}

void printPlus(node * t){
    if(t != NULL && t->l != NULL)
        print1(t->l, 0, 0);
    printf("______________\n\n");
}

int main(void){
    node ** r = malloc(sizeof(node *));
    *r = NULL;
    push(r, 0);
    push(r, 2);
    printPlus(r[0]);
    push(r, 1);
    printPlus(r[0]);
    push(r, -6);
    printPlus(r[0]);
    push(r, -4);
    printPlus(r[0]);
    push(r, -3);
    printPlus(r[0]);
    pop(r, -3);
    pop(r, -6);
    pop(r, -4);
    pop(r, 2);
    printPlus(r[0]);
    pop(r, 1);
    pop(r, 0);
    printPlus(r[0]);
    freeAll(*r);
    free(r);
    return 0;
}

