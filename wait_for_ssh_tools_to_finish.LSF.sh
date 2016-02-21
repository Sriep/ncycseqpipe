PROGNAME=$(basename $0)

function wait_for_ssh_tools_to_finish ()
{
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
}