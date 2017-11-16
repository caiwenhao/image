FROM centos:latest
MAINTAINER mikemckibben@gmail.com

ARG release=1.8.0_131
ARG release_major=8u131
ARG release_minor=b11
ARG release_key=d54c1d3a095b4ff2b6607d096fa80163
ARG base_url=http://download.oracle.com/otn-pub/java/
ARG jdk_download_url=${base_url}jdk/${release_major}-${release_minor}/${release_key}/jdk-${release_major}-linux-x64.rpm
ARG jce_policy_download_url=${base_url}jce/8/jce_policy-8.zip

ENV LC_ALL=en_US.UTF-8 \
    JAVA_HOME=/usr/java/jdk${release}

RUN yum -y install curl wget tar zip unzip ca-certificates libgcc libstdc++ tzdata-java zlib

RUN wget -q -O /tmp/jdk.rpm --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "$jdk_download_url" \
    && rpm -iv /tmp/jdk.rpm \
    && rm /tmp/jdk.rpm

RUN wget -q -O /tmp/jce_policy.zip --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "$jce_policy_download_url" \
    && unzip -oj -d ${JAVA_HOME}/jre/lib/security /tmp/jce_policy.zip \*/\*.jar \
    && rm /tmp/jce_policy.zip \
    && echo LANG=en_US.UTF-8 > /etc/sysconfig/i18n

ENV PATH=${JAVA_HOME}/bin:$PATH