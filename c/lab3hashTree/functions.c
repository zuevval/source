//
// Created by zuevval on 24.04.19.
//

#ifdef __cplusplus
extern "C" {
#endif

#include <stdlib.h>
#include <values.h>
#include <assert.h>
#include "functions.h"

void init(node **tree) {
    *tree = (node *) malloc(sizeof(node));
    (*tree)->key = INT_MAX;
    (*tree)->r = NULL;
    (*tree)->l = NULL;
}

int h(int key) {
    return key == INT_MAX ? key : (1 - key % hashParam1) % hashParam2;
}

enum comparator {
    first,
    equal,
    second
};

typedef enum comparator comp_t;

comp_t hashCmp(int key1, int key2) {
    if (h(key1) > h(key2)) return first;
    if (h(key1) < h(key2)) return second;
    if (key1 > key2) return first; //if hashes equal, compare by keys
    if (key1 < key2) return second;
    return equal;
}

node *find(node *root, int key) {
    //returns a node with the key or the one that should be its parent
    node *n = root;
    comp_t cmp = hashCmp(n->key, key);
    while (cmp != equal) {
        if (cmp == first) {//node's hash is bigger
            if (n->l == NULL) return n;
            n = n->l;
        } else if (cmp == second) {
            if (n->r == NULL) return n;
            n = n->r;
        }
        cmp = hashCmp(n->key, key);
    }
    return n;
}

node *findParent(node *root, int key) {
    //returns a parent of a node with the key specified
    node *n = root;
    node * nparent = NULL;
    comp_t cmp = hashCmp(n->key, key);
    while (cmp != equal) {
        if (cmp == first) {//node's hash is bigger
            if (n->l == NULL) return n;
            nparent = n;
            n = n->l;
        } else if (cmp == second) {
            if (n->r == NULL) return n;
            nparent = n;
            n = n->r;
        }
        cmp = hashCmp(n->key, key);
    }
    return nparent;
}

enum status add(node **tree, node *a) {
    node *n = find(*tree, a->key);
    comp_t cmp = hashCmp(n->key, a->key);
    if (cmp == first) {
        n->l = a;
        return success;
    }
    if (cmp == second) {
        n->r = a;
        return success;
    }
    return fail;
}

enum status push(node **tree, int key) {
    node *a;
    node *n = find(*tree, key);
    comp_t cmp = hashCmp(n->key, key);
    if (cmp == equal) return fail;
    a = (node *) malloc(sizeof(node));
    a->key = key;
    a->l = NULL;
    a->r = NULL;
    return add(tree, a);
}

enum status pop(node **tree, int key) {
    node *p = findParent(*tree, key);
    node *a;
    node *son;
    node *sonNotNull;
    if(p == NULL) return fail;
    a = hashCmp(p->key, key) == first ? p->l : p->r;
    if (a == NULL || a->key != key) return fail;
    if (a->l == NULL && a->r == NULL) {
        if(a == p->l) p->l = NULL;
        else p->r = NULL;
        free(a);
        return success;
    }
    if (a->l != NULL) {
        sonNotNull = a->l;
        son = a->r;
    } else {
        assert(a->r != NULL);
        sonNotNull = a->r;
        son = a->l;
    }
    if(a == p->l) p->l = sonNotNull;
    else p->r = sonNotNull;
    free(a);
    if (son != NULL) return add(tree, son);
    return success;
}

void freeAll(node **tree) {
    node **stack = (node **) malloc(sizeof(node *) * NODES_MAX);
    int stSize = 0;
    node *n;
    stack[stSize++] = *tree;
    while (stSize) {
        n = stack[--stSize];
        if (n->l != NULL) stack[stSize++] = n->l;
        if (n->r != NULL) stack[stSize++] = n->r;
        n->l = NULL;
        n->r = NULL;
        free(n);
    }
    free(stack);
}

#ifdef __cplusplus
}
#endif
