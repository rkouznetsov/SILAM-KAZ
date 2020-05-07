#!/bin/bash
set -u -e

set -o pipefail

umask 0002

nproc=`nproc`
#nproc="1 echo"  # this disables all xargs calls

# environment: version, family, publish


gradsscriptdir=$scriptdir/grads
pm_script=$gradsscriptdir/main_process_pm.gs
apta_script=$gradsscriptdir/main_process_AQ.gs


### WARNING system $grads environment to be used
grads="grads"
## grads=true # uncomment to disable grads calls
rsync="/usr/bin/rsync -v"


outputdir=${OUTPUT_DIR}

picture_dir=$outputdir/webloads/$fcdate${outsuff}

analysis_time=${fcdate}_00 ##${fchour}

[ -d $picture_dir ] || mkdir -p $picture_dir

cd $gradsscriptdir
pwd

mpdset="mpd_kaz"

dates=""
for h in `seq 0 $maxhours`; do ## Plot 0-th hour
   d=`date -u -d"$h hours $fcdate" +"%Y%m%d%H"`
   dates="$dates $d"
done


ioff=0 ## Start plotting with first hour
for d in $dates; do
  pm_binary=$outputdir/$fcdate${outsuff}/PM_${d}.nc4
  binary=$outputdir/$fcdate${outsuff}/${d}.nc4
  echo "\"run $pm_script   $analysis_time ${pm_binary}  $picture_dir $ioff $mpdset\"" 
  echo "\"run $apta_script $analysis_time    ${binary}  $picture_dir $ioff $mpdset\"" 
  ioff=`expr $ioff + 1`
done | xargs -t -l -P $nproc $grads -bpc

# put logo if corresponding command is provided
#cd $scriptdir/delme || exit 234
if [  -z ${PUTLOGOCMD+x}  ]; then
   echo PUTLOGOCMD is not set
else
   echo Putting logos
   ls ${picture_dir}/*.png |grep -v AQI_ |grep -v POLI_| xargs  -I XXX -P $nproc ${PUTLOGOCMD} XXX XXX  
   if [  -n ${PUTLOGOCMDINDEX+x}  ]; then
      #separate logo for AQI
      ls ${picture_dir}/*[AO][QL]I_???.png | xargs  -I XXX -P $nproc ${PUTLOGOCMDINDEX} XXX XXX  
   fi
   echo compressing pics
   ls ${picture_dir}/*.png  | xargs  -I XXX -P $nproc convert XXX PNG8:XXX
fi
#echo waiting..
#wait



echo Done with logos!
[ -n "$outsuff" ] && exit 0 #No publish for modified runs


if $publish; then
    keepdays=7
    pushd $picture_dir/..
    for d in `find . -type d -name '20??????'|sort|head -n -$keepdays`; do
       echo removing $d
       rm -rf $d
    done
    ii=0
    for d in `find . -type d -name '20??????'|sort -r`; do
       linkname=`printf  %03d $ii`
       rm -f $linkname
       echo ln -s  $d $linkname
       ln -sf  $d $linkname
       ii=`expr $ii + 1`  
    done

    #deploy animation if not yet...
    if [ !  -d Napit ]; then
     tar -xvf  $scriptdir/www/Napit.tar
     rsync -av $scriptdir/www/*.html .
    fi

    popd
#    echo Syncing $outputdir/webloads/$fctype to $fmi_data_path
#    mkdir -p $fmi_data_path
#    $rsync -a --delete  $outputdir/webloads/$fctype $fmi_data_path
fi
exit 0

