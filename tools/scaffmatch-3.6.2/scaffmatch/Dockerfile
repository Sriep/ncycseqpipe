#Ray
FROM sriep/bowtie2-2.2.6
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
								git \
								build-essential \
								libopenmpi-dev \
								python2.7 \
								python-pip \
								python-dev \
								python-numpy
RUN pip install networkx
RUN git clone https://github.com/mandricigor/ScaffMatch.git
WORKDIR ScaffMatch
RUN sh install.sh
ENV PATH /ScaffMatch:$PATH
ENTRYPOINT ["scaffmatch"] 