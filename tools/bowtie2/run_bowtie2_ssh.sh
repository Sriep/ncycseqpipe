#!/bin/bash
source hpccore-5
source bowtie2-2.2.5
source samtools-1.0
source jdk-1.7.0_25
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
echo BOWTIE2 ssh: about to run ssh bowtie2 on $TEMPLATE


echo about to run bowtie2-build
echo "bowtie2-build $TEMPLATE $WORKDIR/$PREFIX"
bowtie2-build $TEMPLATE $WORKDIR/$PRFIX_STUB
echo
echo
echo In run_bowtie2_ssh.sh
echo about to run bowtie
bowtie2   --mm \
          --no-mixed \
          -x $WORKDIR/$PRFIX_STUB \
          -1 $SSH_READSDIR/$READS1 \
          -2 $SSH_READSDIR/$READS2 \
          > $WORKDIR/${PRFIX_STUB}_BOW2.sam 
samtools view -bS $WORKDIR/${PRFIX_STUB}_BOW2.sam  \
 | samtools sort /dev/stdin $WORKDIR/${PRFIX_STUB}_BOW2_sorted     
          
#          > $WORKDIR/${PRFIX_STUB}_BOW2.sam \
#  | samtools view -bS - \
#  | samtools sort /dev/stdin $WORKDIR/${PRFIX_STUB}_BOW2_sorted
echo about to run samtools index
samtools index $WORKDIR/${PRFIX_STUB}_BOW2_sorted.bam

#Give location of result files
METRICS_CSV=$WORKDIR/${PRFIX_STUB}_BOW2_sorted.bam
mv $WORKDIR/${PRFIX_STUB}_BOW2.sam $SSH_RESULTDIR/${PRFIX_STUB}_BOW2.sam

#-------------------------- Assembly specific code here --------------------

cp $METRICS_CSV $SSH_RESULTDIR/m_${PRFIX_STUB}_${TOOL_TAG}

#cp $CONTIGS $SSH_RESULTDIR/${ASSEMBLY_TAG}c${PREFIX}i.fasta
#cp $SCAFFOLDS $SSH_RESULTDIR/${ASSEMBLY_TAG}s${PREFIX}i.fasta
echo `basename "$0"`: FINISHED!! FINISHED!!
