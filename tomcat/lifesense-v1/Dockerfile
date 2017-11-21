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
	mv apache-tomcat* ${CATALINA_HOME} && \
	rm -rf $CATALINA_HOME//webapps/docs && \
	rm -rf $CATALINA_HOME//webapps/examples && \
	rm -rf $CATALINA_HOME//webapps/host-manager

# Add EPEL repositories
RUN yum -y install epel-release

# Install yum
RUN yum -y clean all && \
	yum -y install tomcat-native

# Create Tomcat admin user
ADD create_admin_user.sh $CATALINA_HOME/scripts/create_admin_user.sh
ADD tomcat.sh $CATALINA_HOME/scripts/tomcat.sh
ADD server.xml $CATALINA_HOME/conf/server.xml
ADD catalina.properties $CATALINA_HOME/conf/catalina.properties
RUN chmod +x $CATALINA_HOME/scripts/*.sh && chmod +x ${CATALINA_HOME}/bin/*sh

# 
RUN mkdir -p /data/apps/deps/jdk1.8/bin/ && \
	ln -s $JAVA_HOME/bin/jstack /data/apps/deps/jdk1.8/bin/jstack

WORKDIR /opt/tomcat

EXPOSE 8080
EXPOSE 8009

CMD ["$CATALINA_HOME/scripts/tomcat.sh"]