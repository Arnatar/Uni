from fabric.api import *
import os
from fabric.contrib.files import exists


env.use_ssh_config = True
env.hosts = ['cluster']

remote_wd = "/home/werner/dev/04/"
files = 'askparams.c Makefile partdiff-seq.c partdiff-seq.h jobscript.slurm'

def dispatcher():
    run('nginx-dispatcher.sh')

def push():
    local("scp {} cluster:{}".format(files, remote_wd))

def run_messung1():
    with cd(remote_wd):
        run('make')
        # for n in range(0,1):
        # nlines = 2**
        nlines=1024
        print(nlines)
        run('OMP_NUM_THREADS=12 ./partdiff-seq 1 2 {} 2 2 2000'.format(nlines))

def run_messung2():
    with cd(remote_wd):
        run('make')
        for n in range(0,11):
            nlines=2**n
            run('nlines={} sbatch --error=err/{}.err --output=out/{}.out jobscript.slurm'.format(nlines,nlines,nlines))

def deploy():
    push()
    run_messung2()

def get_out():
    with cd(remote_wd):
        run('cat run.out')
        run('cat job.err')
