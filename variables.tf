variable "network_info" {
  type = map(object({
    netmask = number
    gateway = string
    dns     = list(string)
  }))
}
