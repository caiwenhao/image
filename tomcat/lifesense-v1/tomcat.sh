#!/bin/bash

#gc优化
JAVA_GC="-XX:SurvivorRatio=10 -XX:MaxTenuringThreshold=15 -XX:NewRatio=2 -XX:+DisableExplicitGC -Djava.security.egd=file:/dev/./urandom"

#扩展参数
if [[ "X${JAVA_OPTS}" != "X" ]]; then
    JAVA_OPTS="${JAVA_OPTS}"
fi

#环境
if [[ "X${DISCONF_ENV}" != "X" ]]; then
    JAVA_OPTS="${JAVA_OPTS} -Ddisconf.env=${DISCONF_ENV}"
fi

#根据环境预置变量
if [ "$DISCONF_ENV" = 'online' ] ; then
    if [[ "X${DISCONF_HOST}" == "X" ]]; then
        DISCONF_HOST="disconf.lifesense.com:80"
    fi
    if [[ "${JVM_OPTS}" == "false" ]]; then
        JVM_LEVEL="info"
        JVM_Xms="100m"
        JVM_Xmx="2048m"
        JVM_Xmn="600m"
        JVM_Xss="256k"
        TOMCAT_acceptCount=4096
        TOMCAT_maxThreads=512
        TOMCAT_minSpareThreads=512      
    fi
    TINGYUN="true"
else
    if [[ "X${DISCONF_HOST}" == "X" ]]; then
        DISCONF_HOST="disconf.lifesense.com:80"
    fi
    if [[ "${JVM_OPTS}" == "false" ]]; then
        JVM_LEVEL="debug"
        JVM_Xms="100m"
        JVM_Xmx="1024m"
        JVM_Xmn="300m"
        JVM_Xss="256k"
        TOMCAT_acceptCount=4096
        TOMCAT_maxThreads=125
        TOMCAT_minSpareThreads=125         
    fi
fi

#听云
if [[ "${TINGYUN}" == "true" ]]; then
    JAVA_OPTS="${JAVA_OPTS} -javaagent:${CATALINA_HOME}/tingyun/tingyun-agent-java.jar"
    app_name=$(hostname|awk -F- '{print $1"-"$3}')
    sed -i "s/Java Application/${app_name}/" /opt/tomcat/tingyun/tingyun.properties
fi

#日志级别
if [[ "X${JVM_LEVEL}" != "X" ]]; then
    JAVA_OPTS="${JAVA_OPTS} -Dlog.level=${JVM_LEVEL}"
fi

#disconf服务器
if [[ "X${DISCONF_HOST}" != "X" ]]; then
    JAVA_OPTS="${JAVA_OPTS} -Dconf_server_host=${DISCONF_HOST}"
fi

#内存参数
if [[ "X${JVM_Xms}" != "X" ]]; then
    JAVA_OPTS="${JAVA_OPTS} -Xms${JVM_Xms}"
fi
if [[ "X${JVM_Xmx}" != "X" ]]; then
    JAVA_OPTS="${JAVA_OPTS} -Xmx${JVM_Xmx}"
fi
if [[ "X${JVM_Xmn}" != "X" ]]; then
    JAVA_OPTS="${JAVA_OPTS} -Xmn${JVM_Xmn}"
fi
if [[ "X${JVM_Xss}" != "X" ]]; then
    JAVA_OPTS="${JAVA_OPTS} -Xss${JVM_Xss}"
fi

#输出汇总JAVA_OPTS
export JAVA_OPTS="-server -Duser.timezone=Asia/Shanghai -Dfile.encoding=UTF-8 -Dops.hostname=$HOSTNAME $JAVA_OPTS $JAVA_GC"

#tomcat参数
if [[ "X${TOMCAT_acceptCount}" != "X" ]]; then
    sed -i "/acceptCount/ s/4096/${TOMCAT_acceptCount}/g"  ${CATALINA_HOME}/conf/server.xml  
fi
if [[ "X${TOMCAT_maxThreads}" != "X" ]]; then
    sed -i "/maxThreads/ s/512/${TOMCAT_maxThreads}/g"  ${CATALINA_HOME}/conf/server.xml  
fi
if [[ "X${TOMCAT_minSpareThreads}" != "X" ]]; then
    sed -i "/minSpareThreads/ s/30/${TOMCAT_minSpareThreads}/g"  ${CATALINA_HOME}/conf/server.xml  
fi

#运行
if [ ! -f ${CATALINA_HOME}/scripts/.tomcat_admin_created ]; then
	${CATALINA_HOME}/scripts/create_admin_user.sh
fi
		
exec catalina.sh run