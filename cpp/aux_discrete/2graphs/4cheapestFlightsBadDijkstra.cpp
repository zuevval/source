#include<iostream>
#include<fstream>
#include<climits>
#include<cassert>
#include<vector>
using namespace std;

struct ans {
	vector<int> T;
	vector<int> H;
	vector<int> Q;
	bool isCorrect;
};

class myGraph {
	vector<vector<int>> C; //edges
	int n;
	bool dijkstraIter(vector<bool>& X, vector<int>& T, 
		vector<int>& H, vector<int>& Q, int v, int t, int K);
public:
	myGraph(vector<vector<int>>& costs, int N);
	ans dijkstra(int s, int t, int K);
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

ans myGraph::dijkstra(int s, int t, int K) {
	vector<bool> X;
	vector<int> H;
	vector<int> Q;
	X.resize(n);
	H.resize(n);
	Q.resize(n);
	vector<int>T;
	T.resize(n);
	for (int i = 0; i < n; i++) T[i] = INT_MAX;
	int v = s;
	X[v] = 1;
	T[v] = 0;
	ans ansdij;
	ansdij.isCorrect = dijkstraIter(X, T, H, Q, v, t, K);
	ansdij.T = T;
	ansdij.H = H;
	ansdij.Q = Q;
	return ansdij;
}
bool myGraph::dijkstraIter(vector<bool>& X, vector<int>& T,
	vector<int>& H, vector<int>& Q, int v, int t, int K) {
	for (int u = 0; u < n; u++) {
		//if (T[u] - T[v] > C[v][u]) { //original dijkstra, means if time to u is bigger than to ..->v->u
		if (T[u] - T[v] > C[v][u] && Q[v] + 1 - 1 <= K) { //counting stops+dst, later subtract dst
			//assert(!X[u]);
			T[u] = T[v] + C[v][u];
			H[u] = v;
			Q[u] = Q[v] + 1;
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
	return dijkstraIter(X, T, H, Q, v, t, K);
}

class Solution {
public:
	int findCheapestPrice(int n, vector<vector<int>>& flights, int src, int dst, int K) {
		myGraph g(flights, n);
		ans a = g.dijkstra(src, dst, K);
		if (!a.isCorrect) return -1;
		return (a.T)[dst];
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