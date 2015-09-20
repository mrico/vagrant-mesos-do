# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  num_workers=2

  config.ssh.private_key_path = '~/.ssh/id_rsa'

  config.hostmanager.enabled = false
  config.vm.provision :hostmanager

  config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
    droplet = VagrantPlugins::DigitalOcean::Provider.droplet(vm)
    private_network = droplet['networks']['v4'].find { |network|
      network['type'] == 'private'
    }

    private_network['ip_address']
  end

  config.vm.define "mesos-master-1" do |master|
    master.vm.box = 'digital_ocean'
    master.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    master.vm.provision :shell, path: "bootstrap-master.sh"
    master.hostmanager.aliases = %w(zookeeper-1)
  end

  (1..num_workers).each do |n|
    config.vm.define "mesos-worker-#{n}" do |worker|
      worker.vm.box = 'digital_ocean'
      worker.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
      worker.vm.provision :shell, path: "bootstrap-worker.sh"
    end
  end

  config.vm.define "haproxy-1" do |master|
    master.vm.box = 'digital_ocean'
    master.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    master.vm.provision :shell, path: "bootstrap-haproxy.sh"
  end

  config.vm.provider :digital_ocean do |provider|
    provider.token = ENV['DO_TOKEN']
    provider.image = 'ubuntu-14-04-x64'
    provider.region = 'fra1'
    provider.size = '512mb'
    provider.private_networking = true
  end
end
