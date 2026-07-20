variable "network_name" {
  description = "Ime libvirt mreže"
  type        = string
  default     = "redblue-lab"
}

variable "mode" {
  description = "nat | route | none (none = potpuno izolovana mreža, preporučeno za vežbu)"
  type        = string
  default     = "none"
}

variable "domain" {
  description = "DNS domen mreže (interni, ne mora da postoji spolja)"
  type        = string
  default     = "lab.local"
}

variable "cidr" {
  description = "CIDR opseg mreže"
  type        = string
  default     = "192.168.56.0/24"
}

variable "dhcp_enabled" {
  description = "Da li libvirt dodeljuje IP preko DHCP-a (mi ćemo koristiti statičke IP-jeve preko cloud-init, pa ovo obično ostaje false)"
  type        = bool
  default     = false
}
