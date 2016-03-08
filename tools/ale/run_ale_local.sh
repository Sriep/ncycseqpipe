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
declare -r SAMFILE=$LOCAL_RESULTDIR/${PRFIX_STUB}_bow2.sam
declare -r BAMFILE=$LOCAL_RESULTDIR/${PRFIX_STUB}_bow2.bam

declare -a args=( "" "" "" "" "" )
IFS=' ' read -ra args <<< "$PARAMETERS"
debug_msg  ${LINENO} "arguments ${args[@]/#/}"

template_basename=$(basename $TEMPLATE)
cp $TEMPLATE $LOCAL_RESULTDIR/$template_basename
debug_msg  ${LINENO}  "teamplate at $LOCAL_RESULTDIR/$template_basename"
debug_msg  ${LINENO} "about to run ale"
docker run \
	--name ale$PREFIX  \
	-v $LOCAL_RESULTDIR:/datadir:ro \
	-v $WORKDIR:/results \
	sriep/ale \
		/datadir/${PRFIX_STUB}_bow2.bam \
		/datadir/$template_basename \
		/results/$template_basename.ale
remove_docker_container ale$PREFIX

debug_msg  ${LINENO} "finished ale"
#Give location of result files
firstline=$(head -n 1 "$WORKDIR/$TEMPLATE.ale")
outfile="$WORKDIR/$TEMPLATE.csv"
echo $firstline > $outfile
METRICS="$outfile"

#-------------------------- Assembly specific code here --------------------
source $SOURCEDIR/tools/local_footer.sh
