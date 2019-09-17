#!/bin/csh

# written by Sheri Mickelson
# March 2013

set comp_dir = $25/$20/
set comp_dirQ = \"$comp_dir\"

setenv prefix_dir $19 
setenv MODEL_vs_MODEL $20
setenv DIAG_SHARED $21
setenv prefix $22
setenv WKDIR $23
setenv DIAG_HOME $24
setenv prefix_1_dir $25
setenv model_model $26
setenv file_name $27

if ($model_model == 1) then
  set INPUT_TEXT_1 = "$1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13 $14 $15 $16 $17 compare=$comp_dirQ"
else
  set INPUT_TEXT_1 = "$1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13 $14 $15"
endif

setenv current $PWD

cd ${prefix_dir}/${prefix}
echo $PWD
$DIAG_SHARED/mergeall.sh table.html `ls ${prefix_dir}/${prefix}/table_*.html`
mv new.html table.html
rm -f ${prefix_dir}/${prefix}/table_*.html

if ($model_model == 1) then
  cd ${prefix_1_dir}/${MODEL_vs_MODEL}
  echo $PWD
  $DIAG_SHARED/mergeall.sh table.html `ls ${prefix_1_dir}/${MODEL_vs_MODEL}/table_${prefix}*.html`
  mv new.html table.html
endif

cd ${prefix_dir}
ncl  $INPUT_TEXT_1 $DIAG_HOME/clamp/99.final.ncl

cd $current

printf "COMPLETE" > $file_name

