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
      TreeNode() : val(-1), left(NULL), right(NULL) {}
	  void printThis(std::ostream out) {
		  int depth = 0;
	  }
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

struct subtreeInfo {
	int min;
	int max;
	bool isBST;
	subtreeInfo() : min(INT_MAX), max(INT_MIN), isBST(true) {}
};

class Solution {
	subtreeInfo checkIfBST(TreeNode * root) {
		subtreeInfo res;
		if (root == NULL) return res;

		if (root->left != NULL) {
			subtreeInfo resLeft = checkIfBST(root->left);
			res.isBST &= (resLeft.max < root->val);
			res.isBST &= resLeft.isBST;
			res.min = resLeft.min < root->val ? resLeft.min : root->val;
			//if (!resLeft.isBST) return resLeft; 
			//surprisingly, made for speeding up, the line above slows down the program!
		} else res.min = root->val;
		if (root->right != NULL) {
			subtreeInfo resRight = checkIfBST(root->right);
			res.isBST &= (resRight.min > root->val);
			res.isBST &= resRight.isBST;
			res.max = resRight.max > root->val ? resRight.max : root->val;
			//if (!resRight.isBST) return resRight;
		} else res.max = root->val;
		return res;

	}
public:
	bool isValidBST(TreeNode* root) {
		return checkIfBST(root).isBST;
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
		if(isdigit(buf[currChar])) {
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
		if(buf[currChar] != 0)
			currChar++;
	}
	Solution s;
	cout << s.isValidBST(t) << std::endl;
	//printPlus(t);
	return 0;
}