/*_____________________________________________________________________________________________________________________
API Information:
 - Class: "mgmtConnectivityPrefs"
 - Distinguished Named "uni/fabric/connectivityPrefs"
GUI Location:
 - System > System Settings > APIC Connectivity Preferences
_______________________________________________________________________________________________________________________
*/
resource "aci_mgmt_preference" "apic_connectivity_preference" {
  for_each       = { for v in lookup(local.system_settings, "apic_connectivity_preference", []) : "default" => v }
  annotation     = var.annotation
  interface_pref = each.value
}

/*_____________________________________________________________________________________________________________________
API Information:
 - Class: "bgpAsP"
 - Distinguished Name: "uni/fabric/bgpInstP-default"
GUI Location:
 - System > System Settings > BGP Route Reflector: {BGP_ASN}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "bgp_autonomous_system_number" {
  for_each   = { for v in lookup(local.system_settings, "bgp", []) : v.autonomous_system_number => v }
  class_name = "bgpAsP"
  dn         = "uni/fabric/bgpInstP-default/as"
  content = {
    # annotation = var.annotation
    asn = each.value.autonomous_system_number
  }
}


/*_____________________________________________________________________________________________________________________
API Information:
 - Class: "bgpRRNodePEp"
 - Distinguished Name: "uni/fabric/bgpInstP-default/rr/node-{Node_ID}"
GUI Location:
 - System > System Settings > BGP Route Reflector: Route Reflector Nodes
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "bgp_route_reflectors" {
  for_each   = local.bgp_route_reflectors
  class_name = "bgpRRNodePEp"
  dn         = "uni/fabric/bgpInstP-default/rr/node-${each.value.node_id}"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    id    = each.value.node_id
    podId = each.value.pod_id
  }
}

/*_____________________________________________________________________________________________________________________
API Information:
 - Class: "coopPol"
 - Distinguished Named "uni/fabric/pol-default"
GUI Location:
 - System > System Settings > Coop Group > Type
_______________________________________________________________________________________________________________________
*/
resource "aci_coop_policy" "coop_group" {
  for_each = { for v in ["default"] : "default" => v if length(local.coop_group) > 0 }
  annotation = length(compact([lookup(local.coop_group, "annotation", "")])
  ) > 0 ? local.coop_group.annotation : var.annotation
  description = lookup(local.coop_group, "description", "")
  type        = local.coop_group.type
}


/*_____________________________________________________________________________________________________________________
API Information:
 - Class: "epControlP"
 - Distinguished Name: "uni/infra/epCtrlP-default"
GUI Location:
 - System > System Settings > Rogue EP Control
_______________________________________________________________________________________________________________________
*/
resource "aci_endpoint_controls" "rouge_ep_control" {
  for_each = { for v in ["default"] : "default" => v if length(local.rouge_ep_control) > 0 }
  admin_st = lookup(local.rouge_ep_control, "administrative_state", local.rec.administrative_state)
  annotation = length(compact([lookup(local.endpoints, "annotation", "")])
  ) > 0 ? local.endpoints.annotation : var.annotation
  hold_intvl            = lookup(local.rouge_ep_control, "hold_interval", local.rec.hold_interval)
  rogue_ep_detect_intvl = lookup(local.rouge_ep_control, "rouge_interval", local.rec.rouge_interval)
  rogue_ep_detect_mult  = lookup(local.rouge_ep_control, "rouge_multiplier", local.rec.rouge_multiplier)
}

/*_____________________________________________________________________________________________________________________
API Information:
 - Class: "epIpAgingP"
 - Distinguished Name: "uni/infra/ipAgingP-default"
GUI Location:
 - System > System Settings > Endpoint Controls > Ip Aging
_______________________________________________________________________________________________________________________
*/
resource "aci_endpoint_ip_aging_profile" "ip_aging" {
  for_each = { for v in ["default"] : "default" => v if length(local.ip_aging) > 0 }
  admin_st = lookup(local.ip_aging, "administrative_state", local.ipa.administrative_state)
  annotation = length(compact([lookup(local.endpoints, "annotation", "")])
  ) > 0 ? local.endpoints.annotation : var.annotation
}

/*_____________________________________________________________________________________________________________________
API Information:
 - Class: "epLoopProtectP"
 - Distinguished Name: "uni/infra/epLoopProtectP-default"
GUI Location:
 - System > System Settings > Endpoint Controls > Ep Loop Protection
_______________________________________________________________________________________________________________________
*/
#resource "aci_rest_managed" "ep_loop_protection" {
#  for_each = {
#    for v in toset(
#      ["default"]
#    ) : "default" => v if local.recommended_settings.endpoint_controls == true
#  }
#  dn         = "uni/infra/epLoopProtectP-default"
#  class_name = "epLoopProtectP"
#  content = {
#    action = anytrue(
#      [
#        local.loop.action.bd_learn_disable,
#        local.loop.action.port_disable
#      ]
#      ) ? trim(join(",", compact(concat(
#        [length(regexall(true, local.loop.action.bd_learn_disable)
#          ) > 0 ? "bd-learn-disable" : ""
#          ], [length(regexall(true, local.loop.action.port_disable)
#        ) > 0 ? "port-disable" : ""]
#    ))), ",") : ""
#    adminSt = local.loop.administrative_state
#    # annotation = length(compact([local.endpoint.annotation])
#    # ) > 0 ? local.endpoint.annotation : var.annotation
#    loopDetectIntvl = local.loop.loop_detection_interval
#    loopDetectMult  = local.loop.loop_detection_multiplier
#  }
#}
resource "aci_endpoint_loop_protection" "ep_loop_protection" {
  for_each = { for v in ["default"] : "default" => v if local.ep_loop_protection.create == true }
  action = anytrue(
    [
      local.ep_loop_protection.action.bd_learn_disable,
      local.ep_loop_protection.action.port_disable
    ]
    ) ? compact(concat(
      [length(regexall(true, local.ep_loop_protection.action.bd_learn_disable)) > 0 ? "bd-learn-disable" : ""
      ], [length(regexall(true, local.ep_loop_protection.action.port_disable)) > 0 ? "port-disable" : ""]
  )) : []
  admin_st = local.ep_loop_protection.administrative_state
  annotation = length(compact([lookup(local.endpoints, "annotation", "")])
  ) > 0 ? local.endpoints.annotation : var.annotation
  loop_detect_intvl = local.ep_loop_protection.loop_detection_interval
  loop_detect_mult  = local.ep_loop_protection.loop_detection_multiplier
}

/*_____________________________________________________________________________________________________________________
API Information:
 - Class: "infraSetPol"
 - Distinguished Name: "uni/infra/settings"
GUI Location:
 - System > System Settings > Fabric Wide Settings
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "fabric_wide_settings" {
  for_each = { for v in ["default"] : "default" => v if local.fabric_wide_settings.create == true && length(
    regexall("(^[3-4]\\..*|^5.[0-1].*|^5.2\\([0-2].*\\))", var.apic_version)
  ) > 0 }
  class_name = "infraSetPol"
  dn         = "uni/infra/settings"
  content = {
    annotation = length(compact([local.fabric_wide_settings.annotation])
    ) > 0 ? local.fabric_wide_settings.annotation : var.annotation
    domainValidation           = local.fabric_wide_settings.enforce_domain_validation == true ? "yes" : "no"
    enforceSubnetCheck         = local.fabric_wide_settings.enforce_subnet_check == true ? "yes" : "no"
    opflexpAuthenticateClients = local.fabric_wide_settings.spine_opflex_client_authentication == true ? "yes" : "no"
    opflexpUseSsl              = local.fabric_wide_settings.spine_ssl_opflex == true ? "yes" : "no"
    reallocateGipo             = local.fabric_wide_settings.reallocate_gipo == true ? "yes" : "no"
    restrictInfraVLANTraffic   = local.fabric_wide_settings.restrict_infra_vlan_traffic == true ? "yes" : "no"
    unicastXrEpLearnDisable    = local.fabric_wide_settings.disable_remote_ep_learning == true ? "yes" : "no"
    validateOverlappingVlans   = local.fabric_wide_settings.enforce_epg_vlan_validation == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "fabric_wide_settings_5_2_3" {
  #for_each = { for v in ["default"] : "default" => v if local.fabric_wide_settings.create == true  }
  for_each = { for v in ["default"] : "default" => v if local.fabric_wide_settings.create == true && length(
    regexall("(^5\\.2\\(3[a-z]\\)|^5\\.2\\([4-9][a-z]\\)|^[6-9]\\.)", var.apic_version)
  ) > 0 }
  class_name = "infraSetPol"
  dn         = "uni/infra/settings"
  content = {
    # disableEpDampening     = 	each.value. # disable_ep_dampening
    # enableMoStreaming      = 	each.value.
    # enableRemoteLeafDirect = 	each.value.
    # policySyncNodeBringup  = 	each.value.
    domainValidation               = local.fabric_wide_settings.enforce_domain_validation == true ? "yes" : "no"
    enforceSubnetCheck             = local.fabric_wide_settings.enforce_subnet_check == true ? "yes" : "no"
    leafOpflexpAuthenticateClients = local.fabric_wide_settings.leaf_opflex_client_authentication == true ? "yes" : "no"
    leafOpflexpUseSsl              = local.fabric_wide_settings.leaf_ssl_opflex == true ? "yes" : "no"
    opflexpAuthenticateClients     = local.fabric_wide_settings.spine_opflex_client_authentication == true ? "yes" : "no"
    opflexpSslProtocols = anytrue(
      [
        local.fabric_wide_settings.ssl_opflex_versions.TLSv1,
        local.fabric_wide_settings.ssl_opflex_versions.TLSv1_1,
        local.fabric_wide_settings.ssl_opflex_versions.TLSv1_2
      ]
      ) ? replace(trim(join(",", concat([
        length(regexall(true, local.fabric_wide_settings.ssl_opflex_versions.TLSv1)) > 0 ? "TLSv1" : ""], [
        length(regexall(true, local.fabric_wide_settings.ssl_opflex_versions.TLSv1_1)) > 0 ? "TLSv1.1" : ""], [
        length(regexall(true, local.fabric_wide_settings.ssl_opflex_versions.TLSv1_2)) > 0 ? "TLSv1.2" : ""]
    )), ","), ",,", ",") : "TLSv1.1,TLSv1.2"
    opflexpUseSsl            = local.fabric_wide_settings.spine_ssl_opflex == true ? "yes" : "no"
    reallocateGipo           = local.fabric_wide_settings.reallocate_gipo == true ? "yes" : "no"
    restrictInfraVLANTraffic = local.fabric_wide_settings.restrict_infra_vlan_traffic == true ? "yes" : "no"
    unicastXrEpLearnDisable  = local.fabric_wide_settings.disable_remote_ep_learning == true ? "yes" : "no"
    validateOverlappingVlans = local.fabric_wide_settings.enforce_epg_vlan_validation == true ? "yes" : "no"
  }
}


/*_____________________________________________________________________________________________________________________
API Information:
 - Class: "pkiExportEncryptionKey"
 - Distinguished Name: "uni/exportcryptkey"
GUI Location:
 - System > System Settings > Global AES Passphrase Encryption Settings
_______________________________________________________________________________________________________________________
*/
resource "aci_encryption_key" "global_aes_passphrase" {
  for_each = {
    for v in ["default"] : "default" => v if length(local.global_aes_encryption_settings) > 0
  }
  annotation = length(compact([lookup(local.global_aes_encryption_settings, "annotation", local.aes.annotation
  )])) > 0 ? local.global_aes_encryption_settings.annotation : var.annotation
  clear_encryption_key = lookup(local.global_aes_encryption_settings, "clear_passphrase", local.aes.clear_passphrase
  ) == true ? "yes" : "no"
  description = lookup(local.global_aes_encryption_settings, "description", local.aes.description)
  passphrase  = var.aes_passphrase
  passphrase_key_derivation_version = lookup(
    local.global_aes_encryption_settings, "passphrase_key_derivation_version", local.aes.passphrase_key_derivation_version
  )
  strong_encryption_enabled = lookup(local.global_aes_encryption_settings, "enable_encryption", local.aes.enable_encryption
  ) == true ? "yes" : "no"
}

/*_____________________________________________________________________________________________________________________
API Information:
 - Class: "isisDomPol"
 - Distinguished Name: "uni/fabric/isisDomP-default"
GUI Location:
 - System > System Settings > ISIS Policy
_______________________________________________________________________________________________________________________
*/
resource "aci_isis_domain_policy" "isis_policy" {
  for_each = { for v in ["default"] : "default" => v if length(local.isis_policy) > 0 }
  annotation = length(compact([lookup(local.isis_policy, "annotation", local.isis.annotation)])
  ) > 0 ? local.isis_policy.annotation : var.annotation
  lsp_fast_flood     = lookup(local.isis_policy, "lsp_fast_flood_mode", local.isis.lsp_fast_flood_mode)
  lsp_gen_init_intvl = lookup(local.isis_policy, "lsp_generation_initial_wait_interval", local.isis.lsp_generation_initial_wait_interval)
  lsp_gen_max_intvl  = lookup(local.isis_policy, "lsp_generation_maximum_wait_interval", local.isis.lsp_generation_maximum_wait_interval)
  lsp_gen_sec_intvl  = lookup(local.isis_policy, "lsp_generation_second_wait_interval", local.isis.lsp_generation_second_wait_interval)
  mtu                = lookup(local.isis_policy, "isis_mtu", local.isis.isis_mtu)
  redistrib_metric = lookup(
    local.isis_policy, "isis_metric_for_redistributed_routes", local.isis.isis_metric_for_redistributed_routes
  )
  spf_comp_init_intvl = lookup(
    local.isis_policy, "sfp_computation_frequency_initial_wait_interval", local.isis.sfp_computation_frequency_initial_wait_interval
  )
  spf_comp_max_intvl = lookup(
    local.isis_policy, "sfp_computation_frequency_maximum_wait_interval", local.isis.sfp_computation_frequency_maximum_wait_interval
  )
  spf_comp_sec_intvl = lookup(
    local.isis_policy, "sfp_computation_frequency_second_wait_interval", local.isis.sfp_computation_frequency_second_wait_interval
  )
}


/*_____________________________________________________________________________________________________________________
API Information:
 - Class: "infraPortTrackPol"
 - Distinguished Name: "uni/infra/trackEqptFabP-default"
GUI Location:
 - System > System Settings > Port Tracking
_______________________________________________________________________________________________________________________
*/
resource "aci_port_tracking" "port_tracking" {
  for_each = { for v in ["default"] : "default" => v if length(local.port_tracking) > 0 }
  admin_st = lookup(local.port_tracking, "port_tracking_state", local.ptrack.port_tracking_state)
  annotation = length(compact([lookup(local.port_tracking, "annotation", local.ptrack.annotation)])
  ) > 0 ? local.port_tracking.annotation : var.annotation
  delay = lookup(local.port_tracking, "delay_restore_timer", local.ptrack.delay_restore_timer)
  include_apic_ports = lookup(
    local.port_tracking, "include_apic_ports", local.ptrack.include_apic_ports
  ) == true ? "yes" : "no"
  minlinks = lookup(local.port_tracking, "number_of_active_ports", local.ptrack.number_of_active_ports)
}


/*_____________________________________________________________________________________________________________________
API Information:
 - Class: "latencyPtpMode"
 - Distinguished Name: "uni/fabric/ptpmode"
GUI Location:
 - System > System Settings > PTP and Latency Measurement
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "ptp_and_latency_measurement" {
  for_each   = { for v in ["default"] : "default" => v if length(local.ptp_and_latency_measurement) > 0 }
  class_name = "latencyPtpMode"
  dn         = "uni/fabric/ptpmode"
  content = {
    annotation = length(compact([lookup(local.ptp_and_latency_measurement, "annotation", local.ptp.annotation)])
    ) > 0 ? local.ptp_and_latency_measurement.annotation : var.annotation
    fabAnnounceIntvl   = lookup(local.ptp_and_latency_measurement, "announce_interval", local.ptp.announce_interval)
    fabAnnounceTimeout = lookup(local.ptp_and_latency_measurement, "announce_timeout", local.ptp.announce_timeout)
    fabDelayIntvl      = lookup(local.ptp_and_latency_measurement, "delay_request_interval", local.ptp.delay_request_interval)
    fabProfileTemplate = length(regexall(
      "AES67-2015", lookup(local.ptp_and_latency_measurement, "ptp_profile", local.ptp.ptp_profile))
      ) > 0 ? "aes67" : length(regexall(
      "Default", lookup(local.ptp_and_latency_measurement, "ptp_profile", local.ptp.ptp_profile))
      ) > 0 ? "default" : length(regexall(
      "SMPTE-2059-2", lookup(local.ptp_and_latency_measurement, "ptp_profile", local.ptp.ptp_profile))
    ) > 0 ? "smtpe" : ""
    fabSyncIntvl = lookup(local.ptp_and_latency_measurement, "sync_interval", local.ptp.sync_interval)
    globalDomain = lookup(local.ptp_and_latency_measurement, "global_domain", local.ptp.global_domain)
    prio1        = lookup(local.ptp_and_latency_measurement, "global_priority_1", local.ptp.global_priority_1)
    prio2        = lookup(local.ptp_and_latency_measurement, "global_priority_2", local.ptp.global_priority_2)
    state        = lookup(local.ptp_and_latency_measurement, "precision_time_protocol", local.ptp.precision_time_protocol)
  }
}