#!/bin/bash
# IP=`ip addr | grep inet | grep -v "127.0.0.1" | awk -F '/' '{print $1}' | awk '{print $2}'`
IP=`hostname -i`

sed -i "s/#listeners=PLAINTEXT:\/\/:9092/listeners=PLAINTEXT:\/\/0.0.0.0:9092/g" config/server.properties

# DCE
sed -i "s/#advertised.listeners/advertised.listeners/g" config/server.properties
sed -i "s/your.host.name:9092/${KAFKA_HOST_IP}:${KAFKA_PORT}/g" config/server.properties
echo "host.name=${KAFKA_HOST_IP}" >>  config/server.properties

# sed -i "s/#advertised.listeners/advertised.listeners/g" config/server.properties
# sed -i "s/your.host.name:9092/${IP}:9092/g" config/server.properties
# echo "host.name=${IP}" >>  config/server.properties

if [ ${BROKER_ID} != "NULL" ];then
    sed -i "s/broker.id=.*/broker.id=${BROKER_ID}/g" config/server.properties
fi
if [ ${ZOOKEEPER_CLUSTER} == "localhost:2181" ];then
    bin/zookeeper-server-start.sh config/zookeeper.properties & 
else 
    sed -i "s/zookeeper.connect=localhost:2181/zookeeper.connect=${ZOOKEEPER_CLUSTER}/g" config/server.properties
fi
bin/kafka-server-start.sh config/server.properties & 
sleep 5
if [ ${KAFKA_TOPICS} != "NULL" ];then
    if [ ${ZOOKEEPER_CLUSTER} == "localhost:2181" ];then
        bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic ${KAFKA_TOPICS}
    else
        zookeeper=`echo $ZOOKEEPER_CLUSTER | sed "s/,/\n/g" | head -n 1`
        bin/kafka-topics.sh --create --zookeeper ${zookeeper} --replication-factor 1 --partitions 1 --topic ${KAFKA_TOPICS}
    fi
fi
exec tail -f logs/*.log
