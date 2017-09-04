# samba-dc
[![](https://images.microbadger.com/badges/image/phreakazoid/samba-dc.svg)](https://microbadger.com/images/phreakazoid/samba-dc "Get your own image badge on microbadger.com")![](https://img.shields.io/docker/pulls/phreakazoid/samba-dc.svg)![](https://images.microbadger.com/badges/version/phreakazoid/samba-dc.svg)
Docker Samba Domain Controller on RPI with BIND9 for DNS

##### RPI 1+2+3: phreakazoid/samba-dc:latest
##### RPI 1+2+3: phreakazoid/samba-dc:dhcpd

## docker-compose.yml

###  LATEST
```
asterisk:
  container_name: DC
  image: phreakazoid/samba-dc:latest
  restart: always
  net: host
  volumes:
    - "/etc/localtime:/etc/localtime:ro"
    - "/opt/dc-arm/samba:/usr/local/samba/etc"
    - "/opt/dc-arm/data:/usr/local/samba/private"
    - "/opt/dc-arm/samba-log:/usr/local/samba/var"
    - "/opt/dc-arm/bind9:/usr/local/bind9/etc"    
  environment:
    TZ: "Europe/Berlin"
```
