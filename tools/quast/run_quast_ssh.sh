#!/bin/bash
# 
source hpccore-5
source quast-3.1
QUASTDIR=/nbi/software/testing/quast/3.1/x86_64/bin
declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/ssh_header.sh
# PREFIX - Name of strain to assemble
# READS1 - First set of paired end reads, relative to $LOCAL_READSDIR
# READS2 - Second set of paired end reads, relative to $LOCAL_READSDIR
# TOOL_TAG - Tag to indicate the output from this tool
# PARAMETERS - Data used to paramatirse this tool
#
# WORKDIR - Directory in which to put tempory work files
# READSDIR - Directory where paired end reads are located
#-------------------------- Assembly specific code here --------------------
echo QUAST ssh: about to run ssh quast on $PREFIX

echo template is $TEMPLATE
echo "$QUASTDIR/quast.py  --eukaryote  --scaffolds  -o $WORKDIR  $f"
echo now send the quest command for real

$QUASTDIR/quast.py \
  --eukaryote \
  --scaffolds \
  -o $WORKDIR \
  $TEMPLATE

#Give location of result files
METRICS=$WORKDIR/transposed_report.tsv

#-------------------------- Assembly specific code here --------------------
source $SOURCEDIR/ssh_footer.sh