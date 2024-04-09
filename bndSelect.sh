#!/bin/bash

#
# Selects boundary files for an offline run
#

set -u
set -e 

date=20220406
enddate=`date -d yesterday +%Y%m%d`

indirlist=SILAM-bnd58.lst
outd=SILAM-bnd58-selected
misslist=SILAM-bnd58-missing.lst

if [ ! -f $indirlist ]; then
  echo "Creating file list.."
  find  SILAM-bnd58 -name SILAM58AQ-VNM*.nc | sort > $indirlist.tmp 
  mv $indirlist.tmp $indirlist
  echo "File list done: $indirlist "
else
  echo "File list already done: $indirlist "
fi

while  [ $date -le $enddate ]; do
  YYYY=`date -d $date +%Y`
  mkdir -p $outd/$YYYY
  for hh in 00 03 06 09 12 15 18 21; do
    inf=`grep  $date$hh.nc $indirlist | tail -n 1`
    if [ -z $inf ]; then
        echo Missing file for $date$hh |tee -a $misslist
        continue
    fi
    base=`basename $inf`
    outf=$outd/$YYYY/$base
    if [ ! -f $outf ]; then
       cp -p $inf $outf.tmp && mv $outf.tmp $outf
    fi
  done
  echo $date done!
  date=`date -d "$date + 1 day" +%Y%m%d`
done
