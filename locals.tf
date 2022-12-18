locals {
  defaults = lookup(var.model, "defaults", {})
  aes      = local.defaults.system_settings.global_aes_encryption_settings
  aging    = local.defaults.system_settings.endpoint_controls.ip_aging
  coop     = local.defaults.system_settings.coop_group
  endpoint = local.defaults.system_settings.endpoint_controls
  fwide    = local.defaults.system_settings.fabric_wide_settings
  isis     = local.defaults.system_settings.isis_policy
  loop     = local.defaults.system_settings.endpoint_controls.ep_loop_protection
  ptp      = local.defaults.system_settings.ptp_and_latency_measurement
  recommended_settings = lookup(local.system_settings, "recommended_settings", {
    coop_group                     = false
    endpoint_controls              = false
    fabric_wide_settings           = false
    global_aes_encryption_settings = false
    isis_policy                    = false
    port_tracking                  = false
    ptp_and_latency_measurement    = false
  })
  rouge           = local.defaults.system_settings.endpoint_controls.rouge_ep_control
  system_settings = lookup(var.model, "system_settings", {})
  track           = local.defaults.system_settings.port_tracking


  #__________________________________________________________
  #
  # BGP Variables
  #__________________________________________________________

  bgp_route_reflectors = {
    for i in flatten([
      for v in lookup(lookup(
        local.system_settings, "bgp_route_reflector", {}
        ), "pods", []) : [
        for s in v.route_reflector_nodes : {
          annotation = var.annotation
          node_id    = s
          pod_id     = v.pod_id
        }
      ]
    ]) : "Pod-${i.pod_id}:Node-${i.node_id}" => i
  }
}
