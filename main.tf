module "virtual_machine" {
  source       = "./modules/vsphere-vm"
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
  post_script  = each.value.post_script

  # post_script  = each.value.post_script == null ? "" : each.value.post_script

  admin_username = var.admin_username
  admin_password = var.admin_password
}

# Snapshot all VM
# module "vm_snapshot" {
#   source           = "./modules/vsphere-snapshot"
#   for_each         = var.vminfo
#   datacenter       = "Testlab"
#   vmname           = each.value.vmname
#   remove_children  = true
#   persist_snapshot = true
#   # snapshot_name   = "latest"
# }
