#!/bin/bash
# $1 Path to working directory. Results will be put in abyss subdirectory
# $2 Path to Read directory
# $3 Prefix e.g. NCYC93
# $4 First part of the paired end reads, relative to read directory
# $5 Second part of the paired end reads, relative to read directory
# $6 k k-mer size
# $7 j number of processes
WORKDIR=$1
READDIR=$2
PREFIX=$3
READS1=$4
READS2=$5
KMER=$6
PROCS=$7

#RESULTDIR=/home/shepperp/documents/test
#READDIR=/home/shepperp/datashare/Piers/Trim/NCYC_93
#PREFIX=NCYC39
#WORKDIR=$RESULTDIR/$PREFIX/wgs
#READS1=NCYC93.FP.fastq
#READS2=NCYC93.RP.fastq

mkdir -p $WORKDIR
docker run -v $READDIR:/reads:ro fastqtoca -libraryname l1 -insertsize 500 100  -technology illumina -type sanger  -mates reads/$READS1,reads/$READS2 > $WORKDIR/$PREFIX.frg

echo "#  Spec file for celera assembly." > $WORKDIR/$PREFIX.spc
echo $WORKDIR/$PREFIX.frg >> $WORKDIR/$PREFIX.spc

#docker run -v $READDIR:/reads:ro -v $WORKDIR:/results runca -d results -p $PREFIX -s results/$PREFIX.spc
docker run -v $READDIR:/reads:ro -v $WORKDIR:/results runca -d results -p $PREFIX results/$PREFIX.frg