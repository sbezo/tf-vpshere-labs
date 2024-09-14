# tf-vpshere-labs

This repo provides Terraform code for building Cisco Lab scenarios in vSphere environment

# Setup

1. Install terraform, clone repository, go to folder with desired scenario
2. Prepare Templates of required VMs in vSphere (CSR1000v,N9000V, Alpine..)
3. Setup vcenter credentials for Terraform as environment variables (or setup your own method of handling credentials)
4. Customize main.tf file to match your environment
VM template names, names & ID of new/existing VLANs, names of new VMs,folder name...
5. Build LAB
terraform init
terraform apply
6. Configure devices
7. Cleanup
terraform destroy

# Scenario 1
folder: S1-4_routers_in_a_row

<img width="753" alt="image" src="https://github.com/user-attachments/assets/ead7db45-7615-4ceb-aa04-2f43609c79fb">


# Scenario 2
folder: S2-DC_2S_3L

<img width="724" alt="image" src="https://github.com/user-attachments/assets/067c4afe-9fd1-4555-8999-3f59695b6633">

