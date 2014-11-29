#!/bin/sh

#SBATCH --time=0:05 --time-min=0:02
# Run 10 tasks on 2 nodes.
#SBATCH -N 2 -n 10
# Output goes to j.out
#SBATCH -o j.out
mpirun ./timempi