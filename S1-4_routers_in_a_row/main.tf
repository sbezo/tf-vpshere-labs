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

data "vsphere_virtual_machine" "Alpine" {
  name          = "SB-Alpine-Template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

#####################################################################################

### Links ###

# Create a new distributed port group - Link-AA
resource "vsphere_distributed_port_group" "LINK-AA" {
  name               = "VC-DPG-VLAN2160-LINK-AA"
  vlan_id            = 2160
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
}

# Create a new distributed port group - Link-BB
resource "vsphere_distributed_port_group" "LINK-BB" {
  name               = "VC-DPG-VLAN2161-LINK-BB"
  vlan_id            = 2161
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
}

# Create a new distributed port group - Link-CC
resource "vsphere_distributed_port_group" "LINK-CC" {
  name               = "VC-DPG-VLAN2162-LINK-CC"
  vlan_id            = 2162
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
}

### Routers ###

# create linux Alpine11
resource "vsphere_virtual_machine" "A11" {
 name             = "SB-Alpine-11"
 resource_pool_id = data.vsphere_resource_pool.pool.id
 datastore_id     = data.vsphere_datastore.datastore.id
 num_cpus = 1
 memory   = 4096
 guest_id = data.vsphere_virtual_machine.Alpine.guest_id
 folder = "USER_VMs/SB"
 wait_for_guest_net_timeout = 0

 network_interface {
   network_id   = data.vsphere_network.MNG.id
   adapter_type = "vmxnet3"
 }
  network_interface {
   network_id   = vsphere_distributed_port_group.LINK-AA.id
   adapter_type = "vmxnet3"
 }
 disk {
   label = "Hard disk 1"
   size             = 16
   thin_provisioned = true
 }
 clone {
   template_uuid = data.vsphere_virtual_machine.Alpine.id
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
   network_id   = vsphere_distributed_port_group.LINK-AA.id
   adapter_type = "vmxnet3"
 }
   network_interface {
   network_id   = vsphere_distributed_port_group.LINK-BB.id
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
   network_id   = vsphere_distributed_port_group.LINK-BB.id
   adapter_type = "vmxnet3"
 }
   network_interface {
   network_id   = vsphere_distributed_port_group.LINK-CC.id
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

# create linux Alpine12
resource "vsphere_virtual_machine" "A12" {
 name             = "SB-Alpine-12"
 resource_pool_id = data.vsphere_resource_pool.pool.id
 datastore_id     = data.vsphere_datastore.datastore.id
 num_cpus = 1
 memory   = 4096
 guest_id = data.vsphere_virtual_machine.Alpine.guest_id
 folder = "USER_VMs/SB"
 wait_for_guest_net_timeout = 0

 network_interface {
   network_id   = data.vsphere_network.MNG.id
   adapter_type = "vmxnet3"
 }
  network_interface {
   network_id   = vsphere_distributed_port_group.LINK-CC.id
   adapter_type = "vmxnet3"
 }
 disk {
   label = "Hard disk 1"
   size             = 16
   thin_provisioned = true
 }
 clone {
   template_uuid = data.vsphere_virtual_machine.Alpine.id
 }
}