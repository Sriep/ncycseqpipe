#ncycpipe
FROM centos:latest
MAINTAINER Piers Shepperson
RUN yum update
RUN curl -sSL https://get.docker.com/ | sh
RUN service docker start
RUN buld.sh
ENTRYPOINT["assembleStrain.sh"]