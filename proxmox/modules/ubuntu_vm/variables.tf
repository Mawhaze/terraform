# Proxmox Variables
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

# Static Variables
variable "bios" {
  type = string
  default = "ovmf"
}

variable "host_node" {
  type = string
  default = "node01"
}

variable "node_size" {
  type = string
  default = "small"
}

variable "vm_name" {
  type = string
  default = "ubuntu_2404_clone"
}

# Dynamic Variables
variable "description" {
  type = string
  default = ""
}

variable "tags" {
  type = string
  default = ""
}

variable "template_vm_name" {
  type = string
  default = ""
}

locals {
  dynamic_tags = "bootstrap,${var.vm_name},${var.tags}"
  dynamic_desc = "${var.description} | node: ${var.host_node}, size: ${var.node_size}"
  dynamic_template = "${var.host_node}-ubuntu-2404-template"
}

# VM Configuration
variable "instance_config" {
  type = map(object({
    small = object({
      vm_memory = number
      vm_cores = number
      vm_disk_size = string
      vm_storage = string
    }),
    large = object({
      vm_memory = number
      vm_cores = number
      vm_disk_size = string
      vm_storage = string
    }),
    media_server = object({
      vm_memory = number
      vm_cores = number
      vm_disk_size = string
      vm_storage = string
    })
  }))
  default = {
    "node01" = {
      large = {
        vm_memory = 8192
        vm_cores = 4
        vm_disk_size = "64G"
        vm_storage = "nvme02"
      },
      small = {
        vm_memory = 4096
        vm_cores = 2
        vm_disk_size = "32G"
        vm_storage = "nvme02"
      },
      media_server = {
        vm_memory = 16384
        vm_cores = 8
        vm_disk_size = "128G"
        vm_storage = "nvme02"
      }
    },
    "storage" = {
      large = {
        vm_memory = 8192
        vm_cores = 4
        vm_disk_size = "64G"
        vm_storage = "nvme01"
      },
      small = {
        vm_memory = 2048
        vm_cores = 2
        vm_disk_size = "32G"
        vm_storage = "nvme01"
      },
      media_server = {
        vm_memory = 32768
        vm_cores = 8
        vm_disk_size = "128G"
        vm_storage = "nvme01"
      }
    }
  }
}