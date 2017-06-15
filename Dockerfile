FROM        resin/rpi-raspbian:latest
MAINTAINER Patrick "Phreakazoid" Eichmann <phreakazoid@phreakazoid.com>

ARG TZ="Europe/Berlin"

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Build-date:- ${BUILD_DATE}"

RUN [ "cross-build-start" ]

RUN apt-get update && apt-get install -y libbind-dev libssl-dev libkrb5-dev bind9

# DOWNLOAD BIND9
RUN cd /usr/src \
    wget ftp://ftp.isc.org/isc/bind/9.9.9-P8/bind-9.9.9-P8.tar.gz \
    tar -xvf bind-9.9.9-P8.tar.gz \
    cd bind-9.9.9-P8
# CONFIG / COMPILE BIND9
RUN ./configure --prefix /data/bind9 --enable-shared \
    --enable-static --with-openssl=/usr \ 
    --with-gssapi=/usr/include/gssapi --with-libtool \
    --with-dlopen=yes --enable-threads \
    --enable-largefile --with-gnu-ld --enable-ipv6 \
    CFLAGS=-fno-strict-aliasing CFLAGS=-DDIG_SIGCHASE \
    CFLAGS=-O2
RUN make && make install

RUN [ "cross-build-end" ]


VOLUME /data
# USE HOST NETWORKING
#EXPOSE 53 88 135 137 138 139 389 445 464 636 3268 3269
