from fabric.api import *
import os
from fabric.contrib.files import exists


env.use_ssh_config = True
env.hosts = ['cluster']

remote_wd = "/home/werner/dev/04/"
files = 'askparams.c Makefile partdiff-seq.c partdiff-seq.h'

def dispatcher():
    run('nginx-dispatcher.sh')

def push():
    local("scp {} cluster:{}".format(files, remote_wd))

def run_():
    with cd(remote_wd):
        run('make')
        for nthreads in range(2,13):
            run('OMP_NUM_THREADS={} ./partdiff-seq 1 2 512 2 2 200'.format(nthreads))

def deploy():
    push()
    run_()

