#!/bin/bash
# runAbyssLocal.sh
# $1 Config file
# $2 Prefix e.g. NCYC93
# $3 First part of the paired end reads, relative to read directory
# $4 Second part of the paired end reads, relative to read directory
declare -r SSH_CONFIGFILE=$1
declare -r PREFIX=$2
declare -r READS1=$3
declare -r READS2=$4
#Hard conded until I workout how to soft code
declare HPC_DATA=/nbi/group-data/ifs/NBI/Research-Groups/Jo-Dicks

source hpccore-5
source abyss-1.9.0
source $HPC_DATA/$SSH_CONFIGFILE
readonly SSH_WORKDIR
readonly READDIR
readonly ABYSS_KMER
readonly ABYSS_PROCS

echo $PREFIX SSHABYSS: config file $SSH_CONFIGFILE

declare -r WORKDIR=$HPC_DATA/$RESULTDIR/$PREFIX/abyss-ssh
declare -r SSH_RESULTDIR=$HPC_DATA/$RESULTDIR/$PREFIX
declare -r SSH_READSDIR=$HPC_DATA/$READDIR
mkdir -p $WORKDIR
mkdir -p $SSH_RESULTDIR
echo $PREFIX SSHABYSS: resultdirectory 

abyss-pe \
  k=$ABYSS_KMER \
  j=$ABYSS_PROCS \
  name=$WORKDIR/$PREFIX \
  in="$SSH_READSDIR/$READS1 $SSH_READSDIR/$READS2" 

cp $WORKDIR/$PREFIX-6.fa $SSH_RESULTDIR/ac${PREFIX}i_hpc.fasta
cp $WORKDIR/$PREFIX-8.fa $SSH_RESULTDIR/as${PREFIX}i_hpc.fasta
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

