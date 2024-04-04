terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      # version = ">= x.y.z"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~>2.17.0"
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

provider "vault" {
    address = "https://vault.lumigame.com"
}