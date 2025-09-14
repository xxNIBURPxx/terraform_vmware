provider "vsphere" {
  user                 = var.vmware_user
  password             = var.vmware_password
  vsphere_server       = "<Insert vCenter Server IP or FQDN>"
  allow_unverified_ssl = true
  api_timeout          = 10
}

data "vsphere_datacenter" "InsertName" {
  name = "InsertName"
}

resource "vsphere_compute_cluster" "InsertName" {
  name          = "InsertName"
  datacenter_id = data.vsphere_datacenter.InsertName.id
}
