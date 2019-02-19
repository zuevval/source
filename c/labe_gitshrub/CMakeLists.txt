cmake_minimum_required(VERSION 3.12)
project(labe_gitshrub)

set(CMAKE_C_STANDARD 99)

find_package(GTest REQUIRED)
include_directories(${GTEST_INCLUDE_DIRS})
#add_executable(labe_gitshrub tests.cpp functions.c functions.h)
#to run as usual, uncomment line before and comment above
add_executable(labe_gitshrub main.c functions.c functions.h)
target_link_libraries(labe_gitshrub ${GTEST_LIBRARIES} pthread)