#!/bin/csh -f

setenv OBS_DATA     $OBS_HOME/obs_data
setenv HTML_PATH    $DIAG_HOME/html
setenv DIAG_CODE    $DIAG_HOME/code/$RUNTYPE
setenv DIAG_SHARED  $DIAG_HOME/code/shared
setenv INPUT_FILES  $INPUT_HOME/inputFiles
setenv DIAG_RESOURCES  $DIAG_HOME/code/resources

set set0 = $set_0
set set1 = $set_1
set set2 = $set_2
set set3 = $set_3
set set4 = $set_4
set set5 = $set_5
set set6 = $set_6
set set7 = $set_7
set set8 = $set_8
set set8_lnd = $set_8_lnd
set set9 = $set_9
if ($use_swift == 0) then
  if($web_pages == 1) then
  	set convertFlag = $convert
  endif
else
  set convertFlag = 0
  if($web_pages == 1) then
	set convertFlag = $convert
  endif
endif

if ($set8_lnd == "1") then
	set set8 = 1
endif

#*********************************************
# check for type of run
#*********************************************
if ($RUNTYPE == "model1-model2") then
	set compareModels = 1
else
	set compareModels = 0
endif

#**************************************************
# check for $NCARG_ROOT and make sure user 
# specified directories exist
#**************************************************
$DIAG_SHARED/lnd_systems.csh 
echo " "
echo "***************************************************"
echo "          CCSM LMWG DIAGNOSTIC PACKAGE"
echo "          Script Version: "$DIAG_HOME
echo "          NCARG_ROOT    = "$NCARG_ROOT
echo "          NOTE:  Paleo set2 uses NCARG_ROOT = 5.0.1"
echo "          "`date`
echo "***************************************************"  

#*************************************************
# create error files to force shell scripts exit
#*************************************************
if ($use_swift == 1) then
  touch $WKDIR/preProc_error_file 
  if ($set_1 == 1) then
    touch $WKDIR/set1_error_file 
    touch $WKDIR/set1Diff_error_file 
  endif
  if ($set_2 == 1) then
    touch $WKDIR/set2_error_file 
  endif
  if ($set_3 == 1) then
    touch $WKDIR/set3_error_file 
  endif
  if ($set_4 == 1) then
    touch $WKDIR/set4_error_file 
  endif
  if ($set_5 == 1) then
    touch $WKDIR/set5_error_file 
  endif
  if ($set_6 == 1) then
    touch $WKDIR/set6_error_file 
  endif
  if ($set_7 == 1) then
    touch $WKDIR/set7_error_file 
  endif
  if ($set_8 == 1) then
    touch $WKDIR/set8_DJF-JJA_contour_error_file 
    touch $WKDIR/set8_ann_cycle_error_file 
    touch $WKDIR/set8_ann_cycle_lnd_error_file 
    touch $WKDIR/set8_contour_error_file 
    touch $WKDIR/set8_trends_error_file 
    touch $WKDIR/set8_zonal_error_file 
    touch $WKDIR/set8_zonal_lnd_error_file 
  endif
  if ($set_9 == 1) then
    touch $WKDIR/set9_error_file
  endif
endif #end use_swift   
#**************************************************
# Retrieve data from MSS and pre-process data
#**************************************************

if ($regrid_file_type == "HISTORY") then

   echo "Regridding History Files ..... "

  if ($regrid_1 == 1) then
    if ($clim_first_yr_1 >= $trends_first_yr_1) then
      setenv fy $trends_first_yr_1
    else
      setenv fy $clim_first_yr_1 
    endif
    
    if ($clim_num_yrs_1 >= $trends_num_yrs_1) then
      setenv ny $clim_num_yrs_1
    else
      setenv ny $trends_num_yrs_1
    endif

    @ first_yr = $fy - 1
    @ num_yr = $ny + 1
    @ last_yr = $first_yr + $num_yr

    echo $case_1_dir
    $DIAG_SHARED/regrid_history_standalone.pl $case_1_dir $caseid_1 $first_yr $last_yr $prefix_1_dir/Regridded_History_Files/ \
		$wgt_dir_1 $area_dir_1 $old_res_1 $new_res_1 $method_1 $use_swift $swift_scratch_dir $DIAG_SHARED

    setenv case_1_dir $prefix_1_dir/Regridded_History_Files/
  endif

  if ($regrid_2 == 1) then
    if ($clim_first_yr_2 >= $trends_first_yr_2) then
      setenv fy $trends_first_yr_2
    else
      setenv fy $clim_first_yr_2      
    endif

    if ($clim_num_yrs_2 >= $trends_num_yrs_2) then
      setenv ny $clim_num_yrs_2
    else
      setenv ny $trends_num_yrs_2
    endif

    @ first_yr = $fy - 1
    @ num_yr = $ny + 1
    @ last_yr = $first_yr + $num_yr

    $DIAG_SHARED/regrid_history_standalone.pl $case_2_dir $caseid_2 $first_yr $last_yr $prefix_2_dir/Regridded_History_Files/ \
                $wgt_dir_2 $area_dir_2 $old_res_2 $new_res_2 $method_2 $use_swift $swift_scratch_dir $DIAG_SHARED

    setenv case_2_dir $prefix_2_dir/Regridded_History_Files/
  endif

  setenv regrid_1 0
  setenv regrid_2 0
endif

if($use_swift == 0) then
  $DIAG_SHARED/lnd_preProcDriver.pl
  if (-e $WKDIR/preProc_error_file) then
	echo ' '
   	echo 'Premature Exit (lnd_preProcDriver.pl)'
	echo ' '
	goto EXIT
  endif
  if ($regrid_file_type == "CLIMO") then
    if ($regrid_1 == 1 || $regrid_2 == 1) then
        $DIAG_SHARED/lnd_regrid.csh
    endif
  endif
endif

#**************************************************
# if exit_after_MSS flag is set, exit diagnostics package 
#    after reading MSS files.
#**************************************************
if($exit_after_MSS == 1) then
     echo 'Exiting after MSS file retrieval'
     goto EXIT
endif

#*************************************************
# create variable_master.ncl and copy to $WKDIR
#*************************************************
if (-e {$WKDIR}variable_master.ncl) then
	/bin/rm -f {$WKDIR}variable_master.ncl
endif
if ($CASA == 1) then
        $DIAG_SHARED/lnd_varMaster.pl
else
          cp {$INPUT_FILES}/{$var_master_cn}              {$WKDIR}variable_master.ncl
        # cp {$INPUT_FILES}/variable_master3.2.ncl      {$WKDIR}variable_master.ncl
endif

#*************************************************
# create variables lists
#*************************************************
if ( -e ${WKDIR}master_1.txt) then
	rm ${WKDIR}master*.txt
endif
	

#*************************************************
# create variable_master.ncl 
#*************************************************
# Add all regular clm variables
cat $INPUT_FILES/set1_clm.txt                 	                 > ${WKDIR}master_set1.txt
cat $INPUT_FILES/set2_clm.txt                                         > ${WKDIR}master_set2.txt
cat $INPUT_FILES/set3_*.txt                                           > ${WKDIR}master_set3.txt
cat $INPUT_FILES/set5_clm.txt    $INPUT_FILES/set5_hydReg.txt              > ${WKDIR}master_set5.txt
cat $INPUT_FILES/set6_*.txt                                           > ${WKDIR}master_set6.txt

# If CN is on, add all regular cn variables
if ($CN == 1) then
   if ($C13 == 1) then
      echo 'CN + C13 Active'
      cat $INPUT_FILES/set1_cn.txt $INPUT_FILES/set1_c13.txt >> ${WKDIR}master_set1.txt
      cat $INPUT_FILES/set2_cn.txt $INPUT_FILES/set2_c13.txt >> ${WKDIR}master_set2.txt
      cat $INPUT_FILES/set5_cn.txt $INPUT_FILES/set5_c13.txt >> ${WKDIR}masterCN_set5.txt
      cat $INPUT_FILES/set5_cn.txt $INPUT_FILES/set5_c13.txt >> ${WKDIR}master_set5.txt
    else
      echo 'CN Active; C13 Inactive'
      cat $INPUT_FILES/set1_cn.txt                           >> ${WKDIR}master_set1.txt
      cat $INPUT_FILES/set2_cn.txt                           >> ${WKDIR}master_set2.txt
      cat $INPUT_FILES/set5_cn.txt                 	        >> ${WKDIR}masterCN_set5.txt
      cat $INPUT_FILES/set5_cn.txt                           >> ${WKDIR}master_set5.txt
    endif
endif

if ($CLAMP == 1) then
       echo 'CLAMP Active'
       # Add clamp variables
       cat $INPUT_FILES/set1_clm-clamp.txt $INPUT_FILES/set1_cn-clamp.txt  >> ${WKDIR}master_set1.txt
       cat $INPUT_FILES/set2_clm-clamp.txt $INPUT_FILES/set2_cn-clamp.txt  >> ${WKDIR}master_set2.txt
       cat $INPUT_FILES/set5_cn-clamp.txt                             >> ${WKDIR}masterCN_set5.txt
       cat $INPUT_FILES/set5_cn-clamp.txt                             >> ${WKDIR}master_set5.txt
       cat $INPUT_FILES/set5_clm-clamp.txt                            >> ${WKDIR}master_set5.txt
endif

if ($CASA == 1) then
      echo 'CASA active'
      cat $INPUT_FILES/set1_casa.txt  $INPUT_FILES/set1_clm.txt		 >> ${WKDIR}master_set1.txt
      cat $INPUT_FILES/set2_casa.txt  $INPUT_FILES/set2_clm.txt		 >> ${WKDIR}master_set2.txt
      cat $INPUT_FILES/set5_casa.txt 				 >> ${WKDIR}masterCASA_set5.txt
      cat $INPUT_FILES/set5_casa.txt 				 >> ${WKDIR}master_set5.txt
endif	

cat $INPUT_FILES/set8_zonal.txt 				> ${WKDIR}master_set8_zonal.txt
cat $INPUT_FILES/set8_zonal_lnd.txt 			> ${WKDIR}master_set8_zonal_lnd.txt
cat $INPUT_FILES/set8_trends.txt 				> ${WKDIR}master_set8_trends.txt
cat $INPUT_FILES/set8_contour.txt 				> ${WKDIR}master_set8_contour.txt
cat $INPUT_FILES/set8_contour_DJF-JJA.txt 		> ${WKDIR}master_set8_contourDJF-JJA.txt
cat $INPUT_FILES/set8_ann_cycle.txt 			> ${WKDIR}master_set8_ann_cycle.txt
cat $INPUT_FILES/set8_ann_cycle_lnd.txt 		> ${WKDIR}master_set8_ann_cycle_lnd.txt

set nan_exit = 0

#**************************************************
# invoke ncl scripts and create web pages
#**************************************************

if (-e $WKDIR/ncl_list.txt) then
  rm -f $WKDIR/ncl_list.txt
endif

if($write2MSS_Only == 1) then
       echo 'writing files to MSS ONLY mode'
       goto MSS_ONLY
endif
if($web_pages == 1) then
   if ($webPage_Only == 1) then
       echo 'writing Webpage ONLY flag - debug mode'
       goto WEBPAGE_ONLY
   endif
   if ($ps2gif_Only == 1) then
       echo 'converting ps images ONLY flag - debug mode'
       goto CONVERT_ONLY
   endif
   if ($cleanup_Only == 1) then
       echo 'cleaning up ONLY flag - debug mode'
       goto CLEANUP_ONLY
   endif
endif

if ($setRestart_flag == 1) then
 echo 'restarting at set ' $setRestart_set
 if ($setRestart_set == 2) then
        goto SET2_RESTART
 endif
 if ($setRestart_set == 3) then
        goto SET3_RESTART
 endif
 if ($setRestart_set == 4) then
        goto SET4_RESTART
 endif
 if ($setRestart_set == 5) then
        goto SET5_RESTART
 endif
 if ($setRestart_set == 6) then
        goto SET6_RESTART
 endif
 if ($setRestart_set == 7) then
        goto SET7_RESTART
 endif
 if ($setRestart_set == 8) then
        goto SET8_RESTART
 endif
 if ($setRestart_set == 9) then
        goto SET9_RESTART
 endif
endif

cp {$INPUT_FILES}/{$var_master_cn}              {$WKDIR}variable_master.ncl

if ($set_0 == 1) then
  echo 'Starting set0 ----------------------------------------'
  if (-e $WKDIR/NaN.txt) then
  	/bin/rm $WKDIR/NaN.txt
  endif
  
  if ($use_swift == 0) then  
    ncl $DIAG_SHARED/lnd_NaNScreen.ncl
  else
    echo "$DIAG_SHARED/lnd_NaNScreen.ncl" >> $WKDIR/ncl_list.txt
  endif

  if (-e $WKDIR/NaN.txt && ($BLOCK_NAN) ) then
	set nan_exit = 1
	goto EXIT_NAN
  endif
endif

if ($set_1 == 1) then
  echo 'Starting set1 ----------------------------------------'

  if ($use_swift == 0) then
    ncl $DIAG_CODE/set_1.ncl
  else
    echo "$DIAG_CODE/set_1.ncl" >> $WKDIR/ncl_list.txt
  endif

  if (-e $WKDIR/set1_error_file) then
	echo ' '
   	echo 'Premature Exit (set1)'
	echo ' '
	goto EXIT
  endif
  if ($compareModels == 1) then
  	echo 'Starting set1Diff ------------------------------'
        if ($use_swift == 0) then
          ncl $DIAG_CODE/set_1DiffPlot.ncl
        else
          echo "$DIAG_CODE/set_1DiffPlot.ncl" >> $WKDIR/ncl_list.txt
        endif
  	if (-e $WKDIR/set1Diff_error_file) then
		echo ' '
   		echo 'Premature Exit (set1Diff)'
		echo ' '
		goto EXIT
  	endif
  endif
endif
SET2_RESTART:
if ($set_2 == 1) then
  echo 'Starting set2 ----------------------------------------'

  if ($use_swift == 0) then
    ncl     $DIAG_CODE/set_2.ncl
  else
    echo "$DIAG_CODE/set_2.ncl" >> $WKDIR/ncl_list.txt
  endif

  if (-e $WKDIR/set2_error_file) then
	echo ' '
   	echo 'Premature Exit (set2)'
	echo ' '
	goto EXIT
  endif
endif
SET3_RESTART:
if ($set_3 == 1) then
  echo 'Starting set3 ----------------------------------------'

  if ($use_swift == 0) then
    ncl $DIAG_CODE/set_3.ncl
  else
    echo "$DIAG_CODE/set_3.ncl" >> $WKDIR/ncl_list.txt
  endif

  if (-e $WKDIR/set3_error_file) then
	echo ' '
   	echo 'Premature Exit (set3)'
	echo ' '
	goto EXIT
  endif
endif
SET4_RESTART:
if ($set_4 == 1) then
  echo 'Starting set4 ----------------------------------------'
  echo MAKING MAP OF RAOBS STATION LOCATIONS
  
  if ($use_swift == 0) then
    ncl $DIAG_SHARED/raobs_station.ncl	# KOleson code: makes a map of stations vs obs
  else
    echo "$DIAG_SHARED/raobs_station.ncl" >> $WKDIR/ncl_list.txt
  endif

  echo MAKING SET_4 PLOTS

  if ($use_swift == 0) then
    ncl $DIAG_CODE/set_4.ncl
  else
    echo "$DIAG_CODE/set_4.ncl" >> $WKDIR/ncl_list.txt
  endif

  if (-e $WKDIR/set4_error_file) then
	echo ' '
   	echo 'Premature Exit (set4)'
	echo ' '
	goto EXIT
  endif
endif
SET5_RESTART:
if ($set_5 == 1) then
  echo 'Starting set5 ----------------------------------------'
  
  if ($use_swift == 0) then
    ncl $DIAG_CODE/set_5.ncl
  else
    echo "$DIAG_CODE/set_5.ncl" >> $WKDIR/ncl_list.txt
  endif

  if (-e $WKDIR/set5_error_file) then
	echo ' '
   	echo 'Premature Exit (set5)'
	echo ' '
	goto EXIT
  endif
endif
SET6_RESTART:
if ($set_6 == 1) then
  echo 'Starting set6 ----------------------------------------'

  if ($use_swift == 0) then
    ncl $DIAG_CODE/set_6.ncl
  else
    echo "$DIAG_CODE/set_6.ncl" >> $WKDIR/ncl_list.txt
  endif

  if (-e $WKDIR/set6_error_file) then
	echo ' '
   	echo 'Premature Exit (set6)'
	echo ' '
	goto EXIT
  endif
endif
SET7_RESTART:
if ($set_7 == 1) then
  echo 'Starting set7 ----------------------------------------'
  
  if ($use_swift == 0) then
    ncl $DIAG_CODE/set_7.ncl
  else
    echo "$DIAG_CODE/set_7.ncl" >> $WKDIR/ncl_list.txt
  endif

  if (-e $WKDIR/set7_error_file) then
	echo ' '
   	echo 'Premature Exit (set7)'
	echo ' '
	goto EXIT
  endif
endif
SET8_RESTART:
if ($set_8 == 1) then
   echo 'Starting set8 ----------------------------------------'
 if ($use_swift == 0) then  
   ncl $DIAG_CODE/set_8_zonal.ncl
   if (-e $WKDIR/set8_zonal_error_file) then
	echo ' '
   	echo 'Premature Exit (set8_zonal)'
	echo ' '
	goto EXIT
   endif
   ncl $DIAG_CODE/set_8_trends.ncl
   if (-e $WKDIR/set8_trends_error_file) then
	echo ' '
   	echo 'Premature Exit (set8_trends)'
	echo ' '
	 goto EXIT
   endif
   ncl $DIAG_CODE/set_8_contour.ncl
   if (-e $WKDIR/set8_contour_error_file) then
	echo ' '
   	echo 'Premature Exit (set8_contour)'
	echo ' '
	goto EXIT
   endif
   ncl $DIAG_CODE/set_8_ann_cycle.ncl
   if (-e $WKDIR/set8_ann_cycle_error_file) then
	echo ' '
   	echo 'Premature Exit (set8_ann_cycle)'
	echo ' '
	goto EXIT
   endif
   ncl $DIAG_CODE/set_8_DJF-JJA_contour.ncl
   if (-e $WKDIR/set8_DJF-JJA_contour_error_file) then
	echo ' '
   	echo 'Premature Exit (set8_DJF)'
	echo ' '
	goto EXIT
   endif
 else
   echo "$DIAG_CODE/set_8_zonal.ncl" >> $WKDIR/ncl_list.txt
   echo "$DIAG_CODE/set_8_trends.ncl" >> $WKDIR/ncl_list.txt
   echo "$DIAG_CODE/set_8_contour.ncl" >> $WKDIR/ncl_list.txt
   echo "$DIAG_CODE/set_8_ann_cycle.ncl" >> $WKDIR/ncl_list.txt
   echo "$DIAG_CODE/set_8_DJF-JJA_contour.ncl" >> $WKDIR/ncl_list.txt
 endif
endif
if ($set_8_lnd == 1) then
   if ($use_swift == 0) then
     ncl $DIAG_CODE/set_8_ann_cycle_lnd.ncl		# land variables for set 8
   else
     echo "$DIAG_CODE/set_8_ann_cycle_lnd.ncl" >> $WKDIR/ncl_list.txt
   endif

   if (-e $WKDIR/set8_ann_cycle_lnd_error_file) then
	echo ' '
   	echo 'Premature Exit (set8_ann_cycl_lnd)'
	echo ' '
	goto EXIT
   endif

   if ($use_swift == 0) then
     ncl $DIAG_CODE/set_8_zonal_lnd.ncl			# land variables for set 8
   else
     echo "$DIAG_CODE/set_8_zonal_lnd.ncl" >> $WKDIR/ncl_list.txt
   endif

   if (-e $WKDIR/set8_zonal_lnd_error_file) then
	echo ' '
   	echo 'Premature Exit (set8_zonal)'
	echo ' '
	goto EXIT
   endif
endif
SET9_RESTART:
if ($set_9 == 1 && $compareModels == 1) then
  echo 'Starting set9 ----------------------------------------'
  
  if ($use_swift == 0) then
    ncl $DIAG_CODE/set_9.ncl
  else
    echo "$DIAG_CODE/set_9.ncl" >> $WKDIR/ncl_list.txt
  endif

  if (-e $WKDIR/set9_error_file) then
	echo ' '
   	echo 'Premature Exit (set9)'
	echo ' '
	goto EXIT
  endif
  if ($use_swift == 0) then
    $DIAG_SHARED/lnd_statTable.pl
  endif
else
  echo 'Validation turned off ----------------------------------------'
endif

if ($use_swift == 1) then
  if !(-e $WKDIR/ncl_list.txt) then
    echo " " >> $WKDIR/ncl_list.txt
  endif
endif

# If running in non-swift mode, the package will execute as normal.  
# In swift mode, the ncl scripts will be added to the ncl file list and
# will be executed in parallel with other ncl scripts.
if ($CLAMP_DIAG == 1) then
  $CLAMP_SCRIPT
endif

CONVERT_ONLY:

WEBPAGE_ONLY:
#********************************************************
#  create gif files, set up web pages and delete ps files
#********************************************************
if ($web_pages == 1) then
    	echo 'WEBDIR = ' $WEBDIR
	if (! -e $WEBDIR) then
		echo 'creating new webdir'
    		mkdir $WEBDIR || exit 1
	endif
	cd $WEBDIR

    # images shared (used to link to NCAR's web image, which not always there)
    echo 'DIAG_SHARED=' $DIAG_SHARED
    cp $DIAG_SHARED/logo-ncar-active-large.png $WEBDIR/
    cp $DIAG_SHARED/SET*.gif $WEBDIR/
    cp $DIAG_SHARED/3Dglobe.gif $WEBDIR/

	#--------------------------
	# make sure set directories exist
	#--------------------------
	@ ctr = 1;
	foreach sets ($set1 $set2 $set3 $set4 $set5 $set6 $set7 $set8 $set9)
  		if ($sets == 1) then		# is set active? 1 == active
    		    if (! -e set$ctr) then
 			echo 'Note: ' set$ctr 'directory does not exist: Creating'
    			mkdir set$ctr
    		    else 
			set webpage = set$ctr/set$ctr.html
			if (-e $webpage) then
 				echo 'removing' $webpage
    				rm $webpage
			endif
    		    endif
  		endif
  		@ ctr++
	end
	set indexpage = setsIndex.html
	if (-e $indexpage) then
 		echo 'removing' $indexpage
  		rm $indexpage
	endif
	cd $DIAG_SHARED
        if ($use_swift == 0) then
          if ($convertFlag) then
		echo 'Converting ps2gif images'
                $DIAG_SHARED/lnd_ps2gif.pl                              # create gif from ps files
          endif
        endif
endif

#********************************************************
# Call Swift version  
#********************************************************

if ($use_swift == 1) then
# define variables that aren't defined with certain options

  if ($ModelVsModel == 0) then
    setenv trends_first_yr_2      0     # YYYY (must be >= 1)
    setenv trends_num_yrs_2       0     # number of yrs (must be >= 2)
    setenv clim_first_yr_2        0     # YYYY (must be >= 1)
    setenv clim_num_yrs_2         0     # number of yrs (must be >= 1)
    setenv commonName_2		  "null" 
    setenv UseCommonName_2	  0 
  endif

  setenv debugflag 0   # Only used in set_3.ncl

  set mydir = $RUNDIR
  cd $swift_scratch_dir
  
 swift \
  -config $mydir/cf.properties -sites.file $mydir/sites.xml -tc.file $mydir/tc.data -cdm.file $mydir/fs.data $mydir/lnd_diag.swift \
  -weightAnnAvg=$weightAnnAvg -overWriteTrend=$overWriteTrend -overWriteClimo=$overWriteClimo \
  -RUNTYPE=$RUNTYPE -WKDIR=$WKDIR -PTMPDIR=$PTMPDIR -LOCAL_LN=$LOCAL_LN -LOCAL_FLAG_1=$LOCAL_FLAG_1 \
  -LOCAL_FLAG_2=$LOCAL_FLAG_2 -LOCAL_FLAG_atm_1=$LOCAL_FLAG_atm_1 -LOCAL_FLAG_atm_2=$LOCAL_FLAG_atm_2 \
  -LOCAL_FLAG_rtm_1=$LOCAL_FLAG_rtm_1 -LOCAL_FLAG_rtm_2=$LOCAL_FLAG_rtm_2 -LOCAL_1=$LOCAL_1 -LOCAL_2=$LOCAL_2 \
  -LOCAL_atm_1=$LOCAL_atm_1 -LOCAL_atm_2=$LOCAL_atm_2 -LOCAL_rtm_1=$LOCAL_rtm_1 -LOCAL_rtm_2=$LOCAL_rtm_2 \
  -WEBDIR=$WEBDIR -DIAG_CODE=$DIAG_CODE -CN=$CN -CASA=$CASA -PLOTTYPE=$PLOTTYPE -trends_1=$trends_1 \
  -trends_2=$trends_2 -climo_1=$climo_1 -climo_2=$climo_2 -rtm_1=$rtm_1 -rtm_2=$rtm_2 -trends_atm_1=$trends_atm_1 \
  -trends_atm_2=$trends_atm_2 -climo_atm_1=$climo_atm_1 -climo_atm_2=$climo_atm_2 -trends_rtm_1=$trends_rtm_1 \
  -trends_rtm_2=$trends_rtm_2 -climo_rtm_1=$climo_rtm_1 -climo_rtm_2=$climo_rtm_2 -trends_first_yr_1=$trends_first_yr_1 \
  -trends_first_yr_2=$trends_first_yr_2 -clim_first_yr_1=$clim_first_yr_1 -clim_first_yr_2=$clim_first_yr_2 \
  -trends_num_yrs_1=$trends_num_yrs_1 -trends_num_yrs_2=$trends_num_yrs_2 -clim_num_yrs_1=$clim_num_yrs_1 \
  -clim_num_yrs_2=$clim_num_yrs_2 -MSS_tarfile_1=$MSS_tarfile_1 -MSS_tarfile_2=$MSS_tarfile_2 \
  -MSS_path_1=$MSS_path_1 -MSS_path_2=$MSS_path_2 -MSS_path_atm_1=$MSS_path_atm_1 -MSS_path_atm_2=$MSS_path_atm_2 \
  -MSS_path_rtm_1=$MSS_path_rtm_1 -MSS_path_rtm_2=$MSS_path_rtm_2 -caseid_1=$caseid_1 -caseid_2=$caseid_2 \
  -prefix_1=$prefix_1 -prefix_2=$prefix_2 -case_1_dir=$case_1_dir -case_2_dir=$case_2_dir \
  -prefix_1_dir=$prefix_1_dir -prefix_2_dir=$prefix_2_dir -case_1_atm_dir=$case_1_atm_dir -case_2_atm_dir=$case_2_atm_dir \
  -prefix_1_atm_dir=$prefix_1_atm_dir -prefix_2_atm_dir=$prefix_2_atm_dir -case_1_rtm_dir=$case_1_rtm_dir \
  -case_2_rtm_dir=$case_2_rtm_dir -prefix_1_rtm_dir=$prefix_1_rtm_dir -prefix_2_rtm_dir=$prefix_2_rtm_dir \
  -rmMonFilesTrend=$rmMonFilesTrend -rmMonFilesClimo=$rmMonFilesClimo -meansFlag=$meansFlag \
  -deleteProcDir=$deleteProcDir -clamp=$CLAMP -commonname_1=$commonName_1 -commonname_2=$commonName_2 \
  -usecommonname_1=$UseCommonName_1 -usecommonname_2=$UseCommonName_2 -diag_home=$DIAG_HOME \
  -diag_resources=$DIAG_RESOURCES -diag_version=$DIAG_HOME -expContours=$expContours -hydro=$HYDRO -input_files=$INPUT_FILES \
  -land_mask1=$land_mask1 -land_mask2=$land_mask2 -min_lat=$min_lat -min_lon=$min_lon -obs_data=$OBS_DATA -obs_res=$OBS_RES \
  -paleo=$paleo -plotObs=$plotObs -plottype=$PLOTTYPE -raster=$raster -reg_contour=$reg_contour -sig_lvl=$sig_lvl -debugflag=$debugflag \
  -trends_match_flag=$trends_match_Flag -trends_match_yr_1=$trends_match_yr_1 -trends_match_yr_2=$trends_match_yr_2 \
  -convertflag=$convertFlag -regrid_1=$regrid_1 -method_1=$method_1 -wgt_dir_1=$wgt_dir_1 -wgt_file_1=$wgt_file_1 \
  -area_dir_1=$area_dir_1 -area_file_1=$area_file_1 -old_res_1=$old_res_1 \
  -new_res_1=$new_res_1 -regrid_2=$regrid_2 -method_2=$method_2 -wgt_dir_2=$wgt_dir_2 -wgt_file_2=$wgt_file_2 \
  -area_dir_2=$area_dir_2 -area_file_2=$area_file_2 -old_res_2=$old_res_2 \
  -new_res_2=$new_res_2 -projection=$projection -colormap=$colormap -density=$density -diag_shared=$DIAG_SHARED -ncarg_root=$NCARG_ROOT \
  -clamp_diag=$CLAMP_DIAG -nlon_1=$nlon_1 -nlon_2=$nlon_2 -nlat_1=$nlat_1 -nlat_2=$nlat_2 -model_vs_model=$MODEL_vs_MODEL \
  -multi_instance1=$multi_instance1 -num_instance1=$num_instance1 -id_instance1=$id_instance1 \
  -multi_instance2=$multi_instance2 -num_instance2=$num_instance2 -id_instance2=$id_instance2

  if ($CLAMP_DIAG == 1) then
    if ($ModelVsModel == 1) then
        rm -f ${prefix_1_dir}/${MODEL_vs_MODEL}/table_*.html
        mv ${prefix_2_dir}/${prefix_2} ${prefix_1_dir}/
        tar -c -f ${prefix_1_dir}/all.tar -C ${prefix_1_dir} ${prefix_1} ${prefix_2} ${MODEL_vs_MODEL}
    else
        tar -c -f ${prefix_1_dir}/${prefix_1}.tar -C ${prefix_1_dir} ${prefix_1}
    endif
  endif

  if ($set_9 == 1 && $compareModels == 1) then
    cp $WKDIR/set9*.txt $WEBDIR/set9/
    $DIAG_SHARED/lnd_statTable.pl
    cp $WKDIR/set9*.html $WEBDIR/set9/
  endif

  cp $WKDIR/set5_*.txt $WEBDIR/set5/
  cp $WKDIR/set7_*.txt $WEBDIR/set7/

endif




#********************************************************
#   Create web pages; pages are written to $WEBDIR
#********************************************************

   echo 'writing web pages'

   cd $DIAG_SHARED
   /usr/bin/perl ./lnd_create_webpage.pl
   /usr/bin/perl ./lnd_lookupTable.pl

   echo 'done writing web pages'


#********************************************************
#   delete ps pages and create tar file 
#********************************************************
cd $WKDIR
if($web_pages == 1) then
	echo 'Making tar file ... '
	$DIAG_SHARED/lnd_createTarFile.csh 				
endif

echo 'All done. '

#********************************************************
#   write files to MSS
#********************************************************
MSS_ONLY:

if ($MSS_write == 1) then
	echo 'writing files to MSS'
	$DIAG_SHARED/lnd_write2mss.csh
	echo 'done writing files to MSS'

endif


#********************************************************
# Clean up
#********************************************************
CLEANUP_ONLY:

cd $DIAG_CODE

if($web_pages == 1) then
	if ($delete_ps == 1) then
		echo 'Cleaning up work directories (deleting PS files). '
		rm -r $WKDIR/
	endif
	if ($delete_webdir == 1) then
		echo 'Cleaning up web directories (deleting gif files). '
		rm -r $WEBDIR/
	endif
endif
#********************************************************
# Exit for NaNs
#********************************************************
EXIT_NAN:
if ($nan_exit) then
	echo ' '
   	echo 'Premature Exit : Screening procedure found NaNs in input files'
	echo ' '
   	echo 'If you would like to proceed, set BLOCK_NAN to 1 and restart script.'
   	echo ' ..... Note that NaNs are automatically reset to missing by the diagnostics package.'
	echo ' '
endif


EXIT:
set noclobber
echo ' '
echo ' '
echo EXIT lnd_diag-version:{$DIAG_HOME} "`date`"
