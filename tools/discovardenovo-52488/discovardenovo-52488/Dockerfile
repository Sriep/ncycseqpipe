#abyss
FROM ubuntu:latest
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
    automake \
    build-essential \
	libjemalloc-dev \
	zlib1g-dev \
    wget
#RUN wget https://github.com/jemalloc/jemalloc/archive/4.0.4.tar.gz
RUN wget ftp://ftp.broadinstitute.org/pub/crd/DiscovarDeNovo/latest_source_code/LATEST_VERSION.tar.gz
#RUN tar -zxf 4.0.4.tar.gz
RUN tar -zxf LATEST_VERSION.tar.gz
#WORKDIR /jemalloc-4.0.4
#RUN ./autogen.sh
#RUN ./configure
#WORKDIR /jemalloc-4.0.4/deps
#RUN make hiredis lua jemalloc linenoise
#WORKDIR /jemalloc-4.0.4
#RUN make
#RUN sudo make install_bin install_include install_lib
WORKDIR /discovardenovo-52488
RUN ./configure
RUN make all
RUN sudo make install
ENTRYPOINT ["DiscovarDeNovo"]
