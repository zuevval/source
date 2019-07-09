#include"dsf.h"

node_t * initSet(int data) {
	node_t * head = (node_t *)malloc(sizeof(node_t));
	head->next = NULL;
	head->data = data;
	head->head = head;
	head->tail = head;
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
    a = a->head;
    b = b->head;
    if(a->data == b->data) return;
    a->tail->next = b;
    a->tail = b->tail;
    while(b != NULL){
        b->head = a;
        b = b->next;
    }
}

void freeDSU(dsu_t dsu){
    for (int i=0; i<dsu.nUnions; i++) freeSet(dsu.unions[i]);
}