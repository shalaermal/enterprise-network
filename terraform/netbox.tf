# =============================================================================
# TelcoKS Enterprise Network Lab — Main Resources
# File: netbox.tf
# Description: Sites, Device Types, Devices, VLANs, Prefixes
#              Depends on base.tf resources
# =============================================================================

# -----------------------------------------------------------------------------
# DEVICE TYPES — depends on manufacturers
# -----------------------------------------------------------------------------

resource "netbox_device_type" "vsrx" {
  model           = "vSRX 23.2R2"
  slug            = "vsrx-23-2r2"
  manufacturer_id = netbox_manufacturer.juniper.id
  tags            = [netbox_tag.bgp.name, netbox_tag.ospf.name]

  depends_on = [netbox_manufacturer.juniper, netbox_tag.bgp, netbox_tag.ospf]
}

resource "netbox_device_type" "vios" {
  model           = "vIOS 15.9"
  slug            = "vios-15-9"
  manufacturer_id = netbox_manufacturer.cisco.id
  tags            = [netbox_tag.ospf.name]

  depends_on = [netbox_manufacturer.cisco, netbox_tag.ospf]
}

resource "netbox_device_type" "vios_l2" {
  model           = "vIOS-L2"
  slug            = "vios-l2"
  manufacturer_id = netbox_manufacturer.cisco.id

  depends_on = [netbox_manufacturer.cisco]
}

resource "netbox_device_type" "pfsense" {
  model           = "pfSense CE 2.6.0"
  slug            = "pfsense-ce-2-6-0"
  manufacturer_id = netbox_manufacturer.netgate.id
  tags            = [netbox_tag.bgp.name, netbox_tag.ospf.name, netbox_tag.ipsec.name]

  depends_on = [netbox_manufacturer.netgate, netbox_tag.bgp, netbox_tag.ospf, netbox_tag.ipsec]
}

resource "netbox_device_type" "chr" {
  model           = "CHR"
  slug            = "chr"
  manufacturer_id = netbox_manufacturer.mikrotik.id
  tags            = [netbox_tag.ipsec.name]

  depends_on = [netbox_manufacturer.mikrotik, netbox_tag.ipsec]
}

# -----------------------------------------------------------------------------
# SITES — depends on tags
# -----------------------------------------------------------------------------

resource "netbox_site" "hq" {
  name   = "HQ-Pristina"
  slug   = "hq-pristina"
  status = "active"
  tags   = [netbox_tag.hq.name]

  depends_on = [netbox_tag.hq]
}

resource "netbox_site" "prz" {
  name   = "PRZ-Prizren"
  slug   = "prz-prizren"
  status = "active"
  tags   = [netbox_tag.branch.name, netbox_tag.ipsec.name]

  depends_on = [netbox_tag.branch, netbox_tag.ipsec]
}

resource "netbox_site" "pej" {
  name   = "PEJ-Peja"
  slug   = "pej-peja"
  status = "planned"
  tags   = [netbox_tag.branch.name, netbox_tag.ipsec.name]

  depends_on = [netbox_tag.branch, netbox_tag.ipsec]
}

resource "netbox_site" "gjl" {
  name   = "GJL-Gjilan"
  slug   = "gjl-gjilan"
  status = "planned"
  tags   = [netbox_tag.branch.name, netbox_tag.ipsec.name]

  depends_on = [netbox_tag.branch, netbox_tag.ipsec]
}

# -----------------------------------------------------------------------------
# DEVICES — HQ
# -----------------------------------------------------------------------------

resource "netbox_device" "hq_edg_pe01" {
  name           = "HQ-EDG-PE01"
  device_type_id = netbox_device_type.vsrx.id
  role_id        = netbox_device_role.edge_pe.id
  site_id        = netbox_site.hq.id
  status         = "active"
  tags           = [netbox_tag.hq.name, netbox_tag.edge.name, netbox_tag.bgp.name]
  comments       = "Juniper vSRX 23.2R2 | AS65001 | Mgmt: 192.168.10.1 | Loopback: 10.255.255.253/32"

  depends_on = [netbox_device_type.vsrx, netbox_device_role.edge_pe, netbox_site.hq]
}

resource "netbox_device" "hq_fw_edge01" {
  name           = "HQ-FW-EDGE01"
  device_type_id = netbox_device_type.pfsense.id
  role_id        = netbox_device_role.edge_fw.id
  site_id        = netbox_site.hq.id
  status         = "active"
  tags           = [netbox_tag.hq.name, netbox_tag.edge.name, netbox_tag.bgp.name, netbox_tag.ipsec.name]
  comments       = "pfSense CE 2.6.0 | AS65002 | ABR Area0/Area10 | Mgmt: 192.168.10.2 | Loopback: 10.255.255.254/32"

  depends_on = [netbox_device_type.pfsense, netbox_device_role.edge_fw, netbox_site.hq]
}

resource "netbox_device" "hq_cr_01" {
  name           = "HQ-CR-01"
  device_type_id = netbox_device_type.vios.id
  role_id        = netbox_device_role.core_router.id
  site_id        = netbox_site.hq.id
  status         = "active"
  tags           = [netbox_tag.hq.name, netbox_tag.core.name, netbox_tag.ospf.name]
  comments       = "Cisco vIOS 15.9 | OSPF Area0/Area20 | Mgmt: 192.168.10.11 | Loopback: 10.255.255.1/32"

  depends_on = [netbox_device_type.vios, netbox_device_role.core_router, netbox_site.hq]
}

resource "netbox_device" "hq_cr_02" {
  name           = "HQ-CR-02"
  device_type_id = netbox_device_type.vios.id
  role_id        = netbox_device_role.core_router.id
  site_id        = netbox_site.hq.id
  status         = "active"
  tags           = [netbox_tag.hq.name, netbox_tag.core.name, netbox_tag.ospf.name]
  comments       = "Cisco vIOS 15.9 | OSPF Area0/Area20 | Mgmt: 192.168.10.12 | Loopback: 10.255.255.2/32"

  depends_on = [netbox_device_type.vios, netbox_device_role.core_router, netbox_site.hq]
}

resource "netbox_device" "hq_dsw_01" {
  name           = "HQ-DSW-01"
  device_type_id = netbox_device_type.vios_l2.id
  role_id        = netbox_device_role.distribution_sw.id
  site_id        = netbox_site.hq.id
  status         = "active"
  tags           = [netbox_tag.hq.name, netbox_tag.ospf.name]
  comments       = "Cisco vIOS-L2 | HSRP Active VLAN20/40 | STP Root VLAN20/40 | Mgmt: 192.168.10.21 | Loopback: 10.255.255.11/32"

  depends_on = [netbox_device_type.vios_l2, netbox_device_role.distribution_sw, netbox_site.hq]
}

resource "netbox_device" "hq_dsw_02" {
  name           = "HQ-DSW-02"
  device_type_id = netbox_device_type.vios_l2.id
  role_id        = netbox_device_role.distribution_sw.id
  site_id        = netbox_site.hq.id
  status         = "active"
  tags           = [netbox_tag.hq.name, netbox_tag.ospf.name]
  comments       = "Cisco vIOS-L2 | HSRP Active VLAN30/50 | STP Root VLAN30/50 | Mgmt: 192.168.10.22 | Loopback: 10.255.255.12/32"

  depends_on = [netbox_device_type.vios_l2, netbox_device_role.distribution_sw, netbox_site.hq]
}

resource "netbox_device" "hq_asw_01" {
  name           = "HQ-ASW-01"
  device_type_id = netbox_device_type.vios_l2.id
  role_id        = netbox_device_role.access_sw.id
  site_id        = netbox_site.hq.id
  status         = "active"
  tags           = [netbox_tag.hq.name]
  comments       = "Cisco vIOS-L2 | Access VLAN20/30 | Uplink: HQ-DSW-01 | Mgmt: 192.168.10.31"

  depends_on = [netbox_device_type.vios_l2, netbox_device_role.access_sw, netbox_site.hq]
}

resource "netbox_device" "hq_asw_02" {
  name           = "HQ-ASW-02"
  device_type_id = netbox_device_type.vios_l2.id
  role_id        = netbox_device_role.access_sw.id
  site_id        = netbox_site.hq.id
  status         = "active"
  tags           = [netbox_tag.hq.name]
  comments       = "Cisco vIOS-L2 | Access VLAN20/30 | Uplink: HQ-DSW-02 | Mgmt: 192.168.10.32"

  depends_on = [netbox_device_type.vios_l2, netbox_device_role.access_sw, netbox_site.hq]
}

resource "netbox_device" "hq_dmz_sw01" {
  name           = "HQ-DMZ-SW01"
  device_type_id = netbox_device_type.vios_l2.id
  role_id        = netbox_device_role.dmz_sw.id
  site_id        = netbox_site.hq.id
  status         = "active"
  tags           = [netbox_tag.hq.name, netbox_tag.edge.name]
  comments       = "Cisco vIOS-L2 | DMZ Switch | pfSense OPT3 | Mgmt: 192.168.10.41 | Loopback: 10.255.255.41/32"

  depends_on = [netbox_device_type.vios_l2, netbox_device_role.dmz_sw, netbox_site.hq]
}

resource "netbox_device" "oob_mgmt_core" {
  name           = "OOB-MGMT-CORE"
  device_type_id = netbox_device_type.vios_l2.id
  role_id        = netbox_device_role.oob_mgmt.id
  site_id        = netbox_site.hq.id
  status         = "active"
  tags           = [netbox_tag.hq.name]
  comments       = "Cisco vIOS-L2 | Out-of-Band Management | Mgmt: 192.168.10.10 | Loopback: 10.255.255.10/32"

  depends_on = [netbox_device_type.vios_l2, netbox_device_role.oob_mgmt, netbox_site.hq]
}

# -----------------------------------------------------------------------------
# DEVICES — Branch PRZ
# -----------------------------------------------------------------------------

resource "netbox_device" "prz_rtr_01" {
  name           = "PRZ-RTR-01"
  device_type_id = netbox_device_type.chr.id
  role_id        = netbox_device_role.branch_router.id
  site_id        = netbox_site.prz.id
  status         = "active"
  tags           = [netbox_tag.branch.name, netbox_tag.ipsec.name]
  comments       = "MikroTik CHR | IPSec IKEv2 -> HQ-FW-EDGE01 | WAN: 203.0.113.2/29 | LAN: 192.168.110.1/24"

  depends_on = [netbox_device_type.chr, netbox_device_role.branch_router, netbox_site.prz]
}

resource "netbox_device" "prz_sw_01" {
  name           = "PRZ-SW-01"
  device_type_id = netbox_device_type.vios_l2.id
  role_id        = netbox_device_role.access_sw.id
  site_id        = netbox_site.prz.id
  status         = "active"
  tags           = [netbox_tag.branch.name]
  comments       = "Cisco vIOS-L2 | PRZ Access Switch | Mgmt: 192.168.110.10 | Uplink: PRZ-RTR-01"

  depends_on = [netbox_device_type.vios_l2, netbox_device_role.access_sw, netbox_site.prz]
}

# -----------------------------------------------------------------------------
# VLANS — HQ
# -----------------------------------------------------------------------------

resource "netbox_vlan" "mgmt" {
  name    = "Management"
  vid     = 10
  site_id = netbox_site.hq.id
  status  = "active"
  tags    = [netbox_tag.hq.name]

  depends_on = [netbox_site.hq, netbox_tag.hq]
}

resource "netbox_vlan" "data" {
  name    = "Data"
  vid     = 20
  site_id = netbox_site.hq.id
  status  = "active"
  tags    = [netbox_tag.hq.name]

  depends_on = [netbox_site.hq, netbox_tag.hq]
}

resource "netbox_vlan" "voice" {
  name    = "Voice"
  vid     = 30
  site_id = netbox_site.hq.id
  status  = "active"
  tags    = [netbox_tag.hq.name]

  depends_on = [netbox_site.hq, netbox_tag.hq]
}

resource "netbox_vlan" "servers" {
  name    = "Servers"
  vid     = 40
  site_id = netbox_site.hq.id
  status  = "active"
  tags    = [netbox_tag.hq.name]

  depends_on = [netbox_site.hq, netbox_tag.hq]
}

resource "netbox_vlan" "dmz" {
  name    = "DMZ"
  vid     = 50
  site_id = netbox_site.hq.id
  status  = "active"
  tags    = [netbox_tag.hq.name, netbox_tag.edge.name]

  depends_on = [netbox_site.hq, netbox_tag.hq, netbox_tag.edge]
}

# -----------------------------------------------------------------------------
# IP PREFIXES — Supernets
# -----------------------------------------------------------------------------

resource "netbox_prefix" "loopbacks" {
  prefix      = "10.255.255.0/24"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "Loopback addresses — all devices"
  tags        = [netbox_tag.ospf.name]

  depends_on = [netbox_site.hq, netbox_tag.ospf]
}

resource "netbox_prefix" "transit_supernet" {
  prefix      = "172.16.255.0/24"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "Transit links supernet /30 each"
  tags        = [netbox_tag.ospf.name]

  depends_on = [netbox_site.hq, netbox_tag.ospf]
}

resource "netbox_prefix" "vlans_supernet" {
  prefix      = "192.168.0.0/16"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "VLAN subnets supernet"

  depends_on = [netbox_site.hq]
}

resource "netbox_prefix" "branch_transport" {
  prefix      = "203.0.113.0/29"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "Branch VPN transport — pfSense OPT4"
  tags        = [netbox_tag.ipsec.name]

  depends_on = [netbox_site.hq, netbox_tag.ipsec]
}

# -----------------------------------------------------------------------------
# IP PREFIXES — Transit Links /30
# -----------------------------------------------------------------------------

resource "netbox_prefix" "transit_pe_pfsense" {
  prefix      = "172.16.255.0/30"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "HQ-EDG-PE01 <-> HQ-FW-EDGE01 (WAN)"
  tags        = [netbox_tag.bgp.name, netbox_tag.ospf.name]

  depends_on = [netbox_site.hq, netbox_tag.bgp, netbox_tag.ospf]
}

resource "netbox_prefix" "transit_pfsense_cr01" {
  prefix      = "172.16.255.4/30"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "HQ-FW-EDGE01 (OPT1) <-> HQ-CR-01"
  tags        = [netbox_tag.ospf.name]

  depends_on = [netbox_site.hq, netbox_tag.ospf]
}

resource "netbox_prefix" "transit_pfsense_cr02" {
  prefix      = "172.16.255.8/30"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "HQ-FW-EDGE01 (OPT2) <-> HQ-CR-02"
  tags        = [netbox_tag.ospf.name]

  depends_on = [netbox_site.hq, netbox_tag.ospf]
}

resource "netbox_prefix" "transit_cr01_cr02" {
  prefix      = "172.16.255.12/30"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "HQ-CR-01 <-> HQ-CR-02"
  tags        = [netbox_tag.ospf.name]

  depends_on = [netbox_site.hq, netbox_tag.ospf]
}

resource "netbox_prefix" "transit_cr01_dsw01" {
  prefix      = "172.16.255.16/30"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "HQ-CR-01 <-> HQ-DSW-01"
  tags        = [netbox_tag.ospf.name]

  depends_on = [netbox_site.hq, netbox_tag.ospf]
}

resource "netbox_prefix" "transit_cr02_dsw02" {
  prefix      = "172.16.255.20/30"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "HQ-CR-02 <-> HQ-DSW-02"
  tags        = [netbox_tag.ospf.name]

  depends_on = [netbox_site.hq, netbox_tag.ospf]
}

resource "netbox_prefix" "transit_pfsense_dmz" {
  prefix      = "172.16.255.28/30"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "HQ-FW-EDGE01 (OPT3) <-> HQ-DMZ-SW01"
  tags        = [netbox_tag.ospf.name, netbox_tag.edge.name]

  depends_on = [netbox_site.hq, netbox_tag.ospf, netbox_tag.edge]
}

# -----------------------------------------------------------------------------
# IP PREFIXES — VLAN Subnets HQ
# -----------------------------------------------------------------------------

resource "netbox_prefix" "mgmt_subnet" {
  prefix      = "192.168.10.0/24"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "VLAN10 Management — HSRP VIP .254 | DSW-01 .253 | DSW-02 .252"
  vlan_id     = netbox_vlan.mgmt.id

  depends_on = [netbox_site.hq, netbox_vlan.mgmt]
}

resource "netbox_prefix" "data_subnet" {
  prefix      = "192.168.20.0/24"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "VLAN20 Data — HSRP VIP .1 | DSW-01 .2 | DSW-02 .3 | DHCP .100-.200"
  vlan_id     = netbox_vlan.data.id

  depends_on = [netbox_site.hq, netbox_vlan.data]
}

resource "netbox_prefix" "voice_subnet" {
  prefix      = "192.168.30.0/24"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "VLAN30 Voice — HSRP VIP .1 | DSW-01 .2 | DSW-02 .3 | DHCP .100-.200"
  vlan_id     = netbox_vlan.voice.id

  depends_on = [netbox_site.hq, netbox_vlan.voice]
}

resource "netbox_prefix" "servers_subnet" {
  prefix      = "192.168.40.0/24"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "VLAN40 Servers — HSRP VIP .1 | DSW-01 .2 | DSW-02 .3 | HQ-SRV-01 .10"
  vlan_id     = netbox_vlan.servers.id

  depends_on = [netbox_site.hq, netbox_vlan.servers]
}

resource "netbox_prefix" "dmz_subnet" {
  prefix      = "192.168.50.0/24"
  site_id     = netbox_site.hq.id
  status      = "active"
  description = "VLAN50 DMZ — HSRP VIP .1 | DSW-01 .2 | DSW-02 .3"
  vlan_id     = netbox_vlan.dmz.id

  depends_on = [netbox_site.hq, netbox_vlan.dmz]
}

# -----------------------------------------------------------------------------
# IP PREFIXES — Branch LANs
# -----------------------------------------------------------------------------

resource "netbox_prefix" "prz_lan" {
  prefix      = "192.168.110.0/24"
  site_id     = netbox_site.prz.id
  status      = "active"
  description = "PRZ Branch LAN — GW: 192.168.110.1 (PRZ-RTR-01) | SW Mgmt: .10"
  tags        = [netbox_tag.branch.name, netbox_tag.ipsec.name]

  depends_on = [netbox_site.prz, netbox_tag.branch, netbox_tag.ipsec]
}

resource "netbox_prefix" "pej_lan" {
  prefix      = "192.168.120.0/24"
  site_id     = netbox_site.pej.id
  status      = "reserved"
  description = "PEJ Branch LAN — planned | Cisco router"
  tags        = [netbox_tag.branch.name]

  depends_on = [netbox_site.pej, netbox_tag.branch]
}

resource "netbox_prefix" "gjl_lan" {
  prefix      = "192.168.130.0/24"
  site_id     = netbox_site.gjl.id
  status      = "reserved"
  description = "GJL Branch LAN — planned | Juniper switch"
  tags        = [netbox_tag.branch.name]

  depends_on = [netbox_site.gjl, netbox_tag.branch]
}
resource "netbox_vlan" "test" {
  name    = "Test"
  vid     = 60
  site_id = netbox_site.hq.id
  status  = "active"
  tags    = [netbox_tag.hq.name]
  depends_on = [netbox_site.hq, netbox_tag.hq]
}