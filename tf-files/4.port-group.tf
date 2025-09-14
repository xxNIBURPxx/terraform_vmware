provider "vsphere" {
  user                 = var.vmware_user
  password             = var.vmware_password
  vsphere_server       = "<Insert vCenter Server IP or FQDN>"
  allow_unverified_ssl = true
  api_timeout          = 10
}

data "vsphere_distributed_virtual_switch" "dvSwitch-InsertName" {
  name          = "dvSwitch-InsertName"
  datacenter_id = data.vsphere_datacenter.InsertName.id
}

resource "vsphere_distributed_port_group" "v22-Servers" {
  name                            = "v22-Servers"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvSwitch-NIBURP.id
  vlan_id                         = 22 # Set VLAN ID if needed

  # Description
  description = <<EOT
IP Scope: 10.2.22.0/24
Gateway: 10.2.2.1
EOT

  active_uplinks  = [data.vsphere_distributed_virtual_switch.dvSwitch-NIBURP.uplinks[0]]
  standby_uplinks = [data.vsphere_distributed_virtual_switch.dvSwitch-NIBURP.uplinks[1]]
}
