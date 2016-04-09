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
debug_msg  ${LINENO}   "about to run local finishersc on $PREFIX"
readonly TARGET=${args[0]}${args[1]}${PREFIX}i
debug_msg  ${LINENO}  "target is $TARGET"
debug_msg  ${LINENO}  "cp $LOCAL_RESULTDIR/$TARGET.fasta $WORKDIR/contigs.fasta"

#cp $LOCAL_RESULTDIR/$TARGET.fasta $WORKDIR/contigs.fasta

#https://github.com/kakitone/finishingTool/blob/master/README.md
oldcontigs=$LOCAL_RESULTDIR/$TARGET.fasta
newcontigs=$WORKDIR/contigs.fasta
perl -pe 's/>[^\$]*$/">Seg" . ++$n ."\n"/ge' $oldcontigs > $newcontigs

inputfastq="$READSDIR/$READSPB"
outputfasta="$WORKDIR/dirty.fasta"
awk 'BEGIN{P=1}{if(P==1||P==2){gsub(/^[@]/,">");print}; if(P==4)P=0; P++}' "$inputfastq" > "$outputfasta" 
rawreadsfasta="$WORKDIR/raw_reads.fasta"
perl -pe 's/>[^\$]*$/">Seg" . ++$n ."\n"/ge' $outputfasta > $rawreadsfasta

docker run \
	--name finishersc$PREFIX  \
	--volume=$WORKDIR:/results \
  --volume=$LOCAL_RESULTDIR:/data \
	sriep/finishersc finisherSC.py \
    ${args[2]} ${args[3]} \
      /results  \
      MUMmer3.23 
      
docker run \
	--name xPhaser$PREFIX  \
	--volume=$WORKDIR:/results \
  --volume=$LOCAL_RESULTDIR:/data \
	sriep/finishersc  experimental/xPhaser.py \
      /results  \
      MUMmer3.23       
      
docker run \
	--name tSolver$PREFIX  \
	--volume=$WORKDIR:/results \
  --volume=$LOCAL_RESULTDIR:/data \
	sriep/finishersc  experimental/tSolver.py  \
      /results  \
      MUMmer3.23     
      
remove_docker_container finisherrc$PREFIX
remove_docker_container xPhaser$PREFIX
remove_docker_container tSolver$PREFIX

cp $WORKDIR/improved3.fasta $LOCAL_RESULTDIR/${TOOL_TAG}s${PRFIX_STUB}${args[0]}.fasta
cp $WORKDIR/improved4.fasta $LOCAL_RESULTDIR/${TOOL_TAG}s${PRFIX_STUB}${args[0]}_fphaser.fasta
cp $WORKDIR/tademResolved.fasta $LOCAL_RESULTDIR/${TOOL_TAG}s${PRFIX_STUB}${args[0]}_ftandemr.fasta

SCAFFOLDS=$WORKDIR/improved3.fasta
#-------------------------- Footer --------------------

source $SOURCEDIR/tools/local_footer.sh

