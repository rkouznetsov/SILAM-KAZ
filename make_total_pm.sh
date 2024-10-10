#!/bin/sh


#
# Makes total PM and optical columns
#
#
set -e
set -u

family=IDN
#PM2_5                                                                                                                 
#SO4_m_20 SO4_m_70 NH415SO4_m_20 NH415SO4_m_70 NH4NO3_m_70 sslt_m_05 sslt_m_50 EC_m_50 OC_m_50 dust_m_30 dust_m1_5

#PM10
#NO3_c_m3_0 sslt_m3_0 dust_m6_0

#Giant
#dust_m20 sslt_m9_0 sslt_m20

#sslt: sslt_m_05 sslt_m_50 sslt_m3_0 dust_m6_0 sslt_m9_0 sslt_m20
#dust: dust_m_30 dust_m1_5 dust_m6_0  dust_m20

verbose=false

#make further aprun happy
cd $scriptdir




script=""
# Force few other vars to the output

ncdir=${OUTPUT_DIR}/$fcdate$outsuff

scriptfile=$ncdir/ncap2_total_pm_script-$$

waves="550"
dust_species="dust_m_30 dust_m1_5 dust_m6_0  dust_m20"
sia_species="SO4_m_20*96e-3f SO4_m_70*96e-3f NH415SO4_m_20*117e-3f NH415SO4_m_70*117e-3f NH4NO3_m_70*80e-3f"
sslt_species="sslt_m_05 sslt_m_50 sslt_m3_0 dust_m6_0 sslt_m9_0 sslt_m20"
soa_species="AVB0_m_50 AVB1e0_m_50 AVB1e1_m_50 AVB1e2_m_50 AVB1e3_m_50 BVB0_m_50 BVB1e0_m_50 BVB1e1_m_50 BVB1e2_m_50 BVB1e3_m_50"
frp_species="PM_FRP_m_17"

## moles ->kgC
#From CB05 final report
nmvoc_species="BENZENE_gas*72e-3f FACD_gas*12e-3f AACD_gas*24e-3f ETHA_gas*24e-3f MEOH_gas*12e-3f ETOH_gas*24e-3f CRO_gas*84e-3f MEPX_gas*12e-3f ROOH_gas*12e-3f  PANX_gas*36e-3f HCO3_gas*12e-3f OPEN_gas*48e-3f  ETH_gas*24e-3f CRES_gas*96e-3f IOLE_gas*48e-3f PAR5_gas*12e-3f  OLE5_gas*12e-3f ISPD_gas*48e-3f HCHO_gas*12e-3f ALDX_gas*24e-3f C2O3_gas*24e-3f MEO2_gas*12e-3f  ALD2_gas*24e-3f C5H8_2_gas*120e-3f C5H8_gas*60e-3f MGLY_gas*36e-3f XYL_gas*96e-3f TOL_gas*84e-3f"

pm10ss_species="sslt_m_05 sslt_m_50 sslt_m3_0"  ###sslt_m9_0 Not PM10...

pans_species="PAN_gas*121e-3f PANX_gas*121e-3f" 


ncfiles=`ls $ncdir/??????????.nc || exit 30`
if3Dcnc=false


#
# generate output filenames
filesinout=""
for ncfile in $ncfiles; do
  outfile=`dirname $ncfile`/PM_`basename $ncfile`
  filesinout="$filesinout $ncfile $outfile"
  #break #FIXME
done

ncsample=`echo $ncfiles | awk '{print $1}'`
sampledump=`ncdump -h $ncsample`



#
# Name for column variables
#
if [ "$family" = 'glob' ]; then 
  column="column"
  colname="total"
else
  column="tropcol"
  colname="Tropospheric"
fi

#
# Check Rotated-pole projection
#
if echo $sampledump |grep rotated_latitude_longitude >/dev/null; then
   lat=rlat
   lon=rlon
   script="$script rp=rp;"
   rpattr="grid_mapping=\"rp\""
   addrpattr=true
else
   lat=lat
   lon=lon
   addrpattr=false
fi


ifFRP=false #Make total FRP by default  
ifAna=false
case  $family in                                                                                                           
    glob|glob06)
      FINE_ADD="PM_FRP_m_17"
      COARSE_ADD=""
      ;;
    IDN|regional|china)
      #FINE_ADD="PM_FRP_m_17"
      FINE_ADD=""
      COARSE_ADD=""
     ;;
    europe)
      #Must use gfas for europe
      FINE_ADD="PM_GFAS_m_50"
      COARSE_ADD=""
      ;;
    europe_hindcast|europe_hindcastI)
      ifFRP=false #noFRP
      FINE_ADD="PM_GFAS_m_50  PMAS__NEG___m_50*(-1f) PMAS_m_50"
      COARSE_ADD="PMCAS__NEG___m6_0*(-1f) PMCAS_m6_0"
      ifAna=true  ##Skip wd,dd,ocd etc...
      ;;
    *)
       echo Unknown forecast family $family
       exit 255
    ;;
esac

##
## Check vertical
## 
if echo $sampledump |grep b_half >/dev/null; then
   
    vertdim="hybrid"
    script="$script a=a; b=b; a_half=a_half; b_half=b_half; vrt_dep_srf_pr=vrt_dep_srf_pr; da=da; db=db;"
    script="$script *tmp4[\$time,\$$vertdim, \$$lat,\$$lon] = 0f; "
    script="$script *tmp3[\$time,\$$lat,\$$lon] = 0f; "


else
    vertdim="height"
    script="$script dz=dz;"
    script="$script *tmp4[\$time,\$$vertdim, \$$lat,\$$lon] = 0f; "
    script="$script *tmp3[\$time,\$$lat,\$$lon] = 0f; "
fi
echo $vertdim

#
# List OCD variables
# 
ocdvars=`echo  $sampledump |sed -e 's/;/;\n/g' |grep "float ocd_" |sed -e 's/^.*float //' -e 's/(.*$//'`












  pm25_species="SO4_m_20*96e-3f SO4_m_70*96e-3f NH415SO4_m_20*117e-3f NH415SO4_m_70*117e-3f NH4NO3_m_70*80e-3f sslt_m_05 sslt_m_50 dust_m_30 dust_m1_5  EC_m_50 $FINE_ADD $soa_species"

  pm10_species="NO3_c_m3_0*62e-3f sslt_m3_0 dust_m6_0 PM_m6_0 $COARSE_ADD"






#Make PM
for var in "cnc_" "dd_" "wd_"; do 
   if [ $var = "cnc_" ]; then
     #Accumulator
     units=kg/m3
     if $if3Dcnc; then
       tmpvar="tmp4"
     else
       tmpvar="tmp3"
     fi
     long_name="Concentration in air"
     $verbose &&  script="$script print(\"Created 4D tmp for $var\\n\");"
   else
     $ifAna && break  ## Hindcast has cnc only...
     tmpvar="tmp3"
       units=kg/m2/s
       if [ $var = "dd_" ]; then
          long_name="Dry deposition rate"
       else
          long_name="Wet deposition rate"
       fi
       $verbose &&  script="$script print(\"Created 3D tmp for $var\\n\");"
   fi
   script="$script *$tmpvar *= 0.f; $tmpvar@units=\"$units\";"
   #make silam happy on reading
   $addrpattr && script="$script $tmpvar@grid_mapping=\"rp\";" # Add if needed
   
   components=""
   for spec in $pm25_species; do 
     script="$script $tmpvar += ${var}${spec};"
     $verbose &&  script="$script  print(\"Added $spec to pm25\\n\");"
     components="$components ${var}${spec}"
   done
   if [ ! -z "$components" ]; then
     script="$script ${var}PM2_5 = $tmpvar; ${var}PM2_5@long_name=\"${long_name} PM2_5\";"
     [ $var = "cnc_" ] && script="$script where(${var}PM2_5<0.5e-9f) ${var}PM2_5=0.5e-9f;"
     script="$script ${var}PM2_5@components=\"$components\"; ${var}PM2_5@substance_name=\"PM2_5\";"
     script="$script  ${var}PM2_5@silam_amount_unit=\"kg\";  ${var}PM2_5@mode_distribution_type=\"NO_MODE\";"
   fi

   for spec in $pm10_species; do 
     script="$script $tmpvar += ${var}${spec};"
     $verbose &&  script="$script  print(\"Added $spec to pm10\\n\");"
     components="$components ${var}${spec}"
   done

   if [ ! -z "$components" ]; then
     script="$script ${var}PM10 = $tmpvar; ${var}PM10@long_name=\"${long_name} PM10\";"
     [ $var = "cnc_" ] && script="$script where(${var}PM10<0.5e-9f) ${var}PM10=0.5e-9f;"
     script="$script ${var}PM10@components=\"$components\"; ${var}PM10@substance_name=\"PM10\";"
     script="$script  ${var}PM10@silam_amount_unit=\"kg\";  ${var}PM10@mode_distribution_type=\"NO_MODE\";"
   fi

   #Dust, sslt conc
   for outfrac in dust sslt soa sia PM_FRP NMVOC PANS PM10SS; do
      outvar="${var}${outfrac}" #default
      case $outfrac in 
        soa)
          myspecs=$soa_species
          ;;
        sia)
          myspecs=$sia_species
          ;;
        dust)
          myspecs=$dust_species
          ;;
        sslt)
          myspecs=$sslt_species
          ;; 
        PM_FRP)
          $ifFRP || continue # Can skip this
          myspecs=$frp_species
          ;;
        NMVOC)
          outvar="${var}${outfrac}_gas"
          myspecs=$nmvoc_species
          ;;
        PANS)
          outvar="${var}${outfrac}_gas"
          myspecs=$pans_species
          ;;
        PM10SS)
          myspecs=$pm10ss_species
          ;;
      esac

      script="$script  $tmpvar *= 0f;" #Reset accumulator
      components=""
      for spec in $myspecs; do 
        script="$script $tmpvar += ${var}${spec};"
        components="$components ${var}${spec}"
      done

      if [ ! -z "$components" ]; then
        script="$script ${outvar} = $tmpvar; ${outvar}@long_name=\"${long_name} ${outfrac}\"; ${outvar}@components=\"$components\";"
        script="$script ${outvar}@substance_name=\"$outfrac\";"
        if [ "$outfrac" = 'PANS' ]; then 
           script="$script  ${outvar}@silam_amount_unit=\"kg\";  ${outvar}@mode_distribution_type=\"GAS_PHASE\";"
        elif [ "$outfrac" = 'NMVOC' ]; then
           script="$script  ${outvar}@silam_amount_unit=\"kg\";  ${outvar}@mode_distribution_type=\"GAS_PHASE\";"
           myunit=`echo $units | sed -e s/kg/kgC/`
           script="$script  ${outvar}@units=\"$myunit\";"  ## Dirty hack -- NMVOC in GRIB are 
           # Non-methane volatile organic compounds expressed as carbon  (grib2/tables/5/4.230.table)  
        else
           script="$script  ${outvar}@silam_amount_unit=\"kg\";  ${outvar}@mode_distribution_type=\"NO_MODE\";"
        fi

      fi
   done
done


#Optical depth
if [ ! -z "$ocdvars" ]; then 
  script="$script tmp3 *= 0.f; tmp3@units=\"\";"
  $addrpattr && script="$script tmp@grid_mapping=\"rp\";" # Add if needed
  for ocdtype in dust sslt part frp abf gas; do
     mode="NO_MODE"  ##default
     ocdname=$ocdtype
     for w in $waves; do
        outvar="ocd_${ocdtype}_w${w}" 
        components=""
        for v in $ocdvars; do
           echo $v |grep _w$w > /dev/null || continue
           case $ocdtype in
              dust|sslt)
                 echo $v |grep ocd_$ocdtype > /dev/null || continue
                 ;;
              frp)
                 echo $v |grep ocd_PM_FRP > /dev/null || continue
                 ocdname="fire PM"
                 ;;
              part)
                 echo $v |grep gas_w$w  > /dev/null && continue #Not gas
                 echo $v |grep GFAS  > /dev/null && continue #Not GFAS 
                 ocdname="all aerosols"
                 ;;

              abf)
                 ocdname="other aerosols"
                 echo $v |grep gas_w$w  > /dev/null && continue #Not gas
                 echo $v |grep GFAS  > /dev/null && continue #Not GFAS 
                 echo $v |grep dust  > /dev/null && continue #Not dust
                 echo $v |grep sslt  > /dev/null && continue #Not sslt 
                 echo $v |grep PM_FRP  > /dev/null && continue #Not frp
                 ;;

              gas)
                 echo $v |grep gas_w$w > /dev/null || continue   #gas
                 mode="GAS_PHASE"
                 ;;
              *)
                 echo Strange ocdtype $ocdtype
                 exit 40
                 ;;
           esac
          script="$script tmp3 += ${v};"
          components="$components ${v}"
        done

        [ -z "$components" ] && continue # cycle if nothing added

        script="$script ${outvar} = tmp3; ${outvar}@long_name = \"optical column depth $ocdname @ ${w}nm\"; ${outvar}@components=\"$components\";"
        script="$script ${outvar}@mode_distribution_type=\"$mode\";"
        script="$script tmp3 *= 0.f;"
     done
  done
fi

echo $script |sed -e 's/;/;\n/g'> $scriptfile


#
#
#  Air-qualty index
#
if $if3Dcnc; then
  slab=":,0,:,:"
else
  slab=":,:,:"
fi

cat >> $scriptfile <<EOF
  AQI[\$time,\$$lat,\$$lon] = 1b;
  AQI@long_name = "Finnish AQ Index with EAQI thresholds";
  AQI@description = "1=Good 2=Fair 3=Moderate 4=Poor 5=VeryPoor 6=ExtremelyPoor 7=AboveExtremelyPoor"; 
  AQI@reference = "Air Quality Index based on hourly means and thresholds from https://airindex.eea.europa.eu/";
  
  AQISRC[\$time,\$$lat,\$$lon] = -1b;
  AQISRC@long_name="Species responsible for elevated AQI";
  AQISRC@description = "1=PM2.5 2=PM10 3=NO2 4=O3 5=SO2"; 
  AQISRC@_FillValue = -1b;
  AQISRC@missing_value = -1b;

//Declare it in ram
  tmp3 *= 0f;

  tmp3 = cnc_PM2_5($slab)*1e9f; // to ug/m3
  *iPM25 = 1f + (tmp3>10f)+ (tmp3>20f) +  (tmp3>25f) +  (tmp3>50f) + (tmp3>75f) + (tmp3>800f); 
  where (iPM25>AQI) { AQI = int(iPM25); AQISRC = 1;}
 
  tmp3 = cnc_PM10($slab)*1e9f;
  *iPM10 = 1f + (tmp3>20f)+ (tmp3>40f) +  (tmp3>50f) +  (tmp3>100f) + (tmp3>150f) + (tmp3>1200f);
  where (iPM10>AQI) { AQI = int(iPM10); AQISRC = 2;}

  tmp3 = cnc_NO2_gas($slab)*46e6f;
  *iNO2 = 1f + (tmp3>40f)+ (tmp3>90f) +  (tmp3>120f) +  (tmp3>230f) + (tmp3>340f) + (tmp3>1000f)  ;
  where (iNO2>AQI) { AQI = int(iNO2); AQISRC = 3;}
  
  tmp3 = cnc_O3_gas($slab)*48e6f;
  *iO3 = 1f + (tmp3>50f)+ (tmp3>100f) +  (tmp3>130f) +  (tmp3>240f) + (tmp3>380f) + (tmp3>800f);
   where (iO3>AQI) { AQI = int(iO3); AQISRC = 4;}
  
  tmp3 = cnc_SO2_gas($slab)*64e6f;
  *iSO2 = 1f + (tmp3>100f)+ (tmp3>200f) +  (tmp3>350f) +  (tmp3>500f) + (tmp3>750f) + (tmp3>1250f);
   where (iSO2>AQI) { AQI = int(iSO2); AQISRC = 5;}

EOF
$addrpattr && echo "AQISRC@grid_mapping=\"rp\"; AQI@grid_mapping=\"rp\";" >>  $scriptfile


$verbose && echo && echo "Script:" && echo  && cat $scriptfile

##cat $scriptfile
#exit 1

echo -n $filesinout | xargs -n 2 -P 20 -t ncap2 -O -v -S  $scriptfile 
# #
# # generate commands
# for ncfile in $ncfiles; do
#   datestr=`basename $ncfile .nc |sed -e s/ALL_SRCS_//`
#   outfile=`echo $ncfile | sed -e s/${ncpref}/${ncpref}_PM/`
#   echo ncap2 -h -O -v -S $scriptfile $ncfile $outfile
# ##  break #FIXME
# done |$xargs  -P$nproc -I{} -t -r sh -c '{}'


rm $scriptfile

$verbose && echo Done!


exit 0
