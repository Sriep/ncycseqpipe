#!/bin/bash -eu
#
#service docker start
#SOURCEDIR==$(dirname "$BASH_SOURCE")
SOURCEDIR=/home/shepperp/datashare/Piers/github/ncycseqpipe
VERSION=devel

docker build -t sriep/abyss $SOURCEDIR/tools/abyss/abyss
docker build -t sriep/ale $SOURCEDIR/tools/ale/ale
docker build -t sriep/samtools-1.3 $SOURCEDIR/tools/samtools-1.3/samtools-1.3
docker build -t sriep/bowtie2-2.2.6 $SOURCEDIR/tools/bowtie2-2.2.6/bowtie2-2.2.6
#docker build -t sriep/cgal $SOURCEDIR/tools/cgal/cgal
docker build -t sriep/discovardenovo-52488 $SOURCEDIR/tools/discovardenovo-52488/discovardenovo-52488
docker build -t sriep/mauve-2.4.0 $SOURCEDIR/tools/mauve-2.4.0/mauve-2.4.0
docker build -t sriep/finishersc $SOURCEDIR/tools/finishersc/finishersc
#docker build -t sriep/pilon-1.16 $SOURCEDIR/tools/pilon-1.16/pilon-1.16
docker build -t sriep/progressivecactus $SOURCEDIR/tools/progressivecactus/progressivecactus
docker build -t sriep/quast-3.2 $SOURCEDIR/tools/quast-3.2/quast-3.2
docker build -t sriep/ragout $SOURCEDIR/tools/ragout/ragout
docker build -t sriep/ray-2.3.1 $SOURCEDIR/tools/ray-2.3.1/ray-2.3.1
docker build -t sriep/scaffmatch-0.9 $SOURCEDIR/tools/scaffmatch-0.9/scaffmatch-0.9
docker build -t sriep/sga $SOURCEDIR/tools/sga/sga
docker build -t sriep/sibelia $SOURCEDIR/tools/sibelia/sibelia
docker build -t sriep/soapdenovo2 $SOURCEDIR/tools/soapdenovo2/soapdenovo2
docker build -t sriep/spades-3.6.2 $SOURCEDIR/tools/spades-3.6.2/spades-3.6.2
docker build -t sriep/spades-3.7.0 $SOURCEDIR/tools/spades-3.7.0/spades-3.7.0
docker build -t sriep/sspace-longread-1.1 $SOURCEDIR/tools/sspace-longread-1.1/sspace-longread-1.1
docker build -t sriep/wgs-8.3rc2 $SOURCEDIR/tools/wgs-8.3rc2/wgs-8.3rc2


docker push sriep/abyss
docker push sriep/ale
docker push sriep/samtools-1.3
docker push sriep/bowtie2-2.2.6
#docker push sriep/cgal
docker push sriep/discovardenovo-52488
docker push sriep/mauve-2.4.0
docker push sriep/finishersc
#docker push sriep/pilon-1.16
docker push sriep/progressivecactus
docker push sriep/quast-3.2
docker push sriep/ragout
docker push sriep/ray-2.3.1
docker push sriep/scaffmatch-0.9
docker push sriep/sga
docker push sriep/sibelia
docker push sriep/soapdenovo2
docker push sriep/spades-3.6.2
docker push sriep/spades-3.7.0
docker push sriep/sspace-longread-1.1 
docker push sriep/wgs-8.3rc2

#sudo bash -c "/home/shepperp/datashare/Piers/github/ncycseqpipe/utNCYC22.sh &"
#sudo bash -c "/home/shepperp/datashare/Piers/github/ncycseqpipe/build.sh &"

