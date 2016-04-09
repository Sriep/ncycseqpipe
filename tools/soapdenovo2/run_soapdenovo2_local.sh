#!/bin/bash
declare -r SOURCEDIR="$1"
source $SOURCEDIR/tools/local_header.sh

#-------------------------- Assembly specific code here --------------------


debug_msg  ${LINENO} "SOAP2: about to run soap on strain $PREFIX"

> $WORKDIR/config_file
cat $SOURCEDIR/tools/soapdenovo2/soap_config_head.txt >> $WORKDIR/config_file
cat $SOURCEDIR/tools/soapdenovo2/soap_config_lib_head.txt >> $WORKDIR/config_file
echo q1=/reads/$READS1 >> $WORKDIR/config_file
echo q2=/reads/$READS2 >> $WORKDIR/config_file

debug_msg  ${LINENO} "SOAPdenova2 config file follows"
cat $WORKDIR/config_file
debug_msg  ${LINENO} "Finished SOAPdenova2 config file" 

docker run \
	--name soapdenovo2$PREFIX  \
	-v $READSDIR:/reads:ro \
	-v $WORKDIR:/results \
	sriep/soapdenovo2 \
		  all \
		  -s /results/config_file \
		  -K 63 \
		  -p 15 \
		  -R \
		  -o /results/$PREFIX 
remove_docker_container soapdenovo2$PREFIX

CONTIGS=$WORKDIR/$PREFIX.contig
SCAFFOLDS=$WORKDIR/$PREFIX.scafSeq
#-------------------------- Assembly specific code here --------------------

source $SOURCEDIR/tools/local_footer.sh