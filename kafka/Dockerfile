FROM openjdk:8-jdk-alpine

# Install required packages
RUN apk add --no-cache \
    bash \
    su-exec

ENV KAFKA_USER=kafka \
    KAFKA_DATA_DIR=/var/lib/kafka/data \
    KAFKA_HOME=/opt/kafka \
    PATH=$PATH:/opt/kafka/bin

ARG KAFKA_VERSION=0.10.2.1
ARG KAFKA_DIST=kafka_2.11-0.10.2.1

# Add a user and make dirs
RUN set -ex; \
    adduser -D "$KAFKA_USER"; \
    mkdir -p /opt ; \
    chown -R "$KAFKA_USER:$KAFKA_USER" /opt

RUN set -ex; \
    apk add --no-cache --virtual .build-deps \
    gnupg; \
    wget -q "http://www.apache.org/dist/kafka/$KAFKA_VERSION/$KAFKA_DIST.tgz"; \
    wget -q "http://www.apache.org/dist/kafka/$KAFKA_VERSION/$KAFKA_DIST.tgz.asc"; \
    wget -q "http://kafka.apache.org/KEYS"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --import KEYS; \
    gpg --batch --verify "$KAFKA_DIST.tgz.asc" "$KAFKA_DIST.tgz"; \
    tar -xzf "$KAFKA_DIST.tgz" -C /opt ; \
    rm -r "$GNUPGHOME" "$KAFKA_DIST.tgz" "$KAFKA_DIST.tgz.asc"; \
    apk del .build-deps
    
COPY log4j.properties /opt/$KAFKA_DIST/config/


RUN set -x \
    && ln -s /opt/$KAFKA_DIST $KAFKA_HOME \
    && [ `id -u $KAFKA_USER` -eq 1000 ] \
    && [ `id -g $KAFKA_USER` -eq 1000 ] \
    && mkdir -p $KAFKA_DATA_DIR \
    && chown -R "$KAFKA_USER:$KAFKA_USER"  /opt/  \
    && chown -R "$KAFKA_USER:$KAFKA_USER"  $KAFKA_DATA_DIR \
    && cd $KAFKA_HOME

WORKDIR $KAFKA_HOME