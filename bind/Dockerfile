FROM resin/rpi-raspbian:stretch
MAINTAINER Patrick Eichmann <phreakazoid@phreakazoid.com>

ARG TZ="Europe/Berlin"
ARG DEBIAN_FRONTEND=noninteractive

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BIND-Version="9.11.2"
LABEL build_version="Build-date:- ${BUILD_DATE}"

RUN [ "cross-build-start" ]

# BIND9
# NEEDED PACKAGES
RUN apt-get update && apt-get install -y wget gcc make build-essential libssl1.0-dev libkrb5-dev
# DOWNLOAD
RUN wget -O /tmp/bind-9.11.2.tar.gz ftp://ftp.isc.org/isc/bind/9.11.2/bind-9.11.2.tar.gz && \
    tar -xf /tmp/bind-9.11.2.tar.gz -C /tmp
# COMPILE & MAKE
RUN cd /tmp/bind-9.11.2 && ./configure --prefix /usr/local/bind9 --enable-shared \
                       --enable-static --with-openssl=/usr \ 
                       --with-gssapi=/usr/include/gssapi --with-libtool \
                       --with-dlopen=yes --enable-threads \
                       --enable-largefile --with-gnu-ld --enable-ipv6 \
                       CFLAGS=-fno-strict-aliasing CFLAGS=-DDIG_SIGCHASE \
                       CFLAGS=-O2
RUN make -C /tmp/bind-9.11.2
RUN make install -C /tmp/bind-9.11.2
RUN sed 's#^\(export PATH\)$#PATH="/usr/local/bind9/sbin:/usr/local/bind9/bin:$PATH"\n\1#' /etc/profile
# COPY NAMED.CONF
COPY named.conf /usr/local/bind9/etc

### CLEANUP ###
RUN apt-get purge -y gcc* make* build-essential*
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /entrypoint.sh

RUN [ "cross-build-end" ]

VOLUME ["/usr/local/bind9/etc"]
# USE HOST NETWORKING
#EXPOSE 53

ENTRYPOINT ["/entrypoint.sh"]
# START BIND9
CMD ["/usr/local/bind9/sbin/named"]
