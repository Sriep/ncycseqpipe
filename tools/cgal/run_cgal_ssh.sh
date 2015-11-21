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
source bowtie2-2.2.5
source samtools-1.0
source jdk-1.7.0_25
source CGAL-0.9.6 

source $SSH_CONFIGFILE
readonly SSH_WORKDIR
readonly READDIR
readonly PRFIX_STUB=$(basename $PREFIX)


declare -r SSH_RESULTDIR=$HPC_DATA/$RESULTDIR/$PREFIX
declare -r ASSEMBLY=$SSH_RESULTDIR.fasta
declare -r WORKDIR=$SSH_RESULTDIR/$METRIC_TAG-ssh
declare -r SSH_READSDIR=$HPC_DATA/$READDIR
mkdir -p $WORKDIR
mkdir -p $SSH_RESULTDIR
TEMPLATE=$SSH_RESULTDIR.fasta
echo template is $TEMPLATE
#-------------------------- Assembly specific code here --------------------
echo BOWTIE2 ssh: about to run ssh bowtie2 on $TEMPLATE

declare -r SAMFILE=$SSH_RESULTDIR/${PRFIX_STUB}_BOW2.sam

cd  $WORKDIR
echo about to run bowtie2convert
echo "bowtie2convert $SAMFILE 600"
bowtie2convert $SAMFILE 600
echo
echo
echo "align $TEMPLATE.fasta 1000 12"
align $TEMPLATE 1000 12
echo "cgal $TEMPLATE.fasta"
echo
cgal $TEMPLATE
echo "finished cgal"
#Give location of result files
METRICS_CSV=$WORKDIR/out.txt

#-------------------------- Assembly specific code here --------------------

cp $METRICS_CSV $SSH_RESULTDIR/m_${PRFIX_STUB}_${METRIC_TAG}

#cp $CONTIGS $SSH_RESULTDIR/${ASSEMBLY_TAG}c${PREFIX}i.fasta
#cp $SCAFFOLDS $SSH_RESULTDIR/${ASSEMBLY_TAG}s${PREFIX}i.fasta
echo `basename "$0"`: FINISHED!! FINISHED!!
