locals {
  system_settings                = lookup(var.model, "system-settings", {})
  defaults                       = lookup(var.model, "defaults", {})
  coop_group                     = local.defaults.system_settings.coop_group
  endpoint_controls              = local.defaults.system_settings.endpoint_controls
  fabric_wide_settings           = local.defaults.system_settings.fabric_wide_settings
  global_aes_encryption_settings = local.defaults.system_settings.global_aes_encryption_settings
  isis_policy                    = local.defaults.system_settings.isis_policy
  port_tracking                  = local.defaults.system_settings.port_tracking
  ptp_and_latency_measurement    = local.defaults.system_settings.ptp_and_latency_measurement


  #__________________________________________________________
  #
  # BGP Variables
  #__________________________________________________________

  bgp_route_reflectors = {
    for i in flatten([
      for v in lookup(lookup(
        local.system_settings, "bgp_route_reflector", local.defaults.system_settings.bgp_route_reflector
        ), "pods", []) : [
        for s in v.route_reflector_nodes : {
          annotation = local.defaults.annotation
          node_id    = s
          pod_id     = v.pod
        }
      ]
    ]) : "${i.pod_id}_${i.node_id}" => i
  }
}