#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 12

# 1.5h timeout
#SBATCH --time=90
# nlines=1024
export OMP_NUM_THREADS=12
srun ./partdiff-seq 1 2 $nlines 2 2 100
