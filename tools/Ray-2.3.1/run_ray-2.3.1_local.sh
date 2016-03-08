#!/bin/bash
declare -r SOURCEDIR="$1"
source $SOURCEDIR/tools/local_header.sh
# PREFIX - Name of strain to assemble
# READS1 - First set of paired end reads, relative to $LOCAL_READSDIR
# READS2 - Second set of paired end reads, relative to $LOCAL_READSDIR
# ASSEMBLY_TAG - Tag to indicate the output from this tool
# PARAMETERS - Data used to paramatirse this tool
#
# WORKDIR - Directory in which to put tempory work files
# READSDIR - Directory where paired end reads are located
#-------------------------- Assembly specific code here --------------------
debug_msg  ${LINENO} "about to run ray on strain $PREFIX"
declare -a args=( "" "" "" "" "" )
IFS=' ' read -ra args <<< "$PARAMETERS"
debug_msg  ${LINENO} "arguments ${args[@]/#/}"
#${args[0]}  ${args[1]} ${args[2]} ${args[3]} ${args[4]} 

docker run \
	--name ray-2.3.1$PREFIX  \
	-v $READSDIR:/reads:ro \
	-v $WORKDIR:/results \
  --entrypoint mpiexec \
	sriep/ray-2.3.1 \
      -n ${args[0]} \
		  /Ray-2.3.1/ray-build/Ray \
      -k ${args[1]} \
      -p /reads/$READS1 /reads/$READS2 \
      -o /results/out 
debug_msg  ${LINENO} "ray return code is $?"
docker rm -f ray-2.3.1$PREFIX 

#Give location of result files
chmod -R o+rwx $WORKDIR/out
CONTIGS=$WORKDIR/out/Contigs.fasta
#SCAFFOLDS=$WORKDIR/$PREFIX.scafSeq
#-------------------------- Assembly specific code here --------------------

source $SOURCEDIR/tools/local_footer.sh

#DEBUG
#source /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipe.cfg
#PREFIX=NCYC22
#READS1=NCYC22/NCYC22.FP.fastq
#READS2=NCYC22/NCYC22.RP.fastq
#TOOL_TAG=w
#LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX
#WORKDIR=$LOCAL_WORKDIR/$PREFIX/$TOOL_TAG-local
#READSDIR=$LOCAL_DATA/$READDIR
#TEMPLATE=$LOCAL_RESULTDIR.fasta