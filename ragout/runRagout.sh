#!/bin/bash
source /home/shepperp/datashare/Piers/github/ncycseqpipe/ncycseqpipe.cfg
# runPRagpit.sh
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
PREFIX=$1

RESULTDIR=$LOCAL_RESULTDIR/$PREFIX
WORKDIR=$LOCAL_RESULTDIR/$PREFIX/progressiveCactus
mkdir -p $WORKDIR

# Create the ragout configurartion file
rm $WORKDIR/$PREFIX.ragout.recipe
touch $WORKDIR/$PREFIX.ragout.recipe
echo *.draft = true >> $WORKDIR/$PREFIX.ragout.recipe
echo -n .references >> $WORKDIR/$PREFIX.ragout.recipe
for f in $LOCAL_RESULTDIR/$PREFIX/*.fasta
do
	echo -n $(basename "$f" .fasta), $f >> $WORKDIR/$PREFIX.ragout.recipe
done
#remove trailing commma
sed -i '$s/,$//' $WORKDIR/$PREFIX.ragout.recipe
echo .target = ac${PREFIX}i  >> $WORKDIR/$PREFIX.ragout.recipe
echo .hal = $PREFIX.hal >> $WORKDIR/$PREFIX.ragout.recipe

echo Here is progressive ragout sequence file for $PREFIX
cat $WORKDIR/$PREFIX.ragout.recipe

docker run --name ragoutpy$PREFIX  \
	-v $RESULTDIR:/workdir \
	-v $WORKDIR:/results \
	sriep/ragoutpy \
		--maxThreads $PCACTUS_THREADS \
		 /results/$PREFIX.ragout.recipe \
		 /workdir \
		 /results/$PREFIX.hal 
RAGOUT_DONE=$?

#https://github.com/glennhickey/progressiveCactus
#runProgressiveCactus.sh [options] <seqFile> <workDir> <outputHalFile>