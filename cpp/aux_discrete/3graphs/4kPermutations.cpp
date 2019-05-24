#include<iostream>
#include<fstream>
#include<vector>
#include<string>
#include<queue>
using namespace std;

class Solution {
public:
	int kSimilarity(string A, string B) {
		if (A == B) return 0;
		string good = A;
		string bad = B;
		int n = good.size();
		queue<pair<string, int>> q;
		q.push(make_pair(bad, 0));
		while (q.size()) {
			auto curr = q.front();
			q.pop();
			bad = curr.first;
			int k = curr.second;
			int i = 0;
			while (bad[i] == good[i]) i++;
			if (!(i < n)) return k;
			k++; //we'll make one more permutation
			for (int j = i + 1; j < n; j++) {
				if (bad[j] == good[i]) {
					string better = bad;
					better[j] = better[i];
					better[i] = good[i]; //good[i] == previous better[j]
					if (better == good) return k;
					q.push(make_pair(better, k));
				}
			}
		}
		return -1;
	}
};

int main(void) {
	Solution s;
	string A;
	string B;
	string buf;
	getline(cin, buf);
	if (buf == "A = \"abc\", B = \"bca\"") {
		A = "abc";
		B = "bca";
	} else if(buf == "A = \"abac\", B = \"baca\"") {
		A = "abac";
		B = "baca";
	}
	else if (buf == "A = \"ab\", B = \"ba\"") {
		A = "ab";
		B = "ba";
	}
	else {
		A = "aabc";
		B = "abca";
	}
	cout << s.kSimilarity(A, B) << endl;
	return 0;
}
