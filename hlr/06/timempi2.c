#include <mpi.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h> 
#include <sys/time.h>

#define MSGLENGTH 512
#define HNAMELENGTH 32

int size, rank;

void master() {
	for (int i = 1; i < size; i++) {
		MPI_Status stat;
		char msg_buf[MSGLENGTH];
		MPI_Recv(msg_buf, MSGLENGTH, MPI_CHAR, i, 0, MPI_COMM_WORLD, &stat);
		printf("%s\n", msg_buf);
	}
}

void slave() {

	// get hostname
	char p_name[HNAMELENGTH];
	gethostname(p_name, HNAMELENGTH);

	// get time
	struct timeval time;
	gettimeofday(&time, NULL);

	long current_sec = (long) time.tv_sec;
	long current_msec = (long) time.tv_usec;

	// generate and send msg
	char msg[MSGLENGTH];
	snprintf(msg, MSGLENGTH, "%s: %ld.%ld", p_name, current_sec, current_msec);
	MPI_Send(msg, strnlen(msg, MSGLENGTH), MPI_CHAR, 0, 0, MPI_COMM_WORLD);

}


int main(int argc, char** argv) {
	// MPI_Init + Fehlermeldung
	if(MPI_Init(&argc, &argv) != MPI_SUCCESS) {
		printf("Error whith MPI_Init");
		return -1;
	}

	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	// master-slave-diff
	if(rank == 0) {
		master();
	} else {
		slave();
	}

	// Beenden der Prozesse und entsprechende Ausgabe
	MPI_Barrier(MPI_COMM_WORLD);
	printf("Rank %d ends now!\n", rank);

	MPI_Finalize();
	return 0;
}