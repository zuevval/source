cmake_minimum_required(VERSION 3.12)
project(testCmake)

set(CMAKE_C_STANDARD 99)

find_package(GTest REQUIRED)
include_directories(${GTEST_INCLUDE_DIRS})
add_library(fun STATIC functions2.c)
add_executable(testCmake test1.cpp)
#to run as usual, uncomment line before and comment above
#add_executable(testCmake main.c)
target_link_libraries(testCmake fun)
target_link_libraries(testCmake ${GTEST_LIBRARIES} pthread)