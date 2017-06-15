FROM        resin/rpi-raspbian:latest
MAINTAINER Patrick "Phreakazoid" Eichmann <phreakazoid@phreakazoid.com>

RUN [ "cross-build-start" ]

RUN     apt-get update && apt-get install -y libbind-dev libssl-dev libkrb5-dev bind9

RUN [ "cross-build-end" ]


VOLUME /data
# USE HOST NETWORKING
#EXPOSE 53 88 135 137 138 139 389 445 464 636 3268 3269
