FROM        alpine:latest
MAINTAINER Patrick "Phreakazoid" Eichmann <phreakazoid@phreakazoid.com>

ARG TZ="Europe/Berlin"

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Build-date:- ${BUILD_DATE}"

# install s6 supervisor, verifying its authenticity via instructions at:
# https://github.com/just-containers/s6-overlay#verifying-downloads
ENV S6_VERSION 1.17.1.2
RUN cd /tmp \
    && wget https://github.com/just-containers/s6-overlay/releases/download/v$S6_VERSION/s6-overlay-amd64.tar.gz \
    && wget https://github.com/just-containers/s6-overlay/releases/download/v$S6_VERSION/s6-overlay-amd64.tar.gz.sig \
    && apk --update --no-progress add --virtual gpg gnupg \
    && gpg --keyserver pgp.mit.edu --recv-key 0x337EE704693C17EF \
    && gpg --verify /tmp/s6-overlay-amd64.tar.gz.sig /tmp/s6-overlay-amd64.tar.gz \
    && tar xzf s6-overlay-amd64.tar.gz -C / \
    && apk del gpg \
    && rm -rf /tmp/s6-overlay-amd64.tar.gz /tmp/s6-overlay-amd64.tar.gz.sig /root/.gnupg /var/cache/apk/*

RUN apk update && apk upgrade
RUN apk add --no-cache gcc musl-dev wget unzip
#RUN apt-get update && apt-get install -y libbind-dev libssl-dev libkrb5-dev

# DOWNLOAD BIND9
RUN wget -O /tmp/bind-9.9.9-P8.tar.gz ftp://ftp.isc.org/isc/bind/9.9.9-P8/BIND9.9.9-P8.x64.zip && \
   unzip /tmp/BIND9.9.9-P8.x64.zip /tmp
# COMPILE & MAKE
RUN /tmp/BIND9.9.9-P8.x64/configure --prefix /data/bind9 --enable-shared \
                       --enable-static --with-openssl=/usr \ 
                       --with-gssapi=/usr/include/gssapi --with-libtool \
                       --with-dlopen=yes --enable-threads \
                       --enable-largefile --with-gnu-ld --enable-ipv6 \
                       CFLAGS=-fno-strict-aliasing CFLAGS=-DDIG_SIGCHASE \
                       CFLAGS=-O2
RUN make && make install

#RUN apt-get clean && \
#      apt-get autoremove --purge -y && \
#      rm -rf /var/lib/apt/lists/* \

### TO BE CONTINUED 


VOLUME /data
# USE HOST NETWORKING
#EXPOSE 53 88 135 137 138 139 389 445 464 636 3268 3269
