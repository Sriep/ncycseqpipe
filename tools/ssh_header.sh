# $1 Config file
# $2 Prefix e.g. NCYC93
# $3 First part of the paired end reads, relative to read directory
# $4 Second part of the paired end reads, relative to read directory
# $5 Assembly tag from input file
# $6 Arguments from input file
declare -r SSH_CONFIGFILE="$2"
declare -r PREFIX="$3"
declare -r READS1="$4"
declare -r READS2="$5"
declare -r READSPB="$6"
declare -r TOOL_TAG="$7"
declare -r TOOL_NAME="$8"
declare -r LOGPREFIX="$9"
declare -r PARAMETERS=$(echo "${10}" | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")

source $SSH_CONFIGFILE
source $SOURCEDIR/error.sh
OLD_PROGNAME=$PROGNAME || true
PROGNAME=$(basename $0)

debug_msg ${LINENO}  "SOURCEDIR=$SOURCEDIR"
debug_msg ${LINENO}  "SSH_CONFIGFILE=$SSH_CONFIGFILE"
debug_msg ${LINENO}  "PREFIX=$PREFIX"
debug_msg ${LINENO}  "READS1=$READS1"
debug_msg ${LINENO}  "READS2=$READS2"
debug_msg ${LINENO}  "READSPB=$READSPB"
debug_msg ${LINENO}  "TOOL_TAG=$TOOL_TAG"
debug_msg ${LINENO}  "TOOL_NAME=$TOOL_NAME"
debug_msg ${LINENO}  "LOGPREFIX=$LOGPREFIX"
debug_msg ${LINENO}  "PARAMETERS=$PARAMETERS"
debug_msg ${LINENO}  "argument doller ten=$10"
#readonly SSH_WORKDIR
readonly READDIR
#debug_msg ${LINENO} "SSH_WORKDIR=$SSH_WORKDIR"

declare -a args=( "" "" "" "" "" "" "" "" "" "" )
IFS=' ' read -ra args <<< "$PARAMETERS"
echo "arguments from PARAMETERS are ${args[@]/#/}"

declare LOGFILE=${LOGPREFIX}$PROGNAME.log
debug_msg ${LINENO}  "LOGFILE=$LOGFILE"
> $LOGFILE
start=$(date +%s)

readonly PRFIX_STUB=$(basename $PREFIX)
declare -r SSH_RESULTDIR=$HPC_DATA/$RESULTDIR/$PREFIX
declare -r WORKDIR=$SSH_RESULTDIR/$TOOL_NAME-ssh
declare -r SSH_READSDIR=$HPC_DATA/$READDIR
declare -r TEMPLATE=$SSH_RESULTDIR.fasta
mkdir -p $WORKDIR

PROGNAME=$OLD_PROGNAME