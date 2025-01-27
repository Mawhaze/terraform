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
  host_node = "storage"
  node_size = "small"
  vm_name = "tailscale01"
  description = "tailscale subnet router"
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  tags = "tailscale,docker"
}

module "dockerhost" {
  source = "./modules/ubuntu_vm"
  # Variables
  host_node = "storage"
  node_size = "media_server"
  vm_name = "dockerhost01"
  description = "docker host, media server"
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  tags = "docker,media"
}

module "gamehost" {
  source = "./modules/ubuntu_vm"
  # Variables
  host_node = "storage"
  node_size = "media_server"
  vm_name = "gamehost01"
  description = "game host"
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  tags = "docker,game_server"
  
}

# module "testk8s01" {
#   source = "./modules/ubuntu_vm"
#   # Variables
#   host_node = "node01"
#   node_size = "small"
#   vm_name = "testk8s01"
#   description = "temp k8s controller node for testing"
#   proxmox_username = var.proxmox_username
#   proxmox_password = var.proxmox_password
#   tags = "k8s,k8s_controller"
# }

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