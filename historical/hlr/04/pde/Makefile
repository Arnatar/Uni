# Common definitions
CC = gcc

# Compiler flags, paths and libraries
CFLAGS = -std=c99 -pedantic -Wall -Wextra -O2 -ggdb
LFLAGS = $(OCFLAGS)
LIBS   = -lm

OBJS = partdiff-openmp.o askparams.o

partdiff-openmp: CFLAGS += -fopenmp

# Rule to create *.o from *.c
.c.o:
	$(CC) -c $(CFLAGS) $*.c

# Targets ...
all: partdiff-openmp

# partdiff-seq als target erhalten (obwohl fehlerbehaftet, da omp-Funktion genutzt)
partdiff-seq: $(OBJS) Makefile
	$(CC) $(LFLAGS) -o $@ $(OBJS) $(LIBS)

partdiff-openmp: $(OBJS) Makefile
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LIBS)

clean:
	$(RM) *.o *~

partdiff-openmp.o: partdiff-openmp.c Makefile

askparams.o: askparams.c Makefile
