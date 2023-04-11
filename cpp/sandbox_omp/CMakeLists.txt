cmake_minimum_required(VERSION 3.9)
project(openmp_sandbox LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set (CMAKE_CXX_STANDARD_REQUIRED ON)
set (CMAKE_C_EXTENSIONS OFF)

add_executable(sandbox_main main.cpp)

find_package(OpenMP REQUIRED)
target_link_libraries(sandbox_main OpenMP::OpenMP_CXX)
