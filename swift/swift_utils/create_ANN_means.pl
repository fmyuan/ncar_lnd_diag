#!/usr/bin/perl

# Code copied from create_ANN_means in lnd_ann.pm
# Original by Nan Rosenbloom
# Modified to run with Swift by Sheri Mickelson
# March 2013

use IO::File;

$mode = $ARGV[0];
$instance = $ARGV[1];
$casedir = $ARGV[2];
$caseid = $ARGV[3];
$clim_fyr_prnt = $ARGV[4];
$prefixDir = $ARGV[5];
$prefix = $ARGV[6];
$clim_nyr = $ARGV[7];
$clim_range = $ARGV[8];
$outfile = $ARGV[9];

print("Processing ANN_means (Climo)\n");

$NCO = "/glade/u/apps/opt/nco/4.2.0/gnu/4.4.6/bin/";
print("NCO: $NCO");

system("/usr/bin/rm -f *.tmp") if (-e "*.tmp");

if ($mode eq "clm2") {
    $ifile = $casedir.$caseid."_annT".$instance."_".$clim_fyr_prnt.".nc";
    $ofile = $prefixDir.$prefix.$instance."_ANN_means.nc";
}
if ($mode eq "cam2") {
    $ifile = $casedir.$caseid."_annT_atm_".$clim_fyr_prnt.".nc";
    $ofile = $prefixDir.$prefix."_ANN_means_atm.nc";
}
if ($mode eq "rtm") {
    $ifile = $casedir.$caseid."_annT_rtm_".$clim_fyr_prnt.".nc";
    $ofile = $prefixDir.$prefix."_ANN_means_rtm.nc";
}
print("$NCO/ncrcat -\O \-n $clim_nyr,4,1 $ifile $ofile\n") if $DEBUG;
$err = system("$NCO/ncrcat -\O \-n $clim_nyr,4,1 $ifile $ofile");  die "ANN_means ncrcat failed \n" if $err;

$err = system("$NCO/ncatted \-O \-a yrs_averaged,global,c,c,$clim_range $ofile"); die  if $err;
$err = system("$NCO/ncatted \-O \-a num_yrs_averaged,global,c,i,$clim_nyr $ofile"); die  if $err;

if ( $weightAnnAvg)
   { $wtFlag = "\"annual means computed from monthly means with months weighted by number of days in month\""; }
else    { $wtFlag = "\"annual means computed from monthly means with all months weighted equally\""; }

$err = system("$NCO/ncatted \-O \-a weighted_avg,global,c,c,$wtFlag $ofile"); die  if $err;


$mfile = IO::File->new($outfile,'w');
print mfile "Complete";
close (mfile);
