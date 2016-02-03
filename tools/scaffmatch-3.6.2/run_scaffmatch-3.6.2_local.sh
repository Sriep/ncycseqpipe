#!/bin/bash 
# 
declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/local_header.sh
PROGNAME=$(basename $0)
# PREFIX - Name of strain to assemble
# READS1 - First set of paired end reads, relative to $LOCAL_READSDIR
# READS2 - Second set of paired end reads, relative to $LOCAL_READSDIR
# TOOL_TAG - Tag to indicate the output from this tool
# PARAMETERS - Data used to paramatirse this tool
#
# WORKDIR - Directory in which to put tempory work files
# READSDIR - Directory where paired end reads are located
#-------------------------- Assembly specific code here --------------------
debug_msg  ${LINENO}   "about to run local skaffmatch on $PREFIX"
readonly TARGET=${args[0]}${args[1]}${PREFIX}i
debug_msg  ${LINENO}  "target is $TARGET"

#declare -a args=( "" "" "" "" "" )
#IFS=' ' read -ra args <<< "$PARAMETERS"
#debug_msg  ${LINENO}   "arguments ${args[@]/#/}"
#debug_msg  ${LINENO}  "parametrs $PARAMETERS"
docker run \
	--name skaffmatch$PREFIX  \
	--volume=$READSDIR:/reads:ro \
	--volume=$WORKDIR:/results \
  --volume=$LOCAL_RESULTDIR:/data \
	sriep/scaffmatch \
      -w /results  \
      -c /data/${TARGET}.fasta \
      -1 /reads/$READS1 \
      -2 /reads/$READS2 \
      -i ${args[2]} \
      -s ${args[3]} \
      -p fr \
      -l skff_logfile.txt
remove_docker_container skaffmatch$PREFIX

# Give location of result files
# CONTIGS - contig assembly fasta file
# SCAFFOLDS - scaffold assembly fasta file
SCAFFOLDS=$WORKDIR/scaffolds.fa
#-------------------------- Footer --------------------

source $SOURCEDIR/local_footer.sh

#declare  CONFIGFILE=/home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipe.cfg
#declare SSH_CONFIGFILE
#declare  PREFIX=NCYC22
#declare  READS1=/NCYC22/NCYC22.FP.fastq
#declare  READS2=/NCYC22/NCYC22.RP.fastq
#declare  ASSEMBLY_TAG=a
#declare  PARAMTERS=k=80 j=10
