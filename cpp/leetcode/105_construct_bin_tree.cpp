#include <vector>
#include <cassert>

struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

class Solution {
    static bool ifLeftSon(const int parent, const int son, const std::vector<int>& inorder);
    static void add(const int value, const std::vector<int>& inorder, TreeNode* root);
public:
    TreeNode* buildTree(std::vector<int>& preorder, std::vector<int>& inorder) {
        if(preorder.empty()) return nullptr;
        auto root = new TreeNode(preorder[0]);
        for(int i=1; i<preorder.size(); i++) add(preorder[i], inorder, root);
        return root;
    }
};

bool Solution::ifLeftSon(const int parent, const int son, const std::vector<int>& inorder){
    int parentIndex = -1;
    int sonIndex = -1;
    for(int i = 0; i<inorder.size(); i++){
        if(inorder[i] == parent) parentIndex = i;
        if (inorder[i] == son) sonIndex = i;
    }
    return sonIndex < parentIndex;
}

void Solution::add(const int value, const std::vector<int>& inorder, TreeNode* const root){
    TreeNode* current = root;
    while(true){
        bool isLeft = ifLeftSon(current->val, value, inorder);
        if(isLeft){
            if(current->left == nullptr){
                current->left = new TreeNode(value);
                return;
            }
            current = current->left;
        } else {
            if(current->right == nullptr){
                current->right = new TreeNode(value);
                return;
            }
            current = current->right;
        }
    }
}

void test1(){
    std::vector<int>preorder = std::vector<int>({1,2});
    std::vector<int>inorder = std::vector<int>({2,1});
    Solution s = Solution();
    TreeNode* root = s.buildTree(preorder, inorder);
    assert(root->val == 1);
    assert(root->right == nullptr);
    assert(root->left->val == 2);
}

void test2(){
    /* 3
      / \
     9  20
       /  \
      15   7 */
    std::vector<int>preorder = std::vector<int>({3,9,20,15,7});
    std::vector<int>inorder = std::vector<int>({9,3,15,20,7});
    Solution s = Solution();
    TreeNode* root = s.buildTree(preorder, inorder);
    assert(root->val == 3);
    assert(root->left->val == 9);
    assert(root->left->right == nullptr);
    assert(root->left->left == nullptr);
    assert(root->right->val == 20);
    assert(root->right->left->val == 15);
    assert(root->right->right->val == 7);
}

int main(void){
    // TODO free memory (trees) in tests
    test1();
    test2();
}