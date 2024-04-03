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