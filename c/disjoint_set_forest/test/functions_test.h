//
// Created by zuevval on 11.07.19.
//

#ifndef DISJOINT_SET_FOREST_FUNCTIONS_TEST_H
#define DISJOINT_SET_FOREST_FUNCTIONS_TEST_H

#include"dsf_test.h"
#define MAX_BUF_SIZE (100)

dsu_t toDSU (int ** graph, int p, int q){
    node_t ** allNodes = (node_t **)malloc(p * sizeof(node_t *));
    int u, v;
    dsu_t res;
    for(int i=0; i<p; i++) allNodes[i] = NULL;
    for(int i=0; i<q; i++){
        u = graph[i][0];
        v = graph[i][1];
        if(allNodes[u] == NULL) allNodes[u] = initSet(u);
        if(allNodes[v] == NULL) allNodes[v] = initSet(v);
        unite(allNodes[u], allNodes[v]);
    }
    res.nUnions = 0;
    for(int i=0; i<p; i++)
        if(allNodes[i]->head == allNodes[i]) res.nUnions++;
    res.unions = (node_t **)malloc(res.nUnions * sizeof(node_t *));
    int j = 0;
    for(int i=0; i<p; i++){
        if(allNodes[i]->head == allNodes[i]){
            res.unions[j] = allNodes[i];
            j++;
        }
    }
    free(allNodes);
    return res;
}

#endif //DISJOINT_SET_FOREST_FUNCTIONS_TEST_H
