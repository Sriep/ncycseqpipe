#!/bin/bash 
# 
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
debug_msg  ${LINENO}  "spec file template for runCA is $PARAMETERS"
cp $PARAMETERS $WORKDIR/$PREFIX.spc

if  [[ "$READS1" != $NONE ]]; then
  debug_msg  ${LINENO}  "about to run fastqToCA"
  docker run --name fastqtoca$PREFIX \
                  --volume=$READSDIR:/reads:ro \
                  --entrypoint="fastqToCA" \
                  sriep/wgs-8.3rc2 \
                    -libraryname l1 \
                    -insertsize 500 100  \
                    -technology illumina \
                    -type sanger  \
                    -mates /reads/$READS1,/reads/$READS2 \
                    > $WORKDIR/$PREFIX.IlluminaReads.frg
  remove_docker_container fastqtoca$PREFIX
  debug_msg  ${LINENO}  "here is $WORKDIR/$PREFIX.IlluminaReads.frg"
  cat $WORKDIR/$PREFIX.IlluminaReads.frg
  debug_msg  ${LINENO}  "just finished echoing   $WORKDIR/$PREFIX.IlluminaReads.frg"
  echo "#  Frag file/s for illumna assembly assembly." > $WORKDIR/$PREFIX.spc
  echo /results/$PREFIX.IlluminaReads.frg >> $WORKDIR/$PREFIX.spc
fi
if [[ "$READSPB" != $NONE ]]; then
  debug_msg  ${LINENO} "PB reads not implimented yet"
fi

debug_msg  ${LINENO}  "about to cat spec file $WORKDIR/$PREFIX.spc"
cat "$WORKDIR/$PREFIX.spc"
debug_msg  ${LINENO}  "end of $WORKDIR/$PREFIX.spc"

debug_msg ${LINENO} "about to run runCA"
docker run  \
            --name runca$PREFIX \
            --volume=$READSDIR:/reads:ro  \
            --volume=$WORKDIR:/results \
            --entrypoint="runCA" \
            sriep/wgs-8.3rc2 \
              -d /results \
              -p $PREFIX \
              -s /results/$PREFIX.spc              
#              /results/$PREFIX.IlluminaReads.frg
remove_docker_container runca$PREFIX

CONTIGS=$WORKDIR/9-terminator/$PREFIX.ctg.fasta
SCAFFOLDS=$WORKDIR/9-terminator/$PREFIX.scf.fasta
#-------------------------- Footer --------------------

source $SOURCEDIR/tools/local_footer.sh

#source /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipe.cfg
#PREFIX=NCYC22
#READS1=NCYC22/NCYC22.FP.fastq
#READS2=NCYC22/NCYC22.RP.fastq
#TOOL_TAG=w
#LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX
#WORKDIR=$LOCAL_WORKDIR/$PREFIX/$TOOL_TAG-local
#READSDIR=$LOCAL_DATA/$READDIR
#TEMPLATE=$LOCAL_RESULTDIR.fasta
