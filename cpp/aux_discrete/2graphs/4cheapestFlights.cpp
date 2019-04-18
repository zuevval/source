#include<iostream>
#include<climits>
#include<cassert>
#include<vector>
using namespace std;

struct ans {
	vector<int> T;
	vector<int> H;
	bool isCorrect;
};

class myGraph {
	vector<vector<int>> C; //edges
	int n;
	bool dijkstraIter(vector<bool>& X, vector<int>& T, 
		vector<int>& H, int v, int t);
	ans dijkstra(int s, int t);
public:
	myGraph(vector<vector<int>>& costs, int N);
	//int minCost(int s, int t);
};

myGraph::myGraph(vector<vector<int>>& flights, int N)
{
	n = N;
	C.resize(n);
	for (int i = 0; i < n; i++) {
		C[i].resize(n);
		for (int j = 0; j < n; j++) C[i][j] = INT_MAX;
		C[i][i] = 0;
	}
	for (auto & i : flights) {
		int u = i[0]; //source node
		int v = i[1]; //target node
		int w = i[2]; //cost from u to v directly
		C[u][v] = w;
	}
}

ans myGraph::dijkstra(int s, int t) {
	vector<bool> X;
	vector<int> H;
	X.resize(n);
	vector<int>T;
	for (int i = 1; i < n; i++) T[i] = INT_MAX;
	int v = s;
	X[v] = 1; //T[i] == 0
	ans ansdij;
	ansdij.isCorrect = dijkstraIter(X, T, H, v, t);
	ansdij.T = T;
	ansdij.H = H;
	return ansdij;
}
bool myGraph::dijkstraIter(vector<bool>& X, vector<int>& T,
	vector<int>& H, int v, int t) {
	for (int u = 0; u < n; u++) {
		if (T[u] - T[v] > C[v][u]) {
			assert(!X[u]);
			T[u] = T[v] + C[v][u];
			H[u] = v;
		}
	}
	int m = INT_MAX; //minimal path
	v = 0;
	for (int u = 0; u < n; u++) {
		if (X[u]) continue;
		if (T[u] < m) {
			v = u;
			m = T[u];
		}
	}
	if (v == 0) return false; //no way
	if (v == t) return true; //cheapest found
	X[v] = 1; //found cheapest from s to v
	return dijkstraIter(X, T, H, v, t);
}

class Solution {
public:
	int findCheapestPrice(int n, vector<vector<int>>& flights, int src, int dst, int K) {

	}
};
