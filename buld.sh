#!/bin/bash
#
DOCKERDIR=/home/shepperp/datashare/Piers/github/ncycseqpipe
#DOCKERDIR=/home/shepperp/github/ncycseqpipe
cd $DOCKERDIR

#Start docker just in case
sudo service docker start

cd $DOCKERDIR/wgs-8.3rc2/fastqToCA
sudo docker build -t fastqtoca .
cd $DOCKERDIR/wgs-8.3rc2/runCA
sudo docker build -t runCA .
cd $DOCKERDIR/abyss-1.9.0/abyss-pe
sudo docker build -t abyss-pe .