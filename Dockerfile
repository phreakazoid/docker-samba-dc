FROM        resin/rpi-raspbian:latest

MAINTAINER Patrick "Phreakazoid" Eichmann <phreakazoid@phreakazoid.com>

RUN     apt-get update && apt-get install -y libbind-dev libssl-dev libkrb5-dev bind9

#EXPOSE      3142
