#!/bin/bash
# 本次测试，支持Docker之外的访问访问没有问题，暂未测试Docker内部调用
# 根据环境变量判定是否让kafak支持Docker之外的服务访问
# 若需要支持Docker之外的服务访问请设置KAFKA_HOST_IP,KAFKA_PORT这两个环境变量
if [ ${KAFKA_HOST_IP} != "NULL" ] && [ ${KAFKA_PORT} != "NULL" ];then
    echo "advertised.host.name=${KAFKA_HOST_IP}" >> config/server.properties
    echo "advertised.port=${KAFKA_PORT}" >> config/server.properties
else
    IP=`hostname -i`
    sed -i "s/#advertised.listeners/advertised.listeners/g" config/server.properties
    sed -i "s/your.host.name:9092/${IP}:9092/g" config/server.properties
    echo "host.name=${IP}" >>  config/server.properties
fi
# 集群必须设置此环境变量值
if [ ${BROKER_ID} != "NULL" ];then
    sed -i "s/broker.id=.*/broker.id=${BROKER_ID}/g" config/server.properties
fi
# 设置zookeeper集群配置
if [ ${ZOOKEEPER_CLUSTER} == "localhost:2181" ];then
    bin/zookeeper-server-start.sh config/zookeeper.properties &
else
    sed -i "s/zookeeper.connect=localhost:2181/zookeeper.connect=${ZOOKEEPER_CLUSTER}/g" config/server.properties
fi
# 启动服务后是否自动创建TOPICS
if [ ${KAFKA_TOPICS} != "NULL" ];then
    echo "create.topics=${KAFKA_TOPICS}" >> config/server.properties
fi
# 配置kafka参数

echo "log.cleanup.policy = delete" >> config/server.properties
exec bin/kafka-server-start.sh config/server.properties
