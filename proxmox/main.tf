# Proxmox VM infrastructure

# Required resource example
# module "example_vm01" {
#   source = "./modules/ubuntu_vm"
#   providers = {
#     proxmox = proxmox
#   }
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

module "labk8s01" {
  source = "./modules/ubuntu_vm"
  providers = {
    proxmox = proxmox
  }
  # Variables
  host_node = "storage"
  node_size = "small"
  vm_name = "labk8s01"
  description = "k8s controller node"
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  tags = "k8s,k8s_controller"
}

module "labk8s02" {
  source = "./modules/ubuntu_vm"
  providers = {
    proxmox = proxmox
  }
  # Variables
  host_node = "storage"
  node_size = "small"
  vm_name = "labk8s02"
  description = "k8s worker node"
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  tags = "k8s,k8s_worker"
}

module "labk8s03" {
  source = "./modules/ubuntu_vm"
  providers = {
    proxmox = proxmox
  }
  # Variables
  host_node = "cuda"
  node_size = "gpu_node"
  vm_name = "labk8s03"
  description = "k8s worker node. gpu passed though"
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  tags = "k8s,k8s_worker,gpu_node"
}

module "enderbot01" {
  source = "./modules/ubuntu_vm"
  providers = {
    proxmox = proxmox
  }
  # Variables
  host_node = "storage"
  node_size = "large"
  vm_name = "enderbot01"
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  tags = "docker,ender"
}