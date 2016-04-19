#reapr
#FROM r-base:latest
FROM ubuntu:latest
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
    automake \
    build-essential \
	r-base \
    wget
RUN cpan File::Basename
RUN cpan File::Copy
RUN cpan File::Spec
RUN cpan File::Spec::Link
RUN cpan Getopt::Long
RUN cpan List::Util	
RUN wget ftp://ftp.sanger.ac.uk/pub/resources/software/reapr/Reapr_1.0.18.tar.gz
RUN tar -zxf Reapr_1.0.18.tar.gz
WORKDIR /Reapr_1.0.18
RUN ./install.sh
ENV PATH /Reapr_1.0.18:$PATH
ENTRYPOINT ["reapr"]
