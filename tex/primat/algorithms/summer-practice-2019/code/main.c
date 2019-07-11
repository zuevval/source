#include"graph.h"
#include"dsf.h"
#define MAX_BUF_SIZE (100)
dsu_t toDSU (int ** graph, int p, int q);
int main(void) {
	FILE * fin = fopen("input.txt", "r");
	if (fin == NULL) {
		printf("error reading data\n");
		return 0;
	}
	char * buf = (char *)calloc(MAX_BUF_SIZE, sizeof(char));
	int p; //number of vertices in the graph
	int q; //number of edges in the graph
	fscanf(fin, "%i\n%i\n", &p, &q);
	int ** graph = graphMemAlloc(q); //array of edges ([No. of v1, No. of v2])
	graphRead(q, graph, fin);
    free(buf);
    fclose(fin);
	dsu_t dsu = toDSU(graph, p, q);
	for(int i=0; i< dsu.nUnions; i++) printSet(dsu.unions[i]);
	freeDSU(dsu);
    graphMemFree(q, graph);
	return 0;
}
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