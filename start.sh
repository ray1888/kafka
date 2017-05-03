#!/bin/bash
sed -i "s/#listeners=PLAINTEXT:\/\/:9092/listeners=PLAINTEXT:\/\/0.0.0.0:9092/g" config/server.properties
sed -i "s/#advertised.listeners/advertised.listeners/g" config/server.properties
sed -i "s/your.host.name:9092/${KAFKA_HOST_IP}:${KAFKA_PORT}/g" config/server.properties
bin/zookeeper-server-start.sh config/zookeeper.properties & 
bin/kafka-server-start.sh config/server.properties & 
sleep 5
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic ${KAFKA_TOPICS}
tail -f logs/*.log
