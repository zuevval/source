#include<iostream>
#include<fstream>
#include<vector>
#include<stack>
#include<map>
using namespace std;

class Graph {
	multimap<int, pair<int, int>> E;
	vector<vector<bool>> C; //matrix of minimal
	bool connected(int i, int j);
public:
	Graph(int n, multimap<int, pair<int, int>> E);
	void printMinSpanningTree();
};

Graph::Graph(int n, multimap<int, pair<int, int>> edges) {
	E = edges;
	C.resize(n);
	for (int i = 0; i < n; i++) C[i].resize(n);
}

void Graph::printMinSpanningTree() {
	for (auto& e : E) {
		//cout << "weight: " << e.first << endl;
		int u = e.second.first;
		int v = e.second.second;
		if (!connected(u, v)) {
			C[u][v] = true;
			C[v][u] = true;
			cout << u << " " << v << endl;
		}
	}
}

bool Graph :: connected(int i, int j) { //depth first search
	int n = C.size();
	if (i >= n || j >= n) { cerr << "err"; return false; }
	stack<int> s;
	vector<bool> v; //visited vertices
	v.resize(n);
	v[i] = true; //i visited
	s.push(i);
	int u;
	while (s.size()) {
		u = s.top();
		s.pop();
		for (int k = 0; k < n; k++) {
			if (C[u][k]) { //if k adjacent u
				if (k == j) return true;
				if (!v[k]) { //if not visited
					v[k] = true;
					s.push(k);
				}
			}
		}
	}
	return false;
}

void solve(istream & in) {
	int n;
	in >> n;
	int m;
	in >> m;
	int e;
	pair<int, int> t;
	multimap<int, pair<int, int>> E;
	for (int i = 0; i < m; i++) {
		in >> t.first;
		in >> t.second;
		in >> e;
		E.insert(pair<int, pair<int, int>>(e, t));
	}
	Graph g(n, E);
	g.printMinSpanningTree();
}

int main(void) {
	/*ifstream in("input3.txt");
	solve(in);
	in.close();*/
	solve(cin);
	return 0;
}