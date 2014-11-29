#!/bin/sh

#SBATCH --time=0:05
#SBATCH -N 4
#SBATCH --ntasks-per-node=1
#SBATCH -o j.out
mpirun ./timempi
