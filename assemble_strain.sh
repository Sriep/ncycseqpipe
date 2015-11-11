#!/bin/bash
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
declare -r PREFIX=$1
declare -r READS1=$2
declare -r READS2=$3

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
      declare -ri index=$1
      $SOURCEDIR/${ASSEMBLER_NAME[$index]}/run_${ASSEMBLER_NAME[$index]}_local.sh \
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
    echo "$PREFIX: start abyss assembly over ssh link to $SSH_USERID@$SSH_ADDR"
    echo "output directory $SSH_REPORTDIR"
    echo "assembly parameters ${ASSEMBLER_PARAMTERS[$index]}"
    rtv=$(  ssh -tt -i $SSH_KEYFILE $SSH_USERID@$SSH_ADDR \
            "bsub \
            -o $SSH_REPORTDIR \
              $SSH_SOURCEDIR/${ASSEMBLER_NAME[$index]}/run_${ASSEMBLER_NAME[$index]}_ssh.sh \
                $SSH_CONFIGFILE \
                $PREFIX \
                $READS1 \
                $READS2" \
                ${ASSEMBLER_TAG[$index]} \
                ${ASSEMBLER_PARAMTERS[$index]} \
         )
    echo "$PREFIX:  Abyss ssh assembly return value $rtv"
    extract_bsubid_from_rtv
    BSUBIDS[$index]=$rtv
    echo "$PREFIX in send_ssh_asembly : Abyss ssh bsub id is ${BSUBIDS[$index]} with index $index"
  }
  
  for (( i=1; i<=$NUM_ASSMEBLERS; ++i )); do
    echo "$PREFIX: In assembly loop i=$i"
    if [[ "${ASSEMBLER_LOCATION[$i]}" = "local" ]]; then
      send_local_assembly $i
    else 
      if [[ "${ASSEMBLER_LOCATION[$i]}" = "ssh" ]]; then 
        send_ssh_asembly $i
        echo "$PREFIX in send_assemblies : Abyss ssh bsub id is ${BSUBIDS[$i]} with index $i"
      fi
    fi
  done
}

function wait_for_assemblies_to_finish ()
{
  echo "$PREFIX: in wait_for_assemblies_to_finish  Abyss ssh bsub id is ${BSUBIDS[1]} with index 1"
  echo $PREFIX: ------------------------- Waiting ------------------------------
  echo "num assemblers $NUM_ASSMEBLERS"
  for (( i=1; i<=$NUM_ASSMEBLERS; i++ )); do
    echo "$PREFIX: In assembly loop i=$i"
    if [[ "${ASSEMBLER_LOCATION[$i]}" = "local" ]]; then
      echo "wait for pid ${PIDS[$i]}"
      wait ${PIDS[$i]}
    else 
      if [[ "${ASSEMBLER_LOCATION[$i]}" = "ssh" ]]; then         
        ABYSS_SSH_REPORTFILE=$LOCAL_REPORTDIR/${BSUBIDS[$i]}.out
        echo "wait for bsub id ${BSUBIDS[$i]}"
        echo "look for file $ABYSS_SSH_REPORTFILE"
        while  [[ ! -e $ABYSS_SSH_REPORTFILE ]]; do 
          echo "cant find $ABYSS_SSH_REPORTFILE about to sleep for a while"
          sleep 10s; 
        done
        echo "cant found $ABYSS_SSH_REPORTFILE contnuing"
      fi
    fi
    echo "finished waiting for assembly number $i"
  done
  echo $PREFIX: Finished waiting!!!!!!!!!!!!!!!!!!!!
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
  source $SOURCEDIR/get_assemblers.sh
  send_assemblies
  echo "$PREFIX: in  main Abyss ssh bsub id is ${BSUBIDS[1]} with index 1"
  echo $PREFIX: Assemblies sent off !!!!!!!!!!!!!!
  wait_for_assemblies_to_finish
  create_hal_database
  do_ragout_assembly
  # Metrics?
  # Yippee!!
  echo $PREFIX: Finished!!!!!!!!!!!!
}

main "$@"

#docker rm $(docker ps -a -q)
# /home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_strain.sh NCYC22 NCYC22/NCYC22.FP.fastq NCYC22/NCYC22.RP.fastq
#PREFIX=NCYC22
#READS1=NCYC22/NCYC22.FP.fastq
#READS2=N
