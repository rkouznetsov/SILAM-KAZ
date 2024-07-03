#!/bin/sh


#
# Makes total PM and optical columns
#
#
set -e
set -u
verbose=false


#make further aprun happy
cd $scriptdir


script=""
# Force few other vars to the output

ncdir=${OUTPUT_DIR}/$fcdate$outsuff

scriptfile=$ncdir/ncap2_total_pm_script-$$


ncfiles=`ls $ncdir/??????????.nc4 || exit 30`
if3Dcnc=false


#
# generate output filenames
filesinout=""
for ncfile in $ncfiles; do
  outfile=`dirname $ncfile`/PM_`basename $ncfile`
  filesinout="$filesinout $ncfile $outfile"
##  break #FIXME
done

ncsample=`echo $ncfiles | awk '{print $1}'`
sampledump=`ncdump -h $ncsample`



ocdvars=`echo  $sampledump |sed -e 's/;/;\n/g' |grep "float ocd_" |sed -e 's/^.*float //' -e 's/(.*$//'`




SOA="AVB0_m_50*1e9f AVB1e0_m_50*1e9f AVB1e1_m_50*1e9f AVB1e2_m_50*1e9f AVB1e3_m_50*1e9f BVB0_m_50*1e9f BVB1e0_m_50*1e9f BVB1e1_m_50*1e9f BVB1e2_m_50*1e9f BVB1e3_m_50*1e9f"
pm25_species="SO4_m_20*96e6f SO4_m_70*96e6f NH415SO4_m_20*117e6f NH415SO4_m_70*117e6f NH4NO3_m_70*80e6f sslt_m_05*1e9f sslt_m_50*1e9f dust_m_30*1e9f dust_m1_5*1e9f  EC_m_50*1e9f mineral_m_50*1e9f $SOA"

pm10_species="NO3_c_m3_0*62e6f sslt_m3_0*1e9f dust_m6_0*1e9f PM_m6_0*1e9f"






#Make PM
   #Accumulator
   var=cnc_
   vertdim=""
   $if3Dcnc && vertdim=" \$hybrid," 
   units=ug/m3
   tmpvar="tmp4"
   long_name="Concentration in air"
   script="$script *$tmpvar[\$time, $vertdim \$lat, \$lon] = 0.f; $tmpvar@units=\"$units\";"
   $verbose &&  script="$script print(\"Created  tmp for $var\\n\");"
   
   components=""
   for spec in $pm25_species; do 
     script="$script $tmpvar += ${var}${spec};"
     $verbose &&  script="$script  print(\"Added to pm25\\n\");"
     components="$components ${var}${spec}"
   done
   if [ ! -z "$components" ]; then
     [ $var = "cnc_" ] && script="$script where($tmpvar<0.5) $tmpvar=0.5f;"
     script="$script ${var}PM2_5 = $tmpvar; ${var}PM2_5@long_name=\"${long_name} PM2_5\";"
     script="$script ${var}PM2_5@components=\"$components\"; ${var}PM2_5@substance_name=\"PM2_5\";"
     script="$script  ${var}PM2_5@silam_amount_unit=\"kg\";  ${var}PM2_5@mode_distribution_type=\"NO_MODE\";"
   fi

   for spec in $pm10_species; do 
     script="$script $tmpvar += ${var}${spec};"
     $verbose &&  script="$script  print(\"Added to pm10\\n\");"
     components="$components ${var}${spec}"
   done

   if [ ! -z "$components" ]; then
     script="$script ${var}PM10 = $tmpvar; ${var}PM10@long_name=\"${long_name} PM10\";"
     script="$script ${var}PM10@components=\"$components\"; ${var}PM10@substance_name=\"PM10\";"
     script="$script  ${var}PM10@silam_amount_unit=\"kg\";  ${var}PM10@mode_distribution_type=\"NO_MODE\";"
   fi

# This line kills ncap2 at haze
#   script="$script  ram_delete($tmpvar);"
   $verbose &&  script="$script  print(\"Deleted tmp for $var\\n\");"
#Optical depth
script="$script *tmp3[\$time,\$lat,\$lon] = 0f;"
waves="550" 
if [ ! -z "$ocdvars" ]; then 
  script="$script tmp3 *= 0.f; tmp3@units=\"\";"
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
sfc="" 
$if3Dcnc && sfc=",0" for 3D output
cat >> $scriptfile <<EOF
  AQI[\$time,\$lat,\$lon] = 1b;
  AQI@long_name = "Finnish AQ Index";
  AQI@description = "1=Good 2=Fair 3=Moderate 4=Poor 5=VeryPoor"; 
  AQI@reference = "Air Quality Index based on hourly means and thresholds from https://airindex.eea.europa.eu/";
  
  AQISRC[\$time,\$lat,\$lon] = -1b;
  AQISRC@long_name="Species responsible for elevated AQI";
  AQISRC@description = "1=PM2.5 2=PM10 3=NO2 4=O3 5=SO2"; 
  AQISRC@_FillValue = -1b;
  AQISRC@missing_value = -1b;


  tmp3 = cnc_PM2_5(:$sfc,:,:);
  *iPM25 = 1f + (tmp3>10)+ (tmp3>20) +  (tmp3>25) +  (tmp3>50);
  where (iPM25>AQI) { AQI = int(iPM25); AQISRC = 1;}

  tmp3 = cnc_PM10(:$sfc,:,:);
  *iPM10 = 1f + (tmp3>20)+ (tmp3>35) +  (tmp3>50) +  (tmp3>100);
  where (iPM10>AQI) { AQI = int(iPM10); AQISRC = 2;}

  tmp3 = cnc_NO2_gas(:$sfc,:,:)*46e6;
  *iNO2 = 1f + (tmp3>40)+ (tmp3>100) +  (tmp3>200) +  (tmp3>400);
  where (iNO2>AQI) { AQI = int(iNO2); AQISRC = 3;}
  
  tmp3 = cnc_O3_gas(:$sfc,:,:)*48e6;
  *iO3 = 1f + (tmp3>80)+ (tmp3>120) +  (tmp3>180) +  (tmp3>240);
   where (iO3>AQI) { AQI = int(iO3); AQISRC = 4;}
  
  tmp3 = cnc_SO2_gas(:$sfc,:,:)*64e6;
  *iSO2 = 1f + (tmp3>100)+ (tmp3>200) +  (tmp3>350) +  (tmp3>500);
   where (iSO2>AQI) { AQI = int(iSO2); AQISRC = 5;}

EOF


$verbose && echo && echo "Script:" && echo  && cat $scriptfile

echo -n $filesinout | xargs -n 2 -P 20 -t ncap2 -O -v -S  $scriptfile 

rm $scriptfile

$verbose && echo Done!


exit 0
