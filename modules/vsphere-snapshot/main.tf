# data block to fetch the datacenter id
data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_virtual_machine" "vm" {
  name          = var.vmname
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine_snapshot" "snap" {
  virtual_machine_uuid = data.vsphere_virtual_machine.vm.id
  snapshot_name        = var.snapshot_name
  description          = "${var.snapshot_description} on ${timestamp()}"
  memory               = var.snapshot_memory
  quiesce              = var.snapshot_filesystem
  remove_children      = var.remove_children == true && var.persist_snapshot == true ? var.remove_children : false
  consolidate          = var.persist_snapshot
}
