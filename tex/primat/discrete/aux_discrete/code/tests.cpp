#include<gtest/gtest.h>
#include "func-all.h"

TEST(cmn, basic){
    EXPECT_EQ(1,C(1, 1));
    EXPECT_EQ(3,C(3, 1));
    EXPECT_EQ(10,C(5, 3));
    EXPECT_EQ(35,C(7, 4));
}

//4294967295 - UINT_MAX value

TEST(cmn, underCrit){
    EXPECT_EQ(4151918628,C(83, 7));
    EXPECT_EQ(4249404082,C(123, 6));
}

TEST(cmn, overCrit){
    EXPECT_EQ(UINT_MAX,C(84, 7));
    EXPECT_EQ(UINT_MAX,C(200, 100));
    EXPECT_EQ(UINT_MAX,C(1e+09, 1e+04));
}

TEST(amn, basic){
    EXPECT_EQ(1,A(1, 1));
    EXPECT_EQ(3,A(3, 1));
    EXPECT_EQ(60,A(5, 3));
    EXPECT_EQ(840,A(7, 4));
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}

