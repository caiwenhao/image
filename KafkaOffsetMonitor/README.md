
```
java -cp KafkaOffsetMonitor-assembly-0.2.1.jar \
     com.quantifind.kafka.offsetapp.OffsetGetterWeb \
     --offsetStorage kafka
     --zk zk-server1,zk-server2 \
     --port 8080 \
     --refresh 10.seconds \
     --retain 2.days
```
