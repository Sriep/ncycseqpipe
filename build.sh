#!/bin/bash
#
service docker start

#cd $DOCKERDIR/wgs-8.3rc2/fastqToCA
#sudo docker build -t fastqtoca .
#cd $DOCKERDIR/wgs-8.3rc2/runCA
#sudo docker build -t runCA .
docker build -t sriep/abyss-pe:latest ./assemblers/abyss/abyss-pe
docker build -t sriep/soapdenovo2:latest ./assemblers/SOAPdenovo2/SOAPdenovo2
docker build -t sriep/progressivecactus:latest ./progressiveCactus/runProgressiveCactus
docker build -t sriep/ragout:latest ./ragout/ragoutpy

docker push sriep/abyss-pe:latest
docker push sriep/soapdenovo2:latest
docker push sriep/progressivecactus:latest
docker push sriep/ragout:latest


