output "name" {
  value = libvirt_domain.vm.name
}

output "ip_address" {
  # skidamo /24 sufiks, ostaje čista IP adresa za ansible inventory
  value = split("/", var.ip_address)[0]
}
