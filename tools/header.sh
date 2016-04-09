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
declare -r TOOL_MODE="7"
declare -r TOOL_TAG="$8"
declare -r TOOL_NAME="$9"
declare -r LOGPREFIX="${10}"
declare -r PARAMETERS=$(echo "${11}" | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")
source ${!config}
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
readonly PRFIX_STUB=$(basename $PREFIX)

declare CONTIGS=
declare SCAFFOLDS=
declare METRICS=

declare -a args=( "" "" "" "" "" "" "" "" "" "" )
IFS=' ' read -ra args <<< "$PARAMETERS"
debug_msg ${LINENO} "arguments ${args[@]/#/}"

start=$(date +%s)
PROGNAME=$OLD_PROGNAME