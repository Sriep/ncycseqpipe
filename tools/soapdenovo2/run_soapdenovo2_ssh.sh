#!/bin/bash
# 
source hpccore-5
source SOAPdenovo2-r240
declare -r SOURCEDIR="$1"
source $SOURCEDIR/tools/ssh_header.sh
# PREFIX - Name of strain to assemble
# READS1 - First set of paired end reads, relative to $LOCAL_READSDIR
# READS2 - Second set of paired end reads, relative to $LOCAL_READSDIR
# TOOL_TAG - Tag to indicate the output from this tool
# PARAMETERS - Data used to paramatirse this tool
#
# WORKDIR - Directory in which to put tempory work files
# READSDIR - Directory where paired end reads are located
#-------------------------- Assembly specific code here --------------------
debug_msg  ${LINENO} "SOAPdenvo2 ssh: about to run ssh soapdenovo2 on $PREFIX"

#rm $WORKDIR/config_file
#touch $WORKDIR/config_file

> $WORKDIR/config_file
cat $SOURCEDIR/tools/soapdenovo2/soap_config_head.txt >> $WORKDIR/config_file
cat $SOURCEDIR/tools/soapdenovo2/soap_config_lib_head.txt >> $WORKDIR/config_file
echo q1=$SSH_READSDIR/$READS1 >> $WORKDIR/config_file
echo q2=$SSH_READSDIR/$READS2 >> $WORKDIR/config_file

debug_msg  ${LINENO} "$PREFIX SOAP2: soapdenovo2 config file follows"
cat $WORKDIR/config_file
debug_msg  ${LINENO} "$PREFIX SOAP2: Finished soapdenovo2 config file" 
debug_msg  ${LINENO} "workdir $WORKDIR"
debug_msg  ${LINENO} "$PREFIX SOAP2: RUN RUN RUN"

SOAPdenovo-127mer \
		  all \
		  -s $WORKDIR/config_file \
		  -K 63 \
		  -p 15 \
		  -R \
		  -o $WORKDIR/$PREFIX 

#Give location of result files
CONTIGS=$WORKDIR/$PREFIX.contig
SCAFFOLDS=$WORKDIR/$PREFIX.scafSeq
#-------------------------- Assembly specific code here --------------------
source $SOURCEDIR/tools/ssh_footer.sh
