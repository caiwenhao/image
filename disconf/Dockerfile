FROM openjdk:8-jre-alpine

VOLUME [ "/data" ]
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
