#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include"functions.h"

int processInput(char * buf, int vers, Node *trees);

int main(void) { @\label{line:main}@
    Node * trees = (Node *)malloc(maxnum*sizeof(Node));
    int version = 0;
    char * buf = (char *)calloc(maxstrlen+1, sizeof(char));
    init(trees, maxnum);
    fgets(buf, maxstrlen, stdin);
    while(buf[0] != 'q'){ //"q"="quit"
        version = processInput(buf, version, trees);
        fgets(buf, maxstrlen, stdin);
    }
    freeTrees(version, trees);
    free(trees);
    free(buf);
    return 0;
}

int processInput(char * buf, int vers, Node *trees){ @\label{line:processInput}@
    int flag, data;
    buf[0] = tolower(buf[0]);
    switch (buf[0]){
        case '+':
            data = readno (buf+1);
            if(data == errFlag){
                printf("incorrect command\n");
                break;
            }
            flag = findNode(trees + vers, data);
            if(flag){
                printf("trying to insert %d: already in the tree "
                       "in current version (%d)\n", data, vers);
            } else {
                vers++;
                newVersPush(trees, vers, data);
            }
            break;
        case '-':
            data = readno (buf+1);
            if(data == errFlag){
                printf("incorrect command\n");
                break;
            }
            flag = findNode(trees + vers, data);
            if(flag){
                vers++;
                newVersPop(trees, vers, data);
            } else {
                printf("trying to delete %d: no such element "
                       "in current version (%d)\n", data, vers);
            }
            break;
        case '?':
            data = readno (buf+1);
            if(data == errFlag){
                printf("incorrect command\n");
                break;
            }
            flag = findNode(trees+vers, data);
            if(flag){
                printf("element %d is in the tree\n", data);
            } else {
                printf("element %d wasn't found in this version\n", data);
            }
            break;
        case 'u':
            if (vers <= 0)
                printf("no earlier versions\n");
            else if(vers >= maxnum-1){
                printf("you've reached the limit\n");
                break;
            }
            else
                removeVers(vers--, trees);
            break;
        case 'r':
            data = topData(vers, trees);
            if(data == rootData)
                printf("The tree is empty\n");
            else
                printf("Root key: %d\n", data);
            break;
        case '#':
            data = count(vers, trees);
            printf("The tree contains %d elements\n", data);
            break;
        default:
            printf("Unknown command");
    }
    return vers;
}


