#!/usr/bin/perl

# Code created by Keith Oleson
# September 2013

use IO::File;

$filelist = $ARGV[0];
$casedir = $ARGV[1];
$caseid = $ARGV[2];
$prefixDir = $ARGV[3];
$prefix = $ARGV[4];
$num_instance = $ARGV[5];
$outfile = $ARGV[6];

$NCO = "/glade/u/apps/opt/nco/4.2.0/gnu/4.4.6/bin/";
print("NCO: $NCO");

$atts = "-O -x -v ZSOI,DZSOI,WATSAT,SUCSAT,BSW,HKSAT,ZLAKE,DZLAKE,time_written,date_written,time_bounds,mcdate,mcsec,mdcur,nstep";

$ifile = $prefixDir.$prefix."_"."????".$filelist.".nc";
$ofile = $prefixDir.$prefix.$filelist.".nc";
print("$NCO/ncea $atts $ifile $ofile\n") if $DEBUG;
$err = system("$NCO/ncea $atts $ifile $ofile");  die "$f ncea failed \n" if $err;
$err = system("$NCO/ncatted \-O \-a instances_averaged,global,c,c,$num_instance $ofile"); die  if $err;

$mfile = IO::File->new($outfile,'w');
print mfile "Complete";
close (mfile);

