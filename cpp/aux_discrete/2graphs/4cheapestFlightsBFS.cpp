#include<iostream>
#include<fstream>
#include<climits>
#include<cassert>
#include<vector>
#include<queue>
using namespace std;

class myGraph {
	vector<vector<int>> C; //edges
	int n;
public:
	myGraph(vector<vector<int>>& costs, int N);
	int bfs(int s, int t, int K); //breadth first search
	void printC(){
		for (int i = 0; i < n; i++) {
			if (i < 10) cout << " ";
			cout << i << " ";
			for (int j = 0; j < n; j++) {
				if (C[i][j] < INT_MAX) {
					cout << C[i][j] << " ";
					if (C[i][j] < 100) cout << " ";
					if (C[i][j] < 10) cout << " ";
				}
				else cout << "inf ";
			}
			cout << endl;
		}
	}
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

struct node {
	int sum;
	int depth;
	int v; //vertex from 0 to n-1
};
const unsigned int MaxNodes = 1000;
int myGraph::bfs(int s, int t, int K) {
	if (s == t) return 0;
	queue<node> q;
	int res = -1;
	vector <node> best;
	best.resize(n);
	for (int i = 0; i < n; i++) {
		if (i == s) continue;
		(best[i]).depth = INT_MAX;
		(best[i]).sum = INT_MAX;
	}
	node nd;
	nd.depth = 0;
	nd.v = s;
	nd.sum = 0;
	q.push(nd);
	vector <node> paths;
	while (q.size()) {
		nd = q.front();
		/*
		cout << "v:" << nd.v << endl;
		cout << "depth:" << nd.depth << endl;
		cout << "sum:" << nd.sum << endl;
		char dummy;
		cin >> dummy;
		if (q.size() > 100) {
			cout << q.size() << endl;
		}*/
		q.pop();
		for (int u = 0; u < n; u++) {
			if (u == s) continue;
			if (C[nd.v][u] < INT_MAX) {
				node nd2;
				nd2.depth = nd.depth + 1;
				nd2.sum = nd.sum + C[nd.v][u];
				nd2.v = u;
				if (nd2.depth < (best[u]).depth && nd2.sum < (best[u]).sum) {
					best[u].depth = nd2.depth;
					best[u].sum = nd2.sum;
				} else if (nd2.depth > (best[u]).depth && nd2.sum > (best[u]).sum) continue;
				if (u == t) paths.push_back(nd2);
				else if (nd2.depth <= K) q.push(nd2);
			}
		}
	}
	//cout << paths.size() << endl;
	int minCost = INT_MAX;
	for (auto & p : paths) {
		assert(p.v == t);
		assert(p.depth <= K + 1); // <= K stops excluding last
		if (p.sum < minCost) minCost = p.sum;
	}
	if (minCost == INT_MAX) return -1;
	return minCost;
}

class Solution {
public:
	int findCheapestPrice(int n, vector<vector<int>>& flights, int src, int dst, int K) {
		myGraph g(flights, n);
		//g.printC();
		return g.bfs(src, dst, K);
	}
};

int getInt(char * buf, int & curChar) {
	int res = buf[curChar++] - '0';
	while (isdigit(buf[curChar])) {
		res *= 10;
		res += buf[curChar] - '0';
		curChar++;
	}
	curChar++; //skipping space character
	return res;
}

int main(void) {
	const unsigned int maxChars = 100;
	vector<vector<int>> costs;
	int curChar = 0;
	char * buf = new char[maxChars];
	ifstream in("input.txt");
	in.getline(buf, maxChars);
	int n = getInt(buf, curChar); //number of nodes
	curChar = 0;
	in.getline(buf, maxChars);
	int cLen = getInt(buf, curChar); //length of costs
	curChar = 0;
	costs.resize(cLen);
	for (int i = 0; i < cLen; i++) {
		in.getline(buf, maxChars);
		curChar = 0;
		int u = getInt(buf, curChar);
		int v = getInt(buf, curChar);
		int w = getInt(buf, curChar);
		costs[i].push_back(u);
		costs[i].push_back(v);
		costs[i].push_back(w);
	}
	curChar = 0;
	in.getline(buf, maxChars);
	int src = getInt(buf, curChar);
	curChar = 0;
	in.getline(buf, maxChars);
	int dst = getInt(buf, curChar);
	curChar = 0;
	in.getline(buf, maxChars);
	int K = getInt(buf, curChar);
	curChar = 0;
	Solution s;
	cout << s.findCheapestPrice(n, costs, src, dst, K) << endl;

	delete buf;
}