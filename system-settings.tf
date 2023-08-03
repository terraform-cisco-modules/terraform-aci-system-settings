/*_____________________________________________________________________________________________________________________
API Information:
 - Class: "mgmtConnectivityPrefs"
 - Distinguished Named "uni/fabric/connectivityPrefs"
GUI Location:
 - System > System Settings > APIC Connectivity Preferences
_______________________________________________________________________________________________________________________
*/
resource "aci_mgmt_preference" "apic_connectivity_preference" {
  for_each       = { for v in lookup(var.system_settings, "apic_connectivity_preference", []) : "default" => v }
  annotation     = "orchestrator:terraform"
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
  for_each   = { for v in [lookup(var.system_settings, "bgp_route_reflector", {})] : v.autonomous_system_number => v }
  class_name = "bgpAsP"
  dn         = "uni/fabric/bgpInstP-default/as"
  content = {
    #annotation = "orchestrator:terraform"
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
resource "aci_rest_managed" "route_reflector_nodes" {
  for_each   = local.route_reflector_nodes
  class_name = "bgpRRNodePEp"
  dn         = "uni/fabric/bgpInstP-default/rr/node-${each.value.node_id}"
  content = {
    #annotation = "orchestrator:terraform"
    id    = each.value.node_id
    podId = each.value.pod_id
  }
}

resource "aci_rest" "bgp_instance" {
  for_each = { for v in ["default"] : v => merge(
    local.defaults.bgp_route_reflector, lookup(var.system_settings, "bgp_route_reflector", {})
  ) if length(lookup(var.system_settings, "bgp_route_reflector", {})) > 0 }
  class_name = "bgpInstPol"
  path       = "/api/mo/uni/fabric/bgpInstP-default.json"
  content = {
    annotation = "orchestrator:terraform"
    descr      = each.value.description
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
  for_each    = { for v in [local.coop_group] : "default" => v if v.create == true || v.create == "true" }
  annotation  = "orchestrator:terraform"
  description = each.value.description
  type        = each.value.type
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
  for_each = { for v in [local.rouge_ep_control] : "default" => v if v.create == true || v.create == "true" }
  admin_st = each.value.administrative_state
  #description           = each.value.description
  hold_intvl            = each.value.hold_interval
  rogue_ep_detect_intvl = each.value.rouge_interval
  rogue_ep_detect_mult  = each.value.rouge_multiplier
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
  for_each = { for v in [local.ip_aging] : "default" => v if v.create == true || v.create == "true" }
  admin_st = lookup(local.ip_aging, "administrative_state", local.ipa.administrative_state)
}

/*_____________________________________________________________________________________________________________________
API Information:
 - Class: "epLoopProtectP"
 - Distinguished Name: "uni/infra/epLoopProtectP-default"
GUI Location:
 - System > System Settings > Endpoint Controls > Ep Loop Protection
_______________________________________________________________________________________________________________________
*/
resource "aci_endpoint_loop_protection" "ep_loop_protection" {
  for_each = { for v in [local.ep_loop_protection] : "default" => v if v.create == true }
  action = anytrue(
    [
      each.value.action.bd_learn_disable,
      each.value.action.port_disable
    ]
    ) ? compact(concat(
      [length(regexall(true, each.value.action.bd_learn_disable)) > 0 ? "bd-learn-disable" : ""
      ], [length(regexall(true, each.value.action.port_disable)) > 0 ? "port-disable" : ""]
  )) : []
  admin_st          = each.value.administrative_state
  loop_detect_intvl = each.value.loop_detection_interval
  loop_detect_mult  = each.value.loop_detection_multiplier
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
  for_each = { for v in [local.fabric_wide_settings] : "default" => v if v.create == true && length(
    regexall("(^[3-4]\\..*|^5.[0-1].*|^5.2\\([0-2].*\\))", var.apic_version)
  ) > 0 || v.create == "true" && length(regexall("(^[3-4]\\..*|^5.[0-1].*|^5.2\\([0-2].*\\))", var.apic_version)) > 0 }
  class_name = "infraSetPol"
  dn         = "uni/infra/settings"
  content = {
    #annotation                 = "orchestrator:terraform"
    domainValidation           = each.value.enforce_domain_validation == true ? "yes" : "no"
    enforceSubnetCheck         = each.value.enforce_subnet_check == true ? "yes" : "no"
    opflexpAuthenticateClients = each.value.spine_opflex_client_authentication == true ? "yes" : "no"
    opflexpUseSsl              = each.value.spine_ssl_opflex == true ? "yes" : "no"
    reallocateGipo             = each.value.reallocate_gipo == true ? "yes" : "no"
    restrictInfraVLANTraffic   = each.value.restrict_infra_vlan_traffic == true ? "yes" : "no"
    unicastXrEpLearnDisable    = each.value.disable_remote_ep_learning == true ? "yes" : "no"
    validateOverlappingVlans   = each.value.enforce_epg_vlan_validation == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "fabric_wide_settings_5_2_3" {
  for_each = { for v in [local.fabric_wide_settings] : "default" => v if v.create == true && length(
    regexall("(^5\\.2\\(3[a-z]\\)|^5\\.2\\([4-9][a-z]\\)|^[6-9]\\.)", var.apic_version)
    ) > 0 || v.create == "true" && length(
    regexall("(^5\\.2\\(3[a-z]\\)|^5\\.2\\([4-9][a-z]\\)|^[6-9]\\.)", var.apic_version)
  ) > 0 }
  class_name = "infraSetPol"
  dn         = "uni/infra/settings"
  content = {
    # disableEpDampening     = 	each.value. # disable_ep_dampening
    # enableMoStreaming      = 	each.value.
    # enableRemoteLeafDirect = 	each.value.
    # policySyncNodeBringup  = 	each.value.
    #annotation                     = "orchestrator:terraform"
    domainValidation               = each.value.enforce_domain_validation == true ? "yes" : "no"
    enforceSubnetCheck             = each.value.enforce_subnet_check == true ? "yes" : "no"
    leafOpflexpAuthenticateClients = each.value.leaf_opflex_client_authentication == true ? "yes" : "no"
    leafOpflexpUseSsl              = each.value.leaf_ssl_opflex == true ? "yes" : "no"
    opflexpAuthenticateClients     = each.value.spine_opflex_client_authentication == true ? "yes" : "no"
    opflexpSslProtocols = anytrue(
      [
        each.value.ssl_opflex_versions.TLSv1,
        each.value.ssl_opflex_versions.TLSv1_1,
        each.value.ssl_opflex_versions.TLSv1_2
      ]
      ) ? replace(trim(join(",", concat([
        length(regexall(true, each.value.ssl_opflex_versions.TLSv1)) > 0 ? "TLSv1" : ""], [
        length(regexall(true, each.value.ssl_opflex_versions.TLSv1_1)) > 0 ? "TLSv1.1" : ""], [
        length(regexall(true, each.value.ssl_opflex_versions.TLSv1_2)) > 0 ? "TLSv1.2" : ""]
    )), ","), ",,", ",") : "TLSv1.1,TLSv1.2"
    opflexpUseSsl            = each.value.spine_ssl_opflex == true ? "yes" : "no"
    reallocateGipo           = each.value.reallocate_gipo == true ? "yes" : "no"
    restrictInfraVLANTraffic = each.value.restrict_infra_vlan_traffic == true ? "yes" : "no"
    unicastXrEpLearnDisable  = each.value.disable_remote_ep_learning == true ? "yes" : "no"
    validateOverlappingVlans = each.value.enforce_epg_vlan_validation == true ? "yes" : "no"
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
  for_each            = { for v in [local.isis_policy] : "default" => v if v.create == true }
  lsp_fast_flood      = each.value.lsp_fast_flood_mode
  lsp_gen_init_intvl  = each.value.lsp_generation_initial_wait_interval
  lsp_gen_max_intvl   = each.value.lsp_generation_maximum_wait_interval
  lsp_gen_sec_intvl   = each.value.lsp_generation_second_wait_interval
  mtu                 = each.value.isis_mtu
  redistrib_metric    = each.value.isis_metric_for_redistributed_routes
  spf_comp_init_intvl = each.value.sfp_computation_frequency_initial_wait_interval
  spf_comp_max_intvl  = each.value.sfp_computation_frequency_maximum_wait_interval
  spf_comp_sec_intvl  = each.value.sfp_computation_frequency_second_wait_interval
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
  for_each           = { for v in [local.port_tracking] : "default" => v if v.create == true }
  admin_st           = each.value.port_tracking_state == true ? "on" : "off"
  delay              = each.value.delay_restore_timer
  include_apic_ports = each.value.include_apic_ports == true ? "yes" : "no"
  minlinks           = each.value.number_of_active_ports
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
    #annotation         = "orchestrator:terraform"
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