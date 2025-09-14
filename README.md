# 🚀 Terraform for VMware vSphere

This repository provides an **easy-to-follow, modular Terraform configuration** for provisioning VMware vSphere resources.  
It covers **datacenters, clusters, networks, port groups, and virtual machines**, with each `.tf` file focusing on a specific resource type.

---

## 📂 Project Structure

```
vmware-terraform/
├── datacenter.tf       # Create a vSphere datacenter
├── cluster.tf          # Create a compute cluster
├── network.tf          # Create a distributed switch
├── port-groups.tf      # Create distributed port groups
├── main.tf             # Virtual machine build
├── variables.tf        # Input variables
├── terraform.tfvars    # User-provided values (not committed)
```

---

## ⚙️ Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.0.0 recommended)  
- vCenter or ESXi host reachable  
- VMware credentials with appropriate privileges  
- Templates available for cloning (e.g., Ubuntu, Windows, Kali, etc.)  

---

## 🔑 Authentication

Define your VMware credentials in `variables.tf`:

```hcl
variable "vmware_user" {
  type      = string
  sensitive = false
}

variable "vmware_password" {
  type      = string
  sensitive = true
}
```

Provide values in `terraform.tfvars` (excluded from GitHub):

```hcl
vmware_user     = "administrator@vsphere.local"
vmware_password = "SuperSecurePassword!"
```

---

## 🏗️ Steps

### 1. Create a Datacenter

**datacenter.tf**

```hcl
resource "vsphere_datacenter" "InsertName" {
  name = "InsertName"
}
```

---

### 2. Create a Cluster

**cluster.tf**

```hcl
data "vsphere_datacenter" "InsertName" {
  name = "InsertName"
}

resource "vsphere_compute_cluster" "InsertName" {
  name          = "InsertName"
  datacenter_id = data.vsphere_datacenter.InsertName.id
}
```

---

### 3. Create a Distributed Switch

**network.tf**

```hcl
data "vsphere_datacenter" "InsertName" {
  name = "InsertName"
}

resource "vsphere_distributed_virtual_switch" "dvSwitch-InsertName" {
  name          = "dvSwitch-InsertName"
  datacenter_id = data.vsphere_datacenter.InsertName.id
}
```

---

### 4. Create Port Groups

**port-groups.tf**

```hcl
data "vsphere_distributed_virtual_switch" "dvSwitch-InsertName" {
  name          = "dvSwitch-InsertName"
  datacenter_id = data.vsphere_datacenter.InsertName.id
}

resource "vsphere_distributed_port_group" "v22-Servers" {
  name                            = "v22-Servers"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvSwitch-InsertName.id
  vlan_id                         = 22
}
```

---

### 5. Build Virtual Machines

**main.tf**

```hcl
data "vsphere_datacenter" "InsertName" {
  name = "InsertName"
}

data "vsphere_compute_cluster" "InsertName" {
  name          = "InsertName"
  datacenter_id = data.vsphere_datacenter.InsertName.id
}

resource "vsphere_virtual_machine" "test" {
  name             = "test"
  resource_pool_id = data.vsphere_compute_cluster.InsertName.resource_pool_id
  datastore_id     = data.vsphere_datastore.SYNOLOGY.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = "ubuntu64Guest"

  network_interface {
    network_id   = data.vsphere_network.network.id
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
```

---

## ▶️ Usage

Run Terraform commands in order:

```bash
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply "tfplan"
```

---

## 🛑 Notes & Best Practices

- Keep credentials **out of GitHub** (add `terraform.tfvars` to `.gitignore`).  
- Use [remote state](https://developer.hashicorp.com/terraform/language/state/remote) (e.g., S3, Azure Blob) for shared environments.  
- Use [Terraform workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces) to manage multiple environments.  
- Start small (datacenter + cluster) → incrementally add network, port groups, VMs.  

---

## 📜 Author:** Phillip Rubin
