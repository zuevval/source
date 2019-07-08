#include "graph.h"

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
