#!/bin/bash
source /home/shepperp/datashare/Piers/github/ncycseqpipe/ncycseqpipe.cfg
source abyss-1.9.0
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
PREFIX=$1
READS1=$2
READS2=$3
WORKDIR=$SSH_WORKDIR/$PREFIX/abyss-ssh
RESULTDIR=$SSH_RESULTDIR_PATH/$PREFIX
mkdir -p $WORKDIR
mkdir -p $RESULTDIR 
abyss-pe k=$ABYSS_KMER j=$ABYSS_PROCS name=$WORKDIR in='$READDIR/$READS1 $READDIR/$READS2' 

#/home/shepperp/datashare/Piers/github/ncycseqpipe/abyss-1.9.0/runAbyss.sh \
#		NCYC93 \
#		NCYC93/NCYC93.FP.fastq \
#		NCYC93/NCYC93.RP.fastq 
#
#Parameters of the driver script, abyss-pe
#    a: maximum number of branches of a bubble [2]
#    b: maximum length of a bubble (bp) [""]
#    c: minimum mean k-mer coverage of a unitig [sqrt(median)]
#    d: allowable error of a distance estimate (bp) [6]
#    e: minimum erosion k-mer coverage [round(sqrt(median))]
#    E: minimum erosion k-mer coverage per strand [1 if sqrt(median) > 2 else 0]
#    j: number of threads [2]
#    k: size of k-mer (when K is not set) or the span of a k-mer pair (when K is set)
#    K: the length of a single k-mer in a k-mer pair (bp)
#    l: minimum alignment length of a read (bp) [k]
#    m: minimum overlap of two unitigs (bp) [30]
#    n: minimum number of pairs required for building contigs [10]
#    N: minimum number of pairs required for building scaffolds [n]
#    p: minimum sequence identity of a bubble [0.9]
#    q: minimum base quality [3]
#    s: minimum unitig size required for building contigs (bp) [200]
#    S: minimum contig size required for building scaffolds (bp) [s]
#    t: maximum length of blunt contigs to trim [k]
#    v: use v=-v for verbose logging, v=-vv for extra verbose [disabled]

