#!/bin/csh 

# written by Sheri Mickelson
# March 2013

setenv CASA $1
setenv caseid_1 $2
setenv CLAMP $3
setenv clim_first_yr_1 $4
setenv clim_num_yrs_1 $5
setenv CN $6
setenv commonName_1 $7
setenv DIAG_CODE $8
setenv DIAG_HOME $9
setenv DIAG_RESOURCES $10
setenv DIAG_VERSION $11
setenv expContours $12
setenv HYDRO $13
setenv INPUT_FILES $14
setenv land_mask1 $15
setenv min_lat $16
setenv min_lon $17
setenv OBS_DATA $18
setenv OBS_RES $19
setenv paleo $20
setenv PLOTTYPE $21
setenv prefix_1 $22
setenv PTMPDIR $23
setenv raster $24
setenv reg_contour $25
setenv rtm_1 $26
setenv sig_lvl $27
setenv trends_first_yr_1 $28
setenv trends_num_yrs_1 $29
setenv UseCommonName_1 $30
setenv WKDIR $31
setenv ncl_filename $32
setenv season $33
setenv projection $34
setenv colormap $35
setenv density $36
setenv DIAG_SHARED $37
setenv NCARG_ROOT $38 
set outfile_name = $39


touch temp.out

ncl <  $ncl_filename >> temp.out
if ($status != 0)  exit

cp temp.out $outfile_name

