#ifndef H_DSF_MY
#define H_DSF_MY
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
node_t * initSet(int data);
void printSet(node_t * head);
void unite(node_t * a, node_t * b);
void freeDSU(dsu_t dsu);
#endif
