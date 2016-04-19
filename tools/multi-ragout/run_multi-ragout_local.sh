#!/bin/bash
# 
declare -r SOURCEDIR="$1"
source $SOURCEDIR/tools/local_header.sh
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
function run_ragout ()
{
  tail="$1_$2$3$4$5$6"
  target="${1}${PREFIX}i"
  result="rs${PREFIX}$tail"
  workdir="$WORKDIR/$tail"
  mkdir -p "$workdir"
  debug_msg  ${LINENO}  "target is $target"
  
  recipieF="$workdir/${result}_ragout.recipe"
  > "$recipieF"
  echo "*.draft" = true >> "$recipieF"
  echo -n ".references =  " >> "$recipieF"
  declare seperator=
  for (( p=2 ; p <= "$#" ; ++p )); do
    strain=${!p}${PREFIX}i
    debug_msg  ${LINENO}  "strain in loop is $strain"
    echo -n "$seperator"$strain >> "$recipieF"
    seperator=","
  done
  echo >> "$recipieF"
  echo ".target = $target"  >> "$recipieF"
  echo ".hal = /data/$PREFIX.hal" >> "$recipieF"

  cat "$workdir/$recipieF"

  docker run --name ragoutpy$result  \
    --volume=$workdir:/workdir \
    --volume=$LOCAL_RESULTDIR:/data \
    sriep/ragout \
      --threads 10 \
      --outdir /workdir \
      --synteny hal \
      /workdir/${result}_ragout.recipe
  remove_docker_container ragoutpy$result

  cp  $workdir/${target}_scaffolds.fasta  $workdir/${result}.fasta
  cat $workdir/${target}_unplaced.fasta >> $workdir/${result}.fasta
  mv  $workdir/${result}.fasta $LOCAL_RESULTDIR/${result}.fasta
}

run_ragout yc as ds fs ss hs gs cs
run_ragout yc as ds fs ss hs cs
run_ragout yc as fs ss cs
run_ragout yc ds fs cs
run_ragout yc as cs
run_ragout yc cs


run_ragout ac yc as ds fs ss hs gs cs 
run_ragout ac yc as ds fs ss hs cs 
run_ragout ac yc ds fs ss hs cs 
run_ragout ac yc as fs cs 
run_ragout ac yc as cs 
run_ragout ac yc cs 
run_ragout ac cs 

run_ragout cs yc as ds fs ss hs gs  
run_ragout cs ac as ds fs ss hs  
run_ragout cs yc ds fs ss hs  
run_ragout cs yc as ss hs gs  
run_ragout cs yc as fs  
run_ragout cs yc as 
run_ragout cs as 

#-------------------------- Assembly specific code here --------------------
source $SOURCEDIR/tools/local_footer.sh
