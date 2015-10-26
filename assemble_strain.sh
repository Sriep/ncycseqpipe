#!/bin/bash
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

source $CONFIGFILE
readonly SSH_RESULTDIR
readonly DO_LOCAL_ABYSS_ASSEMBLY
readonly DO_SSH_ABYSS_ASSEMBLY
readonly DO_LOCAL_SOAPDENOVO2_ASSEMBLY
readonly DO_SSH_SOAPDENOVO2_ASSEMBLY
readonly DO_WGS
readonly DO_PCACTUS
readonly DO_RAGOUT

echo $PREFIX: source directory $SOURCEDIR
echo $PREFIX: SSH result path $SSH_RESULTDIR
echo $PREFIX: Read directory $READDIR

echo $PREFIX: ************************************ Abyss ************************************
if [ "$DO_LOCAL_ABYSS_ASSEMBLY" = true ]; then 
	echo $PREFIX: start abyss local assembly
	$SOURCEDIR/abyss/run_abyss_local.sh $PREFIX $READS1 $READS2 &
	PID_ABYSS_LOCAL=$!
	echo $PREFIX: Abyss local had pid $PID_ABYSS_LOCAL
fi

if [ "$DO_SSH_ABYSS_ASSEMBLY" = true ]; then 
	echo $PREFIX: start abyss assembly over ssh link to $SSH_USERID@$SSH_ADDR
	ABYSS_SSH_REPORTFILE=$SSH_RESULTDIR_PATH/$PREFIX/bsub_Abyss.log
	ssh -i $SSH_KEYFILE $SSH_USERID@$SSH_ADDR bsub -o $ABYSS_SSH_REPORTFILE $SOURCEDIR/abyss/run_abyss_ssh.sh $PREFIX $READS1 $READS2 
fi

echo $PREFIX: ************************************ SOAPdenovo2 ************************************
if [ "$DO_LOCAL_SOAPDENOVO2_ASSEMBLY" = true ]; then 
	echo $PREFIX: start SOAPdenovo2 local assembly
	$SOURCEDIR/SOAPdenovo2/run_soapdenovo2_local.sh $PREFIX $READS1 $READS2 &
	PID_SOAP_LOCAL=$! 
	echo $PREFIX: SOAPdenovo2 local had pid $PID_SOAP_LOCAL
fi

if [ "$DO_SSH_SOAPDENOVO2_ASSEMBLY" = true ]; then 
	echo start SOAPdenovo2 assembly over ssh link to $SSH_USERID@$SSH_ADDR
	SOAP2_SSH_REPORTFILE=$SSH_RESULTDIR_PATH/$PREFIX/bsub_SOAP.log
	ssh -i $SSH_KEYFILE $SSH_USERID@$SSH_ADDR bsub -o $SOAP2_SSH_REPORTFILE $SOURCEDIR/SOAPdenovo2/run_soapdenovo2_ssh.sh $PREFIX $READS1 $READS2 
fi

echo $PREFIX: ************************************ wgs ************************************
if [ "$DO_WGS" = true ]; then 
	echo $PREFIX: start wgs assembly
	$SOURCEDIR/wgs-8.3rc2/run_wgs.sh $PREFIX $READS1 $READS2 &
	PID_WGS=$!
	echo $PREFIX: wgs had pid $PID_WGS
fi

echo $PREFIX: ************************************ Waiting ************************************
# while still waiting for files to be uploaded sleep
wait $PID_ABYSS_LOCAL $PID_WGS $PID_SOAP_LOCAL

echo $PREFIX: About to wait for assemblies for finish
while ( ( [[ "$DO_SSH_ABYSS_ASSEMBLY" = true ]] && [[ ! -e $ABYSS_SSH_REPORTFILE ]] ) ); do
#		|| ( [[ "$DO_SSH_SOAPDENOVO2_ASSEMBLY" = true ]] && [[ ! -e $SOAP2_SSH_REPORTFILE ]] ) )
	echo $PREFIX: waiting for SSH assemblies
	ls $SSH_RESULTDIR_PATH/$PREFIX
	sleep 30s
done

echo $PREFIX: Assemblies sent off !!!!!!!!!!!!!!

echo $PREFIX: ************************************ scaffolding ************************************

echo $PREFIX: ************************************ progressive cactus ************************************
# progressive cactus on results
echo $PREFIX: Check to see if progessive cactus is required
if [ "DO_PCACTUS" = true ]; then
	echo $PREFIX: run progressive cactus
	$SOURCEDIR/progressiveCactus/run_progressive_cactus.sh $PREFIX 
	echo $PREFIX: finished running progressive cactus
fi

echo $PREFIX: ************************************ ragout ************************************
# Ragout on results
echo $PREFIX: check to see if regout is required
if [ "DO_RAGOUT" = true ]; then
	echo $PREFIX: run ragout
	$SOURCEDIR/ragout/run_ragout.sh $PREFIX 
	echo $PREFIX: finished running ragout
fi

# Metrics?
# Yippee!!
echo $PREFIX: Finished!!!!!!!!!!!!
#docker rm $(docker ps -a -q)
# /home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_strain.sh NCYC22 NCYC22/NCYC22.FP.fastq NCYC22/NCYC22.RP.fastq
#PREFIX=NCYC22
#READS1=NCYC22/NCYC22.FP.fastq
#READS2=NCYC22/NCYC22.RP.fastq
