<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform ACI - System Settings Module

A Terraform module to configure ACI System Settings.

### NOTE: THIS MODULE IS DESIGNED TO BE CONSUMED USING "EASY ACI"

### A comprehensive example using this module is available below:

## [Easy ACI](https://github.com/terraform-cisco-modules/easy-aci-complete)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.9.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.9.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_system_settings"></a> [system\_settings](#input\_system\_settings) | System Settings Model data. | `any` | n/a | yes |
| <a name="input_annotations"></a> [annotations](#input\_annotations) | The Version of this Script. | <pre>list(object(<br>    {<br>      key   = string<br>      value = string<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "key": "orchestrator",<br>    "value": "terraform:easy-aci:v2.0"<br>  }<br>]</pre> | no |
| <a name="input_apic_version"></a> [apic\_version](#input\_apic\_version) | The Version of ACI Running in the Environment. | `string` | `"5.2(4e)"` | no |
| <a name="input_aes_passphrase"></a> [aes\_passphrase](#input\_aes\_passphrase) | Global AES Passphrase. | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apic_connectivity_preference"></a> [apic\_connectivity\_preference](#output\_apic\_connectivity\_preference) | Identifiers for APIC Connectivity Preference: System Settings => APIC Connectivity Preference |
| <a name="output_bgp_route_reflector"></a> [bgp\_route\_reflector](#output\_bgp\_route\_reflector) | Identifiers for:<br>  bgp\_route\_reflector:<br>    autonomous\_system\_number: System Settings => BGP Route Reflector<br>    route\_reflector\_nodes:    System Settings => BGP Route Reflector |
| <a name="output_coop_group"></a> [coop\_group](#output\_coop\_group) | Identifiers for COOP Group: System Settings => COOP Group |
| <a name="output_endpoint_controls"></a> [endpoint\_controls](#output\_endpoint\_controls) | Identifiers for:<br>  endpoint\_controls:<br>    ep\_loop\_protection: System Settings => Endpoint Controls: EP Loop Protection<br>    ip\_aging: System Settings => Endpoint Controls: IP Aging<br>    rouge\_ep\_control: System Settings => Endpoint Controls: Rouge EP Control |
| <a name="output_fabric_wide_settings"></a> [fabric\_wide\_settings](#output\_fabric\_wide\_settings) | Identifiers for Fabric Wide Settings: System Settings => Fabric Wide Settings |
| <a name="output_global_aes_encryption_settings"></a> [global\_aes\_encryption\_settings](#output\_global\_aes\_encryption\_settings) | Identifiers for Global AES Encryption Settings: System Settings => Global AES Encryption Settings |
| <a name="output_isis_policy"></a> [isis\_policy](#output\_isis\_policy) | Identifiers for ISIS Policy: System Settings => ISIS Policy |
| <a name="output_port_tracking"></a> [port\_tracking](#output\_port\_tracking) | Identifiers for Port Tracking: System Settings => Port Tracking |
| <a name="output_ptp_and_latency_measurement"></a> [ptp\_and\_latency\_measurement](#output\_ptp\_and\_latency\_measurement) | Identifiers for PTP and Latency Measurement: System Settings => PTP and Latency Measurement |
## Resources

| Name | Type |
|------|------|
| [aci_coop_policy.coop_group](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/coop_policy) | resource |
| [aci_encryption_key.global_aes_passphrase](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/encryption_key) | resource |
| [aci_endpoint_controls.rouge_ep_control](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/endpoint_controls) | resource |
| [aci_endpoint_ip_aging_profile.ip_aging](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/endpoint_ip_aging_profile) | resource |
| [aci_endpoint_loop_protection.ep_loop_protection](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/endpoint_loop_protection) | resource |
| [aci_isis_domain_policy.isis_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/isis_domain_policy) | resource |
| [aci_mgmt_preference.apic_connectivity_preference](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/mgmt_preference) | resource |
| [aci_port_tracking.port_tracking](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/port_tracking) | resource |
| [aci_rest.bgp_instance](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest) | resource |
| [aci_rest_managed.bgp_autonomous_system_number](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabric_wide_settings](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabric_wide_settings_5_2_3](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.ptp_and_latency_measurement](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.route_reflector_nodes](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->