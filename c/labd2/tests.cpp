#include<gtest/gtest.h>
#include"functions.h"

void tryFill(int *vals, int *dims, int u, int b,int k, int *xPected, char solutionExists);

TEST(empty, no_solution){
    const int u = 0;
    int b=0, k=1;
    int vals[u] = {};
    int dims[u] = {};
    int xPected [u] = {};
    char solutionExists = 0;
    tryFill(vals, dims, u, b, k, xPected, solutionExists);

}

TEST(simple, solution_exists){
    const int u = 1;
    int b=10, k=5;
    int vals[u] = {5};
    int dims[u] = {10};
    int xPected [u] = {1};
    char solutionExists = 1;
    tryFill(vals, dims, u, b, k, xPected, solutionExists);

}

TEST(simple, no_solution){
    const int u = 1;
    int b=10, k=5;
    int vals[u] = {5};
    int dims[u] = {11};
    int xPected [u] = {0};
    char solutionExists = 0;
    tryFill(vals, dims, u, b, k, xPected, solutionExists);
}

TEST(two_elements, solution_exists){
    const int u = 2;
    int b=5, k=3;
    int vals[u] = {1, 2};
    int dims[u] = {2, 2};
    int xPected [u] = {1, 1};
    char solutionExists = 1;
    tryFill(vals, dims, u, b, k, xPected, solutionExists);
}

TEST(five_elements, solution_exists){
    const int u = 5;
    int b=11, k=9;
    int vals[u] = {1, 2, 3, 1, 3};
    int dims[u] = {2, 3, 5, 1, 1};
    int xPected [u] = {1, 1, 1, 0, 1};
    char solutionExists = 1;
    tryFill(vals, dims, u, b, k, xPected, solutionExists);
}

TEST(five_elements, solution_exists2){
    const int u = 5;
    int b=11, k=9;
    int vals[u] = {1, 2, 3, 1, 3};
    int dims[u] = {2, 3, 5, 1, 2};
    int xPected [] = {0, 1, 1, 1, 1};
    char solutionExists = 1;
    tryFill(vals, dims, u, b, k, xPected, solutionExists);
}

TEST(ten_elements, solution_exists){
    const int u = 10;
    int b=8, k=20;
    int vals[u] = {1, 3, 5, 4, 7, 4, 5, 8, 6, 11};
    int dims[u] = {3, 7, 2, 4, 3, 4, 3, 5, 1, 5};
    int xPected [] = {0, 0, 1, 0, 0, 0, 0, 0, 1, 1};
    char solutionExists = 1;
    tryFill(vals, dims, u, b, k, xPected, solutionExists);
}

TEST(stress_test, solution_exists){
    const int u = 10000; //max required
    int b=1, k=2, i;
    int *vals = (int *)malloc(u*sizeof(int));
    int *dims = (int *)malloc(u*sizeof(int));
    int *xPected = (int *)calloc(u, sizeof(int));
    char solutionExists = 1;
    for(i=0; i<u; i++){
        vals[i] = 1;
        dims[i] = 1;
    }
    vals[u-1] = 2;
    xPected[u-1] = 1;
    tryFill(vals, dims, u, b, k, xPected, solutionExists);
    free(vals);
    free(dims);
    free(xPected);
}

TEST(stress_test, no_solution){
    const int u = 10000; //max required
    int b=1, k=2, i;
    int *vals = (int *)malloc(u*sizeof(int));
    int *dims = (int *)malloc(u*sizeof(int));
    int xPected [] = {};
    char solutionExists = 0;
    for(i=0; i<u; i++){
        vals[i] = 1;
        dims[i] = 1;
    }
    tryFill(vals, dims, u, b, k, xPected, solutionExists);
    free(vals);
    free(dims);
}


int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}

void tryFill(int *vals, int *dims, int u, int b,int k, int *xPected, char solutionExists){
    Item *list = (Item *)malloc(sizeof(Item)*u);
    int *x = (int *)calloc(u, sizeof(int));
    int i = 0;
    int flag;
    for(i = 0; i <u; i++){
        list[i].v = vals[i];
        list[i].s = dims[i];
    }
    flag = fill(u, b, k, x, list);
    if(solutionExists){
        EXPECT_EQ(0, flag);
        for(i=0; i<u; i++)
            EXPECT_EQ(xPected[i],x[i]);
    } else {
        EXPECT_EQ(-1, flag);
    }
    free(list);
    free(x);
}

