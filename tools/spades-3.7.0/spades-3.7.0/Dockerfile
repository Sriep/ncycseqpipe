#spades-3.6.2
#FROM centos:latest
#FROM centos:7.1.1503
#FROM centos:7.0.1406
#MAINTAINER Piers Shepperson
#RUN mkdir -p /usr/bin/env
#RUN yum install -y \
#    python2.7 \
#	python-devel \
#	tar \
#    wget
#RUN wget http://spades.bioinf.spbau.ru/release3.7.0/SPAdes-3.7.0-Linux.tar.gz
#RUN tar -xzf SPAdes-3.7.0-Linux.tar.gz
#RUN mkdir -p /usr/bin/env
#RUN ln -s /usr/bin/python2.7 /usr/bin/env/python2.7
#WORKDIR /SPAdes-3.7.0-Linux/bin/
#ENV PATH /SPAdes-3.7.0-Linux/bin:$PATH
#ENTRYPOINT ["./dipspades.py"]
#

#FROM ubuntu:14.04
#FROM python:3-onbuild
#MAINTAINER Piers Shepperson
# Install Python.
#RUN \
#  apt-get update && \
#  apt-get install -y python python-dev python-pip python-virtualenv && \
#  rm -rf /var/lib/apt/lists/*
#RUN sudo apt-get update && sudo apt-get install -y   wget
#RUN ln -s /usr/bin/python3 /usr/bin/python
#RUN wget http://spades.bioinf.spbau.ru/release3.7.0/SPAdes-3.7.0-Linux.tar.gz
#RUN tar -xzf SPAdes-3.7.0-Linux.tar.gz
#WORKDIR /SPAdes-3.7.0-Linux/bin/
#ENV PATH $PATH:/SPAdes-3.7.0-Linux/bin
#ENTRYPOINT ["./dipspades.py"]


FROM ubuntu:14.04
#MAINTAINER Piers Shepperson
RUN \
  apt-get update && \
  apt-get install -y python python-dev python-pip python-virtualenv && \
  rm -rf /var/lib/apt/lists/*
RUN sudo apt-get update && sudo apt-get install -y   \
    automake \
    build-essential \
	cmake \	
	zlib1g-dev
	wget
RUN sudo apt-get update && sudo apt-get install -y  bzip2
#RUN ln -s /usr/bin/python3 /usr/bin/python
RUN    wget http://spades.bioinf.spbau.ru/release3.7.0/SPAdes-3.7.0.tar.gz
RUN    tar -xzf SPAdes-3.7.0.tar.gz
RUN /SPAdes-3.7.0/spades_compile.sh
WORKDIR /SPAdes-3.7.0/bin
ENV PATH $PATH:/SPAdes-3.7.0/bin
ENTRYPOINT ["./dipspades.py"]






























