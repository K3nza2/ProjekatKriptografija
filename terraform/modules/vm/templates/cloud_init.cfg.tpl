#cloud-config
hostname: ${hostname}
fqdn: ${hostname}.lab.local
manage_etc_hosts: true

users:
  - name: labadmin
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    ssh_authorized_keys:
      - ${ssh_public_key}

ssh_pwauth: false

package_update: true

runcmd:
  - systemctl enable ssh
  - systemctl start ssh
