#!/bin/bash
sed -i "s/#listeners=PLAINTEXT:\/\/:9092/listeners=PLAINTEXT:\/\/0.0.0.0:9092/g" config/server.properties
# sed -i "s/#advertised.listeners/advertised.listeners/g" config/server.properties
# sed -i "s/your.host.name:9092/${KAFKA_HOST_IP}:${KAFKA_PORT}/g" config/server.properties
if [ ${ZOOKEEPER} == "localhost:2181" ]
then
  bin/zookeeper-server-start.sh config/zookeeper.properties & 
else 
  sed -i "s/zookeeper.connect=localhost:2181/zookeeper.connect=${ZOOKEEPER}/g" config/server.properties
fi
bin/kafka-server-start.sh config/server.properties & 
sleep 5
if [ ${ZOOKEEPER} == "localhost:2181" ]
then
  bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic ${KAFKA_TOPICS}
else
  zookeeper=`echo $ZOOKEEPER_CLUSTER | sed "s/,/\n/g" | head -n 1`
  bin/kafka-topics.sh --create --zookeeper ${zookeeper} --replication-factor 1 --partitions 1 --topic ${KAFKA_TOPICS}
fi
tail -f logs/*.log
