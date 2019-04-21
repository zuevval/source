//
// Created by zuevval on 21.04.19.
//

#ifndef LAB2_AVL_FUNCTIONS_H
#define LAB2_AVL_FUNCTIONS_H

#define NODES_MAX (1000)

struct node {
    int key;
    int depth; //max depth of subtree with this as root
    struct node * l;
    struct node * r;
};
typedef struct node node;

void zig(node * y,  node * parent);
void zag(node * x, node * parent);

#endif //LAB2_AVL_FUNCTIONS_H
