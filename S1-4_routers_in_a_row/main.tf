provider "vsphere" {
  user           = var.vc_user
  password       = var.vc_password
  vsphere_server = var.vc_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vc_dc
}

data "vsphere_distributed_virtual_switch" "dvs" {
  name          = var.vc_dvs
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vc_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vc_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "MNG" {
  name          = var.vc_mng
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "CSR1000V" {
  name          = "SB-CSR1000V-Template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

#####################################################################################

### Links ###

# Create a new distributed port group - Link-A
resource "vsphere_distributed_port_group" "LINK-A" {
  name               = "VC-DPG-VLAN1160-LINK-A"
  vlan_id            = 1160
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
}

# Create a new distributed port group - Link-B
resource "vsphere_distributed_port_group" "LINK-B" {
  name               = "VC-DPG-VLAN1161-LINK-B"
  vlan_id            = 1161
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
}

# Create a new distributed port group - Link-C
resource "vsphere_distributed_port_group" "LINK-C" {
  name               = "VC-DPG-VLAN1162-LINK-C"
  vlan_id            = 1162
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
}

### Routers ###

# create router R1
resource "vsphere_virtual_machine" "R1" {
 name             = "SB-CSR1000V-R1"
 resource_pool_id = data.vsphere_resource_pool.pool.id
 datastore_id     = data.vsphere_datastore.datastore.id
 num_cpus = 1
 memory   = 4096
 guest_id = data.vsphere_virtual_machine.CSR1000V.guest_id
 folder = "USER_VMs/SB"
 wait_for_guest_net_timeout = 0

 network_interface {
   network_id   = data.vsphere_network.MNG.id
   adapter_type = "vmxnet3"
 }
  network_interface {
   network_id   = vsphere_distributed_port_group.LINK-A.id
   adapter_type = "vmxnet3"
 }
 disk {
   label = "Hard disk 1"
   size             = 8
   thin_provisioned = true
 }
 clone {
   template_uuid = data.vsphere_virtual_machine.CSR1000V.id
 }
}

# create router R2
resource "vsphere_virtual_machine" "R2" {
 name             = "SB-CSR1000V-R2"
 resource_pool_id = data.vsphere_resource_pool.pool.id
 datastore_id     = data.vsphere_datastore.datastore.id
 num_cpus = 1
 memory   = 4096
 guest_id = data.vsphere_virtual_machine.CSR1000V.guest_id
 folder = "USER_VMs/SB"
 wait_for_guest_net_timeout = 0

 network_interface {
   network_id   = data.vsphere_network.MNG.id
   adapter_type = "vmxnet3"
 }
  network_interface {
   network_id   = vsphere_distributed_port_group.LINK-A.id
   adapter_type = "vmxnet3"
 }
   network_interface {
   network_id   = vsphere_distributed_port_group.LINK-B.id
   adapter_type = "vmxnet3"
 }
 disk {
   label = "Hard disk 1"
   size             = 8
   thin_provisioned = true
 }
 clone {
   template_uuid = data.vsphere_virtual_machine.CSR1000V.id
 }
}

# create router R3
resource "vsphere_virtual_machine" "R3" {
 name             = "SB-CSR1000V-R3"
 resource_pool_id = data.vsphere_resource_pool.pool.id
 datastore_id     = data.vsphere_datastore.datastore.id
 num_cpus = 1
 memory   = 4096
 guest_id = data.vsphere_virtual_machine.CSR1000V.guest_id
 folder = "USER_VMs/SB"
 wait_for_guest_net_timeout = 0

 network_interface {
   network_id   = data.vsphere_network.MNG.id
   adapter_type = "vmxnet3"
 }
  network_interface {
   network_id   = vsphere_distributed_port_group.LINK-B.id
   adapter_type = "vmxnet3"
 }
   network_interface {
   network_id   = vsphere_distributed_port_group.LINK-C.id
   adapter_type = "vmxnet3"
 }
 disk {
   label = "Hard disk 1"
   size             = 8
   thin_provisioned = true
 }
 clone {
   template_uuid = data.vsphere_virtual_machine.CSR1000V.id
 }
}

# create router R4
resource "vsphere_virtual_machine" "R4" {
 name             = "SB-CSR1000V-R4"
 resource_pool_id = data.vsphere_resource_pool.pool.id
 datastore_id     = data.vsphere_datastore.datastore.id
 num_cpus = 1
 memory   = 4096
 guest_id = data.vsphere_virtual_machine.CSR1000V.guest_id
 folder = "USER_VMs/SB"
 wait_for_guest_net_timeout = 0

 network_interface {
   network_id   = data.vsphere_network.MNG.id
   adapter_type = "vmxnet3"
 }
  network_interface {
   network_id   = vsphere_distributed_port_group.LINK-C.id
   adapter_type = "vmxnet3"
 }
 disk {
   label = "Hard disk 1"
   size             = 8
   thin_provisioned = true
 }
 clone {
   template_uuid = data.vsphere_virtual_machine.CSR1000V.id
 }
}

# create router R5
resource "vsphere_virtual_machine" "R5" {
 name             = "SB-CSR1000V-R5"
 resource_pool_id = data.vsphere_resource_pool.pool.id
 datastore_id     = data.vsphere_datastore.datastore.id
 num_cpus = 1
 memory   = 4096
 guest_id = data.vsphere_virtual_machine.CSR1000V.guest_id
 folder = "USER_VMs/SB"
 wait_for_guest_net_timeout = 0

 network_interface {
   network_id   = data.vsphere_network.MNG.id
   adapter_type = "vmxnet3"
 }
  network_interface {
   network_id   = vsphere_distributed_port_group.LINK-C.id
   adapter_type = "vmxnet3"
 }
 disk {
   label = "Hard disk 1"
   size             = 8
   thin_provisioned = true
 }
 clone {
   template_uuid = data.vsphere_virtual_machine.CSR1000V.id
 }
}