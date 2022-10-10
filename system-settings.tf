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
  annotation     = local.defaults.annotation
  interface_pref = each.value.interface_to_use_for_external_connections
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
  for_each   = { for v in lookup(local.system_settings, "bgp_route_reflector", []) : "default" => v }
  class_name = "bgpAsP"
  dn         = "uni/fabric/bgpInstP-default/as"
  content = {
    # annotation = local.defaults.annotation
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
    # annotation = each.value.annotation != "" ? each.value.annotation : local.defaults.annotation
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
resource "aci_coop_policy" "coop_group_policy" {
  for_each = {
    for v in lookup(local.system_settings, "recommended_settings", []) : "default" => v if v.coop_group == true
  }
  annotation = length(compact([local.coop_group.annotation])
  ) > 0 ? local.coop_group.annotation : local.defaults.annotation
  type = local.coop_group.type
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
  for_each = {
    for v in lookup(
      local.system_settings, "recommended_settings", []
    ) : "default" => v if v.endpoint_controls == true
  }
  admin_st = local.endpoint_controls.rouge_ep_control.administrative_state
  annotation = length(compact([local.endpoint_controls.annotation])
  ) > 0 ? local.endpoint_controls.annotation : local.defaults.annotation
  hold_intvl            = local.endpoint_controls.rouge_ep_control.hold_interval
  rogue_ep_detect_intvl = local.endpoint_controls.rouge_ep_control.rouge_interval
  rogue_ep_detect_mult  = local.endpoint_controls.rouge_ep_control.rouge_multiplier
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
  for_each = {
    for v in lookup(
      local.system_settings, "recommended_settings", []
    ) : "default" => v if v.endpoint_controls == true
  }
  admin_st = local.endpoint_controls.ip_aging.administrative_state
  annotation = length(compact([local.endpoint_controls.annotation])
  ) > 0 ? local.endpoint_controls.annotation : local.defaults.annotation
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "epLoopProtectP"
 - Distinguished Name: "uni/infra/epLoopProtectP-default"
GUI Location:
 - System > System Settings > Endpoint Controls > Ep Loop Protection
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "ep_loop_protection" {
  for_each = {
    for v in lookup(
      local.system_settings, "recommended_settings", []
    ) : "default" => v if v.endpoint_controls == true
  }
  dn         = "uni/infra/epLoopProtectP-default"
  class_name = "epLoopProtectP"
  content = {
    action = anytrue(
      [
        local.endpoint_controls.ep_loop_protection.bd_learn_disable,
        local.endpoint_controls.ep_loop_protection.port_disable
      ]
      ) ? trim(join(",", compact(concat(
        [length(regexall(true, local.endpoint_controls.ep_loop_protection.bd_learn_disable)
          ) > 0 ? "bd-learn-disable" : ""
          ], [length(regexall(true, local.endpoint_controls.ep_loop_protection.port_disable)
        ) > 0 ? "port-disable" : ""]
    ))), ",") : ""
    adminSt = local.endpoint_controls.ep_loop_protection.administrative_state
    # annotation = length(compact([local.endpoint_controls.annotation])
    # ) > 0 ? local.endpoint_controls.annotation : local.defaults.annotation
    loopDetectIntvl = local.endpoint_controls.ep_loop_protection.loop_detection_interval
    loopDetectMult  = local.endpoint_controls.ep_loop_protection.loop_detection_multiplier
  }
}
# resource "aci_endpoint_loop_protection" "ep_loop_protection" {
#   for_each = {
#     for v in lookup(local.system_settings, "recommended_settings", []) : "default" => v if v.endpoint_controls == true
#   }
#   action = anytrue(
#     [
#       local.endpoint_controls.ep_loop_protection.bd_learn_disable,
#       local.endpoint_controls.ep_loop_protection.port_disable
#     ]
#     ) ? trim(join(",", compact(concat(
#       [length(regexall(true, local.endpoint_controls.ep_loop_protection.bd_learn_disable)) > 0 ? "bd-learn-disable" : ""
#       ], [length(regexall(true, local.endpoint_controls.ep_loop_protection.port_disable)) > 0 ? "port-disable" : ""]
#   ))), ",") : ""
#   admin_st          = local.endpoint_controls.ep_loop_protection.administrative_state
#   annotation = length(compact([local.endpoint_controls.annotation])
#   ) > 0 ? local.endpoint_controls.annotation : local.defaults.annotation
#   loop_detect_intvl = local.endpoint_controls.ep_loop_protection.loop_detection_interval
#   loop_detect_mult  = local.endpoint_controls.ep_loop_protection.loop_detection_multiplier
# }

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraSetPol"
 - Distinguished Name: "uni/infra/settings"
GUI Location:
 - System > System Settings > Fabric Wide Settings
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "fabric_wide_settings" {
  for_each = {
    for v in lookup(local.system_settings, "recommended_settings", []
      ) : "default" => v if v.fabric_wide_settings == true && length(regexall(
      "(^[3-4]\\..*|^5.[0-1].*|^5.2\\([0-2].*\\))", local.defaults.apic_version)
    ) > 0
  }
  class_name = "infraSetPol"
  dn         = "uni/infra/settings"
  content = {
    annotation = length(compact([local.fabric_wide_settings.annotation])
    ) > 0 ? local.fabric_wide_settings.annotation : local.defaults.annotation
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
  for_each = {
    for v in lookup(local.system_settings, "recommended_settings", []
      ) : "default" => v if v.fabric_wide_settings == true && length(
      regexall("(5\\.2(3[a-z])|^[7-9]\\.)", local.defaults.apic_version)
    ) > 0
  }
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

Global AES Encryption Setting — Variables
_______________________________________________________________________________________________________________________
*/
variable "aes_passphrase" {
  description = "Global AES Passphrase."
  sensitive   = true
  type        = string
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
    for v in lookup(
      local.system_settings, "recommended_settings", []
    ) : "default" => v if v.global_aes_encryption_settings == true
  }
  clear_encryption_key              = local.global_aes_encryption_settings.clear_passphrase == true ? "yes" : "no"
  passphrase                        = var.aes_passphrase
  passphrase_key_derivation_version = local.global_aes_encryption_settings.passphrase_key_derivation_version # "v1"
  strong_encryption_enabled         = local.global_aes_encryption_settings.enable_encryption == true ? "yes" : "no"
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
  for_each = {
    for v in lookup(local.system_settings, "recommended_settings", []) : "default" => v if v.isis_policy == true
  }
  annotation = length(compact([local.isis_policy.annotation])
  ) > 0 ? local.isis_policy.annotation : local.defaults.annotation
  lsp_fast_flood      = local.isis_policy.lsp_fast_flood_mode
  lsp_gen_init_intvl  = local.isis_policy.lsp_generation_initial_wait_interval
  lsp_gen_max_intvl   = local.isis_policy.lsp_generation_maximum_wait_interval
  lsp_gen_sec_intvl   = local.isis_policy.lsp_generation_second_wait_interval
  mtu                 = local.isis_policy.isis_mtu
  redistrib_metric    = local.isis_policy.isis_metric_for_redistributed_routes
  spf_comp_init_intvl = local.isis_policy.sfp_computation_frequency_initial_wait_interval
  spf_comp_max_intvl  = local.isis_policy.sfp_computation_frequency_maximum_wait_interval
  spf_comp_sec_intvl  = local.isis_policy.sfp_computation_frequency_second_wait_interval
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
  for_each = {
    for v in lookup(
      local.system_settings, "recommended_settings", []
    ) : "default" => v if v.isis_policy == true
  }
  annotation = length(compact([local.port_tracking.annotation])
  ) > 0 ? local.port_tracking.annotation : local.defaults.annotation
  admin_st           = local.port_tracking.port_tracking_state
  delay              = local.port_tracking.delay_restore_timer
  include_apic_ports = local.port_tracking.include_apic_ports == true ? "yes" : "no"
  minlinks           = local.port_tracking.number_of_active_ports
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
  for_each = {
    for v in lookup(
      local.system_settings, "recommended_settings", []
    ) : "default" => v if v.ptp_and_latency_measurement == true
  }
  class_name = "latencyPtpMode"
  dn         = "uni/fabric/ptpmode"
  content = {
    annotation = length(compact([local.ptp_and_latency_measurement.annotation])
    ) > 0 ? local.ptp_and_latency_measurement.annotation : local.defaults.annotation
    fabAnnounceIntvl   = local.ptp_and_latency_measurement.announce_interval
    fabAnnounceTimeout = local.ptp_and_latency_measurement.announce_timeout
    fabDelayIntvl      = local.ptp_and_latency_measurement.delay_request_interval
    fabProfileTemplate = length(
      regexall("AES67-2015", local.ptp_and_latency_measurement.ptp_profile)) > 0 ? "aes67" : length(
      regexall("Default", local.ptp_and_latency_measurement.ptp_profile)) > 0 ? "default" : length(
      regexall("SMPTE-2059-2", local.ptp_and_latency_measurement.ptp_profile)
    ) > 0 ? "smtpe" : ""
    fabSyncIntvl = local.ptp_and_latency_measurement.sync_interval
    globalDomain = local.ptp_and_latency_measurement.global_domain
    prio1        = local.ptp_and_latency_measurement.global_priority_1
    prio2        = local.ptp_and_latency_measurement.global_priority_2
    state        = local.ptp_and_latency_measurement.precision_time_protocol
  }
}