#include<iostream>
#include<vector>
#include<queue>
#include<set>
using namespace std;

class Solution {
	vector<vector<int>> Routes;
	bool contains(int route, int stop) {
		for (auto stop1 : Routes[route]) {
			if (stop1 == stop) return true;
		}
		return false;
	}
	int bfs(int route, int stop) {
		if (contains(route, stop)) return 1;
		int n = Routes.size();
		set<int> visited;
		queue<pair<int, int>> q; //first - route, second - depth
		q.push(make_pair(route, 1)); //initial depth is 1
		visited.insert(route);
		while (q.size()) {
			auto curr = q.front();
			q.pop();
			route = curr.first;
			int depth = curr.second;
			depth++; //we'll descend a step deeper
			for (int i : Routes[route]) {
				//i is a stop
				//push every bus containing i to queue, if not visited before
				//TODO: make a graph of buses and check it instead
				for (int j = 0; j < n; j++) { //j is a bus
					if (visited.find(j) != visited.end()) continue;
					if (!contains(j, i)) continue;
					if (contains(j, stop)) return depth;
					q.push(make_pair(j, depth));
					visited.insert(j);
				}
			}
		}
		return -1;
	}
public:
	int numBusesToDestination(vector<vector<int>>& routes, int S, int T) {
		if (S == T) return 0;
		Routes = routes;
		int n = routes.size();
		vector<int> startRoutes;
		for (int i = 0; i < n; i++) { //if this route contains start...
			if (contains(i, S)) startRoutes.push_back(i);
		}
		int res = -1;
		for (int route : startRoutes) {
			int depth = bfs(route, T);
			if (res == -1 || depth < res) res = depth;
		}
		return res;
	}
};

int main(void) {
	Solution s;
	vector<vector<int>> routes = { {1, 2, 7},{3, 6, 7} };
	cout << s.numBusesToDestination(routes, 1, 6);
	//vector<vector<int>> routes = {{1, 9, 12, 20, 23, 24, 35, 38}, {10, 21, 24, 31, 32, 34, 37, 38, 43}, {10, 19, 28, 37}, {8}, {14, 19}, {11, 17, 23, 31, 41, 43, 44}, {21, 26, 29, 33}, {5, 11, 33, 41}, {4, 5, 8, 9, 24, 44}};
	//cout << s.numBusesToDestination(routes, 37, 28);
	return 0;
}