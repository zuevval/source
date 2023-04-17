#include <iostream>
#include <mpi.h>
#include <cstring>

#define MAX_STR_SIZE (100)

int main() {
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
        printf("Greetings from process 0 of %d!", commSize);
        for (int q = 1; q < commSize; ++q) {
            MPI_Recv(greeting, MAX_STR_SIZE, MPI_CHAR, q, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            printf("%s\n", greeting);
        }
    }

    MPI_Finalize();
    return 0;
}
