# Proxmox VM infrastructure
# required resource example
# module "example_vm01" {
#   source = "./modules/ubuntu_vm"
#   # Variables
#   host_node = "example01"
#   node_size = "small"
#   vm_name = "examplevm01"
#   proxmox_username = var.proxmox_username
#   proxmox_password = var.proxmox_password
#   tags = "exmple,tags"
# }

module "tailscale01" {
  source = "./modules/ubuntu_vm"
  # Variables
  host_node = "node01"
  node_size = "small"
  vm_name = "tailscale01"
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  tags = "tailscale,docker"
}
