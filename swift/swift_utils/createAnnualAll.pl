#!/usr/bin/perl

# Code copied from create_ANN_ALL in lnd_ann.pm
# Original by Nan Rosenbloom
# Modified to run with Swift by Sheri Mickelson
# March 2013

use IO::File;

$casedir = $ARGV[0];
$caseid = $ARGV[1];
$mode = $ARGV[2];
$instance = $ARGV[3];
$trends_fyr_prnt = $ARGV[4];
$prefix = $ARGV[5];
$prefixDir = $ARGV[6];
$trends_nyr = $ARGV[7];
$trends_range = $ARGV[8];
$outfile = $ARGV[9];

$NCO = "/glade/u/apps/opt/nco/4.2.0/gnu/4.4.6/bin/";
print("NCO: $NCO");

if ($mode eq "clm2") {
    $ifile = $casedir.$caseid."_annT".$instance."_".$trends_fyr_prnt.".nc";
    $ofile = $prefixDir.$prefix.$instance."_ANN_ALL.nc";
}
if ($mode eq "cam2") {
    $ifile = $casedir.$caseid."_annT_atm_".$trends_fyr_prnt.".nc";
    $ofile = $prefixDir.$prefix."_ANN_ALL_atm.nc";
}
if ($mode eq "rtm") {
    $ifile = $casedir.$caseid."_annT_rtm_".$trends_fyr_prnt.".nc";
    $ofile = $prefixDir.$prefix."_ANN_ALL_rtm.nc";
}
print("$NCO/ncrcat -\O \-n $trends_nyr,4,1 $ifile $ofile\n") if $DEBUG;
$err = system("$NCO/ncrcat  -\O \-n $trends_nyr,4,1 $ifile $ofile");  die "ANN_ALL ncrcat failed \n" if $err;
#$err = system("/bin/ls | grep ${casedir}${caseid}_'*annT*' | perl -e '$idx=1;while(<STDIN>){chop;symlink $_,sprintf("%04d.nc",$idx++);}'"); die "ANN_ALL ncrcat failed \n" if $err;
#$err = system("$NCO/ncrcat -n $trends_nyr,4,1 ${casedir}0001.nc $ofile"); die "ANN_ALL ncrcat failed \n" if $err;
#$err = system("/bin/rm ${casedir}????.nc"); die if $err;
$err = system("$NCO/ncatted \-O \-a yrs_averaged,global,c,c,$trends_range $ofile"); die  if $err;
$err = system("$NCO/ncatted \-O \-a num_yrs_averaged,global,c,i,$trends_nyr $ofile"); die  if $err;

$mfile = IO::File->new($outfile,'w');
print mfile "Complete";
close (mfile);

