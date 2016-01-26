FROM ubuntu:latest
#bowtie2 2.2.6
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
	python2.7 \
	python-pip \
	python-dev \
	python-numpy \
	unzip \
    wget
RUN wget http://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.6/bowtie2-2.2.6-linux-x86_64.zip/download -O bowtie2-2.2.6-linux-x86_64.zip
RUN unzip bowtie2-2.2.6-linux-x86_64.zip
ENV PATH /bowtie2-2.2.6:$PATH
ENTRYPOINT ["bowtie2"]
