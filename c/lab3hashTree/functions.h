//
// Created by zuevval on 24.04.19.
//

#ifndef LAB3HASHTREE_FUNCTIONS_H
#define LAB3HASHTREE_FUNCTIONS_H

#ifdef __cplusplus
extern "C" {
#endif

#define Myabs(a) ((a) >= 0 ? (a): -(a))
#define MyMax(a, b) ((a)>(b)?(a):(b))
#define hashParam1 (79)
#define hashParam2 (103)
#define NODES_MAX (997)

struct node {
    int key;
    struct node *l;
    struct node *r;
};
typedef struct node node;

enum status {
    success = 0,
    fail = -1
};

void init(node **tree);

enum status push(node **tree, int key);

enum status pop(node **tree, int key);

void freeAll(node **tree);

#ifdef __cplusplus
}
#endif

#endif //LAB3HASHTREE_FUNCTIONS_H
