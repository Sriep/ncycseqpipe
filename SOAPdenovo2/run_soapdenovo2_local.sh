#!/bin/bash
# runSOAPdenova2.sh
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
declare -r PREFIX=$1
declare -r READS1=$2
declare -r READS2=$3

source $CONFIGFILE
readonly LOCAL_DATA
readonly RESULTDIR
readonly LOCAL_WORKDIR
readonly READDIR
readonly SOAP_KMER
readonly SOAP_PROCS

declare -r WORKDIR=$LOCAL_WORKDIR/$PREFIX/soapdenova2-local
declare -r LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX
declare -r LOCAL_READSDIR=$LOCAL_DATA/$READDIR
mkdir -p $WORKDIR
mkdir -p $LOCAL_RESULTDIR


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
	-v $LOCAL_READSDIR:/reads:ro \
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

cp $WORKDIR/$PREFIX.contig $LOCAL_RESULTDIR/sc${PREFIX}i.fasta
cp $WORKDIR/$PREFIX.scafSeq $LOCAL_RESULTDIR/ss${PREFIX}i.fasta

echo $PREFIX SOAP2: FINISHED!! soapdenovo2$PREFIX FINISHED!!
# /home/shepperp/datashare/Piers/github/ncycseqpipe/SOAPdenovo2/run_soapdenovo2.sh NCYC22 NCYC22/NCYC22.FP.fastq NCYC22/NCYC22.RP.fastq 
