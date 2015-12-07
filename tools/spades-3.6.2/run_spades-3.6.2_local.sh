#!/bin/bash
declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/local_header.sh
# PREFIX - Name of strain to assemble
# READS1 - First set of paired end reads, relative to $LOCAL_READSDIR
# READS2 - Second set of paired end reads, relative to $LOCAL_READSDIR
# ASSEMBLY_TAG - Tag to indicate the output from this tool
# PARAMETERS - Data used to paramatirse this tool
#
# WORKDIR - Directory in which to put tempory work files
# READSDIR - Directory where paired end reads are located
#-------------------------- Assembly specific code here --------------------
BASHDIR=$(dirname $BASH_SOURCE)

echo $PREFIX SPADES: about to run soap on strain $PREFIX

YAMLFILE=$WORKDIR/$PREFIX.yaml
> $YAMLFILE
cat $BASHDIR/spadesYamlHead.txt >> $YAMLFILE
echo "/reads/$READS1" >> $YAMLFILE
cat $BASHDIR/spadesYamlBreak.txt >> $YAMLFILE
echo "/reads/$READS2" >> $YAMLFILE
cat $BASHDIR/spadesYamlEnd.txt >> $YAMLFILE


echo about to run docker spades
docker run \
  --name spades$PREFIX  \
  -v $READSDIR:/reads:ro \
  -v $WORKDIR:/results \
    sriep/spades-3.6.2 \
      --dataset /results/$PREFIX.yaml \
      -o /results 

echo $PREFIX spades: spades return code is $?
docker rm -f spades$PREFIX 
echo $PREFIX spades: spades$PREFIX  stopped

#Give location of result files
CONTIGS=$WORKDIR/spades/contigs.fasta
SCAFFOLDS=$WORKDIR/spades/scaffolds.fasta
#-------------------------- Assembly specific code here --------------------

source $SOURCEDIR/local_footer.sh

#source /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipe.cfg
#PREFIX=NCYC22
#READS1=NCYC22/NCYC22.FP.fastq
#READS2=NCYC22/NCYC22.RP.fastq
#TOOL_TAG=d
#LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX
#WORKDIR=$LOCAL_WORKDIR/$PREFIX/$TOOL_TAG-local
#READSDIR=$LOCAL_DATA/$READDIR
#TEMPLATE=$LOCAL_RESULTDIR.fasta
#BASHDIR=/home/shepperp/datashare/Piers/github/ncycseqpipe/tools/spades-3.6.2