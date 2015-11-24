
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
      echo num of tools is currently $end_tool
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
    echo "assembly parameters ${TOOL_PARAMTERS[$index]}"
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
    echo num of tools is currently $end_tool
    extract_bsubid_from_rtv
    echo in send_ssh_tool just got bsubnumber from rtv it is "$rtv"
    BSUBIDS[$index]="${BSUBIDS[$index]} $rtv"
    echo "$TOOLPREFIX in send_ssh_asembly : ssh bsub id is ${BSUBIDS[$index]} with index $index"
    echo end of send_ssh_tool end of send_ssh_tool
  }
  
  function send_tool ()
  {
    prfix=$1
    index=$2
    echo send tools to finsih para1 $1 and para2 $2
    echo "$prfix send_tools: In assembly loop i=$index tool is ${TOOL_NAME[$index]}"
    if [[ "${TOOL_LOCATION[$index]}" = local ]]; then
      send_local_tool "$prfix" $index
    else 
      if [[ "${TOOL_LOCATION[$index]}" = ssh ]]; then 
        send_ssh_tool "$prfix" $index
        echo "$prfix in send_tools : ssh bsub id is ${BSUBIDS[$index]} with index $index"
      fi
    fi
    echo "END of send_tool END of send_tool END of send_tool END of send_tool"
  }
  
  echo start of send tools
  display_tool_array
  
  # $1 The number of tools to run in this pass
  # $2 The position of the send and wait tool
  echo send tools para1 $1 and para2 $2
  declare -i end_tool="$2"
  declare -i start_tool=$(($end_tool - $1 ))
  echo send tools para1 $1 and para2 $2 "end tool $end_tool start tool $start_tool"

  echo "for (( i=$start_tool ; i <= $end_tool ; ++i )); do"
  for (( i="$start_tool" ; i <= "$end_tool" ; ++i )); do
    if [[ "$TOOL_TYPE[$i]" == "$METRIC" ]]; then
      for f in "$LOCAL_RESULTDIR"/*.fasta; do 
        assembly=$(basename "$f" .fasta)
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