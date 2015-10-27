#ncycpipe
FROM centos:latest
MAINTAINER Piers Shepperson
RUN yum install -y  git 
RUN git clone https://github.com/Sriep/ncycseqpipe.git
ENTRYPOINT [ "/ncycseqpipe/assemble_all.sh" ]