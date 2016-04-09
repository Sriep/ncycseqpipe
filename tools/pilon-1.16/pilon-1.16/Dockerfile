#abyss
FROM ubuntu:latest
MAINTAINER Piers Shepperson
RUN sudo apt-get update && sudo apt-get install -y \
    default-jdk \
    wget
RUN wget https://github.com/broadinstitute/pilon/releases/download/v1.16/pilon-1.16.jar
ENTRYPOINT ["java"]
