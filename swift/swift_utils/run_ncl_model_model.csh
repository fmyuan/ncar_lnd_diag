#!/bin/csh 

# written by Sheri Mickelson
# March 2013

setenv CASA $1
setenv caseid_1 $2
setenv caseid_2 $3
setenv CLAMP $4
setenv clim_first_yr_1 $5
setenv clim_first_yr_2 $6
setenv clim_num_yrs_1 $7
setenv clim_num_yrs_2 $8
setenv CN $9
setenv commonName_1 $10
setenv commonName_2 $11
setenv COMPARE $12
setenv debugFlag $13
setenv DIAG_CODE $14
setenv DIAG_HOME $15
setenv DIAG_RESOURCES $16
setenv DIAG_VERSION $17
setenv expContours $18
setenv HYDRO $19
setenv INPUT_FILES $20
setenv land_mask1 $21
setenv min_lat $22
setenv min_lon $23
setenv OBS_DATA $24
setenv OBS_RES $25
setenv paleo $26
setenv plotObs $27
setenv PLOTTYPE $28
setenv prefix_1 $29
setenv prefix_2 $30
setenv PTMPDIR $31
setenv raster $32
setenv reg_contour $33
setenv rtm_1 $34
setenv rtm_2 $35
setenv sig_lvl $36
setenv trends_first_yr_1 $37
setenv trends_first_yr_2 $38
setenv trends_match_Flag $39
setenv trends_match_yr_1 $40
setenv trends_match_yr_2 $41
setenv trends_num_yrs_1 $42
setenv trends_num_yrs_2 $43
setenv UseCommonName_1 $44
setenv UseCommonName_2 $45
setenv WKDIR $46
setenv ncl_filename $47
setenv season $48
setenv projection $49
setenv colormap $50
setenv density $51
setenv DIAG_SHARED $52
setenv NCARG_ROOT $53
set outfile_name = $54

touch temp.out

ncl < $ncl_filename >> temp.out
if ($status != 0)  exit

cp temp.out $outfile_name

