cmake_minimum_required(VERSION 3.13)
project(lab2_avl)

set(CMAKE_C_STANDARD 99)


find_package(GTest REQUIRED)
include_directories(${GTEST_INCLUDE_DIRS})

add_executable(lab2_avl tests.cpp functions.c functions.h)
#add_executable(lab2_avl main.c functions.c functions.h)
target_link_libraries(lab2_avl ${GTEST_LIBRARIES} pthread)