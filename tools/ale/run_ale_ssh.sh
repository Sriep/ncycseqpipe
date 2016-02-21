#!/bin/bash
# 
source hpccore-5
source ale-0.9
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
declare -r SAMFILE=$SSH_RESULTDIR/${PRFIX_STUB}_bow2.sam
declare -r BAMFILE=$SSH_RESULTDIR/${PRFIX_STUB}_bow2.bam

cd  $WORKDIR
debug_msg  ${LINENO} "about to run ale"
debug_msg  ${LINENO} "bamfile  $BAMFILE"

ALE $BAMFILE $TEMPLATE $WORKDIR/$TEMPLATE.ale

debug_msg  ${LINENO} "finished ale"
#Give location of result files
METRICS=$WORKDIR/$TEMPLATE.ale

#-------------------------- Assembly specific code here --------------------
source $SOURCEDIR/tools/ssh_footer.sh
