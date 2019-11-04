#!/bin/csh -f

# Version lnd_template4.2.28.csh

# NOTE: You MUST use ncl/6.2.0 (e.g., module load ncl/6.2.0)
 
# NOTE: For running the non-swift version of this script, you MUST use
#       nco/4.2.0 (e.g., module load nco/4.2.0).  The swift version is
#       already hardcoded to use nco/4.2.0

# NOTE: This script no longer retrieves history files from the hpss. 
#       Use the script get_hpss_files.csh in $DIAG_HOME/code/shared to get 
#       history files before running this script.

#**************************************************
#  O = OFF; 1 = ON
#**************************************************
# GENERAL  USER MODIFY SECTIONS: 1-21
# ADVANCED USER MODIFY SECTIONS 22-27
#**************************************************
# NOTE:  Pathnames do not require a trailing slash.
#**************************************************
# 1:  Path to data
#**************************************************
 setenv CURRDIR         ${PWD}

# datasets
 setenv PTMPDIR        ${CURRDIR}/results
 setenv SOURCE_1       ${CURRDIR}/sim_baseline 
 setenv SOURCE_2       ${CURRDIR}/none
# Turn on if history files exist on local directory or another machine
# Files will be copied to local directory

setenv LOCAL_FLAG_1       1	#1=ON; 0=OFF
setenv LOCAL_FLAG_2       0	#1=ON; 0=OFF
#setenv LOCAL_FLAG_atm_1   0	#1=ON; 0=OFF
#setenv LOCAL_FLAG_atm_2   0	#1=ON; 0=OFF
#setenv LOCAL_FLAG_rtm_1   0	#1=ON; 0=OFF
#setenv LOCAL_FLAG_rtm_2   0	#1=ON; 0=OFF

setenv LOCAL_LN           1	#1=soft link; 0=copy

#*****************************************************************
# 2a:  Path to land diagnostics package source code
# Do not change this path unless you wish to create
# code changes.  Revisions to code base will not be broadcast.
#**************************************************
setenv DIAG_HOME /lustre/or-hydra/cades-ccsi/f9y/models/ncar_lnd_diag

#*****************************************************************
# 2b:  Path to observational datasets
#*****************************************************************
setenv OBS_HOME  /lustre/or-hydra/cades-ccsi/f9y/models/ncar_lnd_diag

#*****************************************************************
# 2c:  Compare to Observations in set 2
# #*****************************************************************
setenv plotObs  1                                               # (1 = compare to PD observations; 0 = OFF)

#**************************************************
# 3:  where variable lists exist.  
# Do not change this path unless you wish to create 
# non-standard variable lists.
# Standard variable lists:  $DIAG_HOME/inputFiles
# To create non-standard variable lists:
#   a.  copy all variable lists from $DIAG_HOME/inputFiles
#   b.  modify variable lists (retain exact format)
#   c.  change INPUT_HOME to point to new lists
#**************************************************
setenv INPUT_HOME /${DIAG_HOME}/code
setenv var_master_cn 	variable_master4.3.ncl
setenv var_master_casa  variable_master_CASA.ncl

#**************************************************
# 4:  set runtype (model1 vs model2; model vs obs)
#**************************************************
setenv OBS		1	# model vs observations (1 = ON; 0 = OFF)
setenv ModelVsModel	0	# model1 vs model2      (1 = ON; 0 = OFF)

#**************************************************
# 5:  set case1 names
#**************************************************

# Case 1
setenv prefix_1  ELMv1_highlat	# used for output file names
setenv caseid_1  elm20181101_ICB20TRCNPRDCTCBC_N60  	# identifies history files
setenv commonName_1    ELMv1_highlat  	# (Optional) common name for ID'ing run e.g., low water use
setenv UseCommonName_1  1	# 1 = use commonName in plots; 0 = use caseid or prefix

# Case 2
if ($OBS == 1) then
   setenv prefix_2 Observations  	     	# used for output file names
   setenv caseid_2 obs  		# identifies history files
else
   setenv prefix_2 demo2 	# USER SUPPLIED for output file names
   setenv caseid_2 	 	# identifies history files
   setenv commonName_2    demo2  	# (Optional) common name for ID'ing run e.g., low water use
   setenv UseCommonName_2  1	# 1 = use commonName in plots; 0 = use caseid or prefix
endif

#**************************************************
# 6a:  location of data files - if on mass store
# NOTE: DEPRECATED. Use the script get_hpss_files.csh in code/shared to get history files 
#                   before running diagnostics package
#**************************************************
# 6b:  location of local data files (default here assumes CISL machines) 
#**************************************************
setenv LOCAL_1       /nfs/data/ccsi/f9y/ELM_highlat_simulations/${caseid_1}
setenv LOCAL_2       NONE
#setenv LOCAL_atm_1   /Users/f9y/project_acme/archives/${caseid_1}/atm/hist
#setenv LOCAL_atm_2   /Users/f9y/project_acme/archives/${caseid_2}/atm/hist
#setenv LOCAL_rtm_1   /Users/f9y/project_acme/archives/${caseid_1}/rof/hist
#setenv LOCAL_rtm_2   /Users/f9y/project_acme/archives/${caseid_2}/rof/hist
#**************************************************
# 6c:  location for MSS data storage
#**************************************************
# 7a:  which climatological files need to be created?
#**************************************************
setenv overWriteTrend  0   # (1=ON,0=OFF)  Debug tool to overwrite existing files.  (Default=0)
setenv overWriteClimo  0   # (1=ON,0=OFF)  Debug tool to overwrite existing files.  (Default=0)

setenv weightAnnAvg    1   # (1=ON,0=OFF)  On: Ann=(J*31+F*28+...+D*31)/365  Off: Ann=(Jan+Feb+...+Dec)/12

# Case 1
setenv      trends_1   1   # (1=ON,0=OFF)  (set1 & set6) Make trends for case1 simulation
setenv       climo_1   1   # (1=ON,0=OFF)  (set2 & set3 & set5 & set7) Make climo for case1 simulation
setenv  trends_atm_1   0   # (1=ON,0=OFF)  (set4)  Make atm trends for case1
setenv   climo_atm_1   0   # (1=ON,0=OFF)  (set4)  Make atm climo for case1

setenv         rtm_1   0   # (1=ON,0=OFF)  Set to ON (1) for case1 if RTM variables are on separate history files
if ($rtm_1 == 1) then
  setenv  trends_rtm_1   0   # (1=ON,0=OFF)  (set7)  Always set to OFF (0)
  setenv   climo_rtm_1   0   # (1=ON,0=OFF)  (set7)  Make rtm climo for case1
else
  setenv  trends_rtm_1   0   # (1=ON,0=OFF)  (set7)  Always set to OFF (0)
  setenv   climo_rtm_1   0   # (1=ON,0=OFF)  (set7)  Always set to OFF (0)
endif

# Case 2
setenv      trends_2   1   # (1=ON,0=OFF)  (set1 & set6) Make trends for case2 simulation
setenv       climo_2   1   # (1=ON,0=OFF)  (set2 & set3 & set5 & set7) Make climo for case2 simulation
setenv  trends_atm_2   0   # (1=ON,0=OFF)  (set4)  Make atm trends for case2
setenv   climo_atm_2   0   # (1=ON,0=OFF)  (set4)  Make atm climo for case2

setenv         rtm_2   0   # (1=ON,0=OFF)  Set to ON (1) for case2 if RTM variables are on separate history files
if ($rtm_2 == 1) then
  setenv  trends_rtm_2   0   # (1=ON,0=OFF)  (set7)  Always set to OFF (0)
  setenv   climo_rtm_2   0   # (1=ON,0=OFF)  (set7)  Make rtm climo for case2
else
  setenv  trends_rtm_2   0   # (1=ON,0=OFF)  (set7)  Always set to OFF (0)
  setenv   climo_rtm_2   0   # (1=ON,0=OFF)  (set7)  Always set to OFF (0)
endif

#**************************************************
# 7b:  Create Seasonal Means (used in T-Test for set2 in ModelVsModel comparisons)
#      ModelVsModel = 1:  (REQUIRED) means required for T-Test 
#               OBS = 1:  (OPTIONAL) means not used by diagnostic package.
#**************************************************
if ($OBS == 1) then
   setenv meansFlag    1    # (1=ON,0=OFF)  (default = 1)
else
   setenv meansFlag    1    # (1=ON,0=OFF)  (default = 1)
endif
#**************************************************
#**************************************************
# 8:  Specify first year and number of years to be analyzed for long-term climatology (CLIMO).
#**************************************************
setenv clim_first_yr_1          1900      # YYYY (must be >= 1)
setenv clim_num_yrs_1            115      # number of yrs (must be >= 1)
if ($ModelVsModel == 1) then
  setenv clim_first_yr_2        1850     # YYYY (must be >= 1)
  setenv clim_num_yrs_2          10     # number of yrs (must be >= 1)
endif

#**************************************************
# 9:  Specify first year and number of years to be analyzed for long-term trends (TRENDS).
#**************************************************
setenv trends_first_yr_1        1900      # YYYY (must be >= 1)
setenv trends_num_yrs_1          115      # number of yrs (must be >= 2)
if ($ModelVsModel == 1) then
  setenv trends_first_yr_2      1850     # YYYY (must be >= 1)
  setenv trends_num_yrs_2         10     # number of yrs (must be >= 2)
endif

#**************************************************
# 10:  SPECIAL CASE DESCRIPTION: Use to compare records of different lengths and/or time periods.
#     Note:  When comparing trends of different lengths, OR different
#     starting years, trends_match_Flag will default to 1.  Therefore,
#     the user must set match_yr_1 and match_yr_2.  i.e.,
#             (trends_first_yr_1) .ne. (trends_first_yr_2)  
#             (trends_num_yrs_1)  .ne. (trends_num_yrs_2)
#**************************************************
setenv trends_match_Flag        0        # compare different years   (default=0)
setenv trends_match_yr_1      1850       # First year of overlap case1
setenv trends_match_yr_2      1850       # First year of overlap case2

#**************************************************
# 11: Turn this on to exit after reading MSS files 
#    NOTE: When using this option, customize the options in
#    Sections 1 - 9, including the first year and
#    the number of years to retrieve (Sections 8 and 9).  
#    Set Section 7 options to OFF (0) (except rtm_1 and rtm_2 if appropriate).
#    You not have to set any parameters past Section 11.
# NOTE: DEPRECATED. Use the script get_hpss_files.csh in code/shared to get history files 
#                   before running diagnostics package
#**************************************************
setenv exit_after_MSS            0     	 # (1=ON;0=OFF)  			(default = 0)
setenv write2MSS_Only            0
setenv MSS_write                 0

#**************************************************
# 12a:  Is the Carbon/Nitrogen model active?
#**************************************************
setenv CN      1  # (1=CN model active,0=CN model inactive)
setenv C13     0  # (1=C13 Istotopes active,0=C13 isotopes inactive)  NOT TESTED!
setenv CLAMP   0  # (1=CLAMP terminology,0=CLM-CN terminology)        NOT TESTED!
setenv CASA    0  # (1=CASA terminology,0=CLM-CN terminology)         NOT TESTED!
#**************************************************
# 12b:  Are the hydro variables active?
#**************************************************
setenv HYDRO   1  # (1=HYDRO vars active,0=HYDRO vars inactive)  (default = 1)

#**************************************************
# 13:  NaN Pre-screening	(recommended)
#**************************************************
setenv set_0      1   # (1=ON,0=OFF)  PRE-SCREEN for NaNs
setenv BLOCK_NAN  0   # (1=ON,0=OFF)  Exit script if NaNs are found

#**************************************************
# 14:  What sets are active?
#*************************************************
setenv set_1      1   # (1=ON,0=OFF)  ANNUAL TRENDS					(default=1)
setenv set_2      1   # (1=ON,0=OFF)  CE CONTOUR PLOTS					(default=1)
setenv set_3      1   # (1=ON,0=OFF)  REGIONAL MONTHLY 2M-TEMP,PRECIP,			(default=1)
                      # RUNOFF,RADIATIVE AND TURBULENT FLUXES
setenv set_4      0   # (1=ON,0=OFF)  VERTICAL PROFILES					(default=0)
setenv set_5      1   # (1=ON,0=OFF)  ANNUAL MEANS OF REGIONAL HYDROLOGIC		(default=1)
                      # CYCLE AND GLOBAL QUANTITIES
setenv set_6      1   # (1=ON,0=OFF)  ANNUAL TRENDS FOR REGIONS				(default=1)
setenv set_7      0   # (1=ON,0=OFF)  RIVER FLOW AND DISCHARGE			 	(default=1)
setenv set_8      0   # (1=ON,0=OFF)  OCN-ATMOS TRACERS					(default=0)
setenv set_8_lnd  1   # (1=ON,0=OFF)  LND-ATMOS TRACERS					(default=0)
setenv set_9      0   # (1=ON,0=OFF)  VALIDATION DIAGNOSTICS (ONLY FOR MODEL-MODEL)	(default=1)

#**************************************************
# 15:  Restart Set Analysis and skip previous sets.
#**************************************************
setenv setRestart_flag  0   # (1=On,0=Off)  Continue processing sets at $setRestart_flag  (default=0)
setenv setRestart_set   2   # (Valid sets:  2,3,4,5,6,7,8,9)
#**************************************************
# 16:  User preferences:
# Note #1: New users should run a short test run (e.g., 5 yrs) with these flags turned off (1) to be sure
# the diagnostics package is running smooothly with their data.  Then turn the rmMonFiles* flags to on (0)
# to save file space.
#**************************************************
 setenv projection       2      # (1=Cylindrical Equidistant, 0=Robinson, 2=PolarAzimuthalEquiDistant)
 setenv colormap         1      # (1=use Blue-Yellow-Red Colormap, 0=use original colormaps)
 setenv density        288      # controls density of output .gif images, example values = 72,96,144,216,288 (higher values = higher quality)
 setenv rmMonFilesTrend  0      # (1=ON,0=OFF)  rm monthly MSS files after trend files are created   (default = 0)
 setenv rmMonFilesClimo  0      # (1=ON,0=OFF)  rm monthly MSS files after climo files are created   (default = 0)
 setenv raster           1      # (1=ON,0=OFF)  raster mode for set2 contour plots.                  (default = 1)
 setenv expContours      0      # (1=ON,0=OFF)  All contours are user defined for set2 plots.        (default = 0)
				#  To set explicit contours when expContours=0: change 0 to 1 in $INPUT_HOME/set2_*.txt 
                                #  expContours SHOULD ALWAYS BE OFF NOW (set to 0) BECAUSE OF RECENT CHANGES TO SET2
                                #  THAT MAKE THIS OPTION UNNECESSARY
 setenv deleteProcDir    1      # (1=ON,0=OFF)  delete processing directory.  Turn off if you are
				#               considering a continuation of current run.           (default = 1)
#**************************************************
# 17a:  Create web pages?
#*************************************************
setenv web_pages  1   # (1=On,0=Off)  Create webpages.
#**************************************************
# 17b:  Convert postscript files to GIF image files, putting
# then all in subdirectories along with html files.
# Then make tar file of the web pages and gif files.
# Note:  Use default values.
#**************************************************
if ($web_pages == 1) then
 setenv delete_ps        1      # (1=ON,0=OFF)  delete postscript files                              (default = 1)
 setenv delete_webdir    0      # (1=ON,0=OFF)  delete webdir with GIF files                         (default = 1)
 setenv cleanup_Only     0      # (1=ON,0=OFF)  cleanup directories after tar file is created        (default = 0)
 setenv webPage_Only     0      # (1=ON,0=OFF)  skip everything except making the webpage            (default = 0)
 setenv ps2gif_Only      0      # (1=ON,0=OFF)  skip making sets, start with conversion of ps to gif (default = 0)
 setenv convert          1      # (1=ON,0=OFF)  convert ps2gif					     (default = 1)
endif

#**************************************************
# 18:  Send notification and scp tar file?
#**************************************************
setenv remote      0      # (1=ON,0=OFF)  send email to unix.
setenv scpFile     0      # (1=ON,0=OFF)  send tar file to unix (requires interactive passwd).
if ($remote == 1) then
	setenv remote_system  'mycomputer.cgd.ucar.edu'
	setenv remote_dir     '/mydir/diagnostics'
	setenv email_address  ${LOGNAME}@ucar.edu
endif

#**************************************************
# 19:  Use Swift?
#**************************************************

setenv use_swift  0    #(1=ON,0=OFF)  use swift version of the diagnostic package
setenv swift_scratch_dir ${HOME}/sratch/swift_scratch
setenv RUNDIR /${PWD}

#**************************************************
# 20:  Regrid Data (Currently only regrids NE30 to FV_192x288 and NE120 to FV_768x1152)
#      You MUST use ncl/6.2.0.  When using Swift, you must have this statement,
#      module load ncl/6.2.0, in your, e.g., .tcshrc, to ensure that all instances
#      of regridding are using this version
#**************************************************

# For the variable regrid_file_type choose HISTORY or CLIMO.
# HISTORY = regrid all history files used in the comparison
#   -- Must be set to HISTORY if the C-LAMP package is set to true.
#   -- BUT the NE30/NE120 history files must already be staged in
#      the case directory(ies).  You can either do this by linking to the 
#      files if they exist at another location or getting them from the 
#      hpss using code/shared/get_hpss_files.csh.
#      The automated linking method specified by LOCAL_FLAG above
#      will only work seamlessly when regrid_file_type is set to CLIMO.
# CLIMO = regrid only the climo files
setenv regrid_file_type CLIMO
 
setenv regrid_1   0
setenv method_1   conserve
setenv old_res_1  SE_NE30
setenv new_res_1  FV_192x288
setenv wgt_dir_1  $DIAG_HOME/regriddingFiles/ne30/
setenv wgt_file_1 $old_res_1"_to_"$new_res_1"."$method_1".nc"
setenv area_dir_1  $DIAG_HOME/regriddingFiles/
setenv area_file_1 $new_res_1"_area.nc"

setenv regrid_2   0
setenv method_2   conserve
setenv old_res_2  SE_NE120
setenv new_res_2  FV_768x1152
setenv wgt_dir_2  $DIAG_HOME/regriddingFiles/ne120/
setenv wgt_file_2 $old_res_2"_to_"$new_res_2"."$method_2".nc"
setenv area_dir_2  $DIAG_HOME/regriddingFiles/
setenv area_file_2 $new_res_2"_area.nc"

#**************************************************
# 21:  Multi-instance mode
#**************************************************
# Only works with swift
# Set num_instance to 1, 16, or 32 
# If you only want to diagnose one of the instances (instead of the average of all the instances),
# then set num_instance to 1 and id_instance to the id of the land instance to diagnose
setenv multi_instance1 0      # (1=ON,0=OFF)
setenv num_instance1   32     # number of land instances
setenv id_instance1    _0003  # if num_instance is 1, this is id of land instance to diagnose
setenv multi_instance2 0      # (1=ON,0=OFF)
setenv num_instance2   32     # number of land instances
setenv id_instance2    _0003  # if num_instance is 1, this is id of land instance to diagnose

#*****************************************************************
#   END:  GENERAL USER MODIFICATION SECTION  (Sections 1-21)
#*****************************************************************
#*****************************************************************
# BEGIN: ADVANCED USER MODIFICATION SECTION  (Sections 22-27)
#*****************************************************************
#**************************************************
# 22:  set 2 significance tests?
#**************************************************
setenv sig_lvl            0.10     # level of significance
#**************************************************
# 23:  set 2: subregion desired? (Note: DEPRECATED)
#**************************************************
setenv reg_contour   1     # (0 = SUBREGION, 1 = GLOBAL)
setenv min_lat       30.   # southern boundary in degrees north
setenv max_lat       80.   # northern boundary in degrees north
setenv min_lon       -130. # western boundary in degrees east
setenv max_lon       -50.  # eastern boundary in degrees east
setenv OBS_RES       T42   # observation resolution

#**************************************************
# 24:  turn on time stamp on bottom of plots? (Note: DEPRECATED)
#**************************************************
setenv time_stamp 0       # (1=ON,0=OFF)
#**************************************************
# 25:  Plot type 
#**************************************************
set p_type = ps          # postscript plots
#**************************************************
# 26:  creating a paleo run?
# Note that when paleo is on (1), the only sets that work currently are
# set_1, set_2, set_3, set_5, and set_6 AND only global, northern and southern
# hemisphere plots will be created for set_3 and set_6.  The other sets will be turned
# off for you if you don't have them set correctly. plotObs will also be set to off.
#**************************************************
setenv paleo            0 # (1 = use or create coastlines, 0 = OFF)
setenv land_mask1       0 # minimum land in test case (fraction 0-1)  (default=0) (DEPRECATED)
setenv land_mask2       0 # minimum land in std case (fraction 0-1) (default=0) (DEPRECATED)
setenv paleo_diff_plots 0 # make difference plots for different
                          # continental outlines  (1=ON,0=OFF)
#**************************************************
# 27:  CLAMP Diagnostic Package
# # #**************************************************
# Users need to make sure all climo files exist or will be
# created above by the Land Model Diagnostic Package.
setenv CLAMP_DIAG 0 # (1 = Run the CLAMP Diagnostic Package, 0 = OFF)

if ($regrid_file_type == "CLIMO") then
  if ($regrid_1 == 1 || $regrid_2 == 1) then
    setenv CLAMP_DIAG 0
  endif
endif

# For Model vs Obs
setenv CLAMP_SCRIPT /${DIAG_HOME}/clamp/run_1-model.csh
# For Model1 vs Model2
#setenv CLAMP_SCRIPT /${DIAG_HOME}/clamp/run_2-model.csh
 
# User defined directory name to hold Model1 vs Model2 web table
setenv MODEL_vs_MODEL clm_vs_clmpf
 
# use only "new" or "old" for energy balance variables
# "new" if NEE, NETRAD, LATENT, FSH are present in history files
setenv MODEL_TYPE1 "old"
setenv MODEL_TYPE2 "old"
 
# 0.5, 0.9, 1.9, T31, T42
setenv GRID_1 0.5
setenv GRID_2 0.5
 
# 0.5 (nlat=360,nlon=720), 0.9 (nlat=192,nlon=288), 1.9 (nlat=96,nlon=144),
# T31 (nlat=48,nlon=96)  , T42 (nlat=64,nlon=128)
setenv nlat_1 360
setenv nlon_1 720
setenv nlat_2 360
setenv nlon_2 720

#**************************************************
# END USER MODIFY SECTIONS (Sections 1-27).
#**************************************************
#**************************************************
# NO USER CHANGES AFTER THIS POINT
#**************************************************
if ($paleo == 1) then
  setenv plotObs    0   # (1 = compare to PD observations; 0 = OFF)
  setenv set_4      0   # (1=ON,0=OFF)  VERTICAL PROFILES
  setenv set_7      0   # (1=ON,0=OFF)  RIVER FLOW AND DISCHARGE
  setenv set_8      0   # (1=ON,0=OFF)  OCN-ATMOS TRACERS
  setenv set_8_lnd  0   # (1=ON,0=OFF)  LND-ATMOS TRACERS
  setenv set_9      0   # (1=ON,0=OFF)  VALIDATION DIAGNOSTICS (ONLY FOR MODEL-MODEL)
endif

if ($OBS == $ModelVsModel) then
   echo 'ERROR:  Select run type... (Model vs Obs) and (Model1 vs Model2) can not both be active.'
   exit
else if ($OBS == 1) then
   set runtype 	= model-obs     # model vs observations
else if ($ModelVsModel == 1) then
   set runtype 	= model1-model2	# two model comparison
endif

setenv PLOTTYPE         $p_type                                                 # current version: postscript
setenv RUNTYPE          $runtype						# creates directory name
setenv case_1_dir       ${SOURCE_1}/${caseid_1}/				# files for case 1
setenv case_2_dir       ${SOURCE_2}/${caseid_2}/				# files for case 2
setenv case_1_atm_dir   ${SOURCE_1}/${caseid_1}/atm/			# atm files for case 1
setenv case_2_atm_dir   ${SOURCE_2}/${caseid_2}/atm/			# atm files for case 2
setenv rtm_1            $rtm_1                                          # rtm files for case 1 
setenv rtm_2            $rtm_2                                          # rtm files for case 2 
setenv case_1_rtm_dir   ${SOURCE_1}/${caseid_1}/rof/                    # rtm files for case 1
setenv case_2_rtm_dir   ${SOURCE_2}/${caseid_2}/rof/                    # rtm files for case 2
setenv prefix_1_dir     ${PTMPDIR}/${prefix_1}/				# create separate directory for each run
setenv prefix_2_dir     ${PTMPDIR}/${prefix_2}/				# create separate directory for each run
setenv prefix_1_atm_dir ${PTMPDIR}/${prefix_1}/atm/			# atm files for case 1
setenv prefix_2_atm_dir ${PTMPDIR}/${prefix_2}/atm/			# atm files for case 2
setenv prefix_1_rtm_dir ${PTMPDIR}/${prefix_1}/rof/                     # rtm files for case 1
setenv prefix_2_rtm_dir ${PTMPDIR}/${prefix_2}/rof/                     # rtm files for case 2
setenv PROCDIR1  	${PTMPDIR}/${prefix_1}/proc/			# pre-process history files case 1
setenv PROCDIR2  	${PTMPDIR}/${prefix_2}/proc/			# pre-process history files case 2
setenv PROCDIR_ATM1  	${PTMPDIR}/${prefix_1}/atm/proc/		# pre-process history files case 1
setenv PROCDIR_ATM2  	${PTMPDIR}/${prefix_2}/atm/proc/		# pre-process history files case 2
setenv PROCDIR_RTM1     ${PTMPDIR}/${prefix_1}/rof/proc/                # pre-process history files case 1
setenv PROCDIR_RTM2     ${PTMPDIR}/${prefix_2}/rof/proc/                # pre-process history files case 2
setenv WKDIR  	        ${PTMPDIR}/${prefix_1}/${runtype}/		# diagnostic ps files 
setenv WEBDIR           ${PTMPDIR}/${prefix_1}/${prefix_1}-${prefix_2}  # webpages 
#**************************************************
# RUN THE PACKAGE ....
#**************************************************
$DIAG_HOME/code/shared/lnd_driver.csh         			# invoke the rest of the diagnostics
