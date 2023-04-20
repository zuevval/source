#include <iostream>
#include <mpi.h>
#include <cstring>
#include <climits>

#define MAX_STR_SIZE (100)

void greetings() {
    // slightly modified example from "An Introduction to Parallel Programming" by Peter S. Pacheco & Matthew Malensek
    char greeting[MAX_STR_SIZE];
    int commSize; // communicator size (number of processes)
    int myRank; // current process rank;

    MPI_Init(nullptr, nullptr);
    MPI_Comm_size(MPI_COMM_WORLD, &commSize);
    MPI_Comm_rank(MPI_COMM_WORLD, &myRank);


    if (myRank != 0) {
        sprintf(greeting, "Greetings from process %d of %d!", myRank, commSize);
        MPI_Send(greeting, strlen(greeting) + 1, MPI_CHAR, 0, 0, MPI_COMM_WORLD);
    } else {
        printf("Greetings from process 0 of %d!\n", commSize);
        for (int q = 1; q < commSize; ++q) {
            MPI_Recv(greeting, MAX_STR_SIZE, MPI_CHAR, q, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            printf("%s\n", greeting);
        }
    }

    MPI_Finalize();
}

void testSharedMemory() {
    int *a = new int[2];

    MPI_Init(nullptr, nullptr);

    int myRank, commSize;
    MPI_Comm_rank(MPI_COMM_WORLD, &myRank);
    MPI_Comm_size(MPI_COMM_WORLD, &commSize);

    if (myRank % 2 == 0) a[0] = 10;
    else a[1] = 11;
    MPI_Barrier(MPI_COMM_WORLD);

    if (myRank == 0) std::cout << a[0] << " " << a[1] << std::endl; // prints 10, 0 (not 10, 11)

    MPI_Finalize();

    delete[] a;
}

void testMpiMemory() {
    int *a = nullptr;
    size_t aSize = 2;

    MPI_Init(nullptr, nullptr);
    MPI_Win win;
    MPI_Win_allocate_shared(aSize * sizeof(int), sizeof(int), MPI_INFO_NULL, MPI_COMM_WORLD, &a, &win);

    int myRank, commSize;
    MPI_Comm_rank(MPI_COMM_WORLD, &myRank);
    MPI_Comm_size(MPI_COMM_WORLD, &commSize);

    MPI_Aint size;
    int dispUnit;
    MPI_Win_shared_query(win, 0, &size, &dispUnit, &a);

    if (myRank % 2 == 0) a[0] = 10;
    else a[1] = 11;
    MPI_Win_fence(0, win); // also works: MPI_Barrier(MPI_COMM_WORLD);

    if (myRank == 0) std::cout << a[0] << " " << a[1] << std::endl;

    MPI_Win_free(&win);
    MPI_Finalize();
}

void testMpiMemProper() {
    const int nRow = 5, nCol = 4;
    MPI_Init(nullptr, nullptr);
    int commSize, myRank;
    MPI_Comm_size(MPI_COMM_WORLD, &commSize);
    MPI_Comm_rank(MPI_COMM_WORLD, &myRank);

    MPI_Win win;
    int **mtx = nullptr;
    int *mtxLinear = nullptr;
    MPI_Aint size;
    int dispUnit;

    MPI_Win_allocate_shared(nRow * nCol * sizeof(int), sizeof(int), MPI_INFO_NULL, MPI_COMM_WORLD, &mtxLinear, &win);
    MPI_Win_shared_query(win, 0, &size, &dispUnit, &mtxLinear);

    for (int iRow = 0; iRow < nRow; ++iRow) {
        int*row = &mtxLinear[iRow * nCol];

        if (myRank == 0) {
            for (int iCol = 0; iCol < nCol; ++iCol)
                row[iCol] = INT_MAX / 2;
        }
    }

    MPI_Win_free(&win);
    MPI_Finalize();
}

int main() {
//    greetings();
//    lockHolderImpl(); // a custom lock for a single element of a map; this would run forever
//    testSharedMemory();
//    testMpiMemory();
    testMpiMemProper();
    return 0;
}
