![image](https://bootcamp.rhinops.io/images/ansible.gif)
## Ansible Project

# Introduction
This repository utilizes technologies such as Terraform and Ansible , Below is the overview of what was used and how.


# Project Overview
This repository configures 3 Ubuntu 20 linux machines in a scale-set , using my azure subscription and my terraform plan files in a staging and production environments.
This repository also configures a Windows VM using the same methods listed above. 
Ansible playbooks are displayed in this repository , minus sensitive data.

# Environments
![image text](https://bootcamp.rhinops.io/images/week-6-envs.png)
# Goals
Use Terraform to provision the infrastructure , 
Use Ansible to deploy the NodeWeightTracker application , 
Create two environments: Staging and Production using Terraform. ,
Both environments must be identical except for the size of the vms (production ones must be larger) , 
In this project using a Managed Postgresql service is required.

# Expected Result
Three environments provisioned by Terraform **AND** The Weight Tracker Application deployed using Ansible.

