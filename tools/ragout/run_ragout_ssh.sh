#!/bin/bash
# 
source hpccore-5
source ragout-1.2
source python-2.7.11
source hal-2.0

declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/ssh_header.sh
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
readonly RAGOUT_TARGET=${args[0]}${args[1]}${PREFIX}i
debug_msg  ${LINENO}  "Ragout target is $RAGOUT_TARGET"

# Create the ragout configurartion file
> $WORKDIR/$PREFIX.ragout.recipe
echo "*.draft" = true >> $WORKDIR/$PREFIX.ragout.recipe
echo -n ".references =  " >> $WORKDIR/$PREFIX.ragout.recipe
declare seperator=
for f in $SSH_RESULTDIR/*.fasta; do
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
echo ".hal = $SSH_RESULTDIR/$PREFIX.hal" >> $WORKDIR/$PREFIX.ragout.recipe

debug_msg  ${LINENO}  "$PREFIX Ragout: Here is  ragout sequence file for $PREFIX"
cat $WORKDIR/$PREFIX.ragout.recipe
debug_msg  ${LINENO}  "$PREFIX Ragout: Finished ragout sequence file for $PREFIX"

#docker run --name ragoutpy$PREFIX  \
#	--volume=$WORKDIR:/workdir \
#  --volume=$LOCAL_RESULTDIR:/data \
#	sriep/ragout \
#    --threads 10 \
#    --outdir /workdir \
#    --synteny hal \
#    /workdir/$PREFIX.ragout.recipe 
#remove_docker_container ragoutpy$PREFIX

ragout.py --threads 10 \
          --outdir $WORKDIR \
          --synteny hal \
          $WORKDIR/$PREFIX.ragout.recipe

cp  $WORKDIR/${RAGOUT_TARGET}_scaffolds.fasta  $WORKDIR/rs${PREFIX}i.fasta
cat $WORKDIR/${RAGOUT_TARGET}_unplaced.fasta >> $WORKDIR/rs${PREFIX}i.fasta
mv  $WORKDIR/rs${PREFIX}i.fasta $SSH_RESULTDIR/rs${PREFIX}i.fasta
#SCAFFOLDS=
#-------------------------- Assembly specific code here --------------------
source $SOURCEDIR/ssh_footer.sh
