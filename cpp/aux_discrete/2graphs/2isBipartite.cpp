#include<iostream>
#include<vector>
using namespace std;
class myGraph {
	vector <int> depth;
	vector <vector <int>> rel; //rel[i] is an array of vertices adjacent to i
	int n;
	int searchCycle(int i, int j, int jDepth) {
		depth[j] = jDepth;
		jDepth++;
		for (int k : rel[j]) {
			if (depth[k] == -1) { //if hasn't visited node 'k' before
				int len = searchCycle(i, k, jDepth);
				if (len != -1) return len; //if cycle with 'i' found, return its length
			}
			else if (k == i) return jDepth; //thus algorithm considers i<->k to be a cycle, but it doesn't affect the answer
		}
		return -1;
	}
public:
	myGraph(vector<vector<int>> g) : n(g.size()), rel(g){
		depth.resize(n);
		for (int i = 0; i < n; i++)
			depth[i] = -1;
	};
	bool hasOddCycle();
};
class Solution {
public:
	bool isBipartite(vector<vector<int>>& graph) {
		myGraph g(graph);
		return !g.hasOddCycle();
	}
};

bool myGraph::hasOddCycle() {
	for (int i = 0; i < n; i++) {
		for (int j : rel[i]) {
			for (int k = 0; k < n; k++) depth[k] = -1;
			int currDepth = 0;
			depth[i] = currDepth;
			currDepth++;
			int cycleDepth = searchCycle(i, j, currDepth);
			if (cycleDepth == -1) continue;
			if ((cycleDepth % 2)) return true;
		}
		//rel[i].resize(0); //TODO: find out why doesn't work
	}
	return false;
}

int main(void) {
	const unsigned maxChars = 1001;
	char buf[maxChars];
	std::cin.getline(buf, maxChars);
	int currChar = 0;
	int n = buf[currChar++] - '0';
	while (isdigit(buf[currChar])) {
		n *= 10;
		n += buf[currChar] - '0';
		currChar++;
	}
	vector<vector<int>> g;
	for (int i = 0; i < n; i++) {
		std::cin.getline(buf, maxChars);
		vector<int> row;
		int currChar = 0;
		int v = 0;
		while (buf[currChar] != 0) {
			row.push_back(buf[currChar++] - '0');
			while (isdigit(buf[currChar])) {
				row[v] *= 10;
				row[v] += buf[currChar] - '0';
				currChar++;
			}
			v++;
		}
		g.push_back(row);
		currChar++; //to skip space
	}
	Solution s;
	cout << (s.isBipartite(g) ? "true" : "false");
	return 0;
}