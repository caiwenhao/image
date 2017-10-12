FROM 8.0.44-jre8-alpine
MAINTAINER caiwenhao, 77749770@qq.com


VOLUME [ "/data" ]
# Docker Build Arguments, For further upgrade
ARG DISCONF_VERSION 2.6.36
ENV DISCONF_TGZ_URL https://github.com/caiwenhao/disconf/archive/"$DISCONF_VERSION".tar.gz
ENV ONLINE_CONFIG_PATH /tmp/disconf-"$DISCONF_VERSION"/disconf-web/profile/rd
ENV WAR_ROOT_PATH /src
WORKDIR /tmp/
RUN set -x \
	&& wget -O src.tar.gz "$DISCONF_TGZ_URL" \
	&& tar -xvf src.tar.gz --strip-components=1 \
	&& rm src.tar.gz* \
    && cp /tmp/disconf-"$DISCONF_VERSION"/disconf-web/profile/rd/application-demo.properties /tmp/disconf-"$DISCONF_VERSION"/disconf-web/profile/rd/application.properties \
    && cd disconf-"$DISCONF_VERSION"/disconf-web/ \
    && sh deploy/deploy.sh

ADD docker-entrypoint.sh
RUN \
    chmod 755 docker-entrypoint.sh \
    && mv docker-entrypoint.sh /usr/local/bin \
    && cd / \
    && rm -rf /tmp/*
