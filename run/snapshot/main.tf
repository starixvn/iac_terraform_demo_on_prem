module "vm_snapshot" {
  source           = "./modules/vsphere_snapshot"
  for_each         = var.vminfo
  datacenter       = "Testlab"
  vmname           = each.value.vmname
  remove_children  = true
  persist_snapshot = true
  # snapshot_name   = "latest"
}
