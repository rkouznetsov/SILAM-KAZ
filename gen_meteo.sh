#!/bin/bash

#
# This is a script top get a placeholder meteo for Kazakhstan
# from yesterdays global 0.2 forecast
#

set -e
set -u

#export MAILTO="$MAILTO,mikko.aalto@fmi.fi,mikko.partio@fmi.fi"
metdatdir=eslogin:/lustre/tmp/silamdata/tmp

outdir=meteo

tmpdir=/dev/shm/KAZ-meteo

mkdir -p $tmpdir


cd $scriptdir

anmdh=`date -u -d "$fcdate - 1 day" +%m%d%H`
antime=`date -u -d "$fcdate - 1 day" +%Y%m%d`


## Clumsy. For some reason cdo can't handle different leveltypes smoothly
for hh in `seq 0 3 $((${maxhours}+24))`; do

           valdate=`date -u -d "$hh hours  $antime" +"%m%d%H"`
           filebase=F4D${anmdh}00${valdate}001
           file="$metdatdir/$filebase"
           tmpf="$tmpdir/$filebase"
           outf=$outdir/$filebase
           [ -f $outf ] && continue
           rsync -av $file $tmpdir/
	   grib_copy -w typeOfLevel=surface $tmpf $tmpf-surface.tmp
	   cdo sellonlatbox,44.,90.,35.,61.  $tmpf-surface.tmp  $tmpf-surfacecut.tmp
	   cutlist="$tmpf-surfacecut.tmp"
	   rmlist="$tmpf-surface.tmp  $tmpf-surfacecut.tmp"
	   if [ $hh -gt 0 ]; then
		   grib_copy -w typeOfLevel=hybrid $tmpf $tmpf-hybrid.tmp
		   grib_copy -w typeOfLevel=depthBelowLandLayer $tmpf $tmpf-soil.tmp
		   cdo -z aec sellonlatbox,44.,90.,35.,61.  $tmpf-hybrid.tmp  $tmpf-hybridcut.tmp
		   cdo sellonlatbox,44.,90.,35.,61.  $tmpf-soil.tmp  $tmpf-soilcut.tmp
		   cutlist="$cutlist $tmpf-hybridcut.tmp  $tmpf-soilcut.tmp"
		   rmlist="$rmlist  $tmpf-hybrid.tmp  $tmpf-hybridcut.tmp $tmpf-soil.tmp  $tmpf-soilcut.tmp"
	   fi 
           cat $cutlist > $outf.tmp
           #grib_set -w editionNumber=2 -s packingType=grid_ccsds $outf.tmp1  $outf.tmp 
           mv $outf.tmp $outf

           ls -l $tmpf $outf
           rm $tmpf $rmlist

          # grib_set -w editionNumber=2 -s packingType=grid_ccsds  $file $outf.tmp && mv $outf.tmp $outf

done

# Vegetation file

filebase=ecglob100_VEG_${antime}00+00.sfc
 file="$metdatdir/$filebase"
 tmpf="$tmpdir/$filebase"
 outf=$outdir/$filebase
 if [ ! -f $outf ]; then
   rsync -av $file $tmpdir/
   cdo sellonlatbox,44.,90.,35.,61.  $tmpf $outf.tmp
   mv $outf.tmp $outf
   ls -l $tmpf $outf
   rm $tmpf
 fi


rm -rf $tmpdir


#echo 'Checking ECMWF VEG files'
#veg_latest=/lustre/tmp/silamdata/tmp/ecglob100_VEG__latest.sfc
#veg_latest_arch=/arch/silam/bulk/data/meteo/EC_OPER/veg/ecglob100_VEG__latest.sfc
#
#if [[ ! -r $veg_latest || $veg_latest -ot $veg_latest_arch ]]; then
#    echo "Restoring VEG file"
#    cp -pv $veg_latest_arch $veg_latest
#fi
#echo Done!
#
#exit 0



