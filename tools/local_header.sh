location=local
config=CONFIGFILE
source $SOURCEDIR/tools/header.sh

#source $CONFIGFILE
OLD_PROGNAME=$PROGNAME || true
PROGNAME=$(basename $0)

declare -r LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX
declare -r WORKDIR=$LOCAL_WORKDIR/$PREFIX/$TOOL_NAME-local
declare -r READSDIR=$LOCAL_DATA/$READDIR
declare -r TEMPLATE=$LOCAL_RESULTDIR.fasta
mkdir -p $LOCAL_RESULTDIR
mkdir -p $WORKDIR

declare LOGFILE=${LOGPREFIX}_${PREFIX}_${TOOL_NAME}_local.log
declare DOCKERLOGFILE=${LOGPREFIX}${PROGNAME}.dockerlog
debug_msg ${LINENO}  "LOCAL_RESULTDIR=$LOCAL_RESULTDIR"
debug_msg ${LINENO}  "WORKDIR=$WORKDIR"
debug_msg ${LINENO}  "LOGFILE=$LOGFILE"
debug_msg ${LINENO}  "DOCKERLOGFILE=$DOCKERLOGFILE"
> $LOGFILE
> $DOCKERLOGFILE

PROGNAME=$OLD_PROGNAME

function remove_docker_container ()
{
  echo WGC: about to remove $1
  debug_msg ${LINENO} "about to remove $1" 
  docker stats --no-stream=true $1 1>> $DOCKERLOGFILE
  #docker inspect $1 >> $LOGPREFIX.$PROGNAME.$1.json
  docker inspect $1 >> $DOCKERLOGFILE
  docker rm -f $1 
}