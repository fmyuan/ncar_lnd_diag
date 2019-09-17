#!/usr/bin/perl

# Code copied from create_SEAS_means_step0 in lnd_seas_means.pm
# Original by Nan Rosenbloom
# Modified to run with Swift by Sheri Mickelson
# March 2013

use IO::File;

$seas = $ARGV[0];
$yr = $ARGV[1];
$decFlag = $ARGV[2];
$mode = $ARGV[3];
$instance = $ARGV[4];
$procDir = $ARGV[5];
$prefix = $ARGV[6];
$weightAnnAvg = $ARGV[7];
$caseid = $ARGV[8];
$casedir = $ARGV[9];
$outfile = $ARGV[10];

print("===> createAnnualSeasonalFile .. $yr\n");

$NCO = "/glade/u/apps/opt/nco/4.2.0/gnu/4.4.6/bin/";
print("NCO: $NCO");

local($yp)  = printYear($yr);
local($ym1) = $yr-1;

$decYr = $yr - 1    if ($decFlag == 1);                # use Dec from previous yr + JanFeb from same year
$decYr = $yr        if ($decFlag == 2);                # use Dec from same year + JanFeb from following year
$decYr = $yr        if ($decFlag == 3);                # use Dec from last year + JanFeb from first year
$JanFebYr = $yr     if ($decFlag == 1);                # use JanFeb from same year + Dec from previous year
$JanFebYr = $yr + 1 if ($decFlag == 2);                # use JanFeb from following year + Dec from same year
$JanFebYr = $yr     if ($decFlag == 3);                # use JanFeb from first year + Dec from last year

$sfile = $procDir.$prefix.$instance."_".$seas."_".$yp.".nc";

print(" decFlag = $decFlag\n")  if $DEBUG;

if ( $weightAnnAvg) {
     print("Creating Weighted Annual Averages\n") if $DEBUG;
     if ($seas eq "DJF") { @months = ("-12","-01","-02"); @nd = (31,31,28); $ofile=$sfile;}
     if ($seas eq "MAM") { @months = ("-03","-04","-05"); @nd = (31,30,31); $ofile=$sfile;}
     if ($seas eq "JJA") { @months = ("-06","-07","-08"); @nd = (30,31,31); $ofile=$sfile;}
     if ($seas eq "SON") { @months = ("-09","-10","-11"); @nd = (30,31,30); $ofile=$sfile;}

     $sdays=$ctr=0;
     foreach $m (@months) {
     	if    ($m eq "-12") { $useYr = $decYr;    }
        elsif ($m eq "-01") { $useYr = $JanFebYr; }
        elsif ($m eq "-02") { $useYr = $JanFebYr; }
        else                { $useYr = $yr;       }
        $use_prnt = printYear($useYr);

        # Sum the number of days in the season
        $sdays += $nd[$ctr];

        $ifile   = $casedir.$caseid.".".$mode.$instance.".h0.".$use_prnt.$m.".nc";
        print("useYr = $useYr\n");
        #if ($decFlag == 1) {  &getDec(      $useYr) if ( ! -e $ifile); }
        #if ($decFlag == 2) {  &getJanFeb($use_prnt) if ( ! -e $ifile); }
        $out     = $prefix.$instance.".t1".".nc";
        $tmpfile = $prefix.$instance.".t2".".nc";

        if ($ctr == 0) {
       		 system("cp $ifile $tmpfile");
                 $wt1 = 0.0;
                 # if ($mode eq "clm2") { $atts = "-O -x -v ZSOI,DZSOI,WATSAT,SUCSAT,BSW,HKSAT,ZLAKE,DZLAKE,time_written,date_written,mcdate,mcsec,mscur,mdcur,nstep,pftmask"; }
                 if ($mode eq "clm2") { $atts = "-O -x -v ZSOI,DZSOI,WATSAT,SUCSAT,BSW,HKSAT,ZLAKE,DZLAKE,time_written,date_written,mcdate,mcsec,mdcur,nstep"; }
                 if ($mode eq "cam2") { $atts = "-O -x -v time_written,date_written,nbdate,date,nsteph"; }
                 if ($mode eq "rtm")  { $atts = "-O -x -v time_written,date_written,fthresh"; }
        }
        else {
                 system("mv $out $tmpfile");
                 $wt1 = 1.0;
                 $atts = "-O ";
        }
        $wt2 = $nd[$ctr];
        $weights = "-w $wt1,$wt2";
        print("$NCO/ncflint $atts $weights $tmpfile $ifile $out\n"); 
        $err = system("$NCO/ncflint $atts $weights $tmpfile $ifile $out\n"); die "seasonal ncflint failed \n" if $err;
        $ctr++;
     }
     $wt1 = 1./$sdays;               # divide by number of days in the season
     $wt2 = 0.0;
     system("mv $out $tmpfile");
     $weights = "-w $wt1,$wt2";
     print("$NCO/ncflint -O $weights $tmpfile $tmpfile $ofile\n");
     $err = system("$NCO/ncflint -O $weights $tmpfile $tmpfile $ofile");
}  else {
     if ($seas eq "DJF") {
        $ctr=0; foreach $m ("-12","-01","-02") {
     	  if    ($m eq "-12") { $useYr = $decYr;    }
     	  elsif ($m eq "-01") { $useYr = $JanFebYr; }
     	  elsif ($m eq "-02") { $useYr = $JanFebYr; }
     	  $use_prnt = printYear($useYr);
     	  @seasA[$ctr] = $casedir.$caseid.".".$mode.$instance.".h0.".$use_prnt.$m.".nc";
     	  if ($decFlag == 1) {  &getDec(      $useYr) if ( ! -e @seasA[$ctr]); }
     	  if ($decFlag == 2) {  &getJanFeb($use_prnt) if ( ! -e @seasA[$ctr]); }
     	  $ctr++;
        }
     }
     if ($seas eq "MAM") {$ctr=0; foreach $m ("-03","-04","-05") { @seasA[$ctr] = $casedir.$caseid.".".$mode.$instance.".h0.".$yp.$m.".nc"; $ctr++; }}
     if ($seas eq "JJA") {$ctr=0; foreach $m ("-06","-07","-08") { @seasA[$ctr] = $casedir.$caseid.".".$mode.$instance.".h0.".$yp.$m.".nc"; $ctr++; }}
     if ($seas eq "SON") {$ctr=0; foreach $m ("-09","-10","-11") { @seasA[$ctr] = $casedir.$caseid.".".$mode.$instance.".h0.".$yp.$m.".nc"; $ctr++; }}

     # if ($mode eq "clm2") { $atts = "time_written,date_written,mcdate,mcsec,nstep,mdcur,pftmask"; }
     if ($mode eq "clm2") { $atts = "time_written,date_written,mcdate,mcsec,nstep,mdcur"; }
     if ($mode eq "cam2") { $atts = "time_written,date_written,nbdate,date,nsteph"; }
     if ($mode eq "rtm")  { $atts = "time_written,date_written"; }
     $flags = "-O -x -v";

     print("$NCO/ncra  $flags $atts @seasA $sfile\n");

     $err = system("$NCO/ncra $flags $atts @seasA $sfile"); die "ncra failed \n" if $err;

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

sub getDec
{
        $mydir = `pwd`;
        chdir("$casedir");

        $err = 0;
        local($y) = @_;
        local $yp = printYear($y);
        print("==> Processing getDec  for year=$yp\n") if ($DEBUG);
        print("==> getLocalFlag = $localFlag\n") if ($DEBUG);
        print("==> mss_tarfile = $MSS_tarfile\n") if ($DEBUG);
        if ( $localFlag) { getLocal($yp); }
        else {
          if ($MSS_tarfile == 0) {
                print("Retrieving Dec \[Y=$yp\] from HPSS -- \n");
                $filename = $caseid.".".$mode.$instance.".h0.".$yp."-12.nc";
                $err = system("hsi -P \'get $MSS_path\/$filename\' ");
                print "HPSS file does not exist:  $filename \n\n" if $err;
          } else {
                if ($y > 0) {
                        print("Retrieving Dec \[Y=$yp\] from HPSS -- \n");
                        $filename = $caseid.".".$mode.$instance.".h0.".$yp.".tar";
                        $err = system("hsi -P \'get $MSS_path\/$filename\' ");
                        if ($err) { print "HPSS file does not exist:  $filename \n\n"; }
                        else {
                                system("tar -xvf $filename");
                                system("rm $filename");
                        }
                } else { print "HPSS file for year $yp does not exist:  $filename \n\n"; return(-1); }
           }
        }
        $err = 0;
        $fname = $casedir.$filename;
        chdir("$mydir");
        return(-1)    if !-e $fname || -z $fname;
}
sub getJanFeb
{
        $mydir = `pwd`;
        chdir("$casedir");

        print("==> Processing getJanFeb \n") if ($DEBUG);
        local($yp) = @_;
        if ( $localFlag) { getLocal($yp); }
        else {
          if ($MSS_tarfile == 0) {
                print("Retrieving JanFeb \[Y=$yp\] from HPSS --  \n");
                $filename = $caseid.".".$mode.$instance.".h0.".$yp;
                $fname    = $casedir.$caseid.".".$mode.$instance.".h0.".$yp."-01.nc";
                $err = system("hsi -P \'get $MSS_path\/$filename\' ");
                print "HPSS file does not exist:  $filename \n\n" if $err;
          } else {
                print("Retrieving JanFeb \[Y=$yp\] from HPSS --  \n");
                $filename = $caseid.".".$mode.$instance.".h0.".$yp.".tar";
                $err = system("hsi -P \'get $MSS_path\/$filename\' ");
                if (!$err) {
                        system("tar -xvf $filename");
                        system("rm $filename");
                 } else { print "HPSS file for year $yp does not exist:  $filename \n\n"; }
           }
        }
        $err = 0;
        chdir("$mydir");
        return(-1)    if !-e $fname || -z $fname;
}
