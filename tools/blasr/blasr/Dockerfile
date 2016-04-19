#blasr
#FROM ubuntu:latest
FROM sriep/hdf5-1.8.16
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
    automake \
    build-essential \
    git \
    wget
# Install blasr	
RUN git clone git://github.com/PacificBiosciences/blasr.git blasr
ENV HDF5_INCLUDE /usr/local/hdf5/include:$HDF5_INCLUDE
ENV HDF5_LIB /usr/local/hdf5/lib:$HDF5_LIB
WORKDIR /blasr
#RUN git pull --rebase origin master && git submodule update --init
#RUN make update-submodule
RUN ./configure.py --shared --sub --no-pbbam
RUN make configure-submodule
RUN make build-submodule
RUN make blasr
RUN make
RUN sudo make install
ENV PATH /blasr:$PATH
ENTRYPOINT ["blasr"]
