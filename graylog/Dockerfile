FROM graylog/graylog:2.4.6-1
RUN curl -L http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz -o /tmp/GeoLite2-City.tar.gz && \
    mkdir -p /etc/graylog/server/ && \
    tar xvzf /tmp/GeoLite2-City.tar.gz -C /etc/graylog/server/
#告警条件插件    
RUN curl -L https://github.com/alcampos/graylog-plugin-alert-conditional-count/releases/download/0.0.2/graylog-plugin-alert-conditional-count-0.0.1.jar -o /usr/share/graylog/plugin/graylog-plugin-alert-conditional-count-0.0.1.jar && \
    curl -L https://github.com/cvtienhoven/graylog-plugin-aggregates/releases/download/2.2.4/graylog-plugin-aggregates-2.2.4.jar -o /usr/share/graylog/plugin/graylog-plugin-aggregates-2.2.4.jar && \
    curl -L https://github.com/alcampos/graylog-plugin-alert-condition-delorean/releases/download/v0.0.2/graylog-plugin-alert-condition-delorean-0.0.2.jar -o /usr/share/graylog/plugin/graylog-plugin-alert-condition-delorean-0.0.2.jar