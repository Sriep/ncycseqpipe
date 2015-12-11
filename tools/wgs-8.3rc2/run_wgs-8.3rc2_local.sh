#!/bin/bash 
# 
declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/local_header.sh
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
debug_msg  ${LINENO}  "about to run fastqToCA"
docker run --name fastqToCA$PREFIX \
                -v $READSDIR:/reads:ro \
                --entrypoint="fastqToCA" \
                sriep/wgs-8.3rc2 \
                  -libraryname l1 \
                  -insertsize 500 100  \
                  -technology illumina \
                  -type sanger  \
                  -mates /reads/$READS1,/reads/$READS2 \
                  > $WORKDIR/$PREFIX.frg
debug_msg  ${LINENO}  "about to remove fastqToCA$PREFIX"
docker rm -f fastqToCA$PREFIX 
debug_msg  ${LINENO}  "here is $WORKDIR/$PREFIX.frg"
cat $WORKDIR/$PREFIX.frg
debug_msg  ${LINENO}  "just finished echoing   $WORKDIR/$PREFIX.frg"
echo "#  Spec file for celera assembly." > $WORKDIR/$PREFIX.spc
echo $WORKDIR/$PREFIX.frg >> $WORKDIR/$PREFIX.spc
debug_msg  ${LINENO}  "about to cat $WORKDIR/$PREFIX.spc"
cat "$WORKDIR/$PREFIX.spc"
debug_msg  ${LINENO}  "end of $WORKDIR/$PREFIX.spc"

debug_msg ${LINENO} "about to run runCA"
debug_msg ${LINENO} "WGC:about to run runCA" 
docker run  \
            --name runCA$PREFIX \
            -v $READSDIR:/reads:ro \
            -v $WORKDIR:/results \
            --entrypoint="runCA" \
            sriep/wgs-8.3rc2 \
              -d /results \
              -p $PREFIX \
              /results/$PREFIX.frg
echo WGC: about to remove runCA$PREFIX
debug_msg ${LINENO} "about to remove runCA$PREFIX" 
docker rm -f runCA$PREFIX 
# Give location of result files
# CONTIGS - contig assembly fasta file
# SCAFFOLDS - scaffold assembly fasta file
CONTIGS=$WORKDIR/9-terminator/NCYC22.ctg.fasta
SCAFFOLDS=$WORKDIR/9-terminator/NCYC22.scf.fasta
#-------------------------- Footer --------------------

source $SOURCEDIR/local_footer.sh

#source /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipe.cfg
#PREFIX=NCYC22
#READS1=NCYC22/NCYC22.FP.fastq
#READS2=NCYC22/NCYC22.RP.fastq
#TOOL_TAG=w
#LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX
#WORKDIR=$LOCAL_WORKDIR/$PREFIX/$TOOL_TAG-local
#READSDIR=$LOCAL_DATA/$READDIR
#TEMPLATE=$LOCAL_RESULTDIR.fasta
