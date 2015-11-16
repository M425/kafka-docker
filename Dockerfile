FROM ubuntu:trusty

MAINTAINER Wurstmeister 

ENV KAFKA_VERSION="0.8.2.1" SCALA_VERSION="2.10"

RUN apt-get update && apt-get install -y unzip openjdk-6-jdk wget curl git docker.io jq
RUN apt-get install -y --no-install-recommends openssh-server
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
CMD ["/usr/sbin/sshd"]

ADD download-kafka.sh /tmp/download-kafka.sh
RUN /tmp/download-kafka.sh
RUN tar xf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ADD start-kafka.sh /usr/bin/start-kafka.sh
ADD broker-list.sh /usr/bin/broker-list.sh
CMD start-kafka.sh
