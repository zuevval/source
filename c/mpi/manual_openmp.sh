#!/usr/bin/env bash
export CXX=/usr/local/opt/llvm/bin/clang
/Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake --build .
./mpiExample
