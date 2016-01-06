#!/bin/bash
# 

source hpccore-5
source wgs-8.3
declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/ssh_header.sh
# PREFIX - Name of strain to assemble
# PREFIX - Name of strain to assemble
# READS1 - First set of paired end reads, relative to $LOCAL_READSDIR
# READS2 - Second set of paired end reads, relative to $LOCAL_READSDIR
# ASSEMBLY_TAG - Tag to indicate the output from this tool
# PARAMETERS - Data used to paramatirse this tool
#
# WORKDIR - Directory in which to put tempory work files
# READSDIR - Directory where paired end reads are located
#-------------------------- Assembly specific code here --------------------
debug_msg  ${LINENO}  "spec file template for runCA is $PARAMETERS"
cp $PARAMETERS $WORKDIR/$PREFIX.spc

if  [[ "$READS1" != $NONE ]]; then
  debug_msg  ${LINENO}  "about to run fastqToCA"
  docker run --name fastqtoca$PREFIX \
                  --volume=$READSDIR:/reads:ro \
  fastqToCA \
    -libraryname l1 \
    -insertsize 500 100  \
    -technology illumina \
    -type sanger  \
    -mates $READSDIR/$READS1,$READSDIR/$READS2 \
    > $WORKDIR/$PREFIX.IlluminaReads.frg
  
  debug_msg  ${LINENO}  "here is $WORKDIR/$PREFIX.IlluminaReads.frg"
  cat $WORKDIR/$PREFIX.IlluminaReads.frg
  debug_msg  ${LINENO}  "just finished echoing   $WORKDIR/$PREFIX.IlluminaReads.frg"
  echo "#  Frag file/s for illumna assembly assembly." > $WORKDIR/$PREFIX.spc
  echo $WORKDIR/$PREFIX.IlluminaReads.frg >> $WORKDIR/$PREFIX.spc
fi

if [[ "$READSPB" != $NONE ]]; then
  debug_msg  ${LINENO} "PB reads not implimented yet"
fi

debug_msg  ${LINENO}  "about to cat spec file $WORKDIR/$PREFIX.spc"
cat "$WORKDIR/$PREFIX.spc"
debug_msg  ${LINENO}  "end of $WORKDIR/$PREFIX.spc"

debug_msg ${LINENO} "about to run runCA"
runCA \
  -d $WORKDIR \
  -p $PREFIX \
  -s $WORKDIR/$PREFIX.spc

CONTIGS=$WORKDIR/9-terminator/$PREFIX.ctg.fasta
SCAFFOLDS=$WORKDIR/9-terminator/$PREFIX.scf.fasta
#-------------------------- Footer --------------------

source $SOURCEDIR/ssh_footer.sh

#source /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipe.cfg
#PREFIX=NCYC22
#READS1=NCYC22/NCYC22.FP.fastq
#READS2=NCYC22/NCYC22.RP.fastq
#TOOL_TAG=w
#LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX
#WORKDIR=$LOCAL_WORKDIR/$PREFIX/$TOOL_TAG-local
#READSDIR=$LOCAL_DATA/$READDIR
#TEMPLATE=$LOCAL_RESULTDIR.fasta
