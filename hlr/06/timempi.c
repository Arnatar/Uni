#include <mpi.h>
#include <stdio.h>
#include <unistd.h> 
#include <time.h>
#include <sys/time.h>

const int msglength = 512;
const int hnamelen = 50;

int size, rank;

void master() {
	for (int i = 1; i < size; i++) {
		MPI_Status stat;
		char msg_buf[msglength];
		MPI_Recv(msg_buf, msglength, MPI_CHAR, i, 0, MPI_COMM_WORLD, &stat);
		printf("%s\n", msg_buf);
	}
}

void slave() {

	// get hostname
	char p_name[hnamelen];
	gethostname(p_name, hnamelen);

	// get time
	struct timeval time;
	gettimeofday(&time, NULL);

	long current_sec = (long) time.tv_sec;
	long current_msec = (long) time.tv_usec;

	// generate and formatter msg 
	struct tm* mainTime;
	mainTime = localtime(&time.tv_sec);

	char formatedDate[msglength / 2];
	char msg[msglength];

	strftime(formatedDate, sizeof(formatedDate), "%Y-%m-%d %H:%M:%S", mainTime);

	snprintf(msg, msglength, "%s with rank %d reports at %s.%ld", p_name, rank, formatedDate, current_msec);
	
	// send msg
	MPI_Send(msg, msglength, MPI_CHAR, 0, 0, MPI_COMM_WORLD);

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
	printf("rank %d ends now.\n", rank);

	MPI_Finalize();
	return 0;
}
