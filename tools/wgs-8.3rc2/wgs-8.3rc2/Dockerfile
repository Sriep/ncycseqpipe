#runCA
FROM ubuntu:14.04
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
	bzip2 \
	libgomp1 \
	wget  \
	perl \
	 build-essential \ 
	 gcc-multilib \ 
	 apt-utils \ 
	 expat \ 
	 libexpat-dev 
	cpanminus 
RUN cpanm CPAN::Meta \
 Digest::SHA \ 
 Module::Build \ 
 ExtUtils::MakeMaker \ 
 Test::More \ 
 Data::Stag \ 
 Config::Simple \ 
 Statistics::Lite \ 
 Statistics::Descriptive 
RUN wget http://sourceforge.net/projects/wgs-assembler/files/wgs-assembler/wgs-8.3/wgs-8.3rc2-Linux_amd64.tar.bz2/download -O wgs-8.3rc2-Linux_amd64.tar.bz2
RUN bzip2 -dc wgs-8.3rc2-*.tar.bz2 | tar -xf -
WORKDIR /wgs-8.3rc2/Linux-amd64/bin
ENV PATH /wgs-8.3rc2/Linux-amd64/bin:$PATH
ENTRYPOINT ["runCA"] 