#Ray
FROM ubuntu:14.04
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
								libopenmpi-dev \
								openmpi-bin \
								wget \
								libcr-dev \
								mpich2 \
								mpich2-doc \
RUN wget http://sourceforge.net/projects/denovoassembler/files/Ray-2.3.1.tar.bz2/download -O Ray-2.3.1.tar.bz2
RUN bzip2 Ray-2.3.1.tar.bz2 | tar -xf -
make PREFIX=ray-build
make install
ENTRYPOINT ["mpiexec -n 32 ray-build/Ray"] 