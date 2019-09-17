#!/usr/bin/perl

# Code copied from create_MONS_climo_step2 in lnd_mons.pm
# Original by Nan Rosenbloom
# Modified to run with Swift by Sheri Mickelson
# March 2013

use IO::File;

$procDir = $ARGV[0];
$prefix = $ARGV[1];
$mode = $ARGV[2];
$instance = $ARGV[3];
$prefixDir = $ARGV[4];
$clim_range = $ARGV[5];
$clim_nyr = $ARGV[6];
$outfile = $ARGV[7];

print(" START ------create_MONS_climo_step2 \n");
print("Processing MONS climo (Climo) - Step 2\n");

$NCO = "/glade/u/apps/opt/nco/4.2.0/gnu/4.4.6/bin/";
print("NCO: $NCO");

$lnd_monsDir = $procDir."\/lnd_monsDir\/";

$ifile = $lnd_monsDir.$prefix.$instance.".climo-??.nc";
if ($mode eq "clm2") { $ofile = $prefixDir.$prefix.$instance."_MONS_climo.nc"; }
if ($mode eq "cam2") { $ofile = $prefixDir.$prefix.$instance."_MONS_climo_atm.nc"; }
if ($mode eq "rtm")  { $ofile = $prefixDir.$prefix.$instance."_MONS_climo_rtm.nc"; }

print("$NCO/ncrcat \-O  $ifile $ofile\n") if $DEBUG;
$err = system("$NCO/ncrcat \-O  $ifile $ofile");  die "MONS_climo ncrcat failed \n" if $err;
$err = system("$NCO/ncatted \-O \-a yrs_averaged,global,c,c,$clim_range $ofile"); die  if $err;
$err = system("$NCO/ncatted \-O \-a num_yrs_averaged,global,c,i,$clim_nyr $ofile"); die  if $err;
print(" Cleaning up $lnd_monsDir directory\n");
#print(" rm -r $lnd_monsDir\n");
#system("rm -r $lnd_monsDir");
print(" END  ------create_MONS_climo_step2 \n");


$mfile = IO::File->new($outfile,'w');
print mfile "Complete";
close (mfile);
