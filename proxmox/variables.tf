variable "host_node" {
  type = string
}

variable "node_size" {
  type = string
}

variable "proxmox_api_url" {
  type = string
  default = "https://storage.mawhaze.dev:8006/api2/json"
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_password" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "bios" {
  type = string
  default = "ovmf"
}

variable "instance_config" {
  type = map(object({
    small = object({
      target_node = string
      template_vm_name = string
      tags = string
      description = string
      vm_memory = number
      vm_cores = number
      vm_disk_size = string
      vm_storage = string
    }),
    large = object({
      target_node = string
      template_vm_name = string
      tags = string
      description = string
      vm_memory = number
      vm_cores = number
      vm_disk_size = string
      vm_storage = string
    })
  }))
  default = {
    "node01" = {
      large = {
        target_node = "node01"
        template_vm_name = "node01-ubuntu-2404-template"
        description = ""
        tags = "bootstrap"
        vm_memory = 8192
        vm_cores = 4
        vm_disk_size = "64G"
        vm_storage = "nvme02"
      },
      small = {
        target_node = "node01"
        template_vm_name = "node01-ubuntu-2404-template"
        description = ""
        tags = "bootstrap"
        vm_memory = 4096
        vm_cores = 2
        vm_disk_size = "32G"
        vm_storage = "nvme02"
      }
    },
    "storage" = {
      large = {
        target_node = "storage"
        template_vm_name = "storage-ubuntu-2404-template"
        description = ""
        tags = "bootstrap"
        vm_memory = 8192
        vm_cores = 4
        vm_disk_size = "64G"
        vm_storage = "nvme01"
      },
      small = {
        target_node = "storage"
        template_vm_name = "storage-ubuntu-2404-template"
        description = ""
        tags = "bootstrap"
        vm_memory = 2048
        vm_cores = 2
        vm_disk_size = "32G"
        vm_storage = "nvme01"
      }
    }
  }
}