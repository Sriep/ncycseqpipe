# $1 Config file
# $2 Prefix e.g. NCYC93
# $3 First part of the paired end reads, relative to read directory
# $4 Second part of the paired end reads, relative to read directory
# $5 Assembly tag from input file
# $6 Arguments from input file
declare -r CONFIGFILE="$1"
declare -r PREFIX="$2"
declare -r READS1="$3"
declare -r READS2="$4"
declare -r ASSEMBLY_TAG="$5"
#declare -r PARAMTERS="$6"
#strip quotes
declare -r PARAMTERS=$(echo "$6" | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")
echo "just striped quotes $PARAMTERS"

echo run_local_abyss configfile $CONFIGFILE
echo run_local_abyss prefix $PREFIX
echo run_local_abyss reads1 $READS1
echo run_local_abyss reads2 $READS2
echo run_local_abyss assembly tag $ASSEMBLY_TAG
echo run_local_abyss arguments $PARAMTERS

source $CONFIGFILE
readonly LOCAL_DATA
readonly RESULTDIR
readonly LOCAL_WORKDIR
readonly READDIR

declare -r WORKDIR=$LOCAL_WORKDIR/$PREFIX/$ASSEMBLY_TAG-local
declare -r LOCAL_READSDIR=$LOCAL_DATA/$READDIR
mkdir -p $WORKDIR