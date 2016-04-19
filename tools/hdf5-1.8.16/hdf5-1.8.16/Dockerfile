#hdf5
FROM ubuntu:latest
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
    automake \
    build-essential \
    wget
RUN wget http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.16.tar
RUN tar -xf hdf5-1.8.16.tar
WORKDIR /hdf5-1.8.16
RUN ./configure --prefix=/usr/local/hdf5  --enable-cxx 
RUN make
RUN sudo make install
ENTRYPOINT ["/bin/bash"]
