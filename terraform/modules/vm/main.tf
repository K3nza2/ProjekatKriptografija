# Disk mašine - copy-on-write nad zajedničkim base image-om (base_volume_id)
# Ovo znači da se cloud image (Debian/Ubuntu) skida i konvertuje samo JEDNOM,
# a svaka VM dobija svoj tanak COW sloj preko njega - brže i štedi disk.
resource "libvirt_volume" "disk" {
  name           = "${var.vm_name}-disk.qcow2"
  pool           = var.storage_pool
  base_volume_id = var.base_volume_id
  size           = var.disk_size_bytes
}

# user-data deo cloud-init-a: hostname, ssh ključ, root/sudo korisnik
locals {
  user_data = templatefile("${path.module}/templates/cloud_init.cfg.tpl", {
    hostname       = var.vm_name
    ssh_public_key = var.ssh_public_key
  })

  network_config = templatefile("${path.module}/templates/network_config.cfg.tpl", {
    ip_address = var.ip_address
    gateway    = var.gateway
    dns_server = var.gateway
  })
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name           = "${var.vm_name}-cloudinit.iso"
  pool           = var.storage_pool
  user_data      = local.user_data
  network_config = local.network_config
}

resource "libvirt_domain" "vm" {
  name   = var.vm_name
  memory = var.memory_mb
  vcpu   = var.vcpu

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
    network_id     = var.network_id
    wait_for_lease = false
  }

  disk {
    volume_id = libvirt_volume.disk.id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "none"
    autoport    = true
  }
}
