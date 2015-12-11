#!/bin/bash 
# 
declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/local_header.sh
# PREFIX - Name of strain to assemble
# READS1 - First set of paired end reads, relative to $LOCAL_READSDIR
# READS2 - Second set of paired end reads, relative to $LOCAL_READSDIR
# TOOL_TAG - Tag to indicate the output from this tool
# PARAMETERS - Data used to paramatirse this tool
#
# WORKDIR - Directory in which to put tempory work files
# READSDIR - Directory where paired end reads are located
#-------------------------- Assembly specific code here --------------------

echo skaffmatch: about to run local skaffmatch on $PREFIX

declare -a args=( "" "" "" "" "" )
IFS=' ' read -ra args <<< "$PARAMETERS"
echo "arguments ${args[@]/#/}"

docker run \
	--name skaffmatch$PREFIX  \
	--volume=$READSDIR:/reads:ro \
	--volume=$WORKDIR:/results \
  --volume=$LOCAL_RESULTDIR:/data
	sriep/abyss-pe \
		${args[0]}  ${args[1]} ${args[2]} ${args[3]} ${args[4]} \
		name=/results/$PREFIX \
		in="/reads/$READS1 /reads/$READS2"
    
    
    scaffmatch -w /results  \
      -c $TEMPLATE \
      -1 /reads/$READS1 \
      -2 /reads/$READS2 \      \
      -i 400 \
      -s 100 \
      -p fr -l logfile.txt
echo skaffmatch: skaffmatch return code is $?
docker rm -f abysspe$PREFIX 
echo skaffmatch: skaffmatch$PREFIX  stopped

# Give location of result files
# CONTIGS - contig assembly fasta file
# SCAFFOLDS - scaffold assembly fasta file
CONTIGS=$WORKDIR/$PREFIX-6.fa
SCAFFOLDS=$WORKDIR/$PREFIX-8.fa
#-------------------------- Footer --------------------

source $SOURCEDIR/local_footer.sh

#declare  CONFIGFILE=/home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipe.cfg
#declare SSH_CONFIGFILE
#declare  PREFIX=NCYC22
#declare  READS1=/NCYC22/NCYC22.FP.fastq
#declare  READS2=/NCYC22/NCYC22.RP.fastq
#declare  ASSEMBLY_TAG=a
#declare  PARAMTERS=k=80 j=10
