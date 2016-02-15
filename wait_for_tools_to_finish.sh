PROGNAME=$(basename $0)

function wait_for_tools_to_finish ()
{
  #if [[ "$BATCHOPT" = LSF ]]; then
  #  source $SOURCEDIR/wait_for_ssh_tools_to_finish.LSF.sh
  #else
  #debug_msg  ${LINENO} "about to source $SOURCEDIR/wait_for_ssh_tools_to_finish.SLURM.sh"
  source $SOURCEDIR/wait_for_ssh_tools_to_finish.SLURM.sh
  #fi
  
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
    debug_msg  ${LINENO} "$PREFIX: In assembly loop i=$i localtion ${TOOL_LOCATION[$i]}"
    if [[ "${TOOL_LOCATION[$i]}" = local ]]; then      
      wait
      debug_msg  ${LINENO} "finished waiting for all process to finish"
    else 
      debug_msg  ${LINENO} "wait for ssh tools sshjobs=$SSHJOBIDS localtion ${TOOL_LOCATION[$i]}"
      if [[ "${TOOL_LOCATION[$i]}" = ssh ]]; then 
        wait_for_ssh_tools_to_finish 
      fi
    fi
    debug_msg  ${LINENO} "finished waiting for tool number $i"
  done
  debug_msg  ${LINENO} "$PREFIX: Finished waiting!!!!!!!!!!!!!!!!!!!!"
}