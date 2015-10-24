#!/bin/bash
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
PREFIX=$1
READS1=$2
READS2=$3

source /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/ncycseq.cfg
echo Docker directory $DOCKERDIR
echo SSH result path $SSH_RESULT_PATH
echo Local result path $LOCAL_RESULT_PATH
echo Read directory $READDIR

if [ "$DO_LOCAL_ABYSS_ASSEMBLY" = true ] 
then 
	export ABYSS_LOCAL_DONE=false
	$DOCKERDIR/abyss-1.9.0/runAbyssLocal.sh $PREFIX $READS1 $READS2
fi

if [ "$DO_SSH_ABYSS_ASSEMBLY" = true ] 
then 
	export ABYSS_SSH_DONE=false
	$DOCKERDIR/abyss-1.9.0/runAbyssSSH.sh $PREFIX $READS1 $READS2
fi

if [ "$DO_WGS" = true ] 
then 
	export WGS_SSH_DONE=false
	$DOCKERDIR/wgs-8.3rc2/runwgs.sh $PREFIX $READS1 $READS2
fi

#scaffolding
# while still waiting for files to be uploaded sleep
while (  [[ "$ABYSS_LOCAL_DONE" = "false"  &&  "$DO_LOCAL_ABYSS_ASSEMBLY" = "ture" ]] \
		||  [[ "$ABYSS_SSH_DONE" = "false"  &&  "$DO_SSH_ABYSS_ASSEMBLY" = "true" ]]  \
		||  [[ "$WGS_SSH_DONE" = "false"  &&  "$DO_WGS" = "true" ]]  \
)
do
	#echo abyss local done = $ABYSS_LOCAL_DONE
	sleep 1m
done

# scaffolding
# progressive cactus on results
# create sequece file


# Ragout on results
# Metrics?
# Yippee!!
#
# /home/shepperp/datashare/Piers/github/ncycseqpipe/assembleStrain.sh NCYC93 NCYC93/NCYC93.FP.fastq NCYC93/NCYC93.RP.fastq 
