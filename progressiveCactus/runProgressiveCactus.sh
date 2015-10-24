#!/bin/bash
# runProgressiveCactus.sh
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
PREFIX=$1

source /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/ncycseq.cfg
RESULTDIR=$LOCAL_RESULT_PATH/$PREFIX
WORKDIR=$LOCAL_RESULT_PATH/$PREFIX/progressiveCactus
mkdir -p $WORKDIR

# Create the pressive cactus configurartion file
rm $WORKDIR/$PREFIX.cactus.squ
touch $WORKDIR/$PREFIX.cactus.squ
for f in $LOCAL_RESULT_PATH/$PREFIX/*.fasta
do
	echo $(basename "$f" .fasta) $f >> $WORKDIR/$PREFIX.cactus.squ
done

docker run --name progressivecactus$PREFIX  \
	-v $RESULTDIR:/workdir \
	-v $WORKDIR:/results \
	progressivecactus \
		--maxThreads $PCACTUS_THREADS \
		 /results/$PREFIX.cactus.squ \
		 /workdir \
		 /results/$PREFIX.hal 
PCACTUS_DONE=$?

#https://github.com/glennhickey/progressiveCactus
#runProgressiveCactus.sh [options] <seqFile> <workDir> <outputHalFile>