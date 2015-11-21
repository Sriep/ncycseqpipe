#!/bin/bash
# 
# $1 Config file
# $2 Prefix e.g. NCYC93
# $3 First part of the paired end reads, relative to read directory
# $4 Second part of the paired end reads, relative to read directory
# $5 Assembly tag from input file
# $6 Arguments from input file
declare -r SSH_CONFIGFILE="$1"
declare -r PREFIX="$2"
declare -r READS1="$3"
declare -r READS2="$4"
declare -r ASSEMBLY_TAG="$5"
#declare -r PARAMTERS="$6"
declare -r PARAMTERS=$(echo "$6" | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")
echo  $SSH_CONFIGFILE
echo  $PREFIX
echo  $READS1
echo  $READS2
echo  $ASSEMBLY_TAG
echo  $PARAMTERS
source hpccore-5
source abyss-1.9.0

source $SSH_CONFIGFILE
readonly SSH_WORKDIR
readonly READDIR


declare -r SSH_RESULTDIR=$HPC_DATA/$RESULTDIR/$PREFIX
declare -r WORKDIR=$SSH_RESULTDIR/$ASSEMBLY_TAG-ssh
declare -r SSH_READSDIR=$HPC_DATA/$READDIR
mkdir -p $WORKDIR
mkdir -p $SSH_RESULTDIR

#-------------------------- Assembly specific code here --------------------
echo ABYSS ssh: about to run ssh abyss on $PREFIX


declare -a args
IFS=' ' read -ra args <<< "$PARAMTERS"
echo "ABYSS ssh: arguments ${args[@]/#/}"
#${args[@]/#/}
echo "abyss-pek=${args[0]} j=${args[1]} name=$WORKDIR/$PREFIX in=$SSH_READSDIR/$READS1 $SSH_READSDIR/$READS2"
echo "ABYSS ssh: About to run abyss"
abyss-pe \
		$PARAMTERS \
		name=$WORKDIR/$PREFIX \
		in="$SSH_READSDIR/$READS1 $SSH_READSDIR/$READS2"

#Give location of result files
CONTIGS=$WORKDIR/$PREFIX-6.fa
SCAFFOLDS=$WORKDIR/$PREFIX-8.fa
#-------------------------- Assembly specific code here --------------------

cp $CONTIGS $SSH_RESULTDIR/${ASSEMBLY_TAG}c${PREFIX}i.fasta
cp $SCAFFOLDS $SSH_RESULTDIR/${ASSEMBLY_TAG}s${PREFIX}i.fasta
echo `basename "$0"`: FINISHED!! FINISHED!!
