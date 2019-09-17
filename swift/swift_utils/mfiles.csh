#!/bin/csh -fx

# written by Sheri Mickelson
# March 2013

set casedir = $1
set caseid = $2
set year = $3
set mode = $4
set instance = $5
set MSS_path = $6
set MSS_tarfile = $7
set local_link = $8
set localFlag = $9
set localDir = $10
set outfile = $11
set tmp_out = "tmp.out"

set yr = `printf "%04d" $year`

set mydir = `pwd`
cd $casedir

printf "localFlag $localFlag \n" 
printf "localDir $localDir \n" 
printf "outfile $outfile \n"
printf "mode $mode \n" 
printf "instance $instance \n" 
printf "yr $yr \n" 
printf "mss_tarfile: $MSS_tarfile \n"

if ($mode == "clm2") then
  set annFile = ${casedir}/${caseid}_annT_${yr}${instance}.nc
endif
if ($mode == "cam2") then
  set annFile = ${casedir}/${caseid}_annT_atm_${yr}.nc
endif
if ($mode == "rtm") then
  set annFile = ${casedir}/${caseid}_annT_rtm_${yr}.nc
endif

printf "annFile $annFile \n"

if !(-e $annFile) then
if !(-z $annFile) then


 if !(-e ${caseid}.${mode}${instance}.h0.${yr}-{01,02,03,04,05,06,07,08,09,10,11,12}.nc) then
 if !(-z ${caseid}.${mode}${instance}.h0.${yr}-{01,02,03,04,05,06,07,08,09,10,11,12}.nc) then

  if ($localFlag == 0) then

   if ($MSS_tarfile == 0) then
     set filename = ${caseid}.${mode}${instance}.h0.${yr}
     foreach m ( 01 02 03 04 05 06 07 08 09 10 11 12)
       hsi -P "ls ${MSS_path}/${filename}-${m}.nc"
       if ($status == 0) then
         printf "running get ${MSS_path}/${filename}-${m}.nc\n"
         hsi -P "get ${MSS_path}/${filename}-${m}.nc"
       endif
     end
   else
     set filename = ${caseid}.${mode}${instance}.h0.${yr}.tar
     hsi -P "ls ${MSS_path}/${filename}"
     if ($status == 0) then
       printf "running hsi -P get ${MSS_path}/${filename}"
       hsi -P "get ${MSS_path}/${filename}"
       if ($status == 0) then
         tar -xvf $filename
         rm -f $filename
       endif
     endif
   endif
  else
   set filename = ${caseid}.${mode}${instance}.h0.${yr}
   foreach m ( 01 02 03 04 05 06 07 08 09 10 11 12)
     if ($local_link == 0) then
       printf "Running cp ${localDir}/${filename}-${m}.nc . \n"
       cp ${localDir}/${filename}-${m}.nc . 
     else
       printf "Running ln -s ${localDir}/${filename}-${m}.nc \n"
       ln -s ${localDir}/${filename}-${m}.nc .
     endif
   end
  endif
 endif
 endif


 foreach m ( 01 02 03 04 05 06 07 08 09 10 11 12)
   if !(-e ${caseid}.${mode}${instance}.h0.${yr}-${m}.nc) then
     echo "Could not find "`pwd`"/"${caseid}.${mode}${instance}.h0.${yr}-${m}.nc
#    echo "Could not find "`pwd`"/"${caseid}.${mode}${instance}.h0.${yr}-${m}.nc >> $tmp_out
     exit -1
   else
     echo "Found "`pwd`"/"${caseid}.${mode}${instance}.h0.${yr}-${m}.nc
#    echo "Found "`pwd`"/"${caseid}.${mode}${instance}.h0.${yr}-${m}.nc >> $tmp_out
   endif
 end
endif
endif

cd $mydir

printf "Complete " >> $outfile

