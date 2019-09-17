#!/usr/bin/perl

# Code copied from create_SEAS_climo_step1 in lnd_seas_climo.pm
# Original by Nan Rosenbloom
# Modified to run with Swift by Sheri Mickelson
# March 2013

use IO::File;

$mode = $ARGV[0];
$instance = $ARGV[1];
$procDir = $ARGV[2];
$caseid = $ARGV[3];
$m = $ARGV[4];
$prefix = $ARGV[5];
$outfile = $ARGV[6];

$NCO = "/glade/u/apps/opt/nco/4.2.0/gnu/4.4.6/bin/";
print("NCO: $NCO");

$lnd_seas_climoDir = $procDir."\/lnd_seas_climoDir\/";

# -- exclude time variables that overrun in flint operation
# if ($mode eq "clm2") { $atts = "-O -x -v mcdate,mcsec,mdcur,mscur,nstep,pftmask,indxupsc"; }
if ($mode eq "clm2") { $atts = "-O -x -v ZSOI,DZSOI,WATSAT,SUCSAT,BSW,HKSAT,ZLAKE,DZLAKE,mcdate,mcsec,mdcur,mscur,nstep"; }
if ($mode eq "cam2") { $atts = "-O -x -v nbdate,date,nsteph"; }
if ($mode eq "rtm") {$atts = "-O -x -v fthresh"; }

$ifile = $lnd_seas_climoDir.$caseid.".".$mode.$instance.".h0.????".$m.".nc";
$ofile = $procDir.$prefix.$instance.".climo".$m.".nc";
print( "processing $ifile to $ofile\n");
if ($DEBUG) { print("$NCO/ncra $atts $ifile $ofile\n"); }
$err = system("$NCO/ncra $atts $ifile $ofile\n");  die "ncra climo failed\n" if $err;

$mfile = IO::File->new($outfile,'w');
print mfile "Complete";
close (mfile);
