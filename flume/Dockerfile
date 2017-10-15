FROM openjdk:8-jre-alpine

ARG FL_VERSION=1.6.0
ARG FL_MIRROR=http://www-eu.apache.org/dist/
ENV FLUME_USER=flume \
    FLUME_HOME=/opt/flume
LABEL name="flume" flume-version=$FL_VERSION

# Install required packages
RUN apk add --no-cache \
    bash \
    su-exec

# Flume download
RUN set -ex; \
    apk add --no-cache --virtual .build-deps \
    gnupg; \
    curl -L ${FL_MIRROR}/flume/${FL_VERSION}/apache-flume-${FL_VERSION}-bin.tar.gz -o /tmp/apache-flume-${FL_VERSION}-bin.tar.gz && \ 
    curl -L https://www.apache.org/dist/flume/KEYS -o /tmp/KEYS && \ 
    curl -L https://www.apache.org/dist/flume/${FL_VERSION}/apache-flume-${FL_VERSION}-bin.tar.gz.asc -o /tmp/apache-flume-${FL_VERSION}-bin.tar.gz.asc && \
    curl -L https://www.apache.org/dist/flume/${FL_VERSION}/apache-flume-${FL_VERSION}-bin.tar.gz.md5 -o /tmp/apache-flume-${FL_VERSION}-bin.tar.gz.md5 && \
    # Verify download
    # Fix wrong MD5 file...
    sed -i "s/$/  apache-flume-${FL_VERSION}-bin.tar.gz/" /tmp/apache-flume-${FL_VERSION}-bin.tar.gz.md5 && \
    cd /tmp && \
    md5sum -c --quiet apache-flume-${FL_VERSION}-bin.tar.gz.md5 && \
    cd - && \
    gpg --import /tmp/KEYS && \
    gpg --verify /tmp/apache-flume-${FL_VERSION}-bin.tar.gz.asc && \
    # Install 
    tar xvzf /tmp/apache-flume-${FL_VERSION}-bin.tar.gz -C /opt && \
    mv /opt/apache-flume-${FL_VERSION}-bin $FLUME_HOME && \
    rm -f /tmp/apache-flume-* && \
    rm -f /tmp/KEYS && \
    adduser -D "$FLUME_USER" && \
    chown -R "$FLUME_USER:$FLUME_USER" /opt/

ADD files/flume.conf $FLUME_HOME/flume.conf

EXPOSE 1234

WORKDIR $FLUME_HOME 

ENTRYPOINT ["bin/flume-ng", "agent"]
CMD ["-n", "agent", "-c", "conf", "-f", "flume.conf", "-Dflume.root.logger=INFO,console"]