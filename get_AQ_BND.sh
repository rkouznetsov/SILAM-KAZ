#!/bin/bash

# Script to download silam global runs from FMI SILAM thredds setup
# (c)opyleft Roux aka Rostislav DOT Kouznetsov AT fmi.fi 
#Updated  for v5_6 Apr 2020

# Enjoy!


basedate=${1:-"2 days ago"} 
basedate=`date -u -d "$basedate" +%Y%m%d`

set -u 
ncks=ncks

BND_PATH=SILAM-bnd

targetdir=$BND_PATH/`date -u -d "$basedate" +%Y%m%d00`
mkdir -p $targetdir
cd $targetdir



#echo $SHELL
#exit 1

runpref="silam_glob_v5_6_RUN_"
urlbase="http://silam.fmi.fi/thredds/ncss/silam_glob_v5_6/runs/$runpref"

species="AVB0_gas AVB0_m_50 BVB0_gas BVB0_m_50 C2O3_gas C5H8_2_gas
C5H8_gas CO_gas EC_m_50 ETH_gas H2O2_gas HCHO_gas
HNO3_gas HO2_gas HONO_gas N2O5_gas NH3_gas NH415SO4_m_20 NH415SO4_m_70 NH4NO3_m_70 NMVOC_gas NO2_gas NO3_c_m3_0 NO3_gas NO_gas O1D_gas O3_gas OH_gas OLE_gas OPEN_gas 
O_gas PAN_gas PAR_gas PM10 PM2_5 PM_FRP PM_FRP_m_17 PM_m6_0 PNA_gas ROR_gas 
SO2_gas SO4_m_20 SO4_m_70 TO2_gas TOL_gas XO2N_gas XO2_gas XYL_gas 
dust_m1_5 dust_m20 dust_m6_0 dust_m_30 mineral_m_50 sslt sslt_m20 sslt_m3_0 sslt_m9_0 sslt_m_05 sslt_m_50"

varlist="air_dens"

for sp in $species; do
    varlist="$varlist,cnc_${sp}"
done

echo $varlist
#exit 0





# Kazakh domain
bbox="spatial=bb&north=61&west=44&east=90&south=35"


maxjobs=4

# make dates
run=`date -u -d $basedate +"%FT00:00:00Z"`



for try  in `seq 0 10`; do
   missfiles=""
   for hr in `seq 48 167` ; do
   #for hr in `seq 48 52` ; do
        time=`date -u -d"$basedate + $hr hours" +"%FT%H:00:00Z"`
        outf=`date -u -d"$basedate + $hr hours" +"SILAM4DE${run}_%Y%m%d%H.nc"`
        [ -f $outf ] && continue
         missfiles="$missfiles $outf"


        URL="$urlbase$run?var=$varlist&$bbox&temporal=range&time_start=$time&time_end=$time&accept=netcdf&email=$email"
#        echo wget \"$URL\"
#        exit
        #
        # For some reason thredds does not supply _CoordinateModelRunDate anymore
        attcmd="-a _CoordinateModelRunDate,global,c,c,$run ${outf}.tmp -a history,global,d,,, -a history_of_appended_files,global,d,,,"
        (wget -q $URL -O ${outf}.tmp && ncatted -h $attcmd && $ncks -h --mk_rec_dmn time ${outf}.tmp $outf && rm ${outf}.tmp && echo  $outf done!) &
        while [ `jobs | wc -l` -ge $maxjobs ]; do sleep 1; done

   done
   wait
   [ -z "$missfiles" ] && break
done


if [ -z "$missfiles" ]; then
  echo "Finished okay after $try attempts"
  exit 0
else
  echo Failed!
  exit 255
fi


