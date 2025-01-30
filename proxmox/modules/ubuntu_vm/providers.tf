terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}

# provider "proxmox" {
#   pm_api_url = var.proxmox_api_url
#   pm_user = var.proxmox_username
#   pm_password = var.proxmox_password
# }