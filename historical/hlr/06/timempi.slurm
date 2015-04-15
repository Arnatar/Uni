#!/bin/sh

#SBATCH --time=0:05
#SBATCH -N 2
#SBATCH -n 6
#    #SBATCH --ntasks-per-node=1
#SBATCH -o j.out
mpirun ./timempi2
