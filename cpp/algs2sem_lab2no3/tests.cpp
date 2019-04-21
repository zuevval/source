//
// Created by zuevval on 27.03.19.
//
#include<gtest/gtest.h>
#include"functions.h"


TEST(makeMatrix, simple){
    const int n = 2;
    std::vector<std::vector<int>> A;
    A.push_back(std::vector<int>{0, 0});
    A.push_back(std::vector<int>{0, 0});
    std::vector<std::vector<draughtMove>> P;
    P.resize(n-1);
    std::vector<std::vector<int>> T;
    T.resize(n);
    calcMoves(n,A,T,P);
    draughtMove Ptrue [n-1][n] = {{rightMv, leftMv}};
    for (int i=0; i<n-1; i++){
        for(int j=0; j<n; j++)
            EXPECT_EQ(P[i][j], Ptrue[i][j]);
    }
}

int main(int argc, char ** argv){
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}