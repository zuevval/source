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
        if(key == a->key) return qSize;
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

void repair(node ** queue, int qSize){
    //update depth of every element in the queue.
    //If (dif = queue[i]->r->depth - queue[i]->l->depth) < -1 or > 1, re-balance
    int i, dif;
    for(i = qSize - 1; i > 0; i--){
        dif = calcDif(queue[i]);
        assert(Myabs(dif) < 3);
        if(dif > 1) smartZag(queue[i], queue[i-1]);
        if(dif < -1) smartZig(queue[i], queue[i-1]);
    }
}

void addNode (node ** tree, node * a){
    node ** queue = (node **)malloc(sizeof(node*)*NODES_MAX);
    int qSize = find(*tree, a->key, queue);
    if(!qSize){ //empty tree
        free(queue);
        init(tree);
        addNode(tree, a);
        return;
    }
    if(queue[qSize - 1]->key == a->key){
        free(queue);
        free(a);
        return; //already in the tree
    }

    //append 'a' as a child of queue[qSize - 1]
    if(a->key > queue[qSize - 1]->key){
        assert(queue[qSize - 1]->r == NULL);
        queue[qSize-1]->r = a;
    }
    if(a->key < queue[qSize - 1]->key){
        assert(queue[qSize - 1]->l == NULL);
        queue[qSize-1]->l = a;
    }
    repair(queue, qSize);
    free(queue);
}

void push(node ** tree, int key){
    node * a = (node *)malloc(sizeof(node));
    a->l = NULL;
    a->r = NULL;
    a->depth = 1;
    a->key = key;
    addNode(tree, a);
}

void pop(node ** tree, int key){
    int i, dif;
    node * aParent;
    node * bigSon;
    node * smallSon;
    node ** queue = (node **)malloc(sizeof(node *)*NODES_MAX);
    int qSize = find(*tree, key, queue);
    node * a = queue[--qSize];
    if(a->key != key){
        free(queue);
        return; //element is not in the tree
    }
    aParent = queue[qSize - 1];
    if(a->r == NULL || (a->l != NULL && a->r->depth > a->l->depth)){
        bigSon = a->r;
        smallSon = a->l;
    } else {
        bigSon = a->l;
        smallSon = a->r;
    }
    if (aParent->l == a) aParent->l = bigSon;
    else aParent->r = bigSon;
    free(a);
    repair(queue, qSize);

    if(smallSon != NULL) {
        node ** stack = (node **)malloc(NODES_MAX*sizeof(node *));
        int stSize = 0;
        stack[stSize++] = smallSon;
        while(stSize){
            a = stack[--stSize];
            if(a->l != NULL)stack[stSize++] = a->l;
            if(a->r != NULL)stack[stSize++] = a->r;
            a->l = NULL;
            a->r = NULL;
            addNode(tree, a);
        }
        free(stack);
    }
    free(queue);
}

void freeAll(node * root){
    node * a;
    node ** stack = (node **)malloc(NODES_MAX*sizeof(node *));
    int stSize = 0;
    if(root != NULL) stack[stSize++] = root;
    while(stSize){
        a = stack[--stSize];
        if(a->l != NULL)stack[stSize++] = a->l;
        if(a->r != NULL)stack[stSize++] = a->r;
        a->l = NULL;
        a->r = NULL;
        free(a);
    }
    free(stack);
}