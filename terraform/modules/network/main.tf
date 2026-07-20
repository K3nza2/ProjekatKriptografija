resource "libvirt_network" "lab_network" {
  name      = var.network_name
  mode      = var.mode          # "none" = potpuno izolovana, bez interneta
  domain    = var.domain
  addresses = [var.cidr]

  dhcp {
    enabled = var.dhcp_enabled
  }

  dns {
    enabled = false
  }

  autostart = true
}
