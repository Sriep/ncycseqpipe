#!/bin/bash
#
declare -xr CONFIGFILE=$1
declare -xr HPC_CONFIGFILE=$2
# Set sorce directory to be the directory where this file is stored, the
# assumption is that the companion scripts are stored in the same directory  
# structure as found at https://github.com/Sriep/ncycseqpipe.git
declare -xr SOURCEDIR=`dirname "$BASH_SOURCE"`

echo all: "working directory is $PWD"
echo all: "source directory is $SOURCEDIR"
echo all: "read in config file from $CONFIGFILE"

source $CONFIGFILE
readonly ILLUMINA_READS
echo all: "Illumina reads from $ILLUMINA_READS"

if [[ $ILLUMINA_READS ]]; then
  while read col1 col2 col3; do
    echo -ne "all: About to assemble  name $col1 \tread1 $col2 \tread2 $col3"
    $SOURCEDIR/assemble_strain.sh $col1 $col2 $col3 &
  done < $ILLUMINA_READS
fi
echo all : "Sent of all strains to be assembled."
# /home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_all.sh ncycseqpipe.cfg
#
# /home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_all.sh     /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipe.cfg
#
# docker run \
#    --name ncycpipe_run \
#    -v /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input:input \
#    -v /home/shepperp/datashare/Piers/Trim:/reads:ro \
#    -v /home/shepperp/datashare/Piers/assemblies/test:/results \ 
#    -v /home/shepperp/documents/test/workdir:/workdir \
#    -v /nbi/group-data/ifs/NBI/Research-Groups/Jo-Dicks/Piers/assemblies/test:/sshworkdir \
#    -v /var/run/docker.sock:/var/run/docker.sock \
#    ncycpipe
