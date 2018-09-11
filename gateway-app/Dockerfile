FROM openresty/openresty:centos

RUN opm install sumory/lor \
    && opm install agentzh/lua-resty-http \ 
    && opm install GUI/lua-resty-mail \
    && opm install jprjr/lua-resty-exec \
    && opm install openresty/lua-resty-lrucache \
    && opm install p0pr0ck5/lua-resty-logger-socket


ADD ./gateway-app.tar.gz /opt/
RUN chmod +x /opt/gateway-app/start.sh \
    && mkdir -p /opt/gateway-app/logs

ENV LANG en_US.UTF-8
ENV RES_OPTIONS "timeout:1 attempts:1 ndots:2"
WORKDIR /opt/gateway-app
EXPOSE 80
EXPOSE 8000

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone

CMD ["start.sh"]