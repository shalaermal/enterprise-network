# =============================================================================
# TelcoKS Enterprise Network Lab — Base Resources
# File: base.tf
# Description: Foundation resources (no dependencies)
#              Must be applied before netbox.tf resources
# =============================================================================

# -----------------------------------------------------------------------------
# TAGS
# -----------------------------------------------------------------------------

resource "netbox_tag" "hq" {
  name = "HQ"
}

resource "netbox_tag" "branch" {
  name = "Branch"
}

resource "netbox_tag" "core" {
  name = "Core"
}

resource "netbox_tag" "edge" {
  name = "Edge"
}

resource "netbox_tag" "ospf" {
  name = "OSPF"
}

resource "netbox_tag" "bgp" {
  name = "BGP"
}

resource "netbox_tag" "ipsec" {
  name = "IPSec"
}

# -----------------------------------------------------------------------------
# MANUFACTURERS
# -----------------------------------------------------------------------------

resource "netbox_manufacturer" "juniper" {
  name = "Juniper Networks"
  slug = "juniper-networks"
}

resource "netbox_manufacturer" "cisco" {
  name = "Cisco Systems"
  slug = "cisco-systems"
}

resource "netbox_manufacturer" "netgate" {
  name = "Netgate"
  slug = "netgate"
}

resource "netbox_manufacturer" "mikrotik" {
  name = "MikroTik"
  slug = "mikrotik"
}

# -----------------------------------------------------------------------------
# DEVICE ROLES
# -----------------------------------------------------------------------------

resource "netbox_device_role" "edge_pe" {
  name      = "Edge-PE"
  slug      = "edge-pe"
  color_hex = "b71c1c"
  vm_role   = false
}

resource "netbox_device_role" "edge_fw" {
  name      = "Edge-Firewall"
  slug      = "edge-firewall"
  color_hex = "e53935"
  vm_role   = false
}

resource "netbox_device_role" "core_router" {
  name      = "Core-Router"
  slug      = "core-router"
  color_hex = "1565c0"
  vm_role   = false
}

resource "netbox_device_role" "distribution_sw" {
  name      = "Distribution-Switch"
  slug      = "distribution-switch"
  color_hex = "2e7d32"
  vm_role   = false
}

resource "netbox_device_role" "access_sw" {
  name      = "Access-Switch"
  slug      = "access-switch"
  color_hex = "558b2f"
  vm_role   = false
}

resource "netbox_device_role" "dmz_sw" {
  name      = "DMZ-Switch"
  slug      = "dmz-switch"
  color_hex = "e65100"
  vm_role   = false
}

resource "netbox_device_role" "branch_router" {
  name      = "Branch-Router"
  slug      = "branch-router"
  color_hex = "f57f17"
  vm_role   = false
}

resource "netbox_device_role" "oob_mgmt" {
  name      = "OOB-Management"
  slug      = "oob-management"
  color_hex = "546e7a"
  vm_role   = false
}
