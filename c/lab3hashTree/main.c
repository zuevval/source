//
// Created by zuevval on 24.04.19.
//

#include<stdio.h>
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
    node * r;
    init(&r);
    push(&r, 5);
    push(&r, 5);
    push(&r, 6);
    push(&r, 7);
    push(&r, -10);
    push(&r, 25);
    push(&r, -100);
    push(&r, -50);
    push(&r, -99);
    push(&r, -99);
    printPlus(r);
    pop(&r, 5);
    printPlus(r);
    pop(&r, -100);
    printPlus(r);
    freeAll(&r);
    return 0;
}

