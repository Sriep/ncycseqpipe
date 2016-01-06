#!/bin/bash
# 
declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/local_header.sh
# PREFIX - Name of strain to assemble
# READS1 - First set of paired end reads, relative to $LOCAL_READSDIR
# READS2 - Second set of paired end reads, relative to $LOCAL_READSDIR
# TOOL_TAG - Tag to indicate the output from this tool
# PARAMETERS - Data used to paramatirse this tool
#
# WORKDIR - Directory in which to put tempory work files
# READSDIR - Directory where paired end reads are located
# LOCAL_RESULTDIR - Directory where results are to be copied
#-------------------------- Assembly specific code here --------------------

#function clean_fasta  ()
#{
#      sed -i 's/[^a-zA-Z0-9_:.>]/_/g' $1
#}

#rm $WORKDIR/$PREFIX.cactus.seq || true
#touch $WORKDIR/$PREFIX.cactus.seq
> $WORKDIR/$PREFIX.cactus.seq

for f in $LOCAL_RESULTDIR/*.fasta; do
  echo $(basename "$f" .fasta) "/results/"`basename $f` >> $WORKDIR/$PREFIX.cactus.seq
done

echo $PREFIX PCacuts:  Here is progressive cactus sequence file for $PREFIX
cat $WORKDIR/$PREFIX.cactus.seq
echo $PREFIX PCacuts: Finished sequence file about to run progressiveCactus 
docker run --name progressivecactus$PREFIX  \
	-v $WORKDIR:/workdir \
	-v $LOCAL_RESULTDIR:/results \
	sriep/progressivecactus \
		--maxThreads 40 \
		 /workdir/$PREFIX.cactus.seq \
		 /workdir \
		 /results/$PREFIX.hal 
remove_docker_container progressivecactus$PREFIX

#$METRICS=$LOCAL_RESULTDIR/$PREFIX.hal

#https://github.com/glennhickey/progressiveCactus
#runProgressiveCactus.sh [options] <seqFile> <workDir> <outputHalFile>

#-------------------------- Assembly specific code here --------------------
source $SOURCEDIR/local_footer.sh
