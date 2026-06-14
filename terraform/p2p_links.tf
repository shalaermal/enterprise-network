variable "device_p2p_links" {
  description = "Routed point-to-point interfaces + IPs for OSPF core links"
  type = map(object({
    device    = string # key into local.devices
    interface = string
    ip        = string
  }))
  default = {
    # ---- HQ-CR-01 <-> HQ-CR-02 (core link, transit_cr01_cr02 172.16.255.12/30)
    cr01_to_cr02 = { device = "hq_cr_01", interface = "GigabitEthernet0/2", ip = "172.16.255.13/30" }
    cr02_to_cr01 = { device = "hq_cr_02", interface = "GigabitEthernet0/2", ip = "172.16.255.14/30" }

    # ---- HQ-CR-01 <-> HQ-DSW-01 (transit_cr01_dsw01 172.16.255.16/30)
    cr01_to_dsw01 = { device = "hq_cr_01",  interface = "GigabitEthernet0/3", ip = "172.16.255.17/30" }
    dsw01_to_cr01 = { device = "hq_dsw_01", interface = "GigabitEthernet0/1", ip = "172.16.255.18/30" }

    # ---- HQ-CR-02 <-> HQ-DSW-02 (transit_cr02_dsw02 172.16.255.20/30)
    cr02_to_dsw02 = { device = "hq_cr_02",  interface = "GigabitEthernet0/3", ip = "172.16.255.21/30" }
    dsw02_to_cr02 = { device = "hq_dsw_02", interface = "GigabitEthernet0/1", ip = "172.16.255.22/30" }

    # ---- HQ-FW-EDGE01 (vSRX) <-> HQ-EDG-PE01 (transit_pe_pfsense 172.16.255.0/30)
    # ---- HQ-FW-EDGE01 (vSRX) <-> HQ-EDG-PE01 (transit_pe_pfsense 172.16.255.0/30)
    # EVE-NG: vSRX ge-0/0/3 <-> EDG-PE01 ge-0/0/1
    fw_to_pe   = { device = "hq_fw_edge01", interface = "ge-0/0/3", ip = "172.16.255.2/30" }

    # ---- HQ-FW-EDGE01 (vSRX) <-> HQ-CR-01 (transit_pfsense_cr01 172.16.255.4/30)
    # EVE-NG: vSRX ge-0/0/1 <-> CR-01 Gi0/1
    fw_to_cr01 = { device = "hq_fw_edge01", interface = "ge-0/0/1", ip = "172.16.255.5/30" }
    cr01_to_fw = { device = "hq_cr_01",     interface = "GigabitEthernet0/1", ip = "172.16.255.6/30" }

    # ---- HQ-FW-EDGE01 (vSRX) <-> HQ-CR-02 (transit_pfsense_cr02 172.16.255.8/30)
    # EVE-NG: vSRX ge-0/0/2 <-> CR-02 Gi0/1
    fw_to_cr02 = { device = "hq_fw_edge01", interface = "ge-0/0/2", ip = "172.16.255.9/30" }
    cr02_to_fw = { device = "hq_cr_02",     interface = "GigabitEthernet0/1", ip = "172.16.255.10/30" }

    # ---- HQ-FW-EDGE01 (vSRX) <-> HQ-DMZ-SW01 (transit_pfsense_dmz 172.16.255.28/30)
    # EVE-NG: vSRX ge-0/0/4 <-> DMZ-SW01 Gi0/1
    fw_to_dmz  = { device = "hq_fw_edge01", interface = "ge-0/0/4", ip = "172.16.255.29/30" }
    dmz_to_fw  = { device = "hq_dmz_sw01",  interface = "GigabitEthernet0/1", ip = "172.16.255.30/30" }
  }
}

# -----------------------------------------------------------------------
# Create each routed P2P interface.
# type = "1000BASE-T (1GE)" -> matches the physical interface type used
# for the other Gigabit links created manually in NetBox yesterday.
# -----------------------------------------------------------------------
resource "netbox_device_interface" "p2p" {
  for_each    = var.device_p2p_links
  name        = each.value.interface
  device_id   = local.devices[each.value.device].id
  type        = "1000base-t"
  description = "Routed P2P link (OSPF) - ${each.key}"

  depends_on = [local.devices]
}

# -----------------------------------------------------------------------
# Assign the /30 IP address to each side of the link.
# -----------------------------------------------------------------------
resource "netbox_ip_address" "p2p" {
  for_each            = var.device_p2p_links
  ip_address          = each.value.ip
  status              = "active"
  device_interface_id = netbox_device_interface.p2p[each.key].id

  depends_on = [netbox_device_interface.p2p]
}# Last updated: Sun Jun 14 20:21:04 UTC 2026
