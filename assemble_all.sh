#!/bin/bash -eu
#
## @file assemble_all.sh
## @author Piers Shepperson
## @brief Bash Argsparse Library
## @version 0.0

declare -xr CONFIGFILE=$1
# Set sorce directory to be the directory where this file is stored, the
# assumption is that the companion scripts are stored in the same directory  
# structure as found at https://github.com/Sriep/ncycseqpipe.git
source $CONFIGFILE
declare -xr SOURCEDIR=$(dirname "$BASH_SOURCE")
source $SOURCEDIR/error.sh
debug_msg  ${LINENO} "source directory is $SOURCEDIR"
debug_msg  ${LINENO} "read in config file from $CONFIGFILE"
readonly READSFILE 
debug_msg  ${LINENO} "Illumina reads from $READSFILE"
if [[ -z $TOP_LOOP_SLEEP ]]; then 
  TOP_LOOP_SLEEP=1s
fi
debug_msg  ${LINENO} "top sleep time $TOP_LOOP_SLEEP"
## @fn save_pipe_config_information()
## @brief Set the minimum number of non-option parameters expected on
## the command line.
## @param unsigned_int a positive number.
## @retval 0 if there is an unsigned integer is provided and is the
## single parameter of this function.
## @retval 1 in other cases.
## @ingroup ArgsparseParameter
save_pipe_config_information () {
  CONFIGDIR="$LOCAL_DATA/$RESULTDIR/pipline_parameters"
  debug_msg  ${LINENO} "configdir is $CONFIGDIR"
  mkdir -p $CONFIGDIR
  num_runs=1
  if [[ -e "$CONFIGDIR/runs" ]]; then
    num_runs=$(<"$CONFIGDIR/runs")
    num_runs=$(($num_runs+1))
  fi
  echo "$num_runs" > "$CONFIGDIR/runs"
  cp "$CONFIGFILE" "$CONFIGDIR/$num_runs.CONFIGFILE"
  cp "$READSFILE" "$CONFIGDIR/$num_runs.READSFILE"
  cp "$RECIPEFILE" "$CONFIGDIR/$num_runs.RECIPEFILE"
}

function save_strain_pipe_config_information ()
{
  debug_msg  ${LINENO} "logdir is $logdir"
  mkdir -p $logdir
  num_runs=1
  if [[ -e "$logdir/runs" ]]; then
    num_runs=$(<"$logdir/runs")
    num_runs=$(($num_runs+1))
  fi
  echo "$num_runs" > "$logdir/runs"
  cp "$CONFIGFILE" "$logdir/$num_runs.CONFIGFILE"
  cp "$RECIPEFILE" "$logdir/$num_runs.RECIPEFILE"
}

function main ()
{
  save_pipe_config_information
  debug_msg  ${LINENO} "readsfile is $READSFILE"
  if [[ -n $READSFILE ]]; then
    sleep_time=0
    while read -r col1 col2 col3 col4; do
      debug_msg  ${LINENO} "all: About to assemble  name $col1 \tread1 $col2 \tread2 $col3 \treadpb $col3"
      debug_msg  ${LINENO} "all: about to run $SOURCEDIR/assemble_strain.sh $col1 $col2 $col3 $col4 &"
      logdir="$LOCAL_DATA/$RESULTDIR/$col1/logdir"
      save_strain_pipe_config_information $col1 
      debug_msg  ${LINENO} "log dirctory for strian $col1 is $logdir/$num_runs"
      "$SOURCEDIR/assemble_strain.sh" $col1 $col2 $col3 $col4 "$RESULTDIR/$col1/logdir/$num_runs" $sleep_time \
        > "$logdir/$num_runs.assemble_strain.stdout.log" \
        2> "$logdir/$num_runs.assemble_strain.stderr.log" &       
      sleep_time=$(($sleep_time+$TOP_LOOP_SLEEP))
      debug_msg  ${LINENO} "sleep time now $sleep_time"
    done < "$READSFILE"
  fi
  debug_msg  ${LINENO} "Sent of all strains to be assembled."
  debug_msg  ${LINENO} "FINISHED assemble_all.sh."
}

main "$@"

# sudo bash -c "/home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_all.sh /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipe93.cfg > /home/shepperp/93.log 2> /home/shepperp/93err.log &"
#
# # sudo bash -c "/home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_all.sh /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipe2629.cfg > /home/shepperp/2629.log 2> /home/shepperp/2629err.log &"
#
# sudo bash -c "/home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_all.sh /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipe93group.cfg > /home/shepperp/93g.log 2> /home/shepperp/93gerr.log &"
#
# sudo bash -c "/home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_all.sh /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipeTB.cfg > /home/shepperp/tbg.log 2> /home/shepperp/tbgerr.log &"

