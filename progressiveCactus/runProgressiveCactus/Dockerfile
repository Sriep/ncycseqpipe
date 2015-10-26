FROM centos:latest
MAINTAINER Piers Shepperson
#RUN yum check-update && yum install -y \
RUN yum install -y \
    automake \
    build-essential \
	gcc-c++ \
    git \
	make \
    python2.7 \
	python-devel \
    wget
RUN git clone git://github.com/glennhickey/progressiveCactus.git
WORKDIR progressiveCactus/
RUN git pull
RUN git submodule update --init
RUN make
ENTRYPOINT ["/progressiveCactus/bin/runProgressiveCactus.sh"]

