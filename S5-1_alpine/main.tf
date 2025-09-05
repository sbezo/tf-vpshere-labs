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

data "vsphere_virtual_machine" "Alpine" {
  name          = "SB-Alpine-Template"
  datacenter_id = data.vsphere_datacenter.dc.id
}


#####################################################################################
# create linux Alpine1
resource "vsphere_virtual_machine" "Alpine-10" {
 name             = "SB-Alpine-10"
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
 disk {
   label = "Hard disk 1"
   size             = 16
   thin_provisioned = true
 }
 clone {
   template_uuid = data.vsphere_virtual_machine.Alpine.id
 }
}