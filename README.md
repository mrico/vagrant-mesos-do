Vagrant script to easily setup an Apache Mesos cluster on DigitalOcean.

By default the following machines are created and communicating via a private network:

- mesos-master-1: Zookeeper, Mesos Master & Mesos Worker
- mesos-worker-N: Mesos Worker, Docker & Marathon
- haproxy-1: HA proxy with dynamic configuration

After ```vagrant up``` the cluster is ready to use. Mesos is configured to work with docker container. All machines use the UFW firewall and only reachable via ssh. Setup a ssh tunnel (like shown below) to access web consoles.

# Getting started

## Prerequisite

- [Vagrant](https://www.vagrantup.com/downloads.html)
- Vagrant Plugins
  - [vagrant-digitalocean](https://github.com/smdahlen/vagrant-digitalocean)
  - [vagrant-hostmanager](https://github.com/smdahlen/vagrant-hostmanager)
- [Digital Ocean](https://www.digitalocean.com/) account

## Initial setup

### Clone the repository

```
$> git clone https://github.com/mrico/vagrant-mesos-do.git
```

### Set API Token

Set your DigitalOcean API token:

```
$> export DO_TOKEN=INSERT_YOUR_TOKEN_HERE
```

### Have fun

```
$> vagrant up
```

# Additional Configuration

## Adding more workers

- increase variable ```num_workers``` in Vagrantfile


# Access Web consoles

All machines have a ufw firewall running and are not accessible via public IP by default.
Using SSH tunneling is the recommended via to access the web consoles.

## Set up SSH tunneling

#### Mesos Web Console @ mesos-master-1

```
$> ssh -f root@{PUBLIC_IP_OF_MESOS_MASTER_1}  -L5050:{PUBLIC_IP_OF_MESOS_MASTER_1}:5050 -N
```

Navigate your browser to http://localhost:5050.


#### Marathon Web Console @ mesos-worker-1

```
$> ssh -f root@{PUBLIC_IP_OF_MESOS_WORKER_1}  -L8080:{PUBLIC_IP_OF_MESOS_WORKER_1}:8080 -N
```

Navigate your browser to http://localhost:8080.

