//
// Created by zuevval on 21.04.19.
//

#ifndef LAB2_AVL_FUNCTIONS_H
#define LAB2_AVL_FUNCTIONS_H

#define NODES_MAX (1000)
#define Myabs(a) ((a) >= 0 ? (a): -(a))
#define MyMax(a,b) ((a)>(b)?(a):(b))

struct node {
    int key;
    int depth; //max depth of subtree with this as root
    struct node * l;
    struct node * r;
};
typedef struct node node;

void push(node ** root, int key);
void pop(node ** tree, int key);
void freeAll(node * root);

#endif //LAB2_AVL_FUNCTIONS_H
