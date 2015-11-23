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
declare -r LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX

declare -ax TOOL_TYPE
declare -ax TOOL_NAME
declare -ax TOOL_LOCATION
declare -ax TOOL_TAG
declare -ax TOOL_PARAMTERS
declare -xi num_tools=0
declare -xi num_tools_this_pass=0

function display_tool_array ()
{
  echo display_tool_array 
  for (( i=0 ; i <= "$num_tools" ; ++i )); do       
    echo -e "index $i \ttype  ${TOOL_TYPE[$i]} \tname ${TOOL_NAME[$i]} \tlocation ${TOOL_LOCATION[$i]} \ttag ${TOOL_TAG[$i]} \tparameters ${TOOL_PARAMTERS[$i]}"
  done
}

function send_tools ()
{
  # $1 The number of tools to run in this pass
  mkdir -p "$LOCAL_DATA/$RESULTDIR/$PREFIX/ssh_out"
  echo "$PREFIX: ssh source directory at $SSH_SOURCEDIR"
  echo "$PREFIX: ssh configure directory at $SSH_CONFIGFILE"
  echo "$PREFIX: Made ssh reportdir at $SSH_REPORTDIR"
  
  function send_local_tool ()
  {
      declare -r TOOLPREFIX=$1
      declare -ri index=$2
      echo "send_local_assembly tool prefix $TOOLPREFIX"
      echo "In send_local_assembly function tool name ${TOOL_NAME[$index]}"
      echo send the tag "${TOOL_TAG[$index]}"
      echo "send the parmeters ${TOOL_PARAMTERS[$index]}"
      "$SOURCEDIR/tools/${TOOL_NAME[$index]}/run_${TOOL_NAME[$index]}_local.sh" \
        "$CONFIGFILE" \
        "$TOOLPREFIX" \
        "$READS1" \
        "$READS2" \
        "${TOOL_TAG[$index]}" \
        "${TOOL_PARAMTERS[$index]}" \
        "$PARALLEL"
      PIDS[$index]="${PIDS[$index]} $!"
      echo "send_local_assembly pids ${PIDS[$index]}"
      echo num of tools is currently $num_tools
      echo end of send_local_tool endo fo send_local_tool
  }
  
  function send_ssh_tool ()
  {
    declare -r TOOLPREFIX=$1
    declare -ri index=$2
    echo "$PREFIX: about to send ssh assembly tool prefix $TOOLPREFIX"
    declare rtv
    function extract_bsubid_from_rtv ()
    {
      #extract id from Job <131068> is submitted to default queue <NBI-Test128>.
      #DANGER requires name NBI-Test128 stay at 11 characters!!!
      echo In extract_bsubid_from_rtv rtv is "$rtv"
      rtv=${rtv:5:-47}
      echo In extract_bsubid_from_rtv  changed rtv to "$rtv"
    }
    
    echo "$TOOLPREFIX: start assembly over ssh link to $SSH_USERID@$SSH_ADDR"
    echo "output directory $SSH_REPORTDIR"
    echo "assembly parameters ${ASSEMBLER_PARAMTERS[$index]}"
    rtv=$(  ssh -tt -i "$SSH_KEYFILE" "$SSH_USERID@$SSH_ADDR" \
            bsub \
            -o "$SSH_REPORTDIR" \
               "$SSH_SOURCEDIR/tools/${TOOL_NAME[$index]}/run_${TOOL_NAME[$index]}_ssh.sh \
                $SSH_CONFIGFILE \
                $TOOLPREFIX \
                $READS1 \
                $READS2 \
                ${TOOL_TAG[$index]} \
                ${TOOL_PARAMTERS[$index]}" \
         )
    echo "$TOOLPREFIX:  ssh assembly return value $rtv"
    echo num of tools is currently $num_tools
    extract_bsubid_from_rtv
    BSUBIDS[$index]="${BSUBIDS[$index]} $rtv"
    echo "$TOOLPREFIX in send_ssh_asembly : ssh bsub id is ${BSUBIDS[$index]} with index $index"
    echo end of send_ssh_tool end of send_ssh_tool
  }
  
  function send_tool ()
  {
    prfix=$1
    index=$2
    echo "$prfix send_tools: In assembly loop i=$index tool is ${TOOL_NAME[$index]}"
    if [[ "${TOOL_LOCATION[$index]}" = local ]]; then
      send_local_tool "$prfix" $index
    else 
      if [[ "${TOOL_LOCATION[$index]}" = ssh ]]; then 
        send_ssh_tool "$prfix" $index
        echo "$prfix" in send_tools : ssh bsub id is "${BSUBIDS[$index]}" with index $index
      fi
    fi
    echo END of send_tool END of send_tool END of send_tool END of send_tool
  }
  
  echo before send local tools
  display_tool_array
  
  # $1 The number of tools to run in this pass
  declare start_tool=$(($num_tools - $1 ))
  echo "for (( i=$start_tool ; i <= $num_tools ; ++i )); do"
  for (( i="$start_tool" ; i <= "$num_tools" ; ++i )); do
    if [[ "$TOOL_TYPE[$i]" == $METRIC ]]; then
      for f in $LOCAL_RESULTDIR/*.fasta; do 
        assembly=$(basename $f .fasta)
        echo "$PREFIX: TOOL_NAME[$i] metric for $f"
        send_tool "$PREFIX/$assembly" $i
      done
    else
      send_tool "$PREFIX" $i
    fi
    echo in send local tools for loop with index = $i
  done
  echo after send local tools
  display_tool_array
  echo EEEEEEEEEEEEEEEEEEEENd OFFFFFFFFFFFFFFFFFFFFF send tools
}

function wait_for_tools_to_finish ()
{
  # $1 The number of tools to run in this pass
  declare start_tool=$(($num_tools - $1 ))
  
  echo "$PREFIX: in wait_for_assemblies_to_finish  ssh bsub id is ${BSUBIDS[1]} with index 1"
  echo "$PREFIX: ------------------------- Waiting ------------------------------"
  echo "num assemblers $NUM_ASSEMBLERS"
  for (( i=$start_tool; i<$num_tools; ++i )); do
    echo "$PREFIX: In assembly loop i=$i"
    if [[ "${TOOL_LOCATION[$i]}" = local ]]; then
      echo "wait for pid ${PIDS[$i]}"
      wait "${PIDS[$i]}"
    else 
      if [[ "${TOOL_LOCATION[$i]}" = ssh ]]; then         
        MY_SSH_REPORTFILE=$LOCAL_REPORTDIR/${BSUBIDS[$i]}.out
        echo "wait for bsub id ${BSUBIDS[$i]}"
        echo "look for file $MY_SSH_REPORTFILE"
        while  [[ ! -e $MY_SSH_REPORTFILE ]]; do 
          echo "cant find $MY_SSH_REPORTFILE about to sleep for a while"
          sleep "$SLEEP_TIME" 
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
  while read -r col1 col2 col3 col4 col5; do 
    echo -e "parse_recipe_file data: type $col1 $col2 \tlocation $col3 \ttag $col4 \tparamter $col5 "
    echo "parse_recipe_file num of assemblers $num_tools"
    case "$col1" in
      "$SEND_AND_WAIT" )
        echo "parse_recipe_file: case send_and_wait"
        num_tools=$(($num_tools + 1 ))
        TOOL_NAME[num_tools]="send and wait"
        echo "about to call send_tools $num_tools_this_pass"
        send_tools $num_tools_this_pass
        echo "about to call wait_for_tools_to_finish $num_tools_this_pass"
        wait_for_tools_to_finish $num_tools_this_pass
        num_tools_this_pass=0
        echo "finsihed send and wait"
        echo
        ;;
      \#* | "" )
        echo "parse_recipe_file case commeted out line"
        ;;
      $ASDEMBLER | $METRIC )
        echo "parse_recipe_file case assembler tool $col1 added to list"
        num_tools=$(($num_tools + 1 ))
        num_tools_this_pass=$(($num_tools_this_pass + 1 ))
        TOOL_TYPE[num_tools]=$col1
        TOOL_NAME[num_tools]=$col2
        TOOL_LOCATION[num_tools]=$col3
        TOOL_TAG[num_tools]=$col4
        TOOL_PARAMTERS[num_tools]=$col5        
        ;;
      *)
        echo "parse_recipe_file unrecognised entry ignore line" 
        ;;
    esac
    echo "parse_recipe_file done onto next line"
    echo
  done < "$RECIPEFILE"
  echo "parse_recipe_file finshed file"
}

function main ()
{
  echo "In assemble_strain_sh main"
  if [[ -n "$RECIPEFILE" ]]; then
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
