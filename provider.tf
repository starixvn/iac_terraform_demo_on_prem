terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      # version = ">= x.y.z"
    }
  }
  #required_version = ">= 0.13"
}

provider "vsphere" {
  # alias                = "vcenter1"
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}
