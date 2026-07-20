locals {
  ssh_public_key = file(var.ssh_public_key_path)
}

module "network" {
  source = "../../modules/network"

  network_name = "redblue-lab"
  mode         = "none" # izolovana, bez interneta - kao i sada sa Vagrant/VirtualBox
  cidr         = var.network_cidr
}

# --- Base image volumes (skidaju se/konvertuju samo jednom, VM-ovi prave COW kopije preko njih) ---

resource "libvirt_volume" "debian_base" {
  name   = "debian-12-base.qcow2"
  pool   = var.storage_pool
  source = var.debian_image_path
  format = "qcow2"
}

resource "libvirt_volume" "ubuntu_base" {
  name   = "ubuntu-22.04-base.qcow2"
  pool   = var.storage_pool
  source = var.ubuntu_image_path
  format = "qcow2"
}

# --- Attacker VM ---

module "attacker" {
  source = "../../modules/vm"

  vm_name         = "attacker"
  memory_mb       = 2048
  vcpu            = 2
  base_volume_id  = libvirt_volume.debian_base.id
  storage_pool    = var.storage_pool
  network_id      = module.network.network_id
  ip_address      = "192.168.56.10/24"
  gateway         = var.gateway
  ssh_public_key  = local.ssh_public_key
}

# --- Target VM ---

module "target" {
  source = "../../modules/vm"

  vm_name         = "target"
  memory_mb       = 1024
  vcpu            = 1
  base_volume_id  = libvirt_volume.ubuntu_base.id
  storage_pool    = var.storage_pool
  network_id      = module.network.network_id
  ip_address      = "192.168.56.20/24"
  gateway         = var.gateway
  ssh_public_key  = local.ssh_public_key
}

# --- Blue Team VM (Wazuh manager) ---

module "blueteam" {
  source = "../../modules/vm"

  vm_name         = "blueteam"
  memory_mb       = 4096 # Wazuh manager + dashboard traži više RAM-a
  vcpu            = 2
  base_volume_id  = libvirt_volume.debian_base.id
  storage_pool    = var.storage_pool
  network_id      = module.network.network_id
  ip_address      = "192.168.56.30/24"
  gateway         = var.gateway
  ssh_public_key  = local.ssh_public_key
}
