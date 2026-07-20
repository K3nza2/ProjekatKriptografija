version: 2
ethernets:
  ens3:
    dhcp4: false
    addresses:
      - ${ip_address}
    gateway4: ${gateway}
    nameservers:
      addresses: [${dns_server}]
