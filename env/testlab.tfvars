vsphere_user     = "administrator@vcenter7.local"
vsphere_password = "yCiB;2uRN%:_4z6"
vsphere_server   = "vct7.spvn.local"
admin_username   = "nexops"
admin_password   = "XDR%tgbHU*"
/*
project_name = "testlab"
vault_addr = "https://vault.lumigame.com"
db_host = "10.70.70.139"
db_name = "database"
*/
###
vminfo = {
  "server02" = {
    os_type     = "linux"
    os_template = "linux-ubuntu-22.04-lts-BASE"
    vmname      = "vault-app"
    vmfirmware  = "efi"
    cpu         = "1"
    memory      = "2"
    disk_size   = 30
    vmipv4      = "10.70.70.141"
    network     = "VLAN70"
    post_script = "templates/test_php_mysql79.sh"
  },
  "server03" = {
    os_type     = "linux"
    os_template = "linux-ubuntu-22.04-lts-BASE"
    vmname      = "vault-app-mariadb"
    vmfirmware  = "efi"
    cpu         = "1"
    memory      = "2"
    disk_size   = 30
    vmipv4      = "10.70.70.139"
    network     = "VLAN70"
    post_script = "templates/test_php_mariadb79.sh"
  },

}
