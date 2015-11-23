#!/bin/bash
# 

source hpccore-5
source SOAPdenovo2-r240
declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/ssh_header.sh

#-------------------------- Assembly specific code here --------------------
echo SOAPdenvo2 ssh: about to run ssh soapdenovo2 on $PREFIX

rm $WORKDIR/config_file
touch $WORKDIR/config_file
cat $SOURCEDIR/soapdenovo2/soap_config_head.txt >> $WORKDIR/config_file
cat $SOURCEDIR/soapdenovo2/soap_config_lib_head.txt >> $WORKDIR/config_file
echo q1=$SSH_READSDIR/$READS1 >> $WORKDIR/config_file
echo q2=$SSH_READSDIR/$READS2 >> $WORKDIR/config_file

echo $PREFIX SOAP2: soapdenovo2 config file follows
cat $WORKDIR/config_file
echo $PREFIX SOAP2: Finished soapdenovo2 config file 

echo $PREFIX SOAP2: RUN RUN RUN

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

source $SOURCEDIR/ssh_footer.sh
