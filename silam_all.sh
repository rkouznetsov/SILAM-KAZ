#!/bin/bash


set -e
set -u
cd /pfss_fs1/SILAM-scripts/I4FIRES-FIRMS
. environment

date

bash NRT-fires-region.sh

cd /pfss_fs1/SILAM-scripts/IDN-BMKG
source environment
fcdate=20241007

date
bash get_meteo.sh 12
date
bash get_meteo.sh
date
bash get_AQ_BND.sh '2 days ago'
date
bash get_AQ_BND.sh '3 days ago'
date
bash run_full.sh
date
bash make_total_pm.sh
date
bash make_pictures.sh
date
echo Done for $fcdate!

