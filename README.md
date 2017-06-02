# kafka

    docker run -d --name kafka 
    
    

```
version: '2'
services:
    kafka01:
        image: daocloud.io/buxiaomo/kafka
        ports:
            - 9092/tcp
        environment:
            - BROKER_ID=1
            - ZOOKEEPER_CLUSTER=zookeeper01:2181,zookeeper02:2181,zookeeper03:2181
        networks:
            evm_pord:
                aliases:
                    - kafka01
    kafka02:
        image: daocloud.io/buxiaomo/kafka
        ports:
            - 9092/tcp
        environment:
            - BROKER_ID=2
            - ZOOKEEPER_CLUSTER=zookeeper01:2181,zookeeper02:2181,zookeeper03:2181
        networks:
            evm_pord:
                aliases:
                    - kafka02
    kafka03:
        image: daocloud.io/buxiaomo/kafka
        ports:
            - 9092/tcp
        environment:
            - BROKER_ID=3
            - ZOOKEEPER_CLUSTER=zookeeper01:2181,zookeeper02:2181,zookeeper03:2181
        networks:
            evm_pord:
                aliases:
                    - kafka03
```
