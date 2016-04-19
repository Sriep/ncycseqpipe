#FROM java:8
#FROM ubuntu:latest
#MAINTAINER Piers Shepperson
#RUN apt-get -y dist-upgrade
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
#RUN DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:webupd8team/java
#RUN apt-get update && sudo apt-get install -y   oracle-java8-installer 
#RUN apt-get update && sudo apt-get install -y \
#    automake \
#    build-essential \
#    git \
#    wget
#RUN cpan Filesys/Df.pm
#RUN git clone https://github.com/marbl/canu.git
#WORKDIR /canu/src
#RUN make -j 30
#ENV PATH $PATH:/canu/Linux-amd64/bin
#ENTRYPOINT ["canu"]

# Pull base image. if you use "latest" instead of "trusty",
# you will use latest ubuntu images as base image
FROM ubuntu:trusty

# Set maintainer details
MAINTAINER SHAMEERA

# Install prerequisites
RUN apt-get update
RUN apt-get install -y software-properties-common

# Install java8
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN apt-get update && sudo apt-get install -y \
    automake \
    build-essential \
    git \
    wget
RUN cpan Filesys/Df.pm
RUN git clone https://github.com/marbl/canu.git
WORKDIR /canu/src
RUN make -j 30
ENV PATH $PATH:/canu/Linux-amd64/bin
ENTRYPOINT ["canu"]
