#!/usr/bin/perl

# Code copied from create_SEAS_climo_step1 in lnd_seas_climo.pm
# Original by Nan Rosenbloom
# Modified to run with Swift by Sheri Mickelson
# March 2013

use IO::File;

$mode = $ARGV[0];
$instance = $ARGV[1];
$clim_fyr = $ARGV[2];
$clim_lyr = $ARGV[3];
$decFlag = $ARGV[4];
$procDir = $ARGV[5];
$casedir = $ARGV[6];
$caseid = $ARGV[7];
$outfile = $ARGV[8];

  #  D/JF --------------------------------------D/JF
  #   /clim_fyr--------------------------clim_lyr/
  # Options:
  #  1.  if dec of previous year (clim_fyr-1) exists, use it to create DJF.  Dec:  fyr-1 thru lyr-1 JanFeb: fyr   thru lyr
  #  2.  else, use JanFeb from year following last year (clim_lyr+1).        Dec:  fyr   thru lyr   JanFeb: fyr+1 thru lyr+1
  #  3.  else, use JanFeb from fyr-lyr and use dec from fyr-lyr inclusive.   Dec:  fyr   thru lyr   JanFeb: fyr thr lyr  **
  #     ** Note:  Times will not be monotonic

  local($yp)  = printYear($clim_fyr);
  local($ym1) = $clim_fyr-1;

  $decYr = $clim_fyr - 1    if ($decFlag == 1);                # use Dec from fyr-1 + JanFeb from fyr
  $decYr = $clim_lyr        if ($decFlag == 2);                # use Dec from last year + JanFeb from following year
  $decYr = $clim_lyr        if ($decFlag == 3);                # use Dec from last year + JanFeb from first year
  $JanFebYr = $clim_fyr     if ($decFlag == 1);                # use JanFeb from same year + Dec from previous year
  $JanFebYr = $clim_lyr + 1 if ($decFlag == 2);                # use JanFeb from following year + Dec from same year
  $JanFebYr = $clim_fyr     if ($decFlag == 3);                # use JanFeb from first year + Dec from last year

  print("decFlag = $decFlag + decYr = $decYr and JanFebYr = $JanFebYr\n");

  print ("mkdir $procDir\/lnd_seas_climoDir\/\n");
  system("mkdir $procDir\/lnd_seas_climoDir\/");
  $lnd_seas_climoDir = $procDir."\/lnd_seas_climoDir\/";

  # Get december for DJF
  $useYr = $decYr;
  $use_prnt = printYear($useYr);
  $ifile = $casedir.$caseid.".".$mode.$instance.".h0.".$use_prnt."-12.nc";
  print(" grabbing december for year:  $use_prnt\n");
  print(" ln -s $ifile $lnd_seas_climoDir\n");
  $err = system("ln -s $ifile $lnd_seas_climoDir\/.\n");

  # Get Janurary, Feb for DJF
  $useYr = $JanFebYr;
  $use_prnt = printYear($useYr);

  print(" grabbing Jan/Feb for year:  $useYr\n");
  $ifile = $casedir.$caseid.".".$mode.$instance.".h0.".$use_prnt."-01.nc";
  print(" ln -s $ifile $lnd_seas_climoDir\n");
  $err = system("ln -s $ifile $lnd_seas_climoDir\/.\n");

  $ifile = $casedir.$caseid.".".$mode.$instance.".h0.".$use_prnt."-02.nc";
  print(" ln -s $ifile $lnd_seas_climoDir\n");
  $err = system("ln -s $ifile $lnd_seas_climoDir\/.\n");

  # soft link climo files in proc dir so we can use wildcard ncra
  $ctr=0;
  $yrct = $clim_fyr;
  while ($yrct <= $clim_lyr) {
        $use_prnt = printYear($yrct);
        $ifile = $casedir.$caseid.".".$mode.$instance.".h0.".$use_prnt."-??.nc";
        print(" ln -s $ifile $lnd_seas_climoDir\n");
        $err = system("ln -s $ifile $lnd_seas_climoDir\/.\n");
        $yrct++;
  }
  # Now remove the last december if I have the PRIOR december for DJF
  # file name of PRIOR december
  if ($decFlag == 1 ) {
        $useYr = $clim_fyr-1;
        $use_prior = printYear($useYr);
        $priorDec = $lnd_seas_climoDir.$caseid.".".$mode.$instance.".h0.".$use_prior."-12.nc";
        print("priorDec = $priorDec\n");

        # file name of last year december
        $useYr = $clim_lyr;
        $use_last = printYear($useYr);
        $lastDecember = $lnd_seas_climoDir.$caseid.".".$mode.$instance.".h0.".$use_last."-12.nc";
        print("lastDec = $lastDecember\n");

        if (-e $priorDec) {
                print(" Removing  LAST YEAR Dec  for year:  $use_last because PRIOR Dec  exists for year $use_prio\n");
                print(" rm $lastDecember \n");
                $err = system("rm $lastDecember \n");
        }
  }

  # Now remove the first Jan-Feb if I have the Following year for DJF
  if ($decFlag == 2 ) {
        $useYr = $clim_fyr;
        $use_prior = printYear($useYr);
        $firstJan = $lnd_seas_climoDir.$caseid.".".$mode.$instance.".h0.".$use_prior."-01.nc";
        $firstFeb = $lnd_seas_climoDir.$caseid.".".$mode.$instance.".h0.".$use_prior."-02.nc";

        # file name of following year Jan-Feb
        $useYr = $clim_lyr+1;
        $use_last = printYear($useYr);
        $lastJan = $lnd_seas_climoDir.$caseid.".".$mode.$instance.".h0.".$use_last."-01.nc";
        $lastFeb = $lnd_seas_climoDir.$caseid.".".$mode.$instance.".h0.".$use_last."-02.nc";
        print("lastJan = $lastJan\n");
        print("lastFeb = $lastFeb\n");

        if (-e $lastJan) {
                print(" Removing  first Jan  for year:  $use_prior because following Jan exists for year $use_last\n");
                print(" rm $firstJan \n");
                $err = system("rm $firstJan \n");
        }
        if (-e $lastFeb) {
                print(" Removing  first Feb  for year:  $use_prior because following Feb exists for year $use_last\n");
                print(" rm $firstFeb \n");
                $err = system("rm $firstFeb \n");
        }
  }


$mfile = IO::File->new($outfile,'w');
print mfile "Complete";
close (mfile);

sub printYear
{
  local($iyr) = @_;
  if    ($iyr <    10)                { $y = "000".$iyr; }
  elsif ($iyr >=   10 && $iyr <  100) { $y =  "00".$iyr; }
  elsif ($iyr >=  100 && $iyr < 1000) { $y =   "0".$iyr; }
  elsif ($iyr >= 1000)                { $y =       $iyr; }
  return($y);
}

