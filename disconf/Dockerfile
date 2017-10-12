FROM centos:7
MAINTAINER caiwenhao, 77749770@qq.com

# Docker Build Arguments, For further upgrade
ARG DISCONF_VERSION 2.6.36

RUN set -x \
    && rm -rf /usr/local/tomcat/webapps/* \
    && mkdir -p /usr/local/tomcat/webapps/ROOT

ENV DISCONF_TGZ_URL https://github.com/knightliao/disconf/archive/"$DISCONF_VERSION".tar.gz
ENV ONLINE_CONFIG_PATH /tmp/disconf-2.6.36/disconf-web/profile
ENV WAR_ROOT_PATH /usr/local/tomcat/webapps/ROOT
WORKDIR /tmp/
RUN set -x \
	\
	&& wget -O tomcat.tar.gz "$DISCONF_TGZ_URL" \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm tomcat.tar.gz* \
    && cp /tmp/disconf-2.6.36/disconf-web/profile/application-demo.properties /tmp/disconf-2.6.36/disconf-web/profile/application.properties \
    && cd disconf-"$DISCONF_VERSION"/disconf-web/ \
    && sh deploy/deploy.sh

ADD docker-entrypoint.sh docker-entrypoint.sh
RUN \
    chmod 755 docker-entrypoint.sh \
    && mv docker-entrypoint.sh /usr/local/bin \
    && cd / \
    && rm -rf /tmp/* \
