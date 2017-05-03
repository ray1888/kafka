#!/bin/bash
bin/zookeeper-server-start.sh config/zookeeper.properties & 
bin/kafka-server-start.sh config/server.properties & 
sleep 100
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic ${TOPICS}
tail -f logs/*.log
