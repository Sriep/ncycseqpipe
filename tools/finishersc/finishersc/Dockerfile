#abyss
FROM ubuntu:latest
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
    automake \
    build-essential \
    git \
								python2.7 \
								python-pip \
								python-dev \
								python-numpy
RUN git clone https://github.com/kakitone/finishingTool.git
ENV PATH $PATH:/finishingTool
WORKDIR /finishingTool
ENTRYPOINT ["python"]
#		python2.7 \
