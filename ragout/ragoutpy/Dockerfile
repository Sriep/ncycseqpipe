#ragout
FROM sriep/progressivecactus:latest
MAINTAINER Piers Shepperson
RUN git clone https://github.com/fenderglass/Ragout.git
WORKDIR Ragout/
RUN make
ENTRYPOINT ["./ragout.py" ]

