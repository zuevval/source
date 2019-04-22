//
// Created by zuevval on 22.04.19.
//
#include<gtest/gtest.h>
#include "functions.h"
#include<cstdlib>
#include<climits>

TEST(push, init){
    node * r = NULL;
    push(&r, 1);
    EXPECT_TRUE(r != NULL);
    EXPECT_EQ(r->key, INT_MAX);
    EXPECT_TRUE(r->l != NULL);
    //EXPECT_NE(r->l, NULL);
    EXPECT_EQ(r->l->key, 1);
    freeAll(r);
}

TEST(push, many){
    node * r = NULL;
    push(&r, 2);
    push(&r, 0);
    push(&r, 4);
    push(&r, 3);
    push(&r, 5);
    push(&r, -1);
    push(&r, 1);
    /*       _2_
     *    _0_   _4_
     *  -1  1  3  5*/
    EXPECT_TRUE(r->l != NULL);
    node * s = r->l;
    EXPECT_EQ(s->key, 2);
    EXPECT_TRUE(s->l != NULL);
    EXPECT_TRUE(s->l->r != NULL);
    EXPECT_TRUE(s->l->l != NULL);
    EXPECT_TRUE(s->r != NULL);
    EXPECT_TRUE(s->r->l != NULL);
    EXPECT_TRUE(s->r->r != NULL);
    EXPECT_EQ(s->l->key, 0);
    EXPECT_EQ(s->l->r->key, 1);
    EXPECT_EQ(s->l->l->key, -1);
    EXPECT_EQ(s->r->key, 4);
    EXPECT_EQ(s->r->l->key, 3);
    EXPECT_EQ(s->r->r->key, 5);
    freeAll(r);
}

TEST(push, zig){
    node * r = NULL;
    push(&r, 2);
    push(&r, 1);
    push(&r, 0);
    node * s = r->l;
    /*    _2        _1_
     *  _1    -->  0  2
     * 0
     * */
    EXPECT_EQ(s->key, 1);
    EXPECT_EQ(s->l->key, 0);
    EXPECT_EQ(s->r->key, 2);
    freeAll(r);
}

TEST(push, zag){
    node * r = NULL;
    push(&r, 0);
    push(&r, -1);
    push(&r, 4);
    push(&r, 5);
    push(&r, 1);
    node * s = r->l;
    EXPECT_EQ(s->key, 0);
    EXPECT_EQ(s->l->key, -1);
    EXPECT_EQ(s->r->key, 4);
    EXPECT_EQ(s->r->r->key, 5);
    EXPECT_EQ(s->r->l->key, 1);
    /*       _0_                _1_
     *    -1    _4_   --->    _0   _4_
     *         1  5         -1    2  5  */
    push(&r, 2);
    s = r->l;
    EXPECT_EQ(s->key, 1);
    EXPECT_EQ(s->l->key, 0);
    EXPECT_EQ(s->l->l->key, -1);
    EXPECT_EQ(s->r->key, 4);
    EXPECT_EQ(s->r->r->key, 5);
    EXPECT_EQ(s->r->l->key, 2);
    freeAll(r);
}

TEST(pop, zig){
    node * r = NULL;
    push(&r, 2);
    push(&r, 1);
    push(&r, 3);
    push(&r, 0);
    node * s = r->l;
    EXPECT_EQ(s->key, 2);
    EXPECT_EQ(s->l->key, 1);
    EXPECT_EQ(s->r->key, 3);
    EXPECT_EQ(s->l->l->key, 0);
    /*       _2_               _1_
     *    _1     3   --->     0   2
     *   0                          */
    pop(&r, 3);
    s = r->l;
    EXPECT_EQ(s->key, 1);
    EXPECT_EQ(s->l->key, 0);
    EXPECT_EQ(s->r->key, 2);
    freeAll(r);
}

TEST(pop, notLeaf){
    node * r = NULL;
    push(&r, 2);
    push(&r, 1);
    push(&r, 4);
    push(&r, 0);
    push(&r, 3);
    push(&r, 5);
    node * s = r->l;
    EXPECT_EQ(s->key, 2);
    EXPECT_EQ(s->l->key, 1);
    EXPECT_EQ(s->l->l->key, 0);
    EXPECT_EQ(s->r->key, 4);
    EXPECT_EQ(s->r->l->key, 3);
    EXPECT_EQ(s->r->r->key, 5);
    /*       _2_                 _1_
     *    _1    _4_   --->     0   _4_
     *   0     3  5               3   5 */
    pop(&r, 2);
    s = r->l;
    EXPECT_EQ(s->key, 1);
    EXPECT_EQ(s->l->key, 0);
    EXPECT_EQ(s->r->key, 4);
    EXPECT_EQ(s->r->r->key, 5);
    EXPECT_EQ(s->r->l->key, 3);
    EXPECT_TRUE(s->l->l == NULL);
    EXPECT_TRUE(s->l->r == NULL);
    freeAll(r);
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}

