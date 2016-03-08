PROGNAME=$(basename $0)

function send_tools ()
{
  # $1 The number of tools to run in this pass
  mkdir -p "$LOCAL_DATA/$RESULTDIR/$PREFIX/ssh_out" 
  function send_local_tool ()
  {
      declare -r TOOLPREFIX=$1
      declare -ri index=$2
      outlog="${LOCAL_LOGPREFIX}.run_${TOOL_NAME[$index]}_local.sh.log"
      errlog="${LOCAL_LOGPREFIX}.run_${TOOL_NAME[$index]}_local.sh.err.log"
      script_sh=$SOURCEDIR/tools/${TOOL_NAME[$index]}/run_${TOOL_NAME[$index]}_local.sh
      debug_msg  ${LINENO}  "script is $script_sh"
      debug_msg  ${LINENO}  "In send_local_assembly function tool name ${TOOL_NAME[$index]} file ${TOOL_NAME[$index]}/run_${TOOL_NAME[$index]}_local.sh"     
      if [[ "$PARALLEL" == "&" ]]; then
        # /usr/bin/time -o output.time.txt -p date 
        # /usr/bin/time -v 2> stats_$PREFIX_${TOOL_NAME[$index]}.log
        # ( time ./sleep.sh )  2> timeout1.txt
        #( time 
        #sudo bash -c "/home/shepperp/datashare/Piers/github/ncycseqpipe/utNCYC22.sh &"
        $script_sh \
          "$SOURCEDIR" \
          "$CONFIGFILE" \
          "$TOOLPREFIX" \
          "$READS1" \
          "$READS2" \
          "$READSPB" \
          "${TOOL_TYPE[$index]}" \
          "${TOOL_TAG[$index]}" \
          "${TOOL_NAME[$index]}" \
          "${LOCAL_LOGPREFIX}stats/" \
          "${TOOL_PARAMTERS[$index]}" \
          > "$outlog" 2> "$errlog" &
          #> "${LOGPREFIX}.run_${TOOL_NAME[$index]}_local.sh.stdout.log" \
          #2> "${LOGPREFIX}.run_${TOOL_NAME[$index]}_local.sh.stderr.log" &
          #) 2> $LOCAL_WORKDIR/$PREFIX/${TOOL_TAG[$index]}_$PREFIX.log &
          #process_num=$! 
          #set +u; process_num=$!; set -u
      else
        #( time 
        $script_sh \
          "$SOURCEDIR" \
          "$CONFIGFILE" \
          "$TOOLPREFIX" \
          "$READS1" \
          "$READS2" \
          "$READSPB" \
          "${TOOL_TYPE[$index]}" \
          "${TOOL_TAG[$index]}" \
          "${TOOL_NAME[$index]}" \
          "${LOCAL_LOGPREFIX}stats/" \
          "${TOOL_PARAMTERS[$index]}" \
          > $outlog 2> $errlog  
          #> "${LOGPREFIX}.run_${TOOL_NAME[$index]}_local.sh.stdout.log" \
          #2> "${LOGPREFIX}.run_${TOOL_NAME[$index]}_local.sh.stderr.log"
      fi
      debug_msg  ${LINENO} "end of send_local_tool endo fo send_local_tool"
  }
  
  #if [[ "$BATCHOPT" = LSF ]]; then
  #  source $SOURCEDIR/send_ssh_tool.LSF.sh
  #else
    source $SOURCEDIR/send_ssh_tool.SLURM.sh
  #fi
    
  function send_tool ()
  {
    prfix=$1
    index=$2
    debug_msg  ${LINENO} "tool location is ${TOOL_LOCATION[$index]}"
    if [[ "${TOOL_LOCATION[$index]}" = local ]]; then
      send_local_tool "$prfix" $index
    else 
      if [[ "${TOOL_LOCATION[$index]}" = ssh ]]; then 
        send_ssh_tool "$prfix" $index
      fi
    fi
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
        send_tool "$PREFIX/$assembly" $stool
      done
    else
      assembly=
      if [[ "${TOOL_TYPE[$stool]}" == "$ASDEMBLER" ]]; then 
        send_tool "$PREFIX" $stool
      fi
    fi
  done
  debug_msg  ${LINENO} "after send local tools"
  display_tool_array
  debug_msg  ${LINENO} "EEEEEEEEEEEEEEEEEEEENd OFFFFFFFFFFFFFFFFFFFFF send tools"
}