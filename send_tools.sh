PROGNAME=$(basename $0)

function send_tools ()
{
  # $1 The number of tools to run in this pass
  mkdir -p "$LOCAL_DATA/$RESULTDIR/$PREFIX/ssh_out"
  debug_msg  ${LINENO} "$PREFIX: ssh source directory at $SSH_SOURCEDIR"
  debug_msg  ${LINENO} "$PREFIX: ssh configure directory at $SSH_CONFIGFILE"
  debug_msg  ${LINENO} "$PREFIX: Made ssh reportdir at $SSH_REPORTDIR"
  
  function send_local_tool ()
  {
      declare -r TOOLPREFIX=$1
      declare -ri index=$2
      debug_msg  ${LINENO}  "send_local_assembly tool prefix $TOOLPREFIX"
      debug_msg  ${LINENO}  "In send_local_assembly function tool name ${TOOL_NAME[$index]}"
      debug_msg  ${LINENO}  "send the tag ${TOOL_TAG[$index]}"
      debug_msg  ${LINENO}  "send the parmeters ${TOOL_PARAMTERS[$index]}"
      if [[ "$PARALLEL" == "&" ]]; then
        debug_msg  ${LINENO}  parallel is ampusand
        $SOURCEDIR/tools/${TOOL_NAME[$index]}/run_${TOOL_NAME[$index]}_local.sh \
          "$CONFIGFILE" \
          "$TOOLPREFIX" \
          "$READS1" \
          "$READS2" \
          "${TOOL_TAG[$index]}" \
          "${TOOL_PARAMTERS[$index]}" \
          &
          process_num=$!
          #set +u; process_num=$!; set -u
      else
        parrelle is not not ampusand
        $SOURCEDIR/tools/${TOOL_NAME[$index]}/run_${TOOL_NAME[$index]}_local.sh \
          "$CONFIGFILE" \
          "$TOOLPREFIX" \
          "$READS1" \
          "$READS2" \
          "${TOOL_TAG[$index]}" \
          "${TOOL_PARAMTERS[$index]}"
          process_num=          
      fi
      #set +u; process_num=$!; set -u
      debug_msg ${LINENO} "process number is $process_num"
      debug_msg  ${LINENO} "process number is $process_num"
      if [[ -n "$process_num" ]]; then
        #process_num=$!
        debug_msg ${LINENO} process number is $process_num
        PIDS[$index]="${PIDS[$index]} $process_num"
        debug_msg ${LINENO} "send_local_assembly pids ${PIDS[$index]}"
      fi
      debug_msg  ${LINENO} "num of tools is currently $end_tool"
      debug_msg  ${LINENO} "end of send_local_tool endo fo send_local_tool"
  }
  
  function send_ssh_tool ()
  {
    declare -r TOOLPREFIX=$1
    declare -ri index=$2
    debug_msg  ${LINENO} "$PREFIX: about to send ssh assembly tool prefix $TOOLPREFIX"
    declare rtv
    function extract_bsubid_from_rtv ()
    {
      #extract id from Job <131068> is submitted to default queue <NBI-Test128>.
      #DANGER requires name NBI-Test128 stay at 11 characters!!!
      debug_msg  ${LINENO} "In extract_bsubid_from_rtv rtv is $rtv"
      rtv=${rtv:5:-47}
      debug_msg  ${LINENO} "In extract_bsubid_from_rtv  changed rtv to $rtv"
    }
    
    debug_msg  ${LINENO} "$TOOLPREFIX: start assembly over ssh link to $SSH_USERID@$SSH_ADDR"
    debug_msg  ${LINENO} "output directory $SSH_REPORTDIR"
    debug_msg  ${LINENO} "assembly parameters ${TOOL_PARAMTERS[$index]}"
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
    debug_msg  ${LINENO}  "$TOOLPREFIX:  ssh assembly return value $rtv"
    debug_msg  ${LINENO}  "num of tools is currently $end_tool"
    extract_bsubid_from_rtv
    debug_msg  ${LINENO}  "in send_ssh_tool just got bsubnumber from rtv it is $rtv"
    apple="${BSUBIDS[$index]} $rtv"
    BSUBIDS[$index]="${BSUBIDS[$index]} $rtv"
    debug_msg  ${LINENO}  "after being set bsubids is ${BSUBIDS[$index]}"
    debug_msg  ${LINENO} "$TOOLPREFIX in send_ssh_asembly : ssh bsub id is ${BSUBIDS[$index]} with index $index"
    debug_msg  ${LINENO} "end of send_ssh_tool end of send_ssh_tool"
  }
  
  function send_tool ()
  {
    prfix=$1
    index=$2
    debug_msg  ${LINENO} "send tools to finsih para1 $1 and para2 $2"
    echo "$prfix send_tools: In assembly loop i=$index tool is ${TOOL_NAME[$index]}"
    if [[ "${TOOL_LOCATION[$index]}" = local ]]; then
      send_local_tool "$prfix" $index
    else 
      if [[ "${TOOL_LOCATION[$index]}" = ssh ]]; then 
        send_ssh_tool "$prfix" $index
        debug_msg  ${LINENO} "$prfix in send_tools : ssh bsub id is ${BSUBIDS[$index]} with index $index"
      fi
    fi
    debug_msg  ${LINENO} "END of send_tool END of send_tool END of send_tool END of send_tool"
  }
  
  debug_msg  ${LINENO} "start of send tools"
  display_tool_array
  
  # $1 The number of tools to run in this pass
  # $2 The position of the send and wait tool
  debug_msg  ${LINENO} "send tools para1 $1 and para2 $2"
  declare -i end_tool="$2"
  declare -i start_tool=$(($end_tool - $1 ))
  debug_msg  ${LINENO} "send tools para1 $1 and para2 $2 end tool $end_tool start tool $start_tool"

  echo "for (( stool=$start_tool ; stool <= $end_tool ; ++stool )); do"
  for (( stool="$start_tool" ; stool <= "$end_tool" ; ++stool )); do
    PIDS[$stool]=
    BSUBIDS[$stool]=
    if [[ "${TOOL_TYPE[$stool]}" == "$METRIC" ]]; then
      for f in "$LOCAL_RESULTDIR"/*.fasta; do 
        assembly=$(basename "$f" .fasta)        
        debug_msg  ${LINENO} "$PREFIX: TOOL_NAME[$stool] metric for $f"
        debug_msg  ${LINENO} "before before send tool metric for assembley $f bsub is now ${BSUBIDS[$stool]}"
        send_tool "$PREFIX/$assembly" $stool
        debug_msg  ${LINENO} "after after send tool metric for assembley $f bsub is now ${BSUBIDS[$stool]}"
      done
    else
      if [[ "${TOOL_TYPE[$stool]}" == "$ASDEMBLER" ]]; then 
        send_tool "$PREFIX" $stool
      fi
    fi
    debug_msg  ${LINENO} "in send local tools for loop with index = $stool"
  done
  debug_msg  ${LINENO} "after send local tools"
  display_tool_array
  debug_msg  ${LINENO} "EEEEEEEEEEEEEEEEEEEENd OFFFFFFFFFFFFFFFFFFFFF send tools"
}