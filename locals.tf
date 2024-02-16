locals {
  defaults = yamldecode(file("${path.module}/defaults.yaml")).defaults.system_settings

  # DEFAULTS
  aes          = local.defaults.global_aes_encryption_settings
  apic_version = var.system_settings.global_settings.controller.version
  coop_grp     = local.defaults.coop_group
  endpoint     = local.defaults.endpoint_controls
  fwide        = local.defaults.fabric_wide_settings
  isis         = local.defaults.isis_policy
  ptp          = local.defaults.ptp_and_latency_measurement
  ptrack       = local.defaults.port_tracking

  # Recommended Settings
  rsettings = local.defaults.recommended_settings
  rss = [for v in [lookup(var.system_settings, "recommended_settings", local.rsettings)] : {
    aes      = lookup(v, "global_aes_encryption_settings", false)
    coop_grp = lookup(v, "coop_group", false)
    epctrl   = merge(local.rsettings.endpoint_controls, lookup(v, "endpoint_controls", {}))
    fws      = lookup(v, "fabric_wide_settings", false)
    isis     = lookup(v, "isis_policy", false)
    ptp      = lookup(v, "ptp_and_latency_measurement", false)
    ptrack   = lookup(v, "port_tracking", false)
  }][0]

  # POLICIES
  coop_group = local.rss.coop_grp == false && length(lookup(var.system_settings, "coop_group", {})) > 0 ? merge(
    { create = true }, local.coop_grp, lookup(var.system_settings, "coop_group", {})
  ) : local.rss.coop_grp == true ? merge({ create = true }, local.coop_grp) : merge({ create = false }, local.coop_grp)

  global_aes_encryption_settings = local.rss.aes == false && length(lookup(
    var.system_settings, "global_aes_encryption_settings", {})) > 0 ? merge(
    { create = true }, local.aes, lookup(var.system_settings, "global_aes_encryption_settings", {})
  ) : local.rss.aes == true ? merge({ create = true }, local.aes) : merge({ create = false }, local.aes)

  isis_policy = local.rss.isis == false && length(lookup(var.system_settings, "isis_policy", {})) > 0 ? merge(
    { create = true }, local.isis, lookup(var.system_settings, "isis_policy", {})
  ) : local.rss.isis == true ? merge({ create = true }, local.isis) : merge({ create = false }, local.isis)

  port_tracking = local.rss.ptrack == false && length(lookup(var.system_settings, "port_tracking", {})) > 0 ? merge(
    { create = true }, local.ptrack, lookup(var.system_settings, "port_tracking", {})
  ) : local.rss.ptrack == true ? merge({ create = true }, local.ptrack) : merge({ create = false }, local.ptrack)

  ptp_and_latency_measurement = local.rss.ptp == false && length(lookup(
    var.system_settings, "ptp_and_latency_measurement", {})) > 0 ? merge(
    { create = true }, local.ptp, lookup(var.system_settings, "ptp_and_latency_measurement", {})
  ) : local.rss.ptp == true ? merge({ create = true }, local.ptp) : merge({ create = false }, local.ptp)


  #__________________________________________________________
  #
  # BGP Variables
  #__________________________________________________________

  route_reflector_nodes = {
    for i in flatten([
      for v in lookup(lookup(lookup(var.system_settings, "bgp_route_reflector", {}
        ), "route_reflector_nodes", {}), "pods", []) : [
        for s in v.nodes : {
          node_id = s
          pod_id  = v.pod_id
        }
      ]
    ]) : "Pod-${i.pod_id}/Node-${i.node_id}" => i
  }


  #__________________________________________________________
  #
  # System Settings => Endpoint Controls
  #__________________________________________________________

  endpoints = lookup(var.system_settings, "endpoint_controls", {})
  ep_loop_protection = local.rss.epctrl.ep_loop_protection == false && length(lookup(
    local.endpoints, "ep_loop_protection", {})) > 0 ? merge({ create = true }, local.endpoint.ep_loop_protection,
    lookup(local.endpoint, "ep_loop_protection", {}),
    { action = merge(local.endpoint.ep_loop_protection.action, lookup(lookup(
      local.endpoints, "ep_loop_protection", {}), "action", {}))
    }) : local.rss.epctrl.ep_loop_protection == false ? merge({ create = false }, local.endpoint.ep_loop_protection
  ) : merge({ create = true }, local.endpoint.ep_loop_protection)

  ip_aging = local.rss.epctrl.ip_aging == false && length(lookup(local.endpoints, "ip_aging", {})) > 0 ? merge(
    { create = true }, local.endpoint.ip_aging, lookup(local.endpoints, "ip_aging", {})
    ) : local.rss.epctrl.ip_aging == false ? merge({ create = false }, local.endpoint.ip_aging
  ) : merge({ create = true }, local.endpoint.ip_aging)

  rouge_ep_control = local.rss.epctrl.rouge_ep_control == false && length(lookup(
    local.endpoints, "rouge_ep_control", {})) > 0 ? merge({ create = true }, local.endpoint.rouge_ep_control,
    lookup(local.endpoints, "rouge_ep_control", {})) : local.rss.epctrl.rouge_ep_control == false ? merge(
    { create = false }, local.endpoint.rouge_ep_control
  ) : merge({ create = true }, local.endpoint.rouge_ep_control)


  #__________________________________________________________
  #
  # System Settings => Fabric Wide Settings
  #__________________________________________________________

  fws = lookup(var.system_settings, "fabric_wide_settings", {})
  fabric_wide_settings = local.rss.fws == false && length(lookup(
    var.system_settings, "fabric_wide_settings", {})) > 0 ? merge({ create = true }, local.fwide,
    { ssl_opflex_versions = merge(local.fwide.ssl_opflex_versions, lookup(local.fws, "ssl_opflex_versions", {}))
    }) : local.rss.fws == false ? merge({ create = false }, local.fwide
  ) : merge({ create = true }, local.fwide)

}
