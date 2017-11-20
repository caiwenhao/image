FROM reg.lifesense.com/lifesense/jdk:1.8.0-centos7
LABEL maintainer "caiwenhao <77749770@qq.com>"


# Install Tomcat
ENV CATALINA_HOME /opt/tomcat 
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.23

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

RUN wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
 tar -xvf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
 rm apache-tomcat*.tar.gz && \
 mv apache-tomcat* ${CATALINA_HOME}

RUN chmod +x ${CATALINA_HOME}/bin/*sh

# Create Tomcat admin user
ADD create_admin_user.sh $CATALINA_HOME/scripts/create_admin_user.sh
ADD tomcat.sh $CATALINA_HOME/scripts/tomcat.sh
ADD server.xml $CATALINA_HOME/conf/server.xml
RUN chmod +x $CATALINA_HOME/scripts/*.sh

# Create tomcat user
RUN groupadd -r tomcat && \
 useradd -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin  -c "Tomcat user" tomcat && \
 chown -R tomcat:tomcat ${CATALINA_HOME}

WORKDIR /opt/tomcat

EXPOSE 8080
EXPOSE 8009

USER tomcat
CMD ["tomcat.sh"]