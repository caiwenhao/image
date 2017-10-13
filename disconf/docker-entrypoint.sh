#!/bin/bash
DISCONF_CONF="/usr/local/tomcat/webapps/ROOT/WEB-INF/classes"

if [[ "X${DISCONF_DOAMIN}" != "X" ]]; then
    sed -i "s/^domain=*$/domain=${DISCONF_DOAMIN}/" ${DISCONF_CONF}/application.properties

fi
#mail 
if [[ "X${EMAIL_MONITOR_ON}" != "X" ]]; then
    sed -i "s/^EMAIL_HOST =*$/EMAIL_HOST =${EMAIL_HOST}/" ${DISCONF_CONF}/application.properties
    sed -i "s/^EMAIL_HOST_PASSWORD =*$/EMAIL_HOST_PASSWORD =${EMAIL_HOST_PASSWORD}/" ${DISCONF_CONF}/application.properties
    sed -i "s/^EMAIL_HOST_USER =*$/EMAIL_HOST_USER =${EMAIL_HOST_USER}/" ${DISCONF_CONF}/application.properties
    sed -i "s/^EMAIL_PORT =*$/EMAIL_PORT =${EMAIL_PORT}/" ${DISCONF_CONF}/application.properties
    sed -i "s/^DEFAULT_FROM_EMAIL =*$/DEFAULT_FROM_EMAIL =${DEFAULT_FROM_EMAIL}/" ${DISCONF_CONF}/application.properties
fi
#mysql
if [[ "X${DB_HOST}" != "X" ]]; then
    sed -i "s/127.0.0.1:3306/${DB_HOST}:${DB_PORT}/" ${DISCONF_CONF}/jdbc-mysql.properties
    sed -i "s/^jdbc.db_0.username=*$/jdbc.db_0.username=${DB_USER}/" ${DISCONF_CONF}/jdbc-mysql.properties
    sed -i "s/^jdbc.db_0.password=$/jdbc.db_0.password=${DB_PASSWD}/" ${DISCONF_CONF}/jdbc-mysql.properties
fi

#redis
if [[ "X${REDIS_HOST1}" != "X" ]]; then
    sed -i "s/^redis.group1.client1.host=*$/redis.group1.client1.host=${REDIS_HOST1}/" ${DISCONF_CONF}/redis-config.properties
    sed -i "s/^redis.group1.client1.port=*$/redis.group1.client1.port=${REDIS_PORT1}/" ${DISCONF_CONF}/redis-config.properties
    sed -i "s/^redis.group1.client1.password=*$/redis.group1.client1.password=${REDIS_PASSWD1}/" ${DISCONF_CONF}/redis-config.properties
fi
if [[ "X${REDIS_HOST2}" != "X" ]]; then
    sed -i "s/^redis.group1.client2.host=*$/redis.group1.client2.host=${REDIS_HOST2}/" ${DISCONF_CONF}/redis-config.properties
    sed -i "s/^redis.group1.client2.port=*$/redis.group1.client2.port=${REDIS_PORT2}/" ${DISCONF_CONF}/redis-config.properties
    sed -i "s/^redis.group1.client2.password=*$/redis.group1.client2.password=${REDIS_PASSWD2}/" ${DISCONF_CONF}/redis-config.properties
fi

#zook
if [[ "X${ZOOK_HOSTS}" != "X" ]]; then
    sed -i "s/^hosts=*$/hosts=${ZOOK_HOSTS}/" ${DISCONF_CONF}/zoo.properties
fi

#复制静态资源到共享卷
/bin/cp -a /tmp/html /data/
exec ${CATALINA_HOME}/bin/catalina.sh run
