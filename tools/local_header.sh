# $1 Config file
# $2 Prefix e.g. NCYC93
# $3 First part of the paired end reads, relative to read directory
# $4 Second part of the paired end reads, relative to read directory
# $5 Assembly tag from input file
# $6 Arguments from input file
declare -r CONFIGFILE="$1"
declare  PREFIX="$2"
declare  PRFIX_STUB=$(basename $PREFIX)
declare -r READS1="$3"
declare -r READS2="$4"
declare -r READSPB="$5"
declare -r TOOL_TAG="$6"
declare -r TOOL_NAME="$7"
declare -r LOGPREFIX=$8
#strip quotes PARAMETERS
declare -r PARAMETERS=$(echo "$9" | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")

source $CONFIGFILE
source $SOURCEDIR/../error.sh
OLD_PROGNAME=$PROGNAME || true
PROGNAME=$(basename $0)

debug_msg ${LINENO}  "local header configfile $CONFIGFILE"
debug_msg ${LINENO} "local header prefix $PREFIX"
debug_msg ${LINENO}  "local header reads1 $READS1"
debug_msg ${LINENO}  "local header reads2 $READS2"
debug_msg ${LINENO}  "local header READSPB $READSPB"
debug_msg ${LINENO}  "local header tool tag $TOOL_TAG"
debug_msg ${LINENO}  "local header tool name $TOOL_NAME"
debug_msg ${LINENO}  "local header log prefix $LOGPREFIX"
debug_msg ${LINENO}  "local header arguments $PARAMETERS"

readonly LOCAL_DATA
readonly RESULTDIR
readonly LOCAL_WORKDIR
readonly READDIR
readonly PRFIX_STUB=$(basename $PREFIX)

declare -r LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX
declare -r WORKDIR=$LOCAL_WORKDIR/$PREFIX/$TOOL_NAME-local
declare -r READSDIR=$LOCAL_DATA/$READDIR
declare -r TEMPLATE=$LOCAL_RESULTDIR.fasta
declare CONTIGS=
declare SCAFFOLDS=
declare METRICS=
declare LOGFILE=${LOGPREFIX}$PROGNAME.log

declare -a args=( "" "" "" "" "" "" "" "" "" "" )
IFS=' ' read -ra args <<< "$PARAMETERS"
debug_msg ${LINENO} "arguments ${args[@]/#/}"

mkdir -p $LOCAL_RESULTDIR
mkdir -p $WORKDIR
> $LOGFILE
start=$(date +%s)
PROGNAME=$OLD_PROGNAME

function remove_docker_container ()
{
  echo WGC: about to remove $1
  debug_msg ${LINENO} "about to remove $1" 
  docker stats --no-stream=true $1 1>> $LOGFILE
  #docker inspect $1 >> $LOGPREFIX.$PROGNAME.$1.json
  docker inspect $1 >> $LOGFILE
  docker rm -f $1 
}