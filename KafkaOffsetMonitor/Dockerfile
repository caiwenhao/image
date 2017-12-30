FROM openjdk:8-jre-alpine
MAINTAINER wenhao.cai 77749770@qq.com

# Install required packages
RUN apk add --no-cache \
    bash \
    su-exec

ARG DISTRO_NAME=0.2.1

# Download Apache Zookeeper, verify its PGP signature, untar and clean up
RUN set -ex; \
    wget -q "https://github.com/quantifind/KafkaOffsetMonitor/releases/download/v${DISTRO_NAME}/KafkaOffsetMonitor-assembly-${DISTRO_NAME}.jar"; \
    mkdir -p /opt/ ; \
    mv KafkaOffsetMonitor-assembly-${DISTRO_NAME}.jar /opt/

WORKDIR /opt

EXPOSE 8080
