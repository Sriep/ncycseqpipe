#ale
FROM ubuntu:latest
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
    automake \
    build-essential \
	zlib1g-dev \
    git \
    wget
RUN git clone https://github.com/sc932/ALE.git
WORKDIR /ALE
RUN make
ENV PATH /ALE/src:$PATH
ENTRYPOINT ["ALE"]
