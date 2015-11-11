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
declare -r ARGUMENTS="$6"

source $CONFIGFILE
readonly LOCAL_DATA
readonly RESULTDIR
readonly LOCAL_WORKDIR
readonly READDIR

declare -r WORKDIR=$LOCAL_WORKDIR/$PREFIX/$ASSEMBLY_TAG-local
declare -r LOCAL_READSDIR=$LOCAL_DATA/$READDIR
mkdir -p $WORKDIR

#-------------------------- Assembly specific code here --------------------
#Example below
docker --name myassemblername run my_assembler $ARGUMENTS $WORKDIR $READS1 $READS2
docker rm -f myassemblername

#Give location of result files
CONTIGS=$WORKDIR/contigs.fasta
SCAFFOLDS=$WORKDIR/scaffolds.fasta
#-------------------------- Assembly specific code here --------------------

declare -r LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX
mkdir -p $LOCAL_RESULTDIR
cp $CONTIGS $LOCAL_RESULTDIR/${ASSEMBLY_TAG}c${PREFIX}i.fasta
cp $SCAFFOLDS $LOCAL_RESULTDIR/${ASSEMBLY_TAG}s${PREFIX}i.fasta
echo `basename "$0"`: FINISHED!! FINISHED!!
