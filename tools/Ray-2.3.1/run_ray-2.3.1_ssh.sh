#!/bin/bash
source hpccore-5
source Ray-2.3.1
source mpich2-1.5
source openmpi-1.6.5
source openssl-1.0.1j
declare -r SOURCEDIR="$1"
source $SOURCEDIR/ssh_header.sh
PROGNAME=$(basename $0)
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
RAYEX=/nbi/software/testing/Ray/2.3.1/x86_64/bin
#docker run \
#	--name ray-2.3.1$PREFIX  \
#	-v $READSDIR:/reads:ro \
#	-v $WORKDIR:/results \
#  --entrypoint mpiexec \
#	sriep/ray-2.3.1 \
#      -n 10 \
#		  /Ray-2.3.1/ray-build/Ray \
#      -k 31 \
#      -p /reads/$READS1 /reads/$READS2 \
#      -o /results/out 
#debug_msg  ${LINENO} "ray return code is $?"
#docker rm -f ray-2.3.1$PREFIX 

mpiexec -n 10 Ray -k 31 -p $READSDIR/$READS1 $/READSDIR/$READS2 \
      -o $WORKDIR/out 

#Give location of result files
chmod -R o+rwx $WORKDIR/out
CONTIGS=$WORKDIR/out/Contigs.fasta
#SCAFFOLDS=$WORKDIR/$PREFIX.scafSeq
#-------------------------- Assembly specific code here --------------------

source $SOURCEDIR/ssh_footer.sh

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