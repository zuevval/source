#include<gtest/gtest.h>
#include"functions.h"
#include<stdlib.h>

TEST(init, basic){
    int i;
    Node * trees = (Node *)malloc(maxnum*sizeof(Node));
    init(trees, maxnum);
    for(i=0; i<maxnum; i++){
        EXPECT_EQ(i, trees[i].vers);
    }
    free(trees);
}

TEST(newVersPush, simple){
    int vers = 0;
    int data1 = 5;
    Node * trees = (Node *)malloc(maxnum*sizeof(Node));
    Node * t;
    init(trees, maxnum);
    vers ++;
    newVersPush(trees, vers, data1);
    t = trees + vers;
    EXPECT_EQ(-1, t->data);
    EXPECT_NE((Node *)NULL, t->r);
    t = t->r;
    EXPECT_EQ(data1, t->data);
    freeTrees(vers, trees);
    free(trees);
}

const int n = 3;
TEST(newVersPush, simple2){
    int i;
    int data [n] = {2, 1, 3};
    Node * trees = (Node *)malloc(maxnum*sizeof(Node));
    Node * t;
    init(trees, maxnum);
    for(i=1; i<n+1; i++){
        newVersPush(trees, i, data[i-1]);
    }
    t = trees + n;
    EXPECT_EQ(-1, t->data);
    EXPECT_NE((Node *)NULL, t->r);
    t = t->r;
    EXPECT_EQ(data[0], t->data);
    EXPECT_NE((Node *)NULL, t->l);
    EXPECT_NE((Node *)NULL, t->r);
    EXPECT_EQ(data[1], t->l->data);
    EXPECT_EQ(data[2], t->r->data);
    freeTrees(n, trees);
    free(trees);
}

static const int n1 = 4;
TEST(newVersPop, simple){
    int i;
    int data [n1-1] = {2, 1, 3};
    Node * trees = (Node *)malloc(maxnum*sizeof(Node));
    Node * t;
    init(trees, maxnum);
    for(i=1; i<n1; i++){
        newVersPush(trees, i, data[i-1]);
    }
    newVersPop(trees, n1, data[0]);
    t = trees + n1;
    EXPECT_EQ(-1, t->data);
    EXPECT_NE((Node *)NULL, t->r);
    t = t->r;
    EXPECT_EQ(data[1], t->data);
    EXPECT_EQ((Node *)NULL, t->l);
    EXPECT_NE((Node *)NULL, t->r);
    EXPECT_EQ(data[2], t->r->data);

    freeTrees(n1, trees);
    free(trees);
}

static const int n2 = 4;
TEST(removeVers, simple){
    int i;
    int data [n2] = {2, 1, 3, 4};
    Node * trees = (Node *)malloc(maxnum*sizeof(Node));
    Node * t;
    init(trees, maxnum);
    for(i=1; i<n2+1; i++){
        newVersPush(trees, i, data[i-1]);
    }
    t = trees + n2; // t<=> super-root
    EXPECT_NE((Node *)NULL, t->r);
    t = t->r;
    EXPECT_NE((Node *)NULL, t->r);
    EXPECT_NE((Node *)NULL, t->r->r);
    EXPECT_EQ(data[3], t->r->r->data);
    removeVers(n2, trees);
    t = trees + n2 - 1; // t<=> super-root
    EXPECT_NE((Node *)NULL, t->r);
    t = t->r;
    EXPECT_NE((Node *)NULL, t->r);
    EXPECT_EQ(data[2], t->r->data);
    EXPECT_EQ((Node *)NULL, t->r->r);

    EXPECT_NE((Node *)NULL, t->l);
    EXPECT_EQ(data[1], t->l->data);

    freeTrees(n2, trees);
    free(trees);
}

TEST(removeVers, simple2){
    int i;
    int data [n2-1] = {2, 1, 3};
    Node * trees = (Node *)malloc(maxnum*sizeof(Node));
    Node * t;
    init(trees, maxnum);
    for(i=1; i<n2; i++){
        newVersPush(trees, i, data[i-1]);
    }
    newVersPop(trees, n2, data[0]);
    t = trees + n2; // t<=> super-root
    EXPECT_NE((Node *)NULL, t->r);
    t = t->r;
    EXPECT_EQ(data[1], t->data);
    EXPECT_NE((Node *)NULL, t->r);
    EXPECT_EQ(data[2], t->r->data);
    EXPECT_EQ((Node *)NULL, t->l);
    removeVers(n2, trees);

    t = trees + n2 - 1; // t<=> super-root
    EXPECT_NE((Node *)NULL, t->r);
    t = t->r;
    EXPECT_NE((Node *)NULL, t->r);
    EXPECT_NE((Node *)NULL, t->l);
    EXPECT_EQ(data[2], t->r->data);
    EXPECT_EQ(data[1], t->l->data);

    freeTrees(n2, trees);
    free(trees);
}

static const int n4 = 15;
TEST(pushPopRollBack, normal){ @\label{line:pushPopRollBack}@
    int data[n4] = {10, 5, 15, 2, 8, 12, 18, 1, 3, 6, 9, 11, 14, 17, 19};
    int i, flag, n5;
    Node * trees = (Node *)malloc(maxnum*sizeof(Node));
    Node * t;
    init(trees, maxnum);
    for(i=1; i<n4+1; i++){
        newVersPush(trees, i, data[i-1]);
    }

    EXPECT_EQ(n4, count(n4, trees));

    for(i=0; i<n4; i++){
        flag = findNode(trees+n4, data[i]);
        EXPECT_EQ(1, flag);
    }
    EXPECT_EQ(data[0], topData(n4, trees));

    n5 = n4+1;
    newVersPop(trees, n5, data[0]); //remove the root - 10
    EXPECT_EQ(data[10], topData(n5, trees)); //new root should be 9
    EXPECT_EQ(0, findNode(trees+n5, data[0])); //10 shouldn't be in the tree
    EXPECT_EQ(1, findNode(trees+n4, data[0])); //10 should remain in the previous version
    removeVers(n5, trees);
    for(i=0; i<n4; i++)
        EXPECT_EQ(1, findNode(trees+n4, data[i]));
    freeTrees(n4, trees);
    free(trees);
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}

