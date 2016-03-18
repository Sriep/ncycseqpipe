FROM ubuntu:14.04
MAINTAINER Piers Shepperson
RUN \
  apt-get update && \
  apt-get install -y python python-dev python-pip python-virtualenv && \
  rm -rf /var/lib/apt/lists/*
RUN sudo apt-get update && sudo apt-get install -y   wget
RUN wget http://spades.bioinf.spbau.ru/release3.7.0/SPAdes-3.7.0-Linux.tar.gz
RUN tar -xzf SPAdes-3.7.0-Linux.tar.gz
WORKDIR /SPAdes-3.7.0-Linux/bin/
ENV PATH $PATH:/SPAdes-3.7.0-Linux/bin
ENTRYPOINT ["./dipspades.py"]
