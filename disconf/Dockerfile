FROM reg.lifesense.com/library/tomcat:8.0-jdk8-alpine

VOLUME [ "/data" ]
EXPOSE 8080
ADD /data/tmp/war/disconf-web.war /usr/local/tomcat/webapps/ROOT
ADD /data/tmp/war/html /tmp/html
ADD docker-entrypoint.sh
RUN \
    chmod 755 docker-entrypoint.sh \
    && mv docker-entrypoint.sh /usr/local/bin \
    && cd / 
ENTRYPOINT ["docker-entrypoint.sh"]
