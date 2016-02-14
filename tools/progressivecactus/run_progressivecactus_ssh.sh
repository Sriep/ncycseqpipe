#!/bin/bash
# 
source hpccore-5
source progressiveCactus-0.0
declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/ssh_header.sh
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

> $WORKDIR/$PREFIX.cactus.seq

for f in $SSH_RESULTDIR/*.fasta; do
  echo $(basename "$f" .fasta) "$WORKDIR/"$(basename $f) >> $WORKDIR/$PREFIX.cactus.seq
  debug_msg  ${LINENO} "about to cp $f $WORKDIR/$(basename $f)" 
  cp $f $WORKDIR/$(basename $f)
  sed -i 's/[^a-zA-Z0-9_:.>]/_/g' $WORKDIR/$(basename $f)
done

declare -a args=( "" "" "" "" "" )
IFS=' ' read -ra args <<< "$PARAMETERS"
debug_msg  ${LINENO} "arguments ${args[@]/#/}"

debug_msg  ${LINENO} "Here is progressive cactus sequence file for $PREFIX"
cat $WORKDIR/$PREFIX.cactus.seq
debug_msg  ${LINENO} "PCacuts: Finished sequence file about to run progressiveCactus" 

runProgressiveCactus.sh \
		${args[0]}  ${args[1]} ${args[2]} ${args[3]} ${args[4]}  \
		 $WORKDIR/$PREFIX.cactus.seq \
		 $WORKDIR \
		 $SSH_RESULTDIR/$PREFIX.hal 


#docker run --name progressivecactus$PREFIX  \
#	-v $WORKDIR:/workdir \
#	-v $LOCAL_RESULTDIR:/results \
#	sriep/progressivecactus \
#		--maxThreads 40 \
#		 /workdir/$PREFIX.cactus.seq \
#		 /workdir \
#		 /results/$PREFIX.hal 
#remove_docker_container progressivecactus$PREFIX



#$METRICS=$LOCAL_RESULTDIR/$PREFIX.hal

#https://github.com/glennhickey/progressiveCactus
#runProgressiveCactus.sh [options] <seqFile> <workDir> <outputHalFile>

#-------------------------- Assembly specific code here --------------------
source $SOURCEDIR/ssh_footer.sh
