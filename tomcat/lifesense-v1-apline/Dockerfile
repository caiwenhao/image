FROM reg.lifesense.com/lifesense/tomcat:8.0-jdk8-alpine
LABEL maintainer "caiwenhao <77749770@qq.com>"

ENV TINGYUN="" \
    DISCONF_ENV="" \
	DISCONF_HOST="" \
	JVM_LEVEL="" \
	JVM_OPTS="false" \
	JVM_Xms="" \
	JVM_Xmx="" \
	JVM_Xmn="" \
	JVM_Xss="" \
	TOMCAT_acceptCount="" \
	TOMCAT_maxThreads="" \
	TOMCAT_minSpareThreads="" \
	JAVA_OPTS=""

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY server.xml /usr/local/tomcat/conf/server.xml

RUN chmod 755 /docker-entrypoint.sh \
    && cd / 
CMD [ "docker-entrypoint.sh" ]