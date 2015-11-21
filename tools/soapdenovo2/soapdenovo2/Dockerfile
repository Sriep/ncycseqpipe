#soapdenovo2
FROM ubuntu:latest
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
    build-essential \
    git \
    wget
RUN git clone https://github.com/aquaskyline/SOAPdenovo2.git
WORKDIR SOAPdenovo2/
RUN make
ENTRYPOINT ["/SOAPdenovo2/SOAPdenovo-127mer"]

