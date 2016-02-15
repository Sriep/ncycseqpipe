#!/bin/bash
source hpccore-5
source bowtie2-2.2.5
source samtools-1.0
source jdk-1.7.0_25
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
debug_msg  ${LINENO} "BOWTIE2 ssh: about to run ssh bowtie2 on $TEMPLATE"


debug_msg  ${LINENO} "bowtie2-build $TEMPLATE $WORKDIR/$PREFIX"
bowtie2-build $TEMPLATE $WORKDIR/$PRFIX_STUB

debug_msg  ${LINENO} "about to run bowtie"
bowtie2   --mm \
          --no-mixed \
          -x $WORKDIR/$PRFIX_STUB \
          -1 $SSH_READSDIR/$READS1 \
          -2 $SSH_READSDIR/$READS2 \
          > $WORKDIR/${PRFIX_STUB}_${TOOL_TAG}.sam 
samtools view -bS $WORKDIR/${PRFIX_STUB}_${TOOL_TAG}.sam  \
 | samtools sort /dev/stdin $WORKDIR/${PRFIX_STUB}_${TOOL_TAG}

debug_msg  ${LINENO} "about to run samtools index"
samtools index $WORKDIR/${PRFIX_STUB}_${TOOL_TAG}.bam

#Give location of result files
#METRICS_CSV=$WORKDIR/${PRFIX_STUB}_${TOOL_TAG}.bam
debug_msg  ${LINENO} "About to copy result files"
mv $WORKDIR/${PRFIX_STUB}_${TOOL_TAG}.sam $SSH_RESULTDIR/${PRFIX_STUB}_${TOOL_TAG}.sam
#
cp $WORKDIR/${PRFIX_STUB}_${TOOL_TAG}.bam $SSH_RESULTDIR/${PRFIX_STUB}_${TOOL_TAG}.bam 
cp $WORKDIR/${PRFIX_STUB}_${TOOL_TAG}.bam.bai $SSH_RESULTDIR/${PRFIX_STUB}_${TOOL_TAG}.bai

#-------------------------- Assembly specific code here --------------------

#cp $METRICS_CSV $SSH_RESULTDIR/m_${PRFIX_STUB}_${TOOL_TAG}

#cp $CONTIGS $SSH_RESULTDIR/${ASSEMBLY_TAG}c${PREFIX}i.fasta
#cp $SCAFFOLDS $SSH_RESULTDIR/${ASSEMBLY_TAG}s${PREFIX}i.fasta
echo `basename "$0"`: FINISHED!! FINISHED!!
