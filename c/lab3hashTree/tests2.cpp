//
// Created by zuevval on 25.04.19.
//

#include<gtest/gtest.h>
#include "functions.h"
//#include<cstdlib>
#include<climits>

TEST(init, basic){
    node * r = NULL;
    init(&r);
    EXPECT_EQ(r->key, INT_MAX);
    EXPECT_TRUE(r->l == NULL);
    EXPECT_TRUE(r->r == NULL);
    freeAll(&r);
}

TEST(push, basic){
    node *r;
    init(&r);
    enum status flag = push(&r, 1); //h=0
    EXPECT_EQ(success, flag);
    flag = push(&r, 1); //h=0
    EXPECT_EQ(fail, flag);
    push(&r, 2); //-1
    push(&r, -2); //3
    push(&r, -1); //2
    node * s = r->l; //r is super-root
    /*    _0_    <hashes    _1_
     *  -1  _3    keys>   2  _-2
     *     2               -1 */
    EXPECT_EQ(1, s->key);
    EXPECT_EQ(-2, s->r->key);
    EXPECT_EQ(2, s->l->key);
    EXPECT_EQ(-1, s->r->l->key);
    EXPECT_TRUE(s->l->r == NULL);
    EXPECT_TRUE(s->l->l == NULL);
    EXPECT_TRUE(s->r->r == NULL);
    EXPECT_TRUE(s->r->l->r == NULL);
    EXPECT_TRUE(s->r->l->l == NULL);
    freeAll(&r);
}

TEST(pop, basic) {
    node *r;
    init(&r);
    push(&r, 1); //h=0
    push(&r, 2); //-1
    push(&r, -2); //3
    push(&r, -1); //2
    /*    _0_    <hashes    _1_
     *  -1  _3    keys>   2  _-2
     *     2               -1 */
    enum status flag = pop(&r, -1);
    /*    _0_    <hashes    _1_
     *  -1   3    keys>   2   -2
     */
    EXPECT_EQ(success, flag);
    node * s = r->l;
    EXPECT_EQ(1, s->key);
    EXPECT_EQ(-2, s->r->key);
    EXPECT_EQ(2, s->l->key);
    EXPECT_TRUE(s->r->l == NULL);
    //EXPECT_TRUE(s->r->r == NULL);
    EXPECT_TRUE(s->l->l == NULL);
    EXPECT_TRUE(s->l->r == NULL);
    freeAll(&r);
}

TEST(pop, notLeaf) {
    node *r;
    init(&r);
    push(&r, 1); //h=0
    push(&r, 2); //-1
    push(&r, -2); //3
    push(&r, -1); //2
    enum status flag = pop(&r, 1);
    EXPECT_EQ(success, flag);
    flag = pop(&r, 1);
    EXPECT_EQ(fail, flag); //popping already popped out
    node * s = r->l;
    /*    -1_    <hashes     2_
     *      _3    keys>      _-2
     *     2               -1 */
    EXPECT_EQ(2, s->key);
    EXPECT_EQ(-2, s->r->key);
    EXPECT_EQ(-1, s->r->l->key);
    freeAll(&r);
}



int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}



