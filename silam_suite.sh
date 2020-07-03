#!/bin/sh

#
# This is a placeholder script while proper suite has not yet been established
#

cd /home/kgm3/SILAM-KAZ

source environment

bash get_AQ_BND.sh > log/${fcdate}-get_AQ_BND.log

bash run_full.sh > log/${fcdate}-run.log

bash make_total_pm.sh > log/${fcdate}-make_total_pm.log


bash make_pictures.sh > log/${fcdate}-make_pictures.log



