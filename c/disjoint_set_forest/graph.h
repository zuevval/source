#ifndef DISJOINT_SET_FOREST_GRAPH_H
#define DISJOINT_SET_FOREST_GRAPH_H
#include<stdio.h>
#include<stdlib.h>

#define VERTICES_IN_EDGE (2)

int ** graphMemAlloc(int q);
void graphRead(int q, int ** graph, FILE * fin);
void graphMemFree(int q, int ** graph);
#endif //DISJOINT_SET_FOREST_GRAPH_H
