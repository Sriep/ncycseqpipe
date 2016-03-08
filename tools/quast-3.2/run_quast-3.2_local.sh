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
debug_msg  ${LINENO}  "QUAST local: about to run ssh quast on $PREFIX"

declare -a args=( "" "" "" "" "" )
IFS=' ' read -ra args <<< "$PARAMETERS"
debug_msg  ${LINENO} "arguments ${args[@]/#/}"

template_basename=$(basename $TEMPLATE)
cp $TEMPLATE $LOCAL_RESULTDIR/$template_basename

debug_msg  ${LINENO} "about to run quast"
docker run \
	--name quast$template_basename  \
	-v $LOCAL_RESULTDIR:/datadir \
	-v $WORKDIR:/results \
	sriep/quast-3.2 \
    ${args[0]}  ${args[1]} ${args[2]} ${args[3]} ${args[4]} \
		-o /results \
    /datadir/$template_basename
remove_docker_container quast$template_basename

#Give location of result files
debug_msg  "${LINENO}  about to rum cp $WORKDIR $LOCAL_RESULTDIR"
cp -r $WORKDIR $LOCAL_RESULTDIR
METRICS=$WORKDIR/transposed_report.tsv 

#-------------------------- Assembly specific code here --------------------
source $SOURCEDIR/tools/local_footer.sh

#WORKDIR=/nbi/group-data/ifs/NBI/Research-Groups/Jo-Dicks/Piers/assemblies/test/NCYC388/rNCYC388i
#TEMPLATE=/nbi/group-data/ifs/NBI/Research-Groups/Jo-Dicks/Piers/assemblies/test/NCYC388/rNCYC388i.fasta
#bsub $QUASTDIR/quast.py   --eukaryote   --scaffolds   -o $WORKDIR   $TEMPLATE