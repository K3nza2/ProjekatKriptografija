variable "ssh_public_key_path" {
  description = "Putanja do tvog javnog SSH ključa na Pop!_OS-u"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "debian_image_path" {
  description = "Putanja do skinutog Debian cloud image-a (qcow2) - koristi se za attacker i blueteam"
  type        = string
  default     = "./images/debian-12-generic-amd64.qcow2"
}

variable "ubuntu_image_path" {
  description = "Putanja do skinutog Ubuntu cloud image-a (qcow2) - koristi se za target"
  type        = string
  default     = "./images/ubuntu-22.04-server-cloudimg-amd64.qcow2"
}

variable "storage_pool" {
  type    = string
  default = "default"
}

variable "network_cidr" {
  type    = string
  default = "192.168.56.0/24"
}

variable "gateway" {
  type    = string
  default = "192.168.56.1"
}
