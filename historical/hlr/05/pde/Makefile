# Common definitions
CC = gcc

# Compiler flags, paths and libraries
CFLAGS = -std=c99 -pedantic -Wall -Wextra -O2 -ggdb -pthread -g
LFLAGS = $(OCFLAGS)
LIBS   = -lm

OBJS = partdiff-posix.o askparams.o

# partdiff-posix: CFLAGS += -fopenmp

# Rule to create *.o from *.c
.c.o:
	$(CC) -c $(CFLAGS) $*.c

# Targets ...
all: partdiff-posix

# partdiff-seq als target erhalten (obwohl fehlerbehaftet, da omp-Funktion genutzt)
partdiff-seq: $(OBJS) Makefile
	$(CC) $(LFLAGS) -o $@ $(OBJS) $(LIBS)

partdiff-posix: $(OBJS) Makefile
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LIBS)

clean:
	$(RM) *.o *~

# partdiff-posix.o: partdiff-posix.c Makefile

askparams.o: askparams.c Makefile
