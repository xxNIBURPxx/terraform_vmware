provider "vsphere" {
  user                 = var.vmware_user
  password             = var.vmware_password
  vsphere_server       = "<Insert vCenter Server IP or FQDN>"
  allow_unverified_ssl = true
}

resource "vsphere_datacenter" "InsertName" {
  name = "InsertName"
}

data "vsphere_datacenter" "InsertName" {
  name = "InsertName"
}

data "vsphere_datastore" "Datastore-Name" {
  name          = "Datastore-Name"
  datacenter_id = data.vsphere_datacenter.InsertName.id
}


data "vsphere_compute_cluster" "InsertName" {
  name          = "InsertName"
  datacenter_id = data.vsphere_datacenter.InsertName.id
}

data "vsphere_distributed_virtual_switch" "dvSwitch-InsertName" {
  name          = "dvSwitch-InsertName"
  datacenter_id = data.vsphere_datacenter.InsertName.id
}

data "vsphere_virtual_machine" "ubuntu-server-template" {
  name          = "ubuntu-server-template"
  datacenter_id = data.vsphere_datacenter.InsertName.id
}

################################Virtual machine resources below################################
resource "vsphere_virtual_machine" "test" {
  name                             = "test"
  resource_pool_id                 = data.vsphere_compute_cluster.InsertName.resource_pool_id
  datastore_id                     = data.vsphere_datastore.Datastore-Name.id
  scsi_type                        = data.vsphere_virtual_machine.ubuntu-server-template.scsi_type
  num_cpus                         = 4
  memory                           = 8192
  guest_id                         = "ubuntu64Guest"
  firmware                         = "bios"
  wait_for_guest_net_timeout       = 0
  sync_time_with_host              = true
  sync_time_with_host_periodically = false
  tools_upgrade_policy = "upgradeAtPowerCycle"
  
  network_interface {
    network_id   = data.vsphere_network.dvSwitch-InsertName.id
    adapter_type = data.vsphere_virtual_machine.ubuntu-server-template.network_interface_types[0]
    }

  disk {
    label            = "disk0"
    size             = "100"
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu-server-template.id

  }
}
