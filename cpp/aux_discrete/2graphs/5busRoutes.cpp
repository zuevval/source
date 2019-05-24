#include<iostream>
#include<fstream>
#include<climits>
#include<vector>
#include<stack>
#include<set>
using namespace std;

struct dijParam {
	vector<int> T;
	vector<int> H;
	stack<int> st;
	vector<bool> X;
	int s;
	int t;
	int v;
};

class myGraph {
	vector<set<int>> rel; //edges
	int n;
	dijParam dip;
public:
	myGraph(vector<vector<int>>& routes);
	int dijkstra(int s, int t);
};

myGraph::myGraph(vector<vector<int>>& routes) {
	rel.resize(n);
	for (auto & r : routes) {
		for (int i : r) {
			for (int j : r) {
				if (i == j) continue;
				(rel[i]).insert(j);
				(rel[j]).insert(i);
			}
		}
	}
}

int myGraph::dijkstra(int s, int t) {
	dip.H.resize(n);
}

class Solution {
public:
	int numBusesToDestination(vector<vector<int>>& routes, int S, int T) {

	}
};

int main(void) {
	return 0;
}