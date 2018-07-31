FROM graylog/graylog:2.4.6-1
RUN curl -L http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz -o /tmp/GeoLite2-City.tar.gz && \
    mkdir -p /etc/graylog/server/ && \
    tar xvzf /tmp/GeoLite2-City.tar.gz -C /etc/graylog/server/