variable "vminfo" {
  type = map(object({
    os_type     = string # "linux" or "windows" only
    os_template = string
    vmname      = string
    vmfirmware  = optional(string, "efi")
    cpu         = string
    memory      = string
    disk_size   = number
    ext_disks = optional(list(object({
      id     = number
      dev    = string
      sizeGB = number
    })), [])
    vmipv4  = string
    network = optional(string, "VLAN70")
  }))
  default = {
    # "server01" = {
    #   os_type     = "linux"
    #   os_template = "Ubuntu 22.04"
    #   vmname      = "os-linux1"
    #   vmfirmware  = "bios"
    #   cpu         = "1"
    #   memory      = "1024"
    #   disk_size   = 30
    #   vmipv4      = "192.168.1.169"
    # }

    # "server02" = {
    #   os_type     = "windows"
    #   os_template = "Windows Server 2022"
    #   vmname      = "winserver-22"
    #   vmfirmware  = "efi"
    #   cpu         = "4"
    #   memory      = "4096"
    #   disk_size   = 60
    #   vmipv4      = "192.168.1.170"
    # }
  }
}

module "virtual_machine" {
  source       = "./modules/vsphere_vm"
  for_each     = var.vminfo
  datacenter   = "Testlab"
  cluster      = "Testlab Cluster"
  content_lib  = "Content Library"
  datastore    = "SSD_VM"
  network      = each.value.network
  template     = each.value.os_template
  os           = each.value.os_type
  vmname       = each.value.vmname
  vmfirmware   = each.value.vmfirmware
  cpu          = each.value.cpu
  memory       = each.value.memory
  disk_size    = each.value.disk_size
  ipv4         = each.value.vmipv4
  ipv4_netmask = var.network_info[each.value.network].netmask
  ipv4_gateway = var.network_info[each.value.network].gateway
  ipv4_dns     = var.network_info[each.value.network].dns
  ext_disks    = each.value.ext_disks
}
