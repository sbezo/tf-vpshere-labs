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

data "vsphere_network" "OUTSIDE" {
  name          = var.vc_mng
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "ASAv" {
  name          = "SB-ASAV-Template"
  datacenter_id = data.vsphere_datacenter.dc.id
}


#####################################################################################



### ASAv ###



# create ASAv
resource "vsphere_virtual_machine" "ASAv" {
  name             = "SB-ASAv"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  guest_id = "other26xLinux64Guest"
  folder = "USER_VMs/SB"

  clone {
    template_uuid = data.vsphere_virtual_machine.ASAv.id
    linked_clone  = true
  }
network_interface { network_id = data.vsphere_network.OUTSIDE.id }
disk {
  label            = "disk0"
  size             = data.vsphere_virtual_machine.ASAv.disks[0].size
  unit_number      = data.vsphere_virtual_machine.ASAv.disks[0].unit_number
  thin_provisioned = data.vsphere_virtual_machine.ASAv.disks[0].thin_provisioned
}
disk {
  label            = "disk1"
  size             = data.vsphere_virtual_machine.ASAv.disks[1].size
  unit_number      = data.vsphere_virtual_machine.ASAv.disks[1].unit_number
  thin_provisioned = data.vsphere_virtual_machine.ASAv.disks[1].thin_provisioned
}
cdrom {
  client_device = true
}

}
