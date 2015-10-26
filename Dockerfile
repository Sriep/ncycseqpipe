#ncycpipe
FROM centos:latest
MAINTAINER Piers Shepperson
RUN yum update
RUN curl -sSL https://get.docker.com/ | sh
RUN service docker start
RUN yum install -y  git 
RUN git clone https://github.com/Sriep/ncycseqpipe.git
RUN /ncycseqpipe/buld.sh
ENTRYPOINT["/ncycseqpipe/assemble_all.sh"]