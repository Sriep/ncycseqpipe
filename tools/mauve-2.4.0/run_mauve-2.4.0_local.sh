#!/bin/bash 
# 
declare -r SOURCEDIR="$1"
source $SOURCEDIR/tools/local_header.sh
# PREFIX - Name of strain to assemble
# READS1 - First set of paired end reads, relative to $LOCAL_READSDIR
# READS2 - Second set of paired end reads, relative to $LOCAL_READSDIR
# TOOL_TAG - Tag to indicate the output from this tool
# PARAMETERS - Data used to paramatirse this tool
#
# WORKDIR - Directory in which to put tempory work files
# READSDIR - Directory where paired end reads are located
#-------------------------- Assembly specific code here --------------------

docker run \
  --name mauve1 \
  --entrypoint=progressiveMauve \  
  -v /home/shepperp/datashare/Piers/assemblies/test/NCYC93:/assemblies:ro \ 
  -v /home/shepperp/datashare/ref_genome:/refs:ro \
  -v /home/shepperp/datashare/Piers/assemblies/Mauveout:/out \
  sriep/mauve-2.4.0 \
    --output=/out/NCYC93vRef.xmfa \
   /assemblies/asNCYC93i.fasta \
   /refs/Saccharomyces_cerevisiae/S288c_refseq.fasta
docker rm mauve1

docker run \
  --name mauve1 \
  -v /home/shepperp/datashare/Piers/assemblies/test/NCYC93:/assemblies:ro \ 
  -v /home/shepperp/datashare:/refs:ro \
  -v /home/shepperp/datashare/Piers/assemblies/Mauveout:/out \
  --entrypoint=progressiveMauve \    
  sriep/mauve-2.4.0 \
    --output=/out/NCYC93vRef.xmfa \
   /assemblies/asNCYC93i.fasta \
   /refs/ref_genome/Saccharomyces_cerevisiae/S288c_refseq.fasta
docker rm mauve1

docker run \
  --name mauve1 \
  --entrypoint=progressiveMauve \  
  -volume=/home/shepperp/datashare/Piers/assemblies/test/NCYC93:/assemblies:ro \ 
  -volume=/home/shepperp/datashare/ref_genome:/refs:ro \
  -volume=/home/shepperp/documents/testmauve/mout:/out \
  sriep/mauve-2.4.0 \
    --output=/out/NCYC93vRef.xmfa \
   /assemblies/asNCYC93i.fasta \
   /refs/Saccharomyces_cerevisiae/S288c_refseq.fasta
docker rm mauve1


progressiveMauve  --output=NCYC93vS288cRef.xmfa1 seq1 ../S288c_refseq.fasta seq2 ../asNCYC93i.fasta 
progressiveMauve  --output=NCYC93vS288cRef.xmfa1 seq1 /home/shepperp/documents/testmauve/S288c_refseq.fasta seq2 /home/shepperp/documents/testmauve/aNCYC93.fasta 
progressiveMauve  --output=NCYC388vCagGRef.xmfa1 seq1 /home/shepperp/documents/testmauve/CagGRefNCYC388.fasta seq2 /home/shepperp/documents/testmauve/aNCYC388.fasta 

progressiveMauve  --output=NCYC93vS288cRef.xmfa1

cp /home/shepperp/datashare/Piers/assemblies/all/aNCYC388.fasta aNCYC388.fasta 
cp /home/shepperp/datashare/Piers/ref_genome/CagGRefNCYC388.fasta CagGRefNCYC388.fasta 

docker run   --name mauve1   -v /home/shepperp/datashare/Piers/assemblies/test/NCYC93:/assemblies:ro   -v /home/shepperp/datashare:/refs:ro   -v /home/shepperp/documents/testmauve/mout:/out   --entrypoint=progressiveMauve  sriep/mauve-2.4.0     --output=/out/NCYC93vRef.xmfa    /assemblies/asNCYC93i.fasta    /refs/ref_genome/Saccharomyces_cerevisiae/S288c_refseq.fasta
   
docker rm mauve1
#docker run \
#	--name abysspe$PREFIX  \
#	-v $READSDIR:/reads:ro \
#	-v $WORKDIR:/results \
#	sriep/abyss-pe \
#		${args[0]}  ${args[1]} ${args[2]} ${args[3]} ${args[4]} \
#		name=/results/$PREFIX \
#		in="/reads/$READS1 /reads/$READS2"
#echo ABYSS: abyss return code is $?
#docker rm -f abysspe$PREFIX 
#echo ABYSS: abysspe$PREFIX  stopped

# Give location of result files
# CONTIGS - contig assembly fasta file
# SCAFFOLDS - scaffold assembly fasta file
CONTIGS=$WORKDIR/$PREFIX-6.fa
SCAFFOLDS=$WORKDIR/$PREFIX-8.fa
#-------------------------- Footer --------------------

source $SOURCEDIR/tools/local_footer.sh

#declare  CONFIGFILE=/home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipe.cfg
#declare SSH_CONFIGFILE
#declare  PREFIX=NCYC22
#declare  READS1=/NCYC22/NCYC22.FP.fastq
#declare  READS2=/NCYC22/NCYC22.RP.fastq
#declare  ASSEMBLY_TAG=a
#declare  PARAMTERS=k=80 j=10
