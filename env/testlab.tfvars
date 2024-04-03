vsphere_user     = "administrator@vcenter7.local"
vsphere_password = "yCiB;2uRN%:_4z6"
vsphere_server   = "vct7.spvn.local"
admin_username   = "nexops"
admin_password   = "XDR%tgbHU*"
###
vminfo = {
  # "server01" = {
  #   os_type     = "linux"
  #   os_template = "linux-ubuntu-22.04-lts-BASE"
  #   vmname      = "os-linux1"
  #   vmfirmware  = "bios"
  #   cpu         = "1"
  #   memory      = "1024"
  #   disk_size   = 30
  #   vmipv4      = "10.70.70.139"
  # },
  "test-134" = {
    os_type     = "linux"
    os_template = "linux-ubuntu-22.04-lts-BASE"
    vmname      = "test-70-134"
    cpu         = "2"
    memory      = "1"
    vmfirmware  = "efi"
    disk_size   = 30
    vmipv4      = "10.70.70.134"
    network     = "VLAN70"
    post_script = "templates/ubuntu_postscript.sh"
  }
}
