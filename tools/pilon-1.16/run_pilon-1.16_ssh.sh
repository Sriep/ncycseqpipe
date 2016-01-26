#!/bin/bash
# 
source hpccore-5
source bowtie2-2.2.5
source samtools-1.0
source jdk-1.7.0_25
source pilon-1.16 
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
debug_msg  ${LINENO} "Start run_pilon1.16"
declare -r PILONPATH=/nbi/software/testing/pilon/1.16/x86_64/bin
cd  $WORKDIR

declare -a args=( "" "" "" "" "" "" "" )
IFS=' ' read -ra args <<< "$PARAMETERS"
debug_msg  ${LINENO} "arguments ${args[@]/#/}"
debug_msg  ${LINENO} "about to run pilon"

debug_msg  ${LINENO} "about to run pilon"
java -jar $PILONPATH/pilon-1.16.jar \
  --genome "$SSH_RESULTDIR/${args[0]}.fasta"  \
  --frags $SSH_RESULTDIR/${args[0]}/${args[0]}_bow2.bam \
  --output "$SSH_RESULTDIR/${args[0]}_p.fasta" \
   ${args[1]} ${args[2]} ${args[3]} ${args[4]} ${args[5]} ${args[6]} 
#Give location of result files
#METRICS_CSV=$WORKDIR/out.txt
debug_msg  ${LINENO} "Finished run_pilon1.16"
#-------------------------- Assembly specific code here --------------------

cp $METRICS_CSV $SSH_RESULTDIR/m_${PRFIX_STUB}_${TOOL_TAG}

#cp $CONTIGS $SSH_RESULTDIR/${ASSEMBLY_TAG}c${PREFIX}i.fasta
#cp $SCAFFOLDS $SSH_RESULTDIR/${ASSEMBLY_TAG}s${PREFIX}i.fasta
echo `basename "$0"`: FINISHED!! FINISHED!!
