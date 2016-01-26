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
declare -r READSPB="$5"
declare -r TOOL_TAG="$6"
declare -r TOOL_NAME="$7"
declare -r LOGPREFIX="$8"
declare -r PARAMETERS=$(echo "$9" | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")

source $SSH_CONFIGFILE
source $SOURCEDIR/../error.sh
OLD_PROGNAME=$PROGNAME || true
PROGNAME=$(basename $0)

debug_msg ${LINENO}  "$SSH_CONFIGFILE"
debug_msg ${LINENO}  "$PREFIX"
debug_msg ${LINENO}  "$READS1"
debug_msg ${LINENO}  "$READS2"
debug_msg ${LINENO}  "$TOOL_TAG"
debug_msg ${LINENO}  "$TOOL_NAME"
debug_msg ${LINENO}  "$LOGPREFIX"
debug_msg ${LINENO}  "$PARAMTERS"

readonly SSH_WORKDIR
readonly READDIR
debug_msg ${LINENO} "source directory $SOURCEDIR"

readonly PRFIX_STUB=$(basename $PREFIX)
declare -r SSH_RESULTDIR=$HPC_DATA/$RESULTDIR/$PREFIX
declare -r WORKDIR=$SSH_RESULTDIR/$TOOL_TAG-ssh
declare -r SSH_READSDIR=$HPC_DATA/$READDIR
declare -r TEMPLATE=$SSH_RESULTDIR.fasta
mkdir -p $WORKDIR

PROGNAME=$OLD_PROGNAME