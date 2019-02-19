#include"functions2.h"
#include<stdio.h>
#include<string.h>
#include<gtest/gtest.h>
#define MAXLEN (100)
//TODO: at least 10 different tests
const unsigned int resMarkerLen = 1;

void testOutput (char *inputExpr, char *expectedOutput){
    char *ps0 = (char *)malloc((MAXLEN+1) * sizeof(char));
    char *res0 = (char *)calloc((MAXLEN+1), sizeof(char));
    char *ps = ps0;
    char *res = res0;
    int i, lenRes=0;
    int len = strlen(inputExpr);
    res += resMarkerLen;
    for(i=0; i < len; i++)
        ps[i] = inputExpr[i];
    EXPECT_EQ(len,strlen(inputExpr));
    rpn(ps, res, &len, &lenRes);
    EXPECT_EQ(lenRes,strlen(expectedOutput));
    for(i=lenRes-1; i>=0; i--)
        EXPECT_EQ(expectedOutput[lenRes-1-i],res[i]);
    free(ps0);
    free(res0);
}
TEST(processExpr, empty){
char inputExpr [] = "";
char expectedOutput [] = "";
testOutput(inputExpr, expectedOutput);
}
TEST(processExpr, oneVar){
char inputExpr [] = "a";
char expectedOutput [] = "a";
testOutput(inputExpr, expectedOutput);
}
TEST(processExpr, testPrefixMinuses){
    char inputExpr [] = "---a";
    char expectedOutput [] = "000a---";
    testOutput(inputExpr, expectedOutput);
}
TEST(processExpr, testBrackets1){
char inputExpr [] = "(((a)))";
char expectedOutput [] = "a";
testOutput(inputExpr, expectedOutput);
}
TEST(processExpr, testBrackets2){
char inputExpr [] = "((((a+b)*c)-d)/f)";
char expectedOutput [] = "ab+c*d-f/";
testOutput(inputExpr, expectedOutput);
}
TEST(processExpr, ordinaryExpression1){
char inputExpr [] = "a+b*c";
char expectedOutput [] = "abc*+";
testOutput(inputExpr, expectedOutput);
}
TEST(processExpr, ordinaryExpression2){
char inputExpr [] = "a*(-b)-(c/(d+e)+f)-g";
char expectedOutput [] = "a0b-*cde+/f+-g-";
testOutput(inputExpr, expectedOutput);
}
TEST(processExpr, ordinaryExpression3){
char inputExpr [] = "(a-b)*(c+d)/(e-f)*g";
char expectedOutput [] = "ab-cd+*ef-/g*";
testOutput(inputExpr, expectedOutput);
}
TEST(processExpr, ordinaryExpression4){
char inputExpr [] = "a+b*c-d*e+(-f)";
char expectedOutput [] = "abc*+de*-0f-+";
testOutput(inputExpr, expectedOutput);
}
TEST(processExpr, exoticExpression){
char inputExpr [] = "(a)---(b*-c)";
char expectedOutput [] = "a00b0c-*---";
testOutput(inputExpr, expectedOutput);
}
TEST(processExpr, exoticExpression2){
char inputExpr [] = "(((a))---((b))*-(c))";
char expectedOutput [] = "a00b--0c-*-";
testOutput(inputExpr, expectedOutput);
}
TEST(processExpr, unbalanced){
char inputExpr [] = "(a+*";
char expectedOutput [] = "";
testOutput(inputExpr, expectedOutput);
}
int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();

}
