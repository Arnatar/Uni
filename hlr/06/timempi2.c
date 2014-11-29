#include <mpi.h>
#include <stdio.h>
#include <unistd.h> 
#include <time.h>
#include <sys/time.h>
#include <limits.h>

const int msglength = 512;
const int hnamelen = 50;

int size, rank;

int master() {
	// igno master in loop
	for (int i = 1; i < size; i++) {
		MPI_Status stat;
		char msg_buf[msglength];
		// receive from slaves	
		if(MPI_Recv(msg_buf, msglength, MPI_CHAR, i, 0, MPI_COMM_WORLD, &stat) != MPI_SUCCESS) {
			printf("Error with MPI_Recv\n");
		}
		printf("%s\n", msg_buf);
	}

	//ignore this one
	long current_msec = LONG_MAX;

	//accumulator
	long min_msec = LONG_MAX;

	//master Reduce
	if(MPI_Reduce(&current_msec, &min_msec, 1, MPI_LONG, MPI_MIN, 0, MPI_COMM_WORLD) != MPI_SUCCESS) {
		printf("Problem with MPI_Reduce at master\n");
	}

	printf("minimal microseconds: %ld\n", min_msec);

	return 0;
}

int slave() {

	// get hostname
	char p_name[hnamelen];
	if (gethostname(p_name, hnamelen) != 0) {
		printf("Error with hostname of rank %d\n", rank);
		return -1;
	}

	// get time
	struct timeval time;
	if (gettimeofday(&time, NULL) != 0) {
		printf("Error with time at rankd %d\n", rank);
		return -1;
	}

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
	if(MPI_Send(msg, msglength, MPI_CHAR, 0, 0, MPI_COMM_WORLD) != MPI_SUCCESS) {
		printf("Problem with MPI_Send at rank %d\n", rank);
		return -1;
	}

	// reduce slaves, here no receive buffer
	if (MPI_Reduce(&current_msec, NULL, 1, MPI_LONG, MPI_MIN, 0, MPI_COMM_WORLD) != MPI_SUCCESS)
	{
		printf("Problem with MPI_Reduce at rank %d\n", rank);
		return -1;
	}

	return 0;

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
		if(master() != 0) {
			printf("Problem at master");
			return -1;
		}
		
	} else {
		if (slave() != 0) {
			printf("Problem with slave");
			return -1;
		}
	}

	// Beenden der Prozesse und entsprechende Ausgabe
	if(MPI_Barrier(MPI_COMM_WORLD) != MPI_SUCCESS) {
		printf("Problem with MPI_Barrier at rank %d\n", rank);
		return -1;
	}
	
	printf("rank %d ends now.\n", rank);

	MPI_Finalize();
	return 0;
}
