/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraAccPortP"
 - Distinguished Name: "uni/infra/accportprof-{name}"
GUI Location:
 - Fabric > Access Policies > Interfaces > Leaf Interfaces > Profiles > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_leaf_interface_profile" "leaf_interface_profiles" {
  for_each    = { for k, v in local.switch_profiles : k => v if v.node_type != "spine" }
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.value.name
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraLeafS"
 - Distinguished Name: "uni/infra/nprof-{Name}"
GUI Location:
 - Fabric > Access Policies > Switches > Leaf Switches > Profiles > {Name}
_______________________________________________________________________________________________________________________
*/
resource "aci_leaf_profile" "leaf_profiles" {
  depends_on = [
    aci_leaf_interface_profile.leaf_interface_profiles
  ]
  for_each    = { for k, v in local.switch_profiles : k => v if v.node_type != "spine" }
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.value.name
  relation_infra_rs_acc_port_p = [
    aci_leaf_interface_profile.leaf_interface_profiles[each.key].id
  ]
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraLeafS"
 - Class: "infraRsAccNodePGrp"
 - Distinguished Name: "uni/infra/nprof-{name}/leaves-{selector_name}-typ-range"
GUI Location:
 - Fabric > Access Policies > Switches > Leaf Switches > Profiles > {name}: Leaf Selectors Policy Group: {selector_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_leaf_selector" "leaf_selectors" {
  depends_on = [
    aci_leaf_profile.leaf_profiles,
  ]
  for_each                         = { for k, v in local.switch_profiles : k => v if v.node_type != "spine" }
  annotation                       = each.value.annotation != "" ? each.value.annotation : var.annotation
  description                      = each.value.description
  leaf_profile_dn                  = aci_leaf_profile.leaf_profiles[each.key].id
  name                             = each.value.name
  relation_infra_rs_acc_node_p_grp = "uni/infra/funcprof/accnodepgrp-${each.value.policy_group}"
  switch_association_type          = "range"
}

resource "aci_node_block" "leaf_profile_blocks" {
  depends_on = [
    aci_leaf_selector.leaf_selectors
  ]
  for_each              = { for k, v in local.switch_profiles : k => v if v.node_type != "spine" }
  annotation            = each.value.annotation != "" ? each.value.annotation : var.annotation
  description           = each.value.description
  from_                 = each.key
  name                  = "blk${each.key}-${each.key}"
  switch_association_dn = aci_leaf_selector.leaf_selectors[each.key].id
  to_                   = each.key
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraSpAccPortP"
 - Distinguished Name: "uni/infra/spaccportprof-{name}"
GUI Location:
 - Fabric > Access Policies > Interfaces > Spine Interfaces > Profiles > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_spine_interface_profile" "spine_interface_profiles" {
  for_each    = { for k, v in local.switch_profiles : k => v if v.node_type == "spine" }
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.value.name
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraSpineS"
 - Distinguished Name: "uni/infra/nprof-{Name}"
GUI Location:
 - Fabric > Access Policies > Switches > Spine Switches > Profiles > {Name}
_______________________________________________________________________________________________________________________
*/
resource "aci_spine_profile" "spine_profiles" {
  depends_on = [
    aci_spine_interface_profile.spine_interface_profiles
  ]
  for_each    = { for k, v in local.switch_profiles : k => v if v.node_type == "spine" }
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.value.name
  relation_infra_rs_sp_acc_port_p = [
    aci_spine_interface_profile.spine_interface_profiles[each.key].id
  ]
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraSpineS"
 - Distinguished Name: "uni/infra/spprof-{name}/spines-{name}-typ-range"
GUI Location:
 - Fabric > Access Policies > Switches > Spine Switches > Profiles > {name}: Spine Selectors [{name}]
_______________________________________________________________________________________________________________________
*/
resource "aci_spine_switch_association" "spine_profiles" {
  depends_on = [
    aci_spine_profile.spine_profiles,
  ]
  for_each                               = { for k, v in local.switch_profiles : k => v if v.node_type == "spine" }
  annotation                             = each.value.annotation != "" ? each.value.annotation : var.annotation
  spine_profile_dn                       = aci_spine_profile.spine_profiles[each.key].id
  description                            = each.value.description
  name                                   = each.value.name
  relation_infra_rs_spine_acc_node_p_grp = "uni/infra/funcprof/spaccnodepgrp-${each.value.policy_group}"
  spine_switch_association_type          = "range"
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraNodeBlk"
 - Distinguished Name: "uni/infra/spprof-{name}/spines-{name}-typ-range/nodeblk-blk{node_id}-{node_id}"
GUI Location:
 - Fabric > Access Policies > Switches > Spine Switches > Profiles > {name}: Spine Selectors [{name}]
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "spine_profile_node_blocks" {
  depends_on = [
    aci_spine_profile.spine_profiles,
    aci_spine_switch_association.spine_profiles
  ]
  for_each   = { for k, v in local.switch_profiles : k => v if v.node_type == "spine" }
  dn         = "uni/infra/spprof-${each.value.name}/spines-${each.value.name}-typ-range/nodeblk-blk${each.key}-${each.key}"
  class_name = "infraNodeBlk"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    from_ = each.key
    to_   = each.key
    name  = "blk${each.key}-${each.key}"
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraHPortS"
 - Distinguished Name: "uni/infra/accportprof-{interface_profile}/hports-{interface_selector}-typ-range"
GUI Location:
 - Fabric > Access Policies > Interfaces > Leaf Interfaces > Profiles > {interface_profile}:{interface_selector}
_______________________________________________________________________________________________________________________
*/
resource "aci_access_port_selector" "leaf_interface_selectors" {
  depends_on = [
    aci_leaf_interface_profile.leaf_interface_profiles,
  ]
  for_each                  = { for k, v in local.interface_selectors : k => v if v.node_type != "spine" }
  leaf_interface_profile_dn = aci_leaf_interface_profile.leaf_interface_profiles[each.value.key1].id
  annotation                = each.value.annotation != "" ? each.value.annotation : var.annotation
  description               = each.value.description
  name                      = each.value.interface_name
  access_port_selector_type = "range"
  relation_infra_rs_acc_base_grp = length(regexall(
    "access", each.value.policy_group_type)) > 0 && length(compact([each.value.policy_group])
    ) > 0 ? "uni/infra/funcprof/accportgrp-${each.value.policy_group}" : length(regexall(
    "breakout", each.value.policy_group_type)) > 0 && length(compact([each.value.policy_group])
    ) > 0 ? "uni/infra/funcprof/brkoutportgrp-${each.value.policy_group}" : length(regexall(
    "bundle", each.value.policy_group_type)) > 0 && length(compact([each.value.policy_group])
  ) > 0 ? "uni/infra/funcprof/accbundle-${each.value.policy_group}" : ""
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraPortBlk"
 - Distinguished Name: " uni/infra/accportprof-{interface_profile}/hports-{interface_selector}-typ-range/portblk-{interface_selector}"
GUI Location:
 - Fabric > Access Policies > Interfaces > Leaf Interfaces > Profiles > {interface_profile}:{interface_selector}
_______________________________________________________________________________________________________________________
*/
resource "aci_access_port_block" "leaf_port_blocks" {
  depends_on = [
    aci_leaf_interface_profile.leaf_interface_profiles,
    aci_access_port_selector.leaf_interface_selectors
  ]
  for_each                = { for k, v in local.interface_selectors : k => v if v.sub_port == "" && v.node_type != "spine" }
  access_port_selector_dn = aci_access_port_selector.leaf_interface_selectors[each.key].id
  annotation              = each.value.annotation != "" ? each.value.annotation : var.annotation
  description             = each.value.interface_description
  from_card               = each.value.module
  from_port               = each.value.port
  name                    = each.value.interface_name
  to_card                 = each.value.module
  to_port                 = each.value.port
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraPortBlk"
 - Distinguished Name: " uni/infra/accportprof-{interface_profile}/hports-{interface_selector}-typ-{selector_type}/portblk-{interface_selector}"
GUI Location:
 - Fabric > Access Policies > Interfaces > Leaf Interfaces > Profiles > {interface_profile}:{interface_selector}
_______________________________________________________________________________________________________________________
*/
resource "aci_access_sub_port_block" "leaf_port_subblocks" {
  depends_on = [
    aci_leaf_interface_profile.leaf_interface_profiles,
    aci_access_port_selector.leaf_interface_selectors
  ]
  for_each                = { for k, v in local.interface_selectors : k => v if v.sub_port != "" && v.node_type != "spine" }
  access_port_selector_dn = aci_access_port_selector.leaf_interface_selectors[each.key].id
  annotation              = each.value.annotation != "" ? each.value.annotation : var.annotation
  description             = each.value.interface_description
  from_card               = each.value.module
  from_port               = each.value.port
  from_sub_port           = each.value.sub_port
  name                    = each.value.interface_name
  to_card                 = each.value.module
  to_port                 = each.value.port
  to_sub_port             = each.value.sub_port
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraHPortS"
 - Distinguished Name: "uni/infra/accportprof-{interface_profile}/hports-{interface_selector}-typ-range"
GUI Location:
 - Fabric > Access Policies > Interfaces > Spine Interfaces > Profiles > {interface_profile}:{interface_selector}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "spine_interface_selectors" {
  depends_on = [
    aci_spine_interface_profile.spine_interface_profiles
  ]
  for_each   = { for k, v in local.interface_selectors : k => v if v.node_type == "spine" }
  dn         = "uni/infra/spaccportprof-${each.value.name}/shports-${each.value.interface_name}-typ-range"
  class_name = "infraSHPortS"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    name  = each.value.interface_name
    descr = each.value.description
  }
  child {
    rn         = "portblk-${each.value.interface_name}"
    class_name = "infraPortBlk"
    content = {
      fromCard = each.value.module
      fromPort = each.value.port
      toCard   = each.value.module
      toPort   = each.value.port
      name     = each.value.interface_name
    }
  }
}

resource "aci_rest_managed" "spine_interface_policy_group" {
  depends_on = [
    aci_spine_interface_profile.spine_interface_profiles
  ]
  for_each   = { for k, v in local.interface_selectors : k => v if v.node_type == "spine" && v.policy_group != "" }
  dn         = "uni/infra/spaccportprof-${each.value.name}/shports-${each.value.interface_name}-typ-range/rsspAccGrp"
  class_name = "infraRsSpAccGrp"
  content = {
    tDn = length(compact([each.value.policy_group])
    ) > 0 ? "uni/infra/funcprof/spaccportgrp-${each.value.policy_group}" : ""
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mgmtRsInBStNode" or "mgmtRsOoBStNode"
 - Distinguished Name: "uni/tn-mgmt/mgmtp-default/inb-{management_epg}/rsinBStNode-[topology/pod-{pod_id}/node-{node_id}]"
 or
 - Distinguished Name: "uni/tn-mgmt/mgmtp-default/oob-{management_epg}/rsooBStNode-[topology/pod-{pod_id}/node-{node_id}]"
GUI Location:
 - Tenants > mgmt > Node Management Addresses > Static Node Management Addresses
_______________________________________________________________________________________________________________________
*/
resource "aci_static_node_mgmt_address" "static_node_mgmt_addresses" {
  depends_on = [
    aci_rest_managed.fabric_membership
  ]
  for_each   = local.static_node_mgmt_addresses
  addr       = each.value.ipv4_address
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  # description       = each.value.description
  gw                = each.value.ipv4_gateway
  management_epg_dn = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
  t_dn              = "topology/pod-${each.value.pod_id}/node-${each.value.node_id}"
  type              = each.value.management_epg_type == "inb" ? "in_band" : "out_of_band"
  v6_addr           = each.value.ipv6_address
  v6_gw             = each.value.ipv6_gateway
}
