FROM resin/rpi-raspbian:stretch
MAINTAINER Patrick Eichmann <phreakazoid@phreakazoid.com>

ARG TZ="Europe/Berlin"
ARG DEBIAN_FRONTEND=noninteractive

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SAMBA-Version="4.7.0rc5"
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
COPY /bind/named.conf /usr/local/bind9/etc

# SAMBA
# NEEDED PACKAGES
RUN apt-get -y install ntp libacl1-dev python-dev cups\
    libldap2-dev pkg-config gdb libgnutls28-dev libblkid-dev\
    libreadline-dev libattr1-dev python-dnspython libpopt-dev\
    libbsd-dev attr docbook-xsl libcups2-dev krb5-user git
    
RUN git clone git://git.samba.org/samba.git /tmp/samba4/ && cd /tmp/samba4 && git checkout tags/samba-4.7.0rc5
RUN cd /tmp/samba4 && ./configure --enable-debug
RUN make -C /tmp/samba4
RUN make install -C /tmp/samba4

### CLEANUP ###
RUN apt-get purge -y gcc* make* 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN [ "cross-build-end" ]

COPY entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh

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
