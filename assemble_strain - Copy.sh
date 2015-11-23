#!/bin/bash
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
declare -xr PREFIX=$1
declare -xr READS1=$2
declare -xr READS2=$3
echo "$PREFIX starting assemble_strain_sh"
#global varables
source $CONFIGFILE


declare -axi BSUBIDS
declare -axi PIDS
declare -xr SSH_SOURCEDIR=${HPC_DATA}${SOURCEDIR#$LOCAL_DATA}
declare -xr SSH_CONFIGFILE=${HPC_DATA}${CONFIGFILE#*$LOCAL_DATA}
declare -xr SSH_REPORTDIR=$HPC_DATA/$RESULTDIR/$PREFIX/ssh_out
declare -xr LOCAL_REPORTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX/ssh_out

declare -ax TOOL_NAME
declare -ax TOOL_LOCATION
declare -ax TOOL_TAG
declare -ax TOOL_PARAMTERS
declare -xi num_tools=0
declare -xi num_tools_this_pass=0

function send_tools ()
{
  mkdir -p $LOCAL_DATA/$RESULTDIR/$PREFIX/ssh_out
  echo $PREFIX: ssh source directory at $SSH_SOURCEDIR
  echo $PREFIX: ssh configure directory at $SSH_CONFIGFILE
  echo $PREFIX: Made ssh reportdir at $SSH_REPORTDIR
  
  function send_local_assembly ()
  {
      echo "send_local_assembly"
      echo "In send_local_assembly function tool name ${TOOL_NAME[$index]}"
      echo "send the tag ${TOOL_TAG[$index]}"
      echo "send the parmeters ${TOOL_PARAMTERS[$index]}"
      declare -ri index=$1
      $SOURCEDIR/tools/${TOOL_NAME[$index]}/run_${TOOL_NAME[$index]}_local.sh \
        $CONFIGFILE \
        $PREFIX \
        $READS1 \
        $READS2 \
        ${TOOL_TAG[$index]} \
        ${TOOL_PARAMTERS[$index]}
      ${PIDS[$index]}=$!
      echo "send_local_assembly pids ${PIDS[$index]}"
  }
  
  function send_ssh_asembly ()
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
              $SSH_SOURCEDIR/tools/${TOOL_NAME[$index]}/run_${TOOL_NAME[$index]}_ssh.sh \
                $SSH_CONFIGFILE \
                $PREFIX \
                $READS1 \
                $READS2" \
                ${TOOL_TAG[$index]} \
                ${TOOL_PARAMTERS[$index]} \
         )
    echo "$PREFIX:  ssh assembly return value $rtv"
    extract_bsubid_from_rtv
    BSUBIDS[$index]=$rtv
    echo "$PREFIX in send_ssh_asembly : ssh bsub id is ${BSUBIDS[$index]} with index $index"
  }
  
  # $1 The number of tools to run in this pass
  declare start_tool=$(($num_tools - $1 ))
  echo "for (( i=$start_tool ; i <= $num_tools ; ++i )); do"
  for (( i="$start_tool" ; i <= "$num_tools" ; ++i )); do
    echo "$PREFIX send_tools: In assembly loop i=$i tool is ${TOOL_NAME[$i]}"
    if [[ "${TOOL_LOCATION[$i]}" = local ]]; then
      send_local_assembly $i
    else 
      if [[ "${TOOL_LOCATION[$i]}" = ssh ]]; then 
        send_ssh_asembly $i
        echo "$PREFIX in send_tools : ssh bsub id is ${BSUBIDS[$i]} with index $i"
      fi
    fi
  done
}

function wait_for_tools_to_finish ()
{
  # $1 The number of tools to run in this pass
  declare start_tool=$(($num_tools - $1 ))
  
  echo "$PREFIX: in wait_for_assemblies_to_finish  ssh bsub id is ${BSUBIDS[1]} with index 1"
  echo $PREFIX: ------------------------- Waiting ------------------------------
  echo "num assemblers $NUM_ASSEMBLERS"
  for (( i=$start_tool; i<$num_tools; ++i )); do
    echo "$PREFIX: In assembly loop i=$i"
    if [[ "${TOOL_LOCATION[$i]}" = local ]]; then
      echo "wait for pid ${PIDS[$i]}"
      wait ${PIDS[$i]}
    else 
      if [[ "${TOOL_LOCATION[$i]}" = ssh ]]; then         
        MY_SSH_REPORTFILE=$LOCAL_REPORTDIR/${BSUBIDS[$i]}.out
        echo "wait for bsub id ${BSUBIDS[$i]}"
        echo "look for file $MY_SSH_REPORTFILE"
        while  [[ ! -e $MY_SSH_REPORTFILE ]]; do 
          echo "cant find $MY_SSH_REPORTFILE about to sleep for a while"
          sleep $SLEEP_TIME; 
        done
        echo "cant found $MY_SSH_REPORTFILE contnuing"
      fi
    fi
    echo "finished waiting for tool number $i"
  done
  echo "$PREFIX: Finished waiting!!!!!!!!!!!!!!!!!!!!"
}

function parse_recipe_file ()
{
  while read col1 col2 col3 col4; do 
    echo -e "parse_recipe_file data: $col1 \tlocation $col2 \ttag $col3 \tparamter $col4"
    echo "parse_recipe_file num of assemblers $num_tools"
    case "$col1" in
      "send_and_wait" )
        echo "parse_recipe_file: case send_and_wait"
        num_tools=$(($num_tools + 1 ))
        TOOL_NAME[num_tools]="send and wait"
        echo "about to call send_tools $num_tools_this_pass"
        send_tools $num_tools_this_pass
        echo "about to call wait_for_tools_to_finish $num_tools_this_pass"
        wait_for_tools_to_finish $num_tools_this_pass
        num_tools_this_pass=0
        echo "finsihed send and wait"
        ;;
      \#* | "" )
        echo "parse_recipe_file case commeted out line"
        ;;
      * )
        echo "parse_recipe_file case tool $col1 added to list"
        num_tools=$(($num_tools + 1 ))
        num_tools_this_pass=$(($num_tools_this_pass + 1 ))
        TOOL_NAME[num_tools]=$col1
        TOOL_LOCATION[num_tools]=$col2
        TOOL_TAG[num_tools]=$col3
        TOOL_PARAMTERS[num_tools]=$col4        
        ;;
    esac
    echo "parse_recipe_file done onto next line"
    echo
  done < $RECIPEFILE
  echo "parse_recipe_file finshed file"

function main ()
{
  echo "In assemble_strain_sh main"
  if [[ -n "RECIPEFILE" ]]; then
    parse_recipe_file
  fi
}

main "$@"

#docker rm $(docker ps -a -q)
# /home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_strain.sh NCYC22 NCYC22/NCYC22.FP.fastq NCYC22/NCYC22.RP.fastq
#PREFIX=NCYC22
#READS1=NCYC22/NCYC22.FP.fastq
#READS2=N
#hi there
