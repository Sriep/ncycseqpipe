location=ssh
config=SSH_CONFIGFILE
source $SOURCEDIR/tools/header.sh

#source $SSH_CONFIGFILE
OLD_PROGNAME=$PROGNAME || true
PROGNAME=$(basename $0)

declare -r SSH_RESULTDIR=$HPC_DATA/$RESULTDIR/$PREFIX
declare -r WORKDIR=$SSH_RESULTDIR/$TOOL_NAME-ssh
declare -r SSH_READSDIR=$HPC_DATA/$READDIR
declare -r TEMPLATE=$SSH_RESULTDIR.fasta
mkdir -p $WORKDIR

declare LOGFILE=${LOGPREFIX}_${PRFIX_STUB}_${TOOL_NAME}_ssh.log
debug_msg ${LINENO}  "LOGFILE=$LOGFILE"
> $LOGFILE

PROGNAME=$OLD_PROGNAME