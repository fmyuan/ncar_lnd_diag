#!/bin/csh -f

# written by Sheri Mickelson
# March 2013

set wkrdir = $1
set type = $2
set outfile = $3

ls /$wkrdir | grep "."$type > $outfile

