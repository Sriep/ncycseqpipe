#!/bin/bash
#
service docker start

#cd $DOCKERDIR/wgs-8.3rc2/fastqToCA
#sudo docker build -t fastqtoca .
#cd $DOCKERDIR/wgs-8.3rc2/runCA
#sudo docker build -t runCA .
docker build -t sriep/abyss-pe:latest /ncycseqpipe/abyss/abyss-pe
docker build -t sriep/progressivecactus:latest /ncycseqpipe/progressiveCactus/runProgressiveCactus
docker build -t sriep/ragout:latest /ncycseqpipe/ragout/ragoutpy
docker build -t sriep/soapdenovo2:latest /ncycseqpipe/SOAPdenovo2/SOAPdenovo2

docker push sriep/abyss-pe:latest
docker push sriep/progressivecactus:latest
docker push sriep/ragout:latest
docker push sriep/soapdenovo2:latest

