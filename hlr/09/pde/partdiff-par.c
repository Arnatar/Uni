/****************************************************************************/
/****************************************************************************/
/**                                                                        **/
/**                TU Muenchen - Institut fuer Informatik                  **/
/**                                                                        **/
/** Copyright: Prof. Dr. Thomas Ludwig                                     **/
/**            Andreas C. Schmidt                                          **/
/**                                                                        **/
/** File:      partdiff-par.c                                              **/
/**                                                                        **/
/** Purpose:   Partial differential equation solver for Gauss-Seidel and   **/
/**            Jacobi method.                                              **/
/**                                                                        **/
/****************************************************************************/
/****************************************************************************/

/* ************************************************************************ */
/* Include standard header file.                                            */
/* ************************************************************************ */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <math.h>
#include <malloc.h>
#include <sys/time.h>

#include <mpi.h>

#include "partdiff-par.h"

void get_distribution(int distribution[], int nprocs, int global_amount) {
    int base_amount = global_amount / nprocs;
    int rest_amount = global_amount % nprocs;

    int rests[nprocs];


    for (int i = 0; i < nprocs; ++i) {
        rests[i] = (i < rest_amount ? 1 : 0);
    }
    for (int i = 0; i < nprocs; ++i) {
        distribution[i] = base_amount + rests[i];
    }
}

int sum_array(int a[], int num_elements)
{
   int i, sum=0;
   for (i=0; i<num_elements; i++)
   {
	 sum = sum + a[i];
   }
   return(sum);
}

struct calculation_arguments
{
	uint64_t  N;              /* number of spaces between lines (lines=N+1)     */
	uint64_t  N_plus_ghost_rows;
	uint64_t  num_matrices;   /* number of matrices                             */
	double    h;              /* length of a space between two lines            */
	double    ***Matrix;      /* index matrix used for addressing M             */
	double    *M;             /* two matrices with real values                  */

	uint64_t N_global; 			// global size of the problem
	uint64_t offset_start;
	uint64_t offset_end;

	int rank; 					// current rank
	int nprocs; 				// number of processes
	int offset;					// offset for calculating where the matrix is
};

struct calculation_results
{
	uint64_t  m;
	uint64_t  stat_iteration; /* number of current iteration                    */
	double    stat_precision; /* actual precision of all slaves in iteration    */
};

/* ************************************************************************ */
/* Global variables                                                         */
/* ************************************************************************ */

/* time measurement variables */
struct timeval start_time;       /* time when program started                      */
struct timeval comp_time;        /* time when calculation completed                */


/* ************************************************************************ */
/* initVariables: Initializes some global variables                         */
/* ************************************************************************ */
static
void
initVariables (struct calculation_arguments* arguments, struct calculation_results* results, struct options const* options, int rank, int nprocs)
{
	arguments->N_global = (options->interlines * 8) + 9 - 1;

    // get local amount of rows
    int row_amount_distribution[nprocs];
    get_distribution(row_amount_distribution, nprocs, arguments->N_global);

 // * Example with 9 matrix lines and 4 processes:
 // * - rank 0 is responsible for 1-2, rank 1 for 3-4, rank 2 for 5-6 and rank 3 for 7.
 // *   Lines 0 and 8 are not included because they are not calculated.

	arguments->N = row_amount_distribution[rank];
    if (rank == nprocs - 1) arguments->N++;
	arguments->N_plus_ghost_rows = rank == 0 || rank == nprocs - 1 ?
                        row_amount_distribution[rank]+1 :
                        row_amount_distribution[rank]+2;

    // used by DisplayMatrix
    arguments->offset_start = sum_array(row_amount_distribution, rank);

    arguments->offset_end = rank == nprocs - 1 ?
                        arguments->N_global-1 :
                        sum_array(row_amount_distribution, rank+1)-1;


	arguments->num_matrices = (options->method == METH_JACOBI) ? 2 : 1;
	arguments->h = 1.0 / arguments->N_global;

	arguments->rank = rank;
	arguments->nprocs = nprocs;

	results->m = 0;
	results->stat_iteration = 0;
	results->stat_precision = 0;

	//arguments->offset = ((arguments->N_global + 1) / nprocs) * rank;
	arguments->offset = row_amount_distribution[rank];
}

/* ************************************************************************ */
/* freeMatrices: frees memory for matrices                                  */
/* ************************************************************************ */
static
void
freeMatrices (struct calculation_arguments* arguments)
{
	uint64_t i;

	for (i = 0; i < arguments->num_matrices; i++)
	{
		free(arguments->Matrix[i]);
	}

	free(arguments->Matrix);
	free(arguments->M);
}

/* ************************************************************************ */
/* allocateMemory ()                                                        */
/* allocates memory and quits if there was a memory allocation problem      */
/* ************************************************************************ */
static
void*
allocateMemory (size_t size)
{
	void *p;

	if ((p = malloc(size)) == NULL)
	{
		printf("Speicherprobleme! (%" PRIu64 " Bytes)\n", size);
		/* exit program */
		exit(1);
	}

	return p;
}

/* ************************************************************************ */
/* allocateMatrices: allocates memory for matrices                          */
/* ************************************************************************ */
static
void
allocateMatrices (struct calculation_arguments* arguments)
{
	uint64_t i, j;

	uint64_t const Y = arguments->N_plus_ghost_rows;
	uint64_t const X = arguments->N_global;

	arguments->M = allocateMemory(arguments->num_matrices * (Y + 1) * (X + 1) * sizeof(double));
	arguments->Matrix = allocateMemory(arguments->num_matrices * sizeof(double**));

	for (i = 0; i < arguments->num_matrices; i++)
	{
		arguments->Matrix[i] = allocateMemory((Y + 1) * sizeof(double*));

		for (j = 0; j <= Y; j++)
		{
			arguments->Matrix[i][j] = arguments->M + (i * (Y + 1) * (X + 1)) + (j * (X + 1));
		}
	}
}

/* ************************************************************************ */
/* initMatrices: Initialize matrix/matrices and some global variables       */
/* ************************************************************************ */
static
void
initMatrices (struct calculation_arguments* arguments, struct options const* options)
{
	uint64_t g, i, j;                                /*  local variables for loops   */

	uint64_t const N = arguments->N;
	double const h = arguments->h;
	double*** Matrix = arguments->Matrix;

	/* initialize matrix/matrices with zeros */
	for (g = 0; g < arguments->num_matrices; g++)
	{
		for (i = 0; i <= N; i++)
		{
			for (j = 0; j <= N; j++)
			{
				Matrix[g][i][j] = 0.0;
			}
		}
	}

	// /* initialize borders, depending on function (function 2: nothing to do) */
	if (options->inf_func == FUNC_F0)
	{
		for (g = 0; g < arguments->num_matrices; g++)
		{
			for (i = 0; i <= N; i++)
			{
                double offset = h * i + (arguments->offset_start)*h;
				Matrix[g][i][0] = 1.0 - offset;
                // printf("[%d] %f %f\n", arguments->rank, offset, Matrix[g][i][0]);
                // printf("[%d] %d \n", arguments->rank, arguments->N_global);
				Matrix[g][i][arguments->N_global] = offset;


                // if (arguments->rank = arguments->nprocs -1) {
                //     Matrix[g][N][i] = offset;
                // }

			}

            if (arguments->rank == 0) {
                for (i = 0; i <= arguments->N_global; i++) {
                    double offset = h * i;
                    Matrix[g][0][i] = 1.0 - offset;
                }
                Matrix[g][0][arguments->N_global] = 0.0;
            }

            if (arguments->rank == arguments->nprocs -1) {
                for (i = 0; i <= arguments->N_global; i++) {
                    double offset = h * i;
                    Matrix[g][N-1][i] = offset;
                }
                Matrix[g][N-1][arguments->N_global] = 1.0;
            }

		}
	}

}

static
void
calculate_gs (struct calculation_arguments const* arguments, struct calculation_results *results, struct options const* options)
{
    int i, j;                                   /* local variables for loops  */
	int m1, m2;                                 /* used as indices for old and new matrices       */
	double star;                                /* four times center value minus 4 neigh.b values */
	double residuum;                            /* residuum of current iteration                  */
	double maxresiduum;                         /* maximum residuum value of a slave in iteration */
	double maxresiduumbuf;

	// termination flags
	int termin_flag1 = 0; // propagated to the rank above if precision criteria is met. starts at last rank   
	int termin_flag2 = 0; // propagated to the rank below to terminate the processes. starts if rank 0 receives termination flag 1

	int const N = arguments->N;
	double const h = arguments->h;

	int const N_global = arguments->N_global;
	int const nprocs = arguments->nprocs;
	int const rank = arguments->rank;
	uint64_t offset_start = arguments->offset_start;
	uint64_t offset_end = arguments->offset_end;

	double pih = 0.0;
	double fpisin = 0.0;

	int term_iteration = options->term_iteration;
	/* initialize m1 and m2 depending on algorithm */
	if (options->method == METH_JACOBI)
	{
		m1 = 0;
		m2 = 1;
	}
	else
	{
		m1 = 0;
		m2 = 0;
	}

	if (options->inf_func == FUNC_FPISIN)
	{
		pih = PI * h;
		fpisin = 0.25 * TWO_PI_SQUARE * h * h;
	}

	while (term_iteration > 0)
	{
		double** Matrix_Out = arguments->Matrix[m1];
		double** Matrix_In  = arguments->Matrix[m2];

		maxresiduum = 0;
		maxresiduumbuf = 0;

		// receives from above, top rank is irelevant
		if(rank > 0)
		{
			// receive communicated line
			MPI_Recv(Matrix_Out[0], N_global + 1, MPI_DOUBLE, rank - 1,
				rank - 1 + results->stat_iteration, MPI_COMM_WORLD, NULL);
			// receive next maxresiduumbuf
			MPI_Recv(&maxresiduumbuf, 1, MPI_DOUBLE, rank - 1, rank - 1, MPI_COMM_WORLD, NULL);
			// receive final termination flag (flag2)
			MPI_Recv(&termin_flag2, 1, MPI_DOUBLE, rank - 1, rank - 1, MPI_COMM_WORLD, NULL);
		}

		// receives from below, last rank is irelevant
		if(results->stat_iteration > 0)
		{
			if(rank != nprocs - 1)
			{
				// reveive communicated line
				MPI_Recv(Matrix_Out[N], N_global + 1, MPI_DOUBLE, rank + 1,
					rank + 1 + results->stat_iteration - 1, MPI_COMM_WORLD, NULL);
				// receive first termination flag (flag1)
				MPI_Recv(&termin_flag1, 1, MPI_INT, rank + 1, rank + 1, MPI_COMM_WORLD, NULL);
			}
		}

		/* over all rows */
		for (int i = 1; i < N; i++)
		{
			double fpisin_i = 0.0;

			if (options->inf_func == FUNC_FPISIN)
			{
				int offset = arguments->offset_start;
                if(rank > 0)
                	offset--;
				fpisin_i = fpisin * sin(pih * (double)(i+offset));
			}

			/* over all columns */
			for (int j = 1; j < N_global; j++)
			{
				star = 0.25 * (Matrix_In[i-1][j] 
					+ Matrix_In[i][j-1] 
					+ Matrix_In[i][j+1] 
					+ Matrix_In[i+1][j]);

				if (options->inf_func == FUNC_FPISIN)
				{
					star += fpisin_i * sin(pih * (double)j);
				}

				if (options->termination == TERM_PREC || term_iteration == 1)
				{
					residuum = Matrix_In[i][j] - star;
					residuum = (residuum < 0) ? -residuum : residuum;
					maxresiduum = (residuum < maxresiduum) ? maxresiduum : residuum;
					maxresiduum = (maxresiduumbuf < maxresiduum) ? maxresiduum : maxresiduumbuf;
				}

				Matrix_Out[i][j] = star;
			}
		}

		// sends
		// upwards
		if(termin_flag2 != 1)
		{
			if(rank > 0)
			{
				// send communication line
				MPI_Send(Matrix_Out[1], N_global + 1, MPI_DOUBLE, rank - 1,
					rank + results->stat_iteration, MPI_COMM_WORLD);
				// send prelimary termination flag upwards
				MPI_Send(&termin_flag1, 1, MPI_INT, rank - 1, rank, MPI_COMM_WORLD);
			}
		}
		// downwards
		if(rank != nprocs - 1)
		{
			// send communication line
			MPI_Send(Matrix_Out[N - 1], N_global + 1, MPI_DOUBLE, rank + 1,
				rank + results->stat_iteration, MPI_COMM_WORLD);
			// send maxresiduum down the procs (a shame it is not broadcastable)
			MPI_Send(&maxresiduum, 1, MPI_DOUBLE, rank + 1, rank, MPI_COMM_WORLD);
			// send part 2 of the termination signal
			MPI_Send(&termin_flag2, 1, MPI_DOUBLE, rank + 1, rank, MPI_COMM_WORLD);
		}


		results->stat_iteration++;
		results->stat_precision = maxresiduum;

		/* exchange m1 and m2 */

        // here the original code used the 'i' variable, which is now local to the loops
        // the semantics of using it here were wrong anyway -- use a new var called 'tmp'
        int tmp;
		tmp = m1;
		m1 = m2;
		m2 = tmp;


		if(termin_flag2 == 1)
			term_iteration = 0;

		if(rank == 0 && termin_flag1 == 1)
			termin_flag2 = 1;

		/* check for stopping calculation, depending on termination method */
		if (options->termination == TERM_PREC)
		{

			if (rank == nprocs-1) {
				if (maxresiduum < options->term_precision && termin_flag1 != 1)
				{
					termin_flag1 = 1;
				}
			}
		}
		else if (options->termination == TERM_ITER)
		{
			term_iteration--;
		}
	}

	results->m = m2;
}

/* ************************************************************************ */
/* calculate: solves the equation                                           */
/* ************************************************************************ */
static
void
calculate_jacobi (struct calculation_arguments const* arguments, struct calculation_results *results, struct options const* options)
{
	int i, j;                                   /* local variables for loops  */
	int m1, m2;                                 /* used as indices for old and new matrices       */
	double star;                                /* four times center value minus 4 neigh.b values */
	double residuum;                            /* residuum of current iteration                  */
	double maxresiduum;                         /* maximum residuum value of a slave in iteration */

	int const N = arguments->N;
	double const h = arguments->h;

	int const N_global = arguments->N_global;
	int const nprocs = arguments->nprocs;
	int const rank = arguments->rank;
	uint64_t offset_start = arguments->offset_start;
	uint64_t offset_end = arguments->offset_end;

	double pih = 0.0;
	double fpisin = 0.0;

	int term_iteration = options->term_iteration;

	/* initialize m1 and m2 depending on algorithm */
	if (options->method == METH_JACOBI)
	{
		m1 = 0;
		m2 = 1;
	}
	else
	{
		m1 = 0;
		m2 = 0;
	}

	if (options->inf_func == FUNC_FPISIN)
	{
		pih = PI * h;
		fpisin = 0.25 * TWO_PI_SQUARE * h * h;
	}

	while (term_iteration > 0)
	{
		double** Matrix_Out = arguments->Matrix[m1];
		double** Matrix_In  = arguments->Matrix[m2];

		maxresiduum = 0;

		/* over all rows */
		for (i = 1; i < N; i++)
		{
			double fpisin_i = 0.0;

			if (options->inf_func == FUNC_FPISIN)
			{
				int offset = arguments->offset_start;
                if(rank > 0)
                	offset--;
				fpisin_i = fpisin * sin(pih * (double)(i+offset));
			}

			/* over all columns */
			for (j = 1; j < N_global; j++)
			{
				star = 0.25 * (Matrix_In[i-1][j]
					+ Matrix_In[i][j-1]
					+ Matrix_In[i][j+1]
					+ Matrix_In[i+1][j]);

				if (options->inf_func == FUNC_FPISIN)
				{
					star += fpisin_i * sin(pih * (double)j);
				}

				if (options->termination == TERM_PREC || term_iteration == 1)
				{
					residuum = Matrix_In[i][j] - star;
					residuum = (residuum < 0) ? -residuum : residuum;
					maxresiduum = (residuum < maxresiduum) ? maxresiduum : residuum;
				}

				Matrix_Out[i][j] = star;
			}
		}


		MPI_Request sdown;
		MPI_Request sup;
		MPI_Request rdown;
		MPI_Request rup;

		// send
		if (rank < nprocs-1) {
			MPI_Isend(Matrix_In[offset_end - offset_start - 1], N_global+1, MPI_DOUBLE, rank+1, 0, MPI_COMM_WORLD, &sdown);
		}
		if (rank > 0) {
			MPI_Isend(Matrix_In[1], N_global+1, MPI_DOUBLE, rank-1, 0, MPI_COMM_WORLD, &sup);
		}

		// receive
		if (rank > 0) {
			MPI_Irecv(Matrix_In[0], N_global+1, MPI_DOUBLE, rank-1, 0, MPI_COMM_WORLD, &rup);
		}
		if (rank < nprocs-1) {
			MPI_Irecv(Matrix_In[offset_end - offset_start], N_global+1, MPI_DOUBLE, rank+1, 0, MPI_COMM_WORLD, &rdown);
		}

		//Waiting
		if (rank > 0) {
			MPI_Wait(&sup, MPI_STATUS_IGNORE);
			MPI_Wait(&rup, MPI_STATUS_IGNORE);
		}
		if (rank < nprocs-1) {
			MPI_Wait(&sdown, MPI_STATUS_IGNORE);
			MPI_Wait(&rdown, MPI_STATUS_IGNORE);
		}
		MPI_Barrier(MPI_COMM_WORLD);

		/* exchange m1 and m2 */
		i = m1;
		m1 = m2;
		m2 = i;


		MPI_Allreduce(MPI_IN_PLACE, &maxresiduum, 1, MPI_DOUBLE, MPI_MAX, MPI_COMM_WORLD);

		results->stat_iteration++;
		results->stat_precision = maxresiduum;


		/* check for stopping calculation, depending on termination method */
		if (options->termination == TERM_PREC)
		{
			if (maxresiduum < options->term_precision)
			{
				term_iteration = 0;
			}
		}
		else if (options->termination == TERM_ITER)
		{
			term_iteration--;
		}
	}

	results->m = m2;
}

/* ************************************************************************ */
/*  displayStatistics: displays some statistics about the calculation       */
/* ************************************************************************ */
static
void
displayStatistics (struct calculation_arguments const* arguments, struct calculation_results const* results, struct options const* options)
{
	int N = arguments->N;
	double time = (comp_time.tv_sec - start_time.tv_sec) + (comp_time.tv_usec - start_time.tv_usec) * 1e-6;

	printf("Berechnungszeit:    %f s \n", time);
	printf("Speicherbedarf:     %f MiB\n", (N + 1) * (N + 1) * sizeof(double) * arguments->num_matrices / 1024.0 / 1024.0);
	printf("Berechnungsmethode: ");

	if (options->method == METH_GAUSS_SEIDEL)
	{
		printf("Gauss-Seidel");
	}
	else if (options->method == METH_JACOBI)
	{
		printf("Jacobi");
	}

	printf("\n");
	printf("Interlines:         %" PRIu64 "\n",options->interlines);
	printf("Stoerfunktion:      ");

	if (options->inf_func == FUNC_F0)
	{
		printf("f(x,y) = 0");
	}
	else if (options->inf_func == FUNC_FPISIN)
	{
		printf("f(x,y) = 2pi^2*sin(pi*x)sin(pi*y)");
	}

	printf("\n");
	printf("Terminierung:       ");

	if (options->termination == TERM_PREC)
	{
		printf("Hinreichende Genaugkeit");
	}
	else if (options->termination == TERM_ITER)
	{
		printf("Anzahl der Iterationen");
	}

	printf("\n");
	printf("Anzahl Iterationen: %" PRIu64 "\n", results->stat_iteration);
	printf("Norm des Fehlers:   %e\n", results->stat_precision);
	printf("\n");
}

/****************************************************************************/
/** Beschreibung der Funktion DisplayMatrix:                               **/
/**                                                                        **/
/** Die Funktion DisplayMatrix gibt eine Matrix                            **/
/** in einer "ubersichtlichen Art und Weise auf die Standardausgabe aus.   **/
/**                                                                        **/
/** Die "Ubersichtlichkeit wird erreicht, indem nur ein Teil der Matrix    **/
/** ausgegeben wird. Aus der Matrix werden die Randzeilen/-spalten sowie   **/
/** sieben Zwischenzeilen ausgegeben.                                      **/
/****************************************************************************/
/*
static
void
DisplayMatrix (struct calculation_arguments* arguments, struct calculation_results* results, struct options* options)
{
	int x, y;

	double** Matrix = arguments->Matrix[results->m];

	int const interlines = options->interlines;

	printf("Matrix:\n");

	for (y = 0; y < 9; y++)
	{
		for (x = 0; x < 9; x++)
		{
			printf ("%7.4f", Matrix[y * (interlines + 1)][x * (interlines + 1)]);
		}

		printf ("\n");
	}

	fflush (stdout);
}*/


/**
 * rank and size are the MPI rank and size, respectively.
 * from and to denote the global(!) range of lines that this process is responsible for.
 *
 * Example with 9 matrix lines and 4 processes:
 * - rank 0 is responsible for 1-2, rank 1 for 3-4, rank 2 for 5-6 and rank 3 for 7.
 *   Lines 0 and 8 are not included because they are not calculated.
 * - Each process stores two halo lines in its matrix (except for ranks 0 and 3 that only store one).
 * - For instance: Rank 2 has four lines 0-3 but only calculates 1-2 because 0 and 3 are halo lines for other processes. It is responsible for (global) lines 5-6.
 */

static
void
DisplayMatrix (struct calculation_arguments* arguments, struct calculation_results* results, struct options* options)
{
  int const elements = 8 * options->interlines + 9;
  int from = arguments->offset_start;
  int to = arguments->offset_end;
  int rank = arguments->rank;
  int size = arguments->nprocs;
  // printf("[%d] %d %d\n", rank, from, to);

  int x, y;
  double** Matrix = arguments->Matrix[results->m];

  for (int i = 0; i < arguments->nprocs; ++i) {
      // if (rank == arguments->nprocs -1)
      if (rank == i) {
          for (int j = 0; j < arguments->N; ++j) {
              if (j % (options->interlines+1) == 0) {
                  printf("[%d] ", rank);
                  for (int y = 0; y < arguments->N_global; ++y) {
                      if (y % (options->interlines+1) == 0) {
                          printf("%7.4f ", Matrix[j][y]);
                      }
                  }
                  printf("%7.4f\n", Matrix[j][arguments->N_global]);
              }
          }
      }
      MPI_Barrier(MPI_COMM_WORLD);
  }
  MPI_Barrier(MPI_COMM_WORLD);
return;
MPI_Status status;

  /* first line belongs to rank 0 */
  if (rank == 0)
    from--;

  /* last line belongs to rank size - 1 */
  if (rank + 1 == size)
    to++;

  if (rank == 0)
    printf("Matrix:\n");

  for (y = 0; y < 9; y++)
  {
    int line = y * (options->interlines + 1);

    if (rank == 0)
    {
      /* check whether this line belongs to rank 0 */
      if (line < from || line > to)
      {
        /* use the tag to receive the lines in the correct order
         * the line is stored in Matrix[0], because we do not need it anymore */
        MPI_Recv(Matrix[0], elements, MPI_DOUBLE, MPI_ANY_SOURCE, 42 + y, MPI_COMM_WORLD, &status);
      }
    }
    else
    {
      if (line >= from && line <= to)
      {
        /* if the line belongs to this process, send it to rank 0
         * (line - from + 1) is used to calculate the correct local address */
        MPI_Send(Matrix[line - from + 1], elements, MPI_DOUBLE, 0, 42 + y, MPI_COMM_WORLD);
      }
    }

    if (rank == 0)
    {
      for (x = 0; x < 9; x++)
      {
        int col = x * (options->interlines + 1);

        if (line >= from && line <= to)
        {
          /* this line belongs to rank 0 */
          printf("%7.4f", Matrix[line][col]);
          // printf("%7.4f", Matrix[line][col]);
        }
        else
        {
          /* this line belongs to another rank and was received above */
          printf("%7.4f", Matrix[0][col]);
        }
      }

      printf("\n");
    }
  }

  fflush(stdout);
}



/* ************************************************************************ */
/*  main                                                                    */
/* ************************************************************************ */
int
main (int argc, char** argv)
{
	struct options options;
	struct calculation_arguments arguments;
	struct calculation_results results;

    // mpi setup ---------------------------------------------------------------
    MPI_Init(NULL, NULL);

    int rank, nprocs;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);

	/* get parameters */
	AskParams(&options, argc, argv, rank);

	initVariables(&arguments, &results, &options, rank, nprocs);

    // printf("[%d] %" PRIu64 " %" PRIu64 "\n", rank, arguments.offset_start, arguments.offset_end);


    // get and initialize variables and matrices
	allocateMatrices(&arguments);
	initMatrices(&arguments, &options);

	gettimeofday(&start_time, NULL);                   /*  start timer         */
    // solve the equation
    if (options.method == METH_JACOBI)
	{
		calculate_jacobi(&arguments, &results, &options);
	} else
	{
		calculate_gs(&arguments, &results, &options);
	}

	MPI_Barrier(MPI_COMM_WORLD);
	gettimeofday(&comp_time, NULL);                   /*  stop timer          */

	// final communication (top rank needs correct maxresiduum)
	if(nprocs > 1)
	{
		if(rank == 0)
			MPI_Recv(&results.stat_precision, 1, MPI_DOUBLE, nprocs - 1, 1, MPI_COMM_WORLD, NULL);
		if(rank == nprocs - 1)
			MPI_Send(&results.stat_precision, 1, MPI_DOUBLE, 0, 1, MPI_COMM_WORLD);
	}

	DisplayMatrix(&arguments, &results, &options);

	freeMatrices(&arguments);

    MPI_Finalize();
	return 0;
}

