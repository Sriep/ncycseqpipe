#!/bin/bash
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
PREFIX=$1
READS1=$2
READS2=$3

source /home/shepperp/datashare/Piers/github/ncycseqpipe/ncycseqpipe.cfg
echo $PREFIX: Docker directory $DOCKERDIR
echo $PREFIX: SSH result path $SSH_RESULTDIR
echo $PREFIX: Local result path $LOCAL_RESULTDIR
echo $PREFIX: Read directory $READDIR

echo $PREFIX: ************************************ Abyss ************************************
if [ "$DO_LOCAL_ABYSS_ASSEMBLY" = true ] 
then 
	echo $PREFIX: start abyss local assembly
	$DOCKERDIR/abyss/runAbyssLocal.sh $PREFIX $READS1 $READS2 &
	PID_ABYSS_LOCAL=$!
	echo $PREFIX: Abyss local had pid $PID_ABYSS_LOCAL
fi

if [ "$DO_SSH_ABYSS_ASSEMBLY" = true ] 
then 
	echo $PREFIX: start abyss assembly over ssh link to $SSH_USERID@$SSH_ADDR
	ABYSS_SSH_REPORTFILE=$SSH_RESULTDIR_PATH/$PREFIX/bsub_Abyss.log
	ssh -i $SSH_KEYFILE $SSH_USERID@$SSH_ADDR bsub -o $ABYSS_SSH_REPORTFILE $DOCKERDIR/abyss/runAbyssSSH.sh $PREFIX $READS1 $READS2 
fi

echo $PREFIX: ************************************ SOAPdenovo2 ************************************
if [ "$DO_LOCAL_SOAPDENOVO2_ASSEMBLY" = true ] 
then 
	echo $PREFIX: start SOAPdenovo2 local assembly
	$DOCKERDIR/SOAPdenovo2/runSOAPdenovo2.sh $PREFIX $READS1 $READS2 &
	PID_SOAP_LOCAL=$!
	echo $PREFIX: SOAPdenovo2 local had pid $PID_SOAP_LOCAL
fi

if [ "$DO_SOAP_SOAPDENOVO2_ASSEMBLY" = true ] 
then 
	echo start SOAPdenovo2 assembly over ssh link to $SSH_USERID@$SSH_ADDR
	SOAP2_SSH_REPORTFILE=$SSH_RESULTDIR_PATH/$PREFIX/bsub_SOAP.log
	ssh -i $SSH_KEYFILE $SSH_USERID@$SSH_ADDR bsub -o $SOAP2_SSH_REPORTFILE $DOCKERDIR/SOAPdenovo2/runSOAPdenovo2SSH.sh $PREFIX $READS1 $READS2 
fi

echo $PREFIX: ************************************ wgs ************************************
if [ "$DO_WGS" = true ] 
then 
	echo $PREFIX: start wgs assembly
	$DOCKERDIR/wgs-8.3rc2/runwgs.sh $PREFIX $READS1 $READS2 &
	PID_WGS=$!
	echo $PREFIX: wgs had pid $PID_WGS
fi

echo $PREFIX: ************************************ Waiting ************************************
# while still waiting for files to be uploaded sleep
wait $PID_ABYSS_LOCAL $PID_WGS $PID_SOAP_LOCAL

echo $PREFIX: About to wait for assemblies for finish
while ( ( [[ "$DO_SSH_ABYSS_ASSEMBLY" = true ]] && [[ ! -e $ABYSS_SSH_REPORTFILE ]] ) 
		|| ( [[ "$DO_SSH_SOAPDENOVO2_ASSEMBLY" = true ]] && [[ ! -e $SOAP2_SSH_REPORTFILE ]] ) )
do
	echo $PREFIX: waiting for SSH assemblies
	ls $SSH_RESULTDIR_PATH/$PREFIX
	sleep 30s
done

echo $PREFIX: Assemblies sent off !!!!!!!!!!!!!!

echo $PREFIX: ************************************ scaffolding ************************************

echo $PREFIX: ************************************ progressive cactus ************************************
# progressive cactus on results
echo $PREFIX: Check to see if progessive cactus is required
if [ "DO_PCACTUS" = true ]
then
	echo $PREFIX: run progressive cactus
	$DOCKERDIR/progressiveCactus/runProgressiveCactus.sh $PREFIX 
	echo $PREFIX: finished running progressive cactus
fi

echo $PREFIX: ************************************ ragout ************************************
# Ragout on results
echo $PREFIX: check to see if regout is required
if [ "DO_RAGOUT" = true ]
then
	echo $PREFIX: run ragout
	$DOCKERDIR/progressiveCactus/runProgressiveCactus.sh $PREFIX 
	echo $PREFIX: finished running ragout
fi

# Metrics?
# Yippee!!
echo $PREFIX: Finished!!!!!!!!!!!!
#docker rm $(docker ps -a -q)
# /home/shepperp/datashare/Piers/github/ncycseqpipe/assembleStrain.sh NCYC22 NCYC22/NCYC22.FP.fastq NCYC22/NCYC22.RP.fastq
#PREFIX=NCYC22
#READS1=NCYC22/NCYC22.FP.fastq
#READS2=NCYC22/NCYC22.RP.fastq
