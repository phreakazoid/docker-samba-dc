# docker-rpi-samba-dc
Docker Samba Domain Controller on RPI with BIND9 for DNS

ALPHA

##### RPI 1+2+3: phreakazoid/docker-samba-dc:arm
##### X64 Latest Debian/Samba/Bind: phreakazoid/docker-samba-dc:latest

docker run -d \
 --restart=always \
 --net="host" \
 -v /opt/Samba-DC:/data \
 --name Samba-DC \
 phreakazoid/rpi-samba-dc
