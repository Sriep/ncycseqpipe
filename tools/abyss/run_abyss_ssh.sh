#!/bin/bash
# 
source hpccore-5
source abyss-1.9.0
declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/ssh_header.sh

#-------------------------- Assembly specific code here --------------------
echo ABYSS ssh: about to run ssh abyss on $PREFIX


#declare -a args
#IFS=' ' read -ra args <<< "$PARAMTERS"
#echo "ABYSS ssh: arguments ${args[@]/#/}"
#${args[@]/#/}
#echo "abyss-pek=${args[0]} j=${args[1]} name=$WORKDIR/$PREFIX in=$SSH_READSDIR/$READS1 $SSH_READSDIR/$READS2"
#echo "ABYSS ssh: About to run abyss"
abyss-pe \
		$PARAMTERS \
		name=$WORKDIR/$PREFIX \
		in="$SSH_READSDIR/$READS1 $SSH_READSDIR/$READS2"

#Give location of result files
CONTIGS=$WORKDIR/$PREFIX-6.fa
SCAFFOLDS=$WORKDIR/$PREFIX-8.fa
#-------------------------- Assembly specific code here --------------------

source $SOURCEDIR/ssh_footer.sh
