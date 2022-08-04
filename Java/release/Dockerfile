FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /home/closure
ENV TZ="America/New_York"
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV PATH=PATH=$JAVA_HOME/bin:$HOME/MiniZincIDE-2.5.5-bundle-linux-x86_64/bin:$PATH
ENV CAPO=$HOME/gaps/capo/Java
ENV CLASSPATH=$CAPO/joana/dist/*:$CAPO/examples/eop2-demo/dist/*:$CAPO/jython-standalone-2.7.2.jar:$CAPO/jscheme-7.2.jar

RUN apt-get update && \
    apt-get install -y net-tools iproute2 netcat dnsutils curl iputils-ping iptables nmap tcpdump wget

RUN apt-get -y install openjdk-8-jdk
RUN apt-get -y install libzmq3-dev
RUN apt-get -y install libconfig-dev
RUN apt-get -y install tmux
RUN apt-get -y install libzmq-java
RUN apt-get -y install openssh-client

##########################
RUN useradd -u 8877 -s /bin/bash closure
RUN mkdir -p /home/closure
RUN chown closure.closure /home/closure

USER closure

RUN mkdir -p $HOME/opencv-4.6.0/build/
RUN mkdir -p $HOME/gaps

WORKDIR $HOME
RUN echo "bind X kill-session" > .tmux.conf
RUN echo "set-option -g status-keys emacs" >> .tmux.conf

RUN mkdir -p $HOME/gaps/capo/Java/examples
RUN mkdir -p $HOME/gaps/hal
RUN mkdir -p $HOME/opencv-4.6.0/build/lib/

ADD capo/Java/examples/eop2-demo $HOME/gaps/capo/Java/examples/eop2-demo
ADD hal $HOME/gaps/hal
ADD xdcc $HOME/gaps/xdcc
ADD lib $HOME/opencv-4.6.0/build/lib

WORKDIR $HOME/gaps
RUN cp capo/Java/examples/eop2-demo/resources/scripts/* .

EXPOSE 8080 8081

ENTRYPOINT $HOME/gaps/run.sh