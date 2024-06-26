

variable "datacenter" {
  description = "variable for the datacenter where the VMs will be deployed"
  type        = string
}

variable "vmname" {
  description = "(Required) Name of the VM that will have a snapshot created"
  type        = string
}

variable "snapshot_name" {
  description = "(Required) Name of the Snapshot that will be created for the VM"
  type        = string
  default     = "latest"
}

variable "snapshot_description" {
  description = "(Optional) variable for the folder path that will be used when deploying workloads"
  type        = string
  default     = "Snapshot created via Terraform"
}

variable "snapshot_memory" {
  type        = bool
  description = "(Optional) Boolean value that determines if memory will be included in the snapshot. Defaults to true"
  default     = true
}

variable "snapshot_filesystem" {
  type        = bool
  description = "(Optional) Boolean value that determines if the filesystem will be quiesced as a part of the snapshot. Requires VMware Tools. Defaults to true"
  default     = true
}

variable "remove_children" {
  type        = bool
  description = "(Optional) Boolean value that determines if the children in the snapshot tree will be removed on destroy. Defaults to false"
  default     = false
}

variable "persist_snapshot" {
  type        = bool
  description = "(Optional) Boolean value that determines if the delta disks will be consolidated into the parent on destroy. Defaults to false"
  default     = false
}

