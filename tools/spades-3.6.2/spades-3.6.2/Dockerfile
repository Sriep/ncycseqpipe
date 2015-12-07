#spades-3.6.2
FROM centos:latest
MAINTAINER Piers Shepperson
RUN yum install -y \
    python2.7 \
	python-devel \
    wget
RUN wget http://spades.bioinf.spbau.ru/release3.6.2/SPAdes-3.6.2-Linux.tar.gz
RUN tar -xzf SPAdes-3.6.2-Linux.tar.gz
WORKDIR /SPAdes-3.6.2-Linux/bin/
ENV PATH /SPAdes-3.6.2-Linux/bin:$PATH
ENTRYPOINT ["./dipspades.py"]
