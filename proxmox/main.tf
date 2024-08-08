module "test_vm01" {
  source = "./modules/ubuntu_vm"

  # Variables
  host_node = "node01"
  node_size = "small"
  vm_name = "test-vm01"
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
}

module "test_vm02" {
  source = "./modules/ubuntu_vm"

  # Variables
  host_node = "storage"
  node_size = "large"
  vm_name = "test-vm02"
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
}