#abyss
FROM ubuntu:latest
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
    automake \
    build-essential \
	cmake \
    git \
    wget
RUN git clone https://github.com/bioinf/Sibelia.git
WORKDIR Sibelia/build
RUN cmake ../src
RUN make
RUN sudo make install
ENTRYPOINT ["Sibelia"]
