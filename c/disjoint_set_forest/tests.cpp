//
// Created by zuevval on 11.07.19.
//

#include<gtest/gtest.h>
#include<vector>
#include<random>

#include "test/functions_test.h"

TEST(initSet1, general){
    std::vector<int> a = {-1, 0, 1, 2, 100};
    for(int i : a){
        node_t * test = initSet(i);
        EXPECT_EQ(test->data, i);
        //EXPECT_EQ(test->next, NULL);
        EXPECT_EQ(test->head, test);
        freeSet(test);
    }
}

std::pair<std::vector<node_t*>, std::vector<node_t*>> fillAB (int aLen, int bLen){
    std::vector<node_t*> a;
    std::vector<node_t*> b;
    for(int i=0; i< aLen; i++) a.push_back(initSet((int)rand()));
    for(int i=0; i<aLen; i++){
        a[i]->head = a[0];
        if(i < aLen - 1) a[i]->next = a[i+1];
    }
    for(int i=0; i< bLen; i++) b.push_back(initSet((int)rand()));
    for(int i=0; i<bLen; i++){
        b[i]->head = b[0];
        if(i < bLen - 1) b[i]->next = b[i+1];
    }
    return std::make_pair(a, b);
}

TEST(unite, basic){
    const int aLen = 3;
    const int bLen = 4;
    auto ab = fillAB(aLen, bLen);
    auto a = ab.first;
    auto b = ab.second;
    unite(a[(int)rand() % aLen], b[(int)rand() % bLen]);
    int i = 0;
    node_t * ai = a[0];
    while(ai != NULL){
        EXPECT_EQ(ai->head, a[0]);
        if (i < aLen + bLen - 1)
            EXPECT_EQ(ai->next, (i >= aLen - 1 ? b[i - aLen + 1] : a[i + 1]));
        ai = ai->next;
        i++;
    }
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}

