# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  # Attacker VM (Debian sa pentesting tools)
  config.vm.define "attacker" do |attacker|
    attacker.vm.box = "debian/bookworm64"
    attacker.vm.hostname = "attacker"
    attacker.vm.network "private_network", ip: "192.168.56.10"
    
    attacker.vm.provider "virtualbox" do |vb|
      vb.name = "RedTeam-Attacker"
      vb.memory = "2048"
      vb.cpus = 2
    end
    
    # Provizija sa Ansible
    attacker.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y python3 python3-pip openssh-server
      systemctl enable ssh
      systemctl start ssh
    SHELL
  end

  # Target VM (Ubuntu sa vulnerable services)
  config.vm.define "target" do |target|
    target.vm.box = "ubuntu/jammy64"
    target.vm.hostname = "target"
    target.vm.network "private_network", ip: "192.168.56.20"
    
    target.vm.provider "virtualbox" do |vb|
      vb.name = "RedTeam-Target"
      vb.memory = "1024"
      vb.cpus = 1
    end
    
    # Provizija sa Ansible
    target.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y python3 openssh-server
      systemctl enable ssh
      systemctl start ssh
      
      # Kreiranje test user-a za brute force
      useradd -m -s /bin/bash testuser
      echo "testuser:password123" | chpasswd
    SHELL
  end

end
