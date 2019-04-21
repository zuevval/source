//
// Created by zuevval on 21.04.19.
//
#include<stdlib.h>
#include<assert.h>
#include "functions.h"

/*     parent             parent
 *      |                  |
 *     _y_    --zig-->    _x_
 *   _x_  C              A  _y_
 *  A   B    <--zag--      B   C
 *
 * */

void zig(node * y, node * parent){
    node * x = y->l;
    node * B = x->r;
    x->r = y;
    y->l = B;
    (x->depth)++;
    (y->depth)--;
    if(parent->r == y) parent->r = x;
    else{
        assert(parent->l == y);
        parent->l = x;
    }
}
void zag(node * x, node * parent){
    node *y = x->r;
    node *B = y->l;
    y->l = x;
    x->r = B;
    (x->depth)--;
    (y->depth)++;
    if(parent->r == y) parent->r = x;
    else{
        assert(parent->l == y);
        parent->l = x;
    }
}

int find(const node * root, const int key, node ** stack){
    //depth traverse
    //pushes the path into stack
    //return stSize
    int stSize = 0;
    node * a;
    if(root != NULL) stack[stSize++] = root;
    while(stSize){
        a = stack[--stSize];
        if(key == a->key) return ++stSize;
        if(key > a->key && a->r != NULL) stack[stSize++] = a->r;
        if(key < a->key && a->l != NULL) stack[stSize++] = a->l;
    }
    return stSize;
}

void push(node * root, int key){
    node ** stack = (node **)malloc(sizeof(node*)*NODES_MAX);
    int stSize = find(root, key, stack);
    node * a = (node *)malloc(sizeof(node));
    a->l = NULL;
    a->r = NULL;
    a->depth = 1;
    a->key = key;
    if(!stSize){ //empty tree
        root = a;
        return;
    }
    if(stack[stSize - 1]->key == key) return; //already in the tree
    //append 'a' as a child of stack[stSize - 1]
    //update depth of every element in the stack.
    //If (dif = stack[i]->r->depth - stack[i]->l->depth) < -1 or > 1, re-balance
    free(stack);
}
