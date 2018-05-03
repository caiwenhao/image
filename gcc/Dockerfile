FROM reg.lifesense.com/lifesense/jdk:1.8.0-centos7
MAINTAINER caiwenhao

RUN yum install wget tar bzip2 gcc-c++ -y
RUN cd /tmp && wget http://ftp.gnu.org/gnu/gcc/gcc-4.8.0/gcc-4.8.0.tar.bz2 \
    && tar xf gcc-4.8.0.tar.bz2 && cd gcc-4.8.0 && ./contrib/download_prerequisites \
    && cd .. && mkdir gcc-build-4.8.0 \
    && cd gcc-build-4.8.0 && ../gcc-4.8.0/configure --enable-checking=release --enable-languages=c,c++ --disable-multilib \
    && make -j10 \
    && make install \
    && update-alternatives --install /usr/bin/gcc gcc /usr/local/bin/i686-pc-linux-gnu-gcc 40 \
    && rm -rf /tmp/*
