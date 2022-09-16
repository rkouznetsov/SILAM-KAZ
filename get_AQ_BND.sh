#!/bin/bash

# Script to download silam global runs from FMI SILAM thredds setup
# (c)opyleft Roux aka Rostislav DOT Kouznetsov AT fmi.fi 
#Updated  for v5_6 Apr 2020

# Enjoy!


basedate=${1:-"2 days ago"} 
basedate=`date -u -d "$basedate" +%Y%m%d`

set -u 
ncks=ncks

BND_PATH=${BOUNDARY_DIR}58

targetdir=$BND_PATH/`date -u -d "$basedate" +%Y%m%d00`
mkdir -p $targetdir
cd $targetdir

echo Getting boundaries to `pwd`



#echo $SHELL
#exit 1

runpref="silam_glob06_v5_8_RUN_"
urlbaseNCSS="https://thredds.silam.fmi.fi/thredds/ncss/grid/silam_glob06_v5_8/runs/$runpref" ## thredds.silam
urlbase="https://thredds.silam.fmi.fi/thredds/dodsC/silam_glob06_v5_8/runs/$runpref"
#urlbaseNCSS="https://silam.fmi.fi/thredds/ncss/silam_glob06_v5_8/runs/$runpref" 
#urlbase="https://silam.fmi.fi/thredds/dodsC/silam_glob06_v5_8/runs/$runpref"

#List form global v5_7_1 that is pesent in IND
species="AACD_gas ALD2_gas ALDX_gas AVB0_gas AVB0_m_50 AVB1e0_gas AVB1e0_m_50 AVB1e1_gas AVB1e1_m_50 AVB1e2_gas AVB1e2_m_50 AVB1e3_gas AVB1e3_m_50 AVB1e4_gas AVB1e5_gas AVB1e6_gas BENZENE_gas BVB0_gas BVB0_m_50 BVB1e0_gas BVB1e0_m_50 BVB1e1_gas BVB1e1_m_50 BVB1e2_gas BVB1e2_m_50 BVB1e3_gas BVB1e3_m_50 C2O3_gas C5H8_2_gas C5H8_gas CH3Cl_gas CO_gas CRES_gas CRO_gas CXO3_gas EC_m_50 ETHA_gas ETH_gas ETOH_gas FACD_gas H2O2_gas HCHO_gas HCO3_gas HNO3_gas HO2_gas HONO_gas IOLE_gas ISPD_gas MEO2_gas MEOH_gas MEPX_gas MGLY_gas N2O5_gas NH3_gas NH415SO4_m_20 NH415SO4_m_70 NH4NO3_m_70 NO2_gas NO3_c_m3_0 NO3_gas NO_gas NTR_gas O1D_gas O3_gas OH_gas OLE5_gas OPEN_gas O_gas PACD_gas PANX_gas PAN_gas PAR5_gas PM_m6_0 PNA_gas ROOH_gas ROR5_gas SESQ_gas SO2_gas SO4_m_20 SO4_m_70 TO2_gas TOL_gas XO2N_gas XO2_gas XYL_gas dust_m1_5 dust_m20 dust_m6_0 dust_m_30 sslt_m20 sslt_m3_0 sslt_m9_0 sslt_m_05 sslt_m_50"



varlist="a,b,da,db,a_half,b_half,O3_column,NO2_column,air_dens"

for sp in $species; do
    varlist="$varlist,vmr_${sp}"
done

echo $varlist
#exit 0





# Kazakh domain
# bbox="spatial=bb&north=61&west=44&east=90&south=35"
bbox="-d lon,${lonrange} -d lat,${latrange} -d hybrid,0,18 -d hybrid_half,0,19"


maxjobs=16

# make dates
run=`date -u -d $basedate +"%FT00:00:00Z"`



for try  in `seq 0 10`; do
   missfiles=""
   for hr in `seq 48 3 168` ; do
   #for hr in `seq 48 52` ; do
        outf=`date -u -d"$basedate + $hr hours" +"SILAM58${suitename}${run}_%Y%m%d%H.nc"`

        [ -f $outf ] && continue
        step=`expr $hr - 1`
         missfiles="$missfiles $outf"


        URL="$urlbase$run"
        ## The command that fails, but leaves trace in threds logs, so I could grep your request from there
        wget -q "$URL?ncksparams=\"$bbox -d time,$hr -v ${varlist}\"&email=$email" -O /dev/null 2>&1>/dev/null || true
#        exit
        #
        # For some reason thredds does not supply _CoordinateModelRunDate anymore
        attcmd="-a _CoordinateModelRunDate,global,c,c,$run -a history,global,d,,, -a history_of_appended_files,global,d,,, -a _ChunkSizes,,d,,,"
        compresscmd="-h --mk_rec_dmn time -4 -L5  --cnk_dmn hybrid,1 --cnk_map=rd1 --ppc vmr_.*=2"

        #   get -> fix attribures -> compress
        (ncks -O $bbox -d time,$step -v ${varlist} "$URL" ${outf}.tmp && ncatted -h $attcmd ${outf}.tmp && $ncks $compresscmd ${outf}.tmp $outf && rm ${outf}.tmp && echo  $outf done!) & 
        
        echo  `jobs | wc -l`  $maxjobs 
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


