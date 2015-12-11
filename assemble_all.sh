#!/bin/bash -eu
#

declare -xr CONFIGFILE=$1
# Set sorce directory to be the directory where this file is stored, the
# assumption is that the companion scripts are stored in the same directory  
# structure as found at https://github.com/Sriep/ncycseqpipe.git
source $CONFIGFILE
declare -xr SOURCEDIR=$(dirname "$BASH_SOURCE")
source $SOURCEDIR/error.sh
debug_msg  ${LINENO} "working directory is $PWD"
debug_msg  ${LINENO} "source directory is $SOURCEDIR"
debug_msg  ${LINENO} "read in config file from $CONFIGFILE"
readonly ILLUMINA_READS
readonly ASSEMBLERS_FILE
debug_msg  ${LINENO} "Illumina reads from $ILLUMINA_READS"

function main ()
{
  if [[ $ILLUMINA_READS ]]; then
    while read -r col1 col2 col3; do
      echo -e "all: About to assemble  name $col1 \tread1 $col2 \tread2 $col3"
      echo "all: about to run $SOURCEDIR/assemble_strain.sh $col1 $col2 $col3 &"
      "$SOURCEDIR/assemble_strain.sh" $col1 $col2 $col3 &
    done < "$ILLUMINA_READS"
  fi
  debug_msg  ${LINENO} "Sent of all strains to be assembled."
}

main "$@"

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
