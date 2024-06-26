variable "vminfo" {
  type = map(object({
    os_type     = string # "linux" or "windows" only
    os_template = string
    vmname      = string
    cpu         = string
    memory      = string
    vmfirmware  = optional(string, "efi") # "efi" or "bios" only
    disk_size   = number
    ext_disks = optional(list(object({
      id     = number
      dev    = string
      sizeGB = number
    })), [])
    vmipv4      = string
    network     = string
    post_script = optional(string)
  }))
}


variable "network_info" {
  type = map(object({
    netmask = number
    gateway = string
    dns     = list(string)
  }))
}

variable "vsphere_user" {
  description = "vsphere_user"
  type        = string
}

variable "vsphere_password" {
  description = "vsphere_password"
  type        = string
}

variable "vsphere_server" {
  description = "vsphere_server"
  type        = string
}

variable "admin_username" {
  description = "SSH credential to control new host"
  type        = string
}

variable "admin_password" {
  description = "SSH credential to control new host"
  type        = string
}
