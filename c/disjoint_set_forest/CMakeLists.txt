cmake_minimum_required(VERSION 3.13)
project(disjoint_set_forest)


set(CMAKE_C_STANDARD 99)

find_package(GTest REQUIRED)
include_directories(${GTEST_INCLUDE_DIRS})

include_directories(.)

add_executable(disjoint_set_forest tests.cpp test/dsf_test.h test/functions_test.h test/graph_test.h)
#add_executable(disjoint_set_forest dsf.c dsf.h graph.c graph.h functions.c functions.h main.c)

target_link_libraries(disjoint_set_forest ${GTEST_LIBRARIES} pthread)

