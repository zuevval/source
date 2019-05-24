#include<iostream>
#include<fstream>
#include<vector>
#include<stack>
#include<memory>
using namespace std;
struct node {
	int v;
	shared_ptr<node> next;
};
class Graph{
	vector<vector<int>> C;
	shared_ptr<node> loop; //TODO: refactor loop->cycle
	int loopSize;
	int m; //number of edges
	bool isConnected();
	shared_ptr<node> findNextStart();
	shared_ptr<node> findNextLoop(shared_ptr<node> start);
public:
	Graph(int n, vector<pair<int, int>> & E);
	shared_ptr<node> EulerLoop();
};
bool Graph::isConnected() {
	int n = C.size();
	if (n == 0) return true;
	vector<bool> ticked;
	ticked.resize(n);
	stack<int> st;
	st.push(0);
	ticked[0] = true;
	while (st.size()) {
		int v = st.top();
		st.pop();
		for (int i = 0; i < n; i++) {
			if (C[v][i] && !ticked[i]) {
				ticked[i] = true;
				st.push(i);
			}
		}
	}
	for(int i=0; i<n; i++){
		if (!ticked[i]) return false;
	}
	for (int i = 0; i < n; i++) {
		int sum = 0;
		for (int j = 0; j < n; j++) sum += C[i][j];
		if (sum % 2) return false;
	}
	return true;
}
shared_ptr<node> Graph::EulerLoop() {
	if(!isConnected()) return NULL;
	while (loopSize < m) {
		auto start = findNextStart();
		if (start == NULL) return NULL;
		auto next = start->next;
		auto end = findNextLoop(start);
		end->next = next;
	}
	auto end = loop;
	while (end->next != NULL) end = end->next;
	if (end->v != loop->v) return NULL;
	return loop;
}
shared_ptr<node> Graph::findNextStart() {
	int n = C.size();
	auto v = loop;
	bool hasEdge = false;
	while (v != NULL) {
		for (int i = 0; i < n; i++) hasEdge |= (bool)(C[v->v][i]);
		if (hasEdge) return v;
		v = v->next;
	}
	return NULL;
}
shared_ptr<node> Graph::findNextLoop(shared_ptr<node> start) {
	int n = C.size();
	auto res = start;
	int v = res->v;
	int u = -1;
	while(true) {
		for (int i = 0; i < n; i++) {
			if (C[v][i]) {
				C[v][i]--;
				C[i][v]--;
				u = i;
				break;
			}
		}
		if (u == -1) break;
		auto unode = make_shared<node>();
		unode->v = u;
		res->next = unode;
		res = unode;
		loopSize++;
		v = u;
		u = -1;
	}
	return res;
}
Graph::Graph(int n, vector<pair<int, int>> & E) {
	C.resize(n);
	for (int i = 0; i < n; i++) C[i].resize(n);
	for (auto & e : E) {
		C[e.first][e.second]++;
		C[e.second][e.first]++;
	}
	node start;
	start.v = 0;
	loop = make_shared<node>(start);
	m = E.size();
	loopSize = 0;
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
	auto cycle = g.EulerLoop();
	if (cycle == NULL || cycle->next == NULL) cout << "NONE" << endl;
	else {
		while (cycle->next != NULL) {
			cout << ++(cycle->v) << endl;
			cycle = cycle->next;
		}
	}
}

int main(void) {
	/*ifstream in("input4.txt");
	process(in);
	in.close();*/
	process(cin);
	return 0;
}