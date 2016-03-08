#!/bin/bash 
# 
declare -r SOURCEDIR="$1"
source $SOURCEDIR/tools/local_header.sh
# PREFIX - Name of strain to assemble
# READS1 - First set of paired end reads, relative to $LOCAL_READSDIR
# READS2 - Second set of paired end reads, relative to $LOCAL_READSDIR
# TOOL_TAG - Tag to indicate the output from this tool
# PARAMETERS - Data used to paramatirse this tool
#
# WORKDIR - Directory in which to put tempory work files
# READSDIR - Directory where paired end reads are located
#-------------------------- Assembly specific code here --------------------

debug_msg  ${LINENO} "ABYSS: about to run local abyss on $PREFIX"

#declare -a args=( "" "" "" "" "" )
#IFS=' ' read -ra args <<< "$PARAMETERS"
debug_msg  ${LINENO} "arguments ${args[@]/#/}"

docker run \
	--name abyss$PREFIX  \
	-v $READSDIR:/reads:ro \
	-v $WORKDIR:/results \
	sriep/abyss-pe \
		${args[0]}  ${args[1]} ${args[2]} ${args[3]} ${args[4]} \
		name=/results/$PREFIX \
		in="/reads/$READS1 /reads/$READS2"
remove_docker_container abyss$PREFIX

CONTIGS=$WORKDIR/$PREFIX-6.fa
SCAFFOLDS=$WORKDIR/$PREFIX-8.fa
#-------------------------- Footer --------------------

source $SOURCEDIR/tools/local_footer.sh

