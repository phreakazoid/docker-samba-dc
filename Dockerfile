FROM debian:stretch-slim
MAINTAINER Patrick Eichmann <phreakazoid@phreakazoid.com>

ARG TZ="Europe/Berlin"
ARG DEBIAN_FRONTEND=noninteractive

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Build-date:- ${BUILD_DATE}"

RUN apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates \
	curl \
	gcc \
	&& rm -rf /var/lib/apt/lists/*

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
RUN make -C /tmp/bind-9.9.9-P8.x64 && make install -C /tmp/bind-9.9.9-P8x64

#RUN apt-get clean && \
#      apt-get autoremove --purge -y && \
#      rm -rf /var/lib/apt/lists/* \

### TO BE CONTINUED 


VOLUME /data
# USE HOST NETWORKING
#EXPOSE 53 88 135 137 138 139 389 445 464 636 3268 3269
