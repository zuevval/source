//
// Created by zuevval on 21.04.19.
//
#include<stdlib.h>
#include<assert.h>
#include<limits.h>
#include "functions.h"

int calcDif(node * x){
    if(x->r == NULL){
        if(x->l == NULL){
            x->depth = 1;
            return 0;
        }
        x->depth = 1 + x->l->depth;
        return -x->l->depth;
    }
    if(x->l == NULL){
        x->depth = 1+x->r->depth;
        return x->r->depth;
    }
    x->depth = 1 + MyMax(x->r->depth, x->l->depth);
    return x->r->depth - x->l->depth;
}

/*     parent             parent
 *      |                  |
 *     _y_    --zig-->    _x_
 *   _x_  C              A  _y_
 *  A   B    <--zag--      B   C
 * */

void zig(node * y, node * parent){
    node * x = y->l;
    node * B = x->r;
    x->r = y;
    y->l = B;
    calcDif(y); //update depths of y, x; order is important
    calcDif(x);
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
    calcDif(x); //update depths of x, y; order is important
    calcDif(y);
    if(parent->r == x) parent->r = y;
    else{
        assert(parent->l == x);
        parent->l = y;
    }
}

void smartZig(node * y, node * parent){
    node * x = y->l;
    int xDiff = calcDif(x);
    if(xDiff > 0){
        assert(x->r != NULL);
        zag(x,y);
    }
    zig(y, parent);
}

void smartZag(node * x, node * parent){
    node * y = x->r;
    int yDiff = calcDif(y);
    if(yDiff < 0){
        assert(y->l != NULL);
        zig(y,x);
    }
    zag(x, parent);
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

void init(node ** tree){
    node * a = (node *)malloc(sizeof(node));
    a->l = NULL;
    a->r = NULL;
    a->depth = 1;
    a->key = INT_MAX;
    *tree = a;
}

void push(node ** tree, int key){
    int i, dif;
    node ** queue = (node **)malloc(sizeof(node*)*NODES_MAX);
    int qSize = find(*tree, key, queue);
    node * a;
    if(!qSize){ //empty tree
        init(tree);
        push(tree, key);
        return;
    }
    if(queue[qSize - 1]->key == key) return; //already in the tree
    a = (node *)malloc(sizeof(node));
    a->l = NULL;
    a->r = NULL;
    a->depth = 1;
    a->key = key;

    //append 'a' as a child of queue[qSize - 1]
    if(key > queue[qSize - 1]->key){
        assert(queue[qSize - 1]->r == NULL);
        queue[qSize-1]->r = a;
    }
    if(key < queue[qSize - 1]->key){
        assert(queue[qSize - 1]->l == NULL);
        queue[qSize-1]->l = a;
    }
    //update depth of every element in the queue.
    //If (dif = queue[i]->r->depth - queue[i]->l->depth) < -1 or > 1, re-balance
    for(i = qSize - 1; i > 0; i--){
        dif = calcDif(queue[i]);
        assert(Myabs(dif) < 3);
        if(dif > 1) smartZag(queue[i], queue[i-1]);
        if(dif < -1) smartZig(queue[i], queue[i-1]);
    }
    free(queue);
}