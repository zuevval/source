#ifndef H_DSF_MY
#define H_DSF_MY
struct Node {
	int data;
	struct Node * next;
	struct Node * head;
	struct Node * tail;
};

typedef struct Node node_t;

struct DSU {
    int nUnions;
    node_t ** unions;
};

typedef struct DSU dsu_t;

node_t * initSet(int data);
void freeSet(node_t * head);
//node_t find(node_t x, no); TODO: implement or ensure it's unnecessary
node_t * unite(node_t * a, node_t * b);
#endif
