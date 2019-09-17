#!/usr/bin/perl

# Code copied from create_MONS_climo_step2 in lnd_mons.pm
# Original by Nan Rosenbloom
# Modified to run with Swift by Sheri Mickelson
# March 2013

use IO::File;

$m = $ARGV[0];
$procDir = $ARGV[1];
$mode = $ARGV[2];
$instance = $ARGV[3];
$caseid = $ARGV[4];
$prefix = $ARGV[5];
$outfile = $ARGV[6];

print(" START ------create_MONS_climo_step2 \n");
print("Processing MONS climo (Climo) - Step 2\n");

$NCO = "/glade/u/apps/opt/nco/4.2.0/gnu/4.4.6/bin/";
print("NCO: $NCO");

$lnd_monsDir = $procDir."\/lnd_monsDir\/";


# -- exclude time variables that overrun in flint operation
if ($mode eq "clm2") { $atts = "-O -x -v ZSOI,DZSOI,WATSAT,SUCSAT,BSW,HKSAT,ZLAKE,DZLAKE,mcdate,mcsec,mdcur,mscur,nstep"; }
if ($mode eq "cam2") { $atts = "-O -x -v nbdate,date,nsteph"; }
if ($mode eq "rtm") { $atts = "-O -x -v fthresh"; }

# Create monthly averages
print("Starting the month list in create_SEAS_climo_step1\n") if $DEBUG;

$ifile = $lnd_monsDir.$caseid.".".$mode.$instance.".h0.????".$m.".nc";
$ofile = $lnd_monsDir.$prefix.$instance.".climo".$m.".nc";
print( "processing $ifile to $ofile\n");
print("$NCO/ncra $atts $ifile $ofile\n"); 
$err = system("$NCO/ncra $atts $ifile $ofile\n");  die "ncra climo failed\n" if $err;


$mfile = IO::File->new($outfile,'w');
print mfile "Complete";
close (mfile);
