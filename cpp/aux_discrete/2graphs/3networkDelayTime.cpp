#include<iostream>
#include<climits>
#include<vector>
using namespace std;
class myGraph {
	vector<vector<int>> C; //edges
	vector<vector<int>> T; //T[i][j] = smallest time from i to j
	vector<vector<int>> H; //H[i][j] = next vertex on shortest path from i to j
	int N;
	void floyd();
public:
	myGraph(vector<vector<int>>& times, int N);
	int maxTime(int K);
};

myGraph::myGraph(vector<vector<int>>& times, int n)
{
	N = n;
	C.resize(n);
	T.resize(n);
	H.resize(n);
	for (int i = 0; i < n; i++) {
		C[i].resize(n);
		T[i].resize(n);
		H[i].resize(n);
		for (int j = 0; j < n; j++) C[i][j] = INT_MAX;
		C[i][i] = 0;
	}
	for (auto & i : times) {
		int u = i[0] - 1; //source node, enumeration differs
		int v = i[1] - 1; //target node, enumeration differs
		int w = i[2]; //time from u to v directly
		C[u][v] = w;
	}
}

void myGraph::floyd() {
	const int no_path = -1;
	for (int i = 0; i < N; i++) {
		for (int j = 0; j < N; j++) {
			T[i][j] = C[i][j];
			if (C[i][j] == INT_MAX)
				H[i][j] = no_path;
			else
				H[i][j] = j;
		}
	}
	for(int i=0; i<N; i++){
		for (int j = 0; j < N; j++) {
			if (i == j) continue;
			for (int k = 0; k < N; k++) {
				if (i == k) continue;
				/*
				set new path from j to k: j->...->i->...->k
				if better than previous j->...->k
				*/
				if (T[j][i] != INT_MAX && T[i][k] != INT_MAX) {
					if (T[j][k] > T[j][i] + T[i][k]) {
						T[j][k] = T[j][i] + T[i][k];
						H[j][k] = H[j][i]; //to reach k, go to i
					}
				}
			}
		}
		/*
		here Floyd checks for cycles with negative lenght
		(unnecessary in this task)
		*/
	}
}

int myGraph::maxTime(int K) {
	if (N == 1) return 1; //TODO: ask teacher if it should be 0 really
	floyd();
	int res = -1;
	for (int i = 0; i < N; i++) {
		if (i == K - 1) continue;
		if (T[K-1][i] > res && T[K-1][i] < INT_MAX) res = T[K-1][i]; //enumeration differs for K
		if (H[K - 1][i] == -1) return -1; //if node unreachable, no solution
	}
	return res;
}

class Solution {
public:
	int networkDelayTime(vector<vector<int>>& times, int N, int K) {
		myGraph g(times, N);
		return g.maxTime(K);
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
	vector<vector<int>> times;
	int curChar = 0;
	char * buf = new char[maxChars];
	cin.getline(buf, maxChars);
	int n = getInt(buf, curChar);
	curChar = 0;
	cin.getline(buf, maxChars);
	int k = getInt(buf, curChar);
	curChar = 0;
	cin.getline(buf, maxChars);
	int t = getInt(buf, curChar); //length of times
	times.resize(t);
	for (int i = 0; i < t; i++) {
		cin.getline(buf, maxChars);
		curChar = 0;
		int u = getInt(buf, curChar);
		int v = getInt(buf, curChar);
		int w = getInt(buf, curChar);
		times[i].push_back(u);
		times[i].push_back(v);
		times[i].push_back(w);
	}
	Solution s;
	cout << s.networkDelayTime(times, n, k) << endl;

	delete buf;
}