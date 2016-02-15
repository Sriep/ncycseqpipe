FROM ubuntu:latest
MAINTAINER Piers Shepperson
#RUN sudo apt-key update && apt-get update && sudo apt-get install -y \
RUN apt-get update && sudo apt-get install -y \
	git \
    build-essential \
	Xvfb \
	qt5-default \	
    wget 
RUN git clone https://github.com/Sriep/ncycseqpipe.git
WORKDIR /ncycseqpipe/Cpp/ncycpipestats
RUN qmake ncycpipestats.pro
RUN make
ENV PATH  $PATH:/ncycseqpipe/Cpp/ncycpipestats
ENTRYPOINT ["xvfb-run"]
#ENTRYPOINT ["ncycpipestats"]

