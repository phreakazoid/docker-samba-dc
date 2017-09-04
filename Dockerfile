FROM resin/rpi-raspbian:stretch
MAINTAINER Patrick Eichmann <phreakazoid@phreakazoid.com>

ARG TZ="Europe/Berlin"
ARG DEBIAN_FRONTEND=noninteractive

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SAMBA-Version=""
ARG BIND-Version="9.9.9-P8"
LABEL build_version="Build-date:- ${BUILD_DATE}"

RUN [ "cross-build-start" ]

RUN apt-get update && apt-get install -y wget gcc make build-essential openssl libssl-dev libkrb5-dev

# DOWNLOAD BIND9
RUN wget -O /tmp/bind-9.9.9-P8.tar.gz ftp://ftp.isc.org/isc/bind/9.9.9-P8/bind-9.9.9-P8.tar.gz && \
    tar -xvf /tmp/bind-9.9.9-P8.tar.gz -C /tmp
# COMPILE & MAKE
RUN /tmp/bind-9.9.9-P8/configure --prefix /usr/local/bind9 --enable-shared \
                       --enable-static --with-openssl=/usr \ 
                       --with-gssapi=/usr/include/gssapi --with-libtool \
                       --with-dlopen=yes --enable-threads \
                       --enable-largefile --with-gnu-ld --enable-ipv6 \
                       CFLAGS=-fno-strict-aliasing CFLAGS=-DDIG_SIGCHASE \
                       CFLAGS=-O2
RUN make -C /tmp/bind-9.9.9-P8
RUN make install -C /tmp/bind-9.9.9-P8
#RUN make --directory /tmp/bind-9.9.9-P8
#RUN make install --directory /tmp/bind-9.9.9-P8

#RUN sed 's#^\(export PATH\)$#PATH="/usr/local/bind9/sbin:/usr/local/bind9/bin:$PATH"\n\1#' /etc/profile

### CLEANUP ###
RUN apt-get purge -y gcc* make* 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN [ "cross-build-end" ]

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN [ "cross-build-end" ]

VOLUME ["/usr/local/samba/etc", "/usr/local/samba/private", "/usr/local/samba/var", "/usr/local/bind9/etc"]
# USE HOST NETWORKING
#EXPOSE 53 88 135 137 138 139 389 445 464 636 3268 3269

ENTRYPOINT ["/entrypoint.sh"]
# START BIND9
CMD ["/usr/local/bind9/sbin/named"]
# START SAMBA
#CMD ["/usr/local/samba/sbin/smbd, "-D", "--option=server role check:inhibit=yes", "--foreground"]
#CMD ["/usr/local/samba/sbin/winbindd", "-D", "--option=server role check:inhibit=yes", "--foreground"]

