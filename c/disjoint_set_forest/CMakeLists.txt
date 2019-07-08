cmake_minimum_required(VERSION 3.14)
project(disjoint_set_forest C)

set(CMAKE_C_STANDARD 11)

include_directories(.)

add_executable(disjoint_set_forest
        dsf.c
        dsf.h
        main.c graph.c graph.h)
