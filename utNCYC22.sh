#!/bin/bash 
# 

rm -r /home/shepperp/datashare/Piers/assemblies/test/NCYC22
rm -r /home/shepperp/documents/test/workdir/NCYC22
/home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_all.sh /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipeUT.cfg > /home/shepperp/UT.log &
disown
# sudo /home/shepperp/datashare/Piers/github/ncycseqpipe/utNCYC22.sh