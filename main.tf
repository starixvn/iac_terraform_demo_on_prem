variable "default_var" {
  type = object({
    netmask = number
    gateway = string
    dns     = list(string)
  })
  default = {
    netmask = 24
    gateway = "10.70.70.1"
    dns     = ["10.18.200.101", "10.18.200.102"]
  }
}

variable "vminfo" {
  type = map(object({
    os_type     = string # "linux" or "windows" only
    os_template = string
    vmname      = string
    cpu         = string
    memory      = string
    disk_size   = number
    vmipv4      = string
  }))
  default = {
    # "server01" = {
    #   os_type     = "linux"
    #   os_template = "Ubuntu 22.04"
    #   vmname      = "os-linux1"
    #   cpu         = "1"
    #   memory      = "1024"
    #   disk_size   = 30
    #   vmipv4      = "192.168.1.169"
    # }

    # "server02" = {
    #   os_type     = "windows"
    #   os_template = "Windows Server 2022"
    #   vmname      = "winserver-22"
    #   cpu         = "4"
    #   memory      = "4096"
    #   disk_size   = 60
    #   vmipv4      = "192.168.1.170"
    # }

    "k8s-Master-131" = {
      os_type     = "linux"
      os_template = "Ubuntu 22.04"
      vmname      = "k8snode-70-131"
      cpu         = "2"
      memory      = "2048"
      disk_size   = 30
      vmipv4      = "10.70.70.131"
    }

    "k8s-Master-132" = {
      os_type     = "linux"
      os_template = "Ubuntu 22.04"
      vmname      = "k8snode-70-132"
      cpu         = "2"
      memory      = "2048"
      disk_size   = 30
      vmipv4      = "10.70.70.132"
    }

    "k8s-Master-133" = {
      os_type     = "linux"
      os_template = "Ubuntu 22.04"
      vmname      = "k8snode-70-133"
      cpu         = "2"
      memory      = "2048"
      disk_size   = 30
      vmipv4      = "10.70.70.133"
    }

    "k8s-Worker-134" = {
      os_type     = "linux"
      os_template = "Ubuntu 22.04 - K8S Worker"
      vmname      = "k8snode-70-134"
      cpu         = "2"
      memory      = "2048"
      disk_size   = 30
      vmipv4      = "10.70.70.134"
    }
  }
}

module "virtual_machine" {
  source       = "./modules/vsphere_vm"
  for_each     = var.vminfo
  datacenter   = "Testlab"
  cluster      = "Testlab Cluster"
  content_lib  = "Content Library"
  network      = "VLAN70"
  datastore    = "SSD_VM"
  template     = each.value.os_template
  os           = each.value.os_type
  vmname       = each.value.vmname
  cpu          = each.value.cpu
  memory       = each.value.memory
  disk_size    = each.value.disk_size
  ipv4         = each.value.vmipv4
  ipv4_netmask = var.default_var.netmask
  ipv4_gateway = var.default_var.gateway
  ipv4_dns     = var.default_var.dns
}
