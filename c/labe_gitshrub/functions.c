//
// Created by valerii on 13.12.18.
//
#ifdef __cplusplus
extern "C" {
#endif

#include "functions.h"
#include<ctype.h>
#include<stdlib.h>
#include<stdio.h>
#include<assert.h>

int count (int vers, Node *trees){
    int stackTop, res = 0;
    Node ** stack = (Node **)malloc(maxdepth*sizeof(Node*));
    Node * t = trees + vers;
    stackTop = 0;
    if (t->r != NULL){
        assert(t->data == -1);
        stack [++stackTop] = t->r; //stack[0] is always empty
    }
    while(stackTop){
        t = stack[stackTop--];
        if(t->r != NULL)
            stack[++stackTop] = t->r;
        if(t->l != NULL)
            stack[++stackTop] = t->l;
        res++;
    }
    free(stack);
    return res;
}

int topData(int vers, Node * trees){
    Node * t = trees + vers;
    if(t->r == NULL)
        return errFlag;
    else
        return t->r->data;
}
void print1 (Node *t, int depth, int ifLeftSon){
    int i;
    if(t->r != NULL)
        print1(t->r, depth+1, 0);
    for(i=0; i<depth; i++){
        printf("%s","   ");
        if(i == depth - 1){
            if(ifLeftSon)
                printf("\\->");
            else
                printf("/->");
        }
    }
    printf("%d\n", t->data);
    if(t->l != NULL)
        print1(t->l, depth+1, 1);
}

void printPlus(int vers, Node *trees){
    Node * t = trees + vers;
    if(t->r != NULL){
        print1(t->r, 0, 0);
    }
    //printf("%*c", 20, 'a');
}

void printVers(int vers, Node *trees){
    int stackTop;
    Node ** stack = (Node **)malloc(maxdepth*sizeof(Node*));
    Node * t = trees + vers;
    stackTop = 0;
    if (t->r != NULL){
        assert(t->data == -1);
        stack [++stackTop] = t->r; //stack[0] is always empty
    }
    while(stackTop){
        t = stack[stackTop--];
        if(t->r != NULL)
            stack[++stackTop] = t->r;
        if(t->l != NULL)
            stack[++stackTop] = t->l;
        printf("%d ", t->data);
    }
    printf("\n");
    free(stack);
}

Node * copy(Node * n, int vers){
    Node * m = (Node *)malloc(sizeof(Node));
    m->data = n->data;
    m->l = n->l;
    m->r = n->r;
    m->vers = vers;
    return m;
}

Node * newLeaf(int vers, int data){
    Node * m = (Node *)malloc(sizeof(Node));
    m->data = data;
    m->l = NULL;
    m->r = NULL;
    m->vers = vers;
    return m;
}

void newVersPop(Node * trees, int vers, int data){
    //assuming data is in the tree
    enum {
        left,
        right
    } n1IsSon;
    Node * n1, * n2, * t, * n1parent;
    n1 = trees + vers;
    t = trees + vers - 1;
    while (n1->data != data){
        if (n1->data > data){ //copy left, leave old right, go left
            assert(t->l != NULL);
            n1->l = copy(t->l, vers);
            n1parent = n1;
            n1IsSon = left;
            n1 = n1->l;
            t = t->l;
        } else {
            assert(n1->data < data);
            assert(t->r != NULL);
            n1->r = copy(t->r, vers);
            n1parent = n1;
            n1IsSon = right;
            n1 = n1->r;
            t = t->r;
        }
    }
    if(n1->l == NULL || n1->r == NULL){ //simple case: n1parent becomes a new parent of n1's son
        assert(n1->data != -1); //if true, n1IsSon must have been initialized
        if (n1IsSon == right)
            n1parent->r = (n1->r == NULL) ? (n1->l) : (n1->r);
        else
            n1parent->l = (n1->r == NULL) ? (n1->l) : (n1->r);
        free (n1);
    } else { //go once left (using n2), right till end, replace n1's value with n2's, remove n2
        assert(t->l != NULL);
        assert(t->r != NULL);
        n2 = copy(t->l, vers);
        n1->l = n2;
        t = t->l;
        if(t->r == NULL){
            n1->data = n2->data;
            n1->l = n2->l;
            free(n2);
            return;
        }
        while (t->r->r != NULL){
            n2->r = copy(t->r, vers);
            t = t->r;
            n2 = n2->r;
        }
        n2->r = t->r->l;
        n1->data = t->r->data;
    }
}

void newVersPush(Node * trees, int vers, int data){
    //assuming data is not in the tree
    Node * n1;
    Node * t;
    n1 = trees + vers;
    t = trees + vers - 1;
    while (1){
        if(data < n1->data){
            if(t->l != NULL){
                n1->l = copy(t->l, vers);
                n1 = n1->l;
                t = t->l;
            } else{
                n1->l = newLeaf(vers, data);
                break;
            }
        } else {
            assert(data > n1->data);
            if(t->r != NULL){
                n1->r = copy(t->r, vers);
                n1 = n1->r;
                t = t->r;
            } else{
                n1->r = newLeaf(vers, data);
                break;
            }
        }
    }
}

int findNode (Node * t, int data){
    //t is a super-root of a particular version
    while (t->data != data){
        if (data > t->data){
            if (t->r != NULL)
                t = t->r;
            else
                return failureFlag;
        } else {
            assert(data < t->data);
            if (t->l != NULL)
                t = t->l;
            else
                return failureFlag;
        }
    }
    return successFlag;
}

void init(Node *trees, int n){
    int i;
    for(i=0; i<n; i++){
        trees[i].data = rootData;
        trees[i].vers = i;
        trees[i].l = NULL;
        trees[i].r = NULL;

    }
}

void freeTrees(int vers, Node * trees){
    int i;
    for (i=vers; i>0; i--){
        removeVers(i, trees);
    }
}

void removeVers(int vers, Node *trees){
    int stackTop;
    Node ** stack = (Node **)malloc(maxdepth*sizeof(Node*));
    Node * t = trees + vers;
    stackTop = 0;
    if (t->r != NULL && t->r->vers == vers){
        assert(t->data == -1);
        stack [++stackTop] = t->r; //stack[0] is always empty
    }
    while(stackTop){
        t = stack[stackTop--];
        if(t->l != NULL && t->l->vers == vers)
            stack[++stackTop] = t->l;
        if(t->r != NULL && t->r->vers == vers)
            stack[++stackTop] = t->r;
        free(t);
    }
    trees[vers].r = NULL;
    free(stack);
}

int readno(char* s){
    const int shiftMultiple = 10;
    int res = 0;
    if(!isdigit(*s))
        return errFlag;
    while (isdigit(*s)){
        res*=shiftMultiple;
        res+=*s-'0';
        s++;
    }
    return res;
}

#ifdef __cplusplus
}
#endif

