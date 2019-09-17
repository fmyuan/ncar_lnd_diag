#!/bin/csh 

# written by Sheri Mickelson
# March 2013

setenv first_yr $1
setenv last_yr $2
setenv nyear  $3
setenv prefix $4
setenv prefix_dir $5
setenv nlat $6
setenv nlon $7
setenv ncl_filename $8 
setenv WRKDIR $9
setenv case_dir $10
setenv caseid $11
set outfile_name = $12

set current = $PWD

cd $WRKDIR

touch $current/temp.out

echo ncl $ncl_filename

ncl $ncl_filename >> $current/temp.out

cd $current

cp $current/temp.out $outfile_name

