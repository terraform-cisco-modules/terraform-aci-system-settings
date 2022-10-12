<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform ACI - System Settings Module

A Terraform module to configure ACI System Settings.

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
| [aci_coop_policy.coop_group_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/coop_policy) | resource |
| [aci_encryption_key.global_aes_passphrase](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/encryption_key) | resource |
| [aci_endpoint_controls.rouge_ep_control](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/endpoint_controls) | resource |
| [aci_endpoint_ip_aging_profile.ip_aging](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/endpoint_ip_aging_profile) | resource |
| [aci_isis_domain_policy.isis_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/isis_domain_policy) | resource |
| [aci_mgmt_preference.apic_connectivity_preference](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/mgmt_preference) | resource |
| [aci_port_tracking.port_tracking](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/port_tracking) | resource |
| [aci_rest_managed.bgp_autonomous_system_number](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgp_route_reflectors](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.ep_loop_protection](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabric_wide_settings](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabric_wide_settings_5_2_3](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.ptp_and_latency_measurement](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->