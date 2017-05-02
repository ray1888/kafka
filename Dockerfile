FROM daocloud.io/library/debian:jessie
MAINTAINER "Cloth Mo" <root@buxiaomo.com>

COPY sources.list /etc/apt/sources.list

RUN apt-get update \
    && apt-get install openjdk-7-jdk --no-install-recommends -y \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH $PATH:$JAVA_HOME/bin:$JRE_HOME/bin

RUN apt-get update \
    && apt-get install axel --no-install-recommends -y \
    && axel --output=/usr/local/src/kafka_2.10-0.10.2.0.tgz http://apache.fayea.com/kafka/0.10.2.0/kafka_2.10-0.10.2.0.tgz \
    && tar -zxf /usr/local/src/kafka_2.10-0.10.2.0.tgz -C /usr/local/ \
    && rm -rf /usr/local/src/kafka_2.10-0.10.2.0.tgz \
    && apt-get remove axel -y \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/kafka_2.10-0.10.2.0

EXPOSE 9092 

ADD start.sh /start.sh

CMD ["/start.sh"]
