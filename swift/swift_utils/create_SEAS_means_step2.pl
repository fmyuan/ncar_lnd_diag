#!/usr/bin/perl

# Code copied from create_SEAS_means_step2 in lnd_seas_means.pm 
# Original by Nan Rosenbloom
# Modified to run with Swift by Sheri Mickelson
# March 2013

use IO::File;

$seas = $ARGV[0];
$procDir = $ARGV[1]; 
$prefix = $ARGV[2];
$weightAnnAvg = $ARGV[3];
$clim_lyr = $ARGV[4];
$casedir = $ARGV[5];
$caseid = $ARGV[6];
$mode = $ARGV[7];
$instance = $ARGV[8];
$prefixDir = $ARGV[9];
$outfile = $ARGV[10];

print("Concatenating SEASONAL Means\n");

$NCO = "/glade/u/apps/opt/nco/4.2.0/gnu/4.4.6/bin/";
print("NCO: $NCO");

$ifile = $procDir.$prefix.$instance."_".$seas."_????.nc";

if ($mode eq "clm2") {
    $ofile = $prefixDir.$prefix.$instance."_".$seas."_means.nc";
}
if ($mode eq "cam2") {
    $ofile = $prefixDir.$prefix."_".$seas."_means_atm.nc";
}
if ($mode eq "rtm") {
    $ofile = $prefixDir.$prefix."_".$seas."_means_rtm.nc";
}
$err = system("$NCO/ncrcat \-O $ifile $ofile"); die  if $err;

system("$NCO/ncatted \-O \-a yrs_averaged,global,c,c,$clim_range $ofile"); 

system("$NCO/ncatted \-O \-a num_yrs_averaged,global,c,i,$clim_nyr $ofile");
if ( $weightAnnAvg)
        { $wtFlag = "\"annual means computed from monthly means with months weighted by number of days in month\""; }
else    { $wtFlag = "\"annual means computed from monthly means with all months weighted equally\""; }

system("$NCO/ncatted \-O \-a weighted_avg,global,c,c,$wtFlag $ofile"); 
# ... nanr 8/24/07
# Prob:  Landmask is set to 0 by averaging process.  (this only affects set9, but is still misleading.    
# Soln:  Remove bad landmask and overwrite landmask directly from a history file. 
if ($mode eq "clm2") {
    $yr_prnt = printYear($clim_lyr);
    $usefile = $casedir.$caseid.".".$mode.$instance.".h0.".$yr_prnt."-01.nc";
    $lmask   = $procDir.$prefix.$instance.".lmask.nc";
    system("$NCO/ncks -O -v landmask $usefile $lmask") if !-e $lmask;
    system("$NCO/ncks -O -q \-A -v landmask $lmask $ofile");
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
