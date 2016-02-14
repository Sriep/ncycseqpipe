FROM ubuntu:latest
#samtools-1.3
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
	zlib1g-dev \
	build-essential \
	libncurses-dev \
    wget
RUN wget http://sourceforge.net/projects/samtools/files/samtools/1.3/samtools-1.3.tar.bz2/download -O samtools-1.3.tar.bz2
RUN tar -jxf samtools-1.3.tar.bz2
WORKDIR /samtools-1.3
RUN ./configure
RUN make
RUN make install
ENTRYPOINT ["samtools"]
