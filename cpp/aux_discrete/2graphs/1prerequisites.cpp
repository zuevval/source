#include<iostream>
#include<fstream>
#include<vector>
#include<stack>
#include<cassert>
using namespace std;

class Solution {
	vector<vector<bool>> adjacencyMatrix(int n, const vector<pair<int, int>>& prerequisites) {
		vector<vector<bool>> res(n);
		//res.resize(n);
		for (auto & row : res) row.resize(n);
		for (unsigned k = 0; k < prerequisites.size(); k++) {
			int i = prerequisites[k].first; //second in pair
			int j = prerequisites[k].second; //first in pair
			res[i][j] = true;
		}
		
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++)
				cout << res[i][j] << " ";
			cout << endl;
		}
		return res;
	}
public:
	vector<int> findOrder(int numCourses, vector<pair<int, int>>& prerequisites) {
		int n = numCourses;
		vector<vector<bool>> mtx = adjacencyMatrix(n, prerequisites);
		vector <int> order;
		if (n == 0) return order;
		vector <bool> isInChain(n);
		vector <bool> isPassed(n);
		stack <int> st;
		st.push(0);
		isInChain[0] = true;
		while (order.size() < n) {
			if (st.size() == 0) { //push next not passed; mark as inChain; continue;
				for (int i = 0; i < n; i++) {
					if (!isPassed[i]) {
						st.push(i);
						isInChain[i] = true;
						break;
					}
				}
				continue;
			}
			int row = st.top();
			bool isLeaf = true;
			for (int i = 0; i < n; i++) {
				if (mtx[row][i] && !isPassed[i]) {
					if (isInChain[i]) { //if encountered a cycle
						order.resize(0);
						return order;
					}
					isLeaf = false;
					st.push(i);
					isInChain[i] = true;
					break;
				}
			}
			if (isLeaf) {
				assert(st.top() == row);
				st.pop();
				isInChain[row] = false;
				isPassed[row] = true;
				order.push_back(row);
			}
		}
		return order;
	}
};

int main(void) {
	int n;
	cin >> n;
	int pairsNo;
	cin >> pairsNo;
	vector<pair<int, int>> p;
	int firstBuf, secondBuf;
	for (int i = 0; i < pairsNo; i++) {
		cin >> firstBuf;
		cin >> secondBuf;
		p.push_back(pair<int, int>(firstBuf, secondBuf));
	}	
	Solution s;
	vector<int> order = s.findOrder(n, p);
	for (int i = 0; i < order.size(); i++)
		cout << order[i] << " ";
	cout << endl;
}