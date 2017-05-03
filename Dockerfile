FROM daocloud.io/library/debian:jessie
MAINTAINER "Cloth Mo" <root@buxiaomo.com>

ENV KAFKA_VERSION=0.10.2.0
ENV SCALA_VERSION=2.10

COPY sources.list /etc/apt/sources.list

RUN apt-get update \
    && apt-get install openjdk-7-jdk --no-install-recommends -y \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH $PATH:$JAVA_HOME/bin:$JRE_HOME/bin

ADD download-kafka.sh /download-kafka.sh
RUN apt-get update \
    && apt-get install axel --no-install-recommends -y \
    && chmod a+x /download-kafka.sh \
    && /download-kafka.sh \
    && apt-get remove axel -y \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/kafka_${SCALA_VERSION}-${KAFKA_VERSION}

ENV KAFKA_TOPICS test
ENV KAFKA_HOST_IP 127.0.0.1
ENV KAFKA_PORT 9092
ENV ZOOKEEPER localhost:2181


EXPOSE 9092

ADD start.sh /start.sh

CMD ["/bin/bash","/start.sh"]
