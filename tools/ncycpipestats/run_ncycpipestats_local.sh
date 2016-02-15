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
#-------------------------- Assembly specific code here --------------------

debug_msg  ${LINENO} "ncycpipestats"
debug_msg  ${LINENO} "arguments ${args[@]/#/}"

mkdir $LOCAL_RESULTDIR/Docs
docker run \
	--name ncycpipestats$PREFIX  \
	-v $LOCAL_RESULTDIR:/results \
	sriep/ncycpipestats /results \    
		${args[0]}  ${args[1]} ${args[2]} ${args[3]} ${args[4]} 
remove_docker_container ncycpipestats$PREFIX

#-------------------------- Footer --------------------
source $SOURCEDIR/local_footer.sh

