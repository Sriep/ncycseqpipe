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

debug_msg  ${LINENO} "Canu: about to run local canu on $PREFIX"
debug_msg  ${LINENO} "arguments ${args[@]/#/}"

docker run \
	--name canu$PREFIX  \
	-v $READSDIR:/reads:ro \
	-v $WORKDIR:/results \
	sriep/canu \
    -p $PREFIX \
    -d /results \
		${args[0]} \
    -pacbio-raw /reads/$READSPB
remove_docker_container canu$PREFIX

SCAFFOLDS=$WORKDIR/$PREFIX.contigs.fasta
#-------------------------- Footer --------------------
source $SOURCEDIR/tools/local_footer.sh

