output "apic_connectivity_preference" {
  description = "Identifiers for APIC Connectivity Preference: System Settings => APIC Connectivity Preference"
  value = { for v in sort(
    keys(aci_mgmt_preference.apic_connectivity_preference)
  ) : v => aci_mgmt_preference.apic_connectivity_preference[v].id }
}

output "bgp_route_reflector" {
  description = <<-EOT
    Identifiers for:
      bgp_route_reflector:
        autonomous_system_number: System Settings => BGP Route Reflector
        route_reflector_nodes:    System Settings => BGP Route Reflector
  EOT
  value = {
    autonomous_system_number = {
      for v in sort(keys(aci_rest_managed.bgp_autonomous_system_number)
      ) : v => aci_rest_managed.bgp_autonomous_system_number[v].id
    }
    route_reflector_nodes = {
      for v in sort(keys(aci_rest_managed.route_reflector_nodes)) : v => aci_rest_managed.route_reflector_nodes[v].id
    }
  }
}

output "coop_group" {
  description = "Identifiers for COOP Group: System Settings => COOP Group"
  value = { for v in sort(
    keys(aci_coop_policy.coop_group)
  ) : v => aci_coop_policy.coop_group[v].id }
}

output "endpoint_controls" {
  description = <<-EOT
    Identifiers for:
      endpoint_controls:
        ep_loop_protection: System Settings => Endpoint Controls: EP Loop Protection
        ip_aging: System Settings => Endpoint Controls: IP Aging
        rouge_ep_control: System Settings => Endpoint Controls: Rouge EP Control
  EOT
  value = {
    ep_loop_protection = {
      for v in sort(keys(aci_endpoint_loop_protection.ep_loop_protection)
      ) : v => aci_endpoint_loop_protection.ep_loop_protection[v].id
    }
    ip_aging = {
      for v in sort(keys(aci_endpoint_ip_aging_profile.ip_aging)) : v => aci_endpoint_ip_aging_profile.ip_aging[v].id
    }
    rouge_ep_control = {
      for v in sort(keys(aci_endpoint_controls.rouge_ep_control)) : v => aci_endpoint_controls.rouge_ep_control[v].id
    }
  }
}

output "fabric_wide_settings" {
  description = "Identifiers for Fabric Wide Settings: System Settings => Fabric Wide Settings"
  value = {
    for v in sort(keys(aci_rest_managed.fabric_wide_settings)
    ) : v => aci_rest_managed.fabric_wide_settings[v].id
  }
}

output "global_aes_encryption_settings" {
  description = "Identifiers for Global AES Encryption Settings: System Settings => Global AES Encryption Settings"
  value = { for v in sort(keys(aci_encryption_key.global_aes_passphrase)
  ) : v => aci_encryption_key.global_aes_passphrase[v].id }
}

output "isis_policy" {
  description = "Identifiers for ISIS Policy: System Settings => ISIS Policy"
  value       = { for v in sort(keys(aci_isis_domain_policy.isis_policy)) : v => aci_isis_domain_policy.isis_policy[v].id }
}

output "port_tracking" {
  description = "Identifiers for Port Tracking: System Settings => Port Tracking"
  value       = { for v in sort(keys(aci_port_tracking.port_tracking)) : v => aci_port_tracking.port_tracking[v].id }
}

output "ptp_and_latency_measurement" {
  description = "Identifiers for PTP and Latency Measurement: System Settings => PTP and Latency Measurement"
  value = { for v in sort(keys(aci_rest_managed.ptp_and_latency_measurement)
  ) : v => aci_rest_managed.ptp_and_latency_measurement[v].id }
}
