#include <mpi.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h> 
#include <sys/time.h>

#define MSGLENGTH 128
#define HNAMELENGTH 64

int size, rank;


int main(int argc, char** argv) {
	// MPI_Init + Fehlermeldung
	if(MPI_Init(&argc, &argv) != MPI_SUCCESS) {
		printf("Error whith MPI_Init");
		return -1;
	}

	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);


	// get hostname
	char p_name[HNAMELENGTH];
	gethostname(p_name, HNAMELENGTH);

	// get time
	struct timeval time;
	gettimeofday(&time, NULL);

	// generate Output
	long current_sec = (long) time.tv_sec;
	long current_msec = (long) time.tv_usec;


	// generate and send msg
	char msg[MSGLENGTH];
	snprintf(msg, MSGLENGTH, "%s: %ld.%ld\n", p_name, current_sec, current_msec);
	MPI_Send(msg, strnlen(msg, MSGLENGTH), MPI_CHAR, 0, 0, MPI_COMM_WORLD);


	// gather msgs at rank 0
	char* receive_buff;
	if (rank == 0) {
		for (int i = 1; i < size; i++) {
			MPI_Status stat;
			char msg_buf[MSGLENGTH];
			MPI_Recv(msg_buf, MSGLENGTH, MPI_CHAR, i, 0, MPI_COMM_WORLD, &stat);
			printf("%s", msg);
		} 
	}

	// Beenden der Prozesse und entsprechende Ausgabe
	MPI_Barrier(MPI_COMM_WORLD);
	printf("Rank %d ends now!\n", rank);

	MPI_Finalize();
	return 0;
}