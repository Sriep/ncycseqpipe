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
declare -xr SSH_RESULTDIRDIR=$HPC_DATA/$RESULTDIR/$PREFIX
declare -xr LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX

source get_metrics.sh

function send_assemblies ()
{

  
  mkdir -p $LOCAL_DATA/$RESULTDIR/$PREFIX/ssh_out
  echo $PREFIX: ssh source directory at $SSH_SOURCEDIR
  echo $PREFIX: ssh configure directory at $SSH_CONFIGFILE
  echo $PREFIX: Made ssh reportdir at $SSH_REPORTDIR
  
  function send_local_assembly
  {
      echo "In send_local_assembly function"
      declare -ri index=$1
      $SOURCEDIR/metrics/${METRIC_NAME[$index]}/run_${METRIC_NAME[$index]}_local.sh \
        $CONFIGFILE \
        $PREFIX \
        $READS1 \
        $READS2 \
        ${METRIC_TAG[$index]} \
        ${METRIC_PARAMTERS[$index]}
      ${PIDS[$index]}=$!
  }
  
  function send_ssh_asembly
  {
    echo "$PREFIX: about to send ssh assembly"
    declare rtv
    function extract_bsubid_from_rtv ()
    {
      #extract id from Job <131068> is submitted to default queue <NBI-Test128>.
      #DANGER requires name NBI-Test128 stay at 11 characters!!!
      rtv=${rtv:5:-47}
    }
    
    declare -ri index=$1
    echo "$PREFIX: start abyss assembly over ssh link to $SSH_USERID@$SSH_ADDR"
    echo "output directory $SSH_REPORTDIR"
    echo "assembly parameters ${METRIC_PARAMTERS[$index]}"
    rtv=$(  ssh -tt -i $SSH_KEYFILE $SSH_USERID@$SSH_ADDR \
            "bsub \
            -o $SSH_REPORTDIR \
              $SSH_SOURCEDIR/metrics/${METRIC_NAME[$index]}/run_${METRIC_NAME[$index]}_ssh.sh \
                $SSH_CONFIGFILE \
                $PREFIX \
                $READS1 \
                $READS2" \
                ${METRIC_TAG[$index]} \
                ${METRIC_PARAMTERS[$index]} \
         )
    echo "$PREFIX:  Abyss ssh assembly return value $rtv"
    extract_bsubid_from_rtv
    BSUBIDS[$index]=$rtv
    echo "$PREFIX in send_ssh_asembly : Abyss ssh bsub id is ${BSUBIDS[$index]} with index $index"
  }
  
  for (( i=1; i<=$NUM_METRICS; ++i )); do
    echo "$PREFIX: In assembly loop i=$i"
    if [[ "${METRIC_LOCATION[$i]}" = "local" ]]; then
      send_local_assembly $i
    else 
      if [[ "${METRIC_LOCATION[$i]}" = "ssh" ]]; then 
        send_ssh_asembly $i
        echo "$PREFIX in send_assemblies : Abyss ssh bsub id is ${BSUBIDS[$i]} with index $i"
      fi
    fi
  done
}

function main ()
{
  for f in LOCAL_RESULTDIR/*.fasta; do
    for (( i=1; i<=$NUM_METRICS; ++i )); do
      echo "$PREFIX: In assembly loop i=$i"
      if [[ "${METRIC_LOCATION[$i]}" = "local" ]]; then
        send_local_assembly $i
      else 
        if [[ "${METRIC_LOCATION[$i]}" = "ssh" ]]; then 
          send_ssh_asembly $i
          echo "$PREFIX in send_assemblies : Abyss ssh bsub id is ${BSUBIDS[$i]} with index $i"
        fi
      fi
    done
  done
}

main "$@"