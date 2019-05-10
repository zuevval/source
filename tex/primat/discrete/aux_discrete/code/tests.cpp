#include<gtest/gtest.h>
#include "func-all.h"

TEST(cmn, basic){
    EXPECT_EQ(1,C(1, 1));
    EXPECT_EQ(3,C(3, 1));
    EXPECT_EQ(10,C(5, 3));
    EXPECT_EQ(35,C(7, 4));
}

TEST(cmn, underCrit){
    //4294967295 - UINT_MAX value
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

TEST(amn, underCrit){
    EXPECT_EQ(254251200,A(50, 5));
    EXPECT_EQ(417451320,A(55, 5));
    EXPECT_EQ(1452361680,A(70, 5));
    EXPECT_EQ(2533330800,A(78, 5));
    EXPECT_EQ(3936182040,A(85, 5));
}

TEST(amn, overCrit){
    EXPECT_EQ(UINT_MAX, A(88, 5));
    EXPECT_EQ(UINT_MAX, A(89, 5));
    EXPECT_EQ(UINT_MAX, A(1e+9, 1e+6));
}

TEST(pn, basic) {
    EXPECT_EQ(1, P(1));
    EXPECT_EQ(2, P(2));
    EXPECT_EQ(120, P(5));
}

TEST(pn, underCrit) {
    EXPECT_EQ(479001600, P(12));
}

TEST(pn, overCrit) {
    EXPECT_EQ(UINT_MAX, P(13));
    EXPECT_EQ(UINT_MAX, P(1e+9));
}

TEST(umn, basic) {
    EXPECT_EQ(1, U(1, 1));
    EXPECT_EQ(1, U(1, 100));
    EXPECT_EQ(2048, U(2, 11));
}

TEST(umn, underCrit) {
    EXPECT_EQ(1, U(1, 4e+9));
    EXPECT_EQ(1e+9, U(10, 9));
    EXPECT_EQ(3486784401, U(9, 10));
}

TEST(umn, overCrit) {
    EXPECT_EQ(UINT_MAX, U(2, 1e+5));
    EXPECT_EQ(UINT_MAX, U(9, 11));
    EXPECT_EQ(UINT_MAX, U(8, 11));
    EXPECT_EQ(UINT_MAX, U(1e+6, 1e+6));
}

TEST(vmn, basic) {
    EXPECT_EQ(1, V(1, 1));
    EXPECT_EQ(3, V(3, 1));
    EXPECT_EQ(10, V(3, 3));
    EXPECT_EQ(35, V(4, 4));
}

TEST(vmn, underCrit) {
    EXPECT_EQ(4151918628,V(77, 7));
    EXPECT_EQ(4249404082,V(118, 6));
}

TEST(vmn, overCrit) {
    EXPECT_EQ(UINT_MAX,V(78, 7));
    EXPECT_EQ(UINT_MAX,V(200, 100));
    EXPECT_EQ(UINT_MAX,V(1e+09, 1e+04));
}

TEST(fib, basic) {
    EXPECT_EQ(1, fib(1));
    EXPECT_EQ(1, fib(2));
    EXPECT_EQ(21, fib(8));
    EXPECT_EQ(55, fib(10));
}

TEST(fib, underCrit) {
    EXPECT_EQ(1836311903, fib(46));
    EXPECT_EQ(2971215073, fib(47));
}

TEST(fib, overCrit) {
    EXPECT_EQ(UINT_MAX, fib(48));
    EXPECT_EQ(UINT_MAX, fib(1e+9));
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}

