PROGNAME=$(basename $0)

function wait_for_tools_to_finish ()
{
  # $1 The number of tools to run in this pass
  # $2 The position of the send and wait tool
  debug_msg  ${LINENO} "wait for tools to finsih para1 $1 and para2 $2"
  ps
  declare end_tool=$2
  declare start_tool=$(( $end_tool - $1 ))
  debug_msg  ${LINENO} "wait for tools to finsih para1 $1 and para2 $2"

  debug_msg  ${LINENO} "$PREFIX: ------------------------- Waiting ------------------------------"
  debug_msg  ${LINENO} "num assemblers $num_tools"
  debug_msg  ${LINENO} "for loop is for (( i=$start_tool ; i < $end_tool ; ++i )); do"
  for (( i="$start_tool" ; i < "$end_tool" ; ++i )); do
    debug_msg  ${LINENO} "$PREFIX: In assembly loop i=$i"
    if [[ "${TOOL_LOCATION[$i]}" = local ]]; then
      debug_msg  ${LINENO} "wait for pid ${PIDS[$i]}"
      #if [[ -n "${PIDS[$i]}" ]]; then wait "${PIDS[$i]}"; fi
      #debug_msg  ${LINENO}  "wait ${PIDS[$i]}"
      wait
      debug_msg  ${LINENO} "finished waiting for all process to finish"
    else 
      if [[ "${TOOL_LOCATION[$i]}" = ssh ]]; then 
        IFS=' ' read -ra bids <<< "${BSUBIDS[$i]}"
        debug_msg  ${LINENO} "for loop ssh for (( id=0 ; id < ${#bids[@]} ; ++id )); do"
        for (( id=0 ; id < ${#bids[@]} ; ++id )); do
          reportfile=$LOCAL_REPORTDIR/${bids[$id]}.out
          debug_msg  ${LINENO} "wait for bsub id ${bids[$id]}"
          debug_msg  ${LINENO} "look for file $reportfile"
          while  [[ ! -e $reportfile ]]; do 
            debug_msg  ${LINENO} "cant find $reportfile about to sleep for a while"
            sleep "$SLEEP_TIME" 
          done
          debug_msg  ${LINENO} "found $reportfile contnuing"
          cp "$reportfile" "$LOCAL_REPORTDIR/${PREFIX}_${TOOL_NAME[$i]}.out"
          debug_msg  ${LINENO} "about to copy $reportfile to ${LOGPREFIX}.ssh.${TOOL_NAME[$i]}.out"
          cp "$reportfile" "${LOGPREFIX}.ssh.${TOOL_NAME[$i]}.out"  
          debug_msg  ${LINENO} "temp done copy"
        done
      fi
    fi
    debug_msg  ${LINENO} "finished waiting for tool number $i"
  done
  debug_msg  ${LINENO} "$PREFIX: Finished waiting!!!!!!!!!!!!!!!!!!!!"
}