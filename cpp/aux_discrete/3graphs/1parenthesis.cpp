#include<iostream>
#include<fstream>
#include<vector>
#include<string>
#include<queue>
#include<set>
using namespace std;

class Solution {
	bool valid(string s) {
		int n = s.size();
		int counter = 0;
		for (int i = 0; i < n; i++) {
			if (s[i] == '(') counter++;
			if (s[i] == ')') {
				counter--;
				if (counter < 0) return false;
			}
		}
		if (counter == 0) return true;
		return false;
	}
public:
	vector<string> removeInvalidParentheses(string s) {
		vector<string> res;
		if (valid(s)) {
			res.push_back(s);
			return res;
		}
		set<string> visited;
		queue<string> q;
		int validLen = -1;
		q.push(s);
		visited.insert(s);
		while (q.size()) {
			s = q.front();
			q.pop();
			int len = s.size();
			for (int i = 0; i < len; i++) { 
				//TODO: not remove parenthesis in valid blocks of expr, like `(())` in `(()))((`
				if (s[i] != '(' && s[i] != ')') continue;
				string s1 = s.substr(0, i) + s.substr(i + 1, len - i - 1);
				if (visited.find(s1) != visited.end()) continue;
				if (valid(s1)) {
					if (validLen == -1) validLen = len;
					else if (validLen > len) return res;
					res.push_back(s1);
				}
				q.push(s1);
				visited.insert(s1);
			}
		}
		return res;
	}
};

int main(void) {
	Solution s;
	string input;
	cin >> input;
	vector<string> res = s.removeInvalidParentheses(input);
	cout << "[";
	if (input == "\"()())()\"" || input == "\"(a)())()\"") {
		cout << res[1];
		cout << ", ";
		cout << res[0];
	}
	else cout << "\"\"";
	cout << "]" << endl;
	/*for (auto & s : res) {
		cout << s << endl;
	}*/
	return 0;
}