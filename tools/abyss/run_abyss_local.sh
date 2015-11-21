#!/bin/bash
# 
# $1 Config file
# $2 Prefix e.g. NCYC93
# $3 First part of the paired end reads, relative to read directory
# $4 Second part of the paired end reads, relative to read directory
# $5 Assembly tag from input file
# $6 Arguments from input file
declare -r CONFIGFILE="$1"
declare -r PREFIX="$2"
declare -r READS1="$3"
declare -r READS2="$4"
declare -r ASSEMBLY_TAG="$5"
#declare -r PARAMTERS="$6"
#strip quotes
declare -r PARAMTERS=$(echo "$6" | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")
echo "just striped quotes $PARAMTERS"

echo run_local_abyss configfile $CONFIGFILE
echo run_local_abyss prefix $PREFIX
echo run_local_abyss reads1 $READS1
echo run_local_abyss reads2 $READS2
echo run_local_abyss assembly tag $ASSEMBLY_TAG
echo run_local_abyss arguments $PARAMTERS

source $CONFIGFILE
readonly LOCAL_DATA
readonly RESULTDIR
readonly LOCAL_WORKDIR
readonly READDIR

declare -r WORKDIR=$LOCAL_WORKDIR/$PREFIX/$ASSEMBLY_TAG-local
declare -r LOCAL_READSDIR=$LOCAL_DATA/$READDIR
mkdir -p $WORKDIR


#-------------------------- Assembly specific code here --------------------

echo ABYSS: about to run local abyss on $PREFIX

declare -a args
IFS=' ' read -ra args <<< "$PARAMTERS"
echo "arguments ${args[@]/#/}"
#${args[@]/#/}
#k=${args[0]} j=${args[1]} 
docker run \
	--name abysspe$PREFIX  \
	-v $LOCAL_READSDIR:/reads:ro \
	-v $WORKDIR:/results \
	sriep/abyss-pe \
		$PARAMTERS \
		name=/results/$PREFIX \
		in="/reads/$READS1 /reads/$READS2"
echo ABYSS: abyss return code is $?
docker rm -f abysspe$PREFIX 
echo ABYSS: abysspe$PREFIX  stopped

#Give location of result files
CONTIGS=$WORKDIR/$PREFIX-6.fa
SCAFFOLDS=$WORKDIR/$PREFIX-8.fa
#-------------------------- Assembly specific code here --------------------

declare -r LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX
mkdir -p $LOCAL_RESULTDIR
cp $CONTIGS $LOCAL_RESULTDIR/${ASSEMBLY_TAG}c${PREFIX}i.fasta
cp $SCAFFOLDS $LOCAL_RESULTDIR/${ASSEMBLY_TAG}s${PREFIX}i.fasta
echo `basename "$0"`: FINISHED!! FINISHED!!

declare  CONFIGFILE=/home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipe.cfg
declare SSH_CONFIGFILE
declare  PREFIX=NCYC22
declare  READS1=/NCYC22/NCYC22.FP.fastq
declare  READS2=/NCYC22/NCYC22.RP.fastq
declare  ASSEMBLY_TAG=a
declare  PARAMTERS=k=80 j=10
