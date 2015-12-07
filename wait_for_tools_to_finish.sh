function wait_for_tools_to_finish ()
{
  # $1 The number of tools to run in this pass
  # $2 The position of the send and wait tool
  echo wait for tools to finsih para1 $1 and para2 $2
  declare end_tool=$2
  declare start_tool=$(( $end_tool - $1 ))
  echo wait for tools to finsih para1 $1 and para2 $2

  echo "$PREFIX: ------------------------- Waiting ------------------------------"
  echo "num assemblers $num_tools"
  echo for loop is "for (( i=$start_tool ; i < $end_tool ; ++i )); do"
  for (( i="$start_tool" ; i < "$end_tool" ; ++i )); do
    echo "$PREFIX: In assembly loop i=$i"
    if [[ "${TOOL_LOCATION[$i]}" = local ]]; then
      echo "wait for pid ${PIDS[$i]}"
      if [[ -n "${PIDS[$i]}" ]]; then wait "${PIDS[$i]}"; fi
    else 
      if [[ "${TOOL_LOCATION[$i]}" = ssh ]]; then 
        IFS=' ' read -ra bids <<< "${BSUBIDS[$i]}"
        echo "for loop ssh for (( id=0 ; id < ${#bids[@]} ; ++id )); do"
        for (( id=0 ; id < ${#bids[@]} ; ++id )); do
          reportfile=$LOCAL_REPORTDIR/${bids[$id]}.out
          echo "wait for bsub id ${bids[$id]}"
          echo "look for file $reportfile"
          while  [[ ! -e $reportfile ]]; do 
            echo "cant find $reportfile about to sleep for a while"
            sleep "$SLEEP_TIME" 
          done
          cp $reportfile $LOCAL_REPORTDIR/${PREFIX}_${TOOL_NAME[$i]}.out
          echo "found $reportfile contnuing"
        done
      fi
    fi
    echo "finished waiting for tool number $i"
  done
  echo "$PREFIX: Finished waiting!!!!!!!!!!!!!!!!!!!!"
}