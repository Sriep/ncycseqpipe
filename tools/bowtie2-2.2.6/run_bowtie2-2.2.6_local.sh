#!/bin/bash
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
debug_msg  ${LINENO} "BOWTIE2 ssh: about to run ssh bowtie2 on $TEMPLATE"

template_basename=$(basename $TEMPLATE)
cp $TEMPLATE $LOCAL_RESULTDIR/$template_basename
prefix_tail_upper_case=$(basename $PREFIX)
prefix_tail="${prefix_tail_upper_case,,}"
debug_msg  ${LINENO} "prefix tail is  $prefix_tail"
debug_msg  ${LINENO} "bowtie2-build $TEMPLATE $WORKDIR/$PREFIX"
docker run \
	--name bowtie2-build$prefix_tail  \
	-v $LOCAL_RESULTDIR:/datadir:ro \
	-v $WORKDIR:/results \
  --entrypoint="bowtie2-build" \
	sriep/bowtie2-2.2.6 \
    /datadir/$template_basename \
    /results/$PRFIX_STUB
remove_docker_container bowtie2-build$prefix_tail

debug_msg  ${LINENO} "about to run samtools bowtie2"
debug_msg  ${LINENO} "local resutls dir $LOCAL_RESULTDIR"
debug_msg  ${LINENO}  "reads dir $READSDIR"
debug_msg  ${LINENO} "wordir $WORKDIR"
debug_msg  ${LINENO} "bowtieprefix tail is --name bowtie2$prefix_tail upper csee $prefix_tail_upper_case"
debug_msg  ${LINENO} "reads $READS1 reads2 $READS2 prefixstub $PRFIX_STUB tooltag $TOOL_TAG"

docker run  --name bowtie2$prefix_tail  -v $LOCAL_RESULTDIR:/datadir:ro \
  -v $READSDIR:/reads:ro \
  -v $WORKDIR:/results \
  --entrypoint="bowtie2" \
  sriep/bowtie2-2.2.6 \
    "--mm \
    --no-mixed \
    -x /results/$PRFIX_STUB \
    -1/reads/$READS1 \
    -2 /reads/$READS2 \
    > /results${PRFIX_STUB}_${TOOL_TAG}.sam" 
remove_docker_container bowtie2$prefix_tail    

debug_msg  ${LINENO} "bowtieprefix tail is --name bowtie2$prefix_tail upper csee $prefix_tail_upper_case"
debug_msg  ${LINENO} "about to run samtools view"
docker run --name view$prefix_tail  \
  -v $LOCAL_RESULTDIR:/datadir  \
  -v $READSDIR:/reads:ro \
  -v $WORKDIR:/results \
  --entrypoint="view" \
  sriep/samtools-1.3 \
    -bS \
    /results/${PRFIX_STUB}_${TOOL_TAG}.sam \
    /results/${PRFIX_STUB}_${TOOL_TAG}_unosrted.bam 
remove_docker_container view$prefix_tail 
    
docker run --name sort$prefix_tail  \
  -v $LOCAL_RESULTDIR:/datadir  \
  -v $READSDIR:/reads:ro \
  -v $WORKDIR:/results \
  --entrypoint="sort" \
  sriep/samtools-1.3 \    
    /results${PRFIX_STUB}_${TOOL_TAG}_unosrted.bam \
    /results/${PRFIX_STUB}_${TOOL_TAG}
remove_docker_container sort$prefix_tail        

#debug_msg  ${LINENO} "about to run bowtie"
#bowtie2   --mm \
#          --no-mixed \
#          -x $WORKDIR/$PRFIX_STUB \
#          -1 $SSH_READSDIR/$READS1 \
#          -2 $SSH_READSDIR/$READS2 \
#          > $WORKDIR/${PRFIX_STUB}_${TOOL_TAG}.sam 
#samtools view -bS $WORKDIR/${PRFIX_STUB}_${TOOL_TAG}.sam  \
# | samtools sort /dev/stdin $WORKDIR/${PRFIX_STUB}_${TOOL_TAG}

debug_msg  ${LINENO} "about to run samtools index"
docker run \
	--name index$prefix_tail  \
	-v $LOCAL_RESULTDIR:/datadir \  
	-v $READSDIR:/reads:ro \
	-v $WORKDIR:/results \ 
  --entrypoint="index" \
	sriep/samtools-1.3 \
    /results/${PRFIX_STUB}_${TOOL_TAG}.bam
remove_docker_container index$prefix_tail 

#samtools index $WORKDIR/${PRFIX_STUB}_${TOOL_TAG}.bam

#Give location of result files
#METRICS_CSV=$WORKDIR/${PRFIX_STUB}_${TOOL_TAG}.bam
debug_msg  ${LINENO} "About to copy result files"
mv $WORKDIR/${PRFIX_STUB}_${TOOL_TAG}.sam $LOCAL_RESULTDIR/${PRFIX_STUB}_${TOOL_TAG}.sam
#
cp $WORKDIR/${PRFIX_STUB}_${TOOL_TAG}.bam $LOCAL_RESULTDIR/${PRFIX_STUB}_${TOOL_TAG}.bam 
cp $WORKDIR/${PRFIX_STUB}_${TOOL_TAG}.bam.bai $LOCAL_RESULTDIR/${PRFIX_STUB}_${TOOL_TAG}.bai

#-------------------------- Assembly specific code here --------------------

#cp $METRICS_CSV $SSH_RESULTDIR/m_${PRFIX_STUB}_${TOOL_TAG}

#cp $CONTIGS $SSH_RESULTDIR/${ASSEMBLY_TAG}c${PREFIX}i.fasta
#cp $SCAFFOLDS $SSH_RESULTDIR/${ASSEMBLY_TAG}s${PREFIX}i.fasta
echo `basename "$0"`: FINISHED!! FINISHED!!
