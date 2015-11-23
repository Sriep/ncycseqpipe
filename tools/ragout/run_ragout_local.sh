#!/bin/bash
declare -r CONFIGFILE=$1
declare -r PREFIX=$2

source $CONFIGFILE
readonly LOCAL_DATA
readonly RESULTDIR
readonly LOCAL_WORKDIR
readonly RAGOUT_TARGET

declare -r WORKDIR=$LOCAL_WORKDIR/$PREFIX/ragout
declare -r LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX
mkdir -p $WORKDIR
mkdir -p $LOCAL_RESULTDIR

# Create the ragout configurartion file
rm $WORKDIR/$PREFIX.ragout.recipe
touch $WORKDIR/$PREFIX.ragout.recipe
echo "*.draft" = true >> $WORKDIR/$PREFIX.ragout.recipe
echo -n ".references =  " >> $WORKDIR/$PREFIX.ragout.recipe
declare seperator=
for f in $LOCAL_RESULTDIR/*.fasta; do
	echo -n "$seperator"$(basename "$f" .fasta) >> $WORKDIR/$PREFIX.ragout.recipe
  seperator=","
done
echo >> $WORKDIR/$PREFIX.ragout.recipe
#remove trailing commma
#sed -i '$s/,$//' $WORKDIR/$PREFIX.ragout.recipe
echo ".target = $RAGOUT_TARGET"  >> $WORKDIR/$PREFIX.ragout.recipe
echo ".hal = /data/$PREFIX.hal" >> $WORKDIR/$PREFIX.ragout.recipe

echo  $PREFIX Ragout: Here is  ragout sequence file for $PREFIX
cat $WORKDIR/$PREFIX.ragout.recipe
echo  $PREFIX Ragout: Finished ragout sequence file for $PREFIX

docker run --name ragoutpy$PREFIX  \
	--volume=$WORKDIR:/workdir \
  --volume=$LOCAL_RESULTDIR:/data \
	sriep/ragout \
    --threads $RAGOUT_THREADS \
    --outdir /workdir \
    --synteny hal \
    /workdir/$PREFIX.ragout.recipe 
echo $PREFIX Ragout: Ragout return code is $?
docker rm -f ragoutpy$PREFIX 
echo $PREFIX Ragout: ragoutpy$PREFIX  stopped

cp  $WORKDIR/${RAGOUT_TARGET}_scaffolds.fasta  $WORKDIR/r${PREFIX}i.fasta
cat $WORKDIR/${RAGOUT_TARGET}_unplaced.fasta >> $WORKDIR/r${PREFIX}i.fasta
mv  $WORKDIR/r${PREFIX}i.fasta $LOCAL_RESULTDIR/r${PREFIX}i.fasta

#export PYTHONPATH=$PYTHONPATH:/home/shepperp/software/progressiveCactus/submodules
#ragout.py --threads 8 --outdir /home/shepperp/documents/test/workdir/NCYC22/ragout3 --synteny hal  /home/shepperp/documents/test/workdir/NCYC22/ragout3/NCYC22.ragout.recipe 
