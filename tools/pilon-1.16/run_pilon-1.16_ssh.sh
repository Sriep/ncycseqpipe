#!/bin/bash
# 
source hpccore-5
source bowtie2-2.2.5
source samtools-1.0
source jdk-1.7.0_25
source pilon-1.16 
declare -r SOURCEDIR="$1"
source $SOURCEDIR/tools/ssh_header.sh
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
debug_msg  ${LINENO} "geonme $SSH_RESULTDIR/${args[0]}.fasta"
debug_msg  ${LINENO} "mapping file $SSH_RESULTDIR/${TARGET}/${TARGET}_bow2.bam"
debug_msg  ${LINENO} "result dir $WORKDIR"
debug_msg  ${LINENO} "output ${WORKDIR}${TARGET}_pilon.fasta"

java -jar $PILONPATH/pilon-1.16.jar \
  --genome "$SSH_RESULTDIR/${TARGET}.fasta"  \
  --frags $SSH_RESULTDIR/${TARGET}/${TARGET}_bow2.bam \
  --output "${WORKDIR}${TARGET}_pilon.fasta" \
  ${args[2]} ${args[3]} ${args[4]} ${args[5]} ${args[6]} 

debug_msg  ${LINENO} "Finished run_pilon1.16"
#-------------------------- Assembly specific code here --------------------
source $SOURCEDIR/tools/ssh_footer.sh
echo `basename "$0"`: FINISHED!! FINISHED!!
