axel -n 20 --output=/usr/local/src/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz http://apache.fayea.com/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz
tar -zxf /usr/local/src/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /usr/local/
rm -rf /usr/local/src/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz
