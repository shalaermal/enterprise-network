variable "device_loopbacks" {
  description = "Loopback interface name + IP (router-id) per device"
  type = map(object({
    interface = string
    ip        = string
  }))
  default = {
    hq_cr_01    = { interface = "Loopback0", ip = "10.255.255.1/32" }
    hq_cr_02    = { interface = "Loopback0", ip = "10.255.255.2/32" }
    hq_dsw_01   = { interface = "Loopback0", ip = "10.255.255.11/32" }
    hq_dsw_02   = { interface = "Loopback0", ip = "10.255.255.12/32" }
    hq_edg_pe01 = { interface = "lo0",       ip = "10.255.255.3/32" }
  }
}

# -----------------------------------------------------------------------
# Create the Loopback0 / lo0 interface on each device.
# type = "virtual" -> NetBox interface type for non-physical interfaces
# (loopbacks, SVIs, tunnels, etc.)
# -----------------------------------------------------------------------
resource "netbox_device_interface" "loopback" {
  for_each  = var.device_loopbacks
  name      = each.value.interface
  device_id = local.devices[each.key].id
  type      = "virtual"

  depends_on = [local.devices]
}

# -----------------------------------------------------------------------
# Assign the loopback IP address to that interface.
# -----------------------------------------------------------------------
resource "netbox_ip_address" "loopback" {
  for_each            = var.device_loopbacks
  ip_address          = each.value.ip
  status              = "active"
  device_interface_id = netbox_device_interface.loopback[each.key].id

  depends_on = [netbox_device_interface.loopback]
}