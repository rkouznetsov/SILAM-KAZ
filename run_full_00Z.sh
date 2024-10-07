#!/bin/bash

workdir=/home/bik/silam-inanwp

cd $workdir

. environment

set -e
set -u
set -o pipefail

start_time=`date -u -d "$fcdate 00:00:00 UTC" +"%Y %m %d %H 00 0."`
export  start_time

CONTROL=AQ-cb5-00Z.control

#CONTROL=KAZ-cb5-nobnd-grads.control
#outsuff="nobnd-grads" 



  ymd=`date +%Y%m%d_%H%M%S`  

  export nx=1
  export ny=4
  mkdir -p output/${fcdate}${outsuff}
#  export OMP_NUM_THREADS=16

#/usr/bin/time -v /usr/mpi/gcc/openmpi-4.1.4rc1/bin/mpirun -np 32 ${silam_binary}  $CONTROL 2>&1 | tee output/${fcdate}${outsuff}/${ymd}.log

#  /usr/bin/time -v mpirun  -display-map -n 4  --bind-to socket --rank-by core ${silam_binary}mpi  $CONTROL 2>&1 | tee output/${fcdate}${outsuff}/${ymd}.log
  #/usr/bin/time -v mpirun  -display-map -n 4 ${silam_binary}mpi  $CONTROL 2>&1 | tee output/${fcdate}${outsuff}/${ymd}.log
  /usr/bin/time -v ${silam_binary}  $CONTROL 2>&1 | tee output/${fcdate}${outsuff}/${ymd}.log

  #gdb -ex 'break globals::set_error' -ex 'set breakpoint pending on' -ex 'break exit' -ex 'set breakpoint pending off' -ex 'r' --args ${silam_binary}_debug  $CONTROL 

  #srun --cpus-per-task=$OMP_NUM_THREADS --ntasks-per-node=$taskspernode $silam $CONTROL 2>&1 | tee output/${case}/${case}\${ymd}.log
