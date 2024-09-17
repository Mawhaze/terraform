# Proxmox VM infrastructure

# Required resource example
# module "example_vm01" {
#   source = "./modules/ubuntu_vm"
#   # Variables
#   host_node = "example01"
#   node_size = "small"
#   vm_name = "examplevm01"
#   description = "example vm"
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
  description = "tailscale subnet router"
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  tags = "tailscale,docker"
}

module "testk8s01" {
  source = "./modules/ubuntu_vm"
  # Variables
  host_node = "node01"
  node_size = "small"
  vm_name = "testk8s01"
  description = "temp k8s controller node for testing"
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  tags = "k8s,k8s_controller"
}

# module "testk8s02" {
#   source = "./modules/ubuntu_vm"
#   # Variables
#   host_node = "node01"
#   node_size = "small"
#   vm_name = "testk8s02"
#   description = "temp k8s worker node for testing"
#   proxmox_username = var.proxmox_username
#   proxmox_password = var.proxmox_password
#   tags = "k8s,k8s_worker"
# }

# module "k8s02" {
#   source = "./modules/ubuntu_vm"
#   # Variables
#   host_node = "node01"
#   node_size = "large"
#   vm_name = "k8s02"
#   description = "k8s worker node"
#   proxmox_username = var.proxmox_username
#   proxmox_password = var.proxmox_password
#   tags = "k8s,k8s_worker"
# }