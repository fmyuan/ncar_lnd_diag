#!/usr/bin/perl

# Code copied from createAnnualFile in lnd_ann.pm
# Original by Nan Rosenbloom
# Modified to run with Swift by Sheri Mickelson
# March 2013

use IO::File;

$year = $ARGV[0];
$casedir = $ARGV[1];
$caseid = $ARGV[2];
$mode = $ARGV[3];
$instance = $ARGV[4];
$procDir = $ARGV[5];
$prefix = $ARGV[6];
$weightAnnAvg = $ARGV[7];
$yr_prnt = $ARGV[8];
$outfile = $ARGV[9];

$NCO = "/glade/u/apps/opt/nco/4.2.0/gnu/4.4.6/bin/";
print("NCO: $NCO");

@monList  = ("-01","-02","-03","-04","-05","-06","-07","-08","-09","-10","-11","-12");
@ndays    = (  31,   28,   31,   30,   31,   30,   31,   31,   30,   31,   30,   31);

if ($mode eq "clm2") { $ofile = $casedir.$caseid."_annT".$instance."_".$yr_prnt.".nc";     }
if ($mode eq "cam2") { $ofile = $casedir.$caseid."_annT_atm_".$yr_prnt.".nc"; }
if ($mode eq "rtm")  { $ofile = $casedir.$caseid."_annT_rtm_".$yr_prnt.".nc"; }

if (!-e $ofile ||  -z $ofile) {

        if ( $weightAnnAvg) {
           print("    $yr_prnt TIME WEIGHTED AVERAGE\n") if $DEBUG;
           $ifile   = $casedir.$caseid.".".$mode.$instance.".h0.".$yr_prnt."-01.nc";
           $ofile   = $procDir.$prefix."_".$yr_prnt."_annFile".$instance.".nc";
           $tmpfile = $procDir.$prefix."_".$yr_prnt."_atmp".$instance.".nc";
           $ctr=0;
           foreach $m (@monList) {
                $ifile   = $casedir.$caseid.".".$mode.$instance.".h0.".$yr_prnt.$m.".nc";
                if ($m eq "-01") {
                        system("cp $ifile $tmpfile");
                        $wt1 = 0.0;
                        if ($mode eq "clm2") { $atts = "-O -x -v ZSOI,DZSOI,WATSAT,SUCSAT,BSW,HKSAT,ZLAKE,DZLAKE,time_written,date_written,time_bounds,mcdate,mcsec,mdcur,nstep"; }
                        if ($mode eq "cam2") { $atts = "-O -x -v time_written,date_written,nbdate,date,nsteph"; }
                        if ($mode eq "rtm")  { $atts = "-O -x -v time_written,date_written,fthresh"; }
                }
                else {
                        system("mv $ofile $tmpfile");
                        $wt1 = 1.0;
                        $atts = "-O ";
                }
                $wt2 = @ndays[$ctr];
                $weights = "-w $wt1,$wt2";
                print("$NCO/ncflint $atts $weights $tmpfile $ifile $ofile\n");
                $err = system("$NCO/ncflint $atts $weights $tmpfile $ifile $ofile\n");   die "annT ncflint failed \n" if $err;
                $ctr++;
           }
           $wt1 = 1/365.;       # divide by 365 days to get annual average
           $wt2 = 0.0;
           system("mv $ofile $tmpfile");
           if ($mode eq "clm2") { $ofile = $casedir.$caseid."_annT".$instance."_".$yr_prnt.".nc";     }
           if ($mode eq "cam2") { $ofile = $casedir.$caseid."_annT_atm_".$yr_prnt.".nc"; }
           if ($mode eq "rtm")  { $ofile = $casedir.$caseid."_annT_rtm_".$yr_prnt.".nc"; }
           $weights = "-w $wt1,$wt2";
           print("$NCO/ncflint -O $weights $tmpfile $tmpfile $ofile\n");
           $err = system("$NCO/ncflint -O $weights $tmpfile $tmpfile $ofile\n");
        }
        else {
                print("    $yr_prnt SIMPLE TIME AVERAGE\n") if $DEBUG;
                $ifile = $casedir.$caseid.".".$mode.".h0.".$yr_prnt.$instance."-01.nc";
                if ($mode eq "clm2") {
                        $atts = "-O -x -v ZSOI,DZSOI,WATSAT,SUCSAT,BSW,HKSAT,ZLAKE,DZLAKE,time_written,date_written,time_bounds,mcdate,mcsec,mdcur,nstep";
                        $ofile = $casedir.$caseid."_annT".$instance."_".$yr_prnt.".nc";
                }
                if ($mode eq "cam2") {
                        $ofile = $casedir.$caseid."_annT_atm_".$yr_prnt.".nc";
                        $atts = "-O -x -v time_written,date_written,nbdate,date,nsteph";
                }
                if ($mode eq "rtm") {
                       $ofile = $casedir.$caseid."_annT_rtm_".$yr_prnt.".nc";
                       $atts = "-O -x -v time_written,date_written,fthresh";
                }
                print(" $NCO/ncra $atts \-n 12,2,1 $ifile $ofile\n") if $DEBUG;
                $err = system("$NCO/ncra $atts \-n 12,2,1 $ifile $ofile\n"); die "ncra failed \n" if $err;
        }
        # ... nanr 8/24/07
        # Prob:  Landmask is set to 0 by averaging process.  (this only affects set9, but is still misleading.
        # Soln:  Remove bad landmask and overwrite landmask directly from a history file.
        if ($mode eq "clm2") {
                $usefile = $casedir.$caseid.".".$mode.".h0.".$yr_prnt.$instance."-01.nc";
                $lmask   = $procDir.$prefix.".lmask.nc";
                system("$NCO/ncks -O -v landmask $usefile $lmask") if !-e $lmask;
                system("$NCO/ncks -O -q \-A -v landmask $lmask $ofile");
        }
}

$mfile = IO::File->new($outfile,'w');
print mfile "Complete";
close (mfile);





