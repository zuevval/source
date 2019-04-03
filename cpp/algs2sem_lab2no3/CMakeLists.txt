cmake_minimum_required(VERSION 3.13)
project(algs2sem_lab2no3)

set(CMAKE_CXX_STANDARD 14)

find_package(GTest REQUIRED)
include_directories(${GTEST_INCLUDE_DIRS})

#add_executable(algs2sem_lab2no3 tests.cpp functions.cpp functions.h)
add_executable(algs2sem_lab2no3 main.cpp functions.cpp functions.h)
#add_executable(algs2sem_lab2no3 mainTest.cpp functions.cpp functions.h)
target_link_libraries(algs2sem_lab2no3 ${GTEST_LIBRARIES} pthread)