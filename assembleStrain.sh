#!/bin/bash
# $1 Path to working directory. Results will be put in abyss subdirectory
# $2 Path to Read directory
# $3 Prefix e.g. NCYC93
# $4 First part of the paired end reads, relative to read directory
# $5 Second part of the paired end reads, relative to read directory
WORKDIR=$1/abyss
READDIR=$2
PREFIX=$3
READS1=$4
READS2=$5

DOCKERDIR=/home/shepperp/datashare/Piers/github/ncycseqpipe

if test $ABYSS_LOCAL 
then 
	$DOCKERDIR/abyss-pe/runAbyssLocal.sh $WORKDIR/abyssLocal $READDIR $PREFIX $READS1 $READS2 $ABYSS_KMER $ABYSS_PROCS
fi
if test $ABYSS_SSH 
then 
	$DOCKERDIR/abyss-pe/runAbyssSSH.sh $WORKDIR/abyssSHH $READDIR $PREFIX $READS1 $READS2 $ABYSS_KMER $ABYSS_PROCS
fi
if test $WGS 
then 
	$DOCKERDIR/abyss-pe/runwgs.sh $WORKDIR/wgs $READDIR $PREFIX $READS1 $READS2 $ABYSS_KMER $ABYSS_PROCS
fi
