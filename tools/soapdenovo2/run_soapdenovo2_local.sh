#!/bin/bash
declare -xr SOURCEDIR="$(dirname $BASH_SOURCE)/.."
source $SOURCEDIR/local_header.sh

#-------------------------- Assembly specific code here --------------------


echo $PREFIX SOAP2: about to run soap on strain $PREFIX

> $WORKDIR/config_file
cat $SOURCEDIR/soapdenovo2/soap_config_head.txt >> $WORKDIR/config_file
cat $SOURCEDIR/soapdenovo2/soap_config_lib_head.txt >> $WORKDIR/config_file
echo q1=/reads/$READS1 >> $WORKDIR/config_file
echo q2=/reads/$READS2 >> $WORKDIR/config_file

echo $PREFIX SOAP2: SOAPdenova2 config file follows
cat $WORKDIR/config_file
echo $PREFIX SOAP2: Finished SOAPdenova2 config file 

echo $PREFIX SOAP2: RUN RUN RUN

docker run \
	--name soapdenovo2$PREFIX  \
	-v $READSDIR:/reads:ro \
	-v $WORKDIR:/results \
	sriep/soapdenovo2 \
		  all \
		  -s /results/config_file \
		  -K $SOAP_KMER \
		  -p $SOAP_PROCS \
		  -R \
		  -o /results/$PREFIX 

echo $PREFIX SOAP2: SOAPdenovo2 return code is $?
docker rm -f soapdenovo2$PREFIX 
echo $PREFIX SOAP2: soapdenovo2$PREFIX  stopped

#Give location of result files
CONTIGS=$WORKDIR/$PREFIX.contig
SCAFFOLDS=$WORKDIR/$PREFIX.scafSeq
#-------------------------- Assembly specific code here --------------------

source $SOURCEDIR/ssh_footer.sh