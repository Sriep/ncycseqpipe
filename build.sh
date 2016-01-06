#!/bin/bash -eu
#
service docker start

docker build -t sriep/sspace-longread-1.1 ./sspace-longread-1.1/sspace-longread-1.1
docker build -t sriep/progressivecactus ./progressivecactus/progressivecactus
docker build -t sriep/mauve-2.4.0 ./mauve-2.4.0/mauve-2.4.0
docker build -t sriep/scaffmatch-3.6.2 ./scaffmatch-3.6.2/scaffmatch-3.6.2
docker build -t sriep/bowtie2-2.2.6 ./bowtie2-2.2.6/bowtie2-2.2.6
docker build -t sriep/ray-2.3.1 ./ray-2.3.1/ray-2.3.1
docker build -t sriep/spades-3.6.2 ./spades-3.6.2
docker build -t sriep/wgs-8.3rc2/spades-3.6.2
docker build -t sriep/ragout ./ragout/ragout
docker build -t sriep/soapdenovo2 ./soapdenovo2/soapdenovo2
docker build -t sriep/abyss ./abyss/abyss

docker push sriep/sspace-longread-1.1 
docker push sriep/progressivecactus
docker push sriep/mauve-2.4.0
docker push sriep/scaffmatch-3.6.2
docker push sriep/bowtie2-2.2.6
docker push sriep/ray-2.3.1
docker push sriep/spades-3.6.2
docker push sriep/wgs-8.3rc2
docker push sriep/ragout
docker push sriep/soapdenovo2
docker push sriep/abyss

