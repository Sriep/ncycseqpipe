PROGNAME=$(basename $0)
function send_ssh_tool ()
{
  declare -r TOOLPREFIX=$1
  declare -ri index=$2
  debug_msg  ${LINENO} "$PREFIX: about to send ssh assembly tool prefix $TOOLPREFIX"
  declare rtv
  function extract_jobid_from_rtv ()
  {
    #extract id from "Submitted batch job 394721<nl>"
    #DANGER requires output message to stay the same
    rtv=${rtv:20:-1}
    debug_msg  ${LINENO}  "removed nls changed rtv to <${rtv}>"
  }
  
  outlog="${SSH_LOGPREFIX}.${assembly}_run_${TOOL_NAME[$index]}_ssh.sh.log"
  errlog="${SSH_LOGPREFIX}.${assembly}_run_${TOOL_NAME[$index]}_ssh.sh.err.log"
  #script_sh=$SOURCEDIR/tools/${TOOL_NAME[$index]}/run_${TOOL_NAME[$index]}_ssh.sh 
  script_sh=$SSH_SOURCEDIR/tools/${TOOL_NAME[$index]}/run_${TOOL_NAME[$index]}_ssh.sh  
  debug_msg  ${LINENO} "about send to SLURM $script_sh"
  debug_msg  ${LINENO} "ssh -oStrictHostKeyChecking=no  -tt -i  $SSH_KEYFILE $SSH_USERID@$SSH_ADDR   sbatch   --nodes=1     --ntasks=1   --error=$errlog --output=$outlog $script_sh $SSH_SOURCEDIR $SSH_CONFIGFILE  $TOOLPREFIX $READS1   $READS2 $READSPB  ${TOOL_TYPE[$index]}   ${TOOL_TAG[$index]}    ${TOOL_NAME[$index]}   ${SSH_LOGPREFIX}stats/    ${TOOL_PARAMTERS[$index]}"
  
  rtv=$( ssh -oStrictHostKeyChecking=no  -tt -i  $SSH_KEYFILE $SSH_USERID@$SSH_ADDR   sbatch   --nodes=1  --ntasks=1 --mem=10000  --error=$errlog --output=$outlog $script_sh $SSH_SOURCEDIR $SSH_CONFIGFILE  $TOOLPREFIX $READS1   $READS2 $READSPB  ${TOOL_TYPE[$index]}   ${TOOL_TAG[$index]}    ${TOOL_NAME[$index]}   ${SSH_LOGPREFIX}stats/    ${TOOL_PARAMTERS[$index]} )
  
    #rtv=$( ssh -oStrictHostKeyChecking=no  \
  #        -tt -i  $SSH_KEYFILE $SSH_USERID@$SSH_ADDR  \
  #        sbatch  \            
  #          --nodes=1   \
  #          --ntasks=1  \
  #          --error=$errlog \
  #          --output=$outlog \
  #          $script_sh \
  #          $SSH_SOURCEDIR \
  #          $SSH_CONFIGFILE  \
  #          $TOOLPREFIX $READS1   \
  #          $READS2 $READSPB  \
  #          ${TOOL_TYPE[$index]}   \
  #          ${TOOL_TAG[$index]}    \
  #          ${TOOL_NAME[$index]}   \
  #          ${SSH_LOGPREFIX}stats/    \
  #          ${TOOL_PARAMTERS[$index]} \
  #      )
 #             #--partition=nbi-medium
              #--mem=10000 
              #per-task=10              
  debug_msg  ${LINENO}  "$TOOLPREFIX:  ssh assembly return value $rtv"
  extract_jobid_from_rtv
  SSHJOBIDS="${SSHJOBIDS},$rtv"
  debug_msg  ${LINENO}  "after being set job list is $SSHJOBIDS sleep for $SSH_SLEEPTIME"  
  if [[ -n "$SSH_SLEEPTIME" ]]; then sleep $SSH_SLEEPTIME; fi   
}

