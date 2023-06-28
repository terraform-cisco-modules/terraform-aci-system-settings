output "apic_connectivity_preference" {
  value = { for v in sort(
    keys(aci_mgmt_preference.apic_connectivity_preference)
  ) : v => aci_mgmt_preference.apic_connectivity_preference[v].id }
}

output "bgp_autonomous_system_number" {
  value = { for v in sort(
    keys(aci_rest_managed.bgp_autonomous_system_number)
  ) : v => aci_rest_managed.bgp_autonomous_system_number[v].id }
}

output "bgp_route_reflectors" {
  value = { for v in sort(
    keys(aci_rest_managed.bgp_route_reflectors)
  ) : v => aci_rest_managed.bgp_route_reflectors[v].id }
}

output "coop_group" {
  value = { for v in sort(
    keys(aci_coop_policy.coop_group)
  ) : v => aci_coop_policy.coop_group[v].id }
}

output "endpoint_controls-ep_loop_protection" {
  value = { for v in sort(
    keys(aci_endpoint_loop_protection.ep_loop_protection)
  ) : v => aci_endpoint_loop_protection.ep_loop_protection[v].id }
}

output "endpoint_controls-ip_aging" {
  value = { for v in sort(
    keys(aci_endpoint_ip_aging_profile.ip_aging)
  ) : v => aci_endpoint_ip_aging_profile.ip_aging[v].id }
}

output "endpoint_controls-rouge_ep_control" {
  value = { for v in sort(
    keys(aci_endpoint_controls.rouge_ep_control)
  ) : v => aci_endpoint_controls.rouge_ep_control[v].id }
}

output "fabric_wide_settings" {
  value = { for v in sort(
    keys(aci_rest_managed.fabric_wide_settings)
  ) : v => aci_rest_managed.fabric_wide_settings[v].id }
}

output "fabric_wide_settings_5_2_3" {
  value = { for v in sort(
    keys(aci_rest_managed.fabric_wide_settings_5_2_3)
  ) : v => aci_rest_managed.fabric_wide_settings_5_2_3[v].id }
}

output "global_aes_encryption_settings" {
  value = { for v in sort(
    keys(aci_encryption_key.global_aes_passphrase)
  ) : v => aci_encryption_key.global_aes_passphrase[v].id }
}

output "isis_policy" {
  value = { for v in sort(
    keys(aci_isis_domain_policy.isis_policy)
  ) : v => aci_isis_domain_policy.isis_policy[v].id }
}

output "port_tracking" {
  value = { for v in sort(
    keys(aci_port_tracking.port_tracking)
  ) : v => aci_port_tracking.port_tracking[v].id }
}

output "ptp_and_latency_measurement" {
  value = { for v in sort(
    keys(aci_rest_managed.ptp_and_latency_measurement)
  ) : v => aci_rest_managed.ptp_and_latency_measurement[v].id }
}

