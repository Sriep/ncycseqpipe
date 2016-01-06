#runCA
FROM ubuntu:latest
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
	default-jdk \
	wget  
RUN wget http://darlinglab.org/mauve/snapshots/2015/2015-02-13/linux-x64/mauve_linux_snapshot_2015-02-13.tar.gz
RUN tar -zxf mauve_linux_snapshot_2015-02-13.tar.gz
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH /mauve_snapshot_2015-02-13/linux-x64:$PATH
ENTRYPOINT ["progressiveMauve"] 