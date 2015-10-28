#!/bin/bash
echo runProgressiveCactus.sh
# $1 Prefix e.g. NCYC93
declare -r PREFIX=$1

source $CONFIGFILE
readonly LOCAL_RESULTDIR
readonly LOCAL_WORKDIR
declare -r WORKDIR=$LOCAL_WORKDIR/$PREFIX/progressiveCactus
mkdir -p $WORKDIR

# Create the pressive cactus configurartion file
echo $PREFIX "PCacuts: Here is the workdirectory $WORKDIR"
echo $PREFIX "PCacuts: Here is the local result directory $LOCAL_RESULTDIR"

rm $WORKDIR/$PREFIX.cactus.seq
touch $WORKDIR/$PREFIX.cactus.seq

for f in $LOCAL_RESULTDIR/$PREFIX/*.fasta; do
  echo $(basename "$f" .fasta) "/results/"`basename $f` >> $WORKDIR/$PREFIX.cactus.seq
done

echo $PREFIX PCacuts:  Here is progressive cactus sequence file for $PREFIX
cat $WORKDIR/$PREFIX.cactus.seq
echo $PREFIX PCacuts: Finished sequence file about to run progressiveCactus 
docker run --name progressivecactus$PREFIX  \
	-v $WORKDIR:/workdir \
	-v $LOCAL_RESULTDIR/$PREFIX:/results \
	sriep/progressivecactus \
		--maxThreads $PCACTUS_THREADS \
		 /workdir/$PREFIX.cactus.seq \
		 /workdir \
		 /results/$PREFIX.hal 
echo $PREFIX PCacuts: progressivecactus return code is $?
docker rm -f progressivecactus$PREFIX 
echo $PREFIX PCacuts: progressivecactus$PREFIX  stopped

#https://github.com/glennhickey/progressiveCactus
#runProgressiveCactus.sh [options] <seqFile> <workDir> <outputHalFile>