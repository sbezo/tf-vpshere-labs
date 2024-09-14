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

data "vsphere_virtual_machine" "N9300V" {
  name          = "SB-N9300V-Template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

#####################################################################################

### Links ###

# Create a new distributed port group - Link-A
resource "vsphere_distributed_port_group" "LINK-A" {
  name               = "VC-DPG-VLAN1160-LINK-A"
  vlan_id            = 1160
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
  allow_forged_transmits = true
  allow_mac_changes = true
  allow_promiscuous = true
  security_policy_override_allowed = true
  active_uplinks = ["VC-Uplink 1"]
  standby_uplinks = ["VC-Uplink 2"]
}
# Create a new distributed port group - Link-B
resource "vsphere_distributed_port_group" "LINK-B" {
  name               = "VC-DPG-VLAN1161-LINK-B"
  vlan_id            = 1161
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
  allow_forged_transmits = true
  allow_mac_changes = true
  allow_promiscuous = true
  security_policy_override_allowed = true
}

# Create a new distributed port group - Link-C
resource "vsphere_distributed_port_group" "LINK-C" {
  name               = "VC-DPG-VLAN1162-LINK-C"
  vlan_id            = 1162
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
  allow_forged_transmits = true
  allow_mac_changes = true
  allow_promiscuous = true
  security_policy_override_allowed = true
}

# Create a new distributed port group - Link-D
resource "vsphere_distributed_port_group" "LINK-D" {
  name               = "VC-DPG-VLAN1160-LINK-D"
  vlan_id            = 1163
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
  allow_forged_transmits = true
  allow_mac_changes = true
  allow_promiscuous = true
  security_policy_override_allowed = true
}

# Create a new distributed port group - Link-E
resource "vsphere_distributed_port_group" "LINK-E" {
  name               = "VC-DPG-VLAN1161-LINK-E"
  vlan_id            = 1164
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
  allow_forged_transmits = true
  allow_mac_changes = true
  allow_promiscuous = true
  security_policy_override_allowed = true
}

# Create a new distributed port group - Link-F
resource "vsphere_distributed_port_group" "LINK-F" {
  name               = "VC-DPG-VLAN1162-LINK-F"
  vlan_id            = 1165
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
  allow_forged_transmits = true
  allow_mac_changes = true
  allow_promiscuous = true
  security_policy_override_allowed = true
}

### Nexuses ###

# create Spine S1
resource "vsphere_virtual_machine" "S1" {
 name             = "SB-N9300V-S1"
 resource_pool_id = data.vsphere_resource_pool.pool.id
 datastore_id     = data.vsphere_datastore.datastore.id
 num_cpus = 4
 memory   = 10240
 guest_id = data.vsphere_virtual_machine.N9300V.guest_id
 folder = "USER_VMs/SB"
 wait_for_guest_net_timeout = 0
 firmware = "efi"

 network_interface {
   network_id   = data.vsphere_network.MNG.id
   adapter_type = "e1000"
 }
 network_interface {
   network_id   = vsphere_distributed_port_group.LINK-A.id
   adapter_type = "e1000"
 }
 network_interface {
  network_id   = vsphere_distributed_port_group.LINK-B.id
  adapter_type = "e1000"
}
 network_interface {
  network_id   = vsphere_distributed_port_group.LINK-C.id
  adapter_type = "e1000"
}

 # I had to create small secondary disk and then delete it through provision script, because N9300V won't boot from clonned sata disk - from Template
 # and vSphere provider somehow doesn't allow VM creation without disk
 disk {
   label = "secondary-disk"
   size             = 1
   thin_provisioned = true
 }

 clone {
   template_uuid = data.vsphere_virtual_machine.N9300V.id
 }

 # following script calls powershell file with powercli commands to delete created secondary small disk
 provisioner "local-exec" {
 command = "pwsh -File ./delete_disk.ps1 -vc $TF_VAR_vc_server -user $TF_VAR_vc_user -password $TF_VAR_vc_password -vm_name ${self.name}"
 }
}

# create Spine S2
resource "vsphere_virtual_machine" "S2" {
 name             = "SB-N9300V-S2"
 resource_pool_id = data.vsphere_resource_pool.pool.id
 datastore_id     = data.vsphere_datastore.datastore.id
 num_cpus = 4
 memory   = 10240
 guest_id = data.vsphere_virtual_machine.N9300V.guest_id
 folder = "USER_VMs/SB"
 wait_for_guest_net_timeout = 0
 firmware = "efi"

 network_interface {
   network_id   = data.vsphere_network.MNG.id
   adapter_type = "e1000"
 }
 network_interface {
   network_id   = vsphere_distributed_port_group.LINK-D.id
   adapter_type = "e1000"
 }
  network_interface {
   network_id   = vsphere_distributed_port_group.LINK-E.id
   adapter_type = "e1000"
 }
  network_interface {
   network_id   = vsphere_distributed_port_group.LINK-F.id
   adapter_type = "e1000"
 }

 # I had to create small secondary disk and then delete it through provision script, because N9300V won't boot from clonned sata disk - from Template
 # and vSphere provider somehow doesn't allow VM creation without disk
 disk {
   label = "secondary-disk"
   size             = 1
   thin_provisioned = true
 }

 clone {
   template_uuid = data.vsphere_virtual_machine.N9300V.id
 }

 # following script calls powershell file with powercli commands to delete created secondary small disk
 provisioner "local-exec" {
 command = "pwsh -File ./delete_disk.ps1 -vc $TF_VAR_vc_server -user $TF_VAR_vc_user -password $TF_VAR_vc_password -vm_name ${self.name}"
 }
}

# create Leaf L1
resource "vsphere_virtual_machine" "L1" {
 name             = "SB-N9300V-L1"
 resource_pool_id = data.vsphere_resource_pool.pool.id
 datastore_id     = data.vsphere_datastore.datastore.id
 num_cpus = 4
 memory   = 10240
 guest_id = data.vsphere_virtual_machine.N9300V.guest_id
 folder = "USER_VMs/SB"
 wait_for_guest_net_timeout = 0
 firmware = "efi"

 network_interface {
   network_id   = data.vsphere_network.MNG.id
   adapter_type = "e1000"
 }
 network_interface {
   network_id   = vsphere_distributed_port_group.LINK-A.id
   adapter_type = "e1000"
 }
 network_interface {
  network_id   = vsphere_distributed_port_group.LINK-D.id
  adapter_type = "e1000"
}


 # I had to create small secondary disk and then delete it through provision script, because N9300V won't boot from clonned sata disk - from Template
 # and vSphere provider somehow doesn't allow VM creation without disk
 disk {
   label = "secondary-disk"
   size             = 1
   thin_provisioned = true
 }

 clone {
   template_uuid = data.vsphere_virtual_machine.N9300V.id
 }

 # following script calls powershell file with powercli commands to delete created secondary small disk
 provisioner "local-exec" {
 command = "pwsh -File ./delete_disk.ps1 -vc $TF_VAR_vc_server -user $TF_VAR_vc_user -password $TF_VAR_vc_password -vm_name ${self.name}"
 }
}


# create Leaf L2
resource "vsphere_virtual_machine" "L2" {
 name             = "SB-N9300V-L2"
 resource_pool_id = data.vsphere_resource_pool.pool.id
 datastore_id     = data.vsphere_datastore.datastore.id
 num_cpus = 4
 memory   = 10240
 guest_id = data.vsphere_virtual_machine.N9300V.guest_id
 folder = "USER_VMs/SB"
 wait_for_guest_net_timeout = 0
 firmware = "efi"

 network_interface {
   network_id   = data.vsphere_network.MNG.id
   adapter_type = "e1000"
 }
 network_interface {
   network_id   = vsphere_distributed_port_group.LINK-B.id
   adapter_type = "e1000"
 }
 network_interface {
  network_id   = vsphere_distributed_port_group.LINK-E.id
  adapter_type = "e1000"
}


 # I had to create small secondary disk and then delete it through provision script, because N9300V won't boot from clonned sata disk - from Template
 # and vSphere provider somehow doesn't allow VM creation without disk
 disk {
   label = "secondary-disk"
   size             = 1
   thin_provisioned = true
 }

 clone {
   template_uuid = data.vsphere_virtual_machine.N9300V.id
 }

 # following script calls powershell file with powercli commands to delete created secondary small disk
 provisioner "local-exec" {
 command = "pwsh -File ./delete_disk.ps1 -vc $TF_VAR_vc_server -user $TF_VAR_vc_user -password $TF_VAR_vc_password -vm_name ${self.name}"
 }
}

# create Leaf L3
resource "vsphere_virtual_machine" "L3" {
 name             = "SB-N9300V-L3"
 resource_pool_id = data.vsphere_resource_pool.pool.id
 datastore_id     = data.vsphere_datastore.datastore.id
 num_cpus = 4
 memory   = 10240
 guest_id = data.vsphere_virtual_machine.N9300V.guest_id
 folder = "USER_VMs/SB"
 wait_for_guest_net_timeout = 0
 firmware = "efi"

 network_interface {
   network_id   = data.vsphere_network.MNG.id
   adapter_type = "e1000"
 }
 network_interface {
   network_id   = vsphere_distributed_port_group.LINK-C.id
   adapter_type = "e1000"
 }
 network_interface {
  network_id   = vsphere_distributed_port_group.LINK-F.id
  adapter_type = "e1000"
}


 # I had to create small secondary disk and then delete it through provision script, because N9300V won't boot from clonned sata disk - from Template
 # and vSphere provider somehow doesn't allow VM creation without disk
 disk {
   label = "secondary-disk"
   size             = 1
   thin_provisioned = true
 }

 clone {
   template_uuid = data.vsphere_virtual_machine.N9300V.id
 }

 # following script calls powershell file with powercli commands to delete created secondary small disk
 provisioner "local-exec" {
 command = "pwsh -File ./delete_disk.ps1 -vc $TF_VAR_vc_server -user $TF_VAR_vc_user -password $TF_VAR_vc_password -vm_name ${self.name}"
 }
}



