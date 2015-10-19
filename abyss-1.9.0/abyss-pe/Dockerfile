#abyss-pe
FROM ubuntu:14.04
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
    automake \
	build-essential \
    git \
    libboost-all-dev \
    libhdf5-openmpi-dev \
    libopenmpi-dev \
    openmpi-bin \
    sparsehash \
    wget
RUN git clone https://github.com/bcgsc/abyss.git
#RUN cd abyss
WORKDIR abyss/
RUN ./autogen.sh
RUN ./configure
RUN make
RUN sudo make install
ENTRYPOINT ["abyss-pe"]
#ENTRYPOINT ["abyss-1.9.0/bin/abyss-pe"]

#ENTRYPOINT ["abyss-pe"]
#ENTRYPOINT ["ls"]
#	autoconf \
#	automake \
#	libboost-all-dev \
#    libhdf5-openmpi-dev \
#    libopenmpi-dev \      
#    openmpi-bin \
#    sparsehash 
#    wget
#
#
#RUN cd abyss-1.9.0
#RUN ./autogen.sh
#RUN ./configure
#RUN make
#RUN sudo make install
#RUN sudo echo deb http://us.archive.ubuntu.com/ubuntu trusty main multiverse >> /etc/apt/sources.list
#RUN sudo apt-get update && sudo apt-get install -y abyss  
#RUN wget https://github.com/bcgsc/abyss/releases/download/1.9.0/abyss-1.9.0.tar.gz
#RUN tar -zxf abyss-1.9.0.tar.gz