//
// Created by zuevval on 11.07.19.
//

#ifndef DISJOINT_SET_FOREST_GRAPH_TEST_H
#define DISJOINT_SET_FOREST_GRAPH_TEST_H

#include<stdio.h>
#include<stdlib.h>
#define VERTICES_IN_EDGE (2)

int ** graphMemAlloc(int q) {
    int ** graph = (int **)malloc(q * sizeof(int *));
    for (int i = 0; i < q; i++)
        graph[i] = (int *)malloc(q * sizeof(int) * VERTICES_IN_EDGE);
    return graph;
}

void graphRead(int q, int ** graph, FILE * fin) {
    int v, u;
    for (int i = 0; i < q; i++) {
        fscanf(fin, "%i %i\n", &v, &u);
        graph[i][0] = v;
        graph[i][1] = u;
        printf("%i %i\n", graph[i][0], graph[i][1]);
    }
}

void graphMemFree(int q, int ** graph) {
    for (int i = 0; i < q; i++)
        free(graph[i]);
}

#endif //DISJOINT_SET_FOREST_GRAPH_TEST_H