FROM daocloud.io/library/debian:jessie
MAINTAINER "Cloth Mo" <root@buxiaomo.com>

ENV KAFKA_VERSION=0.10.2.0
ENV SCALA_VERSION=2.10

COPY sources.list /etc/apt/sources.list

RUN echo "Asia/Shanghai" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update \
    && apt-get install openjdk-7-jdk --no-install-recommends -y \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH $PATH:$JAVA_HOME/bin:$JRE_HOME/bin

RUN apt-get update \
    && apt-get install axel --no-install-recommends -y \
    && axel -n 20 --output=/usr/local/src/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz http://apache.fayea.com/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
    && tar -zxf /usr/local/src/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /usr/local/ \
    && rm -rf /usr/local/src/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
    && apt-get remove axel -y \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*

COPY dce-app-entrypoint /usr/local/bin/

RUN chmod +x /usr/local/bin/dce-app-entrypoint

WORKDIR /usr/local/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
    
ENV BROKER_ID NULL
ENV KAFKA_TOPICS NULL
ENV ZOOKEEPER_CLUSTER localhost:2181

ENV KAFKA_EXTERNAL false
ENV KAFKA_HOST_IP 127.0.0.1
ENV KAFKA_PORT 9092

EXPOSE 9092 2181

ADD start.sh /start.sh

CMD ["/bin/bash","/start.sh"]
