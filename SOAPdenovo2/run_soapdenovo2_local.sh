#!/bin/bash
# runSOAPdenova2.sh
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
declare -r PREFIX=$1
declare -r READS1=$2
declare -r READS2=$3

#To Do - tempory these should be inhereited
declare -xr SOURCEDIR=/home/shepperp/datashare/Piers/github/ncycseqpipe
declare -r INPUTDIR=/home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input
declare -xr CONFIGFILE=$INPUTDIR/ncycseqpipe.cfg

# varables used from config file
source $CONFIGFILE
readonly LOCAL_RESULTDIR
readonly READDIR
readonly SOAP_KMER
readonly SOAP_PROCS

declare -r WORKDIR=$LOCAL_WORKDIR/$PREFIX/soapenovo2-local
mkdir -p $WORKDIR

echo $PREFIX SOAP2: about to run soap >&2
echo $PREFIX SOAP2: Work directory=$WORKDIR
echo $PREFIX SOAP2: Read directory=$READDIR
echo $PREFIX SOAP2: Result directory=$LOCAL_RESULTDIR
echo $PREFIX SOAP2: Prefix=$PREFIX
echo $PREFIX SOAP2: READS1=$READS1
echo $PREFIX SOAP2: READS2=$READS2
echo $PREFIX SOAP2: Kmer=$ABYSS_KMER
echo $PREFIX SOAP2: Processors=$ABYSS_PROCS

rm $WORKDIR/config_file
touch $WORKDIR/config_file
cat $SOURCEDIR/SOAPdenovo2/soap_config_head.txt >> $WORKDIR/config_file
cat $SOURCEDIR/SOAPdenovo2/soap_config_lib_head.txt >> $WORKDIR/config_file
echo q1=/reads/$READS1 >> $WORKDIR/config_file
echo q2=/reads/$READS2 >> $WORKDIR/config_file

echo $PREFIX SOAP2: SOAPdenova2 config file follows
cat $WORKDIR/config_file
echo $PREFIX SOAP2: Finished SOAPdenova2 config file 

echo $PREFIX SOAP2: RUN RUN RUN

docker run \
	--name soapdenovo2$PREFIX  \
	-v $READDIR:/reads:ro \
	-v $WORKDIR:/results \
	sriep/soapdenovo2 \
		  all \
		  -s /results/config_file \
		  -K $SOAP_KMER \
		  -p $SOAP_PROCS \
		  -R \
		  -o /results/$PREFIX 

echo $PREFIX SOAP2: SOAPdenovo2 return code is $?

mkdir -p $LOCAL_RESULTDIR/$PREFIX
cp $WORKDIR/$PREFIX.contig $LOCAL_RESULTDIR/$PREFIX/sc${PREFIX}i.fasta
cp $WORKDIR/$PREFIX.scafSeq $LOCAL_RESULTDIR/$PREFIX/ss${PREFIX}i.fasta

echo $PREFIX SOAP2: FINISHED!! soapdenovo2$PREFIX FINISHED!!

docker rm -f soapdenovo2$PREFIX 
echo $PREFIX SOAP2: soapdenovo2$PREFIX  stopped

# /home/shepperp/datashare/Piers/github/ncycseqpipe/SOAPdenovo2/run_soapdenovo2.sh NCYC22 NCYC22/NCYC22.FP.fastq NCYC22/NCYC22.RP.fastq 
