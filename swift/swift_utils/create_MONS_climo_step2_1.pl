#!/usr/bin/perl

# Code copied from create_MONS_climo_step2 in lnd_mons.pm
# Original by Nan Rosenbloom
# Modified to run with Swift by Sheri Mickelson
# March 2013

use IO::File;

$procDir = $ARGV[0];
$clim_fyr = $ARGV[1];
$clim_lyr = $ARGV[2];
$casedir = $ARGV[3];
$caseid = $ARGV[4];
$mode = $ARGV[5];
$instance = $ARGV[6];
$outfile = $ARGV[7];

print(" START ------create_MONS_climo_step2 \n");
print("Processing MONS climo (Climo) - Step 2\n");

print ("mkdir $procDir\/lnd_monsDir\/\n");
system("mkdir $procDir\/lnd_monsDir\/");
$lnd_monsDir = $procDir."\/lnd_monsDir\/";

# soft link climo files in proc dir so we can use wildcard ncra
$ctr=0;
$yrct = $clim_fyr;
while ($yrct <= $clim_lyr) {
       $use_prnt = printYear($yrct);
       $ifile = $casedir.$caseid.".".$mode.$instance.".h0.".$use_prnt."-??.nc";
       print(" ln -s $ifile $lnd_monsDir\n");
       $err = system("ln -s $ifile $lnd_monsDir\/.\n");
       $yrct++;
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
