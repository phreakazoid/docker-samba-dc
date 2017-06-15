# docker-rpi-samba-dc
Docker Samba Domain Controller on RPI with BIND9 for DNS

ALPHA

docker run -d \
 --restart=always \
 --net="host" \
 -v /opt/Samba-DC:/data \
 --name Samba-DC \
 phreakazoid/rpi-samba-dc
