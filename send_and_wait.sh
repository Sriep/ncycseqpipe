#!/bin/bash
# send_and_wait.sh
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
declare -xr PREFIX=$1
declare -xr READS1=$2
declare -xr READS2=$3
declare -xr LOOPE_FILE=$4
echo "send and wait prefix is $PREFIX"
echo "send and wait reads1 is $READS1"
echo "send and wait loop file is $LOOPE_FILE"

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

function send_assemblies ()
{

  
  mkdir -p $LOCAL_DATA/$RESULTDIR/$PREFIX/ssh_out
  echo $PREFIX: ssh source directory at $SSH_SOURCEDIR
  echo $PREFIX: ssh configure directory at $SSH_CONFIGFILE
  echo $PREFIX: Made ssh reportdir at $SSH_REPORTDIR
  
  function send_local_assembly
  {
      echo "In send_local_assembly function"
      echo "send the tag ${ASSEMBLER_TAG[$index]}"
      echo "send the parmeters ${ASSEMBLER_PARAMTERS[$index]}"
      declare -ri index=$1
      $SOURCEDIR/tools/${ASSEMBLER_NAME[$index]}/run_${ASSEMBLER_NAME[$index]}_local.sh \
        $CONFIGFILE \
        $PREFIX \
        $READS1 \
        $READS2 \
        ${ASSEMBLER_TAG[$index]} \
        ${ASSEMBLER_PARAMTERS[$index]}
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
    echo "$PREFIX: start assembly over ssh link to $SSH_USERID@$SSH_ADDR"
    echo "output directory $SSH_REPORTDIR"
    echo "assembly parameters ${ASSEMBLER_PARAMTERS[$index]}"
    rtv=$(  ssh -tt -i $SSH_KEYFILE $SSH_USERID@$SSH_ADDR \
            "bsub \
            -o $SSH_REPORTDIR \
              $SSH_SOURCEDIR/tools/${ASSEMBLER_NAME[$index]}/run_${ASSEMBLER_NAME[$index]}_ssh.sh \
                $SSH_CONFIGFILE \
                $PREFIX \
                $READS1 \
                $READS2" \
                ${ASSEMBLER_TAG[$index]} \
                ${ASSEMBLER_PARAMTERS[$index]} \
         )
    echo "$PREFIX:  ssh assembly return value $rtv"
    extract_bsubid_from_rtv
    BSUBIDS[$index]=$rtv
    echo "$PREFIX in send_ssh_asembly : ssh bsub id is ${BSUBIDS[$index]} with index $index"
  }
  
  for (( i=1; i<=$NUM_ASSEMBLERS; ++i )); do
    echo "$PREFIX: In assembly loop i=$i"
    if [[ "${ASSEMBLER_LOCATION[$i]}" = "local" ]]; then
      send_local_assembly $i
    else 
      if [[ "${ASSEMBLER_LOCATION[$i]}" = "ssh" ]]; then 
        send_ssh_asembly $i
        echo "$PREFIX in send_assemblies : ssh bsub id is ${BSUBIDS[$i]} with index $i"
      fi
    fi
  done
}

function wait_for_assemblies_to_finish ()
{
  echo "$PREFIX: in wait_for_assemblies_to_finish  ssh bsub id is ${BSUBIDS[1]} with index 1"
  echo $PREFIX: ------------------------- Waiting ------------------------------
  echo "num assemblers $NUM_ASSEMBLERS"
  for (( i=1; i<=$NUM_ASSEMBLERS; i++ )); do
    echo "$PREFIX: In assembly loop i=$i"
    if [[ "${ASSEMBLER_LOCATION[$i]}" = "local" ]]; then
      echo "wait for pid ${PIDS[$i]}"
      wait ${PIDS[$i]}
    else 
      if [[ "${ASSEMBLER_LOCATION[$i]}" = "ssh" ]]; then         
        MY_SSH_REPORTFILE=$LOCAL_REPORTDIR/${BSUBIDS[$i]}.out
        echo "wait for bsub id ${BSUBIDS[$i]}"
        echo "look for file $MY_SSH_REPORTFILE"
        while  [[ ! -e $MY_SSH_REPORTFILE ]]; do 
          echo "cant find $MY_SSH_REPORTFILE about to sleep for a while"
          sleep 10s; 
        done
        echo "cant found $MY_SSH_REPORTFILE contnuing"
      fi
    fi
    echo "finished waiting for assembly number $i"
  done
  echo $PREFIX: Finished waiting!!!!!!!!!!!!!!!!!!!!
}

function main ()
{
  echo "in send and wait about to call source with parameter $4"
  echo $4
  ASSEMBLERS_FILE=$4;  source $SOURCEDIR/get_assemblers.sh 
  send_assemblies
  echo $PREFIX send and wait: Assemblies sent off !!!!!!!!!!!!!!
  wait_for_assemblies_to_finish
}

main "$@"