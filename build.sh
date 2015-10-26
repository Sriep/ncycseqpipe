#!/bin/bash
#
sudo service docker start

#cd $DOCKERDIR/wgs-8.3rc2/fastqToCA
#sudo docker build -t fastqtoca .
#cd $DOCKERDIR/wgs-8.3rc2/runCA
#sudo docker build -t runCA .
sudo docker build -t abyss-pe /ncycseqpipe/abyss/abyss-pe
sudo docker build -t progressivecactus /ncycseqpipe/progressiveCactus/runProgressiveCactus
sudo docker build -t ragout /ncycseqpipe/ragout/ragoutpy
sudo docker build -t soapdenovo2 /ncycseqpipe/SOAPdenovo2/SOAPdenovo2