#!/usr/bin/env bash

cp /etc/hosts /etc/hosts.orig
grep -v "127.0.1.1" /etc/hosts.orig > /etc/hosts

### Firewall

ufw allow ssh
# Allow access from private network
ufw allow from 10.135.0.0/16
ufw --force enable

### Java Virtual Machine

apt-get update -y
apt-get install -y openjdk-7-jre-headless


### Zookeeper

apt-get install -y zookeeper zookeeperd


### Mesos

apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)

# Add the repository
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | \
  tee /etc/apt/sources.list.d/mesosphere.list

apt-get update -y
apt-get install mesos -y

echo "zk://zookeeper-1:2181/mesos" > /etc/mesos/zk


### Docker
sleep 2
wget -qO- https://get.docker.com/ | sh

echo 'docker,mesos' > /etc/mesos-slave/containerizers
echo '5mins' > /etc/mesos-slave/executor_registration_timeout

### Run Mesos Worker

nohup /usr/bin/mesos-init-wrapper master &
nohup /usr/bin/mesos-init-wrapper slave &

