FROM reg.lifesense.com/lifesense/tomcat:8.0-jdk8-alpine

VOLUME [ "/data" ]
EXPOSE 8080
ADD disconf-web.war html /tmp/
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN \
    chmod 755 /docker-entrypoint.sh \
    && mv /docker-entrypoint.sh /usr/local/bin \
    && cd /usr/local/tomcat/webapps/ROOT \
    && rm -rf * \
    && jar -xvf /tmp/disconf-web.war \
    && rm -f /tmp/disconf-web.war \
    && cd / 
CMD [ "docker-entrypoint.sh" ]