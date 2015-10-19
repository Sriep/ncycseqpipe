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

sshpass -e ssh -t $USERID@hpc.nbi.ac.uk \
					"source abyss-1.9.0; \
					mkdir -p $WORKDIR; \
					bsub abyss-pe k=$KMER j=$PROCS name=$WORKDIR/$PREFIX in='$READDIR/$READS1 $READDIR/$READS2' " 
# /home/shepperp/datashare/Piers/github/ncycseqpipe/abyss-1.9.0/runAbyss.sh \
#		NCYC93 \
#		80 \
#		12 \
#		/nbi/group-data/ifs/NBI/Research-Groups/Jo-Dicks/Piers/assemblies/test/NCYC93 \
#		/nbi/group-data/ifs/NBI/Research-Groups/Jo-Dicks/Piers/Trim/NCYC_93/NCYC93.FP.fastq \
#		/nbi/group-data/ifs/NBI/Research-Groups/Jo-Dicks/Piers/Trim/NCYC_93/NCYC93.RP.fastq
#
#WORKDIR=/nbi/group-data/ifs/NBI/Research-Groups/Jo-Dicks/Piers/assemblies/test/70sshNCYC93
#PREFIX=NCYC93
#READDIR=/nbi/group-data/ifs/NBI/Research-Groups/Jo-Dicks/Piers/Trim
#READS1=NCYC93/NCYC93.FP.fastq
#READS2=/NCYC93/NCYC93.RP.fastq
#KMER=70
#PROCS=12
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

