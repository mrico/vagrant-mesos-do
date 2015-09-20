#!/usr/bin/env bash

cp /etc/hosts /etc/hosts.orig
grep -v "127.0.1.1" /etc/hosts.orig > /etc/hosts

### Firewall

ufw allow ssh
ufw allow http
# Allow access from private network
ufw allow from 10.135.0.0/16
ufw --force enable

wget https://raw.githubusercontent.com/mesosphere/marathon/v0.10.1/bin/haproxy-marathon-bridge

chmod 751 haproxy-marathon-bridge
mv haproxy-marathon-bridge /usr/local/bin


/usr/local/bin/haproxy-marathon-bridge install_haproxy_system mesos-worker-1:8080 mesos-worker-2:8080
