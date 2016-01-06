FROM centos:latest
MAINTAINER Piers Shepperson
RUN yum install -y \
    automake \
    build-essential \
	gcc-c++ \
    git \
	make \
    python2.7 \
	python-devel \
	bzip2 \
    wget
RUN git clone git://github.com/glennhickey/progressiveCactus.git
WORKDIR progressiveCactus/
RUN git pull
RUN git submodule update --init
RUN make
ENV PATH $PATH:/progressiveCactus/submodules/hal/bin:/progressiveCactus/bin
ENV PYTHONPATH $PYTHONPATH:/progressiveCactus/submodules 
ENTRYPOINT ["/progressiveCactus/bin/runProgressiveCactus.sh"]

