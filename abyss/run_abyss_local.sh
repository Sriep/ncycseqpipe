#!/bin/bash
# runAbyssLocal.sh
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
declare -r PREFIX=$1
declare -r READS1=$2
declare -r READS2=$3

source $CONFIGFILE
readonly LOCAL_RESULTDIR
readonly READDIR
readonly ABYSS_KMER
readonly ABYSS_PROCS

declare -r WORKDIR=$LOCAL_WORKDIR/$PREFIX/abyss-local
mkdir -p $WORKDIR

echo ABYSS: about to run abyss on $PREFIX
docker run \
	--name abysspe$PREFIX  \
	-v $READDIR:/reads:ro \
	-v $WORKDIR:/results \
	sriep/abyss-pe \
		k=$ABYSS_KMER \
		j=$ABYSS_PROCS \
		name=/results/$PREFIX \
		in="/reads/$READS1 /reads/$READS2" 
echo ABYSS: abyss return code is $?
docker rm -f abysspe$PREFIX 
echo ABYSS: abysspe$PREFIX  stopped

mkdir -p $LOCAL_RESULTDIR/$PREFIX
cp $WORKDIR/$PREFIX-6.fa $LOCAL_RESULTDIR/$PREFIX/ac${PREFIX}i.fasta
cp $WORKDIR/$PREFIX-8.fa $LOCAL_RESULTDIR/$PREFIX/as${PREFIX}i.fasta

echo ABYSS: FINISHED!! abysspe$PREFIX FINISHED!!
# /home/shepperp/datashare/Piers/github/ncycseqpipe/abyss/run_abyss_local.sh NCYC22 NCYC22/NCYC22.FP.fastq NCYC22/NCYC22.RP.fastq 
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

