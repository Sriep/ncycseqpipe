#runCA
FROM ubuntu:14.04
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
								bzip2 \
								libgomp1 \
								wget 
RUN wget http://sourceforge.net/projects/wgs-assembler/files/wgs-assembler/wgs-8.3/wgs-8.3rc2-Linux_amd64.tar.bz2/download -O wgs-8.3rc2-Linux_amd64.tar.bz2
RUN bzip2 -dc wgs-8.3rc2-*.tar.bz2 | tar -xf -
#ENV PATH $PWD/abyss-1.9.0/bin:$PATH
ENTRYPOINT ["wgs-8.3rc2/Linux-amd64/bin/runCA"] 