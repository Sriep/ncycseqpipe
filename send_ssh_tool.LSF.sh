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
  debug_msg  ${LINENO} "output directory $SSH_REPORTDIR filename ${TOOL_NAME[$index]}/run_${TOOL_NAME[$index]}_ssh.sh"
  debug_msg  ${LINENO} "assembly parameters ${TOOL_PARAMTERS[$index]}"
  rtv=$(  ssh -oStrictHostKeyChecking=no  -tt -i  \
              "$SSH_KEYFILE" "$SSH_USERID@$SSH_ADDR" \
          bsub \
          -o "$SSH_REPORTDIR" \
             "$SSH_SOURCEDIR/tools/${TOOL_NAME[$index]}/run_${TOOL_NAME[$index]}_ssh.sh \
              $SSH_CONFIGFILE \
              $TOOLPREFIX \
              $READS1 \
              $READS2 \
              $READSPB \
              ${TOOL_TYPE[$index]} \
              ${TOOL_TAG[$index]} \
              ${TOOL_NAME[$index]} \
              ${LOGPREFIX} \
              ${TOOL_PARAMTERS[$index]}" \
       )
  debug_msg  ${LINENO}  "$TOOLPREFIX:  ssh assembly return value $rtv"
  extract_bsubid_from_rtv
  BSUBIDS[$index]="${BSUBIDS[$index]} $rtv"
  debug_msg  ${LINENO}  "after being set bsubids is ${BSUBIDS[$index]}"
  debug_msg  ${LINENO} "end of send_ssh_tool end of send_ssh_tool"
}
  