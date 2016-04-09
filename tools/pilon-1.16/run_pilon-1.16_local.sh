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

debug_msg  ${LINENO} "Start run_pilon1.16"

declare -r PILONPATH=/nbi/software/testing/pilon/1.16/x86_64/bin
cd  $WORKDIR
readonly TARGET=${args[0]}${args[1]}${PREFIX}i
debug_msg  ${LINENO}  "target is $TARGET"

declare -a args=( "" "" "" "" "" "" "" )
IFS=' ' read -ra args <<< "$PARAMETERS"
debug_msg  ${LINENO} "arguments ${args[@]/#/}"
debug_msg  ${LINENO} "target=${TARGET}"
debug_msg  ${LINENO} "data $LOCAL_RESULTDIR"
debug_msg  ${LINENO} "result dir $WORKDIR"
debug_msg  ${LINENO} "output $WORKDIR/${TARGET}/${TARGET}_pilon.fasta"

debug_msg  ${LINENO} "docker run 	--name pilon-1.16$PREFIX 	-v $LOCAL_RESULTDIR:/data:ro 	-v $WORKDIR:/results   sriep/pilon-1.16  -jar /pilon-1.16.jar  --genome $data/${TARGET}.fasta    --frags $data/${TARGET}/${TARGET}_bow2.bam   --output /results$/${TARGET}_pilon.fasta   ${args[2]} ${args[3]} ${args[4]} ${args[5]} ${args[6]} "

docker run \
	--name pilon-1.16$PREFIX  \
	-v $LOCAL_RESULTDIR:/data:ro \
	-v $WORKDIR:/results \
  sriep/pilon-1.16 \
  -jar /pilon-1.16.jar \
  --genome "/data/${TARGET}.fasta"  \
  --frags "/data/${TARGET}/${TARGET}_bow2.bam" \
  --output "/results/${TARGET}_pilon" \
  ${args[2]} ${args[3]} ${args[4]} ${args[5]} ${args[6]} 
remove_docker_container pilon-1.16$PREFIX

SCAFFOLDS="$WORKDIR/${TARGET}_pilon.fasta"
#-------------------------- Footer --------------------

source $SOURCEDIR/tools/local_footer.sh

