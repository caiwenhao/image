FROM reg.lifesense.com/lifesense/jdk:1.8.0-centos7
LABEL maintainer "caiwenhao <77749770@qq.com>"


# Install Tomcat
ENV CATALINA_HOME /opt/tomcat 
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.47

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


RUN yum install -y apr-devel openssl-devel
ENV APR_VERSION 1.6.3
ENV TC_NATIVE 1.2.14
RUN wget http://mirror.linux-ia64.org/apache/apr/apr-$APR_VERSION.tar.gz \
  && tar -zxvf apr-$APR_VERSION.tar.gz \
  && cd apr-$APR_VERSION \
  && ./configure \
  && make \
  && make install \
  && cd .. \
  && rm -rf apr-$APR_VERSION.tar.gz \
  && rm -rf apr-$APR_VERSION

# Create Tomcat admin user
ADD create_admin_user.sh $CATALINA_HOME/scripts/create_admin_user.sh
ADD tomcat.sh $CATALINA_HOME/scripts/tomcat.sh
ADD server.xml $CATALINA_HOME/conf/server.xml
RUN chmod +x $CATALINA_HOME/scripts/*.sh && chmod +x ${CATALINA_HOME}/bin/*sh

WORKDIR /opt/tomcat

EXPOSE 8080
EXPOSE 8009

CMD ["$CATALINA_HOME/scripts/tomcat.sh"]