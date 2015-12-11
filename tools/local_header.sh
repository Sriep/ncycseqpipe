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
declare -r TOOL_TAG="$5"
#declare -r PARAMETERS="$6"
#strip quotes PARAMETERS
declare -r PARAMETERS=$(echo "$6" | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")

source $CONFIGFILE
source $SOURCEDIR/../error.sh
OLD_PROGNAME=$PROGNAME || true
PROGNAME=$(basename $0)

echo local header configfile $CONFIGFILE
echo local header prefix $PREFIX
echo local header reads1 $READS1
echo local header reads2 $READS2
echo local header tool tag $TOOL_TAG
echo local header arguments $PARAMETERS

readonly LOCAL_DATA
readonly RESULTDIR
readonly LOCAL_WORKDIR
readonly READDIR
readonly PRFIX_STUB=$(basename $PREFIX)

declare -r LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX
declare -r WORKDIR=$LOCAL_WORKDIR/$PREFIX/$TOOL_TAG-local
declare -r READSDIR=$LOCAL_DATA/$READDIR
declare -r TEMPLATE=$LOCAL_RESULTDIR.fasta
declare CONTIGS=
declare SCAFFOLDS=
declare METRICS=

mkdir -p $LOCAL_RESULTDIR
mkdir -p $WORKDIR

PROGNAME=$OLD_PROGNAME