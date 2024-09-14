# TF_vpshere_Labs

This repo provides Terraform code for building Cisco Lab scenarios in vSphere environment

# Setup

1. Install terraform, clone repository, go to desired folder
2. Prepare Templates of required VMs in vSphere (CSR1000v,N9000V, Alpine..)
3. Setup vcenter credentials for Terraform as environment variables - terraform.txt
4. Customize main.tf file base on your environment
VM template names, names & ID of new/existing VLANs, names of new VMs,folder name...
5. Build LAB
terraform init
terraform apply
6. Configure devices
7. Cleanup
terraform destroy

# Scenario 1
folder: S1-4_routers_in_a_row

<img width="748" alt="image" src="https://github.com/user-attachments/assets/21789e16-b013-457f-b07c-62e79edd3f49">

# Scenario 2
folder: S2-DC_2s_3L

<img width="730" alt="image" src="https://github.com/user-attachments/assets/cb0ba816-74d8-40c0-9b97-8eb41383de0f">
