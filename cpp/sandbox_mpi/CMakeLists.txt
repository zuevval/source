cmake_minimum_required(VERSION 3.25)
project(sandbox_mpi LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

add_executable(sandbox_main main.cpp)

find_package(MPI REQUIRED)
target_link_libraries(sandbox_main PUBLIC MPI::MPI_CXX)
