#!/bin/bash
source /home/shepperp/datashare/Piers/github/ncycseqpipe/ncycseqpipe.cfg
# runProgressiveCactus.sh
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
PREFIX=$1

RESULTDIR=$LOCAL_RESULTDIR/$PREFIX
WORKDIR=$LOCAL_RESULTDIR/$PREFIX/progressiveCactus
mkdir -p $WORKDIR

# Create the pressive cactus configurartion file
rm $WORKDIR/$PREFIX.cactus.squ
touch $WORKDIR/$PREFIX.cactus.squ
for f in $LOCAL_RESULTDIR/$PREFIX/*.fasta
do
	echo $(basename "$f" .fasta) $f >> $WORKDIR/$PREFIX.cactus.squ
done
echo Here is progressive cactus sequence file for $PREFIX
cat $WORKDIR/$PREFIX.cactus.squ

docker run --name progressivecactus$PREFIX  \
	-v $RESULTDIR:/workdir \
	-v $WORKDIR:/results \
	sriep/progressivecactus \
		--maxThreads $PCACTUS_THREADS \
		 /results/$PREFIX.cactus.squ \
		 /workdir \
		 /results/$PREFIX.hal 
PCACTUS_DONE=$?

#https://github.com/glennhickey/progressiveCactus
#runProgressiveCactus.sh [options] <seqFile> <workDir> <outputHalFile>