#include<iostream>
#include<fstream>
#include<cassert>
#include<string>
#include<vector>
#include<stack>
#include<map>
#include<set>
using namespace std;
class Graph {
	map<string, vector<pair<string, double>>> C;
public:
	Graph(vector<vector<string>> & equations, vector<double> & values);
	double weightDFS(string s, string t);
};
Graph::Graph(vector<vector<string>> & equations, vector<double> & values) {
	int n = equations.size();
	for (int i = 0; i < n; i++) {
		auto eq = equations[i];
		assert(eq.size() == 2);
		string v = eq[0];
		string u = eq[1];
		assert(v != u); //else algorithm slightly differs
		auto vInfo = C.find(v);
		auto uInfo = C.find(u);
		if (vInfo == C.end()) {
			vector<pair<string, double>> tmp;
			C.insert(make_pair(v, tmp));
			vInfo = C.find(v);
		}
		if (uInfo == C.end()) {
			vector<pair<string, double>> tmp;
			C.insert(make_pair(u, tmp));
			uInfo = C.find(u);
		}
		//v/u = values[i]
		(vInfo->second).push_back(make_pair(u, values[i]));
		(uInfo->second).push_back(make_pair(v, 1.0/values[i]));
	}
}

double Graph::weightDFS(string s, string t) {
	if (s == t) {
		if (C.find(s) == C.end()) return -1.0;
		return 1.0;
	}
	stack<pair<string, double>> st;
	set<string> visited;
	st.push(make_pair(s, 1.0)); //yet multiple is 1
	while (st.size()) {
		auto expr = st.top();
		st.pop();
		string u = expr.first;
		double multiple = expr.second;
		if (u == t) return multiple;
		visited.insert(u);
		if (C.find(u) == C.end()) continue;
		auto uList = (C.find(u))->second; //adjacency list of `u` vertex
		for (auto expr1 : uList) {
			if (visited.find(expr1.first) != visited.end()) continue;
			expr1.second *= multiple;
			st.push(expr1);
		}
	}
	return -1.0;
}

class Solution {
public:
	vector<double> calcEquation(vector<vector<string>>& equations, vector<double>& values, vector<vector<string>>& queries) {
		Graph g(equations, values);
		vector<double> res;
		for (auto & q : queries) {
			assert(q.size() == 2);
			res.push_back(g.weightDFS(q[0], q[1]));
		}
		return res;
	}
};

int main(void) {
	vector<vector<string>> equations = {{"a", "b"}, {"b", "c"}};
	vector<double> values = {2.0, 3.0};
	vector<vector<string>> queries = {{"a", "c"}, {"b", "a"}, {"a", "e"}, {"a", "a"}, {"x", "x"}};
	//vector<vector<string>> queries = {{"x", "x"}};
	Solution s;
	vector<double> ans = s.calcEquation(equations, values, queries);
	cout << "[";
	for (int i = 0; i < ans.size(); i++) {
		double a = ans[i];
		cout << a;
		if (a - (int)a == 0) cout << ".0";
		//if ((ans[i] % 1) == 0) cout << ".0";
		if (i != ans.size() - 1) cout << ", ";
	}
	cout << "]" << endl;
	return 0;
}