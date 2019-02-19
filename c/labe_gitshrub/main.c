#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include"functions.h"

int processInput(char * buf, int vers, Node *trees);

int main(void) {
    Node * trees = (Node *)malloc(maxnum*sizeof(Node));
    int version = 0;
    char * buf = (char *)calloc(maxstrlen+1, sizeof(char));
    printf("This is GitShrub, a powerful version control system.\n"
           "To view the list of supported commands, type 'h'\n");
    init(trees, maxnum);
    fgets(buf, maxstrlen, stdin);
    while(buf[0] != 'q'){
        if(version >= maxnum-1){
            printf("you've reached the limit\n");
            return 0;
        }
        version = processInput(buf, version, trees);
        fgets(buf, maxstrlen, stdin);
    }
    freeTrees(version, trees);
    free(trees);
    free(buf);
    return 0;
}

int processInput(char * buf, int vers, Node *trees){
    int flag, data;
    buf[0] = tolower(buf[0]);
    switch (buf[0]){
        case '+':
            data = readno (buf+1);
            if(data == -1){
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
            if(data == -1){
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
            if(data == -1){
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
            else
                removeVers(vers--, trees);
            break;
        case 'r':
            data = topData(vers, trees);
            if(data == -1)
                printf("The tree is empty\n");
            else
                printf("Root key: %d\n", data);
            break;
        case 'p':
            if(buf[1] == 'p'){
                printPlus(vers, trees);
                break;
            }
            printVers(vers, trees);
            break;
        case '#':
            data = count(vers, trees);
            printf("The tree contains %d elements\n", data);
            break;
        case 'h':
            printf("Supported commands:\n"
                   "+<x> - add an element\n"
                   "-<x> - remove an element\n"
                   "?<x> - search for an element\n"
                   "u, U - roll back to previous version\n"
                   "r, R - view the root of the tree\n"
                   "# - count the number of elements\n"
                   "p - print all elements\n"
                   "pp - view the whole tree (beta)\n"
                   "q - terminate program\n"
                   "(<x> is any positive int, or zero)\n");
            break;
        default:
            printf("Unknown command:");
            printf("%s %s %s\n", MAG, buf, NRM);
            printf("type 'h' to see the list of supported commands\n");

    }
    return vers;
}


