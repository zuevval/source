//
// Created by zuevval on 11.07.19.
//

#ifndef DISJOINT_SET_FOREST_DSF_TEST_H
#define DISJOINT_SET_FOREST_DSF_TEST_H

#include<stdio.h>
#include<stdlib.h>

struct Node {
    int data;
    struct Node * next;
    struct Node * head;
};

typedef struct Node node_t;

struct DSU {
    int nUnions;
    node_t ** unions;
};

typedef struct DSU dsu_t;

node_t * initSet(int data) {
    node_t * head = (node_t *)malloc(sizeof(node_t));
    head->next = NULL;
    head->data = data;
    head->head = head;
    return head;
}

void freeSet(node_t * head) {
    node_t * nd = head;
    node_t * temp;
    while(nd != NULL){
        temp = nd->next;
        free(nd);
        nd = temp;
    }
}

void printSet(node_t * head){
    node_t * nd = head;
    while(nd != NULL){
        printf("%d ", nd->data);
        nd = nd->next;
    }
    printf("\n");
}

void unite(node_t * a, node_t * b){
    node_t * aHead = a->head;
    b = b->head;
    if(aHead->data == b->data) return;
    while (a->next != NULL) a = a->next; //a is tail now
    a->next = b; //connect tail of A with head of B
    while(b != NULL){
        b->head = aHead;
        b = b->next;
    }
}

void freeDSU(dsu_t dsu){
    for (int i=0; i<dsu.nUnions; i++) freeSet(dsu.unions[i]);
    free(dsu.unions);
}

#endif //DISJOINT_SET_FOREST_DSF_TEST_H
