//
// Created by valerii on 13.12.18.
//
#ifndef LABE_GITSHRUB_FUNCTIONS_H
#define LABE_GITSHRUB_FUNCTIONS_H

#ifdef __cplusplus
extern "C" {
#endif

#ifndef MY_CONSTANTS
#define MY_CONSTANTS
    #define maxnum 1100 //max number of versions; normally >= maxdepth
    #define maxstrlen 100
    #define rootData -1
    #define maxdepth 1000 //max tree depth
    #define errFlag -1
    #define failureFlag 0
    #define successFlag 1
#endif

#define MAG  "\x1B[35m" //magenda color
#define NRM  "\x1B[0m"  //black color

struct Node {
    int data;
    int vers;
    struct Node * r;
    struct Node * l;
};
typedef struct Node Node;

int count (int vers, Node *trees);
int topData(int vers, Node * trees);
void printPlus(int vers, Node *trees);
void printVers(int vers, Node *trees);
void newVersPop(Node * trees, int vers, int data);
void newVersPush(Node * trees, int vers, int data);
int findNode (Node * t, int data);
void init(Node *trees, int n);
void freeTrees(int vers, Node * trees);
void removeVers(int vers, Node *trees);
int readno(char*);

#ifdef __cplusplus
}
#endif

#endif //LABE_GITSHRUB_FUNCTIONS_H
