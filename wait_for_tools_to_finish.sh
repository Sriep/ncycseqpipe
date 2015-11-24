function wait_for_tools_to_finish ()
{
  # $1 The number of tools to run in this pass
  # $2 The position of the send and wait tool
  echo wait for tools to finsih para1 $1 and para2 $2
  declare end_tool=$2
  declare start_tool=$(( $end_tool - $1 ))
  echo wait for tools to finsih para1 $1 and para2 $2

  
  echo "$PREFIX: in wait_for_assemblies_to_finish  ssh bsub id is ${BSUBIDS[1]} with index 1"
  echo "$PREFIX: ------------------------- Waiting ------------------------------"
  echo "num assemblers $num_tools"
  echo for loop is "for (( i=$start_tool ; i < $end_tool ; ++i )); do"
  for (( i="$start_tool" ; i < "$end_tool" ; ++i )); do
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