variable "device_mgmt" {
  description = "Management interface + IP per device (for primary_ip4)"
  type = map(object({
    interface = string
    ip        = string
  }))
  default = {
    hq_edg_pe01   = { interface = "ge-0/0/1",          ip = "192.168.10.1/24" }
    hq_fw_edge01  = { interface = "vmx0",              ip = "192.168.10.2/24" }
    hq_cr_01      = { interface = "GigabitEthernet0/0", ip = "192.168.10.11/24" }
    hq_cr_02      = { interface = "GigabitEthernet0/0", ip = "192.168.10.12/24" }
    hq_dsw_01     = { interface = "GigabitEthernet0/0", ip = "192.168.10.21/24" }
    hq_dsw_02     = { interface = "GigabitEthernet0/0", ip = "192.168.10.22/24" }
    hq_asw_01     = { interface = "GigabitEthernet0/0", ip = "192.168.10.31/24" }
    hq_asw_02     = { interface = "GigabitEthernet0/0", ip = "192.168.10.32/24" }
    hq_dmz_sw01   = { interface = "GigabitEthernet0/0", ip = "192.168.10.41/24" }
    oob_mgmt_core = { interface = "GigabitEthernet0/0", ip = "192.168.10.10/24" }
    prz_rtr_01    = { interface = "ether1",            ip = "203.0.113.2/29" }
    prz_sw_01     = { interface = "GigabitEthernet0/0", ip = "192.168.110.10/24" }
  }
}

locals {
  devices = {
    hq_edg_pe01   = netbox_device.hq_edg_pe01
    hq_fw_edge01  = netbox_device.hq_fw_edge01
    hq_cr_01      = netbox_device.hq_cr_01
    hq_cr_02      = netbox_device.hq_cr_02
    hq_dsw_01     = netbox_device.hq_dsw_01
    hq_dsw_02     = netbox_device.hq_dsw_02
    hq_asw_01     = netbox_device.hq_asw_01
    hq_asw_02     = netbox_device.hq_asw_02
    hq_dmz_sw01   = netbox_device.hq_dmz_sw01
    oob_mgmt_core = netbox_device.oob_mgmt_core
    prz_rtr_01    = netbox_device.prz_rtr_01
    prz_sw_01     = netbox_device.prz_sw_01
  }
}

resource "netbox_interface" "mgmt" {
  for_each  = var.device_mgmt
  name      = each.value.interface
  device_id = local.devices[each.key].id
  type      = "other"

  depends_on = [local.devices]
}

resource "netbox_ip_address" "mgmt" {
  for_each       = var.device_mgmt
  ip_address     = each.value.ip
  status         = "active"
  interface_id   = netbox_interface.mgmt[each.key].id
  interface_type = "device"

  depends_on = [netbox_interface.mgmt]
}

resource "netbox_primary_ip" "mgmt" {
  for_each        = var.device_mgmt
  device_id       = local.devices[each.key].id
  ip_address_id   = netbox_ip_address.mgmt[each.key].id
  ip_address_type = "4"

  depends_on = [netbox_ip_address.mgmt]
}