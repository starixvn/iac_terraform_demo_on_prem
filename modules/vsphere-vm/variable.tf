variable "datacenter" {
  description = "Virtual Datacenter name where VM will be placed"
  type        = string
}

variable "cluster" {
  description = "Password to connect to vCenter Server"
  type        = string
}

variable "network" {
  description = "IP or DNS name to connect to vCenter server"
  type        = string
}

variable "datastore" {
  description = "IP or DNS name to connect to vCenter server"
  type        = string
  #default     = "StarLord_Datastore01"
}

variable "content_lib" {
  description = "Content library name of the template"
  type        = string
}

variable "template" {
  description = "IP or DNS name to connect to vCenter server"
  type        = string
}

variable "os" {
  description = "Operating system of new VM"
  type        = string
}

variable "vmname" {
  description = "Provide New virtual machine name"
  type        = string
}

variable "vmfirmware" {
  description = "Provide New virtual machine firmware type ('efi' or 'bios')"
  type        = string
  default     = "bios"
}

variable "cpu" {
  description = "Provide New virtual machine cpu count"
  type        = string
}

variable "memory" {
  description = "Provide New virtual machine memory"
  type        = string
}

variable "disk_size" {
  description = "Provide New virtual machine disk size"
  type        = number
}

variable "ipv4" {
  description = "Provide New virtual machine ipv4 address"
  type        = string
}

variable "ipv4_netmask" {
  description = "Provide New virtual machine ipv4 netmask"
  type        = number
}

variable "ipv4_gateway" {
  description = "Provide New virtual machine ipv4 netmask"
  type        = string
}

variable "ipv4_dns" {
  description = "Provide New virtual machine ipv4 dns server"
  type        = list(string)
}

variable "ext_disks" {
  description = "Extra disk for virtual machine"
  type = list(object({
    id     = number
    dev    = string
    sizeGB = number
  }))

  default = []
}

variable "post_script" {
  description = "Script File to run after create VM"
  type        = string
}

variable "admin_username" {
  description = "Manage user credential"
  type        = string
}

variable "admin_password" {
  description = "Manage user credential"
  type        = string
}

#variables vm folders
data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
  # provider      = vsphere
}
