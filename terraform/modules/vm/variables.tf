variable "vm_name" {
  description = "Ime VM-a (npr. attacker, target, blueteam)"
  type        = string
}

variable "memory_mb" {
  type    = number
  default = 2048
}

variable "vcpu" {
  type    = number
  default = 2
}

variable "disk_size_bytes" {
  description = "Veličina diska u bajtovima (default 10GB)"
  type        = number
  default     = 10737418240
}

variable "storage_pool" {
  description = "Ime libvirt storage pool-a"
  type        = string
  default     = "default"
}

variable "base_volume_id" {
  description = "ID zajedničkog base cloud image volume-a (kreira se jednom u environments/dev)"
  type        = string
}

variable "network_id" {
  description = "ID libvirt mreže (output iz network modula)"
  type        = string
}

variable "ip_address" {
  description = "Statička IP adresa VM-a u formatu CIDR, npr. 192.168.56.10/24"
  type        = string
}

variable "gateway" {
  description = "Gateway adresa mreže"
  type        = string
}

variable "ssh_public_key" {
  description = "Sadržaj javnog SSH ključa koji se ubacuje preko cloud-init"
  type        = string
}
