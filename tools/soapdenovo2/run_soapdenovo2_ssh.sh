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
source SOAPdenovo2-r240

source $SSH_CONFIGFILE
readonly SSH_WORKDIR
readonly READDIR
declare -xr SOURCEDIR=`dirname "$BASH_SOURCE"`
echo source directory $SOURCEDIR

declare -r SSH_RESULTDIR=$HPC_DATA/$RESULTDIR/$PREFIX
declare -r WORKDIR=$SSH_RESULTDIR/$ASSEMBLY_TAG-ssh
declare -r SSH_READSDIR=$HPC_DATA/$READDIR
mkdir -p $WORKDIR
mkdir -p $SSH_RESULTDIR

#-------------------------- Assembly specific code here --------------------
echo SOAPdenvo2 ssh: about to run ssh abyss on $PREFIX

rm $WORKDIR/config_file
touch $WORKDIR/config_file
cat $SOURCEDIR/soap_config_head.txt >> $WORKDIR/config_file
cat $SOURCEDIR/soap_config_lib_head.txt >> $WORKDIR/config_file
echo q1=$SSH_READSDIR/$READS1 >> $WORKDIR/config_file
echo q2=$SSH_READSDIR/$READS2 >> $WORKDIR/config_file

echo $PREFIX SOAP2: soapdenovo2 config file follows
cat $WORKDIR/config_file
echo $PREFIX SOAP2: Finished soapdenovo2 config file 

echo $PREFIX SOAP2: RUN RUN RUN

SOAPdenovo-127mer \
		  all \
		  -s $WORKDIR/config_file \
		  -K 63 \
		  -p 10 \
		  -R \
		  -o $WORKDIR/$PREFIX 

#abyss-pe \
#		$PARAMTERS \
#		name=$WORKDIR/$PREFIX \
#		in="$SSH_READSDIR/$READS1 $SSH_READSDIR/$READS2"

#Give location of result files
CONTIGS=$WORKDIR/$PREFIX.contig
SCAFFOLDS=$WORKDIR/$PREFIX.scafSeq
#-------------------------- Assembly specific code here --------------------

cp $CONTIGS $SSH_RESULTDIR/${ASSEMBLY_TAG}c${PREFIX}i.fasta
cp $SCAFFOLDS $SSH_RESULTDIR/${ASSEMBLY_TAG}s${PREFIX}i.fasta
echo `basename "$0"`: FINISHED!! FINISHED!!
