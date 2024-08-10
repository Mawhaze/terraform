# Proxmox/Terraform Readme

## Current Functionality

- Deploying new VMs to Proxmox
  - Due to how cloning works in proxmox, new VMs have to be deployed one at a time.

## To Do

- Add validation to the jenkins job before applying the change and deplying new infra
- Add nightly job to check for any changes outside the repo