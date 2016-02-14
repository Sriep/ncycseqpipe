#abyss
FROM ubuntu:latest
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
WORKDIR abyss/
RUN ./autogen.sh
RUN ./configure
RUN make
RUN sudo make install
ENTRYPOINT ["abyss-pe"]
