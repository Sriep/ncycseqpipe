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
debug_msg  ${LINENO} "/home/shepperp/software/ncycseqpipe/Cpp/ncycpipestats/ncycpipestats $LOCAL_RESULTDIR &"
/home/shepperp/software/ncycseqpipe/Cpp/ncycpipestats/ncycpipestats $LOCAL_RESULTDIR &
# docker run \
#	--name ncycpipestats$PREFIX  \
#	-v $LOCAL_RESULTDIR:/results \
#	sriep/ncycpipestats /results \    
#		${args[0]}  ${args[1]} ${args[2]} ${args[3]} ${args[4]} 
# remove_docker_container ncycpipestats$PREFIX

# docker run --name ncycp -v /home/shepperp/datashare/Piers/assemblies/UnitTest1/NCYC22:/results sriep/ncycpipestats /results
# docker run --name ncycp -v /home/shepperp/datashare/Piers/assemblies/UnitTest1/NCYC22:/results sriep/ncycpipestats ncycpipestats  /results
# docker run --name ncycp -v /home/shepperp/datashare/Piers/assemblies/UnitTest1/NCYC22:/results --entrypoint="ncycpipestats" sriep/ncycpipestats   /results
#-------------------------- Footer --------------------
source $SOURCEDIR/local_footer.sh

