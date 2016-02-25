#!/bin/bash -eu
# assemble_strain_sh
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
declare -xr PREFIX=$1
declare -xr READS1=$2
declare -xr READS2=$3
declare -xr READSPB=$4
declare -xr LOGPATH=$5
declare -xr SLEEPTIME=$6


#global varables
source $CONFIGFILE
source $SOURCEDIR/error.sh
#BATCHOPT=LSF #templine
declare -ax BSUBIDS
declare -ax PIDS
declare -xr SSH_SOURCEDIR=${HPC_DATA}${SOURCEDIR#$LOCAL_DATA}
declare -xr SSH_CONFIGFILE=${HPC_DATA}${CONFIGFILE#*$LOCAL_DATA}
declare -xr SSH_REPORTDIR=$HPC_DATA/$RESULTDIR/$PREFIX/ssh_out
declare -xr LOCAL_REPORTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX/ssh_out
declare -r LOCAL_RESULTDIR=$LOCAL_DATA/$RESULTDIR/$PREFIX

declare -xr LOCAL_LOGPREFIX="$LOCAL_DATA/$LOGPATH"
declare -xr SSH_LOGPREFIX="$HPC_DATA/$LOGPATH"
debug_msg  ${LINENO} " SSH_SOURCEDIR is $SSH_SOURCEDIR"
debug_msg  ${LINENO} " SSH_CONFIGFILE is $SSH_CONFIGFILE"
debug_msg  ${LINENO} " LOCAL_LOGPREFIX is $LOCAL_LOGPREFIX"
debug_msg  ${LINENO} " SSH_LOGPREFIX is $SSH_LOGPREFIX"
mkdir -p "${LOCAL_LOGPREFIX}stats/"

declare -ax TOOL_TYPE
declare -ax TOOL_NAME
declare -ax TOOL_LOCATION
declare -ax TOOL_TAG
declare -ax TOOL_PARAMTERS
declare -xi num_tools=0

debug_msg  ${LINENO} "$PREFIX sleeptime $SLEEPTIME"
sleep ${SLEEPTIME}s
debug_msg  ${LINENO} "$PREFIX finished sleeping"

function compile_stats ()
{
  debug_msg  ${LINENO} "function compile_stats"
  stats_file=${LOCAL_LOGPREFIX}stats/allstats.csv
  > $stats_file
  debug_msg  ${LINENO} "fstats file=$stats_file"
  for f in ${LOCAL_LOGPREFIX}stats/*sh.log; do
    echo -n $(basename $f)"," >> "$stats_file"
    cat $f >> "${LOCAL_LOGPREFIX}stats/stats_file"
  done  
  cat "${LOCAL_LOGPREFIX}stats/slurm_script.log" >> "$stats_file"
}

function display_tool_array ()
{
  debug_msg  ${LINENO} "display_tool_array"
  set +u
  for (( i=0 ; i <= "$num_tools" ; ++i )); do       
    echo -e "index $i \ttype  ${TOOL_TYPE[$i]} \tname ${TOOL_NAME[$i]} \tlocation ${TOOL_LOCATION[$i]} \ttag ${TOOL_TAG[$i]} \tparameters ${TOOL_PARAMTERS[$i]}"
  done
  set -u
  debug_msg  ${LINENO} "finish display_tool_array"
}

source  $SOURCEDIR/send_tools.sh
source  $SOURCEDIR/wait_for_tools_to_finish.sh

function save_pipe_config_information ()
{
  CONFIGDIR="$LOCAL_DATA/$RESULTDIR/$PREFIX/pipline_parameters"
  debug_msg  ${LINENO} "configdir is $CONFIGDIR"
  mkdir -p $CONFIGDIR
  num_runs=1
  if [[ -e "$CONFIGDIR/runs" ]]; then
    num_runs=$(<"$CONFIGDIR/runs")
    num_runs=$(($num_runs+1))
  fi
  echo "$num_runs" > "$CONFIGDIR/runs"
  cp "$CONFIGFILE" "$CONFIGDIR/CONFIGFILE.$num_runs"
  cp "$RECIPEFILE" "$CONFIGDIR/RECIPEFILE.$num_runs"
}

function parse_recipe_file ()
{
  function compile_strians_metrics
  {
    for (( recipie_line=1; recipie_line<="$num_tools"; ++recipie_line )); do
      if [[  "${TOOL_TYPE[$recipie_line]}" == "$METRIC" ]]; then
        if [[ ${TOOL_TAG[$recipie_line]: -4}  == .csv ]]; then
          filename=$LOCAL_DATA/$RESULTDIR/$PREFIX/metric_${PREFIX}_${TOOL_TAG[$recipie_line]}
          debug_msg  ${LINENO} "filename is $filename"
          tempfile=$(mktemp)
          for f in $LOCAL_DATA/$RESULTDIR/$PREFIX/*/m_*_"${TOOL_TAG[recipie_line]}"; do
            #debug_msg  ${LINENO} "loop file: $f"
            echo "$f" >> $tempfile
            cat "$f" >> $tempfile
          done
          rm $filename || true
          debug_msg  ${LINENO} "about to move $tempfile to $filename"
          mv $tempfile $filename
        fi
      fi
    done
    debug_msg  ${LINENO} "finished compile_strians_metrics"
  }
  
  function read_recipe_file ()
  {
    declare -i num_tools_this_pass=0
    while read -r col1 col2 col3 col4 col5; do 
      debug_msg  ${LINENO} "parse_recipe_file data: type $col1 $col2 \tlocation $col3 \ttag $col4 \tparamter $col5 "
      #debug_msg  ${LINENO} "parse_recipe_file num of assemblers $num_tools"
      case "$col1" in
        "$SEND_AND_WAIT" )
          debug_msg  ${LINENO} "parse_recipe_file: case send_and_wait"
          num_tools=$(($num_tools + 1 ))
          TOOL_TYPE[num_tools]="$SEND_AND_WAIT"
          TOOL_PARAMTERS[num_tools]=$num_tools_this_pass
          num_tools_this_pass=0
          ;;
        \#* | "" )
          debug_msg  ${LINENO} "parse_recipe_file case commeted out line"
          ;;
        $ASDEMBLER | $METRIC )
          debug_msg  ${LINENO} "parse_recipe_file case assembler tool $col1 added to list"
          num_tools=$(($num_tools + 1 ))
          num_tools_this_pass=$(($num_tools_this_pass + 1 ))
          TOOL_TYPE[num_tools]=$col1
          TOOL_NAME[num_tools]=$col2
          TOOL_LOCATION[num_tools]=$col3
          TOOL_TAG[num_tools]=$col4
          TOOL_PARAMTERS[num_tools]=$col5        
          ;;
        *)
          debug_msg  ${LINENO} "parse_recipe_file unrecognised entry ignore line" 
          ;;
      esac
      #debug_msg  ${LINENO} "parse_recipe_file done onto next line"
    done < "$RECIPEFILE"
    debug_msg  ${LINENO} "parse_recipe_file finshed file"
  }
  
  function run_recipie_file ()
  {
    local recipie_line
    debug_msg  ${LINENO} "start of run_recipie_file"
    debug_msg  ${LINENO} "for loop in run recipie file is  for (( recipie_line=1; recipie_line<="$num_tools"; ++recipie_line )); do"
    for (( recipie_line=1; recipie_line<="$num_tools"; ++recipie_line )); do
      if [[  "${TOOL_TYPE[$recipie_line]}" = $SEND_AND_WAIT ]]; then
        debug_msg  ${LINENO} "about to call send_tools, paramters ${TOOL_PARAMTERS[$recipie_line]} index $recipie_line"
        SSHJOBIDS=""
        send_tools ${TOOL_PARAMTERS[$recipie_line]} $recipie_line
        debug_msg  ${LINENO} "about to call wait_for_tools_to_finish, paramters ${TOOL_PARAMTERS[$recipie_line]} index $recipie_line"
        wait_for_tools_to_finish ${TOOL_PARAMTERS[$recipie_line]} $recipie_line
      fi
      debug_msg  ${LINENO} "run_recipie_file for loop index $recipie_line num tools $num_tools"
      sleep 10s
    done
    debug_msg  ${LINENO} "finshied run_recipie_file"
  }
  
  read_recipe_file
  debug_msg  ${LINENO} "just left read_recipe_file abotu to call display_tool_array"
  display_tool_array
  debug_msg  ${LINENO} "just left display_tool_array about to call run_recipie_file"
  run_recipie_file
  compile_strians_metrics
  debug_msg  ${LINENO} "just left parse_recipe_file"
}

function main ()
{
  #save_strain_pipe_config_information 
  debug_msg  ${LINENO} "In assemble_strain_sh main"
  if [[ -n "$RECIPEFILE" ]]; then
    parse_recipe_file
  fi
  debug_msg  ${LINENO} "Finished assemble_strain_sh main for strain $PREFIX"
  compile_stats
  
  > $LOCAL_RESULTDIR/run_ncycpipestats.sh
  echo "/home/shepperp/software/ncycseqpipe/Cpp/ncycpipestats/ncycpipestats $LOCAL_RESULTDIR" >> "$LOCAL_RESULTDIR/run_ncycpipestats.sh"
}

main "$@"

#docker rm $(docker ps -a -q)
# /home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_strain.sh NCYC22 NCYC22/NCYC22.FP.fastq NCYC22/NCYC22.RP.fastq
#PREFIX=NCYC22
#READS1=NCYC22/NCYC22.FP.fastq
#READS2=N
#hi there
