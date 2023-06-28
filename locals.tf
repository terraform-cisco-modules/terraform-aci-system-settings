locals {
  defaults   = lookup(var.model, "defaults", {}).system_settings
  aes        = local.defaults.global_aes_encryption_settings
  coop_group = local.rs_coop_group == true ? local.defaults.coop_group : lookup(local.system_settings, "coop_group", {})
  endpoint   = local.defaults.endpoint_controls
  fwide      = local.defaults.fabric_wide_settings
  global_aes_encryption_settings = local.rs_global_aes == true ? local.aes : lookup(
    local.system_settings, "global_aes_encryption_settings", {}
  )
  isis          = local.defaults.isis_policy
  isis_policy   = local.rs_isis_policy == true ? local.isis : lookup(local.system_settings, "isis_policy", {})
  port_tracking = local.rs_port_tracking == true ? local.ptrack : lookup(local.system_settings, "port_tracking", {})
  ptp           = local.defaults.ptp_and_latency_measurement
  ptp_and_latency_measurement = local.rs_port_tracking == true ? local.ptp : lookup(
    local.system_settings, "ptp_and_latency_measurement", {}
  )
  ptrack = local.defaults.port_tracking
  recommended_settings = lookup(
    local.system_settings, "recommended_settings", {}
  )
  rec              = local.endpoint.rouge_ep_control
  rs_coop_group    = lookup(local.recommended_settings, "coop_group", false)
  rs_endpoint      = lookup(local.recommended_settings, "endpoint_controls", {})
  rs_ep_aging      = lookup(local.rs_endpoint, "ip_aging", false)
  rs_ep_loop       = lookup(local.rs_endpoint, "ep_loop_protection", false)
  rs_ep_rouge      = lookup(local.rs_endpoint, "rouge_ep_control", false)
  rs_fabric_wide   = lookup(local.recommended_settings, "fabric_wide_settings", false)
  rs_global_aes    = lookup(local.recommended_settings, "global_aes_encryption_settings", false)
  rs_isis_policy   = lookup(local.recommended_settings, "isis_policy", false)
  rs_port_tracking = lookup(local.recommended_settings, "port_tracking", false)
  rs_ptp           = lookup(local.recommended_settings, "ptp_and_latency_measurement", false)
  system_settings  = lookup(var.model, "system_settings", {})


  #__________________________________________________________
  #
  # BGP Variables
  #__________________________________________________________

  bgp_route_reflectors = {
    for i in flatten([
      for v in lookup(lookup(local.system_settings, "bgp_route_reflector", {}), "pods", []) : [
        for s in v.route_reflector_nodes : {
          annotation = var.annotation
          node_id    = s
          pod_id     = v.pod_id
        }
      ]
    ]) : "Pod-${i.pod_id}:Node-${i.node_id}" => i
  }


  #__________________________________________________________
  #
  # System Settings => Endpoint Controls
  #__________________________________________________________

  endpoints = lookup(local.system_settings, "endpoint_controls", {})
  epcl      = lookup(lookup(local.system_settings, "endpoint_controls", {}), "ep_loop_protection", {})
  ep_loop_protection = local.rs_ep_loop == false && length(lookup(lookup(
    local.system_settings, "endpoint_controls", {}), "ep_loop_protection", {})) > 0 ? {
    action = {
      bd_learn_disable = lookup(lookup(local.epcl, "action", {}), "bd_learn_disable", local.epl.action.bd_learn_disable)
      port_disable     = lookup(lookup(local.epcl, "action", {}), "port_disable", local.epl.action.port_disable)
    }
    administrative_state      = lookup(local.epcl, "administrative_state", local.epl.administrative_state)
    create                    = true
    loop_detection_interval   = lookup(local.epcl, "loop_detection_interval", local.epl.loop_detection_interval)
    loop_detection_multiplier = lookup(local.epcl, "loop_detection_multiplier", local.epl.loop_detection_multiplier)
    } : local.rs_ep_loop == false ? merge({ create = false }, local.endpoint.ep_loop_protection) : merge(
    { create = true }, local.endpoint.ep_loop_protection
  )
  epl = local.endpoint.ep_loop_protection
  ipa = local.endpoint.ip_aging
  ip_aging = local.rs_ep_aging == false ? lookup(
    lookup(local.system_settings, "endpoint_controls", {}), "ip_aging", {}
  ) : local.endpoint.ip_aging
  rouge_ep_control = local.rs_ep_rouge == false ? lookup(
    lookup(local.system_settings, "endpoint_controls", {}), "rouge_ep_control", {}
  ) : local.defaults.endpoint_controls.rouge_ep_control


  #__________________________________________________________
  #
  # System Settings => Fabric Wide Settings
  #__________________________________________________________

  fws = lookup(local.system_settings, "fabric_wide_settings", {})
  fabric_wide_settings = local.rs_fabric_wide == false && length(local.fws) > 0 ? {
    annotation                        = lookup(local.fws, "annotation", local.fwide.annotation)
    create                            = true
    disable_remote_ep_learning        = lookup(local.fws, "disable_remote_ep_learning", local.fwide.disable_remote_ep_learning)
    enforce_domain_validation         = lookup(local.fws, "enforce_domain_validation", local.fwide.enforce_domain_validation)
    enforce_epg_vlan_validation       = lookup(local.fws, "enforce_epg_vlan_validation", local.fwide.enforce_epg_vlan_validation)
    enforce_subnet_check              = lookup(local.fws, "enforce_subnet_check", local.fwide.enforce_subnet_check)
    leaf_opflex_client_authentication = lookup(local.fws, "leaf_opflex_client_authentication", local.fwide.leaf_opflex_client_authentication)
    leaf_ssl_opflex                   = lookup(local.fws, "leaf_ssl_opflex", local.fwide.leaf_ssl_opflex)
    reallocate_gipo                   = lookup(local.fws, "reallocate_gipo", local.fwide.reallocate_gipo)
    restrict_infra_vlan_traffic       = lookup(local.fws, "restrict_infra_vlan_traffic", local.fwide.restrict_infra_vlan_traffic)
    ssl_opflex_versions = {
      TLSv1   = lookup(lookup(local.fws, "ssl_opflex_versions", {}), "TLSv1", local.fwide.ssl_opflex_versions.TLSv1)
      TLSv1_1 = lookup(lookup(local.fws, "ssl_opflex_versions", {}), "TLSv1_1", local.fwide.ssl_opflex_versions.TLSv1_1)
      TLSv1_2 = lookup(lookup(local.fws, "ssl_opflex_versions", {}), "TLSv1_2", local.fwide.ssl_opflex_versions.TLSv1_2)
    }
    spine_opflex_client_authentication = lookup(local.fws, "spine_opflex_client_authentication", local.fwide.spine_opflex_client_authentication)
    spine_ssl_opflex                   = lookup(local.fws, "spine_ssl_opflex", local.fwide.spine_ssl_opflex)
    } : local.rs_fabric_wide == false ? merge({ create = false }, local.fwide) : merge({ create = true }, local.fwide
  )

}
