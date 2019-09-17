#!/usr/bin/perl

# Code copied from create_SEAS_climo_step2 in lnd_seas_climo.pm
# Original by Nan Rosenbloom
# Modified to run with Swift by Sheri Mickelson
# March 2013

use IO::File;

$seas = $ARGV[0];
$mode = $ARGV[1];
$instance = $ARGV[2];
$casedir = $ARGV[3];
$caseid = $ARGV[4];
$prefixDir = $ARGV[5];
$prefix = $ARGV[6];
$clim_nyr = $ARGV[7];
$clim_range = $ARGV[8];
$weightAnnAvg = $ARGV[9];
$procDir = $ARGV[10];
$outfile = $ARGV[11];

print(" start ----  create_SEAS_climo_step2:   \[Y=$yr\]\n") ;
print("Processing SEASONAL Climo files (Climo) \n");

$NCO = "/glade/u/apps/opt/nco/4.2.0/gnu/4.4.6/bin/";
print("NCO: $NCO");

if ($mode eq "clm2") {
    $ofile = $prefixDir.$prefix.$instance."_".$seas."_climo.nc";
}
if ($mode eq "cam2") {
    $ofile = $prefixDir.$prefix."_".$seas."_climo_atm.nc";
}
if ($mode eq "rtm") {
    $ofile = $prefixDir.$prefix."_".$seas."_climo_rtm.nc";
}
print(" rm -f $ofile") if -e $ofile;
system("rm -f $ofile") if -e $ofile;

system("/usr/bin/rm -f *.tmp") if -e "*.tmp";
if ( $weightAnnAvg) {
     if ($seas eq "DJF") { @months = ("-12","-01","-02"); @nd = (31,31,28); $ofile=$ofile;}
     if ($seas eq "MAM") { @months = ("-03","-04","-05"); @nd = (31,30,31); $ofile=$ofile;}
     if ($seas eq "JJA") { @months = ("-06","-07","-08"); @nd = (30,31,31); $ofile=$ofile;}
     if ($seas eq "SON") { @months = ("-09","-10","-11"); @nd = (30,31,30); $ofile=$ofile;}

     $sdays=$ctr=0;
     foreach $m (@months) {

        # Sum the number of days in the season
        $sdays += $nd[$ctr];

        $ifile   = $procDir.$prefix.$instance.".climo".$m.".nc";
        $out     = $prefix.$instance.".t1".".nc";
        $tmpfile = $prefix.$instance.".t2".".nc";
        if ($ctr == 0) {
            system("cp $ifile $tmpfile");
            $wt1 = 0.0;
            $atts = "-O -x -v time_written,date_written";
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
     print("$NCO/ncflint \-O $weights $tmpfile $tmpfile $ofile\n");
     $err = system("$NCO/ncflint \-O $weights $tmpfile $tmpfile $ofile");

     print(" rm $out $tmpfile\n");
     system("rm $out $tmpfile");
}  else {
     $ctr=0; foreach $m ("-12","-01","-02") { @seasFiles[$ctr] = $procDir.$prefix.$instance.".climo".$m.".nc"; $ctr++; }
     $ctr=0; foreach $m ("-03","-04","-05") { @seasFiles[$ctr] = $procDir.$prefix.$instance.".climo".$m.".nc"; $ctr++; }
     $ctr=0; foreach $m ("-06","-07","-08") { @seasFiles[$ctr] = $procDir.$prefix.$instance.".climo".$m.".nc"; $ctr++; }
     $ctr=0; foreach $m ("-09","-10","-11") { @seasFiles[$ctr] = $procDir.$prefix.$instance.".climo".$m.".nc"; $ctr++; }

     $flags = "-O -x -v date_written,time_written";

     print("$NCO/ncra $flags @seasFiles $ofile\n");

     $err = system("$NCO/ncra $flags @seasFiles $ofile"); die "SEAS_climo ".$seas." failed \n" if $err;
}
$err = system("$NCO/ncatted \-O \-a yrs_averaged,global,c,c,$clim_range $ofile"); die  if $err;

$err = system("$NCO/ncatted \-O \-a num_yrs_averaged,global,c,i,$clim_nyr $ofile"); die  if $err;

if ( $weightAnnAvg)
        { $wtFlag = "\"annual means computed from monthly means with months weighted by number of days in month\""; }
else    { $wtFlag = "\"annual means computed from monthly means with all months weighted equally\""; }

$err = system("$NCO/ncatted \-O \-a weighted_avg,global,c,c,$wtFlag $ofile"); die  if $err;
# ... nanr 8/24/07
# Prob:  Landmask is set to 0 by averaging process.  (this only affects set9, but is still misleading.    
# Soln:  Remove bad landmask and overwrite landmask directly from a history file. 
if ($mode eq "clm2") {
    $yr_prnt = printYear($clim_lyr);
    $usefile = $casedir.$caseid.".".$mode.$instance.".h0.".$yr_prnt."-01.nc";
    $lmask   = $procDir.$prefix.$instance.".lmask.nc";
    system("$NCO/ncks \-O -v landmask $usefile $lmask") if !-e $lmask;
    system("$NCO/ncks \-O -q \-A -v landmask $lmask $ofile");
}
print(" END  ----  create_SEAS_climo_step2:   \[Y=$yr\]\n") ;


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
