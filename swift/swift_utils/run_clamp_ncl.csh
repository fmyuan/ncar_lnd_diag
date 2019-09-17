#!/bin/csh 

# written by Sheri Mickelson
# March 2013

set INPUT_TEXT = "$1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13 $14 $15 $16 $17 $18"
setenv ncl_filename $19 
setenv WRKDIR $20
setenv prefix $21
setenv prefix_dir $22
setenv fileno $23
setenv MODEL_vs_MODEL_n $24
setenv runtype $25
setenv prefix_1_dir $26
set outfile_name = $27

echo $PWD
mkdir $prefix
cp ${prefix_dir}/${prefix}/table.html ${prefix}/table.html
if ($runtype == "model1-model2") then
  mkdir $MODEL_vs_MODEL_n
  cp ${prefix_1_dir}/${MODEL_vs_MODEL_n}/table.html $MODEL_vs_MODEL_n/table.html
endif

touch temp.out

echo ncl $INPUT_TEXT $ncl_filename

ncl $INPUT_TEXT $ncl_filename >> temp.out

cp ${prefix}/table.html ${prefix_dir}/${prefix}/table_${fileno}.html
if ($runtype == "model1-model2") then
  cp  $MODEL_vs_MODEL_n/table.html ${prefix_1_dir}/${MODEL_vs_MODEL_n}/table_${prefix}_${fileno}.html
endif
mv M_save.* ${prefix_dir}/

cp temp.out $outfile_name

