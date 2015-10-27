#!/bin/bash
# runSOAPdenova2.sh
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
declare -r PREFIX=$1
declare -r READS1=$2
declare -r READS2=$3

# varables used from config file
source $CONFIGFILE
readonly LOCAL_RESULTDIR
readonly READDIR
readonly SOAP_KMER
readonly SOAP_PROCS

declare -r WORKDIR=$LOCAL_WORKDIR/$PREFIX/soapenovo2-local
mkdir -p $WORKDIR

echo $PREFIX SOAP2: about to run soap on strain $PREFIX

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
docker rm -f soapdenovo2$PREFIX 
echo $PREFIX SOAP2: soapdenovo2$PREFIX  stopped

mkdir -p $LOCAL_RESULTDIR/$PREFIX
cp $WORKDIR/$PREFIX.contig $LOCAL_RESULTDIR/$PREFIX/sc${PREFIX}i.fasta
cp $WORKDIR/$PREFIX.scafSeq $LOCAL_RESULTDIR/$PREFIX/ss${PREFIX}i.fasta

echo $PREFIX SOAP2: FINISHED!! soapdenovo2$PREFIX FINISHED!!
# /home/shepperp/datashare/Piers/github/ncycseqpipe/SOAPdenovo2/run_soapdenovo2.sh NCYC22 NCYC22/NCYC22.FP.fastq NCYC22/NCYC22.RP.fastq 
