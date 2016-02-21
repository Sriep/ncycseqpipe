PROGNAME=$(basename $0)
debug_msg  ${LINENO} "In wait_for_ssh_tools_to_finish.SLURM.sh"

function wait_for_ssh_tools_to_finish ()
{
  debug_msg  ${LINENO} "starting wait_for_ssh_tools_to_finish"
  debug_msg  ${LINENO} "SSHJOBIDS=$SSHJOBIDS" 
  #Sleep for a few mins to give time for hpc to react
  sleep 4m
  statuses=$( ssh -i /home/shepperp/.ssh/id_rsa shepperp@SLURM.nbi.ac.uk   "sacct --parsable --format=State --jobs=$SSHJOBIDS"   )       
  debug_msg  ${LINENO} "statuses=$statuses"
  while [[ $statuses == *CONFIGURING* \
        || $statuses == *COMPLETING* \
        || $statuses == *PENDING* \
        || $statuses == *RESIZING* \
        || $statuses == *RUNNING* ]]; do
    debug_msg  ${LINENO} "waiting for sbathes to finish sleep=$SLEEP_TIME"
    sleep "$SLEEP_TIME" 
    statuses=$( ssh -i /home/shepperp/.ssh/id_rsa shepperp@SLURM.nbi.ac.uk   "sacct --parsable --format=State --jobs=$SSHJOBIDS"   )
    debug_msg  ${LINENO} "statuses are $statuses"
  done
  debug_msg  ${LINENO} "all jobs finished, contnuing"
  SSHJOBIDS=
} 

# CONFIGURING
# COMPLETING
# PENDING  RUNNING  RESIZING