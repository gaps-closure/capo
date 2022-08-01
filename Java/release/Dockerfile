FROM ubuntu:20.04

ADD .tmux.conf /root

RUN mkdir -p /home/tchen/
RUN mkdir -p /home/tchen/gaps/capo/Java/examples
RUN mkdir -p /home/tchen/gaps/hal
RUN mkdir -p /home/tchen/opencv-4.6.0/build/lib/

ADD capo/Java/examples/eop2-demo /home/tchen/gaps/capo/Java/examples/eop2-demo
ADD hal /home/tchen/gaps/hal
ADD xdcc /home/tchen/gaps/xdcc
ADD lib /home/tchen/opencv-4.6.0/build/lib

WORKDIR /home/tchen/gaps/capo/Java/examples/eop2-demo/resources/scripts

RUN apt-get update && \
    apt-get install -y net-tools iproute2 netcat dnsutils curl iputils-ping iptables nmap tcpdump

#ENV DEBIAN_FRONTEND noninteractive
#RUN apt-get update && \
#    apt-get -y install gcc mono-mcs && \
#    rm -rf /var/lib/apt/lists/*

RUN apt-get -y install openjdk-8-jdk
RUN apt-get -y install libzmq3-dev
RUN apt-get -y install libconfig-dev
RUN apt-get -y install tmux
RUN apt-get -y install libzmq-java
RUN apt-get -y install openssh-client

EXPOSE 8080 8081

ENTRYPOINT /home/tchen/gaps/capo/Java/examples/eop2-demo/resources/scripts/run.sh