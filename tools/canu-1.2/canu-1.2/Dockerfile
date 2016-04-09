FROM ubuntu:latest
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
    default-jdk \
    wget
RUN cpan Filesys/Df.pm
RUN wget https://github.com/marbl/canu/releases/download/v1.2/canu-1.2.Linux-amd64.tar.bz2
RUN bzip2 -dc canu-1.2*.tar.bz2 | tar -xf -
ENV PATH $PATH:/canu-1.2/Linux-amd64/bin
ENTRYPOINT ["canu"]
