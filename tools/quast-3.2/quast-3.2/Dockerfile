#quast
FROM ubuntu:latest
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
    automake \
    build-essential \
	zlib1g-dev \
	python2.7 \
	python-pip \
	python-dev \
	python-numpy \
    wget
RUN wget http://sourceforge.net/projects/quast/files/quast-3.2.tar.gz/download -O quast-3.2.tar.gz
RUN tar -zxf quast-3.2.tar.gz
WORKDIR /quast-3.2
ENTRYPOINT ["./quast.py"]
