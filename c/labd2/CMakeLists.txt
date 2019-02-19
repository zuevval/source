cmake_minimum_required(VERSION 3.12)
project(labd2)

set(CMAKE_C_STANDARD 99)

find_package(GTest REQUIRED)
include_directories(${GTEST_INCLUDE_DIRS})
add_executable(labd2 tests.cpp functions.c functions.h)
#to run as usual, uncomment line before and comment above
#add_executable(labd2 main.c functions.c functions.h)
target_link_libraries(labd2 ${GTEST_LIBRARIES} pthread)