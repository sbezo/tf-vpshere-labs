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

data "vsphere_virtual_machine" "SB-Ubuntu-Template" {
  name          = "SB-Ubuntu-Template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

#####################################################################################


# create kubernetes node SB-K8Node-01
resource "vsphere_virtual_machine" "SB-K8Node-01" {
  name             = "SB-K8Node-01"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus = 2
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.SB-Ubuntu-Template.guest_id
  folder = "USER_VMs/SB"
  wait_for_guest_net_timeout = 0  
  network_interface {
    network_id   = data.vsphere_network.MNG.id
    adapter_type = "vmxnet3"
  } 
  disk {
    label = "Hard disk 1"
    size             = 32
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.SB-Ubuntu-Template.id
    customize {
      linux_options {
        host_name = "SB-K8Node-01"
        domain    = "lab.local"
      }
      network_interface {
        ipv4_address = "10.208.116.120"
        ipv4_netmask = 24
      }

      ipv4_gateway = "10.208.116.1"
      dns_server_list = ["8.8.8.8", "8.8.4.4"]
    }
  }
}

# create kubernetes node SB-K8Node-02
resource "vsphere_virtual_machine" "SB-K8Node-02" {
  name             = "SB-K8Node-02"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus = 2
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.SB-Ubuntu-Template.guest_id
  folder = "USER_VMs/SB"
  wait_for_guest_net_timeout = 0  
  network_interface {
    network_id   = data.vsphere_network.MNG.id
    adapter_type = "vmxnet3"
  } 
  disk {
    label = "Hard disk 1"
    size             = 32
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.SB-Ubuntu-Template.id
    customize {
      linux_options {
        host_name = "SB-K8Node-02"
        domain    = "lab.local"
      }
      network_interface {
        ipv4_address = "10.208.116.121"
        ipv4_netmask = 24
      }

      ipv4_gateway = "10.208.116.1"
      dns_server_list = ["8.8.8.8", "8.8.4.4"]
    }
  }
}

# create kubernetes node SB-K8Node-03
resource "vsphere_virtual_machine" "SB-K8Node-03" {
  name             = "SB-K8Node-03"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus = 2
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.SB-Ubuntu-Template.guest_id
  folder = "USER_VMs/SB"
  wait_for_guest_net_timeout = 0  
  network_interface {
    network_id   = data.vsphere_network.MNG.id
    adapter_type = "vmxnet3"
  } 
  disk {
    label = "Hard disk 1"
    size             = 32
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.SB-Ubuntu-Template.id
    customize {
      linux_options {
        host_name = "SB-K8Node-03"
        domain    = "lab.local"
      }
      network_interface {
        ipv4_address = "10.208.116.129"
        ipv4_netmask = 24
      }

      ipv4_gateway = "10.208.116.1"
      dns_server_list = ["8.8.8.8", "8.8.4.4"]
    }
  }
}
