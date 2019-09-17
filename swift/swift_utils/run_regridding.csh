#!/bin/csh 

# written by Sheri Mickelson
# March 2013

setenv procDir $1
setenv InFile $2
setenv method $3
setenv wgt_dir $4
setenv wgt_file $5
setenv area_dir $6
setenv area_file $7
setenv oldres $8
setenv OutFile $9
setenv DIAG_HOME $10
setenv newfn $11
set outfile_name = $12

touch temp.out

ncl < $DIAG_HOME/code/shared/se2fv_esmf.regrid2file.ncl >> temp.out
if ($status != 0)  exit

ncks -A -v area ${area_dir}/${area_file} $procDir/$OutFile
mv $procDir/$InFile $procDir/$newfn
mv $procDir/$OutFile $procDir/$InFile
ln -s $procDir/$InFile $procDir/$OutFile

cp temp.out $outfile_name

