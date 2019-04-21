cmake_minimum_required(VERSION 3.13)
project(aux_discrete_tests)

set(CMAKE_CXX_STANDARD 14)

find_package(GTest REQUIRED)
include_directories(${GTEST_INCLUDE_DIRS})


add_executable(aux_discrete_tests factorial.h factorial.c tests.cpp)

target_link_libraries(aux_discrete_tests ${GTEST_LIBRARIES} pthread)