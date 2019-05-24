#include<iostream>
#include<fstream>
#include<vector>
#include<stack>
#include<map>
using namespace std;

class Graph {
	vector<vector<bool>> C; //matrix of minimal
public:
	bool canVisitAll();
	Graph(vector<vector<int>>& rooms);
};

Graph::Graph(vector<vector<int>>& rooms) {
	int n = rooms.size();
	C.resize(n);
	for (int i = 0; i < n; i++) {
		C[i].resize(n);
		for (int j : rooms[i]) {
			C[i][j] = true;
		}
	}
}

bool Graph::canVisitAll() {
	int n = C.size();
	if (n == 0) return 0;
	stack<int> st;
	vector<bool> ticked;
	ticked.resize(n);
	int v = 0;
	ticked[v] = true;
	st.push(v);
	while (st.size()) {
		v = st.top();
		st.pop();
		for (int u = 0; u < n; u++) {
			if (C[v][u] && !ticked[u]) {
				ticked[u] = true;
				st.push(u);
			}
		}
	}
	bool res = true;
	for (auto t : ticked) res &= t;
	return res;
}

class Solution {
public:
	bool canVisitAllRooms(vector<vector<int>>& rooms) {
		Graph g(rooms);
		return g.canVisitAll();
	}
};

int main(void) {
	Solution s;
	vector<vector<int>> rooms;
	char * buf = new char[100];
	cin >> buf;
	//if (buf == "[[1],[2],[3],[]]") rooms = { {1}, {2}, {3}, {} };
	if (buf[3] == ']') rooms = { {1}, {2}, {3}, {} };
	//else if (buf == "[[1,3],[3,0,1],[2],[0]]") rooms = { {1,3}, {3,0,1}, {2}, {0} };
	else if (buf[3] == ',') rooms = { {1,3}, {3,0,1}, {2}, {0} };
	else {
		cout << "Hey, I want to solve discrete math, not write string parsers\n";
		cout << buf;
		return 0;
	}
	cout << (s.canVisitAllRooms(rooms) ? "true" : "false") << endl;
	delete buf;
	return 0;
}