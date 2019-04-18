#include<cstdio>
#include<climits>
#include<iostream>
#include<vector>
#include<cctype> 

struct TreeNode {
	int val;
	TreeNode *left;
	TreeNode *right;
	TreeNode(int x) : val(x), left(NULL), right(NULL) {}
	TreeNode() : val(INT_MIN), left(NULL), right(NULL) {}
};

void print1(TreeNode * t, int depth, int ifLeftSon) {
	int i;
	if (t->right != NULL)
		print1(t->right, depth + 1, 0);
	for (i = 0; i < depth; i++) {
		printf("%s", "   ");
		if (i == depth - 1) {
			if (ifLeftSon)
				printf("\\->");
			else
				printf("/->");
		}
	}
	printf("%d\n", t->val);
	if (t->left != NULL)
		print1(t->left, depth + 1, 1);
}

void printPlus(TreeNode *t) {
	print1(t, 0, 0);
	//printf("%*c", 20, 'a');
}

class Solution {
public:
	int maxDepth(TreeNode* root) {
		int res = 0;
		if (root == NULL || root->val == INT_MIN)
			return res;
		res++;
		int resRight = maxDepth(root->right);
		int resLeft = maxDepth(root->left);
		res += (resRight > resLeft ? resRight : resLeft);
		return res;
	}
};
using namespace std;
int main(void) {
	const unsigned maxNodes = 100;
	const unsigned maxChars = 1001;
	TreeNode * t = new TreeNode[maxNodes];
	char buf[maxChars];
	std::cin.getline(buf, maxChars);
	int currNode = 0;
	int currParent = 0;
	int currChar = 0;
	while (buf[currChar] != 0) {
		if (isdigit(buf[currChar])) {
			if (currNode != 0) {
				if (currNode % 2) t[currParent].left = t + currNode;
				else t[currParent++].right = t + currNode;
			}
			t[currNode].val = buf[currChar++] - '0';
			while (isdigit(buf[currChar])) {
				t[currNode].val *= 10;
				t[currNode].val += buf[currChar] - '0';
				currChar++;
			}
		}
		else {
			if (!(currNode % 2)) currParent++;
			currChar += 4; //length of 'null'
		}
		currNode++;
		if (buf[currChar] != 0)
			currChar++;
	}
	Solution s;
	cout << s.maxDepth(t) << std::endl;
	//printPlus(t);
	return 0;
}