# tomcat编译说明

>基于8-jdk-alpine 构建的tomcat, 用于支持disconf特殊要求的应用.

```shell
docker build -t reg.lifesense.com/library/tomcat:8.0-jdk8-alpine
docker push reg.lifesense.com/library/tomcat:8.0-jdk8-alpine
```