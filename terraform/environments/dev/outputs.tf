output "attacker_ip" {
  value = module.attacker.ip_address
}

output "target_ip" {
  value = module.target.ip_address
}

output "blueteam_ip" {
  value = module.blueteam.ip_address
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../ansible/inventory/hosts.ini"
  content  = <<-EOT
    [attacker]
    ${module.attacker.ip_address} ansible_user=labadmin

    [target]
    ${module.target.ip_address} ansible_user=labadmin

    [blueteam]
    ${module.blueteam.ip_address} ansible_user=labadmin

    [all:vars]
    ansible_python_interpreter=/usr/bin/python3
    ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
  EOT
}
