#!/bin/bash

source environment

set -e
set -u
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

