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

source hpccore-5
source $HPC_DATA/$SSH_CONFIGFILE
readonly SSH_WORKDIR
readonly READDIR

declare -r SSH_RESULTDIR=$HPC_DATA/$RESULTDIR/$PREFIX
declare -r WORKDIR=$SSH_RESULTDIR/$ASSEMBLY_TAG-ssh
declare -r SSH_READSDIR=$HPC_DATA/$READDIR
mkdir -p $WORKDIR
mkdir -p $SSH_RESULTDIR

#-------------------------- Assembly specific code here --------------------
#Example below
source my-asembler
docker --name myassemblername run my_assembler $ARGUMENTS $WORKDIR $READS1 $READS2
docker rm -f myassemblername

#Give location of result files
CONTIGS=$WORKDIR/contigs.fasta
SCAFFOLDS=$WORKDIR/scaffolds.fasta
#-------------------------- Assembly specific code here --------------------

cp $CONTIGS $SSH_RESULTDIR/${ASSEMBLY_TAG}c${PREFIX}i.fasta
cp $SCAFFOLDS $SSH_RESULTDIR/${ASSEMBLY_TAG}s${PREFIX}i.fasta
echo `basename "$0"`: FINISHED!! FINISHED!!
