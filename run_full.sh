#!/bin/sh


set -e
set -u
set -o pipefail

start_time=`date -u -d "$fcdate 00:00:00 UTC" +"%Y %m %d %H 00 0."`
export  start_time

CONTROL=AQ-cb5.control

#CONTROL=KAZ-cb5-nobnd-grads.control
#outsuff="nobnd-grads" 



  ymd=`date +%Y%m%d_%H%M%S`  

  export nx=1
  export ny=4
  runoutdir=${OUTPUT_DIR}/${fcdate}${outsuff}

  mkdir -p ${runoutdir}
  srun --time=2:00:00 --cpus-per-task=112 ${silam_binary}  $CONTROL 2>&1 | tee ${runoutdir}/${ymd}.log


