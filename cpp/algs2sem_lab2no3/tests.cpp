//
// Created by zuevval on 27.03.19.
//
#include<gtest/gtest.h>
#include"functions.h"

TEST(makeMatrix, simple){
    const int n = 3;
    int Test [n][n] = {{1, 1, 1},{1, 1, 1},{1, 1, 1}};
    EXPECT_EQ(1,1);
}

int main(int argc, char ** argv){
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}