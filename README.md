## What is this repository for:   

- This Repo provides terraform `main.tf` and related `variables.tf` files for different scenarios.   
- All scenarios are suppose to run in VMware vSphere environment.    
- Each scenario is in its own "self-explanatory' folder.   
- Some VMs need additional manual setup. Something can be address directly by terraform in `main.tf` file, 
but for LAB purposes is easier to run some bootstrap configs inside VM. Such 'manual' configurations are placed in `Bootstraps` folder.   


## Motivation:  

This repo allows to quickly spin up selected LAB scenario including related VMs and networking in Infrastructure as a Code fashion.  

## Prerequisites:   

- VMware vSphere environment with vCenter
- LABs are designed for environment with VDS implemented (when use Standard switch, some change are required)  
- terraform   
- Templates for each VM - terraform creates new VMs from Templates in all scenarios

## How to use this 

First you need to setup variables and credentials according to your environment. Here is example:

```
export TF_VAR_vc_user=username@vsphere.local
export TF_VAR_vc_password=your_password
export TF_VAR_vc_server=fqdn.of.your.vc
export TF_VAR_vc_dc=name_of_DC
export TF_VAR_vc_dvs=name_of_VDS
export TF_VAR_vc_pool=name_of_resource_pool
export TF_VAR_vc_datastore=name_of_datastorage
export TF_VAR_vc_mng=name_of_management_vlan
```

Then you need to go to selected scenario = folder.   
And run:
```
terraform init
terraform plan
terraform apply
```