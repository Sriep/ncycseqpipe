#!/bin/bash 
## Run this on pipeline directory if pipeline failed to finish correctly.
## Para1: The pipeline directory.
## Para2: NCYC number.
directory=$1
prefix=$2

function compile_stats ()
{
  echo "function compile_stats"
  local stats_file="${directory}"/logdir/1stats/allstats.csv
  > $stats_file
  echo "fstats file=$stats_file"
  for f in "${directory}"/logdir/1stats/*.log; do
    echo -n $(basename $f)"," >> "$stats_file"
    cat $f >> "$stats_file"
  done  
}

function compile_strians_metrics ()
{
  local metricTag=$1
  filename=$directory/metric_${prefix}_${metricTag}
  echo "filename is $filename"
  tempfile=$(mktemp)
  echo "temp file $tempfile directory is $directory tag is $metricTag"
  for f in "$directory"/*/m_*_"${metricTag}"; do
    echo "loop file: $f"
    echo "$f" >> $tempfile
    cat "$f" >> $tempfile
  done
  rm $filename || true
  echo "about to move $tempfile to $filename"
  mv $tempfile $filename
  echo "finished compile_strians_metrics"
}

compile_stats
compile_strians_metrics "ale.csv"
#compile_strians_metrics "cgal.csv"
compile_strians_metrics "quast.csv"
> $directory/run_ncycpipestats.sh
echo "#!/bin/bash" >> "${directory}/run_ncycpipestats.sh"
echo "/home/shepperp/software/ncycseqpipe/Cpp/ncycpipestats/ncycpipestats -s ${directory}" >> "${directory}/run_ncycpipestats.sh"

# /home/shepperp/datashare/Piers/github/ncycseqpipe/finishStrain.sh /home/shepperp/datashare/Piers/assemblies/NCYC523/NCYC523 NCYC523
# /home/shepperp/datashare/Piers/github/ncycseqpipe/finishStrain.sh /home/shepperp/datashare/Piers/assemblies/NCYC3612/NCYC3612 NCYC3612
# /home/shepperp/datashare/Piers/github/ncycseqpipe/finishStrain.sh /home/shepperp/datashare/Piers/assemblies/NCYC3630/NCYC3630 NCYC3630
# /home/shepperp/datashare/Piers/github/ncycseqpipe/finishStrain.sh /home/shepperp/datashare/Piers/assemblies/NCYC3662/NCYC3662 NCYC3662
