cmake_minimum_required(VERSION 3.13)
project(code)

set(CMAKE_C_STANDARD 99)

find_package(GTest REQUIRED)
include_directories(${GTEST_INCLUDE_DIRS})

add_executable(code tests.cpp func-all.c func-all.h)
#add_executable(lab3hashTree main.c functions.c functions.h)
target_link_libraries(code ${GTEST_LIBRARIES} pthread)