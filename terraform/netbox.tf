# Site
resource "netbox_dcim_site" "lab" {
  name   = "Enterprise-Lab"
  slug   = "enterprise-lab"
  status = "active"
}

# VLANs
resource "netbox_ipam_vlan" "management" {
  name    = "Management"
  vlan_id = 10
  site_id = netbox_dcim_site.lab.id
}

resource "netbox_ipam_vlan" "lan" {
  name    = "LAN"
  vlan_id = 20
  site_id = netbox_dcim_site.lab.id
}

resource "netbox_ipam_vlan" "wan" {
  name    = "WAN"
  vlan_id = 30
  site_id = netbox_dcim_site.lab.id
}

resource "netbox_ipam_vlan" "dmz" {
  name    = "DMZ"
  vlan_id = 40
  site_id = netbox_dcim_site.lab.id
}

# IP Prefixes
resource "netbox_ipam_prefix" "main" {
  prefix  = "192.168.0.0/16"
  site_id = netbox_dcim_site.lab.id
  status  = "active"
}

resource "netbox_ipam_prefix" "management" {
  prefix  = "192.168.10.0/24"
  site_id = netbox_dcim_site.lab.id
  status  = "active"
}

resource "netbox_ipam_prefix" "lan" {
  prefix  = "192.168.20.0/24"
  site_id = netbox_dcim_site.lab.id
  status  = "active"
}

resource "netbox_ipam_prefix" "wan" {
  prefix  = "192.168.30.0/24"
  site_id = netbox_dcim_site.lab.id
  status  = "active"
}

resource "netbox_ipam_prefix" "dmz" {
  prefix  = "192.168.40.0/24"
  site_id = netbox_dcim_site.lab.id
  status  = "active"
}
