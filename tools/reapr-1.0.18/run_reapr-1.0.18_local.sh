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

debug_msg  ${LINENO} "REAPR: about to run local REAPR on $PREFIX"
debug_msg  ${LINENO} "arguments ${args[@]/#/}"
target=${args[0]}${args[1]}${PREFIX}i
debug_msg  ${LINENO} "target is $target"

debug_msg  ${LINENO} "about to run facheck"
docker run \
	--name REAPRfacheck"$PREFIX"  \
  -v "$LOCAL_RESULTDIR":/data \
	-v "$READSDIR":/reads:ro \
	-v "$WORKDIR":/results \
	sriep/reapr-1.0.18 facheck \
		/data/"${target}".fasta \
		/results/"${target}"_clean
remove_docker_container REAPRfacheck$PREFIX  
  
debug_msg  ${LINENO} "about to run smaltmap"  
debug_msg  ${LINENO} "docker run --name REAPRsmaltmap$PREFIX  -v $LOCAL_RESULTDIR:/data	-v $READSDIR:/reads:ro -v $WORKDIR:/results sriep/reapr-1.0.18 smaltmap 	${args[2]}  ${args[3]}   /results/${target}_clean.fa   /reads/$READS1 /reads/$READS2   /results/${target}_smalt.bam"  
debug_msg  ${LINENO} "WORKDIR is $WORKDIR"
debug_msg  ${LINENO} "/results/target_smalt.bam is /results/${target}_smalt.bam"

docker run \
	--name REAPRsmaltmap"$PREFIX"  \
  -v "$LOCAL_RESULTDIR":/data \
	-v "$READSDIR":/reads:ro \
	-v "$WORKDIR":/results \
	sriep/reapr-1.0.18 smaltmap \
    /results/"${target}"_clean.fa \
    "/reads/$READS1 /reads/$READS2" \
    /results/"${target}"_smalt.bam
remove_docker_container REAPRsmaltmap$PREFIX
 #		-n 30 \     
debug_msg  ${LINENO} "about to run pipeline"      
docker run \
	--name REAPRpipeline"$PREFIX"  \
  -v "$LOCAL_RESULTDIR":/data \
	-v "$READSDIR":/reads:ro \
	-v "$WORKDIR":/results \
	sriep/reapr-1.0.18 pipeline \
    /results/"${target}"_clean.fa \
    /results/"${target}"_smalt.bam \
    /results/"$PREFIX"_ReaprOut        
remove_docker_container REAPRpipeline$PREFIX

rm -r  "$LOCAL_RESULTDIR"/"$PREFIX"_ReaprOut
mkdir -p "$LOCAL_RESULTDIR"/"$PREFIX"_ReaprOut
cp -r  "$WORKDIR"/"$PREFIX"_ReaprOut  "$LOCAL_RESULTDIR"/"$PREFIX"_ReaprOut

#CONTIGS=
#-------------------------- Footer --------------------

source $SOURCEDIR/tools/local_footer.sh

