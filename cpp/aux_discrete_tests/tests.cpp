//
// Created by zuevval on 29.03.19.
//
#include<gtest/gtest.h>
#include"factorial.h"


TEST(test1, simple){
    EXPECT_EQ(factRecur(0), 1);
    EXPECT_EQ(factRecur(1), 1);
    EXPECT_EQ(factRecur(2), 2);
    EXPECT_EQ(factRecur(3), 6);
    EXPECT_EQ(factRecur(4), 24);
    for(int i=1; i<=12; ++i){
        EXPECT_EQ(factIter(i), factRecur(i));
        EXPECT_EQ(factIter(i), factIter(i-1)*i);
    }
}

int main(int argc, char ** argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}