# docker-samba-dc
Docker Samba Domain Controller on RPI with BIND9 for DNS

ALPHA

##### RPI 1+2+3: phreakazoid/samba-dc:bind-arm
##### RPI 1+2+3: phreakazoid/samba-dc:samba-arm

##### X64 Latest Debian/Samba/Bind: phreakazoid/samba-dc:bind-x64
##### X64 Latest Debian/Samba/Bind: phreakazoid/samba-dc:samba-x64

docker run -d \
 --restart=always \
 --net="host" \
 -v /opt/Samba-DC:/data \
 --name Samba-DC \
 phreakazoid/rpi-samba-dc
