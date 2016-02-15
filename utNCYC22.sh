#!/bin/bash 
# 

rm -r /home/shepperp/datashare/Piers/assemblies/UnitTest1
rm -r /home/shepperp/documents/test/UnitTest
/home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_all.sh /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipeUT.cfg > /home/shepperp/UT.log 2> /home/shepperp/UTerr.log &
disown
# sudo bash -c "/home/shepperp/datashare/Piers/github/ncycseqpipe/utNCYC22.sh &"
#
# sudo bash -c "/home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_all.sh /home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input/ncycseqpipeUT.cfg > /home/shepperp/UT.log 2> /home/shepperp/UTerr.log &"