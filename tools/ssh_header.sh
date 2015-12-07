# $1 Config file
# $2 Prefix e.g. NCYC93
# $3 First part of the paired end reads, relative to read directory
# $4 Second part of the paired end reads, relative to read directory
# $5 Assembly tag from input file
# $6 Arguments from input file
declare -r SSH_CONFIGFILE="$1"
declare -r PREFIX="$2"
declare -r READS1="$3"
declare -r READS2="$4"
declare -r TOOL_TAG="$5"
#declare -r PARAMETERS="$6"
declare -r PARAMETERS=$(echo "$6" | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")
echo  $SSH_CONFIGFILE
echo  $PREFIX
echo  $READS1
echo  $READS2
echo  $TOOL_TAG
echo  $PARAMTERS


source $SSH_CONFIGFILE
readonly SSH_WORKDIR
readonly READDIR
echo source directory $SOURCEDIR

readonly PRFIX_STUB=$(basename $PREFIX)
declare -r SSH_RESULTDIR=$HPC_DATA/$RESULTDIR/$PREFIX
declare -r WORKDIR=$SSH_RESULTDIR/$TOOL_TAG-ssh
declare -r SSH_READSDIR=$HPC_DATA/$READDIR
declare -r TEMPLATE=$SSH_RESULTDIR.fasta
mkdir -p $WORKDIR
