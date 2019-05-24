#include<iostream>
#include<fstream>
#include<vector>
#include<stack>
using namespace std;
class Graph {
	vector<vector<bool>> C;
public:
	Graph(int n, vector<pair<int, int>> & E);
	int components();
};
Graph::Graph(int n, vector<pair<int, int>> & E) {
	C.resize(n);
	for (int i = 0; i < n; i++) C[i].resize(n);
	for (auto & e : E) {
		C[e.first][e.second] = true;
		C[e.second][e.first] = true;
	}
}
int Graph::components() {
	int n = C.size();
	if (n == 0) return 0;
	stack<int> st;
	vector<bool> ticked;
	ticked.resize(n);
	int res = 0;
	int v = 0;
	do {
		ticked[v] = true;
		st.push(v);
		while (st.size()) {
			v = st.top();
			st.pop();
			for (int u = 0; u < n; u++) {
				if (C[u][v] && !ticked[u]) {
					ticked[u] = true;
					st.push(u);
				}
			}
		}
		res++;
		v = -1;
		for (int i = 0; i < n; i++) {
			if (!ticked[i]) {
				v = i;
				break;
			}
		}
	} while (v >= 0);
	return res;
}

void process(istream & in) {
	int n, m, first, second;
	in >> n;
	in >> m;
	vector<pair<int, int>> E;
	for (int i = 0; i < m; i++) {
		in >> first;
		in >> second;
		E.push_back(pair<int, int>(--first, --second));
	}
	Graph g(n, E);
	cout << g.components() << endl;
}

int main(void) {
	/*ifstream in("input4.txt");
	process(in);
	in.close();*/
	process(cin);
	return 0;
}