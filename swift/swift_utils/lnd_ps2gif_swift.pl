#!/usr/bin/perl

use IO::File;

# written by Nan Rosenbloom
# July 2005
# modified by Sheri Mickelson for Swift version
# January 2013
# Usage:  called by /code/lnd_driver.csh to dynamically generate
# html files for revised LMWG Diagnostics Package.

# program checks for successful completion of plots; variables not
# successfully plotted are not linked to the html.

# --------------------------------
# get environment variables

print "Preparing to wait for lnd_ps2gif .....\n";

$file_set  =    $ARGV[0]; 
$file	     =    $ARGV[1];
$wkdir     =    $ARGV[2]; 
$webdir    =    $ARGV[3]; 
$runtype   =    $ARGV[4]; 
$plot_type =    $ARGV[5]; 
$density   =    $ARGV[6];
$outfile     =    $ARGV[7];

if ($runtype eq "model1-model2") { $compareModels = 1; }
else			           { $compareModels = 0; }

$convert = "/usr/bin/convert";
$flags = "-density $density -trim +repage";
$smflags = "-trim +repage";

$set = substr($file_set,3,1);

if ($set == 5) { system("cp $wkdir/set5_*.txt $webdir/set5/"); }
else {
   if ($set == 7) { system("cp $wkdir/set7_*.txt $webdir/set7/"); }
   if ($set == 9) { system("cp $wkdir/set9_*.html $webdir/set9/"); }
   $sfile = "'set".$set."*.ps'";
   #chop($file);
   $fin  = substr($file,length($wkdir));
   if ($plot_type eq "ps")
	{
       	$fn   = substr($fin,0,9);
       	$fn1  = substr($fin,0,13);
       	$f    = substr($fin,0,length($fin)-2);
	$fout = $webdir."/set".$set."/".$f."gif";
      
        print "file =  $file \n";
        print "fin  =  $fin  \n";
        print "fn1  =  $fn1  \n";
        print "f    =  $f    \n";
        print "fout =  $fout \n";
 
	if($fn  eq "set3_reg_" || $fn eq "set6_reg_" || 
	    $fn eq "set7_ANN_" || $fn eq "set7_stat" || $fn  eq "set7_ocea" )
					 { print("Rotating image. $fn\n");  
					   $commandLine = "$convert $flags -rotate -90 $file $fout"; }
	else {
	     if($set == 2 && $compareModels) { $commandLine = "$convert $flags $file $fout"; }
	     else  { 
		if($set == 1) { $commandLine = "$convert $smflags $file $fout"; }
		else          { $commandLine = "$convert   $flags $file $fout"; }
	     }
	}
	print "converting = $fin to $fout\n";
   } elsif ($plot_type eq "png") {

		$outdir = $webdir."/set".$set;
		$commandLine = "mv $wkdir$fin $outdir/$fin";
		print "$commandLine\n";
   } else { die "Invalid plot type.\n"; }
	$err = system($commandLine); #die  if $err;
} 
print "Done with ps2gif conversion\n";

system("pwd");

$mfile = IO::File->new($outfile,'w');
print mfile "Complete";
close (mfile);

