#!/bin/bash
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
declare -xr PREFIX=$1
declare -xr READS1=$2
declare -xr READS2=$3

#global varables
source $CONFIGFILE
readonly HPC_DATA
readonly LOCAL_DATA
readonly DO_PCACTUS
readonly DO_RAGOUT

declare -axi BSUBIDS
declare -axi PIDS
declare -xr SSH_SOURCEDIR=${HPC_DATA}${SOURCEDIR#$LOCAL_DATA}
declare -xr SSH_CONFIGFILE=${HPC_DATA}${CONFIGFILE#*$LOCAL_DATA}
declare -xr SSH_REPORTDIR=$HPC_DATA/$RESULTDIR/$PREFIX/ssh_out
declare -xr LOCAL_REPORTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX/ssh_out

function compile_strians_metrics
{
  ASSEMBLERS_FILE=$1;  source $SOURCEDIR/get_assemblers.sh 
  for (( i=1; i<=$NUM_ASSEMBLERS; ++i )); do
    echo "$PREFIX: In assembly loop i=$i"
    if [[ "${ASSEMBLER_TAG[i]"  == ".csv" ]]; then
      filename=$HPC_DATA/$RESULTDIR/${PREFIX}_metrics.csv
      rm $filename;
      touch $filename;
      for f in $HPC_DATA/$RESULTDIR/*/m_*_${ASSEMBLER_TAG[i]}; do
        echo $f >> $filename
        cat m_${PRFIX}_${ASSEMBLER_TAG[i]} >> $filename
      done
    fi
  done
}

function send_metrics
{
  #ASSEMBLERS_FILE=$1;  source $SOURCEDIR/get_assemblers.sh
  #for (( i=1; i<=$NUM_ASSEMBLERS; i++ )); do
  declare -r LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX
  echo "$PREFIX: do metrics for fastas in $LOCAL_RESULTDIR"
  for f in $LOCAL_RESULTDIR/*.fasta; do 
    assembly=`basename $f .fasta`
    echo "$PREFIX: metrics for $f"
    if [[ $METRICS_PASS1 ]]; then
        $SOURCEDIR/send_and_wait.sh $PREFIX/$assembly $READS1 $READS2 $METRICS_PASS1
    fi
    if [[ $METRICS_PASS2 ]]; then
      $SOURCEDIR/send_and_wait.sh $PREFIX/$assembly $READS1 $READS2 $METRICS_PASS2  
    fi
  done
  
  compile_strians_metrics $METRICS_PASS1
  compile_strians_metrics $METRICS_PASS2
}

function create_hal_database ()
{
  echo $PREFIX: -------------------- progressive cactus -------------------------
  # progressive cactus on results
  echo $PREFIX: Check to see if progessive cactus is required
  if [ "$DO_PCACTUS" = true ]; then
    echo $PREFIX: run progressive cactus
    $SOURCEDIR/progressiveCactus/run_progressive_cactus.sh $PREFIX 
    echo $PREFIX: finished running progressive cactus
  fi
}

function do_ragout_assembly ()
{
  echo $PREFIX: --------------------------- ragout -------------------------
  echo $PREFIX: check to see if regout is required
  if [ "$DO_RAGOUT" = true ]; then
    echo $PREFIX: run ragout
    $SOURCEDIR/ragout/run_ragout.sh $PREFIX 
    echo $PREFIX: finished running ragout
  fi
}

function main ()
{
  #source $SOURCEDIR/get_assemblers.sh
  echo "$PRFIX: about to call send and wait"
  #send_assemblies
  if [[ "$ASSEMBLERS_PASS1" ]]; then
    $SOURCEDIR/send_and_wait.sh $PREFIX $READS1 $READS2 $ASSEMBLERS_PASS1
  fi
    if [[ "$ASSEMBLERS_PASS2" ]]; then
    $SOURCEDIR/send_and_wait.sh $PREFIX $READS1 $READS2 $ASSEMBLERS_PASS2
  fi
  #echo "$PREFIX: in  main Abyss ssh bsub id is ${BSUBIDS[1]} with index 1"
  #echo $PREFIX: Assemblies sent off !!!!!!!!!!!!!!
  #wait_for_assemblies_to_finish
  echo "$PREFID: just called send and wait"
  create_hal_database
  do_ragout_assembly
  # Metrics?
  send_metrics
  #run_metrics.sh 
  # Yippee!!
  echo $PREFIX: Finished!!!!!!!!!!!!
}

main "$@"

#docker rm $(docker ps -a -q)
# /home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_strain.sh NCYC22 NCYC22/NCYC22.FP.fastq NCYC22/NCYC22.RP.fastq
#PREFIX=NCYC22
#READS1=NCYC22/NCYC22.FP.fastq
#READS2=N
