#Ray
FROM ubuntu:14.04
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
								build-essential \
								libopenmpi-dev \
								openmpi-bin \
								wget \
								libcr-dev \
								mpich2 \
								mpich2-doc \
								openssh-client \
								openssh-server
RUN wget http://sourceforge.net/projects/denovoassembler/files/Ray-2.3.1.tar.bz2/download -O Ray-2.3.1.tar.bz2
#RUN bzip2 Ray-2.3.1.tar.bz2 | tar -xf -
RUN tar -jxf Ray-2.3.1.tar.bz2
WORKDIR /Ray-2.3.1
RUN make PREFIX=ray-build
RUN make install
ENV PATH /Ray-2.3.1/ray-build:$PATH
ENTRYPOINT ["mpiexec -n 10 Ray"] 