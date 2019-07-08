#include<stdlib.h>
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
    while(nd->tail != nd){
        temp = nd->next;
        free(nd);
        nd = temp;
    }
    free(nd); //free tail
}

node_t * unite(node_t * a, node_t * b){
    //TODO: implement (see neerc.ifmo.ru)
}