#include"functions.h"

int main(void) {
	FILE * fin = fopen("input.txt", "r");
	if (fin == NULL) {
		printf("error reading data\n");
		return 0;
	}
	char * buf = (char *)calloc(MAX_BUF_SIZE, sizeof(char));
	int p; //number of vertices in the graph
	int q; //number of edges in the graph

	//reading graph from input file
	fscanf(fin, "%i\n%i\n", &p, &q);
	//printf("%i %i\n", p, q);
	int ** graph = graphMemAlloc(q); //array of edges ([No. of v1, No. of v2])
	graphRead(q, graph, fin);
    free(buf);
    fclose(fin);

    //converting to disjoint set union and printing
	dsu_t dsu = toDSU(graph, p, q);
	for(int i=0; i< dsu.nUnions; i++) printSet(dsu.unions[i]);

	freeDSU(dsu);
    graphMemFree(q, graph);
	return 0;
}
