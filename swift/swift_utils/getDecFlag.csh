#!/bin/csh -f

# written by Sheri Mickelson
# March 2013

set clim_fyr = $1
set clim_lyr = $2
set casedir = $3
set caseid = $4
set mode = $5
set instance = $6
set localFlag = $7
set MSS_tarfile = $8
set MSS_path = $9
set localDir = $10
set local_link = $11
set DIAG_HOME = $12
set outfile = $13

set mydir = `pwd`
cd $casedir

cd $mydir

  @ ym1 = $clim_fyr - 1
  @ yp1 = $clim_lyr + 1
  set yr = `printf "%04d" $ym1`
  set fn = $casedir$caseid"."$mode$instance".h0."$yr"-12.nc"
  if (-e $fn || -z $fn)then
    set decFlag = 1
    echo "FOUND:  Dec "$ym1
  else
    $DIAG_HOME/swift/swift_utils/checkDJF.csh $casedir $ym1 $localFlag $MSS_tarfile $mode $instance $MSS_path
      $localDir $local_link 12
    if (-e $fn || -z $fn)then
      set decFlag = 1
      echo "FOUND:  Dec "$ym1
    else
      set yr = `printf "%04d" $yp1`
      set fn = $casedir$caseid"."$mode$instance".h0."$yr"-01.nc"
      if (-e $fn || -z $fn)then
        set decFlag = 2
        echo "FOUND:  Jan+Feb "$yp1
      else
        $DIAG_HOME/swift/swift_utils/checkDJF.csh $casedir $yp1 $localFlag $MSS_tarfile $mode $instance $MSS_path
          $localDir $local_link 1
        set fn = $casedir$caseid"."$mode$instance".h0."$yr"-01.nc"
        if (-e $fn || -z $fn)then
          set decFlag = 2
          echo "FOUND:  Jan+Feb "$yp1
        else
          set decFlag = 3
          echo "NOTE: DJF uses DEC "$clim_lyr " + JanFeb "$clim_fyr
          echo "NOTE:  TIMES MAY NOT INCREASE MONOTONICALLY"
        endif
      endif
    endif
  endif

  printf $decFlag > $outfile

