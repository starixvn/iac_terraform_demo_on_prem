data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_content_library" "library" {
  name = var.content_lib
}

data "vsphere_content_library_item" "template" {
  name       = var.template
  type       = "ovf"
  library_id = data.vsphere_content_library.library.id
}

resource "vsphere_virtual_machine" "linuxvm" {
  #for_each         = var.vminfo
  count            = var.os == "linux" ? 1 : 0
  name             = var.vmname
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = var.cpu
  memory           = var.memory * 1024
  firmware         = var.vmfirmware
  # guest_id         = data.vsphere_virtual_machine.template.guest_id
  # scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  network_interface {
    network_id = data.vsphere_network.network.id
    # adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label = "${var.vmname}-disk0"
    size  = var.disk_size
    #thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  dynamic "disk" {
    for_each = [for disk in var.ext_disks : disk]
    content {
      label       = "disk${disk.value.id}"
      unit_number = disk.value.id
      size        = disk.value.sizeGB
    }
  }
  clone {
    template_uuid = data.vsphere_content_library_item.template.id
    customize {
      linux_options {
        host_name = var.vmname
        domain    = "example.com"
      }
      network_interface {
        ipv4_address = var.ipv4
        ipv4_netmask = var.ipv4_netmask
      }
      ipv4_gateway    = var.ipv4_gateway
      dns_server_list = var.ipv4_dns
    }
  }
}

resource "null_resource" "post_script_linux" {
  count = var.post_script != null && var.os == "linux" ? 1 : 0
  triggers = {
    postscript = var.post_script
  }

  connection {
    type     = "ssh"
    agent    = "false"
    host     = var.ipv4
    user     = var.admin_username
    password = var.admin_password
  }

  # copies file from local directory to remote directory
  provisioner "file" {
    source      = var.post_script
    destination = "/tmp/script.sh"
  }

  # executes the following commands remotely
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }
}


resource "vsphere_virtual_machine" "windowsvm" {
  #for_each         = var.vminfo
  count                   = var.os == "windows" ? 1 : 0
  name                    = var.vmname
  resource_pool_id        = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id            = data.vsphere_datastore.datastore.id
  num_cpus                = var.cpu
  memory                  = var.memory * 1024
  firmware                = "efi"
  efi_secure_boot_enabled = true
  scsi_type               = "lsilogic-sas"
  # guest_id         = data.vsphere_virtual_machine.template.guest_id
  # scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "e1000e"
    # adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label = "${var.vmname}-disk0"
    size  = var.disk_size
    # thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  dynamic "disk" {
    for_each = [for disk in var.ext_disks : disk]
    content {
      label       = "disk${disk.value.id}"
      unit_number = disk.value.id
      size        = disk.value.sizeGB
    }
  }
  clone {
    template_uuid = data.vsphere_content_library_item.template.id
    customize {
      windows_options {
        computer_name  = var.vmname
        workgroup      = "workgroup"
        admin_password = var.admin_password
        time_zone      = 205 # (GMT+07:00) Bangkok, Hanoi, Jakarta
      }
      network_interface {
        ipv4_address = var.ipv4
        ipv4_netmask = var.ipv4_netmask
      }
      ipv4_gateway    = var.ipv4_gateway
      dns_server_list = var.ipv4_dns
    }
  }
}

resource "null_resource" "post_script_windows" {
  count = var.post_script != null && var.os == "windows" ? 1 : 0
  triggers = {
    postscript = var.post_script
  }

  connection {
    type     = "winrm"
    host     = var.ipv4
    user     = "Administrator"
    password = var.admin_password
  }

  # copies file from local directory to remote directory
  provisioner "file" {
    source      = var.post_script
    destination = "C:\\tmp\\script.ps1"
  }

  # executes the following commands remotely
  provisioner "remote-exec" {
    command     = "C:\\tmp\\script.ps1 -Schedule"
    interpreter = ["PowerShell"]
  }
}
