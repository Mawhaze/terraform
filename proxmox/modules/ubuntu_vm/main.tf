resource "proxmox_vm_qemu" "proxmox_vm" {
  name = var.vm_name
  target_node = var.host_node
  tags = var.tags != "" ? var.tags : local.dynamic_tags
  desc= var.description != "" ? var.description : local.dynamic_desc
  clone = var.template_vm_name != "" ? var.template_vm_name : local.dynamic_template
  bios = var.bios
  full_clone = true
  agent = 1
  memory = var.instance_config[var.host_node][var.node_size].vm_memory
  cores = var.instance_config[var.host_node][var.node_size].vm_cores
  scsihw = "virtio-scsi-single"
  ipconfig0 = "ip=dhcp"
  searchdomain = "mawhaze.dev"
  disks {
    scsi {
      scsi0 {
        disk {
          size = var.instance_config[var.host_node][var.node_size].vm_disk_size
          storage = var.instance_config[var.host_node][var.node_size].vm_storage
          emulatessd = true
          iothread = true
        }
      }  
    }
  }
  lifecycle {
    ignore_changes = [ 
      tags
     ]
  }
}