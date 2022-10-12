/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricNodeIdentP"
 - Distinguished Name: "uni/controller/nodeidentpol/nodep-{serial_number}"
GUI Location:
 - Fabric > Access Policies > Inventory > Fabric Membership:[Registered Nodes or Nodes Pending Registration]
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "fabric_membership" {
  for_each   = local.switch_profiles
  dn         = "uni/controller/nodeidentpol/nodep-${each.value.serial_number}"
  class_name = "fabricNodeIdentP"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    extPoolId = each.value.node_type == "remote-leaf" ? each.value.external_pool_id : 0
    name      = each.value.name
    nodeId    = each.key
    nodeType = length(regexall(
      "remote-leaf", each.value.node_type)) > 0 ? "remote-leaf-wan" : length(regexall(
    "tier-2-leaf", each.value.node_type)) > 0 ? each.value.node_type : "unspecified"
    podId  = each.value.pod_id
    role   = each.value.role != null ? each.value.role : "unspecified"
    serial = each.value.serial_number
  }
}

# resource "aci_fabric_node_member" "fabric_node_members" {
#   for_each    = local.fabric_node_members
#   ext_pool_id = each.value.external_pool_id
#   fabric_id   = 1
#   name        = each.value.name
#   node_id     = each.key
#   node_type   = each.value.node_type
#   pod_id      = each.value.pod_id
#   role        = each.value.role
#   serial      = each.value.serial_number
# }

