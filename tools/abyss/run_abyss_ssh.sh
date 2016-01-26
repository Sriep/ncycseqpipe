#!/bin/bash
# 
source hpccore-5
source abyss-1.9.0
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
#-------------------------- Assembly specific code here --------------------
echo ABYSS ssh: about to run ssh abyss on $PREFIX with parameters "$PARAMETERS"

declare -a args=( "" "" "" "" "" )
IFS=' ' read -ra args <<< "$PARAMETERS"
echo "arguments ${args[@]/#/}"

abyss-pe \
		${args[0]}  ${args[1]} ${args[2]} ${args[3]} ${args[4]} \
		name=$WORKDIR/$PREFIX \
		in="$SSH_READSDIR/$READS1 $SSH_READSDIR/$READS2"

#Give location of result files
CONTIGS=$WORKDIR/$PREFIX-6.fa
SCAFFOLDS=$WORKDIR/$PREFIX-8.fa
#-------------------------- Assembly specific code here --------------------

source $SOURCEDIR/ssh_footer.sh
