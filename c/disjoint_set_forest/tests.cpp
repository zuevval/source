//
// Created by zuevval on 11.07.19.
//

#include<gtest/gtest.h>
#include<vector>
#include<map>
#include<random>
#include<cmath>

#include "test/functions_test.h"

TEST(initSet1, general){
    std::vector<int> a = {-1, 0, 1, 2, 100};
    for(int i : a){
        node_t * test = initSet(i);
        EXPECT_EQ(test->data, i);
        EXPECT_TRUE(test->next == NULL);
        EXPECT_EQ(test->head, test);
        freeSet(test);
    }
}

std::pair<std::vector<node_t*>, std::vector<node_t*>> fillAB (int aLen, int bLen){
    std::vector<node_t*> a;
    std::vector<node_t*> b;
    for(int i=0; i< aLen; i++) a.push_back(initSet((int)(i + log((double)(i+1)))));
    for(int i=0; i<aLen; i++){
        a[i]->head = a[0];
        if(i < aLen - 1) a[i]->next = a[i+1];
    }
    for(int i=0; i< bLen; i++) b.push_back(initSet((int)(a[aLen - 1]->data + i+1 + log((double)(i+1)))));
    for(int i=0; i<bLen; i++){
        b[i]->head = b[0];
        if(i < bLen - 1) b[i]->next = b[i+1];
    }
    return std::make_pair(a, b);
}

void testUnite(std::pair<std::vector<node_t*>, std::vector<node_t*>> ab){
    int aLen = ab.first.size();
    int bLen = ab.second.size();
    auto a = ab.first;
    auto b = ab.second;
    bool setsDifferent = a[0]->head->data != b[0]->head->data;
    unite(a[(int)rand() % aLen], b[(int)rand() % bLen]);
    int i = 0;
    node_t * ai = a[0]->head;
    node_t * bi = b[0]->head;
    while(ai != NULL){
        EXPECT_EQ(ai->head, a[0]);
        EXPECT_FALSE(bi == NULL);
        EXPECT_EQ(bi->head, a[0]);
        EXPECT_EQ(bi->data, ai->data);
        ai = ai->next;
        bi = bi->next;
        i++;
    }
    if(setsDifferent) EXPECT_EQ(i, aLen + bLen);
    else{
        EXPECT_EQ(i, aLen);
        EXPECT_EQ(bLen, aLen);
    }
    freeSet(a[0]);
}

TEST(unite, basic){
    const int aLen = 3;
    const int bLen = 4;
    auto ab = fillAB(aLen, bLen);
    testUnite(ab);
}

TEST(unite, bigSets){
    const int aLen = 100;
    const int bLen = 1000;
    auto ab = fillAB(aLen, bLen);
    testUnite(ab);
}

TEST(unite, singleElementSet){
    const int aLen = 1;
    const int bLen = 1;
    auto ab = fillAB(aLen, bLen);
    testUnite(ab);
}

TEST(unite, sameSets){
    const int aLen = 1;
    const int bLen = 0;
    auto ab = fillAB(aLen, bLen);
    ab.second = ab.first;
    testUnite(ab);
}

TEST(unite, bigSameSets){
    const int aLen = 1000;
    const int bLen = 0;
    auto ab = fillAB(aLen, bLen);
    ab.second = ab.first;
    testUnite(ab);
}

void testDSU(int p, int q){
    int ** graph = graphMemAlloc(q);
    for(int i=0; i<q; i++){
        graph[i][0] = (int)(rand())%p;
        graph[i][1] = (int)(rand())%p;
    }
    dsu_t dsu = toDSU(graph, p, q);
    std::map<int, node_t *> nodesMap;
    for(int i=0; i<dsu.nUnions; i++){
        node_t * nd = dsu.unions[i];
        while(nd != NULL){
            EXPECT_TRUE(nodesMap.find(nd->data) == nodesMap.end()); //sets must not intersect
            nodesMap[nd->data] = nd;
            nd = nd->next;
        }
    }
    for(int i=0; i<q; i++){
        int u = graph[i][0];
        int v = graph[i][1];
        EXPECT_EQ(nodesMap[u]->head, nodesMap[v]->head);
    }
    graphMemFree(q, graph);
    freeDSU(dsu);
}

TEST(toDSU, basic){
    int p = 5;
    int q = 6;
    testDSU(p, q);

}

TEST(toDSU, bigGraph){
    int p = 100;
    int q = 300;
    //testDSU(p, q);

}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}

