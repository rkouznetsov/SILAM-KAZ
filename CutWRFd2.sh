#!/bin/sh

#
# Makes cut/compressed NetCDF for a single input WRF file for a given domain
#

set -u
set -e

#ncks=/usr/bin/ncks
ncks=$HOME/singularity/nco/ncks

infile=$1
outdir=$2




rundate=`basename $1 | sed -e 's/.*d01_//' -e 's/_\(..\):00:00.*/T\1:00:00/'`

outd=$outdir/$rundate
mkdir -p $outd

for s in `seq 0 24`; do
	outdate=`date -u -d "$s hours $s hours $s hours  $rundate" +"%Y-%m-%dT%H"` ##Strange way for 3-hour increments

	outfile=$outd/$outdate.nc
    
    [ -f $outfile ] && continue


if [ $s -eq 0 ]; then
  echo $ncks -4 -L2 -d Time,$s -v XLAT,XLONG,LU_INDEX,VAR_SSO,SHDMAX,SHDMIN,SNOALB,VEGFRA,HGT,XLAND,LANDMASK,LAKEMASK,LAI,Times  $infile $outfile

else  
  list3d='U,V,T,QVAPOR,QCLOUD,QRAIN,QICE,QSNOW,QGRAUP,TKE_PBL,CLDFRA'
  prc3d="--ppc U,V,T=.3 --ppc QVAPOR,QCLOUD,QRAIN,QICE,QSNOW,QGRAUP=.7 --ppc TKE_PBL=2 --ppc CLDFRA=.3"

  list2d='Q2,T2,PSFC,U10,V10,TSLB,SMOIS,SEAICE,SNOW,SNOWH,SSTSK,LAI,TSK,RAINC,RAINNC,SWDOWN,SWDNB,ALBEDO,UST,PBLH,HFX,QFX,ACHFX,SST,AFWA_CAPE'
  prc2d='--ppc U10,V10,T2,SMOIS,SEAICE,SSTSK,LAI,TSK,RAINC,RAINNC,ALBEDO,SST,TSLB=.2 --ppc Q2,PBLH,UST=2'

  gridvars="SINALPHA,COSALPHA,MAPFAC_MX,MAPFAC_MY,XLONG,XLAT,XLONG_U,XLAT_U,XLONG_V,XLAT_V,MAPFAC_UX,MAPFAC_UY,MAPFAC_VX,MAPFAC_VY"

  othervars='XLON.*,XLAT.*,Times,ZNU,ZNW,ZS,DZS,HFX_FORCE,LH_FORCE,TSK_FORCE,HFX_FORCE_TEND,LH_FORCE_TEND,TSK_FORCE_TEND,FNM,FNP,RDNW,RDN,DNW,DN,CFN,CFN1,THIS_IS_AN_IDEAL_RUN,RDX,RDY,RESM,ZETATOP,CF1,CF2,CF3,ITIMESTEP,XTIME,P_TOP,T00,P00,TLP,TISO,TLP_STRAT,P_STRAT,MAX_MSTFX,MAX_MSTFY,SAVE_TOPO_FROM_REAL,ISEEDARR_SPPT,ISEEDARR_SKEBS,ISEEDARR_RAND_PERTURB,ISEEDARRAY_SPP_CONV,ISEEDARRAY_SPP_PBL,ISEEDARRAY_SPP_LSM,C1H,C2H,C1F,C2F,C3H,C4H,C3F,C4F'

  echo $ncks -4 -L5 -d Time,$s --baa=1 -v $gridvars,$othervars,$list3d,$list2d $prc3d $prc2d --cnk_dmn bottom_top,1 $infile $outfile
fi  

done |xargs -P 25 -r -I{} -t sh -c '{}'

