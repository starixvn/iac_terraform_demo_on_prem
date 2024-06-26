# terraform-vsphere-snapshot

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_vsphere"></a> [vsphere](#requirement\_vsphere) | >=1.26.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vsphere"></a> [vsphere](#provider\_vsphere) | 2.1.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vsphere_virtual_machine_snapshot.snap](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine_snapshot) | resource |
| [vsphere_datacenter.dc](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datacenter) | data source |
| [vsphere_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/virtual_machine) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datacenter"></a> [datacenter](#input\_datacenter) | variable for the datacenter where the VMs will be deployed | `string` | n/a | yes |
| <a name="input_persist_snapshot"></a> [persist\_snapshot](#input\_persist\_snapshot) | (Optional) Boolean value that determines if the delta disks will be consolidated into the parent on destroy. Defaults to false | `bool` | `false` | no |
| <a name="input_remove_children"></a> [remove\_children](#input\_remove\_children) | (Optional) Boolean value that determines if the children in the snapshot tree will be removed on destroy. Defaults to false | `bool` | `false` | no |
| <a name="input_snapshot_description"></a> [snapshot\_description](#input\_snapshot\_description) | (Optional) variable for the folder path that will be used when deploying workloads | `string` | `"Snapshot created via Terraform"` | no |
| <a name="input_snapshot_filesystem"></a> [snapshot\_filesystem](#input\_snapshot\_filesystem) | (Optional) Boolean value that determines if the filesystem will be quiesced as a part of the snapshot. Requires VMware Tools. Defaults to true | `bool` | `true` | no |
| <a name="input_snapshot_memory"></a> [snapshot\_memory](#input\_snapshot\_memory) | (Optional) Boolean value that determines if memory will be included in the snapshot. Defaults to true | `bool` | `true` | no |
| <a name="input_snapshot_name"></a> [snapshot\_name](#input\_snapshot\_name) | (Required) Name of the Snapshot that will be created for the VM | `string` | n/a | yes |
| <a name="input_vm"></a> [vm](#input\_vm) | (Required) Name of the VM that will have a snapshot created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_snapshot"></a> [snapshot](#output\_snapshot) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
