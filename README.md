<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform ACI - Switch Configuration Module

A Terraform module to configure ACI Switch Configuration.

This module is part of the Cisco [*Intersight as Code*](https://cisco.com/go/intersightascode) project. Its goal is to allow users to instantiate network fabrics in minutes using an easy to use, opinionated data model. It takes away the complexity of having to deal with references, dependencies or loops. By completely separating data (defining variables) from logic (infrastructure declaration), it allows the user to focus on describing the intended configuration while using a set of maintained and tested Terraform Modules without the need to understand the low-level Intersight object model.

A comprehensive example using this module is available here: https://github.com/terraform-cisco-modules/easy-aci-complete

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.1.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.1.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_model"></a> [model](#input\_model) | Model data. | `any` | n/a | yes |
| <a name="input_aes_passphrase"></a> [aes\_passphrase](#input\_aes\_passphrase) | Global AES Passphrase. | `string` | n/a | yes |
## Outputs

No outputs.
## Resources

| Name | Type |
|------|------|
| [aci_access_port_block.leaf_port_blocks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_port_block) | resource |
| [aci_access_port_selector.leaf_interface_selectors](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_port_selector) | resource |
| [aci_access_sub_port_block.leaf_port_subblocks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_sub_port_block) | resource |
| [aci_leaf_interface_profile.leaf_interface_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_interface_profile) | resource |
| [aci_leaf_profile.leaf_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_profile) | resource |
| [aci_leaf_selector.leaf_selectors](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_selector) | resource |
| [aci_node_block.leaf_profile_blocks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/node_block) | resource |
| [aci_rest_managed.fabric_membership](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spine_interface_policy_group](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spine_interface_selectors](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spine_profile_node_blocks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_spine_interface_profile.spine_interface_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spine_interface_profile) | resource |
| [aci_spine_profile.spine_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spine_profile) | resource |
| [aci_spine_switch_association.spine_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spine_switch_association) | resource |
| [aci_static_node_mgmt_address.static_node_mgmt_addresses](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/static_node_mgmt_address) | resource |
| [aci_vpc_explicit_protection_group.vpc_domains](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vpc_explicit_protection_group) | resource |
<!-- END_TF_DOCS -->