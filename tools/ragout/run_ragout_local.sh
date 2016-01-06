#!/bin/bash
# 
declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/local_header.sh
# PREFIX - Name of strain to assemble
# READS1 - First set of paired end reads, relative to $LOCAL_READSDIR
# READS2 - Second set of paired end reads, relative to $LOCAL_READSDIR
# ASSEMBLY_TAG - Tag to indicate the output from this tool
# PARAMETERS - Data used to paramatirse this tool
#
# WORKDIR - Directory in which to put tempory work files
# READSDIR - Directory where paired end reads are located
# LOCAL_RESULTDIR - Directory where results are to be copied
#-------------------------- Assembly specific code here --------------------
readonly RAGOUT_TARGET=$PARAMETERS
debug_msg  ${LINENO}  "Ragout target is $RAGOUT_TARGET"
# Create the ragout configurartion file
> $WORKDIR/$PREFIX.ragout.recipe
echo "*.draft" = true >> $WORKDIR/$PREFIX.ragout.recipe
echo -n ".references =  " >> $WORKDIR/$PREFIX.ragout.recipe
declare seperator=
for f in $LOCAL_RESULTDIR/*.fasta; do
  assembly=$(basename "$f" .fasta)
  if [[ "$assembly" != "$RAGOUT_TARGET" ]]; then 
    echo -n "$seperator"$assembly >> $WORKDIR/$PREFIX.ragout.recipe
    seperator=","
  fi
done
echo >> $WORKDIR/$PREFIX.ragout.recipe
#remove trailing commma
#sed -i '$s/,$//' $WORKDIR/$PREFIX.ragout.recipe
echo ".target = $RAGOUT_TARGET"  >> $WORKDIR/$PREFIX.ragout.recipe
echo ".hal = /data/$PREFIX.hal" >> $WORKDIR/$PREFIX.ragout.recipe

debug_msg  ${LINENO}  "$PREFIX Ragout: Here is  ragout sequence file for $PREFIX"
cat $WORKDIR/$PREFIX.ragout.recipe
debug_msg  ${LINENO}  "$PREFIX Ragout: Finished ragout sequence file for $PREFIX"

docker run --name ragoutpy$PREFIX  \
	--volume=$WORKDIR:/workdir \
  --volume=$LOCAL_RESULTDIR:/data \
	sriep/ragout \
    --threads 10 \
    --outdir /workdir \
    --synteny hal \
    /workdir/$PREFIX.ragout.recipe 
#echo $PREFIX Ragout: Ragout return code is $?
#docker rm -f ragoutpy$PREFIX 
#echo $PREFIX Ragout: ragoutpy$PREFIX  stopped
remove_docker_container ragoutpy$PREFIX

cp  $WORKDIR/${RAGOUT_TARGET}_scaffolds.fasta  $WORKDIR/r${PREFIX}i.fasta
cat $WORKDIR/${RAGOUT_TARGET}_unplaced.fasta >> $WORKDIR/r${PREFIX}i.fasta
mv  $WORKDIR/r${PREFIX}i.fasta $LOCAL_RESULTDIR/r${PREFIX}i.fasta
#SCAFFOLDS=
#-------------------------- Assembly specific code here --------------------
source $SOURCEDIR/local_footer.sh
