#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#include <time.h>
#include <mpi.h>


int main(int argc, char** argv) {
    // mpi setup ---------------------------------------------------------------
    MPI_Init(NULL, NULL);
    int rank, nranks;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &nranks);

    // argument parsing --------------------------------------------------------
    char arg[256];

    // global amount of cells
    int N;

    if (argc < 2) {
        if(rank == 0) {
            printf("ERROR: Give the global amount of cells as argument\n");
        }
        return EXIT_FAILURE;
    }

    sscanf(argv[1], "%s", arg);
    N = atoi(arg);

    if (nranks == 1) {
        if(rank == 0) {
            printf("ERROR: Communicating to other processes doesn't make much "
                    "sense with one process...\n");
        }
        return EXIT_FAILURE;
    }

    if (N < 1 || N % nranks != 0) {
        if(rank == 0) {
            printf("ERROR: Array length must be divisible by nranks.\n");
        }
        return EXIT_FAILURE;
    }


    // variables ---------------------------------------------------------------
    int elements_per_rank = N / nranks;

    // allocation --------------------------------------------------------------

    int* buf1 = malloc(sizeof(int) * N);
    int* buf2 = malloc(sizeof(int) * N);

    int* old = buf1; // old array from which we read
    int* new = buf2; // point to the array to update

    // initialize array --------------------------------------------------------
    // +rank is necessary to have unique random values per rank
    srand(time(NULL)+rank);

    for (int i = 0; i < elements_per_rank; i++) {
        old[i] = rand() % 25;
    }

    // rank wrapraround --------------------------------------------------------

    const int next_rank = rank == nranks - 1 ? 0 : rank + 1;
    const int prev_rank = rank == 0 ? nranks - 1 : rank - 1;

    // mpi requests setup ------------------------------------------------------
    MPI_Request sendNext;
    MPI_Request recvPrev;

    // send 'stop number' from rank #0 to rank #last ---------------------------

    // this is for rank #last only
    int stop_number;

    if (rank == 0) {
        MPI_Send(& old[0], 1, MPI_INT, nranks-1, 0, MPI_COMM_WORLD);
    } else if (rank == nranks-1) {
        // the number from the first position of the array from the first process
        // which determines if the loop stops
        // this is local to the last thread
        MPI_Recv(& stop_number, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }
    MPI_Barrier(MPI_COMM_WORLD);

    if (old[0] == stop_number) {
        printf("%d, %d", old[0], stop_number);
        printf("The stopping condition is reached before we even started. Chance..\n");
        return EXIT_FAILURE;
    }

    // debug print whole array before ------------------------------------------
    if (rank == 0) {
        printf("BEFORE ----------------------------\n");
    }
    MPI_Barrier(MPI_COMM_WORLD);
    for (int i = 0; i < nranks; ++i) {
        if (rank == i) {
            for (int j = 0; j < elements_per_rank; ++j) {
                printf("[%d] %d\n", rank, old[j]);
            }
            printf("\n");
        }
        MPI_Barrier(MPI_COMM_WORLD);
    }
    MPI_Barrier(MPI_COMM_WORLD);

    // circumvent stdout print order problems
    sleep(.5);

    // main loop ---------------------------------------------------------------
    int stop = 0;
    while (!stop) {

        MPI_Isend(old, elements_per_rank, MPI_INT, next_rank,
                1111, MPI_COMM_WORLD, & sendNext);
        MPI_Irecv(new, elements_per_rank, MPI_INT, prev_rank,
                1111, MPI_COMM_WORLD, & recvPrev);

        MPI_Wait(& sendNext, MPI_STATUS_IGNORE);
        MPI_Wait(& recvPrev, MPI_STATUS_IGNORE);
        MPI_Barrier(MPI_COMM_WORLD);

        int * tmp = old;
        old = new;
        new = tmp;

        if (rank == nranks-1 && old[0] == stop_number) {
            stop = 1;
        }
        MPI_Bcast(& stop, 1, MPI_INT, nranks-1, MPI_COMM_WORLD);
    }

    // debug print whole array after movement
    if (rank == 0) {
        printf("AFTER ----------------------------\n");
    }
    MPI_Barrier(MPI_COMM_WORLD);
    for (int i = 0; i < nranks; ++i) {
        if (rank == i) {
            for (int j = 0; j < elements_per_rank; ++j) {
                printf("[%d] %d\n", rank, old[j]);
            }
            printf("\n");
        }
        MPI_Barrier(MPI_COMM_WORLD);
    }
    MPI_Barrier(MPI_COMM_WORLD);

    MPI_Finalize();
    return EXIT_SUCCESS;
}
