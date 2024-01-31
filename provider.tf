#_______________________________________________________________________
#
# Terraform Required Parameters - ACI Provider
# https://registry.terraform.io/providers/CiscoDevNet/aci/latest
#_______________________________________________________________________

terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = ">= 2.13.0"
    }
  }
  required_version = ">= 1.3.0"
}
