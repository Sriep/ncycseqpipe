#!/bin/bash 
# 
declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/local_header.sh
PROGNAME=$(basename $0)
# PREFIX - Name of strain to assemble
# READS1 - First set of paired end reads, relative to $LOCAL_READSDIR
# READS2 - Second set of paired end reads, relative to $LOCAL_READSDIR
# READSPB - Pacbio reads
# TOOL_TAG - Tag to indicate the output from this tool
# PARAMETERS - Data used to paramatirse this tool
#
# WORKDIR - Directory in which to put tempory work files
# READSDIR - Directory where paired end reads are located
#-------------------------- Assembly specific code here --------------------

debug_msg  ${LINENO}   "about to run local sspace longread on $PREFIX"
declare -a args=( "" "" "" "" "" )
IFS=' ' read -ra args <<< "$PARAMETERS"
debug_msg  ${LINENO}   "arguments ${args[@]/#/}"
debug_msg  ${LINENO}  "parametrs $PARAMETERS"
docker run \
	--name sspace-longread$PREFIX  \
	--volume=$READSDIR:/reads:ro \
	--volume=$WORKDIR:/results \
  --volume=$LOCAL_RESULTDIR:/data \
  --entrypoint="perl" \
	sriep/sspace-longread-1.1 \
      SSPACE-LongRead.pl \
      -b /results  \
      -c /data/${args[0]}.fasta \
      -p /reads/$READSPB \
      -t 10 
remove_docker_container sspace-longread$PREFIX

# Give location of result files
# CONTIGS - contig assembly fasta file
# SCAFFOLDS - scaffold assembly fasta file
SCAFFOLDS=$WORKDIR/scaffolds.fasta
#-------------------------- Footer --------------------

source $SOURCEDIR/local_footer.sh

#Usage SSPACE-LongRead scaffolder version 1-1
#perl SSPACE-LongRead.pl -c <contig-sequences> -p <pacbio-reads>
#General options:
#-c  Fasta file containing contig sequences used for scaffolding (REQUIRED)
#-p  File containing PacBio CLR sequences to be used scaffolding (REQUIRED)
#-b  Output folder name where the results are stored 
#    (optional, default -b 'PacBio_scaffolder_results')
#Alignment options:
#-a  Minimum alignment length to allow a contig to be included for scaffolding 
#    (default -a 0, optional)
#-i  Minimum identity of the alignment of the PacBio reads to the contig sequences. 
#    Alignment below this value will be filtered out (default -i 70, optional)
#-t  The number of threads to run BLASR with
#-g  Minimmum gap between two contigs
#Scaffolding options:
#-l  Minimum number of links (PacBio reads) to allow contig-pairs for scaffolding 
#    ( default -k 3, optional)
#-r  Maximum link ratio between two best contig pairs *higher values lead to 
#    least accurate scaffolding* (default -r 0.3, optional)
#-o  Minimum overlap length to merge two contigs (default -o 10, optional)
#Other options:
#-k  Store inner-scaffold sequences in a file. These are the long-read sequences 
#    spanning over a contig-link (default no output, set '-k 1' to store 
#    inner-scaffold sequences. If set, a folder #is generated named 'inner-scaffold-sequences'
#-s  Skip the alignment step and use a previous alignment file. Note that the 
#    results of a previous run will be overwritten. Set '-s 1' to skip the alignment.
#-h  Prints this help message

