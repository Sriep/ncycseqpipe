#!/bin/bash -e
# 
declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/local_header.sh

#-------------------------- Assembly specific code here --------------------

echo ABYSS: about to run local abyss on $PREFIX

#declare -a args
#IFS=' ' read -ra args <<< "$PARAMTERS"
#echo "arguments ${args[@]/#/}"
#${args[@]/#/}
#k=${args[0]} j=${args[1]} 
docker run \
	--name abysspe$PREFIX  \
	-v $LOCAL_READSDIR:/reads:ro \
	-v $WORKDIR:/results \
	sriep/abyss-pe \
		$PARAMTERS \
		name=/results/$PREFIX \
		in="/reads/$READS1 /reads/$READS2"
echo ABYSS: abyss return code is $?
docker rm -f abysspe$PREFIX 
echo ABYSS: abysspe$PREFIX  stopped

#Give location of result files
CONTIGS=$WORKDIR/$PREFIX-6.fa
SCAFFOLDS=$WORKDIR/$PREFIX-8.fa
#-------------------------- Assembly specific code here --------------------

echo scaffold file abyss $CONTIGS
source $SOURCEDIR/local_footer.sh

#declare  CONFIGFILE=/home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipe.cfg
#declare SSH_CONFIGFILE
#declare  PREFIX=NCYC22
#declare  READS1=/NCYC22/NCYC22.FP.fastq
#declare  READS2=/NCYC22/NCYC22.RP.fastq
#declare  ASSEMBLY_TAG=a
#declare  PARAMTERS=k=80 j=10
