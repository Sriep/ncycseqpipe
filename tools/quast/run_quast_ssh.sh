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
declare -r METRIC_TAG="$5"
#declare -r PARAMTERS="$6"
declare -r PARAMTERS=$(echo "$6" | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")
echo  $SSH_CONFIGFILE
echo  $PREFIX
echo  $READS1
echo  $READS2
echo  $METRIC_TAG
echo  $PARAMTERS
source hpccore-5
source quast-3.1
QUASTDIR=/nbi/software/testing/quast/3.1/x86_64/bin

source $SSH_CONFIGFILE
readonly SSH_WORKDIR
readonly READDIR
readonly PRFIX_STUB=${basename $PREFIX}

declare -r SSH_RESULTDIR=$HPC_DATA/$RESULTDIR/$PREFIX
declare -r ASSEMBLY=$SSH_RESULTDIR.fasta
declare -r WORKDIR=$SSH_RESULTDIR/$METRIC_TAG-ssh
declare -r SSH_READSDIR=$HPC_DATA/$READDIR
mkdir -p $WORKDIR
mkdir -p $SSH_RESULTDIR
TEMPLATE=$SSH_RESULTDIR.fasta
#-------------------------- Assembly specific code here --------------------
echo QUAST ssh: about to run ssh quast on $PREFIX

echo template is $TEMPLATE
echo "$QUASTDIR/quast.py  --eukaryote  --scaffolds  -o $WORKDIR  $f"
echo now send the quest command for real

$QUASTDIR/quast.py \
  --eukaryote \
  --scaffolds \
  -o $WORKDIR \
  $TEMPLATE

#Give location of result files
METRICS_CSV=$WORKDIR/transposed_report.tsv

#-------------------------- Assembly specific code here --------------------

cp $METRICS_CSV $SSH_RESULTDIR/m_$(basename $PREFIX)_$METRIC_TAG

#cp $CONTIGS $SSH_RESULTDIR/${METRIC_TAG}c${PREFIX}i.fasta
#cp $SCAFFOLDS $SSH_RESULTDIR/${METRIC_TAG}s${PREFIX}i.fasta
echo `basename "$0"`: FINISHED!! FINISHED!!
