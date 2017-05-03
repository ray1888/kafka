#!/bin/bash
echo "advertised.listeners=PLAINTEXT://10.2.23.3:9092" >> config/server.properties
bin/zookeeper-server-start.sh config/zookeeper.properties & 
bin/kafka-server-start.sh config/server.properties & 
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
tail -f logs/*.log
