#!/usr/bin/perl

# written by Nan Rosenbloom
# December 2006

$share_code = $ENV{'DIAG_SHARED'};   
use lib '$share_code'; 

use lnd_ann;
use lnd_util;
use lnd_getFiles;
use lnd_mons;
use lnd_seas_climo;
use lnd_seas_means;



sub create_SEAS_means_step0
{
        local($yr) = @_;
        print("===> createAnnualSeasonalFile .. $yr\n");
        local($yp)  = printYear($yr);
        local($ym1) = $yr-1;

        $decYr = $yr - 1    if ($decFlag == 1);                # use Dec from previous yr + JanFeb from same year
        $decYr = $yr        if ($decFlag == 2);                # use Dec from same year + JanFeb from following year
        $decYr = $yr        if ($decFlag == 3);                # use Dec from last year + JanFeb from first year
        $JanFebYr = $yr     if ($decFlag == 1);                # use JanFeb from same year + Dec from previous year
        $JanFebYr = $yr + 1 if ($decFlag == 2);                # use JanFeb from following year + Dec from same year
        $JanFebYr = $yr     if ($decFlag == 3);                # use JanFeb from first year + Dec from last year
}
sub create_SEAS_means_step1
{
        local($yr) = @_;
        print("===> createAnnualSeasonalFile .. $yr\n");
        local($yp)  = printYear($yr);
        local($ym1) = $yr-1;

        $decYr = $yr - 1    if ($decFlag == 1);                # use Dec from previous yr + JanFeb from same year
        $decYr = $yr        if ($decFlag == 2);                # use Dec from same year + JanFeb from following year
        $decYr = $yr        if ($decFlag == 3);                # use Dec from last year + JanFeb from first year
        $JanFebYr = $yr     if ($decFlag == 1);                # use JanFeb from same year + Dec from previous year
        $JanFebYr = $yr + 1 if ($decFlag == 2);                # use JanFeb from following year + Dec from same year
        $JanFebYr = $yr     if ($decFlag == 3);                # use JanFeb from first year + Dec from last year

        $sfileDJF = $procDir.$prefix."_DJF_".$yp.".nc";
        $sfileMAM = $procDir.$prefix."_MAM_".$yp.".nc";
        $sfileJJA = $procDir.$prefix."_JJA_".$yp.".nc";
        $sfileSON = $procDir.$prefix."_SON_".$yp.".nc";

	print(" decFlag = $decFlag\n")  if $DEBUG;

        if ( $weightAnnAvg) {
	   print("Creating Weighted Annual Averages\n") if $DEBUG;
           foreach $seas ("DJF","MAM","JJA","SON") {
                if ($seas eq "DJF") { @months = ("-12","-01","-02"); @nd = (31,31,28); $ofile=$sfileDJF;}
                if ($seas eq "MAM") { @months = ("-03","-04","-05"); @nd = (31,30,31); $ofile=$sfileMAM;}
                if ($seas eq "JJA") { @months = ("-06","-07","-08"); @nd = (30,31,31); $ofile=$sfileJJA;}
                if ($seas eq "SON") { @months = ("-09","-10","-11"); @nd = (30,31,30); $ofile=$sfileSON;}

                $sdays=$ctr=0; 
                foreach $m (@months) {
                 	if    ($m eq "-12") { $useYr = $decYr;    }
                 	elsif ($m eq "-01") { $useYr = $JanFebYr; }
                 	elsif ($m eq "-02") { $useYr = $JanFebYr; }
 			else                { $useYr = $yr;       }
                 	$use_prnt = printYear($useYr);  
                
                        # Sum the number of days in the season
                        $sdays += $nd[$ctr];                    
        
                        $ifile   = $casedir.$caseid.".".$mode.".h0.".$use_prnt.$m.".nc"; 
			print("useYr = $useYr\n");
                        if ($decFlag == 1) {  &getDec(      $useYr) if ( ! -e $ifile); }
                 	if ($decFlag == 2) {  &getJanFeb($use_prnt) if ( ! -e $ifile); }
                        $out     = $procDir.$prefix.".t1".".nc"; 
                        $tmpfile = $procDir.$prefix.".t2".".nc"; 

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
                        # print("ncflint $atts $weights $tmpfile $ifile $out\n") if $DEBUG; 
                        $err = system("ncflint $atts $weights $tmpfile $ifile $out\n"); die "seasonal ncflint failed \n" if $err;
                        $ctr++;
                }
                $wt1 = 1./$sdays;               # divide by number of days in the season
                $wt2 = 0.0;
                system("mv $out $tmpfile");
                $weights = "-w $wt1,$wt2";
                # print("ncflint -O $weights $tmpfile $tmpfile $ofile\n") if $DEBUG;
                $err = system("ncflint -O $weights $tmpfile $tmpfile $ofile");

           }
       }  else {
            $ctr=0; foreach $m ("-12","-01","-02") { 
                     if    ($m eq "-12") { $useYr = $decYr;    }
                     elsif ($m eq "-01") { $useYr = $JanFebYr; }
                     elsif ($m eq "-02") { $useYr = $JanFebYr; }
                     $use_prnt = printYear($useYr);  
                     @DJF[$ctr] = $casedir.$caseid.".".$mode.".h0.".$use_prnt.$m.".nc"; 
                     if ($decFlag == 1) {  &getDec(      $useYr) if ( ! -e @DJF[$ctr]); }
                     if ($decFlag == 2) {  &getJanFeb($use_prnt) if ( ! -e @DJF[$ctr]); }
                     $ctr++; 
            }
            $ctr=0; foreach $m ("-03","-04","-05") { @MAM[$ctr] = $casedir.$caseid.".".$mode.".h0.".$yp.$m.".nc"; $ctr++; }
            $ctr=0; foreach $m ("-06","-07","-08") { @JJA[$ctr] = $casedir.$caseid.".".$mode.".h0.".$yp.$m.".nc"; $ctr++; }
            $ctr=0; foreach $m ("-09","-10","-11") { @SON[$ctr] = $casedir.$caseid.".".$mode.".h0.".$yp.$m.".nc"; $ctr++; }


            # if ($mode eq "clm2") { $atts = "time_written,date_written,mcdate,mcsec,nstep,mdcur,pftmask"; }
            if ($mode eq "clm2") { $atts = "time_written,date_written,mcdate,mcsec,nstep,mdcur"; }
            if ($mode eq "cam2") { $atts = "time_written,date_written,nbdate,date,nsteph"; }
            if ($mode eq "rtm")  { $atts = "time_written,date_written,fthresh"; }
            $flags = "-O -x -v";

            print("ncra  $flags $atts @DJF $sfileDJF\n") if $DEBUG;
            print("ncra  $flags $atts @MAM $sfileMAM\n") if $DEBUG;
            print("ncra  $flags $atts @JJA $sfileJJA\n") if $DEBUG;
            print("ncra  $flags $atts @SON $sfileSON\n") if $DEBUG;

            $err = system("ncra $flags $atts @DJF $sfileDJF"); die "ncra failed \n" if $err;
            $err = system("ncra $flags $atts @MAM $sfileMAM"); die "ncra failed \n" if $err;
            $err = system("ncra $flags $atts @JJA $sfileJJA"); die "ncra failed \n" if $err;
            $err = system("ncra $flags $atts @SON $sfileSON"); die "ncra failed \n" if $err;

	}
}



sub create_SEAS_means_step2
{
        print("Concatenating SEASONAL Means\n");
        
        $ifileDJF = $procDir.$prefix."_DJF_????.nc";
        $ifileMAM = $procDir.$prefix."_MAM_????.nc";
        $ifileJJA = $procDir.$prefix."_JJA_????.nc";
        $ifileSON = $procDir.$prefix."_SON_????.nc";

        if ($mode eq "clm2") {
                $ofileDJF = $prefixDir.$prefix."_DJF_means.nc";
                $ofileMAM = $prefixDir.$prefix."_MAM_means.nc";
                $ofileJJA = $prefixDir.$prefix."_JJA_means.nc";
                $ofileSON = $prefixDir.$prefix."_SON_means.nc";
        }
        if ($mode eq "cam2") {
                $ofileDJF = $prefixDir.$prefix."_DJF_means_atm.nc";
                $ofileMAM = $prefixDir.$prefix."_MAM_means_atm.nc";
                $ofileJJA = $prefixDir.$prefix."_JJA_means_atm.nc";
                $ofileSON = $prefixDir.$prefix."_SON_means_atm.nc";
        }
        if ($mode eq "rtm") {
                $ofileDJF = $prefixDir.$prefix."_DJF_means_rtm.nc";
                $ofileMAM = $prefixDir.$prefix."_MAM_means_rtm.nc";
                $ofileJJA = $prefixDir.$prefix."_JJA_means_rtm.nc";
                $ofileSON = $prefixDir.$prefix."_SON_means_rtm.nc";
        }
        system("ncrcat \-O $ifileDJF $ofileDJF");
        system("ncrcat \-O $ifileMAM $ofileMAM");
        system("ncrcat \-O $ifileJJA $ofileJJA");
        system("ncrcat \-O $ifileSON $ofileSON");

        system("ncatted \-O \-a yrs_averaged,global,c,c,$clim_range $ofileDJF");
        system("ncatted \-O \-a yrs_averaged,global,c,c,$clim_range $ofileMAM");
        system("ncatted \-O \-a yrs_averaged,global,c,c,$clim_range $ofileJJA");
        system("ncatted \-O \-a yrs_averaged,global,c,c,$clim_range $ofileSON");

        system("ncatted \-O \-a num_yrs_averaged,global,c,i,$clim_nyr $ofileDJF");
        system("ncatted \-O \-a num_yrs_averaged,global,c,i,$clim_nyr $ofileMAM");
        system("ncatted \-O \-a num_yrs_averaged,global,c,i,$clim_nyr $ofileJJA");
        system("ncatted \-O \-a num_yrs_averaged,global,c,i,$clim_nyr $ofileSON");

        if ( $weightAnnAvg) 
		{ $wtFlag = "\"annual means computed from monthly means with months weighted by number of days in month\""; }
	else    { $wtFlag = "\"annual means computed from monthly means with all months weighted equally\""; }

        system("ncatted \-O \-a weighted_avg,global,c,c,$wtFlag $ofileDJF");
        system("ncatted \-O \-a weighted_avg,global,c,c,$wtFlag $ofileMAM");
        system("ncatted \-O \-a weighted_avg,global,c,c,$wtFlag $ofileJJA");
        system("ncatted \-O \-a weighted_avg,global,c,c,$wtFlag $ofileSON");
        # ... nanr 8/24/07
        # Prob:  Landmask is set to 0 by averaging process.  (this only affects set9, but is still misleading.    
        # Soln:  Remove bad landmask and overwrite landmask directly from a history file. 
        if ($mode eq "clm2") {
                $yr_prnt = printYear($clim_lyr);
                $usefile = $casedir.$caseid.".".$mode.".h0.".$yr_prnt."-01.nc";
                $lmask   = $procDir.$prefix.".lmask.nc";
                system("ncks -v landmask $usefile $lmask") if !-e $lmask;
                system("ncks -q \-A -v landmask $lmask $ofileDJF"); 
                system("ncks -q \-A -v landmask $lmask $ofileMAM");
                system("ncks -q \-A -v landmask $lmask $ofileJJA");
                system("ncks -q \-A -v landmask $lmask $ofileSON");
        }
}

1	# make 'em happy

