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

int find(node * root, const int key, node ** queue){
    //depth traverse
    //pushes the path into queue
    int qSize = 0;
    node * a;
    if(root != NULL) queue[qSize++] = root;
    while(qSize){
        a = queue[qSize - 1];
        if(key == a->key) return ++qSize;
        if(key > a->key && a->r != NULL) queue[qSize++] = a->r;
        else if(key < a->key && a->l != NULL) queue[qSize++] = a->l;
        else return qSize;
    }
    return qSize;
}

void push(node ** root, int key){
    int i, dif;
    node ** queue = (node **)malloc(sizeof(node*)*NODES_MAX);
    int qSize = find(*root, key, queue);
    node * a = (node *)malloc(sizeof(node));
    a->l = NULL;
    a->r = NULL;
    a->depth = 1;
    a->key = key;
    if(!qSize){ //empty tree
        *root = a;
        return;
    }
    if(queue[qSize - 1]->key == key) return; //already in the tree

    //append 'a' as a child of queue[qSize - 1]
    if(key > queue[qSize - 1]->key){
        assert(queue[qSize - 1]->r == NULL);
        queue[qSize-1]->r = a;
    }
    if(key < queue[qSize - 1]->key){
        assert(queue[qSize - 1]->l == NULL);
        queue[qSize-1]->l = a;
    }
    //TODO: update depth of every element in the queue.
    //TODO: If (dif = queue[i]->r->depth - queue[i]->l->depth) < -1 or > 1, re-balance
    for(i = qSize - 1; i > 0; i--){
        if(queue[i]->r == NULL) {
            queue[i]->depth = 1 + queue[i]->l->depth;
            dif = 1 + queue[i]->l->depth;
        }
        else if (queue[i]->l == NULL){
            queue[i]->depth = 1 + queue[i]->r->depth;
            dif = 1 + queue[i]->r->depth;
        } else {
            queue[i]->depth = 1 +  MyMax(queue[i]->r->depth,queue[i]->l->depth);
            dif = queue[i]->r->depth - queue[i]->l->depth;
        }
        if(dif > 1) zig(queue[i], queue[i-1]);
        if(dif < -1) zag(queue[i], queue[i-1]);
    }
    free(queue);
}