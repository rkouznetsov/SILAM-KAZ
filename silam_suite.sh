#!/bin/sh

#
# This is a placeholder script while proper suite has not yet been established
#
set -e
set -u

cd /home/kgm3/SILAM-KAZ

source environment

d=`date +'%Y%m%d%H%M%S'`
bash get_AQ_BND.sh > log/${fcdate}-get_AQ_BND${d}.log

d=`date +'%Y%m%d%H%M%S'`
bash run_full.sh > log/${fcdate}-run${d}.log

d=`date +'%Y%m%d%H%M%S'`
bash make_total_pm.sh > log/${fcdate}-make_total_pm${d}.log


d=`date +'%Y%m%d%H%M%S'`
bash make_pictures.sh > log/${fcdate}-make_pictures${d}.log

bash upload_to_ftp.sh 000
bash upload_to_ftp.sh 001
bash upload_to_ftp.sh 002


