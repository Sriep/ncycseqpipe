#!/bin/bash
#
echo all: read in config file from $CONFIGFILE
declare -xr SOURCEDIR=/home/shepperp/datashare/Piers/github/ncycseqpipe
declare -r INPUTDIR=/home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input
declare -xr CONFIGFILE=$INPUTDIR/ncycseqpipe.cfg

source $CONFIGFILE
readonly ILLUMINA_READS

declare -a prefix
declare -a illumina_read1
declare -a illumina_read2
declare -i num_strains=0

if [[ $INPUTDIR/$ILLUMINA_READS ]]; then
  while read col1 col2 col3; do
    num_strains=$((num_strains+1))
    prefix[$num_strains]="$col1"
    illumina_read1[$num_strains]="$col2"
    illumina_read2[$num_strains]="$col3"
    echo all: read in $num_strains th line
  done < $ILLUMINA_READS
fi

for ((i=1; i<=$num_strains; i++)); do
  echo -n "all: About to assemble "
  echo -ne "name ${prefix[$i]}"
  echo -ne "\tread1 ${illumina_read1[$i]}"
  echo  -e "\tread2 ${illumina_read2[$i]}"
  $SOURCEDIR/assemble_strain.sh \
    ${prefix[$i]} \
    ${illumina_read1[$i]} \
    ${illumina_read2[$i]} &
done
echo all : Sent of all strains to be assembled.  
# /home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_all.sh